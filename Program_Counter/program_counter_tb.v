module program_counter_tb();
    reg clk;
    reg rst;
    reg inc;
    reg branch_en;
    reg [10:0] branch_addr;
    reg [10:0] current_addr;
    wire [10:0] next_addr;

    program_counter pc(
        .clk(clk),
        .rst(rst),
        .inc(inc),
        .branch_en(branch_en),
        .branch_addr(branch_addr),
        .current_addr(current_addr),
        .next_addr(next_addr)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // 100MHz clock
    end

    // Tests
    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);

        // Initialize signals
        rst = 0;
        inc = 0;
        branch_en = 0;
        branch_addr = 11'b0;
        current_addr = 11'b0;

        // Test 1: Reset behavior
        #10 rst = 1;
        #10 rst = 0;

        // Test 2: Normal increment
        #10;
        inc = 1;
        current_addr = 11'd5;
	#10;        
	if (next_addr !== 11'd6) $display("Test 2 Failed: Expected 6, Got %d", next_addr);
        
        // Test 3: Branch operation
        #10;
        inc = 0;
        branch_en = 1;
        branch_addr = 11'd20;
	#10;
        if (next_addr !== 11'd20) $display("Test 3 Failed: Expected 20, Got %d", next_addr);

        // Test 4: Default behavior (no increment, no branch)
        #10;
        inc = 0;
        branch_en = 0;
	#10;
        if (next_addr !== 11'd20) $display("Test 4 Failed: Expected 0, Got %d", next_addr);

        // Test 5: Priority check (both inc and branch_en active)
        #10;
        inc = 1;
        branch_en = 1;
        current_addr = 11'd10;
        branch_addr = 11'd30;
        #10;
        if (next_addr !== 11'd30) $display("Test 5 Failed: Expected 30, Got %d", next_addr);

        // Test 6: Multiple increments
        #10;
        branch_en = 0;
        current_addr = 11'd15;
	#10;
        if (next_addr !== 11'd16) $display("Test 6 Failed: Expected 16, Got %d", next_addr);

        // End simulation
        #20 $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time=%0t rst=%b inc=%b branch_en=%b current_addr=%d branch_addr=%d next_addr=%d",
                 $time, rst, inc, branch_en, current_addr, branch_addr, next_addr);
    end
endmodule
