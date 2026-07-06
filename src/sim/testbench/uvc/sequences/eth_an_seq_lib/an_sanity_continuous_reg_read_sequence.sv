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


class an_sanity_continuous_reg_read_sequence extends an_base_sequence;
   `uvm_object_utils(an_sanity_continuous_reg_read_sequence)
   function new(string name = "an_sanity_continuous_reg_read_sequence");
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
      string func_name = "an_sanity_continuous_reg_read_sequence_body";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
      fork
	 begin
            p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
  `ifdef ENABLE_ETH_VIP
	    fork
               send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);  
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
	    join
	 end // UNMATCHED !!
	 begin
	    #500us;
	    forever begin
// FIXME-MISSING_REG_IN_GDR	       p_sequencer.env.reg_read(`REGISTERS_lt_status1_OFFSET_REG,read_data,.disable_check(1'b1));
	       randcase
		 1: #100ns;
		 1: #200ns;
		 1: #50ns;
		 1: #10ns;
	       endcase	  
	    end    
	 end
      join_any
`endif
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
  endtask
endclass // an_sanity_continuous_reg_read_sequence
