! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes combinators combinators.short-circuit ff.errors fry kernel
       locals macros math math.functions quotations sequences sequences.deep
       strings ;
IN: om.support

: &optional-unpack1 ( &optionals -- arg1/f )
    dup { [ sequence? ] [ quotation? not ] [ string? not ] } 1&& [
        [ f ] [ first ] if-empty
    ] when ; inline

: &optional-unpack2 ( &optionals arg1-default -- arg1 arg2/f )
    over { [ sequence? ] [ quotation? not ] [ string? not ] } 1&& [
        swap [ f ] [
            nip dup length 1 = [ first f ] [ first2 ] if
        ] if-empty
    ] [ drop f ] if ; inline

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

: deep-each* ( obj quot: ( elt -- ) -- )
    [ call( elt -- ) ] 2keep over branch?
    [ [ deep-each* ] curry each ] [ 2drop ] if ; inline recursive

: deep-filter* ( obj quot: ( elt -- ? ) -- seq )
    over [ selector [ deep-each* ] dip ] dip dup branch?
    [ like ] [ drop ] if ; inline

! FIXME keep the structure
: deep-filter-leaves ( ..a obj quot: ( ..a elt -- ..b ? ) -- ..b seq )
    over [
        selector [ '[ dup branch? [ drop ] [ @ ] if ] deep-each ] dip
    ] dip dup branch? [ like ] [ drop ] if ; inline

! FIXME keep the structure
: deep-filter-leaves* ( obj quot: ( elt -- ? ) -- seq )
    over [
        selector [
            '[ dup branch? [ drop ] [ _ call( elt -- ) ] if ] deep-each
        ] dip
    ] dip dup branch? [ like ] [ drop ] if ; inline

: deep-reduce ( ..a seq identity quot: ( ..a prev elt -- ..b next ) -- ..b result )
    swapd '[ dup branch? [ drop ] [ @ ] if ] deep-each ; inline

: deep-reduce* ( seq identity quot: ( prev elt -- next ) -- result )
    swapd '[ dup branch? [ drop ] [ _ call( prev elt -- next ) ] if ] deep-each ; inline

: push-if/index ( ..a ndx elt quot: ( ..a elt -- ..b ? ) accum -- ..b )
    [ rot [ call ] dip f ? ] dip
    swap [ swap push ] [ drop ] if* ; inline

: push-if/index* ( ndx elt quot: ( elt -- ? ) accum -- )
    [ rot [ call( elt -- ? ) ] dip f ? ] dip
    swap [ swap push ] [ drop ] if* ; inline

: selector-for/index ( quot: ( ..a elt -- ..b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ push-if/index ] 2curry ] keep ; inline

: selector-for/index* ( quot: ( elt -- ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ push-if/index* ] 2curry ] keep ; inline

: filter-as/indices ( ..a seq quot: ( ..a elt -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ selector-for/index [ 2each ] dip ] curry dip like ; inline

: filter-as/indices* ( seq quot: ( elt -- ? ) exemplar -- seq' )
    [ [ length iota ] keep ] 2dip
    dup [ selector-for/index* [ 2each ] dip ] curry dip like ; inline

: filter/indices ( ..a seq quot: ( ..a elt -- ..b ? ) -- ..b seq' )
    over filter-as/indices ; inline

: filter/indices* ( seq quot: ( elt -- ? ) -- seq' )
    over filter-as/indices* ; inline

: >power-of-2 ( m -- n )
    dup 0 > [ log2 2^ ] [ drop 0 ] if ; inline

: cl-floor ( num div -- quo rem )
    2dup / floor [ * - ] [ >integer ] bi swap ;
