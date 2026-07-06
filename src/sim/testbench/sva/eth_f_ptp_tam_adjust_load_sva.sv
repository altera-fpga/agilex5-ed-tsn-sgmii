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


module eth_f_ptp_tam_adjust_load_sva
#(
    parameter WORDS             = 1
) (
    // System Intetrface
    input  logic                  i_clk,
    input  logic                  i_rst_n,
    // TX Framing interface
    input  logic                  i_tx_valid,
    // TAM Request
    input  logic                  i_req_tx_tam_load,
    input  logic           [95:0] i_tx_tam,
    input  logic           [31:0] i_tx_tam_adj,
    input  logic                  i_req_rx_tam_load,
    input  logic           [95:0] i_rx_tam,
    input  logic           [31:0] i_rx_tam_adj,
    // TAM completion status
    input  logic                  o_tx_tam_load_complete,
    input  logic                  o_rx_tam_load_complete,
    // EHIP TS Interface
    input  logic [WORDS-1:0][2:0] o_tx_ptp_ins_type,
    input  logic [WORDS-1:0][2:0] o_tx_ptp_byte_offset,
    input  logic [WORDS-1:0][4:0] o_tx_ptp_ts,
    input  logic [WORDS-1:0]      o_tx_ptp_fp,
    // internal
    // add comma above
    input  logic [127:0]   selected_tam_shift,
    input  logic req_rx_tam,
    input  logic req_tx_tam,
    input  logic loading_in_progress_p32
);
    logic [127:0] tx_tam_r_sva;
    logic [127:0] rx_tam_r_sva;
    
    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            tx_tam_r_sva  <= 0;
            rx_tam_r_sva  <= 0;
        end
        else begin
            if (i_req_tx_tam_load) tx_tam_r_sva  <= {i_tx_tam_adj, i_tx_tam};
            if (i_req_rx_tam_load) rx_tam_r_sva  <= {i_rx_tam_adj, i_rx_tam};
        end
    end
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_clk, ($sampled(i_rst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_tam_adjust_load_cvprp.sv"
   `include "eth_f_ptp_tam_adjust_load_assrt.sv"

endmodule : eth_f_ptp_tam_adjust_load_sva
