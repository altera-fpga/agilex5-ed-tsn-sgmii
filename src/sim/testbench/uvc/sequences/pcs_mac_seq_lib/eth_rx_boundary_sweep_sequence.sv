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


class eth_rx_boundary_sweep_sequence extends eth_base_sequence;
  bit rx_crc_pass;
  bit rx_rmpad;
  randc frame_type ftype; 
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(eth_rx_boundary_sweep_sequence)
  constraint ftype_c { ftype inside {VLAN_FRAME,JUMBO_DATA_FRAME,STACKED_VLAN_FRAME,JUMBO_VLAN_FRAME,JUMBO_STACKED_VLAN_FRAME,DATA_FRAME};}
  function new(string name = "seq_0");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
  endfunction:new

  virtual task body();
    uvm_reg_data_t rd_data;
    `uvm_info("eth_seq_lib", "running eth_rx_boundary_sweep_sequence\n",UVM_LOW)
    p_sequencer.env.apply_reset("hard",0,0,1,11);

    //Demote expected VIP errors
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
  //`ifdef ANLT    //dsamantx: FIX_ME for GDR_ANLT
  //  p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
  //`endif
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
  //`ifndef CRETE3
  //if(rd_data[8]!=p_sequencer.env.dyn_rcfg_obj_inst.rm_rx_pads)   `uvm_error("rx_boundary_sweep_sequence", $sformatf("REGISTERS_RXMAC_CONTROL_OFFSET_REG bit 8 value must be initialized as per parameter")); ////dsamantx:FIX_ME as rm_rx_pads param not found in GDR dyn_rcfg
  //`endif
    rx_rmpad=1;
    rx_crc_pass=0;
    
    // `ifndef ANLT   
       p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    // `endif

    //Read register to get max_frame_size
    read_max_frame_size();

    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass);// Rx crc forward disable
    //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    rd_data[1]=0;
    rd_data[8]=rx_rmpad;
    `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL : VLAN detection disable=%0b  remove rx pad = %0b",rd_data[1],rd_data[8]), UVM_NONE)
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);

    `ifdef ENABLE_ETH_VIP
    repeat(6) 
    begin    		
     	for(int i=-50;i<=50;i++) begin 
    		send_eth_frame_with_fix_size(ftype,1518+i,1,ETH_VIP_AVL_RX); 
    	end
    	this.randomize();
	end
   `endif
  endtask
endclass:eth_rx_boundary_sweep_sequence
