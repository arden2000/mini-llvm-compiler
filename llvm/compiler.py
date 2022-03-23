import TypeCheck
import stack
import cfg as CFG
import sys
import os
import ssa
import settings
from sscp import sscp
from dce import dce
from simplifyCFG import simplify_cfg

sscpFlag = False
dceFlag = False
simplifyFlag = False

def libraryFunctionsLLVM():
    llvm = 'declare i8* @malloc(i32)\n'
    llvm += 'declare void @free(i8*)\n'
    llvm += 'declare i32 @printf(i8*, ...)\n'
    llvm += 'declare i32 @scanf(i8*, ...)\n\n'
    llvm += '@.d = private unnamed_addr constant [3 x i8] c"%d\\00", align 1\n'
    llvm += '@.d.space = private unnamed_addr constant [4 x i8] c"%d \\00", align 1\n'
    llvm += '@.nl = private unnamed_addr constant [4 x i8] c"%d\\0A\\00", align 1\n\n'
    if not settings.getStackFlag():
        llvm += '@.null = global i32* null\n'
        llvm += '@.read = global i32 0\n'
    return llvm

def structsLLVM(structs):
    llvm = ""
    for struct in structs:
        llvm += struct.translateToLLVM()
    return llvm
    
def globalDeclsLLVM(decls):
    llvm = ''
    for decl in decls:
        llvm += decl.translateToGlobalLLVM()
    return llvm

def getGlobalLLVM(structs, decls):
    globalsLLVM = libraryFunctionsLLVM() + '\n'
    globalsLLVM += structsLLVM(structs) + '\n'
    globalsLLVM += globalDeclsLLVM(decls) + '\n'
    return globalsLLVM

def parseFlags():
    filename = ''
    global sscpFlag
    global dceFlag
    global simplifyFlag
    for arg in sys.argv:
        if arg == '-stack':
             settings.setStackFlag(True)
        elif arg == '-dce':
            dceFlag = True
        elif arg == '-sscp':
            sscpFlag = True
        elif arg == '-opt':
            sscpFlag = True
            dceFlag = True
            simplifyFlag = True
        elif arg == '-simp':
            simplifyFlag = True
        else:
            filename = arg
    return filename

def main():
    filename = ''
    if len(sys.argv) < 2:
        print(f"Usage: compiler.py [flags] <*.mini>")
        sys.exit(1)
    elif len(sys.argv) >= 2:
        filename = parseFlags()

    filename_and_path = '.'.join(filename.split('.')[:-1]) 
    filename = filename_and_path.split('/')[-1]
    os.system(f'java -jar ./MiniCompiler.jar {filename_and_path}.mini > ../json/{filename}.json')

    structs, decls, funcs = TypeCheck.main(f'../json/{filename}.json')
    
    cfgs = CFG.buildCFGs(funcs)
    
    globalsLLVM = getGlobalLLVM(structs, decls)
    cfgsLLVM = {}
    if settings.getStackFlag():
        cfgsLLVM = stack.createLLVM(cfgs, funcs)
    else:
        cfgsLLVM = ssa.createLLVM(cfgs, funcs)
    allLLVM = globalsLLVM
    
    for func_id in cfgsLLVM.keys():
        allLLVM += cfgsLLVM[func_id]

    if not settings.getStackFlag():
        allLLVM = globalsLLVM
        if (sscpFlag):
            sscp(cfgs)
        if (dceFlag):
            dce(cfgs)
        if (simplifyFlag):
            simplify_cfg(cfgs)
            sscp(cfgs)
        for func_id in cfgs.keys():
            allLLVM += settings.updateCFG(cfgs[func_id], {}) + '}\n\n'
    with open(f'../ll/{filename}.ll', 'w') as f:
        f.write(allLLVM)

if __name__ == '__main__':
    main()