module seven_segment_display (
    input wire [3:0] number,
    input wire [1:0] display_select,
    output reg [6:0] segments,
    output reg [3:0] digit_select
);
//(a, b, c, d, e, f, g)

always @(number)
begin
    case(number) //This assumes that cathodes that we want to light up are driven LOW.
        0: segments =  7'b0000001;
        1: segments =  7'b1001111;
        2: segments =  7'b0010010;
        3: segments =  7'b0000110;
        4: segments =  7'b1001100;
        5: segments =  7'b0100100;
        6: segments =  7'b0100000;
        7: segments =  7'b0001111;
        8: segments =  7'b0000000;
        9: segments =  7'b0000100;
        default: segments = 7'b1111111;
    endcase
end

always @(display_select)
begin
    case(display_select) //This assumes that digit display signal is driven LOW.
        2'b00: digit_select = 4'b0001;
        2'b01: digit_select = 4'b0010;
        2'b10: digit_select = 4'b0100;
        2'b11: digit_select = 4'b1000;
    endcase
end

endmodule
