! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays combinators  kernel math math.order om.graphics
       om.support sequences sorting vectors ;
IN: om.bpf

! ________________________________
! 01-basicproject/classes/bpf.lisp

<PRIVATE
: (new-points) ( n -- points )
    {
        { [ dup 1 < ] [ drop 0 <vector> ] }
        { [ dup 2 < ] [ drop 0 0 <om-point> 1vector ] }
        [ <vector> 0 0 100 100 [ <om-point> over push ] 2bi@ ]
    } cond ; inline
PRIVATE>

TUPLE: internal-bpf { points vector } ;

: <internal-bpf> ( n -- ibpf ) (new-points) internal-bpf boa ;

TUPLE: bpf < internal-bpf { xs maybe: array } { ys maybe: array } ;

: <bpf> ( n -- bpf ) (new-points) f f bpf boa ;

<PRIVATE
: (bpf\) ( bpf -- bpf ) f >>xs f >>ys ; inline
PRIVATE>

GENERIC: cons-bpf ( points obj -- )

M: bpf cons-bpf ( points bpf -- )
    [ [ x>> ] sort-with [ length ] keep ] [ (bpf\) points>> ] bi*
    swap >>underlying length<< ;

<PRIVATE
GENERIC# (simple-seq-ys) 2 ( xs ys dec bpf -- )
GENERIC# (simple-num-ys) 2 ( x  ys dec bpf -- )
GENERIC# (simple-xs-ys)  3 ( xs ys dec bpf -- )

M: sequence (simple-xs-ys)  (simple-seq-ys) ;
M: real     (simple-xs-ys)  (simple-num-ys) ;

! FIXME padding by extrapolation
! FIXME decimal
M: sequence (simple-seq-ys) ( xs ys dec bpf -- )
    nip [ [ <om-point> ] 2map ] dip cons-bpf ;

M: real (simple-seq-ys) ( xs y dec bpf -- )
    nip [ [ <om-point> ] curry map ] dip cons-bpf ;

M: sequence (simple-num-ys) ( x ys dec bpf -- )
    nip [ [ <om-point> ] with map ] dip cons-bpf ;
PRIVATE>

: simple-bpf-from-list ( xs ys &optionals -- bpf )
    bpf unpack2 [ 0 ] unless* swap new [ (simple-xs-ys) ] keep ;
