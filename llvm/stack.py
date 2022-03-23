from AST import Conditional, Void, Loop, Block, Return, Guard, UnconditionalBranch
import TypeCheck
import sys
import random
from settings import getReg, getStackFlag 
from cfg import Node

def storeArgsLLVM(params):
    llvm = ''
    for param in params:
        llvm += f'\tstore {param.type.getLLVMType()} %{param.id.id}1, {param.type.getLLVMType()}* %{param.id.id}\n'
    return llvm

def createLLVM(cfgs, funcs):
    llvm = {}
    for func in funcs:
        llvm[func.id] = func.translateToLLVM()
        if func.retType.type != Void:
            llvm[func.id] += f'\t%return = alloca {func.retType.getLLVMType()}\n'
        llvm[func.id] += translateDeclsToLLVM(func.decls + func.params)
        llvm[func.id] += storeArgsLLVM(func.params)
        llvm[func.id] += f'\tbr label %{cfgs[func.id].name if cfgs[func.id].name else "END"}\n'
        llvm[func.id] += translateBodyToLLVM(cfgs[func.id], 'start', func.retType)
        llvm[func.id] += '}\n\n'
    return llvm
    
def translateDeclsToLLVM(localVars):
    llvm = ''
    for var in localVars:
        llvm += var.translateToLLVM()
    return llvm

def getNextNodeLabel(node):
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


def translateBodyToLLVM(cfgNode, parentNodeLabel, retType):
    if cfgNode.visited:
        return ''
    cfgNode.visited = True
    if not cfgNode.left and not cfgNode.right:
        if not cfgNode.stmts:
            llvm = f'\nEND:\n'
            if retType.type != Void:
                returnReg = getReg()
                llvm += f'\t{returnReg} = load {retType.getLLVMType()}, {retType.getLLVMType()}* %return\n'
            llvm += f'\tret {retType.getLLVMType()}{f" {returnReg}" if retType.getLLVMType() != "void" else ""}\n'
            return llvm
        else:
            cfgNode.left = Node()
    llvm = f'\n{cfgNode.name}:\n'
    # print(f"{cfgNode.name}: preds: ", end = "")
    # for pred in cfgNode.preds:
    #     print(pred.name, end=', ')
    # print()

    for stmt in cfgNode.stmts:
        if isinstance(stmt, Guard):
            elseName = 'END' if not cfgNode.right.name else cfgNode.right.name
            llvm += stmt.translateToLLVM(cfgNode.left.name, elseName, getReg())
        elif isinstance(stmt, UnconditionalBranch) and stmt.branchType == 'while':
            llvm += stmt.translateToLLVM(parentNodeLabel)
        elif isinstance(stmt, UnconditionalBranch) and stmt.branchType in ['if', 'toWhileGuard']:
            llvm += stmt.translateToLLVM(getNextNodeLabel(cfgNode))
        elif isinstance(stmt, Return):
            llvm += stmt.translateToLLVM(getReg()) # stores return value in RETURN_REG and branches to END
            #return llvm
        else:
            llvm += stmt.translateToLLVM(getReg())
    
    if cfgNode.left:
        llvm += translateBodyToLLVM(cfgNode.left, cfgNode.name, retType)
    if cfgNode.right:
        llvm += translateBodyToLLVM(cfgNode.right, cfgNode.name, retType)

    return llvm