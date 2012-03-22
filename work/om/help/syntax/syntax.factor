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
    first +om-reference-tables+ get-global >alist values [
        [ second eq? ] with filter [ first ] map
    ] with map concat ($om-function) ;

<PRIVATE
: (?add-reference) ( contents word -- contents' )
    over [ first \ $om-function eq? ] find drop
    [ drop ] [ \ $om-function swap 2array suffix ] if ; inline

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
