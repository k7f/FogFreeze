! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences.iterators arrays classes kernel locals
       make math om.rhythm refs sequences sequences.deep ;
IN: om.rhythm.dealers

! __________
! rhythm-ref

TUPLE: rhythm-ref
    { index integer }
    { parent maybe: rhythm-tree }
    { value rhythm-element initial: 1 } ;

INSTANCE: rhythm-ref ref
INSTANCE: rhythm-ref rhythm

M: rhythm-ref >rhythm-element ( ref -- relt ) value>> ;

: <rhythm-ref> ( ndx parent/f relt/f -- ref )
    [ 2dup division>> nth ] unless* rhythm-ref boa ;

: !rhythm-ref ( ref -- )
    dup parent>> [
        [ [ value>> ] [ index>> ] bi ] dip
        division>> set-nth
    ] [ drop ] if* ;

M: rhythm-ref get-ref ( ref -- relt/f )
    dup parent>> [ value>> ] [ drop f ] if ;

M: rhythm-ref set-ref ( relt/f ref -- )
    over [ value<< ] [ parent<< ] if ;

GENERIC# fit-ref 1 ( relt ref -- )

M: number fit-ref ( num ref -- ) value<< ;

M: rhythm-tree fit-ref ( rtree ref -- )
    [ value>> get-duration >>duration ] keep value<< ;

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

! _____________
! rhythm-dealer

TUPLE: rhythm-dealer
    { refs sequence }
    { underlying rhythm-tree } ;

INSTANCE: rhythm-dealer rhythm

M: rhythm-dealer >rhythm-element ( rdeal -- relt ) underlying>> ;

<PRIVATE
GENERIC: (create-refs) ( ndx parent relt -- refs )

: (next-refs) ( relt ndx parent -- refs ) rot (create-refs) ; inline

M: number (create-refs) ( ndx parent value -- ref ) <rhythm-ref> ; inline

M: rhythm-tree (create-refs) ( ndx parent rtree -- refs )
    2nip [ division>> ] keep [ (next-refs) ] curry map-index ;
PRIVATE>

: new-rhythm-dealer ( rtree class -- rdeal )
    new [ underlying<< ] [
        swap 0 f (next-refs) dup rhythm-ref?
        [ 1array ] [ flatten ] if >>refs
    ] 2bi ;

: <rhythm-dealer> ( rtree -- rdeal )
    rhythm-dealer new-rhythm-dealer ;

: >rhythm-dealer< ( rdeal -- rtree )
    [ refs>> [ !rhythm-ref ] each ] [ underlying>> ] bi ;

! __________________
! make-rhythm-dealer

<PRIVATE
:: (?add-ref) ( ... ndx parent value include: ( ... value -- ... ? ) -- ... )
    value include call [
        ndx parent value <rhythm-ref> ,
    ] when ; inline

DEFER: (more-refs)

: (create-some-refs) ( ... ndx parent relt include: ( ... value -- ... ? ) -- ... )
    over rhythm-tree? [
        [ 2nip [ division>> ] keep ] dip
        [ (more-refs) ] 2curry each-index
    ] [ (?add-ref) ] if ; inline recursive

: (more-refs) ( ... relt ndx parent include -- ... )
    [ rot ] dip (create-some-refs) ; inline
PRIVATE>

:: make-typed-rhythm-dealer ( ... rtree include: ( ... value -- ... ? ) class -- ... rdeal )
    0 f rtree include [ (create-some-refs) ] { } make
    rtree class new [ underlying<< ] [ refs<< ] [ ] tri ; inline

: make-rhythm-dealer ( ... rtree include: ( ... value -- ... ? ) -- ... rdeal )
    rhythm-dealer make-typed-rhythm-dealer ; inline

! ________________
! make-note-dealer

: make-note-dealer ( rtree -- rdeal )
    [ 0 > ] make-rhythm-dealer ;

! _____
! clone

M: rhythm-dealer clone ( rdeal -- rdeal' )
    (clone) [ [ clone ] map ] change-refs ; inline

! ___________________
! clone-rhythm-dealer

<PRIVATE
GENERIC: (rd-clone) ( newparent iter oldref oldrelt -- newrelt )

: ((rd-clone-atom)) ( newparent iter value -- value )
    [ ?step parent<< ] dip ; inline

: (rd-clone-atom) ( newparent iter oldref value newref -- value )
    swapd co-refs? [ ((rd-clone-atom)) ] [ 2nip ] if ; inline

M: number (rd-clone) ( newparent iter oldref value -- value )
    pick ?peek nip [ (rd-clone-atom) ] [ 2nip nip ] if* ;

:: (pre-clone-next) ( relt newparent iter ndx oldrtree -- newparent iter oldref relt )
    newparent iter ndx oldrtree relt [ <rhythm-ref> ] keep ; inline

M:: rhythm-tree (rd-clone) ( newparent iter oldref oldrtree -- newrtree )
    rhythm-tree new :> newrtree
    newrtree iter oldrtree [ division>> ] keep
    [ (pre-clone-next) (rd-clone) ] curry with with map-index
    newrtree swap >>division
    oldrtree duration>> clone >>duration ;
PRIVATE>

: clone-rhythm-dealer ( rdeal -- rdeal' )
    [ class-of new ]
    [ refs>> [ clone ] map dup ]
    [ underlying>> ] tri
    [ <iterator> f swap f ] [ (rd-clone) ] bi*
    [ >>refs ] [ >>underlying ] bi* ;

! ____________
! clone-rhythm

M: rhythm-dealer clone-rhythm ( rdeal -- rdeal' )
    clone-rhythm-dealer ;

! _______________
! map-rests>notes

<PRIVATE
: (?rests>notes-out) ( ref -- value/f )
    value>> dup integer? [
        dup 0 < [ neg ] [ drop f ] if
    ] [ drop f ] if ; inline

: (?rests>notes-in) ( ref -- value/f )
    value>> dup integer? [
        dup 0 > [ drop f ] [ abs >float  ] if
    ] [ abs ] if ; inline

: (?rests>notes) ( in? ref -- in?' )
    swap over [
        [ (?rests>notes-in) ]
        [ (?rests>notes-out) ] if
        [ dup ] [ f f ] if*
    ] dip set-ref ; inline
PRIVATE>

M: rhythm-dealer map-rests>notes! ( rdeal -- rdeal' )
    [ f ] [ refs>> ] bi [ (?rests>notes) ] each drop ;

M: rhythm-dealer map-rests>notes ( rdeal -- rdeal' )
    clone-rhythm map-rests>notes! ;

! ____________
! rhythm-atoms

! FIXME aliasing
M: rhythm-dealer rhythm-atoms ( rdeal -- atoms )
    [ refs>> [ value>> rhythm-atoms % ] each ] { } make ;

! ___________
! group-notes

<PRIVATE
: (next-slice) ( from to seq -- )
    <slice> [
        dup first value>> 0 > [ , ] [ drop ] if
    ] unless-empty ; inline

: (?group-next-slice) ( refs from ref ndx -- refs from' )
    swap value>> integer? [
        [ pick (next-slice) ] keep
    ] [ drop ] if ; inline

: (?group-last-slice) ( refs from -- )
    swap [ length ] keep (next-slice) ; inline
PRIVATE>

GENERIC: group-notes ( rhm -- slices )

M: rhythm-dealer group-notes ( rdeal -- slices )
    refs>> [ 0 ] keep [
        [ (?group-next-slice) ] each-index
        (?group-last-slice)
    ] { } make ;

M: rhythm-tree group-notes ( rtree -- slices )
    make-note-dealer group-notes ;

! _______________
! each-note-slice

: each-note-slice ( ... rhm quot: ( ... slice -- ... ) -- ... )
    [ group-notes ] dip each ; inline

! _______________
! map-note-slices

: map-note-slices! ( ... rhm quot: ( ... slice -- ... seq ) -- ... rhm' )
    [ dup group-notes ] dip [ [ !rhythm-ref ] each ] compose each ; inline

: map-note-slices ( ... rhm quot: ( ... slice -- ... seq ) -- ... rhm' )
    [ clone-rhythm ] dip map-note-slices! ; inline
