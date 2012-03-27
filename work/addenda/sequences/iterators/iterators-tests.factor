! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: addenda.sequences.iterators math kernel sequences tools.test ;
IN: addenda.sequences.iterators.tests

[ 780 ] [
    40 iota <iterator> 0 [ + ] reduce
] unit-test

[ f ] [
    f <iterator> [ + ] fold
] unit-test

[ f ] [
    { } <iterator> [ + ] fold
] unit-test

[ 720 ] [
    7 iota <iterator> [ ?step drop ] keep [ * ] fold
] unit-test

[ 28 ] [
    { 1 2 3 } { 4 5 6 } <bi-iterator> 7 [ + + ] bi-fold
] unit-test
