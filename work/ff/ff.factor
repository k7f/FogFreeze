! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger effects io kernel math namespaces prettyprint quotations
       stack-checker strings ;
IN: ff

<PRIVATE
SYMBOL: trace?
PRIVATE>

: set-trace ( level/? -- ) trace? set ;
: get-trace ( -- level/? ) trace? get ;
: should-trace? ( min-level -- ? )
    trace? get dup fixnum? [ <= ] [ 2drop f ] if ;

<PRIVATE
TUPLE: (invalid-stack-effect) { expected effect read-only } { given effect read-only } ;

: (invalid-stack-effect) ( expected given -- * ) \ (invalid-stack-effect) boa throw ;

M: (invalid-stack-effect) error.
    "Invalid stack effect: " write dup given>> pprint " instead of " write expected>> . ;
PRIVATE>

: validate-effect ( quot effect -- quot )
    over [
        infer 2dup effect= [ 2drop ] [ (invalid-stack-effect) ] if
    ] [ drop ] if* ;

MIXIN: maybe-fixnum
INSTANCE: f maybe-fixnum
INSTANCE: fixnum maybe-fixnum

MIXIN: maybe-quotation
INSTANCE: f maybe-quotation
INSTANCE: quotation maybe-quotation
