


module PCPU (
	input wire clock,
	input wire [15:0] d_datain,
	input wire enable,
	input wire [15:0] i_datain,
	input wire reset,
	input wire start,
	output wire [15:0] d_addr,
	output wire [15:0] d_dataout,
	output wire d_we,
	output wire [7:0] i_addr,
	output wire [15:0] regi0,
	output wire [15:0] regi1,
	output wire [15:0] regi2,
	output wire [15:0] regi3,
	output wire [15:0] regi4,
	output wire [15:0] regi5,
	output wire [15:0] regi6,
	output wire [15:0] regi7,
	output wire [2:0] wb_addr
);

wire state;

wire [15:0] reg_A;
wire [15:0] reg_B;
wire [15:0] reg_C;
wire [15:0] reg_C1;

wire [15:0] smdr;
wire [15:0] smdr1;

wire dw;
wire zf, sf, cf;
wire jump;

wire [15:0] ex_ir;
wire [15:0] mem_ir;
wire [15:0] wb_ir;
wire [15:0] id_ir;

wire [15:0] ALUo;

assign wb_addr=wb_ir[10:8];


reg [15:0] gr [7:0];
wire [15:0] gr0;
wire [15:0] gr1;
wire [15:0] gr2;
wire [15:0] gr3;
wire [15:0] gr4;
wire [15:0] gr5;
wire [15:0] gr6;
wire [15:0] gr7;

always @ (*) begin
	gr[0] <= gr0;
	gr[1] <= gr1;
	gr[2] <= gr2;
	gr[3] <= gr3;
	gr[4] <= gr4;
	gr[5] <= gr5;
	gr[6] <= gr6;
	gr[7] <= gr7;
end

assign regi0 = gr[0];
assign regi1 = gr[1];
assign regi2 = gr[2];
assign regi3 = gr[3];
assign regi4 = gr[4];
assign regi5 = gr[5];
assign regi6 = gr[6];
assign regi7 = gr[7];

CPU_Control co (
	.clock(clock), .reset(reset), .state(state),
	.wb_ir(wb_ir)
	);

IF IF (
	.clock(clock), .reset(reset), .state(state),
	.reg_C(reg_C), .jump(jump),
	.mem_ir(mem_ir), .i_addr(i_addr), .i_datain(i_datain),
	.id_ir(id_ir)
	  );

ID ID (
	.clock(clock), .reset(reset), .state(state),
	.id_ir(id_ir), .ex_ir(ex_ir), .mem_ir(mem_ir), .wb_ir(wb_ir),
	.ALUo(ALUo), .reg_C(reg_C), .reg_C1(reg_C1), .d_datain(d_datain),
	.reg_A(reg_A), .reg_B(reg_B), .smdr(smdr), .jump(jump),
	.gr0(gr[0]), .gr1(gr[1]), .gr2(gr[2]), .gr3(gr[3]),
	.gr4(gr[4]), .gr5(gr[5]), .gr6(gr[6]), .gr7(gr[7])
	  );

EX EX (
	.clock(clock), .reset(reset), .state(state),
	.ex_ir(ex_ir), .mem_ir(mem_ir), .jump(jump),
	.ALUo(ALUo),
	.reg_A(reg_A), .reg_B(reg_B),
	.smdr(smdr), .smdr1(smdr1),
	.zf(zf), .sf(sf), .cf(cf),
	.reg_C(reg_C), .dw(dw)
	  );

MEM MEM (
	.clock(clock), .reset(reset), .state(state),
	.d_dataout(d_dataout), .d_addr(d_addr), .d_we(d_we),
	.reg_C(reg_C), .dw(dw), .smdr1(smdr1), .mem_ir(mem_ir),
	.wb_ir(wb_ir), .reg_C1(reg_C1),
	.d_datain(d_datain)
	    );


WB WB (
	.clock(clock), .reset(reset), .state(state),
	.wb_ir(wb_ir), .reg_C1(reg_C1),
	.gr0(gr0), .gr1(gr1), .gr2(gr2), .gr3(gr3),
	.gr4(gr4), .gr5(gr5), .gr6(gr6), .gr7(gr7)
	  );

JP JP (
	.mem_ir(mem_ir), .zf(zf), .sf(sf), .cf(cf),
	.jump(jump)
	  );

endmodule

