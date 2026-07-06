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
// Gray Counter
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_gray_cnt (

   clk,
   clkena,
   reset,
//   sw_reset,
   enable,
   b_out,
   g_out);
   
parameter ADDR_WIDTH = 3'b 111;
parameter DEPTH = 8'b 10000000;

input   clk; 
input   clkena;
input   reset; 
//input   sw_reset;
input   enable; 
output  [ADDR_WIDTH - 1:0] b_out; 
output  [ADDR_WIDTH - 1:0] g_out; 
(* syn_preserve = 1 *)reg     [ADDR_WIDTH - 1:0] b_out; 
(* syn_preserve = 1 *)reg     [ADDR_WIDTH - 1:0] g_out/* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"D102\"" */; 
reg     [ADDR_WIDTH - 1:0] b_int;
wire    [ADDR_WIDTH - 1:0] b_slv; 

wire    [ADDR_WIDTH - 1:0]  gry_grayval; 

always @(posedge clk or posedge reset)
   begin : bin
   if (reset == 1'b 1)
      begin
      b_int <= 1'b 1;	
      end
   else
      begin
//      if (sw_reset==1'b1)
//         begin
//         b_int <= 1'b 1;
//         end
//      else
//         begin
         if (clkena == 1'b1 && enable == 1'b 1)
            begin
            if (b_int < (DEPTH - 1'b 1))
               begin
               b_int <= (b_int + 1'b 1);	
               end
            else
               begin
               b_int <= {(ADDR_WIDTH){1'b 0}};	
               end
            end
         end
      end
//   end

assign b_slv = b_int; //  conv_std_logic_vector(b_int, ADDR_WIDTH);

//  Binary next generation to run according the gray values
//  -------------------------------------------------------

always @(posedge clk or posedge reset)
   begin : binreg
   if (reset == 1'b 1)
      begin
      b_out <= {(ADDR_WIDTH){1'b 0}};	
      end
   else
      begin
//      if (sw_reset==1'b1)
//         begin
//         b_out <= {(ADDR_WIDTH){1'b 0}};
//         end
//      else
//         begin
         if (clkena == 1'b1 && enable == 1'b 1)
            begin
            b_out <= b_slv;	
            end
         end
      end
//   end

//  Binary to Gray Code conversion with additional Registers
//  --------------------------------------------------------

assign gry_grayval = bin2gray(b_slv) ;

always @(posedge clk or posedge reset)
   begin : gry
   if (reset == 1'b 1)
      begin
      g_out <= {(ADDR_WIDTH){1'b 0}};	
      end
   else
      begin
//      if (sw_reset==1'b1)
//         begin
//         g_out <= {(ADDR_WIDTH){1'b 0}};
//         end
//      else
//         begin
         if (clkena == 1'b1 && enable == 1'b 1)
            begin 
            g_out <= gry_grayval;	
            end
         end
      end
//   end

// Binary to Gray Conversion
// -------------------------

function [ADDR_WIDTH-1:0] bin2gray;

        input [ADDR_WIDTH-1:0]  bin_val ;
        
        integer LOOP_INDEX; 
                
        for (LOOP_INDEX = 0; LOOP_INDEX <= ADDR_WIDTH - 1; LOOP_INDEX = LOOP_INDEX + 1)
        begin
            
                if (LOOP_INDEX == ADDR_WIDTH - 1)
                begin
               
                        bin2gray[LOOP_INDEX] = bin_val[LOOP_INDEX];	
               
                end
                else
                begin
               
                        bin2gray[LOOP_INDEX] = bin_val[LOOP_INDEX + 1] ^ bin_val[LOOP_INDEX];	
               
                end
        
        end
        
endfunction

endmodule // module gray_cnt
