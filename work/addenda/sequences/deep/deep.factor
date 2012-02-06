! Copyright (C) 2012 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: kernel math quotations sequences strings ;
QUALIFIED-WITH: sequences.deep basis
IN: addenda.sequences.deep

! FIXME find out why is quotation a basis:branch?
GENERIC: ,:branch? ( obj -- ? )

M: quotation ,:branch? drop f ;
M: string    ,:branch? drop f ;
M: sequence  ,:branch? drop t ;
M: object    ,:branch? drop f ;
