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


class preamble_pass_sequence extends eth_base_sequence;
  preamble_sequence tx_seq;
                bit preamble_pass;
                bit rx_crc_pass;
  bit [47:0] src_address;
     uvm_reg_data_t rd_data;
     uvm_reg_data_t txmac_ehip_cfg;
     uvm_reg_data_t rxmac_ehip_cfg;
  `uvm_object_utils(preamble_pass_sequence)
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
    tx_seq=new("tx_seq");  
  endfunction:new

  virtual task body();
    `uvm_info(get_full_name(), "running preamble_pass_sequence\n",UVM_LOW)
    num_of_frames =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 10:50; 
    wait(p_sequencer.env.sideband_if.tx_lane_stable==1);
    preamble_pass = $urandom_range(0,1);
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),preamble_pass); 
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),preamble_pass); 
    
    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    
     fork
      begin
	  	if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
           tx_seq.itr_cnt = 10;      
        end
        tx_seq.start(p_sequencer.tx_seqr);
      end
      begin
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
      end
     join
	 p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames),.timeout_time(1ms));

      p_sequencer.env.reg_read(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);

      preamble_pass = $urandom_range(0,1);
      p_sequencer.env.reg_write(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),preamble_pass); 
      p_sequencer.env.reg_write(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),preamble_pass); 

      fork
       begin
	      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
           tx_seq.itr_cnt = 10;      
          end
         tx_seq.start(p_sequencer.tx_seqr);
       end
       begin
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
       end
      join
	  p_sequencer.env.wait_client_rx_frames_done(.exp_num(num_of_frames*2),.timeout_time(1ms));
	  if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
	       p_sequencer.env.wait_tx_frames_received(.exp_num(20),.timeout_time(1ms));
	  end
    `else
        tx_seq.start(p_sequencer.tx_seqr);
    `endif

   endtask
endclass
