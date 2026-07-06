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


class pcs_dsk_limit_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_dsk_limit_sequence)


  class local_seq_var extends seq_var; 
   
    constraint num_lanes_c {
      num_lanes inside {[1:19]};
    }
    constraint skew_0_c {
       skew_0 == 13;
     }

    constraint skew_1_c {
       skew_1 == 13;
     }
    constraint skew_2_c {
       skew_2 == 13;
     }
    constraint skew_3_c {
       skew_3 == 13;
     }
    constraint skew_4_c {
       skew_4 == 13;
     }
    constraint skew_5_c {
       skew_5 == 13;
     }
    constraint skew_6_c {
       skew_6 == 13;
     }
    constraint skew_7_c {
       skew_7 == 13;
     }
    constraint skew_8_c {
       skew_8 == 13;
     }
    constraint skew_9_c {
       skew_9 == 13;
     }
    constraint skew_10_c {
       skew_10 == 13;
     }
    constraint skew_11_c {
       skew_11 == 13;
     }
    constraint skew_12_c {
       skew_12 == 13;
     }
    constraint skew_13_c {
       skew_13 == 13;
     }
    constraint skew_14_c {
       skew_14 == 13;
     }
    constraint skew_15_c {
       skew_15 == 13;
     }
    constraint skew_16_c {
       skew_16 == 13;
     }
    constraint skew_17_c {
       skew_17 == 13;
     }
    constraint skew_18_c {
       skew_18 == 13;
     }
    constraint skew_19_c {
       skew_19 == 13;
     }

  endclass

   local_seq_var m_seq_var;

  function new(string name = "pcs_dsk_limit_sequence");
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
      // choose lane to add skew (max allowable:Table 80–4—Summary of Skew constraints 
      // At PCS receive 180 ≈ 1856 ≈ 928 See 82.2.12)
      // 928 UI/66  = 14.06 (per virtual lane)
      // check for loss of lock (should lose am lock)
      // wait for recovery
      // Fire Data Packets from VIP 
      //-------------------------------------------------------------------

    $display("start pcs dsk limit sequence");
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

   p_sequencer.env.tb_cfg.skew_test = 1;
   `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.tb_cfg.skew_test), UVM_LOW)
     rx_crc_pass=$urandom;
   //pcs_mac register not accessible in pcs_only mode   
   //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   $display("DONE!!! WRITING TO REG");
 //  tx_seq.start(p_sequencer.tx_seqr);
      //Since skew will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

      //Disabling Avalon ST assertions for missing SOP/EOP (since spurious decodes are possible when the descrambler in uninitialized during deskew 
      p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
      p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);

      //randomize num of lanes, skew on each lane
      if (!m_seq_var.randomize()) begin
        `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
      end
       
      `uvm_info(get_type_name(), $sformatf("num_lanes :%d, lane_0 :%d, lane_1 :%d, lane_2 :%d, lane_3 :%d, lane_4 :%d, lane_5 :%d, lane_6 :%d, lane_7 :%d, lane_8 :%d, lane_9 :%d, lane_10 :%d, lane_11 :%d, lane_12 :%d, lane_13 :%d, lane_14 :%d, lane_15 :%d, lane_16 :%d, lane_17 :%d, lane_18 :%d, lane19 :%d, num_invalid_am :%d", m_seq_var.num_lanes, m_seq_var.lane_0, m_seq_var.lane_1, m_seq_var.lane_2, m_seq_var.lane_3, m_seq_var.lane_4, m_seq_var.lane_5, m_seq_var.lane_6, m_seq_var.lane_7, m_seq_var.lane_8, m_seq_var.lane_9, m_seq_var.lane_10, m_seq_var.lane_11, m_seq_var.lane_12, m_seq_var.lane_13, m_seq_var.lane_14, m_seq_var.lane_15, m_seq_var.lane_16, m_seq_var.lane_17, m_seq_var.lane_18, m_seq_var.lane_19, m_seq_var.num_invalid_am ), UVM_LOW)
      `uvm_info(get_type_name(), $sformatf("num_lanes :%d, skew_0 :%d, skew_1 :%d, skew_2 :%d, skew_3 :%d, skew_4 :%d, skew_5 :%d, skew_6 :%d, skew_7 :%d, skew_8 :%d, skew_9 :%d, skew_10 :%d, skew_11 :%d, skew_12 :%d, skew_13 :%d, skew_14 :%d, skew_15 :%d, skew_16 :%d, skew_17 :%d, skew_18 :%d, lane19 :%d, num_invalid_am :%d", m_seq_var.num_lanes, m_seq_var.skew_0, m_seq_var.skew_1, m_seq_var.skew_2, m_seq_var.skew_3, m_seq_var.skew_4, m_seq_var.skew_5, m_seq_var.skew_6, m_seq_var.skew_7, m_seq_var.skew_8, m_seq_var.skew_9, m_seq_var.skew_10, m_seq_var.skew_11, m_seq_var.skew_12, m_seq_var.skew_13, m_seq_var.skew_14, m_seq_var.skew_15, m_seq_var.skew_16, m_seq_var.skew_17, m_seq_var.skew_18, m_seq_var.skew_19, m_seq_var.num_invalid_am ), UVM_LOW)

      //insert skew
      insert_skew(m_seq_var);
     
       fork 
         begin
           //check to see if lock lsot
           am_lock_lost = 0;
           //wait ((m_env.spy_vif.o_n_hip_ssr[1] == 1'b0) || (m_env.spy_vif.o_n_hip_ssr[0] == 1'b0) || (m_env.spy_vif.o_n_hip_ssr[2] == 1'b0));
           wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
           link_down=1;
           //if(m_env.spy_vif.o_n_hip_ssr[1] == 1'b0) begin
           //  am_lock_lost = 1;
           //end
           ////Not expected to lose block lock
           //if(m_env.spy_vif.o_n_hip_ssr[0] == 1'b0) begin
           //  error_cnt++;
           //end 
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
        `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after skew inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
       end

       //if((timeout_cntr >= 50) && (am_lock_lost == 0)) begin
       // `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR AM LOCK LOSS after skew inserted lock_lost :%d, timeout_cntr :%d", lock_lost, timeout_cntr))
       //end
       //if((am_lock_lost == 1) && (error_cnt == 0))  begin
       //  `uvm_info(get_type_name(), $sformatf("AM LOCK LOST AS EXPECTED am_lock_lost :%d", am_lock_lost), UVM_LOW)
       //end
       //else if((am_lock_lost == 1) && (error_cnt != 0))  begin
       //  `uvm_error(get_type_name(), $sformatf("AM LOCK LOST AS EXPECTED am_lock_lost :%d, BLOCK LOCK LOST UNEXPECTEDLY : error_cnt :%d", am_lock_lost, error_cnt))
       //end

       //Read any status registers FIXME RR
       //

//       m_usr_urm.lanes_deskewed.read(status, lanes_deskewed_rd_data, UVM_BACKDOOR); 
//       `uvm_info(get_type_name(), $sformatf("lanes_deskewed_rd_data:%h ", lanes_deskewed_rd_data), UVM_LOW)
//
//       if(lanes_deskewed_rd_data[0] === 0) begin
//         `uvm_info(get_type_name(), $sformatf("lanes_deskewed_rd_data:%h reflects loss as expected ", lanes_deskewed_rd_data), UVM_LOW)
//       end
//       else begin
//         `uvm_error(get_type_name(), $sformatf("lanes_deskewed_rd_data:%h  does not reflect loss as expected ", lanes_deskewed_rd_data))
//       end
//
//       //need delay before read 
//      `ifndef CRETE2E_EHIP_IPDV
//        wait_clock("i_n_aib_hr_clk[0]", 2);
//       `else
//        wait_clock("h2a_ch0_hip_aib_clk",  2);
//       `endif
//       m_usr_urm.am_lock.read(status, am_lock_rd_data, UVM_FRONTDOOR); 
//       `uvm_info(get_type_name(), $sformatf("am_lock_rd_data:%h ", am_lock_rd_data), UVM_LOW)
//
//       if(am_lock_rd_data[0] === 0) begin
//         `uvm_info(get_type_name(), $sformatf("am_lock_rd_data:%h reflects loss as expected ", am_lock_rd_data), UVM_LOW)
//       end
//       else begin
//         `uvm_error(get_type_name(), $sformatf("am_lock_rd_data:%h  does not reflect loss as expected ", am_lock_rd_data))
//       end
//
//
//       m_usr_urm.phy_rxpcs_status.read(status, phy_rxpcs_status_rd_data, UVM_FRONTDOOR); 
//       `uvm_info(get_type_name(), $sformatf("phy_rxpcs_status_rd_data:%h ", phy_rxpcs_status_rd_data), UVM_LOW)
//
//       if(phy_rxpcs_status_rd_data[0] === 0) begin
//         `uvm_info(get_type_name(), $sformatf("phy_rxpcs_status_rd_data:%h reflects loss as expected ", phy_rxpcs_status_rd_data), UVM_LOW)
//       end
//       else begin
//         `uvm_error(get_type_name(), $sformatf("phy_rxpcs_status_rd_data:%h  does not reflect loss as expected ", phy_rxpcs_status_rd_data))
//       end

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
        `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER SKEW link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
       end
       if(link_up == 1) begin
         `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
       end

//       //need delay before read 
//      `ifndef CRETE2E_EHIP_IPDV
//        wait_clock("i_n_aib_hr_clk[0]", 2);
//       `else
//        wait_clock("h2a_ch0_hip_aib_clk",  2);
//       `endif
//
//       m_usr_urm.am_lock.read(status, am_lock_rd_data, UVM_FRONTDOOR); 
//       `uvm_info(get_type_name(), $sformatf("am_lock_rd_data:%h ", am_lock_rd_data), UVM_LOW)
//
//       if(am_lock_rd_data[0] === 1) begin
//         `uvm_info(get_type_name(), $sformatf("am_lock_rd_data:%h reflects alignment as expected ", am_lock_rd_data), UVM_LOW)
//       end
//       else begin
//         `uvm_error(get_type_name(), $sformatf("am_lock_rd_data:%h  does not reflect alignment as expected ", am_lock_rd_data))
//       end
//
//       //This status will be reflected only is read happens exxactly as deskew
//       //changes
//       //m_usr_urm.lanes_deskewed.read(status, lanes_deskewed_rd_data, UVM_BACKDOOR); 
//       //`uvm_info(get_type_name(), $sformatf("lanes_deskewed_rd_data:%h ", lanes_deskewed_rd_data), UVM_LOW)
//
//       //if(lanes_deskewed_rd_data[0] === 1) begin
//       //  `uvm_info(get_type_name(), $sformatf("lanes_deskewed_rd_data:%h reflects deskew as expected ", lanes_deskewed_rd_data), UVM_LOW)
//       //end
//       //else begin
//       //  `uvm_error(get_type_name(), $sformatf("lanes_deskewed_rd_data:%h  does not reflect deskew as expected ", lanes_deskewed_rd_data))
//       //end
//
//       m_usr_urm.phy_rxpcs_status.read(status, phy_rxpcs_status_rd_data, UVM_FRONTDOOR); 
//       `uvm_info(get_type_name(), $sformatf("phy_rxpcs_status_rd_data:%h ", phy_rxpcs_status_rd_data), UVM_LOW)
//
//       if(phy_rxpcs_status_rd_data[0] === 1) begin
//         `uvm_info(get_type_name(), $sformatf("phy_rxpcs_status_rd_data:%h reflects alignment as expected ", phy_rxpcs_status_rd_data), UVM_LOW)
//       end
//       else begin
//         `uvm_error(get_type_name(), $sformatf("phy_rxpcs_status_rd_data:%h  does not reflect alignment as expected ", phy_rxpcs_status_rd_data))
//       end

       //enable all rule checks after lock regained
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

       //wait before sending frames
       for(int i=0;i<2;i++) begin
         @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
       end
       
       //Enabling Avalon ST assertions for missing SOP/EOP after deskew successful 
       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);

       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
       `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)


      `uvm_info(get_type_name(), "PCS RX VIP DSK LIMIT SEQ END", UVM_LOW)
  endtask
endclass
