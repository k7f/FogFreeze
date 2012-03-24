! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.errors addenda.sequences arrays classes combinators
       fry kernel locals macros math math.order om.bpf om.functions.auxiliary
       om.kernel om.lists om.series om.support quotations sequences words ;
IN: om.functions

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

M: bpf y-transfer ( bpf y &optionals -- x-values )
    [ point-pairs ] 2dip y-transfer ;

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

M: bpf x-transfer ( bpf x-values &optionals -- y-values )
    [ point-pairs ] 2dip x-transfer ;

! _________
! om-sample

<PRIVATE
GENERIC: (sample-gen) ( obj -- quot: ( count/step &optionals -- bpf xs ys ) )

M: word (sample-gen) ( sym -- quot: ( count/step &optionals -- bpf xs ys ) )
    1quotation (sample-gen) ;

M: callable (sample-gen) ( quot: ( x -- y ) -- quot: ( count/step &optionals -- bpf xs ys ) )
    '[
        0.0 1.0 unpack3 drop  ! FIXME decimal
        rot {
            { [ dup integer? ] [ 2over swap - over 1 max / >float swap ] }
            { [ dup float?   ] [ f ] }
            [ class-of invalid-input ]
        } cond arithm-ser dup _ map [ f simple-bpf-from-list ] 2keep
    ] ;

: (sample-reals-ys) ( xs seq xmin xmax count/step -- ys )
    {
        { [ dup integer? ] [ interpole ] }
        { [ dup float?   ] [ 2nip interpolate ] }
        [ class-of invalid-input ]
    } cond ; inline

: (sample-reals-head) ( seq xmin xmax/f -- xmin xmax seq' )
    [ rot over head-slice ]
    [ swap [ length 1 - ] keep ] if* ; inline

: (sample-reals-tail) ( count/step xmin xmax seq -- seq' count/step xmin xmax )
    -rot [ [ tail-slice swap ] keep ] dip ; inline

: (sample-reals-make) ( seq count/step xmin xmax -- bpf xs ys )
    [ [ length iota ] keep ] 3dip rot
    (sample-reals-ys) [ length iota >array ] keep
    [ f simple-bpf-from-list ] 2keep ; inline

: (sample-reals) ( count/step &optionals seq -- bpf xs ys )
    swap 0 f unpack3 drop  ! FIXME decimal
    (sample-reals-head) (sample-reals-tail) (sample-reals-make) ; inline

: (sample-bpf-range) ( xfirst xlast xmin xmax -- xmin' xmax' )
    swapd [ max ] [ min ] 2bi* ; inline

: (sample-bpf-ys) ( points xmin xmax count -- ys )
    [ [ [ x>> >float ] map ] [ [ y>> >float ] map ] bi ] 3dip interpole
    dup sequence? [ 1array ] unless ; inline

: (sample-bpf-xs) ( xmin xmax count -- xs )
    {
        { [ dup 1 > ] [ 2over swap - swap [ 1 - /f ] keep arithm-ser ] }
        { [ 1 = ] [ over - 2.0 / + 1array ] }
        [ 2drop f ]
    } cond ; inline

: (sample-bpf-make-count) ( points xmin xmax count -- xs ys )
    [ (sample-bpf-ys) ] [ (sample-bpf-xs) ] 3bi swap ; inline

: (sample-bpf-make-step) ( points xmin xmax step -- xs ys )
    [ f arithm-ser swap ]
    [ [ dup pick - ] dip /i 1 + (sample-bpf-ys) ] 3bi ; inline

: (sample-bpf-make) ( points count/step xmin xmax -- bpf xs ys )
    rot {
        { [ dup integer? ] [ (sample-bpf-make-count) ] }
        { [ dup float?   ] [ (sample-bpf-make-step) ] }
        [ class-of invalid-input ]
    } cond [ f simple-bpf-from-list ] 2keep ; inline

: (sample-bpf) ( count/step &optionals bpf -- bpf' xs ys )
    points>> swap over [ 3drop f f f ] [
        [ first x>> ] [ last x>> ] bi [ rot ] 2keep unpack3 drop  ! FIXME decimal
        (sample-bpf-range) [ swap ] 2dip (sample-bpf-make)
    ] if-empty ; inline

: (sample-bpfs) ( count/step &optionals bpfs -- bpf-seq xs-seq ys-seq )
    [ (sample-bpf) 3array ] with with map mat-trans first3 ; inline

M: proper-sequence (sample-gen) ( seq -- quot: ( count/step &optionals -- bpf xs ys ) )
    {
        { [ dup empty? ] [ drop [ 2drop f f f ] ] }
        { [ dup first dup bpf? ] [ drop [ (sample-bpfs) ] curry ] }
        { [ real? ] [ [ (sample-reals) ] curry ] }
        [ drop [ 2drop f f f ] ]
    } cond ;

M: bpf (sample-gen) ( bpf -- quot: ( count/step &optionals -- bpf' xs ys ) )
    [ (sample-bpf) ] curry ;

M: bpf-lib (sample-gen) ( bpf-lib -- quot: ( count/step &optionals -- bpf xs ys ) )
    bpfs>> [ (sample-bpfs) ] curry ;

MACRO: (om-sample) ( obj -- quot: ( count/step &optionals -- bpf xs ys ) )
    (sample-gen) ;
PRIVATE>

: om-sample ( obj count/step &optionals -- bpf xs ys )
    rot (om-sample) ; inline
