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


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Description : 
//
// Transmit MII I/O Control
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_mii_tx_if_pcs (

   reset,
   tx_clk,
   tx_clkena,
   clk_ena,
   enan,
   mii_txd,
   mii_txdv,
   mii_txerr,
   mii_txd_i,
   mii_txdv_i,
   mii_txerr_i);

parameter SYNCHRONIZER_DEPTH 	   = 3;   //  Number of synchronizer

input   reset;                  //  Reset
input   tx_clk;                 //  MII Clock
input   tx_clkena;              //  Clock Enable
input   clk_ena;                //  MII Clock Enable
input   enan;                   //  Enable
output  [3:0] mii_txd;          //  MII receive data
output  mii_txdv;               //  MII receive frame enable  
output  mii_txerr;              //  MII receive frame error
input   [7:0] mii_txd_i;        //  MII receive data
input   mii_txdv_i;             //  MII receive frame enable  
input   mii_txerr_i;            //  MII receive frame error

reg     [3:0] mii_txd; 
reg     mii_txdv; 
reg     mii_txerr;

//  Aligned MII Interface
//  ---------------------

wire    enan_reg2;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_1(
    .clk(tx_clk),
    .reset_n(~reset),
    .din(enan),
    .dout(enan_reg2));

always @(posedge reset or posedge tx_clk)
   begin : process_2
   if (reset == 1'b 1)
      begin
      mii_txd   <= {4{1'b 0}};	
      mii_txdv  <= 1'b 0;	
      mii_txerr <= 1'b 0;	
      end
   else
      begin
		  if (tx_clkena == 1'b1) begin
		      if (enan_reg2 == 1'b 1) begin
                 
                 if (clk_ena == 1'b 1) begin
                     mii_txd <= mii_txd_i[7:4];
                 end
                 else begin
                     mii_txd <= mii_txd_i[3:0];
                 end
                 
		         mii_txdv  <= mii_txdv_i;
		         mii_txerr <= mii_txerr_i;
                 
		      end
		      else begin
		         mii_txd   <= {4{1'b 0}};	
		         mii_txdv  <= 1'b 0;	
		         mii_txerr <= 1'b 0;	
		      end
		  end
      end
   end

endmodule // module mii_tx_if_pcs

