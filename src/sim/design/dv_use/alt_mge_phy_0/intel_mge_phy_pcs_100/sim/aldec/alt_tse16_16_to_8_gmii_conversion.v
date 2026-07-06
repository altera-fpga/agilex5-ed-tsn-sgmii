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


// (C) 2001-2011 Intel Corporation. All rights reserved.
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
 
// This is the module that converts the GMII
// interface from slow clock domain to fast clock domain
// Please ensure that the fast and slow clock relationship
// has 0 phase difference and 
// the frequency of fast clock is 2x of slow clock
module alt_tse16_16_to_8_gmii_conversion
(
   // Slow clock and reset (62.5 MHz)
   input  wire          clk_gmii_in,
   input  wire          reset_gmii_in_n,
   
   // Fast clock and reset (125 MHz)
   input  wire          clk_gmii_out,
   input  wire          reset_gmii_out_n,
  //clock enable
   input  wire          rx_16b_clkena,
   input  wire          rx_clkena,
   // GMII data and control in slow clock domain
   input  wire [15:0]   gmii16b_data_in,
   input  wire [1:0]    gmii16b_control_in,
   input  wire [1:0]    gmii16b_error_in,
   // GMII data and control in fast clock domain
   output reg  [7:0]    gmii_data_out,
   output reg      gmii_control_out,
   output reg      gmii_error_out
);
//localparam SYM_IDLE           = 8'h01;
reg phase;
reg [15:0] gmii16b_data_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg [1:0] gmii16b_control_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg [1:0] gmii16b_error_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
 
reg phase_reg_slow_clock /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg phase_reg_fast_clock;
reg phase_reg_fast_clock_reg0;
reg phase_reg_fast_clock_reg1;
reg phase_reg_fast_clock_reg2;
reg conversion_ready /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
 
reg reset_gmii_in_n_pipe1;
reg reset_gmii_in_n_pipe2;
 
reg reset_gmii_out_n_pipe1;
reg reset_gmii_out_n_pipe2;
 
always @ (posedge clk_gmii_in)
    begin
    reset_gmii_in_n_pipe1 <= reset_gmii_in_n;
    reset_gmii_in_n_pipe2 <= reset_gmii_in_n_pipe1;
    end
    
always @ (posedge clk_gmii_out)
    begin
    reset_gmii_out_n_pipe1 <= reset_gmii_out_n;
    reset_gmii_out_n_pipe2 <= reset_gmii_out_n_pipe1;
    end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Phase detection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
// phase_reg_slow_clock is toggling in slow clock domain
always @ (posedge clk_gmii_in)
begin
   if (~reset_gmii_in_n_pipe2)
   begin
      phase_reg_slow_clock <= 1'b0;
   end
   else
   begin
    if (rx_16b_clkena) begin
      phase_reg_slow_clock <= ~phase_reg_slow_clock;
    end
   end
end
 
always @(posedge clk_gmii_out)
begin
   if (~reset_gmii_out_n_pipe2)
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
   if (rx_clkena) begin
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
end
 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data Path
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
// NON_RESETABLE FLOPS
// Latching gmii_data_in and gmii_control_in in slow clock domain
always @ (posedge clk_gmii_in)
begin
if (rx_16b_clkena) begin
   gmii16b_data_in_reg <= gmii16b_data_in;
   gmii16b_control_in_reg <= gmii16b_control_in;
   gmii16b_error_in_reg  <= gmii16b_error_in;
   end
end
 
// gmii_data_out and gmii_control_out mux
// Clock crossing from clk_gmii_in to clk_gmii_out
always @(phase or gmii16b_data_in_reg or gmii16b_control_in_reg or conversion_ready or gmii16b_error_in_reg)
begin
 //  if (~conversion_ready)
  // begin
  //    gmii_data_out = 8'b0;
  //    gmii_control_out =1'b0;
  //    gmii_error_out  = 1'b0;
 //  end
 //  else
  // begin
      if (~phase)
      begin
         gmii_data_out = gmii16b_data_in_reg [7:0];
         gmii_control_out = gmii16b_control_in_reg[0] ;
         gmii_error_out = gmii16b_error_in_reg[0] ;
      end
      else
      begin
         gmii_data_out = gmii16b_data_in_reg [15:8];
         gmii_control_out = gmii16b_control_in_reg [1];
         gmii_error_out = gmii16b_error_in_reg [1];
      end
   //end
end
 
 
endmodule