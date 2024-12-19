/**************************************************************************
***                                                                     *** 
***         Kumar Sai Reddy, Spring, 2024									*** 
***                                                                     *** 
*************************************************************************** 
***  Filename: design.sv    Created by Kumar Sai Reddy,           ***  
***  Version                Version V0p1                                ***  
***  Status                 Tested                                      ***  
***************************************************************************/

module pio_regs
	import pio_reg_pkg::*;
#( 
	parameter logic [] //Abhi
) (
	//Global Signals
	input clk,
	input reset,
	//Select and RW Enable Signals
	input sel,
	input RW,
	//Input Address/Offset
	input [ADDR_WIDTH-1:0] addr,
	//Input Write Data 
	input [DATA_WIDTH-1:0] wdata,
	//Output Read Data
	output logic [DATA_WIDTH-1:0] rdata,
	//Output Flag Busy
	output logic busy
);



endmodule: pio_regs