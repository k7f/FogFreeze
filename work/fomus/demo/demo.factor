! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fomus io.pathnames kernel math math.ranges math.vectors
       namespaces sequences ;
IN: fomus.demo

<PRIVATE
: (a-chord) ( staff base-pitch -- )
    1. fomus-set-dyn .5 fomus-set-dur { 0 4 7 } n+v fomus-add-chord ;

: (a-scale) ( staff base-pitch -- )
    2. fomus-set-dyn [ 12 + ] [ 3 + ] bi [a,b] .25 fomus-add-tenor ;

: (a-figure) ( staff base-pitch start -- )
    [ dup fomus-set-voice ] 2dip
    [ fomus-set-time (a-chord) ]
    [ 1. + fomus-set-time (a-scale) ] 3bi ;

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
          { 1 60 5. }
          { 2 38 4.5 } } [ first3 (a-figure) ] each

        current-directory get "/fomus-demo." append
        [ "fms" append fomus-do-save ]
        [ "xml" append fomus-run-file ]
        [ "ly" append fomus-run-file ] tri
    ] with-fomus ;
PRIVATE>

MAIN: (demo)
