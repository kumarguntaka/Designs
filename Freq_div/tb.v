/*
`timescale 1ns / 1ps

module FrequencyDivider64_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Signals
    reg clk_in = 0;     // Input clock signal
    reg reset = 0;      // Reset signal
    wire clk_out;       // Output clock signal
    
    // Instantiate the unit under test (UUT)
    FrequencyDivider64 dut (
        .clk_in(clk_in),
        .reset(reset),
        .clk_out(clk_out)
    );
    
    // Clock generation
    always #((CLK_PERIOD / 2)) clk_in = ~clk_in;
    
    // Initial reset
    initial begin
        reset = 1;
        #10;
        reset = 0;
    end
    
    // Stimulus
    initial begin
        #100; // Simulate for 100 clock cycles
        $stop; // Stop simulation
    end
    
endmodule */


`timescale 1ns / 1ns   // Set timescale for simulation

module FrequencyMultiplier_tb;

reg clk_in;           // Input clock signal
wire clk_out;         // Output clock signal (multiplied)

// Instantiate the FrequencyMultiplier module
FrequencyMultiplier dut (
    .clk_in(clk_in),
    .clk_out(clk_out)
);

// Clock generator
initial begin
    clk_in = 0;
    forever #5 clk_in = ~clk_in;  // Toggle input clock every 5 time units
end

// Monitor
always @(posedge clk_out) begin
    $display("clk_out toggled at time %t", $time);
end

// Stimulus
initial begin
    #50;  // Run simulation for 100 time units // Finish simulation
end

endmodule

