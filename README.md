# Reaction Time Benchmark FPGA Project

## Overview

This project implements a digital reaction time tester on an FPGA platform. It measures how quickly a user can respond to a visual stimulus and displays the reaction time on a 4-digit seven-segment display.

## Components

### 1. Reaction Time Benchmark Core(reaction_time_benchmark.v)

The main module that:

- Manages the game state machine (Idle → Start → React → Show)
- Measures reaction time
- Controls display output

### 2. Random Number Generator(lcg_random_number_generator.v)

Implements a Linear Congruential Generator (LCG) for generating random delays, using:

- Multiplier (A): 22695477
- Increment (C): 1
- Modulus (M): 65536

### 3. Seven Segment Display Controller(seven_segment_display.v)

Handles the 4-digit seven-segment display output, converting decimal numbers to the appropriate segment patterns.

## How It Works

1. **Initial State**: System starts in IDLE state, waiting for user input
2. **Start Phase**: When start button is pressed, system waits for a random delay
3. **Reaction Phase**: LED lights up, waiting for user response
4. **Display Phase**: Shows the measured reaction time in milliseconds

## Usage

1. Press the start button to begin
2. Wait for the LED indicator (react signal)
3. Press the response button as quickly as possible when the LED lights up
4. Read your reaction time on the 4-digit display
5. Press start again to retry

## Technical Details

- Clock frequency: 100MHz (10ns period)
- Reaction time measured in milliseconds
- Random delay generated using LCG algorithm
- 4-digit multiplexed seven-segment display
- Maximum displayable time: 9999ms

## Testing

A testbench is provided(reaction_time_benchmark_tb.v):

The testbench simulates multiple reaction scenarios and provides timing verification.

## Pin Assignments

- `clk`: System clock input
- `rst`: Active-high reset
- `start_trigger`: Start button input
- `user_trigger`: Reaction button input
- `react`: LED output indicator
- `segments[6:0]`: Seven-segment display outputs
- `digit_select[3:0]`: Digit selection outputs
