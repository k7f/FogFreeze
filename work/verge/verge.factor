! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators continuations debugger io kernel
       math namespaces prettyprint sequences strains ;
IN: verge

! the main loop skeleton is: [ [ goal ] (test-goal) ] [ step (after-step) ] until

<PRIVATE
SYMBOL: trace?
PRIVATE>

: set-trace ( ? -- ) trace? set ;

TUPLE: verge-state strains slipstack hitstack current-value ;

<PRIVATE
: (test-goal) ( hitstack value goal: ( hitstack value -- hitstack ? ) -- hitstack value ? )
    keep swap ; inline

: (check-strains) ( strains hitstack value -- strains hitstack value strain/f )
    pick [ check ] map-find drop ; inline

: (backtrack) ( slipstack hitstack strain -- slipstack' hitstack' )
    trace? get [
        "* backtrack hits: " write over .
        "  slipstack snap: " write pick .
    ] when
    over length 1 > [ drop ] [ throw ] if
    [ 1 cut* drop ] bi@ ; inline

: (sidestep) ( slipstack -- slipstack' value/f )
    trace? get [
        "@ sidestep slips: " write dup .
    ] when
    dup last [
        call( -- value slip'/f )
        pick push
    ] [ f ] if* ; inline

: (try-fallback) ( slipstack hitstack strain -- slipstack' hitstack' strain value/f )
    [ (sidestep) ] 2dip rot
    [ [ (backtrack) ] keep f ] unless* ; inline

: (fallback)
    ( slipstack strains hitstack value strain -- slipstack strains hitstack' value' )
    swap [ swap ] 3dip
    [ drop (try-fallback) dup not ] loop
    [ swap ] 3dip nip ; inline

: (push-slip) ( slipstack strains hitstack value slip -- slipstack' strains hitstack value )
    -rot [ pick push ] 2dip ; inline

: (push-hit) ( hitstack value -- hitstack' )
    [ trace? get [ drop . ] [ 2drop ] if ]
    [ over push ] 2bi ; inline

: (after-step) ( slipstack strains hitstack value slip -- slipstack' strains hitstack' value' )
    (push-slip)
    [ (check-strains) dup ] [ (fallback) ] while drop
    [ (push-hit) ] keep ; inline

! FIXME benchmark the performance costs of using packed and unpacked state
: (initialize) ( state goal step -- slipstack strains hitstack start goal step )
    [
        { [ slipstack>> ] [ strains>> ] [ hitstack>> ] [ current-value>> ] } cleave
    ] 2dip ; inline

: (wrap) ( goal: ( hitstack value -- hitstack ? )
           step: ( hitstack value -- hitstack value' slip: ( -- value'' slip' ) )
           --
           goal': ( hitstack value -- hitstack value ? )
           step': ( hitstack value -- hitstack' value' ) )
    [ (test-goal) ] [ (after-step) ]
    [ curry ] [ compose ] bi-curry* bi* ; inline

: (run) ( slipstack strains hitstack start
          goal: ( ..value -- ..value ? )
          step: ( ..hitstack value -- ..hitstack' value' )
          -- hitstack' ? )
    [ until drop t ] [
        "Warning: " write error.
        3drop f
    ] recover [ 2drop ] 2dip ; inline

: (1lifo) ( obj -- lifo )
    V{ } clone [ push ] keep ; inline

: (make-hitstack) ( start -- hitstack ) (1lifo) ; inline
: (make-slipstack) ( slip -- slipstack ) (1lifo) ; inline
PRIVATE>

: <verge-state> ( start slip: ( -- value slip' ) strains -- state )
    swap (make-slipstack)
    swapd swap [ (make-hitstack) ] keep
    \ verge-state boa ;

: (verge) ( state
            goal: ( hitstack value -- hitstack ? )
            step: ( hitstack value -- hitstack value' slip: ( -- value'' slip' ) )
            -- hitlist ? )
    (initialize) (wrap) (run) ; inline

: verge ( start
          first-slip-maker: ( value -- value slip: ( -- value' slip ) )
          next-slip-maker: ( value -- value slip: ( -- value' slip ) )
          strains
          goal: ( hitstack value -- hitstack ? )
          step: ( hitstack value -- hitstack value' )
          -- hitlist ? )
    [ swap [ [ call ] dip <verge-state> ] dip ] 2dip rot compose (verge) ; inline
