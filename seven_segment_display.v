module seven_segment_display (
    input [3:0] number,
    output reg [6:0] segments
);
//(a, b, c, d, e, f, g)
parameter [6:0] seven_segment_patterns = {
    7'b1000000, // 0
    7'b1111001, // 1
    7'b0100100, // 2
    7'b0110000, // 3
    7'b0011001, // 4
    7'b0010010, // 5
    7'b0000010, // 6
    7'b1111000, // 7
    7'b0000000, // 8
    7'b0010000  // 9
};

always @*
begin
    segments = seven_segment_patterns[number];
end

endmodule