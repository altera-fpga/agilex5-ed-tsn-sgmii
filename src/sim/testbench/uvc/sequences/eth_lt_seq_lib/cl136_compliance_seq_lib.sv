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



class eth_testsuite_cl136_comp_base_seq extends an_base_sequence;
  
  `uvm_object_utils(eth_testsuite_cl136_comp_base_seq)

   integer first_case, last_case;
   uvm_reg_data_t read_data;
   bit AN_EN;
   uvm_reg_data_t read_data_1;
   uvm_reg_data_t read_data_2;
   uvm_reg_data_t read_data_3;
   uvm_reg_data_t read_data_4;
   bit 	   send_frames=0;
   int frame_counter[4];
   bit[11:0]  int_seed[4];
   bit  [4:0]    dut_nonce_field;
   bit  [4:0]    unique_nonce_field;
   bit              dis_stats_chk;
        
  function new(string name = "eth_testsuite_cl136_comp_base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_cl136_comp_base_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_cl136_comp_base_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
     dis_stats_chk=1;
  endfunction:new

  virtual task pre_body();
  endtask; // pre_body
   
   task cl136_comp_base_task(speed_e speed, int node, int inst);
    //ep_sequencer.top_env.apply_hard_reset(0,0,1,11);
     `uvm_info("eth_testsuite_cl136_comp_base_seq", "Executing eth_testsuite_cl136_comp_base_seq ...", UVM_NONE)

     int_seed[0] = 'h57E;
     int_seed[1] = 'h645;
     int_seed[2] = 'h72D;
     int_seed[3] = 'h7B6;

     if(first_case == 16) begin
         AN_EN = 1;
       end
       else begin
        AN_EN = 0;
         end

     `uvm_info("eth_testsuite_cl136_comp_base_seq", $psprintf("Auto negotiation enable in CL136 compliance : AN_EN = %0d",AN_EN), UVM_NONE);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed,.disable_check(1'b1));
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed,1);
     read_data[0] = 1;
     read_data[4] = 1;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed,.disable_check(1'b1));
     read_data[0] = AN_EN;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed);
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);
     read_data[0] = 1;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"), read_data,speed);

     if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.speed == _100G) begin
        p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
        read_data[15:4] = 1;
        p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"), read_data,speed);
     end
	 

     if(!AN_EN) begin
       p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,inst);
     end
     else begin 
            unique_nonce_field = $urandom();
            while(unique_nonce_field == 'h13)
            begin
              unique_nonce_field = $urandom();
            end
            //p_sequencer.top_env.env_ip[inst].mac_callback.link_trans.an73_transmit_nonce_field=unique_nonce_field;
	    p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TRANSMIT_NONCE_FIELD,unique_nonce_field);
          wait (p_sequencer.top_env.env_ip[inst].spy_if.an_done==1'b1);
     `uvm_info("eth_testsuite_cl136_comp_base_seq", "AN is UP ...", UVM_NONE)
         p_sequencer.top_env.reconfig_vip_for_lt_mode(speed,inst); 
     end

     `uvm_info("eth_testsuite_cl136_comp_base_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_NONE)
     //p_sequencer.top_env.env_ip[inst].ts_tasks_if.start_testsuite_test();
     ->p_sequencer.top_env.env_ip[inst].ts_tasks_if.test_start;
     `uvm_info("eth_testsuite_cl136_comp_base_seq", "start_testsuite_test done ...", UVM_NONE)
     check_reset_event(inst);
     `uvm_info("eth_testsuite_cl136_comp_base_seq", "check_reset_event done ...", UVM_NONE)
     //check_reg_wr_rd();
    // #10ns;
     //p_sequencer.top_env.env_ip[inst].ts_tasks_if.wait_for_testsuite_test_finish();
     @p_sequencer.top_env.env_ip[inst].ts_tasks_if.test_done;

     //if (send_frames) begin
     //   p_sequencer.top_env.env_ip[inst].wait_rx_pcs_ready();
     //   t_send_frames();
     //end
     `uvm_info("eth_testsuite_cl136_comp_base_seq", "Exiting eth_testsuite_cl136_comp_base_seq ...", UVM_NONE)   
  endtask // body

  virtual task body();
     string func_name = " cl136_compliance_seq";
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;

     string func_name = "eth_testsuite_cl136_comp_base_seq_body";
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
                   cl136_comp_base_task(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
                 //end
               //join_none
             end
           end
         end
       end
     join
     `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
   endtask


  
  task t_send_frames();
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
   endtask // send_frames

   virtual task check_reset_event(int inst);
      fork
	 begin
	    p_sequencer.top_env.env_ip[inst].ts_tasks_if.monitor_hard_reset_event();
	    //apply_hard_reset(0,0,1,11);
	 end
	 begin
	    while(1) begin
	       #100ns;
	    end
	 end
      join_none
   endtask; // check_reset_event
   
endclass : eth_testsuite_cl136_comp_base_seq

class lt_cl136_comp_seq1 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq1)

  function new(string name = "lt_cl136_comp_seq1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 1;
     last_case = 1;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq1

class lt_cl136_comp_seq2 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq2)

  function new(string name = "lt_cl136_comp_seq2");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 2;
     last_case = 2;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq2

class lt_cl136_comp_seq3 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq3)

  function new(string name = "lt_cl136_comp_seq3");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 3;
     last_case = 3;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq3

class lt_cl136_comp_seq4 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq4)

  function new(string name = "lt_cl136_comp_seq4");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 4;
     last_case = 4;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq4

class lt_cl136_comp_seq5 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq5)

  function new(string name = "lt_cl136_comp_seq5");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 5;
     last_case = 5;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq5

class lt_cl136_comp_seq6 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq6)

  function new(string name = "lt_cl136_comp_seq6");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 6;
     last_case = 6;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq6

class lt_cl136_comp_seq7 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq7)

  function new(string name = "lt_cl136_comp_seq7");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 7;
     last_case = 7;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq7

class lt_cl136_comp_seq8 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq8)

  function new(string name = "lt_cl136_comp_seq8");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 8;
     last_case = 8;
     send_frames = 0;
  endtask; // pre_body
  
endclass : lt_cl136_comp_seq8

class lt_cl136_comp_seq9 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq9)

  function new(string name = "lt_cl136_comp_seq9");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 9;
     last_case = 9;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq9

class lt_cl136_comp_seq10 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq10)

  function new(string name = "lt_cl136_comp_seq10");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 10;
     last_case = 10;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq10

class lt_cl136_comp_seq11 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq11)

  function new(string name = "lt_cl136_comp_seq11");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 11;
     last_case = 11;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq11

class lt_cl136_comp_seq12 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq12)

  function new(string name = "lt_cl136_comp_seq12");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 12;
     last_case = 12;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq12

class lt_cl136_comp_seq13 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq13)

  function new(string name = "lt_cl136_comp_seq13");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 13;
     last_case = 13;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq13

class lt_cl136_comp_seq14 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq14)

  function new(string name = "lt_cl136_comp_seq14");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 14;
     last_case = 14;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq14

class lt_cl136_comp_seq15 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq15)

  function new(string name = "lt_cl136_comp_seq15");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 15;
     last_case = 15;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq15

class lt_cl136_comp_seq16 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq16)

  function new(string name = "lt_cl136_comp_seq16");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 16;
     last_case = 16;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq16

class lt_cl136_comp_seq17 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq17)

  function new(string name = "lt_cl136_comp_seq17");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 17;
     last_case = 17;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq17
class lt_cl136_comp_seq18 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq18)

  function new(string name = "lt_cl136_comp_seq18");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 18;
     last_case = 18;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq18

class lt_cl136_comp_seq19 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq19)

  function new(string name = "lt_cl136_comp_seq19");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 19;
     last_case = 19;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq19

class lt_cl136_comp_seq20 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq20)

  function new(string name = "lt_cl136_comp_seq20");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 20;
     last_case = 20;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq20

class lt_cl136_comp_seq21 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq21)

  function new(string name = "lt_cl136_comp_seq21");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 21;
     last_case = 21;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq21

class lt_cl136_comp_seq22 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq22)

  function new(string name = "lt_cl136_comp_seq22");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 22;
     last_case = 22;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq22

class lt_cl136_comp_seq23 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq23)

  function new(string name = "lt_cl136_comp_seq23");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 23;
     last_case = 23;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq23

class lt_cl136_comp_seq24 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq24)

  function new(string name = "lt_cl136_comp_seq24");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 24;
     last_case = 24;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq24

class lt_cl136_comp_seq25 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq25)

  function new(string name = "lt_cl136_comp_seq25");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 25;
     last_case = 25;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq25

class lt_cl136_comp_seq26 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq26)

  function new(string name = "lt_cl136_comp_seq26");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 26;
     last_case = 26;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq26

class lt_cl136_comp_seq27 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq27)

  function new(string name = "lt_cl136_comp_seq27");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 27;
     last_case = 27;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq27

class lt_cl136_comp_seq28 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq28)

  function new(string name = "lt_cl136_comp_seq28");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 28;
     last_case = 28;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq28

class lt_cl136_comp_seq29 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq29)

  function new(string name = "lt_cl136_comp_seq29");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 29;
     last_case = 29;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq29

class lt_cl136_comp_seq30 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq30)

  function new(string name = "lt_cl136_comp_seq30");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 30;
     last_case = 30;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq30

class lt_cl136_comp_seq31 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq31)

  function new(string name = "lt_cl136_comp_seq31");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 31;
     last_case = 31;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq31

class lt_cl136_comp_seq32 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq32)

  function new(string name = "lt_cl136_comp_seq32");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 32;
     last_case = 32;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq32

class lt_cl136_comp_seq33 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq33)

  function new(string name = "lt_cl136_comp_seq33");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 33;
     last_case = 33;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq33

class lt_cl136_comp_seq34 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq34)

  function new(string name = "lt_cl136_comp_seq34");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 34;
     last_case = 34;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq34

class lt_cl136_comp_seq35 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq35)

  function new(string name = "lt_cl136_comp_seq35");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 35;
     last_case = 35;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq35

class lt_cl136_comp_seq36 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq36)

  function new(string name = "lt_cl136_comp_seq36");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 36;
     last_case = 36;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq36

class lt_cl136_comp_seq37 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq37)

  function new(string name = "lt_cl136_comp_seq37");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 37;
     last_case = 37;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq37

class lt_cl136_comp_seq38 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq38)

  function new(string name = "lt_cl136_comp_seq38");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 38;
     last_case = 38;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq38

class lt_cl136_comp_seq39 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq39)

  function new(string name = "lt_cl136_comp_seq39");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 39;
     last_case = 39;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq39

class lt_cl136_comp_seq40 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq40)

  function new(string name = "lt_cl136_comp_seq40");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 40;
     last_case = 40;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq40

class lt_cl136_comp_seq41 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq41)

  function new(string name = "lt_cl136_comp_seq41");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 41;
     last_case = 41;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq41

class lt_cl136_comp_seq42 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq42)

  function new(string name = "lt_cl136_comp_seq42");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 42;
     last_case = 42;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq42

class lt_cl136_comp_seq43 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq43)

  function new(string name = "lt_cl136_comp_seq43");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 43;
     last_case = 43;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq43

class lt_cl136_comp_seq44 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq44)

  function new(string name = "lt_cl136_comp_seq44");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 44;
     last_case = 44;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq44

class lt_cl136_comp_seq45 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq45)

  function new(string name = "lt_cl136_comp_seq45");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 45;
     last_case = 45;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq45

class lt_cl136_comp_seq46 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq46)

  function new(string name = "lt_cl136_comp_seq46");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 46;
     last_case = 46;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq46

class lt_cl136_comp_seq47 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq47)

  function new(string name = "lt_cl136_comp_seq47");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 47;
     last_case = 47;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq47

class lt_cl136_comp_seq48 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq48)

  function new(string name = "lt_cl136_comp_seq48");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 48;
     last_case = 48;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq48

class lt_cl136_comp_seq49 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq49)

  function new(string name = "lt_cl136_comp_seq49");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 49;
     last_case = 49;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq49

class lt_cl136_comp_seq50 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq50)

  function new(string name = "lt_cl136_comp_seq50");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 50;
     last_case = 50;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq50

class lt_cl136_comp_seq51 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq51)

  function new(string name = "lt_cl136_comp_seq51");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 51;
     last_case = 51;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq51

class lt_cl136_comp_seq52 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq52)

  function new(string name = "lt_cl136_comp_seq52");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 52;
     last_case = 52;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq52

class lt_cl136_comp_seq53 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq53)

  function new(string name = "lt_cl136_comp_seq53");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 53;
     last_case = 53;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq53

class lt_cl136_comp_seq54 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq54)

  function new(string name = "lt_cl136_comp_seq54");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 54;
     last_case = 54;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq54

class lt_cl136_comp_seq55 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq55)

  function new(string name = "lt_cl136_comp_seq55");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 55;
     last_case = 55;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq55

class lt_cl136_comp_seq56 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq56)

  function new(string name = "lt_cl136_comp_seq56");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 56;
     last_case = 56;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq56

class lt_cl136_comp_seq57 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq57)

  function new(string name = "lt_cl136_comp_seq57");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 57;
     last_case = 57;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq57

class lt_cl136_comp_seq58 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq58)

  function new(string name = "lt_cl136_comp_seq58");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 58;
     last_case = 58;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq58

class lt_cl136_comp_seq59 extends eth_testsuite_cl136_comp_base_seq;
  
  `uvm_object_utils(lt_cl136_comp_seq59)

  function new(string name = "lt_cl136_comp_seq59");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task pre_body();
     first_case = 59;
     last_case = 59;
     send_frames = 0;
  endtask; // pre_body
   
endclass : lt_cl136_comp_seq59


