
module sort;

	reg clock;
	reg rst;
	reg [3:0] key;
	reg [3:0] dig;
	reg [7:0] seg;

	top uut (
		.clk(clock), 
		.rst(rst),
		.key(key)
	);
	
	always #1 clock = ~clock;
	always #100 key = ~key;
	initial begin

		clock = 0;
		key = 4'b1111;

		#50 rst = 1;
		#50 rst = 0;
		#50 rst = 1;
	end
      
endmodule

