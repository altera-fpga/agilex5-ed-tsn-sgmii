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


//
// Template for UVM-compliant generic slave agent component
//

`ifndef RESET_AGENT__SV
`define RESET_AGENT__SV

class reset_agent extends uvm_agent;
   reset_drv slv_drv;
   reset_mon slv_mon;
   reset_seqr slv_seqr;

   `uvm_component_utils_begin(reset_agent)
   `uvm_component_utils_end


   function new(string name = "slv_agt", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
         slv_mon = reset_mon::type_id::create("mon", this);
         slv_drv = reset_drv::type_id::create("drv", this);
         slv_seqr = reset_seqr::type_id::create("slv_seqr",this);
   endfunction: build_phase

   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
       slv_drv.seq_item_port.connect(slv_seqr.seq_item_export);
   endfunction

   virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
   endfunction

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
   endtask

   virtual function void report_phase(uvm_phase phase);
      super.report_phase(phase);
   endfunction

endclass: reset_agent

`endif // RESET_AGENT__SV
