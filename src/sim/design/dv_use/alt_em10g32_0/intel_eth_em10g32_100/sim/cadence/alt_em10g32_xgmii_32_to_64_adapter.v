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
//   output_name:        alt_em10g32_xgmii_32_to_64_adapter
//   usePackets:         false
//   hasInEmpty:         false
//   inEmptyWidth:       0
//   hasOutEmpty:        false 
//   outEmptyWidth:      0
//   inDataWidth:        36
//   outDataWidth:       72
//   channelWidth:       0
//   inErrorWidth:       0
//   outErrorWidth:      0
//   inSymbolsPerBeat:   4
//   outSymbolsPerBeat:  8
//   maxState:           7
//   stateWidth:         3
//   maxChannel:         0
//   symbolWidth:        9
//   numMemSymbols:      7
//   symbolWidth:        9


// ------------------------------------------

 
module alt_em10g32_xgmii_32_to_64_adapter (
 // Interface: in
 output             in_ready,
 input              in_valid,
 input [36-1 : 0]   in_data,
 // Interface: out
 input              out_ready,
 output             out_valid,
 output  [72-1: 0]  out_data,

  // Interface: clk
 input              clk,
 // Interface: reset
 input              reset_n

);


   parameter SYNC_RESET_N                = 1;

   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------
   wire    state_from_memory;
   reg     state;
   reg     new_state;
   reg     state_d1;
    
   reg             in_ready_d1;
   wire            a_ready;
   wire            a_valid;
   wire [9-1:0]    a_data0; 
   wire [9-1:0]    a_data1; 
   wire [9-1:0]    a_data2; 
   wire [9-1:0]    a_data3; 
   wire            mem_write;

   reg            state_register;
   reg  [9-1:0]   data0_register;
   reg  [9-1:0]   data1_register;
   reg  [9-1:0]   data2_register;
   reg  [9-1:0]   data3_register;

   // ---------------------------------------------------------------------
   //| Input Register Stage
   // ---------------------------------------------------------------------
   assign {a_valid,a_data3,a_data2,a_data1,a_data0} = (in_ready) ? {in_valid,in_data} : 37'd0;
   

   // ---------------------------------------------------------------------
   //| State & Memory Keepers
   // ---------------------------------------------------------------------
  generate if (SYNC_RESET_N == 1) begin
   always @(posedge clk) begin
      if (!reset_n) begin
         in_ready_d1          <= 0;
         state_d1             <= 0;
      end else begin
         in_ready_d1          <= in_ready;
         state_d1             <= state;
      end
   end
   
   always @(posedge clk) begin
      if (!reset_n) begin
         state_register <= 0;
         data0_register <= 0;
         data1_register <= 0;
         data2_register <= 0;
         data3_register <= 0;
      end else begin
         state_register <= new_state;
         if (mem_write) begin
            data0_register <= a_data0;
            data1_register <= a_data1;
            data2_register <= a_data2;
            data3_register <= a_data3;
            end
         end
      end
  end else begin
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         in_ready_d1          <= 0;
         state_d1             <= 0;
      end else begin
         in_ready_d1          <= in_ready;
         state_d1             <= state;
      end
   end
   
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
         state_register <= 0;
         data0_register <= 0;
         data1_register <= 0;
         data2_register <= 0;
         data3_register <= 0;
      end else begin
         state_register <= new_state;
         if (mem_write) begin
            data0_register <= a_data0;
            data1_register <= a_data1;
            data2_register <= a_data2;
            data3_register <= a_data3;
            end
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
   if (~in_ready_d1)
      state = state_d1;
         
      
   new_state           = state;
       
   case (state) 
         0 : begin
            if (a_valid) begin
               new_state = state+1'b1;
            end
         end
         1 : begin
            if (out_ready) begin
               if (a_valid) 
               begin
                  new_state = 0;
               end
            end
         end

   endcase

   end

   // assign b_data = 
   assign mem_write = (state == 0) && a_valid;
   assign a_ready = (state == 0) || (state == 1 && out_ready);

   // ---------------------------------------------------------------------
   //| Output Register Stage
   // ---------------------------------------------------------------------
   assign in_ready  = a_ready;
   assign out_valid = (state == 1) && (out_ready && a_valid);
   assign out_data  = (state == 1) ? {a_data3,
                                      a_data2,
                                      a_data1,
                                      a_data0,
                                      data3_register,
                                      data2_register,
                                      data1_register,
                                      data0_register} 
                                   : 72'b0;
   



endmodule

   

