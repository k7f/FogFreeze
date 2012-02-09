! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sets kernel tools.test ;
IN: addenda.sets.tests

[ { 1 2 3 4 } ] [
    { 1 2 3 } { 2 3 4 } [ = ] union*
] unit-test

[ { 1 } ] [
    { 1 2 3 } { 2 3 4 } [ = ] diff*
] unit-test

[ { 1 4 } ] [
    { 1 2 3 } { 2 3 4 } symmetric-diff
] unit-test

[ { 1 4 } ] [
    { 1 2 3 } { 2 3 4 } [ = ] symmetric-diff*
] unit-test
