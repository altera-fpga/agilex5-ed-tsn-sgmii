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


class vip_rx_short_random_frames_with_crc_pp_cov extends vip_error_base_sequence;
     bit preamble_pass;
     bit rx_crc;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg;
      
   `uvm_object_utils(vip_rx_short_random_frames_with_crc_pp_cov)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_rx_short_random_frames_with_crc_pp_cov");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=500;
   end
   endfunction:new

   virtual task body();    
      
      frame_size_min=4;
      dis_ehip_drop_frame_cntr =1; //HSD : 1408167187 - disabling drop_frame_cntr in vip_strict_sfd_seq.EHIP does not count drop frames correctly when short and packet with invalid preamble/sfd comes back to back

      en_short_packet=1;
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);


      reg_prog(0,0);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      //25G- when IFG=1, seeing unexpected error data from VIP, hence change
      //to default value
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed != _25G) 
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      else
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));         
      reg_prog(0,1);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed != _25G) 
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      else
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));         
      reg_prog(1,0);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed != _25G) 
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      else
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));         
      reg_prog(1,1);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed != _25G) 
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      else
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time)); 
      `uvm_info("body", "Exiting ...", UVM_NONE);   
   endtask // body
  

task  reg_prog(bit preamble,bit rx_crc);
p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
     if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.crc_pass)   `uvm_error("crc_pass_sequence", $sformatf("mac_cfg_mac_crc_config_OFFSET_REG bit 0 value must be initialized as per parameter"));

    preamble_pass = preamble;
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    txmac_ehip_cfg = {rd_data[31:1],preamble_pass};
     if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G,_40G})  
    $display ("Default value for en_pp for Tx is always 1, irrespective of GUI parameter");
     else begin
    if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough)   `uvm_error("preamble_sequence", $sformatf("mac_cfg_txmac_ehip_cfg_OFFSET_REGbit 0 value must be initialized as per parameter"));
    end
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    rxmac_ehip_cfg = {rd_data[31:1],preamble_pass};
    if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough)   `uvm_error("preamble_sequence", $sformatf("mac_cfg_rxmac_ehip_cfg_OFFSET_REGbit 0 value must be initialized as per parameter"));
    // programing crc value 0,1 randomly
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    if(rd_data[8] == 0)
     begin
     rx_crc = rx_crc;
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc); 
    `uvm_info("preamble_sequence", $sformatf("Setting %0d to crc pass",rx_crc), UVM_MEDIUM)
     p_sequencer.env.dyn_rcfg_obj_inst.crc_pass = rx_crc ;
     end

   // programing preamblepass 0,1 randomly
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G,_40G})   
    $display("Skipping writing to en_pp since run-time change is not valid for 50G");
     else begin
    `uvm_info("preamble_sequence", $sformatf("Setting %0d to RX,TX Preamble pass",preamble_pass), UVM_MEDIUM)
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg); 
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxmac_ehip_cfg);
    p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough = preamble_pass ;
    end 

endtask
endclass // vip_rx_short_random_frames_with_crc_pp_cov

