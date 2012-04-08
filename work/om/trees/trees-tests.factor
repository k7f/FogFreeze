! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel om.rhythm om.rhythm.meter om.rhythm.transformer om.trees
       sequences tools.test ;
IN: om.trees.tests

[ {< f {< 4//4 4 >} >} ] [
    { 1 } { 4 4 } mktree
] unit-test

[ {< f {< 4//4 1 1 1 1 >} >} ] [
    { 1/4 1/4 1/4 1/4 } { 4 4 } mktree
] unit-test

[ {< f {< 4//4 -1 1 -1 1 >} >} ] [
    { -1/4 1/4 -1/4 1/4 } { 4 4 } mktree
] unit-test

[ {< f {< 3//4 1 1 1 >} {< 3//4 3. >} >} ] [
    { 1/4 1/4 4/4 } { 3 4 } mktree
] unit-test

[ {< 3 >< {< 4//4 1 {< 4 1 >} 1 1 >}
          {< 4//4 1 {< 1 >} -2 >}
          {< 4//4 1 {< 1 2 -2 >} 2 >} >}
] [
    { 3 { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
          { 4//4 { 1 { 1 { 1 } } { 1 { -1 } } -1 } }
          { 4//4 { 1 { 1 { 1 2 -1 -1 } } 1 1.0 } } } } reducetree
] unit-test

[ {< 4//4 1 {< 1 >} -2 >} ] [
    {< 4//4 1 {< 1 >} -1 -1 >} reducetree
] unit-test

[ {< f {< 4//8 {< 4 >< 4 >} >} {< 4//8 {< 4 >< 1 1 1 1 >} >} >} ] [
    { 4 4 } { 8 8 } { 4 { 1 1 1 1 } } pulsemaker
] unit-test

[ {< f {< 4//4 1 {< 1 2.0 1 1 >} 1 1.0 >}
       {< 4//4 1.0 {< 1 2 1.0 1 >} 1.0 1 >} >}
] [
    { { 4//4 { 1 { 1 { 1 -2 1 1 } } 1 -1 } }
      { 4//4 { -1 { 1 { 1 2 -1 1 } } -1 1 } } }
    [ >rhythm-element ] map f swap <rhythm> tietree
] unit-test

[ {< f {< 4//4 1 {< 1 2 1 1 >} 1 1 >}
       {< 4//4 1.0 {< 1 2 1 1 >} 1 1 >} >}
] [
    { { 4//4 { 1 { 1 { 1 -2 1 1 } } 1 -1 } }
      { 4//4 { -1 { 1 { 1 2 -1 1 } } -1 1 } } }
    [ >rhythm-element ] map f swap <rhythm>
    <rhythm-transformer> transform-rests >rhythm-transformer<
] unit-test

[ {< f {< 4//4 1 {< 1 2 1 1 >} 1 1 >}
       {< 4//4 1.0 {< 1 2 1 1 >} 1 1 >} >}
] [
    { { 4//4 { 1 { 1 { 1 -2 1 1 } } 1 -1 } }
      { 4//4 { -1 { 1 { 1 2 -1 1 } } -1 1 } } }
    [ >rhythm-element ] map f swap <rhythm> remove-rests
] unit-test

[ {< f {< -1 {< -1 -1 >} 1 >} {< -1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< 1 >} >} <rhythm-transformer>
    { 1 4 } transform-notes-flt >rhythm-transformer<
] unit-test

[ {< f {< -1 {< -1 -1 >} 1 >} {< -1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< 1 >} >} { 0 2 } filtertree
] unit-test

[ { { 1 } { 1 2.0 1.0 } { 1 } { 1 } { 1 } { 1 } { 1 } { 2 } { 1 } { 1 } { -1 } { 1 } } ] [
    f { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
        { 4//4 { 1 { 1 { 1 2 1 1 } } -1 1 } } } <rhythm> group-pulses
] unit-test

[ 11 ] [
    f { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
        { 4//4 { 1 { 1 { 1 2 1 1 } } -1 1 } } } <rhythm> n-pulses
] unit-test

[ {< 2 >< {< 4//4 1 -1 {< 1 1 2 1 >} 1.0 >}
          {< 4//4 1 1 {< 1 1 2.0 1.0 >} 1 >} >}
] [
    2 { { 4//4 { 1 { 1 { 1 2.0 1.0 1 } } 1 1 } }
        { 4//4 { 1 { 1 { 1.0 2 1 1 } } -1 1 } } } <rhythm> reversetree
] unit-test
