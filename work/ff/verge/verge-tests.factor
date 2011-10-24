! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays continuations ff ff.strains ff.strains.generic
       ff.strains.simple ff.verge ff.verge.private io kernel locals math
       namespaces prettyprint sequences tools.test ;
IN: ff.verge.tests

f set-trace

SYMBOL: strain-chain

: reset-strains ( -- ) strain-chain reset-chain ;
: flush-strains ( -- ) strain-chain get . reset-strains ;

: set-max-depth ( guard depth -- ) [ strain-chain ] 2dip set-overdepth ;
: set-max-value ( guard value -- ) [ strain-chain ] 2dip set-overflow ;
: set-min-value ( guard value -- ) [ strain-chain ] 2dip set-underflow ;

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
    strain-chain get clone
    [ 1 <= ]
    [ dup odd? [ 3 * 1 + ] [ 2 /i ] if ]
    verge ; inline

: hotpo-tests ( -- )

    [ V{ 13 40 20 10 5 16 8 4 2 1 } t ] [
        flush-strains 13 [ f ] dup hotpo
    ] unit-test

    [ V{ 13 40 20 10 5 } f ] [
        0 5 set-max-depth 13 [ f ] dup hotpo flush-strains
    ] unit-test

    [ V{ 13 } f ] [
        0 5 set-max-depth 0 15 set-max-value 13 [ f ] dup hotpo flush-strains
    ] unit-test

    [ V{ 13 40 20 11 34 17 52 26 13 40 20 11 34 17 52 26 13 40 20 } f ] [
        2 11 set-min-value 13 [ f ] [ slip-once+1 ] hotpo flush-strains
    ] unit-test

    [ V{ 13 40 21 64 32 16 } f ] [
        2 12 set-min-value 13 [ f ] [ slip-once+1 ] hotpo flush-strains
    ] unit-test

    [ V{ 13 40 21 65 197 } f ] [
        7 5 set-max-depth 2 12 set-min-value 13 [ f ] [ slip-once+1 ] hotpo flush-strains
    ] unit-test

    ; inline

: (single-set-strains) ( guard ctor -- )
    [ strain-chain ] 2dip execute( chain guard/f -- ) ;

: (create-slip-makers) ( slip# -- first-slip-maker next-slip-maker )
    [ f ] swap [ slip-ntimes+1 ] curry ; inline

: (irange-verge) ( start slip# goal step -- hitlist ? )
    [ (create-slip-makers) strain-chain get clone ] 2dip verge ; inline

: (irange-first-verge) ( start slip# goal step -- state hitlist ? )
    [ (create-slip-makers) strain-chain get clone ] 2dip first-verge ; inline

: (irange-next-verge) ( slip# goal step state -- hitlist ? )
    [ [ slip-ntimes+1 ] curry ] 3dip next-verge ; inline

: 7single ( start slip# guard ctor -- hitlist ? )
    (single-set-strains)
    [ drop dup length [ 7 = ] [ 2 = ] bi or ]
    [ ]
    (irange-verge) ;

: 12single ( start slip# guard ctor -- hitlist ? )
    (single-set-strains)
    [ drop dup length 12 = ]
    [ drop 0 ]
    (irange-verge) ;

: 12multi-first ( start slip# guards ctors -- hitlist ? )
    [ (single-set-strains) ] 2each
    [ drop dup length 12 = ]
    [ drop 0 ]
    (irange-verge) ;

:: 12multi-next ( start slip# guards ctors -- hitlist ? )
    guards ctors [ (single-set-strains) ] 2each
    start slip#
    [ drop dup length 12 = ]
    [ drop 0 ]
    (irange-first-verge) [
        drop [
            slip#
            [ drop dup length 12 = ]
            [ drop 0 ]
        ] dip
        (irange-next-verge)
    ] [ nip f ] if ;

:: 12multi-all ( start slip# guards ctors -- hitlists ? )
    guards ctors [ (single-set-strains) ] 2each
    start slip#
    [ drop dup length 12 = ]
    [ drop 0 ]
    0 :> count!
    (irange-first-verge) [
        [
            count 1 + dup count! pprint ". " write . flush ! FIXME accumulate
            dup [
                slip#
                [ drop dup length 12 = ]
                [ drop 0 ]
            ] dip
            (irange-next-verge)
        ] loop nip f
    ] [ nip f ] if ;

ALL-DIFFERENT2: all-different-delta - ;

: first-hit-tests ( -- )

    [ V{ 13 14 15 16 17 18 19 } t ] [
        { 13 14 15 } 2 4
        \ set-all-different 7single flush-strains
    ] unit-test

    [ V{ 13 14 } t ] [
        7 3 set-max-depth { 13 14 } 2 7
        \ set-all-different 7single flush-strains
    ] unit-test

    [ V{ 13 14 15 } f ] [
        7 3 set-max-depth { 13 14 15 } 2 3
        \ set-all-different 7single flush-strains
    ] unit-test

    [ V{ 13 14 16 19 23 28 34 } t ] [
        { 13 14 16 } 6 18
        \ set-all-different-delta 7single flush-strains
    ] unit-test

    [ { 13 14 15 } set-all-different-delta ] [
        { 13 14 15 } 6 1
        \ set-all-different-delta [ 7single ] [ drop 2nip ] recover flush-strains
    ] unit-test

    [ V{ 0 1 3 0 3 1 0 4 0 5 0 6 } t ] [
        { 0 1 3 } 6 19
        \ set-all-different-delta 12single flush-strains
    ] unit-test

    [ V{ 0 1 3 0 3 1 0 4 0 5 0 6 } t ] [
        { 0 1 3 } 6 { 19 }
        { set-all-different-delta } 12multi-first flush-strains
    ] unit-test

    [ V{ 0 1 3 2 7 10 8 4 11 5 9 6 } t ] [
        { 0 1 3 } 11 { 2624 639 }
        { set-all-different set-all-different-delta } 12multi-first flush-strains
    ] unit-test

    ; inline

ALL-DIFFERENT2: all-different-delta12rem - 12 rem ;

: next-hit-tests ( -- )

    [ V{ 0 1 3 2 8 5 9 7 10 4 11 6 } t ] [
        { 0 1 3 } 11 { 3506 835 }
        { set-all-different set-all-different-delta } 12multi-next flush-strains
    ] unit-test

    [ V{ 0 1 3 2 9 5 10 4 7 11 8 6 } t ] [
        { 0 1 3 } 11 { 3093 852 }
        { set-all-different set-all-different-delta12rem } 12multi-next flush-strains
    ] unit-test

    ; inline

: all-hits-tests ( -- )

    [ V{ 0 1 3 2 5 9 4 12 10 6 11 8 } t ] [
        { 0 1 3 } 11 { f f }
        { set-all-different set-all-different-delta } 12multi-all flush-strains
    ] unit-test

    ; inline

! hotpo-tests
! first-hit-tests
next-hit-tests
! all-hits-tests
