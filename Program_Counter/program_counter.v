module program_counter(
	input wire clk,
	input wire rst,
	input wire inc,
	input wire branch_en,
	input wire [10:0] branch_addr,
	input wire [10:0] current_addr,
	output reg [10:0] next_addr = 11'b0
);

	always @(posedge clk) begin
		if (rst) begin
			next_addr <= 11'b0; 
		end
		else if (branch_en) begin
			next_addr <= branch_addr;
		end
		else if (inc) begin
			next_addr <= current_addr + 1;
		end
	end
endmodule		
