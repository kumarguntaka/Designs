`timescale 1ns/1ps
module sync_fifo_tb();

parameter fifo_ptr =4;
parameter fifo_data=32;
parameter fifo_depth=16;

reg clk, rstb, wren, ren;
reg [fifo_data-1:0] write_data; 
wire [fifo_data-1:0] read_data;
wire fifo_full, fifo_empty;
wire [fifo_ptr:0] room_avail, data_avail;
integer i,j;

sync_fifo Dut (.clk(clk), .rstb(rstb), .wren(wren), .ren(ren),
.write_data(write_data), .read_data(read_data), .fifo_full(fifo_full),
.fifo_empty(fifo_empty), .room_avail(room_avail), .data_avail(data_avail));


always #5 clk=~clk;

initial
begin
clk = 0;
rstb = 0;
#50;
rstb=1;
wren=1;
ren =0;
for (i=0; i<=fifo_depth-1; i=i+1)
begin
write_data= 'ha34d;
#50;
end
wren =0;
ren = 1;
#800;
wren=1;
#50 ren=1;
for (j=0; j<=fifo_depth-1; j=j+1)
begin
write_data = 'h9c7b;
#50;
end
end

initial
begin
$monitor("clk=%b, rstb=%b, wren=%b, ren=%b, write_address=%d, write_data=%4h, read_address=%d, read_data=4%h, fifo_full=%b, fifo_empty=%b, room_avail=%d, data_avail=%d", clk, rstb, wren, ren, Dut.write_ptr, write_data, Dut.read_ptr, read_data, fifo_full, fifo_empty, room_avail, data_avail);
#2500;
$finish;
end

endmodule