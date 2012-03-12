! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays assocs help.markup help.markup.private kernel linked-assocs
       math namespaces parser sequences words ;
IN: om.help.syntax

SYMBOL: om-reference-tables
<linked-hash> om-reference-tables set-global

<PRIVATE
: ($om-function) ( children -- )
    "OM reference" $heading
    { "This word implements " } print-element
    dup length 1 > [
        [ { "the " } print-element ] unless
    ] [
        "OM functions" "OM function" ?
        "om-functions" [ write-link ] topic-span
    ] [
        { ": " } { " " } ? print-element
    ] tri
    [ { ", " } print-element ] [ $snippet ] interleave
    { "." } print-element ;
PRIVATE>

! FIXME improve...
: $om-function ( children -- )
    first om-reference-tables get-global >alist values [
        [ second eq? ] with filter [ first ] map
    ] with map concat ($om-function) ;

<PRIVATE
: (?add-reference) ( contents word -- contents' )
    over [ first \ $om-function eq? ] find drop
    [ drop ] [ \ $om-function swap 2array suffix ] if ;

: (om-reference) ( table path -- )
    [
        dup [
            second "help" over
            [ (?add-reference) ] curry change-word-prop
        ] each >array
    ] [ "code/" prepend ] bi*
    om-reference-tables get-global set-at ;
PRIVATE>

SYNTAX: OM-REFERENCE: \ ; parse-until unclip (om-reference) ;
