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


class ptp_min_frame_sequence extends eth_ptp_base_sequence;
  `uvm_object_utils(ptp_min_frame_sequence)
   ptp_base_size_sequence eth_seq;
  eth_ptp_config_sequence eth_ptp_config_seq;
 eth_transaction_frame_type f_type;
int size;
int mix_rule;

  function new(string name = "ptp_min_frame_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   `uvm_info("body", "started ptp_min_frame_sequence ...", UVM_NONE)
   `uvm_do(eth_ptp_config_seq)
  // p_sequencer.env.apply_reset("hard",0,0,1,11); //TODO GDR
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   dis_stats_chk=1;

        `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
        `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)

        `uvm_info("ptp_min_frame_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
        `uvm_info("ptp_min_frame_sequence", "RX PTP ready\n",UVM_LOW)
    
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
        //Actual PTP traffic after PTP ready
        `uvm_create_on(eth_seq, p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        //Actual PTP traffic after PTP ready
        `uvm_create_on(eth_seq, p_sequencer.v_m_sqr);
      end

     std::randomize(f_type) with {f_type inside {ETH_VLAN_FRAME ,ETH_STACKED_VLAN_FRAME ,ETH_DATA_FRAME};};
     std::randomize(f_type)with {f_type dist {ETH_VLAN_FRAME := 30 ,ETH_STACKED_VLAN_FRAME := 10 ,ETH_DATA_FRAME :=60};};
    // std::randomize(mix_rule) with {mix_rule inside {1,2,3};};
     std::randomize(mix_rule) with {mix_rule ==3 ;}; //1 is all v1 frames, 3 without v1 is 2

     if (f_type == ETH_VLAN_FRAME)
     size =42;
     else if (f_type == ETH_STACKED_VLAN_FRAME)
     size =38;
     else
     size =46;
     //$display ("\n\n\n\n+++++++++++++++++++++++++++++++++++++TYPE=%s++++++++++++++++++", f_type);
     //$display("\n\n\n\nMIX_RULE=%d\n\n\n\n\n",mix_rule);
     eth_seq.fb609905_rule = mix_rule;
     eth_seq.pl_size = size;
     if(mix_rule == 3)
       eth_seq.ptp = 1'b1;
     eth_seq.fr_type = f_type;
     eth_seq.sequence_length = 400;

     eth_seq.num_words_local = (p_sequencer.env.spy_if.speed == _10G) ? 1: //[TODO] Need to update with actual values
                        (p_sequencer.env.spy_if.speed == _25G) ? 1:
                        (p_sequencer.env.spy_if.speed == _40G) ? 2:
                        (p_sequencer.env.spy_if.speed == _50G) ? 2:
                        (p_sequencer.env.spy_if.speed == _100G)? 4:
                        (p_sequencer.env.spy_if.speed == _200G)? 8:16;


     if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
         eth_seq.start(p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
         eth_seq.start(p_sequencer.v_m_sqr);
      end
     //eth_seq.start(p_sequencer.tx_seqr);
endtask
endclass : ptp_min_frame_sequence
