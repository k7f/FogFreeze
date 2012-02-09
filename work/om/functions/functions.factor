! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel locals math ;
IN: om.functions

! ________________________________________
! 01-basicproject/functions/functions.lisp

:: linear-fun ( x0 y0 x1 y1 -- quot: ( x -- y ) )
    x0 x1 = [ x0 [ = 1 0 ? ] curry ] [
        y1 y0 - x1 x0 - /
        y1 x1 pick * -
        [ [ * ] dip + ] 2curry
    ] if ;
