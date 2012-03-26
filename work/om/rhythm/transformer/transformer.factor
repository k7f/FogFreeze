! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays kernel locals math om.rhythm refs sequences
       sequences.deep ;
IN: om.rhythm.transformer

! __________
! rhythm-ref

TUPLE: rhythm-ref
    { index integer }
    { parent maybe: rhythm }
    { value number initial: 1 }
    { place integer } ;

INSTANCE: rhythm-ref ref

: <rhythm-ref> ( ndx parent value/f -- ref )
    [ 2dup division>> nth ] unless* 0 rhythm-ref boa ;

: !rhythm-ref ( ref -- )
    [ value>> ] [ index>> ] [ parent>> ] tri
    [ division>> set-nth ] [ 2drop ] if* ;

M: rhythm-ref get-ref ( ref -- value/f )
    dup parent>> [ value>> ] [ drop f ] if ;

M: rhythm-ref set-ref ( value ref -- )
    over [ value<< ] [ parent<< ] if ;

! __________________
! rhythm-transformer

TUPLE: rhythm-transformer
    { refs sequence }
    { underlying rhythm } ;

<PRIVATE
GENERIC: (create-refs) ( ... place ndx parent relt -- ... place' refs )

M: number (create-refs) ( ... place ndx parent value -- ... place' ref )
    <rhythm-ref> [ [ 1 + ] keep ] dip swap >>place ;

: (create-next-refs) ( ... place relt ndx rhm -- ... place' refs )
    rot (create-refs) ; inline

M: rhythm (create-refs) ( ... place ndx parent rhm -- ... place' refs )
    2nip [ division>> ] keep [ (create-next-refs) ] curry map-index ;
PRIVATE>

: <rhythm-transformer> ( rhm -- rt )
    [
        [ 0 0 f ] dip (create-refs) nip dup rhythm-ref?
        [ 1array ] [ flatten ] if
    ] keep rhythm-transformer boa ;

: >rhythm-transformer< ( rt -- rhm )
    [ refs>> [ !rhythm-ref ] each ] [ underlying>> ] bi ;

: with-rhythm-transformer ( ... rhm quot: ( ... refs -- ... refs' ) -- ... rhm' )
    [ <rhythm-transformer> ] dip change-refs >rhythm-transformer< ; inline

<PRIVATE
:: (next-ref) ( ... place ndx parent value pred: ( ... value -- ... ? ) -- ... place' ref )
    value pred call place swap [ 1 + ] when
    [ ndx parent value <rhythm-ref> ] keep >>place ; inline

: (create-refs*) ( ... place ndx parent relt pred: ( ... value -- ... ? ) -- ... place' refs )
    over rhythm? [
        [ 2nip [ division>> ] keep ] dip
        [ [ rot ] dip (create-refs*) ] 2curry map-index
    ] [ (next-ref) ] if ; inline recursive
PRIVATE>

:: make-rhythm-transformer ( ... rhm place pred: ( ... value -- ... ? ) -- ... place' rt )
    place 0 f rhm pred (create-refs*)
    dup rhythm-ref? [ 1array ] [ flatten ] if
    rhm rhythm-transformer boa ; inline
