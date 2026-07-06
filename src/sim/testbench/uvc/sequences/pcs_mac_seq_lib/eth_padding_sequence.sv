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


class eth_padding_sequence extends eth_base_sequence;
  bit rx_crc_pass;
  bit rx_rmpad;
  padding_sequence tx_seq;
  
  `uvm_object_utils(eth_padding_sequence)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    tx_seq=new("tx_seq");  
  endfunction:new

  virtual task body();
    uvm_reg_data_t rd_data;
    `uvm_info("eth_seq_lib", "running eth_padding_sequence\n",UVM_LOW)

    
    //p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    p_sequencer.env.reg_read(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    //if(rd_data[8]!=p_sequencer.env.dyn_rcfg_obj_inst.rm_rx_pads)   `uvm_error("eth_padding_sequence", $sformatf("mac_cfg_rxmac_control_OFFSET_REG bit 8 value must be initialized as per parameter"));    
    rx_rmpad=0;//$urandom;
    rx_crc_pass=1;//$urandom;
    if(rx_rmpad) rx_crc_pass=0;
    
    //Demote expected VIP errors
    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE); 
    `endif
    
     // below code is for coverage purpose 
     if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10G)
      tx_seq.FOR_coverage =1;
    
    //Read register to get max_frame_size
    read_max_frame_size();

    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass);// Rx crc forward disable
    ////randomize the RXMAC_CONTROL data[8]
    //rd_data[1]=0;
    //rd_data[8]=rx_rmpad;
    //`uvm_info(get_full_name(), $psprintf("Writing RXMAC_CONTROL : VLAN detection disable=%0b  remove rx pad = %0b",rd_data[1],rd_data[8]), UVM_NONE)
    //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
    rd_data[1] = rx_rmpad;
    rd_data[0] = ~rx_crc_pass;
    `uvm_info(get_full_name(), $psprintf("Writing rx_padcrc_control register with data = %0d",rd_data), UVM_NONE)
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
    `uvm_info(get_full_name(), $psprintf("Writing rx_vlan_detection register with data = 0"), UVM_NONE)
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),32'h0);

   `ifdef ENABLE_ETH_VIP
      fork
       begin
        repeat(2) begin
         send_eth_frame_with_fix_size(PADDED_FRAME,62,1,ETH_VIP_AVL_RX);  
         send_eth_frame_with_fix_size(PADDED_FRAME,63,1,ETH_VIP_AVL_RX);  
         send_eth_frame_with_fix_size(PADDED_FRAME,64,1,ETH_VIP_AVL_RX);  
         send_eth_frame_with_fix_size(PADDED_FRAME,65,1,ETH_VIP_AVL_RX);  
         send_eth_frame_with_fix_size(PADDED_FRAME,66,1,ETH_VIP_AVL_RX);
        end 
        
        if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
           repeat(5) begin
             send_eth_frame_with_fix_size(PADDED_FRAME,-1,1,ETH_VIP_AVL_RX);
             send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);  
           end
  
           repeat(5) begin
             randcase
               1: send_eth_frame_with_fix_size(PADDED_FRAME,-1,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);  
             endcase
           end     
        end else begin
           repeat(50) begin
             send_eth_frame_with_fix_size(PADDED_FRAME,-1,1,ETH_VIP_AVL_RX);
             send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);  
           end
  
           repeat(100) begin
             randcase
               1: send_eth_frame_with_fix_size(PADDED_FRAME,-1,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);  
             endcase
           end
        end
       end
       begin
        if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin
	        tx_seq.start(p_sequencer.v_m_sqr);
        end else begin
           if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
             tx_seq.seq_cnt = 10;      
           end 
           tx_seq.start(p_sequencer.tx_seqr);
        end   
       end
      join 
    `else
      if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG)
	    tx_seq.start(p_sequencer.v_m_sqr);
      else 
        tx_seq.start(p_sequencer.tx_seqr);
    `endif
    
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
       #250us;
     end

  endtask
endclass: eth_padding_sequence
