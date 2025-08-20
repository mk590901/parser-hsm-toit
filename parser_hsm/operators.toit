import .interfaces
import .operator

class Operators :
  container := {:}

  // Constructor
  constructor :
    createContainer

  contains name/string -> bool :
    return container.contains name

  containsPartially token/string -> bool :
    result/bool := false;
    dictionary/List := getKeys
    dictionary.do : | keyword |
      if keyword.contains token :
        return true
    return result

  getKeys -> List :
    return container.keys //.to_list

  getPrecedence name/string -> int :
    if container.contains name :
      return 0;
    return container[name].getPrecedence

  getOperator name/string -> IOperation? :
    if not container.contains name :
      return null;
    return container[name].getOperation

  createContainer -> none :

    addUnaryOperation   ")"   0  zero
    addUnaryOperation   "("   0  zero
    addBinaryOperation  "=="  1  opEq
    addBinaryOperation  "!="  1  opNe
    addBinaryOperation  "<>"  1  opNe
    addBinaryOperation  "&&"  1  opAnd
    addBinaryOperation  "||"  1  opOr

    addBinaryOperation  "*"   4  opMul
    addBinaryOperation  "/"   4  opDiv

    addBinaryOperation  "<"   2  opLt
    addBinaryOperation  ">"   2  opGt
    addBinaryOperation  ">="  2  opGe
    addBinaryOperation  "<="  2  opLe

    addBinaryOperation  "+"   3  opPlus
    addBinaryOperation  "-"   3  opMinus


    // addUnaryOperation   ")"   1  zero
    // addUnaryOperation   "("   1  zero
    // addBinaryOperation  "=="  4  opEq
    // addBinaryOperation  "!="  4  opNe
    // addBinaryOperation  "<>"  4  opNe
    // addBinaryOperation  "&&"  3  opAnd

    // addBinaryOperation  "*"   3  opMul
    // addBinaryOperation  "/"   3  opDiv

    // addBinaryOperation  "<"   4  opLt
    // addBinaryOperation  ">"   4  opGt
    // addBinaryOperation  ">="  4  opGe
    // addBinaryOperation  "<="  4  opLe

    // addBinaryOperation  "+"   4  opPlus
    // addBinaryOperation  "-"   4  opMinus

    // addBinaryOperation  "||"  2  opOr


  addBinaryOperation operationName/string precedence/int operation/IOperation? -> none :
    container[operationName] = Operator this operationName OperationType.BinaryOperation precedence operation

  addUnaryOperation operationName/string precedence/int operation/IOperation?  -> none :
    container[operationName] = Operator this operationName OperationType.UnaryOperation precedence operation

// Placeholder classes for operations
class zero implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opEq implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opNe implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opAnd implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opLt implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opGt implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opGe implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opLe implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opOr implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opPlus implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opMinus implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opMul implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";

class opDiv implements IOperation :
  execute parameters/List -> string :
    // Implementation here
    return "";
