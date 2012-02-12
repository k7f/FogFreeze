! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math sequences ;
IN: addenda.sequences.iterators

TUPLE: iterator { seq read-only } { index integer } ;

M: iterator length [ seq>> length ] keep index>> - ; inline
M: iterator virtual@ [ index>> + ] keep seq>> ; inline
M: iterator virtual-exemplar seq>> ; inline

INSTANCE: iterator virtual-sequence

: <iterator> ( seq -- iter ) 0 iterator boa ;
: rewind     ( iter -- )     0 swap index<< ;

: ?peek ( iter -- ndx elt/f )
    [ index>> dup ] [ seq>> ?nth ] bi ; inline

: ?step ( iter -- elt/f )
    dup ?peek [ [ 1 + swap index<< ] dip ] [ 2drop f ] if* ; inline

: fold ( ..a iter quot: ( ..a prev elt -- ..b next ) -- ..b result )
    over ?step [
        [ over ?step dup ] rot while drop nip
    ] [ drop f swap seq>> like ] if* ; inline
