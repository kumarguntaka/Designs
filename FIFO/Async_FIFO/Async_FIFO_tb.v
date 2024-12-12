module async_fifo_tb;

    // Parameters
    parameter ADDR = 4;
    parameter WIDTH = 32;

    // Inputs
    reg wrclk, rst_wrclk, write_en, snap_wraddr, roll_wraddr, rst_waddr;
    reg rdclk, rst_rdclk, read_en, snap_rdaddr, roll_rdaddr, rst_rdaddr;
    reg [WIDTH-1:0] write_data;

    // Outputs
    wire [WIDTH-1:0] read_data;
    wire fifo_full, fifo_empty;
    wire [ADDR:0] room_avail, data_avail;

    // Instantiate DUT
    async_fifo #(.ADDR(ADDR), .WIDTH(WIDTH)) dut (
        .wrclk(wrclk), .rst_wrclk(rst_wrclk), .write_en(write_en), .snap_wraddr(snap_wraddr),
        .roll_wraddr(roll_wraddr), .rst_waddr(rst_waddr), .rdclk(rdclk), .rst_rdclk(rst_rdclk),
        .read_en(read_en), .snap_rdaddr(snap_rdaddr), .roll_rdaddr(roll_rdaddr), .rst_rdaddr(rst_rdaddr),
        .write_data(write_data), .read_data(read_data), .fifo_full(fifo_full), .fifo_empty(fifo_empty),
        .room_avail(room_avail), .data_avail(data_avail) );

    // Clock generation
    always #5 wrclk <= ~wrclk;
    always #7 rdclk <= ~rdclk;

    // Reset generation
    initial begin
        rst_wrclk = 1;
        rst_rdclk = 1;
        rst_waddr = 1;
        rst_rdaddr = 1;
        #10 rst_wrclk = 0;
        #12 rst_rdclk = 0;
        #15 rst_waddr = 0;
        #17 rst_rdaddr = 0;
    end

    // Write test
    initial begin
        write_data = 'h0;
        write_en = 1;
        #20 write_data = 'h1;
        #20 write_data = 'h2;
        #20 write_data = 'h3;
        #20 write_data = 'h4;
        #20 write_data = 'h5;
        #20 write_data = 'h6;
        #20 write_data = 'h7;
        #20 write_data = 'h8;
        #20 write_data = 'h9;
        #20 write_data = 'ha;
        #20 write_data = 'hb;
        #20 write_data = 'hc;
        #20 write_data = 'hd;
        #20 write_data = 'he;
        #20 write_data = 'hf;
        #20 write_data = 'h10;
        #20 write_data = 'h11;
        #20 write_data = 'h12;
        #20 write_data = 'h13;
        #20 write_data = 'h14;
        #20 write_data = 'h15;
        #20 write_en = 0;
        #20 $finish;
    end

    // Read test
    always @(posedge rdclk) begin
        if (read_en && !fifo_empty) begin
            $display("Address: %d, Data: %h", room_avail, read_data);
        end
    end

endmodule



/*`timescale 1ns / 1ps

module async_fifo_tb;

    // Parameters
    parameter ADDR = 4;
    parameter WIDTH = 8;
    
    // Inputs
    reg wrclk, rst_wrclk, write_en, snap_wraddr, roll_wraddr, rst_waddr;
    reg [WIDTH-1:0] write_data;
    reg rdclk, rst_rdclk, read_en, snap_rdaddr, roll_rdaddr, rst_rdaddr;
    
    // Outputs
    wire [WIDTH-1:0] read_data;
    wire fifo_full, fifo_empty;
    wire [ADDR:0] room_avail, data_avail;
	
	integer i;
    
    // Instantiate the DUT
    async_fifo #(.ADDR(ADDR), .WIDTH(WIDTH)) dut (
        .wrclk(wrclk),
        .rst_wrclk(rst_wrclk),
        .write_en(write_en),
        .snap_wraddr(snap_wraddr),
        .roll_wraddr(roll_wraddr),
        .rst_waddr(rst_waddr),
        .write_data(write_data),
        .rdclk(rdclk),
        .rst_rdclk(rst_rdclk),
        .read_en(read_en),
        .snap_rdaddr(snap_rdaddr),
        .roll_rdaddr(roll_rdaddr),
        .rst_rdaddr(rst_rdaddr),
        .read_data(read_data),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .room_avail(room_avail),
        .data_avail(data_avail)
    );
    
    // Clock generation
    always #5 wrclk = ~wrclk;
    always #10 rdclk = ~rdclk;
    
    // Write data and check if fifo_full and data_avail are set correctly
    initial begin
        rst_wrclk = 1;
        rst_rdclk = 1;
        #20 rst_wrclk = 0;
        #20 rst_rdclk = 0;
        #20 write_en = 1;
        #20 write_data = 8'h11;
        #20 $display("Write data: %h", write_data);
        #20 $display("FIFO full: %b, Data available: %b, Room available: %d", fifo_full, data_avail, room_avail);
        assert(fifo_full == 0);
        assert(data_avail == 1);
        assert(room_avail == (1 << ADDR) - 1);
        #20 write_en = 0;
        #20 $display("FIFO full: %b, Data available: %b, Room available: %d", fifo_full, data_avail, room_avail);
        assert(fifo_full == 0);
        assert(data_avail == 1);
        assert(room_avail == (1 << ADDR) - 2);
    end
    
    // Read data and check if fifo_empty and data_avail are set correctly
    initial begin
       	#20 read_en = 1;
		#20 $display("Read data: %h", read_data);
		#20 $display("FIFO empty: %b, Data available: %b, Room available: %d", fifo_empty, data_avail, room_avail);
		assert(fifo_empty == 0);
		assert(data_avail == 0);
		assert(room_avail == (1 << ADDR) - 1);
		#20 read_en = 0;
		#20 $display("FIFO empty: %b, Data available: %b, Room available: %d", fifo_empty, data_avail, room_avail);
		assert(fifo_empty == 0);
		assert(data_avail == 1);
		assert(room_avail == (1 << ADDR) - 1);
	end
	
	// Write more data than available space and check if fifo_full is set correctly
	initial begin
		#20 write_en = 1;
		for (i = 0; i < (1 << ADDR); i=i+1) begin
			write_data = i;
			#20 $display("Write data: %h", write_data);
			#20 $display("FIFO full: %b, Data available: %b, Room available: %d", fifo_full, data_avail, room_avail);
			if (i == (1 << ADDR) - 1) begin
				assert(fifo_full == 1);
				assert(data_avail == 0);
				assert(room_avail == 0);
			end else begin
				assert(fifo_full == 0);
				assert(data_avail == 1);
				assert(room_avail == (1 << ADDR) - i - 1);
			end
			#20;
		end
		write_en = 0;
		#20 $display("FIFO full: %b, Data available: %b, Room available: %d", fifo_full, data_avail, room_avail);
		assert(fifo_full == 1);
		assert(data_avail == 0);
		assert(room_avail == 0);
	end
	
	// Read all data and check if fifo_empty is set correctly
	initial begin
		#20 read_en = 1;
		for (i = 0; i < (1 << ADDR); i=i+1) begin
			#20 $display("Read data: %h", read_data);
			#20 $display("FIFO empty: %b, Data available: %b, Room available: %d", fifo_empty, data_avail, room_avail);
			if (i == (1 << ADDR) - 1) begin
				assert(fifo_empty == 1);
				assert(data_avail == 0);
				assert(room_avail == (1 << ADDR) - 1);
			end else begin
				assert(fifo_empty == 0);
				assert(data_avail == (1 << ADDR) - i - 1);
				assert(room_avail == i + 1);
			end
			#20;
		end
		read_en = 0;
		#20 $display("FIFO empty: %b, Data available: %b, Room available: %d", fifo_empty, data_avail, room_avail);
		assert(fifo_empty == 1);
		assert(data_avail == 0);
		assert(room_avail == (1 << ADDR) - 1);
	end
	
endmodule
*/


/*`timescale 1 ns / 1 ns

module async_fifo_tb();

	// Parameters
	parameter ADDR = 4;
	parameter WIDTH = 32;

	// Inputs
	reg wrclk, rst_wrclk, write_en, snap_wraddr, roll_wraddr, rst_waddr;
	reg rdclk, rst_rdclk, read_en, snap_rdaddr, roll_rdaddr, rst_rdaddr;
	reg [WIDTH-1:0] write_data;
	
	// Outputs
	wire [WIDTH-1:0] read_data;
	wire fifo_full, fifo_empty;
	wire [ADDR:0] room_avail, data_avail;
	

	// Instantiate the asynchronous FIFO
	async_fifo #(.ADDR(ADDR), 
				 .WIDTH(WIDTH)) async_fifo_inst 
				
				(.wrclk(wrclk), 
				 .rst_wrclk(rst_wrclk), 
				 .write_en(write_en),
				 .snap_wraddr(snap_wraddr), 
				 .roll_wraddr(roll_wraddr), 
				 .rst_waddr(rst_waddr),
				 .rdclk(rdclk), 
				 .rst_rdclk(rst_rdclk), 
				 .read_en(read_en),
				 .snap_rdaddr(snap_rdaddr), 
				 .roll_rdaddr(roll_rdaddr), 
				 .rst_rdaddr(rst_rdaddr),
				 .write_data(write_data), 
				 .read_data(read_data), 
				 .fifo_full(fifo_full),
				 .fifo_empty(fifo_empty), 
				 .room_avail(room_avail), 
				 .data_avail(data_avail) );
	// Clock generator
	always #5 wrclk = ~wrclk;
	always #8 rdclk = ~rdclk;

	initial begin
	wrclk = 0;
	rst_wrclk = 0;
	rst_waddr = 1;
	write_en = 0;
	snap_wraddr = 0;
	roll_wraddr = 0;
	
	rdclk = 0;
	rst_rdclk = 0;
	rst_rdaddr = 0;
	read_en =0;
	snap_rdaddr = 0;
	roll_rdaddr = 0;
	end

	integer i;
	
	initial fork
	#40 rst_waddr = 0;
	#20 write_en = 1;
	#80 snap_wraddr = 1;
	#90 snap_wraddr = 0;
	for(i=0; i<8; i=i+1)
		begin
		write_data = i*2;
		#20;
		end
	#120 roll_wraddr = 1;
	#160 roll_wraddr = 0;
	join
	
	initial begin
	#60 rst_rdaddr = 0;
	#40 snap_rdaddr = 1;
	#20 snap_rdaddr = 0;
	#20 roll_rdaddr = 1;
	#20 roll_rdaddr = 0;
	end

	initial begin
	$monitor("%d wrclk=%b, rdclk=%b, write_data=%d, read_data =%d, snap_wraddr=%d, snap_rdaddr=%d, roll_rdaddr =%d, roll_wraddr=%d", $time, wrclk, rdclk, write_data, read_data, snap_wraddr, snap_rdaddr, roll_rdaddr, roll_wraddr);
	#400 $finish;
	end

endmodule*/