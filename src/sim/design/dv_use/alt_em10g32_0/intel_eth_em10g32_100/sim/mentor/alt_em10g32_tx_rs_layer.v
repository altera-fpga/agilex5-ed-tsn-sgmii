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

module alt_em10g32_tx_rs_layer #(
    parameter DEVICE_FAMILY         = "Stratix V",
    parameter SYMBOLPERBEAT         = 8,
    parameter LINK_FAULT_DATAWIDTH  = 2,
    parameter ENABLE_MEM_ECC        = 0,
    parameter FORWARD_SYNC_DEPTH    = 3,
    parameter BACKWARD_SYNC_DEPTH   = 3,
    parameter PREAMBLE_PASSTHROUGH   = 0,
    parameter ENABLE_1G10G_MAC      = 0,
    parameter ENABLE_10GBASER_REG_MODE       = 0,
    parameter ENABLE_XGMII          = 1,
    parameter ENABLE_GMII16B        = 0,
    parameter SYNC_RESET_N          = 1
) (
    // clock and reset for st
    input wire clk,     
    input wire rst_n,
    input wire rst_n_asyn,

    // CSR control path
    input wire csr_preamble_passthru,
    input wire csr_crc_inst_en,
    input wire csr_tx_unidirectional_en,
    input wire csr_tx_unidirectional_remote_fault_dis,
    input wire csr_tx_unidirectional_force_remote_fault,
	
	input wire enable_unidirectional,

    // Av-ST control path
    input wire [LINK_FAULT_DATAWIDTH-1:0]rx_link_fault_status,
    
    // Av-ST STM_DATA path
    input wire mx2rs_ethfrm_sop,
    input wire mx2rs_ethfrm_valid,
    output wire rs2mx_ethfrm_ready,
    input wire mx2rs_ethfrm_eop,
    input wire [31:0]mx2rs_ethfrm_data,
    input wire [1:0]mx2rs_ethfrm_empty,
    input wire [1:0]mx2rs_ethfrm_error,
    input wire [1:0] mx2rs_ethfrm_pre_error,
    
    
    input wire [1:0]mx2rs_frm_type,
    
    //output to CRC
    output wire rs2crc_sop,
    output wire rs2crc_eop,
    output wire [1:0]rs2crc_empty,
    output wire [31:0]rs2crc_data,    
    output wire rs2crc_clken,
    
    
    output wire rs2frm_dec_sop,
    output wire rs2frm_dec_valid,
    output wire rs2frm_dec_eop,
    output wire [1:0]rs2frm_dec_empty,
    output wire [31:0]rs2frm_dec_data,
    output wire [1:0]rs2frm_dec_error,
    output wire [1:0]rs2frm_dec_frm_type,

    //input from CRC
    input wire crc2rs_result_valid,
    input wire [31:0]crc2rs_result,
    
    output wire  [31:0]rs2top_eth_xgmii_data,
    output wire  [3:0]rs2top_eth_xgmii_ctrl,    
    output wire  rs2top_eth_xgmii_valid,
    
    
    // input and output ports for GMII/MII interface
    // clock and reset for GMII interface only
    input wire clock_gmii,
    input wire reset_gmii_n,
    input wire reset_gmii_n_asyn,
    
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
    
    // scr input to control ipg
    input wire [7:0]ipg_value_10g,
    input wire [7:0]ipg_value_1g, 
  
    // speed sel port to select speed for MAC
    input wire [2:0]speed_sel,

    // clock enable to use for GMII/MII
    input wire tx_clkena,
    input wire tx_clkena_half_rate,
    
    // 1588
    input  wire        enable_timestamping,
    input  wire        enable_ptp_1step,
    
    output wire [3:0]  xgmii2ptp_xgmii_control,
    output wire [31:0] xgmii2ptp_xgmii_data,
    output wire [1:0]  xgmii2ptp_xgmii_channel,
    
    input  wire [3:0]  ptp2xgmii_xgmii_control,
    input  wire [31:0] ptp2xgmii_xgmii_data,
    
    output wire        gmii2ptp_gmii_control,
    output wire [7:0]  gmii2ptp_gmii_data,
    output wire        gmii2ptp_gmii_error,
    output wire [1:0]  gmii2ptp_gmii_channel,
    
    input  wire        ptp2gmii_gmii_control,
    input  wire [7:0]  ptp2gmii_gmii_data,
    input  wire        ptp2gmii_gmii_error,
    
    output wire [ 1:0]  gmii16b2ptp_gmii16b_control,
    output wire [15:0]  gmii16b2ptp_gmii16b_data,
    output wire [ 1:0]  gmii16b2ptp_gmii16b_error,
    output wire [ 1:0]  gmii16b2ptp_gmii16b_channel,
    
    input  wire [ 1:0]  ptp2gmii16b_gmii16b_control,
    input  wire [15:0]  ptp2gmii16b_gmii16b_data,
    input  wire [ 1:0]  ptp2gmii16b_gmii16b_error,
    
    output wire        tx_packet_in_progress_rs,
    
    // ECC status
    output wire        tx_gmii_encoder_ecc_err_corrected,
    output wire        tx_gmii_encoder_ecc_err_fatal
    
);

wire                mx2rs_ethfrm_sop_xgmii;
wire                mx2rs_ethfrm_valid_xgmii;
wire                rs2mx_ethfrm_ready_xgmii;
wire                mx2rs_ethfrm_eop_xgmii;
wire        [31:0]  mx2rs_ethfrm_data_xgmii;
wire                mx2rs_ethfrm_error_xgmii;

wire                rs2crc_sop_xgmii;
wire                rs2crc_valid_xgmii;
wire                rs2crc_eop_xgmii;
wire                rs2crc_empty_xgmii;
wire                rs2crc_data_xgmii;

wire                mx2rs_ethfrm_sop_gmii_mii;
wire                mx2rs_ethfrm_valid_gmii_mii;
wire                rs2mx_ethfrm_ready_gmii_mii;
wire                mx2rs_ethfrm_eop_gmii_mii;
wire        [31:0]  mx2rs_ethfrm_data_gmii_mii;
wire                mx2rs_ethfrm_error_gmii_mii;

// output pipeline base
wire                mx2rs_ethfrm_sop_gmii_mii_int;
wire                mx2rs_ethfrm_valid_gmii_mii_int;
wire                rs2mx_ethfrm_ready_gmii_mii_int;
wire                mx2rs_ethfrm_eop_gmii_mii_int;
wire        [31:0]  mx2rs_ethfrm_data_gmii_mii_int;
wire        [1:0]   mx2rs_ethfrm_empty_gmii_mii_int;
wire        [1:0]   mx2rs_ethfrm_error_gmii_mii_int;
wire        [1:0]   mx2rs_frm_type_int;

// Set SYNCHRONIZER_IDENTIFICATION=OFF because csr_preamble_passthru is a pseudo-static CSR field
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg                 mx2rs_ethfrm_sop_dly1;
// reg                 mx2rs_ethfrm_sop_dly2;
      
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg                 mx2rs_ethfrm_eop_dly1;
reg                 mx2rs_ethfrm_eop_dly2;
reg                 mx2rs_ethfrm_eop_dly3;
reg                 mx2rs_ethfrm_eop_dly4;
reg                 mx2rs_ethfrm_eop_dly5;
reg                 mx2rs_ethfrm_eop_hold;

// status to report packet in progress
wire                tx_packet_in_progress_xgmii;
wire                tx_packet_in_progress_gmii_mii;
wire                tx_packet_in_progress_gmii16b;


// if ENABLE_1G10G_MAC == 5, this is NBASET mode, this mean all MAC will only use xgmii interface with valid as clock enable to control the speed. 

// Speed sel will be determine which module got the ST buses
assign mx2rs_ethfrm_sop_xgmii = (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?mx2rs_ethfrm_sop:1'b0;
assign mx2rs_ethfrm_valid_xgmii = (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?mx2rs_ethfrm_valid:1'b0;
assign mx2rs_ethfrm_eop_xgmii = (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?mx2rs_ethfrm_eop:1'b0;

assign mx2rs_ethfrm_sop_gmii_mii = (speed_sel != 3'b0 && ENABLE_1G10G_MAC != 5)?mx2rs_ethfrm_sop:1'b0;
assign mx2rs_ethfrm_valid_gmii_mii = (speed_sel != 3'b0 && ENABLE_1G10G_MAC != 5)?mx2rs_ethfrm_valid:1'b0;
assign mx2rs_ethfrm_eop_gmii_mii = (speed_sel != 3'b0 && ENABLE_1G10G_MAC != 5)?mx2rs_ethfrm_eop:1'b0;
assign rs2mx_ethfrm_ready = (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5) ? ((ENABLE_XGMII == 1) ? rs2mx_ethfrm_ready_xgmii : 1'b0) :rs2mx_ethfrm_ready_gmii_mii;

generate if(DEVICE_FAMILY == "Stratix 10" || (DEVICE_FAMILY == "Agilex 5"))
begin
// addtional flop to match with the data that go to CRC
reg [1:0]   flop_error;
// reg [1:0]   flop_frm_type;
reg         flop_valid;
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF "} *) reg         flop_sop;
reg         flop_eop;
reg [1:0]   flop_empty;
reg         flop_clken;
reg [31:0]  flop_data;   


always @ (posedge clk)
    begin
    if(!rst_n)
        begin
        flop_sop <= 1'b0;
        flop_eop <= 1'b0;
        flop_empty <= 2'b0;
        flop_clken <= 1'b0;
        
        flop_error  <= 2'b0;
        // flop_frm_type <= 2'b0;
        flop_valid <= 1'b0;
        end
    else
        begin
        flop_sop <= (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?rs2crc_sop_xgmii:mx2rs_ethfrm_sop;
        flop_eop <= mx2rs_ethfrm_eop;
        flop_empty <= mx2rs_ethfrm_empty;
        flop_clken <= (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?((rs2mx_ethfrm_ready_xgmii & mx2rs_ethfrm_valid_xgmii) | mx2rs_ethfrm_eop_hold):((rs2mx_ethfrm_ready_gmii_mii & mx2rs_ethfrm_valid) | mx2rs_ethfrm_eop_hold);
        
        flop_error <= mx2rs_ethfrm_error;
        // flop_frm_type[1] <=  rs2frm_dec_valid & mx2rs_frm_type[1];
        // flop_frm_type[0] <=  rs2frm_dec_valid & mx2rs_frm_type[0];
        flop_valid <= (csr_preamble_passthru == 1'b1 && (speed_sel == 3'b000 || ENABLE_1G10G_MAC == 5) && (mx2rs_frm_type[1] != 1))?(rs2mx_ethfrm_ready_xgmii & mx2rs_ethfrm_valid & !mx2rs_ethfrm_sop & !mx2rs_ethfrm_sop_dly1):(mx2rs_ethfrm_valid & rs2mx_ethfrm_ready);
        end
    end

always @ (posedge clk)
    begin
    flop_data <= mx2rs_ethfrm_data;
    end
    
assign rs2crc_sop = flop_sop;
assign rs2crc_eop = flop_eop;
assign rs2crc_empty = flop_empty;
assign rs2crc_data = flop_data;
assign rs2crc_clken = flop_clken;

// additional fan out to frame decoder. 
assign rs2frm_dec_sop = rs2crc_sop;
assign rs2frm_dec_valid = flop_valid;
assign rs2frm_dec_eop = rs2crc_eop;
assign rs2frm_dec_empty = rs2crc_empty;
assign rs2frm_dec_data = rs2crc_data;
assign rs2frm_dec_error = flop_error;
assign rs2frm_dec_frm_type[1] = rs2frm_dec_valid & mx2rs_frm_type[1];
assign rs2frm_dec_frm_type[0] = rs2frm_dec_valid & mx2rs_frm_type[0];
    
end
else
begin

assign rs2crc_sop = (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?rs2crc_sop_xgmii:mx2rs_ethfrm_sop;
assign rs2crc_eop = mx2rs_ethfrm_eop;
assign rs2crc_empty = mx2rs_ethfrm_empty;
assign rs2crc_data = mx2rs_ethfrm_data;
assign rs2crc_clken = (speed_sel == 3'b0 || ENABLE_1G10G_MAC == 5)?((rs2mx_ethfrm_ready_xgmii & mx2rs_ethfrm_valid_xgmii) | mx2rs_ethfrm_eop_hold):((rs2mx_ethfrm_ready_gmii_mii & mx2rs_ethfrm_valid) | mx2rs_ethfrm_eop_hold);

// additional fan out to frame decoder. 
assign rs2frm_dec_sop = rs2crc_sop;
assign rs2frm_dec_valid = (csr_preamble_passthru == 1'b1 && (speed_sel == 3'b000 || ENABLE_1G10G_MAC == 5) && (mx2rs_frm_type[1] != 1))?(rs2mx_ethfrm_ready_xgmii & mx2rs_ethfrm_valid & !mx2rs_ethfrm_sop & !mx2rs_ethfrm_sop_dly1):(mx2rs_ethfrm_valid & rs2mx_ethfrm_ready);
assign rs2frm_dec_eop = rs2crc_eop;
assign rs2frm_dec_empty = rs2crc_empty;
assign rs2frm_dec_data = rs2crc_data;
assign rs2frm_dec_error = mx2rs_ethfrm_error;
assign rs2frm_dec_frm_type[1] = rs2frm_dec_valid & mx2rs_frm_type[1];
assign rs2frm_dec_frm_type[0] = rs2frm_dec_valid & mx2rs_frm_type[0];

end
endgenerate



assign tx_packet_in_progress_rs = ((speed_sel == 3'b000) || (speed_sel == 3'b101) || ENABLE_1G10G_MAC == 5) ? tx_packet_in_progress_xgmii :
                                  (ENABLE_GMII16B == 1) ? tx_packet_in_progress_gmii16b : tx_packet_in_progress_gmii_mii;
                                  
// SYNC_RESET FLOPS
always @ (posedge clk)
    begin
    if(!rst_n)
        begin
        mx2rs_ethfrm_sop_dly1 <= 1'b0;
        // mx2rs_ethfrm_sop_dly2 <= 1'b0;
        
        mx2rs_ethfrm_eop_dly1 <= 1'b0;
        mx2rs_ethfrm_eop_dly2 <= 1'b0;
        mx2rs_ethfrm_eop_dly3 <= 1'b0;
        mx2rs_ethfrm_eop_dly4 <= 1'b0;
        mx2rs_ethfrm_eop_dly5 <= 1'b0;
        
        mx2rs_ethfrm_eop_hold <= 1'b0;
        end
    else
        begin
        if(rs2mx_ethfrm_ready)
            begin
            mx2rs_ethfrm_eop_dly1 <= mx2rs_ethfrm_eop;
            end
        else
            begin
            mx2rs_ethfrm_eop_dly1 <= 1'b0;
            end
        if(rs2mx_ethfrm_ready & mx2rs_ethfrm_valid)    
            begin
            mx2rs_ethfrm_eop_hold <= mx2rs_ethfrm_eop;
            end
        else if(mx2rs_ethfrm_eop_dly5)
            begin
            mx2rs_ethfrm_eop_hold <= 1'b0;
            end
        
        mx2rs_ethfrm_eop_dly2 <= mx2rs_ethfrm_eop_dly1;
        mx2rs_ethfrm_eop_dly3 <= mx2rs_ethfrm_eop_dly2;
        mx2rs_ethfrm_eop_dly4 <= mx2rs_ethfrm_eop_dly3;
        mx2rs_ethfrm_eop_dly5 <= mx2rs_ethfrm_eop_dly4;
        
        if(mx2rs_ethfrm_valid)
            begin
            mx2rs_ethfrm_sop_dly1 <= mx2rs_ethfrm_sop;
            end
        else
            begin
            mx2rs_ethfrm_sop_dly1 <= 1'b0;
            end
        // mx2rs_ethfrm_sop_dly2 <= mx2rs_ethfrm_sop_dly1;
        
        end
    end


alt_em10g32_tx_rs_xgmii_layer #(
    .DEVICE_FAMILY          (DEVICE_FAMILY),
    .PREAMBLE_PASSTHROUGH(PREAMBLE_PASSTHROUGH),
    .ENABLE_1G10G_MAC(ENABLE_1G10G_MAC),
    .ENABLE_10GBASER_REG_MODE(ENABLE_10GBASER_REG_MODE),
    .SYNC_RESET_N           (SYNC_RESET_N)
    )xgmii_rs_layer (
    .clk                        (clk),
    .rst_n                      (rst_n_asyn),
    
    .csr_preamble_passthru      (csr_preamble_passthru),
    .csr_crc_inst_en            (csr_crc_inst_en),
    .csr_tx_unidirectional_en   (csr_tx_unidirectional_en),
    .csr_tx_unidirectional_remote_fault_dis             (csr_tx_unidirectional_remote_fault_dis),
    .csr_tx_unidirectional_force_remote_fault           (csr_tx_unidirectional_force_remote_fault),
    
    .enable_unidirectional      (enable_unidirectional),
    
    .rx_link_fault_status       (rx_link_fault_status),
    
    .mx2rs_ethfrm_sop           (mx2rs_ethfrm_sop_xgmii),
    .mx2rs_ethfrm_valid         (mx2rs_ethfrm_valid_xgmii),
    .rs2mx_ethfrm_ready         (rs2mx_ethfrm_ready_xgmii),
    .mx2rs_ethfrm_eop           (mx2rs_ethfrm_eop_xgmii),
    .mx2rs_ethfrm_data          (mx2rs_ethfrm_data),
    .mx2rs_ethfrm_empty         (mx2rs_ethfrm_empty),
    .mx2rs_ethfrm_error         (mx2rs_ethfrm_error),
    .mx2rs_ethfrm_pre_error     (mx2rs_ethfrm_pre_error),
    
    .rs2crc_sop                 (rs2crc_sop_xgmii),
    .rs2crc_eop                 (rs2crc_eop_xgmii),
    .rs2crc_empty               (),
    .rs2crc_data                (),    
    
    .ipg_value_10g              (ipg_value_10g),
    
    .mx2rs_frm_type             (mx2rs_frm_type),
    
    .crc2rs_result_valid        (crc2rs_result_valid),
    .crc2rs_result              (crc2rs_result),
    
    .rs2top_eth_xgmii_data      (rs2top_eth_xgmii_data),
    .rs2top_eth_xgmii_ctrl      (rs2top_eth_xgmii_ctrl), 
    .rs2top_eth_xgmii_valid     (rs2top_eth_xgmii_valid),
    
    .tx_packet_in_progress_xgmii(tx_packet_in_progress_xgmii),
    
    .speed_sel                  (speed_sel),
    
    .enable_timestamping        (enable_timestamping),
    .enable_ptp_1step           (enable_ptp_1step),

    .xgmii2ptp_xgmii_control    (xgmii2ptp_xgmii_control),
    .xgmii2ptp_xgmii_data       (xgmii2ptp_xgmii_data),
    .xgmii2ptp_xgmii_channel    (xgmii2ptp_xgmii_channel),
    
    .ptp2xgmii_xgmii_control    (ptp2xgmii_xgmii_control),
    .ptp2xgmii_xgmii_data       (ptp2xgmii_xgmii_data)
    
);

    
    // Insert a pipeline base here to improve timing
alt_em10g32_pipeline_base#(
   .SYMBOLS_PER_BEAT(1),
   .BITS_PER_SYMBOL(40),
   .PIPELINE_READY(1)
) input_st_pl_inst (
   .clk        (clk),
   .reset_n    (rst_n),
   .in_ready   (rs2mx_ethfrm_ready_gmii_mii),
   .in_valid   (mx2rs_ethfrm_valid_gmii_mii),
   .in_data    ( {mx2rs_ethfrm_sop_gmii_mii,
                  mx2rs_ethfrm_eop_gmii_mii,
                  mx2rs_ethfrm_empty,
                  mx2rs_ethfrm_error,
                  mx2rs_ethfrm_data,
                  mx2rs_frm_type}),
   .out_ready  (rs2mx_ethfrm_ready_gmii_mii_int),
   .out_valid  (mx2rs_ethfrm_valid_gmii_mii_int),
   .out_data   ( {mx2rs_ethfrm_sop_gmii_mii_int,
                  mx2rs_ethfrm_eop_gmii_mii_int,
                  mx2rs_ethfrm_empty_gmii_mii_int,
                  mx2rs_ethfrm_error_gmii_mii_int,
                  mx2rs_ethfrm_data_gmii_mii_int,
                  mx2rs_frm_type_int})
);
    
alt_em10g32_tx_rs_gmii_mii_layer #(
    .ENABLE_MEM_ECC         (ENABLE_MEM_ECC),
    .FORWARD_SYNC_DEPTH     (FORWARD_SYNC_DEPTH),
    .BACKWARD_SYNC_DEPTH    (BACKWARD_SYNC_DEPTH),
    .ENABLE_GMII16B         (ENABLE_GMII16B),
    .SYNC_RESET_N           (SYNC_RESET_N)
) gmii_mii_rs_layer (
    
    .clock_gmii             (clock_gmii),
    .clock_mac              (clk),
    
    .reset_gmii_n           (reset_gmii_n),
    .reset_gmii_n_asyn      (reset_gmii_n_asyn),
    .reset_mac_n            (rst_n),
    .reset_mac_n_asyn       (rst_n_asyn),
    
    .gmii_source_data       (gmii_source_data),
    .gmii_source_control    (gmii_source_control),
    .gmii_source_error      (gmii_source_error),
    
    .mii_source_data        (mii_source_data),
    .mii_source_control     (mii_source_control),
    .mii_source_error       (mii_source_error),

    .gmii16b_tx_en          (gmii16b_tx_en),
    .gmii16b_tx_d           (gmii16b_tx_d),
    .gmii16b_tx_err         (gmii16b_tx_err),
    
    .speed_sel              (speed_sel),
    .ipg_value_1g           (ipg_value_1g),
    
    .mx2rs_frm_type         (mx2rs_frm_type_int),
    
    .tx_clkena              (tx_clkena),
    .tx_clkena_half_rate    (tx_clkena_half_rate),
    
    .mx2rs_ethfrm_sop       (mx2rs_ethfrm_sop_gmii_mii_int),
    .mx2rs_ethfrm_valid     (mx2rs_ethfrm_valid_gmii_mii_int),
    .rs2mx_ethfrm_ready     (rs2mx_ethfrm_ready_gmii_mii_int),
    .mx2rs_ethfrm_eop       (mx2rs_ethfrm_eop_gmii_mii_int),
    .mx2rs_ethfrm_data      (mx2rs_ethfrm_data_gmii_mii_int),
    .mx2rs_ethfrm_empty     (mx2rs_ethfrm_empty_gmii_mii_int),
    .mx2rs_ethfrm_error     (|mx2rs_ethfrm_error_gmii_mii_int),
    
    .csr_crc_inst_en        (csr_crc_inst_en),
    
    .crc2rs_result_valid    (crc2rs_result_valid),
    .crc2rs_result          (crc2rs_result),
    
    .enable_timestamping    (enable_timestamping),
    .enable_ptp_1step       (enable_ptp_1step),
    
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
    
    // status to report packet in progress
    .tx_packet_in_progress_gmii_mii  (tx_packet_in_progress_gmii_mii),
    .tx_packet_in_progress_gmii16b   (tx_packet_in_progress_gmii16b),
    
    .tx_gmii_encoder_ecc_err_corrected (tx_gmii_encoder_ecc_err_corrected),
    .tx_gmii_encoder_ecc_err_fatal     (tx_gmii_encoder_ecc_err_fatal)
    
);   

endmodule
