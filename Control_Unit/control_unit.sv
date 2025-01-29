`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2025 14:09:10
// Design Name: 
// Module Name: control_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module control_unit(
    input clk,
    input [16:0] instruction,
    output [2:0] reg_sel_r0, // connected to reg file r0 select port
    output [2:0] reg_sel_r1, // connected to reg file r1 select port
    output [2:0] reg_sel_w0, // connected to reg file w0 select port
    output reg_w0_rw // connected to reg file r/w port
    );

    wire [4:0] opcode = instruction[15:11];
    wire [11:0] operand = instruction[10:0];

    wire [2:0] reg_arg_1 = operand[10:8];
    wire [2:0] reg_arg_2 = operand[7:5];
    wire [2:0] reg_arg_3 = operand[4:2];


always @(posedge clk) begin
    case (opcode)
      5'b00000: begin // ADD
        reg_w0_rw <= 1;
        reg_sel_w0 <= reg_arg_1; 
        reg_sel_r0 <= reg_arg_2; 
        reg_sel_r1 <= reg_arg_3; // 

      end
        default: $display("unimplemented");
    endcase
  end
endmodule
