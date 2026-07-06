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



    `ifndef ALTERA_COVERAGE_SWIP_ETH_MAC_FRAME_MGBASET_C__SV
`define ALTERA_COVERAGE_SWIP_ETH_MAC_FRAME_MGBASET_C__SV
`uvm_analysis_imp_decl(_eth_frame)
class altera_coverage_swip_eth_mac_frame_mgbaset_c extends uvm_component;
   `uvm_component_utils(altera_coverage_swip_eth_mac_frame_mgbaset_c) 
    // coverage instance properties
    string inst_name ;
    string TEST_NAME = "UNDEFINED_TEST";
    string DUT_NAME = "eth_env_top";
    
    
    
    // frame properties
    bit [31:0] frame_length;
    bit [31:0] payload_length;
    bit [15:0] length_type;
    bit is_jumbo;
    int tx_rx; //1 for TX, 0 for RX
    int frame_size, frame_tx,frame_rx;
    int tag_overhead; 
    uvm_reg regs; 
    registers_urm reg_model;
    bit en_all_mcast, en_all_ucast;
    rand enum int unsigned {DATA_FRAME, CONTROL_FRAME} frame_type = DATA_FRAME;
    rand enum int unsigned {PAUSE_CONTROL, PFC_CONTROL, MISC_CONTROL} control_type = MISC_CONTROL;
    rand enum int unsigned {UNICAST, MULTICAST, BROADCAST, UNICAST_INVALID} da_type = UNICAST;
    rand enum int unsigned {UCAST_ADDR, SUPP_ADDR_0, SUPP_ADDR_1, SUPP_ADDR_2, SUPP_ADDR_3} da_ucast_type = UCAST_ADDR;
    
    rand enum int unsigned {UNTAGGED = 0, VLAN = 1, SVLAN = 2} tag_type = UNTAGGED;

    bit ETH_MAC_RX_SUPP_ENA_0,ETH_MAC_RX_SUPP_ENA_1,ETH_MAC_RX_SUPP_ENA_2,ETH_MAC_RX_SUPP_ENA_3,csr_enable_preamble_passthrough_rx,csr_enable_preamble_passthrough_tx;
    bit [31:0] eth_mac_ucast_address_0_0,eth_mac_ucast_address_0_1,tx_unidir_reg_val,tx_crc_control_reg,tx_preamble_control_reg,rx_preamble_control_reg,rx_custom_preamble_control_reg,ipg_reg;
    bit [31:0] eth_mac_supp_address_0_0,eth_mac_supp_address_0_1;
    bit [31:0] eth_mac_supp_address_1_0,eth_mac_supp_address_1_1;
    bit [31:0] eth_mac_supp_address_2_0,eth_mac_supp_address_2_1;
    bit [31:0] eth_mac_supp_address_3_0,eth_mac_supp_address_3_1;
    bit [31:0]  ETH_MAC_RX_FRAME_CTL;
    bit [7:0]   ipg_10m_100m_1G;
    bit [47:0] eth_mac_ucast_address,eth_mac_supp_address_0,eth_mac_supp_address_1,eth_mac_supp_address_2,eth_mac_supp_address_3;
    
    uvm_analysis_imp_eth_frame #(eth_packet,altera_coverage_swip_eth_mac_frame_mgbaset_c) eth_frame;
 
    
    rand int unsigned error_type = 0;
    
    int pause_quanta;
    int misc_control_type;
    
    int unsigned ipg;
     typedef enum int unsigned {
        NO_ERROR                = 0,
        ERROR_CRC               = 1 << 0,
        ERROR_UNDERSIZED        = 1 << 1,
        ERROR_OVERSIZED         = 1 << 2,
        ERROR_PAYLOAD_LENGTH    = 1 << 3
        //ERROR_MALFMD            = 1 << 4
    } ERROR_E;

    
    virtual spy_interface spy_if; 
     

    
    
    // DUT configuration
    int unsigned max_frame_len = 1518;

    //`ifdef ENABLE_UNIDIRECTIONAL
    logic           csr_tx_unidir_en; 
    logic           csr_unidir_remote_fault_dis;
    logic           timestamping_1step;
    logic [1:0]     unidir_link_fault_status_xgmii_rx_data;
    logic [1:0]     unidir_link_fault_status_xgmii_rx_data_reg;
    logic           unidir_avalon_st_tx_error;
    logic           unidir_avalon_st_tx_error_reg;
    logic [6:0]     unidir_avalon_st_txstatus_error;
    logic [6:0]     unidir_avalon_st_txstatus_error_reg;
    logic           unidir_avalon_st_txstatus_valid;
    logic           unidir_avalon_st_txstatus_valid_reg;
    //`endif

    logic           csr_tx_crc_insrt_en;
    logic           csr_enable_preamble_passthrough_tx;
    logic 	    csr_enable_preamble_passthrough_rx;	

    // `ifdef ETH_MGE_MAC_PHY_DE
    // logic [2:0]     sig_speed;
    // `endif	

    // `ifdef ALTERA_BIC_QSE_MAC
    // `ifndef ETH_10G_MAC_1G10G_PHY_DE
    // try out by sklai
	// internal csr register value
    logic           csr_tx_pausefrm_en;
    logic           csr_tx_pad_insrt_en;
    //logic           csr_tx_crc_insrt_en; //move up
    logic [1:0]     csr_tx_pausefrm_policy;
    logic [1:0]     csr_tx_pausefrm_xonxoff;
    logic [2:0]     csr_pfc_priority_num;
    //logic			csr_enable_preamble_passthrough; //move up
    logic [2:0]     csr_tx_sa_override_en;
    logic [7:0]     csr_tx_pipg_10g_dic;
    logic 	     	csr_status_tx_datafrm_tsfr_en_sts;
    logic 	     	csr_tx_stats_clr;
    logic [15:0]    csr_tx_xoff_hqt0;
    logic [15:0]    csr_tx_xoff_hqt1;
    logic [15:0]    csr_tx_xoff_hqt2;
    logic [15:0]    csr_tx_xoff_hqt3;
    logic [15:0]    csr_tx_xoff_hqt4;
    logic [15:0]    csr_tx_xoff_hqt5;
    logic [15:0]    csr_tx_xoff_hqt6;
    logic [15:0]    csr_tx_xoff_hqt7;
    
    logic [39:0]    sig_avalon_st_txstatus_data;
    logic [2:0]     sig_speed_sel_en;
    logic [1:0]     sig_avalon_st_pause_data;
    logic [15:0]    sig_avalon_st_tx_pause_length_data;
    logic           sig_avalon_st_tx_pause_length_valid;
    logic [71:0]    sig_xgmii_tx;	
    logic           sig_gmii_tx_en;
    logic           sig_gmii16b_tx_en;
    logic [15:0]    sig_avalon_st_tx_pfc_status_data;
    logic           sig_avalon_st_tx_pfc_status_valid;
    logic [15:0]    sig_avalon_st_tx_pfc_gen_data;
    logic [6:0] 	sig_avalon_st_txstatus_error;
    logic [6:0] 	sig_avalon_st_txstatus_error_reg;
    logic           sig_avalon_st_txstatus_valid;
    logic           sig_avalon_st_txstatus_valid_reg;
    logic           sig_avalon_st_tx_error;
    logic           sig_avalon_st_tx_error_reg;
    logic           sig_avalon_st_tx_valid;
    logic [1:0]		sig_link_fault_status_xgmii_tx_data;
    logic [1:0]		sig_link_fault_status_xgmii_tx_data_reg;
    logic [7:0]		sig_avalon_st_rx_pfc_pause_data;
    //`ifdef ENABLE_10GBASER_REG_MODE
    logic           sig_xgmii_tx_valid;
    logic           sig_xgmii_rx_valid;
    //`endif	
    
    
    //rx csr and signals
    //csr
    logic [31:0]    csr_rx_frm_ctl;
    logic           csr_rx_tsfr_sts;
    logic           csr_rx_tsfr_en_n;
    logic           csr_tx_tsfr_en_n;
    logic [31:0]    csr_rx_crcpad_ctl;
    logic           csr_rx_preamb_passthru_en;
    logic           csr_rx_crc_chk;
    logic 	     	csr_rx_stats_clr;
    logic 			csr_rx_pfc_ignore_pausefrm_1;
    logic 			csr_rx_pfc_fwd;
    logic [15:0]    csr_tx_pfcfrm_pqt0;
    logic      		csr_tx_pfcfrm_en0;
    
    
    //signals
    logic [15:0]    sig_avalon_st_rx_pause_length_data;
    logic      		sig_avalon_st_rx_pause_length_valid;
    logic [5:0]		sig_avalon_st_rx_error;
    logic [5:0]		sig_avalon_st_rx_error_reg;
    logic      		sig_avalon_st_rx_valid;
    logic      		sig_avalon_st_rx_valid_reg;
    logic      		sig_avalon_st_rx_endofpacket;
    logic      		sig_avalon_st_rx_endofpacket_reg;
    logic [6:0]		sig_avalon_st_rxstatus_error;
    logic [6:0]		sig_avalon_st_rxstatus_error_reg;
    logic      		sig_gmii_rx_err_reg;
    logic      		sig_avalon_st_rxstatus_valid;
    logic      		sig_avalon_st_rxstatus_valid_reg;
    logic			sig_gmii_rx_err;
    logic      		sig_mii_rx_err;
    logic      		sig_avalon_st_rx_ready;
    logic [1:0]		sig_link_fault_status_xgmii_rx_data;

    covergroup tx_status_error_cg;
        
        option.per_instance = 1;
        
        bic_sig_avalon_st_tx_error_assert_cp: coverpoint sig_avalon_st_tx_error{
            bins sig_avalon_st_tx_error_frame_eq_1 = {1'b1};
        }

		bic_sig_avalon_st_txstatus_valid_cp: coverpoint sig_avalon_st_txstatus_valid{
            bins sig_avalon_st_txstatus_valid_frame = {1'b1};
        }

		bic_sig_avalon_st_txstatus_error_no_error_cp: coverpoint sig_avalon_st_txstatus_error {
            bins sig_avalon_st_txstatus_error_no_error = {7'b000_0000};
        }
		
		bic_sig_avalon_st_txstatus_error_000_0001_cp: coverpoint sig_avalon_st_txstatus_error {
            wildcard bins sig_avalon_st_txstatus_error_000_0001 = {7'b???_???1};
        }
		
		bic_sig_avalon_st_txstatus_error_000_0010_cp: coverpoint sig_avalon_st_txstatus_error {
            wildcard bins sig_avalon_st_txstatus_error_000_0010 = {7'b???_??1?};
        }
		
		bic_sig_avalon_st_txstatus_error_000_0100_cp: coverpoint sig_avalon_st_txstatus_error {
            wildcard bins sig_avalon_st_txstatus_error_000_0100 = {7'b???_?1??};
        }
		
		bic_sig_avalon_st_txstatus_error_001_0000_cp: coverpoint sig_avalon_st_txstatus_error {
            wildcard bins sig_avalon_st_txstatus_error_001_0000 = {7'b??1_????};
        }
		
		bic_sig_avalon_st_txstatus_error_010_0000_cp: coverpoint sig_avalon_st_txstatus_error {
            wildcard bins sig_avalon_st_txstatus_error_010_0000 = {7'b?1?_????};
        }
	
    endgroup


   covergroup rx_status_error_cg;
        
        option.per_instance = 1;
        
        bic_sig_avalon_st_rx_error_assert_cp: coverpoint sig_avalon_st_rx_error{
            //bins sig_avalon_st_rx_error_frame_eq_1 = {1'b1};
            wildcard bins phy_error             = {6'b??_???1};
            wildcard bins crc_error             = {6'b??_??1?};
            wildcard bins undersize_error       = {6'b??_?1??};
            wildcard bins oversize_error        = {6'b??_1???};
            wildcard bins payload_length_error  = {6'b?1_????};
            wildcard bins overflow_error        = {6'b1?_????};
        }

		bic_sig_avalon_st_rxstatus_valid_cp: coverpoint sig_avalon_st_rxstatus_valid{
            bins sig_avalon_st_rxstatus_valid_frame = {1'b1};
        }

		bic_sig_avalon_st_rxstatus_error_no_error_cp: coverpoint sig_avalon_st_rxstatus_error {
            bins sig_avalon_st_rxstatus_error_no_error = {7'b000_0000};
        }
		
		bic_sig_avalon_st_rxstatus_error_000_0001_cp: coverpoint sig_avalon_st_rxstatus_error {
            wildcard bins sig_avalon_st_rxstatus_error_000_0001 = {7'b???_???1};
        }
		
		bic_sig_avalon_st_rxstatus_error_000_0010_cp: coverpoint sig_avalon_st_rxstatus_error {
            wildcard bins sig_avalon_st_rxstatus_error_000_0010 = {7'b???_??1?};
        }
		
		bic_sig_avalon_st_rxstatus_error_000_0100_cp: coverpoint sig_avalon_st_rxstatus_error {
            wildcard bins sig_avalon_st_rxstatus_error_000_0100 = {7'b???_?1??};
        }

      // below bits 4 and 5 of rx_status_error are unused in DM  --------------------------------------------//		
      //	bic_sig_avalon_st_rxstatus_error_001_0000_cp: coverpoint sig_avalon_st_rxstatus_error {      
      //      wildcard bins sig_avalon_st_rxstatus_error_001_0000 = {7'b??1_????};
      //  }
      //	
      //	bic_sig_avalon_st_rxstatus_error_010_0000_cp: coverpoint sig_avalon_st_rxstatus_error {
      //      wildcard bins sig_avalon_st_rxstatus_error_010_0000 = {7'b?1?_????};
      //  } 
      // ----------------------------------------------------------------------------------------------------//	
    endgroup

	

    covergroup cg_mac_frame;
	`ifdef ALTERA_BIC_QSE_MAC
		option.name = $psprintf(" %s",inst_name);
	`else
		option.name = $psprintf(" %s__%s", DUT_NAME, inst_name);
	`endif 
        
        option.per_instance = 1;
		
		//BIC cover points
		
		bic_oversized_frame_length_basic_cp: coverpoint frame_length 
		{
            bins length_1519_63996 = {[1519:63996]};
        }
		
		bic_oversized_frame_length_vlan_cp: coverpoint frame_length 
		{
            bins length_1523_63996 = {[1523:63996]};
        }
		
		bic_oversized_frame_length_svlan_cp: coverpoint frame_length 
		{
            bins length_1527_63996 = {[1527:63996]};
        }
		
		bic_jumbo_frame_length_basic_cp: coverpoint frame_length 
		{
            bins length_1519_63996 = {[1519:63996]};
        }
		
		bic_jumbo_frame_length_vlan_cp: coverpoint frame_length 
		{
            bins length_1523_63996 = {[1523:63996]};
        }
		
		bic_jumbo_frame_length_svlan_cp: coverpoint frame_length 
		{
            bins length_1527_63996 = {[1527:63996]};
        }
		
		bic_undersized_frame_length_preamble_off_cp: coverpoint frame_length 
		{
            bins length_9_63 = {[9:63]};
        }
		
		bic_undersized_frame_length_preamble_on_cp: coverpoint frame_length 
		{
            bins length_17_71 = {[17:71]};
        }
		
		bic_frame_length_cp: coverpoint frame_length 
		{
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1517 = {[1024:1517]};
            bins length_1518 = {1518};
            bins length_gt_1518 = {[1519:9600]};
            //bins length_64000 = {64000}; //TODO: temporary ignore
        }
		
        bic_tag_type_cp: coverpoint tag_type
        {
            bins basic_frame = {UNTAGGED};
            bins vlan_frame = {VLAN};
            bins svlan_frame = {SVLAN};
        }
		
        bic_tag_basic_type_cp: coverpoint tag_type
        {
            bins basic_frame = {UNTAGGED};
        }
		
        bic_tag_vlan_type_cp: coverpoint tag_type
        {
            bins vlan_frame = {VLAN};
        }
		
        bic_tag_svlan_type_cp: coverpoint tag_type
        {
            bins svlan_frame = {SVLAN};
        }
		
        bic_da_type_cp: coverpoint da_type
		{
            bins unicast            = {UNICAST};
            bins multicast          = {MULTICAST};
            bins broadcast          = {BROADCAST};
        }
	

        //DOUBT ipg??	
        //TODO: Remove - temporary take it as non b2b
		bic_b2b_cp: coverpoint ipg {
            bins ipg_b2b = {[1:$]};
        }
		
        bic_non_b2b_cp: coverpoint ipg {
            bins ipg_non_b2b = {[1:$]};  //we can put the range as infinite
        }
		
        bic_ipg_10g_cp: coverpoint ipg {
            bins ipg_8 = {0};
            bins ipg_12 = {1};
        }
		
        bic_ipg_10_100m_cp: coverpoint ipg_10m_100m_1G {
            bins ipg[7] = {[8:15]};
            //coverage disabled for 10m and 100m
            ignore_bins ipg_ignore = {[8:11],[13:15]};
        }

        bic_control_frame_type_cp: coverpoint control_type { 
            // bins pfc_control = {PFC_CONTROL}; PFC not supported in mgbaset
            bins pause_control = {PAUSE_CONTROL};
        }

//DOUBT: redundant...tx and rx are sampled seperately
        bic_rx_control_frame_type_cp: coverpoint control_type {
             bins pfc_control = {PFC_CONTROL}; //PFC not supported in mgbaset
            bins pause_control = {PAUSE_CONTROL};
        }

		bic_b2b_x_control_frame_type_cp: cross bic_b2b_cp, bic_control_frame_type_cp ;
		
		bic_b2b_x_tag_type_cp: cross bic_b2b_cp, bic_tag_type_cp ;

        bic_frame_length_x_bic_tag_type_cp: cross bic_frame_length_cp, bic_tag_type_cp ;
		
        bic_frame_length_x_bic_tag_type_cp_x_bic_da_type_cp: cross bic_frame_length_x_bic_tag_type_cp, bic_da_type_cp ;
		
        bic_frame_length_x_bic_tag_type_cp_x_bic_da_type_x_bic_b2b_cp: cross bic_frame_length_x_bic_tag_type_cp_x_bic_da_type_cp, bic_b2b_cp;
		
        bic_frame_length_x_bic_tag_type_cp_x_bic_da_type_x_bic_non_b2b_cp: cross bic_frame_length_x_bic_tag_type_cp_x_bic_da_type_cp, bic_non_b2b_cp;
		
		//6.2.2.12	adv_32b_tx_ms_oversized_err
		
		bic_tag_basic_type_x_bic_oversized_frame_length_basic_cp: cross bic_tag_basic_type_cp, bic_oversized_frame_length_basic_cp ;
		
		bic_tag_vlan_type_x_bic_oversized_frame_length_vlan_cp: cross bic_tag_vlan_type_cp, bic_oversized_frame_length_vlan_cp ;
		
		bic_tag_svlan_type_x_bic_oversized_frame_length_svlan_cp: cross bic_tag_svlan_type_cp, bic_oversized_frame_length_svlan_cp ;

		//6.2.3.1	basic_32b_rx_ms_data_frm
		bic_frame_length_cp_x_bic_tag_type_cp: cross bic_frame_length_cp, bic_tag_type_cp ;
		
		
		bic_ipg_1g_x_control_frame_type_cp: cross bic_ipg_10g_cp, bic_control_frame_type_cp ;
		
		bic_ipg_1g_x_tag_type_cp: cross bic_ipg_10g_cp, bic_tag_type_cp ;
		
		bic_ipg_10_100m_x_control_frame_type_cp: cross bic_ipg_10_100m_cp, bic_control_frame_type_cp ;
		
		bic_ipg_10_100m_x_tag_type_cp: cross bic_ipg_10_100m_cp, bic_tag_type_cp ;
		
		//6.2.3.13	adv_32b_rx_ms_oversized_err
		
		bic_tag_basic_type_x_bic_jumbo_frame_length_basic_cp: cross bic_tag_basic_type_cp, bic_jumbo_frame_length_basic_cp ;
		
		bic_tag_vlan_type_x_bic_jumbo_frame_length_vlan_cp: cross bic_tag_vlan_type_cp, bic_jumbo_frame_length_vlan_cp ;
		
		bic_tag_svlan_type_x_bic_jumbo_frame_length_svlan_cp: cross bic_tag_svlan_type_cp, bic_jumbo_frame_length_svlan_cp ;

		
        /////////////////////////////////////////////////////////////////
        // Frame Length
        /////////////////////////////////////////////////////////////////
        // Any Error
        frame_length_cp: coverpoint frame_length {
            bins length_64 = {64};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        // No Error TSE
        frame_length_no_error_tse_cp: coverpoint frame_length iff(error_type == NO_ERROR) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error
        frame_length_no_error_cp: coverpoint frame_length iff(error_type == NO_ERROR) {
            bins length_64 = {64};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        // No Error-frame_length_no_error_cuthrough_threshold_4_cp
        frame_length_no_error_cuthrough_threshold_4_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-frame_length_no_error_cuthrough_threshold_16_cp
        frame_length_no_error_cuthrough_threshold_16_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        //DOUBT
        // valid SFD-mac_sfd_untagged_cp
        mac_sfd_untagged_cp: coverpoint frame_length iff(tag_type == UNTAGGED){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
        }
        
        // invalid SFD-mac_sfd_untagged_cp
        mac_sfd_invalid_untagged_cp: coverpoint frame_length iff(tag_type == UNTAGGED){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
        }
        
        // valid SFD-mac_sfd_vlan_cp
        mac_sfd_vlan_cp: coverpoint frame_length iff(tag_type == VLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
        }
        
        // invalid SFD-mac_sfd_vlan_cp
        mac_sfd_invalid_vlan_cp: coverpoint frame_length iff(tag_type == VLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
        }
        
        // valid SFD-mac_sfd_svlan_cp
        mac_sfd_svlan_cp: coverpoint frame_length iff(tag_type == SVLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
        }
        
        // invalid SFD-mac_sfd_vlan_cp
        mac_sfd_invalid_svlan_cp: coverpoint frame_length iff(tag_type == SVLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
        }
        
         //MEENU_DOUBT 
        // No Error-mac_sft_reset
        frame_length_mac_sft_reset_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_txrx_dis
        frame_length_mac_txrx_dis_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-phy_loopback-full duplex
        frame_length_phy_loopback_fd_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-phy_loopback-half duplex
        frame_length_phy_loopback_hd_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }

        // No Error-mac_tx_fwdcrc_en_basic
        frame_length_mac_tx_fwdcrc_en_basic_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_tx_fwdcrc_en_vlan
        frame_length_mac_tx_fwdcrc_en_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_tx_fwdcrc_en_svlan
        frame_length_mac_tx_fwdcrc_en_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_tx_fwdcrc_dis_basic
        frame_length_mac_tx_fwdcrc_dis_basic_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_tx_fwdcrc_dis_vlan
        frame_length_mac_tx_fwdcrc_dis_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_tx_fwdcrc_dis_svlan
        frame_length_mac_tx_fwdcrc_dis_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_frame_length_mac_cuthrough_threshold
        mac_frame_length_mac_cuthrough_threshold_cp: coverpoint frame_length iff(error_type == NO_ERROR) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_tx_omitcrc_en_basic
        frame_length_mac_tx_omitcrc_en_basic_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_tx_omitcrc_en_vlan
        frame_length_mac_tx_omitcrc_en_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_tx_omitcrc_en_svlan
        frame_length_mac_tx_omitcrc_en_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_tx_omitcrc_dis_basic
        frame_length_mac_tx_omitcrc_dis_basic_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_tx_omitcrc_dis_vlan
        frame_length_mac_tx_omitcrc_dis_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_tx_omitcrc_dis_svlan
        frame_length_mac_tx_omitcrc_dis_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_mcast_hstbl_f48_odd_mcast
        frame_length_mac_mcast_hstbl_f48_odd_mcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == MULTICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_f48_odd_ucast
        frame_length_mac_mcast_hstbl_f48_odd_ucast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == UNICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_f48_odd_bcast
        frame_length_mac_mcast_hstbl_f48_odd_bcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == BROADCAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_f48_even_mcast
        frame_length_mac_mcast_hstbl_f48_even_mcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == MULTICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_f48_even_ucast
        frame_length_mac_mcast_hstbl_f48_even_ucast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == UNICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_f48_even_bcast
        frame_length_mac_mcast_hstbl_f48_even_bcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == BROADCAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_l24_odd_mcast
        frame_length_mac_mcast_hstbl_l24_odd_mcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == MULTICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_l24_odd_ucast
        frame_length_mac_mcast_hstbl_l24_odd_ucast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == UNICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_l24_odd_bcast
        frame_length_mac_mcast_hstbl_l24_odd_bcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == BROADCAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_l24_even_mcast
        frame_length_mac_mcast_hstbl_l24_even_mcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == MULTICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_l24_even_ucast
        frame_length_mac_mcast_hstbl_l24_even_ucast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == UNICAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error-mac_mcast_hstbl_l24_even_bcast
        frame_length_mac_mcast_hstbl_l24_even_bcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == BROADCAST)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // Magic packet-mac_mg_register_multicast
        frame_length_mac_mg_register_mcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == MULTICAST)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        // Magic packet-mac_mg_register_unicast
        frame_length_mac_mg_register_ucast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == UNICAST)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        // Magic packet-mac_mg_register_broadcast
        frame_length_mac_mg_register_bcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == BROADCAST)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        // Magic packet-mac_mg_signal_multicast
        frame_length_mac_mg_signal_mcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == MULTICAST)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        // Magic packet-mac_mg_signal_unicast
        frame_length_mac_mg_signal_ucast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == UNICAST)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        // Magic packet-mac_mg_signal_broadcast
        frame_length_mac_mg_signal_bcast_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (da_type == BROADCAST)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        // Padded No Error Untagged for tse
        // pad_en=1, crc_en = 1 (dut will insert pad and crc ) -->  frame_length will be 60 (PREAMBLE + CRC won't be included in packed_size), we can send random lentgh_type 
        // pad_en =1 , crc_en = 0 (invalid)
        // pad_en = 0, crc_en = 0/1 --> client should send min legnth (64 bytes) as per IEEE spec, we can't send random length_type
        frame_length_mac_tx_pad_basic_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length[47] = {[0:46]};
            ignore_bins length_DM_RX[47] = {[0:46]} iff (tx_rx==0);
        }
        
        // Padded No Error VLAN Tagged for tse
        frame_length_mac_tx_pad_vlan_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length[43] = {[0:42]};
            ignore_bins length_DM_RX[43] = {[0:42]}  iff (tx_rx==0);
        }
        
        // Padded No Error SVLAN Tagged for tse
        frame_length_mac_tx_pad_svlan_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length[39] = {[0:38]};
            ignore_bins length_DM_RX[39] = {[0:38]}  iff (tx_rx==0);
        }

        frame_length_mac_rx_pad_basic_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length[47] = {[0:46]};
            ignore_bins length_DM_TX[47] = {[0:46]}   iff (tx_rx==1);
        }
        
        // Padded No Error VLAN Tagged for tse
        frame_length_mac_rx_pad_vlan_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length[43] = {[0:42]};
            ignore_bins length_DM_TX[43] = {[0:42]}  iff (tx_rx==1);
        }
        
        // Padded No Error SVLAN Tagged for tse
        frame_length_mac_rx_pad_svlan_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length[39] = {[0:38]};
            ignore_bins length_DM_TX[39] = {[0:38]}   iff (tx_rx==1);
        }
        
        // No Error-mac_tx_insert_macaddr_en_pri_cp
        mac_tx_insert_macaddr_en_pri_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)&&(da_ucast_type == UCAST_ADDR)){
            bins length_64 = {64}; 
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // No Error-mac_tx_insert_macaddr_en_sup0_cp
        mac_tx_insert_macaddr_en_sup0_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)&&(da_ucast_type == SUPP_ADDR_0)){
            bins length_64 = {64}  ; 
            bins length_65_127 = {[65:127]} ;
            bins length_128_255 = {[128:255]} ;
            bins length_256_511 = {[256:511]} ;
            bins length_512_1023 = {[512:1023]} ;
            bins length_1024_1518 = {[1024:1518]} ;
            //Supplementary address not supported in TX direction 
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1) ;
            ignore_bins length_65_127_DM_TX = {[65:127]}  iff (tx_rx==1);
            ignore_bins length_128_255_DM_TX = {[128:255]} iff (tx_rx==1);
            ignore_bins length_256_511_DM_TX = {[256:511]} iff (tx_rx==1);
            ignore_bins length_512_1023_DM_TX = {[512:1023]} iff (tx_rx==1);
            ignore_bins length_1024_1518_DM_TX = {[1024:1518]} iff (tx_rx==1);
        }
        
        // No Error-mac_tx_insert_macaddr_en_sup1_cp
        mac_tx_insert_macaddr_en_sup1_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)&&(da_ucast_type == SUPP_ADDR_1)){
            bins length_64 = {64} ; 
            bins length_65_127 = {[65:127]} ;
            bins length_128_255 = {[128:255]} ;
            bins length_256_511 = {[256:511]} ;
            bins length_512_1023 = {[512:1023]} ;
            bins length_1024_1518 = {[1024:1518]} ;
            //Supplementary address not supported in TX direction 
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1); 
            ignore_bins length_65_127_DM_TX = {[65:127]}  iff (tx_rx==1);
            ignore_bins length_128_255_DM_TX = {[128:255]} iff (tx_rx==1);
            ignore_bins length_256_511_DM_TX = {[256:511]} iff (tx_rx==1);
            ignore_bins length_512_1023_DM_TX = {[512:1023]} iff (tx_rx==1);
            ignore_bins length_1024_1518_DM_TX = {[1024:1518]} iff (tx_rx==1);
        }
        
        // No Error-mac_tx_insert_macaddr_en_sup2_cp
        mac_tx_insert_macaddr_en_sup2_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)&&(da_ucast_type == SUPP_ADDR_2)){
            bins length_64 = {64} ; 
            bins length_65_127 = {[65:127]} ;
            bins length_128_255 = {[128:255]} ;
            bins length_256_511 = {[256:511]} ;
            bins length_512_1023 = {[512:1023]} ;
            bins length_1024_1518 = {[1024:1518]} ;
            //Supplementary address not supported in TX direction 
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1) ;
            ignore_bins length_65_127_DM_TX = {[65:127]}  iff (tx_rx==1);
            ignore_bins length_128_255_DM_TX = {[128:255]} iff (tx_rx==1);
            ignore_bins length_256_511_DM_TX = {[256:511]} iff (tx_rx==1);
            ignore_bins length_512_1023_DM_TX = {[512:1023]} iff (tx_rx==1);
            ignore_bins length_1024_1518_DM_TX = {[1024:1518]} iff (tx_rx==1);
        }
        
        // No Error-mac_tx_insert_macaddr_en_sup3_cp
        mac_tx_insert_macaddr_en_sup3_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)&&(da_ucast_type == SUPP_ADDR_3)){
            bins length_64 = {64} ; 
            bins length_65_127 = {[65:127]} ;
            bins length_128_255 = {[128:255]} ;
            bins length_256_511 = {[256:511]} ;
            bins length_512_1023 = {[512:1023]} ;
            bins length_1024_1518 = {[1024:1518]} ;
            //Supplementary address not supported in TX direction 
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1); 
            ignore_bins length_65_127_DM_TX = {[65:127]}  iff (tx_rx==1);
            ignore_bins length_128_255_DM_TX = {[128:255]} iff (tx_rx==1);
            ignore_bins length_256_511_DM_TX = {[256:511]} iff (tx_rx==1);
            ignore_bins length_512_1023_DM_TX = {[512:1023]} iff (tx_rx==1);
            ignore_bins length_1024_1518_DM_TX = {[1024:1518]} iff (tx_rx==1);
        }
        
        // No Error-mac_local_loopback_untagged_cp
        mac_local_loopback_untagged_cp: coverpoint frame_length iff(tag_type == UNTAGGED){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        // No Error-mac_local_loopback_vlan_cp
        mac_local_loopback_vlan_cp: coverpoint frame_length iff(tag_type == VLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        // No Error-mac_local_loopback_svlan_cp
        mac_local_loopback_svlan_cp: coverpoint frame_length iff(tag_type == SVLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        // No Error-mac_local_loopback_dis_untagged_cp
        mac_local_loopback_dis_untagged_cp: coverpoint frame_length iff(tag_type == UNTAGGED){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        // No Error-mac_local_loopback_dis_vlan_cp
        mac_local_loopback_dis_vlan_cp: coverpoint frame_length iff(tag_type == VLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        // No Error-mac_local_loopback_dis_svlan_cp
        mac_local_loopback_dis_svlan_cp: coverpoint frame_length iff(tag_type == SVLAN){
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        // No Error-pcs_1000basex_rx_fd_cp
        frame_length_pcs_1000basex_rx_fd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        
        // No Error-pcs_1000basex_tx_fd_cp
        frame_length_pcs_1000basex_tx_fd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        
        // No Error-pcs_isolate_fd_cp
        frame_length_pcs_isolate_fd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        
        // No Error-pcs_soft_reset_fd_cp
        frame_length_pcs_soft_reset_fd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        
        // No Error-pcs_phy_powerdown_fd
        frame_length_pcs_phy_powerdown_fd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        
        // No Error-pcs_phy_loopback_fd
        frame_length_pcs_phy_loopback_fd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        
        // No Error-pcs_phy_powerdown_hd
        frame_length_pcs_phy_powerdown_hd_cp: coverpoint frame_length iff(error_type == NO_ERROR){
            bins length_64_1518 = {[64:1518]};
        }
        // No Error-mac_shift16_on_fd_cp
        mac_shift16_on_fd_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64 = {64}; 
            bins length_1518 = {1518};
            bins length_16384 = {16384}; 
        }
        
        // No Error-mac_shift16_on_hd_cp
        mac_shift16_on_hd_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64 = {64}; 
            bins length_1518 = {1518};
            bins length_16384 = {16384}; 
        }
        
        // No Error-mac_shift16_off_fd_cp
        mac_shift16_off_fd_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64 = {64}; 
            bins length_1518 = {1518};
            bins length_16384 = {16384}; 
        }
        
        // No Error-mac_shift16_off_hd_cp
        mac_shift16_off_hd_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64 = {64}; 
            bins length_1518 = {1518};
            bins length_16384 = {16384}; 
        }
        
        // No Error-mac_vlan_paddis_cp
        mac_vlan_paddis_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)){
            bins length_64 = {64}; 
            bins length_1518 = {100};
            bins length_16384 = {1518}; 
        }
        
        // No Error-mac_svlan_paddis_cp
        mac_svlan_paddis_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)){
            bins length_64 = {64}; 
            bins length_1518 = {100};
            bins length_16384 = {1518}; 
        }
        
        // No Error-mac_vlan_paden_cp
        mac_vlan_paden_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)){
            bins length_64 = {64}; 
            bins length_1518 = {100};
            bins length_16384 = {1518}; 
        }
        
        // No Error-mac_svlan_paden_cp
        mac_svlan_paden_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)){
            bins length_64 = {64}; 
            bins length_1518 = {100};
            bins length_16384 = {1518}; 
        }
        
        // Jumbo No Errori
        // JUMBO FRAME : payload size > 1536 ( frame_length > 1536+18 (DATA), >1536+22(VLAN), >1536+26(SVLAN)
        jumbo_frame_length_no_error_cp: coverpoint frame_length iff((error_type == NO_ERROR)&&(is_jumbo==1)) {
            bins length_1519 = {1555};
            bins length_9600 = {9618};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00??????_?????000} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00??????_?????001} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00??????_?????010} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00??????_?????011} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00??????_?????100} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00??????_?????101} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00??????_?????110} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00??????_?????111} iff((frame_length > 1519) && (frame_length < 9600));
        }
        
        // Jumbo No Error-untagged tse
        jumbo_frame_length_no_error_tse_untagged_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)){
            bins length_64_1518 = {[64:1518]};
            bins length_1519_9599 = {[1519:9599]};
            bins length_9600_10239 = {[9600:10239]};
            //bins length_10240 = {10240}; not supported by nsys BFM
        }
        
        // Jumbo No Error-VLAN tse
        jumbo_frame_length_no_error_tse_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)&&(is_jumbo==1)){
            bins length_1559_9599 = {[1559:9599]};
            bins length_9600_10239 = {[9600:10239]};
            //bins length_10240 = {10240}; not supported by nsys BFM
        }
        
     //   // Jumbo No Error-SVLAN tse
        jumbo_frame_length_no_error_tse_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN) &&(is_jumbo==1)){
            bins length_1563_9599 = {[1563:9599]};
            bins length_9600_10239 = {[9600:10239]};
            //bins length_10240 = {10240}; not supported by nsys BFM
        }
        
        // Jumbo No Error-untagged tse mac_only
        jumbo_frame_length_no_error_tse_untagged_mac_only_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED) &&(is_jumbo==1)){
            bins length_1555_9599 = {[1555:9599]};
            bins length_9600_10239 = {[9600:10239]};
            //bins length_10240 = {10240}; not supported by nsys BFM
        }
        
        // CRC Error TSE
        frame_length_error_crc_tse_cp: coverpoint frame_length iff(error_type & ERROR_CRC) {
            bins length_64 = {64} ;
            bins length_65_1517 = {[65:1517]} ;
            bins length_1518 = {1518} ;
            //CRC not supported in TX direction
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1);
            ignore_bins length_65_1517_DM_TX = {[65:1517]}  iff(tx_rx==1);
            ignore_bins length_1518_DM_TX = {1518}  iff( tx_rx==1);
        }
        
        // CRC Error
        frame_length_error_crc_cp: coverpoint frame_length iff(error_type & ERROR_CRC) {
            bins length_64 = {64} ;
            bins length_1518 = {1518} ;
            //CRC not supported in TX direction
            ignore_bins  length_64_DM_TX = {64}  iff(tx_rx==1);
            ignore_bins length_1518_DM_TX = {1518}  iff (tx_rx==1);
            ignore_bins length_65_1517_DM_TX = {[65:1517]} iff (tx_rx==1);
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0) ;// with (item && tx_rx==0);
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);  
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518)  && tx_rx==0);
        }
        
        // Payload Length Error
        frame_length_error_payload_length_cp: coverpoint frame_length iff(error_type & ERROR_PAYLOAD_LENGTH) {
            bins length_64 = {64};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        // Payload Length Error-mac_rx_disc_err_en_basic 
        mac_rx_disc_err_en_basic_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_disc_err_en_vlan 
        mac_rx_disc_err_en_vlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_disc_err_en_svlan 
        mac_rx_disc_err_en_svlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_disc_err_dis_basic 
        mac_rx_disc_err_dis_basic_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_disc_err_dis_vlan 
        mac_rx_disc_err_dis_vlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_disc_err_dis_svlan 
        mac_rx_disc_err_dis_svlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_no_lgth_check_en_basic 
        mac_rx_no_lgth_check_en_basic_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_no_lgth_check_en_vlan 
        mac_rx_no_lgth_check_en_vlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_no_lgth_check_en_svlan 
        mac_rx_no_lgth_check_en_svlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_no_lgth_check_dis_basic 
        mac_rx_no_lgth_check_dis_basic_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_no_lgth_check_dis_vlan 
        mac_rx_no_lgth_check_dis_vlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }
        
        // Payload Length Error-mac_rx_no_lgth_check_dis_svlan_cp 
        mac_rx_no_lgth_check_dis_svlan_cp: coverpoint frame_length iff((error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }

        // No Error Untagged
        frame_length_no_error_untagged_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        // No Error VLAN Tagged
        frame_length_no_error_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_1522 = {1522};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1522));
        }
        
        // No Error Stacked VLAN Tagged
        frame_length_no_error_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_1526 = {1526};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1526));
        }
        
        // Oversized Error Untagged
        jumbo_frame_length_error_oversized_untagged_cp: coverpoint frame_length iff((error_type & ERROR_OVERSIZED) && (tag_type == UNTAGGED)) {
            bins length_1519 = {1519};
            bins length_9600 = {9600};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00??????_?????000} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00??????_?????001} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00??????_?????010} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00??????_?????011} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00??????_?????100} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00??????_?????101} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00??????_?????110} iff((frame_length > 1519) && (frame_length < 9600));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00??????_?????111} iff((frame_length > 1519) && (frame_length < 9600));
        }
        
        // Oversized Error VLAN Tagged
        jumbo_frame_length_error_oversized_vlan_cp: coverpoint frame_length iff((error_type & ERROR_OVERSIZED) && (tag_type == VLAN)&&(is_jumbo == 1)) {
            bins length_1523 = {1523};
            bins length_9600 = {9600};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00??????_?????000} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00??????_?????001} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00??????_?????010} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00??????_?????011} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00??????_?????100} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00??????_?????101} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00??????_?????110} iff((frame_length > 1523) && (frame_length < 9600));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00??????_?????111} iff((frame_length > 1523) && (frame_length < 9600));
        }
        
        // Oversized Error SVLAN Tagged
        jumbo_frame_length_error_oversized_svlan_cp: coverpoint frame_length iff((error_type & ERROR_OVERSIZED) && (tag_type == SVLAN) && (is_jumbo == 1)) {
            bins length_1527 = {1527};
            bins length_9600 = {9600};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00??????_?????000} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00??????_?????001} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00??????_?????010} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00??????_?????011} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00??????_?????100} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00??????_?????101} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00??????_?????110} iff((frame_length > 1527) && (frame_length < 9600));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00??????_?????111} iff((frame_length > 1527) && (frame_length < 9600));
        }
        
        //frame_length_variable_preamble_untagged_tse
        frame_length_variable_preamble_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        //frame_length_variable_preamble_vlan_tse
        frame_length_variable_preamble_vlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        //frame_length_variable_preamble_svlan_tse
        frame_length_variable_preamble_svlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64_1518 = {[64:1518]};
        }
        
        //frame_length_preamble_error_untagged_tse
        frame_length_preamble_error_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_preamble_error_vlan_tse
        frame_length_preamble_error_vlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_preamble_error_svlan_tse
        frame_length_preamble_error_svlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_preamble_valid_untagged_tse
        frame_length_preamble_valid_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_preamble_valid_vlan_tse
        frame_length_preamble_valid_vlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_preamble_valid_svlan_tse
        frame_length_preamble_valid_svlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error Untagged Tse
        frame_length_no_error_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error VLAN Tagged Tse
        frame_length_no_error_vlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // No Error Stacked VLAN Tagged Tse
        frame_length_no_error_svlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // Oversized Error Untagged Tse
        jumbo_frame_length_error_oversized_untagged_tse_cp: coverpoint frame_length iff((error_type & ERROR_OVERSIZED) && (tag_type == UNTAGGED)) {
            bins length_9600_10240 = {[9600:10240]};
        }
        
        // Oversized Error VLAN Tagged Tse
        jumbo_frame_length_error_oversized_vlan_tse_cp: coverpoint frame_length iff((error_type & ERROR_OVERSIZED) && (tag_type == VLAN)) {
            bins length_9600_10240 = {[9600:10240]};
        }
        
        // Oversized Error SVLAN Tagged_Tse
        jumbo_frame_length_error_oversized_svlan_tse_cp: coverpoint frame_length iff((error_type & ERROR_OVERSIZED) && (tag_type == SVLAN)) {
            bins length_9600_10240 = {[9600:10240]};
        }
        
        // Undersized Error Untagged
        frame_length_error_undersized_fragment_untagged_cp: coverpoint frame_length iff((error_type & ERROR_UNDERSIZED) && (tag_type == UNTAGGED)) {
            bins length_0_17 = {[0:17]};
           // bins length[18] = {[0:17]};
        }
        
        frame_length_error_undersized_runt_untagged_cp: coverpoint frame_length iff((error_type & ERROR_UNDERSIZED) && (tag_type == UNTAGGED)) {
            bins length_18_32 = {[18:32]};
            bins length_33_63 = {[33:63]};
            //bins length[46] = {[18:63]};
        }
        
        // Undersized Error VLAN Tagged
        // TX direction if we enable or disable the padding we receive padded packed_bytes from the monitor
        // minimum 60B we receive as packed_bytes
        frame_length_error_undersized_fragment_vlan_cp: coverpoint frame_length iff((error_type & ERROR_UNDERSIZED) && (tag_type == VLAN)) {
            bins length_18_21 = {[18:21]};
            ignore_bins length_18_21_DM_TX = {[18:21]} iff (tx_rx==1);
           // bins length[9] = {[18:21]};
        }
        
        frame_length_error_undersized_runt_vlan_cp: coverpoint frame_length iff((error_type & ERROR_UNDERSIZED) && (tag_type == VLAN)) {
            bins length_22_32 = {[22:32]};
            bins length_32_63 = {[33:63]};
           // bins length[42] = {[22:63]};
        }
        
        // Undersized Error SVLAN Tagged
        // TX direction if we enable or disable the padding we receive padded packed_bytes from the monitor
        // minimum 60B we receive as packed_bytes
        frame_length_error_undersized_fragment_svlan_cp: coverpoint frame_length iff((error_type & ERROR_UNDERSIZED) && (tag_type == SVLAN)) {
            bins length_18_25 = {[18:25]};
            ignore_bins length_18_25_DM_TX = {[18:25]} iff (tx_rx==1) ;
           // bins length[9] = {[18:25]};
        }
        
        frame_length_error_undersized_runt_svlan_cp: coverpoint frame_length iff((error_type & ERROR_UNDERSIZED) && (tag_type == SVLAN)) {
            bins length_26_32 = {[26:32]};
            bins length_33_63 = {[33:63]};
           // bins length[38] = {[26:63]};
        }
        
        // Payload Length Error Untagged - Fix 64 bytes frame size
        payload_length_error_fix_64_untagged_cp: coverpoint length_type iff((frame_length == 64) && (error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == UNTAGGED)) {
           //  bins length_47 = {47}; with this combination its not possible
            bins length_48_1499 = {[48:1499]};
            bins length_1500 = {1500};
            bins length_1501_1534 = {[1501:1534]};
            bins length_1535 = {1535};
        }
        
        // Payload Length Error VLAN Tagged - Fix 64 bytes frame size
        payload_length_error_fix_64_vlan_cp: coverpoint length_type iff((frame_length == 64) && (error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == VLAN)) {
            // bins length_43 = {43}; with this combination its not possible
            bins length_44_1499 = {[44:1499]};
            bins length_1500 = {1500};
            bins length_1501_1534 = {[1501:1534]};
            bins length_1535 = {1535};
        }
        
        // Payload Length Error SVLAN Tagged - Fix 64 bytes frame size
        payload_length_error_fix_64_svlan_cp: coverpoint length_type iff((frame_length == 64) && (error_type & ERROR_PAYLOAD_LENGTH) && (tag_type == SVLAN)) {
            // bins length_39 = {39}; with this combination its not possible 
            bins length_40_1499 = {[40:1499]};
            bins length_1500 = {1500};
            bins length_1501_1534 = {[1501:1534]};
            bins length_1535 = {1535};
        }
        
        //frame_length_mac_min_ipg_untagged_tse
        frame_length_mac_min_ipg_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_mac_min_ipg_vlan_tse
        frame_length_mac_min_ipg_vlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        //frame_length_mac_min_ipg_svlan_tse
        frame_length_mac_min_ipg_svlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // Payload Untagged - Length/type = Frame Length + 1
        payload_length_error_length_gt_frame_length_untagged_cp: coverpoint frame_length iff((length_type == frame_length - 18 + 1)  && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        // Payload VLAN Tagged - Length/type = Frame Length + 1
        payload_length_error_length_gt_frame_length_vlan_tagged_cp: coverpoint frame_length iff((length_type == (frame_length - 22) + 1)  && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_1522 = {1522};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1522));
        }
        
        // SVLAN Tagged - Length/type = Frame Length + 1
        payload_length_error_length_gt_frame_length_svlan_tagged_cp: coverpoint frame_length iff((length_type == (frame_length - 26) + 1) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_1526 = {1526};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1526));
        }
        
        // Excess Pad Untagged - Fix 46 length/type
        excess_pad_fix_46_length_untagged_cp: coverpoint frame_length iff((length_type == 46) && (tag_type == UNTAGGED)) {
            bins length_65 = {65};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1518));
        }
        
        // Excess Pad VLAN Tagged - Fix 42 length/type
        excess_pad_fix_42_length_vlan_cp: coverpoint frame_length iff((length_type == 42) && (tag_type == VLAN)) {
            bins length_65 = {65};
            bins length_1522 = {1522};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1522));
        }
        
        // Excess Pad VLAN Tagged - Fix 38 length/type
        excess_pad_fix_38_length_svlan_cp: coverpoint frame_length iff((length_type == 38) && (tag_type == SVLAN)) {
            bins length_65 = {65};
            bins length_1526 = {1526};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1526));
        }
        
        // Excess Pad Untagged - Frame Length = Length/type + 1
        excess_pad_frame_length_gt_length_untagged_cp: coverpoint frame_length iff((length_type +1 == (frame_length - 18)) && (tag_type == UNTAGGED)) {
            bins length_65 = {65};
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1518));
        }
        
        // Excess Pad VLAN Tagged - Frame Length = Length/type + 1
        excess_pad_frame_length_gt_length_vlan_cp: coverpoint frame_length iff((length_type +1  == (frame_length - 22)) && (tag_type == VLAN)) {
            bins length_65 = {65};
            bins length_1518 = {1522};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1522));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1522));
        }
        
        // Excess Pad SVLAN Tagged - Frame Length = Length/type + 1
        excess_pad_frame_length_gt_length_svlan_cp: coverpoint frame_length iff((length_type +1  == (frame_length - 26)) && (tag_type == SVLAN)) {
            bins length_65 = {65};
            bins length_1518 = {1526};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1526));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1526));
        }
        
        // Padded No Error Untagged
        padded_payload_length_untagged_tx_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length[47] = {[0:46]};
            ignore_bins length_DM_RX[47] = {[0:46]} iff(tx_rx==0);
        }
        
        // Padded No Error VLAN Tagged
        padded_payload_length_vlan_tx_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length[43] = {[0:42]};
            ignore_bins length_DM_RX[43] = {[0:42]} iff(tx_rx==0);
        }
        
        // Padded No Error SVLAN Tagged
        padded_payload_length_svlan_tx_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length[39] = {[0:38]};
            ignore_bins length_DM_RX[39] = {[0:38]} iff(tx_rx==0);
        }
        
        // Padded No Error Untagged Tse
        padded_payload_length_untagged_tse_tx_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_46 = {[0:46]};
            ignore_bins length_46_DM_RX = {[0:46]} iff(tx_rx==0);
        }
        
        // Padded No Error VLAN Tagged Tse
        padded_payload_length_vlan_tse_tx_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_42 = {[0:42]};
            ignore_bins length_42_DM_RX = {[0:42]} iff(tx_rx==0);
        }
        
        // Padded No Error SVLAN Tagged Tse
        padded_payload_length_svlan_tse_tx_cp: coverpoint length_type iff((frame_length == 60) && (error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_38 = {[0:38]};
            ignore_bins length_38_DM_RX = {[0:38]} iff(tx_rx==0);
        }
       
        // Padded No Error Untagged
        padded_payload_length_untagged_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length[47] = {[0:46]} ;
            ignore_bins length_DM_RX[47] = {[0:46]} iff(tx_rx==0);
        }
        
        // Padded No Error VLAN Tagged
        padded_payload_length_vlan_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length[43] = {[0:42]};
            ignore_bins length_DM_RX[43] = {[0:42]} iff(tx_rx==1);
        }
        
        // Padded No Error SVLAN Tagged
        padded_payload_length_svlan_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length[39] = {[0:38]};
            ignore_bins length_DM_RX[39] = {[0:38]} iff(tx_rx==1);
        }
        
        // Padded No Error Untagged Tse
        padded_payload_length_untagged_tse_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_46 = {[0:46]};
            ignore_bins length_46_DM_RX = {[0:46]} iff(tx_rx==0);
        }
        
        // Padded No Error VLAN Tagged Tse
        padded_payload_length_vlan_tse_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_42 = {[0:42]};
            ignore_bins length_42_DM_RX = {[0:42]} iff(tx_rx==1);
        }
        
        // Padded No Error SVLAN Tagged Tse
        padded_payload_length_svlan_tse_cp: coverpoint length_type iff((frame_length == 64) && (error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_38 = {[0:38]};
            ignore_bins length_38_DM_RX = {[0:38]} iff(tx_rx==1);
        }
 
        // Non-padded No Error Untagged
        non_padded_frame_length_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1518 = {1518};
        }
        
        // Non-padded No Error VLAN Tagged
        non_padded_frame_length_vlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1522 = {1522};
        }
        
        // Non-padded No Error SVLAN Tagged
        non_padded_frame_length_svlan_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_65_1517 = {[65:1517]};
            bins length_1526 = {1526};
        }
        
        // discard crc tse
        discard_crc_frame_length_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_100 = {100};
            bins length_1514 = {1514};  //putting 1514 instead of 1518 because loopback feature is enabled for TSE test
        }
        
        // Forward crc tse
        forward_crc_frame_length_untagged_tse_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_100 = {100};
            bins length_1514 = {1514};  //putting 1514 instead of 1518 because loopback feature is enabled for TSE test
        }
        
        // Non-padded No Error Untagged
        non_padded_frame_length_untagged_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_1518 = {1518};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        // Non-padded No Error VLAN Tagged
        non_padded_frame_length_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_1522 = {1522};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1522));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1522));
        }
        
        // Non-padded No Error SVLAN Tagged
        non_padded_frame_length_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_1526 = {1526};
            wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1526));
            wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1526));
        }
        
        // mac_receive_frame_size_untagged
        mac_receive_frame_size_untagged_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_100 = {[65:1517]};
            bins length_1514 = {1518};
        }
        
        // mac_receive_frame_size_vlan
        mac_receive_frame_size_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_100 = {[65:1517]};
            bins length_1514 = {1518};
        }
        
        // mac_receive_frame_size_svlan
        mac_receive_frame_size_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_100 = {[65:1517]};
            bins length_1514 = {1518};
        }
        
        // mac_transmit_frame_size_untagged
        mac_transmit_frame_size_untagged_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == UNTAGGED)) {
            bins length_64 = {64};
            bins length_100 = {[65:1517]};
            bins length_1514 = {1518};
        }
        
        // mac_transmit_frame_size_vlan
        mac_transmit_frame_size_vlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == VLAN)) {
            bins length_64 = {64};
            bins length_100 = {[65:1517]};
            bins length_1514 = {1518};
        }
        
        // mac_transmit_frame_size_svlan
        mac_transmit_frame_size_svlan_cp: coverpoint frame_length iff((error_type == NO_ERROR) && (tag_type == SVLAN)) {
            bins length_64 = {64};
            bins length_100 = {[65:1517]};
            bins length_1514 = {1518};
        }

        
        ipg_tse_cp: coverpoint frame_length {
            bins length_64 = {64};
            bins length_65_127 = {[65:127]};
            bins length_128_255 = {[128:255]};
            bins length_256_511 = {[256:511]};
            bins length_512_1023 = {[512:1023]};
            bins length_1024_1518 = {[1024:1518]};
        }

        /////////////////////////////////////////////////////////////////
        // Max Frame Length
        /////////////////////////////////////////////////////////////////
        // Any Error
        max_frame_length_cp: coverpoint frame_length {
            bins lg_max_frame_len = {[64:max_frame_len - 1]};
            bins eq_max_frame_len = {max_frame_len};
            bins gt_max_frame_len = {[max_frame_len + 1:$]};
        }
        
        /////////////////////////////////////////////////////////////////
        // Payload Length
        /////////////////////////////////////////////////////////////////
        // Any Error
        length_type_cp: coverpoint length_type {
            bins length_padded[] = {[0:45]};
            bins length_46 = {46};
            bins length_gt_46 = {[46:1500]};
        }
        
        // This payload length Bin is specifically to use in non padding test due to in memory statistic cannot handle too short frame
        length_type_special_cp: coverpoint length_type {
            bins length_padded[] = {[24:45]};
            bins length_46 = {46};
            bins length_gt_46 = {[46:1500]};
        }
        
        /////////////////////////////////////////////////////////////////
        // Destination Address
        /////////////////////////////////////////////////////////////////
        // Any Error
        da_type_cp: coverpoint da_type {
            bins unicast            = {UNICAST};
            bins multicast          = {MULTICAST};
            bins broadcast          = {BROADCAST};
            bins unicast_invalid    = {UNICAST_INVALID};
            //bins multicast_pause    = {MULTICAST_PAUSE};
        }
        
        /////////////////////////////////////////////////////////////////
        // Destination Address - Unicast Type
        /////////////////////////////////////////////////////////////////
        // Any Error
        da_ucast_type_cp: coverpoint da_ucast_type iff((da_type == UNICAST) || (da_type == UNICAST_INVALID)) {
            bins ucast_addr     = {UCAST_ADDR} iff(da_type == UNICAST);
            bins supp_addr_0    = {SUPP_ADDR_0};
            bins supp_addr_1    = {SUPP_ADDR_1};
            bins supp_addr_2    = {SUPP_ADDR_2};
            bins supp_addr_3    = {SUPP_ADDR_3};
            bins ucast_invalid  = {UCAST_ADDR} ;
            //Supplementary address not supported in TX direction 
            ignore_bins supp_addr_0_ignore    = {SUPP_ADDR_0}  iff(tx_rx==1);
            ignore_bins supp_addr_1_ignore    = {SUPP_ADDR_1}  iff(tx_rx==1);
            ignore_bins supp_addr_2_ignore    = {SUPP_ADDR_2}  iff(tx_rx==1);
            ignore_bins supp_addr_3_ignore    = {SUPP_ADDR_3}  iff(tx_rx==1);
        }
       
        /* 
        /////////////////////////////////////////////////////////////////
        // Type Frames
        /////////////////////////////////////////////////////////////////
        type_frame_cp: coverpoint length_type iff(frame_type == TYPE_FRAME) {
            bins types = {[0:65535]};
        }
        */
        /////////////////////////////////////////////////////////////////
        //  Control Frames
        /////////////////////////////////////////////////////////////////
        control_fwd_en_type_cp: coverpoint control_type
            iff((frame_type == CONTROL_FRAME) && ((MISC_CONTROL) || (PAUSE_CONTROL))) {
            bins misc_control = {MISC_CONTROL};
            bins pause_control = {PAUSE_CONTROL};
        }
        
        control_fwd_dis_type_cp: coverpoint control_type
            iff((frame_type == CONTROL_FRAME) && ((MISC_CONTROL) || (PAUSE_CONTROL))) {
            bins misc_control = {MISC_CONTROL};
            bins pause_control = {PAUSE_CONTROL};
        }
        /////////////////////////////////////////////////////////////////
        // Misc Control Type
        /////////////////////////////////////////////////////////////////
     // TODO check the misc_control feature
     //   misc_control_type_cp: coverpoint misc_control_type
     //       iff((frame_type == CONTROL_FRAME) &&
     //           (control_type == MISC_CONTROL)
     //           ) {
     //       bins misc_control_types[2] = {0, [2:65535]};
     //       illegal_bins misc_control_type_il = {-1};
     //   }
     //   
        /*
         /////////////////////////////////////////////////////////////////
        // Pause Frame
        /////////////////////////////////////////////////////////////////

        pause_ignore_en_type_cp: coverpoint da_type
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins multicast_pause    = {MULTICAST_PAUSE};
        }
        
        pause_ignore_dis_type_cp: coverpoint da_type
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins multicast_pause    = {MULTICAST_PAUSE};
        }
        
        pause_quanta_cp: coverpoint pause_quanta
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins pause_quanta_0 = {0};
            bins pause_quanta_gt_0 = {[1:65535]};
            illegal_bins pause_quanta_il = {-1};
        }
        
        pause_quanta_trans_cp: coverpoint pause_quanta
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins pause_quanta_ffff_0 = (16'hffff => 0);
            bins pause_quanta_ffff_1_fffe = (16'hffff => [1:16'hfffe]);
            bins pause_quanta_ffff_ffff = (16'hffff => [1:16'hffff]);
        }
        */
        pause_da_type_cp: coverpoint da_type
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins unicast            = {UNICAST};
            bins multicast          = {MULTICAST};
            bins broadcast          = {BROADCAST};
            bins unicast_invalid    = {UNICAST_INVALID};
          //  bins multicast_pause    = {MULTICAST_PAUSE};
        }
        /*
        pause_fwd_en_cp: coverpoint da_type
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins multicast_pause    = {MULTICAST_PAUSE};
        }
        
        pause_fwd_dis_cp: coverpoint da_type
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins multicast_pause    = {MULTICAST_PAUSE};
        }
        */
        pause_da_ucast_type_cp: coverpoint da_ucast_type
            iff((da_type == UNICAST) &&
                (frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins ucast_addr     = {UCAST_ADDR};
            bins supp_addr_0    = {SUPP_ADDR_0};
            bins supp_addr_1    = {SUPP_ADDR_1};
            bins supp_addr_2    = {SUPP_ADDR_2};
            bins supp_addr_3    = {SUPP_ADDR_3};
            //Supplementary address not supported in TX direction 
            ignore_bins supp_addr_0_ignore    = {SUPP_ADDR_0}  iff(tx_rx==1);
            ignore_bins supp_addr_1_ignore    = {SUPP_ADDR_1}  iff(tx_rx==1);
            ignore_bins supp_addr_2_ignore    = {SUPP_ADDR_2}  iff(tx_rx==1);
            ignore_bins supp_addr_3_ignore    = {SUPP_ADDR_3}  iff(tx_rx==1);
        }
        
        pause_vlan_tagged_cp: coverpoint da_type
            iff((tag_type == VLAN) &&
                (frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins unicast            = {UNICAST};
            //bins multicast_pause    = {MULTICAST_PAUSE};
        }
        
        pause_error_crc_cp: coverpoint da_type
            iff((error_type & ERROR_CRC) &&
                (frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins unicast            = {UNICAST} ;
            //CRC not supported in TX direction
            ignore_bins unicast_DM_TX            = {UNICAST}  iff(tx_rx==1);
            //bins multicast_pause    = {MULTICAST_PAUSE};
        }
        
        pause_error_oversized_cp: coverpoint frame_length
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins length_65 = {[65:68]};
            //Enable it afer SNPS HSD:
            //bins length_1518 = {1518};
            //bins length_gt_1518 = {[1519:$]};
            //wildcard bins length_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 65) && (frame_length < 1518));
            //wildcard bins length_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 65) && (frame_length < 1518));
        }
        
        pause_error_undersized_cp: coverpoint frame_length
            iff((frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            bins runt = {[22:64]};
        }
        
        /////////////////////////////////////////////////////////////////
        // Error Frame
        /////////////////////////////////////////////////////////////////
        error_type_cp: coverpoint error_type {
            bins no_error = {NO_ERROR};
            bins crc_error = {ERROR_CRC};
            bins undersized_error = {ERROR_UNDERSIZED};
            bins oversized_error = {ERROR_OVERSIZED};
            bins payload_length_error = {ERROR_PAYLOAD_LENGTH};
            //CRC not supported in TX direction
            ignore_bins crc_error_ignore = {ERROR_CRC} iff(tx_rx ==1);
        }
        
        
        /////////////////////////////////////////////////////////////////
        // No Error
        /////////////////////////////////////////////////////////////////
        //////////////////////////////////
        // Data Frame
        //////////////////////////////////
        //////////////////////
        // da_type
        //////////////////////
        error_no_data_da_type_cp: coverpoint da_type
            iff((error_type == NO_ERROR) &&
                (frame_type == DATA_FRAME)
                ) {
            
            bins da_type[] = {  UNICAST,
                                MULTICAST,
                                BROADCAST,
                                UNICAST_INVALID
                                };
        }
        
        // Untagged - Non-padded
        error_no_data_unicast_untagged_cp: coverpoint frame_length
            iff((error_type == NO_ERROR) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == UNTAGGED)
                ) {
            
            bins normal_64 = {64} iff(payload_length == 46 - tag_type * 4);
            bins normal_1518 = {1518};
            wildcard bins normal_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }

        
        // VLAN Tagged - Non-padded
        error_no_data_unicast_vlan_cp: coverpoint frame_length
            iff((error_type == NO_ERROR) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == VLAN)
                ) {
            
            bins normal_64 = {64} iff(payload_length == 46 - tag_type * 4);
            bins normal_1518 = {1518};
            wildcard bins normal_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        // SVLAN Tagged - Padded
        error_no_data_unicast_svlan_padded_cp: coverpoint payload_length
            iff((error_type == NO_ERROR) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == SVLAN)
                ) {
            
            bins padded[38] = {[0:47]} iff(frame_length == 64);
            //rx side its not passoble to hit in DM 
            ignore_bins padded_DM[38] = {[0:47]} iff(tx_rx == 0);
        }
        
        // SVLAN Tagged - Non-padded
        error_no_data_unicast_svlan_cp: coverpoint frame_length
            iff((error_type == NO_ERROR) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == SVLAN)
                ) {
            
            bins normal_64 = {64} iff(payload_length == 46 - tag_type * 4);
            bins normal_1518 = {1518};
            wildcard bins normal_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
        }
        
        //////////////////////////////////
        // Control Frame
        //////////////////////////////////
        //////////////////////
        // da_type
        //////////////////////
        error_no_control_da_type_cp: coverpoint da_type
            iff((error_type == NO_ERROR) &&
                (frame_type == CONTROL_FRAME) &&
                (control_type != PAUSE_CONTROL)
                ) {
            
            bins da_type[] = {  UNICAST,
                                MULTICAST,
                                BROADCAST,
                                UNICAST_INVALID
                                };
        }
        
        //////////////////////////////////
        // Pause Frame
        //////////////////////////////////
        //////////////////////
        // da_type
        //////////////////////
        error_no_pause_da_type_cp: coverpoint da_type
            iff((error_type == NO_ERROR) &&
                (frame_type == CONTROL_FRAME) &&
                (control_type == PAUSE_CONTROL)
                ) {
            
            bins da_type[] = {  UNICAST,
                                MULTICAST,
                                BROADCAST,
                                UNICAST_INVALID
                                };
        }
        
        
        
        
        
        /////////////////////////////////////////////////////////////////
        // CRC Error
        /////////////////////////////////////////////////////////////////
        //////////////////////////////////
        // Data Frame
        //////////////////////////////////
        //////////////////////
        // da_type
        //////////////////////
        error_crc_data_da_type_cp: coverpoint da_type
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME)
                ) {
            
            bins da_type[] = {  UNICAST,
                                MULTICAST,
                                BROADCAST,
                                UNICAST_INVALID
                                } ;
            ignore_bins da_type_DM_TX[] = {  UNICAST,
                                             MULTICAST,
                                             BROADCAST,
                                             UNICAST_INVALID
                                             } iff (tx_rx==1);
        }             
        
        //////////////////////
        // length
        //////////////////////
        // Untagged - Padded
        error_crc_data_unicast_untagged_padded_cp: coverpoint payload_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == UNTAGGED)
                ) {
            
            bins padded[46] = {[1:46]} iff(frame_length == 64);
            //rx side its not passoble to hit in DM 
            ignore_bins padded_DM[46] = {[1:46]} iff( tx_rx==0 || tx_rx==1);
        }
        
        // Untagged - Non-padded
        error_crc_data_unicast_untagged_cp: coverpoint frame_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == UNTAGGED)
                ) {
            
            bins normal_64 = {64} iff(payload_length == 46 - tag_type * 4);
            bins normal_1518 = {1518};
            ignore_bins normal_64_DM_TX = {64} iff(tx_rx==1);
            ignore_bins normal_1518_DM_TX = {1518} iff(tx_rx==1);
            ignore_bins length_65_1517_DM_TX = {[65:1517]} iff (tx_rx==1);
            wildcard bins normal_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
            ignore_bins normal_modulo_8_0_DM_TX_PATH = {32'b00000000_00000000_00000???_?????000} iff(tx_rx==1);
            ignore_bins normal_modulo_8_1_DM_TX_PATH = {32'b00000000_00000000_00000???_?????001} iff(tx_rx==1);
            ignore_bins normal_modulo_8_2_DM_TX_PATH = {32'b00000000_00000000_00000???_?????010} iff(tx_rx==1);
            ignore_bins normal_modulo_8_3_DM_TX_PATH = {32'b00000000_00000000_00000???_?????011} iff(tx_rx==1);
            ignore_bins normal_modulo_8_4_DM_TX_PATH = {32'b00000000_00000000_00000???_?????100} iff(tx_rx==1);
            ignore_bins normal_modulo_8_5_DM_TX_PATH = {32'b00000000_00000000_00000???_?????101} iff(tx_rx==1);
            ignore_bins normal_modulo_8_6_DM_TX_PATH = {32'b00000000_00000000_00000???_?????110} iff(tx_rx==1);
            ignore_bins normal_modulo_8_7_DM_TX_PATH = {32'b00000000_00000000_00000???_?????111} iff(tx_rx==1);
        }
        
        // Untagged - mac_rx_disc_err_en_crcerr
        mac_rx_disc_err_en_crcerr_cp: coverpoint frame_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (tag_type == UNTAGGED)
                ) {
            bins length_64 = {64} ;
            bins length_65_1517 = {[65:1517]} ;
            bins length_1518 = {1518} ;
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1);
            ignore_bins length_65_1517_DM_TX = {[65:1517]}  iff (tx_rx==1);
            ignore_bins length_1518_DM_TX = {1518}  iff (tx_rx==1);
        }
        
        // Untagged - mac_rx_disc_err_dis_crcerr
        mac_rx_disc_err_dis_crcerr_cp: coverpoint frame_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (tag_type == UNTAGGED)
                ) {
            bins length_64 = {64} ;
            bins length_65_1517 = {[65:1517]} ;
            bins length_1518 = {1518}  ;
            ignore_bins length_64_DM_TX = {64}  iff (tx_rx==1);
            ignore_bins length_65_1517_DM_TX = {[65:1517]}  iff (tx_rx==1);
            ignore_bins length_1518_DM_TX = {1518}  iff (tx_rx==1);
        }
        
        // VLAN Tagged - Padded
        error_crc_data_unicast_vlan_padded_cp: coverpoint payload_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == VLAN)
                ) {
            
            bins padded[42] = {[0:41]} iff(frame_length == 64);
            //rx side its not passoble to hit in DM 
            ignore_bins padded_DM[42] = {[0:41]} iff(tx_rx==0 ||tx_rx==1 );
        }
        
        // VLAN Tagged - Non-padded
        error_crc_data_unicast_vlan_cp: coverpoint frame_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == VLAN)
                ) {
            
            bins normal_64 = {64} iff(payload_length == 46 - tag_type * 4)  ;
            bins normal_1518 = {1518} with (item && tx_rx==0);
            ignore_bins normal_64_DM_TX = {64} iff(tx_rx==1 );
            ignore_bins normal_1518_DM_TX = {1518} iff(tx_rx==1 );
            ignore_bins length_65_1517_DM_TX = {[65:1517]} iff (tx_rx==1);
            wildcard bins normal_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
            ignore_bins normal_modulo_8_0_DM_TX_PATH = {32'b00000000_00000000_00000???_?????000} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_1_DM_TX_PATH = {32'b00000000_00000000_00000???_?????001} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_2_DM_TX_PATH = {32'b00000000_00000000_00000???_?????010} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_3_DM_TX_PATH = {32'b00000000_00000000_00000???_?????011} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_4_DM_TX_PATH = {32'b00000000_00000000_00000???_?????100} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_5_DM_TX_PATH = {32'b00000000_00000000_00000???_?????101} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_6_DM_TX_PATH = {32'b00000000_00000000_00000???_?????110} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_7_DM_TX_PATH = {32'b00000000_00000000_00000???_?????111} iff(tx_rx==1 );
        }
        
        // SVLAN Tagged - Padded
        error_crc_data_unicast_svlan_padded_cp: coverpoint payload_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == SVLAN)
                ) {
            
            bins padded[38] = {[0:47]} iff(frame_length == 64) ;
            //rx side its not passoble to hit in DM 
            ignore_bins padded_DM[38] = {[0:47]} iff(tx_rx==0 ||tx_rx==1 ) ;
        }
        
        // SVLAN Tagged - Non-padded
        error_crc_data_unicast_svlan_cp: coverpoint frame_length
            iff((error_type == ERROR_CRC) &&
                (frame_type == DATA_FRAME) &&
                (da_type == UNICAST) &&
                (tag_type == SVLAN)
                ) {
            
            bins normal_64 = {64} iff(payload_length == 46 - tag_type * 4) ;
            bins normal_1518 = {1518}  ;
            ignore_bins normal_64_DM_TX= {64} iff(tx_rx==1 );
            ignore_bins normal_1518_DM_TX = {1518} iff(tx_rx==1 ) ;
            ignore_bins length_65_1517_DM_TX = {[65:1517]} iff (tx_rx==1);
            wildcard bins normal_modulo_8_0 = {32'b00000000_00000000_00000???_?????000} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_1 = {32'b00000000_00000000_00000???_?????001} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_2 = {32'b00000000_00000000_00000???_?????010} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_3 = {32'b00000000_00000000_00000???_?????011} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_4 = {32'b00000000_00000000_00000???_?????100} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_5 = {32'b00000000_00000000_00000???_?????101} iff((frame_length > 64) && (frame_length < 1518));
            wildcard bins normal_modulo_8_6 = {32'b00000000_00000000_00000???_?????110} iff((frame_length > 64) && (frame_length < 1518)); 
            wildcard bins normal_modulo_8_7 = {32'b00000000_00000000_00000???_?????111} iff((frame_length > 64) && (frame_length < 1518));
            ignore_bins normal_modulo_8_0_DM_TX_Path = {32'b00000000_00000000_00000???_?????000} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_1_DM_TX_Path = {32'b00000000_00000000_00000???_?????001} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_2_DM_TX_Path = {32'b00000000_00000000_00000???_?????010} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_3_DM_TX_Path = {32'b00000000_00000000_00000???_?????011} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_4_DM_TX_Path = {32'b00000000_00000000_00000???_?????100} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_5_DM_TX_Path = {32'b00000000_00000000_00000???_?????101} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_6_DM_TX_Path = {32'b00000000_00000000_00000???_?????110} iff(tx_rx==1 );
            ignore_bins normal_modulo_8_7_DM_TX_Path = {32'b00000000_00000000_00000???_?????111} iff(tx_rx==1 );
        }
        
        //////////////////////////////////
        // Control Frame
        //////////////////////////////////
        //////////////////////
        // da_type
        //////////////////////
        error_crc_control_da_type_cp: coverpoint da_type iff((error_type == ERROR_CRC) && (frame_type == CONTROL_FRAME) && (control_type != PAUSE_CONTROL)) {
            
            bins da_type[] = {  UNICAST,
                                MULTICAST,
                                BROADCAST,
                                UNICAST_INVALID
                                } ;

           ignore_bins da_type_DM_TX[] = {  UNICAST,
                                            MULTICAST,
                                            BROADCAST,
                                            UNICAST_INVALID
                                         } iff ( tx_rx==1);
        }
        
        //////////////////////////////////
        // Pause Frame
        //////////////////////////////////
        //////////////////////
        // da_type
        //////////////////////
        error_crc_pause_da_type_cp: coverpoint da_type iff((error_type == ERROR_CRC) && (frame_type == CONTROL_FRAME) && (control_type == PAUSE_CONTROL)) {
            
            bins da_type[] = {  UNICAST,
                                MULTICAST,
                                BROADCAST,
                                UNICAST_INVALID
                                };
            ignore_bins da_type_DM_TX[] = {  UNICAST,
                                             MULTICAST,
                                             BROADCAST,
                                             UNICAST_INVALID
                                             }iff ( tx_rx==1);
        }

        // ==============================================================================================
        // Unidirectional FCPs
        // ==============================================================================================
        //`ifdef ENABLE_UNIDIRECTIONAL
            csr_unidir_en_cp: coverpoint csr_tx_unidir_en{
                bins tx_unidir_en_eq_1 = {1};
                bins tx_unidir_en_eq_0 = {0};
                ignore_bins tx_unidir_en_eq_not_DM  = {1};
            }

            csr_unidir_dis_cp: coverpoint csr_tx_unidir_en{
                bins tx_unidir_en_eq_1 = {1};
                bins tx_unidir_en_eq_0 = {0};
                ignore_bins tx_unidir_not_DM = {1};
            }

            csr_unidir_remote_fault_dis_cp: coverpoint csr_unidir_remote_fault_dis{
                bins tx_csr_unidir_remote_fault_dis_1 = {1};
                bins tx_csr_unidir_remote_fault_dis_0 = {0};
                ignore_bins undir_feature_dis_1 = {1};
            }

            csr_crc_insrt_cp: coverpoint csr_tx_crc_insrt_en{
                bins crc_insrt_dis_eq_0 = {0};
                bins crc_insrt_en_eq_1 = {1};
                ignore_bins crc_dis_0 = {0};
            }

            csr_enable_preamble_passthrough_cp_tx: coverpoint csr_enable_preamble_passthrough_tx{
                bins csr_enable_preamble_passthrough_eq_tx_0 = {0};
                bins csr_enable_preamble_passthrough_eq_tx_1 = {1};
                ignore_bins ignr_csr_enable_preamble_passthrough_eq_tx_1 = {1};
            }

             csr_enable_preamble_passthrough_cp_rx: coverpoint csr_enable_preamble_passthrough_rx{ 
                bins csr_enable_preamble_passthrough_eq_0 = {0};
                bins csr_enable_preamble_passthrough_eq_1 = {1};
                ignore_bins DM_csr_enable_preamble_passthrough_eq_rx = {1};
            }
//DOUBT
           // DM not supported
            time_stamping_1step_cp: coverpoint timestamping_1step{
                bins timestamping_1step_eq_0 = {0};
                bins timestamping_1step_eq_1 = {1};
                ignore_bins timestamp_not_supported = {0,1};
            }
//DOUBT- Conection thru spy_if-Done
            unidir_link_fault_status_xgmii_rx_data_cp: coverpoint sig_link_fault_status_xgmii_rx_data {
                bins no_link_fault = {2'b00};
                bins local_fault  = {2'b01};
                bins remote_fault = {2'b10};
				//AVST RX will not receive any packet when VIP sending remote faults, this cg sampled when AVST RX receives the packet
				ignore_bins remote_fault_2 = {2'b10} iff(tx_rx==0);
            }

            unidir_no_link_fault_cp: coverpoint sig_link_fault_status_xgmii_rx_data {
                bins no_link_fault = {2'b00};
            }

//            `ifdef ALTERA_ETH_10G_MAC
//DOUBT- Can this be replaced with avalon_st_txstatus_err
                
                unidir_avalon_st_txstatus_error_010_0000_cp: coverpoint sig_avalon_st_txstatus_error {
                    wildcard bins unidir_avalon_st_txstatus_error_010_0000 = {7'b?1?_????};
                }

                unidir_avalon_st_tx_error_assert_cp: coverpoint sig_avalon_st_tx_error{
                    bins unidir_avalon_st_tx_error_frame_eq_1 = {1'b1};
                }

                unidir_avalon_st_txstatus_valid_cp: coverpoint sig_avalon_st_txstatus_valid{
                    bins unidir_avalon_st_txstatus_valid_frame = {1'b1};
                }

                // === Unidir - Enable ===
                //cross with crc
                unidir_en_x_unidir_remote_fault_dis_x_crc_en_cp: cross csr_unidir_en_cp, csr_unidir_remote_fault_dis_cp, csr_crc_insrt_cp;
                unidir_en_x_unidir_remote_fault_dis_x_crc_en_b2b_cp: cross unidir_en_x_unidir_remote_fault_dis_x_crc_en_cp, bic_b2b_cp;
                unidir_en_x_unidir_remote_fault_dis_x_crc_en_non_b2b_cp: cross unidir_en_x_unidir_remote_fault_dis_x_crc_en_cp, bic_non_b2b_cp;

                //cross with crc x preamble passthrough 
                unidir_en_x_unidir_remote_fault_dis_x_crc_en_x_preamble_passthrough_cp: cross unidir_en_x_unidir_remote_fault_dis_x_crc_en_cp, csr_enable_preamble_passthrough_cp_tx;
                
               
                //cross with crc x time stamping 1 step/2 step 
                unidir_en_x_unidir_remote_fault_dis_x_crc_en_x_time_stamping_1step_cp: cross unidir_en_x_unidir_remote_fault_dis_x_crc_en_cp, time_stamping_1step_cp;

                //cross with crc x preamble passthrough x time stamping 1 step/2 step 
                unidir_en_x_unidir_remote_fault_dis_x_crc_en_x_preamble_passthrough_x_time_stamping_1step_cp: cross unidir_en_x_unidir_remote_fault_dis_x_crc_en_x_preamble_passthrough_cp, time_stamping_1step_cp;

                // === Unidir - Disable ===
                unidir_dis_x_unidir_remote_fault_dis_x_crc_en_cp: cross csr_unidir_dis_cp, csr_unidir_remote_fault_dis_cp, csr_crc_insrt_cp;
                unidir_dis_x_unidir_remote_fault_dis_x_crc_en_b2b_cp: cross unidir_dis_x_unidir_remote_fault_dis_x_crc_en_cp, bic_b2b_cp;
                unidir_dis_x_unidir_remote_fault_dis_x_crc_en_non_b2b_cp: cross unidir_dis_x_unidir_remote_fault_dis_x_crc_en_cp, bic_non_b2b_cp;

                //cross with crc x preamble passthrough 
                unidir_dis_x_unidir_remote_fault_dis_x_crc_en_x_preamble_passthrough_cp: cross unidir_dis_x_unidir_remote_fault_dis_x_crc_en_cp, csr_enable_preamble_passthrough_cp_tx;
               
                //cross with crc x time stamping 1 step/2 step 
                unidir_dis_x_unidir_remote_fault_dis_x_crc_en_x_time_stamping_1step_cp: cross unidir_dis_x_unidir_remote_fault_dis_x_crc_en_cp, time_stamping_1step_cp;

                //cross with crc x preamble passthrough x time stamping 1 step/2 step 
                unidir_dis_x_unidir_remote_fault_dis_x_crc_en_x_preamble_passthrough_x_time_stamping_1step_cp: cross unidir_dis_x_unidir_remote_fault_dis_x_crc_en_x_preamble_passthrough_cp, time_stamping_1step_cp;
//            `endif
        //`endif
        // ==============================================================================================

               `ifdef ENABLE_10GBASER_REG_MODE
                 bic_baser_reg_mode_xgmii_tx_valid_cp: coverpoint sig_xgmii_tx_valid {
                 bins valid_0 = {1'b0};
                 bins valid_1 = {1'b1};
                 }
     
                 bic_baser_reg_mode_xgmii_rx_valid_cp: coverpoint sig_xgmii_rx_valid {
                 bins valid_0 = {1'b0};
                 bins valid_1 = {1'b1};
                 }
               `endif
     
     
             endgroup

           // functions
           function new(string name, uvm_component parent);
              super.new(name,parent);        
               inst_name = name;
               // Update from command line if being passed down
               $value$plusargs("DUT_NAME=%s", DUT_NAME);
               $value$plusargs("TEST_NAME=%s", TEST_NAME);
               eth_frame = new("eth_frame", this); 
               cg_mac_frame = new();
       	       tx_status_error_cg       = new();
               rx_status_error_cg       = new();
               
                if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
                    `uvm_fatal("spy_interface", "failed to get spy_interface intf");
                end
           endfunction


            virtual function void write_eth_frame(eth_packet eth_frame);
             sample_frame(eth_frame);
            endfunction

            task run_phase(uvm_phase phase);
             begin
              fork
                begin
                 always_block();
                end
                begin
					 `uvm_info(get_name(), $sformatf("tx_rx value is %0d",tx_rx),UVM_MEDIUM)
                  if(tx_rx == 1) begin
                  forever begin
                  @(spy_if.sig_avalon_st_tx_error,spy_if.sig_avalon_st_txstatus_valid,spy_if.sig_avalon_st_txstatus_error);
                                        tx_status_error_cg.sample(); 
                    end
                  end
                end
                begin
                    if(tx_rx == 0) begin
                    forever begin
                  @(spy_if.sig_avalon_st_rx_error,spy_if.sig_avalon_st_rxstatus_valid,spy_if.sig_avalon_st_rxstatus_error);
                    rx_status_error_cg.sample(); 
                      end   
                   end
                end 
              join_none

             end
            endtask: run_phase


              function void sample_frame(eth_packet mac_frame);
         $display("packet recieved at mgbaset coverage =%0s  ",mac_frame.sprint()); 
           	this.frame_length = mac_frame.packed_bytes.size();
                  this.payload_length = mac_frame.payload.size();
                  this.length_type = mac_frame.eth_type_or_length;
                  /*this.frame_type = mac_frame.frame_type;
                  this.control_type = mac_frame.control_type;
                  this.da_type = mac_frame.da_type;
                  this.da_ucast_type = mac_frame.da_ucast_type;
                  
                  this.tag_type = mac_frame.tag_type;
                  
                  // Register that will have the ipg value (ipg_seq)
                  this.ipg = mac_frame.ipg;
                  
                  this.error_type = mac_frame.error_type;
                  
                  // `ifdef ALTERA_BIC_QSE_MAC
                  	// `ifndef ETH_10G_MAC_1G10G_PHY_DE
                  	// `ifndef ETH_10G_MAC_NF_PHY_10GBASER_REG_MODE_DE
                  	// `ifndef ETH_MGE_MAC_PHY_DE
                  	// `ifndef ETH_MGBASET_MAC_PHY_DE
                  
                  // CSR
                  // tx csr

		this.csr_tx_pausefrm_en = spy_if.tx_pausefrm_en;
		this.csr_tx_pausefrm_policy = spy_if.tx_pausefrm_policy;
		this.csr_tx_pad_insrt_en = spy_if.tx_pad_insrt_en;
		this.csr_tx_pausefrm_xonxoff = spy_if.tx_pausefrm_xonxoff[1:0];
		this.csr_tx_crc_insrt_en = spy_if.tx_crc_insrt_en;
		this.csr_pfc_priority_num = spy_if.pfc_priority_num;
		//this.csr_tx_preamble_passthru = spy_if.csr_tx_preamble_passthru;
		this.csr_enable_preamble_passthrough = spy_if.enable_preamble_passthrough;
		this.csr_tx_sa_override_en = spy_if.tx_sa_override_en;
		this.csr_tx_pipg_10g_dic = spy_if.tx_pipg_10g_dic;
		this.csr_status_tx_datafrm_tsfr_en_sts = spy_if.status_tx_datafrm_tsfr_en_sts;
		//`ifdef REGISTER_BASED_STATISTICS
		//this.csr_tx_stats_clr = spy_if.STAT_CSR_CLK.tx_stat_reg.clr;
		//`endif
		this.csr_tx_xoff_hqt0 = spy_if.tx_xoff_hqt0[15:0];
		this.csr_tx_xoff_hqt1 = spy_if.tx_xoff_hqt1[15:0];		
		this.csr_tx_xoff_hqt2 = spy_if.tx_xoff_hqt2[15:0];
		this.csr_tx_xoff_hqt3 = spy_if.tx_xoff_hqt3[15:0];
		this.csr_tx_xoff_hqt4 = spy_if.tx_xoff_hqt4[15:0];		
		this.csr_tx_xoff_hqt5 = spy_if.tx_xoff_hqt5[15:0];
		this.csr_tx_xoff_hqt6 = spy_if.tx_xoff_hqt6[15:0];
		this.csr_tx_xoff_hqt7 = spy_if.tx_xoff_hqt7[15:0];
        
		//rx csr
		//ETH_COV_DUT_CSR = altera_swip_eth_system_tb_top.U_TOP_DUT_WRAPPER.U_DUT_WRAPPER.U_DUT.eth_10g_mac_inst.alt_em10g32unit_inst.creg_top_inst
		this.csr_rx_frm_ctl = spy_if.rx_frm_ctl[31:0];
		this.csr_rx_crcpad_ctl = spy_if.rx_crcpad_ctl[31:0];
		this.csr_rx_preamb_passthru_en = spy_if.rx_preamb_passthru_en;
		this.csr_rx_crc_chk = spy_if.csr_rx_crc_chk;
		this.csr_tx_pfcfrm_pqt0 = spy_if.tx_pfcfrm_pqt0[15:0];
		this.csr_tx_pfcfrm_en0 = spy_if.tx_pfcfrm_en0;
		//`ifdef REGISTER_BASED_STATISTICS
		//this.csr_rx_stats_clr = spy_if.STAT_CSR_CLK.rx_stat_reg.clr;
		//`endif


		this.csr_rx_tsfr_sts = spy_if.csr_rx_tsfr_sts;
		this.csr_rx_tsfr_en_n = spy_if.csr_rx_tsfr_en_n;
		this.csr_tx_tsfr_en_n = spy_if.csr_tx_tsfr_en_n;
		this.csr_rx_pfc_ignore_pausefrm_1 = spy_if.csr_rx_pfc_ignore_pausefrm_1;
		this.csr_rx_pfc_fwd = spy_if.csr_rx_pfc_fwd;
                */        
                // SIGNALS
                //tx signal
		this.sig_speed_sel_en = spy_if.sig_speed_sel[2:0];
		
                this.sig_avalon_st_pause_data = spy_if.sig_avalon_st_pause_data[1:0];

		this.sig_avalon_st_tx_pause_length_data = spy_if.sig_avalon_st_tx_pause_length_data[15:0];
		this.sig_avalon_st_tx_pause_length_valid = spy_if.sig_avalon_st_tx_pause_length_valid;
		this.sig_xgmii_tx =spy_if.sig_xgmii_tx[71:0];
		this.sig_gmii_tx_en = spy_if.sig_gmii_tx_en;
		this.sig_gmii16b_tx_en =spy_if.sig_gmii16b_tx_en[0] | spy_if.sig_gmii16b_tx_en[1];
		this.sig_avalon_st_tx_pfc_status_data =spy_if.sig_avalon_st_tx_pfc_status_data[15:0];
		this.sig_avalon_st_tx_pfc_status_valid =spy_if.sig_avalon_st_tx_pfc_status_valid;
		this.sig_avalon_st_tx_pfc_gen_data =spy_if.sig_avalon_st_tx_pfc_gen_data[15:0];
		this.sig_avalon_st_txstatus_error = sig_avalon_st_txstatus_error_reg;
		this.sig_avalon_st_txstatus_valid = sig_avalon_st_txstatus_valid_reg;
		this.sig_avalon_st_txstatus_data =spy_if.sig_avalon_st_txstatus_data[39:0];
		this.sig_avalon_st_tx_error = sig_avalon_st_tx_error_reg;
		this.sig_avalon_st_tx_valid =spy_if.sig_avalon_st_tx_valid;

		this.sig_link_fault_status_xgmii_tx_data = sig_link_fault_status_xgmii_tx_data_reg;
        
		//rx signals
		this.sig_avalon_st_rx_pause_length_data =spy_if.sig_avalon_st_rx_pause_length_data[15:0];
		this.sig_avalon_st_rx_pause_length_valid =spy_if.sig_avalon_st_rx_pause_length_valid;
		this.sig_avalon_st_rx_error = sig_avalon_st_rx_error_reg;
		this.sig_avalon_st_rx_valid = sig_avalon_st_rx_valid_reg;
		this.sig_avalon_st_rx_endofpacket = sig_avalon_st_rx_endofpacket_reg;
		this.sig_avalon_st_rxstatus_error = sig_avalon_st_rxstatus_error_reg;
		this.sig_avalon_st_rxstatus_valid = sig_avalon_st_rxstatus_valid_reg;
		this.sig_gmii_rx_err = sig_gmii_rx_err_reg;
		this.sig_mii_rx_err = spy_if.sig_mii_rx_err;
		this.sig_avalon_st_rx_ready = spy_if.sig_avalon_st_rx_ready;
		this.sig_link_fault_status_xgmii_rx_data =spy_if.sig_link_fault_status_xgmii_rx_data[1:0];
		this.sig_avalon_st_rx_pfc_pause_data = spy_if.sig_avalon_st_rx_pfc_pause_data[7:0];

		//`ifdef ENABLE_10GBASER_REG_MODE //MAC ONLY
		this.sig_xgmii_tx_valid = spy_if.xgmii_tx_valid;
		this.sig_xgmii_rx_valid = spy_if.xgmii_rx_valid;
		//`endif
            

             /* 
               if( (this.frame_type == CONTROL_FRAME) &&
                   (this.control_type == MISC_CONTROL)
                   ) begin
                   this.misc_control_type = mac_frame.frame_data[14] << 8 | mac_frame.frame_data[15];
               end
               else begin
                   this.misc_control_type = -1;
               end
               
               // Pause Quanta
               if( (this.frame_type == CONTROL_FRAME) &&
                   (this.control_type == PAUSE_CONTROL)
                   ) begin
                   this.pause_quanta = mac_frame.frame_data[16] << 8 | mac_frame.frame_data[17];
               end
               else begin
                   this.pause_quanta = -1;
               end
                */
                //*******************************************************************
              $display("mac_frame.is_svlan_f=%0d, mac_frame.is_vlan_f=%d",mac_frame.is_svlan_f,mac_frame.is_vlan_f);
                 if(mac_frame.is_svlan_f == 1) //Add vlan disable check
                 this.tag_type = SVLAN;                 
                 else if(mac_frame.is_vlan_f == 1)
                 this.tag_type = VLAN;
                 else 
                 this.tag_type = UNTAGGED;
                 if(mac_frame.frame_type == ETH_DATA_FRAME)
                 this.tag_type = UNTAGGED;
      
              
                 
                 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.eth_mac_ucast_address_0_0 = regs.get();
                 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.eth_mac_ucast_address_0_1 = regs.get();
                 this.eth_mac_ucast_address = {eth_mac_ucast_address_0_1,eth_mac_ucast_address_0_0};

                 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr0_0_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.eth_mac_supp_address_0_0  = regs.get();
                 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr0_1_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.eth_mac_supp_address_0_1  = regs.get();
                 this.eth_mac_supp_address_0 = {eth_mac_supp_address_0_1,eth_mac_supp_address_0_0};

                 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.ETH_MAC_RX_FRAME_CTL = regs.get();          
                 this.ETH_MAC_RX_SUPP_ENA_0 = ETH_MAC_RX_FRAME_CTL[16];
                 this.ETH_MAC_RX_SUPP_ENA_1 = ETH_MAC_RX_FRAME_CTL[17];
                 this.ETH_MAC_RX_SUPP_ENA_2 = ETH_MAC_RX_FRAME_CTL[18];
                 this.ETH_MAC_RX_SUPP_ENA_3 = ETH_MAC_RX_FRAME_CTL[19];
                 this.en_all_ucast = ETH_MAC_RX_FRAME_CTL[0];
                 this.en_all_mcast =  ETH_MAC_RX_FRAME_CTL[1];


                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr1_0_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.eth_mac_supp_address_1_0 = regs.get();
                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr1_1_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.eth_mac_supp_address_1_1 = regs.get();
                this.eth_mac_supp_address_1 = {eth_mac_supp_address_1_1,eth_mac_supp_address_1_0};
 
                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr2_0_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.eth_mac_supp_address_2_0 = regs.get();
                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr2_1_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.eth_mac_supp_address_2_1 = regs.get();
                this.eth_mac_supp_address_2 = {eth_mac_supp_address_2_1,eth_mac_supp_address_2_0};

                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr3_0_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.eth_mac_supp_address_3_0 = regs.get();
                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_spaddr3_1_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.eth_mac_supp_address_3_1 = regs.get();
                this.eth_mac_supp_address_3 = {eth_mac_supp_address_3_1,eth_mac_supp_address_3_0};


                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_unidir_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.tx_unidir_reg_val = regs.get();
                this.csr_tx_unidir_en = this.tx_unidir_reg_val[0]; 
                this.csr_unidir_remote_fault_dis = this.tx_unidir_reg_val[1];
                
                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.ipg_reg = regs.get();
                this.ipg = this.ipg_reg[0]; 

                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_ipg_10M_100M_1G_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.ipg_reg = regs.get();
                this.ipg_10m_100m_1G = this.ipg_reg[7:0];



                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.tx_crc_control_reg = regs.get();   
                this.csr_tx_crc_insrt_en = this.tx_crc_control_reg[1];  
         
                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.tx_preamble_control_reg = regs.get();
                this.csr_enable_preamble_passthrough_tx =  this.tx_preamble_control_reg[0];

                regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                this.rx_custom_preamble_control_reg = regs.get();
                this.csr_enable_preamble_passthrough_rx =  this.rx_custom_preamble_control_reg[0];
              
               // read MAX_frame size
			   if(tx_rx == 1) begin
                 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.max_frame_len = regs.get();
			   end else begin
				 regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed));
                 this.max_frame_len = regs.get();
			   end

               if(mac_frame.dest_address == this.eth_mac_ucast_address) begin
                  this.da_type = UNICAST;
                  this.da_ucast_type = UCAST_ADDR;
               end
               else if(mac_frame.dest_address ==  this.eth_mac_supp_address_0) begin
                   if( this.ETH_MAC_RX_SUPP_ENA_0) begin
                       this.da_type = UNICAST;
                     end
                    else begin
                      this.da_type = UNICAST_INVALID;
                     end
                    this.da_ucast_type = SUPP_ADDR_0;
                   end
               else if(mac_frame.dest_address == this.eth_mac_supp_address_1)begin
                  if( this.ETH_MAC_RX_SUPP_ENA_1) begin
                         this.da_type = UNICAST;
                      end
                    else begin
                        this.da_type = UNICAST_INVALID;
                     end
                     this.da_ucast_type = SUPP_ADDR_1;
                   end
                else if(mac_frame.dest_address ==  this.eth_mac_supp_address_2) begin
                   if( this.ETH_MAC_RX_SUPP_ENA_2) begin
                       this.da_type = UNICAST;
                     end
                    else begin
                      this.da_type = UNICAST_INVALID;
                     end
                    this.da_ucast_type = SUPP_ADDR_2;
                   end
               else if(mac_frame.dest_address == this.eth_mac_supp_address_3)begin
                  if( this.ETH_MAC_RX_SUPP_ENA_3) begin
                         this.da_type = UNICAST;
                      end
                    else begin
                        this.da_type = UNICAST_INVALID;
                     end
                     this.da_ucast_type = SUPP_ADDR_3;
                   end
               else if (mac_frame.dest_address == 48'hFFFFFFFFFFFF) begin  
                    this.da_type = BROADCAST;
                   end
                else  if(((mac_frame.packed_bytes.size()-8) >=14) && (mac_frame.dest_address[40] == 'h1)) begin
                     this.da_type = MULTICAST;
                    end
                else begin
                  if(this.en_all_ucast) begin
                     this.da_type = UNICAST;
                     end
                 else begin
                     this.da_type = UNICAST_INVALID;
                     end
                 end


     
              if(mac_frame.eth_type_or_length == 'h8808)begin
                  this.frame_type = CONTROL_FRAME;
                  if(mac_frame.payload[0] == 0 && mac_frame.payload[1] == 1) begin
                     this.control_type = PAUSE_CONTROL;
                   end
                   else if(mac_frame.payload[0] == 1 && mac_frame.payload[1] == 1)begin
                    this.control_type = PFC_CONTROL;
                   end 
              //ignoring pause_quanta[0]
                    else
                    this.control_type = MISC_CONTROL;
                    
                 end
               else
                   this.frame_type = DATA_FRAME;
               
                if(!(this.en_all_mcast)) begin
            // Data Frame
            if((this.frame_type == DATA_FRAME) && (this.da_type == MULTICAST)) begin
                this.da_type = UNICAST_INVALID;
            end
            
            
            // Control Frame
            if((this.frame_type == CONTROL_FRAME) && (this.control_type != PAUSE_CONTROL)) begin
                if(this.da_type == MULTICAST) begin
                    this.da_type = UNICAST_INVALID;
                end
            end
            
            // Pause Frame
            if((this.frame_type == CONTROL_FRAME) && (this.control_type == PAUSE_CONTROL)) begin
                if((this.da_type == MULTICAST)) begin
                    this.da_type = UNICAST_INVALID;
                end
            end
            
            // PFC Frame
            if((this.frame_type == CONTROL_FRAME) && (this.control_type == PFC_CONTROL)) begin
                if((this.da_type == MULTICAST)) begin
                    this.da_type = UNICAST_INVALID;
                end
            end
        end


       if(mac_frame.frame_type==ETH_VLAN_FRAME || mac_frame.frame_type==ETH_JUMBO_VLAN_FRAME) begin
         this.frame_size = mac_frame.payload.size() + 22;
         this.tag_overhead=4;
         end
         else if(mac_frame.frame_type==ETH_STACKED_VLAN_FRAME || mac_frame.frame_type ==ETH_JUMBO_STACKED_VLAN_FRAME)begin
         this.frame_size = mac_frame.payload.size() + 26;
         this.tag_overhead = 8;
         end
         else
         begin
         this.frame_size = mac_frame.payload.size() + 18;
         this.tag_overhead=0;
         end

         this.is_jumbo = ((mac_frame.frame_type == ETH_JUMBO_DATA_FRAME)||(mac_frame.frame_type == ETH_JUMBO_STACKED_VLAN_FRAME)|| (mac_frame.frame_type == ETH_JUMBO_VLAN_FRAME))?1:0; 
 
         this.error_type = NO_ERROR;
           
         if(mac_frame.rx_error[1]== 1)
         this.error_type = this.error_type | ERROR_CRC;

         if((mac_frame.payload.size() < mac_frame.eth_type_or_length)&&((mac_frame.frame_type == ETH_DATA_FRAME)||(mac_frame.frame_type == ETH_VLAN_FRAME)||(mac_frame.frame_type == ETH_STACKED_VLAN_FRAME))) begin
             $display("entering length_error  error_type =%0d  ",this.error_type); 
            this.error_type = this.error_type | ERROR_PAYLOAD_LENGTH;
             $display("end length_error  error_type =%0d  ",this.error_type); 
         end

         if(mac_frame.eth_type_or_length == 'h8808)
          begin
              if( this.frame_size > 'd64) 
                this.error_type = this.error_type | ERROR_OVERSIZED;
         end
         else begin
           if(this.frame_size > (max_frame_len + this.tag_overhead ))
              this.error_type = this.error_type | ERROR_OVERSIZED;
         end
         if (this.frame_size < 'd64)
          this.error_type = this.error_type | ERROR_UNDERSIZED;

         $display("is_jumbo display =%0d  ",this.is_jumbo); 
         $display("frame_size display =%0h  ",this.frame_size); 
         $display("error_type display =%0d  ",this.error_type); 
         $display("rx_error display =%0d  ",mac_frame.rx_error); 
         $display("tag_type display =%0d  ",this.tag_type); 
         $display("frame_length display =%0d  ",this.frame_length); 
         $display("payload_length display =%0d  ",this.payload_length); 
         $display("length_type display =%0d  ",this.length_type); 


                this.cg_mac_frame.sample();
           endfunction

              virtual function void always_block(); 
              fork
             
              forever begin 
              @(posedge spy_if.sig_avalon_st_txstatus_valid);
                  sig_avalon_st_txstatus_valid_reg =spy_if.sig_avalon_st_txstatus_valid;
                  sig_avalon_st_txstatus_error_reg =spy_if.sig_avalon_st_txstatus_error[6:0];
              end
                    
          
              forever begin
              @(posedge spy_if.sig_avalon_st_tx_endofpacket);
                  if (spy_if.sig_avalon_st_tx_error) begin
                      sig_avalon_st_tx_error_reg =spy_if.sig_avalon_st_tx_error;        
                  end
              end
          
              forever begin
              @(posedge spy_if.sig_avalon_st_rx_endofpacket);
                  if(spy_if.sig_avalon_st_rx_valid) begin
           		    sig_avalon_st_rx_error_reg =spy_if.sig_avalon_st_rx_error[5:0];
           		    sig_avalon_st_rx_valid_reg =spy_if.sig_avalon_st_rx_valid;
           		    sig_avalon_st_rx_endofpacket_reg = spy_if.sig_avalon_st_rx_endofpacket;
           	    end
              end
          
              forever begin
              @(posedge spy_if.sig_avalon_st_rx_endofpacket);
                  if (spy_if.sig_avalon_st_rxstatus_valid) begin
                      sig_avalon_st_rxstatus_valid_reg =spy_if.sig_avalon_st_rxstatus_valid;
                      sig_avalon_st_rxstatus_error_reg =spy_if.sig_avalon_st_rxstatus_error[6:0];
          			sig_gmii_rx_err_reg =spy_if.sig_gmii_rx_err;
                  end
              end 
          
          
          
              // tx link fault
              forever begin
              @(posedge spy_if.rx_link_fault_status[0] || spy_if.rx_link_fault_status[1]);
                      sig_link_fault_status_xgmii_tx_data_reg = spy_if.rx_link_fault_status;
            
            end 
          
              join_none 
              endfunction 
          
endclass

`endif
