! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs classes classes.algebra colors help.markup
       help.stylesheet io.styles kernel namespaces quotations sequences
       ui.operations urls webbrowser words ;
IN: addenda.help.markup

: $sequence-of ( element -- )
    first dup class? [
        { "a " { $link sequence } " of " } print-element ($link) { "s" } print-element
    ] [ $link ] if ;

: $class/sequence-of ( element -- )
    first dup class? [
        dup ($instance) { " or a " { $link sequence }  " of " } print-element
        ($link) { "s" } print-element
    ] [ $link ] if ;

: $word/callable ( element -- )
    { "a " { $link word } " or a " { $link callable } " with stack effect " }
    print-element $snippet ;

<PRIVATE
: ($input-types-args) ( elements -- on-empty word exclude )
    [ third ] [ first2 ] bi ; inline

: ($input-types) ( word exclude -- types )
    [ "methods" word-prop keys ] dip
    [ [ class<= ] with any? not ] curry filter ; inline
PRIVATE>

: $input-types ( elements -- )
    ($input-types-args) ($input-types)
    [ print-element ] [
        nip [ ", " print-element ] [ ($link) ] interleave
    ] if-empty ;

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
