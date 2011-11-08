! Copyright (C) 2011 krzYszcz.
! See http://factorcode.org/license.txt for BSD license.

USING: accessors alien alien.c-types alien.data alien.libraries
       alien.syntax classes.struct combinators kernel system unix.types ;
IN: fomus.ffi

<<
"fomus" {
    { [ os windows? ] [ "fomus.dll" ] }
    { [ os macosx? ] [ "libfomus.dylib"  ] }
    { [ os unix?  ] [ "libfomus.so" ] }
} cond cdecl add-library
>>
LIBRARY: fomus

! ___________
! basetypes.h

TYPEDEF: void* =FOMUS=
TYPEDEF: double =fomus_float=
TYPEDEF: long =fomus_int=
TYPEDEF: int =fomus_bool=

STRUCT: =fomus_rat= { num =fomus_int= } { den =fomus_int= } ;

! __________
! fomusapi.h

! FIXME: typedef void (*fomus_output)(const char* str);
TYPEDEF: void* fomus_output

ENUM: =fomus_param=
    +fomus_par_none+
    +fomus_par_entry+
    +fomus_par_list+
    +fomus_par_setting+
    +fomus_par_settingval+
    +fomus_par_locfile+
    +fomus_par_locline+
    +fomus_par_loccol+

    +fomus_par_import+
    +fomus_par_import_settingval+

    +fomus_par_export+
    +fomus_par_export_settingval+

    +fomus_par_clef+
    +fomus_par_clef_settingval+

    +fomus_par_staff+
    +fomus_par_staff_clefs+
    +fomus_par_staff_settingval+

    +fomus_par_percinst+
    +fomus_par_percinst_template+
    +fomus_par_percinst_id+
    +fomus_par_percinst_imports+
    +fomus_par_percinst_export+
    +fomus_par_percinst_settingval+

    +fomus_par_inst+
    +fomus_par_inst_template+
    +fomus_par_inst_id+
    +fomus_par_inst_staves+
    +fomus_par_inst_imports+
    +fomus_par_inst_export+
    +fomus_par_inst_percinsts+
    +fomus_par_inst_settingval+

    +fomus_par_part+
    +fomus_par_part_id+
    +fomus_par_part_inst+
    +fomus_par_part_settingval+

    +fomus_par_partmap+
    +fomus_par_partmap_part+
    +fomus_par_partmap_metapart+
    +fomus_par_partmap_settingval+

    +fomus_par_metapart+
    +fomus_par_metapart_id+
    +fomus_par_metapart_partmaps+
    +fomus_par_metapart_settingval+

    +fomus_par_measdef+
    +fomus_par_measdef_id+
    +fomus_par_measdef_settingval+

    +fomus_par_list_percinsts+
    +fomus_par_list_insts+
    +fomus_par_settingval_percinsts+
    +fomus_par_settingval_insts+

    +fomus_par_region+
    +fomus_par_region_voice+
    +fomus_par_region_voicelist+
    +fomus_par_region_time+
    +fomus_par_region_gracetime+
    +fomus_par_region_duration+
    +fomus_par_region_pitch+
    +fomus_par_region_dynlevel+
    +fomus_par_region_mark+
    +fomus_par_region_settingval+

    +fomus_par_time+
    +fomus_par_gracetime+
    +fomus_par_duration+
    +fomus_par_pitch+
    +fomus_par_dynlevel+
    +fomus_par_voice+

    +fomus_par_note_settingval+

    +fomus_par_meas+
    +fomus_par_meas_measdef+

    +fomus_par_markid+
    +fomus_par_markval+
    +fomus_par_mark+

    +fomus_par_noteevent+
    +fomus_par_restevent+
    +fomus_par_markevent+
    +fomus_par_measevent+

    +fomus_par_events+

    +fomus_par_n+ ;

ENUM: =fomus_action=
    +fomus_act_none+

    +fomus_act_set+

    +fomus_act_inc+
    +fomus_act_dec+
    +fomus_act_mult+
    +fomus_act_div+

    +fomus_act_start+
    +fomus_act_append+
    +fomus_act_add+
    +fomus_act_remove+
    +fomus_act_end+
    +fomus_act_clear+

    +fomus_act_queue+
    +fomus_act_cancel+
    +fomus_act_resume+

    +fomus_act_n+ ;

FUNCTION-ALIAS: (fomus_api_version)
int fomus_api_version ( ) ;

FUNCTION-ALIAS: (fomus_version)
c-string fomus_version ( ) ;

FUNCTION-ALIAS: (fomus_err)
int fomus_err ( ) ;

FUNCTION-ALIAS: (fomus_set_outputs)
void fomus_set_outputs ( fomus_output out, fomus_output err, int newline ) ;

FUNCTION-ALIAS: (fomus_init)
void fomus_init ( ) ;

FUNCTION-ALIAS: (fomus_flush)
void fomus_flush ( ) ;

FUNCTION-ALIAS: (fomus_new)
=FOMUS= fomus_new ( ) ;

FUNCTION-ALIAS: (fomus_free)
void fomus_free ( =FOMUS= f ) ;

FUNCTION-ALIAS: (fomus_rt)
void fomus_rt ( int on ) ;

FUNCTION-ALIAS: (fomus_run)
void fomus_run ( =FOMUS= f ) ;

FUNCTION-ALIAS: (fomus_save)
void fomus_save ( =FOMUS= f, c-string path ) ;

FUNCTION-ALIAS: (fomus_load)
void fomus_load ( =FOMUS= f, c-string path ) ;

FUNCTION-ALIAS: (fomus_parse)
void fomus_parse ( =FOMUS= f, c-string input ) ;

FUNCTION-ALIAS: (fomus_copy)
=FOMUS= fomus_copy ( =FOMUS= f ) ;

FUNCTION-ALIAS: (fomus_clear)
void fomus_clear ( =FOMUS= f ) ;

FUNCTION-ALIAS: (fomus_merge)
void fomus_merge ( =FOMUS= to, =FOMUS= from ) ;

FUNCTION-ALIAS: (fomus_ival)
void fomus_ival ( =FOMUS= f, =fomus_param= par, =fomus_action= act, =fomus_int= val ) ;

FUNCTION-ALIAS: (fomus_rval)
void fomus_rval ( =FOMUS= f, =fomus_param= par, =fomus_action= act, =fomus_int= num, =fomus_int= den ) ;

FUNCTION-ALIAS: (fomus_mval)
void fomus_mval ( =FOMUS= f, =fomus_param= par, =fomus_action= act, =fomus_int= val, =fomus_int= num, =fomus_int= den ) ;

FUNCTION-ALIAS: (fomus_fval)
void fomus_fval ( =FOMUS= f, =fomus_param= par, =fomus_action= act, =fomus_float= val ) ;

FUNCTION-ALIAS: (fomus_sval)
void fomus_sval ( =FOMUS= f, =fomus_param= par, =fomus_action= act, c-string str ) ;

FUNCTION-ALIAS: (fomus_act)
void fomus_act ( =FOMUS= f, =fomus_param= par, =fomus_action= act ) ;

! ______
! api.cc

FUNCTION-ALIAS: (fomus_get_ival)
=fomus_int= fomus_get_ival ( =FOMUS= f, c-string key ) ;

FUNCTION-ALIAS: (fomus_get_rval)
=fomus_rat= fomus_get_rval ( =FOMUS= f, c-string key ) ;

FUNCTION-ALIAS: (fomus_get_fval)
=fomus_float= fomus_get_fval ( =FOMUS= f, c-string key ) ;

FUNCTION-ALIAS: (fomus_get_sval)
c-string fomus_get_sval ( =FOMUS= f, c-string key ) ;

! ________
! module.h
! FIXME just for reference, currently, later move to fomus.module.ffi

TYPEDEF: void* module_obj
TYPEDEF: void* module_noteobj

FUNCTION-ALIAS: (module_settingid)
int module_settingid ( c-string key ) ;

FUNCTION-ALIAS: (module_setting_ival)
=fomus_int= module_setting_ival ( module_obj f, int id ) ;

FUNCTION-ALIAS: (module_pitch)
=fomus_rat= module_pitch ( module_noteobj note ) ;
