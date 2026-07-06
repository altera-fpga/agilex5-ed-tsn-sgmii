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


class pcs_bitslip_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_bitslip_sequence)


  class local_seq_var extends seq_var; 
   
    constraint num_p_lanes_c {
      num_p_lanes inside {[1:3]};
      //num_p_lanes  == 1;
    }

/*
    constraint plane_0_c {
      plane_0 == 0;
    }
    constraint serial_skew_0_c {
       //serial_skew_0 == 726; //726= 11 66b blocks which is supported works
       //serial_skew_0 == 824; //SP6 works
       serial_skew_0 == 858; //13 66b blocks
     }

    constraint serial_skew_1_c {
       //serial_skew_1 == 726;
       //serial_skew_1 == 824;
       serial_skew_1 == 858;
     }

    constraint serial_skew_2_c {
       //serial_skew_2 == 726;
       //serial_skew_2 == 824;
       serial_skew_2 == 858;
     }

    constraint serial_skew_3_c {
       //serial_skew_3 == 726;
       //serial_skew_3 == 824;
       serial_skew_3 == 858;
     }
*/
  endclass

   local_seq_var m_seq_var;

  function new(string name = "pcs_bitslip_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

   function void pre_randomize; 
       super.pre_randomize(); 
       //if (p_sequencer.env.dyn_rcfg_obj_inst.pcs_40g_mode) begin
       //   `uvm_info(get_type_name(), $sformatf("Setting pcs_40g_en based on pcs_40g_mode config :%d", p_sequencer.env.dyn_rcfg_obj_inst.pcs_40g_mode), UVM_LOW)
       //   m_seq_var.pcs_40g_en = 1;
       //end
   endfunction

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
     int loop_cnt=5;
      //-------------------------------------------------------------------
      // choose lane to add skew for bit slip
      // verify that lock is attained for all possible bitslip position (needs
      // assertions in DUT to confirm this sequence has covered all bitslip
      // ranges
      // send frames 
      //-------------------------------------------------------------------

    $display("start pcs dsk limit sequence");
    // apply_hard_reset(0,0,1,11);
    // fork
    //   //dut link up
    //   begin
    //     p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    //   end
    // join

   p_sequencer.env.dyn_rcfg_obj_inst.skew_test = 1;
   `uvm_info(get_type_name(), $sformatf("Setting skew_test in config :%d", p_sequencer.env.dyn_rcfg_obj_inst.skew_test), UVM_LOW)

    rx_crc_pass=$urandom; 
   //pcs_mac register not accessible in pcs_only mode   
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   $display("DONE!!! WRITING TO REG");

   for(int i=0;i<loop_cnt;i++) begin
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
      //if (!m_seq_var.randomize()) begin
      if (!m_seq_var.randomize() ) begin
        `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
      end
       
      `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)

      if(i == 0) begin
        wait(p_sequencer.env.sideband_if.tx_lane_stable == 1);
        #1us;
        `uvm_info(get_type_name(), $sformatf("before inserting serial skew:%d", p_sequencer.env.dyn_rcfg_obj_inst.skew_test), UVM_LOW)

        //set lane_reversal: move to outside loop_cnt when loop_cnt increased FIXME RR
        set_lane_reversal(m_seq_var);
      end

      insert_serial_skew(m_seq_var);
     
      link_down=0;
      link_up=0;

      fork 
        begin
          wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
          link_down=1;
        end
        begin
          //timeout check
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


       //am lock should have reassert now
       fork 
         begin
           am_lock = 0;
           timeout_cntr = 0;
           //wait ((m_env.spy_vif.o_n_hip_ssr[1] == 1'b1) && (m_env.spy_vif.o_n_hip_ssr[2] == 1'b1));
           p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
           link_up = 1;
         end
         begin
           while(link_up == 0) begin
             #2ns;
             timeout_cntr++;
             //if(timeout_cntr == 60000) begin
             if(timeout_cntr == 120000) begin
               break;
             end
           end
         end
       join_any

       //if((timeout_cntr >= 60000) && (link_up== 0)) begin
       if((timeout_cntr >= 120000) && (link_up== 0)) begin
        `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
       end
       if(link_up == 1) begin
         `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
       end


       //enable all rule checks after lock regained
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

       //wait before sending frames
       for(int i=0;i<1;i++) begin
         @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
       end
       
       //Enabling Avalon ST assertions for missing SOP/EOP after deskew successful 
       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);

       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
       `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)
       #10us;
    end

      `uvm_info(get_type_name(), "PCS BITSLIP SEQ END", UVM_LOW)
  endtask
endclass
