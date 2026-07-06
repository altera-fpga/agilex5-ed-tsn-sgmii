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


class eth_xcvr_register_access_sequence extends eth_base_sequence;
 
    bit [31:0] addr;
    bit [31:0] data;
    int i;

	  `uvm_object_utils(eth_xcvr_register_access_sequence)

  function new(string name = "eth_xcvr_register_access_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body(); begin
    
     `uvm_info("eth_xcvr_register_access_sequence", "Starting XCVR register Access", UVM_NONE)

	 for(i=0;i<=256;i++)begin
		 addr=i;
	   p_sequencer.env.gdr_ral_read_ux(addr,data);
     end
  	   p_sequencer.env.gdr_ral_write_ux(32'h0,32'hFFFF);
       p_sequencer.env.gdr_ral_read_ux(32'h0,data,0,'hFF);

end
endtask
endclass
