! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math math.order quotations sequences sequences.private strings ;
IN: addenda.sequences

! FIXME find out why is quotation a branch?

GENERIC: atom? ( obj -- ? )

M: quotation atom? drop t ;
M: string    atom? drop t ;
M: sequence  atom? drop f ;
M: object    atom? drop t ;

PREDICATE: proper-sequence < sequence atom? not ;

: sum-lengths-with-atoms ( seq -- n )
    0 [ dup atom? [ drop 1 ] [ length ] if + ] reduce ; inline

: ?length ( obj -- n/f )
    dup sequence? [ length ] [ drop f ] if ; inline

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

! ________
! trimming

: trim-range-slice ( seq low high -- slice/f )
    [
        over [ before=? ] with find drop
        [ tail-slice ] [ drop f ] if*
    ] [
        over [ after=? ] with find-last drop
        [ 1 + head-slice ] [ drop f ] if*
    ] bi* ;

! _________________
! partial reduction

<PRIVATE
: (reduce-head) ( seq identity pred quot -- seq n result )
    [ swap [ (trim-head) 2dup head-slice ] dip ] dip reduce ; inline

: (reduce-tail) ( seq identity pred quot -- seq n result )
    [ swap [ (trim-tail) 2dup tail-slice ] dip ] dip reduce ; inline
PRIVATE>

: reduce-head ( ... seq identity pred: ( ... elt -- ... ? ) quot: ( ... prev elt -- ... next )  -- ... newseq result )
    (reduce-head) [ tail ] dip ; inline

: reduce-head-slice ( ..a seq identity pred: ( ..a elt -- ..b ? ) quot: ( ... prev elt -- ... next ) -- ..b slice result )
    (reduce-head) [ tail-slice ] dip ; inline

: reduce-tail ( ... seq identity pred: ( ... elt -- ... ? ) quot: ( ... prev elt -- ... next )  -- ... newseq result )
    (reduce-tail) [ head ] dip ; inline

: reduce-tail-slice ( ..a seq identity pred: ( ..a elt -- ..b ? ) quot: ( ... prev elt -- ... next ) -- ..b slice result )
    (reduce-tail) [ head-slice ] dip ; inline
