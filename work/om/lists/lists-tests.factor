! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel om.lists om.support om.syntax tools.test ;
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

[ { 2 4 2 4 2 4 0 1 2 3 4 5 6 7 8 } ] [
    '( 3* ( 2 4 ) 0_8 ) expand-lst
] unit-test

[ { "a" "z" 4 12 4 12 { 1 2 3 4 5 } "a" "z" 4 12 4 12 { 1 2 3 4 5 } 0 2 4 6 8 10 12 14 16 } ] [
    '( 2* ( "a" "z" 2* ( 4 12 ) ( 1_5 ) ) 0_16s2 ) expand-lst
] unit-test

[ { { 1 } { 2 3 4 } } ] [
    { 1 2 3 4 } { 1 3 } 'linear group-list
] unit-test

[ { { 1 } { 2 3 } { 4 } } ] [
    { 1 2 3 4 } { 1 2 3 } 'linear group-list
] unit-test

[ { { 1 } { 2 3 } { 4 1 2 } } ] [
    { 1 2 3 4 } { 1 2 3 } 'circular group-list
] unit-test

[ { 1 3 2 4 } ] [
    { 1 2 3 2 2 4 } \ = 1 remove-dup
] unit-test

[ { { 1 2 } { 3 2 } 4 } ] [
    { { 1 2 } { 3 2 2 } 4 } \ = 2 remove-dup
] unit-test

[ { { 1 4 7 } { 2 5 8 } { 3 6 9 } } ] [
    { 1 2 3 4 5 6 7 8 9 } 3 list-modulo
] unit-test

[ { { 1 3 5 7 9 } { 2 4 6 8 } } ] [
    { 1 2 3 4 5 6 7 8 9 } 2 list-modulo
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
