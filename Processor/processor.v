`include "/ALU/ALU.v"
`include "/Registers/Registers.v"

module processor(input clk, input rst,
                 input [4:0] opcode, 
                 input [1:0] read_write,
                 input [2:0] control,
                 input [15:0] imm_val);

    wire [15:0] read_data_0, read_data_1;    // Register file outputs
    wire [15:0] operand_1, operand_2;        // ALU inputs
    wire [15:0] res_0, res_1;                // ALU outputs
    wire [15:0] flag_reg;                    // Flag register
    wire [15:0] data_in_0, data_in_1;        // Register file inputs
    wire [2:0] write_addr_0, write_addr_1;   // Register write addresses
    wire [2:0] read_addr_0, read_addr_1;     // Register read addresses
 // Input MUX for data_in_0
    reg [15:0] mux_data_in_0;
    always @(*) begin
        case(control)
            3'b000: mux_data_in_0 = res_0;        // From ALU result_0
            3'b001: mux_data_in_0 = data_in;      // From I/O port
            3'b010: mux_data_in_0 = read_data_0;  // From data memory
            3'b011: mux_data_in_0 = imm_val;
            default: mux_data_in_0 = 16'h0000;
        endcase
    end
ALU alu (
        .clk(clk),
        .opcode(opcode),
        .operand_1(read_data_0),            
        .operand_2(read_data_1), 
        .result_0(res_0),
        .result_1(res_1),
        .flag_reg(flag_reg),
        .alu_done(alu_done)
    );

    Registers reg_file (
        .clk(clk),
        .rst(rst),
        .read_write(read_write),   
        .read_addr_0(read_addr_0),
        .read_addr_1(read_addr_1),
        .reg_write_addr_0(write_addr_0),
        .reg_write_addr_1(write_addr_1),
        .data_in_0(mux_data_in_0),  // Connected to input MUX
        .data_in_1(res_1),                 
        .read_data_0(read_data_0),
        .read_data_1(read_data_1),
        .reg_done(reg_done)
    );
endmodule
