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


class vip_oversize_frame_sequence extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_oversize_frame_sequence)
     alt_eth_error_vip_base_sequence err_seq;
     alt_eth_vip_custom_sequence eth_seq;
   
   function new(string name = "vip_oversize_frame_sequence");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   endfunction:new

   virtual task body();
      time reg_timeout_time=100ns;
      time frame_timeout_time=5us;
      uvm_status_e status;
      int  total_num_frames_sent=0;
      bit  rx_crc_pass;
      bit [31:0]  rx_max_size;
      
                  
      //p_sequencer.env.apply_reset("hard",0,0,1,11);
      //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
     `uvm_info("body", "Done for for rx_pcs_ready ...", UVM_MEDIUM)
       #100ns;

      /* Number of frames */
      sequence_length = 100;
      total_num_frames_sent=total_num_frames_sent+sequence_length;
      
      // Send frames
      p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
      `uvm_info("vip_oversize_frame_sequence", $sformatf("Max rx size read from reg = %0x",read_data), UVM_MEDIUM)

      // Wait for frames to be received
      for (int i=0;i<sequence_length;i++) begin
	 `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
	 eth_seq.payload_length = (read_data-50)+i;
	 eth_seq.start(p_sequencer.eth_vip_seqr_inst);
      end
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));   
      `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
   endtask // body

endclass // vip_oversize_frame_sequence
