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


module eth_f_ptp_state_ctrl_sva
#(
    parameter ENABLE_DT         = 0,
    parameter PL                = 1,
    parameter WORDS             = 1,
    parameter S_IDLE            = 3'b000,
    parameter S_MEAS_WDLY       = 3'b001,
    parameter S_MEAS_DT         = 3'b010,
    parameter S_TOD_VALID_DOWN  = 3'b100,
    parameter S_MEAS_TIME       = 3'b011,
    parameter S_WAIT_USR_CALC   = 3'b101,
    parameter S_WAIT_TAMLOAD    = 3'b110,
    parameter S_PTP_READY       = 3'b111
) (
    input  logic                      i_ptp_clk,
    input  logic                      i_tx_srst_n,
    input  logic                      i_rx_srst_n,
    input  logic                      tx_ptp_tod_valid_sync,
    input  logic                      rx_ptp_tod_valid_sync,
    input  logic                      tx_apulse_wdly_valid,
    input  logic                      rx_apulse_wdly_valid,
    input  logic                      o_tx_meas_dt,
    input  logic                      o_rx_meas_dt,
    input  logic                      o_tx_ptp_offset_data_valid,
    input  logic                      o_rx_ptp_offset_data_valid,
    input  logic                      o_tx_ptp_ready,
    input  logic                      o_rx_ptp_ready,
    input  logic [2:0]                tx_state,
    input  logic [2:0]                rx_state
);

// tx_tod_valid_down state change
// enter_sync_state
// enter_reset_state
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_state_ctrl_cvprp.sv"
   `include "eth_f_ptp_state_ctrl_assrt.sv"

endmodule : eth_f_ptp_state_ctrl_sva
