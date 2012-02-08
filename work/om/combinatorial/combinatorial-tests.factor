! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: arrays kernel math om.combinatorial om.support sequences sets sorting
       strings tools.test ;
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

[ "bcdea" ] [
    "abcde" 1 rotate
] unit-test

[ "deabc" ] [
    "abcde" 3 rotate
] unit-test

[ t ] [
    { 3 4 5 } [ nth-random ] keep in?
] unit-test

[ f t ] [
    { 1 2 3 4 5 } dup permut-random [ = ] [ natural-sort = ] 2bi
] unit-test

[ { 0 1 2 3 4 } ] [
    { 4 5 6 7 8 } \ < posn-order
] unit-test

[ { 4 3 2 1 0 } ] [
    { 4 5 6 7 8 } \ > posn-order
] unit-test

[ { "abc" "acb" "bac" "bca" "cab" "cba" } ] [
    "abc" permutations
] unit-test
