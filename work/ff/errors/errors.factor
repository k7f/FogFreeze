! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors debugger effects io kernel prettyprint stack-checker strings ;
IN: ff.errors

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