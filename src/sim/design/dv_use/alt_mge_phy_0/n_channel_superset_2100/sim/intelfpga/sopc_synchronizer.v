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


// $Id: //acds/main/ip/sopc/components/sopc_primitives/sopc_synchronizer/sopc_synchronizer.v#1 $
// $Revision: #1.1 $
// $Date: 2008/09/12 $
//-----------------------------------------------------------------------------
//
// File: sopc_synchronizer.v
//
// Abstract: Single bit clock domain crossing synchronizer. 
//           Composed of two flip flops connected in series.
//           Random metastable condition is simulated when the 
//           __SOPC__METASTABLE_SIM macro is defined.
//           Use +define+__SOPC__METASTABLE_SIM argument 
//           on the Verilog simulator compiler command line to 
//           enable this mode.
//
//
// Copyright (C) Altera Corporation 2008, All Rights Reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ns

module sopc_synchronizer (
              clk, 
              reset_n, 
              din, 
              dout
              );

   parameter  DEPTH = 2; // must be >= 2
   localparam RANDOM_SEED = 1234567;
   
   input   clk;
   input   reset_n;    
   input   din;
   output  dout;

   // embedded synthesis directive: 
   //     1. preserve all registers
   // embedded timequest directives: 
   //     1. identify the flops in this module as part of a synchronizer 
   //     2. cut all timing paths to the data input of the first flop din_s1
   
   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name PRESERVE_REGISTER ON; -name CUT ON -from \"*\"; -name SDC_STATEMENT \"set_false_path -to [get_keepers {*:*|din_s1}]\" "} *) reg din_s1;

   (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS; -name PRESERVE_REGISTER ON"} *) reg [DEPTH-2:0] dreg;    

   //synthesis translate_off
   initial begin
      if (DEPTH <2) begin
     $display("%m: Error: synchronizer length: %0d less than 2.", DEPTH);
      end
   end
   //synthesis translate_on   



   // the first synchronizer register is either a simple D flop for synthesis
   // and non-metastable simulation or a D flop with a method to inject random
   // metastable events resulting in random delay of [0,1] cycles

   //synthesis translate_off   

`ifdef __SOPC__METASTABLE_SIM

   wire next_din_s1;
   wire dout;
   reg  din_last;
   reg  random;

   initial begin
      $display("%m: Info: Metastable event injection simulation mode enabled");
   end
   
   always @(posedge clk) begin
      if (reset_n == 0)
    random <= $random(RANDOM_SEED);
      else
    random <= $random;
   end

   /*always @(*) begin //v1.1
     if (reset_n && (din_last != din) && (random != din)) begin
    $display("%m: Info: metastable event @ time %t", $time);     
     end
   end */     
   
   assign next_din_s1 = (din_last ^ din) ? random : din;   

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
     din_last <= 1'b0;
       else
     din_last <= din;
   end

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
     din_s1 <= 1'b0;
       else
     din_s1 <= next_din_s1;
   end
   
`else 

   //synthesis translate_on   

   always @(posedge clk or negedge reset_n) begin
       if (reset_n == 0) 
     din_s1 <= 1'b0;
       else
     din_s1 <= din;
   end

   //synthesis translate_off      

`endif

   //synthesis translate_on

   // the remaining synchronizer registers form a simple shift register
   // of length DEPTH-1

   generate
      if (DEPTH < 3) begin
     always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) 
          dreg <= {DEPTH-1{1'b0}};      
        else
          dreg <= din_s1;
     end     
      end else begin
     always @(posedge clk or negedge reset_n) begin
        if (reset_n == 0) 
          dreg <= {DEPTH-1{1'b0}};
        else
          dreg <= {dreg[DEPTH-3:0], din_s1};
     end
      end
   endgenerate

   assign dout = dreg[DEPTH-2];
   
endmodule 

//--------------------------------------------------------------------------------------------------------------------------
// Version             |  Changes                                                                  | Date         | Owner ID
//--------------------------------------------------------------------------------------------------------------------------
//   1.0               | Initial code                                                              |              | 
//   1.1               | Commenting display statement to reduce sim time                           |  16-Feb-2023 | skgr 
//--------------------------------------------------------------------------------------------------------------------------            
