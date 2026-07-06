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


class eth_soft_reset_during_master_read_register_directed_sequence extends eth_base_sequence;
   uvm_reg_data_t read_data;
   int rand_delay;

   `uvm_object_utils(eth_soft_reset_during_master_read_register_directed_sequence)

     function new(string name = "eth_soft_reset_during_master_read_register_directed_sequence");
	super.new(name);
   `ifdef UVM_POST_VERSION_1_1
	set_automatic_phase_objection(1);
   `endif
     endfunction:new

   virtual task body();

      //disabling register coverage
      //p_sequencer.env.reg_cov.dis_reg_cov=1;
      dis_stats_chk=1;
      p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
      rand_delay = $urandom_range(1,10);
      fork
	 begin
            p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	 end
	 begin
            //FIXME - GDR master_read unavailable in spy_if
            //wait(p_sequencer.env.spy_if.master_read==1);
	    repeat(rand_delay) @(p_sequencer.env.spy_if.clk);
            p_sequencer.env.apply_reset(.rst_type("soft"),.ip_rst(1));
	 end
      join_any
      disable fork;
   `ifdef CRETE3
      //reset_spico();
   `endif
      p_sequencer.env.reconfig_vip_for_an_mode();
      fork
	 begin
   `ifdef CRETE3
	    //reset_spico();
   `endif
	 end
	 begin
            p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	 end
      join

   `ifdef ENABLE_ETH_VIP
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
      join
   `endif
      
   endtask//body
endclass//eth_soft_reset_during_master_read_register_directed_sequence
