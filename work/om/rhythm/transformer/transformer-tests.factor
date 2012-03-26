! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors kernel  math om.rhythm om.rhythm.meter om.rhythm.transformer
       sequences tools.test ;
IN: om.rhythm.transformer.tests

: indices&places ( rt -- indices places )
    refs>> [ [ index>> ] map ] [ [ place>> ] map ] bi ;

[ { 0 0 1 2 0 } { 0 1 2 3 4 } ] [
    T{ rhythm f f
       { T{ rhythm f T{ meter f 3 4 } { 1 T{ rhythm f 1 { 1 1 } } 1 } }
         T{ rhythm f T{ meter f 3 4 } { 1 } }
       }
    } <rhythm-transformer> indices&places
] unit-test

[ { 0 0 1 2 0 } { 0 1 1 2 3 } ] [
    T{ rhythm f f
       { T{ rhythm f T{ meter f 3 4 } { 1 T{ rhythm f 1 { 1 1. } } 1 } }
         T{ rhythm f T{ meter f 3 4 } { 1 } }
       }
    } [ integer? ] <rhythm-transformer*> indices&places
] unit-test
