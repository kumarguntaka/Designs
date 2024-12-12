module sram #(
  parameter ADDR = 4,
  parameter WIDTH = 32
) (
  input clk,
  input [ADDR-1:0] addr,
  input [WIDTH-1:0] data_in,
  input write_en,
  output reg [WIDTH-1:0] data_out
);

  localparam DEPTH = 1<<ADDR;

  reg [WIDTH-1:0] mem [0:DEPTH-1];
  reg [ADDR-1:0] addr_gray [0:DEPTH-1];

  // Write port
  always @(posedge clk) begin
    if (write_en) begin
      mem[addr] <= data_in;
      addr_gray[addr] <= ^{addr, addr[ADDR-1:1]};
    end
  end

  // Read port
  assign data_out = mem[^{addr_gray[addr], addr_gray[addr][ADDR-1]}];

endmodule


/*module sram #(parameter ADDR = 4, WIDTH = 32)
			(input wrclk, wren,
			 input [ADDR-1:0]wr_addr,
			 input [WIDTH-1:0]write_data, 
			 input rdclk, read_en,
			 input [ADDR-1:0]rd_addr,
			 output reg [WIDTH-1:0] read_data);
			
reg [WIDTH-1:0] mem [ADDR-1:0];

always @(posedge wrclk)
begin
	if(!wren)
		mem[wr_addr] <= 'h0;
	else
		mem[wr_addr] <= write_data;
end

always @(posedge rdclk)
begin
	if(!read_en)
		read_data <= 'h0;
	else
		read_data <= mem[rd_addr];
end

endmodule*/