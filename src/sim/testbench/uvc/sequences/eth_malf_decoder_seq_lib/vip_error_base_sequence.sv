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


 class vip_error_base_sequence extends eth_base_sequence;
  
   uvm_reg_data_t read_data;
   svt_ethernet_transaction_exception_list exception_list;   
   svt_ethernet_transaction_exception exception;
   int unsigned sequence_length = 1;
   bit [15:0] frame_size_min = 8;
   bit [15:0] frame_size_max = 10000;
   bit 	      preamble_pass;
   bit 	      rx_crc_pass;
   time       frame_timeout_time=10us;
   uvm_status_e status;
   int 	      total_num_frames_sent=0;
   bit 	      preamble_check;
   bit 	      sfd_check;
   bit 	      en_short_packet=1'b1;
      
   `uvm_object_utils(vip_error_base_sequence)
  
   function new(string name = "vip_error_base_sequence");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
      dis_stats_chk=0;
   endfunction:new

  `ifdef UVM_VERSION_1_1
   virtual    task pre_start();
      super.pre_start();
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_broadcast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      //dis_vec_sb();
      preamble_pass = $urandom_range(0,1);
      rx_crc_pass = $urandom_range(0,1);
      preamble_check = $urandom_range(0,1);
      sfd_check = $urandom_range(0,1);
      //apply_hard_reset(0,0,1,11);
      //`ifdef G100 //muralasx: FIXME for other speeds
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G && p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC)
        p_sequencer.env.eth_ref_model_inst.packet_stall=1;
      //`endif
      // `ifdef ANLT
      // setup_anlt();
      // `endif
      // p_sequencer.env.wait_rx_pcs_ready();
      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
          frame_timeout_time=1ms;      
      end
      #100ns;

//      `uvm_info("vip_error_base_sequence", $sformatf("Setting %0d to RX_CRC_PASS",rx_crc_pass), UVM_MEDIUM)
//      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
//      `uvm_info("vip_error_base_sequence", $sformatf("Setting %0d to RX Preamble pass",preamble_pass), UVM_MEDIUM)
//      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),preamble_pass); 
      
      //For sequences defined in eth_malf_decoder_seq_lib, set this flag so exceptions will not get removed from etherent_mac_sb_callbacks
      p_sequencer.env.mac_callback.eth_malf_decoder_seq_lib = 1; 
   endtask:pre_start
  `endif

    `ifdef UVM_VERSION_1_0
   virtual task pre_body();
      super.pre_body();
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   endtask:pre_body
    `endif


   virtual task body();
      $display("running sequence 0");
      // apply_hard_reset(0,0,1,11);
      // p_sequencer.env.wait_rx_pcs_ready();
//      `uvm_info("body", "Done for for rx_pcs_ready ...", UVM_MEDIUM)

      /** Create the exception class */
      exception = new();
      /** Create the exception list */
      exception_list = new("exception_list", exception);
      /** Assign the type of error to be inserted in exception class */
      exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
      exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
      exception_list.add_exception(exception);
      `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
   endtask // body

endclass // vip_error_base_sequence
