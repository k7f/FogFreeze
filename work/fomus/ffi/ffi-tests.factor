! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: alien.enums fomus.ffi sequences tools.test ;
IN: fomus.ffi.tests

[ { 0 1 2 3 4 5 6 7 19 25 31 33 47 49 60 67 69 71 72 77 } ] [
    {
        fomus_par_none
        fomus_par_entry
        fomus_par_list
        fomus_par_setting
        fomus_par_settingval
        fomus_par_locfile
        fomus_par_locline
        fomus_par_loccol
        fomus_par_percinst_id
        fomus_par_inst_id
        fomus_par_part
        fomus_par_part_inst
        fomus_par_list_insts
        fomus_par_settingval_insts
        fomus_par_time
        fomus_par_meas
        fomus_par_markid
        fomus_par_mark
        fomus_par_noteevent
        fomus_par_n
    } [ enum>number ] map
] unit-test

[ { 0 6 8 10 15 } ] [
    {
        fomus_act_none
        fomus_act_start
        fomus_act_add
        fomus_act_end
        fomus_act_n
    } [ enum>number ] map
] unit-test
