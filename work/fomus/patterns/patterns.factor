! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: fomus.lli fry kernel math sequences sequences.repeating ;
IN: fomus.patterns

! FIXME the staff hint should be optional
! the staff hint, unlike voice, is local to the note,
! i.e. it does not persist (a bug in fomus?)
GENERIC: add-tenor ( staff color talea -- )

M: f add-tenor
    drop [ fomus-set-pitch fomus-set-staff fomus-add-note ] with each ;

M: number add-tenor
    dup fomus-set-dur
    '[ fomus-set-pitch fomus-set-staff fomus-add-note _ fomus-inc-time ] with each ;

M: sequence add-tenor
    2dup shorter? [ [ length cycle ] keep ] [ over length cycle ] if
    rot [
        fomus-set-staff [ fomus-set-dur fomus-set-pitch ] keep
        fomus-add-note fomus-inc-time
    ] curry 2each ;

: add-chord ( staff chord duration -- )
    [ fomus-set-dur f add-tenor ] keep fomus-inc-time ; inline
