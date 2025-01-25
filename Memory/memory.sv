// TODO:  might eventually need a chip-select port?

module memory 
  # (parameter ADDR_WIDTH = 11,  // adress is 11 bits
     parameter DATA_WIDTH = 16,  // data is 16 bits
     parameter DEPTH = 2**ADDR_WIDTH     // 4Kb memory with 16 bit word size implies 2048 words (2^11) w
    )
  (
  input clk,
  input output_enable,
  input write_enable,
  input reset,
  input [ADDR_WIDTH-1:0] address,

  inout [DATA_WIDTH-1:0] data_bus
  );  

  reg [DATA_WIDTH-1:0] mem[DEPTH]; // 11 bits to index
  reg [DATA_WIDTH-1:0] 	tmp_data;
  
 
	always @(posedge clk) begin
    if (reset) 
      for (integer i = 0; i < 2048; i++)
        mem[i] <= 'h0;
    else
      if (write_enable)
        mem[address] <= data_bus;
      else
        tmp_data <= mem[address];       
	end

  assign data_bus = output_enable & !write_enable ? tmp_data : 'hz;
 endmodule 
