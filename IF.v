
`include "define.v"

module IF (
	input wire clock,
	input wire reset,
	input wire state,
	input wire [15:0] reg_C,
	input wire jump,
	input wire [15:0] mem_ir,
	input wire [15:0] i_datain,
	output reg [15:0] id_ir,
	output wire [7:0] i_addr
    );

reg [7:0] pc;

assign i_addr = pc;

always @ (posedge clock or negedge reset) begin
	if (!reset) begin
		id_ir <= 16'b0000_0000_0000_0000;
		pc <= 8'b0000_0000;
	end
	else if (state == `exec) begin
		if (jump) begin
			id_ir <= 16'b0000_0000_0000_0000;
			pc <= reg_C[7:0];
		end
		else if (id_ir[15:11] == `JUMP) begin
			id_ir <= 16'b0000_0000_0000_0000;
			pc <= id_ir[7:0];
		end
		else if ( //发生load数据冒险，流水线加入气泡
			     (id_ir[15:11] == `LOAD) &&
			     	(   (( (i_datain[15:11] == `SHL) || (i_datain[15:11] == `CAR) 
			     		|| (i_datain[15:11] == `SHR) || (i_datain[15:11] == `CAL)
	            		) && (id_ir[10:8] == i_datain[6:4]))
			     	|| 
	                    ((
	                    	(i_datain[15:11] == `ADD) || (i_datain[15:11] == `ADDC)
	                    ||	(i_datain[15:11] == `SUB) || (i_datain[15:11] == `SUBC)
	                    ||	(i_datain[15:11] == `CMP) || (i_datain[15:11] == `AND)
	                    ||	(i_datain[15:11] == `OR)  || (i_datain[15:11] == `XOR)
	                    ) && ((id_ir[10:8] == i_datain[6:4]) || (id_ir[10:8] == i_datain[2:0])))
	                ||
	                	((i_datain[15:11] == `ADDI) || (i_datain[15:11] == `SUBI)
						|| i_datain[15:11] == `MOVI || (i_datain[15:11] == `MOVI)) 
	                	&& (id_ir[10:8] == i_datain[10:8])
	                ) 
			    ) begin
			id_ir <= 16'b0000_0000_0000_0000;
			pc <= pc;
		end
		else begin 
			pc <= pc + 1'b1;
			id_ir <= i_datain;
		end 
	end
end
endmodule
