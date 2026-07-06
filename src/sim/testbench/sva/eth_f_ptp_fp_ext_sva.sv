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


module eth_f_ptp_fp_ext_sva
#(
    parameter WORDS     = 1,
    parameter PKT_CYL   = 1,
    parameter PTP_FP_WIDTH    = 8
) (
    input logic                     i_clk,
    input logic                     i_reset,
    input logic                     i_tx_valid,
    input logic   [WORDS-1:0]       i_tx_inframe, //little endian
    input logic   [PKT_CYL-1:0]     i_fp_valid, //little endian
    //to/from ST
    input logic   [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]  i_ptp_fp_ext,//little endian
    input logic   [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]  o_ptp_fp_ext, //little endian
    //to/from PTP SIP
    input logic   [PKT_CYL-1:0][7:0] o_ptp_fp, //little endian
    input logic   [PKT_CYL-1:0][7:0] i_ptp_fp, //little endian
    //internal
    // add comma above
    input  logic  [WORDS-1:0]       seg_tx_sop,
    input  logic                    fifo_wr_switch
);
logic upword_ptp_fpv;
logic loword_ptp_fpv;

generate if (WORDS==16) begin: sopfp_e400g
assign upword_ptp_fpv = (i_tx_valid && (|seg_tx_sop[15:8]) && (i_fp_valid[1]==1));
assign loword_ptp_fpv = (i_tx_valid && (|seg_tx_sop[7:0]) && (i_fp_valid[0]==1));
end
endgenerate
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_fp_ext_cvprp.sv"
   // `include "eth_f_ptp_state_ctrl_assrt.sv"

endmodule : eth_f_ptp_fp_ext_sva
