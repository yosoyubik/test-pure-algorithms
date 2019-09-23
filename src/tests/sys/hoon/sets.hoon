::  Tests for +to (queue logic )
::
/+  *test
::
=>
::  Utility core
::
|%
++  list-to-set
  |=  l=(list @)  ^-  (set @)
  (sy l)
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
++  sets           (turn lists list-to-set)
++  length         7
++  unqueue
  .
:: +|  %expected-values
++  uni-expected   `(list @)`~[8 8 8 9]
++  wyt-expected   `(list @)`~[7 7 7 5]
:: ++  tap-expected
::   %+  turn  lists
::     |=  l=(list @)  ^-  (list @)
::     =?(l =((lent (sy l)) 5) ~[22] l)
::     (sort l lth)
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
::  logical AND
::
++  test-set-all    ^-  tang
  (expect-eq !>(4) !>(4))
::  logical OR
::
++  test-set-any    ^-  tang
  (expect-eq !>(4) !>(4))
::  check correctness
::
++  test-set-apt    ^-  tang
  (expect-eq !>(4) !>(4))
::  splits a by b
::
++  test-set-bif    ^-  tang
  (expect-eq !>(4) !>(4))
:: ::  b without any a
::
++  test-set-del    ^-  tang
  (expect-eq !>(4) !>(4))
::  difference
::
++  test-set-dif    ^-  tang
  (expect-eq !>(4) !>(4))
::  axis of a in b
::
++  test-set-dig    ^-  tang
  (expect-eq !>(4) !>(4))
::  concatenate
::
++  test-set-gas    ^-  tang
  (expect-eq !>(4) !>(4))
::  +has: does :b exist in :a?
::
++  test-set-has    ^-  tang
  (expect-eq !>(4) !>(4))
  ::  wrap extracted item type in a unit because bunting fails
  ::
  ::    If we used the real item type of _?^(a n.a !!) as the sample type,
  ::    then hoon would bunt it to create the default sample for the gate.
  ::
  ::    However, bunting that expression fails if :a is ~. If we wrap it
  ::    in a unit, the bunted unit doesn't include the bunted item type.
  ::
  ::    This way we can ensure type safety of :b without needing to perform
  ::    this failing bunt. It's a hack.
  ::
::
::  intersection
::
++  test-set-int    ^-  tang
  (expect-eq !>(4) !>(4))
::
::  puts b in a, sorted
::
::
++  test-set-put    ^-  tang
  (expect-eq !>(4) !>(4))
::  replace by product
::
++  test-set-rep    ^-  tang
  (expect-eq !>(4) !>(4))
::
::  apply gate to values
::
++  test-set-run    ^-  tang
  (expect-eq !>(4) !>(4))
::
::  convert to list
::
++  test-set-tap    ^-  tang
  (expect-eq !>(4) !>(4))
  :: =/  lists-from-sets=(list (list @))
  ::   %+  turn  sets
  ::     ::  resulting lists are sorted since +set is not ordered
  ::     ::
  ::     |=(s=(set @) (sort ~(tap in s) lth))
  :: %+  expect-eq
  ::   !>(lists-from-sets)
  ::   !>(tap-expected)
::
::  union
::
++  test-set-uni    ^-  tang
  =/  random-set=(set @)
    (list-to-set (gulf 0 length))
  ::  Tests that the resulting length is the correct
  ::
  =/  uni-sets=(list (set @))
    %+  turn  sets
      |=(s=(set @) (~(uni in s) random-set))
  %+  expect-eq
    !>((turn uni-sets |=(s=(set @) ~(wyt in s))))
    !>(uni-expected)
  ::  Tests that all items of set one are in set two
  ::
::
::  Tests the size of set
::
++  test-set-wyt    ^-  tang
  =/  sizes=(list @)
    %+  turn  sets
      |=(s=(set @) ~(wyt in s))
  ~&  sizes
  %+  expect-eq
    !>(sizes)
    !>(wyt-expected)
::
--
