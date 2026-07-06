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


class eth_mac_frame_mgbaset_rx_cov_sequence extends eth_base_sequence;
  
  uvm_reg_data_t rd_data;
   int frame_num_tx,frame_num_rx;
   int iter_cnt;
   int itr_cnt;
  bit [47:0] unicast_addr;
  int  rx_max_frame_size_value; 
  int  tx_max_frame_size_value;
  bit[47:0] supplementary_da_0; 
  bit[47:0] supplementary_da_1; 
  bit[47:0] supplementary_da_2; 
  bit[47:0] supplementary_da_3;

  `uvm_object_utils(eth_mac_frame_mgbaset_rx_cov_sequence)

  function new(string name = "eth_mac_frame_mgbaset_rx_cov_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    `uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "Executing eth_mac_frame_mgbaset_rx_cov_seqeuence ...", UVM_NONE)
    super.body();
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10G) begin

       //////////////////////////////////////////////
       // padding and crc passthrough ///////////////
       ///////////////////////////////////////////////
       p_sequencer.env.reg_read(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
       rd_data[1] =0; //retains CRC
       rd_data[0] = 0; //retains padding
       `uvm_info(get_full_name(), $psprintf("Writing rx_padcrc_control register with data = %0d",rd_data), UVM_NONE)
       p_sequencer.env.reg_write(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
       `uvm_info(get_full_name(), $psprintf("Writing rx_vlan_detection register with data = 0"), UVM_NONE)
       p_sequencer.env.reg_write(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),32'h0);

       //////////////////////////////////////////////////////
           // mac_rx_disc_err_dis_vlan_cp : VLAN              //
       //////////////////////////////////////////////////////
       `uvm_info("eth_test1", "VLAN FRAME WITH SIZE 64 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff));
       
       //////////////////////////////////////////////////////
       // mac_rx_disc_err_dis_svlan_cp : SVLAN              //
       //////////////////////////////////////////////////////
       `uvm_info("eth_test1", "SVLAN FRAME WITH SIZE 64 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff));
       `uvm_info("eth_test1", "SVLAN FRAME WITH SIZE B/W 65 to 127 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(68),.dest_address('hffffffffffff));
       `uvm_info("eth_test1", "SVLAN FRAME WITH SIZE B/W 128 to 255 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(135),.dest_address('hffffffffffff));
       `uvm_info("eth_test1", "SVLAN FRAME WITH SIZE B/W 256 to 511 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(280),.dest_address('hffffffffffff));
       `uvm_info("eth_test1", "SVLAN FRAME WITH SIZE B/W 512 to 1023 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(518),.dest_address('hffffffffffff));
       `uvm_info("eth_test1", "SVLAN FRAME WITH SIZE B/W 1024 to 1518 ,PAYLOAD LENGTH ERROR", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1030),.dest_address('hffffffffffff));

       //////////////////////////////////////////////////////
       // frame_length_error_undersized_runt_vlan_cp:  VLAN//
       //////////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "Undersized and VLAN frame", UVM_NONE)
       send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(26),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
       `uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "Undersized and VLAN frame", UVM_NONE)
       send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(46),.no_of_frame(1),.path(ETH_VIP_AVL_RX));


       //////////////////////////////////////////////////////
       //excess_pad_fix_46_length_untagged_cp///////////////
       /////////////////////////////////////////////////////
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1518),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(128),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(129),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(130),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(131),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(132),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(133),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(134),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(135),.dest_address('hffffffffffff),.length_type_value(46));

       /////////////////////////////////////////////////////////////////
       //payload_length_error_length_gt_frame_length_untagged_cp: UNTAGGED //
       /////////////////////////////////////////////////////////////////
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(47));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1518),.dest_address('hffffffffffff),.length_type_value(1501));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(128),.dest_address('hffffffffffff),.length_type_value(111));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(48));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(66),.dest_address('hffffffffffff),.length_type_value(49));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(67),.dest_address('hffffffffffff),.length_type_value(50));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(68),.dest_address('hffffffffffff),.length_type_value(51));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(69),.dest_address('hffffffffffff),.length_type_value(52));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(70),.dest_address('hffffffffffff),.length_type_value(53));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(71),.dest_address('hffffffffffff),.length_type_value(54));


	//////////////////////////////////////////////////////////////////////
	//payload_length_error_length_gt_frame_length_svlan_tagged_cp: SVLAN//
	/////////////////////////////////////////////////////////////////////
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(39));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1526),.dest_address('hffffffffffff),.length_type_value(1501));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(128),.dest_address('hffffffffffff),.length_type_value(103));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(40));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(66),.dest_address('hffffffffffff),.length_type_value(41));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(67),.dest_address('hffffffffffff),.length_type_value(42));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(68),.dest_address('hffffffffffff),.length_type_value(43));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(69),.dest_address('hffffffffffff),.length_type_value(44));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(70),.dest_address('hffffffffffff),.length_type_value(45));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(71),.dest_address('hffffffffffff),.length_type_value(46));
	
	//////////////////////////////////////////////////////////////////////////
	////excess_pad_frame_length_gt_length_vlan_cp:   VLAN/////////////////////
	//////////////////////////////////////////////////////////////////////////
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(42));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(128),.dest_address('hffffffffffff),.length_type_value(105));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(129),.dest_address('hffffffffffff),.length_type_value(106));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(130),.dest_address('hffffffffffff),.length_type_value(107));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(131),.dest_address('hffffffffffff),.length_type_value(108));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(132),.dest_address('hffffffffffff),.length_type_value(109));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(133),.dest_address('hffffffffffff),.length_type_value(110));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(134),.dest_address('hffffffffffff),.length_type_value(111));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(135),.dest_address('hffffffffffff),.length_type_value(112));
	send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1522),.dest_address('hffffffffffff),.length_type_value(1499));

       ////////////////////////////////////////////////////////////////////////////////
       /////////////////payload_length_error_fix_64_untagged_cp////////////////////////
       ////////////////////////////////////////////////////////////////////////////////
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(47));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(50));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1500));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1520));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1535));

       ////////////////////////////////////////////////////////
       /////excess_pad_frame_length_gt_length_svlan_cp :SVLAN//
       ////////////////////////////////////////////////////////
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(38));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(128),.dest_address('hffffffffffff),.length_type_value(101));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(129),.dest_address('hffffffffffff),.length_type_value(102));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(130),.dest_address('hffffffffffff),.length_type_value(103));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(131),.dest_address('hffffffffffff),.length_type_value(104));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(132),.dest_address('hffffffffffff),.length_type_value(105));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(133),.dest_address('hffffffffffff),.length_type_value(106));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(134),.dest_address('hffffffffffff),.length_type_value(107));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(135),.dest_address('hffffffffffff),.length_type_value(108));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1526),.dest_address('hffffffffffff),.length_type_value(1499));
       
       ////////////////////////////////////////////////////////////////
       ///// excess_pad_frame_length_gt_length_untagged_cp : Untagged//
       ////////////////////////////////////////////////////////////////
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(46));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1518),.dest_address('hffffffffffff),.length_type_value(1499));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(128),.dest_address('hffffffffffff),.length_type_value(109));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(129),.dest_address('hffffffffffff),.length_type_value(110));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(130),.dest_address('hffffffffffff),.length_type_value(111));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(131),.dest_address('hffffffffffff),.length_type_value(112));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(132),.dest_address('hffffffffffff),.length_type_value(113));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(133),.dest_address('hffffffffffff),.length_type_value(114));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(134),.dest_address('hffffffffffff),.length_type_value(115));
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(135),.dest_address('hffffffffffff),.length_type_value(116));


       //chethan
       ///////////////////////////////////////////////
       // read/write from rx_frame_contro register  //
       ///////////////////////////////////////////////
       p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
       rd_data[3] = 1; //rx_fwd_ctrl_pkt 0 drops control frmae, 1 Forwards control frames to the client
       rd_data[4] = 1; //rx_fwd_pause 0 drops pause frmae, 1 Forwards pause frames to the client;
       `uvm_info("eth_mgbaset_cov",$sformatf("writing rx_frame_control register with value = %0h",rd_data),UVM_NONE);
       p_sequencer.env.reg_write(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);

       //////////////////////////////////////////////////////////////////////////////////////
       // Added below logic to insert unique unicast source address when the parameter sa =1//
       /////////////////////////////////////////////////////////////////////////////////////
       unicast_addr = $random();
       unicast_addr[40]=0;
   `   uvm_info("eth_mgbaset_cov",$sformatf("unicast_addr = %0h",unicast_addr),UVM_NONE);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),unicast_addr[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),unicast_addr[47:32]);


       send_eth_frame_with_fcs_error(1,CONTROL_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,PFC_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX);
       send_eth_frame_with_fix_size(.eth_frame(SFC_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
       //  send_eth_frame_with_length_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1554));//error frame
       //  send_eth_frame_with_length_error(.frame_num(1),.f_type(JUMBO_STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size($urandom_range(64,1518)),.dest_address('hffffffffffff));
       //  send_eth_frame_with_length_error(.frame_num(1),.f_type(JUMBO_STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size($urandom_range(64,1518)),.dest_address('hffffffffffff));
       //  send_eth_frame_with_length_error(.frame_num(1),.f_type(JUMBO_STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size($urandom_range(64,1518)),.dest_address('hffffffffffff));

       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> excess_pad_fix_38_length_svlan_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "excess_pad_fix_38_length_svlan_cp_1", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1526),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(120),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(121),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(122),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(123),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(124),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(125),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(126),.dest_address('hffffffffffff),.length_type_value(38));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(127),.dest_address('hffffffffffff),.length_type_value(38));	

       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> excess_pad_fix_42_length_vlan_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "excess_pad_fix_42_length_vlan_cp_1", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(65),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1522),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(120),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(121),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(122),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(123),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(124),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(125),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(126),.dest_address('hffffffffffff),.length_type_value(42));	
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(127),.dest_address('hffffffffffff),.length_type_value(42));	
       //////////////////////////////////////////////////
       //  pause_vlan_tagged_cp  58pkt //
       //////////////////////////////////////////////////
       send_vlan_control_pause_frame(.frame_num(20),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(68),.dest_address(unicast_addr),.length_type_value('h8808));


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> frame_length_aRXPauseMACCtrlFrames_data_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", ". frame_length_aRXPauseMACCtrlFrames_data_cp", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(CONTROL_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> frame_length_error_payload_length_aFrameCheckSequenceErrors_no_crc_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "frame_length_error_payload_length_aFrameCheckSequenceErrors_no_crc_cp.", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(PFC_FRAME),.path(ETH_VIP_AVL_RX),.f_size($urandom_range(100,3000)),.dest_address('hffffffffffff));

       ///////////////////////////////////////////////////////////////////////
       //writing  random supplementary  address to 4 supplementary register// 
       ///////////////////////////////////////////////////////////////////////
       supplementary_da_0     = {$urandom,$urandom};
       supplementary_da_0[40] = 0;
       `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_0 address value = %0h",supplementary_da_0),UVM_NONE);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr0_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_0[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr0_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_0[47:32]);

       supplementary_da_1     = {$urandom,$urandom};
       supplementary_da_1[40] = 0;
       `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_1 address value = %0h",supplementary_da_1),UVM_NONE);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr1_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_1[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr1_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_1[47:32]);

       supplementary_da_2     = {$urandom,$urandom};
       supplementary_da_2[40] = 0;
       `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_2 address value = %0h",supplementary_da_2),UVM_NONE);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr2_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_2[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr2_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_2[47:32]);

       supplementary_da_3     = {$urandom,$urandom};
       supplementary_da_3[40] = 0;
       `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("supplementary_da_3 address value = %0h",supplementary_da_3),UVM_NONE);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr3_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_3[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_spaddr3_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),supplementary_da_3[47:32]);

       //////////////////////////////////////////////////////////////////////////////////////////
       // read/write to rx_frame_contro register with supplementary_sel //
       // 1> da_ucast_type_cp 
       //////////////////////////////////////////////////////////////////////////////////////////
       p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
       rd_data[1:0]     = 2'b11;       // EN_ALLUCAST EN_ALLMCAST 
       rd_data[19:16] = 4'b1111;     //   supplementary_addr select
       `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("rx_frame_control with allucast_mcast = %0h,supplementary_addr_sel =%0h",rd_data[1:0], rd_data[19:16]),UVM_NONE);
       p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),rd_data);

       /////////////////////////////////////////////////////////////////////////
   
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> mac_tx_insert_macaddr_en_sup0_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
 

       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> mac_tx_insert_macaddr_en_sup1_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_1));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_1));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_1));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_1));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_1));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_1));


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> mac_tx_insert_macaddr_en_sup2_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_2));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_2));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_2));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_2));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_2));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_2));


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> mac_tx_insert_macaddr_en_sup3_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_3));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(65,127)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_3));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(128,255)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_3));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(256,511)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_3));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(512,1023)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_3));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(1024,1518)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_3));
       
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> pause_error_oversized_cp
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        send_eth_frame_with_length_error(.frame_num(1),.f_type(SFC_FRAME),.path(ETH_VIP_AVL_RX),.f_size($urandom_range(65,68)),.dest_address('hffffffffffff));

       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> payload_length_error_fix_64_svlan_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_svlan_cp_1", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(39));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value($urandom_range(40,1499)));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1500));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value($urandom_range(1501,1534)));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1535));	


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> payload_length_error_fix_64_vlan_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_vlan_cp_1", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(43));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value($urandom_range(44,1499)));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1500));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value($urandom_range(1501,1534)));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(1535));	



        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> payload_length_error_length_gt_frame_length_vlan_tagged_cp 
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.dest_address('hffffffffffff),.length_type_value(43));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1522),.dest_address('hffffffffffff),.length_type_value(1501));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(120),.dest_address('hffffffffffff),.length_type_value(99));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(121),.dest_address('hffffffffffff),.length_type_value(100));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(122),.dest_address('hffffffffffff),.length_type_value(101));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(123),.dest_address('hffffffffffff),.length_type_value(102));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(124),.dest_address('hffffffffffff),.length_type_value(103));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(125),.dest_address('hffffffffffff),.length_type_value(104));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(126),.dest_address('hffffffffffff),.length_type_value(105));	
        send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(127),.dest_address('hffffffffffff),.length_type_value(106));

       #10us;
	 	// send_eth_frame_with_fcs_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1518),.ucast_en(1),.unicast_addr(unicast_addr));
	 	// send_eth_frame_with_fcs_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1518),.ucast_en(1),.unicast_addr(unicast_addr));
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> jumbo_frame_length_error_oversized_svlan_cp 
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", "jumbo_frame_length_error_oversized_svlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(JUMBO_STACKED_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1527),.length_type_value('h8870));

         send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size(9600),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> jumbo_frame_length_error_oversized_vlan_cp 
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", "jumbo_frame_length_error_oversized_vlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(JUMBO_VLAN_FRAME),.path(ETH_VIP_AVL_RX),.f_size(1523),.length_type_value('h8870));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size(9600),.no_of_frame(1),.path(ETH_VIP_AVL_RX));

        #30us;
        //////////////////////////////////////////////////
        //   RX FRAME SIZE : 1518, 16384 without error  //
        //////////////////////////////////////////////////
        rx_max_frame_size_value  = $urandom_range('hFF00,'hFFF0);
        `uvm_info(get_full_name(), $psprintf("Writing max_rx_size=  %0h max_tx_size =  %0h",rx_max_frame_size_value,tx_max_frame_size_value), UVM_NONE)
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size_value);

        //////////////////////////////////////////////////sushmitha  /////////////////////////////////////////
        //mac_shift16_off_fd_cp : RX FRAME size 1518
	`uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "rx frame size 1518", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1522),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
	
	//mac_shift16_off_fd_cp : RX FRAME size 16384
	`uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "rx frame size 16384", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(16388),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////



        //mac_shift16_off_fd_cp : RX FRAME size 1518
        `uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "rx frame size 1518", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1518),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
	
	//mac_shift16_off_fd_cp : RX FRAME size 16384
	`uvm_info("eth_mac_frame_mgbaset_rx_cov_sequence", "rx frame size 16384", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(16384),.no_of_frame(1),.path(ETH_VIP_AVL_RX));

        //chethan start
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(1537,9618)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));

        
        ///chethan 
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> jumbo_frame_length_no_error_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", ". jumbo_frame_length_no_error_cp1", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1555),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(9618),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1560),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1561),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1562),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1563),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1564),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1565),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1566),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1567),.no_of_frame(1),.path(ETH_VIP_AVL_RX));

     
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> jumbo_frame_length_no_error_tse_svlan_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", "jumbo_frame_length_no_error_tse_svlan_cp_1", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(1519,9599)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> jumbo_frame_length_no_error_tse_svlan_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", "jumbo_frame_length_no_error_tse_svlan_cp_1", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size($urandom_range(1563,9599)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));


         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1>  jumbo_frame_length_no_error_tse_vlan_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mgbaset_cov_sequence", "jumbo_frame_length_no_error_tse_vlan_cp_2", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(1559,9599)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));

       
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> frame_length_aRXPauseMACCtrlFrames_data_cp 
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mgbaset_cov_sequence", ". frame_length_aRXPauseMACCtrlFrames_data_cp", UVM_NONE)
          send_eth_frame_with_fix_size(.eth_frame(CONTROL_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(1),.path(ETH_VIP_AVL_RX));


         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> error_no_control_da_type_cp Broad_cast 
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mgbaset_cov_sequence", ". error_no_control_da_type_cp", UVM_NONE)
          send_eth_frame_with_fix_size(.eth_frame(PFC_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr('hffffffffffff));
         //////////////////////////////////////////////////////////////////////////////////////////
         // read/write to rx_frame_contro register with supplementary_sel  error_no_control_da_type_cp unicast_invalid//
         //////////////////////////////////////////////////////////////////////////////////////////
         p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
         rd_data[19:16] = 4'b0000;     //   supplementary_addr select
         `uvm_info("eth_supplementary_addr_chk_seq",$sformatf("rx_frame_control with allucast_mcast = %0h,supplementary_addr_sel =%0h",rd_data[1:0], rd_data[19:16]),UVM_NONE);
         p_sequencer.env.reg_write((`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),rd_data);
         

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> error_no_control_da_type_cp Broad_cast 
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mgbaset_cov_sequence", ". error_no_control_da_type_cp", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(SFC_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr('hffffffffffff));
         send_eth_frame_with_fix_size(.eth_frame(SFC_FRAME),.frame_size($urandom_range(100,150)),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       
	     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> error_no_control_da_type_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		 send_eth_frame_with_fix_size(.eth_frame(PFC_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));

		 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> error_no_data_da_type_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		 send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.unicast_addr(1),.ucast_addr(supplementary_da_0));

	     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> error_crc_control_da_type_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	 	 send_eth_frame_with_fcs_error(.frame_num(1),.f_type(PFC_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.ucast_en(1),.unicast_addr(supplementary_da_0));
	 	 send_eth_frame_with_fcs_error(.frame_num(1),.f_type(SFC_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.ucast_en(1),.unicast_addr(supplementary_da_0));
	 	 send_eth_frame_with_fcs_error(.frame_num(1),.f_type(DATA_FRAME),.path(ETH_VIP_AVL_RX),.f_size(64),.ucast_en(1),.unicast_addr(supplementary_da_0));

         ///////////////////////////////////////////////
         // tx_ipg_10g_OFFSET_REG  & bic_ipg_10g_cp ///////////////
         ///////////////////////////////////////////////
         p_sequencer.env.reg_read(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
         rd_data[0] = 0; //ipg_value 8
         `uvm_info(get_full_name(), $psprintf("Writing rx_padcrc_control register with data = %0d",rd_data), UVM_NONE)
         p_sequencer.env.reg_write(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> ipg value 8 with vlan,svlan and untaged frame  
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mgbaset_cov_sequence", "frame_length_error_payload_length_aFrameCheckSequenceErrors_no_crc_cp.", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(PFC_FRAME),.path(ETH_VIP_AVL_RX),.f_size($urandom_range(100,3000)),.dest_address('hffffffffffff));
         send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(100),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
         send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(100),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
      
         ///////////////////////////////////////////////
         //  speed TEST SEUQNCE          ///////////////
         //  transition from 100M -> 10g          ///////////////
         ///////////////////////////////////////////////
 
         #30us
         `ifdef ETH_MULTI_PORT
    	 p_sequencer.env.reg_read(`usxgmii_control_OFFSET_REG,rd_data);
     	 rd_data[4:2] = 3'b001;
	 p_sequencer.env.reg_write(`usxgmii_control_OFFSET_REG,rd_data);
	 `uvm_info("SWITCH_SEQUENCE", $sformatf("Register with address usxgmii_control ('h400) write data is  :'h%0h",rd_data), UVM_NONE);
  	   	
         `ifdef ENABLE_ETH_VIP
	 p_sequencer.env.`MAC_CFG.usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b001,1'b1,1'b1,6'd0,1'b1};
 	 p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.mac_cfg.cfg[0]);
         `endif
	 `else
	 //TODO LL10G   	 p_sequencer.env.reg_read(`usxgmii_control_OFFSET_REG,rd_data);
         //TODO LL10G    	 rd_data[4:2] = 3'b001;
         //TODO LL10G        p_sequencer.env.reg_write(`usxgmii_control_OFFSET_REG,rd_data);
         //TODO LL10G        `uvm_info("SWITCH_SEQUENCE", $sformatf("Register with address usxgmii_control ('h400) write data is  :'h%0h",rd_data), UVM_NONE);
         //TODO LL10G 	   	
         //TODO LL10G        `ifdef ENABLE_ETH_VIP
         //TODO LL10G        p_sequencer.env.mac_cfg.cfg[0].usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b001,1'b1,1'b1,6'd0,1'b1};
         //TODO LL10G	 p_sequencer.env.m_snps_eth_pcs66_agent.reconfigure_via_task(p_sequencer.env.mac_cfg.cfg[0]);
         //TODO LL10G        `endif
	 `endif
    	 #10us;
         	
         `ifdef ENABLE_ETH_VIP
         fork
          send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(100),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
          send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(100),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
   	 join
         `endif
         #10us;

         `ifdef ETH_MULTI_PORT
         p_sequencer.env.reg_read(`usxgmii_control_OFFSET_REG,rd_data);
     	 rd_data[4:2] = 3'b011;
	 p_sequencer.env.reg_write(`usxgmii_control_OFFSET_REG,rd_data);
	 `uvm_info("SWITCH_SEQUENCE", $sformatf("Register with address usxgmii_control ('h400) write data is  :'h%0h",rd_data), UVM_NONE);
  	   	
         `ifdef ENABLE_ETH_VIP
	 p_sequencer.env.`MAC_CFG.usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b011,1'b1,1'b1,6'd0,1'b1};
 	 p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(p_sequencer.env.mac_cfg.cfg[0]);
         `endif
	 `else
	 //TODO LL10G        p_sequencer.env.reg_read(`usxgmii_control_OFFSET_REG,rd_data);
         //TODO LL10G    	 rd_data[4:2] = 3'b011;
         //TODO LL10G        p_sequencer.env.reg_write(`usxgmii_control_OFFSET_REG,rd_data);
         //TODO LL10G        `uvm_info("SWITCH_SEQUENCE", $sformatf("Register with address usxgmii_control ('h400) write data is  :'h%0h",rd_data), UVM_NONE);
         //TODO LL10G 	   	
         //TODO LL10G        `ifdef ENABLE_ETH_VIP
         //TODO LL10G        p_sequencer.env.mac_cfg.cfg[0].usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b011,1'b1,1'b1,6'd0,1'b1};
         //TODO LL10G	 p_sequencer.env.m_snps_eth_pcs66_agent.reconfigure_via_task(p_sequencer.env.mac_cfg.cfg[0]);
         //TODO LL10G        `endif
	 `endif
    	 #10us;
      	
         fork
         `ifdef ENABLE_ETH_VIP
          send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(100),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
          send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(100),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
         `endif
   	 join
     
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    #10us;
    end else begin //_10G
      fork
         `ifdef ENABLE_ETH_VIP
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,5);  
       `endif
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
       join
       `ifdef ENABLE_ETH_VIP
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(5),.timeout_time(200us));
       p_sequencer.env.wait_tx_frames_received(.exp_num(5),.timeout_time(200us));
       `endif
    end
       

  endtask

endclass : eth_mac_frame_mgbaset_rx_cov_sequence
