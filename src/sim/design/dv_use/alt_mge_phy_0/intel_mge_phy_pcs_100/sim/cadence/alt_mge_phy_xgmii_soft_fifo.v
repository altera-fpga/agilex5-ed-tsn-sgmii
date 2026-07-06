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

module alt_mge_phy_xgmii_soft_fifo #(
  parameter FAWIDTH          = 5,
  parameter TSWIDTH          = 16,
  parameter IDWIDTH          = 40,
  parameter RX_DWIDTH        = 64,
  parameter RX_CWIDTH        = 10,
  parameter TX_DWIDTH        = 64,
  parameter TX_CWIDTH        = 9,
  parameter RX_OFFSET        = 16'h283D,
  parameter TX_OFFSET        = 16'h29D6,
  parameter DEVICE_FAMILY    = "Arria V",
  parameter ENABLE_IEEE1588  = 0
  )(
    input wire                   rx_xgmii_clk,
    input wire                   tx_xgmii_clk,
    input wire                   rx_pma_clk,
    input wire                   tx_pma_clk,
    input wire                   rx_xgmii_rst_n,
    input wire                   rx_pma_rst_n,
    input wire                   tx_xgmii_rst_n,
    input wire                   tx_pma_rst_n,
	input wire                   rx_reset_latency_sclk,
	input wire                   tx_reset_latency_sclk,
    input wire  [RX_DWIDTH-1:0]  rx_data_in,
    input wire  [RX_CWIDTH-1:0]  rx_control_in,
    input wire                   rx_data_valid_in,
    input wire  [TX_DWIDTH-1:0]  tx_data_in,
    input wire  [TX_CWIDTH-1:0]  tx_control_in,
    input wire                   tx_data_valid_in,
    output wire [RX_DWIDTH-1:0]  rx_data_out,
    output wire [RX_CWIDTH-1:0]  rx_control_out,
    //output wire                  rx_data_valid_out,
    output wire [TX_DWIDTH-1:0]  tx_data_out,
    output wire [TX_CWIDTH-1:0]  tx_control_out,
    output wire                  tx_data_valid_out,
    output wire                  rxfifofull,
    output wire                  txfifofull,
    output wire [TSWIDTH-1:0]    rx_latency_adj,
    output wire [TSWIDTH-1:0]    tx_latency_adj,
	
	input   wire                 latency_sclk,
	input   wire [11:0]          latency_xcvr_tx,
	input   wire [11:0]          latency_xcvr_rx
 );

  localparam  PMA_MODE = (IDWIDTH == 32) ? 7'd32 : 7'd40;
        
         alt_mge_phy_xgmii_rx_fifo 
           #(
             .PCSDWIDTH          (RX_DWIDTH),        // PCS data width
             .PCSRXCWIDTH        (RX_CWIDTH),        // PCS control width
             .FAWIDTH            (FAWIDTH),          // FIFO Depth (address width) 
             .ISWIDTH            (7),                // RX Gearbox Selector width
             .TSWIDTH            (TSWIDTH),
             .IDWIDTH            (IDWIDTH),          // PCS/PMA IF width
             .OFFSET             (RX_OFFSET),         // PCS latency
			 .DEVICE_FAMILY      (DEVICE_FAMILY),
			 .ENABLE_IEEE1588    (ENABLE_IEEE1588)
             )
         rx_clockcomp
           (
            .wr_rst_n              (rx_pma_rst_n),     // Write Domain Active low Reset
            .rd_rst_n              (rx_xgmii_rst_n),     // Read Domain Active low Reset
			.latency_sclk_reset    (rx_reset_latency_sclk),
            .wr_clk                (rx_pma_clk),     // Write Domain Clock
            .rd_clk                (rx_xgmii_clk),   // Read Domain Clock
            .r_force_align         (1'b0),           // Force alignment 1'b0 
            .r_align_del           (1'b0),           // Delete the alignment pattern   1'b0
            .r_mask_del            (10'd0),          // Mask frame words for deletion  10'd0
            .r_fifo_mode           (3'b010),         // FIFO Mode: Phase-comp, BaseR RM, Interlaken, Register use Mode 2'10, it's BaseR RM
            .wr_align_mark         (1'b1),           // Alignment Pattern  need input set 1'b1 temp
            .rd_align_en           (1'b1),           // This channel is active (rd_clk) 1'b1
            .rd_align_clr          (1'b0),           // Clears the wr_align_val (rd_clk) 1'b0
            .rd_en                 (1'b1),           // Read Data from DSKEW FIFO need input
            .control_in            (rx_control_in),  // Frame information, SV need 2 more bits 
            .data_in               (rx_data_in),     // Write Data In
            .data_valid_in         (rx_data_valid_in),// Write Data In Valid 
            .control_in_fast       (10'd0),          // Fast control in , fast path is not used
            .data_in_fast          (64'd0),          // Fast Write Data In, fast path is not used
            .data_valid_in_fast    (1'b0),           // Fast Write Data In Valid, fast path is not used 

            .r_empty               ({FAWIDTH{1'b0}}),         // FIFO empty threshold 5'b00000
            .r_full                ({FAWIDTH{1'b1}}),         // FIFO full threshold  5'b11111
            .r_pempty              (5'd2),                    // FIFO partially empty threshold 2
            .r_pfull               (5'd15),                   // FIFO partially full threshold 15
            .r_rx_fast_path        (1'b0 ),                   // Fast Path Enable: directly from Gearbox 1'b0
            .r_truebac2bac         (1'b1 ),
            .r_write_ctrl          (1'b0 ),
            .r_skip_word           (64'h1e1e1e1e1e1e1e1e),
            .r_skip_ctrl           ({3{1'b0}} ),
            .gb_odwidth            (7'd66),

            .control_out           (rx_control_out),          // Frame information 
            .data_out              (rx_data_out),             // Read Data Out (Contains CTRL+DATA)
            .data_valid_out        (),                        // Read Data Out Valid 
            .rd_empty              (),                        // Read empty
            .rd_pempty             (),                        // Read partial empty
            .rd_pfull              (),                        // Read partial full 
            .wr_oflw_err           (rxfifofull),              // Overflow error 
            .rd_align_val          (),                        // Alignment Pattern has been found
          //.rd_word_del           ()                         // Flag to identify all words deleted
            .latency_adj           (rx_latency_adj),
            .latency_sclk           (latency_sclk),
			.latency_xcvr_rx        (latency_xcvr_rx),
			
            .fifo_insert           (),
            .fifo_del              (),
            .testbus1              (),
            .testbus2              ()
            );
         
         alt_mge_phy_xgmii_clockcomp
           #(
             .PCSDWIDTH            (TX_DWIDTH),          // FIFO Data input width  
             .PCSCWIDTH            (TX_CWIDTH),
             .FAWIDTH              (FAWIDTH),
             .ISWIDTH              (7),                  // RX Gearbox Selector width
             .TSWIDTH              (TSWIDTH),
             .IDWIDTH              (IDWIDTH),            // PCS/PMA IF width
             .OFFSET               (TX_OFFSET),           // PCS latency
			 .DEVICE_FAMILY        (DEVICE_FAMILY)
             )
         tx_phasecomp
           (
           .wr_rst_n        (tx_xgmii_rst_n),                // Write Domain Active low Reset
           .wr_clk          (tx_xgmii_clk),              // Write Domain Clock
		   .latency_sclk_reset    (tx_reset_latency_sclk),
           .data_in         (tx_data_in),                // Write Data In (Contains CTRL+DATA)
           .control_in      (tx_control_in),             // Frame information
           .data_valid_in   (1'b1),                      // Write Data In Valid
           .rd_rst_n        (tx_pma_rst_n),                // Read Domain Active low Reset
           .rd_clk          (tx_pma_clk),                // Read Domain Clock
           .data_out        (tx_data_out),               // Read Data Out (Contains CTRL+DATA)
           .control_out     (tx_control_out),
           .data_valid_out  (tx_data_valid_out),         // Read Data Out Valid 
           .data_valid_raw  (),                          // Raw Data Valid for Frame-Gen
           .wr_empty        (),                          // Write empty
           .wr_pempty       (),                          // Write partial empty
           .wr_pfull        (),                          // Write partial full 
           .wr_full         (txfifofull),                // FIFO Became FULL, Error Condition
           .rd_empty        (),                          // Read empty
           .rd_pempty       (),                          // Read partial empty
           .rd_pfull        (),                          // Read partial full 
           .phcomp_wren     (),                          // Wr Enable to CP Bonding
           .phcomp_rden     (),                          // Rd Enable to CP Bonding
           .intlkn_rden     (),                          // Interlaken Rd Enable to Agg Bonding
           .dv_en           (),                          // Data Valid Enable to CP Bonding
           .latency_adj     (tx_latency_adj),            // Latency adjustment for timestamping
		   .latency_sclk    (latency_sclk),
		   .latency_xcvr_tx (latency_xcvr_tx),
           
           .fifo_del        (),                          // 10G BaseR Deletion Flag
           .fifo_insert     (),                          // 10G BaseR Insertion Flag
           .testbus1        (),                          // Test Bus 1
           .testbus2        (),                          // Test Bus 2
           
           .r_fifo_mode     (3'b000),                    //clkcomp_mode
           .r_pempty        (5'd2),
           .r_pfull         (5'd23),
           .r_empty         (5'd0),
           .r_full          (5'd31),
           .r_indv          (1'b1),
           .r_truebac2bac   (1'b1),
           .r_phcomp_rd_delay (3'd2),
           .gb_idwidth      (7'd66),
           .gb_odwidth      (PMA_MODE),
           
           // unused ports
           .rd_en           (1'b0),                 // Read Enable in generic mode 
           .comp_dv_en      (1'b0),                 // CP Bonding Data Valid Enable
           .comp_wren_en    (1'b0),                 // CP Bonding Write Enable
           .comp_rden_en    (1'b0),                 // CP Bonding Read Enable
           .comp_intlkn_rden_en (1'b0)              // Interlaken Read Enable from Agg Bonding
            );
            
endmodule
