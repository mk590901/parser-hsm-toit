import .interfaces

class Token implements IToken :
  name/string := ""
  type := TokenType.Unknown

  constructor .name .type :

  getName -> string :
    return name

  setName name_/string :
    name = name_

  getType -> int :
    return type

  setType type_/int :
    type = type_

  isOperand -> bool :
    return false

  isOperator -> bool :
    return false

  isConstant -> bool :
    return false

  isVariable -> bool :
    return false

  toText -> string :
    //return "$name\t$type"
    return "$name\t$(TokenType.type type)"
