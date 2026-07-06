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


//------------------------------------------------------------------------------
// Include File: eth_f_ptp_state_ctrl_assrt
//
// (White Box) Assertions declaration eth_f_ptp module.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put assertion properties for this module here.        */
/*/////////////////////////////////////////////////////////////*/
// TX seq
sequence tx_wdly_done;
    $rose(tx_apulse_wdly_valid);
endsequence
sequence tx_wait_at_least_350ns_time;
    (##[1:150]((tx_state==S_MEAS_WDLY) && !o_tx_meas_dt));
endsequence
sequence tx_sync_state;
    (##[1:$](o_tx_meas_dt));
endsequence

// RX seq
sequence rx_wdly_done;
    $rose(rx_apulse_wdly_valid);
endsequence
sequence rx_wait_at_least_350ns_time;
    (##[1:150]((rx_state==S_MEAS_WDLY) && !o_rx_meas_dt));
endsequence
sequence rx_sync_state;
    (##[1:$](o_rx_meas_dt));
endsequence

property SPTP_TX_ENTER_SYNC_STATE;
    tx_wdly_done |-> tx_wait_at_least_350ns_time |-> tx_sync_state;
endproperty
SPTP_TX_ENTER_SYNC_STATE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_TX_ENTER_SYNC_STATE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_TX_ENTER_SYNC_STATE enter_sync event at is not expected");

property SPTP_RX_ENTER_SYNC_STATE;
    rx_wdly_done |-> rx_wait_at_least_350ns_time |-> rx_sync_state;
endproperty
SPTP_RX_ENTER_SYNC_STATE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_RX_ENTER_SYNC_STATE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_RX_ENTER_SYNC_STATE enter_sync event at is not expected");


property ETH_F_PTP_TX_ENTER_RESET_STATE;
    !i_tx_srst_n |=> (tx_state==S_IDLE && !o_tx_ptp_ready && !o_tx_ptp_offset_data_valid);
endproperty
ETH_F_PTP_TX_ENTER_RESET_STATE_CHECK_i: assert property (@(posedge i_ptp_clk)ETH_F_PTP_TX_ENTER_RESET_STATE) else `uvm_error($sformatf("%m"),"ERROR: ETH_F_PTP_TX_ENTER_RESET_STATE reset asserts at %dns, state must return to S_IDLE in next cycle.");

property ETH_F_PTP_RX_ENTER_RESET_STATE;
    !i_rx_srst_n |=> (rx_state==S_IDLE && !o_rx_ptp_ready && !o_rx_ptp_offset_data_valid);
endproperty
ETH_F_PTP_RX_ENTER_RESET_STATE_CHECK_i: assert property (@(posedge i_ptp_clk)ETH_F_PTP_RX_ENTER_RESET_STATE) else `uvm_error($sformatf("%m"),"ERROR: ETH_F_PTP_RX_ENTER_RESET_STATE reset asserts at %dns, state must return to S_IDLE in next cycle.");

