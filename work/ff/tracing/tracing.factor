! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors combinators.short-circuit debugger io kernel math multiline
       namespaces parser prettyprint ;
IN: ff.tracing

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
