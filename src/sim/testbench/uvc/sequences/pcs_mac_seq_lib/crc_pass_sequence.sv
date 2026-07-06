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


class crc_pass_sequence extends eth_base_sequence;
  bit crc;
  uvm_reg_data_t rd_data;
  bit [47:0] src_address;
  int num_of_frames;
  
  `uvm_object_utils(crc_pass_sequence)
  
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   $display("running crc pass sequence");
   
   //FIXME for GDR_ANLT if required,Otherwise remove
   //if (p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
   //    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   //end
    //muralasx: Added below logic to insert unique unicast source address when the parameter sa =1
    if(p_sequencer.env.dyn_rcfg_obj_inst.sa==1) begin
       src_address = $random();
       src_address[40]=0;
       $display("Source address %0h",src_address);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[47:32]);
    end
   
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
         num_of_frames = 10;
    end else begin
         num_of_frames = 100;
    end

    //Wait for tx_lane_Stable
    wait(p_sequencer.env.sideband_if.tx_lane_stable==1);
    
    crc = $urandom_range(0,1);
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{crc,1'b0}); 
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{31'h0,crc}); 

    crc = $urandom_range(0,1);
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_crccheck_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{crc,1'b0}); 

    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
     join
     p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(1ms));
     p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames),.timeout_time(1ms));
    `else
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
    `endif

    // Adding delay to ensure all transactions completed before the programming a new value
    p_sequencer.env.reg_read(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
    p_sequencer.env.reg_read(`GET_REG_ADDR(rx_crccheck_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 

    crc = $urandom_range(0,1);
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{crc,1'b0}); 
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{31'b0,crc}); 
    crc = $urandom_range(0,1);
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_crccheck_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{crc,1'b0}); 

    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
     join
     p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames*2),.timeout_time(1ms));
     p_sequencer.env.wait_tx_frames_received(.exp_num(num_of_frames*2),.timeout_time(1ms));
    `else
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
    `endif
    #100us;
  endtask
endclass
