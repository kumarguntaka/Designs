`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dummy.sv"
`include "intf.sv";
`include "seq_item.sv";
`include "sequence_item_add.sv";
`include "sequencer.sv";
`include "driver.sv";
`include "monitor.sv";
`include "agent.sv";
`include "scoreboard.sv";
`include "env.sv";
`include "test.sv";

module alu_tb;


intf vif();

//FP_ALU dut(vif.clk, vif.rst,vif.a,vif.b,vif.op,vif.pushin, vif.stopin,vif.z, vif.pushout,vif.stopout);
dummy dut(vif.clk, vif.rst,vif.A,vif.B,vif.op,vif.pushin, vif.stopin,vif.sum, vif.pushout,vif.stopout);

initial begin
	uvm_config_db#(virtual intf)::set(null, "*", "vif", vif);
	run_test("our_test");
end
  
initial begin
	vif.clk=0;  
end

always begin
	#5 vif.clk=~vif.clk;
end

endmodule