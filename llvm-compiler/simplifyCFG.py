from LLVM import * 
from settings import updateCFG
from AST import UnconditionalBranch
import copy

def simplify_cfg(cfgs):
    for func_id in cfgs.keys():
        workList = []
        remove_constant_branches(cfgs[func_id])
        updateCFG(cfgs[func_id], {}) # removes all useless instructions
        remove_useless_blocks(cfgs[func_id])
        updateCFG(cfgs[func_id], {}) # removes all useless instructions

def remove_useless_blocks(node): # , visited):
    # visited[node.name] = True
    if node.left and not is_while_body(node):# visited.get(node.left.name):
        left_node = remove_useless_blocks(node.left)
        if left_node.name != node.left.name:
            update_branch_llvm(node, left_node, None)
    if node.right and not is_while_body(node): # not visited.get(node.right.name):
        right_node = remove_useless_blocks(node.right)
        if right_node.name != node.right.name:
            update_branch_llvm(node, None, right_node)
    if is_useless(node):
        return node.left
    else:
        return node

def update_branch_llvm(node, left_child, right_child):
    if isinstance(node.llvm[-1], llvmUncondBranch) and not contains_untrivial_phis(node):
        node.left = left_child
        node.llvm[-1].label = node.left.name
    elif isinstance(node.llvm[-1], llvmCondBranch) and not contains_untrivial_phis(node):
        if left_child:
            update_phis(node.left.name, node.name, left_child)
            node.left = left_child
            node.llvm[-1].trueLabel = node.left.name
        if right_child:
            update_phis(node.right.name, node.name, right_child)
            node.right = right_child
            node.llvm[-1].falseLabel = node.right.name
        if node.left.name == node.right.name:
            node.llvm[-2].useless = True
            node.llvm[-1].useless = True
            node.llvm.append(llvmUncondBranch(f'br label %{node.left.name}'))
            node.right = None
    elif isinstance(node.llvm[-1], llvmCondBranch):
        if left_child:
            update_phis(node.left.name, node.name, left_child)
            node.left = left_child
            node.llvm[-1].trueLabel = node.left.name
        if right_child and node.left.name != right_child.name:
            update_phis(node.right.name, node.name, right_child)
            node.right = right_child
            node.llvm[-1].falseLabel = node.right.name

def contains_untrivial_phis(node):
    if node.left and node.right:
        continueNode, falsePred = find_continue_node(node, {})
    else:
        continueNode = node.left
    if not continueNode:
        return False
    for inst in continueNode.llvm:
        if isinstance(inst, llvmPhi) and not inst.isTrivial():
            return True
    return False

def update_phis(oldLabel, newLabel, node):
    for inst in node.llvm:
        if isinstance(inst, llvmPhi):
            inst.replaceArg(oldLabel, newLabel)

def is_useless(node):
    if len(node.llvm) == 1 and isinstance(node.llvm[0], llvmUncondBranch) and not contains_untrivial_phis(node):
        return True
    return False
    
def is_while_body(node):
    if node.stmts and isinstance(node.stmts[-1], UnconditionalBranch) and node.stmts[-1].branchType == 'while':
        return True
    return False

def isWhileGuard(cfgNode):
    for parent in cfgNode.preds:
        if parent.stmts and isinstance(parent.stmts[-1], UnconditionalBranch) and parent.stmts[-1].branchType == 'while':
            return True
    return False

def remove_useless_phi_args(contNode, uselessLabel):
    for inst in contNode.llvm:
        if isinstance(inst, llvmPhi):
            inst.removeArg(uselessLabel)

def remove_constant_branches(cfgNode):
    if len(cfgNode.llvm) > 0 and isinstance(cfgNode.llvm[-1], llvmCondBranch):
        if isinstance(cfgNode.llvm[-1].condReg.value, int):
            if cfgNode.llvm[-1].condReg.value != 0: # if always true
                cfgNode.llvm[-1].useless = True
                cfgNode.llvm.append(llvmUncondBranch(f'br label %{cfgNode.llvm[-1].trueLabel}'))
                visited = {}
                find_continue_node(cfgNode.left, visited) # mark all nodes from true side as true in visited dict
                continueNode, falsePred = find_continue_node(cfgNode.right, visited) # traverse tree until false side and true side converge, then return the continue node and the continue nodes pred on the false side
                continueNode.preds.remove(falsePred)
                cfgNode.right = None
                remove_useless_phi_args(continueNode, falsePred.name)
                # remove_useless_phi_args(continueNode, cfgNode.name)
            else: # if always false
                cfgNode.llvm[-1].useless = True
                cfgNode.llvm.append(llvmUncondBranch(f'br label %{cfgNode.llvm[-1].falseLabel}'))
                visited = {}
                find_continue_node(cfgNode.right, visited) # mark all nodes from true side as true in visited dict
                continueNode, truePred = find_continue_node(cfgNode.left, visited) # traverse tree until false side and true side converge, then return the continue node and the continue nodes pred on the false side
                continueNode.preds.remove(truePred)
                cfgNode.left = cfgNode.right
                cfgNode.right = None # so that if there is a child it always starts on the left (this is assumed elsewhere)
                remove_useless_phi_args(continueNode, truePred.name)
                # remove_useless_phi_args(continueNode, cfgNode.name)
    if cfgNode.left and not is_while_body(cfgNode):
        remove_constant_branches(cfgNode.left)
    if cfgNode.right and not is_while_body(cfgNode):
        remove_constant_branches(cfgNode.right)

def find_continue_node(node, visited): 
    # finds the continue node and the pred to the continue node 
    # must be called twice with visited dict passed to the first call and then the second call
    # the second call will return the correct info
    if visited.get(node.name):
        return node, node.preds[1]
    if node.left and visited.get(node.left.name) and node.left not in node.preds:
        return node.left, node  # continue node, continue node's pred
        
    visited[node.name] = True
    if node.left and not visited.get(node.left.name):
        retNode, pred = find_continue_node(node.left, visited)
        if retNode:
            return retNode, pred
    if node.right and not visited.get(node.right.name):
        retNode, pred = find_continue_node(node.right, visited)
        if retNode:
            return retNode, pred
    return None, None