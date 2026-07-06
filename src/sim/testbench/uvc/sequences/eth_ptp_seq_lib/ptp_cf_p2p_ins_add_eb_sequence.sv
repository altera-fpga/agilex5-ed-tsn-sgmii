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


class ptp_cf_p2p_ins_add_eb_sequence extends eth_ptp_base_sequence;

  `uvm_object_utils(ptp_cf_p2p_ins_add_eb_sequence)
  function new(string name = "ptp_cf_p2p_ins_add_eb_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    super.body();
    `uvm_info("eth_seq_lib", "running ptp_cf_p2p_ins_add_eb_sequence\n",UVM_LOW)
    
    fork
    begin
      p_sequencer.top_env.write_asym_p2p_latency();
      repeat(100) begin
        randcase
        1:send_ptp_frame(INS_P2P_W_EB,DATA_FRAME,1);  
        1:send_ptp_frame(INS_P2P_W_EB,VLAN_FRAME,1);  
        1:send_ptp_frame(INS_P2P_W_EB,STACKED_VLAN_FRAME,1);
        1:send_ptp_frame(INS_NOOP,DATA_FRAME,1);  
        1:send_ptp_frame(INS_NOOP,VLAN_FRAME,1);  
        1:send_ptp_frame(INS_NOOP,STACKED_VLAN_FRAME,1);  
        1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
        endcase
      end
    end
    begin 
      `ifdef ENABLE_ETH_VIP
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,100);  
      `endif
    end
    join
  endtask

endclass : ptp_cf_p2p_ins_add_eb_sequence
