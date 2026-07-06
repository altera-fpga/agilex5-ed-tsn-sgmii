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


class eth_adapter_drop_frames_seq_part_1 extends eth_stat_base_sequence;

  `uvm_object_utils(eth_adapter_drop_frames_seq_part_1)
  
  `ifdef ENABLE_ETH_VIP
   alt_eth_error_vip_base_sequence err_seq;
   `endif
     bit [15:0] frame_size_min = 8;
     bit [15:0] frame_size_max = 30;
     int 	      total_num_frames_sent=0;
     time       frame_timeout_time=5us;
     bit 	      en_short_packet=1'b1;
     bit [2:0]  rst_sig;
     bit [2:0]  reset_bits;
     uvm_reg    regs;


  function new(string name = "eth_adapter_drop_frames_seq_part_1");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   uvm_reg_data_t read_data_tx;
   uvm_reg_data_t read_data_rx;
    bit skip_stat_reg_rd_l = 0;
     super.body();
//dis_vec_sb();
  //  uvm_reg_data_t read_data_tx;
  //  uvm_reg_data_t read_data;

      `uvm_info("eth_adapter_drop_frames_seq_part_1", "1. Apply csr reset", UVM_NONE)
//        apply_hard_reset(0,0,1,11);
      `uvm_info("eth_adapter_drop_frames_seq_part_1", "wait_rx_pcs_ready done ...", UVM_NONE)
//        p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      `ifdef G100
        p_sequencer.env.eth_ref_model_inst.packet_stall=1;
      `endif
      num_of_frames=500;
      total_num_frames_sent=num_of_frames;
  //  frame_size_max=30;
    //frame_size_min=8;
      en_short_packet=1;

      `ifdef G50
       frame_size_min=4;
       `endif

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

      //`endif
      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      exception = new();
      /** Create the exception list */
      exception_list = new("exception_list", exception);
      // Sending  frames
      `uvm_info("eth_adapter_drop_frame_sequence","1:Sending frames", UVM_MEDIUM)
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));   
      `endif
      #1000ns;
     
      `ifdef G50
      `uvm_info("eth_adapter_drop_frames_seq_part_1","2 Read  stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      if(read_data_rx ==0 && p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough ==1 ) begin
      `uvm_error("eth_adapter_drop_frames_seq_part_1", $sformatf("REGISTERS_rxmac_adapt_dropped_31_0_OFFSET_REG[0]=%0b",read_data_rx[0]));
      end

      `uvm_info("eth_adapter_drop_frames_seq_part_1","3 Clearing  stats counter register", UVM_MEDIUM)
       p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h1);
       p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,read_data_rx);
       if(read_data_rx[0]==0 && p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough == 1) begin
      `uvm_error("clear_stat_counters", $sformatf("Rxmac_Adapt_dropped is not self-clear"));
       end
      p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h0);
      #400ns;
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);
      
        `else
      `uvm_info("eth_adapter_drop_frames_seq_part_1","2 Read  stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      if(read_data_rx ==0) begin
      `uvm_error("eth_adapter_drop_frames_seq_part_1", $sformatf("REGISTERS_rxmac_adapt_dropped_31_0_OFFSET_REG[0]=%0b",read_data_rx[0]));
      end

      `uvm_info("eth_adapter_drop_frames_seq_part_1","3 Clearing  stats counter register", UVM_MEDIUM)
       p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h1);
       p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,read_data_rx);
       if(read_data_rx[0]==0) begin
      `uvm_error("clear_stat_counters", $sformatf("Rxmac_Adapt_dropped is not self-clear"));
       end
      p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h0);
      #400ns;
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);
      `endif

      
       // Sending  frames
       `ifdef ENABLE_ETH_VIP
      `uvm_info("eth_adapter_drop_frames_seq_part_1","4 Sending frames", UVM_MEDIUM)
      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
      p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
      p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));   
      `endif
      #1000ns;

      `uvm_info("eth_adapter_drop_frames_seq_part_1","5 Read  stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);


      `uvm_info("eth_adapter_drop_frames_seq_part_1", "6. Apply Shadow Request", UVM_NONE)
      apply_adapter_shadow_request();

      //. Read stats counter register 
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "7. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #100ns;
      
      
      `ifdef ENABLE_ETH_VIP
      `uvm_info("eth_adapter_drop_frames_seq_part_1","8. Sending frames", UVM_MEDIUM)
       err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
       p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
       `endif
      #500ns;

      //. Read stats counter register 
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "9. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #500ns;

      `uvm_info("eth_adapter_drop_frames_seq_part_1", "10. Clear Shadow Request", UVM_NONE)
      clear_shadow_request();
      #100ns;

      // check the register
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "11. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #100ns;
      
      // apply shadow request
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "12. Apply Shadow Request", UVM_NONE)
     apply_adapter_shadow_request();


     `ifdef ENABLE_ETH_VIP
      `uvm_info("eth_adapter_drop_frames_seq_part_1","13. Sending frames", UVM_MEDIUM)
       err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
       p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
       `endif
       #100ns;

        p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);
      // Set CNTR_CONFIG bit 1 to clear the counter. 
      `uvm_info("eth_adapter_drop_frames_seq_part_1", "14. Set CNTR_CONFIG bit 0 to clear the stat counter.", UVM_NONE)
        p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h1);
       #400ns;
        p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h0);
        #400ns;
        p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);
        #400ns;
     
      // check the register
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "15. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);

      // Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
      `uvm_info("eth_adapter_drop_frames_seq_part_1", "16. Clear Shadow Request", UVM_NONE)
      clear_shadow_request();
       #50ns;     
      // check the register
      `uvm_info("eth_adapter_drop_frames_seq_part_1", "17. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);

      `uvm_info("eth_adapter_drop_frames_seq_part_1", "18. Apply Shadow Request", UVM_NONE)
      apply_adapter_shadow_request(); 


      //. Read stats counter register 
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "19. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #100ns;
      
      
      `ifdef ENABLE_ETH_VIP
      `uvm_info("eth_adapter_drop_frames_seq_part_1","20. Sending frames", UVM_MEDIUM)
       err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
      // Wait for frames to be received
       p_sequencer.env.wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
       `endif
      #500ns;
      rst_sig = $urandom_range (1,7);
      //Apply_hard reset
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "21. Apply tx/rx/csr hard reset", UVM_MEDIUM)
       p_sequencer.env.apply_reset(.rst_type("hard"),.tx_rst(rst_sig[2]),.rx_rst(rst_sig[1]),.ip_rst(rst_sig[0]),.reset_period($urandom_range(21,50)));
       p_sequencer.env.wait_for_linkup(rst_sig[2],rst_sig[1],rst_sig[0]);

      //. Read stats counter register 
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "22. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #500ns;

      `uvm_info("eth_adapter_drop_frames_seq_part_1", "23. Clear Shadow Request", UVM_NONE)
      clear_shadow_request();
      #100ns; 

       //. Read stats counter register 
       `uvm_info("eth_adapter_drop_frames_seq_part_1", "24. Read stats counter register", UVM_MEDIUM)
      p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data_rx);
      #500ns;
       
      `uvm_info("eth_adapter_drop_frames_seq_part_1", "25. Set CNTR_CONFIG bit 0 to clear the stat counter.", UVM_NONE)
        #400ns;
        p_sequencer.env.reg_write(`ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG,'h1);
        #400ns;
        p_sequencer.env.reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data);
        #400ns;
        
      `uvm_info("body", "Exiting ...", UVM_MEDIUM);
         
  endtask

endclass: eth_adapter_drop_frames_seq_part_1
