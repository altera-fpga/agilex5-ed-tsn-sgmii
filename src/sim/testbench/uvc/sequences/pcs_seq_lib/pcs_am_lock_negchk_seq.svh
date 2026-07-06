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


class pcs_am_lock_negchk_sequence extends pcs_base_sequence;
  bit rx_crc_pass;
  bit bip_present;
  `uvm_object_utils(pcs_am_lock_negchk_sequence)

  class local_seq_var extends seq_var; 

    constraint num_invalid_am_c {
      num_invalid_am dist { 3:= 90, 1:=10, 2:=10} ;
    }
  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_am_lock_negchk_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
     bit am_lock_lost;
     integer timeout_cntr=0;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_down;
     int num_iter = 25;

    $display("start pcs_am_lock_negchk_sequence");
 
    rx_crc_pass=$urandom;
   
    if(  ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside { RSFECKR, RSFECKP})) ||
        ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) ) bip_present = 1;
 
   //pcs_mac register not accessible in pcs_only mode   
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   $display("DONE!!! WRITING TO REG");

    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::NOTE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xlsbi_invalid_align.set_default_fail_effect(svt_err_check_stats::NOTE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_order_within_transcode_block.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane16.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_tbd.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

   fork    
    //poll for loss of lock
    if (bip_present) begin
      forever begin
        @(posedge p_sequencer.env.spy_if.clk);
        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC)) begin
          if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0 ) begin
            `uvm_error(get_type_name(), $sformatf("25G unexpected link down, rx_pcs_ready = :%d   rx_am_lock = %0d",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_am_lock))
            `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
          end
        end
        else begin
          if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0 || p_sequencer.env.spy_if.rx_am_lock == 1'b0) begin
            `uvm_error(get_type_name(), $sformatf("unexpected link down, rx_pcs_ready = :%d   rx_am_lock = %0d",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_am_lock))
            `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
          end
        end
      end
    end
    join_none

    m_seq_var.speed = p_sequencer.env.dyn_rcfg_obj_inst.speed;
    if (!m_seq_var.randomize()) begin
      `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
    end
     
    `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)

    //insert invalid am
    //send 3 consecutive invalid am
    if (bip_present) begin
      for(int i=0;i<m_seq_var.num_invalid_am;i++) begin
        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)  ) begin
           @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
            insert_invalid_am_200_400();
          end
        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) begin
          @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
          insert_invalid_am(m_seq_var);
        end
        if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC)) begin
           @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
           insert_invalid_am_25();
        end
        `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d, num_lanes:%d", i, m_seq_var.num_lanes), UVM_LOW)
      end
    
     fork 
       begin
         //check to see if lock lsot
         am_lock_lost = 0;
         wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
         link_down=1;
       end
       begin
         //timeout check
         while(link_down== 0) begin
           if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G))
           @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
           else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
           `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr), UVM_LOW)
           timeout_cntr++;
           if(timeout_cntr == 50) begin
             break;
           end
         end
       end
     join_any


     `uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
     if(link_down == 1) begin
      `uvm_error(get_type_name(), $sformatf("UNEXPECTED LOSS OF LOCK after 3 invalid ams inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
     end
     else if(link_down == 0) begin
       `uvm_info(get_type_name(), $sformatf("NO LOSS OF LOCK AS EXPECTED am_lock_lost :%d", link_down), UVM_LOW)
     end

     //wait for 1 good am after 3 bad from previous loop
     if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G))
     @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
     else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
     end

     fork 

       //send frames
       begin
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1500);
         `uvm_info(get_type_name(), "Sent 1000 frames", UVM_LOW)
         p_sequencer.env.wait_client_rx_frames_done(.exp_num(1500),.timeout_time(100us));
       end
 
       //corrupt ams (alternate good & bad) 
       if (bip_present) begin

         for(int s=0; s<num_iter; s++) begin
           if(s%2 == 1) begin
             if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G))
             @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
             else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
             `uvm_info(get_type_name(), "Skipping sending invalid AMs for this iteration", UVM_LOW)
           end
           else begin
             for(int i=0; i<m_seq_var.num_invalid_am ; i++) begin
               if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)  ) begin
                  @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
                   insert_invalid_am_200_400();
                 end
               if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) begin
                 @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
                 insert_invalid_am(m_seq_var);
                 `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d, num_lanes:%d", i, m_seq_var.num_lanes), UVM_LOW)
               end
               if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC)) begin
                  @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
                  insert_invalid_am_25();
               end
               `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d, num_lanes:%d, num_invalid_am:%d", i, m_seq_var.num_lanes, m_seq_var.num_invalid_am), UVM_LOW)
             end //num_invalid_am
           end //s
         end //num_iter
       end //invalid am insert thread
     join


      `uvm_info(get_type_name(), "PCS AM LOCK NEGCHK SEQ END", UVM_LOW)
  endtask
endclass
