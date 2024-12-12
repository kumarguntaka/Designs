module testbench;

  // Parameters
  parameter PTR = 3;
  parameter DEPTH = 8;
  parameter WIDTH = 16;

  // Signals
  reg clk, rst_n, wr_en, rd_en;
  reg [WIDTH-1:0] write_data;
  wire [WIDTH-1:0] read_data;
  wire full, empty;

	integer i=0;
  // Instantiate FIFO
  sync_fifo #(.PTR(PTR), .DEPTH(DEPTH), .WIDTH(WIDTH))
    dut (.clk(clk), .rst_n(rst_n), .wr_en(wr_en), .rd_en(rd_en),
         .write_data(write_data), .read_data(read_data),
         .full(full), .empty(empty));

  // Clock Generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Initial values
  initial begin
    rst_n = 0;
    wr_en = 0;
    rd_en = 0;
    write_data = 0;
    #10 rst_n = 1;
  end

  // Stimulus
  initial begin
    // Test case 1: Write data to FIFO
	$display("Write data to FIFO");
    repeat (DEPTH) begin
		wr_en = 1;
		write_data = $random;
		$display("write_data = %h, full = %d, empty = %d", 
				write_data, full, empty);
		#20; 
	end
	
		wr_en = 0;
		#50

    // Test case 2: Read data from FIFO
	$display("Read data from FIFO");
    repeat (DEPTH) begin
		rd_en = 1;
		$display("read_data = %h, full = %d, empty = %d", 
				read_data, full, empty);
		#20; 
	end
	
		rd_en = 0;
		#50;
/*	
    // Test case 3: Write and read at the same time
	$display("Write and Read at the same time Wrap Around");
    for (i=0; i<=15; i=i+1)begin
		if(i<=11) begin
			wr_en = 1;
			write_data = $random;
			$display("write_data = %h, full = %b, empty = %b, i = %d", 
					write_data, full, empty, i);
			#20;
		end
		if (i>=2 & i<=5) begin
			rd_en = 1;
			$display("read_data = %h, full = %d, empty = %d, i = %d", 
					read_data, full, empty, i);
			#20;
		end
		else begin
			rd_en = 0;
			$display("read_data = %h, full = %d, empty = %d, i = %d", 
					read_data, full, empty, i);
			#20;
		end
	end
	
	begin
	#20 rst_n = 0;
	$display("wr_en = %b, write_data = %h, rd_en = %b, read_data = %h, full = %b, empty = %b, rst_n = %b", wr_en, write_data, rd_en, read_data, full, empty, rst_n);
	end
*/
  end
  
  initial begin
	#3000 $finish;
	end

endmodule