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


class eth_reset_code_coverage_for_txrx_ch_rst_inst extends eth_base_sequence;
  `uvm_object_utils(eth_reset_code_coverage_for_txrx_ch_rst_inst)
  int loop_cnt;
  bit[1:0] rst;
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    `uvm_info("body", "started eth_reset_code_coverage_for_txrx_ch_rst_inst ...", UVM_NONE)
   p_sequencer.env.apply_reset("hard",0,0,1,11);
   loop_cnt = $urandom_range(5,10);
   //For RX eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.rx_ch_rst_inst 
   for(int i = 0;i < loop_cnt;i++)
   begin
     `uvm_info("For RX", $psprintf("count=%0d, loop_cnt=%0d",i,loop_cnt), UVM_NONE)
     rst=$urandom_range(1,3);
     repeat($urandom_range(10,500)) @(posedge p_sequencer.env.reset_if.clock);
     p_sequencer.env.apply_reset("hard",0,rst[1],rst[0],$urandom_range(10,50));
   end
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

   `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
   `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
   `endif
    #2000ns;

   p_sequencer.env.apply_reset("hard",0,0,1,11);
   loop_cnt = $urandom_range(5,10);
   //For TX eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.tx_ch_rst_inst 
   for(int i = 0;i < loop_cnt;i++)
   begin
     `uvm_info("For TX", $psprintf("count=%0d, loop_cnt=%0d",i,loop_cnt), UVM_NONE)
     rst=$urandom_range(1,3);
     repeat($urandom_range(10,500)) @(posedge p_sequencer.env.reset_if.clock);
     p_sequencer.env.apply_reset("hard",rst[1],0,rst[0],$urandom_range(10,50));
   end
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

   `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
   `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
   `endif
    #2000ns;

    `uvm_info("body", "ended eth_reset_code_coverage_for_txrx_ch_rst_inst ...", UVM_NONE)
  endtask
endclass : eth_reset_code_coverage_for_txrx_ch_rst_inst
