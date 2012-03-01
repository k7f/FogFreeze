! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.trees.measures tools.test ;
IN: om.trees.measures.tests

[ f ] [
    f fuse-rests-and-ties
] unit-test

[ { 1 -2 } ] [
    { 1 -1 1. } fuse-rests-and-ties
] unit-test

[ { 2 -1 } ] [
    { 1 1. -1 } fuse-rests-and-ties
] unit-test
