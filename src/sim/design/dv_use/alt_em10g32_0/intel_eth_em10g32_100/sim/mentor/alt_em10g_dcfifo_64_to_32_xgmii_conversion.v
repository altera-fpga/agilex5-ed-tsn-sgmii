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


`timescale 1ps/1ps

// This is the module that converts the XGMII
// interface from slow clock domain to fast clock domain
// Please ensure that the fast and slow clock relationship
// has 0 phase difference and 
// the frequency of fast clock is 2x of slow clock
module alt_em10g_dcfifo_64_to_32_xgmii_conversion
(
   // Slow clock and reset (156.25 MHz)
   input  wire          clk_xgmii_in,
   input  wire          reset_xgmii_in_n,
   
   // Fast clock and reset (312.25 MHz)
   input  wire          clk_xgmii_out,
   input  wire          reset_xgmii_out_n,

   // XGMII data and control in slow clock domain
   input  wire [63:0]   xgmii_data_in,
   input  wire [7:0]    xgmii_control_in,

   // XGMII data and control in fast clock domain
   output reg  [31:0]   xgmii_data_out,
   output reg  [3:0]    xgmii_control_out,

   // 1588 related signals
   input  wire [15:0]   xgmii_rx_path_latency,
   output reg  [16:0]   st_rx_path_latency,
   output reg           phase,
   
   // Latency Measurement
   input  wire          sampling_clk,
   input  wire          sampling_clk_reset_n
);
parameter SYNC_RESET_N        = 1;
localparam SYM_IDLE           = 8'h07;

reg [63:0] xgmii_data_in_reg;
reg [7:0] xgmii_control_in_reg;

reg conversion_ready;

wire [71+17:0] fifo_data_in;
wire [71+17:0] fifo_data_out;

wire fifo_almost_empty;
reg fifo_rd_req;

reg  [15:0] measured_path_latency;
wire [14:0] fifo_latency;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Phase detection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

generate if (SYNC_RESET_N == 1) begin
  always @(posedge clk_xgmii_out)
  begin
     if (~reset_xgmii_out_n)
     begin
        phase <= 1'b0;
        conversion_ready <= 1'b0;
  
        fifo_rd_req <= 1'b0;
     end
     else
     begin
        if (~fifo_almost_empty) begin
           conversion_ready <= 1'b1;
        end
  
        if (conversion_ready) begin
           phase <= ~phase;
        end
  
        fifo_rd_req <= (conversion_ready & phase);
     end
  end
end else begin
  always @(posedge clk_xgmii_out or negedge reset_xgmii_out_n)
  begin
     if (~reset_xgmii_out_n)
     begin
        phase <= 1'b0;
        conversion_ready <= 1'b0;
  
        fifo_rd_req <= 1'b0;
     end
     else
     begin
        if (~fifo_almost_empty) begin
           conversion_ready <= 1'b1;
        end
  
        if (conversion_ready) begin
           phase <= ~phase;
        end
  
        fifo_rd_req <= (conversion_ready & phase);
     end
  end
end
endgenerate

assign fifo_data_in = {measured_path_latency[15:0], 1'b0, xgmii_control_in_reg, xgmii_data_in_reg};

alt_em10g32_avalon_dc_fifo #(
    .SYMBOLS_PER_BEAT           (1),
    .BITS_PER_SYMBOL            (64 + 8 + 17),
    .FIFO_DEPTH                 (16),
    .ERROR_WIDTH                (0),
    .USE_PACKETS                (0),
    .STREAM_ALMOST_EMPTY        (1),
    .WR_SYNC_DEPTH              (3), // Changing this would impact latency measurement
    .RD_SYNC_DEPTH              (3), // Measurement need to redo if changed
    .SYNC_RESET_N               (SYNC_RESET_N)
) data_path_fifo (
    
    .in_clk                     (clk_xgmii_in),
    .in_reset_n                 (reset_xgmii_in_n),
    
    .out_clk                    (clk_xgmii_out),
    .out_reset_n                (reset_xgmii_out_n),
    
    // sink
    .in_data                    (fifo_data_in),
    .in_valid                   (1'b1),
    .in_ready                   (),
    .in_startofpacket           (1'b0),
    .in_endofpacket             (1'b0),
    .in_empty                   (1'b0),
    .in_error                   (1'b0),
    .in_channel                 (1'b0),
    
    // source
    .out_data                   (fifo_data_out),
    .out_valid                  (), // Qualified properly by almost_empty and FIFO read
    .out_ready                  (fifo_rd_req),
    .out_startofpacket          (),
    .out_endofpacket            (),
    .out_empty                  (),
    .out_error                  (),
    .out_channel                (),
    
    // streaming in status
    .almost_full_valid          (),
    .almost_full_data           (),
    
    // streaming out status
    .almost_empty_valid         (),
    .almost_empty_data          (fifo_almost_empty),
    
    // in clock
    .in_fill_level              (),
    .almost_full_threshold      (5'd10),
    
    // out clock
    .out_fill_level             (),
    .almost_empty_threshold     (5'd2),
    
    .space_avail_data           (),
    
    // Latency Measurement
    .sampling_clk               (sampling_clk),
    .sampling_clk_reset_n       (sampling_clk_reset_n),
    
    .latency_out_clk            (clk_xgmii_in),
    .latency_out_clk_reset_n    (reset_xgmii_in_n),
    
    .latency_out                (fifo_latency)

);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data Path
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

generate if (SYNC_RESET_N == 1) begin
  // NON_RESETABLE FLOPS
  // Latching xgmii_data_in and xgmii_control_in in slow clock domain
  always @ (posedge clk_xgmii_in)
  begin
     if (~reset_xgmii_in_n)
     begin
        xgmii_data_in_reg <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
        xgmii_control_in_reg <= 4'hF;
     end
     else
     begin
        xgmii_data_in_reg <= xgmii_data_in;
        xgmii_control_in_reg <= xgmii_control_in;
     end
  end
  
  always @ (posedge clk_xgmii_in)
  begin
     if (~reset_xgmii_in_n)
     begin
        measured_path_latency <= 16'h0;
     end
     else
     begin
        measured_path_latency <= xgmii_rx_path_latency + fifo_latency;
     end
  end
  
  // xgmii_data_out and xgmii_control_out mux
  // Clock crossing from clk_xgmii_in to clk_xgmii_out
  always @ (posedge clk_xgmii_out)
  begin
     if (~reset_xgmii_out_n)
     begin
        xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
        xgmii_control_out <= 4'hF;
        st_rx_path_latency <= 17'h0;
     end
     else
     begin
        if (~conversion_ready)
        begin
           xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
           xgmii_control_out <= 4'hF;
           st_rx_path_latency <= 17'h0;
        end
        else
        begin
           if (phase)
           begin
              xgmii_control_out <= fifo_data_out [67:64];
              xgmii_data_out <= fifo_data_out [31:0];
           end
           else
           begin
              xgmii_control_out <= fifo_data_out [71:68];
              xgmii_data_out <= fifo_data_out [63:32];
           end
           
           st_rx_path_latency <= fifo_data_out[88:72];
        end
     end
  end
end else begin
  // NON_RESETABLE FLOPS
  // Latching xgmii_data_in and xgmii_control_in in slow clock domain
  always @ (posedge clk_xgmii_in or negedge reset_xgmii_in_n)
  begin
     if (~reset_xgmii_in_n)
     begin
        xgmii_data_in_reg <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
        xgmii_control_in_reg <= 4'hF;
     end
     else
     begin
        xgmii_data_in_reg <= xgmii_data_in;
        xgmii_control_in_reg <= xgmii_control_in;
     end
  end
  
  always @ (posedge clk_xgmii_in or negedge reset_xgmii_in_n)
  begin
     if (~reset_xgmii_in_n)
     begin
        measured_path_latency <= 16'h0;
     end
     else
     begin
        measured_path_latency <= xgmii_rx_path_latency + fifo_latency;
     end
  end
  
  // xgmii_data_out and xgmii_control_out mux
  // Clock crossing from clk_xgmii_in to clk_xgmii_out
  always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
  begin
     if (~reset_xgmii_out_n)
     begin
        xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
        xgmii_control_out <= 4'hF;
        st_rx_path_latency <= 17'h0;
     end
     else
     begin
        if (~conversion_ready)
        begin
           xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
           xgmii_control_out <= 4'hF;
           st_rx_path_latency <= 17'h0;
        end
        else
        begin
           if (phase)
           begin
              xgmii_control_out <= fifo_data_out [67:64];
              xgmii_data_out <= fifo_data_out [31:0];
           end
           else
           begin
              xgmii_control_out <= fifo_data_out [71:68];
              xgmii_data_out <= fifo_data_out [63:32];
           end
           
           st_rx_path_latency <= fifo_data_out[88:72];
        end
     end
  end
end
endgenerate

endmodule
