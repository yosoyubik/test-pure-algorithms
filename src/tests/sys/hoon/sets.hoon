::  Tests for +to (queue logic )
::
/+  *test
::
=>  ::  Utility core
    ::
    |%
    ++  list-to-set
      |=  l=(list @)  ^-  (set @)
      (sy l)
    --
::
::  Testing arms
::
|%
::  logical AND
::
++  test-set-all  ^-  tang
  =/  s-asc=(set @)   (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  &
      !>  (~(all in ~) |=(* &))
    %+  expect-eq
      !>  &
      !>  (~(all in ~) |=(* |))
    ::  Checks one element fails
    ::
    %+  expect-eq
      !>  |
      !>  (~(all in (sy ~[1])) |=(e=@ =(e 43)))
    ::  Checks not all elements pass
    ::
    %+  expect-eq
      !>  |
      !>  (~(all in s-asc) |=(e=@ (lth e 4)))
    ::  Checks all element pass
    ::
    %+  expect-eq
      !>  &
      !>  (~(all in s-asc) |=(e=@ (lth e 100)))
  ==
::  logical OR
::
++  test-set-any  ^-  tang
  =/  s-asc=(set @)   (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  |
      !>  (~(any in ~) |=(* &))
    %+  expect-eq
      !>  |
      !>  (~(any in ~) |=(* |))
    ::  Checks one element fails
    ::
    %+  expect-eq
      !>  |
      !>  (~(any in (sy ~[1])) |=(e=@ =(e 43)))
    ::  Checks >1 element success
    ::
    %+  expect-eq
      !>  &
      !>  (~(any in s-asc) |=(e=@ (lth e 4)))
    ::  Checks all element success
    ::
    %+  expect-eq
      !>  &
      !>  (~(any in s-asc) |=(e=@ (lth e 100)))
  ==
::  check correctness
::
++  test-set-apt  ^-  tang
  (expect-eq !>(4) !>(2))
::  splits a in b
::
++  test-set-bif  ^-  tang
  (expect-eq !>(4) !>(2))
:: ::  b without any a
::
++  test-set-del  ^-  tang
  =/  s-asc=(set @)   (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  ~
      !>  (~(del in ~) 1)
    ::  Checks deleting non-existing element
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(del in s-asc) 99)
    ::  Checks deleting the only element
    ::
    %+  expect-eq
      !>  ~
      !>  (~(del in (sy ~[1])) 1)
    ::  Checks deleting one element
    ::
    %+  expect-eq
      !>  (sy (gulf 1 6))
      !>  (~(del in s-asc) 7)
  ==
::  difference
::
++  test-set-dif  ^-  tang
  =/  s-des=(set @)   (sy (flop (gulf 1 7)))
  =/  s-asc=(set @)   (sy (gulf 1 7))
  =/  s-dos=(set @)   (sy ~[8 9])
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  ~
      !>  (~(dif in ~) ~)
    %+  expect-eq
      !>  s-asc
      !>  (~(dif in s-asc) ~)
    ::  Checks with equal sets
    ::
    %+  expect-eq
      !>  ~
      !>  (~(dif in s-asc) s-des)
    ::  Checks no elements in common
    ::
    %+  expect-eq
      !>  s-dos
      !>  (~(dif in s-dos) s-asc)
    ::  Checks with sets of diferent size
    ::
    %+  expect-eq
      !>  s-dos
      !>  (~(dif in (sy ~[1 8 9])) s-asc)
  ==
::  axis of a in b
::
++  test-set-dig  ^-  tang
  (expect-eq !>(4) !>(2))
::  concatenate
::
++  test-set-gas  ^-  tang
  ::  we use +apt to check the correctness
  ::  of the sets created with +gas
  ::
  =+  |%
      +|  %test-suite
      ++  s-uno  (~(gas in *(set)) ~[42])
      ++  s-dos  (~(gas in *(set)) ~[6 9])
      ++  s-tre  (~(gas in *(set)) ~[1 0 1])
      ++  s-asc  (~(gas in *(set)) ~[1 2 3 4 5 6 7])
      ++  s-des  (~(gas in *(set)) ~[7 6 5 4 3 2 1])
      ++  s-uns  (~(gas in *(set)) ~[1 6 3 5 7 2 4])
      ++  s-dup  (~(gas in *(set)) ~[1 1 7 4 6 9 4])
      ++  s-nul  (~(gas in *(set)) ~)
      --
  =/  s-lis=(list (set))  ~[s-nul s-uno s-dos s-tre s-asc s-des s-uns s-dup]
  =/  actual=?
    %+  roll  s-lis
      |=  [s=(set) b=?]
      ^-  ?
      &(b ~(apt in s))
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
      !>  ~(apt in (~(gas in s-dos) ~[9 10]))
    ::  Checks concatenating existing elements
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(gas in s-asc) (gulf 1 3))
  ==
::  +has: does :b exist in :a?
::
++  test-set-has  ^-  tang
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
  =/  s-nul=(set @)  *(set @)
  =/  s-asc=(set @)  (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  |
      !>  (~(has in s-nul) 6)
    ::  Checks with non-existing key
    ::
    %+  expect-eq
      !>  |
      !>  (~(has in s-asc) 9)
    ::  Checks success
    ::
    %+  expect-eq
      !>  &
      !>  (~(has in s-asc) 7)
  ==
::
::  intersection
::
++  test-set-int  ^-  tang
  =/  s-nul=(set @)  *(set @)
  =/  s-asc=(set @)  (sy (gulf 1 7))
  =/  s-des=(set @)  (sy (flop (gulf 1 7)))
  =/  s-dos=(set @)  (sy (gulf 8 9))
  =/  s-dup  (sy ~[1 1 4 1 3 5 9 4])
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int in s-nul) s-asc)
    %+  expect-eq
      !>  ~
      !>  (~(int in s-asc) s-nul)
    ::  Checks with all elements different
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int in s-dos) s-asc)
    ::  Checks success (total intersection)
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(int in s-asc) s-des)
    ::  Checks success (partial intersection)
    ::
    %+  expect-eq
      !>  (sy ~[9])
      !>  (~(int in s-dos) s-dup)
  ==
::
::  puts b in a, sorted
::
::
++  test-set-put  ^-  tang
  =/  s-nul=(set @)  *(set @)
  =/  s-asc=(set @)  (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  (sy ~[6])
      !>  (~(put in s-nul) 6)
    ::  Checks with existing key
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(put in s-asc) 6)
    ::  Checks adding new element
    ::
    %+  expect-eq
      !>  (sy (gulf 1 8))
      !>  (~(put in s-asc) 8)
  ==
::  replace in product
::
++  test-set-rep  ^-  tang
  =/  s-nul=(set @)  *(set @)
  =/  s-asc=(set @)  (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty set
    ::
    %+  expect-eq
      !>  b=0
      !>  (~(rep in s-nul) add)
    ::  Checks success
    ::
    %+  expect-eq
      !>  b=28
      !>  (~(rep in s-asc) add)
  ==
::
::  apply gate to values
::
++  test-set-run  ^-  tang
  =/  s-nul  *(set @)
  =/  s-asc  (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(run in s-nul) dec)
    ::  Checks success
    ::
    %+  expect-eq
      !>  (sy (gulf 0 6))
      !>  (~(run in s-asc) dec)
  ==
::
::  Converts a set to list
::
++  test-set-tap  ^-  tang
  =/  s-dup  (sy ~[1 1 4 1 3 5 9 4])
  =/  s-asc  (sy (gulf 1 7))
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  ~(tap in *(set @))
    ::  Checks with duplicates
    ::
    %+  expect-eq
      !>  (sort ~[1 4 3 5 9] gth)
      !>  (sort ~(tap in s-dup) gth)
    ::  Checks with ascending list
    ::
    %+  expect-eq
      !>  (gulf 1 7)
      !>  (sort ~(tap in s-asc) lth)
  ==
::
::  Test the union of sets
::
++  test-set-uni  ^-  tang
  =/  asc=(list @)    (gulf 1 7)
  =/  des=(list @)    (flop (gulf 1 7))
  =/  s-des=(set @)   (sy des)
  =/  s-asc=(set @)   (sy asc)
  =/  s-nul=(set @)   *(set @)
  ;:  weld
    ::  Checks with empty map (a or b)
    ::
    %+  expect-eq
      !>  s-des
      !>  (~(uni in s-nul) s-des)
    %+  expect-eq
      !>  s-des
      !>  (~(uni in s-des) s-nul)
    ::  Checks with no intersection
    ::
    =/  a=(set @)  (sy (scag 4 asc))
    =/  b=(set @)  (sy (slag 4 asc))
    %+  expect-eq
      !>  (list-to-set asc)
      !>  (~(uni in a) b)
    ::  Checks union with equal sets
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(uni in s-asc) s-des)
    ::  Checks union with partial intersection
    ::
    %+  expect-eq
      !>  s-asc
      !>  (~(uni in s-asc) (sy (gulf 1 3)))
  ==
::
::  Tests the size of set
::
++  test-set-wyt  ^-  tang
  ::  We ran all the tests in the suite
  ::
  =+  |%
      +|  %actual
      ++  s-uno  (list-to-set (limo ~[42]))
      ++  s-dos  (list-to-set (limo ~[6 9]))
      ++  s-tre  (list-to-set (limo ~[1 0 1]))
      ++  s-asc  (list-to-set (limo ~[1 2 3 4 5 6 7]))
      ++  s-des  (list-to-set (limo ~[7 6 5 4 3 2 1]))
      ++  s-uns  (list-to-set (limo ~[1 6 3 5 7 2 4]))
      ++  s-dup  (list-to-set (limo ~[1 1 7 4 6 9 4]))
      ++  s-nul  (list-to-set (limo ~))
      ++  s-lis  (limo ~[s-nul s-uno s-dos s-tre s-asc s-des s-uns s-dup])
      +|  %expected
      ++  wyt-expected   (limo ~[0 1 2 2 7 7 7 5])
      --
  =/  sizes=(list @)
    %+  turn  s-lis
      |=(s=(set @) ~(wyt in s))
  %+  expect-eq
    !>  sizes
    !>  wyt-expected
--
