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


class vip_sanity_sequence extends eth_base_sequence;
  
  uvm_reg_data_t read_data;
  
  `uvm_object_utils(vip_sanity_sequence)
  
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
   //p_sequencer.env.apply_reset("hard",0,0,1,11);
   //`ifdef ANLT
   // p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   //`endif
   `uvm_info("body", "waitin for ehip ready ...", UVM_MEDIUM)
   wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
   //`ifdef CRETE3
 
     `uvm_info("body", "Done ehip ready ...", UVM_MEDIUM)
//FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`RSFEC_CFGCSR_CSR_rsfec_top_clk_cfg_OFFSET_REG,read_data);
//FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`RSFEC_CFGCSR_CSR_rsfec_top_clk_cfg_OFFSET_REG,'h123);
   
   p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_corr_1s_cnt_lo"),read_data);
   p_sequencer.env.reg_write(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s3_rsfec_corr_1s_cnt_lo"),'h123);
   #50ns;
   //`endif 
 endtask
endclass
