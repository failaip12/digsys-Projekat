module lcg_random_number_generator (
    input clk,
    input rst,
    output wire [15:0] random_number
);

reg [15:0] state;

// LCG parameters (using the constants from the Borland C/C++ LCG)
parameter A = 22695477; // Multiplier
parameter C = 1;        // Increment
parameter M = 65536;    // Modulus

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 16'hACE1; // Initial seed value (can be any non-zero value)
    end else begin
        state <= (state * A + C) % M;
    end
end

assign random_number = state;

endmodule
