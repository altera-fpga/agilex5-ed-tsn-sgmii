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


class an_restart_during_data_sequence extends an_base_sequence;
   `uvm_object_utils(an_restart_during_data_sequence)
     int rand_delay;
     int num_reset;

      
   function new(string name = "an_restart_during_data_sequence");
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
      string func_name = "restart_an_task";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      // Avoid false errors
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_an73_detect_mv_pair_after_max_time.set_default_fail_effect(svt_err_check_stats::IGNORE); 	
      num_reset = 1; //Vshridhx revisit once build is stable
      //num_reset = $urandom_range(1,10);
      `uvm_info(get_type_name(), $sformatf("%s: Perform reset %0d times - should not affect LT",func_name,num_reset), UVM_NONE);

      p_sequencer.top_env.wait_rx_pcs_ready(speed,node,inst,anlt_std);
      wait_for_seq_mode(speed,inst);

      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,.disable_check(1'b1));

      if ((read_data[21:8]!=14'h8 && speed == _25G) || (read_data[21:8]!=14'h4 && speed == _10G) || (read_data[21:8]!=14'h40 && speed == _40G))
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
         if (read_data[21:8]!=14'h100)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end
      
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
         if (read_data[21:8]!=14'h10)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end 

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
         if (read_data[21:8]!=14'h800)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
         if (read_data[21:8]!=14'h80)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
         if (read_data[21:8]!=14'h20)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
         if (read_data[21:8]!=14'h1000)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
         if (read_data[21:8]!=14'h200)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
         if (read_data[21:8]!=14'h2000)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)) begin
         if (read_data[21:8]!=14'h400)
      `uvm_error(get_type_name(), $sformatf("%s: SEQ mode incorrect",func_name));
       end
      // To avoid false errors
      p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);
      // Send frames + perform reset
      fork : reset_seq
	 begin
	    // Send frames
`ifdef ENABLE_ETH_VIP
	    fork
               send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,inst);  
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,inst);  
            join
`endif
	 end
	 begin
	    for(int i=0; i<num_reset;i++) begin
	       // Reset AN
	       `uvm_info(get_type_name(), $sformatf("%s: Resetting AN",func_name), UVM_LOW);
	       read_data=32'b0;
	       p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed,.disable_check(1'b1));
	       read_data[0]=1'b1;
	       p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed);
	       #5us;
	    end
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
     string func_name = "an_restart_during_data_sequence_body";
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

endclass:an_restart_during_data_sequence
