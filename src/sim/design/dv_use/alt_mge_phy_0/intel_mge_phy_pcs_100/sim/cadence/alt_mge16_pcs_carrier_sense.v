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
// Carrier Detection module.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_carrier_sense (

   reset,
   sw_reset,
   clk,
   clkena,
   transmit,
   receive,
   gmii_crs);

parameter SYNCHRONIZER_DEPTH = 3;
   
input   reset;          //  Active High Global Reset
input   sw_reset;       //  SW Synchronous Reset           
input   clk;            //  125MHz Common Clock  
input   clkena;     //  Clock enable signal 
input   transmit;       //  Frame Transmission Active
input   receive;        //  Frame Reception Active
output  gmii_crs;       //  Carrier Sense

reg     gmii_crs; 

localparam STM_TYPE_SENSE_OFF = 1'b 0;
localparam STM_TYPE_SENSE_ON  = 1'b 1;

reg     state; 
reg     nextstate; 

wire    receive_reg2;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_2(
			.clk(clk), // INPUT
			.reset_n(~reset), //INPUT
			.din(receive), //INPUT
			.dout(receive_reg2));// OUTPUT

always @(posedge reset or posedge clk)
   begin : process_1
   if (reset == 1'b 1)
      begin
      state <= STM_TYPE_SENSE_OFF;	
      end
   else
      begin
	  if (clkena == 1'b1) begin
	      if (sw_reset == 1'b 1)
	         begin
	         state <= STM_TYPE_SENSE_OFF;	
	         end
	      else
	         begin
	         state <= nextstate;	
	         end
	      end
	  end
   end

always @(state or transmit or receive_reg2)
   begin : process_2
   case (state)
   STM_TYPE_SENSE_OFF:
      begin
      if (transmit == 1'b 1 | receive_reg2 == 1'b 1)
         begin
         nextstate = STM_TYPE_SENSE_ON;	
         end
      else
         begin
         nextstate = STM_TYPE_SENSE_OFF;	
         end
      end
   STM_TYPE_SENSE_ON:
      begin
      if (transmit == 1'b 0 & receive_reg2 == 1'b 0)
         begin
         nextstate = STM_TYPE_SENSE_OFF;	
         end
      else
         begin
         nextstate = STM_TYPE_SENSE_ON;	
         end
      end
   default:
      begin
      nextstate = STM_TYPE_SENSE_OFF;	
      end
    
   endcase
   end
   
always @(posedge reset or posedge clk)
   begin
   if (reset == 1'b 1)
      begin
      gmii_crs <= 1'b0;	
      end
   else
      begin
		  if (clkena == 1'b1) begin
			  gmii_crs <= state == STM_TYPE_SENSE_ON ? 1'b 1 : 1'b 0;
		  end
      end
   end

endmodule // module carrier_sense

