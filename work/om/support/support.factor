! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes combinators ff.errors fry kernel locals macros math
       math.functions quotations sequences sequences.deep sequences.private
       strings ;
IN: om.support

GENERIC: unpack1 ( &optionals -- arg1/f )

M: quotation unpack1 ( &optionals -- arg1/f ) ; inline
M: string    unpack1 ( &optionals -- arg1/f ) ; inline
M: sequence  unpack1 ( &optionals -- arg1/f ) [ f ] [ first ] if-empty ; inline
M: object    unpack1 ( &optionals -- arg1/f ) ; inline

GENERIC# unpack2 1 ( &optionals arg1-default -- arg1 arg2/f )

M: quotation unpack2 ( &optionals arg1-default -- arg1 arg2/f ) drop f ; inline
M: string    unpack2 ( &optionals arg1-default -- arg1 arg2/f ) drop f ; inline

M: sequence unpack2 ( &optionals arg1-default -- arg1 arg2/f )
    swap [ f ] [
        nip dup length 1 = [ first f ] [ first2 ] if
    ] if-empty ;

M: object unpack2 ( &optionals arg1-default -- arg1 arg2/f ) drop f ; inline

MACRO:: om-binop-number ( quot: ( elt1 elt2 -- elt' ) -- )
    [
        {
            { [ over number? ] quot }
            { [ over sequence? ] [ quot curry map ] }
            [ drop class-of invalid-input ]
        } cond
    ] ;

MACRO:: om-binop-sequence ( quot: ( elt1 elt2 -- elt' ) -- )
    [
        {
            { [ over number? ] [ quot with map ] }
            { [ over sequence? ] [ quot 2map ] }
            [ drop class-of invalid-input ]
        } cond
    ] ;

! ____________________________
! nonstandard deep combinators

: fixed-deep-each ( obj quot: ( elt -- ) -- )
    [ call( elt -- ) ] 2keep over branch?
    [ [ fixed-deep-each ] curry each ] [ 2drop ] if ; inline recursive

: fixed-deep-filter ( obj quot: ( elt -- ? ) -- seq )
    over [ selector [ fixed-deep-each ] dip ] dip dup branch?
    [ like ] [ drop ] if ; inline

: deep-map-leaves ( ..a obj quot: ( ..a elt -- ..b elt' ) -- ..b newobj )
    '[ dup branch? [ @ ] unless ] deep-map ; inline

! FIXME keep the structure
: deep-filter-leaves ( ..a obj quot: ( ..a elt -- ..b ? ) -- ..b seq )
    over [
        selector [ '[ dup branch? [ drop ] [ @ ] if ] deep-each ] dip
    ] dip dup branch? [ like ] [ drop ] if ; inline

! FIXME keep the structure
: fixed-deep-filter-leaves ( obj quot: ( elt -- ? ) -- seq )
    over [
        selector [
            '[ dup branch? [ drop ] [ _ call( elt -- ) ] if ] deep-each
        ] dip
    ] dip dup branch? [ like ] [ drop ] if ; inline

: deep-reduce ( ..a seq identity quot: ( ..a prev elt -- ..b next ) -- ..b result )
    swapd '[ dup branch? [ drop ] [ @ ] if ] deep-each ; inline

: fixed-deep-reduce ( seq identity quot: ( prev elt -- next ) -- result )
    swapd '[ dup branch? [ drop ] [ _ call( prev elt -- next ) ] if ] deep-each ; inline

! ____________________________
! nonstandard flat combinators

<PRIVATE
: (push-when) ( ? elt seq -- )
    rot [ push ] [ 2drop ] if ; inline

: (fixed-push-if) ( elt quot: ( elt -- ? ) accum -- )
    [ over [ call( elt -- ? ) ] dip ] dip (push-when) ; inline

: (push-if-index) ( ..a ndx elt quot: ( ..a elt ndx -- ..b ? ) accum -- ..b )
    [ over [ swapd call ] dip ] dip (push-when) ; inline

: (fixed1-push-if-index) ( a ndx elt quot: ( a elt ndx -- b ? ) accum -- b )
    [ over [ swapd call( a elt ndx -- b ? ) ] dip ] dip (push-when) ; inline

: (push-if/index) ( ..a ndx elt quot: ( ..a elt -- ..b ? ) accum -- ..b )
    [ rot [ call ] dip ] dip (push-when) ; inline

: (fixed-push-if/index) ( ndx elt quot: ( elt -- ? ) accum -- )
    [ rot [ call( elt -- ? ) ] dip ] dip (push-when) ; inline

: (fixed-selector-for) ( quot exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (fixed-push-if) ] 2curry ] keep ; inline

: (selector-for-index) ( quot: ( ..a elt ndx -- ..b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (push-if-index) ] 2curry ] keep ; inline

: (fixed1-selector-for-index) ( quot: ( a elt ndx -- b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (fixed1-push-if-index) ] 2curry ] keep ; inline

: (selector-for/index) ( quot: ( ..a elt -- ..b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (push-if/index) ] 2curry ] keep ; inline

: (fixed-selector-for/index) ( quot: ( elt -- ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (fixed-push-if/index) ] 2curry ] keep ; inline
PRIVATE>

! non-polymorphic variants (fixed stack depth)

: fixed-filter-as ( seq quot: ( elt -- ? ) exemplar -- seq' )
    dup [ (fixed-selector-for) [ each ] dip ] curry dip like ; inline

: fixed-filter ( seq quot: ( elt -- ? ) -- seq' )
    over fixed-filter-as ; inline

! index-dependent variants

: filter-as-index ( ..a seq quot: ( ..a elt ndx -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (selector-for-index) [ 2each ] dip ] curry dip like ; inline

: fixed1-filter-as-index ( a seq quot: ( a elt ndx -- b ? ) exemplar -- b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (fixed1-selector-for-index) [ 2each ] dip ] curry dip like ; inline

: filter-index ( ..a seq quot: ( ..a elt ndx -- ..b ? ) -- ..b seq' )
    over filter-as-index ; inline

: fixed1-filter-index ( a seq quot: ( a elt ndx -- b ? ) -- b seq' )
    over fixed1-filter-as-index ; inline

! index-collecting variants

: filter-as/indices ( ..a seq quot: ( ..a elt -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (selector-for/index) [ 2each ] dip ] curry dip like ; inline

: fixed-filter-as/indices ( seq quot: ( elt -- ? ) exemplar -- seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (fixed-selector-for/index) [ 2each ] dip ] curry dip like ; inline

: filter/indices ( ..a seq quot: ( ..a elt -- ..b ? ) -- ..b seq' )
    over filter-as/indices ; inline

: fixed-filter/indices ( seq quot: ( elt -- ? ) -- seq' )
    over fixed-filter-as/indices ; inline

! accumulator

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

! ____
! math

: >power-of-2 ( m -- n )
    dup 0 > [ log2 2^ ] [ drop 0 ] if ; inline

: cl-floor ( num div -- quo rem )
    2dup / floor [ * - ] [ >integer ] bi swap ;
