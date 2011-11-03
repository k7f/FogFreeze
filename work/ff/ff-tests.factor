! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays ff ff.private sequences tools.test ;
IN: ff.tests

TRACING: f

<TRACING
[ "should never be" ] [ "executed" ] unit-test
TRACING>

TRACING: t

<TRACING

[ "a hack" set-tracing-level ] [ (tracing-mismatch)? ] must-fail-with
[ 0 set-tracing-hack ] [ (tracing-mismatch)? ] must-fail-with
[ f set-tracing-hack ] [ (tracing-mismatch)? ] must-fail-with

[ { f f f f f f f f } ] [
    set-tracing-off { f t "a hack" 0 1 2 3 4 } [ should-trace? ] map
] unit-test

[ { f t f f f f f f } ] [
    t set-tracing-hack { f t "a hack" 0 1 2 3 4 } [ should-trace? ] map
] unit-test

[ { f f t f f f f f } ] [
    "a hack" set-tracing-hack { f t "a hack" 0 1 2 3 4 } [ should-trace? ] map
] unit-test

[ { { f f f t f f f f }
    { f f f t t f f f }
    { f f f t t t f f }
    { f f f t t t t f }
    { f f f t t t t t } } ] [
    5 iota [
        set-tracing-level { f t "a hack" 0 1 2 3 4 } [ should-trace? ] map
    ] map
] unit-test

[ { { f f f }
    { t f f }
    { t t f }
    { t t t }
    { t t t } } ] [
    5 iota [ set-tracing-level tracing? high-tracing? full-tracing? 3array ] map
] unit-test

TRACING>
