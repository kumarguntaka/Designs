.PHONY: all sim synth clean

SHELL := /bin/bash -o pipefail

DUT ?= StreamingHistogram.v
SYNTH_TIMEOUT ?= 60
XILINX_CELLS_URL ?= https://github.com/Xilinx/XilinxUnisimLibrary.git
XILINX_CELLS_DIR ?= XilinxUnisimLibrary/verilog/src
IVERILOG ?= /usr/bin/iverilog
YOSYS ?= /usr/bin/yosys

all: sim synth gatesim

sim: StreamingHistogram-sim
	./$< +VCDFILE=sim.vcd +VCDLEVEL=0 | tee sim.log

StreamingHistogram-sim: StreamingHistogram_tb.v ${DUT} | ${XILINX_CELLS_DIR}
	${IVERILOG} -g2005-sv -s StreamingHistogramTB -y ${XILINX_CELLS_DIR} -o $@ $^

synth: StreamingHistogram.netlist.v

StreamingHistogram.netlist.v: ${DUT}
	timeout ${SYNTH_TIMEOUT} ${YOSYS} -p 'synth_xilinx -top StreamingHistogram' -p stat $< -L synth.log -o $@

${XILINX_CELLS_DIR}:
	git clone ${XILINX_CELLS_URL}

gatesim: ./StreamingHistogram-gatesim
	./$< +VCDFILE=gatesim.vcd +VCDLEVEL=1 | tee gatesim.log

StreamingHistogram-gatesim: StreamingHistogram_tb.v StreamingHistogram.netlist.v | ${XILINX_CELLS_DIR}
	${IVERILOG} -g2005-sv -s StreamingHistogramTB -DGATESIM -y ${XILINX_CELLS_DIR} -y ${XILINX_CELLS_DIR}/unisims -o $@ $^

clean:
	$(RM) StreamingHistogram-sim sim.log sim.vcd
	$(RM) StreamingHistogram-gatesim gatesim.log gatesim.vcd
	$(RM) StreamingHistogram.netlist.v synth.log
	$(RM) -r XilinxUnisimLibrary
