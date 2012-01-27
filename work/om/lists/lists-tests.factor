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
