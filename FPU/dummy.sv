module dummy(
input clk, 
input rst,
input [7:0] A,
input [7:0] B,
input [2:0] op,
input pushin, 
input stopin,
output [7:0] sum, 
output pushout,
output stopout
);

initial begin
$display("Inside DUT");
end

endmodule