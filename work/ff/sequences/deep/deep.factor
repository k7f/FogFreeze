! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math quotations sequences strings ;
QUALIFIED-WITH: sequences.deep basis
IN: ff.sequences.deep

! FIXME find out why is quotation a basis:branch?
GENERIC: ff:branch? ( obj -- ? )

M: quotation ff:branch? drop f ;
M: string    ff:branch? drop f ;
M: sequence  ff:branch? drop t ;
M: object    ff:branch? drop f ;
