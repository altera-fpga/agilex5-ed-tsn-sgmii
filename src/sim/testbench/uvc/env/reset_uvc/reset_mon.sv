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


`ifndef RESET_MON__SV
`define RESET_MON__SV

typedef class reset_transaction;
typedef class reset_mon;


class reset_mon extends uvm_monitor;
   reset_transaction tr;
   uvm_analysis_port #(reset_transaction) mon_analysis_port;  
   typedef virtual reset_if v_if;
   v_if mon_if;

   extern function new(string name = "reset_mon",uvm_component parent);
  
  `uvm_component_utils_begin(reset_mon)
   `uvm_component_utils_end


   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern protected virtual task detect(reset_transaction tr);

endclass: reset_mon


function reset_mon::new(string name = "reset_mon",uvm_component parent);
   super.new(name, parent);
   mon_analysis_port = new ("mon_analysis_port",this);
endfunction: new

function void reset_mon::build_phase(uvm_phase phase);
   super.build_phase(phase);
endfunction: build_phase

function void reset_mon::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "slv_if", mon_if);
endfunction: connect_phase

function void reset_mon::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase); 
  if (mon_if == null) `uvm_fatal("CFGERR", "Interface for reset monitor not set");
endfunction: end_of_elaboration_phase


function void reset_mon::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
endfunction: start_of_simulation_phase

task reset_mon::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
endtask: reset_phase

task reset_mon::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
endtask:configure_phase

task reset_mon::run_phase(uvm_phase phase);
   super.run_phase(phase);
   `uvm_info("reset_MONITOR", "Starting Monitor...",UVM_NONE)
   tr = reset_transaction::type_id::create("tr", this);
   forever
   begin
     detect(tr);
   end
endtask: run_phase

task reset_mon:: detect(reset_transaction tr);
        `uvm_info("reset_MONITOR", "STARTING TO DETECT RESET...",UVM_DEBUG)
         @(negedge (mon_if.tx_rst_n && mon_if.rx_rst_n && mon_if.csr_rst_n)); 
         tr = reset_transaction::type_id::create("tr", this);

	 if(mon_if.tx_rst_n == 0 ) 
	 begin
	   tr.assert_transmit_reset = 1;
	 end
	 
	 if(mon_if.rx_rst_n == 0 )
	 begin
	   tr.assert_receiver_reset = 1;
	 end

	 if(mon_if.csr_rst_n == 0 )
	 begin
	   tr.assert_ip_reset     = 1;
	 end
         `uvm_info("reset_MONITOR", $sformatf("\n %0s",tr.sprint()), UVM_DEBUG);
          mon_analysis_port.write(tr);
endtask: detect

`endif // RESET_MON__SV
