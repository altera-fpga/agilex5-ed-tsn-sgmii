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

module alt_em10g32_avalon_dc_fifo_lat_calc # (
    parameter ADDR_WIDTH  = 5,
    parameter SYNC_DEPTH  = 3,
    parameter SYNC_RESET_N = 1
) (
    input                  wr_clk,
    input                  reset_wr_clk_n,
    
    input                  rd_clk,
    input                  reset_rd_clk_n,
    
    input                  sampling_clk, // 257 MHz clock from 10GBASE-R PHY
    input                  reset_sampling_clk_n,
    
    input                  latency_out_clk, // RX: wr_clk, TX: rd_clk, 156.25 MHz for easier timing closure
    input                  reset_latency_out_clk_n,
    
    input [ADDR_WIDTH-1:0] rd_ptr,
    input [ADDR_WIDTH-1:0] wr_ptr,
    
    output reg [ADDR_WIDTH+10-1:0] latency_out // Upper bits: cycle, lower 10-bits fractional cycles
);
    
    localparam SAMPLE_SIZE  = 33; // The only supported size
    localparam COUNTER_SIZE = 6; // To support sample size of 33
    localparam ACCUM_SIZE   = 10; // To support sample size of 33
    
    localparam FIFO_FRAC_WIDTH = 10; // Fractional cycle is 10-bits
    localparam LAT_ADJ_WIDTH = ADDR_WIDTH + FIFO_FRAC_WIDTH;
    
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
    reg  [ADDR_WIDTH-1:0] wr_ptr_sample /*synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=D102" */;
    reg  [ADDR_WIDTH-1:0] rd_ptr_sample /*synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=D102" */;
    wire [ADDR_WIDTH-1:0] wr_ptr_sync;
    wire [ADDR_WIDTH-1:0] rd_ptr_sync;
    
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge wr_clk) begin
        if (!reset_wr_clk_n) begin
            wr_ptr_sample <= {ADDR_WIDTH{1'b0}};
        end
        else begin
            wr_ptr_sample <= wr_ptr;
        end
    end
    
    always @(posedge rd_clk) begin
        if (!reset_rd_clk_n) begin
            rd_ptr_sample <= {ADDR_WIDTH{1'b0}};
        end
        else begin
            rd_ptr_sample <= rd_ptr;
        end
    end
  end else begin
    always @(posedge wr_clk or negedge reset_wr_clk_n) begin
        if (!reset_wr_clk_n) begin
            wr_ptr_sample <= {ADDR_WIDTH{1'b0}};
        end
        else begin
            wr_ptr_sample <= wr_ptr;
        end
    end
    
    always @(posedge rd_clk or negedge reset_rd_clk_n) begin
        if (!reset_rd_clk_n) begin
            rd_ptr_sample <= {ADDR_WIDTH{1'b0}};
        end
        else begin
            rd_ptr_sample <= rd_ptr;
        end
    end
  end
  endgenerate
    
    alt_em10g32_dcfifo_synchronizer_bundle #(
        .WIDTH      (ADDR_WIDTH),
        .DEPTH      (SYNC_DEPTH)
    ) wr_crosser (
        .clk        (sampling_clk),
        .reset_n    (reset_sampling_clk_n),
        .din        (wr_ptr_sample),
        .dout       (wr_ptr_sync)
    );
    
    alt_em10g32_dcfifo_synchronizer_bundle #(
        .WIDTH      (ADDR_WIDTH),
        .DEPTH      (SYNC_DEPTH)
    ) rd_crosser (
        .clk        (sampling_clk),
        .reset_n    (reset_sampling_clk_n),
        .din        (rd_ptr_sample),
        .dout       (rd_ptr_sync)
    );
    
    // sampling_clk domain
    reg  [COUNTER_SIZE-1:0]  numdata_index;
    reg  [ADDR_WIDTH-1:0]    numdata;
    
    reg                      accum_done;
    reg  [ACCUM_SIZE-1:0]    latency_accum;
    
    reg                      avg_calc_done;
    reg  [LAT_ADJ_WIDTH+20-1:0] latency_avg;
    
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge sampling_clk) begin
        if (!reset_sampling_clk_n) begin
            numdata_index       <= {COUNTER_SIZE{1'b0}};
            numdata             <= {ADDR_WIDTH{1'b0}};
            
            accum_done          <= 1'b0;
            latency_accum       <= {ACCUM_SIZE{1'b0}};
            
            avg_calc_done       <= 1'b0;
            latency_avg         <= {(LAT_ADJ_WIDTH+20){1'b0}};
        end
        else begin
            
            numdata <= gray_to_bin(wr_ptr_sync) - gray_to_bin(rd_ptr_sync);
            
            if (numdata_index == SAMPLE_SIZE - 1) begin
                accum_done      <= 1'b1;
                numdata_index   <= {COUNTER_SIZE{1'b0}};
            end
            else begin
                accum_done      <= 1'b0;
                numdata_index   <= numdata_index + {{(COUNTER_SIZE-1){1'b0}}, 1'b1};
            end
            
            latency_accum <= (numdata_index == {COUNTER_SIZE{1'b0}}) ? numdata : (latency_accum + numdata);
            avg_calc_done <= accum_done;
            
            if(accum_done) begin
                latency_avg <= (((latency_accum << (10+FIFO_FRAC_WIDTH)) - ((latency_accum << (5+FIFO_FRAC_WIDTH)) - (latency_accum << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                                 >> 15); // divide by 32768
            end
        end
    end
  end else begin
    always @(posedge sampling_clk or negedge reset_sampling_clk_n) begin
        if (!reset_sampling_clk_n) begin
            numdata_index       <= {COUNTER_SIZE{1'b0}};
            numdata             <= {ADDR_WIDTH{1'b0}};
            
            accum_done          <= 1'b0;
            latency_accum       <= {ACCUM_SIZE{1'b0}};
            
            avg_calc_done       <= 1'b0;
            latency_avg         <= {(LAT_ADJ_WIDTH+20){1'b0}};
        end
        else begin
            
            numdata <= gray_to_bin(wr_ptr_sync) - gray_to_bin(rd_ptr_sync);
            
            if (numdata_index == SAMPLE_SIZE - 1) begin
                accum_done      <= 1'b1;
                numdata_index   <= {COUNTER_SIZE{1'b0}};
            end
            else begin
                accum_done      <= 1'b0;
                numdata_index   <= numdata_index + {{(COUNTER_SIZE-1){1'b0}}, 1'b1};
            end
            
            latency_accum <= (numdata_index == {COUNTER_SIZE{1'b0}}) ? numdata : (latency_accum + numdata);
            
            // Rather than divide by 33...
            // 1/33 ~= 993/32768 ~= (1024 - 31)/32768
            // error = 0.0000009x, where x = accum. fill level = avg. fill level * 33
            // max fill level = 16  ==>  max error = 0.0004752cycle / 3.04128 ps (negligible)
            avg_calc_done <= accum_done;
            
            if(accum_done) begin
                latency_avg <= (((latency_accum << (10+FIFO_FRAC_WIDTH)) - ((latency_accum << (5+FIFO_FRAC_WIDTH)) - (latency_accum << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                                 >> 15); // divide by 32768
            end
        end
    end
  end
  endgenerate
    
    // latency_out_clk domain (RX: wr_clk, TX: rd_clk)
    wire                     latency_accum_val;
    wire [LAT_ADJ_WIDTH-1:0] latency_accum_out;
    
    alt_em10g32_clock_crosser #(
        .SYMBOLS_PER_BEAT   (1),
        .BITS_PER_SYMBOL    (LAT_ADJ_WIDTH),
        .FORWARD_SYNC_DEPTH (SYNC_DEPTH),
        .BACKWARD_SYNC_DEPTH(SYNC_DEPTH),
        .USE_OUTPUT_PIPELINE(0)
    ) path_delay_transfer (
        .in_clk     (sampling_clk),
        .in_reset_n (reset_sampling_clk_n),
        .in_ready   (), // Assumption: round trip clock crossing takes less than 33 sampling clock cycle, thus ready not used to keep input data stable
        .in_valid   (avg_calc_done),
        .in_data    (latency_avg[LAT_ADJ_WIDTH-1:0]),
        
        .out_clk    (latency_out_clk),
        .out_reset_n(reset_latency_out_clk_n),
        .out_ready  (1'b1),
        .out_valid  (latency_accum_val),
        .out_data   (latency_accum_out)
    );
    
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge latency_out_clk) begin
        if (!reset_latency_out_clk_n) begin
            latency_out <= {LAT_ADJ_WIDTH{1'b0}};
        end else begin
            if (latency_accum_val) begin
                latency_out <= latency_accum_out;
            end else begin
                latency_out <= latency_out;
            end
        end
    end
  end else begin
    always @(posedge latency_out_clk or negedge reset_latency_out_clk_n) begin
        if (!reset_latency_out_clk_n) begin
            latency_out <= {LAT_ADJ_WIDTH{1'b0}};
        end else begin
            if (latency_accum_val) begin
                latency_out <= latency_accum_out;
            end else begin
                latency_out <= latency_out;
            end
        end
    end
  end
  endgenerate

endmodule
