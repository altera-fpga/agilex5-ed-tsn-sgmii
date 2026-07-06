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


class an_restart_during_lt_sequence extends an_base_sequence;
   `uvm_object_utils(an_restart_during_lt_sequence)
     int rand_delay;
     int num_reset;

      
   function new(string name = "an_restart_during_lt_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      lt_on=1;
      super.pre_start();
   endtask:pre_start
  `endif
   
   task automatic restart_an(speed_e speed, int node, int inst);
      bit [31:0] c3_read_data;
      string func_name = "restart_an_task";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      // Avoid false errors
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE); 	
      num_reset = 1; //Vshridhx revisit once build is stable
      //num_reset = $urandom_range(1,10);
      `uvm_info(get_type_name(), $sformatf("%s: Perform reset %0d times - should not affect LT",func_name,num_reset), UVM_NONE); 
      p_sequencer.top_env.wait_for_an_complete(speed,node,inst,anlt_std);
      
      #400us;// This delay accomodates AN and LT transmission gap from RTL
      `uvm_info(get_type_name(), $sformatf("Delay between AN and LT completes;reconfiguring VIP agent for LT data xfer"), UVM_NONE);
      p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,inst);

      `uvm_info(get_type_name(), $sformatf("%s: Waiting for LT to be in progress",func_name), UVM_LOW)
      // Wait LT training in progress
      fork : wait_lt
	 begin
        if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1 && // Lane 0 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]==1 && // Lane 1 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[2]==1 && // Lane 2 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[3]==1    // Lane 3 training in progress
		  );
	 end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1 && // Lane 0 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]==1  // Lane 1 training in progress
          );
	     end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1); // Lane 0 training in progress
       end
      if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _40G) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1 && // Lane 0 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]==1 && // Lane 1 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[2]==1 && // Lane 2 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[3]==1    // Lane 3 training in progress
		  );
	 end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1); // Lane 0 training in progress
       end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1 && // Lane 0 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]==1 && // Lane 1 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[2]==1 && // Lane 2 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[3]==1 &&   // Lane 3 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[4]==1 &&   // Lane 4 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[5]==1 &&   // Lane 5 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[6]==1 &&   // Lane 6 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[7]==1    // Lane 7 training in progress
		  );
	 end
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1 && // Lane 0 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]==1 && // Lane 1 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[2]==1 && // Lane 2 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[3]==1    // Lane 3 training in progress
		  );
	 end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1 && // Lane 0 training in progress
		  p_sequencer.top_env.env_ip[inst].spy_if.lt_training[1]==1  // Lane 1 training in progress
          );
	     end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_training[0] ==1); // Lane 0 training in progress
       end
	   	    
	    `uvm_info(get_type_name(), $sformatf("%s: Got LT in progress",func_name), UVM_LOW)
	    #10us;
	    disable wait_lt;
	 end
	 begin
	    #2ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for LT",func_name));
	    disable wait_lt;	        
	 end
      join
      for (int i=0; i<num_reset;i++) begin
	  // Reset AN
	  `uvm_info(get_type_name(), $sformatf("%s: Resetting AN",func_name), UVM_LOW);
	  read_data=32'b0;
	  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed,.disable_check(1'b1));
	  read_data[0]=1'b1;
	  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed);
	 randcase
	   1: #5us;
	   1: #10us;
	   1: #20us;
	   1: #40us;
	 endcase
      end
      // Wait link up
      fork : wait_link_up
	 begin
	    if(speed == _100G) begin
	      p_sequencer.top_env.disable_snps_errors(speed,inst);
            end
            else if(speed == _25G) begin
              p_sequencer.top_env.disable_10_25G_snps_errors(speed,inst);
            end 
	    p_sequencer.top_env.wait_for_lt_complete(speed,node,inst,.skip_c3_delay(1'b1),.skip_reconfig(1'b1));
         `uvm_info(get_type_name(), $sformatf("%s: Waiting for seq ready",func_name), UVM_NONE);
		   wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_link_ready == 1'b1);
		  `uvm_info(get_type_name(), $sformatf("seq ready asserted...=%0t", $time), UVM_NONE);
	    `uvm_info(get_type_name(), $sformatf("Waiting for rx pcs ready ...=%0t", $time), UVM_NONE)
	  //  wait(p_sequencer.top_env.env_ip[inst].master_agent.mast_agt_if.rx_pcs_ready == 1'b1);
        wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1);
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
	       #3ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
	    disable wait_link_up;
	 end
      join
      
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE)
  endtask:restart_an

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "an_restart_during_lt_sequence_body";
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
                     `uvm_info(get_type_name(), $sformatf("Speed 10G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 25G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 40G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 50G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_50g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 100G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_100g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 200G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_200g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                     `uvm_info(get_type_name(), $sformatf("Speed 400G - restart_an Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
                     restart_an(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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

endclass:an_restart_during_lt_sequence
