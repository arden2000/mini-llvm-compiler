import sys
import TypeCheck
from settings import getReg, getStackFlag
class Type:
    def __init__(self, type_, typeStr):
        self.type = type_
        self.typeStr = typeStr

    def getLLVMType(self):
        if self.type == Number:
            return 'i32'
        elif self.type == Bool:
            return 'i1' # i32
        elif self.type == Void:
            return 'void'
        elif self.type == Struct:
            return f'%struct.{self.typeStr}*'

class Struct:
    def __init__(self, struct):
        self.id = struct['id']
        self.fields = parseDeclarations(struct['fields'])
        self.lineNum = struct['line']

    def getStructSize(self):
        return len(self.fields) * 4

    def translateToLLVM(self):
        types = ''
        for field in self.fields:
            types += field.type.getLLVMType() + ', '
        return f'%struct.{self.id} = type {{{types[:-2]}}}\n'
    
    def getElementPtr(self, reg, id_):
        count = 0
        for field in self.fields:
            if field.id.id == id_:
                return f'getelementptr %struct.{self.id}, %struct.{self.id}* {reg}, i32 0, i32 {count}'
            count += 1

    def getFieldType(self, id_):
        for field in self.fields:
            if field.id.id == id_:
                return field.type # type class

class Declaration:
    def __init__(self, decl):
        self.id = ID(decl['id'])
        self.type = getTypeFromString(decl['type'])
        self.lineNum = decl['line']
    
    def translateToGlobalLLVM(self):
        llvm = f'@{self.id.id} = global {self.type.getLLVMType()} {"null" if self.type.type == Struct else 0}\n'
        return llvm

    def translateToLLVM(self, block=None):
        if not getStackFlag():
            reg = getReg()
            block.varMap[self.id.id] = reg
            if (self.type.type == Struct):
                return f'\t{reg} = bitcast i32** @.null to {self.type.getLLVMType()}\n'
            else:
                return f'\t{reg} = add {self.type.getLLVMType()} 0, 0\n'

        return f'\t%{self.id.id} = alloca {self.type.getLLVMType()}\n'

class Function: 
    def __init__(self, stmt):
        self.id = stmt['id']
        self.lineNum = stmt['line']
        self.retType = getTypeFromString(stmt['return_type'])
        self.params = parseDeclarations(stmt['parameters'])
        self.decls = parseDeclarations(stmt['declarations'])
        self.body = self.parseFuncBody(stmt['body'])

    def parseFuncBody(self, body_list):
        body = Block({'list': []})
        body.stmts = parseBlock(body_list)
        return body

    def getParamsLLVM(self, block=None):
        if not getStackFlag():
            return self.getParamsSSA(block)
        paramsLLVM = ''
        for param in self.params:
            paramsLLVM += f'{param.type.getLLVMType()} %{param.id.id}1, '
        return paramsLLVM[:-2]
    
    def getParamsSSA(self, block):
        paramsLLVM = ''
        for param in self.params:
            block.varMap[f'{param.id.id}'] = f'%{param.id.id}'
            paramsLLVM += f'{param.type.getLLVMType()} %{param.id.id}, '
        return paramsLLVM[:-2]

    def translateToLLVM(self, block=None):
        return f'define {self.retType.getLLVMType()} @{self.id}({self.getParamsLLVM(block)}) {{\n' # have to close } at the end of CFG

class Assignment:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.target = self.parseTarget(stmt['target'])
        self.source = parseExpression(stmt['source'])

    def parseTarget(self, target):
        og_target = target
        while (target.get('left')):
            target['exp'] = 'dot'
            target = target['left']
        target['exp'] = 'id'
        return parseExpression(og_target)

    def translateToSSA(self, reg, block):
        sourceLLVM = ""
        if not isinstance(self.source, ID) and not isinstance(self.source, Null):
            sourceLLVM = self.source.translateToLLVM(reg, block)
        
        if isinstance(self.target, ID):
            storeLLVM = ''
            if not self.target.isGlobal and isinstance(self.source, ID) and not self.source.isGlobal:
                block.varMap[self.target.id] = self.source.getIdLLVM(block)
                return ''
            elif self.target.isGlobal and isinstance(self.source, ID) and not self.source.isGlobal:
                return f'\tstore {self.target.type.getLLVMType()} {self.source.getIdLLVM(block)}, {self.target.type.getLLVMType()}* {self.target.getIdLLVM(block)}\n'
            elif not self.target.isGlobal and isinstance(self.source, ID) and self.source.isGlobal:
                block.varMap[self.target.id] = reg
                return self.source.translateToLLVM(reg, block)
            elif self.target.isGlobal and isinstance(self.source, ID) and self.source.isGlobal:
                loadLLVM = self.source.translateToLLVM(reg, block)
                storeLLVM = f'\tstore {self.target.type.getLLVMType()} {reg}, {self.target.type.getLLVMType()}* {self.target.getIdLLVM(block)}\n'
                return loadLLVM + storeLLVM
            elif self.target.isGlobal and isinstance(self.source, Read):
                return self.source.translateToLLVM(self.target.getIdLLVM(block))
            elif self.target.isGlobal:
                if self.target.type.type == Struct and isinstance(self.source, Null):
                    bitcastLLVM = f'\t{reg} = bitcast i32** @.null to {self.target.type.getLLVMType()}\n'
                    assignLLVM = f'\tstore {self.target.type.getLLVMType()} {reg}, {self.target.type.getLLVMType()}* {self.target.getIdLLVM(block)}\n' 
                    return bitcastLLVM + assignLLVM
                else:
                    return sourceLLVM + f'\tstore {self.target.type.getLLVMType()} {reg}, {self.target.type.getLLVMType()}* {self.target.getIdLLVM(block)}\n' 
            elif isinstance(self.source, Read):
                block.varMap[self.target.id] = reg
                targetLLVM = f'\t{reg} = load i32, i32* @.read\n'
                return self.source.translateToLLVM('@.read') + targetLLVM
            elif isinstance(self.source, Null):
                block.varMap[self.target.id] = 'null'
                return sourceLLVM
            else:
                block.varMap[self.target.id] = reg
                return sourceLLVM
        elif isinstance(self.target, Selector):
            assignLLVM = ''
            targetReg = getReg()
            #if not isinstance(self.source, ID):
            targetLLVM = self.target.translateToTargetLLVM(targetReg, block) 
            if isinstance(self.source, Read):
                return targetLLVM + self.source.translateToLLVM(targetReg, block)
            elif isinstance(self.source, ID):
                if self.source.isGlobal:
                    assignLLVM = f'\t{reg} = load {self.source.type.getLLVMType()}, {self.source.type.getLLVMType()}* {self.source.getIdLLVM(block)}\n'
                    assignLLVM += f'\tstore {self.target.type.getLLVMType()} {reg}, {self.target.type.getLLVMType()}* {targetReg}\n'
                else:
                    assignLLVM = f'\tstore {self.target.type.getLLVMType()} {self.source.getIdLLVM(block)}, {self.target.type.getLLVMType()}* {targetReg}\n'
            elif isinstance(self.source, Null):
                assignLLVM = f'\tstore {self.target.type.getLLVMType()} null, {self.target.type.getLLVMType()}* {targetReg}\n'      
            else:
                assignLLVM = f'\tstore {self.target.type.getLLVMType()} {reg}, {self.target.type.getLLVMType()}* {targetReg}\n'      
            return sourceLLVM + targetLLVM + assignLLVM
    
    def translateToLLVM(self, reg, block=None):
        if not getStackFlag():
            return self.translateToSSA(reg, block)
        sourceLLVM = self.source.translateToLLVM(reg, block)
        targetLLVM = ''
        assignLLVM = ''

        if isinstance(self.target, ID):
            if isinstance(self.source, Read):
                return targetLLVM + self.source.translateToLLVM(self.target.getIdLLVM())
            else:
                assignLLVM = f'\tstore {self.target.type.getLLVMType()} {reg}, {self.target.type.getLLVMType()}* {self.target.getIdLLVM()}\n'
        elif isinstance(self.target, Selector):
            reg1 = getReg()
            targetLLVM = self.target.translateToTargetLLVM(reg1) 
            if isinstance(self.source, Read):
                return targetLLVM + self.source.translateToLLVM(reg1)
            else:
                assignLLVM = f'\tstore i32 {reg}, i32* {reg1}\n'      
        return sourceLLVM + targetLLVM + assignLLVM
         
class Print:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.exp = parseExpression(stmt['exp'])
        self.endl = stmt['endl']

    def translateToLLVM(self, reg, block=None): 
        printLLVM = ""
        if isinstance(self.exp, ID):
            if self.exp.isGlobal:
                printLLVM = f'\t{reg} = load {self.exp.type.getLLVMType()}, {self.exp.type.getLLVMType()}* {self.exp.getIdLLVM(block)}\n'
            else:
                reg = self.exp.getIdLLVM(block)
        else:
            printLLVM = self.exp.translateToLLVM(reg, block)
        callPrint = f'\tcall i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.d.space, i32 0, i32 0), i32 {reg})\n'
        if self.endl:
            callPrint = f'\tcall i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.nl, i32 0, i32 0), i32 {reg})\n'
        return printLLVM + callPrint

class Block:
    def __init__(self, stmt):
        self.stmts = parseBlock(stmt['list'])

class Conditional:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.guard = parseExpression(stmt['guard'])
        self.then = Block(stmt['then'])
        self.else_ = Block(stmt['else']) if stmt.get('else') else None

class UnconditionalBranch:
    def __init__(self, branchType):
        self.branchType = branchType
        self.parentLabel = None

    def translateToLLVM(self, guardLabel=None):
        if self.branchType == 'while':
            guardLabel = self.parentLabel
        elif self.branchType == 'return':
            guardLabel = 'END'
        return f'\tbr label %{guardLabel}\n'
   
class Guard:
    def __init__(self, guard):
        self.guard = guard

    def translateToLLVM(self, trueLabel, falseLabel, reg, block=None):
        guardLLVM = ''
        if isinstance(self.guard, ID):
            if self.guard.isGlobal:
                guardLLVM += f'\t{reg} = load {self.guard.type.getLLVMType()}, {self.guard.type.getLLVMType()}* {self.guard.getIdLLVM(block)}\n'
            else:
                reg = self.guard.getIdLLVM(block)
        # elif isinstance(self.guard, Bool):
        #     truncSource = 1 if self.guard.value else 0
        else:
            guardLLVM = self.guard.translateToLLVM(reg, block)
            #truncSource = reg

        truncLLVM = ''
        # if isinstance(self.guard, Bool) or isinstance(self.guard, ID) or isinstance(self.guard, Selector) or isinstance(self.guard, Invocation):
        #     truncReg = getReg()
        #     truncLLVM = f'\t{truncReg} = trunc i32 {truncSource} to i1\n'
        #     reg = truncReg
        branchLLVM = f'\tbr i1 {reg}, label %{trueLabel}, label %{falseLabel}\n'
        return guardLLVM + truncLLVM + branchLLVM

class Loop:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.guard = parseExpression(stmt['guard'])
        self.body = Block(stmt['body'])

class Return:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.retExp = parseExpression(stmt['exp']) if stmt.get('exp') else None
        self.retType = None

    def translateToSSA(self, reg, block=None):
        llvm = ''
        if self.retExp:
            if isinstance(self.retExp, ID):
                block.varMap['return'] = self.retExp.getIdLLVM(block)
            elif isinstance(self.retExp, Null):
                block.varMap['return'] = 'null'
            else: 
                llvm = self.retExp.translateToLLVM(reg, block) # saves return val to reg
                block.varMap['return'] = reg
        llvm += '\tbr label %END\n' # branches to the return block
        return llvm

    def translateToLLVM(self, reg, block=None):
        if not getStackFlag():
            return self.translateToSSA(reg, block)
        llvm = ''
        if self.retExp:
            llvm = self.retExp.translateToLLVM(reg, block) # saves return val to reg
            returnStore = f'\tstore {self.retType.getLLVMType()} {reg}, {self.retType.getLLVMType()}* %return\n'
            llvm += returnStore
        llvm += '\tbr label %END\n' # branches to the return block
        return llvm

class Invocation:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.id = stmt['id']
        self.args = self.parseArgs(stmt['args'])
        self.retType = None
        self.argTypes = []
    
    def parseArgs(self, args):
        arguments = []
        for arg in args:
            arguments.append(parseExpression(arg))
        return arguments

    def translateToLLVM(self, reg, block=None):
        evalArgsLLVM, argsLLVM = self.getArgsLLVM(block)
        callLLVM = f'\t{f"{reg} = " if self.retType.type != Void else ""}call {self.retType.getLLVMType()} @{self.id}({argsLLVM})\n'
        return evalArgsLLVM + callLLVM
        
    def getArgsLLVM(self, block=None):
        evalArgsLLVM = ''
        argsLLVM = ''
        for i in range(len(self.args)):
            reg = getReg()
            if isinstance(self.args[i], Null):
                argsLLVM += f'{self.argTypes[i].getLLVMType()} null, ' 
            elif isinstance(self.args[i], Number):
                argsLLVM += f'{self.argTypes[i].getLLVMType()} {self.args[i].value}, ' 
            elif isinstance(self.args[i], Bool):
                argsLLVM += f'{self.argTypes[i].getLLVMType()} {1 if self.args[i].value else 0}, ' 
            elif isinstance(self.args[i], ID):
                if self.args[i].isGlobal:
                    reg = getReg()
                    evalArgsLLVM += f'\t{reg} = load {self.args[i].type.getLLVMType()}, {self.args[i].type.getLLVMType()}* {self.args[i].getIdLLVM(block)}\n'
                    argsLLVM += f'{self.argTypes[i].getLLVMType()} {reg}, ' 
                else:
                    argsLLVM += f'{self.argTypes[i].getLLVMType()} {self.args[i].getIdLLVM(block)}, ' 
            else:
                evalArgsLLVM += self.args[i].translateToLLVM(reg, block)
                argsLLVM += f'{self.argTypes[i].getLLVMType()} {reg}, ' 
        argsLLVM = argsLLVM[:-2]
        return evalArgsLLVM, argsLLVM

class Delete:
    def __init__(self, stmt):
        self.lineNum = stmt['line']
        self.delExp = parseExpression(stmt['exp'])
        self.type = None

    def translateToLLVM(self, reg, block=None):
        if not getStackFlag() and isinstance(self.delExp, ID):
            reg = self.delExp.getIdLLVM(block)
            delExpLLVM = ''
        else:
            delExpLLVM = self.delExp.translateToLLVM(reg, block)
        reg1 = getReg()
        bitcastLLVM = getBitcastLLVM(reg1, reg, self.type.getLLVMType(), 'i8*')
        return delExpLLVM + bitcastLLVM + f'\tcall void @free(i8* {reg1})\n'

class Binop:
    def __init__(self, exp):
        self.lineNum = exp['line']
        self.op = exp['operator']
        self.left = parseExpression(exp['lft'])
        self.right = parseExpression(exp['rht'])
        self.leftType = None
        self.rightType = None
    
    def translateToLLVM(self, reg, block=None):
        left = ""
        right = ""
        bitcast = ""

        if isinstance(self.left, ID):
            if self.left.isGlobal:
                reg1 = getReg()
                left = f'\t{reg1} = load {self.left.type.getLLVMType()}, {self.left.type.getLLVMType()}* {self.left.getIdLLVM(block)}\n'
            else:
                reg1 = self.left.getIdLLVM(block)
        elif isinstance(self.left, Null):
            reg1 = 'null'
            # reg1 = getReg()
            # left = self.left.translateToLLVM(reg1, self.right.type)
        else:
            reg1 = getReg()
            left = self.left.translateToLLVM(reg1, block)
        
        if isinstance(self.right, ID):
            if self.right.isGlobal:
                reg2 = getReg()
                right = f'\t{reg2} = load {self.right.type.getLLVMType()}, {self.right.type.getLLVMType()}* {self.right.getIdLLVM(block)}\n'
            else:
                reg2 = self.right.getIdLLVM(block)
        elif isinstance(self.right, Null):
            reg2 = 'null'
            # reg2 = getReg()
            # right = self.right.translateToLLVM(reg2, self.left.type)
        else:
            reg2 = getReg()
            right = self.right.translateToLLVM(reg2, block)
            
        opType = 'i32'
        if self.op == '&&' or self.op == '||':
            opType = 'i1'
        if self.leftType != Null and self.leftType.type == Struct:
            opType = 'i32*'
            saveReg = getReg()
            left += getBitcastLLVM(saveReg, reg1, self.leftType.getLLVMType(), 'i32*')
            reg1 = saveReg
        if self.rightType != Null and self.rightType.type == Struct:
            opType = 'i32*'
            saveReg = getReg()
            right += getBitcastLLVM(saveReg, reg2, self.rightType.getLLVMType(), 'i32*')
            reg2 = saveReg
        final = f'\t{reg} = {self.getOpLLVM()} {opType} {reg1}, {reg2}\n'
        return left + right + final

    def getOpLLVM(self):
        if self.op == '+':
            return 'add'
        elif self.op == '-':
            return 'sub'
        elif self.op == '*':
            return 'mul'
        elif self.op == '/':
            return 'sdiv'
        elif self.op == '&&':
            return 'and'
        elif self.op == '||':
            return 'or'
        elif self.op == '<':
            return 'icmp slt'
        elif self.op == '>':
            return 'icmp sgt'
        elif self.op == '<=':
            return 'icmp sle'
        elif self.op == '>=':
            return 'icmp sge'
        elif self.op == '==':
            return 'icmp eq'
        elif self.op == '!=':
            return 'icmp ne'
        else:
            return 'huhhhhhhh'

class Unop:
    def __init__(self, exp):
        self.lineNum = exp['line']
        self.op = exp['operator']
        self.lineNum = exp['line']
        self.operand = parseExpression(exp['operand'])

    def translateToLLVM(self, targetReg, block=None):
        operandLLVM = ''
        if isinstance(self.operand, ID):
            sourceReg = self.operand.getIdLLVM(block) 
        else:
            sourceReg = getReg()
            operandLLVM = self.operand.translateToLLVM(sourceReg, block)
        opLLVM = self.getOpLLVM(sourceReg, targetReg)
        return operandLLVM + opLLVM

    def getOpLLVM(self, sourceReg, targetReg):
        if self.op == '-':
            return f'\t{targetReg} = mul i32 -1, {sourceReg}\n'
        elif self.op == '!':
            return f'\t{targetReg} = xor i32 1, {sourceReg}\n'

class Selector:
    def __init__(self, exp):
        self.lineNum = exp['line']
        self.left = parseExpression(exp['left'])
        self.id = exp['id']
        self.type = None
        
    def selectorHelperLLVM(self, reg, selector, outerMost, block=None):
        reg1 = getReg()
        if isinstance(selector.left, ID):
            struct = getStructFromName(selector.left.type.typeStr)
            retType = struct.getFieldType(selector.id)
            if not getStackFlag():
                l1 = f'\t{reg1} = {struct.getElementPtr(selector.left.getIdLLVM(block), selector.id)}\n'
                l2 = f'\t{reg} = load {retType.getLLVMType()}, {retType.getLLVMType()}* {reg1}\n'
                if outerMost:
                    l1 = f'\t{reg} = {struct.getElementPtr(selector.left.getIdLLVM(block), selector.id)}\n'
                    l2 = ''
                if selector.left.isGlobal:
                    l1 = f'\t{reg1} = load {selector.left.type.getLLVMType()}, {selector.left.type.getLLVMType()}* {selector.left.getIdLLVM(block)}\n'
                    l2 = f'\t{reg} = {struct.getElementPtr(reg1, selector.id)}\n'
            else:
                l1 = f'\t{reg1} = load {selector.left.type.getLLVMType()}, {selector.left.type.getLLVMType()}* {selector.left.getIdLLVM(block)}\n'
                l2 = f'\t{reg} = {struct.getElementPtr(reg1, selector.id)}\n'
            retString = l1 + l2
            retType = struct.getFieldType(selector.id)
            return retString, retType, reg
        elif isinstance(selector.left, Invocation):
            struct = getStructFromName(selector.left.retType.typeStr)
            invocationLLVM = selector.left.translateToLLVM(reg1)
            l1 = f'\t{reg} = {struct.getElementPtr(reg1, selector.id)}\n'
            retString = invocationLLVM + l1
            retType = struct.getFieldType(selector.id)
            return retString, retType, reg
        
        llvm, leftType, leftStructReg = self.selectorHelperLLVM(getReg(), selector.left, False, block)
        struct = getStructFromName(leftType.typeStr)

        retType = struct.getFieldType(selector.id)
        if not getStackFlag():
            reg1 = getReg()
            if outerMost:
                l1 = f'\t{reg} = {struct.getElementPtr(leftStructReg, selector.id)}\n'
                l2 = ''
            else:
                l1 = f'\t{reg1} = {struct.getElementPtr(leftStructReg, selector.id)}\n'
                l2 = f'\t{reg} = load {retType.getLLVMType()}, {retType.getLLVMType()}* {reg1}\n'
        else:
            l1 = f'\t{reg1} = load {leftType.getLLVMType()}, {leftType.getLLVMType()}* {leftStructReg}\n'
            l2 = f'\t{reg} = {struct.getElementPtr(reg1, selector.id)}\n'
        retString = llvm + l1 + l2
        return retString, retType, reg
     
    def translateToTargetLLVM(self, destReg, block=None): # target of assignment
        reg1 = getReg()
        if not getStackFlag():
            llvm, retType, leftStructReg = self.selectorHelperLLVM(destReg, self, True, block)
        else:
            llvm, retType, leftStructReg = self.selectorHelperLLVM(reg1, self, True, block)
            llvm += f'\t{destReg} = load {retType.getLLVMType()}, {retType.getLLVMType()}* {reg1}\n'
        return llvm

    def translateToLLVM(self, destReg, block=None):
        if not getStackFlag():
            reg = getReg()
            llvm, retType, leftStructReg = self.selectorHelperLLVM(reg, self, True, block)
            llvm += f'\t{destReg} = load {retType.getLLVMType()}, {retType.getLLVMType()}* {reg}\n'
        else:
            llvm, retType, leftStructReg = self.selectorHelperLLVM(destReg, self, True, block)
        return llvm

class Number:
    def __init__(self, exp):
        self.lineNum = exp['line']
        self.value = exp['value']
    
    def translateToLLVM(self, reg, block=None):
        return f'\t{reg} = add i32 0, {self.value}\n'

class ID:
    def __init__(self, id_):
        self.id = id_
        self.type = None
        self.isGlobal = False

    def getIdLLVM(self, block=None):
        if self.isGlobal:
            return f'@{self.id}'
        if not getStackFlag():
            return self.getIdReg(block)
        return f'%{self.id}'
    
    def getIdReg(self, block):
        reg = block.varMap.get(self.id)
        if reg:
            return reg
        else:
            return self.getIdReg(block.preds[0])

    def translateToLLVM(self, reg, block=None):
        return f'\t{reg} = load {self.type.getLLVMType()}, {self.type.getLLVMType()}* {self.getIdLLVM(block)}\n'

class New:
    def __init__(self, exp):
        self.lineNum = exp['line']
        self.id = exp['id']
        self.type = None

    def translateToLLVM(self, reg, block=None):
        reg1 = getReg()
        mallocLLVM = f'\t{reg1} = call i8* @malloc(i32 {getStructFromName(self.id).getStructSize()})\n'
        bitcastLLVM = getBitcastLLVM(reg, reg1, 'i8*', self.type.getLLVMType())
        return mallocLLVM + bitcastLLVM

class Null:
    def __init__(self, exp):
        self.lineNum = exp['line']

    def translateToLLVM(self, reg, type_=None):
        return f'\t{reg} = bitcast i32** @.null to i\n'
        
class Void:
    def __init__(self):
        pass

class Bool:
    def __init__(self, exp):
        self.lineNum = exp['line']
        self.value = exp['exp']
    
    def translateToLLVM(self, reg, block=None):
        return f'\t{reg} = add i1 {1 if self.value == "true" else 0}, 0\n'

class Read:
    def __init__(self):
        pass

    def translateToLLVM(self, saveRead, block=None): 
        return f'\tcall i32 (i8*, ...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.d, i32 0, i32 0), i32* {saveRead})\n'
    

def parseBlock(stmtList):
    returnList = []
    for s in stmtList:
        returnList.append(parseStatement(s))
    return returnList  

def parseStatement(stmt):
    name = stmt['stmt']
    if name == 'block':
        return Block(stmt)
    elif name == 'assign':
        return Assignment(stmt)
    elif name == 'print':
        return Print(stmt)
    elif name == 'if':
        return Conditional(stmt)
    elif name == 'while':
        return Loop(stmt)
    elif name == 'delete':
        return Delete(stmt)
    elif name == 'return':
        return Return(stmt)
    elif name == 'invocation':
        return Invocation(stmt)
    else:
        print(f"Unknown Stmt: {name}")
        sys.exit(1)
    
def parseExpression(exp):
    name = exp['exp']
    if name == 'true':
        return Bool(exp)
    elif name == 'false':
        return Bool(exp)
    elif name == 'binary':
        return Binop(exp)
    elif name == 'unary':
        return Unop(exp)
    elif name == 'dot':
        return Selector(exp)
    elif name == 'num':
        return Number(exp)
    elif name == 'id':
        return ID(exp['id'])
        # return ID(exp)
    elif name == 'new':
        return New(exp)
    elif name == 'invocation':
        return Invocation(exp)
    elif name == 'null':
        return Null(exp)
    elif name == 'read':
        return Read()
    else:
        print(f"Unknown Exp: {name}")
        sys.exit(1)

def parseDeclarations(decls):
    declarations = []
    for decl in decls:
        declarations.append(Declaration(decl))
    return declarations

def parseFunctions(func_list):
    funcs = []
    for func in func_list:
        funcs.append(Function(func))
    return funcs

def parseStructs(struct_list):
    structs = []
    for struct in struct_list:
        structs.append(Struct(struct))
    return structs

def getTypeFromString(typeStr):
    if (typeStr == 'int'):
        return Type(Number, typeStr)
    elif (typeStr == 'bool'):
        return Type(Bool, typeStr)
    elif (typeStr == 'void'):
        return Type(Void, typeStr)
    else:
        return Type(Struct, typeStr)

def getStructFromName(name):
    for struct in TypeCheck.structs:
        if struct.id == name:
            return struct

def getBitcastLLVM(saveReg, sourceReg, fromType, toType):
    return f'\t{saveReg} = bitcast {fromType} {sourceReg} to {toType}\n'

def main():
    pass

if __name__ == '__main__':
    main()