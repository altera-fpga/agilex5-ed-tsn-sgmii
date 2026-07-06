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


class ptp_base_size_sequence extends uvm_sequence #(eth_packet);
 
  bit ptp;
  int fb609905_rule;
  ptp_op_e ptp_op;
  eth_transaction_frame_type fr_type;
  int pl_size;
  int sequence_length;
  int ipg;
  bit bandwidth;
  int num_words_local;
dyn_rcfg dyn_rcfg_obj_inst; 
  
`uvm_object_utils(ptp_base_size_sequence)

  function new(string name = "ptp_base_size_sequence");
    super.new(name);
   `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new
  
/** Raise an objection if this is the parent sequence */
   virtual task pre_body();
  uvm_phase phase;
  super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
  if (phase!=null) begin
    phase.raise_objection(this);
  end
 endtask: pre_body
   
   /** Drop an objection if this is the parent sequence */
   virtual task post_body();
  uvm_phase phase;
  super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
  if (phase!=null) begin
    phase.drop_objection(this);
  end
   endtask: post_body

 virtual task body();
   `uvm_info("eth_seq_lib", "running ptp_base_size_sequence\n",UVM_LOW)

 `uvm_create(req)
      repeat(sequence_length) begin 
          if (fb609905_rule == 1)
          begin
            std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};}; // All V1
          end
          else if (fb609905_rule == 2)
          begin
            std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_V2_W_UDP_CS_0,INS_NOOP,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};}; // All V2
          end  
          else if(fb609905_rule == 3)
          begin
						std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB, INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,INS_2STEP};};
          end 
          else
            begin
            std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};}; // No V1 EB
            end 
        if(fb609905_rule != 3)   
          std::randomize(ptp);
         //$display("\n\n\nPTP_OP_GOT=%s\n\n\n", ptp_op);
         //  $display("\n\n\n\n\nPTP_REQ=%b\n\n\n\n",ptp);
        if(bandwidth)
        `uvm_rand_send_with(req,{is_ptp_seq==ptp;frame_type == fr_type; payload.size == pl_size; m_ptp_op == ptp_op; interpacket_gap==ipg; num_words==num_words_local;})
        else
        `uvm_rand_send_with(req,{is_ptp_seq==ptp;frame_type == fr_type; payload.size == pl_size; m_ptp_op == ptp_op;num_words==num_words_local;})
      end  
 
  endtask

endclass : ptp_base_size_sequence
