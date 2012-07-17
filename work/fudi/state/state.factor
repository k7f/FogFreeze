! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors assocs classes fry fudi.logging kernel macros namespaces
       prettyprint quotations sequences vectors ;
IN: fudi.state

<PRIVATE
SYMBOLS: (locals) (remotes) ;

TUPLE: (cell) { value vector } { callback maybe{ callable } } ;

: (touch) ( cell -- )
    dup callback>> [
        [ value>> ] dip call( value -- )
    ] [ drop ] if* ;

: (touch-value) ( value cell -- )
    callback>> [ call( value -- ) ] [ drop ] if* ;

: (data-paste) ( new old -- )
    0 swap pick [
        dup sequence? [
            length [ [ copy ] keep ] dip swap
        ] [
            drop [ set-nth 1 ] keep
        ] if set-length
    ] [ set-length drop ] if* ;

: (data-create) ( value -- value' )
    dup sequence? [ >vector ] [ 1vector ] if ;

: (data-replace) ( value cell -- )
    [ value>> [ [ (data-paste) ] keep ] [ (data-create) ] if* ] keep
    [ (touch-value) ] [ value<< ] 2bi ;

: (data-push-unsafe) ( value cell -- )
    [ value>> [ push ] keep ] keep
    [ (touch-value) ] [ value<< ] 2bi ;

: (data-push) ( value cell -- )
    [ value>> [ [ push ] keep ] [ 1vector ] if* ] keep
    [ (touch-value) ] [ value<< ] 2bi ;

: (hook-replace) ( callback cell -- )
    over maybe{ callable } instance? [ callback<< ] [
        drop unparse \ (hook-replace) fudi-ERROR
    ] if ;

: (value>cell) ( value -- cell )
    (data-create) f (cell) boa ;

: (callback>cell) ( callback -- cell )
    V{ } clone swap (cell) boa ;

: (get-value) ( key state -- value/f )
    [ at [ value>> ] [ f ] if* ] [ drop f ] if* ;

: (set-value) ( value cell/f key state -- )
    [ [ [ (data-replace) ] keep t ] [ (value>cell) f ] if* ] 2dip rot
    [ 3drop ] [ set-at ] if ;

: (push-value) ( value cell -- )
    [ (data-push) ] [ drop "missing cell" \ (push-value) fudi-ERROR ] if* ;

: (2push-value) ( first second cell -- )
    [ rot over (data-push) (data-push-unsafe) ] [
        2drop "missing cell" \ (2push-value) fudi-ERROR
    ] if* ;

: (set-callback) ( callback cell/f key state -- )
    [ [ [ (hook-replace) ] keep t ] [ (callback>cell) f ] if* ] 2dip rot
    [ 3drop ] [ set-at ] if ;

: (touch-by-key) ( name state -- )
    [ at [ (touch) ] when* ] [ drop ] if* ;

MACRO: (set-cell) ( state-symbol -- )
    [ name>> ] keep dup '[
        [ unparse [ _ swap " " glue \ (set-cell) fudi-DEBUG ] bi@ ] 2keep
        swap _ get-global [
            [ at ] 2keep (set-value)
        ] [
            f swap H{ } clone [ (set-value) ] keep _ set-global
        ] if*
    ] ;

MACRO: (grow-cell) ( state-symbol -- )
    [ name>> ] keep over '[
        [ unparse [ _ swap " " glue \ (grow-cell) fudi-DEBUG ] bi@ ] 2keep
        swap _ get-global [
            at (push-value)
        ] [
            2drop "missing state " _ append \ (grow-cell) fudi-ERROR
        ] if*
    ] ;

MACRO: (2grow-cell) ( state-symbol -- )
    [ name>> ] keep over '[
        [ [ unparse ] bi@ " " glue [ _ swap " " glue \ (2grow-cell) fudi-DEBUG ] bi@ ] 3keep
        rot _ get-global [
            at (2push-value)
        ] [
            3drop "missing state " _ append \ (2grow-cell) fudi-ERROR
        ] if*
    ] ;

MACRO: (clone-cell) ( state-symbol -- )
    [ name>> ] keep dup '[
        [ [ _ swap " " glue \ (clone-cell) fudi-DEBUG ] bi@ ] 2keep
        _ get-global [
            swap over (get-value) [
                clone -rot [ at ] 2keep [ (set-value) ] keep _ set-global
            ] [ 2drop ] if*
        ] [ 2drop ] if*
    ] ;

MACRO: (tap-cell) ( state-symbol -- )
    [ name>> ] keep dup '[
        [ _ over " " glue \ (tap-cell) fudi-DEBUG ] dip
        swap _ get-global [
            [ at ] 2keep (set-callback)
        ] [
            f swap H{ } clone [ (set-callback) ] keep _ set-global
        ] if*
    ] ;
PRIVATE>

: get-local  ( name -- cell ) (locals)  get-global [ at ] [ drop f ] if* ;
: get-remote ( name -- cell ) (remotes) get-global [ at ] [ drop f ] if* ;

: touch-local  ( name -- ) (locals)  get-global (touch-by-key) ;
: touch-remote ( name -- ) (remotes) get-global (touch-by-key) ;

: set-local  ( name value -- ) (locals)  (set-cell) ;
: set-remote ( name value -- ) (remotes) (set-cell) ;

: push-local  ( name value -- ) (locals)  (grow-cell) ;
: push-remote ( name value -- ) (remotes) (grow-cell) ;

: push-local-event ( name time-stamp value -- ) (locals) (2grow-cell) ;
: push-remote-event ( name time-stamp value -- ) (remotes) (2grow-cell) ;

: clone-local  ( to from -- ) (locals)  (clone-cell) ;
: clone-remote ( to from -- ) (remotes) (clone-cell) ;

: local.  ( name -- ) get-local . ;
: remote. ( name -- ) get-remote . ;

: locals.  ( -- ) (locals)  get-global . ;
: remotes. ( -- ) (remotes) get-global . ;

! Publishing: a change in ff triggers a quotation.  When publishing on a fudin,
! the quotation feeds Pd.  The fudin's method is defined in peers and it is
! invoked by the parser.
! Contract: Callback is not fired until next set-local.  In order to
! force immediate callback, call touch-local after publish.
GENERIC: publish ( name object -- )

M: f publish (locals) (tap-cell) ;

M: callable publish dupd curry (locals) (tap-cell) ;

! Subscription: a change in Pd triggers a quotation.
! Callback is not fired until next set-remote.  In order to force
! immediate callback, call touch-remote after subscribe.
: subscribe ( name quot/f -- ) (remotes) (tap-cell) ;
