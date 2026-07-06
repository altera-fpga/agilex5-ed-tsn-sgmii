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
// SGMII Transmit Converter.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_tx_converter (

   reset,
   sw_reset,
   clk,
   eth_speed,
   ff_rden,
   ff_aempty,
   ff_data,
   pcs_data,
   pcs_en,
   pcs_err);

input   reset;                  //  Active High Global Reset
input   sw_reset;               //  SW Synchronous Reset           
input   clk;                    //  125MHz Receive Clock
input   [1:0] eth_speed;        //  Signal Detect from PMA      
output  ff_rden;                //  FIFO Write Enable 
input   ff_aempty;              //  FIFO Almost Empty          
input   [19:0] ff_data;         //  FIFO Data 9:0 is for 1G; 19:0 is for 2.5G
output  [15:0] pcs_data;        //  GMII Data 7:0 is for 1G; 15:0 is for 2.5G
output  [1:0] pcs_en;           //  GMII Data Valid bit 0 is for 1G; 1:0 is for 2.5G        
output  [1:0] pcs_err;          //  GMII Error bit 0 is for 1G; 1:0 is for 2.5G        

reg     ff_rden; 
reg     [15:0] pcs_data;        //7:0 is for 1G; 15:0 is for 2.5G
reg     [1:0] pcs_en;           //bit 0 is for 1G; 1:0 is for 2.5G    
reg     [1:0] pcs_err;          //bit 0 is for 1G; 1:0 is for 2.5G    

localparam STM_TYP_IDLE      = 2'h0;
localparam STM_TYP_GIGA_MODE = 2'h1;
localparam STM_TYP_WAIT_RD   = 2'h2;
localparam STM_TYP_FF_READ   = 2'h3;

reg     [1:0] nextstate; 
reg     [1:0] state; 

reg     [6:0] rden_cnt; 
reg     rden_cnt_dec; 

always @(posedge reset or posedge clk)
   begin : process_2
   if (reset == 1'b 1)
      begin
      state <= STM_TYP_IDLE;   
      end
   else
      begin
      state <= nextstate;   
      end
   end

always @(state or rden_cnt_dec or eth_speed or ff_aempty or sw_reset)
   begin : process_3
   case (state)
   STM_TYP_IDLE:
      begin
      if (ff_aempty == 1'b 0 & eth_speed == 2'b 10 & 
      sw_reset == 1'b 0)
         begin
         nextstate = STM_TYP_GIGA_MODE;   
         end
      else if (ff_aempty == 1'b 0 & sw_reset == 1'b 0 )
         begin
         nextstate = STM_TYP_FF_READ;   
         end
      else
         begin
         nextstate = STM_TYP_IDLE;   
         end
      end
   STM_TYP_GIGA_MODE:
      begin
      if (eth_speed != 2'b 10 | sw_reset == 1'b 1)
         begin
         nextstate = STM_TYP_IDLE;   
         end
      else
         begin
         nextstate = STM_TYP_GIGA_MODE;   
         end
      end
   STM_TYP_FF_READ:
      begin
      nextstate = STM_TYP_WAIT_RD;   
      end
   STM_TYP_WAIT_RD:
      begin
      if (eth_speed == 2'b 10 | sw_reset == 1'b 1)
         begin
         nextstate = STM_TYP_IDLE;   
         end
      else if (rden_cnt_dec == 1'b 1 )
         begin
         nextstate = STM_TYP_FF_READ;   
         end
      else
         begin
         nextstate = STM_TYP_WAIT_RD;   
         end
      end
   default:
      begin
      nextstate = STM_TYP_IDLE;
      end
   endcase
   end

//  FIFO Read Control
//  -----------------

always @(posedge reset or posedge clk)
   begin : process_4
   if (reset == 1'b 1)
      begin
      rden_cnt <= {7{1'b 0}};   
      end
   else
      begin
      if (eth_speed == 2'b 00)
         begin
         if (rden_cnt == 8'h 63)
            begin
            rden_cnt <= {7{1'b 0}};   
            end
         else
            begin
            rden_cnt <= rden_cnt + 1'b 1;   
            end
         end
      else if (eth_speed == 2'b 01 )
         begin
         if (rden_cnt >= 8'h 09)
            begin
            rden_cnt <= {7{1'b 0}};   
            end
         else
            begin
            rden_cnt <= rden_cnt + 1'b 1;   
            end
         end
      else
         begin
         rden_cnt <= {7{1'b 0}};   
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_5
   if (reset == 1'b 1)
      begin
      rden_cnt_dec <= 1'b 0;   
      end
   else
      begin
      if (eth_speed == 2'b 00)
         begin
         if (rden_cnt == 8'h 62)
            begin
            rden_cnt_dec <= 1'b 1;   
            end
         else
            begin
            rden_cnt_dec <= 1'b 0;   
            end
         end
      else if (eth_speed == 2'b 01 )
         begin
         if (rden_cnt == 4'h 8)
            begin
            rden_cnt_dec <= 1'b 1;   
            end
         else
            begin
            rden_cnt_dec <= 1'b 0;   
            end
         end
      else
         begin
         rden_cnt_dec <= 1'b 0;   
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_6
   if (reset == 1'b 1)
      begin
      ff_rden <= 1'b 0;   
      end
   else
      begin
      if (state == STM_TYP_GIGA_MODE)
         begin
         ff_rden <= ~ ff_aempty;   
         end
      else if (state == STM_TYP_FF_READ )
         begin
         ff_rden <= ~ ff_aempty;   
         end
      else
         begin
         ff_rden <= 1'b 0;   
         end
      end
   end

//  PCS GMII Data
//  -------------

always @(posedge reset or posedge clk)
   begin : process_7
   if (reset == 1'b 1)
      begin
      pcs_data <= {16{1'b 0}};   
      pcs_en   <= 2'b 0;   
      pcs_err  <= 2'b 0;   
      end
   else
      // begin
      // pcs_data <= ff_data[15:0];   
      // pcs_en   <= ff_data[17:16];   
      // pcs_err  <= ff_data[19:18];   
      // end

      begin
      if (eth_speed ==2'b11)		//sbalasun: temporary for 1G  
          begin
            pcs_data[7:0] <= ff_data[7:0];   
            pcs_en[0]     <= ff_data[8];   
            pcs_err[0]    <= ff_data[9];
          end
      else				//sbalasun:temporary for 2.5G
          begin
            pcs_data      <= ff_data[15:0];   
            pcs_en        <= ff_data[17:16];   
            pcs_err       <= ff_data[19:18];
          end
      end
   end

endmodule // module tx_converter
