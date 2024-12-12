module testbench;

	// Parameters
	parameter PTR = 4;
	
	// Inputs
	reg [PTR-1:0] binary_value;
	
	// Outputs
	wire [PTR-1:0] gray_value;
	
	// Instantiate the module to be tested
	binary_to_gray #(.PTR(PTR)) dut(.binary_value(binary_value), .gray_value(gray_value));
	
	// Stimulus generation
	initial begin
		$monitor("binary_value = %b, gray_value = %b", binary_value, gray_value);
		
		binary_value = 4'b0000;
		#5;
		
		binary_value = 4'b0001;
		#5;
		
		binary_value = 4'b0010;
		#5;
		
		binary_value = 4'b0011;
		#5;
		
		binary_value = 4'b0100;
		#5;
		
		binary_value = 4'b0101;
		#5;
		
		binary_value = 4'b0110;
		#5;
		
		binary_value = 4'b0111;
		#5;
		
		binary_value = 4'b1000;
		#5;
		
		binary_value = 4'b1001;
		#5;
		
		binary_value = 4'b1010;
		#5;
		
		binary_value = 4'b1011;
		#5;
		
		binary_value = 4'b1100;
		#5;
		
		binary_value = 4'b1101;
		#5;
		
		binary_value = 4'b1110;
		#5;
		
		binary_value = 4'b1111;
		#5;
		
		$finish;
	end
	
endmodule
