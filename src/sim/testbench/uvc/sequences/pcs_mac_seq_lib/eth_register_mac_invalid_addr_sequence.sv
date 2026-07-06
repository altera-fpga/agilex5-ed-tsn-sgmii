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



class  eth_register_mac_invalid_addr_sequence extends eth_base_sequence;
    

   //int i; 
    bit [31:0] addr;
    uvm_reg_data_t data;
    int i;


    `uvm_object_utils( eth_register_mac_invalid_addr_sequence)
    function new(string name=" eth_register_mac_invalid_addr_sequence");
	  super.new(name);
	 endfunction

   

 virtual task body(); begin     

for(i=0;i<=1138;i++)begin
	addr=i;
	if( addr inside {['h0:'hf],['h12:'h1d],['h60:'h6f],['h71:'h9f],['h406:'h411],['h413:'h41f]})
	begin
	  	
    `uvm_info("eth_invalid_register_access_sequence", "Performing default_read...", UVM_LOW)
 	  p_sequencer.env.reg_read(addr, data);
      p_sequencer.env.reg_write(addr,'h1);
    end
end

  				
end
endtask
    
endclass


