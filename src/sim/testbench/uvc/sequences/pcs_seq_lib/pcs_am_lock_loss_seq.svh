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


class pcs_am_lock_loss_sequence extends pcs_base_sequence;
  bit rx_crc_pass;
  `uvm_object_utils(pcs_am_lock_loss_sequence)

  seq_var m_seq_var;

  function new(string name = "pcs_am_lock_loss_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
     bit am_lock_lost;
     bit am_lock;
     integer timeout_cntr=0;
     int error_cnt=0;
     bit link_down;
     bit link_up;
     int loop_cnt=2;
     bit am_mode;

     uvm_reg_data_t lanes_deskewed_rd_data;

    `uvm_info(get_type_name(), "PCS RX VIP AM LOCK SEQ BEGIN", UVM_LOW)

//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
     //Read word lock status register to reflect lock
     //check_csr_status(1);
     
    rx_crc_pass=$urandom; 
   if(  ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside { RSFECKR, RSFECKP})) ||
        ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G && p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) ||
        ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) ) am_mode = 1;

   //pcs_mac register not accessible in pcs_only mode   
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   `uvm_info(get_type_name(), "DONE!!! WRITING TO REG", UVM_LOW)

   `ifdef ENABLE_ETH_VIP
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_tbd.set_default_fail_effect(svt_err_check_stats::NOTE);
   `endif

   //tx traffic should be uninterrupted
   fork
   begin
     if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}))
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,800);  
     else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN)
         send_eth_frame(DATA_FRAME,OTN_MODE,800);  
     else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE)
         send_eth_frame(DATA_FRAME,FLEXE_MODE,800);
      p_sequencer.env.wait_tx_frames_received(.exp_num(800),.timeout_time(700us)); 
   end
 

  if(am_mode) begin
   begin
     for(int i=0;i< loop_cnt;i++) begin

        link_down = 0;
        link_up = 0;
        timeout_cntr = 0;

        //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
        //bit 0: (set t0 0 to disable checker on tx side)
        //bit 1: (set t0 0 to disable checker on rx side)
        //bit 2: (set t0 0 to disable checker on checker arbiter)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

	   if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
           p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
           p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
	   end
    
       `ifdef ENABLE_ETH_VIP
          p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_tbd.set_default_fail_effect(svt_err_check_stats::NOTE);
       `endif
	    
        m_seq_var.speed = p_sequencer.env.dyn_rcfg_obj_inst.speed; 

        if (!m_seq_var.randomize()) begin
          `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
        end
        `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
        
        //Send 5 bad ams
        for(int i=0; i<5; i++) begin
          if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)  ) begin
             @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
              insert_invalid_am_200_400();
            end
          if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G)) begin
            @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
            insert_invalid_am(m_seq_var);
            `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d, num_lanes:%d", i, m_seq_var.num_lanes), UVM_LOW)
          end
          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) begin
            @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
            insert_invalid_am_50(m_seq_var);
            `uvm_info(get_type_name(), $sformatf("inserted invalid_am for 50G i:%d, num_lanes:%d", i, m_seq_var.num_lanes), UVM_LOW)
          end
          if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside { RSFECKR, RSFECKP})) begin
             @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
             insert_invalid_am_25();
          end
        end
       
         fork 
           begin
             //check to see if lock lost
             am_lock_lost = 0;
             wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0);
             //am_lock gets deasserted after rxpcs_rdy, so check for am_lock
             //first and confirm that rxpcs_rdy gets deasserted as well
             `uvm_info(get_type_name(), $sformatf("waitinfg rx_am_lock"), UVM_LOW)
             wait(p_sequencer.env.spy_if.rx_am_lock == 1'b0);
             link_down=1;
	         repeat(40) @(posedge p_sequencer.env.spy_if.clk);
             //Check that am_lock is deasserted
             if ( (p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0) )  begin
               `uvm_info(get_type_name(), $sformatf("rx_pcs_ready low as expected "), UVM_LOW)
             end
             else begin
               `uvm_error(get_type_name(), $sformatf("rx_pcs_ready:%d expected to go low ", p_sequencer.env.sideband_if.rx_pcs_ready))
             end

             //Check that blk_lock is not deasserted in non FEC mode and vice versa in FEC mode
             if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside { RSFECKR, RSFECKP, LLFEC}) begin// Block_lock goes low with AM corruption in FEC HSD 16011365660
               if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b0) )  begin
                 `uvm_info(get_type_name(), $sformatf("block_lock low as expected "), UVM_LOW)
               end
               else begin
                 `uvm_error(get_type_name(), $sformatf("block_lock :%d not expected to remain high in FEC mode ", p_sequencer.env.spy_if.rx_block_lock))
               end
             end
             else begin
               if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b1) )  begin
                 `uvm_info(get_type_name(), $sformatf("block_lock high as expected "), UVM_LOW)
               end
               else begin
                 `uvm_error(get_type_name(), $sformatf("block_lock :%d not expected to go low in Non fec mode", p_sequencer.env.spy_if.rx_block_lock))
               end
             end
             if ( (p_sequencer.env.spy_if.rx_am_lock == 1'b0) )  begin
               `uvm_info(get_type_name(), $sformatf("am_lock low as expected "), UVM_LOW)
             end
             else begin
               `uvm_error(get_type_name(), $sformatf("block_lock :%d expected to go low ", p_sequencer.env.spy_if.rx_am_lock))
             end
           end
           begin
             //timeout check
             while(link_down== 0) begin
               if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
               else if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
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
           `uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED am_lock_lost :%d", link_down), UVM_LOW)
         end
         else if((timeout_cntr >= 50) && (link_down == 0)) begin
          `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after invalid ams inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
         end

//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
        //Read rxpcs_fully_aligned status register to reflect loss
        //check_csr_status(0);

         //am lock should have reassert now
         fork 
           begin
             am_lock = 0;
             timeout_cntr = 0;
             p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1),.disable_vip_err(1));
             link_up = 1;
           end
           begin
             while(link_up == 0) begin
               #2ns;
               timeout_cntr++;
                if(timeout_cntr == 18000000) begin
                 break;
               end
             end
           end
         join_any

         if((timeout_cntr >= 18000000) && (link_up== 0)) begin
          `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER BAD AMs link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
         end
         if(link_up == 1) begin
           `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
         end

         //Check that am_lock is asserted
         if ( (p_sequencer.env.sideband_if.rx_pcs_ready == 1'b1) )  begin
         //if ( (p_sequencer.env.spy_if.rx_am_lock == 1'b1) )  begin
           `uvm_info(get_type_name(), $sformatf("rx_am_lock high as expected "), UVM_LOW)
         end
         else begin
           `uvm_error(get_type_name(), $sformatf("rx_am_lock:%d expected to go high", p_sequencer.env.spy_if.rx_am_lock))
         end
	 
	     repeat(30) @(posedge p_sequencer.env.spy_if.clk); //Wait till locks are asserted

         //Check that blk_lock is asserted
         if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b1) )  begin
           `uvm_info(get_type_name(), $sformatf("block_lock high as expected "), UVM_LOW)
         end
         else begin
           `uvm_error(get_type_name(), $sformatf("block_lock :%d not expected to go low ", p_sequencer.env.spy_if.rx_block_lock))
         end
         if((p_sequencer.env.dyn_rcfg_obj_inst.speed != _25G)) begin // 25G FEC am lock always low, See HSD 14011594751
           if ( (p_sequencer.env.spy_if.rx_am_lock == 1'b1) )  begin
             `uvm_info(get_type_name(), $sformatf("am_lock high as expected "), UVM_LOW)
           end
           else begin
             `uvm_error(get_type_name(), $sformatf("block_lock :%d expected to go high ", p_sequencer.env.spy_if.rx_am_lock))
           end
         end

//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
        //Read rxpcs_fully_aligned status register to reflect lock
        //check_csr_status(1);

         //enable all rule checks after lock regained
         p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
         p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

	     //muralasx:
	     if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
            p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
            p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
	     end
        `ifdef ENABLE_ETH_VIP
            p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_tbd.set_default_fail_effect(svt_err_check_stats::NOTE);
       `endif

         //wait before sending frames
         for(int i=0;i<1;i++) begin
           if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
           else if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
           else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
         end

         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
         `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)
         p_sequencer.env.wait_client_rx_frames_done(.exp_num(100),.timeout_time(100us));

         //Wait before next iteration
         #10us;
     end //loop_cnt
   end
   end
   join //tx & rx threads

   #5us;

   `uvm_info(get_type_name(), "PCS RX VIP AM LOCK SEQ END", UVM_LOW)
  endtask

endclass
