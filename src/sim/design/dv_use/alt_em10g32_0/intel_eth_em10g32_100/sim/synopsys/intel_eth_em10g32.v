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


/////////////////////////////////////////////////////////////////////////////
// 
// Module: Altera Ethernet 32-bit MAC Wrapper
//
// Description: This module wraps around the 32-bit MAC and 64-32b adaptors
// depending on configuration
//
// Parameter:
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module intel_eth_em10g32 #(
    parameter DEVICE_FAMILY               = "Stratix V",
    
    parameter INSERT_ST_ADAPTOR           = 0,
    parameter INSERT_CSR_ADAPTOR          = 0,
    parameter INSERT_XGMII_ADAPTOR        = 1,
    parameter USE_ASYNC_ADAPTOR           = 0,
    
    parameter DATAPATH_OPTION             = 3,
    parameter ENABLE_SUPP_ADDR            = 0,
    parameter ENABLE_PFC                  = 0,
    parameter PFC_PRIORITY_NUMBER         = 8, // Min = 1
    parameter INSTANTIATE_STATISTICS      = 0,
    parameter REGISTER_BASED_STATISTICS   = 0,
    
    parameter PREAMBLE_PASSTHROUGH        = 0,
    parameter ENABLE_TIMESTAMPING         = 0,
    parameter ENABLE_PTP_1STEP            = 0,
    parameter ENABLE_ASYMMETRY            = 0,
    parameter ENABLE_P2P                  = 0,
    parameter TSTAMP_FP_WIDTH             = 4,
    parameter ENABLE_1G10G_MAC            = 0,
    parameter ENABLE_MEM_ECC              = 0,
    parameter ENABLE_UNIDIRECTIONAL       = 0,
    parameter ENABLE_TXRX_DATAPATH        = 0,
    parameter ENABLE_10GBASER_REG_MODE    = 0,
    parameter TIME_OF_DAY_FORMAT          = 2,
    parameter SYNC_RESET_N                = 1
 
) (

    // Clock and reset
    input wire tx_312_5_clk,
    input wire tx_156_25_clk,
    input wire tx_xcvr_clk,
    input wire tx_rst_n,
    
    input wire rx_312_5_clk,
    input wire rx_156_25_clk,
    input wire rx_xcvr_clk,
    input wire rx_rst_n,

    input wire csr_clk,
    input wire csr_rst_n,

    // Avalon-MM Slave
    input wire [(INSERT_CSR_ADAPTOR?12:9):0]   csr_address,                                    
    input wire          csr_read,
    input wire          csr_write,                                        
    input wire [31:0]   csr_writedata,                                
    output wire [31:0]  csr_readdata,                                  
    output wire         csr_waitrequest,                            
    
    // Speed Selection
    input wire [(ENABLE_1G10G_MAC >= 3 ? 2 : 1):0]   speed_sel,
    
    // TX path
    // Av-ST pause control path
    input wire [1:0]    avalon_st_pause_data,
    input wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_gen_data,

    // Av-ST sink data path
    input wire          avalon_st_tx_startofpacket,
    input wire          avalon_st_tx_endofpacket,
    input wire          avalon_st_tx_valid,
    input wire [(INSERT_ST_ADAPTOR?63:31):0]   avalon_st_tx_data,
    input wire [(INSERT_ST_ADAPTOR?2:1):0]    avalon_st_tx_empty,
    input wire          avalon_st_tx_error,

    output wire         avalon_st_tx_ready,

    // XGMII Transmit
    input wire [1:0]    link_fault_status_xgmii_tx_data,
    output wire [71:0]  xgmii_tx,
    output wire [(ENABLE_10GBASER_REG_MODE?63:31):0]  xgmii_tx_data,
    output wire [(ENABLE_10GBASER_REG_MODE?7:3):0]   xgmii_tx_control,
    output wire         xgmii_tx_valid,

    // GMII Transmit
    input  wire         gmii_tx_clk,
    output wire [7:0]   gmii_tx_d,
    output wire         gmii_tx_en,
    output wire         gmii_tx_err,
    
    // GMII 16 bit Transmit
    input  wire         gmii16b_tx_clk,
    output wire [15:0]  gmii16b_tx_d,
    output wire [ 1:0]  gmii16b_tx_en,
    output wire [ 1:0]  gmii16b_tx_err,
    
    // MII Transmit
    input  wire         tx_clkena,
    input  wire         tx_clkena_half_rate,
    output wire [3:0]   mii_tx_d,
    output wire         mii_tx_en,
    output wire         mii_tx_err,
    
    // Frame Info (User Logic)
    output wire         avalon_st_txstatus_valid,
    output wire [39:0]  avalon_st_txstatus_data,
    output wire [6:0]   avalon_st_txstatus_error,
    
    // Pause Quanta (For TX only variant)
    input  wire         avalon_st_tx_pause_length_valid,
    input  wire [15:0]  avalon_st_tx_pause_length_data,
    
    // PFC XON/XOFF Status
    output wire         avalon_st_tx_pfc_status_valid,
    output wire [15:0]  avalon_st_tx_pfc_status_data,
    
    
    // RX path
    // XGMII Receive
    input  wire [71:0]  xgmii_rx, 
    input  wire [(ENABLE_10GBASER_REG_MODE?63:31):0]  xgmii_rx_data,
    input  wire [(ENABLE_10GBASER_REG_MODE?7:3):0]   xgmii_rx_control,
    input  wire         xgmii_rx_valid,
    output wire [ 1:0]  link_fault_status_xgmii_rx_data,
    
    // GMII Receive
    input  wire         gmii_rx_clk,
    input  wire [ 7:0]  gmii_rx_d,
    input  wire         gmii_rx_dv,
    input  wire         gmii_rx_err,

    // GMII 16 bit receive
    input  wire         gmii16b_rx_clk,
    input  wire [15:0]  gmii16b_rx_d,
    input  wire [ 1:0]  gmii16b_rx_dv,
    input  wire [ 1:0]  gmii16b_rx_err,

    // MII Receive
    input  wire         rx_clkena,
    input  wire         rx_clkena_half_rate,
    input  wire [3:0]   mii_rx_d,
    input  wire         mii_rx_dv,
    input  wire         mii_rx_err,
    
    // Avalon-ST Receive (User)
    output wire [(INSERT_ST_ADAPTOR?63:31):0]  avalon_st_rx_data,
    output wire         avalon_st_rx_startofpacket,
    output wire         avalon_st_rx_endofpacket,
    output wire         avalon_st_rx_valid,
    output wire [(INSERT_ST_ADAPTOR?2:1):0]  avalon_st_rx_empty,
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
    
    // 1588 //ED
    
    input  wire [((ENABLE_1G10G_MAC==5)?23:15):0]  tx_path_delay_10g_data,
    //input  wire [23:0]  tx_path_delay_10g_data,
    input  wire [95:0]  tx_time_of_day_96b_10g_data,
    input  wire [63:0]  tx_time_of_day_64b_10g_data,

    input  wire [21:0]  tx_path_delay_1g_data,
    input  wire [95:0]  tx_time_of_day_96b_1g_data,
    input  wire [63:0]  tx_time_of_day_64b_1g_data,
    
    input  wire [((ENABLE_1G10G_MAC==5)?23:15):0]  rx_path_delay_10g_data,
    //input  wire [23:0]  rx_path_delay_10g_data,
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
    
    // Unidirectional port
    output  wire                       unidirectional_en,
    output  wire                       unidirectional_remote_fault_dis,
    output  wire                       unidirectional_force_remote_fault,

    // ECC Status
    output wire                        ecc_err_det_corr,
    output wire                        ecc_err_det_uncorr,
    
    // Sampling clock to measure latency of XGMII DC FIFO adapter
    input  wire                        latency_measure_sampling_clk // Give it a better name?
    
);

    // Local parameters
    localparam SYNCHRONIZER_DEPTH = 4;
    localparam TX_XGMII_ADAPTER_PATH_DELAY = (INSERT_XGMII_ADAPTOR ? (USE_ASYNC_ADAPTOR?3:2) :0) + ((ENABLE_UNIDIRECTIONAL)?2:0) + ((ENABLE_TIMESTAMPING & PREAMBLE_PASSTHROUGH & ENABLE_UNIDIRECTIONAL & ENABLE_PTP_1STEP == 0)?2:0);
    localparam RX_XGMII_ADAPTER_PATH_DELAY = (INSERT_XGMII_ADAPTOR ? (USE_ASYNC_ADAPTOR?7:2) :0);

    // Internal wires
    wire tx_clk_sync;
    wire rx_clk_sync;
    wire csr_clk_sync;
    wire gmii_tx_clk_sync;
    wire gmii_rx_clk_sync;

    wire tx_rst_n_sync;
    wire rx_rst_n_sync;
    wire csr_rst_n_sync;
    wire gmii_tx_rst_n_sync;
    wire gmii_rx_rst_n_sync;
    
    // Reset for statistics in TX/RX clock domain
    wire csr_rst_tx_clk_n;
    wire csr_rst_rx_clk_n;
    
    // Reset for clock crosser
    wire csr_tx_cc_in_rst_n;
    wire csr_tx_cc_out_rst_n;
    wire tx_csr_cc_in_rst_n;
    wire tx_csr_cc_out_rst_n;

    wire csr_gmii_tx_cc_in_rst_n;
    wire csr_gmii_tx_cc_out_rst_n;
    wire gmii_tx_csr_cc_in_rst_n;
    wire gmii_tx_csr_cc_out_rst_n;

    wire csr_rx_cc_in_rst_n;
    wire csr_rx_cc_out_rst_n;
    wire rx_csr_cc_in_rst_n;
    wire rx_csr_cc_out_rst_n;

    wire csr_gmii_rx_cc_in_rst_n;
    wire csr_gmii_rx_cc_out_rst_n;
    wire gmii_rx_csr_cc_in_rst_n;
    wire gmii_rx_csr_cc_out_rst_n;

    wire tx_rx_cc_in_rst_n;
    wire tx_rx_cc_out_rst_n;
    wire rx_tx_cc_in_rst_n;
    wire rx_tx_cc_out_rst_n;

    wire tx_156_25_clk_sync;
    wire tx_156_25_rst_n_sync;

    wire rx_156_25_clk_sync;
    wire rx_156_25_rst_n_sync;
    
    wire tx_sampling_rst_n_sync;
    wire rx_sampling_rst_n_sync;

    wire csr_ms_clk;
    wire csr_ms_rst_n;
    wire [31:0] csr_ms_readdata;
    wire [9:0]  csr_ms_address;
    wire        csr_ms_read;
    wire        csr_ms_write;
    wire [31:0] csr_ms_writedata;
    wire        csr_ms_waitrequest;

    wire [31:0] xgmii_rx_adpt_data;
    wire [3:0]  xgmii_rx_adpt_control;

    wire [31:0] xgmii_rx_format_adpt_data;
    wire [3:0]  xgmii_rx_format_adpt_control;
    wire        xgmii_rx_format_adpt_valid;

    wire [31:0] xgmii_tx_adpt_data;
    wire [3:0]  xgmii_tx_adpt_control;

    wire [63:0] xgmii_tx_format_adpt_data;
    wire [7:0]  xgmii_tx_format_adpt_control;
    wire        xgmii_tx_format_adpt_valid;

    wire        avalon_st_rx_adpt_ready;
    wire        avalon_st_rx_adpt_valid;
    wire [31:0] avalon_st_rx_adpt_data;
    wire [5:0]  avalon_st_rx_adpt_error;
    wire        avalon_st_rx_adpt_startofpacket;
    wire        avalon_st_rx_adpt_endofpacket;
    wire [1:0]  avalon_st_rx_adpt_empty;

    wire        avalon_st_tx_adpt_ready;
    wire        avalon_st_tx_adpt_valid;
    wire [31:0] avalon_st_tx_adpt_data;
    wire        avalon_st_tx_adpt_error;
    wire        avalon_st_tx_adpt_startofpacket;
    wire        avalon_st_tx_adpt_endofpacket;
    wire [1:0]  avalon_st_tx_adpt_empty;

    wire                        tx_adpt_egress_p2p_update;
    wire [45:0]                 tx_adpt_egress_p2p_val;
    wire                        tx_adpt_egress_asymmetry_update;
    wire                        tx_adpt_egress_timestamp_request_valid;
    wire [TSTAMP_FP_WIDTH-1:0]  tx_adpt_egress_timestamp_request_fingerprint;
    wire [95:0]                 tx_adpt_egress_timestamp_96b_data;
    wire                        tx_adpt_egress_timestamp_96b_valid;
    wire [TSTAMP_FP_WIDTH-1:0]  tx_adpt_egress_timestamp_96b_fingerprint;
    wire [63:0]                 tx_adpt_egress_timestamp_64b_data;
    wire                        tx_adpt_egress_timestamp_64b_valid;
    wire [TSTAMP_FP_WIDTH-1:0]  tx_adpt_egress_timestamp_64b_fingerprint;
    wire                        tx_adpt_etstamp_ins_ctrl_timestamp_insert;
    wire                        tx_adpt_etstamp_ins_ctrl_timestamp_format;
    wire                        tx_adpt_etstamp_ins_ctrl_residence_time_update;
    wire [95:0]                 tx_adpt_etstamp_ins_ctrl_ingress_timestamp_96b;
    wire [63:0]                 tx_adpt_etstamp_ins_ctrl_ingress_timestamp_64b;
    wire                        tx_adpt_etstamp_ins_ctrl_residence_time_calc_format;
    wire                        tx_adpt_etstamp_ins_ctrl_checksum_zero;
    wire                        tx_adpt_etstamp_ins_ctrl_checksum_correct;
    wire [15:0]                 tx_adpt_etstamp_ins_ctrl_offset_timestamp;
    wire [15:0]                 tx_adpt_etstamp_ins_ctrl_offset_correction_field;
    wire [15:0]                 tx_adpt_etstamp_ins_ctrl_offset_checksum_field;
    wire [15:0]                 tx_adpt_etstamp_ins_ctrl_offset_checksum_correction;

    wire                        avalon_st_adpt_txstatus_valid;
    wire [39:0]                 avalon_st_adpt_txstatus_data;
    wire [6:0]                  avalon_st_adpt_txstatus_error;

    wire [15:0]                 avalon_st_adpt_tx_pfc_data;   // TBD    
    wire                        avalon_st_adpt_tx_pfc_status_valid;
    wire [15:0]                 avalon_st_adpt_tx_pfc_status_data;
    
    wire [1:0]                  avalon_st_adpt_pause_data;   

    wire                        avalon_st_adpt_tx_pause_length_valid;
    wire [15:0]                 avalon_st_adpt_tx_pause_length_data; 

    wire                        rx_adpt_ingress_timestamp_96b_valid;
    wire [95:0]                 rx_adpt_ingress_timestamp_96b_data;
    wire                        rx_adpt_ingress_timestamp_64b_valid;
    wire [63:0]                 rx_adpt_ingress_timestamp_64b_data;
    
    wire                        rx_adpt_ingress_p2p_val_valid;
    wire [45:0]                 rx_adpt_ingress_p2p_val;

    wire                        avalon_st_adpt_rxstatus_valid;
    wire [39:0]                 avalon_st_adpt_rxstatus_data;
    wire [6:0]                  avalon_st_adpt_rxstatus_error;

    wire [7:0]                  avalon_st_adpt_rx_pfc_pause_data;
    wire                        avalon_st_adpt_rx_pfc_status_valid;
    wire [15:0]                 avalon_st_adpt_rx_pfc_status_data; 

    wire                        avalon_st_adpt_rx_pause_length_valid;
    wire [15:0]                 avalon_st_adpt_rx_pause_length_data; 
//from 17bits to 25bits
    wire [23:0]                 tx_adpt_path_delay_10g_data;
    wire [23:0]                 rx_adpt_path_delay_10g_data;
    wire [23:0]                 tx_path_delay_10g_data_expand;
    wire [23:0]                 rx_path_delay_10g_data_expand;
    wire                        csr_tx_adptdcff_rdwtrmrk_dis;
    wire [2:0]                  csr_tx_adptdcff_rdwtrmrk;
    wire [2:0]                  csr_tx_adptdcff_vldpkt_minwt;
    
    // csr reset to reset tx/rx path. 1 to reset 0 no reset
    wire                        csr_tx_data_path_reset;
    wire                        csr_rx_data_path_reset;
    
    wire                        tx_rst_n_final;
    wire                        rx_rst_n_final;
    
    // those inverted reset wire is use to connect to reset status
    wire                        tx_rst_final;
    wire                        rx_rst_final;    
    wire                        tx_156_25_rst_sync;
    wire                        rx_156_25_rst_sync;    
    wire                        gmii_tx_rst_sync;
    wire                        gmii_rx_rst_sync;
    
    wire                        tx_rst_status;
    wire                        rx_rst_status;
    wire                        tx_156_25_rst_status;
    wire                        rx_156_25_rst_status;
    wire                        gmii_tx_rst_status;
    wire                        gmii_rx_rst_status;
    
    wire                        tx_rst_n_status;
    wire                        rx_rst_n_status;
    wire                        tx_156_25_rst_n_status;
    wire                        rx_156_25_rst_n_status;
    wire                        gmii_tx_rst_n_status;
    wire                        gmii_rx_rst_n_status;
    
    wire                        status_tx_rst_sts;
    wire                        status_rx_rst_sts;
    
    wire [1:0] speed_sel_sync;
    
    
    assign tx_rst_n_final = ~csr_tx_data_path_reset & tx_rst_n;
    assign rx_rst_n_final = ~csr_rx_data_path_reset & rx_rst_n;
    


    // this register is use to backpressure TX path when tx reset asserted, and tx disable asserted
    wire                        tx_en;
    reg                         tx_en_n_floped;
    wire                        tx_en_floped;
    wire                        csr_tx_tsfr_en_n;
    wire                        tx_tsfr_en_n;
    wire                        tx_tsfr_en;
    wire                        avalon_st_tx_ready_temp;
    reg                         data_in_progress;
    
generate if(INSERT_ST_ADAPTOR)
begin
    always @ (posedge tx_156_25_clk_sync)
        begin
        if(~tx_156_25_rst_n_sync)
            begin
            data_in_progress <= 1'b0;
            end
        else
            begin
			// also need to qualify tx_tsfr_en because if tx_tsfr_en deasserted during EOP, it will cause data_in_progress go to 1, and then TX path will hang         
            if(tx_tsfr_en && avalon_st_tx_valid && avalon_st_tx_ready && avalon_st_tx_startofpacket)
                begin
                data_in_progress <= 1'b1;
                end
            // if eop and underflow occur    
            else if((avalon_st_tx_valid && avalon_st_tx_ready && avalon_st_tx_endofpacket) || (avalon_st_tx_ready && avalon_st_tx_valid == 1'b0))
                begin
                data_in_progress <= 1'b0;
                end
            end
        end
        
    wire csr_tx_tsfr_en_n_sync;       
        
    alt_em10g32_std_synchronizer #(
        .rst_value(1),
        .depth(2)
    ) sync_tx_transfer_control (
        .clk (tx_156_25_clk_sync),
        .reset_n (tx_156_25_rst_n_sync),
        .din (csr_tx_tsfr_en_n),
        .dout (csr_tx_tsfr_en_n_sync)
    );    
             
    assign tx_tsfr_en = ~csr_tx_tsfr_en_n_sync;          
    assign tx_en = (tx_tsfr_en | data_in_progress);    
    
    always @ (posedge tx_156_25_clk_sync)
        begin
        tx_en_n_floped <= ~tx_en;
        end
        
end
else
begin
	always @ (posedge tx_clk_sync)
        begin
        if(~tx_rst_n_sync)
            begin
            data_in_progress <= 1'b0;
            end
        else
            begin
			// also need to qualify tx_tsfr_en because if tx_tsfr_en deasserted during EOP, it will cause data_in_progress go to 1, and then TX path will hang         
            if(tx_tsfr_en && avalon_st_tx_valid && avalon_st_tx_ready && avalon_st_tx_startofpacket)
                begin
                data_in_progress <= 1'b1;
                end
            // if eop and underflow occur    
            else if((avalon_st_tx_valid && avalon_st_tx_ready && avalon_st_tx_endofpacket) || (avalon_st_tx_ready && avalon_st_tx_valid == 1'b0))
                begin
                data_in_progress <= 1'b0;
                end
            end
        end
        
    assign tx_tsfr_en = ~csr_tx_tsfr_en_n;    
    assign tx_en = (tx_tsfr_en | data_in_progress);
    
    always @ (posedge tx_clk_sync)
        begin
        tx_en_n_floped <= ~tx_en;
        end
        
end
endgenerate
    
    
    // this piece of logic is function for when csr_tx_en de-asserted, and there packet is still being process, 
    // we will wait until end of thise frame then only deasserted ready

    
          
    assign tx_en_floped = !tx_en_n_floped;
    assign avalon_st_tx_ready = avalon_st_tx_ready_temp & tx_en_floped;

    // tx and rx reset status
    assign tx_rst_status = ~tx_rst_n_status;
    assign rx_rst_status = ~rx_rst_n_status;
    assign tx_156_25_rst_status = ~tx_156_25_rst_n_status;
    assign rx_156_25_rst_status = ~rx_156_25_rst_n_status;
    assign gmii_tx_rst_status = ~gmii_tx_rst_n_status;
    assign gmii_rx_rst_status = ~gmii_rx_rst_n_status;
    
    reg flop_rx_rst_n_sync;
    reg flop_tx_rst_n_sync;
    reg flop2_rx_rst_n_sync;
    reg flop2_tx_rst_n_sync;
    
    always @ (posedge rx_clk_sync)
        begin
        flop_rx_rst_n_sync <= rx_rst_n_sync;
        flop2_rx_rst_n_sync <= flop_rx_rst_n_sync;
        end
        
    always @ (posedge tx_clk_sync)
        begin
        flop_tx_rst_n_sync <= tx_rst_n_sync;
        flop2_tx_rst_n_sync <= flop_tx_rst_n_sync;
        end
            
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) tx_rst_n_status_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (flop2_tx_rst_n_sync),
        .dout (tx_rst_n_status)
    ); 
    
    
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) rx_rst_n_status_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (flop2_rx_rst_n_sync),
        .dout (rx_rst_n_status)
    ); 
    
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) tx_156_25_rst_n_status_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (tx_156_25_rst_n_sync),
        .dout (tx_156_25_rst_n_status)
    ); 
    
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) rx_156_25_rst_n_status_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (rx_156_25_rst_n_sync),
        .dout (rx_156_25_rst_n_status)
    ); 
    
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) gmii_tx_rst_n_status_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (gmii_tx_rst_n_sync),
        .dout (gmii_tx_rst_n_status)
    ); 
    
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) gmii_rx_rst_n_status_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (gmii_rx_rst_n_sync),
        .dout (gmii_rx_rst_n_status)
    ); 
    
    alt_em10g32_dcfifo_synchronizer_bundle #(
       .DEPTH (2),
       .WIDTH (2)
    ) speed_sel_2bits_sync (
        .clk (csr_clk_sync),
        .reset_n (csr_rst_n_sync),
        .din (speed_sel[1:0]),
        .dout (speed_sel_sync[1:0])
    );
    
    // when using st adaptor or xgmii adaptor, then we need to include tx_156_25_rst_status. same for rx
    
     assign status_tx_rst_sts = (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7)? ( (speed_sel_sync == 3'b000) || (speed_sel_sync == 3'b101) ? tx_rst_status | (tx_156_25_rst_status & (INSERT_ST_ADAPTOR == 1 | INSERT_XGMII_ADAPTOR == 1)) :
                                                                                                                     tx_rst_status | (tx_156_25_rst_status & (INSERT_ST_ADAPTOR == 1 | INSERT_XGMII_ADAPTOR == 1)) | gmii_tx_rst_status ) :
                               (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6)? tx_rst_status | gmii_tx_rst_status:
                               (speed_sel_sync[0] == 1'b1 || speed_sel_sync[1] == 1)?tx_rst_status | tx_156_25_rst_status | gmii_tx_rst_status:tx_rst_status | (tx_156_25_rst_status & (INSERT_ST_ADAPTOR == 1 | INSERT_XGMII_ADAPTOR == 1));
    assign status_rx_rst_sts = (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7)? ( (speed_sel_sync == 3'b000) || (speed_sel_sync == 3'b101) ? rx_rst_status | (rx_156_25_rst_status & (INSERT_ST_ADAPTOR == 1 | INSERT_XGMII_ADAPTOR == 1)) :
                                                                                                                     rx_rst_status | (rx_156_25_rst_status & (INSERT_ST_ADAPTOR == 1 | INSERT_XGMII_ADAPTOR == 1)) | gmii_rx_rst_status ) :
                               (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6)? rx_rst_status | gmii_rx_rst_status:
                               (speed_sel_sync[0] == 1'b1 || speed_sel_sync[1] == 1)?rx_rst_status | rx_156_25_rst_status | gmii_rx_rst_status:rx_rst_status | (rx_156_25_rst_status & (INSERT_ST_ADAPTOR == 1 | INSERT_XGMII_ADAPTOR == 1));
    
    
    //------------------------------------------------------------------------
    // 32b MAC
    //------------------------------------------------------------------------
    alt_em10g32unit #(
        .DEVICE_FAMILY               ( DEVICE_FAMILY               ),
        
        .INSERT_ST_ADAPTOR           ( INSERT_ST_ADAPTOR           ),
        
        .DATAPATH_OPTION             ( DATAPATH_OPTION             ),
        .ENABLE_SUPP_ADDR            ( ENABLE_SUPP_ADDR            ),
        .ENABLE_PFC                  ( ENABLE_PFC                  ),
        .PFC_PRIORITY_NUMBER         ( PFC_PRIORITY_NUMBER         ),
        .INSTANTIATE_STATISTICS      ( INSTANTIATE_STATISTICS      ),
        .REGISTER_BASED_STATISTICS   ( REGISTER_BASED_STATISTICS   ),
                                                               
        .PREAMBLE_PASSTHROUGH        ( PREAMBLE_PASSTHROUGH        ),
        .ENABLE_TIMESTAMPING         ( ENABLE_TIMESTAMPING         ),
        .ENABLE_PTP_1STEP            ( ENABLE_PTP_1STEP            ),
        .ENABLE_ASYMMETRY            ( ENABLE_ASYMMETRY            ),
        .ENABLE_P2P                  ( ENABLE_P2P                  ),
        .TSTAMP_FP_WIDTH             ( TSTAMP_FP_WIDTH             ),
        .ENABLE_1G10G_MAC            ( ENABLE_1G10G_MAC            ),
        .ENABLE_MEM_ECC              ( ENABLE_MEM_ECC              ),
        .ENABLE_UNIDIRECTIONAL       ( ENABLE_UNIDIRECTIONAL       ),
        .ENABLE_10GBASER_REG_MODE    ( ENABLE_10GBASER_REG_MODE    ),
        .ENABLE_TXRX_DATAPATH        ( ENABLE_TXRX_DATAPATH        ),
        .TX_XGMII_ADAPTER_PATH_DELAY ( TX_XGMII_ADAPTER_PATH_DELAY ),
        .RX_XGMII_ADAPTER_PATH_DELAY ( RX_XGMII_ADAPTER_PATH_DELAY ),      
        .SYNCHRONIZER_DEPTH          ( SYNCHRONIZER_DEPTH          ),
        .TIME_OF_DAY_FORMAT          ( TIME_OF_DAY_FORMAT          ),
        .SYNC_RESET_N                ( SYNC_RESET_N                ) 
    ) alt_em10g32unit_inst (

        // Clock and reset
        .tx_clk_sync                (tx_clk_sync),
        .tx_rst_n_sync              (tx_rst_n_sync),
        
        .rx_clk_sync                (rx_clk_sync),
        .rx_rst_n_sync              (rx_rst_n_sync),
        
        .csr_clk_sync               (csr_clk_sync),
        .csr_rst_n_sync             (csr_rst_n_sync),
        
        .gmii_tx_clk_sync           (gmii_tx_clk_sync),
        .gmii_tx_rst_n_sync         (gmii_tx_rst_n_sync),
        
        .gmii_rx_clk_sync           (gmii_rx_clk_sync),
        .gmii_rx_rst_n_sync         (gmii_rx_rst_n_sync),
        
        // Reset for statistics in TX/RX clock domain
        .csr_rst_tx_clk_n           (csr_rst_tx_clk_n),
        .csr_rst_rx_clk_n           (csr_rst_rx_clk_n),
        
        // Reset for clock crosser
        .csr_tx_cc_in_rst_n         (csr_tx_cc_in_rst_n),
        .csr_tx_cc_out_rst_n        (csr_tx_cc_out_rst_n),
        .tx_csr_cc_in_rst_n         (tx_csr_cc_in_rst_n),
        .tx_csr_cc_out_rst_n        (tx_csr_cc_out_rst_n),
        
        .csr_gmii_tx_cc_in_rst_n    (csr_gmii_tx_cc_in_rst_n),
        .csr_gmii_tx_cc_out_rst_n   (csr_gmii_tx_cc_out_rst_n),
        .gmii_tx_csr_cc_in_rst_n    (gmii_tx_csr_cc_in_rst_n),
        .gmii_tx_csr_cc_out_rst_n   (gmii_tx_csr_cc_out_rst_n),
        
        .csr_rx_cc_in_rst_n         (csr_rx_cc_in_rst_n),
        .csr_rx_cc_out_rst_n        (csr_rx_cc_out_rst_n),
        .rx_csr_cc_in_rst_n         (rx_csr_cc_in_rst_n),
        .rx_csr_cc_out_rst_n        (rx_csr_cc_out_rst_n),
        
        .csr_gmii_rx_cc_in_rst_n    (csr_gmii_rx_cc_in_rst_n),
        .csr_gmii_rx_cc_out_rst_n   (csr_gmii_rx_cc_out_rst_n),
        .gmii_rx_csr_cc_in_rst_n    (gmii_rx_csr_cc_in_rst_n),
        .gmii_rx_csr_cc_out_rst_n   (gmii_rx_csr_cc_out_rst_n),
        
        .tx_rx_cc_in_rst_n          (tx_rx_cc_in_rst_n),
        .tx_rx_cc_out_rst_n         (tx_rx_cc_out_rst_n),
        .rx_tx_cc_in_rst_n          (rx_tx_cc_in_rst_n),
        .rx_tx_cc_out_rst_n         (rx_tx_cc_out_rst_n),
        
        // Avalon-MM Slave
        .csr_address                (csr_ms_address),                                 
        .csr_read                   (csr_ms_read),
        .csr_write                  (csr_ms_write),                                           
        .csr_writedata              (csr_ms_writedata),                                
        .csr_readdata               (csr_ms_readdata),                                  
        .csr_waitrequest            (csr_ms_waitrequest),                            
        
        // Speed Selection
        .speed_sel                  (speed_sel),
        
        // CSR Output
        .csr_tx_adptdcff_rdwtrmrk_dis (csr_tx_adptdcff_rdwtrmrk_dis),
        .csr_tx_adptdcff_rdwtrmrk     (csr_tx_adptdcff_rdwtrmrk),
        .csr_tx_adptdcff_vldpkt_minwt (csr_tx_adptdcff_vldpkt_minwt),
        
        // TX path
        // Av-ST pause control path
        .avalon_st_pause_data       (avalon_st_adpt_pause_data),
        .avalon_st_tx_pfc_gen_data  (avalon_st_adpt_tx_pfc_data),

        // Av-ST sink data path
        .avalon_st_tx_startofpacket (avalon_st_tx_adpt_startofpacket),
        .avalon_st_tx_endofpacket   (avalon_st_tx_adpt_endofpacket),
        .avalon_st_tx_valid         (avalon_st_tx_adpt_valid),
        .avalon_st_tx_data          (avalon_st_tx_adpt_data),
        .avalon_st_tx_empty         (avalon_st_tx_adpt_empty),
        .avalon_st_tx_error         (avalon_st_tx_adpt_error),
        .avalon_st_tx_ready         (avalon_st_tx_adpt_ready),

        // XGMII Transmit
        .link_fault_status_xgmii_tx_data (link_fault_status_xgmii_tx_data),
        .xgmii_tx_data              (xgmii_tx_adpt_data),
        .xgmii_tx_control           (xgmii_tx_adpt_control),
        .xgmii_tx_valid             (xgmii_tx_format_adpt_valid),

        // GMII Transmit
        .gmii_tx_d                  (gmii_tx_d),
        .gmii_tx_en                 (gmii_tx_en),
        .gmii_tx_err                (gmii_tx_err),

        // GMII 16 bit Transmit
        .gmii16b_tx_d               (gmii16b_tx_d),
        .gmii16b_tx_en              (gmii16b_tx_en),
        .gmii16b_tx_err             (gmii16b_tx_err),
        
        // MII Transmit
        .tx_clkena                  (tx_clkena),
        .tx_clkena_half_rate        (tx_clkena_half_rate),
        .mii_tx_d                   (mii_tx_d),
        .mii_tx_en                  (mii_tx_en),
        .mii_tx_err                 (mii_tx_err),
        
        // Frame Info (User Logic)
        .avalon_st_txstatus_valid   (avalon_st_adpt_txstatus_valid),
        .avalon_st_txstatus_data    (avalon_st_adpt_txstatus_data),
        .avalon_st_txstatus_error   (avalon_st_adpt_txstatus_error),
        
        // Pause Quanta (For TX only variant)
        .avalon_st_tx_pause_length_valid    (avalon_st_adpt_tx_pause_length_valid),
        .avalon_st_tx_pause_length_data     (avalon_st_adpt_tx_pause_length_data),
        
        // PFC XON/XOFF Status
        .avalon_st_tx_pfc_status_valid      (avalon_st_adpt_tx_pfc_status_valid),
        .avalon_st_tx_pfc_status_data       (avalon_st_adpt_tx_pfc_status_data),
        
        
        // RX path
        // XGMII Receive
        .xgmii_rx_data                      ((ENABLE_10GBASER_REG_MODE) ? xgmii_rx_format_adpt_data : xgmii_rx_adpt_data),
        .xgmii_rx_control                   ((ENABLE_10GBASER_REG_MODE) ? xgmii_rx_format_adpt_control : xgmii_rx_adpt_control),
        .xgmii_rx_valid                     (xgmii_rx_format_adpt_valid),
        .link_fault_status_xgmii_rx_data    (link_fault_status_xgmii_rx_data),
        
        // GMII Receive
        .gmii_rx_d                          (gmii_rx_d),
        .gmii_rx_dv                         (gmii_rx_dv),
        .gmii_rx_err                        (gmii_rx_err),

        // GMII 16 bit Receive
        .gmii16b_rx_d                       (gmii16b_rx_d),
        .gmii16b_rx_dv                      (gmii16b_rx_dv),
        .gmii16b_rx_err                     (gmii16b_rx_err),        

        // MII Receive
        .rx_clkena                          (rx_clkena),
        .rx_clkena_half_rate                (rx_clkena_half_rate),
        .mii_rx_d                           (mii_rx_d),
        .mii_rx_dv                          (mii_rx_dv),
        .mii_rx_err                         (mii_rx_err),
        
        // Avalon-ST Receive (User)
        .avalon_st_rx_data                  (avalon_st_rx_adpt_data),  
        .avalon_st_rx_startofpacket         (avalon_st_rx_adpt_startofpacket),
        .avalon_st_rx_endofpacket           (avalon_st_rx_adpt_endofpacket),
        .avalon_st_rx_valid                 (avalon_st_rx_adpt_valid),
        .avalon_st_rx_empty                 (avalon_st_rx_adpt_empty),
        .avalon_st_rx_error                 (avalon_st_rx_adpt_error),
        .avalon_st_rx_ready                 (avalon_st_rx_adpt_ready),
        
        // Frame Info (User Logic)
        .avalon_st_rxstatus_valid           (avalon_st_adpt_rxstatus_valid),
        .avalon_st_rxstatus_data            (avalon_st_adpt_rxstatus_data),
        .avalon_st_rxstatus_error           (avalon_st_adpt_rxstatus_error),
        
        // Pause Quanta (For RX only variant)
        .avalon_st_rx_pause_length_valid    (avalon_st_adpt_rx_pause_length_valid),
        .avalon_st_rx_pause_length_data     (avalon_st_adpt_rx_pause_length_data),
        
        // PFC XON/XOFF Status
        .avalon_st_rx_pfc_status_valid      (avalon_st_adpt_rx_pfc_status_valid),
        .avalon_st_rx_pfc_status_data       (avalon_st_adpt_rx_pfc_status_data),
        
        // PFC Pause Data
        .avalon_st_rx_pfc_pause_data        (avalon_st_adpt_rx_pfc_pause_data),
        
        // 1588
        .tx_path_delay_10g_data             (tx_adpt_path_delay_10g_data),
        .tx_time_of_day_96b_10g_data        (tx_time_of_day_96b_10g_data),
        .tx_time_of_day_64b_10g_data        (tx_time_of_day_64b_10g_data),
        
        .tx_path_delay_1g_data              (tx_path_delay_1g_data),
        .tx_time_of_day_96b_1g_data         (tx_time_of_day_96b_1g_data),
        .tx_time_of_day_64b_1g_data         (tx_time_of_day_64b_1g_data),
        
        .rx_path_delay_10g_data             (rx_adpt_path_delay_10g_data),
        .rx_time_of_day_96b_10g_data        (rx_time_of_day_96b_10g_data),
        .rx_time_of_day_64b_10g_data        (rx_time_of_day_64b_10g_data),
        
        .rx_path_delay_1g_data              (rx_path_delay_1g_data),
        .rx_time_of_day_96b_1g_data         (rx_time_of_day_96b_1g_data),
        .rx_time_of_day_64b_1g_data         (rx_time_of_day_64b_1g_data),
        
        .tx_egress_timestamp_96b_valid      (tx_adpt_egress_timestamp_96b_valid),
        .tx_egress_timestamp_96b_data       (tx_adpt_egress_timestamp_96b_data),
        .tx_egress_timestamp_96b_fingerprint(tx_adpt_egress_timestamp_96b_fingerprint),
        .tx_egress_timestamp_64b_valid      (tx_adpt_egress_timestamp_64b_valid),
        .tx_egress_timestamp_64b_data       (tx_adpt_egress_timestamp_64b_data),
        .tx_egress_timestamp_64b_fingerprint(tx_adpt_egress_timestamp_64b_fingerprint),
        
        .rx_ingress_timestamp_96b_valid     (rx_adpt_ingress_timestamp_96b_valid),
        .rx_ingress_timestamp_96b_data      (rx_adpt_ingress_timestamp_96b_data),
        .rx_ingress_timestamp_64b_valid     (rx_adpt_ingress_timestamp_64b_valid),
        .rx_ingress_timestamp_64b_data      (rx_adpt_ingress_timestamp_64b_data),
        
        .rx_ingress_p2p_val_valid           (rx_adpt_ingress_p2p_val_valid),
        .rx_ingress_p2p_val                 (rx_adpt_ingress_p2p_val),
        
        // User input for 1-step operations
        .tx_egress_p2p_update                          (tx_adpt_egress_p2p_update),
        .tx_egress_p2p_val                             (tx_adpt_egress_p2p_val),
        .tx_egress_asymmetry_update                    (tx_adpt_egress_asymmetry_update),
        .tx_egress_timestamp_request_valid             (tx_adpt_egress_timestamp_request_valid),
        .tx_egress_timestamp_request_fingerprint       (tx_adpt_egress_timestamp_request_fingerprint),
        .tx_etstamp_ins_ctrl_timestamp_insert          (tx_adpt_etstamp_ins_ctrl_timestamp_insert),
        .tx_etstamp_ins_ctrl_timestamp_format          (tx_adpt_etstamp_ins_ctrl_timestamp_format),
        .tx_etstamp_ins_ctrl_residence_time_update     (tx_adpt_etstamp_ins_ctrl_residence_time_update),
        .tx_etstamp_ins_ctrl_ingress_timestamp_96b     (tx_adpt_etstamp_ins_ctrl_ingress_timestamp_96b),
        .tx_etstamp_ins_ctrl_ingress_timestamp_64b     (tx_adpt_etstamp_ins_ctrl_ingress_timestamp_64b),
        .tx_etstamp_ins_ctrl_residence_time_calc_format(tx_adpt_etstamp_ins_ctrl_residence_time_calc_format),
        .tx_etstamp_ins_ctrl_checksum_zero             (tx_adpt_etstamp_ins_ctrl_checksum_zero),
        .tx_etstamp_ins_ctrl_checksum_correct          (tx_adpt_etstamp_ins_ctrl_checksum_correct),
        .tx_etstamp_ins_ctrl_offset_timestamp          (tx_adpt_etstamp_ins_ctrl_offset_timestamp),
        .tx_etstamp_ins_ctrl_offset_correction_field   (tx_adpt_etstamp_ins_ctrl_offset_correction_field),
        .tx_etstamp_ins_ctrl_offset_checksum_field     (tx_adpt_etstamp_ins_ctrl_offset_checksum_field),
        .tx_etstamp_ins_ctrl_offset_checksum_correction(tx_adpt_etstamp_ins_ctrl_offset_checksum_correction),
        
        .csr_tx_tsfr_en_n                   (csr_tx_tsfr_en_n),
        
        .tx_en                              (tx_en_floped),
        .tx_en_n                            (tx_en_n_floped),
        
        // Unidirectional port
        .unidirectional_en                  (unidirectional_en),
        .unidirectional_remote_fault_dis    (unidirectional_remote_fault_dis),  
		.unidirectional_force_remote_fault	(unidirectional_force_remote_fault),

        // csr to reset tx/rx path
        .csr_tx_data_path_reset             (csr_tx_data_path_reset),
        .csr_rx_data_path_reset             (csr_rx_data_path_reset), 

        // tx and rx reset status
        .status_tx_rst_sts                  (status_tx_rst_sts),
        .status_rx_rst_sts                  (status_rx_rst_sts),
        
        // ECC Status
        .ecc_err_det_corr                   (ecc_err_det_corr),
        .ecc_err_det_uncorr                 (ecc_err_det_uncorr)
        
        );
//ED
assign rx_path_delay_10g_data_expand = (ENABLE_1G10G_MAC == 5)? rx_path_delay_10g_data: {8'b0,rx_path_delay_10g_data};
assign tx_path_delay_10g_data_expand = (ENABLE_1G10G_MAC == 5)? tx_path_delay_10g_data: {8'b0,tx_path_delay_10g_data};
   //------------------------------------------------------------------------
   // XGMII adaptor
   //------------------------------------------------------------------------
   generate
   if (INSERT_XGMII_ADAPTOR && !ENABLE_10GBASER_REG_MODE) begin :  xgmii_adpt
        alt_em10g_32_64_xgmii_conversion #(
            .USE_ASYNC_ADAPTOR      (USE_ASYNC_ADAPTOR),
            .SYNC_RESET_N           (SYNC_RESET_N)
        ) xgmii_conv_inst (

            .tx_312_5_clk           (tx_clk_sync),      
            .tx_312_5_rst_n         (tx_rst_n_sync), 
            .rx_312_5_clk           (rx_clk_sync),  
            .rx_312_5_rst_n         (rx_rst_n_sync),
            .tx_156_25_clk          (tx_156_25_clk_sync),       
            .tx_156_25_rst_n        (tx_156_25_rst_n_sync),
            .rx_156_25_clk          (rx_156_25_clk_sync),       
            .rx_156_25_rst_n        (rx_156_25_rst_n_sync),
            .xgmii_tx_data_in       (xgmii_tx_adpt_data),
            .xgmii_tx_control_in    (xgmii_tx_adpt_control),
            .xgmii_tx               (xgmii_tx),  
            .xgmii_rx               (xgmii_rx),  
            .xgmii_rx_data_out      (xgmii_rx_adpt_data),
            .xgmii_rx_control_out   (xgmii_rx_adpt_control),
            .xgmii_rx_path_latency  (rx_path_delay_10g_data_expand[15:0]),
            .xgmii_tx_path_latency  (tx_path_delay_10g_data_expand[15:0]), 
            .st_tx_path_latency     (tx_adpt_path_delay_10g_data[16:0]), 
            .st_rx_path_latency     (rx_adpt_path_delay_10g_data[16:0]), 
            .tx_phase               (),
            .rx_phase               (),
            .sampling_clk           (latency_measure_sampling_clk),
            .tx_sampling_clk_rst_n  (tx_sampling_rst_n_sync),
            .rx_sampling_clk_rst_n  (rx_sampling_rst_n_sync)
        );
        assign tx_adpt_path_delay_10g_data[23:17]  = 7'b0;
        assign rx_adpt_path_delay_10g_data[23:17]  = 7'b0;
        assign xgmii_tx_data    = 32'b0;
        assign xgmii_tx_control = 4'h0;
    end
    else begin
        assign xgmii_tx             = 72'b0;
        assign xgmii_tx_data        = (ENABLE_10GBASER_REG_MODE)?xgmii_tx_format_adpt_data:xgmii_tx_adpt_data;
        assign xgmii_tx_control     = (ENABLE_10GBASER_REG_MODE)?xgmii_tx_format_adpt_control:xgmii_tx_adpt_control;
        assign xgmii_rx_adpt_data   = xgmii_rx_data[31:0];
        assign xgmii_rx_adpt_control= xgmii_rx_control[3:0];
        assign tx_adpt_path_delay_10g_data = tx_path_delay_10g_data_expand;
        assign rx_adpt_path_delay_10g_data = rx_path_delay_10g_data_expand;
    end
    endgenerate



    //------------------------------------------------------------------------
    // ST adaptor
    //------------------------------------------------------------------------
    generate
    if (INSERT_ST_ADAPTOR) begin : st_adpt
        altera_eth_avalon_st_adapter # ( 
            .DEVICE_FAMILY      (DEVICE_FAMILY),
            
            .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
            
            .DATAPATH_OPTION    (DATAPATH_OPTION),
            .ENABLE_PFC         (ENABLE_PFC),
            .PFC_PRIORITY_NUMBER(8), // Use the maximum width for the PFC buses based on current top level and hw.tcl behavior
            
            .ENABLE_TIMESTAMPING(ENABLE_TIMESTAMPING),
            .TSTAMP_FP_WIDTH    (TSTAMP_FP_WIDTH),
            .TIME_OF_DAY_FORMAT (TIME_OF_DAY_FORMAT),
            .SYNC_RESET_N(SYNC_RESET_N)
        ) avalon_st_adpt_inst (
            // CSR
            .csr_tx_adptdcff_rdwtrmrk_dis     (csr_tx_adptdcff_rdwtrmrk_dis),
            .csr_tx_adptdcff_rdwtrmrk         (csr_tx_adptdcff_rdwtrmrk),
            .csr_tx_adptdcff_vldpkt_minwt     (csr_tx_adptdcff_vldpkt_minwt),
            
            // tx clock and reset  
            .avalon_st_tx_clk_312             (tx_clk_sync),    
            .avalon_st_tx_312_reset_n         (flop2_tx_rst_n_sync),    
            .avalon_st_tx_clk_156             (tx_156_25_clk_sync),          
            .avalon_st_tx_156_reset_n         (tx_156_25_rst_n_sync),
        
            // tx avst signal at 156mhz domain
            .avalon_st_tx_156_ready           (avalon_st_tx_ready_temp),
            .avalon_st_tx_156_valid           (avalon_st_tx_valid & tx_en_floped),
            .avalon_st_tx_156_data            (avalon_st_tx_data),
            .avalon_st_tx_156_error           (avalon_st_tx_error),             
            .avalon_st_tx_156_startofpacket   (avalon_st_tx_startofpacket),
            .avalon_st_tx_156_endofpacket     (avalon_st_tx_endofpacket),  
            .avalon_st_tx_156_empty           (avalon_st_tx_empty),

            // tx avst signal at 312mhz domain    
            .avalon_st_tx_312_ready           (avalon_st_tx_adpt_ready),         
            .avalon_st_tx_312_valid           (avalon_st_tx_adpt_valid),
            .avalon_st_tx_312_data            (avalon_st_tx_adpt_data),
            .avalon_st_tx_312_error           (avalon_st_tx_adpt_error),        
            .avalon_st_tx_312_startofpacket   (avalon_st_tx_adpt_startofpacket),
            .avalon_st_tx_312_endofpacket     (avalon_st_tx_adpt_endofpacket),  
            .avalon_st_tx_312_empty           (avalon_st_tx_adpt_empty),

            // rx clock and reset    
            .avalon_st_rx_clk_312             (rx_clk_sync),          
            .avalon_st_rx_312_reset_n         (flop2_rx_rst_n_sync),    
            .avalon_st_rx_clk_156             (rx_156_25_clk_sync),          
            .avalon_st_rx_156_reset_n         (rx_156_25_rst_n_sync),
            
            // rx avst signal at 312mhz domain
            .avalon_st_rx_312_ready           (avalon_st_rx_adpt_ready),
            .avalon_st_rx_312_valid           (avalon_st_rx_adpt_valid),
            .avalon_st_rx_312_data            (avalon_st_rx_adpt_data),
            .avalon_st_rx_312_error           (avalon_st_rx_adpt_error),
            .avalon_st_rx_312_startofpacket   (avalon_st_rx_adpt_startofpacket),
            .avalon_st_rx_312_endofpacket     (avalon_st_rx_adpt_endofpacket),
            .avalon_st_rx_312_empty           (avalon_st_rx_adpt_empty),

            // rx avst signal at 156mhz domain    
            .avalon_st_rx_156_ready          (avalon_st_rx_ready),
            .avalon_st_rx_156_valid          (avalon_st_rx_valid),
            .avalon_st_rx_156_data           (avalon_st_rx_data),
            .avalon_st_rx_156_error          (avalon_st_rx_error),
            .avalon_st_rx_156_startofpacket  (avalon_st_rx_startofpacket),
            .avalon_st_rx_156_endofpacket    (avalon_st_rx_endofpacket),
            .avalon_st_rx_156_empty          (avalon_st_rx_empty),

            // TX 1588 signals at 156mhz domain
            .tx_egress_p2p_update_156                             (tx_egress_p2p_update),
            .tx_egress_p2p_val_156                                (tx_egress_p2p_val),
            .tx_egress_asymmetry_update_156                       (tx_egress_asymmetry_update),
            .tx_egress_timestamp_request_valid_156                (tx_egress_timestamp_request_valid),
            .tx_egress_timestamp_request_fingerprint_156          (tx_egress_timestamp_request_fingerprint),
            .tx_egress_timestamp_96b_data_156                     (tx_egress_timestamp_96b_data),
            .tx_egress_timestamp_96b_valid_156                    (tx_egress_timestamp_96b_valid),
            .tx_egress_timestamp_96b_fingerprint_156              (tx_egress_timestamp_96b_fingerprint),
            .tx_egress_timestamp_64b_data_156                     (tx_egress_timestamp_64b_data),
            .tx_egress_timestamp_64b_valid_156                    (tx_egress_timestamp_64b_valid),
            .tx_egress_timestamp_64b_fingerprint_156              (tx_egress_timestamp_64b_fingerprint),
            .tx_etstamp_ins_ctrl_timestamp_insert_156             (tx_etstamp_ins_ctrl_timestamp_insert),
            .tx_etstamp_ins_ctrl_timestamp_format_156             (tx_etstamp_ins_ctrl_timestamp_format),
            .tx_etstamp_ins_ctrl_residence_time_update_156        (tx_etstamp_ins_ctrl_residence_time_update),
            .tx_etstamp_ins_ctrl_ingress_timestamp_96b_156        (tx_etstamp_ins_ctrl_ingress_timestamp_96b),
            .tx_etstamp_ins_ctrl_ingress_timestamp_64b_156        (tx_etstamp_ins_ctrl_ingress_timestamp_64b),
            .tx_etstamp_ins_ctrl_residence_time_calc_format_156   (tx_etstamp_ins_ctrl_residence_time_calc_format),
            .tx_etstamp_ins_ctrl_checksum_zero_156                (tx_etstamp_ins_ctrl_checksum_zero),
            .tx_etstamp_ins_ctrl_checksum_correct_156             (tx_etstamp_ins_ctrl_checksum_correct),
            .tx_etstamp_ins_ctrl_offset_timestamp_156             (tx_etstamp_ins_ctrl_offset_timestamp),
            .tx_etstamp_ins_ctrl_offset_correction_field_156      (tx_etstamp_ins_ctrl_offset_correction_field),
            .tx_etstamp_ins_ctrl_offset_checksum_field_156        (tx_etstamp_ins_ctrl_offset_checksum_field),
            .tx_etstamp_ins_ctrl_offset_checksum_correction_156   (tx_etstamp_ins_ctrl_offset_checksum_correction),
        
            // TX 1588 signals at 312mhz domain
            .tx_egress_p2p_update_312                             (tx_adpt_egress_p2p_update),
            .tx_egress_p2p_val_312                                (tx_adpt_egress_p2p_val),
            .tx_egress_asymmetry_update_312                       (tx_adpt_egress_asymmetry_update),
            .tx_egress_timestamp_request_valid_312                (tx_adpt_egress_timestamp_request_valid),
            .tx_egress_timestamp_request_fingerprint_312          (tx_adpt_egress_timestamp_request_fingerprint),
            .tx_egress_timestamp_96b_data_312                     (tx_adpt_egress_timestamp_96b_data),
            .tx_egress_timestamp_96b_valid_312                    (tx_adpt_egress_timestamp_96b_valid),
            .tx_egress_timestamp_96b_fingerprint_312              (tx_adpt_egress_timestamp_96b_fingerprint),
            .tx_egress_timestamp_64b_data_312                     (tx_adpt_egress_timestamp_64b_data),
            .tx_egress_timestamp_64b_valid_312                    (tx_adpt_egress_timestamp_64b_valid),
            .tx_egress_timestamp_64b_fingerprint_312              (tx_adpt_egress_timestamp_64b_fingerprint),
            .tx_etstamp_ins_ctrl_timestamp_insert_312             (tx_adpt_etstamp_ins_ctrl_timestamp_insert),
            .tx_etstamp_ins_ctrl_timestamp_format_312             (tx_adpt_etstamp_ins_ctrl_timestamp_format),
            .tx_etstamp_ins_ctrl_residence_time_update_312        (tx_adpt_etstamp_ins_ctrl_residence_time_update),
            .tx_etstamp_ins_ctrl_ingress_timestamp_96b_312        (tx_adpt_etstamp_ins_ctrl_ingress_timestamp_96b),
            .tx_etstamp_ins_ctrl_ingress_timestamp_64b_312        (tx_adpt_etstamp_ins_ctrl_ingress_timestamp_64b),
            .tx_etstamp_ins_ctrl_residence_time_calc_format_312   (tx_adpt_etstamp_ins_ctrl_residence_time_calc_format),
            .tx_etstamp_ins_ctrl_checksum_zero_312                (tx_adpt_etstamp_ins_ctrl_checksum_zero),
            .tx_etstamp_ins_ctrl_checksum_correct_312             (tx_adpt_etstamp_ins_ctrl_checksum_correct),
            .tx_etstamp_ins_ctrl_offset_timestamp_312             (tx_adpt_etstamp_ins_ctrl_offset_timestamp),
            .tx_etstamp_ins_ctrl_offset_correction_field_312      (tx_adpt_etstamp_ins_ctrl_offset_correction_field),
            .tx_etstamp_ins_ctrl_offset_checksum_field_312        (tx_adpt_etstamp_ins_ctrl_offset_checksum_field),
            .tx_etstamp_ins_ctrl_offset_checksum_correction_312   (tx_adpt_etstamp_ins_ctrl_offset_checksum_correction),

            // TX Status Signals
            .avalon_st_txstatus_valid_156             (avalon_st_txstatus_valid),
            .avalon_st_txstatus_data_156              (avalon_st_txstatus_data),
            .avalon_st_txstatus_error_156             (avalon_st_txstatus_error),

            .avalon_st_txstatus_valid_312             (avalon_st_adpt_txstatus_valid),
            .avalon_st_txstatus_data_312              (avalon_st_adpt_txstatus_data),
            .avalon_st_txstatus_error_312             (avalon_st_adpt_txstatus_error),
        
            // TX PFC Status Signals
            .avalon_st_tx_pfc_data_156                (avalon_st_tx_pfc_gen_data),               
            .avalon_st_tx_pfc_status_valid_156        (avalon_st_tx_pfc_status_valid),
            .avalon_st_tx_pfc_status_data_156         (avalon_st_tx_pfc_status_data),
                                                                                      
            .avalon_st_tx_pfc_data_312                (avalon_st_adpt_tx_pfc_data),       
            .avalon_st_tx_pfc_status_valid_312        (avalon_st_adpt_tx_pfc_status_valid),
            .avalon_st_tx_pfc_status_data_312         (avalon_st_adpt_tx_pfc_status_data), 
            
            // TX Pause Data
            .avalon_st_tx_pause_data_156              (avalon_st_pause_data),
            .avalon_st_tx_pause_data_312              (avalon_st_adpt_pause_data),  
            
            // Pause Quanta (For TX only variant)
            .avalon_st_tx_pause_length_valid_156      (avalon_st_tx_pause_length_valid),
            .avalon_st_tx_pause_length_data_156       (avalon_st_tx_pause_length_data),
                                                                                        
            .avalon_st_tx_pause_length_valid_312      (avalon_st_adpt_tx_pause_length_valid),
            .avalon_st_tx_pause_length_data_312       (avalon_st_adpt_tx_pause_length_data), 

            // RX 1588 signals
            .rx_ingress_timestamp_96b_valid_312       (rx_adpt_ingress_timestamp_96b_valid),
            .rx_ingress_timestamp_96b_data_312        (rx_adpt_ingress_timestamp_96b_data),
            .rx_ingress_timestamp_64b_valid_312       (rx_adpt_ingress_timestamp_64b_valid),
            .rx_ingress_timestamp_64b_data_312        (rx_adpt_ingress_timestamp_64b_data),
                                                                                       
            .rx_ingress_timestamp_96b_valid_156       (rx_ingress_timestamp_96b_valid),
            .rx_ingress_timestamp_96b_data_156        (rx_ingress_timestamp_96b_data),
            .rx_ingress_timestamp_64b_valid_156       (rx_ingress_timestamp_64b_valid),
            .rx_ingress_timestamp_64b_data_156        (rx_ingress_timestamp_64b_data),
            
            .rx_ingress_p2p_val_valid_312             (rx_adpt_ingress_p2p_val_valid),
            .rx_ingress_p2p_val_312                   (rx_adpt_ingress_p2p_val),
            
            .rx_ingress_p2p_val_valid_156             (rx_ingress_p2p_val_valid),
            .rx_ingress_p2p_val_156                   (rx_ingress_p2p_val),            

            // RX Status Signals
            .avalon_st_rxstatus_valid_156             (avalon_st_rxstatus_valid),
            .avalon_st_rxstatus_data_156              (avalon_st_rxstatus_data),
            .avalon_st_rxstatus_error_156             (avalon_st_rxstatus_error),
                                                                                  
            .avalon_st_rxstatus_valid_312             (avalon_st_adpt_rxstatus_valid),
            .avalon_st_rxstatus_data_312              (avalon_st_adpt_rxstatus_data),
            .avalon_st_rxstatus_error_312             (avalon_st_adpt_rxstatus_error),

            // RX PFC Status Signals
            .avalon_st_rx_pfc_pause_data_312          (avalon_st_adpt_rx_pfc_pause_data),
            .avalon_st_rx_pfc_status_valid_312        (avalon_st_adpt_rx_pfc_status_valid),
            .avalon_st_rx_pfc_status_data_312         (avalon_st_adpt_rx_pfc_status_data), 
                                                                                      
            .avalon_st_rx_pfc_pause_data_156          (avalon_st_rx_pfc_pause_data),
            .avalon_st_rx_pfc_status_valid_156        (avalon_st_rx_pfc_status_valid),
            .avalon_st_rx_pfc_status_data_156         (avalon_st_rx_pfc_status_data),
            
            // Pause Quanta (For RX only variant)
            .avalon_st_rx_pause_length_valid_312      (avalon_st_adpt_rx_pause_length_valid),
            .avalon_st_rx_pause_length_data_312       (avalon_st_adpt_rx_pause_length_data), 
                                                                                         
            .avalon_st_rx_pause_length_valid_156      (avalon_st_rx_pause_length_valid),
            .avalon_st_rx_pause_length_data_156       (avalon_st_rx_pause_length_data) 

        );
    end
    else begin
        assign  avalon_st_tx_ready_temp         = avalon_st_tx_adpt_ready;   
        assign  avalon_st_tx_adpt_valid         = avalon_st_tx_valid & tx_en_floped;
        assign  avalon_st_tx_adpt_data          = avalon_st_tx_data[31:0];
        assign  avalon_st_tx_adpt_error         = avalon_st_tx_error; 
        assign  avalon_st_tx_adpt_startofpacket = avalon_st_tx_startofpacket;
        assign  avalon_st_tx_adpt_endofpacket   = avalon_st_tx_endofpacket;
        assign  avalon_st_tx_adpt_empty         = avalon_st_tx_empty[1:0];
    
        assign  avalon_st_rx_adpt_ready         = avalon_st_rx_ready;   
        assign  avalon_st_rx_valid              = avalon_st_rx_adpt_valid;
        assign  avalon_st_rx_data               = avalon_st_rx_adpt_data;
        assign  avalon_st_rx_error              = avalon_st_rx_adpt_error; 
        assign  avalon_st_rx_startofpacket      = avalon_st_rx_adpt_startofpacket;
        assign  avalon_st_rx_endofpacket        = avalon_st_rx_adpt_endofpacket;
        assign  avalon_st_rx_empty              = avalon_st_rx_adpt_empty;

        // TX 1588 signals
        assign tx_adpt_egress_p2p_update                            = tx_egress_p2p_update;
        assign tx_adpt_egress_p2p_val                               = tx_egress_p2p_val;
        assign tx_adpt_egress_asymmetry_update                      = tx_egress_asymmetry_update;
        assign tx_adpt_egress_timestamp_request_valid               = tx_egress_timestamp_request_valid;
        assign tx_adpt_egress_timestamp_request_fingerprint         = tx_egress_timestamp_request_fingerprint;
        assign tx_egress_timestamp_96b_data                         = tx_adpt_egress_timestamp_96b_data;
        assign tx_egress_timestamp_96b_valid                        = tx_adpt_egress_timestamp_96b_valid;
        assign tx_egress_timestamp_96b_fingerprint                  = tx_adpt_egress_timestamp_96b_fingerprint;
        assign tx_egress_timestamp_64b_data                         = tx_adpt_egress_timestamp_64b_data;
        assign tx_egress_timestamp_64b_valid                        = tx_adpt_egress_timestamp_64b_valid;
        assign tx_egress_timestamp_64b_fingerprint                  = tx_adpt_egress_timestamp_64b_fingerprint;
        assign tx_adpt_etstamp_ins_ctrl_timestamp_insert            = tx_etstamp_ins_ctrl_timestamp_insert;
        assign tx_adpt_etstamp_ins_ctrl_timestamp_format            = tx_etstamp_ins_ctrl_timestamp_format;
        assign tx_adpt_etstamp_ins_ctrl_residence_time_update       = tx_etstamp_ins_ctrl_residence_time_update;
        assign tx_adpt_etstamp_ins_ctrl_ingress_timestamp_96b       = tx_etstamp_ins_ctrl_ingress_timestamp_96b;
        assign tx_adpt_etstamp_ins_ctrl_ingress_timestamp_64b       = tx_etstamp_ins_ctrl_ingress_timestamp_64b;
        assign tx_adpt_etstamp_ins_ctrl_residence_time_calc_format  = tx_etstamp_ins_ctrl_residence_time_calc_format;
        assign tx_adpt_etstamp_ins_ctrl_checksum_zero               = tx_etstamp_ins_ctrl_checksum_zero;
        assign tx_adpt_etstamp_ins_ctrl_checksum_correct            = tx_etstamp_ins_ctrl_checksum_correct;
        assign tx_adpt_etstamp_ins_ctrl_offset_timestamp            = tx_etstamp_ins_ctrl_offset_timestamp;
        assign tx_adpt_etstamp_ins_ctrl_offset_correction_field     = tx_etstamp_ins_ctrl_offset_correction_field;
        assign tx_adpt_etstamp_ins_ctrl_offset_checksum_field       = tx_etstamp_ins_ctrl_offset_checksum_field;
        assign tx_adpt_etstamp_ins_ctrl_offset_checksum_correction  = tx_etstamp_ins_ctrl_offset_checksum_correction;

        // TX Status
        assign avalon_st_txstatus_valid             = avalon_st_adpt_txstatus_valid;
        assign avalon_st_txstatus_data              = avalon_st_adpt_txstatus_data;    
        assign avalon_st_txstatus_error             = avalon_st_adpt_txstatus_error;

        // TX PFC Status
        assign avalon_st_adpt_tx_pfc_data           = avalon_st_tx_pfc_gen_data;
        assign avalon_st_tx_pfc_status_valid        = avalon_st_adpt_tx_pfc_status_valid;     
        assign avalon_st_tx_pfc_status_data         = avalon_st_adpt_tx_pfc_status_data;     

        // TX Pause Data
        assign avalon_st_adpt_pause_data            = avalon_st_pause_data;
        
        // Pause Quanta (For TX only variant)
        assign avalon_st_adpt_tx_pause_length_valid = avalon_st_tx_pause_length_valid;
        assign avalon_st_adpt_tx_pause_length_data  = avalon_st_tx_pause_length_data;

        // RX 1588 signals
        assign rx_ingress_timestamp_96b_valid       = rx_adpt_ingress_timestamp_96b_valid;
        assign rx_ingress_timestamp_96b_data        = rx_adpt_ingress_timestamp_96b_data;
        assign rx_ingress_timestamp_64b_valid       = rx_adpt_ingress_timestamp_64b_valid;
        assign rx_ingress_timestamp_64b_data        = rx_adpt_ingress_timestamp_64b_data;
        
        //meanPathDelay (p2p)
        assign rx_ingress_p2p_val_valid             = rx_adpt_ingress_p2p_val_valid;
        assign rx_ingress_p2p_val                   = rx_adpt_ingress_p2p_val;        

        // RX Status Signals
        assign avalon_st_rxstatus_valid             = avalon_st_adpt_rxstatus_valid;        
        assign avalon_st_rxstatus_data              = avalon_st_adpt_rxstatus_data;
        assign avalon_st_rxstatus_error             = avalon_st_adpt_rxstatus_error;
        
        // RX PFC Status Signals
        assign avalon_st_rx_pfc_pause_data          = avalon_st_adpt_rx_pfc_pause_data;   
        assign avalon_st_rx_pfc_status_valid        = avalon_st_adpt_rx_pfc_status_valid;
        assign avalon_st_rx_pfc_status_data         = avalon_st_adpt_rx_pfc_status_data;

        // Pause Quanta (For RX only variant) 
        assign avalon_st_rx_pause_length_valid = avalon_st_adpt_rx_pause_length_valid;
        assign avalon_st_rx_pause_length_data  = avalon_st_adpt_rx_pause_length_data;
         
    end
    endgenerate

    //------------------------------------------------------------------------
    // MM adaptor
    //------------------------------------------------------------------------
    generate
    if (INSERT_CSR_ADAPTOR) begin : csr_adpt
        altera_eth_avalon_mm_adapter avalon_mm_adapter (
            // Avalon Slave Interface
            .sl_clock            (csr_clk),
            .sl_reset            (csr_rst_n),    
            .sl_csr_readdata_o   (csr_readdata),
            .sl_csr_address_i    (csr_address),
            .sl_csr_read_i       (csr_read),
            .sl_csr_write_i      (csr_write),
            .sl_csr_writedata_i  (csr_writedata),
            .sl_csr_waitrequest_o(csr_waitrequest),
   
            // Avalon Master Interface
            .ms_clock           (csr_ms_clk),
            .ms_reset           (csr_ms_rst_n),    
            .ms_csr_readdata_i  (csr_ms_readdata),
            .ms_csr_address_o   (csr_ms_address),
            .ms_csr_read_o      (csr_ms_read),
            .ms_csr_write_o     (csr_ms_write),
            .ms_csr_writedata_o (csr_ms_writedata),
            .ms_csr_waitrequest_i(csr_ms_waitrequest)
        );
    end
    else begin
        assign csr_ms_clk       = csr_clk;
        assign csr_ms_rst_n     = csr_rst_n;
        assign csr_readdata     = csr_ms_readdata;
        assign csr_ms_address   = csr_address[9:0];
        assign csr_ms_write     = csr_write;
        assign csr_ms_writedata = csr_writedata;
        assign csr_ms_read      = csr_read;
        assign csr_waitrequest  = csr_ms_waitrequest; 
    end
    endgenerate

    //------------------------------------------------------------------------
    // XGMII Data Format adapter
    //------------------------------------------------------------------------
    generate
    if (ENABLE_10GBASER_REG_MODE) begin : xgmii_format_adpt
        alt_em10g32_xgmii_data_format_adapter #(
          .SYNC_RESET_N(SYNC_RESET_N)
        ) xgmii_data_format_adapter (
            // TX 32 to 64 conversion
            .tx_clk          (tx_clk_sync),
            .tx_reset_n      (tx_rst_n_sync),    
            .tx_in_data      (xgmii_tx_adpt_data),
            .tx_in_control   (xgmii_tx_adpt_control),
            .tx_in_valid     (xgmii_tx_format_adpt_valid),
            .tx_in_ready     (),
            .tx_out_data     (xgmii_tx_format_adpt_data),
            .tx_out_control  (xgmii_tx_format_adpt_control),
            .tx_out_valid    (xgmii_tx_valid),
            .tx_out_ready    (1'b1),
   
            // RX 64 to 32 conversion
            .rx_clk          (rx_clk_sync),
            .rx_reset_n      (rx_rst_n_sync),    
            .rx_in_data      (xgmii_rx_data),
            .rx_in_control   (xgmii_rx_control),
            .rx_in_valid     (xgmii_rx_valid),
            // .rx_in_ready     (),
            .rx_out_data     (xgmii_rx_format_adpt_data),
            .rx_out_control  (xgmii_rx_format_adpt_control),
            .rx_out_valid    (xgmii_rx_format_adpt_valid),
            .rx_out_ready    (1'b1)
        );
    end
    else begin
        assign xgmii_tx_valid = xgmii_tx_format_adpt_valid;
        assign xgmii_rx_format_adpt_data       = 32'b0;
        assign xgmii_rx_format_adpt_control       = 4'b0;
        assign xgmii_rx_format_adpt_valid       = xgmii_rx_valid;
    end
    endgenerate

    //------------------------------------------------------------------------
    // Clock and Reset
    //------------------------------------------------------------------------
    alt_em10g32_clk_rst #(
        .DEPTH                  (SYNCHRONIZER_DEPTH),
        .INSERT_XGMII_ADAPTOR   (INSERT_XGMII_ADAPTOR),
        .INSERT_ST_ADAPTOR      (INSERT_ST_ADAPTOR),
        .USE_ASYNC_ADAPTOR      (USE_ASYNC_ADAPTOR),
        .ENABLE_TIMESTAMPING    (ENABLE_TIMESTAMPING),
        .SYNC_RESET_N           (0)
    ) clk_rst_inst (
        .tx_clk                     ((ENABLE_10GBASER_REG_MODE) ? tx_xcvr_clk : (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? tx_156_25_clk : tx_312_5_clk),
        .tx_rst_n                   (tx_rst_n_final),

        .rx_clk                     ((ENABLE_10GBASER_REG_MODE) ? rx_xcvr_clk : (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? rx_156_25_clk : rx_312_5_clk),
        .rx_rst_n                   (rx_rst_n_final),
                                   
        .csr_clk                    (csr_ms_clk),
        .csr_rst_n                  (csr_ms_rst_n),
                                   
        .gmii_tx_clk                ((ENABLE_1G10G_MAC >= 3) ? gmii16b_tx_clk : gmii_tx_clk),
        .gmii_rx_clk                ((ENABLE_1G10G_MAC >= 3) ? gmii16b_rx_clk : gmii_rx_clk),

        .tx_156_25_clk              (tx_156_25_clk),
        .rx_156_25_clk              (rx_156_25_clk),
        
        .latency_measure_sampling_clk(latency_measure_sampling_clk),
        
        .tx_clk_sync                (tx_clk_sync),
        .tx_rst_n_sync              (tx_rst_n_sync),
                                   
        .rx_clk_sync                (rx_clk_sync),
        .rx_rst_n_sync              (rx_rst_n_sync),
                                   
        .csr_clk_sync               (csr_clk_sync),
        .csr_rst_n_sync             (csr_rst_n_sync),
        
        .gmii_tx_clk_sync           (gmii_tx_clk_sync),
        .gmii_tx_rst_n_sync         (gmii_tx_rst_n_sync),
        
        .gmii_rx_clk_sync           (gmii_rx_clk_sync),
        .gmii_rx_rst_n_sync         (gmii_rx_rst_n_sync),

        .tx_156_25_clk_sync         (tx_156_25_clk_sync),
        .tx_156_25_rst_n_sync       (tx_156_25_rst_n_sync),
        .rx_156_25_clk_sync         (rx_156_25_clk_sync),
        .rx_156_25_rst_n_sync       (rx_156_25_rst_n_sync),
        
        .tx_sampling_rst_n_sync     (tx_sampling_rst_n_sync),
        .rx_sampling_rst_n_sync     (rx_sampling_rst_n_sync),
        
        .csr_rst_tx_clk_n           (csr_rst_tx_clk_n),
        .csr_rst_rx_clk_n           (csr_rst_rx_clk_n),
        
        .csr_tx_cc_in_rst_n         (csr_tx_cc_in_rst_n),
        .csr_tx_cc_out_rst_n        (csr_tx_cc_out_rst_n),
        .tx_csr_cc_in_rst_n         (tx_csr_cc_in_rst_n),
        .tx_csr_cc_out_rst_n        (tx_csr_cc_out_rst_n),
        
        .csr_gmii_tx_cc_in_rst_n    (csr_gmii_tx_cc_in_rst_n),
        .csr_gmii_tx_cc_out_rst_n   (csr_gmii_tx_cc_out_rst_n),
        .gmii_tx_csr_cc_in_rst_n    (gmii_tx_csr_cc_in_rst_n),
        .gmii_tx_csr_cc_out_rst_n   (gmii_tx_csr_cc_out_rst_n),
        
        .csr_rx_cc_in_rst_n         (csr_rx_cc_in_rst_n),
        .csr_rx_cc_out_rst_n        (csr_rx_cc_out_rst_n),
        .rx_csr_cc_in_rst_n         (rx_csr_cc_in_rst_n),
        .rx_csr_cc_out_rst_n        (rx_csr_cc_out_rst_n),
        
        .csr_gmii_rx_cc_in_rst_n    (csr_gmii_rx_cc_in_rst_n),
        .csr_gmii_rx_cc_out_rst_n   (csr_gmii_rx_cc_out_rst_n),
        .gmii_rx_csr_cc_in_rst_n    (gmii_rx_csr_cc_in_rst_n),
        .gmii_rx_csr_cc_out_rst_n   (gmii_rx_csr_cc_out_rst_n),
        
        .tx_rx_cc_in_rst_n          (tx_rx_cc_in_rst_n),
        .tx_rx_cc_out_rst_n         (tx_rx_cc_out_rst_n),
        .rx_tx_cc_in_rst_n          (rx_tx_cc_in_rst_n),
        .rx_tx_cc_out_rst_n         (rx_tx_cc_out_rst_n)
    );


endmodule
