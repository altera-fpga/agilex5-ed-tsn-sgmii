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



class eth_fc_agt extends uvm_agent;
   // ToDo: add uvm agent properties here
   protected uvm_active_passive_enum is_active = UVM_ACTIVE;
   eth_fc_sqr flow_sqr;
   eth_fc_drv flow_drv;
   eth_fc_mon flow_mon;
   typedef virtual eth_fc_interface vif;
   vif flow_agt_if; 

   `uvm_component_utils_begin(eth_fc_agt)
	`uvm_component_utils_end

   function new(string name = "flow_agt", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      flow_mon = eth_fc_mon::type_id::create("flow_mon", this);
      if (is_active == UVM_ACTIVE) begin
         flow_sqr = eth_fc_sqr::type_id::create("flow_sqr", this);
         flow_drv = eth_fc_drv::type_id::create("flow_drv", this);
      end
      if (!uvm_config_db#(vif)::get(this, "", "mst_if", flow_agt_if)) begin
         `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance")
      end
      uvm_config_db# (vif)::set(this,"flow_drv","mst_if",flow_drv.drv_if);
      uvm_config_db# (vif)::set(this,"flow_mon","status_if",flow_mon.mon_if);
   endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (is_active == UVM_ACTIVE) flow_drv.seq_item_port.connect(flow_sqr.seq_item_export);
   endfunction

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
   endtask

   virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);
   endfunction

endclass: eth_fc_agt

