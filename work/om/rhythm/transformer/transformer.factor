! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences.iterators arrays kernel locals make math
       math.functions om.rhythm refs sequences sequences.deep ;
IN: om.rhythm.transformer

! __________
! rhythm-ref

TUPLE: rhythm-ref
    { index integer }
    { parent maybe: rhythm-tree }
    { value rhythm-element initial: 1 }
    { place integer } ;

INSTANCE: rhythm-ref ref
INSTANCE: rhythm-ref rhythm

M: rhythm-ref >rhythm-element ( ref -- relt ) value>> ;

: <rhythm-ref> ( ndx parent/f relt/f -- ref )
    [ 2dup division>> nth ] unless* 0 rhythm-ref boa ;

: !rhythm-ref ( ref -- )
    [ value>> ] [ index>> ] [ parent>> ] tri
    [ division>> set-nth ] [ 2drop ] if* ;

M: rhythm-ref get-ref ( ref -- relt/f )
    dup parent>> [ value>> ] [ drop f ] if ;

M: rhythm-ref set-ref ( relt/f ref -- )
    over [ value<< ] [ parent<< ] if ;

GENERIC# fit-ref 1 ( relt ref -- )

M: rhythm-element fit-ref ( relt ref -- ) set-ref ;

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

! __________________
! rhythm-transformer

TUPLE: rhythm-transformer
    { refs sequence }
    { underlying rhythm-tree } ;

INSTANCE: rhythm-transformer rhythm

M: rhythm-transformer >rhythm-element ( rtf -- relt ) underlying>> ;

<PRIVATE
GENERIC: (create-refs) ( ... place ndx parent relt -- ... place' refs )

M: number (create-refs) ( ... place ndx parent value -- ... place' ref )
    <rhythm-ref> [ [ 1 + ] keep ] dip swap >>place ;

: (next-refs) ( ... place relt ndx rtf -- ... place' refs )
    rot (create-refs) ; inline

M: rhythm-tree (create-refs) ( ... place ndx parent rtf -- ... place' refs )
    2nip [ division>> ] keep [ (next-refs) ] curry map-index ;
PRIVATE>

: <rhythm-transformer> ( rtree -- rtf )
    [
        [ 0 0 f ] dip (create-refs) nip dup rhythm-ref?
        [ 1array ] [ flatten ] if
    ] keep rhythm-transformer boa ;

: >rhythm-transformer< ( rtf -- rtree )
    [ refs>> [ !rhythm-ref ] each ] [ underlying>> ] bi ;

! _______________________
! make-rhythm-transformer

<PRIVATE
:: (placed-ref) ( ... place ndx parent value increment: ( ... value -- ... ? ) -- ... place' ref )
    place value increment call [ 1 + ] when
    [ ndx parent value <rhythm-ref> ] keep >>place ; inline

DEFER: (more-placed-refs)

: (create-placed-refs) ( ... place ndx parent relt increment: ( ... value -- ... ? ) -- ... place' refs )
    over rhythm-tree? [
        [ 2nip [ division>> ] keep ] dip
        [ (more-placed-refs) ] 2curry map-index
    ] [ (placed-ref) ] if ; inline recursive

: (more-placed-refs) ( ... place relt ndx parent increment -- ... place' refs )
    [ rot ] dip (create-placed-refs) ; inline
PRIVATE>

:: make-rhythm-transformer ( ... rtree place increment: ( ... value -- ... ? ) -- ... lastplace rtf )
    place 0 f rtree increment (create-placed-refs)
    dup rhythm-ref? [ 1array ] [ flatten ] if
    rtree rhythm-transformer boa ; inline

! ________________________
! make-rhythm-transformer*

<PRIVATE
:: (placed-ref*) ( ..a place ndx parent value include: ( ..a value -- ..b ? ) increment: ( ..b value -- ..a ? ) -- ..a place' )
    value include call [
        place value increment call [ 1 + ] when
        [ ndx parent value <rhythm-ref> ] keep >>place ,
    ] [ place ] if ; inline

DEFER: (more-placed-refs*)

: (create-placed-refs*) ( ..a place ndx parent relt include: ( ..a value -- ..b ? ) increment: ( ..b value -- ..a ? ) -- ..a place' )
    pick rhythm-tree? [
        [ 2nip [ division>> ] keep ] 2dip
        [ (more-placed-refs*) ] 3curry each-index
    ] [ (placed-ref*) ] if ; inline recursive

: (more-placed-refs*) ( ... place relt ndx parent include increment -- ... place' )
    [ rot ] 2dip (create-placed-refs*) ; inline
PRIVATE>

:: make-rhythm-transformer* ( ..a rtree place include: ( ..a value -- ..b ? ) increment: ( ..b value -- ..a ? ) -- ..a lastplace rtf )
    place 0 f rtree include increment
    [ (create-placed-refs*) ] { } make
    rtree rhythm-transformer boa ; inline

! _____________________
! make-note-transformer

: make-note-transformer ( rtree place -- lastplace rtf )
    [ dup integer? [ 0 > ] [ drop f ] if ] make-rhythm-transformer ;

: make-note-transformer* ( rtree place -- lastplace rtf )
    [ 0 > ] [ integer? ] make-rhythm-transformer* ;

! _____
! clone

M: rhythm-transformer clone ( rtf -- rtf' )
    (clone) [ [ clone ] map ] change-refs ; inline

! ____________
! clone-rhythm

<PRIVATE
GENERIC: (rtf-clone) ( newparent iter oldref oldrelt -- newrelt )

: ((rtf-clone-atom)) ( newparent iter value -- value )
    [ ?step parent<< ] dip ; inline

: (rtf-clone-atom) ( newparent iter oldref value newref -- value )
    swapd co-refs? [ ((rtf-clone-atom)) ] [ 2nip ] if ; inline

M: number (rtf-clone) ( newparent iter oldref value -- value )
    pick ?peek nip [ (rtf-clone-atom) ] [ 2nip nip ] if* ;

:: (pre-clone-next) ( relt newparent iter ndx oldrtree -- newparent iter oldref relt )
    newparent iter ndx oldrtree relt [ <rhythm-ref> ] keep ; inline

M:: rhythm-tree (rtf-clone) ( newparent iter oldref oldrtree -- newrtree )
    rhythm-tree new :> newrtree
    newrtree iter oldrtree [ division>> ] keep
    [ (pre-clone-next) (rtf-clone) ] curry with with map-index
    newrtree swap >>division
    oldrtree duration>> clone >>duration ;
PRIVATE>

M: rhythm-transformer clone-rhythm ( rtf -- rtf' )
    [ refs>> [ clone ] map ]
    [ underlying>> ] bi over
    [ <iterator> f swap f ] [ (rtf-clone) ] [ swap ] tri*
    rhythm-transformer boa ;

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

M: rhythm-transformer map-rests>notes! ( rtf -- rtf' )
    [ f ] [ refs>> ] bi [ (?rests>notes) ] each drop ;

M: rhythm-transformer map-rests>notes ( rtf -- rtf' )
    clone-rhythm map-rests>notes! ;

! __________________
! submap-notes>rests

<PRIVATE
: (?sub-notes>rests-start) ( ref places value -- value/f )
    swap rot place>> swap member?
    [ neg ] [ drop f ] if ; inline

: (sub-notes>rests-cont) ( ref places value -- value/f )
    2nip neg round >integer ; inline

: (?sub-notes>rests-out) ( ref places -- value/f )
    over value>> dup integer? [
        dup 0 > [ (?sub-notes>rests-start) ] [ 3drop f ] if
    ] [ 3drop f ] if ; inline

: (?sub-notes>rests-in) ( ref places -- value/f )
    over value>> dup integer? [
        dup 0 > [ (?sub-notes>rests-start) ] [ 3drop f ] if
    ] [ (sub-notes>rests-cont) ] if ; inline

: (?sub-notes>rests) ( in? ref places -- in?' )
    rot pick [
        [ (?sub-notes>rests-in) ]
        [ (?sub-notes>rests-out) ] if
        [ dup ] [ f f ] if*
    ] dip set-ref ; inline
PRIVATE>

M: rhythm-transformer submap-notes>rests! ( rtf places -- rtf' )
    [ [ f ] [ refs>> ] bi ] dip [ (?sub-notes>rests) ] curry each drop ;

M: rhythm-transformer submap-notes>rests ( rtf places -- rtf' )
    [ clone-rhythm ] [ submap-notes>rests! ] bi* ;

M: rhythm-tree submap-notes>rests ( rtree places -- rtree' )
    [ -1 make-note-transformer nip ]
    [ submap-notes>rests >rhythm-transformer< ] bi* ;

M: rhythm-tree submap-notes>rests! ( rtree places -- rtree' )
    [ -1 make-note-transformer nip ]
    [ submap-notes>rests! >rhythm-transformer< ] bi* ;

! ____________
! rhythm-atoms

M: rhythm-transformer rhythm-atoms ( rtf -- atoms )
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

M: rhythm-transformer group-notes ( rtf -- slices )
    refs>> [ 0 ] keep [
        [ (?group-next-slice) ] each-index
        (?group-last-slice)
    ] { } make ;

M: rhythm-tree group-notes ( rtree -- slices )
    -1 make-note-transformer* nip group-notes ;

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

! __________________
! rhythm-change-nths

GENERIC# rhythm-change-nths 2 ( rhm places values -- rhm )

<PRIVATE
: (rtf-change-nth) ( place value rtf -- )
    [ swap ] [ refs>> ] bi* nth fit-ref ; inline

: (rtf-change-nths) ( places values rtf -- )
    [ [ nth ] dip (rtf-change-nth) ] 2curry each-index ; inline
PRIVATE>

M: rhythm-transformer rhythm-change-nths ( rtf places values -- rtf )
    rot [ (rtf-change-nths) ] keep ;

M: rhythm-tree rhythm-change-nths ( rtree places values -- rtree )
    rot <rhythm-transformer> [ (rtf-change-nths) ] keep >rhythm-transformer< ;
