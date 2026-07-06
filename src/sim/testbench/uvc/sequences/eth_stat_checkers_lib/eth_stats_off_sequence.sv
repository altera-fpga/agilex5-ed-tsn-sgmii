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


class eth_stats_off_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_stats_off_sequence)
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
    uvm_reg_data_t rd_data;
    string func_name="body";
    `uvm_info("body", "started eth_stat_base_sequence ...", UVM_NONE)
    //Enable vector scoreboard
    //en_vec_sb();
    

    // apply_hard_reset(0,0,1,11);
    // p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    //For tx error insertion
    //enable_tx_error_insertion();

    rand_regs();

    //Need to clear stat registers as Mlab RAM is not initialized. FB 489113
    //reg_predict_stats_off();
    //clear_stat_counters();
    //#400ns;
    
    reg_predict_stats_off();

    //FIXME : rx_parity_error & tx_parity_error is not avialable in F-time according to Ken(designers)
    //FIXME Shabbir: currently DV is not able to capture read data x, so clear parity error in any case
    //Read status regsiters for parity error
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);

    //if(read_data_tx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end
    //if(read_data_rx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end

    #100ns;
    reg_predict_stats_off();
    //parity error should get cleared now
    //FIXME Shabbir: currently DV is not able to capture read data x
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
    if(read_data_tx[0]!==0) begin
      `uvm_error("eth_stat_base_sequence", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=%0b",func_name,read_data_tx[0]));
    end
    if(read_data_rx[0]!==0) begin
      `uvm_error("eth_stat_base_sequence", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=%0b",func_name,read_data_rx[0]));
    end

    #0;
    //read and compare all stats at the begining of all stat sequence
    `uvm_info("eth_stat_base_sequence", "read and compare all stats at the begining of sequence", UVM_NONE)
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats();

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
 `ifdef ENABLE_ETH_VIP
      repeat($urandom_range(20,30)) begin
        fork
          begin
            randcase 
              1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);
              1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
            endcase
	        end  
          begin
            randcase 
              1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
              1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
            endcase
	        end  
        join
      end
      #800ns;
      reg_predict_stats_off();
  `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
 `endif
  endtask
  `ifdef UVM_VERSION_1_1
  virtual task post_start();
    string func_name="post_start";
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.phase_done.set_drain_time(this, 2us);
    end
    //read and compare all stats at the end of all stat sequence
    `uvm_info("eth_stat_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats();
    starting_phase.drop_objection(this, "Ending");
  endtask:post_start
  `endif
  function reg_predict_stats_off();
    //dsamantx :FIXME-GDR :Need to update the correct instance
    //please check all stat registers in documents before calling this task

    p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_fragments_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_fragments_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
    p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_jabbers_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_jabbers_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_fcserr_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_fcserr_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_crcerr_okpkt_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_crcerr_okpkt_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG      p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG      p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG      p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG      p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG      p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG      p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REg       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_oversize_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_oversize_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_rnt_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_rnt_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG     p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_frame_octetsok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG     p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_rx_frame_octetsok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_cfg_cntr_rx_config"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));

       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_fragments_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_fragments_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_jabbers_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_jabbers_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_fcserr_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_fcserr_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_crcerr_okpkt_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_crcerr_okpkt_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_ok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_ok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_err_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_err_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_oversize_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_oversize_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_rnt_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_rnt_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_frame_octetsok_lo"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
//MISSING_REG       p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_frame_octetsok_hi"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
       p_sequencer.env.gdr_ral_predict(.regname("mac_cfg_cntr_tx_config"),.value('hdeadc0de),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
  endfunction:reg_predict_stats_off
endclass:eth_stats_off_sequence
