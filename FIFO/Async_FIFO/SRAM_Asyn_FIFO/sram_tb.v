module sram_tb;
  // Define parameters and signals
  parameter ADDR = 4;
  parameter WIDTH = 32;
  reg clk = 0;
  reg [ADDR-1:0] addr;
  reg [WIDTH-1:0] data_in;
  reg write_en;
  wire [WIDTH-1:0] data_out;
  
  // Instantiate the DUT
  sram #(ADDR, WIDTH) dut (
    .clk(clk),
    .addr(addr),
    .data_in(data_in),
    .write_en(write_en),
    .data_out(data_out)
  );
  
  // Generate clock
  always #5 clk = ~clk;
  
  // Write data to memory
  initial begin
    addr = 0;
    data_in = 32'h00000001;
    write_en = 1;
    #10;
    write_en = 0;
    #10;
    addr = 1;
    data_in = 32'h00000002;
    write_en = 1;
    #10;
    write_en = 0;
    #10;
  end
  
  // Read data from memory
  initial begin
    addr = 0;
    #20;
    $display("Data at address 0: %h", data_out);
    addr = 1;
    #20;
    $display("Data at address 1: %h", data_out);
  end
endmodule


/*module sram_tb();

	parameter ADDR = 4;
	parameter WIDTH = 32;
	
	reg wrclk = 0;
	reg wren = 0;
	reg [ADDR-1:0] wr_addr = 0;
	reg [WIDTH-1:0] wr_data = 0;
	reg rdclk = 0;
	reg read_en = 0;
	reg [ADDR-1:0] rd_addr = 0;
	
	wire [WIDTH-1:0] read_data;
	
	sram #(ADDR, WIDTH) dut (
		.wrclk(wrclk),
		.wren(wren),
		.wr_addr(wr_addr),
		.wr_data(wr_data),
		.rdclk(rdclk),
		.read_en(read_en),
		.rd_addr(rd_addr),
		.read_data(read_data)
	);
	
	always #5 wrclk = ~wrclk;
	always #10 rdclk = ~rdclk;
	

	initial begin
		// Write data to address 0
		wren = 1;
		wr_addr = 0;
		wr_data = 32'h01234567;
		#20;
		
		// Write data to address 1
		wren = 1;
		wr_addr = 1;
		wr_data = 32'h54ABCDEF;
		#20;
		
		// Write data to address 2
		wren = 1;
		wr_addr = 2;
		wr_data = 32'hFEDCBA98;
		#20;
		
		// Write data to address 3
		wren = 1;
		wr_addr = 3;
		wr_data = 32'hFEDCBA98;
		#20;
		
		// Disable write
		wren = 0;
		
		// Wait for some time
		#20;
		
		// Read data from address 0
		read_en = 1;
		rd_addr = 0;
		#20;
		
		// Read data from address 1
		read_en = 1;
		rd_addr = 1;
		#20;
		
		// Read data from address 2
		read_en = 1;
		rd_addr = 2;
		#20;
		
		// Read data from address 2
		read_en = 1;
		rd_addr = 3;
		#20;
		
		// Disable read
		read_en = 0;
		
		// Wait for some time
		#20;
		
	end
	
	initial begin
	$monitor("%d write_data = %h, waddr= %d,  read_data = %h, raddr=%d, wen= %b, ren=%b, mem=%p",$time, wr_data, wr_addr, read_data, rd_addr, wren, read_en, dut.mem);
	#300 $finish;
	end
	
endmodule */