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


class ptp_stats_registers_sequence extends eth_ptp_base_sequence;
  
  
  bit [9:0] total_ptp_packets, total_1_step_packets, total_2_step_packets, total_v2_packets,rx_total_ptp_ts;
  uvm_reg_data_t read_data;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address = 'h1c78;  
  bit [31:0] min_address = 'h1a68;
  int reg_index[$];

  `uvm_object_utils(ptp_stats_registers_sequence)

  function new(string name = "ptp_stats_registers_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
  super.body();

  //from stats base
 
    `uvm_info("body", "started eth_stat_base_sequence ...", UVM_NONE)
   
        `uvm_info(get_name(),$sformatf("eth_stat_base_sequence: no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)

    //Demoting common error
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    `endif

    // apply_hard_reset(0,0,1,11);
    // `ifdef CRETE3
    //   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    // `else  
    //   rx_pcs_ready_timeout();//Shabbir - FB 534015
    // `endif  

    //For tx error insertion
    //enable_tx_error_insertion();//Disabling Tx error insertion for every tests

    //muralasx: FIXME fix register code as GDR reg_model isn't available
    //rand_regs();
    
    //HSD 16011077291  : TODO : Reset valu needs to match
    //FIXME: Workaround for now is to reset the register fields manually, revisit after HSD fix
    //GDR has a new register to take care of
    p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_config_ctrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b00);

    //Need to clear stat registers as Mlab RAM is not initialized. FB 489113
    clear_stat_counters();
    #400ns;
    //p_sequencer.env.eth_ref_model_inst.dis_fc_assertion=1;
    
    //FIXME Shabbir: currently DV is not able to capture read data x, so clear parity error in any case
    //Read status regsiters for parity error
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_TX_CNTR_STATUS_OFFSET_REG,read_data_tx,1);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_RX_CNTR_STATUS_OFFSET_REG,read_data_rx,1);

    //if(read_data_tx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end
    //if(read_data_rx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end

    #100ns;
    //parity error should get cleared now
    //FIXME Shabbir: currently DV is not able to capture read data x
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_TX_CNTR_STATUS_OFFSET_REG,read_data_tx,1);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_RX_CNTR_STATUS_OFFSET_REG,read_data_rx,1);
    #0;
    //FIXME EHIP Shabbir: FB 505364, need to fix DV, scripts
    //VR//p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
    //Shabbir: disabling en_sfc/pfc, so SFC frames are not processed and traffic will not be halted on TX side even with fc1 which prevents AVST tiemout
    //VR//p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h0);

  //end from stat base

  repeat(50) begin

       send_frames();
   total_ptp_packets += 1; 
   end
 

//  p_sequencer.env.apply_reset("hard",0,0,1,11); TODO GDR
    p_sequencer.reg_model.default_map.get_registers(regs_org);
    enable_disable_anlt_reset();

        
    `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)

    foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        regs.push_back(regs_org[i]);
      end
    end

   
 
   
#100ns;
//p_sequencer.env.gdr_ral_predict(.regname("mac_stats_cntr_tx_total_1step_ptp_pkts"),.value(total_1_step_packets),.kind(UVM_PREDICT_DIRECT), .map(p_sequencer.reg_model.default_map));
p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_total_1step_ptp_pkts_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  // if (read_data != total_1_step_packets)
  //   `uvm_error(get_type_name(),$sformatf("Mismatch total number of PTP 1 step packets reg_read=%0d, total_1_step_packets=%0d", read_data, total_1_step_packets ))
  // else
  //   `uvm_info(get_type_name(),$sformatf("1 step  packets reg_read=%0d, total_1_step__packets=%0d", read_data, total_1_step_packets), UVM_MEDIUM)  



 
#700ns;

     p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_total_ptp_pkts_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
 //  if (read_data != total_ptp_packets)
 //    `uvm_error(get_type_name(),$sformatf("Mismatch total number of PTP packets reg_read=%0d, total_ptp_packets=%0d", read_data, total_ptp_packets ))
  // else
  //   `uvm_info(get_type_name(),$sformatf("total number of PTP packets reg_read=%0d, total_ptp_packets=%0d", read_data, total_ptp_packets), UVM_MEDIUM)

#700ns;
     
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_total_2step_ptp_pkts_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  // if (read_data != total_2_step_packets)
  //   `uvm_error(get_type_name(),$sformatf("Mismatch total number of PTP 2 step packets reg_read=%0d, total_2_step_packets=%0d", read_data, total_2_step_packets ))
  // else
  //   `uvm_info(get_type_name(),$sformatf("2 step packets reg_read=%0d, total_2_step__packets=%0d", read_data, total_2_step_packets), UVM_MEDIUM) 
#700ns;

  p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_total_ptp_ts_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  // if (read_data != rx_total_ptp_ts)
  //   `uvm_error(get_type_name(),$sformatf("Mismatch total number of Rx total packets reg_read=%0d, rx_total_ptp_ts=%0d", read_data,rx_total_ptp_ts ))
  // else
  //   `uvm_info(get_type_name(),$sformatf("Rx total ptp ts reg_read=%0d, rx_total_ptp_ts=%0d", read_data, rx_total_ptp_ts), UVM_MEDIUM) 
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_fec_mode_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h6); //VR: RW  TODO remove from this seq 
//#700ns;
//   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_tx_ptp_fec_mode_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//     `uvm_info(get_type_name(),$sformatf("fec mode reg_read=%0d, fec mode =6", read_data), UVM_MEDIUM) 
  
  endtask 

  task send_vip_frames();
    send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);
  endtask

  task send_frames();
   `ifdef ENABLE_ETH_VIP
      send_vip_frames();
      rx_total_ptp_ts +=1;
   `else
   randcase
   1:begin send_ptp_frame(INS_V2,DATA_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_V2_W_UDP_CS_0,DATA_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_V2_W_EB,DATA_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_CF,DATA_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
      1:begin send_ptp_frame(INS_V2_W_UDP_CS_0,VLAN_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_V2_W_EB,VLAN_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_CF,VLAN_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_CF_W_UDP_CS_0,VLAN_FRAME,1);  
      total_v2_packets += 1;   
      total_1_step_packets +=1;
     end
   1:begin send_ptp_frame(INS_CF_W_EB,VLAN_FRAME,1);
      total_v2_packets += 1;   
      total_1_step_packets +=1;  
     end
   1:begin send_ptp_frame(INS_2STEP,VLAN_FRAME,1);  
       total_v2_packets += 1;
       total_2_step_packets += 1;
     end
   endcase
 `endif
  endtask
endclass
