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


class env extends uvm_env; 

`uvm_component_utils(env) 
reset_agent ag1; 

function new(string name, uvm_component parent); 
super.new(name, parent); 
endfunction 

function void build(); 
uvm_report_info(get_full_name(),"Build", UVM_LOW); 
ag1 = reset_agent::type_id::create("reset_agent",this); 
endfunction 

function void connect(); 
uvm_report_info(get_full_name(),"Connect", UVM_LOW); 
endfunction 

function void end_of_elaboration(); 
uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW); 
endfunction 

function void start_of_simulation(); 
uvm_report_info(get_full_name(),"Start_of_simulation", UVM_LOW); 
endfunction 

task run(); 
uvm_report_info(get_full_name(),"Run", UVM_LOW); 
endtask 

function void extract(); 
uvm_report_info(get_full_name(),"Extract", UVM_LOW); 
endfunction 

function void check(); 
uvm_report_info(get_full_name(),"Check", UVM_LOW); 
endfunction 

function void report(); 
uvm_report_info(get_full_name(),"Report", UVM_LOW); 
endfunction 

endclass 

class test1 extends uvm_test; 

`uvm_component_utils(test1) 
env t_env; 
reset_sequence seq;
function new (string name="test1", uvm_component parent=null); 
super.new (name, parent); 
seq = reset_sequence::type_id::create("reset_sequence",this); 
t_env = env::type_id::create("env",this); 
endfunction : new 

function void end_of_elaboration(); 
uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW); 
print(); 
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);

uvm_report_info(get_full_name(),"sequence run phase ", UVM_LOW);

      uvm_test_done.raise_objection(this);
      seq.start(t_env.ag1.slv_seqr);
      uvm_test_done.drop_objection(this);

endtask : run_phase

endclass 
