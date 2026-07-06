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



class ptp_2step_accuracy_100g_skew_reorder_sequence extends eth_ptp_base_sequence;

   rand bit [3:0] lane_skew[20];
   integer lane_order[16] = '{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};

   constraint lane_skew_c
   {
     foreach(lane_skew[i])
       lane_skew[i] inside {[1:9]};
   }

  `uvm_object_utils(ptp_2step_accuracy_100g_skew_reorder_sequence)
  function new(string name = "ptp_2step_accuracy_100g_skew_reorder_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

   
 virtual task body();
this.randomize();

`ifdef ENABLE_ETH_VIP
 p_sequencer.env.disable_all_snps_errors();
`endif
 // foreach(lane_skew[i])
   //  begin

 //  $display ("lane skew applied");
 // `uvm_info("lane_skew", $sformatf("skew[%0d]=%0d",i,lane_skew[i]),UVM_NONE)
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE0,lane_skew[0]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE1,lane_skew[1]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE2,lane_skew[2]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE3,lane_skew[3]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE4,lane_skew[4]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE5,lane_skew[5]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE6,lane_skew[6]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE7,lane_skew[7]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE8,lane_skew[8]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE9,lane_skew[9]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE10,lane_skew[10]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE11,lane_skew[11]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE12,lane_skew[12]);
// p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE13,lane_skew[13]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE14,lane_skew[14]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE15,lane_skew[15]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE16,lane_skew[16]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE17,lane_skew[17]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE18,lane_skew[18]);
 //p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE19,lane_skew[19]);

     //end
`uvm_info(get_full_name(), "Disable scoreboard", UVM_LOW)
            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;  
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
            uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_LOW);
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
            `endif

   super.body();
            `uvm_info(get_full_name(), "Enable scoreboard", UVM_LOW)
            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;  
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;  
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1;
            //Enable avst monitor assertions after getting lock
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);
            `endif

    dis_stats_chk=1;
   `uvm_info("eth_seq_lib", "running ptp_2step_accuracy_100g_skew_reorder_sequence\n",UVM_LOW)
 //lane_order.shuffle();
   // this.randomize();

    

  //INS_2STEP/INS_NOOP/NON_PTP
  fork
  begin
//    repeat (20) @ (posedge p_sequencer.env.spy_if.o_tx_am);
//    `uvm_info("serial_wait", "Done waiting additional 20 TX_AMs before TX traffic\n",UVM_NONE)
    repeat(200) begin
      randcase
      1:send_ptp_frame(INS_2STEP,DATA_FRAME,1);  
      1:send_ptp_frame(INS_2STEP,VLAN_FRAME,1);  
      1:send_ptp_frame(INS_2STEP,STACKED_VLAN_FRAME,1);  
      endcase
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
//     repeat (5) @ (posedge p_sequencer.env.spy_if.o_rx_am);
//     `uvm_info("serial_wait", "Done waiting additional 20 RX_AMs before RX traffic\n",UVM_NONE)
     send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,200);  
   `endif
  end
  join

  endtask
endclass : ptp_2step_accuracy_100g_skew_reorder_sequence

