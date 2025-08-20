import .interfaces
import .operators
import .parser_helper
import .token_constant
import .token_operator
import .token_variable
import .tokens
import .compiler_ip

class Function :
  execute tokens/Tokens :
    print "\nInfix:   $tokens.expression"
    infix/Tokens := prepare tokens
    compiler/CompilerInfixPostfix := CompilerInfixPostfix infix Operators
    result/Tokens? := compiler.compile
    if result == null :
      print "*** Failed to convert infix expression to Polish notation ***"
    else :  
      print "Postfix: $result.expression"

class ParserController :
  source/string       := ?
  index/int           := 0
  currentChar/string  := ""
  token/string        := ""
  operators/Operators := ?
  result              := null
  tokens/Tokens       := Tokens

  stateMachine/ParserHelper := ?

  callback/Function   := ?

  constructor .source .operators .callback/Function :
    stateMachine = ParserHelper
    stateMachine.setController this
    tokens.setController this
    stateMachine.init
    init

  parse -> none :
    stateMachine.run "NextChar"

  dispose -> none :
    stateMachine.dispose

  getSource -> string :
    return source

  getIndex -> int :
    return index

  setIndex index_/int -> none :
    index = index_

  getCurrentChar -> string :
    return currentChar

  setCurrentChar currentChar_/string -> none : 
    currentChar = currentChar_

  getToken -> string :
    return token

  setToken token_/string -> none :
    token = token_

  addToken symbol/string -> none :
    token += symbol;
  
  getResult -> IFunctor :
    return result

  setResult result_/IFunctor -> none :
    result = result_

  getOperators -> Operators :
    return operators

  trace message/string -> none :
     print "D: $message"

  init -> none :
    setIndex 0

  stopParsing -> none :
    setIndex 0

  accumulateToken -> none :
    addToken getCurrentChar
    getNewChar

  tokenIsKeyword token/string -> bool :
    return operators.contains token

  charIsKeywordChar symbol/string -> bool :
    return operators.containsPartially symbol

  setTokenV1 -> none :
    tokens.add (createToken token)
    setToken ""
    stateMachine.run "NextChar"

  setTokenV2 -> none :
    tokens.add (createToken token)
    setToken ""
    setIndex (getIndex - 1)
    stateMachine.run "NextChar"

  createToken tokenName/string -> IToken :
    t/IToken := ?
    tokenType/int := getTokenTypeEnum tokenName
    if tokenType == TokenType.Operator :
      t = TokenOperator tokenName
    else :
      if tokenName.contains "." :
        t = TokenVariable tokenName
      else :
        t = TokenConstant tokenName
    return t

  getTokenType token/string -> string :
    return tokenIsKeyword token ? "Operator" : "Operand";

  getTokenTypeEnum token/string -> int :
    return tokenIsKeyword token ? TokenType.Operator : TokenType.Operand

  initToken -> none :
    setToken ""
    stateMachine.run (checkCharacter getCurrentChar)

  stop -> none :
    //trace "ParserController.stop"
    stopParsing
    dispose

  setError -> none : 
    trace "ParserController.setError"

  getNewChar -> none :
    if (index >= source.size) :
      stateMachine.run "EOL"
      return;
    setCurrentChar (source[index..index+1])
    index++;
    testEvent/string := checkCharacter getCurrentChar
    stateMachine.run testEvent

  checkCharacter currentChar/string -> string :
    if (currentChar[0] <= 32) :
      return "EOL"
    else if (charIsKeywordChar currentChar) :
      return "KeywordChar"
    else :
      return "ValidChar"

  getTokens -> Tokens :
    return tokens
