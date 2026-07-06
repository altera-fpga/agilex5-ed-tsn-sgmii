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
// Module: Altera Ethernet MAC 32-bit TX TOP
//
// Description: 
//  * Transmit path
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module alt_em10g32_tx_top #(
    parameter DEVICE_FAMILY         = "Stratix V",
    parameter ENABLE_PFC            = 0,
    parameter PFC_PRIORITY_NUM      = 8,
    parameter INSTANTIATE_TX_CRC    = 1,
    
    parameter ENABLE_TIMESTAMPING   = 0,
    parameter ENABLE_PTP_1STEP      = 0,
    parameter TSTAMP_FP_WIDTH       = 4,
    parameter TX_XGMII_ADAPTER_PATH_DELAY = 0,    

    parameter TXDATAWIDTH           = 32,
    parameter TXEMPTYWIDTH          = 2,
    parameter TXUSRERRWIDTH         = 1,

    parameter LINK_FAULT_DATAWIDTH  = 2,
    parameter ENABLE_UNIDIRECTIONAL = 0,
    parameter ENABLE_1G10G_MAC      = 0,
    parameter ENABLE_10GBASER_REG_MODE       = 0,
    parameter ENABLE_XGMII          = 1,
    parameter ENABLE_GMII16B        = 0,
    parameter FORWARD_SYNC_DEPTH    = 3,
    parameter BACKWARD_SYNC_DEPTH   = 3,

    parameter ENABLE_MEM_ECC        = 0,
    parameter TIME_OF_DAY_FORMAT    = 2,
    parameter PREAMBLE_PASSTHROUGH  = 0,

    parameter DEBUG                 = 0,
    parameter SYNC_RESET_N          = 1
) (

    // Clock and reset
    input wire clk,
    input wire rst_n,

    // CSR control path
    input wire          csr_tx_mac_sa_ovrd_en,
    input wire [47:0]   csr_tx_mac_sa,
    input wire          csr_tx_tsfr_en_n,
    input wire          csr_tx_preamble_passthru,
    input wire          csr_tx_pad_insrt_en,
    input wire          csr_tx_crc_inst_en,
    input wire [15:0]   csr_tx_max_datafrmlen,
    input wire          csr_txvlandet_dis,

    input wire          csr_tx_pause_en,
    input wire          csr_tx_pause_xonxoff_valid,
    input wire [1:0]    csr_tx_pause_xonxoff_ctrl,
    input wire [15:0]   csr_tx_pause_pq,
    input wire          csr_tx_pause_select,
    input wire [15:0]   csr_tx_pause_holdoff_pq,

    input wire          csr_tx_pfc0_en,
    input wire [15:0]   csr_tx_pfc0_pqt,
    input wire [15:0]   csr_tx_pfc0_hqt,

    input wire          csr_tx_pfc1_en,
    input wire [15:0]   csr_tx_pfc1_pqt,
    input wire [15:0]   csr_tx_pfc1_hqt,

    input wire          csr_tx_pfc2_en,
    input wire [15:0]   csr_tx_pfc2_pqt,
    input wire [15:0]   csr_tx_pfc2_hqt,

    input wire          csr_tx_pfc3_en,
    input wire [15:0]   csr_tx_pfc3_pqt,
    input wire [15:0]   csr_tx_pfc3_hqt,

    input wire          csr_tx_pfc4_en,
    input wire [15:0]   csr_tx_pfc4_pqt,
    input wire [15:0]   csr_tx_pfc4_hqt,

    input wire          csr_tx_pfc5_en,
    input wire [15:0]   csr_tx_pfc5_pqt,
    input wire [15:0]   csr_tx_pfc5_hqt,

    input wire          csr_tx_pfc6_en,
    input wire [15:0]   csr_tx_pfc6_pqt,
    input wire [15:0]   csr_tx_pfc6_hqt,

    input wire          csr_tx_pfc7_en,
    input wire [15:0]   csr_tx_pfc7_pqt,
    input wire [15:0]   csr_tx_pfc7_hqt,

    input wire          csr_tx_unidirectional_en,
    input wire          csr_tx_unidirectional_remote_fault_dis,
    input wire          csr_tx_unidirectional_force_remote_fault,
    
    output wire         csr_tx_pause_status, 
    output wire         csr_tx_backpressure_status,
    
    input wire [31:0]   csr_adjust_10g,
    input wire [19:0]   csr_period_10g,
    input wire [31:0]   csr_adjust_1g,
    input wire [19:0]   csr_period_1g,
    input wire [18:0]   csr_asymmetry,
    input wire          csr_p2p_dir_egress,

    // Av-ST pause control path
    input wire [1:0]    pause_ctrl_sink_data,
    input wire [(PFC_PRIORITY_NUM*2)-1 : 0]    pfc_ctrl_sink_data,

    // Av-ST sink data path
    input wire                      frm_sink_sop,
    input wire                      frm_sink_eop,
    input wire                      frm_sink_valid,
    input wire [TXDATAWIDTH-1:0]    frm_sink_data,
    input wire [TXEMPTYWIDTH-1:0]   frm_sink_empty,
    input wire [TXUSRERRWIDTH-1:0]  frm_sink_error,

    output wire                     frm_sink_ready,

    // TX RS layer in/out ports
    output wire [TXDATAWIDTH-1:0]  rs2top_eth_xgmii_data,
    output wire [3:0]              rs2top_eth_xgmii_ctrl, 
    output wire                    rs2top_eth_xgmii_valid,

    // Link fault status
    input wire [LINK_FAULT_DATAWIDTH-1:0] rx_link_fault_status,

    // Speed selection
    input wire [2:0]    speed_sel,

    // Flow control
    input wire          rx2flc_pause_field_valid,
    input wire [15:0]   rx2flc_pause_pq,

    // input and output ports for GMII/MII interface
    // clock and reset for GMII interface only
    input wire clock_gmii,
    input wire reset_gmii_n,
    
    // gmii interface
    output wire [7:0]gmii_source_data,
    output wire gmii_source_control,
    output wire gmii_source_error,
    
    // GMII 16 bit Transmit
    output wire [15:0]  gmii16b_tx_d,
    output wire [ 1:0]  gmii16b_tx_en,
    output wire [ 1:0]  gmii16b_tx_err,

    // mii interface
    output wire [3:0]mii_source_data,
    output wire mii_source_control,
    output wire mii_source_error,
  
    // clock enable to use for GMII/MII
    input wire tx_clkena,
    input wire tx_clkena_half_rate,

    // Frame Info (User Logic)
    output wire         user_txstatus_valid,
    output wire [39:0]  user_txstatus_data,
    output wire [ 6:0]  user_txstatus_error,

    // Frame Info (Stat Logic)
    output wire         stat_txstatus_valid,
    output wire [39:0]  stat_txstatus_data,
    output wire [ 6:0]  stat_txstatus_error,

    // PFC XON/XOFF Status
    output wire         pfc_xonxoff_status_valid,
    output wire [15:0]  pfc_xonxoff_status_data,

    // Underflow
    output wire         tx_undrflw_pulse,

    // Unidirectional enablement
    input wire          enable_unidirectional,

    // input to control ipg
    input wire [7:0]    ipg_value_10g,
    input wire [7:0]    ipg_value_1g,

    // 1588
    //ED change path delay to 24 bits instead of 17
    input  wire [23:0]  tx_path_delay_10g_data,
    input  wire [95:0]  tx_time_of_day_96b_10g_data,
    input  wire [63:0]  tx_time_of_day_64b_10g_data,
    
    input  wire [21:0]  tx_path_delay_1g_data,
    input  wire [95:0]  tx_time_of_day_96b_1g_data,
    input  wire [63:0]  tx_time_of_day_64b_1g_data,
    
    output wire                        tx_egress_timestamp_96b_valid,
    output wire [95:0]                 tx_egress_timestamp_96b_data,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_96b_fingerprint,
    output wire                        tx_egress_timestamp_64b_valid,
    output wire [63:0]                 tx_egress_timestamp_64b_data,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_64b_fingerprint,
    
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
    
    // ECC status
    output wire                        tx_gmii_encoder_ecc_err_corrected,
    output wire                        tx_gmii_encoder_ecc_err_fatal,
    output wire                        tx_ptp_request_control_ecc_err_corrected,
    output wire                        tx_ptp_request_control_ecc_err_fatal,

    // busy bit status
    output wire                        tx_packet_in_progress_top,
   
    // Debug
    output wire dbg_tx_data_frm_gen_fifo_overflow,
    //output wire   dbg_tx_data_frm_gen_fifo_underflow,
    output wire dbg_tx_pause_trans_in_progress,
    output wire dbg_tx_pfc_trans_in_progress,
    
   //cf error status
   output                               ingress_overflow,
   output                               egress_overflow,
   output                               egress_rt_gt_4s,
   output                               egress_rt_neg,
   output                               cf_overflow_valid 

);

    // Local parameters
    localparam TXSRCERRWIDTH = TXUSRERRWIDTH+1;


    // Internal wires
    wire                        data_frm_sink_sop;
    wire                        data_frm_sink_eop;
    wire                        data_frm_sink_valid;
    wire [TXDATAWIDTH-1:0]      data_frm_sink_data;
    wire [TXEMPTYWIDTH-1:0]     data_frm_sink_empty;
    wire [TXUSRERRWIDTH-1:0]    data_frm_sink_error;
    wire                        data_frm_sink_ready;
    
    wire                        frm2mx_pausefrm_sop;
    wire                        frm2mx_pausefrm_eop;
    wire                        frm2mx_pausefrm_valid;
    wire [TXDATAWIDTH-1:0]      frm2mx_pausefrm_data;
    wire                        mx2frm_pausefrm_ready;

    wire                        frm2mx_normfrm_sop;
    wire                        frm2mx_normfrm_eop;
    wire                        frm2mx_normfrm_valid;
    wire [TXDATAWIDTH-1:0]      frm2mx_normfrm_data;
    wire [TXEMPTYWIDTH-1:0]     frm2mx_normfrm_empty;
    wire [TXSRCERRWIDTH-1:0]    frm2mx_normfrm_error;
    wire                        mx2frm_normfrm_ready;

    wire                        frm2mx_pfcfrm_sop;
    wire                        frm2mx_pfcfrm_eop;
    wire                        frm2mx_pfcfrm_valid;
    wire [TXDATAWIDTH-1:0]      frm2mx_pfcfrm_data;
    wire                        mx2frm_pfcfrm_ready;

    wire                        rs2crc_sop;
    wire                        rs2crc_clken;
    wire                        rs2crc_eop;
    wire [TXEMPTYWIDTH-1:0]     rs2crc_empty;
    wire [TXDATAWIDTH-1:0]      rs2crc_data;

    wire                        mx2rs_sop;
    wire                        mx2rs_eop;
    wire                        mx2rs_valid;
    wire [TXDATAWIDTH-1:0]      mx2rs_data;
    wire [TXEMPTYWIDTH-1:0]     mx2rs_empty;
    wire [TXSRCERRWIDTH-1:0]     mx2rs_error;
    wire [TXSRCERRWIDTH-1:0]     mx2rs_pre_error;
    wire [1:0]                  mx2rs_frm_type;
    wire                        rs2mx_ready;

    wire                        crc2rs_result_valid;
    wire [TXDATAWIDTH-1:0]      crc2rs_result;

    wire                        flc2dataframe_ready;
    wire                        flc2dataframe_valid;

    wire                        rs2frm_dec_sop;
    wire                        rs2frm_dec_valid;
    wire                        rs2frm_dec_eop;
    wire [TXEMPTYWIDTH-1:0]     rs2frm_dec_empty;
    wire [TXDATAWIDTH-1:0]      rs2frm_dec_data;
    wire [TXSRCERRWIDTH-1:0]    rs2frm_dec_error;
    wire [1:0]                  rs2frm_dec_frm_type;

    wire                        pl_frm_dec_sop;
    wire                        pl_frm_dec_valid;
    wire                        pl_frm_dec_eop;
    wire [TXEMPTYWIDTH-1:0]     pl_frm_dec_empty;
    wire [TXDATAWIDTH-1:0]      pl_frm_dec_data;
    wire [TXSRCERRWIDTH-1:0]    pl_frm_dec_error;
    wire [1:0]                  pl_frm_dec_frm_type;

    wire [39:0]                 in_frm_dec_data;
    wire [39:0]                 out_frm_dec_data;

    wire                        frm_info_stat_valid;
    wire [39:0]                 frm_info_stat_data;
    wire [ 2:0]                 frm_info_stat_error;

    wire                        frm_info_user_valid;
    wire [39:0]                 frm_info_user_data;
    wire [ 2:0]                 frm_info_user_error;

    wire        crc_inst_en;
    
    
    // 1588
    wire [3:0]   xgmii2ptp_xgmii_control;
    wire [31:0]  xgmii2ptp_xgmii_data;
    wire [1:0]   xgmii2ptp_xgmii_channel;
    // ED
    //wire         xgmii2ptp_xgmii_valid;
    wire [3:0]   ptp2xgmii_xgmii_control;
    wire [31:0]  ptp2xgmii_xgmii_data;
    
    wire         gmii2ptp_gmii_control;
    wire [7:0]   gmii2ptp_gmii_data;
    wire         gmii2ptp_gmii_error;
    wire [1:0]   gmii2ptp_gmii_channel;
    
    wire         ptp2gmii_gmii_control;
    wire [7:0]   ptp2gmii_gmii_data;
    wire         ptp2gmii_gmii_error;
    
    wire [ 1:0]   gmii16b2ptp_gmii16b_control;
    wire [15:0]   gmii16b2ptp_gmii16b_data;
    wire [ 1:0]   gmii16b2ptp_gmii16b_error;
    wire [ 1:0]   gmii16b2ptp_gmii16b_channel;
    
    wire [ 1:0]   ptp2gmii16b_gmii16b_control;
    wire [15:0]   ptp2gmii16b_gmii16b_data;
    wire [ 1:0]   ptp2gmii16b_gmii16b_error;
    
    // busy bit status wire
    wire         tx_packet_in_progress_data_frm;
    wire         tx_packet_in_progress_pfc;
    wire         tx_packet_in_progress_pause;
    wire         tx_packet_in_progress_rs;
    
    // flop reset to improve timing. cannot add for rs layer. 
    reg         rst_n_pipe1;
    reg         rst_n_pipe2;
    // reg         rst_n_pipe3;
    // reg         rst_n_pipe4;
    // reg         rst_n_pipe5;
    // reg         rst_n_pipe6;
    
    reg         reset_gmii_n_pipe1;
    // reg         reset_gmii_n_pipe2;
    
    always @ (posedge clk)
        begin
        rst_n_pipe2 <= rst_n;
        rst_n_pipe1 <= rst_n_pipe2;
        // rst_n_pipe3 <= rst_n_pipe2;
        // rst_n_pipe4 <= rst_n_pipe3;
        // rst_n_pipe5 <= rst_n_pipe4;
        // rst_n_pipe6 <= rst_n_pipe5;
        end
    
    always @ (posedge clock_gmii)
        begin
        reset_gmii_n_pipe1 <= reset_gmii_n;
        // reset_gmii_n_pipe2 <= reset_gmii_n_pipe1;
        end

    assign tx_packet_in_progress_top = tx_packet_in_progress_data_frm | tx_packet_in_progress_pfc | tx_packet_in_progress_pause | tx_packet_in_progress_rs;

    //------------------------------------------------------------------------
    // Pause frame generator
    //------------------------------------------------------------------------
    alt_em10g32_tx_pause_frm_gen #(
        .TXDATAWIDTH(TXDATAWIDTH),
        .DEBUG      (DEBUG)
    ) pause_frm_gen_inst (
        // Clock and reset
        .clk (clk),
        .rst_n (rst_n_pipe1),

        // CSR control path
        .csr_tx_preamble_passthru   (csr_tx_preamble_passthru),
        .csr_tx_mac_sa              (csr_tx_mac_sa),
        .csr_tx_tsfr_en_n           (csr_tx_tsfr_en_n),
        .csr_tx_pause_en            (csr_tx_pause_en),
        .csr_tx_pause_xonxoff_valid (csr_tx_pause_xonxoff_valid),
        .csr_tx_pause_xonxoff_ctrl  (csr_tx_pause_xonxoff_ctrl),
        .csr_tx_pause_pq            (csr_tx_pause_pq),
        .csr_tx_pause_select        (csr_tx_pause_select),
        .csr_tx_pause_holdoff_pq    (csr_tx_pause_holdoff_pq),

        .csr_tx_pause_status        (csr_tx_pause_status), 

        // Av-ST control path
        .pause_ctrl_sink_data       (pause_ctrl_sink_data),

        // Pause frame data path
        .frm2mx_pausefrm_sop        (frm2mx_pausefrm_sop),
        .frm2mx_pausefrm_eop        (frm2mx_pausefrm_eop),
        .frm2mx_pausefrm_valid      (frm2mx_pausefrm_valid),
        .frm2mx_pausefrm_data       (frm2mx_pausefrm_data),
        .mx2frm_pausefrm_ready      (mx2frm_pausefrm_ready),
        
        .tx_packet_in_progress_pause (tx_packet_in_progress_pause),

        // Debug
        .dbg_tx_pause_trans_in_progress (dbg_tx_pause_trans_in_progress)
    );

    //------------------------------------------------------------------------
    // PFC generator
    //------------------------------------------------------------------------
    generate if (ENABLE_PFC) begin : PFC
    alt_em10g32_tx_pfc_frm_gen #(
        .PFC_PRIORITY_NUM   (PFC_PRIORITY_NUM),
        .TXDATAWIDTH        (TXDATAWIDTH),
        .DEBUG              (DEBUG)
    ) pfc_frm_gen_inst (
        .clk    (clk),
        .rst_n  (rst_n_pipe1),

        // CSR control path
        .csr_tx_preamble_passthru   (csr_tx_preamble_passthru),
        .csr_tx_mac_sa      (csr_tx_mac_sa),
        .csr_tx_tsfr_en_n   (csr_tx_tsfr_en_n),
                                       
        .csr_tx_pfc0_en     (csr_tx_pfc0_en),
        .csr_tx_pfc0_pqt    (csr_tx_pfc0_pqt),
        .csr_tx_pfc0_hqt    (csr_tx_pfc0_hqt),
                                       
        .csr_tx_pfc1_en     (csr_tx_pfc1_en),
        .csr_tx_pfc1_pqt    (csr_tx_pfc1_pqt),
        .csr_tx_pfc1_hqt    (csr_tx_pfc1_hqt),
                                           
        .csr_tx_pfc2_en     (csr_tx_pfc2_en),
        .csr_tx_pfc2_pqt    (csr_tx_pfc2_pqt),
        .csr_tx_pfc2_hqt    (csr_tx_pfc2_hqt),
                                           
        .csr_tx_pfc3_en     (csr_tx_pfc3_en),
        .csr_tx_pfc3_pqt    (csr_tx_pfc3_pqt),
        .csr_tx_pfc3_hqt    (csr_tx_pfc3_hqt),
                                           
        .csr_tx_pfc4_en     (csr_tx_pfc4_en),
        .csr_tx_pfc4_pqt    (csr_tx_pfc4_pqt),
        .csr_tx_pfc4_hqt    (csr_tx_pfc4_hqt),
                                           
        .csr_tx_pfc5_en     (csr_tx_pfc5_en),
        .csr_tx_pfc5_pqt    (csr_tx_pfc5_pqt),
        .csr_tx_pfc5_hqt    (csr_tx_pfc5_hqt),

        .csr_tx_pfc6_en     (csr_tx_pfc6_en),
        .csr_tx_pfc6_pqt    (csr_tx_pfc6_pqt),
        .csr_tx_pfc6_hqt    (csr_tx_pfc6_hqt),
                                           
        .csr_tx_pfc7_en     (csr_tx_pfc7_en),
        .csr_tx_pfc7_pqt    (csr_tx_pfc7_pqt),
        .csr_tx_pfc7_hqt    (csr_tx_pfc7_hqt),

        // Av-ST control path
        .pfc_ctrl_sink_data (pfc_ctrl_sink_data),

        // Pause frame data path
        .frm2mx_pfcfrm_sop   (frm2mx_pfcfrm_sop),
        .frm2mx_pfcfrm_eop   (frm2mx_pfcfrm_eop),
        .frm2mx_pfcfrm_valid (frm2mx_pfcfrm_valid),
        .frm2mx_pfcfrm_data  (frm2mx_pfcfrm_data),
        .mx2frm_pfcfrm_ready (mx2frm_pfcfrm_ready),
        
        // busy bit status
        .tx_packet_in_progress_pfc  (tx_packet_in_progress_pfc),
    
        // Debug
        .dbg_tx_pfc_trans_in_progress (dbg_tx_pfc_trans_in_progress)

    );
    end
    else begin
        assign frm2mx_pfcfrm_sop    = 1'b0;
        assign frm2mx_pfcfrm_eop    = 1'b0;
        assign frm2mx_pfcfrm_valid  = 1'b0;
        assign frm2mx_pfcfrm_data   = {TXDATAWIDTH{1'b0}};
        assign dbg_tx_pfc_trans_in_progress = 1'b0;
        assign tx_packet_in_progress_pfc = 1'b0;
    end
    endgenerate

    //------------------------------------------------------------------------
    // Input pipeline for 1588 to improve timing
    //------------------------------------------------------------------------
    
    generate 
    if (ENABLE_TIMESTAMPING || (DEVICE_FAMILY == "Stratix 10")) begin : input_pl
        wire [36:0] in_data;
        wire [36:0] out_data;

        assign in_data = {frm_sink_error, frm_sink_empty, frm_sink_data, frm_sink_eop, frm_sink_sop};

        alt_em10g32_pipeline_base #(
            .SYMBOLS_PER_BEAT(1),
            .BITS_PER_SYMBOL(37),
            .PIPELINE_READY(1)
        ) input_st_pl_inst (
            .clk        (clk),
            .reset_n    (rst_n_pipe1),
            .in_ready   (frm_sink_ready),
            .in_valid   (frm_sink_valid),
            .in_data    (in_data),
            .out_ready  (data_frm_sink_ready),
            .out_valid  (data_frm_sink_valid),
            .out_data   (out_data)
        );

        assign data_frm_sink_sop    = out_data[0];
        assign data_frm_sink_eop    = out_data[1];
        assign data_frm_sink_data   = out_data[33:2];
        assign data_frm_sink_empty  = out_data[35:34];
        assign data_frm_sink_error  = out_data[36];
    end
    else begin
        assign data_frm_sink_sop    = frm_sink_sop;  
        assign data_frm_sink_eop    = frm_sink_eop;  
        assign data_frm_sink_data   = frm_sink_data; 
        assign data_frm_sink_empty  = frm_sink_empty;
        assign data_frm_sink_error  = frm_sink_error;
        assign data_frm_sink_valid  = frm_sink_valid;
        assign frm_sink_ready       = data_frm_sink_ready;
    end
    endgenerate

    //------------------------------------------------------------------------
    // Data frame generator
    //------------------------------------------------------------------------
    alt_em10g32_tx_data_frm_gen #(
        .TXDATAWIDTH        (TXDATAWIDTH),
        .TXEMPTYWIDTH       (TXEMPTYWIDTH),
        .TXSINKERRWIDTH     (TXUSRERRWIDTH),
        .TXSRCERRWIDTH      (TXSRCERRWIDTH),

        .FFDEPTH            (6),
        .FULLWTRMRK         (4),

        .DEBUG              (DEBUG)
    ) data_frm_gen_inst (

        // Clock and reset
        .clk            (clk),
        .rst_n          (rst_n_pipe1),

        // CSR control path
        .csr_tx_mac_sa_ovrd_en       (csr_tx_mac_sa_ovrd_en),
        .csr_tx_mac_sa               (csr_tx_mac_sa),
        .csr_tx_preamble_passthru    (csr_tx_preamble_passthru),
        .csr_tx_pad_insrt_en         (csr_tx_pad_insrt_en),
        .csr_tx_backpressure_status  (csr_tx_backpressure_status),

        // Av-ST sink data path
        .frm_sink_sop               (data_frm_sink_sop),
        .frm_sink_eop               (data_frm_sink_eop),
        .frm_sink_valid             (data_frm_sink_valid),
        .frm_sink_data              (data_frm_sink_data),
        .frm_sink_empty             (data_frm_sink_empty),
        .frm_sink_error             (data_frm_sink_error),

        .frm_sink_ready             (data_frm_sink_ready),

        // Av-ST source data path
        .frm2mx_normfrm_sop         (frm2mx_normfrm_sop),
        .frm2mx_normfrm_eop         (frm2mx_normfrm_eop),
        .frm2mx_normfrm_valid       (frm2mx_normfrm_valid),
        .frm2mx_normfrm_data        (frm2mx_normfrm_data),
        .frm2mx_normfrm_empty       (frm2mx_normfrm_empty),
        .frm2mx_normfrm_error       (frm2mx_normfrm_error),
        
        .mx2frm_normfrm_ready       (mx2frm_normfrm_ready),

        // Flow control
        .flc2dataframe_ready        (flc2dataframe_ready),
        .flc2dataframe_valid        (flc2dataframe_valid),
        
        // Underflow pulse to Statistic
        .tx_undrflw_pulse           (tx_undrflw_pulse),
        
        .tx_packet_in_progress_data_frm     (tx_packet_in_progress_data_frm),
        
        // Debug
        .dbg_tx_data_frm_gen_fifo_overflow (dbg_tx_data_frm_gen_fifo_overflow)
        //.dbg_tx_data_frm_gen_fifo_underflow(dbg_tx_data_frm_gen_fifo_underflow)

    );

    //------------------------------------------------------------------------
    // Muxer
    //------------------------------------------------------------------------
    alt_em10g32_tx_frm_muxer #(
        .TXDATAWIDTH   (TXDATAWIDTH),
        .TXEMPTYWIDTH  (TXEMPTYWIDTH),
        .TXSRCERRWIDTH (TXSRCERRWIDTH) 
    ) frm_muxer_inst (

        // Clock and reset
        .clk    (clk),
        .rst_n  (rst_n_pipe1),

        // Ports from TX data frame generator
        .frm2mx_normfrm_sop     (frm2mx_normfrm_sop),
        .frm2mx_normfrm_eop     (frm2mx_normfrm_eop),
        .frm2mx_normfrm_valid   (frm2mx_normfrm_valid),
        .frm2mx_normfrm_data    (frm2mx_normfrm_data),
        .frm2mx_normfrm_empty   (frm2mx_normfrm_empty),
        .frm2mx_normfrm_error   (frm2mx_normfrm_error),
        .mx2frm_normfrm_ready   (mx2frm_normfrm_ready),

        // Ports from TX pause frame generator
        .frm2mx_pausefrm_sop    (frm2mx_pausefrm_sop),
        .frm2mx_pausefrm_eop    (frm2mx_pausefrm_eop),
        .frm2mx_pausefrm_valid  (frm2mx_pausefrm_valid),
        .frm2mx_pausefrm_data   (frm2mx_pausefrm_data),    
        .mx2frm_pausefrm_ready  (mx2frm_pausefrm_ready),

        // Ports from TX PFC
        .frm2mx_pfcfrm_sop      (frm2mx_pfcfrm_sop),
        .frm2mx_pfcfrm_eop      (frm2mx_pfcfrm_eop),
        .frm2mx_pfcfrm_valid    (frm2mx_pfcfrm_valid),
        .frm2mx_pfcfrm_data     (frm2mx_pfcfrm_data),
        .mx2frm_pfcfrm_ready    (mx2frm_pfcfrm_ready),

        // Output ports
        .mx2rs_sop              (mx2rs_sop),
        .mx2rs_eop              (mx2rs_eop),
        .mx2rs_valid            (mx2rs_valid),
        .mx2rs_data             (mx2rs_data),
        .mx2rs_empty            (mx2rs_empty),
        .mx2rs_error            (mx2rs_error),
        .mx2rs_pre_error        (mx2rs_pre_error),
        .mx2rs_frm_type         (mx2rs_frm_type),
        .rs2mx_ready            (rs2mx_ready)

    );

    //------------------------------------------------------------------------
    // RS layer
    //------------------------------------------------------------------------
    alt_em10g32_tx_rs_layer #( 
        .DEVICE_FAMILY          (DEVICE_FAMILY),
        .SYMBOLPERBEAT          (TXDATAWIDTH),
        .LINK_FAULT_DATAWIDTH   (LINK_FAULT_DATAWIDTH),
        .ENABLE_MEM_ECC         (ENABLE_MEM_ECC),
        .FORWARD_SYNC_DEPTH     (FORWARD_SYNC_DEPTH),
        .BACKWARD_SYNC_DEPTH    (BACKWARD_SYNC_DEPTH),
        .PREAMBLE_PASSTHROUGH   (PREAMBLE_PASSTHROUGH),
        .ENABLE_1G10G_MAC       (ENABLE_1G10G_MAC),    
        .ENABLE_10GBASER_REG_MODE        (ENABLE_10GBASER_REG_MODE),
        .ENABLE_XGMII           (ENABLE_XGMII),
        .ENABLE_GMII16B         (ENABLE_GMII16B),
        .SYNC_RESET_N(SYNC_RESET_N)
    ) rs_layer_inst (

        // Clock and reset
        .clk            (clk),
        .rst_n          (rst_n_pipe1),
        .rst_n_asyn     (rst_n),
        
        // CSR control path
        .csr_preamble_passthru  (csr_tx_preamble_passthru),
        .csr_crc_inst_en        (crc_inst_en),
        .csr_tx_unidirectional_en   (csr_tx_unidirectional_en),
        .csr_tx_unidirectional_remote_fault_dis(csr_tx_unidirectional_remote_fault_dis),
        .csr_tx_unidirectional_force_remote_fault(csr_tx_unidirectional_force_remote_fault),
     
        // Av-ST control path
        .rx_link_fault_status   (rx_link_fault_status),
        
        // Av-ST STM_DATA path
        .mx2rs_ethfrm_sop       (mx2rs_sop),
        .mx2rs_ethfrm_valid     (mx2rs_valid),
        .rs2mx_ethfrm_ready     (rs2mx_ready),
        .mx2rs_ethfrm_eop       (mx2rs_eop),
        .mx2rs_ethfrm_data      (mx2rs_data),
        .mx2rs_ethfrm_empty     (mx2rs_empty),
        .mx2rs_ethfrm_error     (mx2rs_error),
        .mx2rs_ethfrm_pre_error (mx2rs_pre_error),
        .mx2rs_frm_type         (mx2rs_frm_type),
        
        // output to CRC
        .rs2crc_sop             (rs2crc_sop),
        .rs2crc_clken           (rs2crc_clken),
        .rs2crc_eop             (rs2crc_eop),
        .rs2crc_empty           (rs2crc_empty),
        .rs2crc_data            (rs2crc_data),

        // output to frame decoder
        .rs2frm_dec_sop         (rs2frm_dec_sop),
        .rs2frm_dec_valid       (rs2frm_dec_valid),
        .rs2frm_dec_eop         (rs2frm_dec_eop),
        .rs2frm_dec_empty       (rs2frm_dec_empty),
        .rs2frm_dec_data        (rs2frm_dec_data),
        .rs2frm_dec_error       (rs2frm_dec_error),
        .rs2frm_dec_frm_type    (rs2frm_dec_frm_type),
        
        // input from CRC
        .crc2rs_result_valid    (crc2rs_result_valid),
        .crc2rs_result          (crc2rs_result),
        
        // xgmii data to top
        .rs2top_eth_xgmii_data  (rs2top_eth_xgmii_data),
        .rs2top_eth_xgmii_ctrl  (rs2top_eth_xgmii_ctrl),    
        .rs2top_eth_xgmii_valid (rs2top_eth_xgmii_valid),

        // input and output ports for GMII/MII interface
        // clock and reset for GMII interface
        .clock_gmii             (clock_gmii),
        .reset_gmii_n           (reset_gmii_n_pipe1),
        .reset_gmii_n_asyn      (reset_gmii_n),
    
        // gmii interface
        .gmii_source_data       (gmii_source_data),
        .gmii_source_control    (gmii_source_control),
        .gmii_source_error      (gmii_source_error),
    
        // GMII 16 bit Transmit
        .gmii16b_tx_d           (gmii16b_tx_d),
        .gmii16b_tx_en          (gmii16b_tx_en),
        .gmii16b_tx_err         (gmii16b_tx_err),        
        
        // mii interface
        .mii_source_data        (mii_source_data),
        .mii_source_control     (mii_source_control),
        .mii_source_error       (mii_source_error),
  
        // speed sel port to select speed for MAC
        .speed_sel              (speed_sel),

        // PIPG
        .ipg_value_10g          (ipg_value_10g),
        .ipg_value_1g           (ipg_value_1g),

        // clock enable to use for GMII/MII
        .tx_clkena              (tx_clkena),
        .tx_clkena_half_rate    (tx_clkena_half_rate),

        // Unidirecitonal Enablement
        .enable_unidirectional  (enable_unidirectional),
        
        // 1588
        .enable_timestamping    (ENABLE_TIMESTAMPING ? 1'b1 : 1'b0),
        .enable_ptp_1step       (ENABLE_PTP_1STEP ? 1'b1 : 1'b0),
        
        .xgmii2ptp_xgmii_control(xgmii2ptp_xgmii_control),
        .xgmii2ptp_xgmii_data   (xgmii2ptp_xgmii_data),
        .xgmii2ptp_xgmii_channel(xgmii2ptp_xgmii_channel),
        //ED
        //.xgmii2ptp_xgmii_valid  (xgmii2ptp_xgmii_valid),
        .ptp2xgmii_xgmii_control(ptp2xgmii_xgmii_control),
        .ptp2xgmii_xgmii_data   (ptp2xgmii_xgmii_data),
        
        .gmii2ptp_gmii_control  (gmii2ptp_gmii_control),
        .gmii2ptp_gmii_data     (gmii2ptp_gmii_data),
        .gmii2ptp_gmii_error    (gmii2ptp_gmii_error),
        .gmii2ptp_gmii_channel  (gmii2ptp_gmii_channel),
        
        .ptp2gmii_gmii_control  (ptp2gmii_gmii_control),
        .ptp2gmii_gmii_data     (ptp2gmii_gmii_data),
        .ptp2gmii_gmii_error    (ptp2gmii_gmii_error),
        
        .gmii16b2ptp_gmii16b_control  (gmii16b2ptp_gmii16b_control),
        .gmii16b2ptp_gmii16b_data     (gmii16b2ptp_gmii16b_data),
        .gmii16b2ptp_gmii16b_error    (gmii16b2ptp_gmii16b_error),
        .gmii16b2ptp_gmii16b_channel  (gmii16b2ptp_gmii16b_channel),
        
        .ptp2gmii16b_gmii16b_control  (ptp2gmii16b_gmii16b_control),
        .ptp2gmii16b_gmii16b_data     (ptp2gmii16b_gmii16b_data),
        .ptp2gmii16b_gmii16b_error    (ptp2gmii16b_gmii16b_error),
        
        .tx_packet_in_progress_rs          (tx_packet_in_progress_rs),
        
        // ECC status
        .tx_gmii_encoder_ecc_err_corrected (tx_gmii_encoder_ecc_err_corrected),
        .tx_gmii_encoder_ecc_err_fatal     (tx_gmii_encoder_ecc_err_fatal)

    );

    //------------------------------------------------------------------------
    // Add pipeline between rs layer and frm decoder to improve timing
    //------------------------------------------------------------------------
    assign in_frm_dec_data = {rs2frm_dec_frm_type, rs2frm_dec_error, rs2frm_dec_empty, rs2frm_dec_data, rs2frm_dec_eop, rs2frm_dec_sop};

    alt_em10g32_pipeline_base #(
        .SYMBOLS_PER_BEAT(1),
        .BITS_PER_SYMBOL(40),
        .PIPELINE_READY(1)
    ) frm_dec_pl_inst (
        .clk        (clk),
        .reset_n    (rst_n_pipe1),
        .in_ready   (),
        .in_valid   (rs2frm_dec_valid),
        .in_data    (in_frm_dec_data),
        .out_ready  (1'b1),
        .out_valid  (pl_frm_dec_valid),
        .out_data   (out_frm_dec_data)
    );

    assign pl_frm_dec_sop    = out_frm_dec_data[0];
    assign pl_frm_dec_eop    = out_frm_dec_data[1];
    assign pl_frm_dec_data   = out_frm_dec_data[33:2];
    assign pl_frm_dec_empty  = out_frm_dec_data[35:34];
    assign pl_frm_dec_error  = out_frm_dec_data[37:36];
    assign pl_frm_dec_frm_type = out_frm_dec_data[39:38];


    //------------------------------------------------------------------------
    // CRC
    //------------------------------------------------------------------------
    assign crc_inst_en = (INSTANTIATE_TX_CRC)? csr_tx_crc_inst_en : 1'b0;

    generate
    if (INSTANTIATE_TX_CRC && !(ENABLE_TIMESTAMPING && ENABLE_PTP_1STEP)) begin
        alt_em10g32_crc32 crc32_inst (
            .clk        (clk),
            .rst_n      (rst_n_pipe1),
            .clken      (rs2crc_clken),
            .sop        (rs2crc_sop),   
            .eop        (rs2crc_eop),               
            .mty        (rs2crc_empty),     
            .data       (rs2crc_data),
            .crc_out    (crc2rs_result),             //inverted and bit-reversed
            .crc_valid  (crc2rs_result_valid),
            .crc_good   ()
        );
    end
    else begin
        assign crc2rs_result    = {TXDATAWIDTH{1'b0}};
        assign crc2rs_result_valid = 1'b0;
    end
    endgenerate

    //------------------------------------------------------------------------
    // Pause frame flow control
    //------------------------------------------------------------------------
    alt_em10g32_tx_flow_control #(
        .ENABLE_1G10G_MAC(ENABLE_1G10G_MAC),
        .ENABLE_10GBASER_REG_MODE (ENABLE_10GBASER_REG_MODE)
    ) tx_flow_control_inst (
        .clk    (clk),
        .reset_n(rst_n_pipe1),
    
        .rx2flc_pause_field_valid   (rx2flc_pause_field_valid),
        .rx2flc_pause_pq            (rx2flc_pause_pq),
    
        .speed_sel                  (speed_sel),
    
        .flc2dataframe_ready        (flc2dataframe_ready),
        .flc2dataframe_valid        (flc2dataframe_valid)
    );

    //------------------------------------------------------------------------
    // Frame decoder
    //------------------------------------------------------------------------
    alt_em10g32_frm_decoder frm_decoder_inst (

        // Clock & Reset
        .clk    (clk),
        .rst_n  (rst_n_pipe1),
        
        // Configuration from CSR
        .csr_tx_crc_insrt_en            (crc_inst_en | pl_frm_dec_frm_type[1]), // if CRC insertion disable, still insert CRC for pause/pfc frames 
        .csr_txvlandet_dis              (csr_txvlandet_dis),
        .csr_rx_primaddr                (48'h0),
        .csr_rx_suppaddr_en0            (1'b0),
        .csr_rx_suppaddr_en1            (1'b0),
        .csr_rx_suppaddr_en2            (1'b0),
        .csr_rx_suppaddr_en3            (1'b0),
        .csr_rx_supp_macaddr_0          (48'h0),
        .csr_rx_supp_macaddr_1          (48'h0),
        .csr_rx_supp_macaddr_2          (48'h0),
        .csr_rx_supp_macaddr_3          (48'h0),
        .csr_rx_max_datafrmlen          (csr_tx_max_datafrmlen),
        .csr_rxvlandet_dis              (1'b0),
        .csr_rx_allucast_en             (1'b1),
        .csr_rx_allmcast_en             (1'b1),
        .csr_rx_ignore_pausefrm         (1'b0),
        .csr_rx_pfc_ignore_pausefrm_0   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_1   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_2   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_3   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_4   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_5   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_6   (1'b0),
        .csr_rx_pfc_ignore_pausefrm_7   (1'b0),
        .csr_rx_frm_info_user_type      (1'b0),
        
        // Frame Data
        .frm_data                       (pl_frm_dec_data),
        .frm_sop                        (pl_frm_dec_sop),
        .frm_eop                        (pl_frm_dec_eop),
        .frm_valid                      (pl_frm_dec_valid),
        .frm_empty                      (pl_frm_dec_empty),
        .frm_error                      (1'b0),
        
        // Frame Info (Statistics)
        .frm_info_stat_valid            (frm_info_stat_valid),
        .frm_info_stat_data             (frm_info_stat_data),
        .frm_info_stat_error            (frm_info_stat_error),
        
        // Frame Info (User Logic)
        .frm_info_user_valid            (frm_info_user_valid),
        .frm_info_user_data             (frm_info_user_data),
        .frm_info_user_error            (frm_info_user_error),
        
        // Frame Info for CRC/Pad Remover
        .pad_rem_info_valid             (),
        .pad_rem_info_length_type       (),
        .pad_rem_info_length_frm        (),
        .pad_rem_info_ctrl_frm          (),
        
        // Frame Drop Info
        .frm_drop_info_valid            (),
        .frm_drop_info_da_matched       (),
        .frm_drop_info_unicast          (),
        .frm_drop_info_multicast        (),
        .frm_drop_info_broadcast        (),
        .frm_drop_info_ctrl_frm         (),
        .frm_drop_info_pause_frm        (),
        .frm_drop_info_pfc_frm          (),
        
        // Pause Quanta
        .pause_quanta_valid             (),
        .pause_quanta                   (),
        
        // PFC Pause Quanta
        .pfc_status_valid               (),
        .pfc_status_pause_quanta_valid  (),
        .pfc_status_pause_quanta_0      (),
        .pfc_status_pause_quanta_1      (),
        .pfc_status_pause_quanta_2      (),
        .pfc_status_pause_quanta_3      (),
        .pfc_status_pause_quanta_4      (),
        .pfc_status_pause_quanta_5      (),
        .pfc_status_pause_quanta_6      (),
        .pfc_status_pause_quanta_7      (),
        
        // PFC XON/XOFF Status
        .pfc_xonxoff_status_valid       (pfc_xonxoff_status_valid),
        .pfc_xonxoff_status_data        (pfc_xonxoff_status_data)
    );

    //------------------------------------------------------------------------
    // Signals Alignment
    // Align error to frame decoder output: 3 clock cycle latency
    //------------------------------------------------------------------------
    alt_em10g32_tx_err_aligner #(
        .DELAY (3)
    ) stat_err_aligner_inst (
        .clk        (clk),
        .rst_n      (rst_n_pipe1),
      
        // From frm decoder
        .frm_info_valid (frm_info_stat_valid),
        .frm_info_data  (frm_info_stat_data),
        .frm_info_error (frm_info_stat_error),

        // From rs layer
        //.frm_data       (pl_frm_dec_data),
        //.frm_sop        (pl_frm_dec_sop),
        //.frm_eop        (pl_frm_dec_eop),
        .frm_valid      (pl_frm_dec_valid),
        //.frm_empty      (pl_frm_dec_empty),
        .frm_error      (pl_frm_dec_error),

        .txstatus_valid (stat_txstatus_valid),
        .txstatus_data  (stat_txstatus_data),
        .txstatus_error (stat_txstatus_error)

    );

    alt_em10g32_tx_err_aligner #(
        .DELAY (3)
    ) user_err_aligner_inst (
        .clk        (clk),
        .rst_n      (rst_n_pipe1),
        
        // From frm decoder
        .frm_info_valid (frm_info_user_valid),
        .frm_info_data  (frm_info_user_data),
        .frm_info_error (frm_info_user_error),
        
        // From rs layer
        //.frm_data       (pl_frm_dec_data),
        //.frm_sop        (pl_frm_dec_sop),
        //.frm_eop        (pl_frm_dec_eop),
        .frm_valid      (pl_frm_dec_valid),
        //.frm_empty      (pl_frm_dec_empty),
        .frm_error      (pl_frm_dec_error),

        .txstatus_valid (user_txstatus_valid),
        .txstatus_data  (user_txstatus_data),
        .txstatus_error (user_txstatus_error)

    );
    
    //------------------------------------------------------------------------
    // 1588
    //------------------------------------------------------------------------
    generate 
    if (ENABLE_TIMESTAMPING) 
        begin
        alt_em10g32_tx_ptp_top #(
            .DEVICE_FAMILY      (DEVICE_FAMILY),
            .ENABLE_PTP_1STEP   (ENABLE_PTP_1STEP),
            .TSTAMP_FP_WIDTH             (TSTAMP_FP_WIDTH),
            .TX_XGMII_ADAPTER_PATH_DELAY (TX_XGMII_ADAPTER_PATH_DELAY),
            .ENABLE_MEM_ECC     (ENABLE_MEM_ECC),
            .TXDATAWIDTH        (TXDATAWIDTH),
            .TXEMPTYWIDTH       (TXEMPTYWIDTH),
            .TXSINKERRWIDTH     (TXUSRERRWIDTH),
            .FORWARD_SYNC_DEPTH     (FORWARD_SYNC_DEPTH),
            .BACKWARD_SYNC_DEPTH    (BACKWARD_SYNC_DEPTH),
            .ENABLE_GMII16B         (ENABLE_GMII16B),
            .TIME_OF_DAY_FORMAT (TIME_OF_DAY_FORMAT),
            .ENABLE_1G10G_MAC (ENABLE_1G10G_MAC)
        ) ptp_top_inst (
            // 10G clock (312.5MHz) and active low reset 
            .xgmii_clk                                      (clk),
            .xgmii_clk_rst_n                                (rst_n),
            
            // 1G/100M/10M clock (125MHz) and active low reset
            .gmii_clk                                       (clock_gmii),
            .gmii_clk_rst_n                                 (reset_gmii_n),
            
            // Current speed indication
            // 000=10Gbps
            // 001=1Gbps
            // 010=100Mbps
            // 011=10Mbps           
            // 100=2.5Gbps
            // 101=5Gbps
            .speed_sel                                      (speed_sel),
            .tx_clkena_half_rate                            (tx_clkena_half_rate),
            
            // User input for 1-step operations
            .tx_egress_p2p_update                           (tx_egress_p2p_update),
            .tx_egress_p2p_val                              (tx_egress_p2p_val),            
            .tx_egress_asymmetry_update                     (tx_egress_asymmetry_update),
            .tx_egress_timestamp_request_valid              (tx_egress_timestamp_request_valid),
            .tx_egress_timestamp_request_fingerprint        (tx_egress_timestamp_request_fingerprint),
            .tx_etstamp_ins_ctrl_timestamp_insert           (tx_etstamp_ins_ctrl_timestamp_insert),
            .tx_etstamp_ins_ctrl_timestamp_format           (tx_etstamp_ins_ctrl_timestamp_format),
            .tx_etstamp_ins_ctrl_residence_time_update      (tx_etstamp_ins_ctrl_residence_time_update),
            .tx_etstamp_ins_ctrl_ingress_timestamp_96b      (tx_etstamp_ins_ctrl_ingress_timestamp_96b),
            .tx_etstamp_ins_ctrl_ingress_timestamp_64b      (tx_etstamp_ins_ctrl_ingress_timestamp_64b),
            .tx_etstamp_ins_ctrl_residence_time_calc_format (tx_etstamp_ins_ctrl_residence_time_calc_format),
            .tx_etstamp_ins_ctrl_checksum_zero              (tx_etstamp_ins_ctrl_checksum_zero),
            .tx_etstamp_ins_ctrl_checksum_correct           (tx_etstamp_ins_ctrl_checksum_correct),
            .tx_etstamp_ins_ctrl_offset_timestamp           (tx_etstamp_ins_ctrl_offset_timestamp),
            .tx_etstamp_ins_ctrl_offset_correction_field    (tx_etstamp_ins_ctrl_offset_correction_field),
            .tx_etstamp_ins_ctrl_offset_checksum_field      (tx_etstamp_ins_ctrl_offset_checksum_field),
            .tx_etstamp_ins_ctrl_offset_checksum_correction (tx_etstamp_ins_ctrl_offset_checksum_correction),
            
            // Av-ST Data SOP / Valid
            .avst_sink_data_sop                             (frm_sink_sop),
            .avst_sink_data_valid                           (frm_sink_valid),
            .avst_sink_data_eop                             (frm_sink_eop),   
            .avst_sink_data_ready                           (frm_sink_ready),   
            .avst_sink_data_error                           (frm_sink_error),   
            .avst_sink_data_data                            (frm_sink_data),   
            .avst_sink_data_empty                           (frm_sink_empty),
            
            // XGMII / GMII Data Channel 
            .xgmii_sink_data_channel                        (xgmii2ptp_xgmii_channel[1]),
            .gmii_sink_data_channel                         (gmii2ptp_gmii_channel[1]),
            .gmii16b_sink_data_channel                      (gmii16b2ptp_gmii16b_channel[1]),
            
            // XGMII sink data
            .xgmii_sink_data                                ({xgmii2ptp_xgmii_control[3], xgmii2ptp_xgmii_data[31:24],xgmii2ptp_xgmii_control[2], xgmii2ptp_xgmii_data[23:16],xgmii2ptp_xgmii_control[1], xgmii2ptp_xgmii_data[15:8],xgmii2ptp_xgmii_control[0], xgmii2ptp_xgmii_data[7:0]}),
            //ED
            .xgmii_sink_valid                               (rs2top_eth_xgmii_valid),
            // GMII sink data
            .gmii_sink_control                              (gmii2ptp_gmii_control),
            .gmii_sink_data                                 (gmii2ptp_gmii_data),
            .gmii_sink_error                                (gmii2ptp_gmii_error),
            
            // GMII16B sink data
            .gmii16b_sink_control                           (gmii16b2ptp_gmii16b_control),
            .gmii16b_sink_data                              (gmii16b2ptp_gmii16b_data),
            .gmii16b_sink_error                             (gmii16b2ptp_gmii16b_error),
        
            // CSR CRC insert control
            .csr_tx_crc_inst_en                             (csr_tx_crc_inst_en),   
            
            // CSR
            // csr_adjust[31:16] = tx_adjust_ns
            // csr_adjust[15: 0] = tx_adjust_fns
            // csr_period[19:16] = period in ns
            // csr_period[15: 0] = period in fns
            .csr_adjust_10g                                 (csr_adjust_10g),
            .csr_period_10g                                 (csr_period_10g),
            .csr_adjust_1g                                  (csr_adjust_1g),
            .csr_period_1g                                  (csr_period_1g),
            .csr_asymmetry                                  (csr_asymmetry),
            .csr_p2p_dir_egress                             (csr_p2p_dir_egress),
            
            // Path delay data from PHY
            .tx_path_delay_10g_data                         (tx_path_delay_10g_data),
            .tx_path_delay_1g_data                          (tx_path_delay_1g_data),
            
            // ToD inputs for 10G and 1G/100M/10M   
            .tx_time_of_day_96b_10g_data                    (tx_time_of_day_96b_10g_data),
            .tx_time_of_day_64b_10g_data                    (tx_time_of_day_64b_10g_data),
            .tx_time_of_day_96b_1g_data                     (tx_time_of_day_96b_1g_data),
            .tx_time_of_day_64b_1g_data                     (tx_time_of_day_64b_1g_data),
            
            // XGMII source data
            .xgmii_src_data                                 ({ptp2xgmii_xgmii_control[3], ptp2xgmii_xgmii_data[31:24],ptp2xgmii_xgmii_control[2], ptp2xgmii_xgmii_data[23:16],ptp2xgmii_xgmii_control[1], ptp2xgmii_xgmii_data[15:8],ptp2xgmii_xgmii_control[0], ptp2xgmii_xgmii_data[7:0]}),
            
            // GMII source data
            .gmii_src_control                               (ptp2gmii_gmii_control),
            .gmii_src_data                                  (ptp2gmii_gmii_data),
            .gmii_src_error                                 (ptp2gmii_gmii_error),
            
            // GMII16B source data
            .gmii16b_src_control                            (ptp2gmii16b_gmii16b_control),
            .gmii16b_src_data                               (ptp2gmii16b_gmii16b_data),
            .gmii16b_src_error                              (ptp2gmii16b_gmii16b_error),
            
            // User output for fingerprint and timestamp
            .tx_egress_timestamp_96b_valid                  (tx_egress_timestamp_96b_valid),
            .tx_egress_timestamp_96b_data                   (tx_egress_timestamp_96b_data),
            .tx_egress_timestamp_96b_fingerprint            (tx_egress_timestamp_96b_fingerprint),
            .tx_egress_timestamp_64b_valid                  (tx_egress_timestamp_64b_valid),
            .tx_egress_timestamp_64b_data                   (tx_egress_timestamp_64b_data),
            .tx_egress_timestamp_64b_fingerprint            (tx_egress_timestamp_64b_fingerprint),
            
            // ECC Status
            .tx_ptp_request_control_ecc_err_corrected       (tx_ptp_request_control_ecc_err_corrected),
            .tx_ptp_request_control_ecc_err_fatal           (tx_ptp_request_control_ecc_err_fatal),
            
            .csr_tx_preamble_passthru                       (csr_tx_preamble_passthru),
            
            //cf error status
            .ingress_overflow                               (ingress_overflow),
            .egress_overflow                                (egress_overflow),
            .egress_rt_gt_4s                                (egress_rt_gt_4s),
            .egress_rt_neg                                  (egress_rt_neg),
            .cf_overflow_valid                              (cf_overflow_valid)             
        );
        end
    else
        begin
        assign ptp2xgmii_xgmii_control = 0;
        assign ptp2xgmii_xgmii_data = 0;
        assign ptp2gmii_gmii_control = 0;
        assign ptp2gmii_gmii_data = 0;
        assign ptp2gmii_gmii_error = 0;
        assign ptp2gmii16b_gmii16b_control = 0;
        assign ptp2gmii16b_gmii16b_data = 0;
        assign ptp2gmii16b_gmii16b_error = 0;
        
        assign tx_egress_timestamp_96b_valid = 0;
        assign tx_egress_timestamp_96b_data = 0;
        assign tx_egress_timestamp_96b_fingerprint = 0;
        assign tx_egress_timestamp_64b_valid = 0;
        assign tx_egress_timestamp_64b_data = 0;
        assign tx_egress_timestamp_64b_fingerprint = 0;
        assign tx_ptp_request_control_ecc_err_corrected = 0;
        assign tx_ptp_request_control_ecc_err_fatal = 0;
        
        assign ingress_overflow = 1'b0; 
        assign egress_overflow = 1'b0;
        assign egress_rt_gt_4s = 1'b0;
        assign egress_rt_neg = 1'b0;  
        assign cf_overflow_valid = 1'b0;        
        end
    endgenerate
    
endmodule
