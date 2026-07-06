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
module alt_em10g32_rx_top (
    // Parameter
    enable_preamble_passthrough,
    
    // Clock & Reset
    xgmii_rx_clk,
    xgmii_rx_rst_b,
    
    // Configuration from CSR
    csr_rx_tsfr_en_n,
    csr_rx_tsfr_sts,
    csr_rx_primaddr,
    csr_rx_suppaddr_en0,
    csr_rx_suppaddr_en1,
    csr_rx_suppaddr_en2,
    csr_rx_suppaddr_en3,
    csr_rx_supp_macaddr_0,
    csr_rx_supp_macaddr_1,
    csr_rx_supp_macaddr_2,
    csr_rx_supp_macaddr_3,
    csr_rx_max_datafrmlen,
    csr_rxvlandet_dis,
    csr_rx_ignore_pausefrm,
    csr_rx_pfc_ignore_pausefrm_0,
    csr_rx_pfc_ignore_pausefrm_1,
    csr_rx_pfc_ignore_pausefrm_2,
    csr_rx_pfc_ignore_pausefrm_3,
    csr_rx_pfc_ignore_pausefrm_4,
    csr_rx_pfc_ignore_pausefrm_5,
    csr_rx_pfc_ignore_pausefrm_6,
    csr_rx_pfc_ignore_pausefrm_7,
    csr_rx_frm_info_user_type,
    csr_rx_allucast_en,
    csr_rx_allmcast_en,
    csr_rx_fwd_ctlfrm,
    csr_rx_fwd_pausefrm,
    csr_rx_pfc_fwd,
    csr_rx_crcpad_rem,
    csr_rx_preamb_fwd_ctl,
    csr_rx_preamble_passthru,
    csr_rx_crc_chk,
    csr_adjust_10g,
    csr_period_10g,
    csr_adjust_1g,
    csr_period_1g,
    
    // Frame Drop Behavior
    frm_drop_ctrl_pfc_behavior,
    
    // Overflow Event to CSR
    overflow_event,
    drop_event,
    
    // Speed Selection
    speed_sel,
    
    // XGMII Receive
    xgmii_rx_data,
    xgmii_rx_ctrl,
    xgmii_rx_valid,
    link_fault_status_xgmii_rx_data,
    
    // GMII Receive
    gmii_rx_clk,
    gmii_rx_rst_b,
    gmii_rx_d,
    gmii_rx_dv,
    gmii_rx_err,
    
    // GMII 16 bit receive
    gmii16b_rx_d,
    gmii16b_rx_dv,
    gmii16b_rx_err,

    // MII Receive
    mii_rx_clken,
    mii_rx_clken_half_rate,
    mii_rx_d,
    mii_rx_dv,
    mii_rx_err,
    
    // Avalon-ST Receive (User)
    avalon_st_rx_data,
    avalon_st_rx_sop,
    avalon_st_rx_eop,
    avalon_st_rx_valid,
    avalon_st_rx_empty,
    avalon_st_rx_error,
    avalon_st_rx_ready,
    
    // Frame Info (Statistics)
    avalon_st_rx_statistics_valid,
    avalon_st_rx_statistics_data,
    avalon_st_rx_statistics_error,
    
    // Frame Info (User Logic)
    avalon_st_rxstatus_valid,
    avalon_st_rxstatus_data,
    avalon_st_rxstatus_error,
    
    // Pause Quanta
    avalon_st_rx_pause_length_valid,
    avalon_st_rx_pause_length_data,
    
    // PFC XON/XOFF Status
    avalon_st_rx_pfc_status_valid,
    avalon_st_rx_pfc_status_data,
    
    // PFC Pause Data
    avalon_st_rx_pfc_pause_data,
    
    // 1588
    rx_path_delay_10g_data,
    rx_time_of_day_96b_10g_data,
    rx_time_of_day_64b_10g_data,
    
    rx_path_delay_1g_data,
    rx_time_of_day_96b_1g_data,
    rx_time_of_day_64b_1g_data,
    
    rx_ingress_timestamp_96b_valid,
    rx_ingress_timestamp_96b_data,
    rx_ingress_timestamp_64b_valid,
    rx_ingress_timestamp_64b_data,
	
	// bust bbit status
	rx_packet_in_progress_rs,
    
    // ECC Status
    rx_gmii_decoder_ecc_err_corrected,
    rx_gmii_decoder_ecc_err_fatal,
    rx_ptp_aligner_ecc_err_corrected,
    rx_ptp_aligner_ecc_err_fatal

);

// Parameter
parameter DEVICE_FAMILY = "Stratix V";
parameter ENABLE_MEM_ECC = 0;
parameter ENABLE_TIMESTAMPING = 0;
parameter RX_XGMII_ADAPTER_PATH_DELAY = 0;
parameter FORWARD_SYNC_DEPTH = 3;
parameter BACKWARD_SYNC_DEPTH = 3;
parameter ENABLE_10GBASER_REG_MODE = 0;
parameter ENABLE_1G10G_MAC = 0;
parameter ENABLE_GMII16B = 0;
parameter SYNC_RESET_N = 1;

input               enable_preamble_passthrough;

// Clock & Reset
input               xgmii_rx_clk;
input               xgmii_rx_rst_b;

// Configuration from CSR
input               csr_rx_tsfr_en_n;
output              csr_rx_tsfr_sts;
input      [47:0]   csr_rx_primaddr;
input               csr_rx_suppaddr_en0;
input               csr_rx_suppaddr_en1;
input               csr_rx_suppaddr_en2;
input               csr_rx_suppaddr_en3;
input      [47:0]   csr_rx_supp_macaddr_0;
input      [47:0]   csr_rx_supp_macaddr_1;
input      [47:0]   csr_rx_supp_macaddr_2;
input      [47:0]   csr_rx_supp_macaddr_3;
input      [15:0]   csr_rx_max_datafrmlen;
input               csr_rxvlandet_dis;
input               csr_rx_ignore_pausefrm;
input               csr_rx_pfc_ignore_pausefrm_0;
input               csr_rx_pfc_ignore_pausefrm_1;
input               csr_rx_pfc_ignore_pausefrm_2;
input               csr_rx_pfc_ignore_pausefrm_3;
input               csr_rx_pfc_ignore_pausefrm_4;
input               csr_rx_pfc_ignore_pausefrm_5;
input               csr_rx_pfc_ignore_pausefrm_6;
input               csr_rx_pfc_ignore_pausefrm_7;
input               csr_rx_frm_info_user_type;
input               csr_rx_allucast_en;
input               csr_rx_allmcast_en;
input               csr_rx_fwd_ctlfrm;
input               csr_rx_fwd_pausefrm;
input               csr_rx_pfc_fwd;
input      [ 1:0]   csr_rx_crcpad_rem;
input               csr_rx_preamb_fwd_ctl;
input               csr_rx_preamble_passthru;
input               csr_rx_crc_chk;
input      [31:0]   csr_adjust_10g;
input      [19:0]   csr_period_10g;
input      [31:0]   csr_adjust_1g;
input      [19:0]   csr_period_1g;

// Frame Drop Behavior
input               frm_drop_ctrl_pfc_behavior;

// Overflow Event to CSR
output              overflow_event;
output              drop_event;

// Speed Selection
input      [ 2:0]   speed_sel;

// XGMII Receive
input      [31:0]   xgmii_rx_data;
input      [ 3:0]   xgmii_rx_ctrl;
input               xgmii_rx_valid;
output     [ 1:0]   link_fault_status_xgmii_rx_data;

// GMII Receive
input               gmii_rx_clk;
input               gmii_rx_rst_b;
input      [ 7:0]   gmii_rx_d;
input               gmii_rx_dv;
input               gmii_rx_err;
    
// GMII 16 bit receive
input      [15:0]   gmii16b_rx_d;
input      [ 1:0]   gmii16b_rx_dv;
input      [ 1:0]   gmii16b_rx_err;

// MII Receive
input               mii_rx_clken;
input               mii_rx_clken_half_rate;
input      [ 3:0]   mii_rx_d;
input               mii_rx_dv;
input               mii_rx_err;

// Avalon-ST Receive (User)
output     [31:0]   avalon_st_rx_data;
output              avalon_st_rx_sop;
output              avalon_st_rx_eop;
output              avalon_st_rx_valid;
output     [ 1:0]   avalon_st_rx_empty;
output     [ 5:0]   avalon_st_rx_error;
input               avalon_st_rx_ready;

// Frame Info (Statistics)
output              avalon_st_rx_statistics_valid;
output     [39:0]   avalon_st_rx_statistics_data;
output     [ 6:0]   avalon_st_rx_statistics_error;

// Frame Info (User Logic)
output              avalon_st_rxstatus_valid;
output     [39:0]   avalon_st_rxstatus_data;
output     [ 6:0]   avalon_st_rxstatus_error;

// Pause Quanta
output              avalon_st_rx_pause_length_valid;
output     [15:0]   avalon_st_rx_pause_length_data;

// PFC XON/XOFF Status
output              avalon_st_rx_pfc_status_valid;
output     [15:0]   avalon_st_rx_pfc_status_data;

// PFC Pause Data
output     [ 7:0]   avalon_st_rx_pfc_pause_data;

// 1588 
//ED update path delay to 24 bits instead of 17
input      [23:0]   rx_path_delay_10g_data;
input      [95:0]   rx_time_of_day_96b_10g_data;
input      [63:0]   rx_time_of_day_64b_10g_data;

input      [21:0]   rx_path_delay_1g_data;
input      [95:0]   rx_time_of_day_96b_1g_data;
input      [63:0]   rx_time_of_day_64b_1g_data;

output              rx_ingress_timestamp_96b_valid;
output     [95:0]   rx_ingress_timestamp_96b_data;
output              rx_ingress_timestamp_64b_valid;
output     [63:0]   rx_ingress_timestamp_64b_data;

output				rx_packet_in_progress_rs;

// ECC Status
output              rx_gmii_decoder_ecc_err_corrected;
output              rx_gmii_decoder_ecc_err_fatal;
output              rx_ptp_aligner_ecc_err_corrected;
output              rx_ptp_aligner_ecc_err_fatal;

// Frame Data (From RS)
wire       [31:0]   rx_rs2fctl_frm_data;
wire                rx_rs2fctl_frm_sop;
wire                rx_rs2fctl_frm_eop;
wire                rx_rs2fctl_frm_valid;
wire       [ 1:0]   rx_rs2fctl_frm_empty;
wire                rx_rs2fctl_frm_error;

// Frame Data (From Frame Control)
wire       [31:0]   rx_fctl2align_frm_data;
wire                rx_fctl2align_frm_sop;
wire                rx_fctl2align_frm_eop;
wire                rx_fctl2align_frm_valid;
wire       [ 1:0]   rx_fctl2align_frm_empty;
wire       [ 1:0]   rx_fctl2align_frm_error;
wire                rx_align2fctl_frm_ready;

// Frame Info (Statistics)
wire                rx_fd2align_statistics_valid;
wire       [39:0]   rx_fd2align_statistics_data;
wire       [ 2:0]   rx_fd2align_statistics_error;

// Frame Info (User Logic)
wire                rx_fd2align_rxstatus_valid;
wire       [39:0]   rx_fd2align_rxstatus_data;
wire       [ 2:0]   rx_fd2align_rxstatus_error;

// Frame Info for CRC/Pad Remover
wire                rx_fd2pcrem_info_valid;
wire       [15:0]   rx_fd2pcrem_info_length_type;
wire                rx_fd2pcrem_info_length_frm;
wire                rx_fd2pcrem_info_ctrl_frm;

// Frame Drop Info
wire                rx_fd2flt_info_valid;
wire                rx_fd2flt_info_da_matched;
wire                rx_fd2flt_info_unicast;
wire                rx_fd2flt_info_multicast;
wire                rx_fd2flt_info_broadcast;
wire                rx_fd2flt_info_ctrl_frm;
wire                rx_fd2flt_info_pause_frm;
wire                rx_fd2flt_info_pfc_frm;

// Pause Quanta
wire                rx_fd2align_pause_pq_en;
wire       [15:0]   rx_fd2align_pause_pq;

// PFC Pause Quanta From Frame Decoder
wire                rx_fd2align_pfc_field_valid;
wire       [ 7:0]   rx_fd2align_pfc_pq_en;
wire       [15:0]   rx_fd2align_pfc_pq0;
wire       [15:0]   rx_fd2align_pfc_pq1;
wire       [15:0]   rx_fd2align_pfc_pq2;
wire       [15:0]   rx_fd2align_pfc_pq3;
wire       [15:0]   rx_fd2align_pfc_pq4;
wire       [15:0]   rx_fd2align_pfc_pq5;
wire       [15:0]   rx_fd2align_pfc_pq6;
wire       [15:0]   rx_fd2align_pfc_pq7;

// PFC Pause Quanta to Flow Control
wire                rx_align2flc_pfc_field_valid;
wire                rx_align2flc_pfc_pq0_en;
wire                rx_align2flc_pfc_pq1_en;
wire                rx_align2flc_pfc_pq2_en;
wire                rx_align2flc_pfc_pq3_en;
wire                rx_align2flc_pfc_pq4_en;
wire                rx_align2flc_pfc_pq5_en;
wire                rx_align2flc_pfc_pq6_en;
wire                rx_align2flc_pfc_pq7_en;
wire       [15:0]   rx_align2flc_pfc_pq0;
wire       [15:0]   rx_align2flc_pfc_pq1;
wire       [15:0]   rx_align2flc_pfc_pq2;
wire       [15:0]   rx_align2flc_pfc_pq3;
wire       [15:0]   rx_align2flc_pfc_pq4;
wire       [15:0]   rx_align2flc_pfc_pq5;
wire       [15:0]   rx_align2flc_pfc_pq6;
wire       [15:0]   rx_align2flc_pfc_pq7;

// PFC XON/XOFF Status
wire                rx_fd2align_pfc_status_valid;
wire       [15:0]   rx_fd2align_pfc_status_data;

// CRC32
wire                rx_crc2align_crc32_valid;
wire                rx_crc2align_crc32_good;
reg                 rx_crc32_clken_p1;
reg                 rx_crc32_clken_p2;
reg                 rx_crc32_clken_p3;
reg                 rx_crc32_clken_p4;

// Preamble Pass-through
wire                csr_rx_preamb_fwd_ctl_int;

// MII Alignment Status
wire                mii_alignment_status;

// 1588 Aligner
wire                rx_ovfin2ptp_sop;
wire                rx_ovfin2ptp_valid;

wire [7:0] 	    gmii_mii_rx_d;
wire                gmii_mii_rx_dv;
wire                gmii_mii_rx_err;

reg     xgmii_rx_rst_b_pipe1;
reg     xgmii_rx_rst_b_pipe2;
// reg     xgmii_rx_rst_b_pipe3;
// reg     xgmii_rx_rst_b_pipe4;
// reg     xgmii_rx_rst_b_pipe5;
// reg     xgmii_rx_rst_b_pipe6;

reg     gmii_rx_rst_b_pipe1;
reg     gmii_rx_rst_b_pipe2;
// reg     gmii_rx_rst_b_pipe3;
// reg     gmii_rx_rst_b_pipe4;
// reg     gmii_rx_rst_b_pipe5;
// reg     gmii_rx_rst_b_pipe6;

always @ (posedge xgmii_rx_clk)
    begin
    xgmii_rx_rst_b_pipe2 <= xgmii_rx_rst_b;
    xgmii_rx_rst_b_pipe1 <= xgmii_rx_rst_b_pipe2;
    // xgmii_rx_rst_b_pipe3 <= xgmii_rx_rst_b_pipe2;
    // xgmii_rx_rst_b_pipe4 <= xgmii_rx_rst_b_pipe3;
    // xgmii_rx_rst_b_pipe5 <= xgmii_rx_rst_b_pipe4;
    // xgmii_rx_rst_b_pipe6 <= xgmii_rx_rst_b_pipe5;
    end

always @ (posedge gmii_rx_clk)
    begin
    gmii_rx_rst_b_pipe2 <= gmii_rx_rst_b;
    gmii_rx_rst_b_pipe1 <= gmii_rx_rst_b_pipe2;
    // gmii_rx_rst_b_pipe3 <= gmii_rx_rst_b_pipe2;
    // gmii_rx_rst_b_pipe4 <= gmii_rx_rst_b_pipe3;
    // gmii_rx_rst_b_pipe5 <= gmii_rx_rst_b_pipe4;
    // gmii_rx_rst_b_pipe6 <= gmii_rx_rst_b_pipe5;
    end
    
 // To improve timing, pipeline 1 time for RX XGMII data signals , path_delay_data+internal_MAC_cycle will be pipeline 1 time in rx_ptp_top level
// Set SYNCHRONIZER_IDENTIFICATION=OFF because they are driving by same clock rx_312_5_clk
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg     [31:0]   xgmii_rx_data_reg;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg     [ 3:0]   xgmii_rx_ctrl_reg;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg              xgmii_rx_valid_reg;
wire     [31:0]   xgmii_rx_data_sel;
wire     [ 3:0]   xgmii_rx_ctrl_sel;
wire              xgmii_rx_valid_sel;

 always @ (posedge xgmii_rx_clk )
 begin

 xgmii_rx_data_reg <= xgmii_rx_data;
 xgmii_rx_ctrl_reg <= xgmii_rx_ctrl;
 xgmii_rx_valid_reg <= xgmii_rx_valid;
 end

assign xgmii_rx_data_sel = (ENABLE_TIMESTAMPING) ? xgmii_rx_data_reg : xgmii_rx_data ;
assign xgmii_rx_ctrl_sel = (ENABLE_TIMESTAMPING) ? xgmii_rx_ctrl_reg : xgmii_rx_ctrl ;
assign xgmii_rx_valid_sel = (ENABLE_TIMESTAMPING) ? xgmii_rx_valid_reg : xgmii_rx_valid ;
//End code 
//------------------------------------------------------------------------
// RS Layer
//------------------------------------------------------------------------
alt_em10g32_rx_rs_layer #(
    .DEVICE_FAMILY              (DEVICE_FAMILY),
    .ENABLE_MEM_ECC             (ENABLE_MEM_ECC),
    .FORWARD_SYNC_DEPTH         (FORWARD_SYNC_DEPTH),
    .BACKWARD_SYNC_DEPTH        (BACKWARD_SYNC_DEPTH),
    .ENABLE_10GBASER_REG_MODE   (ENABLE_10GBASER_REG_MODE),
    .ENABLE_1G10G_MAC           (ENABLE_1G10G_MAC),
    .ENABLE_GMII16B             (ENABLE_GMII16B),
    .ENABLE_TIMESTAMPING        (ENABLE_TIMESTAMPING),
    .SYNC_RESET_N               (SYNC_RESET_N)
) rs_layer(
    // Clock and reset
    .top2rs_xgmii_rx_clk        (xgmii_rx_clk),
    .top2rs_xgmii_rx_rst_b      (xgmii_rx_rst_b_pipe1),
    .top2rs_xgmii_rx_rst_b_asyn (xgmii_rx_rst_b),
    .top2rs_gmii_rx_clk         (gmii_rx_clk),
    .top2rs_gmii_rx_rst_b       (gmii_rx_rst_b_pipe1),
    .top2rs_gmii_rx_rst_b_asyn  (gmii_rx_rst_b),
    
    // Avalon-ST Data path
    .rx_rs2fctl_frm_sop         (rx_rs2fctl_frm_sop),
    .rx_rs2fctl_frm_eop         (rx_rs2fctl_frm_eop),
    .rx_rs2fctl_frm_empty       (rx_rs2fctl_frm_empty),
    .rx_rs2fctl_frm_valid       (rx_rs2fctl_frm_valid),
    .rx_rs2fctl_frm_error       (rx_rs2fctl_frm_error),
    .rx_rs2fctl_frm_data        (rx_rs2fctl_frm_data),
    
    // CSR control path
    .csr_rx_tsfr_en_n           (csr_rx_tsfr_en_n),
    .csr_rx_tsfr_sts            (csr_rx_tsfr_sts),
    .csr_rx_preamble_passthru   (csr_rx_preamble_passthru),
    
    // Speed selection
    .rx_top2rs_phy_speed        (speed_sel),
    
    // GMII/MII clock enable
    .rx_top2rs_mii_rx_clken         (mii_rx_clken),
    .rx_top2rs_mii_clken_half_rate  (mii_rx_clken_half_rate),
    
    // Link fault status
    .rx_rs2top_link_fault_status_xgmii_rx_data   (link_fault_status_xgmii_rx_data),
    
    // XGMII data
    .rx_top2rs_xgmii_rx_data    (xgmii_rx_data_sel),
    .rx_top2rs_xgmii_rx_ctrl    (xgmii_rx_ctrl_sel),
    .rx_top2rs_xgmii_rx_valid   (xgmii_rx_valid_sel),
    
    // GMII data
    .rx_top2rs_gmii_rx_d        (gmii_rx_d),
    .rx_top2rs_gmii_rx_dv       (gmii_rx_dv),
    .rx_top2rs_gmii_rx_err      (gmii_rx_err),

    // GMII 16 bit data
    .rx_top2rs_gmii16b_rx_d     (gmii16b_rx_d),
    .rx_top2rs_gmii16b_rx_dv    (gmii16b_rx_dv),
    .rx_top2rs_gmii16b_rx_err   (gmii16b_rx_err),
    
    // MII data
    .rx_top2rs_mii_rx_d         (mii_rx_d),
    .rx_top2rs_mii_rx_dv        (mii_rx_dv),
    .rx_top2rs_mii_rx_err       (mii_rx_err),

    // GMII/MII data for PTP
    .rx_rs2ptp_gmii_rx_d        (gmii_mii_rx_d),
    .rx_rs2ptp_gmii_rx_dv       (gmii_mii_rx_dv),
    .rx_rs2ptp_gmii_rx_err      (gmii_mii_rx_err),	   
    
    // MII Alignment Status
    .mii_alignment_status       (mii_alignment_status),

 	// status to report packet in progress
    .rx_packet_in_progress_rs	(rx_packet_in_progress_rs),
    
    // ECC Status
    .rx_gmii_decoder_ecc_err_corrected (rx_gmii_decoder_ecc_err_corrected),
    .rx_gmii_decoder_ecc_err_fatal     (rx_gmii_decoder_ecc_err_fatal)
);

//------------------------------------------------------------------------
// Frame Decoder
//------------------------------------------------------------------------
alt_em10g32_frm_decoder frm_decoder_inst(
    // Clock & Reset
    .clk                            (xgmii_rx_clk),
    .rst_n                          (xgmii_rx_rst_b_pipe1),
    
    // Configuration from CSR
    .csr_tx_crc_insrt_en            (1'b0),
    .csr_txvlandet_dis              (1'b0),
    .csr_rx_primaddr                (csr_rx_primaddr),
    .csr_rx_suppaddr_en0            (csr_rx_suppaddr_en0),
    .csr_rx_suppaddr_en1            (csr_rx_suppaddr_en1),
    .csr_rx_suppaddr_en2            (csr_rx_suppaddr_en2),
    .csr_rx_suppaddr_en3            (csr_rx_suppaddr_en3),
    .csr_rx_supp_macaddr_0          (csr_rx_supp_macaddr_0),
    .csr_rx_supp_macaddr_1          (csr_rx_supp_macaddr_1),
    .csr_rx_supp_macaddr_2          (csr_rx_supp_macaddr_2),
    .csr_rx_supp_macaddr_3          (csr_rx_supp_macaddr_3),
    .csr_rx_max_datafrmlen          (csr_rx_max_datafrmlen),
    .csr_rxvlandet_dis              (csr_rxvlandet_dis),
    .csr_rx_allucast_en             (csr_rx_allucast_en),
    .csr_rx_allmcast_en             (csr_rx_allmcast_en),
    .csr_rx_ignore_pausefrm         (csr_rx_ignore_pausefrm),
    .csr_rx_pfc_ignore_pausefrm_0   (csr_rx_pfc_ignore_pausefrm_0),
    .csr_rx_pfc_ignore_pausefrm_1   (csr_rx_pfc_ignore_pausefrm_1),
    .csr_rx_pfc_ignore_pausefrm_2   (csr_rx_pfc_ignore_pausefrm_2),
    .csr_rx_pfc_ignore_pausefrm_3   (csr_rx_pfc_ignore_pausefrm_3),
    .csr_rx_pfc_ignore_pausefrm_4   (csr_rx_pfc_ignore_pausefrm_4),
    .csr_rx_pfc_ignore_pausefrm_5   (csr_rx_pfc_ignore_pausefrm_5),
    .csr_rx_pfc_ignore_pausefrm_6   (csr_rx_pfc_ignore_pausefrm_6),
    .csr_rx_pfc_ignore_pausefrm_7   (csr_rx_pfc_ignore_pausefrm_7),
    .csr_rx_frm_info_user_type      (csr_rx_frm_info_user_type),
    
    // Frame Data
    .frm_data                       (rx_rs2fctl_frm_data),
    .frm_sop                        (rx_rs2fctl_frm_sop),
    .frm_eop                        (rx_rs2fctl_frm_eop),
    .frm_valid                      (rx_rs2fctl_frm_valid),
    .frm_empty                      (rx_rs2fctl_frm_empty),
    .frm_error                      (rx_rs2fctl_frm_error),
    
    // Frame Info (Statistics)
    .frm_info_stat_valid            (rx_fd2align_statistics_valid),
    .frm_info_stat_data             (rx_fd2align_statistics_data),
    .frm_info_stat_error            (rx_fd2align_statistics_error),
    
    // Frame Info (User Logic)
    .frm_info_user_valid            (rx_fd2align_rxstatus_valid),
    .frm_info_user_data             (rx_fd2align_rxstatus_data),
    .frm_info_user_error            (rx_fd2align_rxstatus_error),
    
    // Length/Type Field for CRC/Pad Remover
    .pad_rem_info_valid             (rx_fd2pcrem_info_valid),
    .pad_rem_info_length_type       (rx_fd2pcrem_info_length_type),
    .pad_rem_info_length_frm        (rx_fd2pcrem_info_length_frm),
    .pad_rem_info_ctrl_frm          (rx_fd2pcrem_info_ctrl_frm),
    
    // Frame Drop Info
    .frm_drop_info_valid            (rx_fd2flt_info_valid),
    .frm_drop_info_da_matched       (rx_fd2flt_info_da_matched),
    .frm_drop_info_unicast          (rx_fd2flt_info_unicast),
    .frm_drop_info_multicast        (rx_fd2flt_info_multicast),
    .frm_drop_info_broadcast        (rx_fd2flt_info_broadcast),
    .frm_drop_info_ctrl_frm         (rx_fd2flt_info_ctrl_frm),
    .frm_drop_info_pause_frm        (rx_fd2flt_info_pause_frm),
    .frm_drop_info_pfc_frm          (rx_fd2flt_info_pfc_frm),
    
    // Pause Quanta
    .pause_quanta_valid             (rx_fd2align_pause_pq_en),
    .pause_quanta                   (rx_fd2align_pause_pq),
    
    // PFC Pause Quanta
    .pfc_status_valid               (rx_fd2align_pfc_field_valid),
    .pfc_status_pause_quanta_valid  (rx_fd2align_pfc_pq_en),
    .pfc_status_pause_quanta_0      (rx_fd2align_pfc_pq0),
    .pfc_status_pause_quanta_1      (rx_fd2align_pfc_pq1),
    .pfc_status_pause_quanta_2      (rx_fd2align_pfc_pq2),
    .pfc_status_pause_quanta_3      (rx_fd2align_pfc_pq3),
    .pfc_status_pause_quanta_4      (rx_fd2align_pfc_pq4),
    .pfc_status_pause_quanta_5      (rx_fd2align_pfc_pq5),
    .pfc_status_pause_quanta_6      (rx_fd2align_pfc_pq6),
    .pfc_status_pause_quanta_7      (rx_fd2align_pfc_pq7),
    
    // PFC XON/XOFF Status
    .pfc_xonxoff_status_valid       (rx_fd2align_pfc_status_valid),
    .pfc_xonxoff_status_data        (rx_fd2align_pfc_status_data)
);

//------------------------------------------------------------------------
// Frame Control
//------------------------------------------------------------------------
assign csr_rx_preamb_fwd_ctl_int = (speed_sel == 3'b000) ? csr_rx_preamb_fwd_ctl : 1'b0;

alt_em10g32_rx_frm_control frm_control_inst(
    // Parameter
    .enable_preamble_passthrough    (enable_preamble_passthrough),
    
    // Clock & Reset
    .mac_rx_clk                     (xgmii_rx_clk),
    .mac_rx_rst_b                   (xgmii_rx_rst_b_pipe1),
    
    // Configuration from CSR
    .csr_rx_allucast_en             (csr_rx_allucast_en),
    .csr_rx_allmcast_en             (csr_rx_allmcast_en),
    .csr_rx_fwd_ctlfrm              (csr_rx_fwd_ctlfrm),
    .csr_rx_fwd_pausefrm            (csr_rx_fwd_pausefrm),
    .csr_rx_pfc_fwd                 (csr_rx_pfc_fwd),
    .csr_rx_crcpad_rem              (csr_rx_crcpad_rem),
    .csr_rx_preamb_fwd_ctl          (csr_rx_preamb_fwd_ctl_int),
    
    // Overflow Event to CSR
    .overflow_event                 (overflow_event),
    .drop_event                     (drop_event),
    
    // Frame Input Data
    .rx_rs2fctl_frm_data            (rx_rs2fctl_frm_data),
    .rx_rs2fctl_frm_sop             (rx_rs2fctl_frm_sop),
    .rx_rs2fctl_frm_eop             (rx_rs2fctl_frm_eop),
    .rx_rs2fctl_frm_valid           (rx_rs2fctl_frm_valid),
    .rx_rs2fctl_frm_empty           (rx_rs2fctl_frm_empty),
    .rx_rs2fctl_frm_error           (rx_rs2fctl_frm_error),
    
    // Frame Output Data
    .rx_fctl2top_frm_data           (rx_fctl2align_frm_data),
    .rx_fctl2top_frm_sop            (rx_fctl2align_frm_sop),
    .rx_fctl2top_frm_eop            (rx_fctl2align_frm_eop),
    .rx_fctl2top_frm_valid          (rx_fctl2align_frm_valid),
    .rx_fctl2top_frm_empty          (rx_fctl2align_frm_empty),
    .rx_fctl2top_frm_error          (rx_fctl2align_frm_error),
    .rx_top2fctl_frm_ready          (rx_align2fctl_frm_ready),
    
    // Frame Info for CRC/Pad Remover
    .rx_fd2pcrem_info_valid         (rx_fd2pcrem_info_valid),
    .rx_fd2pcrem_info_length_type   (rx_fd2pcrem_info_length_type),
    .rx_fd2pcrem_info_length_frm    (rx_fd2pcrem_info_length_frm),
    .rx_fd2pcrem_info_ctrl_frm      (rx_fd2pcrem_info_ctrl_frm),
    
    // Frame Drop Info
    .rx_fd2flt_info_valid           (rx_fd2flt_info_valid),
    .rx_fd2flt_info_da_matched      (rx_fd2flt_info_da_matched),
    .rx_fd2flt_info_unicast         (rx_fd2flt_info_unicast),
    .rx_fd2flt_info_multicast       (rx_fd2flt_info_multicast),
    .rx_fd2flt_info_broadcast       (rx_fd2flt_info_broadcast),
    .rx_fd2flt_info_ctrl_frm        (rx_fd2flt_info_ctrl_frm),
    .rx_fd2flt_info_pause_frm       (rx_fd2flt_info_pause_frm),
    .rx_fd2flt_info_pfc_frm         (rx_fd2flt_info_pfc_frm),
    
    // Frame Drop Behavior
    .frm_drop_ctrl_pfc_behavior     (frm_drop_ctrl_pfc_behavior),
    
    // 1588 Aligner
    .rx_ovfin2ptp_sop               (rx_ovfin2ptp_sop),
    .rx_ovfin2ptp_valid             (rx_ovfin2ptp_valid)
);

//------------------------------------------------------------------------
// CRC32
//------------------------------------------------------------------------
// SYNC_RESET FLOPS
// Might be able to make these flops non-resetable if the EOP and VALID is cleared from previous module
always @(posedge xgmii_rx_clk) begin
    if(!xgmii_rx_rst_b_pipe1) begin
        // rx_crc32_clken_p1 <= 1'b0;
        rx_crc32_clken_p4 <= 1'b0;
    end
    else begin
        // rx_crc32_clken_p1 <= rx_rs2fctl_frm_valid & rx_rs2fctl_frm_eop;
        rx_crc32_clken_p4 <= rx_crc32_clken_p3 | rx_crc32_clken_p2 | rx_crc32_clken_p1 | (rx_rs2fctl_frm_valid & rx_rs2fctl_frm_eop); // Improve timing by OR all signals together
    end
end

// NON_RESETABLE FLOPS
always @(posedge xgmii_rx_clk) begin
    rx_crc32_clken_p1 <= rx_rs2fctl_frm_valid & rx_rs2fctl_frm_eop;
    rx_crc32_clken_p2 <= rx_crc32_clken_p1;
    rx_crc32_clken_p3 <= rx_crc32_clken_p2;
end

alt_em10g32_crc32 crc32_inst (
    // Clock & Reset
    .clk        (xgmii_rx_clk),
    .rst_n      (xgmii_rx_rst_b_pipe1),
    
    // Frame Input Data
    .clken      (rx_rs2fctl_frm_valid | rx_crc32_clken_p4),
    .sop        (rx_rs2fctl_frm_sop),
    .eop        (rx_rs2fctl_frm_eop),
    .mty        (rx_rs2fctl_frm_empty),
    .data       (rx_rs2fctl_frm_data),
    
    // CRC Output
    .crc_out    (),
    .crc_valid  (rx_crc2align_crc32_valid),
    .crc_good   (rx_crc2align_crc32_good)
);

//------------------------------------------------------------------------
// Signals Alignment
//------------------------------------------------------------------------
alt_em10g32_rx_status_aligner status_aligner_inst(
    // Parameter
    .enable_preamble_passthrough        (enable_preamble_passthrough),
    
    // Clock & Reset
    .mac_rx_clk                         (xgmii_rx_clk),
    .mac_rx_rst_b                       (xgmii_rx_rst_b_pipe1),
    
    // Frame Input Data (From RS)
    .rx_rs2fctl_frm_data                (rx_rs2fctl_frm_data),
    .rx_rs2fctl_frm_sop                 (rx_rs2fctl_frm_sop),
    .rx_rs2fctl_frm_eop                 (rx_rs2fctl_frm_eop),
    .rx_rs2fctl_frm_valid               (rx_rs2fctl_frm_valid),
    .rx_rs2fctl_frm_empty               (rx_rs2fctl_frm_empty),
    .rx_rs2fctl_frm_error               (rx_rs2fctl_frm_error),
    
    // Frame Input Data (From Frame Control)
    .rx_fctl2align_frm_data             (rx_fctl2align_frm_data),
    .rx_fctl2align_frm_sop              (rx_fctl2align_frm_sop),
    .rx_fctl2align_frm_eop              (rx_fctl2align_frm_eop),
    .rx_fctl2align_frm_valid            (rx_fctl2align_frm_valid),
    .rx_fctl2align_frm_empty            (rx_fctl2align_frm_empty),
    .rx_fctl2align_frm_error            (rx_fctl2align_frm_error),
    .rx_align2fctl_frm_ready            (rx_align2fctl_frm_ready),
    
    // Avalon-ST Receive (User)
    .avalon_st_rx_data                  (avalon_st_rx_data),
    .avalon_st_rx_sop                   (avalon_st_rx_sop),
    .avalon_st_rx_eop                   (avalon_st_rx_eop),
    .avalon_st_rx_valid                 (avalon_st_rx_valid),
    .avalon_st_rx_empty                 (avalon_st_rx_empty),
    .avalon_st_rx_error                 (avalon_st_rx_error),
    .avalon_st_rx_ready                 (avalon_st_rx_ready),
    
    // CRC Status
    .csr_rx_crc_chk                     (csr_rx_crc_chk),
    .rx_crc2align_crc32_valid           (rx_crc2align_crc32_valid),
    .rx_crc2align_crc32_good            (rx_crc2align_crc32_good),
    
    // Frame Info In (Statistics)
    .rx_fd2align_statistics_valid       (rx_fd2align_statistics_valid),
    .rx_fd2align_statistics_data        (rx_fd2align_statistics_data),
    .rx_fd2align_statistics_error       (rx_fd2align_statistics_error),
    
    // Frame Info Out (Statistics)
    .avalon_st_rx_statistics_valid      (avalon_st_rx_statistics_valid),
    .avalon_st_rx_statistics_data       (avalon_st_rx_statistics_data),
    .avalon_st_rx_statistics_error      (avalon_st_rx_statistics_error),
    
    // Frame Info In (User Logic)
    .rx_fd2align_rxstatus_valid         (rx_fd2align_rxstatus_valid),
    .rx_fd2align_rxstatus_data          (rx_fd2align_rxstatus_data),
    .rx_fd2align_rxstatus_error         (rx_fd2align_rxstatus_error),
    
    // Frame Info Out (User Logic)
    .avalon_st_rxstatus_valid           (avalon_st_rxstatus_valid),
    .avalon_st_rxstatus_data            (avalon_st_rxstatus_data),
    .avalon_st_rxstatus_error           (avalon_st_rxstatus_error),
    
    // Pause Quanta In
    .rx_fd2align_pause_pq_en            (rx_fd2align_pause_pq_en),
    .rx_fd2align_pause_pq               (rx_fd2align_pause_pq),
    
    // Pause Quanta Out
    .avalon_st_rx_pause_length_valid    (avalon_st_rx_pause_length_valid),
    .avalon_st_rx_pause_length_data     (avalon_st_rx_pause_length_data),
    
    // PFC Pause Quanta In
    .rx_fd2align_pfc_field_valid        (rx_fd2align_pfc_field_valid),
    .rx_fd2align_pfc_pq_en              (rx_fd2align_pfc_pq_en),
    .rx_fd2align_pfc_pq0                (rx_fd2align_pfc_pq0),
    .rx_fd2align_pfc_pq1                (rx_fd2align_pfc_pq1),
    .rx_fd2align_pfc_pq2                (rx_fd2align_pfc_pq2),
    .rx_fd2align_pfc_pq3                (rx_fd2align_pfc_pq3),
    .rx_fd2align_pfc_pq4                (rx_fd2align_pfc_pq4),
    .rx_fd2align_pfc_pq5                (rx_fd2align_pfc_pq5),
    .rx_fd2align_pfc_pq6                (rx_fd2align_pfc_pq6),
    .rx_fd2align_pfc_pq7                (rx_fd2align_pfc_pq7),
    
    // PFC Pause Quanta Out
    .rx_align2flc_pfc_field_valid       (rx_align2flc_pfc_field_valid),
    .rx_align2flc_pfc_pq0_en            (rx_align2flc_pfc_pq0_en),
    .rx_align2flc_pfc_pq1_en            (rx_align2flc_pfc_pq1_en),
    .rx_align2flc_pfc_pq2_en            (rx_align2flc_pfc_pq2_en),
    .rx_align2flc_pfc_pq3_en            (rx_align2flc_pfc_pq3_en),
    .rx_align2flc_pfc_pq4_en            (rx_align2flc_pfc_pq4_en),
    .rx_align2flc_pfc_pq5_en            (rx_align2flc_pfc_pq5_en),
    .rx_align2flc_pfc_pq6_en            (rx_align2flc_pfc_pq6_en),
    .rx_align2flc_pfc_pq7_en            (rx_align2flc_pfc_pq7_en),
    .rx_align2flc_pfc_pq0               (rx_align2flc_pfc_pq0),
    .rx_align2flc_pfc_pq1               (rx_align2flc_pfc_pq1),
    .rx_align2flc_pfc_pq2               (rx_align2flc_pfc_pq2),
    .rx_align2flc_pfc_pq3               (rx_align2flc_pfc_pq3),
    .rx_align2flc_pfc_pq4               (rx_align2flc_pfc_pq4),
    .rx_align2flc_pfc_pq5               (rx_align2flc_pfc_pq5),
    .rx_align2flc_pfc_pq6               (rx_align2flc_pfc_pq6),
    .rx_align2flc_pfc_pq7               (rx_align2flc_pfc_pq7),
    
    // PFC XON/XOFF Status In
    .rx_fd2align_pfc_status_valid       (rx_fd2align_pfc_status_valid),
    .rx_fd2align_pfc_status_data        (rx_fd2align_pfc_status_data),
    
    // PFC XON/XOFF Status Out
    .avalon_st_rx_pfc_status_valid      (avalon_st_rx_pfc_status_valid),
    .avalon_st_rx_pfc_status_data       (avalon_st_rx_pfc_status_data)
    
);

//------------------------------------------------------------------------
// Signals Alignment
//------------------------------------------------------------------------
alt_em10g32_rx_pfc_flow_control pfc_flow_control_inst(
    // Clock & Reset
    .clk                                (xgmii_rx_clk),
    .reset_n                            (xgmii_rx_rst_b_pipe1),
    
    .rx2flc_pfc_field_valid             (rx_align2flc_pfc_field_valid),
    
    .rx2flc_pfc_pq0_en                  (rx_align2flc_pfc_pq0_en),
    .rx2flc_pfc_pq0                     (rx_align2flc_pfc_pq0),
    
    .rx2flc_pfc_pq1_en                  (rx_align2flc_pfc_pq1_en),
    .rx2flc_pfc_pq1                     (rx_align2flc_pfc_pq1),
    
    .rx2flc_pfc_pq2_en                  (rx_align2flc_pfc_pq2_en),
    .rx2flc_pfc_pq2                     (rx_align2flc_pfc_pq2),
    
    .rx2flc_pfc_pq3_en                  (rx_align2flc_pfc_pq3_en),
    .rx2flc_pfc_pq3                     (rx_align2flc_pfc_pq3),
    
    .rx2flc_pfc_pq4_en                  (rx_align2flc_pfc_pq4_en),
    .rx2flc_pfc_pq4                     (rx_align2flc_pfc_pq4),
    
    .rx2flc_pfc_pq5_en                  (rx_align2flc_pfc_pq5_en),
    .rx2flc_pfc_pq5                     (rx_align2flc_pfc_pq5),
    
    .rx2flc_pfc_pq6_en                  (rx_align2flc_pfc_pq6_en),
    .rx2flc_pfc_pq6                     (rx_align2flc_pfc_pq6),
    
    .rx2flc_pfc_pq7_en                  (rx_align2flc_pfc_pq7_en),
    .rx2flc_pfc_pq7                     (rx_align2flc_pfc_pq7),
    
    .flc2top_pfc_data                   (avalon_st_rx_pfc_pause_data)
);

//------------------------------------------------------------------------
// 1588
//------------------------------------------------------------------------
generate 
if (ENABLE_TIMESTAMPING) 
    begin
    alt_em10g32_rx_ptp_top #(
        .DEVICE_FAMILY (DEVICE_FAMILY),
        .RX_XGMII_ADAPTER_PATH_DELAY (RX_XGMII_ADAPTER_PATH_DELAY),
        .FORWARD_SYNC_DEPTH(FORWARD_SYNC_DEPTH),
        .BACKWARD_SYNC_DEPTH(BACKWARD_SYNC_DEPTH),
        .ENABLE_MEM_ECC (ENABLE_MEM_ECC),
        .ENABLE_GMII16B(ENABLE_GMII16B),
        .ENABLE_1G10G_MAC(ENABLE_1G10G_MAC)
    ) ptp_top_inst(
        // Clock and reset
        .xgmii_clk                              (xgmii_rx_clk),
        .xgmii_clk_rst_n                        (xgmii_rx_rst_b),
        .gmii_clk                               (gmii_rx_clk),
        .gmii_clk_rst_n                         (gmii_rx_rst_b),
        
        // Speed selection (10G/1G)
        .speed_sel                              (speed_sel),
        
        // MII clock enable and alignment status (1G)
        .rx_clkena_half_rate                    (mii_rx_clken_half_rate),
        .mii_alignment_status                   (mii_alignment_status),
        
        // CSR signals (10G)
        .csr_adjust_10g                         (csr_adjust_10g),
        .csr_period_10g                         (csr_period_10g),
        
        // CSR signals (1G)
        .csr_adjust_1g                          (csr_adjust_1g),
        .csr_period_1g                          (csr_period_1g),
        
        // Path delay and time of day sink (10G)
        .path_delay_10g_data                    (rx_path_delay_10g_data),
        .time_of_day_96b_10g_data               (rx_time_of_day_96b_10g_data),
        .time_of_day_64b_10g_data               (rx_time_of_day_64b_10g_data),
        
        // Path delay and time of day sink (1G)
        .path_delay_1g_data                     (rx_path_delay_1g_data),
        .time_of_day_96b_1g_data                (rx_time_of_day_96b_1g_data),
        .time_of_day_64b_1g_data                (rx_time_of_day_64b_1g_data),
        
        // XGMII data sink (10G)
        .xgmii_sink_data                        ({xgmii_rx_ctrl_sel[3], xgmii_rx_data_sel[31:24],xgmii_rx_ctrl_sel[2], xgmii_rx_data_sel[23:16],xgmii_rx_ctrl_sel[1], xgmii_rx_data_sel[15:8],xgmii_rx_ctrl_sel[0], xgmii_rx_data_sel[7:0]}),
        //ED
        .xgmii_sink_valid                         (xgmii_rx_valid_sel),
        // GMII data sink (1G)
        .gmii_sink_data                         (gmii_mii_rx_d),
        .gmii_sink_control                      (gmii_mii_rx_dv),
        .gmii_sink_error                        (gmii_mii_rx_err),
        
        // GMII16B data sink (1G/2.5G)
        .gmii16b_sink_data                      (gmii16b_rx_d),
        .gmii16b_sink_control                   (gmii16b_rx_dv),
        .gmii16b_sink_error                     (gmii16b_rx_err),
                        
        // Avalon-ST data sink (10G)
        .avst_sink_data_valid                   (rx_rs2fctl_frm_valid),
        .avst_sink_data_sop                     (rx_rs2fctl_frm_sop),
        
        // Avalon-ST status data sink (10G)
        .avst_rxstatus_valid                    (avalon_st_rxstatus_valid),
        
        // Avalon-ST flow control data sink (sink port) (10G) from frm ctrl output
        .overflow_control_sink_data_sink_valid  (rx_ovfin2ptp_valid),
        .overflow_control_sink_data_sink_sop    (rx_ovfin2ptp_sop), 
        
        // Avalon-ST flow control data source (src port) (10G) from overflow ctrl output
        .overflow_control_src_data_sink_valid   (avalon_st_rx_valid),
        .overflow_control_src_data_sink_sop     (avalon_st_rx_sop),
        
        // Avalon-ST data source ready (10G)
        .avst_src_data_ready                    (avalon_st_rx_ready),
        
        // Timestamp source (10G)
        .rx_ingress_timestamp_96b_src_valid     (rx_ingress_timestamp_96b_valid),
        .rx_ingress_timestamp_96b_src_data      (rx_ingress_timestamp_96b_data),
        .rx_ingress_timestamp_64b_src_valid     (rx_ingress_timestamp_64b_valid),
        .rx_ingress_timestamp_64b_src_data      (rx_ingress_timestamp_64b_data),
        
        // ECC Status
        .rx_ptp_aligner_ecc_err_corrected       (rx_ptp_aligner_ecc_err_corrected),
        .rx_ptp_aligner_ecc_err_fatal           (rx_ptp_aligner_ecc_err_fatal)
    );
    end
else
    begin
    assign rx_ingress_timestamp_96b_valid = 0;
    assign rx_ingress_timestamp_96b_data = 0;
    assign rx_ingress_timestamp_64b_valid = 0;
    assign rx_ingress_timestamp_64b_data = 0;
    assign rx_ptp_aligner_ecc_err_corrected = 0;
    assign rx_ptp_aligner_ecc_err_fatal = 0;
    
    
    end    
endgenerate
 
endmodule
