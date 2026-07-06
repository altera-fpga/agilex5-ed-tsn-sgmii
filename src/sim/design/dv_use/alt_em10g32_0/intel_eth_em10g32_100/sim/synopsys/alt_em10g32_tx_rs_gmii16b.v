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


`timescale 1ns/1ns

module alt_em10g32_tx_rs_gmii16b (
   // Clock and reset
   input clk,
   input rst_n,

   // IPG setting
   input [7:0] ipg_value_1g,

   // Avalon-ST Data path
   input tx_ethfrm_sop,
   input tx_ethfrm_eop,
   input tx_ethfrm_valid,
   output reg tx_ethfrm_ready,
   input [31:0] tx_ethfrm_data,
   input [1:0] tx_ethfrm_empty,
   input tx_ethfrm_error,
   input [1:0] tx_ethfrm_channel,
   input tx_clkena,
   // GMII 16 bit signals
   output reg [1:0] gmii16b_tx_en,    //  GMII Transmit Enable
   output reg [15:0] gmii16b_tx_d,    //  GMII Transmit Data
   output reg [1:0] gmii16b_tx_err,   //  GMII Transmit Error
   output reg [1:0] gmii16b_tx_channel //  GMII Transmit Frame Source
);
parameter SYNC_RESET_N = 1;
localparam SYM_PREAMBLE = 8'h55;
localparam SYM_SFD = 8'hd5;

reg tx_ethfrm_sop_reg;
reg tx_ethfrm_eop_reg;
reg [1:0] tx_ethfrm_empty_reg;
reg [31:0] tx_ethfrm_data_reg;
reg [3:0] tx_ethfrm_error_reg;
reg [3:0] tx_ethfrm_valid_reg;
reg [1:0] tx_ethfrm_channel_reg;

reg data_even;
reg dfa_gmii16b_tx_sop;
reg dfa_gmii16b_tx_eop;

reg [1:0] dfa_gmii16b_tx_en;
reg [15:0] dfa_gmii16b_tx_d;
reg [1:0] dfa_gmii16b_tx_err;
reg [1:0] dfa_gmii16b_tx_channel;

reg [1:0] dfa_gmii16b_tx_en_d0;
reg [15:0] dfa_gmii16b_tx_d_d0;
reg [1:0] dfa_gmii16b_tx_err_d0;
reg [1:0] dfa_gmii16b_tx_channel_d0;
reg [1:0] dfa_gmii16b_tx_en_d1;
reg [15:0] dfa_gmii16b_tx_d_d1;
reg [1:0] dfa_gmii16b_tx_err_d1;
reg [1:0] dfa_gmii16b_tx_channel_d1;

reg ipg_backpressure; // Backpressure for IPG and PREAMBLE SFD generation
reg [7:0] ipg_count;
reg ipg_done;
reg ipg_needed;
reg data_select;
reg data_select_next;
reg [3:0] preamble_gen;

reg [1:0] gmii16b_tx_en_int;
reg [15:0] gmii16b_tx_d_int;
reg [1:0] gmii16b_tx_err_int;
reg [1:0] gmii16b_tx_channel_int;

// Take in Avalon-ST data if it is valid and ready
always @(posedge clk)
begin
if (tx_ethfrm_ready)
    begin
    if (tx_ethfrm_valid)
        begin
        tx_ethfrm_data_reg <= tx_ethfrm_data;
        end
    else
        begin
        tx_ethfrm_data_reg <= 32'b0;
        end
    end    
end

always @(posedge clk)
begin
   if (~rst_n)
   begin
      tx_ethfrm_sop_reg <= 1'b0;
      tx_ethfrm_eop_reg <= 1'b0;
      tx_ethfrm_empty_reg <= 2'b0;
     
      tx_ethfrm_error_reg <= 4'b0;
      tx_ethfrm_valid_reg <= 4'b0;
      tx_ethfrm_channel_reg <= 2'b0;
   end
   else
   begin
   

      if (tx_ethfrm_ready)
      begin
         if (tx_ethfrm_valid)
         begin
            tx_ethfrm_sop_reg <= tx_ethfrm_sop;
            tx_ethfrm_eop_reg <= tx_ethfrm_eop;
           
            tx_ethfrm_empty_reg <= tx_ethfrm_empty;
            tx_ethfrm_channel_reg <= tx_ethfrm_channel;

            if (tx_ethfrm_eop)
            begin
               if (tx_ethfrm_empty == 4'd3)
               begin
                  tx_ethfrm_valid_reg <= 4'b1000;
                  tx_ethfrm_error_reg <= 4'b1000 & {tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error};
               end
               else if (tx_ethfrm_empty == 4'd2)
               begin
                  tx_ethfrm_valid_reg <= 4'b1100;
                  tx_ethfrm_error_reg <= 4'b1100 & {tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error};
               end
               else if (tx_ethfrm_empty == 4'd1)
               begin
                  tx_ethfrm_valid_reg <= 4'b1110;
                  tx_ethfrm_error_reg <= 4'b1110 & {tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error};
               end
               else
               begin
                  tx_ethfrm_valid_reg <= 4'b1111;
                  tx_ethfrm_error_reg <= {tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error};
               end
            end
            else
            begin
               tx_ethfrm_valid_reg <= 4'b1111;
               tx_ethfrm_error_reg <= {tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error, tx_ethfrm_error};
            end
         end
         else
         begin
            tx_ethfrm_sop_reg <= 1'b0;
            tx_ethfrm_eop_reg <= 1'b0;
            tx_ethfrm_empty_reg <= 2'b0;
           
            tx_ethfrm_error_reg <= 4'b0;
            tx_ethfrm_valid_reg <= 4'b0;
            tx_ethfrm_channel_reg <= 2'b0;
         end
      end
   end
 
end

// GMII DFA logic
generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      dfa_gmii16b_tx_sop <= 1'b0;
      dfa_gmii16b_tx_eop <= 1'b0;
      dfa_gmii16b_tx_en <= 2'b0;
      dfa_gmii16b_tx_d <= 16'b0;
      dfa_gmii16b_tx_err <= 2'b0;
      dfa_gmii16b_tx_channel <= 2'b0;
      data_even <= 1'b0;
   end
   else
   begin
 
    if (tx_clkena)
    begin
        if (~(ipg_backpressure & dfa_gmii16b_tx_sop))
        begin

            if (~data_even)
            begin
            dfa_gmii16b_tx_sop <= tx_ethfrm_sop_reg;
            dfa_gmii16b_tx_en <= {tx_ethfrm_valid_reg[2], tx_ethfrm_valid_reg[3]};
            dfa_gmii16b_tx_d <= {tx_ethfrm_data_reg[23:16], tx_ethfrm_data_reg[31:24]};
            dfa_gmii16b_tx_err <= {tx_ethfrm_error_reg[2], tx_ethfrm_error_reg[3]};
            dfa_gmii16b_tx_channel <= tx_ethfrm_channel_reg;

            if ((tx_ethfrm_empty_reg == 2'd3 || tx_ethfrm_empty_reg == 2'd2) && tx_ethfrm_eop_reg)
            begin
               dfa_gmii16b_tx_eop <= 1'b1;
            end
            else
            begin
               dfa_gmii16b_tx_eop <= 1'b0;
            end
         end
         else
         begin
            dfa_gmii16b_tx_sop <= 1'b0;
            dfa_gmii16b_tx_en <= {tx_ethfrm_valid_reg[0], tx_ethfrm_valid_reg[1]};
            dfa_gmii16b_tx_d <= {tx_ethfrm_data_reg[7:0], tx_ethfrm_data_reg[15:8]};
            dfa_gmii16b_tx_err <= {tx_ethfrm_error_reg[0], tx_ethfrm_error_reg[1]};
            dfa_gmii16b_tx_channel <= tx_ethfrm_channel_reg;

            if ((tx_ethfrm_empty_reg == 2'd1 || tx_ethfrm_empty_reg == 2'd0) && tx_ethfrm_eop_reg)
            begin
               dfa_gmii16b_tx_eop <= 1'b1;
            end
            else
            begin
               dfa_gmii16b_tx_eop <= 1'b0;
            end
         end

         data_even <= ~data_even;
      end
   end
end
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      dfa_gmii16b_tx_sop <= 1'b0;
      dfa_gmii16b_tx_eop <= 1'b0;
      dfa_gmii16b_tx_en <= 2'b0;
      dfa_gmii16b_tx_d <= 16'b0;
      dfa_gmii16b_tx_err <= 2'b0;
      dfa_gmii16b_tx_channel <= 2'b0;
      data_even <= 1'b0;
   end
   else
   begin
 
    if (tx_clkena)
    begin
        if (~(ipg_backpressure & dfa_gmii16b_tx_sop))
        begin

            if (~data_even)
            begin
            dfa_gmii16b_tx_sop <= tx_ethfrm_sop_reg;
            dfa_gmii16b_tx_en <= {tx_ethfrm_valid_reg[2], tx_ethfrm_valid_reg[3]};
            dfa_gmii16b_tx_d <= {tx_ethfrm_data_reg[23:16], tx_ethfrm_data_reg[31:24]};
            dfa_gmii16b_tx_err <= {tx_ethfrm_error_reg[2], tx_ethfrm_error_reg[3]};
            dfa_gmii16b_tx_channel <= tx_ethfrm_channel_reg;

            if ((tx_ethfrm_empty_reg == 2'd3 || tx_ethfrm_empty_reg == 2'd2) && tx_ethfrm_eop_reg)
            begin
               dfa_gmii16b_tx_eop <= 1'b1;
            end
            else
            begin
               dfa_gmii16b_tx_eop <= 1'b0;
            end
         end
         else
         begin
            dfa_gmii16b_tx_sop <= 1'b0;
            dfa_gmii16b_tx_en <= {tx_ethfrm_valid_reg[0], tx_ethfrm_valid_reg[1]};
            dfa_gmii16b_tx_d <= {tx_ethfrm_data_reg[7:0], tx_ethfrm_data_reg[15:8]};
            dfa_gmii16b_tx_err <= {tx_ethfrm_error_reg[0], tx_ethfrm_error_reg[1]};
            dfa_gmii16b_tx_channel <= tx_ethfrm_channel_reg;

            if ((tx_ethfrm_empty_reg == 2'd1 || tx_ethfrm_empty_reg == 2'd0) && tx_ethfrm_eop_reg)
            begin
               dfa_gmii16b_tx_eop <= 1'b1;
            end
            else
            begin
               dfa_gmii16b_tx_eop <= 1'b0;
            end
         end

         data_even <= ~data_even;
      end
   end
end
end
end
endgenerate

// Pipeline registers for GMII DFA logic output
generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      dfa_gmii16b_tx_en_d0 <= 2'b0;
      dfa_gmii16b_tx_d_d0 <= 16'b0;
      dfa_gmii16b_tx_err_d0 <= 2'b0;
      dfa_gmii16b_tx_channel_d0 <= 2'b0;

      dfa_gmii16b_tx_en_d1 <= 2'b0;
      dfa_gmii16b_tx_d_d1 <= 16'b0;
      dfa_gmii16b_tx_err_d1 <= 2'b0;
      dfa_gmii16b_tx_channel_d1 <= 2'b0;
   end
   else
   begin
    if(tx_clkena)
    begin
      if (ipg_done)
      begin
         if (dfa_gmii16b_tx_sop == 1'b1 && preamble_gen != 4'b0000)
         begin
            if (preamble_gen == 4'b0001)
            begin
               dfa_gmii16b_tx_en_d0 <= 2'b11;
               dfa_gmii16b_tx_d_d0 <= {SYM_SFD,SYM_PREAMBLE};
               dfa_gmii16b_tx_err_d0 <= 2'b00;
               dfa_gmii16b_tx_channel_d0 <= dfa_gmii16b_tx_channel;
            end
            else
            begin
               dfa_gmii16b_tx_en_d0 <= 2'b11;
               dfa_gmii16b_tx_d_d0 <= {SYM_PREAMBLE,SYM_PREAMBLE};
               dfa_gmii16b_tx_err_d0 <= 2'b00;
               dfa_gmii16b_tx_channel_d0 <= dfa_gmii16b_tx_channel;
            end
         end
         else
         begin
            dfa_gmii16b_tx_en_d0 <= dfa_gmii16b_tx_en;
            dfa_gmii16b_tx_d_d0 <= dfa_gmii16b_tx_d;
            dfa_gmii16b_tx_err_d0 <= dfa_gmii16b_tx_err;
            dfa_gmii16b_tx_channel_d0 <= dfa_gmii16b_tx_channel;
         end
      end
      else
      begin
         dfa_gmii16b_tx_en_d0 <= 2'b0;
         dfa_gmii16b_tx_d_d0 <= 16'b0;
         dfa_gmii16b_tx_err_d0 <= 2'b0;
         dfa_gmii16b_tx_channel_d0 <= 2'b0;
      end

      dfa_gmii16b_tx_en_d1 <= dfa_gmii16b_tx_en_d0;
      dfa_gmii16b_tx_d_d1 <= dfa_gmii16b_tx_d_d0;
      dfa_gmii16b_tx_err_d1 <= dfa_gmii16b_tx_err_d0;
      dfa_gmii16b_tx_channel_d1 <= dfa_gmii16b_tx_channel_d0;
end
   end
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      dfa_gmii16b_tx_en_d0 <= 2'b0;
      dfa_gmii16b_tx_d_d0 <= 16'b0;
      dfa_gmii16b_tx_err_d0 <= 2'b0;
      dfa_gmii16b_tx_channel_d0 <= 2'b0;

      dfa_gmii16b_tx_en_d1 <= 2'b0;
      dfa_gmii16b_tx_d_d1 <= 16'b0;
      dfa_gmii16b_tx_err_d1 <= 2'b0;
      dfa_gmii16b_tx_channel_d1 <= 2'b0;
   end
   else
   begin
    if(tx_clkena)
    begin
      if (ipg_done)
      begin
         if (dfa_gmii16b_tx_sop == 1'b1 && preamble_gen != 4'b0000)
         begin
            if (preamble_gen == 4'b0001)
            begin
               dfa_gmii16b_tx_en_d0 <= 2'b11;
               dfa_gmii16b_tx_d_d0 <= {SYM_SFD,SYM_PREAMBLE};
               dfa_gmii16b_tx_err_d0 <= 2'b00;
               dfa_gmii16b_tx_channel_d0 <= dfa_gmii16b_tx_channel;
            end
            else
            begin
               dfa_gmii16b_tx_en_d0 <= 2'b11;
               dfa_gmii16b_tx_d_d0 <= {SYM_PREAMBLE,SYM_PREAMBLE};
               dfa_gmii16b_tx_err_d0 <= 2'b00;
               dfa_gmii16b_tx_channel_d0 <= dfa_gmii16b_tx_channel;
            end
         end
         else
         begin
            dfa_gmii16b_tx_en_d0 <= dfa_gmii16b_tx_en;
            dfa_gmii16b_tx_d_d0 <= dfa_gmii16b_tx_d;
            dfa_gmii16b_tx_err_d0 <= dfa_gmii16b_tx_err;
            dfa_gmii16b_tx_channel_d0 <= dfa_gmii16b_tx_channel;
         end
      end
      else
      begin
         dfa_gmii16b_tx_en_d0 <= 2'b0;
         dfa_gmii16b_tx_d_d0 <= 16'b0;
         dfa_gmii16b_tx_err_d0 <= 2'b0;
         dfa_gmii16b_tx_channel_d0 <= 2'b0;
      end

      dfa_gmii16b_tx_en_d1 <= dfa_gmii16b_tx_en_d0;
      dfa_gmii16b_tx_d_d1 <= dfa_gmii16b_tx_d_d0;
      dfa_gmii16b_tx_err_d1 <= dfa_gmii16b_tx_err_d0;
      dfa_gmii16b_tx_channel_d1 <= dfa_gmii16b_tx_channel_d0;
end
   end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      preamble_gen <= 4'b1000;
   end
   else
   begin
    if(tx_clkena)
    begin
      if (dfa_gmii16b_tx_sop == 1'b1 && preamble_gen == 4'b0000)
         preamble_gen <= 4'b1000;
      else
         if (dfa_gmii16b_tx_sop == 1'b1 && preamble_gen != 4'b0000 && ipg_done == 1'b1)
         preamble_gen <= {1'b0, preamble_gen[3:1]};
    end
   end
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      preamble_gen <= 4'b1000;
   end
   else
   begin
    if(tx_clkena)
    begin
      if (dfa_gmii16b_tx_sop == 1'b1 && preamble_gen == 4'b0000)
         preamble_gen <= 4'b1000;
      else
         if (dfa_gmii16b_tx_sop == 1'b1 && preamble_gen != 4'b0000 && ipg_done == 1'b1)
         preamble_gen <= {1'b0, preamble_gen[3:1]};
    end
   end
end
end
endgenerate

always @(*)
begin
  
 tx_ethfrm_ready = ~(ipg_backpressure & dfa_gmii16b_tx_sop) & data_even & tx_clkena;
  
   
end

always @(*)
begin
   if ((ipg_value_1g[0] && ipg_count[0]) || // ipg_value_1g and ipg_count are odd numbers
      (~ipg_value_1g[0] & ~ipg_count[0]))   // ipg_value_1g and ipg_count are even numbers
   begin
      if (ipg_count >= ipg_value_1g)
      begin
         ipg_done = 1'b1;
         data_select_next = data_select;
      end
      else
      begin
         ipg_done = 1'b0;
         data_select_next = data_select;
      end
   end
   else
   begin
      if ((data_select && (ipg_count >= ipg_value_1g + 8'd1)) || // already shifted, thus backpressure 1 clock late (+2) and don't shift (-1) = +1
         (~data_select && (ipg_count >= ipg_value_1g - 8'd1)))   // not shifted yet, thus backpressure like normal (+0) and shift +1 = (+1)
      begin
         ipg_done = 1'b1;

         if (ipg_done & ipg_needed)
            data_select_next = ~data_select;
         else
            data_select_next = data_select;
      end
      else
      begin
         ipg_done = 1'b0;
         data_select_next = data_select;
      end
   end
end

generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      data_select <= 1'b0;
      ipg_needed <= 1'b0;
   end
   else
   begin
    if(tx_clkena)
    begin
      data_select <= data_select_next;
      if (dfa_gmii16b_tx_eop)
         ipg_needed <= 1'b1;
      else if (ipg_done)
         ipg_needed <= 1'b0;
    end
   end
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      data_select <= 1'b0;
      ipg_needed <= 1'b0;
   end
   else
   begin
    if(tx_clkena)
    begin
      data_select <= data_select_next;
      if (dfa_gmii16b_tx_eop)
         ipg_needed <= 1'b1;
      else if (ipg_done)
         ipg_needed <= 1'b0;
    end
   end
end
end
endgenerate

always @(*)
begin

   if ((dfa_gmii16b_tx_sop == 1'b1 && preamble_gen != 4'b0000) || // PREAMBLE and SFD
      (ipg_needed == 1'b1 && ipg_done == 1'b0))                // IPG
      ipg_backpressure = 1'b1;
   else
      ipg_backpressure = 1'b0;
end

generate if (SYNC_RESET_N == 1) begin
always @(posedge clk)
begin
   if (~rst_n)
   begin
      ipg_count <= 8'h0;
   end
   else
   begin
    if(tx_clkena)
    begin
      if (dfa_gmii16b_tx_eop)
      begin
         if (dfa_gmii16b_tx_en != 2'b11)
            ipg_count <= 8'd1;
         else
            ipg_count <= 8'd0;
      end
      else if (ipg_count < ipg_value_1g)
      begin
         ipg_count <= ipg_count + 8'd2;
      end
    end
   end
end
end else begin
always @(posedge clk or negedge rst_n)
begin
   if (~rst_n)
   begin
      ipg_count <= 8'h0;
   end
   else
   begin
    if(tx_clkena)
    begin
      if (dfa_gmii16b_tx_eop)
      begin
         if (dfa_gmii16b_tx_en != 2'b11)
            ipg_count <= 8'd1;
         else
            ipg_count <= 8'd0;
      end
      else if (ipg_count < ipg_value_1g)
      begin
         ipg_count <= ipg_count + 8'd2;
      end
    end
   end
end
end
endgenerate


always @(*)
begin


   if (data_select == 1'b0)
   begin
      gmii16b_tx_en_int = dfa_gmii16b_tx_en_d0;
      gmii16b_tx_d_int = dfa_gmii16b_tx_d_d0;
      gmii16b_tx_err_int = dfa_gmii16b_tx_err_d0;
      gmii16b_tx_channel_int = dfa_gmii16b_tx_channel_d0;
   end
   else
   begin
      gmii16b_tx_en_int = {dfa_gmii16b_tx_en_d0[0], dfa_gmii16b_tx_en_d1[1]};
      gmii16b_tx_d_int = {dfa_gmii16b_tx_d_d0[7:0], dfa_gmii16b_tx_d_d1[15:8]};
      gmii16b_tx_err_int = {dfa_gmii16b_tx_err_d0[0], dfa_gmii16b_tx_err_d1[1]};
      gmii16b_tx_channel_int = dfa_gmii16b_tx_channel_d0;
   end
end
//end
always @(*)
begin
   gmii16b_tx_en = gmii16b_tx_en_int;
   gmii16b_tx_d = gmii16b_tx_d_int;
   gmii16b_tx_err = gmii16b_tx_err_int;
   gmii16b_tx_channel = gmii16b_tx_channel_int;
end

endmodule
