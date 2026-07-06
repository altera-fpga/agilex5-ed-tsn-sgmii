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
(*altera_attribute = {"SUPPRESS_DA_RULE_INTERNAL=\"D102\"" } *)
module alt_mge16_pcs_ph_calculator # (
  parameter ADDR_WIDTH  = 5,
  parameter SAMPLE_SIZE = 64
) (
  input                  rd_clk,
  input                  reset_rd_clk,
  input                  wr_clk,
  input                  reset_wr_clk,
  input                  calc_clk,
  input                  reset_calc_clk,
  input                  clk_125,
  input                  reset_clk_125,
  input [ADDR_WIDTH-1:0] rd_ptr,
  input [ADDR_WIDTH-1:0] wr_ptr,
  output reg [11:0]      latency_adj
);

    localparam sync_stages   = 2;
    
    // Graycode to binary conversion
    function [ADDR_WIDTH-1:0] gray_to_bin;
        input [ADDR_WIDTH-1:0] gray;
        integer i;
        begin
           gray_to_bin[ADDR_WIDTH-1] = gray[ADDR_WIDTH-1];
           for (i=ADDR_WIDTH-2; i>=0; i=i-1)
           begin: gry_to_bin
                   gray_to_bin[i] = gray_to_bin[i+1] ^ gray[i];
           end
        end
    endfunction

    // Read and write pointers from read and write clock domains
    // manually synchronize instead of using synchronizer_bundle to get recognized signal name
    reg [ADDR_WIDTH-1:0] wr_ptr_sample;
    reg [ADDR_WIDTH-1:0] rd_ptr_sample;
    reg [ADDR_WIDTH-1:0] sync_wr_ptr;
    reg [ADDR_WIDTH-1:0] sync_rd_ptr;
	 
    always @ (posedge rd_clk or posedge reset_rd_clk) begin
        if (reset_rd_clk) begin
            rd_ptr_sample <= {ADDR_WIDTH{1'b0}};
        end
        else begin
            rd_ptr_sample <= rd_ptr;
        end
    end

    always @ (posedge wr_clk or posedge reset_wr_clk) begin
        if (reset_wr_clk) begin
            wr_ptr_sample <= {ADDR_WIDTH{1'b0}};
        end
        else begin
            wr_ptr_sample <= wr_ptr;
        end
    end
    
    alt_mge_phy_std_synchronizer_bundle #(
        .width(ADDR_WIDTH),
        .depth(sync_stages)
    ) rd_ptr_sync (
        .clk        (calc_clk),
        .reset_n    (~reset_calc_clk),
        .din        (rd_ptr_sample),
        .dout       (sync_rd_ptr)
    );
    
    alt_mge_phy_std_synchronizer_bundle #(
        .width(ADDR_WIDTH),
        .depth(sync_stages)
    ) wr_ptr_sync (
        .clk        (calc_clk),
        .reset_n    (~reset_calc_clk),
        .din        (wr_ptr_sample),
        .dout       (sync_wr_ptr)
    );
    
    // calc_clk domain
    reg valid;
    reg [6:0] numdata_index, numdata_index_reg;
    reg [ADDR_WIDTH-1:0] numdata_q[63:0];
    reg [ADDR_WIDTH-1:0] numdata;
    reg [ADDR_WIDTH-1:0] numdata_reg;
    reg [11:0] latency_accum;

    always @ (posedge calc_clk or posedge reset_calc_clk) begin
        if (reset_calc_clk) begin
            valid <= 1'b0;
            numdata_index <= 7'd0;
            numdata_index_reg <= 7'd1;
            numdata_q <= '{SAMPLE_SIZE{1'b0}};
            numdata <= {ADDR_WIDTH{1'b0}};
            numdata_reg <= {ADDR_WIDTH{1'b0}};
            latency_accum <= {12{1'b0}};
        end
        else begin
            numdata     <= gray_to_bin(sync_wr_ptr)-gray_to_bin(sync_rd_ptr);
                
            if (numdata_index == SAMPLE_SIZE-1) begin
                valid <= 1'b1;
                numdata_index <= 7'd0;
                numdata_index_reg <= 7'd1;
                numdata_reg <= numdata_q[0];
            end
            else begin
                valid <= valid;
                numdata_index <= numdata_index + 7'd1;
                numdata_index_reg <= numdata_index + 7'd2;
                if (valid)
                    numdata_reg <= numdata_q[numdata_index_reg];
                else
                    numdata_reg <= {ADDR_WIDTH{1'b0}};
            end

            numdata_q[numdata_index] <= numdata;
            latency_accum <= (latency_accum + numdata) - numdata_reg;
        end
    end

        
   // clk_125 domain (RX: rd_clk, TX: wr_clk)
   reg [11:0] latency_accum_out;
   wire latency_accum_val;  
   
    alt_mge16_pcs_clock_crosser // 5-rd_clk cycles
      #(.BITS_PER_SYMBOL(12))
    path_delay_transfer(.in_clk(calc_clk),
                   .in_reset(reset_calc_clk),
                   .in_ready(),
                   .in_valid(valid),
                   .in_data(latency_accum),
                   .out_clk(clk_125),
                   .out_reset(reset_clk_125),
                   .out_ready(1'b1),
                   .out_valid(latency_accum_val),
                   .out_data(latency_accum_out));

    always @ (posedge clk_125 or posedge reset_clk_125) begin
        if (reset_clk_125) begin
            latency_adj <= {12{1'b0}};
        end else begin      
            if (latency_accum_val) begin
            // <<6 for 6-bit fractional
            // >>6 to divide by 64 (sample size)
            // shifting are canceled off
                latency_adj <= latency_accum_out;
            end else begin
                latency_adj <= latency_adj;
            end        
        end
    end
       
endmodule
