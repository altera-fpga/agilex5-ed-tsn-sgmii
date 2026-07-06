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


`timescale 1ns / 1ns
module alt_em10g32_rx_rs_gmii_mii (
    //clock and reset
    clk_gmii,
    clk_mac,
    reset_gmii,
    reset_gmii_asyn,
    reset_mac,
    
    
    // mux to select which output
    speed_sel,
    rx_clkena,
    rx_clkena_half_rate,
    
    // disable rx path
    csr_rx_tsfr_en_n,
    rx_tsfr_sts_gmii,
    rx_tsfr_sts_mii,
    
    // input : gmii interface after ST conversion
    gmii_sink_data,
    gmii_sink_control,
    gmii_sink_error,
    
    //input : mii interface after ST conversion
    mii_sink_data,
    mii_sink_control,
    mii_sink_error,

    // output : gmii/mii interface for PTP
    gmii_mii_sink_data_o,
    gmii_mii_sink_control_o,
    gmii_mii_sink_error_o,				   
				   
    // output : ST interface before GMII/MII conversion
    rxdata_src_sop,
    rxdata_src_eop,
    rxdata_src_valid,
    rxdata_src_data,
    rxdata_src_error,
    rxdata_src_empty,
    
    // MII Alignment Status
    mii_alignment_status,
    
    // status to report packet in progress
    rx_packet_in_progress_gmii_mii,
    
    // ECC Status
    rx_gmii_decoder_ecc_err_corrected,
    rx_gmii_decoder_ecc_err_fatal

);

parameter	W_GMII_WIDTH				=	8;
parameter	BITSPERSYMBOL				=	8;  // Streaming Data symbol width in bits
parameter	SYMBOLSPERBEAT				= 	4;  // Streaming Number of symbols per word
parameter   SYNCHRONIZER_DEPTH          =   3;
parameter   ENABLE_MEM_ECC              =   0;
parameter   FORWARD_SYNC_DEPTH          =   3;
parameter   BACKWARD_SYNC_DEPTH         =   3;
parameter   SYNC_RESET_N                =   1;


localparam   MAC_WIDTH				=	BITSPERSYMBOL*SYMBOLSPERBEAT;
localparam   EMPTY_WIDTH				=       $clog2(SYMBOLSPERBEAT);
localparam	 W_GMII_CONTROL_WIDTH			=	W_GMII_WIDTH/8;
localparam   MAC_TO_GMII_RATIO			=	MAC_WIDTH/W_GMII_WIDTH;


input                   clk_gmii;
input                   clk_mac;
input                   reset_gmii;
input                   reset_gmii_asyn;
input                   reset_mac;
                
input      [2:0]        speed_sel;
input                   rx_clkena;
input                   rx_clkena_half_rate;

input                   csr_rx_tsfr_en_n;
output                  rx_tsfr_sts_gmii;
output                  rx_tsfr_sts_mii;
    
input      [7:0]       gmii_sink_data;
input                  gmii_sink_control;
input                  gmii_sink_error;

input      [3:0]       mii_sink_data;
input                  mii_sink_control;
input                  mii_sink_error;

output     [7:0]       gmii_mii_sink_data_o;
output                 gmii_mii_sink_control_o;
output                 gmii_mii_sink_error_o;   

output                   rxdata_src_sop;
output                   rxdata_src_eop;
output                   rxdata_src_valid;
output       [MAC_WIDTH - 1:0]            rxdata_src_data;
output                   rxdata_src_error;
output       [EMPTY_WIDTH-1:0]           rxdata_src_empty;

output                      mii_alignment_status;

// ECC Status
output                      rx_gmii_decoder_ecc_err_corrected;
output                      rx_gmii_decoder_ecc_err_fatal;

output                      rx_packet_in_progress_gmii_mii;

wire         [7:0]          wire_gmii_sink_data;
wire                        wire_gmii_sink_control;
wire                        wire_gmii_sink_error;

wire      [7:0]             mii_sink_data_o;
wire                        mii_sink_control_o;
wire                        mii_sink_error_o;

wire                        gmii_avst_convt_sop;
wire                        gmii_avst_convt_eop;
wire                        gmii_avst_convt_valid;
wire      [7:0]             gmii_avst_convt_data;
wire                        gmii_avst_convt_ready;
wire                        gmii_avst_convt_empty;
wire                        gmii_avst_convt_error;

// those register is use to detect when control signal from high to low, then only csr_rx_tsfr_en_n will take effect to disable rx path
reg         disable_gmii_rx_n;
reg         disable_mii_rx_n;

wire        rx_tsfr_sts_gmii;
wire        rx_tsfr_sts_mii;
wire        reset_gmii_n;
wire        reset_gmii_n_asyn;
wire        csr_rx_tsfr_en_n_gmii_sync;

assign reset_gmii_n = ~reset_gmii;
assign reset_gmii_n_asyn = ~reset_gmii_asyn;

// use std synchronizer because disable_gmii_rx_n and disable_mii_rx_n is run at gmii clock
    alt_em10g32_std_synchronizer #(
        .depth(2)
    ) sync_rx_tsfr_en_gmii_mii (
        .clk (clk_gmii),
        .reset_n (reset_gmii_n_asyn),
        .din (csr_rx_tsfr_en_n),
        .dout (csr_rx_tsfr_en_n_gmii_sync)
    );

// when control deasserted, it mean that this packet finish transfer. hence can start to disable at this point
always @ (posedge clk_gmii)
    begin
    if(reset_gmii)
        begin
        disable_gmii_rx_n <= 1'b1;
        disable_mii_rx_n <= 1'b1;     
        end
    else
        begin
        if(gmii_sink_control == 1'b0)
            begin
            disable_gmii_rx_n <= ~csr_rx_tsfr_en_n_gmii_sync;
            end
        if(mii_sink_control == 1'b0)
            begin
            disable_mii_rx_n <= ~csr_rx_tsfr_en_n_gmii_sync;
            end
        end
    end

assign rx_tsfr_sts_gmii = ~disable_gmii_rx_n;
assign rx_tsfr_sts_mii = ~disable_mii_rx_n;


    
wire    wire_speed_mii_gmii_bar;

assign wire_speed_mii_gmii_bar = (speed_sel == 3'b011 || speed_sel == 3'b010)? 1'b1 : 1'b0;

assign wire_gmii_sink_data = wire_speed_mii_gmii_bar ? mii_sink_data_o : gmii_sink_data;
assign wire_gmii_sink_control = wire_speed_mii_gmii_bar ? mii_sink_control_o : gmii_sink_control;
assign wire_gmii_sink_error = wire_speed_mii_gmii_bar ? mii_sink_error_o : gmii_sink_error;

assign gmii_mii_sink_data_o = wire_speed_mii_gmii_bar ? mii_sink_data_o : gmii_sink_data;
assign gmii_mii_sink_control_o = wire_speed_mii_gmii_bar ? mii_sink_control_o : gmii_sink_control;
assign gmii_mii_sink_error_o = wire_speed_mii_gmii_bar ? mii_sink_error_o : gmii_sink_error;
   
alt_em10g32_rx_gmii_decoder #(
    .ENABLE_MEM_ECC(ENABLE_MEM_ECC),
    .FORWARD_SYNC_DEPTH(FORWARD_SYNC_DEPTH),
    .BACKWARD_SYNC_DEPTH(BACKWARD_SYNC_DEPTH),
    .SYNC_RESET_N(SYNC_RESET_N)
) gmii_decoder (
    .clk_gmii(clk_gmii),
    .clk_mac(clk_mac),
    .reset_gmii(reset_gmii_asyn),
    .reset_mac(reset_mac),
    .gmii_sink_data(wire_gmii_sink_data),
    .gmii_sink_control(wire_gmii_sink_control & disable_gmii_rx_n),
    .gmii_sink_error(wire_gmii_sink_error),
    .rxdata_src_sop(rxdata_src_sop),
    .rxdata_src_eop(rxdata_src_eop),
    .rxdata_src_valid(rxdata_src_valid),
    .rxdata_src_data(rxdata_src_data),
    .rxdata_src_error(rxdata_src_error),
    .rxdata_src_empty(rxdata_src_empty),
    .rx_clkena(rx_clkena_half_rate),
    .gmii_decoder_ecc_err_corrected(rx_gmii_decoder_ecc_err_corrected),
    .gmii_decoder_ecc_err_fatal(rx_gmii_decoder_ecc_err_fatal)

);

alt_em10g32_rx_gmii_mii_decoder_if #(.SYNC_RESET_N(SYNC_RESET_N)) mii_rx_if(
    .reset(reset_gmii_asyn),                  //INPUT :  Reset
    .rx_clk(clk_gmii),                 //INPUT :  MII Clock
    .clk_ena(rx_clkena),                //INPUT :  MII Clock Enable
    .clk_ena_half_rate(rx_clkena_half_rate), //INPUT :  MII Clock Enable (Half rate)
    .mii_rxd(mii_sink_data),                //INPUT :  MII receive data
    .mii_rxdv(mii_sink_control & disable_mii_rx_n),               //INPUT :  MII receive frame enable  
    .mii_rxerr(mii_sink_error),              //INPUT :  MII receive frame error
    .mii_rxd_o(mii_sink_data_o),              //OUTPUT:  MII receive data
    .mii_rxdv_o(mii_sink_control_o),             //OUTPUT:  MII receive frame enable  
    .mii_rxerr_o(mii_sink_error_o),            //OUTPUT:  MII receive frame error
    .mii_align_err(),           //OUTPUT:  MII receive alignment error
    .mii_alignment_status(mii_alignment_status)     //OUTPUT:  Status of the alignment for latency calculation
);

// since gmii and mii is running at same clock, hence i combine them to save resources for synchronizer
assign rx_packet_in_progress_gmii_mii = mii_sink_control | gmii_sink_control;


endmodule

