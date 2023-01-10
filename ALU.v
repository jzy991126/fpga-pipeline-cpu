`include "define.v"

module ALU (
	input wire [15:0] ex_ir,
	input wire [15:0] reg_A,
	input wire [15:0] reg_B,
	input wire cfin,
	input wire [15:0] ALUi,
	output reg cfout,
	output reg [15:0] ALUo
    );

always @ (*)      
    case(ex_ir[15:11])
        `LOAD   : {cfout, ALUo} <= reg_A + reg_B;
        `STORE  : {cfout, ALUo} <= reg_A + reg_B;
        `ADD    : {cfout, ALUo} <= reg_A + reg_B;
        `ADDI   : {cfout, ALUo} <= reg_A + reg_B;
        `MOVI   : ALUo <=reg_B;
        `ADDC   : {cfout, ALUo} <= reg_A + reg_B + cfin;
        `SUB    : {cfout, ALUo} <= reg_A - reg_B;
        `SUBI   : {cfout, ALUo} <= reg_A - reg_B;
        `SUBC   : {cfout, ALUo} <= reg_A - reg_B - cfin;
        `CMP    : {cfout, ALUo} <= reg_A - reg_B;
        `AND    : {cfout, ALUo} <= reg_A & reg_B;
        `OR     : {cfout, ALUo} <= reg_A | reg_B;
        `XOR    : {cfout, ALUo} <= reg_A ^ reg_B;
        `SHL    : {cfout, ALUo} <= reg_A << reg_B[3:0];
        `SHR    : {cfout, ALUo} <= reg_A >> reg_B[3:0];
        `CAL    : {cfout, ALUo} <= $signed(reg_A) <<< reg_B[3:0];
        `CAR    : {cfout, ALUo} <= $signed(reg_A) >>> reg_B[3:0];
        `JZ     : {cfout, ALUo} <= reg_A + reg_B;
        `JNZ    : {cfout, ALUo} <= reg_A + reg_B;
        `JS     : {cfout, ALUo} <= reg_A + reg_B;
        `JNS    : {cfout, ALUo} <= reg_A + reg_B;
        `JC     : {cfout, ALUo} <= reg_A + reg_B;
        `JNC    : {cfout, ALUo} <= reg_A + reg_B;
        default : {cfout, ALUo} <= {cfin, ALUi};
     endcase
endmodule
