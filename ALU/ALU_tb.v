module ALU_tb();
    // Inputs
    reg clk;
    reg [4:0] opcode;
    reg [15:0] operand_1;
    reg [15:0] operand_2;
    reg [3:0] bit_position;
    
    // Outputs
    wire [15:0] result_0;
    wire [15:0] result_1;
    wire [15:0] flag_reg;
    
    // Instantiate ALU
    ALU dut (
        .clk(clk),
        .opcode(opcode),
        .operand_1(operand_1),
        .operand_2(operand_2),
        .bit_position(bit_position),
        .result_0(result_0),
        .result_1(result_1),
        .flag_reg(flag_reg)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize inputs
        opcode = 0;
        operand_1 = 0;
        operand_2 = 0;
        bit_position = 0;
        
        // Wait for 100 ns for global reset
        #100;
        

	/* Syntax: test_case (input [64:0] test_name; input [4:0] test_opcode; 
			      input [15:0] test_op1; input [15:0] test_op2; input [3:0] test_bit_pos;) */
        // Test ADD operation
        // Normal addition
        test_case("ADD - Normal", 5'b00000, 16'd10, 16'd20, 4'd0);
        // Addition with carry
        test_case("ADD - Carry", 5'b00000, 16'hFFFF, 16'd1, 4'd0);
        // Addition with overflow
        test_case("ADD - Overflow", 5'b00000, 16'h7FFF, 16'h7FFF, 4'd0);
        
        // Test MUL operation
        test_case("MUL - Normal", 5'b00001, 16'd10, 16'd20, 4'd0);
        test_case("MUL - Large", 5'b00001, 16'hFFFF, 16'h2, 4'd0);
        
        // Test SUB operation
        test_case("SUB - Normal", 5'b00010, 16'd20, 16'd10, 4'd0);
        test_case("SUB - Negative", 5'b00010, 16'd40, 16'd29, 4'd0);
        
        // Test DIV operation
        test_case("DIV - Normal", 5'b00011, 16'd20, 16'd5, 4'd0);
        test_case("DIV - By Zero", 5'b00011, 16'd20, 16'd0, 4'd0);
        
        // Test logical operations
        test_case("NOT", 5'b00100, 16'hAAAA, 16'd0, 4'd0);
        test_case("AND", 5'b00101, 16'hAAAA, 16'h5555, 4'd0);
        test_case("OR", 5'b00110, 16'hAAAA, 16'h5555, 4'd0);
        test_case("XOR", 5'b00111, 16'hAAAA, 16'h5555, 4'd0);
        
        // Test INC operation
        test_case("INC - Normal", 5'b01000, 16'd10, 16'd0, 4'd0);
        test_case("INC - Overflow", 5'b01000, 16'hFFFF, 16'd0, 4'd0);
        
        // Test CMP operation
        test_case("CMP - Equal", 5'b01001, 16'd10, 16'd10, 4'd0);
        test_case("CMP - Greater", 5'b01001, 16'd20, 16'd10, 4'd0);
        test_case("CMP - Less", 5'b01001, 16'd10, 16'd20, 4'd0);
        
        // Test rotation operations
        test_case("RR", 5'b01010, 16'hAAAA, 16'd0, 4'd0);
        test_case("RL", 5'b01011, 16'hAAAA, 16'd0, 4'd0);
        
        // Test bit operations
        test_case("SETB", 5'b01100, 16'h0000, 16'd0, 4'd8);
        test_case("CLRB", 5'b01101, 16'hFFFF, 16'd0, 4'd8);

	// Test setting different flag bits
        test_case("SETF - Carry Flag", 5'b01110, 16'h0000, 16'h0000, 4'd0);
        test_case("SETF - Zero Flag", 5'b01110, 16'h0000, 16'h0000, 4'd7);
        test_case("SETF - Negative Flag", 5'b01110, 16'h0000, 16'h0000, 4'd6);
        test_case("SETF - General Purpose Flag", 5'b01110, 16'h0000, 16'h0000, 4'd4);
        
        // Test SWAP operation
        test_case("SWAP - Bytes", 5'b01111, 16'hABCD, 16'h0000, 4'd0);
        test_case("SWAP - Same Bytes", 5'b01111, 16'hAAAA, 16'h0000, 4'd0);
        test_case("SWAP - Zero", 5'b01111, 16'h0000, 16'h0000, 4'd0);
        test_case("SWAP - All Ones", 5'b01111, 16'hFFFF, 16'h0000, 4'd0);
        
        // End simulation
        #100 $finish;
    end
    
    // Task to run test cases
    task test_case;
        input [255:0] test_name;
        input [4:0] test_opcode;
        input [15:0] test_op1;
        input [15:0] test_op2;
        input [3:0] test_bit_pos;
        begin
            $display("\nRunning test: %s", test_name);
            @(negedge clk);
            opcode = test_opcode;
            operand_1 = test_op1;
            operand_2 = test_op2;
            bit_position = test_bit_pos;
            
            @(posedge clk);
            #1; // Wait for outputs to stabilize
            
            $display("Inputs: op1=%h, op2=%h, bit_pos=%d", test_op1, test_op2, test_bit_pos);
            $display("Outputs: result0=%h, result1=%h", result_0, result_1);
            $display("Flags: %b", flag_reg);
            
            // Specific checks
            case(test_opcode)
                5'b00000: begin // ADD
                    if(result_0 !== test_op1 + test_op2)
                        $display("ERROR: ADD result mismatch");
                end
		
		5'b00010: begin
			if(result_0 !== test_op1 - test_op2)
			$display("ERROR: SUB result mismatch"); 
		end
                5'b01001: begin // CMP
                    if(test_op1 == test_op2 && !flag_reg[3])
                        $display("ERROR: CMP equal flag not set");
                    if(test_op1 > test_op2 && !flag_reg[2])
                        $display("ERROR: CMP greater flag not set");
                    if(test_op1 < test_op2 && !flag_reg[0])
                        $display("ERROR: CMP less flag not set");
                end
            endcase
        end
    endtask
    
    // Optional: Wave dump
    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0, ALU_tb);
    end
    
endmodule
