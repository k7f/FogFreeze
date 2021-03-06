! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays fomus fomus.elements fomus.patterns fomus.render fry kernel
       locals math math.ranges math.vectors macros namespaces sequences ;
IN: fomus.demo

<PRIVATE
MACRO: (chord) ( pitches -- )
    '[ 110 set-dyn [ _ n+v ] dip add-chord ] ;

: (4-chord) ( staff base-pitch duration -- ) { 4 10 11 15 } (chord) ;
: (2-chord) ( staff base-pitch duration -- ) { 4 15 } (chord) ;

: (an-arpeggio) ( staff base-pitch duration -- )
    90 set-dyn [ { 0 4 8 } n+v ] dip add-tenor ;

:: (a-scale) ( staff base-pitch -- )
    30 set-dyn
    base-pitch [ 12 + ] [ 3 + ] bi staff 2 = [ swap ] when
    [ staff ] 2dip [a,b] { 1/2 1/4 1/4 } add-tenor ;

:: (a-figure) ( staff base-pitch start -- )
    staff set-voice start set-time
    M[(..] M[>..]
    staff base-pitch over 1 = [ 1/3 (an-arpeggio) ] [
        [ 1 + 1/2 (4-chord) ] [ 1/4 inc-time 1/4 (2-chord) ] 2bi
    ] if
    M[..)] M[..>]
    start 1 + set-time
    staff base-pitch (a-scale) ;

: (demo) ( -- )
    fomus-start <fomus> [
        ! settings section
        ! module `parts'
        { "piano" } use-layout-def
        ! module `dyns'
        1 128 "ppp" "fff" use-dynamics

        ! parts section
        "pf" "piano" "pianoforte" use-part

        ! events section
        "pf" set-part
        { { 1 58 1 }
          { 2 36 1/2 }
          { 1 60 6 }
          { 2 38 5+1/2 } } [ first3 (a-figure) ] each

        "fomus-demo" fomus-render&play
    ] with-fomus ;
PRIVATE>

MAIN: (demo)
