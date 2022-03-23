from LLVM import * 
from settings import updateCFG

def sscp(cfgs):
    for func_id in cfgs.keys():
        workList = []
        regTypes = {}
        sscp_init(cfgs[func_id], workList, regTypes)
        sscp_main(workList, regTypes)
        updateCFG(cfgs[func_id], {}) # removes all useless instructions
        
def sscp_main(workList, regTypes):
    while workList:
        reg = workList.pop(0)
        for use in reg.uses:
            targetReg = use.target
            if targetReg and regTypes[targetReg] != 'unknowable':
                temp = regTypes[targetReg]
                regTypes[targetReg] = evaluateInstruction(use, regTypes)
                if regTypes[targetReg] != temp:
                    workList.append(targetReg)

def sscp_init(cfgNode, workList, regTypes):
    registers = cfgNode.llvm[0].registers
    for reg in registers.keys():
        regTypes[registers[reg]] = getRegType(registers[reg]) # look at the instruction and see what value reg has (Unknown, Constant, Unknowable)
        if regTypes[registers[reg]] != 'unknown':
            workList.append(registers[reg])

def getRegType(reg):
    if isinstance(reg.definition, llvmBinop) or isinstance(reg.definition, llvmICMP):
        if isinstance(reg.definition.operands[0], Constant) and isinstance(reg.definition.operands[1], Constant):
            return performOperation(reg.definition)
        else:
            return 'unknown'
    elif isinstance(reg.definition, llvmTrunc) and isinstance(reg.definition.source, Constant):
        reg.definition.target.value = reg.definition.source.value
        reg.definition.useless = True
        return 'unknown'
    elif isinstance(reg.definition, llvmPhi) or isinstance(reg.definition, llvmTrunc):
        return 'unknown'  
    else:
        return 'unknowable'
                
def evaluateInstruction(inst, regTypes):
    if isinstance(inst, llvmPhi):
        return evaluatePhi(inst, regTypes)
    elif isinstance(inst, llvmTrunc):
        return evaluateTrunc(inst, regTypes)
    targetReg = inst.target
    srcReg1 = inst.operands[0]
    srcReg2 = inst.operands[1]
    if regTypes.get(srcReg1) == 'unknowable' or regTypes.get(srcReg2) == 'unknowable':
        return 'unknowable'
    elif regTypes.get(srcReg1) == 'unknown' or regTypes.get(srcReg2) == 'unknown':
        return 'unknown'
    else:
        return performOperation(inst)

def evaluateTrunc(inst, regTypes):
    if regTypes[inst.source] not in ['unknown', 'unknowable']:
        inst.target.value = inst.source.value
        inst.useless = True
        return inst.source
    return regTypes[inst.source]
    
def evaluatePhi(phi, regTypes):
    if phi.isTrivial():
        phi.useless = True
        phi.target.value = phi.args[0]['reg'].value
        return regTypes[phi.args[0]['reg']]
    else:
        return 'unknowable'
        
def performOperation(inst):
    if isinstance(inst, llvmBinop):
        inst.useless = True
        return evalBinop(inst)
    elif isinstance(inst, llvmICMP):
        inst.useless = True
        return evalICMP(inst)
    else:
        print("huhhhhhh")

def evalBinop(inst):
    op = inst.op
    targetReg = inst.target
    srcReg1 = inst.operands[0]
    srcReg2 = inst.operands[1]
    
    if op == 'add':
        targetReg.value = srcReg1.value + srcReg2.value
        return targetReg.value
    elif op == 'sub':
        targetReg.value = srcReg1.value = srcReg2.value
        return targetReg.value
    elif op == 'mul':
        targetReg.value = srcReg1.value * srcReg2.value
        return targetReg.value
    elif op == 'sdiv':
        targetReg.value = srcReg1.value // srcReg2.value
        return targetReg.value
    elif op == 'and':
        targetReg.value = 1 if (srcReg1.value and srcReg2.value) else 0
        return targetReg.value
    elif op == 'or':
        targetReg.value = 1 if (srcReg1.value or srcReg2.value) else 0
        return targetReg.value
    else:
        return 'huhhhhhhh'

def evalICMP(inst):
    op = inst.op
    targetReg = inst.target
    srcReg1 = inst.operands[0]
    srcReg2 = inst.operands[1]

    if op == 'slt':
        targetReg.value = 1 if (srcReg1.value < srcReg2.value) else 0
        return targetReg.value
    elif op == 'sgt':
        targetReg.value = 1 if (srcReg1.value > srcReg2.value) else 0
        return targetReg.value
    elif op == 'sle':
        targetReg.value = 1 if (srcReg1.value <= srcReg2.value) else 0
        return targetReg.value
    elif op == 'sge':
        targetReg.value = 1 if (srcReg1.value >= srcReg2.value) else 0
        return targetReg.value
    elif op == 'eq':
        targetReg.value = 1 if (srcReg1.value == srcReg2.value) else 0
        return targetReg.value
    elif op == 'ne':
        targetReg.value = 1 if (srcReg1.value != srcReg2.value) else 0
        return targetReg.value
    else:
        return 'huhhhhhhhhhhhhhhhhhhh'