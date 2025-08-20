import monitor

//////////////////////////////////////////////////
//  class Queue
//////////////////////////////////////////////////
class Queue :
  _locker ::= monitor.Mutex
  _queue := []
  
  isEmpty :
    rc := false
    _locker.do :
      if (_queue.size == 0) :
        rc = true
    return rc
  
  put message :
    _locker.do :
      _queue.add message
    
  get :
    out := null
    _locker.do :
      if _queue.size > 0 :
        out = _queue[0]
        _queue.remove out
    return out 
    
  trace prompt :
    print ("$prompt$_queue")

//////////////////////////////////////////////////
//  Function create_key
//////////////////////////////////////////////////
create_key s/string t/string -> string :
  return "$s.$t"

//////////////////////////////////////////////////
//  class IQHsmStateMachineHelper
//////////////////////////////////////////////////
abstract class IQHsmStateMachineHelper :
  abstract get_state -> string
  abstract set_state state/string -> none
  abstract executor event/string -> ThreadedCodeExecutor?

//////////////////////////////////////////////////
//  class EventWrapper
//////////////////////////////////////////////////
class EventWrapper :
  _data/Object?
  _event/string
  
  constructor event/string data/Object? :
    _event = event
    _data = data
  
  data -> Object? :
    return _data
  
  event -> string :
    return _event

class StreamController :
  
  queue_      ::= Queue
  semaphore_  ::= monitor.Semaphore
  closed_     := false

  add data :
    if closed_: return
    queue_.put data
    semaphore_.up     // Up the semaphore, signaling a new element

  receive :
    if closed_ and queue_.isEmpty: return null
    semaphore_.down   // Waiting for the element to appear
    if closed_ and queue_.isEmpty: return null
    return queue_.get

  close :
    closed_ = true
    semaphore_.up     // Unlock pending tasks


class Publisher :

  streamController_/StreamController ::= ?

  constructor .streamController_/StreamController :

  post message/any -> none :
    streamController_.add message
    //sleep --ms = 0

  close -> none :
    streamController_.close


//////////////////////////////////////////////////
//  class Runner
//////////////////////////////////////////////////
class Runner:
  _helper/IQHsmStateMachineHelper? := null
  _streamController/StreamController := StreamController
  _publisher/Publisher := ?
  _taskRef := null
    
  constructor helper/IQHsmStateMachineHelper? :
    _helper = helper
    _publisher = Publisher _streamController
    _taskRef = task:: subscribe _streamController

  subscribe streamController/StreamController :
    while true :
      value := _streamController.receive
      if value == null: break
      event_wrapper/EventWrapper := value
      tc_executor := _helper.executor event_wrapper.event
      if (tc_executor == null) :
        print "post: failed to get executor for event ($event_wrapper.event)"
        return
      tc_executor.executeSync event_wrapper.data

  post event/string data/Object? -> none :
    _publisher.post (EventWrapper event data)
    
  stop :
    _streamController.close
    _taskRef.cancel
    _taskRef = null
  
//////////////////////////////////////////////////
//  class QHsmHelper
//////////////////////////////////////////////////
class QHsmHelper extends IQHsmStateMachineHelper :
  _state/string := ""
  _runner/Runner? := null
  _container/Map := {:}

  constructor state/string :
    _state = state
    _runner = Runner this
 
  get_state -> string :
    return _state
  
  set_state state/string -> none :
    _state = state
  
  executor event/string -> ThreadedCodeExecutor? :
    key/string := create_key _state event
    if not _container.contains key :
      print "runSync.error: $_state->$event"
      return null
    tc_executor := _container[key]
    return tc_executor
  
  insert state/string event/string tc_executor/ThreadedCodeExecutor :
    key/string := create_key state event
    _container[key] = tc_executor 

  post event/string data/any -> none :    
    _runner.post event data

  stop :
    _runner.stop
      
  
//////////////////////////////////////////////////
//  class ThreadedCodeExecutor
//////////////////////////////////////////////////
class ThreadedCodeExecutor :
  target_state_/string := ""
  helper_/IQHsmStateMachineHelper? := null
  container_/List := []
    
  constructor helper/IQHsmStateMachineHelper? target_state/string container/List :
    target_state_ = target_state
    helper_ = helper
    container_ = container
    
  executeSync data/any -> none :
    helper_.set_state target_state_
    container_.do : | fun/Lambda |
      fun.call data

