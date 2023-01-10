

`include "define.v"

module IM (
    input wire [7:0] addr,
    output reg [15:0] iout
    );

always @ (*) begin
    case (addr[7:0])
        0:  iout =  {`LOAD, `gr3, 1'b0,`gr0,4'b0001};
        1:  iout =  {`MOVI, `gr4, 4'b0000  ,4'b0000};
        2:  iout =  {`ADD, `gr1, 1'b0, `gr1,1'b0,`gr3 };
        3:  iout =  {`SUBI,`gr3, 4'b0000, 4'b0001};
        4:  iout =  {`CMP, `gr1, 1'b0, `gr3, 1'b0, `gr4};
        5:  iout =  {`JNZ, `gr4, 4'b0000, 4'b0010};
		  6:  iout =  {`LOAD, `gr3, 1'b0,`gr4,4'b0000};
		  7:  iout =  {`CAL, `gr3, 1'b0,`gr3,4'b0010};
		  8:  iout =  {`STORE, `gr3, 1'b0,`gr4,4'b0010};
		  0:  iout =  {`LOAD, `gr3, 1'b0,`gr0,4'b0010};
        default : iout = {`HALT, 11'd0};
    endcase
end
endmodule
