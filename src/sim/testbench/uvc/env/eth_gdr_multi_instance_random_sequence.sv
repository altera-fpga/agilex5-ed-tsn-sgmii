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


class eth_gdr_multi_instance_random_sequence extends uvm_sequence;

`uvm_object_utils(eth_gdr_multi_instance_random_sequence)
`uvm_declare_p_sequencer(eth_top_virtual_sequencer)
uvm_sequence_base seq[`NUM_INST];
string m_sequence  ;

string mac_seq_list[11] = '{"sanity_sequence","sweep_parameter_sequence","crc_pass_sequence","fc_rand_seq","eth_stat_fcs_err_frame_seq","vip_strict_sfd_sequence","eth_link_remote_fault_rand_sequence","eth_link_local_fault_rand_sequence","eth_fc_rxfwd_rand_seq","preamble_pass_sequence","eth_hard_reset_recovery_sequence" };
string pcs_seq_list[7]  = '{"pcs_cable_pull_no_data_sequence","pcs_cable_pull_rand_data_sequence","pcs_sanity_sequence","pcs_err_during_lock_sequence","pcs_lock_on_data_sequence","pcs_blk_lock_loss_sequence","eth_hard_reset_recovery_sequence" };
string flexe_seq_list[4]  = '{"pcs66_sanity_sequence","eth_hard_reset_recovery_sequence","pcs_cable_pull_rand_data_sequence","pcs_cable_pull_no_data_sequence"};
string otn_seq_list[4]  = '{"pcs66_sanity_sequence","eth_hard_reset_recovery_sequence","pcs_cable_pull_rand_data_sequence","pcs_cable_pull_no_data_sequence"};

function new(string name = "eth_gdr_multi_instance_random_sequence");
    super.new(name);
endfunction:new

function string sequence_tobe_driven (mode_e mode_random) ;
       `uvm_info("multi_instance_random_sequence",$sformatf(" mode random value is %0s ",mode_random),UVM_NONE);
	if( mode_random == MACSEG || mode_random == PCSMAC ) begin
           mac_seq_list.shuffle();
           sequence_tobe_driven = mac_seq_list[0];
	end else if(mode_random == PCSONLY) begin
           pcs_seq_list.shuffle();
           sequence_tobe_driven = pcs_seq_list[0];
	end else if(mode_random == FLEXE ) begin
           flexe_seq_list.shuffle();
           sequence_tobe_driven = flexe_seq_list[0];
	end else if( mode_random == OTN) begin
           otn_seq_list.shuffle();
           sequence_tobe_driven = otn_seq_list[0];
	end
endfunction

virtual task pre_body();
      uvm_phase phase;
      super.pre_body();
      phase = starting_phase;
      if (phase!=null) begin
	  phase.raise_objection(this);
      end

      foreach (seq[i]) begin
           m_sequence  = sequence_tobe_driven(p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.mode) ;
           `uvm_info("multi_instance_random_sequence",$sformatf("mi_random_sequence: sequenc_to_be_driven %0s for ip%0d for mode %0s",m_sequence, i,p_sequencer.top_env.env_ip[i].dyn_rcfg_obj_inst.mode),UVM_NONE);
            if (!$cast(seq[i], factory.create_object_by_name(m_sequence))) begin
               `uvm_fatal("TEST:NOTASEQ", {"Type ", m_sequence , " is not a sequence type"});
            end
            p_sequencer.top_env.env_ip[i].spy_if.inst_num = i; 
      end
endtask: pre_body

virtual task post_body();
      uvm_phase phase;
      super.post_body();
      phase = starting_phase;
      if (phase!=null) begin
	 phase.drop_objection(this);
      end
endtask: post_body

virtual task body();
         foreach (seq[i]) begin
	 automatic int j=i;
	    fork
	    begin
                  begin
	   	    p_sequencer.top_env.env_ip[j].wait_for_linkup(.ip_sync(1));
                    seq[j].start(p_sequencer.virtual_sequencer_inst[j]);
                  end
            end  // fork 
	    join_none
	 end  // foreach 
    	 wait fork;
       //#600ns;
       #100us;
endtask // body 

endclass

