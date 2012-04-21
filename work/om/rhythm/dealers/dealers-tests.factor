! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math om.rhythm om.rhythm.dealers sequences tools.test ;
IN: om.rhythm.dealers.tests

[ T{ rhythm-ref f 2 {< f 1 2 3 >} 3 } ] [
    2 {< f 1 2 3 >} f <rhythm-ref>
] unit-test

[ T{ rhythm-ref f 0 f {< f 1 2 3 >} } ] [
    {< f 1 2 3 >} dup
    [ [ 0 f ] dip <rhythm-ref> ] bi@ co-refs?
] unit-test

[ f ] [
    {< f 1 2 3 >} dup clone-rhythm
    [ [ 0 f ] dip <rhythm-ref> ] bi@ co-refs?
] unit-test

[ f ] [
    {< f 1 2 3 >} dup clone-rhythm
    [ 2 swap f <rhythm-ref> ] bi@ co-refs?
] unit-test

[ f ] [
    {< f 1 2 3 >}
    1 2 [ swap f <rhythm-ref> ] bi-curry@ bi co-refs?
] unit-test

[ T{ rhythm-ref f 2 {< f 1 2 3 >} 3 } ] [
    {< f 1 2 3 >}
    2 2 [ swap f <rhythm-ref> ] bi-curry@ bi co-refs?
] unit-test

CONSTANT: rhythmA {< f {< 3//4 -1 {< 1 -1 >} 1 >} {< 3//4 -1 >} >}
CONSTANT: rhythmB {< f {< 3//4 -1 {< 1 1. >} 1 >} {< 3//4 -1 >} >}
CONSTANT: rhythmC {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >}

[ { 0 0 1 2 0 } ] [
    rhythmA <rhythm-dealer> refs>> [ index>> ] map
] unit-test

[ { 0 0 2 0 } ] [
    rhythmB [ integer? ] make-rhythm-dealer refs>> [ index>> ] map
] unit-test

[ { 0 1 2 } ] [
    rhythmB make-note-dealer refs>> [ index>> ] map
] unit-test

[ f t ] [
    rhythmC <rhythm-dealer> dup clone [ eq? ] [ = ] 2bi
] unit-test

[ f t ] [
    rhythmC <rhythm-dealer> dup clone-rhythm [ eq? ] [ = ] 2bi
] unit-test

[ t t ] [
    rhythmC <rhythm-dealer> dup clone
    [ refs>> last parent>> ] bi@ [ eq? ] [ = ] 2bi
] unit-test

[ f t ] [
    rhythmC <rhythm-dealer> dup clone-rhythm
    [ refs>> last parent>> ] bi@ [ eq? ] [ = ] 2bi
] unit-test

[ {< f {< 1 {< 1 1 >} 1 >} {< 1 >} >} ] [
    rhythmC clone-rhythm <rhythm-dealer>
    map-rests>notes! >rhythm-dealer<
] unit-test

[ {< f {< 1 {< 1 1 >} 1 >} {< 1 >} >} ] [
    rhythmC <rhythm-dealer> map-rests>notes >rhythm-dealer<
] unit-test

[ { -1 1 1.0 1 -1 } ] [
    rhythmB <rhythm-dealer> rhythm-atoms
] unit-test

[ { { 1 } { 2 3.0 } { 5 } } ] [
    {< f 1 2 3. -4 5 -6 >} <rhythm-dealer>
    group-notes [ [ value>> ] map ] map
] unit-test

[ { { 2 3.0 } { 5 } } ] [
    {< f -1 2 3. -4 5 >} <rhythm-dealer>
    group-notes [ [ value>> ] map ] map
] unit-test

[ { { 2 3.0 } { 5 } } ] [
    {< f -1 2 3. -4 5 >} group-notes [ [ value>> ] map ] map
] unit-test

[ {< 15 >< -1 4 6. -4 10 >} ] [
    {< t -1 2 3. -4 5 >} dup <rhythm-dealer>
    [ [ [ 2 * ] change-value !rhythm-ref ] each ] each-note-slice
] unit-test

[ {< 15 >< -1 4 6. -4 10 >} ] [
    {< t -1 2 3. -4 5 >} dup
    [ [ [ 2 * ] change-value !rhythm-ref ] each ] each-note-slice
] unit-test

[ {< 15 >< -1 4 6. -4 10 >} ] [
    {< t -1 2 3. -4 5 >}
    [ dup [ [ 2 * ] change-value drop ] each ] map-note-slices!
] unit-test

[ {< 21 >< 2 4 6. -4 10 -6 >} ] [
    {< t 1 2 3. -4 5 -6 >}
    [ dup [ [ 2 * ] change-value drop ] each ] map-note-slices
] unit-test
