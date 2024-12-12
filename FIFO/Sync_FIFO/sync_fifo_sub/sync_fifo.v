/**************************************************************************
***                                                                     *** 
*** EE 526L Project                 Easwarao Guntupalli  , Spring, 2023 *** 
***                                                                     *** 
*** Project    sync_fifo                           Group # X	        *** 
***                                                                     *** 
*************************************************************************** 
***  Filename: sync_fifo.v  Created by Easwarao Guntupalli, 2/27/2023 ***  
***  Version                Version V0p1                                ***  
***  Status                   tested                                    ***  
***************************************************************************/ 

`timescale 1 ns/100 ps 

module sync_fifo #(parameter FIFO_PTR = 4, 
                             FIFO_WIDTH = 8, 
							 FIFO_DEPTH = 32)
(fifo_clk, fifo_rstb,
fifo_wren,
fifo_wrdata,
fifo_rden,

fifo_rddata, 
fifo_full, 
fifo_empty, 
fifo_room_avail, 
fifo_data_avail );

//****************************************************************//
//********************* PORT DECLARATION *************************//
//****************************************************************//

output [FIFO_WIDTH-1:0] fifo_rddata;
output                  fifo_full, fifo_empty;
output [FIFO_PTR:0]     fifo_room_avail, fifo_data_avail;
input  [FIFO_WIDTH-1:0] fifo_wrdata;
input                   fifo_clk, fifo_rstb;
input                   fifo_wren, fifo_rden;

//****************************************************************//
//*************** LOCAL PARAMETER DECLARATION ********************//
//****************************************************************//

localparam FIFO_DEPTH_MINUS1 = FIFO_DEPTH - 1;

//****************************************************************//
//************** INTERNAL SIGNAL DECLARATION *********************//
//****************************************************************//

reg  [FIFO_PTR-1:0] wr_ptr, wr_ptr_nxt;
reg  [FIFO_PTR-1:0] rd_ptr, rd_ptr_nxt;
reg                 fifo_full, fifo_empty;
wire                fifo_full_nxt, fifo_empty_nxt;  // why wire, figure it out??
reg  [FIFO_PTR:0]   num_entries, num_entries_nxt;
reg  [FIFO_PTR:0]   fifo_room_avail;
wire [FIFO_PTR:0]   fifo_room_avail_nxt;
wire [FIFO_PTR:0]   fifo_data_avail;

//****************************************************************//
//****************** WRITE POINTER LOGIC *************************//
//****************************************************************//

always@(*)      //Try without braces of wild card
begin
	wr_ptr_nxt = wr_ptr;
if(fifo_wren)
	begin
		if(wr_ptr == FIFO_DEPTH_MINUS1)
			wr_ptr_nxt = 'd0;
		else
			wr_ptr_nxt = wr_ptr+1'b1;
	end
end

//****************************************************************//
//******************* READ POINTER LOGIC *************************//
//****************************************************************//

always@(*)      //Try without braces of wild card
begin
	rd_ptr_nxt = rd_ptr;
if(fifo_rden)
	begin
		if(rd_ptr == FIFO_DEPTH_MINUS1)
			rd_ptr_nxt = 'd0;
		else
			rd_ptr_nxt = rd_ptr+1'b1;
	end
end

//****************************************************************//
//******* CALCULATE NUMBER OF ENTRIES & ASSIGN VARIABLES *********//
//****************************************************************//

always@(*)      //Try without braces of wild card
begin
	num_entries_nxt = num_entries;
	
	if(fifo_wren&&fifo_rden)
		num_entries_nxt = num_entries;
	else if(fifo_wren)
		num_entries_nxt = num_entries + 1'b1;
	else if(fifo_rden)
		num_entries_nxt = num_entries - 1'b1;

end

assign fifo_full_nxt       = (num_entries_nxt == FIFO_DEPTH);
assign fifo_empty_nxt      = (num_entries_nxt == 'd0);
assign fifo_data_avail     = num_entries;
assign fifo_room_avail_nxt = (FIFO_DEPTH - num_entries_nxt);

//****************************************************************//
//*************************** FIFO LOGIC *************************//
//****************************************************************//

always@(posedge fifo_clk or negedge fifo_rstb)
begin
if(!fifo_rstb)
	begin
		wr_ptr          <= 'd0;
		rd_ptr          <= 'd0;
		num_entries     <= 'd0;
		fifo_full       <= 1'b0;
		fifo_empty      <= 1'b1;
		fifo_room_avail <= FIFO_DEPTH;
	end
else
	begin
		wr_ptr          <= wr_ptr_nxt;
		rd_ptr          <= rd_ptr_nxt;
		num_entries     <= num_entries_nxt;
		fifo_full       <= fifo_full_nxt;
		fifo_empty      <= fifo_empty_nxt;
		fifo_room_avail <= fifo_room_avail_nxt;
	end
end

//****************************************************************//
//********************** SRAM INSTANTIATION **********************//
//****************************************************************//

sram#(4, 8, 16) sram1
(.fifo_wrdata(fifo_wrdata),
.fifo_rddata(fifo_rddata),
.rd_ptr(rd_ptr), 
.wr_ptr(wr_ptr), 
.fifo_rstb(fifo_rstb), 
.fifo_wren(fifo_wren), 
.fifo_rden(fifo_rden), 
.fifo_clk(fifo_clk));

endmodule