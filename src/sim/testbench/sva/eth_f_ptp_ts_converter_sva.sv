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


module eth_f_ptp_ts_converter_sva
#(
    parameter DEBUG         = 0,
    parameter PKT_CYL       = 1,
    parameter WORDS         = 1,
    parameter RX_PLNUM      = 1
) (
    input  logic                        i_clk,
    input  logic                        i_tx_rst_n,
    input  logic                        i_rx_rst_n,
    input  logic [95:0]                 i_tod,
    input  logic                        i_rx_valid,
    input  logic [WORDS-1:0]            i_rx_inframe,
    input  logic [WORDS-1:0][2:0]       i_rx_empty,
    input  logic [WORDS-1:0]            i_rx_ptp_its,
    input  logic [PKT_CYL-1:0][3:0]     i_rx_ptp_its_vl,
    input  logic [PKT_CYL-1:0]          i_tx_ptp_ets_valid,
    input  logic [WORDS-1:0][2:0]       i_tx_ptp_ets,
    input  logic [WORDS-1:0]            i_tx_ptp_ets_fp,
    input  logic [PKT_CYL-1:0][3:0]     i_tx_ptp_ets_vl,
    input  logic [PKT_CYL-1:0]          o_rx_ptp_its_valid,
    input  logic [PKT_CYL-1:0][95:0]    o_rx_ptp_its,
    input  logic [PKT_CYL-1:0][4:0]     o_rx_ptp_its_vl,
    input  logic [PKT_CYL-1:0]          o_tx_ptp_ets_valid,
    input  logic [PKT_CYL-1:0]          o_tx_ptp_ets_valid_early,
    input  logic [PKT_CYL-1:0][95:0]    o_tx_ptp_ets,
    input  logic [PKT_CYL-1:0][7:0]     o_tx_ptp_ets_fp,
    input  logic [PKT_CYL-1:0][7:0]     o_tx_ptp_ets_fp_early,
    input  logic [PKT_CYL-1:0][4:0]     o_tx_ptp_ets_vl,
    // internal
    // add comma above
    input  logic [WORDS-1:0] w_rx_sop,
    input  logic [PKT_CYL-1:0] w_rx_ptp_its_valid,
    input  logic [PKT_CYL-1:0] w_tx_ptp_ets_valid,
    input  logic [PKT_CYL-1:0] tx_ets_rollover,
    input  logic [PKT_CYL-1:0] tx_ets_rollover_billion,
    input  logic [PKT_CYL-1:0] rx_tod_rollover,
    input  logic [PKT_CYL-1:0] rx_tod_rollover_billion
);

   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_ts_converter_cvprp.sv"
   // `include "eth_f_ptp_ts_converter_assrt.sv"

endmodule : eth_f_ptp_ts_converter_sva
