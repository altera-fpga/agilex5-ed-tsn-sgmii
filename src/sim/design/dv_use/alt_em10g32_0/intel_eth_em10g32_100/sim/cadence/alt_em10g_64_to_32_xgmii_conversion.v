// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


`timescale 1ps/1ps

// This is the module that converts the XGMII
// interface from slow clock domain to fast clock domain
// Please ensure that the fast and slow clock relationship
// has 0 phase difference and 
// the frequency of fast clock is 2x of slow clock
module alt_em10g_64_to_32_xgmii_conversion
(
   // Slow clock and reset (156.25 MHz)
   input  wire          clk_xgmii_in,
   input  wire          reset_xgmii_in_n,
   
   // Fast clock and reset (312.25 MHz)
   input  wire          clk_xgmii_out,
   input  wire          reset_xgmii_out_n,

   // XGMII data and control in slow clock domain
   input  wire [63:0]   xgmii_data_in,
   input  wire [7:0]    xgmii_control_in,

   // XGMII data and control in fast clock domain
   output reg  [31:0]   xgmii_data_out,
   output reg  [3:0]    xgmii_control_out,

   // 1588 related signals
   input  wire [15:0]   xgmii_rx_path_latency,
   output wire [16:0]   st_rx_path_latency,
   output reg           phase
);
localparam SYM_IDLE           = 8'h07;

reg [63:0] xgmii_data_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg [7:0] xgmii_control_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg [15:0] xgmii_rx_path_latency_reg /* synthesis altera_attribute="suppress_da_rule_internal=\"D101,D102\"" */;

reg phase_reg_slow_clock /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg phase_reg_fast_clock;
reg phase_reg_fast_clock_reg0;
reg phase_reg_fast_clock_reg1;
reg phase_reg_fast_clock_reg2;
reg conversion_ready /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;

reg reset_xgmii_in_n_pipe1;
reg reset_xgmii_in_n_pipe2;

reg reset_xgmii_out_n_pipe1;
reg reset_xgmii_out_n_pipe2;

always @ (posedge clk_xgmii_in)
    begin
    reset_xgmii_in_n_pipe1 <= reset_xgmii_in_n;
    reset_xgmii_in_n_pipe2 <= reset_xgmii_in_n_pipe1;
    end
    
always @ (posedge clk_xgmii_out)
    begin
    reset_xgmii_out_n_pipe1 <= reset_xgmii_out_n;
    reset_xgmii_out_n_pipe2 <= reset_xgmii_out_n_pipe1;
    end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Phase detection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// phase_reg_slow_clock is toggling in slow clock domain
always @ (posedge clk_xgmii_in)
begin
   if (~reset_xgmii_in_n_pipe2)
   begin
      phase_reg_slow_clock <= 1'b0;
   end
   else
   begin
      phase_reg_slow_clock <= ~phase_reg_slow_clock;
   end
end

always @(posedge clk_xgmii_out)
begin
   if (~reset_xgmii_out_n_pipe2)
   begin
      phase_reg_fast_clock <= 1'b0;
      phase_reg_fast_clock_reg0 <= 1'b1;
      phase_reg_fast_clock_reg1 <= 1'b0;
      phase_reg_fast_clock_reg2 <= 1'b1;
      
      phase <= 1'b0;
      conversion_ready <= 1'b0;
   end
   else
   begin
      phase_reg_fast_clock <= phase_reg_slow_clock;
      phase_reg_fast_clock_reg0 <= phase_reg_fast_clock;
      phase_reg_fast_clock_reg1 <= phase_reg_fast_clock_reg0;
      phase_reg_fast_clock_reg2 <= phase_reg_fast_clock_reg1;

      // Looking for 0011 or 1100 condition to ensure the
      // slow clock domain is out of reset, and to confirm the clock phase
      // relationship
      // conversion_ready is set to 1 once 0011 or 1100 pattern is found
      // to enable the output MUX
      // phase register is set to 1 once 0011 or 1100 pattern is found
      // and toggle with conversion_ready == 1
      if ((phase_reg_fast_clock == phase_reg_fast_clock_reg0) 
         && (phase_reg_fast_clock_reg0 != phase_reg_fast_clock_reg1)
         && (phase_reg_fast_clock_reg1 == phase_reg_fast_clock_reg2)
         )
      begin
         conversion_ready <= 1'b1;
         phase <= 1'b1;
      end
      else
      begin
         if (conversion_ready)
            phase <= ~phase;
      end
   end
end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data Path
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// NON_RESETABLE FLOPS
// Latching xgmii_data_in and xgmii_control_in in slow clock domain
always @ (posedge clk_xgmii_in)
begin
   xgmii_data_in_reg <= xgmii_data_in;
   xgmii_control_in_reg <= xgmii_control_in;
end

// phase_reg_slow_clock is toggling in slow clock domain
always @ (posedge clk_xgmii_in)
begin
   if (~reset_xgmii_in_n_pipe2)
   begin
      xgmii_rx_path_latency_reg <= 16'b0;
   end
   else
   begin
      xgmii_rx_path_latency_reg <= xgmii_rx_path_latency;
   end
end

// xgmii_data_out and xgmii_control_out mux
// Clock crossing from clk_xgmii_in to clk_xgmii_out
always @(phase or xgmii_data_in_reg or xgmii_control_in_reg or conversion_ready)
begin
   if (~conversion_ready)
   begin
      xgmii_data_out = {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
      xgmii_control_out =4'hF;
   end
   else
   begin
      if (~phase)
      begin
         xgmii_data_out = xgmii_data_in_reg [31:0];
         xgmii_control_out = xgmii_control_in_reg [3:0];
      end
      else
      begin
         xgmii_data_out = xgmii_data_in_reg [63:32];
         xgmii_control_out = xgmii_control_in_reg [7:4];
      end
   end
end

// Multiply by 2
// Clock crossing from clk_xgmii_in to clk_xgmii_out
assign st_rx_path_latency = {xgmii_rx_path_latency_reg[15:0],1'b0};

endmodule
