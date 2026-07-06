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


class pcs_duplicate_am_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_duplicate_am_sequence)

  class local_seq_var extends seq_var; 

   //num_lanes: 1, 4 or more
    constraint num_lanes_c {
      num_lanes == 1; 
    }

    constraint lane_0_c {
      lane_0 inside {[0:18]};
    }
  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_duplicate_am_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
     int num_frames;
     bit link_lost;
     bit am_lock_lost;
     bit am_lock;
     bit lock_lost;
     integer timeout_cntr=0;
     int error_cnt=0;
     uvm_status_e status;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_down;
     bit link_up;

     //-------------------------------------------------------------------
     //wait for linkup
     //choose lanes/lane to introduce duplicate am
     // For all above cases, DUT should lose lock (loses deskew, and eventually pcs_ready) 
     //send good ams to regain lock
     //send frames

    `uvm_info(get_type_name(), "PCS DUPLICATE AM  SEQ BEGIN", UVM_LOW)
    // apply_hard_reset(0,0,1,11);
    // fork
    //   //dut link up
    //   begin
    //     p_sequencer.env.wait_rx_pcs_ready();
    //   end
    //   //vip link up(FIXME RR)
    //   begin
    //   end
    // join

     rx_crc_pass=$urandom; 
   //pcs_mac register not accessible in pcs_only mode   
   //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   `uvm_info(get_type_name(), "DONE!!! WRITING TO REG", UVM_LOW)


//      //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
//      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
//      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
//      //bit 0: (set t0 0 to disable checker on tx side)
//      //bit 1: (set t0 0 to disable checker on rx side)
//      //bit 2: (set t0 0 to disable checker on checker arbiter)
//      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
//      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

       
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::NOTE);

      //insert invalid am
        for(int i=0;i<4;i++) begin 
          //randomize num of lanes, invalid am on each lane
          if (!m_seq_var.randomize()) begin
            `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
          end
          `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
          @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
          insert_duplicate_am(m_seq_var);
          `uvm_info(get_type_name(), $sformatf("inserted duplicate_am i:%d, num_lanes:%d", i, m_seq_var.num_lanes), UVM_LOW)
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
           //while(am_lock_lost == 0) begin
           while(link_down== 0) begin
             @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
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
         `uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED am_lock_lost :%d", link_down), UVM_LOW)
       end
       else if((timeout_cntr >= 50) && (link_down == 0)) begin
        `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after invalid ams inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
       end


       //am lock should have reassert now
       fork 
         begin
           am_lock = 0;
           timeout_cntr = 0;
           //wait ((m_env.spy_vif.o_n_hip_ssr[1] == 1'b1) && (m_env.spy_vif.o_n_hip_ssr[2] == 1'b1));
           p_sequencer.env.wait_rx_pcs_ready();
           link_up = 1;
         end
         begin
           while(link_up == 0) begin
             #2ns;
             timeout_cntr++;
             //if(timeout_cntr == 600) begin
             //if(timeout_cntr == 4000) begin
             //if(timeout_cntr == 10000) begin
             //if(timeout_cntr == 20000) begin
             if(timeout_cntr == 60000) begin
               break;
             end
           end
         end
       join_any

       //am lock did not happen within timeout interval
       //if((timeout_cntr >= 600) && (link_up== 0)) begin
       //if((timeout_cntr >= 4000) && (link_up== 0)) begin
       //if((timeout_cntr >= 10000) && (link_up== 0)) begin
       //if((timeout_cntr >= 20000) && (link_up== 0)) begin
       if((timeout_cntr >= 60000) && (link_up== 0)) begin
        `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER BAD AMs link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
       end
       if(link_up == 1) begin
         `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
       end


  //     //enable all rule checks after lock regained
  //     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
  //     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::ERROR);

       //wait before sending frames
       for(int i=0;i<1;i++) begin
         @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
       end
       

       //send frames
       //m_env.m_snps_phy_bfm.do_drv_cfg(`ETH_MODE_MAC_INTER_FRAME_GAP,12);
       //for(int z =0 ; z < 100; z++)
       //begin
       //	m_env.m_snps_phy_bfm.do_drv_cmd(`ETH_MAC_DATA_FRAME,`ETH_MAC1_INDVL_ADDRESS,64+z);
       //end
       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
       `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)


      `uvm_info(get_type_name(), "PCS DUPLICATE AM  SEQ END", UVM_LOW)
  endtask
endclass
