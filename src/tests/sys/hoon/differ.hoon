::  Tests for +differ (hunt-mcilroy)
::
/+  *test
::
=,  differ
::  Testing arms
::
|%
::  ++berk:differ: invert diff patch
::
++  test-berk  ^-  tang
  ::  An inverted diff between %a and %b can be checked
  ::  by patching %b and obtaining %a
  ::
  ;:  weld
    ::  (some) test examples adapted from:
    ::  https://github.com/gioele/diff-lcs/blob/master/test/test_diff-lcs.rb
    ::
    =/  a=wain  "abcehjlmnp"
    =/  b=wain  "bcdefjklmrst"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "abcde"
    =/  b=wain  "ae"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "ae"
    =/  b=wain  "abcde"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "vxae"
    =/  b=wain  "wyabcde"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "xae"
    =/  b=wain  "abcde"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "ae"
    =/  b=wain  "xabcde"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "aev"
    =/  b=wain  "xabcdewx"
    =/  diff-a-b  (lusk a b (loss a b))
    =/  diff-b-a  (lusk b a (loss b a))
    =/  p-a  (lurk b (berk diff-a-b))
    =/  p-b  (lurk a (berk diff-b-a))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    ::  individuals diffs
    ::
    =/  a  "10qawsedrftg"
    =/  b  "1Aqawsedrftg"
    =/  dif=(urge:clay cord)
      :~  ::  copies first match
          ::
          [%.y 1]
          ::  replaces 0 with 'A'
          ::
          [%.n "0" "A"]
          ::  copies the rest
          ::
          [%.y 10]
      ==
    (expect-eq !>(a) !>((lurk b (berk dif))))
    ::
    =/  a  "1qawsedrftg10"
    =/  b  "1Aqawsedrftg"
    =/  dif=(urge:clay cord)
      :~  ::  copies first match
          ::
          [%.y 1]
          ::  inserts 'A'
          ::
          [%.n ~ "A"]
          ::  copies all matches
          ::
          [%.y 10]
          ::  copies '10'
          ::
          [%.n (flop "10") ~]
      ==
    (expect-eq !>(a) !>((lurk b (berk dif))))
  ==
::
::  ++loss:differ: longest subsequence
::
++  test-loss  ^-  tang
  ;:  weld
    ::  null case
    ::
    %+  expect-eq
      !>  ~
      !>  (loss "abc" "xyz")
    ::  common prefix
    ::
    %+  expect-eq
      !>  "abc"
      !>  (loss "abcq" "abcxyz")
    %+  expect-eq
      !>  "qaz"
      !>  (loss "qaz" "qazxyz")
    ::  common suffix
    ::
    %+  expect-eq
      !>  "wsx"
      !>  (loss "qwsx" "xyzwsx")
    %+  expect-eq
      !>  "edc"
      !>  (loss "edc" "xyzedc")
    ::  overlap
    ::
    %+  expect-eq
      !>  "rfv"
      !>  (loss "qrfvp" "xyzrfvdef")
    %+  expect-eq
      !>  "tgb"
      !>  (loss "qwertytgb" "tgbasdfgh")
    :: Non contiguous
    ::
    %+  expect-eq
      ::  From wikipedia:
      ::  https://en.wikipedia.org/wiki/Longest_common_subsequence_problem
      ::
      !>  "MJAU"
      !>  (loss "XMJYAUZ" "MZJAWXU")
    %+  expect-eq
      !>  "qawsxcf"
      !>  (loss "qazwsxedcrfvtb" "qqqawsxcf")
  ==
::
::  ++lurk:differ: apply list patch
++  test-lurk  ^-  tang
  ;:  weld
    ::  (some) test examples adapted from:
    ::  https://github.com/gioele/diff-lcs/blob/master/test/test_diff-lcs.rb
    ::
    =/  a=wain  "abcehjlmnp"
    =/  b=wain  "bcdefjklmrst"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "abcde"
    =/  b=wain  "ae"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "ae"
    =/  b=wain  "abcde"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "vxae"
    =/  b=wain  "wyabcde"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "xae"
    =/  b=wain  "abcde"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "ae"
    =/  b=wain  "xabcde"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    =/  a=wain  "aev"
    =/  b=wain  "xabcdewx"
    =/  p-b  (lurk a (lusk a b (loss a b)))
    =/  p-a  (lurk b (lusk b a (loss b a)))
    (expect-eq !>(a^b) !>(p-a^p-b))
    ::
    ::  individuals diffs
    ::
    =/  a  "10qawsedrftg"
    =/  b  "1Aqawsedrftg"
    =/  dif=(urge:clay cord)
      :~  ::  copies first match
          ::
          [%.y 1]
          ::  replaces 0 with 'A'
          ::
          [%.n "0" "A"]
          ::  copies the rest
          ::
          [%.y 10]
      ==
    (expect-eq !>(b) !>((lurk a dif)))
    ::
    =/  a  "1qawsedrftg10"
    =/  b  "1Aqawsedrftg"
    =/  dif=(urge:clay cord)
      :~  ::  copies first match
          ::
          [%.y 1]
          ::  inserts 'A'
          ::
          [%.n ~ "A"]
          ::  copies all matches
          ::
          [%.y 10]
          ::  copies '10'
          ::
          [%.n (flop "10") ~]
      ==
    (expect-eq !>(b) !>((lurk a dif)))
  ==
::  ++lusk:differ: lcs to list patch
++  test-lusk  ^-  tang
  ;:  weld
    ::  (some) test examples adapted from:
    ::  https://github.com/gioele/diff-lcs/blob/master/test/test_diff-lcs.rb
    ::
    =/  a=wain  "abcehjlmnp"
    =/  b=wain  "bcdefjklmrst"
    =/  diff=(urge:clay cord)
      :~  [%.n ~['a'] ~]
          [%.y 2]
          [%.n ~ ~['d']]
          [%.y 1]
          [%.n ~['h'] ~['f']]
          [%.y 1]
          [%.n ~ ~['k']]
          [%.y 2]
          [%.n (flop "np") (flop "rst")]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
    ::
    =/  a=wain  "abcde"
    =/  b=wain  "ae"
    =/  diff=(urge:clay cord)
      :~  [%.y 1]
          [%.n (flop "bcd") ~]
          [%.y 1]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
    ::
    =/  a=wain  "ae"
    =/  b=wain  "abcde"
    =/  diff=(urge:clay cord)
      :~  [%.y 1]
          [%.n ~ (flop "bcd")]
          [%.y 1]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
    ::
    =/  a=wain  "vxae"
    =/  b=wain  "wyabcde"
    =/  diff=(urge:clay cord)
      :~  [%.n (flop "vx") (flop "wy")]
          [%.y 1]
          [%.n ~ (flop "bcd")]
          [%.y 1]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
    ::
    =/  a=wain  "xae"
    =/  b=wain  "abcde"
    =/  diff=(urge:clay cord)
      :~  [%.n "x" ~]
          [%.y 1]
          [%.n ~ (flop "bcd")]
          [%.y 1]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
    ::
    =/  a=wain  "ae"
    =/  b=wain  "xabcde"
    =/  diff=(urge:clay cord)
      :~  [%.n ~ "x"]
          [%.y 1]
          [%.n ~ (flop "bcd")]
          [%.y 1]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
    ::
    =/  a=wain  "aev"
    =/  b=wain  "xabcdewx"
    =/  diff=(urge:clay cord)
      :~  [%.n ~ "x"]
          [%.y 1]
          [%.n ~ (flop "bcd")]
          [%.y 1]
          [%.n "v" (flop "wx")]
      ==
    %+  expect-eq
      !>  diff
      !>  `(urge:clay cord)`(lusk a b (loss a b))
  ==
--
