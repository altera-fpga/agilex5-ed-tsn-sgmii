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


// (C) 2001-2021 Intel Corporation. All rights reserved.
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


`timescale 1ps/1ps
module alt_mge_x2_rx_sync (
   input                clk,
   input                reset,
   input                signal_detect,
   input      [1:0]     kchar,
   input      [15:0]    data,
   input      [1:0]     char_err,
   output reg           sync_lost,
   output reg           sync_acqurd,
   output reg [1:0]     rx_even,
   output reg [1:0]     rx_sync
);

parameter STM_TYP_LOST_OF_SYNC                     = 4'd0;
parameter STM_TYP_COMMA_DETECT_1                   = 4'd1;
parameter STM_TYP_COMMA_DETECT_2                   = 4'd2;
parameter STM_TYP_COMMA_DETECT_3                   = 4'd3;
parameter STM_TYP_SYNC_ACQUIRED_1                  = 4'd4;
parameter STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1    = 4'd5;
parameter STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2    = 4'd6;
parameter STM_TYP_SYNC_ACQUIRED_2                  = 4'd8;
parameter STM_TYP_SYNC_ACQUIRED_3                  = 4'd9;
parameter STM_TYP_SYNC_ACQUIRED_4                  = 4'd10;
parameter STM_TYP_SYNC_ACQUIRED_2A                 = 4'd11;
parameter STM_TYP_SYNC_ACQUIRED_3A                 = 4'd12;
parameter STM_TYP_SYNC_ACQUIRED_4A                 = 4'd13;

reg [3:0] state;
reg [3:0] nxt_state;

reg [1:0] good_cgs;
reg [1:0] nxt_good_cgs;

wire [1:0] comma_detect;
wire [1:0] data_detect;
wire [1:0] cgbad;


//define cgbad
assign cgbad = char_err | (rx_even & comma_detect) ;

assign comma_detect[0] = (data[ 7:0] == 8'h3C | data[ 7:0] == 8'hBC | data[ 7:0] == 8'hFC) & kchar[0] == 1'b 1 & char_err[0] == 1'b0;
assign comma_detect[1] = (data[15:8] == 8'h3C | data[15:8] == 8'hBC | data[15:8] == 8'hFC) & kchar[1] == 1'b 1 & char_err[1] == 1'b0;

assign data_detect[0] = kchar[0] == 1'b 0 & char_err[0] == 1'b0;
assign data_detect[1] = kchar[1] == 1'b 0 & char_err[1] == 1'b0;

always @(posedge clk or posedge reset)
begin
   if (reset)
   begin
      rx_even <= 2'b01;
   end
   else
   begin
      if (nxt_state == STM_TYP_COMMA_DETECT_1)
      begin
         rx_even <= 2'b01;
      end
      else if (nxt_state == STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1)
      begin
         rx_even <= 2'b10;
      end
      else
      begin
         rx_even <= rx_even;
      end
   end
end

always @(posedge clk or posedge reset)
begin
   if (reset)
   begin
      rx_sync <= 2'b0;
   end
   else
   begin
      if (  nxt_state == STM_TYP_LOST_OF_SYNC ||
            nxt_state == STM_TYP_COMMA_DETECT_1 ||
            nxt_state == STM_TYP_COMMA_DETECT_2 ||
            nxt_state == STM_TYP_COMMA_DETECT_3 ||
            nxt_state == STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1 ||
            nxt_state == STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2)
      begin
         rx_sync <= 2'b0;
      end
      else
      begin
         if (state == STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2 && nxt_state == STM_TYP_SYNC_ACQUIRED_1)
            rx_sync <= 2'b11;
         else if (state == STM_TYP_COMMA_DETECT_3 && (nxt_state == STM_TYP_SYNC_ACQUIRED_1 || nxt_state == STM_TYP_SYNC_ACQUIRED_2))
            rx_sync <= 2'b10;
         else
            rx_sync <= 2'b11;
      end
   end
end

always @(posedge clk or posedge reset)
begin
   if (reset)
   begin
      sync_lost <= 1'b1;
      sync_acqurd <= 1'b0;
   end
   else
   begin
      if (  nxt_state == STM_TYP_LOST_OF_SYNC ||
            nxt_state == STM_TYP_COMMA_DETECT_1 ||
            nxt_state == STM_TYP_COMMA_DETECT_2 ||
            nxt_state == STM_TYP_COMMA_DETECT_3 ||
            nxt_state == STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1 ||
            nxt_state == STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2)
      begin
         sync_lost <= 1'b1;
         sync_acqurd <= 1'b0;
      end
      else
      begin
         sync_lost <= 1'b0;
         sync_acqurd <= 1'b1;
      end
   end
end

always @(posedge clk or posedge reset)
begin
   if (reset)
   begin
      state <= STM_TYP_LOST_OF_SYNC;
   end
   else
   begin
      state <= nxt_state;
   end
end

always @(posedge clk or posedge reset)
begin
   if (reset)
   begin
      good_cgs <= 2'd0;
   end
   else
   begin
      good_cgs <= nxt_good_cgs;
   end
end

always @(*)
begin
   case (state)
      STM_TYP_LOST_OF_SYNC:
      begin
         if (signal_detect == 1'b1 && comma_detect[0] == 1'b1 && data_detect[1] == 1'b1)
            nxt_state = STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1;
         else if (signal_detect == 1'b1 && comma_detect[1] == 1'b1)
            nxt_state = STM_TYP_COMMA_DETECT_1;
         else
            nxt_state = STM_TYP_LOST_OF_SYNC;
      end
      STM_TYP_COMMA_DETECT_1: // 1st comma at 2nd word
      begin
         if (data_detect[0] == 1'b0 || cgbad != 2'b0)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (comma_detect[1] == 1'b1 && data_detect[0] == 1'b1)
            nxt_state = STM_TYP_COMMA_DETECT_2;
         else
            nxt_state = STM_TYP_COMMA_DETECT_1;

      end
      STM_TYP_COMMA_DETECT_2: // 2nd comma at 2nd word
      begin
         if (data_detect[0] == 1'b0 || cgbad != 2'b0)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (comma_detect[1] == 1'b1 && data_detect[0] == 1'b1)
            nxt_state = STM_TYP_COMMA_DETECT_3;
         else
            nxt_state = STM_TYP_COMMA_DETECT_2;
      end
      STM_TYP_COMMA_DETECT_3: // 3rd comma at 2nd word
      begin
         if (data_detect[0] == 1'b0 || cgbad != 2'b0)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (data_detect[0] == 1'b1 && cgbad == 2'b0)
            nxt_state = STM_TYP_SYNC_ACQUIRED_1;
         else if (data_detect[0] == 1'b1 && cgbad == 2'b10)
            nxt_state = STM_TYP_SYNC_ACQUIRED_2;
         else
            nxt_state = STM_TYP_COMMA_DETECT_3;
      end
      STM_TYP_SYNC_ACQUIRED_1:
      begin
         if (cgbad == 2'b01)
            nxt_state = STM_TYP_SYNC_ACQUIRED_2A;
         else if (cgbad == 2'b10)
            nxt_state = STM_TYP_SYNC_ACQUIRED_2;
         else if (cgbad == 2'b11)
            nxt_state = STM_TYP_SYNC_ACQUIRED_3;
         else
            nxt_state = STM_TYP_SYNC_ACQUIRED_1;
      end
      STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1: // 1st comma at first word followed by data
      begin
         if (data_detect[1] == 1'b0 || cgbad != 2'b0)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (comma_detect[0] == 1'b1 && data_detect[1] == 1'b1)
            nxt_state = STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2;
         else
            nxt_state = STM_TYP_COMMA_DETECT_1_ACQUIRE_SYNC_1;
      end
      STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2: // 2nd comma at first word followed by data
      begin
         if (data_detect[1] == 1'b0 || cgbad != 2'b0)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (comma_detect[0] == 1'b1 && data_detect[1] == 1'b1)
            nxt_state = STM_TYP_SYNC_ACQUIRED_1;
         else
            nxt_state = STM_TYP_COMMA_DETECT_2_ACQUIRE_SYNC_2;
      end
      STM_TYP_SYNC_ACQUIRED_2:
      begin
         if (cgbad == 2'b11)
            nxt_state = STM_TYP_SYNC_ACQUIRED_4;
         else if (cgbad == 2'b01)
            nxt_state = STM_TYP_SYNC_ACQUIRED_3A;
         else if (cgbad == 2'b10)
            nxt_state = STM_TYP_SYNC_ACQUIRED_3;
         else 
            nxt_state = STM_TYP_SYNC_ACQUIRED_2A;
      end
      STM_TYP_SYNC_ACQUIRED_3:
      begin
         if (cgbad == 2'b11)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (cgbad == 2'b01)
            nxt_state = STM_TYP_SYNC_ACQUIRED_4A;
         else if (cgbad == 2'b10)
            nxt_state = STM_TYP_SYNC_ACQUIRED_4;
         else
            nxt_state = STM_TYP_SYNC_ACQUIRED_3A;
      end
      STM_TYP_SYNC_ACQUIRED_4:
      begin
         if (cgbad == 2'b11)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (cgbad == 2'b01)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (cgbad == 2'b10)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else
            nxt_state = STM_TYP_SYNC_ACQUIRED_4A;
      end
      STM_TYP_SYNC_ACQUIRED_2A:
      begin
         if (cgbad == 2'b11)
            nxt_state = STM_TYP_SYNC_ACQUIRED_4;
         else if (cgbad == 2'b01)
            nxt_state = STM_TYP_SYNC_ACQUIRED_3A;
         else if (cgbad == 2'b10)
         begin
            if (good_cgs == 3)
               nxt_state = STM_TYP_SYNC_ACQUIRED_2;
            else
               nxt_state = STM_TYP_SYNC_ACQUIRED_3;
         end
         else
         begin
            if (good_cgs == 3 || good_cgs == 2)
               nxt_state = STM_TYP_SYNC_ACQUIRED_1;
            else
               nxt_state = STM_TYP_SYNC_ACQUIRED_2A;
         end
      end
      STM_TYP_SYNC_ACQUIRED_3A:
      begin
         if (cgbad == 2'b11)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (cgbad == 2'b01)
            nxt_state = STM_TYP_SYNC_ACQUIRED_4A;
         else if (cgbad == 2'b10)
         begin
            if (good_cgs == 3)
               nxt_state = STM_TYP_SYNC_ACQUIRED_3;
            else
               nxt_state = STM_TYP_SYNC_ACQUIRED_4;
         end
         else
         begin
            if (good_cgs == 3 || good_cgs == 2)
               nxt_state = STM_TYP_SYNC_ACQUIRED_2A;
            else
               nxt_state = STM_TYP_SYNC_ACQUIRED_3A;
         end
      end
      STM_TYP_SYNC_ACQUIRED_4A:
      begin
         if (cgbad == 2'b11)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (cgbad == 2'b01)
            nxt_state = STM_TYP_LOST_OF_SYNC;
         else if (cgbad == 2'b10)
         begin
            if (good_cgs == 3)
               nxt_state = STM_TYP_SYNC_ACQUIRED_4;
            else
               nxt_state = STM_TYP_LOST_OF_SYNC;
         end
         else
         begin
            if (good_cgs == 3 || good_cgs == 2)
               nxt_state = STM_TYP_SYNC_ACQUIRED_3A;
            else
               nxt_state = STM_TYP_SYNC_ACQUIRED_4A;
         end
      end
      default:
      begin
         nxt_state = STM_TYP_LOST_OF_SYNC;
      end
   endcase
end

always @(*)
begin
   case (state)
      STM_TYP_SYNC_ACQUIRED_2:
      begin
         if (cgbad == 2'b00)     // -> SYNC_ACQUIRED_2A -> SYNC_ACQUIRED_2A
            nxt_good_cgs = 2'd2;
         else if (cgbad == 2'b01)// -> SYNC_ACQUIRED_3  -> SYNC_ACQUIRED_3A
            nxt_good_cgs = 2'd1;
         else
         begin
            // 2'b10                   -> SYNC_ACQUIRED_2A -> SYNC_ACQUIRED_3
            // 2'b11                   -> SYNC_ACQUIRED_3  -> SYNC_ACQUIRED_4
            nxt_good_cgs = 2'd0;
         end
      end
      STM_TYP_SYNC_ACQUIRED_3:
      begin
         if (cgbad == 2'b00) //     -> SYNC_ACQUIRED_3A -> SYNC_ACQUIRED_3A
            nxt_good_cgs = 2'd2;
         else if (cgbad == 2'b01) //-> SYNC_ACQUIRED_4  -> SYNC_ACQUIRED_4A 
            nxt_good_cgs = 2'd1;
         else
         begin
            // 2'b10                   -> SYNC_ACQUIRED_3A -> SYNC_ACQUIRED_4
            // 2'b11                   -> SYNC_ACQUIRED_4  -> LOST_OF_SYNC
            nxt_good_cgs = 2'd0;
         end
      end
      STM_TYP_SYNC_ACQUIRED_4:
      begin
         if (cgbad == 2'b00) //     -> SYNC_ACQUIRED_4A -> SYNC_ACQUIRED_4A
            nxt_good_cgs = 2'd2;
         else
         begin
            // 2'b01                   -> LOST_OF_SYNC     -> *
            // 2'b10                   -> SYNC_ACQUIRED_4A -> LOST_OF_SYNC
            // 2'b11                   -> LOST_OF_SYNC     -> LOST_OF_SYNC
            nxt_good_cgs = 2'd0;
         end
      end
      STM_TYP_SYNC_ACQUIRED_2A:
      begin
         if (cgbad == 2'b00) 
         begin
            //       (good_cgs == 1)   -> SYNC_ACQUIRED_2A -> SYNC_ACQUIRED_2A
            //       (good_cgs == 2)   -> SYNC_ACQUIRED_2A -> SYNC_ACQUIRED_1
            //       (good_cgs == 3)   -> SYNC_ACQUIRED_1  -> SYNC_ACQUIRED_1
            // nxt_good_cgs = good_cgs + 2
            nxt_good_cgs = 2'd3;
         end
         else if (cgbad == 2'b01) //-> SYNC_ACQUIRED_3  -> SYNC_ACQUIRED_3A
         begin
            nxt_good_cgs = 2'd1;
         end
         else if (cgbad == 2'b10)
         begin
            //       (good_cgs == 3)   -> SYNC_ACQUIRED_1  -> SYNC_ACQUIRED_2
            //       (good_cgs == 2)   -> SYNC_ACQUIRED_2A -> SYNC_ACQUIRED_3
            //       (good_cgs == 1)   -> SYNC_ACQUIRED_2A -> SYNC_ACQUIRED_3
            nxt_good_cgs = 2'd0;
         end
         begin
            //(cgbad == 2'b11)      -> SYNC_ACQUIRED_3  -> SYNC_ACQUIRED_4
            nxt_good_cgs = 2'd0;
         end
      end
      STM_TYP_SYNC_ACQUIRED_3A:
      begin
         if (cgbad == 2'b00) 
         begin
            //       (good_cgs == 1)   -> SYNC_ACQUIRED_3A -> SYNC_ACQUIRED_3A
            //       (good_cgs == 2)   -> SYNC_ACQUIRED_3A -> SYNC_ACQUIRED_2
            //       (good_cgs == 3)   -> SYNC_ACQUIRED_2  -> SYNC_ACQUIRED_2A
            if (good_cgs == 2'd1)
               nxt_good_cgs = 2'd3;
            else if (good_cgs == 2'd2)
               nxt_good_cgs = 2'd0;
            else
               nxt_good_cgs = 2'd1;
         end
         else if (cgbad == 2'b01) //-> SYNC_ACQUIRED_4  -> SYNC_ACQUIRED_4A
         begin
            nxt_good_cgs = 2'd1;
         end
         else if (cgbad == 2'b10)
         begin
            //       (good_cgs == 3)   -> SYNC_ACQUIRED_2  -> SYNC_ACQUIRED_3
            //       (good_cgs == 2)   -> SYNC_ACQUIRED_3A -> SYNC_ACQUIRED_4
            //       (good_cgs == 1)   -> SYNC_ACQUIRED_3A -> SYNC_ACQUIRED_4
            nxt_good_cgs = 2'd0;
         end
         begin
            //(cgbad == 2'b11)      -> SYNC_ACQUIRED_4  -> LOST_OF_SYNC
            nxt_good_cgs = 2'd0;
         end
      end
      STM_TYP_SYNC_ACQUIRED_4A:
      begin
         if (cgbad == 2'b00) 
         begin
            //       (good_cgs == 1)   -> SYNC_ACQUIRED_4A -> SYNC_ACQUIRED_4A
            //       (good_cgs == 2)   -> SYNC_ACQUIRED_4A -> SYNC_ACQUIRED_3
            //       (good_cgs == 3)   -> SYNC_ACQUIRED_3  -> SYNC_ACQUIRED_3A
            if (good_cgs == 2'd1)
               nxt_good_cgs = 2'd3;
            else if (good_cgs == 2'd2)
               nxt_good_cgs = 2'd0;
            else
               nxt_good_cgs = 2'd1;
         end
         else if (cgbad == 2'b01) //-> LOST_OF_SYNC    -> *
         begin
            nxt_good_cgs = 2'd0;
         end
         else if (cgbad == 2'b10)
         begin
            //       (good_cgs == 3)   -> SYNC_ACQUIRED_3  -> SYNC_ACQUIRED_4
            //       (good_cgs == 2)   -> SYNC_ACQUIRED_4A -> LOST_OF_SYNC
            //       (good_cgs == 1)   -> SYNC_ACQUIRED_4A -> LOST_OF_SYNC
            nxt_good_cgs = 2'd0;
         end
         begin
            //(cgbad == 2'b11)      -> LOST_OF_SYNC  -> LOST_OF_SYNC
            nxt_good_cgs = 2'd0;
         end
      end
      default:
      begin
         nxt_good_cgs = 2'd0;
      end
   endcase
end

endmodule
