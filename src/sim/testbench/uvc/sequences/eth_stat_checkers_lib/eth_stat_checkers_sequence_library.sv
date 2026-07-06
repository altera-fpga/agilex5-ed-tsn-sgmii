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


//Base sequence for stat sequences
class eth_stat_base_sequence extends eth_base_sequence;
  uvm_reg_data_t read_data_tx;
  uvm_reg_data_t read_data_rx;
  `ifdef ENABLE_ETH_VIP
  svt_ethernet_transaction_exception_list exception_list;   
  svt_ethernet_transaction_exception      exception;
  `endif
  `uvm_object_utils(eth_stat_base_sequence)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    uvm_reg_data_t rd_data;
    string func_name="body";
    uvm_cmdline_processor  inst;
    string m_sequence = "vip_sanity_sequence";

    super.body();
    `uvm_info("body", "started eth_stat_base_sequence ...", UVM_NONE)
    //Enable vector scoreboard
    //en_vec_sb();
   
    //reducing num_of_frames to max 2.5K to reduce sim time for stats
    //if(num_of_frames > 2500) begin
    //  void'(std::randomize(num_of_frames) with { num_of_frames dist {[500:700]:=35 , [701:1000]:=25 , [1001:2000]:=20 , [2001:2500]:=10};});
    //end    
    //Shabbir- Rekha wants to complete stats tests in 8 hours
    if(num_of_frames > 600 || num_of_frames==0) begin
      void'(std::randomize(num_of_frames) with { num_of_frames dist {[100:200]:=45 , [201:400]:=35 , [401:600]:=20};});
    end    
    //Shabbir- cr3 link up takes ~5 times more than cr2e, hence num_of_frames has to be reduced to complete test in 8 hours
    //`ifdef CRETE3//muralasx: FIXME for GDR
    if(num_of_frames > 300) begin
      void'(std::randomize(num_of_frames) with { num_of_frames dist {[50:100]:=45 ,[101:200]:=35 , [201:300]:=20};});
    end    
    //For below sequences, need to reduce frame count to complete test in 8 hours
    inst = uvm_cmdline_processor::get_inst();
    inst.get_arg_value("+m_sequence=",m_sequence);
    if(num_of_frames > 70 && (m_sequence == "eth_stat_64B_MAXB_cnt_sequence"         || 
      m_sequence == "eth_stat_crcerrokpkt_cnt_sequence"  || 
      m_sequence == "eth_stat_reset_sequence"          || 
      m_sequence == "eth_stat_shadowcopy_sequence"        || 
      m_sequence == "eth_stats_fragments_rnt_cnt_sequence"    || 
      m_sequence == "eth_stat_pause_cnt_sequence"    || 
      m_sequence == "eth_stat_fcs_err_frame_seq")) begin
      void'(std::randomize(num_of_frames) with { num_of_frames dist {[30:40]:=45 ,[41:60]:=35 , [61:70]:=20};});
    end
    //`endif
    `uvm_info(get_name(),$sformatf("eth_stat_base_sequence: no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)

    //Demoting common error
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    `endif

    // apply_hard_reset(0,0,1,11);
    // `ifdef CRETE3
    //   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    // `else  
    //   rx_pcs_ready_timeout();//Shabbir - FB 534015
    // `endif  

    //For tx error insertion
    //enable_tx_error_insertion();//Disabling Tx error insertion for every tests

    //muralasx: FIXME fix register code as GDR reg_model isn't available
    rand_regs();
    

    //Need to clear stat registers as Mlab RAM is not initialized. FB 489113
    clear_stat_counters();
    #400ns;
    //p_sequencer.env.eth_ref_model_inst.dis_fc_assertion=1;
    
    //FIXME dsamantx: According to Ken(designers),rx_parity_error and tx_parity_error not available in F-tile. please check and clean up accordingly.
    //FIXME Shabbir: currently DV is not able to capture read data x, so clear parity error in any case
    //Read status regsiters for parity error
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);

    //if(read_data_tx[0]!==0) begin
    //  p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end
    //if(read_data_rx[0]!==0) begin
    //  p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end

    #100ns;
    //parity error should get cleared now
    //FIXME Shabbir: currently DV is not able to capture read data x
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
//DM_TODO Cleanup    if(read_data_tx[0]!==0) begin
//DM_TODO Cleanup      `uvm_error("eth_stat_base_sequence", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=%0b",func_name,read_data_tx[0]));
//DM_TODO Cleanup    end
//DM_TODO Cleanup    if(read_data_rx[0]!==0) begin
//DM_TODO Cleanup      `uvm_error("eth_stat_base_sequence", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=%0b",func_name,read_data_rx[0]));
//DM_TODO Cleanup    end
//DM_TODO Cleanup
    #0;
    //FIXME EHIP Shabbir: FB 505364, need to fix DV, scripts
//    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
    //Shabbir: disabling en_sfc/pfc, so SFC frames are not processed and traffic will not be halted on TX side even with fc1 which prevents AVST tiemout
//    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h0);

  endtask : body

  `ifdef UVM_VERSION_1_1
  virtual task post_start();
    string func_name="post_start";
    //Read status regsiters for parity error, it is checked in ref model
    //FIXME Shabbir: currently DV is not able to capture read data x
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
// DM_TODO Cleanup    if(read_data_tx[0]!==0) begin
// DM_TODO Cleanup      `uvm_error("eth_stat_base_sequence", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=%0b",func_name,read_data_tx[0]));
// DM_TODO Cleanup    end
// DM_TODO Cleanup    if(read_data_rx[0]!==0) begin
// DM_TODO Cleanup      `uvm_error("eth_stat_base_sequence", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=%0b",func_name,read_data_rx[0]));
// DM_TODO Cleanup    end
    super.post_start();
  endtask:post_start
  `endif



endclass:eth_stat_base_sequence

//Shabbrir: creating temporary sequence to read stat registers for FB 480945. So designer can validate his fix
//`include "stat_sanity_sequence.sv"

//`include "fcs_error_sequence.sv"

// Fixme : Utpal - Added this sequence for debug purpose. Need to remove it later. 
//`include "eth_debug_seq.sv"

// Fixme : Utpal - Added this sequence for debug purpose. Need to remove it later. 
//`include "eth_debug_seq_1.sv"

//Class : eth_stats_fragments_rnt_cnt_sequence 
//1. Apply csr reset.
//2. Read FRAGMENTS and RNT registers.
//3. Send undersize frame with an FCS error or without an FCS Error randomly.
//4. Read FRAGMENTS and RNT counter register
//5. Repeat step 3 and step 4 five to ten time to ensure FRAGMENTS and RNT counters increments by 1.
//6. Send undersize and normal frames without FCS Error and Read FRAGMENTS and RNT counter registers.
//7. Send undersize and normal frames with FCS Error and Read FRAGMENTS and RNT counter registers.
//8. Send 63/64/65 bytes frame with FCS error and read FRAGMENTS and RNT counter registers after each frame.
//9. send 63/64/65 bytes frame without FCS error and read FRAGMENTS and RNT counter registers after each frame
//10. Send undersize and normal with and without FCS Error frames randomly.
//11. Read FRAGMENTS and RNT counter registers.
//12. Send random frames such that read value of FRAGMENTS and RNT counters status register rollover from 32 bit value to 33 bit value  and read FRAGMENTS and RNT registers after each frame.
//13. Send random frames such that read value of FRAGMENTS and RNT counter status registers reach to maximum value  
//14. Read FRAGMENTS and RNT counter registers.
//15. Send undersize and normal with and without FCS Error randomly after FRAGMENTS and RNT counter reaches to maximum value.
//16. Read FRAGMENTS and RNT counter register to make sure counter does not rollover.
//17. Read all stats counter registers
//This sequence can be used to drive fragment and runt frames from VIP 
`include "eth_stats_fragments_rnt_cnt_sequence.sv"

//class eth_stat_fcs_err_frame_seq
//1. Apply csr reset.
//2. Read FCSERR register.
//3. Send one frame with FCS error (i.e oversize,undersize,normal)
//4. Read FCSERR counter register
//5. Repeat step 3 and step 4 five to ten time to ensure FCSERR counter increments by 1.
//6. Send some frames without FCS error (i.e oversize,undersize,normal). 
//7. Read FCSERR register
//8. Send random  frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)
//9. Read FCSERR register
//10. Send random frames such that read value of FCSERR counter status register rollover from 32 bit value to 33 bit value  and read FCSERR register after each frame.
//11. Send random frames such that read value of FCSERR counter status register reaches to maximum value  
//12. Read FCSERR counter register
//13. Send random frames after FCSERR counter reaches to maximum value.
//14. Read FCSERR counter register to make sure counter does not rollover.
//15. Read all stats counter registers
`include "eth_stat_fcs_err_frame_seq.sv"

//Class : eth_stat_reset_sequence
//1. Apply csr reset.
//2. Read all stats counter register 
//3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
//4. Read all stats counter register .
//5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
//6. Repeat step 3 and 4.
//7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
//8. Read all stats counter register .
//9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
//10. Read all stats counter registers.
//11. repeat step 6.
//12. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//4. Read all stats counter registers.
//13. read all stat regiters after sending some frames to make sure counter does not gts updated  
//14. repeat step 7 to 10.
//15. EHIP: check clear stats functionality
/*class eth_stat_reset_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_reset_sequence)

  int transaction_count;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    uvm_reg_data_t read_data_tx;
    uvm_reg_data_t read_data_rx;
    bit skip_stat_reg_rd_l = 0;
    `uvm_info("body", "started eth_stat_reset_sequence ...", UVM_NONE)
    super.body();

    if($test$plusargs("skip_stat_reg_rd")) begin
      skip_stat_reg_rd_l = 1;
    end
    else begin
      skip_stat_reg_rd_l = 0;
    end

    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = num_of_frames/4;
    end
    //Ignore expected VIP errors
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
  p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame

    if(skip_stat_reg_rd_l === 0) begin
      //read and compare all stats at the begining of sequence
      `uvm_info("eth_stat_reset_sequence", "2. read and compare all stats at the begining of sequence", UVM_NONE)
      read_and_compare_stats();
    end

    //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_reset_sequence", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    #700ns; 
    `uvm_info("eth_stat_reset_sequence", "3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
    p_sequencer.env.write_stat_regs();

    //4. Read all stats counter register .
    `uvm_info("eth_stat_reset_sequence", "4. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
    `uvm_info("eth_stat_reset_sequence", "5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter", UVM_NONE)
    apply_rst_to_clear_stat_reg();

    //6. Repeat step 3 and 4.
    `uvm_info("eth_stat_reset_sequence", "6. Repeat step 3 and 4", UVM_NONE)
    `uvm_info("eth_stat_reset_sequence", "6.3. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    #700ns; 
    `uvm_info("eth_stat_reset_sequence", "6.3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
    p_sequencer.env.write_stat_regs();

    //4. Read all stats counter register .
    `uvm_info("eth_stat_reset_sequence", "6.4. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
    `uvm_info("eth_stat_reset_sequence", "7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly", UVM_NONE)
    apply_tx_rx_hard_soft_rst();

    `uvm_info("eth_stat_reset_sequence", "8. Read all stats counter register to check they retain value", UVM_NONE)
    read_and_compare_stats();

    `uvm_info("eth_stat_reset_sequence", "9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter and 10. Read all stats counter registers", UVM_NONE)
    apply_rst_to_clear_stat_reg();

    //11. repeat step 6
    `uvm_info("eth_stat_reset_sequence", "11. Repeat step 6", UVM_NONE)
    `uvm_info("eth_stat_reset_sequence", "11.6. Repeat step 3 and 4", UVM_NONE)
    `uvm_info("eth_stat_reset_sequence", "11.6.3. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    #700ns; 
    `uvm_info("eth_stat_reset_sequence", "11.6.3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
    p_sequencer.env.write_stat_regs();

    //4. Read all stats counter register .
    `uvm_info("eth_stat_reset_sequence", "11.6.4. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //12. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
    `uvm_info("eth_stat_reset_sequence", "12. Apply shadow request", UVM_NONE)
    apply_shadow_request();
    read_and_compare_stats();//As per Mehul's feedback

    //13. read all stat regiters after sending some frames to make sure counter does not gets updated  
    `uvm_info("eth_stat_reset_sequence", "13. read all stat regiters after sending some frames to make sure counter does not gets updated", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    #700ns; //572434250 FIXME Shabbir: wait till tx/rx frame is decoded by MAC and stat is updated
    read_and_compare_stats();//As per Mehul's feedback

    `uvm_info("eth_stat_reset_sequence", "13.1. clear shadow request", UVM_NONE)
    clear_shadow_request();

    #0;
    `uvm_info("eth_stat_reset_sequence", "13.2. Read all stats counter registers, they should have actual counter values as shadow request is cleared", UVM_NONE)
    read_and_compare_stats();

    //14. repeat step 7 to 10.
    `uvm_info("eth_stat_reset_sequence", "14. repeat step 7 to 10", UVM_NONE)

    `uvm_info("eth_stat_reset_sequence", "14.1. Apply shadow request again and apply reset/clear stat regs while shadow request is ON", UVM_NONE)
    apply_shadow_request();

    //7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
    `uvm_info("eth_stat_reset_sequence", "14.7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly", UVM_NONE)
    apply_tx_rx_hard_soft_rst();

    `uvm_info("eth_stat_reset_sequence", "14.8. Read all stats counter register to check they retain value", UVM_NONE)
    read_and_compare_stats();

    `uvm_info("eth_stat_reset_sequence", "14.9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 and check stats counters are not reset and 14.10. Read all stats counter registers", UVM_NONE)
    apply_rst_to_clear_stat_reg();

    `uvm_info("eth_stat_reset_sequence", "14.10. clear shadow request", UVM_NONE)
    clear_shadow_request();

    #0;
    `uvm_info("eth_stat_reset_sequence", "14.11. Read all stats counter registers, they should have actual counter values as shadow request is cleared", UVM_NONE)
    read_and_compare_stats();

    `uvm_info("eth_stat_reset_sequence", "15.1. Check clear stats functionality. Send frames to get counters incremented", UVM_NONE)
    send_directed_frames();
    send_random_frames(transaction_count);

    `uvm_info("eth_stat_reset_sequence", "15.2. Clear stats registers", UVM_NONE)
    clear_stat_counters();
    #400ns;

    `uvm_info("body", "ended eth_stat_reset_sequence ...", UVM_NONE)
  endtask

endclass:eth_stat_reset_sequence
*/

//Class : eth_stat_reset_sequence_part_1
//1. Apply csr reset.
//2. Read all stats counter register 
//3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
//4. Read all stats counter register .
//5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
//6. Repeat step 3 and 4.
//7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
//8. Read all stats counter register .
//9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
//10. Read all stats counter registers.
//11. repeat step 6.
//12. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//4. Read all stats counter registers.
//13. read all stat regiters after sending some frames to make sure counter does not gts updated  
//14. repeat step 7 to 10.
//15. EHIP: check clear stats functionality
//`include "eth_stat_reset_sequence_part_1.sv"
//
//`include "eth_stat_reset_sequence_part_2.sv"
//
//`include "eth_stat_reset_sequence_part_3.sv"
//
//`include "eth_stat_reset_sequence_part_4.sv"

//1. Apply csr reset.
//2. Read JABBERS register and configure MAX PAYLOAD SIZE register with random value.
//3. Send one oversize frame with FCS error 
//4. Read JABBERS counter register
//5. Repeat step 3 and step 4 five to ten time to ensure JABBERS counter increments by 1.
//6. Send some oversize frames (>MAX PAYLAOD SIZE and MAXPAYLOADSIZE+1) without FCS error and Read JABBERS register.
//7. Send some non oversize frame (< MAX PAYLAOD SIZE and = MAXPAYLAOD SIZE ) with and without FCS error 
//8. Read JABBERS register 
//9. Configure MAX PAYLOAD SIZE register with other than step 2 value.
//10. Send random  frame (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error)
//11. Read JABBERS register
//12. Send random frames such that read value of JABBERS counter status register rollover from 32 bit value to 33 bit value  and read JABBERS register after each frame.
//13. Send random frames such that read value of JABBERS counter status register reaches to maximum value  
//14. Read JABBERS counter register
//15. Send random frames after JABBERS counter reaches to maximum value.
//16. Read JABBERS counter register to make sure counter does not rollover.
//17. Read all stats counter registers
//Class : eth_vip_jabber_frame_seq 
//This sequence can be used to drive jabber frames from VIP 

`include "eth_stat_jabbers_cnt_sequence.sv"

//class:eth_stat_mcast_ctrl_cnt_sequence
//1. Apply csr reset.
//2. Read MCAST_CTRL_ERR and MCAST_CTRL_OK  registers.
//3. Send one multicast control frame with FCS error and without FCS randomly.
//4. Read MCAST_CTRL_ERR and MCAST_CTRL_OK  counter registers.
//5. Repeat step 3 and step 4 five to ten time to ensure MCAST_CTRL_ERR and MCAST_CTRL_OK counters increment by 1.
//6. Send some multicast control and normal data frames without fcs error and Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
//7. Send some multicast control and normal data frames with fcs error and Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
//8. Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
//9. Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
//10. Send random control frames such that read value of MCAST_CTRL_ERR and MCAST_CTRL_OK  counter status register rollover from 32 bit value to 33 bit value  and read MCAST_CTRL_ERR and MCAST_CTRL_OK  registers after each frame.
//11. Send random frames such that read value of MCAST_CTRL_ERR and MCAST_CTRL_OK  counter status register reaches to maximum value  
//12. Read MCAST_CTRL_ERR and MCAST_CTRL_OK counter register
//13. Send random multicast, unicast and broadcast   frames after MCAST_CTRL_ERR and MCAST_CTRL_OK  counter reaches to maximum value.
//14. Read MCAST_CTRL_ERR and MCAST_CTRL_OK counter register to make sure counter does not rollover.
//15. Read all stats counter registers

`include "eth_stat_mcast_ctrl_cnt_sequence.sv"

//class:eth_stat_ucast_ctrl_cnt_sequence
//1. Apply csr reset.
//2. Read UCAST_CTRL_ERR and UCAST_CTRL_OK  registers.
//3. Send one multicast control frame with FCS error and without FCS randomly.
//4. Read UCAST_CTRL_ERR and UCAST_CTRL_OK  counter registers.
//5. Repeat step 3 and step 4 five to ten time to ensure UCAST_CTRL_ERR and UCAST_CTRL_OK counters increment by 1.
//6. Send some multicast control and normal data frames without fcs error and Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
//7. Send some multicast control and normal data frames with fcs error and Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
//8. Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
//9. Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
//10. Send random control frames such that read value of UCAST_CTRL_ERR and UCAST_CTRL_OK  counter status register rollover from 32 bit value to 33 bit value  and read UCAST_CTRL_ERR and UCAST_CTRL_OK  registers after each frame.
//11. Send random frames such that read value of UCAST_CTRL_ERR and UCAST_CTRL_OK  counter status register reaches to maximum value  
//12. Read UCAST_CTRL_ERR and UCAST_CTRL_OK counter register
//13. Send random multicast, unicast and broadcast   frames after UCAST_CTRL_ERR and UCAST_CTRL_OK  counter reaches to maximum value.
//14. Read UCAST_CTRL_ERR and UCAST_CTRL_OK counter register to make sure counter does not rollover.
//15. Read all stats counter registers

`include "eth_stat_ucast_ctrl_cnt_sequence.sv"

//class:eth_stat_bcast_ctrl_cnt_sequence
//1. Apply csr reset.
//2. Read BCAST_CTRL_ERR and BCAST_CTRL_OK  registers.
//3. Send one multicast control frame with FCS error and without FCS randomly.
//4. Read BCAST_CTRL_ERR and BCAST_CTRL_OK  counter registers.
//5. Repeat step 3 and step 4 five to ten time to ensure BCAST_CTRL_ERR and BCAST_CTRL_OK counters increment by 1.
//6. Send some multicast control and normal data frames without fcs error and Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
//7. Send some multicast control and normal data frames with fcs error and Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
//8. Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
//9. Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
//10. Send random control frames such that read value of BCAST_CTRL_ERR and BCAST_CTRL_OK  counter status register rollover from 32 bit value to 33 bit value  and read BCAST_CTRL_ERR and BCAST_CTRL_OK  registers after each frame.
//11. Send random frames such that read value of BCAST_CTRL_ERR and BCAST_CTRL_OK  counter status register reaches to maximum value  
//12. Read BCAST_CTRL_ERR and BCAST_CTRL_OK counter register
//13. Send random multicast, unicast and broadcast   frames after BCAST_CTRL_ERR and BCAST_CTRL_OK  counter reaches to maximum value.
//14. Read BCAST_CTRL_ERR and BCAST_CTRL_OK counter register to make sure counter does not rollover.
//15. Read all stats counter registers

`include "eth_stat_bcast_ctrl_cnt_sequence.sv"
//
`include "eth_stat_mcastdata_cnt_sequence.sv"
//
`include "eth_stat_bcastdata_cnt_sequence.sv"
//
`include "eth_stat_ucastdata_cnt_sequence.sv"

//Class : eth_stat_shadowcopy_sequence
//1. Apply csr reset.
//2. Read all stats counter registers.
//3. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//4. Read all stats counter registers.
//5. Send random frames such that all stats counts have non reset value.
//6. Read all stats counter register.
//7. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
//8. Read all stats counter registers.
//9. Send random frames such that all stats counts have different value compare to step 5.
//10. Read all stats counter registers.
//11. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//12. Read all stats counter registers.
//13. Send random frames such that all stats counts have non reset value.
//14. Read all stats counter register.
//15. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
//16. Read all stats counter registers.
//17. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//18. Send random frames such that all stats counts have non reset value.
//19. Read all stats counter registers.
//20. Set CNTR_CONFIG bit 0 to clear the stat counter.
//21. Read all stats counter registers. (?) 
//22. Send random frames such that all stats counts have non reset value.
//23. Read all stats counter registers.(?)
//24. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
//25. Read all stats counter registers.(?)
/*
class eth_stat_shadowcopy_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_shadowcopy_sequence)

  int transaction_count;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_stat_shadowcopy_sequence ...", UVM_NONE)
    super.body();
    ////Enable vector scoreboard
    //en_vec_sb();

    ////1. Apply csr reset.
    //`uvm_info("eth_stat_shadowcopy_sequence", "1. Apply csr reset", UVM_NONE)
    //apply_hard_reset(0,0,1,11);
    //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    if (!($value$plusargs("num_frames=%d",transaction_count))) begin
      transaction_count = num_of_frames/6;
    end
    //Ignore expected VIP errors
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    
    
    //Read register to get max_frame_size
    read_max_frame_size();

    //2. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "2. Read all stats counter register", UVM_NONE)
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats();

    //3. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
    `uvm_info("eth_stat_shadowcopy_sequence", "3. Apply Shadow Request", UVM_NONE)
    apply_shadow_request();
    
    #100ns;
    //4. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "4. Read all stats counter register", UVM_NONE)
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats();
    
    //5. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence", "5. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //6. Read all stats counter register .
    `uvm_info("eth_stat_shadowcopy_sequence", "6. Read all stats counter register", UVM_NONE)
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats();

    //7. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
    `uvm_info("eth_stat_shadowcopy_sequence", "7. Clear Shadow Request", UVM_NONE)
    clear_shadow_request();

    #100ns;
    //8. Read all stats counter register .
    `uvm_info("eth_stat_shadowcopy_sequence", "8. Read all stats counter register", UVM_NONE)
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats();

    //9. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence", "9. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //10. Read all stats counter register .
    `uvm_info("eth_stat_shadowcopy_sequence", "10. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //11. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
    `uvm_info("eth_stat_shadowcopy_sequence", "11. Apply Shadow Request", UVM_NONE)
    apply_shadow_request();
    
    #100ns;
    //12. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "12. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();
    
    //13. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence", "13. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //14. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "14. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();
    
    //15. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
    `uvm_info("eth_stat_shadowcopy_sequence", "15. Clear Shadow Request", UVM_NONE)
    clear_shadow_request();

    #100ns;
    //16. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "16. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();
    
    //17. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
    `uvm_info("eth_stat_shadowcopy_sequence", "17. Apply Shadow Request", UVM_NONE)
    apply_shadow_request();
    
    //18. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence", "18. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //19. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "19. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //20. Set CNTR_CONFIG bit 1 to clear the counter. 
    `uvm_info("eth_stat_shadowcopy_sequence", "20. Set CNTR_CONFIG bit 0 to clear the stat counter.", UVM_NONE)
    clear_stat_counters(); 
    #400ns;

    //21. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "21. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //22. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence", "22. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);

    #800ns;
    //23. Read all stats counter register 
    `uvm_info("eth_stat_shadowcopy_sequence", "23. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //24. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
    `uvm_info("eth_stat_shadowcopy_sequence", "24. Clear Shadow Request", UVM_NONE)
    clear_shadow_request();

    #0;
    `uvm_info("eth_stat_shadowcopy_sequence", "24.1. Read all stats counter register", UVM_NONE)
    read_and_compare_stats();

    //25. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
    `uvm_info("eth_stat_shadowcopy_sequence", "25. Send random frames such that all stats counts have non reset value", UVM_NONE)
    send_random_frames(transaction_count);
    #800ns;
    
    //25. Read all stats counter register 
    //`uvm_info("eth_stat_shadowcopy_sequence", "25. Read all stats counter register", UVM_NONE)
    //read_and_compare_stats();

    `uvm_info("body", "ended eth_stat_shadowcopy_sequence ...", UVM_NONE)
  endtask:body

endclass:eth_stat_shadowcopy_sequence
*/

`include "eth_stat_shadowcopy_sequence_part_1.sv"
//
//`include "eth_stat_shadowcopy_sequence_part_2.sv"
//
`include "eth_stat_oversize_cnt_sequence.sv"
//
`include "eth_stat_octetsok_cnt_sequence.sv"

//1. Apply csr reset.
//2. Read CRCERR_OKPKT register.
//3. Send one normal frame (frame size >= 64) with FCS error 
//4. Read CRCERR_OKPKT counter register
//5. Repeat step 3 and step 4 five to ten time to ensure CRCERR_OKPKT counter increments by 1.
//6. Send some frames without FCS error (i.e oversize, normal). 
//7. Read FCSERR register
//8. Send random  frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)
//9. Read FCSERR register
//10. Send random frames such that read value of CRCERR_OKPKT counter status register rollover from 32 bit value to 33 bit value  and read CRCERR_OKPKT register after each frame.
//11. Send random frames such that read value of CRCERR_OKPKT counter status register reaches to maximum value  
//12. Read CRCERR_OKPKT counter register
//13. Send random frames after CRCERR_OKPKT counter reaches to maximum value.
//14. Read CRCERR_OKPKT counter register to make sure counter does not rollover.
//15. Read all stats counter registers
`include "eth_stat_crcerrokpkt_cnt_sequence.sv"

//Class : eth_stat_64B_MAXB_cnt_sequence
//1. Apply csr reset.
//2.Read 64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  register.
//3. Send one frame from each category stats counters start boundary  (i.e.. 63,64,65,128,256,,512,1024,1519 bytes) byte size. 
//4.  Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3.
//5. Send one frame from each category stats counters end boundary  (i.e.. 63,64,127,255,,511,1023,1518 and MAXB bytes) byte size. 
//6.  Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 5.
//7. Send some frames from each category stats counters  byte size boundary , have a frame size random between start and end boundary.
//8. Read  64B,65to127B, 128to255B,256to511B, 512o1023B,1024to1518B,1519toMAXB register.
//9. Send random frames such that read value of  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  counter status register rollover from 32 bit value to 33 bit value 
//10.  read  64B, 5to127B, 128to255B, 256to511B, 512o1023B, 1024to1518B,1519toMAXB  register after each frame.
//11. Send random frames such that read value of  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  counter status register reaches to maximum value  
//12.Read  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB counter register
//13. Send random frames after  64B, 65to127B, 128to255B, 256to511B, 512o1023B,1024to1518B,1519toMAXB  counter reaches to maximum value.
//14. Read  64B,65to127B,128to255B, 256to511B, 512o1023B, 1024to1518B,1519toMAXB counter register to make sure counter does not rollover.
//15. Read all stats counter registers
//
//PS : 
//1 ) Before step 9/11, test may force the counter value near to max value or expected value to avoid large frame transfer.
//2) include normal, undersize ,oversize and control frames with and without FCS error in step 7 and 9
//`include "eth_stat_64B_MAXB_cnt_sequence.sv"

//1. Apply csr reset.
//2. Read PAUSE_ERR and PAUSE  registers.
//3. Send one pause control frame with FCS error or without FCS error randomly. 
//4. Read  PAUSE_ERR and PAUSE  counter registers.
//5. Repeat step 3 and step 4 five to ten time to ensure  PAUSE_ERR and PAUSE counter increments by 1.
//6. Send some  control (pause and PFC ) and normal data frames without fcs error and Read  PAUSE_ERR and PAUSE registers.
//7. Send some  control (pause and PFC ) and normal data frames with fcs error and Read  PAUSE_ERR and PAUSE registers.
//8. Send random control frames (data , pause and PFC frames)with FCS error or without FCS Error randomly.
//9. Read  PAUSE_ERR and PAUSE registers
//10. Send random frames such that read value of  PAUSE_ERR and PAUSE  counter status register rollover from 32 bit value to 33 bit value  and read  PAUSE_ERR and PAUSE  registers after each frame.
//11. Send random frames such that read value of  PAUSE_ERR and PAUSE  counter status register reaches to maximum value  
//12. Read  PAUSE_ERR and PAUSE counter registers.
//13. Send random frames after  PAUSE_ERR and PAUSE  counter reaches to maximum value.
//14. Read  PAUSE_ERR and PAUSE counter register to make sure counter does not rollover.
//15. Read all stats counter registers

`include "eth_stat_pause_cnt_sequence.sv"

//Send XOFF frame followed closely by XON frame ,during an AM cycle.(FB 596537)
//1.VIP_rx side send combination of XOFF and XON frame randomaly(total frame 500).
//2.VIP_tc side send a normal data frame.

//`include "eth_pause_xon_frame_during_am_fb596537.sv"
//
//`include "parity_err_seq_fb489674.sv"
//
`include "eth_tx_error_test_sequence.sv"
//
`include "eth_short_frame_test_sequence.sv"
//
//`include "eth_read_in_between_test_sequence.sv"
//
`include "eth_length_error_test_sequence.sv"
//
//`include "eth_stats_off_sequence.sv"
//
//`include "eth_vip_control_frame_coverage_sequence.sv"
//
`include "eth_dropped_frame_stat_test_sequence.sv"
//
`include "eth_malformed_stat_test_sequence.sv"
//
////muralasx : Edited
`include "eth_error_in_between_frame_test_sequence.sv"
//
////eth_stat_counter_overflow will force LSB stats registers and check LSB registers gets overflow and RTL counts from MSB registers
//`include "eth_stat_counter_overflow.sv"
//
//`include "eth_adapter_drop_frames_seq_part_1.sv"
//
//`include "eth_adapter_drop_frames_seq_part_2.sv"
//
//
////Shabbir: This sequence is added to reproduce the issue of FB 596537
//`include "eth_stat_reset_sequence_part_1_fb_596537.sv"
//
//`include "eth_adapter_drop_frames_seq_debug.sv"
//
`include "eth_adapter_drop_frames_seq_debug_cov.sv"
//
`include "eth_runt_frames_seq.sv"
//
`include "macstats_tx_coverage_sequence.sv"

