::  Tests for +to (queue logic)
::
/+  *test
::
=>  ::  Utility core
    ::
    |%
    ++  list-to-qeu
      |=  l=(list @)
      ^-  (qeu @)
      (~(gas to `(qeu @)`~) l)
    --
::
=>  ::  Test Data
    ::
    |%
    +|  %test-suite
    ++  q-uno  (~(gas to *(qeu)) ~[42])
    ++  q-dos  (~(gas to *(qeu)) ~[6 9])
    ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
    ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
    ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
    ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
    ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
    ++  q-nul  (~(gas to *(qeu)) ~)
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
  =+  |%
      +|  %test-suite
      ++  q-uno  (~(gas to *(qeu)) ~[42])
      ++  q-dos  (~(gas to *(qeu)) ~[6 9])
      ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
      ++  q-tri  (~(gas to *(qeu)) ~[1 2 3])
      ++  q-tra  (~(gas to *(qeu)) ~[3 2 1])
      ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
      ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
      ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
      ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
      ++  q-nul  (~(gas to *(qeu)) ~)
      --
  =/  q-lis=(list (qeu))
    :~  q-nul  q-uno  q-dos  q-tre  q-tri
        q-tra  q-asc  q-des  q-uns  q-dup
    ==
  =/  actual=?
    %+  roll  q-lis
      |=  [s=(qeu) b=?]
      &(b ~(apt to s))
  ;:  weld
    ::  Checks with all tests in the suite
    ::
    %+  expect-eq
      !>  &
      !>  actual
    ::  Checks appending >1 elements
    ::
    %+  expect-eq
      !>  &
      !>  ~(apt to (~(gas to q-dos) ~[9 10]))
    ::  Checks adding existing elements
    ::
    %+  expect-eq
      !>  (~(gas to *(qeu)) (weld (gulf 1 7) (gulf 1 3)))
      !>  (~(gas to q-asc) (gulf 1 3))
  ==
::
::  head-rest pair
::
++  test-queue-get  ^-  tang
  =+  |%
      +|  %test-suite
      ++  q-nul  (~(gas to *(qeu)) ~)
      ++  q-uno  (~(gas to *(qeu)) ~[42])
      ++  q-dos  (~(gas to *(qeu)) ~[6 9])
      ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
      ++  q-tri  (~(gas to *(qeu)) ~[1 2 3])
      ++  q-tra  (~(gas to *(qeu)) ~[3 2 1])
      ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
      ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
      ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
      ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
      --
  =/  expected=(list (qeu))
    :~  q-uno  q-dos  q-tre  q-tri
        q-tra  q-asc  q-des  q-uns  q-dup
    ==
  =/  heads=(list)
    %+  turn  expected
      |=(q=(qeu) -:~(get to q))
  ;:  weld
    ::  Expects crash on empty list
    ::
    %-  expect-fail
      |.  ~(get to q-nul)
    ::  All tests in the suite
    ::
    %+  expect-eq
      !>  ~[42 6 1 1 3 1 7 1 1]
      !>  heads
  ==
::
::  Tests removing the root (more specialized balancing operation)
::
++  test-queue-nip  ^-  tang
  =+  |%
      +|  %test-suite
      ++  q-nul  (~(gas to *(qeu)) ~)
      ++  q-uno  (~(gas to *(qeu)) ~[42])
      ++  q-dos  (~(gas to *(qeu)) ~[6 9])
      ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
      ++  q-tri  (~(gas to *(qeu)) ~[1 2 3])
      ++  q-tra  (~(gas to *(qeu)) ~[3 2 1])
      ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
      ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
      ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
      ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
      --
  =/  expected=(list (qeu))
    :~  q-nul  q-uno  q-dos  q-tre  q-tri
        q-tra  q-asc  q-des  q-uns  q-dup
    ==
  =/  queues=(list (qeu))
    %+  turn  expected
      |=(q=(qeu) ~(nip to q))
  ::  The queue representation follows vertical ordering of the tree nodes
  ::  as to a min-heap (i.e. priority(parent node) < priority(children) )
  ::  after napping we check that the resulting tree is balance
  ::
  =/  actual=?
    %+  roll  queues
      |=([q=(qeu) a=?] &(a ~(apt to q)))
  %+  expect-eq
    !>  &
    !>  actual
::
::  Tests removing the root
::
::    TL;DR: current comment at L:1788 to %/sys/hoon/hoon.hoon is wrong
::    For a longer explanation read
::    https://github.com/urbit/urbit/issues/1577#issuecomment-483845590
::
++  test-queue-nap  ^-  tang
  =+  |%
      +|  %test-suite
      ++  q-nul  (~(gas to *(qeu)) ~)
      ++  q-uno  (~(gas to *(qeu)) ~[42])
      ++  q-dos  (~(gas to *(qeu)) ~[6 9])
      ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
      ++  q-tri  (~(gas to *(qeu)) ~[1 2 3])
      ++  q-tra  (~(gas to *(qeu)) ~[3 2 1])
      ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
      ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
      ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
      ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
      --
  =/  expected=(list [term (qeu)])
    :~  [%uno q-uno]  [%dos q-dos]  [%tres-1 q-tre]
        [%tres-2 q-tri]  [%tres-3 q-tra]  [%asc q-asc]
        [%des q-des]  [%uns q-uns]  [%dup q-dup]
    ==
  ::  The queue representation follows vertical ordering of the tree nodes
  ::  as to a min-heap (i.e. priority(parent node) < priority(children) )
  ::  after napping we check that the resulting tree is balance
  ::
  =/  queues=(list [term ?])
    %+  turn  expected
      |=([t=term q=(qeu)] [t ~(apt to ~(nap to q))])
  :: =/  actual=[term ?]
  ::   %+  roll  queues
  ::     |=([[t=term q=(qeu)] a=?] &(a ~(apt to q)))
  :: ;:  weld
    ::  All tests in the suite
    ::
    %-  zing
    ;:  weld
      %+  turn  queues
        |=  [t=term f=?]
        (expect-eq !>(t^&) !>(t^f))
      ::  Expects crash on empty list
      ::
      :_  ~
      %-  expect-fail
        |.  ~(nap to q-nul)
    ==
    ::  Expects crash on empty list
    ::
  ::   %-  expect-fail
  ::     |.  ~(nap to q-nul)
  :: ==
  :: =/  test
  ::   :~
  ::     ~(apt to (~(gas to *(qeu)) ~[1 2 3]))
  ::     ~(apt to (~(gas to *(qeu)) ~[1 3 2]))
  ::     ~(apt to (~(gas to *(qeu)) ~[2 1 3]))
  ::     ~(apt to (~(gas to *(qeu)) ~[2 3 1]))
  ::     ~(apt to (~(gas to *(qeu)) ~[3 2 1]))
  ::     ~(apt to (~(gas to *(qeu)) ~[3 1 2]))
  ::   ==
  :: =/  balance
  :: |=  a=(tree)
  :: ^+  a
  :: ?~  a  ~
  :: ~&  |(?=(~ l.a) (mor n.a n.l.a))
  :: ~&  |(?=(~ r.a) (mor n.a n.r.a))
  :: ?:  |(?=(~ l.a) (mor n.a n.l.a))
  ::   ?:  |(?=(~ r.a) (mor n.a n.r.a))
  ::     ~&  a
  ::     a
  ::   $(a [n.r.a $(a [n.a l.a l.r.a]) r.r.a])
  :: $(a [n.l.a l.l.a $(a [n.a r.l.a r.a])])
  ::
  :: (expect-eq !>(4) !>(2))

  :: =/  actual-qeus=(list (qeu @))
  ::   %+  turn  queues
  ::     |=(iq=(qeu @) ~(nap to iq))
  :: =/  expected-qeus=(list (qeu @))
  ::   %+  turn  lists
  ::     |=(l=(list @) (list-to-qeu (weld l ~[7])))
  :: %+  expect-eq
  ::   !>(actual-qeus)
  ::   !>(expected-qeus)
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
  :: =/  actual-qeus=(list (qeu @))
  ::   %+  turn  queues
  ::     |=(iq=(qeu @) (~(put to iq) 7))
  :: =/  expected-qeus=(list (qeu @))
  ::   %+  turn  lists
  ::     |=(l=(list @) (list-to-qeu (weld l ~[7])))
  :: %+  expect-eq
  ::   !>(actual-qeus)
  ::   !>(expected-qeus)
::
::  Tests producing a queue a as a list from front to back
::
++  test-queue-tap  ^-  tang
  =+  |%
      +|  %test-suite
      ++  q-nul  ~
      ++  q-uno  ~[42]
      ++  q-dos  ~[6 9]
      ++  q-tre  ~[1 0 1]
      ++  q-tri  ~[1 2 3]
      ++  q-tra  ~[1 3 2]
      ++  q-asc  ~[1 2 3 4 5 6 7]
      ++  q-des  ~[7 6 5 4 3 2 1]
      ++  q-uns  ~[1 6 3 5 7 2 4]
      ++  q-dup  ~[1 1 7 4 6 9 4]
      --
  =/  expected=(list (list))
    :~  q-nul  q-uno  q-dos  q-tre  q-tri
        q-tra  q-asc  q-des  q-uns  q-dup
    ==
  =/  queues=(list (qeu))
    %+  turn  expected
      |=(iq=(list) (~(gas to *(qeu)) iq))
  =/  actual=(list (list))
    %+  turn  queues
      |=(iq=(qeu) ~(tap to iq))
  %+  expect-eq
    !>  expected
    !>  actual
::
::  Tests producing the head of the queue
::
++  test-queue-top  ^-  tang
  =+  |%
      +|  %test-suite
      ++  q-nul  (~(gas to *(qeu)) ~)
      ++  q-uno  (~(gas to *(qeu)) ~[42])
      ++  q-dos  (~(gas to *(qeu)) ~[6 9])
      ++  q-tre  (~(gas to *(qeu)) ~[1 0 1])
      ++  q-tri  (~(gas to *(qeu)) ~[1 2 3])
      ++  q-tra  (~(gas to *(qeu)) ~[1 3 2])
      ++  q-asc  (~(gas to *(qeu)) ~[1 2 3 4 5 6 7])
      ++  q-des  (~(gas to *(qeu)) ~[7 6 5 4 3 2 1])
      ++  q-uns  (~(gas to *(qeu)) ~[1 6 3 5 7 2 4])
      ++  q-dup  (~(gas to *(qeu)) ~[1 1 7 4 6 9 4])
      --
  ::  We ran all the tests to the suite
  ::
  =/  queues=(list (qeu))
    :~  q-nul  q-uno  q-dos  q-tre  q-tri
        q-tra  q-asc  q-des  q-uns  q-dup
    ==
  =/  expected   ~[~ `42 `6 `1 `1 `1 `1 `7 `1 `1]
  =/  heads=(list (unit))
    %+  turn  queues
      |=(iq=(qeu) ~(top to iq))
  %+  expect-eq
    !>  expected
    !>  heads
::
--
