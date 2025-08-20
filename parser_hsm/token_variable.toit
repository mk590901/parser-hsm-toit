import .interfaces
import .token

class TokenVariable extends Token :
  
  constructor name/string : 
    super name TokenType.Operand

  toText -> string :
    return "$name\t$(TokenType.type getType)/Variable"

  isOperand -> bool :
    return true

  isOperator -> bool :
    return false

  isConstant -> bool :
    return false

  isVariable -> bool :
    return true
