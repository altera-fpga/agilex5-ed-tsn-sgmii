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


`timescale 1 ps / 1 ps
module alt_em10g32_rst_cnt #(
   parameter RESET_SYNC_DEPTH    = 4,
   parameter SYNC_RESET_N        = 1,
   parameter RESET_COUNT         = 32
) (
   input    wire  clk,
   input    wire  rst_n_in,
   output   reg   rst_n_out /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R105" */
);

   localparam COUNT_VAL = RESET_COUNT - 1;
   localparam COUNT_WIDTH = log2ceil (COUNT_VAL);
   localparam COUNT_WIDTH_MINUS_ONE = COUNT_WIDTH - 1;


   wire  rst_in;
   wire  rst_in_sync;

   reg   [COUNT_WIDTH_MINUS_ONE:0] reset_count;

   reg   rst_n_out_int;

   // Invert reset polarity
   assign rst_in = ~rst_n_in;
   
   // Synchronized the reset input
   alt_em10g32_reset_synchronizer # (
      .ASYNC_RESET(1),
      .DEPTH      (RESET_SYNC_DEPTH)  
   ) reset_synchronizer_inst(
      .clk(clk),
      .reset_in(rst_in),
      .reset_out(rst_in_sync)
   );

   // Reset counter
   generate if (SYNC_RESET_N == 1) begin
   always @(posedge clk)
   begin
      if (rst_in_sync)
      begin
         reset_count <= COUNT_VAL[COUNT_WIDTH_MINUS_ONE:0];
      end
      else
      begin
         if (reset_count != {COUNT_WIDTH{1'b0}})
         begin
            reset_count <= reset_count - {{COUNT_WIDTH_MINUS_ONE{1'b0}},1'b1};
         end
      end
   end

   // Reset output based on reset_count value
   always @(posedge clk)
   begin
      if (rst_in_sync)
      begin
         rst_n_out_int <= 1'b0;
      end
      else
      begin
         if (reset_count == {COUNT_WIDTH{1'b0}})
         begin
            rst_n_out_int <= 1'b1;
         end
      end
   end

   // Flop the reset output
   always @(posedge clk)
   begin
      if (rst_in_sync)
      begin
         rst_n_out <= 1'b0;
      end
      else
      begin
         rst_n_out <= rst_n_out_int;
      end
   end
   end else begin
   always @(posedge clk or posedge rst_in_sync)
   begin
      if (rst_in_sync)
      begin
         reset_count <= COUNT_VAL[COUNT_WIDTH_MINUS_ONE:0];
      end
      else
      begin
         if (reset_count != {COUNT_WIDTH{1'b0}})
         begin
            reset_count <= reset_count - {{COUNT_WIDTH_MINUS_ONE{1'b0}},1'b1};
         end
      end
   end

   // Reset output based on reset_count value
   always @(posedge clk or posedge rst_in_sync)
   begin
      if (rst_in_sync)
      begin
         rst_n_out_int <= 1'b0;
      end
      else
      begin
         if (reset_count == {COUNT_WIDTH{1'b0}})
         begin
            rst_n_out_int <= 1'b1;
         end
      end
   end

   // Flop the reset output
   always @(posedge clk or posedge rst_in_sync)
   begin
      if (rst_in_sync)
      begin
         rst_n_out <= 1'b0;
      end
      else
      begin
         rst_n_out <= rst_n_out_int;
      end
   end
   end
   endgenerate

   // --------------------------------------------------
   // Calculates the log2ceil of the input value
   // --------------------------------------------------
   function integer log2ceil;
      input integer val;
      integer i;

      begin
         i = 1;
         log2ceil = 0;
            while (i < val) begin
               log2ceil = log2ceil + 1;
               i = i << 1; 
            end
      end
   endfunction
endmodule
