! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators.short-circuit debugger effects io kernel parser
       math multiline namespaces prettyprint quotations stack-checker strings ;
IN: ff

<PRIVATE
SYMBOL: tracing-enabled?
PRIVATE>

SYNTAX: TRACING: scan-object tracing-enabled? set ;

SYNTAX: <TRACING
    tracing-enabled? get [ "TRACING>" parse-multiline-string drop ] unless ;

SYNTAX: TRACING> ;

<PRIVATE
SYMBOL: trace?

ERROR: (tracing-mismatch) { given read-only } ;

M: (tracing-mismatch) error.
    "Bad tracing request " write given>> [
        fixnum? [ "(not a hack): " ] [ "(not a number): " ] if write
    ] [ . ] bi ;

: (set-trace) ( level/? -- ) trace? set ; inline
: (get-trace) ( -- level/? ) trace? get ; inline

: (traceable-level?) ( min-level -- ? )
    (get-trace) [ dup fixnum? [ <= ] [ 2drop f ] if ] [ drop f ] if* ; inline
PRIVATE>

: set-tracing-off ( -- ) f (set-trace) ;

: set-tracing-level ( level -- )
    dup fixnum? [ (set-trace) ] [ (tracing-mismatch) ] if ;

: set-tracing-hack ( hack -- )
    dup { [ fixnum? ] [ not ] } 1|| [ (tracing-mismatch) ] [ (set-trace) ] if ;

: should-trace? ( min-level/hack -- ? )
    (get-trace) [
        over fixnum? [ dup fixnum? [ <= ] [ 2drop f ] if ] [ = ] if
    ] [ drop f ] if* ; inline

: tracing? ( -- ? ) 1 (traceable-level?) ; inline
: high-tracing? ( -- ? ) 2 (traceable-level?) ; inline
: full-tracing? ( -- ? ) 3 (traceable-level?) ; inline

<PRIVATE
ERROR: (invalid-stack-effect) { expected effect read-only } { given effect read-only } ;

M: (invalid-stack-effect) error.
    "Invalid stack effect: " write dup given>> pprint " instead of " write expected>> . ;
PRIVATE>

: validate-effect ( quot effect -- quot )
    over [
        infer 2dup effect= [ 2drop ] [ (invalid-stack-effect) ] if
    ] [ drop ] if* ;

GENERIC: invalid-input ( obj -- * )

<PRIVATE
ERROR: (invalid-input-string) { message string read-only } ;
M: (invalid-input-string) error. "Invalid input: " write message>> . ;
PRIVATE>

M: string invalid-input (invalid-input-string) ;

MIXIN: maybe-fixnum
INSTANCE: f maybe-fixnum
INSTANCE: fixnum maybe-fixnum

MIXIN: maybe-callable
INSTANCE: f maybe-callable
INSTANCE: callable maybe-callable
