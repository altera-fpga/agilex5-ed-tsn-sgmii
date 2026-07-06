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

module alt_em10g32_rx_pfc_flow_control (

    clk,
    reset_n,
    
    
    rx2flc_pfc_field_valid,
    
    rx2flc_pfc_pq0_en,
    rx2flc_pfc_pq0,
    
    rx2flc_pfc_pq1_en,
    rx2flc_pfc_pq1,
    
    rx2flc_pfc_pq2_en,
    rx2flc_pfc_pq2,
    
    rx2flc_pfc_pq3_en,
    rx2flc_pfc_pq3,
    
    rx2flc_pfc_pq4_en,
    rx2flc_pfc_pq4,
    
    rx2flc_pfc_pq5_en,
    rx2flc_pfc_pq5,
    
    rx2flc_pfc_pq6_en,
    rx2flc_pfc_pq6,
    
    rx2flc_pfc_pq7_en,
    rx2flc_pfc_pq7,
    
    flc2top_pfc_data

);
    parameter   PFC_PRIORITY_NUM    = 8;
    parameter   PAUSE_QUANTA_WIDTH  = 16;
    parameter   PREAMBLE_PASS_THROUGH = 0;
    parameter   SYNC_RESET_N = 1;
    
    input clk;
    input reset_n;
    
    
    input rx2flc_pfc_field_valid;
    
    input rx2flc_pfc_pq0_en;
    input [15:0]rx2flc_pfc_pq0;
    
    input rx2flc_pfc_pq1_en;
    input [15:0]rx2flc_pfc_pq1;
    
    input rx2flc_pfc_pq2_en;
    input [15:0]rx2flc_pfc_pq2;
    
    input rx2flc_pfc_pq3_en;
    input [15:0]rx2flc_pfc_pq3;
    
    input rx2flc_pfc_pq4_en;
    input [15:0]rx2flc_pfc_pq4;
    
    input rx2flc_pfc_pq5_en;
    input [15:0]rx2flc_pfc_pq5;
    
    input rx2flc_pfc_pq6_en;
    input [15:0]rx2flc_pfc_pq6;
    
    input rx2flc_pfc_pq7_en;
    input [15:0]rx2flc_pfc_pq7;
    
    output wire[PFC_PRIORITY_NUM - 1:0]flc2top_pfc_data;
    
    wire    [((PAUSE_QUANTA_WIDTH+1) * PFC_PRIORITY_NUM) - 1:0]pfc_pause_quanta_sink_data;
    
    assign pfc_pause_quanta_sink_data = {rx2flc_pfc_pq7_en,rx2flc_pfc_pq7,
                                         rx2flc_pfc_pq6_en,rx2flc_pfc_pq6,
                                         rx2flc_pfc_pq5_en,rx2flc_pfc_pq5,
                                         rx2flc_pfc_pq4_en,rx2flc_pfc_pq4,
                                         rx2flc_pfc_pq3_en,rx2flc_pfc_pq3,
                                         rx2flc_pfc_pq2_en,rx2flc_pfc_pq2,
                                         rx2flc_pfc_pq1_en,rx2flc_pfc_pq1,
                                         rx2flc_pfc_pq0_en,rx2flc_pfc_pq0};

    alt_em10g32_rx_pfc_pause_conversion #(
    .PFC_PRIORITY_NUM(PFC_PRIORITY_NUM),
    .SYNC_RESET_N(SYNC_RESET_N)
    
    
    ) pausebeat_convertion (
    .clk                            (clk),
    .reset_n                        (reset_n),
    .pfc_pause_quanta_sink_valid    (rx2flc_pfc_field_valid),
    .pfc_pause_quanta_sink_data     (pfc_pause_quanta_sink_data),
    .pfc_pause_ena_src_data         (flc2top_pfc_data)

    );
    
endmodule
