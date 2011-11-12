! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: combinators debugger fomus.ffi fry io io.backend kernel math math.parser
       namespaces sequences timidity ;
IN: fomus

<PRIVATE
SYMBOL: (fomus-initialized?)
SYMBOL: (fomus-instance)

ERROR: (fomus-not-initialized) ;
M: (fomus-not-initialized) error. drop "Execute fomus-start, please!" print ;

ERROR: (no-fomus-instance) ;
M: (no-fomus-instance) error. drop "Use with-fomus, please!" print ;
PRIVATE>

! ______________________
! primary infrastructure

: fomus-start ( -- )
    (fomus-initialized?) get-global [
        (fomus_init) t (fomus-initialized?) set-global
    ] unless ;

: <fomus> ( -- fomus )
    (fomus-initialized?) get-global [ (fomus_new) ] [ (fomus-not-initialized) ] if ;

: with-fomus ( fomus quot -- )
    swap (fomus-instance) set call (fomus-instance) get (fomus_free) ; inline

: fomus-call ( quot -- )
    (fomus-instance) get [ swap call ] [ (no-fomus-instance) ] if* ; inline

! _______________________________________
! primary wrapping interface: common part

: fomus-do-run ( -- )
    [ (fomus_copy) (fomus_run) ] fomus-call ;

: fomus-add-note ( -- )
    [ +fomus_par_noteevent+ +fomus_act_add+ (fomus_act) ] fomus-call ;

! _______________________________________
! primary wrapping interface: unsafe part

: fomus-push-integers ( seq -- )
    [ [ dup +fomus_par_list+ +fomus_act_start+ (fomus_act)
        swap [ dup +fomus_par_list+ +fomus_act_add+ ] dip (fomus_ival)
        +fomus_par_list+ +fomus_act_end+ (fomus_act)
    ] curry each ] fomus-call ;

: fomus-push-strings ( seq -- )
    [ [ dup +fomus_par_list+ +fomus_act_start+ (fomus_act)
        swap [ dup +fomus_par_list+ +fomus_act_add+ ] dip (fomus_sval)
        +fomus_par_list+ +fomus_act_end+ (fomus_act)
    ] curry each ] fomus-call ;

: fomus-set-integer-setting ( key value -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ _ (fomus_sval)
        +fomus_par_settingval+ +fomus_act_set+ _ (fomus_ival)
    ] fomus-call ;

: fomus-set-rational-setting ( key num den -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ _ (fomus_sval)
        +fomus_par_settingval+ +fomus_act_set+ _ _ (fomus_rval)
    ] fomus-call ;

: fomus-set-mixed-setting ( key offset num den -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ _ (fomus_sval)
        +fomus_par_settingval+ +fomus_act_set+ _ _ _ (fomus_mval)
    ] fomus-call ;

: fomus-set-float-setting ( key value -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ _ (fomus_sval)
        +fomus_par_settingval+ +fomus_act_set+ _ (fomus_fval)
    ] fomus-call ;

: fomus-set-string-setting ( key value -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ _ (fomus_sval)
        +fomus_par_settingval+ +fomus_act_set+ _ (fomus_sval)
    ] fomus-call ;

: fomus-set-list-setting ( key -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ _ (fomus_sval)
        +fomus_par_settingval+ +fomus_act_set+ (fomus_act)
    ] fomus-call ;

: fomus-do-save ( path -- )
    [ (fomus_copy) swap (fomus_save) ] fomus-call ;

: fomus-set-events ( merge -- )
    [ swap [ +fomus_par_events+ +fomus_act_set+ ] dip (fomus_ival) ] fomus-call ;

: fomus-clear-events ( -- )
    [ +fomus_par_events+ +fomus_act_clear+ (fomus_act) ] fomus-call ;

: fomus-add-part ( -- )
    [ +fomus_par_part+ +fomus_act_add+ (fomus_act) ] fomus-call ;

: fomus-set-part ( id -- )
    [ swap [ +fomus_par_part+ +fomus_act_set+ ] dip (fomus_sval) ] fomus-call ;

: fomus-set-part-id ( id -- )
    [ swap [ +fomus_par_part_id+ +fomus_act_set+ ] dip (fomus_sval) ] fomus-call ;

: fomus-set-part-inst ( inst -- )
    [ swap [ +fomus_par_part_inst+ +fomus_act_set+ ] dip (fomus_sval) ] fomus-call ;

: fomus-set-part-name ( name -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ "name" (fomus_sval)
        +fomus_par_part_settingval+ +fomus_act_set+ _ (fomus_sval)
    ] fomus-call ;

: fomus-set-staff ( staff -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ "staff" (fomus_sval)
        +fomus_par_note_settingval+ +fomus_act_set+ _ (fomus_ival)
    ] fomus-call ;

: fomus-set-staves ( staves -- )
    fomus-push-integers '[
        dup +fomus_par_setting+ +fomus_act_set+ "staff" (fomus_sval)
        +fomus_par_note_settingval+ +fomus_act_set+ (fomus_act)
    ] fomus-call ;

: fomus-set-clef ( clef -- )
    '[
        dup +fomus_par_setting+ +fomus_act_set+ "clef" (fomus_sval)
        +fomus_par_note_settingval+ +fomus_act_set+ _ (fomus_ival)
    ] fomus-call ;

! FIXME???
: fomus-add-voice ( voice -- )
    [ swap [ +fomus_par_voice+ +fomus_act_add+ ] dip (fomus_ival) ] fomus-call ;

: fomus-set-voice ( voice -- )
    [ swap [ +fomus_par_voice+ +fomus_act_set+ ] dip (fomus_ival) ] fomus-call ;

: fomus-set-time ( time -- )
    [ swap [ +fomus_par_time+ +fomus_act_set+ ] dip (fomus_fval) ] fomus-call ;

: fomus-inc-time ( amount -- )
    [ swap [ +fomus_par_time+ +fomus_act_inc+ ] dip (fomus_fval) ] fomus-call ;

: fomus-set-dyn ( level -- )
    [ swap [ +fomus_par_dynlevel+ +fomus_act_set+ ] dip (fomus_fval) ] fomus-call ;

: fomus-set-dur ( duration -- )
    [ swap [ +fomus_par_duration+ +fomus_act_set+ ] dip (fomus_fval) ] fomus-call ;

: fomus-set-pitch ( pitch -- )
    [ swap [ +fomus_par_pitch+ +fomus_act_set+ ] dip (fomus_ival) ] fomus-call ;

: fomus-get-integer ( key -- value )
    [ swap (fomus_get_ival) ] fomus-call ;

: fomus-get-rational ( key -- value )
    [ swap (fomus_get_rval) ] fomus-call ;

: fomus-get-float ( key -- value )
    [ swap (fomus_get_fval) ] fomus-call ;

: fomus-get-string ( key -- value )
    [ swap (fomus_get_sval) ] fomus-call ;

! _________________________________________
! primary wrapping interface: typesafe part TODO

! ________________________
! secondary infrastructure TODO

! _________________________________________
! secondary wrapping interface: unsafe part

: fomus-run-file ( path -- )
    "filename" swap fomus-set-string-setting fomus-do-run ;

: fomus-get-title ( -- title ) "title" fomus-get-string ;

: fomus-get-author ( -- author ) "author" fomus-get-string ;

: fomus-set-global-layout ( layout -- ) "layout" swap fomus-set-string-setting ;

: fomus-set-global-layout-def ( layout-def -- )
    fomus-push-strings "layout-def" fomus-set-list-setting ;

: fomus-set-global-name ( name -- ) "name" swap fomus-set-string-setting ;

: fomus-set-global-staff ( staff -- ) "staff" swap fomus-set-integer-setting ;

: fomus-set-global-staves ( staves -- ) fomus-push-integers "staff" fomus-set-list-setting ;

! ___________________________________________
! secondary wrapping interface: typesafe part TODO

! __________________
! compound interface

! FIXME the staff hint should be optional
! the staff hint, unlike voice, is local to the note,
! i.e. it does not persist (a bug in fomus?)
GENERIC: fomus-add-tenor ( staff color talea -- )

M: f fomus-add-tenor
    drop [ fomus-set-pitch fomus-set-staff fomus-add-note ] with each ;

M: number fomus-add-tenor
    dup fomus-set-dur
    '[ fomus-set-pitch fomus-set-staff fomus-add-note _ fomus-inc-time ] with each ;

! FIXME
! M: sequence fomus-add-tenor

: fomus-add-chord ( staff chord -- ) f fomus-add-tenor ; inline

: fomus-play ( path -- )
    normalize-path {
        [ ".fms" append fomus-do-save ]
        [ ".xml" append fomus-run-file ]
        [ ".ly" append fomus-run-file ]
        [ ".mid" append play ]
    } cleave ;
