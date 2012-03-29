! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences.iterators arrays kernel locals math
       om.rhythm refs sequences sequences.deep ;
IN: om.rhythm.transformer

! __________
! rhythm-ref

TUPLE: rhythm-ref
    { index integer }
    { parent maybe: rhythm }
    { value rhythm-element initial: 1 }
    { place integer } ;

INSTANCE: rhythm-ref ref

: <rhythm-ref> ( ndx parent/f relt/f -- ref )
    [ 2dup division>> nth ] unless* 0 rhythm-ref boa ;

: !rhythm-ref ( ref -- )
    [ value>> ] [ index>> ] [ parent>> ] tri
    [ division>> set-nth ] [ 2drop ] if* ;

M: rhythm-ref get-ref ( ref -- relt/f )
    dup parent>> [ value>> ] [ drop f ] if ;

M: rhythm-ref set-ref ( relt/f ref -- )
    over [ value<< ] [ parent<< ] if ;

<PRIVATE
: (co-refs?) ( ref2 ref1 parent -- ref2 ? )
    [ [ parent>> ] dip eq? ]
    [ over [ value>> ] bi@ eq? ] if* ; inline
PRIVATE>

: co-refs? ( ref1 ref2 -- ref2/f )
    2dup [ index>> ] bi@ = [
        swap over parent>>
        (co-refs?) [ drop f ] unless
    ] [ 2drop f ] if ;

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

:: make-rhythm-transformer ( ... rhm place pred: ( ... value -- ... ? ) -- ... lastplace rt )
    place 0 f rhm pred (create-refs*)
    dup rhythm-ref? [ 1array ] [ flatten ] if
    rhm rhythm-transformer boa ; inline

<PRIVATE
GENERIC: (rt-clone) ( newparent iter oldref oldrelt -- newrelt )

: ((rt-clone-atom)) ( newparent iter value -- value )
    [ ?step parent<< ] dip ; inline

: (rt-clone-atom) ( newparent iter oldref value newref -- value )
    swapd co-refs? [ ((rt-clone-atom)) ] [ 2nip ] if ; inline

M: number (rt-clone) ( newparent iter oldref value -- value )
    pick ?peek nip [ (rt-clone-atom) ] [ 2nip nip ] if* ;

:: (pre-clone-next) ( relt newparent iter ndx oldrhm -- newparent iter oldref relt )
    newparent iter ndx oldrhm relt [ <rhythm-ref> ] keep ; inline

M:: rhythm (rt-clone) ( newparent iter oldref oldrhm -- newrhm )
    rhythm new :> newrhm
    newrhm iter oldrhm [ division>> ] keep
    [ (pre-clone-next) (rt-clone) ] curry with with map-index
    newrhm swap >>division
    oldrhm duration>> clone >>duration ;
PRIVATE>

M: rhythm-transformer clone ( rt -- rt' )
    (clone) [ [ clone ] map ] change-refs ; inline

M: rhythm-transformer clone-rhythm ( rt -- rt' )
    [ refs>> [ clone ] map ]
    [ underlying>> ] bi over
    [ <iterator> f swap f ] [ (rt-clone) ] [ swap ] tri*
    rhythm-transformer boa ;
