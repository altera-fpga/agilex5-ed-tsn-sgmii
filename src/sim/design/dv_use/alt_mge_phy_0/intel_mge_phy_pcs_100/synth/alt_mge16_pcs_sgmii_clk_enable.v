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
// Clock control generation.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_sgmii_clk_enable (
   
   reset_clk,
   ethernet_mode,
   clk,
   clk_ena_half,
   clk_ena);

input   reset_clk;              //  Asynchronous Reset - clk Domain
input   [1:0] ethernet_mode;    //  MAC Speed Selection
input   clk;                    //  Input Clock  of 125 MHz          
output  clk_ena;                //  Clock Enable 
output clk_ena_half;

reg clk_ena_half_i;
wire    clk_ena; 
reg     clk_ena_i; 
reg     [2:0] count5;
reg     [5:0] count50;
reg     [3:0] count10;
reg     [6:0] count100;


always @(posedge reset_clk or posedge clk)
   begin
   if (reset_clk == 1'b 1)
      begin
      count10 <= 4'b 0000;	
      count100 <= 7'b 0000000;
	   count5 <= 3'b 000;	
      count50 <= 6'b 000000;
      end
   else
      begin
	  
		  if (count10 == 4'b 1001) begin
		  count10 <= 4'b 0000;
		  end
		  else begin
		  count10 <= count10 + 4'b0001;
		  end

		  if (count100 == 7'h 63) begin
		  count100 <= 7'h 00;
		  end
		  else begin
		  count100 <= count100 + 7'h01;
		  end
		  
		 if (count5 == 3'b 100) begin
		  count5 <= 3'b 000;
		  end
		  else begin
		  count5 <= count5 + 3'b001;
		  end

		  if (count50 == 6'h 31) begin
		  count50 <= 6'h 00;
		  end
		  else begin
		  count50 <= count50 + 6'h01;
		  end 

	  end
   end
   
always @(posedge reset_clk or posedge clk)
   begin
   if (reset_clk == 1'b 1)
      begin
      clk_ena_i <= 1'b 1;	
      end
   else
      begin
      if (ethernet_mode[1] == 1'b1)
         begin
         clk_ena_i <= 1'b 1;	
         end
      else if ((ethernet_mode == 2'b01) && (count5 == 3'b100))
         begin
         clk_ena_i <= 1'b 1;	
         end
      else if ((ethernet_mode == 2'b00) && (count50 == 6'h 31))
         begin
         clk_ena_i <= 1'b 1;	
         end
      else
         begin
         clk_ena_i <= 1'b 0;	
         end
      end
   end

assign clk_ena = clk_ena_i;  


always @(posedge reset_clk or posedge clk)
   begin
   if (reset_clk == 1'b 1)
      begin
      clk_ena_half_i <= 1'b 1;	
      end
   else
      begin
      if (ethernet_mode[1] == 1'b1)
         begin
         clk_ena_half_i <= 1'b 1;	
         end
      else if ((ethernet_mode == 2'b01) && (count10 == 4'b 1001))
         begin
         clk_ena_half_i <= 1'b 1;	
         end
      else if ((ethernet_mode == 2'b00) && (count100 == 7'h 63))
         begin
         clk_ena_half_i <= 1'b 1;	
         end
      else
         begin
         clk_ena_half_i <= 1'b 0;	
         end
      end
   end

assign clk_ena_half = clk_ena_half_i;  



endmodule
