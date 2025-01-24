// Register testbench
module registers_tb();
    reg clk;
    reg rst;
    reg write_en;
    reg swap_en;
    reg bit_op_en;
    reg [2:0] read_addr_0;
    reg [2:0] read_addr_1;
    reg [2:0] reg_write_addr;
    reg [15:0] data_in;
    reg [1:0] bit_op;
    reg [3:0] bit_position;
    wire [15:0] read_data_0;
    wire [15:0] read_data_1;
    
    registers uut (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
	.swap_en(swap_en),
	.bit_op_en(bit_op_en),
        .read_addr_0(read_addr_0),
        .read_addr_1(read_addr_1),
        .reg_write_addr(reg_write_addr),
        .data_in(data_in),
	.bit_op(bit_op),
	.bit_position(bit_position),
        .read_data_0(read_data_0),
        .read_data_1(read_data_1)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
     initial begin
        $dumpfile("registers_tb.vcd");
        $dumpvars(0, registers_tb);    
    end
    initial begin
        rst = 1;
        write_en = 0;
	swap_en = 0;
	bit_op_en = 0;
        read_addr_0 = 0;
        read_addr_1 = 0;
        reg_write_addr = 0;
        data_in = 0;
        
        // 100 ns for global reset
        #100;
        rst = 0;
        
        // Test case 1: Write to register
        @(posedge clk);
        write_en = 1;
        reg_write_addr = 3'b010;
        data_in = 16'h1234;
        
        // Test case 2: Write to register
        @(posedge clk);
        reg_write_addr = 3'b101;
        data_in = 16'h5678;
        
        // Test case 3: Read
        @(posedge clk);
        write_en = 0;
        read_addr_0 = 3'b010;
        read_addr_1 = 3'b101;
	#20;

	//Test case 4: Swap
	@(posedge clk);
	write_en = 1;
	swap_en = 1;
	reg_write_addr = 3'b010;
	swap_en = 0;
	write_en=0;
	#20;
	
	// Test case 5: Simultaneous read and write
        @(posedge clk);
        write_en = 1;
        reg_write_addr = 3'b010;  
        data_in = 16'h2345;
        read_addr_0 = 3'b010; 
        read_addr_1 = 3'b000;
	
	// Test case 5a: Read
	@(posedge clk);
        write_en = 0;
        read_addr_0 = 3'b010;
        read_addr_1 = 3'b101;
	#20;

	//Test case 6: Bit operation, Set bit
	@(posedge clk);
	write_en = 1;
	bit_op_en = 1;
	bit_op = 2'b00;
	reg_write_addr = 3'b000;
	bit_position = 4'b1111;
	#10;
	bit_op_en = 0;
	write_en = 0;
	#10;

	//Test case 6a: Read
	@(posedge clk);
        write_en = 0;
        read_addr_0 = 3'b000;
	#20;

	// Test case X: Reset
        @(posedge clk);
        rst = 1;
	write_en = 0;
        #20;
        rst = 0;

        // End simulation
        #100;
        $finish;
    end
    initial begin
        $monitor("Time=%0t rst=%b we=%b wa=%b din=%h ra0=%b rd0=%h ra1=%b rd1=%h",
                 $time, rst, write_en, reg_write_addr, data_in, 
                 read_addr_0, read_data_0, read_addr_1, read_data_1);
    end
endmodule