registers = {}

def getRegDict():
    return registers

def resetRegDict():
    global registers
    registers = {}

def getRegister(reg, inst):
    global registers
    if not '%' in reg and not '@' in reg: # if constant
        return Constant(reg)
    regClass = registers.get(reg)
    if regClass:
        regClass.uses.append(inst)
        return regClass
    else:
        registers[reg] = Register(reg)
        registers[reg].definition = inst
        return registers[reg]

class Param:
    def __init__(self, reg):
        self.reg = reg
        getRegister(reg, self)

class llvmFuncHeader:
    def __init__(self, header, declsLLVM):
        self.header = header
        self.decls = declsLLVM
        self.params = []
        self.registers = {}
        self.useless = False
        self.parseFuncHeader(header)
        
    def parseFuncHeader(self, header):
        header = header.strip()[:-3]
        header = header.split('(')[1]
        if len(header) == 0:
            return
        args = header.split(', ')
        for arg in args:
            arg = arg.split(' ')[1]
            self.params.append(Param(arg))

    def __str__(self):
        return f'{self.header}START:\n{self.getDeclsLLVM()}'

    def getDeclsLLVM(self):
        declsLLVM = ''
        for decl in self.decls:
            if not decl.useless:
                declsLLVM += str(decl)
        return declsLLVM

class Constant:
    def __init__(self, val):
        if (val == 'null'):
            self.value = 'null'
        else:
            self.value = int(val)
    
    def __str__(self):
        return f'{self.value}'

class Register:
    def __init__(self, reg):
        self.reg = reg
        self.definition = None
        self.uses = []
        self.value = reg
    
    def __str__(self):
        return f'{self.value}'

class llvmBinop:
    def __init__(self, inst):
        self.llvm = inst
        self.operands = []
        self.op = None
        self.target = None
        self.useless = False
        self.type = None
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.operands.append(getRegister(instruction[4][:-1], self))
        self.operands.append(getRegister(instruction[5], self))
        self.type = instruction[3]
        self.op = instruction[2]
        self.target = getRegister(instruction[0], self)

    def __str__(self):
        return f'\t{self.target} = {self.op} {self.type} {self.operands[0]}, {self.operands[1]}\n'   

class llvmStore:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.source = None
        self.type = None
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.type = instruction[1]
        self.source = getRegister(instruction[2][:-1], self)
        self.target = getRegister(instruction[4], self)
    
    def __str__(self):
        return f'\tstore {self.type} {self.source}, {self.type}* {self.target}\n'

class llvmLoad:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.source = None
        self.operands = []
        self.type = None
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.source = getRegister(instruction[5], self)
        self.operands.append(self.source)
        self.target = getRegister(instruction[0], self)
        self.type = instruction[3][:-1]

    def __str__(self):
        return f'\t{self.target} = load {self.type}, {self.type}* {self.source}\n'

class llvmUncondBranch:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.label = None
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.label = instruction[2][1:]
    
    def __str__(self):
        return f'\tbr label %{self.label}\n'

class llvmCondBranch:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.trueLabel = None
        self.falseLabel = None
        self.condReg = None
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.trueLabel = instruction[4][1:-1]
        self.falseLabel = instruction[6][1:]
        self.condReg = getRegister(instruction[2][:-1], self)

    def __str__(self):
        return f'\tbr i1 {self.condReg}, label %{self.trueLabel}, label %{self.falseLabel}\n'

class llvmICMP:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.operands = []
        self.op = None
        self.useless = False
        self.type = None
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.target = getRegister(instruction[0], self)
        self.op = instruction[3]
        self.type = instruction[4]
        self.operands.append(getRegister(instruction[5][:-1], self))
        self.operands.append(getRegister(instruction[6], self))  
    
    def __str__(self):
        return f'\t{self.target} = icmp {self.op} {self.type} {self.operands[0]}, {self.operands[1]}\n'

class llvmReturn:
    def __init__(self, inst):
        self.llvm = inst
        self.retVal = None
        self.type = None
        self.useless = False
        self.target = None
        self.operands = []
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.type = instruction[1]
        if len(instruction) > 2:
            self.retVal = getRegister(instruction[2], self)
            self.operands.append(self.retVal)
    
    def __str__(self):
        return f'\tret {self.type} {self.retVal if self.retVal else ""}\n'

class llvmBitcast:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.source = None
        self.sourceType = None
        self.targetType = None
        self.useless = False
        self.operands = []
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.target = getRegister(instruction[0], self)
        self.source = getRegister(instruction[4], self)
        self.sourceType = instruction[3]
        self.targetType = instruction[-1]
        self.operands.append(self.source)
    
    def __str__(self):
        return f'\t{self.target} = bitcast {self.sourceType} {self.source} to {self.targetType}\n'

class llvmTrunc:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.source = None
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.target = getRegister(instruction[0], self)
        self.source = getRegister(instruction[4], self)

    def __str__(self):
        return f'\t{self.target} = trunc i32 {self.source} to i1\n'
        
class llvmCall:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.args = []
        self.argTypes = []
        self.retType = None
        self.name = None
        self.isLibrary = False
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        if '@scanf' in instruction or '@printf' in instruction:
            instruction = instruction.split(' ')
            self.args.append(getRegister(instruction[-1][:-1], self))
            self.isLibrary = True
            return
        instruction = instruction.split(' ')
        if '=' in instruction:
            self.target = getRegister(instruction[0], self)
            self.retType = instruction[3]
            self.name = instruction[4].split('(')[0]
        else:
            self.retType = instruction[1]
            self.name = instruction[2].split('(')[0]
        self.parseArgs(inst)

    def parseArgs(self, instruction):
        instruction = instruction.strip()
        instruction = instruction.split('(')[1]
        instruction = instruction[:-1] # removes closing )
        if len(instruction) == 0:
            return
        stringArgs = instruction.split(', ')
        for arg in stringArgs:
            argType = arg.split(' ')[0]
            arg = arg.split(' ')[1]
            self.args.append(getRegister(arg, self))
            self.argTypes.append(argType)
    
    def __str__(self):
        if self.isLibrary:
            return self.createLibLLVM()
        target = f'\t{self.target} = ' if self.target else '\t'
        call = f'call {self.retType} {self.name}({self.getArgString()})\n'
        return target + call
    
    def getArgString(self):
        argString = ''
        for i in range(len(self.args)):
            argString += f'{self.argTypes[i]} {self.args[i]}, '
        return argString[:-2]
        
    def createLibLLVM(self):
        inst = self.llvm.strip()
        inst = inst.split(' ')
        llvm = ' '.join(inst[:-1])
        return f'\t{llvm} {self.args[0]})\n'

class llvmPhi:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.args = []
        self.operands = []
        self.type = None
        self.useless = False
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.target = getRegister(instruction[0], self)
        self.type = instruction[3]
        self.parseArgs(inst)

    def parseArgs(self, instruction):
        instruction = instruction.strip()
        stringArgs = instruction.split('[ ')[1:]
        for arg in stringArgs:
            arg = arg.split(', ')
            stringReg = arg[0]
            label = arg[1][1:-2] # removes ] and % from the label
            reg = getRegister(stringReg, self)
            self.args.append({'reg': reg, 'label': label})
            self.operands.append(reg)

    def replaceArg(self, oldLabel, newLabel):
        for arg in self.args:
            if arg['label'] == oldLabel:
                arg['label'] = newLabel

    def removeArg(self, oldLabel):
        argsToRemove = []
        for arg in self.args:
            if arg['label'] == oldLabel:
                argsToRemove.append(arg)
        for arg in argsToRemove:
            self.args.remove(arg)

    def isTrivial(self):
        for i in range(len(self.args) - 1):
            if self.args[i]['reg'].value != self.args[i + 1]['reg'].value:
                return False
        return True 
            
    def __str__(self):
        return f'\t{self.target} = phi {self.type} {self.getArgsLLVM()}\n'
    
    def getArgsLLVM(self):
        argLLVM = ''
        for arg in self.args:
            argLLVM += f'[ {str(arg["reg"])}, %{arg["label"]} ], '
        return argLLVM[:-2]

class llvmGetElementPtr:
    def __init__(self, inst):
        self.llvm = inst
        self.target = None
        self.source = None
        self.operands = []
        self.useless = False
        self.type = None
        self.path = None
        self.parseInst(inst)
    
    def parseInst(self, inst):
        instruction = inst.strip()
        instruction = instruction.split(' ')
        self.target = getRegister(instruction[0], self)
        self.source = getRegister(instruction[5][:-1], self)
        self.type = instruction[3][:-1]
        self.operands.append(self.source)
        self.path = ' '.join(instruction[6:])

    def __str__(self):
        return f'\t{self.target.value} = getelementptr {self.type}, {self.type}* {self.source.value}, {self.path}\n'
        