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
// Register Access Control.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_host_control (
   
   reset,
   clk,
   cs,
   rd,
   wr,
   sel,
   data_in,
   data_out,
   busy,
   reg_rd,
   reg_wr,
   reg_sel,
   reg_data_in,
   reg_data_out);

input   reset;                  //  Active High Global Reset
input   clk;                    //  Host Interface Clock
input   cs;                     //  Chip Select
input   rd;                     //  Register Read Strobe
input   wr;                     //  Register Write Strobe
input   [4:0] sel;              //  Register Address
input   [15:0] data_in;         //  Write Data for Host Bus
output  [15:0] data_out;        //  Read Data to Host Bus
output  busy;                   //  Interface Busy
output  reg_rd;                 //  Register Read Strobe
output  reg_wr;                 //  Register Write Strobe
output  [4:0] reg_sel;          //  Register Address
input   [15:0] reg_data_in;     //  Write Data for Host Bus
output  [15:0] reg_data_out;    //  Read Data to Host Bus
 
//  Register Control
//  ----------------

reg     [15:0] data_out;
reg     busy; 
reg     reg_rd; 
reg     reg_wr; 
reg     [4:0] reg_sel; 
reg     [15:0] reg_data_out; 

parameter STM_TYPE_IDLE         = 2'h0;
parameter STM_TYPE_NEXT_CYCLE   = 2'h1;
parameter STM_TYPE_END_READ     = 2'h2;
parameter STM_TYPE_WAIT_CYCLE   = 2'h3;


reg     [1:0] state; 
reg     [1:0] nextstate; 

//  Idle count
reg     idle_cnt;

// Fogbugz 26815 - Back to back register accesses return the same read data
always @(posedge reset or posedge clk)
   begin : process_idle_cnt
   if (reset == 1'b 1)
      begin
          idle_cnt <= 1'b0;	
      end
   else
      begin
         if (state == STM_TYPE_IDLE)
            begin
               if (idle_cnt != 1'b1)
                  idle_cnt <= idle_cnt + 1'b1;
            end
         else
            begin
               idle_cnt <= 1'b0;
            end
      end
   end


always @(posedge reset or posedge clk)
   begin : process_1
   if (reset == 1'b 1)
      begin
      state <= STM_TYPE_IDLE;	
      end
   else
      begin
      state <= nextstate;	
      end
   end

always @(state or rd or wr or cs or idle_cnt)
   begin : process_2
   case (state)
   STM_TYPE_IDLE:
      begin
          // Fogbugz 26815 - Back to back register accesses return the same read data
          if (idle_cnt != 1'b1)
             begin
                nextstate = STM_TYPE_IDLE;
             end
          else
             begin
                   
                if (cs == 1'b 1 & rd == 1'b 0 & wr == 1'b 1 )
                
                  //  Register Write Accesses
                  //  -----------------------
                  
                   begin
                   nextstate = STM_TYPE_NEXT_CYCLE;	
                   end
                else if (cs == 1'b 1 & wr == 1'b 0 & rd == 1'b 1)
                
                  //  Other Read Accesses
                  //  -------------------
                  
                   begin
                   nextstate = STM_TYPE_END_READ;	
                   end
                else
                   begin
                   nextstate = STM_TYPE_IDLE;	
                   end
             end
      end
   STM_TYPE_END_READ:
      begin
      nextstate = STM_TYPE_NEXT_CYCLE;	
      end
   STM_TYPE_NEXT_CYCLE:
      begin
      nextstate = STM_TYPE_WAIT_CYCLE;	
      end
   STM_TYPE_WAIT_CYCLE:
      begin
      nextstate = STM_TYPE_IDLE;	
      end
   default:
      begin      
      nextstate = STM_TYPE_IDLE;	
      end   
   endcase
   end

//  Registers Control
//  -----------------                                        

always @(posedge reset or posedge clk)
   begin : process_3
   if (reset == 1'b 1)
      begin
      reg_data_out <= {16{1'b 0}};	
      reg_wr       <= 1'b 0;	
      reg_sel      <= {5{1'b 0}};	
      end
   else
      begin
      reg_data_out <= data_in;	
      reg_sel <= sel;	
      if (nextstate == STM_TYPE_NEXT_CYCLE)
         begin
         reg_wr <= wr;	
         end
      else
         begin
         reg_wr <= 1'b 0;	
         end
      end
   end

always @(posedge reset or posedge clk)
   begin : process_4
   if (reset == 1'b 1)
      begin
      reg_rd <= 1'b 0;	
      end
   else
      begin
      if (nextstate == STM_TYPE_END_READ)
         begin
         reg_rd <= 1'b 1;	
         end
      else
         begin
         reg_rd <= 1'b 0;	
         end
      end
   end

//  Interface Control
//  -----------------

always @(posedge reset or posedge clk)
   begin : process_5
   if (reset == 1'b 1)
      begin
      data_out <= {16{1'b 0}};	
      end
   else
      begin
      data_out <= reg_data_in;	
      end
   end

always @(posedge reset or posedge clk)
   begin : process_6
   if (reset == 1'b 1)
      begin
      busy <= 1'b 1;	
      end
   else
      begin
      if (nextstate == STM_TYPE_WAIT_CYCLE)
         begin
         busy <= 1'b 0;	
         end
      else
         begin
         busy <= 1'b 1;	
         end
      end
   end

endmodule // module pcs_host_control
