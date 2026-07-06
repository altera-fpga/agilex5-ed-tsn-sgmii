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


class eth_mac_frame_mgbaset_tx_cov_sequence extends eth_base_sequence;
  
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

  `uvm_object_utils(eth_mac_frame_mgbaset_tx_cov_sequence)

  function new(string name = "eth_mac_frame_mgbaset_tx_cov_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "Executing eth_mac_frame_mgbaset_tx_cov_seqeuence ...", UVM_NONE)
    super.body();
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10G) begin


        //////////////////////////////////////////////////////////////////////////////
	// Insert FCS error only when CRC has to be calculated and sent from AvST   //
        //  So writing 0 to register to  disbaling the CRC from MAC                 //
        /////////////////////////////////////////////////////////////////////////////
        p_sequencer.env.reg_read(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
        rd_data[1] = 1'b1;
       `uvm_info("eth_mgbaset_cov",$sformatf("writing tx_crc_control register with value = %0h",rd_data),UVM_NONE);
        p_sequencer.env.reg_write(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
    
        //////////////////////////////////////////////////////////////////////////////
	// tx_pad_control =1 --> tx_crc_control should be always 1                  //
        // tx_pad_control =0 --> tx_crc_control can be 0 or 1                      //
        /////////////////////////////////////////////////////////////////////////////
        p_sequencer.env.reg_read(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
        rd_data[0] = 1'b1;
       `uvm_info("eth_mgbaset_cov",$sformatf("writing tx_crc_control register with value = %0h",rd_data),UVM_NONE);
        p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 



        //Setting sip_limit to 1
	//p_sequencer.env.master_agent.mast_mon.sip_limit=1;	
	//p_sequencer.env.eth_ref_model_inst.sip_limit=1;


        //////////////////////////////////////////////////////////////////////////////////////
        // Added below logic to insert unique unicast source address                        //
        /////////////////////////////////////////////////////////////////////////////////////
        unicast_addr = 48'hD6D4D3D2D1D0;
        unicast_addr[40]=0;
       `uvm_info("eth_mgbaset_cov",$sformatf("unicast_addr = %0h",unicast_addr),UVM_NONE);
        p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),unicast_addr[31:0]);
        p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),unicast_addr[47:32]);
 
        //////////////////////////////////////////////////
        //  excess_pad_fix_38_length_svlan_cp           //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_fix_38_length_svlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(69),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1530),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(120),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(121),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(122),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(123),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(38));


        //////////////////////////////////////////////////
        //  excess_pad_fix_42_length_vlan_cp           //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_fix_42_length_vlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(69),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1526),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(42));


        //////////////////////////////////////////////////
        //  pause_vlan_tagged_cp  58pkt //
        //////////////////////////////////////////////////
         //send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(64),.no_of_frame(10),.path(AVL_TX_ETH_VIP),.frame_length_64(8808),.ucast_addr(unicast_addr));
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "pause_vlan_tagged_cp", UVM_NONE)
         //send_vlan_control_pause_frame(.frame_num(10),.f_size(71),.dest_address(unicast_addr));
         send_vlan_control_pause_frame(.frame_num(10));

        // send_vlan_control_pause_frame(.frame_num(10),.dest_address(unicast_addr));
        //////////////////////////////////////////////////
        //  excess_pad_fix_46_length_untagged_cp  58pkt //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_fix_46_length_untagged_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(69),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1522),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(46));


        //////////////////////////////////////////////////
        //  excess_pad_frame_length_gt_length_svlan_cp  //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_frame_length_gt_length_svlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(69),.length_type_value(38));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1530),.length_type_value(1499));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(93));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(94));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(95));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(96));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(97));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(98));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(99));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(100));


        //////////////////////////////////////////////////
        // excess_pad_frame_length_gt_length_untagged_cp //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_frame_length_gt_length_untagged_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(69),.length_type_value(46));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1522),.length_type_value(1499));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(101));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(102));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(103));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(104));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(105));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(106));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(107));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(108));

        //////////////////////////////////////////////////
        //  excess_pad_frame_length_gt_length_vlan_cp   //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_frame_length_gt_length_vlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(69),.length_type_value(42));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1526),.length_type_value(1499));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(97));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(98));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(99));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(100));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(101));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(102));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(103));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(104));
       
        //////////////////////////////////////////////////
        //  frame_length_error_undersized_fragment_svlan_cp    //
        //////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "frame_length_error_undersized_fragment_svlan_cp", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(26),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

        //////////////////////////////////////////////////
        //   frame_length_error_undersized_fragment_vlan_cp    //
        //////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "frame_length_error_undersized_fragment_vlan_cp", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(22),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
        
  
        //////////////////////////////////////////////////
        //   frame_length_mac_tx_pad_basic_cp           //
        //////////////////////////////////////////////////
        for(int i =1 ; i<48; i++)begin
          `uvm_info("eth_mgbaset_cov_sequence", "frame_length_mac_tx_pad_basic_cp", UVM_NONE)
           send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(68),.no_of_frame(1),.path(AVL_TX_ETH_VIP),.frame_length_64(i));
        end

        //////////////////////////////////////////////////
        //   frame_length_mac_tx_pad_svlan_cp           //
        //////////////////////////////////////////////////
        for(int i =0 ; i<39; i++)begin
          `uvm_info("eth_mgbaset_cov_sequence", "frame_length_mac_tx_pad_svlan_cp", UVM_NONE)
           send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(68),.no_of_frame(1),.path(AVL_TX_ETH_VIP),.frame_length_64(i));
        end


        //////////////////////////////////////////////////
        //   frame_length_mac_tx_pad_vlan_cp           //
        //////////////////////////////////////////////////
        for(int i =0 ; i<43; i++)begin
          `uvm_info("eth_mgbaset_cov_sequence", "frame_length_mac_tx_pad_vlan_cp", UVM_NONE)
           send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(68),.no_of_frame(1),.path(AVL_TX_ETH_VIP),.frame_length_64(i));
        end


        //////////////////////////////////////////////////
        //  payload_length_error_fix_64_svlan_cp  192      //
        //////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "excess_pad_fix_38_length_svlan_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(65),.length_type_value(38));


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> payload_length_error_fix_64_svlan_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_svlan_cp_1", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(39));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_svlan_cp_2", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value($urandom_range(40,1499)));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_svlan_cp_3", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(1500));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_svlan_cp_4", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value($urandom_range(1501,1534)));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_svlan_cp_5", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(1535));	


       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       /////////////// 1> payload_length_error_fix_64_untagged_cp 
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_untagged_cp_1", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(47));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_untagged_cp_2", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value($urandom_range(48,1499)));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_untagged_cp_3", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(1500));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_untagged_cp_4", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value($urandom_range(1501,1534)));	
       `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_fix_64_untagged_cp_5", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(1535));	

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> payload_length_error_fix_64_vlan_cp 
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_fix_64_vlan_cp_1", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(43));	
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_fix_64_vlan_cp_2", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value($urandom_range(44,1499)));	
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_fix_64_vlan_cp_3", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(1500));	
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_fix_64_vlan_cp_4", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value($urandom_range(1501,1534)));	
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_fix_64_vlan_cp_5", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(1535));





        //////////////////////////////////////////////////
       //  payload_length_error_length_gt_frame_length_svlan_tagged_cp  //
       //////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_length_gt_frame_length_svlan_tagged_cp", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(39));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1530),.length_type_value(1501));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(95));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(96));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(97));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(98));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(99));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(100));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(101));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(102));


       //////////////////////////////////////////////////
       //  payload_length_error_length_gt_frame_length_untagged_cp   //
       //////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "payload_length_error_length_gt_frame_length_untagged_cp", UVM_NONE)
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.length_type_value(47));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1522),.length_type_value(1501));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.length_type_value(103));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.length_type_value(104));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.length_type_value(105));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.length_type_value(106));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.length_type_value(107));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.length_type_value(108));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.length_type_value(109));
        send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.length_type_value(110));


      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      /////////////// 1> payload_length_error_length_gt_frame_length_vlan_tagged_cp 
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.dest_address('hffffffffffff),.length_type_value(43));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1526),.dest_address('hffffffffffff),.length_type_value(1501));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(124),.dest_address('hffffffffffff),.length_type_value(99));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(125),.dest_address('hffffffffffff),.length_type_value(100));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(126),.dest_address('hffffffffffff),.length_type_value(101));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(127),.dest_address('hffffffffffff),.length_type_value(102));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(128),.dest_address('hffffffffffff),.length_type_value(103));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(129),.dest_address('hffffffffffff),.length_type_value(104));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(130),.dest_address('hffffffffffff),.length_type_value(105));	
      `uvm_info("eth_mgbaset_cov_sequence", "payload_length_error_length_gt_frame_length_vlan_tagged_cp", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(131),.dest_address('hffffffffffff),.length_type_value(106));


       
       // fc_tx
       send_eth_frame_with_fix_size(.eth_frame(SFC_FRAME),.frame_size($urandom_range(68,72)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       send_eth_frame_with_fix_size(.eth_frame(PFC_FRAME),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       
       #30us;  
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
      // send_eth_frame_with_fix_size(.eth_frame(PFC_FRAME),.frame_size(100),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(104),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(104),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size(9604),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(9604),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size(9604),.no_of_frame(1),.path(AVL_TX_ETH_VIP));


       //pause_error_oversized_cp
       `uvm_info("eth_mgbaset_cov_sequence", "shruti_dbg: Oversized PAUSE frame", UVM_NONE)
       send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,68,1,AVL_TX_ETH_VIP);

       //Misc Frame
       `uvm_info("eth_mgbaset_cov_sequence", "shruti_dbg: MISC Control frame", UVM_NONE)
       send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(64),.dest_address('hffffffffffff),.length_type_value(8808));
    
       //Misc Control frame without Error
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.misc_control_frame(1));
       // pause_da_type_cp
       send_eth_frame_with_fix_size(.eth_frame(MCAST_CTRL_FRAME),.frame_size(64),.no_of_frame(1),.path(ETH_VIP_AVL_RX),.misc_control_frame(0));
       // Unicast Untagged with frame size 64,1518 
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(64),.no_of_frame(1),.path(AVL_TX_ETH_VIP),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1518),.no_of_frame(1),.path(AVL_TX_ETH_VIP),.unicast_addr(1),.ucast_addr(supplementary_da_0));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", " non_padded_frame_length_vlan_cp", UVM_NONE)
       send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(1526),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", " error_no_data_unicast_svlan_cp", UVM_NONE)
       send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(1530),.no_of_frame(1),.path(AVL_TX_ETH_VIP),.unicast_addr(1),.ucast_addr(supplementary_da_0));

       #30us;
       ////////////////////////////////////////sushmitha changes  ////////////////////////////////////////////////////////////////////////////////////////
       //  So writing 0 to register to  disbaling the CRC from MAC                 //
       /////////////////////////////////////////////////////////////////////////////
        p_sequencer.env.reg_read(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
        rd_data[1] = 1'b0;
       `uvm_info("eth_mgbaset_cov",$sformatf("writing tx_crc_control register with value = %0h",rd_data),UVM_NONE);
        p_sequencer.env.reg_write(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
    
        //////////////////////////////////////////////////////////////////////////////
	// tx_pad_control =1 --> tx_crc_control should be always 1                  //
        // tx_pad_control =0 --> tx_crc_control can be 0 or 1                      //
        /////////////////////////////////////////////////////////////////////////////
        p_sequencer.env.reg_read(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
        rd_data[0] = 1'b0;
       `uvm_info("eth_mgbaset_cov",$sformatf("writing tx_pad_control register with value = %0h",rd_data),UVM_NONE);
        p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);


   

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1>  mac_rx_disc_err_dis_basic_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.dest_address('hffffffffffff));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size($urandom_range(128,255)),.dest_address('hffffffffffff));
         send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size($urandom_range(256,511)),.dest_address('hffffffffffff));
              send_eth_frame_with_length_error(.frame_num(1),.f_type(DATA_FRAME),.path(AVL_TX_ETH_VIP),.f_size($urandom_range(1024,1518)),.dest_address('hffffffffffff));
 
         //////////////////////////////////////////////////////
             // mac_rx_disc_err_dis_svlan_cp : SVLAN              //
         //////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "SVLAN FRAME WITH SIZE 64 ,PAYLOAD LENGTH ERROR", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(STACKED_VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(68),.dest_address('hffffffffffff));

             ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          /////////////// 1>  jumbo_frame_length_error_oversized_svlan_cp
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         //`uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_error_oversized_svlan_cp", UVM_NONE)
          //send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size(9604),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

              //////////////////////////////////////////////////
         //   TX FRAME SIZE : 1518, 16384 without error  //
         //////////////////////////////////////////////////
         tx_max_frame_size_value  = $urandom_range('hFF00,'hFFF0);
         `uvm_info(get_full_name(), $psprintf("Writing max_rx_size=  %0h max_tx_size =  %0h",rx_max_frame_size_value,tx_max_frame_size_value), UVM_NONE)
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size_value);

         //mac_shift16_off_fd_cp : TX FRAME size 1518
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "tx frame size 1518", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1522),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
   
         //mac_shift16_off_fd_cp : TX FRAME size 16384
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "tx frame size 16384", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(16388),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> jumbo_frame_length_no_error_tse_svlan_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_svlan_cp", UVM_NONE)
          send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> mac_receive_frame_size_untagged_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", ". mac_receive_frame_size_untagged_cp", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1522),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1>   non_padded_frame_length_svlan_tse_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", " non_padded_frame_length_svlan_tse_cp", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(1530),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1>   non_padded_frame_length_untagged_tse_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", " non_padded_frame_length_untagged_tse_cp", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1522),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1>   non_padded_frame_length_vlan_tse_cp
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", " non_padded_frame_length_vlan_tse_cp", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(1526),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         		
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         /////////////// 1> frame_length_error_payload_length_cp 
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "frame_length_error_payload_length_cp", UVM_NONE)
         send_eth_frame_with_length_error(.frame_num(1),.f_type(VLAN_FRAME),.path(AVL_TX_ETH_VIP),.f_size(1522),.dest_address('hffffffffffff));	
   
         //////////////////////////////////////////////////
         // frame_length_no_error_svlan_cp : SVLAN//
         //////////////////////////////////////////////////////
         `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "frame_length_no_error_svlan_cp", UVM_NONE)
         send_eth_frame_with_fix_size(.eth_frame(STACKED_VLAN_FRAME),.frame_size(1530),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

         ////////////////////////////////////////////////////
         // frame_length_no_error_untagged_cp : UNTAGGED//
         /////////////////////////////////////////////////////
	`uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "frame_length_no_error_svlan_cp", UVM_NONE)
	 send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1522),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

	//////////////////////////////////////////////////////
	// frame_length_no_error_vlan_cp : VLAN//
	//////////////////////////////////////////////////////
	`uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "frame_length_no_error_vlan_cp", UVM_NONE)
	send_eth_frame_with_fix_size(.eth_frame(VLAN_FRAME),.frame_size(1526),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

	 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> jumbo_frame_length_no_error_cp
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", ". jumbo_frame_length_no_error_cp1", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1559),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp2", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(9622),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp3", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1564),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp4", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1565),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp5", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1566),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp6", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1567),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp7", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1568),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp8", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1569),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp9", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1570),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_cp10", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size(1571),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
            //not hitting
       ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> jumbo_frame_length_no_error_tse_untagged_cp
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_untagged_cp_1", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(1519,9599)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_untagged_cp_2", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
            //not hitting
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1> jumbo_frame_length_no_error_tse_untagged_mac_only_cp
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_untagged_mac_only_cp", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(1519,9599)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_untagged_mac_only_cp", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_DATA_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /////////////// 1>  jumbo_frame_length_no_error_tse_vlan_cp
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_vlan_cp_2", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(1559,9599)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "jumbo_frame_length_no_error_tse_vlan_cp_3", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

          //////////////////////////////////end sushmitha changes////////////////////////////////////////////////////////
        
       #30us;  
         //////////////////////////////////////////////////
	//   RX FRAME SIZE : 1518, 16384 without error  //
        //////////////////////////////////////////////////
	tx_max_frame_size_value  = $urandom_range('hFF00,'hFFF0);
       `uvm_info(get_full_name(), $psprintf("Writing max_rx_size=  %0h max_tx_size =  %0h",rx_max_frame_size_value,tx_max_frame_size_value), UVM_NONE)
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size_value);

       //mac_shift16_off_fd_cp : RX FRAME size 1518
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "rx frame size 1518", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(1518),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
	
       //mac_shift16_off_fd_cp : RX FRAME size 16384
       `uvm_info("eth_mac_frame_mgbaset_tx_cov_sequence", "rx frame size 16384", UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size(16384),.no_of_frame(1),.path(AVL_TX_ETH_VIP));


        //chethan
       ////jumbo_frame_length_no_error_tse_svlan_cp
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size($urandom_range(64,1518)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

       //jumbo_frame_length_no_error_tse_svlan_cp
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size($urandom_range(1519,9599)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

       //jumbo_frame_length_no_error_tse_svlan_cp
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_STACKED_VLAN_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

       //jumbo_frame_length_no_error_tse_vlan_cp
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(64,1518)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

       //jumbo_frame_length_no_error_tse_vlan_cp
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(1519,9599)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

       //jumbo_frame_length_no_error_tse_vlan_cp
       send_eth_frame_with_fix_size(.eth_frame(JUMBO_VLAN_FRAME),.frame_size($urandom_range(9600,10239)),.no_of_frame(1),.path(AVL_TX_ETH_VIP));

       //Unicast Invalid
       p_sequencer.env.reg_read(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
       rd_data[1] = 0; //rx_fwd_ctrl_pkt 0 drops control frmae, 1 Forwards control frames to the client
       `uvm_info("Tx cov",$sformatf("writing rx_frame_control register with value = %0h",rd_data),UVM_NONE);
       p_sequencer.env.reg_write(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
       for(int i=0; i<5; i++) begin 
         send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);
       end

       //Misc Control Frame
       //send_eth_frame_with_fix_size(MISC_CONTROL_FRAME,64,1,AVL_TX_ETH_VIP);


       
    #30us;
    end else begin //_10G
      `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,5);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
       join
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(5),.timeout_time(200us));
       p_sequencer.env.wait_tx_frames_received(.exp_num(5),.timeout_time(200us));
      `endif
    end


  endtask

endclass : eth_mac_frame_mgbaset_tx_cov_sequence
