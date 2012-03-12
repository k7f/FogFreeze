! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays assocs help.markup help.markup.private help.syntax kernel math
       namespaces om.help.syntax om.kernel om.rhythm om.rhythm.meter
       om.rhythm.onsets om.rhythm.private om.trees sequences ;
IN: om.help.reference

<PRIVATE
: ($ref-table) ( path table -- )
    swap \ $snippet swap 2array $heading [
        first2 [ \ $snippet ] dip \ $link [ swap 2array ] 2bi@ 2array
    ] map $table ;

: $ref-tables ( element -- )
    drop om-reference-tables get-global >alist [ ($ref-table) ] assoc-each ;
PRIVATE>

OM-REFERENCE:
"projects/01-basicproject/functions/kernel.lisp"
{ "om+" om+ }
{ "om*" om* }
{ "om-" om- }
{ "om/" om/ }
{ "om^" om^ }
{ "om-e" om-e }
{ "om-log" om-log }
{ "om-round" om-round }
{ "om//" om// }
;

OM-REFERENCE:
"projects/02-musicproject/functions/trees.lisp"
{ "mktree" mktree }
{ "reducetree" reducetree }
{ "pulsemaker" pulsemaker }
{ "tietree" tietree }
{ "build-one-measure" <measure> }
{ "simple->tree" zip-measures }
{ "make-proportional-cell" ratios>integers }
{ "x-dx-pause-ok" onsets>durations }
{ "dx-x-pause-ok" durations>onsets }
{ "build-local-times" global>local }
{ "get-onsettime-before" last-before }
{ "filter-events-between" trim-between }
{ "better-predefined-subdiv?" (?split-heuristically) }
{ "fuse-pauses-and-tied-notes-between-beats" fuse-rests-and-ties }
{ "grouper1" fuse-notes-deep }
{ "grouper2" fuse-rests-deep }
{ "grouper3" fuse-rests-deep }
;

OM-REFERENCE:
"projects/02-musicproject/container/tree2container.lisp"
{ "symbol->ratio" >meter }
{ "resolve-?" >rhythm-element }
;

ARTICLE: "om-functions" "OM functions"
{ $ref-tables } ;
