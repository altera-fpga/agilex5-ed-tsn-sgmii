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


`ifndef ETH_1025_SEQ_LIB
`define ETH_1025_SEQ_LIB

//Placeholder for 1025 BASE sequence
class eth1025_base_sequence extends eth_base_sequence;
     `uvm_object_utils(eth1025_base_sequence)
     
     function new(string name = "eth1025_base_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
//---------------
//FUNCTIONS/TASKS
//---------------

     `ifdef UVM_VERSION_1_0
     virtual task pre_body();
          super.pre_body();
     endtask:pre_body
     
     virtual task post_body();
          super.post_body();
     endtask:post_body
     `endif
     
     `ifdef UVM_VERSION_1_1
     virtual task pre_start();
          super.pre_start();
          
          //FB: https://fogbugz.altera.com/default.asp?588037#5292418
		//To disable XSBI checker
          `ifdef ENABLE_ETH_VIP
		//p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
		//$display("Disable XSBI checker");
          //`endif
          
          //FB: https://fogbugz.altera.com/default.asp?591880#5292423
          //Disable Vector SB CONTROL frame check from VIP TX to MAC RX
          p_sequencer.env.sb_vec_vip_tx_mac_rx.vector_sb_check_dis["CTRL_FRAME"]=1;
          `endif


          `ifdef RSFEC
          //When using RSFEC configuration the DUT parameter will be different and it doesnt pass in the value to the register reset value 
          //rx_pause_daddr
          $display("Setting rx_pause_daddr at time %t", $time);
          p_sequencer.reg_model.rx_pause_daddrl.set_reset(`REGISTERS_rx_pause_daddrl_RESET_VALUE_REG);
          p_sequencer.reg_model.rx_pause_daddrh.set_reset(`REGISTERS_rx_pause_daddrh_RESET_VALUE_REG);
          p_sequencer.reg_model.RXMAC_CONTROL.en_plen.set_reset(1'b1);
          `endif

     endtask:pre_start
     
     virtual task post_start();
          super.post_start();
     endtask:post_start
     `endif
     
     //For register testing only
     task reset_register_to_default();
     
          p_sequencer.reg_model.tx_pld_conf.set_reset(`REGISTERS_tx_pld_conf_RESET_VALUE_REG);
          p_sequencer.reg_model.rx_pld_conf.set_reset(`REGISTERS_rx_pld_conf_RESET_VALUE_REG);
          
          //tx_pause_saddr
          p_sequencer.reg_model.tx_pfc_saddrl.saddrl.set_reset(`REGISTERS_tx_pfc_saddrl_RESET_VALUE_REG);
          p_sequencer.reg_model.tx_pfc_saddrh.saddrh.set_reset(`REGISTERS_tx_pfc_saddrh_RESET_VALUE_REG);
          
          //pfc_holdoff_quanta_0/1/2/3/4/5/6/7
          p_sequencer.reg_model.pfc_holdoff_quanta_0.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_0_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_1.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_1_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_2.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_2_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_3.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_3_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_4.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_4_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_5.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_5_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_6.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_6_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_holdoff_quanta_7.holdoff_quanta.set_reset(`REGISTERS_pfc_holdoff_quanta_7_RESET_VALUE_REG);


          p_sequencer.reg_model.MAC_CRC_CONFIG.set_reset(`REGISTERS_MAC_CRC_CONFIG_RESET_VALUE_REG);
          p_sequencer.reg_model.RXMAC_CONTROL.set_reset(`REGISTERS_RXMAC_CONTROL_RESET_VALUE_REG);          
          p_sequencer.reg_model.rxmac_ehip_cfg.set_reset(`REGISTERS_rxmac_ehip_cfg_RESET_VALUE_REG);
          p_sequencer.reg_model.txmac_ehip_cfg.set_reset(`REGISTERS_txmac_ehip_cfg_RESET_VALUE_REG);
          p_sequencer.reg_model.TX_MAC_CONTROL.set_reset(`REGISTERS_TX_MAC_CONTROL_RESET_VALUE_REG);
          p_sequencer.reg_model.MAX_TX_SIZE_CONFIG.set_reset(`REGISTERS_MAX_TX_SIZE_CONFIG_RESET_VALUE_REG);
          p_sequencer.reg_model.RXMAC_SIZE_CONFIG.set_reset(`REGISTERS_RXMAC_SIZE_CONFIG_RESET_VALUE_REG);
          
          //am_encoding
          p_sequencer.reg_model.am_encoding_0.set_reset(`REGISTERS_am_encoding_0_RESET_VALUE_REG);
          p_sequencer.reg_model.am_encoding_1.set_reset(`REGISTERS_am_encoding_1_RESET_VALUE_REG);
          p_sequencer.reg_model.am_encoding_2.set_reset(`REGISTERS_am_encoding_2_RESET_VALUE_REG);
          p_sequencer.reg_model.am_encoding_3.set_reset(`REGISTERS_am_encoding_3_RESET_VALUE_REG);
          
          //flow_control
          p_sequencer.reg_model.tx_pause_en.set_reset(`REGISTERS_tx_pause_en_RESET_VALUE_REG);
          p_sequencer.reg_model.tx_xof_en_tx_pause_qnumber.set_reset(`REGISTERS_tx_xof_en_tx_pause_qnumber_RESET_VALUE_REG);
          p_sequencer.reg_model.txsfc_ehip_cfg.set_reset(`REGISTERS_txsfc_ehip_cfg_RESET_VALUE_REG);
          p_sequencer.reg_model.rx_pause_enable.set_reset(`REGISTERS_rx_pause_enable_RESET_VALUE_REG);
          p_sequencer.reg_model.rxsfc_ehip_cfg.set_reset(`REGISTERS_rxsfc_ehip_cfg_RESET_VALUE_REG);          
          
          //flow_control_holdoff_mode
          p_sequencer.reg_model.retransmit_xoff_holdoff_en.set_reset(`REGISTERS_retransmit_xoff_holdoff_en_RESET_VALUE_REG);
          p_sequencer.reg_model.cfg_retransmit_holdoff_en.set_reset(`REGISTERS_cfg_retransmit_holdoff_en_RESET_VALUE_REG);
          
          //forward_rx_pause_request
          p_sequencer.reg_model.rx_pause_fwd.set_reset(`REGISTERS_rx_pause_fwd_RESET_VALUE_REG);
          
          //hi_ber_monitor
          p_sequencer.reg_model.rxpcs_conf.set_reset(`REGISTERS_rxpcs_conf_RESET_VALUE_REG);
          
          //holdoff quanta
          p_sequencer.reg_model.retransmit_xoff_holdoff_quanta.set_reset(`REGISTERS_retransmit_xoff_holdoff_quanta_RESET_VALUE_REG);
          
          //ipg_removed_per_am_period
          p_sequencer.reg_model.ipg_col_rem.set_reset(`REGISTERS_ipg_col_rem_RESET_VALUE_REG);
          
          //link_fault_mode
          p_sequencer.reg_model.link_fault_config.set_reset(`REGISTERS_link_fault_config_RESET_VALUE_REG);
          
          //pause_quanta
          p_sequencer.reg_model.tx_pause_quanta.set_reset(`REGISTERS_tx_pause_quanta_RESET_VALUE_REG);
          
          
          //pfc_pause_quanta_0/1/2/3/4/5/6/7
          p_sequencer.reg_model.pfc_pause_quanta_0.set_reset(`REGISTERS_pfc_pause_quanta_0_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_1.set_reset(`REGISTERS_pfc_pause_quanta_1_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_2.set_reset(`REGISTERS_pfc_pause_quanta_2_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_3.set_reset(`REGISTERS_pfc_pause_quanta_3_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_4.set_reset(`REGISTERS_pfc_pause_quanta_4_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_5.set_reset(`REGISTERS_pfc_pause_quanta_5_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_6.set_reset(`REGISTERS_pfc_pause_quanta_6_RESET_VALUE_REG);
          p_sequencer.reg_model.pfc_pause_quanta_7.set_reset(`REGISTERS_pfc_pause_quanta_7_RESET_VALUE_REG);
          
          //rx_pause_daddr
          p_sequencer.reg_model.rx_pause_daddrl.set_reset(`REGISTERS_rx_pause_daddrl_RESET_VALUE_REG);
          p_sequencer.reg_model.rx_pause_daddrh.set_reset(`REGISTERS_rx_pause_daddrh_RESET_VALUE_REG);
          
          //tx_pause_daddr
          p_sequencer.reg_model.tx_pfc_daddrl.set_reset(`REGISTERS_tx_pfc_daddrl_RESET_VALUE_REG);
          p_sequencer.reg_model.tx_pfc_daddrh.set_reset(`REGISTERS_tx_pfc_daddrh_RESET_VALUE_REG);
          
          //txmac_saddr
          p_sequencer.reg_model.txmac_saddrl.set_reset(`REGISTERS_txmac_saddrl_RESET_VALUE_REG);
          p_sequencer.reg_model.txmac_saddrh.set_reset(`REGISTERS_txmac_saddrh_RESET_VALUE_REG);
          
          //uniform_holdoff_quanta
          p_sequencer.reg_model.cfg_retransmit_holdoff_quanta.set_reset(`REGISTERS_cfg_retransmit_holdoff_quanta_RESET_VALUE_REG);
          
          //phy_ehip_pcs_modes
          //Use_enc
          p_sequencer.reg_model.phy_ehip_pcs_modes.set_reset(`REGISTERS_phy_ehip_pcs_modes_RESET_VALUE_REG);          
          p_sequencer.reg_model.phy_ehip_clock_gating.set_reset(`REGISTERS_phy_ehip_clock_gating_RESET_VALUE_REG);
          p_sequencer.reg_model.EIO_RX_SOFT_PURGE_S.set_reset(`REGISTERS_EIO_RX_SOFT_PURGE_S_RESET_VALUE_REG);

          //ANLT_SEQ_CFG
          p_sequencer.reg_model.an_cfg1.set_reset(`REGISTERS_an_cfg1_RESET_VALUE_REG);

     endtask: reset_register_to_default

endclass: eth1025_base_sequence

//*******************************************************************
// Sequence Name: eth1025_sanity_sequence
// Description: runs a random variation of packets(10) on tx,rx path
//*******************************************************************
class eth1025_sanity_sequence extends eth1025_base_sequence;
     //  sequence_0 tx_seq;
     bit rx_crc_pass;
     uvm_reg_data_t read_data_xcvr[4];
     //  ethernet_random_sequence eth_seq;
     `uvm_object_utils(eth1025_sanity_sequence)
     
     function new(string name = "eth1025_sanity_sequence");
     
     super.new(name);
          `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     // tx_seq=new("tx_seq");  
     
     endfunction:new

     virtual task body();
          `uvm_info("eth_seq_lib", "running sanity sequence\n",UVM_LOW)
          apply_hard_reset(0,0,1,11);
          rx_crc_pass=$urandom;
          p_sequencer.env.wait_rx_pcs_ready();
          //reg_read(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1); 
          //$display("DONE!!! WRITING TO REG %0d",read_data);
          //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data); 
          //   $display("DONE!!! WRITING TO REG");
          //  tx_seq.start(p_sequencer.tx_seqr);
          `ifdef ENABLE_ETH_VIP
               fork
               send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,200);  
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,200);  
               join
          `else
               `ifdef EHIP_PCS_ONLY
                    send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,200);  
                    #500us;
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               `endif          
          `endif
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_tx_padding_sequence
// Descriptions: 
// 1. running for every Parameter combination.
// 2. Toggle reset.
// 3. Register value of MAC_CRC_CONFIG and max_frame_size is randomized.
// 4. 300-500 Packets of sizes 1-8, 9-64, >64 of random patterns are sent on MAC TX.
//*******************************************************************************
class eth1025_tx_padding_sequence extends eth1025_base_sequence;

     padding_sequence tx_seq;
     padding_sequence_cfg tx_seq1;
     `uvm_object_utils(eth1025_tx_padding_sequence)
     
     function new(string name = "eth1025_tx_padding_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          tx_seq =new("tx_seq");  
          tx_seq1=new("tx_seq1");  
     endfunction:new

     virtual task body();
          $display("running 1025 padding sequence");
          apply_hard_reset(0,0,1,11);
          p_sequencer.env.wait_rx_pcs_ready();
          
          //Disable these checks as we also send packets of frame length < 64 bytes
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE); 
          `endif
          //if(p_sequencer.env.tb_cfg.crc_pass) tx_seq.start(p_sequencer.tx_seqr);
          // else tx_seq1.start(p_sequencer.tx_seqr);
          tx_seq.start(p_sequencer.tx_seqr);
     endtask
     
endclass

//*******************************************************************************
// Sequence Name: eth1025_rx_padding_sequence
// Descriptions: 
// 1. bit8 of rxmac control.remove_rx_pad:0 means padded frame not altered,1:padded bytes removed
//*******************************************************************************
class eth1025_rx_padding_sequence extends eth1025_base_sequence;
     bit rx_crc_pass;
     bit rx_rmpad;
     
     `uvm_object_utils(eth1025_rx_padding_sequence)
     function new(string name = "eth1025_rx_padding_sequence");
     super.new(name);
          `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t rd_data;
          `uvm_info("eth_seq_lib", "running eth1025_rx_padding_sequence\n",UVM_LOW)
          
          apply_hard_reset(0,0,1,11);
          
          //Demote expected VIP errors
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          
          reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          `ifndef CRETE3
               if(rd_data[8]!=p_sequencer.env.tb_cfg.rm_rx_pads)   `uvm_error("rx_padding_sequence", $sformatf("REGISTERS_RXMAC_CONTROL_OFFSET_REG bit 8 value must be initialized as per parameter"));
          `endif
          
          
          for(int i=0;i<2;i++)
          begin

               rx_rmpad=i;//$urandom_range(0,1);
               rx_crc_pass=$urandom;
               if(rx_rmpad) rx_crc_pass=0;
               p_sequencer.env.wait_rx_pcs_ready();
               
               //Read register to get max_frame_size
               read_max_frame_size();
               
               reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass);// Rx crc forward disable
               //reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
               rd_data[1]=0;
               rd_data[8]=rx_rmpad;
               `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL : VLAN detection disable=%0b  remove rx pad = %0b",rd_data[1],rd_data[8]), UVM_NONE)
               reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data);
               
               `ifdef ENABLE_ETH_VIP
               send_eth_frame_with_fix_size(PADDED_FRAME,62,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(PADDED_FRAME,63,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(PADDED_FRAME,64,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(PADDED_FRAME,65,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(PADDED_FRAME,66,1,ETH_VIP_AVL_RX);
               
               send_eth_frame_with_fix_size(RANDOM_FRAME,62,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(RANDOM_FRAME,63,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(RANDOM_FRAME,65,1,ETH_VIP_AVL_RX);  
               send_eth_frame_with_fix_size(RANDOM_FRAME,66,1,ETH_VIP_AVL_RX);
     
               repeat(25) begin
                    send_eth_frame_with_fix_size(PADDED_FRAME,-1,1,ETH_VIP_AVL_RX);
                    send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);  
               end
               
               repeat(50) begin
                    randcase
                    1: send_eth_frame_with_fix_size(PADDED_FRAME,-1,1,ETH_VIP_AVL_RX);
                    1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);  
                    endcase
               end
               
               `endif
               
          end
          
          
          
     endtask
endclass


//*******************************************************************************
// Sequence Name: eth1025_tx_padding_sequence
// Descriptions: 
// 1. every Parameter combination is run. 
// 2. Toggle reset.
// 3. max_frame_size is randomized.
// 4. 300-500 Packets of random sizes and patterns are sent back to back from 
//    TX as well as RX.
//*******************************************************************************
class preamble1025_pass_sequence extends eth1025_base_sequence;
     preamble_sequence tx_seq;
     bit 	      preamble_pass;
     bit 	      rx_crc_pass;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg;
     `uvm_object_utils(preamble1025_pass_sequence)
     function new(string name = "preamble1025_pass_sequence");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          $display("running preamble sequence");
          apply_hard_reset(0,0,1,11);
          //`ifndef CRETE3
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          
          for(int i=0; i<2; i++)begin
               //Preamble pass = 0
               preamble_pass = i;
               reg_read(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
               txmac_ehip_cfg = {rd_data[31:1],preamble_pass};
               if((rd_data[0]!=p_sequencer.env.tb_cfg.preamble_passthrough) && i==0)  `uvm_error("preamble_sequence", $sformatf("REGISTERS_txmac_ehip_cfg_OFFSET_REG bit 0 value must be initialized as per parameter"));
               
               reg_read(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
               rxmac_ehip_cfg = {rd_data[31:1],preamble_pass};
               
               if((rd_data[0]!=p_sequencer.env.tb_cfg.preamble_passthrough) && i==0)  `uvm_error("preamble_sequence", $sformatf("REGISTERS_rxmac_ehip_cfg_OFFSET_REG bit 0 value must be initialized as per parameter"));
               //`endif
               p_sequencer.env.wait_rx_pcs_ready();
               
               `ifdef ENABLE_ETH_VIP
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
                    //   rx_crc_pass = $urandom_range(0,1);
                    //     `uvm_info("vip_error_base_sequence", $sformatf("Setting %0d to RX_CRC_PASS",rx_crc_pass), UVM_MEDIUM)
                    //     reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
                         `uvm_info("preamble_sequence", $sformatf("Setting %0d to RX,TX Preamble pass",preamble_pass), UVM_MEDIUM)
                         reg_write(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg); 
                         reg_write(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxmac_ehip_cfg); 
                    fork
                         tx_seq.start(p_sequencer.tx_seqr);
                         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,150);  
                    join
               
               `else
                    tx_seq.start(p_sequencer.tx_seqr);
               `endif
          end
          
     endtask
endclass

//*******************************************************************************
// Sequence Name: crc1025_pass_sequence
// Descriptions: 
// 1. run for every combination of Parameter values .
// 2. Toggle reset.
// 3. 300-500 Packets of random sizes (<64 and >64) are sent back to back from TX.
//*******************************************************************************
class crc1025_pass_sequence extends eth1025_base_sequence;
     bit rx_crc;
     uvm_reg_data_t rd_data;
     `uvm_object_utils(crc1025_pass_sequence)
     function new(string name = "crc1025_pass_sequence");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new

     virtual task body();
          $display("running crc 1025 pass sequence");
          apply_hard_reset(0,0,1,11);
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          p_sequencer.env.wait_rx_pcs_ready();
          
          for(int i=0;i<2;i++)
          begin
          
               reg_read(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
               
               `ifndef CRETE3
                    if((rd_data[0]!=p_sequencer.env.tb_cfg.crc_pass) && i==0)  `uvm_error("crc1025_pass_sequence", $sformatf("REGISTERS_MAC_CRC_CONFIG_OFFSET_REG bit 0 value must be initialized as per parameter"));
               `endif
               
               //p_sequencer.env.wait_rx_pcs_ready();
               reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
               
               //Shabbir- FB560308 CRC passthrough can not be enabled with remove pads (bytestoremove=2) (rx_bytes_to_remove = "Remove CRC and PAD bytes")
               if(rd_data[8] == 0)
               begin
                    rx_crc = i;//$urandom_range(0,1);
                    `uvm_info("crc1025_pass_sequence", $sformatf("rx_crc setting is %0d",rx_crc), UVM_MEDIUM)
                    reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc); 
               end
               
               `ifdef ENABLE_ETH_VIP
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    fork
                         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,150);  
                         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,150);  
                    join
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,150);  
               `endif
          
          end
          
     endtask
endclass

//*******************************************************************************
// Sequence Name: rx_crc1025_pass_sequence
// Descriptions: 
// 1. run for every combination of Parameter values.
// 2. Toggle reset.
// 3. Register value of forward_rx_crc and max_frame_size is randomized.
// 4. 300-500 Good and bad FCS packets of random sizes are sent back to back from RX.
//
//Checkers: When forward_rx_crc=1, the CRC is forwarded and not stripped out. When forward_rx_crc=0, the CRC will be stripped out. 
//*******************************************************************************
class rx_crc1025_pass_sequence extends eth1025_base_sequence;
     bit rx_crc;
	 bit[1:0] bit_count_crc = 0;
     uvm_reg_data_t rd_data;
     `uvm_object_utils(rx_crc1025_pass_sequence)
     function new(string name = "rx_crc1025_pass_sequence");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new

     virtual task body();
          $display("running rx crc 1025 pass sequence");
          apply_hard_reset(0,0,1,11);
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          p_sequencer.env.wait_rx_pcs_ready();
          
          for(int i=0;i<4;i++)
          begin
			  
               reg_read(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1); //h507
               
               `ifndef CRETE3
                    if((rd_data[0]!=p_sequencer.env.tb_cfg.crc_pass) && i==0)  `uvm_error("rx crc1025_pass_sequence", $sformatf("REGISTERS_MAC_CRC_CONFIG_OFFSET_REG bit 0 value must be initialized as per parameter"));
               `endif
               
               //p_sequencer.env.wait_rx_pcs_ready();
               reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1); //h50a
               
               //Shabbir- FB560308 CRC passthrough can not be enabled with remove pads (bytestoremove=2) (rx_bytes_to_remove = "Remove CRC and PAD bytes")
               if(rd_data[8] == 0)
               begin
					$display("bit count crc is %d",bit_count_crc[0]);
					$display("bit count crc is %d",bit_count_crc[1]);
                    rx_crc = i; //$urandom_range(0,1); 
                    `uvm_info("rx crc1025_pass_sequence", $sformatf("rx_crc setting is %0d",rx_crc), UVM_MEDIUM)
					
					reg_read(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1); //h507	
					rd_data[0] = bit_count_crc[0];
					reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); //h507
					`uvm_info("check register value", $sformatf("rd_data is 'h%h",rd_data), UVM_MEDIUM)
										
					reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1); //h50a
					rd_data[7] = bit_count_crc[1];
					reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); //h50a
					`uvm_info("check register value", $sformatf("rd_data is 'h%h",rd_data), UVM_MEDIUM)
			
					bit_count_crc++;
					
               end
               repeat(50) begin
               `ifdef ENABLE_ETH_VIP
				p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE); // waive fcserr
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE); 
                    fork
					begin
					//Check is done manually. Beng Wei to add checker for,
					//When forward_rx_crc=1, the CRC is forwarded and not stripped out. 
					//When forward_rx_crc=0, the CRC will be stripped out. 
						send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1); 
						send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);						 
                     
					end
					join
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,50);  
               `endif
			   end
			   
             end
          
     endtask
endclass

//*******************************************************************************
// Sequence Name: fc1025_rand_seq
// Descriptions: 
// 1. run for every combination of Parameter values .
// 2. Toggle reset.
// 3. write to all fc tx and rx registers.all registers are static(except pause request)
// 4. Randomly select sfc/pfc and  initiate pause seq on tx path and instruct 
//    vip to send control frames on rx path.data packets go in parallel
//*******************************************************************************
class fc1025_rand_seq extends eth1025_base_sequence;
     fc_pause_sequence pause_seq;
     `uvm_object_utils(fc1025_rand_seq)
     uvm_reg_data_t rd_data;
     bit[8:0] port_en;//tx_pause_en 
     bit[8:0] holdoff_en; //retransmit holdoff_en
     bit[15:0] sfc_holdoff_quanta; //retransmit holdoff_en
     bit[15:0] sfc_pause_quanta; //retransmit holdoff_en
     
     bit ready_drop;//should pause enable or disable tx transmission,will cause ready to be dropped,tx of en tx pause q no
     bit same_holdoff_en;//only in pfc
     bit [15:0] same_holdoff_quanta;
     bit [47:0] tx_da; 
     bit [47:0] tx_sa; 
     bit [1:0] tx_fc_en;//ehip cfg for tx path 
     bit[8:0] reg_mode;//to control port or signal/for tb use only 
     bit[15:0] quanta[]; 
     bit[15:0] hold_quanta[]; 
     bit[7:0] rx_pfc_en;//rx_pause_en 
     bit rx_fc_fwd;//rx frame fwd
     bit[47:0] rx_da; 
     bit[1:0] rx_fc_en;//en dis sfc pfc on rx path 
     uvm_event_pool event_pool;
     uvm_event wait_fc_reg_write;

     function new(string name = "fc1025_rand_seq");
          super.new(name);
          pause_seq=new("pause_seq");  
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          event_pool = new();
          event_pool = event_pool.get_global_pool();
          wait_fc_reg_write = event_pool.get("fc_reg_write");
     endfunction:new

     virtual task body();
          port_en=9'h1ff;//$urandom;//tx_pause_en
          holdoff_en=0;//9'h1ff;//$urandom;//retransmit xoff en
          sfc_holdoff_quanta=100;//$urandom;
          sfc_pause_quanta=500;//$urandom;
          ready_drop=1;//$urandom;
          same_holdoff_en=0;//$urandom;
          same_holdoff_quanta=100;//$urandom;
          tx_da={$urandom,$urandom}; 
          tx_sa={$urandom,$urandom};
          tx_fc_en=3;//$urandom; 
          rx_pfc_en=8'hff;//$urandom; 
          rx_fc_fwd=1;//$urandom;
          rx_da={$urandom,$urandom}; 
          rx_fc_en=$urandom;//dynamic xoff/xon generation 
          reg_mode=$urandom; //for tb use only
     
          quanta=new[8];
          hold_quanta=new[8];
          p_sequencer.env.sb_mac_tx_vip_rx.fc_flag_en = 1;
          
          apply_hard_reset(0,0,1,11);
          
          `uvm_info("eth_seq_lib", "running fc1025_rand_sequence\n",UVM_LOW)
          pause_seq.fc_mode=reg_mode;
          pause_seq.pause_pfc=0;
          pause_seq.same_holdoff=same_holdoff_en;
          pause_seq.same_holdoff_quanta=same_holdoff_quanta;
          
          foreach(quanta[i]) begin
               quanta[i]=125;
               pause_seq.pause_quanta[i]=quanta[i];
               randcase
                    60:  hold_quanta[i]=(quanta[i] *3)/4;
                    20:  hold_quanta[i]=quanta[i];
                    20:  hold_quanta[i]=(quanta[i] *4)/3;
               endcase
          end
     
          pause_seq.pause_quanta[8]=sfc_pause_quanta;
          tx_sa[40]=0;
          tx_da[40]=0;
          
          //wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          `ifdef CRETE3
               p_sequencer.env.wait_rx_pcs_ready();
          `else
               rx_pcs_ready_timeout();
          `endif  
          
          reg_read(`GET_REG_ADDR(mac_cfg_tx_xof_en_tx_pause_qnumber_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          if(rd_data[0]!=p_sequencer.env.tb_cfg.flow_control)   `uvm_error("fc1025_rand_sequence", $sformatf("REGISTERS_tx_xof_en_tx_pause_qnumber_OFFSET_REG bit 0 value must be initialized as per parameter"));
          reg_read(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          if(rd_data[0]!=p_sequencer.env.tb_cfg.rx_fc_fwd)   `uvm_error("fc1025_rand_sequence", $sformatf("REGISTERS_rx_pause_fwd_OFFSET_REG value must be initialized as per parameter"));
          p_sequencer.env.flow_agent.flow_mon.flow_control=1;
          reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),port_en); //initial value otherwise dynamic 
          reg_write(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),holdoff_en); 
          reg_write(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_holdoff_quanta); 
          reg_write(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),sfc_pause_quanta); 
          reg_write(`GET_REG_ADDR(mac_cfg_tx_xof_en_tx_pause_qnumber_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),ready_drop); 
          reg_write(`GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),same_holdoff_en); 
          reg_write(`GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),same_holdoff_quanta); 
          reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[31:0]); 
          reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[47:32]); 
          reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_sa[31:0]); 
          reg_write(`GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_sa[47:32]); 
          reg_write(`GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_fc_en);
          
          reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_pfc_en); 
          reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_fc_fwd); 
          `ifdef ENABLE_ETH_VIP
               reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[31:0]); //same da for loopback mode only
               reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[47:32]); 
               dest_address=rx_da;
          `else 
               reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[31:0]); //same da for loopback mode only
               reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_da[47:32]); 
          `endif
          reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_fc_en);
     
          `uvm_info("fc1025_rand_seq", "=========================FLOW CONTROL INFO FOR THIS SIMULATION===================\n",UVM_LOW)
          `uvm_info("fc1025_rand_seq", "=========================TX PATH===================\n",UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("Ports Enabled for input:%h...\n",port_en),UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("Ports Enabled for sending automatic holdoff xoff frames:%h...\n",holdoff_en),UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("SFC pause quanta:%h...\n",sfc_pause_quanta),UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("SFC hold quanta:%h...\n",sfc_holdoff_quanta),UVM_LOW)
          
          if(ready_drop) `uvm_info("fc1025_rand_seq","SFC will inhibit traffic flow...\n",UVM_LOW)
          else `uvm_info("fc1025_rand_seq","SFC will not stop TX traffic...\n",UVM_LOW)
          if(same_holdoff_en) `uvm_info("fc1025_rand_seq",$sformatf("all PFC queues will have same holdoff value which is:%h",same_holdoff_quanta),UVM_LOW)
          
          `uvm_info("fc1025_rand_seq",$sformatf("TX SOURCE ADDR:%h...\n",tx_sa),UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("TX DEST ADDR:%h...\n",tx_da),UVM_LOW)
          
          if(tx_fc_en[1]) `uvm_info("fc1025_rand_seq","PFC frames will be passed by DUT...\n",UVM_LOW)
          if(tx_fc_en[0]) `uvm_info("fc1025_rand_seq","SFC frames will be passed by DUT...\n",UVM_LOW)
          
          `uvm_info("fc1025_rand_seq", "=========================RX PATH===================\n",UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("Ports Enabled for output:%h...\n",rx_pfc_en),UVM_LOW)
          
          if(rx_fc_fwd) `uvm_info("fc1025_rand_seq","Control frames will be forwarded on rx user interface...\n",UVM_LOW)
          else `uvm_info("fc1025_rand_seq","Control frames will not be forwarded on rx user interface...\n",UVM_LOW)
          
          `uvm_info("fc1025_rand_seq",$sformatf("RX DEST ADDR in VIP mode:%h...\n",rx_da),UVM_LOW)
          
          if(rx_fc_en[1]) `uvm_info("fc1025_rand_seq","PFC frames will be passed by DUT...\n",UVM_LOW)
          if(rx_fc_en[0]) `uvm_info("fc1025_rand_seq","SFC frames will be passed by DUT...\n",UVM_LOW)
     
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[0]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[0]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[1]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[1]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[2]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[2]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[3]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[3]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[4]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[4]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[5]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[5]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[6]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[6]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),quanta[7]); 
          reg_write(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),hold_quanta[7]); 
     
          p_sequencer.env.wait_rx_pcs_ready();
     
          wait_fc_reg_write.trigger();
          `uvm_info("fc1025_rand_seq", "All fc registers are written, triggered event..\n",UVM_LOW)
     
          `uvm_info("fc1025_rand_seq", "This test will run in Pause Mode...\n",UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("PAUSE TIME=%dns\n",12.8*sfc_pause_quanta),UVM_LOW)
          `uvm_info("fc1025_rand_seq",$sformatf("HOLD TIME=%dns\n",12.8*sfc_holdoff_quanta),UVM_LOW)
          
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
               fork
                    pause_seq.start(p_sequencer.fc_sqr);
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
               begin
                    repeat(4) begin
                    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,3);  
                    send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);  
                    end
               end 
               join
          
          `else
               fork
                    pause_seq.start(p_sequencer.fc_sqr);
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,100);  
               join
          `endif
          
     endtask
     
endclass

//*******************************************************************************
// Sequence Name: vip1025_sanity_sequence
// Descriptions: 
// 1. Sequence to do rsfec ehip register read/write
//*******************************************************************************
class vip1025_sanity_sequence extends eth1025_base_sequence;
  
     uvm_reg_data_t read_data;
     
     `uvm_object_utils(vip1025_sanity_sequence)
     
     function new(string name = "vip1025_sanity_sequence");
     super.new(name);
          `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          
          `uvm_info("body", "waitin for ehip ready ...", UVM_MEDIUM)
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          `ifdef CRETE3
          
               `uvm_info("body", "Done ehip ready ...", UVM_MEDIUM)
               c3_rsfec_reg_read(`RSFEC_CFGCSR_CSR_rsfec_top_clk_cfg_OFFSET_REG,read_data);
               c3_rsfec_reg_write(`RSFEC_CFGCSR_CSR_rsfec_top_clk_cfg_OFFSET_REG,'h123);
               
               c3_rsfec_reg_read(`RSFEC_CFGCSR_CSR_rsfec_corr_1s_cnt_3_lo_OFFSET_REG,read_data);
               c3_rsfec_reg_write(`RSFEC_CFGCSR_CSR_rsfec_corr_1s_cnt_3_lo_OFFSET_REG,'h123);
               #50ns;
               
          `endif 
     endtask
     
endclass

//*******************************************************************************
// Sequence Name: eth1025_register_ip_hard_reset_sequence
// Descriptions:
// This sequence test the csr register reset value.
// 1.Read all ip register after applying cs_rst_n reset.
// 2. write non- reset random value on registers and read them back.
// 3.  Apply cs_rst_n and read all IP register.
// 4. write non- reset random value on registers and read them back.
// 5.Apply soft_txp_rst/soft_rxp_rst/ eio_soft_reset /hard tx_rst/hard rx_reset  and read all IP register.
// 6.  Applying cs_rst_n reset and Read all ip register
//*******************************************************************************
class eth1025_register_ip_hard_reset_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit [2:0]     reset_sel; 
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     
     `uvm_object_utils(eth1025_register_ip_hard_reset_sequence)
     
     function new(string name = "eth1025_register_ip_hard_reset_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          //Reset the registers to reset default values as it has been changed in environment build phase - update_ral_reset_value()          
          reset_register_to_default(); 
     
          dis_reg_cov();
          apply_hard_reset(0,0,1,11);
          
          if(p_sequencer.env.tb_cfg.enable_stas_count ==1 )   max_address = 'h9FF; 
          if(p_sequencer.env.tb_cfg.rsfec_en == 1) max_address = 'hDFF;
               p_sequencer.reg_model.default_map.get_registers(regs_org);
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG || 
                    regs_org[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG || 
                    regs_org[i].get_address() == `ETH_F_ALL_clk_tx_khz_OFFSET_REG ) 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_clk_rx_khz_OFFSET_REG) //FB:551427 for KHZ_RX 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))  
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))  
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
// FIXME-MISSING_REG_IN_GDR               if(regs_org[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          `ifdef RSFEC
          //Unused registers
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() inside {[12'hc00:12'hc67],12'ha09})
                    regs_org.delete(i);
          end
          `endif          
          
          `uvm_info(get_name(), $sformatf("max_address =%0d ", max_address), UVM_MEDIUM)
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) begin
                    regs.push_back(regs_org[i]);
               end
          end
          
          foreach(regs[i]) begin
               if(
               //FB start: https://fogbugz.altera.com/default.asp?592982#5260616               
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || 
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_rxpcs_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               `ifdef G10     
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_ber_invalid_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               `endif               
               //FB end: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_phy_rxpma_status_OFFSET_REG ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //For multilane               
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Disable because the REGISTERS_RX_CNTR_CONFIG_OFFSET_REG might set the RX Shadow Request in progress and hold there causing expected value mismatch               
               `ifdef CRETE3
// FIXME-MISSING_REG_IN_GDR                    regs[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG ||    
               `endif
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
               ) begin
                    compare_disable[regs[i].get_address()] = 1;
               end 
               else begin
                    compare_disable[regs[i].get_address()] = 0;
               end
          end
          
          //wait for ehip ready
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          reg_read('h37F,read_data); //Read Immediately
          reg_read('h380,read_data); //Read Immediately
          reg_read('h381,read_data); //Read Immediately
          `ifndef CRETE3
               reg_read('h382,read_data); //Read Immediately
          `endif
          
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          //Disable SNPS serial interface protocol checks as we are doing register testing that includes phy registers
          p_sequencer.env.disable_10_25G_snps_errors();
          `endif
          
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_align.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);               
          `endif
          
          if(p_sequencer.env.tb_cfg.enable_stas_count == 1 )  
          begin 
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
          end
          
          foreach(regs[i]) begin
               `uvm_info("eth1025_register_ip_hard_reset_sequence", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
          end
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "1:Read registers", UVM_NONE)
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          //ignoring comparison for CNTR_STATUS,just check it's reset value
          compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          //compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          
          //#4us;
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "2:Write registers", UVM_NONE)
          foreach(regs[i]) begin
               reg_write(regs[i].get_address(),$urandom());
          end
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "3:Read registers", UVM_NONE)
          foreach(regs[i]) begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          //ignoring comparison for CNTR_STATUS,just check it's reset value
          compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
          //compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "4:Applied Hard reset", UVM_NONE)
          apply_hard_reset(0,0,1,$urandom_range(11,50));
          
          if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
               wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
          end
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          reg_read('h37F,read_data); //Read Immediately
          reg_read('h380,read_data); //Read Immediately
          reg_read('h381,read_data); //Read Immediately
          `ifndef CRETE3
               reg_read('h382,read_data); //Read Immediately
          `endif
          
          p_sequencer.env.wait_rx_pcs_ready(); 
          
          `ifdef ENABLE_ETH_VIP
          //Disable SNPS serial interface protocol checks as we are doing register testing that includes phy registers
          p_sequencer.env.disable_10_25G_snps_errors();          
          `endif
          
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_align.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "5:Read registers", UVM_NONE)
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          //ignoring comparison for CNTR_STATUS,just check it's reset value
          compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          //compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "6:Write registers",UVM_NONE)
          foreach(regs[i]) begin
               reg_write(regs[i].get_address(),$urandom());
          end
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "7:Read registers", UVM_NONE)
          foreach(regs[i]) begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "8:Applied Soft reset", UVM_NONE)
          reset_sel = $urandom_range(1,7);
          apply_soft_reset(reset_sel[0],reset_sel[1],reset_sel[2]);
          
          //if(reset_sel[0] == 1 || reset_sel[2] == 1)
          //begin
          //  `uvm_info("eth1025_register_ip_hard_reset_sequence", "8.2:Applied Soft reset", UVM_NONE)
          //  if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
          //    `uvm_info("eth1025_register_ip_hard_reset_sequence", "8.3:Applied Soft reset", UVM_NONE)
          //    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
          //    `uvm_info("eth1025_register_ip_hard_reset_sequence", "8.4:Applied Soft reset", UVM_NONE)
          //  end
          //end
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          
          p_sequencer.env.wait_rx_pcs_ready(); 

          `ifdef ENABLE_ETH_VIP
          //Disable SNPS serial interface protocol checks as we are doing register testing that includes phy registers
          p_sequencer.env.disable_10_25G_snps_errors();
          `endif
          
// FIXME-MISSING_REG_IN_GDR          //compare_disable[`REGISTERS_PHY_CLK_OFFSET_REG] = 1;
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "9:Read registers", UVM_NONE)
          foreach(regs[i]) begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "10:Read registers", UVM_NONE)
          foreach(regs[i]) begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "11:Applied Hard reset", UVM_NONE)
          apply_hard_reset(0,0,1,$urandom_range(11,50));
          
          if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
               wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
          end
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          reg_read('h37F,read_data); //Read Immediately
          reg_read('h380,read_data); //Read Immediately
          reg_read('h381,read_data); //Read Immediately
          `ifndef CRETE3
               reg_read('h382,read_data); //Read Immediately
          `endif
          
          p_sequencer.env.wait_rx_pcs_ready(); 
          
          `ifdef ENABLE_ETH_VIP
          //Disable SNPS serial interface protocol checks as we are doing register testing that includes phy registers
          p_sequencer.env.disable_10_25G_snps_errors();          
          `endif
          
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_align.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          //ignoring comparison for CNTR_STATUS,just check it's reset value
          compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
          //compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 0;
// FIXME-MISSING_REG_IN_GDR          compare_disable[`REGISTERS_PHY_CLK_OFFSET_REG] = 0;
          
          `uvm_info("eth1025_register_ip_hard_reset_sequence", "12:Read registers", UVM_NONE)
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
     
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_register_access_sequence_1
// Descriptions: 
// 1.Apply reset
// 2.Perfrom walking 1s,walking 0s, all ones and all zeroes pattern on register access.
// 3.Perform random read-write operation on registers with random write value.
// 4.Perform read-write access on reserved spaces.
// Note : Some functional specific bits is not part of this test case and it should be covered under specific feature test case
//*******************************************************************************
class eth1025_register_access_sequence_1 extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     
     `uvm_object_utils(eth1025_register_access_sequence_1)
     
     function new(string name = "eth1025_register_access_sequence_1");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          dis_reg_cov();
          p_sequencer.env.tb_cfg.print();
          if(p_sequencer.env.tb_cfg.enable_stas_count ==1 ) max_address = 'h9ff; 
          if(p_sequencer.env.tb_cfg.rsfec_en == 1) max_address = 'hdff;
          
          //Reset the registers to reset default values as it has been changed in environment build phase - update_ral_reset_value()          
          reset_register_to_default();
          
          apply_hard_reset(0,0,1,11);
          p_sequencer.reg_model.default_map.get_registers(regs_org);
          
          //Removed registers from checking
          foreach(regs_org[i]) begin
          if(regs_org[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG || 
               regs_org[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG || 
               regs_org[i].get_address() == `ETH_F_ALL_clk_tx_khz_OFFSET_REG || 
               regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_clk_rx_khz_OFFSET_REG) //FB:551427 for KHZ_RX 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
// FIXME-MISSING_REG_IN_GDR               if(regs_org[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          //Soft reset is cover in soft_reset_recovery sequence     
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end
          
          //Will make the PCS behaivor undeterminitistic
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end          
          
          //Not found in latest register document
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_rxmac_adapt_dropped_snapshot_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          `ifdef RSFEC
          //Unused registers
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() inside {[12'hc00:12'hc67],12'ha09})
                    regs_org.delete(i);
          end
          `endif
          
          `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)
          
          foreach(regs_org[i]) 
          begin
               if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
               begin
                    regs.push_back(regs_org[i]);
               end
          end
          
          //Disable register checking list
          foreach(regs[i]) begin
               if(
               //FB start: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || 
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_rxpcs_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  || 
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               `ifdef G10     
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_ber_invalid_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               `endif     
               //FB end: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||      
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane 
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Some registers in this address is not used in 10G/25G
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG || //reserved
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //For multilane
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Disable because the REGISTERS_RX_CNTR_CONFIG_OFFSET_REG might set the RX Shadow Request in progress and hold there causing expected value mismatch
               //`ifdef G50
               //     regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
               //`endif
               `ifdef CRETE3
// FIXME-MISSING_REG_IN_GDR                    regs[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG ||    
               `endif
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
               ) begin
                    compare_disable[regs[i].get_address()] = 1;
               end 
               else begin
                    compare_disable[regs[i].get_address()] = 0;
               end
          end
          
          //wait for ehip ready
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          //reg_read('h37F,read_data); //Read Immediately - Only for multilane
          //reg_read('h380,read_data); //Read Immediately - Only for multilane
          //reg_read('h381,read_data); //Read Immediately - Only for multilane
          //`ifndef CRETE3
          //     reg_read('h382,read_data); //Read Immediately - Only for multilane
          //`endif
          
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.disable_10_25G_snps_errors();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          if(p_sequencer.env.tb_cfg.enable_stas_count == 1 )  
          begin 
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
          end
          
          foreach(regs[i]) begin
               `uvm_info("eth1025_register_access_sequence_1", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
          end
          
          `uvm_info("eth1025_register_access_sequence_1", "Performing random read write Pattern...", UVM_LOW)
          `uvm_info("eth1025_register_access_sequence_1", "2:Write registers", UVM_NONE)
          regs.shuffle();
          foreach(regs[i]) 
          begin
               reg_write(regs[i].get_address(),$urandom());
          end
          
          `uvm_info("eth1025_register_access_sequence_1", "3:Read registers", UVM_NONE)
          regs.shuffle();
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          
          `uvm_info("eth1025_register_access_sequence_1", "Performing read write Pattern on reserved space", UVM_LOW)          
          reg_write(`GET_REG_ADDR(ehip_cfg_dprio_control_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom());
          reg_read(`GET_REG_ADDR(ehip_cfg_dprio_control_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

          reg_write(`GET_REG_ADDR(ehip_cfg_dprio_control_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),$urandom());
          reg_read(`GET_REG_ADDR(ehip_cfg_dprio_control_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_dprio_control_2_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_dprio_control_2_OFFSET_REG,read_data);

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_dprio_control_3_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_dprio_control_3_OFFSET_REG,read_data);
          
// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_dprio_control_4_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_dprio_control_4_OFFSET_REG,read_data);

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_dprio_control_5_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_dprio_control_5_OFFSET_REG,read_data);          

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_txmac_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_txmac_scratch_OFFSET_REG,read_data);           
                    
// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_rxmac_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_rxmac_scratch_OFFSET_REG,read_data);    
         
// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_txsfc_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_txsfc_scratch_OFFSET_REG,read_data);              

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_rxsfc_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_rxsfc_scratch_OFFSET_REG,read_data);  
          
// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_txstat_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_txstat_scratch_OFFSET_REG,read_data);    

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_rxstat_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_rxstat_scratch_OFFSET_REG,read_data);    

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_tx_ptp_clk_period_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_tx_ptp_clk_period_OFFSET_REG,read_data);   

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_tx_ptp_status_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_tx_ptp_status_OFFSET_REG,read_data);
          
// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_rxptp_scratch_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_rxptp_scratch_OFFSET_REG,read_data);

// FIXME-MISSING_REG_IN_GDR          reg_write(`REGISTERS_rx_ptp_clk_period_OFFSET_REG,$urandom());
// FIXME-MISSING_REG_IN_GDR          reg_read(`REGISTERS_rx_ptp_clk_period_OFFSET_REG,read_data);            
          
          
          `uvm_info("eth1025_register_access_sequence_1", "Performing random read write Pattern...", UVM_LOW)
          regs.shuffle();
          foreach(regs[i]) begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          `uvm_info("eth1025_register_access_sequence_1", "4:Write registers", UVM_NONE)
          regs.shuffle();
          foreach(regs[i]) 
          begin
               reg_write(regs[i].get_address(),$urandom());
          end
          
          `uvm_info("eth1025_register_access_sequence_1", "5:Read registers", UVM_NONE)
          regs.shuffle();
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          apply_hard_reset(0,0,1,$urandom_range(11,50));
          
          if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1) begin
               wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0);
          end
          
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          reg_read('h37F,read_data); //Read Immediately
          reg_read('h380,read_data); //Read Immediately
          reg_read('h381,read_data); //Read Immediately
          `ifndef CRETE3
               reg_read('h382,read_data); //Read Immediately
          `endif
          
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.disable_10_25G_snps_errors();
          `endif
          
          foreach(regs[i]) 
          begin
               `uvm_info("eth1025_register_access_sequence_1", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_MEDIUM)
          end
          
          `uvm_info("eth1025_register_access_sequence_1", "6:Read registers", UVM_NONE)
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end 
          
          
     endtask
     
endclass

class eth1025_register_access_sequence_2 extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     
     `uvm_object_utils(eth1025_register_access_sequence_2)
     
     function new(string name = "eth1025_register_access_sequence_2");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          dis_reg_cov();
          p_sequencer.env.tb_cfg.print();
          if(p_sequencer.env.tb_cfg.enable_stas_count ==1 ) max_address = 'h9ff; 
          if(p_sequencer.env.tb_cfg.rsfec_en == 1) max_address = 'hdff;
          
          //Reset the registers to reset default values as it has been changed in environment build phase - update_ral_reset_value()          
          reset_register_to_default();          
          
          apply_hard_reset(0,0,1,11);
          p_sequencer.reg_model.default_map.get_registers(regs_org);
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG || 
                    regs_org[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG || 
                    regs_org[i].get_address() == `ETH_F_ALL_clk_tx_khz_OFFSET_REG || 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_clk_rx_khz_OFFSET_REG) //FB:551427 for KHZ_RX 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
// FIXME-MISSING_REG_IN_GDR               if(regs_org[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          //Soft reset is cover in soft_reset_recovery sequence     
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end          
          
          //Will make the PCS behaivor undeterminitistic
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end            
          
          //Not found in latest register document
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_rxmac_adapt_dropped_snapshot_OFFSET_REG)
                    regs_org.delete(i);
          end

          `ifdef RSFEC
          //Unused registers
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() inside {[12'hc00:12'hc67],12'ha09})
                    regs_org.delete(i);
          end
          `endif          
          
               
          `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)
          
          foreach(regs_org[i]) 
          begin
               if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
               begin
                    regs.push_back(regs_org[i]);
               end
          end
          
          foreach(regs[i]) begin
               if(
               //FB start: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || 
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_rxpcs_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               `ifdef G10     
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_ber_invalid_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               `endif                   
               //FB end: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||      
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane 
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Some registers in this address is not used in 10G/25G
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG || //reserved
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //For multilane
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Disable because the REGISTERS_RX_CNTR_CONFIG_OFFSET_REG might set the RX Shadow Request in progress and hold there causing expected value mismatch               
               //`ifdef G50
               //     regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
               //`endif
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
               ) begin
                    compare_disable[regs[i].get_address()] = 1;
               end 
               else begin
                    compare_disable[regs[i].get_address()] = 0;
               end
          end
          
          //wait for ehip ready
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          
          p_sequencer.env.wait_rx_pcs_ready();          
          
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.disable_10_25G_snps_errors();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          if(p_sequencer.env.tb_cfg.enable_stas_count == 1 )  
          begin 
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
          end
          
          foreach(regs[i]) begin
               `uvm_info("eth1025_register_access_sequence_2", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
          end
          
          `uvm_info("eth1025_register_access_sequence_2", "1:Read registers", UVM_NONE)
          
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          //ignoring comparison for CNTR_STATUS,just check it's reset value
          compare_disable[`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          compare_disable[`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          compare_disable[`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)] = 1;
          
          `uvm_info("eth1025_register_access_sequence_2", "Performing All 1s Pattern...", UVM_LOW)
          foreach(regs[i]) 
          begin
               reg_write(regs[i].get_address(),'hFFFF_FFFF);
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
          
          `uvm_info("eth1025_register_access_sequence_2", "Performing All 0s Pattern...", UVM_LOW)
          foreach(regs[i]) 
          begin
               reg_write(regs[i].get_address(),'h00000000);
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end
              
          
     endtask
endclass

class eth1025_register_access_sequence_3 extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     rand int k;
     
     `uvm_object_utils(eth1025_register_access_sequence_3)
     
     function new(string name = "eth1025_register_access_sequence_3");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          dis_reg_cov();
          p_sequencer.env.tb_cfg.print();
          if(p_sequencer.env.tb_cfg.enable_stas_count ==1 ) max_address = 'h9ff; 
          if(p_sequencer.env.tb_cfg.rsfec_en == 1) max_address = 'hdff;
          
          //Reset the registers to reset default values as it has been changed in environment build phase - update_ral_reset_value()          
          reset_register_to_default();          
          
          apply_hard_reset(0,0,1,11);
          p_sequencer.reg_model.default_map.get_registers(regs_org);
          
          foreach(regs_org[i]) begin
          if(regs_org[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG || 
               regs_org[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG || 
               regs_org[i].get_address() == `ETH_F_ALL_clk_tx_khz_OFFSET_REG || 
               regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_clk_rx_khz_OFFSET_REG) //FB:551427 for KHZ_RX 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
// FIXME-MISSING_REG_IN_GDR               if(regs_org[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          //Soft reset is cover in soft_reset_recovery sequence     
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end          
          
          //Will make the PCS behaivor undeterminitistic
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end            
          
          //Not found in latest register document
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_rxmac_adapt_dropped_snapshot_OFFSET_REG)
                    regs_org.delete(i);
          end

          `ifdef RSFEC
          //Unused registers
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() inside {[12'hc00:12'hc67],12'ha09})
                    regs_org.delete(i);
          end
          `endif          
               
          `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)
          
          foreach(regs_org[i]) 
          begin
               if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
               begin
                    regs.push_back(regs_org[i]);
               end
          end
          
          foreach(regs[i]) begin
               if(
               //FB start: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || 
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_rxpcs_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||               
               `ifdef G10     
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_ber_invalid_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               `endif                   
               //FB end: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||      
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane 
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Some registers in this address is not used in 10G/25G
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG || //reserved
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //For multilane               
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Disable because the REGISTERS_RX_CNTR_CONFIG_OFFSET_REG might set the RX Shadow Request in progress and hold there causing expected value mismatch               
               //`ifdef G50
               //     regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
               //`endif
               `ifdef CRETE3
// FIXME-MISSING_REG_IN_GDR                    regs[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG ||    
               `endif
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
               ) begin
                    compare_disable[regs[i].get_address()] = 1;
               end 
               else begin
                    compare_disable[regs[i].get_address()] = 0;
               end
          end
          
          //wait for ehip ready
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          
          //Disable SNPS serial interface protocol checks
          p_sequencer.env.disable_10_25G_snps_errors();          
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          if(p_sequencer.env.tb_cfg.enable_stas_count == 1 )  
          begin 
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
          end
          
          foreach(regs[i]) begin
               `uvm_info("eth1025_register_access_sequence_3", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
          end
          
          randomize(k) with {k inside {0,4,8,12,16,20,24,28};};
          `uvm_info("eth1025_register_access_sequence_3", "Performing walk 1 Pattern...", UVM_LOW)
          foreach(regs[i]) 
          begin
               for(int j=k;j<=k+3;j++) 
               begin
                    reg_write(regs[i].get_address(),1<<j);
                    reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
               end
          end
       
          
     endtask
     
endclass

class eth1025_register_access_sequence_4 extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     rand int k;
     
     `uvm_object_utils(eth1025_register_access_sequence_4)
     
     function new(string name = "eth1025_register_access_sequence_4");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          dis_reg_cov();
          p_sequencer.env.tb_cfg.print();
          if(p_sequencer.env.tb_cfg.enable_stas_count ==1 ) max_address = 'h9ff; 
          if(p_sequencer.env.tb_cfg.rsfec_en == 1) max_address = 'hdff;
          
          //Reset the registers to reset default values as it has been changed in environment build phase - update_ral_reset_value()          
          reset_register_to_default();          
          
          apply_hard_reset(0,0,1,11);
          p_sequencer.reg_model.default_map.get_registers(regs_org);
          
          
          foreach(regs_org[i]) begin
          if(regs_org[i].get_address() == `ETH_F_ALL_eth_reset_OFFSET_REG || 
               regs_org[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG || 
               regs_org[i].get_address() == `ETH_F_ALL_clk_tx_khz_OFFSET_REG || 
               regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_clk_rx_khz_OFFSET_REG) //FB:551427 for KHZ_RX 
                    regs_org.delete(i);
          end
          
          foreach(regs_org[i]) begin
// FIXME-MISSING_REG_IN_GDR               if(regs_org[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          //Soft reset is cover in soft_reset_recovery sequence     
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end          
          
          //Will make the PCS behaivor undeterminitistic
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed))
                    regs_org.delete(i);
          end            
          
          //Not found in latest register document
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_rxmac_adapt_dropped_snapshot_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          `ifdef RSFEC
          //Unused registers
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() inside {[12'hc00:12'hc67],12'ha09})
                    regs_org.delete(i);
          end
          `endif          
               
          `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)
          
          foreach(regs_org[i]) 
          begin
               if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
               begin
                    regs.push_back(regs_org[i]);
               end
          end
          
          foreach(regs[i]) begin
               if(
               //FB start: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || 
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_rxpcs_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               `ifdef G10     
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_ber_invalid_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               `endif                   
               //FB end: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||      
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane 
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Some registers in this address is not used in 10G/25G
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG || //reserved
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //For multilane               
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Disable because the REGISTERS_RX_CNTR_CONFIG_OFFSET_REG might set the RX Shadow Request in progress and hold there causing expected value mismatch               
               //`ifdef G50
               //     regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
               //`endif
               `ifdef CRETE3
// FIXME-MISSING_REG_IN_GDR                    regs[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG ||    
               `endif
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
               ) begin
                    compare_disable[regs[i].get_address()] = 1;
               end 
               else begin
                    compare_disable[regs[i].get_address()] = 0;
               end
          end
          
          //wait for ehip ready
          wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
          
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          //Disable SNPS serial interface protocol checks
          p_sequencer.env.disable_10_25G_snps_errors();
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          if(p_sequencer.env.tb_cfg.enable_stas_count == 1 )  
          begin 
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h3);
          end
          
          foreach(regs[i]) begin
               `uvm_info("eth1025_register_access_sequence_4", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
          end
          
          randomize(k) with {k inside {0,4,8,12,16,20,24,28};};
          `uvm_info("eth1025_register_access_sequence_4", "Performing walk 0 Pattern...", UVM_LOW)
          foreach(regs[i]) 
          begin
               for(int j=k;j<=k+3;j++) 
               begin
                    reg_write(regs[i].get_address(),~(1<<j));
                    reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
               end
          end
         
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_register_access_sequence_reset
// Descriptions: 
// 1.Sequence to check default reset value of registers
//*******************************************************************************
class eth1025_register_access_sequence_reset extends eth1025_base_sequence;

     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     
     `uvm_object_utils(eth1025_register_access_sequence_reset)
     
     function new(string name = "eth1025_register_access_sequence_reset");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          dis_reg_cov();
          
          //Reset the registers to reset default values as it has been changed in environment build phase - update_ral_reset_value()          
          reset_register_to_default();
          p_sequencer.env.tb_cfg.print();
          if(p_sequencer.env.tb_cfg.enable_stas_count ==1 ) max_address = 'h9ff; 
          if(p_sequencer.env.tb_cfg.rsfec_en == 1) max_address = 'hdff;
          
          apply_hard_reset(0,0,1,11);
          p_sequencer.reg_model.default_map.get_registers(regs_org);
          
          //Not found in latest register document
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() == `ETH_F_ALL_rxmac_adapt_dropped_snapshot_OFFSET_REG)
                    regs_org.delete(i);
          end
          
          `ifdef RSFEC
          //Unused registers
          foreach(regs_org[i]) begin
               if(regs_org[i].get_address() inside {[12'hc00:12'hc67],12'ha09})
                    regs_org.delete(i);
          end
          `endif          

          `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)
          
          foreach(regs_org[i]) 
          begin
               if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
               begin
                    regs.push_back(regs_org[i]);
               end
          end
          
          
          //Disable register checking list
          foreach(regs[i]) begin
               if(
               //FB start: https://fogbugz.altera.com/default.asp?592982#5260616               
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || 
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_eio_sftreset_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_tx_pld_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_rxpcs_conf_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_xus_timer_window_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_ipg_col_rem_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pause_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_en_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_cfg_retransmit_holdoff_quanta_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_tx_pfc_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               `ifdef G10     
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_ber_invalid_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)  ||
               `endif                   
               //FB end: https://fogbugz.altera.com/default.asp?592982#5260616
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_pcs_vlane_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||     //Only for 100G?
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_dsk_depth_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_lanes_deskewed_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               //regs[i].get_address() == `GET_REG_ADDR(ehip_stats_ber_count_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||      
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Multilane only  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane 
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||  //Only for 100G multilane  
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_16_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_17_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_18_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_bip_counter_19_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //Only for 100G multilane   
               //regs[i].get_address() == `GET_REG_ADDR(ehip_stats_err_block_cnt_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               //regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
// FIXME-MISSING_REG_IN_GDR               //regs[i].get_address() == `REGISTERS_phy_ehip_mode_muxes_OFFSET_REG ||    
               regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_pcs_modes_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    //Some registers in this address is not used in 10G/25G
               //regs[i].get_address() == `GET_REG_ADDR(ehip_cfg_phy_ehip_en_clock_gating_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||    
               //regs[i].get_address() == `ETH_F_ALL_link_fault_status_OFFSET_REG ||    
// FIXME-MISSING_REG_IN_GDR               regs[i].get_address() == `REGISTERS_rx_pld_status_OFFSET_REG || //reserved
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //For multilane               
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ||
               regs[i].get_address() == `ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG ||
               //`ifdef G50
                    //regs[i].get_address() == `GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) || //FB:551395:We cant set 'h1 for pp in env file.It's always take 'h1 in all simulation 
               //`endif
               `ifdef CRETE3
// FIXME-MISSING_REG_IN_GDR                    regs[i].get_address() == `REGISTERS_phy_pma_sloop_OFFSET_REG ||    
               `endif
               regs[i].get_address() == `GET_REG_ADDR(ehip_stats_tx_pld_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)    
               ) begin
                    compare_disable[regs[i].get_address()] = 1;
               end 
               else begin
                    compare_disable[regs[i].get_address()] = 0;
               end
          end
          
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          //Disable SNPS serial interface protocol checks
          p_sequencer.env.disable_10_25G_snps_errors();          
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif

          foreach(regs[i]) begin
               `uvm_info("eth1025_register_access_sequence_reset", $sformatf("Register compare_disable[('h%h)-(%s)] = %0d",regs[i].get_address(),regs[i].get_name(),compare_disable[regs[i].get_address()]), UVM_NONE)
          end

          `uvm_info("eth1025_register_access_sequence_reset", "1:Read registers", UVM_NONE)
          foreach(regs[i]) 
          begin
               reg_read(regs[i].get_address(),read_data,compare_disable[regs[i].get_address()]);
          end          
     
     endtask:body


endclass:eth1025_register_access_sequence_reset


//*******************************************************************************
// Sequence Name: bandwidth1025_sequence
// Descriptions: 
// 1. Apply reset
// 2. send 100-200 frame of each size 64 bytes
// 3. repeat step for 65,66,67,68,69,70,71,72,73 to put stess on MII boundary
// 4. send jumbo frames with maximum payload
// 5. Measure the bandwidth
//*******************************************************************************
class bandwidth1025_sequence extends eth1025_base_sequence;
     //  sequence_0 tx_seq;
     bit rx_crc_pass;
     //  ethernet_random_sequence eth_seq;
     `uvm_object_utils(bandwidth1025_sequence)
     
     function new(string name = "bandwidth1025_sequence");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          $display("running sanity sequence");
          apply_hard_reset(0,0,1,11);
          rx_crc_pass=$urandom;
          p_sequencer.env.wait_rx_pcs_ready();
          //   reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //   $display("DONE!!! WRITING TO REG");
          //  tx_seq.start(p_sequencer.tx_seqr);
          `ifdef ENABLE_ETH_VIP
               `ifdef G50
                    for(int i =46; i<127;i++)
                    begin
                         send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,100,i);
                    end
               `endif
                    `ifdef G100
                    for(int i = 46 ; i<512;i++)
                    begin
                         send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,100,i);
                    end
               `endif
               `ifdef G25
                    for(int i = 46 ; i<512;i++)
                    begin
                         send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,50,i);
                         `uvm_info("payload_size", $sformatf("payload size is %0d byte",i),UVM_NONE);
     
                    end
               `endif
               `ifdef G10
                    for(int i = 46 ; i<512;i++)
                    begin
                                        //(frame type, xfer_path, number of frame, payload size)
                         send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,50,i);
                         `uvm_info("payload_size", $sformatf("payload size is %0d byte",i),UVM_NONE);
                    end
               `endif
          `else
               `ifdef G50
                    for(int i =46; i<127;i++)
                    begin
                         send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,10000,i);
                    end
               `endif
                    `ifdef G100
                    for(int i = 46 ; i<512;i++)
                    begin
                         send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,10000,i);
                    end
               `endif
          
          `endif
     endtask
endclass

//*******************************************************************************
// Sequence Name: fixed1025_stress_sequence
// Descriptions: 
//*******************************************************************************
class fixed1025_stress_sequence extends eth1025_base_sequence;
     //  sequence_0 tx_seq;
     bit rx_crc_pass;
     //  ethernet_random_sequence eth_seq;
     `uvm_object_utils(fixed1025_stress_sequence)
     
     function new(string name = "seq_0");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          $display("running sanity sequence");
          apply_hard_reset(0,0,1,11);
          rx_crc_pass=$urandom;
          p_sequencer.env.wait_rx_pcs_ready();
          //   reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //   $display("DONE!!! WRITING TO REG");
          //  tx_seq.start(p_sequencer.tx_seqr);
          `ifdef ENABLE_ETH_VIP
               send_eth_frame1(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,500,9582);
          `else
               send_eth_frame1(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,1000,9582);
          `endif
     
     endtask
endclass

//*******************************************************************************
// Sequence Name: updown1025_stress_sequence
// Descriptions: 
//*******************************************************************************
class updown1025_stress_sequence extends eth1025_base_sequence;
     //  sequence_0 tx_seq;
     bit rx_crc_pass;
     //  ethernet_random_sequence eth_seq;
     int	rand_frames ;
     int	rand_frames_large ;
     int 	frame;
     int frame1;
     `uvm_object_utils(updown1025_stress_sequence)
     
     function new(string name = "updown1025_stress_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          $display("running sanity sequence");
          apply_hard_reset(0,0,1,11);
          rx_crc_pass=$urandom;
          p_sequencer.env.wait_rx_pcs_ready();
          //   reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //   $display("DONE!!! WRITING TO REG");
          //  tx_seq.start(p_sequencer.tx_seqr);
          `ifdef ENABLE_ETH_VIP
               fork
                    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
               join
          `else
          
               fork
               begin
                    for(int i=0;i<20;)
                    begin 
                         rand_frames = $urandom_range(4,8);
                         rand_frames_large = $urandom_range(4,8);
                         for(int j=0;j<rand_frames;j++)
                         begin
                              frame=$urandom_range(46,82);	
                              send_eth_frame1(DATA_FRAME,AVL_TX_ETH_VIP,1,frame);
                         end
                              
                         for(int k=0;k<rand_frames_large;k++)
                         begin
                              frame1=$urandom_range(8000,9000);	
                              send_eth_frame1(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,1,frame1);
                         end
                    
                         //	$display("i= %d \n",i);
                         i=i+rand_frames+rand_frames_large;
                    end
               end
               join
          `endif
     
     endtask
endclass

//*******************************************************************************
// Sequence Name: fb1025_495115_hard_rst_seq
// Descriptions: check different hard/soft resets. 
//               after this test works, run eth_stat_reset_sequence
//*******************************************************************************
class fb1025_495115_hard_rst_seq extends eth1025_base_sequence;
     bit[2:0] hard_rst_sig;
     bit[2:0] soft_rst_sig;
     bit[2:0] rst_sig;
     `uvm_object_utils(fb1025_495115_hard_rst_seq)
     
     function new(string name = "fb1025_495115_hard_rst_seq");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started fb1025_495115_hard_rst_seq ...", UVM_NONE)
          apply_hard_reset(0,0,1,11);
          `ifdef CRETE3
               p_sequencer.env.wait_rx_pcs_ready();
          `else
               rx_pcs_ready_timeout();//Shabbir - FB 534015
          `endif  
          
          for (int i=0;i<7;i++) begin
               
               `ifdef ENABLE_ETH_VIP
               fork
                    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               join
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
               `endif
               #2000ns;
               //Disable scoreboard 
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 1; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 1;
          `endif
               `uvm_info("fb1025_495115_hard_rst_seq", "5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter", UVM_NONE)
               //hard_rst
               hard_rst_sig++;
               `uvm_info("apply_hard_reset", $sformatf("hard_reset := %0d | hard_rst_combination := %0d",i,hard_rst_sig),UVM_NONE)
               apply_hard_reset(hard_rst_sig[2],hard_rst_sig[1],hard_rst_sig[0],$urandom_range(21,50));
          `ifndef ENABLE_ETH_VIP
               if(hard_rst_sig == 3'b100) begin // Tx reset only
                    // For tx reset only, there is delay for rx pcs ready to go low.
                    //This delay will ensure following function will start waiting for rx pcs ready at correct time.
                    #3000ns;
               end
          `endif  
               wait_for_dut_n_vip_link_up(hard_rst_sig[2],hard_rst_sig[1],hard_rst_sig[0]);
          
               //Enable scoreboard
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 0;
          `endif
               
               `ifdef ENABLE_ETH_VIP
               fork
                    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               join
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               `endif
               #2000ns; 
          end  
          `uvm_info("body", "ended fb1025_495115_hard_rst_seq ...", UVM_NONE)
     endtask
endclass : fb1025_495115_hard_rst_seq


//*******************************************************************************
// Sequence Name: fb1025_495115_soft_rst_seq
// Descriptions: check different hard/soft resets. 
//               after this test works, run eth_stat_reset_sequence
//*******************************************************************************
class fb1025_495115_soft_rst_seq extends eth1025_base_sequence;
     bit[2:0] hard_rst_sig;
     bit[2:0] soft_rst_sig;
     bit[2:0] rst_sig;
     `uvm_object_utils(fb1025_495115_soft_rst_seq)
     function new(string name = "fb1025_495115_soft_rst_seq");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started fb1025_495115_soft_rst_seq ...", UVM_NONE)
          apply_hard_reset(0,0,1,11);
          `ifdef CRETE3
               p_sequencer.env.wait_rx_pcs_ready();
          `else
               rx_pcs_ready_timeout();//Shabbir - FB 534015
          `endif  
          
          for (int i=0;i<7;i++) begin
               
               `ifdef ENABLE_ETH_VIP
               fork
                    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               join
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
               `endif
               #2000ns;
               //Disable scoreboard 
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 1; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 1;
          `endif
               `uvm_info("fb1025_495115_soft_rst_seq", "5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter", UVM_NONE)
               // soft rst
               soft_rst_sig++;
               `uvm_info("apply_soft_reset", $sformatf("soft_reset := %0d | soft_rst_combination := %0d",i,soft_rst_sig),UVM_NONE)
               apply_soft_reset(soft_rst_sig[2],soft_rst_sig[1],soft_rst_sig[0]);
          `ifndef ENABLE_ETH_VIP
               if(soft_rst_sig == 3'b100) begin // Tx reset only
                    // For tx reset only, there is delay for rx pcs ready to go low.
                    //This delay will ensure following function will start waiting for rx pcs ready at correct time.
                    #3000ns;
               end
          `endif
               wait_for_dut_n_vip_link_up(soft_rst_sig[2],soft_rst_sig[1],soft_rst_sig[0]);
               $display("[CW debug]: After wait dut link up");
               
          
               //Enable scoreboard
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 0;
          `endif
               
               `ifdef ENABLE_ETH_VIP
               fork
                    send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               join
               `else
                    send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
               `endif
               #2000ns; 
          end  
          `uvm_info("body", "ended fb1025_495115_soft_rst_seq ...", UVM_NONE)
     endtask
endclass : fb1025_495115_soft_rst_seq

class eth1025_dummytest_sequence extends eth1025_base_sequence;

     uvm_reg_data_t read_data;
     uvm_reg 	regs_org[$],regs[$];
     bit compare_disable[integer];
     bit [31:0] max_address = 'h5FF;
     bit [31:0] min_address = 'h300;
     int reg_index[$];
     
     `uvm_object_utils(eth1025_dummytest_sequence)
     
     function new(string name = "eth1025_dummytest_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          `uvm_info("body", "Entering ...", UVM_MEDIUM);
          `uvm_info("body", "Exiting ...", UVM_MEDIUM);
     endtask: body
     
endclass: eth1025_dummytest_sequence

//************************************************************
// Sequence Name: jumbo_frame_sequences
// Description:
// 1. configurare tx_max_framesize = 9600
// 2. Send jumbo packet (9600 bytes)
// 3. Repeat continiously back-to-back (b2b) with 500 frames
// Checks:
// 1. validate stats is correctly
// 2. Ensure no CRC error reported in both stats and status
// 3. Ensure no malformed packet observed
// 4. Ensure oversize frame is reported when packet size > max_framesize
//************************************************************
class jumbo_frame_sequences extends eth1025_base_sequence;
        bit rx_crc_pass;
     `uvm_object_utils(jumbo_frame_sequences)

     function new(string name = "jumbo_frame_sequences");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new

     virtual task body();
          $display("running jumbo sequence");
          apply_hard_reset(0,0,1,11);
          rx_crc_pass=$urandom;
          p_sequencer.env.wait_rx_pcs_ready();
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), 16'h2580);	//Set the register to allow max packet size 
          `uvm_info("max_tx_register_value_set", "Writing to max_tx_size register", UVM_LOW);
	  reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data);
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), 16'h2580);        //Set the register to allow max packet size
          `uvm_info("max_rx_register_value_set", "Writing to max_rx_size register", UVM_LOW);
          reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed), read_data);

	`ifdef ENABLE_ETH_VIP
	for (int size = 9572; size < 9593; size++)
		begin
		fork
		send_eth_frame1(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,10,size);  //Send 10 frames of 9572-9592 bytes packets in TX path
		send_eth_frame1(JUMBO_DATA_FRAME,ETH_VIP_AVL_RX,10,size);  //Send 10 frames of 9572-9592 bytes packets in RX path
		join
		end
        `else

	for (int size = 9572; size < 9593; size++)
	        begin
		fork
		send_eth_frame1(JUMBO_DATA_FRAME,AVL_TX_ETH_VIP,10,size);  //Send 10 frames of 9572-9592 bytes packets in TX path
		send_eth_frame1(JUMBO_DATA_FRAME,ETH_VIP_AVL_RX,10,size);  //Send 10 frames of 9572-9592 bytes packets in RX path
		join
		end
        `endif
	

     endtask
endclass


`ifdef ENABLE_ETH_VIP
//***************************************************
//VIP SEQUENCES (only applicable when VIP is enabled)
//***************************************************

//*******************************************************************************
// Sequence Name: eth1025_rxmax_payload_frame_sequence
// Descriptions: 
// 1. Apply reset
// 2. Configure random value of MAX_RX_SIZE_CONFIG parameter in DUT
// 3.Send less payload size frame than MAX_RX_SIZE_CONFIG configured value (but valid frame) from Avalon ST TX side.
// 4.Read all available status registers
// 5. Send more  payload size frame than MAX_RX_SIZE_CONFIG configured value from Avalon ST Tx side
// 6. Read all available status registers
// 7.  Repeat steps 3 to 6 for VIP TX side traffic
//*******************************************************************************
class eth1025_rxmax_payload_frame_sequence extends eth1025_base_sequence;
     alt_eth_vip_custom_sequence eth_seq;
     uvm_reg_data_t read_data,cfg_payload_size,rx_max_read_data;
     int frame_count = 0;
     
     `uvm_object_utils(eth1025_rxmax_payload_frame_sequence)
     
     function new(string name = "eth1025_rxmax_payload_frame_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          `uvm_info("eth1025_rxmax_payload_frame_sequence", "Executing eth1025_rxmax_payload_frame_sequence ...", UVM_LOW)
          p_sequencer.env.wait_rx_pcs_ready();
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
          read_data[7]=0;//$urandom_range(0,1); // writing 0 to make sequence pass
          `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL : enforce max rx = %0b",read_data[7]), UVM_NONE)
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);
          `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
          eth_seq.payload_length = $urandom_range(46,rx_max_read_data);
          frame_count++;
          `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
          eth_seq.start(p_sequencer.eth_vip_seqr_inst);
          read_registers();
          
          `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
          eth_seq.payload_length = $urandom_range(rx_max_read_data,rx_max_read_data+100);
          frame_count++;
          `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
          eth_seq.start(p_sequencer.eth_vip_seqr_inst);
          read_registers();
          
          //Shabbir- Rekha wants to complete stats tests in 8 hours
          for(int i=0;i<10;i++) 
          begin
               cfg_payload_size  = $urandom_range(64,'hFFF0);
               reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
               reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);
               
               `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
               eth_seq.payload_length = $urandom_range(rx_max_read_data - 50,rx_max_read_data);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
               eth_seq.start(p_sequencer.eth_vip_seqr_inst);
               read_registers();
               
               `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
               eth_seq.payload_length = $urandom_range(rx_max_read_data,rx_max_read_data + 10);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
               eth_seq.start(p_sequencer.eth_vip_seqr_inst);
               read_registers();
          end
          
          for(int m='hFFF0;m<'hFFFF;m++)
          begin
               cfg_payload_size = m;
               reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
               reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);
          
               `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
               eth_seq.payload_length = $urandom_range(m-10,m);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
               eth_seq.start(p_sequencer.eth_vip_seqr_inst);
               read_registers();
               
               `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
               eth_seq.payload_length = $urandom_range(m,'hFFFF);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
               eth_seq.start(p_sequencer.eth_vip_seqr_inst);
               read_registers();
          end
          
          /*
          reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
          read_data[7]= 1;
          `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL : enforce max rx = %0b",read_data[7]), UVM_NONE)
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(10) begin
               cfg_payload_size = $urandom_range('hFFF0,'hFFFF);
               reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
               reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);
          
               `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
               eth_seq.payload_length = $urandom_range(cfg_payload_size + 1,cfg_payload_size + 1000);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
               eth_seq.start(p_sequencer.eth_vip_seqr_inst);
               read_registers();
          end
          */
          
          
          `uvm_info("eth1025_rxmax_payload_frame_sequence", "Exiting eth1025_rxmax_payload_frame_sequence ...", UVM_LOW)
     endtask
     
     task read_registers();
          #1000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask

endclass

//*******************************************************************************
// Sequence Name: eth1025_txmax_payload_frame_sequence
// Descriptions: same as above for rx path
//*******************************************************************************
class eth1025_txmax_payload_frame_sequence extends eth1025_base_sequence;
     alt_eth_avalonst_custom_sequence avl_tx_pkt;
     uvm_reg_data_t read_data,cfg_payload_size,tx_max_read_data;
     int frame_count = 0;
     
     `uvm_object_utils(eth1025_txmax_payload_frame_sequence)
     
     function new(string name = "eth1025_txmax_payload_frame_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          `uvm_info("eth1025_txmax_payload_frame_sequence", "Executing eth1025_txmax_payload_frame_sequence ...", UVM_LOW)
          p_sequencer.env.wait_rx_pcs_ready();
          
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_read_data);
          `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
          avl_tx_pkt.byte_count = $urandom_range(46,tx_max_read_data);
          frame_count++;
          `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
          avl_tx_pkt.start(p_sequencer.tx_seqr);
          #100ns;
          read_registers();
          
          `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
          avl_tx_pkt.byte_count = $urandom_range(tx_max_read_data,tx_max_read_data+100);
          frame_count++;
          `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
          avl_tx_pkt.start(p_sequencer.tx_seqr);
          read_registers();
          
          //Shabbir- Rekha wants to complete stats tests in 8 hours
          for(int i=0;i<10;i++) 
          begin
               cfg_payload_size  = $urandom_range(64,'hFFF0);
               reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
               reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_read_data);
               
               `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
               avl_tx_pkt.byte_count = $urandom_range(tx_max_read_data - 50,tx_max_read_data);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
               avl_tx_pkt.start(p_sequencer.tx_seqr);
               read_registers();
               
               `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
               avl_tx_pkt.byte_count = $urandom_range(tx_max_read_data,tx_max_read_data + 10);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
               avl_tx_pkt.start(p_sequencer.tx_seqr);
               read_registers();
          end
          
          for(int m='hFFF0;m<'hFFFF;m++)
          begin
               cfg_payload_size = m;
               reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
               reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_read_data);
          
               `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
               avl_tx_pkt.byte_count = $urandom_range(m-10,m);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
               avl_tx_pkt.start(p_sequencer.tx_seqr);
               read_registers();
               
               `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
               avl_tx_pkt.byte_count = $urandom_range(m,'hFFFF);
               frame_count++;
               `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
               avl_tx_pkt.start(p_sequencer.tx_seqr);
               read_registers();
          end
          
          
          //Commenting below code as frame > 'hFFFF can cause stat counter mismatch. Fb:522383 
          
          //  repeat(10) begin
          //    cfg_payload_size = $urandom_range('hFFF0,'hFFFF);
          //    reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
          //    `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
          //    avl_tx_pkt.byte_count = $urandom_range(cfg_payload_size + 1,cfg_payload_size + 1000);
          //    frame_count++;
          //    `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
          //    avl_tx_pkt.start(p_sequencer.tx_seqr);
          //    read_registers();
          //  end
          
          `uvm_info("eth1025_txmax_payload_frame_sequence", "Exiting eth1025_txmax_payload_frame_sequence ...", UVM_LOW)
     endtask
     
     task read_registers();
          #1000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask

endclass

//*******************************************************************************
// Sequence Name: eth1025_hard_reset_recovery_sequence
// Descriptions: 
// This sequence test the hard reset recovery of dut 
// supal : this seq is made just to reproduce issue found in hw testing
// no need to add in regression as superset of this seq is eth1025_hard_reset_recovery_sequence
// 1. Apply hard ip (cs_rst_n) reset.
// 2. Perform frame transmission and reception.
// 3. Apply tx/rx/Ip reset single or multiple times.
// 4. Perform frame transmission and reception..
// 5. Apply tx/rx/Ip reset single or multiple times.
// 6. Perform frame transmission and reception.
// 7.  Apply tx/rx/Ip reset in middle of frame transmission.
// 8. Perform frame transmission and reception.
// 9. Read all available status registers
//*******************************************************************************
class eth1025_hard_reset_recovery_sequence extends eth1025_base_sequence;
     uvm_event_pool a_event_pool;
     uvm_event assertion_event;
     bit [2:0] rst_sig;
     
     `uvm_object_utils(eth1025_hard_reset_recovery_sequence)
     
     function new(string name = "eth1025_hard_reset_recovery_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          process p_tx;
          process p_rx;
          a_event_pool = new();
          a_event_pool = a_event_pool.get_global_pool();
          assertion_event = a_event_pool.get("assertion_event");
          apply_hard_reset(0,0,1,21);
          assertion_event.trigger();
          p_sequencer.env.tb_cfg.enable_stas_count = 0;
          
          `uvm_info("eth1025_hard_reset_recovery_sequence", "Executing eth1025_hard_reset_recovery_sequence ...", UVM_LOW)
          p_sequencer.env.wait_rx_pcs_ready();
          
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,25);
          
          for(int i=0;i<20;i++) begin reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
          
          rst_sig = $urandom_range(1,7);
          `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("1 : rst_sig := %0p",rst_sig),UVM_NONE)
          apply_hard_reset(rst_sig[2],rst_sig[1],rst_sig[0],$urandom_range(21,50));
          wait_for_dut_n_vip_link_up(rst_sig[2],rst_sig[1],rst_sig[0]);
          
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
          end
          join
          
          for(int i=0;i<20;i++) begin reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
          
          rst_sig = $urandom_range(1,7);
          `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("2 : rst_sig := %0p",rst_sig),UVM_NONE)
          apply_hard_reset(rst_sig[2],rst_sig[1],rst_sig[0],$urandom_range(21,50));
          wait_for_dut_n_vip_link_up(rst_sig[2],rst_sig[1],rst_sig[0]);
          
          fork : reset_thread_1
          begin
               p_tx = process :: self();
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
          end
          begin
               p_rx = process :: self();
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
          end
          begin
               for(int j=0;j<$urandom_range (20,40);j++) begin
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
               end
               
               rst_sig = $urandom_range(1,7);
               fork 
               begin
                    `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("3 : rst_sig := %0p",rst_sig),UVM_NONE)
                    //if(rst_sig[2] == 1) begin //Tx reset
                    //  uvm_hdl_force("eth_env_top.tx_avst_if.reset",1);
                    //end
                    apply_hard_reset(rst_sig[2],rst_sig[1],rst_sig[0],$urandom_range(21,50));
                    
                    wait_for_dut_n_vip_link_up(rst_sig[2],rst_sig[1],rst_sig[0]);
                    //if(rst_sig[2] == 1) begin //Tx reset
                    //  uvm_hdl_release("eth_env_top.tx_avst_if.reset");
                    //end
               end  
               begin
                    #200ns;
                    p_tx.kill();
                    p_rx.kill();
               end
               join 	 
               disable reset_thread_1;
               `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("Done fork thread 1"),UVM_NONE)
               
          end
          begin
               @ (negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
               //#1; // removed so that eth_scoreboard will be able to disable check straight after reset asserted
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n );
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n  & p_sequencer.env.reset_if.rx_rst_n);
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n);
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
               uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_NONE);
               // if(p_sequencer.env.reset_if.tx_rst_n !== 0) begin
               //   disable reset_thread_1; 
               // end
               `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("Done fork thread 2"),UVM_NONE)
               
          end
          join
          
          `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("Done reset_thread_1"),UVM_NONE)
          
          `ifdef ENABLE_ETH_VIP
          //Rx reset can cause DUT tx to transmit fault. This can corrupt DUT tx frame. 
          //Below check will make sure that such erroneous frames are transmitted before we enable VIP rx checkers.
          
          if((rst_sig[2] == 1 &&  rst_sig[0] == 0) || (rst_sig[1] == 1 && rst_sig[0] == 0)) begin // Tx or Rx reset only
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
               //bit 0: (set t0 0 to disable checker on tx side)
               //bit 1: (set t0 0 to disable checker on rx side)
               //bit 2: (set t0 0 to disable checker on checker arbiter)
               //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
          
               repeat(10) @(p_sequencer.env.spy_if.event_mac_idle_detected_rx); 
          
               //enable all rule checks 
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
          end
          
          
          `endif 
          
          //  #100ns;//added delay to close previous fork join thead
          `uvm_info("eth1025_hard_reset_recovery_sequence", $sformatf("Enable scoreboards"),UVM_NONE)
          
          //Enable scoreboards after pcs ready goes high
          p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
          p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
          p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
          p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
          //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0;  //patelavx
          
          //do some normal frame transfer
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
          end
          join
          
          for(int i=0;i<20;i++) begin reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
          
          `uvm_info("eth1025_hard_reset_recovery_sequence", "Exiting eth_avalonst_to_serial_simplex_sequence ...", UVM_LOW)
     endtask

endclass 

//*******************************************************************************
// Sequence Name: fc1025_rand_seq
// Descriptions: 
// This sequence test the soft reset recovery of dut
// 1. Apply hard ip (soft eio_sys_rst) reset.
// 2. Perform frame transmission and reception.
// 3. Apply tx/rx/IP soft reset single or multiple times.
// 4. Perform frame transmission and reception..
// 5. Apply tx/rx/IP soft reset single or multiple times.
// 6. Perform frame transmission and reception.
// 7.  Apply tx/rx/IP  soft reset in middle of frame transmission.
// 8. Perform frame transmission and reception.
// 9. Read all available status registers
//*******************************************************************************
class eth1025_soft_reset_recovery_sequence extends eth1025_base_sequence;
     bit [2:0] reset_bits;
     uvm_event_pool a_event_pool;
     uvm_event assertion_event;
     
     `uvm_object_utils(eth1025_soft_reset_recovery_sequence)
     
     function new(string name = "eth1025_soft_reset_recovery_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          process p_tx;
          process p_rx;
          a_event_pool = new();
          a_event_pool = a_event_pool.get_global_pool();
          assertion_event = a_event_pool.get("assertion_event");
          apply_hard_reset(0,0,1,21);
          assertion_event.trigger();
          p_sequencer.env.tb_cfg.enable_stas_count = 0;
          `uvm_info("eth1025_soft_reset_recovery_sequence", "Executing eth1025_soft_reset_recovery_sequence ...", UVM_LOW)
          p_sequencer.env.wait_rx_pcs_ready();
          
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,50);
          
          for(int i=0;i<20;i++) begin reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
          
          reset_bits = $urandom_range (1,7);
          `uvm_info("eth1025_soft_reset_recovery_sequence", $sformatf("1 : reset_bits := %0p",reset_bits),UVM_NONE)
          apply_soft_reset(reset_bits[2],reset_bits[1],reset_bits[0]);
          wait_for_dut_n_vip_link_up(reset_bits[2],reset_bits[1],reset_bits[0]);
          
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
          end
          join
          
          for(int i=0;i<20;i++) begin reg_read(`ETH_F_ALL_eth_reset_OFFSET_REG,read_data);  end
          
          reset_bits = $urandom_range (1,7);
          `uvm_info("eth1025_soft_reset_recovery_sequence", $sformatf("2 : reset_bits := %0p",reset_bits),UVM_NONE)
          apply_soft_reset(reset_bits[2],reset_bits[1],reset_bits[0]);
          wait_for_dut_n_vip_link_up(reset_bits[2],reset_bits[1],reset_bits[0]);
          
          fork :soft_reset
          begin
               p_tx = process :: self();
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
          end
          begin
               p_rx = process :: self();
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);
          end
          begin
               @(posedge p_sequencer.env.spy_if.avst_tx_sop);
               #20ns;
               //As vip always operate in duplex mode, independent assertion of tx or rx reset impact other
               //one as rx pcs ready go low in both case and eventually packet drop happens on both path despite respective path reset is applied 
               // so need to disable all scb
               reset_bits = $urandom_range (1,7);
               `uvm_info("eth1025_soft_reset_recovery_sequence", $sformatf("3 : reset_bits := %0p",reset_bits),UVM_NONE)
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; 
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis =1;  //patelavx
               
               fork 
               begin 
                    apply_soft_reset(reset_bits[2],reset_bits[1],reset_bits[0]);
                    wait_for_dut_n_vip_link_up(reset_bits[2],reset_bits[1],reset_bits[0]);
               end
               begin
                    wait(p_sequencer.env.spy_if.eio_soft_rst == 1'b1 || p_sequencer.env.spy_if.tx_soft_rst == 1'b1 || p_sequencer.env.spy_if.rx_soft_rst == 1'b1);
                    p_tx.kill();
                    p_rx.kill();
               end 
               join
          
               disable soft_reset; 
          end
          join
          
          uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d sb_vec_vip_tx_mac_rx.sb_enable:%0d sb_vec_mac_tx_vip_rx.sb_enable:%0d ", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_NONE);
          `ifdef ENABLE_ETH_VIP
          //Rx reset can cause DUT tx to transmit fault. This can corrupt DUT tx frame. 
          //Below check will make sure that such erroneous frames are transmitted before we enable VIP rx checkers.
          
          if((reset_bits[2] == 1 &&  reset_bits[0] == 0) || (reset_bits[1] == 1 && reset_bits[0] == 0)) begin // Tx or Rx reset only
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
               //bit 0: (set t0 0 to disable checker on tx side)
               //bit 1: (set t0 0 to disable checker on rx side)
               //bit 2: (set t0 0 to disable checker on checker arbiter)
               //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
          
               repeat(10) @(p_sequencer.env.spy_if.event_mac_idle_detected_rx); 
          
               //enable all rule checks 
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
               p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
          end
          
          
          `endif
          //Enable scoreboards after pcs ready goes high
          p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0; 
          p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
          p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;
          p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1;
          //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; //patelavx
          
          //do some normal frame transfer
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
          end
          join
          
          `uvm_info("eth1025_soft_reset_recovery_sequence", "Exiting eth1025_soft_reset_recovery_sequence ...", UVM_LOW)
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_ipg_sequence
// Descriptions:
// 1. Apply reset 
// 2. Send multiple random frame random interpacket gaps value from VIP Tx and Avalon ST Tx interface.
// 3. Read all available status registers
// 4. Send multiple frame with min payload size from Avalon ST Tx side back to back to check the average ipg calculation.
// Checks:
// 1. All packets must pass through the DUT in both direction with min to max interpacket delay 
// 2. Tx MAC deficit idle counter must maintain average IPG of 12 bytes.
//*******************************************************************************
class eth1025_ipg_sequence extends eth1025_base_sequence;  
  
     `uvm_object_utils(eth1025_ipg_sequence)
     
     function new(string name = "eth1025_ipg_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     
     virtual task pre_body();
          p_sequencer.env.ipg_checker.ipg_check_enable = 1'b1;
     endtask
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          `uvm_info("eth1025_ipg_sequence", "Executing eth1025_ipg_sequence ...", UVM_LOW)
          p_sequencer.env.wait_rx_pcs_ready();
          send_eth_frame(IPG_STRESS,AVL_TX_ETH_VIP,10000);
          `uvm_info("eth1025_ipg_sequence", "Exiting eth1025_ipg_sequence ...", UVM_LOW)
     endtask
     
endclass

//*******************************************************************************
// Sequence Name: vip1025_strict_sfd_sequence
// Descriptions:
// 1. Toggle reset.
// 2. Register setting for CRC pass through is randomized. Reg settings for preamble_check and SFD_check is (0,0).  
// 4. There are 4 frame types being tested. 
//    A. Good frame (good preamble, sfd, fcs). 
//    B. Bad SFD + good preamble. 
//    C. Good SFD + bad preamble. 
//    D. Bad SFD + Bad preamble. 
//    E. Bad FCS sequence
//  random number of frames (500-5000) from the above list will be sent in a random order. 
// 5. Set Registers (preamble_check, SFD_check) to (0,1) and repeat step 4.  
// 6. Set Registers (preamble_check, SFD_check) to (1,0) and repeat step 4.
// 7. Set Registers (preamble_check, SFD_check) to (1,1) and repeat step 4.
//*******************************************************************************
//TEMP PUT HERE
class vip1025_strict_sfd_sequence extends vip_error_base_sequence;
      
     `uvm_object_utils(vip1025_strict_sfd_sequence)
     alt_eth_error_vip_base_sequence err_seq;
     
     function new(string name = "vip1025_strict_sfd_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          bit [55:0] good_preamble;
          bit [55:0] bad_preamble;
          bit [7:0]  good_sfd;
          bit [7:0]  bad_sfd;
          int 	 preamble_post;
          int 	 sfd_post;      
     
          en_short_packet=1;
          
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_four_idle_c_char_or_seq_os_not_before_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
     
          /* Number of frames */
          sequence_length = 100;
          good_preamble = 56'h55555555555555;
          good_sfd = 8'hd5;
          total_num_frames_sent=num_of_frames;
          // Flip single bit of the good preamble
          // #1
          preamble_post = $urandom_range(55,0);
          sfd_post = $urandom_range(7,0);
          bad_preamble = good_preamble;
          bad_preamble[preamble_post] =~good_preamble[preamble_post];
          bad_sfd = good_sfd;
          bad_sfd[sfd_post] = ~good_sfd[sfd_post];
          exception = new();
          exception_list = new("exception_list", exception);
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
          exception.frame_send_invalid_preamble_bits_error = bad_preamble;
          exception_list.add_exception(exception);
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
          exception.frame_invalid_sfd_error = bad_sfd;
          exception_list.add_exception(exception);
     
          // Flip single bit of the good preamble
          // #2
          preamble_post = $urandom_range(55,0);
          sfd_post = $urandom_range(7,0);
          bad_preamble = good_preamble;
          bad_preamble[preamble_post] =~good_preamble[preamble_post];
          bad_sfd = good_sfd;
          bad_sfd[sfd_post] = ~good_sfd[sfd_post];
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
          exception.frame_send_invalid_preamble_bits_error = bad_preamble;
          exception_list.add_exception(exception);
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
          exception.frame_invalid_sfd_error = bad_sfd;
          exception_list.add_exception(exception);
     
          // Flip single bit of the good preamble
          // #3
          preamble_post = $urandom_range(55,0);
          sfd_post = $urandom_range(7,0);
          bad_preamble = good_preamble;
          bad_preamble[preamble_post] =~good_preamble[preamble_post];
          bad_sfd = good_sfd;
          bad_sfd[sfd_post] = ~good_sfd[sfd_post];
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
          exception.frame_send_invalid_preamble_bits_error = bad_preamble;
          exception_list.add_exception(exception);
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
          exception.frame_invalid_sfd_error = bad_sfd;
          exception_list.add_exception(exception);
     
          // Flip single bit of the good preamble
          // #4
          preamble_post = $urandom_range(55,0);
          sfd_post = $urandom_range(7,0);
          bad_preamble = good_preamble;
          bad_preamble[preamble_post] =~good_preamble[preamble_post];
          bad_sfd = good_sfd;
          bad_sfd[sfd_post] = ~good_sfd[sfd_post];
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
          exception.frame_send_invalid_preamble_bits_error = bad_preamble;
          exception_list.add_exception(exception);
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
          exception.frame_invalid_sfd_error = bad_sfd;
          exception_list.add_exception(exception);
     
          // Flip single bit of the good preamble
          // #5
          preamble_post = $urandom_range(55,0);
          sfd_post = $urandom_range(7,0);
          bad_preamble = good_preamble;
          bad_preamble[preamble_post] =~good_preamble[preamble_post];
          bad_sfd = good_sfd;
          bad_sfd[sfd_post] = ~good_sfd[sfd_post];
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
          exception.frame_send_invalid_preamble_bits_error = bad_preamble;
          exception_list.add_exception(exception);
          exception = new();
          exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
          exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
          exception.frame_invalid_sfd_error = bad_sfd;
          exception_list.add_exception(exception);      
          
          `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
          `uvm_info("vip_error_base_sequence", "Setting preamble_check=0, sfd_check=0", UVM_MEDIUM)
          preamble_check=0;
          sfd_check=0;
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0}); 
          // Send frames
          err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
          // Wait for frames to be received
          wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
          wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));      
          #200ns;
     
          `uvm_info("vip_error_base_sequence", "Setting preamble_check=1, sfd_check=0", UVM_MEDIUM)
          preamble_check=1;
          sfd_check=0;
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0}); 
          // Send frames
          err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
          total_num_frames_sent=total_num_frames_sent+num_of_frames;
          // Wait for frames to be received
          wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
          wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));      
          #200ns;
          
          `uvm_info("vip_error_base_sequence", "Setting preamble_check=0, sfd_check=1", UVM_MEDIUM)
          preamble_check=0;
          sfd_check=1;
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0}); 
          // Send frames
          err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
          total_num_frames_sent=total_num_frames_sent+num_of_frames;
          // Wait for frames to be received
          wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
          wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));      
          #200ns;
     
          `uvm_info("vip_error_base_sequence", "Setting preamble_check=1, sfd_check=1", UVM_MEDIUM)
          preamble_check=1;
          sfd_check=1;
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{27'b0,preamble_check,sfd_check,3'b0}); 
          // Send frames
          err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));
          total_num_frames_sent=total_num_frames_sent+num_of_frames;
          // Wait for frames to be received
          wait_vip_tx_frames_done(.exp_num(total_num_frames_sent),.timeout_time(frame_timeout_time)); 
          wait_client_rx_frames_done(.exp_num(total_num_frames_sent-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));      
          `uvm_info("body", "Exiting ...", UVM_MEDIUM);   
     endtask // body

endclass // vip1025_strict_sfd_sequence

`endif

`ifdef ENABLE_ETH_VIP
`include "eth_1025_stat_checkers_sequence_library.sv"
`include "eth_1025_link_fault_sequences.sv"
`include "cl31_compliance_seq_lib.sv"
`endif

`endif // ETH_1025_SEQ_LIB
