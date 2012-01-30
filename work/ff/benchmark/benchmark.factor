! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays ff.benchmark.syntax kernel math math.functions prettyprint
       sequences tools.time ;
IN: ff.benchmark

: compare-unary ( quot1: ( obj -- ) quot2: ( obj -- ) obj -- runtime1 runtime2 )
     [ pick benchmark 2nip ]
     [ over benchmark 2nip ] 3bi ; inline

: compare-unary* ( quot1: ( obj -- ) quot2: ( obj -- ) obj -- runtime1 runtime2 )
     [ pick benchmark( obj -- ) 2nip ]
     [ over benchmark( obj -- ) 2nip ] 3bi ; inline

<PRIVATE
: (powers) ( base from to -- array )
    [ [ ^ ] 2keep ] dip swap - 1 +
    [ * dup ] with replicate nip ; inline
PRIVATE>

: power-compare-unary ( quot1: ( seq -- ) quot2: ( seq -- ) base from to -- results )
    (powers) [
        -rot pick iota compare-unary* [ /f ] keep 3array
    ] with with map ; inline

: power-lower-bounds ( results expo coef -- results' )
    [ pick first rot ^ * swap [ second ] [ third ] bi 3array ] 2curry map ;

: power-lower-bounds?* ( results expo coef -- checks )
    power-lower-bounds [ [ first ] [ second ] bi < ] map ;

: power-compare-unary?* ( quot1: ( seq -- ) quot2: ( seq -- ) base from to expo coef -- checks )
    [ power-compare-unary ] 2dip power-lower-bounds?* ; inline
