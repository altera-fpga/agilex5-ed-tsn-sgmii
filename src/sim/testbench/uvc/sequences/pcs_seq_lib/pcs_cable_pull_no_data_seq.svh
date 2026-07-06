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


class pcs_cable_pull_no_data_sequence extends pcs_base_sequence;
  `uvm_object_utils(pcs_cable_pull_no_data_sequence)

  seq_var m_seq_var;
  int num_frames;

  function new(string name = "pcs_cable_pull_no_data_sequence");
    super.new(name);
    m_seq_var = new(); 
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
     integer timeout_cntr=0;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_up;
     bit [31:0] force_rand_data_cntr;

    //-------------------------------------------------------------------
    //wait for link up
    //simulate stop_clk (force rx_serial_data to 'z)
    //dut link should go down
    //stop forcing rx_serial_data
    //wait for link up  
    // frames sent on rx path should be received 
    //-------------------------------------------------------------------

    `uvm_info(get_type_name(), "PCS CABLE PULL NO DATA   SEQ BEGIN", UVM_LOW)
    m_seq_var.speed = p_sequencer.env.dyn_rcfg_obj_inst.speed; 
    //p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),2000); // Configuring BER timer for 2000 clock cycles 

    //Disable vip(TX)-> DUT(RX) scoreboard
    p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;   
    p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;   
    p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0; 
    p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
    
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
        num_frames = 5;
    end else begin
        num_frames = 50;
    end 

    //force random data onto rx path for a random duration
    `uvm_info("instance number",$sformatf("ip instance number is ip%0d",p_sequencer.env.spy_if.inst_num),UVM_NONE);
 
	fork
		begin
		   repeat(10) @(p_sequencer.env.spy_if.clk);
                   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
                      force_rand_data_cntr = 5000 + $urandom()%100;
                   end 
                   else begin
		      force_rand_data_cntr = 1500 + $urandom()%100;
		   end
           //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
		   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
		   //bit 0: (set t0 0 to disable checker on tx side)
		   //bit 1: (set t0 0 to disable checker on rx side)
		   //bit 2: (set t0 0 to disable checker on checker arbiter)
		   if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
		       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);

		   repeat(1000) @(p_sequencer.env.spy_if.clk);
		   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
		   if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
		   p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);

		   // Force 'hX for cable pulling 
		   p_sequencer.env.ts_tasks_if.force_rand_rx_data(1,p_sequencer.env.spy_if.inst_num);
		   repeat(force_rand_data_cntr) @(p_sequencer.env.spy_if.clk);

		   //link must be down by this time
                   //GDR : if(p_sequencer.env.spy_if.rx_am_lock !== 1'b0 || p_sequencer.env.spy_if.rx_block_lock !== 1'b0) begin 
		   if( p_sequencer.env.spy_if.rx_block_lock !== 1'b0) begin
		      `uvm_error(get_type_name(), $psprintf("Expected link down has not occurred, block_lock :%d  am_lock ", p_sequencer.env.spy_if.rx_block_lock, p_sequencer.env.spy_if.rx_am_lock))
		   end

		   // Remove force
		   p_sequencer.env.ts_tasks_if.release_rand_rx_data(1,p_sequencer.env.spy_if.inst_num);
		   `uvm_info(get_type_name(), "DONE DRIVING HIZ RX DATA", UVM_LOW)
		end
		    
		begin
		   //send frames
		   send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_frames);
		end
		
        // thread to make sure that consecutive sop's assertion wont trigger because of link down.
		fork
		   begin
		      @(negedge p_sequencer.env.sideband_if.rx_pcs_ready);
		      p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
		      p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
		   end
		join_none
	join
    	 

    fork begin //to terminate threads when link is down 
       //lock should have reasserted now
       //dut, vip link up
       fork 
          begin
            timeout_cntr = 0;
            link_up = 0;
            //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1),.disable_vip_err(1));
			wait(p_sequencer.env.spy_if.rx_block_lock == 1);
            `uvm_info(get_type_name(), "DUT LINKUP SUCCESSFUL AFTER DRIVING RAND RX DATA", UVM_LOW)
            link_up = 1;
          end
          begin
            while(link_up == 0) begin
              #2ns;
              timeout_cntr++;
              if(timeout_cntr == 400000000) begin
                break;
              end
             end
          end
       join_any
       disable fork;
    end
    join


    if((timeout_cntr >= 400000000) && (link_up== 0)) begin
      `uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER SKEW link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
    end
    
    if(link_up == 1) begin
      `uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
    end

    repeat(50000) @(p_sequencer.env.spy_if.clk);

    fork
      begin
        forever begin
          @(posedge p_sequencer.env.spy_if.clk);
          if(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0 || (p_sequencer.env.spy_if.rx_am_lock == 1'b0&&(!(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}))) || p_sequencer.env.spy_if.rx_block_lock == 1'b0) begin
            `uvm_error(get_type_name(), $sformatf("unexpected link down, rx_pcs_ready = :%d   rx_am_lock = %0d   block_lock = %0d ",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_am_lock,p_sequencer.env.spy_if.rx_block_lock))
            `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
          end
        end
      end
    join_none

    //enable all rule checks after lock regained
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
    if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})begin
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
       p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
       if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN && p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_40G,_50G}) begin //HSD:16013285236
       `uvm_info(get_type_name(), $sformatf("Temporarily disabling BIP errors for OTN"), UVM_NONE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end  
    end
    
    //Enable vip(TX)-> DUT(RX) scoreboard
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0; 

    if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE,PCSONLY})) begin
         p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1; 
         p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
     end

    `uvm_info(get_type_name(), "Re-enabled scoreboard", UVM_LOW);

    //send frames
    wait (p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0); // waiting for hi_ber to go low
    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_frames); 
    p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_frames),.timeout_time(1ms));
         
    `uvm_info(get_type_name(), "PCS CABLE PULL NO DATA   SEQ END", UVM_LOW)
  endtask
endclass : pcs_cable_pull_no_data_sequence


class pcs_cable_pull_no_data_reset_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(pcs_cable_pull_no_data_reset_sequence)

  class local_seq_var extends seq_var; 

  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_cable_pull_no_data_reset_sequence");
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
     int loop_cnt = 3;
     bit [15:0] len;
     bit [31:0] force_rand_data_cntr;


    //-------------------------------------------------------------------
    //wait for link up
    //simulate stop_clk (force rx_serial_data to 'z)
    //dut link should go down
    //stop forcing rx_serial_data
    //wait for link up  
    // frames sent on rx path should be received 
    //-------------------------------------------------------------------


    `uvm_info(get_type_name(), "PCS CABLE PULL NO DATA   SEQ BEGIN", UVM_LOW)

  
    rx_crc_pass=$urandom;

    //dut, vip link up
 //   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    //Disable vip(TX)-> DUT(RX) scoreboard
    p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;   
    p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;   
    p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0; 
    p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;

    //force random data onto rx path for a random duration
    fork 
	    fork

		    begin
			      repeat(10) @(p_sequencer.env.spy_if.clk);
			      //force_rand_data_cntr = 100000 + $urandom()%1000;
			      force_rand_data_cntr = 40000 + $urandom()%1000;
			      //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
			      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
			      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
			      //bit 0: (set t0 0 to disable checker on tx side)
			      //bit 1: (set t0 0 to disable checker on rx side)
			      //bit 2: (set t0 0 to disable checker on checker arbiter)
			      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
			      `ifdef OTN_MODE
			      p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
			      `endif
			      `ifdef FLEXE_MODE
			      p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
			      `endif

			      repeat(1000) @(p_sequencer.env.spy_if.clk);
			      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
			      `ifdef OTN_MODE
			      p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
			      `endif
			      `ifdef FLEXE_MODE
			      p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
			      `endif

			      // Force 'hX for cable pulling 
			      p_sequencer.env.ts_tasks_if.force_rand_rx_data(2); // Drive 0 on rx_serial 
			      repeat(force_rand_data_cntr) @(p_sequencer.env.spy_if.clk);

			      //link must be down by this time
			      //if(p_sequencer.env.spy_if.rx_am_lock !== 1'b0 || p_sequencer.env.spy_if.rx_block_lock !== 1'b0) begin
                                 if(p_sequencer.env.spy_if.rx_block_lock !== 1'b0) begin
			        `uvm_error(get_type_name(), $psprintf("Expected link down has not occurred, block_lock :%d  am_lock ", p_sequencer.env.spy_if.rx_block_lock, p_sequencer.env.spy_if.rx_am_lock))
			      end

			      // Remove force
			      p_sequencer.env.ts_tasks_if.release_rand_rx_data(1);
			      `uvm_info(get_type_name(), "DONE DRIVING HIZ RX DATA", UVM_LOW)
		      end
		     begin
			      @(negedge p_sequencer.env.sideband_if.rx_pcs_ready);
			      //wait(p_sequencer.env.spy_if.ehip_addr=='h00_1028);
                                  p_sequencer.env.apply_reset(.rst_type("soft"),.ip_rst(1));
			  end 

		      begin
			      //send frames
			      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
		      end
	    join
    	begin 
    	#200us; 
    	`uvm_fatal(get_type_name(),"Timeout waiting for desired ehip_addr or negedge of rx_pcs_ready")
    	end
	join_any
	disable fork; 

    `uvm_info(get_type_name(), "PCS CABLE PULL NO DATA  RESET SEQ END", UVM_LOW)
  endtask
endclass:pcs_cable_pull_no_data_reset_sequence

