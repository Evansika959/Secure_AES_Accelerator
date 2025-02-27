###################################################################

# Created by write_sdc on Sun Feb  9 20:13:38 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions typical -library typical
set_wire_load_mode segmented
set_wire_load_model -name ibm13_wl10 -library typical
set_max_fanout 16 [current_design]
set_driving_cell -lib_cell INVX2TR [get_ports {text[7]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[6]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[5]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[4]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[3]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[2]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[1]}]
set_driving_cell -lib_cell INVX2TR [get_ports {text[0]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[7]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[6]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[5]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[4]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[3]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[2]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[1]}]
set_driving_cell -lib_cell INVX2TR [get_ports {key[0]}]
set_load -pin_load 0.01 [get_ports {out0[7]}]
set_load -pin_load 0.01 [get_ports {out0[6]}]
set_load -pin_load 0.01 [get_ports {out0[5]}]
set_load -pin_load 0.01 [get_ports {out0[4]}]
set_load -pin_load 0.01 [get_ports {out0[3]}]
set_load -pin_load 0.01 [get_ports {out0[2]}]
set_load -pin_load 0.01 [get_ports {out0[1]}]
set_load -pin_load 0.01 [get_ports {out0[0]}]
