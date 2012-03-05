! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.rhythm om.trees.measures tools.test ;
IN: om.trees.measures.tests

[ t ] [
    { 1 } 4 4 <measure> measure?
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 4 } } ] [
    { 1 } 4 4 <measure>
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 1 1 1 1 } } ] [
    { 1 1+1/4 1+2/4 1+3/4 } 4 4 <measure>
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 1. 2 1 } } ] [
    { 1+1/4 1+3/4 } 4 4 <measure>
] unit-test
