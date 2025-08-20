import .interfaces
import .parser_controller
import .token_variable

class Tokens :
  currentIndex/int            := 0
  container/List              := []
  controller := null

  constructor :
    container.clear

  add token/IToken -> none :
    container.add token

  get i/int -> IToken :
    return container[i]

  size -> int :
    return container.size

  reset -> none :
    currentIndex = 0

  is-empty -> bool :
    return container.is-empty

  last -> IToken :
    return container.last  

  hasMoreTokens -> bool :
    return (currentIndex < size)

  getNextToken -> any :
    if hasMoreTokens :
      return get (currentIndex++)
    return null

  extractVariables -> Tokens :
    result/Tokens := Tokens
    for i := 0; i < size; i++ :
      token/IToken := get i
      if token.isVariable :
        result.add (TokenVariable token.getName)
    return result

  trace text/string -> none :
    print "------- $text -------"
    for i := 0; i < size; i++ :
      token/IToken := get i
      line/string := "($i $token.toText"
      print "$i\t$token.toText"
    print "+++++++ $text +++++++"
 
  expression -> string :
    result/string := ""
    for i := 0; i < size; i++ :
      token/IToken := get i
      result += " " + token.getName
    return result  

  setController parserController/ParserController -> none :
    controller = parserController;

