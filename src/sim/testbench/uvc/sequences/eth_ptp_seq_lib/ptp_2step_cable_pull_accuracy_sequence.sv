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


class ptp_2step_cable_pull_accuracy_sequence extends eth_ptp_base_sequence;

  `uvm_object_utils(ptp_2step_cable_pull_accuracy_sequence)
  function new(string name = "ptp_2step_cable_pull_accuracy_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
    dis_stats_chk=1;
   `uvm_info("eth_seq_lib", "running ptp_2step_cable_pull_accuracy_sequence\n",UVM_LOW)

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

//Force SPM clock to 0
  `uvm_info(get_type_name(), "Force the SPM clock to 0\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.spm_clk_gate", 'h0);

//Force the serial lines to Z
  `uvm_info(get_type_name(), "Force the serial lines to Z\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.dut.i_rx_serial_n_ip0",'hz);
  uvm_hdl_force("eth_env_top.dut.i_rx_serial_ip0",'hz);
  uvm_hdl_force("eth_env_top.dut.o_tx_serial_n_ip0",'hz);
  uvm_hdl_force("eth_env_top.dut.o_tx_serial_ip0",'hz);
 
//Release the rx_pcs_ready and o_tx_lanes_stable
  #2us;
  `uvm_info(get_type_name(), "Force the rx_pcs_ready and o_tx_lanes_stable to 0\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.dut.ip0.eth_f_0.sip_inst.o_tx_lanes_stable",'h0);
  uvm_hdl_force("eth_env_top.dut.ip0.eth_f_0.sip_inst.o_rx_pcs_ready",'h0);

//Check FEC alignment is lost – wait pcs_rx_sf goes to 1
  if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type != NOFEC) begin
    `uvm_info(get_type_name(), "Wait for FEC lose lock during cable pull\n",UVM_LOW)
    wait (p_sequencer.env.spy_if.pcs_rx_sf === 'hffffff);
  end
//Force signal_ok to 0
  `uvm_info(get_type_name(), "Force signal_ok to 0\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.spy_if_ip0.ehip_signal_ok",'h0);

//Check for rx_pcs_aligned goes 0
  `uvm_info(get_type_name(), "Wait for o_rx_pcs_fully_aligned go to 0\n",UVM_LOW)
  wait (p_sequencer.env.spy_if.pcs_aligned[0] === 1'b0);
  `uvm_info(get_type_name(), "rx_pcs_fully_aligned is 0\n",UVM_LOW)

//Release the serial line
  `uvm_info(get_type_name(), "Release the serial lines\n",UVM_LOW)
  uvm_hdl_release("eth_env_top.dut.i_rx_serial_n_ip0");
  uvm_hdl_release("eth_env_top.dut.i_rx_serial_ip0");
  uvm_hdl_release("eth_env_top.dut.o_tx_serial_n_ip0");
  uvm_hdl_release("eth_env_top.dut.o_tx_serial_ip0");

  uvm_hdl_release("eth_env_top.dut.ip0.eth_f_0.sip_inst.o_tx_lanes_stable");
  uvm_hdl_release("eth_env_top.dut.ip0.eth_f_0.sip_inst.o_rx_pcs_ready");

//Force signal_ok to 1
  `uvm_info(get_type_name(), "Force signal_ok to 1\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.spy_if_ip0.ehip_signal_ok",'hffffff);
//Release signal_ok
  #1ps;
  `uvm_info(get_type_name(), "Release i_signal_ok\n",UVM_LOW)
  uvm_hdl_release("eth_env_top.spy_if_ip0.ehip_signal_ok");

//Detect the rx_pcs_aligned[0] goes to 1
  `uvm_info(get_type_name(), "Wait for o_rx_pcs_fully_aligned go to 1\n",UVM_LOW)
  wait (p_sequencer.env.spy_if.pcs_aligned[0] === 1'b1);
  `uvm_info(get_type_name(), "PCS alignment done\n",UVM_LOW)

//Force the rx_pcs_ready and o_tx_lanes_stable to 1
  #2us;
  `uvm_info(get_type_name(), "Force the rx_pcs_ready and o_tx_lanes_stable to 1\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.dut.ip0.eth_f_0.sip_inst.o_tx_lanes_stable",'h1);
  uvm_hdl_force("eth_env_top.dut.ip0.eth_f_0.sip_inst.o_rx_pcs_ready",'h1);

//Force SPM clock to 1
  `uvm_info(get_type_name(), "Force the SPM clock to 1\n",UVM_LOW)
  uvm_hdl_force("eth_env_top.spm_clk_gate", 'h1);

//Wait for PTP ready goes back 1
  `uvm_info(get_type_name(), "Waiting for TX PTP Ready\n",UVM_LOW)
  wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
  `uvm_info(get_type_name(), "TX PTP ready\n",UVM_LOW)
  `uvm_info(get_type_name(), "Waiting for RX PTP Ready\n",UVM_LOW)
  wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
  `uvm_info(get_type_name(), "RX PTP ready\n",UVM_LOW)

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
endclass : ptp_2step_cable_pull_accuracy_sequence
