module mem_decoder(OPCODE, LOAD, STORE, Load_Imm, clk);

input [15:0] OPCODE;
output reg LOAD, STORE, Load_Imm;

wire [1:0] I;
assign I = OPCODE[12:11];

reg [3:0] O;

always @(posedge clk) begin
    case(I)
        2'b00: O = 4'b0001;
        2'b01: O = 4'b0010;
        2'b10: O = 4'b0100;
        2'b11: O = 4'b1000;
        default: O = 4'b0000;
    endcase

    Load_Imm <= O[0] | O[1];
    LOAD <= O[2];
    STORE <= O[3];
end

endmodule
