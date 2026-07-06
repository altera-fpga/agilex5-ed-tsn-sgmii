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


class eth_link_remote_fault_rand_sequence extends eth_base_sequence;
  `uvm_object_utils(eth_link_remote_fault_rand_sequence)
  
  uvm_reg_data_t read_data;
  bit link_fault_en;
  int read_count=0;
  rand bit link_fault_type;
  bit link_fault_detected;
  int rx_pkt_cnt_b4_lf =0;
  int rx_pkt_cnt_after_lf=0;
  bit [1:0] exp_lf=2'b00;

  // 0 : local_fault, 1 : remote_fault
  //constraint lf_c { link_fault_type dist {0:=50, 1:=50};}
  constraint lf_c { link_fault_type == 1;}

  function new(string name = "eth_link_remote_fault_rand_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    super.body();
    this.randomize();

    //10m simulation time is more than 4 days
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10M) begin
       fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,2);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,2);  
       join
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(2),.timeout_time(1ms));
       p_sequencer.env.wait_tx_frames_received(.exp_num(2),.timeout_time(1ms));    
    end else begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,10);
       `uvm_info(get_name(), $sformatf("lf_remote_sequence: waiting for mac_tx_vip_rx received frames should become 10"),UVM_NONE);
       p_sequencer.env.wait_tx_frames_received(10);
       `uvm_info(get_name(), $sformatf("lf_remote_sequence: wait done for mac_tx_vip_rx received frames should become 10"),UVM_NONE);

       // 0 : lf_off, 1 : Unidirectional, 2 : Bidirectional
       `uvm_info(get_name(),$sformatf("lf_remote_sequence : Link fault option selected is %0d",p_sequencer.env.dyn_rcfg_obj_inst.lf),UVM_NONE);

       case(p_sequencer.env.dyn_rcfg_obj_inst.lf)
        2'b00 : exp_lf = 2'b00;       
        2'b01 : exp_lf = 2'b11;       
        2'b10 : exp_lf = 2'b01;       
      endcase

      p_sequencer.env.reg_read(`GET_REG_ADDR(tx_unidir_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
      `uvm_info(get_name(), $sformatf("lf_remote_sequence :tx_unidirectional control register read data %0d",read_data),UVM_NONE);

      //Disable VIP checker assertion based on link_fault mode 
      if(p_sequencer.env.dyn_rcfg_obj_inst.lf == 2'd2) begin
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::NOTE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::NOTE); // Only for ehip
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::NOTE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::NOTE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::NOTE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::NOTE);
        //25G Errors
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
        //200G Errors
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);

        //Disable mac_tx_vip_rx scoreboard
        p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=1;
      end
      
      p_sequencer.env.sb_mac_tx_vip_rx.scb_dis=1;
      p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 0;
      `uvm_info(get_name(),$sformatf("lf_remote_sequence: Remote link fault type selected"),UVM_NONE);

       fork
          begin
            send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,30,1);
          end
     
          begin
            `uvm_info(get_name(),$sformatf("lf_remote_sequence: Sending REMOTE FAULT frames from VIP TX"),UVM_NONE);       
            for(int i = 0; i < 120; i++) begin //60
              send_link_fault(svt_ethernet_enum_pkg::ETH_MAC_REMOTE_LINK_STATE_FAULT,750);
            end
            `uvm_info(get_name(),$sformatf("lf_remote_sequence: Done Sending REMOTE FAULT frames from VIP TX"),UVM_NONE);       
          end
       join_none


       `uvm_info(get_name(), $sformatf("lf_remote_sequence: waiting for link fault signal to be 1"), UVM_NONE);
       link_fault_detected = 0;
       read_count = 0;

      fork
      begin        
      fork
        begin
	   if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10G) begin
           	wait(p_sequencer.env.spy_if.lf_status == 2'b10);
           	`uvm_info(get_name(),$sformatf("lf_remote_sequence : link remote fault detected"),UVM_NONE);
	   end
	   else begin
          	`uvm_info(get_name(),$sformatf("lf_remote_sequence:LINK FAULT is not available for IP Variants other than 10G. ll_var is %s",p_sequencer.env.dyn_rcfg_obj_inst.ll_var),UVM_NONE); // [LL10G] HSDES:16018733974 -> LINK FAULT is not available for IP Variants other than 10G. MGE supports 2.5G and 1G only
	   end
        end
        begin
           #50us;
           `uvm_error(get_name(), $sformatf("lf_remote_sequence: Waiting timeout for link remote fault signal to become 2"))
        end
      join_any
      disable fork;
      end
      join

       //rx_pkt_cnt_b4_lf = p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt;
       rx_pkt_cnt_b4_lf = p_sequencer.env.eth_ref_model_inst.transaction_id_rx;
       `uvm_info(get_name(),$sformatf("lf_remote_sequence : received rx_pkt count before link_fault =%0d",rx_pkt_cnt_b4_lf),UVM_NONE);

       `uvm_info(get_name(), $sformatf("lf_remote_sequence: waiting for link fault signal to be 0 after link fault detected"), UVM_NONE);
       link_fault_detected = 1;
       read_count = 0;

      fork
      begin        
      fork
        begin
           wait(p_sequencer.env.spy_if.lf_status == 2'b00);
           `uvm_info(get_name(),$sformatf("lf_remote_sequence : No link fault detected"),UVM_NONE);
        end
        begin
           #1ms;
           `uvm_error(get_name(), $sformatf("lf_remote_sequence: Waiting timeout for link fault signal to become 0"))
        end
      join_any
      disable fork;
      end
      join

       #30us;

       //rx_pkt_cnt_after_lf = p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt;
       rx_pkt_cnt_after_lf = p_sequencer.env.eth_ref_model_inst.transaction_id_rx;
       `uvm_info(get_name(),$sformatf("lf_remote_sequence : received rx_pkt count after link_fault =%0d",rx_pkt_cnt_after_lf),UVM_NONE); 

       if(p_sequencer.env.dyn_rcfg_obj_inst.lf == 2'b01) begin
            if(rx_pkt_cnt_after_lf == 40)begin
               `uvm_info(get_name(),$sformatf("lf_remote_sequence : no loss of packet in TX direction"),UVM_NONE);      
            end else begin
               `uvm_error(get_name(), $sformatf("lf_remote_sequence: Expecting no loss of frames in TX direction "))      
            end
       end else begin
            if(rx_pkt_cnt_after_lf < 40 ) begin //grey windiw
               `uvm_info(get_name(),$sformatf("lf_remote_sequence : loss of packet in TX direction"),UVM_NONE);      
            end else begin
               `uvm_error(get_name(), $sformatf("lf_remote_sequence: Expecting loss of frames in TX direction "))      
            end     
       end
    end
    #20us;
    `uvm_info(get_name(),$sformatf("lf_remote_sequence: Sequence completed"),UVM_NONE);

    endtask
endclass
