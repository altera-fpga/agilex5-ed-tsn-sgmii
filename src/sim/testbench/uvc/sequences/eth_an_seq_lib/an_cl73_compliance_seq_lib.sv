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


class eth_testsuite_cl73_comp_base_seq extends an_base_sequence;
  
  `uvm_object_utils(eth_testsuite_cl73_comp_base_seq)

   integer first_case, last_case;
   uvm_reg_data_t read_data;
   bit [31:0] an_c0_reg;
   bit 	      an_np_ctrl=0;
   bit  nonce_possibility_en;
   bit  dis_stats_chk;
           
  function new(string name = "eth_testsuite_cl73_comp_base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_cl73_comp_base_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
     dis_stats_chk=1;
  endfunction:new

  virtual task pre_start();
     cmpl_seq = 1;
     super.pre_start();
  endtask:pre_start
   
  virtual task automatic cl73_comp_base_task(speed_e speed, int node, int inst);
     `uvm_info("eth_testsuite_cl73_comp_base_seq", "Executing eth_testsuite_cl73_comp_base_seq ...", UVM_NONE)
       if(anlt_std == CONSORTIUM)
         anlt_std = CONSORTIUM;
       else
         anlt_std = get_anlt_std(speed,inst);

       //config VIP DME page
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

       //p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TRANSMIT_NONCE_FIELD,$urandom_range(1,31));
       an_c0_reg = {16'h737D,12'b0,1'b0,an_np_ctrl,1'b0,1'b1};
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),an_c0_reg,speed); 
     // Disable Link training
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),32'h10,speed);
       if (first_case inside {57,112}) begin
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),32'h2001,speed);
       end
      else begin 
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),32'h2003,speed);
       end
     check_reg_wr_rd(speed,inst);

       p_sequencer.top_env.env_ip[inst].ts_tasks_if.speed = speed;
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.node = node;
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.inst = inst;
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.ch_num = p_sequencer.top_env.env_ip[inst].spy_if.ch_num;
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.fec_type = p_sequencer.top_env.env_ip[inst].spy_if.fec_type;
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.cr_mode = p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.cr_mode;
       p_sequencer.top_env.env_ip[inst].ts_tasks_if.enable_scoreboard = 1;
       ->p_sequencer.top_env.env_ip[inst].ts_tasks_if.test_start;
     `uvm_info(get_type_name(), $sformatf("vnot0"), UVM_LOW)

     wait_for_an_done_and_rfg_vip(speed,inst);

     fork
       forever begin
         @(posedge p_sequencer.top_env.env_ip[inst].spy_if.an_done);
         if(p_sequencer.top_env.env_ip[inst].ts_tasks_if.enable_scoreboard)
           p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(0);
         else
           p_sequencer.top_env.env_ip[inst].dynamic_enable_disable_scoreboards(1);
       end
     join_none

     fork
	forever begin
	  p_sequencer.top_env.nonce_possibility(speed,inst);
	end
     join_none
     #10ns;
      @(p_sequencer.top_env.env_ip[inst].ts_tasks_if.test_done);
     `uvm_info(get_type_name(), $sformatf("vnot1"), UVM_LOW)
      
     p_sequencer.top_env.disable_an_snps_errors(speed,inst);
     `uvm_info(get_type_name(), $sformatf("vnot2"), UVM_LOW)

     `uvm_info("eth_testsuite_cl73_comp_base_seq", "Exiting eth_testsuite_cl73_comp_base_seq ...", UVM_NONE)   
  endtask:cl73_comp_base_task

  virtual task body();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;
     string func_name = "eth_testsuite_cl73_comp_base_seq_body";
     `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
     get_inst_num();
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
             if(p_sequencer.top_env.kr_cfg_inst.active_10g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
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
             if(p_sequencer.top_env.kr_cfg_inst.active_25g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
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
             if(p_sequencer.top_env.kr_cfg_inst.active_40g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
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
             if(p_sequencer.top_env.kr_cfg_inst.active_50g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
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
             if(p_sequencer.top_env.kr_cfg_inst.active_100g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
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
             if(p_sequencer.top_env.kr_cfg_inst.active_200g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_400g) begin
           node_idx_400g = get_start_node(_400G);
           for(int inst=0;inst<num_inst_400g;inst++) begin
             automatic int idx = node_idx_400g;
             automatic int i=inst;
             `uvm_info(get_type_name(), $sformatf("Speed 400G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
             if(p_sequencer.top_env.kr_cfg_inst.active_400g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]) begin
               //fork
                 //begin
                   cl73_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
         end
       end
     join
     `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
   endtask:body
   
   virtual task check_reset_event(int inst);
      fork
	 begin
	    p_sequencer.top_env.env_ip[inst].ts_tasks_if.monitor_hard_reset_event();
            //FIX_ME: vinoth2x - Remove below code since hard reset is applied during reset phase
	    //apply_hard_reset(0,0,1,11);
	 end
	 begin
	    while(1) begin
	       #100ns;
	    end
	 end
      join_none
   endtask; // check_reset_event
endclass : eth_testsuite_cl73_comp_base_seq

class an_cl73_comp_seq1 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq1)

  function new(string name = "an_cl73_comp_seq1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 1;
     last_case = 1;
     super.pre_start();
     `uvm_info(get_type_name(), $sformatf("vnot"), UVM_LOW)
  endtask:pre_start
   
endclass : an_cl73_comp_seq1

class an_cl73_comp_seq2 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq2)

  function new(string name = "an_cl73_comp_seq2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 2;
     last_case = 2;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq2

class an_cl73_comp_seq3 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq3)

  function new(string name = "an_cl73_comp_seq3");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 3;
     last_case = 3;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq3

class an_cl73_comp_seq4 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq4)

  function new(string name = "an_cl73_comp_seq4");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 4;
     last_case = 4;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq4

class an_cl73_comp_seq5 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq5)

  function new(string name = "an_cl73_comp_seq5");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 5;
     last_case = 5;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq5

class an_cl73_comp_seq6 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq6)

  function new(string name = "an_cl73_comp_seq6");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 6;
     last_case = 6;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq6

class an_cl73_comp_seq7 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq7)

  function new(string name = "an_cl73_comp_seq7");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 7;
     last_case = 7;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq7

class an_cl73_comp_seq8 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq8)

  function new(string name = "an_cl73_comp_seq8");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 8;
     last_case = 8;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq8

class an_cl73_comp_seq9 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq9)

  function new(string name = "an_cl73_comp_seq9");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 9;
     last_case = 9;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq9

class an_cl73_comp_seq10 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq10)

  function new(string name = "an_cl73_comp_seq10");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 10;
     last_case = 10;
     super.pre_start();
     //no_traffic = 1;
  endtask:pre_start
   
endclass : an_cl73_comp_seq10

class an_cl73_comp_seq11 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq11)

  function new(string name = "an_cl73_comp_seq11");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 11;
     last_case = 11;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq11

class an_cl73_comp_seq12 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq12)

  function new(string name = "an_cl73_comp_seq12");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 12;
     last_case = 12;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq12

class an_cl73_comp_seq13 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq13)

  function new(string name = "an_cl73_comp_seq13");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 13;
     last_case = 13;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq13

class an_cl73_comp_seq14 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq14)

  function new(string name = "an_cl73_comp_seq14");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 14;
     last_case = 14;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq14

class an_cl73_comp_seq15 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq15)

  function new(string name = "an_cl73_comp_seq15");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 15;
     last_case = 15;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq15

class an_cl73_comp_seq16 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq16)

  function new(string name = "an_cl73_comp_seq16");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 16;
     last_case = 16;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq16
class an_cl73_comp_seq17 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq17)

  function new(string name = "an_cl73_comp_seq17");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 17;
     last_case = 17;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq17

class an_cl73_comp_seq18 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq18)

  function new(string name = "an_cl73_comp_seq18");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 18;
     last_case = 18;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq18

class an_cl73_comp_seq19 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq19)

  function new(string name = "an_cl73_comp_seq19");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 19;
     last_case = 19;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq19

class an_cl73_comp_seq24 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq24)

  function new(string name = "an_cl73_comp_seq24");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 24;
     last_case = 24;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq24

class an_cl73_comp_seq25 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq25)

  function new(string name = "an_cl73_comp_seq25");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 25;
     last_case = 25;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq25

class an_cl73_comp_seq26 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq26)

  function new(string name = "an_cl73_comp_seq26");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 26;
     last_case = 26;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq26

class an_cl73_comp_seq27 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq27)

  function new(string name = "an_cl73_comp_seq27");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 27;
     last_case = 27;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq27

class an_cl73_comp_seq28 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq28)

  function new(string name = "an_cl73_comp_seq28");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 28;
     last_case = 28;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq28

class an_cl73_comp_seq29 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq29)

  function new(string name = "an_cl73_comp_seq29");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 29;
     last_case = 29;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq29

class an_cl73_comp_seq30 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq30)

  function new(string name = "an_cl73_comp_seq30");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 30;
     last_case = 30;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq30

class an_cl73_comp_seq31 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq31)

  function new(string name = "an_cl73_comp_seq31");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 31;
     last_case = 31;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq31

class an_cl73_comp_seq32 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq32)

  function new(string name = "an_cl73_comp_seq32");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 32;
     last_case = 32;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq32

class an_cl73_comp_seq33 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq33)

  function new(string name = "an_cl73_comp_seq33");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 33;
     last_case = 33;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq33

class an_cl73_comp_seq34 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq34)

  function new(string name = "an_cl73_comp_seq34");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 34;
     last_case = 34;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq34

class an_cl73_comp_seq35 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq35)

  function new(string name = "an_cl73_comp_seq35");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 35;
     last_case = 35;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq35

class an_cl73_comp_seq36 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq36)

  function new(string name = "an_cl73_comp_seq36");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 36;
     last_case = 36;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq36

class an_cl73_comp_seq37 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq37)

  function new(string name = "an_cl73_comp_seq37");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 37;
     last_case = 37;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq37

class an_cl73_comp_seq38 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq38)

  function new(string name = "an_cl73_comp_seq38");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 38;
     last_case = 38;
     an_np_ctrl=1;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq38

class an_cl73_comp_seq39 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq39)

  function new(string name = "an_cl73_comp_seq39");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 39;
     last_case = 39;
     an_np_ctrl=1;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq39

class an_cl73_comp_seq40 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq40)

  function new(string name = "an_cl73_comp_seq40");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 40;
     last_case = 40;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq40

class an_cl73_comp_seq41 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq41)

  function new(string name = "an_cl73_comp_seq41");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 41;
     last_case = 41;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq41

class an_cl73_comp_seq45 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq45)

  function new(string name = "an_cl73_comp_seq45");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 45;
     last_case = 45;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq45

class an_cl73_comp_seq46 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq46)

  function new(string name = "an_cl73_comp_seq46");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 46;
     last_case = 46;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq46

class an_cl73_comp_seq49 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq49)

  function new(string name = "an_cl73_comp_seq49");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 49;
     last_case = 49;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq49

class an_cl73_comp_seq50 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq50)

  function new(string name = "an_cl73_comp_seq50");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 50;
     last_case = 50;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq50

class an_cl73_comp_seq51 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq51)

  function new(string name = "an_cl73_comp_seq51");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 51;
     last_case = 51;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq51

class an_cl73_comp_seq52 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq52)

  function new(string name = "an_cl73_comp_seq52");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 52;
     last_case = 52;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq52

class an_cl73_comp_seq53 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq53)

  function new(string name = "an_cl73_comp_seq53");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 53;
     last_case = 53;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq53

class an_cl73_comp_seq54 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq54)

  function new(string name = "an_cl73_comp_seq54");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 54;
     last_case = 54;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq54

class an_cl73_comp_seq55 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq55)

  function new(string name = "an_cl73_comp_seq55");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 55;
     last_case = 55;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq55

class an_cl73_comp_seq56 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq56)

  function new(string name = "an_cl73_comp_seq56");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 56;
     last_case = 56;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq56

class an_cl73_comp_seq57 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq57)

  function new(string name = "an_cl73_comp_seq57");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 57;
     last_case = 57;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq57

class an_cl73_comp_seq58 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq58)

  function new(string name = "an_cl73_comp_seq58");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 58;
     last_case = 58;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq58

class an_cl73_comp_seq59 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq59)

  function new(string name = "an_cl73_comp_seq59");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 59;
     last_case = 59;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq59

class an_cl73_comp_seq60 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq60)

  function new(string name = "an_cl73_comp_seq60");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 60;
     last_case = 60;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq60

class an_cl73_comp_seq65 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq65)

  function new(string name = "an_cl73_comp_seq65");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 65;
     last_case = 65;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq65

class an_cl73_comp_seq66 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq66)

  function new(string name = "an_cl73_comp_seq66");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 66;
     last_case = 66;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq66

class an_cl73_comp_seq67 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq67)

  function new(string name = "an_cl73_comp_seq67");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 67;
     last_case = 67;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq67

class an_cl73_comp_seq68 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq68)

  function new(string name = "an_cl73_comp_seq68");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 68;
     last_case = 68;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq68

class an_cl73_comp_seq69 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq69)

  function new(string name = "an_cl73_comp_seq69");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 69;
     last_case = 69;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq69

class an_cl73_comp_seq70 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq70)

  function new(string name = "an_cl73_comp_seq70");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 70;
     last_case = 70;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq70

class an_cl73_comp_seq71 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq71)

  function new(string name = "an_cl73_comp_seq71");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 71;
     last_case = 71;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq71

class an_cl73_comp_seq72 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq72)

  function new(string name = "an_cl73_comp_seq72");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 72;
     last_case = 72;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq72

class an_cl73_comp_seq73 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq73)

  function new(string name = "an_cl73_comp_seq73");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 73;
     last_case = 73;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq73


class an_cl73_comp_seq74 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq74)

  function new(string name = "an_cl73_comp_seq74");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 74;
     last_case = 74;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq74

class an_cl73_comp_seq75 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq75)

  function new(string name = "an_cl73_comp_seq75");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 75;
     last_case = 75;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq75

class an_cl73_comp_seq76 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq76)

  function new(string name = "an_cl73_comp_seq76");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 76;
     last_case = 76;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq76

class an_cl73_comp_seq77 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq77)

  function new(string name = "an_cl73_comp_seq77");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 77;
     last_case = 77;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq77

class an_cl73_comp_seq78 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq78)

  function new(string name = "an_cl73_comp_seq78");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 78;
     last_case = 78;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq78

class an_cl73_comp_seq79 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq79)

  function new(string name = "an_cl73_comp_seq79");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 79;
     last_case = 79;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq79

class an_cl73_comp_seq83 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq83)

  function new(string name = "an_cl73_comp_seq83");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 83;
     last_case = 83;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq83

class an_cl73_comp_seq84 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq84)

  function new(string name = "an_cl73_comp_seq84");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 84;
     last_case = 84;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq84

class an_cl73_comp_seq87 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq87)

  function new(string name = "an_cl73_comp_seq87");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 87;
     last_case = 87;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq87

class an_cl73_comp_seq88 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq88)

  function new(string name = "an_cl73_comp_seq88");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 88;
     last_case = 88;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq88

class an_cl73_comp_seq89 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq89)

  function new(string name = "an_cl73_comp_seq89");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 89;
     last_case = 89;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq89

class an_cl73_comp_seq90 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq90)

  function new(string name = "an_cl73_comp_seq90");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 90;
     last_case = 90;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq90

class an_cl73_comp_seq91 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq91)

  function new(string name = "an_cl73_comp_seq91");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 91;
     last_case = 91;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq91

class an_cl73_comp_seq92 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq92)

  function new(string name = "an_cl73_comp_seq92");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 92;
     last_case = 92;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq92

class an_cl73_comp_seq93 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq93)

  function new(string name = "an_cl73_comp_seq93");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 93;
     last_case = 93;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq93

class an_cl73_comp_seq97 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq97)

  function new(string name = "an_cl73_comp_seq97");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 97;
     last_case = 97;
     an_np_ctrl=1;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq97

class an_cl73_comp_seq101 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq101)

  function new(string name = "an_cl73_comp_seq101");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 101;
     last_case = 101;
     an_np_ctrl=1;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq101

class an_cl73_comp_seq102 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq102)

  function new(string name = "an_cl73_comp_seq102");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 102;
     last_case = 102;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq102

class an_cl73_comp_seq103 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq103)

  function new(string name = "an_cl73_comp_seq103");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 103;
     last_case = 103;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq103

class an_cl73_comp_seq104 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq104)

  function new(string name = "an_cl73_comp_seq104");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 104;
     last_case = 104;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq104

class an_cl73_comp_seq107 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq107)

  function new(string name = "an_cl73_comp_seq107");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 107;
     last_case = 107;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq107

class an_cl73_comp_seq110 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq110)

  function new(string name = "an_cl73_comp_seq110");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 110;
     last_case = 110;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq110

class an_cl73_comp_seq111 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq111)

  function new(string name = "an_cl73_comp_seq111");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 111;
     last_case = 111;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq111


class an_cl73_comp_seq112 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq112)

  function new(string name = "an_cl73_comp_seq112");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 112;
     last_case = 112;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq112

class an_cl73_comp_seq113 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq113)

  function new(string name = "an_cl73_comp_seq113");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 113;
     last_case = 113;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq113


class an_cl73_comp_seq116 extends eth_testsuite_cl73_comp_base_seq;
  
  `uvm_object_utils(an_cl73_comp_seq116)

  function new(string name = "an_cl73_comp_seq116");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_start();
     first_case = 116;
     last_case = 116;
     super.pre_start();
  endtask:pre_start
   
endclass : an_cl73_comp_seq116
