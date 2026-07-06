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
module alt_em10g32_creg_top (
    // Clock & Reset
    csr_clk,
    csr_clk_rst_n,
    tx_clk,
    tx_clk_rst_n,
    rx_clk,
    rx_clk_rst_n,
    gmii_tx_clk,
    gmii_tx_clk_rst_n,
    gmii_rx_clk,
    gmii_rx_clk_rst_n,
    
    // Reset for statistics in TX/RX clock domain
    csr_rst_tx_clk_n,
    csr_rst_rx_clk_n,
    
    // Reset for clock crosser
    csr_tx_cc_in_rst_n,
    csr_tx_cc_out_rst_n,
    tx_csr_cc_in_rst_n,
    tx_csr_cc_out_rst_n,
    
    csr_gmii_tx_cc_in_rst_n,
    csr_gmii_tx_cc_out_rst_n,
    gmii_tx_csr_cc_in_rst_n,
    gmii_tx_csr_cc_out_rst_n,
    
    csr_rx_cc_in_rst_n,
    csr_rx_cc_out_rst_n,
    rx_csr_cc_in_rst_n,
    rx_csr_cc_out_rst_n,
    
    csr_gmii_rx_cc_in_rst_n,
    csr_gmii_rx_cc_out_rst_n,
    gmii_rx_csr_cc_in_rst_n,
    gmii_rx_csr_cc_out_rst_n,

    // Register Inputs and Outputs
    const_revision_id,
    const_mac_capability,
    csr_tx_mac_sa,
    csr_rx_primaddr,
    status_wait_request_timeout,
    csr_tx_data_path_reset,
    csr_rx_data_path_reset,
    csr_tx_tsfr_en_n,
    status_tx_datafrm_tsfr_en_sts,
    status_tx_busy,
    status_tx_rst_sts,
    csr_tx_pad_insrt_en,
    const_tx_crcctl_reserved,
    csr_tx_crc_insrt_en,
    csr_tx_preamble_passthru,
    csr_tx_mac_sa_ovrd_en,
    csr_tx_max_frmlen,
    csr_txvlandet_dis,
    tx_pipg_10g_dic,
    tx_pipg_1g_fixed,
    pulse_tx_udf_errcnt,
    csr_tx_pause_xonxoff_ctrl,
    csr_tx_pause_xonxoff_ctrl_valid,
    csr_tx_pause_xonxoff_ctrl_clr,
    csr_tx_pause_pqt,
    csr_tx_pause_hqt,
    csr_tx_pause_en,
    csr_tx_pausefrm_policy,
    csr_tx_pfc0_en,
    csr_tx_pfc1_en,
    csr_tx_pfc2_en,
    csr_tx_pfc3_en,
    csr_tx_pfc4_en,
    csr_tx_pfc5_en,
    csr_tx_pfc6_en,
    csr_tx_pfc7_en,
    csr_tx_pfc0_pqt,
    csr_tx_pfc1_pqt,
    csr_tx_pfc2_pqt,
    csr_tx_pfc3_pqt,
    csr_tx_pfc4_pqt,
    csr_tx_pfc5_pqt,
    csr_tx_pfc6_pqt,
    csr_tx_pfc7_pqt,
    csr_tx_pfc0_xoff_hqt,
    csr_tx_pfc1_xoff_hqt,
    csr_tx_pfc2_xoff_hqt,
    csr_tx_pfc3_xoff_hqt,
    csr_tx_pfc4_xoff_hqt,
    csr_tx_pfc5_xoff_hqt,
    csr_tx_pfc6_xoff_hqt,
    csr_tx_pfc7_xoff_hqt,
    csr_tx_unidirectional_en,
    csr_tx_unidirectional_remote_fault_dis,
    csr_tx_unidirectional_force_remote_fault,
    csr_rx_tsfr_en_n,
    status_rx_tsfr_sts,
    status_rx_busy,
    status_rx_rst_sts,
    csr_rx_crcpad_rem,
    status_rx_crc_reserved,
    csr_rx_crc_chk,
    csr_rx_preamb_fwd_ctl,
    csr_rx_preamb_passthru_en,
    csr_rx_allucast_en,
    csr_rx_allmcast_en,
    csr_rx_fwd_ctlfrm,
    csr_rx_fwd_pausefrm,
    csr_rx_ignore_pausefrm,
    csr_rx_suppaddr_en0,
    csr_rx_suppaddr_en1,
    csr_rx_suppaddr_en2,
    csr_rx_suppaddr_en3,
    csr_rx_max_datafrmlen,
    csr_rxvlandet_dis,
    csr_rx_supp_macaddr_0,
    csr_rx_supp_macaddr_1,
    csr_rx_supp_macaddr_2,
    csr_rx_supp_macaddr_3,
    csr_rx_pfc_ignore_pausefrm_0,
    csr_rx_pfc_ignore_pausefrm_1,
    csr_rx_pfc_ignore_pausefrm_2,
    csr_rx_pfc_ignore_pausefrm_3,
    csr_rx_pfc_ignore_pausefrm_4,
    csr_rx_pfc_ignore_pausefrm_5,
    csr_rx_pfc_ignore_pausefrm_6,
    csr_rx_pfc_ignore_pausefrm_7,
    csr_rx_pfc_fwd,
    pulse_rx_pkt_ovrflw_errcnt,
    pulse_rx_pkt_ovrflw_etherstatsdropevents,
    csr_tx_period_10g,
    csr_tx_adj_fracns_10g,
    csr_tx_adj_ns_10g,
    csr_tx_period_1g,
    csr_tx_adj_fracns_1g,
    csr_tx_adj_ns_1g,
    csr_tx_asymmetry,
    csr_tx_p2p_dir_egress,
    cf_overflow_ingress_status,
    cf_overflow_egress_status,
    cf_rt_gt_eq_4s_status,
    cf_rt_neg_status,
    csr_rx_period_10g,
    csr_rx_adj_fracns_10g,
    csr_rx_adj_ns_10g,
    csr_rx_period_1g,
    csr_rx_adj_fracns_1g,
    csr_rx_adj_ns_1g,
    csr_rx_p2p_val_ns,
    csr_rx_p2p_val_valid,
    csr_rx_p2p_val_fns,
    ecc_corrected_err_status,
    ecc_fatal_err_status,
    ecc_corrected_err_status_ena,
    ecc_fatal_err_status_ena,
    csr_tx_adptdcff_rdwtrmrk_dis,
    csr_tx_adptdcff_rdwtrmrk,
    csr_tx_adptdcff_vldpkt_minwt,
    
    // Avalon-MM Slave
    avs_address,
    avs_read,
    avs_write,
    avs_writedata,
    avs_readdata,
    avs_waitrequest,

    // From Frame Decoders to Statistics
    tx_stat_valid,
    tx_stat_data,
    tx_stat_error,
    rx_stat_valid,
    rx_stat_data,
    rx_stat_error,
    
    // ECC Status
    tx_gmii_encoder_ecc_err_corrected,
    tx_gmii_encoder_ecc_err_fatal,
    rx_gmii_decoder_ecc_err_corrected,
    rx_gmii_decoder_ecc_err_fatal,
    tx_ptp_request_control_ecc_err_corrected,
    tx_ptp_request_control_ecc_err_fatal,
    rx_ptp_aligner_ecc_err_corrected,
    rx_ptp_aligner_ecc_err_fatal,
    
    // CF Error Status
    ingress_overflow,
    egress_overflow,
    egress_rt_gt_4s,
    egress_rt_neg,
    cf_overflow_valid, 
    
    // Parameters
    insert_st_adaptor,
    enable_tx,
    enable_rx,
    enable_tx_crc,
    enable_supp_addr,
    enable_pfc,
    enable_preamble_passthrough,
    pfc_priority_num,
    enable_timestamping,
    enable_asymmetry,
    enable_p2p,
    enable_mem_ecc,
    enable_1g10g_mac,
	enable_unidirectional,
    enable_txrx_datapath_n,
    instantiate_statistics,
    register_based_statistics
);

// Parameters
parameter DEVICE_FAMILY = "Stratix V";
parameter ENABLE_MEM_ECC = 0;
parameter SYNCHRONIZER_DEPTH = 2;
parameter STATISTICS_CSR_CLOCK = 1;
parameter STATISTICS_CSR_CLOCK_DC_FIFO = 0;
parameter INSTANTIATE_STATISTICS = 0;  
parameter REGISTER_BASED_STATISTICS = 0;  
parameter SYNC_RESET_N = 1;

// Clock & Reset
input                csr_clk;
input                csr_clk_rst_n;
input                tx_clk;
input                tx_clk_rst_n;
input                rx_clk;
input                rx_clk_rst_n;
input                gmii_tx_clk;
input                gmii_tx_clk_rst_n;
input                gmii_rx_clk;
input                gmii_rx_clk_rst_n;

// Reset for statistics in TX/RX clock domain
input                csr_rst_tx_clk_n;
input                csr_rst_rx_clk_n;

// Reset for clock crosser
input                csr_tx_cc_in_rst_n;
input                csr_tx_cc_out_rst_n;
input                tx_csr_cc_in_rst_n;
input                tx_csr_cc_out_rst_n;

input                csr_gmii_tx_cc_in_rst_n;
input                csr_gmii_tx_cc_out_rst_n;
input                gmii_tx_csr_cc_in_rst_n;
input                gmii_tx_csr_cc_out_rst_n;

input                csr_rx_cc_in_rst_n;
input                csr_rx_cc_out_rst_n;
input                rx_csr_cc_in_rst_n;
input                rx_csr_cc_out_rst_n;

input                csr_gmii_rx_cc_in_rst_n;
input                csr_gmii_rx_cc_out_rst_n;
input                gmii_rx_csr_cc_in_rst_n;
input                gmii_rx_csr_cc_out_rst_n;

// Avalon-MM Slave
input      [ 9:0]    avs_address;
input                avs_read;
input                avs_write;
input      [31:0]    avs_writedata;
output reg [31:0]    avs_readdata;
output               avs_waitrequest;

// From Frame Decoders to Statistics
input                tx_stat_valid;
input      [39:0]    tx_stat_data;
input      [ 6:0]    tx_stat_error;
input                rx_stat_valid;
input      [39:0]    rx_stat_data;
input      [ 6:0]    rx_stat_error;

// ECC Status
input                tx_gmii_encoder_ecc_err_corrected;
input                tx_gmii_encoder_ecc_err_fatal;
input                rx_gmii_decoder_ecc_err_corrected;
input                rx_gmii_decoder_ecc_err_fatal;
input                tx_ptp_request_control_ecc_err_corrected;
input                tx_ptp_request_control_ecc_err_fatal;
input                rx_ptp_aligner_ecc_err_corrected;
input                rx_ptp_aligner_ecc_err_fatal;

// CF Error Status
input                ingress_overflow;
input                egress_overflow;
input                egress_rt_gt_4s;
input                egress_rt_neg;
input                cf_overflow_valid; 

// Parameters
input                insert_st_adaptor;
input                enable_tx;
input                enable_rx;
input                enable_tx_crc;
input                enable_supp_addr;
input                enable_pfc;
input                enable_preamble_passthrough;
input      [ 3:0]    pfc_priority_num;
input                enable_timestamping;
input                enable_asymmetry;
input                enable_p2p;
input                enable_mem_ecc;
input                enable_1g10g_mac;
input		 enable_unidirectional;
input                enable_txrx_datapath_n;
input                instantiate_statistics;
input                register_based_statistics;

// Register Inputs and Outputs
input      [ 7:0]    const_revision_id;
input      [31:0]    const_mac_capability;
output     [47:0]    csr_tx_mac_sa;
output     [47:0]    csr_rx_primaddr;
output               status_wait_request_timeout;
output               csr_tx_data_path_reset;
output               csr_rx_data_path_reset;
output               csr_tx_tsfr_en_n;
input                status_tx_datafrm_tsfr_en_sts;
input                status_tx_busy;
input                status_tx_rst_sts;
output               csr_tx_pad_insrt_en;
input                const_tx_crcctl_reserved;
output               csr_tx_crc_insrt_en;
output               csr_tx_preamble_passthru;
output               csr_tx_mac_sa_ovrd_en;
output     [15:0]    csr_tx_max_frmlen;
output               csr_txvlandet_dis;
output     [ 7:0]    tx_pipg_10g_dic;
output     [ 7:0]    tx_pipg_1g_fixed;
input                pulse_tx_udf_errcnt;
output     [ 1:0]    csr_tx_pause_xonxoff_ctrl;
output               csr_tx_pause_xonxoff_ctrl_valid;
input                csr_tx_pause_xonxoff_ctrl_clr;
output     [15:0]    csr_tx_pause_pqt;
output     [15:0]    csr_tx_pause_hqt;
output               csr_tx_pause_en;
output     [ 1:0]    csr_tx_pausefrm_policy;
output               csr_tx_pfc0_en;
output               csr_tx_pfc1_en;
output               csr_tx_pfc2_en;
output               csr_tx_pfc3_en;
output               csr_tx_pfc4_en;
output               csr_tx_pfc5_en;
output               csr_tx_pfc6_en;
output               csr_tx_pfc7_en;
output     [15:0]    csr_tx_pfc0_pqt;
output     [15:0]    csr_tx_pfc1_pqt;
output     [15:0]    csr_tx_pfc2_pqt;
output     [15:0]    csr_tx_pfc3_pqt;
output     [15:0]    csr_tx_pfc4_pqt;
output     [15:0]    csr_tx_pfc5_pqt;
output     [15:0]    csr_tx_pfc6_pqt;
output     [15:0]    csr_tx_pfc7_pqt;
output     [15:0]    csr_tx_pfc0_xoff_hqt;
output     [15:0]    csr_tx_pfc1_xoff_hqt;
output     [15:0]    csr_tx_pfc2_xoff_hqt;
output     [15:0]    csr_tx_pfc3_xoff_hqt;
output     [15:0]    csr_tx_pfc4_xoff_hqt;
output     [15:0]    csr_tx_pfc5_xoff_hqt;
output     [15:0]    csr_tx_pfc6_xoff_hqt;
output     [15:0]    csr_tx_pfc7_xoff_hqt;
output               csr_tx_unidirectional_en;
output               csr_tx_unidirectional_remote_fault_dis;
output               csr_tx_unidirectional_force_remote_fault;
output               csr_rx_tsfr_en_n;
input                status_rx_tsfr_sts;
input                status_rx_busy;
input                status_rx_rst_sts;
output     [ 1:0]    csr_rx_crcpad_rem;
input                status_rx_crc_reserved;
output               csr_rx_crc_chk;
output               csr_rx_preamb_fwd_ctl;
output               csr_rx_preamb_passthru_en;
output               csr_rx_allucast_en;
output               csr_rx_allmcast_en;
output               csr_rx_fwd_ctlfrm;
output               csr_rx_fwd_pausefrm;
output               csr_rx_ignore_pausefrm;
output               csr_rx_suppaddr_en0;
output               csr_rx_suppaddr_en1;
output               csr_rx_suppaddr_en2;
output               csr_rx_suppaddr_en3;
output     [15:0]    csr_rx_max_datafrmlen;
output               csr_rxvlandet_dis;
output     [47:0]    csr_rx_supp_macaddr_0;
output     [47:0]    csr_rx_supp_macaddr_1;
output     [47:0]    csr_rx_supp_macaddr_2;
output     [47:0]    csr_rx_supp_macaddr_3;
output               csr_rx_pfc_ignore_pausefrm_0;
output               csr_rx_pfc_ignore_pausefrm_1;
output               csr_rx_pfc_ignore_pausefrm_2;
output               csr_rx_pfc_ignore_pausefrm_3;
output               csr_rx_pfc_ignore_pausefrm_4;
output               csr_rx_pfc_ignore_pausefrm_5;
output               csr_rx_pfc_ignore_pausefrm_6;
output               csr_rx_pfc_ignore_pausefrm_7;
output               csr_rx_pfc_fwd;
input                pulse_rx_pkt_ovrflw_errcnt;
input                pulse_rx_pkt_ovrflw_etherstatsdropevents;
output     [19:0]    csr_tx_period_10g;
output     [15:0]    csr_tx_adj_fracns_10g;
output     [15:0]    csr_tx_adj_ns_10g;
output     [19:0]    csr_tx_period_1g;
output     [15:0]    csr_tx_adj_fracns_1g;
output     [15:0]    csr_tx_adj_ns_1g;
output     [18:0]    csr_tx_asymmetry;
output               csr_tx_p2p_dir_egress;
output               cf_overflow_ingress_status;
output               cf_overflow_egress_status;
output               cf_rt_gt_eq_4s_status;
output               cf_rt_neg_status;
output     [19:0]    csr_rx_period_10g;
output     [15:0]    csr_rx_adj_fracns_10g;
output     [15:0]    csr_rx_adj_ns_10g;
output     [19:0]    csr_rx_period_1g;
output     [15:0]    csr_rx_adj_fracns_1g;
output     [15:0]    csr_rx_adj_ns_1g;
output     [29:0]    csr_rx_p2p_val_ns;
output               csr_rx_p2p_val_valid;
output     [15:0]    csr_rx_p2p_val_fns;
output               ecc_corrected_err_status;
output               ecc_fatal_err_status;
output               ecc_corrected_err_status_ena;
output               ecc_fatal_err_status_ena;
output               csr_tx_adptdcff_rdwtrmrk_dis;
output     [ 2:0]    csr_tx_adptdcff_rdwtrmrk;
output     [ 2:0]    csr_tx_adptdcff_vldpkt_minwt;

// Wire for register map input and output ports
wire       [ 7:0]    revision_id;
wire       [31:0]    mac_capability;
wire       [31:0]    pri_macaddr_bit31to0;
wire       [15:0]    pri_macaddr_bit47to32;
wire                 wait_request_timeout;
wire                 tx_data_path_reset;
wire                 rx_data_path_reset;
wire                 tx_tsfr_en_n;
wire                 tx_datafrm_tsfr_en_sts;
wire                 tx_busy;
wire                 tx_rst_sts;
wire                 tx_pad_insrt_en;
wire                 tx_crcctl_reserved;
wire                 tx_crc_insrt_en;
wire                 tx_preamb_passthru_en;
wire                 tx_sa_override_en;
wire       [15:0]    tx_max_datafrmlen;
wire                 txvlandet_dis;
wire       [ 7:0]    tx_pipg10g_dic;
wire       [ 7:0]    tx_pipg1g_fixed;
wire       [31:0]    tx_udf_errcnt_bit31to0;
wire       [ 3:0]    tx_udf_errcnt_bit35to32;
wire       [ 1:0]    tx_pausefrm_xonxoff;
wire                 tx_pausefrm_xonxoff_valid_internal;
wire                 csr_tx_pause_xonxoff_ctrl_clr_internal;
wire       [15:0]    tx_pausefrm_pqt;
wire       [15:0]    tx_pausefrm_xoff_hqt;
wire                 tx_pausefrm_en;
wire       [ 1:0]    tx_pausefrm_policy;
wire                 tx_pfcfrm_en0;
wire                 tx_pfcfrm_en1;
wire                 tx_pfcfrm_en2;
wire                 tx_pfcfrm_en3;
wire                 tx_pfcfrm_en4;
wire                 tx_pfcfrm_en5;
wire                 tx_pfcfrm_en6;
wire                 tx_pfcfrm_en7;
wire       [15:0]    tx_pfcfrm_pqt0;
wire       [15:0]    tx_pfcfrm_pqt1;
wire       [15:0]    tx_pfcfrm_pqt2;
wire       [15:0]    tx_pfcfrm_pqt3;
wire       [15:0]    tx_pfcfrm_pqt4;
wire       [15:0]    tx_pfcfrm_pqt5;
wire       [15:0]    tx_pfcfrm_pqt6;
wire       [15:0]    tx_pfcfrm_pqt7;
wire       [15:0]    tx_xoff_hqt0;
wire       [15:0]    tx_xoff_hqt1;
wire       [15:0]    tx_xoff_hqt2;
wire       [15:0]    tx_xoff_hqt3;
wire       [15:0]    tx_xoff_hqt4;
wire       [15:0]    tx_xoff_hqt5;
wire       [15:0]    tx_xoff_hqt6;
wire       [15:0]    tx_xoff_hqt7;
wire                 tx_unidirectional_en;
wire                 tx_unidirectional_remote_fault_dis;
wire                 tx_unidirectional_force_remote_fault;
wire                 rx_tsfr_en_n;
wire                 rx_tsfr_sts;
wire                 rx_busy;
wire                 rx_rst_sts;
wire       [ 1:0]    rx_crcpad_rem;
wire                 rx_crc_reserved;
wire                 rx_crc_chk;
wire                 rx_preambctl_fwd;
wire                 rx_preamb_passthru_en;
wire                 rx_allucast_en;
wire                 rx_allmcast_en;
wire                 rx_fwd_ctlfrm;
wire                 rx_fwd_pausefrm;
wire                 rx_ignore_pausefrm;
wire                 rx_suppaddr_en0;
wire                 rx_suppaddr_en1;
wire                 rx_suppaddr_en2;
wire                 rx_suppaddr_en3;
wire       [15:0]    rx_max_datafrmlen;
wire                 rxvlandet_dis;
wire       [31:0]    rx_supp_macaddr_bit31to0_0;
wire       [15:0]    rx_supp_macaddr_bit47to32_0;
wire       [31:0]    rx_supp_macaddr_bit31to0_1;
wire       [15:0]    rx_supp_macaddr_bit47to32_1;
wire       [31:0]    rx_supp_macaddr_bit31to0_2;
wire       [15:0]    rx_supp_macaddr_bit47to32_2;
wire       [31:0]    rx_supp_macaddr_bit31to0_3;
wire       [15:0]    rx_supp_macaddr_bit47to32_3;
wire                 rx_pfc_ignore_pausefrm_0;
wire                 rx_pfc_ignore_pausefrm_1;
wire                 rx_pfc_ignore_pausefrm_2;
wire                 rx_pfc_ignore_pausefrm_3;
wire                 rx_pfc_ignore_pausefrm_4;
wire                 rx_pfc_ignore_pausefrm_5;
wire                 rx_pfc_ignore_pausefrm_6;
wire                 rx_pfc_ignore_pausefrm_7;
wire                 rx_pfc_fwd;
wire       [31:0]    rx_pkt_ovrflw_errcnt_bit31to0;
wire       [ 3:0]    rx_pkt_ovrflw_errcnt_bit35to32;
wire       [31:0]    rx_pkt_ovrflw_etherstatsdropevents_bit31to0;
wire       [ 3:0]    rx_pkt_ovrflw_etherstatsdropevents_bit35to32;
wire       [19:0]    tx_period_10g;
wire       [15:0]    tx_adj_fracns_10g;
wire       [15:0]    tx_adj_ns_10g;
wire       [19:0]    tx_period_1g;
wire       [15:0]    tx_adj_fracns_1g;
wire       [15:0]    tx_adj_ns_1g;
wire       [18:0]    tx_asymmetry;
wire                 tx_p2p_dir_egress;
wire                 cf_overflow_ingress;
wire                 cf_overflow_egress;
wire                 cf_rt_gt_eq_4s;
wire                 cf_rt_neg;
wire       [19:0]    rx_period_10g;
wire       [15:0]    rx_adj_fracns_10g;
wire       [15:0]    rx_adj_ns_10g;
wire       [19:0]    rx_period_1g;
wire       [15:0]    rx_adj_fracns_1g;
wire       [15:0]    rx_adj_ns_1g;
wire       [29:0]    rx_p2p_val_ns;
wire                 rx_p2p_val_valid;
wire       [15:0]    rx_p2p_val_fns;
wire                 ecc_corrected_err;
wire                 ecc_fatal_err;
wire                 ecc_corrected_err_ena;
wire                 ecc_fatal_err_ena;
wire                 tx_adptdcff_rdwtrmrk_dis;
wire       [ 2:0]    tx_adptdcff_rdwtrmrk;
wire       [ 2:0]    tx_adptdcff_vldpkt_minwt;

reg                  waitrequest_reg;

reg                  avs_read_flop;
reg                  reg_map_avs_read;
reg                  reg_map_avs_read_flop;
reg                  reg_map_avs_write;
wire       [ 9:0]    reg_map_avs_address;
wire       [31:0]    reg_map_avs_readdata;
wire       [31:0]    reg_map_avs_writedata;
reg        [31:0]    reg_map_avs_readdata_flop;

reg                  tx_stat_avs_read_csr_clk;
reg                  tx_stat_avs_write_csr_clk;
wire       [ 5:0]    tx_stat_avs_address_csr_clk;
wire       [31:0]    tx_stat_avs_readdata_csr_clk;
wire       [31:0]    tx_stat_avs_writedata_csr_clk;

reg                  rx_stat_avs_read_csr_clk;
reg                  rx_stat_avs_write_csr_clk;
wire       [ 5:0]    rx_stat_avs_address_csr_clk;
wire       [31:0]    rx_stat_avs_readdata_csr_clk;
wire       [31:0]    rx_stat_avs_writedata_csr_clk;

// Used when statistics running in TX/RX clock domain
wire                 tx_stat_avs_resp_done_csr_clk;
wire                 tx_stat_avs_cmd_done_csr_clk;

wire                 rx_stat_avs_resp_done_csr_clk;
wire                 rx_stat_avs_cmd_done_csr_clk;

wire                 tx_stat_avs_read_tx_clk;
wire                 tx_stat_avs_write_tx_clk;
wire       [ 5:0]    tx_stat_avs_address_tx_clk;
wire       [31:0]    tx_stat_avs_readdata_tx_clk;
wire       [31:0]    tx_stat_avs_writedata_tx_clk;
reg                  tx_stat_avs_waitrequest_tx_clk;
reg        [ 1:0]    tx_stat_mem_read_wait_tx_clk;

wire                 rx_stat_avs_read_rx_clk;
wire                 rx_stat_avs_write_rx_clk;
wire       [ 5:0]    rx_stat_avs_address_rx_clk;
wire       [31:0]    rx_stat_avs_readdata_rx_clk;
wire       [31:0]    rx_stat_avs_writedata_rx_clk;
reg                  rx_stat_avs_waitrequest_rx_clk;
reg        [ 1:0]    rx_stat_mem_read_wait_rx_clk;

wire                 tx_stat_access_csr_clk;
wire                 tx_stat_access_tx_clk;
wire                 rx_stat_access_csr_clk;
wire                 rx_stat_access_rx_clk;

wire                 tx_stat_mem_avs_read_tx_clk;
wire                 tx_stat_mem_avs_write_tx_clk;
wire       [ 5:0]    tx_stat_mem_avs_address_tx_clk;
wire       [31:0]    tx_stat_mem_avs_readdata_tx_clk;
wire       [31:0]    tx_stat_mem_avs_writedata_tx_clk;

wire                 tx_stat_reg_avs_read_tx_clk;
wire                 tx_stat_reg_avs_write_tx_clk;
wire       [ 5:0]    tx_stat_reg_avs_address_tx_clk;
wire       [31:0]    tx_stat_reg_avs_readdata_tx_clk;
wire       [31:0]    tx_stat_reg_avs_writedata_tx_clk;

wire                 rx_stat_mem_avs_read_rx_clk;
wire                 rx_stat_mem_avs_write_rx_clk;
wire       [ 5:0]    rx_stat_mem_avs_address_rx_clk;
wire       [31:0]    rx_stat_mem_avs_readdata_rx_clk;
wire       [31:0]    rx_stat_mem_avs_writedata_rx_clk;

wire                 rx_stat_reg_avs_read_rx_clk;
wire                 rx_stat_reg_avs_write_rx_clk;
wire       [ 5:0]    rx_stat_reg_avs_address_rx_clk;
wire       [31:0]    rx_stat_reg_avs_readdata_rx_clk;
wire       [31:0]    rx_stat_reg_avs_writedata_rx_clk;

reg                  tx_stat_avs_resp_done_csr_clk_p2;
reg                  rx_stat_avs_resp_done_csr_clk_p2;

reg                  stat_access_in_progress;

wire                 tx_mem_stat_update_ecc_err_corrected;
wire                 tx_mem_stat_update_ecc_err_fatal;
wire                 tx_mem_stat_csr_ecc_err_corrected;
wire                 tx_mem_stat_csr_ecc_err_fatal;

wire                 rx_mem_stat_update_ecc_err_corrected;
wire                 rx_mem_stat_update_ecc_err_fatal;
wire                 rx_mem_stat_csr_ecc_err_corrected;
wire                 rx_mem_stat_csr_ecc_err_fatal;

wire                 tx_mem_stat_update_ecc_err_corrected_tx_clk;
wire                 tx_mem_stat_update_ecc_err_fatal_tx_clk;
wire                 tx_mem_stat_csr_ecc_err_corrected_tx_clk;
wire                 tx_mem_stat_csr_ecc_err_fatal_tx_clk;

wire                 rx_mem_stat_update_ecc_err_corrected_rx_clk;
wire                 rx_mem_stat_update_ecc_err_fatal_rx_clk;
wire                 rx_mem_stat_csr_ecc_err_corrected_rx_clk;
wire                 rx_mem_stat_csr_ecc_err_fatal_rx_clk;

// Used when statistics running in CSR clock domain
reg        [ 1:0]    stat_read_wait;

wire                 csr_clk_tx_stat_valid;
wire       [39:0]    csr_clk_tx_stat_data;
wire       [ 6:0]    csr_clk_tx_stat_error;

wire                 csr_clk_rx_stat_valid;
wire       [39:0]    csr_clk_rx_stat_data;
wire       [ 6:0]    csr_clk_rx_stat_error;

wire                 tx_stat_mem_avs_read_csr_clk;
wire                 tx_stat_mem_avs_write_csr_clk;
wire       [ 5:0]    tx_stat_mem_avs_address_csr_clk;
wire       [31:0]    tx_stat_mem_avs_readdata_csr_clk;
wire       [31:0]    tx_stat_mem_avs_writedata_csr_clk;

wire                 tx_stat_reg_avs_read_csr_clk;
wire                 tx_stat_reg_avs_write_csr_clk;
wire       [ 5:0]    tx_stat_reg_avs_address_csr_clk;
wire       [31:0]    tx_stat_reg_avs_readdata_csr_clk;
wire       [31:0]    tx_stat_reg_avs_writedata_csr_clk;

wire                 rx_stat_mem_avs_read_csr_clk;
wire                 rx_stat_mem_avs_write_csr_clk;
wire       [ 5:0]    rx_stat_mem_avs_address_csr_clk;
wire       [31:0]    rx_stat_mem_avs_readdata_csr_clk;
wire       [31:0]    rx_stat_mem_avs_writedata_csr_clk;

wire                 rx_stat_reg_avs_read_csr_clk;
wire                 rx_stat_reg_avs_write_csr_clk;
wire       [ 5:0]    rx_stat_reg_avs_address_csr_clk;
wire       [31:0]    rx_stat_reg_avs_readdata_csr_clk;
wire       [31:0]    rx_stat_reg_avs_writedata_csr_clk;

wire                 tx_stat_cc_ecc_err_corrected;
wire                 tx_stat_cc_ecc_err_fatal;
wire                 rx_stat_cc_ecc_err_corrected;
wire                 rx_stat_cc_ecc_err_fatal;

// ECC Status
wire                 tx_gmii_encoder_ecc_err_corrected_csr_clk;
wire                 tx_gmii_encoder_ecc_err_fatal_csr_clk;
wire                 rx_gmii_decoder_ecc_err_corrected_csr_clk;
wire                 rx_gmii_decoder_ecc_err_fatal_csr_clk;

wire                 tx_ptp_request_control_ecc_err_corrected_csr_clk;
wire                 tx_ptp_request_control_ecc_err_fatal_csr_clk;
wire                 rx_ptp_aligner_ecc_err_corrected_csr_clk;
wire                 rx_ptp_aligner_ecc_err_fatal_csr_clk;

wire                 tx_mem_stat_update_ecc_err_corrected_csr_clk;
wire                 tx_mem_stat_update_ecc_err_fatal_csr_clk;
wire                 tx_mem_stat_csr_ecc_err_corrected_csr_clk;
wire                 tx_mem_stat_csr_ecc_err_fatal_csr_clk;

wire                 rx_mem_stat_update_ecc_err_corrected_csr_clk;
wire                 rx_mem_stat_update_ecc_err_fatal_csr_clk;
wire                 rx_mem_stat_csr_ecc_err_corrected_csr_clk;
wire                 rx_mem_stat_csr_ecc_err_fatal_csr_clk;

wire                 tx_mem_stat_update_ecc_err_corrected_csr_clk_selected;
wire                 tx_mem_stat_update_ecc_err_fatal_csr_clk_selected;
wire                 tx_mem_stat_csr_ecc_err_corrected_csr_clk_selected;
wire                 tx_mem_stat_csr_ecc_err_fatal_csr_clk_selected;

wire                 rx_mem_stat_update_ecc_err_corrected_csr_clk_selected;
wire                 rx_mem_stat_update_ecc_err_fatal_csr_clk_selected;
wire                 rx_mem_stat_csr_ecc_err_corrected_csr_clk_selected;
wire                 rx_mem_stat_csr_ecc_err_fatal_csr_clk_selected;

wire                 ecc_corrected_err_status_in;
wire                 ecc_fatal_err_status_in;

wire                 cf_overflow_ingress_status_in;
wire                 cf_overflow_egress_status_in;
wire                 cf_rt_gt_eq_4s_status_in;
wire                 cf_rt_neg_status_in;

wire                 ingress_overflow_csr_clk;
wire                 egress_overflow_csr_clk;
wire                 egress_rt_gt_4s_csr_clk;
wire                 egress_rt_neg_csr_clk;
wire                 cf_overflow_valid_csr_clk;


// wait request timeout
reg  [4:0]    waitrequest_timeout;
wire                 wait_request_timeout_in;

// Reset for clock crosser
wire                csr_tx_clk_cc_in_rst_n;
wire                csr_tx_clk_cc_out_rst_n;
wire                tx_clk_csr_cc_in_rst_n;
wire                tx_clk_csr_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//wire                csr_gmii_tx_clk_cc_in_rst_n;
//wire                csr_gmii_tx_clk_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//wire                gmii_tx_clk_csr_cc_in_rst_n;
//wire                gmii_tx_clk_csr_cc_out_rst_n;

wire                csr_rx_clk_cc_in_rst_n;
wire                csr_rx_clk_cc_out_rst_n;
wire                rx_clk_csr_cc_in_rst_n;
wire                rx_clk_csr_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//wire                csr_gmii_rx_clk_cc_in_rst_n;
//wire                csr_gmii_rx_clk_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//wire                gmii_rx_clk_csr_cc_in_rst_n;
//wire                gmii_rx_clk_csr_cc_out_rst_n;

assign csr_tx_clk_cc_in_rst_n               = csr_tx_cc_in_rst_n;
assign csr_tx_clk_cc_out_rst_n              = csr_tx_cc_out_rst_n;
assign tx_clk_csr_cc_in_rst_n               = tx_csr_cc_in_rst_n;
assign tx_clk_csr_cc_out_rst_n              = tx_csr_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//assign csr_gmii_tx_clk_cc_in_rst_n          = csr_gmii_tx_cc_in_rst_n;
//assign csr_gmii_tx_clk_cc_out_rst_n         = csr_gmii_tx_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//assign gmii_tx_clk_csr_cc_in_rst_n          = gmii_tx_csr_cc_in_rst_n;
//assign gmii_tx_clk_csr_cc_out_rst_n         = gmii_tx_csr_cc_out_rst_n;

assign csr_rx_clk_cc_in_rst_n               = csr_rx_cc_in_rst_n;
assign csr_rx_clk_cc_out_rst_n              = csr_rx_cc_out_rst_n;
assign rx_clk_csr_cc_in_rst_n               = rx_csr_cc_in_rst_n;
assign rx_clk_csr_cc_out_rst_n              = rx_csr_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//assign csr_gmii_rx_clk_cc_in_rst_n          = csr_gmii_rx_cc_in_rst_n;
//assign csr_gmii_rx_clk_cc_out_rst_n         = csr_gmii_rx_cc_out_rst_n;

// Unused for now: comment out to avoid warnings
//assign gmii_rx_clk_csr_cc_in_rst_n          = gmii_rx_csr_cc_in_rst_n;
//assign gmii_rx_clk_csr_cc_out_rst_n         = gmii_rx_csr_cc_out_rst_n;

// Avalon-MM Address Decoding
assign reg_map_avs_address = avs_address;
assign tx_stat_avs_address_csr_clk = avs_address[5:0];
assign rx_stat_avs_address_csr_clk = avs_address[5:0];

assign reg_map_avs_writedata = avs_writedata;
assign tx_stat_avs_writedata_csr_clk = avs_writedata;
assign rx_stat_avs_writedata_csr_clk = avs_writedata;

always @(*) begin
    if(avs_address[9:6] == 4'b0111) begin
        reg_map_avs_read          = 1'b0;
        tx_stat_avs_read_csr_clk  = 1'b0;
        rx_stat_avs_read_csr_clk  = avs_read;
        
        reg_map_avs_write         = 1'b0;
        tx_stat_avs_write_csr_clk = 1'b0;
        rx_stat_avs_write_csr_clk = avs_write;
        
        avs_readdata = instantiate_statistics ? rx_stat_avs_readdata_csr_clk : 32'h0;
    end
    else if(avs_address[9:6] == 4'b0101) begin
        reg_map_avs_read          = 1'b0;
        tx_stat_avs_read_csr_clk  = avs_read;
        rx_stat_avs_read_csr_clk  = 1'b0;
        
        reg_map_avs_write         = 1'b0;
        tx_stat_avs_write_csr_clk = avs_write;
        rx_stat_avs_write_csr_clk = 1'b0;
        
        avs_readdata = instantiate_statistics ? tx_stat_avs_readdata_csr_clk : 32'h0;
    end
    else begin
        // Prevent multiple read/write during waitrequest
        reg_map_avs_read          = avs_read & waitrequest_reg;
        tx_stat_avs_read_csr_clk  = 1'b0;
        rx_stat_avs_read_csr_clk  = 1'b0;
        
        reg_map_avs_write         = avs_write & waitrequest_reg;
        tx_stat_avs_write_csr_clk = 1'b0;
        rx_stat_avs_write_csr_clk = 1'b0;
        
        avs_readdata = reg_map_avs_readdata_flop;
    end
end

  generate if (SYNC_RESET_N == 1) begin
    always @ (posedge csr_clk) begin
        if(!csr_clk_rst_n) begin
            avs_read_flop             <= 1'b0;
            reg_map_avs_read_flop     <= 1'b0;
            reg_map_avs_readdata_flop <= 32'h0;
        end
        else begin
            avs_read_flop             <= avs_read;
            reg_map_avs_read_flop     <= reg_map_avs_read;
            reg_map_avs_readdata_flop <= reg_map_avs_readdata;
        end
    end
  end else begin
    always @ (posedge csr_clk or negedge csr_clk_rst_n) begin
        if(!csr_clk_rst_n) begin
            avs_read_flop             <= 1'b0;
            reg_map_avs_read_flop     <= 1'b0;
            reg_map_avs_readdata_flop <= 32'h0;
        end
        else begin
            avs_read_flop             <= avs_read;
            reg_map_avs_read_flop     <= reg_map_avs_read;
            reg_map_avs_readdata_flop <= reg_map_avs_readdata;
        end
    end
  end
  endgenerate

assign avs_waitrequest = waitrequest_reg;

generate if(STATISTICS_CSR_CLOCK == 0)
    begin : STAT_TX_RX_CLK

        assign tx_stat_access_csr_clk = tx_stat_avs_read_csr_clk | tx_stat_avs_write_csr_clk;
        assign rx_stat_access_csr_clk = rx_stat_avs_read_csr_clk | rx_stat_avs_write_csr_clk;

        if (SYNC_RESET_N == 1) begin
          always @ (posedge csr_clk)
              begin
              if(!csr_clk_rst_n)
                  begin
                  waitrequest_timeout <= 5'b0;
                  end
              else
                  begin
                  if((!tx_stat_avs_resp_done_csr_clk && tx_stat_access_csr_clk) || (!rx_stat_avs_resp_done_csr_clk && rx_stat_access_csr_clk))
                      begin
                      waitrequest_timeout <= waitrequest_timeout + 1'b1;
                      end
                  else
                      begin
                      waitrequest_timeout <= 5'b0;
                      end
                  end
              end
          
          
          always @(posedge csr_clk) begin
              if(!csr_clk_rst_n) begin
                  waitrequest_reg <= 1'b1;
              end
              else begin
                  if(tx_stat_access_csr_clk) begin
                      waitrequest_reg <= (waitrequest_timeout == 5'b1_1111)? 1'b0:~tx_stat_avs_resp_done_csr_clk;
                  end
                  else if(rx_stat_access_csr_clk) begin
                      waitrequest_reg <= (waitrequest_timeout == 5'b1_1111)? 1'b0:~rx_stat_avs_resp_done_csr_clk;
                  end
                  else if(((reg_map_avs_read && reg_map_avs_read_flop) | reg_map_avs_write) & waitrequest_reg) begin
                      waitrequest_reg <= 1'b0;
                  end
                  else begin
                      waitrequest_reg <= 1'b1;
                  end
              end
          end

          always @(posedge csr_clk) begin
              if(!csr_clk_rst_n) begin
                  tx_stat_avs_resp_done_csr_clk_p2 <= 1'b0;
                  rx_stat_avs_resp_done_csr_clk_p2 <= 1'b0;
                  
                  stat_access_in_progress <= 1'b0;
              end
              else begin
                  // Delay the clear of stat_access_in_progress register a cycle later than waitrequest
                  // So that CSR to TX/RX stat clock crosser will not sample the read/write request when waitrequest deasserted
                  tx_stat_avs_resp_done_csr_clk_p2 <= tx_stat_avs_resp_done_csr_clk;
                  rx_stat_avs_resp_done_csr_clk_p2 <= rx_stat_avs_resp_done_csr_clk;
                  
                  // Clear the stat_access_in_progress register, so that next read/write instruction could be processed by clock crosser
                  if(tx_stat_access_csr_clk & tx_stat_avs_resp_done_csr_clk_p2) begin
                      stat_access_in_progress <= 1'b0;
                  end
                  else if(rx_stat_access_csr_clk & rx_stat_avs_resp_done_csr_clk_p2) begin
                      stat_access_in_progress <= 1'b0;
                  end
                  else if(tx_stat_access_csr_clk) begin
                      // Clear the stat_access_in_progress register, to avoid CSR stall due to reset while reading from statistics
                      if(!csr_tx_cc_in_rst_n) begin
                          stat_access_in_progress <= 1'b0;
                      end
                      // Prevent clock crosser from taking further request input while processing until complete read is returned
                      else if(tx_stat_avs_cmd_done_csr_clk) begin
                          stat_access_in_progress <= 1'b1;
                      end
                      else begin
                          stat_access_in_progress <= stat_access_in_progress;
                      end
                  end
                  else if(rx_stat_access_csr_clk) begin
                      // Clear the stat_access_in_progress register, to avoid CSR stall due to reset while reading from statistics
                      if(!csr_rx_cc_in_rst_n) begin
                          stat_access_in_progress <= 1'b0;
                      end
                      // Prevent clock crosser from taking further request input while processing until complete read is returned
                      else if(rx_stat_avs_cmd_done_csr_clk) begin
                          stat_access_in_progress <= 1'b1;
                      end
                      else begin
                          stat_access_in_progress <= stat_access_in_progress;
                      end
                  end
                  else begin
                      stat_access_in_progress <= stat_access_in_progress;
                  end
              end
          end
        end else begin
          always @ (posedge csr_clk or negedge csr_clk_rst_n)
              begin
              if(!csr_clk_rst_n)
                  begin
                  waitrequest_timeout <= 5'b0;
                  end
              else
                  begin
                  if((!tx_stat_avs_resp_done_csr_clk && tx_stat_access_csr_clk) || (!rx_stat_avs_resp_done_csr_clk && rx_stat_access_csr_clk))
                      begin
                      waitrequest_timeout <= waitrequest_timeout + 1'b1;
                      end
                  else
                      begin
                      waitrequest_timeout <= 5'b0;
                      end
                  end
              end
          
          
          always @(posedge csr_clk or negedge csr_clk_rst_n) begin
              if(!csr_clk_rst_n) begin
                  waitrequest_reg <= 1'b1;
              end
              else begin
                  if(tx_stat_access_csr_clk) begin
                      waitrequest_reg <= (waitrequest_timeout == 5'b1_1111)? 1'b0:~tx_stat_avs_resp_done_csr_clk;
                  end
                  else if(rx_stat_access_csr_clk) begin
                      waitrequest_reg <= (waitrequest_timeout == 5'b1_1111)? 1'b0:~rx_stat_avs_resp_done_csr_clk;
                  end
                  else if(((reg_map_avs_read && reg_map_avs_read_flop) | reg_map_avs_write) & waitrequest_reg) begin
                      waitrequest_reg <= 1'b0;
                  end
                  else begin
                      waitrequest_reg <= 1'b1;
                  end
              end
          end

          always @(posedge csr_clk or negedge csr_clk_rst_n) begin
              if(!csr_clk_rst_n) begin
                  tx_stat_avs_resp_done_csr_clk_p2 <= 1'b0;
                  rx_stat_avs_resp_done_csr_clk_p2 <= 1'b0;
                  
                  stat_access_in_progress <= 1'b0;
              end
              else begin
                  // Delay the clear of stat_access_in_progress register a cycle later than waitrequest
                  // So that CSR to TX/RX stat clock crosser will not sample the read/write request when waitrequest deasserted
                  tx_stat_avs_resp_done_csr_clk_p2 <= tx_stat_avs_resp_done_csr_clk;
                  rx_stat_avs_resp_done_csr_clk_p2 <= rx_stat_avs_resp_done_csr_clk;
                  
                  // Clear the stat_access_in_progress register, so that next read/write instruction could be processed by clock crosser
                  if(tx_stat_access_csr_clk & tx_stat_avs_resp_done_csr_clk_p2) begin
                      stat_access_in_progress <= 1'b0;
                  end
                  else if(rx_stat_access_csr_clk & rx_stat_avs_resp_done_csr_clk_p2) begin
                      stat_access_in_progress <= 1'b0;
                  end
                  else if(tx_stat_access_csr_clk) begin
                      // Clear the stat_access_in_progress register, to avoid CSR stall due to reset while reading from statistics
                      if(!csr_tx_cc_in_rst_n) begin
                          stat_access_in_progress <= 1'b0;
                      end
                      // Prevent clock crosser from taking further request input while processing until complete read is returned
                      else if(tx_stat_avs_cmd_done_csr_clk) begin
                          stat_access_in_progress <= 1'b1;
                      end
                      else begin
                          stat_access_in_progress <= stat_access_in_progress;
                      end
                  end
                  else if(rx_stat_access_csr_clk) begin
                      // Clear the stat_access_in_progress register, to avoid CSR stall due to reset while reading from statistics
                      if(!csr_rx_cc_in_rst_n) begin
                          stat_access_in_progress <= 1'b0;
                      end
                      // Prevent clock crosser from taking further request input while processing until complete read is returned
                      else if(rx_stat_avs_cmd_done_csr_clk) begin
                          stat_access_in_progress <= 1'b1;
                      end
                      else begin
                          stat_access_in_progress <= stat_access_in_progress;
                      end
                  end
                  else begin
                      stat_access_in_progress <= stat_access_in_progress;
                  end
              end
          end
        end

        // TX CSR Access
        alt_em10g32_clock_crosser
        #(
            .SYMBOLS_PER_BEAT    (1),
            .BITS_PER_SYMBOL     (32 + 6 + 1 + 1),
            .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
            .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
            .USE_OUTPUT_PIPELINE (0)
        ) clock_crosser_tx_stat_csr_to_tx_clk (
            .in_clk      (csr_clk),
            .in_reset_n  (csr_tx_cc_in_rst_n),
            .in_ready    (tx_stat_avs_cmd_done_csr_clk),
            .in_valid    (tx_stat_access_csr_clk & ~stat_access_in_progress),
            .in_data     ({tx_stat_avs_read_csr_clk, tx_stat_avs_write_csr_clk, tx_stat_avs_address_csr_clk, tx_stat_avs_writedata_csr_clk}),
            .out_clk     (tx_clk),
            .out_reset_n (csr_tx_cc_out_rst_n),
            .out_ready   (~tx_stat_avs_waitrequest_tx_clk),
            .out_valid   (tx_stat_access_tx_clk),
            .out_data    ({tx_stat_avs_read_tx_clk, tx_stat_avs_write_tx_clk, tx_stat_avs_address_tx_clk, tx_stat_avs_writedata_tx_clk})
        );

        //assign tx_stat_avs_waitrequest_tx_clk = (tx_stat_mem_read_wait_tx_clk != 2'b00);

        if (SYNC_RESET_N == 1) begin
          always @(posedge tx_clk) begin
              if(!tx_clk_rst_n) begin
                  tx_stat_mem_read_wait_tx_clk <= 2'b11;
                  tx_stat_avs_waitrequest_tx_clk <= 1'b1;
              end
              else begin
                  if(tx_stat_access_tx_clk) begin
                      tx_stat_mem_read_wait_tx_clk <= tx_stat_mem_read_wait_tx_clk - 1'b1;
                      tx_stat_avs_waitrequest_tx_clk <= (tx_stat_mem_read_wait_tx_clk != 2'b01);
                  end
                  else begin
                      tx_stat_mem_read_wait_tx_clk <= 2'b11;
                  end
              end
          end
        end else begin
          always @(posedge tx_clk or negedge tx_clk_rst_n) begin
              if(!tx_clk_rst_n) begin
                  tx_stat_mem_read_wait_tx_clk <= 2'b11;
                  tx_stat_avs_waitrequest_tx_clk <= 1'b1;
              end
              else begin
                  // Statistics read/write latency always 4
                  if(tx_stat_access_tx_clk) begin
                      /* if(tx_stat_mem_read_wait_tx_clk == 2'b11) begin
                          tx_stat_mem_read_wait_tx_clk <= 2'b10;
                      end
                      else if(tx_stat_mem_read_wait_tx_clk == 2'b10) begin
                          tx_stat_mem_read_wait_tx_clk <= 2'b01;
                      end
                      else if(tx_stat_mem_read_wait_tx_clk == 2'b01) begin
                          tx_stat_mem_read_wait_tx_clk <= 2'b00;
                      end
                      else begin
                          tx_stat_mem_read_wait_tx_clk <= 2'b11;
                      end */
                      tx_stat_mem_read_wait_tx_clk <= tx_stat_mem_read_wait_tx_clk - 1'b1;
                      tx_stat_avs_waitrequest_tx_clk <= (tx_stat_mem_read_wait_tx_clk != 2'b01);
                  end
                  else begin
                      tx_stat_mem_read_wait_tx_clk <= 2'b11;
                  end
              end
          end
        end

        alt_em10g32_clock_crosser
        #(
            .SYMBOLS_PER_BEAT    (1),
            .BITS_PER_SYMBOL     (32),
            .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
            .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
            .USE_OUTPUT_PIPELINE (0)
        ) clock_crosser_tx_stat_tx_to_csr_clk (
            .in_clk      (tx_clk),
            .in_reset_n  (tx_csr_cc_in_rst_n),
            .in_ready    (),
            .in_valid    (~tx_stat_avs_waitrequest_tx_clk),
            .in_data     (tx_stat_avs_readdata_tx_clk),
            .out_clk     (csr_clk),
            .out_reset_n (tx_csr_cc_out_rst_n),
            .out_ready   (1'b1),
            .out_valid   (tx_stat_avs_resp_done_csr_clk),
            .out_data    (tx_stat_avs_readdata_csr_clk)
        );

        // RX CSR Access
        alt_em10g32_clock_crosser
        #(
            .SYMBOLS_PER_BEAT    (1),
            .BITS_PER_SYMBOL     (32 + 6 + 1 + 1),
            .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
            .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
            .USE_OUTPUT_PIPELINE (0)
        ) clock_crosser_rx_stat_csr_to_rx_clk (
            .in_clk      (csr_clk),
            .in_reset_n  (csr_rx_cc_in_rst_n),
            .in_ready    (rx_stat_avs_cmd_done_csr_clk),
            .in_valid    (rx_stat_access_csr_clk & ~stat_access_in_progress),
            .in_data     ({rx_stat_avs_read_csr_clk, rx_stat_avs_write_csr_clk, rx_stat_avs_address_csr_clk, rx_stat_avs_writedata_csr_clk}),
            .out_clk     (rx_clk),
            .out_reset_n (csr_rx_cc_out_rst_n),
            .out_ready   (~rx_stat_avs_waitrequest_rx_clk),
            .out_valid   (rx_stat_access_rx_clk),
            .out_data    ({rx_stat_avs_read_rx_clk, rx_stat_avs_write_rx_clk, rx_stat_avs_address_rx_clk, rx_stat_avs_writedata_rx_clk})
        );

        // assign rx_stat_avs_waitrequest_rx_clk = (rx_stat_mem_read_wait_rx_clk != 2'b00);

        if (SYNC_RESET_N == 1) begin
          always @(posedge rx_clk) begin
              if(!rx_clk_rst_n) begin
                  rx_stat_mem_read_wait_rx_clk <= 2'b11;
                  rx_stat_avs_waitrequest_rx_clk <= 1'b1;
              end
              else begin
                  if(rx_stat_access_rx_clk) begin
                      rx_stat_mem_read_wait_rx_clk <= rx_stat_mem_read_wait_rx_clk - 1'b1;
                      rx_stat_avs_waitrequest_rx_clk <= (rx_stat_mem_read_wait_rx_clk != 2'b01);
                  end
                  else begin
                      rx_stat_mem_read_wait_rx_clk <= 2'b11;
                  end
              end
          end
        end else begin
          always @(posedge rx_clk or negedge rx_clk_rst_n) begin
              if(!rx_clk_rst_n) begin
                  rx_stat_mem_read_wait_rx_clk <= 2'b11;
                  rx_stat_avs_waitrequest_rx_clk <= 1'b1;
              end
              else begin
                  // Statistics read/write latency always 4
                  if(rx_stat_access_rx_clk) begin
                      /* if(rx_stat_mem_read_wait_rx_clk == 2'b11) begin
                          rx_stat_mem_read_wait_rx_clk <= 2'b10;
                      end
                      else if(rx_stat_mem_read_wait_rx_clk == 2'b10) begin
                          rx_stat_mem_read_wait_rx_clk <= 2'b01;
                      end
                      else if(rx_stat_mem_read_wait_rx_clk == 2'b01) begin
                          rx_stat_mem_read_wait_rx_clk <= 2'b00;
                      end
                      else begin
                          rx_stat_mem_read_wait_rx_clk <= 2'b11;
                      end */
                      rx_stat_mem_read_wait_rx_clk <= rx_stat_mem_read_wait_rx_clk - 1'b1;
                      rx_stat_avs_waitrequest_rx_clk <= (rx_stat_mem_read_wait_rx_clk != 2'b01);
                  end
                  else begin
                      rx_stat_mem_read_wait_rx_clk <= 2'b11;
                  end
              end
          end
        end

        alt_em10g32_clock_crosser
        #(
            .SYMBOLS_PER_BEAT    (1),
            .BITS_PER_SYMBOL     (32),
            .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
            .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
            .USE_OUTPUT_PIPELINE (0)
        ) clock_crosser_rx_stat_rx_to_csr_clk (
            .in_clk      (rx_clk),
            .in_reset_n  (rx_csr_cc_in_rst_n),
            .in_ready    (),
            .in_valid    (~rx_stat_avs_waitrequest_rx_clk),
            .in_data     (rx_stat_avs_readdata_rx_clk),
            .out_clk     (csr_clk),
            .out_reset_n (rx_csr_cc_out_rst_n),
            .out_ready   (1'b1),
            .out_valid   (rx_stat_avs_resp_done_csr_clk),
            .out_data    (rx_stat_avs_readdata_csr_clk)
        );

        // TX Statistics
        assign tx_stat_mem_avs_read_tx_clk = tx_stat_avs_read_tx_clk & tx_stat_access_tx_clk & ~register_based_statistics & instantiate_statistics;
        assign tx_stat_mem_avs_write_tx_clk = tx_stat_avs_write_tx_clk & tx_stat_access_tx_clk & ~register_based_statistics & instantiate_statistics;
        assign tx_stat_mem_avs_address_tx_clk = tx_stat_avs_address_tx_clk;
        assign tx_stat_mem_avs_writedata_tx_clk = tx_stat_avs_writedata_tx_clk;

        assign tx_stat_reg_avs_read_tx_clk = tx_stat_avs_read_tx_clk & tx_stat_access_tx_clk & register_based_statistics & instantiate_statistics & (tx_stat_mem_read_wait_tx_clk == 2'b11);
        assign tx_stat_reg_avs_write_tx_clk = tx_stat_avs_write_tx_clk & tx_stat_access_tx_clk & register_based_statistics & instantiate_statistics & (tx_stat_mem_read_wait_tx_clk == 2'b11);
        assign tx_stat_reg_avs_address_tx_clk = tx_stat_avs_address_tx_clk;
        assign tx_stat_reg_avs_writedata_tx_clk = tx_stat_avs_writedata_tx_clk;

        assign tx_stat_avs_readdata_tx_clk = ~register_based_statistics ? tx_stat_mem_avs_readdata_tx_clk : tx_stat_reg_avs_readdata_tx_clk;

        // use generate block to instantiate stat mem module to eliminate the synthesis warning
        if(INSTANTIATE_STATISTICS && (REGISTER_BASED_STATISTICS == 0))
        begin
        // TX Memory Statistics
        alt_em10g32_stat_mem #(
            .DEVICE_FAMILY(DEVICE_FAMILY),
            .ENABLE_MEM_ECC(ENABLE_MEM_ECC),
            .SYNC_RESET_N(SYNC_RESET_N)
        ) tx_stat_mem (
            // Clock and Reset
            .clk                (tx_clk),
            .csr_reset_n        (csr_rst_tx_clk_n),

            // CSR Interface
            .csr_read           (tx_stat_mem_avs_read_tx_clk),
            .csr_address        (tx_stat_mem_avs_address_tx_clk),
            .csr_readdata       (tx_stat_mem_avs_readdata_tx_clk),
            .csr_write          (tx_stat_mem_avs_write_tx_clk),
            .csr_writedata      (tx_stat_mem_avs_writedata_tx_clk),

            // Frame Status
            .stat_sink_valid    (tx_stat_valid),
            .stat_sink_data     (tx_stat_data),
            .stat_sink_error    (tx_stat_error),

            // ECC Status
            .mem_stat_update_ecc_err_corrected  (tx_mem_stat_update_ecc_err_corrected_tx_clk),
            .mem_stat_update_ecc_err_fatal      (tx_mem_stat_update_ecc_err_fatal_tx_clk),
            .mem_stat_csr_ecc_err_corrected     (tx_mem_stat_csr_ecc_err_corrected_tx_clk),
            .mem_stat_csr_ecc_err_fatal         (tx_mem_stat_csr_ecc_err_fatal_tx_clk),
            
            // Parameters
            .enable_pfc         (enable_pfc)
        );
        end
        else
        begin
        assign tx_stat_mem_avs_readdata_tx_clk = 32'b0;
        assign tx_mem_stat_update_ecc_err_corrected_tx_clk = 1'b0;
        assign tx_mem_stat_update_ecc_err_fatal_tx_clk = 1'b0;
        assign tx_mem_stat_csr_ecc_err_corrected_tx_clk = 1'b0;
        assign tx_mem_stat_csr_ecc_err_fatal_tx_clk = 1'b0;
        end

        // TX Register Statistics
        alt_em10g32_stat_reg #(
            .SYNC_RESET_N(SYNC_RESET_N)
        ) tx_stat_reg(
            // Clock and Reset
            .clk                (tx_clk),
            .csr_reset_n        (csr_rst_tx_clk_n),

            // CSR Interface
            .csr_read           (tx_stat_reg_avs_read_tx_clk),
            .csr_address        (tx_stat_reg_avs_address_tx_clk),
            .csr_readdata       (tx_stat_reg_avs_readdata_tx_clk),
            .csr_write          (tx_stat_reg_avs_write_tx_clk),
            .csr_writedata      (tx_stat_reg_avs_writedata_tx_clk),

            // Frame Status
            .stat_sink_valid    (tx_stat_valid),
            .stat_sink_data     (tx_stat_data),
            .stat_sink_error    (tx_stat_error),

            // Parameters
            .enable_pfc         (enable_pfc)
        );

        // RX Statistics
        assign rx_stat_mem_avs_read_rx_clk = rx_stat_avs_read_rx_clk & rx_stat_access_rx_clk & ~register_based_statistics & instantiate_statistics;
        assign rx_stat_mem_avs_write_rx_clk = rx_stat_avs_write_rx_clk & rx_stat_access_rx_clk & ~register_based_statistics & instantiate_statistics;
        assign rx_stat_mem_avs_address_rx_clk = rx_stat_avs_address_rx_clk;
        assign rx_stat_mem_avs_writedata_rx_clk = rx_stat_avs_writedata_rx_clk;

        assign rx_stat_reg_avs_read_rx_clk = rx_stat_avs_read_rx_clk & rx_stat_access_rx_clk & register_based_statistics & instantiate_statistics & (rx_stat_mem_read_wait_rx_clk == 2'b11);
        assign rx_stat_reg_avs_write_rx_clk = rx_stat_avs_write_rx_clk & rx_stat_access_rx_clk & register_based_statistics & instantiate_statistics & (rx_stat_mem_read_wait_rx_clk == 2'b11);
        assign rx_stat_reg_avs_address_rx_clk = rx_stat_avs_address_rx_clk;
        assign rx_stat_reg_avs_writedata_rx_clk = rx_stat_avs_writedata_rx_clk;

        assign rx_stat_avs_readdata_rx_clk = ~register_based_statistics ? rx_stat_mem_avs_readdata_rx_clk : rx_stat_reg_avs_readdata_rx_clk;

        // use generate block to instantiate stat mem module to eliminate the synthesis warning
        if(INSTANTIATE_STATISTICS && (REGISTER_BASED_STATISTICS == 0))
        begin
        // RX Memory Statistics
        alt_em10g32_stat_mem #(
            .DEVICE_FAMILY(DEVICE_FAMILY),
            .ENABLE_MEM_ECC(ENABLE_MEM_ECC),
            .SYNC_RESET_N(SYNC_RESET_N)
        ) rx_stat_mem (
            // Clock and Reset
            .clk                (rx_clk),
            .csr_reset_n        (csr_rst_rx_clk_n),

            // CSR Interface
            .csr_read           (rx_stat_mem_avs_read_rx_clk),
            .csr_address        (rx_stat_mem_avs_address_rx_clk),
            .csr_readdata       (rx_stat_mem_avs_readdata_rx_clk),
            .csr_write          (rx_stat_mem_avs_write_rx_clk),
            .csr_writedata      (rx_stat_mem_avs_writedata_rx_clk),

            // Frame Status
            .stat_sink_valid    (rx_stat_valid),
            .stat_sink_data     (rx_stat_data),
            .stat_sink_error    (rx_stat_error),
            
            // ECC Status
            .mem_stat_update_ecc_err_corrected  (rx_mem_stat_update_ecc_err_corrected_rx_clk),
            .mem_stat_update_ecc_err_fatal      (rx_mem_stat_update_ecc_err_fatal_rx_clk),
            .mem_stat_csr_ecc_err_corrected     (rx_mem_stat_csr_ecc_err_corrected_rx_clk),
            .mem_stat_csr_ecc_err_fatal         (rx_mem_stat_csr_ecc_err_fatal_rx_clk),
            
            // Parameters
            .enable_pfc         (enable_pfc)
        );
        end
        else
        begin
        assign rx_stat_mem_avs_readdata_rx_clk = 32'b0;
        assign rx_mem_stat_update_ecc_err_corrected_rx_clk = 1'b0;
        assign rx_mem_stat_update_ecc_err_fatal_rx_clk = 1'b0;
        assign rx_mem_stat_csr_ecc_err_corrected_rx_clk = 1'b0;
        assign rx_mem_stat_csr_ecc_err_fatal_rx_clk = 1'b0;
        end

        // RX Register Statistics
        alt_em10g32_stat_reg #(
            .SYNC_RESET_N(SYNC_RESET_N)
        ) rx_stat_reg(
            // Clock and Reset
            .clk                (rx_clk),
            .csr_reset_n        (csr_rst_rx_clk_n),

            // CSR Interface
            .csr_read           (rx_stat_reg_avs_read_rx_clk),
            .csr_address        (rx_stat_reg_avs_address_rx_clk),
            .csr_readdata       (rx_stat_reg_avs_readdata_rx_clk),
            .csr_write          (rx_stat_reg_avs_write_rx_clk),
            .csr_writedata      (rx_stat_reg_avs_writedata_rx_clk),

            // Frame Status
            .stat_sink_valid    (rx_stat_valid),
            .stat_sink_data     (rx_stat_data),
            .stat_sink_error    (rx_stat_error),

            // Parameters
            .enable_pfc         (enable_pfc)
        );
        
        assign tx_stat_cc_ecc_err_corrected = 1'b0;
        assign tx_stat_cc_ecc_err_fatal = 1'b0;
        
        assign rx_stat_cc_ecc_err_corrected = 1'b0;
        assign rx_stat_cc_ecc_err_fatal = 1'b0;
        
        assign tx_mem_stat_update_ecc_err_corrected = 1'b0;
        assign tx_mem_stat_update_ecc_err_fatal = 1'b0;
        assign tx_mem_stat_csr_ecc_err_corrected = 1'b0;
        assign tx_mem_stat_csr_ecc_err_fatal = 1'b0;
        
        assign rx_mem_stat_update_ecc_err_corrected = 1'b0;
        assign rx_mem_stat_update_ecc_err_fatal = 1'b0;
        assign rx_mem_stat_csr_ecc_err_corrected = 1'b0;
        assign rx_mem_stat_csr_ecc_err_fatal = 1'b0;
    end
else
    begin : STAT_CSR_CLK
        
        always @ (*)
            begin
            waitrequest_timeout = 5'b0_0000;
            end
            
        
        if (SYNC_RESET_N == 1) begin
          always @(posedge csr_clk) begin
              if(!csr_clk_rst_n) begin
                  waitrequest_reg <= 1'b1;
                  stat_read_wait <= 2'b11;
              end
              else begin
                  // Memory based statistics read latency = 4
                  if((instantiate_statistics && !register_based_statistics) &&
                     ((avs_address[9:6] == 4'b0111) || (avs_address[9:6] == 4'b0101)) &&
                     avs_read && waitrequest_reg) begin
                      if(stat_read_wait == 2'b11) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b10;
                      end
                      else if(stat_read_wait == 2'b10) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b01;
                      end
                      else if(stat_read_wait == 2'b01) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b00;
                      end
                      else begin
                          waitrequest_reg <= 1'b0;
                          stat_read_wait <= 2'b11;
                      end
                  end
                  
                  // Register based statistics read latency = 2
                  else if((instantiate_statistics && register_based_statistics) &&
                     ((avs_address[9:6] == 4'b0111) || (avs_address[9:6] == 4'b0101)) &&
                     avs_read && waitrequest_reg) begin
                      if(stat_read_wait == 2'b11) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b10;
                      end
                      else if(stat_read_wait == 2'b10) begin
                          waitrequest_reg <= 1'b0;
                          stat_read_wait <= 2'b01;
                      end
                      else begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b11;
                      end
                  end
                  
                  // Read from or write to other registers latency = 1
                  else if(((avs_read && avs_read_flop) | avs_write) && waitrequest_reg) begin
                      waitrequest_reg <= 1'b0;
                      stat_read_wait <= 2'b11;
                  end
                  else begin
                      waitrequest_reg <= 1'b1;
                      stat_read_wait <= 2'b11;
                  end
              end
          end
        end else begin
          always @(posedge csr_clk or negedge csr_clk_rst_n) begin
              if(!csr_clk_rst_n) begin
                  waitrequest_reg <= 1'b1;
                  stat_read_wait <= 2'b11;
              end
              else begin
                  // Memory based statistics read latency = 4
                  if((instantiate_statistics && !register_based_statistics) &&
                     ((avs_address[9:6] == 4'b0111) || (avs_address[9:6] == 4'b0101)) &&
                     avs_read && waitrequest_reg) begin
                      if(stat_read_wait == 2'b11) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b10;
                      end
                      else if(stat_read_wait == 2'b10) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b01;
                      end
                      else if(stat_read_wait == 2'b01) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b00;
                      end
                      else begin
                          waitrequest_reg <= 1'b0;
                          stat_read_wait <= 2'b11;
                      end
                  end
                  
                  // Register based statistics read latency = 2
                  else if((instantiate_statistics && register_based_statistics) &&
                     ((avs_address[9:6] == 4'b0111) || (avs_address[9:6] == 4'b0101)) &&
                     avs_read && waitrequest_reg) begin
                      if(stat_read_wait == 2'b11) begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b10;
                      end
                      else if(stat_read_wait == 2'b10) begin
                          waitrequest_reg <= 1'b0;
                          stat_read_wait <= 2'b01;
                      end
                      else begin
                          waitrequest_reg <= 1'b1;
                          stat_read_wait <= 2'b11;
                      end
                  end
                  
                  // Read from or write to other registers latency = 1
                  else if(((avs_read && avs_read_flop) | avs_write) && waitrequest_reg) begin
                      waitrequest_reg <= 1'b0;
                      stat_read_wait <= 2'b11;
                  end
                  else begin
                      waitrequest_reg <= 1'b1;
                      stat_read_wait <= 2'b11;
                  end
              end
          end
        end
        
        // TX Statistics CSR Interface
        assign tx_stat_mem_avs_read_csr_clk      = tx_stat_avs_read_csr_clk & ~register_based_statistics & instantiate_statistics;
        assign tx_stat_mem_avs_write_csr_clk     = tx_stat_avs_write_csr_clk & ~register_based_statistics & instantiate_statistics & waitrequest_reg;
        assign tx_stat_mem_avs_address_csr_clk   = tx_stat_avs_address_csr_clk;
        assign tx_stat_mem_avs_writedata_csr_clk = tx_stat_avs_writedata_csr_clk;
        
        assign tx_stat_reg_avs_read_csr_clk      = tx_stat_avs_read_csr_clk & register_based_statistics & instantiate_statistics & (stat_read_wait == 2'b11);
        assign tx_stat_reg_avs_write_csr_clk     = tx_stat_avs_write_csr_clk & register_based_statistics & instantiate_statistics & waitrequest_reg;
        assign tx_stat_reg_avs_address_csr_clk   = tx_stat_avs_address_csr_clk;
        assign tx_stat_reg_avs_writedata_csr_clk = tx_stat_avs_writedata_csr_clk;
        
        assign tx_stat_avs_readdata_csr_clk = register_based_statistics ? tx_stat_reg_avs_readdata_csr_clk : tx_stat_mem_avs_readdata_csr_clk;
        
        // RX Statistics CSR Interface
        assign rx_stat_mem_avs_read_csr_clk      = rx_stat_avs_read_csr_clk & ~register_based_statistics & instantiate_statistics;
        assign rx_stat_mem_avs_write_csr_clk     = rx_stat_avs_write_csr_clk & ~register_based_statistics & instantiate_statistics & waitrequest_reg;
        assign rx_stat_mem_avs_address_csr_clk   = rx_stat_avs_address_csr_clk;
        assign rx_stat_mem_avs_writedata_csr_clk = rx_stat_avs_writedata_csr_clk;
        
        assign rx_stat_reg_avs_read_csr_clk      = rx_stat_avs_read_csr_clk & register_based_statistics & instantiate_statistics & (stat_read_wait == 2'b11);
        assign rx_stat_reg_avs_write_csr_clk     = rx_stat_avs_write_csr_clk & register_based_statistics & instantiate_statistics & waitrequest_reg;
        assign rx_stat_reg_avs_address_csr_clk   = rx_stat_avs_address_csr_clk;
        assign rx_stat_reg_avs_writedata_csr_clk = rx_stat_avs_writedata_csr_clk;
        
        assign rx_stat_avs_readdata_csr_clk = register_based_statistics ? rx_stat_reg_avs_readdata_csr_clk : rx_stat_mem_avs_readdata_csr_clk;
        
        if(STATISTICS_CSR_CLOCK_DC_FIFO == 0) begin
            // TX Statistics Clock Crosser
            alt_em10g32_rr_clock_crosser #(
                .NUM_OF_CHANNEL      (4),
                
                .SYMBOLS_PER_BEAT    (1),
                .BITS_PER_SYMBOL     (40),
                .CHANNEL_WIDTH       (0),
                .ERROR_WIDTH         (7),
                .USE_PACKETS         (0),
                
                .FORWARD_SYNC_DEPTH  (3),
                .BACKWARD_SYNC_DEPTH (3),
                
                .USE_OUTPUT_PIPELINE (0),
                .SYNC_RESET_N        (SYNC_RESET_N)
            ) clock_crosser_csr_clk_tx_stat(
                .in_clk             (tx_clk),
                .in_reset_n         (tx_csr_cc_in_rst_n),
                .in_valid           (tx_stat_valid),
                .in_ready           (),
                .in_data            (tx_stat_data),
                .in_startofpacket   (1'b0),
                .in_endofpacket     (1'b0),
                .in_empty           (1'b0),
                .in_error           (tx_stat_error),
                .in_channel         (1'b0),
                .out_clk            (csr_clk),
                .out_reset_n        (tx_csr_cc_out_rst_n),
                .out_valid          (csr_clk_tx_stat_valid),
                .out_ready          (1'b1),
                .out_data           (csr_clk_tx_stat_data),
                .out_startofpacket  (),
                .out_endofpacket    (),
                .out_empty          (),
                .out_error          (csr_clk_tx_stat_error),
                .out_channel        ()
            );
            
            assign tx_stat_cc_ecc_err_corrected = 1'b0;
            assign tx_stat_cc_ecc_err_fatal = 1'b0;
        end
        else begin
            // TX Statistics Clock Crosser DC FIFO
            alt_em10g32_avalon_dc_fifo_secc #(
                .ENABLE_MEM_ECC             (ENABLE_MEM_ECC),
                .ECC_BLOCK_WIDTH            (32),
                .REGISTER_ENC_INPUT         (0),
                .REGISTER_ENC_OUTPUT        (0),
                .REGISTER_DEC_INPUT         (0),
                .REGISTER_DEC_OUTPUT        (0),
                
                .SYMBOLS_PER_BEAT           (1),
                .BITS_PER_SYMBOL            (40),
                .FIFO_DEPTH                 (16),
                .CHANNEL_WIDTH              (0),
                .ERROR_WIDTH                (7),
                .USE_PACKETS                (0),
                
                .USE_IN_FILL_LEVEL          (0),
                .USE_OUT_FILL_LEVEL         (0),
                .WR_SYNC_DEPTH              (SYNCHRONIZER_DEPTH),
                .RD_SYNC_DEPTH              (SYNCHRONIZER_DEPTH),
                .STREAM_ALMOST_FULL         (0),
                .STREAM_ALMOST_EMPTY        (0),
                
                .BACKPRESSURE_DURING_RESET  (0),
                .SYNC_RESET_N               (SYNC_RESET_N)
            ) dc_fifo_csr_clk_tx_stat(
                .in_clk             (tx_clk),
                .in_reset_n         (tx_clk_rst_n),
                
                .out_clk            (csr_clk),
                .out_reset_n        (csr_clk_rst_n),
                
                .in_data            (tx_stat_data),
                .in_valid           (tx_stat_valid),
                .in_startofpacket   (1'b0),
                .in_endofpacket     (1'b0),
                .in_empty           (1'b0),
                .in_error           (tx_stat_error),
                .in_channel         (1'b0),
                .in_ready           (),
                
                .out_data           (csr_clk_tx_stat_data),
                .out_valid          (csr_clk_tx_stat_valid),
                .out_startofpacket  (),
                .out_endofpacket    (),
                .out_empty          (),
                .out_error          (csr_clk_tx_stat_error),
                .out_channel        (),
                .out_ready          (1'b1),
                
                .in_csr_address     (1'b0),
                .in_csr_read        (1'b0),
                .in_csr_write       (1'b0),
                .in_csr_writedata   (32'h0),
                .in_csr_readdata    (),
                
                .out_csr_address    (1'b0),
                .out_csr_read       (1'b0),
                .out_csr_write      (1'b0),
                .out_csr_writedata  (32'h0),
                .out_csr_readdata   (),
                
                .almost_full_valid  (),
                .almost_full_data   (),
                .almost_empty_valid (),
                .almost_empty_data  (),
                
                .space_avail_data   (),
                
                .ecc_err_corrected  (tx_stat_cc_ecc_err_corrected),
                .ecc_err_detected   (),
                .ecc_err_fatal      (tx_stat_cc_ecc_err_fatal)
            );
        end
        
        if(INSTANTIATE_STATISTICS && (REGISTER_BASED_STATISTICS == 0))
        begin
        // TX Memory Statistics
        alt_em10g32_stat_mem #(
            .DEVICE_FAMILY(DEVICE_FAMILY),
            .ENABLE_MEM_ECC(ENABLE_MEM_ECC),
            .SYNC_RESET_N(SYNC_RESET_N)
        ) tx_stat_mem (
            // Clock and Reset
            .clk                (csr_clk),
            .csr_reset_n        (csr_clk_rst_n),

            // CSR Interface
            .csr_read           (tx_stat_mem_avs_read_csr_clk),
            .csr_address        (tx_stat_mem_avs_address_csr_clk),
            .csr_readdata       (tx_stat_mem_avs_readdata_csr_clk),
            .csr_write          (tx_stat_mem_avs_write_csr_clk),
            .csr_writedata      (tx_stat_mem_avs_writedata_csr_clk),

            // Frame Status
            .stat_sink_valid    (csr_clk_tx_stat_valid),
            .stat_sink_data     (csr_clk_tx_stat_data),
            .stat_sink_error    (csr_clk_tx_stat_error),
            
            // ECC Status
            .mem_stat_update_ecc_err_corrected  (tx_mem_stat_update_ecc_err_corrected),
            .mem_stat_update_ecc_err_fatal      (tx_mem_stat_update_ecc_err_fatal),
            .mem_stat_csr_ecc_err_corrected     (tx_mem_stat_csr_ecc_err_corrected),
            .mem_stat_csr_ecc_err_fatal         (tx_mem_stat_csr_ecc_err_fatal),
            
            // Parameters
            .enable_pfc         (enable_pfc)
        );
        end
        else
        begin
        assign tx_stat_mem_avs_readdata_csr_clk = 32'b0;
        assign tx_mem_stat_update_ecc_err_corrected = 1'b0;
        assign tx_mem_stat_update_ecc_err_fatal = 1'b0;
        assign tx_mem_stat_csr_ecc_err_corrected = 1'b0;
        assign tx_mem_stat_csr_ecc_err_fatal = 1'b0;
        end

        // TX Register Statistics
        alt_em10g32_stat_reg #(
            .SYNC_RESET_N(SYNC_RESET_N)
        ) tx_stat_reg(
            // Clock and Reset
            .clk                (csr_clk),
            .csr_reset_n        (csr_clk_rst_n),

            // CSR Interface
            .csr_read           (tx_stat_reg_avs_read_csr_clk),
            .csr_address        (tx_stat_reg_avs_address_csr_clk),
            .csr_readdata       (tx_stat_reg_avs_readdata_csr_clk),
            .csr_write          (tx_stat_reg_avs_write_csr_clk),
            .csr_writedata      (tx_stat_reg_avs_writedata_csr_clk),

            // Frame Status
            .stat_sink_valid    (csr_clk_tx_stat_valid),
            .stat_sink_data     (csr_clk_tx_stat_data),
            .stat_sink_error    (csr_clk_tx_stat_error),

            // Parameters
            .enable_pfc         (enable_pfc)
        );
        
        if(STATISTICS_CSR_CLOCK_DC_FIFO == 0) begin
            // RX Statistics Clock Crosser
            alt_em10g32_rr_clock_crosser #(
                .NUM_OF_CHANNEL      (4),
                
                .SYMBOLS_PER_BEAT    (1),
                .BITS_PER_SYMBOL     (40),
                .CHANNEL_WIDTH       (0),
                .ERROR_WIDTH         (7),
                .USE_PACKETS         (0),
                
                .FORWARD_SYNC_DEPTH  (3),
                .BACKWARD_SYNC_DEPTH (3),
                
                .USE_OUTPUT_PIPELINE (0),
                .SYNC_RESET_N        (SYNC_RESET_N)
            ) clock_crosser_csr_clk_rx_stat(
                .in_clk             (rx_clk),
                .in_reset_n         (rx_csr_cc_in_rst_n),
                .in_valid           (rx_stat_valid),
                .in_ready           (),
                .in_data            (rx_stat_data),
                .in_startofpacket   (1'b0),
                .in_endofpacket     (1'b0),
                .in_empty           (1'b0),
                .in_error           (rx_stat_error),
                .in_channel         (1'b0),
                .out_clk            (csr_clk),
                .out_reset_n        (rx_csr_cc_out_rst_n),
                .out_valid          (csr_clk_rx_stat_valid),
                .out_ready          (1'b1),
                .out_data           (csr_clk_rx_stat_data),
                .out_startofpacket  (),
                .out_endofpacket    (),
                .out_empty          (),
                .out_error          (csr_clk_rx_stat_error),
                .out_channel        ()
            );
            
            assign rx_stat_cc_ecc_err_corrected = 1'b0;
            assign rx_stat_cc_ecc_err_fatal = 1'b0;
        end
        else begin
            // RX Statistics Clock Crosser DC FIFO
            alt_em10g32_avalon_dc_fifo_secc #(
                .ENABLE_MEM_ECC             (ENABLE_MEM_ECC),
                .ECC_BLOCK_WIDTH            (32),
                .REGISTER_ENC_INPUT         (0),
                .REGISTER_ENC_OUTPUT        (0),
                .REGISTER_DEC_INPUT         (0),
                .REGISTER_DEC_OUTPUT        (0),
                
                .SYMBOLS_PER_BEAT           (1),
                .BITS_PER_SYMBOL            (40),
                .FIFO_DEPTH                 (16),
                .CHANNEL_WIDTH              (0),
                .ERROR_WIDTH                (7),
                .USE_PACKETS                (0),
                
                .USE_IN_FILL_LEVEL          (0),
                .USE_OUT_FILL_LEVEL         (0),
                .WR_SYNC_DEPTH              (SYNCHRONIZER_DEPTH),
                .RD_SYNC_DEPTH              (SYNCHRONIZER_DEPTH),
                .STREAM_ALMOST_FULL         (0),
                .STREAM_ALMOST_EMPTY        (0),
                
                .BACKPRESSURE_DURING_RESET  (0),
                .SYNC_RESET_N               (SYNC_RESET_N)
            ) dc_fifo_csr_clk_rx_stat(
                .in_clk             (rx_clk),
                .in_reset_n         (rx_clk_rst_n),
                
                .out_clk            (csr_clk),
                .out_reset_n        (csr_clk_rst_n),
                
                .in_data            (rx_stat_data),
                .in_valid           (rx_stat_valid),
                .in_startofpacket   (1'b0),
                .in_endofpacket     (1'b0),
                .in_empty           (1'b0),
                .in_error           (rx_stat_error),
                .in_channel         (1'b0),
                .in_ready           (),
                
                .out_data           (csr_clk_rx_stat_data),
                .out_valid          (csr_clk_rx_stat_valid),
                .out_startofpacket  (),
                .out_endofpacket    (),
                .out_empty          (),
                .out_error          (csr_clk_rx_stat_error),
                .out_channel        (),
                .out_ready          (1'b1),
                
                .in_csr_address     (1'b0),
                .in_csr_read        (1'b0),
                .in_csr_write       (1'b0),
                .in_csr_writedata   (32'h0),
                .in_csr_readdata    (),
                
                .out_csr_address    (1'b0),
                .out_csr_read       (1'b0),
                .out_csr_write      (1'b0),
                .out_csr_writedata  (32'h0),
                .out_csr_readdata   (),
                
                .almost_full_valid  (),
                .almost_full_data   (),
                .almost_empty_valid (),
                .almost_empty_data  (),
                
                .space_avail_data   (),
                
                .ecc_err_corrected  (rx_stat_cc_ecc_err_corrected),
                .ecc_err_detected   (),
                .ecc_err_fatal      (rx_stat_cc_ecc_err_fatal)
            );
        end
        
        if(INSTANTIATE_STATISTICS && (REGISTER_BASED_STATISTICS == 0))
        begin
        // RX Memory Statistics
        alt_em10g32_stat_mem #(
            .DEVICE_FAMILY(DEVICE_FAMILY),
            .ENABLE_MEM_ECC(ENABLE_MEM_ECC),
            .SYNC_RESET_N(SYNC_RESET_N)
        ) rx_stat_mem (
            // Clock and Reset
            .clk                (csr_clk),
            .csr_reset_n        (csr_clk_rst_n),

            // CSR Interface
            .csr_read           (rx_stat_mem_avs_read_csr_clk),
            .csr_address        (rx_stat_mem_avs_address_csr_clk),
            .csr_readdata       (rx_stat_mem_avs_readdata_csr_clk),
            .csr_write          (rx_stat_mem_avs_write_csr_clk),
            .csr_writedata      (rx_stat_mem_avs_writedata_csr_clk),

            // Frame Status
            .stat_sink_valid    (csr_clk_rx_stat_valid),
            .stat_sink_data     (csr_clk_rx_stat_data),
            .stat_sink_error    (csr_clk_rx_stat_error),
            
            // ECC Status
            .mem_stat_update_ecc_err_corrected  (rx_mem_stat_update_ecc_err_corrected),
            .mem_stat_update_ecc_err_fatal      (rx_mem_stat_update_ecc_err_fatal),
            .mem_stat_csr_ecc_err_corrected     (rx_mem_stat_csr_ecc_err_corrected),
            .mem_stat_csr_ecc_err_fatal         (rx_mem_stat_csr_ecc_err_fatal),
            
            // Parameters
            .enable_pfc         (enable_pfc)
        );
        end
        else
        begin
        assign rx_stat_mem_avs_readdata_csr_clk = 32'b0;
        assign rx_mem_stat_update_ecc_err_corrected = 1'b0;
        assign rx_mem_stat_update_ecc_err_fatal = 1'b0;
        assign rx_mem_stat_csr_ecc_err_corrected = 1'b0;
        assign rx_mem_stat_csr_ecc_err_fatal = 1'b0;
        end

        // RX Register Statistics
        alt_em10g32_stat_reg #(
            .SYNC_RESET_N(SYNC_RESET_N)
        ) rx_stat_reg(
            // Clock and Reset
            .clk                (csr_clk),
            .csr_reset_n        (csr_clk_rst_n),

            // CSR Interface
            .csr_read           (rx_stat_reg_avs_read_csr_clk),
            .csr_address        (rx_stat_reg_avs_address_csr_clk),
            .csr_readdata       (rx_stat_reg_avs_readdata_csr_clk),
            .csr_write          (rx_stat_reg_avs_write_csr_clk),
            .csr_writedata      (rx_stat_reg_avs_writedata_csr_clk),

            // Frame Status
            .stat_sink_valid    (csr_clk_rx_stat_valid),
            .stat_sink_data     (csr_clk_rx_stat_data),
            .stat_sink_error    (csr_clk_rx_stat_error),

            // Parameters
            .enable_pfc         (enable_pfc)
        );
        
        assign tx_mem_stat_update_ecc_err_corrected_tx_clk = 1'b0;
        assign tx_mem_stat_update_ecc_err_fatal_tx_clk = 1'b0;
        assign tx_mem_stat_csr_ecc_err_corrected_tx_clk = 1'b0;
        assign tx_mem_stat_csr_ecc_err_fatal_tx_clk = 1'b0;
        
        assign rx_mem_stat_update_ecc_err_corrected_rx_clk = 1'b0;
        assign rx_mem_stat_update_ecc_err_fatal_rx_clk = 1'b0;
        assign rx_mem_stat_csr_ecc_err_corrected_rx_clk = 1'b0;
        assign rx_mem_stat_csr_ecc_err_fatal_rx_clk = 1'b0;
    end
endgenerate

// ECC Status
alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_gmii_encoder_ecc_err_corrected(
    .in_clk      (gmii_tx_clk),
    .in_reset_n  (gmii_tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_gmii_encoder_ecc_err_corrected),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (gmii_tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_gmii_encoder_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_gmii_encoder_ecc_err_fatal(
    .in_clk      (gmii_tx_clk),
    .in_reset_n  (gmii_tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_gmii_encoder_ecc_err_fatal),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (gmii_tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_gmii_encoder_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_gmii_decoder_ecc_err_corrected(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_gmii_decoder_ecc_err_corrected),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_gmii_decoder_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_gmii_decoder_ecc_err_fatal(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_gmii_decoder_ecc_err_fatal),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_gmii_decoder_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_ptp_request_control_ecc_err_corrected(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_ptp_request_control_ecc_err_corrected),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_ptp_request_control_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_ptp_request_control_ecc_err_fatal(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_ptp_request_control_ecc_err_fatal),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_ptp_request_control_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_ptp_aligner_ecc_err_corrected(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_ptp_aligner_ecc_err_corrected),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_ptp_aligner_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_ptp_aligner_ecc_err_fatal(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_ptp_aligner_ecc_err_fatal),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_ptp_aligner_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_mem_stat_update_ecc_err_corrected(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_mem_stat_update_ecc_err_corrected_tx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_mem_stat_update_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_mem_stat_update_ecc_err_fatal(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_mem_stat_update_ecc_err_fatal_tx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_mem_stat_update_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_mem_stat_csr_ecc_err_corrected(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_mem_stat_csr_ecc_err_corrected_tx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_mem_stat_csr_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_mem_stat_csr_ecc_err_fatal(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_mem_stat_csr_ecc_err_fatal_tx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (tx_mem_stat_csr_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_mem_stat_update_ecc_err_corrected(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_mem_stat_update_ecc_err_corrected_rx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_mem_stat_update_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_mem_stat_update_ecc_err_fatal(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_mem_stat_update_ecc_err_fatal_rx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_mem_stat_update_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_mem_stat_csr_ecc_err_corrected(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_mem_stat_csr_ecc_err_corrected_rx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_mem_stat_csr_ecc_err_corrected_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_mem_stat_csr_ecc_err_fatal(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (rx_mem_stat_csr_ecc_err_fatal_rx_clk),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (rx_mem_stat_csr_ecc_err_fatal_csr_clk),
    .out_data    ()
);

alt_em10g32_clock_crosser #(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (4),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_cf_error_status(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (cf_overflow_valid),
    .in_data     ({ingress_overflow,egress_overflow,egress_rt_gt_4s,egress_rt_neg}),
    .out_clk     (csr_clk),
    .out_reset_n (tx_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (cf_overflow_valid_csr_clk),
    .out_data    ({ingress_overflow_csr_clk,egress_overflow_csr_clk,egress_rt_gt_4s_csr_clk,egress_rt_neg_csr_clk})
);

assign tx_mem_stat_update_ecc_err_corrected_csr_clk_selected = STATISTICS_CSR_CLOCK ? tx_mem_stat_update_ecc_err_corrected : tx_mem_stat_update_ecc_err_corrected_csr_clk;
assign tx_mem_stat_update_ecc_err_fatal_csr_clk_selected = STATISTICS_CSR_CLOCK ? tx_mem_stat_update_ecc_err_fatal : tx_mem_stat_update_ecc_err_fatal_csr_clk;
assign tx_mem_stat_csr_ecc_err_corrected_csr_clk_selected = STATISTICS_CSR_CLOCK ? tx_mem_stat_csr_ecc_err_corrected : tx_mem_stat_csr_ecc_err_corrected_csr_clk;
assign tx_mem_stat_csr_ecc_err_fatal_csr_clk_selected = STATISTICS_CSR_CLOCK ? tx_mem_stat_csr_ecc_err_fatal : tx_mem_stat_csr_ecc_err_fatal_csr_clk;

assign rx_mem_stat_update_ecc_err_corrected_csr_clk_selected = STATISTICS_CSR_CLOCK ? rx_mem_stat_update_ecc_err_corrected : rx_mem_stat_update_ecc_err_corrected_csr_clk;
assign rx_mem_stat_update_ecc_err_fatal_csr_clk_selected = STATISTICS_CSR_CLOCK ? rx_mem_stat_update_ecc_err_fatal : rx_mem_stat_update_ecc_err_fatal_csr_clk;
assign rx_mem_stat_csr_ecc_err_corrected_csr_clk_selected = STATISTICS_CSR_CLOCK ? rx_mem_stat_csr_ecc_err_corrected : rx_mem_stat_csr_ecc_err_corrected_csr_clk;
assign rx_mem_stat_csr_ecc_err_fatal_csr_clk_selected = STATISTICS_CSR_CLOCK ? rx_mem_stat_csr_ecc_err_fatal : rx_mem_stat_csr_ecc_err_fatal_csr_clk;

assign ecc_corrected_err_status_in = (enable_1g10g_mac & ((tx_gmii_encoder_ecc_err_corrected_csr_clk & enable_tx) |
                                                          (rx_gmii_decoder_ecc_err_corrected_csr_clk & enable_rx))) |
                                     (enable_timestamping & ((tx_ptp_request_control_ecc_err_corrected_csr_clk & enable_tx) |
                                                             (rx_ptp_aligner_ecc_err_corrected_csr_clk & enable_rx))) |
                                     ((instantiate_statistics & ~register_based_statistics) & (((tx_mem_stat_update_ecc_err_corrected_csr_clk_selected | tx_mem_stat_csr_ecc_err_corrected_csr_clk_selected) & enable_tx) |
                                                                                               ((rx_mem_stat_update_ecc_err_corrected_csr_clk_selected | rx_mem_stat_csr_ecc_err_corrected_csr_clk_selected) & enable_rx))) |
                                     ((instantiate_statistics & (STATISTICS_CSR_CLOCK != 0) & (STATISTICS_CSR_CLOCK_DC_FIFO != 0)) & ((tx_stat_cc_ecc_err_corrected & enable_tx) | (rx_stat_cc_ecc_err_corrected & enable_rx)));

assign ecc_fatal_err_status_in = (enable_1g10g_mac & ((tx_gmii_encoder_ecc_err_fatal_csr_clk & enable_tx) |
                                                      (rx_gmii_decoder_ecc_err_fatal_csr_clk & enable_rx))) |
                                 (enable_timestamping & ((tx_ptp_request_control_ecc_err_fatal_csr_clk & enable_tx) | 
                                                         (rx_ptp_aligner_ecc_err_fatal_csr_clk & enable_rx))) |
                                 ((instantiate_statistics & ~register_based_statistics) & (((tx_mem_stat_update_ecc_err_fatal_csr_clk_selected | tx_mem_stat_csr_ecc_err_fatal_csr_clk_selected) & enable_tx) |
                                                                                           ((rx_mem_stat_update_ecc_err_fatal_csr_clk_selected | rx_mem_stat_csr_ecc_err_fatal_csr_clk_selected) & enable_rx))) |
                                 ((instantiate_statistics & (STATISTICS_CSR_CLOCK != 0) & (STATISTICS_CSR_CLOCK_DC_FIFO != 0)) & ((tx_stat_cc_ecc_err_fatal & enable_tx) | (rx_stat_cc_ecc_err_fatal & enable_rx)));

                                 
assign wait_request_timeout_in = (waitrequest_timeout == 5'b11111) ? 1'b1: 1'b0;    

assign cf_overflow_ingress_status_in = ingress_overflow_csr_clk & cf_overflow_valid_csr_clk;
assign cf_overflow_egress_status_in = egress_overflow_csr_clk & cf_overflow_valid_csr_clk;
assign cf_rt_gt_eq_4s_status_in = egress_rt_gt_4s_csr_clk & cf_overflow_valid_csr_clk;
assign cf_rt_neg_status_in = egress_rt_neg_csr_clk & cf_overflow_valid_csr_clk; 
                           
// Clock Crossing and Connection
// Constant signal for const_revision_id
assign revision_id = const_revision_id;

// Constant signal for const_mac_capability
assign mac_capability = const_mac_capability;

// Pseudo-static signal for csr_tx_mac_sa
assign csr_tx_mac_sa = {pri_macaddr_bit47to32, pri_macaddr_bit31to0};

// Pseudo-static signal for csr_rx_primaddr
assign csr_rx_primaddr = {pri_macaddr_bit47to32, pri_macaddr_bit31to0};

// Single-bit clock crossing for status_wait_request_timeout
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_csr_clk_status_wait_request_timeout (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(wait_request_timeout),
    .dout(status_wait_request_timeout)
);

// Single-bit clock crossing for csr_tx_data_path_reset
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_csr_clk_csr_tx_data_path_reset (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(tx_data_path_reset),
    .dout(csr_tx_data_path_reset)
);

// Single-bit clock crossing for csr_rx_data_path_reset
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_csr_clk_csr_rx_data_path_reset (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(rx_data_path_reset),
    .dout(csr_rx_data_path_reset)
);

// Single-bit clock crossing for csr_tx_tsfr_en_n
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH),.rst_value(1)) sync_tx_clk_csr_tx_tsfr_en_n (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(tx_tsfr_en_n),
    .dout(csr_tx_tsfr_en_n)
);

// Single-bit clock crossing for status_tx_datafrm_tsfr_en_sts
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_status_tx_datafrm_tsfr_en_sts (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_tx_datafrm_tsfr_en_sts),
    .dout(tx_datafrm_tsfr_en_sts)
);

// Single-bit clock crossing for status_tx_busy
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_status_tx_busy (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_tx_busy),
    .dout(tx_busy)
);

// Single-bit clock crossing for status_tx_rst_sts
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_csr_clk_status_tx_rst_sts (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_tx_rst_sts),
    .dout(tx_rst_sts)
);

// Pseudo-static signal for csr_tx_pad_insrt_en
assign csr_tx_pad_insrt_en = tx_pad_insrt_en;

// Constant signal for const_tx_crcctl_reserved
assign tx_crcctl_reserved = const_tx_crcctl_reserved;

// Pseudo-static signal for csr_tx_crc_insrt_en
assign csr_tx_crc_insrt_en = tx_crc_insrt_en;

// Pseudo-static signal for csr_tx_preamble_passthru
assign csr_tx_preamble_passthru = tx_preamb_passthru_en;

// Pseudo-static signal for csr_tx_mac_sa_ovrd_en
assign csr_tx_mac_sa_ovrd_en = tx_sa_override_en;

// Pseudo-static signal for csr_tx_max_frmlen
assign csr_tx_max_frmlen = tx_max_datafrmlen;

// Pseudo-static signal for csr_txvlandet_dis
assign csr_txvlandet_dis = txvlandet_dis;

// Pseudo-static signal for tx_pipg_10g_dic
assign tx_pipg_10g_dic = tx_pipg10g_dic;

// Pseudo-static signal for tx_pipg_1g_fixed
assign tx_pipg_1g_fixed = tx_pipg1g_fixed;

// Statistics counter with input pulse for pulse_tx_udf_errcnt
wire pulse_tx_udf_errcnt_tx_clk_valid;
reg [35:0] pulse_tx_udf_errcnt_counter;
reg [ 3:0] pulse_tx_udf_errcnt_counter_shadow;
alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_pulse_tx_udf_errcnt(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_clk_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (pulse_tx_udf_errcnt),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (pulse_tx_udf_errcnt_tx_clk_valid),
    .out_data    ()
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_tx_udf_errcnt_counter <= 36'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h03E)) begin
              pulse_tx_udf_errcnt_counter <= 36'h0;
          end
          else if(pulse_tx_udf_errcnt_tx_clk_valid) begin
              pulse_tx_udf_errcnt_counter <= pulse_tx_udf_errcnt_counter + 36'h1;
          end
      end
  end
  
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_tx_udf_errcnt_counter_shadow <= 4'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h03E)) begin
              pulse_tx_udf_errcnt_counter_shadow <= pulse_tx_udf_errcnt_counter[35:32];
          end
      end
  end
end else begin
  always @(posedge csr_clk or negedge csr_clk_rst_n) begin
      if(!csr_clk_rst_n) begin
          pulse_tx_udf_errcnt_counter <= 36'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h03E)) begin
              pulse_tx_udf_errcnt_counter <= 36'h0;
          end
          else if(pulse_tx_udf_errcnt_tx_clk_valid) begin
              pulse_tx_udf_errcnt_counter <= pulse_tx_udf_errcnt_counter + 36'h1;
          end
      end
  end
  
  always @(posedge csr_clk or negedge csr_clk_rst_n) begin
      if(!csr_clk_rst_n) begin
          pulse_tx_udf_errcnt_counter_shadow <= 4'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h03E)) begin
              pulse_tx_udf_errcnt_counter_shadow <= pulse_tx_udf_errcnt_counter[35:32];
          end
      end
  end
end
endgenerate

assign {tx_udf_errcnt_bit35to32, tx_udf_errcnt_bit31to0} = {pulse_tx_udf_errcnt_counter_shadow[3:0], pulse_tx_udf_errcnt_counter[31:0]};

// Clock crossing with valid signal for csr_tx_pause_xonxoff_ctrl
wire csr_tx_pause_xonxoff_ctrl_tx_clk_valid;
wire [1:0] csr_tx_pause_xonxoff_ctrl_tx_clk_data;
reg  [1:0] csr_tx_pause_xonxoff_ctrl_tx_clk_reg;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (2),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_pause_xonxoff_ctrl(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (tx_pausefrm_xonxoff_valid_internal),
    .in_data     (tx_pausefrm_xonxoff),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_pause_xonxoff_ctrl_valid),
    .out_data    (csr_tx_pause_xonxoff_ctrl)
);

// External clear based on negative edge for csr_tx_pause_xonxoff_ctrl_clr
reg  csr_tx_pause_xonxoff_ctrl_clr_tx_clk_reg;
wire csr_tx_pause_xonxoff_ctrl_clr_tx_clk_pulse;

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_pause_xonxoff_ctrl_clr_tx_clk_reg <= 1'b0;
      end
      else begin
          csr_tx_pause_xonxoff_ctrl_clr_tx_clk_reg <= csr_tx_pause_xonxoff_ctrl_clr;
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_pause_xonxoff_ctrl_clr_tx_clk_reg <= 1'b0;
      end
      else begin
          csr_tx_pause_xonxoff_ctrl_clr_tx_clk_reg <= csr_tx_pause_xonxoff_ctrl_clr;
      end
  end
end
endgenerate

assign csr_tx_pause_xonxoff_ctrl_clr_tx_clk_pulse = csr_tx_pause_xonxoff_ctrl_clr_tx_clk_reg & ~csr_tx_pause_xonxoff_ctrl_clr;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_pause_xonxoff_ctrl_clr(
    .in_clk      (tx_clk),
    .in_reset_n  (tx_clk_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (csr_tx_pause_xonxoff_ctrl_clr_tx_clk_pulse),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (tx_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_pause_xonxoff_ctrl_clr_internal),
    .out_data    ()
);

// Pseudo-static signal for csr_tx_pause_pqt
assign csr_tx_pause_pqt = tx_pausefrm_pqt;

// Pseudo-static signal for csr_tx_pause_hqt
assign csr_tx_pause_hqt = tx_pausefrm_xoff_hqt;

// Pseudo-static signal for csr_tx_pause_en
assign csr_tx_pause_en = tx_pausefrm_en;

// Pseudo-static signal for csr_tx_pausefrm_policy
assign csr_tx_pausefrm_policy = tx_pausefrm_policy;

// Pseudo-static signal for csr_tx_pfc0_en
assign csr_tx_pfc0_en = tx_pfcfrm_en0;

// Pseudo-static signal for csr_tx_pfc1_en
assign csr_tx_pfc1_en = tx_pfcfrm_en1;

// Pseudo-static signal for csr_tx_pfc2_en
assign csr_tx_pfc2_en = tx_pfcfrm_en2;

// Pseudo-static signal for csr_tx_pfc3_en
assign csr_tx_pfc3_en = tx_pfcfrm_en3;

// Pseudo-static signal for csr_tx_pfc4_en
assign csr_tx_pfc4_en = tx_pfcfrm_en4;

// Pseudo-static signal for csr_tx_pfc5_en
assign csr_tx_pfc5_en = tx_pfcfrm_en5;

// Pseudo-static signal for csr_tx_pfc6_en
assign csr_tx_pfc6_en = tx_pfcfrm_en6;

// Pseudo-static signal for csr_tx_pfc7_en
assign csr_tx_pfc7_en = tx_pfcfrm_en7;

// Pseudo-static signal for csr_tx_pfc0_pqt
assign csr_tx_pfc0_pqt = tx_pfcfrm_pqt0;

// Pseudo-static signal for csr_tx_pfc1_pqt
assign csr_tx_pfc1_pqt = tx_pfcfrm_pqt1;

// Pseudo-static signal for csr_tx_pfc2_pqt
assign csr_tx_pfc2_pqt = tx_pfcfrm_pqt2;

// Pseudo-static signal for csr_tx_pfc3_pqt
assign csr_tx_pfc3_pqt = tx_pfcfrm_pqt3;

// Pseudo-static signal for csr_tx_pfc4_pqt
assign csr_tx_pfc4_pqt = tx_pfcfrm_pqt4;

// Pseudo-static signal for csr_tx_pfc5_pqt
assign csr_tx_pfc5_pqt = tx_pfcfrm_pqt5;

// Pseudo-static signal for csr_tx_pfc6_pqt
assign csr_tx_pfc6_pqt = tx_pfcfrm_pqt6;

// Pseudo-static signal for csr_tx_pfc7_pqt
assign csr_tx_pfc7_pqt = tx_pfcfrm_pqt7;

// Pseudo-static signal for csr_tx_pfc0_xoff_hqt
assign csr_tx_pfc0_xoff_hqt = tx_xoff_hqt0;

// Pseudo-static signal for csr_tx_pfc1_xoff_hqt
assign csr_tx_pfc1_xoff_hqt = tx_xoff_hqt1;

// Pseudo-static signal for csr_tx_pfc2_xoff_hqt
assign csr_tx_pfc2_xoff_hqt = tx_xoff_hqt2;

// Pseudo-static signal for csr_tx_pfc3_xoff_hqt
assign csr_tx_pfc3_xoff_hqt = tx_xoff_hqt3;

// Pseudo-static signal for csr_tx_pfc4_xoff_hqt
assign csr_tx_pfc4_xoff_hqt = tx_xoff_hqt4;

// Pseudo-static signal for csr_tx_pfc5_xoff_hqt
assign csr_tx_pfc5_xoff_hqt = tx_xoff_hqt5;

// Pseudo-static signal for csr_tx_pfc6_xoff_hqt
assign csr_tx_pfc6_xoff_hqt = tx_xoff_hqt6;

// Pseudo-static signal for csr_tx_pfc7_xoff_hqt
assign csr_tx_pfc7_xoff_hqt = tx_xoff_hqt7;

// Pseudo-static signal for csr_tx_unidirectional_en
assign csr_tx_unidirectional_en = tx_unidirectional_en;

// Pseudo-static signal for csr_tx_unidirectional_remote_fault_dis
assign csr_tx_unidirectional_remote_fault_dis = tx_unidirectional_remote_fault_dis;

// Pseudo-static signal for csr_tx_unidirectional_force_remote_fault
assign csr_tx_unidirectional_force_remote_fault = tx_unidirectional_force_remote_fault;

// Single-bit clock crossing for csr_rx_tsfr_en_n
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_csr_rx_tsfr_en_n (
    .clk(rx_clk),
    .reset_n(rx_clk_rst_n),
    .din(rx_tsfr_en_n),
    .dout(csr_rx_tsfr_en_n)
);

// Single-bit clock crossing for status_rx_tsfr_sts
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_status_rx_tsfr_sts (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_rx_tsfr_sts),
    .dout(rx_tsfr_sts)
);

// Single-bit clock crossing for status_rx_busy
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_csr_clk_status_rx_busy (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_rx_busy),
    .dout(rx_busy)
);

// Single-bit clock crossing for status_rx_rst_sts
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_csr_clk_status_rx_rst_sts (
    .clk(csr_clk),
    .reset_n(csr_clk_rst_n),
    .din(status_rx_rst_sts),
    .dout(rx_rst_sts)
);

// Pseudo-static signal for csr_rx_crcpad_rem
assign csr_rx_crcpad_rem = rx_crcpad_rem;

// Constant signal for status_rx_crc_reserved
assign rx_crc_reserved = status_rx_crc_reserved;

// Single-bit clock crossing for csr_rx_crc_chk
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_csr_rx_crc_chk (
    .clk(rx_clk),
    .reset_n(rx_clk_rst_n),
    .din(rx_crc_chk),
    .dout(csr_rx_crc_chk)
);

// Single-bit clock crossing for csr_rx_preamb_fwd_ctl
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_csr_rx_preamb_fwd_ctl (
    .clk(rx_clk),
    .reset_n(rx_clk_rst_n),
    .din(rx_preambctl_fwd),
    .dout(csr_rx_preamb_fwd_ctl)
);

// Pseudo-static signal for csr_rx_preamb_passthru_en
assign csr_rx_preamb_passthru_en = rx_preamb_passthru_en;

// Pseudo-static signal for csr_rx_allucast_en
assign csr_rx_allucast_en = rx_allucast_en;

// Pseudo-static signal for csr_rx_allmcast_en
assign csr_rx_allmcast_en = rx_allmcast_en;

// Pseudo-static signal for csr_rx_fwd_ctlfrm
assign csr_rx_fwd_ctlfrm = rx_fwd_ctlfrm;

// Pseudo-static signal for csr_rx_fwd_pausefrm
assign csr_rx_fwd_pausefrm = rx_fwd_pausefrm;

// Pseudo-static signal for csr_rx_ignore_pausefrm
assign csr_rx_ignore_pausefrm = rx_ignore_pausefrm;

// Pseudo-static signal for csr_rx_suppaddr_en0
assign csr_rx_suppaddr_en0 = rx_suppaddr_en0;

// Pseudo-static signal for csr_rx_suppaddr_en1
assign csr_rx_suppaddr_en1 = rx_suppaddr_en1;

// Pseudo-static signal for csr_rx_suppaddr_en2
assign csr_rx_suppaddr_en2 = rx_suppaddr_en2;

// Pseudo-static signal for csr_rx_suppaddr_en3
assign csr_rx_suppaddr_en3 = rx_suppaddr_en3;

// Pseudo-static signal for csr_rx_max_datafrmlen
assign csr_rx_max_datafrmlen = rx_max_datafrmlen;

// Pseudo-static signal for csr_rxvlandet_dis
assign csr_rxvlandet_dis = rxvlandet_dis;

// Pseudo-static signal for csr_rx_supp_macaddr_0
assign csr_rx_supp_macaddr_0 = {rx_supp_macaddr_bit47to32_0, rx_supp_macaddr_bit31to0_0};

// Pseudo-static signal for csr_rx_supp_macaddr_1
assign csr_rx_supp_macaddr_1 = {rx_supp_macaddr_bit47to32_1, rx_supp_macaddr_bit31to0_1};

// Pseudo-static signal for csr_rx_supp_macaddr_2
assign csr_rx_supp_macaddr_2 = {rx_supp_macaddr_bit47to32_2, rx_supp_macaddr_bit31to0_2};

// Pseudo-static signal for csr_rx_supp_macaddr_3
assign csr_rx_supp_macaddr_3 = {rx_supp_macaddr_bit47to32_3, rx_supp_macaddr_bit31to0_3};

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_0
assign csr_rx_pfc_ignore_pausefrm_0 = rx_pfc_ignore_pausefrm_0;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_1
assign csr_rx_pfc_ignore_pausefrm_1 = rx_pfc_ignore_pausefrm_1;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_2
assign csr_rx_pfc_ignore_pausefrm_2 = rx_pfc_ignore_pausefrm_2;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_3
assign csr_rx_pfc_ignore_pausefrm_3 = rx_pfc_ignore_pausefrm_3;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_4
assign csr_rx_pfc_ignore_pausefrm_4 = rx_pfc_ignore_pausefrm_4;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_5
assign csr_rx_pfc_ignore_pausefrm_5 = rx_pfc_ignore_pausefrm_5;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_6
assign csr_rx_pfc_ignore_pausefrm_6 = rx_pfc_ignore_pausefrm_6;

// Pseudo-static signal for csr_rx_pfc_ignore_pausefrm_7
assign csr_rx_pfc_ignore_pausefrm_7 = rx_pfc_ignore_pausefrm_7;

// Pseudo-static signal for csr_rx_pfc_fwd
assign csr_rx_pfc_fwd = rx_pfc_fwd;

// Statistics counter with input pulse for pulse_rx_pkt_ovrflw_errcnt
wire pulse_rx_pkt_ovrflw_errcnt_rx_clk_valid;
reg [35:0] pulse_rx_pkt_ovrflw_errcnt_counter;
reg [ 3:0] pulse_rx_pkt_ovrflw_errcnt_counter_shadow;
alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_pulse_rx_pkt_ovrflw_errcnt(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_clk_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (pulse_rx_pkt_ovrflw_errcnt),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (pulse_rx_pkt_ovrflw_errcnt_rx_clk_valid),
    .out_data    ()
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_errcnt_counter <= 36'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FC)) begin
              pulse_rx_pkt_ovrflw_errcnt_counter <= 36'h0;
          end
          else if(pulse_rx_pkt_ovrflw_errcnt_rx_clk_valid) begin
              pulse_rx_pkt_ovrflw_errcnt_counter <= pulse_rx_pkt_ovrflw_errcnt_counter + 36'h1;
          end
      end
  end
  
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_errcnt_counter_shadow <= 4'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FC)) begin
              pulse_rx_pkt_ovrflw_errcnt_counter_shadow <= pulse_rx_pkt_ovrflw_errcnt_counter[35:32];
          end
      end
  end
end else begin
  always @(posedge csr_clk or negedge csr_clk_rst_n) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_errcnt_counter <= 36'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FC)) begin
              pulse_rx_pkt_ovrflw_errcnt_counter <= 36'h0;
          end
          else if(pulse_rx_pkt_ovrflw_errcnt_rx_clk_valid) begin
              pulse_rx_pkt_ovrflw_errcnt_counter <= pulse_rx_pkt_ovrflw_errcnt_counter + 36'h1;
          end
      end
  end
  
  always @(posedge csr_clk or negedge csr_clk_rst_n) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_errcnt_counter_shadow <= 4'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FC)) begin
              pulse_rx_pkt_ovrflw_errcnt_counter_shadow <= pulse_rx_pkt_ovrflw_errcnt_counter[35:32];
          end
      end
  end
end
endgenerate

assign {rx_pkt_ovrflw_errcnt_bit35to32, rx_pkt_ovrflw_errcnt_bit31to0} = {pulse_rx_pkt_ovrflw_errcnt_counter_shadow[3:0], pulse_rx_pkt_ovrflw_errcnt_counter[31:0]};

// Statistics counter with input pulse for pulse_rx_pkt_ovrflw_etherstatsdropevents
wire pulse_rx_pkt_ovrflw_etherstatsdropevents_rx_clk_valid;
reg [35:0] pulse_rx_pkt_ovrflw_etherstatsdropevents_counter;
reg [ 3:0] pulse_rx_pkt_ovrflw_etherstatsdropevents_counter_shadow;
alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (1),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_pulse_rx_pkt_ovrflw_etherstatsdropevents(
    .in_clk      (rx_clk),
    .in_reset_n  (rx_clk_csr_cc_in_rst_n),
    .in_ready    (),
    .in_valid    (pulse_rx_pkt_ovrflw_etherstatsdropevents),
    .in_data     (1'b0),
    .out_clk     (csr_clk),
    .out_reset_n (rx_clk_csr_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (pulse_rx_pkt_ovrflw_etherstatsdropevents_rx_clk_valid),
    .out_data    ()
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_etherstatsdropevents_counter <= 36'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FE)) begin
              pulse_rx_pkt_ovrflw_etherstatsdropevents_counter <= 36'h0;
          end
          else if(pulse_rx_pkt_ovrflw_etherstatsdropevents_rx_clk_valid) begin
              pulse_rx_pkt_ovrflw_etherstatsdropevents_counter <= pulse_rx_pkt_ovrflw_etherstatsdropevents_counter + 36'h1;
          end
      end
  end
  
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_etherstatsdropevents_counter_shadow <= 4'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FE)) begin
              pulse_rx_pkt_ovrflw_etherstatsdropevents_counter_shadow <= pulse_rx_pkt_ovrflw_etherstatsdropevents_counter[35:32];
          end
      end
  end
end else begin
  always @(posedge csr_clk) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_etherstatsdropevents_counter <= 36'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FE)) begin
              pulse_rx_pkt_ovrflw_etherstatsdropevents_counter <= 36'h0;
          end
          else if(pulse_rx_pkt_ovrflw_etherstatsdropevents_rx_clk_valid) begin
              pulse_rx_pkt_ovrflw_etherstatsdropevents_counter <= pulse_rx_pkt_ovrflw_etherstatsdropevents_counter + 36'h1;
          end
      end
  end
  
  always @(posedge csr_clk or negedge csr_clk_rst_n) begin
      if(!csr_clk_rst_n) begin
          pulse_rx_pkt_ovrflw_etherstatsdropevents_counter_shadow <= 4'h0;
      end
      else begin
          if(avs_read && (avs_address == 10'h0FE)) begin
              pulse_rx_pkt_ovrflw_etherstatsdropevents_counter_shadow <= pulse_rx_pkt_ovrflw_etherstatsdropevents_counter[35:32];
          end
      end
  end
end
endgenerate

assign {rx_pkt_ovrflw_etherstatsdropevents_bit35to32, rx_pkt_ovrflw_etherstatsdropevents_bit31to0} = {pulse_rx_pkt_ovrflw_etherstatsdropevents_counter_shadow[3:0], pulse_rx_pkt_ovrflw_etherstatsdropevents_counter[31:0]};

// Multi-bits clock crossing for csr_tx_period_10g
wire csr_tx_period_10g_csr_clk_ready;
wire csr_tx_period_10g_csr_clk_valid;
wire csr_tx_period_10g_tx_clk_valid;
wire [19:0] csr_tx_period_10g_tx_clk_data;
reg  [19:0] csr_tx_period_10g_tx_clk_reg;

assign csr_tx_period_10g_csr_clk_valid = csr_tx_period_10g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_period_10g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_period_10g_csr_clk_ready),
    .in_valid    (csr_tx_period_10g_csr_clk_valid),
    .in_data     (tx_period_10g),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_period_10g_tx_clk_valid),
    .out_data    (csr_tx_period_10g_tx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_period_10g_tx_clk_reg <= 20'h33333;
      end
      else begin
          if(csr_tx_period_10g_tx_clk_valid) begin
              csr_tx_period_10g_tx_clk_reg <= csr_tx_period_10g_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_period_10g_tx_clk_reg <= 20'h33333;
      end
      else begin
          if(csr_tx_period_10g_tx_clk_valid) begin
              csr_tx_period_10g_tx_clk_reg <= csr_tx_period_10g_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_period_10g = csr_tx_period_10g_tx_clk_reg;

// Multi-bits clock crossing for csr_tx_adj_fracns_10g
wire csr_tx_adj_fracns_10g_csr_clk_ready;
wire csr_tx_adj_fracns_10g_csr_clk_valid;
wire csr_tx_adj_fracns_10g_tx_clk_valid;
wire [15:0] csr_tx_adj_fracns_10g_tx_clk_data;
reg  [15:0] csr_tx_adj_fracns_10g_tx_clk_reg;

assign csr_tx_adj_fracns_10g_csr_clk_valid = csr_tx_adj_fracns_10g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_adj_fracns_10g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_adj_fracns_10g_csr_clk_ready),
    .in_valid    (csr_tx_adj_fracns_10g_csr_clk_valid),
    .in_data     (tx_adj_fracns_10g),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_adj_fracns_10g_tx_clk_valid),
    .out_data    (csr_tx_adj_fracns_10g_tx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_fracns_10g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_fracns_10g_tx_clk_valid) begin
              csr_tx_adj_fracns_10g_tx_clk_reg <= csr_tx_adj_fracns_10g_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_fracns_10g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_fracns_10g_tx_clk_valid) begin
              csr_tx_adj_fracns_10g_tx_clk_reg <= csr_tx_adj_fracns_10g_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_adj_fracns_10g = csr_tx_adj_fracns_10g_tx_clk_reg;

// Multi-bits clock crossing for csr_tx_adj_ns_10g
wire csr_tx_adj_ns_10g_csr_clk_ready;
wire csr_tx_adj_ns_10g_csr_clk_valid;
wire csr_tx_adj_ns_10g_tx_clk_valid;
wire [15:0] csr_tx_adj_ns_10g_tx_clk_data;
reg  [15:0] csr_tx_adj_ns_10g_tx_clk_reg;

assign csr_tx_adj_ns_10g_csr_clk_valid = csr_tx_adj_ns_10g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_adj_ns_10g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_adj_ns_10g_csr_clk_ready),
    .in_valid    (csr_tx_adj_ns_10g_csr_clk_valid),
    .in_data     (tx_adj_ns_10g),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_adj_ns_10g_tx_clk_valid),
    .out_data    (csr_tx_adj_ns_10g_tx_clk_data)
);
  
generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_ns_10g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_ns_10g_tx_clk_valid) begin
              csr_tx_adj_ns_10g_tx_clk_reg <= csr_tx_adj_ns_10g_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_ns_10g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_ns_10g_tx_clk_valid) begin
              csr_tx_adj_ns_10g_tx_clk_reg <= csr_tx_adj_ns_10g_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_adj_ns_10g = csr_tx_adj_ns_10g_tx_clk_reg;

// Multi-bits clock crossing for csr_tx_period_1g
wire csr_tx_period_1g_csr_clk_ready;
wire csr_tx_period_1g_csr_clk_valid;
wire csr_tx_period_1g_tx_clk_valid;
wire [19:0] csr_tx_period_1g_tx_clk_data;
reg  [19:0] csr_tx_period_1g_tx_clk_reg;

assign csr_tx_period_1g_csr_clk_valid = csr_tx_period_1g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_period_1g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_period_1g_csr_clk_ready),
    .in_valid    (csr_tx_period_1g_csr_clk_valid),
    .in_data     (tx_period_1g),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_period_1g_tx_clk_valid),
    .out_data    (csr_tx_period_1g_tx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_period_1g_tx_clk_reg <= 20'h80000;
      end
      else begin
          if(csr_tx_period_1g_tx_clk_valid) begin
              csr_tx_period_1g_tx_clk_reg <= csr_tx_period_1g_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_period_1g_tx_clk_reg <= 20'h80000;
      end
      else begin
          if(csr_tx_period_1g_tx_clk_valid) begin
              csr_tx_period_1g_tx_clk_reg <= csr_tx_period_1g_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_period_1g = csr_tx_period_1g_tx_clk_reg;

// Multi-bits clock crossing for csr_tx_adj_fracns_1g
wire csr_tx_adj_fracns_1g_csr_clk_ready;
wire csr_tx_adj_fracns_1g_csr_clk_valid;
wire csr_tx_adj_fracns_1g_tx_clk_valid;
wire [15:0] csr_tx_adj_fracns_1g_tx_clk_data;
reg  [15:0] csr_tx_adj_fracns_1g_tx_clk_reg;

assign csr_tx_adj_fracns_1g_csr_clk_valid = csr_tx_adj_fracns_1g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_adj_fracns_1g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_adj_fracns_1g_csr_clk_ready),
    .in_valid    (csr_tx_adj_fracns_1g_csr_clk_valid),
    .in_data     (tx_adj_fracns_1g),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_adj_fracns_1g_tx_clk_valid),
    .out_data    (csr_tx_adj_fracns_1g_tx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_fracns_1g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_fracns_1g_tx_clk_valid) begin
              csr_tx_adj_fracns_1g_tx_clk_reg <= csr_tx_adj_fracns_1g_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_fracns_1g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_fracns_1g_tx_clk_valid) begin
              csr_tx_adj_fracns_1g_tx_clk_reg <= csr_tx_adj_fracns_1g_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_adj_fracns_1g = csr_tx_adj_fracns_1g_tx_clk_reg;

// Multi-bits clock crossing for csr_tx_adj_ns_1g
wire csr_tx_adj_ns_1g_csr_clk_ready;
wire csr_tx_adj_ns_1g_csr_clk_valid;
wire csr_tx_adj_ns_1g_tx_clk_valid;
wire [15:0] csr_tx_adj_ns_1g_tx_clk_data;
reg  [15:0] csr_tx_adj_ns_1g_tx_clk_reg;

assign csr_tx_adj_ns_1g_csr_clk_valid = csr_tx_adj_ns_1g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_adj_ns_1g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_adj_ns_1g_csr_clk_ready),
    .in_valid    (csr_tx_adj_ns_1g_csr_clk_valid),
    .in_data     (tx_adj_ns_1g),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_adj_ns_1g_tx_clk_valid),
    .out_data    (csr_tx_adj_ns_1g_tx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_ns_1g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_ns_1g_tx_clk_valid) begin
              csr_tx_adj_ns_1g_tx_clk_reg <= csr_tx_adj_ns_1g_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_adj_ns_1g_tx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_tx_adj_ns_1g_tx_clk_valid) begin
              csr_tx_adj_ns_1g_tx_clk_reg <= csr_tx_adj_ns_1g_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_adj_ns_1g = csr_tx_adj_ns_1g_tx_clk_reg;

// Multi-bits clock crossing for csr_tx_asymmetry
wire csr_tx_asymmetry_csr_clk_ready;
wire csr_tx_asymmetry_csr_clk_valid;
wire csr_tx_asymmetry_tx_clk_valid;
wire [18:0] csr_tx_asymmetry_tx_clk_data;
reg  [18:0] csr_tx_asymmetry_tx_clk_reg;

assign csr_tx_asymmetry_csr_clk_valid = csr_tx_asymmetry_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (19),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_tx_clk_csr_tx_asymmetry(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_tx_clk_cc_in_rst_n),
    .in_ready    (csr_tx_asymmetry_csr_clk_ready),
    .in_valid    (csr_tx_asymmetry_csr_clk_valid),
    .in_data     (tx_asymmetry),
    .out_clk     (tx_clk),
    .out_reset_n (csr_tx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_tx_asymmetry_tx_clk_valid),
    .out_data    (csr_tx_asymmetry_tx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge tx_clk) begin
      if(!tx_clk_rst_n) begin
          csr_tx_asymmetry_tx_clk_reg <= 19'h0000;
      end
      else begin
          if(csr_tx_asymmetry_tx_clk_valid) begin
              csr_tx_asymmetry_tx_clk_reg <= csr_tx_asymmetry_tx_clk_data;
          end
      end
  end
end else begin
  always @(posedge tx_clk or negedge tx_clk_rst_n) begin
      if(!tx_clk_rst_n) begin
          csr_tx_asymmetry_tx_clk_reg <= 19'h0000;
      end
      else begin
          if(csr_tx_asymmetry_tx_clk_valid) begin
              csr_tx_asymmetry_tx_clk_reg <= csr_tx_asymmetry_tx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_tx_asymmetry = csr_tx_asymmetry_tx_clk_reg;

// Single-bit clock crossing for csr_tx_p2p_dir_egress
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_csr_tx_p2p_dir_egress (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(tx_p2p_dir_egress),
    .dout(csr_tx_p2p_dir_egress)
);

// Single-bit clock crossing for cf_overflow_ingress_status
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_cf_overflow_ingress_status (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(cf_overflow_ingress),
    .dout(cf_overflow_ingress_status)
);

// Single-bit clock crossing for cf_overflow_egress_status
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_cf_overflow_egress_status (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(cf_overflow_egress),
    .dout(cf_overflow_egress_status)
);

// Single-bit clock crossing for cf_rt_gt_eq_4s_status
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_cf_rt_gt_eq_4s_status (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(cf_rt_gt_eq_4s),
    .dout(cf_rt_gt_eq_4s_status)
);

// Single-bit clock crossing for cf_rt_neg_status
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_tx_clk_cf_rt_neg_status (
    .clk(tx_clk),
    .reset_n(tx_clk_rst_n),
    .din(cf_rt_neg),
    .dout(cf_rt_neg_status)
);

// Multi-bits clock crossing for csr_rx_period_10g
wire csr_rx_period_10g_csr_clk_ready;
wire csr_rx_period_10g_csr_clk_valid;
wire csr_rx_period_10g_rx_clk_valid;
wire [19:0] csr_rx_period_10g_rx_clk_data;
reg  [19:0] csr_rx_period_10g_rx_clk_reg;

assign csr_rx_period_10g_csr_clk_valid = csr_rx_period_10g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_period_10g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_period_10g_csr_clk_ready),
    .in_valid    (csr_rx_period_10g_csr_clk_valid),
    .in_data     (rx_period_10g),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_period_10g_rx_clk_valid),
    .out_data    (csr_rx_period_10g_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_period_10g_rx_clk_reg <= 20'h33333;
      end
      else begin
          if(csr_rx_period_10g_rx_clk_valid) begin
              csr_rx_period_10g_rx_clk_reg <= csr_rx_period_10g_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_period_10g_rx_clk_reg <= 20'h33333;
      end
      else begin
          if(csr_rx_period_10g_rx_clk_valid) begin
              csr_rx_period_10g_rx_clk_reg <= csr_rx_period_10g_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_period_10g = csr_rx_period_10g_rx_clk_reg;

// Multi-bits clock crossing for csr_rx_adj_fracns_10g
wire csr_rx_adj_fracns_10g_csr_clk_ready;
wire csr_rx_adj_fracns_10g_csr_clk_valid;
wire csr_rx_adj_fracns_10g_rx_clk_valid;
wire [15:0] csr_rx_adj_fracns_10g_rx_clk_data;
reg  [15:0] csr_rx_adj_fracns_10g_rx_clk_reg;

assign csr_rx_adj_fracns_10g_csr_clk_valid = csr_rx_adj_fracns_10g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_adj_fracns_10g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_adj_fracns_10g_csr_clk_ready),
    .in_valid    (csr_rx_adj_fracns_10g_csr_clk_valid),
    .in_data     (rx_adj_fracns_10g),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_adj_fracns_10g_rx_clk_valid),
    .out_data    (csr_rx_adj_fracns_10g_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_fracns_10g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_fracns_10g_rx_clk_valid) begin
              csr_rx_adj_fracns_10g_rx_clk_reg <= csr_rx_adj_fracns_10g_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_fracns_10g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_fracns_10g_rx_clk_valid) begin
              csr_rx_adj_fracns_10g_rx_clk_reg <= csr_rx_adj_fracns_10g_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_adj_fracns_10g = csr_rx_adj_fracns_10g_rx_clk_reg;

// Multi-bits clock crossing for csr_rx_adj_ns_10g
wire csr_rx_adj_ns_10g_csr_clk_ready;
wire csr_rx_adj_ns_10g_csr_clk_valid;
wire csr_rx_adj_ns_10g_rx_clk_valid;
wire [15:0] csr_rx_adj_ns_10g_rx_clk_data;
reg  [15:0] csr_rx_adj_ns_10g_rx_clk_reg;

assign csr_rx_adj_ns_10g_csr_clk_valid = csr_rx_adj_ns_10g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_adj_ns_10g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_adj_ns_10g_csr_clk_ready),
    .in_valid    (csr_rx_adj_ns_10g_csr_clk_valid),
    .in_data     (rx_adj_ns_10g),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_adj_ns_10g_rx_clk_valid),
    .out_data    (csr_rx_adj_ns_10g_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_ns_10g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_ns_10g_rx_clk_valid) begin
              csr_rx_adj_ns_10g_rx_clk_reg <= csr_rx_adj_ns_10g_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_ns_10g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_ns_10g_rx_clk_valid) begin
              csr_rx_adj_ns_10g_rx_clk_reg <= csr_rx_adj_ns_10g_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_adj_ns_10g = csr_rx_adj_ns_10g_rx_clk_reg;

// Multi-bits clock crossing for csr_rx_period_1g
wire csr_rx_period_1g_csr_clk_ready;
wire csr_rx_period_1g_csr_clk_valid;
wire csr_rx_period_1g_rx_clk_valid;
wire [19:0] csr_rx_period_1g_rx_clk_data;
reg  [19:0] csr_rx_period_1g_rx_clk_reg;

assign csr_rx_period_1g_csr_clk_valid = csr_rx_period_1g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (20),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_period_1g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_period_1g_csr_clk_ready),
    .in_valid    (csr_rx_period_1g_csr_clk_valid),
    .in_data     (rx_period_1g),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_period_1g_rx_clk_valid),
    .out_data    (csr_rx_period_1g_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_period_1g_rx_clk_reg <= 20'h80000;
      end
      else begin
          if(csr_rx_period_1g_rx_clk_valid) begin
              csr_rx_period_1g_rx_clk_reg <= csr_rx_period_1g_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_period_1g_rx_clk_reg <= 20'h80000;
      end
      else begin
          if(csr_rx_period_1g_rx_clk_valid) begin
              csr_rx_period_1g_rx_clk_reg <= csr_rx_period_1g_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_period_1g = csr_rx_period_1g_rx_clk_reg;

// Multi-bits clock crossing for csr_rx_adj_fracns_1g
wire csr_rx_adj_fracns_1g_csr_clk_ready;
wire csr_rx_adj_fracns_1g_csr_clk_valid;
wire csr_rx_adj_fracns_1g_rx_clk_valid;
wire [15:0] csr_rx_adj_fracns_1g_rx_clk_data;
reg  [15:0] csr_rx_adj_fracns_1g_rx_clk_reg;

assign csr_rx_adj_fracns_1g_csr_clk_valid = csr_rx_adj_fracns_1g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_adj_fracns_1g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_adj_fracns_1g_csr_clk_ready),
    .in_valid    (csr_rx_adj_fracns_1g_csr_clk_valid),
    .in_data     (rx_adj_fracns_1g),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_adj_fracns_1g_rx_clk_valid),
    .out_data    (csr_rx_adj_fracns_1g_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_fracns_1g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_fracns_1g_rx_clk_valid) begin
              csr_rx_adj_fracns_1g_rx_clk_reg <= csr_rx_adj_fracns_1g_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_fracns_1g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_fracns_1g_rx_clk_valid) begin
              csr_rx_adj_fracns_1g_rx_clk_reg <= csr_rx_adj_fracns_1g_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_adj_fracns_1g = csr_rx_adj_fracns_1g_rx_clk_reg;

// Multi-bits clock crossing for csr_rx_adj_ns_1g
wire csr_rx_adj_ns_1g_csr_clk_ready;
wire csr_rx_adj_ns_1g_csr_clk_valid;
wire csr_rx_adj_ns_1g_rx_clk_valid;
wire [15:0] csr_rx_adj_ns_1g_rx_clk_data;
reg  [15:0] csr_rx_adj_ns_1g_rx_clk_reg;

assign csr_rx_adj_ns_1g_csr_clk_valid = csr_rx_adj_ns_1g_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_adj_ns_1g(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_adj_ns_1g_csr_clk_ready),
    .in_valid    (csr_rx_adj_ns_1g_csr_clk_valid),
    .in_data     (rx_adj_ns_1g),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_adj_ns_1g_rx_clk_valid),
    .out_data    (csr_rx_adj_ns_1g_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_ns_1g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_ns_1g_rx_clk_valid) begin
              csr_rx_adj_ns_1g_rx_clk_reg <= csr_rx_adj_ns_1g_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_adj_ns_1g_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_adj_ns_1g_rx_clk_valid) begin
              csr_rx_adj_ns_1g_rx_clk_reg <= csr_rx_adj_ns_1g_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_adj_ns_1g = csr_rx_adj_ns_1g_rx_clk_reg;

// Multi-bits clock crossing for csr_rx_p2p_val_ns
wire csr_rx_p2p_val_ns_csr_clk_ready;
wire csr_rx_p2p_val_ns_csr_clk_valid;
wire csr_rx_p2p_val_ns_rx_clk_valid;
wire [29:0] csr_rx_p2p_val_ns_rx_clk_data;
reg  [29:0] csr_rx_p2p_val_ns_rx_clk_reg;

assign csr_rx_p2p_val_ns_csr_clk_valid = csr_rx_p2p_val_ns_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (30),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_p2p_val_ns(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_p2p_val_ns_csr_clk_ready),
    .in_valid    (csr_rx_p2p_val_ns_csr_clk_valid),
    .in_data     (rx_p2p_val_ns),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_p2p_val_ns_rx_clk_valid),
    .out_data    (csr_rx_p2p_val_ns_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_p2p_val_ns_rx_clk_reg <= 30'h00000000;
      end
      else begin
          if(csr_rx_p2p_val_ns_rx_clk_valid) begin
              csr_rx_p2p_val_ns_rx_clk_reg <= csr_rx_p2p_val_ns_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_p2p_val_ns_rx_clk_reg <= 30'h00000000;
      end
      else begin
          if(csr_rx_p2p_val_ns_rx_clk_valid) begin
              csr_rx_p2p_val_ns_rx_clk_reg <= csr_rx_p2p_val_ns_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_p2p_val_ns = csr_rx_p2p_val_ns_rx_clk_reg;

// Single-bit clock crossing for csr_rx_p2p_val_valid
alt_em10g32_std_synchronizer #(.depth(SYNCHRONIZER_DEPTH)) sync_rx_clk_csr_rx_p2p_val_valid (
    .clk(rx_clk),
    .reset_n(rx_clk_rst_n),
    .din(rx_p2p_val_valid),
    .dout(csr_rx_p2p_val_valid)
);

// Multi-bits clock crossing for csr_rx_p2p_val_fns
wire csr_rx_p2p_val_fns_csr_clk_ready;
wire csr_rx_p2p_val_fns_csr_clk_valid;
wire csr_rx_p2p_val_fns_rx_clk_valid;
wire [15:0] csr_rx_p2p_val_fns_rx_clk_data;
reg  [15:0] csr_rx_p2p_val_fns_rx_clk_reg;

assign csr_rx_p2p_val_fns_csr_clk_valid = csr_rx_p2p_val_fns_csr_clk_ready;

alt_em10g32_clock_crosser
#(
    .SYMBOLS_PER_BEAT    (1),
    .BITS_PER_SYMBOL     (16),
    .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
    .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
    .USE_OUTPUT_PIPELINE (0)
) clock_crosser_rx_clk_csr_rx_p2p_val_fns(
    .in_clk      (csr_clk),
    .in_reset_n  (csr_rx_clk_cc_in_rst_n),
    .in_ready    (csr_rx_p2p_val_fns_csr_clk_ready),
    .in_valid    (csr_rx_p2p_val_fns_csr_clk_valid),
    .in_data     (rx_p2p_val_fns),
    .out_clk     (rx_clk),
    .out_reset_n (csr_rx_clk_cc_out_rst_n),
    .out_ready   (1'b1),
    .out_valid   (csr_rx_p2p_val_fns_rx_clk_valid),
    .out_data    (csr_rx_p2p_val_fns_rx_clk_data)
);

generate if (SYNC_RESET_N == 1) begin
  always @(posedge rx_clk) begin
      if(!rx_clk_rst_n) begin
          csr_rx_p2p_val_fns_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_p2p_val_fns_rx_clk_valid) begin
              csr_rx_p2p_val_fns_rx_clk_reg <= csr_rx_p2p_val_fns_rx_clk_data;
          end
      end
  end
end else begin
  always @(posedge rx_clk or negedge rx_clk_rst_n) begin
      if(!rx_clk_rst_n) begin
          csr_rx_p2p_val_fns_rx_clk_reg <= 16'h0000;
      end
      else begin
          if(csr_rx_p2p_val_fns_rx_clk_valid) begin
              csr_rx_p2p_val_fns_rx_clk_reg <= csr_rx_p2p_val_fns_rx_clk_data;
          end
      end
  end
end
endgenerate

assign csr_rx_p2p_val_fns = csr_rx_p2p_val_fns_rx_clk_reg;

// Pseudo-static signal for ecc_corrected_err_status
assign ecc_corrected_err_status = ecc_corrected_err;

// Pseudo-static signal for ecc_fatal_err_status
assign ecc_fatal_err_status = ecc_fatal_err;

// Pseudo-static signal for ecc_corrected_err_status_ena
assign ecc_corrected_err_status_ena = ecc_corrected_err_ena;

// Pseudo-static signal for ecc_fatal_err_status_ena
assign ecc_fatal_err_status_ena = ecc_fatal_err_ena;

// Pseudo-static signal for csr_tx_adptdcff_rdwtrmrk_dis
assign csr_tx_adptdcff_rdwtrmrk_dis = tx_adptdcff_rdwtrmrk_dis;

// Pseudo-static signal for csr_tx_adptdcff_rdwtrmrk
assign csr_tx_adptdcff_rdwtrmrk = tx_adptdcff_rdwtrmrk;

// Pseudo-static signal for csr_tx_adptdcff_vldpkt_minwt
assign csr_tx_adptdcff_vldpkt_minwt = tx_adptdcff_vldpkt_minwt;


// Register Map Instance
alt_em10g32_creg_map #(
    .SYNC_RESET_N(SYNC_RESET_N)
) alt_em10g32_creg_map_inst(
    // Clock & Reset
    .csr_clk(csr_clk),
    .csr_clk_rst_n(csr_clk_rst_n),

    // Register Inputs and Outputs
    .revision_id(revision_id),
    .mac_capability(mac_capability),
    .pri_macaddr_bit31to0(pri_macaddr_bit31to0),
    .pri_macaddr_bit47to32(pri_macaddr_bit47to32),
    .wait_request_timeout(wait_request_timeout),
    .wait_request_timeout_in(wait_request_timeout_in),
    .tx_data_path_reset(tx_data_path_reset),
    .rx_data_path_reset(rx_data_path_reset),
    .tx_tsfr_en_n(tx_tsfr_en_n),
    .tx_datafrm_tsfr_en_sts(tx_datafrm_tsfr_en_sts),
    .tx_busy(tx_busy),
    .tx_rst_sts(tx_rst_sts),
    .tx_pad_insrt_en(tx_pad_insrt_en),
    .tx_crcctl_reserved(tx_crcctl_reserved),
    .tx_crc_insrt_en(tx_crc_insrt_en),
    .tx_preamb_passthru_en(tx_preamb_passthru_en),
    .tx_sa_override_en(tx_sa_override_en),
    .tx_max_datafrmlen(tx_max_datafrmlen),
    .txvlandet_dis(txvlandet_dis),
    .tx_pipg10g_dic(tx_pipg10g_dic),
    .tx_pipg1g_fixed(tx_pipg1g_fixed),
    .tx_udf_errcnt_bit31to0(tx_udf_errcnt_bit31to0),
    .tx_udf_errcnt_bit35to32(tx_udf_errcnt_bit35to32),
    .tx_pausefrm_xonxoff(tx_pausefrm_xonxoff),
    .tx_pausefrm_xonxoff_valid_internal(tx_pausefrm_xonxoff_valid_internal),
    .csr_tx_pause_xonxoff_ctrl_clr_internal(csr_tx_pause_xonxoff_ctrl_clr_internal),
    .tx_pausefrm_pqt(tx_pausefrm_pqt),
    .tx_pausefrm_xoff_hqt(tx_pausefrm_xoff_hqt),
    .tx_pausefrm_en(tx_pausefrm_en),
    .tx_pausefrm_policy(tx_pausefrm_policy),
    .tx_pfcfrm_en0(tx_pfcfrm_en0),
    .tx_pfcfrm_en1(tx_pfcfrm_en1),
    .tx_pfcfrm_en2(tx_pfcfrm_en2),
    .tx_pfcfrm_en3(tx_pfcfrm_en3),
    .tx_pfcfrm_en4(tx_pfcfrm_en4),
    .tx_pfcfrm_en5(tx_pfcfrm_en5),
    .tx_pfcfrm_en6(tx_pfcfrm_en6),
    .tx_pfcfrm_en7(tx_pfcfrm_en7),
    .tx_pfcfrm_pqt0(tx_pfcfrm_pqt0),
    .tx_pfcfrm_pqt1(tx_pfcfrm_pqt1),
    .tx_pfcfrm_pqt2(tx_pfcfrm_pqt2),
    .tx_pfcfrm_pqt3(tx_pfcfrm_pqt3),
    .tx_pfcfrm_pqt4(tx_pfcfrm_pqt4),
    .tx_pfcfrm_pqt5(tx_pfcfrm_pqt5),
    .tx_pfcfrm_pqt6(tx_pfcfrm_pqt6),
    .tx_pfcfrm_pqt7(tx_pfcfrm_pqt7),
    .tx_xoff_hqt0(tx_xoff_hqt0),
    .tx_xoff_hqt1(tx_xoff_hqt1),
    .tx_xoff_hqt2(tx_xoff_hqt2),
    .tx_xoff_hqt3(tx_xoff_hqt3),
    .tx_xoff_hqt4(tx_xoff_hqt4),
    .tx_xoff_hqt5(tx_xoff_hqt5),
    .tx_xoff_hqt6(tx_xoff_hqt6),
    .tx_xoff_hqt7(tx_xoff_hqt7),
    .tx_unidirectional_en(tx_unidirectional_en),
    .tx_unidirectional_remote_fault_dis(tx_unidirectional_remote_fault_dis),
    .tx_unidirectional_force_remote_fault(tx_unidirectional_force_remote_fault),
    .rx_tsfr_en_n(rx_tsfr_en_n),
    .rx_tsfr_sts(rx_tsfr_sts),
    .rx_busy(rx_busy),
    .rx_rst_sts(rx_rst_sts),
    .rx_crcpad_rem(rx_crcpad_rem),
    .rx_crc_reserved(rx_crc_reserved),
    .rx_crc_chk(rx_crc_chk),
    .rx_preambctl_fwd(rx_preambctl_fwd),
    .rx_preamb_passthru_en(rx_preamb_passthru_en),
    .rx_allucast_en(rx_allucast_en),
    .rx_allmcast_en(rx_allmcast_en),
    .rx_fwd_ctlfrm(rx_fwd_ctlfrm),
    .rx_fwd_pausefrm(rx_fwd_pausefrm),
    .rx_ignore_pausefrm(rx_ignore_pausefrm),
    .rx_suppaddr_en0(rx_suppaddr_en0),
    .rx_suppaddr_en1(rx_suppaddr_en1),
    .rx_suppaddr_en2(rx_suppaddr_en2),
    .rx_suppaddr_en3(rx_suppaddr_en3),
    .rx_max_datafrmlen(rx_max_datafrmlen),
    .rxvlandet_dis(rxvlandet_dis),
    .rx_supp_macaddr_bit31to0_0(rx_supp_macaddr_bit31to0_0),
    .rx_supp_macaddr_bit47to32_0(rx_supp_macaddr_bit47to32_0),
    .rx_supp_macaddr_bit31to0_1(rx_supp_macaddr_bit31to0_1),
    .rx_supp_macaddr_bit47to32_1(rx_supp_macaddr_bit47to32_1),
    .rx_supp_macaddr_bit31to0_2(rx_supp_macaddr_bit31to0_2),
    .rx_supp_macaddr_bit47to32_2(rx_supp_macaddr_bit47to32_2),
    .rx_supp_macaddr_bit31to0_3(rx_supp_macaddr_bit31to0_3),
    .rx_supp_macaddr_bit47to32_3(rx_supp_macaddr_bit47to32_3),
    .rx_pfc_ignore_pausefrm_0(rx_pfc_ignore_pausefrm_0),
    .rx_pfc_ignore_pausefrm_1(rx_pfc_ignore_pausefrm_1),
    .rx_pfc_ignore_pausefrm_2(rx_pfc_ignore_pausefrm_2),
    .rx_pfc_ignore_pausefrm_3(rx_pfc_ignore_pausefrm_3),
    .rx_pfc_ignore_pausefrm_4(rx_pfc_ignore_pausefrm_4),
    .rx_pfc_ignore_pausefrm_5(rx_pfc_ignore_pausefrm_5),
    .rx_pfc_ignore_pausefrm_6(rx_pfc_ignore_pausefrm_6),
    .rx_pfc_ignore_pausefrm_7(rx_pfc_ignore_pausefrm_7),
    .rx_pfc_fwd(rx_pfc_fwd),
    .rx_pkt_ovrflw_errcnt_bit31to0(rx_pkt_ovrflw_errcnt_bit31to0),
    .rx_pkt_ovrflw_errcnt_bit35to32(rx_pkt_ovrflw_errcnt_bit35to32),
    .rx_pkt_ovrflw_etherstatsdropevents_bit31to0(rx_pkt_ovrflw_etherstatsdropevents_bit31to0),
    .rx_pkt_ovrflw_etherstatsdropevents_bit35to32(rx_pkt_ovrflw_etherstatsdropevents_bit35to32),
    .tx_period_10g(tx_period_10g),
    .tx_adj_fracns_10g(tx_adj_fracns_10g),
    .tx_adj_ns_10g(tx_adj_ns_10g),
    .tx_period_1g(tx_period_1g),
    .tx_adj_fracns_1g(tx_adj_fracns_1g),
    .tx_adj_ns_1g(tx_adj_ns_1g),
    .tx_asymmetry(tx_asymmetry),
    .tx_p2p_dir_egress(tx_p2p_dir_egress),
    .cf_overflow_ingress(cf_overflow_ingress),
    .cf_overflow_ingress_status_in(cf_overflow_ingress_status_in),
    .cf_overflow_egress(cf_overflow_egress),
    .cf_overflow_egress_status_in(cf_overflow_egress_status_in),
    .cf_rt_gt_eq_4s(cf_rt_gt_eq_4s),
    .cf_rt_gt_eq_4s_status_in(cf_rt_gt_eq_4s_status_in),
    .cf_rt_neg(cf_rt_neg),
    .cf_rt_neg_status_in(cf_rt_neg_status_in),
    .rx_period_10g(rx_period_10g),
    .rx_adj_fracns_10g(rx_adj_fracns_10g),
    .rx_adj_ns_10g(rx_adj_ns_10g),
    .rx_period_1g(rx_period_1g),
    .rx_adj_fracns_1g(rx_adj_fracns_1g),
    .rx_adj_ns_1g(rx_adj_ns_1g),
    .rx_p2p_val_ns(rx_p2p_val_ns),
    .rx_p2p_val_valid(rx_p2p_val_valid),
    .rx_p2p_val_fns(rx_p2p_val_fns),
    .ecc_corrected_err(ecc_corrected_err),
    .ecc_corrected_err_status_in(ecc_corrected_err_status_in),
    .ecc_fatal_err(ecc_fatal_err),
    .ecc_fatal_err_status_in(ecc_fatal_err_status_in),
    .ecc_corrected_err_ena(ecc_corrected_err_ena),
    .ecc_fatal_err_ena(ecc_fatal_err_ena),
    .tx_adptdcff_rdwtrmrk_dis(tx_adptdcff_rdwtrmrk_dis),
    .tx_adptdcff_rdwtrmrk(tx_adptdcff_rdwtrmrk),
    .tx_adptdcff_vldpkt_minwt(tx_adptdcff_vldpkt_minwt),

    // Avalon-MM Slave
    .avs_address(reg_map_avs_address),
    .avs_read(reg_map_avs_read),
    .avs_write(reg_map_avs_write),
    .avs_writedata(reg_map_avs_writedata),
    .avs_readdata(reg_map_avs_readdata),
    .avs_waitrequest(),

    // Parameters
    .insert_st_adaptor(insert_st_adaptor),
    .enable_tx(enable_tx),
    .enable_rx(enable_rx),
    .enable_tx_crc(enable_tx_crc),
    .enable_supp_addr(enable_supp_addr),
    .enable_pfc(enable_pfc),
    .enable_preamble_passthrough(enable_preamble_passthrough),
    .pfc_priority_num(pfc_priority_num),
    .enable_timestamping(enable_timestamping),
    .enable_asymmetry(enable_asymmetry),
    .enable_p2p(enable_p2p),
    .enable_mem_ecc(enable_mem_ecc),
    .enable_1g10g_mac(enable_1g10g_mac),
    .enable_unidirectional(enable_unidirectional),
    .enable_txrx_datapath_n(enable_txrx_datapath_n)
);

endmodule

