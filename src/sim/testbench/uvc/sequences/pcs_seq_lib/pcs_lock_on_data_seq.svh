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


class pcs_lock_on_data_sequence extends pcs_base_sequence;
  bit rx_crc_pass;
  time       frame_timeout_time=1ms;
  `uvm_object_utils(pcs_lock_on_data_sequence)

  class local_seq_var extends seq_var; 

     constraint num_invalid_sync_hdr_c {
       num_invalid_sync_hdr == 65;
     }

     //---------------------------------------------------------------------------
     // Function: new
     //    Class contructor
     //---------------------------------------------------------------------------
     function new (string n = "core_seq_var");
        super.new(n);
     endfunction : new

  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_lock_on_data_sequence");
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
     int num_of_valid_sync_hdrs_for_lock = 64;
     int loop_cnt =1;
     int num_iter=1;
     int good_sync_hdr_cnt;
     bit sent_data_blks = 0;

      //-------------------------------------------------------------------
      // wait for link up 
      // add invalid sync hdrs for loss of lock
      // send data block and verify lock happens on data 
      // wait for recovery
      // Fire Data Packets from VIP 
      //-------------------------------------------------------------------

      $display("start pcs_lock_on_data sequence");

   	  for(int loop=0;loop<loop_cnt;loop++) begin
      //Since skew will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b000);
      //SNPS ticket : 01109587
      // p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      // p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      // p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);


      //randomize num of lanes, 
      if (!m_seq_var.randomize()) begin
        `uvm_fatal(get_type_name(), "Randomization of seq_var failed")
      end
       
      `uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)

      //HSD 16011554580 - sync header decoding by PCS is not feasible in Firecode type
      //HSD 16011685925 - sync header corruption is not useful for 200G/400G
      if((p_sequencer.env.dyn_rcfg_obj_inst.fec_type == FCFEC) || (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_400G,_200G})) begin
        `uvm_info(get_name(),$sformatf(" SYNC HEADER coruuption is not applicable for FCFEC/200G/400G"),UVM_LOW);       
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
        `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)
      end 
      else begin
         p_sequencer.env.configure_vip_ber();
         `uvm_info(get_type_name(), "Configured ber", UVM_LOW)
      
         fork
         //thread to send bad sync hdrs followed by data blks
         begin 
         //Send 65 bad sync hdrs for core
	 	 //disable SB during invalid SH insertion : seeing additional packet
	 	 //from VIP without 'hFB or 'hFD due to invalid SH - SNPS :01151942 
         p_sequencer.env.dynamic_enable_disable_scoreboards(1);
         // p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
	     // p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
         `uvm_info(get_name(), $sformatf("Insert 65 INVALID SYNC Headers"),UVM_LOW);
         insert_invalid_sync_hdr_callback(65);
         `uvm_info(get_name(), $sformatf("INVALID SYNC HDRS inserted, wait for blk lock loss at time :%t", $time), UVM_LOW)
         //send data blks, enough for dut to have locked when this sent thread is done
         `uvm_info(get_name(), $sformatf("Insert DATA SYNC Headers"),UVM_LOW);
         insert_data_sync_hdr_callback(64*50);
             
         sent_data_blks = 1;
         `uvm_info(get_name(), $sformatf("DATA BLKS inserted, wait for linkup at time :%t sent_data_blks :%d", $time, sent_data_blks), UVM_LOW)
         end
    
         begin
          fork
           begin
	      	 //check to see if blk lock lost
             if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G, _10G}) begin
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_var == _USXGMII)begin
	              wait(p_sequencer.env.spy_if.rx_block_lock == 1'b0);
                      `uvm_info(get_name(), $sformatf("Link went down as expected at time :%t", $time), UVM_LOW)
		    end 
		    link_down=1;
	     end else begin
                wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b1);
		link_down=1;
                `uvm_info(get_name(), $sformatf("Link went down as expected at time :%t", $time), UVM_LOW)
	     end

             wait(sent_data_blks == 1'b1);
             if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G , _10G}) begin
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_var == _USXGMII)begin
                       wait(p_sequencer.env.spy_if.rx_block_lock == 1'b1);
                       `uvm_info(get_name(), $sformatf("Link up after data blks as expected at time :%t", $time), UVM_LOW)
		    end
                link_down=0;
	     end else begin
                wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0);
                #1us;
                wait(p_sequencer.env.sideband_if.rx_pcs_ready == 1'b1);
                `uvm_info(get_name(), $sformatf("pcs ready is asserted at time :%t", $time), UVM_LOW)
		link_down=0;
                `uvm_info(get_name(), $sformatf("Link up after data blks as expected at time :%t", $time), UVM_LOW)
	     end 	 
           end 
           begin
              #200us; //Todo : check with Siva
              `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR rx_block_lock 1'b0 followed by 1'b1"))
           end
          join_any
          disable fork;
         end
         join

       	 //wait before sending frames
         /*if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
         	for(int i=0;i<5;i++) begin
            	if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G , _10G}) begin
             		@(p_sequencer.env.ts_tasks_if.event_insert_xxvsbi_align_marker); 
           		end else begin
             		@(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
	   			end  
         	end
      	 end else begin
        	if ((p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC) && (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G , _10G})) begin
           		for(int i=0;i<50;i++) begin
             		@(p_sequencer.env.ts_tasks_if.event_xsbi_66b_block_loaded);; 
           		end
        	end
      	 end  */
		 #20us;
     	 `uvm_info(get_name(), $sformatf("Sending VIP TX traffic after link up at time :%t", $time), UVM_LOW)

       	 //enable all rule checks after lock regained
       	 p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
       	 p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
       	 p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      	 //Re- Enable Scorebaord
       	 p_sequencer.env.dynamic_enable_disable_scoreboards(0);

       	 if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
		   // send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);
	    send_eth_frame_with_fix_size(.eth_frame(DATA_FRAME),.frame_size($urandom_range(40,50)),.no_of_frame(10),.path(ETH_VIP_AVL_RX));
	 end else begin
	    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,50);
	 end		
       	 `uvm_info(get_type_name(), "Sent frames", UVM_LOW)
       	 p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
	 if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
	 #250us;
	 end
      end  
     end //loop_cnt
     `uvm_info(get_type_name(), "PCS RX VIP ERR DURING LOCK SEQ END", UVM_LOW)
  endtask
endclass
