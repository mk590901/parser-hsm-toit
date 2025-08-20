class TokenType :
  static Unknown  ::= 0
  static Operand  ::= 1
  static Operator ::= 2

  static type value -> string :
    ident/string := "" 
    if value == Unknown :
      ident = "Unknown"
    else if value == Operand :
      ident = "Operand"
    else if value == Operator :
      ident = "Operator"
    return ident

class OperationType :
  static Unknown          ::= 0
  static BinaryOperation  ::= 1
  static UnaryOperation   ::= 2

  static type value -> string :
    ident/string := "" 
    if value == Unknown :
      ident = "Unknown"
    else if value == BinaryOperation :
      ident = "BinaryOperation"
    else if value == UnaryOperation :
      ident = "UnaryOperation"
    return ident

interface IToken :
  getName -> string
  setName name/string -> none
  getType -> int
  setType type/int -> none

  toText -> string

  isOperand   -> bool
  isOperator  -> bool
  isConstant  -> bool
  isVariable  -> bool

interface IOperation :
  execute parameters/List -> string

interface IFunctor :
  execute -> none
