! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors addenda.eval addenda.prettyprint arrays io.streams.string
       kernel math om.rhythm prettyprint sequences tools.test ;
IN: om.rhythm.tests

[
    "T{ rhythm-tree { duration 1 } { division { T{ rhythm-tree { duration 1 } { division { -1 } } } } } }"
] [
    {< {< >} >} unparse-tuple
] unit-test

: (reparse-literal) ( token vocabs -- obj token' )
    eval-using [ [ pprint ] with-string-writer ] keep swap ; inline

: reparse-literal ( token vocabs -- obj ? )
    over [ (reparse-literal) ] dip = ;

[
    { { {< >} t } { {< >} f } { {< >} f }
      { {< -2 >} t } { {< 1 >} t } { {< 2 >} t } { {< 3//4 >} t }
      { {< >} f } { {< 2 >< >} t } { {< 3//4 >} f }
      { {< >} f } { {< -2 >} f } { {< 1 >} f } { {< 2 >} f }
      { {< {< >} >} t }
    }
] [
    { "{< >}" "{< >< >}" "{< -1 >}"
      "{< -2 >}" "{< 1 >}" "{< 2 >}" "{< 3//4 >}"
      "{< 1 >< >}" "{< 2 >< >}" "{< 3//4 >< >}"
      "{< >< -1 >}" "{< >< -2 >}" "{< >< 1 >}" "{< >< 2 >}"
      "{< {< >} >}"
    }
    [ { "om.rhythm" } reparse-literal 2array ] map
] unit-test

[ {< 1/4 1/4 1/4 1/4 >} 1 ] [
    t { 1/4 1/4 1/4 1/4 } <rhythm-tree> dup duration>>
] unit-test

[ {< 3/4 >< 1/4 1/4 1/4 >} ] [
    t { 1/4 1/4 1/4 } <rhythm-tree>
] unit-test

[ {< 1 1 1 1 >} ] [
    1 { 1 1 1 1 } {< >} <rhythm>
] unit-test

[ {< 4//4 1 1 1 1 >} ] [
    { 4 4 } { 1 1 1 1 } {< >} <rhythm>
] unit-test

[ {< 1 1 1 1 >} ] [
    { 1 2 3 4 5 } onsets>rhythm
] unit-test

[ {< 1. 1 -1 >} ] [
    { 2 -3 4 } onsets>rhythm
] unit-test

[ {< {< 2 >< 1 1 1 >} -1 1 >} ] [
    { 1 3 5 -7 10 13 } onsets>rhythm
] unit-test

[ {< 1 -1 {< 2 >< 1 1 1 >} >} ] [
    { 1 -4 7 9 11 13 } onsets>rhythm
] unit-test

[ {< -1 {< 2 >< 1 1 1 >} 1 >} ] [
    { -1 4 6 8 10 13 } onsets>rhythm
] unit-test

[ {< 1. {< 2 >< 1 1 1 >} -1 >} ] [
    { 4 6 8 -10 13 } onsets>rhythm
] unit-test

[ {< 1 1 {< 2 >< 2 1 >} >} ] [
    { 1 4 7 11 13 } onsets>rhythm
] unit-test

[ {< {< 2 >< 2 1 >} 1 1 >} ] [
    { 1 5 7 10 13 } onsets>rhythm
] unit-test

[ {< {< 2 >< 1 2 >} 1 1 >} ] [
    { 1 3 7 10 13 } onsets>rhythm
] unit-test

[ {< 1 1 {< 2 >< 1 2 >} >} ] [
    { 1 4 7 9 13 } onsets>rhythm
] unit-test

[ {< 1 {< 1 1 1 >} >} ] [
    { 1 4 5 6 7 } onsets>rhythm
] unit-test

[ {< 1. {< 1 1 1 >} >} ] [
    { 4 5 6 7 } onsets>rhythm
] unit-test

[ {< {< 1 1 1 >} 1 >} ] [
    { 1 2 3 4 7 } onsets>rhythm
] unit-test

[ {< 1 1 1 1 >} ] [
    { 1 2 3 4 } 4 absolute-rhythm
] unit-test

[ {< 1. 1 1 >} ] [
    { 2 3 } 3 absolute-rhythm
] unit-test

[ {< 1. 2 1 >} ] [
    { 1+1/4 1+3/4 } 1 absolute-rhythm
] unit-test

[ 4 ] [
    { 1 } 4 absolute-rhythm-element
] unit-test

[ f ] [
    f fuse-rests-and-ties
] unit-test

[ { 1 -2 } ] [
    { 1 -1 1. } fuse-rests-and-ties
] unit-test

[ { 2 -1 } ] [
    { 1 1. -1 } fuse-rests-and-ties
] unit-test

[ { 1 {< 1 {< 4 1 >} 3 >} 2 } ] [
    { 1 {< 1 {< 1 2. 1. 1 >} 1 1. 1. >} 1 1. } fuse-notes-deep
] unit-test

[ { {< -1 {< 1 -3 1 >} -3 >} } ] [
    { {< -1 {< 1 -2 -1 1 >} -1 -1 -1 >} } fuse-rests-deep
] unit-test

[ { {< -2 -1 -1 >} } ] [
    { {< -1 -1 {< -2 -1 >} -1 >} } fuse-rests-deep
] unit-test

[ t ] [
    { 1 } 4 4 <measure> measure?
] unit-test

[ {< 4//4 4 >} ] [
    { 1 } 4 4 <measure>
] unit-test

[ {< 4//4 1 1 1 1 >} ] [
    { 1 1+1/4 1+2/4 1+3/4 } 4 4 <measure>
] unit-test

[ {< 4//4 1. 2 1 >} ] [
    { 1+1/4 1+3/4 } 4 4 <measure>
] unit-test

[ {< f {< 4//4 4 >} >} ] [
    { 1 } { { 4 4 } } zip-measures
] unit-test

[ {< f {< 4//4 1 1 1 1 >} >} ] [
    { 1/4 1/4 1/4 1/4 } { { 4 4 } } zip-measures
] unit-test

[ {< f {< 4//4 -1 1 -1 1 >} >} ] [
    { -1/4 1/4 -1/4 1/4 } { { 4 4 } } zip-measures
] unit-test

[ {< f {< 3//4 1 1 1 >} {< 3//4 3. >} >} ] [
    { 1/4 1/4 4/4 } { { 3 4 } { 3 4 } } zip-measures
] unit-test

[ {< 4//4 {< 2 >} 2 4 >} ] [
    {< 4//4 {< 1 >} 1 2 >} [ 2 * ] map-rhythm
] unit-test

[ {< 4//4 {< 2 >} 2 4 >} ] [
    {< 4//4 {< 1 >} 1 2 >} [ 2 * ] map-rhythm!
] unit-test

[ f ] [
    {< 4//4 1 >} dup [ ] map-rhythm eq?
] unit-test

[ t ] [
    {< 4//4 1 >} dup [ ] map-rhythm! eq?
] unit-test

[ {< f {< 1 {< 1 1 >} 1 >} {< 1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >} map-rests>notes
] unit-test

[ {< f {< 1 {< 1 1 >} 1 >} {< 1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >} map-rests>notes!
] unit-test

[ {< f {< -1 {< -1 -1 >} -1 >} {< -1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >} map-notes>rests
] unit-test

[ {< f {< -1 {< -1 -1 >} -1 >} {< -1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >} map-notes>rests!
] unit-test

[ {< f {< 1 {< -1 1 >} -1 >} {< 1 >} >} ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >}
    { { -1 1 } { 1 -1 } } rhythm-substitute
] unit-test

[ { -1 1 -1 1 -1 } ] [
    {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >} rhythm-atoms
] unit-test
