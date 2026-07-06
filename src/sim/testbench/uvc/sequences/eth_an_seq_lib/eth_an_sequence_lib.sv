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


class an_base_sequence extends uvm_sequence #(uvm_sequence_item);
   `uvm_object_utils(an_base_sequence)
   `uvm_declare_p_sequencer(eth_top_virtual_sequencer)

   uvm_reg_data_t read_data;
   uvm_reg_data_t exp_read_data;

   bit [31:0] an_c0_reg;
   bit 	      lt_on=1;
   bit 	      seq_2=0;
   bit 	      data_on=0;
   bit 	      an_on=1;
   bit 	      rf=0;
   bit 	      ignore_nonce=0;
   bit 	      an_bp_ctrl=0;
   bit 	      an_np_ctrl=0;
   bit 	      an_ovrd_param=0;  
   bit 	      tx_disable=0;
   bit [48:0] vip_page_received;
   bit [48:0] vip_page_sent;
   bit [48:0] vip_base_page_received;
   bit [48:0] vip_base_page_sent;
   bit [48:0] vip_next_page_sent;
   bit [11:0] hcd;
   bit [24:0] an_tech;
   bit [2:0]  an_pause;
   bit [3:0]  an_fec;
   bit 	      LFI_timer_done=0;
   bit 	      AN_timer_done=0;
   bit 	      one_sec_timer_done;
   bit [31:0] c3_data;
   bit [31:0] c4_data;
   bit [31:0] c5_data;
   bit [31:0] c6_data;
   bit [31:0] c7_data;
   bit [31:0] c8_data;
   bit [31:0] c9_data;
   bit [31:0] ca_data; 
   bit [31:0] cb_data;  
   bit [31:0] ce_data;  
   bit [47:0] usr_bp;
   bit [4:0]  tnonce;
   bit 	      an_timeout_status=0;
   bit 	      lt_timeout_status=0;
   bit 	      link_up_status=0;
   longint    lf_timeout_time;
   longint    an_timeout_time;
   longint    one_sec_timeout_time;
   bit 	      skip_c3_delay=1;
   bit 	      LT_started=0;
   bit 	      ovrd_an_on;
   bit 	      ovrd_rf_on;
   bit 	      ovrd_lt_on;
   bit 	      allow_enable_errors=1;
   int        num_inst_10g;
   int        num_inst_25g;
   int        num_inst_40g;
   int        num_inst_50g;
   int        num_inst_100g;
   int        num_inst_200g;
   int        num_inst_400g;
   bit        cmpl_seq;
   bit        reg_access_seq;
   bit        next_page_test=0;
   bit        recfg_rst;
   bit        vip_np_en;
   int 	      vip_np_num;
   bit [3:0]  vip_fec_cap;
   bit [1:0]  vip_pause_cap;
   bit        vip_rf;
   bit        ll_fec_neg;
   bit        rs_fec_neg;
   bit[17:0]  neg_port;
   bit        neg_fail;
   bit        consortium_np_rcvd;
   bit        an_fail;
   bit        baser_fec_neg_en;
   bit        an_lp_ability = 1;
   bit        an_status;
   bit        an_ability = 1;
   bit        an_adv_rf;
   bit        an_complete = 1;
   bit        an_page_rcvd = 1;
   anlt_std_e anlt_std; 
            
   function new(string name = "an_base_sequence");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new

     task automatic send_eth_frame(frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int no_of_frames=1,int inst = 0);
       bit [47:0] dest_address = 'h01_80_c2_00_00_01;
       alt_eth_avalonst_base_sequence avl_tx_pkt;
       `ifdef ENABLE_ETH_VIP
         alt_eth_vip_base_sequence eth_seq;
       `endif
       string task_name = "send_eth_frame";
       `uvm_info(get_type_name(), $sformatf("%s: BEGIN",task_name), UVM_LOW);
       `ifdef ENABLE_ETH_VIP
         // RX PATH
         if(path inside {ETH_VIP_AVL_RX,ETH_VIP_MAC_BOTH}) begin
           `uvm_create_on(eth_seq, p_sequencer.virtual_sequencer_inst[inst].eth_vip_seqr_inst);

           eth_seq.eth_frame = f_type;
           eth_seq.sequence_length = no_of_frames;
           eth_seq.dest_address = dest_address;

           `uvm_info("send_eth_frame", $sformatf("sending %0s frame from vip tx",f_type.name()),UVM_MEDIUM);

           eth_seq.start(p_sequencer.virtual_sequencer_inst[inst].eth_vip_seqr_inst);
         end
       `endif

      // TX Path MAC/PCS_ONLY
      if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode inside {PCSONLY,PCSMAC,MACSEG}) begin      
        if(path inside {AVL_TX_ETH_VIP,ETH_VIP_MAC_BOTH}) begin 
          if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode == PCSONLY) begin
             `uvm_create_on(avl_tx_pkt, p_sequencer.top_env.env_ip[inst].mii_tx_agent.m_sqr);
          end else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode == PCSMAC) begin
             `uvm_create_on(avl_tx_pkt, p_sequencer.virtual_sequencer_inst[inst].tx_seqr);
          end
          else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode ==MACSEG) begin 
             `uvm_create_on(avl_tx_pkt,p_sequencer.virtual_sequencer_inst[inst].v_m_sqr);
          end

         avl_tx_pkt.eth_frame = f_type;
         avl_tx_pkt.sequence_length = no_of_frames;
         avl_tx_pkt.payload_size=$urandom_range(64,1500);
         avl_tx_pkt.bandwidth=0;  

         `uvm_info("send_eth_frame", $sformatf("sending %0s frame from avalon tx with payload = %d",f_type.name(),avl_tx_pkt.payload_size),UVM_MEDIUM);

         if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode == PCSONLY) begin
             avl_tx_pkt.start(p_sequencer.top_env.env_ip[inst].mii_tx_agent.m_sqr);
          end else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode == PCSMAC) begin
             avl_tx_pkt.start(p_sequencer.virtual_sequencer_inst[inst].tx_seqr);
          end
          else if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode ==MACSEG) begin 
              avl_tx_pkt.start(p_sequencer.virtual_sequencer_inst[inst].v_m_sqr);
          end
        end
      end
     `uvm_info(get_type_name(), $sformatf("%s: END",task_name), UVM_LOW)
     
     endtask:send_eth_frame

  task get_inst_num();
    num_inst_10g  = $countones(p_sequencer.top_env.kr_cfg_inst.active_10g);
    num_inst_25g  = $countones(p_sequencer.top_env.kr_cfg_inst.active_25g);
    num_inst_40g  = $countones(p_sequencer.top_env.kr_cfg_inst.active_40g);
    num_inst_50g  = $countones(p_sequencer.top_env.kr_cfg_inst.active_50g);
    num_inst_100g = $countones(p_sequencer.top_env.kr_cfg_inst.active_100g);
    num_inst_200g = $countones(p_sequencer.top_env.kr_cfg_inst.active_200g);
    num_inst_400g = $countones(p_sequencer.top_env.kr_cfg_inst.active_400g);
    `uvm_info(get_type_name(), $sformatf("Num of inst - 10G: %0d, 25G: %0d, 40G: %0d, 50G: %0d, 100G: %0d, 200G: %0d, 400G: %0d",num_inst_10g,num_inst_25g,num_inst_40g,num_inst_50g,num_inst_100g,num_inst_200g,num_inst_400g), UVM_NONE);
  endtask:get_inst_num
  

 `ifdef UVM_VERSION_1_1
  virtual task pre_start();
     int  node_idx_10g;
     int  node_idx_25g;
     int  node_idx_40g;
     int  node_idx_50g;
     int  node_idx_100g;
     int  node_idx_200g;
     int  node_idx_400g;

     if((get_parent_sequence() == null) && (starting_phase != null))
       starting_phase.raise_objection(this, "Starting");

     if(!cmpl_seq && !reg_access_seq) begin

     get_inst_num();

     `uvm_info(get_type_name(), $sformatf("Active nodes - 10G: %0b, 25G: %0b, 40G: %0b, 50G: %0b, 100G: %0b, 200G: %0b, 400G: %0b",p_sequencer.top_env.kr_cfg_inst.active_10g,p_sequencer.top_env.kr_cfg_inst.active_25g,p_sequencer.top_env.kr_cfg_inst.active_40g,p_sequencer.top_env.kr_cfg_inst.active_50g,p_sequencer.top_env.kr_cfg_inst.active_100g,p_sequencer.top_env.kr_cfg_inst.active_200g,p_sequencer.top_env.kr_cfg_inst.active_400g), UVM_NONE);
     `uvm_info(get_type_name(), $sformatf("ANLT nodes - 10G: %0b, 25G: %0b, 40G: %0b, 50G: %0b, 100G: %0b, 200G: %0b, 400G: %0b",p_sequencer.top_env.kr_cfg_inst.node_sel_10g,p_sequencer.top_env.kr_cfg_inst.node_sel_25g,p_sequencer.top_env.kr_cfg_inst.node_sel_40g,p_sequencer.top_env.kr_cfg_inst.node_sel_50g,p_sequencer.top_env.kr_cfg_inst.node_sel_100g,p_sequencer.top_env.kr_cfg_inst.node_sel_200g,p_sequencer.top_env.kr_cfg_inst.node_sel_400g), UVM_NONE);

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
             `uvm_info(get_type_name(), $sformatf("Speed 10G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_10g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx]), UVM_NONE);
               if(p_sequencer.top_env.kr_cfg_inst.active_10g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_10g[idx])
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
           end
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
             `uvm_info(get_type_name(), $sformatf("Speed 25G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_25g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx]), UVM_NONE);
               if(p_sequencer.top_env.kr_cfg_inst.active_25g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_25g[idx])
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
           end
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
             `uvm_info(get_type_name(), $sformatf("Speed 40G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_40g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx]), UVM_NONE);
               if(p_sequencer.top_env.kr_cfg_inst.active_40g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_40g[idx])
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
               if(p_sequencer.top_env.kr_cfg_inst.active_50g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_50g[idx])
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
               if(p_sequencer.top_env.kr_cfg_inst.active_100g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_100g[idx])
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
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
               if(p_sequencer.top_env.kr_cfg_inst.active_200g[idx] && p_sequencer.top_env.kr_cfg_inst.node_sel_200g[idx])
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
           end
         end
       end
       
       begin
         if(p_sequencer.top_env.kr_cfg_inst.is_speed_400g) begin
           node_idx_400g = get_start_node(_400G);
           for(int inst=0;inst<num_inst_400g;inst++) begin
             automatic int idx = node_idx_400g;
             automatic int i = inst;
             `uvm_info(get_type_name(), $sformatf("Speed 400G - Inst: %0d, Node_idx: %0d, active_node: %0b, anlt_node: %0b",i,idx,p_sequencer.top_env.kr_cfg_inst.active_400g[idx],p_sequencer.top_env.kr_cfg_inst.node_sel_400g[idx]), UVM_NONE);
               if(p_sequencer.top_env.kr_cfg_inst.active_400g && p_sequencer.top_env.kr_cfg_inst.node_sel_400g)
                 anlt_reg_config(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.speed,idx,i);
           end
         end
       end
     join
   end
  endtask:pre_start

  task automatic anlt_reg_config(speed_e speed = _25G, int node = 0, int inst = 0);
    
    string task_name = "anlt_reg_config";
    `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, node %0d, inst %0d",task_name,speed,node,inst), UVM_LOW);

    if ($value$plusargs("rf_on=%d",ovrd_rf_on)) begin
      `uvm_info(get_type_name(), $sformatf("Override rf_on to %0d",ovrd_rf_on), UVM_NONE);
      an_adv_rf = ovrd_rf_on;
    end else
      an_adv_rf=$urandom_range(0,1);


    //config VIP DME page
    if(next_page_test == 0) begin
      if(anlt_std == CONSORTIUM)
        anlt_std = CONSORTIUM;
      else
        anlt_std = get_anlt_std(speed,inst);

      if(anlt_std == IEEE) begin
        vip_np_num = 0;
        vip_np_en = 0;
      end
      else if(anlt_std inside {CONSORTIUM,IEEE_CONSORTIUM}) begin
        vip_np_num = 1;
        vip_np_en = 1;
      end
      p_sequencer.top_env.config_vip(speed,inst,vip_np_en,vip_np_num,anlt_std);
    end
    else begin
    `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, node %0d, inst %0d, NP_test %0d",task_name,speed,node,inst,next_page_test), UVM_LOW);
      p_sequencer.top_env.config_vip(speed,inst,vip_np_en,vip_np_num,anlt_std);
    end


    //Revisit: vinoth2x - check LFI timer values
    //if(speed ==_100G)
     lf_timeout_time = p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ltkr*3.27*1000000;
    /*else if(speed inside {_10G,_25G})
     lf_timeout_time = 2000*1000000;*/
     
     an_timeout_time = 2000*1000000;
     one_sec_timeout_time=an_timeout_time;

     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed,.disable_check(1'b1));
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed,.disable_check(1'b1)); // Read twice as avmm need to wait till reconfig reset deasserted.
     if(!read_data[0])
       `uvm_error(get_type_name(), $sformatf("an_enable default value mismatch"));

     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed,.disable_check(1'b1));
     if(!read_data[0])
       `uvm_error(get_type_name(), $sformatf("lt_enable default value mismatch"));

     // Enable/Disable LT
     if ($value$plusargs("lt_on=%d",ovrd_lt_on)) begin
	`uvm_info(get_type_name(), $sformatf("Override lt_on to %0d",ovrd_lt_on), UVM_NONE);
	lt_on = ovrd_lt_on;
     end
     read_data=32'b0;
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed,.disable_check(1'b1));
     read_data[0]=lt_on;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"lt_cfg1"),read_data,speed);
     // AN settings
     if (an_bp_ctrl) begin
	`uvm_info(get_type_name(), $sformatf("User base page override"), UVM_NONE)
	// Randomize values to be overridden
	randomize_bp_fields(speed);
	tnonce = $urandom_range(0,31);
	// Create the base page
	usr_bp = {an_fec,an_tech,tnonce,an_np_ctrl,1'b0,an_adv_rf,an_pause,5'b0,5'b1};
	c4_data = usr_bp[47:16]; // User BP low
	// Override params to correct value
	c3_data = {an_pause,an_fec,an_tech[7:0],usr_bp[15:0]}; // AN override + User bp low
	c5_data = {an_tech[22:8],16'b0}; // AN tech override
	p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg3"),c3_data,speed);
	p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg4"),c4_data,speed);
	p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg5"),c5_data,speed);        
     end
     else if (an_ovrd_param) begin
	`uvm_info(get_type_name(), $sformatf("AN parameters override"), UVM_NONE)
	randomize_bp_fields(speed);
	tnonce = $urandom_range(0,31);
	// Override AN_TECH,AN_PAUSE,AN_FEC
        an_bp_ctrl =1;
	usr_bp = {an_fec,an_tech,tnonce,an_np_ctrl,1'b0,an_adv_rf,an_pause,5'b0,5'b1};
	c3_data = {an_pause,an_fec,an_tech[7:0],usr_bp[15:0]};
	c4_data = usr_bp[47:16]; // User BP low
	c5_data = {an_tech[22:8],16'b0};
	p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg3"),c3_data,speed);
	p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg4"),c4_data,speed);
	p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg5"),c5_data,speed);    
     end
     if ($value$plusargs("an_on=%d",ovrd_an_on)) begin
	`uvm_info(get_type_name(), $sformatf("Override an_on to %0d",ovrd_an_on), UVM_NONE);
	an_on = ovrd_an_on;
     end
     an_c0_reg = {16'h737D,8'b0,ignore_nonce,1'b0,an_ovrd_param,1'b0,an_adv_rf,an_np_ctrl,an_bp_ctrl,an_on};
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),an_c0_reg,speed);
     // Reset SEQ
     read_data=32'b0;
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed,.disable_check(1'b1));
     read_data[0]=1'b1;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);

     fork
	change_vip_tnonce(speed,node,inst);
	wait_lfit_timeout(inst);
	wait_an_timeout(speed,inst);
	wait_one_sec_timer_timeout(inst);
     join_none
    `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, node %0d, inst %0d",task_name,speed,node,inst), UVM_LOW);
  endtask:anlt_reg_config

  virtual task post_start();
    //Revist: vinoth2x - check the drain time
    //if ((get_parent_sequence() == null) && (starting_phase != null)) begin
    //  starting_phase.phase_done.set_drain_time(this, 10us);
    //end
    starting_phase.drop_objection(this, "Ending");
  endtask:post_start
  `endif //  `ifdef UVM_VERSION_1_1

   task automatic reprogram_an_after_reset(speed_e speed = _25G, int node = 0, int inst = 0);
      string task_name = "reprogram_an_after_reset";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, node %0d, inst %0d",task_name,speed,node,inst), UVM_LOW);
      // Reset expected statuses
      an_timeout_status=0;
      lt_timeout_status=0;
      link_up_status=0;
      // make sure ignore_nonce=0 so as to avoid false errors
      an_ovrd_param=0;
      an_np_ctrl=0;
      an_bp_ctrl=0;
      an_c0_reg = {16'h737D,8'b0,ignore_nonce,1'b0,an_ovrd_param,1'b0,an_adv_rf,an_np_ctrl,an_bp_ctrl,an_on};
      p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),an_c0_reg,speed);
     // Reset SEQ
     read_data=32'b0;
     p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed,.disable_check(1'b1));
     read_data[0]=1'b1;
     p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);
     `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, node %0d, inst %0d",task_name,speed,node,inst), UVM_LOW);

   endtask:reprogram_an_after_reset

   task automatic change_vip_tnonce(speed_e speed = _25G, int node = 0, int inst = 0);
      string task_name = "change_vip_tnonce";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, node %0d, inst %0d",task_name,speed,node,inst), UVM_LOW);
      forever begin
	  @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
	  wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_TRANSMIT_DISABLE);
         p_sequencer.top_env.env_ip[inst].ts_tasks_if.do_drv_cfg(`ETH_MODE_AN_TRANSMIT_NONCE_FIELD,$urandom_range(0,31));
	 if (!allow_enable_errors) begin // Only in an_error_sanity_sequence
	    // Program DUT user base page to set new value
	    p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg4"),c4_data,speed,.disable_check(1'b1));
	    tnonce = $urandom_range(0,31);
	    c4_data[4:0]=tnonce;
	    p_sequencer.top_env.reg_write_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg4"),c4_data,speed);
	 end
      end
      `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, node %0d, inst %0d",task_name,speed,node,inst), UVM_LOW);
   endtask:change_vip_tnonce

   //This funciton will give control to access registers from compliance testsuite. Refer cl73_compliance_seq_lib.sv and dut_reg_write/read tasks in nvs_eth_dut_status_check_status_task for usage
   task automatic check_reg_wr_rd(speed_e speed = _25G, int inst = 0);
      string task_name = "check_reg_wr_rd";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, inst %0d",task_name,speed,inst), UVM_LOW);
        if (p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode != OTN && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.mode != FLEXE) begin
         fork
           begin
             while(1)
             begin
               @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_read_req;
               p_sequencer.top_env.reg_read_anlt(p_sequencer.top_env.env_ip[inst].ts_tasks_if.anlt_reg,read_data,speed);
               p_sequencer.top_env.env_ip[inst].ts_tasks_if.read_data = read_data;
               ->p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_read_done;
             end
           end
           begin
             while(1)
             begin
               @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_write_req;
               p_sequencer.top_env.reg_write_anlt(p_sequencer.top_env.env_ip[inst].ts_tasks_if.anlt_reg,p_sequencer.top_env.env_ip[inst].ts_tasks_if.write_data,speed);
               ->p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_write_done;
             end
           end
         join_none
        end
        `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, inst %0d",task_name,speed,inst), UVM_LOW);
   endtask:check_reg_wr_rd

   task automatic wait_for_an_done_and_rfg_vip(speed_e speed = _25G, int inst = 0);
      string task_name = "wait_for_an_done_and_rfg_vip";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, inst %0d",task_name,speed,inst), UVM_LOW);
         fork
           begin
             while(1)
             begin
               @p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_vip_cfg_req;
               p_sequencer.top_env.reconfig_vip_for_datamode(speed,inst);
               `uvm_info(get_type_name(), $sformatf("VIP configured for data mode"), UVM_LOW);
               ->p_sequencer.top_env.env_ip[inst].ts_tasks_if.event_vip_cfg_done;
             end
           end
         join_none
       `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, inst %0d",task_name,speed,inst), UVM_LOW);
   endtask:wait_for_an_done_and_rfg_vip

   task automatic check_reset_values(speed_e speed = _25G, int node = 0, int inst = 0);
      string task_name="check_reset_values";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, node %0d",task_name,speed,node), UVM_LOW);

      if(!recfg_rst)begin
         // Reset the mirror/desired values
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_cfg")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"seq_status")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg2")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg3")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg4")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg5")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg6")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status1")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status2")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status3")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status4")),.field_name(""),.speed(speed));
         // p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status5")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg8")),.field_name(""),.speed(speed));
         p_sequencer.top_env.gdr_ral_reset_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status6")),.field_name(""),.speed(speed));
         //p_sequencer.top_env.gdr_ral_predict_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_status")),.reg_data('h20),.kind(UVM_PREDICT_DIRECT),.speed(speed));
         //p_sequencer.top_env.gdr_ral_predict_anlt(.reg_name($sformatf("port%0d_%0s_csr",node,"an_cfg1")),.field_name("enable_an"),.reg_data(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.synthan),.kind(UVM_PREDICT_DIRECT),.speed(speed));
       end
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_cfg"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"seq_status"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg1"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg2"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg3"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg4"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg5"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg6"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status1"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status2"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status3"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status4"),read_data,speed);
   //   p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status5"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_cfg8"),read_data,speed);
      p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status6"),read_data,speed);
      `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, node %0d",task_name,speed,node), UVM_LOW);
   endtask:check_reset_values
   
   task automatic wait_an_timeout(speed_e speed = _25G, int inst = 0);
      time start_time=0;
      bit  start_timer=0;
      longint timeout_time;
      longint time_diff;
      string task_name = "wait_an_timeout";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s, inst %0d",task_name,speed,inst), UVM_LOW);
      timeout_time = an_timeout_time;
      
      fork
	 forever begin
	    wait_an_ability_detect(inst);
	    fork: start_an_timer
	       begin
	    	  p_sequencer.top_env.nonce_possibility(speed,inst);
	       end
	       begin
	    	  `uvm_info(get_type_name(), $sformatf("Starting AN timer, start_time=%0d",$time), UVM_NONE);
	    	  start_timer = 1;
	    	  start_time = $time;
	    	  AN_timer_done = 0;
		  wait_an_tx_disable(inst,.en_timeout(1'b0));
		  disable start_an_timer;
	       end
	       begin
		   wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode=='h01);
		   wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode!='h01);
		  start_timer = 0;
	    	  `uvm_info(get_type_name(), $sformatf("Exited AN mode. End timer"), UVM_NONE);
		  disable start_an_timer;		  
	       end
	    join
	 end
	 forever begin
	    time_diff = $time-start_time;
	    if ((start_timer == 1) 
		&& (start_time>0) 
		&& (time_diff>(timeout_time-20*1000000)) 
		&& !AN_timer_done
		&& (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode=='h01)
		) begin
	       AN_timer_done = 1'b1;
	       start_timer = 0;
	       `uvm_info(get_type_name(), $sformatf("AN timeout occured"), UVM_NONE);
	    end
	    #500ns;
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s, inst %0d",task_name,speed,inst), UVM_LOW);
   endtask:wait_an_timeout
   
   task automatic wait_lfit_timeout(int inst = 0);
      time start_time=0;
      bit  start_timer;
      longint timeout_time;
      longint time_diff;  
      string task_name = "wait_lfit_timeout";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, inst %0d",task_name,inst), UVM_LOW);
      timeout_time = lf_timeout_time;
                        
      fork
	 forever begin
	    if (an_on) begin
	        @ (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state);
	        wait (p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.vif.debug_bus.debug_bus_an.debug_bus_an73_bfm.arbiter_present_state == svt_ethernet_enum_pkg::AN73_ARBITER_STATE_AN_GOOD_CHECK);
	       start_timer = 1;
	       start_time = $time;
	       LFI_timer_done = 0;
	       `uvm_info(get_type_name(), $sformatf("Starting LFI timer due to AN complete @ %0t",start_time), UVM_NONE);
	    end else
	      #100us;	 
	 end
	 forever begin
	    time_diff = $time-start_time;
	    if ((start_time>0) && (time_diff>(timeout_time-20*1000000)) && !LFI_timer_done) begin
	       LFI_timer_done = 1'b1;
	       `uvm_info(get_type_name(), $sformatf("LFI timeout occured"), UVM_NONE);
	    end
	    #500ns;
	 end
	 forever begin
	     wait (!AN_timer_done);
	     wait (AN_timer_done);
	    LFI_timer_done = 1'b0;
	    start_time=0;
	    `uvm_info(get_type_name(), $sformatf("LFI timer reset because AN timeout occured"), UVM_NONE);	    
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END, inst %0d",task_name,inst), UVM_LOW);
   endtask:wait_lfit_timeout

   task automatic wait_one_sec_timer_timeout(int inst = 0);
      longint timeout_time = one_sec_timeout_time;
      time start_time=0;
      uvm_reg_data_t read_data;
      string task_name = "wait_one_sec_timer_timeout";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, inst %0d",task_name,inst), UVM_LOW);
      fork
	 forever begin
	     wait (!AN_timer_done && !LT_started);
	     wait (AN_timer_done || LT_started);
	     wait (!p_sequencer.top_env.env_ip[inst].spy_if.kr_counter_is_running[0]);
	     wait (p_sequencer.top_env.env_ip[inst].spy_if.kr_counter_is_running[0]);
	    #2us;
	    `ifdef FALCON_MESA
	    uvm_hdl_force("eth_env_top.dut.top.GENKR.alt_ehipc3_fm_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter",one_sec_timeout_time/1000);
	     repeat(5) @(p_sequencer.top_env.env_ip[inst].spy_if.clk);
	    uvm_hdl_release("eth_env_top.dut.top.GENKR.alt_ehipc3_fm_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter");
	    `else
      uvm_hdl_force("eth_env_top.dut.top.GENKR.alt_ehipc3_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter",one_sec_timeout_time/1000);
	     repeat(5) @(p_sequencer.top_env.env_ip[inst].spy_if.clk);
	    uvm_hdl_release("eth_env_top.dut.top.GENKR.alt_ehipc3_kr_inst.TRAINING_CPU.alt_ehipc3_kr_cpu.timer_0.internal_counter");
	    `endif //FALCON_MESA
	    `uvm_info(get_type_name(), $sformatf("%s: Starting 1sec timer",task_name), UVM_NONE);
	    start_time=$time;
	    one_sec_timer_done=0;
	 end // fork begin
	 forever begin
	    if ((start_time>0) && (($time-start_time)>(timeout_time-20*1000000)) && !one_sec_timer_done) begin
	       one_sec_timer_done=1;
	       `uvm_info(get_type_name(), $sformatf("1second timeout occured"), UVM_NONE);
	       start_time=0;
	    end
	    #5us;
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END, inst %0d",task_name,inst), UVM_LOW);
   endtask:wait_one_sec_timer_timeout

   task automatic wait_an_ability_detect(int inst = 0);
      time start_time1=0;
      time start_time2=0;
      string task_name = "wait_an_ability_detect";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, inst %0d",task_name,inst), UVM_LOW);
      // Wait for Sequencer to enter AN mode
       wait (p_sequencer.top_env.env_ip[inst].spy_if.seq_mode=='h01);
      `uvm_info(get_type_name(), $sformatf("In AN mode"), UVM_LOW);
      fork : wait_tx_ability_det
	 begin
	    while (1) begin
               if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 0)
                 @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[0]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 1)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[1]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 2)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[2]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 3)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[3]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 4)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[4]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 5)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[5]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 6)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[6]);
               else if(p_sequencer.top_env.env_ip[inst].spy_if.an_chan == 7)
                  @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial[7]);
	       `uvm_info(get_type_name(), $sformatf("AN TX Ability Detect entered"), UVM_LOW);
	       disable wait_tx_ability_det;
               //Revisit: vinoth2x - timing check condition for GDR
	       /*start_time2 = start_time1;
	       start_time1 = $time;
	       if (start_time2!=0 && ((start_time1-start_time2)<7ns) && ((start_time1-start_time2)>5ns)) begin
		  `uvm_info(get_type_name(), $sformatf("AN TX Ability Detect entered"), UVM_LOW);
		  disable wait_tx_ability_det;
	       end*/
	       #1ns;
	    end
	 end
	 begin
	    // Timeout
	    #5ms;
	    `uvm_error(get_type_name(), $sformatf("Timeout waiting for ability detect"));
	    disable wait_tx_ability_det;
	 end
      join;
      `uvm_info(get_type_name(), $sformatf("%s: END, inst %0d",task_name,inst), UVM_LOW);
   endtask:wait_an_ability_detect
   
   task automatic wait_an_tx_disable(int inst = 0, bit en_timeout=1'b1);
      time start_time;
      string task_name = "wait_an_tx_disable";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, inst %0d",task_name,inst), UVM_LOW);
            
      fork : wait_tx_disable
	 begin
	    while (1) begin
	       start_time = $time;
	       @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial);
	       // Transition seen
	    end
	 end
	 begin
	    while (1) begin
	       if (($time-start_time)>1us) begin
		  `uvm_info(get_type_name(), $sformatf("TX Disable entered"), UVM_LOW);
		  disable wait_tx_disable;
	       end
	       #1ns;
	    end
	 end
	 begin
	    if (en_timeout) begin
	       // Timeout
	       #200us;
	       `uvm_error(get_type_name(), $sformatf("Timeout waiting for TX disable"));	
	       disable wait_tx_disable;
	    end
	 end
      join;
      `uvm_info(get_type_name(), $sformatf("%s: END, inst %0d",task_name,inst), UVM_LOW);
   endtask:wait_an_tx_disable

   task automatic an_status_check_during_tx_disable(speed_e speed = _25G, int node = 0, int inst = 0);
      time   start_time;
      uvm_reg_data_t read_data;
      uvm_reg_data_t exp_read_data;
      string task_name = "an_status_check_during_tx_disable";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, node %0d, inst %0d",task_name,node,inst), UVM_LOW);
      
      exp_read_data = 32'h0;
      exp_read_data = 0 << 1 //an_status[an_page_received]
		      | 0 << 2 //an_status[an_complete]
		      | 1 << 5 //an_status[an_ability]
		      | 0 << 6 //an_status[an_status]
		      | 1 << 7 //an_status[an_lp_ability]
		      | 0 << 9 //an_status[an_failure]
		      | 1 << 11 //an_status[negotiation_failure]
		      | 11'b0 << 12; //an_status[ieee_negotiated_port_type]
      fork
	 begin
	    while (1) begin
	       start_time = $time;
	       @ (p_sequencer.top_env.env_ip[inst].spy_if.tx_serial);
	       // Transition seen
	    end
	 end
	 begin
	    while (1) begin
	       if (($time-start_time)>1us) begin
		  `uvm_info(get_type_name(), $sformatf("TX Disable entered"), UVM_LOW);
		  tx_disable=1;
	       end
	       #1ns;
	    end
	 end
	 begin
	    while (1) begin
	       if (tx_disable==1) begin
		  p_sequencer.top_env.reg_read_anlt($sformatf("port%0d_%0s_csr",node,"an_status"),read_data,speed,.disable_check(1'b1));
		  if (read_data != exp_read_data) begin
		     `uvm_error(get_type_name(), $sformatf("%s: AN TX Disable status incorrect. Exp=%0x, Act=%0x",task_name,exp_read_data,read_data));
		  end
	       end
	       #10us;
	    end
	 end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END, node %0d, inst %0d",task_name,node,inst), UVM_LOW);
   endtask:an_status_check_during_tx_disable
   
   function void randomize_bp_fields(speed_e speed = _25G);
      string func_name = "randomize_bp_fields";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN, speed %0s",func_name,speed), UVM_LOW);
      // Randomize values to be overridden
      if(speed == _10G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
	    if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	  `uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0;
         end
      //FIX ME: When FEC is enable
      else if(speed == _25G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
		 if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	   `uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0;
         end
     else if(speed == _100G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
      if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	`uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0; //Revisit:
      end
      else if(speed == _50G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
      if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	`uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0; //Revisit:
      end
      else if(speed == _200G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
      if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	`uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0; //Revisit:
      end
      else if(speed == _400G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
      if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	`uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0; //Revisit:
      end
      else if(speed == _40G) begin
	    an_tech  =  p_sequencer.top_env.get_tech_ability(speed);
      if (!std::randomize(an_pause) with {an_pause dist {
							 3'b00 := 1,
							 3'b10 := 1,
							 3'b01 := 1,
							 3'b11 := 1
							 };})
	`uvm_error("std::randomize", $sformatf("Randomize an_pause fail"));
	   an_fec   = 4'b0; //Revisit:
      end

      `uvm_info(get_type_name(), $sformatf("%s: Randomized values: ANTECH=%0x, ANPAUSE=%0x, ANFEC=%0x",func_name,an_tech,an_pause,an_fec), UVM_NONE);
      `uvm_info(get_type_name(), $sformatf("%s: END, speed %0s",func_name,speed), UVM_LOW);
   endfunction:randomize_bp_fields

   function anlt_std_e get_anlt_std(speed_e speed = _25G,int inst =0);
     if((speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1) ||
        (speed == _100G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) ||
        (speed == _200G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4))
        get_anlt_std = IEEE_CONSORTIUM;
     else if((speed == _50G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2) ||
             (speed == _400G && p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)) 
             get_anlt_std = CONSORTIUM;
     else
       get_anlt_std = IEEE;
   endfunction:get_anlt_std
   
   function int get_start_node(speed_e speed = _25G); 
      int i; 
      bit[15:0] node = 0;
      case(speed)
         _10G:  node = p_sequencer.top_env.kr_cfg_inst.active_10g;
         _25G:  node = p_sequencer.top_env.kr_cfg_inst.active_25g;
         _40G:  node = p_sequencer.top_env.kr_cfg_inst.active_40g;
         _50G:  node = p_sequencer.top_env.kr_cfg_inst.active_50g;
         _100G: node = p_sequencer.top_env.kr_cfg_inst.active_100g;
         _200G: node = p_sequencer.top_env.kr_cfg_inst.active_200g;
         _400G: node = p_sequencer.top_env.kr_cfg_inst.active_400g;
      endcase
      for(i=0; i<$bits(node); i++) begin
        if(node[i])
          break;
      end
      return i;
   endfunction:get_start_node

   task wait_for_seq_mode (speed_e speed =_25G,int inst =0);
      case(speed)
         _10G:  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[2] ==1);
         _25G:  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[3] ==1);
         _40G:  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[6] ==1);
         _50G:  begin
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[4] ==1); 
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[8] ==1); 
                end
         _100G:  begin
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[7] ==1); 
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 1)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[11] ==1); 
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[5] ==1); 
                end
         _200G:  begin
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 2)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[12] ==1); 
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[9] ==1); 
                end
         _400G:  begin
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 4)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[13] ==1); 
                 if(p_sequencer.top_env.env_ip[inst].dyn_rcfg_obj_inst.ch_num == 8)
                  wait(p_sequencer.top_env.env_ip[inst].spy_if.seq_mode[10] ==1); 
                end
      endcase

   endtask
task pcs_link_up(int inst =0);
     bit dut_pcs_ready;
     bit vip_pcs_ready;

     `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
    //wait(p_sequencer.top_env.env_ip[inst].master_agent.mast_agt_if.rx_pcs_ready==1);
     dut_pcs_ready=0;
     vip_pcs_ready=0;
   `uvm_info("wait_for_lt_complete", $sformatf("Waiting for Rx pcs ready...=%0t", $time), UVM_NONE);
     fork: link_ready
      begin   
       wait(p_sequencer.top_env.env_ip[inst].spy_if.rx_pcs_ready==1);
	  `uvm_info("wait_for_lt_complete", $sformatf("Rx pcs ready asserted...=%0t", $time), UVM_NONE);
	   dut_pcs_ready=1;
      end
      begin
	 `uvm_info("wait_for_lt_complete", $sformatf("Wait VIP to link up...=%0t", $time), UVM_NONE)
    	p_sequencer.top_env.env_ip[inst].m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_LINK_UP.wait_trigger();
	 `uvm_info("wait_for_lt_complete", $sformatf("Done waiting VIP to link up...=%0t", $time), UVM_NONE)
	 vip_pcs_ready=1;
      end
      begin
        wait (vip_pcs_ready && dut_pcs_ready);
        disable link_ready;
      end
      begin
	 #2ms;
	 `uvm_fatal(get_type_name(), $sformatf("Timeout waiting for PCS ready"));
      end
     join 
    
    `uvm_info(get_name(), $sformatf("******* wait_for_rx_pcs_ready end ***************"), UVM_NONE);
  endtask
  
endclass:an_base_sequence

//`include "eth_soft_reset_avmm_access_seq.sv"

`include "an_sanity_sequence.sv"
`include "an_sanity_consortium_sequence.sv"
`include "an_register_access_sequence.sv"
`include "an_cl73_compliance_seq_lib.sv"

//`include "an_sanity_continuous_reg_read_sequence.sv"

//`include "an_sanity_skiplt_sequence.sv"

//`include "an_10_25g_reconfig_sequence.sv"

//`include "an_10_25g_reconfig_skiplt_sequence.sv"

//`include "an_sanity_sequence_fb569509.sv"

`include "an_error_sanity_sequence.sv"

`include "an_override_params_sequence.sv"

`include "an_seq_reset_during_data_sequence.sv"

`include "an_seq_reset_during_lt_sequence.sv"

`include "an_seq_reset_during_an_sequence.sv"

`include "an_basic_next_page_sequence.sv"

`include "an_basic_next_page_from_vip_sequence.sv"

`include "an_user_base_page_sequence.sv"

`include "an_main_reset_during_an_sequence.sv"

//stumulur//Description: AN is restarted after sending pause frames periodically. Expected: Sanity passes after AN-restart
//typedef class pcs_cable_pull_no_data_reset_sequence; 
	
`include "an_csr_reset_during_an_sequence.sv"

`include "an_reconfig_reset_during_an_sequence.sv"

`include "an_reconfig_reset_after_frames_sequence.sv"

`include "an_soft_ip_reset_during_an_sequence.sv"

`include "an_hard_txrx_reset_during_an_sequence.sv"

`include "an_soft_txrx_reset_during_an_sequence.sv"

`include "an_restart_during_lt_sequence.sv"

`include "an_restart_during_data_sequence.sv"

`include "an_csr_reset_after_frames_sequence.sv"

`include "an_timer_cross_base_sequence.sv"

`include "an_a1_l1_p1_timer_cross_sequence_1.sv"

`include "an_a1_l1_p2_timer_cross_sequence_2.sv"

`include "an_a1_l1_p3_timer_cross_sequence_3.sv"

`include "an_a1_l2_lfr0_p1_timer_cross_sequence_4.sv"

`include "an_a1_l2_lfr1_p1_timer_cross_sequence_5.sv"

`include "an_a1_l2_lfr1_p3_timer_cross_sequence_6.sv"

`include "an_a2_skiplt0_l1_p1_timer_cross_sequence_7.sv"

`include "an_a2_skiplt1_l1_p1_timer_cross_sequence_8.sv"

`include "an_a2_skiplt0_l2_p1_timer_cross_sequence_9.sv"

`include "an_a2_skiplt1_l2_p1_timer_cross_sequence_10.sv"

`include "an_a2_skiplt0_l2_p2_timer_cross_sequence_11.sv"

`include "an_a2_skiplt1_l2_p2_timer_cross_sequence_12.sv"

`include "an_a2_skiplt0_l2_lfr1_p23_timer_cross_sequence_13.sv"

`include "an_a2_skiplt1_l2_lfr1_p23_timer_cross_sequence_14.sv"

`include "an_a3_skiplt0_l1_p1_timer_cross_sequence_15.sv"

`include "an_a3_skiplt1_l1_p1_timer_cross_sequence_16.sv"

`include "an_a3_skiplt0_l2_p1_timer_cross_sequence_17.sv"

`include "an_a1_l1_p4_timer_cross_sequence_18.sv"

`include "an_a2_l1_p4_timer_cross_sequence_19.sv"

`include "an_a1_l2_p4_timer_cross_sequence_20.sv"

`include "an_a2_l2_p4_timer_cross_sequence_21.sv"

//`include "eth_soft_reset_during_master_read_register_directed_sequence.sv"

//`include "an_ehip_reg_access_during_kr_sequence.sv"

//`include "an_reset_vip_during_np_sequence.sv"

//`include "anlt_recreate_1408912566.sv"
