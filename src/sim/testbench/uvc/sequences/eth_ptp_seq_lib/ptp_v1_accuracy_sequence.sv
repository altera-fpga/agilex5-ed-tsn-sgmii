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


class ptp_v1_accuracy_sequence extends eth_ptp_base_sequence;

  `uvm_object_utils(ptp_v1_accuracy_sequence)
  function new(string name = "ptp_v1_accuracy_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    super.body();
    dis_stats_chk=1;
    `uvm_info("eth_seq_lib", "running ptp_v1_accuracy_sequence\n",UVM_LOW)
    
    fork
    begin
      repeat (20) @ (posedge p_sequencer.env.spy_if.o_tx_am);
      `uvm_info("serial_wait", "Done waiting additional 20 TX_AMs before TX traffic\n",UVM_NONE)
      repeat(150) begin
        randcase
        1:send_ptp_frame(INS_V1,DATA_FRAME,1);  
        1:send_ptp_frame(INS_V1,VLAN_FRAME,1);  
        1:send_ptp_frame(INS_V1,STACKED_VLAN_FRAME,1);
        1:send_ptp_frame(INS_V1_W_UDP_CS_0,DATA_FRAME,1);  
        1:send_ptp_frame(INS_V1_W_UDP_CS_0,VLAN_FRAME,1);  
        1:send_ptp_frame(INS_V1_W_UDP_CS_0,STACKED_VLAN_FRAME,1);  
        1:send_ptp_frame(INS_V1_W_EB,DATA_FRAME,1);  
        1:send_ptp_frame(INS_V1_W_EB,VLAN_FRAME,1);  
        1:send_ptp_frame(INS_V1_W_EB,STACKED_VLAN_FRAME,1);  
        endcase
      end
    end
    begin
      `ifdef ENABLE_ETH_VIP
       repeat (20) @ (posedge p_sequencer.env.spy_if.o_rx_am);
       `uvm_info("serial_wait", "Done waiting additional 20 RX_AMs before RX traffic\n",UVM_NONE)
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,150);  
      `endif
    end
    join
  endtask

endclass : ptp_v1_accuracy_sequence
