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


//==============================================================================
// (C) 2011-2016 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: $
// $Revision: $
// $Date: $
// $Author: $
//==============================================================================

`ifndef __PTP_TX_REF_MODEL_SVH__
`define __PTP_TX_REF_MODEL_SVH__

//------------------------------------------------------------------------------
// Class: ptp_tx_ref_model
//
//------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_avmm_bus_in_ptp)
`altuvm_analysis_imp_array_decl(_from_avmm_p2p_mst)
`altuvm_analysis_imp_array_decl(_from_avmm_asm_mst)

class ptp_tx_ref_model extends uvm_component;

    registers_urm reg_model;
    uvm_reg 	regs;
    uvm_reg_data_t read_data;

   string      m_msg_id = {"PTP_TX", ".RM"};

    typedef virtual eth_fc_interface v_if2;
   v_if2 rx_fc_if;
 typedef virtual eth_sideband_interface vif;
 vif sideband_if; 
 virtual reset_if reset_if;
 virtual spy_interface spy_if;

   bit reset_model_i  ;
	bit bypass_queue = 0;
  bit disable_vl_check=0;

   bit is_ptp_tx_ref_model;
   bit disable_latency_check;
   bit tx_preamble_passthrough;
   semaphore  m_sema;
   //bit [7:0]            i_ptp_tx_fp_q[$];
	//static bit [7:0]            o_ptp_tx_fp_q[$];
   bit [31:0]            i_ptp_tx_fp_q[$]; //set to max
   bit [31:0]            o_ptp_tx_fp_q[$];  //set to max
   bit [9:0] i_ptp_tx_vl_q[$];
   bit [9:0] o_ptp_tx_vl_q[$];
   bit [9:0] i_ptp_rx_vl_q[$];
   bit [9:0] o_ptp_rx_vl_q[$];
   int exp_eth_frm_cnt;
   int i_fp_cnt;
   int i_vl_cnt;
   int o_vl_cnt;
   int i_vl_rx_cnt;
   int o_vl_rx_cnt;
   bit fp_check_en=1; // RS - check with RR
   bit vl_check_en=1; 
   ptp_tx_tran     exp_egr_ts_frame_q[$];
   eth_packet exp_eth_frame_q[$], act_eth_frame_q[$];
   int act_egr_ts_frm_cnt;
   int o_fp_cnt;
   bit [31:0] asym_lat;
   bit [31:0] p2p_lat;
   bit [31:0] global_asm_lat[128];
   bit [31:0] global_p2p_lat[128];
   int act_eth_frm_cnt;

   //tb config class
   //eth_param_tb tb_cfg; 
   // Dynamic Config Obj
  dyn_rcfg dyn_rcfg_obj_inst;
  bit [63:0] tx_total_ptp_packets, tx_total_1_step_packets, tx_total_2_step_packets, tx_total_v2_packets, rxmac_adapt_dropped_cntr;

bit [31:0] shadow_req_tx;
   bit [31:0] 	shadow_req_grant_tx;
   bit 		snap_req_grant_tx;
   bit [31:0] shadow_req_rx;
   bit [31:0] 	shadow_req_grant_rx;
   bit 		snap_req_grant_rx;


   `uvm_analysis_imp_decl(_from_tx_layering_agt)
   `uvm_analysis_imp_decl(_from_ptp_tx_mon)
   `uvm_analysis_imp_decl(_from_ptp_tx_rx_mon)
   `uvm_analysis_imp_decl(_from_ptp_tx_wb_mon)
   `uvm_analysis_imp_decl(_from_ptp_tx_wb_rx_mon)
   `uvm_analysis_imp_decl(_from_rx_avst_eth_ref)
   //`uvm_analysis_imp_decl(_from_avmm_p2p_mst)
   //`uvm_analysis_imp_decl(_from_avmm_asm_mst)

   uvm_tlm_fifo#(altuvm_avalon_mm_req_base) m_tf_avmm_p2p_mst;
   uvm_tlm_fifo#(altuvm_avalon_mm_req_base) m_tf_avmm_asm_mst;

   // Expectation: From streaming tx agent-> tx_layering_agt -> this
   uvm_analysis_imp_from_tx_layering_agt #(eth_packet, ptp_tx_ref_model) a_imp_tx_layering_agt;
   // Expectation, Actual: From ptp_tx_agent -> this
   uvm_analysis_imp_from_ptp_tx_mon #(ptp_tx_tran, ptp_tx_ref_model) a_imp_ptp_tx_mon;
   uvm_analysis_imp_from_ptp_tx_rx_mon #(ptp_tx_tran, ptp_tx_ref_model) a_imp_ptp_tx_rx_mon;
   uvm_analysis_imp_from_ptp_tx_wb_mon #(ptp_tx_tran, ptp_tx_ref_model) a_imp_ptp_tx_wb_mon;
   uvm_analysis_imp_from_ptp_tx_wb_rx_mon #(ptp_tx_tran, ptp_tx_ref_model) a_imp_ptp_tx_wb_rx_mon;
   // Actual
   uvm_analysis_imp_from_rx_avst_eth_ref #(eth_packet, ptp_tx_ref_model) a_imp_rx_avst_mon; //For both macseg and avst

   //P2P
   altuvm_analysis_imp_array_from_avmm_p2p_mst #(altuvm_avalon_mm_req_base, ptp_tx_ref_model) a_imp_avmm_p2p_mst;
   //ASM
   altuvm_analysis_imp_array_from_avmm_asm_mst #(altuvm_avalon_mm_req_base, ptp_tx_ref_model) a_imp_avmm_asm_mst;

   // Analysis ports
   uvm_analysis_port #(eth_packet) a_port; //This is to send expected frame to scoreboard after ptp field modifications 

   //ptp stats
   uvm_analysis_imp_avmm_bus_in_ptp #(altuvm_avalon_mm_req_base, ptp_tx_ref_model) avmm_bus_in_ptp;
   
   //reg_model handle
   //registers_urm reg_model; //FIXME RR: hook this up from eth_env

   altuvm_avalon_mm_req_base    avmm_p2p_mst_pkt;
   altuvm_avalon_mm_req_base    avmm_asm_mst_pkt;
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   //`uvm_object_utils_begin(ptp_tx_ref_model)
   `uvm_component_utils_begin(ptp_tx_ref_model)
     // `uvm_field_int(                expect_response, UVM_ALL_ON | UVM_NOPACK | UVM_NOCOMPARE)
     `uvm_field_int(fp_check_en, UVM_ALL_ON)
     `uvm_field_int(vl_check_en, UVM_ALL_ON)
   //`uvm_object_utils_end
   `uvm_component_utils_end
   
   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new(string name = "ptp_tx_ref_model", uvm_component parent = null);

      super.new(name, parent);

      is_ptp_tx_ref_model = 1;

      // Creating the analysis ports
      a_imp_tx_layering_agt = new("a_imp_tx_layering_agt",this);
      a_imp_ptp_tx_mon = new("a_imp_ptp_tx_mon", this);
      a_imp_ptp_tx_rx_mon = new("a_imp_ptp_tx_rx_mon", this);
      a_imp_ptp_tx_wb_mon = new("a_imp_ptp_tx_wb_mon", this);
      a_imp_ptp_tx_wb_rx_mon = new("a_imp_ptp_tx_wb_rx_mon", this);
      a_port = new("a_port", this);
      a_imp_rx_avst_mon = new("a_imp_rx_avst_mon", this);
      a_imp_avmm_p2p_mst = new("a_imp_avmm_p2p_mst", this, 0);
      a_imp_avmm_asm_mst = new("a_imp_avmm_asm_mst", this, 0);

      avmm_bus_in_ptp = new("avmm_bus_in_ptp", this);

      m_tf_avmm_p2p_mst  = new("m_tf_avmm_p2p_mst", this, 0); 
      m_tf_avmm_asm_mst  = new("m_tf_avmm_asm_mst", this, 0); 
      m_sema = new(1); // init w 1 key

      //uvm_config_db#(eth_param_tb)::get(this, "", "tb_config", tb_cfg);
      //if (tb_cfg == null)  `uvm_fatal("ERROR", "failed to get tb_cfg in ptp_tx_ref_model");

      if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
    if (!uvm_config_db#(vif)::get(this, "", "mst_if", sideband_if)) begin
      `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance")
   end
   
   if(!uvm_config_db#(virtual reset_if)::get(this, "", "slv_if", reset_if)) begin
       `uvm_fatal("ptp_rx_ref_model", "failed to get reset_if intf");
   end  
  
    if(!uvm_config_db#(virtual spy_interface)::get(this,"","spy_interface", spy_if)) begin
       `uvm_fatal("ptp_rx_ref_model", "failed to get spy intf");
   end 


   endfunction : new

   //
   // Function: build_phase
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
   if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in in tx layering mon");
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction : connect_phase

   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   //
   // Notes:
   //
   //--------------------------------------------------------------------------
   task run_phase(uvm_phase phase);

     string mname = this.get_name();

     super.run_phase(phase);

     fork
        finger_print_check();
        if(dyn_rcfg_obj_inst.speed != _10G || dyn_rcfg_obj_inst.speed != _25G) begin
           vl_debug_port_check();
        end
        modify_exp_ptp_fields();
        
        begin
            forever begin
                m_tf_avmm_p2p_mst.get(avmm_p2p_mst_pkt);
                p2p_reg_value_queue(avmm_p2p_mst_pkt);
            end
        end
        begin
            forever begin
                m_tf_avmm_asm_mst.get(avmm_asm_mst_pkt);
                asm_reg_value_queue(avmm_asm_mst_pkt);
            end
        end
        begin
            reset_ptp_tx_ref_model();        
        end
     join_none

   endtask : run_phase

   //--------------------------------------------------------------------------
   // Description:
   //
   //
   // Notes:
   //
   //--------------------------------------------------------------------------
   function void check_phase (uvm_phase phase);

      super.check_phase(phase);

      if (i_ptp_tx_fp_q.size != o_ptp_tx_fp_q.size && fp_check_en) begin

         `uvm_error(get_type_name(),$sformatf("fp queues are not equal. i_fp_q=%0d, o_fp_q=%0d",
            i_ptp_tx_fp_q.size(), o_ptp_tx_fp_q.size()))

         if (i_ptp_tx_fp_q.size) begin
            foreach(i_ptp_tx_fp_q[i]) `uvm_info (get_type_name(), $sformatf("i_ptp_tx_fp_q::i=0x%0h", i_ptp_tx_fp_q[i]), UVM_FULL)
         end
         if (o_ptp_tx_fp_q.size) begin
            foreach(o_ptp_tx_fp_q[i]) `uvm_info (get_type_name(), $sformatf("o_ptp_tx_fp_q::i=0x%0h", o_ptp_tx_fp_q[i]), UVM_FULL)
         end
      end
      else `uvm_info (get_type_name(), $sformatf("finger prints are empty, as expected"), UVM_MEDIUM)

   endfunction : check_phase

   //--------------------------------------------------------------------------
   // Description:
   //
   //
   // Notes:
   //
   //--------------------------------------------------------------------------
   function void report_phase(uvm_phase phase);

      super.report_phase(phase);

      `uvm_info (get_type_name(), $sformatf("finger print count, i_fp=%0d, o_fp=%0d", i_fp_cnt, o_fp_cnt), UVM_MEDIUM)

      `uvm_info (get_type_name(), $sformatf("exp_eth_frame_q=%0d, exp_egr_ts_frame_q=%0d, act_eth_frame_q=%0d",
         exp_eth_frame_q.size(), exp_egr_ts_frame_q.size(), act_eth_frame_q.size()), UVM_MEDIUM)


   endfunction : report_phase

   //--------------------------------------------------------------------------
   // Description: Task to reset and flush queues. Also to control the ptp
   //              ref model queueto accept or reject incoming packets.
   //
   // Notes:
   //
   //--------------------------------------------------------------------------   
   task reset_ptp_tx_ref_model();
      fork
      begin
         //to reset
         forever
         begin
         
            @(negedge reset_if.csr_rst_n , negedge reset_if.tx_rst_n , negedge reset_if.rx_rst_n , posedge spy_if.soft_tx_rst , posedge spy_if.soft_rx_rst );
            `uvm_info (get_type_name(), $sformatf("Setting bypass_queue = 1"), UVM_MEDIUM)
            bypass_queue = 1;
            reset_model();
            flush_frames();            
         
         end
      end
      begin
         //to deassert bypass queue
         forever
         begin
            @(posedge reset_if.csr_rst_n , posedge reset_if.tx_rst_n , posedge reset_if.rx_rst_n , negedge spy_if.soft_tx_rst , negedge spy_if.soft_rx_rst );
            
            wait(spy_if.o_tx_ptp_ready & spy_if.o_rx_ptp_ready);
            
            //Workaround for PTP midsim traffic issue to turn on scoreboard after 1us due to corrupted FEFE packet prior to previous reset
            if(spy_if.delayed_scb_en == 1)begin
               #10us;
            end            
            
            `uvm_info (get_type_name(), $sformatf("Setting bypass_queue = 0"), UVM_MEDIUM)
            bypass_queue = 0;         
         end      
      end
      join
   endtask: reset_ptp_tx_ref_model

   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   // Notes: 
   // -This function collects and stores the expected packets (from the
   // eth_tx_layering_agt
   // - Also collects and stores expected fingerprints for comparison
   //
   //--------------------------------------------------------------------------
   function process_packet_from_tx_layering_agt(eth_packet t);

      eth_packet exp_trans;
      string s = "process_packet_from_tx_layering_agt";

      //If bypass_queue == 1 it will just skip
      if(bypass_queue == 0)begin

         exp_eth_frm_cnt++;
         
         //Collect expected fp if ptp frame
         if((t.is_ptp_seq == 1) && (t.m_ptp_kind !== PTP_ERR)) begin : IS_PTP_SEQ
   
            `uvm_info({get_type_name(),s}, $sformatf("packet=%0d is PTP kind, \n %s", 
               exp_eth_frm_cnt, t.sprint()), UVM_FULL)
   
            // Note: FP-out is asserted for Valid Op/sub-ops only, even if the FF is invalid.
            if (fp_check_en) begin
               i_ptp_tx_fp_q.push_back(t.i_ptp_tx_fp);
               i_fp_cnt++;
               `uvm_info(get_type_name(), $sformatf("i_fp=0x%0h, i_fp_q.size=%0d, i_fp_cnt=%0d",
                  t.i_ptp_tx_fp, i_ptp_tx_fp_q.size(), i_fp_cnt), UVM_LOW)
            end
         end : IS_PTP_SEQ
   
         // Compare for functional mode tests, in Full Duplex mode.
         exp_trans = eth_packet::type_id::create("exp_trans");
         exp_trans.copy(t);
         // Push all expected ethernet frames.
         exp_eth_frame_q.push_back(exp_trans);
         `uvm_info(get_type_name(), $sformatf("packet%0d, is_ptp=%b, op=%s, kind=%s",
            exp_eth_frm_cnt, exp_trans.is_ptp_seq, exp_trans.m_ptp_op, 
            exp_trans.m_ptp_kind), UVM_HIGH)
         `uvm_info(get_type_name(), $sformatf("packet:%0d, from_tx_layering_agt \n %s",
            exp_eth_frm_cnt, exp_trans.sprint()), UVM_MEDIUM)
   
   
         `uvm_info(get_type_name(),
            $sformatf("process_packet_from_tx_layering_agt::is_ptp_seq=%0b, processed expected packet: \n %s",
            t.is_ptp_seq, t.sprint()), UVM_MEDIUM)
      end

   endfunction : process_packet_from_tx_layering_agt

   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   // Notes:
   // This function collects ptp tx o/p (timestamp, fingerprints) for
   // comparison
   //
   //--------------------------------------------------------------------------
   function process_packet_from_ptp_tx_mon(ref ptp_tx_tran t);

      ptp_tx_tran egr_trans;

      //If bypass_queue == 1 it will just skip
      if(bypass_queue == 0)begin

         egr_trans = ptp_tx_tran::type_id::create("egr_trans");
         egr_trans.copy(t); 
         //
         // Push the contents into queues for later comparison
         //
         if (egr_trans.o_ptp_ets_valid) begin
            exp_egr_ts_frame_q.push_back(egr_trans);
            act_egr_ts_frm_cnt++;
            `uvm_info(get_type_name(), $sformatf("Received Egress TS::%0d\n",
               act_egr_ts_frm_cnt), UVM_DEBUG)
         end
   
         `uvm_info(get_type_name(),
                  $sformatf("fields_check_en::processed packet from_ptp_tx_mon:: \n %s",
                  egr_trans.sprint()), UVM_DEBUG)
   
         //
         // Push the contents into queues for later comparison
         //
         if (t.o_ptp_ets_valid) begin
         o_ptp_tx_fp_q.push_back(t.o_ptp_ets_fp);
         o_fp_cnt++;
         `uvm_info (get_type_name(), $sformatf("o_ptp_tx_fp=0x%0h, o_fp_cnt=%0d",
                     t.o_ptp_ets_fp, o_fp_cnt), UVM_LOW)
         `uvm_info (get_type_name(), 
                  $sformatf({"C3DV_PTP_INFO:lane_en_num=0_0, egr_ptp_tx_ts=0x%x, egr_ts_cnt=%0d"},
                  t.o_ptp_ets, o_fp_cnt), UVM_NONE)
         end
         if (t.o_ptp_ets_valid) begin
          if(disable_vl_check ==0) begin
         o_ptp_tx_vl_q.push_back(t.o_ptp_ets_vl);
         o_vl_cnt++;
         `uvm_info(get_type_name(), $sformatf("o_ptp_tx_vl=%0d, o_ptp_tx_vl_q.size=%0d, o_tx_vl_cnt=%0d",
               t.o_ptp_ets_vl, o_ptp_tx_vl_q.size(), o_vl_cnt), UVM_LOW)
         end
       end
      end
      
   endfunction : process_packet_from_ptp_tx_mon

   function process_packet_from_ptp_tx_rx_mon(ref ptp_tx_tran t);
	
      //If bypass_queue == 1 it will just skip
      if(bypass_queue == 0 )begin
       if(disable_vl_check ==0) begin	
         if (t.o_ptp_its_vl_valid) begin
            o_ptp_rx_vl_q.push_back(t.o_ptp_its_vl);
            o_vl_rx_cnt++;
            `uvm_info(get_type_name(), $sformatf("o_ptp_rx_vl=%0d, o_ptp_rx_vl_q.size=%0d, o_rx_vl_cnt=%0d",
               t.o_ptp_its_vl, o_ptp_rx_vl_q.size(), o_vl_rx_cnt), UVM_LOW)
         end
       end 
      end
   endfunction : process_packet_from_ptp_tx_rx_mon

   function process_packet_from_ptp_tx_wb_mon(ref ptp_tx_tran t);

      //If bypass_queue == 1 it will just skip
      if(bypass_queue == 0)begin	
	      if(disable_vl_check ==0) begin	
         if (t.i_ptp_ets_vl_valid) begin
            i_ptp_tx_vl_q.push_back(t.i_ptp_ets_vl);
            i_vl_cnt++;
            `uvm_info(get_type_name(), $sformatf("i_ptp_tx_vl=%0d, i_ptp_tx_vl_q.size=%0d, i_tx_vl_cnt=%0d",
               t.i_ptp_ets_vl, i_ptp_tx_vl_q.size(), i_vl_cnt), UVM_LOW)
         end
       end
      end
   endfunction : process_packet_from_ptp_tx_wb_mon

   function process_packet_from_ptp_tx_wb_rx_mon(ref ptp_tx_tran t);
	
      //If bypass_queue == 1 it will just skip
      if(bypass_queue == 0)begin
		if (disable_vl_check == 0) begin
         if (t.i_ptp_its_vl_valid) begin
            i_ptp_rx_vl_q.push_back(t.i_ptp_its_vl);
            i_vl_rx_cnt++;
            `uvm_info(get_type_name(), $sformatf("i_ptp_rx_vl=%0d, i_ptp_rx_vl_q.size=%0d, i_rx_vl_cnt=%0d",
               t.i_ptp_its_vl, i_ptp_rx_vl_q.size(), i_vl_rx_cnt), UVM_LOW)
               $display("i_vl_rx_cnt=%0d", i_vl_rx_cnt);
               gdr_ral_predict(.regname("mac_stats_cntr_rx_total_ptp_ts"),.value(i_vl_rx_cnt),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));     
   
         end
         end
      end
   endfunction : process_packet_from_ptp_tx_wb_rx_mon


   function void overflow_under_flow_check(bit pos_neg, ref bit[63:0] get_exp_cf_bytes, ref bit[63:0] orignal_cf);  //pos_neg = 1 // sign is positive or overflow
     if((pos_neg == 1)) //--
     begin
        `uvm_info(get_type_name(),$sformatf("new_cf=x%0x , orignal_cf=x%0x", get_exp_cf_bytes, orignal_cf), UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("orignal_cf=x%0x", orignal_cf), UVM_LOW)
       if((get_exp_cf_bytes > 'h7fffffffffffffff) && (orignal_cf <= 'h7fffffffffffffff)) 
       begin
        get_exp_cf_bytes = 'h7fffffffffffffff;
        `uvm_info(get_type_name(),  $sformatf("As exp_cf exceeded the boundary of max limit modified value is max value of cf, new_cf=x%0x", get_exp_cf_bytes), UVM_LOW)
       end
     end
     else 
     begin
      `uvm_info(get_type_name(),  $sformatf("value of cf, expected cf=x%0x", get_exp_cf_bytes), UVM_LOW) 
      if((get_exp_cf_bytes < 'h8000000000000000)&& (orignal_cf >= 'h8000000000000000))
      begin 
      get_exp_cf_bytes = 'h7fffffffffffffff;
      `uvm_info(get_type_name(),  $sformatf("As exp_cf exceeded the boundary of max limit modified value is max value of cf, new_cf=x%0x", get_exp_cf_bytes), UVM_LOW) 
      end
     end  //--
   endfunction
   
   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   // Notes: 
   // -This function collects and stores the actual packets (from the rx_avst_mon
   // for loopback mode and eth_ref_model_inst for VIP mode
   // - It is used to collect the actual CF value
   //
   //--------------------------------------------------------------------------
   function process_packet_from_rx_avst_eth_ref (eth_packet t);

      eth_packet act_trans;
      string s = "process_packet_from_rx_avst_eth_ref";
      
      //If bypass_queue == 1 it will just skip
      if(bypass_queue == 0)begin      
      
         act_eth_frm_cnt++;
         
         // Compare for functional mode tests, in Full Duplex mode.
         act_trans = eth_packet::type_id::create("act_trans");
         act_trans.copy(t);
         // Push all expected ethernet frames.
         act_eth_frame_q.push_back(act_trans);
   
         `uvm_info(get_type_name(), $sformatf("packet:%0d, from_rx_avst_eth_ref \n %s",
            act_eth_frm_cnt, act_trans.sprint()), UVM_MEDIUM)
         
      end
      
   endfunction : process_packet_from_rx_avst_eth_ref   

   function int gdr_ral_get(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    case (dyn_rcfg_obj_inst.speed)
    _10G : regname = {"e25_",regname};
    _25G : regname = {"e25_",regname};
    _50G : regname = {"e50_",regname};
    _100G : regname = {"e100_",regname};
    _200G : regname = {"e200_",regname};
    _400G : regname = {"e400_",regname};
    endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
	    $display("gdr_ral_get :%0s value %0h",regs[i].get_name(),reg_l.get());
        if(fldname == "") return reg_l.get();
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
	      $display(" Field %0s get is %0h",fldname, fld_l.get());
          return fld_l.get();
        end
      end
    end
    `uvm_fatal("eth_ref_model", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

function void gdr_ral_predict(string regname, string fldname="",uvm_reg_data_t value, uvm_predict_e kind, uvm_reg_map map);
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    case (dyn_rcfg_obj_inst.speed)
    _10G : regname = {"e25_",regname};
    _25G : regname = {"e25_",regname};
    _50G : regname = {"e50_",regname};
    _100G : regname = {"e100_",regname};
    _200G : regname = {"e200_",regname};
    _400G : regname = {"e400_",regname};
    endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        if(fldname == "") begin 
          reg_l.predict(.value(value), .kind(kind), .map(map));
          return;
        end
        //else begin
        //  fld_l  = reg_l.get_field_by_name(fldname);
        //  return fld_l.get();
        //end
      end
    end
    `uvm_fatal("eth_ref_model", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction


   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   // Notes:
   //write function for packet from tx layering agt/fc agt
   //
   //--------------------------------------------------------------------------
   virtual function void write_from_tx_layering_agt(eth_packet t);
     
    string func_name = "write_from_tx_layering_agt";

     eth_packet trans;
     bit [31:0] txmac_ctrl;
     int length_error_tx;
     int illegal_length_type_field_tx;
     eth_packet trans_stat_tx;
     uvm_reg 	regs_tx;


     trans = eth_packet::type_id::create("trans");
     trans.copy(t);
     this.process_packet_from_tx_layering_agt(trans);

     //ral  
        
   txmac_ctrl = gdr_ral_get("mac_cfg_txmac_control");
   $cast(trans_stat_tx,t.clone());
   //trans_stat_tx.unpack_bytes(tb_cfg.crc_pass,tb_cfg.preamble_passthrough,"vip_rx_mac_tx");
   if (trans_stat_tx ==null) begin     
      `uvm_error("ETH REF MODE", $sformatf("%s: Empty frame received from TX monitor",func_name));
      return;
   end    
   `uvm_info("ETH REF MODEL", $sformatf("%s: Packet received at stat tx...",func_name),UVM_MEDIUM)

   if(trans_stat_tx.is_ptp_seq == 1)
       begin
         tx_total_ptp_packets += 1;
       end

       if(trans_stat_tx.m_ptp_op inside {INS_V2,INS_V2_W_ASYM_LAT,INS_V2_W_UDP_CS_0,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT_EB} )
       begin
        tx_total_v2_packets +=1; 
        tx_total_1_step_packets +=1;
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_1step_ptp_pkts"),.value(tx_total_1_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_v2_ptp_pkts"),.value(tx_total_v2_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end

       if(trans_stat_tx.m_ptp_op inside{INS_CF,INS_CF_W_ASYM_LAT,INS_CF_W_UDP_CS_0,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT_EB,INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB})
       begin
         tx_total_1_step_packets +=1;
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_1step_ptp_pkts"),.value(tx_total_1_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end

       if(t.m_ptp_op == INS_2STEP)
       begin
         tx_total_2_step_packets +=1;
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_2step_ptp_pkts"),.value(tx_total_2_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));

       end

         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_ptp_pkts"),.value(tx_total_ptp_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
 

  
   endfunction : write_from_tx_layering_agt

   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   // Notes:
   // write function for ptp_tx op transaction from ptp_tx_agt
   //
   //--------------------------------------------------------------------------
   virtual function void write_from_ptp_tx_mon(ptp_tx_tran t);

      ptp_tx_tran in_trans;

      in_trans = ptp_tx_tran::type_id::create("in_trans");
      in_trans.copy(t); 
      `uvm_info(get_type_name(), $sformatf("Received from ptp_tx_mon: \n %s",in_trans.sprint()), UVM_DEBUG)
      this.process_packet_from_ptp_tx_mon(in_trans);
      `uvm_info(get_type_name(), $sformatf("processed transaction, wrote to AP "), UVM_FULL)

   endfunction : write_from_ptp_tx_mon

   virtual function void write_from_ptp_tx_rx_mon(ptp_tx_tran t);

      ptp_tx_tran in_trans;

      in_trans = ptp_tx_tran::type_id::create("in_trans");
      in_trans.copy(t);
      `uvm_info(get_type_name(), $sformatf("Received from ptp_tx_mon: \n %s",in_trans.sprint()), UVM_DEBUG)
      this.process_packet_from_ptp_tx_rx_mon(in_trans);
      `uvm_info(get_type_name(), $sformatf("processed transaction, wrote to AP "), UVM_FULL)

   endfunction : write_from_ptp_tx_rx_mon

   virtual function void write_from_ptp_tx_wb_mon(ptp_tx_tran t);

      ptp_tx_tran in_trans;

      in_trans = ptp_tx_tran::type_id::create("in_trans");
      in_trans.copy(t);
      `uvm_info(get_type_name(), $sformatf("Received from ptp_tx_mon: \n %s",in_trans.sprint()), UVM_DEBUG)
      this.process_packet_from_ptp_tx_wb_mon(in_trans);
      `uvm_info(get_type_name(), $sformatf("processed transaction, wrote to AP "), UVM_FULL)

   endfunction : write_from_ptp_tx_wb_mon

   virtual function void write_from_ptp_tx_wb_rx_mon(ptp_tx_tran t);

      ptp_tx_tran in_trans;

      in_trans = ptp_tx_tran::type_id::create("in_trans");
      in_trans.copy(t);
      `uvm_info(get_type_name(), $sformatf("Received from ptp_tx_mon: \n %s",in_trans.sprint()), UVM_DEBUG)
      this.process_packet_from_ptp_tx_wb_rx_mon(in_trans);
      `uvm_info(get_type_name(), $sformatf("processed transaction, wrote to AP "), UVM_FULL)

   endfunction : write_from_ptp_tx_wb_rx_mon

   
   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   // Notes:
   // write function for avst_rx_mon or refmodel
   //
   //--------------------------------------------------------------------------
   virtual function void write_from_rx_avst_eth_ref(eth_packet t);

     eth_packet act_trans;

     act_trans = eth_packet::type_id::create("act_trans");
     act_trans.copy(t);
     this.process_packet_from_rx_avst_eth_ref(act_trans);

   endfunction : write_from_rx_avst_eth_ref   
   
   function void write_axp_from_avmm_p2p_mst(int unsigned idx, altuvm_avalon_mm_req_base t);
      `uvm_info(get_type_name(),$sformatf("Got AVMM P2P master transaction:\n%s", t.convert2string()),UVM_MEDIUM)
      void'(m_tf_avmm_p2p_mst.try_put(t));
   endfunction : write_axp_from_avmm_p2p_mst

   function void write_axp_from_avmm_asm_mst(int unsigned idx, altuvm_avalon_mm_req_base t);
      `uvm_info(get_type_name(),$sformatf("Got AVMM ASM master transaction:\n%s", t.convert2string()),UVM_MEDIUM)
      void'(m_tf_avmm_asm_mst.try_put(t));
   endfunction : write_axp_from_avmm_asm_mst

    function void check_to_clr_stat_cntr();
    string func_name = "check_to_clr_stat_cntr";
    bit [31:0] phy_config;
    shadow_req_rx = gdr_ral_get("mac_cfg_cntr_rx_config");//reg_model.RX_CNTR_CONFIG.get();
    shadow_req_tx = gdr_ral_get("mac_cfg_cntr_tx_config");//reg_model.TX_CNTR_CONFIG.get();
    //Have to use get_mirrored_value to get predited value for CNTR_STATUS register as it is RO register
//GDR-FIXME-REG-MISSING    shadow_req_grant_rx = reg_model.RX_CNTR_STATUS.get_mirrored_value();
//GDR-FIXME-REG-MISSING    shadow_req_grant_tx = reg_model.TX_CNTR_STATUS.get_mirrored_value();

    if(shadow_req_rx[2]==1 && shadow_req_grant_rx[1]==1)
      snap_req_grant_rx = 1;
    else if (shadow_req_rx[2]==0 && shadow_req_grant_rx[1]==0)
      snap_req_grant_rx = 0;
    if(shadow_req_tx[2]==1 && shadow_req_grant_tx[1]==1)
      snap_req_grant_tx = 1;
    else if (shadow_req_tx[2]==0 && shadow_req_grant_tx[1]==0)
      snap_req_grant_tx = 0;

    `uvm_info("PTP REF MODEL", $sformatf("%s: RX_CNTR_CONFIG='h%0h, TX_CNTR_CONFIG='h%0h, RX_CNTR_STATUS='h%0h, TX_CNTR_STATUS='h%0h",func_name,shadow_req_rx, shadow_req_tx,shadow_req_grant_rx,shadow_req_grant_tx),UVM_MEDIUM)
    `uvm_info("PTP REF MODEL", $sformatf("%s: snap_req_grant_rx='h%0h, snap_req_grant_tx='h%0h, sideband_if.snapshot_en='h%0h, shadow_req_rx[0]='h%0h",func_name,snap_req_grant_rx, snap_req_grant_tx,sideband_if.snapshot_en,shadow_req_rx[0]),UVM_MEDIUM)

    if(shadow_req_tx[0]==1 || (snap_req_grant_tx == 0 && sideband_if.snapshot_en == 0))  begin//Need to predict while clearing registers and de-asserting shadow request 
      if(shadow_req_tx[0] == 1) begin//Need to reset counters for clear stat regs 
        
        tx_total_ptp_packets=0;
        tx_total_1_step_packets=0;
        tx_total_2_step_packets=0;
        tx_total_v2_packets=0;

              end

  if(!((shadow_req_tx[0] == 1) && (snap_req_grant_tx == 1 || sideband_if.snapshot_en == 1))) begin//Don't want to predict when clear request comes but shadow request is ON
       gdr_ral_predict(.regname("mac_stats_cntr_tx_total_ptp_pkts"),.value(tx_total_ptp_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_total_1step_ptp_pkts"),.value(tx_total_1_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_total_2step_ptp_pkts"),.value(tx_total_2_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_total_v2_ptp_pkts"),.value(tx_total_v2_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
      end
    end
          endfunction:check_to_clr_stat_cntr

  function clr_adapt_stat_cntr();
    string func_name = "clr_adapt_stat_cntr";
//GDR-FIXME-REG-MISSING    adapt_cntr = reg_model.rxmac_adapt_dropped_clear.get();
      rxmac_adapt_dropped_cntr=0;
    //if(sideband_if.snapshot_en == 0) begin // FIXME Can't use register of shadow request fb:596887
    //  reg_model.rxmac_adapt_dropped_31_0.predict(.value(rxmac_adapt_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
    //  reg_model.rxmac_adapt_dropped_63_32.predict(.value(rxmac_adapt_dropped_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
    //  end
  endfunction:clr_adapt_stat_cntr


   function void write_avmm_bus_in_ptp(altuvm_avalon_mm_req_base tr);
 uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
     if ((tr.address) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;
       //Have to predit CNTR_STATUS register as it is RO and RAL mirrored value don't get updated because set_auto_predict is 0.
//GDR-FIXME-REG-MISSING       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
//GDR-FIXME-REG-MISSING      begin
//GDR-FIXME-REG-MISSING         if(select_reg.get_address() == `REGISTERS_RX_CNTR_STATUS_OFFSET_REG || select_reg.get_address() == `REGISTERS_TX_CNTR_STATUS_OFFSET_REG) begin
//GDR-FIXME-REG-MISSING          select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//GDR-FIXME-REG-MISSING        end
//GDR-FIXME-REG-MISSING        else if(select_reg.get_address() == `REGISTERS_anlt_seq_cfg_OFFSET_REG || select_reg.get_address() == `REGISTERS_an_cfg2_OFFSET_REG || select_reg.get_address() == `REGISTERS_lt_cfg2_OFFSET_REG) begin
//GDR-FIXME-REG-MISSING          select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_READ), .map(reg_model.default_map));
//GDR-FIXME-REG-MISSING        end
//GDR-FIXME-REG-MISSING      end
      //predict stat counter based on shadow/clear request
      //TODO: Temporary remove to save simulation time
      //if(select_reg.get_address() == `GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,dyn_rcfg_obj_inst.speed) || select_reg.get_address() == `GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,dyn_rcfg_obj_inst.speed) /*|| select_reg.get_address() == `REGISTERS_RX_CNTR_STATUS_OFFSET_REG || select_reg.get_address() == `REGISTERS_TX_CNTR_STATUS_OFFSET_REG*/) begin
      //  check_to_clr_stat_cntr();
      //end
       // predict stat counter base on register
       //DM_TODO: remove if(select_reg.get_address() == `ETH_F_ALL_rxmac_adapt_dropped_control_OFFSET_REG) begin
       //DM_TODO: remove   clr_adapt_stat_cntr();
       //DM_TODO: remove end  
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
           //if((tr.address>>2) == `GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,dyn_rcfg_obj_inst.speed) || (tr.address>>2) == `GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,dyn_rcfg_obj_inst.speed) )
           //  select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]} & 'hFFFFFFFC),.kind(UVM_PREDICT_WRITE), .map(reg_model.default_map));
           //else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(reg_model.default_map));

         //EHIP Shabbir: in EHIP, eio_sys_rst will reset the CSRs. FB 517791
//GDR-FIXME-REG-MISSING         if((tr.address>>2) == `REGISTERS_PHY_CONFIG_OFFSET_REG && (tr.data_bytes[0][0] == 1)) begin
//GDR-FIXME-REG-MISSING           reset_ral_and_stats_counters();
//GDR-FIXME-REG-MISSING           //PHY_CONFIG register doesn't get reset with eio_sys_rst so needs to preserve its value
//GDR-FIXME-REG-MISSING           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(reg_model.default_map));
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("No Register found with address :%0h",(tr.address)));
   end
endfunction // write_avmm_bus_in

/*function void write_stat_checker_tx(eth_packet t);
   string func_name = "write_stat_checker_tx";
   bit [31:0] txmac_ctrl;
   int length_error_tx;
   int illegal_length_type_field_tx;
   eth_packet trans_stat_tx;
   uvm_reg 	regs_tx;
   
   txmac_ctrl = gdr_ral_get("mac_cfg_txmac_control");
   $cast(trans_stat_tx,t.clone());
   //trans_stat_tx.unpack_bytes(tb_cfg.crc_pass,tb_cfg.preamble_passthrough,"vip_rx_mac_tx");
   if (trans_stat_tx ==null) begin     
      `uvm_error("ETH REF MODE", $sformatf("%s: Empty frame received from TX monitor",func_name));
      return;
   end    
   `uvm_info("ETH REF MODEL", $sformatf("%s: Packet received at stat tx...",func_name),UVM_MEDIUM)

  if(trans_stat_tx.is_ptp_seq == 1)
       begin
         tx_total_ptp_packets += 1;
       end

       if(trans_stat_tx.m_ptp_op inside {INS_V2,INS_V2_W_ASYM_LAT,INS_V2_W_UDP_CS_0,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT_EB} )
       begin
        tx_total_v2_packets +=1; 
        tx_total_1_step_packets +=1;
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_1step_ptp_pkts"),.value(tx_total_1_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_v2_ptp_pkts"),.value(tx_total_v2_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end

       if(trans_stat_tx.m_ptp_op inside{INS_CF,INS_CF_W_ASYM_LAT,INS_CF_W_UDP_CS_0,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT_EB,INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB})
       begin
         tx_total_1_step_packets +=1;
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_1step_ptp_pkts"),.value(tx_total_1_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end

       if(t.m_ptp_op == INS_2STEP)
       begin
         tx_total_2_step_packets +=1;
         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_2step_ptp_pkts"),.value(tx_total_2_step_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));

       end

         gdr_ral_predict(.regname("mac_stats_cntr_tx_total_ptp_pkts"),.value(tx_total_ptp_packets),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
 

 endfunction */
   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   //
   // Notes:
   //
   // Assumption: Finger print is emitted for every input packet(Pause is an exception).
   //--------------------------------------------------------------------------
   task finger_print_check();

      //bit [7:0] i_fp, o_fp;
      bit [31:0] i_fp, o_fp; //set to max
      int i=0; 

      forever begin

         `uvm_info(get_type_name(),$sformatf("Waiting for finger print comparison"), UVM_FULL)

         // Based on the packet size, either the input FP appears first, or the ouput FP appears
         // first.  Note that both are captured at SOP!
         //  However, for most packets(Pause is an exception), it is expected
         // that the in-order comparison is sufficient.
         wait((i_ptp_tx_fp_q.size() > 0+i) && (o_ptp_tx_fp_q.size() > 0+i));

         // Note: Pause frames have special consideration. Revisit.
         i_fp = i_ptp_tx_fp_q[i];
         o_fp = o_ptp_tx_fp_q[i];
         i++;
         if (o_fp === i_fp) begin

            `uvm_info(get_type_name(),$sformatf("FP matches. i_fp=0x%0h, i_fp_q=0x%0h, o_fp_q=%0d",
               i_fp, i_ptp_tx_fp_q.size(), o_ptp_tx_fp_q.size()), UVM_FULL)

         end
         else `uvm_error(get_type_name(),$sformatf("FP doesn't match! i_fp=0x%0h, o_fp=0x%0h, i_fp_q=%0d, o_fp_q=%0d",
            i_fp, o_fp, i_ptp_tx_fp_q.size(), o_ptp_tx_fp_q.size()))

         `uvm_info(get_type_name(),$sformatf("finger print comparison. Done."), UVM_FULL)

      end

   endtask : finger_print_check

   //--------------------------------------------------------------------------
   // Input: 
   // Output:
   // Description:
   // Check the white box signal at HIP if match the SIP signal
   //
   // Notes:
   // PTP debug output pin
   // Present PTP debug information. One of the information that required for multilane MAC debug is VL number that SOP has landed for both TX and RX. 
   //--------------------------------------------------------------------------

   task vl_debug_port_check();

      bit [7:0] i_tx_vl, o_tx_vl;
      bit [7:0] i_rx_vl, o_rx_vl;
      fork
      begin
         forever begin
 
            `uvm_info(get_type_name(),$sformatf("Waiting for tx virtual lane debug port comparison"), UVM_FULL)

            wait((i_ptp_tx_vl_q.size() > 0) && (o_ptp_tx_vl_q.size() > 0));
            i_tx_vl = i_ptp_tx_vl_q.pop_front();
            o_tx_vl = o_ptp_tx_vl_q.pop_front();

            if (o_tx_vl === i_tx_vl) begin
  
               `uvm_info(get_type_name(),$sformatf("Tx VL debug port matches. i_tx_vl=%0d, i_tx_vl_q=%0d, o_tx_vl_q=%0d",
                  i_tx_vl, i_ptp_tx_vl_q.size(), o_ptp_tx_vl_q.size()), UVM_LOW)

            end
            else 
               `uvm_error(get_type_name(),$sformatf("Tx VL debug port doesn't match! i_tx_vl=%0d, o_tx_vl=%0d, i_tx_vl_q=%0d, o_tx_vl_q=%0d",
                  i_tx_vl, o_tx_vl, i_ptp_tx_vl_q.size(), o_ptp_tx_vl_q.size()))

            `uvm_info(get_type_name(),$sformatf("Tx VL debug port comparison. Done."), UVM_LOW)

         end
      end
      begin
         forever begin

            `uvm_info(get_type_name(),$sformatf("Waiting for rx virtual lane debug port comparison"), UVM_FULL)

            wait((i_ptp_rx_vl_q.size() > 0) && (o_ptp_rx_vl_q.size() > 0));
            i_rx_vl = i_ptp_rx_vl_q.pop_front();
            o_rx_vl = o_ptp_rx_vl_q.pop_front();

            if (o_rx_vl === i_rx_vl) begin

               `uvm_info(get_type_name(),$sformatf("Rx VL debug port matches. i_rx_vl=%0d, i_rx_vl_q=%0d, o_rx_vl_q=%0d",
                  i_rx_vl, i_ptp_rx_vl_q.size(), o_ptp_rx_vl_q.size()), UVM_LOW)

            end
            else
               `uvm_error(get_type_name(),$sformatf("Rx VL debug port doesn't match! i_rx_vl=%0d, o_rx_vl=%0d, i_rx_vl_q=%0d, o_rx_vl_q=%0d",
                  i_rx_vl, o_rx_vl, i_ptp_rx_vl_q.size(), o_ptp_rx_vl_q.size()))

            `uvm_info(get_type_name(),$sformatf("Rx VL debug port comparison. Done."), UVM_LOW)

         end
      end
      join
   endtask : vl_debug_port_check

   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description:
   //
   //
   // Notes:
   // This function get the sent frame from TX_LAYERING_AGT
   // for functional checks, get o_egr_ts as golden, modify frame fields 
   // send to scoreboard as expected tx packet 
   //
   //--------------------------------------------------------------------------
   task modify_exp_ptp_fields();

      bit [47:0]           m_egr_ptp_tx_ts;
      bit [95:0]           m_nadder_tod_ts,egress_timestamp_eq_chk;
      eth_packet   exp_eth_frame, act_eth_frame;
      ptp_tx_tran     exp_egr_ts_frame, exp_ptp_fields, act_ptp_fields;
      shortint             comparing_frame_cnt, comparing_ptp_frame_cnt;
      bit [31:0]           m_ptp_debug_en;
      bit                  elane_en;
      bit tx_pp_en;
      bit is_vlan;
      bit is_stacked_vlan;
      bit m_rx_crc_fwd_en;
      bit m_dut_crc_insert_en;
      
      forever begin

         `uvm_info(get_type_name(),$sformatf("modify_exp_ptp_fields"), UVM_MEDIUM)

         wait(exp_eth_frame_q.size() > 0 && act_eth_frame_q.size()>0);

         if(reset_model_i)
            begin
                `uvm_info(get_type_name(),$sformatf("Entered to Not to send frames into queues reset_model_i: %d",reset_model_i), UVM_MEDIUM)
                wait(reset_model_i == 0);
                `uvm_info(get_type_name(),$sformatf("Exited to send frames into queues reset_model_i: %d",reset_model_i), UVM_MEDIUM)
                wait(exp_eth_frame_q.size() > 0 && act_eth_frame_q.size()>0);
            end
          else 
         `uvm_info(get_type_name(),$sformatf("No reset of frames in refmodel"), UVM_HIGH)
         
         exp_eth_frame = exp_eth_frame_q.pop_front();
         act_eth_frame = act_eth_frame_q.pop_front();

         if (exp_eth_frame.is_ptp_seq) begin

            //These are EHIP PTP register fields, are they needed? FIXME RR
            // extra latency reg fields: bit 31 is sign-bit, 15 ns, 16 fns
            //m_ptp_latency_s.ptp_tx_extra_latency = m_usr_urm.tx_ptp_extra_latency.extra_latency.get_mirrored_value();
            // clock period fields: fns
            //m_ptp_latency_s.ptp_tx_clk_period = m_usr_urm.tx_ptp_clk_period.clkrate.get_mirrored_value();
            //m_ptp_latency_s.tolerance_ns =  tolerance_value * m_ptp_latency_s.ptp_tx_clk_period[19:16];
            
            wait(exp_egr_ts_frame_q.size() > 0)
            
            //if (!exp_egr_ts_frame_q.size()) begin
            //   // It is expected that egress TS is now provided for PTP frames only. 
            //   `uvm_error(get_type_name(), $sformatf("Something Wrong! No Egress Time-stamp received"))
            //end
            //else begin
            //  exp_egr_ts_frame = exp_egr_ts_frame_q.pop_front();
            //end

            exp_egr_ts_frame = exp_egr_ts_frame_q.pop_front();

            comparing_ptp_frame_cnt++;

            if( (exp_eth_frame.frame_type === ETH_VLAN_FRAME) ||  (exp_eth_frame.frame_type === ETH_JUMBO_VLAN_FRAME) ) begin
              is_vlan = 1;
            end
            else if( (exp_eth_frame.frame_type === ETH_STACKED_VLAN_FRAME) ||  (exp_eth_frame.frame_type === ETH_JUMBO_STACKED_VLAN_FRAME) ) begin
              is_stacked_vlan = 1;
            end

            //
            // Based on the PTP control field info in the expected frame, modify expected ptp field bytes
            //
            //Find corresponding field in SIP FIXME RR
            //FIXME RR: for duplex, m_rx_crc_fwd_en=1 (would not depend on rx DUT config
            //For loopback, rx DUT config required
            //TODO_GDR:
            //bit m_rx_crc_fwd_en = m_usr_urm.mac_crc_config.forward_rx_crc.get_mirrored_value();
            m_rx_crc_fwd_en = 1; 
            m_dut_crc_insert_en = ~exp_eth_frame.skip_tx_crc_insertion;
            tx_pp_en = dyn_rcfg_obj_inst.preamble_passthrough;
            
            exp_eth_frame.reset_original_bytes(tx_pp_en, is_vlan, is_stacked_vlan);

            //Find corresponding field in SIP FIXME RR
            if(!exp_eth_frame.skip_tx_crc_insertion )
            //exp_ptp_fields = generate_exp_ptp_fields(exp_eth_frame, exp_egr_ts_frame, m_nadder_tod_ts, m_ptp_latency_s);
            exp_ptp_fields = generate_exp_ptp_fields(exp_eth_frame, exp_egr_ts_frame, act_eth_frame);
            if (exp_eth_frame.m_ptp_kind != PTP_ERR && !exp_eth_frame.skip_tx_crc_insertion ) begin
               // Modify PTP fields.
               case (exp_eth_frame.m_ptp_op)
                 INS_V1, 
                 INS_V1_W_ASYM_LAT, 
                 INS_V1_W_UDP_CS_0, 
                 INS_V1_W_ASYM_LAT_UDP_CS_0,
                 INS_V1_W_EB,
                 INS_V1_W_ASYM_LAT_EB: begin
                   exp_eth_frame.modify_v1(exp_eth_frame.m_ptp_op, exp_eth_frame.ptp_offset, exp_eth_frame.cs_offset, is_vlan, is_stacked_vlan, 
                                           m_rx_crc_fwd_en, m_dut_crc_insert_en, tx_pp_en, exp_ptp_fields.ts_bytes,  exp_ptp_fields.cf_bytes,  exp_ptp_fields.cs_bytes); 
                 end
                 INS_V2, 
                 INS_V2_W_ASYM_LAT, 
                 INS_V2_W_UDP_CS_0, 
                 INS_V2_W_ASYM_LAT_UDP_CS_0,
                 INS_V2_W_EB,
                 INS_V2_W_ASYM_LAT_EB: begin
            
                  exp_eth_frame.modify_v2(exp_eth_frame.m_ptp_op, exp_eth_frame.ptp_offset,exp_eth_frame.cf_offset, exp_eth_frame.cs_offset, is_vlan, is_stacked_vlan,
                                           m_rx_crc_fwd_en, m_dut_crc_insert_en, tx_pp_en, exp_ptp_fields.ts_bytes,  exp_ptp_fields.cf_bytes,  exp_ptp_fields.cs_bytes);
            
                  `uvm_info(get_type_name(), $sformatf("After modify V2"), UVM_MEDIUM)
                  exp_eth_frame.print();
            
                 end
                 INS_CF, 
                 INS_CF_W_ASYM_LAT, 
                 INS_CF_W_UDP_CS_0, 
                 INS_CF_W_ASYM_LAT_UDP_CS_0,
                 INS_CF_W_EB,
                 INS_CF_W_ASYM_LAT_EB,
                 INS_P2P, 
                 INS_P2P_W_UDP_CS_0, 
                 INS_P2P_W_EB, 
                 INS_P2P_W_ASYM_LAT, 
                 INS_P2P_W_ASYM_LAT_UDP_CS_0, 
                 INS_P2P_W_ASYM_LAT_EB,
                 INS_ASYM_LAT,
                 INS_ASYM_LAT_CS_0,
                 INS_ASYM_LAT_EB: begin
                   exp_eth_frame.modify_cf(exp_eth_frame.m_ptp_op, exp_eth_frame.cf_offset,exp_eth_frame.cs_offset, is_vlan, is_stacked_vlan, 
                                           m_rx_crc_fwd_en, m_dut_crc_insert_en, tx_pp_en, exp_ptp_fields.ts_bytes,  exp_ptp_fields.cf_bytes,  exp_ptp_fields.cs_bytes);
                 end
                 INS_2STEP: begin
                   `uvm_info(get_type_name(), 
                            $sformatf("modify_exp_ptp_fields::2STEP operation no frame modification"),UVM_LOW)
                 end
                 default: begin
                   `uvm_error(get_type_name(), $sformatf("modify_ptp_fields called with invalid opcode exp_eth_frame.m_ptp_op :%s", 
                              exp_eth_frame.m_ptp_op));
                 end
               
               endcase 
               //DM_TODO: check regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
               `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
               //DM_TODO: check read_data = regs.get_mirrored_value();
//               `ifndef ENABLE_ETH_VIP
               //regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
               $display("\n\n\n\n\n***********READ_DATA_VALUE=%h************\n\n\n\n\n",read_data);
//                if(read_data==0)
//                  exp_eth_frame.fcs= 0;
//                else
//                 if(exp_eth_frame.m_ptp_op!=INS_2STEP) exp_eth_frame.fcs={<<byte{exp_eth_frame.fcs}};
//               `else
               `uvm_info(get_type_name(), $sformatf("Before fcs reversal: FCS=%0h",exp_eth_frame.fcs),UVM_MEDIUM)
               if(exp_eth_frame.m_ptp_op!=INS_2STEP) exp_eth_frame.fcs={<<byte{exp_eth_frame.fcs}};
               if (exp_eth_frame.m_ptp_op==INS_2STEP && dyn_rcfg_obj_inst.mode == MACSEG) exp_eth_frame.fcs={<<byte{exp_eth_frame.fcs}};
               `uvm_info(get_type_name(), $sformatf("After fcs reversal: FCS=%0h",exp_eth_frame.fcs),UVM_MEDIUM)
//               `endif
 end 
            else begin // ERR Kind.
               `uvm_info(get_type_name(), 
                  $sformatf("modify_exp_ptp_fields::Ignored. Bad PTP Frame,=%0d, FrameNum=%0d  skip_crc_insertion = %0d", 
                     comparing_frame_cnt, comparing_ptp_frame_cnt,exp_eth_frame.skip_tx_crc_insertion),UVM_MEDIUM)
            end
         end //is_ptp_seq
         else begin
           `uvm_info(get_type_name(), $sformatf("modify_exp_ptp_fields::Ignoring Non-PTP frame"), UVM_MEDIUM)
         end 

         `uvm_info(get_type_name(), $sformatf("modify_exp_ptp_fields::Done. FrameNum=%0d, PTP_FrameNum=%0d",
                 comparing_frame_cnt, comparing_ptp_frame_cnt), UVM_MEDIUM)

         //Send packet to scoreboard
         a_port.write(exp_eth_frame); 

         // clear frame type after sending packet to scoreboard
         is_vlan = 0;
         is_stacked_vlan = 0;

      end

   endtask : modify_exp_ptp_fields

   //------------------------------------------------------------------------
   //
   //
   //------------------------------------------------------------------------
   virtual function ptp_tx_tran generate_exp_ptp_fields(const ref eth_packet in_eth_trans, 
      const ref ptp_tx_tran in_ptp_trans, const ref eth_packet act_eth_trans);

      ptp_op_e m_ptp_op;
      bit[31:0] cf_offset_sb;
      bit[63:0] cf_offset_rx_val;
      bit[6:0]  asym_p2p_idx;
      bit[31:0] asym_reg_read_data, p2p_reg_read_data;

      generate_exp_ptp_fields = ptp_tx_tran::type_id::create("generate_exp_ptp_fields");
 
      
      m_ptp_op = in_eth_trans.m_ptp_op;
      asym_p2p_idx = in_eth_trans.asym_p2p_idx;
             

      `uvm_info(get_type_name(), $sformatf("ptp_opcode=%s", m_ptp_op.name), UVM_MEDIUM)

      //Read asym and p2p reg
      if (m_ptp_op[7]) begin
	`uvm_info(get_type_name(), $sformatf("m_ptp_op[7]: %b, asym_p2p_idx: %d, global_p2p_lat: %h", m_ptp_op[7], asym_p2p_idx, global_p2p_lat[asym_p2p_idx]), UVM_MEDIUM)
        p2p_lat = {global_p2p_lat[asym_p2p_idx], 8'b0}; //{p2p_reg_read_data,8'b0};
	`uvm_info(get_type_name(), $sformatf("p2p_lat: %h", p2p_lat), UVM_MEDIUM)
      end 
      if (m_ptp_op[0]) begin
	`uvm_info(get_type_name(), $sformatf("m_ptp_op[0]: %b, asym_p2p_idx: %d, global_asm_lat: %h", m_ptp_op[0], asym_p2p_idx, global_asm_lat[asym_p2p_idx]), UVM_MEDIUM)
        asym_lat = {global_asm_lat[asym_p2p_idx], 8'b0}; //{asym_reg_read_data, 8'b0};
	`uvm_info(get_type_name(), $sformatf("asym_lat: %h", asym_lat), UVM_MEDIUM)
      end
      //  asym_lat=33280; //read from reg or seq
      //  p2p_lat=33536; //read from reg or seq

      generate_exp_ptp_fields.o_ptp_ets_fp = in_eth_trans.i_ptp_tx_fp; // Expected Finger Print.
  //    if (m_ptp_op inside {INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,INS_P2P,INS_P2P_W_EB,INS_P2P_W_UDP_CS_0}) 
  //    begin
  //        $display("asym/p2p opcode");
  //        asym_lat = 130; //because forced the reg to 130
  //      //Read from seq or RAL and assign to asym_lat
  //    end

      if((in_eth_trans.frame_type == ETH_DATA_FRAME) || (in_eth_trans.frame_type == ETH_JUMBO_DATA_FRAME) ||(in_eth_trans.frame_type == ETH_IPV4_FRAME) || (in_eth_trans.frame_type == ETH_IPV6_FRAME) || (in_eth_trans.frame_type == ETH_USER_DEFINED_FRAME))
          cf_offset_sb = in_eth_trans.cf_offset - 14 ;
      if ((in_eth_trans.frame_type == ETH_VLAN_FRAME) || (in_eth_trans.frame_type == ETH_JUMBO_VLAN_FRAME) )
           cf_offset_sb = in_eth_trans.cf_offset  - 14 - 4;
      if ((in_eth_trans.frame_type == ETH_STACKED_VLAN_FRAME) || (in_eth_trans.frame_type == ETH_JUMBO_STACKED_VLAN_FRAME ))  
             cf_offset_sb = in_eth_trans.cf_offset  - 14 - 8;

      cf_offset_rx_val = {act_eth_trans.payload[cf_offset_sb],act_eth_trans.payload[cf_offset_sb+1],act_eth_trans.payload[cf_offset_sb+2],act_eth_trans.payload[cf_offset_sb+3],act_eth_trans.payload[cf_offset_sb+4],act_eth_trans.payload[cf_offset_sb+5],act_eth_trans.payload[cf_offset_sb+6],act_eth_trans.payload[cf_offset_sb+7]};

      `uvm_info(get_type_name(), $psprintf("cf values of rx value and tx value cf_offset_rx_val= %0h", cf_offset_rx_val),UVM_MEDIUM);

      case(m_ptp_op)
         INS_NOOP: begin
          // Do nothing.
         end
         INS_V1, INS_V1_W_ASYM_LAT: begin

            generate_exp_ptp_fields.ts_bytes_are_valid = 1;
            // Set expected timestamp field.
            generate_exp_ptp_fields.ts_bytes = get_exp_ts_bytes(in_eth_trans, in_ptp_trans);
   
            // Latency check FIXME RR: how to account for extra_latency 
            //if(m_ptp_op === INS_V1_W_ASYM_LAT) begin
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s);
            // if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
         end
         INS_V1_W_UDP_CS_0, INS_V1_W_ASYM_LAT_UDP_CS_0: begin

            generate_exp_ptp_fields.ts_bytes_are_valid = 1;
            // Set expected timestamp field.
            generate_exp_ptp_fields.ts_bytes = get_exp_ts_bytes(in_eth_trans, in_ptp_trans);
   
            generate_exp_ptp_fields.cs_bytes_are_valid = 1;
            generate_exp_ptp_fields.cs_bytes = 16'h0;
   
            // Latency check FIXME RR: how to account for extra_latency 
            //if(m_ptp_op === INS_V1_W_ASYM_LAT_UDP_CS_0) begin
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s);
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
         end
         INS_V1_W_EB, INS_V1_W_ASYM_LAT_EB: begin

            bit odd_cs_offset, odd_ts_offset;
            int pyld_bytes_size;
            bit [79:0] orig_ts_bytes;
            bit [64:0] diff_v1_ts; 
            bit [63:0] inv_new_ts;
            bit [31:0] extra_cs_1;
            bit [15:0] inv_cs_corrector, inv_verify_cs;
            bit [16:0] exp_cs_corrector, extra_cs_2, verify_cs;
   
            generate_exp_ptp_fields.ts_bytes_are_valid = 1;
            // Set expected timestamp field.
            generate_exp_ptp_fields.ts_bytes = get_exp_ts_bytes(in_eth_trans, in_ptp_trans);
   
            generate_exp_ptp_fields.cs_bytes_are_valid = 1;
            // EB bytes calculation
            pyld_bytes_size = in_eth_trans.payload.size();
            orig_ts_bytes = in_eth_trans.original_bytes;
            // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
            if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1;
            else odd_cs_offset = 0; 
            if (in_eth_trans.ptp_offset % 2) odd_ts_offset = 1;
            else odd_ts_offset = 0;
            
            // Find the diff b/n original ts and expected ts fields
            inv_new_ts = ~(generate_exp_ptp_fields.ts_bytes[63:0]); // 1's complement
            diff_v1_ts = in_eth_trans.original_bytes[79:16] + inv_new_ts; // old +(~new), in 1's complement world
            diff_v1_ts[63:0] = diff_v1_ts[63:0] + diff_v1_ts[64]; // add cb bit
   
            extra_cs_1 = diff_v1_ts[63:48] + diff_v1_ts[47:32] + diff_v1_ts[31:16] + diff_v1_ts[15:0];
            extra_cs_2 = extra_cs_1[31:16] + extra_cs_1[15:0];
            inv_cs_corrector = extra_cs_2[15:0] + extra_cs_2[16]; 
           
            if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
            // new_cs + old_cs
               exp_cs_corrector = (odd_ts_offset ? {inv_cs_corrector[7:0], inv_cs_corrector[15:8]} 
                                                   : inv_cs_corrector) 
                                                               + 
                                    (odd_cs_offset ? 
                                          {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                                          : in_eth_trans.original_cs_bytes);
            end
            else begin
               // 
               `uvm_error(get_type_name(),"ins_v1_w_eb_bytes, skip_crc_insertion not supported");
            end
           
            // One more time, to be sure
            exp_cs_corrector[15:0] = exp_cs_corrector[15:0] + exp_cs_corrector[16];
               
            // Based on original cs offset position, order the expected new cs bytes
            generate_exp_ptp_fields.cs_bytes[15:8] = 
               odd_cs_offset ? exp_cs_corrector[7:0] : exp_cs_corrector[15:8];
            generate_exp_ptp_fields.cs_bytes[7:0] = 
               odd_cs_offset ? exp_cs_corrector[15:8] : exp_cs_corrector[7:0];
            
            `uvm_info(get_type_name(), 
               $sformatf("pyld_size=%0d, odd_ts_cs_offset=%0b_%0b", 
                  pyld_bytes_size, odd_ts_offset, odd_cs_offset), UVM_FULL);
            `uvm_info(get_type_name(), 
               $sformatf("diff_v1_ts=x%0x, orig_bytes=x%0x, egress_ts=x%0x", 
                  diff_v1_ts, in_eth_trans.original_bytes[79:16], 
                  generate_exp_ptp_fields.ts_bytes[63:0]), UVM_DEBUG);
            `uvm_info(get_type_name(),
               $sformatf("UNINVERTED: new_ts_cs=x%0x, old_cs=x%0x, exp_cs=x%0x", 
                  inv_cs_corrector[15:0], in_eth_trans.original_cs_bytes[15:0], 
                  exp_cs_corrector[15:0]), UVM_FULL);

            // verify expected CS bytes
            // new_ts_bytes + new_cs_bytes, in 16-bit chunks, into 17 bit result
            verify_cs = generate_exp_ptp_fields.ts_bytes[63:48] +
                        generate_exp_ptp_fields.ts_bytes[47:32] +
                        generate_exp_ptp_fields.ts_bytes[31:16] +
                        generate_exp_ptp_fields.ts_bytes[15:0] +
                        generate_exp_ptp_fields.cs_bytes[15:0] ;
            // add the carry bit
            verify_cs[15:0] = verify_cs[15:0] + verify_cs[16];
            // take 1's complement, and it should be zero(and that means no error).
            inv_verify_cs = ~(verify_cs[15:0]);
            `uvm_info(get_type_name(), 
              $sformatf("new_ts_bytes=%x,new_cs_bytes=%x,verify_cs_16=%x, inv_verify_cs=%x", 
                 generate_exp_ptp_fields.ts_bytes[63:0], generate_exp_ptp_fields.cs_bytes,
                 verify_cs[16:0], inv_verify_cs), UVM_DEBUG);
            if (verify_cs[15:0] == 'hffff) 
              `uvm_info(get_type_name(), $sformatf("PASS. CS Updated calc-ed Correctly!"), UVM_MEDIUM)
            else begin
               `uvm_info(get_type_name(), $sformatf("Investigate. CS Update calc. incorrect., =%x",
                  verify_cs[15:0]), UVM_MEDIUM);
            end

            // Latency check FIXME RR: how to account for extra_latency 
            //if(m_ptp_op === INS_V1_W_ASYM_LAT_EB) begin
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s);
            //  if (pass) 
            //     `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
         end

         INS_V2, INS_V2_W_ASYM_LAT: begin

            generate_exp_ptp_fields.ts_bytes_are_valid = 1;
            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set Timestamp and Correction fields.
            // 1. Set expected timestamp field.
            generate_exp_ptp_fields.ts_bytes = get_exp_ts_bytes(in_eth_trans, in_ptp_trans);
            // 2. Set expected correction field.
            // Expected cf bytes: Add the 16 bit fns from the egress ts to the original cf bytes
   
            // if (m_ptp_op === INS_V2) begin
            //    generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0];
            //    overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes); 
            // end else if (!in_eth_trans.asym_sign) begin
            //    generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0]+  asym_lat ; 
            //    overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes); 
            // end else if (in_eth_trans.asym_sign) begin
            //    generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0] - asym_lat  ; 
            //    overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes); 
            // end
            if (m_ptp_op === INS_V2) begin
             generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0];
             overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else begin //for ASM case
              if (!in_eth_trans.asym_sign) begin
                 generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0]+  asym_lat ; 
                 overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
              end else if (in_eth_trans.asym_sign) begin
                 generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0] - asym_lat  ; 
                 overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
              end
            end


              `uvm_info(get_type_name(),  $sformatf("ORIGNAL_CF_BYTES=x%0x m_ptp_op=%s genrated cf=%0x", in_eth_trans.original_cf_bytes, m_ptp_op,generate_exp_ptp_fields.cf_bytes), UVM_LOW) 

           `uvm_info(get_type_name(), $sformatf("ptp_op=%s, orig_cf_bytes=x%0x, exp_fns=x%0x", 
              m_ptp_op.name, in_eth_trans.original_cf_bytes, 
              in_ptp_trans.o_ptp_ets[15:0]), UVM_DEBUG)

            // Latency check FIXME RR: how to account for extra_latency 
            //if(m_ptp_op === INS_V2_W_ASYM_LAT) begin
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s);
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
         end

         INS_V2_W_UDP_CS_0, INS_V2_W_ASYM_LAT_UDP_CS_0: begin

            generate_exp_ptp_fields.ts_bytes_are_valid = 1;
            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set Timestamp and Correction fields.
            // 1. Set expected timestamp field.
            generate_exp_ptp_fields.ts_bytes = get_exp_ts_bytes(in_eth_trans, in_ptp_trans);
            // generate_exp_ptp_fields.ts_bytes = {in_ptp_trans.nadder_tod_ts[95:48],
            //                                     in_ptp_trans.ptp_tx_ts[47:16]}; 
            // 2. Set expected correction field.
            // Expected cf bytes: Add the 16 bit fns from the egress ts to the original cf bytes
            if(m_ptp_op === INS_V2_W_UDP_CS_0 ) begin
            generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0]; 
            overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes);end 
            else if (!in_eth_trans.asym_sign) begin
            generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0] +  asym_lat  ; 
            overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes);end 
            else if (in_eth_trans.asym_sign) begin
            generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0] -  asym_lat  ; 
            overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes);end 



            `uvm_info(get_type_name(), $sformatf("ptp_op=%s, orig_cf_bytes=x%0x, exp_fns=x%0x", 
              m_ptp_op.name, in_eth_trans.original_cf_bytes, 
              in_ptp_trans.o_ptp_ets[15:0]), UVM_DEBUG)

            // Set UDP CS fields.
            generate_exp_ptp_fields.cs_bytes_are_valid = 1;
            generate_exp_ptp_fields.cs_bytes = 16'h0; 

            // Latency check FIXME RR: how to account for extra_latency 
            //if(m_ptp_op === INS_V2_W_ASYM_LAT_UDP_CS_0) begin
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s);
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end

         end

         INS_V2_W_EB, INS_V2_W_ASYM_LAT_EB: begin

            // Set Timestamp and EB fields.
            bit odd_cs_offset, odd_ts_offset, odd_cf_offset;
            int pyld_bytes_size;
            bit [79:0] inv_new_ts_no_fns;
            bit [63:0] inv_new_cf;
            bit [80:0] diff_v2_ts_no_fns;
            // bit [96:0] diff_v2_ts; // extra bit for cb
            bit [64:0] diff_cf;    // extra bit for cb
            bit [31:0] new_cs, new_ts_cs_1, new_cf_cs_1, upd_cs_1; 
            bit [16:0] verify_cs, new_ts_cs_2, new_cf_cs_2, upd_cs_2; // extra bit for cb
            bit [15:0] inv_verify_cs;

            generate_exp_ptp_fields.ts_bytes_are_valid = 1;
            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set Timestamp field 
            // 1. Set expected timestamp field.
            // upper 48s field, lower 32ns field
            generate_exp_ptp_fields.ts_bytes = get_exp_ts_bytes(in_eth_trans, in_ptp_trans);

            // 2. Set expected correction field.
   
            // Expected cf bytes: Add the 16 bit fns from the egress ts to the original cf bytes
            if(m_ptp_op === INS_V2_W_EB) begin
            generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0]; 
            overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes);end 
            // Revisit: can overflow happen?
            else if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0]  +  asym_lat  ;  
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
            else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes + in_ptp_trans.o_ptp_ets[15:0]  -  asym_lat  ;  
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end

            `uvm_info(get_type_name(), $sformatf("ptp_op=%s, orig_cf_bytes=x%0x, exp_fns=x%0x", 
              m_ptp_op.name, in_eth_trans.original_cf_bytes, 
              in_ptp_trans.o_ptp_ets[15:0]), UVM_DEBUG)

            // Latency check FIXME RR: how to account for extra_latency 
            //if (m_ptp_op == INS_V2_W_ASYM_LAT_EB) begin : EXTRA_LATENCY_CHECK
            //   bit pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s);
            //   if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end : EXTRA_LATENCY_CHECK
   
            // EB bytes calculation
           
            generate_exp_ptp_fields.cs_bytes_are_valid = 1;
            pyld_bytes_size = in_eth_trans.payload.size();
            // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
            if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1; 
            else odd_cs_offset = 0; 
            if (in_eth_trans.ptp_offset % 2) odd_ts_offset = 1;
            else odd_ts_offset = 0;
            if (in_eth_trans.cf_offset % 2) odd_cf_offset = 1;
            else odd_cf_offset = 0;
            
            `uvm_info(get_type_name(), $psprintf("cs_offset= %0h, ptp_offset=%0h, cf_offset=%0h", in_eth_trans.cs_offset,in_eth_trans.ptp_offset,in_eth_trans.cf_offset),UVM_MEDIUM);
            `uvm_info(get_type_name(), $psprintf("odd_cs_offset= %0h, odd_ts_offset=%0h, odd_cf_offset=%0h", odd_cs_offset,odd_ts_offset,odd_cf_offset),UVM_MEDIUM);


            // Find the diff b/n original ts and expected ts fields
            inv_new_ts_no_fns = ~(generate_exp_ptp_fields.ts_bytes); // 1's compl.
            diff_v2_ts_no_fns = in_eth_trans.original_bytes[79:0] + inv_new_ts_no_fns; // old +(~new)
            diff_v2_ts_no_fns[79:0] = diff_v2_ts_no_fns[79:0] + diff_v2_ts_no_fns[80]; // add cb
            
            `uvm_info(get_type_name(), $psprintf("inv_new_ts_no_fns=%0h, diff_v2_ts_no_fns= %0h",inv_new_ts_no_fns, diff_v2_ts_no_fns),UVM_MEDIUM);
   
            new_ts_cs_1 = diff_v2_ts_no_fns[79:64] + diff_v2_ts_no_fns[63:48] + 
                        diff_v2_ts_no_fns[47:32] + diff_v2_ts_no_fns[31:16] + 
                        diff_v2_ts_no_fns[15:0];
            new_ts_cs_2 = new_ts_cs_1[31:16] + new_ts_cs_1[15:0];  // cb
            new_ts_cs_2[15:0] = new_ts_cs_2[15:0] + new_ts_cs_2[16];  // redundant: another cb, just in case.
           
            `uvm_info(get_type_name(), $psprintf("new_ts_cs_1=%0h, new_ts_cs_2= %0h",new_ts_cs_1, new_ts_cs_2),UVM_MEDIUM);

            // Find the  diff b/n original cf and expected cf 
            //generate_exp_ptp_fields.cf_bytes need to get the actual value from DUT which doesnt lost 8 bit accuracy value
            //inv_new_cf = ~(generate_exp_ptp_fields.cf_bytes); // 1's complement
            inv_new_cf = ~(cf_offset_rx_val); // 1's complement
            `uvm_info(get_type_name(), $psprintf("inv_new_cf= %0h", inv_new_cf),UVM_MEDIUM);
            // old + (~new)
            diff_cf = in_eth_trans.original_cf_bytes + inv_new_cf; 
            `uvm_info(get_type_name(), $psprintf("original_cf_bytes= %0h, diff_cf=%0h", in_eth_trans.original_cf_bytes,diff_cf),UVM_MEDIUM);
            diff_cf[63:0] = diff_cf[63:0] + diff_cf[64]; // add the cb bit


            new_cf_cs_1 = diff_cf[63:48] + diff_cf[47:32] + diff_cf[31:16] + diff_cf[15:0]; 
            new_cf_cs_2 = new_cf_cs_1[31:16] + new_cf_cs_1[15:0];  // cb
            new_cf_cs_2[15:0] = new_cf_cs_2[15:0] + new_cf_cs_2[16]; // redundant: another cb, just in case
           
            `uvm_info(get_type_name(), $psprintf("new_cf_cs_1= %0h, new_cf_cs_2=%0h", new_cf_cs_1,new_cf_cs_2),UVM_MEDIUM);
            `uvm_info(get_type_name(), $psprintf("original_cs_bytes= %0h", in_eth_trans.original_cs_bytes),UVM_MEDIUM);

           
            if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
               // new_cs + old_cs
               upd_cs_1 = (odd_ts_offset ? {new_ts_cs_2[7:0], new_ts_cs_2[15:8]} : new_ts_cs_2[15:0])
                         +
                         (odd_cf_offset ? {new_cf_cs_2[7:0], new_cf_cs_2[15:8]} : new_cf_cs_2[15:0])
                         +
                         (odd_cs_offset 
                            ? {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                            : in_eth_trans.original_cs_bytes);
            end else begin
               // 
               `uvm_error(get_type_name(),"ins_v2_w_eb_bytes, skip_crc_insertion not supported");
            end
           
            `uvm_info(get_type_name(), $psprintf("upd_cs_1= %0h", upd_cs_1),UVM_MEDIUM);
           
            upd_cs_2 = upd_cs_1[15:0] + upd_cs_1[31:16]; // cb
            upd_cs_2[15:0] = upd_cs_2[15:0] + upd_cs_2[16]; // redundant: another cb, just in case 
           
            `uvm_info(get_type_name(), $psprintf("upd_cs_2= %0h", upd_cs_2),UVM_MEDIUM);

            `uvm_info(get_type_name(), 
              $sformatf("pyld_size=%0d,odd_ts_cf_cs_offsets=%0b_%0b_%0b", 
                 pyld_bytes_size, odd_ts_offset, odd_cf_offset, odd_cs_offset), UVM_FULL);

            `uvm_info(get_type_name(),
              $sformatf("UNINVERTED: old_cs=x%0x, new_ts_cs_2=x%0x, new_cf_cs_2=x%0x, upd_cs_2=x%0x",
                  in_eth_trans.original_cs_bytes, new_ts_cs_2[15:0], new_cf_cs_2[15:0], upd_cs_2[15:0]), UVM_FULL);
           
            generate_exp_ptp_fields.cs_bytes[15:8] = 
              odd_cs_offset ? upd_cs_2[7:0] : upd_cs_2[15:8];
            generate_exp_ptp_fields.cs_bytes[7:0] = 
              odd_cs_offset ? upd_cs_2[15:8] : upd_cs_2[7:0];

            `uvm_info(get_type_name(), 
              $sformatf("diff_v2_ts_no_fns=x%0x, orig_ts_bytes=x%0x, inv_egress_ts=x%0x", 
                 diff_v2_ts_no_fns[79:0], in_eth_trans.original_bytes[79:0], 
                 inv_new_ts_no_fns), UVM_DEBUG);
            `uvm_info(get_type_name(), 
              $sformatf("diff_cf=x%0x, orig_cf_bytes=x%0x, inv_new_cf=x%0x", 
                 diff_cf[63:0], in_eth_trans.original_cf_bytes[63:0], 
                 inv_new_cf), UVM_DEBUG);
         end

         INS_CF, INS_CF_W_ASYM_LAT: begin

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if(m_ptp_op === INS_CF) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans); 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  +  asym_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  -  asym_lat ;
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
           
              `uvm_info(get_type_name(),  $sformatf("ORIGNAL_CF_BYTES=x%0x m_ptp_op=%s genrated cf=%0x", in_eth_trans.original_cf_bytes, m_ptp_op,generate_exp_ptp_fields.cf_bytes), UVM_LOW) 

            // Latency check FIXME RR: how to account for extra_latency 
            //if (m_ptp_op === INS_CF_W_ASYM_LAT) begin 
            //  // Latency check
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s); 
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
         end

         INS_CF_W_UDP_CS_0, INS_CF_W_ASYM_LAT_UDP_CS_0: begin

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if(m_ptp_op === INS_CF_W_UDP_CS_0 ) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans); 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  +  asym_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (in_eth_trans.asym_sign) begin
                 generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  -  asym_lat ; 
                 overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
           
              `uvm_info(get_type_name(),  $sformatf("ORIGNAL_CF_BYTES=x%0x m_ptp_op=%s genrated cf=%0x", in_eth_trans.original_cf_bytes, m_ptp_op,generate_exp_ptp_fields.cf_bytes), UVM_LOW) 
            //Set cs_bytes
            generate_exp_ptp_fields.cs_bytes_are_valid = 1;
            generate_exp_ptp_fields.cs_bytes = 16'h0; 
   
            // Latency check FIXME RR: how to account for extra_latency 
            //if (m_ptp_op === INS_CF_W_ASYM_LAT_UDP_CS_0) begin 
            //  // Latency check
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s); 
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end

         end

         INS_CF_W_EB, INS_CF_W_ASYM_LAT_EB: begin

            // Set CF and EB fields.
            bit odd_cs_offset, odd_cf_offset;
            int pyld_bytes_size;
            bit [64:0] diff_cf; 
            bit [63:0] inv_new_cf;
            bit [15:0] inv_verify_cs;
            bit [31:0] new_cs;
            bit [16:0] new_cs_2, upd_cs, verify_cs;

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if (m_ptp_op === INS_CF_W_EB) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans); 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  +  asym_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  -  asym_lat ; 
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
           

            // Latency check FIXME RR: how to account for extra_latency 
            //if (m_ptp_op === INS_CF_W_ASYM_LAT_EB) begin 
            //  // Latency check
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s); 
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
   
            // EB bytes calculation
          
            generate_exp_ptp_fields.cs_bytes_are_valid = 1; 
            // 1. determine if the cs_offset location is odd/even
            pyld_bytes_size = in_eth_trans.payload.size();
            // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
            if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1; 
            else odd_cs_offset = 0; 
            if (in_eth_trans.cf_offset % 2) odd_cf_offset = 1;
            else odd_cf_offset = 0;
            // 2. Do the math for CS bytes.
            //    a. Find the diff between new and old CF
            inv_new_cf = ~(cf_offset_rx_val); // 1's complement
            // old + (~new)
            diff_cf = in_eth_trans.original_cf_bytes + inv_new_cf; // old + (~new) 
            diff_cf[63:0] = diff_cf[63:0] + diff_cf[64]; // add the cb bit
            
            new_cs = diff_cf[63:48] + diff_cf[47:32] + diff_cf[31:16] + diff_cf[15:0]; 
            new_cs_2[16:0] = new_cs[31:16] + new_cs[15:0]; // cb
            new_cs_2[15:0] = new_cs_2[15:0] + new_cs_2[16]; // redundant: another cb, just in case
           
            if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
               // new_cs + old_cs
               upd_cs = (odd_cf_offset ? {new_cs_2[7:0], new_cs_2[15:8]} : new_cs_2[15:0])
                           + 
                        (odd_cs_offset 
                           ? {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                           : in_eth_trans.original_cs_bytes);
            end else begin
               // 
               `uvm_error(get_type_name(),"ins_cf_w_eb_bytes, skip_crc_insertion not supported");
            end
           
            // add cb
            upd_cs[15:0] = upd_cs[15:0] + upd_cs[16];
            
            `uvm_info(get_type_name(), 
               $sformatf("pyld_size=%0d,odd_cf_cs_offset=%0b_%0b", 
                  pyld_bytes_size, odd_cf_offset, odd_cs_offset), UVM_FULL);
            
            `uvm_info(get_type_name(), 
               $sformatf("UNINVERTED: inv_new_cf=x%0x, diff_cf=x%0x, old_cs=x%0x, new_cs=x%0x, new_cs_2=x%0x, exp_cs=x%0x", 
                  inv_new_cf, diff_cf, in_eth_trans.original_cs_bytes, new_cs[15:0], new_cs_2[15:0], upd_cs[15:0]), UVM_FULL);
            
            // Based on original cs offset position, order the expected new cs bytes
            generate_exp_ptp_fields.cs_bytes[15:8] = 
               odd_cs_offset ? upd_cs[7:0] : upd_cs[15:8];
            generate_exp_ptp_fields.cs_bytes[7:0] = 
               odd_cs_offset ? upd_cs[15:8] : upd_cs[7:0];
         end

         INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB: begin
         
            // Set CF and EB fields.
            bit odd_cs_offset, odd_cf_offset;
            int pyld_bytes_size;
            bit [64:0] diff_cf; 
            bit [63:0] inv_new_cf;
            bit [15:0] inv_verify_cs;
            bit [31:0] new_cs;
            bit [16:0] new_cs_2, upd_cs, verify_cs;
          
            if (!in_eth_trans.asym_sign) begin 
               generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes  +  asym_lat  ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes  -  asym_lat  ; 
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
             
              `uvm_info(get_type_name(),  $sformatf("ORIGNAL_CF_BYTES=x%0x m_ptp_op=%s genrated cf=%0x", in_eth_trans.original_cf_bytes, m_ptp_op,generate_exp_ptp_fields.cf_bytes), UVM_LOW) 

            if (m_ptp_op === INS_ASYM_LAT_CS_0) begin 
               generate_exp_ptp_fields.cs_bytes_are_valid = 1;
               generate_exp_ptp_fields.cs_bytes = 16'h0;
            end else if (INS_ASYM_LAT_EB) begin


               // EB bytes calculation
            
               generate_exp_ptp_fields.cs_bytes_are_valid = 1; 
               // 1. determine if the cs_offset location is odd/even
               pyld_bytes_size = in_eth_trans.payload.size();
               // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
               if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1; 
               else odd_cs_offset = 0; 
               if (in_eth_trans.cf_offset % 2) odd_cf_offset = 1;
               else odd_cf_offset = 0;
               // 2. Do the math for CS bytes.
               //    a. Find the diff between new and old CF
               inv_new_cf = ~(cf_offset_rx_val); // 1's complement
               // old + (~new)
               diff_cf = in_eth_trans.original_cf_bytes + inv_new_cf; // old + (~new) 
               diff_cf[63:0] = diff_cf[63:0] + diff_cf[64]; // add the cb bit
               
               new_cs = diff_cf[63:48] + diff_cf[47:32] + diff_cf[31:16] + diff_cf[15:0]; 
               new_cs_2[16:0] = new_cs[31:16] + new_cs[15:0]; // cb
               new_cs_2[15:0] = new_cs_2[15:0] + new_cs_2[16]; // redundant: another cb, just in case
            
               if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
                  // new_cs + old_cs
                  upd_cs = (odd_cf_offset ? {new_cs_2[7:0], new_cs_2[15:8]} : new_cs_2[15:0])
                              + 
                           (odd_cs_offset 
                              ? {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                              : in_eth_trans.original_cs_bytes);
               end
               else begin
                  // 
                  `uvm_error(get_type_name(),"ins_cf_w_eb_bytes, skip_crc_insertion not supported");
               end
            
               // add cb
               upd_cs[15:0] = upd_cs[15:0] + upd_cs[16];
               
               `uvm_info(get_type_name(), 
                  $sformatf("pyld_size=%0d,odd_cf_cs_offset=%0b_%0b", 
                     pyld_bytes_size, odd_cf_offset, odd_cs_offset), UVM_FULL);
               
               `uvm_info(get_type_name(), 
                  $sformatf("UNINVERTED: inv_new_cf=x%0x, diff_cf=x%0x, old_cs=x%0x, new_cs=x%0x, new_cs_2=x%0x, exp_cs=x%0x", 
                     inv_new_cf, diff_cf, in_eth_trans.original_cs_bytes, new_cs[15:0], new_cs_2[15:0], upd_cs[15:0]), UVM_FULL);
               
               // Based on original cs offset position, order the expected new cs bytes
               generate_exp_ptp_fields.cs_bytes[15:8] = 
                  odd_cs_offset ? upd_cs[7:0] : upd_cs[15:8];
               generate_exp_ptp_fields.cs_bytes[7:0] = 
                  odd_cs_offset ? upd_cs[15:8] : upd_cs[7:0];
                  
            end

         end
         
         INS_P2P: begin
            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if(m_ptp_op === INS_P2P) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  +  p2p_lat ;
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
         end
       
         INS_P2P_W_UDP_CS_0: begin
            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if(m_ptp_op === INS_P2P_W_UDP_CS_0 ) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  +  p2p_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
         
               //Set cs_bytes
               generate_exp_ptp_fields.cs_bytes_are_valid = 1;
               generate_exp_ptp_fields.cs_bytes = 16'h0; 

         end

         INS_P2P_W_EB: begin

            // Set CF and EB fields.
            bit odd_cs_offset, odd_cf_offset;
            int pyld_bytes_size;
            bit [64:0] diff_cf; 
            bit [63:0] inv_new_cf;
            bit [15:0] inv_verify_cs;
            bit [31:0] new_cs;
            bit [16:0] new_cs_2, upd_cs, verify_cs;

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if (m_ptp_op === INS_P2P_W_EB) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  +  p2p_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
           

            // Latency check FIXME RR: how to account for extra_latency 
            //if (m_ptp_op === INS_CF_W_ASYM_LAT_EB) begin 
            //  // Latency check
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s); 
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
   
            // EB bytes calculation
          
            generate_exp_ptp_fields.cs_bytes_are_valid = 1; 
            // 1. determine if the cs_offset location is odd/even
            pyld_bytes_size = in_eth_trans.payload.size();
            // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
            if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1; 
            else odd_cs_offset = 0; 
            if (in_eth_trans.cf_offset % 2) odd_cf_offset = 1;
            else odd_cf_offset = 0;
            // 2. Do the math for CS bytes.
            //    a. Find the diff between new and old CF
            //inv_new_cf = ~(generate_exp_ptp_fields.cf_bytes); // 1's complement
            //generate_exp_ptp_fields.cf_bytes need to get the actual value from DUT which doesnt lost 8 bit accuracy value
            inv_new_cf = ~(cf_offset_rx_val); // 1's complement
            `uvm_info(get_type_name(), $psprintf("cf_offset_rx_val= %0h", cf_offset_rx_val),UVM_MEDIUM);
            `uvm_info(get_type_name(), $psprintf("inv_new_cf= %0h", inv_new_cf),UVM_MEDIUM);
            // old + (~new)
            diff_cf = in_eth_trans.original_cf_bytes + inv_new_cf; // old + (~new) 
            `uvm_info(get_type_name(), $psprintf("original_cf_bytes= %0h", in_eth_trans.original_cf_bytes),UVM_MEDIUM);
            diff_cf[63:0] = diff_cf[63:0] + diff_cf[64]; // add the cb bit
            
            new_cs = diff_cf[63:48] + diff_cf[47:32] + diff_cf[31:16] + diff_cf[15:0]; 
            new_cs_2[16:0] = new_cs[31:16] + new_cs[15:0]; // cb
            new_cs_2[15:0] = new_cs_2[15:0] + new_cs_2[16]; // redundant: another cb, just in case
           
            if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
               // new_cs + old_cs
               upd_cs = (odd_cf_offset ? {new_cs_2[7:0], new_cs_2[15:8]} : new_cs_2[15:0])
                        + 
                       (odd_cs_offset 
                          ? {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                          : in_eth_trans.original_cs_bytes);
            end else begin
               // 
               `uvm_error(get_type_name(),"ins_cf_w_eb_bytes, skip_crc_insertion not supported");
            end
           
            // add cb
            upd_cs[15:0] = upd_cs[15:0] + upd_cs[16];
           
            `uvm_info(get_type_name(), 
              $sformatf("pyld_size=%0d,odd_cf_cs_offset=%0b_%0b", 
                 pyld_bytes_size, odd_cf_offset, odd_cs_offset), UVM_FULL);
           
            `uvm_info(get_type_name(), 
              $sformatf("UNINVERTED: inv_new_cf=x%0x, diff_cf=x%0x, old_cs=x%0x, new_cs=x%0x, new_cs_2=x%0x, exp_cs=x%0x", 
                 inv_new_cf, diff_cf, in_eth_trans.original_cs_bytes, new_cs[15:0], new_cs_2[15:0], upd_cs[15:0]), UVM_LOW);
           
            // Based on original cs offset position, order the expected new cs bytes
            generate_exp_ptp_fields.cs_bytes[15:8] = 
               odd_cs_offset ? upd_cs[7:0] : upd_cs[15:8];
            generate_exp_ptp_fields.cs_bytes[7:0] = 
               odd_cs_offset ? upd_cs[15:8] : upd_cs[7:0];
         end

         //Duplicate removed
         /*
         INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB: begin
            bit odd_cs_offset, odd_ts_offset, odd_cf_offset;
            int pyld_bytes_size;
            bit [79:0] inv_new_ts_no_fns;
            bit [63:0] inv_new_cf;
            bit [80:0] diff_v2_ts_no_fns;
            // bit [96:0] diff_v2_ts; // extra bit for cb
            bit [64:0] diff_cf;    // extra bit for cb
            bit [31:0] new_cs, new_ts_cs_1, new_cf_cs_1, upd_cs_1; 
            bit [16:0] verify_cs, new_ts_cs_2, new_cf_cs_2, upd_cs_2; // extra bit for cb
            bit [15:0] inv_verify_cs;


          
            if (!in_eth_trans.asym_sign) begin 
               generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes  +  asym_lat  ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
   
            else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = in_eth_trans.original_cf_bytes - asym_lat  ; 
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end

            if (m_ptp_op === INS_ASYM_LAT_CS_0) begin 
               generate_exp_ptp_fields.cs_bytes_are_valid = 1;
               generate_exp_ptp_fields.cs_bytes = 16'h0;
            end

            else if (INS_ASYM_LAT_EB) begin
               generate_exp_ptp_fields.cs_bytes_are_valid = 1;
               pyld_bytes_size = in_eth_trans.payload.size();
               // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
               if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1; 
               else odd_cs_offset = 0; 
               if (in_eth_trans.ptp_offset % 2) odd_ts_offset = 1;
               else odd_ts_offset = 0;
               if (in_eth_trans.cf_offset % 2) odd_cf_offset = 1;
               else odd_cf_offset = 0;

               // Find the diff b/n original ts and expected ts fields
               inv_new_ts_no_fns = ~(generate_exp_ptp_fields.ts_bytes); // 1's compl.
               diff_v2_ts_no_fns = in_eth_trans.original_bytes[79:0] + inv_new_ts_no_fns; // old +(~new)
               diff_v2_ts_no_fns[79:0] = diff_v2_ts_no_fns[79:0] + diff_v2_ts_no_fns[80]; // add cb
   
               new_ts_cs_1 = diff_v2_ts_no_fns[79:64] + diff_v2_ts_no_fns[63:48] + 
                           diff_v2_ts_no_fns[47:32] + diff_v2_ts_no_fns[31:16] + 
                           diff_v2_ts_no_fns[15:0];
               new_ts_cs_2 = new_ts_cs_1[31:16] + new_ts_cs_1[15:0];  // cb
               new_ts_cs_2[15:0] = new_ts_cs_2[15:0] + new_ts_cs_2[16];  // redundant: another cb, just in case.
   
               // Find the  diff b/n original cf and expected cf 
               //inv_new_cf = ~(generate_exp_ptp_fields.cf_bytes); // 1's complement
               //generate_exp_ptp_fields.cf_bytes need to get the actual value from DUT which doesnt lost 8 bit accuracy value
               inv_new_cf = ~(cf_offset_rx_val); // 1's complement
               // old + (~new)
               diff_cf = in_eth_trans.original_cf_bytes + inv_new_cf; 
               diff_cf[63:0] = diff_cf[63:0] + diff_cf[64]; // add the cb bit
   
   
               new_cf_cs_1 = diff_cf[63:48] + diff_cf[47:32] + diff_cf[31:16] + diff_cf[15:0]; 
               new_cf_cs_2 = new_cf_cs_1[31:16] + new_cf_cs_1[15:0];  // cb
               new_cf_cs_2[15:0] = new_cf_cs_2[15:0] + new_cf_cs_2[16]; // redundant: another cb, just in case

           
               if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
               // new_cs + old_cs
               upd_cs_1 = (odd_ts_offset ? {new_ts_cs_2[7:0], new_ts_cs_2[15:8]} : new_ts_cs_2[15:0])
                           +
                           (odd_cf_offset ? {new_cf_cs_2[7:0], new_cf_cs_2[15:8]} : new_cf_cs_2[15:0])
                           +
                           (odd_cs_offset 
                              ? {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                              : in_eth_trans.original_cs_bytes);
               end else begin
                  // 
                  `uvm_error(get_type_name(),"ins_v2_w_eb_bytes, skip_crc_insertion not supported");
               end
           
               upd_cs_2 = upd_cs_1[15:0] + upd_cs_1[31:16]; // cb
               upd_cs_2[15:0] = upd_cs_2[15:0] + upd_cs_2[16]; // redundant: another cb, just in case 
   
               `uvm_info(get_type_name(), 
               $sformatf("pyld_size=%0d,odd_ts_cf_cs_offsets=%0b_%0b_%0b", 
                  pyld_bytes_size, odd_ts_offset, odd_cf_offset, odd_cs_offset), UVM_FULL);
   
               `uvm_info(get_type_name(),
               $sformatf("UNINVERTED: old_cs=x%0x, new_ts_cs_2=x%0x, new_cf_cs_2=x%0x, upd_cs_2=x%0x",
                     in_eth_trans.original_cs_bytes, new_ts_cs_2[15:0], new_cf_cs_2[15:0], upd_cs_2[15:0]), UVM_FULL);
            
               generate_exp_ptp_fields.cs_bytes[15:8] = 
                  odd_cs_offset ? upd_cs_2[7:0] : upd_cs_2[15:8];
               generate_exp_ptp_fields.cs_bytes[7:0] = 
                  odd_cs_offset ? upd_cs_2[15:8] : upd_cs_2[7:0];
      
               `uvm_info(get_type_name(), 
                  $sformatf("diff_v2_ts_no_fns=x%0x, orig_ts_bytes=x%0x, inv_egress_ts=x%0x", 
                     diff_v2_ts_no_fns[79:0], in_eth_trans.original_bytes[79:0], 
                     inv_new_ts_no_fns), UVM_DEBUG);
               `uvm_info(get_type_name(), 
               $sformatf("diff_cf=x%0x, orig_cf_bytes=x%0x, inv_new_cf=x%0x", 
                  diff_cf[63:0], in_eth_trans.original_cf_bytes[63:0], 
                  inv_new_cf), UVM_DEBUG);
            end

         end*/

         INS_P2P_W_ASYM_LAT:  begin

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if(m_ptp_op === INS_P2P_W_ASYM_LAT) begin
            if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  + p2p_lat +  asym_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans) + p2p_lat -  asym_lat ; 
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); 
            end
           
         end
      end

            
         INS_P2P_W_ASYM_LAT_UDP_CS_0:begin

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if(m_ptp_op === INS_P2P_W_ASYM_LAT_UDP_CS_0) begin
               if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans) + p2p_lat +  asym_lat ;
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); end 
               else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans) + p2p_lat -  asym_lat;
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes); end
            end 
            //Set cs_bytes
            generate_exp_ptp_fields.cs_bytes_are_valid = 1;
            generate_exp_ptp_fields.cs_bytes = 16'h0; 

         end


         INS_P2P_W_ASYM_LAT_EB:  begin

            // Set CF and EB fields.
            bit odd_cs_offset, odd_cf_offset;
            int pyld_bytes_size;
            bit [64:0] diff_cf; 
            bit [63:0] inv_new_cf;
            bit [15:0] inv_verify_cs;
            bit [31:0] new_cs;
            bit [16:0] new_cs_2, upd_cs, verify_cs;

            generate_exp_ptp_fields.cf_bytes_are_valid = 1;
            // Set CF field.
            if (m_ptp_op === INS_P2P_W_ASYM_LAT_EB) begin
            if (!in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  + p2p_lat +  asym_lat ; 
               overflow_under_flow_check(1,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes);  
            end else if (in_eth_trans.asym_sign) begin
               generate_exp_ptp_fields.cf_bytes = get_exp_cf_bytes(in_eth_trans, in_ptp_trans)  + p2p_lat -  asym_lat ; 
               overflow_under_flow_check(0,generate_exp_ptp_fields.cf_bytes,in_eth_trans.original_cf_bytes);  
            end
         end 

            // Latency check FIXME RR: how to account for extra_latency 
            //if (m_ptp_op === INS_CF_W_ASYM_LAT_EB) begin 
            //  // Latency check
            //  pass = latency_check(in_ptp_trans, m_nadder_tod_ts, m_ptp_latency_s); 
            //  if (pass) 
            //      `uvm_info(get_type_name(), $sformatf("Extra_latency_check, Passed. ptp_op=%s",
            //          m_ptp_op.name), UVM_FULL)
            //end
   
            // EB bytes calculation
          
            generate_exp_ptp_fields.cs_bytes_are_valid = 1; 
            // 1. determine if the cs_offset location is odd/even
            pyld_bytes_size = in_eth_trans.payload.size();
            // if (pyld_bytes_size - 2 - (in_eth_trans.skip_tx_crc_insertion ? 4 : 0) % 2) begin
            if (in_eth_trans.cs_offset % 2) odd_cs_offset = 1; 
            else odd_cs_offset = 0; 
            if (in_eth_trans.cf_offset % 2) odd_cf_offset = 1;
            else odd_cf_offset = 0;
            // 2. Do the math for CS bytes.
            //    a. Find the diff between new and old CF
            inv_new_cf = ~(cf_offset_rx_val); // 1's complement
            // old + (~new)
            diff_cf = in_eth_trans.original_cf_bytes + inv_new_cf; // old + (~new) 
            diff_cf[63:0] = diff_cf[63:0] + diff_cf[64]; // add the cb bit
            
            new_cs = diff_cf[63:48] + diff_cf[47:32] + diff_cf[31:16] + diff_cf[15:0]; 
            new_cs_2[16:0] = new_cs[31:16] + new_cs[15:0]; // cb
            new_cs_2[15:0] = new_cs_2[15:0] + new_cs_2[16]; // redundant: another cb, just in case
           
            if (!in_eth_trans.skip_tx_crc_insertion) begin // DUT inserts CRC
               // new_cs + old_cs
               upd_cs = (odd_cf_offset ? {new_cs_2[7:0], new_cs_2[15:8]} : new_cs_2[15:0])
                           + 
                        (odd_cs_offset 
                           ? {in_eth_trans.original_cs_bytes[7:0], in_eth_trans.original_cs_bytes[15:8]}
                           : in_eth_trans.original_cs_bytes);
            end
            else begin
               // 
               `uvm_error(get_type_name(),"ins_cf_w_eb_bytes, skip_crc_insertion not supported");
            end
           
            // add cb
            upd_cs[15:0] = upd_cs[15:0] + upd_cs[16];
            
            `uvm_info(get_type_name(), 
               $sformatf("pyld_size=%0d,odd_cf_cs_offset=%0b_%0b", 
                  pyld_bytes_size, odd_cf_offset, odd_cs_offset), UVM_FULL);
            
            `uvm_info(get_type_name(), 
               $sformatf("UNINVERTED: inv_new_cf=x%0x, diff_cf=x%0x, old_cs=x%0x, new_cs=x%0x, new_cs_2=x%0x, exp_cs=x%0x", 
                  inv_new_cf, diff_cf, in_eth_trans.original_cs_bytes, new_cs[15:0], new_cs_2[15:0], upd_cs[15:0]), UVM_FULL);
            
            // Based on original cs offset position, order the expected new cs bytes
            generate_exp_ptp_fields.cs_bytes[15:8] = 
               odd_cs_offset ? upd_cs[7:0] : upd_cs[15:8];
            generate_exp_ptp_fields.cs_bytes[7:0] = 
               odd_cs_offset ? upd_cs[15:8] : upd_cs[7:0];
         end
            
         default: begin
           // For supposedly invalid op-code, set the Frame-fields to zero.
         end
      endcase


      `uvm_info(get_type_name(), $sformatf("expected PTP Fields:: \n %s", generate_exp_ptp_fields.sprint()), UVM_LOW) //FIXME RR lower verbosity after bringup

      return generate_exp_ptp_fields;

   endfunction : generate_exp_ptp_fields



   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description: 
   // 
   //
   // Notes:  
   //
   //--------------------------------------------------------------------------
   virtual function bit [79:0] get_exp_ts_bytes (const ref eth_packet in_eth_trans,
      const ref ptp_tx_tran in_ptp_trans);
      
      bit [47:0] v2_second_part;
      bit [31:0] v1_second_part;
      // 96 bit egress timestamp available from user i/f, treating this as
      // golden for functional checks 
      v2_second_part = in_ptp_trans.o_ptp_ets[95:48];
      v1_second_part = in_ptp_trans.o_ptp_ets[79:48];

      //if (in_eth_trans.insert_v1_timestamp) begin
      case (in_eth_trans.m_ptp_op) 

        INS_V1, INS_V1_W_ASYM_LAT, INS_V1_W_UDP_CS_0, INS_V1_W_ASYM_LAT_UDP_CS_0, INS_V1_W_EB, INS_V1_W_ASYM_LAT_EB: begin
          // 64-bit field
          // upper 16 of upper 48s field ignored, lower 32 of 48s, 32 bits of 32ns 
          get_exp_ts_bytes = {16'h0, v1_second_part, in_ptp_trans.o_ptp_ets[47:16]}; 
      end
 
        INS_V2, INS_V2_W_ASYM_LAT, INS_V2_W_UDP_CS_0, INS_V2_W_ASYM_LAT_UDP_CS_0, INS_V2_W_EB, INS_V2_W_ASYM_LAT_EB: begin
           // 80-bit field.
           // upper 48s field, lower 32ns field
           get_exp_ts_bytes = {v2_second_part, in_ptp_trans.o_ptp_ets[47:16]}; 
      end
        default:begin
           `uvm_error(get_type_name(), $sformatf("get_exp_ts_bytes called with invalid opcode in_eth_trans.m_ptp_op :%s", 
                      in_eth_trans.m_ptp_op));
      end

      endcase 


      `uvm_info(get_type_name(), $sformatf("get_exp_ts_bytes:: x%0x", get_exp_ts_bytes), UVM_DEBUG)

   endfunction : get_exp_ts_bytes

   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description: 
   // 
   //
   // Notes:  
   //
   //--------------------------------------------------------------------------
   virtual function bit [63:0] get_exp_cf_bytes (const ref eth_packet in_eth_trans,
      const ref ptp_tx_tran in_ptp_trans);

      bit [63:0] diff_egr_and_ingr_ts;
      bit [47:0] cf_second_part;

      get_exp_cf_bytes = in_eth_trans.original_cf_bytes;

      //NOTE: The design expects the Egress timestamp to be always greater than the Ingress timestamp..So even if the ns part of ingress is greather than egress.. 
      //      but then the seconds part of egress should be greater than ingress
      //      in_eth_trans.nadder_tod_ts: monitor packs ingress_ts in this
      //      field. In driver, this is driven as get_ingress_timestamp
      //      (nadder_tod

      //diff_egr_and_ingr_ts = (in_ptp_trans.o_ptp_ets[95:0] - in_eth_trans.ingress_ts[95:0]);  

      // This is the case where Egress ns > Ingres Ns
      if(in_ptp_trans.o_ptp_ets[47:0] > in_eth_trans.ingress_ts[47:0]) begin  // Egress > Ingress

        //ns/fns part
        diff_egr_and_ingr_ts[47:0] = in_ptp_trans.o_ptp_ets[47:0] - in_eth_trans.ingress_ts[47:0];
        //Second part
        cf_second_part = in_ptp_trans.o_ptp_ets[95:48] - in_eth_trans.ingress_ts[95:48]; 

        //Adding second part diff after s->ns conversion
        diff_egr_and_ingr_ts[47:16] = diff_egr_and_ingr_ts[47:16] + (cf_second_part * (10**9));
      end
      // This is the case where Ingress ns > Egress Ns
	else begin
	$display("entered the rollover case for o_ptp_ets[47:0]= %0h,ingress_ts[47:0]= %0h & o_ptp_ets[95:48]= %0h,ingress_ts[95:48]= %0h",in_ptp_trans.o_ptp_ets[47:0],in_eth_trans.ingress_ts[47:0],in_ptp_trans.o_ptp_ets[95:48],in_eth_trans.ingress_ts[95:48]);
        //ns/fns part
        diff_egr_and_ingr_ts = BILLION_NS + in_ptp_trans.o_ptp_ets[47:0] - in_eth_trans.ingress_ts[47:0];
        //Second part
        cf_second_part = in_ptp_trans.o_ptp_ets[95:48] - in_eth_trans.ingress_ts[95:48] - 1; 

        //Adding second part diff after s->ns conversion
        diff_egr_and_ingr_ts[47:16] = diff_egr_and_ingr_ts[47:16] + (cf_second_part * (10**9)); 
      end


      // New CF = Old CF + (egr_ts-ingr_ts)
      get_exp_cf_bytes = get_exp_cf_bytes + diff_egr_and_ingr_ts;
      `uvm_info(get_type_name(),$sformatf("orig_cf=x%0x, diff_egr_and_ingr_ts=x%0x, new_cf=x%0x", in_eth_trans.original_cf_bytes, diff_egr_and_ingr_ts, get_exp_cf_bytes), UVM_LOW)
     // if(get_exp_cf_bytes > 'h7fffffffffffffff)
     // begin
     //  get_exp_cf_bytes = 'h7fffffffffffffff;
     //  `uvm_info(get_type_name(),  $sformatf("As exp_cf exceeded the boundary of max limit modified value is max value of cf, new_cf=x%0x", get_exp_cf_bytes), UVM_LOW)
     // end

   endfunction : get_exp_cf_bytes
   
   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description: 
   // 
   //
   // Notes:  
   //
   //--------------------------------------------------------------------------
   virtual function bit [15:0] get_exp_cs_bytes (const ref eth_packet in_eth_trans,
      const ref ptp_tx_tran in_ptp_trans, const ref bit [95:0] m_nadder_tod_ts);

   endfunction : get_exp_cs_bytes

    //To flush frames of received from tx_layering_mon and actual packets
   function flush_frames();
       `uvm_info(get_type_name(), $sformatf("Resetting ptp tx ref model exp_eth_frame_q:%0d  act_eth_frame_q:%0d", exp_eth_frame_q.size(),act_eth_frame_q.size()), UVM_LOW)
   
       exp_eth_frame_q.delete();
       act_eth_frame_q.delete();
     
       `uvm_info(get_type_name(), $sformatf("Resetting ptp tx ref model exp_eth_frame_q:%0d  act_eth_frame_q:%0d", exp_eth_frame_q.size(),act_eth_frame_q.size()), UVM_LOW)
   endfunction

   function reset_model();
       `uvm_info(get_type_name(), $sformatf("Resetting ptp tx ref model i_ptp_tx_fp_q.size:%0d, o_ptp_tx_fp_q.size:%0d, exp_egr_ts_frame_q.size:%0d, i_ptp_tx_vl_q.size:%0d, o_ptp_tx_vl_q.size:%0d, i_ptp_rx_vl_q.size:%0d ", i_ptp_tx_fp_q.size(),o_ptp_tx_fp_q.size(),exp_egr_ts_frame_q.size(),i_ptp_tx_vl_q.size(),o_ptp_tx_vl_q.size(), i_ptp_rx_vl_q.size()), UVM_LOW)
       i_ptp_tx_fp_q.delete();
       o_ptp_tx_fp_q.delete();
       exp_egr_ts_frame_q.delete();
       i_ptp_tx_vl_q.delete();
       o_ptp_tx_vl_q.delete();
       i_ptp_rx_vl_q.delete();
   endfunction

   task p2p_reg_value_queue(input altuvm_avalon_mm_req_base  avmm_mst_pkt);
       logic[23:0] local_p2p_lat;
       logic[23:0] local_addr_offset;

//	`uvm_info(get_type_name(),$sformatf("PTP TX Ref Model: P2P Avalon MMM addr : %0d", avmm_mst_pkt.address), UVM_MEDIUM)
        if(avmm_mst_pkt.address inside {['h5040:'h523c]} && avmm_mst_pkt.transaction ==AVALON_MM_WRITE) begin 
            `uvm_info(get_type_name(),$sformatf("PTP TX Ref Model: P2P Register addr Matched : %0d", avmm_mst_pkt.address), UVM_MEDIUM)
            local_p2p_lat[23:0] = {avmm_mst_pkt.data_bytes[2], avmm_mst_pkt.data_bytes[1], avmm_mst_pkt.data_bytes[0]};
            local_addr_offset = avmm_mst_pkt.address[23:0];
            for (int i = 0; i < 128; i++) begin
                if(local_addr_offset[9:0] == ('h40 + ('h4 * i))) begin
                    global_p2p_lat[i] = local_p2p_lat;
                end
            end
        end
   endtask : p2p_reg_value_queue
   
   task asm_reg_value_queue(input altuvm_avalon_mm_req_base  avmm_mst_pkt);
       logic[23:0] local_asm_lat;
       logic[23:0] local_addr_offset;
       int local_asym_idx;

	//`uvm_info(get_type_name(),$sformatf("PTP TX Ref Model: ASM Avalon MMM addr : %0d", avmm_mst_pkt.address), UVM_MEDIUM)
        if(avmm_mst_pkt.address inside {['h5040:'h523c]} && avmm_mst_pkt.transaction ==AVALON_MM_WRITE) begin 
            `uvm_info(get_type_name(),$sformatf("PTP TX Ref Model: ASM Register addr Matched : %0d", avmm_mst_pkt.address), UVM_MEDIUM)
            local_asm_lat[23:0] = {avmm_mst_pkt.data_bytes[2], avmm_mst_pkt.data_bytes[1], avmm_mst_pkt.data_bytes[0]};
           // `uvm_info(get_type_name(),$sformatf("PTP TX Ref Model: ASM Register write  : %h", local_asm_lat), UVM_MEDIUM)
           // `uvm_info(get_type_name(),$sformatf("PTP TX Ref Model: ASM Register write data local_asm_lat : %h", local_asm_lat), UVM_MEDIUM)
            local_addr_offset = avmm_mst_pkt.address[23:0];
            for (int i = 0; i < 128; i++) begin
                if(local_addr_offset[9:0] == ('h40 + ('h4 * i))) begin
                    global_asm_lat[i] = local_asm_lat;
                end
            end
        end
   endtask : asm_reg_value_queue
   //--------------------------------------------------------------------------
   // Input:
   // Output:
   // Description: Latency compare: 
   // Determine the difference between egress TS and nadder TOD(at sop-at-mii)
   // If both are euqal, latency is NOT accounted for.
   // if egress ts == nadder TOD + latency, Pass.
   //
   // Notes:  
   // Guaranteed to work for EHIP_MAC_LB only.
   //--------------------------------------------------------------------------
//   virtual function bit latency_check ( const ref ptp_tx_tran in_ptp_trans, 
//      const ref bit [95:0] m_nadder_tod_ts, ptp_latency_s m_ptp_latency_s);
//      // bit [31:0] extra_latency, bit [19:0] clk_period, bit [31:0] tolerance_ns);
//
//      bit [31:0] diff_offset_ns;
//
//      if(disable_latency_check ==0) begin
//        if (in_ptp_trans.ptp_tx_ts[47:16] == (m_nadder_tod_ts[47:16] + m_ptp_latency_s.ptp_tx_extra_latency[31:16]))
//        begin
//           `uvm_info(get_type_name(), $sformatf("EXTRA_LATENCY_CHECK: Passed. \
//              nadder_tod_no_fns=x%0x, nadder_tod_96b=x%0x, \
//              egress_ts_no_fns=x%0x, extra_latency_ns_fns=x%0x_%0x", 
//              m_nadder_tod_ts[47:16], m_nadder_tod_ts, in_ptp_trans.ptp_tx_ts[47:16], 
//              m_ptp_latency_s.ptp_tx_extra_latency[31:16], 
//              m_ptp_latency_s.ptp_tx_extra_latency[15:0]), UVM_FULL)
//        end
//        else begin : LAT_NOT_EQUAL
//           case(in_ptp_trans.ptp_tx_ts[47:16] < m_nadder_tod_ts[47:16])
//              0: begin // egress ts is greater.
//                 diff_offset_ns = in_ptp_trans.ptp_tx_ts[47:16] - m_nadder_tod_ts[47:16];
//              end
//              1: begin // egress ts is less
//                 diff_offset_ns = m_nadder_tod_ts[47:16] - in_ptp_trans.ptp_tx_ts[47:16];
//              end
//           endcase
//           // units of ns.  Revisit: Ignoring fns, for now.
//           if (diff_offset_ns > m_ptp_latency_s.ptp_tx_clk_period[19:16]) begin
//              // convert to ns 
//              // Assumption: tolerance_value is units of clocks!
//              if (diff_offset_ns <= m_ptp_latency_s.tolerance_ns + m_ptp_latency_s.ptp_tx_extra_latency[31:16])
//                 `uvm_info(get_type_name(), 
//                    $sformatf("EXTRA_LATENCY_CHECK:ToleranceRange:PASSED."), UVM_FULL)
//           end 
//           else begin 
//           // Ignore for now, this value would be <= clk_period.
//           end
//        end : LAT_NOT_EQUAL
//      end
//
//      `uvm_info(get_type_name(), 
//         $sformatf("EXTRA_LATENCY_CHECK:Details:\n\
//         diff_offset_ns=%0d, tolerance_ns=%0d,\
//         nadder_tod_no_fns=x%0x, nadder_tod_96b=x%0x,\
//         egress_ts_no_fns=x%0x, extra_latency=x%0x_%0x", 
//         diff_offset_ns, m_ptp_latency_s.tolerance_ns, 
//         m_nadder_tod_ts[47:16], m_nadder_tod_ts, 
//         in_ptp_trans.ptp_tx_ts[47:16], 
//         m_ptp_latency_s.ptp_tx_extra_latency[31:16], 
//         m_ptp_latency_s.ptp_tx_extra_latency[15:0]), UVM_DEBUG)
//
//   endfunction : latency_check



   //--------------------------------------------------------------------------
   //
   // Function: convert2string
   //
   // This function is called by do_print sprint method and is a way to convert
   // objects into string representation.
   //
   function string convert2string();
      return sprint();
   endfunction : convert2string

  
endclass : ptp_tx_ref_model

`endif//__PTP_TX_REF_MODEL_SVH__
