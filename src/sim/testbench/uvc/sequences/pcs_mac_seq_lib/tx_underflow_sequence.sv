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


class tx_underflow_sequence extends eth_base_sequence;
  bit crc;
  bit pad;
  uvm_reg_data_t rd_data;
  bit [47:0] src_address;
  int num_of_frames;
  
  `uvm_object_utils(tx_underflow_sequence)
  
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   $display("running Tx underflow sequence");
   
    p_sequencer.env.eth_ref_model_inst.tx_underflow_case = 1'b1;
   
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
         num_of_frames = 10;
    end else begin
         num_of_frames = 50;
    end

    //Wait for tx_lane_Stable
    wait(p_sequencer.env.sideband_if.tx_lane_stable==1);

    p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
    p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
    
    crc = $urandom_range(0,1);
    crc = 1'b0;
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{crc,1'b1}); 
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{31'h0,pad}); 

    crc = $urandom_range(0,1);
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_crccheck_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{crc,1'b0}); 
    p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
    p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;

    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     fork
         send_eth_frame(UNDERSIZE_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
     join
    `else
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
    `endif

  endtask
endclass
