! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors arrays assocs help.markup help.markup.private kernel
       namespaces sequences ui.operations ui.tools.inspector urls webbrowser ;
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

: $unpacking-combinator ( children -- )
    { "To be called in an " { $link POSTPONE: inline } " context.  This is a higher-order version of " } print-element $link { " suitable for unpacking quotations." } print-element ;

<PRIVATE
! CONSTANT: (clhs-body) "http://clhs.lisp.se/Body/"
CONSTANT: (clhs-body) "http://www.lispworks.com/documentation/HyperSpec/Body/"
PRIVATE>

: $clhs-link ( children -- )
    first dup (clhs-body) prepend >url [ write-link ] ($span) ;

<PRIVATE
! FIXME don't remove the inspector form url's popup -- push it down, instead
: (prioritize-url-operation) ( -- )
    +primary+ +secondary+ [ t swap \ open-url props>> set-at ] bi@
    operations get values [ command>> \ inspector eq? ] find nip
    [ [ url? not ] swap predicate<< ] when* ;
PRIVATE>

(prioritize-url-operation)
