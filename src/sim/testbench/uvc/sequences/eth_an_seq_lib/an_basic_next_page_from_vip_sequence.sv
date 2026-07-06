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


class an_basic_next_page_from_vip_sequence extends an_base_sequence;
   `uvm_object_utils(an_basic_next_page_from_vip_sequence)
   
   function new(string name = "an_basic_next_page_from_vip_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      next_page_test = 1;
      vip_np_en = 1;
      //vinoth2x: Randomize once the next page feature is ready
      //vip_np_num = $urandom_range(2,10);
      vip_np_num = 2;
      super.pre_start();
   endtask:pre_start
  `endif
   
   task automatic an_basic_next_page(speed_e speed, int node, int inst);
                  
      string func_name = "an_basic_next_page_task";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("%s: VIP will send %0d next pages",func_name,vip_np_num), UVM_LOW);

      p_sequencer.top_env.reset_vip(inst);

      if(speed == _25G) begin
        randcase
          1: begin
              anlt_std = IEEE;
              p_sequencer.top_env.vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
             end
          1: begin
              anlt_std = CONSORTIUM;
              consortium_np_rcvd = 1;
              p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,vip_np_en,vip_np_num,anlt_std);
             end
        endcase
      end
      else if(((speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) ||
              (speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) ||
              (speed == _200G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) && 
              p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) 
             begin
               randcase
                 1: begin
                     anlt_std = IEEE;
                     p_sequencer.top_env.vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
                    end
                 1: begin
                     anlt_std = IEEE_CONSORTIUM;
                     consortium_np_rcvd = 1;
                     p_sequencer.top_env.config_vip(speed,inst,vip_np_en,vip_np_num,anlt_std);
                    end
               endcase
             end
      else if((speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) ||
              (speed == _400G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)) begin
              anlt_std = CONSORTIUM;
              consortium_np_rcvd = 1;
              p_sequencer.top_env.vip_dme_page_cfg_consortium_mode(speed,inst,vip_np_en,vip_np_num,anlt_std);
      end
      else begin
        anlt_std = IEEE;
        p_sequencer.top_env.vip_dme_page_cfg(speed,inst,vip_np_en,vip_np_num,anlt_std);
      end

       `uvm_info(get_name(), $sformatf("%s: anlt_standard = %0s",func_name,anlt_std.name), UVM_LOW);

       // Wait VIP NEXT_PAGE_WAIT
       @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
       wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_COMPLETE_ACKNOWLEDGEMENT);
       vip_base_page_received = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip;
       `uvm_info(get_name(), $sformatf("%s: Base page received by VIP = %0x",func_name,vip_base_page_received), UVM_LOW);
       vip_base_page_sent = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
       `uvm_info(get_name(), $sformatf("%s: Base page sent by VIP = %0x",func_name,vip_base_page_sent), UVM_LOW);
       p_sequencer.top_env.check_base_page(speed,node,inst,vip_base_page_received,anlt_std);

      fork : wait_next_page
         begin
           wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal  == 'h110); //Wait DUT moved to COMPLETE_ACK state
           // Check received next pages from VIP
           p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),c7_data,speed,.disable_check(1'b1));
           p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),c8_data,speed,.disable_check(1'b1));
           if ((c7_data[4:0] != vip_base_page_sent[4:0]) // selector
               || (c7_data[9:5] != vip_base_page_sent[9:5]) // enonce
               || (c7_data[12:10] != vip_base_page_sent[12:10]) // pause
               || (c7_data[13] != vip_base_page_sent[13]) // rf
               || (c7_data[15] != vip_base_page_sent[15]) // np
               || (c8_data[4:0] != vip_base_page_sent[20:16]) // tnonce
               || ((anlt_std != CONSORTIUM) && (c8_data[26:5] != vip_base_page_sent[42:21]))
            // || (c8_data[31:27] != vip_page_sent[47:43]) // REvisit:: fec bit disable comparsion 
               )
           `uvm_error(get_type_name(), $sformatf("%s: Base page received from VIP incorrect.\nEXP selector=%0x, ACT selector=%0x \nEXP enonce=%0x, ACT enonce=%0x, \nEXP pause=%0x, ACT pause=%0x, \nEXP rf=%0x, ACT rf=%0x, \nEXP np=%0x, ACT np=%0x, \nEXP tnonce=%0x, ACT tnonce=%0x, \nEXP tech_ability=%0x, ACT tech_ability=%0x, \nEXP FEC=%0x, ACT FEC=%0x",func_name,vip_base_page_sent[4:0],c7_data[4:0],vip_base_page_sent[9:5],c7_data[9:5],vip_base_page_sent[12:10],c7_data[12:10],vip_base_page_sent[13],c7_data[13],vip_base_page_sent[15],c7_data[15],vip_base_page_sent[20:16],c8_data[4:0],vip_base_page_sent[42:21],c8_data[26:5],vip_page_sent[47:43],c8_data[31:27]));
         end
       	 begin
           if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM}) begin
             wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal  == 'h130);
             `uvm_info(get_name(), $sformatf("%s: DUT moved to next page wait first time",func_name), UVM_NONE);
             wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal  == 'h120);
	     vip_page_sent = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op[47:0];
	     `uvm_info(get_name(), $sformatf("%s: Consortium page sent by VIP = %0x",func_name,vip_page_sent), UVM_LOW);
             wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal  == 'h130);
             vip_page_received = p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_ip[47:0];
	     `uvm_info(get_name(), $sformatf("%s: Consortium page received by VIP = %0x",func_name,vip_page_received), UVM_LOW);
            end

	    wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD);
	    // Wait for AN done
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.an_done);
	    `uvm_info(get_name(), $sformatf("%s: AN  is up from DUT side",func_name), UVM_NONE);

            if(anlt_std == IEEE) begin
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && (vip_page_received[44] || vip_page_sent[44]))
                  rs_fec_neg = 1;
                else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && (vip_page_received[45] || vip_page_sent[45]))
                  baser_fec_neg_en = 1;
              end 
              else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
                rs_fec_neg = 1; 
              end
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) begin
                if(((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) ||
                   ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) ||
                   ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4))) 
                    rs_fec_neg = 1;
              end
            end
            else if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM})begin
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _25G) begin
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && vip_page_received[40] && vip_page_sent[40] && (vip_page_received[42] || vip_page_sent[42]))
                  rs_fec_neg = 1;
                else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == FCFEC && vip_page_received[41] && vip_page_sent[41] && (vip_page_received[43] || vip_page_sent[43]))
                  baser_fec_neg_en = 1;
              end
              else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) begin
                if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == RSFECKR && vip_page_received[40] && vip_page_sent[40] && (vip_page_received[42] || vip_page_sent[42]))
                  rs_fec_neg = 1;
              end
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == LLFEC) begin
                if(((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) && (vip_page_received[37] && vip_page_sent[37]) && (vip_page_received[44] || vip_page_sent[44])) ||
                   ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) && (vip_page_received[38] && vip_page_sent[38]) && (vip_page_received[44] || vip_page_sent[44])) ||
                   ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) && (vip_page_received[39] && vip_page_sent[39]) && (vip_page_received[44] || vip_page_sent[44]))) 
                   ll_fec_neg = 1;
                   else 
                     rs_fec_neg = 1;
               end
              end

            neg_port = p_sequencer.top_env.get_neg_port(speed,inst,anlt_std);
            exp_read_data = {ll_fec_neg,rs_fec_neg,neg_port[17],neg_port[16:12],neg_port[11:0],neg_fail,consortium_np_rcvd,an_fail,baser_fec_neg_en,an_lp_ability,an_status,an_ability,1'b0,an_adv_rf,an_complete,an_page_rcvd,1'b0};

	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed,.disable_check(1'b1));
            if(read_data[29:9] != exp_read_data[29:9] ||
               read_data[7:0] != exp_read_data[7:0]) //Revisit:Fec bit disable comparison
           if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) begin
              if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.fec_type == NOFEC) begin //Disable the checker till 21.3, HSD::16013431953 ::Revisit:: Aditya
	             `uvm_info(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP=%0x, ACT=%0x",func_name,exp_read_data,read_data),UVM_LOW);//need to update for rsfec support
               end 
               else begin
	             `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP=%0x, ACT=%0x",func_name,exp_read_data,read_data));//need to update for rsfec support
               end
            end 
           else begin
	          `uvm_error(get_type_name(), $sformatf("%s: AN  STATUS read data is incorrect. EXP=%0x, ACT=%0x",func_name,exp_read_data,read_data));//need to update for rsfec support
           end
	    //p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed,.disable_check(1'b1));

            /*if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM}) begin :: Revisit:: Aditya :: Disabled the checker as per HSD:: 16013345640
              if((ce_data[8:0] != vip_page_sent[8:0]) || (ce_data[18:13] != vip_page_sent[26:20])) //Revisit:vinoth2x - check the register field for 400G_8
                `uvm_error(get_type_name(), $sformatf("%s: Consortium tech received from VIP is incorrect \nEXP Extend tech ability=%0x, ACT Extend tech ability=%0x\nEXP tech ability=%0x, ACT tech ability=%0x",func_name,vip_page_sent[8:0],ce_data[8:0],vip_page_sent[26:20],ce_data[18:13]));
            end*/

	    disable wait_next_page;
	 end // fork begin
	 begin
	    forever begin
	       wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_NEXT_PAGE_WAIT);
	       wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_COMPLETE_ACKNOWLEDGEMENT);
	       vip_next_page_sent=p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_48b_linkword_op;
               wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal  == 'h110); //Wait DUT moved to COMPLETE_ACK state
           // if(anlt_std == IEEE) begin //Revisit:: Aditya Deffered till 21.3 for consortium mode HSD::16013311079 
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),c9_data,speed,.disable_check(1'b1));
               p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),ca_data,speed,.disable_check(1'b1));
               if (vip_next_page_sent[15:0]!=c9_data[15:0] || vip_next_page_sent[47:16]!=ca_data[31:0])
		 `uvm_error(get_type_name(), $sformatf("%s: Next Page received incorrect. \nEXP[15:0]=%0x, ACT[15:0]=%0x \nEXP[47:16]=%0x, ACT[47:16]=%0x",func_name,vip_next_page_sent[15:0],c9_data[15:0],vip_next_page_sent[47:16],ca_data[31:0]));
       //end
	    end
	 end
	 begin
	    // Timeout loop
	    #2ms;
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
	   `uvm_info(get_type_name(), $sformatf("Waiting for rx pcs ready ...=%0t", $time), UVM_NONE)
	    wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready == 1'b1);
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
     string func_name = "an_basic_next_page_from_vip_sequence_body";
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
   		             p_sequencer.top_env.env_ip[i].dynamic_enable_disable_scoreboards(1);
                     an_basic_next_page(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
   		             p_sequencer.top_env.env_ip[i].dynamic_enable_disable_scoreboards(0);
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

endclass:an_basic_next_page_from_vip_sequence
