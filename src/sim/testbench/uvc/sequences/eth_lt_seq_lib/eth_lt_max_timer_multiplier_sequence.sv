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


class eth_lt_max_timer_multiplier_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit disable_max_timer;
  bit [4:0] mwt_multiplier;
  bit lt_failure_response; 
  time training_start_time[4];
  time training_fail_time[4];

  `uvm_object_utils(eth_lt_max_timer_multiplier_sequence)

  function new(string name = "eth_lt_max_timer_multiplier_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
  if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));

   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
   p_sequencer.env.mac_callback.lane_select = $urandom_range(1,'hF);
   p_sequencer.env.mac_callback.local_status_reg[15] = 0 ;
   bringup_status_read();

   prbs_select();

   LT_en = 1;
   AN_en = $urandom_range(0,1);
   disable_max_timer = 0;
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
   read_data[1] = disable_max_timer;
   `uvm_info(get_name(), $sformatf("Disable max wait timer                                                     :%0d ",read_data[1]), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);



// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_params_OFFSET_REG,read_data);
   mwt_multiplier  = $urandom_range(0,31);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_params_OFFSET_REG,{read_data[31:5],mwt_multiplier});
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_params_OFFSET_REG,read_data);

   case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR     'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR     'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR     'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR     'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
   endcase

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,($urandom & 'h0000_7007)); 
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   lt_failure_response =  read_data[12];
   `uvm_info(get_name(), $sformatf("******* ERROR INJECTION ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.enable_lt_status_reg_err            :%0d ",p_sequencer.env.mac_callback.enable_lt_status_reg_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0d ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.local_status_reg               :%0d ",p_sequencer.env.mac_callback.local_status_reg), UVM_NONE);
   `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);


   wait_for_an_vip_event(AN_en);

   p_sequencer.env.reconfig_vip_for_lt_mode(2000);

   fork : max_wait_timer
     begin
       forever 
       begin 
         send_lt_trans_from_vip();
       end
     end
     
     begin
       if(p_sequencer.env.mac_callback.lane_select[0] == 1'b1) begin
         @(posedge p_sequencer.env.spy_if.lt_training[0])
	 training_start_time[0] = $time;
         `uvm_info(get_name(), $sformatf("training_start_time[0]=%0t ",training_start_time[0]), UVM_NONE);
         @(posedge p_sequencer.env.spy_if.training_fail[0]);
	 training_fail_time[0] = $time;
	 `uvm_info(get_name(), $sformatf("training_fail_time[0]=%0t ",training_fail_time[0]), UVM_NONE);
	 `uvm_info(get_name(), $sformatf("Actual lane0  :(training_fail_time[0] - training_start_time[0])=%0t ",(training_fail_time[0] - training_start_time[0])), UVM_NONE);
         `uvm_info(get_name(), $sformatf("Expected max wait timer=%0d ",p_sequencer.env.spy_if.exp_mwt), UVM_NONE);
	 if((training_fail_time[0] - training_start_time[0]) != p_sequencer.env.spy_if.exp_mwt )
	 begin
           `uvm_error(get_name(), "Lane0-Maximum Wait timer is not alinged with configured value"); 
	 end
       end
     end

     begin
       if(p_sequencer.env.mac_callback.lane_select[1] == 1'b1) begin
         @(posedge p_sequencer.env.spy_if.lt_training[1])
	 training_start_time[1] = $time;
         `uvm_info(get_name(), $sformatf("training_start_time[1]=%0t ",training_start_time[1]), UVM_NONE);
         @(posedge p_sequencer.env.spy_if.training_fail[1]);
	 training_fail_time[1] = $time;
	 `uvm_info(get_name(), $sformatf("training_fail_time[1]=%0t ",training_fail_time[1]), UVM_NONE);
	 `uvm_info(get_name(), $sformatf("Actual lane1  :(training_fail_time[1] - training_start_time[1])=%0t ",(training_fail_time[1] - training_start_time[1])), UVM_NONE);
	 if((training_fail_time[1] - training_start_time[1]) != p_sequencer.env.spy_if.exp_mwt )
	 begin
           `uvm_error(get_name(), "Lane0-Maximum Wait timer is not alinged with configured value"); 
	 end
       end
     end

     begin
       if(p_sequencer.env.mac_callback.lane_select[2] == 1'b1) begin
         @(posedge p_sequencer.env.spy_if.lt_training[2])
	 training_start_time[2] = $time;
         `uvm_info(get_name(), $sformatf("training_start_time[1]=%0t ",training_start_time[2]), UVM_NONE);
         @(posedge p_sequencer.env.spy_if.training_fail[2]);
	 training_fail_time[2] = $time;
	 `uvm_info(get_name(), $sformatf("training_fail_time[2]=%0t ",training_fail_time[2]), UVM_NONE);
	 `uvm_info(get_name(), $sformatf("Actual lane2  :(training_fail_time[2] - training_start_time[2])=%0t ",(training_fail_time[2] - training_start_time[2])), UVM_NONE);
	 if((training_fail_time[2] - training_start_time[2]) != p_sequencer.env.spy_if.exp_mwt )
	 begin
           `uvm_error(get_name(), "Lane0-Maximum Wait timer is not alinged with configured value"); 
	 end
       end
     end

     begin
       if(p_sequencer.env.mac_callback.lane_select[3] == 1'b1) begin
         @(posedge p_sequencer.env.spy_if.lt_training[3])
	 training_start_time[3] = $time;
         `uvm_info(get_name(), $sformatf("training_start_time[1]=%0t ",training_start_time[3]), UVM_NONE);
         @(posedge p_sequencer.env.spy_if.training_fail[3]);
	 training_fail_time[3] = $time;
	 `uvm_info(get_name(), $sformatf("training_fail_time[3]=%0t ",training_fail_time[3]), UVM_NONE);
	 `uvm_info(get_name(), $sformatf("Actual lane3  :(training_fail_time[3] - training_start_time[3])=%0t ",(training_fail_time[3] - training_start_time[3])), UVM_NONE);
	 if((training_fail_time[3] - training_start_time[3]) != p_sequencer.env.spy_if.exp_mwt )
	 begin
           `uvm_error(get_name(), "Lane0-Maximum Wait timer is not alinged with configured value"); 
	 end
       end
     end

     begin
         @(p_sequencer.env.spy_if.lt_training);
       for(int i=0;i<(p_sequencer.env.spy_if.rtl_mwt*(mwt_multiplier+1)) ;i++) begin
         `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
	 #10us;
       end
       p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_autoadaptation_dme_encoding.set_default_fail_effect(svt_err_check_stats::NOTE);
       p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_autoadaptation_status_update_without_coeff_update_n.set_default_fail_effect(svt_err_check_stats::NOTE);
       
       if( p_sequencer.env.spy_if.training_fail != p_sequencer.env.mac_callback.lane_select)
       begin
         `uvm_info(get_name(), $sformatf("p_sequencer.env.spy_if.training_fail=%0h ",p_sequencer.env.spy_if.training_fail), UVM_NONE);
         `uvm_error(get_name(), "Expected lanes didnt reported link training failure"); 
       end
       
       if( p_sequencer.env.spy_if.lt_training !=  p_sequencer.env.mac_callback.lane_select)
       begin
         `uvm_info(get_name(), $sformatf("p_sequencer.env.spy_if.lt_training=%0h ",p_sequencer.env.spy_if.lt_training), UVM_NONE);
         `uvm_error(get_name(), "Expected lanes didnt reported link training complete"); 
       end

       if( p_sequencer.env.spy_if.lt_trained != 'hf)
       begin
         `uvm_info(get_name(), $sformatf("p_sequencer.env.spy_if.lt_trained=%0h ",p_sequencer.env.spy_if.lt_trained), UVM_NONE);
         `uvm_error(get_name(), "Expected lanes didnt reported  lt_trained complete"); 
       end

       if( p_sequencer.env.spy_if.lt_frame_lock != 'hf)
       begin
         `uvm_info(get_name(), $sformatf("p_sequencer.env.spy_if.lt_frame_lock=%0h ",p_sequencer.env.spy_if.lt_frame_lock), UVM_NONE);
         `uvm_error(get_name(), "Expected lanes didnt reported lt_frame_lock complete"); 
       end
      `uvm_info(get_name(), $sformatf(" disabled max_wait_timer "), UVM_NONE);
       disable max_wait_timer;
     end

   join
 end

    endtask
endclass
