module reaction_time_benchmark (
    input clk,
    input rst,
    input start_trigger,
    input user_trigger,
    input [15:0] random_delay,
    output reg [3:0] ms,
    output reg react,
    output reg [1:0] display_select
);

// State machine states
parameter IDLE_STATE = 2'b00;
parameter START_STATE = 2'b01;
parameter REACT_STATE = 2'b10;
parameter SHOW_STATE = 2'b11;
reg [1:0] state;
reg [5:0] reaction_time;

reg [3:0] ms_ones = 0;
reg [3:0] ms_tens = 0;
reg [3:0] ms_hundreds = 0;
reg [3:0] ms_thousands = 0;

reg [31:0] delay = 50000; // 1 sekunda
//reg [31:0] delay;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE_STATE;
    end else begin
        case (state)
            IDLE_STATE:
                if (start_trigger) begin
                    delay <= random_delay * 4;
					//delay <= 50000;
                    state <= START_STATE;
                end
            START_STATE: begin
                delay <= delay - 1;
                if (user_trigger) begin
                    state <= IDLE_STATE;
                end
                if(delay == 0) begin
                    delay <= random_delay * 4;
					//delay <= 50000;
                    state <= REACT_STATE;
                 end
            end
            REACT_STATE:
                if (user_trigger) begin
                    state <= SHOW_STATE;
                end
            SHOW_STATE:
                if (start_trigger) begin
                    state <= START_STATE;
                end
        endcase
    end
end

always @(posedge clk) begin
    if (!rst) begin
        if (state == REACT_STATE) begin
            react <= 1;
            reaction_time <= reaction_time + 1;
        end
        else begin
            react <= 0;
        end
        if (state == START_STATE) begin
            reaction_time <= 0;
            react <= 0;
            ms_ones <= 0;
            ms_tens <= 0;
            ms_hundreds <= 0;
            ms_thousands <= 0;
        end
        if (reaction_time >= 49) begin
            ms_ones <= ms_ones + 1;
            reaction_time <= 0;
        end
        if (ms_ones >= 10) begin
            ms_tens <= ms_tens + 1;
            ms_ones <= 0;
        end
        if (ms_tens >= 10) begin
            ms_hundreds <= ms_hundreds + 1;
            ms_tens <= 0;
        end
        if (ms_hundreds >= 10) begin
            ms_thousands <= ms_thousands + 1;
            ms_hundreds <= 0;
        end
        if (ms_thousands >= 10) begin
            ms_thousands <= 9;
        end
    end
    else begin
        reaction_time <= 0;
    end
end

always @(posedge clk) begin
    if (state == REACT_STATE) begin
        display_select <= 0;
    end
    if (rst) begin
        ms <= 4'b0000;
        display_select <= 0;
    end else begin
        if (state == SHOW_STATE) begin
            case (display_select)
                2'b00: ms <= ms_tens;
                2'b01: ms <= ms_hundreds;
                2'b10: ms <= ms_thousands;
                2'b11: ms <= ms_ones;
            endcase
            display_select <= display_select + 1;
        end
    end
end
endmodule
