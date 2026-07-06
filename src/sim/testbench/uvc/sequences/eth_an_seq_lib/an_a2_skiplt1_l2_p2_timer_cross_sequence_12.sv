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


class an_a2_skiplt1_l2_p2_timer_cross_sequence_12 extends an_timer_cross_base_sequence;
   `uvm_object_utils(an_a2_skiplt1_l2_p2_timer_cross_sequence_12)
      
   function new(string name = "an_a2_skiplt1_l2_p2_timer_cross_sequence_12");
      super.new(name);
`ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
`endif
   endfunction:new
   
  `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      lt_on=$urandom_range(0,1);
      super.pre_start();
   endtask:pre_start
  `endif
   
   virtual task set_timer_disable();
      super.set_timer_disable();
      // Link Failure response - PCS mode
      skip_lt_an_timeout=1;
      lf_res=0;
      lf_hiber = $urandom_range(0,1);
   endtask:set_timer_disable
   
   virtual task set_anlt_pcs_setting();
      an_setting = 2; // 1=>good, 2=>don't start 3=>don't finish
      lt_setting = 2; // 1=>good, 2=>don't fin
      if(p_sequencer.top_env.kr_cfg_inst.is_speed_100g) begin
      pcs_setting = $urandom_range(2,3); // 1=>good, 2=>hiber/am loss, 2=>am loss
      repeat_count = 10;
      end
     else if(p_sequencer.top_env.kr_cfg_inst.is_speed_25g)begin
      pcs_setting = 2;
      repeat_count = 10;
     end
     else begin
      pcs_setting = 2;
      repeat_count = 10;
    end
      last_iteration_good=1; // At last iteration, if dis_mwt_timer=0, let all end correctly
   endtask:set_anlt_pcs_setting
   
endclass:an_a2_skiplt1_l2_p2_timer_cross_sequence_12
