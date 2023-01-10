`include "define.v"

module CPU_Control (
	input wire clock,
	input wire reset,
	input wire [15:0] wb_ir,
	output reg state
	);

reg next_state;


initial 
begin
	state<= `exec;
	next_state<=`exec;
end

always @ (posedge clock or negedge reset) begin
	if (!reset)
		state <= `exec;
	else
		state <= next_state;
end

always @ (*) begin
	if((wb_ir[15:11] == `HALT))
		next_state<=`idle;
	else
		next_state<=state;
end

endmodule