! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays circular classes ff.assertions ff.errors
       ff.sequences.deep grouping kernel locals make math math.functions
       math.order math.parser om.series om.support parser quotations sequences
       sequences.deep strings vocabs.parser words ;
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
        [ dup ff:branch? [ length ] [ drop 1 ] if ] bi@ +
    ] dip sum-lengths-with-atoms + ; inline

: (x-append-new) ( obj1 obj2 &rest-seq -- seq )
    pick [ (x-append-length) ] dip
    dup ff:branch? [ drop { } ] unless new-resizable ; inline

: (2-append!) ( seq obj -- seq )
    dup ff:branch? [ append! ] [ suffix! ] if ; inline

GENERIC: (2-append) ( obj1 obj2 -- seq )

M: string (2-append) ( obj1 obj2 -- seq )
    over ff:branch? [ suffix ] [ 2array ] if ; inline

M: sequence (2-append) ( obj seq -- seq' )
    over ff:branch? [ append ] [ swap prefix ] if ; inline

M: object (2-append) ( obj1 obj2 -- seq )
    over ff:branch? [ suffix ] [ 2array ] if ; inline

: (x-append) ( obj1 obj2 &rest-seq -- seq )
    [ (x-append-new) ] 3keep
    [ [ (2-append!) ] bi@ ] dip
    [ (2-append!) ] each ; inline
PRIVATE>

: x-append ( obj1 obj2 &rest -- seq )
    &rest>sequence [
        pick [ (x-append) ] dip
        dup ff:branch? [ drop { } ] unless like
    ] [ (2-append) ] if* ;

! ____
! flat

<PRIVATE
: (flat-new) ( seq -- seq' )
    [ sum-lengths-with-atoms ] keep new-resizable ; inline

: (flat-exemplar) ( seq -- seq' )
    first dup ff:branch? [ drop { } ] unless ; inline

: (flat-one) ( seq -- seq' )
    dup empty? [ clone ] [
        [ (flat-new) ] keep [ (2-append!) ] each
    ] if ; inline
PRIVATE>

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
! expand-lst

<PRIVATE
CONSTANT: (*valid-expand-chars*) { CHAR: * CHAR: _ }

DEFER: (expand-lst)

: (expand-*) ( ndx seq nrep -- count ? )
    [ 1 + ] [ ] [ nonnegative-integer! ] tri*
    -rot nth (expand-lst) <repetition> { } concat-as % 2 t ; inline

: (expand-_1) ( begin tailchars -- count ? )
    >string dup string>number [
        1 f arithm-ser %
    ] [ not-a-number ] ?if 1 t ; inline

: (expand-_s) ( begin tailchars s-ndx -- count ? )
    cut-slice rest-slice [ >string ] bi@ 2dup [ string>number ] bi@ dupd and [
        [ 2drop ] 2dip f arithm-ser %
    ] [ -rot swap ? not-a-number ] if* 1 t ; inline

: (expand-_) ( begin tailchars -- count ? )
    CHAR: s over index [ (expand-_s) ] [ (expand-_1) ] if* ; inline

: (expand-other) ( elt -- count )
    dup search [ , ] [ no-word , ] ?if 1 ; inline

:: (expand-string-eval) ( ndx seq elt pre sep post -- count )
    0 f pre [
        post empty? [
            sep CHAR: * eq? [ 2drop ndx seq pre (expand-*) ] when
        ] [
            sep CHAR: _ eq? [ 2drop pre post (expand-_) ] when
        ] if
    ] when [ drop elt (expand-other) ] unless ; inline

: (expand-string-parse) ( elt -- pre sep post )
    >array dup (*valid-expand-chars*) find-tail*
    [ length head* string>number ] [ ?first ] [ ] tri
    over [ rest ] [ drop f ] if ; inline

: (expand-string) ( ndx seq elt -- count )
    dup (expand-string-parse) (expand-string-eval) ; inline

: (expand-any) ( ndx seq elt -- count )
    dup cl-symbol? [ name>> (expand-string) ] [
        2nip dup ff:branch? [ (expand-lst) ] when , 1
    ] if ;

: (expand-pred) ( ndx seq -- ndx seq elt f )
    2dup ?nth dup ; inline

: (expand-step) ( ndx seq elt -- ndx' seq )
    2over [ [ (expand-any) ] dip + ] dip ; inline

: (expand-lst) ( obj -- seq )
    dup ff:branch? [
        [ f ] [
            [ [ 0 swap [ (expand-pred) ] [ (expand-step) ] while ] curry ]
            keep make [ 3drop ] dip
        ] if-empty
    ] [ [ [ 0 f ] dip (expand-any) drop ] { } make ] if ;
PRIVATE>

ALIAS: expand-lst (expand-lst)

! __________
! group-list

SYMBOLS: 'linear 'circular ;

<PRIVATE
: (size>sizes) ( seq size -- seq sizes )
    over length over / ceiling swap <repetition> ; inline

: (sizes>offsets-check) ( len offset ndx sizes -- len offset ndx sizes ? )
    2dup length < [
        [ 2dup > ] 2dip rot
    ] [ f ] if ; inline

: (sizes>offsets-check*) ( len offset ndx sizes -- len offset ndx sizes ? )
    2dup length < ; inline

: (sizes>offsets-step) ( offset ndx sizes -- offset' ndx' sizes offset )
    pick [ [ nth + ] 2keep [ 1 + ] dip ] dip ; inline

: (sizes>offsets-step*) ( len offset ndx sizes -- len offset' ndx' sizes offset )
    pick [ [ nth + over mod ] 2keep [ 1 + ] dip ] dip ; inline

: (sizes>offsets) ( len sizes mode -- sizes offsets )
    [ 0 0 ] 2dip 'circular eq?
    [ [ (sizes>offsets-check*) ] [ (sizes>offsets-step*) ] pick produce-as ]
    [ [ (sizes>offsets-check)  ] [ (sizes>offsets-step)  ] pick produce-as ]
    if [ 3drop ] 2dip ; inline

: ((next-chunk)) ( seq size offset -- chunk )
    pick [
        pick length over - rot min swapd
        [ [ [ nth , ] [ [ 1 + ] dip ] 2bi ] fixed2-times ]
    ] dip make 2nip ; inline

: ((next-chunk*)) ( seq size offset -- chunk )
    pick [
        swap [ circular boa ] dip
        [ [ [ first , ] [ rotate-circular ] [ ] tri ] fixed1-times ]
    ] dip make nip ; inline

: (next-chunk) ( seq ndx sizes offset -- seq ndx' sizes chunk )
    [ 2dup nth [ 1 + over ] 2dip swapd ] dip ((next-chunk)) ; inline

: (next-chunk*) ( seq ndx sizes offset -- seq ndx' sizes chunk )
    [ 2dup nth [ 1 + over ] 2dip swapd ] dip ((next-chunk*)) ; inline

: (group-list) ( seq sizes offsets mode -- seq' )
    [ 0 ] 3dip 'circular eq?
    [ [ (next-chunk*) ] fixed3-map! ]
    [ [ (next-chunk)  ] fixed3-map! ]
    if [ 3drop ] dip ; inline
PRIVATE>

GENERIC# group-list 1 ( seq segmentation mode -- seq' )

M: integer group-list ( seq size mode -- seq' )
    [ (size>sizes) ] dip group-list ;

M: sequence group-list ( seq sizes mode -- seq' )
    [ dup length ] 2dip [ (sizes>offsets) ] keep (group-list) ;

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
