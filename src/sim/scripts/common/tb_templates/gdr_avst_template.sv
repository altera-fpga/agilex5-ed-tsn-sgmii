


///////////////
// start DUT <NUM_INST> wires
///////////////

   logic reset_ip0; 
   wire  clk_ip0;

   wire       clk_tx_ip0;
   wire       clk_rx_ip0;
   wire       reconfig_clk_ip0;
   wire       clk_pll_ip0;
   wire       clk_tx_div_ip0;
   wire       clk_rec_div64_ip0;
   wire       clk_rec_div_ip0;  
   logic      clk_ref_ip0=0;       
   logic      clk_sys_ip0=0;       
   logic      clk_125=0; 

   logic      clk_status_ip0=0;
   
   reg  	    rst_n_ip0;
   wire       rst_ack_n_ip0;
   reg  	    tx_rst_n_ip0;
   wire       tx_rst_ack_n_ip0;
   reg  	    rx_rst_n_ip0;
   wire       rx_rst_ack_n_ip0;
   reg  	    mac_tx_rst_n_ip0;
   wire       mac_tx_rst_ack_n_ip0;
   reg  	    mac_rx_rst_n_ip0;
   wire       mac_rx_rst_ack_n_ip0;
   reg  	    mac_rst_n_ip0;
   wire       mac_rst_ack_n_ip0;
   logic 		  reconfig_reset_ip0;    
   wire 		  tx_lanes_stable_ip0;    
   wire 		  rx_pcs_ready_ip0;    
   wire 		  rx_pcs_ready_ack_ip0;    
   wire           rx_pause_ip0;

   wire 		  tx_pll_locked_ip0;    
   wire 		  cdr_locked_ip0;    
   
   wire  	    rx_block_lock_ip0;              
   wire 			rx_am_lock_ip0;            
   wire 			local_fault_status_ip0;            
   wire 			remote_fault_status_ip0;            
   reg  	    stats_snapshot_ip0;
   wire 			rx_hi_ber_ip0;            
   wire 			rx_pcs_fully_aligned_ip0;            
   
   reg [63:0] tx_data_ip0; 
   reg 	      tx_valid_ip0;
   reg 	      tx_startofpacket_ip0;
   reg 	      tx_endofpacket_ip0;
   reg [2:0] 	tx_empty_ip0;
   reg [1:0]  xcvr_mode_ip0;
   reg  	    tx_ready_ip0;
   reg  	    tx_error_ip0;
   reg  	    tx_skip_crc_ip0;
   reg              custom_cadence_ip0;
   reg [7:0]        i_tx_pfc_ip0;
   reg [1:0]	    i_tx_pause_ip0;
   //reg [63:0] tx_preamble_ip0; //// RAMI-REF - Only when AVST, preamble pass through enabled and spee is 40/50g

   reg [63:0] rx_data_ip0; // 64 for 10/25G; 128 for 50G; 512 for 100G
   reg 	      rx_valid_ip0;
   reg 	      rx_startofpacket_ip0;
   reg 	      rx_endofpacket_ip0;
   reg [2:0] 	rx_empty_ip0;
   reg [5:0]  rx_error_ip0;
   reg [39:0] rx_status_data_ip0;
   reg  	    rx_status_valid_ip0;
   //reg [63:0] rx_preamble_ip0; //// RAMI-REF - Only when AVST, preamble pass through enabled and spee is 40/50g

  
   reg  	     reconfig_eth_write_ip0;         
   reg  	     reconfig_eth_read_ip0;
   reg  [3:0]        reconfig_eth_byteenable_ip0;
   reg  [19:0] reconfig_eth_addr_ip0;       
   reg  [31:0] reconfig_eth_writedata_ip0;     
   wire [31:0] reconfig_eth_readdata_ip0;      
   wire 	     reconfig_eth_waitrequest_ip0;   
   wire 	     reconfig_eth_readdata_valid_ip0; 

   reg  	     reconfig_xcvr0_write_ip0;         
   reg  	     reconfig_xcvr0_read_ip0;          
   reg  [3:0]    reconfig_xcvr0_byteenable_ip0;          
   reg  [19:0] reconfig_xcvr0_address_ip0;       
   reg  [31:0] reconfig_xcvr0_writedata_ip0;     
   wire [31:0] reconfig_xcvr0_readdata_ip0;
   wire 	     reconfig_xcvr0_waitrequest_ip0;   
   wire 	     reconfig_xcvr0_readdata_valid_ip0;
   wire       i_clk_sys;
   wire [0:0] xcvrif_txfifo_pfull;
   wire [0:0] xcvrif_txfifo_pempty;
   wire [0:0] xcvrif_txfifo_empty;
   wire [0:0] xcvrif_hold_interrupt;
//   wire       tx_tod_clk,rx_tod_clk; //for PTP
///////////////
// end DUT port wires 
///////////////

///////////////
// start SM DUT <NUM_INST> wires
///////////////
   reg  	     reconfig_eth_mac_write_ip0;         
   reg  	     reconfig_eth_mac_read_ip0;
   reg  [3:0]  reconfig_eth_mac_byteenable_ip0;
   reg  [19:0] reconfig_eth_mac_addr_ip0;       
   reg  [31:0] reconfig_eth_mac_writedata_ip0;     
   wire [31:0] reconfig_eth_mac_readdata_ip0;      
   wire 	     reconfig_eth_mac_waitrequest_ip0;   
   wire 	     reconfig_eth_mac_readdata_valid_ip0; 

   reg  	     reconfig_eth_rcfg_write_ip0;         
   reg  	     reconfig_eth_rcfg_read_ip0;
   reg  [3:0]  reconfig_eth_rcfg_byteenable_ip0;
   reg  [19:0] reconfig_eth_rcfg_addr_ip0;       
   reg  [31:0] reconfig_eth_rcfg_writedata_ip0;     
   wire [31:0] reconfig_eth_rcfg_readdata_ip0;      
   wire 	     reconfig_eth_rcfg_waitrequest_ip0;   
   wire 	     reconfig_eth_rcfg_readdata_valid_ip0;
///////////////
// end SM DUT port wires 
///////////////


`include "basic_test_params_ip0.v"

   //// RAMI-FIX Do we need to do this for all speed per instance
   //defparam dut.sim_mode           = "enable";
   //defparam dut.ip0.sim_mode           = "enable";
   //defparam dut.ip0.tx_am_period    = "sim_only_am_period";
   //defparam dut.ip0.rx_am_interval  = "sim_only_am_interval";

 // Need to set these hierarchies per ip
 // PATH-FIX: `define GDR_RX_MAC_IP0 dut.ip0.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.u_rx_mac
 // PATH-FIX: `define GDR_TX_MAC_IP0 dut.ip0.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.u_tx_mac
 // PATH-FIX: `define GDR_XCVR_IP0 dut.ip0.alt_ehipc3_hard_inst.Dynamic_Reconfig.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp

   `define ETH_DUT_INST_PATH eth_env_top.dut.U_DUT.u_channel.mac 
   `define ETH_MAC_INST_PATH eth_env_top.dut.U_DUT.u_channel.mac.alt_eth_top
   `define ETH_COV_DUT_CSR eth_env_top.dut.U_DUT.u_channel.mac.alt_eth_top.alt_em10g32unit_inst.creg_top_inst 

   `ifndef ENABLE_ETH_VIP
   //Chintan : Changing parameter value only in loopback mode as VIP doesn't support CRC cover preamble feature
   //defparam dut.ip0.rxcrc_covers_preamble = `rxcrc_covers_preamble_ip0 ? "enable" : "disable";  //RAMI-FIX `rxcrc_covers_preamble_ip0 not there in basic_test_params
   //defparam dut.ip0.txcrc_covers_preamble = `txcrc_covers_preamble_ip0 ? "enable" : "disable";  //RAMI-FIX `txcrc_covers_preamble_ip0 not there in basic_test_params
   `endif
		
// defparam eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.genblk1.ncssblk.n_channel_superset_ip_inst.n_channel_superset_ip.hal_top_wrapper_inst.hal_top_ip.one_lane_inst_0.one_lane_hal_top_p0.pcs_hal_top_inst.pcs_hal_top.ch_pcs_dr_enabled_atom="DR_ENABLED_DR_DISABLED";
// defparam eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.genblk1.ncssblk.n_channel_superset_ip_inst.n_channel_superset_ip.hal_top_wrapper_inst.hal_top_ip.one_lane_inst_0.one_lane_hal_top_p0.genblk1.pldif_hal_top_inst.pldif_hal_top.pldif_hal_coreip_inst.ch4_pldif_inst.x_std_sm_hssi_pld_chnl_dp_0__tx_fifo_width = "TX_FIFO_WIDTH_SINGLE_WIDTH";
   //---------------------------------------------------------------------------
   //  UVC Instances 
   //---------------------------------------------------------------------------
   altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_ip0 (
								  .clk                       (reconfig_clk_ip0),
								  .reset                     (reconfig_reset_ip0)
								  );
   altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,		
			  .IS_ACTIVE                 (UVM_ACTIVE),
			  .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
			  ) avmm_rtb_ip0 (.uif(avmm_if_ip0));

   initial begin
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_rtb_path","avmm_rtb_ip0");
   end
// AVMM default


   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 (
	 		            .clk                       (clk_status_ip0),
	 		            .reset                     (reconfig_reset_ip0)
               );
   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,
           .IS_ACTIVE                 (UVM_ACTIVE),
           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
               ) avmm_xcvr_rtb_ip0_0 (.uif(avmm_xcvr_if_ip0_0));

   initial begin        
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");
   end            


	 reset_if reset_if_ip0();
	 initial begin
	    uvm_config_db #(virtual reset_if)::set (null, "*env_ip0", "slv_if", reset_if_ip0); 
	 end

 `ifdef ENABLE_ETH_VIP
 
/*
   // RAMI-FIX Do this for 100G and 100G w/FEC
   initial begin
        ts_tasks_if[0].event_xsbi_do_err_loaded = svt_ethernet_drv_0.Bfm.event_xsbi_do_err_loaded; 
        `ifdef RSFEC
        ts_tasks_if[0].event_kr4_fec_do_err_loaded = svt_ethernet_drv_0.Bfm.event_kr4_fec_do_err_loaded; 
        ts_tasks_if[0].event_load_align_marker_error = svt_ethernet_drv_0.Bfm.event_load_align_marker_error; 
        ts_tasks_if[0].event_rs_error_inserted = svt_ethernet_drv_0.Bfm.event_rs_error_inserted; 
        ts_tasks_if[0].event_kr4_fec_cw_transmitted = svt_ethernet_drv_0.Bfm.event_kr4_fec_cw_transmitted; 
        ts_tasks_if[0].event_kr4_fec_align4_insert = svt_ethernet_drv_0.Bfm.event_kr4_fec_align4_insert; 
        `endif
   end
*/

   initial begin
     //DM_Todo: Uncomment it
     /*
     ts_tasks_if[0].event_load_align_marker_error    = svt_ethernet_drv_0.Bfm.event_load_align_marker_error; //Alex: added for pcs_am_lock sequencce support 
     spy_if_ip0.event_mac_idle_detected_rx           = svt_ethernet_mon_chk_0.Chk.event_mac_idle_detected_rx;
     spy_if_ip0.event_chk_no_eop_tx                  = svt_ethernet_mon_chk_0.Chk.event_chk_no_term_char_found_tx;
     ts_tasks_if[0].event_10g_multilane_insert_align_block = svt_ethernet_drv_0.Bfm.multilane_10g.event_insert_align_block; 
     ts_tasks_if[0].event_10g_multilane_insert_66b_block   = svt_ethernet_drv_0.Bfm.event_10g_multilane_insert_66b_block;  
     ts_tasks_if[0].event_xsbi_66b_block_loaded = svt_ethernet_drv_0.Bfm.event_xsbi_66b_block_loaded; // added for pcs_err_druing_lock sequence 25G
     ts_tasks_if[0].event_insert_xxvsbi_align_marker    = svt_ethernet_drv_0.Bfm.event_insert_xxvsbi_align_marker; //added for pcs_wrong_am_interval sequence 25G
      */

     //**************************Ported covergroup signals
     // TODO Add the signals based on the variants
    `ifdef ETH_MULTI_PORT 
     assign spy_if_ip0.sig_avalon_st_pause_data =  `ETH_DUT_INST_PATH.avalon_st_pause_data;
     assign spy_if_ip0.tx_pausefrm_en =  `ETH_COV_DUT_CSR.tx_pausefrm_en;
     assign spy_if_ip0.tx_pausefrm_policy = `ETH_COV_DUT_CSR.tx_pausefrm_policy;
     assign spy_if_ip0.tx_pad_insrt_en = `ETH_COV_DUT_CSR.tx_pad_insrt_en;
     assign spy_if_ip0.tx_pausefrm_xonxoff=  `ETH_COV_DUT_CSR.tx_pausefrm_xonxoff;
     assign spy_if_ip0.tx_crc_insrt_en =  `ETH_COV_DUT_CSR.tx_crc_insrt_en;
     assign spy_if_ip0.pfc_priority_num = `ETH_COV_DUT_CSR.pfc_priority_num;
     assign spy_if_ip0.enable_preamble_passthrough = `ETH_COV_DUT_CSR.enable_preamble_passthrough;
     assign spy_if_ip0.tx_sa_override_en = `ETH_COV_DUT_CSR.tx_sa_override_en;
     assign spy_if_ip0.tx_pipg_10g_dic = `ETH_COV_DUT_CSR.tx_pipg_10g_dic;
     assign spy_if_ip0.status_tx_datafrm_tsfr_en_sts = `ETH_COV_DUT_CSR.status_tx_datafrm_tsfr_en_sts;
     assign spy_if_ip0.tx_xoff_hqt0 = `ETH_COV_DUT_CSR.tx_xoff_hqt0;
     assign spy_if_ip0.tx_xoff_hqt1 = `ETH_COV_DUT_CSR.tx_xoff_hqt1;
     assign spy_if_ip0.tx_xoff_hqt2 = `ETH_COV_DUT_CSR.tx_xoff_hqt2;
     assign spy_if_ip0.tx_xoff_hqt3 = `ETH_COV_DUT_CSR.tx_xoff_hqt3;
     assign spy_if_ip0.tx_xoff_hqt4 = `ETH_COV_DUT_CSR.tx_xoff_hqt4; 
     assign spy_if_ip0.tx_xoff_hqt5 = `ETH_COV_DUT_CSR.tx_xoff_hqt5; 
     assign spy_if_ip0.tx_xoff_hqt6 = `ETH_COV_DUT_CSR.tx_xoff_hqt6; 
     assign spy_if_ip0.tx_xoff_hqt7 = `ETH_COV_DUT_CSR.tx_xoff_hqt7;
     assign spy_if_ip0.rx_frm_ctl = `ETH_COV_DUT_CSR.alt_em10g32_creg_map_inst.rx_frm_ctl;
     assign spy_if_ip0.rx_crcpad_ctl = `ETH_COV_DUT_CSR.alt_em10g32_creg_map_inst.rx_crcpad_ctl;
     assign spy_if_ip0.rx_preamb_passthru_en = `ETH_COV_DUT_CSR.alt_em10g32_creg_map_inst.rx_preamb_passthru_en;
     assign spy_if_ip0.csr_rx_crc_chk = `ETH_COV_DUT_CSR.csr_rx_crc_chk;
     assign spy_if_ip0.tx_pfcfrm_pqt0 = `ETH_COV_DUT_CSR.tx_pfcfrm_pqt0;
     assign spy_if_ip0.tx_pfcfrm_en0 = `ETH_COV_DUT_CSR.tx_pfcfrm_en0;
     assign spy_if_ip0.csr_rx_tsfr_sts = `ETH_MAC_INST_PATH.alt_em10g32unit_inst.csr_rx_tsfr_sts;
     assign spy_if_ip0.csr_rx_tsfr_en_n = `ETH_MAC_INST_PATH.alt_em10g32unit_inst.csr_rx_tsfr_en_n;
     assign spy_if_ip0.csr_tx_tsfr_en_n = `ETH_MAC_INST_PATH.alt_em10g32unit_inst.csr_tx_tsfr_en_n;
     assign spy_if_ip0.csr_rx_pfc_ignore_pausefrm_1 =  `ETH_MAC_INST_PATH.alt_em10g32unit_inst.csr_rx_pfc_ignore_pausefrm_1;
     assign spy_if_ip0.csr_rx_pfc_fwd = `ETH_MAC_INST_PATH.alt_em10g32unit_inst.csr_rx_pfc_fwd;
     assign spy_if_ip0.sig_speed_sel_en = `ETH_MAC_INST_PATH.speed_sel;
     assign spy_if_ip0.sig_avalon_st_pause_data = `ETH_MAC_INST_PATH.avalon_st_pause_data;
     assign spy_if_ip0.sig_avalon_st_tx_pause_length_data = `ETH_MAC_INST_PATH.avalon_st_tx_pause_length_data;
     assign spy_if_ip0.sig_avalon_st_tx_pause_length_valid = `ETH_MAC_INST_PATH.avalon_st_tx_pause_length_valid;
     assign spy_if_ip0.sig_xgmii_tx = `ETH_MAC_INST_PATH.xgmii_tx;
     assign spy_if_ip0.sig_gmii_tx_en =   `ETH_MAC_INST_PATH.gmii_tx_en;
     assign spy_if_ip0.sig_gmii16b_tx_en = `ETH_MAC_INST_PATH.gmii16b_tx_en;
     assign spy_if_ip0.sig_avalon_st_tx_pfc_status_data = `ETH_MAC_INST_PATH.avalon_st_tx_pfc_status_data;
     assign spy_if_ip0.sig_avalon_st_tx_pfc_status_valid = `ETH_MAC_INST_PATH.avalon_st_tx_pfc_status_valid;
     assign spy_if_ip0.sig_avalon_st_tx_pfc_gen_data = `ETH_MAC_INST_PATH.avalon_st_tx_pfc_gen_data[15:0];
     assign spy_if_ip0.sig_avalon_st_txstatus_valid =   `ETH_MAC_INST_PATH.avalon_st_txstatus_valid;
     assign spy_if_ip0.sig_avalon_st_txstatus_error = `ETH_MAC_INST_PATH.avalon_st_txstatus_error;
     assign spy_if_ip0.sig_avalon_st_txstatus_data =  `ETH_MAC_INST_PATH.avalon_st_txstatus_data;
     assign spy_if_ip0.sig_avalon_st_tx_error =  `ETH_MAC_INST_PATH.avalon_st_tx_error;
     assign spy_if_ip0.sig_avalon_st_tx_valid =   `ETH_MAC_INST_PATH.avalon_st_tx_valid;
     assign spy_if_ip0.sig_avalon_st_tx_endofpacket = `ETH_MAC_INST_PATH.avalon_st_tx_endofpacket;
     assign spy_if_ip0.sig_avalon_st_rx_pause_length_data =   `ETH_MAC_INST_PATH.avalon_st_rx_pause_length_data;
     assign spy_if_ip0.sig_avalon_st_rx_pause_length_valid = `ETH_MAC_INST_PATH.avalon_st_rx_pause_length_valid;
     assign spy_if_ip0.sig_avalon_st_rx_error = `ETH_MAC_INST_PATH.avalon_st_rx_error;
     assign spy_if_ip0.sig_avalon_st_rxstatus_valid =  `ETH_MAC_INST_PATH.avalon_st_rxstatus_valid;
     assign spy_if_ip0.sig_avalon_st_rxstatus_error = `ETH_MAC_INST_PATH.avalon_st_rxstatus_error;
     assign spy_if_ip0.sig_avalon_st_rx_valid = `ETH_MAC_INST_PATH.avalon_st_rx_valid;
     assign spy_if_ip0.sig_avalon_st_rx_endofpacket = `ETH_MAC_INST_PATH.avalon_st_rx_endofpacket;
     assign spy_if_ip0.sig_avalon_st_rxstatus_error = `ETH_MAC_INST_PATH.avalon_st_rxstatus_error;
     assign spy_if_ip0.sig_avalon_st_rxstatus_valid = `ETH_MAC_INST_PATH.avalon_st_rxstatus_valid;
     assign spy_if_ip0.sig_gmii_rx_err = `ETH_MAC_INST_PATH.gmii_rx_err;
     assign spy_if_ip0.sig_mii_rx_err = `ETH_MAC_INST_PATH.mii_rx_err;
     assign spy_if_ip0.sig_avalon_st_rx_ready = `ETH_MAC_INST_PATH.avalon_st_rx_ready;
     assign spy_if_ip0.sig_link_fault_status_xgmii_rx_data =  `ETH_MAC_INST_PATH.link_fault_status_xgmii_rx_data;
     assign spy_if_ip0.sig_avalon_st_rx_pfc_pause_data = `ETH_MAC_INST_PATH.avalon_st_rx_pfc_pause_data[7:0];
     assign spy_if_ip0.xgmii_tx_valid =  `ETH_MAC_INST_PATH.xgmii_tx_valid;
     assign spy_if_ip0.xgmii_rx_valid =  `ETH_MAC_INST_PATH.xgmii_rx_valid;
     assign spy_if_ip0.xgmii_tx_valid =  `ETH_DUT_INST_PATH.xgmii_tx_valid;
     assign spy_if_ip0.xgmii_rx_valid =  `ETH_DUT_INST_PATH.xgmii_rx_valid;
     assign spy_if_ip0.xgmii_rx_data = `ETH_DUT_INST_PATH.xgmii_rx_data;
     assign spy_if_ip0.xgmii_tx_data = `ETH_DUT_INST_PATH.xgmii_tx_data;
     assign spy_if_ip0.xgmii_tx_control = `ETH_DUT_INST_PATH.xgmii_tx_control;
     assign spy_if_ip0.xgmii_rx_control = `ETH_DUT_INST_PATH.xgmii_rx_control;
`endif
     //*****************End of Ported covergroup signals 
   end
`ifdef ETH_MULTI_PORT
   svt_ethernet_multi_port_xxm_bfm_driver      #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) svt_ethernet_drv_0(svt_ethernet_txrx_if[0]); 
   svt_ethernet_multi_port_xxm_mon_chk_driver  #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) svt_ethernet_mon_chk_0(svt_ethernet_txrx_if[0]); 
`else   
   svt_ethernet_xxm_bfm_driver svt_ethernet_drv_0(svt_ethernet_txrx_if[0]); 
   svt_ethernet_xxm_mon_chk_driver svt_ethernet_mon_chk_0(svt_ethernet_txrx_if[0]); 
`endif
        defparam svt_ethernet_mon_chk_0.ETH_JUMBO_FRAME_SIZE=70000; 
        defparam svt_ethernet_drv_0.ETH_JUMBO_FRAME_SIZE=70000;   
   

 `endif 
 
     bit 				    soft_reset_ip0;
     bit[31:0] REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
     `ifdef DEVICE_SM
     assign REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_mac_ip0.address[17:2] == `mac_reset_control_OFFSET_REG) && (avmm_if_mac_ip0.write == 1'b1)) ? avmm_if_mac_ip0.writedata : REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
     `else
     assign REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_ip0.address[17:2] == `mac_reset_control_OFFSET_REG) && (avmm_if_ip0.write == 1'b1)) ? avmm_if_ip0.writedata : REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
   `endif
     assign  soft_reset_ip0 =  0;//REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];

//`ifndef ANLT
     assign spy_if_ip0.eio_soft_rst =  0;//REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
     assign spy_if_ip0.tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
     assign spy_if_ip0.rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[8];   
     `ifdef ETH_MULTI_PORT
     assign spy_if_ip0.pcs_led_an_o = eth_env_top.dut.U_DUT.u_channel.led_an;
     assign spy_if_ip0.an_state     =  eth_env_top.dut.U_DUT.u_channel.phy.alt_mge_channel.mge_pcs.USXGMII_PCS.usxgmii_pcs.an.state[2:0];    
`endif
//`endif

   //---------------------------------------------------------------------------
   //  UVC Instances for TX-MAC-AVST UVC.
   // This UVC is active agent and works as a driver+monitor 
   //---------------------------------------------------------------------------

	 // IF                 
always begin 
         #4ns clk_125 = ~clk_125;
    end
`ifdef PTP_EN
   //Special handling for AVST for PTP reset. No RX reset when TX is reset
   bit tx_ip_rst_en;

	 // IF
	 altera_avalon_st_if#(
			      `ALTUVM_AVALON_ST_INF_TB_PARAM_INST_25G, 
			      .ST_SYMBOL_W(ST_SYMBOL_W_25G) 
			      ) tx_avst_if_ip0 (.clk (clk_tx_ip0),
					   .reset (reset_ip0 
						   | ~reset_if_ip0.tx_rst_n
						   | spy_if_ip0.eio_soft_rst 
						   | spy_if_ip0.tx_soft_rst
                     | ~(eth_sideband_if_ip0.tx_lane_stable & (~tx_ip_rst_en)))
					   );

   //Assert tx_ip_rst_en signal when tx rst asserted 
   always @(negedge reset_if_ip0.tx_rst_n or posedge spy_if_ip0.tx_soft_rst or posedge reset_ip0)begin
      `uvm_info("event",$sformatf("IP reset/ TX only reset condition happened"),UVM_LOW);
      tx_ip_rst_en = 1;   
   end
   
   //Deassert tx_ip_rst_en signal when both ptp tx and rx asserted
   always @(posedge spy_if_ip0.o_tx_ptp_ready or posedge spy_if_ip0.o_rx_ptp_ready)begin
      if(spy_if_ip0.o_tx_ptp_ready == 1 && spy_if_ip0.o_rx_ptp_ready == 1)begin
         `uvm_info("event",$sformatf("Reset tx_ip_rst_en"),UVM_LOW);
         tx_ip_rst_en = 0;
      end
   end
   
`else

	 altera_avalon_st_if#(
			      `ALTUVM_AVALON_ST_INF_TB_PARAM_INST_25G, 
			      .ST_SYMBOL_W(ST_SYMBOL_W_25G) 
			      ) tx_avst_if_ip0 (.clk (clk_tx_ip0),
					   .reset ( 
						    ~reset_if_ip0.tx_rst_n 
						   | ~reset_if_ip0.rx_rst_n 
						   | spy_if_ip0.eio_soft_rst 
						   | spy_if_ip0.tx_soft_rst 
						   | spy_if_ip0.rx_soft_rst)
					   );   

`endif           

	 // RTB
	 altuvm_avalon_st_rtb#(
			       `ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_25G, 
			       `altuvm_avalon_st_symbol_param_inst(avst),
			       .ST_SYMBOL_W(ST_SYMBOL_W_25G), 
			       .IS_ACTIVE(UVM_ACTIVE),
			       .BFM_TYPE(altuvm_avalon_st_pkg::AVALON_ST_SOURCE)
			       ) avst_tx_rtb_ip0  (.uif(tx_avst_if_ip0 ));
	 initial begin
	    uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avst_tx_rtb_path","avst_tx_rtb_ip0");
	 end


   //---------------------------------------------------------------------------
   //  UVC Instances for RX-MAC-AVST UVC.
   // This UVC is passive agent and works as a monitor 
   //---------------------------------------------------------------------------

	 // IF
	 altera_avalon_st_if#(
			      `ALTUVM_AVALON_ST_INF_TB_PARAM_INST_25G, 
			      .ST_SYMBOL_W(ST_SYMBOL_W_25G) 
			      ) rx_avst_if_ip0(.clk (clk_rx_ip0),
					   .reset( 
						   ~reset_if_ip0.rx_rst_n 
						  | spy_if_ip0.eio_soft_rst 
						  | spy_if_ip0.rx_soft_rst
					   ));
	 // RTB
	 altuvm_avalon_st_rtb#(
			       `ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_25G, 
			       `altuvm_avalon_st_symbol_param_inst(avst),
			       .ST_SYMBOL_W(ST_SYMBOL_W_25G), 
			       .IS_ACTIVE(UVM_PASSIVE),
			       .BFM_TYPE(altuvm_avalon_st_pkg::AVALON_ST_MONITOR)
			       ) avst_rx_rtb_ip0 (.uif (rx_avst_if_ip0)
					      );
	 assign rx_avst_if_ip0.ready          = 1'b1;

	 initial begin
	    uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avst_rx_rtb_path","avst_rx_rtb_ip0");
	 end


//  defparam dut.ip0.SIM_SHORT_AM = 1;
//mprash2x


`ifdef ETH_BASERS10
  assign clk_rx_ip0 =  eth_env_top.dut.U_DUT.clk_312_5 ; //BASERS10 eth_env_top.dut.mac64b_clk;
  assign clk_tx_ip0 =  eth_env_top.dut.U_DUT.clk_312_5 ; //BASERS10 eth_env_top.dut.mac64b_clk;
`elsif ETH_BASERS10_ARRIA
  assign clk_rx_ip0 =  eth_env_top.dut.U_DUT.rx_xcvr_clk ; //BASERS10 eth_env_top.dut.mac64b_clk;
  assign clk_tx_ip0 =  eth_env_top.dut.U_DUT.tx_xcvr_clk ; //BASERS10 eth_env_top.dut.mac64b_clk;
`elsif ETH_MULTI_PORT
  assign spy_if_ip0.tx_156_25_clk_sync = eth_env_top.dut.U_DUT.u_channel.mac.alt_eth_top.tx_156_25_clk_sync; 
  assign spy_if_ip0.rx_156_25_clk_sync = eth_env_top.dut.U_DUT.u_channel.mac.alt_eth_top.rx_156_25_clk_sync; 
  assign clk_rx_ip0 = eth_env_top.dut.mac64b_clk;
  assign clk_tx_ip0 = eth_env_top.dut.mac64b_clk;
`elsif ETH_SM_MGBASET
  assign clk_rx_ip0 = eth_env_top.dut.mac64b_clk;
  assign clk_tx_ip0 = eth_env_top.dut.mac64b_clk;
`elsif ETH_MGBASET
  assign clk_rx_ip0 = eth_env_top.dut.U_DUT_WRAPPER.mac64b_clk;
  assign clk_tx_ip0 = eth_env_top.dut.U_DUT_WRAPPER.mac64b_clk;
`elsif ETH_NF_10G
  assign clk_rx_ip0 = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.pll_0_outclk0_clk;
  assign clk_tx_ip0 = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.pll_0_outclk0_clk;
`else
  assign clk_rx_ip0 = eth_env_top.dut.mac64b_clk;
  assign clk_tx_ip0 = eth_env_top.dut.mac64b_clk;
`endif



//Passed avst interface Error to vector interface
`ifdef ETH_MULTI_PORT
   assign eth_vector_if_ip0.status_error = eth_env_top.dut.U_DUT.u_channel.avalon_st_rxstatus_error[6:0]; 
   assign eth_vector_if_ip0.status_error_tx = eth_env_top.dut.U_DUT.u_channel.avalon_st_txstatus_error[6:0]; 
`elsif ETH_SM_MGBASET
   assign eth_vector_if_ip0.status_error    = eth_env_top.dut.U_DUT.avalon_st_rxstatus_error[6:0];
   assign eth_vector_if_ip0.status_error_tx = eth_env_top.dut.U_DUT.avalon_st_txstatus_error[6:0];
`elsif ETH_MGBASET
   assign eth_vector_if_ip0.status_error    = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_rxstatus_error[6:0];
   assign eth_vector_if_ip0.status_error_tx = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_txstatus_error[6:0];
`elsif ETH_MGE
   assign eth_vector_if_ip0.status_error = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_rxstatus_error[6:0]; 
   assign eth_vector_if_ip0.status_error_tx =  eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_txstatus_error[6:0];
`elsif ETH_NF_10G 
   assign eth_vector_if_ip0.status_error = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_rxstatus_error[6:0]; 
   assign eth_vector_if_ip0.status_error_tx =  eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_txstatus_error[6:0];
 `else
   assign eth_vector_if_ip0.status_error    = eth_env_top.dut.U_DUT.avalon_st_rxstatus_error[6:0];
   assign eth_vector_if_ip0.status_error_tx = eth_env_top.dut.U_DUT.avalon_st_txstatus_error[6:0];
`endif



    //DUT and other interface connections
    assign rst_n_ip0    = reset_if_ip0.csr_rst_n;
    assign tx_rst_n_ip0 = reset_if_ip0.tx_rst_n;
    assign rx_rst_n_ip0 = reset_if_ip0.rx_rst_n;
    assign mac_tx_rst_n_ip0 = reset_if_ip0.mac_tx_rst_n;
    assign mac_rx_rst_n_ip0 = reset_if_ip0.mac_rx_rst_n;
    assign mac_rst_n_ip0 = reset_if_ip0.mac_rst_n;
    assign reset_if_ip0.rst_ack_n = rst_ack_n_ip0; 
    assign reset_if_ip0.tx_rst_ack_n = tx_rst_ack_n_ip0; 
    assign reset_if_ip0.rx_rst_ack_n = rx_rst_ack_n_ip0; 
    assign reset_if_ip0.mac_tx_rst_ack_n = mac_tx_rst_ack_n_ip0; 
    assign reset_if_ip0.mac_rx_rst_ack_n = mac_rx_rst_ack_n_ip0; 
    assign reset_if_ip0.mac_rst_ack_n = mac_rst_ack_n_ip0; 

    bit [63:0] rx_preamble_stored_ip0; 
        always @(negedge clk_rx_ip0) begin
      if (rx_startofpacket_ip0 && rx_valid_ip0) begin
        //rx_preamble_stored_ip0 <= rx_preamble_ip0;
      end
    end
    assign tx_startofpacket_ip0 = tx_avst_if_ip0.startofpacket;
    assign tx_endofpacket_ip0   = tx_avst_if_ip0.endofpacket;
    assign tx_valid_ip0         = tx_avst_if_ip0.valid;
    assign tx_empty_ip0         = tx_avst_if_ip0.empty;
    assign tx_data_ip0          = tx_avst_if_ip0.data;
    assign tx_skip_crc_ip0      = tx_avst_if_ip0.channel[0];
    assign i_tx_pfc_ip0        = 8'b0;// TBD VENKATKX Drive 1'b0 other wise dut_tx will drive pause frames (Need to drive proper value from the interface) 
    assign i_tx_pause_ip0      = 2'b0;// TBD VENKATKX Drive 1'b0 other wise dut_tx will drive pause frames (Need to drive proper value from the interface) 
    assign tx_error_ip0         = eth_sideband_if_ip0.tx_error; 
    //assign tx_preamble_ip0      = eth_sideband_if_ip0.l2_tx_preamble; // RAMI-REF only for 40G/50G 
    assign eth_sideband_if_ip0.tx_lane_stable = tx_lanes_stable_ip0;
    assign eth_sideband_if_ip0.rx_pcs_ready   = rx_pcs_ready_ip0;
    assign eth_sideband_if_ip0.rx_pause       = rx_pause_ip0;
    //assign eth_sideband_if_ip0.l2_rx_preamble = rx_preamble_stored_ip0;      // RAMI-REF only for 40G/50G 
    //assign eth_sideband_if_ip0.mon_tx_preamble  = tx_preamble_ip0;

    assign eth_sideband_if_ip0.tx_ready     = tx_ready_ip0;       // RAMI-FIX port not available in GDR

    assign tx_avst_if_ip0.ready       = tx_ready_ip0;
    assign rx_avst_if_ip0.empty       = rx_empty_ip0;
    assign rx_avst_if_ip0.data        = rx_data_ip0;
    assign rx_avst_if_ip0.error       = rx_error_ip0;
    assign rx_avst_if_ip0.endofpacket = rx_endofpacket_ip0;
    `ifndef ETH_MULTI_PORT 
        assign eth_vector_if_ip0.end_offpacket =rx_endofpacket_ip0; 
    `endif
    assign custom_cadence_ip0         = eth_sideband_if_ip0.custom_cadence;

    assign stats_snapshot_ip0            = eth_sideband_if_ip0.snapshot_en;

    `ifdef ETH_MGE
    assign eth_vector_if_ip0.status_valid = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_rxstatus_valid[0:0];
    assign eth_vector_if_ip0.status_data  = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_rxstatus_data[39:0];
    `elsif ETH_NF_10G
    assign eth_vector_if_ip0.status_valid = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_rxstatus_valid[0:0];
    assign eth_vector_if_ip0.status_data  = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_rxstatus_data[39:0];
    assign eth_vector_if_ip0.hi_ber       =  eth_env_top.dut.U_DUT_WRAPPER.U_DUT.xcvr_10gkr_a10_0_rx_hi_ber_export;
    `else
    assign eth_vector_if_ip0.status_valid = rx_status_valid_ip0;
    assign eth_vector_if_ip0.status_data  = rx_status_data_ip0;
    `endif

    `ifdef ETH_MULTI_PORT
       assign eth_vector_if_ip0.status_valid_tx =eth_env_top.dut.U_DUT.u_channel.avalon_st_txstatus_valid[0:0];
       assign eth_vector_if_ip0.status_data_tx =eth_env_top.dut.U_DUT.u_channel.avalon_st_txstatus_data[39:0];
    `elsif ETH_SM_MGBASET
       assign eth_vector_if_ip0.status_valid_tx =eth_env_top.dut.U_DUT.avalon_st_txstatus_valid[0:0];
       assign eth_vector_if_ip0.status_data_tx =eth_env_top.dut.U_DUT.avalon_st_txstatus_data[39:0];
    `elsif ETH_MGBASET   
       assign eth_vector_if_ip0.status_valid_tx =eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_txstatus_valid[0:0];
       assign eth_vector_if_ip0.status_data_tx =eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_txstatus_data[39:0];
    `elsif ETH_MGE
       assign eth_vector_if_ip0.status_valid_tx = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_txstatus_valid[0:0]; 
       assign eth_vector_if_ip0.status_data_tx  =  eth_env_top.dut.U_DUT_WRAPPER.U_DUT.avalon_st_txstatus_data[39:0];
    `elsif ETH_NF_10G
       assign eth_vector_if_ip0.status_valid_tx = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_txstatus_valid[0:0]; 
       assign eth_vector_if_ip0.status_data_tx  =  eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_txstatus_data[39:0];
    `else
       assign eth_vector_if_ip0.status_valid_tx =eth_env_top.dut.U_DUT.avalon_st_txstatus_valid;
       assign eth_vector_if_ip0.status_data_tx =eth_env_top.dut.U_DUT.avalon_st_txstatus_data[39:0];
    `endif
    
    //CSR
     logic[1:0] address_MSB;
    `ifdef ETH_NF_10G
       //if((avmm_if_ip0.address[17:0]>= 'h0) && (avmm_if_ip0.address[17:0] < 'h3fff))
       //assign  address_MSB = 2'b00;
       assign  address_MSB  = ((avmm_if_ip0.address[17:0]>= 'h0) && (avmm_if_ip0.address[17:0]<='h3fff)) ? 2'b00  : 2'b10;
    `elsif ETH_NF_1G
       assign  address_MSB = 2'b10;
    `endif
    initial 
      begin
       `uvm_info("gdr_avst_temp", $sformatf("address_MSB = %0d",address_MSB),UVM_MEDIUM)
      end 
      
         `ifdef 1G_SPEED
     //    `uvm_info("event",$sformatf("Inside 1G SPEED"),UVM_LOW);
             assign xcvr_mode_ip0 = 2'b00;
         `endif
         `ifdef 2_5G_SPEED
       //  `uvm_info("event",$sformatf("Inside 2.5G SPEED"),UVM_LOW);
             assign xcvr_mode_ip0 = 2'b01;
         `endif

    assign reconfig_eth_write_ip0           = avmm_if_ip0.write;
    assign reconfig_eth_read_ip0            = avmm_if_ip0.read;
    //assign reconfig_eth_addr_ip0            =  {2'b00,avmm_if_ip0.address[17:0]} ; //{3'b0,avmm_if_ip0.address[17:2]};
    `ifdef ETH_NF_10G
      assign reconfig_eth_addr_ip0            =  {address_MSB,avmm_if_ip0.address[17:0]};
    `else
      assign reconfig_eth_addr_ip0            =  {3'b0,avmm_if_ip0.address[17:2]};
    `endif
    assign reconfig_eth_byteenable_ip0      = avmm_if_ip0.byteenable;
    assign reconfig_eth_writedata_ip0       = avmm_if_ip0.writedata;
    assign avmm_if_ip0.readdata             = reconfig_eth_readdata_ip0;
    assign avmm_if_ip0.waitrequest          = reconfig_eth_waitrequest_ip0;    
    assign avmm_if_ip0.readdatavalid        = ~reconfig_eth_waitrequest_ip0;
// AVMM CSR

    
    // scaled based on number of phy channels
    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;
    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;
    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;
    assign reconfig_xcvr0_address_ip0         = {2'b00,(avmm_xcvr_if_ip0_0.address[19:2])};
    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;
    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;
    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    
    assign avmm_xcvr_if_ip0_0.readdatavalid    = 0; //reconfig_xcvr0_readdata_valid_ip0;
    
   //FB 535148 (do it for appropiate DUT - RAMI-FIX do we need this???) 
   initial begin
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_read = 0;
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_write = 0;
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_writedata[7:0] = 0;
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_address[20:0] = 0;
     // PATH-FIX: repeat (5) 
     // PATH-FIX: @ (posedge dut.ip0.alt_ehipc3_hard_inst.i_reconfig_clk);
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_read ;
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_write ;
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_writedata[7:0] ;
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_address[20:0] ;
   end
   initial begin
//force eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.sip_inst.i_rx_fifo_rd_en[0:0] = 1'b1;
//force eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.genblk1.ncssblk.n_channel_superset_ip_inst.n_channel_superset_ip.hal_top_wrapper_inst.i_hio_txdata_fifo_wr_en[0:0] = 1'b1;
//force eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.genblk1.ncssblk.n_channel_superset_ip_inst.n_channel_superset_ip.hal_top_wrapper_inst.hal_top_ip.one_lane_inst_0.one_lane_hal_top_p0.phy_hal_top_inst.phy_hal_top.phy_hal_coreip_inst.ch4_phy_inst.x_std_sm_xcvrif_1ch_0.sf_rtl_inst.xcvrif_chnl_tx_u0.tx_fifo.i_bond_wr_en  = 1'b1;
//force eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.genblk1.ncssblk.n_channel_superset_ip_inst.i_hio_ch0_lavmm_clk = clk_125;
//force eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.genblk1.ncssblk.n_channel_superset_ip_inst.n_channel_superset_ip.hal_top_wrapper_inst.i_hio_pld_reset_clk_row[0:0] = clk_125; 
//force eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.alt_mge_xcvr_directphy.sip_inst.intel_directphy_avmm_inst.reconfig_pdp_clk[0:0] = clk_125;
end

   initial begin
//TODO Remove code    force eth_env_top.dut.dm_top.genblk2[0].pcs.i_mge_pcs.USXGMII_PCS.usxgmii_pcs.csr.alt_mge_phy_usxg32_creg_map_inst.usxgmii_an_en = 1'b0;
   end


    initial
    begin
      assertion_event.wait_ptrigger();
      `uvm_info("assertion_event", "IP0 out of assertion_event wait trigger", UVM_NONE)
       avst_rx_rtb_ip0.monitor.u_bfm.monitor_assertion.enable_a_non_missing_endofpacket   = 0;
    end

`ifdef ENABLE_ETH_VIP

    //FB-544895
//    `ifdef ANLT
//        always @(reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
//        begin
//            svt_ethernet_txrx_if[0].reset = ( ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0);  
//        end
//    `else

`ifndef PTP_EN
      always @(reset_if_ip0.csr_rst_n or soft_reset_ip0 or reset_if_ip0.vip_rst or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or spy_if_ip0.tx_soft_rst or spy_if_ip0.rx_soft_rst)
      begin
          `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);
          //svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | soft_reset_ip0 | reset_if_ip0.vip_rst | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | spy_if_ip0.tx_soft_rst | spy_if_ip0.rx_soft_rst);  
          svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n);  
      end
   //initial begin
   //svt_ethernet_txrx_if[0].reset = 0;
   //#1us;
   //svt_ethernet_txrx_if[0].reset = 1;
   //#1us;
   //svt_ethernet_txrx_if[0].reset = 0;
   //end
`else
      //VIP only reset depend on RX reset and IP reset only. TX only reset dont reset else mid traffic will have assertion error.
      always @(reset_if_ip0.csr_rst_n or soft_reset_ip0 or reset_if_ip0.vip_rst or reset_if_ip0.rx_rst_n or spy_if_ip0.rx_soft_rst)
      begin
          `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);  
          svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | soft_reset_ip0 | reset_if_ip0.vip_rst | ~reset_if_ip0.rx_rst_n | spy_if_ip0.rx_soft_rst);  
      end
`endif        
        
    
`endif

	 always @(tx_lanes_stable_ip0 or reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
	   begin
	      assertion_on_off_reset[0] = (~tx_lanes_stable_ip0 | ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0); 
	   end


// RAMI-FIX clk_sys_ip0???

//*********************************************//  
//drajasek-driving src_ip_clk to 1Ghz
//   assign i_clk_sys = clk_sys_ip0;
//   always begin #500ps clk_sys_ip0 = ~clk_sys_ip0;
//   force eth_env_top.dut.ip0.top_ip0.i_src_ip_clk = clk_sys_ip0;
//   end
//*********************************************//  
initial
begin
     forever begin
       @(posedge spy_if_ip0.t_valid);
       force eth_env_top.dut.i_tx_valid_ip0 =1;
       `uvm_info("bfm queue","AFTER APPLYING VALID", UVM_NONE)

       @(negedge spy_if_ip0.t_valid); 
       release eth_env_top.dut.i_tx_valid_ip0;
       `uvm_info("bfm queue"," IN ELSE LOOP AFTER APPLYING VALID",UVM_NONE)
     end
end 
	assign reconfig_clk_ip0     = clk_status_ip0;
	assign clk_ip0              = clk_pll_ip0;
	// assign reset_ip0            = ~reset_if_ip0.csr_rst_n;
	assign reset_ip0= ~rst_n_ip0;
	assign reset_if_ip0.clock   = clk_status_ip0;

//********************************************************//
//drajasek-toggling this reset to reset the soft CSRs
initial begin
  assign reconfig_reset_ip0 =  reset_if_ip0.reconfig_rst_n;
  #500ns;
  assign reconfig_reset_ip0 =  ~reset_if_ip0.reconfig_rst_n;
end  
//*****************************************************//

//`ifdef ANLT
//	 always begin
//            #3200 clk_ref_ip0 = ~clk_ref_ip0;
//	 end
//`else
	 if(`phy_refclk_ip0 == 0 || `phy_refclk_ip0 == 156.250000) always #3200 clk_ref_ip0 = ~clk_ref_ip0;                
	 if(`phy_refclk_ip0 == 1 || `phy_refclk_ip0 == 322.265625) always #1551.51515 clk_ref_ip0 = ~clk_ref_ip0;
     if(`phy_refclk_ip0 == 2 || `phy_refclk_ip0 == 312.500000) always #1600 clk_ref_ip0 = ~clk_ref_ip0;
     if(`phy_refclk_ip0 == 3 || `phy_refclk_ip0 == 644.531250) always #775.757575  clk_ref_ip0 = ~clk_ref_ip0;
//`endif



//`ifdef ANLT
//    always begin #500ps clk_status_ip0= ~clk_status_ip0;    end //to speed up simulation
//`else
	//100MHz to 161.13MHz
	//Previously it is set to 1GHz which caused internal signal clock cross failed.
	//Now set to 100MHz



    `ifdef FAST_CLK
         `ifdef PTP_EN
    	   always begin 
            if(!($test$plusargs("PTP_REG_TEST")))begin
               #5000ps clk_status_ip0= ~clk_status_ip0;
            end else begin
               #500ps clk_status_ip0= ~clk_status_ip0;
            end
           end
         `else
            always begin #(CLOCK_PERIOD/2) clk_status_ip0= ~clk_status_ip0; end
         `endif
    `else
    	always begin #(CLOCK_PERIOD/2) clk_status_ip0= ~clk_status_ip0;    end
    `endif



   `ifdef ENABLE_ETH_VIP
    initial
    begin
      //DM_Todo : Uncomment it      
      //spy_if_ip0.event_chk_start_cntrl_character_tx = eth_env_top.svt_ethernet_mon_chk_0.Chk.xgmii_checker.tx.event_chk_start_cntrl_character; // ip0 + chk_i
      //spy_if_ip0.cw_insert = svt_ethernet_drv_0.Bfm.event_kr4_fec_cw_transmitted; // ip0 + drv_i
      //spy_if_ip0.event_mac_idle_detected_rx = eth_env_top.svt_ethernet_mon_chk_0.Chk.event_mac_idle_detected_rx; // ip0 + chk_i
    end
    //assign spy_if_ip0.mii_tx_clk = eth_env_top.svt_ethernet_mon_chk_0.Chk.xgmii_checker.tx.xgmii_clk; // ip0 + chk_i
    //assign spy_if_ip0.data_valid_tx = eth_env_top.svt_ethernet_mon_chk_0.Chk.xgmii_checker.tx.data_valid; // ip0 + chk_i
    `endif

    `ifdef ENABLE_ETH_VIP
     //schauh1x: uncomment the below line once DUT is ready, python script must take care to increase the number of 
        `ifndef NON_ANLT_PTP
      assign eth_env_top.signal_map_if[0].usr_rx_pcs_syn_up = eth_sideband_if_ip0.tx_lane_stable;
    //  assign signal_map_if[0].kr4_fec_am_lock =  eth_env_top.dut.rx_am_lock ;
        `endif
     `ifdef COMPL_TC
      `ifdef ETH_MULTI_PORT
        assign eth_env_top.signal_map_if.signal_map_if[0].usr_rx_pcs_syn_up = eth_sideband_if_ip0.rx_pcs_ready;
      `else
        assign eth_env_top.signal_map_if.usr_rx_pcs_syn_up = eth_sideband_if_ip0.rx_pcs_ready;
      `endif
       always begin
       wait ((eth_env_top.dut.o_rx_valid_ip0 === 1'b1) && (eth_env_top.dut.o_rx_startofpacket_ip0 === 1'b1));
       wait ((eth_env_top.dut.o_rx_valid_ip0 === 1'b1) && (eth_env_top.dut.o_rx_endofpacket_ip0 === 1'b1));
       //check_frm_rcv testsuite task
       `ifdef ETH_MULTI_PORT
       ->signal_map_if.signal_map_if[0].event_rx_frame_accepted; 
       `else
       ->signal_map_if.event_rx_frame_accepted; 
       `endif
       end
      `endif
    `endif
   
   
  `ifdef ENABLE_ETH_VIP
   //pass interface to env
   initial begin
      ts_tasks_if[0].ip = 0; //ALEX new: ts_task_if[i].ip = i, for INST[i] which needs AVST template
      uvm_config_db#(virtual eth_testsuite_tasks_intf)::set(uvm_root::get(),"*env_ip0","ts_tasks_if",ts_tasks_if[0]);
     `ifdef ETH_MULTI_PORT
        uvm_config_db#(virtual svt_ethernet_multi_port_txrx_if#(`NUM_OF_PORTS))::set(uvm_root::get(),"*env_ip0", "if_port", svt_ethernet_txrx_if[0]);
     `else
        uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),"*env_ip0", "if_port", svt_ethernet_txrx_if[0]);
     `endif
      
      `ifndef NON_ANLT_PTP
      uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"*ts_component0*", "if_directed", directed_if[0]);    //schauh1x
      `endif
  `ifdef COMPL_TC 
    `ifdef ETH_MULTI_PORT
       uvm_config_db#(virtual svt_ethernet_test_suite_multi_port_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)))::set(uvm_root::get(),"", "if_directed_mp", directed_if);
       uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"","if_directed",directed_if.directed_if[0]);
       uvm_config_db#(virtual svt_ethernet_signal_mapping_multi_port_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)))::set(uvm_root::get(),"","signal_map_if", signal_map_if);
     `else
       uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"","if_directed", directed_if);
       uvm_config_db#(virtual svt_ethernet_signal_mapping_if)::set(uvm_root::get(),"","signal_map_if",signal_map_if);
     `endif
  `endif
    end 

  `endif


   eth_sideband_interface eth_sideband_if_ip0(.rst(reset_ip0),
                                              //.clk(clk_pll_ip0),
                                              .clk(clk_tx_ip0),
                                              .clk_tx(clk_tx_ip0),
                                              .clk_rx(clk_rx_ip0),
`ifdef PTP_EN
                                              .tx_tod_clk(eth_env_top.dut.i_clk_tx_tod_ip0),
                                              .rx_tod_clk(eth_env_top.dut.i_clk_rx_tod_ip0));
`else
                                              .tx_tod_clk('b0),
                                              .rx_tod_clk('b0));
`endif
                                              
	 vector_uvc_interface eth_vector_if_ip0(clk_rx_ip0,reset_ip0,clk_tx_ip0);
   
   initial begin
      uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "mst_if",eth_sideband_if_ip0); 
      uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "slv_if",eth_sideband_if_ip0); 
      uvm_config_db #(virtual vector_uvc_interface)::set(uvm_root::get(), "*env_ip0.vector_agent*","vector_if",eth_vector_if_ip0);
   end
         
   
   // SPY IF
   spy_interface #(.IP("ip0")) spy_if_ip0(); // ALEX new: #(.IP("ip<i>)), for INST[i] which needs AVST template
   initial begin
     `ifdef COV
       uvm_config_db #(v_if2)::set(null,"*","spy_interface",spy_if_ip0);
     `else
       uvm_config_db #(v_if2)::set(null,"*env_ip0","spy_interface",spy_if_ip0);
     `endif
       uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","dut_name","*dut_25g_ip0");  
   end

// AVMM IF
   initial begin
       uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,"*env_ip0*","status_if",avmm_if_ip0);
   end
  
   // pass DUT valid and sop to RX avst and sideband interface
   assign rx_avst_if_ip0.valid                        = rx_valid_ip0;
   assign rx_avst_if_ip0.startofpacket                = rx_startofpacket_ip0;
   assign eth_sideband_if_ip0.rx_valid                = rx_valid_ip0;
   assign eth_sideband_if_ip0.rx_sop                  = rx_startofpacket_ip0;
   assign eth_sideband_if_ip0.tx_sop                  = tx_startofpacket_ip0;

         initial
           begin

              //This assertion is disabeld based on discussion with uvc owner,i.e reset is applied by user
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
              avst_rx_rtb_ip0.monitor.u_bfm.monitor_assertion.set_enable_a_no_data_outside_packet(0);
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0;              

              avmm_mac_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
              avmm_mac_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
              avmm_mac_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0; 

              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0;              

  //            force eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;

              //dsamantx : Added this timeout in itf script.
	      //dsamantx : Accesing some register takes more time than 1us.
//	      `ifdef FAST_CLK
//	         eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.set_waitrequest_timeout(2000);
//	      `else
//	         eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.set_waitrequest_timeout(200);
//        `endif
//
//  		  `ifdef FAST_CLK
//            force  avmm_rtb_ip0.master.u.u_bfm.command_timeout=3000;
//        `else
//        	force  avmm_rtb_ip0.master.u.u_bfm.command_timeout=300;
//        `endif
            `ifdef FAST_CLK
              	force avmm_xcvr_rtb_ip0_0.master.u.u_bfm.command_timeout=1000; 
              	force avmm_xcvr_rtb_ip0_0.master.u.u_bfm.response_timeout=1000;
              `endif

              //AVMM covergroups
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
              avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);


              //MAC AVMM covergroups
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	            avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	            avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
              avmm_mac_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);


              //RCFG AVMM covergroups
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	            avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	            avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);

             //AVST TX covergroup
             avst_tx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_error(0);     
             avst_tx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_error_in_middle_of_packet(0);     
             avst_tx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_packet_with_idles(0);     
             avst_tx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_transaction_after_reset(0);     
             //AVST RX covergroup
             avst_rx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_transaction_after_reset(0);
             avst_rx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_valid_non_ready(0);
             avst_rx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_non_valid_non_ready(0);
             avst_rx_rtb_ip0.monitor.u_bfm.monitor_coverage.set_enable_c_packet_with_back_pressure(0);


              //FB-530473 -timeout increased to >25000ns // RAMI-FIX do need this??
              //force avst_tx_rtb_ip0.source.u.u_bfm.response_timeout=25000;
	            force avst_tx_rtb_ip0.source.u.u_bfm.response_timeout=500000;
              
              //Setting AVMM driver idle signal driving to 0
              avmm_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);
              avmm_mac_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);
              avmm_rcfg_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);
              
              //Setting AVST driver idle signal driving to 0
              avst_tx_rtb_ip0.source.u.u_bfm.set_idle_state_output_configuration(0);

              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
              avmm_mac_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;

              // scaled  based on number of phy channels
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;
              // https://hsdes.intel.com/appstore/article/#/16012162175
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
              // DM : byteenable is always 'F 
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
	      avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	      avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
	`ifndef PTP_EN
              repeat (10) @(posedge clk_status_ip0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 1;
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
              avmm_mac_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
	`else
           if(`NUM_INST == 1) begin //disable for multi instance PTP
              repeat (10) @(posedge clk_status_ip0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 1;
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
              avmm_mac_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
              avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
           end
        `endif 
            end

	 

   // interface connections spy_if
   assign spy_if_ip0.o_rx_hi_ber = rx_hi_ber_ip0;
   assign spy_if_ip0.rx_am_lock = rx_am_lock_ip0;
   `ifdef ETH_MULTI_PORT
   assign spy_if_ip0.rx_block_lock = rx_block_lock_ip0;
   `else
   //LL10G_TODO:https://hsdes.intel.com/appstore/article/#/16018642496
   assign spy_if_ip0.rx_block_lock = rx_pcs_ready_ip0;
   `endif
   assign spy_if_ip0.rx_pcs_ready = rx_pcs_ready_ip0;
   //assign spy_if_ip0.ehip_ready = ehip_ready_ip0; // RAMI-FIX port not available in GDR
   assign spy_if_ip0.soft_reset = soft_reset_ip0;
   assign spy_if_ip0.o_tx_ready = tx_ready_ip0;
   
   //GDR_RX/TX_MAC connections
   assign spy_if_ip0.rf_status		= remote_fault_status_ip0;
   `ifdef ETH_MULTI_PORT
   	assign spy_if_ip0.lf_status		= `ETH_MAC_INST_PATH.link_fault_status_xgmii_rx_data[1:0];
    	// assign spy_if_ip0.rf_status		= remote_fault_status_ip0;
	//   assign spy_if_ip0.lf_status		= `ETH_MAC_INST_PATH.link_fault_status_xgmii_rx_data[1:0];
   	//assign spy_if_ip0.fault          = remote_fault_status_ip0 | local_fault_status_ip0;
   `endif  
   `ifdef ETH_BASERS10_ARRIA
    	assign spy_if_ip0.lf_status		       = eth_env_top.dut.U_DUT.link_fault_status_xgmii_rx_data[1:0];
	assign spy_if_ip0.sig_avalon_st_rx_error       = eth_env_top.dut.U_DUT.avalon_st_rx_error;
        assign spy_if_ip0.sig_avalon_st_rx_endofpacket = eth_env_top.dut.U_DUT.avalon_st_rx_endofpacket;	
   `endif
   `ifdef ETH_BASERS10
       assign spy_if_ip0.lf_status		       = eth_env_top.dut.U_DUT.link_fault_status_xgmii_rx_data[1:0];
       assign spy_if_ip0.sig_avalon_st_rx_error        = eth_env_top.dut.U_DUT.avalon_st_rx_error;
       assign spy_if_ip0.sig_avalon_st_rx_endofpacket  = eth_env_top.dut.U_DUT.avalon_st_rx_endofpacket;
   `endif
   `ifdef ETH_MGE
       assign spy_if_ip0.sig_avalon_st_rx_error        = eth_env_top.dut.U_DUT_WRAPPER.avalon_st_rx_error;
       assign spy_if_ip0.sig_avalon_st_rx_endofpacket  = eth_env_top.dut.U_DUT_WRAPPER.avalon_st_rx_endofpacket;
   `endif
   `ifdef ETH_NF_10G                                      
       assign spy_if_ip0.lf_status		       = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.link_fault_status_xgmii_rx_data[1:0];
       assign spy_if_ip0.sig_avalon_st_rx_error        = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_rx_error;
       assign spy_if_ip0.sig_avalon_st_rx_endofpacket  = eth_env_top.dut.U_DUT_WRAPPER.U_DUT.alt_em10g32_0.avalon_st_rx_endofpacket;
   `endif
   `ifdef ETH_SM_MGBASET
       assign spy_if_ip0.sig_avalon_st_txstatus_valid  = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_txstatus_valid;
       assign spy_if_ip0.sig_avalon_st_txstatus_error  = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_txstatus_error;
       assign spy_if_ip0.sig_avalon_st_txstatus_data   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_txstatus_data;
       assign spy_if_ip0.sig_avalon_st_tx_error        = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_tx_error;
       assign spy_if_ip0.sig_avalon_st_tx_valid        = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_tx_valid;
       assign spy_if_ip0.sig_avalon_st_tx_endofpacket  = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_tx_endofpacket;
       assign spy_if_ip0.sig_avalon_st_rx_error         = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rx_error;
       assign spy_if_ip0.sig_avalon_st_rxstatus_valid   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rxstatus_valid;
       assign spy_if_ip0.sig_avalon_st_rxstatus_error   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rxstatus_error;
       assign spy_if_ip0.sig_avalon_st_rx_valid         = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rx_valid;
       assign spy_if_ip0.sig_avalon_st_rx_endofpacket   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rx_endofpacket;
   `endif
   assign spy_if_ip0.clk                  = clk_ref_ip0;
   // PATH-FIX: assign spy_if_ip0.mii_data_rx					= `GDR_RX_MAC_IP0.mii_d;
   // PATH-FIX: assign spy_if_ip0.mii_ctrl_rx          = `GDR_RX_MAC_IP0.mii_c;
   // PATH-FIX: assign spy_if_ip0.mii_valid_rx					= `GDR_RX_MAC_IP0.mii_valid;
   
   // RAMI-FIX scale based on speed??
   //assign spy_if_ip0.mii_data3_tx          = `GDR_TX_MAC_IP0.packet_mii[3].d;
   //assign spy_if_ip0.mii_data2_tx          = `GDR_TX_MAC_IP0.packet_mii[2].d;
   //assign spy_if_ip0.mii_data1_tx          = `GDR_TX_MAC_IP0.packet_mii[1].d;
   // PATH-FIX: assign spy_if_ip0.mii_data0_tx          = `GDR_TX_MAC_IP0.packet_mii[0].d;
   //assign spy_if_ip0.mii_ctrl3_tx          = `GDR_TX_MAC_IP0.packet_mii[3].c;
   //assign spy_if_ip0.mii_ctrl2_tx          = `GDR_TX_MAC_IP0.packet_mii[2].c;
   //assign spy_if_ip0.mii_ctrl1_tx          = `GDR_TX_MAC_IP0.packet_mii[1].c;
   // PATH-FIX: assign spy_if_ip0.mii_ctrl0_tx          = `GDR_TX_MAC_IP0.packet_mii[0].c;
   // PATH-FIX: assign spy_if_ip0.mii_valid_tx		       = `GDR_TX_MAC_IP0.mii_valid;

   assign spy_if_ip0.avst_tx_eop		       = tx_avst_if_ip0.endofpacket;			  	
   assign spy_if_ip0.avst_tx_sop					 = tx_avst_if_ip0.startofpacket;
   // PATH-FIX: assign spy_if_ip0.rx_mac_mii_clk	       = `GDR_RX_MAC_IP0.i_clk & `GDR_RX_MAC_IP0.mii_valid;
   // PATH-FIX: assign spy_if_ip0.o_rx_valid            = dut.ip0.alt_ehipc3_hard_inst.o_rx_valid; // RAMI-FIX GDR hier 
   // PATH-FIX: assign spy_if_ip0.stop_flow             = `GDR_TX_MAC_IP0.tag_gen.preamble.stop_flow;
//   assign spy_if_ip0.rx_dsk_done     = eth_env_top.dut.ip0.top_ip0.sip_inst.ehip_rx_dsk_done ;
   `ifndef PTP_EN
        //assign spy_if_ip0.tx_pll_locked   = eth_env_top.dut.ip0.top_ip0.sip_inst.xcvr_txpll_locked[3:0];
        //assign spy_if_ip0.cdr_lock        = eth_env_top.dut.ip0.top_ip0.sip_inst.xcvr_rxcdr_locked[3:0];
//        assign spy_if_ip0.tx_pll_locked   = eth_env_top.dut.ip0.top_ip0.sip_inst.tx_pll_locked_csr[7:0];
//        assign spy_if_ip0.cdr_lock        = eth_env_top.dut.ip0.top_ip0.sip_inst.eiofreq_lock_csr[7:0];
   `endif

`ifdef CR3TOP_SIMPLE_SERDES

   initial 
   begin 

       // RAMI-FIX path for GDR and scales as per phy channels (possibly using GDR_XCVR_IP0)
       // PATH-FIX: force eth_env_top.dut.ip0.alt_ehipc3_hard_inst.Dynamic_Reconfig.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.ct1_hssirtl_c3xcvr_inst.die_specific_inst.x_c3xcvr.i_async_reset_n = 0;
       //force eth_env_top.dut.ip0
       //force eth_env_top.dut.ip0
       //force eth_env_top.dut.ip0
           #10ns  ;
       // PATH-FIX: release eth_env_top.dut.ip0.alt_ehipc3_hard_inst.Dynamic_Reconfig.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.ct1_hssirtl_c3xcvr_inst.die_specific_inst.x_c3xcvr.i_async_reset_n;
       //release eth_env_top.dut.ip0
       //release eth_env_top.dut.ip0
       //release eth_env_top.dut.ip0

   end

`endif 
   
   
            //For FB#602451 RAMI-FIX GDR hier, needed??
            //assign spy_if_ip0.tx_pma_ready = eth_env_top.dut.ip0.o_sl_tx_pma_ready[i];
            //assign spy_if_ip0.rx_pma_ready = eth_env_top.dut.ip0.o_sl_rx_pma_ready[i];
	    


     `ifdef ENABLE_ETH_VIP       //schauh1x	
      `ifndef NON_ANLT_PTP
       `ifndef PTP_EN
       `SVT_ETHERNET_TEST_SUITE_TOP_INST(0,signal_map_if[0],directed_if[0])
     //  `SVT_ETHERNET_TEST_SUITE_TOP_INST(1,signal_map_if[1],directed_if[1])
     //  `SVT_ETHERNET_TEST_SUITE_TOP_INST(2,signal_map_if[2],directed_if[2])
     //  `SVT_ETHERNET_TEST_SUITE_TOP_INST(3,signal_map_if[3],directed_if[0])
       `endif
       `endif
       `ifdef COMPL_TC
          `ifdef ETH_MULTI_PORT
            `SVT_ETHERNET_TEST_SUITE_TOP_MULTI_PORT_INST(0,signal_map_if,directed_if,svt_ethernet_txrx_if,"")
          `else
            `SVT_ETHERNET_TEST_SUITE_TOP_INST(0,signal_map_if,directed_if)
          `endif
       `endif
    `endif

