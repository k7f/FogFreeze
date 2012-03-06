! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.rhythm.meter tools.test ;
IN: om.rhythm.meter.tests

[ T{ meter f 19 64 } ] [
    19 64 <meter> >meter
] unit-test

[ T{ meter f 19 64 } ] [
    "19//64" >meter
] unit-test

[ T{ meter f 19 64 } ] [
    19//64 >meter
] unit-test

[ T{ meter f 19 64 } ] [
    { 19 64 } >meter
] unit-test
