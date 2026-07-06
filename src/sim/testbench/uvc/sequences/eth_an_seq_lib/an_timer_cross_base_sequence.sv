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


class an_timer_cross_base_sequence extends an_base_sequence;
   `uvm_object_utils(an_timer_cross_base_sequence)
    rand bit dis_an_timer=0;
   rand bit dis_lf_timer=0;
   rand bit dis_mwt_timer=0;   
   rand bit lf_res=0;   
   rand bit skip_lt_an_timeout=0;   
   rand bit lf_hiber=0;
   bit [31:0] b0_reg;
   bit [31:0] d0_reg;
   int 	      an_setting = 1; // 1=>good, 2=>don't start 3=>don't finish
   int 	      lt_setting = 1; // 1=>good, 2=>don't fin
   int 	      pcs_setting = 1; // 1=>good, 2=>hiber/am loss, 3=>am loss
   int 	      repeat_count;
   bit 	      last_iteration_good = 0;
   bit 	      reset_and_end_test=0;
   int 	      next_mode=0;
   bit 	      end_errors=0;
   int 	      max_an_restarts=2;
   bit        dut_hiber_done;
   bit        vip_hiber_done;

                  
   function new(string name = "an_timer_cross_base_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual task pre_start();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
      super.pre_start();
      set_timer_disable();
      override_timer_disable_settings();
      set_anlt_pcs_setting();
      `uvm_info(get_type_name(), $sformatf("Setting dis_an_timer=%0b, \ndis_lf_timer=%0b, \ndis_mwt_timer=%0b, \nlf_res=%0b, \nskip_lt_an_timeout=%0b, \nlf_hiber=%0b",dis_an_timer,dis_lf_timer,dis_mwt_timer,lf_res,skip_lt_an_timeout,lf_hiber), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("Setting an_setting=%0d, \nlt_setting=%0d, \npcs_setting=%0d, \nrepeat_count=%0d",an_setting,lt_setting,pcs_setting,repeat_count), UVM_NONE);
      //dis_lf_timer = (an_on) ? 0 : 1; 
         dis_lf_timer = 1; //HSD::16012978995
         dis_an_timer = 1;
      b0_reg = {17'b0,skip_lt_an_timeout,lf_hiber,lf_res,9'b0,dis_lf_timer,dis_an_timer,1'b1};
     fork
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_10g) begin
           node_idx_10g = get_start_node(_10G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_10g);i++) begin
           //for(int i=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);i<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_25g);i++) begin
             automatic int idx;
             if(i != 0) 
               node_idx_10g++;
             idx = node_idx_10g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_10g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]) begin
                  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_10G);
                  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_10G,.disable_check(1'b1));
                  d0_reg[1] = dis_mwt_timer;
                  d0_reg[15:4]=12'h1;
                  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_10G);
               end
             //join_none
           end
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_25g) begin
           node_idx_25g = get_start_node(_25G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_25g);i++) begin
           //for(int i=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);i<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_25g);i++) begin
             automatic int idx;
             if(i != 0) 
               node_idx_25g++;
             idx = node_idx_25g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_25g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]) begin
                  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_25G);
                  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_25G,.disable_check(1'b1));
                  d0_reg[1] = dis_mwt_timer;
                  d0_reg[15:4]=12'h1;
                  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_25G);
               end
             //join_none
           end
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_40g) begin
           node_idx_40g = get_start_node(_40G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_40g);i++) begin
           //for(int i=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);i<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_25g);i++) begin
             automatic int idx;
             if(i != 0) 
               node_idx_40g++;
             idx = node_idx_40g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_40g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]) begin
                  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_40G);
                  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_40G,.disable_check(1'b1));
                  d0_reg[1] = dis_mwt_timer;
                  d0_reg[15:4]=12'h1;
                  p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_40G);
               end
             //join_none
           end
         end
       end

       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_50g) begin
           node_idx_50g = get_start_node(_50G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_50g);i++) begin
           //for(int i=(num_inst_400g + num_inst_200g + num_inst_100g);i<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);i++) begin
           automatic int idx;
           if(i != 0) 
             node_idx_50g++;
           idx = node_idx_50g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_50g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]) begin
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_50G);
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_50G,.disable_check(1'b1));
                 d0_reg[1] = dis_mwt_timer;
                 d0_reg[15:4]=12'h1;
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_50G);
               end
             //join_none
           end
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_100g) begin
           node_idx_100g = get_start_node(_100G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_100g);i++) begin
           //for(int i=(num_inst_400g + num_inst_200g);i<(num_inst_400g + num_inst_200g + num_inst_100g);i++) begin
           automatic int idx;
           if(i != 0) 
             node_idx_100g++;
           idx = node_idx_100g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_100g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]) begin
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_100G);
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_100G,.disable_check(1'b1));
                 d0_reg[1] = dis_mwt_timer;
                 d0_reg[15:4]=12'h1;
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_100G);
               end
             //join_none
           end
         end
       end
   
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_200g) begin
           node_idx_200g = get_start_node(_200G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_200g);i++) begin
           //for(int i=num_inst_400g;i<(num_inst_400g + num_inst_200g);i++) begin
           automatic int idx;
           if(i != 0) 
             node_idx_200g++;
           idx = node_idx_200g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_200g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]) begin
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_200G);
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_200G,.disable_check(1'b1));
                 d0_reg[1] = dis_mwt_timer;
                 d0_reg[15:4]=12'h1;
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_200G);
               end
             //join_none
           end
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_400g) begin
           node_idx_400g = get_start_node(_400G);
           for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_400g);i++) begin
           //for(int i=0;i<num_inst_400g;i++) begin
           automatic int idx = node_idx_400g;
             //fork
               if(p_sequencer.top_env.kr_cfg_inst.active_400g && p_sequencer.top_env.kr_cfg_inst.node_sel_400g) begin
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"seq_cfg"),b0_reg,_400G);
                 p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_400G,.disable_check(1'b1));
                 d0_reg[1] = dis_mwt_timer;
                 d0_reg[15:4]=12'h1;
                 p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",idx,"lt_cfg1"),d0_reg,_400G);
              end
             //join_none
           end
         end
       end
     join
   endtask:pre_start
   
  `endif   
  virtual task automatic cause_pcs_hiber(speed_e speed, int inst);
      string func_name = "cause_pcs_hiber";
      bit [20:0] xus_timer_preload;
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
          if(speed == _25G) begin
     p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),312500); // Configuring BER timer for 2000 clock cycles
         end
          if(speed == _10G) begin
     p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),19532); // Configuring BER timer for 2000 clock cycles
         end
          if(speed == _50G) begin
     p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),195313); // Configuring BER timer for 2000 clock cycles
     p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,33000);
     p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_XSBI_BER_TIMER,33000);
         end
          if(speed == _100G) begin
     p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),78125); // Configuring BER timer for 2000 clock cycles
     p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,7300);
     p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_XSBI_BER_TIMER,7300);
         end
      `uvm_info(get_type_name(), $sformatf("%s: xus timer force done",func_name), UVM_LOW);
      //wait_for_hiber_window_done_t
      `uvm_info(get_full_name(), $sformatf("%s: Waiting for xus_timer_done",func_name), UVM_LOW);
     fork : wait_xus_done
	begin
	   // When xus timer done, BER SM enters START
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
	   wait (p_sequencer.top_env.env_ip[inst].spy_if.xus_timer_done_25g == 1);
	   disable wait_xus_done;
         end
          else begin
	   wait (p_sequencer.top_env.env_ip[inst].spy_if.xus_timer_done_anlt == 1);
	   disable wait_xus_done;
         end
	end
	begin
	   #1ms;
	   `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for xus timer done",func_name));
	   disable wait_xus_done;
	end
     join;     
      // Insert 100 invalid SH
      for (int i=0;i<97;i++) begin
        if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
          `uvm_info(get_type_name(), $sformatf("%s:  Sending Invalid sync header_100G",func_name), UVM_LOW);
          p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.enable_injection = 1;
//          p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.err_inj_cnt = 0;
//          while (p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.err_inj_cnt < 66)
//          begin
//            #10ns;
//            `uvm_info(get_type_name(), $sformatf("%s: err_inj_cnt : %d",p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.err_inj_cnt,func_name), UVM_MEDIUM)
//          end
        end
        else begin
          if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_100G, _50G}) begin
            @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_66b_block);
            p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_SYNC_HEADER_LANE0, 2'b00);
          end
          else begin 
            p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XSBI_INSERT_SYNC_HEADER, 2'b00);
            @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
          end
        end

        if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
          `uvm_info(get_type_name(), $sformatf("PCR: For ETH2 no need to skip continous sending invalid sync header"), UVM_LOW);
        end
        else begin
          if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_100G, _50G}) begin
            // Wait 20 sh before inserting next bad sh so that block_lock does not break
            repeat (100) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_66b_block);
          end
          else  begin
            repeat (100) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
          end
        end

      end //for loop

      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
        `uvm_info(get_type_name(), $sformatf("PCR: For ETH2 66b event doesnot trigger"), UVM_LOW);
      end
      else begin
        if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_100G, _50G}) begin
          //wait for some time before checking if ber status is flagged by the dut
            repeat(10) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_66b_block);
        end
        else begin
          repeat(10) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
        end
      end

     fork : wait_rx_hiber_done
	begin
	   // wait_rx_hiber_done
	   wait(p_sequencer.top_env.env_ip[inst].spy_if.o_rx_hi_ber == 1);
        if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
          `uvm_info(get_type_name(), $sformatf("PCR: Stopping Invalid sync header_100G for ETH2"), UVM_LOW);
          p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.enable_injection = 0;
        end
	   disable wait_rx_hiber_done;
	end
	begin
	   #500us;
	   `uvm_fatal(get_type_name(), $sformatf("HI BER not set after causing condition"));
	   disable wait_rx_hiber_done;
	end
     join;     

     if(speed == _100G) begin
       if(p_sequencer.top_env.env_ip[inst].spy_if.o_rx_hi_ber !== 1) begin
         `uvm_fatal(get_type_name(), $sformatf("HI BER not set after causing condition"));
       end
     end

     if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
       `uvm_info(get_type_name(), $sformatf("PCR: For ETH2 66b event doesnot trigger"), UVM_LOW);
     end
     else begin
       if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_100G, _50G}) begin
         `uvm_info(get_type_name(), $sformatf("%s: Hi BER asserted",func_name), UVM_LOW);
         repeat(10) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_66b_block);
       end
       else begin
         `uvm_info(get_type_name(), $sformatf("%s: Hi BER asserted",func_name), UVM_LOW);
         repeat(10) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
       end
     end

     // If LF Hiber, then link gets lost soon becuase of HiBER, no need to forcibly deassert HiBER
     if (lf_hiber && !dis_lf_timer) begin
	`uvm_info(get_type_name(), $sformatf("%s: If LF Hiber && !dis_lf_timer, link gets lost, no need to forcibly deassert HiBER",func_name), UVM_LOW);
     end else begin
	// Wait for HiBER to end
	// 1. force xus to a high value so that HiBER ends soon
	#10us;
          if(speed == _25G) begin
              p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),312500); // Configuring BER timer for 2000 clock cycles
              p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,61760);
          end
          if(speed == _10G) begin
              p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),19532); // Configuring BER timer for 2000 clock cycles
              p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,61760);
          end
          if(speed == _50G) begin
              p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),195313); // Configuring BER timer for 2000 clock cycles
              p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,33000);
          end
          if(speed == _100G) begin
               p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),78125); // Configuring BER timer for 2000 clock cycles
               p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,7300);
          end

	fork : wait_xus_done2
	   begin
	      // When xus timer done, BER SM enters START
           if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
	         @(p_sequencer.top_env.env_ip[inst].spy_if.xus_timer_done_25g);
	         disable wait_xus_done2;
           end
             else begin
	         @(p_sequencer.top_env.env_ip[inst].spy_if.xus_timer_done_anlt);
	         disable wait_xus_done2;
           end
       end
	   begin
	   	#1ms;
	      `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for xus timer done",func_name));
	      disable wait_xus_done2;
	   end
	join    
	// Wait for HiBER to enters START_TIMER -> BER_TEST. Set xus_timer again so that o_rx_hi_ber deasserts quickly
	repeat(20) @(p_sequencer.top_env.env_ip[inst].spy_if.clk);
     
          if(speed == _25G) begin
              p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),312500); // Configuring BER timer for 2000 clock cycles
              p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,61760);
          end
          if(speed == _10G) begin
              p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),19532); // Configuring BER timer for 2000 clock cycles
              p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,61760);
          end
          if(speed == _50G) begin
              p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),195313); // Configuring BER timer for 2000 clock cycles
              p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,33000);
          end
          if(speed == _100G) begin
               p_sequencer.top_env.env_ip[inst].reg_write(`GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG, p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed),78125); // Configuring BER timer for 2000 clock cycles
               p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_XSBI_BER_TIMER,7300);
          end
	
	fork : wait_hiber_end
	      `uvm_info(get_type_name(), $sformatf("%s: Check for hiber done started",func_name), UVM_LOW);
	   begin
	      wait (p_sequencer.top_env.env_ip[inst].spy_if.o_rx_hi_ber == 0);
          dut_hiber_done = 1;
	      `uvm_info(get_type_name(), $sformatf("%s: HiBER deasserted",func_name), UVM_LOW);
	   end
       begin
         if(speed == _100G || speed == _50G) begin
           if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
             `uvm_info(get_type_name(), $sformatf("PCR: For ETH2 ber timer event doesnot trigger"), UVM_LOW);
           end
           else begin
             repeat(2)@(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_ber_timer_done);
           end
         end
         vip_hiber_done = 1;
	      `uvm_info(get_type_name(), $sformatf("%s: VIP xus timer done",func_name), UVM_LOW);
       end
       begin
	      `uvm_info(get_type_name(), $sformatf("%s: Check for DUT and VIP hiber done started",func_name), UVM_LOW);
         wait(dut_hiber_done==1 && vip_hiber_done==1);
         `uvm_info(get_type_name(), $sformatf("%s: Check for DUT and VIP hiber done ended",func_name), UVM_LOW);
	      disable wait_hiber_end;
       end
	   begin
	      	#1ms;
	      `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for HiBER to end",func_name));
	      disable wait_hiber_end;
	   end
	join
	repeat(10) @(p_sequencer.top_env.env_ip[inst].spy_if.clk);
     end // if (lf_hiber)
     
     `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
  endtask:cause_pcs_hiber 
   
   virtual task automatic cause_am_lock_loss(speed_e speed, int inst);
      string func_name = "cause_am_lock_loss";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      //Since invalid ams will be introduced which will cause loss of lock, enable all rule checks until lock regained(disabled whether you pass 1/0 to it)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
      for(int i=0;i<16;i++) begin 
         //randomize num of lanes, invalid am on each lane
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_align_block);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB0, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB1, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB2, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB3, $urandom%32);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
      end
    end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
      for(int i=0;i<16;i++) begin 
         //randomize num of lanes, invalid am on each lane
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_align_block);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB0, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB1, $urandom%32);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
      end
    end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
      for(int i=0;i<16;i++) begin 
         //randomize num of lanes, invalid am on each lane
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_align_block);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB0, $urandom%32);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
      end
    end
      if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _40G) begin
      for(int i=0;i<16;i++) begin 
         //randomize num of lanes, invalid am on each lane
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_align_block);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB0, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB1, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB2, $urandom%32);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_VLAB3, $urandom%32);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
      end
    end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed ==_25G) begin
      for(int i=0;i<40;i=i+2) begin 
         //randomize num of lanes, invalid am on each lane
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_load_align_marker_error);
         //p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM_LANE0,24'haaaaaa);
         p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM0_NIBBLE,0);
         p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM0_NIBBLE,2);
         p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM0_NIBBLE,4);
         p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM0_NIBBLE,9);
        //p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM1_NIBBLE,1);
        //p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM1_NIBBLE,4);
        //p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM1_NIBBLE,11);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
      end
    end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
      for(int i=0;i<16;i=i++) begin
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_load_align_marker_error);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE0,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE1,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE2,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE3,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE4,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE5,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE6,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE7,48'haaaa_aaaa_aaaa);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
        end
      end

     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) begin
      for(int i=0;i<16;i=i++) begin
         @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_load_align_marker_error);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE0,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE1,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE2,48'haaaa_aaaa_aaaa);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_CDXBI_UNIQUE_AM_LANE3,48'haaaa_aaaa_aaaa);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
        end
      end 
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
      for(int i=0;i<16;i=i++) begin
        @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_load_align_marker_error);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM_LANE0,24'hfab958);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM_LANE1,24'hfab958);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
        end
      end 
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
        int i = 0;
       while (i<16) begin
        @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_load_align_marker_error);
        p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XXVSBI_LSBI_AM_LANE0,24'hfab958);
         `uvm_info(get_type_name(), $sformatf("inserted invalid_am i:%d", i), UVM_LOW);
          i++;
        end
      end 

      fork: wait_am_loss
	 begin
	    wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_am_lock == 1'b0);
        `uvm_info(get_type_name(), $sformatf("rx_am_lock low as expected "), UVM_LOW)
           if(speed == _100G)
	    repeat(40) @(posedge p_sequencer.top_env.env_ip[inst].spy_if.clk);
	   else
	    //repeat(80) @(posedge p_sequencer.top_env.env_ip[inst].spy_if.clk);
       wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b0);
	    //Check that am_lock is deasserted
	    if ( (p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b0) )  begin
               `uvm_info(get_type_name(), $sformatf("rx_pcs_ready low as expected "), UVM_LOW)
		 end
	    else begin
               `uvm_error(get_type_name(), $sformatf("rx_pcs_ready:%d expected to go low ",p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready));
	    end
	    disable wait_am_loss;
	 end // fork
	 begin
	    #100us;
	    `uvm_fatal(get_type_name(), $sformatf("Tineout waiting for am_lock_loss"));
	    disable wait_am_loss;
	 end
      join
     
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
   endtask:cause_am_lock_loss
   
    virtual task automatic wait_for_link_trained(speed_e speed = _25G, int node = 0, int inst = 0, bit skip_c3_delay=1'b0, bit skip_reconfig=1'b0);
      string func_name = "wait_for_link_trained";
      uvm_reg_data_t read_data,lt_cfg;
       bit lt_timeout_en=0;
       bit max_disable_timer=0;
       bit [31:0] lane_status;
       bit [31:0] exp_lane_status;
       bit max_timeout_expire;
       uvm_status_e      status;
       bit [31:0] c3_read_data;
       bit [7:0] vip_lt_done;
        `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);

        p_sequencer.top_env.gdr_ral_read_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"lt_cfg1")),.read_data(read_data),.speed(speed)); // Need to Review 
        lt_on = read_data[0];//LT Enable
        `uvm_info(get_name(), $sformatf("%s: LT CFG(add :0xd0) register read data :%0h",func_name,read_data), UVM_NONE);
        
        if (lt_on) begin

         #125us;
         p_sequencer.top_env.enable_lt_snps_errors(speed,inst);

        if (!skip_reconfig)
          p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,inst);
      // Wait for SEQ AN mode

      fork : wait_seq_lt
	 begin
	     wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane0 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
             vip_lt_done[0] = 1'b1;
            `uvm_info("wait_for_link_trained", $psprintf("lane 0 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	 end	 
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 1) begin
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane1 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[1] = 1'b1;
              `uvm_info("wait_for_link_trained", $psprintf("lane 1 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane2 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[2] = 1'b1;
              `uvm_info("wait_for_link_trained", $psprintf("lane 2 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end	    
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 2) begin
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane3 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[3] = 1'b1;
              `uvm_info("wait_for_link_trained", $psprintf("lane 3 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end 
	 begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	        wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane4 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
                vip_lt_done[4] = 1'b1;
               `uvm_info("wait_for_link_trained", $psprintf("lane 4 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end
	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane5 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[5] = 1'b1;
              `uvm_info("wait_for_link_trained", $psprintf("lane 5 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end
	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane6 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[6] = 1'b1;
              `uvm_info("wait_for_link_trained", $psprintf("lane 6 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end
	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num > 4) begin
	       wait(p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_training_state_lane7 == svt_ethernet_status::LINK_READY_TO_SEND_DATA_ON_WAIT_TIMER_DONE);
               vip_lt_done[7] = 1'b1;
              `uvm_info("wait_for_link_tarined", $psprintf("lane 7 up : exp lt_status1 :0h",lane_status), UVM_NONE);
	    end
	 end
         begin
	    #4ms;
	    `uvm_error(get_type_name(), $sformatf("%s: LT timeout",func_name)); 
          disable wait_seq_lt; 
	 end

	  begin
	    if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) begin
             wait(vip_lt_done==1'b1);
            end
	    else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
             wait(vip_lt_done==2'b11);
            end
	    else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4) begin
             wait(vip_lt_done==4'b1111);
            end
	    else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8) begin
             wait(vip_lt_done==8'b1111_1111);
            end
            p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
            disable wait_seq_lt; 
        end
      join

      p_sequencer.top_env.env_ip[inst].mac_cfg.cfg[0].enable_autoadaptation = 0;
      p_sequencer.top_env.env_ip[inst].mac_cfg.cfg[0].enable_autoadaptation_pam = 0;
   end // if (lt_on)
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW);
endtask:wait_for_link_trained


   virtual task automatic override_timer_disable_settings();
      int ovrd_dis_an_timer, ovrd_dis_lf_timer, ovrd_dis_mwt_timer, ovrd_lf_hiber, ovrd_lf_res, ovrd_skip_lt_an_timeout;
      string func_name = "override_timer_disable_settings";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      
      if ($value$plusargs("dis_an_timer=%d",ovrd_dis_an_timer)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Override dis_an_timer to %0d",func_name, ovrd_dis_an_timer), UVM_NONE);
	 dis_an_timer = ovrd_dis_an_timer;
      end
      if ($value$plusargs("dis_lf_timer=%d",ovrd_dis_lf_timer)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Override dis_lf_timer to %0d",func_name, ovrd_dis_lf_timer), UVM_NONE);
	 dis_lf_timer = ovrd_dis_lf_timer;
      end
      if ($value$plusargs("dis_mwt_timer=%d",ovrd_dis_mwt_timer)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Override dis_mwt_timer to %0d",func_name, ovrd_dis_mwt_timer), UVM_NONE);
	 dis_mwt_timer = ovrd_dis_mwt_timer;
      end
      if ($value$plusargs("lf_hiber=%d",ovrd_lf_hiber)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Override lf_hiber to %0d",func_name, ovrd_lf_hiber), UVM_NONE);
	 lf_hiber = ovrd_lf_hiber;
      end
      if ($value$plusargs("lf_res=%d",ovrd_lf_res)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Override lf_res to %0d",func_name, ovrd_lf_res), UVM_NONE);
	 lf_res = ovrd_lf_res;
      end
      if ($value$plusargs("skip_lt_an_timeout=%d",ovrd_skip_lt_an_timeout)) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Override skip_lt_an_timeout to %0d",func_name, ovrd_skip_lt_an_timeout), UVM_NONE);
	 skip_lt_an_timeout = ovrd_skip_lt_an_timeout;
      end
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
   endtask:override_timer_disable_settings
       
   virtual task automatic set_timer_disable();
      string func_name = "set_timer_disable";      
      if (!std::randomize(dis_an_timer))      
	`uvm_error("std::randomize", $sformatf("Randomize dis_an_timer fail"));
      if (!std::randomize(dis_lf_timer))      
	`uvm_error("std::randomize", $sformatf("Randomize dis_lf_timer fail"));
      if (!std::randomize(dis_mwt_timer))      
	`uvm_error("std::randomize", $sformatf("Randomize dis_mwt_timer fail"));
      // FIX ME: Added constraint because MWT timer expiry cannot be tested. Please remove when fixed.
      if (!std::randomize(lf_res) with {if (!dis_mwt_timer) lf_res==1'b0;})      
	`uvm_error("std::randomize", $sformatf("Randomize lf_res fail"));
      if (!std::randomize(skip_lt_an_timeout))      
	`uvm_error("std::randomize", $sformatf("Randomize skip_lt_an_timeout fail"));
      if (!std::randomize(lf_hiber))      
	`uvm_error("std::randomize", $sformatf("Randomize lf_hiber fail"));
      
   endtask:set_timer_disable
   
   virtual   task automatic check_stuck_in_an_mode_forever(speed_e speed, int node, int inst);
      string func_name = "check_stuck_in_an_mode_forever";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      fork : wait_seq_an
	 begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode==6'h01);
	    disable wait_seq_an;
	 end // UNMATCHED !!
	 begin
	    #800us;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for AN SEQ mode",func_name));
	 end
      join
      // VIP should not receive AN data from DUT during lf timer disabled
      fork: wait_an
	 begin
	    wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD);
	    `uvm_fatal(get_type_name(), $sformatf("%s: AN should not complete",func_name));
	    disable wait_an;
	 end
	 begin
	    #1ms;
	    disable wait_an;
	 end
      join
      // Wait link up
      fork : wait_link_up2
	 begin
       wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b1);
	    `uvm_fatal(get_type_name(), $sformatf("%s: Link should not come up when dis_lf_timer=1",func_name));
	    disable wait_link_up2;
	 end
	 begin
	       #1ms;
	    disable wait_link_up2;
	 end
      join  
      // Read SEQ mode
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,.disable_check(1'b1));
      // Check SEQ mode
      if(read_data[15:8] != 'h01) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP AN mode",func_name));
      // Check link status
      if (read_data[0] != link_up_status)
	`uvm_error(get_type_name(), $sformatf("%s: Link up status is incorrect. EXP=%0b, ACT=%0b",func_name,link_up_status,read_data[0]));
      // Check AN timeout status
      if (read_data[1] != an_timeout_status)
	`uvm_error(get_type_name(), $sformatf("%s: AN timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,an_timeout_status,read_data[1]));
      // Check LT timeout status
      if (read_data[2] != lt_timeout_status)
	`uvm_error(get_type_name(), $sformatf("%s: LT timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,lt_timeout_status,read_data[2]));      
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);   
   endtask:check_stuck_in_an_mode_forever
   
   virtual   task automatic check_stuck_in_lt_mode_forever(speed_e speed, int node, int inst);
      string func_name = "check_stuck_in_lt_mode_forever";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for SEQ to enter LT mode",func_name), UVM_LOW);
      fork : wait_seq_lt
	 begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode==6'h02);
	    disable wait_seq_lt;
	 end // UNMATCHED !!
	 begin
	    #1ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for LT SEQ mode",func_name));
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: Done waiting for SEQ to enter LT mode",func_name), UVM_LOW);
      // Wait link up
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for PCS ready",func_name), UVM_LOW);
      fork : wait_link_up2
	 begin
       wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b1);
	    `uvm_info(get_type_name(), $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE);
	    `uvm_fatal(get_type_name(), $sformatf("%s: Link should not come up when dis_mwt_timer=1",func_name));
	    disable wait_link_up2;
	 end
	 begin
	       #2ms;
	    `uvm_info(get_type_name(), $sformatf("%s: Timeout waiting for PCS ready",func_name), UVM_LOW);
	    disable wait_link_up2;
	 end
      join
      // Read SEQ mode
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,.disable_check(1'b1));
      // Check SEQ mode
      if(read_data[15:8] != 'h02) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP LT mode",func_name));
      // Check link status
      if (read_data[0] != link_up_status)
	`uvm_error(get_type_name(), $sformatf("%s: Link up status is incorrect. EXP=%0b, ACT=%0b",func_name,link_up_status,read_data[0]));
      // Check AN timeout status
      if (read_data[1] != an_timeout_status)
	`uvm_error(get_type_name(), $sformatf("%s: AN timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,an_timeout_status,read_data[1]));
      // Check LT timeout status
      if (read_data[2] != lt_timeout_status)
	`uvm_error(get_type_name(), $sformatf("%s: LT timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,lt_timeout_status,read_data[2]));      
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);   
   endtask:check_stuck_in_lt_mode_forever
   
   virtual   task automatic check_stuck_in_data_mode_forever(speed_e speed, int node, int inst);
      string func_name = "check_stuck_in_data_mode_forever";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for SEQ to enter Data mode",func_name), UVM_LOW);
      fork : wait_seq_data
	 begin
                wait_for_seq_mode(speed,inst);
	    	     disable wait_seq_data;
	 end // UNMATCHED !!
	 begin
	    #1ms;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for Data SEQ mode",func_name));
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: Done waiting for SEQ to enter data mode",func_name), UVM_LOW);
      // Wait link up
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for PCS ready",func_name), UVM_LOW);
       p_sequencer.top_env.disable_10_25G_snps_errors(speed,inst);
      fork : wait_link_up2
        begin
          if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2 https://hsdes.intel.com/appstore/article/#/16013424478
            wait(p_sequencer.top_env.env_ip[inst].spy_if.o_rx_hi_ber==1'b1);
            `uvm_info(get_type_name(), $sformatf("Rx pcs hi_ber asserted...=%0t", $time), UVM_NONE)
            disable wait_link_up2;
          end
          else begin
            wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b1);
            `uvm_info(get_type_name(), $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE)
            `uvm_fatal(get_type_name(), $sformatf("%s: Link up unexpectedly",func_name));
            disable wait_link_up2;
          end
        end
	 begin
          if(speed == _100G) begin
	    #1ms;
          end
          if(speed == _25G) begin
	    #400us;
          end
          if(speed == _10G) begin
	    #400us;
          end
          if(speed == _50G) begin
	    #500us;
          end
	    disable wait_link_up2;
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: Done waiting for PCS ready or hi_ber",func_name), UVM_LOW);
      // Read SEQ mode
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,.disable_check(1'b1));
      // Check SEQ mode
          if(speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2 ) begin
      if(read_data[21:8] != 'h80) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1 ) begin
      if(read_data[21:8] != 'h800) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4 ) begin
      if(read_data[21:8] != 'h20) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _25G) begin
      if(read_data[21:8] != 'h08) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _10G) begin
      if(read_data[21:8] != 'h04) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _40G) begin
      if(read_data[21:8] != 'h40) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) begin
      if(read_data[21:8] != 'h10) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1 ) begin
      if(read_data[21:8] != 'h100) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _200G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2 ) begin
      if(read_data[21:8] != 'h1000) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _200G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4 ) begin
      if(read_data[21:8] != 'h200) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _400G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4 ) begin
      if(read_data[21:8] != 'h2000) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
          if(speed == _400G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8 ) begin
      if(read_data[21:8] != 'h400) 
	`uvm_error(get_type_name(), $sformatf("%s: SEQ recofig mode is incorrect. EXP data mode",func_name));
    end
      // Check link status
      if (read_data[0] != link_up_status)
	`uvm_error(get_type_name(), $sformatf("%s: Link up status is incorrect. EXP=%0b, ACT=%0b",func_name,link_up_status,read_data[0]));
      // Check AN timeout status
      if (read_data[1] != an_timeout_status)
	`uvm_error(get_type_name(), $sformatf("%s: AN timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,an_timeout_status,read_data[1]));
      // Check LT timeout status
      if (read_data[2] != lt_timeout_status)
	`uvm_error(get_type_name(), $sformatf("%s: LT timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,lt_timeout_status,read_data[2]));
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);   
   endtask:check_stuck_in_data_mode_forever
   
   virtual task automatic set_anlt_pcs_setting();
      an_setting = 1; // 0=>good, 1=>don't start 2=>don't finish
      lt_setting = 1; // 0=>good, 1=>don't fin
      pcs_setting = 1; // 0=>good, 1=>hiber/am loss, 2=>am loss
      repeat_count = 1;
      last_iteration_good = 0;
   endtask:set_anlt_pcs_setting
   
   task automatic wait_lt_timeout(speed_e speed, int node, int inst);
      string func_name = "wait_lt_timeout";
      uvm_reg_data_t read_data;
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for LT timeout",func_name), UVM_NONE);
      
      fork : wait_lt_timeout
	 begin
	    // FIX ME: Fix in 19.1 when FB 605333 is fixed
//	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode==6'h02);
//	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode!=6'h02);
//	   `else
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode==6'h02);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_timeout);
	    `uvm_info(get_type_name(), $sformatf("%s: Done waiting for LT timeout",func_name), UVM_NONE);
	    // Check status
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,.disable_check(1'b1));
	    if (read_data[2]!=1'b1)
	      `uvm_error(get_type_name(), $sformatf("LT timeout not set as expected"));
	    lt_timeout_status=1;
	    disable wait_lt_timeout;
	 end
	 begin
	    wait(LFI_timer_done==1);
	    #100us;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for LT timeout",func_name));
	 end
      join
   endtask:wait_lt_timeout
   
   task automatic wait_an_timer_timeout(speed_e speed, int node, int inst);
      string func_name = "wait_an_timer_timeout";
      uvm_reg_data_t read_data;
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for AN timeout",func_name), UVM_NONE);
      // Reduce the AN timer for simulation
      wait (!p_sequencer.top_env.env_ip[inst].spy_if.kr_counter_is_running[0]);
      `uvm_info(get_type_name(), $sformatf("%s: Done Waiting for Counter0",func_name), UVM_NONE);
      wait (p_sequencer.top_env.env_ip[inst].spy_if.kr_counter_is_running[0]);
      `uvm_info(get_type_name(), $sformatf("%s: Done Waiting for Counter1",func_name), UVM_NONE);
      #5us;
      `ifdef FALCON_MESA
      uvm_hdl_force("eth_env_top.dut.top.GENKR.alt_ehipc3_fm_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter",an_timeout_time/1000);
      repeat(5) @(p_sequencer.top_env.env_ip[inst].spy_if.clk);
      uvm_hdl_release("eth_env_top.dut.top.GENKR.alt_ehipc3_fm_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter");
      `else
      uvm_hdl_force("eth_env_top.dut.top.GENKR.alt_ehipc3_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter",an_timeout_time/1000);
      repeat(5) @(p_sequencer.top_env.env_ip[inst].spy_if.clk);
      uvm_hdl_release("eth_env_top.dut.top.GENKR.alt_ehipc3_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter");
      `endif //FALCON_MESA
      fork : wait_an_timer_timeout
	 begin
	    `uvm_info(get_type_name(), $sformatf("%s: Waiting for AN timeout",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.an_timeout);
	    if (!AN_timer_done) begin
	       `uvm_error(get_type_name(), $sformatf("%s: AN timeout prematurely. Exp timeout time=%0t ps",func_name,an_timeout_time));
	    end else begin
	       `uvm_info(get_type_name(), $sformatf("%s: Done waiting for AN timeout",func_name), UVM_NONE);
	    end
	    an_timeout_status=1;
	    // Read register
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed,.disable_check(1'b1));
	    // Check AN timeout status
	    if (read_data[1] != an_timeout_status)
	      `uvm_error(get_type_name(), $sformatf("%s: AN timeout status is incorrect. EXP=%0b, ACT=%0b",func_name,an_timeout_status,read_data[1]));
	    disable wait_an_timer_timeout;
	 end
	 begin
	    // AN_timeout
	    wait(AN_timer_done==1);
	    #100us;
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for AN timeout",func_name));
	 end
      join
   endtask:wait_an_timer_timeout

   task automatic wait_mwt_timeout(speed_e speed, int node, int inst);
      string func_name = "wait_mwt_timeout";
      uvm_reg_data_t read_data;
      longint mwt_timeout=0;
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for MWT timeout",func_name), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("%s: Waiting for LT in progress",func_name), UVM_NONE);
      fork : wait_mwt
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
	    `uvm_info(get_type_name(), $sformatf("%s: DONE LT in progress",func_name), UVM_NONE);
	    disable wait_mwt;
	 end
	 begin
	    #2ms;
	    `uvm_fatal(get_type_name(), $sformatf("Timeout waiting for LT in progress"));
	 end
      join
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),d0_reg,speed,.disable_check(1'b1));
      mwt_timeout = d0_reg[15:4] * 419.4 * 1000000000;
      fork : wait_mwt_timeout
	 begin
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[1]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 1 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[2]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[2]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 2 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[3]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[3]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 3 training failure occurred",func_name), UVM_NONE);
          end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[1]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 1 training failure occurred",func_name), UVM_NONE);
        end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
        end
      if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _40G) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[1]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 1 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[2]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[2]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 2 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[3]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[3]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 3 training failure occurred",func_name), UVM_NONE);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
      end
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _400G) begin
         wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[1]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 1 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[2]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[2]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 2 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[3]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[3]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 3 training failure occurred",func_name), UVM_NONE);
         wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[4] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[4] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 4 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[5]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[5]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 5 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[6]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[6]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 6 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[7]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[7]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 3 training failure occurred",func_name), UVM_NONE);
          end
     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _200G) begin
        wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[1]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 1 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[2]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[2]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 2 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[3]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[3]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 3 training failure occurred",func_name), UVM_NONE);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)) begin
           wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
	    wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[1]==0 && // Training complete
		 p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[1]==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 1 training failure occurred",func_name), UVM_NONE);
      end
      if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin
           wait (p_sequencer.top_env.env_ip[inst].spy_if.lt_trained[0] ==0 && // Training complete
         p_sequencer.top_env.env_ip[inst].spy_if.lt_failure[0] ==1); // Training failure
	    `uvm_info(get_type_name(), $sformatf("%s: Lane 0 training failure occurred",func_name), UVM_NONE);
      end
	    `uvm_info(get_type_name(), $sformatf("%s: Done waiting for MWT timeout",func_name), UVM_NONE);
	    // Check status
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_status1"),read_data,speed,.disable_check(1'b1)); //Checking Status through spy if
	    //if (read_data[3]!=1'b1 && read_data[11]!=1'b1 && read_data[19]!=1'b1 && read_data[27]!=1'b1)
	      //`uvm_error(get_type_name(), $sformatf("Training failure status not set as expected"));
	    disable wait_mwt_timeout;
	 end
	 begin
	    #(mwt_timeout);
	    #100us; // Allow some more than expected value time
	    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for MWT timeout",func_name));
	 end
      join
   endtask:wait_mwt_timeout

   task automatic wait_lf_timeout_and_restart_an(speed_e speed, int inst);
      string func_name = "wait_lf_timeout_and_restart_an";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      if (!LFI_timer_done
	  || !one_sec_timer_done
	  ) begin
	 // Wait for LF to timeout in PCS mode
	 fork : restart_an
	    begin
	       wait (LFI_timer_done
		     || one_sec_timer_done
		     );
	       #100us;
	       `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting sequencer to move to AN mode after LFI timeout",func_name));
	    end
	    begin
             if(speed == _100G)
	       wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode!=6'h20);
             if(speed == _25G)
	       wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode!=6'h08);

             if(speed != _100G) begin
	       if (!(LFI_timer_done || one_sec_timer_done))  begin
		     `uvm_error(get_type_name(), $sformatf("%s: Sequencer has exited data mode prematurely",func_name));				
		  end else begin
		     `uvm_info(get_type_name(), $sformatf("%s: Sequencer has exited data mode as expected",func_name), UVM_NONE);
		  end
            end
            if(speed == _100G) begin
              if (!(LFI_timer_done || one_sec_timer_done)) begin
                 `uvm_error(get_type_name(), $sformatf("%s: Sequencer has exited data mode prematurely",func_name));				
              end else begin
                 `uvm_info(get_type_name(), $sformatf("%s: Sequencer has exited data mode as expected",func_name), UVM_NONE);
              end
            end
		  disable restart_an;
	    end
	    join
	 end_errors=1;
	 if (an_on || lt_on) begin
	    // DUT restart AN mode
	    `uvm_info(get_type_name(), $sformatf("%s: LF has timed out in data mode. Go to AN mode",func_name), UVM_LOW);
	    next_mode=0;
	    `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
	    end_errors=1;
	   // p_sequencer.top_env.reset_vip(inst);
	    p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
	    #2us;
	   // p_sequencer.top_env.reset_vip(inst);
	    p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
	 end else begin // if (an_on || lt_on)
	    // VIP in PCS mode - DUT should link up
	    `uvm_info(get_type_name(), $sformatf("%s: VIP continue in data mode",func_name), UVM_NONE);
	  //  p_sequencer.top_env.reset_vip(inst);      
	    p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
	 end
      end else begin
	 `uvm_info(get_type_name(), $sformatf("%s: LT has timed out already. Go to AN mode",func_name), UVM_LOW);
	 next_mode=0;
	 `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);	
      end // else: !if(!LFI_timer_done)
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
   endtask:wait_lf_timeout_and_restart_an
   
   
   task automatic an_timer_cross(speed_e speed, int node, int inst);
      string func_name = "an_timer_cross_task";
      bit    pcs_failed=0;
//      int    next_mode=0;
//      bit    end_errors=0;
      int    an_mode_count=0;
      /*********************
       0: AN mode
       1: LT mode
       2: PCS mode
       3: Reset and end test mode
       ************************/                        
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      for (int i=0;i<repeat_count;i++) begin
	 `uvm_info(get_type_name(), $sformatf("%s: In loop count %0d of %0d",func_name,i,repeat_count), UVM_NONE);
	 // In last iteration, bring up all correctly
	if(speed == _100G) begin
	  p_sequencer.top_env.disable_snps_errors(speed,inst);
        end
        else if(speed == _25G) begin
           p_sequencer.top_env.disable_10_25G_snps_errors(speed,inst);
        end
	 p_sequencer.top_env.enable_lt_snps_errors(speed,inst);
	 if (next_mode==0) begin
	    an_mode_count++;
	    pcs_failed=0;
	    end_errors=0;
	    LT_started=0;
	    AN_timer_done=0;
	    one_sec_timer_done=0;
	    if (an_mode_count==max_an_restarts && next_mode==0) begin // if AN mode is reached back again
	       `uvm_info(get_type_name(), $psprintf("%s: In second iteration set all to come up",func_name,an_mode_count,repeat_count), UVM_LOW);
	       an_setting=1;
	       lt_setting=1;
	       pcs_setting=1;
	    end

	    if (an_on)
	      next_mode=0;
	    else if (lt_on)
	      next_mode=1;
	    else
	      next_mode=2;
	 end
	 case (next_mode)
	   0: begin // AN
	      /////////////////////////////////////////////////////////////////////
	      ////////////////// STAGE 1 //////////////////////////////////////////
	      /////////////////////////////////////////////////////////////////////
	      `uvm_info(get_type_name(), $sformatf("%s: STAGE 1: AN",func_name), UVM_NONE);
	      `uvm_info(get_type_name(), $sformatf("%s: Wait for AN mode",func_name), UVM_NONE);
	      fork : wait_seq_an
		 begin
		    wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode==6'h01);
		    `uvm_info(get_type_name(), $sformatf("%s: In AN seq mode",func_name), UVM_LOW);
		    disable wait_seq_an;
		 end // UNMATCHED !!
		 begin
		    #800us;
		    `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for AN SEQ mode",func_name));
		 end
	      join		   
	      case (an_setting)
		1: begin
		   // Wait to enter AN mode - for when AN has to restart, old AN complete should not be asserted
		  /* p_sequencer.top_env.env_ip[inst].mac_callback.link_trans.an73_technology_ability_field = svt_ethernet_enum_pkg::AN73_TECHNOLOGY_ABILITY_FIELD_USER;
		    `uvm_info(get_type_name(), $sformatf("%s: In AN seq mode Technology ability setting",func_name), UVM_LOW);
                   if(speed == _100G) begin
                      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,'h1ff);
                    end
                   if(speed == _25G) begin
                      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,'h7ff);
                    end*/
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
		   p_sequencer.top_env.env_ip[inst].mac_callback.link_trans.an73_link_fail_inhibit_timer = 4000000;
		   p_sequencer.top_env.wait_for_an_complete(speed,node,inst,anlt_std);
		   //////// NEXT MODE /////////
		   next_mode=lt_on?1:2;
		   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		   ////////////////////////////
		end
		2,3: begin
		   if (an_setting==2) begin
		      // 2=>don't start
		      // Set VIP to data mode so that AN never starts
		      `uvm_info(get_type_name(), $sformatf("%s: AN don't start at all - should timeout or hang",func_name), UVM_NONE);
		      p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
              p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
		   end else begin
		      `uvm_info(get_type_name(), $sformatf("%s: VIP configured in incompatible mode",func_name), UVM_NONE);
		      p_sequencer.top_env.disable_an_snps_errors(speed,inst);
		      // 3=>don't finish
		      // VIP is set to an incompatible ability so that AN keeps restarting
                      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TECHNOLOGY_ABILITY_FIELD,'h1);
                    if(speed == _50G) begin
                      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_BREAK_LINK_TIMER,400000);
                      end
                      else begin
                      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_BREAK_LINK_TIMER,2750000);
                      end
                      p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TRANSMIT_NONCE_FIELD,$urandom_range(0,31));
		      // wait till an good check, then reconfiure VIP mode so that AN times out
		      repeat (2) begin
			 @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
			 wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD_CHECK);
			 p_sequencer.top_env.disable_an_snps_errors(speed,inst);
		      end		      
		      p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
		      p_sequencer.top_env.enable_an_snps_errors(speed,inst);
              p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
		   end
		   if (dis_an_timer) begin
		      check_stuck_in_an_mode_forever(speed,node,inst);
		      //////// NEXT MODE /////////
		      next_mode=3;
		      `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		      ////////////////////////////
		   end else begin
		      // Wait for AN timeout
		      // AN mode is exited after AN Timer expires
		      wait_an_timer_timeout(speed,node,inst);
		      // Decide next mode
		      if (skip_lt_an_timeout) begin
			 `uvm_info(get_type_name(), $sformatf("%s: AN has timed out and skip_lt_an_timeout=1. Go to PCS mode",func_name), UVM_LOW);
			 next_mode=2;
			 `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		      end else begin
			 `uvm_info(get_type_name(), $sformatf("%s: AN has timed out and skip_lt_an_timeout=0. Go to LT mode if enabled",func_name), UVM_LOW);
			 next_mode=lt_on?1:2;
			 `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		      end
		   end
		end
		default: begin
		   // AN good. Just wait for AN to complete
		   p_sequencer.top_env.wait_for_an_complete(speed,node,inst,anlt_std);
		end	   
	      endcase // case (an_setting)
	   end // case: 0
	   1: begin // LT
	      /////////////////////////////////////////////////////////////////////
	      ////////////////// STAGE 2 //////////////////////////////////////////
	      /////////////////////////////////////////////////////////////////////
	      `uvm_info(get_type_name(), $sformatf("%s: STAGE 2: LT",func_name), UVM_NONE);
	      if (!an_on) begin
		 skip_c3_delay=1;
		 LT_started=1;
		 `uvm_info(get_type_name(), $sformatf("%s: AN disabled",func_name), UVM_LOW);
	      end else
		skip_c3_delay=0;
	      	      
	      case (lt_setting)
		1: begin
		   // LT good. Just wait for LT to complete
		   //p_sequencer.top_env.wait_for_lt_complete(speed,node,inst,.skip_c3_delay(skip_c3_delay));
           wait_for_link_trained(speed,node,inst,.skip_c3_delay(skip_c3_delay));
		   `uvm_info(get_type_name(), $sformatf("%s: LT has complete. Go to PCS mode",func_name), UVM_LOW);
		   next_mode=2;
		   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);		   
		end
		2: begin
		   // 1=>don't complete
		   // Set VIP to data mode so that LT never completes
		   p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);

		   case ({dis_mwt_timer,dis_lf_timer,lf_res})
		     3'b0: begin
			if (an_timeout_status || !an_on) begin
			   `uvm_info(get_type_name(), $sformatf("%s: AN has timed out or AN not enabled, wait for MWT timeout",func_name), UVM_LOW);
			   wait_mwt_timeout(speed,node,inst);
			end else begin
			   wait_lt_timeout(speed,node,inst);
			   `uvm_info(get_type_name(), $sformatf("%s: LT has timed out and lf_res=0. Go to AN mode",func_name), UVM_LOW);
			end
			next_mode=0;
			`uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			if (an_on) begin
			  // p_sequencer.top_env.reset_vip(inst);
			   p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
			end
		     end
		     3'b1: begin
			wait_mwt_timeout(speed,node,inst);
			`uvm_info(get_type_name(), $sformatf("%s: MWT has timed out and lf_res=1. Go to PCS mode",func_name), UVM_LOW);
			next_mode=2;
			`uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		     end
		     3'b10: begin
			if (an_timeout_status || !an_on) begin
			   `uvm_info(get_type_name(), $sformatf("%s: AN has timed out or AN not enabled, wait for MWT timeout",func_name), UVM_LOW);
			   wait_mwt_timeout(speed,node,inst);
			   `uvm_info(get_type_name(), $sformatf("%s: MWT has timed out, AN was disabled/ AN timeout occured. And lf_res=0. Restart AN.",func_name), UVM_LOW);
			   next_mode=0;
			   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			   if (an_on) begin
			      //p_sequencer.top_env.reset_vip(inst);
			      p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
			   end			   
			end else begin
			   check_stuck_in_lt_mode_forever(speed,node,inst);
			   next_mode=3;
			   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			end
		     end
		     3'b011: begin
			wait_mwt_timeout(speed,node,inst);
			`uvm_info(get_type_name(), $sformatf("%s: MWT has timed out and lf_res=1. Go to PCS mode",func_name), UVM_LOW);
			next_mode=2;
			`uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		     end
		     3'b100: begin
			if (an_timeout_status || !an_on) begin
			   `uvm_info(get_type_name(), $sformatf("%s: AN has timed out or AN not enabled, dis_mwt_timer=1. Hang in LT mode ",func_name), UVM_NONE);
			   check_stuck_in_lt_mode_forever(speed,node,inst);
			   next_mode=3;
			   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			end else begin
			   wait_lt_timeout(speed,node,inst);
			   `uvm_info(get_type_name(), $sformatf("%s: LT has timed out and lf_res=0. Go to AN mode",func_name), UVM_LOW);
			   next_mode=0;
			   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			   //p_sequencer.top_env.reset_vip(inst);
			   p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
			end
		     end
		     3'b101: begin
			if (an_timeout_status || !an_on) begin
			   `uvm_info(get_type_name(), $sformatf("%s: AN has timed out or AN not enabled, dis_mwt_timer=1. Hang in LT mode ",func_name), UVM_NONE);
			   check_stuck_in_lt_mode_forever(speed,node,inst);
			   next_mode=3;
			   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			end else begin
			   wait_lt_timeout(speed,node,inst);
			   `uvm_info(get_type_name(), $sformatf("%s: LT has timed out and lf_res=0. Go to AN mode",func_name), UVM_LOW);
			   next_mode=0;
			   `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			  // p_sequencer.top_env.reset_vip(inst);
			   p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
			end
		     end
		     3'b110: begin
			check_stuck_in_lt_mode_forever(speed,node,inst);
			next_mode=3;
			`uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		     end
		     3'b111: begin
			check_stuck_in_lt_mode_forever(speed,node,inst);
			next_mode=3;
			`uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
		     end
		   endcase // case ({dis_mwt_timer,dis_lf_timer,lf_res})
		end
		default: begin
		   // LT good. Just wait for LT to complete
		   //p_sequencer.top_env.wait_for_lt_complete(speed,node,inst,.skip_c3_delay(skip_c3_delay));
           wait_for_link_trained(speed,node,inst,.skip_c3_delay(skip_c3_delay));
		end
	      endcase // case (lt_setting)
	   end // case: 1
	   /////////////////////////////////////////////////////////////////////
	   ////////////////// STAGE 3 //////////////////////////////////////////
	   /////////////////////////////////////////////////////////////////////
	   2: begin // PCS
	      `uvm_info(get_type_name(), $sformatf("%s: STAGE 3: PCS",func_name), UVM_NONE);
	      if (pcs_setting==4) begin
		 // PCS dont link up
		 // Do not reconfigure for PCS mode
		 // Disable CL72 snps errors
          if (lt_on == 1'b0) begin
		   p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
         end
          p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
                     if(speed == _25G) begin
			if(an_setting == 1) begin
		        p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
		        end
                      end
		 `uvm_info(get_type_name(), $sformatf("%s: Sending bad sync headers",func_name), UVM_LOW);
		
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		fork : insert_inv_sh_25g
		begin
      		for (int i=0;i<97;i++) begin
	      		p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XSBI_INSERT_SYNC_HEADER, 2'b00);
	      		@(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
	  		repeat (100) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
     			repeat(10) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
      		   end
		 `uvm_info(get_type_name(), $sformatf("%s: Sending bad sync headers Phase 2",func_name), UVM_LOW);
      		for (int i=0;i<15500;i++) begin
	      		p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XSBI_INSERT_SYNC_HEADER, 2'b00);
	      		@(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
	  		repeat (100) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
     			repeat(10) @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
      		   end
			disable insert_inv_sh_25g;
		 end
		 begin
		       #4000us;
		       `uvm_info(get_type_name(), $sformatf("%s: Timeout waiting for Data SEQ mode",func_name),UVM_LOW);
		       `uvm_fatal(get_type_name(), $sformatf("%s: Timeout issue in corrupting data",func_name));
		 end
		 join_none
		end
		else begin
		 fork : insert_inv_sh
		 begin
		    while (1) begin
                 if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
			    `uvm_info(get_type_name(), $sformatf("%s:  Sending Invalid sync header_100G",func_name), UVM_LOW);
                   p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.enable_injection = 1;
                   p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.err_inj_cnt = 0;
                 while (p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.err_inj_cnt < 66)
                   begin
                     #10ns;
                    `uvm_info(get_type_name(), $sformatf("%s: err_inj_cnt : %d",p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.err_inj_cnt,func_name), UVM_MEDIUM)
                   end
                 end
                 else if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed inside {_100G, _50G}) begin
			       @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_10g_multilane_insert_66b_block);
	 		       p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_SYNC_HEADER_LANE0, 2'b00);
                 end
                 else if(speed == _25G) begin
		           p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_err(`ETH_XSBI_INSERT_SYNC_HEADER, 2'b00);
		           @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_xsbi_do_err_loaded);
                 end
		       end
	      end
	     begin
		    while (1) begin
		       if (end_errors) begin
               p_sequencer.top_env.env_ip[inst].g100_ck_corruption_callbacks.enable_injection = 0;
			  `uvm_info(get_type_name(), $sformatf("%s: Stop sending bad sync headers",func_name), UVM_LOW);
			  disable insert_inv_sh;
		       end
		       #1us;
		    end
		  end
	   join_none
	    end

		 `uvm_info(get_type_name(), $sformatf("%s: PCS should not link up",func_name), UVM_NONE);
		 fork : wait_seq_data
		    begin
                wait_for_seq_mode(speed,inst);
		        disable wait_seq_data;
		    end // UNMATCHED !!
		    begin
		       #1500us;
		       `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for Data SEQ mode",func_name));
		    end
		 join
		 `uvm_info(get_type_name(), $sformatf("%s: Done waiting for SEQ to enter data mode",func_name), UVM_LOW);
		 // Wait for LF timer to expire and then AN should restart
		 if (dis_lf_timer) begin
		    `uvm_info(get_type_name(), $sformatf("%s: PCS to not come up and dis_lf_timer=1",func_name), UVM_LOW);
		    check_stuck_in_data_mode_forever(speed,node,inst);
		    end_errors=1;
		    next_mode=3;
	            disable insert_inv_sh_25g;
		    `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);		     
		 end else begin
		    //////////////////////
		    wait_lf_timeout_and_restart_an(speed,inst);
		    //////////////////////////////////////
		    end_errors=1;
		 end
	      end else begin
		 // Wait for PCS
		 fork : wait_link_up
		    begin
               if (lt_on == 1'b0) begin
		       p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
               end
               p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
                      if(speed != _100G) begin
		       if(an_on == 1 && an_setting ==1) begin
                         //REVISIT: vinoth2x
			 /*`ifndef RSFEC
		          p_sequencer.top_env.reconfig_vip_for_an_mode();
                          p_sequencer.top_env.disable_snps_errors();
			 `else
			  p_sequencer.top_env.env_ip[inst].mac_cfg.enable_rs_fec = 1; 
   			  p_sequencer.top_env.env_ip[inst].mac_cfg.enable_fec_cov = 1; 
   			  p_sequencer.top_env.env_ip[inst].mac_cfg.rs_fec_width ='d1;
   			  p_sequencer.top_env.env_ip[inst].mac_cfg.interface_select = 1;
			  p_sequencer.top_env.env_ip[inst].mac_cfg.xxvsbi_rs_fec_mode_align_timer = 'd16;
        		  `uvm_info(get_type_name(), $sformatf("reconfiguring VIP agent config for RSFEC AN-EN:\n",p_sequencer.top_env.env_ip[inst].mac_cfg.print()), UVM_NONE);
         		  p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].reconfigure_via_task(p_sequencer.top_env.env_ip[inst].mac_cfg);
			 `endif*/
		        end
		     end
		       fork : wait_seq_data
			  begin
                   wait_for_seq_mode(speed,inst);
                   disable wait_seq_data;
			  end // fork
			  begin
			     #1500us;
			     `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for Data SEQ mode",func_name));
			  end
		       join

		       fork : t_wait_lf_timeout_and_restart_an
			  if (!dis_lf_timer) begin
			     wait_lf_timeout_and_restart_an(speed,inst);
			     disable wait_link_up;
			  end
		       join_none
               
               `uvm_info(get_type_name(), $sformatf("%s: Waiting for seq ready",func_name), UVM_NONE);
		       wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_link_ready == 1'b1);
		       `uvm_info(get_type_name(), $sformatf("seq ready asserted...=%0t", $time), UVM_NONE);
		       
		       `uvm_info(get_type_name(), $sformatf("%s: Waiting for PCS ready",func_name), UVM_NONE);
               wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b1);
		       `uvm_info(get_type_name(), $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE);

		       `uvm_info("wait_rx_pcs_ready", $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE);
		       p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_LINK_UP.wait_trigger();
		       `uvm_info("wait_rx_pcs_ready", $sformatf("Done waiting VIP to link up...=%0t", $time), UVM_NONE);
		       link_up_status=1;

                       if(speed == _100G) begin
		         repeat(5000)
			 @(posedge p_sequencer.top_env.env_ip[inst].spy_if.clk);
		        end
			else begin
			if(seq_2) begin
     			   `uvm_info(get_name(), $sformatf("For Timer Sequence_2 reduced delay "), UVM_NONE);
		           repeat(5000);
			 end else begin
		         repeat(7000);
		        end
			 @(posedge p_sequencer.top_env.env_ip[inst].spy_if.clk);
		       end

		       p_sequencer.top_env.enable_snps_errors(speed,inst);	       
		       disable wait_link_up;	       
		       disable t_wait_lf_timeout_and_restart_an;
		    end // fork
		    begin
		       #3ms;
		       `uvm_fatal(get_type_name(), $sformatf("%s: Timeout waiting for link up",func_name));
		       disable wait_link_up;
		    end
		 join
		 if (next_mode!=2)
		   continue;
          p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(0);
  `ifdef ENABLE_ETH_VIP
		 fork
		    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,inst);  
		    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,inst);  
		 join
  `endif
		 case (pcs_setting)
		   1 : begin
		      // PCS to link up, do nothing
		      `uvm_info(get_type_name(), $sformatf("%s: PCS to link up, end test",func_name), UVM_NONE);
		      break;
		   end
		   2,3: begin
             if (pcs_setting==2) begin // HiBER
               // Insert HiBER
               cause_pcs_hiber(speed,inst);
               if (lf_hiber && !dis_lf_timer)
                 pcs_failed=1;

		      end
              else begin //pcs_setting = 3
                // Insert AM lock loss
                if (speed != _10G) begin
                  if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
				 `uvm_info(get_type_name(), $sformatf("PCR: For ETH2 AM lock loss will not happen"), UVM_NONE);     
                  pcs_failed=0;
                  end
                  else begin
                    cause_am_lock_loss(speed,inst);
                    pcs_failed=1;
                  end
                end
                else begin
                  pcs_failed=0;
                end
              end

		      if (pcs_failed) begin
			 link_up_status=0; 
			 if (dis_lf_timer) begin
			    // If LF timer is disabled, then stuck in data mode forever
			    // There are 2 possible routes
			    // a. VIP sends PCS data, then PCS will link up
			    // b. VIP sends AN data, then PCS is stuck in data mode forever
			    randcase
			      1: begin
				 // VIP in PCS mode - DUT should link up
				 `uvm_info(get_type_name(), $sformatf("%s: VIP continue in data mode",func_name), UVM_NONE);     
                 wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1'b1);
				 `uvm_info(get_type_name(), $sformatf("%s: Rx pcs ready asserted at time %0t",func_name,$time), UVM_NONE)
				   `uvm_info("wait_rx_pcs_ready", $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE);
				 p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_LINK_UP.wait_trigger();
				 `uvm_info("wait_rx_pcs_ready", $sformatf("Done waiting VIP to link up...=%0t", $time), UVM_NONE);
			      end
			      1: begin
				 // VIP in AN mode - DUT stuck in data mode forever
				 `uvm_info(get_type_name(), $sformatf("%s: VIP continue in AN mode, DUT stuck in data mode forever",func_name), UVM_NONE);  
				 //p_sequencer.top_env.reset_vip(inst);      
				 p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
				 check_stuck_in_data_mode_forever(speed,node,inst);
				 next_mode=3;
				 `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);				 
			      end
			    endcase // randcase
			    // Since DIS LF TIMER is set, reset end test
			    reset_and_end_test=1;
			    break;
			 end else begin // if (dis_lf_timer)
			    // DIS LF Timer=0 && PCS failed hence AN to restart 
			    // Reset VIP
			    if (an_on || lt_on) begin
			      // p_sequencer.top_env.reset_vip(inst);      
			       p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
			       `uvm_info(get_type_name(), $sformatf("%s: PCS failed and dis_lf_timer=0. Go to AN mode",func_name), UVM_LOW);
			       next_mode=0;
			       `uvm_info(get_type_name(), $sformatf("%s: NEXT MODE=%0d",func_name,next_mode), UVM_LOW);
			    end else begin
			       // VIP in PCS mode - DUT should link up
			       `uvm_info(get_type_name(), $sformatf("%s: VIP continue in data mode",func_name), UVM_NONE);
			       //p_sequencer.top_env.reset_vip(inst);      
			       p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
			       next_mode=0;
			    end
			 end
		      end else begin // if (pcs_failed)
			 `uvm_info(get_type_name(), $sformatf("%s: HiBER occured, but lf_hiber=0. Send frames and end",func_name), UVM_NONE); 
			 // HiBER occured, but lf_hiber=0
			 // Send frames and end
              p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
              p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(0);
  `ifdef ENABLE_ETH_VIP
			 fork
			    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,inst);  
			    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,inst);  
			 join
  `endif
			 break;
		      end // else: !if(pcs_failed)
		   end // case: 2,3
		   default : begin
		   end
		 endcase // case (pcs_setting)
	      end // else: !if(pcs_setting==4)
	   end // case: 2
	   3: begin // reset and end test
	      // Reset and end test
	      `uvm_info(get_type_name(), $sformatf("%s: Reset and end test",func_name), UVM_NONE);
	      allow_enable_errors=1;
	      // Disable AN errors
	      p_sequencer.top_env.disable_an_snps_errors(speed,inst);
	      an_timeout_status=0;
	      lt_timeout_status=0;
	      link_up_status=0;
	      // Reset VIP
	     // p_sequencer.top_env.reset_vip(inst);  
	      // Reset sequencer or csr reset
	      randcase
		 1: begin
		   // SEQ reset
		   `uvm_info(get_type_name(), $sformatf("%s: Apply SEQ reset",func_name), UVM_NONE);  
		   read_data=32'b0;
		   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed,.disable_check(1'b1));
		   read_data[0]=1'b1;
		   p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);
           p_sequencer.top_env.disable_an_snps_errors(speed,inst);
		   #5us;
		   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed,.disable_check(1'b1));
                   if(read_data[0] == 1) begin
                      wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal == 'hB0); //wait until CPU transit to TRANSMIT_DISABLE state
                   end
                   else begin
                      wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal == 'h160); //wait until CPU transit to PS_LT_RC state
                   end
		end
		1: begin
		   `uvm_info(get_type_name(), $sformatf("%s: Apply CSR reset",func_name), UVM_NONE); 
		   // CSR reset
                   //REVIST: vinoth2x - check hard/soft reset for KR IP
               p_sequencer.top_env.env_ip[inst].apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
	       p_sequencer.top_env.disable_an_snps_errors(speed,inst);
		   // Reset VIP
		   //p_sequencer.top_env.reset_vip(inst);  
		   #5us;
		   check_reset_values(speed,node,inst);
		   reprogram_an_after_reset(speed,node,inst);
		   #5us;
		   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed,.disable_check(1'b1));
                   if(read_data[0] == 1) begin
                      wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal == 'hB0); //wait until CPU transit to TRANSMIT_DISABLE state
                   end
                   else begin
                      wait(p_sequencer.top_env.env_ip[inst].spy_if.debug_signal == 'h160); //wait until CPU transit to PS_LT_RC state
                   end
		end 
	      endcase // randcase
	      #5us;
	      // Reset VIP
	     // p_sequencer.top_env.reset_vip(inst);  
	      p_sequencer.top_env.reconfig_vip_for_an_mode(speed,inst);
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
	      p_sequencer.top_env.env_ip[inst].mac_callback.link_trans.an73_link_fail_inhibit_timer = 4000000;
        if ((p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) && (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)) begin //ETH2
          p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_BREAK_LINK_TIMER,250000);
        end
          	      // Wait for PCS
              p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
	      p_sequencer.top_env.wait_rx_pcs_ready(speed,node,inst,anlt_std);       
              p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(0);
  `ifdef ENABLE_ETH_VIP
	      fork
		 send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10,inst);  
		 send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10,inst);  
	      join
  `endif
	      break;
	   end // case: 3
	 endcase // case (next_mode)
      end // for (int i=0;i<repeat_count;i++)
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
   endtask:an_timer_cross

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "an_timer_cross_base_sequence_body";
     `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
     fork
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_10g) begin
           node_idx_10g = get_start_node(_10G);
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g + num_inst_40g + num_inst_25g + num_inst_10g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_10g++;
             idx = node_idx_10g;
             if(p_sequencer.top_env.kr_cfg_inst.active_10g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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
             automatic int i=inst;
             if(i != 0) 
               node_idx_25g++;
             idx = node_idx_25g;
             if(p_sequencer.top_env.kr_cfg_inst.active_25g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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
             automatic int i=inst;
             if(i != 0) 
               node_idx_40g++;
             idx = node_idx_40g;
             if(p_sequencer.top_env.kr_cfg_inst.active_40g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_50g);i++) begin
           for(int inst=(num_inst_400g + num_inst_200g + num_inst_100g);inst<(num_inst_400g + num_inst_200g + num_inst_100g + num_inst_50g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_50g++;
             idx = node_idx_50g;
             if(p_sequencer.top_env.kr_cfg_inst.active_50g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_100g);i++) begin
           for(int inst=(num_inst_400g + num_inst_200g);inst<(num_inst_400g + num_inst_200g + num_inst_100g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_100g++;
             idx = node_idx_100g;
             if(p_sequencer.top_env.kr_cfg_inst.active_100g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_200g);i++) begin
           for(int inst=num_inst_400g;inst<(num_inst_400g + num_inst_200g);inst++) begin
             automatic int idx;
             automatic int i=inst;
             if(i != 0) 
               node_idx_200g++;
             idx = node_idx_200g;
             if(p_sequencer.top_env.kr_cfg_inst.active_200g[idx]) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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
           //for(int i=0;i<$countones(p_sequencer.top_env.kr_cfg_inst.active_400g);i++) begin
           for(int inst=0;inst<num_inst_400g;inst++) begin
             automatic int idx = node_idx_400g;
             automatic int i = inst;
             if(p_sequencer.top_env.kr_cfg_inst.active_400g) begin
               fork
                 begin
                   if(p_sequencer.top_env.kr_cfg_inst.node_sel_400g) begin
                     an_timer_cross(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                   end
                   else begin
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

endclass:an_timer_cross_base_sequence
