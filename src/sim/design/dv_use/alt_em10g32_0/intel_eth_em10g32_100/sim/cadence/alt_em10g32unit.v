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


//////////////////////////////////////////////////////////////////////////////
// 
// Module: Altera Ethernet 32-bit MAC Top
//
// Description: This module sits at the highest hierarchy and depending on the IP configuration (TX only, RX only, TX+RX) 
//
// Parameter:
//  * DATAPATH_OPTION = 1 - TX only, 2 - RX only, 3 - TX and RX
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32unit #(
    parameter DEVICE_FAMILY             = "Stratix V",
    
    parameter INSERT_ST_ADAPTOR         = 0,
    
    parameter DATAPATH_OPTION           = 3,
    parameter ENABLE_SUPP_ADDR          = 0,
    parameter ENABLE_PFC                = 0,
    parameter PFC_PRIORITY_NUMBER       = 8, // Min = 1
    parameter INSTANTIATE_STATISTICS    = 0,
    parameter REGISTER_BASED_STATISTICS = 0,
    
    parameter PREAMBLE_PASSTHROUGH      = 0,
    parameter ENABLE_TIMESTAMPING       = 0,
    parameter ENABLE_PTP_1STEP          = 0,
    parameter ENABLE_ASYMMETRY          = 0,
    parameter ENABLE_P2P                = 0,
    parameter TSTAMP_FP_WIDTH           = 4,
    parameter ENABLE_1G10G_MAC          = 0,
    parameter ENABLE_MEM_ECC            = 0,
    parameter ENABLE_UNIDIRECTIONAL     = 0,
    parameter ENABLE_10GBASER_REG_MODE  = 0,
    parameter ENABLE_TXRX_DATAPATH      = 0,
    parameter TX_XGMII_ADAPTER_PATH_DELAY = 0,
    parameter RX_XGMII_ADAPTER_PATH_DELAY = 0,
    parameter SYNCHRONIZER_DEPTH        = 4,
    parameter TIME_OF_DAY_FORMAT        = 2,    
    parameter DEBUG                     = 0,
    parameter SYNC_RESET_N              = 1
) (

    // Clock and reset
    input wire tx_clk_sync,
    input wire tx_rst_n_sync,
    
    input wire rx_clk_sync,
    input wire rx_rst_n_sync,

    input wire csr_clk_sync,
    input wire csr_rst_n_sync,

    input wire gmii_tx_clk_sync,
    input wire gmii_tx_rst_n_sync,

    input wire gmii_rx_clk_sync,
    input wire gmii_rx_rst_n_sync,

    // Reset for statistics in TX/RX clock domain
    input wire csr_rst_tx_clk_n,
    input wire csr_rst_rx_clk_n,
    
    // Reset for clock crosser
    input wire csr_tx_cc_in_rst_n,
    input wire csr_tx_cc_out_rst_n,
    input wire tx_csr_cc_in_rst_n,
    input wire tx_csr_cc_out_rst_n,

    input wire csr_gmii_tx_cc_in_rst_n,
    input wire csr_gmii_tx_cc_out_rst_n,
    input wire gmii_tx_csr_cc_in_rst_n,
    input wire gmii_tx_csr_cc_out_rst_n,

    input wire csr_rx_cc_in_rst_n,
    input wire csr_rx_cc_out_rst_n,
    input wire rx_csr_cc_in_rst_n,
    input wire rx_csr_cc_out_rst_n,

    input wire csr_gmii_rx_cc_in_rst_n,
    input wire csr_gmii_rx_cc_out_rst_n,
    input wire gmii_rx_csr_cc_in_rst_n,
    input wire gmii_rx_csr_cc_out_rst_n,

    input wire tx_rx_cc_in_rst_n,
    input wire tx_rx_cc_out_rst_n,
    input wire rx_tx_cc_in_rst_n,
    input wire rx_tx_cc_out_rst_n,

    // Avalon-MM Slave
    input wire [9:0]    csr_address,                                    
    input wire          csr_read,
    input wire          csr_write,                                        
    input wire [31:0]   csr_writedata,                                
    output wire [31:0]  csr_readdata,                                  
    output wire         csr_waitrequest,                            
    
    // Speed Selection
    input  wire [(ENABLE_1G10G_MAC >= 3 ? 2 : 1):0]   speed_sel /* synthesis altera_attribute="suppress_da_rule_internal=\"D101,D103\"" */,
    
    // CSR Output
    output wire         csr_tx_adptdcff_rdwtrmrk_dis,
    output wire [ 2:0]  csr_tx_adptdcff_rdwtrmrk,
    output wire [ 2:0]  csr_tx_adptdcff_vldpkt_minwt,
    
    // TX path
    // Av-ST pause control path
    input wire [1:0]    avalon_st_pause_data,
    input wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_gen_data,

    // Av-ST sink data path
    input wire          avalon_st_tx_startofpacket,
    input wire          avalon_st_tx_endofpacket,
    input wire          avalon_st_tx_valid,
    input wire [31:0]   avalon_st_tx_data,
    input wire [1:0]    avalon_st_tx_empty,
    input wire          avalon_st_tx_error,

    output wire         avalon_st_tx_ready,

    // XGMII Transmit
    input wire [1:0]    link_fault_status_xgmii_tx_data,
    output wire [31:0]  xgmii_tx_data,
    output wire [3:0]   xgmii_tx_control,
    output wire         xgmii_tx_valid,
    
    // GMII Transmit
    output wire [ 7:0]  gmii_tx_d,
    output wire         gmii_tx_en,
    output wire         gmii_tx_err,

    // GMII 16 bit Transmit
    output wire [15:0]  gmii16b_tx_d,
    output wire [ 1:0]  gmii16b_tx_en,
    output wire [ 1:0]  gmii16b_tx_err,
    
    // MII Transmit
    input  wire         tx_clkena,
    input  wire         tx_clkena_half_rate,
    output wire [ 3:0]  mii_tx_d,
    output wire         mii_tx_en,
    output wire         mii_tx_err,
    
    // Frame Info (User Logic)
    output wire         avalon_st_txstatus_valid,
    output wire [39:0]  avalon_st_txstatus_data,
    output wire [ 6:0]  avalon_st_txstatus_error,
    
    // Pause Quanta (For TX only variant)
    input  wire         avalon_st_tx_pause_length_valid,
    input  wire [15:0]  avalon_st_tx_pause_length_data,
    
    // PFC XON/XOFF Status
    output wire         avalon_st_tx_pfc_status_valid,
    output wire [15:0]  avalon_st_tx_pfc_status_data,
    
    
    // RX path
    // XGMII Receive
    input  wire [31:0]  xgmii_rx_data,
    input  wire [ 3:0]  xgmii_rx_control,
    input  wire         xgmii_rx_valid,
    output wire [ 1:0]  link_fault_status_xgmii_rx_data,
    
    // GMII Receive
    input  wire [ 7:0]  gmii_rx_d,
    input  wire         gmii_rx_dv,
    input  wire         gmii_rx_err,

    // GMII 16 bit receive
    input  wire [15:0]  gmii16b_rx_d,
    input  wire [ 1:0]  gmii16b_rx_dv,
    input  wire [ 1:0]  gmii16b_rx_err,
    
    // MII Receive
    input  wire         rx_clkena,
    input  wire         rx_clkena_half_rate,
    input  wire [ 3:0]  mii_rx_d,
    input  wire         mii_rx_dv,
    input  wire         mii_rx_err,
    
    // Avalon-ST Receive (User)
    output wire [31:0]  avalon_st_rx_data,
    output wire         avalon_st_rx_startofpacket,
    output wire         avalon_st_rx_endofpacket,
    output wire         avalon_st_rx_valid,
    output wire [ 1:0]  avalon_st_rx_empty,
    output wire [ 5:0]  avalon_st_rx_error,
    input  wire         avalon_st_rx_ready,
    
    // Frame Info (User Logic)
    output wire         avalon_st_rxstatus_valid,
    output wire [39:0]  avalon_st_rxstatus_data,
    output wire [ 6:0]  avalon_st_rxstatus_error,
    
    // Pause Quanta (For RX only variant)
    output wire         avalon_st_rx_pause_length_valid,
    output wire [15:0]  avalon_st_rx_pause_length_data,
    
    // PFC XON/XOFF Status
    output wire         avalon_st_rx_pfc_status_valid,
    output wire [15:0]  avalon_st_rx_pfc_status_data,
    
    // PFC Pause Data
    output wire [ 7:0]  avalon_st_rx_pfc_pause_data,
    
    // 1588
    input  wire [23:0]  tx_path_delay_10g_data,
    input  wire [95:0]  tx_time_of_day_96b_10g_data,
    input  wire [63:0]  tx_time_of_day_64b_10g_data,
    
    input  wire [21:0]  tx_path_delay_1g_data,
    input  wire [95:0]  tx_time_of_day_96b_1g_data,
    input  wire [63:0]  tx_time_of_day_64b_1g_data,
    
    input  wire [23:0]  rx_path_delay_10g_data,
    input  wire [95:0]  rx_time_of_day_96b_10g_data,
    input  wire [63:0]  rx_time_of_day_64b_10g_data,
    
    input  wire [21:0]  rx_path_delay_1g_data,
    input  wire [95:0]  rx_time_of_day_96b_1g_data,
    input  wire [63:0]  rx_time_of_day_64b_1g_data,
    
    output wire                        tx_egress_timestamp_96b_valid,
    output wire [95:0]                 tx_egress_timestamp_96b_data,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_96b_fingerprint,
    output wire                        tx_egress_timestamp_64b_valid,
    output wire [63:0]                 tx_egress_timestamp_64b_data,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_64b_fingerprint,
    
    output wire         rx_ingress_timestamp_96b_valid,
    output wire [95:0]  rx_ingress_timestamp_96b_data,
    output wire         rx_ingress_timestamp_64b_valid,
    output wire [63:0]  rx_ingress_timestamp_64b_data,
    
    //meanPathDelay (p2p)
    output wire         rx_ingress_p2p_val_valid,
    output wire [45:0]  rx_ingress_p2p_val,
    
    // User input for 1-step operations
    input  wire                        tx_egress_p2p_update,
    input  wire [45:0]                 tx_egress_p2p_val,    
    input  wire                        tx_egress_asymmetry_update,
    input  wire                        tx_egress_timestamp_request_valid,
    input  wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_request_fingerprint,
    input  wire                        tx_etstamp_ins_ctrl_timestamp_insert,
    input  wire                        tx_etstamp_ins_ctrl_timestamp_format,
    input  wire                        tx_etstamp_ins_ctrl_residence_time_update,
    input  wire [95:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_96b,
    input  wire [63:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_64b,
    input  wire                        tx_etstamp_ins_ctrl_residence_time_calc_format,
    input  wire                        tx_etstamp_ins_ctrl_checksum_zero,
    input  wire                        tx_etstamp_ins_ctrl_checksum_correct,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_timestamp,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_correction_field,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_field,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_correction,
    
    // TX disable
    output wire                         csr_tx_tsfr_en_n,
    
    // TX enabled status
    input wire                          tx_en,
    input wire                          tx_en_n,
    
    // Unidirectional port
    output wire                         unidirectional_en,
    output wire                         unidirectional_remote_fault_dis,
    output wire                         unidirectional_force_remote_fault,
    
    // csr to reset tx/rx path
    output wire                         csr_tx_data_path_reset,
    output wire                         csr_rx_data_path_reset,
    
    // tx and rx reset status
    input wire                          status_tx_rst_sts,
    input wire                          status_rx_rst_sts,
    
    // ECC Status Output
    output wire                        ecc_err_det_corr,
    output wire                        ecc_err_det_uncorr
    
);
    // Local parameters
    localparam BITSPERSYMBOL    = 8;
    localparam SYMBOLSPERBEAT   = 4;

    localparam DATAWIDTH        = BITSPERSYMBOL * SYMBOLSPERBEAT;
    localparam EMPTYWIDTH       = log2ceil(SYMBOLSPERBEAT); 
    localparam TXUSRERRWIDTH    = 1;

    localparam LINK_FAULT_DATAWIDTH = 2;

    localparam INSTANTIATE_TX_CRC        = 1; // must not disable unless pause/pfc generation logic is also removed
    
    // NOTE: Do not expose this parameter in hw.tcl
    // Run register based statistics module in CSR clock module for better timing performance
    // Run memory based statistics module in TX/RX clock domain to avoid problem updating counter when back-to-back 64-bytes frames are received
    localparam STATISTICS_CSR_CLOCK      = (REGISTER_BASED_STATISTICS == 1) ? 1 : 0;

    localparam ENABLE_GMII16B = ((ENABLE_1G10G_MAC == 3) || (ENABLE_1G10G_MAC == 4)||(ENABLE_1G10G_MAC == 6)||(ENABLE_1G10G_MAC == 7))? 1 : 0;
    localparam ENABLE_XGMII   = (ENABLE_1G10G_MAC == 3) ? 0 : 1;
    
    // Internal wires
    wire [ 2:0]   speed_sel_int;
    wire [2:0]    speed_sel_int_sync_tx;  
    wire [2:0]    speed_sel_int_sync_rx;  
    
    reg [2:0]     speed_sel_int_sync_tx_reg1;
    reg [2:0]     speed_sel_int_sync_tx_reg2;
    reg [2:0]     speed_sel_int_sync_rx_reg1;
    reg [2:0]     speed_sel_int_sync_rx_reg2;
    
    wire [15:0]   csr_tx_pause_pq;
    wire          csr_tx_pause_select;
    wire [15:0]   csr_tx_pause_holdoff_pq;
    wire          csr_tx_pause_status; 

    wire insert_st_adaptor;
    
    wire enable_tx;                                 
    wire enable_rx;                                        
    wire enable_tx_crc;                                
    wire enable_supp_addr;                  
    wire enable_pfc;                                    
    wire enable_preamble_passthrough;
    wire [3:0] pfc_priority_num;                      
    wire enable_timestamping;                   
    wire enable_asymmetry;                   
    wire enable_p2p;                   
    wire enable_mem_ecc;
    wire enable_1g10g_mac;
    wire enable_unidirectional;
    wire enable_txrx_datapath_n;
    wire instantiate_statistics;
    wire register_based_statistics;

    
    wire [9:0]  avs_address;                                    
    wire        avs_read;
    wire        avs_write;                                        
    wire [31:0] avs_writedata;                                
    wire [31:0] avs_readdata;                                  
    wire        avs_waitrequest;  

    wire        frm_sink_sop;
    wire        frm_sink_eop;
    wire        frm_sink_valid;
    wire [31:0] frm_sink_data;
    wire [1:0]  frm_sink_empty;
    wire        frm_sink_error;

    wire        frm_sink_ready;

    wire [31:0] rs2top_eth_xgmii_data;
    wire [3:0]  rs2top_eth_xgmii_ctrl;
    wire        rs2top_eth_xgmii_valid;

    wire [1:0]  pause_ctrl_sink_data;
    wire [(PFC_PRIORITY_NUMBER*2)-1:0] pfc_ctrl_sink_data;

    wire [(LINK_FAULT_DATAWIDTH-1):0] rx_link_fault_status;
    
    // Register Inputs and Outputs
    wire    [ 7:0]      const_revision_id;
    wire    [31:0]      const_mac_capability;
    wire    [47:0]      csr_tx_mac_sa;
    wire    [47:0]      csr_rx_primaddr;
    wire                status_tx_datafrm_tsfr_en_sts;
    wire                status_tx_busy;
    wire                status_rx_busy;
    wire                tx_tsfr_en_n; 
    wire                csr_tx_pad_insrt_en;
    wire                const_tx_crcctl_reserved;
    wire                csr_tx_crc_insrt_en;
    wire                csr_tx_preamble_passthru;
    wire                csr_tx_mac_sa_ovrd_en;
    wire     [15:0]     csr_tx_max_frmlen;
    wire                csr_txvlandet_dis;
    wire     [ 7:0]     tx_pipg_10g_dic;
    wire     [ 7:0]     tx_pipg_1g_fixed;
    wire                pulse_tx_udf_errcnt;
    wire     [ 1:0]     csr_tx_pause_xonxoff_ctrl;
    wire                csr_tx_pause_xonxoff_ctrl_valid;
    wire                csr_tx_pause_xonxoff_ctrl_clr;
    wire                csr_tx_pause_en;
    wire     [ 1:0]     csr_tx_pausefrm_policy;
    wire                csr_tx_pfc0_en;
    wire                csr_tx_pfc1_en;
    wire                csr_tx_pfc2_en;
    wire                csr_tx_pfc3_en;
    wire                csr_tx_pfc4_en;
    wire                csr_tx_pfc5_en;
    wire                csr_tx_pfc6_en;
    wire                csr_tx_pfc7_en;
    wire     [15:0]     csr_tx_pfc0_pqt;
    wire     [15:0]     csr_tx_pfc1_pqt;
    wire     [15:0]     csr_tx_pfc2_pqt;
    wire     [15:0]     csr_tx_pfc3_pqt;
    wire     [15:0]     csr_tx_pfc4_pqt;
    wire     [15:0]     csr_tx_pfc5_pqt;
    wire     [15:0]     csr_tx_pfc6_pqt;
    wire     [15:0]     csr_tx_pfc7_pqt;
    wire     [15:0]     csr_tx_pfc0_xoff_hqt;
    wire     [15:0]     csr_tx_pfc1_xoff_hqt;
    wire     [15:0]     csr_tx_pfc2_xoff_hqt;
    wire     [15:0]     csr_tx_pfc3_xoff_hqt;
    wire     [15:0]     csr_tx_pfc4_xoff_hqt;
    wire     [15:0]     csr_tx_pfc5_xoff_hqt;
    wire     [15:0]     csr_tx_pfc6_xoff_hqt;
    wire     [15:0]     csr_tx_pfc7_xoff_hqt;
    wire                csr_tx_unidirectional_en;
    wire                csr_tx_unidirectional_remote_fault_dis;
    wire                csr_tx_unidirectional_force_remote_fault;
    wire                csr_rx_tsfr_en_n;
    wire                csr_rx_tsfr_sts;
    wire                status_rx_tsfr_sts;
    wire     [ 1:0]     csr_rx_crcpad_rem;
    wire                status_rx_crc_reserved;
    wire                csr_rx_crc_chk;
    wire                csr_rx_preamb_fwd_ctl;
    wire                csr_rx_preamb_passthru_en;
    wire                csr_rx_allucast_en;
    wire                csr_rx_allmcast_en;
    wire                csr_rx_fwd_ctlfrm;
    wire                csr_rx_fwd_pausefrm;
    wire                csr_rx_ignore_pausefrm;
    wire                csr_rx_suppaddr_en0;
    wire                csr_rx_suppaddr_en1;
    wire                csr_rx_suppaddr_en2;
    wire                csr_rx_suppaddr_en3;
    wire     [15:0]     csr_rx_max_datafrmlen;
    wire                csr_rxvlandet_dis;
    wire     [47:0]     csr_rx_supp_macaddr_0;
    wire     [47:0]     csr_rx_supp_macaddr_1;
    wire     [47:0]     csr_rx_supp_macaddr_2;
    wire     [47:0]     csr_rx_supp_macaddr_3;
    wire                csr_rx_pfc_ignore_pausefrm_0;
    wire                csr_rx_pfc_ignore_pausefrm_1;
    wire                csr_rx_pfc_ignore_pausefrm_2;
    wire                csr_rx_pfc_ignore_pausefrm_3;
    wire                csr_rx_pfc_ignore_pausefrm_4;
    wire                csr_rx_pfc_ignore_pausefrm_5;
    wire                csr_rx_pfc_ignore_pausefrm_6;
    wire                csr_rx_pfc_ignore_pausefrm_7;
    wire                csr_rx_pfc_fwd;
    wire                pulse_rx_pkt_ovrflw_errcnt;
    wire                pulse_rx_pkt_ovrflw_etherstatsdropevents;
    wire     [19:0]     csr_tx_period_10g;
    wire     [15:0]     csr_tx_adj_fracns_10g;
    wire     [15:0]     csr_tx_adj_ns_10g;
    wire     [19:0]     csr_tx_period_1g;
    wire     [18:0]     csr_tx_asymmetry;
    wire                csr_p2p_dir_egress;
    wire     [15:0]     csr_tx_adj_fracns_1g;
    wire     [15:0]     csr_tx_adj_ns_1g;
    wire     [19:0]     csr_rx_period_10g;
    wire     [15:0]     csr_rx_adj_fracns_10g;
    wire     [15:0]     csr_rx_adj_ns_10g;
    wire     [19:0]     csr_rx_period_1g;
    wire     [15:0]     csr_rx_adj_fracns_1g;
    wire     [15:0]     csr_rx_adj_ns_1g;
    wire                ecc_corrected_err_status;
    wire                ecc_fatal_err_status;
    wire                ecc_corrected_err_status_ena;
    wire                ecc_fatal_err_status_ena;

    // From Frame Decoders to Statistics
    wire                tx_stat_valid;
    wire      [39:0]    tx_stat_data;
    wire      [ 6:0]    tx_stat_error;
    wire                rx_stat_valid;
    wire      [39:0]    rx_stat_data;
    wire      [ 6:0]    rx_stat_error;
    
    // GMII
    wire      [ 7:0]    gmii_tx_d_int;
    wire                gmii_tx_en_int;
    wire                gmii_tx_err_int;
    
    wire      [ 7:0]    gmii_rx_d_int;
    wire                gmii_rx_dv_int;
    wire                gmii_rx_err_int;
    
    // GMII 16b
    wire      [15:0]    gmii16b_tx_d_int;
    wire      [ 1:0]    gmii16b_tx_en_int;
    wire      [ 1:0]    gmii16b_tx_err_int;
    
    wire      [15:0]    gmii16b_rx_d_int;
    wire      [ 1:0]    gmii16b_rx_dv_int;
    wire      [ 1:0]    gmii16b_rx_err_int;

    // MII
    wire                tx_clkena_int;
    wire                tx_clkena_half_rate_int;
    wire      [ 3:0]    mii_tx_d_int;
    wire                mii_tx_en_int;
    wire                mii_tx_err_int;
    
    wire                rx_clkena_int;
    wire                rx_clkena_half_rate_int;
    wire      [ 3:0]    mii_rx_d_int;
    wire                mii_rx_dv_int;
    wire                mii_rx_err_int;
    
    // PFC XON/XOFF Status
    wire                avalon_st_tx_pfc_status_valid_int;
    wire      [15:0]    avalon_st_tx_pfc_status_data_int;
    
    wire                avalon_st_rx_pfc_status_valid_int;
    wire      [15:0]    avalon_st_rx_pfc_status_data_int;
    
    wire      [ 7:0]    avalon_st_rx_pfc_pause_data_int;
    
    // 1588
    wire      [23:0]    tx_path_delay_10g_data_int;
    wire      [95:0]    tx_time_of_day_96b_10g_data_int;
    wire      [63:0]    tx_time_of_day_64b_10g_data_int;
    
    wire      [21:0]    tx_path_delay_1g_data_int;
    wire      [95:0]    tx_time_of_day_96b_1g_data_int;
    wire      [63:0]    tx_time_of_day_64b_1g_data_int;
    
    wire      [23:0]    rx_path_delay_10g_data_int;
    wire      [95:0]    rx_time_of_day_96b_10g_data_int;
    wire      [63:0]    rx_time_of_day_64b_10g_data_int;
    
    wire      [21:0]    rx_path_delay_1g_data_int;
    wire      [95:0]    rx_time_of_day_96b_1g_data_int;
    wire      [63:0]    rx_time_of_day_64b_1g_data_int;
    
    wire                             tx_egress_timestamp_96b_valid_int;
    wire      [95:0]                 tx_egress_timestamp_96b_data_int;
    wire      [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_96b_fingerprint_int;
    wire                             tx_egress_timestamp_64b_valid_int;
    wire      [63:0]                 tx_egress_timestamp_64b_data_int;
    wire      [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_64b_fingerprint_int;
    
    wire                rx_ingress_timestamp_96b_valid_int;
    wire      [95:0]    rx_ingress_timestamp_96b_data_int;
    wire                rx_ingress_timestamp_64b_valid_int;
    wire      [63:0]    rx_ingress_timestamp_64b_data_int;
    
    // User input for 1-step operations
    wire                             tx_egress_p2p_update_int;
    wire      [45:0]                 tx_egress_p2p_val_int;   
    wire                             tx_egress_asymmetry_update_int;
    wire                             tx_egress_timestamp_request_valid_int;
    wire      [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_request_fingerprint_int;
    wire                             tx_etstamp_ins_ctrl_timestamp_insert_int;
    wire                             tx_etstamp_ins_ctrl_timestamp_format_int;
    wire                             tx_etstamp_ins_ctrl_residence_time_update_int;
    wire      [95:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_96b_int;
    wire      [63:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_64b_int;
    wire                             tx_etstamp_ins_ctrl_residence_time_calc_format_int;
    wire                             tx_etstamp_ins_ctrl_checksum_zero_int;
    wire                             tx_etstamp_ins_ctrl_checksum_correct_int;
    wire      [15:0]                 tx_etstamp_ins_ctrl_offset_timestamp_int;
    wire      [15:0]                 tx_etstamp_ins_ctrl_offset_correction_field_int;
    wire      [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_field_int;
    wire      [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_correction_int;
    
    // ECC status
    wire                             tx_gmii_encoder_ecc_err_corrected;
    wire                             tx_gmii_encoder_ecc_err_fatal;
    wire                             rx_gmii_decoder_ecc_err_corrected;
    wire                             rx_gmii_decoder_ecc_err_fatal;
    wire                             tx_ptp_request_control_ecc_err_corrected;
    wire                             tx_ptp_request_control_ecc_err_fatal;
    wire                             rx_ptp_aligner_ecc_err_corrected;
    wire                             rx_ptp_aligner_ecc_err_fatal;

    // Clock Crossed Signals From RX to TX
    wire                              rx_link_fault_status_rx_clk_ready;
    wire                              rx_link_fault_status_rx_clk_valid;
    wire                              rx_link_fault_status_tx_clk_valid;
    wire [(LINK_FAULT_DATAWIDTH-1):0] rx_link_fault_status_tx_clk_data;
    reg  [(LINK_FAULT_DATAWIDTH-1):0] rx_link_fault_status_tx_clk;
    
    wire                avalon_st_rx_pause_length_valid_tx_clk;
    wire      [15:0]    avalon_st_rx_pause_length_data_tx_clk;

    wire        rx2flc_pause_field_valid;
    wire [15:0] rx2flc_pause_pq;

    wire         stat_txstatus_valid;
    wire [39:0]  stat_txstatus_data;
    wire [ 6:0]  stat_txstatus_error;

    wire csr_tx_backpressure_status;
    
    // status to report packet in progress
    reg tx_packet_in_progress_unit;
    reg rx_packet_in_progress_unit;
    reg rx_packet_in_progress_unit_final;
    reg tx_packet_in_progress_unit_final;
    wire rx_packet_in_progress_rs;
    wire tx_packet_in_progress_top;
    
   //cf error status
    wire ingress_overflow;
    wire egress_overflow;
    wire egress_rt_gt_4s;
    wire egress_rt_neg;
    wire cf_overflow_valid;     
    
    
    //------------------------------------------------------------------------
    // Configuration
    //------------------------------------------------------------------------
    assign insert_st_adaptor        = (INSERT_ST_ADAPTOR)? 1'b1 : 1'b0;
    assign enable_tx                = (DATAPATH_OPTION == 1) || (DATAPATH_OPTION == 3)? 1'b1 : 1'b0;
    assign enable_rx                = (DATAPATH_OPTION == 2) || (DATAPATH_OPTION == 3)? 1'b1 : 1'b0;
    assign enable_tx_crc            = (INSTANTIATE_TX_CRC)? 1'b1 : 1'b0;
    assign enable_supp_addr         = (ENABLE_SUPP_ADDR)? 1'b1 : 1'b0;
    assign enable_pfc               = (ENABLE_PFC)? 1'b1 : 1'b0;
    assign enable_preamble_passthrough = (PREAMBLE_PASSTHROUGH)? 1'b1 : 1'b0;
    assign pfc_priority_num         = (ENABLE_PFC)? PFC_PRIORITY_NUMBER[3:0] : 4'h0;
    assign enable_timestamping      = (ENABLE_TIMESTAMPING)? 1'b1 : 1'b0;
    assign enable_asymmetry         = (ENABLE_ASYMMETRY)? 1'b1 : 1'b0;
    assign enable_p2p               = (ENABLE_P2P)? 1'b1 : 1'b0;
    assign enable_mem_ecc           = (ENABLE_MEM_ECC)? 1'b1 : 1'b0;
    assign enable_1g10g_mac         = (ENABLE_1G10G_MAC)? 1'b1 : 1'b0;
    assign enable_unidirectional = (ENABLE_UNIDIRECTIONAL)? 1'b1 : 1'b0;
    assign enable_txrx_datapath_n = (ENABLE_TXRX_DATAPATH)? 1'b0 : 1'b1;
    assign instantiate_statistics   = (INSTANTIATE_STATISTICS)? 1'b1 : 1'b0;
    assign register_based_statistics = (REGISTER_BASED_STATISTICS)? 1'b1 : 1'b0;
    
    //------------------------------------------------------------------------
    // Signals remapping 
    //------------------------------------------------------------------------
    assign avs_address      = csr_address;                                    
    assign avs_read         = csr_read;
    assign avs_write        = csr_write;                                        
    assign avs_writedata    = csr_writedata;                                
    assign csr_readdata     = avs_readdata;                                  
    assign csr_waitrequest  = avs_waitrequest;  

    // Case:1807980315 During underflow, the user's input could be don't care in simulation. Use valid to force the current invalid data to 0 to prevent "X" to propagate
    assign frm_sink_sop     = avalon_st_tx_startofpacket;
    assign frm_sink_eop     = avalon_st_tx_endofpacket;
    assign frm_sink_valid   = avalon_st_tx_valid;
    assign frm_sink_data    = (avalon_st_tx_valid) ? avalon_st_tx_data : 32'h0;
    assign frm_sink_empty   = (avalon_st_tx_valid) ? avalon_st_tx_empty : 2'h0;
    assign frm_sink_error   = (avalon_st_tx_valid) ? avalon_st_tx_error : 1'h0;
    assign avalon_st_tx_ready = frm_sink_ready;

    assign pause_ctrl_sink_data = avalon_st_pause_data; 
    assign pfc_ctrl_sink_data   = (ENABLE_PFC) ? avalon_st_tx_pfc_gen_data : {(PFC_PRIORITY_NUMBER*2){1'b0}};

    assign xgmii_tx_data    = rs2top_eth_xgmii_data;
    assign xgmii_tx_control = rs2top_eth_xgmii_ctrl;
    assign xgmii_tx_valid   = rs2top_eth_xgmii_valid;

    assign status_tx_datafrm_tsfr_en_sts = tx_en_n;
    assign status_rx_tsfr_sts = csr_rx_tsfr_sts;
    
    assign unidirectional_en = csr_tx_unidirectional_en;
    assign unidirectional_remote_fault_dis = csr_tx_unidirectional_remote_fault_dis;
    assign unidirectional_force_remote_fault = csr_tx_unidirectional_force_remote_fault;

    
    //------------------------------------------------------------------------
    // Ports Termination
    //------------------------------------------------------------------------
    generate
    if (ENABLE_1G10G_MAC <= 2 && ENABLE_1G10G_MAC >= 0) begin : speed_sel_int_assign
        assign speed_sel_int        = (ENABLE_1G10G_MAC == 0) ? 3'b000:                   // 10G only
                                      (ENABLE_1G10G_MAC == 1) ? {2'b0, speed_sel[0]}:    // 10G and 1G
                                      (ENABLE_1G10G_MAC == 2) ? {1'b0, speed_sel[1:0]}:   // 10G 1G 100M 10M
                                      3'b000;
    end
    else begin
        assign speed_sel_int        = speed_sel;
    end
    endgenerate

    // TX GMII
    assign gmii_tx_d                = (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 2) ? gmii_tx_d_int : 8'b0;
    assign gmii_tx_en               = (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 2) ? gmii_tx_en_int : 1'b0;
    assign gmii_tx_err              = (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 2) ? gmii_tx_err_int : 1'b0;
    
    // RX GMII
    assign gmii_rx_d_int            = (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 2) ? gmii_rx_d : 8'b0;
    assign gmii_rx_dv_int           = (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 2) ? gmii_rx_dv : 1'b0;
    assign gmii_rx_err_int          = (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 2) ? gmii_rx_err : 1'b0;
    
    // TX GMII 16b
    assign gmii16b_tx_d             = (ENABLE_GMII16B == 1) ? gmii16b_tx_d_int : 16'b0;
    assign gmii16b_tx_en            = (ENABLE_GMII16B == 1) ? gmii16b_tx_en_int : 2'b0;
    assign gmii16b_tx_err           = (ENABLE_GMII16B == 1) ? gmii16b_tx_err_int : 2'b0;
    
    // RX GMII 16b
    assign gmii16b_rx_d_int         = (ENABLE_GMII16B == 1) ? gmii16b_rx_d : 16'b0;
    assign gmii16b_rx_dv_int        = (ENABLE_GMII16B == 1) ? gmii16b_rx_dv : 2'b0;
    assign gmii16b_rx_err_int       = (ENABLE_GMII16B == 1) ? gmii16b_rx_err : 2'b0;

    // TX MII
    assign tx_clkena_int            = (ENABLE_1G10G_MAC == 2 || ENABLE_1G10G_MAC == 6 || ENABLE_1G10G_MAC == 7) ? tx_clkena :
                                      (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 4) ? 1'b1 :
                                      1'b0;
    assign tx_clkena_half_rate_int  = (ENABLE_1G10G_MAC == 2 || ENABLE_1G10G_MAC == 6 || ENABLE_1G10G_MAC == 7) ? tx_clkena_half_rate :
                                      (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 4) ? 1'b1 :
                                      1'b0;
    assign mii_tx_d                 = (ENABLE_1G10G_MAC == 2) ? mii_tx_d_int : 4'b0;
    assign mii_tx_en                = (ENABLE_1G10G_MAC == 2) ? mii_tx_en_int : 1'b0;
    assign mii_tx_err               = (ENABLE_1G10G_MAC == 2) ? mii_tx_err_int : 1'b0;
    
    // RX MII
    assign rx_clkena_int            = (ENABLE_1G10G_MAC == 2 || ENABLE_1G10G_MAC == 6 || ENABLE_1G10G_MAC == 7) ? rx_clkena :
                                      (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 4) ? 1'b1 :
                                      1'b0;
    assign rx_clkena_half_rate_int  = (ENABLE_1G10G_MAC == 2 || ENABLE_1G10G_MAC == 6 || ENABLE_1G10G_MAC == 7) ? rx_clkena_half_rate :
                                      (ENABLE_1G10G_MAC == 1 || ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 4) ? 1'b1 :
                                      1'b0;
    assign mii_rx_d_int             = (ENABLE_1G10G_MAC == 2) ? mii_rx_d : 4'b0;
    assign mii_rx_dv_int            = (ENABLE_1G10G_MAC == 2) ? mii_rx_dv : 1'b0;
    assign mii_rx_err_int           = (ENABLE_1G10G_MAC == 2) ? mii_rx_err : 1'b0;
    
    // PFC XON/XOFF Status
    assign avalon_st_tx_pfc_status_valid    = (ENABLE_PFC) ? avalon_st_tx_pfc_status_valid_int : 1'b0;
    assign avalon_st_tx_pfc_status_data     = (ENABLE_PFC) ? avalon_st_tx_pfc_status_data_int : 16'h0;
    
    assign avalon_st_rx_pfc_status_valid    = (ENABLE_PFC) ? avalon_st_rx_pfc_status_valid_int : 1'b0;
    assign avalon_st_rx_pfc_status_data     = (ENABLE_PFC) ? avalon_st_rx_pfc_status_data_int : 16'h0;
    
    assign avalon_st_rx_pfc_pause_data      = (ENABLE_PFC) ? avalon_st_rx_pfc_pause_data_int : 8'h0;
    
    // 1588
    assign tx_path_delay_10g_data_int       = (ENABLE_TIMESTAMPING) ? tx_path_delay_10g_data : 24'h0;
    assign tx_time_of_day_96b_10g_data_int  = (ENABLE_TIMESTAMPING) ? tx_time_of_day_96b_10g_data : 96'h0;
    assign tx_time_of_day_64b_10g_data_int  = (ENABLE_TIMESTAMPING) ? tx_time_of_day_64b_10g_data : 64'h0;
    
    assign tx_path_delay_1g_data_int        = (ENABLE_TIMESTAMPING) ? tx_path_delay_1g_data : 22'h0;
    assign tx_time_of_day_96b_1g_data_int   = (ENABLE_TIMESTAMPING) ? tx_time_of_day_96b_1g_data : 96'h0;
    assign tx_time_of_day_64b_1g_data_int   = (ENABLE_TIMESTAMPING) ? tx_time_of_day_64b_1g_data : 64'h0;
    
    assign rx_path_delay_10g_data_int       = (ENABLE_TIMESTAMPING) ? rx_path_delay_10g_data : 24'h0;
    assign rx_time_of_day_96b_10g_data_int  = (ENABLE_TIMESTAMPING) ? rx_time_of_day_96b_10g_data : 96'h0;
    assign rx_time_of_day_64b_10g_data_int  = (ENABLE_TIMESTAMPING) ? rx_time_of_day_64b_10g_data : 64'h0;
    
    assign rx_path_delay_1g_data_int        = (ENABLE_TIMESTAMPING) ? rx_path_delay_1g_data : 22'h0;
    assign rx_time_of_day_96b_1g_data_int   = (ENABLE_TIMESTAMPING) ? rx_time_of_day_96b_1g_data : 96'h0;
    assign rx_time_of_day_64b_1g_data_int   = (ENABLE_TIMESTAMPING) ? rx_time_of_day_64b_1g_data : 64'h0;
    
    assign tx_egress_timestamp_96b_valid        = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_96b_valid_int : 1'b0;
    assign tx_egress_timestamp_96b_data         = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_96b_data_int : 96'h0;
    assign tx_egress_timestamp_96b_fingerprint  = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_96b_fingerprint_int : {TSTAMP_FP_WIDTH{1'b0}};
    assign tx_egress_timestamp_64b_valid        = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_64b_valid_int : 1'b0;
    assign tx_egress_timestamp_64b_data         = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_64b_data_int : 64'h0;
    assign tx_egress_timestamp_64b_fingerprint  = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_64b_fingerprint_int : {TSTAMP_FP_WIDTH{1'b0}};
    
    assign rx_ingress_timestamp_96b_valid       = (ENABLE_TIMESTAMPING) ? rx_ingress_timestamp_96b_valid_int : 1'b0;
    assign rx_ingress_timestamp_96b_data        = (ENABLE_TIMESTAMPING) ? rx_ingress_timestamp_96b_data_int : 96'h0;
    assign rx_ingress_timestamp_64b_valid       = (ENABLE_TIMESTAMPING) ? rx_ingress_timestamp_64b_valid_int : 1'b0;
    assign rx_ingress_timestamp_64b_data        = (ENABLE_TIMESTAMPING) ? rx_ingress_timestamp_64b_data_int : 64'h0;
    
    // User input for 2-step operations
    assign tx_egress_timestamp_request_valid_int                = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_request_valid : 1'b0;
    assign tx_egress_timestamp_request_fingerprint_int          = (ENABLE_TIMESTAMPING) ? tx_egress_timestamp_request_fingerprint : 1'b0;
    
    // User input for 1-step operations
    assign tx_egress_p2p_update_int                             = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_egress_p2p_update : 1'b0;
    assign tx_egress_p2p_val_int                                = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_egress_p2p_val : 46'b0;
    assign tx_egress_asymmetry_update_int                       = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_egress_asymmetry_update : 1'b0;
    assign tx_etstamp_ins_ctrl_timestamp_insert_int             = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_timestamp_insert : 1'b0;
    assign tx_etstamp_ins_ctrl_timestamp_format_int             = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_timestamp_format : 1'b0;
    assign tx_etstamp_ins_ctrl_residence_time_update_int        = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_residence_time_update : 1'b0;
    assign tx_etstamp_ins_ctrl_ingress_timestamp_96b_int        = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_ingress_timestamp_96b : 96'h0;
    assign tx_etstamp_ins_ctrl_ingress_timestamp_64b_int        = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_ingress_timestamp_64b : 64'h0;
    assign tx_etstamp_ins_ctrl_residence_time_calc_format_int   = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_residence_time_calc_format : 1'b0;
    assign tx_etstamp_ins_ctrl_checksum_zero_int                = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_checksum_zero : 1'b0;
    assign tx_etstamp_ins_ctrl_checksum_correct_int             = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_checksum_correct : 1'b0;
    assign tx_etstamp_ins_ctrl_offset_timestamp_int             = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_offset_timestamp : 16'h0;
    assign tx_etstamp_ins_ctrl_offset_correction_field_int      = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_offset_correction_field : 16'h0;
    assign tx_etstamp_ins_ctrl_offset_checksum_field_int        = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_offset_checksum_field : 16'h0;
    assign tx_etstamp_ins_ctrl_offset_checksum_correction_int   = (ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP) ? tx_etstamp_ins_ctrl_offset_checksum_correction : 16'h0;
    
    
    //------------------------------------------------------------------------
    // Reserved
    //------------------------------------------------------------------------
    assign const_revision_id = 8'h00;
    assign const_mac_capability = 32'h0000;
    assign const_tx_crcctl_reserved = 1'b1;
    assign status_tx_busy = tx_packet_in_progress_unit_final;
    assign status_rx_busy = rx_packet_in_progress_unit_final;
    assign status_rx_crc_reserved = 1'b0;
    
    
    generate
        if (ENABLE_1G10G_MAC == 0) begin: speed_sel_sync
            assign speed_sel_int_sync_tx = 3'b000;
            assign speed_sel_int_sync_rx = 3'b000;
        end
        else begin
            // synchronise for tx path
            alt_em10g32_dcfifo_synchronizer_bundle #(
               .DEPTH (3),
               .WIDTH (3)
            ) speed_sel_3bits_sync_tx (
                .clk (tx_clk_sync),
                .reset_n (csr_rst_tx_clk_n),
                .din (speed_sel_int),
                .dout (speed_sel_int_sync_tx)
            );
            
            alt_em10g32_dcfifo_synchronizer_bundle #(
               .DEPTH (3),
               .WIDTH (3)
            ) speed_sel_3bits_sync_rx (
                .clk (rx_clk_sync),
                .reset_n (csr_rst_rx_clk_n),
                .din (speed_sel_int),
                .dout (speed_sel_int_sync_rx)
            );
        end
    endgenerate    
    
    always @(posedge tx_clk_sync)
        begin
        speed_sel_int_sync_tx_reg1 <= speed_sel_int_sync_tx;
        speed_sel_int_sync_tx_reg2 <= speed_sel_int_sync_tx_reg1;
    end
    
    always @(posedge rx_clk_sync)
        begin
        speed_sel_int_sync_rx_reg1 <= speed_sel_int_sync_rx;
        speed_sel_int_sync_rx_reg2 <= speed_sel_int_sync_rx_reg1;
    end

    //------------------------------------------------------------------------
    // TX path
    //------------------------------------------------------------------------
    generate 
        if ((DATAPATH_OPTION == 1) || (DATAPATH_OPTION == 3)) begin : tx_path
            alt_em10g32_tx_top #(
                .DEVICE_FAMILY      (DEVICE_FAMILY),
                .ENABLE_PFC         (ENABLE_PFC),
                .PFC_PRIORITY_NUM   (PFC_PRIORITY_NUMBER),
                .INSTANTIATE_TX_CRC (INSTANTIATE_TX_CRC),
                .ENABLE_TIMESTAMPING(ENABLE_TIMESTAMPING),
                .ENABLE_PTP_1STEP   (ENABLE_PTP_1STEP),
                .ENABLE_UNIDIRECTIONAL(ENABLE_UNIDIRECTIONAL),
                .ENABLE_1G10G_MAC   (ENABLE_1G10G_MAC),
                .ENABLE_10GBASER_REG_MODE    (ENABLE_10GBASER_REG_MODE),
                .ENABLE_XGMII       (ENABLE_XGMII),
                .ENABLE_GMII16B     (ENABLE_GMII16B),
                .TSTAMP_FP_WIDTH    (TSTAMP_FP_WIDTH),
                .TXDATAWIDTH        (DATAWIDTH),
                .TXEMPTYWIDTH       (EMPTYWIDTH),
                .TXUSRERRWIDTH      (TXUSRERRWIDTH),
                .LINK_FAULT_DATAWIDTH (LINK_FAULT_DATAWIDTH),
                .TX_XGMII_ADAPTER_PATH_DELAY (TX_XGMII_ADAPTER_PATH_DELAY),
                .ENABLE_MEM_ECC     (ENABLE_MEM_ECC),
                .FORWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
                .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
                .TIME_OF_DAY_FORMAT  (TIME_OF_DAY_FORMAT),
                .PREAMBLE_PASSTHROUGH(PREAMBLE_PASSTHROUGH),
                .DEBUG          (DEBUG),
                .SYNC_RESET_N   (SYNC_RESET_N) 
            ) tx_top_inst (

                // Clock and reset
                .clk    (tx_clk_sync),
                .rst_n  (tx_rst_n_sync),

                // CSR control path
                .csr_tx_mac_sa_ovrd_en      (csr_tx_mac_sa_ovrd_en   ),
                .csr_tx_mac_sa              (csr_tx_mac_sa           ),
                .csr_tx_tsfr_en_n           (csr_tx_tsfr_en_n        ),
                .csr_tx_preamble_passthru   (csr_tx_preamble_passthru),
                .csr_tx_pad_insrt_en        (csr_tx_pad_insrt_en     ),
                .csr_tx_crc_inst_en         (csr_tx_crc_insrt_en),
                .csr_tx_max_datafrmlen      (csr_tx_max_frmlen),
                .csr_txvlandet_dis          (csr_txvlandet_dis),

                .csr_tx_pause_en            (csr_tx_pause_en           ),
                .csr_tx_pause_xonxoff_valid (csr_tx_pause_xonxoff_ctrl_valid),// TMP
                .csr_tx_pause_xonxoff_ctrl  (csr_tx_pause_xonxoff_ctrl ),
                .csr_tx_pause_pq            (csr_tx_pause_pq           ),
                .csr_tx_pause_select        (csr_tx_pausefrm_policy[0] ),
                .csr_tx_pause_holdoff_pq    (csr_tx_pause_holdoff_pq   ),
                
                .csr_tx_pfc0_en             (csr_tx_pfc0_en),
                .csr_tx_pfc0_pqt            (csr_tx_pfc0_pqt),
                .csr_tx_pfc0_hqt            (csr_tx_pfc0_xoff_hqt),
                                                           
                .csr_tx_pfc1_en             (csr_tx_pfc1_en),
                .csr_tx_pfc1_pqt            (csr_tx_pfc1_pqt),
                .csr_tx_pfc1_hqt            (csr_tx_pfc1_xoff_hqt),
                                                           
                .csr_tx_pfc2_en             (csr_tx_pfc2_en),
                .csr_tx_pfc2_pqt            (csr_tx_pfc2_pqt),
                .csr_tx_pfc2_hqt            (csr_tx_pfc2_xoff_hqt),
                                                           
                .csr_tx_pfc3_en             (csr_tx_pfc3_en),
                .csr_tx_pfc3_pqt            (csr_tx_pfc3_pqt),
                .csr_tx_pfc3_hqt            (csr_tx_pfc3_xoff_hqt),
                                                           
                .csr_tx_pfc4_en             (csr_tx_pfc4_en),
                .csr_tx_pfc4_pqt            (csr_tx_pfc4_pqt),
                .csr_tx_pfc4_hqt            (csr_tx_pfc4_xoff_hqt),
                                                           
                .csr_tx_pfc5_en             (csr_tx_pfc5_en),
                .csr_tx_pfc5_pqt            (csr_tx_pfc5_pqt),
                .csr_tx_pfc5_hqt            (csr_tx_pfc5_xoff_hqt),
                                                           
                .csr_tx_pfc6_en             (csr_tx_pfc6_en),
                .csr_tx_pfc6_pqt            (csr_tx_pfc6_pqt),
                .csr_tx_pfc6_hqt            (csr_tx_pfc6_xoff_hqt),
                                                           
                .csr_tx_pfc7_en             (csr_tx_pfc7_en),
                .csr_tx_pfc7_pqt            (csr_tx_pfc7_pqt),
                .csr_tx_pfc7_hqt            (csr_tx_pfc7_xoff_hqt),
                
                .csr_tx_unidirectional_en   (csr_tx_unidirectional_en),
                .csr_tx_unidirectional_remote_fault_dis (csr_tx_unidirectional_remote_fault_dis),
                .csr_tx_unidirectional_force_remote_fault (csr_tx_unidirectional_force_remote_fault),
                
                .csr_tx_pause_status        (csr_tx_pause_xonxoff_ctrl_clr),
                .csr_tx_backpressure_status (csr_tx_backpressure_status),
                
                .csr_adjust_10g             ({csr_tx_adj_ns_10g, csr_tx_adj_fracns_10g}),
                .csr_period_10g             (csr_tx_period_10g),
                .csr_adjust_1g              ({csr_tx_adj_ns_1g, csr_tx_adj_fracns_1g}),
                .csr_period_1g              (csr_tx_period_1g),
                .csr_asymmetry              (csr_tx_asymmetry),
                .csr_p2p_dir_egress         (csr_p2p_dir_egress),

                // Av-ST pause control path
                .pause_ctrl_sink_data       (pause_ctrl_sink_data),
                .pfc_ctrl_sink_data         (pfc_ctrl_sink_data),
                
                // Av-ST sink data path
                .frm_sink_sop               (frm_sink_sop  ),
                .frm_sink_eop               (frm_sink_eop  ),
                .frm_sink_valid             (frm_sink_valid),
                .frm_sink_data              (frm_sink_data ),
                .frm_sink_empty             (frm_sink_empty),
                .frm_sink_error             (frm_sink_error),
                .frm_sink_ready             (frm_sink_ready),

                // TX RS layer in/out ports
                .rx_link_fault_status       (rx_link_fault_status),
                .rs2top_eth_xgmii_data      (rs2top_eth_xgmii_data),
                .rs2top_eth_xgmii_ctrl      (rs2top_eth_xgmii_ctrl), 
                .rs2top_eth_xgmii_valid     (rs2top_eth_xgmii_valid),

                // Speed selection
                .speed_sel                  (speed_sel_int_sync_tx_reg2),

                // Flow control
                .rx2flc_pause_field_valid   (rx2flc_pause_field_valid),
                .rx2flc_pause_pq            (rx2flc_pause_pq),

                // input and output ports for GMII/MII interface
                // clock and reset for GMII interface only
                .clock_gmii                 (gmii_tx_clk_sync),
                .reset_gmii_n               (gmii_tx_rst_n_sync),
    
                // gmii interface
                .gmii_source_data           (gmii_tx_d_int),
                .gmii_source_control        (gmii_tx_en_int),
                .gmii_source_error          (gmii_tx_err_int),
                
                // GMII 16 bit Transmit
                .gmii16b_tx_d               (gmii16b_tx_d_int),
                .gmii16b_tx_en              (gmii16b_tx_en_int),
                .gmii16b_tx_err             (gmii16b_tx_err_int),   

                // mii interface
                .mii_source_data            (mii_tx_d_int),
                .mii_source_control         (mii_tx_en_int),
                .mii_source_error           (mii_tx_err_int),
  
                // clock enable to use for GMII/MII
                .tx_clkena                  (tx_clkena_int),
                .tx_clkena_half_rate        (tx_clkena_half_rate_int),

                // Frame Info (User Logic)
                .user_txstatus_valid        (avalon_st_txstatus_valid),
                .user_txstatus_data         (avalon_st_txstatus_data),
                .user_txstatus_error        (avalon_st_txstatus_error),

                // Frame Info (Stat Logic)
                .stat_txstatus_valid        (tx_stat_valid),
                .stat_txstatus_data         (tx_stat_data),
                .stat_txstatus_error        (tx_stat_error),

                // PFC XON/XOFF Status
                .pfc_xonxoff_status_valid   (avalon_st_tx_pfc_status_valid_int),
                .pfc_xonxoff_status_data    (avalon_st_tx_pfc_status_data_int),
 
                // Underflow
                .tx_undrflw_pulse           (pulse_tx_udf_errcnt),
                
                // Unidirectional enablement
                .enable_unidirectional      (enable_unidirectional),
 
                // input to control ipg
                .ipg_value_10g              (tx_pipg_10g_dic),
                .ipg_value_1g               (tx_pipg_1g_fixed), // CSR register is 8-bits wide, but data path use only 5-bits
 
                // 1588
                .tx_path_delay_10g_data         (tx_path_delay_10g_data_int),
                .tx_time_of_day_96b_10g_data    (tx_time_of_day_96b_10g_data_int),
                .tx_time_of_day_64b_10g_data    (tx_time_of_day_64b_10g_data_int),
                
                .tx_path_delay_1g_data          (tx_path_delay_1g_data_int),
                .tx_time_of_day_96b_1g_data     (tx_time_of_day_96b_1g_data_int),
                .tx_time_of_day_64b_1g_data     (tx_time_of_day_64b_1g_data_int),
                
                .tx_egress_timestamp_96b_valid          (tx_egress_timestamp_96b_valid_int),
                .tx_egress_timestamp_96b_data           (tx_egress_timestamp_96b_data_int),
                .tx_egress_timestamp_96b_fingerprint    (tx_egress_timestamp_96b_fingerprint_int),
                .tx_egress_timestamp_64b_valid          (tx_egress_timestamp_64b_valid_int),
                .tx_egress_timestamp_64b_data           (tx_egress_timestamp_64b_data_int),
                .tx_egress_timestamp_64b_fingerprint    (tx_egress_timestamp_64b_fingerprint_int),
                
                .tx_egress_p2p_update                           (tx_egress_p2p_update_int),
                .tx_egress_p2p_val                              (tx_egress_p2p_val_int),
                .tx_egress_asymmetry_update                     (tx_egress_asymmetry_update_int),
                .tx_egress_timestamp_request_valid              (tx_egress_timestamp_request_valid_int),
                .tx_egress_timestamp_request_fingerprint        (tx_egress_timestamp_request_fingerprint_int),
                .tx_etstamp_ins_ctrl_timestamp_insert           (tx_etstamp_ins_ctrl_timestamp_insert_int),
                .tx_etstamp_ins_ctrl_timestamp_format           (tx_etstamp_ins_ctrl_timestamp_format_int),   
                .tx_etstamp_ins_ctrl_residence_time_update      (tx_etstamp_ins_ctrl_residence_time_update_int),
                .tx_etstamp_ins_ctrl_ingress_timestamp_96b      (tx_etstamp_ins_ctrl_ingress_timestamp_96b_int),
                .tx_etstamp_ins_ctrl_ingress_timestamp_64b      (tx_etstamp_ins_ctrl_ingress_timestamp_64b_int),
                .tx_etstamp_ins_ctrl_residence_time_calc_format (tx_etstamp_ins_ctrl_residence_time_calc_format_int),
                .tx_etstamp_ins_ctrl_checksum_zero              (tx_etstamp_ins_ctrl_checksum_zero_int),
                .tx_etstamp_ins_ctrl_checksum_correct           (tx_etstamp_ins_ctrl_checksum_correct_int),
                .tx_etstamp_ins_ctrl_offset_timestamp           (tx_etstamp_ins_ctrl_offset_timestamp_int),
                .tx_etstamp_ins_ctrl_offset_correction_field    (tx_etstamp_ins_ctrl_offset_correction_field_int),
                .tx_etstamp_ins_ctrl_offset_checksum_field      (tx_etstamp_ins_ctrl_offset_checksum_field_int),
                .tx_etstamp_ins_ctrl_offset_checksum_correction (tx_etstamp_ins_ctrl_offset_checksum_correction_int),
                
                // ECC status
                .tx_gmii_encoder_ecc_err_corrected (tx_gmii_encoder_ecc_err_corrected),
                .tx_gmii_encoder_ecc_err_fatal     (tx_gmii_encoder_ecc_err_fatal),
                .tx_ptp_request_control_ecc_err_corrected (tx_ptp_request_control_ecc_err_corrected),
                .tx_ptp_request_control_ecc_err_fatal     (tx_ptp_request_control_ecc_err_fatal),
                
                // busy bit status
                .tx_packet_in_progress_top                (tx_packet_in_progress_top),

                // Debug
                .dbg_tx_data_frm_gen_fifo_overflow(),
                //.dbg_tx_data_frm_gen_fifo_underflow(),
                .dbg_tx_pfc_trans_in_progress(),
                .dbg_tx_pause_trans_in_progress(),
                
                //cf error status
                .ingress_overflow                               (ingress_overflow),
                .egress_overflow                                (egress_overflow),
                .egress_rt_gt_4s                                (egress_rt_gt_4s),
                .egress_rt_neg                                  (egress_rt_neg),
                .cf_overflow_valid                              (cf_overflow_valid)
                
                );
        end

        if (DATAPATH_OPTION == 1) begin : tx_only_link_status
            assign rx_link_fault_status     = link_fault_status_xgmii_tx_data;
            assign rx2flc_pause_field_valid = avalon_st_tx_pause_length_valid;
            assign rx2flc_pause_pq          = avalon_st_tx_pause_length_data;
        end
        else if (DATAPATH_OPTION == 3) begin : tx_rx_link_status
            assign rx_link_fault_status     = rx_link_fault_status_tx_clk;
            assign rx2flc_pause_field_valid = avalon_st_rx_pause_length_valid_tx_clk;
            assign rx2flc_pause_pq          = avalon_st_rx_pause_length_data_tx_clk;
        end
        else begin
            assign rx_link_fault_status     = 2'b0;
            assign rx2flc_pause_field_valid = 1'b0;
            assign rx2flc_pause_pq          = 16'h0;
        end

    endgenerate
    
    
    //------------------------------------------------------------------------
    // RX path
    //------------------------------------------------------------------------
    generate 
        if ((DATAPATH_OPTION == 2) || (DATAPATH_OPTION == 3)) begin : rx_path
            alt_em10g32_rx_top # (
                .DEVICE_FAMILY                  (DEVICE_FAMILY),
                .RX_XGMII_ADAPTER_PATH_DELAY    (RX_XGMII_ADAPTER_PATH_DELAY),
                .ENABLE_TIMESTAMPING            (ENABLE_TIMESTAMPING),
                .ENABLE_10GBASER_REG_MODE       (ENABLE_10GBASER_REG_MODE),
                .ENABLE_1G10G_MAC               (ENABLE_1G10G_MAC),
                .ENABLE_GMII16B                 (ENABLE_GMII16B),
                .FORWARD_SYNC_DEPTH             (SYNCHRONIZER_DEPTH),
                .BACKWARD_SYNC_DEPTH            (SYNCHRONIZER_DEPTH),
                .ENABLE_MEM_ECC                 (ENABLE_MEM_ECC),
                .SYNC_RESET_N                   (SYNC_RESET_N) 
            ) rx_top_inst (
                
                // Parameter
                .enable_preamble_passthrough    (enable_preamble_passthrough),
                
                // Clock & Reset
                .xgmii_rx_clk                   (rx_clk_sync),
                .xgmii_rx_rst_b                 (rx_rst_n_sync),
                
                // Configuration from CSR
                .csr_rx_tsfr_en_n               (csr_rx_tsfr_en_n),
                .csr_rx_tsfr_sts                (csr_rx_tsfr_sts),
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
                .csr_rx_ignore_pausefrm         (csr_rx_ignore_pausefrm),
                .csr_rx_pfc_ignore_pausefrm_0   (csr_rx_pfc_ignore_pausefrm_0),
                .csr_rx_pfc_ignore_pausefrm_1   (csr_rx_pfc_ignore_pausefrm_1),
                .csr_rx_pfc_ignore_pausefrm_2   (csr_rx_pfc_ignore_pausefrm_2),
                .csr_rx_pfc_ignore_pausefrm_3   (csr_rx_pfc_ignore_pausefrm_3),
                .csr_rx_pfc_ignore_pausefrm_4   (csr_rx_pfc_ignore_pausefrm_4),
                .csr_rx_pfc_ignore_pausefrm_5   (csr_rx_pfc_ignore_pausefrm_5),
                .csr_rx_pfc_ignore_pausefrm_6   (csr_rx_pfc_ignore_pausefrm_6),
                .csr_rx_pfc_ignore_pausefrm_7   (csr_rx_pfc_ignore_pausefrm_7),
                .csr_rx_frm_info_user_type      (1'b0), // Set to 0 to ensure consistency with statistics interface
                .csr_rx_allucast_en             (csr_rx_allucast_en),
                .csr_rx_allmcast_en             (csr_rx_allmcast_en),
                .csr_rx_fwd_ctlfrm              (csr_rx_fwd_ctlfrm),
                .csr_rx_fwd_pausefrm            (csr_rx_fwd_pausefrm),
                .csr_rx_pfc_fwd                 (csr_rx_pfc_fwd),
                .csr_rx_crcpad_rem              (csr_rx_crcpad_rem),
                .csr_rx_preamb_fwd_ctl          (csr_rx_preamb_fwd_ctl),
                .csr_rx_preamble_passthru       (csr_rx_preamb_passthru_en),
                .csr_rx_crc_chk                 (csr_rx_crc_chk),
                .csr_adjust_10g                 ({csr_rx_adj_ns_10g, csr_rx_adj_fracns_10g}),
                .csr_period_10g                 (csr_rx_period_10g),
                .csr_adjust_1g                  ({csr_rx_adj_ns_1g, csr_rx_adj_fracns_1g}),
                .csr_period_1g                  (csr_rx_period_1g),
                
                // Frame Drop Behavior
                .frm_drop_ctrl_pfc_behavior     (enable_pfc),
                
                // Overflow Event to CSR
                .overflow_event                 (pulse_rx_pkt_ovrflw_errcnt),
                .drop_event                     (pulse_rx_pkt_ovrflw_etherstatsdropevents),
                
                // Speed Selection
                .speed_sel                      (speed_sel_int_sync_rx_reg2),
                
                // XGMII Receive
                .xgmii_rx_data                  (xgmii_rx_data),
                .xgmii_rx_ctrl                  (xgmii_rx_control),
                .xgmii_rx_valid                 (xgmii_rx_valid),
                .link_fault_status_xgmii_rx_data(link_fault_status_xgmii_rx_data),
                
                // GMII Receive
                .gmii_rx_clk                    (gmii_rx_clk_sync),
                .gmii_rx_rst_b                  (gmii_rx_rst_n_sync),
                .gmii_rx_d                      (gmii_rx_d_int),
                .gmii_rx_dv                     (gmii_rx_dv_int),
                .gmii_rx_err                    (gmii_rx_err_int),
                
                // GMII 16 bit Receive
                .gmii16b_rx_d                   (gmii16b_rx_d_int),
                .gmii16b_rx_dv                  (gmii16b_rx_dv_int),
                .gmii16b_rx_err                 (gmii16b_rx_err_int),                  

                // MII Receive
                .mii_rx_clken                   (rx_clkena_int),
                .mii_rx_clken_half_rate         (rx_clkena_half_rate_int),
                .mii_rx_d                       (mii_rx_d_int),
                .mii_rx_dv                      (mii_rx_dv_int),
                .mii_rx_err                     (mii_rx_err_int),
                
                // Avalon-ST Receive (User)
                .avalon_st_rx_data              (avalon_st_rx_data),
                .avalon_st_rx_sop               (avalon_st_rx_startofpacket),
                .avalon_st_rx_eop               (avalon_st_rx_endofpacket),
                .avalon_st_rx_valid             (avalon_st_rx_valid),
                .avalon_st_rx_empty             (avalon_st_rx_empty),
                .avalon_st_rx_error             (avalon_st_rx_error),
                .avalon_st_rx_ready             (avalon_st_rx_ready),
                
                // Frame Info (Statistics)
                .avalon_st_rx_statistics_valid  (rx_stat_valid),
                .avalon_st_rx_statistics_data   (rx_stat_data),
                .avalon_st_rx_statistics_error  (rx_stat_error),
                
                // Frame Info (User Logic)
                .avalon_st_rxstatus_valid       (avalon_st_rxstatus_valid),
                .avalon_st_rxstatus_data        (avalon_st_rxstatus_data),
                .avalon_st_rxstatus_error       (avalon_st_rxstatus_error),
                
                // Pause Quanta
                .avalon_st_rx_pause_length_valid(avalon_st_rx_pause_length_valid),
                .avalon_st_rx_pause_length_data (avalon_st_rx_pause_length_data),
                
                // PFC XON/XOFF Status
                .avalon_st_rx_pfc_status_valid  (avalon_st_rx_pfc_status_valid_int),
                .avalon_st_rx_pfc_status_data   (avalon_st_rx_pfc_status_data_int),
                
                // PFC Pause Data
                .avalon_st_rx_pfc_pause_data    (avalon_st_rx_pfc_pause_data_int),
                
                // 1588
                .rx_path_delay_10g_data         (rx_path_delay_10g_data_int),
                .rx_time_of_day_96b_10g_data    (rx_time_of_day_96b_10g_data_int),
                .rx_time_of_day_64b_10g_data    (rx_time_of_day_64b_10g_data_int),
                .rx_path_delay_1g_data          (rx_path_delay_1g_data_int),
                .rx_time_of_day_96b_1g_data     (rx_time_of_day_96b_1g_data_int),
                .rx_time_of_day_64b_1g_data     (rx_time_of_day_64b_1g_data_int),
                
                .rx_ingress_timestamp_96b_valid (rx_ingress_timestamp_96b_valid_int),
                .rx_ingress_timestamp_96b_data  (rx_ingress_timestamp_96b_data_int),
                .rx_ingress_timestamp_64b_valid (rx_ingress_timestamp_64b_valid_int),
                .rx_ingress_timestamp_64b_data  (rx_ingress_timestamp_64b_data_int),
                
                // bust bbit status
                .rx_packet_in_progress_rs       (rx_packet_in_progress_rs),
                
                // ECC Status
                .rx_gmii_decoder_ecc_err_corrected (rx_gmii_decoder_ecc_err_corrected),
                .rx_gmii_decoder_ecc_err_fatal     (rx_gmii_decoder_ecc_err_fatal),
                .rx_ptp_aligner_ecc_err_corrected  (rx_ptp_aligner_ecc_err_corrected),
                .rx_ptp_aligner_ecc_err_fatal      (rx_ptp_aligner_ecc_err_fatal)
                );
        end
    
    endgenerate
    
    
    //------------------------------------------------------------------------
    // RX path to TX path clock crossing
    //------------------------------------------------------------------------
    generate 
        if (DATAPATH_OPTION == 3) begin : rx_path_to_tx_path
            
            assign rx_link_fault_status_rx_clk_valid = rx_link_fault_status_rx_clk_ready;
            
            alt_em10g32_clock_crosser #(
                .SYMBOLS_PER_BEAT    (1),
                .BITS_PER_SYMBOL     (2),
                .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
                .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
                .USE_OUTPUT_PIPELINE (0)
            ) clock_crosser_link_fault (
                .in_clk      (rx_clk_sync),
                .in_reset_n  (rx_tx_cc_in_rst_n),
                .in_ready    (rx_link_fault_status_rx_clk_ready),
                .in_valid    (rx_link_fault_status_rx_clk_valid),
                .in_data     (link_fault_status_xgmii_rx_data),
                .out_clk     (tx_clk_sync),
                .out_reset_n (rx_tx_cc_out_rst_n),
                .out_ready   (1'b1),
                .out_valid   (rx_link_fault_status_tx_clk_valid),
                .out_data    (rx_link_fault_status_tx_clk_data)
            );
            
            always @(posedge tx_clk_sync) begin
                if(~tx_rst_n_sync) begin
                    rx_link_fault_status_tx_clk <= {LINK_FAULT_DATAWIDTH{1'b0}};
                end
                else begin
                    if(rx_link_fault_status_tx_clk_valid) begin
                        rx_link_fault_status_tx_clk <= rx_link_fault_status_tx_clk_data;
                    end
                end
            end
            
            alt_em10g32_clock_crosser #(
                .SYMBOLS_PER_BEAT    (1),
                .BITS_PER_SYMBOL     (16),
                .FORWARD_SYNC_DEPTH  (SYNCHRONIZER_DEPTH),
                .BACKWARD_SYNC_DEPTH (SYNCHRONIZER_DEPTH),
                .USE_OUTPUT_PIPELINE (0)
            ) clock_crosser_pause_quanta (
                .in_clk      (rx_clk_sync),
                .in_reset_n  (rx_tx_cc_in_rst_n),
                .in_ready    (),
                .in_valid    (avalon_st_rx_pause_length_valid),
                .in_data     (avalon_st_rx_pause_length_data),
                .out_clk     (tx_clk_sync),
                .out_reset_n (rx_tx_cc_out_rst_n),
                .out_ready   (1'b1),
                .out_valid   (avalon_st_rx_pause_length_valid_tx_clk),
                .out_data    (avalon_st_rx_pause_length_data_tx_clk)
            );
            
        end
    endgenerate
    
    
    //------------------------------------------------------------------------
    // CSR module
    //------------------------------------------------------------------------
    alt_em10g32_creg_top #(
        .DEVICE_FAMILY          (DEVICE_FAMILY),
        .ENABLE_MEM_ECC         (ENABLE_MEM_ECC),
        .INSTANTIATE_STATISTICS (INSTANTIATE_STATISTICS),
        .REGISTER_BASED_STATISTICS(REGISTER_BASED_STATISTICS),
        .SYNCHRONIZER_DEPTH     (SYNCHRONIZER_DEPTH),
        .STATISTICS_CSR_CLOCK   (STATISTICS_CSR_CLOCK),
        .SYNC_RESET_N           (SYNC_RESET_N) 
    ) creg_top_inst (
        // Clock & Reset
        .csr_clk        (csr_clk_sync),     
        .csr_clk_rst_n  (csr_rst_n_sync),
        .tx_clk         (tx_clk_sync),
        .tx_clk_rst_n   (tx_rst_n_sync),
        .rx_clk         (rx_clk_sync),
        .rx_clk_rst_n   (rx_rst_n_sync),        
        .csr_rst_tx_clk_n               (csr_rst_tx_clk_n),
        .csr_rst_rx_clk_n               (csr_rst_rx_clk_n),
        .csr_tx_cc_in_rst_n             (csr_tx_cc_in_rst_n),
        .csr_tx_cc_out_rst_n            (csr_tx_cc_out_rst_n),
        .tx_csr_cc_in_rst_n             (tx_csr_cc_in_rst_n),
        .tx_csr_cc_out_rst_n            (tx_csr_cc_out_rst_n),
        .csr_gmii_tx_cc_in_rst_n        (csr_gmii_tx_cc_in_rst_n),
        .csr_gmii_tx_cc_out_rst_n       (csr_gmii_tx_cc_out_rst_n),
        .gmii_tx_csr_cc_in_rst_n        (gmii_tx_csr_cc_in_rst_n),
        .gmii_tx_csr_cc_out_rst_n       (gmii_tx_csr_cc_out_rst_n),
        .csr_rx_cc_in_rst_n             (csr_rx_cc_in_rst_n),
        .csr_rx_cc_out_rst_n            (csr_rx_cc_out_rst_n),
        .rx_csr_cc_in_rst_n             (rx_csr_cc_in_rst_n),
        .rx_csr_cc_out_rst_n            (rx_csr_cc_out_rst_n),
        .csr_gmii_rx_cc_in_rst_n        (csr_gmii_rx_cc_in_rst_n),
        .csr_gmii_rx_cc_out_rst_n       (csr_gmii_rx_cc_out_rst_n),
        .gmii_rx_csr_cc_in_rst_n        (gmii_rx_csr_cc_in_rst_n),
        .gmii_rx_csr_cc_out_rst_n       (gmii_rx_csr_cc_out_rst_n),
        .gmii_tx_clk                    (gmii_tx_clk_sync),
        .gmii_tx_clk_rst_n              (gmii_tx_rst_n_sync),
        .gmii_rx_clk                    (gmii_rx_clk_sync),
        .gmii_rx_clk_rst_n              (gmii_rx_rst_n_sync),
        .const_revision_id              (const_revision_id),                // input, 8-bit
        .const_mac_capability           (const_mac_capability),             // input, 32-bit
        .csr_tx_mac_sa                  (csr_tx_mac_sa),                    // output, 48-bit
        .csr_rx_primaddr                (csr_rx_primaddr),                  // output, 48-bit
        .csr_tx_data_path_reset         (csr_tx_data_path_reset),           // output, 1 bit
        .csr_rx_data_path_reset         (csr_rx_data_path_reset),           // output, 1 bit
        .status_wait_request_timeout    (),                                 // output, 1 bit. purpose left dangling
        .csr_tx_tsfr_en_n               (csr_tx_tsfr_en_n),                 // output, 1-bit
        .status_tx_datafrm_tsfr_en_sts  (status_tx_datafrm_tsfr_en_sts),    // input, 1-bit
        .status_tx_busy                 (status_tx_busy),                   // input, 1-bit
        .status_tx_rst_sts              (status_tx_rst_sts),                // input, 1-bit
        .csr_tx_pad_insrt_en            (csr_tx_pad_insrt_en),              // output, 1-bit
        .const_tx_crcctl_reserved       (const_tx_crcctl_reserved),         // input, 1-bit
        .csr_tx_crc_insrt_en            (csr_tx_crc_insrt_en),              // output, 1-bit
        .csr_tx_preamble_passthru       (csr_tx_preamble_passthru),         // output, 1-bit
        .csr_tx_mac_sa_ovrd_en          (csr_tx_mac_sa_ovrd_en),            // output, 1-bit
        .csr_tx_max_frmlen              (csr_tx_max_frmlen),                // output, 16-bit
        .csr_txvlandet_dis              (csr_txvlandet_dis),                // output, 1-bit
        .tx_pipg_10g_dic                (tx_pipg_10g_dic),                  // output, 8-bit
        .tx_pipg_1g_fixed               (tx_pipg_1g_fixed),                 // output, 8-bit
        .pulse_tx_udf_errcnt            (pulse_tx_udf_errcnt),              // input, 1-bit
        .csr_tx_pause_xonxoff_ctrl      (csr_tx_pause_xonxoff_ctrl),        // output, 2-bit
        .csr_tx_pause_xonxoff_ctrl_valid(csr_tx_pause_xonxoff_ctrl_valid),  // output, 1-bit
        .csr_tx_pause_xonxoff_ctrl_clr  (csr_tx_pause_xonxoff_ctrl_clr),    // input, 1-bit
        .csr_tx_pause_pqt               (csr_tx_pause_pq),                  // output, 16-bit
        .csr_tx_pause_hqt               (csr_tx_pause_holdoff_pq),          // output, 16-bit
        .csr_tx_pause_en                (csr_tx_pause_en),                  // output, 1-bit
        .csr_tx_pausefrm_policy         (csr_tx_pausefrm_policy),           // output, 2-bit
        .csr_tx_pfc0_en                 (csr_tx_pfc0_en),                   // output, 1-bit
        .csr_tx_pfc1_en                 (csr_tx_pfc1_en),                   // output, 1-bit
        .csr_tx_pfc2_en                 (csr_tx_pfc2_en),                   // output, 1-bit
        .csr_tx_pfc3_en                 (csr_tx_pfc3_en),                   // output, 1-bit
        .csr_tx_pfc4_en                 (csr_tx_pfc4_en),                   // output, 1-bit
        .csr_tx_pfc5_en                 (csr_tx_pfc5_en),                   // output, 1-bit
        .csr_tx_pfc6_en                 (csr_tx_pfc6_en),                   // output, 1-bit
        .csr_tx_pfc7_en                 (csr_tx_pfc7_en),                   // output, 1-bit
        .csr_tx_pfc0_pqt                (csr_tx_pfc0_pqt),                  // output, 16-bit
        .csr_tx_pfc1_pqt                (csr_tx_pfc1_pqt),                  // output, 16-bit
        .csr_tx_pfc2_pqt                (csr_tx_pfc2_pqt),                  // output, 16-bit
        .csr_tx_pfc3_pqt                (csr_tx_pfc3_pqt),                  // output, 16-bit
        .csr_tx_pfc4_pqt                (csr_tx_pfc4_pqt),                  // output, 16-bit
        .csr_tx_pfc5_pqt                (csr_tx_pfc5_pqt),                  // output, 16-bit
        .csr_tx_pfc6_pqt                (csr_tx_pfc6_pqt),                  // output, 16-bit
        .csr_tx_pfc7_pqt                (csr_tx_pfc7_pqt),                  // output, 16-bit
        .csr_tx_pfc0_xoff_hqt           (csr_tx_pfc0_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc1_xoff_hqt           (csr_tx_pfc1_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc2_xoff_hqt           (csr_tx_pfc2_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc3_xoff_hqt           (csr_tx_pfc3_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc4_xoff_hqt           (csr_tx_pfc4_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc5_xoff_hqt           (csr_tx_pfc5_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc6_xoff_hqt           (csr_tx_pfc6_xoff_hqt),             // output, 16-bit
        .csr_tx_pfc7_xoff_hqt           (csr_tx_pfc7_xoff_hqt),             // output, 16-bit
        .csr_tx_unidirectional_en       (csr_tx_unidirectional_en),         // output, 1-bit
        .csr_tx_unidirectional_remote_fault_dis(csr_tx_unidirectional_remote_fault_dis), // output, 1-bit
        .csr_tx_unidirectional_force_remote_fault(csr_tx_unidirectional_force_remote_fault), // output, 1-bit
        .csr_rx_tsfr_en_n               (csr_rx_tsfr_en_n),                 // output, 1-bit
        .status_rx_tsfr_sts             (status_rx_tsfr_sts),               // input, 1-bit
        .status_rx_busy                 (status_rx_busy),                   // input, 1-bit
        .status_rx_rst_sts              (status_rx_rst_sts),                // input, 1-bit
        .csr_rx_crcpad_rem              (csr_rx_crcpad_rem),                // output, 2-bit
        .status_rx_crc_reserved         (status_rx_crc_reserved),           // input, 1-bit
        .csr_rx_crc_chk                 (csr_rx_crc_chk),                   // output, 1-bit
        .csr_rx_preamb_fwd_ctl          (csr_rx_preamb_fwd_ctl),            // output, 1-bit
        .csr_rx_preamb_passthru_en      (csr_rx_preamb_passthru_en),        // output, 1-bit
        .csr_rx_allucast_en             (csr_rx_allucast_en),               // output, 1-bit
        .csr_rx_allmcast_en             (csr_rx_allmcast_en),               // output, 1-bit
        .csr_rx_fwd_ctlfrm              (csr_rx_fwd_ctlfrm),                // output, 1-bit
        .csr_rx_fwd_pausefrm            (csr_rx_fwd_pausefrm),              // output, 1-bit
        .csr_rx_ignore_pausefrm         (csr_rx_ignore_pausefrm),           // output, 1-bit
        .csr_rx_suppaddr_en0            (csr_rx_suppaddr_en0),              // output, 1-bit
        .csr_rx_suppaddr_en1            (csr_rx_suppaddr_en1),              // output, 1-bit
        .csr_rx_suppaddr_en2            (csr_rx_suppaddr_en2),              // output, 1-bit
        .csr_rx_suppaddr_en3            (csr_rx_suppaddr_en3),              // output, 1-bit
        .csr_rx_max_datafrmlen          (csr_rx_max_datafrmlen),            // output, 16-bit
        .csr_rxvlandet_dis              (csr_rxvlandet_dis),                // output, 1-bit
        .csr_rx_supp_macaddr_0          (csr_rx_supp_macaddr_0),            // output, 48-bit
        .csr_rx_supp_macaddr_1          (csr_rx_supp_macaddr_1),            // output, 48-bit
        .csr_rx_supp_macaddr_2          (csr_rx_supp_macaddr_2),            // output, 48-bit
        .csr_rx_supp_macaddr_3          (csr_rx_supp_macaddr_3),            // output, 48-bit
        .csr_rx_pfc_ignore_pausefrm_0   (csr_rx_pfc_ignore_pausefrm_0),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_1   (csr_rx_pfc_ignore_pausefrm_1),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_2   (csr_rx_pfc_ignore_pausefrm_2),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_3   (csr_rx_pfc_ignore_pausefrm_3),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_4   (csr_rx_pfc_ignore_pausefrm_4),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_5   (csr_rx_pfc_ignore_pausefrm_5),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_6   (csr_rx_pfc_ignore_pausefrm_6),     // output, 1-bit
        .csr_rx_pfc_ignore_pausefrm_7   (csr_rx_pfc_ignore_pausefrm_7),     // output, 1-bit
        .csr_rx_pfc_fwd                 (csr_rx_pfc_fwd),                   // output, 1-bit
        .pulse_rx_pkt_ovrflw_errcnt     (pulse_rx_pkt_ovrflw_errcnt),       // input, 1-bit
        .pulse_rx_pkt_ovrflw_etherstatsdropevents(pulse_rx_pkt_ovrflw_etherstatsdropevents),    // input, 1-bit
        .csr_tx_period_10g              (csr_tx_period_10g),                // output, 20-bit
        .csr_tx_adj_fracns_10g          (csr_tx_adj_fracns_10g),            // output, 16-bit
        .csr_tx_adj_ns_10g              (csr_tx_adj_ns_10g),                // output, 16-bit
        .csr_tx_asymmetry               (csr_tx_asymmetry),                // output, 19-bit
        .csr_tx_p2p_dir_egress          (csr_p2p_dir_egress),               // output, 1-bit
        .cf_overflow_ingress_status     (/*NC*/),
        .cf_overflow_egress_status      (/*NC*/),
        .cf_rt_gt_eq_4s_status          (/*NC*/),
        .cf_rt_neg_status               (/*NC*/),        
        .csr_rx_p2p_val_valid           (rx_ingress_p2p_val_valid),         // output, 1-bit
        .csr_rx_p2p_val_ns              (rx_ingress_p2p_val[45:16]),        // output, 46-bit
        .csr_rx_p2p_val_fns             (rx_ingress_p2p_val[15:0]),         // output, 46-bit
        .csr_tx_period_1g               (csr_tx_period_1g),                 // output, 20-bit
        .csr_tx_adj_fracns_1g           (csr_tx_adj_fracns_1g),             // output, 16-bit
        .csr_tx_adj_ns_1g               (csr_tx_adj_ns_1g),                 // output, 16-bit
        .csr_rx_period_10g              (csr_rx_period_10g),                // output, 20-bit
        .csr_rx_adj_fracns_10g          (csr_rx_adj_fracns_10g),            // output, 16-bit
        .csr_rx_adj_ns_10g              (csr_rx_adj_ns_10g),                // output, 16-bit
        .csr_rx_period_1g               (csr_rx_period_1g),                 // output, 20-bit
        .csr_rx_adj_fracns_1g           (csr_rx_adj_fracns_1g),             // output, 16-bit
        .csr_rx_adj_ns_1g               (csr_rx_adj_ns_1g),                 // output, 16-bit
        .ecc_corrected_err_status       (ecc_corrected_err_status),         // output, 1-bit
        .ecc_fatal_err_status           (ecc_fatal_err_status),             // output, 1-bit
        .ecc_corrected_err_status_ena   (ecc_corrected_err_status_ena),     // output, 1-bit
        .ecc_fatal_err_status_ena       (ecc_fatal_err_status_ena),         // output, 1-bit
        
        // CF Error Status
        .ingress_overflow               (ingress_overflow),                 // input, 1-bit
        .egress_overflow                (egress_overflow),                  // input, 1-bit
        .egress_rt_gt_4s                (egress_rt_gt_4s),                  // input, 1-bit
        .egress_rt_neg                  (egress_rt_neg),                    // input, 1-bit
        .cf_overflow_valid              (cf_overflow_valid),                // input, 1-bit         

        // Avalon-MM Slave
        .avs_address    (avs_address),                                  // input, 9-bit
        .avs_read       (avs_read),                                     // input, 1-bit
        .avs_write      (avs_write),                                    // input, 1-bit
        .avs_writedata  (avs_writedata),                                // input, 32-bit
        .avs_readdata   (avs_readdata),                                 // output, 32-bit
        .avs_waitrequest(avs_waitrequest),                              // output, 1-bit

        // From Frame Decoders to Statistics
        .tx_stat_valid  (tx_stat_valid),
        .tx_stat_data   (tx_stat_data),
        .tx_stat_error  (tx_stat_error),
        .rx_stat_valid  (rx_stat_valid),
        .rx_stat_data   (rx_stat_data),
        .rx_stat_error  (rx_stat_error),

        // ECC Status
        .tx_gmii_encoder_ecc_err_corrected (tx_gmii_encoder_ecc_err_corrected),
        .tx_gmii_encoder_ecc_err_fatal     (tx_gmii_encoder_ecc_err_fatal),
        .rx_gmii_decoder_ecc_err_corrected (rx_gmii_decoder_ecc_err_corrected),
        .rx_gmii_decoder_ecc_err_fatal     (rx_gmii_decoder_ecc_err_fatal),
        .tx_ptp_request_control_ecc_err_corrected (tx_ptp_request_control_ecc_err_corrected),
        .tx_ptp_request_control_ecc_err_fatal     (tx_ptp_request_control_ecc_err_fatal),
        .rx_ptp_aligner_ecc_err_corrected         (rx_ptp_aligner_ecc_err_corrected),
        .rx_ptp_aligner_ecc_err_fatal             (rx_ptp_aligner_ecc_err_fatal),
        
        // Test Mode
        .csr_tx_adptdcff_rdwtrmrk_dis       (csr_tx_adptdcff_rdwtrmrk_dis),
        .csr_tx_adptdcff_rdwtrmrk           (csr_tx_adptdcff_rdwtrmrk),
        .csr_tx_adptdcff_vldpkt_minwt       (csr_tx_adptdcff_vldpkt_minwt),
        
        // Parameters
        .insert_st_adaptor          (insert_st_adaptor),                // input, 1-bit
        .enable_tx                  (enable_tx),                        // input, 1-bit
        .enable_rx                  (enable_rx),                        // input, 1-bit
        .enable_tx_crc              (enable_tx_crc),                    // input, 1-bit
        .enable_supp_addr           (enable_supp_addr),                 // input, 1-bit
        .enable_pfc                 (enable_pfc),                       // input, 1-bit
        .enable_preamble_passthrough(enable_preamble_passthrough),      // input, 1-bit
        .pfc_priority_num           (pfc_priority_num),                 // input, 4-bit
        .enable_timestamping        (enable_timestamping),              // input, 1-bit
        .enable_asymmetry           (enable_asymmetry),                 // input, 1-bit
        .enable_p2p                 (enable_p2p),                       // input, 1-bit
        .enable_mem_ecc             (enable_mem_ecc),                   // input, 1-bit
        .enable_1g10g_mac           (enable_1g10g_mac),                 // input, 1-bit
        .enable_unidirectional      (enable_unidirectional),            // input, 1-bit
        .enable_txrx_datapath_n       (enable_txrx_datapath_n),             // input, 1-bit
        .instantiate_statistics     (instantiate_statistics),
        .register_based_statistics  (register_based_statistics)
    );

    // ECC Status Output
    assign ecc_err_det_corr = enable_mem_ecc & ecc_corrected_err_status & ecc_corrected_err_status_ena;
    assign ecc_err_det_uncorr = enable_mem_ecc & ecc_fatal_err_status & ecc_fatal_err_status_ena;
    
    // packet in progress should asserted when disable tx path and there is still got packet. 
    always @ (posedge tx_clk_sync)
        begin
        if(!tx_rst_n_sync)
            begin
            tx_packet_in_progress_unit <= 1'b0;
            end
        else
            begin
            // tx enable
            if(!csr_tx_tsfr_en_n)
                begin
                tx_packet_in_progress_unit <= 1'b0;
                end
            // tx disable    
            else
                begin
                if(tx_en)
                    begin
                    tx_packet_in_progress_unit <= 1'b1;
                    end
                else
                    begin
                    tx_packet_in_progress_unit <= 1'b0;
                    end
                end
            end
        end
        
    always @ (posedge tx_clk_sync)
        begin
        if(!tx_rst_n_sync)
            begin
            tx_packet_in_progress_unit_final <= 1'b0;
            end    
        else
            begin
            tx_packet_in_progress_unit_final <= tx_packet_in_progress_unit | tx_packet_in_progress_top;
            end 
		end    
        
    // packet in progress for RX
    always @ (posedge rx_clk_sync)
        begin
        if(!rx_rst_n_sync)
            begin
            rx_packet_in_progress_unit <= 1'b0;
            end    
        else
            begin
            if(avalon_st_rx_startofpacket && avalon_st_rx_valid && avalon_st_rx_ready)
                begin
                rx_packet_in_progress_unit <= 1'b1;
                end
            else if (avalon_st_rx_endofpacket && avalon_st_rx_valid && avalon_st_rx_ready) 
                begin
                rx_packet_in_progress_unit <= 1'b0;
                end
            end
		end
            
    always @ (posedge rx_clk_sync)
        begin
        if(!rx_rst_n_sync)
            begin
            rx_packet_in_progress_unit_final <= 1'b0;
            end    
        else
            begin
            rx_packet_in_progress_unit_final <= rx_packet_in_progress_unit | rx_packet_in_progress_rs;
            end 
		end
        
    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1; 
            end
        end
    endfunction



endmodule


