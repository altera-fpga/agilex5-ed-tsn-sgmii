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


class ptp_mix_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;

  `uvm_object_utils(ptp_mix_sequence)
  function new(string name = "ptp_mix_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `uvm_info("eth_seq_lib", "running ptp_mix_sequence\n",UVM_LOW)
   p_sequencer.top_env.write_asym_p2p_latency(); 

   fork
    begin
      repeat(200) begin
        std::randomize(ptp_op) with {ptp_op inside {[INS_NOOP:INS_2STEP]};ptp_op != INS_INVALID_V1 ; ptp_op != INS_INVALID_V2; ptp_op != INS_INVALID_CS_EB_V1; ptp_op != INS_INVALID_CS_EB_V2; ptp_op != INS_INVALID_ETS_V1;ptp_op != INS_INVALID_ETS_V2;};
        std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
        randcase
        1:send_ptp_frame(ptp_op,f_type,1);  
        1:send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,1); //Jumbo frame not supported until this is fixed - https://hsdes.intel.com/resource/22010448866
        //1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
        endcase
      end
    end
    begin
     `ifdef ENABLE_ETH_VIP
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,200);  //Jumbo frame not supported until this is fixed - https://hsdes.intel.com/resource/22010448866
        //send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,200);  
     `endif
    end
   join
  endtask

endclass : ptp_mix_sequence 
