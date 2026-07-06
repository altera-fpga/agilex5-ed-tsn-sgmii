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


module gdra_gdr_xcvrif_sva
#(
   //PARAMETER DECLARTIONS
  ) (   
   
   //---------------------------------------------------------------------------
   // Port Declarations
   //---------------------------------------------------------------------------
   //input  wire         clk,     // <<example>>
   //input  wire         rst_n,   // <<example>>
     input wire tx_wr_clk,
     input wire tx_rd_clk,
     input wire tx_wr_en,
     input wire tx_rd_en,
     input wire tx_wr_full, 
     input wire tx_rd_empty 

   /*/////////////////////////////////////////////////////////////*/
   /* TODO: Define the signals of this module as input type here. */
   /*/////////////////////////////////////////////////////////////*/
   //input  wire [31:0]  data     // <<example>>
);
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   //`altuvm_sva_setup(top, posedge, tx_core_clkout, ($sampled(tx_core_rst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "gdra_gdr_xcvrif_assrt.sv"

endmodule : gdra_gdr_xcvrif_sva
