! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math math.functions om.rhythm sequences ;
IN: om.trees

! ____________________________________
! 02-musicproject/functions/trees.lisp

! ______
! mktree

<PRIVATE
: (total-duration) ( durs -- dur )
    0 [ abs + ] reduce ; inline

: (count-measures) ( durs tsigs -- n )
    [ (total-duration) ] [ first2 ] bi*
    [ / ] [ * ] bi*
    dup integer? [ truncate 1 + ] unless ; inline
PRIVATE>

: mktree ( durs tsigs -- rhm )
    dup first sequence?
    [ 2dup (count-measures) swap <repetition> ] unless
    zip-measures ;
