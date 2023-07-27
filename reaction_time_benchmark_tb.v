`timescale 1ms/1us
module reaction_time_benchmark_tb;

  // Parameters
  parameter CLK_PERIOD = 0.01;
  parameter RESET_TIME = 0.02; 
  
  // Inputs
  reg clk;
  reg rst;
  reg start_trigger;
  reg user_trigger;
  
  // Outputs
  wire [3:0] ms;
  wire [1:0] display_select;
  wire [6:0] segments;
  
  // Instantiate the DUT (Design Under Test)
  reaction_time_benchmark dut (
    .clk(clk),
    .rst(rst),
    .start_trigger(start_trigger),
    .user_trigger(user_trigger),
    .ms(ms),
    .display_select(display_select)
  );
  
  // Instantiate the seven_segment_display module
  seven_segment_display disp (
    .number(ms),
    .segments(segments) // Connect the 'segments' wire
  );
  
  // Clock generation
  always #CLK_PERIOD clk = ~clk;
  
  // Reset generation
  initial begin
    clk=0;
    rst = 1;
    #RESET_TIME;
    rst = 0;
  end
  
  // Stimulus generation
  initial begin
    start_trigger = 0;
    user_trigger = 0;
    #0.1; // Wait some time before starting the benchmark
  
    // Start the benchmark
    start_trigger = 1;
    #0.2; // Wait for a few clock cycles to let the benchmark run
    start_trigger = 0;
  
    // Simulate some user responses at different times
    #1230; user_trigger = 1; #10; user_trigger = 0;
    #1000;

    start_trigger = 1;
    #0.2; // Wait for a few clock cycles to let the benchmark run
    start_trigger = 0;

    #1450; user_trigger = 1; #10; user_trigger = 0;
    // Wait for the benchmark to finish
    #10;
  
    // End the simulation
    $finish;
  end
  
  // Monitor
  always @(posedge clk) begin
    $display("Time: %0dms, Display Select: %b, ms: %d",
      $time, display_select, ms);
  end
  
endmodule

