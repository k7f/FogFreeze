! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: math om.combinatorial om.support sequences tools.test ;
IN: om.combinatorial.tests

[ { 1 2 3 6 7 } ] [
    { 3 6 7 2 1 } f sort-list
] unit-test

[ { 7 6 3 2 1 } ] [
    { 3 6 7 2 1 } { { :test [ > ] } } sort-list
] unit-test

[ { { "c" 7 } { "b" 6 } { "a" 3 } { "d" 2 } { "e" 1 } } ] [
    { { "a" 3 } { "b" 6 } { "c" 7 } { "d" 2 } { "e" 1 } }
    { { :test [ > ] } { :key [ second ] } } sort-list
] unit-test

[ { { 5 2 4 3 } { 7 8 9 1 } } ] [
    { { 7 8 9 1 } { 5 2 4 3 } }
    { { :test [ < ] } { :key [ first ] } } sort-list
] unit-test

[ { { 1 7 8 9 } { 2 3 4 5 } } ] [
    { { 7 8 9 1 } { 5 2 4 3 } }
    { { :test [ < ] } { :rec t } } sort-list
] unit-test
