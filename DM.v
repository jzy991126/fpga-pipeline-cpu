

`include "define.v"

module DM (
    input wire [15:0] addr,
    output wire [15:0] dout,
    input wire [15:0] din,
    input wire we,
    input wire clk,
    input wire reset
    );

reg [15:0] mem [`MEM_SIZE - 1:0];



always @ (posedge clk or negedge reset) begin
    if (!reset) begin
        mem[0]<=8;
        mem[1]<=5;
    end
    else if (we) begin
        mem[addr] <= din;
    end
end

assign dout = mem[addr];

endmodule
