//`include "sv_assert.sv"

module async_fifo	#(parameter	ADDR = 4,
								WIDTH = 32)

///*************************Inputs and Outputs*********************///

					(input wrclk, rst_wrclk, write_en, snap_wraddr, 
					 input roll_wraddr, rst_waddr, rdclk, rst_rdclk, 
					 input read_en, snap_rdaddr, roll_rdaddr, rst_rdaddr,
					input	[WIDTH-1:0] write_data,
					output	[WIDTH-1:0] read_data,
					output reg fifo_full, fifo_empty, 
					output reg [ADDR:0] room_avail, data_avail);
					
///*************************LOCAL_PARAMETERS***********************///

localparam DEPTH = (1<<ADDR);

///*******************Wires and Registers**************************///

reg [ADDR:0] write_wrap_addr, nxt_write_wrap_addr, write_addr_snap_vlaue, 
			 rd_addr_wrap, nxt_rd_addr_wrap, rd_addr_snap_value;
wire [ADDR-1:0] wr_addr, rd_addr;
wire [ADDR:0] nxt_room_avail, nxt_write_addr_snap_value, 
			  nxt_read_addr_snap_value, data_avail_nxt;
wire nxt_fifo_full, nxt_fifo_empty;


///*************************write address**************************///


always @(*)
	begin 
		nxt_write_wrap_addr = write_wrap_addr;
		if(rst_waddr)
			nxt_write_wrap_addr = 'd0;
		else if(roll_wraddr)
			nxt_write_wrap_addr = write_addr_snap_vlaue;
		else if(write_en && (write_wrap_addr == (2*DEPTH)-1))
			write_wrap_addr = 'd0;
		else if (write_en)
			nxt_write_wrap_addr = write_wrap_addr+1;
	end
	
	
///*********************write address to reload********************///


assign nxt_write_addr_snap_value = snap_wraddr ? write_wrap_addr : write_addr_snap_vlaue;

always @(posedge wrclk or negedge rst_wrclk)
	begin
		if(rst_wrclk)
			begin
				write_wrap_addr <= 'd0;
				write_addr_snap_vlaue <= 'd0;
			end
		else
			begin
				write_wrap_addr <= nxt_write_wrap_addr;
				write_addr_snap_vlaue <= nxt_write_addr_snap_value;
			end
	end
	
	
///****************Write address Binary to Gray********************///


reg [ADDR:0] write_addr_wrap_gray;
wire [ADDR:0] nxt_write_addr_wrap_gray;

binary_to_gray #(.PTR (ADDR)) binary_to_gray_wr
				(.binary_value(nxt_write_wrap_addr), 
				 .gray_value (nxt_write_addr_wrap_gray));
				 
always @(posedge wrclk or negedge rst_wrclk)
	begin
		if(!rst_wrclk)
			write_addr_wrap_gray <= 'd0;
		else
			write_addr_wrap_gray <= nxt_write_addr_wrap_gray;
end
	
	
///*************synchronize_write_address_wrap_gray****************///


reg [ADDR:0] write_addr_wrap_gray_sync1;
reg [ADDR:0] write_addr_wrap_gray_sync2;

always @(posedge rdclk or negedge rst_rdclk)
	begin
		if(!rst_rdclk)
			begin
				write_addr_wrap_gray_sync1 <= 0;
				write_addr_wrap_gray_sync2 <= 0;
			end
		else 
			begin
				write_addr_wrap_gray_sync1 <= write_addr_wrap_gray;
				write_addr_wrap_gray_sync2 <= write_addr_wrap_gray_sync1;
			end
	end
	
	
///*******write address wrap gray sync2 from gray to binary********///


reg [ADDR:0] write_addr_wrap_rd_clk;
wire [ADDR:0] nxt_write_addr_wrap_rdclk;

gray_to_binary #(.PTR (ADDR)) gray_to_binary_wr 
				(.gray_value (write_addr_wrap_gray_sync2),
				.binary_value (nxt_write_addr_wrap_rdclk));
			
always @(posedge rdclk or negedge rst_rdclk)
	begin
		if(!rst_rdclk)
			write_addr_wrap_rd_clk <= 'd0;
		else
			write_addr_wrap_rd_clk <= nxt_write_addr_wrap_rdclk;
	end


///*************************read address***************************///


always @(*)
	begin 
		nxt_rd_addr_wrap = rd_addr_wrap;
		
		if(rst_rdaddr)
			nxt_rd_addr_wrap = 'd0;
		else if(roll_rdaddr)
			nxt_rd_addr_wrap = rd_addr_snap_value;
		else if(read_en && (rd_addr_wrap == (2*DEPTH)-1))
			rd_addr_wrap = 'd0;
		else if (read_en)
			nxt_rd_addr_wrap = rd_addr_wrap+1;
	end
	

///*********************read address to reload*********************///


assign nxt_read_addr_snap_value = snap_rdaddr ? rd_addr_wrap : rd_addr_snap_value;

always @(posedge rdclk or negedge rst_rdclk)
	begin
		if(rst_rdclk)
			begin
				rd_addr_wrap <= 'd0;
				rd_addr_snap_value <= 'd0;
			end
		else
			begin
				rd_addr_wrap <= nxt_rd_addr_wrap;
				rd_addr_snap_value <= nxt_read_addr_snap_value;
			end
	end
	
	
///*****************read address Binary to Gray********************///


reg [ADDR:0] rd_addr_wrap_gray;
wire [ADDR:0] nxt_rd_addr_wrap_gray;

binary_to_gray #(.PTR (ADDR)) binary_to_gray_rd
				(.binary_value(nxt_rd_addr_wrap),
				 .gray_value (nxt_rd_addr_wrap_gray));
				 
always @(posedge rdclk or negedge rst_rdclk)
	begin
		if(!rst_rdclk)
			rd_addr_wrap_gray <= 'd0;
		else
			rd_addr_wrap_gray <= nxt_rd_addr_wrap_gray;
	end


///**************synchronize_read_address_wrap_gray****************///


reg [ADDR:0] rd_addr_wrap_gray_sync1;
reg [ADDR:0] rd_addr_wrap_gray_sync2;

always @(posedge wrclk or negedge rst_wrclk)
	begin
		if(!rst_wrclk)
			begin
				rd_addr_wrap_gray_sync1 <= 0;
				rd_addr_wrap_gray_sync2 <= 0;
			end
		else 
			begin
				rd_addr_wrap_gray_sync1 <= rd_addr_wrap_gray;
				rd_addr_wrap_gray_sync2 <= rd_addr_wrap_gray_sync1;
			end
	end


///**********************gray to binary****************************///


reg [ADDR:0] rd_addr_wrap_wrclk;
wire [ADDR:0] nxt_rd_addr_wrap_wrclk;

gray_to_binary #(.PTR(ADDR)) gray_to_binary_rd
				(.gray_value (rd_addr_wrap_gray_sync2),
				.binary_value (nxt_rd_addr_wrap_wrclk));

always @(posedge wrclk or negedge rst_wrclk)
	begin
		if(!rst_wrclk)
			rd_addr_wrap_wrclk <= 'd0;
		else
			rd_addr_wrap_wrclk <= nxt_rd_addr_wrap_wrclk;
	end
	
assign wr_ptr = write_wrap_addr[ADDR-1:0];
assign rd_addr = rd_addr_wrap[ADDR-1:0];


///*********************SRAM memory instantiation******************///


sram #(.ADDR(ADDR), .WIDTH(WIDTH)) sram_0
	   (.wrclk(wrclk), .wren(write_en), .wr_addr(wr_addr), .write_data(write_data),
		.rdclk(rdclk), .read_en(read_en), .rd_addr(rd_addr), .read_data(read_data));
		
		
///*****************Generate FIFO_Full*****************************///

assign	fifo_full_nxt = (nxt_write_wrap_addr[ADDR] != 
	nxt_rd_addr_wrap_wrclk[ADDR] && nxt_write_wrap_addr[ADDR-1:0] == 
	nxt_rd_addr_wrap_wrclk[ADDR-1:0]);
		 
assign	room_avail_nxt = (write_wrap_addr[ADDR] == rd_addr_wrap_wrclk[ADDR]) 
	? (ADDR - (write_wrap_addr[ADDR-1:0] - rd_addr_wrap_wrclk[ADDR-1:0])): 
	(rd_addr_wrap_wrclk[ADDR-1:0] - write_wrap_addr[ADDR-1:0]);
		
		
///***************Generate FIFO_Empty******************************///


assign	fifo_empty_nxt = (nxt_write_wrap_addr[ADDR:0] == 
	nxt_write_addr_wrap_rdclk[ADDR:0]);
		
		
assign data_avail_nxt = (rd_addr_wrap[ADDR] == write_addr_wrap_rd_clk[ADDR])? 
	(write_addr_wrap_rd_clk[ADDR-1:0] - rd_addr_wrap[ADDR-1:0]):
	(ADDR - (rd_addr_wrap[ADDR-1:0] - write_addr_wrap_rd_clk [ADDR-1:0]));
		

always @(posedge wrclk or negedge rst_wrclk)
	begin
		if(!rst_wrclk)
			begin
				fifo_full <= 1'b0;
				room_avail<=  'd0;
			end
		else
			begin
				fifo_full <= fifo_full_nxt;
				room_avail<= room_avail_nxt;
			end
	end
	
	
always @(posedge rdclk or negedge rst_rdclk)
	begin
		if(!rst_rdclk)
			begin
				fifo_empty <= 1'b1;
				data_avail <=  'd0;
			end
		else
			begin
				fifo_empty <= fifo_empty_nxt;
				data_avail <= data_avail_nxt;
			end
	end
	
endmodule