! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math sequences ;
IN: addenda.sequences.iterators

GENERIC: rewind ( iter -- )

! ________
! iterator

TUPLE: iterator { seq read-only } { index integer } ;

M: iterator length [ seq>> length ] keep index>> - ; inline
M: iterator virtual@ [ index>> + ] keep seq>> ; inline
M: iterator virtual-exemplar seq>> ; inline

INSTANCE: iterator virtual-sequence

: <iterator> ( seq -- iter ) 0 iterator boa ;
: >iterator< ( iter -- seq ) seq>> ;

M: iterator rewind ( iter -- ) 0 swap index<< ;

: ?peek ( iter -- ndx elt/f )
    [ index>> dup ] [ seq>> ?nth ] bi ; inline

: ?step ( iter -- elt/f )
    dup ?peek [ [ 1 + swap index<< ] dip ] [ 2drop f ] if* ; inline

<PRIVATE
: (fold) ( ..a iter quot: ( ..a prev elt -- ..b next ) elt -- ..b result )
    [ over ?step dup ] rot while drop nip ; inline

: (empty-fold) ( iter quot -- result )
    2drop f ; inline
PRIVATE>

: fold ( ..a iter quot: ( ..a prev elt -- ..b next ) -- ..b result )
    over ?step [ (fold) ] [ (empty-fold) ] if* ; inline

! ___________
! bi-iterator

TUPLE: bi-iterator { seq1 read-only } { seq2 read-only } { index integer } ;

M: bi-iterator length [ seq2>> length ] keep index>> - ; inline
M: bi-iterator virtual@ [ index>> + ] keep seq2>> ; inline
M: bi-iterator virtual-exemplar seq2>> ; inline

INSTANCE: bi-iterator virtual-sequence

: <bi-iterator> ( seq1 seq2 -- iter ) 0 bi-iterator boa ;
: >bi-iterator< ( iter -- seq1 seq2 ) [ seq1>> ] [ seq2>> ] bi ;

M: bi-iterator rewind ( iter -- ) 0 swap index<< ;

: ?bi-peek ( iter -- ndx elt1/f elt2/f )
    [ index>> dup dup ] [ seq1>> ?nth ] [ swapd seq2>> ?nth ] tri ; inline

: ?bi-step ( iter -- elt1/f elt2/f )
    dup ?bi-peek [ [ 1 + swap index<< ] 2dip ] [ 2nip f ] if* ; inline

<PRIVATE
: (bi-fold) ( ..a iter identity quot: ( ..a prev elt1 elt2 -- ..b next ) elt1 elt2 -- ..b result )
    rot dup dip
    [ over ?bi-step dup ] swap while 2drop nip ; inline

: (empty-bi-fold) ( iter identity quot elt1 -- result )
    2drop nip ; inline
PRIVATE>

: bi-fold ( ..a iter identity quot: ( ..a prev elt1 elt2 -- ..b next ) -- ..b result )
    pick ?bi-step [ (bi-fold) ] [ (empty-bi-fold) ] if* ; inline
