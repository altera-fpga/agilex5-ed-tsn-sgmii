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


module eth_f_ptp_tx_pkt_dly_sva
#(
    parameter PKT_CYL       = 1,
    parameter WORDS         = 1,
    parameter TX_PTP_DLY    = 5
) (
    // Clock and Reset
    input  logic  	                i_clk,
    input  logic [WORDS-1:0]        i_rst_n,
    // TX Data Path in
    input  logic [WORDS-1:0]        i_tx_valid,
    input  logic [WORDS-1:0]        i_tx_inframe,
    input  logic [WORDS-1:0][63:0]  i_tx_data,
    input  logic [WORDS-1:0][2:0]   i_tx_empty,
    input  logic [WORDS-1:0]        i_tx_error,
    input  logic [WORDS-1:0]        i_tx_skip_crc,
    // TX PTP in
    input  logic [WORDS-1:0][2:0]   i_tx_ptp_byte_offset,
    // TX Data Path out
    input  logic [TX_PTP_DLY:0][WORDS-1:0]        o_tx_inframe_pline, // share to convert_command
    input  logic [TX_PTP_DLY:0][WORDS-1:0]        o_tx_sop_pline,     // share to convert_command
    input  logic [TX_PTP_DLY:0][WORDS-1:0]        o_tx_eop_pline,     // share to convert_command
    input  logic [TX_PTP_DLY:0][WORDS-1:0][2:0]   o_tx_empty_pline,   // share to convert_command
    input  logic [WORDS-1:0]        o_tx_inframe,
    input  logic [WORDS-1:0][63:0]  o_tx_data,
    input  logic [WORDS-1:0][2:0]   o_tx_empty,
    input  logic [WORDS-1:0]        o_tx_error,
    input  logic [WORDS-1:0]        o_tx_skip_crc
    // internal
    // add comma above
);
logic loword_sop;
logic loword_eop;
logic hiword_sop;
logic hiword_eop;

generate if (PKT_CYL==2) begin: sopeop_e400g
assign loword_sop = (i_tx_valid && (|o_tx_sop_pline[0][7:0]));
assign loword_eop = (i_tx_valid && (|o_tx_eop_pline[0][7:0]));
assign hiword_sop = (i_tx_valid && (|o_tx_sop_pline[0][15:8]));
assign hiword_eop = (i_tx_valid && (|o_tx_eop_pline[0][15:8]));
end
endgenerate
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_tx_pkt_dly_cvprp.sv"
   // `include "eth_f_ptp_tx_pkt_dly_assrt.sv"

endmodule : eth_f_ptp_tx_pkt_dly_sva
