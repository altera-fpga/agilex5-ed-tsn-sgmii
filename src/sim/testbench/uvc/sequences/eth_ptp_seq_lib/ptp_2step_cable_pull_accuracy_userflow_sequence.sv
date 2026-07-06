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


class ptp_2step_cable_pull_accuracy_userflow_sequence extends eth_ptp_base_sequence;

  `uvm_object_utils(ptp_2step_cable_pull_accuracy_userflow_sequence)
  eth_ptp_config_sequence eth_ptp_config_seq;

  function new(string name = "ptp_2step_cable_pull_accuracy_userflow_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

   task reset_spm_scb();

      fork
      begin
         //reset
         forever
         begin
            `uvm_info(get_full_name(), "waiting rx ptp ready low ...", UVM_LOW)
            @(negedge p_sequencer.env.spy_if.o_rx_ptp_ready); 
            `uvm_info(get_full_name(), "clearing scoreboard queues", UVM_LOW)
            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
            `endif

         end
      end
      begin
         //deassert
         forever
         begin
            @(posedge p_sequencer.env.spy_if.o_rx_ptp_ready);
            `uvm_info(get_full_name(), "enable SPM", UVM_LOW)
            uvm_hdl_force("eth_env_top.spm_clk_gate", 'h1);
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

         end
      end
      join_none
   endtask: reset_spm_scb

 virtual task body();
   super.body();
   reset_spm_scb();
    dis_stats_chk=1;
   `uvm_info("eth_seq_lib", "running ptp_2step_cable_pull_accuracy_userflow_sequence\n",UVM_LOW)

  p_sequencer.env.disable_all_snps_errors();  

  fork
  begin
    repeat(10) begin
      randcase
      1:send_ptp_frame(INS_2STEP,DATA_FRAME,1);  
      1:send_ptp_frame(INS_2STEP,VLAN_FRAME,1);  
      1:send_ptp_frame(INS_2STEP,STACKED_VLAN_FRAME,1);  
      endcase
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
   `endif
  end
  join

//Wait until no packet send or received
  #5us; //huge delay to allow packets transfer complete

//Force the serial lines to Z
  `uvm_info(get_type_name(), "Force the serial lines to Z\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.dut.i_rx_serial_n_ip0",'hz);
  uvm_hdl_force("eth_env_top.dut.i_rx_serial_ip0",'hz);
  uvm_hdl_force("eth_env_top.dut.o_tx_serial_n_ip0",'hz);
  uvm_hdl_force("eth_env_top.dut.o_tx_serial_ip0",'hz);

  `uvm_info(get_full_name(), "reset SPM by forcing SPM clock to 0", UVM_LOW)
  uvm_hdl_force("eth_env_top.spm_clk_gate", 'h0);
 
//Check for rx_ptp_ready goes 0
  `uvm_info(get_type_name(), "Wait for rx ptp ready go to 0\n",UVM_LOW)
  wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b0);
  `uvm_info(get_type_name(), "rx ptp ready is 0\n",UVM_LOW)

//Release the serial line
  `uvm_info(get_type_name(), "Release the serial lines\n",UVM_LOW)
  uvm_hdl_release("eth_env_top.dut.i_rx_serial_n_ip0");
  uvm_hdl_release("eth_env_top.dut.i_rx_serial_ip0");
  uvm_hdl_release("eth_env_top.dut.o_tx_serial_n_ip0");
  uvm_hdl_release("eth_env_top.dut.o_tx_serial_ip0");


  `uvm_do(eth_ptp_config_seq)

//Check for rx_ptp_ready goes 1
  `uvm_info(get_type_name(), "Wait for rx ptp ready go to 1\n",UVM_LOW)
  wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
  `uvm_info(get_type_name(), "rx ptp ready is 1\n",UVM_LOW)

//Send some cycle

  `uvm_info(get_type_name(), "Send some cycles\n",UVM_LOW)
  fork
  begin
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
     send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,200);
   `endif
  end
  join

  endtask
endclass : ptp_2step_cable_pull_accuracy_userflow_sequence
