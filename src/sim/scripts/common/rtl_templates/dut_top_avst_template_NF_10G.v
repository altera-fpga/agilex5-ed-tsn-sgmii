

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
                input  wire [7:0]   i_tx_pfc_ip0,
		input  wire [1:0]   i_tx_pause_ip0,
		output  wire[7:0]   o_rx_pfc_ip0,
		output  wire        o_rx_pause_ip0,
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

          	input  wire [19:0]  i_reconfig_eth_addr_ip0, 
          	input  wire         i_reconfig_eth_read_ip0, 
          	input  wire         i_reconfig_eth_write_ip0,
                input  wire [3:0]   i_reconfig_eth_byteenable_ip0,
          	input  wire [31:0]  i_reconfig_eth_writedata_ip0,
          	output wire [31:0]  o_reconfig_eth_readdata_ip0,
          	output wire         o_reconfig_eth_readdata_valid_ip0,
          	output wire         o_reconfig_eth_waitrequest_ip0,
                input wire          i_clk_kr25g,
                input wire          i_reset_kr25g,

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

 reg clk_156_25 =0;
 always 
  begin 
    #3200ps clk_156_25= ~clk_156_25;
  end

 reg rst_dut;
 initial begin
 assign rst_dut = i_tx_rst_n_ip0 & i_rx_rst_n_ip0;
 end
 assign i_avalon_st_rx_ready_ip0 = 'h1;

  //DM DUT TOP instantiation
    altera_swip_eth_1g10g_mac_phy_de_wrapper #(
        .NUM_OF_CHANNEL                 (1)
    ) U_DUT_WRAPPER (
        .avalon_mm_csr_clk          (clk_156_25),
        .avalon_st_rx_clk           (clk_156_25),
        .avalon_st_tx_clk           (clk_156_25),
        .ref_clk                    (clk_156_25),    
        .reset                      (~rst_dut),
        
         // CSR
        .csr_address                (i_reconfig_eth_addr_ip0),
        .csr_read                   (i_reconfig_eth_read_ip0),
        .csr_readdata               (o_reconfig_eth_readdata_ip0),
        .csr_write                  (i_reconfig_eth_write_ip0),
        .csr_writedata              (i_reconfig_eth_writedata_ip0),
        .csr_waitrequest            (o_reconfig_eth_waitrequest_ip0),    
        .csr_burstcount              (),
        .csr_byteenable              (),
        .csr_debugaccess             (),

        // MAC TX User Frame
        .avalon_st_tx_sink_data     (i_tx_data_ip0),
        .avalon_st_tx_sink_sop      (i_tx_startofpacket_ip0),
        .avalon_st_tx_sink_eop      (i_tx_endofpacket_ip0),
        .avalon_st_tx_sink_empty    (i_tx_empty_ip0),
        .avalon_st_tx_sink_ready    (o_tx_ready_ip0),
        .avalon_st_tx_sink_valid    (i_tx_valid_ip0),
        .avalon_st_tx_sink_error    (i_tx_error_ip0),
    
        // MAC RX User Frame
        .avalon_st_rx_src_data      (o_rx_data_ip0),
        .avalon_st_rx_src_sop       (o_rx_startofpacket_ip0),
        .avalon_st_rx_src_eop       (o_rx_endofpacket_ip0),
        .avalon_st_rx_src_empty     (o_rx_empty_ip0),
        .avalon_st_rx_src_ready     (i_avalon_st_rx_ready_ip0),
        .avalon_st_rx_src_valid     (o_rx_valid_ip0),
        .avalon_st_rx_src_error     (o_rx_error_ip0),
    
        .xcvr_atx_pll_a10_0_pll_locked_pll_locked(o_tx_lanes_stable_ip0),
        `ifdef ETH_NF_1G 
          .rx_syncstatus(o_rx_pcs_ready_ip0),
         `else
          .xcvr_10gkr_a10_0_rx_data_ready_export(o_rx_pcs_ready_ip0),
         `endif
        // Transceiver Serial Interface
          `ifdef ETH_NF_1G 
            .sgmii_tx_out                 ({o_tx_serial_ip0}),
            .sgmii_rx_in                  ({i_rx_serial_ip0})
           `else
            .xg_base_r_tx_out             (o_tx_serial_ip0),
            .xg_base_r_rx_in              (i_rx_serial_ip0)
          `endif

         );
 
     

  
endmodule: dut_top

