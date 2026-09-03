module fulladder(a_i, b_i, s_o, c_o);
	
	wire axb;
  
  assign axb  = a ^ b;
  assign sum  = axb ^ cin;
  assign cout = (a & b) | (cin & axb);
	
	
endmodule


