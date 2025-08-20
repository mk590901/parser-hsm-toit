//	File ParserHelper.toit included classes ParserHelper &
//	ParserComposer automatically generated at 2025-08-10 13:03:50

import .tc_core show *
import .parser_controller show *

//////////////////////////////////////////////////
//  Class ParserHelper
//////////////////////////////////////////////////
class ParserHelper :

  parserController/ParserController? := null

  composer_/ParserComposer := ParserComposer
  helper_/QHsmHelper := QHsmHelper "parser"

  constructor :
    create_helper

  create_helper -> none:

    helper_.insert "parser" "init" (ThreadedCodeExecutor helper_ "idle" (composer_.compose "parser.init"))
    helper_.insert "idle" "NextChar" (ThreadedCodeExecutor helper_ "WaitNextChar" (composer_.compose "idle.NextChar"))
    helper_.insert "EndToken" "NextChar" (ThreadedCodeExecutor helper_ "WaitNextChar" (composer_.compose "EndToken.NextChar"))
    helper_.insert "AccumulateKeyword" "NextChar" (ThreadedCodeExecutor helper_ "WaitNextChar" (composer_.compose "AccumulateKeyword.NextChar"))
    helper_.insert "AccumulateKeyword" "ValidChar" (ThreadedCodeExecutor helper_ "EndToken" (composer_.compose "AccumulateKeyword.ValidChar"))
    helper_.insert "AccumulateKeyword" "EOL" (ThreadedCodeExecutor helper_ "EndToken" (composer_.compose "AccumulateKeyword.EOL"))
    helper_.insert "AccumulateKeyword" "InvisibleChar" (ThreadedCodeExecutor helper_ "EndToken" (composer_.compose "AccumulateKeyword.InvisibleChar"))
    helper_.insert "AccumulateKeyword" "KeywordChar" (ThreadedCodeExecutor helper_ "AccumulateKeyword" (composer_.compose "AccumulateKeyword.KeywordChar"))
    helper_.insert "AccumulateToken" "NextChar" (ThreadedCodeExecutor helper_ "WaitNextChar" (composer_.compose "AccumulateToken.NextChar"))
    helper_.insert "AccumulateToken" "ValidChar" (ThreadedCodeExecutor helper_ "AccumulateToken" (composer_.compose "AccumulateToken.ValidChar"))
    helper_.insert "AccumulateToken" "EOL" (ThreadedCodeExecutor helper_ "EndToken" (composer_.compose "AccumulateToken.EOL"))
    helper_.insert "AccumulateToken" "InvisibleChar" (ThreadedCodeExecutor helper_ "EndToken" (composer_.compose "AccumulateToken.InvisibleChar"))
    helper_.insert "AccumulateToken" "KeywordChar" (ThreadedCodeExecutor helper_ "EndToken" (composer_.compose "AccumulateToken.KeywordChar"))
    helper_.insert "Stop" "NextChar" (ThreadedCodeExecutor helper_ "WaitNextChar" (composer_.compose "Stop.NextChar"))
    helper_.insert "Stop" "Reset" (ThreadedCodeExecutor helper_ "idle" (composer_.compose "Stop.Reset"))
    helper_.insert "WaitNextChar" "NextChar" (ThreadedCodeExecutor helper_ "WaitNextChar" (composer_.compose "WaitNextChar.NextChar"))
    helper_.insert "WaitNextChar" "ValidChar" (ThreadedCodeExecutor helper_ "AccumulateToken" (composer_.compose "WaitNextChar.ValidChar"))
    helper_.insert "WaitNextChar" "EOL" (ThreadedCodeExecutor helper_ "Stop" (composer_.compose "WaitNextChar.EOL"))
    helper_.insert "WaitNextChar" "KeywordChar" (ThreadedCodeExecutor helper_ "AccumulateKeyword" (composer_.compose "WaitNextChar.KeywordChar"))

  init -> none :
    helper_.post "init" 1

  run eventName/string -> none :
    helper_.post eventName 2

  state -> string :
    return helper_.get_state

  dispose :
    helper_.stop
    parserController.callback.execute parserController.tokens

  setController parserController_/ParserController -> none :
    parserController = parserController_
    composer_.setController parserController

//////////////////////////////////////////////////
//  class ParserComposer
//////////////////////////////////////////////////
class ParserComposer :
  
  parserController := null

  setController parserController_/ParserController -> none :
    parserController = parserController_

  //parser_entry data/any -> none :

  //parser_init data/any -> none :

  //idle_entry data/any -> none :

  idle_nextchar data/any -> none :
    if parserController == null :
      return
    parserController.getNewChar

  //waitNextChar_entry data/any -> none :

  endToken_nextchar data/any -> none :
    if parserController == null :
      return
    parserController.getNewChar

  //endToken_exit data/any -> none :

  //accumulateKeyword_exit data/any -> none :

  accumulateKeyword_validchar data/any -> none :
    if parserController == null :
      return
    parserController.setTokenV2

  //endToken_entry data/any -> none :

  accumulateKeyword_eol data/any -> none :
    if parserController == null :
      return
    parserController.setTokenV1

  accumulateKeyword_invisiblechar data/any -> none :
    if parserController == null :
      return
    parserController.setTokenV1

  accumulateKeyword_keywordchar data/any -> none :
    if parserController == null :
      return
    parserController.accumulateToken

  //accumulateKeyword_entry data/any -> none :

  //accumulateToken_exit data/any -> none :

  accumulateToken_validchar data/any -> none :
    if parserController == null :
      return
    parserController.accumulateToken

  //accumulateToken_entry data/any -> none :

  accumulateToken_eol data/any -> none :
    if parserController == null :
      return
    parserController.setTokenV1

  accumulateToken_invisiblechar data/any -> none :
    if parserController == null :
      return
    parserController.setTokenV1

  accumulateToken_keywordchar data/any -> none :
    if parserController == null :
      return
    parserController.setTokenV2

  //stop_exit data/any -> none :

  stop_reset data/any -> none :
    //print "stop_reset"

  //idle_exit data/any -> none :

  //waitNextChar_exit data/any -> none :

  waitNextChar_validchar data/any -> none :
    if parserController == null :
      return
    parserController.initToken

  waitNextChar_eol data/any -> none :
    if parserController == null :
      return
    parserController.stop

  //stop_entry data/any -> none :

  waitNextChar_keywordchar data/any -> none :
    //@print "waitNextChar_keywordchar"
    if parserController == null :
      return
    parserController.initToken

  compose key/string -> List :
    list/List := []

    if key == "parser.init" :
      //list.add :: | p | parser_entry p
      //list.add :: | p | parser_init p
      //list.add :: | p | idle_entry p
      return list

    if key == "idle.NextChar" :
      list.add :: | p | idle_nextchar p
      //list.add :: | p | waitNextChar_entry p
      return list

    if key == "EndToken.NextChar" :
      list.add :: | p | endToken_nextchar p
      //list.add :: | p | endToken_exit p
      //list.add :: | p | waitNextChar_entry p
      return list

    if key == "AccumulateKeyword.NextChar" :
      list.add :: | p | idle_nextchar p
      //list.add :: | p | accumulateKeyword_exit p
      //list.add :: | p | waitNextChar_entry p
      return list

    if key == "AccumulateKeyword.ValidChar" :
      list.add :: | p | accumulateKeyword_validchar p
      //list.add :: | p | accumulateKeyword_exit p
      //list.add :: | p | endToken_entry p
      return list

    if key == "AccumulateKeyword.EOL" :
      list.add :: | p | accumulateKeyword_eol p
      //list.add :: | p | accumulateKeyword_exit p
      //list.add :: | p | endToken_entry p
      return list

    if key == "AccumulateKeyword.InvisibleChar" :
      list.add :: | p | accumulateKeyword_invisiblechar p
      //list.add :: | p | accumulateKeyword_exit p
      //list.add :: | p | endToken_entry p
      return list

    if key == "AccumulateKeyword.KeywordChar" :
      list.add :: | p | accumulateKeyword_keywordchar p
      //list.add :: | p | accumulateKeyword_exit p
      //list.add :: | p | accumulateKeyword_entry p
      return list

    if key == "AccumulateToken.NextChar" :
      list.add :: | p | idle_nextchar p
      //list.add :: | p | accumulateToken_exit p
      //list.add :: | p | waitNextChar_entry p
      return list

    if key == "AccumulateToken.ValidChar" :
      list.add :: | p | accumulateToken_validchar p
      //list.add :: | p | accumulateToken_exit p
      //list.add :: | p | accumulateToken_entry p
      return list

    if key == "AccumulateToken.EOL" :
      list.add :: | p | accumulateToken_eol p
      //list.add :: | p | accumulateToken_exit p
      //list.add :: | p | endToken_entry p
      return list

    if key == "AccumulateToken.InvisibleChar" :
      list.add :: | p | accumulateToken_invisiblechar p
      //list.add :: | p | accumulateToken_exit p
      //list.add :: | p | endToken_entry p
      return list

    if key == "AccumulateToken.KeywordChar" :
      list.add :: | p | accumulateToken_keywordchar p
      //list.add :: | p | accumulateToken_exit p
      //list.add :: | p | endToken_entry p
      return list

    if key == "Stop.NextChar" :
      list.add :: | p | idle_nextchar p
      //list.add :: | p | stop_exit p
      //list.add :: | p | waitNextChar_entry p
      return list

    if key == "Stop.Reset" :
      list.add :: | p | stop_reset p
      //list.add :: | p | stop_exit p
      //list.add :: | p | idle_exit p
      //list.add :: | p | parser_init p
      //list.add :: | p | idle_entry p
      return list

    if key == "WaitNextChar.NextChar" :
      list.add :: | p | idle_nextchar p
      //list.add :: | p | waitNextChar_exit p
      //list.add :: | p | waitNextChar_entry p
      return list

    if key == "WaitNextChar.ValidChar" :
      list.add :: | p | waitNextChar_validchar p
      //list.add :: | p | waitNextChar_exit p
      //list.add :: | p | accumulateToken_entry p
      return list

    if key == "WaitNextChar.EOL" :
      list.add :: | p | waitNextChar_eol p
      //list.add :: | p | waitNextChar_exit p
      //list.add :: | p | stop_entry p
      return list

    if key == "WaitNextChar.KeywordChar" :
      list.add :: | p | waitNextChar_keywordchar p
      //list.add :: | p | waitNextChar_exit p
      //list.add :: | p | accumulateKeyword_entry p
      return list

    return list

