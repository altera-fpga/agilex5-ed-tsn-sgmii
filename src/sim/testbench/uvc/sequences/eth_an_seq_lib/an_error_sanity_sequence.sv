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


class an_error_sanity_sequence extends an_base_sequence;
   `uvm_object_utils(an_error_sanity_sequence)


     function new(string name = "an_error_sanity_sequence");
	super.new(name);
  `ifdef UVM_POST_VERSION_1_1
	set_automatic_phase_objection(1);
  `endif
     endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual   task pre_start();
      randcase
	1: begin
	   an_bp_ctrl=0;
	   an_ovrd_param=0;
	end
	1: begin
	   an_bp_ctrl=1;
	   an_ovrd_param=0;
	end
	1: begin
	   an_bp_ctrl=0;
	   an_ovrd_param=1;
	end
      endcase
      super.pre_start();
   endtask:pre_start
  `endif //  `ifdef UVM_VERSION_1_1
   
   task automatic an_error_injection(speed_e speed, int node, int inst);
      int    max_count=3;
      int    count;
      bit    an_rf;
      bit    cons;
      bit [31:0] xor_result;

     string func_name = "an_error_injection_task";
     `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)

      p_sequencer.top_env.disable_an_snps_errors(speed,inst);
      allow_enable_errors=0;

      p_sequencer.top_env.env_ip[inst].mac_callback.link_trans.an73_technology_ability_field=svt_ethernet_enum_pkg::AN73_TECHNOLOGY_ABILITY_FIELD_USER;
      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,1 );
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE);

      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_BREAK_LINK_TIMER,2750000);
      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TRANSMIT_NONCE_FIELD,$urandom_range(1,31));
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_an73_invalid_rsrvd_tech_abilty_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_an73_nonce_match_in_abilty_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      
      wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal == 'hB0); //wait until CPU transit to TRANSMIT_DISABLE state

      fork : an_restart
	 begin
	    // Timeout loop
	    #7ms;
	    `uvm_error(get_type_name(), $sformatf("%s: AN timeout",func_name));	
	    disable  an_restart;
	 end
	 begin
	    // If AN complete, error out
	    while (1) begin
	       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_AN73_COMPLETE.wait_trigger();
	       `uvm_error(get_type_name(), $sformatf("%s: AN completed unexpectedly",func_name));
	    end
	 end
	 begin
	    // If SEQ goes to LT mode or data mode, error out 
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[13]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[10]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[12]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4))begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[9]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[7]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[11]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[5]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[4]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[8]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
	  if(speed == _40G) begin 
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[6]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
	  if(speed == _25G) begin 
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[3]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
	  if(speed == _10G) begin 
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[1] || p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[2]);
	    `uvm_error(get_type_name(), $sformatf("%s: SEQ switched out of AN mode unexpectedly",func_name));
	    disable an_restart;
       end
	    
	 end 
	 begin
	    // If PCS done, then error out
       wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1);
	    `uvm_error(get_type_name(), $sformatf("%s: PCS ready",func_name));
	    disable an_restart;	    
	 end
	 begin
	    while (count < max_count) begin
	       if(speed == _100G) begin 
                 p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,1 );
	         vip_fec_cap = $urandom_range(15,0);
	         vip_pause_cap = $urandom_range(3,0);
	         vip_rf=$urandom_range(0,1);
	         p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_FEC_CAPABILITY,vip_fec_cap);
                 p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_PCS_PAUSE_CONTROL_MODE,vip_pause_cap);
                 p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_RF_BIT,vip_rf);

               end
                 p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,1 );
                if(anlt_std == CONSORTIUM || anlt_std == IEEE_CONSORTIUM) begin
                  p_sequencer.top_env.reconfig_vip_for_consortium_mode(speed,inst);
                  p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NEXT_PAGE_BIT,1);
                  p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NMBR_NXT_PGE,1);
                  p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_NEXT_PAGE,{5'h0,1'h1,32'h0,11'h5});
                  p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_UNFORMATTED_NEXT_PAGE,{5'h0,1'h0,3'h0,8'b0,21'h0,11'h203});
                end
	       // Wait for VIP to reach COMP_ACK -> it means DUT has sent enough frames + with ACKS
	       @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
	       wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_COMPLETE_ACKNOWLEDGEMENT);
	       p_sequencer.top_env.disable_an_snps_errors(speed,inst);
	       // DUT is in middle of AN
           if (count ==0) begin
             an_rf = 0;
            end
           else begin
             an_rf = an_adv_rf;
           end
	       wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_TRANSMIT_DISABLE);
	       // Wait for DUT TX disable (1us of static tx_serial)
	       wait_an_tx_disable(inst,0);
	       // DUT is in TX disable
	       exp_read_data = 32'h0;
               
               if(anlt_std == IEEE) begin
                  cons =1'b0;
               end
               if(anlt_std == CONSORTIUM) begin
                  cons = 1'b1;
               end
               if(anlt_std == IEEE_CONSORTIUM) begin
                  cons = 1'b1;
               end
               exp_read_data = {20'b0,1'b1,cons,1'b0,1'b0,1'b1,1'b0,1'b1,1'b0,an_adv_rf,1'b0,1'b1,1'b0};

         if (count ==0) begin
           wait (p_sequencer.top_env.env_ip[inst].spy_if.an_negfail==1'b1);
           $display("Vignesh neg_fail");
         end
         else begin
	        wait (p_sequencer.top_env.env_ip[inst].spy_if.an_page_rec==1'b1);
	 end
	       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed,.disable_check(1'b1));
	       // Read second time because an_page_received bit is latch high
	       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed,.disable_check(1'b1));
	       if (read_data != exp_read_data) begin
		  `uvm_error(get_type_name(), $sformatf("%s: AN status incorrect. Exp=%0x, Act=%0x",func_name,exp_read_data,read_data));
	       end
	       count=count+1;
	       `uvm_info(get_type_name(), $sformatf("%s: AN restarted %0d times",func_name,count), UVM_NONE);
	    end
	    disable an_restart;	    
	 end
      join
      
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
          p_sequencer.top_env.disable_an_snps_errors(speed,inst);
          wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal == 'hB0); //wait until CPU transit to TRANSMIT_DISABLE state
          p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);  
      end

      if(anlt_std == IEEE) begin
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
      end
      else if(anlt_std == CONSORTIUM) begin
        vip_np_en = 1;
        vip_np_num = 1;
        p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,vip_np_en,vip_np_num,anlt_std);
      end
      else if(anlt_std == IEEE_CONSORTIUM) begin
        vip_np_en = 1;
        vip_np_num = 1;
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
        p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,vip_np_en,vip_np_num,anlt_std);
      end
     `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)

  endtask:an_error_injection

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "an_error_sanity_sequence_body";
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
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - an_error_injection Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
                     an_error_injection(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                     p_sequencer.top_env.wait_rx_pcs_ready(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i,anlt_std);
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
 
endclass:an_error_sanity_sequence
