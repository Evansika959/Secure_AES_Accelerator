simSetSimulator "-vcssv" -exec "./verdi" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./verdi.daidir"
srcTBInvokeSim
verdiSetActWin -win $_OneSearch
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -inst "dut" -line 18 -pos 1 -win $_nTrace1
srcAction -pos 17 3 0 -win $_nTrace1 -name "dut" -ctrlKey off
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 2 -pos 1 -win $_nTrace1
srcSelect -signal "rst_n" -line 3 -pos 1 -win $_nTrace1
srcSelect -signal "start" -line 4 -pos 1 -win $_nTrace1
srcSelect -signal "set_key" -line 5 -pos 1 -win $_nTrace1
srcSelect -signal "halt" -line 6 -pos 1 -win $_nTrace1
srcSelect -signal "state" -line 7 -pos 1 -win $_nTrace1
srcSelect -signal "key" -line 8 -pos 1 -win $_nTrace1
srcSelect -signal "out" -line 9 -pos 1 -win $_nTrace1
srcSelect -signal "out_valid" -line 10 -pos 1 -win $_nTrace1
srcSelect -signal "fsm_state" -line 17 -pos 1 -win $_nTrace1
srcSelect -signal "next_fsm_state" -line 17 -pos 1 -win $_nTrace1
srcSelect -signal "stage_out_regs" -line 19 -pos 1 -win $_nTrace1
srcSelect -signal "stage_key_regs" -line 20 -pos 1 -win $_nTrace1
srcSelect -signal "stage_valid" -line 21 -pos 1 -win $_nTrace1
srcSelect -signal "stage_in_valid" -line 22 -pos 1 -win $_nTrace1
srcSelect -signal "key_reg" -line 24 -pos 1 -win $_nTrace1
srcSelect -signal "after_addroundkey" -line 27 -pos 1 -win $_nTrace1
srcSelect -signal "stage0_in" -line 27 -pos 1 -win $_nTrace1
wvCreateWindow
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave3
srcTBRunSim
verdiDockWidgetMaximize -dock windowDock_nWave_3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvSelectSignal -win $_nWave3 {( "G1" 16 )} 
wvSetCursor -win $_nWave3 27693.526458 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 36494.349192 -snap {("G1" 13)}
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvSetCursor -win $_nWave3 32413.148148 -snap {("G1" 17)}
wvSetCursor -win $_nWave3 36628.044702 -snap {("G1" 17)}
wvSetCursor -win $_nWave3 36390.585742 -snap {("G1" 17)}
wvSetCursor -win $_nWave3 21193.212251 -snap {("G1" 17)}
wvSetCursor -win $_nWave3 27723.333673
wvSetCursor -win $_nWave3 22321.142315
wvSetCursor -win $_nWave3 9498.358432
wvSetCursor -win $_nWave3 6352.027201
wvSetCursor -win $_nWave3 23627.166599
wvSetCursor -win $_nWave3 28316.981075 -snap {("G1" 18)}
wvSetCursor -win $_nWave3 28316.981075 -snap {("G1" 18)}
wvSetCursor -win $_nWave3 26536.038869
wvSetCursor -win $_nWave3 37874.704247 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 40546.117556 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 35975.032560 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 37934.068987 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 38646.445869
wvSetCursor -win $_nWave3 50578.758649 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 37755.974766 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 39715.011193 -snap {("G1" 0)}
wvSetCursor -win $_nWave3 40130.564374 -snap {("G1" 1)}
