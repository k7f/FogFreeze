! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: combinators help.markup kernel ;
IN: addenda.help.markup

: $ad-hoc-monomorphic ( children -- )
    drop { "Ad-hoc definitions of monomorphic combinators will (hopefully) be replaced with generic macros or some other mechanism (e.g. " { $link call-effect } " with run-time stack-effect resolution)." } $warning ;

: $set-combinator ( children -- )
    { "Like " } print-element $link { ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." } print-element ;
