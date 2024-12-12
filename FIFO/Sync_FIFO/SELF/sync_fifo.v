module	sync_fifo #(parameter PTR = 3, DEPTH = 8,
					WIDTH = 16) 
		(input clk, rst_n, wr_en, rd_en,
		input [WIDTH-1:0] write_data, 
		output [WIDTH-1:0] read_data,
		output reg full, empty );
		 
		reg [PTR:0] wr_ptr, rd_ptr;
		reg [PTR:0] Temp_wr_ptr, Temp_rd_ptr;
	
		sram sync_fifo_sram (.clk(clk),
							 .rst_n(rst_n),
							 .wr_en(wr_en),
							 .rd_en(rd_en),
							 .read_data(read_data),
							 .write_data(write_data)); 
							 
		always @(posedge clk or negedge rst_n) begin
			if(!rst_n) begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				full   <= 0;
				empty  <= 0;
				Temp_rd_ptr <= 0;
				Temp_wr_ptr <= 0;
			end
			else begin
				wr_ptr <= Temp_wr_ptr;
				rd_ptr <= Temp_rd_ptr;
			end
		end
		
		always @(*) begin
			
			Temp_wr_ptr = wr_ptr;
			
			if(wr_en & wr_ptr == DEPTH-1)
				Temp_wr_ptr = 0;
			else 
				Temp_wr_ptr = wr_ptr + 1;
		end
			
		always @(*) begin
			
			Temp_rd_ptr = rd_ptr;
			
			if(rd_en & rd_ptr == DEPTH-1)
				Temp_rd_ptr = 0;
			else
				Temp_rd_ptr = rd_ptr + 1;
		end
		
		always @(*) begin
			Temp_wr_ptr = wr_ptr;
			Temp_rd_ptr = rd_ptr;
		if(wr_en && rd_en)begin
			Temp_wr_ptr = wr_ptr;
			Temp_rd_ptr = rd_ptr;
		end
		else if (wr_en)
			Temp_wr_ptr = wr_ptr + 1;
		else if (rd_en)
			Temp_rd_ptr = rd_ptr - 1;
		end
		
		assign full = ((Temp_wr_ptr == DEPTH)&(Temp_rd_ptr==DEPTH));
		assign empty =((Temp_wr_ptr=='d0)&(Temp_rd_ptr=='d0));
		
endmodule


module sram #(parameter PTR = 3, WIDTH = 16, 
				DEPTH = 8)
			(input clk, rst_n, wr_en, rd_en,
			input [DEPTH-1:0] write_data,
			output reg [DEPTH-1:0] read_data);
			
		reg [PTR-1:0] fifo [DEPTH:0];
		reg [PTR:0] wr_ptr; 
		reg [PTR:0] rd_ptr;
		
		always @(posedge clk or negedge rst_n) begin
			read_data <= 0;
			wr_ptr <= 0;
			rd_ptr <= 0;
			if(!rst_n)begin
				wr_ptr <= 0;
				rd_ptr <= 0;
			end
			else if(wr_en) begin
				fifo[wr_ptr] <= write_data;
			end
			else if(rd_en) begin
				read_data <= fifo[rd_ptr];
			end
		end
		
endmodule








