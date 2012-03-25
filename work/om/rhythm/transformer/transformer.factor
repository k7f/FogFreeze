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
GENERIC: (create-refs) ( ndx parent relt -- ndx' refs )

M: number (create-refs) ( ndx parent value -- ndx' ref )
    [ [ 1 + ] keep ] 2dip <rhythm-ref> ;

: (create-next-refs) ( ndx relt rhm -- ndx' refs )
    swap (create-refs) ; inline

M: rhythm (create-refs) ( ndx parent rhm -- ndx' refs )
    nip [ division>> ] keep [ (create-next-refs) ] curry map ;
PRIVATE>

: <rhythm-transformer> ( rhm -- rt )
    [
        0 f rot (create-refs) nip dup rhythm-ref?
        [ 1array ] [ flatten ] if
    ] keep rhythm-transformer boa ;

<PRIVATE
: (create-refs*) ( ndx parent relt pred: ( ... value -- ... ? ) -- ndx' refs )
    over rhythm? [
        [ nip [ division>> ] keep ] dip
        [ swapd (create-refs*) ] 2curry map
    ] [
        keep swapd
        [ [ 1 + ] when dup ] 2dip <rhythm-ref>
    ] if ; inline recursive
PRIVATE>

: <rhythm-transformer*> ( ... rhm pred: ( ... value -- ... ? ) -- ... rt )
    over [
        [ -1 f ] 2dip (create-refs*) nip dup rhythm-ref?
        [ 1array ] [ flatten ] if
    ] dip rhythm-transformer boa ; inline

: >rhythm-transformer< ( rt -- rhm )
    [ refs>> [ !rhythm-ref ] each ] [ underlying>> ] bi ;

: with-rhythm-transformer ( ... rhm quot: ( ... refs -- ... refs' ) -- ... rhm' )
    [ <rhythm-transformer> ] dip change-refs >rhythm-transformer< ; inline

: with-rhythm-transformer* ( ... rhm pred: ( ... value -- ... ? ) quot: ( ... refs -- ... refs' ) -- ... rhm' )
    [ <rhythm-transformer*> ] dip change-refs >rhythm-transformer< ; inline
