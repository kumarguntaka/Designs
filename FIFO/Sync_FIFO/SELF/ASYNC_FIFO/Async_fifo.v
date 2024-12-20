module Async_fifo #(parameter PTR = 4,
							WIDTH = 32,
							DEPTH = 16)
	(input wrclk, wr_rstn,
			write_en, 
	input [WIDTH-1:0]write_data,
		  snapshot_wrptr, rollback_wrptr,
		  reset_wrptr,
	input rdclk, rd_rstn,
		read_en, sanpshot_rdptr, 
		rollback_rdptr, reset_rdptr,
	output [WIDTH-1:0]read_data, 
	output reg fifo_full, fifo_empty);

reg [PTR:0] wrptr_wrap, wrptr_wrap_temp;
reg [PTR:0] wrptr_snapshot;
wire [PTR:0] wrptr_snapshot_temp;
wire [PTR-1:0] wr_ptr;

wire fifo_full_next;

reg [PTR:0] rdptr_wrap, rdptr_wrap_temp;
reg [PTR:0] rdptr_snapshot;
wire [PTR:0] rdptr_snapshot_temp;
wire [PTR-1:0] rd_ptr;

wire fifo_empty_next;

// write pointer control logic
always@(*) begin
		
	wrptr_wrap_temp = wrptr_wrap;
	
	if(reset_wrptr)
		wrptr_wrap_temp = 'd0;
	else if(rollback_wrptr)
		wrptr_wrap_temp = wrptr_snapshot_temp;
	else if(write_en&&(wrptr_wrap==DEPTH-1))
		wrptr_wrap_temp = 'd0;
	else if(write_en)
		wrptr_wrap_temp = wrptr_wrap + 1;
end
	
//write pointer snapshort used to reload later
assign wrptr_snapshot_temp = snapshot_wrptr? 
		wrptr_wrap : wrptr_snapshot_temp;

always@(posedge wrclk or negedge wr_rstn) begin
	if(!wr_rstn) begin
		wrptr_wrap <= 'd0;
		wrptr_snapshot <= 'd0;
	end
	else begin
		wrptr_wrap <= wrptr_wrap_temp;
		wrptr_snapshot <= wrptr_snapshot_temp;
	end
end

//Binary to gray convertion
reg [PTR:0]wrptr_wrap_gray;
wire [PTR:0]wrptr_wrap_gray_temp;

binary_to_gray #(.PTR(PTR)) binary_to_gray_write
	(.binary_value (wrptr_wrap_gray),
	 .gray_value (wrptr_wrap_gray_temp));
	 
/*
*************************************
module binary_to_gray #(parameter N=4)
						(input [PTR:0]binary_value,
						output [PTR:0]gray_value);
						
assign gray_value = binary_value ^ (binary_value >> 1);

endmodule
*************************************
module binary_to_gray #(parameter N=4)
						(input [PTR:0]binary_value,
						output [PTR:0]gray_value);
	
	genvar i;
	generate
		for(i=0; i<N-1; i=i+1)begin
			assign gray_value[i]= binary_value[i]^binary_value[i+1];
		end
	endgenerate
	
assign gray_value[N-1] = binary_value[N-1];

endmodule				
						
**************************************
module binary_to_gray  #(parameter PTR=4)
						(input [PTR:0]binary_value,
					 output [PTR:0]gray_value);

assign gray_value[PTR] = binary_value[PTR];

genvar i;

generate
	for (i=PTR-1; i>0; i=i-1) begin: Bi_to_Gr 

		BG M(.a(binary_value[i]), .b(binary_value[i-1]), .z(gray_value[i-1]));

	end
endgenerate
endmodule

module BG(input a, b, output z);

xor (z,a,b);

endmodule
*****************************************
*/	 

always@(posedge wrclk or negedge wr_rstn) begin
	
	if(!wr_rstn)
		wrptr_wrap_gray <= 'd0;
	else
		wrptr_wrap_gray <= wrptr_wrap_gray_temp;
end

//Sync wrptr to read clock domain
reg [PTR:0]wrptr_wrap_gray_sync1;
reg [PTR:0]wrptr_wrap_gray_sync2;

always@(posedge rdclk or negedge rd_rstn) begin

	if(!rd_rstn) begin
		wrptr_wrap_gray_sync1 <= 'd0;
		wrptr_wrap_gray_sync2 <= 'd0;
	end
	else begin
		wrptr_wrap_gray_sync1 <= wrptr_wrap_gray;
		wrptr_wrap_gray_sync2 <= wrptr_wrap_gray_sync1;
	end
end

//convert sync gray wrptr to binary
reg [PTR:0]wrptr_wrap_binary;
wire [PTR:0]wrptr_wrap_binary_temp;

gray_to_binary #(.PTR(PTR)) gray_to_binary_read
				(.gray_value(wrptr_wrap_binary),
				.binary_value(wrptr_wrap_binary_temp));
				
always@(posedge rdclk or negedge rd_rstn) begin

	if(!rd_rstn) 
		wrptr_wrap_binary <= 'd0;
	else
		wrptr_wrap_binary <= wrptr_wrap_binary_temp;
		
end

//read pointer logic
always@(*) begin

	rdptr_wrap_temp = rdptr_wrap;
	
	if(reset_rdptr)
		rdptr_wrap_temp = 'd0;
	else if(rollback_rdptr)
		rdptr_wrap_temp = rdptr_snapshot_temp;
	else if(read_en && (rdptr_wrap==DEPTH-1))
		rdptr_wrap_temp = 'd0;
	else if(read_en)
		rdptr_wrap_temp = rdptr_wrap+1;
end

//Take sanpshot of rd_ptr
assign rdptr_snapshot_temp = sanpshot_rdptr?
		rdptr_wrap:rdptr_snapshot_temp;

always@(posedge rdclk or negedge rd_rstn) begin

	if(!rd_rstn)begin
		rdptr_wrap <= 'd0;
		rdptr_snapshot <= 'd0;
	end
	else begin
		rdptr_wrap <= rdptr_wrap_temp;
		rdptr_snapshot <= rdptr_snapshot_temp;
	end
end


//Binary to gray convertion
reg [PTR:0]rdptr_wrap_gray;
wire [PTR:0]rdptr_wrap_gray_temp;

binary_to_gray #(.PTR(PTR)) binary_to_gray_read
	(.binary_value (rdptr_wrap_gray),
	 .gray_value (rdptr_wrap_gray_temp));
	 
	 
always@(posedge rdclk or negedge rd_rstn) begin

	if(!rd_rstn)
		rdptr_wrap_gray <= 'd0;
	else 
		rdptr_wrap_gray <= rdptr_wrap_gray_temp;
end

//synchronize rdptr_wrap_gray
reg [PTR:0]rdptr_wrap_sync1;
reg [PTR:0]rdptr_wrap_sync2;

always@(posedge wrclk or negedge wr_rstn) begin

	if(!wr_rstn)begin
		rdptr_wrap_sync1 <= 'd0;
		rdptr_wrap_sync2 <= 'd0;
	end
	else begin
		rdptr_wrap_sync1 <= rdptr_wrap_gray;
		rdptr_wrap_sync2 <= rdptr_wrap_sync1;
	end
end

//convert sync gray rdptr to binary
reg [PTR:0]rdptr_wrap_binary;
wire [PTR:0]rdptr_wrap_binary_temp;

gray_to_binary #(.PTR(PTR)) gray_to_binary_write
				(.gray_value(rdptr_wrap_binary),
				.binary_value(rdptr_wrap_binary_temp));
				
always@(posedge wrclk or negedge wr_rstn) begin

	if(!wr_rstn)
		rdptr_wrap_binary <= 'd0;
	else
		rdptr_wrap_binary <= rdptr_wrap_binary_temp;
end

assign wr_ptr = wrptr_wrap[PTR:0];
assign rd_ptr = rdptr_wrap[PTR:0];

assign fifo_full_next = ((wrptr_wrap_temp[PTR]!=rdptr_wrap_binary_temp[PTR]) &&
	(wrptr_wrap_temp[PTR-1:0]==rdptr_wrap_binary_temp[PTR-1:0]));
	
assign fifo_empty_next = (rdptr_wrap_temp[PTR:0] == wrptr_wrap_binary_temp[PTR:0]);

always@(posedge wrclk or negedge wr_rstn) begin

	if(!wr_rstn)
		fifo_full <= 'd0;
	else
		fifo_full <= fifo_full_next;
end

always@(posedge rdclk or negedge rd_rstn) begin

	if(!rd_rstn)
		fifo_empty <= 'd0;
	else
		fifo_empty <= fifo_empty_next;
end
endmodule
/*
//SRAM memory instantation
sram #(.PTR(PTR),
	   .WIDTH(WIDTH),
	   .DEPTH(DEPTH)) SRAM
	(.wrclk(wrclk),
	 .write_en(write_en),
	 .wr_ptr(wr_ptr),
	 .write_data(write_data),
	 .rdclk(rdclk),
	 .read_en(read_en),
	 .rd_ptr(rd_ptr),
	 .read_data(read_data));
endmodule

module sram #(parameter PTR = 4, WIDTH = 32, 
				DEPTH = 8)
			(input wrclk, wr_rstn, wr_en, 
			 input rdclk, rd_rstn,rd_en,
			input [DEPTH-1:0] write_data,
			output reg [DEPTH-1:0] read_data);
			
		reg [PTR-1:0] fifo [DEPTH:0];
		reg [PTR:0] wr_ptr; 
		reg [PTR:0] rd_ptr;
		
		always @(posedge wrclk or negedge wr_rstn) begin
			wr_ptr <= 0;
			if(!wr_rstn)
				wr_ptr <= 0;
			else if(wr_en) 
				fifo[wr_ptr] <= write_data;
		end
		
		always @(posedge rdclk or negedge rd_rstn) begin
			rd_ptr <= 0;
			if(!rd_rstn)
				rd_ptr <= 0;
			else if(rd_en)
				fifo[rd_ptr] <= read_data;
		end
endmodule
*/
module binary_to_gray #(parameter PTR=4)
						(input [PTR:0]binary_value,
						output [PTR:0]gray_value);
						
assign gray_value = binary_value ^ (binary_value >> 1);

endmodule


module gray_to_binary  #(parameter PTR=4)
						(input [PTR:0]gray_value,
						 output [PTR:0]binary_value);
						 
assign binary_value[0] = gray_value[0];

GB A(.a(gray_value[0]), .b(gray_value[1]), .z(binary_value[1]));

genvar i;

generate
	for (i=2; i<PTR; i=i+1) begin: Gr_to_Bi
	
		GB M(.a(gray_value[i]), .b(binary_value[i-1]), .z(binary_value[i]));
	
	end
endgenerate
endmodule

module GB(input a,b, output z);

xor (z,a,b);

endmodule