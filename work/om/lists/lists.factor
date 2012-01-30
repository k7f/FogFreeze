! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays assocs classes ff.assertions ff.errors grouping
       kernel make math math.order om.support prettyprint quotations
       sequences sequences.deep strings words ;
QUALIFIED: sets
IN: om.lists

! _____________________________________
! 01-basicproject/functions/lists.lisp

! _________
! last-elem

GENERIC: last-elem ( seq -- obj/f )

M: sequence last-elem ( seq -- obj/f )
    [ f ] [ last ] if-empty ;

! ______________
! last-n first-n

<PRIVATE
: (empty-chunk?) ( seq n -- ? )
    [ empty? ] [ zero? ] bi* or ; inline
PRIVATE>

GENERIC# last-n 1 ( seq n -- seq' )

M: sequence last-n ( seq n -- seq' )
    nonnegative-integer! 2dup (empty-chunk?) [
        drop f swap like
    ] [
        [ dup length ] dip -
        dup 1 < [ drop clone ] [ tail ] if
    ] if ;

GENERIC# first-n 1 ( seq n -- seq' )

M: sequence first-n ( seq n -- seq' )
    nonnegative-integer! 2dup (empty-chunk?) [
        drop f swap like
    ] [
        over length over < [ drop clone ] [ head ] if
    ] if ;

! ________
! x-append

<PRIVATE
: (x-append-length) ( obj1 obj2 &rest-seq -- n )
    [
        [ dup branch? [ length ] [ drop 1 ] if ] bi@ +
    ] dip sum-lengths-with-atoms + ; inline

: (x-append-new) ( obj1 obj2 &rest-seq -- seq )
    pick [ (x-append-length) ] dip
    dup branch? [ drop { } ] unless new-resizable ; inline

: (2-append!) ( seq obj -- seq )
    dup branch? [ append! ] [ suffix! ] if ; inline

GENERIC: (2-append) ( obj1 obj2 -- seq )

M: string (2-append) ( obj1 obj2 -- seq )
    over branch? [ suffix ] [ 2array ] if ; inline

M: sequence (2-append) ( obj seq -- seq' )
    over branch? [ append ] [ swap prefix ] if ; inline

M: object (2-append) ( obj1 obj2 -- seq )
    over branch? [ suffix ] [ 2array ] if ; inline

: (x-append) ( obj1 obj2 &rest-seq -- seq )
    [ (x-append-new) ] 3keep
    [ [ (2-append!) ] bi@ ] dip
    [ (2-append!) ] each ; inline
PRIVATE>

: x-append ( obj1 obj2 &rest -- seq )
    &rest>sequence [
        pick [ (x-append) ] dip
        dup branch? [ drop { } ] unless like
    ] [ (2-append) ] if* ;

! ____
! flat

<PRIVATE
: (flat-new) ( seq -- seq' )
    [ sum-lengths-with-atoms ] keep new-resizable ; inline

: (flat-exemplar) ( seq -- seq' )
    first dup branch? [ drop { } ] unless ; inline

: (flat-one) ( seq -- seq' )
    dup empty? [ clone ] [
        [ (flat-new) ] keep [ (2-append!) ] each
    ] if ; inline
PRIVATE>

! &optionals: (level nil)
GENERIC# flat 1 ( seq &optionals -- seq' )

M: sequence flat ( seq &optionals -- seq' )
    unpack1 [
        dup integer? [
            dup 0 > [
                dupd [ (flat-one) ] times swap like
            ] [ drop ] if
        ] [ drop ] if
    ] [ flatten ] if* ;

! ___________
! create-list

: create-list ( n obj -- seq )
    [ nonnegative-integer! ] dip <repetition> >array ;

! _________
! mat-trans

<PRIVATE
: (column-indices) ( mat -- indices )
    dup first length [ length max ] reduce iota ; inline
PRIVATE>

GENERIC: mat-trans ( mat -- mat' )

M: sequence mat-trans ( mat -- mat' )
    dup empty? [
        [ (column-indices) ] keep
        [ [ ?nth ] with V{ } map-as [ ] { } filter-as ] curry
        { } map-as
    ] unless ;

! __________
! remove-dup

<PRIVATE
: (remove-dup*) ( seq test: ( obj1 obj2 -- ? ) depth -- seq' )
    pick sequence? [
        dup 1 <= [
            drop [ <reversed> ] dip members* reverse  ! FIXME compatibility hack
        ] [
            1 - [ (remove-dup*) ] 2curry map
        ] if
    ] [ 2drop ] if ; inline recursive

: (remove-dup) ( seq depth -- seq' )
    over sequence? [
        dup 1 <= [
            drop <reversed> sets:members reverse  ! FIXME compatibility hack
        ] [
            1 - [ (remove-dup) ] curry map
        ] if
    ] [ drop ] if ; inline recursive
PRIVATE>

GENERIC# remove-dup 1 ( seq test-fun depth -- seq' )

M: word remove-dup ( seq test-sym depth -- seq' )
    [ 1quotation ] dip remove-dup ;

M: callable remove-dup ( seq test: ( obj1 obj2 -- ? ) depth -- seq' )
    dup fixnum? [
        over [ = ] = [ nip (remove-dup) ] [ (remove-dup*) ] if
    ] [ class-of invalid-input ] if ;

! ___________
! list-modulo

GENERIC# list-modulo 1 ( seq n -- arr )

M: sequence list-modulo ( seq n -- arr )
    <groups> mat-trans ;

! _________
! interlock

: (interlock) ( elt ndx seq-from seq-where -- )
    [ swap ] dip index [
        swap ?nth [ , ] when*
    ] [ drop ] if* , ; inline

: interlock ( seq-to seq-from seq-where -- result )
    pick [ [ (interlock) ] 2curry [ each-index ] 2curry ] dip make ;

! _________
! subs-posn

<PRIVATE
: (subs-nth) ( seq posn subs -- seq )
    swap nonnegative-integer! pick set-nth ; inline

: (scalar-subs-posn) ( seq posn subs -- seq )
    over sequence? [ [ (subs-nth) ] curry each ] [ (subs-nth) ] if ; inline
PRIVATE>

GENERIC: subs-posn ( seq posn subs -- seq )

M: quotation subs-posn ( seq posn subs -- seq ) (scalar-subs-posn) ;
M: string    subs-posn ( seq posn subs -- seq ) (scalar-subs-posn) ;

M: sequence subs-posn ( seq posn subs -- seq )
    over sequence? [
        [ ?nth (subs-nth) ] curry each-index
    ] [ ?first (subs-nth) ] if ;

M: object subs-posn ( seq posn subs -- seq ) (scalar-subs-posn) ;
