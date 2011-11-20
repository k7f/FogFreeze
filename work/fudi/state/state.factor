! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs classes ff.types fudi.logging kernel namespaces
       prettyprint sequences vectors ;
IN: fudi.state

<PRIVATE
SYMBOLS: (locals) (remotes) ;

TUPLE: (cell) { value vector } { callback ?callable } ;

: (data-copy) ( new old -- )
    0 swap pick sequence? [ copy ] [ set-nth ] if ;

: (data-create) ( value -- value' )
    dup sequence? [ >vector ] [ 1vector ] if ;

: (data-replace) ( value cell -- )
    [ value>> [ [ (data-copy) ] keep ] [ (data-create) ] if* ] keep
    [ callback>> [ call( value -- ) ] [ drop ] if* ] [ value<< ] 2bi ;

: (hook-replace) ( callback cell -- )
    over ?callable instance? [ callback<< ] [
        drop unparse \ (hook-replace) fudi-ERROR
    ] if ;

: (value>cell) ( value -- cell )
    (data-create) f (cell) boa ;

: (callback>cell) ( callback -- cell )
    V{ } clone swap (cell) boa ;

: (set-value) ( value cell/f key state -- )
    [ [ [ (data-replace) ] keep ] [ (value>cell) ] if* ] 2dip set-at ;

: (set-callback) ( callback cell/f key state -- )
    [ [ [ (hook-replace) ] keep ] [ (callback>cell) ] if* ] 2dip set-at ;
PRIVATE>

: remote. ( name -- ) (remotes) get-global [ at ] [ drop f ] if* . ;

: remotes. ( -- ) (remotes) get-global . ;

: touch-remote ( name -- )
    (remotes) get-global [
        at [
            dup callback>> [
                [ value>> ] dip call( value -- )
            ] [ drop ] if*
        ] when*
    ] [ drop ] if* ;

: set-remote ( name object -- )
    ! [ unparse [ \ set-remote fudi-DEBUG ] bi@ ] 2keep
    swap (remotes) get-global [
        [ at ] 2keep (set-value)
    ] [
        f swap H{ } clone [ (set-value) ] keep (remotes) set-global
    ] if* ;

! Callback is not fired until next set-remote.  In order to force
! immediate callback, call touch-remote after subscribe.
: subscribe ( name quot/f -- )
    ! [ unparse [ \ subscribe fudi-DEBUG ] bi@ ] 2keep
    swap (remotes) get-global [
        [ at ] 2keep (set-callback)
    ] [
        f swap H{ } clone [ (set-callback) ] keep (remotes) set-global
    ] if* ;
