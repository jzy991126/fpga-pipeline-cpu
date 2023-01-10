`include "define.v"

module EX (
	input wire clock,
	input wire reset,
	input wire state,
	input wire [15:0] ex_ir,
	input wire [15:0] reg_B,
	input wire [15:0] reg_A,
	input wire [15:0] smdr,
	input wire jump,
	output wire [15:0] ALUo,
	output reg [15:0] mem_ir,
	output reg zf,
	output reg sf,
	output reg cf,
	output reg [15:0] reg_C,
	output reg dw,
	output reg [15:0] smdr1
	);

wire [15:0] ALUi;
wire cfin, cfout;

ALU ALU (
	.ex_ir(ex_ir), .reg_A(reg_A), .reg_B(reg_B),
	.cfin(cfin), .cfout(cfout),
	.ALUo(ALUo), .ALUi(ALUi)
		);

assign cfin = cf;
assign ALUi = reg_C;

always @ (posedge clock or negedge reset) begin
	if(!reset) begin
		mem_ir <= 16'b0000_0000_0000_0000;
		smdr1  <= 16'b0000_0000_0000_0000;
		reg_C  <= 16'b0000_0000_0000_0000;
		dw     <= 1'b0;
		zf     <= 1'b0;
		sf     <= 1'b0;
		cf     <= 1'b0;
	end
	else if (state == `exec) begin
		if (jump)
			mem_ir <= 16'b0000_0000_0000_0000;
		else begin
			mem_ir <= ex_ir;
			reg_C <= ALUo;
			if (
				(ex_ir[15:11] == `ADD)  
			 || (ex_ir[15:11] == `ADDI) || (ex_ir[15:11] == `ADDC)
			 || (ex_ir[15:11] == `SUB)  || (ex_ir[15:11] == `SUBI)
			 || (ex_ir[15:11] == `SUBC) || (ex_ir[15:11] == `CMP)
			   ) begin
				if (ALUo == 16'b0000_0000_0000_0000)
					zf <= 1'b1;
				else
					zf <= 1'b0;
				if (ALUo[15] == 1'b1)
					sf <= 1'b1;
				else
					sf <= 1'b0;
				cf <= cfout;
			end

			if (ex_ir[15:11] == `STORE) begin
				dw    <= 1'b1;
				smdr1 <= smdr;
			end
			else begin
				dw <= 1'b0;
				smdr1 <= 16'b0000_0000_0000_0000;
			end
		end
	end	
end

endmodule
