module binary_to_gray  #(parameter PTR=4)
						(input [PTR-1:0]binary_value,
					 output [PTR-1:0]gray_value);

assign gray_value[PTR-1] = binary_value[PTR-1];

genvar i;

generate
	for (i=PTR-1; i>0; i=i-1) begin: Bi_to_Gr 

		BG M(.a(binary_value[i]), .b(binary_value[i-1]), .z(gray_value[i-1]));

	end
endgenerate
endmodule

module BG(input a, b, output z);

xor (z,a,b);

endmodule