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


class pcs_sanity_sequence extends eth_base_sequence;
  bit rx_crc_pass;
  
  `uvm_object_utils(pcs_sanity_sequence)
  
  function new(string name = "seq_0");
    super.new(name);
     `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=200;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
   `uvm_info("eth_seq_lib", "running sanity sequence\n",UVM_LOW)
   rx_crc_pass=$urandom;
   `ifdef ENABLE_ETH_VIP
      p_sequencer.env.mac_cfg.print();
   `endif
   
    if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN || p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE) begin
      //Disabling vector scoreboard and stat checking in PCS_ONLY mode
      dis_stats_chk=1;
      dis_vec_sb();
    end

   `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN || p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE) begin
       p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     end
   `endif
   fork
	begin // Tx path
	   if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSONLY) begin
	      repeat(num_of_frames) begin
		 if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		    randcase 
		      10 : send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1); 
		      1  : send_eth_frame(UNDERSIZE_FRAME,AVL_TX_ETH_VIP,1); 
		    endcase
		 end else
		   send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
	      end
	   end
          `ifdef ENABLE_ETH_VIP
	   if (p_sequencer.env.dyn_rcfg_obj_inst.mode == OTN || p_sequencer.env.dyn_rcfg_obj_inst.mode == FLEXE) begin
	      repeat(num_of_frames) begin
		 randcase 
		   10 : send_eth_frame(RANDOM_FRAME,OTN_MODE,1); 
		   1  : send_eth_frame(UNDERSIZE_FRAME,OTN_MODE,1); 
		 endcase
	      end
	   end
         `endif
	end 
	begin // Rx path
         `ifdef ENABLE_ETH_VIP
	   repeat(num_of_frames) begin
	      if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		 randcase 
		   10 : send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);  
		   1  : send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);  
		 endcase
	      end else begin
                `uvm_info("pcs_sanity_sequence", "start VIP_TX Traffic", UVM_MEDIUM)
		send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1); 
                `uvm_info("pcs_sanity_sequence", "end VIP_TX_TRAFFIC", UVM_MEDIUM)

	      end
	   end // repeat (200)
         `endif
	end
     join     

  // Some drain time to make sure all packetes are processed 
   #10us;

  endtask
endclass : pcs_sanity_sequence
