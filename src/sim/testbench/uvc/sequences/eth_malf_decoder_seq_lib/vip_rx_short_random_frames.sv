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


class vip_rx_short_random_frames extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_rx_short_random_frames)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_rx_short_random_frames");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=500;
   end
   endfunction:new

   virtual task body();    
      bit [55:0] good_preamble;
      bit [55:0] bad_preamble;
      bit [7:0]  good_sfd;
      bit [7:0]  bad_sfd;
      int 	 preamble_post;
      int 	 sfd_post;
      
      frame_size_min=4;
      dis_ehip_drop_frame_cntr =1; //HSD : 1408167187 - disabling drop_frame_cntr in vip_strict_sfd_seq.EHIP does not count drop frames correctly when short and packet with invalid preamble/sfd comes back to back

      en_short_packet=1;
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);

      exception_list = new("exception_list", exception);
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));            
      `uvm_info("body", "Exiting ...", UVM_NONE);   
   endtask // body
   
endclass // vip_rx_short_random_frames
