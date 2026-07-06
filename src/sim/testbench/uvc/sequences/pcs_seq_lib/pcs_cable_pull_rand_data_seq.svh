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


class pcs_cable_pull_rand_data_sequence extends pcs_base_sequence;

  bit rx_crc_pass;
  int rx_pkt_cnt=0;
  `uvm_object_utils(pcs_cable_pull_rand_data_sequence)

  seq_var m_seq_var;
  int num_frames;

  function new(string name = "pcs_cable_pull_rand_data_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
     bit am_lock;
     integer timeout_cntr=0;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_up;
     bit [15:0] len;
     bit [31:0] force_rand_data_cntr;

    //-------------------------------------------------------------------
    //toggle rxpma_rdy after hard reset
    //pcs_rdy should go down when rx_pma rdy low
    //dut link should come up after rxpma_rdy goes back to high
    // frames sent on rx path during this toggling. After every link up, all frames should be received
    //-------------------------------------------------------------------
    `uvm_info(get_type_name(), "PCS CABLE PULL RAND DATA   SEQ BEGIN", UVM_NONE)


     m_seq_var.speed = p_sequencer.env.dyn_rcfg_obj_inst.speed; 
     rx_crc_pass=$urandom;
    // p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),2000); // Configuring BER timer for 2000 clock cycles

     if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
        num_frames = 5;
    end else begin
        num_frames = 50;
    end
 
    //Disable vip(TX)-> DUT(RX) scoreboard
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;  
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
     `uvm_info("instance number",$sformatf("ip instance number is ip%0d",p_sequencer.env.spy_if.inst_num),UVM_NONE);


    //force random data onto rx path for a random duration
     fork
     begin
         repeat(10) @(p_sequencer.env.spy_if.clk);
         force_rand_data_cntr = 40000 + $urandom()%1000;
       
         //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
         p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
         if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) 
           p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
	
        `ifdef ENABLE_ETH_VIP
	       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
	       p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
        `endif

        repeat(1000) @(p_sequencer.env.spy_if.clk);
        //bit 0: (set t0 0 to disable checker on tx side)
        //bit 1: (set t0 0 to disable checker on rx side)
        //bit 2: (set t0 0 to disable checker on checker arbiter)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
        if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) 
           p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
       
        // Force random data for cable pulling 
        p_sequencer.env.ts_tasks_if.force_rand_rx_data(0,p_sequencer.env.spy_if.inst_num);
        repeat(force_rand_data_cntr) @(p_sequencer.env.spy_if.clk);

        //link must be down by this time
        if(p_sequencer.env.spy_if.rx_block_lock !== 1'b0) begin
           `uvm_error(get_type_name(), $psprintf("Expected link down has not occurred, block_lock :%d ", p_sequencer.env.spy_if.rx_block_lock))
        end
 
        // Remove force
        p_sequencer.env.ts_tasks_if.release_rand_rx_data(0,p_sequencer.env.spy_if.inst_num);
        `uvm_info(get_type_name(), "DONE DRIVING RAND RX DATA", UVM_LOW)
     end
 
     begin
       //send frames
       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_frames);
     end
     join


     fork begin //to terminate threads when link is down 
        //lock should have reasserted now
        fork 
           begin
              am_lock = 0;
              timeout_cntr = 0;
              //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1),.disable_vip_err(1));
			  wait(p_sequencer.env.spy_if.rx_block_lock == 1);
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
            end // while (link_up == 0)
	     
        join_any
        disable fork;
     end
     join

    //drajasek waiting for o_rx_block_lock to relock HSD 16011633981
  
    fork
      begin
	     wait(p_sequencer.env.spy_if.rx_block_lock == 1'b1)
	     `uvm_info(get_type_name(),"re-lock done",UVM_LOW);
	  end
	  begin
	     timeout_cntr = 0;
	     while(p_sequencer.env.spy_if.rx_block_lock == 1'b0) begin
            #5ns;		  
            timeout_cntr++;
	        if (timeout_cntr == 18000000) begin
              break;
	        end
	     end
      end
    join_any
    disable fork;
	  
    
    fork
      begin
        forever begin
          @(posedge p_sequencer.env.spy_if.clk);
          if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0 
	     //muralasx: FIXME added below line by ignoring macro. 
//	     || (p_sequencer.env.spy_if.rx_am_lock == 1'b0 && (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}))
	     || p_sequencer.env.spy_if.rx_block_lock == 1'b0) begin
           // `uvm_error(get_type_name(), $sformatf("unexpected link down, rx_pcs_ready = :%d   rx_am_lock = %0d   block_lock = %0d ",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_am_lock,p_sequencer.env.spy_if.rx_block_lock))
		   `uvm_error(get_type_name(), $sformatf("unexpected link down, rx_pcs_ready = :%d  block_lock = %0d ",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_block_lock))

            `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
          end
        end
      end
    join_none

    //enable all rule checks after lock regained
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
       if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN && p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_40G,_50G}) begin //HSD:16013285236
       `uvm_info(get_type_name(), $sformatf("Temporarily disabling BIP errors for OTN"), UVM_NONE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end  
    end
    
    //Enable vip(TX)-> DUT(RX) scoreboard
     //  waiting for all the previous packets to complete before enabling Scoreboard
     p_sequencer.env.wait_vip_tx_frames_done(.exp_num(num_frames));
     #5us;
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0; 
     if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE,PCSONLY})) begin
       p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
       p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
     end
//   TBD: Check why assertion was not enabled in C3 for cable_pull no data and change here too
//   Added in excel and commentedd for TOG
//	`ifdef ENABLE_ETH_VIP
//	 p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
//	 p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);
//       `endif
    `uvm_info(get_type_name(), "Re-enabled scoreboard", UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("TX SCB :%0d & RX SCB:%0d",p_sequencer.env.sb_vip_tx_mac_rx.tx_pkt_cnt,p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_LOW)
    rx_pkt_cnt = p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt;

    //send frames
    wait (p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0); // waiting for hi_ber to go low
    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_frames);
    #1us;
    p_sequencer.env.wait_vip_tx_frames_done(.exp_num(num_frames));
    `uvm_info(get_full_name(),$sformatf("TX SCB :%0d & RX SCB:%0d",p_sequencer.env.sb_vip_tx_mac_rx.tx_pkt_cnt,p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt),UVM_LOW)
    wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt==(rx_pkt_cnt+num_frames));
  //  p_sequencer.env.wait_client_rx_frames_done(.exp_num(100),.timeout_time(200us));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
        #250us;
    end
	`uvm_info(get_type_name(), "PCS CABLE PULL RAND DATA   SEQ END", UVM_LOW)
  endtask
endclass
