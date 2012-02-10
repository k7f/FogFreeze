! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences arrays kernel locals math sequences ;
IN: om.functions.auxiliary

:: x-around ( x pairs -- result )
    x pairs [ first <= ] with find [
        over 0 > [ [ 1 - pairs nth ] dip ] [ nip dup ] if
    ] [ drop pairs last dup ] if* pairs 2sequence ;

<PRIVATE
: (y-around) ( pair1 pair2 y -- both ? )
    2over [ second ] bi@ 3dup
    [ <= ] [ >= ] bi-curry* bi and [ 3drop t ] [
        [ >= ] [ <= ] bi-curry* bi and
    ] if [
        [ 2array ] [ 2drop f ] if
    ] keep ; inline
PRIVATE>

: y-around ( y pairs -- result )
    dup rest-slice rot [ (y-around) ] curry 2filter ;

:: linear-interpol ( x1 x2 y1 y2 x -- y )
    x1 x2 = [ y1 ] [ y1 y2 y1 - x x1 - x2 x1 - / * + ] if ; inline
