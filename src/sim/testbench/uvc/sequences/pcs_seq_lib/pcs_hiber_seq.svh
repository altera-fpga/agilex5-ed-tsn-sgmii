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


class pcs_hiber_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_hiber_sequence)

  class local_seq_var extends seq_var;

   constraint delay_bn_invalid_sync_hdr_c{
      delay_bn_invalid_sync_hdr inside {[100:200]};
    }
  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_hiber_sequence");
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
     integer timeout_cntr_value=1000;
     bit insert_invalid_sync_hdr_thread_done = 0;
     bit success;
     int error_cnt=0;
     uvm_status_e status;
     bit [31:0] xus_timer_window_reg_rd;
     bit [20:0] xus_timer_preload;

     //-------------------------------------------------------------------
     // choose lane/lanes to add invalid sync hdrs (start at start of window (1st) and keep it 97 total in a 500us window)
     // check that dut entered hiber state
     // check for loss of lock (should not lose lock)
     // check that dut continues to be in hiber state at the beginning of the next window (2nd)
     // check for loss of lock (should not lose lock)
     // now check that dut gets out of hiber state at the beginning of the next window (3rd)
     // check for loss of lock (should not lose lock)
     // send frames
     //-------------------------------------------------------------------

    `uvm_info(get_type_name(), "PCS RX VIP HIBER SEQ START", UVM_LOW)

    rx_crc_pass=$urandom;

 
    //pcs_mac register not accessible in pcs_only mode   
    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
    $display("DONE!!! WRITING TO REG");

    timeout_cntr = 0;
    //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
    //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
    //bit 0: (set t0 0 to disable checker on tx side)
    //bit 1: (set t0 0 to disable checker on rx side)
    //bit 2: (set t0 0 to disable checker on checker arbiter)
    //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})begin
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
    end

    m_seq_var.speed = p_sequencer.env.dyn_rcfg_obj_inst.speed;
    //randomize num of lanes, invalid am on each lane
    if (!m_seq_var.randomize()) begin
      `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
    end
    `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)

    fork
      begin
        insert_invalid_sync_hdr_thread_done = 0;
        //wait for new ber window to start
        //For 50G, preload xus_timer to a large value for shorter simulation times
	 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)
          xus_timer_preload = 20'd171415;
	 if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)
          xus_timer_preload = 20'd403220;

	 if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) xus_timer_preload = 20'd190000;


	//muralasx: FIXME for GDR reg_model. 
        //`ifdef CRETE3
        //// `ifdef ACDS_19_1
        //  `ifdef FALCON_MESA
        //    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);
        //    `else
        //   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);  
        //   `endif //FALCON_MESA
        // /* `else
        //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);  
        //  `endif*/
	//`else //For crete2e
       ////  `ifdef ACDS_19_1
        //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload); 
        // /* `else
        //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);  
        //`endif*/
        //`endif

        repeat(2) @(p_sequencer.env.spy_if.clk);

	//muralasx:  FIXME for GDR reg_model
        //`ifdef CRETE3
        // //`ifdef ACDS_19_1
        //   `ifdef FALCON_MESA
        //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");
        //  `else
        //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");
        //  `endif //FALCON_MESA
        //  `else //For crete2e
        //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");  
        //`endif
             
	`uvm_info(get_type_name(), $sformatf("xus timer force done"), UVM_LOW)
  
        wait_for_hiber_window_done_t();
        `uvm_info(get_type_name(), $sformatf("xus timer window end, invalid sync hdr insertion begins m_seq_var.invalid_sync_hdr_cnt:%d", m_seq_var.invalid_sync_hdr_cnt), UVM_LOW)

	while(m_seq_var.invalid_sync_hdr_cnt < 'd97) begin
          `uvm_info(get_type_name(), $sformatf("invalid_sync_hdr_cnt:%d", m_seq_var.invalid_sync_hdr_cnt), UVM_LOW)
	  @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);
          insert_invalid_sync_hdr(m_seq_var);

          //wait random delay before insering next invalid sync hdr
          for(int i=0; i<m_seq_var.delay_bn_invalid_sync_hdr; i++) begin
	    @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);
          end
	end

        //wait for some time before checking if ber status is flagged by the dut
        repeat(50) @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);

	if(p_sequencer.env.spy_if.o_rx_hi_ber !== 1) begin
	  `uvm_fatal(get_type_name(), $sformatf("HI BER not set after causing condition"))
	end

        repeat(50) @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);

	if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})) begin
	    success = p_sequencer.env.mii_tx_agent.mii_rx_mon.check_for_local_fault();

	    if(success) begin
              `uvm_info(get_type_name(), $sformatf("Local faults sent out in HI BER state"), UVM_LOW)
            end
            else begin
              `uvm_fatal(get_type_name(), $sformatf("Local faults not sent out in HI BER state"))
            end
	end

        insert_invalid_sync_hdr_thread_done = 1;
        `uvm_info(get_type_name(), $sformatf("End of thread inserting invalid sync hdrs"), UVM_LOW)
      end
      begin
        //check to see if lock lost
        error_cnt = 0;
        while((error_cnt == 0) || (timeout_cntr <= timeout_cntr_value)) begin
          if((p_sequencer.env.spy_if.block_lock == 1'b0) && (p_sequencer.env.spy_if.rx_am_lock == 1'b0) && (p_sequencer.env.spy_if.rx_dsk_done == 1'b0)) begin
            //Not expected to lose block lock
            error_cnt++;
            break;
          end
          else begin
	    @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);
            timeout_cntr++;
            if(insert_invalid_sync_hdr_thread_done == 1) begin
            break;
            end
          end
        end //while
      end
    join
    disable fork;

    if(error_cnt != 0)  begin
      `uvm_fatal(get_type_name(), $sformatf("UNEXPECTED LOSS OF LOCK error_cnt :%d", error_cnt))
    end

    //For 50G mode, this checks gets enabled somewhat early. So, delaying enabling by around 10us. 
    //muraralsx: FIXME for all the speeds. 
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed != _100G) #10us;

    //enable all rule checks after lock regained
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
    end

    //Check for loss of lock
    if((p_sequencer.env.spy_if.block_lock == 1'b0) && (p_sequencer.env.spy_if.rx_am_lock == 1'b0) && (p_sequencer.env.spy_if.rx_dsk_done == 1'b0)) begin
      `uvm_fatal(get_type_name(), $sformatf("UNEXPECTED LOSS OF LOCK  at the end of the first timer window"))
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("NO LOSS OF LOCK at the end of the first timer window"), UVM_LOW)
    end


    // check that dut continues to be in hiber state at the beginning of the next window (2nd)
    //wait for new ber window to start

    //muralasx:  FIXME for GDR reg_model 
    //`ifdef CRETE3
    //     //`ifdef ACDS_19_1
    //       `ifdef FALCON_MESA
    //           uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload); 
    //           `else
    //           uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);  
    //        `endif //FALCON_MESA
    //    	`else //For crete2e
    //      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload); 
    //    `endif

        repeat(2) @(p_sequencer.env.spy_if.clk);

       //muralasx: FIXME for GDR reg_model
       // `ifdef CRETE3
       // // `ifdef ACDS_19_1
       //    `ifdef FALCON_MESA
       //      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");
       //      `else
       //      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");  
       //     `endif //FALCON_MESA
       // 
       //         `else //For crete2e
       //   uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");  
       // `endif
         
    `uvm_info(get_type_name(), $sformatf("xus timer force done"), UVM_LOW)

    wait_for_hiber_window_done_t();

    //wait for some time before checking lock 
    repeat(50) @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);

    if(p_sequencer.env.spy_if.o_rx_hi_ber !== 1) begin
      `uvm_fatal(get_type_name(), $sformatf("HI BER not set in second window"))
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("HI BER set in second window"), UVM_LOW)
    end

    if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})) begin
         success = p_sequencer.env.mii_tx_agent.mii_rx_mon.check_for_local_fault();

         if(success) begin
           `uvm_info(get_type_name(), $sformatf("Local faults sent out in HI BER state in second window "), UVM_LOW)
         end
         else begin
           `uvm_fatal(get_type_name(), $sformatf("Local faults not sent out in HI BER state in second window"))
         end
    end
    //Check for loss of lock
    if((p_sequencer.env.spy_if.block_lock == 1'b0) && (p_sequencer.env.spy_if.rx_am_lock == 1'b0) && (p_sequencer.env.spy_if.rx_dsk_done == 1'b0)) begin
      `uvm_fatal(get_type_name(), $sformatf("UNEXPECTED LOSS OF LOCK  at the end of the second timer window"))
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("NO LOSS OF LOCK at the end of the first second window"), UVM_LOW)
    end


    //now check that dut gets out of hiber state at the beginning of the next window (3rd)
    //wait for new ber window to start

    //muralasx: FIXME for GDR
    //`ifdef CRETE3
    //    // `ifdef ACDS_19_1
    //     `ifdef FALCON_MESA
    //      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);
    //      `else
    //      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload);  
    //      `endif //FALCON_MESA
    //     	`else //For crete2e
    //      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer",xus_timer_preload); 
    //    `endif

        repeat(2) @(p_sequencer.env.spy_if.clk);

    //muralasx: FIXME for GDR
    //    `ifdef CRETE3
    //    // `ifdef ACDS_19_1
    //       `ifdef FALCON_MESA
    //         uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");
    //       `else
    //      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");
    //      `endif //FALCON_MESA
    //    	`else //For crete2e
    //      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.die_specific_inst.x_c2_ehip_core.u_rx_pcs.u_pcs_ber.u_pcs_ber_sm.xus_timer");  
    //    `endif
         
    `uvm_info(get_type_name(), $sformatf("xus timer force done"), UVM_LOW)

    wait_for_hiber_window_done_t();

    //wait for some time before checking lock 
    repeat(1000) begin
      @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);
      if(p_sequencer.env.spy_if.o_rx_hi_ber === 0) begin
        break;
      end
    end  

    if(p_sequencer.env.spy_if.o_rx_hi_ber !== 0) begin
      `uvm_fatal(get_type_name(), $sformatf("HI BER not reset in third window"))
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("HI BER reset in thirs window"), UVM_LOW)
    end

    repeat(50) @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);

    if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})) begin
         success = p_sequencer.env.mii_tx_agent.mii_rx_mon.check_for_local_fault();

         if(success == 0) begin
           `uvm_info(get_type_name(), $sformatf("Local faults not sent out in HI BER state in third window "), UVM_LOW)
         end
         else begin
           `uvm_fatal(get_type_name(), $sformatf("Local faults still sent out in HI BER state in third window"))
         end
    end
    //Check for loss of lock
    if((p_sequencer.env.spy_if.block_lock == 1'b0) && (p_sequencer.env.spy_if.rx_am_lock == 1'b0) && (p_sequencer.env.spy_if.rx_dsk_done == 1'b0)) begin
      `uvm_fatal(get_type_name(), $sformatf("UNEXPECTED LOSS OF LOCK  at the end of the third timer window"))
    end
    else begin
      `uvm_info(get_type_name(), $sformatf("NO LOSS OF LOCK at the end of the first third window"), UVM_LOW)
    end


    `uvm_info(get_type_name(), $sformatf("About to send frames"), UVM_LOW)

    //send frames
    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
    `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)

    `uvm_info(get_type_name(), "PCS RX VIP HIBER SEQ END", UVM_LOW)
  endtask
endclass
