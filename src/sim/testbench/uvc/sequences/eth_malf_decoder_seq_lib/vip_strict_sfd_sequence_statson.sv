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


class vip_strict_sfd_sequence_statson extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_strict_sfd_sequence_statson)
     alt_eth_error_vip_base_sequence err_seq;
   
   function new(string name = "vip_strict_sfd_sequence_statson");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=100;
   end
   endfunction:new

   virtual task body();
      bit [55:0] good_preamble;
      bit [55:0] bad_preamble;
      bit [7:0]  good_sfd;
      bit [7:0]  bad_sfd;
      int 	 preamble_post;
      int 	 sfd_post;      

      en_short_packet=1;
      dis_stats_chk=0;//stats chk is disabled in vip_error_base_sequence. But stats check should be enabled for this sequence
      //p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 1;
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE); 

      /* Number of frames */
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
         num_of_frames = 10;
      end   
      sequence_length = num_of_frames;
      good_preamble = 56'h55555555555555;
      good_sfd = 8'hd5;
      total_num_frames_sent=num_of_frames;
      dis_ehip_drop_frame_cntr =1;
      // Flip single bit of the good preamble
      // #1
      preamble_post = $urandom_range(55,0);
      sfd_post = $urandom_range(7,0);
      bad_preamble = good_preamble;
      bad_preamble[preamble_post] =~good_preamble[preamble_post];
      bad_sfd = good_sfd;
      bad_sfd[sfd_post] = ~good_sfd[sfd_post];
      exception = new();
      exception_list = new("exception_list", exception);
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
      exception.frame_send_invalid_preamble_bits_error = bad_preamble;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
      exception.frame_invalid_sfd_error = bad_sfd;
      exception_list.add_exception(exception);

      // Flip single bit of the good preamble
      // #2
      preamble_post = $urandom_range(55,0);
      sfd_post = $urandom_range(7,0);
      bad_preamble = good_preamble;
      bad_preamble[preamble_post] =~good_preamble[preamble_post];
      bad_sfd = good_sfd;
      bad_sfd[sfd_post] = ~good_sfd[sfd_post];
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
      exception.frame_send_invalid_preamble_bits_error = bad_preamble;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
      exception.frame_invalid_sfd_error = bad_sfd;
      exception_list.add_exception(exception);

      // Flip single bit of the good preamble
      // #3
      preamble_post = $urandom_range(55,0);
      sfd_post = $urandom_range(7,0);
      bad_preamble = good_preamble;
      bad_preamble[preamble_post] =~good_preamble[preamble_post];
      bad_sfd = good_sfd;
      bad_sfd[sfd_post] = ~good_sfd[sfd_post];
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
      exception.frame_send_invalid_preamble_bits_error = bad_preamble;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
      exception.frame_invalid_sfd_error = bad_sfd;
      exception_list.add_exception(exception);

      // Flip single bit of the good preamble
      // #4
      preamble_post = $urandom_range(55,0);
      sfd_post = $urandom_range(7,0);
      bad_preamble = good_preamble;
      bad_preamble[preamble_post] =~good_preamble[preamble_post];
      bad_sfd = good_sfd;
      bad_sfd[sfd_post] = ~good_sfd[sfd_post];
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
      exception.frame_send_invalid_preamble_bits_error = bad_preamble;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
      exception.frame_invalid_sfd_error = bad_sfd;
      exception_list.add_exception(exception);

      // Flip single bit of the good preamble
      // #5
      preamble_post = $urandom_range(55,0);
      sfd_post = $urandom_range(7,0);
      bad_preamble = good_preamble;
      bad_preamble[preamble_post] =~good_preamble[preamble_post];
      bad_sfd = good_sfd;
      bad_sfd[sfd_post] = ~good_sfd[sfd_post];
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
      exception.frame_send_invalid_preamble_bits_error = bad_preamble;
      exception_list.add_exception(exception);
      exception = new();
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
      exception.frame_invalid_sfd_error = bad_sfd;
      exception_list.add_exception(exception);      
      
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      // Send frames
       //25G IFG > min value ; VIP- SNPS ticket 01105940
      if(!(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G})) begin
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet));
      end else begin
        err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet));
      end	
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));      
      #200ns;

      `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
   endtask // body

endclass // vip_strict_sfd_sequence_statson
