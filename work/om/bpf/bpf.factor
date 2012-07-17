! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays combinators kernel math om.graphics om.support
       sequences sorting vectors ;
IN: om.bpf

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

TUPLE: bpf < internal-bpf { xs maybe{ array } } { ys maybe{ array } } ;

: <bpf> ( n -- bpf ) (new-points) f f bpf boa ;

TUPLE: bpf-lib { bpfs vector } ;

: <bpf-lib> ( n -- bpf-lib )
    {
        { [ dup 1 < ] [ drop 0 <vector> ] }
        { [ dup 2 < ] [ drop 2 <bpf> 1vector ] }
        [ <vector> 2 <bpf> over push ]
    } cond bpf-lib boa ;

: point-pairs ( bpf -- pairs )
    points>> [ [ x>> ] [ y>> ] bi 2array ] { } map-as ;

<PRIVATE
: (bpf\) ( bpf -- bpf ) f >>xs f >>ys ; inline
PRIVATE>

GENERIC: cons-bpf ( points obj -- )

M: bpf cons-bpf ( points bpf -- )
    [ [ x>> ] sort-with [ length ] keep ] [ (bpf\) points>> ] bi*
    swap >>underlying length<< ;

<PRIVATE
GENERIC# (simple-num-ys) 2 ( dx ys dec bpf -- )
GENERIC# (simple-seq-ys) 2 ( xs ys dec bpf -- )
GENERIC# (simple-xs-ys)  3 ( xs ys dec bpf -- )

M: real (simple-seq-ys) ( xs y dec bpf -- )
    [ drop [ <om-point> ] curry map ] dip cons-bpf ;

: (simple-step) ( x dx y -- x' pt )
    [ over ] dip <om-point> [ + ] dip ; inline

M: sequence (simple-num-ys) ( dx ys dec bpf -- )
    [ drop [ 0 ] 2dip [ (simple-step) ] with map ] dip cons-bpf drop ;

: (simple-2step-x) ( x y i dx xs -- x' y )
    swapd ?nth [ nip swap rot drop ] [ swap [ + ] dip ] if* ; inline

: (simple-2step-y) ( x' y i dy ys -- x' y' )
    swapd ?nth [ 2nip ] [ + ] if* ; inline

: (simple-2step) ( x y i dx dy xs ys -- x y pt )
    [ swap [ pick [ (simple-2step-x) ] dip ] dip ] dip
    (simple-2step-y) 2dup <om-point> ; inline

: (simple-seqs) ( xs ys -- pts )
    [ 0 0 ] 2dip over [
        [ max-length ] [
            [ dup length 1 > [ 2 tail* first2 swap - ] [ last ] if ] bi@
        ] [ ] 2tri [ (simple-2step) ] 2curry 2curry
    ] dip map-integers 2nip ; inline

: (simple-seq-seq) ( xs ys -- pts )
    {
        { [ over empty? ] [ 2drop f ] }
        { [ dup empty? ] [ 2drop f ] }
        { [ 2dup [ length ] bi@ = ] [ [ <om-point> ] 2map ] }
        [ (simple-seqs) ]
    } cond ; inline

M: sequence (simple-seq-ys) ( xs ys dec bpf -- )
    [ drop (simple-seq-seq) ] dip cons-bpf ;

M: real     (simple-xs-ys)  (simple-num-ys) ;
M: sequence (simple-xs-ys)  (simple-seq-ys) ;
PRIVATE>

: simple-bpf-from-list ( xs ys &optionals -- bpf )
    bpf unpack2 [ 0 ] unless* swap new [ (simple-xs-ys) ] keep ;
