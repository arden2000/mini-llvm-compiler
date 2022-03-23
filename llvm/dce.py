from LLVM import * 
from settings import updateCFG

def dce(cfgs):
    for func_id in cfgs.keys():
        workList = []
        dce_init(cfgs[func_id], workList)
        dce_main(workList)
        updateCFG(cfgs[func_id], {}) # removes all useless instructions

def dce_main(workList):
    while (workList):
        reg = workList.pop(0)
        reg.definition.useless = True
        for opReg in reg.definition.operands:
            if isinstance(opReg, Register):
                if '@' not in opReg.reg and reg.definition in opReg.uses:
                    opReg.uses.remove(reg.definition)
                if len(opReg.uses) == 0 and not is_critical(opReg.definition):
                    workList.append(opReg)

def is_critical(inst):
    if isinstance(inst, Param) or isinstance(inst, llvmCall) or isinstance(inst, llvmStore) or isinstance(inst, llvmCondBranch) or isinstance(inst, llvmUncondBranch) or isinstance(inst, llvmTrunc):
        return True
    else:
        for op in inst.operands:
            if not isinstance(op, Constant) and '@' in op.reg:
                return True
        return False

def dce_init(cfgNode, workList):
    registers = cfgNode.llvm[0].registers
    for reg in registers.keys():
        if len(registers[reg].uses) == 0 and not is_critical(registers[reg].definition):
            workList.append(registers[reg])

