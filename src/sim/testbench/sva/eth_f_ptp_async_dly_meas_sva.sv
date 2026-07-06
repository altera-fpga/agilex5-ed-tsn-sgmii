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


module eth_f_ptp_async_dly_meas_sva
#(
  parameter ENABLE_DT           = 1
) (
    input  logic                i_clk,
    input  logic                i_tod_clk,
    input  logic                i_samp_clk,
    input  logic                i_rst_n,
    input  logic                i_tod_rst_n,
    input  logic                i_samp_rst_n,
    //
    input  logic [2:0]          i_cfg_osclk_var,
    input  logic                i_calibrate_wdly,
    input  logic                i_calibrate_dt,
    // wdly
    input  logic                i_sclk_ptp,
    // input  logic                i_sclk_return,
    // dt
    input  logic                i_sclk_return,
    input  logic                i_sclk_return_tod,
    // output
    input  logic                o_wdly_valid,
    input  logic [19:0]         o_wdly,
    input  logic                o_dt_valid,
    input  logic [31:0]         o_dt,
    // internal
    input  logic                samp_sync_rst,
    input  logic                calibrate_wdly_samp,
    input  logic                calibrate_dt_samp,
    input  logic                restart_count,
    input  logic                dly_total_count_valid,
    input  logic                count_start,
    input  logic                count_stop
);

   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   // `include "eth_f_ptp_async_dly_meas_cvprp.sv"
   `include "eth_f_ptp_async_dly_meas_assrt.sv"

endmodule : eth_f_ptp_async_dly_meas_sva
