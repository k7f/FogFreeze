! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays combinators help.markup kernel sequences prettyprint ;
IN: om.help.markup

: $vocab-intro ( children -- )
    { "The " } print-element dup first 1array $vocab-link
    { " vocabulary is an experimental port of the file " } print-element
    second 1array $snippet
    { " from the main " { $snippet "code" } " tree of OpenMusic." } print-element
    { "The text in descriptions and notes was copied verbatim from the original docstrings.  There may be little or no meaning left in it after the transfer." } $warning ;

: $optionals ( children -- )
    drop { "an " { $link object } " providing optional arguments" } print-element ;

: $optional-defaults ( element -- )
    "Default values of optional arguments" $heading [ values-row ] map $table ;

: $rest ( children -- )
    drop { "an " { $link object } " containing a variable number of arguments" } print-element ;

: $ad-hoc-monomorphic ( children -- )
    drop { "Ad-hoc definitions of monomorphic combinators will (hopefully) be replaced with generic macros or some other mechanism (e.g. " { $link call-effect } " with run-time stack-effect resolution)." } $warning ;

