reg = 1
stackFlag = False

def getReg():
    global reg
    currReg = reg
    reg += 1
    return f'%r{currReg}'

def setStackFlag(val):
    global stackFlag
    stackFlag = val

def getStackFlag():
    return stackFlag

def updateCFG(cfgNode, visited):
    visited[cfgNode] = True
    llvm = str(cfgNode)
    if cfgNode.left and not visited.get(cfgNode.left):
        llvm += updateCFG(cfgNode.left, visited)
    if cfgNode.right and not visited.get(cfgNode.right):
        llvm += updateCFG(cfgNode.right, visited)
    return llvm