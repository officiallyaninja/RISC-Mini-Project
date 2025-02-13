module IOPorts(input wire [1:0] port_sel,
               input wire [15:0] data_in,
               input wire read_write, 
               output data_out [15:0]);

 reg [15:0] ports [0:4];
    always @(posedge clk or posedge rst) begin 
	    if (read_write) begin 
		    ports[port_sel] <= data_in; 
	    end	
    end
	// Read logic
	assign data_out = ports[port_sel];

endmodule
