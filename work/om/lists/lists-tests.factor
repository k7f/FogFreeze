! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: om.lists tools.test ;
IN: om.lists.tests

[ 5 ] [
    { 1 2 3 4 5 } last-elem
] unit-test

[ { 3 4 5 } ] [
    { 1 2 3 4 5 } 3 last-n
] unit-test

[ { 1 2 3 } ] [
    { 1 2 3 4 5 } 3 first-n
] unit-test

[ { 1 2 3 4 5 } ] [
    { 1 2 3 } { 4 5 } f x-append
] unit-test

[ { 1 4 5 } ] [
    1 { 4 5 } f x-append
] unit-test

[ { 1 2 3 4 } ] [
    { 1 2 3 } 4 f x-append
] unit-test

[ { 1 2 3 4 5 6 7 } ] [
    { 1 2 3 } 4 { { 5 6 7 } } x-append
] unit-test

[ { 1 2 3 4 5 6 7 } ] [
    { 1 2 3 } 4 { 5 6 7 } x-append
] unit-test

[ { 1 2 3 4 5 6 } ] [
    { { 1 2 } 3 { { 4 5 } 6 } } f flat
] unit-test

[ { 1 2 3 { 4 5 } 6 } ] [
    { { 1 2 } 3 { { 4 5 } 6 } } 1 flat
] unit-test

[ { create-list create-list create-list create-list } ] [
    4 \ create-list create-list
] unit-test

[ { { 1 "a" 4 } { 2 "b" 5 } { 3 "c" 6 } } ] [
    { { 1 2 3 } { "a" "b" "c" } { 4 5 6 } } mat-trans
] unit-test

[ { 0 "a" 1 2 "b" 3 } ] [
    { 0 1 2 3 } { "a" "b" } { 1 3 } interlock
] unit-test

[ { 0 1 "a" 3 } ] [
    { 0 1 2 3 } 2 "a" subs-posn
] unit-test

[ { 0 "a" 2 "b" } ] [
    { 0 1 2 3 } { 1 3 } { "a" "b" } subs-posn
] unit-test
