from AST import Conditional, Void, Loop, Block, Return, Guard, UnconditionalBranch
import TypeCheck
import sys
import random
from settings import getReg
class Node:
    def __init__(self):
        self.left = None
        self.right = None
        self.stmts = []
        self.name = None
        self.hasReturn = False
        self.visited = False
        self.varMap = {}
        self.preds = []
        self.llvm = []
    
    def __str__(self):
        llvm = ''
        toRemove = []
        if self.name != 'START':
            llvm = f'\n{self.name}:\n'
        for inst in self.llvm:
            if inst.useless:
                toRemove.append(inst)
            else:
                llvm += str(inst)
        for inst in toRemove:
            self.llvm.remove(inst) 
        return llvm

def buildCFGs(funcs):
    cfgs = {}
    for func in funcs:
        cfg = Node()
        populateCFG(func.body, cfg)
        cfgs[func.id] = cfg
        #cfgs[func.id] = trimCFG(cfg)
    return cfgs

# def printCFG(cfg):
#     print(cfg.name)
#     if cfg.left:
#         printCFG(cfg.left)
#     if cfg.right:
#         printCFG(cfg.right)

def getBlockName(block):
    while isinstance(block, Block):
        if block.stmts:
            block = block.stmts[0]
        else:
            return getEmptyNodeLabel()
    return block.lineNum

emptyNodeCounter = 0

def getEmptyNodeLabel():
    global emptyNodeCounter
    temp = emptyNodeCounter
    emptyNodeCounter += 1
    return f'EmptyNode{temp}'

def populateCFG(body, node):
    '''
        body: function body
        node: top level node to build the cfg on
            Builds a Control Flow Graph for the given function. 
            Branches on Conditionals and Loops
        return: a cfg containing Nodes, where each Node represents a basic block of code (basic block = chunk of code that is guaranteed to execute all the way through)
    '''
    for stmt in body.stmts:
        if not node.name:
            if isinstance(stmt, Block):
                node.name = f'L{getBlockName(stmt)}'
            else:
                stmt.lineNum
                node.name = f'L{stmt.lineNum}'
        if isinstance(stmt, Conditional):
            guard = Guard(stmt.guard)
            node.stmts.append(guard)
            continueNode = Node()
            node.left = Node()
            node.left.preds.append(node)
            thenFinal = populateCFG(stmt.then, node.left) # then is on the left
            #thenFinal.preds.append(node) # then block pred is current node(guard)  
            if not thenFinal.hasReturn:
                thenFinal.stmts.append(UnconditionalBranch('if'))
                thenFinal.left = continueNode
                continueNode.preds.append(thenFinal) # continue node pred is then block
            if (stmt.else_):
                node.right = Node()
                node.right.preds.append(node)
                elseFinal = populateCFG(stmt.else_, node.right) # else is on the right                    
                #elseFinal.preds.append(node)
                if not elseFinal.hasReturn:
                    elseFinal.stmts.append(UnconditionalBranch('if'))
                    elseFinal.left = continueNode
                    continueNode.preds.append(elseFinal) # continueNode pred is else block
            else:
                node.right = continueNode
                continueNode.preds.append(node) # continueNode pred is current node(guard)
            node = continueNode
        elif isinstance(stmt, Loop):
            if node.stmts: 
                node.stmts.append(UnconditionalBranch('toWhileGuard'))
                guardNode = Node()
                node.left = guardNode
                guardNode.preds.append(node) # guard node has previous node as its pred
            else:
                guardNode = node
            guard = Guard(stmt.guard)
            guardNode.name = f'L{stmt.lineNum}'
            guardNode.stmts.append(guard)
            bodyStart = Node()
            guardNode.left = bodyStart
            bodyStart.preds.append(guardNode)
            bodyFinal = populateCFG(stmt.body, guardNode.left) # guardNode.left = body of while
            if not bodyFinal.hasReturn:
                uBranch = UnconditionalBranch('while')
                uBranch.parentLabel = guardNode.name
                bodyFinal.stmts.append(uBranch) # add a stmt to branch back to the guard
                guardNode.preds.append(bodyFinal)
                bodyFinal.left = guardNode
                 # guard node has while body as pred
            guardNode.right = Node() # guardNode.right = after body of while
            node = guardNode.right # node = current location in program that will be populated on next pass
            node.preds.append(guardNode) # guard false condition block has guard as its pred
        elif isinstance(stmt, Block):
            node = populateCFG(stmt, node)
        elif isinstance(stmt, Return):
            node.stmts.append(stmt)
            node.hasReturn = True
        else:
            node.stmts.append(stmt)
    if not node.name:
        node.name = getEmptyNodeLabel()
    return node