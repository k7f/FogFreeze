! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel math om.rhythm om.rhythm.meter om.rhythm.transformer
       sequences tools.test ;
IN: om.rhythm.transformer.tests

[ T{ rhythm-ref f 2 T{ rhythm f f { 1 2 3 } } 3 0 } ] [
    2 T{ rhythm f f { 1 2 3 } } f <rhythm-ref>
] unit-test

[ T{ rhythm-ref f 0 f T{ rhythm f f { 1 2 3 } } } ] [
    T{ rhythm f f { 1 2 3 } } dup
    [ [ 0 f ] dip <rhythm-ref> ] bi@ co-refs?
] unit-test

[ f ] [
    T{ rhythm f f { 1 2 3 } } dup clone-rhythm
    [ [ 0 f ] dip <rhythm-ref> ] bi@ co-refs?
] unit-test

[ f ] [
    T{ rhythm f f { 1 2 3 } } dup clone-rhythm
    [ 2 swap f <rhythm-ref> ] bi@ co-refs?
] unit-test

[ f ] [
    T{ rhythm f f { 1 2 3 } }
    1 2 [ swap f <rhythm-ref> ] bi-curry@ bi co-refs?
] unit-test

[ T{ rhythm-ref f 2 T{ rhythm f f { 1 2 3 } } 3 0 } ] [
    T{ rhythm f f { 1 2 3 } }
    2 2 [ swap f <rhythm-ref> ] bi-curry@ bi co-refs?
] unit-test

: indices&places ( rt -- indices places )
    refs>> [ [ index>> ] map ] [ [ place>> ] map ] bi ;

CONSTANT: rhythmA T{
    rhythm f f { T{ rhythm f T{ meter f 3 4 } { -1 T{ rhythm f 1 { 1 -1 } } 1 } }
                 T{ rhythm f T{ meter f 3 4 } { -1 } } }
}

CONSTANT: rhythmB T{
    rhythm f f { T{ rhythm f T{ meter f 3 4 } { -1 T{ rhythm f 1 { 1 1. } } 1 } }
                 T{ rhythm f T{ meter f 3 4 } { -1 } } }
}

CONSTANT: rhythmC T{
    rhythm f f { T{ rhythm f 1 { -1 T{ rhythm f 1 { 1 -1 } } 1 } }
                 T{ rhythm f 1 { -1 } } }
}

[ { 0 0 1 2 0 } { 0 1 2 3 4 } ] [
    rhythmA <rhythm-transformer> indices&places
] unit-test

[ { 0 0 1 2 0 } { 0 1 1 2 3 } ] [
    rhythmB -1 [ integer? ] make-rhythm-transformer nip indices&places
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
