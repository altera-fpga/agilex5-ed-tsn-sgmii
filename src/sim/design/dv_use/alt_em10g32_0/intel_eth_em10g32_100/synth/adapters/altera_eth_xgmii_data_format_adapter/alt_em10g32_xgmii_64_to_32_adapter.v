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


// (C) 2001-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// (C) 2001-2013 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

 
// $Id: //acds/rel/13.1/ip/.../avalon-st_data_format_adapter.sv.terp#1 $
// $Revision: #1 $
// $Date: 2013/09/21 $
// $Author: dmunday $


// --------------------------------------------------------------------------------
//| Avalon Streaming Data Adapter
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps

// ------------------------------------------
// Generation parameters:
//   output_name:        alt_em10g32_xgmii_64_to_32_adapter
//   usePackets:         false
//   hasInEmpty:         false
//   inEmptyWidth:       0
//   hasOutEmpty:        false 
//   outEmptyWidth:      0
//   inDataWidth:        72
//   outDataWidth:       36
//   channelWidth:       0
//   inErrorWidth:       0
//   outErrorWidth:      0
//   inSymbolsPerBeat:   8
//   outSymbolsPerBeat:  4
//   maxState:           7
//   stateWidth:         3
//   maxChannel:         0
//   symbolWidth:        9
//   numMemSymbols:      7
//   symbolWidth:        9


// ------------------------------------------

 
module alt_em10g32_xgmii_64_to_32_adapter (
 // Interface: in
 input              in_valid,
 input [72-1 : 0]   in_data,
 // Interface: out
 output             out_valid,
 output  [36-1: 0]  out_data,

  // Interface: clk
 input              clk,
 // Interface: reset
 input              reset_n

);


   parameter SYNC_RESET_N = 1;

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------
   wire    state_from_memory;
   reg     state;
   reg     new_state;
    
   reg     state_register;
   reg  [72-1:0]  in_data_reg_1;
   reg  [36-1:0]  in_data_reg_2;
   reg            in_valid_reg_1;
   reg            in_valid_reg_2;
   
   // ---------------------------------------------------------------------
   //| Input Register Stage
   // ---------------------------------------------------------------------
   // NON_RESETABLE FLOPS
   always @(posedge clk) begin
      if (in_valid) begin
         in_data_reg_1 <= in_data;
      end
      in_valid_reg_1 <= in_valid;
      in_valid_reg_2 <= in_valid_reg_1;
      in_data_reg_2 <= in_data_reg_1[71:36];
   end

   // ---------------------------------------------------------------------
   //| State & Memory Keepers
   // ---------------------------------------------------------------------
   
   generate if (SYNC_RESET_N == 1) begin
     always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
           state_register <= 0;
        end else begin
           state_register <= new_state;
           end
        end
   end else begin
     always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
           state_register <= 0;
        end else begin
           state_register <= new_state;
           end
        end
   end
   endgenerate
   
      assign state_from_memory = state_register;
   
   // ---------------------------------------------------------------------
   //| State Machine
   // ---------------------------------------------------------------------
   always @* begin

      
   state = state_from_memory;
      
   new_state           = state;
       
   case (state) 
            0 : begin
                if (in_valid_reg_2 || (in_valid && in_valid_reg_1)) begin
                  new_state = state+1'b1;
                  end
                end
            1 : begin
                  new_state = 0;
                end

   endcase

   end


   // ---------------------------------------------------------------------
   //| Output Register Stage
   // ---------------------------------------------------------------------
   assign out_valid = state == 1 || (state == 0 && (in_valid_reg_2 || (in_valid && in_valid_reg_1)));
   assign out_data  = (state == 0) ? {in_data_reg_1[35:0]}
                                   : {in_data_reg_2};
   



endmodule

   

