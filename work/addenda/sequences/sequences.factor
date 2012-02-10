! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math quotations sequences sequences.private strings ;
IN: addenda.sequences

! FIXME find out why is quotation a branch?
GENERIC: ,:branch? ( obj -- ? )

M: quotation ,:branch? drop f ;
M: string    ,:branch? drop f ;
M: sequence  ,:branch? drop t ;
M: object    ,:branch? drop f ;

: sum-lengths-with-atoms ( seq -- n )
    0 [ dup ,:branch? [ length ] [ drop 1 ] if + ] reduce ; inline

! _________
! filtering

<PRIVATE
: (push-when) ( ? elt seq -- )
    rot [ push ] [ 2drop ] if ; inline

: (push-if-index) ( ..a ndx elt quot: ( ..a elt ndx -- ..b ? ) accum -- ..b )
    [ over [ swapd call ] dip ] dip (push-when) ; inline

: (push-if/index) ( ..a ndx elt quot: ( ..a elt -- ..b ? ) accum -- ..b )
    [ rot [ call ] dip ] dip (push-when) ; inline

: (selector-for-index) ( quot: ( ..a elt ndx -- ..b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (push-if-index) ] 2curry ] keep ; inline

: (selector-for/index) ( quot: ( ..a elt -- ..b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (push-if/index) ] 2curry ] keep ; inline
PRIVATE>

: filter-as-index ( ..a seq quot: ( ..a elt ndx -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (selector-for-index) [ 2each ] dip ] curry dip like ; inline

: filter-index ( ..a seq quot: ( ..a elt ndx -- ..b ? ) -- ..b seq' )
    over filter-as-index ; inline

: filter-as/indices ( ..a seq quot: ( ..a elt -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (selector-for/index) [ 2each ] dip ] curry dip like ; inline

: filter/indices ( ..a seq quot: ( ..a elt -- ..b ? ) -- ..b seq' )
    over filter-as/indices ; inline

<PRIVATE
: (filter-integers) ( ..a len quot: ( ..a i -- ..b elt ? ) accum -- ..b )
    [ swap [ push ] [ 2drop ] if ] curry compose each-integer ; inline
PRIVATE>

: filter-integers ( ..a len quot: ( ..a i -- ..b elt ? ) exemplar -- ..b newseq )
    [ over ] dip [ new-resizable [ (filter-integers) ] keep ] keep like ; inline

: 2filter-as ( ..a seq1 seq2 quot: ( ..a elt1 elt2 -- ..b newelt ? ) exemplar -- ..b newseq )
    [ (2each) ] dip filter-integers ; inline

: 2filter ( ..a seq1 seq2 quot: ( ..a elt1 elt2 -- ..b newelt ? ) -- ..b newseq )
    pick 2filter-as ; inline

! ____________
! accumulating

<PRIVATE
: (iterator) ( seq quot -- n quot' )
    [ [ length ] keep ] dip
    [ [ nth-unsafe ] dip curry keep ] 2curry ; inline

: (map-integers+) ( ..a len quot: ( ..a i -- ..b elt ) exemplar -- ..b newseq )
    [ over 1 + ] dip [ [ collect ] keep ] new-like ; inline
PRIVATE>

: accumulate-all-as ( ..a seq identity quot: ( ..a prev elt -- ..b next ) exemplar -- ..b newseq )
    [ swapd (iterator) ] dip pick
    [ (map-integers+) ] dip swap
    [ set-nth-unsafe ] keep ; inline

: accumulate-all ( ..a seq identity quot: ( ..a prev elt -- ..b next ) -- ..b newseq )
    pick accumulate-all-as ; inline

! _________
! searching

: find-tail ( seq candidates -- tailseq/f )
    dupd [
        [ eq? ] with find drop
    ] curry find drop [ tail ] [ drop f ] if* ; inline

: find-tail* ( seq candidates -- tailseq/f )
    [ f over ] dip [
        [ eq? ] curry find rot drop
    ] with find drop [ tail ] [ 2drop f ] if ; inline
