
module top (
	input wire clk,
	input wire rst,
	input [3:0] key,
	output [3:0] dig,
	output [7:0] seg,
	output [3:0] led
    );

wire CPU_Clock;
wire MEM_Clock;

wire [7:0] i_addr;
wire [15:0] i_datain;

wire [15:0] d_datain;
wire [15:0] d_addr;
wire [15:0] d_dataout;
wire d_we;

wire [15:0] gr[7:0];

wire [3:0] rkey;

wire rclk;


bt but(.key(key),.key_pulse(rkey),.rst(rst),.clk(clk));


wire boardCLK;

reg [15:0] temp [7:0];

reg flag;
reg flag2;

wire [2:0] cpos;

always @(posedge rkey[2:2])
begin
flag = ~flag;
end
always @(posedge rkey[3:3])
begin
flag2 = ~flag2;
end
assign boardCLK = rkey[0:0];
reg [2:0] cnt;
always@(posedge rkey[1:1])
begin
	if(~flag2)
	begin
		if(flag)
			cnt<=cnt+1;
		else
			cnt<=cnt-1;
	end
	else
	begin
		cnt<=cpos;
	end
end

xian xx(.dig(dig),.seg(seg),.num(gr[cnt]),.clk(clk));
assign led[2:0] = ~cnt;
assign led[3:3] = ~flag;



PCPU myCPU (
	.clock(boardCLK), .reset(rst),
	.i_addr(i_addr), .i_datain(i_datain),
	.d_addr(d_addr), .d_datain(d_datain), .d_dataout(d_dataout), .d_we(d_we),
	.regi0(gr[0]), .regi1(gr[1]), .regi2(gr[2]), .regi3(gr[3]),
	.regi4(gr[4]), .regi5(gr[5]), .regi6(gr[6]), .regi7(gr[7]),.wb_addr(cpos)
	);

IM instructionMemory (
	.addr(i_addr), .iout(i_datain)
	);

DM dataMemory (
	.addr(d_addr), .dout(d_datain), .din(d_dataout),
	.we(d_we), .clk(boardCLK), .reset(rst)
	);

endmodule
