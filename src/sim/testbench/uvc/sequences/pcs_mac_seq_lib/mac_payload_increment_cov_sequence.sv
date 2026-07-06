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


class mac_payload_increment_cov_sequence extends eth_base_sequence;

  `uvm_object_utils(mac_payload_increment_cov_sequence)
  bit [47:0] src_address;
  int data_width;
  int start_index;
  int end_index;
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
    `uvm_info("eth_seq_lib", "running mac_payload_increment_cov_sequence\n",UVM_LOW)
    `ifdef ENABLE_ETH_VIP
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    
    //muralasx: Added below logic to insert unique unicast source address when the parameter sa =1
    if(p_sequencer.env.dyn_rcfg_obj_inst.sa==1) begin
       src_address = $random();
       src_address[40]=0;
       $display("Source address %0h",src_address);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[47:32]);
    end

    //adding this condition only for avst,starting the loop count with i=3 as we are not adding the sip limit condition     
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
    	send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5); 
        p_sequencer.env.wait_tx_frames_received(.exp_num(5),.timeout_time(1ms));
    end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode==PCSMAC) begin
	    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),64000);
        case(p_sequencer.env.dyn_rcfg_obj_inst.speed)
         _10G,_25G : data_width= 8; //(64 bits = 8 bytes)
         _40G,_50G : data_width = 16; //128bits = 16 bytes
         _100G     : data_width  = 64; //512bits = 64 byts
	    endcase

        randcase
	      50: begin
	           start_index = 3; 
               end_index   = 500; 
	          end	
	      50: begin
	           start_index = 501; 
               end_index   = 1000; 
	          end    
        endcase      
        `uvm_info("eth_seq_lib",$sformatf("start_index=%0d, end_index=%0d",start_index, end_index),UVM_NONE);

	    fork
	    begin
	    	for (int i = start_index ; i <= end_index; i++) begin
	    		send_eth_frame_with_fix_size(DATA_FRAME,(i*data_width),1,AVL_TX_ETH_VIP);
        		end
        	end
        	begin
	    	for (int i = start_index ; i <= end_index; i++) begin //interms of bytes
	    		send_eth_frame_with_fix_size(DATA_FRAME,(i*data_width),1,ETH_VIP_AVL_RX);
           		end
	    end
	    join
    end  
    #25us;
  
  endtask
endclass
