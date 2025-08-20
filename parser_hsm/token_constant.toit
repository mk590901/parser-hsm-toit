import .interfaces
import .token

class TokenConstant extends Token :
  
  constructor name/string : 
    super name TokenType.Operand

  toText -> string :
    return "$name\t$(TokenType.type getType)/Constant"

  isOperand -> bool :
    return true

  isOperator -> bool :
    return false

  isConstant -> bool :
    return true

  isVariable -> bool :
    return false
