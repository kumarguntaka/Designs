/**************************************************************************
***                                                                     *** 
*** EE 526 L Experiment #3          Abhiram Reddy Duvvuru, Spring, 2023 *** 
***                                                                     *** 
*** Experiment #9 sync_fifo_tb                        Group # X	        *** 
***                                                                     *** 
*************************************************************************** 
***  File: sync_fifo_tb.v   Created by Abhiram Reddy Duvvuru, 4/6/2023  ***  
***  Version                Version V0p1                                ***  
***  Status                 Untested                                    ***  
***************************************************************************/ 

`timescale 1 ns/100 ps

module sync_fifo_tb# (parameter FIFO_PTR = 4, 
                                FIFO_WIDTH = 8,
			                    FIFO_DEPTH = 16);

//----------------------------------------------------------------//
//----------------- INTERNAL PORT DECLARATION --------------------//
//----------------------------------------------------------------//

reg            			 fifo_clk,fifo_rstb;
reg            			 fifo_wren,fifo_rden;
reg     [FIFO_WIDTH-1:0] fifo_wrdata;
wire    [FIFO_WIDTH-1:0] fifo_rddata;
wire           			 fifo_full,fifo_empty;
wire    [FIFO_PTR :0] 	 fifo_room_avail,fifo_data_avail;
			   
reg     [FIFO_WIDTH-1 :0]buffer[0:10240];
integer        			 n,x,rwd;
integer       			 wr_ptr,rd_ptr;

//----------------------------------------------------------------//
//---------------------- INITIAL CONDITION -----------------------//
//----------------------------------------------------------------//

initial begin
$timeformat (-9,1,"ns",12);

fifo_clk=0;fifo_rstb=0;
fifo_wren=0;fifo_rden=0;
rwd=0;wr_ptr=0;rd_ptr=0;

repeat(5)@(posedge fifo_clk) fifo_rstb = 0;
repeat(5)@(posedge fifo_clk) fifo_rstb = 1;

if(1)
	begin
		test_sc_fifo;
	end
else
	begin
		rwd=4;
		wr_sc(256);
		rd_sc(256);
		wr_sc(256);
		rd_sc(256);
	end

$display("rd_ptr=%0d, wr_ptr=%0d delta=%0d", rd_ptr, wr_ptr, wr_ptr-rd_ptr);
$finish;
end

//----------------------------------------------------------------//
//----------------------- SC FIFO SANITY -------------------------//
//----------------------------------------------------------------//

task test_sc_fifo;
begin
$display("\n\n");
$display("*****************************************************");
$display("***************** SC FIFO Sanity Test ***************");
$display("***************************************************\n");

for(rwd=0;rwd<5;rwd=rwd+1)	// read write delay
   begin
	$display("rwd=%0d",rwd);
	
	$display("pass 0 ...");
	for(x=0;x<256;x=x+1)
	   begin
		wr_sc(1);
	   end
	$display("pass 1 ...");
	for(x=0;x<256;x=x+1)
	   begin
		rd_sc(1);
	   end
	$display("pass 2 ...");
	for(x=0;x<256;x=x+1)
	   begin
		wr_sc(1);
	   end
	$display("pass 3 ...");
	for(x=0;x<256;x=x+1)
	   begin
		rd_sc(1);
	   end
   end

$display("");
$display("*****************************************************");
$display("************** SC FIFO Sanity Test DONE *************");
$display("***************************************************\n");
end
endtask

//----------------------------------------------------------------//
//---------------------- WE & RE & CONDITION ---------------------//
//----------------------------------------------------------------//

always @(posedge fifo_clk)
	if(fifo_wren & !fifo_full)
	   begin
		buffer[wr_ptr] = fifo_wrdata;
		wr_ptr=wr_ptr+1;
	   end

always @(posedge fifo_clk)
	if(fifo_rden & !fifo_empty)
	   begin
		#3;
		if(fifo_rddata != buffer[rd_ptr])
			$display("ERROR: Data (%0d) mismatch, expected %h got %h (%t)",
			 rd_ptr, buffer[rd_ptr], fifo_rddata, $time);
		rd_ptr=rd_ptr+1;
	   end

//----------------------------------------------------------------//
//----------------------- CLOCK GENERATOR ------------------------//
//----------------------------------------------------------------//

always #5 fifo_clk = ~fifo_clk;

//----------------------------------------------------------------//
//--------------------- FIFO INSTANTIATION -----------------------//
//----------------------------------------------------------------//

sync_fifo #(4,8,16) 
DUT(
fifo_clk, fifo_rstb,
fifo_wren,
fifo_wrdata,
fifo_rden,

fifo_rddata, 
fifo_full, 
fifo_empty, 
fifo_room_avail, 
fifo_data_avail );

//----------------------------------------------------------------//
//--------------------- FIFO INSTANTIATION -----------------------//
//----------------------------------------------------------------//

task wr_sc;
input	cnt;
integer	cnt;

begin
@(posedge fifo_clk);
	for(n=0;n<cnt;n=n+1)
	   begin
		//@(posedge fifo_clk);
		#1;
		fifo_wren = 1;
		fifo_wrdata = $random;
		@(posedge fifo_clk);
		#1;
		fifo_wren = 0;
		fifo_wrdata = 8'hxx;
		repeat(rwd)@(posedge fifo_clk);
	   end
end
endtask

//----------------------------------------------------------------//
//--------------------- FIFO INSTANTIATION -----------------------//
//----------------------------------------------------------------//

task rd_sc;
input	cnt;
integer	cnt;

begin
@(posedge fifo_clk);
	for(n=0;n<cnt;n=n+1)
	   begin
		//@(posedge fifo_clk);
		#1;
		fifo_rden = 1;
		@(posedge fifo_clk);
		#1;
		fifo_rden = 0;
		repeat(rwd)@(posedge fifo_clk);
	   end
end
endtask

endmodule