! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs classes ff.types fry fudi.logging kernel macros
       namespaces prettyprint quotations sequences vectors ;
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

: (touch-cell) ( name state -- )
    [
        at [
            dup callback>> [
                [ value>> ] dip call( value -- )
            ] [ drop ] if*
        ] when*
    ] [ drop ] if* ;

MACRO: (set-cell) ( state-symbol -- )
    [ name>> ] keep dup '[
        [ unparse [ _ swap " " glue \ (set-cell) fudi-DEBUG ] bi@ ] 2keep
        swap _ get-global [
            [ at ] 2keep (set-value)
        ] [
            f swap H{ } clone [ (set-value) ] keep _ set-global
        ] if*
    ] ;

MACRO: (tap-cell) ( state-symbol -- )
    [ name>> ] keep dup '[
        [ unparse [ _ swap " " glue \ (tap-cell) fudi-DEBUG ] bi@ ] 2keep
        swap _ get-global [
            [ at ] 2keep (set-callback)
        ] [
            f swap H{ } clone [ (set-callback) ] keep _ set-global
        ] if*
    ] ;
PRIVATE>

: local.  ( name -- ) (locals)  get-global [ at ] [ drop f ] if* . ;
: remote. ( name -- ) (remotes) get-global [ at ] [ drop f ] if* . ;

: locals.  ( -- ) (locals)  get-global . ;
: remotes. ( -- ) (remotes) get-global . ;

: touch-local  ( name -- ) (locals)  get-global (touch-cell) ;
: touch-remote ( name -- ) (remotes) get-global (touch-cell) ;

: set-local  ( name value -- ) (locals)  (set-cell) ;
: set-remote ( name value -- ) (remotes) (set-cell) ;

! Contract: Callback is not fired until next set-local.  In order to
! force immediate callback, call touch-local after publish.
GENERIC: publish ( name object -- )

M: f publish (locals) (tap-cell) ;

M: callable publish dupd curry (locals) (tap-cell) ;

! Callback is not fired until next set-remote.  In order to force
! immediate callback, call touch-remote after subscribe.
: subscribe ( name quot/f -- ) (remotes) (tap-cell) ;
