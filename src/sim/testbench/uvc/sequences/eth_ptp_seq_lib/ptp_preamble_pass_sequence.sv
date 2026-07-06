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


class ptp_preamble_pass_sequence extends eth_ptp_base_sequence;
  //preamble_sequence tx_seq;
     bit preamble_pass;
     bit rx_crc_pass;
     ptp_op_e ptp_op;
     frame_type f_type;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg;
  `uvm_object_utils(ptp_preamble_pass_sequence)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    //tx_seq=new("tx_seq");  
  endfunction:new

   virtual task body();
      super.body();
      `uvm_info(get_full_name(), "running ptp_preamble_pass_sequence\n",UVM_LOW)
    
      //skipping this sequence for 50G AVST because it doesnt support preamble pass through = 1 change from register
      if(!((p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) && (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC)))begin
         preamble_pass = 1;
         p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
         txmac_ehip_cfg = {rd_data[31:1],preamble_pass};
         if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough)   `uvm_error("preamble_sequence", $sformatf("mac_cfg_txmac_ehip_cfg_OFFSET_REGbit 0 value must be initialized as per parameter"));
         p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
         rxmac_ehip_cfg = {rd_data[31:1],preamble_pass};
         if(rd_data[0]!=p_sequencer.env.dyn_rcfg_obj_inst.preamble_passthrough)   `uvm_error("preamble_sequence", $sformatf("mac_cfg_rxmac_ehip_cfg_OFFSET_REGbit 0 value must be initialized as per parameter"));
      
         p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
      
         #10ns;
      
         `uvm_info("preamble_sequence", $sformatf("Setting %0d to RX,TX Preamble pass",preamble_pass), UVM_MEDIUM)
         $display("\nRXMAC_EHIP_RD_DATA_31_0=%b",txmac_ehip_cfg);
         //p_sequencer.env.reg_write(`GET_REG_ADDR(ptp_dr_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg); 
         p_sequencer.env.reg_write(`ETH_F_ALL_ptp_dr_cfg_OFFSET_REG,txmac_ehip_cfg); 
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg); 
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxmac_ehip_cfg); 
      
         p_sequencer.top_env.write_asym_p2p_latency();
         `ifdef ENABLE_ETH_VIP
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
         `endif
         fork
         begin
         repeat(200) begin
            randcase
            1:send_ptp_frame(INS_CF,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_CF_W_ASYM_LAT,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2_W_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_CF_W_ASYM_LAT,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2_W_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2_W_UDP_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2_W_ASYM_LAT,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2_W_ASYM_LAT_UDP_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_V2_W_ASYM_LAT_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_CF_W_UDP_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_CF_W_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_CF_W_ASYM_LAT_UDP_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_CF_W_ASYM_LAT_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_P2P,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_P2P_W_UDP_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_P2P_W_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_P2P_W_ASYM_LAT,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_P2P_W_ASYM_LAT_UDP_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_P2P_W_ASYM_LAT_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_ASYM_LAT,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_ASYM_LAT_CS_0,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_ASYM_LAT_EB,DATA_FRAME,1,0,1);  
            1:send_ptp_frame(INS_2STEP,DATA_FRAME,1); 
            endcase
         end
         end
         begin
         `ifdef ENABLE_ETH_VIP
            send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,100);  
         `else
            #1us;
         `endif
         end
         join
      end else begin
         `uvm_info("preamble_sequence", $sformatf("Skipping preamble pass sequence for speed %s and interface %s",p_sequencer.env.dyn_rcfg_obj_inst.speed.name(),p_sequencer.env.dyn_rcfg_obj_inst.mode.name()), UVM_MEDIUM)      
      end
   endtask
endclass
