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
// Collision Detection.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_colision_detect (

   reset,
   sw_reset,
   clk,
   transmit,
   receive,
   hd_ena,
   gmii_col);

parameter SYNCHRONIZER_DEPTH = 3;

input   reset;          //  Active High Global Reset
input   sw_reset;       //  SW Synchronous Reset           
input   clk;            //  125MHz Common Clock   
input   [1:0] transmit; //  Frame Transmission Active
input   [1:0] receive;  //  Frame Reception Active
input   hd_ena;         //  Half Duplex Enable     
output  gmii_col;       //  Carrier Sense

wire    gmii_col; 

localparam STM_TYPE_COL_OFF = 1'b0;
localparam STM_TYPE_COL_ON  = 1'b1;

(* syn_preserve = 1 *)reg     state /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"D101,D103\"" */ ; 
reg        nextstate; 
reg        receive_reg1;
wire       receive_reg2;
wire       hd_ena_reg2; 

always @(posedge reset or posedge clk)
   begin
   if (reset == 1'b 1)
      begin
      receive_reg1 <= 1'b0;   
      end
   else
      begin
      receive_reg1 <= |receive;
      end
   end

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_2(
			.clk(clk), // INPUT
			.reset_n(~reset), //INPUT
			.din(receive_reg1), //INPUT
			.dout(receive_reg2));// OUTPUT

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_3(
			.clk(clk), // INPUT
			.reset_n(~reset), //INPUT
			.din(hd_ena), //INPUT
			.dout(hd_ena_reg2));// OUTPUT

always @(posedge reset or posedge clk)
   begin : process_2
   if (reset == 1'b 1)
      begin
      state <= STM_TYPE_COL_OFF;   
      end
   else
      begin
      if (sw_reset == 1'b 1)
         begin
         state <= STM_TYPE_COL_OFF;   
         end
      else
         begin
         state <= nextstate;   
         end
      end
   end

always @(state or transmit or receive_reg2 or hd_ena_reg2)
   begin : process_3
   case (state)
   STM_TYPE_COL_OFF:
      begin
      if (transmit == 1'b 1 & receive_reg2 == 1'b 1 & 
      hd_ena_reg2 == 1'b 1)
         begin
         nextstate = STM_TYPE_COL_ON;   
         end
      else
         begin
         nextstate = STM_TYPE_COL_OFF;   
         end
      end
   STM_TYPE_COL_ON:
      begin
      if (transmit == 1'b 0 | receive_reg2 == 1'b 0)
         begin
         nextstate = STM_TYPE_COL_OFF;   
         end
      else
         begin
         nextstate = STM_TYPE_COL_ON;   
         end
      end
   default:
      begin
      nextstate = STM_TYPE_COL_OFF;
      end
 
   endcase
   end

assign gmii_col = state == STM_TYPE_COL_ON ? 1'b 1 : 1'b 0; 

endmodule // module colision_detect
