module decoder3to8(OPCODE, ALU_en, Mem_Sel, Branch_en, clk);

input [15:0] OPCODE;
input clk;
output reg ALU_en, Mem_Sel, Branch_en;

wire [2:0] I;                                   /* I= input of the decoder */
reg [7:0] O;                                   /*outputs of the decoder itself*/

assign I = OPCODE[15:13];                       /*note to self: 16 bit opcode, of which we use bits 15-13 for the decoder*/

always @(posedge clk) begin
    case (I)
        3'b000: O = 8'b00000001;
        3'b001: O = 8'b00000010;
        3'b010: O = 8'b00000100;
        3'b011: O = 8'b00001000;
        3'b100: O = 8'b00010000;
        3'b101: O = 8'b00100000;
        3'b110: O = 8'b01000000;
        3'b111: O = 8'b10000000;
        default: O = 8'b00000000;
    endcase
  
    ALU_en <= O[1] | O[2] | O[5];             /*001, 010, 101*/
    Mem_Sel <= O[3] | O[6];                   /*011, 110*/
    Branch_en <= O[0] | O[4] | O[7];          /*000, 100, 111*/
end

endmodule
