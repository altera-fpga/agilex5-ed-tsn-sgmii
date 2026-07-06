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


class alt_eth_vip_custom_sequence extends uvm_sequence #(svt_ethernet_transaction); 

  int payload_length;

   /** UVM object utility macro */
   `uvm_object_utils(alt_eth_vip_custom_sequence)

   /** Class constructor */
   function new (string name = "alt_eth_vip_custom_sequence",int sequence_length=1);
     super.new(name);
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
    `uvm_info("body", $sformatf("Calling alt_eth_vip_custom_sequence byte count %0d", payload_length), UVM_LOW)
    `uvm_create(req)
    req.reasonable_command_type.constraint_mode(0);
    req.reasonable_byte_count.constraint_mode(0);
    //if(payload_length < 'h600)
    if(payload_length > 'h600)
    begin
      if(payload_length > 'hFFFF) begin
        req.reasonable_length_type.constraint_mode(0);
      end
      `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count == payload_length;})
    end
    else
    begin
      `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME}; byte_count == payload_length;})
    end

   
  endtask: body
endclass
