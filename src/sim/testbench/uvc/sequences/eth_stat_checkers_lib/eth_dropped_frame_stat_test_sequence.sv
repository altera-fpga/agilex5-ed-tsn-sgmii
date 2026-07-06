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


class eth_dropped_frame_stat_test_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_dropped_frame_stat_test_sequence)

  int transaction_count;
  int itr_cnt1,itr_cnt2;
  //bit rx_crc_pass;

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
    uvm_reg_data_t rd_data;
    `uvm_info("body", "started eth_dropped_frame_stat_test_sequence ...", UVM_NONE)
    super.body();
     p_sequencer.env.reg_read(`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);//mac_cfg_txmac_control
    rd_data[0]=$urandom_range(0,1);
    `uvm_info("eth_stat_base_sequence", $psprintf("Writing TX VLAN detection disable=%0b",rd_data[0]), UVM_NONE)
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);//mac_cfg_txmac_control
	//read rx_vlan_detection register
     p_sequencer.env.reg_read(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);//mac_cfg_txmac_control
    rd_data[0]=$urandom_range(0,1);
    `uvm_info("eth_stat_base_sequence", $psprintf("Writing RX VLAN detection disable=%0b",rd_data[0]), UVM_NONE)
//	write rx_vlan_detection register
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);//mac_cfg_txmac_control
    
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    
	if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
	   itr_cnt1 = 3;
	end else begin
	   itr_cnt1 = $urandom_range(5,10);
	end

    repeat(itr_cnt1) begin
      fork
        begin
          randcase//Rx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_sfd_preamble_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
          endcase
        end
        begin
          send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
        end
      join
    end

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
	   itr_cnt2 = 2;
	end else begin
	   itr_cnt2 = $urandom_range(50,100);
	end

    repeat(itr_cnt2) begin
      fork
        begin
          randcase//Rx path 
          //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
            1: send_eth_frame_with_sfd_preamble_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);//error frame
            1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
          endcase
        end
        begin
          send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
        end
      join
    end

   	p_sequencer.env.wait_tx_frames_received(.exp_num(itr_cnt1+itr_cnt2),.timeout_time(1ms));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
	   #250us;
	end   

    //Read all stats counter registers
    `uvm_info("eth_dropped_frame_stat_test_sequence", "Read All stats counter registers.", UVM_NONE)
    read_and_compare_stats();

    #900ns;

  endtask

endclass : eth_dropped_frame_stat_test_sequence
