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


class eth_rsfec_reg_soft_reset_sequence extends eth_base_sequence;
   
  `uvm_object_utils(eth_rsfec_reg_soft_reset_sequence)

  function new(string name = "eth_rsfec_reg_soft_reset_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

   virtual task body();
      p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
      p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
// FIXME-MISSING_REG_IN_GDR      p_sequencer.env.reg_write(`RSFEC_CFGCSR_CSR_rsfec_top_rx_cfg_OFFSET_REG,32'haaaa);
      #5us;
      p_sequencer.env.apply_reset(.rst_type("soft"),.ip_rst(1));
      #5us;
      wait (p_sequencer.env.master_agent.mast_agt_if.ehip_ready);
// FIXME-MISSING_REG_IN_GDR      p_sequencer.env.reg_read(`RSFEC_CFGCSR_CSR_rsfec_top_rx_cfg_OFFSET_REG,read_data);
  endtask // body
endclass
