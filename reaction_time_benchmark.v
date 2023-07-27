module reaction_time_benchmark (
    input clk,          // System clock
    input rst,          // Reset signal (active high)
    input start_trigger,// Signal to start the benchmark (active high)
    input user_trigger, // Signal from the user indicating a response (active high)
    output reg [3:0] ms, // Output for milliseconds (0 to 999)
    output reg [1:0] display_select // Counter to select which part of the ms value to display  
);

// State machine states
parameter IDLE_STATE = 2'b00;
parameter START_STATE = 2'b01;
parameter REACT_STATE = 2'b10;
parameter SHOW_STATE = 2'b11;

reg [1:0] state;         // State variable
reg [31:0] reaction_time;// Reaction time in clock cycles

reg [31:0] delay = 50000; // 1 sekunda
reg react_time = 0;

wire[6:0] segments;
seven_segment_display disp (
    .number(ms),
    .segments(segments)
);
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE_STATE;
        reaction_time <= 0;
        display_select <= 0;
    end else begin
        case (state)
            IDLE_STATE:
                if (start_trigger) begin
                    state <= START_STATE;
                    display_select <= 0; // Initialize the display select counter
                end
            START_STATE: begin
                delay = delay - 1;
                if(delay == 0) begin
                    delay = 50000;
                    react_time = 1;
                end
                if (react_time) begin
                    react_time = 0;
                    state <= REACT_STATE;
                    reaction_time <= 0;
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
    if (rst) begin
        reaction_time <= 0;
    end else begin
        if (state == REACT_STATE) begin
            reaction_time <= reaction_time + 2;
        end
    end
end

// Display the reaction time in milliseconds on the seven-segment display
always @(posedge clk) begin
    if (rst) begin
        ms <= 4'b0000;
    end else begin
        // Convert the reaction time to milliseconds
        if (reaction_time >= 100) begin
            case (display_select)
                2'b00: ms <= (reaction_time / 100) % 10; // Display ms_ones
                2'b01: ms <= (reaction_time / 1000) % 10; // Display ms_tens
                2'b10: ms <= (reaction_time / 10000) % 10; // Display ms_hundreds
            endcase
            display_select <= display_select + 1; // Cycle through ms_ones, ms_tens, and ms_hundreds
        end else begin
            ms <= 4'b0000;
            display_select <= 0;
        end
    end
end

endmodule
