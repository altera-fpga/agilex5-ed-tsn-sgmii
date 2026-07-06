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


module eth_f_ptp_convert_commands_sva
#(
    parameter TX_PTP_DLY    = 1,
    parameter PKT_CYL       = 1,
    parameter WORDS         = 1
) (
    // System Intetrface
    input  logic                     i_clk,
    input  logic [WORDS  :0]         i_rst_n,
    input  logic                     i_cfg_tx_pp,
    
    // 1-Step TS Interface
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ins_ets,
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ins_cf,
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ins_cs,
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ins_eb,
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ets_format,
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ins_asm,
    input  logic [PKT_CYL-1:0]       i_tx_ptp_ins_p2p,
    input  logic [PKT_CYL-1:0][15:0] i_tx_ptp_offset_ts,
    input  logic [PKT_CYL-1:0][15:0] i_tx_ptp_offset_cf,
    input  logic [PKT_CYL-1:0][15:0] i_tx_ptp_offset_cs,
    input  logic [PKT_CYL-1:0][95:0] i_tx_ptp_rt_its,
    
    // 2-Step TS Interface
    input  logic [PKT_CYL-1:0]       i_tx_ptp_req_ets,
    input  logic [PKT_CYL-1:0][7:0]  i_tx_ptp_req_fp,
    
    // Asymmetry and P2P sign and index
    input  logic [PKT_CYL-1:0][7:0]  i_tx_ptp_asm_p2p_sign_idx,
    
    // TX Framing interface
    input  logic               [WORDS  :0]      i_tx_valid,
    input  logic               [WORDS-1:0]      i_tx_skip_crc,
    input  logic [TX_PTP_DLY:0][WORDS-1:0]      i_tx_inframe_pline,
    input  logic [TX_PTP_DLY:0][WORDS-1:0]      i_tx_sop_pline,     // share to convert_command
    input  logic [TX_PTP_DLY:0][WORDS-1:0]      i_tx_eop_pline,     // share to convert_command
    input  logic [TX_PTP_DLY:0][WORDS-1:0][2:0] i_tx_empty_pline,   // share to convert_command
    
    // EHIP TS Interface
    input  logic [WORDS-1:0][2:0]  o_tx_ptp_ins_type,
    input  logic [WORDS-1:0][2:0]  o_tx_ptp_byte_offset,
    input  logic [WORDS-1:0][4:0]  o_tx_ptp_ts,
    input  logic [WORDS-1:0]       o_tx_ptp_fp,
    // internal
    input logic [WORDS-1:0]         cmd_tx_sop,
    input logic [WORDS-1:0][2:0]    cmd_ins_type,
    input logic [WORDS-1:0][2:0]    cmd_byte_offset,
    input logic [WORDS-1:0][7:0]    asm_p2p_sign_idx,
    input logic [WORDS-1:0]         good_size_packet
);
logic upword_ptp_cmd;
logic loword_ptp_cmd;

generate if (WORDS==16) begin:ptp_cmd_e400g
assign upword_ptp_cmd = (|i_tx_sop_pline[0][15:8] && (i_tx_ptp_req_ets[1] || i_tx_ptp_ins_ets[1] || i_tx_ptp_ins_cf[1]));
assign loword_ptp_cmd =(|i_tx_sop_pline[0][7:0] && (i_tx_ptp_req_ets[0] || i_tx_ptp_ins_ets[0] || i_tx_ptp_ins_cf[0]));
end
endgenerate
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_convert_commands_cvprp.sv"
   `include "eth_f_ptp_convert_commands_assrt.sv"

endmodule : eth_f_ptp_convert_commands_sva
