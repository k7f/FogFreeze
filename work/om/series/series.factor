! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays classes ff.errors kernel layouts math math.order math.ranges
       om.support sequences ;
IN: om.series

! _____________________________________
! 01-basicproject/functions/series.lisp

GENERIC: x->dx ( seq -- seq' )

M: sequence x->dx ( seq -- seq' )
    [ rest-slice ] keep [ - ] over 2map-as ;

GENERIC: dx->x ( start seq -- seq' )

M: sequence dx->x ( start seq -- seq' )
    over number?
    [ swap [ + ] accumulate-all ]
    [ drop class-of invalid-input ] if ;

<PRIVATE
: (arithm-ser-range) ( begin end step nummax -- range )
    [ [ over - ] dip [ /i 1 + ] keep ] dip
    swap [ min 0 max ] dip range boa ; inline
PRIVATE>

! &optionals: (nummax MOST-POSITIVE-FIXNUM)
: arithm-ser ( begin end step &optionals -- seq )
    &optional-unpack1 [ most-positive-fixnum ] unless*
    (arithm-ser-range) >array ;
