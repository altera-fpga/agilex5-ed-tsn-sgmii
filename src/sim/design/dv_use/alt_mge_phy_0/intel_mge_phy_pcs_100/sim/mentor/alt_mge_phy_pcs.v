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

module alt_mge_phy_pcs #(
    // Variant
    parameter IS_2P5G           = 0,
    parameter IS_1G_2P5G        = 1,
    parameter IS_1G_10G         = 0,
    parameter IS_MGBASE_T       = 0,
    parameter IS_10G_USXGMII    = 0,
    // Adapter Logic 
	 parameter ENABLE_GMII_ADAPTER    =  1,

    // CSR
    // 0: 1G/2.5G        - address  5-bit, databus 16-bit
    // 1: 1G/2.5G/5G/10G - address 11-bit, databus 32-bit
    parameter CSR_IF_MODE       = (IS_2P5G || IS_1G_2P5G) ? 0: 1,
    parameter CSR_ADDRESS_WIDTH = (CSR_IF_MODE == 1) ? 11 : 5,
    parameter CSR_DATABUS_WIDTH = (CSR_IF_MODE == 1) ? 32 : 16,
    
    // Synchronizer
    parameter SYNCHRONIZER_DEPTH= 3,
    
    // GIGE PCS
    parameter DEVICE_FAMILY     = "Arria V",
    parameter PHY_IDENTIFIER    = 32'h00000000,
    parameter DEV_VERSION       = 16'h0F00,
    parameter ENABLE_IEEE1588   = 0,
    parameter ENABLE_SGMII      = 0,
    // XGMII
    parameter XGMII_32_CWIDTH   = 4,
    parameter XGMII_32_DWIDTH   = 32,
    parameter XGMII_64_CWIDTH   = 8,
    parameter XGMII_64_DWIDTH   = 64,
    
    parameter XGMII_MAC_CWIDTH  = (IS_10G_USXGMII) ? XGMII_32_CWIDTH : XGMII_64_CWIDTH,
    parameter XGMII_MAC_DWIDTH  = (IS_10G_USXGMII) ? XGMII_32_DWIDTH : XGMII_64_DWIDTH,
    
    parameter XGMII_XCVR_CWIDTH = XGMII_64_CWIDTH,
    parameter XGMII_XCVR_DWIDTH = XGMII_64_DWIDTH,
    
    parameter PMA_MODE = 32,
    
    parameter ENABLE_UMII_FAULT = 0,
    parameter ENABLE_USXGMII_AN_RESP_MODE = 0
) (
    // Clock
    input  wire                         csr_clk,
    input  wire                         gmii8b_tx_clkin,
 
    input  wire                         tx_xgmii_clk,
    input  wire                         tx_pma_clk,
    input  wire                         tx_mac_clk_125,
    input  wire                         tx_8b_clk,

    input  wire                         rx_mac_clk_125,
	input  wire                         tx_mac_clk,
    input  wire                         rx_mac_clk,

    output wire           						gmii8b_tx_clkout,
    output wire           						gmii8b_rx_clkout,	


    input  wire                         rx_xgmii_clk,
    input  wire                         rx_pma_clk,
    input  wire                         rx_fm_ff_sample_clk,
    
    input  wire                         rx_pma_clkout,
	 output  wire                         tx_clkout,
	 output  wire                         rx_clkout,
    
    // Reset
    input  wire                         reset,
    //input  wire                         iopll_lock,
    input  wire                         tx_digitalreset,
    input  wire                         rx_digitalreset,
    
    output wire                         tx_digitalreset_to_xcvr,
    output wire                         rx_digitalreset_to_xcvr,
    
    // CSR
    input  wire [CSR_ADDRESS_WIDTH-1:0] csr_address,
    input  wire                         csr_read,
    input  wire                         csr_write,
    input  wire [CSR_DATABUS_WIDTH-1:0] csr_writedata,
    output wire [CSR_DATABUS_WIDTH-1:0] csr_readdata,
    output wire                         csr_waitrequest,
    
    // GMII 16-bit
    input  wire [1:0]                   tx_gmii16b_en,
    input  wire [15:0]                  tx_gmii16b_d,
    input  wire [1:0]                   tx_gmii16b_err,
    
    output wire [1:0]                   rx_gmii16b_dv,
    output wire [15:0]                  rx_gmii16b_d,
    output wire [1:0]                   rx_gmii16b_err,
    
	 
	 
	   
    // GMII 8-bit
    input  wire                         tx_gmii8b_en,
    input  wire [7:0]                   tx_gmii8b_d,
    input  wire                         tx_gmii8b_err,
    
    output wire                         rx_gmii8b_dv,
    output wire [7:0]                  rx_gmii8b_d,
    output wire                        rx_gmii8b_err,
    
	 
    // XGMII
    input  wire                         tx_xgmii_valid_in,
    input  wire [XGMII_MAC_CWIDTH-1:0]  tx_xgmii_control_in,
    input  wire [XGMII_MAC_DWIDTH-1:0]  tx_xgmii_data_in,
    
    output wire                         rx_xgmii_valid_out,
    output wire [XGMII_MAC_CWIDTH-1:0]  rx_xgmii_control_out,
    output wire [XGMII_MAC_DWIDTH-1:0]  rx_xgmii_data_out,
    
    // BASE-X PCS Data Path
    output wire [  1:0]                 tx_basex_datak,
    output wire [ 19:0]                 tx_basex_parallel_data,
    
    input  wire [  1:0]                 rx_basex_datak,
    input  wire [ 19:0]                 rx_basex_parallel_data,
    
    // BASE-R PCS Data Path
    output wire                         tx_xgmii_valid_out,
    output wire [XGMII_XCVR_CWIDTH-1:0] tx_xgmii_control_out,
    output wire [XGMII_XCVR_DWIDTH-1:0] tx_xgmii_data_out,
    
    input  wire                         rx_xgmii_valid_in,
    input  wire [XGMII_XCVR_CWIDTH-1:0] rx_xgmii_control_in,
    input  wire [XGMII_XCVR_DWIDTH-1:0] rx_xgmii_data_in,
    
    // MII interface
    output wire                         tx_mii_valid,
    output wire [XGMII_XCVR_CWIDTH-1:0] tx_mii_c,
    output wire [XGMII_XCVR_DWIDTH-1:0] tx_mii_d,
    output wire                         tx_mii_am,
    input  wire                         tx_mii_ready,

    input  wire                         rx_mii_valid,
    input  wire [XGMII_XCVR_CWIDTH-1:0] rx_mii_c,
    input  wire [XGMII_XCVR_DWIDTH-1:0] rx_mii_d,
    input  wire                         rx_mii_am_valid, 
    // PHY Status
    output wire                         led_link,
    output wire                         led_char_err,
    output wire                         led_disp_err,
    output wire                         led_an,
    output wire                         led_panel_link,

    output wire                   [1:0] rx_umii_fault_status,
    
    // XCVR Status
    input  wire [1:0]                   rx_syncstatus,
    input  wire [1:0]                   rx_runningdisp,
    input  wire [1:0]                   rx_disperr,
    input  wire [1:0]                   rx_errdetect,
    input  wire [1:0]                   rx_patterndetect,
    input  wire [4:0]                   rx_std_bitslipboundarysel,
    
    input  wire                         rx_block_lock_in,
    input  wire                         rx_block_lock_fm_in,
    output wire                         rx_block_lock_out,

    input  wire                         rx_am_lock,
    input  wire                         local_fault_status,
    input  wire                         remote_fault_status,
    input  wire                         rx_hi_ber,
    input  wire                         rx_pcs_fully_aligned,

    // 1588
    input  wire                         latency_measure_clk,
    output wire [21:0]                  tx_gmii16b_latency,
    output wire [21:0]                  rx_gmii16b_latency,
    
    output wire [(IS_10G_USXGMII?23:15):0]  tx_xgmii_latency,
    output wire [(IS_10G_USXGMII?23:15):0]  rx_xgmii_latency,
    
    input  wire                         latency_sclk,
    
    input  wire                         tx_fifo_latency_pulse,
    input  wire                         tx_pcs_fifo_latency_pulse,
    input  wire                         rx_fifo_latency_pulse,
    input  wire                         rx_pcs_fifo_latency_pulse,
    
    // Speed
    input  wire [1:0]                   xcvr_mode,
    output wire [2:0]                   operating_speed,
    output                              rx_clkena,
    output                              tx_clkena,
    //output                              rx_clkena_8b,
    //output                              tx_clkena_8b,
   // output                               mii_col,
	// output                               mii_crs,
	 input wire [1:0]                     gmii8b_mac_speed,

    // Transceiver signals
    output wire                         rx_seriallpbken,

    output wire                         stats_snapshot,
    
    // Agilex USXGMII 1588
    input  wire                         tx_dl_async_pulse,
    input  wire                         rx_dl_async_pulse,
    
    output wire                         tx_dl_measure_sel,
    output wire                         rx_dl_measure_sel,
    output wire                         dl_async_cal_pulse,
    
    input  wire                         cdr_lock,
    input  wire                         tx_pll_locked,
    input  wire                         tx_lanes_stable,
    input  wire                         rx_pcs_ready,
    
    output wire                         o_cdr_lock,
    output wire                         o_tx_pll_locked,
    output wire                         o_tx_lanes_stable,
    output wire                         o_rx_pcs_ready,
	input wire                           mrphy_pll_lock_pcs,
	output wire                           pll_locked_stable,
		input wire                         gmii8b_rx_rst_n,
     		input wire                         gmii8b_tx_rst_n
     		//input wire  [1:0]                  hps_gmii_phy_mac_speed_o     

);



// adapter 8 bit clock outport assignment
    assign gmii8_tx_clkout = tx_mac_clk_125 ;
    assign gmii8_rx_clkout = rx_mac_clk_125 ;
    assign tx_clkout = tx_mac_clk ;
    assign rx_clkout = rx_mac_clk ;

  //assign output port
  assign stats_snapshot=1'b0;

    // Div33 recovered clock from eth_f NPHY
    // Renaming for a better clarity
    wire        rx_rec_div33_clk;
    assign      rx_rec_div33_clk = rx_pma_clkout;
    
    assign      o_cdr_lock = cdr_lock;
    assign      o_tx_pll_locked = tx_pll_locked;
    assign      o_tx_lanes_stable = tx_lanes_stable;
    assign      o_rx_pcs_ready = rx_pcs_ready;

    // Reset
    wire        global_reset__csr_clk;
    wire        global_reset__tx_xgmii_clk;
    wire        global_reset__tx_pma_clk;
    wire        global_reset__rx_xgmii_clk;
    wire        global_reset__rx_pma_clk;
    wire        global_reset__rx_rec_div33_clk;
    wire        global_reset__latency_sclk;
    wire        global_reset__tx_mac_clk_125;
    wire        global_reset__rx_mac_clk_125;

    wire        tx_reset__csr_clk;
    wire        tx_reset__tx_xgmii_clk;
    wire        tx_reset__tx_pma_clk;
    wire        tx_reset__latency_sclk;
    wire        tx_reset__tx_mac_clk_125;

    wire        rx_reset__csr_clk;
    wire        rx_reset__rx_xgmii_clk;
    wire        rx_reset__rx_pma_clk;
    wire        rx_reset__rx_rec_div33_clk;
    wire        rx_reset__tx_pma_clk;
    wire        rx_reset__latency_sclk;
    wire        rx_reset__rx_mac_clk_125;

    wire        gtx_reset__csr_clk;
    wire        gtx_reset__tx_xgmii_clk;
    wire        gtx_reset__tx_pma_clk;
    wire        gtx_reset__latency_sclk;
	 wire        gtx_reset__tx_mac_clk_125;
    wire        gtx_reset__tx_mac_clk;
    
    wire        grx_reset__csr_clk;
    wire        grx_reset__rx_xgmii_clk;
    wire        grx_reset__rx_pma_clk;
    wire        grx_reset__rx_rec_div33_clk;
    wire        grx_reset__rx_fm_ff_sample_clk;
    wire        grx_reset__tx_pma_clk;
    wire        grx_reset__latency_sclk;
    wire        grx_reset__rx_mac_clk_125;
    wire        grx_reset__rx_mac_clk;

    // CSR
    wire [ 4:0] csr_gmii16b_pcs_address;
    wire        csr_gmii16b_pcs_read;
    wire        csr_gmii16b_pcs_write;
    wire [15:0] csr_gmii16b_pcs_writedata;
    wire [15:0] csr_gmii16b_pcs_readdata;
    wire        csr_gmii16b_pcs_waitrequest;

    wire [ 5:0] csr_usxgmii_pcs_address;
    wire        csr_usxgmii_pcs_read;
    wire        csr_usxgmii_pcs_write;
    wire [31:0] csr_usxgmii_pcs_writedata;
    wire [31:0] csr_usxgmii_pcs_readdata;
    wire        csr_usxgmii_pcs_waitrequest;

    // CSR Registers
    wire        serial_loopback;

    // Operating speed
    wire [1:0]  sgmii_speed;
	 wire [1:0]  sgmii_speed_tx_mac_clk_o;
wire [1:0]  sgmii_speed_tx_mac_clk_125_o;
wire [1:0]  sgmii_speed_rx_mac_clk_125_o;
wire [1:0]  sgmii_speed_rx_mac_clk_o;
    
    wire        wire_rx_fm_ff_sample_clk;
	 
	 
	 // wire GMII 16-bit pcs_pma
   wire  [1:0]                      rx_gmii16b_dv_pcs ;
   wire [15:0]                 rx_gmii16b_d_pcs ;
   wire  [1:0]                     rx_gmii16b_err_pcs ;
                              
   wire  [1:0]                     tx_gmii16b_en_pcs ;
   wire [15:0]                 tx_gmii16b_d_pcs ;
   wire  [1:0]                    tx_gmii16b_err_pcs ;
	// wire adapter logic
 wire   [1:0]                                 	gmii_16brx_dv  ;
 wire [15:0]                             	gmii_16brx_d   ;
 wire [1:0]                                   	gmii_16brx_err ;
              										
 wire [1:0]                                   	gmii_16btx_en  ;
 wire [15:0]                             	gmii_16btx_d   ;
 wire   [1:0]                                 	gmii_16btx_err ; 

wire                                   	tx_gmii8b_en_fifo  ;
 wire [7:0]                             	tx_gmii8b_d_fifo   ;
 wire                                  	tx_gmii8b_err_fifo ;
wire                                     wrempty_s;
wire                                     rdfull_s;
wire                                     rdempty_s;
wire                                     wrfull_s;

wire                                      mii_col;
wire                                      mii_crs;
 wire                                     tx_disable_w;
 wire [6:0]                                adapter_status_w;
	 
	     assign wire_rx_fm_ff_sample_clk = (DEVICE_FAMILY=="Agilex" && ENABLE_IEEE1588) ? rx_fm_ff_sample_clk : 1'b0;

	 /// demux logic for data swapping between adapter and direct GMII rx path
	 
	  assign rx_gmii16b_dv = ENABLE_GMII_ADAPTER == 1'b1 ?  2'b00 : rx_gmii16b_dv_pcs ;
	  assign rx_gmii16b_d =   ENABLE_GMII_ADAPTER == 1'b1 ? 16'h0000 : rx_gmii16b_d_pcs ;
	  assign rx_gmii16b_err = ENABLE_GMII_ADAPTER == 1'b1 ? 2'b00 : rx_gmii16b_err_pcs ; 
	  
	  assign gmii_16brx_dv = ENABLE_GMII_ADAPTER == 1'b0 ?  2'b00 : rx_gmii16b_dv_pcs ;
	  assign gmii_16brx_d =   ENABLE_GMII_ADAPTER == 1'b0 ? 16'h0000 : rx_gmii16b_d_pcs ;
	  assign gmii_16brx_err = ENABLE_GMII_ADAPTER == 1'b0 ? 2'b00 : rx_gmii16b_err_pcs ; 
	  
	  /// mux logic for data swapping between adapter and direct GMII tx path
	 
	  assign tx_gmii16b_en_pcs = ENABLE_GMII_ADAPTER == 1'b1 ?  gmii_16btx_en : tx_gmii16b_en; 
	  assign tx_gmii16b_d_pcs = ENABLE_GMII_ADAPTER == 1'b1 ?  gmii_16btx_d : tx_gmii16b_d; 
     assign tx_gmii16b_err_pcs = ENABLE_GMII_ADAPTER == 1'b1 ? gmii_16btx_err : tx_gmii16b_err; 
	  
	  //GMII RX  output 
//	  assign  rx_gmii16b_dv = rx_gmii16b_dv_pcs ;
//	  assign  rx_gmii16b_d = rx_gmii16b_d_pcs ;
//	  assign  rx_gmii16b_err = rx_gmii16b_err_pcs ;

    // Reset Sync
    alt_mge_phy_pcs_rst_sync #(
        .SYNCHRONIZER_DEPTH         (SYNCHRONIZER_DEPTH)
    ) rst_sync (
        // Clock
        .csr_clk                    (csr_clk),
        
        .tx_xgmii_clk               (tx_xgmii_clk),
        .tx_pma_clk                 (tx_pma_clk),
        .rx_mac_clk_125               (rx_mac_clk_125),
		  .tx_mac_clk_125               (tx_mac_clk_125),
		  .rx_mac_clk               (rx_mac_clk),
		  .tx_mac_clk               (tx_mac_clk),
        .rx_xgmii_clk               (rx_xgmii_clk),
        .rx_pma_clk                 (rx_pma_clk),
        .rx_rec_div33_clk           (rx_rec_div33_clk),
        .rx_fm_ff_sample_clk        (wire_rx_fm_ff_sample_clk),
        
        .latency_sclk               (latency_sclk),
        
        // Async Reset Input
        .reset                      (reset ),
        
        .tx_digitalreset            (tx_digitalreset ),
        .rx_digitalreset            (rx_digitalreset ),
        
        // Sync Reset Output
        .global_reset__csr_clk          (global_reset__csr_clk),
        .global_reset__tx_xgmii_clk     (global_reset__tx_xgmii_clk),
        .global_reset__tx_pma_clk       (global_reset__tx_pma_clk),
        .global_reset__rx_xgmii_clk     (global_reset__rx_xgmii_clk),
        .global_reset__rx_pma_clk       (global_reset__rx_pma_clk),
        .global_reset__rx_rec_div33_clk (global_reset__rx_rec_div33_clk),
        .global_reset__latency_sclk     (global_reset__latency_sclk),
        .global_reset__tx_mac_clk_125      (global_reset__tx_mac_clk_125),
         .global_reset__rx_mac_clk_125      (global_reset__rx_mac_clk_125),

        .tx_reset__csr_clk              (tx_reset__csr_clk),
        .tx_reset__tx_xgmii_clk         (tx_reset__tx_xgmii_clk),
        .tx_reset__tx_pma_clk           (tx_reset__tx_pma_clk),
        .tx_reset__latency_sclk         (tx_reset__latency_sclk),
         .tx_reset__tx_mac_clk_125           (tx_reset__tx_mac_clk_125),

        .rx_reset__csr_clk              (rx_reset__csr_clk),
        .rx_reset__rx_xgmii_clk         (rx_reset__rx_xgmii_clk),
        .rx_reset__rx_pma_clk           (rx_reset__rx_pma_clk),
        .rx_reset__rx_rec_div33_clk     (rx_reset__rx_rec_div33_clk),
        .rx_reset__tx_pma_clk           (rx_reset__tx_pma_clk),
        .rx_reset__latency_sclk         (rx_reset__latency_sclk),
         .rx_reset__rx_mac_clk_125           (rx_reset__rx_mac_clk_125),

        .gtx_reset__csr_clk             (gtx_reset__csr_clk),
        .gtx_reset__tx_xgmii_clk        (gtx_reset__tx_xgmii_clk),
        .gtx_reset__tx_pma_clk          (gtx_reset__tx_pma_clk),
        .gtx_reset__latency_sclk        (gtx_reset__latency_sclk),
        .gtx_reset__tx_mac_clk_125       (gtx_reset__tx_mac_clk_125),
		  
		   .grx_reset__rx_mac_clk_125       (grx_reset__rx_mac_clk_125),
		   .gtx_reset__tx_mac_clk       (gtx_reset__tx_mac_clk),
		  
		   .grx_reset__rx_mac_clk      (grx_reset__rx_mac_clk),

        .grx_reset__csr_clk             (grx_reset__csr_clk),
        .grx_reset__rx_xgmii_clk        (grx_reset__rx_xgmii_clk),
        .grx_reset__rx_pma_clk          (grx_reset__rx_pma_clk),
        .grx_reset__rx_rec_div33_clk    (grx_reset__rx_rec_div33_clk),
        .grx_reset__rx_fm_ff_sample_clk (grx_reset__rx_fm_ff_sample_clk),
        .grx_reset__tx_pma_clk          (grx_reset__tx_pma_clk),
        .grx_reset__latency_sclk        (grx_reset__latency_sclk)
        
    );

    // Reset to transceiver
    assign tx_digitalreset_to_xcvr = gtx_reset__tx_pma_clk;
    assign rx_digitalreset_to_xcvr = grx_reset__rx_pma_clk;

    // CSR
    alt_mge_phy_pcs_csr_top #(
        // Variant
        .IS_2P5G                        (IS_2P5G),
        .IS_1G_2P5G                     (IS_1G_2P5G),
        .IS_1G_10G                      (IS_1G_10G),
        .IS_MGBASE_T                    (IS_MGBASE_T),
        .IS_10G_USXGMII                 (IS_10G_USXGMII),
        
        // Mode & Width
        .CSR_IF_MODE                    (CSR_IF_MODE),
        .CSR_ADDRESS_WIDTH              (CSR_ADDRESS_WIDTH),
        .CSR_DATABUS_WIDTH              (CSR_DATABUS_WIDTH)
    ) csr (
        // Clock
        .csr_clk                        (csr_clk),
        
        // Reset
        .global_rst_n__csr_clk          (~global_reset__csr_clk),
        
        // User CSR Interface
        .csr_address                    (csr_address),
        .csr_read                       (csr_read),
        .csr_write                      (csr_write),
        .csr_writedata                  (csr_writedata),
        .csr_readdata                   (csr_readdata),
        .csr_waitrequest                (csr_waitrequest),
        
        // GMII 16-bit PCS
        .csr_gmii16b_pcs_address        (csr_gmii16b_pcs_address),
        .csr_gmii16b_pcs_read           (csr_gmii16b_pcs_read),
        .csr_gmii16b_pcs_write          (csr_gmii16b_pcs_write),
        .csr_gmii16b_pcs_writedata      (csr_gmii16b_pcs_writedata),
        .csr_gmii16b_pcs_readdata       (csr_gmii16b_pcs_readdata),
        .csr_gmii16b_pcs_waitrequest    (csr_gmii16b_pcs_waitrequest),
        
        // USXGMII PCS
        .csr_usxgmii_pcs_address        (csr_usxgmii_pcs_address),
        .csr_usxgmii_pcs_read           (csr_usxgmii_pcs_read),
        .csr_usxgmii_pcs_write          (csr_usxgmii_pcs_write),
        .csr_usxgmii_pcs_writedata      (csr_usxgmii_pcs_writedata),
        .csr_usxgmii_pcs_readdata       (csr_usxgmii_pcs_readdata),
        .csr_usxgmii_pcs_waitrequest    (csr_usxgmii_pcs_waitrequest),
        
        // CSR Registers
        .serial_loopback                (serial_loopback)
    );

    wire [11:0] gmii_latency_xcvr_tx;
    wire [11:0] gmii_latency_xcvr_rx;
	 
	 // ADAPTER LOGIC
 generate
  if (ENABLE_GMII_ADAPTER == 1) begin 
//	 alt_tse16_gmii_16b_conv conv_dut(
//                // Clocks
//                .tx_mac_clk_125   (tx_mac_clk_125),
//                .tx_mac_clk       (tx_mac_clk),
//                .rx_mac_clk_125   (rx_mac_clk_125),
//                .rx_mac_clk       (rx_mac_clk),
//                // Resets
//                .tx_reset_tx_mac_clk_125    (gtx_reset__tx_mac_clk_125),
//                .rx_reset_rx_mac_clk_125    (grx_reset__rx_mac_clk_125),
//                .tx_reset_tx_mac_clk        (gtx_reset__tx_mac_clk),
//                .rx_reset_rx_mac_clk        (grx_reset__rx_mac_clk),
////                 // Clock enables
////                .rx_16b_clkena          (rx_16b_clkena),  //output
////                .tx_16b_clkena          (tx_16b_clkena),  //output
////                .tx_clkena              (tx_clkena), //output
////                .rx_clkena              (rx_clkena), //output
//					 
//					 
//					 // Clock enables
//                .rx_16b_clkena          (),  //output
//                .tx_16b_clkena          (),  //output
//                .tx_clkena              (tx_clkena_8b), //output
//                .rx_clkena               (rx_clkena_8b), //output
//					 
//                // SGMII speeds
//                .sgmii_speed_tx_mac_clk     (sgmii_speed_tx_mac_clk_o),
//                .sgmii_speed_rx_mac_clk     (sgmii_speed_rx_mac_clk_o),
//                .sgmii_speed_tx_mac_clk_125 (sgmii_speed_tx_mac_clk_125_o),
//
//                .sgmii_speed_rx_mac_clk_125 (sgmii_speed_rx_mac_clk_125_o),
//                
//                .gmii_8b_rx_d                (rx_gmii8b_d),       //           mac_gmii_connection.gmii_rx_d
//                .gmii_8b_rx_dv               (rx_gmii8b_dv),      //                              .gmii_rx_dv
//                .gmii_8b_rx_err              (rx_gmii8b_err),     //                              .gmii_rx_err
//					 
//                .gmii_8b_tx_d                (tx_gmii8b_d_fifo),       //                              .gmii_tx_d
//                .gmii_8b_tx_en               (tx_gmii8b_en_fifo),      //                              .gmii_tx_en
//                .gmii_8b_tx_err              (tx_gmii8b_err_fifo),     //                              .gmii_tx_err
//               
//                // GMII 16b
//                .gmii_16b_rx_dv         (gmii_16brx_dv),
//                .gmii_16b_rx_d          (gmii_16brx_d),
//                .gmii_16b_rx_err        (gmii_16brx_err),
//					 
//                .gmii_16b_tx_en         (gmii_16btx_en),
//                .gmii_16b_tx_d          (gmii_16btx_d),
//                .gmii_16b_tx_err        (gmii_16btx_err)
//
//);

hps_to_mge_gmii_adapter_core u_hps_to_mge_gmii_adapter_core (
		//.clk            (clock_clk),                //   input,   width = 1,          clock.clk
		//.rst_n          (reset_sink_reset_n),       //   input,   width = 1,     reset_sink.reset_n
		//.addr           (csr_address),              //   input,   width = 1,            csr.address
		//.read           (csr_read),                 //   input,   width = 1,               .read
		//.write          (csr_write),                //   input,   width = 1,               .write
		//.writedata      (csr_writedata),            //   input,  width = 32,               .writedata
		//.readdata       (csr_readdata),             //  output,  width = 32,               .readdata
		.mac_tx_clk_o   (gmii8b_tx_clkin),    //   input,   width = 1,       hps_gmii.phy_tx_clk_o
		.mac_rst_tx_n   (gmii8b_tx_rst_n),        //   input,   width = 1,               .rst_tx_n
		.mac_rst_rx_n   (gmii8b_rx_rst_n),        //   input,   width = 1,               .rst_rx_n
		.mac_txd        (tx_gmii8b_d),       //   input,   width = 8,               .phy_txd_o
		.mac_txen       (tx_gmii8b_en),      //   input,   width = 1,               .phy_txen_o
		.mac_txer       (tx_gmii8b_err),      //   input,   width = 1,               .phy_txer_o
		.mac_speed      (gmii8b_mac_speed), //   input,   width = 2,               .phy_mac_speed_o
		.mac_tx_clk_i   (gmii8b_tx_clkout),    //  output,   width = 1,               .phy_tx_clk_i
		.mac_rx_clk     (gmii8b_rx_clkout),    //  output,   width = 1,               .phy_rx_clk_i
		.mac_rxdv       (rx_gmii8b_dv),      //  output,   width = 1,               .phy_rxdv_i
		.mac_rxer       (rx_gmii8b_err),      //  output,   width = 1,               .phy_rxer_i
		.mac_rxd        (rx_gmii8b_d),       //  output,   width = 8,               .phy_rxd_i
		.mac_col        (mii_col),       //  output,   width = 1,               .phy_col_i
		.mac_crs        (mii_crs),       //  output,   width = 1,               .phy_crs_i
		.pll_125m_clk   (tx_8b_clk),         //   input,   width = 1,   pll_125m_clk.clk
		.pll_25m_clk    (tx_mac_clk_125),          //   input,   width = 1,    pll_25m_clk.clk
		.pll_2_5m_clk   (rx_mac_clk_125),         //   input,   width = 1,   pll_2_5m_clk.clk
		.pll_locked     (mrphy_pll_lock_pcs),        //   input,   width = 1,     pll_locked.export
		.phy_rx_clkout  (rx_mac_clk),        //   input,   width = 1,  phy_rx_clkout.clk
		.phy_rx_clkena  (rx_clkena),     //   input,   width = 1,  phy_rx_clkena.export
		.phy_tx_clkout  (tx_mac_clk),        //   input,   width = 1,  phy_tx_clkout.clk
		.phy_tx_clkena  (tx_clkena),     //   input,   width = 1,  phy_tx_clkena.export
		.phy_speed      (operating_speed),         //   input,   width = 3,      phy_speed.export
		.gmii16b_rx_d   (gmii_16brx_d),      //   input,  width = 16,   gmii16b_rx_d.export
		.gmii16b_rx_dv  (gmii_16brx_dv),     //   input,   width = 2,  gmii16b_rx_dv.export
		.gmii16b_rx_err (gmii_16brx_err),    //   input,   width = 2, gmii16b_rx_err.export
		.gmii16b_tx_d   (gmii_16btx_d),      //  output,  width = 16,   gmii16b_tx_d.export
		.gmii16b_tx_en  (gmii_16btx_en),     //  output,   width = 2,  gmii16b_tx_en.export
		.tx_disable    (tx_disable_w),
		.adapter_status  (adapter_status_w) ,
		.pll_locked_stable (pll_locked_stable),

		.gmii16b_tx_err (gmii_16btx_err)     //  output,   width = 2, gmii16b_tx_err.export
	);



// dcfifo #(
//        .intended_device_family("Agilex 5"),
//        .lpm_hint("RAM_BLOCK_TYPE=M20K,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE"),
//        .lpm_numwords(8),
//        .lpm_showahead("OFF"),
//        .lpm_type("dcfifo"),
//        .lpm_width(10),
//        .lpm_widthu(3),
//        .overflow_checking("ON"),
//        .rdsync_delaypipe(4),
//        .underflow_checking("ON"),
//        .use_eab("ON"),
//        .write_aclr_synch("ON"),
//        .read_aclr_synch("ON"),
//        .wrsync_delaypipe (4)
//    ) dcfifo_adpater(
//        .wrclk (gmii8b_mac_tx_clk_o),
//        .wrreq ( ~wrfull_s),
//        .aclr (gtx_reset__tx_mac_clk_125),
//        .rdreq (~rdempty_s & tx_clkena_8b),
//        .rdclk (tx_mac_clk_125),
//        .data ({tx_gmii8b_err,tx_gmii8b_en,tx_gmii8b_d}),
//        .rdempty (rdempty_s),
//        .wrusedw (),
//        .wrfull (wrfull_s),
//        .q ({tx_gmii8b_err_fifo,tx_gmii8b_en_fifo,tx_gmii8b_d_fifo}),
//        .rdusedw (),
//        .eccstatus (),
//        .rdfull (rdfull_s),
//        .wrempty (wrempty_s)
//    );
	
	
	
	
	
	end 
	endgenerate 
	 
	 
	 
	 
	
    
    generate
    if (((DEVICE_FAMILY == "Stratix 10") || (DEVICE_FAMILY =="Agilex 5"))  && (IS_2P5G || IS_1G_2P5G || IS_1G_10G || IS_MGBASE_T)) begin
        alt_mge_xcvr_latency_pulse_measurement #(
            .FIFO_DEPTH    (8),
            .PCS_FIFO_DEPTH(8),
            .SAMPLE_SIZE   (512)
        ) GMII_TX_LATENCY (
            .latency_sclk           (latency_sclk),
            .reset                  (gtx_reset__latency_sclk),
            .fifo_latency_pulse     (tx_fifo_latency_pulse),
            .pcs_fifo_latency_pulse (tx_pcs_fifo_latency_pulse),
            .latency_xcvr           (gmii_latency_xcvr_tx),
            .result_ready           ()
        );
        
        alt_mge_xcvr_latency_pulse_measurement #(
            .FIFO_DEPTH    (8),
            .PCS_FIFO_DEPTH(8),
            .SAMPLE_SIZE    (512)
        ) GMII_RX_LATENCY (
            .latency_sclk           (latency_sclk),
            .reset                  (grx_reset__latency_sclk),
            .fifo_latency_pulse     (rx_fifo_latency_pulse),
            .pcs_fifo_latency_pulse (rx_pcs_fifo_latency_pulse),
            .latency_xcvr           (gmii_latency_xcvr_rx),
            .result_ready           ()
        );
    end
    else begin
        assign gmii_latency_xcvr_tx = {12{1'b0}};
        assign gmii_latency_xcvr_rx = {12{1'b0}};
    end
    endgenerate 
    
    generate
    if (IS_2P5G || IS_1G_2P5G || IS_1G_10G || IS_MGBASE_T) begin: GMII_PCS
        // GMII 16-bit
        alt_mge16_pcs_pma #(
            .DEVICE_FAMILY              (DEVICE_FAMILY),
            .PHY_IDENTIFIER             (PHY_IDENTIFIER),
            .DEV_VERSION                (DEV_VERSION),
            .ENABLE_IEEE1588            (ENABLE_IEEE1588),
            .ENABLE_SGMII		        (ENABLE_SGMII),
            .SYNCHRONIZER_DEPTH         (SYNCHRONIZER_DEPTH)
        ) gmii_pcs (
            
            // Clock
            .csr_clk                    (csr_clk),
            
            .tx_mac_clk                 (tx_mac_clk),
            .tx_phy_clk                 (tx_pma_clk),
            
            .rx_mac_clk                 (rx_mac_clk),
            .rx_phy_clk                 (rx_pma_clk),
            .rx_mac_clk_125               (rx_mac_clk_125),
				 .tx_mac_clk_125               (tx_mac_clk_125),
           
            // Reset
            .csr_reset_csr_clk          (global_reset__csr_clk),
            .tx_reset_tx_mac_clk        (gtx_reset__tx_mac_clk),
            .tx_reset_tx_phy_clk        (gtx_reset__tx_pma_clk),
            .rx_reset_rx_mac_clk        (grx_reset__rx_mac_clk),
            .rx_reset_rx_phy_clk        (grx_reset__rx_pma_clk),
            .latency_sclk_reset_tx      (gtx_reset__latency_sclk),
            .latency_sclk_reset_rx      (grx_reset__latency_sclk),
            .tx_reset_tx_mac_clk_125    (gtx_reset__tx_mac_clk_125),
            .rx_reset_rx_mac_clk_125    (grx_reset__rx_mac_clk_125),
            // CSR
            .address                    (csr_gmii16b_pcs_address),
            .read                       (csr_gmii16b_pcs_read),
            .write                      (csr_gmii16b_pcs_write),
            .writedata                  (csr_gmii16b_pcs_writedata),
            .readdata                   (csr_gmii16b_pcs_readdata),
            .waitrequest                (csr_gmii16b_pcs_waitrequest),
            
            // GMII 16-bit
            .gmii_tx_en                 (tx_gmii16b_en_pcs),
            .gmii_tx_d                  (tx_gmii16b_d_pcs),
            .gmii_tx_err                (tx_gmii16b_err_pcs),
            
            .gmii_rx_dv                 (rx_gmii16b_dv_pcs),
            .gmii_rx_d                  (rx_gmii16b_d_pcs),
            .gmii_rx_err                (rx_gmii16b_err_pcs),
            //8bit status signals
				 .mii_crs  (mii_crs),
				 .mii_col  (mii_col),
            // PHY Status
            .led_link                   (led_link),
            .led_char_err               (led_char_err),
            .led_disp_err               (led_disp_err),
            .led_an                     (led_an),
            .led_panel_link             (led_panel_link),
            //clk enable
            .rx_clkena_half             (rx_clkena),
            .tx_clkena_half             (tx_clkena),
            .sgmii_speed                (sgmii_speed),      //  SGMII Speed
				.sgmii_speed_tx_mac_clk_125_o (sgmii_speed_tx_mac_clk_125_o), 
		      .sgmii_speed_rx_mac_clk_125_o (sgmii_speed_rx_mac_clk_125_o), 
            .sgmii_speed_rx_mac_clk_o (sgmii_speed_rx_mac_clk_o), 
            .sgmii_speed_tx_mac_clk_o (sgmii_speed_tx_mac_clk_o),

				
//				
//            // XCVR Data Path
//            .tx_datak                   (tx_basex_datak),
           .tx_parallel_data           (tx_basex_parallel_data),
//            .rx_datak                   (rx_basex_datak),
           .rx_parallel_data           (rx_basex_parallel_data),
            
            // XCVR Status
            .rx_syncstatus              (rx_syncstatus),
            .rx_runningdisp             (rx_runningdisp),
            .rx_disperr                 (rx_disperr),
            .rx_errdetect               (rx_errdetect),
            .rx_patterndetect           (rx_patterndetect),
            .rx_std_bitslipboundarysel  (rx_std_bitslipboundarysel),
            
            // Settings to XCVR
            .rx_seriallpbken            (rx_seriallpbken),
            
            // 1588
            .latency_measure_clk        (latency_measure_clk),
            .gmii16b_tx_latency         (tx_gmii16b_latency),
            .gmii16b_rx_latency         (rx_gmii16b_latency),
            .latency_sclk               (latency_sclk),
            .latency_xcvr_rx            (gmii_latency_xcvr_rx),
				.tx_disable                  (tx_disable_w),
				.adapter_status               (adapter_status_w) ,
            .latency_xcvr_tx            (gmii_latency_xcvr_tx)
        );
        
        //assign sgmii_speed = 2'b10;
        
        assign operating_speed = (xcvr_mode == 2'b00) ? ((sgmii_speed == 2'b00) ? 3'b011 : // 10M
                                                         (sgmii_speed == 2'b01) ? 3'b010 : // 100M
                                                         (sgmii_speed == 2'b10) ? 3'b001 : // 1G
                                                                                  3'b001): // Unused: default to 1G
                                 (xcvr_mode == 2'b01) ? 3'b100 : // 2.5G
                                 (xcvr_mode == 2'b10) ? 3'b101 : // 5G
                                                        3'b000 ; // 10G
    end
    else begin
        assign csr_gmii16b_pcs_readdata    = 16'h0;
        assign csr_gmii16b_pcs_waitrequest = 1'b0;
        
        assign rx_gmii16b_dv            = 2'b00;
        assign rx_gmii16b_d             = 16'h0;
        assign rx_gmii16b_err           = 2'b0;
        
        assign tx_basex_datak           = 2'b00;
        assign tx_basex_parallel_data   = 20'h0;
        
        assign tx_gmii16b_latency       = 22'h0;
        assign rx_gmii16b_latency       = 22'h0;
        
        assign led_link                 = 1'b0;
        assign led_char_err             = 1'b0;
        assign led_disp_err             = 1'b0;
        assign led_panel_link           = 1'b0;
        
        assign rx_clkena                = 1'b0;
        assign tx_clkena                = 1'b0;
    end
    endgenerate

    wire [11:0] xgmii_latency_xcvr_tx;
    wire [11:0] xgmii_latency_xcvr_rx;

    generate
    //if (DEVICE_FAMILY == "Stratix 10" && (IS_1G_10G || IS_MGBASE_T || IS_10G_USXGMII)) begin
	  if (DEVICE_FAMILY == "Stratix 10" && (IS_1G_10G  || IS_10G_USXGMII)) begin
        alt_mge_xcvr_latency_pulse_measurement #(
            .FIFO_DEPTH    (16),
            .PCS_FIFO_DEPTH(16),
            .SAMPLE_SIZE   (4096)
        ) XGMII_TX_LATENCY (
            .latency_sclk           (latency_sclk),
            .reset                  (gtx_reset__latency_sclk),
            .fifo_latency_pulse     (tx_fifo_latency_pulse),
            .pcs_fifo_latency_pulse (tx_pcs_fifo_latency_pulse),
            .latency_xcvr           (xgmii_latency_xcvr_tx),
            .result_ready           ()
        );
        
        alt_mge_xcvr_latency_pulse_measurement #(
            .FIFO_DEPTH    (16),
            .PCS_FIFO_DEPTH(16),
            .SAMPLE_SIZE   (4096)
        ) XGMII_RX_LATENCY (
            .latency_sclk           (latency_sclk),
            .reset                  (grx_reset__latency_sclk),
            .fifo_latency_pulse     (rx_fifo_latency_pulse),
            .pcs_fifo_latency_pulse (rx_pcs_fifo_latency_pulse),
            .latency_xcvr           (xgmii_latency_xcvr_rx),
            .result_ready           ()
        );
    end
    else begin
        assign xgmii_latency_xcvr_tx = {12{1'b0}};
        assign xgmii_latency_xcvr_rx = {12{1'b0}};
    end
    endgenerate
    
    // For Agilex 1588
    wire            wire_tx_mii_am;
    wire            wire_dl_async_cal_pulse;
    wire            wire_tx_dl_measure_sel;
    wire            wire_rx_dl_measure_sel;
    wire            wire_rx_mii_am_valid;
    wire            wire_tx_dl_async_pulse;
    wire            wire_rx_dl_async_pulse;
    
    assign tx_mii_am                    = (DEVICE_FAMILY=="Agilex 5" && ENABLE_IEEE1588 && IS_10G_USXGMII ) ? wire_tx_mii_am         : 1'b0;
    assign dl_async_cal_pulse           = (DEVICE_FAMILY=="Agilex 5" && ENABLE_IEEE1588 && IS_10G_USXGMII) ? wire_dl_async_cal_pulse: 1'b0;
    assign tx_dl_measure_sel            = (DEVICE_FAMILY=="Agilex 5" && ENABLE_IEEE1588 && IS_10G_USXGMII) ? wire_tx_dl_measure_sel : 1'b0;
    assign rx_dl_measure_sel            = (DEVICE_FAMILY=="Agilex" && ENABLE_IEEE1588 && IS_10G_USXGMII) ? wire_rx_dl_measure_sel : 1'b0;

    assign wire_rx_mii_am_valid         = (DEVICE_FAMILY=="Agilex 5" && ENABLE_IEEE1588 && IS_10G_USXGMII) ? rx_mii_am_valid        : 1'b0;
    assign wire_tx_dl_async_pulse       = (DEVICE_FAMILY=="Agilex 5" && ENABLE_IEEE1588 && IS_10G_USXGMII) ? tx_dl_async_pulse      : 1'b0;
    assign wire_rx_dl_async_pulse       = (DEVICE_FAMILY=="Agilex 5" && ENABLE_IEEE1588 && IS_10G_USXGMII) ? rx_dl_async_pulse      : 1'b0;



reg [63:0] rx_mii_d_d2,rx_mii_d_d1; 
reg [7:0] rx_mii_c_d2,rx_mii_c_d1;
reg  rx_mii_valid_d2,rx_mii_valid_d1;
reg  rx_mii_am_valid_d2,rx_mii_am_valid_d1;
reg  rx_block_lock_fm_in_d2,rx_block_lock_fm_in_d1;
reg  rx_am_lock_d2,rx_am_lock_d1;
reg  local_fault_status_d2,local_fault_status_d1;
reg  remote_fault_status_d2,remote_fault_status_d1;


always @(posedge rx_pma_clk)
begin
 rx_mii_d_d1 <= rx_mii_d; 
 rx_mii_c_d1 <= rx_mii_c;
 rx_mii_valid_d1 <= rx_mii_valid;
//rx_mii_am_valid_d1 <= alt_mge_xcvr_native_rx_pcs_o_rx_mii_am_valid;
 rx_block_lock_fm_in_d1 <= rx_block_lock_fm_in;

//rx_am_lock_d1 <= alt_mge_xcvr_native_status_ports_o_rx_am_lock;
 //local_fault_status_d1 <= alt_mge_xcvr_native_status_ports_o_local_fault_status;
// remote_fault_status_d1 <= alt_mge_xcvr_native_status_ports_o_remote_fault_status;

 rx_mii_d_d2 <= rx_mii_d_d1; 
 rx_mii_c_d2 <= rx_mii_c_d1;
 rx_mii_valid_d2 <= rx_mii_valid_d1;
 //rx_mii_am_valid_d2 <= rx_mii_am_valid_d1;
 rx_block_lock_fm_in_d2 <= rx_block_lock_fm_in_d1;
 //rx_am_lock_d2 <= rx_am_lock_d1;
//local_fault_status_d2 <=  local_fault_status_d1;
 //remote_fault_status_d2 <= remote_fault_status_d1;
end    

    generate
    if ((DEVICE_FAMILY != "Agilex 5") && (IS_1G_10G || IS_MGBASE_T)) begin: XGMII_PCS
	 //if (IS_1G_10G ) begin: XGMII_PCS
        // XGMII
        alt_mge_phy_xgmii_pcs #(
            .PMA_MODE                   (PMA_MODE),
            .DEVICE_FAMILY              (DEVICE_FAMILY),
            .ENABLE_IEEE1588            (ENABLE_IEEE1588)
        ) xgmii_pcs (
            
            // TX
            .tx_xgmii_clk               (tx_xgmii_clk),
            .tx_pma_clk                 (tx_pma_clk),
            
            .tx_xgmii_rst_n             (~gtx_reset__tx_xgmii_clk),
            .tx_pma_rst_n               (~gtx_reset__tx_pma_clk),
            
            .tx_reset_latency_sclk      (gtx_reset__latency_sclk),
            
            .tx_data_in                 (tx_xgmii_data_in),
            .tx_control_in              (tx_xgmii_control_in),
            
            .tx_data_valid_out          (tx_xgmii_valid_out),
            .tx_control_out             (tx_xgmii_control_out),
            .tx_data_out                (tx_xgmii_data_out),
            

            // RX
            .rx_xgmii_clk               (rx_xgmii_clk),
            .rx_pma_clk                 (rx_pma_clk),
            
            .rx_xgmii_rst_n             (~grx_reset__rx_xgmii_clk),
            .rx_pma_rst_n               (~grx_reset__rx_pma_clk),
            
            .rx_reset_latency_sclk      (grx_reset__latency_sclk),
            
            .rx_data_valid_in           (rx_xgmii_valid_in),
            .rx_control_in              (rx_xgmii_control_in),
            .rx_data_in                 (rx_xgmii_data_in),
            .rx_control_fec_in          (2'b10),
            
            .rx_control_out             (rx_xgmii_control_out),
            .rx_data_out                (rx_xgmii_data_out),
            
            .rx_latency_adj             (rx_xgmii_latency),
            .tx_latency_adj             (tx_xgmii_latency),
            
            .latency_sclk               (latency_sclk),
            .latency_xcvr_rx            (xgmii_latency_xcvr_rx),
            .latency_xcvr_tx            (xgmii_latency_xcvr_tx)
        );
        
        assign csr_usxgmii_pcs_readdata    = 32'h0;
        assign csr_usxgmii_pcs_waitrequest = 1'b0;
        
        assign rx_xgmii_valid_out = 1'b0;
        assign rx_block_lock_out = rx_block_lock_in;
        
        assign rx_umii_fault_status = 2'b00;
    end
        
    else if (IS_10G_USXGMII && DEVICE_FAMILY != "Agilex 5") begin: USXGMII_PCS
        // USXGMII
        alt_mge_phy_usxg32_pcs #(
            .PMA_MODE                       (PMA_MODE),
            .DEVICE_FAMILY                  (DEVICE_FAMILY),
            .ENABLE_IEEE1588                (ENABLE_IEEE1588),
            .SYNCHRONIZER_DEPTH             (SYNCHRONIZER_DEPTH),
            .ENABLE_UMII_FAULT              (ENABLE_UMII_FAULT),
            .ENABLE_USXGMII_AN_RESP_MODE    (ENABLE_USXGMII_AN_RESP_MODE)

        ) usxgmii_pcs (
            
            // Clock
            .csr_clk                    (csr_clk),
            
            .tx_xgmii_clk               (tx_xgmii_clk),
            .tx_pma_clk                 (tx_pma_clk),
            
            .rx_xgmii_clk               (rx_xgmii_clk),
            .rx_pma_clk                 (rx_pma_clk),
            
            // Reset
            .global_rst_n__csr_clk      (~global_reset__csr_clk),
            .global_rst_n__sclk         (1'b0),
            
            .gtx_rst_n__csr_clk         (~gtx_reset__csr_clk),
            .gtx_rst_n__tx_xgmii_clk    (~gtx_reset__tx_xgmii_clk),
            .gtx_rst_n__tx_pma_clk      (~gtx_reset__tx_pma_clk),
            
            .grx_rst_n__csr_clk         (~grx_reset__csr_clk),
            .grx_rst_n__rx_xgmii_clk    (~grx_reset__rx_xgmii_clk),
            .grx_rst_n__rx_pma_clk      (~grx_reset__rx_pma_clk),
            
            // CSR
            .csr_address                (csr_usxgmii_pcs_address),
            .csr_read                   (csr_usxgmii_pcs_read),
            .csr_write                  (csr_usxgmii_pcs_write),
            .csr_writedata              (csr_usxgmii_pcs_writedata),
            .csr_readdata               (csr_usxgmii_pcs_readdata),
            .csr_waitrequest            (csr_usxgmii_pcs_waitrequest),
            
            // TX
            .tx_xgmii_32_valid_in       (tx_xgmii_valid_in),
            .tx_xgmii_32_control_in     (tx_xgmii_control_in),
            .tx_xgmii_32_data_in        (tx_xgmii_data_in),
            
            .tx_xgmii_64_valid_out      (tx_xgmii_valid_out),
            .tx_xgmii_64_control_out    (tx_xgmii_control_out),
            .tx_xgmii_64_data_out       (tx_xgmii_data_out),
            
            // RX
            .rx_xgmii_64_valid_in       (rx_xgmii_valid_in),
            .rx_xgmii_64_control_in     (rx_xgmii_control_in),
            .rx_xgmii_64_data_in        (rx_xgmii_data_in),
            
            .rx_xgmii_32_valid_out      (rx_xgmii_valid_out),
            .rx_xgmii_32_control_out    (rx_xgmii_control_out),
            .rx_xgmii_32_data_out       (rx_xgmii_data_out),
            
            .rx_block_lock_in           (rx_block_lock_in),
            .rx_block_lock_out          (rx_block_lock_out),
            
            // Status
            .led_an                     (led_an),
            .rx_umii_fault_status       (rx_umii_fault_status),
            //ED 1588
            .tx_reset_latency_sclk      (gtx_reset__latency_sclk),
            .tx_latency_adj             (tx_xgmii_latency),
            .rx_reset_latency_sclk      (grx_reset__latency_sclk),
            .rx_latency_adj             (rx_xgmii_latency),
            .latency_sclk               (latency_sclk),
            .latency_xcvr_rx            (xgmii_latency_xcvr_rx),
            .latency_xcvr_tx            (xgmii_latency_xcvr_tx),
            // Operating Speed
            .operating_speed            (operating_speed)
        );
        
        assign rx_seriallpbken          = serial_loopback;
        
        // assign tx_xgmii_latency         = 16'h0;
        // assign rx_xgmii_latency         = 16'h0;
        
    end

    else if ((IS_10G_USXGMII) && (DEVICE_FAMILY == "Agilex 5") && (ENABLE_IEEE1588 == 0)) begin: USXGMII_PCS
        // USXGMII
        alt_mge_phy_usxg32_pcs #(
            .PMA_MODE                       (PMA_MODE),
            .DEVICE_FAMILY                  (DEVICE_FAMILY),
            .ENABLE_IEEE1588                (ENABLE_IEEE1588),
            .SYNCHRONIZER_DEPTH             (SYNCHRONIZER_DEPTH),
            .ENABLE_UMII_FAULT              (ENABLE_UMII_FAULT),
            .ENABLE_USXGMII_AN_RESP_MODE    (ENABLE_USXGMII_AN_RESP_MODE)

        ) usxgmii_pcs (
            // Clock
            .csr_clk                    (csr_clk),
            
            .tx_xgmii_clk               (tx_xgmii_clk),
            .tx_pma_clk                 (tx_pma_clk),
            
            .rx_xgmii_clk               (rx_xgmii_clk),
            .rx_pma_clk                 (rx_pma_clk),
            
            // Reset
            .global_rst_n__csr_clk      (~global_reset__csr_clk),
            .global_rst_n__sclk         (1'b0),
            
            .gtx_rst_n__csr_clk         (~gtx_reset__csr_clk),
            .gtx_rst_n__tx_xgmii_clk    (~gtx_reset__tx_xgmii_clk),
            .gtx_rst_n__tx_pma_clk      (~gtx_reset__tx_pma_clk),
            
            .grx_rst_n__csr_clk         (~grx_reset__csr_clk),
            .grx_rst_n__rx_xgmii_clk    (~grx_reset__rx_xgmii_clk),
            .grx_rst_n__rx_pma_clk      (~grx_reset__rx_pma_clk),
            
            // CSR
            .csr_address                (csr_usxgmii_pcs_address),
            .csr_read                   (csr_usxgmii_pcs_read),
            .csr_write                  (csr_usxgmii_pcs_write),
            .csr_writedata              (csr_usxgmii_pcs_writedata),
            .csr_readdata               (csr_usxgmii_pcs_readdata),
            .csr_waitrequest            (csr_usxgmii_pcs_waitrequest),
            
            // TX
            .tx_xgmii_32_valid_in       (tx_xgmii_valid_in),
            .tx_xgmii_32_control_in     (tx_xgmii_control_in),
            .tx_xgmii_32_data_in        (tx_xgmii_data_in),
            
            .tx_xgmii_64_valid_out      (tx_mii_valid),
            .tx_xgmii_64_control_out    (tx_mii_c),
            .tx_xgmii_64_data_out       (tx_mii_d),
            
            // RX
            .rx_xgmii_64_valid_in       (rx_mii_valid_d2),
            .rx_xgmii_64_control_in     (rx_mii_c_d2),
            .rx_xgmii_64_data_in        (rx_mii_d_d2),
            
            .rx_xgmii_32_valid_out      (rx_xgmii_valid_out),
            .rx_xgmii_32_control_out    (rx_xgmii_control_out),
            .rx_xgmii_32_data_out       (rx_xgmii_data_out),
            
            .rx_block_lock_in           (rx_block_lock_fm_in_d2),
            .rx_block_lock_out          (rx_block_lock_out),
            
            // Status
            .led_an                     (led_an),
            .rx_umii_fault_status       (rx_umii_fault_status),
            
            // ED 1588
            .tx_reset_latency_sclk      (gtx_reset__latency_sclk),
            .tx_latency_adj             (tx_xgmii_latency),
            .rx_reset_latency_sclk      (grx_reset__latency_sclk),
            .rx_latency_adj             (rx_xgmii_latency),
            .latency_sclk               (latency_sclk),
            .latency_xcvr_rx            (xgmii_latency_xcvr_rx),
            .latency_xcvr_tx            (xgmii_latency_xcvr_tx),
            
            // Operating Speed
            .operating_speed            (operating_speed)
        );
        
        assign rx_seriallpbken          = serial_loopback;
        
        // assign tx_xgmii_latency         = 16'h0;
        // assign rx_xgmii_latency         = 16'h0;
    end
    
    else if ((IS_10G_USXGMII) && (DEVICE_FAMILY == "Agilex 5") && (ENABLE_IEEE1588 == 1)) begin: USXGMII_PCS
        // USXGMII
        alt_mge_phy_usxg32_pcs #(
            .PMA_MODE                       (PMA_MODE),
            .DEVICE_FAMILY                  (DEVICE_FAMILY),
            .ENABLE_IEEE1588                (ENABLE_IEEE1588),
            .SYNCHRONIZER_DEPTH             (SYNCHRONIZER_DEPTH),
            .ENABLE_UMII_FAULT              (ENABLE_UMII_FAULT),
            .ENABLE_USXGMII_AN_RESP_MODE    (ENABLE_USXGMII_AN_RESP_MODE)

        ) usxgmii_pcs (
            // Clock
            .csr_clk                    (csr_clk),
            
            .tx_xgmii_clk               (tx_xgmii_clk),
            .tx_pma_clk                 (tx_pma_clk),
            
            .rx_xgmii_clk               (rx_xgmii_clk),
            .rx_pma_clk                 (rx_pma_clk),
            .rx_rec_div33_clk           (rx_rec_div33_clk),
            .rx_fm_ff_sample_clk        (rx_fm_ff_sample_clk),
            
            // Reset
            .global_rst_n               (~reset),
            .tx_digital_rst_n           (~tx_digitalreset),
            .rx_digital_rst_n           (~rx_digitalreset),
            
            .global_rst_n__csr_clk      (~global_reset__csr_clk),
            .global_rst_n__sclk         (~global_reset__latency_sclk),
            .global_rst_n__tx_xgmii_clk (~global_reset__tx_xgmii_clk),
            .global_rst_n__rx_xgmii_clk (~global_reset__rx_xgmii_clk),
            .global_rst_n__rx_rec_div33_clk (~global_reset__rx_rec_div33_clk),
            
            .gtx_rst_n__csr_clk         (~gtx_reset__csr_clk),
            .gtx_rst_n__tx_xgmii_clk    (~gtx_reset__tx_xgmii_clk),
            .gtx_rst_n__tx_pma_clk      (~gtx_reset__tx_pma_clk),
            
            .grx_rst_n__csr_clk             (~grx_reset__csr_clk),
            .grx_rst_n__rx_xgmii_clk        (~grx_reset__rx_xgmii_clk),
            .grx_rst_n__rx_pma_clk          (~grx_reset__rx_pma_clk),
            .grx_rst_n__rx_rec_div33_clk    (~grx_reset__rx_rec_div33_clk),
            .grx_rst_n__rx_fm_ff_sample_clk (~grx_reset__rx_fm_ff_sample_clk),
            
            // CSR
            .csr_address                (csr_usxgmii_pcs_address),
            .csr_read                   (csr_usxgmii_pcs_read),
            .csr_write                  (csr_usxgmii_pcs_write),
            .csr_writedata              (csr_usxgmii_pcs_writedata),
            .csr_readdata               (csr_usxgmii_pcs_readdata),
            .csr_waitrequest            (csr_usxgmii_pcs_waitrequest),
            
            // TX
            .tx_xgmii_32_valid_in       (tx_xgmii_valid_in),
            .tx_xgmii_32_control_in     (tx_xgmii_control_in),
            .tx_xgmii_32_data_in        (tx_xgmii_data_in),
            
            .tx_xgmii_64_valid_out      (tx_mii_valid),
            .tx_xgmii_64_control_out    (tx_mii_c),
            .tx_xgmii_64_data_out       (tx_mii_d),
            
            // RX
            .rx_xgmii_64_valid_in       (rx_mii_valid),
            .rx_xgmii_64_control_in     (rx_mii_c),
            .rx_xgmii_64_data_in        (rx_mii_d),
            
            .rx_xgmii_32_valid_out      (rx_xgmii_valid_out),
            .rx_xgmii_32_control_out    (rx_xgmii_control_out),
            .rx_xgmii_32_data_out       (rx_xgmii_data_out),
            
            .rx_block_lock_in           (rx_block_lock_fm_in),
            .rx_block_lock_out          (rx_block_lock_out),
            
            // Status
            .led_an                     (led_an),
            .rx_umii_fault_status       (rx_umii_fault_status),
            
            // ED 1588
            .tx_reset_latency_sclk      (gtx_reset__latency_sclk),
            .tx_latency_adj             (tx_xgmii_latency),
            .rx_reset_latency_sclk      (grx_reset__latency_sclk),
            .rx_latency_adj             (rx_xgmii_latency),
            
            .latency_sclk               (latency_sclk),
            .latency_xcvr_rx            (xgmii_latency_xcvr_rx),
            .latency_xcvr_tx            (xgmii_latency_xcvr_tx),
            
            // Operating Speed
            .operating_speed            (operating_speed),
            
            // 1588
            .rx_xgmii_dl_sync_pulse_in  (wire_rx_mii_am_valid),
            .tx_xgmii_dl_sync_pulse_out (wire_tx_mii_am),
            
            .tx_dl_async_pulse          (wire_tx_dl_async_pulse),
            .rx_dl_async_pulse          (wire_rx_dl_async_pulse),
            
            .dl_async_cal_pulse         (wire_dl_async_cal_pulse),
            .tx_dl_measure_sel          (wire_tx_dl_measure_sel),
            .rx_dl_measure_sel          (wire_rx_dl_measure_sel),

            .tx_stable                  (tx_lanes_stable),
            .rx_stable                  (rx_pcs_ready)
        );
        
        assign rx_seriallpbken          = serial_loopback;

    end
    
    else begin
        assign csr_usxgmii_pcs_readdata    = 32'h0;
        assign csr_usxgmii_pcs_waitrequest = 1'b0;
        
        assign tx_xgmii_valid_out   = 1'b0;
        assign tx_xgmii_control_out = {XGMII_XCVR_CWIDTH{1'b0}};
        assign tx_xgmii_data_out    = {XGMII_XCVR_DWIDTH{1'b0}};
        
        assign rx_xgmii_valid_out   = 1'b0;
        assign rx_xgmii_control_out = {XGMII_MAC_CWIDTH{1'b0}};
        assign rx_xgmii_data_out    = {XGMII_MAC_DWIDTH{1'b0}};
        
        assign tx_xgmii_latency     = 16'h0;
        assign rx_xgmii_latency     = 16'h0;
        
        assign rx_block_lock_out    = 1'b0;
        
        assign rx_umii_fault_status = 2'b00;
    end

    endgenerate
    
endmodule
