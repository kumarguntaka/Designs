module gray_to_binary  #(parameter PTR=4)
						(input [PTR-1:0]gray_value,
						 output [PTR-1:0]binary_value);
						 
assign binary_value[0] = gray_value[0];

GB A(.a(gray_value[0]), .b(gray_value[1]), .z(binary_value[1]));

genvar i;

generate
	for (i=2; i<PTR; i=i+1) begin: Gr_to_Bi
	
		GB M(.a(gray_value[i]), .b(binary_value[i-1]), .z(binary_value[i]));
	
	end
endgenerate
endmodule

module GB(input a,b, output z);

xor (z,a,b);

endmodule