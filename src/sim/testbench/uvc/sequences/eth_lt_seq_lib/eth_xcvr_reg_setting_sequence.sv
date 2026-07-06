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


class eth_xcvr_reg_setting_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit cmd_status;
  uvm_reg_data_t xcvr_read_data[4];
  bit [3:0] lane_select;
  `uvm_object_utils(eth_xcvr_reg_setting_sequence)


  function new(string name = "eth_xcvr_reg_setting_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
   bringup_status_read();
   prbs_select();

   LT_en = 1;
   AN_en = 0;//$urandom_range(0,1);
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,($urandom & 'h0000_7007));
   #1us; 
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   `uvm_info(get_name(), $sformatf("******* ERROR INJECTION ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

   co_eff_predict(DEFAULT,'hF,HOLD,HOLD,HOLD);
   read_xcvr_reg();
   wait_for_an_vip_event(AN_en);

   p_sequencer.env.reconfig_vip_for_lt_mode();
   wait(p_sequencer.env.spy_if.lt_training == 'hF);
   
   #1us; 

   co_eff_predict(INITIALIZE,'hF,HOLD,HOLD,HOLD); 
   read_xcvr_reg();

   lane_select = $urandom_range(1,'hF);
   `uvm_info(get_name(), $sformatf("lane_select                   :%0h ",lane_select), UVM_NONE);
   send_lt_command_from_vip(PRESET,lane_select,HOLD,HOLD,HOLD); 
   preset_complete_wait(lane_select);
   read_xcvr_reg();

   for(int j=0;j<16;j++) begin
   `uvm_info(get_name(), $sformatf("CO_EFF_ZERO                   :%0d ",j), UVM_NONE);
   send_lt_command_from_vip(CO_EFF_ZERO,lane_select,HOLD,HOLD,DEC); 
   zero_co_eff_status_update_wait(lane_select,DEC);
   #300ns; //RTL takes some time to update co-effcient because of internal latency
   read_xcvr_reg();
   end

   for(int k=0;k<13;k++) begin
   `uvm_info(get_name(), $sformatf("CO_EFF_POS                   :%0d ",k), UVM_NONE);
   send_lt_command_from_vip(CO_EFF_POS,lane_select,DEC,HOLD,HOLD); 
   post_co_eff_status_update_wait(lane_select,DEC);
   read_xcvr_reg();
   #3us;
   end
   
   for(int k=0;k<4;k++) begin
   `uvm_info(get_name(), $sformatf("CO_EFF_POS                   :%0d ",k), UVM_NONE);
   send_lt_command_from_vip(CO_EFF_NEG,lane_select,HOLD,DEC,HOLD); 
   pre_co_eff_status_update_wait(lane_select,DEC);
   read_xcvr_reg();
   end
   
   wait_for_lt_vip_event();
   read_xcvr_reg();
 end

   endtask
endclass
