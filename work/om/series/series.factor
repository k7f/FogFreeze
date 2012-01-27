! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays classes ff.errors fry kernel layouts locals macros make
       math math.functions math.order math.primes math.primes.factors
       math.ranges om.support prettyprint quotations sequences ;
IN: om.series

! _____________________________________
! 01-basicproject/functions/series.lisp

<PRIVATE
: (max-length) ( start end -- length/f )
    over 1 < [ nip ] [ swap - ] if
    dup 0 < [ drop f ] [ 1 + max-array-capacity min ] if ; inline
PRIVATE>

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

<PRIVATE
: (fibo-skip) ( a b n -- a' b' )
    dup 1 < [ drop ] [ [ [ + ] keep swap ] times ] if ; inline

: (fibo-make) ( a b max-length limit -- seq )
    [
        [ pick ] dip 2dup < [
            swap , [
                over 1 > [ pick over < ] [ f ] if
            ] [
                [ [ [ , ] [ + ] [ ] tri swap ] dip 1 - ] dip
            ] while 2drop
        ] [ 3drop ] if 2drop
    ] { } make ; inline

:: (fibo-ser) ( a b limit start end -- seq )
    a b start (fibo-skip) start end (max-length)
    [ limit (fibo-make) ] [ 2array ] if* ; inline
PRIVATE>

! &optionals: (begin 0) (end MOST-POSITIVE-FIXNUM)
: fibo-ser ( seed1 seed2 limit &optionals -- seq )
    0 unpack2 [ most-positive-fixnum ] unless* (fibo-ser) ;

! _____________
! geometric-ser

<PRIVATE
: (geometric-skip) ( num factor n -- num' )
    dup 1 < [ 2drop ] [ [ [ * ] keep ] times drop ] if ; inline

: (geometric-max-length) ( nummax start end -- length/f )
    (max-length) dup [
        min dup 1 < [ drop f ] when
    ] [ nip ] if ; inline

MACRO: (geometric-test) ( limit factor -- curry: ( accum count -- accum count ? ) )
    1 < [ < ] [ > ] ? '[
        [ dup 0 > [ _ pick @ ] [ f ] if ]
    ] ;

: (geometric-step) ( factor -- curry: ( accum count -- accum' count' ) )
    [ pick , [ 1 - swap ] dip * swap ] curry ; inline

:: (geometric-ser) ( seed factor limit nummax start end -- seq )
    seed factor start (geometric-skip)
    nummax start end (geometric-max-length) [
        limit factor [ (geometric-test) ] [ (geometric-step) ] bi
        [ while 2drop ] { } make
    ] [ 1array ] if* ; inline
PRIVATE>

! &optionals: (nummax (expt 2 32)) (begin 0) (end (expt 2 32))
: geometric-ser ( seed factor limit &optionals -- seq )
    most-positive-fixnum 0 unpack3 [ most-positive-fixnum ] unless*
    (geometric-ser) ; inline

! _________
! prime-ser

<PRIVATE
: (prime-ser) ( first-value max-value max-count -- seq )
    [
        [ 2over > [ f ] [ dup 0 > ] if ]
        [ [ dup , next-prime ] 2dip 1 - ] while 3drop
    ] { } make ; inline
PRIVATE>

! &optionals: (numelem (expt 2 32))
: prime-ser ( max-value &optionals -- seq )
    unpack1 [ 2 -rot (prime-ser) ] [ primes-upto { } like ] if* ;

ALIAS: prime-factors group-factors

! __________
! inharm-ser

: inharm-ser ( start dist npart -- seq )
    iota [ 1 + swap ^ * ] with with map ;
