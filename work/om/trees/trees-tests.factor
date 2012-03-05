! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.rhythm om.trees tools.test ;
IN: om.trees.tests

[ T{ rhythm f f { T{ rhythm f T{ meter f 4 4 } { 4 } } } } ] [
    { 1 } { 4 4 } mktree
] unit-test

[ T{ rhythm f f { T{ rhythm f T{ meter f 4 4 } { 1 1 1 1 } } } } ] [
    { 1/4 1/4 1/4 1/4 } { 4 4 } mktree
] unit-test

[ T{ rhythm f f { T{ rhythm f T{ meter f 4 4 } { -1 1 -1 1 } } } } ] [
    { -1/4 1/4 -1/4 1/4 } { 4 4 } mktree
] unit-test

[ T{ rhythm f f
     { T{ rhythm f T{ meter f 3 4 } { 1 1 1 } }
       T{ rhythm f T{ meter f 3 4 } { 3. } } } } ] [
    { 1/4 1/4 4/4 } { 3 4 } mktree
] unit-test
