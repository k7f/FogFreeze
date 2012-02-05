! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays assocs combinators help.markup help.markup.private
       kernel sequences ui.operations urls webbrowser ;
IN: om.help.markup

: $vocab-intro ( children -- )
    { "The " } print-element dup first 1array $vocab-link
    { " vocabulary is an experimental port of the file " } print-element
    second 1array $snippet
    { " from the main " { $snippet "code" } " tree of OpenMusic." } print-element
    { "The text in descriptions and notes was copied verbatim from the original docstrings.  There may be little or no meaning left in it after the transfer." } $warning ;

: $optionals ( children -- )
    drop { "an " { $link object } " providing " { $snippet "&optional" } " arguments" } print-element ;

: $optional-defaults ( element -- )
    "Default values of optional arguments" $heading [ values-row ] map $table ;

: $keys ( children -- )
    drop { "an " { $link object } " providing " { $snippet "&key" } " arguments" } print-element ;

: $rest ( children -- )
    drop { "an " { $link object } " containing a variable number of arguments" } print-element ;

: $ad-hoc-monomorphic ( children -- )
    drop { "Ad-hoc definitions of monomorphic combinators will (hopefully) be replaced with generic macros or some other mechanism (e.g. " { $link call-effect } " with run-time stack-effect resolution)." } $warning ;

: $unpacking-combinator ( children -- )
    { "To be called in an " { $link POSTPONE: inline } " context.  This is a higher-order version of " } print-element $link { " suitable for unpacking quotations." } print-element ;

<PRIVATE
! CONSTANT: (clhs-body) "http://clhs.lisp.se/Body/"
CONSTANT: (clhs-body) "http://www.lispworks.com/documentation/HyperSpec/Body/"
PRIVATE>

: $clhs-link ( children -- )
    first dup (clhs-body) prepend >url [ write-link ] ($span) ;

t +primary+ \ open-url props>> set-at
