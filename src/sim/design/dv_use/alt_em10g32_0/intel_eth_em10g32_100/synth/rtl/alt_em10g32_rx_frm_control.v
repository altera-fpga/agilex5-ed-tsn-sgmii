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
module alt_em10g32_rx_frm_control (
    // Parameter
    enable_preamble_passthrough,
    
    // Clock & Reset
    mac_rx_clk,
    mac_rx_rst_b,
    
    // Configuration from CSR
    csr_rx_allucast_en,
    csr_rx_allmcast_en,
    csr_rx_fwd_ctlfrm,
    csr_rx_fwd_pausefrm,
    csr_rx_pfc_fwd,
    csr_rx_crcpad_rem,
    csr_rx_preamb_fwd_ctl,
    
    // Overflow Event to CSR
    overflow_event,
    drop_event,
    
    // Frame Input Data
    rx_rs2fctl_frm_data,
    rx_rs2fctl_frm_sop,
    rx_rs2fctl_frm_eop,
    rx_rs2fctl_frm_valid,
    rx_rs2fctl_frm_empty,
    rx_rs2fctl_frm_error,
    
    // Frame Output Data
    rx_fctl2top_frm_data,
    rx_fctl2top_frm_sop,
    rx_fctl2top_frm_eop,
    rx_fctl2top_frm_valid,
    rx_fctl2top_frm_empty,
    rx_fctl2top_frm_error,
    rx_top2fctl_frm_ready,
    
    // Frame Info for CRC/Pad Remover
    rx_fd2pcrem_info_valid,
    rx_fd2pcrem_info_length_type,
    rx_fd2pcrem_info_length_frm,
    rx_fd2pcrem_info_ctrl_frm,
    
    // Frame Drop Info
    rx_fd2flt_info_valid,
    rx_fd2flt_info_da_matched,
    rx_fd2flt_info_unicast,
    rx_fd2flt_info_multicast,
    rx_fd2flt_info_broadcast,
    rx_fd2flt_info_ctrl_frm,
    rx_fd2flt_info_pause_frm,
    rx_fd2flt_info_pfc_frm,
    
    // Frame Drop Behavior
    frm_drop_ctrl_pfc_behavior,
    
    // 1588 Aligner
    rx_ovfin2ptp_sop,
    rx_ovfin2ptp_valid
);

// Parameter
input               enable_preamble_passthrough;

// Clock & Reset
input               mac_rx_clk;
input               mac_rx_rst_b;

// Configuration from CSR
input               csr_rx_allucast_en;
input               csr_rx_allmcast_en;
input               csr_rx_fwd_ctlfrm;
input               csr_rx_fwd_pausefrm;
input               csr_rx_pfc_fwd;
input      [ 1:0]   csr_rx_crcpad_rem;
input               csr_rx_preamb_fwd_ctl;

// Overflow Event to CSR
output              overflow_event;
output              drop_event;

// Frame Input Data
input      [31:0]   rx_rs2fctl_frm_data;
input               rx_rs2fctl_frm_sop;
input               rx_rs2fctl_frm_eop;
input               rx_rs2fctl_frm_valid;
input      [ 1:0]   rx_rs2fctl_frm_empty;
input               rx_rs2fctl_frm_error;

// Frame Output Data
output     [31:0]   rx_fctl2top_frm_data;
output              rx_fctl2top_frm_sop;
output              rx_fctl2top_frm_eop;
output              rx_fctl2top_frm_valid;
output     [ 1:0]   rx_fctl2top_frm_empty;
output     [ 1:0]   rx_fctl2top_frm_error;
input               rx_top2fctl_frm_ready;

// Frame Info for CRC/Pad Remover
input               rx_fd2pcrem_info_valid;
input      [15:0]   rx_fd2pcrem_info_length_type;
input               rx_fd2pcrem_info_length_frm;
input               rx_fd2pcrem_info_ctrl_frm;

// Frame Drop Info
input               rx_fd2flt_info_valid;
input               rx_fd2flt_info_da_matched;
input               rx_fd2flt_info_unicast;
input               rx_fd2flt_info_multicast;
input               rx_fd2flt_info_broadcast;
input               rx_fd2flt_info_ctrl_frm;
input               rx_fd2flt_info_pause_frm;
input               rx_fd2flt_info_pfc_frm;

// Frame Drop Behavior
input               frm_drop_ctrl_pfc_behavior;

// 1588 Aligner
output              rx_ovfin2ptp_sop;
output              rx_ovfin2ptp_valid;

// CRC/Pad Removal to Preamble
wire       [31:0]   rx_pcrem2pa_frm_data;
wire                rx_pcrem2pa_frm_sop;
wire                rx_pcrem2pa_frm_eop;
wire                rx_pcrem2pa_frm_valid;
wire       [ 1:0]   rx_pcrem2pa_frm_empty;
wire                rx_pcrem2pa_frm_error;
wire                rx_pcrem2pa_frm_ready;

// Preamble to Overflow (Output from Preamble)
wire       [31:0]   rx_pa2ovf_out_frm_data;
wire                rx_pa2ovf_out_frm_sop;
wire                rx_pa2ovf_out_frm_eop;
wire                rx_pa2ovf_out_frm_valid;
wire       [ 1:0]   rx_pa2ovf_out_frm_empty;
wire                rx_pa2ovf_out_frm_error;
wire                rx_pa2ovf_out_frm_ready;

// Preamble to Overflow (Input to Overflow)
wire       [31:0]   rx_pa2ovf_frm_data;
wire                rx_pa2ovf_frm_sop;
wire                rx_pa2ovf_frm_eop;
wire                rx_pa2ovf_frm_valid;
wire       [ 1:0]   rx_pa2ovf_frm_empty;
wire                rx_pa2ovf_frm_error;
wire                rx_pa2ovf_frm_ready;

alt_em10g32_rx_fctl_filter_crcpad_rem filter_crcpad_rem_inst(
    // Clock & Reset
    .mac_rx_clk                 (mac_rx_clk),
    .mac_rx_rst_b               (mac_rx_rst_b),
    
    // Configuration from CSR
    .csr_rx_allucast_en         (csr_rx_allucast_en),
    .csr_rx_allmcast_en         (csr_rx_allmcast_en),
    .csr_rx_fwd_ctlfrm          (csr_rx_fwd_ctlfrm),
    .csr_rx_fwd_pausefrm        (csr_rx_fwd_pausefrm),
    .csr_rx_pfc_fwd             (csr_rx_pfc_fwd),
    .csr_rx_crcpad_rem          (csr_rx_crcpad_rem),
    
    // Frame Input Data
    .rx_rs2fctl_frm_data        (rx_rs2fctl_frm_data),
    .rx_rs2fctl_frm_sop         (rx_rs2fctl_frm_sop),
    .rx_rs2fctl_frm_eop         (rx_rs2fctl_frm_eop),
    .rx_rs2fctl_frm_valid       (rx_rs2fctl_frm_valid),
    .rx_rs2fctl_frm_empty       (rx_rs2fctl_frm_empty),
    .rx_rs2fctl_frm_error       (rx_rs2fctl_frm_error),
    
    // Frame Output Data
    .rx_fltrpcrem2pa_frm_data   (rx_pcrem2pa_frm_data),
    .rx_fltrpcrem2pa_frm_sop    (rx_pcrem2pa_frm_sop),
    .rx_fltrpcrem2pa_frm_eop    (rx_pcrem2pa_frm_eop),
    .rx_fltrpcrem2pa_frm_valid  (rx_pcrem2pa_frm_valid),
    .rx_fltrpcrem2pa_frm_empty  (rx_pcrem2pa_frm_empty),
    .rx_fltrpcrem2pa_frm_error  (rx_pcrem2pa_frm_error),
    
    // Frame Info for CRC/Pad Remover
    .pad_rem_info_valid         (rx_fd2pcrem_info_valid),
    .pad_rem_info_length_type   (rx_fd2pcrem_info_length_type),
    .pad_rem_info_length_frm    (rx_fd2pcrem_info_length_frm),
    .pad_rem_info_ctrl_frm      (rx_fd2pcrem_info_ctrl_frm),
    
    // Frame Drop Info
    .frm_drop_info_valid        (rx_fd2flt_info_valid),
    .frm_drop_info_da_matched   (rx_fd2flt_info_da_matched),
    .frm_drop_info_unicast      (rx_fd2flt_info_unicast),
    .frm_drop_info_multicast    (rx_fd2flt_info_multicast),
    .frm_drop_info_broadcast    (rx_fd2flt_info_broadcast),
    .frm_drop_info_ctrl_frm     (rx_fd2flt_info_ctrl_frm),
    .frm_drop_info_pause_frm    (rx_fd2flt_info_pause_frm),
    .frm_drop_info_pfc_frm      (rx_fd2flt_info_pfc_frm),
    
    // Frame Drop Behavior
    .frm_drop_ctrl_pfc_behavior (frm_drop_ctrl_pfc_behavior)
);

alt_em10g32_rx_fctl_preamble preamble_inst(
   // Clock and reset
   .mac_rx_clk                  (mac_rx_clk),
   .mac_rx_rst_b                (mac_rx_rst_b),
   
   // Configuration registers
   .csr_rx_preamb_fwd_ctl       (csr_rx_preamb_fwd_ctl),
   
   // Data path sink
   .rx_pcrem2pa_frm_sop         (rx_pcrem2pa_frm_sop),
   .rx_pcrem2pa_frm_valid       (rx_pcrem2pa_frm_valid),
   .rx_pcrem2pa_frm_eop         (rx_pcrem2pa_frm_eop),
   .rx_pcrem2pa_frm_data        (rx_pcrem2pa_frm_data),
   .rx_pcrem2pa_frm_empty       (rx_pcrem2pa_frm_empty),
   .rx_pcrem2pa_frm_error       (rx_pcrem2pa_frm_error),
   
   // Data path source
   .rx_pa2ovf_frm_sop           (rx_pa2ovf_out_frm_sop),
   .rx_pa2ovf_frm_valid         (rx_pa2ovf_out_frm_valid),
   .rx_pa2ovf_frm_eop           (rx_pa2ovf_out_frm_eop),
   .rx_pa2ovf_frm_data          (rx_pa2ovf_out_frm_data),
   .rx_pa2ovf_frm_empty         (rx_pa2ovf_out_frm_empty),
   .rx_pa2ovf_frm_error         (rx_pa2ovf_out_frm_error)
);

assign rx_pa2ovf_frm_sop    = enable_preamble_passthrough ? rx_pa2ovf_out_frm_sop   : rx_pcrem2pa_frm_sop;
assign rx_pa2ovf_frm_valid  = enable_preamble_passthrough ? rx_pa2ovf_out_frm_valid : rx_pcrem2pa_frm_valid;
assign rx_pa2ovf_frm_eop    = enable_preamble_passthrough ? rx_pa2ovf_out_frm_eop   : rx_pcrem2pa_frm_eop;
assign rx_pa2ovf_frm_data   = enable_preamble_passthrough ? rx_pa2ovf_out_frm_data  : rx_pcrem2pa_frm_data;
assign rx_pa2ovf_frm_empty  = enable_preamble_passthrough ? rx_pa2ovf_out_frm_empty : rx_pcrem2pa_frm_empty;
assign rx_pa2ovf_frm_error  = enable_preamble_passthrough ? rx_pa2ovf_out_frm_error : rx_pcrem2pa_frm_error;

alt_em10g32_rx_fctl_overflow overflow_inst(
   // Clock and reset
   .mac_rx_clk                  (mac_rx_clk),
   .mac_rx_rst_b                (mac_rx_rst_b),
    
   // CSR signals
   .overflow_event              (overflow_event),
   .drop_event                  (drop_event),
    
   // Avalon-ST Sink
   .rx_pa2ovf_frm_sop           (rx_pa2ovf_frm_sop),
   .rx_pa2ovf_frm_valid         (rx_pa2ovf_frm_valid),
   .rx_pa2ovf_frm_eop           (rx_pa2ovf_frm_eop),
   .rx_pa2ovf_frm_data          (rx_pa2ovf_frm_data),
   .rx_pa2ovf_frm_empty         (rx_pa2ovf_frm_empty),
   .rx_pa2ovf_frm_error         (rx_pa2ovf_frm_error),
   
   // Avalon-ST Source
   .rx_fctl2top_frm_sop         (rx_fctl2top_frm_sop),
   .rx_fctl2top_frm_valid       (rx_fctl2top_frm_valid),
   .rx_fctl2top_frm_eop         (rx_fctl2top_frm_eop),
   .rx_fctl2top_frm_data        (rx_fctl2top_frm_data),
   .rx_fctl2top_frm_empty       (rx_fctl2top_frm_empty),
   .rx_fctl2top_frm_error       (rx_fctl2top_frm_error),
   .rx_top2fctl_frm_ready       (rx_top2fctl_frm_ready)
);

// 1588 Aligner
assign rx_ovfin2ptp_sop = rx_pa2ovf_frm_sop;
assign rx_ovfin2ptp_valid = rx_pa2ovf_frm_valid;

endmodule
