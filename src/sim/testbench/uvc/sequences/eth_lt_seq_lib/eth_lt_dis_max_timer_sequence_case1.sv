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


class eth_lt_dis_max_timer_sequence_case1 extends eth_lt_base_sequence;
 
  bit LT_en;
  bit AN_en;
  bit disable_max_timer;
  bit lt_failure_response; 

  bit [3:0] restart_lane;
  //bit [7:0] restart_lane; vinoth2x
  bit [7:0] restart_status[4];
  //bit [7:0] restart_status[8]; vinoth2x
  uvm_reg 	regs;
  bit[3:0] lane_trained;
  //bit[7:0] lane_trained; vinoth2x
  bit[3:0] Lane_select_err;
  //bit[7:0] Lane_select_err; vinoth2x
  bit err_flag;

  `uvm_object_utils(eth_lt_dis_max_timer_sequence_case1)

  function new(string name = "eth_lt_dis_max_timer_sequence_case1");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   
   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));

   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 0;
   Lane_select_err = $urandom_range(1,'hF);
   //Lane_select_err = $urandom_range(1,'hFF); vinoth2x
   p_sequencer.env.mac_callback.local_status_reg[15] = 0 ;
   bringup_status_read();

   prbs_select();

   LT_en = 1;
   AN_en = $urandom_range(0,1);
   disable_max_timer = 1;
   enable_disable_lt(LT_en);
   enable_disable_an(AN_en);
   reset_sequencer();

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
   read_data[1] = disable_max_timer;
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);

//   case({AN_en,LT_en})
// FIXME-MISSING_REG_IN_GDR     'b00:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2000);
// FIXME-MISSING_REG_IN_GDR     'b01:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR     'b10:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
// FIXME-MISSING_REG_IN_GDR     'b11:reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h100);
//   endcase

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,(($urandom & 'h0000_7007)| 'h0000_0004));//Disable_LF_timer set to 1 
	#1us;
// FIXME-MISSING_REG_IN_GDR//reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data,1);//haseensx
// FIXME-MISSING_REG_IN_GDR//    regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_anlt_seq_cfg_OFFSET_REG);
//    read_data[0] = 1'b0;
//    regs.predict(.value(read_data),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data );
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
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.local_status_reg               :%0d ",p_sequencer.env.mac_callback.local_status_reg), UVM_NONE);
   `uvm_info(get_name(), $sformatf("******* **************************"), UVM_NONE);

   wait_for_an_vip_event(AN_en);

   p_sequencer.env.reconfig_vip_for_lt_mode(3000);
   err_flag=1;


   fork : dis_max_timer_1

begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 Init command complete "), UVM_NONE);
     if(Lane_select_err[0] == 1'b1) begin
     p_sequencer.env.mac_callback.lane_select[0] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
     `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
//   wait(p_sequencer.env.spy_if.lt_train_state[1][3:0]=='h3);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 Init command complete "), UVM_NONE);
   if(Lane_select_err[1] == 1'b1) begin
     p_sequencer.env.mac_callback.lane_select[1] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
     `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
   end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 Init command complete "), UVM_NONE);
   if(Lane_select_err[2] == 1'b1) begin 
     p_sequencer.env.mac_callback.lane_select[2] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
     `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
    end
   end
   
   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 Init command complete "), UVM_NONE);
     if(Lane_select_err[3] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[3] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end
   
   // Fix lane 4 to lane 7 : revisit vinoth2x
   /*begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 4 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane4.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 4 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane4.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 4 Init command complete "), UVM_NONE);
     if(Lane_select_err[4] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[4] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 5 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane5.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 5 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane5.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 5 Init command complete "), UVM_NONE);
     if(Lane_select_err[5] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[5] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 6 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane6.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 6 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane6.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 6 Init command complete "), UVM_NONE);
     if(Lane_select_err[6] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[6] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 7 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane7.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 7 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane7.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 7 Init command complete "), UVM_NONE);
     if(Lane_select_err[7] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[7] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end*/

   begin
     wait( p_sequencer.env.mac_callback.lane_select != 'h0);
     forever 
     begin 
       send_lt_trans_from_vip();
     end
   end
   join_none
     
   //wait more than configured max wait timer but not till LF timer expires. 
   for(int i=0;i<(p_sequencer.env.spy_if.rtl_mwt + 2) ;i++)
   begin
      `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
      #10us;
   end
   //upon link faulure RTL stop sending data on all lanes,
   // LT restart stop data on transmit lanes
   disable_lt_rx_checker();
   disable_lt_tx_checker();
   restart_status[0]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[0],1'b1,1'b1};//faied,training,frame lock,trained.
   restart_status[1]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[1],1'b1,1'b1};
   restart_status[2]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[2],1'b1,1'b1};
   restart_status[3]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[3],1'b1,1'b1};
   //Fix lane 4 to lane 7: revisit vinoth2x
   /*restart_status[4]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[4],1'b1,1'b1};
   restart_status[5]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[5],1'b1,1'b1};
   restart_status[6]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[6],1'b1,1'b1};
   restart_status[7]  = {5'b00000,p_sequencer.env.mac_callback.lane_select[7],1'b1,1'b1};*/
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
// FIXME-MISSING_REG_IN_GDR   //reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[7],restart_status[6],restart_status[5],restart_status[4],restart_status[3],restart_status[2],restart_status[1],restart_status[0]}); vinoth2x
    
   restart_lane = 'hF;
   //restart_lane = 'hFF; vinoth2x
   `uvm_info(get_name(), $sformatf("1st : restart_lane                   :%0h ",restart_lane), UVM_LOW);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,{read_data[31:4],restart_lane[3:0]});
// FIXME-MISSING_REG_IN_GDR   //p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,{read_data[31:4],restart_lane[3:0]}); //Check register fields: revisit vinoth2x
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_training) -start     :%0h ",p_sequencer.env.spy_if.lt_training), UVM_NONE);
   wait(p_sequencer.env.spy_if.lt_training == 'h0);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_training) - done     :%0h ",p_sequencer.env.spy_if.lt_training), UVM_NONE);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_frame_lock) -start     :%0h ",p_sequencer.env.spy_if.lt_frame_lock), UVM_NONE);
   wait(p_sequencer.env.spy_if.lt_frame_lock == 'h0);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_frame_lock) - done     :%0h ",p_sequencer.env.spy_if.lt_frame_lock), UVM_NONE);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_trained) -start     :%0h ",p_sequencer.env.spy_if.lt_trained), UVM_NONE);
   wait(p_sequencer.env.spy_if.lt_trained == 'h0);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_trained) - done     :%0h ",p_sequencer.env.spy_if.lt_trained), UVM_NONE);

// FIXME-MISSING_REG_IN_GDR//   reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0); //FB_FIX-577811 for C2
   err_flag=0;
   disable dis_max_timer_1;
    p_sequencer.env.mac_callback.lane_select = 'h0;
    p_sequencer.env.mac_callback.enable_lt_status_reg_err = 0;
   `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0d ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
   `uvm_info(get_name(), $sformatf("dis_max_timer_1 err_flag: %0h ",err_flag), UVM_NONE);
   p_sequencer.env.reset_vip();
   p_sequencer.env.reconfig_vip_for_lt_mode(2000);
   `ifndef CRETE3 // C2 specific delay to enable checker again
     #30us;
   `endif
   enable_lt_rx_checker();

  fork : dis_max_timer_2
  begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane0.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 0 Init command complete "), UVM_NONE);
     if(Lane_select_err[0] == 1'b1) begin
     p_sequencer.env.mac_callback.lane_select[0] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
     `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
//   wait(p_sequencer.env.spy_if.lt_train_state[1][3:0]=='h3);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane1.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 1 Init command complete "), UVM_NONE);
   if(Lane_select_err[1] == 1'b1) begin
     p_sequencer.env.mac_callback.lane_select[1] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
     `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
   end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane2.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 2 Init command complete "), UVM_NONE);
   if(Lane_select_err[2] == 1'b1) begin 
     p_sequencer.env.mac_callback.lane_select[2] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
     `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
    end
   end
   
   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane3.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 3 Init command complete "), UVM_NONE);
     if(Lane_select_err[3] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[3] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   // Fix lane 4 to lane 7: revisit vinoth2x
   /*begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 4 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane4.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 4 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane4.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 4 Init command complete "), UVM_NONE);
     if(Lane_select_err[4] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[4] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 5 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane5.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 5 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane5.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 5 Init command complete "), UVM_NONE);
     if(Lane_select_err[5] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[5] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 6 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane6.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 6 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane6.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 6 Init command complete "), UVM_NONE);
     if(Lane_select_err[6] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[6] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end

   begin
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 7 waiting for INIT command "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane7.received_autoadaptation_control_page[15:0]=='h1000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 7 Init command received "), UVM_NONE);
     wait(p_sequencer.env.svt_ethernet_txrx_inst.debug_bus.debug_bus_backplane.debug_bus_autoadaptation_bfm_lane7.received_autoadaptation_control_page[15:0]=='h0000);
   `uvm_info("disable_rx_remote_ready_1", $sformatf("Lane 7 Init command complete "), UVM_NONE);
     if(Lane_select_err[7] == 1'b1) begin 
       p_sequencer.env.mac_callback.lane_select[7] = 1'b1;
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 1;
       `uvm_info(get_name(), $sformatf("p_sequencer.env.mac_callback.lane_select                   :%0h ",p_sequencer.env.mac_callback.lane_select), UVM_NONE);
     end
   end*/

   begin
     wait( p_sequencer.env.mac_callback.lane_select != 'h0);
     forever 
     begin 
       send_lt_trans_from_vip();
     end
   end
   join_none


// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200,1);
// FIXME-MISSING_REG_IN_GDR  //   p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0,1);

   for(int i=0;i<10 ;i++)
   begin
      `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
      #10us;
   end
 
   ////wait more than LF timer timer.
   //`uvm_info(get_name(), $sformatf("p_sequencer.env.dyn_rcfg_obj_inst.ltkr: %0d ",p_sequencer.env.dyn_rcfg_obj_inst.ltkr), UVM_NONE);
   //for(int i=0;i<(((p_sequencer.env.dyn_rcfg_obj_inst.ltkr/10)*2) + 1) ;i++)
   //begin
   //   `uvm_info(get_name(), $sformatf("#10us count =%0d ",i), UVM_NONE);
   //   #10us;
// FIXME-MISSING_REG_IN_GDR   //   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_status_OFFSET_REG,read_data);
   //end
   //upon link faulure RTL stop sending data on all lanes,
   disable_lt_rx_checker();
   disable_lt_tx_checker();
   restart_status[0]  = {5'b00000,1'b1,1'b1,1'b0};//faied,training,frame lock,trained.
   restart_status[1]  = {5'b00000,1'b1,1'b1,1'b0};
   restart_status[2]  = {5'b00000,1'b1,1'b1,1'b0};
   restart_status[3]  = {5'b00000,1'b1,1'b1,1'b0};
   // Fix lane 4 to lane 8 : revisit vinoth2x
   /*restart_status[4]  = {5'b00000,1'b1,1'b1,1'b0};
   restart_status[5]  = {5'b00000,1'b1,1'b1,1'b0};
   restart_status[6]  = {5'b00000,1'b1,1'b1,1'b0};
   restart_status[7]  = {5'b00000,1'b1,1'b1,1'b0};*/
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[3],restart_status[2],restart_status[1],restart_status[0]});
// FIXME-MISSING_REG_IN_GDR   //reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,{restart_status[7],restart_status[6],restart_status[5],restart_status[4],restart_status[3],restart_status[2],restart_status[1],restart_status[0]}); vinoth2x
   
   restart_lane = 'hF;
   //restart_lane = 'hFF; vinoth2x
   `uvm_info(get_name(), $sformatf("2nd : restart_lane                   :%0h ",restart_lane), UVM_LOW);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,{read_data[31:4],restart_lane[3:0]});
// FIXME-MISSING_REG_IN_GDR   //p_sequencer.env.reg_write(`REGISTERS_lt_cfg2_OFFSET_REG,{read_data[31:4],restart_lane[3:0]}); // check register fields: revisit vinoth2x
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_training) -start     :%0h ",p_sequencer.env.spy_if.lt_training), UVM_NONE);
   wait(p_sequencer.env.spy_if.lt_training == 'h0);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_training) - done     :%0h ",p_sequencer.env.spy_if.lt_training), UVM_NONE);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_frame_lock) -start     :%0h ",p_sequencer.env.spy_if.lt_frame_lock), UVM_NONE);
   wait(p_sequencer.env.spy_if.lt_frame_lock == 'h0);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_frame_lock) - done     :%0h ",p_sequencer.env.spy_if.lt_frame_lock), UVM_NONE);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_trained) -start     :%0h ",p_sequencer.env.spy_if.lt_trained), UVM_NONE);
   wait(p_sequencer.env.spy_if.lt_trained == 'h0);
   `uvm_info(get_name(), $sformatf("wait(p_sequencer.env.spy_if.lt_trained) - done     :%0h ",p_sequencer.env.spy_if.lt_trained), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR  // reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h0); //FB_FIX-577811 for C2
   err_flag=0;
   `uvm_info(get_name(), $sformatf("dis_max_timer_2 err_flag: %0h ",err_flag), UVM_NONE);
   disable dis_max_timer_2;
   //disable error injectio to briung up LT correctly
   p_sequencer.env.mac_callback.enable_lt_status_reg_err = 0;
   p_sequencer.env.mac_callback.lane_select = 'h0;
   p_sequencer.env.reset_vip();
   p_sequencer.env.reconfig_vip_for_lt_mode(15);

   `ifndef CRETE3 // C2 specific delay to enable checker again
     #30us;
   `endif
   enable_lt_rx_checker();

// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR //  p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0);

   wait_for_lt_vip_event();
   disable_lt_rx_checker();
   disable_lt_tx_checker();

// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_lt_cfg2_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h200);
// FIXME-MISSING_REG_IN_GDR //  p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);

   p_sequencer.env.reconfig_vip_for_datamode();

   `uvm_info("wait_for_lt_complete", $sformatf("Waiting for RX PCS READY to be up "), UVM_NONE);
   wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
   p_sequencer.env.enable_snps_errors();

   send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
   
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_status1_OFFSET_REG,'h01010101);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_anlt_seq_status_OFFSET_REG,'h2001);
// FIXME-MISSING_REG_IN_GDR   reg_predict_read(`REGISTERS_lt_cfg2_OFFSET_REG,'h0);
// FIXME-MISSING_REG_IN_GDR  // p_sequencer.env.reg_read(`REGISTERS_an_status_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status1_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status2_OFFSET_REG,read_data,1);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status3_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status4_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status5_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR   p_sequencer.env.reg_read(`REGISTERS_an_status6_OFFSET_REG,read_data);

  endtask
endclass
