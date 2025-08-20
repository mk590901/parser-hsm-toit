import expect show *
import .tc_core show *
import .parser_helper show *
import .token_constant show *
import .token_operator show *
import .token_variable show *
import .operators show *
import .parser_controller show *

main :

  print "Test in progress..."

  checkParserControllerOne
  checkParserControllerTwo
  checkParserControllerThree
  checkParserControllerFour

checkParserControllerOne :
  parserController/ParserController := ParserController "ZwLight.Brightness >= 50" Operators Function
  expect-equals (parserController == null) false 
  parserController.parse
  // sleep --ms = 1000
  // expect-equals 3 parserController.tokens.size

checkParserControllerTwo :
  parserController/ParserController := ParserController "ZwLight.Brightness >= (50+4*8-BLE.Light.Brightness)" Operators Function
  expect-equals (parserController == null) false 
  parserController.parse
  // sleep --ms = 2000
  // expect-equals 11 parserController.tokens.size

checkParserControllerThree :
  parserController/ParserController := ParserController "ZwLight.Brightness * (Z1+2)" Operators Function
  expect-equals (parserController == null) false 
  parserController.parse
  // sleep --ms = 2000
  // expect-equals 11 parserController.tokens.size

checkParserControllerFour :
  error/bool := false
  parserController/ParserController := ParserController "ZwLight.Brightness * ((Z1+2) * " Operators Function
  expect-equals (parserController == null) false 
  parserController.parse
