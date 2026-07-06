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


class fc_rand_an_seq extends an_base_sequence;
	`uvm_object_utils(fc_rand_an_seq)
	 fc_pause_sequence pause_seq;
 
 	 uvm_reg_data_t rd_data;
  	bit[8:0] port_en;//tx_pause_en 
  	bit[8:0] holdoff_en; //retransmit holdoff_en
  	bit[15:0] sfc_holdoff_quanta; //retransmit holdoff_en
  	bit[15:0] sfc_pause_quanta; //retransmit holdoff_en
  
  	bit ready_drop;//should pause enable or disable tx transmission,will cause ready to be dropped,tx of en tx pause q no
  	bit same_holdoff_en;//only in pfc
  	bit [15:0] same_holdoff_quanta;
  	bit [47:0] tx_da; 
  	bit [47:0] tx_sa; 
  	bit [1:0] tx_fc_en;//ehip cfg for tx path 
  	bit[8:0] reg_mode;//to control port or signal/for tb use only 
  	bit[15:0] quanta[]; 
  	bit[15:0] hold_quanta[]; 
  	bit[7:0] rx_pfc_en;//rx_pause_en 
  	bit rx_fc_fwd;//rx frame fwd
  	bit[47:0] rx_da; 
  	bit[1:0] rx_fc_en;//en dis sfc pfc on rx path 
  	uvm_event_pool event_pool;
  	uvm_event wait_fc_reg_write;
  	pcs_cable_pull_no_data_reset_sequence cable_pull_seq;
	function new(string name = "fc_rand_an_seq");
      		super.new(name);
		pause_seq=new("pause_seq");
		cable_pull_seq=new();
		`ifdef UVM_POST_VERSION_1_1
     	 		set_automatic_phase_objection(1);
		`endif
		event_pool = new();
    		event_pool = event_pool.get_global_pool();
    		wait_fc_reg_write = event_pool.get("fc_reg_write");
  	 endfunction:new
	`ifdef UVM_VERSION_1_1
   		virtual task pre_start();
      			lt_on=1;
      			super.pre_start();
  		endtask; // pre_start
  	`endif
	virtual task body();
		string func_name = "fc_rand_an_seq_body";
		port_en=9'h100;//$urandom;//tx_pause_en
   		holdoff_en=0;//9'h1ff;//$urandom;//retransmit xoff en
   		sfc_holdoff_quanta=100;//$urandom;
   		sfc_pause_quanta=500;//$urandom;
   		ready_drop=0;//$urandom;
   		same_holdoff_en=0;//$urandom;
   		same_holdoff_quanta=100;//$urandom;
   		tx_da={$urandom,$urandom}; 
   		tx_sa={$urandom,$urandom};
   		tx_fc_en=1;//$urandom; 
   		rx_pfc_en=8'h01;//$urandom; 
   		rx_fc_fwd=1;//$urandom;
   		rx_da={$urandom,$urandom}; 
   		rx_fc_en=3;//rx side en sfc,en pfc 
   		reg_mode=$urandom; //for tb use only

   		quanta=new[8];
   		hold_quanta=new[8];
   		p_sequencer.env.sb_mac_tx_vip_rx.fc_flag_en = 1;
      		
      		`uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
		pause_seq.fc_mode=reg_mode;
    		pause_seq.pause_pfc=0;
    		pause_seq.same_holdoff=same_holdoff_en;
    		pause_seq.same_holdoff_quanta=same_holdoff_quanta;
  		foreach(quanta[i]) begin
    			quanta[i]=125;
    			pause_seq.pause_quanta[i]=quanta[i];
    			randcase
    				60:  hold_quanta[i]=(quanta[i] *3)/4;
    				20:  hold_quanta[i]=quanta[i];
    				20:  hold_quanta[i]=(quanta[i] *4)/3;
    			endcase
   		end
   		pause_seq.pause_quanta[8]=sfc_pause_quanta;
   		tx_sa[40]=0;
   		tx_da[40]=0;
                p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
		wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
	    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_tx_xof_en_tx_pause_qnumber_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
	  if(rd_data[0]!=0)   `uvm_error("fc_fb_seq1", $sformatf("REGISTERS_tx_xof_en_tx_pause_qnumber_OFFSET_REG bit 0 value must be 0")); // As per FB 586418 ,this register will always have value 0.
	    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
	  if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.rx_fc_fwd)   `uvm_error("fc_fb_seq1uence", $sformatf("REGISTERS_rx_pause_fwd_OFFSET_REG value must be initialized as per parameter"));
	   p_sequencer.env.flow_agent.flow_mon.flow_control=1;
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),port_en); //initial value otherwise dynamic 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),holdoff_en); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_holdoff_quanta); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_pause_quanta); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_xof_en_tx_pause_qnumber_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),ready_drop); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),same_holdoff_en); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),same_holdoff_quanta); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[31:0]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[47:32]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_sa[31:0]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_sa[47:32]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_fc_en);
	 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_pfc_en); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_fc_fwd); 
	 `ifdef ENABLE_ETH_VIP
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[31:0]); //same da for loopback mode only
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[47:32]); 
	   dest_address=rx_da;
	   `else 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[31:0]); //same da for loopback mode only
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[47:32]); 
	   `endif
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_fc_en);

	`uvm_info("fc_fb_seq1", "=========================FLOW CONTROL INFO FOR THIS SIMULATION===================\n",UVM_LOW)
	`uvm_info("fc_fb_seq1", "=========================TX PATH===================\n",UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("Ports Enabled for input:%h...\n",port_en),UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("Ports Enabled for sending automatic holdoff xoff frames:%h...\n",holdoff_en),UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("SFC pause quanta:%h...\n",sfc_pause_quanta),UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("SFC hold quanta:%h...\n",sfc_holdoff_quanta),UVM_LOW)
	    if(ready_drop) `uvm_info("fc_fb_seq1","SFC will inhibit traffic flow...\n",UVM_LOW)
	    else `uvm_info("fc_fb_seq1","SFC will not stop TX traffic...\n",UVM_LOW)
	    if(same_holdoff_en) `uvm_info("fc_fb_seq1",$sformatf("all PFC queues will have same holdoff value which is:%h",same_holdoff_quanta),UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("TX SOURCE ADDR:%h...\n",tx_sa),UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("TX DEST ADDR:%h...\n",tx_da),UVM_LOW)
	    if(tx_fc_en[1]) `uvm_info("fc_fb_seq1","PFC frames will be passed by DUT...\n",UVM_LOW)
	    if(tx_fc_en[0]) `uvm_info("fc_fb_seq1","SFC frames will be passed by DUT...\n",UVM_LOW)
	    `uvm_info("fc_fb_seq1", "=========================RX PATH===================\n",UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("Ports Enabled for output:%h...\n",rx_pfc_en),UVM_LOW)
	    if(rx_fc_fwd) `uvm_info("fc_fb_seq1","Control frames will be forwarded on rx user interface...\n",UVM_LOW)
	    else `uvm_info("fc_fb_seq1","Control frames will not be forwarded on rx user interface...\n",UVM_LOW)
	    `uvm_info("fc_fb_seq1",$sformatf("RX DEST ADDR in VIP mode:%h...\n",rx_da),UVM_LOW)
	    if(rx_fc_en[1]) `uvm_info("fc_fb_seq1","PFC frames will be passed by DUT...\n",UVM_LOW)
	    if(rx_fc_en[0]) `uvm_info("fc_fb_seq1","SFC frames will be passed by DUT...\n",UVM_LOW)
	  
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[0]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[0]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[1]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[1]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[2]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[2]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[3]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[3]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[4]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[4]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[5]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[5]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[6]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[6]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[7]); 
	   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[7]);
	   wait_fc_reg_write.trigger();
	      `uvm_info("fc_fb_seq1", "All fc registers are written, triggered event..\n",UVM_LOW)
	      `uvm_info("fc_fb_seq1", "This test will run in Pause Mode...\n",UVM_LOW)
	      `uvm_info("fc_fb_seq1",$sformatf("PAUSE TIME=%dns\n",12.8*sfc_pause_quanta),UVM_LOW)
	      `uvm_info("fc_fb_seq1",$sformatf("HOLD TIME=%dns\n",12.8*sfc_holdoff_quanta),UVM_LOW)
	     `ifdef ENABLE_ETH_VIP
	      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
	      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
	      fork
	       // pause_seq.start(p_sequencer.fc_sqr);
	        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
			send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);
	       begin
	          repeat(2) begin
	           send_eth_frame(SFC_XOFF_FRAME,ETH_VIP_AVL_RX,3);  
	           send_eth_frame(SFC_XON_FRAME,ETH_VIP_AVL_RX,1);  
	          end
	        end 

	      join
	     `else
	        fork
	           pause_seq.start(p_sequencer.fc_sqr);
	        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
	        join
	     `endif
	     //Check if all tx & rx packets are transmitted/received
	     fork
	     	fork 
	     		wait(p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt==10); 
	     		wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt==10); 
	     	join
	     	begin 
	     		#100us;
	     		`uvm_error("Packet wait", $sformatf("Timeout either waiting for packets to be received by VIP or by DUT. sb_mac_tx_vip_rx received packet count =%d,sb_vip_tx_mac_rx received packet count =%d  ",p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt,p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt));
	     	end
	     join_any
	     disable fork; 
	     //cable pull followed by reset when ehip addr = 21'h1028
	     cable_pull_seq.start(p_sequencer);
	     
	    p_sequencer.env.disable_an_snps_errors();
	  `ifdef CRETE3
		 //reset_spico(); 
	  `endif
		 #5us;
		 check_reset_values();
		 reprogram_an_after_reset();
		 p_sequencer.env.reset_vip();
		 p_sequencer.env.reconfig_vip_for_an_mode();
		 #5us;
		 p_sequencer.env.enable_an_snps_errors();
	   	 p_sequencer.env.mac_callback.link_trans.an73_next_page_bit = 0;
		
		fork : wait_link_up
		 begin
                    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
		    disable wait_link_up;
		 end
		 begin
	  `ifdef CRETE3
		       #3ms;
	  `else
		       #1ms;
	  `endif
		    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
		    disable wait_link_up;
		 end
	      join
	    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
	    p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
	  //  `ifdef OTN_MODE
	  if(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})begin
	    p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
	    p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
           end
	   // `endif
	   // `ifdef FLEXE_MODE
	   // p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_ENABLE_ALL_RULE,1);
	   // p_sequencer.env.ts_tasks_if.do_mon_cfg_pcs66(`ETH_CHECKER_RULE_MODE,3'b111);
	    //`endif
	    
	    //Enable vip(TX)-> DUT(RX) scoreboard
	     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
	     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0; 

	    //`ifndef OTN_MODE	 
	    //`ifndef FLEXE_MODE	
	    //`ifndef EHIP_PCS_ONLY
	    if(!(p_sequencer.env.dyn_rcfg_obj_inst.mode inside {OTN,FLEXE,PCS_ONLY})) begin
	     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1; 
	     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
            end
	    //`endif
	    //`endif
	    //`endif

	    `uvm_info(get_type_name(), "Re-enabled scoreboard", UVM_LOW)

	    fork
	      begin
	        forever begin
	          @(posedge p_sequencer.env.spy_if.clk);
	          if(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready == 1'b0 || (!(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}) && p_sequencer.env.spy_if.rx_am_lock == 1'b0) || p_sequencer.env.spy_if.rx_block_lock == 1'b0) begin
	            `uvm_error(get_type_name(), $sformatf("unexpected link down, rx_pcs_ready = :%d   rx_am_lock = %0d   block_lock = %0d ",p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready,p_sequencer.env.spy_if.rx_am_lock,p_sequencer.env.spy_if.rx_block_lock))
	            `uvm_fatal(get_type_name(), "DUT LINK DOWN UNEXPECTED")
	          end
	        end
	      end
	    join_none

	    repeat(100) @(p_sequencer.env.spy_if.clk);
	      fork
	         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
	         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
	      join
	      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
   endtask // body
endclass: fc_rand_an_seq
