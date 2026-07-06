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


class pcs_err_during_lock_sequence extends pcs_base_sequence;
  
  bit rx_crc_pass;
  time       frame_timeout_time=50us;
  `uvm_object_utils(pcs_err_during_lock_sequence)

  function new(string name = "pcs_err_during_lock_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
     int num_frames;
     bit link_lost;
     bit am_lock_lost;
     bit am_lock;
     bit lock_lost;
     integer timeout_cntr_ber=0;
     integer timeout_cntr=0;
     int error_cnt=0;
     uvm_status_e status;
     bit [31:0] am_lock_rd_data;
     bit [31:0] phy_rxpcs_status_rd_data;
     bit [31:0] lanes_deskewed_rd_data;
     bit link_down;
     bit link_up;
     bit hi_ber;
     int num_of_valid_sync_hdrs_for_lock = 64;
     int loop_cnt =1;
     int num_iter=1;
     int good_sync_hdr_cnt;

     $display("start pcs err during lock sequence");

     for(int loop=0;loop<loop_cnt;loop++) begin
     //Since skew will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
     //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
     //bit 0: (set t0 0 to disable checker on tx side)
     //bit 1: (set t0 0 to disable checker on rx side)
     //bit 2: (set t0 0 to disable checker on checker arbiter)
     //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b000);
     // p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);

     //HSD 16011554580 - sync header decoding by PCS is not feasible in Firecode type
     //HSD 16011685925 - sync header corruption is not useful for 200G/400G
      if((p_sequencer.env.dyn_rcfg_obj_inst.fec_type == FCFEC) || (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_400G,_200G})) begin
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
        `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)
      end else begin
         p_sequencer.env.configure_vip_ber();
         `uvm_info(get_type_name(), "Configured ber", UVM_LOW)
         // Refer HSD : https://hsdes.intel.com/appstore/article/#/16011738218
         //Send 65 bad sync hdrs for core (66*65)
		 //disable SB during invalid SH insertion : seeing additional packet
		 //from VIP without 'hFB or 'hFD due to invalid SH - SNPS :01151942 
         p_sequencer.env.dynamic_enable_disable_scoreboards(1);
		 if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_40G,_50G}) begin //HSD 16013097963
           insert_invalid_sync_hdr_callback(65);
           repeat(30) @(p_sequencer.env.spy_if.clk);
	     end  
         else
           insert_invalid_sync_hdr_callback(100);
           `uvm_info(get_name(), $sformatf(" 66*65 INVALID SYNC HDRS inserted, wait for blk lock loss at time :%t", $time), UVM_LOW)
    
         fork begin //to terminate threads when link is down 
          fork 
           begin
             //check to see if blk lock lsot
             link_down=0;
             wait(p_sequencer.env.spy_if.rx_block_lock == 1'b0); //block lock
             link_down=1;
	     	`uvm_info(get_type_name(),$sformatf("After inv_sync_headers, link_down = %0d",link_down),UVM_MEDIUM);
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
           /*begin // check for hi_ber//HSD : 16012712652
             hi_ber = 0;
             wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b1);
             hi_ber=1;
             `uvm_info(get_type_name(), $sformatf("Link is down"), UVM_LOW)
           end
           begin
           //timeout check for hi_ber
             while(hi_ber== 0) begin
             @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
               `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr_ber), UVM_LOW)
               timeout_cntr_ber++;
               if(timeout_cntr_ber == 50) begin
                 break;
               end
             end
           end*/
          join_any
          disable fork;
         end
         join

     	 `uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
     	 if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}  || ((p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G}) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC))) begin // Add speeds which will have block lock loss with invalid sync headers HSD #16013306835
         	`uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
         	if(link_down == 1) begin
          		`uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED link_down:%d", link_down), UVM_LOW)
        	end
            else if((timeout_cntr >= 50) && (link_down == 0)) begin
             	`uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after invalid sync hdrs inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
         	end 
         end //25G && 5OG
     	 else begin
        	`uvm_info(get_type_name(), $sformatf("Invalid Sync Headers are not expected to cause block loss, only hi_ber is expected to go low as link_down is %0d", link_down), UVM_LOW)
        	if(link_down == 1) begin
            	`uvm_error(get_type_name(), $sformatf("Link Down is not expected for this speed, pcs_ready is %0d, block lock is %0d and am_lock is %0d",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_block_lock, p_sequencer.env.spy_if.rx_am_lock))
        	end
        	else if((timeout_cntr_ber >= 50) && (hi_ber == 0)) begin
          		`uvm_error(get_type_name(), $sformatf("hi_ber is not going high as expected, hi_ber is %0d",p_sequencer.env.spy_if.o_rx_hi_ber))
        	end
        	else if(hi_ber == 1) begin
          		`uvm_info(get_type_name(), $sformatf("HI_BER is high as expected"), UVM_LOW)
        	end
     	 end

      	 //Wait till  few good sync hdrs sent, then send error blk again
      	 good_sync_hdr_cnt = $urandom()%64;
      	 `uvm_info(get_type_name(),$sformatf("waiting for good sync header count = %0d", good_sync_hdr_cnt),UVM_LOW)
       
	   	/* if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin
	  		for (int i = 0; i < good_sync_hdr_cnt ; i++) begin
             @(p_sequencer.env.ts_tasks_if.event_xsbi_66b_block_loaded);; //SNPS ticket 25G: 01096811
          	end
	  	 	 @(p_sequencer.env.ts_tasks_if.event_xsbi_66b_block_loaded);
       	 end 
       	 else begin 
         	for (int i = 0; i < good_sync_hdr_cnt ; i++) begin
            	@(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);;
         	end
	 			@(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);
       	 end*/ //Check with snps regarding events

		 #20us;
         `uvm_info(get_type_name(), $sformatf("wait done for good sync header count =%0d", good_sync_hdr_cnt), UVM_LOW);
     
     	 if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}  || ((p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G}) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC))) begin 
		 	// Add speeds which will have block lock loss with invalid sync headers #16013306835
    	 	// if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G}) begin // Add speeds which will have block lock loss with invalid sync headers
			wait(p_sequencer.env.spy_if.rx_block_lock == 1'b1); //block_lock
       		`uvm_info(get_type_name(),"PCS_READY up after good sync headers count",UVM_LOW);
     	 end 
     	 else begin
        	wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0);
       		`uvm_info(get_type_name(),"HI_BER down after good sync headers count",UVM_LOW);
     	 end	     

       	 insert_invalid_sync_hdr_callback(65);

       	 `uvm_info(get_name(), $sformatf("INVALID SYNC HDRS inserted during lock, wait for blk lock loss at time :%t", $time), UVM_LOW)
        
		 fork begin //to terminate threads when link is down 
          fork 
           begin
             //check to see if blk lock lsot
             link_down=0;
             wait(p_sequencer.env.spy_if.rx_block_lock == 1'b0); //block lock
             link_down=1;
	         `uvm_info(get_type_name(),$sformatf("After inv_sync_headers, link_down = %0d",link_down),UVM_MEDIUM);
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
           /*begin // check for hi_ber//HSD : 16012712652
             hi_ber = 0;
             wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b1);
             hi_ber=1;
             `uvm_info(get_type_name(), $sformatf("Link is down"), UVM_LOW)
           end
           begin
           //timeout check for hi_ber
             while(hi_ber== 0) begin
             @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
               `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr_ber), UVM_LOW)
               timeout_cntr_ber++;
               if(timeout_cntr_ber == 50) begin
                 break;
               end
             end
          end*/
          join_any
          disable fork;
         end
         join


     	 if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}  || ((p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G}) && (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC))) begin 
		 // Add speeds which will have block lock loss with invalid sync headers
     	 //if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G}) begin // Add speeds which will have block lock loss with invalid sync headers
         `uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
        	if(link_down == 1) begin
        	  `uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED link_down:%d", link_down), UVM_LOW)
        	end	else if((timeout_cntr >= 50) && (link_down == 0)) begin
          		`uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after invalid sync hdrs inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
        	end
     	 end //25G
     	 else begin
        	`uvm_info(get_type_name(), $sformatf("Invalid Sync Headers are not expected to cause block loss, only hi_ber is expected to go low as link_down is %0d", link_down), UVM_LOW)
        	if(link_down == 1) begin
           	`uvm_error(get_type_name(), $sformatf("Link Down is not expected for this speed, pcs_ready is %0d, block lock is %0d and am_lock is %0d",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_block_lock, p_sequencer.env.spy_if.rx_am_lock))
        	end else if((timeout_cntr_ber >= 50) && (hi_ber == 0)) begin
         	 `uvm_error(get_type_name(), $sformatf("hi_ber is not going high as expected, hi_ber is %0d",p_sequencer.env.spy_if.o_rx_hi_ber))
        	end else if(hi_ber == 1) begin
          	 `uvm_info(get_type_name(), $sformatf("HI_BER is high as expected"), UVM_LOW)
        	end
     	 end

         //Wait till 64 good sync hdrs sent
       	 /*if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin
	  		for (int i = 0; i < good_sync_hdr_cnt ; i++) begin
            	@(p_sequencer.env.ts_tasks_if.event_xsbi_66b_block_loaded);;
          	end
       	 end else begin  
         	for (int i = 0; i < num_of_valid_sync_hdrs_for_lock; i++) begin
            	@(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);;
         	end
       	 end*/
		 #10us;

       	 //lock should have reasserted now
       	 fork 
         begin
           timeout_cntr = 0;
	   	   link_up = 0;
           wait(p_sequencer.env.spy_if.rx_block_lock == 1'b1); //block lock
           link_up = 1;
         end
         begin
           while(link_up == 0) begin
             #2ns;
             timeout_cntr++;
             if(timeout_cntr == 60000) begin
               break;
             end
           end
         end
       	 join_any
      
      	 fork begin  
         //hi_ber should have deasserted now
          fork 
          begin
            hi_ber = 1;
            timeout_cntr_ber = 0;
            p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
            wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0);
            hi_ber = 0;
          end
          begin
            while(hi_ber == 1) begin
              #2ns;
              timeout_cntr_ber++;
                if(timeout_cntr_ber == 60000) begin
                break;
              end
            end
          end
          join_any
          disable fork;
         end
      	 join

       	 //lock did not happen within timeout interval
     	 if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin // Add speeds which will have block lock loss with invalid sync headers
       		if((timeout_cntr >= 60000) && (link_up== 0)) begin
     
    		`uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER ERRORS link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
       		end
       	 	if(link_up == 1) begin
         		`uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
       		end
     	 end else begin  
       		if((timeout_cntr_ber >=60000) && (hi_ber ==1 )) begin
         		`uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR hi_ber de-assertion AFTER BAD sync hdrs hi_ber:%d, timeout_cntr_ber :%d", hi_ber, timeout_cntr_ber))
       		end
       		if(hi_ber == 0) begin
         		`uvm_info(get_type_name(), $sformatf("HI_BER DEASSERTED as expected, hi_ber:%d", hi_ber), UVM_LOW)
       		end
     	 end  

       	 //wait before sending frames
       	 /*if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin
	  		for (int i = 0; i < good_sync_hdr_cnt ; i++) begin
            	@(p_sequencer.env.ts_tasks_if.event_xsbi_66b_block_loaded);;
          	end
       	 end else begin  
        	for (int i = 0; i < num_of_valid_sync_hdrs_for_lock; i++) begin
            	@(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);;
         	end
       	 end*/
		 #10us;

       	 //enable all rule checks after lock regained
       	 p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
       	 p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
       	 p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      	 //Re- Enable Scorebaord
         p_sequencer.env.dynamic_enable_disable_scoreboards(0);
       
       	 send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);
         `uvm_info(get_type_name(), "Sent 100 frames", UVM_LOW)
         #25us;
         p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));

     end 
   end //loop_cnt
   `uvm_info(get_type_name(), "PCS RX VIP ERR DURING LOCK SEQ END", UVM_LOW)
 endtask
endclass
