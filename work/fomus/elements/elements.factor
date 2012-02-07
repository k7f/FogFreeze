! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.errors arrays classes fomus.lli fomus.syntax kernel math
       sequences strings ;
IN: fomus.elements

<PRIVATE
: (simple-number?) ( obj -- ? ) dup fixnum? [ drop t ] [ float? ] if ;

: (simple-number!) ( obj -- obj )
    dup (simple-number?) [ class-of invalid-input ] unless ;

: (fixnum!) ( obj -- obj ) dup fixnum? [ class-of invalid-input ] unless ;
: (number!) ( obj -- obj ) dup number? [ class-of invalid-input ] unless ;
: (string!) ( obj -- obj ) dup string? [ class-of invalid-input ] unless ;

: (strings!) ( seq -- seq )
    dup [ string? [ class-of invalid-input ] unless ] each ;

: (use-dyns) ( flag -- )
    dup string? [ "yes" "no" ? ] unless fomus-set-global-dyns ;

! range: [ bottom..top ) as of 0.1.18-alpha
: (use-dyn-range) ( bottom top -- )
    [ (simple-number!) ] bi@ 2array fomus-set-global-dyn-range ;

: (use-dynsym-range) ( bottom top -- )
    [ (string!) ] bi@ 2array fomus-set-global-dynsym-range ;
PRIVATE>

: use-layout-def ( layout-def -- )
    (strings!) fomus-set-global-layout-def ;

: use-part ( id inst name -- )
    [ (string!) ] tri@
    [ fomus-set-part-id ] [ fomus-set-part-inst ] [ fomus-set-part-name ] tri*
    fomus-add-part ;

: use-dynamics ( bottom top softest loudest -- )
    "yes" (use-dyns) [ (use-dyn-range) ] [ (use-dynsym-range) ] 2bi* ;

: set-part ( id -- )
    (string!) fomus-set-part ;

: set-voice ( voice -- )
    (fixnum!) fomus-set-voice ;

: set-time ( time -- )
    (number!) fomus-set-time ;

: inc-time ( amount -- )
    (number!) fomus-inc-time ;

: set-dyn ( dyn -- )
    (simple-number!) fomus-set-dyn ;

FOMUS-MARKS:
    . - > /. !
    (.. .(. ..)
    ((.. .((. ..)).
    <.. .<. ..<
    >.. .>. ..>
    ped.. .ped. ..ped
    ~ gliss< gliss>
    arp arp^ arp_
    ferm ferm-long ferm-short ferm-verylong
    arco pizz +
    vib moltovib
    damp etouf
    downbow upbow
    break< break> ;
