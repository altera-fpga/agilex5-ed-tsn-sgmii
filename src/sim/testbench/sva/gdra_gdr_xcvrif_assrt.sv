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
// Include File: gdra_gdr_xcvrif_assrt
//
// (White Box) Assertions declaration gdra_gdr_xcvrif module.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put assertion properties for this module here.        */
/*/////////////////////////////////////////////////////////////*/

property ETH_F_HW_TX_WR_FIFO_FULL_CHECK;
    tx_wr_en |-> !tx_wr_full;
endproperty
ETH_F_HW_TX_WR_FIFO_FULL_CHECK_i: assert property (@(posedge tx_wr_clk)ETH_F_HW_TX_WR_FIFO_FULL_CHECK) else `uvm_error($sformatf("%m"),"ERROR: ETH_F_HW_TX_WR_FIFO_FULL_CHECK tx fifo full when write enable at is not expected");

property ETH_F_HW_TX_RD_FIFO_EMPTY_CHECK;
    tx_rd_en |-> !tx_rd_empty;
endproperty
ETH_F_HW_TX_RD_FIFO_EMPTY_CHECK_i: assert property (@(posedge tx_rd_clk)ETH_F_HW_TX_RD_FIFO_EMPTY_CHECK) else `uvm_error($sformatf("%m"),"ERROR: ETH_F_HW_TX_RD_FIFO_EMPTY_CHECK tx fifo empty when read enable at is not expected");
