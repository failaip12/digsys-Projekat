`timescale 1ms/1us
module reaction_time_benchmark_tb;

  parameter CLK_PERIOD = 0.01;
  parameter RESET_TIME = 0.02; 
  
  reg clk;
  reg rst;
  reg start_trigger;
  reg user_trigger;
  
  wire [3:0] ms;
  wire [1:0] display_select;
  wire react;
  wire [6:0] segments;
  wire [3:0] digit_select;
  wire [15:0] random_number;

  reaction_time_benchmark dut (
    .clk(clk),
    .rst(rst),
    .start_trigger(start_trigger),
    .user_trigger(user_trigger),
    .random_delay(random_number),
    .ms(ms),
    .react(react),
    .display_select(display_select)
  );
  

  seven_segment_display disp (
    .number(ms),
    .display_select(display_select),
    .segments(segments),
    .digit_select(digit_select)
  );

  lcg_random_number_generator rng (
    .clk(clk),
    .rst(rst),
    .random_number(random_number)
  );
  

  always #CLK_PERIOD clk = ~clk;
  

  initial begin
    clk=0;
    rst = 1;
    #RESET_TIME;
    rst = 0;
  end
  

  initial begin
    start_trigger = 0;
    user_trigger = 0;
    #0.1; 
  
    
    start_trigger = 1;
    #0.2;
    start_trigger = 0;
  
    
    #1230; user_trigger = 1; #10; user_trigger = 0;
    #1000;

    start_trigger = 1;
    #0.2; 
    start_trigger = 0;

    #1450; user_trigger = 1; #10; user_trigger = 0;
    
    #10;
  
    
    $finish;
  end
  
  reg [10:0] counter = 0; 

  always @(posedge clk) begin
      if (counter == 500) begin
          $display("Time: %0dms, Display Select: %b, ms: %d",
            $time, display_select, ms);
          counter <= 0;
      end else begin
          counter <= counter + 1; 
      end
  end
  
endmodule
