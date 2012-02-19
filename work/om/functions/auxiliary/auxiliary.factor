! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences addenda.sequences.iterators arrays assocs
       combinators kernel locals make math math.ranges sequences ;
IN: om.functions.auxiliary

! ________
! x-around

:: x-around ( x points -- result )
    x points [ first <= ] with find [
        over 0 > [ [ 1 - points nth ] dip ] [ nip dup ] if
    ] [ drop points last dup ] if* points 2sequence ;

! ________
! y-around

<PRIVATE
: (y-around) ( point1 point2 y -- both ? )
    2over [ second ] bi@ 3dup
    [ <= ] [ >= ] bi-curry* bi and [ 3drop t ] [
        [ >= ] [ <= ] bi-curry* bi and
    ] if [
        [ 2array ] [ 2drop f ] if
    ] keep ; inline
PRIVATE>

: y-around ( y points -- result )
    dup rest-slice rot [ (y-around) ] curry 2filter ;

! _______________
! linear-interpol

:: linear-interpol ( x1 x2 y1 y2 x -- y )
    x1 x2 = [ y1 ] [ y1 y2 y1 - x x1 - x2 x1 - / * + ] if ; inline

: linear-interpol* ( points x -- y )
    [ swap x-around first2 [ first2 ] bi@ swapd ] keep linear-interpol ; inline

! ___________
! interpolate

<PRIVATE
: (interpolate-step) ( ptr step x1 y1 x2 y2 -- ptr' step )
    [ swap [ pick ] 2dip rot ] dip swap linear-interpol , [ + ] keep ; inline

: (interpolate) ( ptr step x1 y1 x2 y2 -- ptr' step )
    over [ [ (interpolate-step) ] 2curry 2curry ] dip
    [ pick > ] curry swap while ; inline
PRIVATE>

: interpolate ( xs ys step -- result )
    over [
        [ [ first ] keep ] 2dip -rot
        [ unclip-slice swap ] bi@ swapd
        [ [ [ (interpolate) ] 2keep ] 2each , 3drop ]
    ] dip make ; inline

! _________
! interpole

<PRIVATE
: (bounds>range) ( x-min x-max n -- range )
    2over swap - swap >float 1 - / <range> ; inline

:: (interpole-step) ( xiter yiter x1! x2! y1! y2! x -- xiter yiter x1' x2' y1' y2' y/f )
    f [
        {
            { [ x2 not ] [ f ] }
            { [ y2 not ] [ f ] }
            { [ x1 x > ] [ f ] }
            { [ x2 x < ] [ x2 x1! y2 y1! xiter ?step x2! yiter ?step y2! t ] }
            [ x1 x2 y1 y2 x linear-interpol nip f ]
        } cond
    ] loop [ xiter yiter x1 x2 y1 y2 ] dip ; inline

: (interpole) ( xs ys range -- result )
    [ [ <iterator> dup ?step ] bi@ swapd dupd dup ] dip
    [ (interpole-step) ] map sift
    [ 2drop 2drop 2drop ] dip ; inline
PRIVATE>

: interpole ( xs ys x-min x-max n -- result )
    dup 1 > [ (bounds>range) (interpole) ] [
        1 < [ 2drop 2drop f ] [
            [ zip ] [ over - 2 / + ] 2bi* linear-interpol*
        ] if
    ] if ; inline
