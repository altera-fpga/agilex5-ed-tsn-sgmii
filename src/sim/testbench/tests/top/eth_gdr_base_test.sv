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



class eth_gdr_base_test extends uvm_test;

  `uvm_component_utils(eth_gdr_base_test)
 
   uvm_cmdline_processor  inst;
   string m_sequence = "vip_sanity_sequence";
   bit 	  zero_pkt_check_en =1'b1;
   bit 	  std_am =1'b0;
   
   eth_top_env top_env;
   tsn_axi_agent_cfg m_axi_st_system_cfg;

   `ifdef NON_ANLT_PTP 
	   eth_gdr_multi_instance_sanity_sequence multi_instance_sanity_sequence ;  
	   eth_gdr_multi_instance_random_sequence multi_instance_random_sequence ;  
   `endif
   `ifdef PTP_EN
	   eth_gdr_multi_instance_ptp_sanity_sequence multi_instance_ptp_sanity ;  
	   eth_gdr_multi_instance_ptp_2step_accuracy_sequence multi_instance_ptp_2step_accuracy ;  
   `endif

   int 	  packet_sum[`NUM_INST];
   int 	  num_pkt_to_send=10;
   dyn_rcfg dyn_rcfg_obj_inst[`NUM_INST];
   dyn_rcfg dyn_rcfg_t;
   kr_cfg kr_cfg_inst;
   speed_e speed_info[`NUM_INST];
   string speed_arr[3]='{"1G","100M","10M"};
   rand int speed_s;

   constraint speed_s_c { speed_s dist { 0 := 15, 1 := 6, 2 := 4 }; }

`ifdef ENABLE_ETH_VIP
  `ifdef ETH_MULTI_PORT
     svt_ethernet_multi_port_configuration #(`NUM_OF_PORTS) vip_cfg[`NUM_INST];
  `else
     svt_ethernet_agent_configuration vip_cfg[`NUM_INST];
  `endif

   svt_ethernet_agent_configuration vip_tx_cfg_otn_flexe[`NUM_INST];
   `ifndef NON_ANLT_PTP 
      `ifndef PTP_EN
       svt_ethernet_test_suite_component ts_component[`NUM_INST];
      //svt_ethernet_link_transaction link_transaction[`NUM_INST]; RAMI-REF do we need this?
      `endif
   `endif
   `ifdef COMPL_TC
     `ifdef ETH_MULTI_PORT
      `ifndef SVT_ETHERNET_TEST_SUITE_SINGLE_PORT
        svt_ethernet_test_suite_multi_port_component ts_comp_mp;
      `endif
      svt_ethernet_test_suite_component ts_component;
      virtual svt_ethernet_test_suite_multi_port_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) svt_ethernet_test_suite_multi_port_if_test_inst;
      virtual svt_ethernet_test_suite_if  svt_ethernet_test_suite_if_test_inst;
     `else
      virtual svt_ethernet_test_suite_if  svt_ethernet_test_suite_if_test_inst;
      svt_ethernet_test_suite_component ts_component;
     `endif
  `endif
`endif
   string tb_mode_str;
   int node_index=0;
   int    modes_file_id, modes_line_id;
   uvm_sequence_base seq[`NUM_INST];
   uvm_sequence_base anlt_seq;
   bit anlt_test_seq;
   extern virtual task wait_for_link_up(); 
   extern virtual task send_traffic(int num_pkt_to_send,uvm_phase phase); 
   extern virtual task send_config_to_spy_intf(); 
  

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void end_of_elaboration_phase (uvm_phase phase);
       uvm_phase main_phase = phase.find_by_name("main", 0);
       super.end_of_elaboration_phase (phase);
       uvm_top.set_timeout (50ms);
       main_phase.phase_done.set_drain_time(this, 10000);
       for (int j = 0;j<`NUM_INST;j++) begin
       	  packet_sum[j]=0;
       end  
   endfunction

   virtual function void build_phase(uvm_phase phase);

   super.build_phase(phase);
   top_env = eth_top_env::type_id::create("top_env", this);
   m_axi_st_system_cfg = tsn_axi_agent_cfg::type_id::create("m_axi_st_system_cfg");
   m_axi_st_system_cfg.set_cfg();
   uvm_config_db#(svt_axi_system_configuration)::set(this,"top_env.m_axi_st_env*", "cfg", m_axi_st_system_cfg);
   uvm_config_db#(svt_axi_system_configuration)::set(this,"top_env", "m_axi_system_cfg", m_axi_st_system_cfg);
   `ifdef NON_ANLT_PTP 
   multi_instance_sanity_sequence = eth_gdr_multi_instance_sanity_sequence::type_id::create("multi_instance_sanity_sequence"); 
   multi_instance_random_sequence = eth_gdr_multi_instance_random_sequence::type_id::create("multi_instance_random_sequence"); 
    `endif 
   `ifdef PTP_EN
   multi_instance_ptp_sanity = eth_gdr_multi_instance_ptp_sanity_sequence::type_id::create("multi_instance_ptp_sanity"); 
   multi_instance_ptp_2step_accuracy = eth_gdr_multi_instance_ptp_2step_accuracy_sequence::type_id::create("multi_instance_ptp_2step_accuracy"); 
   `endif
   kr_cfg_inst = kr_cfg::type_id::create("kr_cfg_inst", this);
      /* Get configuration from gdr_modes.txt */ 
   //modes_file_id = $fopen({getenv("REG_LOCAL_ROOT_DIR_PATH"), "/ip/ethernet/alt_ethernet_crete_gdr/testbench/tb/gdr_gen_qhip_files/gdr_modes.txt"}, "r");
   //modes_file_id = $fopen("gdr_modes.txt", "r");
   modes_file_id = $fopen({getenv("REG_LOCAL_ROOT_DIR_PATH"), "/testbench/tests/top/gdr_modes.txt"}, "r");
   if(modes_file_id!=0) begin
     int i = 0;
     while(!$feof(modes_file_id)) begin
       $display("extracting file");
      if($fgets(tb_mode_str,modes_file_id)) begin //modified
       //modes_line_id            = $fgets(tb_mode_str,modes_file_id);
       dyn_rcfg_t               = extract_mode_from_str(tb_mode_str);
       dyn_rcfg_obj_inst[i]   = dyn_rcfg_t;
       speed_info[i]=dyn_rcfg_t.speed;
			 i = i + 1 ;  
       if(dyn_rcfg_t.anlt)
         extract_kr_mode_from_dyn_rcfg(dyn_rcfg_t,kr_cfg_inst);
      end
     end
   end
   else begin
     `uvm_fatal("TEST:NOMODE", {"Mode is not defined, check gdr_mode.txt"});
   end
 `uvm_info("starting base test","srinichauhan 0 base test : in build phase",UVM_NONE);
   // Setup VIP config objects   
`ifdef ENABLE_ETH_VIP
 `uvm_info("starting base test","srinichauhan 1 base test : in build phase",UVM_NONE);
//   for (int i =0 ;i<dyn_rcfg_obj_inst[i] ; i++) begin 
   `ifndef NON_ANLT_PTP
      `ifndef PTP_EN
      for (int i = 0;i<`NUM_INST;i++) begin
       //  ts_comp[i] = svt_ethernet_test_suite_component::type_id::create($sformatf("ts_comp%0d",i), this);
       ts_component[i] = svt_ethernet_test_suite_component::type_id::create($sformatf("ts_component%0d",i), this);
       `uvm_info(get_type_name(), $psprintf("srinichauhan test component created for instance %0d, created is %s",i,ts_component[i].sprint()),UVM_NONE);
       `uvm_info("starting case","srinichauhan 2 base test : created ts component",UVM_NONE)
       end
       `endif
    `endif
   `ifdef COMPL_TC
      `ifdef ETH_MULTI_PORT
        `ifndef SVT_ETHERNET_TEST_SUITE_SINGLE_PORT
          ts_comp_mp = svt_ethernet_test_suite_multi_port_component::type_id::create("ts_comp_mp", this);
        `endif
        ts_component = svt_ethernet_test_suite_component::type_id::create("ts_component", this);
      `else
        ts_component = svt_ethernet_test_suite_component::type_id::create("ts_component", this);
      `endif
  `endif
`endif

    /* Print configuration */
   for (int j = 0;j<`NUM_INST;j++) begin
      `uvm_info(get_type_name(), $psprintf("Dynamic TB RCFG obj for instance %0d, randomized to %s",j,dyn_rcfg_obj_inst[j].sprint()),UVM_NONE);
      uvm_config_db#(dyn_rcfg)::set(this,$sformatf("*env_ip%0d", j),"dyn_rcfg_obj_inst",dyn_rcfg_obj_inst[j]);
   end
    
      `uvm_info(get_type_name(), $psprintf("KR avmm CFG obj randomized to %s",kr_cfg_inst.sprint()),UVM_NONE);
      uvm_config_db#(kr_cfg)::set(this,$sformatf("top_env"),"kr_cfg_inst",kr_cfg_inst);

   // Setup VIP config objects   
`ifdef ENABLE_ETH_VIP
   foreach (dyn_rcfg_obj_inst[i]) begin
      vip_cfg[i]= setup_vip_config(dyn_rcfg_obj_inst[i],i);
      vip_tx_cfg_otn_flexe[i]= setup_vip_tx_config(dyn_rcfg_obj_inst[i],i);
      //link_transaction = svt_ethernet_link_transaction::type_id::create("link_transaction");
   end

   // Send VIP config objects to CFG db
   for (int j = 0;j<`NUM_INST;j++) begin
      `ifdef ETH_MULTI_PORT
      uvm_config_db#(svt_ethernet_multi_port_configuration#(`NUM_OF_PORTS))::set(this,$sformatf("*env_ip%0d", j),"mac_cfg",vip_cfg[j]);
      `else
      uvm_config_db#(svt_ethernet_agent_configuration)::set(this,$sformatf("*env_ip%0d", j),"mac_cfg",vip_cfg[j]);
      `endif
      uvm_config_db#(svt_ethernet_agent_configuration)::set(this,$sformatf("*env_ip%0d", j),"mac_cfg_otn_flexe",vip_tx_cfg_otn_flexe[j]);
      //uvm_config_db#(svt_ethernet_link_transaction)::set(this,$sformatf("*env_ip%0d", j),"link_transaction",link_transaction);
   end

  `ifdef COMPL_TC
    `ifdef ETH_MULTI_PORT
        uvm_config_db#(virtual svt_ethernet_test_suite_multi_port_if#(`NUM_OF_PORTS))::get(this,"","if_directed_mp", svt_ethernet_test_suite_multi_port_if_test_inst);
        uvm_config_db#(virtual svt_ethernet_test_suite_if)::get(this,"", "if_directed", svt_ethernet_test_suite_if_test_inst);
     `else
        uvm_config_db#(virtual svt_ethernet_test_suite_if)::get(this,"", "if_directed", svt_ethernet_test_suite_if_test_inst);
     `endif
  `endif
`endif // !`ifdef ENABLE_ETH_VIP

   inst = uvm_cmdline_processor::get_inst();
   inst.get_arg_value("+m_sequence=",m_sequence);
   `uvm_info("eth_gdr_base_test", $psprintf("sequnce set from commnad line is %0s",m_sequence),UVM_NONE);   

endfunction // build_phase

virtual task reset_phase(uvm_phase phase);
  phase.raise_objection(this);
  send_config_to_spy_intf(); //Added here to pass the spy_info to assertion file.
    `ifdef ENABLE_ETH_VIP
    foreach (dyn_rcfg_obj_inst[i]) begin
       	 $cast(top_env.env_ip[i].ts_tasks_if.speed, dyn_rcfg_obj_inst[i].speed);
    end
    `endif
   `uvm_info("eth_gdr_base_test", $psprintf("Reset Phase Apply Reset"),UVM_MEDIUM);   
   for (int i=0;i<`NUM_INST;i++) begin
      automatic int idx=i;
      int rst_sel; 
      int rst_sig_1;
      string rst_type="hard";
      int reset_type;
      rst_sel = 2; //$urandom_range(1,5);   ///mprash2x: LL10g DB 
      if(rst_sel == 1) rst_sig_1 = 1;  //IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      else if(rst_sel == 5) rst_sig_1 = 0; // No Reset
      rst_sig_1 = 7; //FTILE: applied all resets
      
      reset_type = 1; // $urandom_range(1,2);
      if(reset_type == 1) rst_type = "hard";
      else rst_type = "soft";
      `uvm_info(get_full_name(), $sformatf("Inside base test, rst_sig_1 := %0d , Reset type is %0s",rst_sig_1, rst_type),UVM_LOW)
      
      fork
      begin
         if(dyn_rcfg_obj_inst[idx].ptp == 0)begin
           `ifdef NON_ANLT_PTP
           if(rst_sel == 5) begin
            `uvm_info(get_full_name(), $sformatf("Inside base test, Applying VIP reset, DUT reset is not given, rst_sel is %0d",rst_sel),UVM_LOW)
            top_env.env_ip[idx].apply_vip_reset(); 
           end
            top_env.env_ip[idx].apply_reset(rst_type,rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50)); 
          `else
            top_env.env_ip[idx].apply_reset();
          `endif
         end else begin //TODO: PTP still use fake reset until SRC auto ready

            `ifdef ENABLE_ETH_VIP
            //disabling vip checks before reset
            top_env.env_ip[idx].ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
            top_env.env_ip[idx].ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
            top_env.env_ip[idx].disable_snps_errors();
         if ($test$plusargs("SKEW")) begin
             fork
            begin
                 top_env.env_ip[idx].apply_skew();
             end
   			join_none;
                end

       if ($test$plusargs("SKEW_LANE_REORDER")) begin
             fork
            begin
                 top_env.env_ip[idx].apply_lane_reorder();
             end
   			join_none;
                end

            `endif

            //`ifdef __SRC_TEST__ 
            top_env.env_ip[idx].apply_reset("hard",1,1,1,11,0,0,0);
            //`else
            //top_env.env_ip[idx].spy_if.simmode_reset();
            //`endif
            top_env.env_ip[idx].eth_ref_model_inst.reset_ral_and_stats_counters();
            
         end
      end
      join_none;
   end
   wait fork;
  phase.drop_objection(this);

endtask

   // In this phase decide all the knobs for the test progression 
   // e.g. number of iterations, num frames, add noise or not etc.
   // Each test should override this for custom config
   virtual task pre_configure_phase(uvm_phase phase);
      phase.raise_objection(this);
      phase.drop_objection(this);
   endtask // pre_configure_phase

   virtual task pre_main_phase(uvm_phase phase);
      phase.raise_objection(this);
      if(m_sequence.substr(0,1) inside {"an","lt"}) begin
        if (!$cast(anlt_seq, factory.create_object_by_name(m_sequence))) begin
	    `uvm_fatal("TEST:NOTASEQ", {"Type ", m_sequence, " is not a sequence type"});
	 end
         anlt_test_seq = 1;
      end 
      else begin
         if (`NUM_INST == 1 ) begin  
            foreach (seq[i]) begin
              if (!$cast(seq[i], factory.create_object_by_name(m_sequence))) begin
                `uvm_fatal("TEST:NOTASEQ", {"Type ", m_sequence, " is not a sequence type"});
              end
            end
         end  //  if (`NUM_INST == 1 ) begin 
        anlt_test_seq = 0;
      end

      send_config_to_spy_intf(); 
      phase.drop_objection(this);
   endtask // pre_main_phase
   
   virtual task main_phase(uvm_phase phase);
      string func_name = "main_phase";
      phase.raise_objection(this);
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
 
      `ifdef COMPL_TC
      if (!$test$plusargs("COMPL_TEST")) begin
      $display("NO TESTSUITE VEIFICATION REQUIRED");
        `ifdef ETH_MULTI_PORT
           svt_ethernet_test_suite_multi_port_if_test_inst.directed_test_done=1; 
           svt_ethernet_test_suite_if_test_inst.directed_test_done=1;
        `else
            svt_ethernet_test_suite_if_test_inst.directed_test_done=1;
        `endif
      end
      `endif
 	  //Send traffic
      if(anlt_test_seq) begin
        anlt_seq.starting_phase= phase;
        anlt_seq.start(top_env.top_virtual_sequencer_inst);
      end
	  else begin
		     // Nipoon: commenting this and instead adding link up inside the fork loop for sequence so that any lane which has link up done , traffic can start immediately  
         //wait_for_link_up();
         
     if (`NUM_INST == 1 ) begin  
        foreach (seq[i])
	         begin
	            automatic int j=i;
	            fork
		            begin
                      if ((m_sequence == "auto_neg_sanity_sequence") || (m_sequence == "auto_neg_rst_during_data_sequence") || (m_sequence == "auto_neg_rst_during_an_sequence")) begin  
	       				`uvm_info("AN_SEQ", $sformatf("AN sequence is selected, setting environment variable"), UVM_NONE);
                        top_env.env_ip[j].enable_an = 1'b1;
                      end
								    // added link up line   
                      if ((m_sequence != "auto_neg_rst_during_an_sequence") && (m_sequence != "auto_neg_diff_ability_sequence")) begin  
    	                  top_env.env_ip[j].wait_for_linkup(.ip_sync(1));
                      end
                    seq[j].starting_phase= phase;
                		seq[j].start(top_env.top_virtual_sequencer_inst.virtual_sequencer_inst[j]);
            		end
	            join_none
	        end
    	   wait fork;
     end 
     else  //   if (`NUM_INST == 1 ) begin
		 begin 
     `ifdef NON_ANLT_PTP 
     // Multi Instance Sanity test Invoke 
		  if ( m_sequence == "multi_instance_sanity_sequence" ) begin  
      multi_instance_sanity_sequence.start(top_env.top_virtual_sequencer_inst);
			end
		  if ( m_sequence == "multi_instance_random_sequence" ) begin  
      multi_instance_random_sequence.start(top_env.top_virtual_sequencer_inst);
			end
    `endif
    `ifdef PTP_EN
                  if ( m_sequence == "multi_instance_ptp_sanity" ) begin
      multi_instance_ptp_sanity.start(top_env.top_virtual_sequencer_inst);
                        end
                  if ( m_sequence == "multi_instance_ptp_2step_accuracy" ) begin
      multi_instance_ptp_2step_accuracy.start(top_env.top_virtual_sequencer_inst);
                        end
    `endif
    end  
    end
       `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
      phase.drop_objection(this);
   endtask
  virtual task post_main_phase(uvm_phase phase); // Added by Atiwari2 to read sip regs
      string func_name = "post_main_phase";
      phase.raise_objection(this);
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
      //Running the Task to read SIP registers:
  //    for (int i=0;i<`NUM_INST;i++) begin
  //       `uvm_info("eth_gdr_base_test", $psprintf("atiwari2-: Reading SIP Regs Post Traffic , NUM INST - %0d",`NUM_INST),UVM_NONE);
  //       top_env.env_ip[i].read_sip_status();
  //    end//for
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
      phase.drop_objection(this);
   endtask // post_main_phase
 
   function void report_phase(uvm_phase phase);
   super.report_phase(phase);

   for (int i=0;i<`NUM_INST;i++) begin
   `ifdef ENABLE_ETH_VIP
     if(top_env.env_ip[i].loopback_enable == 0) begin
       packet_sum[i] = top_env.env_ip[i].sb_vip_tx_mac_rx.tx_pkt_cnt + top_env.env_ip[i].sb_vip_tx_mac_rx.rx_pkt_cnt + top_env.env_ip[i].sb_vip_tx_mac_rx.fc_tx_pkt_cnt + top_env.env_ip[i].sb_vip_tx_mac_rx.fc_rx_pkt_cnt +
                       top_env.env_ip[i].sb_mac_tx_vip_rx.tx_pkt_cnt + top_env.env_ip[i].sb_mac_tx_vip_rx.rx_pkt_cnt + top_env.env_ip[i].sb_mac_tx_vip_rx.fc_tx_pkt_cnt + top_env.env_ip[i].sb_mac_tx_vip_rx.fc_rx_pkt_cnt ;
     end else begin
       packet_sum[i] = top_env.env_ip[i].sb_loopbk.tx_pkt_cnt + top_env.env_ip[i].sb_loopbk.rx_pkt_cnt + top_env.env_ip[i].sb_loopbk.fc_tx_pkt_cnt + top_env.env_ip[i].sb_loopbk.fc_rx_pkt_cnt; 
     end
     `uvm_info("eth_gdr_base_test", $psprintf("rami-base: %s sequence packet_sum for instance%0d=%0d",m_sequence,i,packet_sum[i]),UVM_NONE);
  `else
    packet_sum[i] = top_env.env_ip[i].sb_loopbk.tx_pkt_cnt + top_env.env_ip[i].sb_loopbk.rx_pkt_cnt + top_env.env_ip[i].sb_loopbk.fc_tx_pkt_cnt + top_env.env_ip[i].sb_loopbk.fc_rx_pkt_cnt; 
    `uvm_info("eth_gdr_base_test", $psprintf("rami-base: %s sequence loopback packet_sum for instance%0d=%0d",m_sequence,i,packet_sum[i]),UVM_NONE)
  `endif
  end
 
   if(m_sequence == "eth_register_access_sequence"        		 ||
	  m_sequence == "eth_register_mac_access_sequence"        		 ||
	  m_sequence == "eth_register_mac_invalid_addr_sequence"        		 ||
	  m_sequence == "eth_register_pcs_access_sequence"        		 ||
      m_sequence == "eth_register_access_sequence_1"        		 || 
      m_sequence == "eth_register_access_sequence_2"        		 || 
      m_sequence == "eth_register_access_sequence_3"        		 || 
      m_sequence == "eth_register_access_sequence_4"        		 || 
      m_sequence == "eth_register_access_sequence_5"        		 || 
      m_sequence == "eth_register_access_sequence_6"        		 ||
      m_sequence == "eth_sip_reg_access_sequence"        		 ||
      m_sequence == "eth_hip_reg_access_sequence"        		 ||
      m_sequence == "eth_register_timeout_seq"        		 ||
      m_sequence == "eth_xcvr_register_access_sequence"                  ||
      m_sequence == "eth_tx_reset_recovery_sequence"                     ||
      m_sequence == "eth_rx_reset_recovery_sequence"                     ||
      m_sequence == "eth_register_rsfec_reset_sequence"      ||
      m_sequence == "eth_register_ip_hard_reset_sequence"		 || 
      m_sequence == "eth_phy_deskew_reg_sequence"        		 || 
      m_sequence == "eth_phy_deskew_reg_sequence_1"       		 || 
      m_sequence == "eth_register_write_reserved_space"  		 || 
      m_sequence == "eth_register_write_reserved_space_1"  		 || 
      m_sequence == "eth_register_write_reserved_space_anlt_ptp"  		 || 
      m_sequence == "eth_register_write_reserved_space_FF"		 || 
      m_sequence == "eth_phy_frmerr_reg_sequence"         		 ||
      m_sequence == "eth_reset_during_access_register"         		 ||
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock1"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock2"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock3"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock4"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock5"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock6"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock7"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock8"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock9"       || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_block_lock10"      || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock1"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock2"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock3"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock4"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock5"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock6"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock7"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock8"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_am_lock10"         || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_decoder1"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_decoder2"          || 
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_scrambler1"        ||
      m_sequence == "eth_testsuite_100g_cl82_comp_seq_ber"        	 ||
      `ifdef COMPL_TC
      m_sequence == "eth_testsuite_xgmii_cl46_comp_seq23"        	 ||
      m_sequence == "eth_testsuite_xgmii_cl46_comp_seq26"        	 ||
      `endif
      m_sequence == "an_cl73_comp_seq1"         		 ||
      m_sequence == "an_cl73_comp_seq2"         		 ||
      m_sequence == "an_cl73_comp_seq3"         		 ||
      m_sequence == "an_cl73_comp_seq4"       		         ||
      m_sequence == "an_cl73_comp_seq7"        		         ||
      m_sequence == "an_cl73_comp_seq24"         		 ||
      m_sequence == "an_cl73_comp_seq25"         		 ||
      m_sequence == "an_cl73_comp_seq36"         		 ||
      m_sequence == "an_cl73_comp_seq37"     			 ||
      m_sequence == "an_cl73_comp_seq54"         		 || 
      m_sequence == "an_cl73_comp_seq55"        		 ||
      m_sequence == "an_cl73_comp_seq56"       		         || 
      m_sequence == "an_cl73_comp_seq57"         		 ||
      m_sequence == "an_cl73_comp_seq58"         		 ||
      m_sequence == "an_cl73_comp_seq59"        		 ||
      m_sequence == "an_cl73_comp_seq84"       		         ||
      m_sequence == "an_cl73_comp_seq91"        		 ||
      m_sequence == "an_cl73_comp_seq92"        		 ||
      m_sequence == "an_cl73_comp_seq93"        		 ||
      m_sequence == "an_cl73_comp_seq101"        		 ||
      m_sequence == "an_cl73_comp_seq107"        		 ||
      m_sequence == "an_cl73_comp_seq110"        		 ||
      m_sequence == "sweep_parameter_sequence"		   		 	||
      m_sequence == "lt_cl72_comp_seq1"         		||
	  m_sequence == "lt_cl72_comp_seq2"         		 ||
      m_sequence == "lt_cl72_comp_seq3"         		 ||
      m_sequence == "lt_cl72_comp_seq4"         		 ||
      m_sequence == "lt_cl72_comp_seq5"         		 ||
      m_sequence == "lt_cl72_comp_seq6"         		 ||
      m_sequence == "lt_cl72_comp_seq7"         		 ||
      m_sequence == "lt_cl72_comp_seq8"         		 ||
      m_sequence == "lt_cl72_comp_seq9"         		 ||
      m_sequence == "lt_cl72_comp_seq10"         		 ||
      m_sequence == "lt_cl72_comp_seq11"         		 ||
      m_sequence == "lt_cl72_comp_seq12"         		 ||
      m_sequence == "lt_cl72_comp_seq13"         		 ||
      m_sequence == "lt_cl72_comp_seq14"         		 ||
      m_sequence == "lt_cl72_comp_seq15"         		 ||
      m_sequence == "lt_cl72_comp_seq16"         		 ||
      m_sequence == "lt_cl72_comp_seq17"         		 ||
      m_sequence == "lt_cl72_comp_seq18"         		 ||
      m_sequence == "lt_cl72_comp_seq19"         		 ||
      m_sequence == "lt_cl72_comp_seq20"         		 ||
      m_sequence == "lt_cl72_comp_seq21"         		 ||
      m_sequence == "lt_cl72_comp_seq22"         		 ||
      m_sequence == "lt_cl72_comp_seq23"         		 ||
      m_sequence == "lt_cl72_comp_seq24"         		 ||
      m_sequence == "lt_cl72_comp_seq25"         		 ||
      m_sequence == "lt_cl72_comp_seq26"         		 ||
      m_sequence == "lt_cl72_comp_seq27"         		 ||
      m_sequence == "lt_cl72_comp_seq28"         		 ||
      m_sequence == "lt_cl72_comp_seq29"         		 ||
      m_sequence == "lt_cl72_comp_seq30"         		 ||
      m_sequence == "lt_cl72_comp_seq31"         		 ||
      m_sequence == "lt_cl72_comp_seq32"         		 ||
      m_sequence == "lt_cl72_comp_seq33"         		 ||
      m_sequence == "lt_cl72_comp_seq34"         		 ||
      m_sequence == "lt_cl72_comp_seq35"         		 ||
      m_sequence == "lt_cl72_comp_seq36"         		 ||
      m_sequence == "lt_cl72_comp_seq37"         		 ||
      m_sequence == "lt_cl72_comp_seq38"         		 ||
      m_sequence == "lt_cl72_comp_seq39"         		 ||
      m_sequence == "lt_cl72_comp_seq40"         		 ||
      m_sequence == "lt_cl72_comp_seq41"         		 ||
      m_sequence == "lt_cl72_comp_seq42"         		 ||
      m_sequence == "lt_cl72_comp_seq43"         		 ||
      m_sequence == "lt_cl72_comp_seq44"         		 ||
      m_sequence == "lt_cl72_comp_seq45"         		 ||
      m_sequence == "lt_cl72_comp_seq46"         		 ||
      m_sequence == "lt_cl72_comp_seq47"         		 ||
      m_sequence == "lt_cl72_comp_seq48"         		 ||
      m_sequence == "lt_cl72_comp_seq49"         		 ||
      m_sequence == "lt_cl72_comp_seq50"         		 ||
      m_sequence == "lt_cl72_comp_seq51"         		 ||
      m_sequence == "lt_cl72_comp_seq52"         		 ||
      m_sequence == "lt_cl72_comp_seq53"         		 ||
      m_sequence == "lt_cl72_comp_seq54"         		 ||
      m_sequence == "lt_cl72_comp_seq55"         		 ||
      m_sequence == "lt_cl72_comp_seq56"         		 ||
      m_sequence == "lt_cl72_comp_seq57"         		 ||
      m_sequence == "lt_cl72_comp_seq58"         		 ||
      m_sequence == "lt_cl72_comp_seq59"         		 ||
      m_sequence == "lt_cl136_comp_seq1"         		 ||
      m_sequence == "lt_cl136_comp_seq3"         		 ||
      m_sequence == "lt_cl136_comp_seq11"         		 ||
      m_sequence == "lt_cl136_comp_seq20"         		 ||
      m_sequence == "lt_cl136_comp_seq21"         		 ||
      m_sequence == "lt_cl136_comp_seq22"         		 ||
      m_sequence == "lt_cl136_comp_seq23"         		 ||
      m_sequence == "lt_cl136_comp_seq24"         		 ||
      m_sequence == "lt_cl136_comp_seq25"         		 ||
      m_sequence == "lt_cl136_comp_seq32"         		 ||
      m_sequence == "lt_cl136_comp_seq34"         		 ||
      m_sequence == "lt_cl136_comp_seq36"         		 ||
      m_sequence == "lt_cl136_comp_seq40"         		 ||
      m_sequence == "lt_cl136_comp_seq46"         		 ||
      m_sequence == "eth_phy_reg_sequence"                             ||
      m_sequence == "eth1025_register_access_sequence_1"               ||
      m_sequence == "eth1025_register_access_sequence_2"               ||
      m_sequence == "eth1025_register_access_sequence_3"               ||
      m_sequence == "eth1025_register_access_sequence_4"               ||
      m_sequence == "eth1025_register_access_sequence_4"               ||
      m_sequence == "eth1025_register_access_sequence_reset"           ||
      m_sequence == "eth1025_register_ip_hard_reset_sequence"          ||
      m_sequence == "eth_testsuite_cl49__1_1_comp_seq"                 ||
      m_sequence == "eth_testsuite_cl49__1_2_comp_seq"                 ||
      m_sequence == "eth_testsuite_cl49__1_3_comp_seq"                 ||
      m_sequence == "eth_rsfec_uncorrectable_codeword_sequence"        ||
      m_sequence == "eth_rsfec_error_counter_reset_sequence"           ||
      m_sequence == "an_register_access_sequence" ||
      m_sequence == "ptp_register_access_sequence_1" ||
      m_sequence == "ptp_register_access_sequence_2" ||
      m_sequence == "ptp_register_access_sequence_3" ||
      m_sequence == "ptp_register_access_sequence_4" ||
      m_sequence == "ptp_asm_p2p_read_write_reg_sequence" ||
      m_sequence == "ptp_ro_registers_sequence" ||
      m_sequence == "ptp_preamble_pass_sequence" ||
      m_sequence == "tsn_sanity_reg" ||
      m_sequence == "tsn_csr_regs" ||
      m_sequence == "tsn_mphy_regs" ||
      m_sequence == "tsn_csr_mphy_regs" ||
      m_sequence == "tsn_ucsr_mphy_cov_regs" ||
      m_sequence == "sanity_reg")
    begin
      zero_pkt_check_en = 1'b0;
    end
    else
    begin
      zero_pkt_check_en = 1'b1;
    end
 
    for (int j = 0;j<`NUM_INST;j++) begin
       if ((packet_sum[j] == 'h0) && zero_pkt_check_en == 1'b1) 
       begin
         uvm_report_error(get_name(),$psprintf("%s sequence didnt send any packet on instance%0d",m_sequence,j),UVM_NONE);
       end

    end  
   
endfunction:report_phase

`ifdef ENABLE_ETH_VIP
   /*** Need to be updated to support all GDR speeds - RAMI ***/
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Input: dyn_rcfg
   // Outut: svt_ethernet_agent_configuration
   // Function: Translates dyn_rcfg to equivalent svt_cfg
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  `ifdef ETH_MULTI_PORT 
   function svt_ethernet_multi_port_configuration#(`NUM_OF_PORTS) setup_vip_config(dyn_rcfg dyn_rcfg_inst, int ch);
     bit[2:0] dm_speed;
      
      svt_ethernet_multi_port_configuration #(`NUM_OF_PORTS) vip_cfg_inst;
      vip_cfg_inst = svt_ethernet_multi_port_configuration#(`NUM_OF_PORTS)::type_id::create($sformatf("vip_cfg_%0d",ch));
      
      /** Set the Interface Select As USXGMII Enable for VIP 0 */
      vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_USXGMII_ENABLE;
      vip_cfg_inst.usxgmii_mac_phy_mode = svt_ethernet_enum_pkg::USXGMII_PHY_MODE;
      vip_cfg_inst.usxgmii_mode         = svt_ethernet_enum_pkg::USXGMII_10G_1_PORT;
      vip_cfg_inst.enable_vip_cdr       = 1;
      vip_cfg_inst.cfg[0].enable_mon_pkt_drop_on_framing_error=0;
      vip_cfg_inst.cfg[0].enable_mon_pkt_retain_on_framing_error=1;
      vip_cfg_inst.cfg[0].enable_mon_pkt_drop_on_framing_error = 0;
      vip_cfg_inst.cfg[0].enable_mac_transaction_cov = 0; 
      vip_cfg_inst.cfg[0].enable_detailed_transaction_print_tx = 1; 
      vip_cfg_inst.cfg[0].mac_address[0] = 48'h000000004455;   //ALEX : Need to check this configuration
      vip_cfg_inst.cfg[0].disable_entry_to_fault_state = 1'b1;  //
      vip_cfg_inst.cfg[0].enable_complete_data_frame_with_preamble_rx = 1; 
      vip_cfg_inst.cfg[0].disable_pause_mode = 1;

      case(dyn_rcfg_inst.ll_speed)
        _10G : begin
          dm_speed = 3'b011;
        end
        _5G : begin
          dm_speed = 3'b101;
        end
        _2p5G : begin
          dm_speed = 3'b100;
        end
        _1G : begin
          dm_speed = 3'b010;
        end
        _100M : begin
          dm_speed = 3'b001;
        end
        _10M : begin
          dm_speed = 3'b000;
        end
        default : begin
          dm_speed = 3'b011;
        end
      endcase
      inst = uvm_cmdline_processor::get_inst();
      inst.get_arg_value("+m_sequence=",m_sequence);
      `uvm_info("eth_gdr_base_test", $psprintf("sequnce set from commnad line is %0s",m_sequence),UVM_NONE);

      /** Programming the VIP0 Port Configuration */
      foreach(vip_cfg_inst.cfg[i]) begin
         vip_cfg_inst.cfg[i].interface_select     = svt_ethernet_enum_pkg::ETH_USXGMII;
         //vip_cfg_inst.cfg[i].mac_address[0]       = 48'h0000AA774455;
         if((m_sequence == "auto_neg_sanity_sequence") || (m_sequence == "auto_neg_rst_during_data_sequence") || (m_sequence == "auto_neg_rst_during_an_sequence") || (m_sequence == "auto_neg_diff_ability_sequence")) begin
           vip_cfg_inst.cfg[i].enable_usxgmii_an      = 1;
           vip_cfg_inst.cfg[i].enable_usxgmii_soft_an = 0;
           vip_cfg_inst.cfg[i].usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,dm_speed,1'b1,1'b1,6'd0,1'b1};
         end
         else begin
           vip_cfg_inst.cfg[i].enable_usxgmii_an      = 0;
           vip_cfg_inst.cfg[i].enable_usxgmii_soft_an = 1;
           vip_cfg_inst.cfg[i].usxgmii_an_config_reg  = {1'b1,1'b0,1'b1,1'b1,3'b011,1'b1,1'b1,6'd0,1'b1};
         end
      end        
 
     /* case (dyn_rcfg_inst.speed)
        _10G  : begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_USXGMII_ENABLE; 
                vip_cfg_inst.NUMBER_OF_PORTS = 1;
                if(dyn_rcfg_inst.ll_speed == _10G) begin
                  vip_cfg_inst.usxgmii_mode     = svt_ethernet_enum_pkg::USXGMII_10G_1_PORT;
                end
                end
        _25G  : begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_25G_SERIAL;                                         //GDR: ETH-1
                if(dyn_rcfg_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) vip_cfg_inst.enable_xxvsbi_lsbi_rs_fec = 1;                              //GDR: ETH-7
                if(dyn_rcfg_inst.fec_type == FCFEC) vip_cfg_inst.enable_fec = 1;                                               //GDR: ETH-17
                if(dyn_rcfg_inst.fec_type == RSFECKP) vip_cfg_inst.enable_kp4_rs_fec =1;                                       //GDR: 
                end 
        _40G  : vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_XLSBI_SERIAL;                                       //GDR: ETH-16
        _50G  : begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_50G_SERIAL;                                         //GDR: TBD
                if(dyn_rcfg_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) vip_cfg_inst.enable_xxvsbi_lsbi_rs_fec =1;                                 //GDR: ETH-4
                if(dyn_rcfg_inst.fec_type == RSFECKP) vip_cfg_inst.enable_kp4_rs_fec =1;                                       //GDR: ETH-10
                if(dyn_rcfg_inst.fec_type == LLFEC) vip_cfg_inst.enable_ll_rs_fec =1;                                          //GDR: ETH-15
                end
        _100G : begin 
                if(dyn_rcfg_inst.fec_type == NOFEC) begin
                  vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_CAUI_25X4;      //GDR: ETH-8
                end else if (dyn_rcfg_inst.ch_num==1) begin //802.3ck interleaved fec
		          vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_100G_CK;
     	        end
                else begin
                  //As per the solvnet:01112737 & DE HSD: 16012059992
                  //updating VIP config with enable_four_lane_pmd=0
                  if(dyn_rcfg_inst.ch_num == 4) begin 
                     vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_4_LANE;     //GDR: ETH-13/14
                     vip_cfg_inst.enable_four_lane_pmd = (dyn_rcfg_inst.fec_type == RSFECKP)?0:1;
                  end
                  if(dyn_rcfg_inst.ch_num == 2) begin
                     vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_4_LANE;     //GDR: ETH-14
                     vip_cfg_inst.enable_four_lane_pmd = (dyn_rcfg_inst.fec_type == RSFECKP)?0:1;
                  end
                  if(dyn_rcfg_inst.ch_num == 1) begin
                     vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_CSBI_2_LANE;     //GDR: ETH-2
                     vip_cfg_inst.enable_four_lane_pmd = (dyn_rcfg_inst.fec_type == RSFECKP)?0:1;
                  end
               end
                if((dyn_rcfg_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) && (dyn_rcfg_inst.ch_num != 1)) vip_cfg_inst.enable_rs_fec =1; 
                if(dyn_rcfg_inst.fec_type == RSFECKP) vip_cfg_inst.enable_kp4_rs_fec =1;                                       //GDR: ETH-2
                if(dyn_rcfg_inst.fec_type == LLFEC) vip_cfg_inst.enable_ll_rs_fec =1;                                          //GDR: ETH-14
                end
        _200G : begin
                if(dyn_rcfg_inst.ch_num == 4 || dyn_rcfg_inst.ch_num == 8) vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_200G_SERIAL;   //GDR: ETH-5/OTHER-10
                if(dyn_rcfg_inst.ch_num == 2) vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_200G_SERIAL_4_LANE;   //GDR: ETH-11
                if(dyn_rcfg_inst.fec_type == RSFECKP) vip_cfg_inst.enable_kp4_rs_fec =1;                                       //GDR: ETH-11
                if(dyn_rcfg_inst.fec_type == LLFEC) vip_cfg_inst.enable_ll_rs_fec =1;                                          //GDR: ETH-5
                end
        _400G : begin
                if(dyn_rcfg_inst.ch_num == 8) vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_400G_SERIAL;         //GDR: ETH-9/18
                if(dyn_rcfg_inst.ch_num == 4) vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_400G_SERIAL_8_LANE;  //GDR: ETH-3
                if(dyn_rcfg_inst.fec_type == RSFECKP) vip_cfg_inst.enable_kp4_rs_fec =1;                                       //GDR: ETH-3/18
                if(dyn_rcfg_inst.fec_type == LLFEC) vip_cfg_inst.enable_ll_rs_fec =1;                                          //GDR: ETH-9
                end
        default: `uvm_fatal("SETUP_VIP_CFG", {"Speed is not defined, check gdr.csv"})
      endcase 

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.<PAM4>
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if (((dyn_rcfg_inst.speed == _50G)  && (dyn_rcfg_inst.ch_num == 1)) ||                                                   //GDR: ETH-10/15
          ((dyn_rcfg_inst.speed == _100G) && (dyn_rcfg_inst.ch_num == 1)) ||                                                   //GDR: ETH-2
          ((dyn_rcfg_inst.speed == _100G) && (dyn_rcfg_inst.ch_num == 2)) ||                                                   //GDR: ETH-14
          ((dyn_rcfg_inst.speed == _200G) && (dyn_rcfg_inst.ch_num != 8)) ||                                                   //GDR: ETH-5/11
          (dyn_rcfg_inst.speed == _400G) )                                                                                    //GDR: ETH-3/9/18
      begin
        vip_cfg_inst.enable_pam4 = 1;
        vip_cfg_inst.enable_pam4_precoding = 0;
      end

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set <cfg>.<alignTimer>
      // 25/200/400G : in terms of codewords
      // 40/50/100G  : in terms of PCS blocks
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      case (dyn_rcfg_inst.speed)
         
         _25G:    if(dyn_rcfg_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                     if(dyn_rcfg_inst.ptp == 1) begin
                        vip_cfg_inst.xxvsbi_rs_fec_mode_align_timer = 32;
                     end else begin
                        // 1280/(2*40) = 16 codewords    
                        vip_cfg_inst.xxvsbi_rs_fec_mode_align_timer = std_am ? 1024 : 16;
                     end
                  end
         _40G  :  vip_cfg_inst.xlsbi_40g_align_timer = std_am ? 16384 : 64;
         
         _50G:    if(dyn_rcfg_inst.ptp == 1) begin
                     vip_cfg_inst.lsbi_50g_align_timer = 1280;
                  end 
                  else begin
                    if(dyn_rcfg_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                      vip_cfg_inst.lsbi_50g_align_timer = std_am ? 20480 : 320;
                    end
                    else begin
                      vip_cfg_inst.lsbi_50g_align_timer = std_am ? 16384 : 256;
                    end
                  end
         _100G:   if(dyn_rcfg_inst.ptp == 1) begin
                    if (dyn_rcfg_inst.ch_num==1) begin //802.3ck interleaved fec
                      vip_cfg_inst.cgbi_rs_fec_mode_align_timer = 'd128;
                    end else begin
                      vip_cfg_inst.csbi_100g_align_timer = 512;
                    end
                  end else begin
                    if (dyn_rcfg_inst.ch_num==1) begin //802.3ck interleaved fec
                      vip_cfg_inst.cgbi_rs_fec_mode_align_timer = 'd64;
                    end else if(dyn_rcfg_inst.fec_type inside {RSFECKR,RSFECKP,LLFEC}) begin
                      vip_cfg_inst.csbi_100g_align_timer = std_am ? 16384 : 256;
                    end
                    else begin
                      vip_cfg_inst.csbi_100g_align_timer = std_am ? 16384 : 256;
                    end
                  end
         _200G:   if(dyn_rcfg_inst.ptp == 1) begin
                     vip_cfg_inst.ccbi_rs_fec_mode_align_timer = 256;
                  end else begin
                     //5120/(2*40) = 64 codewords     
                     vip_cfg_inst.ccbi_rs_fec_mode_align_timer = std_am ? 4096 : 64;
                  end
         _400G:   if(dyn_rcfg_inst.ptp == 1) begin
                     vip_cfg_inst.cdbi_rs_fec_mode_align_timer = 512;
                  end else begin
                     //10240/(2*40) = 128 codewords      
                     vip_cfg_inst.cdbi_rs_fec_mode_align_timer = std_am ? 8192 : 128;
                  end
      endcase

      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // Set common cfgs
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if((dyn_rcfg_inst.fec_type != NOFEC) && (dyn_rcfg_inst.speed != _100G) ) vip_cfg_inst.enable_xxvsbi_lsbi_consortium_mode = 0; // TODO why except 100G ?
      if((dyn_rcfg_inst.speed != _10G) && (dyn_rcfg_inst.speed != _25G) ) vip_cfg_inst.mac_expected_minimum_ipg = 1;
//      if(vip_cfg_inst.enable_pam4) vip_cfg_inst.enable_pam4_gray_coding = 0;///1; // TODO Randomize ?? // Bydefault VIP in graycode mode. TODO: Need to disable for eth10/11?
      vip_cfg_inst.enable_mon_pkt_drop_on_framing_error=0;
      vip_cfg_inst.enable_mon_pkt_retain_on_framing_error=1;
      vip_cfg_inst.enable_vip_cdr = 1;  // TODO randomize ??
      vip_cfg_inst.enable_mon_pkt_drop_on_framing_error = 0;
//      vip_cfg_inst.disable_pause_mode = 1;
      vip_cfg_inst.enable_mac_transaction_cov = 1; 
      vip_cfg_inst.enable_detailed_transaction_print_tx = 1; 
      //ALEX : TODO Need to review following configuration
      vip_cfg_inst.mac_address[0] = 48'h000000004455;   //ALEX : Need to check this configuration
      vip_cfg_inst.disable_entry_to_fault_state = 1'b1;  //
      vip_cfg_inst.enable_complete_data_frame_with_preamble_rx = 1; 
      vip_cfg_inst.disable_pause_mode = 1;
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      // set ANLT cfgs
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
      if ((dyn_rcfg_t.enable_an==1) || (dyn_rcfg_t.enable_lt==1) ) begin
         vip_cfg_inst.interface_select = 1;
         vip_cfg_inst.autoadaptation_max_wait_timer = 29000000;
         vip_cfg_inst.enable_xxvsbi_lsbi_consortium_mode = 0;
         vip_cfg_inst.an73_break_link_timer = 32'd400000;
         vip_cfg_inst.enable_an_cov = 1;
         vip_cfg_inst.enable_ad_cov = 1;
         if (dyn_rcfg_inst.fec_type==RSFECKR) begin
           if ((dyn_rcfg_inst.speed == _50G)  || (dyn_rcfg_inst.speed == _25G)) begin                                              
            vip_cfg_inst.enable_xxvsbi_lsbi_rs_fec      = 1;
           end
            vip_cfg_inst.xxvsbi_rs_fec_mode_align_timer = 16;
            vip_cfg_inst.enable_fec_cov                 = 1;
         end
        end*/
      return (vip_cfg_inst);
   endfunction // setup_vip_config
  `else
   function svt_ethernet_agent_configuration setup_vip_config(dyn_rcfg dyn_rcfg_inst, int ch);
      
      svt_ethernet_agent_configuration vip_cfg_inst;
      vip_cfg_inst = svt_ethernet_agent_configuration::type_id::create($sformatf("vip_cfg_%0d",ch));
      
      /** Set the Interface Select As USXGMII Enable for VIP 0 */
          if(dyn_rcfg_inst.ll_var == _NF1G)begin
            vip_cfg_inst.qsgmii_mac_phy_mode =  svt_ethernet_enum_pkg::SGMII_PHY_MODE;
            vip_cfg_inst.enable_sgmii_mode = 1;
          end 
          vip_cfg_inst.enable_mon_pkt_drop_on_framing_error=0;
          vip_cfg_inst.enable_mon_pkt_retain_on_framing_error=1;
          `ifdef ETH_MGE
            vip_cfg_inst.enable_vip_cdr = 0;  // TODO randomize ??
          `else
            vip_cfg_inst.enable_vip_cdr = 1;
          `endif
          // disbaling the CDR as suggested by VIP team :-  01343282
          if((dyn_rcfg_inst.ll_var == _MGBASET || dyn_rcfg_inst.ll_var == _MGBASETA10) && (dyn_rcfg_inst.ll_speed != _10G))begin 
            vip_cfg_inst.enable_vip_cdr = 0;
          end
            `uvm_info("setup_vip_config ", $sformatf("ll_speed is %s enable_vip_cdr %d",dyn_rcfg_inst.ll_speed,vip_cfg_inst.enable_vip_cdr), UVM_NONE)
      
          vip_cfg_inst.enable_mon_pkt_drop_on_framing_error = 0;
          vip_cfg_inst.enable_mac_transaction_cov = 1; 
          vip_cfg_inst.enable_detailed_transaction_print_tx = 1; 
          vip_cfg_inst.mac_address[0] = 48'h000000004455;   //ALEX : Need to check this configuration
          vip_cfg_inst.disable_entry_to_fault_state = 1'b1;  //
          vip_cfg_inst.enable_complete_data_frame_with_preamble_rx = 1; 
          vip_cfg_inst.disable_pause_mode = 1;
          vip_cfg_inst.disable_preamble_shrinkage = 1;
          if(dyn_rcfg_inst.ll_var == _MGE)begin
            vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_1G_BASEX_1BIT;
          end 
          if(dyn_rcfg_inst.ll_var == _BASERS10)begin
            vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_XSBI_SERIAL;
          end 
          if(dyn_rcfg_inst.ll_var == _BASERA10)begin
            vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_XSBI_SERIAL;
          end 
          if(dyn_rcfg_inst.ll_var == _NF10G)begin
               vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_XSBI_SERIAL;
          end 
          if(dyn_rcfg_inst.ll_var == _NF1G)begin
               vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_1G_BASEX_1BIT;
          end 
          if(dyn_rcfg_inst.ll_var == _MGBASET || dyn_rcfg_inst.ll_var == _MGBASETA10) begin
            if(dyn_rcfg_inst.ll_speed == _10G)
              begin      				
               vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_XSBI_SERIAL;
               `uvm_info("setup_vip_config ", $sformatf("ll_speed is %s",dyn_rcfg_inst.ll_speed), UVM_NONE)
              end
            else
              begin
          //     vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_1G_BASEX_1BIT; //for 2.5 and 1G  speeds
               `uvm_info("setup_vip_config ", $sformatf("ll_speed is %s",dyn_rcfg_inst.ll_speed), UVM_NONE)
                if(dyn_rcfg_inst.ll_speed == _1G) begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_1G_BASEX_1BIT; //for 2.5 and 1G  speeds
                end 
                else if(dyn_rcfg_inst.ll_speed == _2p5G) begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_1G_BASEX_1BIT; //for 2.5 and 1G  speeds
                end 
                else if(dyn_rcfg_inst.ll_speed == _100M) begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_MII_100M_SERIAL_1G; //100M 
                end
                else if(dyn_rcfg_inst.ll_speed == _10M) begin
                vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_MII_10M_SERIAL_1G; //10M
                end
              end
          end
      return (vip_cfg_inst);
   endfunction // setup_vip_mge_config
  `endif   

   // Need to be updated to support all GDR speeds - RAMI
   function svt_ethernet_agent_configuration setup_vip_tx_config(dyn_rcfg dyn_rcfg_inst, int ch);
      svt_ethernet_agent_configuration vip_cfg_inst;
      vip_cfg_inst = svt_ethernet_agent_configuration::type_id::create($sformatf("vip_tx_cfg_otn_flexe_%0d",ch));

      if(dyn_rcfg_inst.speed inside {_10G,_25G})
	 vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_66B_10G_ENCODER; 
      else
	 vip_cfg_inst.interface_select = svt_ethernet_enum_pkg::ETH_66B_MULTILANE_ENCODER; 
      if (dyn_rcfg_inst.mode==OTN) begin
	 vip_cfg_inst.enable_complete_data_frame_with_preamble_rx = 1; 
	 vip_cfg_inst.mac_expected_minimum_ipg = 1; 
	 vip_cfg_inst.xsbi_scrambler_active = 1;//Set xsbi_scrambler/descrambler_active to 1 to enable scrambler(OTN mode)
	 vip_cfg_inst.xsbi_descrambler_active = 1;
      end else if (dyn_rcfg_inst.mode==FLEXE) begin
	 vip_cfg_inst.enable_complete_data_frame_with_preamble_rx = 1; 
	 vip_cfg_inst.mac_expected_minimum_ipg = 1; 
	 vip_cfg_inst.xsbi_scrambler_active = 0;//Set xsbi_scrambler/descrambler_active to 0 to disable scrambler
	 vip_cfg_inst.xsbi_descrambler_active = 0;
      end
      
      return (vip_cfg_inst);
   endfunction // setup_vip_tx_config
`endif // ENABLE_ETH_VIP

   /* Converter fuction for enum, int and bit from string */
   /* Constraint block does not support direct usage of atoi or cast from string to enum*/
   function speed_e get_speed_enum(input string s);
       get_speed_enum = get_speed_enum.first;
       repeat(get_speed_enum.num) begin
           if(get_speed_enum.name == s) return get_speed_enum;
           else get_speed_enum = get_speed_enum.next;
       end
       assert(0) else $error("Identifier '%s' not in enum speed_e",s);
   endfunction
   
   function llvar_e get_llvar_enum(input string s);
       get_llvar_enum = get_llvar_enum.first;
       repeat(get_llvar_enum.num) begin
           if(get_llvar_enum.name == s) return get_llvar_enum;
           else get_llvar_enum = get_llvar_enum.next;
       end
       assert(0) else $error("Identifier '%s' not in enum llvar_e",s);
   endfunction


   function device_mode_e get_device_mode_enum(input string s);
       get_device_mode_enum = get_device_mode_enum.first;
       repeat(get_device_mode_enum.num) begin
           if(get_device_mode_enum.name == s) return get_device_mode_enum;
           else get_device_mode_enum = get_device_mode_enum.next;
       end
       assert(0) else $error("Identifier '%s' not in enum device_mode_e",s);
   endfunction


   function mode_e get_mode_enum(input string s);
       get_mode_enum = get_mode_enum.first;
       repeat(get_mode_enum.num) begin
           if(get_mode_enum.name == s) return get_mode_enum;
           else get_mode_enum = get_mode_enum.next;
       end
       assert(0) else $error("Identifier '%s' not in enum mode_e",s);
   endfunction

   function int get_int(input string s);
       get_int = s.atoi();
       return get_int;
   endfunction

   function bit [39:0] get_bit(input string s);
       get_bit = s.atoi();
       return get_bit;
   endfunction
   /* Converter function end*/

   task wait_tx_frames_sent(int exp_num, time timeout_time=200us, int instnum=0);
      string func_name = $sformatf("wait_tx_frames_sent_%0d",instnum);
      time   start_time;
      bit    condition_met;
      int  act_pkt_cnt;
      
      `uvm_info("Packet wait", $sformatf("%s: Waiting for %0d transmitted by AVST, Instance num=%0d",func_name,exp_num,instnum), UVM_NONE);
      start_time = $time;
      condition_met = 1'b0;

	  	fork
      		begin 
      			while (condition_met!=1'b1) begin
`ifdef ENABLE_ETH_VIP      				
                          if(m_sequence != "bandwidth_sequence" && m_sequence != "sanity_loopback_sequence") begin
	    			if ((top_env.env_ip[instnum].sb_mac_tx_vip_rx.tx_pkt_cnt)<exp_num) begin
	       				#10ns;
	       			end else begin
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
	       			end
                          end else begin
	    			if (top_env.env_ip[instnum].sb_loopbk.tx_pkt_cnt<exp_num) begin
	       				#10ns;
	       			end else begin 
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
	       			end
                          end
`else
	    			if (top_env.env_ip[instnum].sb_loopbk.tx_pkt_cnt<exp_num) begin
	       				#10ns;
	       			end
	       			else begin 
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
	       			end
`endif
	       		end
	       	end
	       	begin 
	       		#200us; 
`ifdef ENABLE_ETH_VIP      				
                          if(m_sequence != "bandwidth_sequence" && m_sequence != "sanity_loopback_sequence") begin
	       		act_pkt_cnt = (top_env.env_ip[instnum].sb_mac_tx_vip_rx.tx_pkt_cnt) ; 
		 end else begin 
	       		act_pkt_cnt = top_env.env_ip[instnum].sb_loopbk.tx_pkt_cnt; 
	       	 end
`else
	       		act_pkt_cnt = top_env.env_ip[instnum].sb_loopbk.tx_pkt_cnt; 
`endif
	       		`uvm_error("Packet wait", $sformatf("%s: Timeout waiting for %0d transmitted by AVST. Waited %0t.transmitted packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
	       	end
	    join_any
	    disable fork;

  endtask // wait_tx_frames_sent

   task wait_tx_frames_received(int exp_num, time timeout_time=200us, int instnum=0);
      string func_name = $sformatf("wait_tx_frames_received_%0d",instnum);
      time   start_time;
      bit    condition_met;
      int  act_pkt_cnt; 
      
      `uvm_info("Packet wait", $sformatf("%s: Waiting for %0d frames received by VIP",func_name,exp_num), UVM_NONE)
	    start_time = $time;
      condition_met = 1'b0;
     	fork
      		begin 
      			while (condition_met!=1'b1) begin
`ifdef ENABLE_ETH_VIP      				
                          if(m_sequence != "bandwidth_sequence" && m_sequence != "sanity_loopback_sequence") begin
	    			if ((top_env.env_ip[instnum].sb_mac_tx_vip_rx.rx_pkt_cnt)<exp_num) begin
	       				#10ns;
	       			end else begin
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames received by VIP",func_name,exp_num), UVM_NONE)
	       			end				
		           end else begin 
	    			if (top_env.env_ip[instnum].sb_loopbk.rx_pkt_cnt<exp_num) begin
	       				#10ns;
	       			end else begin 
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames received by VIP",func_name,exp_num), UVM_NONE)
	       			end				
	       	           end
`else
	    			if (top_env.env_ip[instnum].sb_loopbk.rx_pkt_cnt<exp_num) begin
	       				#10ns;
	       			end
	       			else begin 
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames received by VIP",func_name,exp_num), UVM_NONE)
	       			end
`endif
	       		end
	       	end
	       	begin 
	       		#200us; 
`ifdef ENABLE_ETH_VIP      				
                          if(m_sequence != "bandwidth_sequence" && m_sequence != "sanity_loopback_sequence") begin
	       		act_pkt_cnt = (top_env.env_ip[instnum].sb_mac_tx_vip_rx.rx_pkt_cnt);
		 end else begin 
	       		act_pkt_cnt = top_env.env_ip[instnum].sb_loopbk.rx_pkt_cnt; 
	       	 end 
`else
	       		act_pkt_cnt = top_env.env_ip[instnum].sb_loopbk.rx_pkt_cnt; 
`endif
	       		`uvm_error("Packet wait", $sformatf("%s: Timeout waiting for %0d frames received by VIP. Waited %0t. received packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
	  	    end
	    join_any
	    disable fork;
     
   endtask // wait_tx_frames_received

   task wait_rx_frames_sent(int exp_num, time timeout_time=200us, int instnum=0);
      string func_name = $sformatf("wait_rx_frames_sent_%0d",instnum);
      time   start_time;
      bit    condition_met;
      int  act_pkt_cnt;
      
      `uvm_info("Packet wait", $sformatf("%s: Waiting for %0d transmitted by VIP, Instance num=%0d",func_name,exp_num,instnum), UVM_NONE);
      start_time = $time;
      condition_met = 1'b0;
	 	fork
      		begin 
      			while (condition_met!=1'b1) begin
	    			if ((top_env.env_ip[instnum].sb_vip_tx_mac_rx.tx_pkt_cnt)<exp_num) begin
	       				#10ns;
	       			end
	       			else begin 
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames transmitted by VIP",func_name,exp_num), UVM_NONE)
	       			end
	       		end
	       	end
	       	begin 
	       		#200us; 
	       		act_pkt_cnt = (top_env.env_ip[instnum].sb_vip_tx_mac_rx.tx_pkt_cnt); 
	       		`uvm_error("Packet wait", $sformatf("%s: Timeout waiting for %0d transmitted by VIP. Waited %0t.transmitted packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
	   		
	       	end
	    join_any
	    disable fork;
   endtask // wait_rx_frames_sent

   task wait_rx_frames_received(int exp_num, time timeout_time=200us, int instnum=0);
      string func_name = $sformatf("wait_rx_frames_received_%0d",instnum);
      time   start_time;
      bit    condition_met;
      int  act_pkt_cnt;
      
      `uvm_info("Packet wait", $sformatf("%s: Waiting for %0d frames received by AVST",func_name,exp_num), UVM_NONE)
	start_time = $time;
      condition_met = 1'b0;
	 	fork
      		begin 
      			while (condition_met!=1'b1) begin
	    			if ((top_env.env_ip[instnum].sb_vip_tx_mac_rx.rx_pkt_cnt)<exp_num) begin
	       				#10ns;
	       			end
	       			else begin 
	       				condition_met=1'b1;
	       				`uvm_info("Packet wait", $sformatf("%s: %0d frames received by AVST",func_name,exp_num), UVM_NONE)
	       			end
	       		end
	       	end
	       	begin 
	       		#200us; 
	       		act_pkt_cnt = (top_env.env_ip[instnum].sb_vip_tx_mac_rx.rx_pkt_cnt); 
	       		`uvm_error("Packet wait", $sformatf("%s: Timeout waiting for %0d frames received by AVST. Waited %0t.received packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
	   		
	       	end
	    join_any
	    disable fork; 

   endtask // wait_rx_frames_received
   
      // From GDR CSV text file will be created with each row representing a DUT instance and its params
      // MODE string already contains speed & channel number, INTERFACE will be converted to mode_string and appended as last string)
      // tb_mode_str=MODE_TRANSTYPE_PTP_ANLT_RXPAUSEFWD_SA_TXVLAN_RXVLAN_ENMXFRSIZE_ENASYNCAD_PP_SFD_LF_RXBYTEREM_READYDROP_RDYLAT_PHYREFCLK_IPG_FEC_TXMXFRSIZE_RXMXFRSIZE_IPGREM_ACTIVENODE_ANLTENNODE_INTERFACE
      function dyn_rcfg extract_mode_from_str(string tb_mode_str);

      int offset=0;
      string speed_str,_speed_str,ch_str,transtype_str,ptp_str,an_str,lt_str,anchan0_str,crmode_str,rxpausefwd_str,sa_str,txvlan_str,rxvlan_str,enmxfrsize_str,enasyncad_str,pp_str,s_preamble_str,sfd_str,lf_str,fc_str,rxbyterem_str,readydrop_str,rdylat_str,phyrefclk_str,syspll_str,syspllcnt_str,cadnum_str,cadden_str,ipg_str,fec_str,txmxfrsize_str,rxmxfrsize_str,ipgrem_str,mode_str,active_node_str,anlt_en_node_str,fp_width_str,ll_speed_str,_ll_speed_str,ll_var_str,_ll_var_str,device_mode_str,_device_mode_str;

      dyn_rcfg tb_dyn_rcfg;

      tb_dyn_rcfg = dyn_rcfg::type_id::create("tb_dyn_rcfg", this);

      for (int i = 0; i < tb_mode_str.len(); i++) begin
	      if (tb_mode_str.getc(i) == "_") begin
	        if (speed_str.len()==0) begin
	          speed_str=tb_mode_str.substr(offset,i-1);
              _speed_str = {"_",speed_str};
	          offset=i+1;
	        end else if (ch_str.len()==0) begin
	          ch_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (transtype_str.len()==0) begin
	          transtype_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (ptp_str.len()==0) begin
	          ptp_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (an_str.len()==0) begin
	          an_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (lt_str.len()==0) begin
	          lt_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (anchan0_str.len()==0) begin
	          anchan0_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (crmode_str.len()==0) begin
	          crmode_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (rxpausefwd_str.len()==0) begin
	          rxpausefwd_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (sa_str.len()==0) begin
	          sa_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (txvlan_str.len()==0) begin
	          txvlan_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (rxvlan_str.len()==0) begin
	          rxvlan_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (enmxfrsize_str.len()==0) begin
	          enmxfrsize_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (enasyncad_str.len()==0) begin
	          enasyncad_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (pp_str.len()==0) begin
	          pp_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (s_preamble_str.len()==0) begin
	          s_preamble_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (sfd_str.len()==0) begin
	          sfd_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (lf_str.len()==0) begin
	          lf_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (fc_str.len()==0) begin
	          fc_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (rxbyterem_str.len()==0) begin
	          rxbyterem_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (readydrop_str.len()==0) begin
	          readydrop_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (rdylat_str.len()==0) begin
	          rdylat_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (phyrefclk_str.len()==0) begin
	          phyrefclk_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (syspll_str.len()==0) begin
	          syspll_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (syspllcnt_str.len()==0) begin
	          syspllcnt_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (cadnum_str.len()==0) begin
	          cadnum_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (cadden_str.len()==0) begin
	          cadden_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (ipg_str.len()==0) begin
	          ipg_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (fec_str.len()==0) begin
	          fec_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (txmxfrsize_str.len()==0) begin
	          txmxfrsize_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (rxmxfrsize_str.len()==0) begin
	          rxmxfrsize_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (ipgrem_str.len()==0) begin
	          ipgrem_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (active_node_str.len()==0) begin
	          active_node_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (anlt_en_node_str.len()==0) begin
	          anlt_en_node_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
	        end else if (ll_speed_str.len()==0) begin
	          ll_speed_str=tb_mode_str.substr(offset,i-1);

            if(ll_speed_str == "1XX")begin
              this.randomize();
              ll_speed_str=speed_arr[speed_s];
            `uvm_info(get_type_name(), $psprintf("randomized speed selected : %s",ll_speed_str),UVM_NONE);
            end

              _ll_speed_str = {"_",ll_speed_str}; 
	          offset=i+1;              
	        end else if (ll_var_str.len()==0) begin
                   ll_var_str=tb_mode_str.substr(offset,i-1);
              _ll_var_str = {"_",ll_var_str};
	      `uvm_info("eth_gdr_llvar", $sformatf("llvar is : %s",ll_var_str), UVM_NONE)
              `uvm_info("eth_gdr_llvar", $sformatf("_llvar is : %s",_ll_var_str), UVM_NONE)
	          offset=i+1;              
	        end else if (mode_str.len()==0) begin
	          mode_str=tb_mode_str.substr(offset,i-1);
	          offset=i+1;
			  end else if (fp_width_str.len()==0) begin 
           //IMPORTANT NOTE: only for PTP - Please put this "else if fp_width_str" block at the end of this for loop, before "mode_str". 
			  //param_tb.csv will only generate this for PTP only. Non ptp doesn't have this param in the file and it will be constraint to 0 for tb_dyn_rcfg
             `uvm_info("eth_gdr_base_test", $sformatf("ptp_str is %d",get_bit(ptp_str)), UVM_NONE)
             fp_width_str=tb_mode_str.substr(offset,i-1);
				 offset=i+1;
				 `uvm_info("eth_gdr_base_test", $sformatf("fp_width_str is %0d",get_int(fp_width_str)), UVM_NONE)             
	        end
	     end
     end // for (int i = 0; i < tb_mode_str.len(); i++)
     //mode_str=tb_mode_str.substr(offset,tb_mode_str.len()-2);
     device_mode_str=tb_mode_str.substr(offset,tb_mode_str.len()-2);
     _device_mode_str = {"_",device_mode_str}; 
	   `uvm_info("eth_gdr_device_mode", $sformatf("device_mode is : %s",device_mode_str), UVM_NONE)
	   `uvm_info("eth_gdr_device_mode", $sformatf("_device_mode is : %s",_device_mode_str), UVM_NONE)

       tb_dyn_rcfg.randomize() with
       	{  
       	 speed==get_speed_enum(_speed_str);
       	 ll_speed==get_speed_enum(_ll_speed_str);
	       ll_var==get_llvar_enum(_ll_var_str);
	       device_mode==get_device_mode_enum(_device_mode_str);
       	 ch_num==get_int(ch_str);
	       trans_type==get_bit(transtype_str);
	       ptp==get_bit(ptp_str);
	       enable_an==get_bit(an_str);
	       enable_lt==get_bit(lt_str);
	       an_chan0==get_bit(anchan0_str);
	       cr_mode==get_bit(crmode_str);
	       rx_fc_fwd==get_bit(rxpausefwd_str);
	       sa==get_bit(sa_str);
	       txvlan==get_bit(txvlan_str);
	       rxvlan==get_bit(rxvlan_str);
	       en_mx_frsz==get_bit(enmxfrsize_str);
	       en_async_adp==get_bit(enasyncad_str);
	       preamble_passthrough==get_bit(pp_str);
	       strict_preamble==get_bit(s_preamble_str);
	       sfd==get_bit(sfd_str);
	       lf==get_bit(lf_str);
	       fc==get_bit(fc_str);
	       rxbyte_rem==get_bit(rxbyterem_str);
	       fc_rdy_drop==get_bit(readydrop_str);
	       rdy_lat==get_bit(rdylat_str);
	       phyrefclk==get_bit(phyrefclk_str);
	       syspll==get_bit(syspll_str);
	       syspllcnt==get_bit(syspllcnt_str);
	       cadnum==get_bit(cadnum_str);
	       cadden==get_bit(cadden_str);
	       ipg==get_int(ipg_str);
	       fec_type==get_bit(fec_str);
	       tx_frm_size==get_int(txmxfrsize_str);
	       rx_frm_size==get_int(rxmxfrsize_str);
	       ipg_rm_perperiod==get_int(ipgrem_str);
               active_node==get_bit(active_node_str);
               anlt_en_node==get_bit(anlt_en_node_str);
       	 mode==get_mode_enum(mode_str);
          fp_width==get_int(fp_width_str);
       	 //fc==1;
       	 };
      if(tb_dyn_rcfg.enable_an || tb_dyn_rcfg.enable_lt) tb_dyn_rcfg.anlt=1; 
      else                                               tb_dyn_rcfg.anlt=0;
      if(tb_dyn_rcfg.rxbyte_rem == 0) begin tb_dyn_rcfg.crc_pass = 1; tb_dyn_rcfg.rm_rx_pads = 0; end
      if(tb_dyn_rcfg.rxbyte_rem == 1) begin tb_dyn_rcfg.crc_pass = 0; tb_dyn_rcfg.rm_rx_pads = 0; end
      if(tb_dyn_rcfg.rxbyte_rem == 3) begin tb_dyn_rcfg.crc_pass = 0; tb_dyn_rcfg.rm_rx_pads = 1; end
      return (tb_dyn_rcfg);

   endfunction // extract_mode_from_str

   // Function to extrace ANLT cfg and node information from dyn_cfg object 
   function void extract_kr_mode_from_dyn_rcfg(dyn_rcfg dyn_rcfg, ref kr_cfg kr_cfg_t);
     case (dyn_rcfg.speed)
     _10G : begin
             kr_cfg_t.is_speed_10g = (dyn_rcfg.enable_an || dyn_rcfg.enable_lt) ;
             kr_cfg_t.active_10g |= dyn_rcfg.active_node;
             kr_cfg_t.node_sel_10g |= dyn_rcfg.anlt_en_node;
            end
     _25G : begin
             kr_cfg_t.is_speed_25g = (dyn_rcfg.enable_an || dyn_rcfg.enable_lt) ;
             kr_cfg_t.active_25g |= dyn_rcfg.active_node;
             kr_cfg_t.node_sel_25g |= dyn_rcfg.anlt_en_node;
            end
     _40G : begin
             kr_cfg_t.is_speed_40g = (dyn_rcfg.enable_an || dyn_rcfg.enable_lt) ;
             kr_cfg_t.active_40g |= dyn_rcfg.active_node;
             kr_cfg_t.node_sel_40g |= dyn_rcfg.anlt_en_node;
            end
     _50G : begin
             kr_cfg_t.is_speed_50g = (dyn_rcfg.enable_an || dyn_rcfg.enable_lt) ;
             kr_cfg_t.active_50g |= dyn_rcfg.active_node[7:0];
             kr_cfg_t.node_sel_50g |= dyn_rcfg.anlt_en_node[7:0];
            end
     _100G : begin
             kr_cfg_t.is_speed_100g = ( dyn_rcfg.enable_an || dyn_rcfg.enable_lt );
             kr_cfg_t.active_100g |= dyn_rcfg.active_node[3:0];
             kr_cfg_t.node_sel_100g |= dyn_rcfg.anlt_en_node[3:0];
            end
     _200G : begin
             kr_cfg_t.is_speed_200g = dyn_rcfg.anlt ;
             kr_cfg_t.active_200g |= dyn_rcfg.active_node[1:0];
             kr_cfg_t.node_sel_200g |= dyn_rcfg.anlt_en_node[1:0];
            end
     _400G : begin
             kr_cfg_t.is_speed_400g = dyn_rcfg.anlt ;
             kr_cfg_t.active_400g |= dyn_rcfg.active_node[0];
             kr_cfg_t.node_sel_400g |= dyn_rcfg.anlt_en_node[0];
            end
   endcase

//	       anlt==get_bit(anlt_str);

   endfunction // extract_kr_mode_from_str


endclass : eth_gdr_base_test

task eth_gdr_base_test::wait_for_link_up();

	    for (int i=0;i<`NUM_INST;i++) begin
	    	automatic int idx=i;
		    fork
			begin
	      top_env.env_ip[idx].wait_for_linkup(.ip_sync(1));
			end
		     join_none;
		end
		wait fork;
	     
endtask 


task eth_gdr_base_test::send_traffic(int num_pkt_to_send,uvm_phase phase);

	    for (int i=0;i<`NUM_INST;i++) begin
	    	automatic int idx=i;
		    fork
			begin
			      seq[idx].starting_phase= phase;
			      seq[idx].start(top_env.top_virtual_sequencer_inst.virtual_sequencer_inst[idx]);
			end
		     join_none;
		end
		wait fork;
	     
	 	// Wait for frames to be received
	    for (int i=0;i<`NUM_INST;i++) begin
	    	automatic int j=i;
	       	fork
		    		wait_tx_frames_sent(.exp_num(num_pkt_to_send),.instnum(j));
		     		wait_tx_frames_received(.exp_num(num_pkt_to_send),.instnum(j));
		     		wait_rx_frames_sent(.exp_num(num_pkt_to_send),.instnum(j));
		     		wait_rx_frames_received(.exp_num(num_pkt_to_send),.instnum(j));
		   join_none
		end
		   wait fork; 

endtask 

task eth_gdr_base_test::send_config_to_spy_intf();
// Send speed info to spy interface
	    foreach (dyn_rcfg_obj_inst[i]) begin
       	 $cast(top_env.env_ip[i].spy_if.speed,dyn_rcfg_obj_inst[i].speed);
       	 top_env.env_ip[i].spy_if.ch_num=dyn_rcfg_obj_inst[i].ch_num;
	       top_env.env_ip[i].spy_if.trans_type=dyn_rcfg_obj_inst[i].trans_type;
	       top_env.env_ip[i].spy_if.ptp=dyn_rcfg_obj_inst[i].ptp;
	       top_env.env_ip[i].spy_if.anlt=dyn_rcfg_obj_inst[i].anlt;
	       top_env.env_ip[i].spy_if.rx_fc_fwd=dyn_rcfg_obj_inst[i].rx_fc_fwd;
	       top_env.env_ip[i].spy_if.sa=dyn_rcfg_obj_inst[i].sa;
               top_env.env_ip[i].spy_if.an_ch_sel= dyn_rcfg_obj_inst[i].an_chan0 ;
	       top_env.env_ip[i].spy_if.txvlan=dyn_rcfg_obj_inst[i].txvlan;
	       top_env.env_ip[i].spy_if.rxvlan=dyn_rcfg_obj_inst[i].rxvlan;
	       top_env.env_ip[i].spy_if.en_mx_frsz=dyn_rcfg_obj_inst[i].en_mx_frsz;
	       top_env.env_ip[i].spy_if.en_async_adp=dyn_rcfg_obj_inst[i].en_async_adp;
	       top_env.env_ip[i].spy_if.preamble_passthrough=dyn_rcfg_obj_inst[i].preamble_passthrough;
	       top_env.env_ip[i].spy_if.sfd=dyn_rcfg_obj_inst[i].sfd;
	       top_env.env_ip[i].spy_if.lf=dyn_rcfg_obj_inst[i].lf;
	       top_env.env_ip[i].spy_if.rxbyte_rem=dyn_rcfg_obj_inst[i].rxbyte_rem;
	       top_env.env_ip[i].spy_if.fc_rdy_drop=dyn_rcfg_obj_inst[i].fc_rdy_drop;
	       top_env.env_ip[i].spy_if.rdy_lat=dyn_rcfg_obj_inst[i].rdy_lat;
	       top_env.env_ip[i].spy_if.phyrefclk=dyn_rcfg_obj_inst[i].phyrefclk;
	       top_env.env_ip[i].spy_if.syspllcnt=dyn_rcfg_obj_inst[i].syspllcnt;
	       top_env.env_ip[i].spy_if.syspll=dyn_rcfg_obj_inst[i].syspll;
	       top_env.env_ip[i].spy_if.ipg=dyn_rcfg_obj_inst[i].ipg;
	       $cast(top_env.env_ip[i].spy_if.fec_type, dyn_rcfg_obj_inst[i].fec_type);
	       top_env.env_ip[i].spy_if.tx_frm_size=dyn_rcfg_obj_inst[i].tx_frm_size;
	       top_env.env_ip[i].spy_if.rx_frm_size=dyn_rcfg_obj_inst[i].rx_frm_size;
	       top_env.env_ip[i].spy_if.ipg_rm_perperiod=dyn_rcfg_obj_inst[i].ipg_rm_perperiod;
       	 $cast(top_env.env_ip[i].spy_if.mode, dyn_rcfg_obj_inst[i].mode);
       	 top_env.env_ip[i].spy_if.fc=dyn_rcfg_obj_inst[i].fc;
       	 top_env.env_ip[i].spy_if.fp_width=dyn_rcfg_obj_inst[i].fp_width;          
        if(m_sequence == "eth_ipg_sequence") top_env.env_ip[i].spy_if.ipg_check_enable=1'b1;
        $display("Inside base test: Syspllcst %0d, %0b, %0h",top_env.env_ip[i].spy_if.syspllcnt,top_env.env_ip[i].spy_if.syspllcnt,top_env.env_ip[i].spy_if.syspllcnt);
     	end
endtask
