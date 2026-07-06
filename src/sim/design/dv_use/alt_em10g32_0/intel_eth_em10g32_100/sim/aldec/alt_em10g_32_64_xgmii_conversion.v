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


`timescale 1ps/1ps

module alt_em10g_32_64_xgmii_conversion #(
   parameter USE_ASYNC_ADAPTOR = 0,
   parameter SYNC_RESET_N      = 1
) (
   input  wire          tx_312_5_clk,      
   input  wire          tx_312_5_rst_n, 
   input  wire          rx_312_5_clk,  
   input  wire          rx_312_5_rst_n,
   input  wire          tx_156_25_clk,       
   input  wire          tx_156_25_rst_n,
   input  wire          rx_156_25_clk,       
   input  wire          rx_156_25_rst_n,
   input  wire [31:0]   xgmii_tx_data_in,
   input  wire [3:0]    xgmii_tx_control_in,
   output wire [71:0]   xgmii_tx,  
   input  wire [71:0]   xgmii_rx,  
   output wire [31:0]   xgmii_rx_data_out,
   output wire [3:0]    xgmii_rx_control_out,
   input  wire [15:0]   xgmii_rx_path_latency,
   input  wire [15:0]   xgmii_tx_path_latency,
   output wire [16:0]   st_tx_path_latency,
   output wire [16:0]   st_rx_path_latency,
   output wire          tx_phase,
   output wire          rx_phase,
   input  wire          sampling_clk,
   input  wire          tx_sampling_clk_rst_n,
   input  wire          rx_sampling_clk_rst_n
);

wire [63:0] xgmii_tx_data_out;
wire [7:0] xgmii_tx_control_out;

wire [63:0] xgmii_rx_data_in;
wire [7:0] xgmii_rx_control_in;

assign xgmii_tx = {
   xgmii_tx_control_out[7], xgmii_tx_data_out[63:56],
   xgmii_tx_control_out[6], xgmii_tx_data_out[55:48],
   xgmii_tx_control_out[5], xgmii_tx_data_out[47:40],
   xgmii_tx_control_out[4], xgmii_tx_data_out[39:32],
   xgmii_tx_control_out[3], xgmii_tx_data_out[31:24],
   xgmii_tx_control_out[2], xgmii_tx_data_out[23:16],
   xgmii_tx_control_out[1], xgmii_tx_data_out[15:8],
   xgmii_tx_control_out[0], xgmii_tx_data_out[7:0]};

assign xgmii_rx_data_in = {
   xgmii_rx[70:63],
   xgmii_rx[61:54],
   xgmii_rx[52:45],
   xgmii_rx[43:36],
   xgmii_rx[34:27],
   xgmii_rx[25:18],
   xgmii_rx[16:9],
   xgmii_rx[7:0]
};

assign xgmii_rx_control_in = {
   xgmii_rx[71],
   xgmii_rx[62],
   xgmii_rx[53],
   xgmii_rx[44],
   xgmii_rx[35],
   xgmii_rx[26],
   xgmii_rx[17],
   xgmii_rx[8]
};

generate if(USE_ASYNC_ADAPTOR == 0)
begin : XGMII_ADAPTOR

    alt_em10g_32_to_64_xgmii_conversion #(
     .SYNC_RESET_N(SYNC_RESET_N)
    )
    tx_xgmii_conversion
    (
       // Fast clock and reset (312.5 MHz)
       .clk_xgmii_in (tx_312_5_clk),
       .reset_xgmii_in_n (tx_312_5_rst_n),
       
       // Slow clock and reset (156.25 MHz)
       .clk_xgmii_out (tx_156_25_clk),
       .reset_xgmii_out_n (tx_156_25_rst_n),

       // XGMII data and control in fast clock domain
       .xgmii_data_in (xgmii_tx_data_in),
       .xgmii_control_in (xgmii_tx_control_in),

       // XGMII data and control in slow clock domain
       .xgmii_data_out (xgmii_tx_data_out),
       .xgmii_control_out (xgmii_tx_control_out),

       .xgmii_tx_path_latency (xgmii_tx_path_latency),
       .st_tx_path_latency (st_tx_path_latency),
       .phase (tx_phase)
    );

    alt_em10g_64_to_32_xgmii_conversion rx_xgmii_conversion
    (
       // Slow clock and reset (156.25 MHz)
       .clk_xgmii_in (rx_156_25_clk),
       .reset_xgmii_in_n (rx_156_25_rst_n),
       
       // Fast clock and reset (312.25 MHz)
       .clk_xgmii_out (rx_312_5_clk),
       .reset_xgmii_out_n (rx_312_5_rst_n),

       // XGMII data and control in slow clock domain
       .xgmii_data_in (xgmii_rx_data_in),
       .xgmii_control_in (xgmii_rx_control_in),

       // XGMII data and control in fast clock domain
       .xgmii_data_out (xgmii_rx_data_out),
       .xgmii_control_out (xgmii_rx_control_out),

       // 1588 related signals
       .xgmii_rx_path_latency (xgmii_rx_path_latency),
       .st_rx_path_latency (st_rx_path_latency),
       .phase (rx_phase)
    );

end
else begin

    alt_em10g_dcfifo_32_to_64_xgmii_conversion #(
     .SYNC_RESET_N(SYNC_RESET_N)
    ) tx_dcfifo_xgmii_conversion
    (
       // Fast clock and reset (312.5 MHz)
       .clk_xgmii_in (tx_312_5_clk),
       .reset_xgmii_in_n (tx_312_5_rst_n),
       
       // Slow clock and reset (156.25 MHz)
       .clk_xgmii_out (tx_156_25_clk),
       .reset_xgmii_out_n (tx_156_25_rst_n),

       // XGMII data and control in fast clock domain
       .xgmii_data_in (xgmii_tx_data_in),
       .xgmii_control_in (xgmii_tx_control_in),

       // XGMII data and control in slow clock domain
       .xgmii_data_out (xgmii_tx_data_out),
       .xgmii_control_out (xgmii_tx_control_out),

       .xgmii_tx_path_latency (xgmii_tx_path_latency),
       .st_tx_path_latency (st_tx_path_latency),
       .phase (tx_phase),
       
       // Latency Measurement
       .sampling_clk (sampling_clk),
       .sampling_clk_reset_n (tx_sampling_clk_rst_n)
    );

    alt_em10g_dcfifo_64_to_32_xgmii_conversion #(
     .SYNC_RESET_N(SYNC_RESET_N)
    ) rx_dcfifo_xgmii_conversion
    (
       // Slow clock and reset (156.25 MHz)
       .clk_xgmii_in (rx_156_25_clk),
       .reset_xgmii_in_n (rx_156_25_rst_n),
       
       // Fast clock and reset (312.25 MHz)
       .clk_xgmii_out (rx_312_5_clk),
       .reset_xgmii_out_n (rx_312_5_rst_n),

       // XGMII data and control in slow clock domain
       .xgmii_data_in (xgmii_rx_data_in),
       .xgmii_control_in (xgmii_rx_control_in),

       // XGMII data and control in fast clock domain
       .xgmii_data_out (xgmii_rx_data_out),
       .xgmii_control_out (xgmii_rx_control_out),

       // 1588 related signals
       .xgmii_rx_path_latency (xgmii_rx_path_latency),
       .st_rx_path_latency (st_rx_path_latency),
       .phase (rx_phase),
       
       // Latency Measurement
       .sampling_clk (sampling_clk),
       .sampling_clk_reset_n (rx_sampling_clk_rst_n)
    );

end
endgenerate

endmodule
