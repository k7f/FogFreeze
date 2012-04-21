! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.sequences.iterators arrays kernel locals macros make
       math math.functions om.rhythm om.rhythm.dealers refs sequences
       sequences.deep ;
IN: om.rhythm.transformer

! __________________
! rhythm-transformer

TUPLE: rhythm-transformer < rhythm-dealer
    { event-indices sequence } ;

INSTANCE: rhythm-transformer rhythm

: <rhythm-transformer> ( rtree -- rtf )
    rhythm-transformer new-rhythm-dealer
    dup refs>> length iota >>event-indices ;

ALIAS: >rhythm-transformer< >rhythm-dealer<

! ______________________
! renumber-rhythm-events

<PRIVATE
: (incrementer) ( ... place increment: ( ... value -- ... ? ) ref -- ... place' )
    rot [ value>> swap call ] dip
    swap [ 1 + ] when ; inline

: (renumber-rhythm-events) ( ... place increment: ( ... value -- ... ? ) rtf -- ... places )
    refs>> [ (incrementer) dup ] with map nip ; inline
PRIVATE>

: renumber-rhythm-events ( ... rtf place increment: ( ... value -- ... ? ) -- ... rtf )
    pick (renumber-rhythm-events) >>event-indices ; inline

! ________________________
! make-rhythm-transformer*

: make-rhythm-transformer* ( ... rtree place increment: ( ... value -- ... ? ) -- ... rtf )
    [ rhythm-transformer new-rhythm-dealer ] 2dip
    renumber-rhythm-events ; inline

! _______________________
! make-rhythm-transformer

: make-rhythm-transformer ( ..a rtree place include: ( ..a value -- ..b ? ) increment: ( ..b value -- ..a ? ) -- ..a rtf )
    [ swapd rhythm-transformer make-typed-rhythm-dealer ] dip ! pl r i
    swapd renumber-rhythm-events ; inline

! ______________________
! make-note-transformer*

: make-note-transformer* ( rtree place -- rtf )
    [ dup integer? [ 0 > ] [ drop f ] if ] make-rhythm-transformer* ;

! _____________________
! make-note-transformer

: make-note-transformer ( rtree place -- rtf )
    [ 0 > ] [ integer? ] make-rhythm-transformer ;

! ____________
! clone-rhythm

M: rhythm-transformer clone-rhythm ( rtf -- rtf' )
    [ clone-rhythm-dealer ] keep
    event-indices>> clone >>event-indices ;

! __________________
! submap-notes>rests

<PRIVATE
: (?sub-notes>rests-start) ( value ndx places -- value/f )
    member? [ neg ] [ drop f ] if ; inline

:: (?sub-notes>rests-out) ( ref ndx places -- value/f )
    ref value>> dup integer? [
        dup 0 > [
            ndx places (?sub-notes>rests-start)
        ] [ drop f ] if
    ] [ drop f ] if ; inline

:: (?sub-notes>rests-in) ( ref ndx places -- value/f )
    ref value>> dup integer? [
        dup 0 > [
            ndx places (?sub-notes>rests-start)
        ] [ drop f ] if
    ] [ neg round >integer ] if ; inline

:: (?sub-notes>rests) ( in? ref ndx places -- in?' )
    ref ndx places in?
    [ (?sub-notes>rests-in) ]
    [ (?sub-notes>rests-out) ] if
    [ dup ] [ f f ] if*
    ref set-ref ; inline
PRIVATE>

M: rhythm-transformer submap-notes>rests! ( rtf places -- rtf' )
    [ [ f ] [ refs>> ] [ event-indices>> ] tri ] dip
    [ (?sub-notes>rests) ] curry 2each drop ;

M: rhythm-transformer submap-notes>rests ( rtf places -- rtf' )
    [ clone-rhythm ] [ submap-notes>rests! ] bi* ;

M: rhythm-tree submap-notes>rests! ( rtree places -- rtree' )
    [ -1 make-note-transformer ]
    [ submap-notes>rests! >rhythm-transformer< ] bi* ;

M: rhythm-tree submap-notes>rests ( rtree places -- rtree' )
    [ -1 make-note-transformer ]
    [ submap-notes>rests >rhythm-transformer< ] bi* ;

! __________________
! rhythm-change-nths

GENERIC# rhythm-change-nths 2 ( rhm places values -- rhm )

<PRIVATE
: (rtf-change-nth) ( place value rtf -- )
    [ swap ] [ swap over event-indices>> ] bi*
    index [ swap refs>> nth fit-ref ] [ 2drop ] if* ; inline

: (rtf-change-nths) ( places values rtf -- )
    [ [ nth ] dip (rtf-change-nth) ] 2curry each-index ; inline
PRIVATE>

M: rhythm-transformer rhythm-change-nths ( rtf places values -- rtf )
    rot [ (rtf-change-nths) ] keep ;

M: rhythm-tree rhythm-change-nths ( rtree places values -- rtree )
    rot <rhythm-transformer> [ (rtf-change-nths) ] keep >rhythm-transformer< ;
