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


class ptp_cf_underflow_overflow_sequence extends eth_ptp_base_sequence;
  `uvm_object_utils(ptp_cf_underflow_overflow_sequence)
  ptp_base_over_under_flow_sequence eth_seq;
  eth_ptp_config_sequence eth_ptp_config_seq;
  eth_transaction_frame_type f_type;
  int size;
	int i;
  int mix_rule;
  bit [31:0] rd_data;
  int cf_excess;
  int delay;
  frame_type f_type;
  ptp_op_e ptp_op;
  //int fb609905_rule;

  function new(string name = "ptp_cf_underflow_overflow_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    //uvm_default_printer.knobs.begin_elements=-1;
  endfunction:new

  virtual task body();
    super.body();
     `uvm_do(eth_ptp_config_seq)
     p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
     $display("rx pcs ready received");
    `uvm_info("eth_seq_lib", "running ptp_cf_underflow_overflow_sequence\n",UVM_LOW)
    
    `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
      wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
    `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)

    `uvm_info("ptp_frames_underflow", "Waiting for RX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
        `uvm_info("ptp_frames_underflow", "RX PTP ready\n",UVM_LOW)

    p_sequencer.top_env.write_asym_p2p_latency(); 
    #20ns;  
		  if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
        //Actual PTP traffic after PTP ready
        `uvm_create_on(eth_seq, p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        //Actual PTP traffic after PTP ready
        `uvm_create_on(eth_seq, p_sequencer.v_m_sqr);
      end
  
      for(i=0; i< 8; ++i)
      begin   
        std::randomize(f_type) with {f_type inside {ETH_JUMBO_DATA_FRAME};};
        //std::randomize(mix_rule) with {mix_rule inside {1,2,3};}; 
        //std::randomize(mix_rule) with {mix_rule {3 ;}; // overflow of cf

        mix_rule = (i%2 == 0)? 3 /*overflowflow*/ : 4 ;
       `uvm_info(get_type_name(),  $sformatf("Mix rule selected=x%0x", mix_rule), UVM_LOW) 
        
        //p_sequencer.env.spy_if.ts_under_over = 1'b1;

        eth_seq.trans_rule = mix_rule;
        //rk eth_seq.pl_size = $urandom_range(64,400);
        eth_seq.pl_size = 1501;
        eth_seq.fr_type = f_type;
        eth_seq.ptp = 1;;
        eth_seq.sequence_length = 1;
        if(mix_rule == 4)
          //eth_seq.ingress_cf_local = $urandom_range('h0000F,'h10000);
          eth_seq.ingress_cf_local = 'h8000_0000_0000_0001;
        else
        begin
          cf_excess = $urandom_range('hFFFF_FFFF, 'hFFFF_FFEE);
          eth_seq.ingress_cf_local = {'h7FFF_FFFF,cf_excess};
        end
       `uvm_info(get_type_name(),  $sformatf("Ingress cf local=%h", eth_seq.ingress_cf_local), UVM_LOW) 
        //p_sequencer.env.spy_if.ingress_ts_part = eth_seq.ingress_cf_local;

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
          p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_tx_ptp_cf_overflow_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          if(rd_data == 0)
            `uvm_error(get_type_name(), $sformatf("overflow EXP=1, ACT=%0x",read_data)); 
	end
  endtask

endclass : ptp_cf_underflow_overflow_sequence
