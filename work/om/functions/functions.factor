! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel locals math om.functions.auxiliary om.kernel om.support
       sequences ;
IN: om.functions

! ________________________________________
! 01-basicproject/functions/functions.lisp

! __________
! linear-fun

:: linear-fun ( x0 y0 x1 y1 -- quot: ( x -- y ) )
    x0 x1 = [ x0 [ = 1 0 ? ] curry ] [
        y1 y0 - x1 x0 - /
        y1 x1 pick * -
        [ [ * ] dip + ] 2curry
    ] if ;

! __________
! y-transfer

GENERIC# y-transfer 2 ( obj y &optionals -- x-values )

<PRIVATE
: (y-transfer) ( pairs y -- x-values )
    [ swap y-around ] keep [
        [ first2 [ first2 swap ] bi@ swapd ] dip linear-interpol
        ! OM now rounds to an integer, which is most likely a bug...
    ] curry map ; inline
PRIVATE>

M: sequence y-transfer ( pairs y &optionals -- x-values )
    [ (y-transfer) ] dip unpack1 [ om-round ] when* ;

! FIXME define M: bpf y-transfer in om.bpf.tools

! __________
! x-transfer

GENERIC# x-transfer 2 ( obj x-values &optionals -- y-values )

<PRIVATE
: ((x-transfer)) ( pairs x -- y )
    [ swap x-around first2 [ first2 ] bi@ swapd ] keep linear-interpol ; inline

GENERIC:    (x-transfer) ( pairs xs -- ys )
M: number   (x-transfer) ( pairs x  -- y  )   ((x-transfer)) ;
M: sequence (x-transfer) ( pairs xs -- ys ) [ ((x-transfer)) ] with map ;
PRIVATE>

M: sequence x-transfer ( pairs x-values &optionals -- y-values )
    [ (x-transfer) ] dip unpack1 [ om-round ] when* ;

! FIXME define M: bpf x-transfer in om.bpf.tools
