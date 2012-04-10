! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math om.rhythm om.rhythm.transformer sequences
       tools.test ;
IN: om.rhythm.transformer.tests

[ T{ rhythm-ref f 2 {< f 1 2 3 >} 3 0 } ] [
    2 {< f 1 2 3 >} f <rhythm-ref>
] unit-test

[ T{ rhythm-ref f 0 f {< f 1 2 3 >} 0 } ] [
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

[ T{ rhythm-ref f 2 {< f 1 2 3 >} 3 0 } ] [
    {< f 1 2 3 >}
    2 2 [ swap f <rhythm-ref> ] bi-curry@ bi co-refs?
] unit-test

: indices&places ( rtf -- indices places )
    refs>> [ [ index>> ] map ] [ [ place>> ] map ] bi ;

CONSTANT: rhythmA {< f {< 3//4 -1 {< 1 -1 >} 1 >} {< 3//4 -1 >} >}
CONSTANT: rhythmB {< f {< 3//4 -1 {< 1 1. >} 1 >} {< 3//4 -1 >} >}
CONSTANT: rhythmC {< f {< -1 {< 1 -1 >} 1 >} {< -1 >} >}
CONSTANT: rhythmD {< f {< -1 {< 1 -1 >} 1 >} {< 1 >} >}

[ { 0 0 1 2 0 } { 0 1 2 3 4 } ] [
    rhythmA <rhythm-transformer> indices&places
] unit-test

[ { 0 0 1 2 0 } { 0 1 1 2 3 } ] [
    rhythmB -1 [ integer? ] make-rhythm-transformer nip indices&places
] unit-test

[ { 0 0 1 2 0 } { -1 0 0 1 2 } ] [
    rhythmD -1 make-note-transformer nip indices&places
] unit-test

[ { 0 1 2 } { 0 0 1 } ] [
    rhythmB -1 make-note-transformer* nip indices&places
] unit-test

[ f t ] [
    rhythmC <rhythm-transformer> dup clone [ eq? ] [ = ] 2bi
] unit-test

[ f t ] [
    rhythmC <rhythm-transformer> dup clone-rhythm [ eq? ] [ = ] 2bi
] unit-test

[ t t ] [
    rhythmC <rhythm-transformer> dup clone
    [ refs>> last parent>> ] bi@ [ eq? ] [ = ] 2bi
] unit-test

[ f t ] [
    rhythmC <rhythm-transformer> dup clone-rhythm
    [ refs>> last parent>> ] bi@ [ eq? ] [ = ] 2bi
] unit-test

[ {< f {< 1 {< 1 1 >} 1 >} {< 1 >} >} ] [
    rhythmC clone-rhythm <rhythm-transformer>
    map-rests>notes! >rhythm-transformer<
] unit-test

[ {< f {< 1 {< 1 1 >} 1 >} {< 1 >} >} ] [
    rhythmC <rhythm-transformer> map-rests>notes >rhythm-transformer<
] unit-test

[ {< f {< -1 {< -1 -1 >} 1 >} {< -1 >} >} ] [
    rhythmD clone-rhythm <rhythm-transformer>
    { 1 2 4 } submap-notes>rests! >rhythm-transformer<
] unit-test

[ {< f {< -1 {< -1 -1 >} 1 >} {< -1 >} >} ] [
    rhythmD <rhythm-transformer>
    { 1 2 4 } submap-notes>rests >rhythm-transformer<
] unit-test

[ {< f {< -1 {< -1 -1 >} 1 >} {< -1 >} >} ] [
    rhythmD clone-rhythm { 0 2 } submap-notes>rests!
] unit-test

[ {< f {< -1 {< -1 -1 >} 1 >} {< -1 >} >} ] [
    rhythmD { 0 2 } submap-notes>rests
] unit-test

[ { -1 1 1.0 1 -1 } ] [
    rhythmB rhythm-atoms
] unit-test

[ { { 1 } { 2 3.0 } { 5 } } ] [
    {< f 1 2 3. -4 5 -6 >} <rhythm-transformer>
    group-notes [ [ value>> ] map ] map
] unit-test

[ { { 2 3.0 } { 5 } } ] [
    {< f -1 2 3. -4 5 >} <rhythm-transformer>
    group-notes [ [ value>> ] map ] map
] unit-test

[ { { 2 3.0 } { 5 } } ] [
    {< f -1 2 3. -4 5 >} group-notes [ [ value>> ] map ] map
] unit-test

[ {< 15 >< -1 4 6. -4 10 >} ] [
    {< t -1 2 3. -4 5 >} dup <rhythm-transformer>
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
