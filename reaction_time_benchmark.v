module reaction_time_benchmark (
    input clk,          // System clock
    input rst,          // Reset signal (active high)
    input start_trigger,// Signal to start the benchmark (active high)
    input user_trigger, // Signal from the user indicating a response (active high)
    output reg [4:0] ms, // Output for milliseconds (0 to 9)
    output reg [1:0] display_select // Counter to select which part of the ms value to display  
);

// State machine states
parameter IDLE_STATE = 2'b00;
parameter START_STATE = 2'b01;
parameter REACT_STATE = 2'b10;
parameter SHOW_STATE = 2'b11;

reg [1:0] state;         // State variable
reg [31:0] reaction_time;// Reaction time in clock cycles

reg [3:0] ms_ones = 0;
reg [3:0] ms_tens = 0;
reg [3:0] ms_hundreds = 0;
reg [3:0] ms_thousands = 0;

reg [31:0] delay = 50000; // 1 sekunda

wire[6:0] segments;
seven_segment_display disp (
    .clk(clk),
    .number(ms),
    .segments(segments)
);

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE_STATE;
        //delay = {$random} %10 * 25000; // 0 - 5 sekundi
    end else begin
        case (state)
            IDLE_STATE:
                if (start_trigger) begin
                    state <= START_STATE;
                end
            START_STATE: begin
                delay = delay - 1;
                if(delay == 0) begin
                    delay = 50000;
                    state <= REACT_STATE;
                    //delay = {$random} %10 * 25000; // 0 - 5 sekundi
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
            reaction_time <= reaction_time + 2;
        end
        if (state == START_STATE) begin
            ms_ones <= 0;
            ms_tens <= 0;
            ms_hundreds <= 0;
            ms_thousands <= 0;
        end
        if (reaction_time >= 100) begin
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

// Display the reaction time in milliseconds on the seven-segment display
always @(posedge clk) begin
    if (state == START_STATE) begin
        display_select <= 0;
    end
    if (rst) begin
        ms <= 4'b0000;
        display_select <= 0;
    end else begin
        // Convert the reaction time to milliseconds
        case (display_select)
            2'b00: ms <= ms_ones;       // Display ms_ones
            2'b01: ms <= ms_tens;       // Display ms_tens
            2'b10: ms <= ms_hundreds;   // Display ms_hundreds
            2'b11: ms <= ms_thousands;  // Display ms_thousands
        endcase
        display_select <= display_select + 1;
    end
end
endmodule
