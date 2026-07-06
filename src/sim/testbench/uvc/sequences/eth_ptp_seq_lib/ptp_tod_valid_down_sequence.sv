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


class ptp_tod_valid_down_sequence extends eth_ptp_base_sequence;

  bit rx_crc_pass;
  
`uvm_object_utils(ptp_tod_valid_down_sequence)
  function new(string name = "ptp_tod_valid_down_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    super.body();
    `uvm_info("eth_seq_lib", "running ptp tod valid down sequence\n",UVM_LOW)
   rx_crc_pass=$urandom;
   
   wait(p_sequencer.env.spy_if.o_tx_ptp_ready == 1);
   `uvm_info("eth_seq_lib", "running ptp tod valid down sequence, PTP TX Ready is 1\n",UVM_LOW)
   wait(p_sequencer.env.spy_if.o_rx_ptp_ready == 1);
   `uvm_info("eth_seq_lib", "running ptp tod valid down sequence, PTP RX Ready is 1\n",UVM_LOW)   
   
   //Send PTP frames
   fork
   begin
      //TX
      send_ptp_frame(INS_V2,DATA_FRAME,1);  
      send_ptp_frame(INS_V2_W_UDP_CS_0,DATA_FRAME,1);  
      send_ptp_frame(INS_V2_W_EB,DATA_FRAME,1);  
      send_ptp_frame(INS_CF,DATA_FRAME,1);  
      send_ptp_frame(INS_CF_W_UDP_CS_0,DATA_FRAME,1);  
      send_ptp_frame(INS_CF_W_EB,DATA_FRAME,1);  
      
      send_ptp_frame(INS_V2,VLAN_FRAME,1);  
      send_ptp_frame(INS_V2_W_UDP_CS_0,VLAN_FRAME,1);  
      send_ptp_frame(INS_V2_W_EB,VLAN_FRAME,1);  
      send_ptp_frame(INS_CF,VLAN_FRAME,1);  
      send_ptp_frame(INS_CF_W_UDP_CS_0,VLAN_FRAME,1);  
      send_ptp_frame(INS_CF_W_EB,VLAN_FRAME,1);
      
      send_ptp_frame(INS_2STEP,VLAN_FRAME,1);   
   
   end
   begin
   
      //RX -VIP
      `ifdef ENABLE_ETH_VIP
         send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,10);      
      `endif
   
   end
   join


  endtask
endclass
