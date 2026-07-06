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


class eth_vip_preset_cmd_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit cmd_status;
  `uvm_object_utils(eth_vip_preset_cmd_sequence)

  function new(string name = "eth_vip_preset_cmd_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new


  virtual task body();
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
   
   //DUT specific 
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));

   //DUT specific 
   prbs_select();
   LT_en = 1;
   AN_en = 0;//$urandom_range(0,1);
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

   p_sequencer.env.reconfig_vip_for_lt_mode();
 
   //DUT specific 
   wait(p_sequencer.env.spy_if.lt_training == 'hF);
   
  // cmd_status= 1;
  // fork :preset_1
  // begin
  // while (cmd_status) begin 
  //   send_lt_command_from_vip(PRESET,'h1,0,0,0); 
  //    if(cmd_status ==1'b0) break;
  // end
  // end
  // join_none
   send_lt_command_from_vip(PRESET,'h1,0,0,0); 
   wait(p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_status_update_neg_lane0 == svt_ethernet_status::STATUS_CHANGED_ON_PRESET);
   wait(p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_status_update_pos_lane0 == svt_ethernet_status::STATUS_CHANGED_ON_PRESET);
   wait(p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.status_rx.autoadaptation_status_update_zero_lane0 == svt_ethernet_status::STATUS_CHANGED_ON_PRESET)
   //cmd_status = 0;
   //disable preset_1;

   #1us;
 end
   endtask
endclass
