! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences arrays kernel math om.rhythm refs
       sequences sequences.deep ;
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

<PRIVATE
: (create-refs*) ( ... place ndx parent relt pred: ( ... value -- ... ? ) -- ... place' refs )
    over rhythm? [
        [ 2nip [ division>> ] keep ] dip
        [ [ rot ] dip (create-refs*) ] 2curry map-index
    ] [
        keep [ -rot ] dip <rhythm-ref>
        [ [ 1 + ] when ] dip over >>place
    ] if ; inline recursive
PRIVATE>

: <rhythm-transformer*> ( ... rhm pred: ( ... value -- ... ? ) -- ... rt )
    over [
        [ -1 0 f ] 2dip (create-refs*) nip dup rhythm-ref?
        [ 1array ] [ flatten ] if
    ] dip rhythm-transformer boa ; inline

: >rhythm-transformer< ( rt -- rhm )
    [ refs>> [ !rhythm-ref ] each ] [ underlying>> ] bi ;

: with-rhythm-transformer ( ... rhm quot: ( ... refs -- ... refs' ) -- ... rhm' )
    [ <rhythm-transformer> ] dip change-refs >rhythm-transformer< ; inline

: with-rhythm-transformer* ( ... rhm pred: ( ... value -- ... ? ) quot: ( ... refs -- ... refs' ) -- ... rhm' )
    [ <rhythm-transformer*> ] dip change-refs >rhythm-transformer< ; inline
