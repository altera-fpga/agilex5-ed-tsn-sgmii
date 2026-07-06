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


`timescale 1 ps / 1 ps

module alt_em10g32_rx_fctl_preamble
(
   // Clock and reset
   input mac_rx_clk,
   input mac_rx_rst_b,

   // Configuration registers
   input csr_rx_preamb_fwd_ctl,

   // Data path sink
   input rx_pcrem2pa_frm_sop,
   input rx_pcrem2pa_frm_valid,
   input rx_pcrem2pa_frm_eop,
   input [31:0] rx_pcrem2pa_frm_data,
   input [1:0] rx_pcrem2pa_frm_empty,
   input rx_pcrem2pa_frm_error,

   // Data path source
   output rx_pa2ovf_frm_sop,
   output rx_pa2ovf_frm_valid,
   output rx_pa2ovf_frm_eop,
   output [31:0] rx_pa2ovf_frm_data,
   output [1:0] rx_pa2ovf_frm_empty,
   output rx_pa2ovf_frm_error
);

reg sop_reg_0, sop_reg_1;
reg eop_reg_0, eop_reg_1;
reg valid_reg_0, valid_reg_1;
reg [31:0] data_reg_0, data_reg_1;
reg [1:0] empty_reg_0, empty_reg_1;
reg error_reg_0, error_reg_1;

// If preamble pass through is enabled, pipeline the sink input by 2 clock cycle 
// and extend the sop and valid signal to include the preamble values
// 
// If preamble pass through is not enabled, just pass the pipelined register to outputs
assign rx_pa2ovf_frm_sop = csr_rx_preamb_fwd_ctl ? 
   rx_pcrem2pa_frm_sop:
   sop_reg_1;

// If preamble pass through is enabled, extend the valid 2 cycle earlier to include
// preamble values
assign rx_pa2ovf_frm_valid = csr_rx_preamb_fwd_ctl ? 
   (valid_reg_1 | (rx_pcrem2pa_frm_valid & rx_pcrem2pa_frm_sop) | (valid_reg_0 & sop_reg_0)):
   valid_reg_1;
assign rx_pa2ovf_frm_eop = eop_reg_1;
assign rx_pa2ovf_frm_data = data_reg_1;
assign rx_pa2ovf_frm_empty = empty_reg_1;
assign rx_pa2ovf_frm_error = error_reg_1;

// SYNC_RESET FLOPS
// Pipeline registers
always @(posedge mac_rx_clk)
begin
   if (~mac_rx_rst_b)
   begin
      {sop_reg_1, sop_reg_0} <= 2'b0;
      {eop_reg_1, eop_reg_0} <= 2'b0;
      {valid_reg_1, valid_reg_0} <= 2'b0;
   end
   else
   begin
      {sop_reg_1, sop_reg_0} <= {sop_reg_0, rx_pcrem2pa_frm_sop};
      {eop_reg_1, eop_reg_0} <= {eop_reg_0,rx_pcrem2pa_frm_eop};
      {valid_reg_1, valid_reg_0} <= {valid_reg_0,rx_pcrem2pa_frm_valid};
   end
end

// NON_RESETABLE FLOPS
// Pipeline registers
always @(posedge mac_rx_clk)
begin
   {data_reg_1, data_reg_0} <= {data_reg_0,rx_pcrem2pa_frm_data};
   {empty_reg_1, empty_reg_0} <= {empty_reg_0,rx_pcrem2pa_frm_empty};
   {error_reg_1, error_reg_0} <= {error_reg_0,rx_pcrem2pa_frm_error};
end

endmodule
