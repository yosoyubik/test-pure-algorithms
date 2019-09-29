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
      ::
      ::  The +uni:in arm has currently an issue coming from the fact that
      ::  +mor follows non-strict ordering (mor 1 1) -> %.y
      ::  which causes that the comparison of equality[1] between the nodes from
      ::  from the different maps is never reached.
      ::
      ::  The new arms proposed here to replace +uni:in called +union removes
      ::  the equality comparison that is never reached.
      ::
      ::  The new arm is tested in this suite togetther with +uni.
      ::
      ::  Notes:
      ::  [1]
      ::  https://github.com/urbit/urbit/blob/master/pkg/arvo/sys/hoon.hoon#L1536
      ::
      ++  union
        |=  [a=(set @) b=(set @)]
        |-  ^+  a
        ?~  b
          a
        ?~  a
          b
        ?:  (mor n.a n.b)
          ?:  =(n.b n.a)
            [n.b $(a l.a, b l.b) $(a r.a, b r.b)]
          ?:  (gor n.b n.a)
            $(a [n.a $(a l.a, b [n.b l.b ~]) r.a], b r.b)
          $(a [n.a l.a $(a r.a, b [n.b ~ r.b])], b l.b)
        ?:  (gor n.a n.b)
          $(b [n.b $(b l.b, a [n.a l.a ~]) r.b], a r.a)
        $(b [n.b l.b $(b r.b, a [n.a ~ r.a])], a l.a)
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
  ::  manually constructed sets with predefined vertical/horizontal
  ::  ordering
  ::
  ::  for the following three elements (1, 2, 3) the vertical priorities are:
  ::    > (mug (mug 1))
  ::    1.405.103.437
  ::    > (mug (mug 2))
  ::    1.200.431.393
  ::    > (mug (mug 3))
  ::    1.576.941.407
  ::
  ::  and the ordering 2 < 1 < 3
  ::  a correctly balanced tree stored as a min-heap
  ::  should have node=2 as the root
  ::
  ::  The horizontal priorities are:
  ::    > (mug 1)
  ::    1.901.865.568
  ::    > (mug 2)
  ::    1.904.972.904
  ::    > (mug 3)
  ::    1.923.673.882
  ::
  ::  and the ordering 1 < 2 < 3.
  ::  1 should be in the left brach and 3 in the right one.
  ::
  =/  balanced-a=(set @)    [2 [1 ~ ~] [3 ~ ~]]
  ::  doesn't follow vertical ordering
  ::
  =/  unbalanced-a=(set @)  [1 [2 ~ ~] [3 ~ ~]]
  ::  doesn't follow horizontal ordering
  ::
  =/  unbalanced-b=(set @)  [2 [3 ~ ~] [1 ~ ~]]
  ::  doesn't follow horizontal & vertical ordering
  ::
  =/  unbalanced-c=(set @)  [1 [3 ~ ~] [2 ~ ~]]
  ;:  weld
    (expect-eq !>(b-a+%.y) !>(b-a+~(apt in balanced-a)))
    (expect-eq !>(u-a+%.n) !>(u-a+~(apt in unbalanced-a)))
    (expect-eq !>(u-b+%.n) !>(u-b+~(apt in unbalanced-b)))
    (expect-eq !>(u-c+%.n) !>(u-c+~(apt in unbalanced-c)))
  ==
::  splits a in b
::
++  test-set-bif  ^-  tang
  =/  s-asc=(set @)   (sy (gulf 1 7))
  =/  s-nul=(set @)   *(set @)
  =/  splits-a=[(set) (set)]  (~(bif in s-asc) 99)
  =/  splits-b=[(set) (set)]  (~(bif in s-asc) 6)
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  [~ ~]
      !>  (~(bif in s-nul) 1)
    ::  Checks bifurcating in non-existing element
    ::
    ::  The traversal of the +map is done comparing the 2x +mug
    ::  of the added node and the existing one from the tree.
    ::  Because of this, the search will stop at different leaves,
    ::  based on the value of the hash, therefore the right and left
    ::  maps that are returned can be different
    ::  (null or a less than the total number of nodes)
    ::  The best way to check is that the sum of the number of nodes
    ::  in both maps are the same as before, and that both returned
    ::  sets are correct
    ::
    %+  expect-eq
      !>  7
      !>  (add ~(wyt in -.splits-a) ~(wyt in +.splits-a))
    %+  expect-eq
      !>  %.y
      !>  &(~(apt in -.splits-a) ~(apt in +.splits-a))
    ::  Checks splitting in existing element
    ::
    %+  expect-eq
      !>  6
      !>  (add ~(wyt in -.splits-b) ~(wyt in +.splits-b))
    %+  expect-eq
      !>  %.y
      !>  &(~(apt in -.splits-b) ~(apt in +.splits-b))
    =/  left   (~(has in -.splits-b) 6)
    =/  right  (~(has in +.splits-b) 6)
    %+  expect-eq
      !>  %.n
      !>  &(left right)
  ==
:: b without any a
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
      !>  (~(dif in *(set)) ~)
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
  =/  custom  [2 [1 ~ ~] [3 ~ ~]]
  =/  manual-set=(set @)  custom
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(dig in *(set)) 6)
    ::  Checks with non-existing key
    ::
    %+  expect-eq
      !>  ~
      !>  (~(dig in manual-set) 9)
    ::  Checks success via tree addressing. We use the return axis
    ::  to address the raw noun and check that it gives the corresponding
    ::  from the key.
    ::
    %+  expect-eq
      !>  1
      !>  +:(slot (need (~(dig in manual-set) 1)) !>(custom))
    %+  expect-eq
      !>  2
      !>  +:(slot (need (~(dig in manual-set) 2)) !>(custom))
    %+  expect-eq
      !>  3
      !>  +:(slot (need (~(dig in manual-set) 3)) !>(custom))
  ==
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
    ::
    ::  Tests for the +union arm
    ::
    ::  Checks with empty map (a or b)
    ::
    %+  expect-eq
      !>  s-des
      !>  (union s-nul s-des)
    %+  expect-eq
      !>  s-des
      !>  (union s-des s-nul)
    ::  Checks with no intersection
    ::
    =/  a=(set @)  (sy (scag 4 asc))
    =/  b=(set @)  (sy (slag 4 asc))
    %+  expect-eq
      !>  (list-to-set asc)
      !>  (union a b)
    ::  Checks union with equal sets
    ::
    %+  expect-eq
      !>  s-asc
      !>  (union s-asc s-des)
    ::  Checks union with partial intersection
    ::
    %+  expect-eq
      !>  s-asc
      !>  (union s-asc (sy (gulf 1 3)))
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
