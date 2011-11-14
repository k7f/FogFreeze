! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fomus fry kernel locals math math.ranges math.vectors macros
       namespaces sequences ;
IN: fomus.demo

<PRIVATE
MACRO: (chord) ( pitches -- )
    '[ 120 fomus-set-dyn [ _ n+v ] dip fomus-add-chord ] ;

: (4-chord) ( staff base-pitch duration -- ) { 4 10 11 15 } (chord) ;
: (2-chord) ( staff base-pitch duration -- ) { 4 15 } (chord) ;

: (an-arpeggio) ( staff base-pitch duration -- )
    90 fomus-set-dyn [ { 0 4 8 } n+v ] dip fomus-add-tenor ;

:: (a-scale) ( staff base-pitch -- )
    40 fomus-set-dyn
    base-pitch [ 12 + ] [ 3 + ] bi staff 2 = [ swap ] when
    [ staff ] 2dip [a,b] { 1/2 1/4 1/4 } fomus-add-tenor ;

:: (a-figure) ( staff base-pitch start -- )
    staff fomus-set-voice
    start fomus-set-time
    staff base-pitch over 1 = [ 1/3 (an-arpeggio) ] [
        [ 1 + 1/2 (4-chord) ] [ 1/4 fomus-inc-time 1/4 (2-chord) ] 2bi
    ] if
    start 1 + fomus-set-time
    staff base-pitch (a-scale) ;

: (demo) ( -- )
    fomus-start <fomus> [
        ! settings section
        ! module `parts'
        { "piano" } fomus-set-global-layout-def
        ! module `dyns'
        t mus-set-global-dyns
        1 128 mus-set-global-dyn-range
        "ppp" "fff" mus-set-global-dynsym-range

        ! parts section
        "pf" fomus-set-part-id "piano" fomus-set-part-inst
        "pianoforte" fomus-set-part-name fomus-add-part

        ! events section
        "pf" fomus-set-part
        { { 1 58 1 }
          { 2 36 1/2 }
          { 1 60 6 }
          { 2 38 5+1/2 } } [ first3 (a-figure) ] each

        "fomus-demo" fomus-render&play
    ] with-fomus ;
PRIVATE>

MAIN: (demo)
