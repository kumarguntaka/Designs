/**************************************************************************
***                                                                     *** 
*** EE 526 L Experiment #3          Abhiram Reddy Duvvuru, Spring, 2023 *** 
***                                                                     *** 
*** Experiment #9 sync_fifo                           Group # X	        *** 
***                                                                     *** 
*************************************************************************** 
***  Filename: sync_fifo.v  Created by Abhiram Reddy Duvvuru, 2/27/2023 ***  
***  Version                Version V0p1                                ***  
***  Status                 Untested                                    ***  
***************************************************************************/ 

`timescale 1 ns/100 ps 

module sram#(parameter FIFO_PTR = 4, 
                       FIFO_WIDTH = 8,
			           FIFO_DEPTH = 16)
(fifo_wrdata,
fifo_rddata,
rd_ptr, 
wr_ptr, 
fifo_rstb, 
fifo_wren, 
fifo_rden, 
fifo_clk);

//****************************************************************//
//********************* PORT DECLARATION *************************//
//****************************************************************//

output reg [FIFO_WIDTH-1:0]  fifo_rddata;
input  	   [FIFO_WIDTH-1:0]  fifo_wrdata;
input  	   [FIFO_PTR-1:0]    rd_ptr, wr_ptr;
input                        fifo_rstb, fifo_wren, fifo_rden, fifo_clk;

//****************************************************************//
//************** INTERNAL SIGNAL DECLARATION *********************//
//****************************************************************//

reg [FIFO_WIDTH-1:0] SRAM [FIFO_DEPTH-1:0];

//****************************************************************//
//*************************** SRAM LOGIC *************************//
//****************************************************************//

always@(posedge fifo_clk)
begin
	if(fifo_rstb == 1'b1) 
		begin
			if(fifo_wren == 1'b1 && fifo_rden == 1'b0) 
				begin
					SRAM [wr_ptr] = fifo_wrdata;
				end
			else if(fifo_rden == 1'b1 && fifo_wren == 1'b0) 
				begin
					fifo_rddata = SRAM [rd_ptr]; 
				end
		end
end

endmodule