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


class ptp_err_mix_offset_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit mix_rule;

  `uvm_object_utils(ptp_err_mix_offset_sequence)
  function new(string name = "ptp_err_mix_offset_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   dis_stats_chk=1;
   enable_tx_error_insertion();
   `ifdef ENABLE_ETH_VIP
   disable_snps_err();//disabling VIP checkers  
   `endif
   `uvm_info("eth_seq_lib", "running ptp_err_mix_offset_sequence\n",UVM_LOW)
   //mix_rule = $urandom(); //VR 1 will send v1 frames
   mix_rule = 0;
   p_sequencer.env.m_ptp_tx_ref_model.fp_check_en = 0;
  fork
  begin
    repeat(100) begin
      if(mix_rule)
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
      else
        std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
      std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME,JUMBO_DATA_FRAME,JUMBO_VLAN_FRAME,JUMBO_STACKED_VLAN_FRAME};};
      randcase
        1:send_ptp_frame(ptp_op,f_type,1,1);  // Error frame with invalid offsets
        1:send_ptp_frame(ptp_op,f_type,1,0);  // good frame
      endcase
    end
  end
  begin
   `ifdef ENABLE_ETH_VIP
     repeat(100) begin
     	randcase 
     	1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);  
     	1:send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP);
     	endcase
     end
   `endif
  end
  join

  endtask
  
endclass : ptp_err_mix_offset_sequence
