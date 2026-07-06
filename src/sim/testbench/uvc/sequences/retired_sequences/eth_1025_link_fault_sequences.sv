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


//*******************************************************************************
// Sequence Name: eth1025_link_remote_fault_duplex_sequence
// Descriptions:
// This sequence test remore link fault in duplex mode
// 1. Apply reset
// 2. Read the Link fault register of TX and RX MAC and disable the unidirection (clause 66 )mode.
// 3.  Configure the link fault enable bit of TX MAX LINK FAULT register (LINK FAULT[0] = 1/0) randomly
// 4.  Perform Normal or error frame transmission in duplex mode.
// 5. keep sending valid remote link fault from VIP after some frame transfer
// 6. After some time stop remote link fault sequence generation from VIP.
// 7. Read RX and RX LINK FAULT Registers
// 8. Repeate Step 4 to Step 7. 
// 
// (NO AVMM writes, ehip parameters set to in lf_bidir mode)
// 
// Note : Valid Remote fault condition refers to detection of 4 remote fault order set in 128 column.
// 
//*******************************************************************************
class eth1025_link_remote_fault_duplex_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     bit link_fault_en;
     int data_on_mii = 0 ;
     `uvm_object_utils(eth1025_link_remote_fault_duplex_sequence)
     
     function new(string name = "eth1025_link_remote_fault_duplex_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.wait_rx_pcs_ready();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);//Disable the read check as it is not required to write. Also FB: https://fogbugz.altera.com/default.asp?592982#5260616
          // ***** No need to set any registers in ehip, parameter already takes care of it *****//
          //link_fault_en =$urandom_range(0,1);
          link_fault_en =1;
          `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_NONE);
          read_data[0]  = link_fault_en; 
          //read_data[1]  = 0; //Disable (clause-66) unidirection
          reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,5);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,5);
          end
          
          begin
               for(int j=0;j<$urandom_range(2,4);j++)
               begin 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
                    `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
               end
               
               `uvm_info(get_name(), $sformatf("Turning off SNPS check"), UVM_NONE);
               //Turning off SNPS check
               `ifdef ENABLE_ETH_VIP
               p_sequencer.env.disable_10_25G_snps_errors();
               `endif                
               
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,50);//start
               
          end
          join_none
          
          `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
          wait(p_sequencer.env.spy_if.check_rx_mii_remote_fault());
          `uvm_info(get_name(), $sformatf("received remote fault order set on rx mii"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
          
          `uvm_info(get_name(), $sformatf("Turning off scoreboard check"), UVM_NONE);         
          //Turn off scoreboard check
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 1; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 1;
          `endif          
          
          //This dummy read is to accomodate thertl internal dealy to update the register
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
          //read_data_chk(read_data,'h2);
          repeat(6) @(posedge p_sequencer.env.spy_if.clk); 
          
          `uvm_info("eth1025_link_remote_fault_duplex_sequence", $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
          while (p_sequencer.env.spy_if.remote_fault == 1'b1)
          begin
               if(link_fault_en == 1'b1) begin // and is bidir, then TX must transmit IDLE
                    if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1) 
                    begin
                         if(p_sequencer.env.spy_if.check_idle_tx_mii())
                         begin
                              `uvm_info("eth1025_link_remote_fault_duplex_sequence", $sformatf("CHECK_IDLE_TX_MII:data on tx mii correct when link fault is enabled."), UVM_NONE); 
                         end
                         else
                         begin
                              `uvm_error("eth1025_link_remote_fault_duplex_sequence", $sformatf("CHECK_IDLE_TX_MII:data on tx mii incorrect when link fault is enabled."));
                         end
                    end
               end
               else
               begin
                    if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
                    begin
                         data_on_mii = data_on_mii + 1;
                    end
               end
          
               //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
               //read_data_chk(read_data,'h2);
               repeat(1) @(posedge p_sequencer.env.spy_if.clk);
          end
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          `uvm_info(get_name(), $sformatf("waiting for remote_fault signal to be 0 -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 1"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault_status == 1'b1);
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 1 -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault_status == 1'b0);
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 0 -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for link to be stable"), UVM_NONE);
          wait(p_sequencer.env.spy_if.mii_ctrl0_tx[0] == 1'b1 && p_sequencer.env.spy_if.mii_data0_tx[7:0] == 8'hfb);
          `uvm_info(get_name(), $sformatf("waiting for link to be stable -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("Turning on scoreboard check"), UVM_NONE);
          
          //Immediately turn on scoreboard check after lane stable
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 0;
          `endif          
          
          `uvm_info(get_name(), $sformatf("Turning on SNPS check"), UVM_NONE);
          
          //Wait 50 more clocks before turning on SNPS check as it takes time for error packets to get transmitted to serial interface
          repeat(50) @(posedge p_sequencer.env.spy_if.clk);
          
          //Enable SNPS check
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.enable_10_25G_snps_errors();
          `endif
          

          
          if(data_on_mii == 0 && link_fault_en == 0)
          begin
               `uvm_warning(get_name(), $sformatf("data on tx mii has idle symbol value, please take a look at waves and confirm it is not caused by remote fault when link fault is off."));
          end
          
          data_on_mii = 0;
          
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
          end
          
          begin
               for(int j=0;j<$urandom_range(10,15);j++)
               begin 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
                    `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
               end
               
               `uvm_info(get_name(), $sformatf("Turning off SNPS check"), UVM_NONE);
               //Turning off SNPS check
               `ifdef ENABLE_ETH_VIP
               p_sequencer.env.disable_10_25G_snps_errors();
               `endif                  
               
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,$urandom_range(4,500));//start
               
          end
          join_none
          
          `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
          wait(p_sequencer.env.spy_if.check_mii_rx_remote_fault());
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
          
          `uvm_info(get_name(), $sformatf("Turning off scoreboard check"), UVM_NONE);
          
          //Turn off scoreboard check
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 0;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 1; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 1;
          `endif          
          
          //This dummy read is to accomodate thertl internal dealy to update the register
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
          //read_data_chk(read_data,'h2);
          repeat(6) @(posedge p_sequencer.env.spy_if.clk); 
          
          `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
          while (p_sequencer.env.spy_if.remote_fault == 1'b1)
          begin
               if(link_fault_en == 1'b1) begin
                    if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1) 
                    begin
                         if(p_sequencer.env.spy_if.check_idle_tx_mii())
                         begin
                              `uvm_info(get_name(), $sformatf("CHECK_IDLE_TX_MII:data on tx mii correct when link fault is enabled."), UVM_NONE); 
                         end
                         else
                         begin
                              `uvm_error(get_name(), $sformatf("CHECK_IDLE_TX_MII:data on tx mii incorrect when link fault is enabled."));
                         end
                    end
               end
               else
               begin
                    if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
                    begin
                         data_on_mii = data_on_mii + 1;
                    end
               end
          
               //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
               //read_data_chk(read_data,'h2);
               repeat(1) @(posedge p_sequencer.env.spy_if.clk);
          end
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          `uvm_info(get_name(), $sformatf("waiting for remote_fault signal to be 0 -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 1"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault_status == 1'b1);
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 1 -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault_status == 1'b0);
          `uvm_info(get_name(), $sformatf("waiting for remote_fault_status signal to be 0 -- done"), UVM_NONE);
          
          `uvm_info(get_name(), $sformatf("waiting for link to be stable"), UVM_NONE);
          wait(p_sequencer.env.spy_if.mii_ctrl0_tx[0] == 1'b1 && p_sequencer.env.spy_if.mii_data0_tx[7:0] == 8'hfb);
          `uvm_info(get_name(), $sformatf("waiting for link to be stable -- done"), UVM_NONE);          
          
          `uvm_info(get_name(), $sformatf("Turning on scoreboard check"), UVM_NONE);
          
          //Turn on scoreboard check immediately after lane stable
          `ifdef ENABLE_ETH_VIP
               p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
               p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
               p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
               p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
               //p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; //patelavx
          `else
               p_sequencer.env.sb_loopbk.scb_dis = 0;
          `endif          
          
          //Wait 50 more clocks before turning on SNPS check as it takes time for error packets to get transmitted to serial interface
          repeat(50) @(posedge p_sequencer.env.spy_if.clk);          
          
          `uvm_info(get_name(), $sformatf("Turning on SNPS check"), UVM_NONE);
          
          //Enable SNPS check
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.enable_10_25G_snps_errors();
          `endif    

               
          if(data_on_mii == 0 && link_fault_en == 0)
          begin
               `uvm_warning(get_name(), $sformatf("data on tx mii has idle symbol value, please take a look at waves and confirm it is not caused by remote fault when link fault is off."));
          end
          
          //`uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
          //wait(p_sequencer.env.spy_if.remote_fault == 1'b0|p_sequencer.env.spy_if.remote_fault_status == 1'b0);
          
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          
          //FIXME : check why objection drop is not working
          #50us;
     
     endtask
endclass

//*******************************************************************************
// Sequence Name: fc1025_rand_seq
// Descriptions: 
// This sequence test remore link fault in simplex mode
// 1. Apply reset
// 2. Read the Link fault register of TX and RX MAC and enable unidirection (clause 66 )mode.
// 3.  Configure the link fault enable bit of TX MAX LINK FAULT register (LINK FAULT[0] = 1/0) randomly
// 4.  Perform Normal or error frame transmission in duplex mode.
// 5. keep sending valid remote link fault from VIP 
// 6. After some time stop remote link fault sequence generation from VIP.
// 7. Read RX and RX LINK FAULT Registers
// 8. Repeate Step 4 to Step 7.
// (NO AVMM writes, ehip parameters set to in lf_unidir mode)

//*******************************************************************************
class eth1025_link_remote_fault_simplex_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     bit link_fault_en;
     int data_on_mii = 0 ;
     
     `uvm_object_utils(eth1025_link_remote_fault_simplex_sequence)
     
     function new(string name = "eth1025_link_remote_fault_simplex_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          dis_stats_chk = 1;
          dis_vec_sb();
          
          p_sequencer.env.wait_rx_pcs_ready();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
          // ***** No need to set any registers in ehip, parameter already takes care of it *****//
          //link_fault_en =  $urandom_range(0,1);
          link_fault_en =  1;
          `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
          read_data[0]  = link_fault_en; 
          read_data[1] = 1; //enable (clause-66) unidirection
          reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
          fork
               begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,5);
               end
          
               begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,5);
               end
          
               begin
                    for(int j=0;j<$urandom_range(0,4);j++)
                    begin 
                         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
                         `uvm_info(get_name(), $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
                    end
                    
                    `uvm_info(get_name(), $sformatf("Disable SNPS errors"), UVM_LOW);
                    `ifdef ENABLE_ETH_VIP
                    p_sequencer.env.disable_10_25G_snps_errors();
                    `endif
                    
                    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,50);//start

                    
               end
          join_none
          
          `uvm_info(get_name() , $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
          wait(p_sequencer.env.spy_if.check_mii_rx_remote_fault());
          
          `uvm_info(get_name() , $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
          
          //This dummy read is to accomodate thertl internal dealy to update the register
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //if (p_sequencer.env.tb_cfg.pcs_40g_mode) // 2 dummy reads only for 40g
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
          //read_data_chk(read_data,'h2);
          repeat(6) @(posedge p_sequencer.env.spy_if.clk); 
          
          `uvm_info(get_name(), $sformatf("waiting for remote_fault tx mii to go 0"), UVM_NONE);
          while (p_sequencer.env.spy_if.remote_fault == 1'b1)
          begin
               if(p_sequencer.env.spy_if.check_no_idle_tx_mii()) // because is unidir per Clause 66
               begin
                    data_on_mii = data_on_mii + 1;
               end
               //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
               //read_data_chk(read_data,'h2);
               repeat(1) @(posedge p_sequencer.env.spy_if.clk);
          end
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
          `uvm_info(get_name(), $sformatf("Enable SNPS errors check"), UVM_NONE);
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.enable_10_25G_snps_errors();
          `endif          
          
          if(data_on_mii == 0)
          begin
               `uvm_error(get_name(), $sformatf("data on tx mii has idle symbol value, please take a look at waves and confirm it is not caused by remote fault when link fault is off."));
          end
          
          data_on_mii = 0;
          
          fork
          begin
               send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
          end
          
          begin
               send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
          end
          
          begin
               for(int j=0;j<$urandom_range(10,15);j++)
               begin 
                    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
                    `uvm_info(get_name(), $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
               end
               `uvm_info(get_name(), $sformatf("Disable SNPS errors"), UVM_LOW);
               `ifdef ENABLE_ETH_VIP
               p_sequencer.env.disable_10_25G_snps_errors();
               `endif  
               
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,$urandom_range(4,500));//start
             
          end
          join_none
          
          `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
          wait(p_sequencer.env.spy_if.check_mii_rx_remote_fault());
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
          
          //This dummy read is to accomodate thertl internal dealy to update the register
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //if (p_sequencer.env.tb_cfg.pcs_40g_mode) // 2 dummy reads only for 40g
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
          //read_data_chk(read_data,'h2);
          repeat(6) @(posedge p_sequencer.env.spy_if.clk); 
          
          `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
          while (p_sequencer.env.spy_if.remote_fault == 1'b1)
          begin
               if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
               begin
                    data_on_mii = data_on_mii + 1;
               end
               //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
               //read_data_chk(read_data,'h2);
               repeat(1) @(posedge p_sequencer.env.spy_if.clk);
          end
          
          `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
          `uvm_info(get_name(), $sformatf("Enable SNPS errors check"), UVM_NONE);
          `ifdef ENABLE_ETH_VIP
          p_sequencer.env.enable_10_25G_snps_errors();
          `endif             
          
          if(data_on_mii == 0)
          begin
               `uvm_error(get_name(), $sformatf("data on tx mii has idle symbol value, please take a look at waves and confirm it is not caused by remote fault when link fault is off."));
          end
          
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          
          #50us;
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_testsuite_lf_cl81_comp_tc_13_seq
// Descriptions: 
//*******************************************************************************
class eth1025_testsuite_lf_cl81_comp_tc_13_seq extends eth1025_base_sequence;
  
     `uvm_object_utils(eth1025_testsuite_lf_cl81_comp_tc_13_seq)
     
     integer first_case, last_case;
     
     function new(string name = "eth1025_testsuite_lf_cl81_comp_tc_13_seq");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
               `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_13_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
          end
          else begin
               first_case = 13;
          end
          if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
               `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_13_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
          end
          else begin
               last_case = 13;
          end
     endfunction:new
     
     virtual task pre_body();
     endtask; // pre_body
     
     virtual task body();
     
          `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_13_seq", "Executing eth1025_testsuite_lf_cl81_comp_tc_13_seq ...", UVM_NONE)
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          fork
          begin
               p_sequencer.env.ts_tasks_if.start_testsuite_test();
               `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_13_seq", "start_testsuite_test done ...", UVM_NONE)
               p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_XLGMII_CGMII_CL81_COMP_TP",13,13);
               
               fork
                    p_sequencer.env.ts_tasks_if.monitor_error_event();
                    p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
               join_any
          end
          
          begin
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,180);  
          end
          join
          #1us;
     endtask
endclass : eth1025_testsuite_lf_cl81_comp_tc_13_seq


//Class : eth1025_testsuite_lf_cl81_comp_tc_14_seq
class eth1025_testsuite_lf_cl81_comp_tc_14_seq extends eth1025_base_sequence;

     `uvm_object_utils(eth1025_testsuite_lf_cl81_comp_tc_14_seq)
     
     function new(string name = "eth1025_testsuite_lf_cl81_comp_tc_14_seq");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task pre_body();
     endtask; // pre_body
     
     virtual task body();
          `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_14_seq", "Executing eth1025_testsuite_lf_cl81_comp_tc_14_seq ...", UVM_NONE)
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          fork
          begin
               p_sequencer.env.ts_tasks_if.start_testsuite_test();
               `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_14_seq", "start_testsuite_test done ...", UVM_NONE)
               p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_XLGMII_CGMII_CL81_COMP_TP",14,14);
               fork
                    p_sequencer.env.ts_tasks_if.monitor_error_event();
                    p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
               join_any
          end          
          begin
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,180);  
          end 
          join
          
          #1us;
     endtask; 
endclass : eth1025_testsuite_lf_cl81_comp_tc_14_seq

class eth1025_testsuite_lf_cl81_comp_tc_15_seq extends eth1025_base_sequence;
  
     `uvm_object_utils(eth1025_testsuite_lf_cl81_comp_tc_15_seq)
     
     function new(string name = "eth1025_testsuite_lf_cl81_comp_tc_15_seq");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_15_seq", "Executing eth1025_testsuite_lf_cl81_comp_tc_15_seq ...", UVM_NONE)
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          fork :case_15_fork
          begin
               p_sequencer.env.ts_tasks_if.start_testsuite_test();
               `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_15_seq", "start_testsuite_test done ...", UVM_NONE)
               p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_XLGMII_CGMII_CL81_COMP_TP",15,15);
               fork
                    p_sequencer.env.ts_tasks_if.monitor_error_event();
                    p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
               join_any
          end
          begin
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,500);  
          end  
          join
          
          #1us;
     endtask; 

endclass : eth1025_testsuite_lf_cl81_comp_tc_15_seq

//Class : eth1025_testsuite_lf_cl81_comp_tc_16_seq
class eth1025_testsuite_lf_cl81_comp_tc_16_seq extends eth1025_base_sequence;
  
     `uvm_object_utils(eth1025_testsuite_lf_cl81_comp_tc_16_seq)
     
     function new(string name = "eth1025_testsuite_lf_cl81_comp_tc_16_seq");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_16_seq", "Executing eth1025_testsuite_lf_cl81_comp_tc_16_seq ...", UVM_NONE)
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          fork :case_16_fork
          begin
               p_sequencer.env.ts_tasks_if.start_testsuite_test();
               `uvm_info("eth1025_testsuite_lf_cl81_comp_tc_16_seq", "start_testsuite_test done ...", UVM_NONE)
               p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_XLGMII_CGMII_CL81_COMP_TP",16,16);
               fork
                    p_sequencer.env.ts_tasks_if.monitor_error_event();
                    p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
               join_any
          end
          begin
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,500);  
          end
          join
          #1us;
     endtask; 

endclass : eth1025_testsuite_lf_cl81_comp_tc_16_seq

//*******************************************************************************
// Sequence Name: eth1025_link_local_fault_128blk_sequence
// Descriptions: ???
//*******************************************************************************
class eth1025_link_local_fault_128blk_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     bit link_fault_en,success;
     int data_on_mii = 0 ;
     int case_no=1;
     int delay_count;
     `ifdef G100  
          int max_colm=32;
     `else
          int max_colm=64;
     `endif
     
     `uvm_object_utils(eth1025_link_local_fault_128blk_sequence)
     
     function new(string name = "eth1025_link_local_fault_128blk_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.wait_rx_pcs_ready();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          //TEMP DISABLE this register check FB - https://fogbugz.altera.com/default.asp?592982#5260616
          reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
          
          // ***** No need to set any registers in ehip, parameter already takes care of it *****//
          link_fault_en = 1 ;//$urandom_range(0,1);
          `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_NONE);
          read_data[0]  = link_fault_en; 
          //read_data[1]  = $urandom_range(0,1);
          reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          //case - 1 //send alternate patter of fault symbol
          `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.local_fault == 1'b0);
               
          `ifdef G100  
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          repeat(8) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          repeat(16) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          repeat(24) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          `else
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          repeat(10) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          repeat(20) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          repeat(30) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          `endif
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.local_fault == 1'b1);
               
          for( int i =(max_colm - 5)  ;i<max_colm;i++) 
          begin
               case_no = case_no + 1 ;
               `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
               `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
               wait(p_sequencer.env.spy_if.local_fault == 1'b0);
               
               //case -2 // send fault oreder set such that they exact meet 128 column boundary
               send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
               
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
               `ifdef G100
                    repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
                    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
                    repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
                    send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
               `endif  
               
               `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
               wait(p_sequencer.env.spy_if.local_fault == 1'b1);
          
          end
          
          case_no = case_no + 1 ;
          `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.local_fault == 1'b0);
          
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          
          `ifdef G100  
               success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
          `else
               success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
          `endif
          
          `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
          if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
          repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          
          `ifdef G100  
               success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
          `else
               success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
          `endif
          
          `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
          if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
          repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          
          `ifdef G100  
               success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
          `else
               success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
          `endif
          
          `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
          if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
          repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT,1);//start
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.local_fault == 1'b1);
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.local_fault == 1'b0);
          
          #100ns;
     
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_link_remote_fault_128blk_sequence
// Descriptions: ???
//*******************************************************************************
class eth1025_link_remote_fault_128blk_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     bit link_fault_en,success;
     int data_on_mii = 0 ;
     int case_no=1;
     int delay_count;
     `ifdef G100  
          int max_colm=32;
     `else
          int max_colm=64;
     `endif  
     `uvm_object_utils(eth1025_link_remote_fault_128blk_sequence)
     
     function new(string name = "eth1025_link_remote_fault_128blk_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          
          p_sequencer.env.wait_rx_pcs_ready();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          //TEMP DISABLE this register check FB - https://fogbugz.altera.com/default.asp?592982#5260616
          reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
          
          // ***** No need to set any registers in ehip, parameter already takes care of it *****//
          link_fault_en = 1 ;//$urandom_range(0,1);
          `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_NONE);
          //read_data[0]  = link_fault_en; 
          //read_data[1]  = $urandom_range(0,1);
          //reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          //case - 1 //send alternate patter of fault symbol
          `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
               
          `ifdef G100  
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          repeat(8) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          repeat(16) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          repeat(24) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          `else
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          repeat(10) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          repeat(20) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          repeat(30) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          `endif  
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
               
          for( int i =(max_colm - 5)  ;i<max_colm;i++) 
          begin
               case_no = case_no + 1 ;
               `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
               `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
               wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
               //case -2 // send fault oreder set such that they exact meet 128 column boundary
               send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
          
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          `ifdef G100
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
               repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          `endif  
          
               `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
               wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
               
               send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
          
          end
          
          case_no = case_no + 1 ;
          `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          
          `ifdef G100  
          success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
          `else
          success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
          `endif  
          `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
          if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
          repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          
          `ifdef G100  
          success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
          `else
          success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
          `endif  
          `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
          if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
          repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          
          `ifdef G100  
          success = std::randomize (delay_count) with {delay_count dist {[1:15]:=8,[16:27]:=1,[28:31]:=8};};
          `else
          success = std::randomize (delay_count) with {delay_count dist {[1:20]:=8,[21:59]:=1,[60:63]:=8};};
          `endif  
          `uvm_info(get_name(), $sformatf("case ::%d success=%0d delay_count=%0d", case_no,success,delay_count), UVM_NONE);
          if(!success) `uvm_error(get_name(), $sformatf("Randomisation failed"));
          repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
          
          send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,1);//start
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 1 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b1);
          
          `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
          wait(p_sequencer.env.spy_if.remote_fault == 1'b0);
          
          #100ns;
     
     endtask
endclass

//*******************************************************************************
// Sequence Name: eth1025_link_fault_morethan128nblk_sequence
// Descriptions: ???
//*******************************************************************************
class eth1025_link_fault_morethan128nblk_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data;
     bit link_fault_en,success;
     int fault_pair = 0 ;
     int case_no=0;
     int fault_count=0;
     int delay_count;
     `ifdef G100  
          int max_cnt=32;
     `else
          int max_cnt=64;
     `endif  
     svt_ethernet_enum_pkg::link_fault_sequence_type_enum local_link_fault_type;
     
     `uvm_object_utils(eth1025_link_fault_morethan128nblk_sequence)
     
     function new(string name = "eth1025_link_fault_morethan128nblk_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          apply_hard_reset(0,0,1,11);
          dis_vec_sb();
          dis_stats_chk = 1;
          p_sequencer.env.wait_rx_pcs_ready();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
          
          
          //reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
          
          //TEMP DISABLE this register check FB - https://fogbugz.altera.com/default.asp?592982#5260616
          reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
          
          
          // ***** No need to set any registers in ehip, parameter already takes care of it *****//
          link_fault_en = 1 ;//$urandom_range(0,1);
          `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_NONE);
          //read_data[0]  = link_fault_en; 
          //read_data[1]  = $urandom_range(0,1);
          //reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          success = $urandom_range(0,1);
          if(success) begin 
               local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_LOCAL_LINK_STATE_FAULT; 
          end
          else begin
               local_link_fault_type = svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT; 
          end
          
          
          fork : thread_1 
          begin
               //case 1 to 4
               for( int i = max_cnt-1;i<max_cnt+10;i++) 
               begin
                    case_no = case_no + 1 ;
                    `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
                    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
                    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
               
                    send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,1);
               
                    send_link_fault(local_link_fault_type,1);//start
                    repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
                    send_link_fault(local_link_fault_type,1);//start
                    repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
                    send_link_fault(local_link_fault_type,1);//start
                    repeat(i) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
                    send_link_fault(local_link_fault_type,1);//start
                    //delay for link fault asserion check
                    repeat(100) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               end
          
               //case 5 onwards 
               for(int k=0;k<10;k++)
               begin
                    case_no = case_no + 1 ;
                    `uvm_info(get_name(), $sformatf("case ::%d", case_no), UVM_NONE);
                    `uvm_info(get_name(), $sformatf("case ::%d - waiting for link fault signal to be 0 ", case_no), UVM_NONE);
                    delay_count = $urandom_range(max_cnt+10,max_cnt+100);
                    fault_pair =  $urandom_range(1,3);
                    `uvm_info(get_name(), $sformatf("case ::%d - sending %0d pairs of link faults seperated by %0d clocks",case_no,fault_pair,delay_count), UVM_NONE);
                    send_link_fault(local_link_fault_type,fault_pair);
                    repeat(delay_count) @(posedge  p_sequencer.env.spy_if.rx_mac_mii_clk);
               end
          
               //approx time to finish and reach all link fault os to rtl
               #3000ns;	
               disable thread_1; 
          end
          
          begin
               forever begin
                    @(posedge p_sequencer.env.spy_if.fault);
                    fault_count = fault_count + 1;
                    `uvm_info(get_name(), $sformatf("fault_count ::%d", fault_count), UVM_NONE);
               end
          end
          join
               
          `uvm_info(get_name(), $sformatf("final fault_count ::%d", fault_count), UVM_NONE);
          
          //we cant predict exact delay between two os as we send data from vip serial lane and link fault chekcing happens on mii so it is possible to see +/-1 mii clock tolerance
          // as we send the os with gap of 63 and 64 in case 1,2, it may possible that fault detection happens one or twice based on 126-128 column boundary.
          // this case gaurantee > 130 gap between os wont result in link fault instead accurate 128 column
          // For C2E, tolerence observed is +/-2 hence max we shall see is 3
          // (For C2E 50G random seed 4051 with B181 we see 4 RF's being detected and looks legitimate - hence increasing to 4)
          if(fault_count > 4 ) begin
               `uvm_error(get_name(), $sformatf("false link fault detected"));
          end
          #100ns;
     
     endtask
endclass

////Class : eth_link_local_fault_simplex_sequence
////This sequence test remore link fault in duplex mode
//class eth_link_local_fault_simplex_sequence extends eth1025_base_sequence;
//  uvm_reg_data_t read_data;
//  bit link_fault_en;
//
//  `uvm_object_utils(eth_link_local_fault_simplex_sequence)
//
//  function new(string name = "eth_link_local_fault_simplex_sequence");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
// endfunction:new
//
//  virtual task body();
//    apply_hard_reset(0,0,1,11);
//    dis_vec_sb();
//    dis_stats_chk = 1;
//    p_sequencer.env.wait_rx_pcs_ready();
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    //if (p_sequencer.env.tb_cfg.pcs_40g_mode) 
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    //else 
//    //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);  
//     
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
// 
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
//   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
//
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    link_fault_en =  $urandom_range(0,1);
//    `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
//    read_data[0] = link_fault_en; 
//    read_data[1] = 0; //Disable (clause-66) unidirection
//    reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
// 
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
//
//    fork
//     begin
//       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,5);
//     end
//  
//     begin
//       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,5);
//     end
//
//     begin
//       for(int j=0;j<$urandom_range(1,4);j++)
//       begin 
//         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
//         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
//       end
//       generate_hiber();
//     end
//   join_none
//
//   `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.check_rx_mii_local_fault());
//        
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b1);
//    
//    //This dummy read is to accomodate thertl internal dealy to update the register
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//    read_data_chk(read_data,'h1);
//    
//   `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
//    while (p_sequencer.env.spy_if.local_fault == 1'b1)
//    begin
//      if(link_fault_en == 1'b1) begin
//     
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is enabled."), UVM_DEBUG); 
//          end
//          else
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is enabled."));
//          end
//        end
//      end
//      else
//      begin
//       // if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
//       // begin
//       //   `uvm_info(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii correct when link fault is disable."), UVM_NONE); 
//       // end
//       // else
//       // begin
//       //   `uvm_error(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii incorrect when link fault is disabl."));
//       // end
//
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disable."));
//          end
//          else
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is disable."), UVM_DEBUG); 
//          end
//        end
//      end
//    
//     reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//     read_data_chk(read_data,'h1);
//    end
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
//
//    fork
//     begin
//       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
//     end
//  
//     begin
//       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
//     end
//
//     begin
//       for(int j=0;j<$urandom_range(10,20);j++)
//       begin 
//         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
//         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
//       end
//       generate_hiber();
//     end
//   join_none
//
//   `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.check_rx_mii_local_fault());
//  
//    `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b1);
//
//    //This dummy read is to accomodate thertl internal dealy to update the register
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//    read_data_chk(read_data,'h1);
//
//   `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
//    while (p_sequencer.env.spy_if.local_fault == 1'b1)
//    begin
//      if(link_fault_en == 1'b1) begin
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is enabled."), UVM_DEBUG); 
//          end
//          else
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is enabled."));
//          end
//        end
//      end
//      else
//      begin
//      //  if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
//      //  begin
//      //    `uvm_info(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii correct when link fault is disable."), UVM_NONE); 
//      //  end
//      //  else
//      //  begin
//      //    `uvm_error(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii incorrect when link fault is disabl."));
//      //  end
//
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
//          end
//          else
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is disable."), UVM_DEBUG); 
//          end
//        end
//      end
//    
//     reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//     read_data_chk(read_data,'h1);
//    end
//   
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
//
//    //This dummy read is to accomodate thertl internal dealy to update the register
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//    #50us; 
// 
//  endtask
//endclass

////Class : eth_link_local_fault_duplex_sequence
////This sequence test local link fault in duplex mode
//class eth_link_local_fault_duplex_sequence extends eth1025_base_sequence;
//  uvm_reg_data_t read_data;
//  bit link_fault_en;
//
//  `uvm_object_utils(eth_link_local_fault_duplex_sequence)
//
//  function new(string name = "eth_link_local_fault_duplex_sequence");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
// endfunction:new
//
//  virtual task body();
//
//    apply_hard_reset(0,0,1,11);
//    dis_vec_sb();
//    dis_stats_chk = 1;
//
//    p_sequencer.env.wait_rx_pcs_ready();
//
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    link_fault_en =  0;//$urandom_range(0,1);
//    `uvm_info(get_name(), $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
//    read_data[0] = link_fault_en; 
//    read_data[1] = 0; //Disable (clause-66) unidirection
//    reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    //if (p_sequencer.env.tb_cfg.pcs_40g_mode) 
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    //else 
//    //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);  
//     
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
//
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
//   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    
//
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
//
//    fork
//     begin
//       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,5);
//     end
//  
//     begin
//       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,5);
//     end
//
//     begin
//       for(int j=0;j<$urandom_range(2,4);j++)
//       begin 
//         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
//         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
//       end
//       generate_hiber();
//     end
//   join_none
//
//   `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.check_rx_mii_local_fault());
// 
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b1);
//    
//    //This dummy read is to accomodate thertl internal dealy to update the register
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//    read_data_chk(read_data,'h1);
//    
//   `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
//    while (p_sequencer.env.spy_if.local_fault == 1'b1)
//    begin
//      if(link_fault_en == 1'b1) begin
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is enabled."), UVM_DEBUG); 
//          end
//          else
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is enabled."));
//          end
//        end
//      end
//      else
//      begin
//      //  if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
//      //  begin
//      //    `uvm_info(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii correct when link fault is disable."), UVM_NONE); 
//      //  end
//      //  else
//      //  begin
//      //    `uvm_error(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii incorrect when link fault is disabl."));
//      //  end
//
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
//          end
//          else
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is disable."), UVM_DEBUG); 
//          end
//        end
//      end
//    
//     reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//    read_data_chk(read_data,'h1);
//    end
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
//
//    fork
//     begin
//       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
//     end
//  
//     begin
//       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
//     end
//
//     begin
//       for(int j=0;j<$urandom_range(10,15);j++)
//       begin 
//         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
//         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
//       end
//       generate_hiber();
//     end
//   join_none
//
//   `uvm_info(get_name(), $sformatf("waiting for remote order set on rx mii"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.check_rx_mii_local_fault());
//  
//    `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 1"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b1);
//
//    //This dummy read is to accomodate thertl internal dealy to update the register
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//    read_data_chk(read_data,'h1);
//
//   `uvm_info(get_name(), $sformatf("waiting for idle order set on tx mii"), UVM_NONE);
//    while (p_sequencer.env.spy_if.local_fault == 1'b1)
//    begin
//      if(link_fault_en == 1'b1) begin
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is enabled."), UVM_DEBUG); 
//          end
//          else
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is enabled."));
//          end
//        end
//      end
//      else
//      begin
//     //   if(p_sequencer.env.spy_if.check_no_idle_tx_mii())
//     //   begin
//     //     `uvm_info(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii correct when link fault is disable."), UVM_NONE); 
//     //   end
//     //   else
//     //   begin
//     //     `uvm_error(get_name(), $sformatf("CHECK_NO_IDLE_TX_MII:data on tx mii incorrect when link fault is disabl."));
//     //   end
//
//        if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//        begin
//          if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//          begin
//            `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
//          end
//          else
//          begin
//            `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is disable."), UVM_DEBUG); 
//          end
//        end
//      end
//    
//     reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data,1);
//    read_data_chk(read_data,'h1);
//    end
//   
//   `uvm_info(get_name(), $sformatf("waiting for link fault signal to be 0"), UVM_NONE);
//    wait(p_sequencer.env.spy_if.local_fault == 1'b0);
//    
//    //This dummy read is to accomodate thertl internal dealy to update the register
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//    #50us; 
//  endtask
//endclass

////Class : eth_link_local_fault_duplex_sequence
////This sequence test local link fault in duplex mode
//class eth_force_link_remote_fault_sequence extends eth1025_base_sequence;
//  uvm_reg_data_t read_data,tx_link_reg;
//  bit remote_fault_disable;
//  int read_cnt=0,random_cnt;
//  bit link_fault_en,chk_rmt_flt=0;
//
//  `uvm_object_utils(eth_force_link_remote_fault_sequence)
//
//  function new(string name = "eth_force_link_remote_fault_sequence");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
// endfunction:new
//
//  virtual task body();
//    apply_hard_reset(0,0,1,11);
//    dis_vec_sb();
//    dis_stats_chk = 1;
//
//    p_sequencer.env.wait_rx_pcs_ready();
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
//
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
//
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_local_fault_signal_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
//   p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
//   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
//   //p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
//
//
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    link_fault_en =  $urandom_range(0,1);
//    read_data[0] = link_fault_en;
//    read_data[2:1] = $urandom_range(0,3);
//    `uvm_info("main_phase", $sformatf("link_fault_en::%d", link_fault_en), UVM_LOW);
//    reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//
//    fork
//     begin
//       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,25);
//     end
//  
//     begin
//       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
//     end
//
//     begin
//       for(int j=0;j<$urandom_range(10,25);j++)
//       begin 
//         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
//         `uvm_info("main_phase", $sformatf("FRAME::%d accepted by PHY agent", j), UVM_LOW);
//       end
//       reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
//       tx_link_reg[3] = 1; 
//       reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
//       chk_rmt_flt = 1;
//     end
//     join_none
//     
//     random_cnt = $urandom_range(10,50);
//    `uvm_info("main_phase", $sformatf("random_cnt::%d", random_cnt), UVM_LOW);
//     
//    wait(chk_rmt_flt == 1);
//
//     reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//     reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
//     while(tx_link_reg[3] == 1)
//     begin
//        if(link_fault_en == 1) begin
//          if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//          begin
//            if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//            begin
//              `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii correct when link fault is enabled."), UVM_DEBUG); 
//            end
//            else
//            begin
//              `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is enabled."));
//            end
//          end
//        end 
//	else
//	begin
//          if(p_sequencer.env.spy_if.mii_valid_tx == 1'b1)
//          begin
//            if(p_sequencer.env.spy_if.check_tx_mii_remote_fault())
//            begin
//              `uvm_error(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT:data on tx mii incorrect when link fault is disabl."));
//            end
//            else
//            begin
//              `uvm_info(get_name(), $sformatf("CHECK_TX_MII_REMOTE_FAULT :data on tx mii correct when link fault is disable."), UVM_DEBUG); 
//            end
//          end
//        end
//
//       reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
//       reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//       read_cnt = read_cnt + 1;
//
//       if(read_cnt == random_cnt)
//       begin
//         tx_link_reg[3] = 0; 
//         reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_link_reg);
//         break;
//       end
//     end
// 
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    reg_read(`ETH_F_ALL_link_fault_status_OFFSET_REG,read_data);
//
//    send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5);
// 
//    #1us;
//    
//  endtask
//endclass
