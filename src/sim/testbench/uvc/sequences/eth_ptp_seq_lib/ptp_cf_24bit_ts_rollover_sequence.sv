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


class ptp_cf_24bit_ts_rollover_sequence extends eth_ptp_base_sequence;
  frame_type f_type;
  ptp_op_e ptp_op;
  int fb609905_rule;

  `uvm_object_utils(ptp_cf_24bit_ts_rollover_sequence)
  function new(string name = "ptp_cf_24bit_ts_rollover_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    //uvm_default_printer.knobs.begin_elements=-1;
  endfunction:new

  virtual task body();
    super.body();
    `uvm_info("eth_seq_lib", "running ptp_cf_24bit_ts_rollover_sequence\n",UVM_LOW)

    p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.tod_ns_part.rand_mode(0);	
    p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.tod_ns_part= 'd16303589 - $floor($realtime/1000);
    
    uvm_hdl_force("eth_env_top.dut.i_ptp_tx_tod_valid_ip0",'h0);
    `uvm_info("eth_seq_lib", "PTP TX valid goes to 0",UVM_LOW)
    uvm_hdl_force("eth_env_top.dut.i_ptp_rx_tod_valid_ip0",'h0);
    `uvm_info("eth_seq_lib", "PTP RX valid goes to 0",UVM_LOW)    
    
    wait(p_sequencer.env.spy_if.o_tx_ptp_ready == 0);
    `uvm_info("eth_seq_lib", "PTP TX ready goes to 0",UVM_LOW)
    wait(p_sequencer.env.spy_if.o_rx_ptp_ready == 0);
    `uvm_info("eth_seq_lib", "PTP RX ready goes to 0",UVM_LOW)
    
    #1us;
    uvm_hdl_force("eth_env_top.dut.i_ptp_tx_tod_valid_ip0",'h1);   
    `uvm_info("eth_seq_lib", "PTP TX valid goes to 1",UVM_LOW)
    #1ns;
    uvm_hdl_force("eth_env_top.dut.i_ptp_rx_tod_valid_ip0",'h1);   
    `uvm_info("eth_seq_lib", "PTP RX valid goes to 1",UVM_LOW)

    wait(p_sequencer.env.spy_if.o_tx_ptp_ready == 1);
    `uvm_info("eth_seq_lib", "PTP TX ready goes to 1",UVM_LOW)
    wait(p_sequencer.env.spy_if.o_rx_ptp_ready == 1);    
    `uvm_info("eth_seq_lib", "PTP RX ready goes to 1",UVM_LOW)

    

        fork
	begin
		repeat (2)
        	@ (negedge p_sequencer.env.spy_if.o_tx_am);
        
        	std::randomize(fb609905_rule) with {fb609905_rule inside {2,3};}; // 1 is not valid
		std::randomize(f_type) with {f_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME};};
		repeat(400)
		begin
        	if (fb609905_rule == 1)
            		std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};}; // All V1
          	else if (fb609905_rule == 2)
            		std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};}; // All V2
          	else if (fb609905_rule == 3)
            		std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};}; // No V1 EB
        
        	send_ptp_frame(ptp_op,f_type,1);
		end 
	end 
	begin
		repeat (2)
        	@ (negedge p_sequencer.env.spy_if.o_rx_am);
		`ifdef ENABLE_ETH_VIP
       		send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,100);  
      		`endif
	end
       join
  endtask

endclass : ptp_cf_24bit_ts_rollover_sequence

