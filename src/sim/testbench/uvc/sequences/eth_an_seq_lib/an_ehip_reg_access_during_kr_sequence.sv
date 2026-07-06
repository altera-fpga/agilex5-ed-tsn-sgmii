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


class an_ehip_reg_access_during_kr_sequence extends an_base_sequence;
   `uvm_object_utils(an_ehip_reg_access_during_kr_sequence)
     function new(string name = "an_ehip_reg_access_during_kr_sequence");
	super.new(name);
   `ifdef UVM_POST_VERSION_1_1
	set_automatic_phase_objection(1);
   `endif
     endfunction:new
   
   `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      lt_on=1;
      super.pre_start();
   endtask; // pre_start
 `endif
   
   virtual task body();
      string func_name = "an_ehip_reg_access_during_kr_sequence_body";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
      //FIXME -GDR tasks are not availabe in testsuiteintf
      //p_sequencer.env.ts_tasks_if.set_enable_a_waitrequest_timeout(0);
      //p_sequencer.env.ts_tasks_if.set_enable_a_read_response_sequence(0);
      p_sequencer.env.avmm_agt_cfg.set_command_timeout(0);
      //p_sequencer.env.ts_tasks_if.set_command_timeout(999999999999);
      
	fork
	   begin
              p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
	   end // UNMATCHED !!
	   begin
	      wait (p_sequencer.env.spy_if.seq_mode=='h02);
	   end
	join
      
 `ifdef ENABLE_ETH_VIP
      fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
      join
 `endif
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
	endtask
endclass // an_ehip_reg_access_during_kr_sequence
