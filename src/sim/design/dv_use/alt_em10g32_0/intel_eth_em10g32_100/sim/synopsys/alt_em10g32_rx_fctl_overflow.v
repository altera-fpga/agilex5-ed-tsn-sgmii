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

module alt_em10g32_rx_fctl_overflow
(
   // Clock and reset
   input mac_rx_clk,
   input mac_rx_rst_b,

   // CSR signals
   output overflow_event,
   output drop_event,

   // Avalon-ST Sink
   input rx_pa2ovf_frm_sop,
   input rx_pa2ovf_frm_valid,
   input rx_pa2ovf_frm_eop,
   input [31:0] rx_pa2ovf_frm_data,
   input [1:0] rx_pa2ovf_frm_empty,
   input rx_pa2ovf_frm_error,

   // Avalon-ST Source
   output rx_fctl2top_frm_sop,
   output rx_fctl2top_frm_valid,
   input rx_top2fctl_frm_ready,
   output rx_fctl2top_frm_eop,
   output [31:0] rx_fctl2top_frm_data,
   output [1:0] rx_fctl2top_frm_empty,
   output [1:0] rx_fctl2top_frm_error
);

wire overflow;
reg overflow_reg;
reg eop_extend;
reg frame_dropped;
wire eop_in_valid;
wire sop_in_valid;

// EOP and SOP for Avalon-ST sink that is qualified with valid signal
assign eop_in_valid = rx_pa2ovf_frm_eop & rx_pa2ovf_frm_valid;
assign sop_in_valid = rx_pa2ovf_frm_sop & rx_pa2ovf_frm_valid;

// Overflow occurs when the data is valid but external data sink is not ready
assign overflow = ~rx_top2fctl_frm_ready & rx_fctl2top_frm_valid;

// SYNC_RESET FLOPS
// overflow_reg
// Register the overflow condition and 
// clear it when the current frame is EOP
always @(posedge mac_rx_clk)
begin
   if (~mac_rx_rst_b)
   begin
      overflow_reg <= 1'b0;
   end
   else
   begin
      if (overflow & ~rx_fctl2top_frm_eop)
      begin
         overflow_reg <= 1'b1;
      end
      else if (eop_in_valid)
      begin
         overflow_reg <= 1'b0;
      end
   end
end

// SYNC_RESET FLOPS
// eop_extend
// Extend the EOP of the current frame if overflow is occuring during the
// EOP cycle, until this EOP is accepted by external sink
always @(posedge mac_rx_clk)
begin
   if (~mac_rx_rst_b)
   begin
      eop_extend <= 1'b0;
   end
   else
   begin
      if (rx_fctl2top_frm_eop & overflow)
      begin
         eop_extend <= 1'b1;
      end 
      else if (rx_fctl2top_frm_valid & rx_top2fctl_frm_ready)
      begin
         eop_extend <= 1'b0;
      end
   end
end

// SYNC_RESET FLOPS
// frame_dropped
// A frame is consider dropped if 
// EOP from the last frame is extended until SOP of current frame
// or overflow happened during the SOP of the current frame
always @(posedge mac_rx_clk)
begin
   if (~mac_rx_rst_b)
   begin
      frame_dropped <= 1'b0;
   end
   else
   begin
      if ((eop_extend | overflow) & sop_in_valid)
      begin
         frame_dropped <= 1'b1;
      end 
      else if (eop_in_valid)
      begin
         frame_dropped <= 1'b0;
      end
   end
end

assign rx_fctl2top_frm_data = rx_pa2ovf_frm_data;
assign rx_fctl2top_frm_empty = rx_pa2ovf_frm_empty;

// rx_fctl2top_frm_valid
// Asserted only when
// EOP is extended
// or if the frame is not dropped, incoming frame is valid
assign rx_fctl2top_frm_valid = eop_extend |
   ((rx_pa2ovf_frm_valid | overflow_reg) & ~frame_dropped);


// rx_fctl2top_frm_eop
// Asserted only when
// EOP is extended
// or if the frame is not dropped, incoming frame is EOP
assign rx_fctl2top_frm_eop = eop_extend |
   (eop_in_valid & ~frame_dropped);

// rx_fctl2top_frm_sop
// Asserted only when
// and this frame is not affected by EOP from last frame
assign rx_fctl2top_frm_sop = (sop_in_valid) & ~eop_extend;

// rx_fctl2top_frm_error
// Pass through the incoming frame error signal at bit 0
// and overflow error and EOP is extended at bit 1
assign rx_fctl2top_frm_error = {(overflow_reg | eop_extend), rx_pa2ovf_frm_error};

// overflow_event
// Asserted at the EOP of the frame if current frame has overflow scenario
assign overflow_event = (overflow | overflow_reg) & ~frame_dropped & eop_in_valid;

// drop_event
// Asserted at the EOP of the frame if current frame is dropped
assign drop_event = frame_dropped & eop_in_valid;

endmodule
