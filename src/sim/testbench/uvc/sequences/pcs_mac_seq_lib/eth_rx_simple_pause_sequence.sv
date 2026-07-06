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


class eth_rx_simple_pause_sequence extends svt_ethernet_transaction_base_sequence; 

   int unsigned sequence_length = 1;
   /** UVM object utility macro */
   `uvm_object_utils(eth_rx_simple_pause_sequence)
     
     /** Class constructor */
     function new (string name = "eth_rx_simple_pause_sequence",int sequence_length=1);
      	super.new(name);
	this.sequence_length = sequence_length;
     endfunction : new

   /** Raise an objection if this is the parent sequence */
   virtual task pre_body();
      uvm_phase phase;
      super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
      phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
      if (phase!=null) begin
	 phase.raise_objection(this);
      end
   endtask: pre_body
   
   /** Drop an objection if this is the parent sequence */
   virtual task post_body();
      uvm_phase phase;
      super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
      phase = get_starting_phase();
`else
      phase = starting_phase;
`endif
      if (phase!=null) begin
	 phase.drop_objection(this);
      end
   endtask: post_body
 
   virtual task body();
      bit status;
      
      `svt_xvm_note("body", "Entered ...");
      super.body();
      
      `svt_xvm_create (req) 

	req.reasonable_mac_ctrl_parameter.constraint_mode(0);
	repeat(sequence_length) begin
	   `svt_xvm_rand_send_with(req, {
	   req.byte_count          == byte_count; 
	   req.mac_inter_frame_gap == 12;
	   req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME;
	   req.mac_ctrl_parameter == 16'hffff;
					 })
	     end
      `svt_xvm_note("body" ," Exited ...");
    
   endtask: body
endclass // eth_rx_simple_pause_sequence
