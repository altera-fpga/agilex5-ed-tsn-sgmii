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
module altera_eth_avalon_st_adapter # ( 
      parameter DEVICE_FAMILY               = "Stratix V",
      
      parameter SYNC_DEPTH                  = 3,
      
      parameter USE_ASYNC_ADAPTOR           = 0,
      
      parameter DATAPATH_OPTION             = 3,
      parameter ENABLE_PFC                  = 0,
      parameter PFC_PRIORITY_NUMBER         = 8,
      
      parameter ENABLE_TIMESTAMPING         = 0,
      parameter TSTAMP_FP_WIDTH             = 4,
      parameter TIME_OF_DAY_FORMAT          = 2,
      parameter SYNC_RESET_N                = 1
) (
    // CSR
    input  wire [2:0]  csr_tx_adptdcff_rdwtrmrk,
    input  wire [2:0]  csr_tx_adptdcff_vldpkt_minwt,
    input  wire        csr_tx_adptdcff_rdwtrmrk_dis,
    
    //tx clock and reset  
    input  wire        avalon_st_tx_clk_312,    
    input  wire        avalon_st_tx_312_reset_n,    
    input  wire        avalon_st_tx_clk_156,          
    input  wire        avalon_st_tx_156_reset_n,
    
    //tx avst signal at 156mhz domain
    output wire        avalon_st_tx_156_ready,         
    input  wire        avalon_st_tx_156_valid,         
    input  wire [63:0] avalon_st_tx_156_data,          
    input  wire        avalon_st_tx_156_error,         
    input  wire        avalon_st_tx_156_startofpacket, 
    input  wire        avalon_st_tx_156_endofpacket,   
    input  wire [2:0]  avalon_st_tx_156_empty,

    //tx avst signal at 312mhz domain    
    input  wire        avalon_st_tx_312_ready,        
    output wire        avalon_st_tx_312_valid,        
    output wire [31:0] avalon_st_tx_312_data,         
    output wire        avalon_st_tx_312_error,        
    output wire        avalon_st_tx_312_startofpacket,
    output wire        avalon_st_tx_312_endofpacket,  
    output wire [1:0]  avalon_st_tx_312_empty,

    //rx clock and reset    
    input  wire        avalon_st_rx_clk_312,          
    input  wire        avalon_st_rx_312_reset_n,    
    input  wire        avalon_st_rx_clk_156,          
    input  wire        avalon_st_rx_156_reset_n,
    
    //rx avst signal at 312mhz domain
    output wire        avalon_st_rx_312_ready,         
    input  wire        avalon_st_rx_312_valid,         
    input  wire [31:0] avalon_st_rx_312_data,          
    input  wire [5:0]  avalon_st_rx_312_error,         
    input  wire        avalon_st_rx_312_startofpacket, 
    input  wire        avalon_st_rx_312_endofpacket,   
    input  wire [1:0]  avalon_st_rx_312_empty,  

    //rx avst signal at 156mhz domain    
    input  wire         avalon_st_rx_156_ready,        
    output wire         avalon_st_rx_156_valid,        
    output wire [63:0]  avalon_st_rx_156_data,         
    output wire [5:0]   avalon_st_rx_156_error,        
    output wire         avalon_st_rx_156_startofpacket,
    output wire         avalon_st_rx_156_endofpacket,  
    output wire [2:0]   avalon_st_rx_156_empty,   

    // TX 1588 signals at 156mhz domain
    // Aligned to data path
    input  wire                        tx_egress_p2p_update_156,
    input  wire [45:0]                 tx_egress_p2p_val_156,
    input  wire                        tx_egress_asymmetry_update_156,
    input  wire                        tx_egress_timestamp_request_valid_156,
    input  wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_request_fingerprint_156,
    input  wire                        tx_etstamp_ins_ctrl_timestamp_insert_156,
    input  wire                        tx_etstamp_ins_ctrl_timestamp_format_156,
    input  wire                        tx_etstamp_ins_ctrl_residence_time_update_156,
    input  wire [95:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_96b_156,
    input  wire [63:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_64b_156,
    input  wire                        tx_etstamp_ins_ctrl_residence_time_calc_format_156,
    input  wire                        tx_etstamp_ins_ctrl_checksum_zero_156,
    input  wire                        tx_etstamp_ins_ctrl_checksum_correct_156,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_timestamp_156,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_correction_field_156,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_field_156,
    input  wire [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_correction_156,
    
    // Not aligned to data path
    output wire [95:0]                 tx_egress_timestamp_96b_data_156,
    output wire                        tx_egress_timestamp_96b_valid_156,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_96b_fingerprint_156,
    output wire [63:0]                 tx_egress_timestamp_64b_data_156,
    output wire                        tx_egress_timestamp_64b_valid_156,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_64b_fingerprint_156,
    
    // TX 1588 signals at 312mhz domain
    // Aligned to data path
    output wire                        tx_egress_p2p_update_312,
    output wire [45:0]                 tx_egress_p2p_val_312,
    output wire                        tx_egress_asymmetry_update_312,
    output wire                        tx_egress_timestamp_request_valid_312,
    output wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_request_fingerprint_312,
    output wire                        tx_etstamp_ins_ctrl_timestamp_insert_312,
    output wire                        tx_etstamp_ins_ctrl_timestamp_format_312,
    output wire                        tx_etstamp_ins_ctrl_residence_time_update_312,
    output wire [95:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_96b_312,
    output wire [63:0]                 tx_etstamp_ins_ctrl_ingress_timestamp_64b_312,
    output wire                        tx_etstamp_ins_ctrl_residence_time_calc_format_312,
    output wire                        tx_etstamp_ins_ctrl_checksum_zero_312,
    output wire                        tx_etstamp_ins_ctrl_checksum_correct_312,
    output wire [15:0]                 tx_etstamp_ins_ctrl_offset_timestamp_312,
    output wire [15:0]                 tx_etstamp_ins_ctrl_offset_correction_field_312,
    output wire [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_field_312,
    output wire [15:0]                 tx_etstamp_ins_ctrl_offset_checksum_correction_312,
    
    // Not aligned to data path
    input  wire [95:0]                 tx_egress_timestamp_96b_data_312,
    input  wire                        tx_egress_timestamp_96b_valid_312,
    input  wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_96b_fingerprint_312,
    input  wire [63:0]                 tx_egress_timestamp_64b_data_312,
    input  wire                        tx_egress_timestamp_64b_valid_312,
    input  wire [TSTAMP_FP_WIDTH-1:0]  tx_egress_timestamp_64b_fingerprint_312,
    
    //TX Status Signals
    // Not aligned to data path
    output wire                        avalon_st_txstatus_valid_156,
    output wire [39:0]                 avalon_st_txstatus_data_156,
    output wire [6:0]                  avalon_st_txstatus_error_156,

    input  wire                        avalon_st_txstatus_valid_312,
    input  wire [39:0]                 avalon_st_txstatus_data_312,
    input  wire [6:0]                  avalon_st_txstatus_error_312,
    
    //TX PFC Data Signals
    // Not aligned to data path
    input  wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_data_156,       
    output wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_data_312,       
    
    //TX PFC Status Signals
    // Not aligned to data path
    output wire                               avalon_st_tx_pfc_status_valid_156,
    output wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_status_data_156,

    input  wire                               avalon_st_tx_pfc_status_valid_312,
    input  wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_status_data_312,  

    // TX Pause Data
    // Not aligned to data path
    input  wire [1:0]                  avalon_st_tx_pause_data_156,
    output wire [1:0]                  avalon_st_tx_pause_data_312,    

    // Pause Quanta (For TX only variant)
    // Not aligned to data path
    input  wire                        avalon_st_tx_pause_length_valid_156,
    input  wire [15:0]                 avalon_st_tx_pause_length_data_156,

    output wire                        avalon_st_tx_pause_length_valid_312,
    output wire [15:0]                 avalon_st_tx_pause_length_data_312,      

    // RX 1588 signals
    // Aligned to data path
    input  wire                        rx_ingress_timestamp_96b_valid_312,
    input  wire [95:0]                 rx_ingress_timestamp_96b_data_312,
    input  wire                        rx_ingress_timestamp_64b_valid_312,
    input  wire [63:0]                 rx_ingress_timestamp_64b_data_312,

    output wire                        rx_ingress_timestamp_96b_valid_156,
    output wire  [95:0]                rx_ingress_timestamp_96b_data_156,
    output wire                        rx_ingress_timestamp_64b_valid_156,
    output wire  [63:0]                rx_ingress_timestamp_64b_data_156,  
    
    input  wire                        rx_ingress_p2p_val_valid_312,
    input  wire [45:0]                 rx_ingress_p2p_val_312, 

    output wire                        rx_ingress_p2p_val_valid_156,
    output wire [45:0]                 rx_ingress_p2p_val_156,     

    //RX Status Signals
    // Aligned to data path
    output wire                        avalon_st_rxstatus_valid_156,
    output wire [39:0]                 avalon_st_rxstatus_data_156,
    output wire [6:0]                  avalon_st_rxstatus_error_156,
    
    input  wire                        avalon_st_rxstatus_valid_312,
    input  wire [39:0]                 avalon_st_rxstatus_data_312,
    input  wire [6:0]                  avalon_st_rxstatus_error_312,

    //RX PFC Pause Data Signals
    // Not aligned to data path
    input  wire [PFC_PRIORITY_NUMBER-1:0]     avalon_st_rx_pfc_pause_data_312,
    output wire [PFC_PRIORITY_NUMBER-1:0]     avalon_st_rx_pfc_pause_data_156,
    
    //RX PFC Status Signals
    // Aligned to data path
    input  wire                               avalon_st_rx_pfc_status_valid_312,
    input  wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_rx_pfc_status_data_312,      
    
    output wire                               avalon_st_rx_pfc_status_valid_156,
    output wire [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_rx_pfc_status_data_156,
    
    // Pause Quanta (For RX only variant)
    // Not aligned to data path
    input  wire                        avalon_st_rx_pause_length_valid_312,
    input  wire [15:0]                 avalon_st_rx_pause_length_data_312,  

    output wire                        avalon_st_rx_pause_length_valid_156,
    output wire [15:0]                 avalon_st_rx_pause_length_data_156      
);

localparam USE_TX_DATAPATH          = (DATAPATH_OPTION == 1) || (DATAPATH_OPTION == 3);
localparam USE_RX_DATAPATH          = (DATAPATH_OPTION == 2) || (DATAPATH_OPTION == 3);
localparam USE_96B_TIME_FORMAT      = (TIME_OF_DAY_FORMAT == 0) || (TIME_OF_DAY_FORMAT == 2);
localparam USE_64B_TIME_FORMAT      = (TIME_OF_DAY_FORMAT == 1) || (TIME_OF_DAY_FORMAT == 2);
    
localparam TX_1588_156_TO_312_WIDTH = ((TIME_OF_DAY_FORMAT == 0) ? (96) :
                                      (TIME_OF_DAY_FORMAT == 1) ? (64) :
                                      (96 + 64 + 1)) + (TSTAMP_FP_WIDTH + 1) + (16*4) + 5 + 1 +47;
localparam RX_1588_312_TO_156_WIDTH = ((TIME_OF_DAY_FORMAT == 0) ? (96 + 1 + 46 +1) :
                                      (TIME_OF_DAY_FORMAT == 1) ? (64 + 1 + 46 +1) :
                                      (96 + 1 + 64 + 1 + 46 +1));
localparam TX_DC_FIFO_156_TO_312_WIDTH = (ENABLE_PFC ? PFC_PRIORITY_NUMBER * 2 : 0) + (2);

wire [63:0]  dc_avalon_st_tx_out_data;
wire         dc_avalon_st_tx_out_valid;
wire         dc_avalon_st_tx_out_error;
wire         dc_avalon_st_tx_out_startofpacket;
wire         dc_avalon_st_tx_out_endofpacket;
wire [2:0]   dc_avalon_st_tx_out_empty;
wire         dc_avalon_st_tx_out_ready;

// ----------------------
// modification starts
// ----------------------

wire [63:0]  adpt_avalon_st_tx_out_data;
wire         adpt_avalon_st_tx_out_valid;
wire         adpt_avalon_st_tx_out_error;
wire         adpt_avalon_st_tx_out_startofpacket;
wire         adpt_avalon_st_tx_out_endofpacket;
wire [2:0]   adpt_avalon_st_tx_out_empty;
wire         adpt_avalon_st_tx_out_ready;

wire dc_avalon_st_tx_out_lt_rdwtrmark;
wire dc_avalon_st_tx_out_almost_empty_valid;
wire dc_avalon_st_tx_out_almost_empty_data;

// ----------------------
// modification ends
// ----------------------

wire [63:0]  dc_avalon_st_rx_in_data;
wire         dc_avalon_st_rx_in_valid;
wire [5:0]   dc_avalon_st_rx_in_error;
wire         dc_avalon_st_rx_in_startofpacket;
wire         dc_avalon_st_rx_in_endofpacket;
wire [2:0]   dc_avalon_st_rx_in_empty;
wire         dc_avalon_st_rx_in_ready;

wire         almost_full_data_rx_156_to_312;


//wide bus for tx 1588 and rx/tx status signal
wire [TX_1588_156_TO_312_WIDTH - 1:0] wide_bus_tx_1588_into_dc_fifo;
wire [TX_1588_156_TO_312_WIDTH - 1:0] wide_bus_tx_1588_from_dc_fifo;
wire [RX_1588_312_TO_156_WIDTH - 1:0] wide_bus_rx_1588_into_dc_fifo;                                       
wire [RX_1588_312_TO_156_WIDTH - 1:0] wide_bus_rx_1588_from_dc_fifo;
wire [47:0] wide_bus_rx_status_into_dc_fifo;                                       
wire [47:0] wide_bus_rx_status_from_dc_fifo; 
wire rx_1588_valid_wire;
wire rx_status_valid_wire;

// Sideband Adaptor
wire tx_dc_fifo_156_to_312_out_valid;
reg  tx_dc_fifo_156_to_312_out_ready;
reg  tx_dc_fifo_156_to_312_read_ready;
wire tx_dc_fifo_156_to_312_almost_empty;
wire [TX_DC_FIFO_156_TO_312_WIDTH-1:0] wide_bus_into_tx_dc_fifo_156_to_312;
wire [TX_DC_FIFO_156_TO_312_WIDTH-1:0] wide_bus_from_tx_dc_fifo_156_to_312;

reg  [(PFC_PRIORITY_NUMBER*2)-1:0] avalon_st_tx_pfc_data_156_reg;
reg  [1:0] avalon_st_tx_pause_data_156_reg;

reg [7:0] rx_pfc_pause_write_ready_delay;
reg rx_pfc_pause_write_ready;
reg rx_pfc_pause_in_valid;
wire rx_pfc_pause_out_valid;
wire [PFC_PRIORITY_NUMBER-1:0] avalon_st_rx_pfc_pause_data_156_wire;

reg             rx_ingress_timestamp_96b_valid_312_pipe1;
reg     [95:0]  rx_ingress_timestamp_96b_data_312_pipe1;
reg             rx_ingress_timestamp_64b_valid_312_pipe1;
reg     [63:0]  rx_ingress_timestamp_64b_data_312_pipe1;
reg             avalon_st_rxstatus_valid_312_pipe1;
reg     [39:0]  avalon_st_rxstatus_data_312_pipe1;
reg     [6:0]   avalon_st_rxstatus_error_312_pipe1;
reg             rx_ingress_p2p_val_valid_312_pipe1;
reg     [45:0]  rx_ingress_p2p_val_312_pipe1;

generate if (DEVICE_FAMILY == "Stratix 10")
begin

    always @ (posedge avalon_st_rx_clk_312)
        begin
        rx_ingress_timestamp_96b_valid_312_pipe1 <= rx_ingress_timestamp_96b_valid_312;
        rx_ingress_timestamp_96b_data_312_pipe1 <= rx_ingress_timestamp_96b_data_312;
        rx_ingress_timestamp_64b_valid_312_pipe1 <= rx_ingress_timestamp_64b_valid_312;
        rx_ingress_timestamp_64b_data_312_pipe1 <= rx_ingress_timestamp_64b_data_312;
        
        rx_ingress_p2p_val_valid_312_pipe1 <= rx_ingress_p2p_val_valid_312;    
        rx_ingress_p2p_val_312_pipe1 <= rx_ingress_p2p_val_312;        
        end
end
else
begin
    always @ (*)
        begin
        rx_ingress_timestamp_96b_valid_312_pipe1 = rx_ingress_timestamp_96b_valid_312;
        rx_ingress_timestamp_96b_data_312_pipe1 = rx_ingress_timestamp_96b_data_312;
        rx_ingress_timestamp_64b_valid_312_pipe1 = rx_ingress_timestamp_64b_valid_312;
        rx_ingress_timestamp_64b_data_312_pipe1 = rx_ingress_timestamp_64b_data_312;

        rx_ingress_p2p_val_valid_312_pipe1 = rx_ingress_p2p_val_valid_312;    
        rx_ingress_p2p_val_312_pipe1 = rx_ingress_p2p_val_312;    
        
        end
end 
endgenerate

generate if(TIME_OF_DAY_FORMAT == 0)
begin: TIME_FORMAT_96
    assign wide_bus_tx_1588_into_dc_fifo = {tx_egress_p2p_update_156,
                                            tx_egress_p2p_val_156,
                                            tx_egress_asymmetry_update_156,
                                            tx_egress_timestamp_request_fingerprint_156,
                                            tx_egress_timestamp_request_valid_156,
                                            tx_etstamp_ins_ctrl_timestamp_insert_156,
                                            tx_etstamp_ins_ctrl_timestamp_format_156,
                                            tx_etstamp_ins_ctrl_residence_time_update_156,
                                            tx_etstamp_ins_ctrl_ingress_timestamp_96b_156,
                                            //tx_etstamp_ins_ctrl_ingress_timestamp_64b_156,
                                            //tx_etstamp_ins_ctrl_residence_time_calc_format_156,
                                            tx_etstamp_ins_ctrl_checksum_zero_156,
                                            tx_etstamp_ins_ctrl_checksum_correct_156,
                                            tx_etstamp_ins_ctrl_offset_timestamp_156,
                                            tx_etstamp_ins_ctrl_offset_correction_field_156,
                                            tx_etstamp_ins_ctrl_offset_checksum_field_156,
                                            tx_etstamp_ins_ctrl_offset_checksum_correction_156};
    
    assign {tx_egress_p2p_update_312,
            tx_egress_p2p_val_312,
            tx_egress_asymmetry_update_312,
            tx_egress_timestamp_request_fingerprint_312,
            tx_egress_timestamp_request_valid_312,
            tx_etstamp_ins_ctrl_timestamp_insert_312,
            tx_etstamp_ins_ctrl_timestamp_format_312,
            tx_etstamp_ins_ctrl_residence_time_update_312,
            tx_etstamp_ins_ctrl_ingress_timestamp_96b_312,
            //tx_etstamp_ins_ctrl_ingress_timestamp_64b_312,
            //tx_etstamp_ins_ctrl_residence_time_calc_format_312,
            tx_etstamp_ins_ctrl_checksum_zero_312,
            tx_etstamp_ins_ctrl_checksum_correct_312,
            tx_etstamp_ins_ctrl_offset_timestamp_312,
            tx_etstamp_ins_ctrl_offset_correction_field_312,
            tx_etstamp_ins_ctrl_offset_checksum_field_312,
            tx_etstamp_ins_ctrl_offset_checksum_correction_312} = wide_bus_tx_1588_from_dc_fifo;
    
    assign tx_etstamp_ins_ctrl_ingress_timestamp_64b_312 = 64'h0;
    assign tx_etstamp_ins_ctrl_residence_time_calc_format_312 = 1'b0;
  
    assign wide_bus_rx_1588_into_dc_fifo = {rx_ingress_p2p_val_valid_312_pipe1, rx_ingress_p2p_val_312_pipe1, rx_ingress_timestamp_96b_valid_312_pipe1,rx_ingress_timestamp_96b_data_312_pipe1};
    
    assign rx_ingress_timestamp_64b_data_156 = 64'h0;
    assign rx_ingress_timestamp_96b_data_156 = wide_bus_rx_1588_from_dc_fifo[95:0];
    assign rx_ingress_timestamp_64b_valid_156 = 1'b0;
    assign rx_ingress_timestamp_96b_valid_156 = wide_bus_rx_1588_from_dc_fifo[96] & avalon_st_rx_156_valid & avalon_st_rx_156_startofpacket; 
    assign rx_ingress_p2p_val_156 = wide_bus_rx_1588_from_dc_fifo[142:97];    
    assign rx_ingress_p2p_val_valid_156 = wide_bus_rx_1588_from_dc_fifo[143];    
    
end
else if(TIME_OF_DAY_FORMAT == 1)
begin: TIME_FORMAT_64
    assign wide_bus_tx_1588_into_dc_fifo = {tx_egress_p2p_update_156,
                                            tx_egress_p2p_val_156,
                                            tx_egress_asymmetry_update_156,
                                            tx_egress_timestamp_request_fingerprint_156,
                                            tx_egress_timestamp_request_valid_156,
                                            tx_etstamp_ins_ctrl_timestamp_insert_156,
                                            tx_etstamp_ins_ctrl_timestamp_format_156,
                                            tx_etstamp_ins_ctrl_residence_time_update_156,
                                            //tx_etstamp_ins_ctrl_ingress_timestamp_96b_156,
                                            tx_etstamp_ins_ctrl_ingress_timestamp_64b_156,
                                            //tx_etstamp_ins_ctrl_residence_time_calc_format_156,
                                            tx_etstamp_ins_ctrl_checksum_zero_156,
                                            tx_etstamp_ins_ctrl_checksum_correct_156,
                                            tx_etstamp_ins_ctrl_offset_timestamp_156,
                                            tx_etstamp_ins_ctrl_offset_correction_field_156,
                                            tx_etstamp_ins_ctrl_offset_checksum_field_156,
                                            tx_etstamp_ins_ctrl_offset_checksum_correction_156};
    
    assign {tx_egress_p2p_update_312,
            tx_egress_p2p_val_312,
            tx_egress_asymmetry_update_312,
            tx_egress_timestamp_request_fingerprint_312,
            tx_egress_timestamp_request_valid_312,
            tx_etstamp_ins_ctrl_timestamp_insert_312,
            tx_etstamp_ins_ctrl_timestamp_format_312,
            tx_etstamp_ins_ctrl_residence_time_update_312,
            //tx_etstamp_ins_ctrl_ingress_timestamp_96b_312,
            tx_etstamp_ins_ctrl_ingress_timestamp_64b_312,
            //tx_etstamp_ins_ctrl_residence_time_calc_format_312,
            tx_etstamp_ins_ctrl_checksum_zero_312,
            tx_etstamp_ins_ctrl_checksum_correct_312,
            tx_etstamp_ins_ctrl_offset_timestamp_312,
            tx_etstamp_ins_ctrl_offset_correction_field_312,
            tx_etstamp_ins_ctrl_offset_checksum_field_312,
            tx_etstamp_ins_ctrl_offset_checksum_correction_312} = wide_bus_tx_1588_from_dc_fifo;
    
    assign tx_etstamp_ins_ctrl_ingress_timestamp_96b_312 = 96'h0;
    assign tx_etstamp_ins_ctrl_residence_time_calc_format_312 = 1'b1;
    
    
    assign wide_bus_rx_1588_into_dc_fifo =  {rx_ingress_p2p_val_valid_312_pipe1, rx_ingress_p2p_val_312_pipe1, rx_ingress_timestamp_64b_valid_312_pipe1,rx_ingress_timestamp_64b_data_312_pipe1};
    
    assign rx_ingress_timestamp_64b_data_156 = wide_bus_rx_1588_from_dc_fifo[63:0];
    assign rx_ingress_timestamp_96b_data_156 = 96'h0;
    assign rx_ingress_timestamp_64b_valid_156 = wide_bus_rx_1588_from_dc_fifo[64] & avalon_st_rx_156_valid & avalon_st_rx_156_startofpacket;                
    assign rx_ingress_timestamp_96b_valid_156 = 1'b0;
    assign rx_ingress_p2p_val_156 = wide_bus_rx_1588_from_dc_fifo[110:65];    
    assign rx_ingress_p2p_val_valid_156 = wide_bus_rx_1588_from_dc_fifo[111];    
    
end
else
begin: TIME_FORMAT_96_AND_64
    assign wide_bus_tx_1588_into_dc_fifo = {tx_egress_p2p_update_156,
                                            tx_egress_p2p_val_156,
                                            tx_egress_asymmetry_update_156,
                                            tx_egress_timestamp_request_fingerprint_156,
                                            tx_egress_timestamp_request_valid_156,
                                            tx_etstamp_ins_ctrl_timestamp_insert_156,
                                            tx_etstamp_ins_ctrl_timestamp_format_156,
                                            tx_etstamp_ins_ctrl_residence_time_update_156,
                                            tx_etstamp_ins_ctrl_ingress_timestamp_96b_156,
                                            tx_etstamp_ins_ctrl_ingress_timestamp_64b_156,
                                            tx_etstamp_ins_ctrl_residence_time_calc_format_156,
                                            tx_etstamp_ins_ctrl_checksum_zero_156,
                                            tx_etstamp_ins_ctrl_checksum_correct_156,
                                            tx_etstamp_ins_ctrl_offset_timestamp_156,
                                            tx_etstamp_ins_ctrl_offset_correction_field_156,
                                            tx_etstamp_ins_ctrl_offset_checksum_field_156,
                                            tx_etstamp_ins_ctrl_offset_checksum_correction_156};
    
    assign {tx_egress_p2p_update_312,
            tx_egress_p2p_val_312,
            tx_egress_asymmetry_update_312,
            tx_egress_timestamp_request_fingerprint_312,
            tx_egress_timestamp_request_valid_312,
            tx_etstamp_ins_ctrl_timestamp_insert_312,
            tx_etstamp_ins_ctrl_timestamp_format_312,
            tx_etstamp_ins_ctrl_residence_time_update_312,
            tx_etstamp_ins_ctrl_ingress_timestamp_96b_312,
            tx_etstamp_ins_ctrl_ingress_timestamp_64b_312,
            tx_etstamp_ins_ctrl_residence_time_calc_format_312,
            tx_etstamp_ins_ctrl_checksum_zero_312,
            tx_etstamp_ins_ctrl_checksum_correct_312,
            tx_etstamp_ins_ctrl_offset_timestamp_312,
            tx_etstamp_ins_ctrl_offset_correction_field_312,
            tx_etstamp_ins_ctrl_offset_checksum_field_312,
            tx_etstamp_ins_ctrl_offset_checksum_correction_312} = wide_bus_tx_1588_from_dc_fifo;
            
            
    
    assign wide_bus_rx_1588_into_dc_fifo = {rx_ingress_p2p_val_valid_312_pipe1, rx_ingress_p2p_val_312_pipe1, rx_ingress_timestamp_96b_valid_312_pipe1,rx_ingress_timestamp_96b_data_312_pipe1,rx_ingress_timestamp_64b_valid_312_pipe1,rx_ingress_timestamp_64b_data_312_pipe1};
    
    assign rx_ingress_timestamp_64b_data_156 = wide_bus_rx_1588_from_dc_fifo[63:0];
    assign rx_ingress_timestamp_96b_data_156 = wide_bus_rx_1588_from_dc_fifo[160:65];
    assign rx_ingress_timestamp_64b_valid_156 = wide_bus_rx_1588_from_dc_fifo[64] & avalon_st_rx_156_valid & avalon_st_rx_156_startofpacket;                
    assign rx_ingress_timestamp_96b_valid_156 = wide_bus_rx_1588_from_dc_fifo[161] & avalon_st_rx_156_valid & avalon_st_rx_156_startofpacket; 
    assign rx_ingress_p2p_val_156 = wide_bus_rx_1588_from_dc_fifo[207:162];    
    assign rx_ingress_p2p_val_valid_156 = wide_bus_rx_1588_from_dc_fifo[208];    

end
endgenerate

generate if((ENABLE_TIMESTAMPING) && (USE_RX_DATAPATH))
begin : DUMMY_P2P
 //to fix ram synthesis away warning
 reg [45:0] dummy_reg_rx_ingress_p2p_val_156  /* synthesis noprune */;
 reg dummy_reg_rx_ingress_p2p_val_valid_156  /* synthesis noprune */;
 
 always @ (posedge avalon_st_rx_clk_156) begin
     dummy_reg_rx_ingress_p2p_val_valid_156 <= rx_ingress_p2p_val_valid_156;
     dummy_reg_rx_ingress_p2p_val_156 <= rx_ingress_p2p_val_156;
 end
end
endgenerate


generate if (DEVICE_FAMILY == "Stratix 10")
    begin

    always @ (posedge avalon_st_rx_clk_312)
        begin
        avalon_st_rxstatus_valid_312_pipe1 <= avalon_st_rxstatus_valid_312;
        avalon_st_rxstatus_data_312_pipe1 <= avalon_st_rxstatus_data_312;
        avalon_st_rxstatus_error_312_pipe1 <= avalon_st_rxstatus_error_312;
        end
    end
else
    begin
    always @ (*)
        begin
        avalon_st_rxstatus_valid_312_pipe1 = avalon_st_rxstatus_valid_312;
        avalon_st_rxstatus_data_312_pipe1 = avalon_st_rxstatus_data_312;
        avalon_st_rxstatus_error_312_pipe1 = avalon_st_rxstatus_error_312;
        end
    
    end    
endgenerate    


assign wide_bus_rx_status_into_dc_fifo ={avalon_st_rxstatus_valid_312_pipe1,avalon_st_rxstatus_data_312_pipe1,avalon_st_rxstatus_error_312_pipe1};                                        

assign avalon_st_rxstatus_error_156 = wide_bus_rx_status_from_dc_fifo[6:0];
assign avalon_st_rxstatus_data_156 = wide_bus_rx_status_from_dc_fifo[46:7];
assign avalon_st_rxstatus_valid_156 = wide_bus_rx_status_from_dc_fifo[47] & avalon_st_rx_156_valid & avalon_st_rx_156_endofpacket;

// ----------------------
// modification starts
// ----------------------

// Modulating the VALID/READY handshake between the DCFIFO and 64/32 adaption logic.
// When there is a valid SOP and the DCFIFO has not reached the CSR pre-configured DCFIFO low watermark (default to 2),
// this piece of new logic shall mask out the READY to the DCFIFO and the VALID to the 64/32 adaption logic,
// until a CSR pre-configured waiting period (default to 2) has ended
// In this way, there shouldn't be a bandwidth loss when TX client continues feeding data to the MAC TX

assign dc_avalon_st_tx_out_lt_rdwtrmark = !dc_avalon_st_tx_out_almost_empty_valid || dc_avalon_st_tx_out_almost_empty_data;

alt_em10g32_vldpkt_rddly #(
    //. WAIT_TRANSFER_COUNT(2),
    .SYMBOLS_PER_BEAT(8),
    .BITS_PER_SYMBOL(8),
    .CHANNEL_WIDTH(0),
    .ERROR_WIDTH(1),
    .USE_PACKETS(1),
    .SYNC_RESET_N(SYNC_RESET_N)
) tx_156_312_wait_fifo_fill (
    .clk						(avalon_st_tx_clk_312),
    .rst_n						(avalon_st_tx_312_reset_n),
    .csr_vldpkt_minwt			(csr_tx_adptdcff_vldpkt_minwt),
    .csr_rdwtrmrk_dis			(csr_tx_adptdcff_rdwtrmrk_dis),
    .in_lt_rdwtrmark			(dc_avalon_st_tx_out_lt_rdwtrmark),
    .in_startofpacket			(dc_avalon_st_tx_out_startofpacket),
    .in_endofpacket				(dc_avalon_st_tx_out_endofpacket),
    .in_valid					(dc_avalon_st_tx_out_valid),
    .in_ready					(dc_avalon_st_tx_out_ready),
    .in_data					(dc_avalon_st_tx_out_data),
    .in_empty					(dc_avalon_st_tx_out_empty),
    .in_error					(dc_avalon_st_tx_out_error),
    .in_channel					(1'b0),
    .out_startofpacket			(adpt_avalon_st_tx_out_startofpacket),
    .out_endofpacket			(adpt_avalon_st_tx_out_endofpacket),
    .out_valid					(adpt_avalon_st_tx_out_valid),
    .out_ready					(adpt_avalon_st_tx_out_ready),
    .out_data					(adpt_avalon_st_tx_out_data),
    .out_empty					(adpt_avalon_st_tx_out_empty),
    .out_error					(adpt_avalon_st_tx_out_error),
    .out_channel				()
);

// ----------------------
// modification ends
// ----------------------

////////////////////////////////////////////////////////////////////////////////
// TX Packet DC FIFO 156 to 312
////////////////////////////////////////////////////////////////////////////////
generate if(USE_TX_DATAPATH)
begin : TX_156_TO_312
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY          (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT       (8),
        .BITS_PER_SYMBOL        (8),
        .FIFO_DEPTH             (16),
        .ERROR_WIDTH            (1),
        .USE_PACKETS            (1),
        .STREAM_ALMOST_EMPTY    (1),
        .SYNC_RESET_N           (0)
    ) tx_156_to_312 (

        .in_clk(avalon_st_tx_clk_156),
        .in_reset_n(avalon_st_tx_156_reset_n),

        .out_clk(avalon_st_tx_clk_312),
        .out_reset_n(avalon_st_tx_312_reset_n),

        // sink
        .in_data(avalon_st_tx_156_data),
        .in_valid(avalon_st_tx_156_valid),
        .in_ready(avalon_st_tx_156_ready),
        .in_startofpacket(avalon_st_tx_156_startofpacket),
        .in_endofpacket(avalon_st_tx_156_endofpacket),
        .in_empty(avalon_st_tx_156_empty),
        .in_error(avalon_st_tx_156_error),
        .in_channel(1'b0),

        // source
        .out_data(dc_avalon_st_tx_out_data),
        .out_valid(dc_avalon_st_tx_out_valid),
        .out_ready(dc_avalon_st_tx_out_ready),
        .out_startofpacket(dc_avalon_st_tx_out_startofpacket),
        .out_endofpacket(dc_avalon_st_tx_out_endofpacket),
        .out_empty(dc_avalon_st_tx_out_empty),
        .out_error(dc_avalon_st_tx_out_error),
        .out_channel(),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(),

        // streaming out status
        .almost_empty_valid(dc_avalon_st_tx_out_almost_empty_valid),
        .almost_empty_data(dc_avalon_st_tx_out_almost_empty_data),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd0),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold({2'b00, csr_tx_adptdcff_rdwtrmrk}),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    );
end
else begin
    assign dc_avalon_st_tx_out_data = {(64){1'b0}};
    assign dc_avalon_st_tx_out_valid = {(1){1'b0}};
    assign dc_avalon_st_tx_out_startofpacket = {(1){1'b0}};
    assign dc_avalon_st_tx_out_endofpacket = {(1){1'b0}};
    assign dc_avalon_st_tx_out_empty = {(3){1'b0}};
    assign dc_avalon_st_tx_out_error = {(1){1'b0}};
    
    assign avalon_st_tx_156_ready = {(1){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// RX Packet DC FIFO 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if(USE_RX_DATAPATH && DEVICE_FAMILY == "Stratix 10")
begin : RX_312_TO_156_s10
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT   (8),
        .BITS_PER_SYMBOL    (8),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (6),
        .USE_PACKETS        (1),
        .STREAM_ALMOST_FULL (1),
        .SYNC_RESET_N       (0)
    ) rx_312_to_156 (

        .in_clk(avalon_st_rx_clk_312),
        .in_reset_n(avalon_st_rx_312_reset_n),

        .out_clk(avalon_st_rx_clk_156),
        .out_reset_n(avalon_st_rx_156_reset_n),

        // sink
        .in_data(dc_avalon_st_rx_in_data),
        .in_valid(dc_avalon_st_rx_in_valid & !almost_full_data_rx_156_to_312),
        .in_ready(dc_avalon_st_rx_in_ready),
        .in_startofpacket(dc_avalon_st_rx_in_startofpacket),
        .in_endofpacket(dc_avalon_st_rx_in_endofpacket),
        .in_empty(dc_avalon_st_rx_in_empty),
        .in_error(dc_avalon_st_rx_in_error),
        .in_channel(1'b0),

        // source
        .out_data(avalon_st_rx_156_data),
        .out_valid(avalon_st_rx_156_valid),
        .out_ready(avalon_st_rx_156_ready),
        .out_startofpacket(avalon_st_rx_156_startofpacket),
        .out_endofpacket(avalon_st_rx_156_endofpacket),
        .out_empty(avalon_st_rx_156_empty),
        .out_error(avalon_st_rx_156_error),
        .out_channel(),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(almost_full_data_rx_156_to_312),

        // streaming out status
        .almost_empty_valid(),
        .almost_empty_data(),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd13),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold(5'd2),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    );
end
else if (USE_RX_DATAPATH && DEVICE_FAMILY != "Stratix 10") 
begin : RX_312_TO_156
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT   (8),
        .BITS_PER_SYMBOL    (8),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (6),
        .USE_PACKETS        (1),
        .SYNC_RESET_N       (0)
    ) rx_312_to_156 (

        .in_clk(avalon_st_rx_clk_312),
        .in_reset_n(avalon_st_rx_312_reset_n),

        .out_clk(avalon_st_rx_clk_156),
        .out_reset_n(avalon_st_rx_156_reset_n),

        // sink
        .in_data(dc_avalon_st_rx_in_data),
        .in_valid(dc_avalon_st_rx_in_valid),
        .in_ready(dc_avalon_st_rx_in_ready),
        .in_startofpacket(dc_avalon_st_rx_in_startofpacket),
        .in_endofpacket(dc_avalon_st_rx_in_endofpacket),
        .in_empty(dc_avalon_st_rx_in_empty),
        .in_error(dc_avalon_st_rx_in_error),
        .in_channel(1'b0),

        // source
        .out_data(avalon_st_rx_156_data),
        .out_valid(avalon_st_rx_156_valid),
        .out_ready(avalon_st_rx_156_ready),
        .out_startofpacket(avalon_st_rx_156_startofpacket),
        .out_endofpacket(avalon_st_rx_156_endofpacket),
        .out_empty(avalon_st_rx_156_empty),
        .out_error(avalon_st_rx_156_error),
        .out_channel(),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(),

        // streaming out status
        .almost_empty_valid(),
        .almost_empty_data(),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd0),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold(5'd2),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    );
    
    assign almost_full_data_rx_156_to_312 = 1'b0;
end
else begin
    assign avalon_st_rx_156_data = {(64){1'b0}};
    assign avalon_st_rx_156_valid = {(1){1'b0}};
    assign avalon_st_rx_156_startofpacket = {(1){1'b0}};
    assign avalon_st_rx_156_endofpacket = {(1){1'b0}};
    assign avalon_st_rx_156_empty = {(3){1'b0}};
    assign avalon_st_rx_156_error = {(1){1'b0}};
    
    assign dc_avalon_st_rx_in_ready = {(1){1'b0}};
    assign almost_full_data_rx_156_to_312 = 1'b0;
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// TX 1588 DC FIFO 156 to 312
////////////////////////////////////////////////////////////////////////////////
generate if((ENABLE_TIMESTAMPING) && (USE_TX_DATAPATH))
begin : TX_1588_156_TO_312
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT   (1),
        .BITS_PER_SYMBOL    (TX_1588_156_TO_312_WIDTH),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (0),
        .USE_PACKETS        (0),
        .SYNC_RESET_N       (0)
    ) tx_1588_156_to_312 (

        .in_clk(avalon_st_tx_clk_156),
        .in_reset_n(avalon_st_tx_156_reset_n),

        .out_clk(avalon_st_tx_clk_312),
        .out_reset_n(avalon_st_tx_312_reset_n),

        // sink
        .in_data(wide_bus_tx_1588_into_dc_fifo),
        .in_valid(avalon_st_tx_156_valid & avalon_st_tx_156_ready & avalon_st_tx_156_startofpacket),
        .in_ready(),
        .in_startofpacket(1'b0),
        .in_endofpacket(1'b0),
        .in_empty(1'b0),
        .in_error(1'b0),
        .in_channel(1'b0),

        // source
        .out_data(wide_bus_tx_1588_from_dc_fifo),
        .out_valid(),
        .out_ready(avalon_st_tx_312_valid & avalon_st_tx_312_ready & avalon_st_tx_312_startofpacket),
        .out_startofpacket(),
        .out_endofpacket(),
        .out_empty(),
        .out_error(),
        .out_channel(),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(),

        // streaming out status
        .almost_empty_valid(),
        .almost_empty_data(),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd0),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold(5'd2),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    );
end
else begin
    assign wide_bus_tx_1588_from_dc_fifo = {(TX_1588_156_TO_312_WIDTH){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// RX 1588 DC FIFO 312 to 156
////////////////////////////////////////////////////////////////////////////////
reg             in_valid_ready_eop_for_status;
reg             in_valid_ready_sop_for_rx_1588;
wire            avalon_st_rx_312_valid_pipe1;
wire            avalon_st_rx_312_endofpacket_pipe1;
wire            avalon_st_rx_312_startofpacket_pipe1;
wire    [1:0]   avalon_st_rx_312_empty_pipe1;
wire    [5:0]   avalon_st_rx_312_error_pipe1;
wire    [31:0]  avalon_st_rx_312_data_pipe1;
wire            in_ready_pipe1;

generate if (DEVICE_FAMILY == "Stratix 10")
begin
always @ (posedge avalon_st_rx_clk_312)
    begin
    if(!avalon_st_rx_312_reset_n)
        begin
        in_valid_ready_sop_for_rx_1588 <= 1'b0;
        end
    else
        begin
        if(avalon_st_rx_312_valid & in_ready_pipe1 & avalon_st_rx_312_startofpacket)
            begin
            in_valid_ready_sop_for_rx_1588 <= 1'b1;
            end
        else
            begin
            in_valid_ready_sop_for_rx_1588 <= 1'b0;
            end
        end
    end
end
else
begin
always @ (*)
    begin
    in_valid_ready_sop_for_rx_1588 = avalon_st_rx_312_valid & in_ready_pipe1 & avalon_st_rx_312_startofpacket;
    end
end
endgenerate

generate if((ENABLE_TIMESTAMPING) && (USE_RX_DATAPATH))
begin : RX_1588_312_TO_156
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT   (1),
        .BITS_PER_SYMBOL    (RX_1588_312_TO_156_WIDTH),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (0),
        .USE_PACKETS        (0),
        .SYNC_RESET_N       (0)
    ) rx_1588_312_to_156 (

        .in_clk(avalon_st_rx_clk_312),
        .in_reset_n(avalon_st_rx_312_reset_n),

        .out_clk(avalon_st_rx_clk_156),
        .out_reset_n(avalon_st_rx_156_reset_n),

        // sink
        .in_data(wide_bus_rx_1588_into_dc_fifo),
        .in_valid(in_valid_ready_sop_for_rx_1588),
        .in_ready(),
        .in_startofpacket(1'b0),
        .in_endofpacket(1'b0),
        .in_empty(1'b0),
        .in_error(1'b0),
        .in_channel(1'b0),

        // source
        .out_data(wide_bus_rx_1588_from_dc_fifo),
        .out_valid(rx_1588_valid_wire),
        .out_ready(avalon_st_rx_156_valid & avalon_st_rx_156_ready & avalon_st_rx_156_startofpacket),
        .out_startofpacket(),
        .out_endofpacket(),
        .out_empty(),
        .out_error(),
        .out_channel(),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(),

        // streaming out status
        .almost_empty_valid(),
        .almost_empty_data(),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd0),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold(5'd2),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    );
end
else begin
    assign wide_bus_rx_1588_from_dc_fifo = {(RX_1588_312_TO_156_WIDTH){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// RX Status DC FIFO 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if (DEVICE_FAMILY == "Stratix 10")
begin : PIPELINE_BASE_S10

// add a pipeline stage before go in to the adapter
    alt_em10g32_pipeline_base #(
            .BITS_PER_SYMBOL    (32 + 1 + 1 + 6 + 2),
            .SYMBOLS_PER_BEAT   (1),
            .PIPELINE_READY     (0)
            ) buffer_1 (
            .clk        (avalon_st_rx_clk_312),
            .reset_n    (avalon_st_rx_312_reset_n),
            .in_ready   (avalon_st_rx_312_ready),
            .in_valid   (avalon_st_rx_312_valid),
            .in_data    ({avalon_st_rx_312_data,avalon_st_rx_312_startofpacket,avalon_st_rx_312_endofpacket,avalon_st_rx_312_error,avalon_st_rx_312_empty}),
            .out_ready  (in_ready_pipe1),
            .out_valid  (avalon_st_rx_312_valid_pipe1),
            .out_data   ({avalon_st_rx_312_data_pipe1,avalon_st_rx_312_startofpacket_pipe1,avalon_st_rx_312_endofpacket_pipe1,avalon_st_rx_312_error_pipe1,avalon_st_rx_312_empty_pipe1})
        );



// flop a layer before go in to the fifo to improve timing
always @ (posedge avalon_st_rx_clk_312)
    begin
    if(!avalon_st_rx_312_reset_n)
        begin
        in_valid_ready_eop_for_status <= 1'b0;
        end
    else
        begin
        if(avalon_st_rx_312_valid & in_ready_pipe1 & avalon_st_rx_312_endofpacket)
            begin
            in_valid_ready_eop_for_status <= 1'b1;
            end
        else
            begin
            in_valid_ready_eop_for_status <= 1'b0;
            end
        end
    end
end
else
begin

assign avalon_st_rx_312_data_pipe1 = avalon_st_rx_312_data;
assign avalon_st_rx_312_startofpacket_pipe1 = avalon_st_rx_312_startofpacket;
assign avalon_st_rx_312_endofpacket_pipe1 = avalon_st_rx_312_endofpacket;
assign avalon_st_rx_312_error_pipe1 = avalon_st_rx_312_error;
assign avalon_st_rx_312_empty_pipe1 = avalon_st_rx_312_empty;
assign avalon_st_rx_312_ready = in_ready_pipe1;
assign avalon_st_rx_312_valid_pipe1 = avalon_st_rx_312_valid;

always @ (*)
    begin
    in_valid_ready_eop_for_status = avalon_st_rx_312_valid & in_ready_pipe1 & avalon_st_rx_312_endofpacket;
    end

end
endgenerate 

generate if(USE_RX_DATAPATH)
begin : RX_STATUS_312_TO_156
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT   (1),
        .BITS_PER_SYMBOL    (48),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (0),
        .USE_PACKETS        (0),
        .SYNC_RESET_N       (0)
    ) rx_status_312_to_156 (

        .in_clk(avalon_st_rx_clk_312),
        .in_reset_n(avalon_st_rx_312_reset_n),

        .out_clk(avalon_st_rx_clk_156),
        .out_reset_n(avalon_st_rx_156_reset_n),

        // sink
        .in_data(wide_bus_rx_status_into_dc_fifo),
        .in_valid(in_valid_ready_eop_for_status),
        .in_ready(),
        .in_startofpacket(1'b0),
        .in_endofpacket(1'b0),
        .in_empty(1'b0),
        .in_error(1'b0),
        .in_channel(1'b0),

        // source
        .out_data(wide_bus_rx_status_from_dc_fifo),
        .out_valid(rx_status_valid_wire),
        .out_ready(avalon_st_rx_156_valid & avalon_st_rx_156_ready & avalon_st_rx_156_endofpacket),
        .out_startofpacket(),
        .out_endofpacket(),
        .out_empty(),
        .out_error(),
        .out_channel(),

        // streaming in status
        .almost_full_valid(),
        .almost_full_data(),

        // streaming out status
        .almost_empty_valid(),
        .almost_empty_data(),
        
        // in clock
        .in_fill_level(),
        .almost_full_threshold(5'd0),
        
        // out clock
        .out_fill_level(),
        .almost_empty_threshold(5'd2),
        
        .space_avail_data(),
        
        // Latency Measurement
        .sampling_clk(1'b0),
        .sampling_clk_reset_n(1'b0),
        
        .latency_out_clk(1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out()
    );
end
else begin
    assign wide_bus_rx_status_from_dc_fifo = {(48){1'b0}};
end
endgenerate

avalon_st_adapter adapter (

    .avalon_st_tx_clk_clk           (avalon_st_tx_clk_312),          
    .avalon_st_tx_reset_reset_n     (avalon_st_tx_312_reset_n),    
    
    // ----------------------
	// modification starts
	// ----------------------
    .avalon_st_tx_in_ready          (adpt_avalon_st_tx_out_ready),         
    .avalon_st_tx_in_valid          (adpt_avalon_st_tx_out_valid),         
    .avalon_st_tx_in_data           (adpt_avalon_st_tx_out_data),          
    .avalon_st_tx_in_error          (adpt_avalon_st_tx_out_error),         
    .avalon_st_tx_in_startofpacket  (adpt_avalon_st_tx_out_startofpacket), 
    .avalon_st_tx_in_endofpacket    (adpt_avalon_st_tx_out_endofpacket),   
    .avalon_st_tx_in_empty          (adpt_avalon_st_tx_out_empty),         

    // .avalon_st_tx_in_ready          (dc_avalon_st_tx_out_ready),         
    // .avalon_st_tx_in_valid          (dc_avalon_st_tx_out_valid),         
    // .avalon_st_tx_in_data           (dc_avalon_st_tx_out_data),          
    // .avalon_st_tx_in_error          (dc_avalon_st_tx_out_error),         
    // .avalon_st_tx_in_startofpacket  (dc_avalon_st_tx_out_startofpacket), 
    // .avalon_st_tx_in_endofpacket    (dc_avalon_st_tx_out_endofpacket),   
    // .avalon_st_tx_in_empty          (dc_avalon_st_tx_out_empty),         

	// ----------------------
	// modification ends
	// ----------------------
    
    .avalon_st_tx_out_ready         (avalon_st_tx_312_ready),        
    .avalon_st_tx_out_valid         (avalon_st_tx_312_valid),        
    .avalon_st_tx_out_data          (avalon_st_tx_312_data),         
    .avalon_st_tx_out_error         (avalon_st_tx_312_error),        
    .avalon_st_tx_out_startofpacket (avalon_st_tx_312_startofpacket),
    .avalon_st_tx_out_endofpacket   (avalon_st_tx_312_endofpacket),  
    .avalon_st_tx_out_empty         (avalon_st_tx_312_empty),        
    .avalon_st_rx_clk_clk           (avalon_st_rx_clk_312),          
    .avalon_st_rx_reset_reset_n     (avalon_st_rx_312_reset_n),    
    .avalon_st_rx_in_ready          (in_ready_pipe1),         
    .avalon_st_rx_in_valid          (avalon_st_rx_312_valid_pipe1),         
    .avalon_st_rx_in_data           (avalon_st_rx_312_data_pipe1),          
    .avalon_st_rx_in_error          (avalon_st_rx_312_error_pipe1),         
    .avalon_st_rx_in_startofpacket  (avalon_st_rx_312_startofpacket_pipe1), 
    .avalon_st_rx_in_endofpacket    (avalon_st_rx_312_endofpacket_pipe1),   
    .avalon_st_rx_in_empty          (avalon_st_rx_312_empty_pipe1),         
    .avalon_st_rx_out_ready         (dc_avalon_st_rx_in_ready & !almost_full_data_rx_156_to_312),        
    .avalon_st_rx_out_valid         (dc_avalon_st_rx_in_valid ),        
    .avalon_st_rx_out_data          (dc_avalon_st_rx_in_data),         
    .avalon_st_rx_out_error         (dc_avalon_st_rx_in_error),        
    .avalon_st_rx_out_startofpacket (dc_avalon_st_rx_in_startofpacket),
    .avalon_st_rx_out_endofpacket   (dc_avalon_st_rx_in_endofpacket),  
    .avalon_st_rx_out_empty         (dc_avalon_st_rx_in_empty)         



);

////////////////////////////////////////////////////////////////////////////////
// TX Status 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if(USE_TX_DATAPATH)
begin : TX_STATUS_312_TO_156
    altera_eth_sideband_crosser #(
        .WIDTH              (40+7),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N (SYNC_RESET_N)
    ) tx_status_312_to_156 (
        .in_clk     (avalon_st_tx_clk_312),
        .in_rst_n   (avalon_st_tx_312_reset_n),
        
        .out_clk    (avalon_st_tx_clk_156),
        .out_rst_n  (avalon_st_tx_156_reset_n),
        
        .in_valid   (avalon_st_txstatus_valid_312),
        .in_data    ({avalon_st_txstatus_error_312, avalon_st_txstatus_data_312}),
        
        .out_valid  (avalon_st_txstatus_valid_156),
        .out_data   ({avalon_st_txstatus_error_156, avalon_st_txstatus_data_156})
    );
end
else begin
    assign avalon_st_txstatus_valid_156 = {(1){1'b0}};
    assign {avalon_st_txstatus_error_156, avalon_st_txstatus_data_156} = {(40+7){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// TX PFC Status 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if((ENABLE_PFC) && (USE_TX_DATAPATH))
begin : TX_PFC_STATUS_312_TO_156
    altera_eth_sideband_crosser #(
        .WIDTH              (PFC_PRIORITY_NUMBER * 2),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N (SYNC_RESET_N)
    ) tx_pfc_status_312_to_156 (
        .in_clk     (avalon_st_tx_clk_312),
        .in_rst_n   (avalon_st_tx_312_reset_n),
        
        .out_clk    (avalon_st_tx_clk_156),
        .out_rst_n  (avalon_st_tx_156_reset_n),
        
        .in_valid   (avalon_st_tx_pfc_status_valid_312),
        .in_data    (avalon_st_tx_pfc_status_data_312),
        
        .out_valid  (avalon_st_tx_pfc_status_valid_156),
        .out_data   (avalon_st_tx_pfc_status_data_156)
    );
end
else begin
    assign avalon_st_tx_pfc_status_valid_156 = 1'b0;
    assign avalon_st_tx_pfc_status_data_156 = {(PFC_PRIORITY_NUMBER * 2){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// TX Timestamp 96b 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if((ENABLE_TIMESTAMPING) && (USE_TX_DATAPATH) && (USE_96B_TIME_FORMAT))
begin : TX_EGRESS_TIMESTAMP_96B_312_TO_156
    altera_eth_sideband_crosser #(
        .WIDTH              (96+TSTAMP_FP_WIDTH),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N (SYNC_RESET_N)
    ) tx_egress_timestamp_96b_312_to_156 (
        .in_clk     (avalon_st_tx_clk_312),
        .in_rst_n   (avalon_st_tx_312_reset_n),
        
        .out_clk    (avalon_st_tx_clk_156),
        .out_rst_n  (avalon_st_tx_156_reset_n),
        
        .in_valid   (tx_egress_timestamp_96b_valid_312),
        .in_data    ({tx_egress_timestamp_96b_fingerprint_312, tx_egress_timestamp_96b_data_312}),
        
        .out_valid  (tx_egress_timestamp_96b_valid_156),
        .out_data   ({tx_egress_timestamp_96b_fingerprint_156, tx_egress_timestamp_96b_data_156})
    );
end
else begin
    assign tx_egress_timestamp_96b_valid_156 = 1'b0;
    assign {tx_egress_timestamp_96b_fingerprint_156, tx_egress_timestamp_96b_data_156} = {(96+TSTAMP_FP_WIDTH){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// TX Timestamp 64b 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if((ENABLE_TIMESTAMPING) && (USE_TX_DATAPATH) && (USE_64B_TIME_FORMAT))
begin : TX_EGRESS_TIMESTAMP_64B_312_TO_156
    altera_eth_sideband_crosser #(
        .WIDTH              (64+TSTAMP_FP_WIDTH),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N (SYNC_RESET_N)
    ) tx_egress_timestamp_64b_312_to_156 (
        .in_clk     (avalon_st_tx_clk_312),
        .in_rst_n   (avalon_st_tx_312_reset_n),
        
        .out_clk    (avalon_st_tx_clk_156),
        .out_rst_n  (avalon_st_tx_156_reset_n),
        
        .in_valid   (tx_egress_timestamp_64b_valid_312),
        .in_data    ({tx_egress_timestamp_64b_fingerprint_312, tx_egress_timestamp_64b_data_312}),
        
        .out_valid  (tx_egress_timestamp_64b_valid_156),
        .out_data   ({tx_egress_timestamp_64b_fingerprint_156, tx_egress_timestamp_64b_data_156})
    );
end
else begin
    assign tx_egress_timestamp_64b_valid_156 = 1'b0;
    assign {tx_egress_timestamp_64b_fingerprint_156, tx_egress_timestamp_64b_data_156} = {(64+TSTAMP_FP_WIDTH){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// RX Pause Length 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if((USE_RX_DATAPATH) && (!USE_TX_DATAPATH))
begin : RX_PAUSE_LENGTH_312_TO_156
    altera_eth_sideband_crosser #(
        .WIDTH              (16),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N (SYNC_RESET_N)
    ) rx_pause_length_312_to_156 (
        .in_clk     (avalon_st_rx_clk_312),
        .in_rst_n   (avalon_st_rx_312_reset_n),
        
        .out_clk    (avalon_st_rx_clk_156),
        .out_rst_n  (avalon_st_rx_156_reset_n),
        
        .in_valid   (avalon_st_rx_pause_length_valid_312),
        .in_data    (avalon_st_rx_pause_length_data_312),
        
        .out_valid  (avalon_st_rx_pause_length_valid_156),
        .out_data   (avalon_st_rx_pause_length_data_156)
    );
end
else begin
    assign avalon_st_rx_pause_length_valid_156 = 1'b0;
    assign avalon_st_rx_pause_length_data_156 = {(16){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// RX PFC Status 312 to 156
////////////////////////////////////////////////////////////////////////////////
generate if((ENABLE_PFC) && (USE_RX_DATAPATH))
begin : RX_PFC_STATUS_312_TO_156
    altera_eth_sideband_crosser #(
        .WIDTH              (PFC_PRIORITY_NUMBER * 2),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N       (SYNC_RESET_N)
    ) rx_pfc_status_312_to_156 (
        .in_clk     (avalon_st_rx_clk_312),
        .in_rst_n   (avalon_st_rx_312_reset_n),
        
        .out_clk    (avalon_st_rx_clk_156),
        .out_rst_n  (avalon_st_rx_156_reset_n),
        
        .in_valid   (avalon_st_rx_pfc_status_valid_312),
        .in_data    (avalon_st_rx_pfc_status_data_312),
        
        .out_valid  (avalon_st_rx_pfc_status_valid_156),
        .out_data   (avalon_st_rx_pfc_status_data_156)
    );
end
else begin
    assign avalon_st_rx_pfc_status_valid_156 = 1'b0;
    assign avalon_st_rx_pfc_status_data_156 = {(PFC_PRIORITY_NUMBER * 2){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// TX Pause Length 156 to 312
////////////////////////////////////////////////////////////////////////////////
generate if((USE_TX_DATAPATH) && (!USE_RX_DATAPATH))
begin : TX_PAUSE_LENGTH_156_TO_312
    altera_eth_sideband_crosser #(
        .WIDTH              (16),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N       (SYNC_RESET_N)
    ) tx_pause_length_156_to_312 (
        .in_clk     (avalon_st_tx_clk_156),
        .in_rst_n   (avalon_st_tx_156_reset_n),
        
        .out_clk    (avalon_st_tx_clk_312),
        .out_rst_n  (avalon_st_tx_312_reset_n),
        
        .in_valid   (avalon_st_tx_pause_length_valid_156),
        .in_data    (avalon_st_tx_pause_length_data_156),
        
        .out_valid  (avalon_st_tx_pause_length_valid_312),
        .out_data   (avalon_st_tx_pause_length_data_312)
    );
end
else begin
    assign avalon_st_tx_pause_length_valid_312 = 1'b0;
    assign avalon_st_tx_pause_length_data_312 = {(16){1'b0}};
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// TX Sideband DC FIFO 156 to 312
////////////////////////////////////////////////////////////////////////////////
generate if((USE_ASYNC_ADAPTOR) && (USE_TX_DATAPATH))
begin : TX_SIDEBAND

    if (SYNC_RESET_N == 1) begin
      always @(posedge avalon_st_tx_clk_312) begin
          if(!avalon_st_tx_312_reset_n) begin
              tx_dc_fifo_156_to_312_read_ready <= 1'b0;
              tx_dc_fifo_156_to_312_out_ready <= 1'b0;
          end
          else begin
              if(~tx_dc_fifo_156_to_312_almost_empty) begin
                  tx_dc_fifo_156_to_312_read_ready <= 1'b1;
              end
              
              tx_dc_fifo_156_to_312_out_ready <= ~tx_dc_fifo_156_to_312_out_ready;
          end
      end
    end else begin
      always @(posedge avalon_st_tx_clk_312 or negedge avalon_st_tx_312_reset_n) begin
          if(!avalon_st_tx_312_reset_n) begin
              tx_dc_fifo_156_to_312_read_ready <= 1'b0;
              tx_dc_fifo_156_to_312_out_ready <= 1'b0;
          end
          else begin
              if(~tx_dc_fifo_156_to_312_almost_empty) begin
                  tx_dc_fifo_156_to_312_read_ready <= 1'b1;
              end
              
              tx_dc_fifo_156_to_312_out_ready <= ~tx_dc_fifo_156_to_312_out_ready;
          end
      end
    end

    if(ENABLE_PFC) begin
        assign wide_bus_into_tx_dc_fifo_156_to_312 = {
            avalon_st_tx_pfc_data_156,
            
            avalon_st_tx_pause_data_156
        };
        
        assign {
            avalon_st_tx_pfc_data_312,
            
            avalon_st_tx_pause_data_312
        } = (tx_dc_fifo_156_to_312_read_ready & tx_dc_fifo_156_to_312_out_valid) ? wide_bus_from_tx_dc_fifo_156_to_312 : {TX_DC_FIFO_156_TO_312_WIDTH{1'b0}};
    end
    else begin
        assign wide_bus_into_tx_dc_fifo_156_to_312 = {
            avalon_st_tx_pause_data_156
        };
        
        assign avalon_st_tx_pause_data_312 = (tx_dc_fifo_156_to_312_read_ready & tx_dc_fifo_156_to_312_out_valid) ? wide_bus_from_tx_dc_fifo_156_to_312 : {TX_DC_FIFO_156_TO_312_WIDTH{1'b0}};
        
        assign avalon_st_tx_pfc_data_312 = {(PFC_PRIORITY_NUMBER){1'b0}};
    end
    
    alt_em10g32_avalon_dc_fifo #(
        .DEVICE_FAMILY      (DEVICE_FAMILY),
        .SYMBOLS_PER_BEAT   (1),
        .BITS_PER_SYMBOL    (TX_DC_FIFO_156_TO_312_WIDTH),
        .FIFO_DEPTH         (16),
        .ERROR_WIDTH        (0),
        .USE_PACKETS        (0),
        .STREAM_ALMOST_EMPTY(1),
        .SYNC_RESET_N       (0)
    ) tx_dc_fifo_156_to_312 (
        
        .in_clk                 (avalon_st_tx_clk_156),
        .in_reset_n             (avalon_st_tx_156_reset_n),
        
        .out_clk                (avalon_st_tx_clk_312),
        .out_reset_n            (avalon_st_tx_312_reset_n),
        
        // sink
        .in_data                (wide_bus_into_tx_dc_fifo_156_to_312),
        .in_valid               (1'b1),
        .in_ready               (),
        .in_startofpacket       (1'b0),
        .in_endofpacket         (1'b0),
        .in_empty               (1'b0),
        .in_error               (1'b0),
        .in_channel             (1'b0),
        
        // source
        .out_data               (wide_bus_from_tx_dc_fifo_156_to_312),
        .out_valid              (tx_dc_fifo_156_to_312_out_valid),
        .out_ready              (tx_dc_fifo_156_to_312_read_ready & tx_dc_fifo_156_to_312_out_ready),
        .out_startofpacket      (),
        .out_endofpacket        (),
        .out_empty              (),
        .out_error              (),
        .out_channel            (),
        
        // streaming in status
        .almost_full_valid      (),
        .almost_full_data       (),
        
        // streaming out status
        .almost_empty_valid     (),
        .almost_empty_data      (tx_dc_fifo_156_to_312_almost_empty),
        
        // in clock
        .in_fill_level          (),
        .almost_full_threshold  (5'd0),
        
        // out clock
        .out_fill_level         (),
        .almost_empty_threshold (5'd2),
        
        .space_avail_data       (),
        
        // Latency Measurement
        .sampling_clk           (1'b0),
        .sampling_clk_reset_n   (1'b0),
        
        .latency_out_clk        (1'b0),
        .latency_out_clk_reset_n(1'b0),
        
        .latency_out            ()
    );
end
else begin
    
    if((ENABLE_PFC) && (USE_TX_DATAPATH)) begin
        
        if (SYNC_RESET_N == 1) begin
          always @(posedge avalon_st_tx_clk_156) begin
              if(!avalon_st_tx_156_reset_n) begin
                  avalon_st_tx_pfc_data_156_reg <= {(PFC_PRIORITY_NUMBER * 2){1'b0}};
              end
              else begin
                  avalon_st_tx_pfc_data_156_reg <= avalon_st_tx_pfc_data_156;
              end
          end
        end else begin
          always @(posedge avalon_st_tx_clk_156 or negedge avalon_st_tx_156_reset_n) begin
              if(!avalon_st_tx_156_reset_n) begin
                  avalon_st_tx_pfc_data_156_reg <= {(PFC_PRIORITY_NUMBER * 2){1'b0}};
              end
              else begin
                  avalon_st_tx_pfc_data_156_reg <= avalon_st_tx_pfc_data_156;
              end
          end
        end
        
        assign avalon_st_tx_pfc_data_312 = avalon_st_tx_pfc_data_156_reg;
        
    end
    else begin
        
        assign avalon_st_tx_pfc_data_312 = {(PFC_PRIORITY_NUMBER * 2){1'b0}};
        
    end
    
    if(USE_TX_DATAPATH) begin
        
        if (SYNC_RESET_N == 1) begin
          always @(posedge avalon_st_tx_clk_156) begin
              if(!avalon_st_tx_156_reset_n) begin
                  avalon_st_tx_pause_data_156_reg <= 2'h0;
              end
              else begin
                  avalon_st_tx_pause_data_156_reg <= avalon_st_tx_pause_data_156;
              end
          end
        end else begin
          always @(posedge avalon_st_tx_clk_156 or negedge avalon_st_tx_156_reset_n) begin
              if(!avalon_st_tx_156_reset_n) begin
                  avalon_st_tx_pause_data_156_reg <= 2'h0;
              end
              else begin
                  avalon_st_tx_pause_data_156_reg <= avalon_st_tx_pause_data_156;
              end
          end
        end
        
        assign avalon_st_tx_pause_data_312 = avalon_st_tx_pause_data_156_reg;
        
    end
    else begin
        
        assign avalon_st_tx_pause_data_312 = 2'h0;
        
    end
    
end
endgenerate

////////////////////////////////////////////////////////////////////////////////
// RX PFC Pause Data
////////////////////////////////////////////////////////////////////////////////
generate if((ENABLE_PFC) && (USE_RX_DATAPATH))
begin : RX_PFC_PAUSE_312_TO_156

    // Delay the write in the fast clock domain, due to reset of slow clock deasserted later by reset synchronizer
  if (SYNC_RESET_N == 1) begin
    always @(posedge avalon_st_rx_clk_312) begin
        if(!avalon_st_rx_312_reset_n) begin
            rx_pfc_pause_write_ready_delay <= 8'b1000_0000;
            rx_pfc_pause_write_ready <= 1'b0;
            rx_pfc_pause_in_valid <= 1'b0;
        end
        else begin
            rx_pfc_pause_write_ready_delay[7:0] <= {1'b0, rx_pfc_pause_write_ready_delay[7:1]};
            
            if(rx_pfc_pause_write_ready_delay[0]) begin
                rx_pfc_pause_write_ready <= 1'b1;
            end
            
            rx_pfc_pause_in_valid <= ~rx_pfc_pause_in_valid;
        end
    end
  end else begin
    always @(posedge avalon_st_rx_clk_312 or negedge avalon_st_rx_312_reset_n) begin
        if(!avalon_st_rx_312_reset_n) begin
            rx_pfc_pause_write_ready_delay <= 8'b1000_0000;
            rx_pfc_pause_write_ready <= 1'b0;
            rx_pfc_pause_in_valid <= 1'b0;
        end
        else begin
            rx_pfc_pause_write_ready_delay[7:0] <= {1'b0, rx_pfc_pause_write_ready_delay[7:1]};
            
            if(rx_pfc_pause_write_ready_delay[0]) begin
                rx_pfc_pause_write_ready <= 1'b1;
            end
            
            rx_pfc_pause_in_valid <= ~rx_pfc_pause_in_valid;
        end
    end
  end
    
    assign avalon_st_rx_pfc_pause_data_156 = rx_pfc_pause_out_valid ? avalon_st_rx_pfc_pause_data_156_wire : {PFC_PRIORITY_NUMBER{1'b0}};
    
    altera_eth_sideband_crosser #(
        .WIDTH              (PFC_PRIORITY_NUMBER),
        .USE_ASYNC_ADAPTOR  (USE_ASYNC_ADAPTOR),
        .SYNC_RESET_N       (SYNC_RESET_N)
    ) rx_pfc_pause_312_to_156 (
        .in_clk     (avalon_st_rx_clk_312),
        .in_rst_n   (avalon_st_rx_312_reset_n),
        
        .out_clk    (avalon_st_rx_clk_156),
        .out_rst_n  (avalon_st_rx_156_reset_n),
        
        .in_valid   (rx_pfc_pause_write_ready & rx_pfc_pause_in_valid),
        .in_data    (avalon_st_rx_pfc_pause_data_312),
        
        .out_valid  (rx_pfc_pause_out_valid),
        .out_data   (avalon_st_rx_pfc_pause_data_156_wire)
    );
end
else begin
    assign avalon_st_rx_pfc_pause_data_156 = {(PFC_PRIORITY_NUMBER){1'b0}};
end
endgenerate

endmodule
