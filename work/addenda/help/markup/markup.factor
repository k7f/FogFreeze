! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs colors help.markup help.stylesheet io.styles kernel
       namespaces sequences ui.operations ui.tools.inspector urls webbrowser ;
IN: addenda.help.markup

: $moving-target ( element -- )
    [
        warning-style get clone
        dup T{ rgba f 1 .3 0 1 } border-color rot set-at
        dup T{ rgba f 0.9 1 .85 1 } page-color rot set-at
        [ last-element off "Moving target" $heading print-element ] with-nesting
    ] ($heading) ;

: $set-combinator ( children -- )
    { "Like " } print-element $link { ", but equality test may be arbitrary, instead of the hard-coded " { $link = } " operator." } print-element ;

: prioritize-url-operation ( -- )
    +primary+ +secondary+ [ t swap \ open-url props>> set-at ] bi@
    ! reinsert the open-url operation, so that it overrides inspector as the top +primary+
    { open-url [ url? ] } dup operations get rename-at ;

prioritize-url-operation
