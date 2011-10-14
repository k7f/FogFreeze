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

TUPLE: (bad-strain) { error strain read-only } { message string read-only } ;

: (bad-strain) ( strain string -- * ) \ (bad-strain) boa throw ;

M: (bad-strain) error.
    "Bad strain (" over message>> "): " [ write ] tri@ error>> . ;
PRIVATE>

: invalid-input ( string/strain -- * )
    dup string?
    [ \ (invalid-input-string) boa ]
    [ \ (invalid-input-strain) boa ] if throw ;

TUPLE: verge-state strains stateful-strains slipstack hitstack current-value ;

<PRIVATE
: (test-goal) ( hitstack value goal: ( hitstack value -- hitstack ? ) -- hitstack value ? )
    keep swap ; inline

: (check-strains) ( strains hitstack value -- strain/f )
    rot [ check ] map-find drop [ 2drop ] dip
    dup [ 1 should-trace? [ "!!! failure: " write dup . ] when ] when ; inline

: (push-vstrains) ( hitstack value vstrains -- )
    [
        dup push-quotation>> [
            [ 2dup ] 2dip call( hitstack value strain -- )
        ] [ drop ] if*
    ] each 2drop ; inline

: (drop-vstrains) ( vstrains -- )
    [ dup drop-quotation>> [ call( strain -- ) ] [ drop ] if* ] each ; inline

! FIXME LPP invariant does not hold here
: (check-strains-initial) ( strains hitstack value -- strain/f )
    over empty? [ 3drop f ] [ (check-strains) ] if ; inline

: (push-hit) ( vstrains value hitstack -- )
    [
        get-trace [
            "hit " write 2 should-trace? [ swap pprint " -> " write . ] [ drop . ] if
        ] [ 2drop ] if
    ] [
        swap rot (push-vstrains)
    ] [ push ] 2tri ; inline

: (drop-hit) ( vstrains hitstack -- )
    [ get-trace [ "drop " write last . ] [ drop ] if ] [
        drop (drop-vstrains)
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

: (backtrack) ( vstrains slipstack hitstack strain -- vstrains slipstack' hitstack' )
    1 should-trace? [
        "* backtrack hits: " write over .
        ". slipstack snap: " write pick .
    ] when
    ! FIXME report exhaustion not a credit runout
    pick length 1 > [ drop ] [ throw ] if
    pick over (drop-hit) ; inline

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

: (try-fallback) ( vstrains slipstack hitstack strain -- vstrains slipstack' hitstack' strain value/f )
    [ (sidestep) ] 2dip rot
    [ [ (backtrack) ] keep f ] unless* ; inline

: (fallback)
    ( vstrains slipstack hitstack value strain -- vstrains slipstack hitstack' value' )
    swap [ drop (try-fallback) dup not ] loop nip ; inline

: (after-step)
    ( vstrains strains slipstack hitstack value slip -- vstrains strains slipstack' hitstack' value' )
    [ over ] 2dip rot (push-slip) [
        [ swap ] 2dip
        3dup (check-strains)
        [ swap ] 3dip dup
    ] [
        [ swapd ] 3dip (fallback) [ swap ] 3dip
    ] while drop
    [ pick ] 2dip [ swap (push-hit) ] 2keep ; inline

! FIXME benchmark the performance costs of using packed and unpacked state
: (initialize) ( state goal step -- vstrains strains slipstack hitstack start goal step )
    [ { [ stateful-strains>> ]
        [ strains>> ]
        [ slipstack>> ]
        [ hitstack>> ]
        [ current-value>> ] } cleave ] 2dip ; inline

: (wrap) ( goal: ( hitstack value -- hitstack ? )
           step: ( hitstack value -- hitstack value' slip: ( -- value'' slip' ) )
           --
           goal': ( hitstack value -- hitstack value ? )
           step': ( hitstack value -- hitstack' value' ) )
    [ (test-goal) ] [ (after-step) ]
    [ curry ] [ compose ] bi-curry* bi* ; inline

: (run) ( vstrains strains slipstack hitstack start
          goal: ( ..value -- ..value ? )
          step: ( ..hitstack value -- ..hitstack' value' )
          -- hitstack' ? )
    [ until drop t ] [
        "Warning: " write error.
        3drop f
    ] recover [ 3drop ] 2dip ; inline

: (>lifo) ( seq -- lifo )
    dup sequence? [
        [ "empty sequence" invalid-input ] [ >vector ] if-empty
    ] [ "not a sequence" invalid-input ] if ; inline

: (1lifo) ( obj -- lifo )
    V{ } clone [ push ] keep ; inline

: (make-hitstack) ( start -- hitstack ) (>lifo) ; inline
: (make-slipstack) ( slip -- slipstack ) (1lifo) ; inline

: (make-stateful-strains) ( strains -- vstrains )
    [
        dup [ push-quotation>> ] [ drop-quotation>> ] bi
        2dup and [ 2nip nip ] [
            over or [
                [ "drop" ] [ "push" ] if "missing " " quotation" surround (bad-strain)
            ] [ 2drop ] if f
        ] if*
    ] filter ; inline

: ((fill-stateful-strains)) ( ndx vstrains hitstack -- )
    rot 1 + head-slice unclip-last-slice
    rot (push-vstrains) ; inline

: (fill-stateful-strains) ( hitstack vstrains -- )
    over [ length iota ] 2dip
    [ ((fill-stateful-strains)) ] 2curry each ; inline

: (do-initial-checks) ( ndx vstrains strains hitstack -- )
    [ rot ] dip swap 1 + head-slice unclip-last-slice [
        (check-strains-initial) [ invalid-input ] when*
    ] 2keep rot (push-vstrains) ; inline

: (build-stacks) ( slip strains start -- slipstack vstrains hitstack )
    [ (make-slipstack) ] [ (make-stateful-strains) ] [ (make-hitstack) ] tri* ; inline

: (insert-iota) ( vstrains hitstack -- iota vstrains hitstack )
    [ length iota ] keep swapd ; inline

: (do-all-initial-checks) ( iota vstrains strains hitstack -- )
    [ (do-initial-checks) ] 3curry each ; inline

: (build-verge-state) ( slipstack vstrains strains hitstack -- state )
    [ swap rot ] dip dup last \ verge-state boa ;
PRIVATE>

: <verge-state> ( start slip: ( -- value slip' ) strains -- state )
    dup [ pick (build-stacks) (insert-iota) ] dip
    swap [ (do-all-initial-checks) ] 3keep
    (build-verge-state) nip ;

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
