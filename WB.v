`include "define.v"

module WB (
	input wire clock,
	input wire reset,
	input wire state,
	input wire [15:0] wb_ir,
	input wire [15:0] reg_C1,
	output reg [15:0] gr0,
	output reg [15:0] gr1,
	output reg [15:0] gr2,
	output reg [15:0] gr3,
	output reg [15:0] gr4,
	output reg [15:0] gr5,
	output reg [15:0] gr6,
	output reg [15:0] gr7
    );

always @ (posedge clock or negedge reset) begin 
	if(!reset) begin
		gr7 <= 16'b0000_0000_0000_0000;
		gr6 <= 16'b0000_0000_0000_0000;
		gr5 <= 16'b0000_0000_0000_0000;
		gr4 <= 16'b0000_0000_0000_0000;
		gr3 <= 16'b0000_0000_0000_0000;
		gr2 <= 16'b0000_0000_0000_0000;
		gr1 <= 16'b0000_0000_0000_0000;
		gr0 <= 16'b0000_0000_0000_0000;
	end
	else if (state == `exec) begin
		if (
			(wb_ir[15:11] == `LOAD) || (wb_ir[15:11] == `MOVI)
		 || (wb_ir[15:11] == `ADD)  || (wb_ir[15:11] == `ADDI)
		 || (wb_ir[15:11] == `ADDC) || (wb_ir[15:11] == `SUB)
		 || (wb_ir[15:11] == `SUBI) || (wb_ir[15:11] == `SUBC)
		 || (wb_ir[15:11] == `AND)  || (wb_ir[15:11] == `OR)
		 || (wb_ir[15:11] == `XOR)  || (wb_ir[15:11] == `SHL)
		 || (wb_ir[15:11] == `SHR)  || (wb_ir[15:11] == `CAL)
		 || (wb_ir[15:11] == `CAR)
		   )
			case(wb_ir[10:8])
				`gr0 : gr0 <= reg_C1;
				`gr1 : gr1 <= reg_C1;
				`gr2 : gr2 <= reg_C1;
				`gr3 : gr3 <= reg_C1;
				`gr4 : gr4 <= reg_C1;
				`gr5 : gr5 <= reg_C1;
				`gr6 : gr6 <= reg_C1;
				`gr7 : gr7 <= reg_C1;
			endcase
	end
end
endmodule
