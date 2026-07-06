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


class ptp_v1_mix_ts_ins_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;

  `uvm_object_utils(ptp_v1_mix_ts_ins_sequence)
  function new(string name = "ptp_v1_mix_ts_ins_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `uvm_info("eth_seq_lib", "running ptp_v1_mix_ts_ins_sequence\n",UVM_LOW)
  
   //INS_V1/INS_V1_W_ASYM/NON_PTP
   fork
   begin
     repeat(50) begin
       randcase
       1:send_ptp_frame(INS_V1,DATA_FRAME,1);  
       1:send_ptp_frame(INS_V1,VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1,STACKED_VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT,DATA_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT,VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT,STACKED_VLAN_FRAME,1);  
       1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
       endcase
     end
   end
   begin
     `ifdef ENABLE_ETH_VIP
      send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);  
     `endif
   end
   join


   //INS_V1_W_UDP_CS_0/INS_V1_W_ASYM_LAT_UDP_CS_0/NON_PTP
   fork
   begin
     repeat(50) begin
       randcase
       1:send_ptp_frame(INS_V1_W_UDP_CS_0,DATA_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_UDP_CS_0,VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_UDP_CS_0,STACKED_VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT_UDP_CS_0,DATA_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT_UDP_CS_0,VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT_UDP_CS_0,STACKED_VLAN_FRAME,1);  
       1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
       endcase
     end
   end
   begin
     `ifdef ENABLE_ETH_VIP
      send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);  
     `endif
   end
   join

   //INS_V1_W_EB/INS_V1_W_ASYM_LAT_EB/NON_PTP
   fork
   begin
     repeat(50) begin
       randcase
       1:send_ptp_frame(INS_V1_W_EB,DATA_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_EB,VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_EB,STACKED_VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT_EB,DATA_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT_EB,VLAN_FRAME,1);  
       1:send_ptp_frame(INS_V1_W_ASYM_LAT_EB,STACKED_VLAN_FRAME,1);  
       1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
       endcase
     end
   end
   begin
     `ifdef ENABLE_ETH_VIP
      send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);  
     `endif
   end
   join



   //Randomize all ptp op with frame type/NON_PTP
   fork
   begin
     repeat(50) begin
       std::randomize(ptp_op) with {ptp_op inside {[INS_V1:INS_V1_W_ASYM_LAT_EB]};};
       std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
       randcase
       1:send_ptp_frame(ptp_op,f_type,1);  
       1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
       endcase
     end 
   end
   begin
     `ifdef ENABLE_ETH_VIP
      send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);  
     `endif
   end
   join
   
  endtask
endclass : ptp_v1_mix_ts_ins_sequence
