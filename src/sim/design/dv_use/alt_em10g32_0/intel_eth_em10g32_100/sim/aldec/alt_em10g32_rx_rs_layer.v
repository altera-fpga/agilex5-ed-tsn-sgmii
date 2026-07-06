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

module alt_em10g32_rx_rs_layer
(
   // Clock and reset
   input top2rs_xgmii_rx_clk,
   input top2rs_xgmii_rx_rst_b,
   input top2rs_xgmii_rx_rst_b_asyn,
   input top2rs_gmii_rx_clk,
   input top2rs_gmii_rx_rst_b,
   input top2rs_gmii_rx_rst_b_asyn,

   // Avalon-ST Data path
   output rx_rs2fctl_frm_sop,
   output rx_rs2fctl_frm_eop,
   output [1:0] rx_rs2fctl_frm_empty,
   output rx_rs2fctl_frm_valid,
   output rx_rs2fctl_frm_error,
   output [31:0] rx_rs2fctl_frm_data,

   // CSR control path
   input csr_rx_preamble_passthru,
   input csr_rx_tsfr_en_n,
   output csr_rx_tsfr_sts,

   // Speed selection
   // 000=10Gbps
   // 001=1Gbps
   // 010=100Mbps
   // 011=10Mbps           
   // 100=2.5Gbps
   // 101=5Gbps
   input [2:0] rx_top2rs_phy_speed,

   // GMII/MII clock enable
   input rx_top2rs_mii_rx_clken,
   input rx_top2rs_mii_clken_half_rate,

   // Link fault status
   output [1:0] rx_rs2top_link_fault_status_xgmii_rx_data,

   // XGMII data
   input [31:0] rx_top2rs_xgmii_rx_data,
   input [3:0] rx_top2rs_xgmii_rx_ctrl,
   input rx_top2rs_xgmii_rx_valid,

   // GMII data
   input [7:0] rx_top2rs_gmii_rx_d,
   input rx_top2rs_gmii_rx_dv,
   input rx_top2rs_gmii_rx_err,

   // GMII 16 bit data
   input [15:0] rx_top2rs_gmii16b_rx_d,
   input [1:0] rx_top2rs_gmii16b_rx_dv,
   input [1:0] rx_top2rs_gmii16b_rx_err,

   // GMII/MII data for PTP
   output [7:0] rx_rs2ptp_gmii_rx_d,
   output rx_rs2ptp_gmii_rx_dv,
   output rx_rs2ptp_gmii_rx_err,

   // MII data
   input [3:0] rx_top2rs_mii_rx_d,
   input rx_top2rs_mii_rx_dv,
   input rx_top2rs_mii_rx_err,
   
   // MII Alignment Status
   output mii_alignment_status,
   
   // status to report packet in progress
   output rx_packet_in_progress_rs,
   
   // ECC Status
   output rx_gmii_decoder_ecc_err_corrected,
   output rx_gmii_decoder_ecc_err_fatal
);

// Synthesis parameter to enable Quad speed support
parameter DEVICE_FAMILY = "Stratix V";
parameter ENABLE_MEM_ECC = 0;
parameter FORWARD_SYNC_DEPTH = 4;
parameter BACKWARD_SYNC_DEPTH = 4;
parameter ENABLE_10GBASER_REG_MODE = 0;
parameter ENABLE_1G10G_MAC = 0;
parameter ENABLE_GMII16B = 0;
parameter ENABLE_TIMESTAMPING = 0;
parameter SYNC_RESET_N = 1;

wire rx_ethfrm_sop_10g;
wire rx_ethfrm_eop_10g;
wire [1:0] rx_ethfrm_empty_10g;
wire rx_ethfrm_valid_10g;
wire [31:0] rx_ethfrm_data_10g;
wire rx_ethfrm_error_10g;

wire rx_ethfrm_sop_below_10g;
wire rx_ethfrm_eop_below_10g;
wire [1:0] rx_ethfrm_empty_below_10g;
wire rx_ethfrm_valid_below_10g;
wire [31:0] rx_ethfrm_data_below_10g;
wire rx_ethfrm_error_below_10g;

wire rx_ethfrm_sop_gmii16b;
wire rx_ethfrm_eop_gmii16b;
wire [1:0] rx_ethfrm_empty_gmii16b;
wire rx_ethfrm_valid_gmii16b;
wire [31:0] rx_ethfrm_data_gmii16b;
wire rx_ethfrm_error_gmii16b;

wire rx_tsfr_sts_xgmii;
wire rx_tsfr_sts_gmii;
wire rx_tsfr_sts_mii;
wire rx_tsfr_sts_gmii16b;
reg  rx_tsfr_sts_gmii16b_flop;
wire rx_tsfr_sts_gmii16b_sync;
wire rx_tsfr_sts_gmii_mii;
reg  rx_tsfr_sts_gmii_mii_flop;
wire rx_tsfr_sts_gmii_mii_sync;


// status to report packet in progress
wire rx_packet_in_progress_gmii_mii;
wire rx_packet_in_progress_gmii_mii_sync;
wire packet_in_progress_xgmii;    
wire rx_packet_in_progress_gmii16b;
wire rx_packet_in_progress_gmii16b_sync;
wire csr_rx_tsfr_sts_wire;
reg  csr_rx_tsfr_sts_flop;

// those wire and flop is the flop the link fault status before it go to clock crosser
wire [1:0]rx_rs2top_link_fault_status_xgmii_rx_data_wire;
reg  [1:0]rx_rs2top_link_fault_status_xgmii_rx_data_flop;

wire [1:0] rx_rs2top_link_fault_status_xgmii_rx_data_int;

// same clock hence can OR together
assign rx_tsfr_sts_gmii_mii = rx_tsfr_sts_gmii | rx_tsfr_sts_mii;

// we need to flop the data before it go to std synchroniser
always @ (posedge top2rs_gmii_rx_clk)
    begin
    rx_tsfr_sts_gmii_mii_flop <= rx_tsfr_sts_gmii_mii;
    rx_tsfr_sts_gmii16b_flop <= rx_tsfr_sts_gmii16b;
    end

// use std synchronizer because rx_tsfr_sts_gmii and rx_tsfr_sts_mii is run at gmii clock
alt_em10g32_std_synchronizer #(
    .depth(2)
) sync_rx_tsfr_sts_gmii_mii (
    .clk (top2rs_xgmii_rx_clk),
    .reset_n (top2rs_xgmii_rx_rst_b_asyn),
    .din (rx_tsfr_sts_gmii_mii_flop),
    .dout (rx_tsfr_sts_gmii_mii_sync)
);


alt_em10g32_std_synchronizer #(
    .depth(2)
) sync_rx_tsfr_sts_gmii16b (
    .clk (top2rs_xgmii_rx_clk),
    .reset_n (top2rs_xgmii_rx_rst_b_asyn),
    .din (rx_tsfr_sts_gmii16b_flop),
    .dout (rx_tsfr_sts_gmii16b_sync)
);

alt_em10g32_std_synchronizer #(
    .depth(2)
) sync_rx_gmii_mii_to_mac_clock (
    .clk (top2rs_xgmii_rx_clk),
    .reset_n (top2rs_xgmii_rx_rst_b_asyn),
    .din (rx_packet_in_progress_gmii_mii),
    .dout (rx_packet_in_progress_gmii_mii_sync)
);

alt_em10g32_std_synchronizer #(
    .depth(2)
) sync_rx_gmii16b_to_mac_clock (
    .clk (top2rs_xgmii_rx_clk),
    .reset_n (top2rs_xgmii_rx_rst_b_asyn),
    .din (rx_packet_in_progress_gmii16b),
    .dout (rx_packet_in_progress_gmii16b_sync)
);

// if ENABLE_1G10G_MAC == 5, this is NBASET mode, this mean all MAC will only use xgmii interface with valid as clock enable to control the speed. 

assign csr_rx_tsfr_sts_wire = (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_tsfr_sts_xgmii :
                              (ENABLE_GMII16B == 1) ? rx_tsfr_sts_gmii16b_sync : rx_tsfr_sts_gmii_mii_sync;

// need to flop the signal before go in to sd synchroniser
always @ (posedge top2rs_xgmii_rx_clk)
    begin
    csr_rx_tsfr_sts_flop <= csr_rx_tsfr_sts_wire;
    end

assign csr_rx_tsfr_sts = csr_rx_tsfr_sts_flop;    
assign rx_packet_in_progress_rs = (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? packet_in_progress_xgmii :
                                  (ENABLE_GMII16B == 1) ? rx_packet_in_progress_gmii16b_sync : rx_packet_in_progress_gmii_mii_sync;

// MUX to select GMII16B, GMII/MII or XGMII Avalon-ST output
// 000=10Gbps
// 001=1Gbps (needs to select between GMII16B and GMII)
// 010=100Mbps
// 011=10Mbps           
// 100=2.5Gbps
// 101=5Gbps
generate if ((DEVICE_FAMILY == "Stratix 10") || (DEVICE_FAMILY == "Agilex 5"))
begin

reg     rx_rs2fctl_frm_sop_flop;
reg     rx_rs2fctl_frm_eop_flop;
reg     [1:0] rx_rs2fctl_frm_empty_flop;
reg     rx_rs2fctl_frm_valid_flop;
reg     rx_rs2fctl_frm_error_flop;
reg     [31:0] rx_rs2fctl_frm_data_flop;

always @ (posedge top2rs_xgmii_rx_clk)
    begin
    if(!top2rs_xgmii_rx_rst_b)
        begin
        rx_rs2fctl_frm_sop_flop <= 1'b0;
        rx_rs2fctl_frm_eop_flop <= 1'b0;
        // rx_rs2fctl_frm_empty_flop <= 2'b0;
        rx_rs2fctl_frm_valid_flop <= 1'b0;
        // rx_rs2fctl_frm_error_flop <= 1'b0;
        end
    else
        begin
        rx_rs2fctl_frm_sop_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_sop_10g :
        (ENABLE_GMII16B == 1) ? rx_ethfrm_sop_gmii16b : rx_ethfrm_sop_below_10g;
        
        rx_rs2fctl_frm_eop_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_eop_10g :
        (ENABLE_GMII16B == 1) ? rx_ethfrm_eop_gmii16b : rx_ethfrm_eop_below_10g;
   
        // rx_rs2fctl_frm_empty_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_empty_10g :
        // (ENABLE_GMII16B == 1) ? rx_ethfrm_empty_gmii16b : rx_ethfrm_empty_below_10g;
        
        rx_rs2fctl_frm_valid_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_valid_10g :
        (ENABLE_GMII16B == 1) ? rx_ethfrm_valid_gmii16b : rx_ethfrm_valid_below_10g;
        
        // rx_rs2fctl_frm_error_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_error_10g :
        // (ENABLE_GMII16B == 1) ? rx_ethfrm_error_gmii16b : rx_ethfrm_error_below_10g;
        end
    end
    
always @ (posedge top2rs_xgmii_rx_clk)
    begin
    rx_rs2fctl_frm_data_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5 ) ? rx_ethfrm_data_10g:
    (ENABLE_GMII16B == 1) ? rx_ethfrm_data_gmii16b : rx_ethfrm_data_below_10g;
    rx_rs2fctl_frm_empty_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_empty_10g :
    (ENABLE_GMII16B == 1) ? rx_ethfrm_empty_gmii16b : rx_ethfrm_empty_below_10g;
    rx_rs2fctl_frm_error_flop <= (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_error_10g :
    (ENABLE_GMII16B == 1) ? rx_ethfrm_error_gmii16b : rx_ethfrm_error_below_10g;
    end

assign rx_rs2fctl_frm_sop = rx_rs2fctl_frm_sop_flop;
assign rx_rs2fctl_frm_eop = rx_rs2fctl_frm_eop_flop;
assign rx_rs2fctl_frm_empty = rx_rs2fctl_frm_empty_flop;
assign rx_rs2fctl_frm_valid = rx_rs2fctl_frm_valid_flop;   
assign rx_rs2fctl_frm_error = rx_rs2fctl_frm_error_flop;
assign rx_rs2fctl_frm_data = rx_rs2fctl_frm_data_flop;
    
end
else
begin
assign rx_rs2fctl_frm_sop = 
   (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_sop_10g :
   (ENABLE_GMII16B == 1) ? rx_ethfrm_sop_gmii16b : rx_ethfrm_sop_below_10g;

assign rx_rs2fctl_frm_eop = 
   (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_eop_10g :
   (ENABLE_GMII16B == 1) ? rx_ethfrm_eop_gmii16b : rx_ethfrm_eop_below_10g;

assign rx_rs2fctl_frm_empty = 
   (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_empty_10g :
   (ENABLE_GMII16B == 1) ? rx_ethfrm_empty_gmii16b : rx_ethfrm_empty_below_10g;

assign rx_rs2fctl_frm_valid = 
   (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_valid_10g :
   (ENABLE_GMII16B == 1) ? rx_ethfrm_valid_gmii16b : rx_ethfrm_valid_below_10g;

assign rx_rs2fctl_frm_error = 
   (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ? rx_ethfrm_error_10g :
   (ENABLE_GMII16B == 1) ? rx_ethfrm_error_gmii16b : rx_ethfrm_error_below_10g;

assign rx_rs2fctl_frm_data = 
   (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5 ) ? rx_ethfrm_data_10g:
   (ENABLE_GMII16B == 1) ? rx_ethfrm_data_gmii16b : rx_ethfrm_data_below_10g;
end
endgenerate


assign rx_rs2top_link_fault_status_xgmii_rx_data_wire = (rx_top2rs_phy_speed == 3'b000 || rx_top2rs_phy_speed == 3'b101 || ENABLE_1G10G_MAC == 5) ?
                                                   rx_rs2top_link_fault_status_xgmii_rx_data_int : 2'b0;

// before the data go to clock crosser or std synchroniser, must flop it first.                                                    
always @ (posedge top2rs_xgmii_rx_clk)
    begin
    rx_rs2top_link_fault_status_xgmii_rx_data_flop <= rx_rs2top_link_fault_status_xgmii_rx_data_wire;
    end

assign rx_rs2top_link_fault_status_xgmii_rx_data = rx_rs2top_link_fault_status_xgmii_rx_data_flop;
    
alt_em10g32_rx_rs_gmii16b_top #(
   .ENABLE_TIMESTAMPING(ENABLE_TIMESTAMPING),
   .SYNC_RESET_N(SYNC_RESET_N)
) i_rx_rs_gmii16b_top (
   .clk_gmii (top2rs_gmii_rx_clk),
   .reset_gmii_n (top2rs_gmii_rx_rst_b),
   .reset_gmii_n_asyn (top2rs_gmii_rx_rst_b_asyn),
   .clk_mac (top2rs_xgmii_rx_clk),
   .reset_mac_n (top2rs_xgmii_rx_rst_b),

   .csr_rx_tsfr_en_n (csr_rx_tsfr_en_n),
   .rx_tsfr_sts_gmii16b (rx_tsfr_sts_gmii16b),

   .gmii16b_rx_dv (rx_top2rs_gmii16b_rx_dv),
   .gmii16b_rx_d (rx_top2rs_gmii16b_rx_d),
   .gmii16b_rx_err (rx_top2rs_gmii16b_rx_err),
     //clk_ena
   .rx_clkena_half_rate (rx_top2rs_mii_rx_clken),
   .rx_ethfrm_sop (rx_ethfrm_sop_gmii16b),
   .rx_ethfrm_eop (rx_ethfrm_eop_gmii16b),
   .rx_ethfrm_empty (rx_ethfrm_empty_gmii16b),
   .rx_ethfrm_valid (rx_ethfrm_valid_gmii16b),
   .rx_ethfrm_error (rx_ethfrm_error_gmii16b),
   .rx_ethfrm_data (rx_ethfrm_data_gmii16b),
   
   .rx_packet_in_progress_gmii16b(rx_packet_in_progress_gmii16b)
);

alt_em10g32_rx_rs_xgmii i_rx_rs_xgmii
(
   // Clock and reset
   .top2rs_xgmii_rx_clk (top2rs_xgmii_rx_clk),
   .top2rs_xgmii_rx_rst_b (top2rs_xgmii_rx_rst_b),
   
   // Register setting
   .csr_preamble_passthru (csr_rx_preamble_passthru),
   .csr_rx_tsfr_en_n        (csr_rx_tsfr_en_n),
   .rx_tsfr_sts_xgmii       (rx_tsfr_sts_xgmii),
   
   .packet_in_progress_xgmii(packet_in_progress_xgmii),

   // Avalon-ST outputs
   .rx_ethfrm_sop_10g (rx_ethfrm_sop_10g),
   .rx_ethfrm_eop_10g (rx_ethfrm_eop_10g),
   .rx_ethfrm_empty_10g (rx_ethfrm_empty_10g),
   .rx_ethfrm_valid_10g (rx_ethfrm_valid_10g),
   .rx_ethfrm_data_10g (rx_ethfrm_data_10g),
   .rx_ethfrm_error_10g (rx_ethfrm_error_10g),
   .rx_link_fault_status_xgmii_rx_data (rx_rs2top_link_fault_status_xgmii_rx_data_int),

   // XGMII inputs
   .rx_top2rs_xgmii_rx_data (rx_top2rs_xgmii_rx_data),
   .rx_top2rs_xgmii_rx_ctrl (rx_top2rs_xgmii_rx_ctrl),
   .rx_top2rs_xgmii_rx_valid(rx_top2rs_xgmii_rx_valid)
);


alt_em10g32_rx_rs_gmii_mii 
#( 
   .ENABLE_MEM_ECC (ENABLE_MEM_ECC),
   .FORWARD_SYNC_DEPTH(FORWARD_SYNC_DEPTH),
   .BACKWARD_SYNC_DEPTH(BACKWARD_SYNC_DEPTH),
   .SYNC_RESET_N(SYNC_RESET_N)
)
i_rx_rs_gmii_mii
(
   // Clock and reset
   .clk_gmii (top2rs_gmii_rx_clk),
   .clk_mac (top2rs_xgmii_rx_clk),
   .reset_gmii (~top2rs_gmii_rx_rst_b),
   .reset_gmii_asyn (~top2rs_gmii_rx_rst_b_asyn),
   .reset_mac (~top2rs_xgmii_rx_rst_b),
   .speed_sel (rx_top2rs_phy_speed),
   .rx_clkena (rx_top2rs_mii_rx_clken),
   .rx_clkena_half_rate (rx_top2rs_mii_clken_half_rate),
   
   .csr_rx_tsfr_en_n (csr_rx_tsfr_en_n),
   .rx_tsfr_sts_gmii (rx_tsfr_sts_gmii),
   .rx_tsfr_sts_mii (rx_tsfr_sts_mii),

   // GMII inputs
   .gmii_sink_data (rx_top2rs_gmii_rx_d),
   .gmii_sink_control (rx_top2rs_gmii_rx_dv),
   .gmii_sink_error (rx_top2rs_gmii_rx_err),

   // MII inputs
   .mii_sink_data (rx_top2rs_mii_rx_d),
   .mii_sink_control (rx_top2rs_mii_rx_dv),
   .mii_sink_error (rx_top2rs_mii_rx_err),

   // GMII/MII outputs for PTP
   .gmii_mii_sink_data_o (rx_rs2ptp_gmii_rx_d),
   .gmii_mii_sink_control_o (rx_rs2ptp_gmii_rx_dv),
   .gmii_mii_sink_error_o (rx_rs2ptp_gmii_rx_err),
 
   // Avalon-ST outputs
   .rxdata_src_sop (rx_ethfrm_sop_below_10g),
   .rxdata_src_eop (rx_ethfrm_eop_below_10g),
   .rxdata_src_valid (rx_ethfrm_valid_below_10g),
   .rxdata_src_data (rx_ethfrm_data_below_10g),
   .rxdata_src_error (rx_ethfrm_error_below_10g),
   .rxdata_src_empty (rx_ethfrm_empty_below_10g),
   
   .mii_alignment_status (mii_alignment_status),
   
    // status to report packet in progress
    .rx_packet_in_progress_gmii_mii(rx_packet_in_progress_gmii_mii),

   
   // ECC Status
   .rx_gmii_decoder_ecc_err_corrected(rx_gmii_decoder_ecc_err_corrected),
   .rx_gmii_decoder_ecc_err_fatal(rx_gmii_decoder_ecc_err_fatal)
);

endmodule
