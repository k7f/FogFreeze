! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays assocs help.markup help.syntax kernel namespaces
       om.help.syntax.private parser sequences vocabs ;
IN: om.help.reference

SYNTAX: OM-REFERENCE: \ ; parse-until unclip (om-reference) ;

<PRIVATE
: ($ref-table) ( path table -- )
    swap \ $snippet swap 2array $heading [
        first2 [ \ $snippet ] dip \ $link [ swap 2array ] 2bi@ 2array
    ] map $table ;

! FIXME first invocation may take some time to complete, so present a list
! of om sources as folded subtopics, each to be unfolded on demand.
! FIXME find a way to specify order of tables and their parts, and to sort them.
: $ref-tables ( element -- )
    drop +om-vocabs+ get-global [ require ] each
    +om-reference-tables+ get-global >alist [ ($ref-table) ] assoc-each ;
PRIVATE>

OM-VOCABS:
    bpf combinatorial conversions functions functions.auxiliary graphics
    kernel kernel.private lists rhythm rhythm.dealer rhythm.meter
    rhythm.onsets rhythm.private rhythm.transformer series sets trees
    trees.private ;

ARTICLE: "om-words" "OM words"
{ $ref-tables } ;
