! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel sequences ;
IN: addenda.sequences

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

! index-dependent variants

: filter-as-index ( ..a seq quot: ( ..a elt ndx -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (selector-for-index) [ 2each ] dip ] curry dip like ; inline

: filter-index ( ..a seq quot: ( ..a elt ndx -- ..b ? ) -- ..b seq' )
    over filter-as-index ; inline

! index-collecting variants

: filter-as/indices ( ..a seq quot: ( ..a elt -- ..b ? ) exemplar -- ..b seq' )
    [ [ length iota ] keep ] 2dip
    dup [ (selector-for/index) [ 2each ] dip ] curry dip like ; inline

: filter/indices ( ..a seq quot: ( ..a elt -- ..b ? ) -- ..b seq' )
    over filter-as/indices ; inline
