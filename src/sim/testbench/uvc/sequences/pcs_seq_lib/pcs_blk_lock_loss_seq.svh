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


class pcs_blk_lock_loss_sequence extends pcs_base_sequence;
  bit rx_crc_pass;
  `uvm_object_utils(pcs_blk_lock_loss_sequence)

  class local_seq_var extends seq_var; 

     constraint num_invalid_sync_hdr_c {
       num_invalid_sync_hdr == 65;
     }
     constraint num_lanes_c {
     (speed == _50G)  -> num_lanes inside {[2:4]}; 
     (speed == _40G)  -> num_lanes inside {[2:4]}; 
     (speed == _100G) -> num_lanes inside {[4:20]}; 
     (speed == _200G) -> num_lanes inside {[4:8]}; 
     (speed == _400G) -> num_lanes inside {[4:16]}; 
    }
  endclass

  local_seq_var m_seq_var;

  function new(string name = "pcs_blk_lock_loss_sequence");
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
     integer timeout_cntr_ber=0;
     bit link_down;
     bit link_up;
     bit hi_ber; 
     uvm_reg_data_t word_lock_rd_data;
     uvm_reg_data_t am_lock_rd_data;
     uvm_reg_data_t rxpcs_fully_aligned_rd_data;
     uvm_reg_data_t lanes_deskewed_rd_data;
     uvm_reg_data_t frm_err_rd_data;
     uvm_reg_data_t read_data;
     int loop_cnt=1;
	 int frame_cnt;

     `uvm_info(get_type_name(), "PCS RX BLK LOCK LOSS SEQ BEGIN", UVM_LOW)
     rx_crc_pass=$urandom;
 	 $display("DONE!!! WRITING TO REG");
     p_sequencer.env.configure_vip_ber();
     `uvm_info(get_type_name(), "Configured ber", UVM_LOW)

	 if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
	    frame_cnt = 5;
	 end else begin 
		frame_cnt = 20;
     end		

     //tx traffic should be uninterrupted
   	 fork
   	   begin
     	 if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}))
            send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,20);  
     	 else if (p_sequencer.env.dyn_rcfg_obj_inst.mode==OTN)
          	send_eth_frame(DATA_FRAME,OTN_MODE,100);  
     	 else if (p_sequencer.env.dyn_rcfg_obj_inst.mode==FLEXE)
          	send_eth_frame(DATA_FRAME,FLEXE_MODE,100);  
   	   end
   	   begin
     //seq repeats
     	for(int loop=0;loop<loop_cnt;loop++) begin
			p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;  
       		p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
      		p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; // Disabling SCBD since VIP is treating FEFE from invalid sync headers as packets 
        	p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
     		link_down = 0;
     		link_up = 0;
     		hi_ber = 0;
     		timeout_cntr = 0;
     		timeout_cntr_ber = 0;
     		//Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
    		p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
     		p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b000);

     		if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
        		p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_DISABLE_ALL_RULE,0);
        		p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b101);
     		end

       		p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     		//randomize num of lanes, invalid am on each lane
     		$cast(m_seq_var.speed, p_sequencer.env.spy_if.speed);

     		if (!m_seq_var.randomize()) begin
       			`uvm_fatal(get_type_name(), "Randomization of seq_var failed")
     		end

     		`uvm_info(get_name(), $sformatf("m_seq_var := %s",m_seq_var.sprint), UVM_LOW)
     
			insert_invalid_sync_hdr_callback(m_seq_var.num_invalid_sync_hdr); 
       		`uvm_info(get_type_name(), $sformatf("inserted invalid_sync_hdr :%d, num_lanes:%d", m_seq_var.num_invalid_sync_hdr, m_seq_var.num_lanes), UVM_LOW)
     
      		fork 
     	 	begin //to terminate threads when link is down 
       		  fork 
         		begin
           		//check to see if lock lost
           		am_lock_lost = 0;
           		wait(p_sequencer.env.spy_if.rx_block_lock  == 1'b0);
           		link_down=1;
          		// worst case expected adapter delay HSD - 1507233382
           		//#289ns; //Commenting this delay, suspecting this might be because of RTL change #HSD16012412741
           		//Check that blk lock, am_lock are deasserted
           		//dr if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b0) && (p_sequencer.env.spy_if.rx_am_lock== 1'b0) ) begin
           		/*if (p_sequencer.env.spy_if.rx_block_lock == 1'b0) begin
             	`uvm_info(get_type_name(), $sformatf("block_lock low as expected "), UVM_LOW)
           		end
           		else begin
             	`uvm_fatal(get_type_name(), $sformatf("block_lock :%d signals expected to go low ", p_sequencer.env.spy_if.rx_block_lock))
           		end*/
           		end
		  		// check with DM Designers 
        		/*begin // check for hi_ber
           		hi_ber = 0;
           		wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b1);
           		hi_ber=1;
           		//dr if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b0) || (p_sequencer.env.spy_if.rx_am_lock== 1'b0) || (p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0)) begin
           		if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b0) || (p_sequencer.env.sideband_if.rx_pcs_ready == 1'b0)) begin
             	`uvm_info(get_type_name(), $sformatf("Link is down"), UVM_LOW)
             	link_down=1;
           		end
         		end*/
         		begin
           		//timeout check
           		//while(am_lock_lost == 0) begin
          		 while(link_down== 0) begin
	     			if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
             		else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
                	`uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr), UVM_LOW)
             	    timeout_cntr++;
             		if(timeout_cntr == 50) begin
               		break;
             		end
           		 end
         		end
         		begin
           		//timeout check for hi_ber
           		 while(hi_ber== 0) begin
	     			if((p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G)) @(p_sequencer.env.ts_tasks_if.event_load_align_marker_error);
             		else @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
             		`uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr_ber), UVM_LOW)
             		timeout_cntr_ber++;
             		if(timeout_cntr_ber == 50) begin
               		break;
             		end
           		 end
         		end
       		  join_any
       		  disable fork;
     	    end
     	    join

      		if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin // Add speeds which will have block lock loss with invalid sync headers
        	`uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
        		if(link_down == 1) begin
          			`uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED link_down:%d", link_down), UVM_LOW)
        		end	else if((timeout_cntr >= 50) && (link_down == 0)) begin
       				`uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after invalid sync hdrs inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
      			end
        	end //25G
        	else begin //Speeds where link down is not expected after inserting invalid sync headers
        	`uvm_info(get_type_name(), $sformatf("Invalid Sync Headers are not expected to cause block loss, only hi_ber is expected to go low", link_down), UVM_LOW)
        		if(link_down == 1) begin
       				`uvm_error(get_type_name(), $sformatf("Link Down is not expected for this speed, pcs_ready is %0d, block lock is %0d ",p_sequencer.env.sideband_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_block_lock))
       			end else if((timeout_cntr_ber >= 50) && (hi_ber == 0)) begin
       				`uvm_error(get_type_name(), $sformatf("hi_ber is not going high as expected, hi_ber is %0d",p_sequencer.env.spy_if.o_rx_hi_ber))
       			end else if(hi_ber == 1) begin
        			`uvm_info(get_type_name(), $sformatf("HI_BER is high as expected"), UVM_LOW)
      			end
    		end
     
     		//For coverage purpose
      		//dr p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data, 1);
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
      	/*	p_sequencer.env.reg_read(`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data, 1);
      		`uvm_info(get_type_name(), $sformatf("rxpcs_status read value :%h", read_data), UVM_LOW)
	  		if(read_data[0] == 1) begin
	    		`uvm_error(get_type_name(), $sformatf("Expecting rxpcs_status read value should be zero"));
      		end	*/	
      
       		repeat(20) @(p_sequencer.env.spy_if.clk);

      		//Read rxpcs_fully_aligned status register to reflect loss
      		//if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC) check_csr_status(1); 
      		fork begin //to terminate threads when link is down 
        	//lock should have reasserted now
         	  fork 
          		begin
            		am_lock = 0;
            		timeout_cntr = 0;
					//p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1),.disable_vip_err(1));
              		`uvm_info(get_type_name(), $sformatf("Wait DUT to link up...=%0t", $time), UVM_NONE)
              		wait((p_sequencer.env.sideband_if.tx_lane_stable==1) && (p_sequencer.env.sideband_if.rx_pcs_ready == 1'b1));
			  		wait(p_sequencer.env.spy_if.rx_block_lock  == 1'b1);
              		`uvm_info(get_type_name(), $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE)
              		p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.EVENT_LINK_UP.wait_trigger();
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
         	  disable fork;
            end
      	    join

           	if((timeout_cntr >= 18000000) && (link_up== 0)) begin
       			`uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINKUP AFTER BAD sync hdrs link_up:%d, timeout_cntr :%d", link_up, timeout_cntr))
      	  	end
       	  	if(link_up == 1) begin
        		`uvm_info(get_type_name(), $sformatf("LINK UP REGAINED AFTER LOSS AS EXPECTED link_up:%d", link_up), UVM_LOW)
      	  	end

      	  	fork begin  
        	//hi_ber should have deasserted now
        	 fork 
          	  begin
            	hi_ber = 1;
            	timeout_cntr_ber = 0;
            	wait(p_sequencer.env.spy_if.o_rx_hi_ber == 1'b0);
            	hi_ber = 0;
          	  end
          	  begin
            	while(hi_ber == 1) begin
              	#2ns;
              	timeout_cntr_ber++;
                	if(timeout_cntr_ber == 18000000) begin
                	break;
              		end
            	end
              end
             join_any
             disable fork;
       	    end
     	    join

       	   	if((timeout_cntr_ber >= 18000000) && (hi_ber ==1 )) begin
         		`uvm_fatal(get_type_name(), $sformatf("TIMEOUT WAITING FOR ihi_ber de-assertion AFTER BAD sync hdrs hi_ber:%d, timeout_cntr_ber :%d", hi_ber, timeout_cntr_ber))
        	end
         	if(hi_ber == 0) begin
         		`uvm_info(get_type_name(), $sformatf("HI_BER DEASSERTED as expected, hi_ber:%d", hi_ber), UVM_LOW)
     	 	end
    

     	 	//For coverage purpose
	 		#1us;
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
      	/*	p_sequencer.env.reg_read(`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data, 1);
      		`uvm_info(get_type_name(), $sformatf("rxpcs_status read value :%h", read_data), UVM_LOW);
	  		if(read_data[0] == 1'b0) begin
	    			`uvm_error(get_type_name(), $sformatf("Expecting rxpcs_status read value should be high"));
	  		end */
      		//check_csr_status(1); //HSD 16011365742

			//	p_sequencer.env.wait_tx_frames_received(.exp_num(100),.timeout_time(200us));
       		//wait before sending frames
			// Re-enabling Scoreboards
     	end //loop_cnt
   	  end
   	 join //tx & rx threads

     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;  
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1;
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;  
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;
     #5us;

	 send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,frame_cnt);
	 send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,frame_cnt);
     `uvm_info(get_type_name(),$sformatf("Sent %0d frames in ETH_VIP_AVL_RX",frame_cnt), UVM_LOW);
	 #250us;
  endtask
endclass
