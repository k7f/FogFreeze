! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays kernel math om.rhythm refs sequences sequences.deep ;
IN: om.rhythm.transformer

! __________
! rhythm-ref

TUPLE: rhythm-ref
    { index integer }
    { parent maybe: rhythm }
    { value number initial: 1 } ;

INSTANCE: rhythm-ref ref

: <rhythm-ref> ( ndx parent value/f -- ref )
    [ 2dup division>> nth ] unless* rhythm-ref boa ;

: >rhythm-ref< ( ref -- ndx parent/f value )
    [ index>> ] [ parent>> ] [ value>> ] tri
    over [ 3dup -rot division>> set-nth ] when ;

: !rhythm-ref ( ref -- )
    [ value>> ] [ index>> ] [ parent>> ] tri
    [ division>> set-nth ] [ 2drop ] if* ;

M: rhythm-ref get-ref ( ref -- value )
    dup parent>> [ value>> ] [ drop f ] if ;

M: rhythm-ref set-ref ( value ref -- )
    over [ value<< ] [ parent<< ] if ;

! __________________
! rhythm-transformer

TUPLE: rhythm-transformer
    { refs sequence }
    { underlying rhythm } ;

<PRIVATE
GENERIC: (create-references) ( ndx parent relt -- refs )

M: number (create-references) ( ndx parent value -- ref )
    <rhythm-ref> ;

M: rhythm (create-references) ( ndx parent rhm -- refs )
    2nip [ division>> ] keep
    [ rot (create-references) ] curry map-index ;
PRIVATE>

: <rhythm-transformer> ( rhm -- rt )
    [
        f f rot (create-references) dup rhythm-ref?
        [ 1array ] [ flatten ] if
    ] keep rhythm-transformer boa ;

: >rhythm-transformer< ( rt -- rhm )
    [ refs>> [ !rhythm-ref ] each ] [ underlying>> ] bi ;

: with-rhythm-transformer ( ... rhm quot: ( ... refs -- ... refs' ) -- ... rhm' )
    [ <rhythm-transformer> ] dip change-refs >rhythm-transformer< ; inline
