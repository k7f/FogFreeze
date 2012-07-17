! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel locals sequences ui.commands ui.gestures ui.tools.listener ;
IN: ff.commands

:: add-listener-command ( word gesture -- )
    word H{ { +nullary+ t } { +listener+ t } } define-command
    "ff" listener-gadget get-command-at [
        dup commands>> dup [ second word = ] find [
            swap [ { gesture word } ] 2dip set-nth drop
        ] [
            drop { gesture word } suffix swap commands<<
        ] if listener-gadget update-gestures
    ] [
        listener-gadget "ff" f { { gesture word } } define-command-map
    ] if* ;
