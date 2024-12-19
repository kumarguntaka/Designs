/*module FrequencyDivider64 (
    input wire clk_in,  // Input clock
    input wire reset,   // Reset signal
    output wire clk_out // Output clock
);

reg [5:0] counter; // 6-bit counter

// Modulo-64 counter
always @(posedge clk_in or posedge reset) begin
    if (reset)
        counter <= 0;
    else if (counter == 63)
        counter <= 0; // Wrap around
    else
        counter <= counter + 1;
end

assign clk_out = counter[5]; // Output every 64th cycle

endmodule
*/

module FrequencyMultiplier (
    input wire clk_in,      // Input clock signal
    output reg clk_out      // Output clock signal (multiplied)
);

  integer count =0;   
always @(posedge clk_in) begin
    
  for(count = 0; count < 64; count++) begin
	clk_out <= ~clk_out;
	end
end

endmodule
