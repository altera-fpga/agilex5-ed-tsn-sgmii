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


class eth_ip_sloop_sequence extends eth_base_sequence;
  uvm_event_pool event_pool;
  uvm_event sloop_trigger_event;
  
  `uvm_object_utils(eth_ip_sloop_sequence)
  
  function new(string name = "eth_ip_sloop_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    event_pool = new();
    event_pool = event_pool.get_global_pool();
    sloop_trigger_event = event_pool.get("sloop_trigger_event");

    //disabling register coverage
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage
    p_sequencer.env.apply_reset("hard",0,0,1,11);
    `uvm_info("eth_ip_sloop_sequence", "Executing eth_ip_sloop_sequence ...", UVM_NONE)
    //#1us;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_phy_pma_sloop_OFFSET_REG,'hF);
    `uvm_info("eth_ip_sloop_sequence", "SLOOP = 'hF", UVM_NONE)
    
    sloop_trigger_event.trigger();
    `uvm_info("eth_ip_sloop_sequence", "trigger event", UVM_NONE)

    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    `uvm_info("eth_ip_sloop_sequence", "PCS ready now ", UVM_NONE)
    
    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,20);
    `uvm_info("eth_ip_sloop_sequence", "Send Ethernet Frame", UVM_NONE)
    #5us;

// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_phy_pma_sloop_OFFSET_REG,'h0);
    `uvm_info("eth_ip_sloop_sequence", "SLOOP = 'h0", UVM_NONE)
  endtask
endclass:eth_ip_sloop_sequence
