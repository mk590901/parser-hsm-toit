import .interfaces
import .token

class TokenOperator extends Token :
  
  constructor name/string : 
    super name TokenType.Operator

  toText -> string :
    //return "$name\t$(TokenType.type getType)/Operator"
    return "$name\t$(TokenType.type getType)/$(TokenType.type getType)"

  isOperand -> bool :
    return false

  isOperator -> bool :
    return type == TokenType.Operator //true

  isConstant -> bool :
    return false

  isVariable -> bool :
    return false
