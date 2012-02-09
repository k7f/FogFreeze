! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: help.markup kernel ;
IN: addenda.help.markup

: $set-combinator ( children -- )
    { "Like " } print-element $link { ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." } print-element ;
