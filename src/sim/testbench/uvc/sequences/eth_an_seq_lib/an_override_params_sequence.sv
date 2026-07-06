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


class an_override_params_sequence extends an_base_sequence;
   `uvm_object_utils(an_override_params_sequence)


   function new(string name = "an_override_params_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new

`ifdef UVM_VERSION_1_1
   virtual task pre_start();
      an_ovrd_param=1'b1;
      super.pre_start();
   endtask: pre_start
`endif   
   
   task automatic an_override_param(speed_e speed, int node, int inst);
      string func_name = "an_override_param_task";
      uvm_reg_data_t read_data;
      
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
      // Wait for AN to complete successfully and frame sent should have reconfigured values
      fork : wait_an_complete
	 begin
        if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM}) begin
          @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
          wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_COMPLETE_ACKNOWLEDGEMENT);
	       vip_page_received=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip;
            `uvm_info(get_name(), $sformatf("%s: Base page received by VIP = %0x",func_name,vip_page_received), UVM_LOW);
	       vip_page_sent=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
            `uvm_info(get_name(), $sformatf("%s: Base page sent by VIP = %0x",func_name,vip_page_sent), UVM_LOW);
           wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD);
	      `uvm_info(get_name(), $sformatf("%s: AN  is up from VIP side",func_name), UVM_LOW);  
	       wait (p_sequencer.top_env.env_ip[inst].spy_if.an_done);
	      `uvm_info(get_name(), $sformatf("%s: AN  is up from DUT side",func_name), UVM_LOW);
        end
        if(anlt_std == IEEE) begin
	    wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD);
	    `uvm_info(get_name(), $sformatf("%s: AN  is up from VIP side",func_name), UVM_LOW);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.an_done==1'b1);
	    `uvm_info(get_name(), $sformatf("%s: AN  is up from DUT side",func_name), UVM_NONE);
	    vip_page_received = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip;
	    vip_page_sent = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
        end
            if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM}) begin
              consortium_np_rcvd = 1;
            end
           
            if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && (vip_page_received[44] || vip_page_sent[44]))
                rs_fec_neg = 1;
              else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && (vip_page_received[45] || vip_page_sent[45]))
                baser_fec_neg_en = 1;
            end

            neg_port = p_sequencer.top_env.get_neg_port(speed,inst);
            exp_read_data = {ll_fec_neg,rs_fec_neg,neg_port[17],neg_port[16:12],neg_port[11:0],neg_fail,consortium_np_rcvd,an_fail,baser_fec_neg_en,an_lp_ability,an_status,an_ability,1'b0,an_adv_rf,an_complete,an_page_rcvd,1'b0};

	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed,.disable_check(1'b1));            
            if(read_data[29:9] != exp_read_data[29:9] ||
               read_data[7:0] != exp_read_data[7:0]) 
	      `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP=%0x, ACT=%0x",func_name,exp_read_data,read_data));//need to update for rsfec support

	    `uvm_info(get_type_name(), $sformatf("%s: Page received by VIP=%0x",func_name,vip_page_received), UVM_NONE)
	    if (vip_page_received[12:10] != an_pause
		|| vip_page_received[13] != an_adv_rf
		|| vip_page_received[42:21] != an_tech
		//|| vip_page_received[47:46] != an_fec[1:0]
		) begin
	       `uvm_error(get_type_name(), $sformatf("%s: Page sent to VIP has incorrect fields. \nExpected: Pause Ability=%0x, RF=%0x, Tech ability=%0x, FEC=%0x \nActual: Pause Ability=%0x, RF=%0x, Tech ability=%0x, FEC=%0x",func_name, an_pause,an_adv_rf,an_tech,an_fec,vip_page_received[12:10],vip_page_received[13],vip_page_received[42:21],vip_page_received[47:43]));
	    end
	    disable wait_an_complete;
	 end
	 begin
	    #2.5ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: AN timeout",func_name))
	    disable wait_an_complete;
	 end
join
      /*if(speed == _100G) begin
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,'h1ff);
      end
      else if(speed == _25G) begin
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,'h3ff);
      end */
      // Wait for lt done + PCS ready
      fork : wait_link_up
	  begin
            if(speed == _100G) begin
	      p_sequencer.top_env.disable_snps_errors(speed,inst);
            end
            else if(speed == _25G) begin
              p_sequencer.top_env.disable_10_25G_snps_errors(speed,inst);
            end

	    p_sequencer.top_env.wait_for_lt_complete(speed,node,inst);
        `uvm_info(get_type_name(), $sformatf("%s: Waiting for seq ready",func_name), UVM_NONE);
		  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_link_ready == 1'b1);
		`uvm_info(get_type_name(), $sformatf("seq ready asserted...=%0t", $time), UVM_NONE);
	    `uvm_info(get_type_name(), $sformatf("Waiting for rx pcs ready ...=%0t", $time), UVM_NONE)
       wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1);
	   // wait(p_sequencer.top_env.env_ip[inst].master_agent.mast_agt_if.rx_pcs_ready == 1'b1);
	    `uvm_info(get_type_name(), $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE);
	    `uvm_info("wait_rx_pcs_ready", $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE);
	    p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_LINK_UP.wait_trigger();
	    `uvm_info("wait_rx_pcs_ready", $sformatf("Done waiting VIP to link up...=%0t", $time), UVM_NONE);
            if(speed == _100G) begin
	        repeat(5000)
	        @(posedge p_sequencer.top_env.env_ip[inst].spy_if.clk);
	        p_sequencer.top_env.enable_snps_errors(speed,inst);
              end
              else if(speed == _25G) begin
	        wait(p_sequencer.top_env.env_ip[inst].spy_if.o_tx_lanes_stable == 1'b1);
	        p_sequencer.top_env.enable_10_25G_snps_errors(speed,inst);
              end
	    disable wait_link_up;
	 end
	 begin
	    #2ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
	    disable wait_link_up;
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
  endtask: an_override_param

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "an_override_param_sequence_body";
     `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
     fork
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_10g) begin
           node_idx_10g = get_start_node(_10G);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - an_override_param Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
                     an_override_param(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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

endclass: an_override_params_sequence
