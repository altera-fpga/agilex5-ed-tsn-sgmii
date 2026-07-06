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


class an_a1_l1_p4_timer_cross_sequence_18 extends an_timer_cross_base_sequence;
   `uvm_object_utils(an_a1_l1_p4_timer_cross_sequence_18)
      
   function new(string name = "an_a1_l1_p4_timer_cross_sequence_18");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      randcase
	1: begin
	   an_on=0;
	   lt_on=1;
	end
	1: begin
	   an_on=1;
	   lt_on=0;
	end
	1: begin
	   an_on=1;
	   lt_on=1;
	end
      endcase
      super.pre_start();
   endtask:pre_start
  `endif
   
   virtual task set_anlt_pcs_setting();
      an_setting = 1; // 1=>good, 2=>don't start 3=>don't finish
      lt_setting = 1; // 1=>good, 2=>don't fin
      pcs_setting = 4; // 1=>good, 2=>hiber/am loss, 2=>am loss
      repeat_count = 10;
      max_an_restarts=3;
   endtask:set_anlt_pcs_setting
   
endclass:an_a1_l1_p4_timer_cross_sequence_18
