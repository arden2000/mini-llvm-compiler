from AST import Conditional, Void, Assignment, Loop, Block, Return, Guard, UnconditionalBranch
import TypeCheck
import sys
import random
from settings import getReg
from cfg import Node
from LLVM import *
import copy
nodeQueue = []

class Phi:
    def __init__(self, ambiguousVar, type_):
        self.ambVar = ambiguousVar
        self.operands = []
        self.type = type_

    def translateToLLVM(self, block):
        phiReg = block.varMap.get(self.ambVar)
        for parent in block.preds:
            op = self.getPhiOperand(parent, parent.name)
            if op and op['reg'] != phiReg:
                self.operands.append(op)
        
        # if len(self.operands) == 1:
        #     block.varMap[self.ambVar] = self.operands[0]['reg']
        #     return ''
        if phiReg is None:
            phiReg = getReg()
            block.varMap[self.ambVar] = phiReg
    
        return f'\t{phiReg} = phi {self.type.getLLVMType()} {self.getPhiOperandsLLVM()}\n'

    def getPhiOperand(self, block, label):
        reg = block.varMap.get(self.ambVar)
        if reg:
            return {'reg': reg, 'label': label}
        elif block.preds[0] != block.left: # while body's left == while body's pred
            return self.getPhiOperand(block.preds[0], label)
    
    def getPhiOperandsLLVM(self):
        opLLVM = ''
        for op in self.operands:
            opLLVM += f'[ {op["reg"]}, %{op["label"]} ], '
        return opLLVM[:-2]

def addHeadNode(cfgs, func):
    headNode = Node()
    headNode.left = cfgs[func.id]
    cfgs[func.id].preds.append(headNode)
    headNode.visited = True
    headNode.name = 'START'
    cfgs[func.id] = headNode
    funcHeaderLLVM = func.translateToLLVM(cfgs[func.id])
    declsLLVM = translateDeclsToLLVM(func.decls, cfgs[func.id])
    declsLLVMClasses = createLLVMClasses('label\n' + declsLLVM)
    headNode.llvm.append(llvmFuncHeader(funcHeaderLLVM, declsLLVMClasses))
    headNode.llvm.append(llvmUncondBranch(f'br label %{cfgs[func.id].left.name if cfgs[func.id].left else "END"}'))
    
def createLLVM(cfgs, funcs):
    llvm = {}
    for func in funcs:
        addHeadNode(cfgs, func)
        llvm[func.id] = str(cfgs[func.id])
        #llvm[func.id] += f'\tbr label %{cfgs[func.id].left.name if cfgs[func.id].left else "END"}\n'
        endBlock = Node()
        endBlock.name = 'END'
        addEndBlock(cfgs[func.id].left, endBlock, {})
        llvm[func.id] += translateBodyToLLVM(cfgs[func.id].left, func) # skip past the header block
        llvm[func.id] += '}\n\n'
        #cfgs[func.id].llvm[0].registers = copy.deepcopy(getRegDict())
        for reg in getRegDict().keys():
            cfgs[func.id].llvm[0].registers[reg] = getRegDict()[reg]
        resetRegDict()
    return llvm
    
def translateDeclsToLLVM(localVars, block):
    llvm = ''
    for var in localVars:
        llvm += var.translateToLLVM(block)
    return llvm

def getNextNodeLabel(node): # dont need END anymore - it is an actual CFG node now
    if node.left:
        if not node.left.name:
            return 'END'
        return node.left.name
    elif node.right:
        if not node.right.name:
            return 'END'
        return node.right.name
    else:
        return 'huhhhhhh'

def addEndBlock(cfg, endBlock, visited):
    visited[cfg] = 1
    if cfg.hasReturn or (not cfg.left and not cfg.right):
        if cfg not in endBlock.preds:
            cfg.left = endBlock
            endBlock.preds.append(cfg)
            if not cfg.hasReturn:
                cfg.stmts.append(UnconditionalBranch('END'))
            cfg.right = None
        return
    if cfg.stmts and isinstance(cfg.stmts[-1], UnconditionalBranch) and cfg.stmts[-1].branchType == 'while':
        return
    if cfg.left and not visited.get(cfg.left):
        addEndBlock(cfg.left, endBlock, visited)
    if cfg.right and not visited.get(cfg.right):
        addEndBlock(cfg.right, endBlock, visited)

def isReadyToTranslate(cfgNode):
    for pred in cfgNode.preds:
        if not pred.visited: # and pred.name and cfgNode.name != pred.name: # if any pred has not been visited, return False
            return False
    return True
    
def translateBodyToLLVM(cfgNode, func):
    global nodeQueue
    nodeQueue.append(cfgNode)
    llvm = ""
    while nodeQueue:
        cfgNode = nodeQueue.pop(0)
        if isReadyToTranslate(cfgNode):
            if cfgNode.left and not cfgNode.left.visited:
                nodeQueue.append(cfgNode.left)
            if cfgNode.right and not cfgNode.right.visited:
                nodeQueue.append(cfgNode.right)
            if not cfgNode.visited:
                if cfgNode.name == 'END':
                    llvm += translateEndBlockToLLVM(cfgNode, func.retType)
                else:
                    llvm += translateNodeToLLVM(cfgNode, func.params + func.decls)
        elif isWhileGuard(cfgNode) and not cfgNode.left.visited: # while body has not been visited yet (while body is the left child of while guard)
            populateWhileGuardVarMap(cfgNode, func.params + func.decls)
            nodeQueue.append(cfgNode.left)
            llvm += translateNodeToLLVM(cfgNode.left, func.params + func.decls) # translate the body now that it is ready
            if cfgNode.left.left:
                nodeQueue.append(cfgNode.left.left)
            if cfgNode.left.right:
                nodeQueue.append(cfgNode.left.right)
            nodeQueue.append(cfgNode)
        else:
            nodeQueue.append(cfgNode)
    return llvm

def isWhileGuard(cfgNode):
    for parent in cfgNode.preds:
        if parent.stmts and isinstance(parent.stmts[-1], UnconditionalBranch) and parent.stmts[-1].branchType == 'while':
            return True
    return False

def populateWhileGuardVarMap(block, allLocals):
    for decl in allLocals: # precursor to adding phi nodes for all vars
        block.varMap[decl.id.id] = getReg() 
    
def translateEndBlockToLLVM(endBlock, retType):
    llvm = f'\nEND:\n'
    endBlock.visited = True
    if retType.getLLVMType() == "void":
        llvm += '\tret void\n'
        endBlock.llvm = createLLVMClasses(llvm[3:])
        return llvm
    returnPhi = Phi('return', retType)
    llvm += returnPhi.translateToLLVM(endBlock)
    llvm += f'\tret {retType.getLLVMType()} {endBlock.varMap["return"]}\n'
    endBlock.llvm = createLLVMClasses(llvm[3:])
    return llvm

def addPhis(cfgNode, allLocals):
    if len(cfgNode.preds) > 1:
        for decl in allLocals:
            cfgNode.stmts.insert(0, Phi(decl.id.id, decl.type))

def translateNodeToLLVM(cfgNode, allLocals):
    llvm = f'\n{cfgNode.name}:\n'
    addPhis(cfgNode, allLocals)
    for stmt in cfgNode.stmts:
        if isinstance(stmt, Guard):
            elseName = 'END' if not cfgNode.right else cfgNode.right.name
            llvm += stmt.translateToLLVM(cfgNode.left.name, elseName, getReg(), cfgNode)
        elif isinstance(stmt, UnconditionalBranch) and stmt.branchType == 'while':
            llvm += stmt.translateToLLVM()
        elif isinstance(stmt, UnconditionalBranch) and stmt.branchType in ['if', 'toWhileGuard', 'END']:
            llvm += stmt.translateToLLVM(getNextNodeLabel(cfgNode))
        elif isinstance(stmt, Return):
            llvm += stmt.translateToLLVM(getReg(), cfgNode) # stores return value in RETURN_REG and branches to END
            #return llvm
        elif isinstance(stmt, Assignment):
            llvm += stmt.translateToLLVM(getReg(), cfgNode)
        elif isinstance(stmt, Phi):
            llvm += stmt.translateToLLVM(cfgNode)
        else:
            if isinstance(stmt, UnconditionalBranch):
                print(stmt.branchType)
            llvm += stmt.translateToLLVM(getReg(), cfgNode)
    cfgNode.visited = True

    cfgNode.llvm = createLLVMClasses(llvm[1:])
    #return llvm
    return str(cfgNode)

def createLLVMClasses(llvm):
    llvmClasses = []
    llvm = llvm.split('\n')[1:] # removes label from execution
    if len(llvm[-1]) == 0:
        llvm = llvm[:-1]
    for inst in llvm:
        llvmClasses.append(createLLVMClass(inst))
    return llvmClasses

def createLLVMClass(inst):
    if 'call' in inst:
        return llvmCall(inst)
    elif 'bitcast' in inst:
        return llvmBitcast(inst)
    elif 'trunc' in inst:
        return llvmTrunc(inst)
    elif 'getelementptr' in inst:
        return llvmGetElementPtr(inst)
    elif 'load' in inst:
        return llvmLoad(inst)
    elif 'store' in inst:
        return llvmStore(inst)
    elif 'br i1' in inst:
        return llvmCondBranch(inst)
    elif 'br' in inst:
        return llvmUncondBranch(inst)
    elif 'icmp' in inst:
        return llvmICMP(inst)
    elif 'phi' in inst:
        return llvmPhi(inst)
    elif 'ret' in inst:
        return llvmReturn(inst)
    elif inst != '':
        return llvmBinop(inst)