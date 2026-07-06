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


`timescale 1 ps / 1 ps

module alt_mge_multi_channel #(
    parameter NUM_OF_CHANNEL = 1
) (
    
    // Reference Clock
    input                                   refclk_10g,
    
    // CSR Clock
    input                                   csr_clk,
    // CSR register reset 
    input                                   avmm_rst_n,  
    
    // MAC Clock
    output                                  mac32b_clk,
    
    // XGMII Clock
    output                                  mac64b_clk,
    
    // Reset
    input                                   reset,
    output [NUM_OF_CHANNEL-1:0]             tx_digitalreset,
    output [NUM_OF_CHANNEL-1:0]             rx_digitalreset,
    
    // CSR
    input                      [19:0]       csr_mch_address,
    input                                   csr_mch_read,
    input                                   csr_mch_write,
    input                      [31:0]       csr_mch_writedata,
    output                     [31:0]       csr_mch_readdata,
    output                                  csr_mch_waitrequest,

   //XCVR
    input                      [19:0]      i_reconfig_xcvr0_address,
    input                                  i_reconfig_xcvr0_read,
    input                                  i_reconfig_xcvr0_write,
    input                      [31:0]      i_reconfig_xcvr0_writedata,
    output                     [31:0]      o_reconfig_xcvr0_readdata,
    output                                 o_reconfig_xcvr0_waitrequest,
    output                                 o_reconfig_xcvr0_readdata_valid,
    
    // MAC TX User Frame
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_valid,
    output [NUM_OF_CHANNEL-1:0]             avalon_st_tx_ready,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_startofpacket,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_endofpacket,
    input  [NUM_OF_CHANNEL-1:0][63:0]       avalon_st_tx_data,
    input  [NUM_OF_CHANNEL-1:0][ 2:0]       avalon_st_tx_empty,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_tx_error,
    
    // MAC RX User Frame
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rx_valid,
    input  [NUM_OF_CHANNEL-1:0]             avalon_st_rx_ready,
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rx_startofpacket,
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rx_endofpacket,
    output [NUM_OF_CHANNEL-1:0][63:0]       avalon_st_rx_data,
    output [NUM_OF_CHANNEL-1:0][ 2:0]       avalon_st_rx_empty,
    output [NUM_OF_CHANNEL-1:0][ 5:0]       avalon_st_rx_error,
    
    // MAC TX Frame Status
    output [NUM_OF_CHANNEL-1:0]             avalon_st_txstatus_valid,
    output [NUM_OF_CHANNEL-1:0][39:0]       avalon_st_txstatus_data,
    output [NUM_OF_CHANNEL-1:0][ 6:0]       avalon_st_txstatus_error,
    
    // MAC RX Frame Status
    output [NUM_OF_CHANNEL-1:0]             avalon_st_rxstatus_valid,
    output [NUM_OF_CHANNEL-1:0][39:0]       avalon_st_rxstatus_data,
    output [NUM_OF_CHANNEL-1:0][ 6:0]       avalon_st_rxstatus_error,
    
    // MAC TX Pause Frame Generation Command
    input  [NUM_OF_CHANNEL-1:0][ 1:0]       avalon_st_pause_data,
    
    // MAC Status
    output [NUM_OF_CHANNEL-1:0][ 1:0]       xgmii_rx_link_fault_status,
    
    // PHY Status
    output [NUM_OF_CHANNEL-1:0]             led_an,
    output [NUM_OF_CHANNEL-1:0]             rx_block_lock,

    // Data Path Readiness
    output [NUM_OF_CHANNEL-1:0]             channel_tx_ready,
    output [NUM_OF_CHANNEL-1:0]             channel_rx_ready,
    output              o_rx_pcs_ready, //mprash2x
    output              o_tx_lanes_stable, //mprash2x
    input                             i_refclk2pll,
    input                             i_refclk2syspll,
    
    // Transceiver Serial Interface
    output [NUM_OF_CHANNEL-1:0]             tx_serial_data,
    input  [NUM_OF_CHANNEL-1:0]             rx_serial_data,
    output [NUM_OF_CHANNEL-1:0]             tx_serial_data_n,
    input  [NUM_OF_CHANNEL-1:0]             rx_serial_data_n,
    input                             i_reconfig_clk,  
   // input                             i_clk_ref,
    input                             i_rst_n,
    input                             i_tx_rst_n,
    input                             i_rx_rst_n,
    output                             o_rst_ack_n,
    output                             o_tx_rst_ack_n,
    output                             o_rx_rst_ack_n,
    output                             o_cdr_lock,
    output              o_clk_pll,
    output              o_tx_pll_locked


//    output [NUM_OF_CHANNEL-1:0]             rx_pma_clkout,
    
    
    
);
    // Maximum number of channels defined in address decoder
    localparam MAX_NUM_OF_CHANNEL = 12;

    wire i_clk_sys;   //mprash2x
    wire i_clk_ref;
    
    // Loop Control Variable
    //genvar i;
    
    // Core PLL
    wire                                core_pll_locked;
    wire                                o_sys_pll_locked;
    
    // Transceiver PLL
    wire                                xcvr_pll_10g_pll_locked;
    wire                                xcvr_pll_10g_pll_cal_busy;
    wire                                xcvr_pll_10g_serial_clk;
    
    // Reset Synchronization
    wire                                reset_csr_clk;
    
    // MAC Status
    wire     [NUM_OF_CHANNEL-1:0]       xgmii_rx_link_fault_status_good;
    
    // Reconfiguration Signals
    wire     [NUM_OF_CHANNEL-1:0][ 2:0] operating_speed;
    
    // MAC CSR
    wire [MAX_NUM_OF_CHANNEL-1:0][15:0] csr_ch_address;
    wire [MAX_NUM_OF_CHANNEL-1:0]       csr_ch_read;
    wire [MAX_NUM_OF_CHANNEL-1:0]       csr_ch_write;
    wire [MAX_NUM_OF_CHANNEL-1:0][31:0] csr_ch_writedata;
    wire [MAX_NUM_OF_CHANNEL-1:0][31:0] csr_ch_readdata;
    wire [MAX_NUM_OF_CHANNEL-1:0]       csr_ch_waitrequest;
    assign csr_ch_address = csr_mch_address;
    assign csr_ch_read = csr_mch_read;
    assign csr_ch_write = csr_mch_write;
    assign csr_ch_writedata = csr_mch_writedata;
    assign csr_mch_readdata = csr_ch_readdata;
    assign csr_mch_waitrequest = csr_ch_waitrequest;
  
    wire clkdiv2_pll_lock;
   
    
    alt_mge_systemclk_f_0 sys_pll (
    //GDR
     .out_systempll_clk_0(i_clk_sys), // out_systempll_clk_0.clk
     .out_systempll_synthlock_0 (),
     .out_refclk_fgt_0(i_clk_ref),    //    out_refclk_fgt_0.clk
     .in_refclk_fgt_0(i_refclk2syspll)               //          refclk_fgt.in_refclk_fgt_0
     //.in_refclk_fgt_1(i_refclk2syspll)               //
//refclk_fgt.in_refclk_fgt_1 

   );
     
    alt_mge_iopll iopll (
     	.rst      (~o_sys_pll_locked),     
	.refclk   (o_clk_pll),  
	.locked   (clkdiv2_pll_lock),  
	.outclk_0 (mac32b_clk),
	.outclk_1 (mac64b_clk) 
	);
    
    logic clkdiv2_pll_lock_reg ;
        always @ (posedge csr_clk) begin:REGISTER_PLL_LOCK
      if(!o_sys_pll_locked)
    	 clkdiv2_pll_lock_reg <= 1'b0;
      else 
      	 clkdiv2_pll_lock_reg <= clkdiv2_pll_lock;
       end 
     
    
    //generate for(i = 0; i < MAX_NUM_OF_CHANNEL; i = i + 1)
    //begin : CHANNEL_GEN
        
      //  if(i < NUM_OF_CHANNEL) begin
            // MAC + PHY
            alt_mge_channel_wrapper u_channel (
                
                // CSR Clock
                .csr_clk                    (csr_clk),
                
                // MAC Clock
                .mac32b_clk                 (mac32b_clk),
                
                // XGMII Clock
                .mac64b_clk                 (mac64b_clk),
                
                // Reset
                .reset                      (reset),
		.avmm_rst_n                 (avmm_rst_n),
                .tx_digitalreset            (tx_digitalreset),
                .rx_digitalreset            (rx_digitalreset),
                
                // PLL Status for Transceiver Reset Controller
               // .xcvr_pll_10g_pll_locked    (xcvr_pll_10g_pll_locked),
               // .xcvr_pll_10g_pll_cal_busy  (xcvr_pll_10g_pll_cal_busy),
               // .core_pll_locked            (core_pll_locked),
                
                // CSR
                .csr_ch_address             (csr_ch_address),
                .csr_ch_read                (csr_ch_read),
                .csr_ch_write               (csr_ch_write),
                .csr_ch_writedata           (csr_ch_writedata),
                .csr_ch_readdata            (csr_ch_readdata),
                .csr_ch_waitrequest         (csr_ch_waitrequest),

                 //XCVR
                 .i_reconfig_xcvr0_address       (i_reconfig_xcvr0_address),
                 .i_reconfig_xcvr0_read          (i_reconfig_xcvr0_read),
                 .i_reconfig_xcvr0_write         (i_reconfig_xcvr0_write),
                 .i_reconfig_xcvr0_writedata     (i_reconfig_xcvr0_writedata),
                 .o_reconfig_xcvr0_readdata      (o_reconfig_xcvr0_readdata), 
                 .o_reconfig_xcvr0_waitrequest   (o_reconfig_xcvr0_waitrequest),
                 .o_reconfig_xcvr0_readdata_valid (o_reconfig_xcvr0_readdata_valid),
                
                // MAC TX User Frame
                .avalon_st_tx_valid         (avalon_st_tx_valid),
                .avalon_st_tx_ready         (avalon_st_tx_ready),
                .avalon_st_tx_startofpacket (avalon_st_tx_startofpacket),
                .avalon_st_tx_endofpacket   (avalon_st_tx_endofpacket),
                .avalon_st_tx_data          (avalon_st_tx_data),
                .avalon_st_tx_empty         (avalon_st_tx_empty),
                .avalon_st_tx_error         (avalon_st_tx_error),
                
                // MAC RX User Frame
                .avalon_st_rx_valid         (avalon_st_rx_valid),
                .avalon_st_rx_ready         (avalon_st_rx_ready),
                .avalon_st_rx_startofpacket (avalon_st_rx_startofpacket),
                .avalon_st_rx_endofpacket   (avalon_st_rx_endofpacket),
                .avalon_st_rx_data          (avalon_st_rx_data),
                .avalon_st_rx_empty         (avalon_st_rx_empty),
                .avalon_st_rx_error         (avalon_st_rx_error),
                
                // MAC TX Frame Status
                .avalon_st_txstatus_valid   (avalon_st_txstatus_valid),
                .avalon_st_txstatus_data    (avalon_st_txstatus_data),
                .avalon_st_txstatus_error   (avalon_st_txstatus_error),
                
                // MAC RX Frame Status
                .avalon_st_rxstatus_valid   (avalon_st_rxstatus_valid),
                .avalon_st_rxstatus_data    (avalon_st_rxstatus_data),
                .avalon_st_rxstatus_error   (avalon_st_rxstatus_error),
                
                // MAC TX Pause Frame Generation Command
                .avalon_st_pause_data       (avalon_st_pause_data),
                
                // MAC Status
                .xgmii_rx_link_fault_status (xgmii_rx_link_fault_status),
                
                // PHY Operating Speed
                .operating_speed            (operating_speed),
                
                // PHY Status
                .led_an                     (led_an),
                .rx_block_lock              (rx_block_lock),
                
                // Transceiver Serial Interface
            //    .tx_serial_clk              (xcvr_pll_10g_serial_clk),
            //    .rx_cdr_refclk_1            (refclk_10g),
            //    .rx_pma_clkout              (rx_pma_clkout),
            //    .tx_serial_data             (tx_serial_data),
             //   .rx_serial_data             (rx_serial_data),
                
                // Data Path Readiness
                .channel_tx_ready           (channel_tx_ready),
                .channel_rx_ready           (channel_rx_ready),
       .o_tx_lanes_stable                   (o_tx_lanes_stable             ),  
       .o_rx_pcs_ready                      (o_rx_pcs_ready             ),   
                  .o_clk_pll                (o_clk_pll),
                   .i_rx_serial              (rx_serial_data),
                   .i_rx_serial_n            (rx_serial_data_n),
                  .o_tx_serial              (tx_serial_data),
                  .o_tx_serial_n            (tx_serial_data_n),
		   .i_reconfig_clk           (i_reconfig_clk),
                   .i_clk_ref                (i_clk_ref),
                   .i_clk_sys                (i_clk_sys),
                   .i_rst_n                  (i_rst_n & clkdiv2_pll_lock_reg),
                   .i_tx_rst_n               (i_tx_rst_n & clkdiv2_pll_lock_reg),
                   .i_rx_rst_n               (i_rx_rst_n & clkdiv2_pll_lock_reg),
                   .o_rst_ack_n               (o_rst_ack_n      ),   
                   .o_tx_rst_ack_n            (o_tx_rst_ack_n   ), 
                   .o_rx_rst_ack_n            (o_rx_rst_ack_n   ),
       .o_cdr_lock                          ( o_cdr_lock      ),   
       .o_tx_pll_locked                     ( o_tx_pll_locked   ),
       .o_sys_pll_locked         (o_sys_pll_locked)
            );
       // end
        
        //else begin
        //    assign csr_ch_readdata = 32'h0;
        //    assign csr_ch_waitrequest = 1'b0;
        //end
        
    //end
    //endgenerate
    
    // Avalon-MM Address Decoder
    /*address_decoder_multi_channel_wrapper address_decoder_mch (
        .csr_clk_clk                    (csr_clk),
        .csr_clk_reset_reset_n          (~reset),
        
        // Byte addressing
        .slave_address                  (csr_mch_address),
        .slave_read                     (csr_mch_read),
        .slave_write                    (csr_mch_write),
        .slave_writedata                (csr_mch_writedata),
        .slave_readdata                 (csr_mch_readdata),
        .slave_waitrequest              (csr_mch_waitrequest),
        
        // Byte addressing
        .channel_0_address              (csr_ch_address     [0]),
        .channel_0_read                 (csr_ch_read        [0]),
        .channel_0_write                (csr_ch_write       [0]),
        .channel_0_writedata            (csr_ch_writedata   [0]),
        .channel_0_readdata             (csr_ch_readdata    [0]),
        .channel_0_waitrequest          (csr_ch_waitrequest [0]),
        
        // Byte addressing
        .channel_1_address              (csr_ch_address     [1]),
        .channel_1_read                 (csr_ch_read        [1]),
        .channel_1_write                (csr_ch_write       [1]),
        .channel_1_writedata            (csr_ch_writedata   [1]),
        .channel_1_readdata             (csr_ch_readdata    [1]),
        .channel_1_waitrequest          (csr_ch_waitrequest [1]),
        
        // Byte addressing
        .channel_2_address              (csr_ch_address     [2]),
        .channel_2_read                 (csr_ch_read        [2]),
        .channel_2_write                (csr_ch_write       [2]),
        .channel_2_writedata            (csr_ch_writedata   [2]),
        .channel_2_readdata             (csr_ch_readdata    [2]),
        .channel_2_waitrequest          (csr_ch_waitrequest [2]),
        
        // Byte addressing
        .channel_3_address              (csr_ch_address     [3]),
        .channel_3_read                 (csr_ch_read        [3]),
        .channel_3_write                (csr_ch_write       [3]),
        .channel_3_writedata            (csr_ch_writedata   [3]),
        .channel_3_readdata             (csr_ch_readdata    [3]),
        .channel_3_waitrequest          (csr_ch_waitrequest [3]),
        
        // Byte addressing
        .channel_4_address              (csr_ch_address     [4]),
        .channel_4_read                 (csr_ch_read        [4]),
        .channel_4_write                (csr_ch_write       [4]),
        .channel_4_writedata            (csr_ch_writedata   [4]),
        .channel_4_readdata             (csr_ch_readdata    [4]),
        .channel_4_waitrequest          (csr_ch_waitrequest [4]),
        
        // Byte addressing
        .channel_5_address              (csr_ch_address     [5]),
        .channel_5_read                 (csr_ch_read        [5]),
        .channel_5_write                (csr_ch_write       [5]),
        .channel_5_writedata            (csr_ch_writedata   [5]),
        .channel_5_readdata             (csr_ch_readdata    [5]),
        .channel_5_waitrequest          (csr_ch_waitrequest [5]),
        
        // Byte addressing
        .channel_6_address              (csr_ch_address     [6]),
        .channel_6_read                 (csr_ch_read        [6]),
        .channel_6_write                (csr_ch_write       [6]),
        .channel_6_writedata            (csr_ch_writedata   [6]),
        .channel_6_readdata             (csr_ch_readdata    [6]),
        .channel_6_waitrequest          (csr_ch_waitrequest [6]),
        
        // Byte addressing
        .channel_7_address              (csr_ch_address     [7]),
        .channel_7_read                 (csr_ch_read        [7]),
        .channel_7_write                (csr_ch_write       [7]),
        .channel_7_writedata            (csr_ch_writedata   [7]),
        .channel_7_readdata             (csr_ch_readdata    [7]),
        .channel_7_waitrequest          (csr_ch_waitrequest [7]),
        
        // Byte addressing
        .channel_8_address              (csr_ch_address     [8]),
        .channel_8_read                 (csr_ch_read        [8]),
        .channel_8_write                (csr_ch_write       [8]),
        .channel_8_writedata            (csr_ch_writedata   [8]),
        .channel_8_readdata             (csr_ch_readdata    [8]),
        .channel_8_waitrequest          (csr_ch_waitrequest [8]),
        
        // Byte addressing
        .channel_9_address              (csr_ch_address     [9]),
        .channel_9_read                 (csr_ch_read        [9]),
        .channel_9_write                (csr_ch_write       [9]),
        .channel_9_writedata            (csr_ch_writedata   [9]),
        .channel_9_readdata             (csr_ch_readdata    [9]),
        .channel_9_waitrequest          (csr_ch_waitrequest [9]),
        
        // Byte addressing
        .channel_10_address             (csr_ch_address     [10]),
        .channel_10_read                (csr_ch_read        [10]),
        .channel_10_write               (csr_ch_write       [10]),
        .channel_10_writedata           (csr_ch_writedata   [10]),
        .channel_10_readdata            (csr_ch_readdata    [10]),
        .channel_10_waitrequest         (csr_ch_waitrequest [10]),
        
        // Byte addressing
        .channel_11_address             (csr_ch_address     [11]),
        .channel_11_read                (csr_ch_read        [11]),
        .channel_11_write               (csr_ch_write       [11]),
        .channel_11_writedata           (csr_ch_writedata   [11]),
        .channel_11_readdata            (csr_ch_readdata    [11]),
        .channel_11_waitrequest         (csr_ch_waitrequest [11])
    ); */
    
endmodule
