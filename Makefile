STD_CELLS = /afs/umich.edu/class/eecs627/ibm13/artisan/2005q3v1/aci/sc-x/verilog/ibm13_neg.v
TESTBENCH = ../testbench/encrypt_engine_tb.sv
SIM_FILES = encryptRound.sv addRoundKey.sv sbox.sv mixColumns.sv shiftRows.sv \
			subBytes.sv subWords.sv key_expansion_stage.sv \
			inv_subBytes.sv inv_shiftRows.sv inv_mixColumns.sv inv_sbox.sv \
			sysdef.svh decryptRound.sv decryptLastRound \
			aes_engine.sv encryptLastRound.sv
# SIM_SYNTH_FILES = standard.vh ../syn/mult.syn.v

VV         = vcs
VVOPTS     = -o $@ +v2k +vc -sverilog -timescale=1ns/1ps +vcs+lic+wait +multisource_int_delays                    \
	       	+neg_tchk +incdir+$(VERIF) +plusarg_save +overlap +warn=noSDFCOM_UHICD,noSDFCOM_IWSBA,noSDFCOM_IANE,noSDFCOM_PONF -full64 -cc gcc +libext+.v+.vlib+.vh 

ifdef WAVES
VVOPTS += +define+DUMP_VCD=1 +memcbk +vcs+dumparrays +sdfverbose
endif

ifdef GUI
VVOPTS += -gui
endif

all: clean c_compile sim synth sim_synth

clean:
	rm -f verilog/ucli.key
	rm -f verilog/sim
	rm -f verilog/sim_synth
	rm -fr verilog/sim.daidir
	rm -fr verilog/sim_synth.daidir
	rm -f verilog/*.log
	rm -fr verilog/csrc
	rm -f verilog/goldenbrick.txt
	rm -f verilog/testbench.txt
	rm -f verilog/testbench_functional.txt
	rm -f verilog/testbench_structural.txt
	rm -f verilog/inter.*
	rm -f verilog/inter.fsdb.field
	rm -f verilog/novas.*
	rm -f verilog/verdi* -r
	rm -f goldenbrick/goldenbrick
	rm -f goldenbrick/goldenbrick.txt
	rm -f -r syn/dwsvf_*

sim:
	cd verilog; $(VV) $(VVOPTS) $(SIM_FILES) $(TESTBENCH); ./$@

sim_shiftrows:
	cd verilog; $(VV) $(VVOPTS) shiftRows.sv ../testbench/shiftrow_tb.sv; ./$@

sim_aesRound:
	cd verilog; $(VV) $(VVOPTS) sysdef.svh decryptRound.sv subBytes.sv shiftRows.sv mixColumns.sv sbox.sv \
	addRoundKey.sv inv_subBytes.sv inv_shiftRows.sv inv_mixColumns.sv inv_sbox.sv\
	 ../testbench/encryptRound_tb.sv; ./$@

sim_key_expansion_stage:
	cd verilog; $(VV) $(VVOPTS) key_expansion_stage.sv subWords.sv sbox.sv  ../testbench/key_expansion_stage_tb.sv; ./$@

verdi: 
	cd verilog; $(VV) $(VVOPTS) -debug_access+r -kdb $(SIM_FILES) $(TESTBENCH); ./$@ -gui=verdi -verdi_opts "-ultra"

slack:
	grep --color=auto "slack" syn/*.rpt
	# grep --color=auto "Path Group: " syn/*.rpt
.PHONY: slack

synth:
	cd syn; dc_shell -tcl_mode -xg_mode -f mult.syn.tcl | tee output.txt 

sim_synth:
	cp goldenbrick/goldenbrick.txt verilog/goldenbrick.txt
	cd verilog; $(VV) $(VVOPTS) $(STD_CELLS) $(SIM_SYNTH_FILES) $(TESTBENCH); ./$@
	diff verilog/goldenbrick.txt verilog/testbench.txt | tee verilog/diff_structural.txt
	cp verilog/testbench.txt verilog/testbench_structural.txt
