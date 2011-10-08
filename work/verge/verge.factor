! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators continuations debugger io kernel
       math namespaces prettyprint sequences strains strings
       vectors ;
IN: verge

<PRIVATE
SYMBOL: trace?
PRIVATE>

: set-trace ( level/? -- ) trace? set ;
: get-trace ( -- level/? ) trace? get ;
: should-trace? ( min-level -- ? )
    trace? get dup fixnum? [ <= ] [ 2drop f ] if ;

<PRIVATE
TUPLE: (invalid-input-string) { message string read-only } ;
M: (invalid-input-string) error. "Invalid input: " write message>> . ;

TUPLE: (invalid-input-strain) { error strain read-only } ;
M: (invalid-input-strain) error. "Invalid input: " write error>> error. ;
PRIVATE>

: invalid-input ( string/strain -- * )
    dup string?
    [ \ (invalid-input-string) boa ]
    [ \ (invalid-input-strain) boa ] if throw ;

TUPLE: verge-state strains slipstack hitstack current-value ;

<PRIVATE
: (test-goal) ( hitstack value goal: ( hitstack value -- hitstack ? ) -- hitstack value ? )
    keep swap ; inline

: (check-strains) ( strains hitstack value -- strains hitstack value strain/f )
    pick [ check ] map-find drop
    dup [ 1 should-trace? [ "!!! failure: " write dup . ] when ] when ; inline

! FIXME LPP invariant does not hold here
: (check-strains-initial) ( strains hitstack value -- strains hitstack value strain/f )
    (check-strains) ; inline

: (push-hit) ( value hitstack -- )
    [
        get-trace [
            "hit " write 2 should-trace? [ swap pprint " -> " write . ] [ drop . ] if
        ] [ 2drop ] if
    ] [
        2drop  ! FIXME update strain-state
    ] [ push ] 2tri ; inline

: (drop-hit) ( hitstack -- )
    [ get-trace [ "drop " write last . ] [ drop ] if ] [
        drop  ! FIXME update strain-state
    ] [ pop* ] tri ; inline

: (push-slip) ( slip slipstack -- )
    [
        1 should-trace? [
            "push slip " write 3 should-trace? [ swap pprint " -> " write . ] [ drop . ] if
        ] [ 2drop ] if
    ] [ push ] 2bi ; inline

: (pop-slip) ( slipstack -- slip )
    pop
    1 should-trace? [
        "pop slip " write dup .
    ] when ; inline

: (backtrack) ( slipstack hitstack strain -- slipstack' hitstack' )
    1 should-trace? [
        "* backtrack hits: " write over .
        ". slipstack snap: " write pick .
    ] when
    ! FIXME report exhaustion not a credit runout
    pick length 1 > [ drop ] [ throw ] if
    dup (drop-hit) ; inline

: (sidestep) ( slipstack -- slipstack' value/f )
    1 should-trace? [
        "@ sidestep slips: " write dup .
    ] when
    dup empty? [ f ] [
        dup (pop-slip) [
            call( -- value slip'/f )
            pick (push-slip)
        ] [ f ] if*
    ] if ; inline

: (try-fallback) ( slipstack hitstack strain -- slipstack' hitstack' strain value/f )
    [ (sidestep) ] 2dip rot
    [ [ (backtrack) ] keep f ] unless* ; inline

: (fallback)
    ( slipstack strains hitstack value strain -- slipstack strains hitstack' value' )
    swap [ swap ] 3dip
    [ drop (try-fallback) dup not ] loop
    [ swap ] 3dip nip ; inline

: (after-step) ( slipstack strains hitstack value slip -- slipstack' strains hitstack' value' )
    [ pick ] 2dip rot (push-slip)
    [ (check-strains) dup ] [ (fallback) ] while drop
    [ swap (push-hit) ] 2keep ; inline

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

: (>lifo) ( seq -- lifo )
    dup sequence? [
        [ "empty sequence" invalid-input ] [ >vector ] if-empty
    ] [ "not a sequence" invalid-input ] if ; inline

: (1lifo) ( obj -- lifo )
    V{ } clone [ push ] keep ; inline

: (make-hitstack) ( start -- hitstack ) (>lifo) ; inline
: (make-slipstack) ( slip -- slipstack ) (1lifo) ; inline
PRIVATE>

: <verge-state> ( start slip: ( -- value slip' ) strains -- state )
    swapd swap (make-hitstack)
    [ unclip-last (check-strains-initial) [ invalid-input ] when* 2drop ] keep
    [ swap (make-slipstack) ] dip
    dup last \ verge-state boa ;

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
