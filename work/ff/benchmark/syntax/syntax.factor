! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: combinators effects.parser kernel math system ;
IN: ff.benchmark.syntax

: benchmark-effect ( quot effect -- runtime )
    nano-count [ call-effect nano-count ] dip - ; inline

SYNTAX: benchmark( \ benchmark-effect parse-call( ;
