module registers(
    input wire clk,
    input wire rst,
    input wire write_en,
    input wire swap_en,
    input wire bit_op_en,
    input wire [2:0] read_addr_0,
    input wire [2:0] read_addr_1,
    input wire [2:0] reg_write_addr,
    input wire [15:0] data_in,
    input wire [1:0] bit_op,
    input wire [3:0] bit_position,
    output reg [15:0] read_data_0,
    output reg [15:0] read_data_1
);
    // Register file array
    reg [15:0] registers [0:7];
    
    // Reset and write logic
    always @(posedge clk or posedge rst) begin
          if (rst) begin
              registers[0] <= 16'b0;                
              registers[1] <= 16'b0;               
              registers[2] <= 16'b0;
              registers[3] <= 16'b0;
              registers[4] <= 16'b0;
              registers[5] <= 16'b0;
              registers[6] <= 16'b0;
              registers[7] <= 16'b0;
          end
          else if (write_en) begin
		if (swap_en) begin
                	registers[reg_write_addr] <= {registers[reg_write_addr][7:0], registers[reg_write_addr][15:8]};
            	end
		
		else if (bit_op_en) begin
			case (bit_op)
				2'b00: registers[reg_write_addr] <= registers[reg_write_addr] | (1 << bit_position);
				2'b01: registers[reg_write_addr] <= registers[reg_write_addr] & (0 << bit_position);
			endcase
		end		
		
		else begin
            		registers[reg_write_addr] <= data_in;
		end
          end
    end

    always @(*) begin
        if (rst) begin
            read_data_0 = 16'b0;
            read_data_1 = 16'b0;
        end
        else begin
            read_data_0 = registers[read_addr_0];
            read_data_1 = registers[read_addr_1];
        end
    end
endmodule