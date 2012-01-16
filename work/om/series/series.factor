! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays classes ff.errors kernel layouts locals make math math.order
       math.ranges om.support sequences ;
IN: om.series

! _____________________________________
! 01-basicproject/functions/series.lisp

! ___________
! x->dx dx->x

GENERIC: x->dx ( seq -- seq' )

M: sequence x->dx ( seq -- seq' )
    [ rest-slice ] keep [ - ] over 2map-as ;

GENERIC: dx->x ( start seq -- seq' )

M: sequence dx->x ( start seq -- seq' )
    over number?
    [ swap [ + ] accumulate-all ]
    [ drop class-of invalid-input ] if ;

! __________
! arithm-ser

<PRIVATE
: (arithm-ser-range) ( begin end step nummax -- range )
    [ [ over - ] dip [ /i 1 + ] keep ] dip
    swap [ min 0 max ] dip range boa ; inline
PRIVATE>

! &optionals: (nummax MOST-POSITIVE-FIXNUM)
: arithm-ser ( begin end step &optionals -- seq )
    unpack1 [ most-positive-fixnum ] unless*
    (arithm-ser-range) >array ;

! ________
! fibo-ser

: (fibo-skip) ( a b n -- a' b' )
    dup 1 < [ drop ] [ [ [ + ] keep swap ] times ] if ; inline

: (fibo-max-length) ( start end -- length/f )
    over 1 < [ nip ] [ swap - ] if
    dup 1 < [ drop f ] when ; inline

: (fibo-make) ( a b max-length limit -- seq )
    [
        [ pick ] dip 2dup < [
            swap , [
                over 0 > [ pick over < ] [ f ] if
            ] [
                [ [ [ , ] [ + ] [ ] tri swap ] dip 1 - ] dip
            ] while 2drop
        ] [ 3drop ] if 2drop
    ] { } make ; inline

:: (fibo-ser) ( a b limit start end -- seq )
    a b start (fibo-skip) start end (fibo-max-length)
    [ limit (fibo-make) ] [ 2array ] if* ; inline

! &optionals: (begin 0) (end MOST-POSITIVE-FIXNUM)
: fibo-ser ( seed1 seed2 limit &optionals -- seq )
    0 unpack2 [ most-positive-fixnum ] unless* (fibo-ser) ;
