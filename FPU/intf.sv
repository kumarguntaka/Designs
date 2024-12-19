interface intf();
  logic clk;
  logic rst;
  logic [7:0] sum;
  logic       stopout;
  logic       pushout;
  logic       stopin;
  logic       pushin;
  logic [7:0] A;
  logic [7:0] B;
  logic [2:0] op;
endinterface 