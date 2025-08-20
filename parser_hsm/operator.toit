import .interfaces
import .operators

class Operator :
  name/string           := ""
  type                  := OperationType.Unknown
  operation/IOperation  := ?
  precedence/int        := 0
  parent/Operators      := ?

  // Constructor
  constructor .parent .name .type .precedence .operation :

  getName -> string :
    return name;

  setName name_/string :
    name = name_

  getType -> any :
    return type

  getOperation -> IOperation :
    return operation

  setOperation operation_/IOperation :
    operation = operation_


  getParent -> Operators :
    return parent

  setParent parent_/Operators :
    parent = parent_

  getPrecedence -> int :
    return precedence

  setPrecedence precedence_/int :
    precedence_ = precedence

