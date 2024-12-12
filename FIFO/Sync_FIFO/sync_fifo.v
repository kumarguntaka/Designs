`timescale 1ns/1ps
module sync_fifo#(parameter fifo_ptr = 4,
fifo_data = 32,
fifo_depth = 16) (input clk, rstb, wren, ren,
input [fifo_data-1:0] write_data,
output [(fifo_data)-1:0] read_data,
output fifo_full, fifo_empty,
output [fifo_ptr:0] room_avail, data_avail);


reg [fifo_ptr:0] no_of_entries;
reg [fifo_ptr-1:0] write_ptr, read_ptr;


sram #(.fifo_ptr(fifo_ptr),.fifo_data(fifo_data),
.fifo_depth(fifo_depth)) sram_1(.clk(clk),
.rstb(rstb),
.write_enable(wren),
.read_enable(ren),
.write_ptr(write_ptr),
.read_ptr(read_ptr),
.write_data(write_data),
.read_data(read_data));

// write pointer 

always @(posedge clk or negedge rstb)
begin 
	if (!rstb)
		write_ptr <= 'd0;
		else if(wren)
			begin
				if(write_ptr==fifo_depth-1)
					write_ptr <= 'd0;
				else
				write_ptr <= write_ptr+1'b1;
			end
end

//read Pointer

always @(posedge clk or negedge rstb)
begin 
	if (!rstb)
		read_ptr <= 'd0;
		else if(ren)
			begin
				if(read_ptr==fifo_depth-1)
					read_ptr <= 'd0;
				else
				read_ptr <= read_ptr+1'b1;
			end
end

// number of entries

always @(posedge clk)
begin
	no_of_entries <= 'd0;
	if(wren&&ren)
		no_of_entries <= no_of_entries;
	else if(wren)
		no_of_entries <= no_of_entries+1'b1;
	else 
		no_of_entries <= no_of_entries-1'b1;
end

assign fifo_full = (no_of_entries==fifo_depth);
assign fifo_empty = (no_of_entries=='d0);
assign data_avail = no_of_entries;
assign room_avail = (fifo_depth - no_of_entries);

endmodule


//SRAM memory module

module sram #(parameter fifo_ptr = 4,
fifo_data = 32,
fifo_depth =16) (input clk, rstb, 
input [fifo_ptr-1:0] write_ptr,
input [fifo_ptr-1:0] read_ptr,
input [fifo_data-1:0] write_data,
output reg [fifo_data-1:0] read_data, 
input write_enable, input read_enable);

//reg [width-1:0] tmp_data;
reg [fifo_data-1:0] mem [fifo_ptr-1:0];

always @(posedge clk or negedge rstb)
begin
	if(!rstb)
		mem[write_ptr] <= 32'b0;
	else if(write_enable)
		mem[write_ptr] <= write_data;
end

always @(posedge clk or negedge rstb)
begin
	if(!rstb)
		read_data <= 32'bz;
	else if(read_enable)
		read_data <= mem[read_ptr];
end

endmodule