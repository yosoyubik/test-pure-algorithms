::  Tests for +to (queue logic)
::
/+  *test
::
=>  ::  Test Data
    ::
    |%
    +|  %test-suite
    ++  l-uno  ~[42]
    ++  l-dos  ~[6 9]
    ++  l-tre  ~[1 0 1]
    ++  l-tri  ~[1 2 3]
    ++  l-tra  ~[3 2 1]
    ++  l-asc  ~[1 2 3 4 5 6 7]
    ++  l-des  ~[7 6 5 4 3 2 1]
    ++  l-uns  ~[1 6 3 5 7 2 4]
    ++  l-dup  ~[1 1 7 4 6 9 4]
    ::  we tagged each entry in the test suite to easily identify
    ::  the +to arm that fails with a specific queue.
    ::
    ++  q-nul  [%nul (~(gas to *(qeu)) ~)]
    ++  q-uno  [%uno (~(gas to *(qeu)) l-uno)]
    ++  q-dos  [%dos (~(gas to *(qeu)) l-dos)]
    ++  q-tre  [%tre (~(gas to *(qeu)) l-tre)]
    ++  q-tri  [%tri (~(gas to *(qeu)) l-tri)]
    ++  q-tra  [%tra (~(gas to *(qeu)) l-tra)]
    ++  q-asc  [%asc (~(gas to *(qeu)) l-asc)]
    ++  q-des  [%des (~(gas to *(qeu)) l-des)]
    ++  q-uns  [%uns (~(gas to *(qeu)) l-uns)]
    ++  q-dup  [%dup (~(gas to *(qeu)) l-dup)]
    +|  %grouped-data
    ++  queues  ^-  (list [term (qeu)])
      :~  q-uno  q-dos  q-tre
          q-tri  q-tra  q-asc
          q-des  q-uns  q-dup
      ==
    ++  lists  ^-  (list (list))
      :~  l-uno  l-dos  l-tre
          l-tri  l-tra  l-asc
          l-des  l-uns  l-dup
      ==
    --
::  Testing arms
::
|%
::  check correctness
::
++  test-queue-apt  ^-  tang
  (expect-eq !>(4) !>(2))
::
::  Balances the queue
::
++  test-queue-bal  ^-  tang
  (expect-eq !>(4) !>(2))
::
::  max depth of queue
::
++  test-queue-dep  ^-  tang
  (expect-eq !>(4) !>(2))
::
::  insert list to que
::
++  test-queue-gas  ^-  tang
  ::  we use +apt to check the correctness
  ::  of the queues created with +gas
  ::
  :: =+  |%
  ::     +|  %test-suite
  ::     ++  q-uno  (~(gas to *(qeu)) ~[42])
  ::     ++  q-dos  (~(gas to *(qeu)) ~[6 9])
  ::     ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
  ::     ++  q-tri  (~(gas to *(qeu)) ~[1 2 3])
  ::     ++  q-tra  (~(gas to *(qeu)) ~[3 2 1])
  ::     ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
  ::     ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
  ::     ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
  ::     ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
  ::     ++  q-nul  (~(gas to *(qeu)) ~)
  ::     --
  :: =/  q-lis=(list (qeu))
  ::   :~  q-nul  q-uno  q-dos  q-tre  q-tri
  ::       q-tra  q-asc  q-des  q-uns  q-dup
  ::   ==
  :: =/  actual=?
  ::   %+  roll  queues
  ::     |=  [[term s=(qeu)] b=?]
  ::     &(b ~(apt to s))
  =/  actual=(list [term ?])
    %+  turn  queues
      |=  [t=term s=(qeu)]
      [t ~(apt to s)]
  %-  zing
  ;:  weld
    ::  Checks with all tests in the suite
    ::
    %+  turn  actual
      |=  [t=term f=?]
      %+  expect-eq
        !>  t^&
        !>  t^f
    ::  Checks appending >1 elements
    ::
    :_  ~
    %+  expect-eq
      !>  &
      !>  ~(apt to (~(gas to +:q-dos) ~[9 10]))
    ::  Checks adding existing elements
    ::
    :_  ~
    %+  expect-eq
      !>  (~(gas to *(qeu)) (weld (gulf 1 7) (gulf 1 3)))
      !>  (~(gas to +:q-asc) (gulf 1 3))
  ==
  :: ;:  weld
  ::   ::  Checks with all tests in the suite
  ::   ::
  ::   %+  expect-eq
  ::     !>  &
  ::     !>  actual
  ::   ::  Checks appending >1 elements
  ::   ::
  ::   %+  expect-eq
  ::     !>  &
  ::     !>  ~(apt to (~(gas to q-dos) ~[9 10]))
  ::   ::  Checks adding existing elements
  ::   ::
  ::   %+  expect-eq
  ::     !>  (~(gas to *(qeu)) (weld (gulf 1 7) (gulf 1 3)))
  ::     !>  (~(gas to q-asc) (gulf 1 3))
  :: ==
::
::  head-rest pair
::
++  test-queue-get  ^-  tang
  =/  expected=(map term [@ (qeu)])
    %-  my
    :~  uno+[42 ~]
        dos+[6 (~(gas to *(qeu)) ~[9])]
        tre+[1 (~(gas to *(qeu)) ~[0 1])]
        tri+[1 (~(gas to *(qeu)) ~[2 3])]
        tra+[3 (~(gas to *(qeu)) ~[2 1])]
        asc+[1 (~(gas to *(qeu)) ~[2 3 4 5 6 7])]
        des+[7 (~(gas to *(qeu)) ~[6 5 4 3 2 1])]
        uns+[1 (~(gas to *(qeu)) ~[6 3 5 7 2 4])]
        dup+[1 (~(gas to *(qeu)) ~[1 7 4 6 9 4])]
    ==
  =/  pairs=(list [term [* (qeu)]])
    %+  turn  queues
      |=([t=term q=(qeu)] [t ~(get to q)])
  %-  zing
  ;:  weld
    ::  All tests in the suite
    ::
    %+  turn  pairs
      |=  [t=term p=[* (qeu)]]
      %+  expect-eq
        !>  t^(~(got by expected) t)
        !>  t^p
    ::  Expects crash on empty list
    ::
    :_  ~
    %-  expect-fail
      |.  ~(get to +:q-nul)
  ==
::
::  Tests removing the root (more specialized balancing operation)
::
++  test-queue-nip  ^-  tang
  =/  actual=(list [term ?])
    %+  turn  queues
      ::  The queue representation follows vertical ordering
      ::  of the tree nodes as a min-heap
      ::  [i.e. priority(parent node) < priority(children)]
      ::  after nip we check that the resulting tree is balanced
      ::
      |=([t=term q=(qeu)] [t ~(apt to ~(nip to q))])
    %-  zing
    ;:  weld
      ::  All tests in the suite
      ::
      %+  turn  actual
        |=  [t=term f=?]
        (expect-eq !>(t^&) !>(t^f))
      ::  Expects crash on empty list
      ::
      :_  ~
      %-  expect-fail
        |.  ~(nap to +:q-nul)
    ==
::
::  Tests removing the root
::
::    TL;DR: current comment at L:1788 to %/sys/hoon/hoon.hoon is wrong
::    For a longer explanation read
::    https://github.com/urbit/urbit/issues/1577#issuecomment-483845590
::
++  test-queue-nap  ^-  tang

  =/  actual=(list [term ?])
    %+  turn  queues
      ::  The queue representation follows vertical ordering
      ::  of the tree nodes as a min-heap
      ::  [i.e. priority(parent node) < priority(children)]
      ::  after nip we check that the resulting tree is balanced
      ::
      |=([t=term q=(qeu)] [t ~(apt to ~(nap to q))])
    %-  zing
    ;:  weld
      ::  All tests in the suite
      ::
      %+  turn  actual
        |=  [t=term f=?]
        (expect-eq !>(t^&) !>(t^f))
      ::  Expects crash on empty list
      ::
      :_  ~
      %-  expect-fail
        |.  ~(nap to +:q-nul)
    ==
::
::  Tests inserting new tail
::
++  test-queue-put  ^-  tang
  =/  q-uno  (~(gas to *(qeu)) ~[42])
  =/  q-asc  (~(gas to *(qeu)) (gulf 1 7))
  =/  q-dos  (~(gas to *(qeu)) ~[42 43])
  ;:  weld
    ::  Checks with empty queue
    ::
    %+  expect-eq
      !>  q-uno
      !>  (~(put to *(qeu)) 42)
    ::  Checks putting existing element
    ::
    =/  q-dup  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7 6])
    %+  expect-eq
      !>  q-dup
      !>  (~(put to q-asc) 6)
    ::  Checks putting a new element
    ::
    %+  expect-eq
      !>  (~(gas to *(qeu)) (gulf 1 8))
      !>  (~(put to q-asc) 8)
  ==
::
::  Tests producing a queue a as a list from front to back
::
++  test-queue-tap  ^-  tang
  ::  We ran all queues in the suite against the corresponding lists
  ::
  =/  queues=(list (qeu))
    %+  turn  lists
      |=(iq=(list) (~(gas to *(qeu)) iq))
  =/  actual=(list (list))
    %+  turn  queues
      |=(iq=(qeu) ~(tap to iq))
  %+  expect-eq
    !>  lists
    !>  actual
::
::  Tests producing the head of the queue
::
++  test-queue-top  ^-  tang
  =/  expected=(map term @)
    %-  my
    :~  uno+42  dos+6  tre+1  tri+1
        tra+3   asc+1  des+7  uns+1  dup+1
    ==
  =/  heads=(list [term (unit)])
    %+  turn  queues
      |=([t=term iq=(qeu)] [t ~(top to iq)])
  %-  zing
  ;:  weld
    ::  All the tests to the suite
    ::
    %+  turn  heads
      |=  [t=term u=(unit)]
      %+  expect-eq
        !>  t^(~(get by expected) t)
        !>  t^u
    :_  ~
    ::  Top of an empty queue is ~
    ::
    (expect-eq !>(~) !>(~(top to +:q-nul)))
  ==
::
--
