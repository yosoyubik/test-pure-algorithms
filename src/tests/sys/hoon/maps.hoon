::  Tests for +in (map logic )
::
/+  *test
::
=>  ::  Utility core
    ::
    |%
    ++  map-of-doubles
      |=  l=(list @)
      ^-  (map @ @)
      %-  my
      ^-  (list (pair @ @))
      %+  turn  l
        |=  k=@
        [k (mul 2 k)]
    --
::
=>  ::  Test Data
    ::
    |%
    +|  %test-suite
    ++  m-uno  (map-of-doubles (limo ~[42]))
    ++  m-dos  (map-of-doubles (limo ~[6 9]))
    ++  m-tre  (map-of-doubles (limo ~[1 0 1]))
    ++  m-asc  (map-of-doubles (limo ~[1 2 3 4 5 6 7]))
    ++  m-des  (map-of-doubles (limo ~[7 6 5 4 3 2 1]))
    ++  m-uns  (map-of-doubles (limo ~[1 6 3 5 7 2 4]))
    ++  m-dup  (map-of-doubles (limo ~[1 1 7 4 6 9 4]))
    ++  m-nul  (map-of-doubles (limo ~))
    ++  m-lis  (limo ~[m-nul m-uno m-dos m-tre m-asc m-des m-uns m-dup])
    +|  %expected-values
    ++  wyt-expected   (limo ~[0 1 2 2 7 7 7 5])
    --
::  Testing arms
::
|%
::  Test logical AND
::
++  test-map-all    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  &
      !>  (~(all by m-nul) |=(* &))
    %+  expect-eq
      !>  &
      !>  (~(all by m-nul) |=(* |))
    ::  Checks one element fails
    ::
    %+  expect-eq
      !>  |
      !>  (~(all by m-uno) |=(e=@ =(e 43)))
    ::  Checks >1 element fails
    ::
    %+  expect-eq
      !>  |
      !>  (~(all by m-dos) |=(e=@ (lth e 4)))
    ::  Checks all elements pass
    ::
    %+  expect-eq
      !>  &
      !>  (~(all by m-des) |=(e=@ (lth e 80)))
  ==
::
::  Test logical OR
::
++  test-map-any    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  |
      !>  (~(any by m-nul) |=(* &))
    %+  expect-eq
      !>  |
      !>  (~(any by m-nul) |=(* |))
    ::  Checks one element fails
    ::
    %+  expect-eq
      !>  |
      !>  (~(any by m-uno) |=(e=@ =(e 43)))
    ::  Checks >1 element fails
    ::
    %+  expect-eq
      !>  |
      !>  (~(any by m-dos) |=(e=@ (lth e 4)))
    ::  Checks one element passes
    ::
    %+  expect-eq
      !>  &
      !>  (~(any by m-des) |=(e=@ =(e 14)))
    ::  Checks all element pass
    ::
    %+  expect-eq
      !>  &
      !>  (~(any by m-des) |=(e=@ (lth e 100)))
  ==
::
::  Test check correctnes (correct horizontal/vertical order)
::
++  test-map-apt    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  &
      !>  ~(apt by m-nul)
    ::
    ::  Checks wrong vertical ordering
    ::  (e.g. (mug mug (left branch)) > (mug mug node)
    ::
    :: ?~  m-asc
    ::   %+  expect-eq
    ::     !>  &
    ::     !>  ~(apt by m-nul)
    :: %+  expect-eq
    ::   !>  &
    ::   !>  ~(apt by m-nul)
    :: %+  expect-eq
    ::   !>  &
    ::   !>  (mor p.n.m-des ?~(l.des 0 p.n.l.m-des))
    ::  Checks wrong horizontal ordering
    ::
    ::  Checks all elements pass
    ::
    :: %+  expect-eq
    ::   !>  &
    ::   !>  ~(apt by des)
  ==
::
::  Test bifurcation (i.e. splits map a into two, discarding -.a)
::
++  test-map-bif    ^-  tang
  (expect-eq !>(4) !>(2))
::
::  Test delete at key b
::
++  test-map-del    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(del by m-nul) 1)
    ::  Checks deleting non-existing element
    ::
    %+  expect-eq
      !>  m-des
      !>  (~(del by m-des) 99)
    ::  Checks deleting the only element
    ::
    %+  expect-eq
      !>  ~
      !>  (~(del by m-uno) 42)
    ::  Checks deleting one element
    ::
    %+  expect-eq
      !>  (map-of-doubles (limo ~[6 5 4 3 2 1]))
      !>  (~(del by m-des) 7)
  ==
::
::  Test difference (removes elements of a present in b)
::
++  test-map-dif    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(dif by ~) ~)
    %+  expect-eq
      !>  m-dup
      !>  (~(dif by m-dup) m-nul)
    ::  Checks same elements, different ordering
    ::
    %+  expect-eq
      !>  ~
      !>  (~(dif by m-asc) m-des)
    ::  Checks different map length
    ::
    %+  expect-eq
      !>  (my ~[[7 14] [1 2] [4 8]])
      !>  (~(dif by m-dup) m-dos)
    ::  Checks no elements in common
    ::
    %+  expect-eq
      !>  m-uno
      !>  (~(dif by m-uno) m-dos)
  ==
::
::  Test axis of a in b
::
++  test-map-dig    ^-  tang
  (expect-eq !>(4) !>(2))
::  Test concatenate
::
++  test-map-gas    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  m-dos
      !>  (~(gas by m-nul) ~[[6 12] [9 18]])
    ::  Checks with > 1 element
    ::
    %+  expect-eq
      !>  (map-of-doubles (limo ~[42 10]))
      !>  (~(gas by m-uno) [10 20]~)
    ::  Checks appending >1 elements
    ::
    %+  expect-eq
      !>  (map-of-doubles (limo ~[6 9 3 4 5 7]))
      !>  (~(gas by m-dos) ~[[3 6] [4 8] [5 10] [7 14]])
    ::  Checks concatenating existing elements
    ::
    %+  expect-eq
      !>  m-des
      !>  (~(gas by m-des) ~[[3 6] [4 8] [5 10] [7 14]])
  ==
::
::  Test grab value by key
::
++  test-map-get    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(get by m-nul) 6)
    ::  Checks with non-existing key
    ::
    %+  expect-eq
      !>  ~
      !>  (~(get by m-des) 9)
    ::  Checks success
    ::
    %+  expect-eq
      !>  `14
      !>  (~(get by m-des) 7)
  ==
::
::  Test need value by key
::
++  test-map-got    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %-  expect-fail
      |.  (~(got by m-nul) 6)
    ::  Checks with non-existing key
    ::
    %-  expect-fail
      |.  (~(got by m-des) 9)
    ::  Checks success
    ::
    %+  expect-eq
      !>  14
      !>  (~(got by m-des) 7)
  ==
::
::  Test fall value by key
::
++  test-map-gut    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  42
      !>  (~(gut by m-nul) 6 42)
    ::  Checks with non-existing key
    ::
    %+  expect-eq
      !>  42
      !>  (~(gut by m-des) 9 42)
    ::  Checks success
    ::
    %+  expect-eq
      !>  14
      !>  (~(gut by m-des) 7 42)
  ==
::
::  Test +has: does :b exist in :a?
::
++  test-map-has    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  |
      !>  (~(has by m-nul) 6)
    ::  Checks with non-existing key
    ::
    %+  expect-eq
      !>  |
      !>  (~(has by m-des) 9)
    ::  Checks success
    ::
    %+  expect-eq
      !>  &
      !>  (~(has by m-des) 7)
  ==
::
::  Test intersection
::
++  test-map-int    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int by m-nul) m-des)
    %+  expect-eq
      !>  ~
      !>  (~(int by m-des) m-nul)
    ::  Checks with all keys different
    ::
    %+  expect-eq
      !>  ~
      !>  (~(int by m-dos) m-uno)
    ::  Checks success (total intersection)
    ::
    %+  expect-eq
      !>  m-asc
      !>  (~(int by m-asc) m-des)
    ::  Checks success (partial intersection)
    ::
    %+  expect-eq
      !>  (map-of-doubles (limo ~[1 7 4 6]))
      !>  (~(int by m-des) m-dup)
    ::  Checks using value from b
    ::
    %+  expect-eq
      !>  (my [6 99]~)
      !>  (~(int by m-dos) (my [6 99]~))
  ==
::
::  ?
::
++  test-map-jab    ^-  tang
  (expect-eq !>(4) !>(2))
::
::  Test produce set of keys
::
++  test-map-key    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  ~(key by m-nul)
    ::  Checks when creating a set from a list with duplicates
    ::
    %+  expect-eq
      !>  (sy ~[1 1 7 4 6 9 4])
      !>  ~(key by m-dup)
    ::  Checks correctness
    ::
    %+  expect-eq
      !>  (sy ~[1 2 3 4 5 6 7])
      !>  ~(key by m-des)
  ==
::
::  Test add key-value pair with validation (the value is a nonempty unit)
::
++  test-map-mar    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  (my [6 12]~)
      !>  (~(mar by m-nul) 6 `12)
    ::  Checks with empty value (deletes the key)
    ::
    %+  expect-eq
      !>  (~(del by m-des) 6)
      !>  (~(mar by m-des) 6 ~)
    ::  Checks success (when key exists)
    ::
    %+  expect-eq
      !>  (my ~[[6 12] [9 99]])
      !>  (~(mar by m-dos) 9 `99)
    ::  Checks success (when key does not exist)
    ::
    %+  expect-eq
      !>  (~(put by m-des) [90 23])
      !>  (~(mar by m-des) 90 `23)
  ==
::
::  Test add key-value pair
::
++  test-map-put    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  (my [6 12]~)
      !>  (~(put by m-nul) 6 12)
    ::  Checks with existing key
    ::
    %+  expect-eq
      !>  (my ~[[6 99] [9 18]])
      !>  (~(put by m-dos) 6 99)
    ::  Checks success (new key)
    ::
    %+  expect-eq
      !>  (my ~[[42 84] [9 99]])
      !>  (~(put by m-uno) 9 99)
  ==
::
::  Test replace by product
::
++  test-map-rep    ^-  tang
  ::  Accumulates differences between keys and values
  ::
  =/  rep-gate  |=([a=[@ @] b=@] (add b (sub +.a -.a)))
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  b=0
      !>  (~(rep by m-nul) rep-gate)
    ::  Checks success
    ::
    %+  expect-eq
      ::  =m-dos {[p=6 q=12] [p=9 q=18]}
      ::  (12 - 6) + (18 - 9)
      !>  b=15
      !>  (~(rep by m-dos) rep-gate)
  ==
::
::  Test Test transform + product
::
++  test-map-rib    ^-  tang
  (expect-eq !>(4) !>(2))
  :: =/  rib-gate  |=([a=[@ @] acc=?] &(acc =(2 (div +.a -.a))))
  :: ;:  weld
  ::   ::  Checks with empty map
  ::   ::
  ::   %+  expect-eq
  ::     !>  |
  ::     !>  (~(rib by m-nul) & rib-gate)
  ::   ::  Checks success
  ::   ::
  ::   %+  expect-eq
  ::     !>  &
  ::     !>  (~(rib by m-asc) & rib-gate)
  ::   ::  Checks failure
  ::   ::
  ::   %+  expect-eq
  ::     !>  |
  ::     !>  (~(rib by (my [1 11]~)) & rib-gate)
  :: ==
::
::  apply gate to values
::
++  test-map-run    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(run by m-nul) dec)
    ::  Checks success
    ::
    %+  expect-eq
      !>  (my ~[[1 1] [2 3] [3 5] [4 7] [5 9] [6 11] [7 13]])
      !>  (~(run by m-asc) dec)
  ==
::
::  Test apply gate to nodes
::
++  test-map-rut    ^-  tang
  =/  rut-gate  |=(a=[@ @] (add -.a +.a))
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(rut by m-nul) rut-gate)
    ::  Checks success
    ::
    %+  expect-eq
      !>  (my ~[[1 3] [2 6] [3 9] [4 12] [5 15] [6 18] [7 21]])
      !>  (~(rut by m-asc) rut-gate)
  ==
::
::  Test listify pairs
::
++  test-map-tap    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  ~(tap by ~)
    ::  Checks success
    ::
    %+  expect-eq
      !>  ~[[p=9 q=18] [p=6 q=12]]
      !>  ~(tap by m-dos)
  ==
  :: =/  lists-from-sets=(list (list @))
  ::   %+  turn  all
  ::     ::  resulting lists are sorted for proper list equality
  ::     ::
  ::     |=(s=(set @) (sort ~(tap in s) gth))
  :: %+  expect-eq
  ::   !>  lists-from-sets
  ::   !>  tap-expected
::
::  Test the union of maps
::
++  test-map-uni    ^-  tang
  ;:  weld
    ::  Checks with empty map (a or b)
    ::
    %+  expect-eq
      !>  m-des
      !>  (~(uni by m-nul) m-des)
    %+  expect-eq
      !>  m-des
      !>  (~(uni by m-des) m-nul)
    ::  Checks with all keys different
    ::
    =/  keys  (limo ~[1 2 3 4 5 6 7 8])
    =/  a=(map @ @)  (map-of-doubles (scag 4 keys))
    =/  b=(map @ @)  (map-of-doubles (slag 4 keys))
    %+  expect-eq
      !>  (map-of-doubles keys)
      !>  (~(uni by a) b)
    ::  Checks union all keys equal
    ::
    %+  expect-eq
      !>  m-asc
      !>  (~(uni by m-asc) m-des)
    ::  Checks union with value replacement from b
    ::
    =/  c=(map @ @)  (my [1 12]~)
    =/  d=(map @ @)  (my [1 24]~)
    %+  expect-eq
      !>  d
      !>  (~(uni by c) d)
  ==
::
::  Test general union
::
++  test-map-uno    ^-  tang
  (expect-eq !>(4) !>(2))
::
::  Test apply gate to nodes (duplicates +rut)
::
++  test-map-urn    ^-  tang
  =/  urn-gate  |=(a=[@ @] (add -.a +.a))
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  (~(urn by m-nul) urn-gate)
    ::  Checks success
    ::
    %+  expect-eq
      !>  (my ~[[1 3] [2 6] [3 9] [4 12] [5 15] [6 18] [7 21]])
      !>  (~(urn by m-asc) urn-gate)
  ==
::
::  Test produce list of vals
::
++  test-map-val    ^-  tang
  ;:  weld
    ::  Checks with empty map
    ::
    %+  expect-eq
      !>  ~
      !>  ~(val by m-nul)
    ::  Checks when creating a set from a list with duplicates
    ::
    =/  a=(list @)  ~(tap in (sy ~[1 1 7 4 6 9 4]))
    %+  expect-eq
      ::  we need to sort since the map is not sorted
      ::
      !>  (sort (turn a |=(e=@ (mul 2 e))) gth)
      !>  (sort ~(val by m-dup) gth)
    ::  Checks correctness (no duplicates)
    ::
    =/  b=(list @)  ~(tap in (sy (gulf 1 7)))
    %+  expect-eq
      !>  (sort (turn b |=(e=@ (mul 2 e))) gth)
      !>  (sort ~(val by m-asc) gth)
  ==
::
::  Tests the size of map
::
++  test-map-wyt    ^-  tang
  ::  We ran all the tests in the suite
  ::
  =/  sizes=(list @)
    %+  turn  m-lis
      |=(m=(map @ @) ~(wyt by m))
  %+  expect-eq
    !>  sizes
    !>  wyt-expected
::
--
