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
module alt_em10g_dcfifo_32_to_64_xgmii_conversion
(
   // Fast clock and reset (312.5 MHz)
   input  wire          clk_xgmii_in,
   input  wire          reset_xgmii_in_n,
   
   // Slow clock and reset (156.25 MHz)
   input  wire          clk_xgmii_out,
   input  wire          reset_xgmii_out_n,

   // XGMII data and control in fast clock domain
   input  wire [31:0]   xgmii_data_in,
   input  wire [3:0]    xgmii_control_in,

   // XGMII data and control in slow clock domain
   output reg  [63:0]   xgmii_data_out,
   output reg  [7:0]    xgmii_control_out,

   // 1588 related signals
   input  wire [15:0]   xgmii_tx_path_latency,
   output wire [16:0]   st_tx_path_latency,
   output reg           phase,
   
   // Latency Measurement
   input  wire          sampling_clk,
   input  wire          sampling_clk_reset_n
);

parameter SYNC_RESET_N        = 1;
localparam SYM_IDLE           = 8'h07;

reg [31:0] xgmii_data_in_reg;
reg [3:0] xgmii_control_in_reg;

reg [3:0] write_wait;
reg conversion_ready;

reg [71:0] fifo_data_in;
wire [71:0] fifo_data_out;

wire fifo_almost_empty;
reg fifo_rd_req;

wire [14:0] fifo_latency;

reg [4:0] transfer_valid_slow;
reg [2:0] transfer_valid_fast /* synthesis altera_attribute="suppress_da_rule_internal=\"D101,D102\"" */;

reg [15:0] xgmii_tx_path_latency_slow;
reg [16:0] xgmii_tx_path_latency_fast /* synthesis altera_attribute="suppress_da_rule_internal=\"D101,D102\"" */;
reg [16:0] xgmii_tx_path_latency_fast_2;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Phase detection
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk_xgmii_in or negedge reset_xgmii_in_n)
    begin
       if (~reset_xgmii_in_n)
       begin
          write_wait <= 4'b1000;
          conversion_ready <= 1'b0;
          phase <= 1'b0;
          fifo_data_in <= {8'hFF, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
       end
       else
       begin
          write_wait[3:0] <= {1'b0, write_wait[3:1]}; // Delay write to minimize latency (due to rst_156 deasserted later than rst_312), delay must be lower than MAC latency which is 7 cycles
          
          if(write_wait[0]) begin
             conversion_ready <= 1'b1;
          end
          
          if (conversion_ready)
          begin
             phase <= ~phase;
          end
    
          if (phase)
          begin
             fifo_data_in <= {xgmii_control_in, xgmii_control_in_reg, xgmii_data_in, xgmii_data_in_reg};
          end
       end
    end
  end else begin
    always @(posedge clk_xgmii_in or negedge reset_xgmii_in_n)
    begin
       if (~reset_xgmii_in_n)
       begin
          write_wait <= 4'b1000;
          conversion_ready <= 1'b0;
          phase <= 1'b0;
          fifo_data_in <= {8'hFF, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
       end
       else
       begin
          write_wait[3:0] <= {1'b0, write_wait[3:1]}; // Delay write to minimize latency (due to rst_156 deasserted later than rst_312), delay must be lower than MAC latency which is 7 cycles
          
          if(write_wait[0]) begin
             conversion_ready <= 1'b1;
          end
          
          if (conversion_ready)
          begin
             phase <= ~phase;
          end
    
          if (phase)
          begin
             fifo_data_in <= {xgmii_control_in, xgmii_control_in_reg, xgmii_data_in, xgmii_data_in_reg};
          end
       end
    end
  end
  endgenerate

alt_em10g32_avalon_dc_fifo #(
    .SYMBOLS_PER_BEAT           (1),
    .BITS_PER_SYMBOL            (64 + 8),
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
    .in_valid                   (conversion_ready & ~phase),
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
    
    .latency_out_clk            (clk_xgmii_out),
    .latency_out_clk_reset_n    (reset_xgmii_out_n),
    
    .latency_out                (fifo_latency)

);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Data Path
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  generate if (SYNC_RESET_N == 1) begin
    always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
    begin
       if (~reset_xgmii_out_n)
       begin
          xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
          xgmii_control_out <= 8'hFF;
       end
       else
       begin
          if (fifo_rd_req)
          begin
             {xgmii_control_out, xgmii_data_out} <= fifo_data_out;
          end
          else
          begin
             xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
             xgmii_control_out <= 8'hFF;
          end
       end
    end
  end else begin
    always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
    begin
       if (~reset_xgmii_out_n)
       begin
          xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
          xgmii_control_out <= 8'hFF;
       end
       else
       begin
          if (fifo_rd_req)
          begin
             {xgmii_control_out, xgmii_data_out} <= fifo_data_out;
          end
          else
          begin
             xgmii_data_out <= {SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE, SYM_IDLE};
             xgmii_control_out <= 8'hFF;
          end
       end
    end
  end
  endgenerate

// NON_RESETABLE FLOPS
always @(posedge clk_xgmii_in)
begin
   xgmii_data_in_reg <= xgmii_data_in;
   xgmii_control_in_reg <= xgmii_control_in;
end

  generate if (SYNC_RESET_N == 1) begin
    always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
    begin
       if (~reset_xgmii_out_n)
       begin
          fifo_rd_req <= 1'b0;
       end
       else
       begin
          if (~fifo_almost_empty) begin
             fifo_rd_req <= 1'b1;
          end
       end
    end
  end else begin
    always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
    begin
       if (~reset_xgmii_out_n)
       begin
          fifo_rd_req <= 1'b0;
       end
       else
       begin
          if (~fifo_almost_empty) begin
             fifo_rd_req <= 1'b1;
          end
       end
    end
  end
  endgenerate

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Latency
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Initiate the transfer every 5-cycles (Possible to reduce to 4-cycles, but since the latency data should be constant once stable, thus trying to play safe here)
  generate if (SYNC_RESET_N == 1) begin
    always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
    begin
       if (~reset_xgmii_out_n)
       begin
          transfer_valid_slow[4] <= 1'b1;
          transfer_valid_slow[3:0] <= 4'b0000;
          xgmii_tx_path_latency_slow <= 16'b0;
       end
       else
       begin
          transfer_valid_slow[4:0] <= {transfer_valid_slow[0], transfer_valid_slow[4:1]};
          
          if(transfer_valid_slow[1]) begin
             xgmii_tx_path_latency_slow <= xgmii_tx_path_latency + fifo_latency;
          end
       end
    end
    
    always @ (posedge clk_xgmii_in or negedge reset_xgmii_in_n)
    begin
       if (~reset_xgmii_in_n)
       begin
          transfer_valid_fast[2:0] <= 3'b000;
          xgmii_tx_path_latency_fast <= 17'b0;
          xgmii_tx_path_latency_fast_2 <= 17'b0;
       end
       else
       begin
          transfer_valid_fast[0] <= transfer_valid_slow[0]; // Multi-cycle Path, setup = 2, hold = 0
          transfer_valid_fast[1] <= transfer_valid_fast[0];
          transfer_valid_fast[2] <= transfer_valid_fast[1];
          
          xgmii_tx_path_latency_fast <= {xgmii_tx_path_latency_slow[15:0], 1'b0}; // Multi-cycle Path, setup = 2, hold = 0
          
          if(transfer_valid_fast[2]) begin
             xgmii_tx_path_latency_fast_2 <= xgmii_tx_path_latency_fast;
          end
       end
    end
  end else begin
    always @ (posedge clk_xgmii_out or negedge reset_xgmii_out_n)
    begin
       if (~reset_xgmii_out_n)
       begin
          transfer_valid_slow[4] <= 1'b1;
          transfer_valid_slow[3:0] <= 4'b0000;
          xgmii_tx_path_latency_slow <= 16'b0;
       end
       else
       begin
          transfer_valid_slow[4:0] <= {transfer_valid_slow[0], transfer_valid_slow[4:1]};
          
          if(transfer_valid_slow[1]) begin
             xgmii_tx_path_latency_slow <= xgmii_tx_path_latency + fifo_latency;
          end
       end
    end
    
    always @ (posedge clk_xgmii_in or negedge reset_xgmii_in_n)
    begin
       if (~reset_xgmii_in_n)
       begin
          transfer_valid_fast[2:0] <= 3'b000;
          xgmii_tx_path_latency_fast <= 17'b0;
          xgmii_tx_path_latency_fast_2 <= 17'b0;
       end
       else
       begin
          transfer_valid_fast[0] <= transfer_valid_slow[0]; // Multi-cycle Path, setup = 2, hold = 0
          transfer_valid_fast[1] <= transfer_valid_fast[0];
          transfer_valid_fast[2] <= transfer_valid_fast[1];
          
          xgmii_tx_path_latency_fast <= {xgmii_tx_path_latency_slow[15:0], 1'b0}; // Multi-cycle Path, setup = 2, hold = 0
          
          if(transfer_valid_fast[2]) begin
             xgmii_tx_path_latency_fast_2 <= xgmii_tx_path_latency_fast;
          end
       end
    end
  end
  endgenerate

assign st_tx_path_latency = xgmii_tx_path_latency_fast_2;

endmodule
