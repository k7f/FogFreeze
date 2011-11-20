! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: assocs fudi.logging kernel namespaces prettyprint sequences vectors ;
IN: fudi.state

<PRIVATE
SYMBOLS: (locals) (remotes) ;

: (copy) ( new old -- )
    0 swap pick sequence? [ copy ] [ set-nth ] if ;

: (set-at) ( new old/f key state -- )
    pick [
        [ [ (copy) ] keep ] 2dip
    ] [
        [ drop dup sequence? [ >vector ] [ 1vector ] if ] 2dip
    ] if set-at ;
PRIVATE>

: remotes. ( -- ) (remotes) get-global . ;

: update-remotes ( name object -- )
    [ unparse [ \ update-remotes fudi-DEBUG ] bi@ ] 2keep
    swap (remotes) get-global [
        [ at ] 2keep (set-at)
    ] [
        f swap H{ } clone [ (set-at) ] keep (remotes) set-global
    ] if* ;
