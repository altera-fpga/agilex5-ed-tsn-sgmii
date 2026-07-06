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


class pcs_am_lock_negchk2_sequence extends pcs_base_sequence;
  bit rx_crc_pass;
  bit bip_present;
  `uvm_object_utils(pcs_am_lock_negchk2_sequence)

  class local_seq_var extends seq_var; 

    constraint num_invalid_am_c {
      num_invalid_am dist { 3:= 90, 1:=10, 2:=10} ;
    }

  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_am_lock_negchk2_sequence");
    super.new(name);
    m_seq_var = new(); 
   `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
   `endif
  endfunction:new

  virtual task body();
    bit am_lock_lost;
    integer timeout_cntr=0;
    bit link_down;

    $display("start pcs_am_lock_negchk2_sequence");

    rx_crc_pass=$urandom;
   
    if(  ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside { RSFECKR, RSFECKP})) ||
        ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) ) bip_present = 1;
    //pcs_mac register not accessible in pcs_only mode   
    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
    $display("DONE!!! WRITING TO REG");

    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane16.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_order_within_transcode_block.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::NOTE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::NOTE);
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G ) begin
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_up_align_marker.set_default_fail_effect(svt_err_check_stats::NOTE);
    end
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    fork    
    //poll for loss of lock
      forever begin
        @(posedge p_sequencer.env.spy_if.clk);
        if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0) begin
          `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
        end
      end
    join_none

    if (!m_seq_var.randomize()) begin
      `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
    end

    //insert invalid bip 
     `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
     insert_invalid_bip(m_seq_var.num_invalid_am);
     `uvm_info(get_type_name(), $sformatf("inserted invalid_bip count =%d, num_lanes:%d",m_seq_var.num_invalid_am , m_seq_var.num_lanes), UVM_LOW)
   
    //Wait for few cycles to make sure link lock stays 
    if (bip_present) begin
      repeat(10) begin 
        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
        else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
      end
    end else begin
       @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);      
    end

    fork 

      //send frames
      begin
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1000);
        `uvm_info(get_type_name(), "Sent 1000 frames", UVM_LOW)
      end
 
      //if (bip_present) begin // 200,400G: BIP doesnt exists , but will go corrupt AM symbols to make sure no loss of lock
      //corrupt ams (alternate good & bad) 
      begin

        for(int s=0; s<5; s++) begin
          if(s%2 == 1) begin
            if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) 
               @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
            else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
            `uvm_info(get_type_name(), "Skipping sending invalid AMs for this iteration", UVM_LOW)
          end
          else begin
            if (!m_seq_var.randomize()) begin
              `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
            end
              `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
              insert_invalid_bip(m_seq_var.num_invalid_am);
              `uvm_info(get_type_name(), $sformatf("inserted invalid_bip count =%d, num_lanes:%d",m_seq_var.num_invalid_am , m_seq_var.num_lanes), UVM_LOW)
          end //s
        end //num_iter
      end //invalid am insert thread
      //end
    join

    //Wait for few cycles to make sure link lock stays 
    if (bip_present) begin
      repeat(10) begin 
        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
        else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
      end
    end else begin
       @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);      
    end


      `uvm_info(get_type_name(), "PCS AM LOCK NEGCHK2 SEQ END", UVM_LOW)
  endtask
endclass
