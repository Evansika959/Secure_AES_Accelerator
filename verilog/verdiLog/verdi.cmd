simSetSimulator "-vcssv" -exec "./verdi" -args " " -uvmDebug on
debImport "-i" "-simflow" "-dbdir" "./verdi.daidir"
srcTBInvokeSim
verdiSetActWin -win $_OneSearch
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
srcSelect -inst "dut" -line 18 -pos 1 -win $_nTrace1
srcAction -pos 17 3 1 -win $_nTrace1 -name "dut" -ctrlKey off
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
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvSetCursor -win $_nWave3 21660.483695 -snap {("G1" 10)}
wvSetCursor -win $_nWave3 52538.194495 -snap {("G1" 13)}
wvSetCursor -win $_nWave3 34103.740286 -snap {("G1" 13)}
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomOut -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvZoomIn -win $_nWave3
wvSetCursor -win $_nWave3 39639.533166 -snap {("G1" 12)}
wvSetCursor -win $_nWave3 48627.566849 -snap {("G1" 12)}
debExit
