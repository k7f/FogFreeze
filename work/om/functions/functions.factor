! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.errors classes combinators fry kernel locals macros math
       math.order om.bpf om.functions.auxiliary om.kernel om.series
       om.support quotations sequences words ;
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
: (y-transfer) ( points y -- x-values )
    [ swap y-around ] keep [
        [ first2 [ first2 swap ] bi@ swapd ] dip linear-interpol
        ! FIXME OM now rounds to an integer, which is most likely a bug...
    ] curry map ; inline
PRIVATE>

M: sequence y-transfer ( points y &optionals -- x-values )
    [ (y-transfer) ] dip unpack1 [ om-round ] when* ;

! FIXME define M: bpf y-transfer in om.bpf.tools

! __________
! x-transfer

GENERIC# x-transfer 2 ( obj x-values &optionals -- y-values )

<PRIVATE
GENERIC:    (x-transfer) ( points xs -- ys )
M: number   (x-transfer) ( points x  -- y  )   linear-interpol* ;
M: sequence (x-transfer) ( points xs -- ys ) [ linear-interpol* ] with map ;
PRIVATE>

M: sequence x-transfer ( points x-values &optionals -- y-values )
    [ (x-transfer) ] dip unpack1 [ om-round ] when* ;

! FIXME define M: bpf x-transfer in om.bpf.tools

! _________
! om-sample

<PRIVATE
GENERIC: ((om-sample)) ( obj -- quot: ( count/step &optionals -- bpf xs ys ) )

M: word ((om-sample)) ( sym -- quot: ( count/step &optionals -- bpf xs ys ) )
    1quotation ((om-sample)) ;

M: callable ((om-sample)) ( quot: ( x -- y ) -- quot: ( count/step &optionals -- bpf xs ys ) )
    '[
        0.0 1.0 unpack3 drop  ! FIXME decimal
        rot {
            ! FIXME OM excludes upper boundary in by-count mode (off-by-one bug?)
            { [ dup integer? ] [ 2over swap - over 1 max / >float swap ] }
            { [ dup float?   ] [ f ] }
            [ class-of invalid-input ]
        } cond arithm-ser dup _ map [ f simple-bpf-from-list ] 2keep
    ] ;

MACRO: (om-sample) ( obj -- quot: ( count/step &optionals -- bpf xs ys ) )
    ((om-sample)) ;
PRIVATE>

: om-sample ( obj count/step &optionals -- bpf xs ys )
    rot (om-sample) ; inline
