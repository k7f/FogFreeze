! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fomus kernel math math.ranges math.vectors namespaces
       sequences ;
IN: fomus.demo

<PRIVATE
: (a-chord) ( staff base-pitch -- )
    4. fomus-set-dyn { 4 11 12 15 } n+v .25 fomus-add-chord ;

: (an-arpeggio) ( staff base-pitch -- )
    4. fomus-set-dyn { 0 4 8 } n+v .3 fomus-add-tenor ;

: (a-scale) ( staff base-pitch -- )
    1. fomus-set-dyn [ 12 + ] [ 3 + ] bi
    pick 2 = [ swap ] when
    [a,b] { .5 .25 .25 } fomus-add-tenor ;

: (a-figure) ( staff base-pitch start -- )
    [ dup fomus-set-voice ] 2dip [
        fomus-set-time over 1 = [ (an-arpeggio) ] [
            2dup (a-chord) .5 fomus-inc-time (a-chord)
        ] if
    ] [ 1. + fomus-set-time (a-scale) ] 3bi ;

: (demo) ( -- )
    fomus-start <fomus> [
        ! settings section
        ! module `parts'
        { "piano" } fomus-set-global-layout-def

        ! parts section
        "pf" fomus-set-part-id "piano" fomus-set-part-inst
        "pianoforte" fomus-set-part-name fomus-add-part

        ! events section
        "pf" fomus-set-part
        { { 1 58 1 }
          { 2 36 .5 }
          { 1 60 6. }
          { 2 38 5.5 } } [ first3 (a-figure) ] each

        "fomus-demo" fomus-render&play
    ] with-fomus ;
PRIVATE>

MAIN: (demo)
