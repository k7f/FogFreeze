! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays assocs help.markup help.markup.private kernel lexer
       linked-assocs math namespaces sequences sets words ;
IN: om.help.syntax

<PRIVATE

SYMBOL: +om-reference-tables+
+om-reference-tables+ get-global [
    <linked-hash> +om-reference-tables+ set-global
] unless

: (om-type-name) ( plural? om-types -- name )
    ?last [
        "OM " prepend swap [ "s" append ] when
    ] [ "OM functions" "OM function" ? ] if* ;

: (print-om-reference) ( om-types om-names -- )
    "OM reference" $heading
    { "This word implements " } print-element
    dup length 1 > [
        [ { "the " } print-element ] unless
    ] [
        rot (om-type-name) "om-words" [ write-link ] topic-span
    ] [
        { ": " } { " " } ? print-element
    ] tri
    [ { ", " } print-element ] [ $snippet ] interleave
    { "." } print-element ;

: (pick-om-names) ( om-types word table -- om-types' om-names )
    [ second eq? ] with filter [
        2 over ?nth [
            [ suffix! ] curry dip
        ] when* first
    ] map ;
PRIVATE>

: $om-word ( children -- )
    first V{ } clone swap
    +om-reference-tables+ get-global >alist values
    [ (pick-om-names) ] with map concat
    (print-om-reference) ;

<PRIVATE
: (?add-reference) ( contents word -- contents' )
    over [ first \ $om-word eq? ] find drop
    [ drop ] [ \ $om-word swap 2array suffix ] if ; inline

: (update-references) ( table -- )
    [
        second "help" over
        [ (?add-reference) ] curry change-word-prop
    ] each ;

: (om-reference) ( table path -- )
    [ >array dup (update-references) ]
    [ "code/" prepend ] bi*
    +om-reference-tables+ get-global [ append members ] change-at ;

SYMBOL: +om-vocabs+

SYNTAX: OM-VOCABS: ";" [ "om." prepend ] map-tokens +om-vocabs+ set-global ;

PRIVATE>
