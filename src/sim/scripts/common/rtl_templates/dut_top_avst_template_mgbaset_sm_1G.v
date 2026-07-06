

// Sample script generated dut_top with 2 instances of 25G.avalon_st IP
`timescale 1 ps / 1 ps

module dut_top #()
   
  (
    input               i_reconfig_clk_ip0,
    input               mac64b_clk,
    input               rx_digitalreset,
    input               tx_digitalreset,
    input  wire [9:0]   i_reconfig_eth_addr_ip0, 
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

    output wire         o_rx_block_lock_ip0,        
    input  wire         i_rst_n_ip0,
    output wire         o_rst_ack_n_ip0,
    input  wire         i_tx_rst_n_ip0,              
    input  wire         i_rx_rst_n_ip0,              
    output wire         o_tx_rst_ack_n_ip0,              
    output wire         o_rx_rst_ack_n_ip0,              
    input  wire         i_mac_tx_rst_n_ip0,              
    input  wire         i_mac_rx_rst_n_ip0,              
    input  wire         i_mac_rst_n_ip0,              
    output wire         o_mac_tx_rst_ack_n_ip0,              
    output wire         o_mac_rx_rst_ack_n_ip0,              
    output wire         o_mac_rst_ack_n_ip0,              
    input  wire  [1:0]  i_xcvr_mode_ip0,
    output wire         o_tx_serial_ip0,
    input  wire         i_rx_serial_ip0,
    output wire         o_tx_serial_n_ip0,
    input  wire         i_rx_serial_n_ip0,
    output wire         o_rx_is_lockedtodata_xcvr_ip0,       
    input  wire         i_reconfig_reset_ip0,
    input  wire         i_clk_tx_ip0,
    input  wire         i_clk_rx_ip0,
    input  wire         i_clk_sys,
    input  wire	        i_refclk2pll,
    input  wire	        i_refclk2syspll,
    input  wire	        i_bk_refclk2pll,
    output wire         o_clk_pll_ip0,
    output wire         o_clk_tx_div_ip0,
    output wire         o_clk_rec_div64_ip0,
    output wire         o_clk_rec_div_ip0,                            
    output wire         o_tx_lanes_stable_ip0,       
    output wire         o_rx_pcs_ready_ip0,
    output wire         o_rx_pcs_ready_ack_ip0,
    output wire         o_tx_pll_locked_ip0, 
    output wire         o_cdr_lock_ip0,
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
    output wire [7:0]   o_rx_pfc_ip0,
    output  wire        o_rx_pause_ip0,
    output wire [63:0]  o_rx_data_ip0,            
    output wire         o_rx_valid_ip0,           
    output wire         o_rx_startofpacket_ip0,   
    output wire         o_rx_endofpacket_ip0,     
    output wire [2:0]   o_rx_empty_ip0,           
    output wire [5:0]   o_rx_error_ip0,
    output wire [39:0]  o_rx_status_data_ip0,
    output wire         o_rx_status_valid_ip0,
    input  wire         i_avalon_st_rx_ready_ip0,
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
    output wire         o_reconfig_xcvr0_readdata_valid_ip0
    );

  wire flux_clk;
  wire sss_req;
  wire sss_grant;
  wire system_pll_clk;
  wire system_pll_lock;
  reg reset;
  reg clk_156_25;
  initial begin
      assign reset = i_mac_tx_rst_n_ip0 ;
  end

  initial clk_156_25 = 1'b0;
  always #3200 clk_156_25 = ~clk_156_25;
  assign mac64b_clk = clk_156_25; 

  assign i_avalon_st_rx_ready_ip0 = 'h1;

alt_mge_mac_wrapper U_DUT (
            
            // CSR Clock
            .csr_clk                    (i_reconfig_clk_ip0),
            // MAC User Clock
            .mac_clk                    (mac64b_clk),
            // Reset
            .reset                      (~reset),
            .tx_digitalreset            (~i_mac_tx_rst_n_ip0),
            .rx_digitalreset            (~i_mac_rx_rst_n_ip0),
             // MAC CSR
            .csr_mac_address            (i_reconfig_eth_mac_addr_ip0),
            .csr_mac_read               (i_reconfig_eth_mac_read_ip0),
            .csr_mac_write              (i_reconfig_eth_mac_write_ip0),
            .csr_mac_writedata          (i_reconfig_eth_mac_writedata_ip0),
            .csr_mac_readdata           (o_reconfig_eth_mac_readdata_ip0),
            .csr_mac_waitrequest        (o_reconfig_eth_mac_waitrequest_ip0),
            // PHY CSR
            .csr_phy_address            (i_reconfig_eth_addr_ip0),
            .csr_phy_read               (i_reconfig_eth_read_ip0),
            .csr_phy_write              (i_reconfig_eth_write_ip0),
            .csr_phy_writedata          (i_reconfig_eth_writedata_ip0),
            .csr_phy_readdata           (o_reconfig_eth_readdata_ip0),
            .csr_phy_waitrequest        (o_reconfig_eth_waitrequest_ip0),
            // PHY Status
            .led_an                      (),
            .led_char_err                (),
            .led_disp_err                (),
            .led_link                    (),
           //   led_panel_link                   (), // TODO : Once DE_TEAM
            //   add it for 1G2P5G 16BIT(NON-SGMII) mode enable it back
            // .rx_block_lock                  (o_rx_block_lock_ip0), // TODO:
            // enable for USXGMII 
 
            .o_src_ch_pause_request     (0),
            .i_src_ch_pause_grant       (), 
             //RST
            .i_rst_n                     (i_rst_n_ip0),
            .o_rst_ack_n                 (o_rst_ack_n_ip0),
            .i_tx_rst_n                  (i_tx_rst_n_ip0),
            .i_rx_rst_n                  (i_rx_rst_n_ip0),
            .o_tx_rst_ack_n              (o_tx_rst_ack_n_ip0),
            .o_rx_rst_ack_n              (o_rx_rst_ack_n_ip0),
            .i_mac_tx_rst_n              (i_mac_tx_rst_n_ip0),
            .i_mac_rx_rst_n              (i_mac_rx_rst_n_ip0),
            .o_mac_tx_rst_ack_n          (o_mac_tx_rst_ack_n_ip0),
            .o_mac_rx_rst_ack_n          (o_mac_rx_rst_ack_n_ip0),
            .o_mac_rst_ack_n             (o_mac_rst_ack_n_ip0), 
            //CDR and FLUX clk 
            .refclk                  (refclk),
            .refclk_n                (~refclk),
            // PHY Operating Mode from Reconfig Block
            .xcvr_mode                  (i_xcvr_mode_ip0),
            .flux_clk                   (flux_clk),
            .sss_grant                  (sss_grant),
            .sss_req                    (sss_req),
            .tx_serial_data              (o_tx_serial_ip0),
            .rx_serial_data              (i_rx_serial_ip0),
            .tx_serial_data_n            (o_tx_serial_n_ip0),
            .rx_serial_data_n            (i_rx_serial_n_ip0),
            //Transceiver status 
            .rx_is_lockedtodata             (o_rx_is_lockedtodata_xcvr_ip0), 
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
            .channel_tx_ready               (o_tx_lanes_stable_ip0),
            .channel_rx_ready               (o_rx_pcs_ready_ip0),
            .system_pll_clk                 (system_pll_clk),          
		        .system_pll_lock                 (system_pll_lock),          
            // Transceiver Reconfiguration
            .reconfig_clk               (i_reconfig_clk_ip0),
            .reconfig_reset             (i_reconfig_reset_ip0),
            .reconfig_write             (i_reconfig_eth_rcfg_write_ip0),
            .reconfig_read              (i_reconfig_eth_rcfg_read_ip0),
            .reconfig_address           (i_reconfig_eth_rcfg_addr_ip0),
            .reconfig_be                (i_reconfig_eth_rcfg_byteenable_ip0), 
            .reconfig_writedata         (i_reconfig_eth_rcfg_writedata_ip0),
            .reconfig_readdata          (o_reconfig_eth_rcfg_readdata_ip0),
            .reconfig_waitrequest       (o_reconfig_eth_rcfg_waitrequest_ip0),
            .reconfig_readdata_valid    (o_reconfig_eth_rcfg_readdata_valid_ip0)  
        );
        
intel_src_sss sss_src(
     .o_src_rs_grant(sss_grant), //check with DPHY VAl
     .i_src_rs_priority(1'b1),
     .i_src_rs_req(sss_req),
     .o_pma_cu_clk(flux_clk)
 );
                

intel_systemclk_gts sys_pll(
     .o_syspll_c0(system_pll_clk),  
		 .o_pll_lock (system_pll_lock),     //  output,  width = 1,   o_pll_lock.o_pll_lock
     .i_refclk(refclk),    
     .i_refclk_ready(1'b1)
     
 );  
  
endmodule: dut_top

