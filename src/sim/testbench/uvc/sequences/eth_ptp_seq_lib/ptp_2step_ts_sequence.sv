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


class ptp_2step_ts_sequence extends eth_ptp_base_sequence;
  //ptp_op_e ptp_op;
  //frame_type f_type;

  `uvm_object_utils(ptp_2step_ts_sequence)
  function new(string name = "ptp_2step_ts_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `uvm_info("eth_seq_lib", "running ptp_2step_ts_sequence\n",UVM_LOW)
  
  //INS_2STEP/INS_NOOP/NON_PTP
  fork
  begin
    repeat(100) begin
      randcase
      1:send_ptp_frame(INS_2STEP,DATA_FRAME,1);  
      1:send_ptp_frame(INS_2STEP,VLAN_FRAME,1);  
      1:send_ptp_frame(INS_2STEP,STACKED_VLAN_FRAME,1);  
      1:send_ptp_frame(INS_NOOP,DATA_FRAME,1);  
      1:send_ptp_frame(INS_NOOP,VLAN_FRAME,1);  
      1:send_ptp_frame(INS_NOOP,STACKED_VLAN_FRAME,1);  
      1:send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,1); //Jumbo frame not supported until this is fixed - https://hsdes.intel.com/resource/22010448866
      //1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
      endcase
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);  //Jumbo frame not supported until this is fixed - https://hsdes.intel.com/resource/22010448866
     //send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);  
   `endif
  end
  join

  ////Randomize all ptp op with frame type/NON_PTP
  //repeat(100) begin
  //  std::randomize(ptp_op) with {ptp_op inside {INS_2STEP,INS_NOOP};};
  //  std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
  //  randcase
  //  1:send_ptp_frame(ptp_op,f_type,1);  
  //  1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
  //  endcase
  //end 
   
  endtask
endclass : ptp_2step_ts_sequence
