// NOTE: expected_mem and mem are equal but do not compare as equal in this
// test bench. this is because there is a one clock cycle delay in the data
// port. I do not know how to get rid of this yet, and I am not sure whether
// this will cause problems in future integration.


module memory_tb;
  parameter ADDR_WIDTH = 11;
  parameter DATA_WIDTH = 16;
  parameter DEPTH = 2**ADDR_WIDTH;

  reg clk;
  reg we;
  reg oe;
  reg [ADDR_WIDTH-1:0] addr;
  wire [DATA_WIDTH-1:0] data;

  reg error_found;
  reg [DATA_WIDTH-1:0] tb_data;
  reg [DATA_WIDTH-1:0] expected_mem [0:DEPTH-1];

  memory u0
  ( 
    .clk(clk),
    .address(addr),
    .data_bus(data),
    .write_enable(we),
    .output_enable(oe)

  );


  always #10 clk = ~clk;
  assign data = !oe ? tb_data : 'hz;

  initial begin
    {clk, we, addr, tb_data, oe} <= 0; // initialize ports to 0

    repeat (2) @ (posedge clk);


    // ----------------------------
    // WRITE PHASE
    // ----------------------------
    

    for (integer i = 0; i < DEPTH; i= i+1) begin
      expected_mem[i] <= $random;
    end
    
    for (integer i = 0; i < DEPTH; i= i+1) begin
      @(posedge clk);
      we <= 1;
      addr <= i;
      oe <= 0;
      tb_data <= expected_mem[i];
    end


    // One extra cycle after the loop completes
    @(posedge clk);
    we <= 0; // Stop writing


    // ----------------------------
    // READ & VERIFY PHASE
    // ----------------------------
    error_found <= 0;
    for (integer i = 0; i < DEPTH; i= i+1) begin
      @(posedge clk)
      addr <= i;
      we <= 0;
      oe <= 1;

      // Wait 1 cycle for the RAM to present the data
      @(posedge clk); 
      // Now data should be stable on the bus
      if (data !== expected_mem[i]) begin
        $display("ERROR at address %0d: expected 0x%0h, got 0x%0h", i, expected_mem[i], data);
        error_found <= 1;
      end
    end
    if (!error_found) $display("No Errors Found!");

    #20 $finish;
  end
endmodule

