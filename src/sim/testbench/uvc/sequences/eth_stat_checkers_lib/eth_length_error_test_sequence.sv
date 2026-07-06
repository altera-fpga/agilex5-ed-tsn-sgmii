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


class eth_length_error_test_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_length_error_test_sequence)

  int transaction_count;
  int frame_num_tx,frame_num_rx;
  bit tx_plen_en = 1'b1; //Enable Tx length error checking
  uvm_reg_data_t rd_data;
  uvm_reg_data_t txmac_ehip_cfg;
  bit [47:0] dest_address;
  //bit rx_crc_pass;
  int itr_cnt;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = 100;
    end
  endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_length_error_test_sequence ...", UVM_NONE)
    super.body();
    
//Register not present in DM    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
//Register not present in DM    txmac_ehip_cfg = {rd_data[31:5],tx_plen_en,rd_data[3:0]};
//Register not present in DM    `uvm_info("eth_length_error_test_sequence", $sformatf("Setting %0d to tx_plen_en",tx_plen_en), UVM_MEDIUM)
//Register not present in DM    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg);
//Register not present in DM
//Register not present in DM    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
//Register not present in DM    dest_address[31:0] = rd_data;
//Register not present in DM    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
//Register not present in DM    dest_address[47:32] = rd_data;

    //muralasx:  TODO need to keep below errors in a method. 
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 10:50;
    

    //2. Randomly send data frames with less payload size than the length/type field(Tx and Rx side,payload < 1500) , also send frames with payload > 1500 
    repeat(itr_cnt) begin
      fork
        begin
          randcase//Rx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1554));//error frame
            1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame_with_fix_size(VLAN_FRAME,-1,1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1558));//error frame
            1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,$urandom_range(1500,1536),1,ETH_VIP_AVL_RX);
            1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1562));//error frame
            1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(1570,1580));//COV:-  Ethernet type that was not FC X Length error
            1: send_eth_frame_with_length_error(1,PFC_FRAME,ETH_VIP_AVL_RX,-1,dest_address);//COV:-  SFC/PFC frame X   Length error
            1: send_eth_frame_with_length_error(1,SFC_FRAME,ETH_VIP_AVL_RX,-1,dest_address);//COV:-  SFC/PFC frame X   Length error
            1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(1530,1540));//COV:-  Illegal length type frame X Length error
            1: send_eth_frame_with_length_error(1,CONTROL_FRAME,ETH_VIP_AVL_RX,$urandom_range(1570,1580));//COV:- 
          endcase
	  frame_num_rx++;
        end
        begin
          randcase//Tx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
            1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(1501,1554));//error frame
            1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,-1);//error frame
            1: send_eth_frame_with_fix_size(VLAN_FRAME,-1,1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,$urandom_range(1501,1558));//error frame
            1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,-1);//error frame
            1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,$urandom_range(1500,1536),1,AVL_TX_ETH_VIP);
            1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,$urandom_range(1501,1562));//error frame
          endcase
	  frame_num_tx++;
        end
      join
    end
    #10us;
    p_sequencer.env.wait_client_rx_frames_done(.exp_num(frame_num_rx-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(1ms),.include_fc_pkt(1));
	p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms),.include_fc_pkt(1));
    // Read all stats registers.
    read_and_compare_stats();

  endtask

endclass : eth_length_error_test_sequence
