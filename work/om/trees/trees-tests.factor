! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel om.rhythm om.rhythm.meter om.rhythm.transformer om.trees
       sequences tools.test ;
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

[ T{ rhythm f 3
     { T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 4 1 } } 1 1 } }
       T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 } } -2 } }
       T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 2 -2 } } 2 } } } } ] [
    { f { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
          { 4//4 { 1 { 1 { 1 } } { 1 { -1 } } -1 } }
          { 4//4 { 1 { 1 { 1 2 -1 -1 } } 1 1.0 } } } } reducetree
] unit-test

[ T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 } } -2 } } ] [
    T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 } } -1 -1 } } reducetree
] unit-test

[ T{ rhythm f 1
     { T{ rhythm f T{ meter f 4 8 } { T{ rhythm f 4 { 4 } } } }
       T{ rhythm f T{ meter f 4 8 } { T{ rhythm f 4 { 1 1 1 1 } } } } } } ] [
    { 4 4 } { 8 8 } { 4 { 1 1 1 1 } } pulsemaker
] unit-test

[ T{ rhythm f 2
     { T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 2.0 1 1 } } 1 1.0 } }
       T{ rhythm f T{ meter f 4 4 } { 1.0 T{ rhythm f 1 { 1 2 1.0 1 } } 1.0 1 } } } }
] [
    { { 4//4 { 1 { 1 { 1 -2 1 1 } } 1 -1 } }
      { 4//4 { -1 { 1 { 1 2 -1 1 } } -1 1 } } }
    [ >rhythm-element ] map f swap <rhythm> tietree
] unit-test

[ T{ rhythm f 2
     { T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 2 1 1 } } 1 1 } }
       T{ rhythm f T{ meter f 4 4 } { 1.0 T{ rhythm f 1 { 1 2 1 1 } } 1 1 } } } }
] [
    { { 4//4 { 1 { 1 { 1 -2 1 1 } } 1 -1 } }
      { 4//4 { -1 { 1 { 1 2 -1 1 } } -1 1 } } }
    [ >rhythm-element ] map f swap <rhythm>
    <rhythm-transformer> transform-rests >rhythm-transformer<
] unit-test

[ T{ rhythm f 2
     { T{ rhythm f T{ meter f 4 4 } { 1 T{ rhythm f 1 { 1 2 1 1 } } 1 1 } }
       T{ rhythm f T{ meter f 4 4 } { 1.0 T{ rhythm f 1 { 1 2 1 1 } } 1 1 } } } }
] [
    { { 4//4 { 1 { 1 { 1 -2 1 1 } } 1 -1 } }
      { 4//4 { -1 { 1 { 1 2 -1 1 } } -1 1 } } }
    [ >rhythm-element ] map f swap <rhythm> remove-rests
] unit-test

[
    T{ rhythm f f { T{ rhythm f 1 { -1 T{ rhythm f 1 { -1 -1 } } 1 } }
                    T{ rhythm f 1 { -1 } } } }
] [
    T{ rhythm f f { T{ rhythm f 1 { -1 T{ rhythm f 1 { 1 -1 } } 1 } }
                    T{ rhythm f 1 { 1 } } }
    } <rhythm-transformer> { 1 4 } transform-notes-flt >rhythm-transformer<
] unit-test

[
    T{ rhythm f f { T{ rhythm f 1 { -1 T{ rhythm f 1 { -1 -1 } } 1 } }
                    T{ rhythm f 1 { -1 } } } }
] [
    T{ rhythm f f { T{ rhythm f 1 { -1 T{ rhythm f 1 { 1 -1 } } 1 } }
                    T{ rhythm f 1 { 1 } } }
    } { 0 2 } filtertree
] unit-test

[ { { 1 } { 1 2.0 1.0 } { 1 } { 1 } { 1 } { 1 } { 1 } { 2 } { 1 } { 1 } { -1 } { 1 } } ] [
    f { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
        { 4//4 { 1 { 1 { 1 2 1 1 } } -1 1 } } } <rhythm> group-pulses
] unit-test

[ 11 ] [
    f { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
        { 4//4 { 1 { 1 { 1 2 1 1 } } -1 1 } } } <rhythm> n-pulses
] unit-test

[ T{ rhythm f 2 { T{ rhythm f T{ meter f 4 4 }
                     { 1 -1 T{ rhythm f 1 { 1 1 2 1 } } 1.0 } }
                  T{ rhythm f T{ meter f 4 4 }
                     { 1 1 T{ rhythm f 1 { 1 1 2.0 1.0 } } 1 } } } }
] [
    f { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
        { 4//4 { 1 { 1 { 1.0 2 1 1 } } -1 1 } } } <rhythm> reversetree
] unit-test
