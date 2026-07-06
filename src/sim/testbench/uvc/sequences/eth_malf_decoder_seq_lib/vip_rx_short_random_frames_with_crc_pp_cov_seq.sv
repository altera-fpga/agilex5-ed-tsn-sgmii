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


class vip_rx_short_random_frames_with_crc_pp_cov_seq extends vip_error_base_sequence;
     bit preamble_pass;
     bit rx_crc;
	 time       frame_timeout_time=1ms;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg;
      
   `uvm_object_utils(vip_rx_short_random_frames_with_crc_pp_cov_seq)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_rx_short_random_frames_with_crc_pp_cov_seq");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=50;
   end
   endfunction:new

   virtual task body();    
      
      frame_size_min=4;
      $display("frame_size_min = %d",frame_size_min); 
      dis_ehip_drop_frame_cntr =1; //HSD : 1408167187 - disabling drop_frame_cntr in vip_strict_sfd_seq.EHIP does not count drop frames correctly when short and packet with invalid preamble/sfd comes back to back

      en_short_packet=1;
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);

      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
	      num_of_frames = 3;
	  end

      reg_prog(0,0);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      `uvm_info(get_full_name(),"Sending error frame \n",UVM_LOW);
      `uvm_info(get_full_name(),$sformatf("Sending frame with num_of_frames = %d frame_size_min = %d frame_size_max = %d en_short_packet = %d  ...\n",num_of_frames,frame_size_min,frame_size_max,en_short_packet),UVM_LOW)
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      
      total_num_frames_sent=num_of_frames;
      // Wait for frames to be received
      `uvm_info(get_full_name(),"Going to wait for receiving of frames\n", UVM_LOW);
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
     `uvm_info(get_full_name(),"Wait for receiving of frames is done\n", UVM_LOW); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));         
     `uvm_info(get_full_name(),"Wait for client rx frames is done\n", UVM_LOW);

      #25us;
      reg_prog(0,1);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      `uvm_info(get_full_name(),$sformatf("Sending frame with frame_size_min = %d frame_size_max = %d en_short_packet = %d  ...\n",frame_size_min,frame_size_max,en_short_packet),UVM_LOW) 
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      
	  total_num_frames_sent=total_num_frames_sent+num_of_frames;
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
       `uvm_info(get_full_name(),"Wait for receiving of frames is done\n", UVM_LOW);
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time)); 
       `uvm_info(get_full_name(),"Wait_1 for client rx frames is done\n", UVM_LOW);
     
	 #25us;
     //Premable passthrough is disabled for DM
     reg_prog(1,0);
     exception_list = new("exception_list", exception);
     `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
     // Send frames
     `uvm_info(get_full_name(),$sformatf("Sending frame with frame_size_min = %d frame_size_max = %d en_short_packet = %d ...\n",frame_size_min,frame_size_max,en_short_packet),UVM_LOW)
     err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      
	  total_num_frames_sent=total_num_frames_sent+num_of_frames;
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      `uvm_info(get_full_name(),"Wait for receiving of frames is done\n", UVM_LOW);
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time)); 
      `uvm_info(get_full_name(),"Wait_1 for client rx frames is done\n", UVM_LOW);

      #25us;
	  reg_prog(1,1);
      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      `uvm_info(get_full_name(),$sformatf("Sending frame with frame_size_min = %d frame_size_max = %d en_short_packet = %d  ...\n",frame_size_min,frame_size_max,en_short_packet),UVM_LOW)
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
      
	  total_num_frames_sent=total_num_frames_sent+num_of_frames;
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      `uvm_info(get_full_name(),"Wait for receiving of frames is done\n", UVM_LOW);
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time)); 
      `uvm_info(get_full_name(),"Wait_2 for client rx frames is done\n", UVM_LOW); 
      `uvm_info("body", "Exiting ...", UVM_NONE);   

   endtask // body
  

task  reg_prog(bit preamble,bit rx_crc);
   
   `uvm_info(get_full_name(),$psprintf("MS_DEBUG_VIP Inside vip_rx_seq reg_prog preamble = %d rx_crc = %d",preamble,rx_crc),UVM_NONE); 
    p_sequencer.env.reg_read(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);

    preamble_pass = preamble;
    p_sequencer.env.reg_read(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    txmac_ehip_cfg = {rd_data[31:1],preamble_pass};
    p_sequencer.env.reg_read(`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    rxmac_ehip_cfg = {rd_data[31:1],preamble_pass};
    
    if(rd_data[1] == 0)
    begin
     rx_crc = rx_crc;
     p_sequencer.env.reg_write(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc); 
    `uvm_info("preamble_sequence", $sformatf("Setting %0d to crc pass",rx_crc), UVM_MEDIUM)
     p_sequencer.env.dyn_rcfg_obj_inst.crc_pass = rx_crc ;
     end

     p_sequencer.env.reg_write(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg);
     p_sequencer.env.reg_write(`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxmac_ehip_cfg);
     p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough = preamble_pass ;

endtask
endclass // vip_rx_short_random_frames_with_crc_pp_cov

