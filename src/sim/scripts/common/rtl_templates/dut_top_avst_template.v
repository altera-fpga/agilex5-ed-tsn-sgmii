

// Sample script generated dut_top with 2 instances of 25G.avalon_st IP
`timescale 1 ps / 1 ps

module dut_top #()
   
  (
    
    //inst0
		input  wire         i_clk_tx_ip0,
		input  wire         i_clk_rx_ip0,
                input  wire         i_clk_sys,
		input  wire	    i_refclk2pll,
		input  wire	    i_refclk2syspll,
		input  wire	    i_bk_refclk2pll,
		input  wire         i_reconfig_clk_ip0,          
		output wire         o_clk_pll_ip0,
		output wire         o_clk_tx_div_ip0, 									 
		output wire         o_clk_rec_div64_ip0,						 
		output wire         o_clk_rec_div_ip0,	                                     

		input  wire         i_rst_n_ip0,
		output wire         o_rst_ack_n_ip0,
		input  wire         i_tx_rst_n_ip0,              
		output wire         o_tx_rst_ack_n_ip0,              
		input  wire         i_rx_rst_n_ip0,              
		output wire         o_rx_rst_ack_n_ip0,              
    input  wire         i_mac_tx_rst_n_ip0,              
    input  wire         i_mac_rx_rst_n_ip0,              
    input  wire         i_mac_rst_n_ip0,              
    output wire         o_mac_tx_rst_ack_n_ip0,              
    output wire         o_mac_rx_rst_ack_n_ip0,              
    output wire         o_mac_rst_ack_n_ip0,              
	  input  wire         i_reconfig_reset_ip0,
		output wire         o_tx_lanes_stable_ip0,       
		output wire         o_rx_pcs_ready_ip0,

 		output wire         o_tx_pll_locked_ip0, 
   	output wire         o_cdr_lock_ip0,
     
		output wire         o_rx_block_lock_ip0,        
		output wire         o_rx_am_lock_ip0,   
   	output wire         o_local_fault_status_ip0, 
   	output wire         o_remote_fault_status_ip0, 
		input  wire         i_stats_snapshot_ip0,
   	output wire         o_rx_hi_ber_ip0,	
   	output wire         o_rx_pcs_fully_aligned_ip0, 

		input  wire [63:0]  i_tx_data_ip0,            
		input  wire         i_tx_valid_ip0,           
		input  wire [0:0]   i_tx_startofpacket_ip0,   
		input  wire [0:0]   i_tx_endofpacket_ip0,     
		input  wire [2:0]   i_tx_empty_ip0,           
		output wire         o_tx_ready_ip0,           
		input  wire         i_tx_error_ip0,
		input  wire         i_tx_skip_crc_ip0,
		input  wire         i_custom_cadence_ip0,
		output wire [0:0]   o_xcvrif_txfifo_pfull,
		output wire [0:0]   o_xcvrif_txfifo_pempty,
		output wire [0:0]   o_xcvrif_txfifo_empty,
		output wire [0:0]   o_xcvrif_hold_interrupt,
                input  wire   [7:0] i_tx_pfc_ip0,
		input  wire   [1:0] i_tx_pause_ip0,
		output  wire   [7:0] o_rx_pfc_ip0,
		output  wire         o_rx_pause_ip0,
		//input  wire [63:0]  i_tx_preamble_ip0, // for 40G/50G

		output wire [63:0]  o_rx_data_ip0,            
		output wire         o_rx_valid_ip0,           
		output wire         o_rx_startofpacket_ip0,   
		output wire         o_rx_endofpacket_ip0,     
		output wire [2:0]   o_rx_empty_ip0,           
		output wire [5:0]   o_rx_error_ip0,
		//output wire [63:0]  o_rx_preamble_ip0, // for 40G/50G
		output wire [39:0]  o_rx_status_data_ip0,
		output wire         o_rx_status_valid_ip0,
        input  wire         i_avalon_st_rx_ready_ip0,

		output wire         o_tx_serial_ip0,
		input  wire         i_rx_serial_ip0,
		output wire         o_tx_serial_n_ip0,
		input  wire         i_rx_serial_n_ip0,

        input  wire  [1:0]  i_xcvr_mode_ip0,
   	input  wire [19:0]  i_reconfig_eth_addr_ip0, 
   	input  wire         i_reconfig_eth_read_ip0, 
   	input  wire         i_reconfig_eth_write_ip0,
	input  wire [3:0]   i_reconfig_eth_byteenable_ip0,
   	input  wire [31:0]  i_reconfig_eth_writedata_ip0,
   	output wire [31:0]  o_reconfig_eth_readdata_ip0,
   	output wire         o_reconfig_eth_readdata_valid_ip0,
   	output wire         o_reconfig_eth_waitrequest_ip0,

    input  wire [9:0]   i_reconfig_eth_mac_addr_ip0, 
    input  wire         i_reconfig_eth_mac_read_ip0, 
    input  wire         i_reconfig_eth_mac_write_ip0,
	  input  wire [3:0]   i_reconfig_eth_mac_byteenable_ip0,
    input  wire [31:0]  i_reconfig_eth_mac_writedata_ip0,
    output wire [31:0]  o_reconfig_eth_mac_readdata_ip0,
   	output wire         o_reconfig_eth_mac_readdata_valid_ip0,
   	output wire         o_reconfig_eth_mac_waitrequest_ip0,
    input  wire [9:0]   i_reconfig_eth_rcfg_addr_ip0, 
    input  wire         i_reconfig_eth_rcfg_read_ip0, 
    input  wire         i_reconfig_eth_rcfg_write_ip0,
   	input  wire [3:0]   i_reconfig_eth_rcfg_byteenable_ip0,
    input  wire [31:0]  i_reconfig_eth_rcfg_writedata_ip0,
    output wire [31:0]  o_reconfig_eth_rcfg_readdata_ip0,
   	output wire         o_reconfig_eth_rcfg_readdata_valid_ip0,
   	output wire         o_reconfig_eth_rcfg_waitrequest_ip0,

    input wire i_clk_kr25g,
input wire i_reset_kr25g,

input wire [11:0]   i_kr_reconfig_addr_kr25g,
input wire          i_kr_reconfig_read_kr25g,
input wire          i_kr_reconfig_write_kr25g,
input wire [3:0]    i_kr_reconfig_byte_en_kr25g,
input wire [31:0]   i_kr_reconfig_writedata_kr25g,
output wire [31:0]  o_kr_reconfig_readdata_kr25g,
output wire         o_kr_reconfig_readdata_valid_kr25g,
output wire         o_kr_reconfig_waitrequest_kr25g,

    input  wire         i_reconfig_xcvr0_write_ip0,             
    input  wire         i_reconfig_xcvr0_read_ip0,               
    input  wire [19:0]  i_reconfig_xcvr0_address_ip0,         
    input  wire [3:0]   i_reconfig_xcvr0_byteenable_ip0,
    input  wire [31:0]  i_reconfig_xcvr0_writedata_ip0,     
    output wire [31:0]  o_reconfig_xcvr0_readdata_ip0,       
    output wire         o_reconfig_xcvr0_waitrequest_ip0, 
    output wire         o_reconfig_xcvr0_readdata_valid_ip0,       
   output wire          tx_digitalreset,
   output wire          rx_digitalreset

  );	

 reg rst_dut;
 initial begin
 assign rst_dut = i_tx_rst_n_ip0 & i_rx_rst_n_ip0;
 end
 assign i_avalon_st_rx_ready_ip0 = 'h1;

  //DM DUT TOP instantiation
    alt_mge_multi_channel #(
        .NUM_OF_CHANNEL                 (2)
    ) U_DUT (
 
    // Reference Clock
		.refclk_10g                     (refclk),    
		
        .csr_clk                        (i_reconfig_clk_ip0), 
	.avmm_rst_n                     (~i_reconfig_reset_ip0), 
        .mac32b_clk                     (mac32b_clk),  
        .mac64b_clk                     (mac64b_clk),  
    
        .reset                          (~rst_dut),
        .tx_digitalreset                (tx_digitalreset),
        .rx_digitalreset                (rx_digitalreset),
 
        // CSR
        .csr_mch_address                ({i_reconfig_eth_addr_ip0,2'b0}),
        //.csr_mch_address                (csr_address),
        .csr_mch_read                   (i_reconfig_eth_read_ip0),
        .csr_mch_write                  (i_reconfig_eth_write_ip0),
        .csr_mch_writedata              (i_reconfig_eth_writedata_ip0),
        .csr_mch_readdata               (o_reconfig_eth_readdata_ip0),
        .csr_mch_waitrequest            (o_reconfig_eth_waitrequest_ip0),    

 //XCVR
        .i_reconfig_xcvr0_address       (i_reconfig_xcvr0_address_ip0),
        .i_reconfig_xcvr0_read          (i_reconfig_xcvr0_read_ip0),
        .i_reconfig_xcvr0_write         (i_reconfig_xcvr0_write_ip0),
        .i_reconfig_xcvr0_writedata     (i_reconfig_xcvr0_writedata_ip0),
        .o_reconfig_xcvr0_readdata      (o_reconfig_xcvr0_readdata_ip0), 
        .o_reconfig_xcvr0_waitrequest   (o_reconfig_xcvr0_waitrequest_ip0),
        .o_reconfig_xcvr0_readdata_valid (o_reconfig_xcvr0_readdata_valid_ip0),
 
  //      .xcvr_mode                  (i_xcvr_mode_ip0),
        // MAC TX User Frame
        .avalon_st_tx_valid             (i_tx_valid_ip0),
        .avalon_st_tx_ready             (o_tx_ready_ip0),
        .avalon_st_tx_startofpacket     (i_tx_startofpacket_ip0),
        .avalon_st_tx_endofpacket       (i_tx_endofpacket_ip0),
        .avalon_st_tx_data              (i_tx_data_ip0),
        .avalon_st_tx_empty             (i_tx_empty_ip0),
        .avalon_st_tx_error             (i_tx_error_ip0),
    
        // MAC RX User Frame
        .avalon_st_rx_valid             (o_rx_valid_ip0),
        .avalon_st_rx_ready             (i_avalon_st_rx_ready_ip0),
        .avalon_st_rx_startofpacket     (o_rx_startofpacket_ip0),
        .avalon_st_rx_endofpacket       (o_rx_endofpacket_ip0),
        .avalon_st_rx_data              (o_rx_data_ip0),
        .avalon_st_rx_empty             (o_rx_empty_ip0),
        .avalon_st_rx_error             (o_rx_error_ip0),
    
        // MAC TX Frame Status
        .avalon_st_txstatus_valid       (),
        .avalon_st_txstatus_data        (),
        .avalon_st_txstatus_error       (),
    
        // MAC RX Frame Status
        .avalon_st_rxstatus_valid       (o_rx_status_valid_ip0),
        .avalon_st_rxstatus_data        (o_rx_status_data_ip0),
        .avalon_st_rxstatus_error       (),
        
        // MAC TX Pause Frame Generation Command
        .avalon_st_pause_data           (i_tx_pause_ip0),
    
        // MAC Status
        .xgmii_rx_link_fault_status     (),
    
        // PHY Status
        .led_an                         (),
        .rx_block_lock                  (o_rx_block_lock_ip0),
    
        // Transceiver Serial Interface
        .tx_serial_data                 ({o_tx_serial_ip0}),
        .rx_serial_data                 ({i_rx_serial_ip0}),
        .rx_pma_clkout                  (),
    
        // Data Path Readiness
        .channel_tx_ready               (o_tx_lanes_stable_ip0),
        .channel_rx_ready               (o_rx_pcs_ready_ip0)
        
    );
 
     

  
endmodule: dut_top

