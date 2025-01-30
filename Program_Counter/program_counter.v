module program_counter(
    input wire clk,
    input wire rst,
    input wire inc,
    input wire branch_en,
    input wire [10:0] branch_addr,
    output reg [10:0] current_addr
);
    always @(posedge clk) begin
        if (rst) begin
            current_addr <= 11'b0; 
        end
        else begin
            if (inc) begin
                if (branch_en) 
                    current_addr <= branch_addr;
                else 
                    current_addr <= current_addr + 1;
            end
        end
    end
endmodule
