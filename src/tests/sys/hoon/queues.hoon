::  Tests for +to (queue logic )
::
/+  *test
::
=>
::  Utility core
::
|%
++  list-to-qeu
  |=  l=(list @)
  ^-  (qeu @)
  (~(gas to `(qeu @)`~) l)
--
::
=>
::  Test Data
::
|%

++  ascending      ~[1 2 3 4 5 6 7] ::(gulf 0 7)           ::
++  descending     ~[7 6 5 4 3 2 1] ::(flop ascending) ::~[6 5 4 3 2 1 0]
++  unsorted       ~[1 6 3 5 7 2 4]
++  duplicates     ~[1 1 7 4 6 9 4]
++  lists          :~  descending
                       ascending
                       unsorted
                       duplicates
                   ==
++  uno            ~[42]
++  dos            ~[6 9]
++  tres           ~[1 0 1]
++  empty          ~
++  queues         (turn lists list-to-qeu)
++  unqueue
  .
  :: |=  [queue=(qeu @) test=(list @)]
  :: %-  zing
  :: |-  ^-  (list tang)
  :: ?~  test   ~
  :: ?~  queue  ~
  :: :_  $(queue ~(nap to queue), test t.test)
  :: %+  expect-eq
  ::   !>  (need ~(top to queue))
  ::   !>  i.test
--
::  Testing arms
::
|%
::  check correctness
::
++  test-queue-apt  ^-  tang
  (expect-eq !>(4) !>(4))
::
::  Balances the queue
::
++  test-queue-bal  ^-  tang
  (expect-eq !>(4) !>(4))
::
::  max depth of queue
::
++  test-queue-dep  ^-  tang
  (expect-eq !>(4) !>(4))
::
::  insert list to que
::
++  test-queue-gas  ^-  tang
  (expect-eq !>(4) !>(4))
::
::  head-rest pair
::
++  test-queue-get  ^-  tang
  (expect-eq !>(4) !>(4))
::
::  Tests removing the root (more specialized balancing operation)
::
++  test-queue-nip  ^-  tang
  (expect-eq !>(4) !>(4))
::
::  Tests removing the root
::
::    TL;DR: current comment at L:1788 in %/sys/hoon/hoon.hoon is wrong
::    For a longer explanation read
::    https://github.com/urbit/urbit/issues/1577#issuecomment-483845590
::
++  test-queue-nap  ^-  tang
  =/  actual-qeus=(list (qeu @))
    %+  turn  queues
      |=(iq=(qeu @) ~(nap to iq))
  =/  expected-qeus=(list (qeu @))
    %+  turn  lists
      |=(l=(list @) (list-to-qeu (weld l ~[7])))
  %+  expect-eq
    !>(actual-qeus)
    !>(expected-qeus)
    :: 1 1 1
    :: 1 1 2
    :: 1 1 3
    :: 1 2 1
    :: 1 2 3
    :: 1 3 1
    :: 1 3 2
    :: 1 3 3
    :: 2 1 1
    :: 2 1 2
    :: 2 1 3
    :: 2 2 1
    :: 2 2 2
    :: 2 2 3
    :: 2 3 1
    :: 2 3 2
    :: 2 3 3
    :: 3 1 1
    :: 3 1 2
    :: 3 1 3
    :: 3 2 1
    :: 3 2 2
    :: 3 2 3
    :: 3 3 1
    :: 3 3 2
    :: 3 3 3
::
::  Tests inserting new tail
::
++  test-queue-put  ^-  tang
  =/  actual-qeus=(list (qeu @))
    %+  turn  queues
      |=(iq=(qeu @) (~(put to iq) 7))
  =/  expected-qeus=(list (qeu @))
    %+  turn  lists
      |=(l=(list @) (list-to-qeu (weld l ~[7])))
  %+  expect-eq
    !>(actual-qeus)
    !>(expected-qeus)
::
::  Tests producing a queue a as a list from front to back
::
++  test-queue-tap  ^-  tang
  =/  front-list=(list (list @))
    %+  turn  queues
      |=(iq=(qeu @) ~(tap to iq))
  %+  expect-eq
    !>(front-list)
    !>(`(list (list @))`lists)
::
::  Tests producing the head of the queue
::
++  test-queue-top  ^-  tang
  =/  heads=(list @)
    %+  turn  queues
      |=(iq=(qeu @) (need ~(top to iq)))
  %+  expect-eq
    !>(heads)
    !>(`(list @)`~[7 1 1 1])
::
--
