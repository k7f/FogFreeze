! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences.private kernel math sequences sequences.private ;
IN: addenda.sequences.mono

! FIXME replace ad-hoc definitions of monomorphic combinators with generic macros

<PRIVATE
: (fixed-push-if) ( elt quot: ( elt -- ? ) accum -- )
    [ over [ call( elt -- ? ) ] dip ] dip (push-when) ; inline

: (fixed1-push-if-index) ( a ndx elt quot: ( a elt ndx -- b ? ) accum -- b )
    [ over [ swapd call( a elt ndx -- b ? ) ] dip ] dip (push-when) ; inline

: (fixed-push-if/index) ( ndx elt quot: ( elt -- ? ) accum -- )
    [ rot [ call( elt -- ? ) ] dip ] dip (push-when) ; inline

: (fixed-selector-for) ( quot exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (fixed-push-if) ] 2curry ] keep ; inline

: (fixed1-selector-for-index) ( quot: ( a elt ndx -- b ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (fixed1-push-if-index) ] 2curry ] keep ; inline

: (fixed-selector-for/index) ( quot: ( elt -- ? ) exemplar -- selector accum )
    [ length ] keep new-resizable [ [ (fixed-push-if/index) ] 2curry ] keep ; inline

: (fixed-find) ( seq quot quot' -- i elt )
    pick [
        [ (each) ] dip call( n quot: ( i -- ? ) -- i )
    ] dip finish-find ; inline

: (fixed1-each-integer) ( a i n quot: ( a i -- a' ) -- a' )
    2over < [
        [ nip call( a i -- a' ) ] 3keep [ 1 + ] 2dip (fixed1-each-integer)
    ] [ 3drop ] if ; inline recursive

: (fixed2-each-integer) ( a b i n quot: ( a b i -- a' b' ) -- a' b' )
    2over < [
        [ nip call( a b i -- a' b' ) ] 3keep [ 1 + ] 2dip (fixed2-each-integer)
    ] [ 3drop ] if ; inline recursive
PRIVATE>

: fixed-filter-as ( seq quot: ( elt -- ? ) exemplar -- seq' )
    dup [ (fixed-selector-for) [ each ] dip ] curry dip like ; inline

: fixed-filter ( seq quot: ( elt -- ? ) -- seq' )
    over fixed-filter-as ; inline

: fixed-find ( seq quot: ( elt -- ? ) -- i elt )
    [ find-integer ] (fixed-find) ; inline

: fixed-any? ( seq quot: ( elt -- ? ) -- ? )
    fixed-find drop >boolean ; inline

: fixed1-each-integer ( a n quot: ( a i -- a' ) -- a' )
    [ 0 ] 2dip (fixed1-each-integer) ; inline

: fixed2-each-integer ( a b n quot: ( a b i -- a' b' ) -- a' b' )
    [ 0 ] 2dip (fixed2-each-integer) ; inline

: fixed1-times ( a n quot: ( a -- a' ) -- a' )
    [ drop ] prepose fixed1-each-integer ; inline

: fixed2-times ( a b n quot: ( a b -- a' b' ) -- a' b' )
    [ drop ] prepose fixed2-each-integer ; inline

: fixed3-map! ( a b c seq quot: ( a b c elt -- a b c newelt ) -- a b c seq )
    over [ map-into ] over [ call( a b c seq quot into -- a b c ) ] dip ; inline

! index-dependent variants

: fixed1-filter-as-index ( a seq quot: ( a elt ndx -- b ? ) exemplar -- b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (fixed1-selector-for-index) [ 2each ] dip ] curry dip like ; inline

: fixed1-filter-index ( a seq quot: ( a elt ndx -- b ? ) -- b seq' )
    over fixed1-filter-as-index ; inline

! index-collecting variants

: fixed-filter-as/indices ( seq quot: ( elt -- ? ) exemplar -- seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (fixed-selector-for/index) [ 2each ] dip ] curry dip like ; inline

: fixed-filter/indices ( seq quot: ( elt -- ? ) -- seq' )
    over fixed-filter-as/indices ; inline
