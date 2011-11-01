! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays continuations ff ff.strains ff.strains.generic
       ff.strains.simple ff.verge ff.verge.private fry io kernel locals math
       namespaces prettyprint sequences tools.test ;
IN: ff.verge.tests

f set-trace

: report ( -- report ) strains-failures strains. ;

: slip-once+1 ( value -- value slip )
    dup [
        1 + f
    ] curry ;

: slip-twice+1 ( value -- value slip )
    dup [
        1 + slip-once+1
    ] curry ;

: slip-ntimes+1 ( value slip# -- value slip )
    over [
        1 + swap 1 - dup 0 > [ slip-ntimes+1 ] [ drop f ] if
    ] 2curry ;

: hotpo ( start first-slip-maker next-slip-maker -- hitlist ? )
    [ 1array ] 2dip
    all-strains get
    [ 1 <= ]
    [ dup odd? [ 3 * 1 + ] [ 2 /i ] if ]
    verge ; inline

: hotpo-tests ( -- )

    [ V{ 13 40 20 10 5 16 8 4 2 1 } t ] [
        f [ 13 [ f ] dup hotpo ] with-strains
    ] unit-test

    [ V{ 13 40 20 10 5 } f { { overdepth 0 } } ] [
        0 5 <overdepth> f chain-in [ 13 [ f ] dup hotpo report ] with-strains
    ] unit-test

    [ V{ 13 } f { { overdepth 0 } { overflow 0 } } ] [
        0 5 <overdepth> f chain-in 0 15 <overflow> swap chain-in [
            13 [ f ] dup hotpo report
        ] with-strains
    ] unit-test

    [ V{ 13 40 20 11 34 17 52 26 13 40 20 11 34 17 52 26 13 40 20 } f { { underflow 2 } } ] [
        2 11 <underflow> f chain-in [
            13 [ f ] [ slip-once+1 ] hotpo report
        ] with-strains
    ] unit-test

    [ V{ 13 40 21 64 32 16 } f { { underflow 2 } } ] [
        2 12 <underflow> f chain-in [
            13 [ f ] [ slip-once+1 ] hotpo report
        ] with-strains
    ] unit-test

    [ V{ 13 40 21 65 197 } f { { overdepth 7 } { underflow 2 } } ] [
        7 5 <overdepth> f chain-in 2 12 <underflow> swap chain-in [
            13 [ f ] [ slip-once+1 ] hotpo report
        ] with-strains
    ] unit-test

    ; inline

: (create-slip-makers) ( slip# -- first-slip-maker next-slip-maker )
    [ f ] swap [ slip-ntimes+1 ] curry ; inline

: (irange-verge) ( start slip# goal step -- hitlist ? )
    [ (create-slip-makers) all-strains get ] 2dip verge ; inline

: (irange-first-verge) ( start slip# goal step -- state hitlist ? )
    [ (create-slip-makers) all-strains get ] 2dip first-verge ; inline

: (irange-next-verge) ( slip# goal step state -- hitlist ? )
    [ [ slip-ntimes+1 ] curry ] 3dip next-verge ; inline

: 7single ( start slip# guard ctor chain -- hitlist ? report )
    [ [ 1array ] bi@ ] dip chain-grow [
        [ drop dup length [ 7 = ] [ 2 = ] bi or ]
        [ ]
        [ (irange-verge) ] [ drop 3drop f ] recover report
    ] with-strains ;
 
: 12single ( start slip# guard ctor -- hitlist ? report )
    [ 1array ] bi@ build-strains [
        [ drop dup length 12 = ]
        [ drop 0 ]
        (irange-verge) report
    ] with-strains ;

: 12multi-first ( start slip# guards ctors -- hitlist ? report )
    build-strains [
        [ drop dup length 12 = ]
        [ drop 0 ]
        (irange-verge) report
    ] with-strains ;

ALL-DIFFERENT2: all-different-delta - ;

: first-hit-tests ( -- )

    [ V{ 13 14 15 16 17 18 19 } t { { all-different 4 } } ] [
        { 13 14 15 } 2 4
        \ +all-different+ f 7single
    ] unit-test

    [ V{ 13 14 } t { { overdepth 0 } { all-different 0 } } ] [
        { 13 14 } 2 7 \ +all-different+
        7 3 <overdepth> f chain-in 7single
    ] unit-test

    [ V{ 13 14 15 } f { { overdepth 3 } { all-different 0 } } ] [
        { 13 14 15 } 2 3 \ +all-different+
        7 3 <overdepth> f chain-in 7single
    ] unit-test

    [ V{ 13 14 16 19 23 28 34 } t { { all-different-delta 18 } } ] [
        { 13 14 16 } 6 18
        \ +all-different-delta+ f 7single
    ] unit-test

    [ { 13 14 15 } f { { all-different-delta 1 } } ] [
        { 13 14 15 } 6 1
        \ +all-different-delta+ f 7single
    ] unit-test

    [ V{ 0 1 3 0 3 1 0 4 0 5 0 6 } t { { all-different-delta 19 } } ] [
        { 0 1 3 } 6 19
        \ +all-different-delta+ 12single
    ] unit-test

    [ V{ 0 1 3 0 3 1 0 4 0 5 0 6 } t { { all-different-delta 19 } } ] [
        { 0 1 3 } 6 { f }
        { +all-different-delta+ } 12multi-first
    ] unit-test

    [ V{ 0 1 3 2 7 10 8 4 11 5 9 6 } t
      {
          { all-different 2624 }
          { all-different-delta 639 }
      } ] [
        { 0 1 3 } 11 { 2624 639 }
        { +all-different+ +all-different-delta+ } 12multi-first
    ] unit-test

    ; inline

: create-trols ( slip# depth -- slip-maker goal step )
    swap [ slip-ntimes+1 ] curry
    swap '[ drop dup length _ = ]
    [ drop 0 ] ; inline

: multi-second ( start slip# depth guards ctors -- hitlist ? report )
    build-strains [
        rot [ f ] [
            2dup create-trols
            (initialize-with) (run) [
                drop create-trols
                (initialize-with) (single-step) (run)
            ] [ 2nip f ] if
        ] with-verging report
    ] with-strains ;

ALL-DIFFERENT2: all-different-delta12rem - 12 rem ;

: second-hit-tests ( -- )

    [ V{ 0 1 3 2 8 5 9 7 10 4 11 6 } t
      {
          { all-different 3506 }
          { all-different-delta 835 }
      } ] [
        { 0 1 3 } 11 12 { 3506 835 }
        { +all-different+ +all-different-delta+ } multi-second
    ] unit-test

    [ V{ 0 1 3 2 9 5 10 4 7 11 8 6 } t
      {
          { all-different 3093 }
          { all-different-delta12rem 852 }
      } ] [
        { 0 1 3 } 11 12 { 3093 852 }
        { +all-different+ +all-different-delta12rem+ } multi-second
    ] unit-test

    [ V{ 0 1 3 7 5 2 10 4 9 8 11 6 } t
      {
          { all-different 204 }
          { all-different-delta12rem 42 }
      } ] [
        { 0 1 3 7 5 2 } 11 12 { f f }
        { +all-different+ +all-different-delta12rem+ } multi-second
    ] unit-test

    ; inline

:: 12multi-last ( start slip# guards ctors -- hitlist ? report )
    guards ctors build-strains [
        start slip#
        [ drop dup length 12 = ]
        [ drop 0 ]
        (irange-first-verge) [
            [
                clone over [
                    slip#
                    [ drop dup length 12 = ]
                    [ drop 0 ]
                ] dip
                (irange-next-verge)
                [ [ nip ] [ drop ] if ] keep
            ] loop nip t
        ] [ nip f ] if
        report
    ] with-strains ;

: last-hit-tests ( -- )

    [ V{ 0 1 3 11 9 8 5 10 4 7 2 6 } t
      {
          { all-different 46015 }
          { all-different-delta12rem 11439 }
      } ] [
        { 0 1 3 } 11 { f f }
        { +all-different+ +all-different-delta12rem+ } 12multi-last
    ] unit-test

    ; inline

:: 12multi-nth ( start slip# guards ctors n -- hitlist ? report )
    guards ctors build-strains [
        start slip#
        [ drop dup length 12 = ]
        [ drop 0 ]
        0 :> count!
        (irange-first-verge) [
            [
                count 1 + dup n < [
                    count! clone over [
                        slip#
                        [ drop dup length 12 = ]
                        [ drop 0 ]
                    ] dip
                    (irange-next-verge)
                    [ [ nip ] [ drop ] if ] keep
                ] [ drop f ] if
            ] loop nip t
        ] [ nip f ] if
        report
    ] with-strains ;

: nth-hit-tests ( -- )

    [ V{ 0 1 3 9 8 4 7 5 10 2 11 6 } t
      {
          { all-different 31437 }
          { all-different-delta12rem 7774 }
      } ] [
        { 0 1 3 } 11 { f f }
        { +all-different+ +all-different-delta12rem+ } 27 12multi-nth
    ] unit-test

    ; inline

:: 12multi-all ( start slip# guards ctors -- hitlists report )
    guards ctors build-strains [
        start slip#
        [ drop dup length 12 = ]
        [ drop 0 ]
        V{ } clone :> hitlists!
        (irange-first-verge) [
            [
                clone hitlists swap suffix! hitlists!
                dup [
                    slip#
                    [ drop dup length 12 = ]
                    [ drop 0 ]
                ] dip
                (irange-next-verge)
            ] loop 2drop
        ] [ 2drop ] if
        hitlists report
    ] with-strains ;

: all-hits-tests ( -- )

    [ V{ 11 10 8 9 4 1 3 7 0 6 2 5 } 382 { 442939 107656 } ] [
        { 11 10 } 11 { f f }
        { +all-different+ +all-different-delta12rem+ } 12multi-all
        [ [ last ] [ length ] [ . ] tri ] dip
        [ second ] map
    ] unit-test

    ; inline

! hotpo-tests
! first-hit-tests
! second-hit-tests
! last-hit-tests
! nth-hit-tests
all-hits-tests
