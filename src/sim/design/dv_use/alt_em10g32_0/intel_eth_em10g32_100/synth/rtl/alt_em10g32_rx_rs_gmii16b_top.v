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

module alt_em10g32_rx_rs_gmii16b_top (
   // Clock and reset
   input clk_gmii,
   input clk_mac,
   input reset_gmii_n,
   input reset_gmii_n_asyn,
   input reset_mac_n,

   input csr_rx_tsfr_en_n,
   output rx_tsfr_sts_gmii16b,
    // GMII/MII clock enable
   
   input rx_clkena_half_rate,
   // GMII 16 bit signals
   input [1:0] gmii16b_rx_dv,    //  GMII Receive Enable
   input [15:0] gmii16b_rx_d,    //  GMII Receive Data
   input [1:0] gmii16b_rx_err,   //  GMII Receive Error

   // Avalon-ST Data path
   output wire rx_ethfrm_sop,
   output wire rx_ethfrm_eop,
   output wire [1:0] rx_ethfrm_empty,
   output wire rx_ethfrm_valid,
   output wire rx_ethfrm_error,
   output wire [31:0] rx_ethfrm_data,
   
   output reg rx_packet_in_progress_gmii16b
);

parameter ENABLE_TIMESTAMPING = 0;
parameter SYNC_RESET_N = 1;

wire rx_ethfrm_sop_int;
wire rx_ethfrm_eop_int;
wire [1:0] rx_ethfrm_empty_int;
wire rx_ethfrm_valid_int;
wire rx_ethfrm_error_int;
wire [31:0] rx_ethfrm_data_int;

wire csr_rx_tsfr_en_n_sync;
reg  disable_gmii16b_rx_n;

wire        pipeline_in_sop;
wire        pipeline_in_eop;
wire [1:0]  pipeline_in_empty;
wire        pipeline_in_valid;
wire        pipeline_in_error;
wire [31:0] pipeline_in_data;

wire        pipeline_out_sop;
wire        pipeline_out_eop;
wire [1:0]  pipeline_out_empty;
wire        pipeline_out_valid;
wire        pipeline_out_error;
wire [31:0] pipeline_out_data;

// Set SYNCHRONIZER_IDENTIFICATION=OFF because they are driving by same clock gmii16b_rx_clk
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg  [1:0]  gmii16b_rx_dv_reg [3:0];
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg  [15:0] gmii16b_rx_d_reg  [3:0];
(* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg  [1:0]  gmii16b_rx_err_reg[3:0];

wire [1:0]  gmii16b_rx_dv_int;
wire [15:0] gmii16b_rx_d_int;
wire [1:0]  gmii16b_rx_err_int;

wire state_is_idle;

alt_em10g32_std_synchronizer #(
    .depth(2)
) sync_csr_rx_tsfr_en_n (
    .clk (clk_gmii),
    .reset_n (reset_gmii_n_asyn),
    .din (csr_rx_tsfr_en_n),
    .dout (csr_rx_tsfr_en_n_sync)
);

// When state_is_idle asserted, it means that this packet finish transfer (or data path is idling). 
// hence can start to disable at this point
always @ (posedge clk_gmii)
begin
   if (~reset_gmii_n)
   begin
      disable_gmii16b_rx_n <= 1'b1;
   end
   else
   begin
      if (state_is_idle)
      begin
         disable_gmii16b_rx_n <= ~csr_rx_tsfr_en_n_sync;
      end
   end
end

assign rx_tsfr_sts_gmii16b = ~disable_gmii16b_rx_n;

generate 
if (ENABLE_TIMESTAMPING) 
    begin
        always @(posedge clk_gmii )
        begin
            if (~reset_gmii_n)
            begin
                gmii16b_rx_dv_reg [0] <= 2'h0;
                gmii16b_rx_d_reg  [0] <= 16'h0;
                gmii16b_rx_err_reg[0] <= 2'h0;
                
                gmii16b_rx_dv_reg [1] <= 2'h0;
                gmii16b_rx_d_reg  [1] <= 16'h0;
                gmii16b_rx_err_reg[1] <= 2'h0;
                
                gmii16b_rx_dv_reg [2] <= 2'h0;
                gmii16b_rx_d_reg  [2] <= 16'h0;
                gmii16b_rx_err_reg[2] <= 2'h0;
                
                gmii16b_rx_dv_reg [3] <= 2'h0;
                gmii16b_rx_d_reg  [3] <= 16'h0;
                gmii16b_rx_err_reg[3] <= 2'h0;
            end
            else
            begin
                gmii16b_rx_dv_reg [0] <= gmii16b_rx_dv;
                gmii16b_rx_d_reg  [0] <= gmii16b_rx_d;
                gmii16b_rx_err_reg[0] <= gmii16b_rx_err;
                
                gmii16b_rx_dv_reg [1] <= gmii16b_rx_dv_reg [0];
                gmii16b_rx_d_reg  [1] <= gmii16b_rx_d_reg  [0];
                gmii16b_rx_err_reg[1] <= gmii16b_rx_err_reg[0];
                
                gmii16b_rx_dv_reg [2] <= gmii16b_rx_dv_reg [1];
                gmii16b_rx_d_reg  [2] <= gmii16b_rx_d_reg  [1];
                gmii16b_rx_err_reg[2] <= gmii16b_rx_err_reg[1];
                
                gmii16b_rx_dv_reg [3] <= gmii16b_rx_dv_reg [2];
                gmii16b_rx_d_reg  [3] <= gmii16b_rx_d_reg  [2];
                gmii16b_rx_err_reg[3] <= gmii16b_rx_err_reg[2];
            end
        end
        
        assign gmii16b_rx_dv_int  = gmii16b_rx_dv_reg [3];
        assign gmii16b_rx_d_int   = gmii16b_rx_d_reg  [3];
        assign gmii16b_rx_err_int = gmii16b_rx_err_reg[3];
    end
else
    begin
        assign gmii16b_rx_dv_int  = gmii16b_rx_dv;
        assign gmii16b_rx_d_int   = gmii16b_rx_d;
        assign gmii16b_rx_err_int = gmii16b_rx_err;
    end
endgenerate

alt_em10g32_rx_rs_gmii16b #(
.SYNC_RESET_N(SYNC_RESET_N)
) i_alt_em10g32_rx_rs_gmii16b (
   .clk (clk_gmii),
   .rst_n (reset_gmii_n_asyn),
   .csr_rx_tsfr_en_n (csr_rx_tsfr_en_n_sync),
   .gmii16b_rx_dv (gmii16b_rx_dv_int),
   .gmii16b_rx_d (gmii16b_rx_d_int),
   .gmii16b_rx_err (gmii16b_rx_err_int),
   .state_is_idle (state_is_idle),
   .rx_ethfrm_sop (rx_ethfrm_sop_int),
   .rx_ethfrm_eop (rx_ethfrm_eop_int),
   .rx_ethfrm_empty (rx_ethfrm_empty_int),
   .rx_ethfrm_valid (rx_ethfrm_valid_int),
   .rx_ethfrm_error (rx_ethfrm_error_int),
   .rx_clkena (rx_clkena_half_rate),
   .rx_ethfrm_data (rx_ethfrm_data_int)
);

alt_em10g32_rr_clock_crosser #(
    .NUM_OF_CHANNEL     (5),
    
    .SYMBOLS_PER_BEAT   (4),
    .BITS_PER_SYMBOL    (8),
    .CHANNEL_WIDTH      (0),
    .ERROR_WIDTH        (1),
    .USE_PACKETS        (1),
    
    .FORWARD_SYNC_DEPTH (3),
    .BACKWARD_SYNC_DEPTH(3),
    .SYNC_RESET_N       (SYNC_RESET_N)
) i_gmii16b_rx_clock_crosser (
    
    .in_clk(clk_gmii),
    .in_reset_n(reset_gmii_n),

    .out_clk(clk_mac),
    .out_reset_n(reset_mac_n),

    // sink
    .in_data            (rx_ethfrm_data_int),
    .in_valid           (rx_ethfrm_valid_int & rx_clkena_half_rate),
    .in_ready           (),
    .in_startofpacket   (rx_ethfrm_sop_int),
    .in_endofpacket     (rx_ethfrm_eop_int),
    .in_error           (rx_ethfrm_error_int),
    .in_empty           (rx_ethfrm_empty_int),
    .in_channel         (1'b0),

    // source
    .out_data           (pipeline_in_data),
    .out_valid          (pipeline_in_valid),
    .out_ready          (1'b1),
    .out_startofpacket  (pipeline_in_sop),
    .out_endofpacket    (pipeline_in_eop),
    .out_error          (pipeline_in_error),
    .out_empty          (pipeline_in_empty),
    .out_channel        ()
    
);

alt_em10g32_pipeline_base #(
    .BITS_PER_SYMBOL    (37),
    .SYMBOLS_PER_BEAT   (1),
    .PIPELINE_READY     (0)
) out_pipeline (
    .clk        (clk_mac),
    .reset_n    (reset_mac_n),
    .in_ready   (),
    .in_valid   (pipeline_in_valid),
    .in_data    ({pipeline_in_error,
                  pipeline_in_sop,
                  pipeline_in_eop,
                  pipeline_in_empty,
                  pipeline_in_data}),
    .out_ready  (1'b1),
    .out_valid  (pipeline_out_valid),
    .out_data   ({pipeline_out_error,
                  pipeline_out_sop,
                  pipeline_out_eop,
                  pipeline_out_empty,
                  pipeline_out_data})
);

assign rx_ethfrm_sop    = pipeline_out_sop;
assign rx_ethfrm_eop    = pipeline_out_eop;
assign rx_ethfrm_empty  = pipeline_out_empty;
assign rx_ethfrm_valid  = pipeline_out_valid;
assign rx_ethfrm_error  = pipeline_out_error;
assign rx_ethfrm_data   = pipeline_out_data;

always @ (posedge clk_gmii)
begin
   if (~reset_gmii_n)
   begin
      rx_packet_in_progress_gmii16b <= 1'b0;
   end
   else
   begin
      rx_packet_in_progress_gmii16b <= |gmii16b_rx_dv;
   end
end

endmodule
