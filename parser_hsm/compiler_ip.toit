import .interfaces
import .operators
import .parser_helper
import .token_constant
import .token_operator
import .token_variable
import .tokens
import .token

// prepare function
prepare infix/Tokens -> Tokens :
  result := Tokens
  for i := 0; i < infix.size; i++ :
    token := infix.get i
    if token.getName == "(" or token.getName == ")" :
      token.setType TokenType.Unknown
    result.add token
  return result

class CompilerInfixPostfix :
  infix_/Tokens? := null
  postfix_/Tokens? := null
  operators_/Operators? := null

  constructor tokens/Tokens operators/Operators :
    set-tokens tokens
    set-operators operators

  compile -> Tokens? :
    result/Tokens? := null
    try:
      result = riskyOperationWrapper (:: toPostfix infix_)
    finally:
    // Optional finally block, runs regardless of exception
      return result

  riskyOperationWrapper function/Lambda -> any :
    e := catch --trace=false :
      return function.call
    if e:
      print "Exception: $e.stringify"
    return "*** Error ***"


  toPostfix infix/Tokens -> Tokens :
    if infix.size == 0 :
      throw "FormatException: Expression is empty"

    input := prepare infix  // Assume prepare is defined elsewhere
    output := Tokens
    operatorStack := []  // Using List as a stack
    tokens := input
    openParenCount := 0

    // Checking the token sequence
    for i := 0; i < tokens.size; i++:
      token := tokens.get i

      // Checking for invalid characters
      if not token.isOperand and not token.isOperator and token.getName != "(" and token.getName != ")":
        throw "FormatException: Invalid character or token: $token"

      // Checking the correctness of the sequence
      if i > 0:
        prevToken := tokens.get (i - 1)
        if token.isOperator and prevToken.isOperator:
          throw "FormatException: Two operators in a row: $(prevToken.getName) $(token.getName)"
        if token.getName == "(" and prevToken.isOperand:
          throw "FormatException: Missing operator before opening parenthesis"
        if token.getName == ")" and prevToken.getName == "(":
          throw "FormatException: Empty parentheses"

      // Token processing
      if token.isOperand :
        output.add token
      else if token.isOperator :
        while not operatorStack.is-empty and
            operatorStack.first.getName != "(" and
            (precedence_ operatorStack.first) >= (precedence_ token) :
          output.add (operatorStack.remove --at=0)
        operatorStack.insert --at=0 token
      else if token.getName == "(":
        operatorStack.insert --at=0 token
        openParenCount++
      else if token.getName == ")":
        if openParenCount == 0:
          throw "FormatException: Mismatched closing parenthesis"
        while not operatorStack.is-empty and operatorStack.first.getName != "(" :
          output.add (operatorStack.remove --at=0)
        if operatorStack.is-empty :
          throw "FormatException: Mismatched closing parenthesis"
        operatorStack.remove --at=0  // Remove '('
        openParenCount--

    // Checking for unclosed parentheses
    if openParenCount > 0:
      throw "FormatException: Mismatched opening parenthesis"

    // Checking for operator at the end
    if not tokens.is-empty and tokens.last.isOperator:
      throw "FormatException: Expression ends with an operator \"$(tokens.last.getName)\""

    // Take out remaining operators
    while not operatorStack.is-empty :
      op := operatorStack.remove --at=0
      if op.getName == "(" or op.getName == ")":
        throw "FormatException: Mismatched parenthesis"
      output.add op

    return output

  get-tokens -> Tokens? :
    return infix_

  set-tokens tokens/Tokens :
    infix_ = tokens

  get-operators -> Operators? :
    return operators_

  set-operators operators/Operators:
    operators_ = operators

  precedence_ token/IToken -> int:
    return operators_.getPrecedence token.getName
  
    