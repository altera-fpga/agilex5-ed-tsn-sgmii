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


module eth_f_ptp_rx_pkt_dly_sva
#(
    parameter WORDS         = 1,
    parameter RX_PTP_DLY    = 7
) (
    input wire                      i_clk,
    input wire  [WORDS-1:0]         i_rst_n,
    // RX data in
    input  wire                     i_rx_valid,
    input  wire [WORDS-1:0][63:0]   i_rx_data,
    input  wire [WORDS-1:0] 	    i_rx_inframe,
    input  wire [WORDS-1:0][2:0]    i_rx_empty,
    input  wire [WORDS-1:0][1:0]    i_rx_error,
    input  wire [WORDS-1:0]         i_rx_fcs_error,
    input  wire [WORDS-1:0][2:0]    i_rx_status,
    // RX data out
    input  wire                     o_rx_valid,
    input  wire [WORDS-1:0]         o_rx_inframe,
    input  wire [WORDS-1:0][63:0]   o_rx_data,
    input  wire [WORDS-1:0][2:0]    o_rx_empty,
    input  wire [WORDS-1:0][1:0]    o_rx_error,
    input  wire [WORDS-1:0]         o_rx_fcs_error,
    input  wire [WORDS-1:0][2:0]    o_rx_status,
    //internal
    input  wire [RX_PTP_DLY-1:0][WORDS-1:0] r_rx_inframe
);

    logic [WORDS:0]     rx_inframe_w;
    logic [WORDS-1:0]   inc_rx_sop;
    logic [WORDS-1:0]   inc_rx_eop;
    logic loword_sop;
    logic loword_eop;
    logic hiword_sop;
    logic hiword_eop;
    
    assign rx_inframe_w         = {r_rx_inframe[0][0], i_rx_inframe};
    assign inc_rx_sop              = ~rx_inframe_w[WORDS:1] &  rx_inframe_w[WORDS-1:0];
    assign inc_rx_eop              =  rx_inframe_w[WORDS:1] & ~rx_inframe_w[WORDS-1:0];
generate if (WORDS==16) begin:sopeop_e400g
    assign loword_sop = (i_rx_valid && (|inc_rx_sop[7:0]));
    assign loword_eop = (i_rx_valid && (|inc_rx_eop[7:0]));
    assign hiword_sop = (i_rx_valid && (|inc_rx_sop[15:8]));
    assign hiword_eop = (i_rx_valid && (|inc_rx_eop[15:8]));
end
endgenerate
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   // `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_rx_pkt_dly_cvprp.sv"
   // `include "eth_f_ptp_rx_pkt_dly_assrt.sv"

endmodule : eth_f_ptp_rx_pkt_dly_sva
