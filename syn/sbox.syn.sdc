###################################################################

# Created by write_sdc on Mon Feb 17 14:44:04 2025

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions typical -library typical
set_wire_load_mode segmented
set_wire_load_model -name ibm13_wl10 -library typical
set_max_fanout 16 [current_design]
set_driving_cell -lib_cell INVX2TR [get_ports {a[7]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[6]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[5]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[4]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[3]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[2]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[1]}]
set_driving_cell -lib_cell INVX2TR [get_ports {a[0]}]
set_load -pin_load 0.01 [get_ports {c[7]}]
set_load -pin_load 0.01 [get_ports {c[6]}]
set_load -pin_load 0.01 [get_ports {c[5]}]
set_load -pin_load 0.01 [get_ports {c[4]}]
set_load -pin_load 0.01 [get_ports {c[3]}]
set_load -pin_load 0.01 [get_ports {c[2]}]
set_load -pin_load 0.01 [get_ports {c[1]}]
set_load -pin_load 0.01 [get_ports {c[0]}]
