! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: classes ff.errors kernel math om.support sequences ;
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
