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


class eth_ref_clk_code_coverage extends eth_base_sequence;
 
  bit neg_edge;
  `uvm_object_utils(eth_ref_clk_code_coverage)
   
  function new(string name = "eth_ref_clk_code_coverage");
    super.new(name);
  	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    `uvm_info("eth_ref_clk_code_coverage", "running eth_ref_clk_code_coverage sequence\n",UVM_LOW)
   p_sequencer.env.apply_reset("hard",0,0,1,11);
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   neg_edge = $urandom();
  
   fork
   begin
     //turning off clk_pll_div assertions 
     uvm_hdl_force("eth_env_top.assertion_on_off_reset",'b1);

     //Disabling RX VIP checker
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b101);
  
     // turning off ref_clk for 2000 ref_clk cycles
     if(neg_edge) begin
       @(negedge p_sequencer.env.spy_if.clk)
       uvm_hdl_force("eth_env_top.dut.i_clk_ref",'b0);
       #12.8us; //2000 ref_clk cycles
       uvm_hdl_release("eth_env_top.dut.i_clk_ref");
     end else begin
       @(posedge p_sequencer.env.spy_if.clk)
       uvm_hdl_force("eth_env_top.dut.i_clk_ref",'b1);
       #12.8us; //2000 ref_clk cycles
       uvm_hdl_release("eth_env_top.dut.i_clk_ref");
     end
   end
   begin
      wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==0);
   end
   join

   //turning on clk_pll_div assertions 
   uvm_hdl_release("eth_env_top.assertion_on_off_reset");

   //Enabling RX VIP checker
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);

   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   fork
     send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
     send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
   join
  endtask
endclass
