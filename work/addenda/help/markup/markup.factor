! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: assocs colors help.markup help.stylesheet io.styles kernel namespaces ;
IN: addenda.help.markup

: $moving-target ( element -- )
    [
        warning-style get dup
        T{ rgba f 1 .3 0 1 } border-color rot set-at dup
        T{ rgba f 0.9 1 .85 1 } page-color rot set-at
        [ last-element off "Moving target" $heading print-element ] with-nesting
    ] ($heading) ;

: $set-combinator ( children -- )
    { "Like " } print-element $link { ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." } print-element ;
