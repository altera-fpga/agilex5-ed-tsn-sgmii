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



class alt_eth_avalonst_ptp_base_sequence extends uvm_sequence #(eth_packet);
  `uvm_object_utils(alt_eth_avalonst_ptp_base_sequence)
  int unsigned sequence_length = 1;
  ptp_op_e operation;

  typedef enum {_400G,_200G,_100G,_50G,_40G,_25G,_10G} speed_e;
  bit my_speed;
  frame_type eth_frame;
  int payload_size;
  int ipg;
  int bandwidth;
 int pack_size;  
 int coverage_s;
int num_words_local;
 bit ptp_err;
 bit speed_400G;
 bit preamble_pass;

/* constraint ptp_sig_width_c {
 if (my_speed != _400G)
  cf_offset <= 8'hFF; 
} 
*/


  function new(string name = "base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

virtual task body();
    bit status;
  int pl_size;
  
  `uvm_info("body", "Entered ...", UVM_MEDIUM)

//  if (my_speed != _400G)
//    speed_400G = 0;
//  else
//    speed_400G = 1;
  

    for(int i = 0; i < sequence_length; i++) begin
      `uvm_info("body", $sformatf("Calling `uvm_do, iteration=%0d %s", i,eth_frame.name()), UVM_MEDIUM)

     if(eth_frame == IPV4_FRAME) 
        `uvm_do_with(req,{frame_type == ETH_IPV4_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
      else if(eth_frame == IPV6_FRAME)
        `uvm_do_with(req,{frame_type == ETH_IPV6_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local; })
      else if(eth_frame == USER_DEFINED_FRAME) begin
        `uvm_create(req)
        req.payload_size_c.constraint_mode(0);
        void'(std::randomize(pl_size) with {pl_size dist {[46:1500] := 70, [1501:3000] := 30};});
        `uvm_rand_send_with(req,{frame_type == ETH_USER_DEFINED_FRAME; payload.size == pl_size; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local; })
      end  
      else   if(eth_frame == DATA_FRAME)
           begin
	      if(bandwidth==1) begin
	      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;interpacket_gap==ipg;payload.size==payload_size; m_ptp_op == operation;is_ptp_seq ==1;
               speed_400G == speed_400G; num_words==num_words_local; })
      //  $display("Printing transaction");
      //  req.print();
      end
              else if(coverage_s==1) begin
	      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; interpacket_gap==ipg;payload.size==payload_size; m_ptp_op == operation; is_ptp_seq ==1; speed_400G == speed_400G; num_words==num_words_local;}) 
   //$display("Printing transaction");
   //     req.print();

 end
	      else if (ptp_err) begin
	      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_ERR; speed_400G
== speed_400G; num_words==num_words_local;})
       //$display("Printing transaction");
       // req.print();

end
              else if (preamble_pass) begin
                `uvm_create(req)
                 req.preamble_c.constraint_mode(0);
	         `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; interpacket_gap==ipg;/*payload.size==payload_size; */ m_ptp_op == operation; is_ptp_seq ==1; speed_400G == speed_400G; preamble[63:56]==8'hfb; preamble[7:0]==8'hD5; m_ptp_kind == PTP_NORMAL; num_words==num_words_local;}) 
	      

end 
	      else begin
	      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; speed_400G == speed_400G; m_ptp_kind == PTP_NORMAL; num_words==num_words_local;})
      // $display("Printing transaction");
      //  req.print();
end
      end  
      else if(eth_frame == VLAN_FRAME) begin
	      if (ptp_err)
	      `uvm_do_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_ERR; num_words==num_words_local; })
	      else
        `uvm_do_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; m_ptp_kind == PTP_NORMAL; num_words==num_words_local;})
      end
      else if(eth_frame == STACKED_VLAN_FRAME) begin
	      if (ptp_err)
	        `uvm_do_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_ERR; num_words==num_words_local; })
	      else
          `uvm_do_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_NORMAL; num_words==num_words_local;})
      end
      else if(eth_frame == JUMBO_DATA_FRAME)
     	   begin
		   if(bandwidth==1)
	      `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL;interpacket_gap==ipg;payload.size==payload_size; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
              else if (coverage_s==1)
	      `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME;interpacket_gap==ipg;payload.size==payload_size; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
	      else if (ptp_err)
	        `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_ERR; num_words==num_words_local; })
	      else
	      `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; m_ptp_kind == PTP_NORMAL; num_words==num_words_local;})
      end	
      else if(eth_frame == JUMBO_VLAN_FRAME) begin
        if(ptp_err)
	        `uvm_do_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_ERR; num_words==num_words_local;})
	      else
          `uvm_do_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; m_ptp_kind == PTP_NORMAL;num_words==num_words_local;})
      end
      else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
        if(ptp_err)
	        `uvm_do_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1;m_ptp_kind == PTP_ERR; num_words==num_words_local;})
	      else
          `uvm_do_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME;frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; m_ptp_kind == PTP_NORMAL; num_words==num_words_local;})
      end
      else if(eth_frame == CONTROL_FRAME) begin
        if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_do_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
        end  
        else begin
          // XON packets
          `uvm_do_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL;
                            foreach(pfc_pause_quanta[idx])
                              pfc_pause_quanta[idx] == 16'h0;
                            sfc_pause_quanta == 16'h0; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
        end
      end  
      else if(eth_frame == PFC_FRAME) begin
        if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
        end
        else begin
          // XON packets
          `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;
                            foreach(pfc_pause_quanta[idx])
                              pfc_pause_quanta[idx] == 16'h0; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local; num_words==num_words_local;})
        end  
      end    
      else if(eth_frame == SFC_FRAME) begin
        if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_do_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
        end
        else begin
          // XON packets
          `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;
                            sfc_pause_quanta == 16'h0; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
        end  
      end 
        else if(eth_frame == RANDOM_FRAME) begin
        `uvm_do_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
      end
      else if(eth_frame == UNDERSIZE_FRAME) begin
        `uvm_do_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == UNDERSIZE; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
      end
      else if(eth_frame == IPG_STRESS) begin
        `uvm_do_with(req,{frame_type inside {ETH_DATA_FRAME,ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME}; frame_payload_type == NORMAL; payload.size inside{[46:53]};interpacket_gap==0; m_ptp_op == operation; is_ptp_seq ==1; num_words==num_words_local;})
      end
      else 
     `uvm_error("alt_eth_avalonst_ptp_base_sequence", $sformatf("Invalid frame type %0s",eth_frame.name()));
    end
  endtask: body


endclass

class eth_ptp_base_sequence extends eth_base_sequence;

`ifdef ENABLE_ETH_VIP
  `ifdef SER_MON_EN
    bit rand_latency=0;
  `else
    bit rand_latency=1;
  `endif  
`else
  bit rand_latency=0;
`endif  
  int tx_extra_latency;
  int rx_extra_latency;
  int asym_latency;

  //bit [18:0] ETH_ADDR_OFFSET = 19'h0;
  //bit [18:0] FEC_ADDR_OFFSET = 19'h14000;
  bit [31:0]                     ui_value;
  bit [6:0]                      tx_pma_delay;
  bit [6:0]                      rx_pma_delay;
  bit [6:0]                      rx_slip_count;
  bit [38:0]                     tx_ptp_extra_latency;
  bit [38:0]                     rx_ptp_extra_latency;

  bit [4:0]                      vl;
  bit [19:0][38:0]               vl_offset_load_arr;
  bit [19:0]                     vl_offset_collected;

  uvm_reg_data_t read_data;

  rand bit                       rand_skew;

`ifdef RSFEC

  bit [2:0]                      ln;

  bit [1:0]                      phy_ln0_map;
  bit [31:0]                     skew_ln[4];
  bit [31:0]                     cw_pos_rx[4];
  bit [31:0]                     min_val[$];
  bit [31:0]                     min_skew;
  bit [31:0]                     lane_skew_adjust;
  bit [31:0]                     Tlat_final;
  

  typedef struct packed {
      bit [1:0]  selected_pl;
      bit [31:0] deskew_delay;
  } rx_rsfec_dskw_delay_s;
  rx_rsfec_dskw_delay_s           dskw_delay;

`else

  typedef struct packed {
      bit [2:0]  gb_state;
      bit [1:0]  ba_phase;
      bit [4:0]  ba_pos;
      bit [13:0] am_count; // 1 bit less than example TB
      bit [4:0]  local_vl;
      bit [4:0]  remote_vl;
      bit [1:0]  local_pl; // 1 bit less than example TB
  } read_vl_data_s;
  read_vl_data_s [19:0]           vl_data;

   rand bit [3:0] lane_skew[20];
   integer lane_order[20] = '{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19};

   // Table 80–4—Summary of Skew constraints
   // At PCS receive 180 ns ≈ 928 See 82.2.12)
   // 928 UI/66  = 14.06 (per virtual lane)
   constraint lane_skew_c
   {
     foreach(lane_skew[i])
       lane_skew[i] inside {[0:14]};
   }

`endif  

  eth_ptp_config_sequence eth_ptp_config_seq;

  function new(string name = "eth_ptp_base_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 function disable_snps_err();
 `ifdef ENABLE_ETH_VIP
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_flowcontrol_rsvrd_fields_within_paus_frame_not_zeroes.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
 `endif
 endfunction 

//Can be reuse for vl_reload UI adjusment
 task vl_reload();   

        `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
        `uvm_info("eth_ptp_base_sequence", $sformatf("Waiting PTP TX ready speed %0s", p_sequencer.env.spy_if.speed),UVM_NONE)
         //TODO_GDR: Qualify with 400G as temporary workaround
         //if(p_sequencer.env.spy_if.speed != _400G)begin            
            wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1); 
         //end else begin
         //   #10ns;
         //end
        `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)

        `uvm_info("eth_ptp_base_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
        `uvm_info("eth_ptp_base_sequence", $sformatf("Waiting PTP RX ready speed %0s", p_sequencer.env.spy_if.speed),UVM_NONE)
         //TODO_GDR: Qualify with 400G as temporary workaround
         //if(p_sequencer.env.spy_if.speed != _400G)begin
            wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1); 
         //end else begin
         //   #10ns;
         //end
        `uvm_info("eth_ptp_base_sequence", "RX PTP ready\n",UVM_LOW)
 endtask : vl_reload


 virtual task body();

   `uvm_info("body", "started eth_ptp_base_sequence ...", UVM_NONE)

   //`ifdef ENABLE_ETH_VIP
   //  //https://hsdes.intel.com/appstore/article/#/16012059992
   //  //Temporary waive RSFEC AM error
   //  if($test$plusargs("eth2")) begin
   //    `uvm_info("eth_ptp_base_sequence", "Temporary waive RSFEC AM error for eth 2\n",UVM_LOW)
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //  end
   //  if($test$plusargs("other_9")) begin
   //    `uvm_info("eth_ptp_base_sequence", "Temporary waive RSFEC AM error for other_9\n",UVM_LOW)
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //  end
   //  if($test$plusargs("100_12")) begin
   //    `uvm_info("eth_ptp_base_sequence", "Temporary waive RSFEC AM error for 100_12\n",UVM_LOW)
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //  end
   //`endif

  //TODO GDR 
  // p_sequencer.env.apply_reset("hard",0,0,1,11);
  `uvm_do(eth_ptp_config_seq)
  
	//If it is firecode, write to rx_ptp_ap_filter register
	if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == FCFEC)begin
		`uvm_info("body", "Write to rx_ptp_ap_filter ...", UVM_NONE)
		p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_ap_filter_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),8);
	end

   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

   // `ifdef ENABLE_ETH_VIP
   //  //https://hsdes.intel.com/appstore/article/#/16012059992
   //  //Temporary waive RSFEC AM error
   //  if($test$plusargs("eth2")) begin
   //    `uvm_info("eth_ptp_base_sequence", "Temporary waive RSFEC AM error for eth 2\n",UVM_LOW)
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //  end
   //  if($test$plusargs("other_9")) begin
   //    `uvm_info("eth_ptp_base_sequence", "Temporary waive RSFEC AM error for other_9\n",UVM_LOW)
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //  end
   //  if($test$plusargs("100_12")) begin
   //    `uvm_info("eth_ptp_base_sequence", "Temporary waive RSFEC AM error for 100_12\n",UVM_LOW)
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane17.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane18.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_rs_fec_invalid_am_lane19.set_default_fail_effect(svt_err_check_stats::IGNORE);
   //  end
   //`endif

   `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
   `uvm_info("eth_ptp_base_sequence", $sformatf("Waiting PTP TX ready speed %0s", p_sequencer.env.spy_if.speed),UVM_NONE)

   wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1); 

   `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)
   

   `uvm_info("eth_ptp_base_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
   `uvm_info("eth_ptp_base_sequence", $sformatf("Waiting PTP RX ready speed %0s", p_sequencer.env.spy_if.speed),UVM_NONE)

   wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1); 

   `uvm_info("eth_ptp_base_sequence", "RX PTP ready\n",UVM_LOW)

   `ifdef ENABLE_ETH_VIP
   reset_scb(); //for multiple reset scoreboard handling after first initial reset linkup
   `endif
 endtask

//TODO: Remove obselete
 task write_ptp_reg(int tx_extra_latency=100,int asym_latency=100,int rx_extra_latency=100);
//YC   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_extra_latency);
// FIXME-MISSING_REG_IN_GDR//YC   p_sequencer.env.reg_write(`REGISTERS_tx_ptp_asym_latency_OFFSET_REG,asym_latency);
//YC   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_extra_latency);
 endtask

 task send_ptp_frame(ptp_op_e op_type= INS_V1,frame_type f_type = DATA_FRAME,int no_of_frames=1,bit ptp_err=0, bit preamble_pass=0);
   int num_words_local;
   alt_eth_avalonst_ptp_base_sequence avl_tx_pkt;

     //`uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
   //avl_tx_pkt.speed_e = p_sequencer.env.dyn_rcfg_obj_inst.speed;
   //avl_tx_pkt.my_speed = p_sequencer.env.dyn_rcfg_obj_inst.speed;
   //$cast(avl_tx_pkt.my_speed, p_sequencer.env.dyn_rcfg_obj_inst.speed);
   //$display ("speed: %s",  avl_tx_pkt.speed_e );
   //$display ("speed: %s",  avl_tx_pkt.my_speed );
   //$display ("speed_env: %s", p_sequencer.env.dyn_rcfg_obj_inst.speed);
   num_words_local = (p_sequencer.env.spy_if.speed == _10G) ? 1: //[TODO] Need to update with actual values
                        (p_sequencer.env.spy_if.speed == _25G) ? 1:
                        (p_sequencer.env.spy_if.speed == _40G) ? 2:
                        (p_sequencer.env.spy_if.speed == _50G) ? 2:
                        (p_sequencer.env.spy_if.speed == _100G)? 4:
                        (p_sequencer.env.spy_if.speed == _200G)? 8:16;

   if (p_sequencer.env.dyn_rcfg_obj_inst.mode inside {PCSONLY,PCSMAC,MACSEG}) begin
      //if((path == AVL_TX_ETH_VIP) || (path == ETH_VIP_MAC_BOTH)) begin
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSONLY) begin
            `uvm_create_on(avl_tx_pkt, p_sequencer.env.mii_tx_agent.m_sqr);
         end else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin
            `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
         end
         else if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
            `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
         end
      //end 
      avl_tx_pkt.speed_400G = (p_sequencer.env.spy_if.speed == _400G) ? 1 : 0;
      avl_tx_pkt.operation = op_type;
      avl_tx_pkt.eth_frame = f_type;
      avl_tx_pkt.sequence_length = no_of_frames;
      avl_tx_pkt.preamble_pass = preamble_pass;
      avl_tx_pkt.bandwidth=0;
      avl_tx_pkt.num_words_local=num_words_local;
      if((op_type inside {INS_INVALID_CS_EB_V2,INS_INVALID_CS_EB_V1,INS_INVALID_V2,INS_INVALID_V1,INS_INVALID_ETS_V1,INS_INVALID_ETS_V2}) || (ptp_err))
         avl_tx_pkt.ptp_err = 1;
         `uvm_info("send_ptp_frame", $sformatf("sending %0s PTP %0s frame from avalon tx",op_type.name(),f_type.name()),UVM_MEDIUM);
      //Sequencer select
      if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
         avl_tx_pkt.start(p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
         avl_tx_pkt.start(p_sequencer.v_m_sqr);
      end
   end
 endtask // send_ptp_frame
endclass


//For custom invalid 9 bytes packet
class eth_packet_pattern_9B extends eth_packet;
   `uvm_object_utils(eth_packet_pattern_9B)
   static int num_of_frames = 1;// = 4;

   function new(string name = "eth_packet_pattern_9B");
    super.new(name);
   endfunction : new


   function pack_bytes(bit crc_passthrough,bit preamble_passthrough);
      int preamble_ptr;
      int crc_ptr;
      
         if((frame_type == ETH_DATA_FRAME) )
      //this.l_packed_bytes 	     = new[8 + 6 + 3 ];
      this.l_packed_bytes 	     = new[8 + 6 + 1 ];
      this.l_packed_bytes[0] 		 = this.preamble[63:56];
      this.l_packed_bytes[1] 		 = this.preamble[55:48];
      this.l_packed_bytes[2] 		 = this.preamble[47:40];
      this.l_packed_bytes[3] 		 = this.preamble[39:32];
      this.l_packed_bytes[4] 		 = this.preamble[31:24];
      this.l_packed_bytes[5] 		 = this.preamble[23:16];
      this.l_packed_bytes[6] 		 = this.preamble[15:8];
      this.l_packed_bytes[7] 		 = this.preamble[7:0];
      
      this.l_packed_bytes[8] 		 = this.dest_address[47:40];
      this.l_packed_bytes[9] 		 = this.dest_address[39:32];
      this.l_packed_bytes[10] 		 = this.dest_address[31:24];
      this.l_packed_bytes[11] 		 = this.dest_address[23:16];
      this.l_packed_bytes[12] 		 = this.dest_address[15:8];
      this.l_packed_bytes[13] 		 = this.dest_address[7:0];
      
      this.l_packed_bytes[14] 		 = this.src_address[47:40];
     // this.l_packed_bytes[15] 		 = this.src_address[39:32];
     // this.l_packed_bytes[16] 		 = this.src_address[31:24];
      
      if (preamble_passthrough == 1 )
      begin
         preamble_ptr = 0;
      end
      else
      begin
         preamble_ptr = 8;
      end
      
      if(crc_passthrough == 1) begin
         crc_ptr = 4 ;
      end
      else
      begin
         crc_ptr = 0 ;
      end
   
      `ifdef SHORT
         l_packed_bytes1=new[l_packed_bytes.size];	
         l_packed_bytes1 =new[packet_size](l_packed_bytes);
         l_packed_bytes= new[packet_size];	
         l_packed_bytes=l_packed_bytes1; 
         packed_bytes=new[packet_size];	
         foreach(packed_bytes[i])
         packed_bytes[i] = l_packed_bytes[i+preamble_ptr];
      `else
         packed_bytes = new[9];
         foreach(packed_bytes[i])
         packed_bytes[i] = l_packed_bytes[i+preamble_ptr];
      `endif
      
      `uvm_info(get_type_name(),$sformatf("size of packed_bytes:'%d",packed_bytes.size()), UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("size of l_packed_bytes:'%d",l_packed_bytes.size()), UVM_LOW) 
   
   endfunction 



   function seg_pack_bytes(bit crc_passthrough,bit preamble_passthrough,bit covers_preamble); //TODO: remove covers_preamble
   int preamble_ptr;
   bit [7:0] temp_sfc_payload[];
   bit [7:0] temp_pfc_payload[];
   int crc_ptr,p_size;
   int empty_bytes; 
   int num_bytes;//store num bytes exclude payloads 
   
   `uvm_info(get_type_name(),$sformatf("inside seg_pack_bytes crc_passthrough : %0d, preamble_passthrough: %0d",crc_passthrough, preamble_passthrough), UVM_LOW)
      foreach(payload[i])begin
         `uvm_info(get_type_name(),$sformatf("inside seg_pack_bytes payload %0h",payload[i]), UVM_HIGH)
      end
   
   //Rounding up the pcaked_bytes size in 8 bytes 
      if((frame_type == ETH_DATA_FRAME) || (frame_type == ETH_IPV4_FRAME) || 
      (frame_type == ETH_IPV6_FRAME) || (frame_type == ETH_USER_DEFINED_FRAME))
         begin
            //p_size=$ceil((this.payload.size() + 22 + 4 )/8);
            p_size=$ceil((8+6+3 )/8);
         this.l_seg_packed_bytes 	     = new[p_size];
      end
   
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function p_size: %0d -- 1",p_size), UVM_MEDIUM)
   
   if(this.tx_fcs_error_insertion && crc_passthrough==0) begin
      //this.fcs = $urandom();
      this.fcs = ($urandom()%10 !==0) ? $urandom() : 32'h0 ;
      `uvm_info(get_type_name(),$sformatf("fcs error is inserted fcs:32'%h",this.fcs), UVM_LOW)
   end
   
   if((frame_type == ETH_DATA_FRAME) || (frame_type == ETH_JUMBO_DATA_FRAME) || (frame_type == ETH_IPV4_FRAME) || 
      (frame_type == ETH_IPV6_FRAME) || (frame_type == ETH_USER_DEFINED_FRAME)) 
      begin
         `uvm_info(get_type_name(),$sformatf("inside data pkt fcs -- 1: 32'%h",this.fcs), UVM_LOW)      
         //If crc passthrough - 1 then need to consider to add fcs to the data to drive
         if(crc_passthrough == 1)begin
            {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}};
            num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.fcs})/8); 
         end else begin
            {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}};
            num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length})/8); 
         end
         `uvm_info(get_type_name(),$sformatf("inside data pkt fcs -- 2: 32'%h",this.fcs), UVM_LOW)
      end
   
   
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function frame_type %0s",frame_type.name()), UVM_MEDIUM)
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function preamble %0h",preamble), UVM_MEDIUM)
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function dest_address %0h",dest_address), UVM_MEDIUM)
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function src_address %0h",src_address), UVM_MEDIUM)
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function eth_type_or_length %0h",eth_type_or_length), UVM_MEDIUM)
   `uvm_info(get_type_name(),$sformatf("inside data pkt fcs -- 3: 32'%h",this.fcs), UVM_LOW)
      
      foreach(l_seg_packed_bytes[i])begin
         `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function l_seg_packed_bytes[%0d] = %0h -- 1",i,l_seg_packed_bytes[i]), UVM_MEDIUM)
      end    
   
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function num_bytes: %0d -- 1",num_bytes), UVM_MEDIUM)
   
   if (preamble_passthrough == 1 )
   begin
      preamble_ptr = 0;
   end
   else
   begin
      preamble_ptr = 1;
   end
   
   if(crc_passthrough == 1) begin //skip_
      crc_ptr = 0.5 ;
   end
   else
   begin
      crc_ptr = 0 ;
   end
   
      `ifdef SHORT
      $display("SHORT packet_size is %d",packet_size);
      l_seg_packed_bytes=new[packet_size](l_seg_packed_bytes); 
      seg_packed_bytes=new[packet_size];	
   
      foreach(seg_packed_bytes[i])
      seg_packed_bytes[i] = l_seg_packed_bytes[i+preamble_ptr];
      `else
      //p_size=$ceil(preamble_ptr+crc_ptr);
      p_size=preamble_ptr; //TODO:crc_ptr //$floor(preamble_ptr+crc_ptr);
      seg_packed_bytes = new[l_seg_packed_bytes.size() - p_size];
      seg_packed_bytes = new[9];
      
      foreach(seg_packed_bytes[i])
         seg_packed_bytes[i] = l_seg_packed_bytes[i+preamble_ptr];
   
      //Adjust num_bytes based on p_size (include or remove pp)
      num_bytes = num_bytes - (p_size*8);
      `endif
      
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function p_size: %0d -- 2",p_size), UVM_MEDIUM)
      
      //Process unused/empty bytes that was padded with 0 with stream operator previously
      //value must not be >= 8
      if(frame_type == ETH_PFC_FRAME) begin
         empty_bytes = (8*seg_packed_bytes.size) - (num_bytes + ($bits(pfc_pause_quanta)/8)+ temp_pfc_payload.size); //only payload 2 and 3 and has been added previously + 8 of the pfc_pause_quanta size
      end else if(frame_type ==ETH_SFC_FRAME) begin
         empty_bytes = (8*seg_packed_bytes.size) - (num_bytes + temp_sfc_payload.size); 
      end else begin
         empty_bytes = (8*seg_packed_bytes.size) - (num_bytes + payload.size); 
      end
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function empty_bytes: %0d, frame type %s, num_bytes %0d, payload_size %0d",empty_bytes,frame_type.name(), num_bytes, payload.size), UVM_MEDIUM)
   
      //Padded back with X
      for(int i = 0; i< empty_bytes; i++)begin
         seg_packed_bytes[seg_packed_bytes.size() - 1][(i*8) +:8] = 8'hx;
      end 
   
      
   //byte order in seg BFM's each segment is left to right MSB goes first 
   foreach(seg_packed_bytes[i])
      seg_packed_bytes[i] = {<<byte{seg_packed_bytes[i]}};
      
      foreach(seg_packed_bytes[i])begin
         `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function seg_packed_bytes[%0d] = %0h -- 2",i,seg_packed_bytes[i]), UVM_MEDIUM)
      end    
   
   endfunction: seg_pack_bytes
endclass : eth_packet_pattern_9B 

//For custom invalid 9 bytes packet
class ptp_base_size_mini_sequence extends uvm_sequence #(eth_packet_pattern_9B);
 
   bit ptp;
   int fb609905_rule;
   ptp_op_e ptp_op;
   eth_transaction_frame_type fr_type;
   int pl_size;
   int sequence_length;
   int ipg;
   bit bandwidth;
   int num_words_local;
   dyn_rcfg dyn_rcfg_obj_inst; 
  
   `uvm_object_utils(ptp_base_size_mini_sequence)

  function new(string name = "ptp_base_size_mini_sequence");
    super.new(name);
   `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new
  
/** Raise an objection if this is the parent sequence */
   virtual task pre_body();
  uvm_phase phase;
  super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
  if (phase!=null) begin
    phase.raise_objection(this);
  end
 endtask: pre_body
   
   /** Drop an objection if this is the parent sequence */
   virtual task post_body();
  uvm_phase phase;
  super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
  if (phase!=null) begin
    phase.drop_objection(this);
  end
   endtask: post_body

   virtual task body();
   `uvm_info("eth_seq_lib", "running ptp_base_size_mini_sequence\n",UVM_LOW)

   `uvm_create(req)
      repeat(sequence_length) begin 
			req.payload_size_c.constraint_mode(0); 
          if (fb609905_rule == 1)
          begin
            std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};}; // All V1
          end
          else if (fb609905_rule == 2)
          begin
            std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_V2_W_UDP_CS_0,INS_NOOP,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};}; // All V2
          end  
          else if(fb609905_rule == 3)
          begin
						            std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB, INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,INS_2STEP};}; 
          end 
          else
            begin
            std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};}; // No V1 EB
            end 
        if(fb609905_rule != 3)   
          std::randomize(ptp);
        if(bandwidth)
        `uvm_rand_send_with(req,{is_ptp_seq==ptp;frame_type == fr_type; payload.size == pl_size; m_ptp_op == ptp_op; interpacket_gap==ipg; num_words==num_words_local;})
        else
        `uvm_rand_send_with(req,{is_ptp_seq==ptp;frame_type == fr_type; payload.size == pl_size; m_ptp_op == ptp_op; interpacket_gap==ipg; num_words==num_words_local;})
      end  
 
  endtask

endclass : ptp_base_size_mini_sequence


`include "ptp_sanity_sequence.sv"
`include "ptp_ipg_coverage_sequence.sv"

`include "ptp_v1_accuracy_sequence.sv"

`include "ptp_v2_accuracy_sequence.sv"

`include "ptp_2step_accuracy_sequence.sv"

`include "ptp_reset_2step_accuracy_sequence.sv"

`include "ptp_v1_ts_ins_sequence.sv"

`include "ptp_v1_ts_ins_w_asym_lat_sequence.sv"

`include "ptp_v1_ts_ins_udp_cs_sequence.sv"

`include "ptp_v1_ts_ins_udp_cs_w_asym_lat_sequence.sv"

`include "ptp_v1_ts_ins_add_eb_sequence.sv"

`include "ptp_v1_ts_ins_add_eb_w_asym_lat_sequence.sv"

`include "ptp_v2_ts_ins_sequence.sv"

`include "ptp_v2_ts_ins_w_asym_lat_sequence.sv"

`include "ptp_v2_ts_ins_udp_cs_sequence.sv"

`include "ptp_v2_ts_ins_udp_cs_w_asym_lat_sequence.sv"

`include "ptp_v2_ts_ins_add_eb_sequence.sv"

`include "ptp_v2_ts_ins_add_eb_w_asym_lat_sequence.sv"

`include "ptp_cf_ts_ins_sequence.sv"

`include "ptp_cf_ts_ingress_coverage_sequence.sv"

`include "ptp_cf_ts_rollover_sequence.sv"

`include "ptp_cf_ts_ins_w_asym_lat_sequence.sv"

`include "ptp_sync_latency_ctr_sequence.sv"

`include "ptp_cf_ts_ins_udp_cs_sequence.sv"

`include "ptp_cf_ts_ins_udp_cs_w_asym_lat_sequence.sv"

`include "ptp_cf_ts_ins_add_eb_sequence.sv"

`include "ptp_cf_ts_ins_add_eb_w_asym_lat_sequence.sv"

`include "ptp_cf_ts_ins_p2p_w_asym_lat_sequence.sv"

`include "ptp_cf_p2p_ins_sequence.sv"

`include "ptp_cf_p2p_zcsum_ins_sequence.sv"

`include "ptp_v1_mix_ts_ins_sequence.sv"

`include "ptp_v2_mix_ts_ins_sequence.sv"

`include "ptp_cf_mix_ins_sequence.sv"

`include "ptp_cf_p2p_zcsum_ins_w_asym_lat_sequence.sv"

`include "ptp_cf_p2p_ins_add_eb_sequence.sv"

`include "ptp_cf_p2p_ins_add_eb_w_asym_lat_sequence.sv" 

`include "ptp_2step_ts_sequence.sv"

//RAMI-FIXME why only noop/2step???
`include "ptp_mix_sequence.sv"

`include "ptp_base_constraint_sequence.sv"

`include "ptp_base_over_under_flow_sequence.sv"

`include "ptp_cf_underflow_overflow_sequence.sv"

`include "ptp_base_size_sequence.sv"

`include "ptp_frame_size_sequence.sv"

`include "ptp_frames_underflow.sv"

`include "ptp_min_frame_sequence.sv"
`include "ptp_invalid_min_frame_sequence.sv"

//`include "ptp_sfc_sequence.sv" //obselete

`include "ptp_preamble_pass_sequence.sv"

`include "ptp_bandwidth_sequence.sv"

`include "ptp_stress_sequence.sv"

`include "ptp_rx_mcast_ucast_frames_sequence.sv"

`include "ptp_rx_ipv4_ipv6_frames_sequence.sv"

`include "ptp_rx_vlan_frames_sequence.sv"

`include "ptp_loopback_accuracy_sequence.sv"

`include "ptp_reset_sequence.sv"

`include "ptp_cf_asym_ins_sequence.sv"

`include "ptp_cf_asym_zcsum_ins_sequence.sv"

`include "ptp_cf_asym_ins_add_eb_sequence.sv"

`include "ptp_cf_24bit_ts_rollover_sequence.sv"

`include "ptp_stats_registers_sequence.sv"
//`include "ptp_wo_registers_sequence.sv"
`include "ptp_ro_registers_sequence.sv"
`include "ptp_register_access_sequence_1.sv"
`include "ptp_register_access_sequence_2.sv"
`include "ptp_register_access_sequence_3.sv"
`include "ptp_register_access_sequence_4.sv"
`include "ptp_asm_p2p_read_write_reg_sequence.sv"

`include "ptp_debug_logic_reg_sequence.sv"

`include "ptp_tx_err_mix_sequence.sv"


`include "ptp_length_err_mix_sequence.sv"


`include "ptp_err_mix_invalid_sequence.sv"

`include "ptp_tx_flow_control_sequence.sv"

`include "ptp_tx_fifo_stress_sequence.sv"

`include "ptp_err_mix_offset_sequence.sv"

`include "ptp_rx_flow_control_sequence.sv"

`include "ptp_tod_valid_down_sequence.sv"

`ifdef ENABLE_ETH_VIP
//`include "ptp_vl_reload_sequence.sv" //Unused for now

`include "ptp_link_fault_sequence.sv"

`include "ptp_remote_fault_sequence.sv"

`include "ptp_force_rf_fault_sequence.sv"

`include "ptp_err_fcs_injection_sequence.sv"

`include "ptp_err_malformed_sequence.sv"

`include "ptp_2step_cable_pull_accuracy_sequence.sv"

`include "ptp_2step_cable_pull_accuracy_userflow_sequence.sv"

`include "ptp_rx_fifo_stress_sequence.sv"

`include "eth_ptp_hard_reset_recovery_sequence.sv"


`include "ptp_b2b_reset_2step_accuracy_sequence.sv"

`include "eth_ptp_soft_reset_recovery_sequence.sv"

`include "ptp_dut_recv_pos_ppm_sequence.sv"
`include "ptp_dut_recv_neg_ppm_sequence.sv"
`include "ptp_dut_tx_pos_ppm_sequence.sv"
`include "ptp_dut_tx_neg_ppm_sequence.sv"
`include "ptp_2step_accuracy_100g_skew_reorder_sequence.sv"

`endif//ENABLE_ETH_VIP
