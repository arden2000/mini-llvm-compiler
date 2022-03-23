import sys
import json

import AST
from AST import Type, Struct, Declaration, Function, Assignment, Print, Block, Conditional, Loop, Read, Bool, Void, Null, New, ID, Number, Selector, Unop, Binop, Delete, Invocation, Return
from json import JSONDecodeError

class TypeCheckNode:
   def __init__(self):
      self.left = None
      self.right = None
      self.hasReturn = False

funcs = []
decls = []
structs = []

def getIdType(varID, localVars, lineNum):
    '''
        searchs for given varID in local declarations, then in global declarations.
        if found, return the type associated with the varID
        else, prints error message and exits
    '''
    for var in localVars:
        if varID.id == var.id.id:
            return var.type
    for decl in decls:
        if decl.id.id == varID.id:
            varID.isGlobal = True
            return decl.type # a Type class
    if lineNum:
        print(f"Line {lineNum}: variable {varID.id} has not been declared")
    else:
        print(f"variable {varID.id} has not been declared")
    sys.exit(1)

def getBinopType(binop, localVars):
    '''
        binop: instance of binop class 
            checks that both left and right sides of binary operation are valid
        return: resulting type of binary operation
    '''
    arith_ops = ['+', '-', '*', '/']
    rel_ops = ['<', '>', '<=', '>=']
    eq_ops = ['==', '!=']
    bool_ops = ['&&', '||']
    left_op_type = getExpressionType(binop.left, localVars)
    right_op_type = getExpressionType(binop.right, localVars)
    binop.leftType = left_op_type
    binop.rightType = right_op_type
    if binop.rightType == Null and binop.leftType == Null:
        print(f"Line {binop.lineNum}: {binop.op} operator cannot have two null operands")
        sys.exit(1)

    if isinstance(left_op_type, Type):
        left_op_type = left_op_type.type
    if isinstance(right_op_type, Type):
        right_op_type = right_op_type.type

    if binop.op in arith_ops:
        if right_op_type != Number or left_op_type != Number:
            print(f"Line {binop.lineNum}: {binop.op} operator requires two integer operands")
            sys.exit(1)
        return Type(Number, 'int')
    elif binop.op in rel_ops:
        if right_op_type != Number or left_op_type != Number:
            print(f"Line {binop.lineNum}: {binop.op} operator requires two integer operands")
            sys.exit(1)
        return Type(Bool, 'bool')
    elif binop.op in eq_ops:
        if (right_op_type != left_op_type or right_op_type == Bool) and not ((right_op_type == Struct and left_op_type == Null) or (right_op_type == Null and left_op_type == Struct)):
            print(f"Line {binop.lineNum}: {binop.op} operator requires two integer or structure operands")
            sys.exit(1)
        return Type(Bool, 'bool')
    elif binop.op in bool_ops:
        if right_op_type != Bool or left_op_type != Bool:
            print(f"Line {binop.lineNum}: {binop.op} operator requires two boolean operands")
            sys.exit(1)
        return Type(Bool, 'bool')
    
def getUnopType(unop, localVars):
    '''
        unop: instance of Unop class
            checks that ! operation is used with a boolean type
            checks that - operation is used with a number type
        returns: Bool or Number class, depending on the unop.op operation
    '''
    opType = getExpressionType(unop.operand, localVars)
    if isinstance(opType, Type):
        opType = opType.type
    if unop.op == '!':
        if opType != Bool:
            print(f"Line {unop.lineNum}: {unop.op} requires a boolean operand")
            sys.exit(1)
        return Type(Bool, 'bool')
    elif unop.op == '-':
        if opType != Number:
            print(f"Line {unop.lineNum}: {unop.op} requires an integer operand")
            sys.exit(1)
        return Type(Number, 'int')


def getSelectorType(selector, localVars):
    '''
        selector: a selector class instance
            checks that selector.left is a struct
            checks that selector.id is a field of the struct
        returns: Type class instance for selector.id field of the struct
    '''
    leftType = getExpressionType(selector.left, localVars)
    # leftType must be a struct with a field selector.id
    if isinstance(leftType, Type) and leftType.type == Struct:
        leftStruct = getStruct(leftType.typeStr, selector.lineNum)
        for field in leftStruct.fields:
            if field.id.id == selector.id:
                selector.type = field.type
                return field.type
        print(f"Line {selector.lineNum}: struct {leftStruct.id} does not have field \'{selector.id}\'")
        sys.exit(1)
    print(f"Line {selector.lineNum}: left side of dot operation requires a structure type")
    sys.exit(1)


def getExpressionType(exp, localVars):
    '''
        exp: an object (hopefully of one of the expression types)
            routes the object to the appropriate getType function
        returns: A class denoting the type of the given object
    '''
    if isinstance(exp, Bool):
        return Type(Bool, 'bool')
    elif isinstance(exp, Binop):
        return getBinopType(exp, localVars)

    elif isinstance(exp, Unop):
        return getUnopType(exp, localVars)
    elif isinstance(exp, Selector):
        return getSelectorType(exp, localVars) # a Type object
    elif isinstance(exp, Number):
        return Type(Number, 'int')
    elif isinstance(exp, ID):
        exp.type = getIdType(exp, localVars, None) # a Type object
        return exp.type
    elif isinstance(exp, New):
        getStruct(exp.id, exp.lineNum) # validates that the struct type has been declared
        exp.type = Type(Struct, exp.id)
        return  exp.type # a Type object
    elif isinstance(exp, Invocation):
        checkInvocationValid(exp, localVars)
        return getFunc(exp.id, exp.lineNum).retType # a Type object
    elif isinstance(exp, Null): 
        return Null
    elif isinstance(exp, Read):
        return Number
    else:
        print("huhhhhhhhhh")
        print(type(exp))
        sys.exit(1)

def checkStatementValid(stmt, localVars):
    '''
        stmt: an object (hopefully of one of the statement types)
            routes the object to the appropriate checkStmt function
        returns: None
    '''
    if isinstance(stmt, Block):
        checkBlockValid(stmt, localVars)
    elif isinstance(stmt, Assignment):
        checkAssignmentValid(stmt, localVars)
    elif isinstance(stmt, Print):
        checkPrintValid(stmt, localVars)
    elif isinstance(stmt, Conditional):
        checkConditionalValid(stmt, localVars)
    elif isinstance(stmt, Loop):
        checkLoopValid(stmt, localVars)
    elif isinstance(stmt, Delete):
        checkDeleteValid(stmt, localVars)
    elif isinstance(stmt, Return):
        checkReturnValid(stmt, localVars)
    elif isinstance(stmt, Invocation):
        checkInvocationValid(stmt, localVars)

def checkInvocationValid(invocation, localVars):
    '''
        invocation: instance of Invocation class
            checks if invocation.id is an existing function
            checks that the type of invocation.args matches the type of the function parameters
        return: None
    '''
    func = getFunc(invocation.id, invocation.lineNum) # finding invoked function
    invocation.retType = func.retType
    if len(invocation.args) != len(func.params): # if function params and invocation args length dont match, error and exit
        print(f"Line {invocation.lineNum}: function {invocation.id} takes {len(func.params)} arguments, {len(invocation.args)} were given")
        sys.exit(1)
    for i in range(len(invocation.args)): # go through params and args and make sure types align
        argType = getExpressionType(invocation.args[i], localVars)
        
        if argType == func.params[i].type.type:
            invocation.argTypes.append(argType)
        elif isinstance(argType, Type) and argType.typeStr == func.params[i].type.typeStr:
            invocation.argTypes.append(argType)
        elif func.params[i].type.type == Struct and argType == Null:
            invocation.argTypes.append(func.params[i].type)
        else:
            print(f"Line {invocation.lineNum}: argument {i + 1} of function {invocation.id} requires a {func.params[i].type.typeStr} type")
            sys.exit(1)
    
def checkReturnValid(returnStmt, localVars):
    '''
        returnStmt: instance of Return class
            checks that the given return expression is valid, if one is given
        returns: None
    '''
    if returnStmt.retExp:
        retType = getExpressionType(returnStmt.retExp, localVars)
        returnStmt.retType = retType

def checkDeleteValid(delete, localVars):
    '''
        delete: instance on Delete class
            checks if the expression to delete is a structure reference
        returns: None
    '''
    deleteType = getExpressionType(delete.delExp, localVars)
    delete.type = deleteType
    if not isinstance(deleteType, Type) or deleteType.type != Struct:
        print(f"Line {delete.lineNum}: delete can only deallocate a struct")
        sys.exit(1)
    
def checkLoopValid(loop, localVars):
    '''
        loop: instance of Loop class
            checks if the guard is a valid expression
            checks if the guard is of Bool type
        returns: None
    '''
    guardType = getExpressionType(loop.guard, localVars)
    if not isinstance(guardType, Type) or guardType.type != Bool:
        print(f"Line {loop.lineNum}: \'while\' condition must evaluate to a boolean value")
        sys.exit(1)  
    checkStatementValid(loop.body, localVars)
    
def checkConditionalValid(cond, localVars):
    '''
        cond: instance of Conditional class
            checks if cond.guard is a valid expression and returns a Bool type
            checks if cond.then is a valid statement
            checks if cond.else is a valid statement, if it exists
        
    '''
    guardType = getExpressionType(cond.guard, localVars)
    if not isinstance(guardType, Type) or guardType.type != Bool:
        print(f"Line {cond.lineNum}: \'if\' condition must evaluate to a boolean value")
        sys.exit(1)  
    checkStatementValid(cond.then, localVars)
    if cond.else_: 
        checkStatementValid(cond.else_, localVars)

def checkPrintValid(printStmt, localVars):
    '''
        printStmt: instance on Print class
            checks if the printStmt.exp is a valid expression
            checks if the printStmt.exp is of Number type
        returns: None
    '''
    outType = getExpressionType(printStmt.exp, localVars)
    if not isinstance(outType, Type) or outType.type != Number:
        print(f"Line {printStmt.lineNum}: print requires integer argument")
        sys.exit(1)   

# struct A = null is valid, fix later
def checkAssignmentValid(assignment, localVars):
    '''
        assignment: instance on Assignment class
            checks if the assignment.source is a valid expression
            checks if the assignment.target is a valid expression
            checks if the type of assignment.source matches the type of assignment.target
        returns: None
    '''
    sourceType = getExpressionType(assignment.source, localVars)
    targetType = getExpressionType(assignment.target, localVars)
    #print("source: ", sourceType.typeStr)
    #print("target: ", targetType.typeStr)
    # types dont match or source is a Type object and you need the extra comparison
    if isinstance(sourceType, Type) and targetType.typeStr != sourceType.typeStr:
        print(f"Line {assignment.lineNum}: assignment types must match")
        sys.exit(1)  
    elif isinstance(targetType.type, Struct) and sourceType != Null:
        print(f"Line {assignment.lineNum}: assignment types must match")
        sys.exit(1)
        

def checkBlockValid(block, localVars):
    '''
        block: instance on Block class
            checks if every statment in block.stmt is a valid statement
        returns: None
    '''
    for stmt in block.stmts:
        checkStatementValid(stmt, localVars)

def main(json_file=None): 
    try:
        with open(json_file, 'r') as f:
            json_data = json.loads(f.read())
    except FileNotFoundError:
        print(f'File not found: {json_file}')
        sys.exit(1)  
    except JSONDecodeError:
        print(f'Usage: TypeCheck.py [flags] <*.json>')
        sys.exit(1)     
        
    global structs
    global decls
    global funcs
    structs = AST.parseStructs(json_data['types'])
    decls = AST.parseDeclarations(json_data['declarations'])
    for decl in decls:
        decl.id.isGlobal = True
    funcs = AST.parseFunctions(json_data['functions'])

    checkDeclarationsValid(decls)
    checkFuncsRedeclared(funcs)
    checkStructsRedeclared(structs)
    findMain(funcs)

    for func in funcs:
        checkStatementValid(func.body, func.decls + func.params)
        cfg = TypeCheckNode()
        buildCFG(func.body, func.decls + func.params, func.retType, func.id, cfg)
        if not checkReturnPath(cfg, {}) and func.retType.type != Void :
            print(f"All paths through function \'{func.id}\' must have a return statement")
            sys.exit(1)
    return structs, decls, funcs

def buildCFG(body, localVars, retType, funcID, node):
    '''
        body: function body
        localVars: local declarations and parameters of function
        retType: return type of function 
        funcID: id of function
        node: top level node to build the cfg on
            Builds a Control Flow Graph for the given function. 
            Branches on Conditionals and Loops
            Checks if return statements match the function return type
        return: a cfg containing Nodes, where each Node represents a basic block of code (basic block = chunk of code that is guaranteed to execute all the way through)
    '''
    for stmt in body.stmts:
        if isinstance(stmt, Conditional):
            continueNode = TypeCheckNode()
            node.left = TypeCheckNode()
            thenFinal = buildCFG(stmt.then, localVars, retType, funcID, node.left)
            thenFinal.left = continueNode
            if (stmt.else_):
                node.right = TypeCheckNode()
                elseFinal = buildCFG(stmt.else_, localVars, retType, funcID, node.right)
                elseFinal.right = continueNode
            else:
                node.right = continueNode
            node = continueNode
        elif isinstance(stmt, Loop):
            continueNode = TypeCheckNode()
            node.left = TypeCheckNode()
            bodyFinal = buildCFG(stmt.body, localVars, retType, funcID, node.left)
            bodyFinal.left = continueNode
            node.right = continueNode
            node = continueNode
        elif isinstance(stmt, Block):
            node = buildCFG(stmt, localVars, retType, funcID, node)
        elif isinstance(stmt, Return):
            if (stmt.retExp):
                retExpType = getExpressionType(stmt.retExp, localVars)
            else:
                retExpType = Type(Void, 'void')
            if isinstance(retExpType, Type) and retExpType.typeStr != retType.typeStr:
                print(f"Line {stmt.lineNum}: return statement must match the declared return type for function \'{funcID}\': {retType.typeStr}")
                sys.exit(1)
            else:
                stmt.retType = retType
                node.hasReturn = True
    return node

def checkReturnPath(cfg, visited):
    '''
        cfg: a tree made up of Nodes
        return: False if there is a path through the tree that does not contain a node with Node.hasReturn set to true, True if no such path exists.
    '''
    visited[cfg] = True
    if cfg.hasReturn:
        return True    
    if cfg.left and cfg.right and not visited.get(cfg.left) and not visited.get(cfg.right):
        return checkReturnPath(cfg.left, visited) and checkReturnPath(cfg.right, visited)
    elif cfg.right and not visited.get(cfg.left):
        return checkReturnPath(cfg.right, visited)
    elif cfg.left and not visited.get(cfg.left):
        return checkReturnPath(cfg.left, visited)
    elif visited.get(cfg.left) or visited.get(cfg.right):
        return True
    else:
        return False

def parseFlags(argv):
    return argv

def checkDeclarationsValid(decls):
    '''
        decls: list of Declaration objects
            checks if variables are redeclared
            if the variable is a structure, checks if that structure exists 
        returns: None
    '''
    declarations = {}
    for decl in decls:
        if declarations.get(decl.id): # if declaration already exists, print error and exit
            print(f"Line {decl.lineNum}: identifiers cannot be redeclared: {decl.id}")
            sys.exit(1)
        else:
            declarations[decl.id] = 1
        if decl.type.type == Struct:
            getStruct(decl.type.typeStr, decl.lineNum) # check if structType is one of the structs created
    
def checkStructsRedeclared(structs):
    '''
        structs: list of Struct objects
            checks if any structs are redeclared
            checks if any fields of a struct are redeclared
        returns: None
    '''
    structIDs = {}
    for struct in structs:
        if structIDs.get(struct.id):
            print(f"Line {struct.lineNum}: structs cannot be redeclared: {struct.id}")
            sys.exit(1)
        else:
            structIDs[struct.id] = 1
        checkDeclarationsValid(struct.fields)

def checkFuncsRedeclared(funcs):
    '''
        funcs: list of Function objects
            checks if functions are redeclared
            checks if func.params are valid declarations
            checks if func.decls are valid declarations
            checks if func.retType is valid
        returns: None
    '''
    funcsIDs = {}
    for func in funcs:
        if funcsIDs.get(func.id): 
            print(f"Line {func.lineNum}: functions cannot be redeclared: {func.id}")
            sys.exit(1)
        else:
            funcsIDs[func.id] = 1
        localVars = func.params + func.decls
        checkDeclarationsValid(localVars)
        if func.retType.type == Struct:
            getStruct(func.retType.typeStr, func.lineNum)

def findMain(funcs):
    '''
        funcs: list of Function objects
            checks if fun main() int has been declared
        returns: None
    '''
    for func in funcs:
        if func.id == 'main' and func.retType.type == Number and not func.params:
            return
    print("Program must include main function: fun main() int")
    sys.exit(1)

def getFunc(name, lineNum):
    '''
        name: function name
        returns: the instance of a Function object with name 'name' if found, None otherwise
    '''
    for func in funcs:
        if func.id == name:
            return func
    # if invoked function does not exist, error and exit
    print(f"Line {lineNum}: function {name} has not been declared")
    sys.exit(1)

def getStruct(structTypeStr, lineNum):
    '''
        structTypeStr: the type of struct you are searching for
        returns: the struct class
    '''
    #print(len(structs))
    for struct in structs:
        #print(f'{struct.id} == {structTypeStr}')
        if struct.id == structTypeStr:
            return struct
    print(f"Line {lineNum}: struct {structTypeStr} does not exist")
    sys.exit(1)


if __name__ == '__main__':
    main()