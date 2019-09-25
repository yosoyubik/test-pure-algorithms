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
++  uno  ~[42]
++  dos  ~[6 9]
++  tre  ~[1 0 1]
++  asc  ~[1 2 3 4 5 6 7] ::         ::
++  des  ~[7 6 5 4 3 2 1] ::(flop ascending) ::~[6 5 4 3 2 1 0]
++  uns  ~[1 6 3 5 7 2 4]
++  dup  ~[1 1 7 4 6 9 4]
++  nul  ~
++  lis  (limo ~[uno dos tre asc des uns dup])
++  all  (turn lis list-to-set)
:: +|  %expected-values
++  tap-expected
  (limo ~[uno dos ~[1 0] asc des uns ~[9 7 6 4 1]])
  :: %+  roll
  ::   (turn lis |=(l=(list @) (sort l gth)))
  :: |=  [e=@ l=(list @)]
  :: ^-  (list @)
  :: ?~  l  (limo ~[e])
  :: :+  e
  ::   &(f =(sut.a sut.e))
  :: &(s =((sub val.a val.e) 1))
++  uni-expected   (limo ~[9 9 8 8 8 8 9])
++  wyt-expected   (limo ~[1 2 2 7 7 7 5])
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
::  Converts a set to list
::
++  test-set-tap    ^-  tang
  =/  lists-from-sets=(list (list @))
    %+  turn  all
      ::  resulting lists are sorted for proper list equality
      ::
      |=(s=(set @) (sort ~(tap in s) gth))
  %+  expect-eq
    !>  lists-from-sets
    !>  tap-expected
::
::  Test the union of sets
::
++  test-set-uni    ^-  tang
  =/  random-set=(set @)  (list-to-set (gulf 0 7))
  ::  Calculates the union of all sets in our suite with the random-set
  ::
  =/  uni-sets=(list (set @))
    %+  turn  all
      |=(s=(set @) (~(uni in s) random-set))
  %+  expect-eq
    !>  (turn uni-sets |=(s=(set @) ~(wyt in s)))
    !>  uni-expected
  ::  Tests that all items of set one are in set two
  ::
  ::  ?
::
::  Tests the size of set
::
++  test-set-wyt    ^-  tang
  ::  We ran all the tests in the suite
  ::
  =/  sizes=(list @)
    %+  turn  all
      |=(s=(set @) ~(wyt in s))
  %+  expect-eq
    !>  sizes
    !>  wyt-expected
--
