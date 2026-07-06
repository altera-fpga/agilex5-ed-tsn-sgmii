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


interface eth_testsuite_tasks_intf;
 /* ip number which is accessed by this interface, must be assigned from top */
  bit[4:0] ip;

  /* Variables references for tests/sequences 
     Need to check unused variabels and clean*/
  event event_read_req;
  event event_read_done;
  event event_write_req;
  event event_write_done;
  event event_spico_restart_req;
  event event_spico_restart_done;
  event test_start;
  event test_done;
  event event_xsbi_66b_block_loaded;
  event event_10g_multilane_insert_align_block;
  event event_load_align_marker_error;
  event event_insert_xxvsbi_align_marker;
  event event_10g_multilane_insert_66b_block;
  event event_xsbi_do_err_loaded;
  event event_kr4_fec_do_err_loaded;
  event event_rs_error_inserted;
  event event_kr4_fec_cw_transmitted;
  event event_kr4_fec_align4_insert;
  event event_vip_cfg_req;
  event event_vip_cfg_done;
  event event_ber_timer_done;
  event event_ad_traning_complete_lane0;
  event event_ad_traning_complete_lane1;
  event event_ad_traning_complete_lane2;
  event event_ad_traning_complete_lane3;
  event event_ad_traning_complete_lane4;
  event event_ad_traning_complete_lane5;
  event event_ad_traning_complete_lane6;
  event event_ad_traning_complete_lane7;
  bit [31:0] addr;
  bit [31:0] read_data;
  bit [31:0] write_data;
  bit [7:0]  lane_select;
  string anlt_reg;
  bit   enable_scoreboard;

  eth_env_pkg::speed_e speed;
  int node;
  int inst;
  int ch_num;
  int fec_type;
  bit cr_mode;

  `ifdef ANLT
  initial begin
        event_ad_traning_complete_lane0= svt_ethernet_drv_0.Bfm.ad_sm0.event_ad_traning_complete;
        event_ad_traning_complete_lane1= svt_ethernet_drv_0.Bfm.ad_sm1.event_ad_traning_complete;
        event_ad_traning_complete_lane2= svt_ethernet_drv_0.Bfm.ad_sm2.event_ad_traning_complete;
        event_ad_traning_complete_lane3= svt_ethernet_drv_0.Bfm.ad_sm3.event_ad_traning_complete;
        event_ad_traning_complete_lane4= svt_ethernet_drv_0.Bfm.ad_sm4.event_ad_traning_complete;
        event_ad_traning_complete_lane5= svt_ethernet_drv_0.Bfm.ad_sm5.event_ad_traning_complete;
        event_ad_traning_complete_lane6= svt_ethernet_drv_0.Bfm.ad_sm6.event_ad_traning_complete;
        event_ad_traning_complete_lane7= svt_ethernet_drv_0.Bfm.ad_sm7.event_ad_traning_complete;
        event_ber_timer_done = svt_ethernet_drv_0.Bfm.multilane_10g.rx_decoder.event_ber_timer_done;
        event_10g_multilane_insert_align_block = svt_ethernet_drv_0.Bfm.multilane_10g.event_insert_align_block;
        event_10g_multilane_insert_66b_block = svt_ethernet_drv_0.Bfm.event_10g_multilane_insert_66b_block; 
        event_xsbi_do_err_loaded = svt_ethernet_drv_0.Bfm.event_xsbi_do_err_loaded; 
        event_load_align_marker_error = svt_ethernet_drv_0.Bfm.event_load_align_marker_error; 
        `ifdef RSFEC
        event_kr4_fec_do_err_loaded = svt_ethernet_drv_0.Bfm.event_kr4_fec_do_err_loaded; 
        event_load_align_marker_error = svt_ethernet_drv_0.Bfm.event_load_align_marker_error; 
        event_rs_error_inserted = svt_ethernet_drv_0.Bfm.event_rs_error_inserted; 
        event_kr4_fec_cw_transmitted = svt_ethernet_drv_0.Bfm.event_kr4_fec_cw_transmitted; 
        event_kr4_fec_align4_insert = svt_ethernet_drv_0.Bfm.event_kr4_fec_align4_insert; 
        `endif
      end
  `endif
    
  /* This method waits for vip rx link to go down */
  task wait_vip_rx_link_down();
  `ifdef ETH_MULTI_PORT
    `BFM_WAIT(eth_env_top.svt_ethernet_txrx_if,port_if[0].if_mon.usr_chk_sync_up_rx,0)
  `else
    `BFM_WAIT(eth_env_top.svt_ethernet_txrx_if,if_mon.usr_chk_sync_up_rx,0)
  `endif
    #5ns;
  endtask 

  /* This method waits for vip rx link to go up */
  task wait_vip_rx_link_up();
  `ifdef ETH_MULTI_PORT
    `BFM_WAIT(eth_env_top.svt_ethernet_txrx_if,port_if[0].if_mon.usr_chk_sync_up_rx,1)
  `else
    `BFM_WAIT(eth_env_top.svt_ethernet_txrx_if,if_mon.usr_chk_sync_up_rx,1)
  `endif
  endtask
  
  /* This method waits for otn vip tx link to go up */
  task wait_otn_vip_tx_link_up();
    //DM_Todo: `BFM_WAIT(eth_env_top.uif_pcs66,if_mon.usr_chk_sync_up_tx,1)
  endtask

  /* This method calls VIP drv do_cfg for indexed vip */
  task do_drv_cfg(input [31:0] param, input [63:0] pvalue);
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_drv,do_cfg(param,pvalue))
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_drv,Bfm.do_cfg(param,pvalue))
  endtask

  /* This method calls VIP mon do_cfg for indexed vip */
  task do_mon_cfg(input [31:0] param, input [63:0] pvalue);
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_mon_chk,do_cfg(param,pvalue))
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_mon_chk,Chk.do_cfg(param,pvalue))
  endtask
  
  /* This method calls VIP do_cfg for indexed vip */
  task do_drv_cfg_pcs66(input [31:0] param, input [63:0] pvalue);
    // TBD `BFM_FUNCTION(eth_env_top.svt_ethernet_drv_otn_flexe,do_cfg(param,pvalue))
    // TBD `BFM_FUNCTION(eth_env_top.svt_ethernet_drv_otn_flexe,Bfm.do_cfg(param,pvalue))
  endtask
  
  /* This method calls VIP do_cfg for indexed vip */
  task do_mon_cfg_pcs66(input [31:0] param, input [63:0] pvalue);
    `ifdef FLEXE_MODE
      `FLEXE_BFM_FUNCTION(eth_env_top.svt_ethernet_mon_chk_otn_flexe,do_cfg(param,pvalue))
      `FLEXE_BFM_FUNCTION(eth_env_top.svt_ethernet_mon_chk_otn_flexe,Chk.do_cfg(param,pvalue))
    `endif  
    `ifdef OTN_MODE
      `OTN_BFM_FUNCTION(eth_env_top.svt_ethernet_mon_chk_otn_flexe,do_cfg(param,pvalue))
      `OTN_BFM_FUNCTION(eth_env_top.svt_ethernet_mon_chk_otn_flexe,Chk.do_cfg(param,pvalue))
    `endif  
  endtask

  /* This method calls RTB set_enable for indexed vip */
  function set_enable_a_non_missing_startofpacket (bit en);
    `uvm_info("set_enable_a_non_missing_startofpacket", $sformatf(" set_enable_a_non_missing_startofpacket assertion in avst_rx_rtb is set to %d", en), UVM_LOW)
   `ifdef AVST_MODE
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_non_missing_startofpacket(en))
   `endif
  endfunction

  /* This method calls RTB set_enable for indexed vip */
  function set_enable_a_non_missing_endofpacket (bit en);
    `uvm_info("set_enable_a_non_missing_startofpacket", $sformatf(" set_enable_a_non_missing_startofpacket assertion in avst_rx_rtb is set to %d", en), UVM_LOW)
   `ifdef AVST_MODE
     `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_non_missing_endofpacket(en))
   `endif
  endfunction

  /* This method calls RTB set_enable for indexed vip */
  function avst_set_enable_a_mon_assertion (bit en);
    `uvm_info("set_enable_a_non_missing_startofpacket", $sformatf(" set_enable_a_non_missing_startofpacket assertion in avst_rx_rtb is set to %d", en), UVM_LOW)
   `ifdef AVST_MODE
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_non_missing_endofpacket(en))
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_non_missing_startofpacket(en))
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_valid_legal(en))
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_empty_legal(en))
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_no_data_outside_packet(en))
    `RTB_FUNCTION(eth_env_top.avst_rx_rtb,monitor.u_bfm.monitor_assertion.set_enable_a_less_than_max_channel(en))
   `endif
  endfunction

  /* This method calls RTB set_enable for indexed vip */
  task do_drv_err(input [31:0] param, input [71:0] pvalue);
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_drv,Bfm.do_err(param,pvalue))
  endtask

  /* This method calls VIP do_cmd for indexed vip */
  task do_drv_cmd (input [31:0] cmd, input [63:0] address, input [31:0] byte_count);
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_drv,Bfm.do_cmd(cmd,address,byte_count))
  endtask

  /* This method calls VIP do_pkt for indexed vip */
  task do_drv_pkt(input [7:0] idx, input [7:0] data);
    //DM_Todo: `BFM_FUNCTION(eth_env_top.svt_ethernet_drv,Bfm.do_pkt(idx,data))
  endtask

    
     task force_avst_rx_ready(bit value=0);
        force $root.eth_env_top.dut.i_avalon_st_rx_ready_ip0 = value; 
     endtask 

     task release_avst_rx_ready();
       release $root.eth_env_top.dut.i_avalon_st_rx_ready_ip0;
     endtask  
 
////// Below code (static call) commented for GDR sanity, Need to move to GDR rtl path structure before use
     task force_rx_pma_rdy();
//////        $root.eth_env_top.force_rx_pma_rdy();
     endtask  
//////
     task release_rx_pma_rdy();
//////        $root.eth_env_top.release_rx_pma_rdy();
     endtask  
//////
/////     task force_rand_rx_data(input [1:0] mode, bit [`NUM_CHANNELS-1:0] rand_ch=4'b1111);
     task force_rand_rx_data(input [1:0] mode, bit [3:0] rand_ch=0);
      `ifdef INST_0 
        if(rand_ch == 0) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip0 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip0 = 'hz;
           end
         end
      `endif
      `ifdef INST_1
         if(rand_ch == 1) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip1 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip1 = 'hz;
           end
         end 
      `endif
      `ifdef INST_2 
        if(rand_ch == 2) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip2 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip2 = 'hz;
           end
         end
      `endif
      `ifdef INST_3 
        if(rand_ch == 3) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip3 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip3 = 'hz;
           end
         end
      `endif
      `ifdef INST_4 
        if(rand_ch == 4) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip4 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip4 = 'hz;
           end
         end
      `endif
      `ifdef INST_5 
        if(rand_ch == 5) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip5 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip5 = 'hz;
           end
         end
      `endif
      `ifdef INST_6 
        if(rand_ch == 6) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip6 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip6 = 'hz;
           end
         end
      `endif
      `ifdef INST_7 
        if(rand_ch == 7) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip7 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip7 = 'hz;
           end
         end
      `endif
      `ifdef INST_8 
        if(rand_ch == 8) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip8 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip8 = 'hz;
           end
         end
      `endif
      `ifdef INST_9 
        if(rand_ch == 9) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip9 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip9 = 'hz;
           end
         end
      `endif
      `ifdef INST_10 
        if(rand_ch == 10) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip10 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip10 = 'hz;
           end
         end
      `endif
      `ifdef INST_11 
        if(rand_ch == 11) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip11 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip11 = 'hz;
           end
         end
      `endif
      `ifdef INST_12 
        if(rand_ch == 12) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip12 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip12 = 'hz;
           end
         end
      `endif
      `ifdef INST_13 
        if(rand_ch == 13) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip13 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip13 = 'hz;
           end
         end
      `endif
      `ifdef INST_14 
        if(rand_ch == 14) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip14 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip14 = 'hz;
           end
         end
      `endif
      `ifdef INST_15 
        if(rand_ch == 15) begin
           if(mode == 0) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip15 = $urandom();
           end else if(mode == 1) begin
	     force $root.eth_env_top.dut.i_rx_serial_ip15 = 'hz;
           end
         end
      `endif
     
     endtask  
//////
     task release_rand_rx_data(input [1:0] mode,bit [3:0] rand_ch=0);
//////        $root.eth_env_top.release_rand_rx_data(mode);
      `ifdef INST_0 
        if(rand_ch == 0) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip0;
         end
      `endif
      `ifdef INST_1 
        if(rand_ch == 1) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip1;
         end
      `endif
      `ifdef INST_2 
        if(rand_ch == 2) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip2;
         end
      `endif
      `ifdef INST_3 
        if(rand_ch == 3) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip3;
         end
      `endif
      `ifdef INST_4 
        if(rand_ch == 4) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip4;
         end
      `endif
      `ifdef INST_5 
        if(rand_ch == 5) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip5;
         end
      `endif
      `ifdef INST_6 
        if(rand_ch == 6) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip6;
         end
      `endif
      `ifdef INST_7 
        if(rand_ch == 7) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip7;
         end
      `endif
      `ifdef INST_8 
        if(rand_ch == 8) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip8;
         end
      `endif
      `ifdef INST_9 
        if(rand_ch == 9) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip9;
         end
      `endif
      `ifdef INST_10 
        if(rand_ch == 10) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip10;
         end
      `endif
      `ifdef INST_11 
        if(rand_ch == 11) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip11;
         end
      `endif
      `ifdef INST_12 
        if(rand_ch == 12) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip12;
         end
      `endif
      `ifdef INST_13 
        if(rand_ch == 13) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip13;
         end
      `endif
      `ifdef INST_14 
        if(rand_ch == 14) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip14;
         end
      `endif
      `ifdef INST_15 
        if(rand_ch == 15) begin
	     release $root.eth_env_top.dut.i_rx_serial_ip15;
         end
      `endif

     endtask  
//////
     task force_prelock_cntr(input [9:0] value);
//////        $root.eth_env_top.force_prelock_cntr(value);
     endtask  
//////
     task release_prelock_cntr();
//////        $root.eth_env_top.release_prelock_cntr();
     endtask  
//////
//`ifdef ANLT
   task wait_tx_an_reset();
//////      $root.eth_env_top.wait_tx_an_reset();
   endtask // wait_tx_an_reset
//////   
   task wait_tx_an_restart();
//////      $root.eth_env_top.wait_tx_an_restart();
   endtask 
//`endif 
//////
//----------------------------------------------------------------------------
//////muralasx: Newly Added methods
//----------------------------------------------------------------------------
     task start_testsuite_test();
///        $root.eth_env_top.start_snps_testsuite = 1;
     endtask:start_testsuite_test  
//////
     task testsuite_case_select(string testname, integer first_case, integer last_case);
//        $root.eth_env_top.u_tsbind.testcase_name = testname;
//        $root.eth_env_top.u_tsbind.first_case    = first_case;
//        $root.eth_env_top.u_tsbind.last_case     = last_case;
//        `uvm_info("testsuite_case_select", $sformatf("Selected test = %0s, first case = %0d, last case = %0d", u_tsbind.testcase_name,u_tsbind.first_case,u_tsbind.last_case), UVM_LOW)
     endtask:testsuite_case_select  
//////
     task monitor_error_event();
//        fork 
//           begin
//              @($root.eth_env_top.u_tsbind.event_test_case_error)
//                `uvm_error("eth_testsuite_task", $sformatf("Testsuite error, please refer error message above"));
//           end
//           begin
//              while(1) begin
//                 #100ns;
//              end
//           end
//        join_none;
     endtask:monitor_error_event  
//////
     task wait_for_testsuite_test_finish();
//        bit drop_objection;
//        while (drop_objection == 0)
//        begin
//          fork : testsuite
//            @($root.eth_env_top.u_tsbind.test_case_ends) $root.eth_env_top.ts_num_of_test_done++;
//            @($root.eth_env_top.u_tsbind.case_disable)   $root.eth_env_top.ts_num_of_test_done++;
//          join_any
//
//          if ($root.eth_env_top.ts_num_of_test_done >  ($root.eth_env_top.u_tsbind.last_case - $root.eth_env_top.u_tsbind.first_case))
//          begin
//            drop_objection = 1;
//            disable testsuite;
//          end
//        end
     endtask:wait_for_testsuite_test_finish  
//////
     task dut_reg_read_req();
//        @($root.eth_env_top.u_tsbind.dut_read_req);
//          addr = $root.eth_env_top.u_tsbind.Addr;
     endtask:dut_reg_read_req  
//////
     task dut_reg_read_done();
//        $root.eth_env_top.u_tsbind.Read_Data = read_data;
//        ->$root.eth_env_top.u_tsbind.dut_read_done;
     endtask:dut_reg_read_done  
//////
      task dut_reg_write_req();
//        @($root.eth_env_top.u_tsbind.dut_write_req);
//        addr = $root.eth_env.top.u_tsbind.Addr;
//        write_data = $root.eth_env_top.u_tsbind.Write_Data;
      endtask : dut_reg_write_req
//////
      task dut_reg_write_done();
///         ->$root.eth_env_top.u_tsbind.dut_write_done;
      endtask : dut_reg_write_done
//////
      task spico_restart_req();
///         @($root.eth_env_top.u_tsbind.spico_restart_req);
      endtask : spico_restart_req
//////
      task spico_restart_done();
///        ->$root.eth_env_top.u_tsbind.spico_restart_done;
      endtask : spico_restart_done
//////
      task monitor_hard_reset_event();
///        @($root.eth_env_top.u_tsbind.nvs_eth_10g_multilane_cl82_comp_tp.event_hard_reset);
      endtask:monitor_hard_reset_event
//////
      task wait_for_top_clock(input [31:0] clock);
///        repeat(clock) @(posedge $root.eth_env_top.u_tsbind.clock);
      endtask:wait_for_top_clock
//----------------------------------------------------------------------------

  function set_enable_a_byteenable_legal (bit en=1);
    `uvm_info("set_enable_a_byteenable_legal", $sformatf(" set_enable_a_byteenable_legal assertion in avmm_rtb is set to %d ", en), UVM_LOW)
    `RTB_FUNCTION(eth_env_top.avmm_rtb,monitor.u_bfm.master_assertion.set_enable_a_byteenable_legal(en))
endfunction

  function set_xcvr_enable_a_byteenable_legal (bit en=1);
    `uvm_info("set_enable_a_byteenable_legal", $sformatf(" set_enable_a_byteenable_legal assertion in avmm_xcvr_rtb is set to %d ", en), UVM_LOW)
    `RTB_XCVR_FUNCTION(num_lanes, eth_env_top.avmm_xcvr_rtb_ip0,monitor.u_bfm.master_assertion.set_enable_a_byteenable_legal(en))  
  endfunction

endinterface
