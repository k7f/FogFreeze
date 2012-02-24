! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.help.markup arrays assocs help.markup help.markup.private
       kernel present sequences urls words ;
IN: om.help.markup

: $vocab-intro ( children -- )
    { "The " } print-element dup first 1array $vocab-link
    { " vocabulary is an experimental port of the file " } print-element
    second "code/" prepend 1array $snippet
    { " from the main source tree of OpenMusic (downloadable from " } print-element
    "this page" "http://repmus.ircam.fr/openmusic/sources" >url [ write-link ] ($span)
    { ")." } print-element
    { "The text in descriptions and notes was copied verbatim from the original docstrings.  There may be little or no meaning left in it after the transfer." } $warning ;

: $aux-vocab-intro ( children -- )
    { "The " } print-element first dup ".auxiliary" append 1array $vocab-link
    { " vocabulary extends the " { $emphasis "official" } " " } print-element
    1array $vocab-link { " API with implementation helpers expected to fit in another context some day." } print-element ;

: $optionals ( children -- )
    drop { "an " { $link object } " providing " { $snippet "&optional" } " arguments" } print-element ;

<PRIVATE
: (&optional-row) ( seq -- seq )
    unclip \ $snippet swap present 2array swap dup first word?
    [ \ $link prefix ] when 2array ;
PRIVATE>

: $optional-defaults ( element -- )
    "Default values of optional arguments" $heading [ (&optional-row) ] map $table ;

: $keys ( children -- )
    drop { "an " { $link assoc } " providing " { $snippet "&key" } " arguments" } print-element ;

: $rest ( children -- )
    drop { "an " { $link object } " containing a variable number of arguments" } print-element ;

: $unpacking-combinator ( children -- )
    { "To be called in an " { $link POSTPONE: inline } " context.  This is a higher-order version of " } print-element $link { " suitable for unpacking quotations." } print-element ;

<PRIVATE
! CONSTANT: (clhs-body) "http://clhs.lisp.se/Body/"
CONSTANT: (clhs-body) "http://www.lispworks.com/documentation/HyperSpec/Body/"
PRIVATE>

: $clhs-link ( children -- )
    first dup (clhs-body) prepend >url [ write-link ] ($span) ;

prioritize-url-operation
