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



`timescale 1ns / 1ns

module alt_mge16_phy_xcvr_term #(
    parameter IS_2P5G = 0,
    parameter IS_1G_2P5G = 1,
    parameter IS_1G_10G = 0,
    parameter IS_MGBASE_T = 0,
    parameter IS_10G_USXGMII = 0,
    parameter BASER_REG_MODE = 1,
	parameter ENABLE_IEEE1588 = 0,
	parameter DEVICE_FAMILY = "Arria 10", 
	parameter ENABLE_GMII_ADAPTER = 0,
    
    parameter TX_SERIAL_CLK_WIDTH = (IS_2P5G)        ? 1 : 
                                    (IS_1G_2P5G)     ? 2 :
                                    (IS_1G_10G)      ? 2 :
                                    (IS_MGBASE_T)    ? 3 :
                                    (IS_10G_USXGMII) ? 1 : 2,
    
    parameter RX_CDR_REFCLK_WIDTH = (IS_2P5G)        ? 1 : 
                                    (IS_1G_2P5G)     ? 1 :
                                    (IS_1G_10G)      ? 2 :
                                    (IS_MGBASE_T)    ? 2 :
                                    (IS_10G_USXGMII) ? 1 : 1,
    
    parameter ENABLE_TX_PIPELINE = 1, // 0: Disable pipeline, 1: Positive edge pipeline, 2: Negative edge pipeline
    parameter ENABLE_RX_PIPELINE = 1  // 0: Disable pipeline, 1: Positive edge pipeline, 2: Negative edge pipeline, 3: Negative edge pipeline followed by positive edge pipeline
) (
	// TX Reset
    input           tx_digitalreset_to_xcvr_in,         // From GMII PCS
    output          tx_digitalreset_to_xcvr_out,        // To Native PHY
    
    // RX Reset
    input           rx_digitalreset_to_xcvr_in,         // From GMII PCS
    output          rx_digitalreset_to_xcvr_out,        // To Native PHY
   
   //Reset to DPHY
   //
   
   input           i_rst_n,                            // from top
   input           i_tx_rst_n,                         // from top
   input           i_rx_rst_n,                         // from top
   output          o_tx_rst,                         // To  DPHY
   output          o_rx_rst,                         // To  DPHY 
   input           i_rx_rst_ack,                     // from DPHY          
   input           i_tx_rst_ack,                     // from DPHY
   output          o_rst_ack_n,                        // To top
   output 	   	   o_rx_rst_ack_n,                     // To Top
   output          o_tx_rst_ack_n,                     // To Top

   //ready signals
   
   input i_tx_ready,   //from dphy
   input i_rx_ready,   //from dphy
   output o_tx_ready,  //to top
   output o_rx_ready,  //to top
   
    // TX Serial Clock
    input    [TX_SERIAL_CLK_WIDTH-1:0]  tx_serial_clk_in,       // From User
	output   [TX_SERIAL_CLK_WIDTH-1:0]  tx_serial_clk_out_28nm, // To Native PHY
	output          tx_serial_clk_out0_a10, // To Native PHY
	output          tx_serial_clk_out1_a10, // To Native PHY
	output          tx_serial_clk_out2_a10, // To Native PHY
	
	//clock to match as per has
 	input       gmii8b_mac_tx_clk_o,                            // from top
	
	//iopll 
	output permit_cal,
	output tx_digitalreset_iopll,
    
    // RX CDR Refclk
    input           rx_cdr_refclk_in_0,     // From User
   // input           rx_cdr_refclk_in_1,     // From User
    output   [RX_CDR_REFCLK_WIDTH-1:0]       rx_cdr_refclk_out_28nm, // To Native PHY
    output          rx_cdr_refclk_out0_a10, // To Native PHY
   // output          rx_cdr_refclk_out1_a10, // To Native PHY
    
    // TX PCS Clock
    input           tx_xgmii_coreclkin,     // From User
    input           tx_clkout_in,           // From Native PHY pllclock
	 input           tx_clkout_in_2,           // From Native PHY

    output          tx_clkout_out_pcs,      // To PCS
    output          tx_clkout_out_mac,      // To MAC
    output          tx_coreclkin_out_xcvr,  // To Native PHY
    
    // RX PCS Clock
    input           rx_xgmii_coreclkin,     // From User
    input           rx_clkout_in,           // From Native PHY
    output          rx_clkout_out_pcs,      // To PCS
    output          rx_clkout_out_mac,      // To MAC
	output          rx_coreclkin_out_xcvr,  // To Native PHY
    
    // RX PMA Clock (Sync-E)
	input           rx_pma_clkout_in,       // From Native PHY
	output          rx_pma_clkout_out,      // To User
    
    // Serial Loopback
    input           rx_seriallpbken_in,     // From PCS
    output          rx_seriallpbken_out,    // To Native PHY
    
    // Transceiver Mode from Reconfig
    input  [  1:0]  xcvr_mode_in,           // From User
    output [  1:0]  xcvr_mode_out,          // To PCS
//    
    // TX BASE-X PCS Data Path
//	input  [  1:0]  tx_basex_datak,         // From BASE-X PCS
//	input  [ 15:0]  tx_basex_parallel_data, // From BASE-X PCS
    
    // RX BASE-X PCS Data Path
//	output [  1:0]  rx_basex_datak,         // To BASE-X PCS
//	output [ 15:0]  rx_basex_parallel_data, // To BASE-X PCS
	
	 // TX BASE-X PCS Data Path
	
	input  [ 19:0]  tx_basex_parallel_data, // From BASE-X PCS
    
    // RX BASE-X PCS Data Path
	output [ 19:0]  rx_basex_parallel_data, // To BASE-X PCS
    
//    // RX BASE-X PCS Status
    output [  1:0]  rx_syncstatus_a10,      // To PCS
    output [  1:0]  rx_runningdisp_a10,     // To PCS
    output [  1:0]  rx_disperr_a10,         // To PCS
    output [  1:0]  rx_errdetect_a10,       // To PCS
    output [  1:0]  rx_patterndetect_a10,   // To PCS
    
//    // TX BASE-R PCS Data Path
	input  [  7:0]  tx_baser_control,       // From BASE-R PCS
	input  [ 63:0]  tx_baser_parallel_data, // From BASE-R PCS
	input           tx_baser_data_valid,    // From BASE-R PCS
//    
//    // RX BASE-R PCS Data Path
	output [  7:0]  rx_baser_control,       // To BASE-R PCS
	output [  1:0]  rx_baser_control_fec,   // To BASE-R PCS
	output [ 63:0]  rx_baser_parallel_data, // To BASE-R PCS
	output          rx_baser_data_valid,    // To BASE-R PCS
//    
//    // RX BASE-R PCS Status
    input           rx_enh_blk_lock_in,     // From Native PHY
    output          rx_enh_blk_lock_out,    // To User
    
//    // 28nm: Unused Signals
	output [ 25:0]  unused_tx_parallel_data_28nm,   // To Native PHY
    input  [ 35:0]  unused_rx_parallel_data_28nm,   // From Native PHY
    
//    // Arria 10: TX Data Path
	output reg [ 17:0]  tx_control_a10,         // To Native PHY
	output reg [127:0]  tx_parallel_data_a10,   // To Native PHY
    output reg          tx_enh_data_valid_out,  // To Native PHY
    
//    // Arria 10: RX Data Path
    input  [ 19:0]  rx_control_a10,         // From Native PHY
    input  [127:0]  rx_parallel_data_a10,   // From Native PHY
    input           rx_enh_data_valid_in,   // From Native PHY
	
	// SM: TX Data Path
	output [79:0]  tx_parallel_data_sm,   // To Native PHY
	
	// SM: RX Data Path
    input [79:0]  rx_parallel_data_sm,   // From Native PHY
    
//    // 10GBASE-R BER Checker
    input           rx_enh_highber_in,          // From Native PHY
    output          rx_enh_highber_clr_cnt_out, // To Native PHY
    output          rx_enh_clr_errblk_count_out, // To Native PHY
	
	// latency_sclk for Stratix 10
	input           latency_sclk,
	output          latency_sclk_to_xcvr,
	output          latency_sclk_to_pcs,
	
		
 // PTP deterministic latency sync pulses
   input    i_tx_dl_sync_pulse,
   output   o_rx_dl_sync_pulse,
   

	//DR ports
	input o_src_ch_pause_request,
	output i_src_ch_pause_grant,

		//DL ports
	
	input    det_lat_rx_async_dl_sync,
    input    det_lat_rx_async_pulse,
    input    det_lat_rx_async_sample_sync,
    input    det_lat_rx_sclk_sample_sync,
    input    det_lat_rx_trig_sample_sync,
    input    det_lat_tx_async_dl_sync,
    input    det_lat_tx_async_pulse,
    input    det_lat_tx_async_sample_sync,
    input    det_lat_tx_sclk_sample_sync,
    input    det_lat_tx_trig_sample_sync,
    input    xcvrif_rx_latency_pulse,
    input    xcvrif_tx_latency_pulse,
    output   det_lat_rx_dl_clk,
    output   det_lat_rx_mux_select,
    output   det_lat_rx_sclk_flop,
    output   det_lat_rx_sclk_gen_clk,
    output   det_lat_rx_trig_flop,
    output   det_lat_sampling_clk,
    output   det_lat_tx_dl_clk,
    output   det_lat_tx_mux_select,
    output   det_lat_tx_sclk_flop,
    output   det_lat_tx_sclk_gen_clk,
    output   det_lat_tx_trig_flop
    
);
    reg baser_path_ena;
    
    reg [ 19:0]  rx_control_a10_reg;
    reg [127:0]  rx_parallel_data_a10_reg;
    reg          rx_enh_data_valid_in_reg;
    
    reg [ 19:0]  rx_control_a10_reg2;
    reg [127:0]  rx_parallel_data_a10_reg2;
    reg          rx_enh_data_valid_in_reg2;
	
	reg [79:0]   rx_parallel_data_s10_reg;
	reg [79:0]   rx_parallel_data_s10_reg2;
	
	//cadence fifo
    wire [39:0] tbi4x_tx_d_out ;
    wire tx_4xtbi_tx_d_valid_sig;
    wire tx_fifo_full_sig,tx_fifo_rdempty_sig;
    wire [39:0] tbi4x_rx_d_sig ;
    wire rx_fifo_rd_pempty_sig;
	wire rx_4xtbi_rx_d_valid_sig;
	
	
wire        tx_dl_sync_pulse;
wire [ 1:0] tx_dl_sync_pulse_tx_efifo_out;
wire        rx_dl_sync_pulse_rx_efifo_out;
wire [ 1:0] tx_dl_sync_bit;
wire [ 1:0] rx_dl_sync_bit;

	 ftile_efifo_wrapper_top #(
            .ENABLE_TIMESTAMPING        (ENABLE_IEEE1588)
        ) fifo_wrapper (
                .i_tx_fifo_wclk     	 (tx_clkout_in_2),
	        .i_rx_fifo_wclk          (tx_clkout_in),
	        .i_tx_fifo_rclk          (tx_clkout_in),
	        .i_rx_fifo_rclk          (rx_clkout_in),
	        .i_tx_fifo_rst_n_async   (~ tx_digitalreset_to_xcvr_in),
	        .i_rx_fifo_rst_n_async   (~ rx_digitalreset_to_xcvr_in),
		.i_tx_2xtbi_datain  	 (tx_basex_parallel_data),
            	.i_tx_dl_sync_pulse         (tx_dl_sync_pulse),
                .o_tx_4xtbi_data	 (tbi4x_tx_d_out),
                .o_tx_4xtbi_wrdata_valid (tx_4xtbi_tx_d_valid_sig),
            	.o_tx_dl_sync_pulse         (tx_dl_sync_pulse_tx_efifo_out),
		.o_tx_fifo_rdempty       (tx_fifo_rdempty_sig), 
                .o_tx_fifo_full		 (tx_fifo_full_sig),
                .i_rx_4xtbi_data         (tbi4x_rx_d_sig),
            	.i_rx_dl_sync_pulse         (rx_dl_sync_bit),
                .i_rx_fifo_rd_en         (!rx_fifo_rd_pempty_sig),
                .i_rx_4xtbi_rd_data_valid(rx_4xtbi_rx_d_valid_sig),
                .o_rx_2xtbi_dataout      (rx_basex_parallel_data),
            	.o_rx_dl_sync_pulse         (rx_dl_sync_pulse_rx_efifo_out),
		.o_rx_fifo_rd_pempty     (rx_fifo_rd_pempty_sig)
	 ) ; 
    
    always @(posedge tx_clkout_in) begin
        baser_path_ena <= ((IS_1G_10G) || (IS_MGBASE_T) || (IS_10G_USXGMII)) && xcvr_mode_in[1];
    end
    
    // TX Reset
    assign tx_digitalreset_to_xcvr_out      = tx_digitalreset_to_xcvr_in;
    
    // RX Reset
    assign rx_digitalreset_to_xcvr_out      = rx_digitalreset_to_xcvr_in;
    
    // TX Serial Clock
    assign tx_serial_clk_out_28nm       = tx_serial_clk_in;
    assign tx_serial_clk_out0_a10       = tx_serial_clk_in[0];

     // phy reset 
	assign o_tx_rst = ~(i_rst_n && i_tx_rst_n);
    assign o_rx_rst = ~(i_rst_n && i_rx_rst_n);
	assign o_tx_rst_ack_n = ~i_tx_rst_ack;
	assign o_rx_rst_ack_n = ~i_rx_rst_ack;
	assign o_rst_ack_n = o_tx_rst_ack_n && o_rx_rst_ack_n;
	
     // ready assignments
       assign o_tx_ready = i_tx_ready;
       assign o_rx_ready = i_rx_ready;

	//iopll assignments
	
	assign permit_cal = i_tx_ready;
	assign tx_digitalreset_iopll = ~i_tx_ready;
    
    generate if(TX_SERIAL_CLK_WIDTH >= 2)
        begin : TX_SERIAL_CLK_WIDTH_GT_2
            assign tx_serial_clk_out1_a10 = tx_serial_clk_in[1];
        end
        else begin
            assign tx_serial_clk_out1_a10 = 1'b0;
        end
    endgenerate
    
    generate if(TX_SERIAL_CLK_WIDTH >= 3)
        begin : TX_SERIAL_CLK_WIDTH_GT_3
            assign tx_serial_clk_out2_a10 = tx_serial_clk_in[2];
        end
        else begin
            assign tx_serial_clk_out2_a10 = 1'b0;
        end
    endgenerate
    
    // RX CDR Refclk
    generate if(RX_CDR_REFCLK_WIDTH == 2)
        begin : RX_CDR_REFCLK
            assign rx_cdr_refclk_out_28nm = {rx_cdr_refclk_in_0, rx_cdr_refclk_in_0};
        end
        else begin
            assign rx_cdr_refclk_out_28nm = rx_cdr_refclk_in_0;
        end
    endgenerate
    
    assign rx_cdr_refclk_out0_a10       = rx_cdr_refclk_in_0;
    //assign rx_cdr_refclk_out1_a10       = rx_cdr_refclk_in_1;
    
    // TX PCS Clock
    assign tx_clkout_out_pcs            = tx_clkout_in_2;
    assign tx_clkout_out_mac            = tx_clkout_in_2;
    
    generate if(BASER_REG_MODE == 0 && (DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))
        begin : TX_BASER_REG_MODE
            alt_mge_phy_gf_clock_mux #(
                .num_clocks (2)
            ) tx_gf_clock_mux (
                .clk        ({tx_xgmii_coreclkin, tx_clkout_in}),
                .clk_select ({baser_path_ena, ~baser_path_ena}),
                .clk_out    (tx_coreclkin_out_xcvr)
            );
        end
        else begin
            assign tx_coreclkin_out_xcvr = tx_clkout_in;
        end
    endgenerate
    
    // RX PCS Clock
    assign rx_clkout_out_pcs            = rx_clkout_in;
    assign rx_clkout_out_mac            = tx_clkout_in; // Connected to tx_clkout since the RX data path has been rate matched
    
    generate if(BASER_REG_MODE == 0 && (DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))
        begin : RX_BASER_REG_MODE
            alt_mge_phy_gf_clock_mux #(
                .num_clocks (2)
            ) rx_gf_clock_mux (
                .clk        ({rx_xgmii_coreclkin, rx_clkout_in}),
                .clk_select ({baser_path_ena, ~baser_path_ena}),
                .clk_out    (rx_coreclkin_out_xcvr)
            );
        end
        else begin
            assign rx_coreclkin_out_xcvr = tx_clkout_in;
        end
    endgenerate
    
	// latency_sclk
	assign latency_sclk_to_pcs = (ENABLE_IEEE1588 == 1)? latency_sclk : 1'b0;
	assign latency_sclk_to_xcvr = (ENABLE_IEEE1588 == 1)? latency_sclk : 1'b0;
	
    // RX PMA Clock (Sync-E)
    assign rx_pma_clkout_out            = rx_pma_clkout_in;
    
    // Serial Loopback
    assign rx_seriallpbken_out          = rx_seriallpbken_in;
    
    // Transceiver Mode from Reconfig
    assign xcvr_mode_out                = xcvr_mode_in;
    
   


//    
//assign tx_parallel_data_s10 = {60'b0, tx_basex_parallel_data};
//assign rx_basex_parallel_data = rx_parallel_data_s10[19:0];
assign tx_parallel_data_sm    = {      1'b1,
                                                1'b0,
												 tx_dl_sync_bit[1],
                                                17'b0,
                                                tbi4x_tx_d_out[39:20],
                                                1'b0,
                                                tx_4xtbi_tx_d_valid_sig,
												tx_dl_sync_bit[0],
                                                17'b0,
                                                tbi4x_tx_d_out[19:0]};

assign tx_dl_sync_bit   = ENABLE_IEEE1588 ? tx_dl_sync_pulse_tx_efifo_out : 2'b00;
assign tx_dl_sync_pulse = ENABLE_IEEE1588 ? i_tx_dl_sync_pulse    : 1'b0;


assign tbi4x_rx_d_sig      = {rx_parallel_data_sm[59:40], rx_parallel_data_sm[19:0]};
 assign rx_4xtbi_rx_d_valid_sig = rx_parallel_data_sm[38];
  
assign o_rx_dl_sync_pulse = ENABLE_IEEE1588 ? rx_dl_sync_pulse_rx_efifo_out : 1'b0;
assign rx_dl_sync_bit     = ENABLE_IEEE1588 ? {rx_parallel_data_sm[77], rx_parallel_data_sm[37]} : 2'b00;


    // Bit position refer to Native PHY GUI message box
   // assign rx_basex_datak               = baser_path_ena ? 2'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[40], rx_parallel_data_a10_reg[8]} : {rx_parallel_data_s10_reg[24], rx_parallel_data_s10_reg[8]};
//    //assign rx_basex_parallel_data       = baser_path_ena ? 16'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[39:32], rx_parallel_data_a10_reg[7:0]} : {rx_parallel_data_s10_reg[23:16], rx_parallel_data_s10_reg[7:0]};
//    assign rx_baser_control             = baser_path_ena ? (((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? rx_control_a10_reg[7:0] : {rx_parallel_data_s10_reg[75:72],rx_parallel_data_s10_reg[35:32]}): 8'hFF;
//    assign rx_baser_control_fec         = baser_path_ena ? (((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? rx_control_a10_reg[9:8] : 2'b00): 2'b00;
//    assign rx_baser_parallel_data       = baser_path_ena ? (((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? rx_parallel_data_a10_reg[63:0] : {rx_parallel_data_s10_reg[71:40],rx_parallel_data_s10_reg[31:0]}) : {8{8'h07}};
//    assign rx_baser_data_valid          = baser_path_ena ? (((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? rx_enh_data_valid_in_reg : rx_parallel_data_s10_reg[36]): 1'b0;
//    
//    // RX BASE-X PCS Status
//    // Bit position refer to Native PHY GUI message box
//    assign rx_syncstatus_a10            = baser_path_ena ? 2'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[42], rx_parallel_data_a10_reg[10]} : {rx_parallel_data_s10_reg[26], rx_parallel_data_s10_reg[10]};
//    assign rx_runningdisp_a10           = baser_path_ena ? 2'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[47], rx_parallel_data_a10_reg[15]} : {rx_parallel_data_s10_reg[31], rx_parallel_data_s10_reg[15]};
//    assign rx_disperr_a10               = baser_path_ena ? 2'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[43], rx_parallel_data_a10_reg[11]} : {rx_parallel_data_s10_reg[27], rx_parallel_data_s10_reg[11]};
//    assign rx_errdetect_a10             = baser_path_ena ? 2'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[41], rx_parallel_data_a10_reg[9]} : {rx_parallel_data_s10_reg[25], rx_parallel_data_s10_reg[9]};
//    assign rx_patterndetect_a10         = baser_path_ena ? 2'h0 : ((DEVICE_FAMILY == "Arria 10" || DEVICE_FAMILY == "Cyclone 10 GX"))? {rx_parallel_data_a10_reg[44], rx_parallel_data_a10_reg[12]} : {rx_parallel_data_s10_reg[28], rx_parallel_data_s10_reg[12]};
//    
//    // RX BASE-R PCS Status
//    assign rx_enh_blk_lock_out          = baser_path_ena ? rx_enh_blk_lock_in : 1'b0;
//    
//    // 28nm: Unused Signals
//    assign unused_tx_parallel_data_28nm = 26'h0;
//    
//    // 10GBASE-R BER Checker
//    assign rx_enh_highber_clr_cnt_out   = 1'b0;
//    assign rx_enh_clr_errblk_count_out  = 1'b0;
//    
endmodule
