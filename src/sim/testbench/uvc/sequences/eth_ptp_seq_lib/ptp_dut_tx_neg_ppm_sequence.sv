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




class ptp_dut_tx_neg_ppm_sequence extends eth_ptp_base_sequence;

  `uvm_object_utils(ptp_dut_tx_neg_ppm_sequence)
  function new(string name = "ptp_dut_tx_neg_ppm_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
if (p_sequencer.env.spy_if.speed == _100G) begin
 `uvm_info("eth_seq_lib", "changing now the value of ptp_ui reg for 100G\n",UVM_LOW)
p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h9EE41B);
p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h9EE00A);
end
else if (p_sequencer.env.spy_if.speed == _50G) begin
  `uvm_info("eth_seq_lib", "changing now the value of ptp_ui reg for 50G\n",UVM_LOW)
p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h4F720E);
p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_ui_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h4F7005);
end


   super.body();
    dis_stats_chk=1;
   `uvm_info("eth_seq_lib", "running now ptp_dut_tx_neg_ppm_sequence\n",UVM_LOW)
  $display ("change the value of UI offset reg for dut tx neg ppm case");
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
//mac_cfg_tx_ptp_ui
  
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
endclass : ptp_dut_tx_neg_ppm_sequence
