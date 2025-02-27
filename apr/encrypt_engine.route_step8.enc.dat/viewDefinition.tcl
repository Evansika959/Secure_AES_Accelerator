if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name typical\
   -timing\
    [list ${::IMEX::libVar}/mmmc/typical.lib]
create_rc_corner -name typical_rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -qx_tech_file ${::IMEX::libVar}/mmmc/typical_rc_corner/cmos8rf_8LM_62_SigCmax.tch
create_delay_corner -name typical_delay_corner\
   -library_set typical\
   -rc_corner typical_rc_corner
create_constraint_mode -name my_constraint_mode\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/my_constraint_mode/my_constraint_mode.sdc]
create_analysis_view -name typical_analysis_view -constraint_mode my_constraint_mode -delay_corner typical_delay_corner -latency_file ${::IMEX::dataVar}/mmmc/views/typical_analysis_view/latency.sdc
set_analysis_view -setup [list typical_analysis_view] -hold [list typical_analysis_view]
