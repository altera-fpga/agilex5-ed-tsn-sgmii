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


// (C) 2001-2017 Intel Corporation. All rights reserved.
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
// interface from fast clock domain to slow clock domain
// Please ensure that the fast and slow clock relationship
// has 0 phase difference and 
// the frequency of fast clock is 2x of slow clock
module alt_tse16_8_to_16_gmii_conversion
(
   // Fast clock and reset (312.5 MHz)
   input  wire          clk_gmii_in,
   input  wire          reset_gmii_in_n,
   //clock enable
   input  wire          tx_16b_clkena,
   input  wire          tx_clkena,
   // Slow clock and reset (156.25 MHz)
   input  wire          clk_gmii16b_out,
   input  wire          reset_gmii16b_out_n,
 
   // XGMII data and control in fast clock domain
   input  wire [7:0]    gmii_data_in,
   input  wire [0:0]    gmii_control_in,
   input   wire [0:0]   gmii_error_in,
   // XGMII data and control in slow clock domain
   output reg  [15:0]   gmii16b_data_out,
   output reg  [1:0]    gmii16b_control_out,
   output reg  [1:0]    gmii16b_error_out
);
 
//localparam SYM_IDLE           = 8'h07;
 
reg [7:0] gmii_data_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg [0:0]  gmii_control_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg [0:0]  gmii_error_in_reg /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg phase_reg_slow_clock /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg phase_reg_fast_clock;
reg phase_reg_fast_clock_reg0;
reg phase_reg_fast_clock_reg1;
reg phase_reg_fast_clock_reg2;
 
reg conversion_ready /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
reg phase;
 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Phase detection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @(posedge clk_gmii_in or negedge reset_gmii_in_n)
begin
   if (~reset_gmii_in_n)
   begin
      phase_reg_fast_clock <= 1'b0;
      phase_reg_fast_clock_reg0 <= 1'b1;
      phase_reg_fast_clock_reg1 <= 1'b0;
      phase_reg_fast_clock_reg2 <= 1'b1;
 
      conversion_ready <= 1'b0;
 
      phase <= 1'b0;
   end
   else
   begin
      phase_reg_fast_clock <= phase_reg_slow_clock;
      phase_reg_fast_clock_reg0 <= phase_reg_fast_clock;
      phase_reg_fast_clock_reg1 <= phase_reg_fast_clock_reg0;
      phase_reg_fast_clock_reg2 <= phase_reg_fast_clock_reg1;
 
      // Looking for 0011 or 1100 condition to ensure the
      // slow clock domain is out of reset to confirm the clock phase
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
 
always @ (posedge clk_gmii16b_out or negedge reset_gmii16b_out_n)
begin
   if (~reset_gmii16b_out_n)
   begin
      phase_reg_slow_clock <= 1'b0;
   end
   else
   begin
      phase_reg_slow_clock <= ~phase_reg_slow_clock;
   end
end
 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data Path
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
always @ (posedge clk_gmii16b_out or negedge reset_gmii16b_out_n)
begin
   if (~reset_gmii16b_out_n)
   begin
        gmii16b_data_out <= 16'b0;
        gmii16b_control_out <= 2'b0;
        gmii16b_error_out <= 2'b0;
   end
   else
   begin
   if (tx_16b_clkena) begin
      if (conversion_ready)
      begin
         gmii16b_data_out <= {gmii_data_in, gmii_data_in_reg};
         gmii16b_control_out <= {gmii_control_in, gmii_control_in_reg};
         gmii16b_error_out <= {gmii_error_in,gmii_error_in_reg};
      end
      else
      begin
         gmii16b_data_out <= 16'b0;
         gmii16b_control_out <= 2'b0;
        gmii16b_error_out <= 2'b0;
      end
    end
   end
end
 
// NON_RESETABLE FLOPS
always @(posedge clk_gmii_in)
begin
if (tx_clkena) begin
   gmii_data_in_reg <= gmii_data_in;
   gmii_control_in_reg <= gmii_control_in;
   gmii_error_in_reg <= gmii_error_in;
   end
end
 
endmodule