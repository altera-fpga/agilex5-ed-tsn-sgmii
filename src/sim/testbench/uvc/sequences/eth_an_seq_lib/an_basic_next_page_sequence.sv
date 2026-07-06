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


class an_basic_next_page_sequence extends an_base_sequence;
   `uvm_object_utils(an_basic_next_page_sequence)
   
   function new(string name = "an_basic_next_page_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      an_np_ctrl=1'b1;
      an_bp_ctrl=$urandom_range(0,1);
      next_page_test = 1;
      vip_np_en = 1;
      //vinoth2x: Randomize once the next page feature is ready
      vip_np_num = $urandom_range(2,10);
      super.pre_start();
   endtask:pre_start
  `endif
   
   task automatic an_basic_next_page(speed_e speed, int node, int inst);
      bit [31:0] c1_data;
      bit [47:0] next_page;
      bit [47:0] last_vip_next_page;
      bit [31:0] data_c0_2;
      bit 	 np_bit, prev_np_bit;
      int        np_cnt=0;
      string func_name = "an_basic_next_page_task";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("%s: VIP will send %0d pages",func_name,vip_np_num), UVM_LOW);
      // Program next pages in to C5 and C6 + C1.8
      next_page = {$urandom(),$urandom()};
      // Let first next page have a np_bit SET
      np_bit = 1;
      next_page[15] = np_bit;
      if (np_bit) begin
	 c5_data[15:0] = next_page[15:0];
	 c6_data       = next_page[47:16];
	 c1_data[8] = 1'b1;
	 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg5"),c5_data,speed);
	 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg6"),c6_data,speed);
      end
      // Wait VIP NEXT_PAGE_WAIT
      @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
      wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_NEXT_PAGE_WAIT);
      `uvm_info(get_type_name(), $sformatf("%s: VIP reached NP_WAIT first time",func_name), UVM_LOW);
      // Check content of base page to be correct
      vip_page_received=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip;
      vip_base_page_sent=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
      fork: wait_an_page_rec
	 begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.an_page_rec==1'b1);
	    disable wait_an_page_rec;
	 end // UNMATCHED !!
	 begin
	    #100us;
	    `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for C2.1 (an page received to assert)",func_name));
	 end
      join
      p_sequencer.top_env.check_base_page(speed,node,inst,vip_page_received);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),c7_data,speed,.disable_check(1'b1));
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),c8_data,speed,.disable_check(1'b1));
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
      if ((c7_data[4:0] != vip_base_page_sent[4:0]) // selector
	  || (c7_data[9:5] != vip_base_page_sent[9:5]) // enonce
	  || (c7_data[12:10] != vip_base_page_sent[12:10]) // pause
	  || (c7_data[13] != vip_base_page_sent[13]) // rf
	  || (c7_data[15] != vip_base_page_sent[15]) // np
	  || (c8_data[4:0] != vip_base_page_sent[20:16]) // tnonce
	  || (c8_data[26:5] != vip_base_page_sent[42:21]) // tech ability
	  || (c8_data[31:27] != vip_base_page_sent[47:43]) // fec 
	  )
	`uvm_error(get_type_name(), $sformatf("%s: Page received from VIP incorrect.\nEXP selector=%0x, ACT selector=%0x \nEXP enonce=%0x, ACT enonce=%0x, \nEXP pause=%0x, ACT pause=%0x, \nEXP rf=%0x, ACT rf=%0x, \nEXP np=%0x, ACT np=%0x, \nEXP tnonce=%0x, ACT tnonce=%0x, \nEXP tech ability=%0x, ACT tech ability=%0x, \nEXP fec=%0x, ACT=%0x",func_name,vip_base_page_sent[4:0],c7_data[4:0],vip_base_page_sent[9:5],c7_data[9:5],vip_base_page_sent[12:10],c7_data[12:10],vip_base_page_sent[13],c7_data[13],vip_base_page_sent[15],c7_data[15],vip_base_page_sent[20:16],c8_data[4:0],vip_base_page_sent[42:21],c8_data[26:5],vip_base_page_sent[47:43],c8_data[31:27]));
      
      
      // Give DUT time to reach ack_finished=true
      repeat (2)
	@ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_dme_page_received);
      // Let DUT know that NP is loaded
      p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),c1_data,speed);
      fork : wait_next_page
	 begin	
	    while (np_bit==1 || vip_next_page_sent[15]) begin
	       `uvm_info(get_type_name(), $sformatf("%s: Sending NP#%0d with NP bit in BASE page=%0d and vip next page bit=%d",func_name,np_cnt,np_bit, vip_next_page_sent[15]), UVM_LOW);
	       // Wait VIP ACK DETECT: If VIP is in ACK detect, then DUT has reached NP WAIT
	       @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
	       wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_ACKNOWLEDGE_DETECT);
	       // Check content of next page to be correct
	       vip_page_received=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip;
	       vip_next_page_sent=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
               if (!vip_next_page_sent[15])
		 last_vip_next_page = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
	       // Check next page sent by DUT
	       if (np_bit || prev_np_bit) begin
		  if (vip_page_received[10:0]!=next_page[10:0]
		      || vip_page_received[47:16]!=next_page[47:16])
		    `uvm_error(get_type_name(), $sformatf("%s: Next Page sent incorrect. \nEXP[10:0]=%0x, ACT[10:0]=%0x \nEXP[47:16]=%0x, ACT[47:16]=%0x",func_name,next_page[10:0],vip_page_received[10:0],next_page[47:16],vip_page_received[47:16]));
	       end else begin
		  if (vip_page_received[10:0]!=11'h1
		      || vip_page_received[15]!=1'b0
		      || vip_page_received[47:16]!=32'h0)
		    `uvm_error(get_type_name(), $sformatf("%s: Next Page sent incorrect. \nEXP[10:0]=1, ACT[10:0]=%0x \nEXP[15]=0, ACT[15]=%0x \nEXP[47:16]=0, ACT[47:16]=%0x",func_name,vip_page_received[10:0],vip_page_received[15],vip_page_received[47:16]));
	       end

	       prev_np_bit = np_bit;
               if (np_bit || (!np_bit && vip_next_page_sent[15])) begin
		  // Randomize np_bit
		  // Program next pages in to C5 and C6 + C1.8
		  if(np_bit) begin
                    next_page = {$urandom(),$urandom()};
		    void'(std::randomize(np_bit) with {np_bit dist {1 := 6, 0 := 4};});
                  end
                  else   
                    next_page = 48'h1;
		    next_page[15] = np_bit;
		    c5_data[15:0] = next_page[15:0];
		    c6_data = next_page[47:16];
		    c1_data[8] = 1'b1;
		    p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg5"),c5_data,speed);
		    p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg6"),c6_data,speed);
		    // Wait for DUT to indicate that LP next page is ready
		    fork: wait_c1_8_reset
		       begin
		          read_data[8]=1;
		          while (read_data[8]==1'b1) begin
		             p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed,.disable_check(1'b1));
		             #500ns;
		          end
		          disable wait_c1_8_reset;
		       end
		       begin
		          #200us;
		          `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for C1.8 to deassert",func_name));
		       end
		    join
               end
	       // Check next page received by DUT
	       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),c9_data,speed,.disable_check(1'b1));
	       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),ca_data,speed,.disable_check(1'b1));
	       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
	       if (np_bit==1) begin
		  if (vip_next_page_sent[15]) begin
		     if (vip_next_page_sent[10:0]!=c9_data[10:0]
			 || vip_next_page_sent[47:16]!=ca_data[31:0])
		       `uvm_error(get_type_name(), $sformatf("%s: Next Page received incorrect. \nEXP[10:0]=%0x, ACT[10:0]=%0x \nEXP[47:16]=%0x, ACT[47:16]=%0x",func_name,vip_next_page_sent[10:0],c9_data[10:0],vip_next_page_sent[47:16],ca_data[31:0]));
		  end else begin
		     if (last_vip_next_page[10:0]!=c9_data[10:0]
			 || last_vip_next_page[47:16]!=ca_data[31:0])
		       `uvm_error(get_type_name(), $sformatf("%s: Next Page received incorrect. \nEXP[10:0]=%0x, ACT[10:0]=%0x \nEXP[47:16]=%0x, ACT[47:16]=%0x",func_name,last_vip_next_page[10:0],c9_data[10:0],last_vip_next_page[47:16],ca_data[31:0]));
		  end
	       end
          
	       // Let DUT know that NP is loaded
	       p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),c1_data,speed);
	       np_cnt++;
	    end // while (np_bit==1 || vip_next_page_sent[15])
	    `uvm_info(get_type_name(), $sformatf("%s: No more next pages, wait for AN complete",func_name), UVM_LOW);
		//Enable User Controlled AN Next Pages
           p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),data_c0_2,speed,.disable_check(1'b1));
	       data_c0_2[2]=0;
	       p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),data_c0_2,speed);

	    wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD);
	    vip_page_sent = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
	    // Wait for AN done
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.an_done);
	    `uvm_info(get_name(), $sformatf("%s: AN  is up from DUT side",func_name), UVM_NONE);
	    // Check next page received by DUT
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),c9_data,speed,.disable_check(1'b1));
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),ca_data,speed,.disable_check(1'b1));
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);	    
	    if (last_vip_next_page[10:0]!=c9_data[10:0]
		|| last_vip_next_page[47:16]!=ca_data[31:0])
	      `uvm_error(get_type_name(), $sformatf("%s: Next Page received incorrect. \nEXP[10:0]=%0x, ACT[10:0]=%0x \nEXP[47:16]=%0x, ACT[47:16]=%0x",func_name,last_vip_next_page[10:0],c9_data[10:0],last_vip_next_page[47:16],ca_data[31:0]));

            if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && (vip_page_received[44] || vip_page_sent[44]))
                rs_fec_neg = 1;
              else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && (vip_page_received[45] || vip_page_sent[45]))
                baser_fec_neg_en = 1;
            end

	    // Check AN Status C2
            neg_port = p_sequencer.top_env.get_neg_port(speed,inst);
            exp_read_data = {ll_fec_neg,rs_fec_neg,neg_port[17],neg_port[16:12],neg_port[11:0],neg_fail,consortium_np_rcvd,an_fail,baser_fec_neg_en,an_lp_ability,an_status,an_ability,1'b0,an_adv_rf,an_complete,an_page_rcvd,1'b0};

	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed,.disable_check(1'b1));
            if(read_data[29:9] != exp_read_data[29:9] ||
               read_data[7:0] != exp_read_data[7:0]) 
	      `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP=%0x, ACT=%0x",func_name,exp_read_data,read_data));//need to update for rsfec support
	    // Check page
	    disable wait_next_page;
	 end
	 begin
	    // Timeout loop
	    #4ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for AN to complete",func_name));
	    disable wait_next_page;
	 end
      join
      
      p_sequencer.top_env.wait_for_lt_complete(speed,node,inst);

      // Wait link up
      fork : wait_link_up
	 begin
           `uvm_info(get_type_name(), $sformatf("%s: Waiting for seq ready",func_name), UVM_NONE);
           wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_link_ready == 1'b1);
	   `uvm_info(get_type_name(), $sformatf("seq ready asserted...=%0t", $time), UVM_NONE);
            wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1);
	    `uvm_info(get_type_name(), $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE);
	    `uvm_info("wait_rx_pcs_ready", $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE);
	    p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_LINK_UP.wait_trigger();
	    `uvm_info("wait_rx_pcs_ready", $sformatf("Done waiting VIP to link up...=%0t", $time), UVM_NONE);
	    disable wait_link_up;
	 end
	 begin
	    #2ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
	    disable wait_link_up;
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE)    
  endtask:an_basic_next_page

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "an_basic_next_page_sequence_body";
     `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
     fork
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_10g) begin
           node_idx_10g = get_start_node(_10G);
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_25g);i++) begin
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g + num_inst_10g);inst++) begin
             automatic int idx;
             automatic int i = inst;
             if(i != 0) 
                node_idx_10g++;
             idx = node_idx_10g;
             `uvm_info(get_type_name(), $sformatf("Speed 10G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_10g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_25g) begin
           node_idx_25g = get_start_node(_25G);
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_25g);i++) begin
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g);inst++) begin
             automatic int idx;
             automatic int i = inst;
             if(i != 0) 
                node_idx_25g++;
             idx = node_idx_25g;
             `uvm_info(get_type_name(), $sformatf("Speed 25G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_25g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_40g) begin
           node_idx_40g = get_start_node(_40G);
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_25g);i++) begin
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g);inst++) begin
             automatic int idx;
             automatic int i = inst;
             if(i != 0) 
                node_idx_40g++;
             idx = node_idx_40g;
             `uvm_info(get_type_name(), $sformatf("Speed 40G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_40g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_50g) begin
           node_idx_50g = get_start_node(_50G);
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_50g++;
             idx = node_idx_50g;
             `uvm_info(get_type_name(), $sformatf("Speed 50G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_50g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_100g) begin
           node_idx_100g = get_start_node(_100G);
           for(int inst=(num_inst_400g + num_inst_200g);inst<(num_inst_400g + num_inst_200g + num_inst_100g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_100g++;
             idx = node_idx_100g;
             `uvm_info(get_type_name(), $sformatf("Speed 100G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_100g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
   
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_200g) begin
           node_idx_200g = get_start_node(_200G);
           for(int inst=num_inst_400g;inst<(num_inst_400g + num_inst_200g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_200g++;
             idx = node_idx_200g;
             `uvm_info(get_type_name(), $sformatf("Speed 200G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_200g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_400g) begin
           node_idx_400g = get_start_node(_400G);
           for(int inst=0;inst<num_inst_400g;inst++) begin
             automatic int idx = node_idx_400g;
             automatic int i=inst;
             `uvm_info(get_type_name(), $sformatf("Speed 400G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_400g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]) begin
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - an_basic_next_page Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                   else begin
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - wait_for_linkup Inst: %0d, Node_idx: %0d",i,idx), UVM_NONE);
                     p_sequencer.top_env.env_ip[i].wait_for_linkup(); //pass node as argument after wait_for_linkup task modified to check for active nodes
                     fork
                       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,i);  
                       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,i);  
                     join
                   end
                 end
               join_none
             end
           end
           wait fork;
         end
       end
     join
     `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
   endtask:body

endclass: an_basic_next_page_sequence
