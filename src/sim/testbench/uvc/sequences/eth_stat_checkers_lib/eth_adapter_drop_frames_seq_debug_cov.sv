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


class eth_adapter_drop_frames_seq_debug_cov extends eth_stat_base_sequence;
  eth_packet req;
  eth_packet req_mac;

  `uvm_object_utils(eth_adapter_drop_frames_seq_debug_cov)
  
   `ifdef ENABLE_ETH_VIP
   alt_eth_error_vip_base_sequence err_seq;
   svt_ethernet_transaction_exception_list exception_list;   
   svt_ethernet_transaction_exception exception;
   `endif
	 bit [15:0] frame_size_min; 
     bit [15:0] frame_size_max = 30;
     int 	      total_num_frames_sent=0;
     int 	      tx_frames_size=$urandom_range(1,8);
     time       frame_timeout_time=1ms;
     bit 	      en_short_packet=1'b1;
     int payload_size;
     int incr = 0;
     int num_words_local;
    uvm_reg_data_t rd_data;
  
  function new(string name = "eth_adapter_drop_frames_seq_debug_cov");
    super.new(name);
    //req_mac=new("req_mac"); 
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    
     super.body();
     
	 //dis_vec_sb();
     dis_stats_chk=1;
    
    if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) p_sequencer.env.master_agent.mast_mon.sip_limit=1;
    else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) p_sequencer.env.mast_mon_macseg_tx.sip_limit=1;
    
	if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) p_sequencer.env.eth_ref_model_inst.packet_stall=1;
    p_sequencer.env.eth_ref_model_inst.sip_limit=1;
    num_of_frames=5;
    total_num_frames_sent=num_of_frames;
    //  frame_size_max=30;
    //DM_Todo: uncomment once HSD resolved: Refer HSD : 16014797325
    frame_size_min=8;
    en_short_packet=1;

    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_broadcast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      //sending frame size less for tx_sop_eop coverage so disabling below
      //vip_rx checks
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);

      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      exception = new();
      ///** Create the exception list */
      exception_list = new("exception_list", exception);
      `endif
               
	  // Send frames
      for(int i = 0 ; i < 1 ; i++) begin
          `ifdef ENABLE_ETH_VIP
             if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin 
               err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
	       	   p_sequencer.env.wait_vip_tx_frames_done(.exp_num(num_of_frames *(i+1)),.timeout_time(frame_timeout_time)); 
               p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
	        end else begin
               err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(12),.en_short_packet(en_short_packet),.one_exception(1'b1));
               p_sequencer.env.wait_vip_tx_frames_done(.exp_num(num_of_frames *(i+1)),.timeout_time(frame_timeout_time)); 
               p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
	       	end
          `endif
      end

      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
         //do nothing, to reduce simulation time     
      end else begin   
         case(p_sequencer.env.dyn_rcfg_obj_inst.speed)
             _10G : num_words_local = 1;     
             _25G : num_words_local = 1;     
             _40G : num_words_local = 1;     
             _50G : num_words_local = 2;     
             _100G : num_words_local = 4;     
             _200G : num_words_local = 8;     
             _400G : num_words_local = 16;     
         endcase

 
            if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin 
                `uvm_create_on(req_mac, p_sequencer.v_m_sqr);
            end
            else begin 
                 `uvm_create_on(req_mac, p_sequencer.tx_seqr);
            end
            `uvm_info("body", "Exiting mac_tx_vip_rx_sequernce ...", UVM_MEDIUM);
           //end

          //Disabling scoreboard for this test since it is for only coverage
           p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
           p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
           p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
           p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;

          for(int i = 0; i < 100; i++) begin //300
             payload_size = $urandom_range(9,12);
            `uvm_info(get_name(),$sformatf("value of payload_1 is %d",(payload_size+incr)), UVM_LOW)
            req_mac.payload_size_c.constraint_mode(0);
            req_mac.interpacket_gap_c.constraint_mode(0);
            req_mac.skip_tx_crc_insertion_c.constraint_mode(0);
            if((payload_size+incr) < 12) begin
              if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) p_sequencer.env.master_agent.mast_mon.sip_limit=1;
              else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) p_sequencer.env.mast_mon_macseg_tx.sip_limit=1;
               if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) p_sequencer.env.eth_ref_model_inst.packet_stall=1;
              p_sequencer.env.eth_ref_model_inst.sip_limit=1;
              req_mac.sip_limit_test=1;
             // `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME;frame_payload_type == NORMAL;sip_limit_test == 1; payload.size == payload_size+incr; bus_rate == BUSY;interpacket_gap == 0;num_words == num_words_local; skip_tx_crc_insertion ==0;})
			     `uvm_rand_send_with(req_mac,{frame_type inside { ETH_DATA_FRAME,ETH_STACKED_VLAN_FRAME,ETH_VLAN_FRAME};frame_payload_type == NORMAL;sip_limit_test == 1; payload.size == payload_size+incr; bus_rate == BUSY;interpacket_gap == 0;num_words == num_words_local; skip_tx_crc_insertion ==0;})
            end
            else begin
              if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) p_sequencer.env.master_agent.mast_mon.sip_limit=0;
              else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) p_sequencer.env.mast_mon_macseg_tx.sip_limit=0;
               if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) p_sequencer.env.eth_ref_model_inst.packet_stall=0;
              p_sequencer.env.eth_ref_model_inst.sip_limit=0;
              req_mac.sip_limit_test=0;
             // `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME;frame_payload_type == NORMAL;sip_limit_test == 0; payload.size == payload_size+incr; bus_rate == BUSY;interpacket_gap == 0;num_words == num_words_local; skip_tx_crc_insertion ==0;})
			 `uvm_rand_send_with(req_mac,{frame_type inside {  ETH_DATA_FRAME,ETH_STACKED_VLAN_FRAME,ETH_VLAN_FRAME} ;frame_payload_type == NORMAL;sip_limit_test == 0; payload.size == payload_size+incr; bus_rate == BUSY;interpacket_gap == 0;num_words == num_words_local; skip_tx_crc_insertion ==0;})
            end
            incr=incr+1;
            if(incr==15)
              incr=0;
          end 

           for(int i = 0; i < 100; i++) begin //200
             payload_size = $urandom_range(9,10);
             incr = $urandom_range(7,12);
            `uvm_info(get_name(),$sformatf("value of payload_2 is %d",(payload_size+incr)), UVM_LOW)
            req_mac.payload_size_c.constraint_mode(0);
            req_mac.interpacket_gap_c.constraint_mode(0);
            req_mac.skip_tx_crc_insertion_c.constraint_mode(0);
            if((payload_size+incr) < 12) begin
              if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) p_sequencer.env.master_agent.mast_mon.sip_limit=1;
              else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) p_sequencer.env.mast_mon_macseg_tx.sip_limit=1;
               if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) p_sequencer.env.eth_ref_model_inst.packet_stall=1;
              p_sequencer.env.eth_ref_model_inst.sip_limit=1;
              req_mac.sip_limit_test=1;
              `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME;frame_payload_type == NORMAL;sip_limit_test == 1; payload.size == payload_size+incr; bus_rate == BUSY;interpacket_gap == 0;num_words == num_words_local; skip_tx_crc_insertion ==0;})

            end
            else begin
              if(p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) p_sequencer.env.master_agent.mast_mon.sip_limit=0;
              else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) p_sequencer.env.mast_mon_macseg_tx.sip_limit=0;
               if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) p_sequencer.env.eth_ref_model_inst.packet_stall=0;
              p_sequencer.env.eth_ref_model_inst.sip_limit=0;
              req_mac.sip_limit_test=0;
              `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME;frame_payload_type == NORMAL;sip_limit_test == 0; payload.size == payload_size+incr; bus_rate == BUSY;interpacket_gap == 0;num_words == num_words_local; skip_tx_crc_insertion ==0;})
            end
           end
           //wait for all frames to be received
           #250us;
      end     
      
      `uvm_info("body", "Exiting ...", UVM_MEDIUM);
          
  endtask
endclass
