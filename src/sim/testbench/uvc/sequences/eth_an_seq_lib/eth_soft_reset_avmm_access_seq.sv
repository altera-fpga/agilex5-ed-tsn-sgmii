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


class eth_soft_reset_avmm_access_seq extends an_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
  uvm_reg_data_t read_data;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(eth_soft_reset_avmm_access_seq)
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
  	string func_name = "eth_soft_reset_avmm_access_seq";
    `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
   rx_crc_pass=$urandom;
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   fork
   	begin
   		forever begin 
	   		randcase 
	   		1:p_sequencer.env.reg_write($urandom_range(1024,1298),$urandom()); //'h400 to 'h512 is MAC address range, so as ato make sure that ehip avmm is being accessed.
	   		1:p_sequencer.env.reg_read($urandom_range(1024,1298),read_data,1); 
	   		endcase
	   	end
   	end
   	begin
                p_sequencer.env.apply_reset(.rst_type("soft"),.ip_rst(1));
   	end
   	begin
   		#100us; // time given to check if ehip avmm hangs 
   		disable fork;
   	end
   join
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
  endtask
endclass:eth_soft_reset_avmm_access_seq
