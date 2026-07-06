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


class eth_lt_c3_mwt_exp_sequence extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit disable_max_timer;
  bit lt_failure_response,dis_lf_timer; 

  bit [3:0] restart_lane;
  bit [7:0] restart_status[4];
  uvm_reg regs;
  bit[3:0] lane_trained;
  bit[3:0] Lane_select_err;
  bit      Lane_select_err_25g;
  bit err_flag;

  `uvm_object_utils(eth_lt_c3_mwt_exp_sequence)

  function new(string name = "eth_lt_c3_mwt_exp_sequence");
    super.new(name);
`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));

   //`ifdef G100
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     #500us;
    end
   //`endif

   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 0;
   //solvnet : 8001173351
   Lane_select_err = 1;// $urandom_range(1,'hF);
   Lane_select_err_25g = $urandom_range(0,1);
   bringup_status_read();

   prbs_select();

   LT_en = 1;
   AN_en = 1;//$urandom_range(0,1);
   disable_max_timer = 0;
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
   read_data[15:4] = 'h0;
   read_data[1] = disable_max_timer;
   read_data[4] = 1;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);

   //case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR     'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR     'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR     'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR     'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
   //endcase

    //C3 RAL: model seq_reset bit is "RW" type,temporary patch until RAL is fixed.
    // C3 also takes time to clear the bit.
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data,1);
    dis_lf_timer = read_data[2];
// FIXME-MISSING_REG_IN_GDR    regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_anlt_seq_cfg_OFFSET_REG);
    read_data[0] = 1'b0;
    regs.predict(.value(read_data),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));

   `uvm_info(get_name(), $sformatf("******* ERROR INJECTION ***************"), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT_en                   :%0d ",LT_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("AN_en                   :%0d ",AN_en), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable max wait timer  :%0d ",disable_max_timer), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Restart AN sequencer    :%0d ",read_data[0]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disabl AN Timer         :%0d ",read_data[1]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Disable LF Timer        :%0d ",read_data[2]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Failure Response     :%0d ",read_data[12]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("LT Fail if Hiber on/off :%0d ",read_data[13]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Skip LT on AN Timeout   :%0d ",read_data[14]), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.enable_lt_status_reg_err            :%0d ",p_sequencer.env.mac_callback.enable_lt_status_reg_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Lane_select_err                   :%0d ",Lane_select_err), UVM_NONE);
   `uvm_info(get_name(), $sformatf("Lane_select_err_25g               :%0d ",Lane_select_err_25g), UVM_NONE);
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.local_status_reg               :%0d ",p_sequencer.env.mac_callback.local_status_reg), UVM_NONE);
   `uvm_info(get_name(), $sformatf("*********************************"), UVM_NONE);
 
   wait_for_an_vip_event(AN_en);

   p_sequencer.env.reconfig_vip_for_lt_mode(5000);
   disable_lt_tx_checker();
   //RTL does not end LT gracefully when error injection happens on either lane,
   // VIP does not support each lane disable checker so have to disable the checker for all lanes.
   disable_lt_rx_checker();

   fork : dis_max_timer_1
   //`ifdef G100
   begin
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     if(Lane_select_err[0] == 1'b1) 
     begin
       p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       p_sequencer.env.mac_callback.lane_select[0] = 1'b1;
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
       `uvm_info(get_name(), $sformatf("Lane 0 waiting for PRESET command "), UVM_NONE);
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h2000);
       `uvm_info(get_name(), $sformatf("Lane 0 PRESET command received "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h003F;
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
       `uvm_info(get_name(), $sformatf("Lane 0 PRESET command completed "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
     end
     end
   end

   begin
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     if(Lane_select_err[1] == 1'b1) 
     begin
       p_sequencer.env.mac_callback.lane_select[1] = 1'b1;
       p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select            :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
       `uvm_info(get_name(), $sformatf("Lane 1 waiting for PRESET command "), UVM_NONE);
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h2000);
       `uvm_info(get_name(), $sformatf("Lane 1 PRESET command received "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h003F;
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h0000);
       `uvm_info(get_name(), $sformatf("Lane 1 PRESET command completed "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
     end
    end
   end

   begin
    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     if(Lane_select_err[2] == 1'b1)
     begin 
       p_sequencer.env.mac_callback.lane_select[2] = 1'b1;
       p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select               :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
       `uvm_info(get_name(), $sformatf("Lane 2 waiting for PRESET command "), UVM_NONE);
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h2000);
       `uvm_info(get_name(), $sformatf("Lane 2 PRESET command received "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h003F;
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h0000);
       `uvm_info(get_name(), $sformatf("Lane 2 PRESET command completed "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
     end
   end
   end

   begin
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
     if(Lane_select_err[3] == 1'b1) 
     begin 
       p_sequencer.env.mac_callback.lane_select[3] = 1'b1;
       p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select             :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
       `uvm_info(get_name(), $sformatf("Lane 3 waiting for PRESET command "), UVM_NONE);
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h2000);
       `uvm_info(get_name(), $sformatf("Lane 3 PRESET command received "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h003F;
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info(get_name(), $sformatf("Lane 3 PRESET command complete "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
     end
   end
   end
  //`endif

   //`ifndef G100
   if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
   begin
     if(Lane_select_err_25g == 1'b1) 
     begin
       p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       p_sequencer.env.mac_callback.lane_select[0] = 1'b1;
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
       `uvm_info(get_name(), $sformatf("Lane 0 waiting for PRESET command "), UVM_NONE);
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h2000);
       `uvm_info(get_name(), $sformatf("Lane 0 PRESET command received "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h003F;
       wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
       `uvm_info(get_name(), $sformatf("Lane 0 PRESET command completed "), UVM_NONE);
       p_sequencer.env.mac_callback.local_status_reg = 'h0000;
     end
   end
  end
  //`endif

   begin
     wait( p_sequencer.env.mac_callback.lane_select != 'h0);
     forever 
     begin 
       send_lt_trans_from_vip();
     end
   end
    join_none
     
   //wait more than LF timer
   for(int i=0;i<150 ;i++)
   begin
      `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
      #10us;
   end
   disable dis_max_timer_1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 0;

  endtask
endclass
