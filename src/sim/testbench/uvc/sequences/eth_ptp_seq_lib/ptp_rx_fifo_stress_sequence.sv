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


class alt_eth_vip_base_small_sequence extends svt_ethernet_transaction_base_sequence; 

   int unsigned sequence_length = 1;
   svt_ethernet_transaction_exception_list exception_list;
   bit [15:0] byte_count;
   
   /** UVM object utility macro */
   `uvm_object_utils(alt_eth_vip_base_small_sequence)
     
     /** Class constructor */
     function new (string name = "alt_eth_vip_base_small_sequence",int sequence_length=1);
      	super.new(name);
	this.sequence_length = sequence_length;
     endfunction : new

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
      bit status;
      
      `svt_xvm_note("body", "Entered ...");
      super.body();
      
      `svt_xvm_create (req) 
          req.reasonable_byte_count.constraint_mode(0);
	repeat(sequence_length) begin
	   `svt_xvm_rand_send_with(req, {
					 req.byte_count          == byte_count; 
					 req.mac_inter_frame_gap == 5;
					 req.command_type        == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME;
					 req.exception_list == exception_list;
					 })
	     end
      `svt_xvm_note("body" ," Exited ...");
    
   endtask: body

task send_packet_13(int packet_size =17);

   `uvm_info("body", "endtred to transmit the packet ...", UVM_MEDIUM)
  $display("entered to transmit the packet"); 
      //Short packets
	 `svt_xvm_create (req) 
          req.user_packet_type = svt_ethernet_enum_pkg::DATA_FRAME;
          req.disable_mac_pad = 1'b1;
          req.enable_mac_frame_user_fcs=1'b1;
          req.reasonable_byte_count.constraint_mode(0);
          req.reasonable_mac_inter_frame_gap.constraint_mode(0);
          req.reasonable_command_type.constraint_mode(0);
          req.user_no_of_bytes = packet_size;
	        req.user_pkt_data = new[packet_size];
          for(int j=0; j < packet_size; j++) begin
             if(j==0) begin
               req.user_pkt_data[j]=8'hFB;
             end
             if(j>=1 && j<7) begin
               req.user_pkt_data[j]=8'h55;
             end
             if(j==7) begin
               req.user_pkt_data[j]=8'hD5;
             end
             if(j>7) begin
               req.user_pkt_data[j]=$urandom();
             end
          end
	 `svt_xvm_rand_send_with(req,
                            { 
           req.byte_count          == packet_size;
	         req.mac_inter_frame_gap == 'h5;
	         req.command_type        == svt_ethernet_enum_pkg::ETH_USER_FRAME_WITH_PREAMBLE_SFD_HEADER;}) ;

$display("packet transmitting is done");
   `uvm_info("body", "packet transmitting is done ...", UVM_MEDIUM)
endtask
   `include "alt_eth_error_vip_base_sequence_tasks.svh"
 
endclass : alt_eth_vip_base_small_sequence

class ptp_rx_fifo_stress_sequence extends eth_ptp_base_sequence;
  `uvm_object_utils(ptp_rx_fifo_stress_sequence)

   `ifdef ENABLE_ETH_VIP
   alt_eth_vip_base_small_sequence err_seq;
   svt_ethernet_transaction_exception_list exception_list;   
   svt_ethernet_transaction_exception exception;
   `endif
   ptp_base_size_sequence eth_seq;
  eth_ptp_config_sequence eth_ptp_config_seq;
 eth_transaction_frame_type f_type;
int size;
int mix_rule;

  function new(string name = "ptp_rx_fifo_stress_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   `uvm_info("body", "started ptp_rx_fifo_stress_sequence ...", UVM_NONE)
   `uvm_do(eth_ptp_config_seq)
  // p_sequencer.env.apply_reset("hard",0,0,1,11); //TODO GDR
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   dis_stats_chk=1;

//    //loading VL offset  (copied form the ptp_base_seq)
//   if(rand_latency) begin
//     tx_extra_latency[31] = $urandom();
//     tx_extra_latency[30:16] = $urandom_range(0,20);
//     tx_extra_latency[15:0] = $urandom;
//
//     rx_extra_latency[31] = $urandom();
//     rx_extra_latency[30:16] = $urandom_range(0,20);
//     rx_extra_latency[15:0] = $urandom;
//
//     asym_latency[31] = $urandom();
//     asym_latency[30:16] = $urandom_range(0,20);
//     asym_latency[15:0] = $urandom;
//
//     write_ptp_reg(tx_extra_latency,asym_latency,rx_extra_latency);
//
//   end else begin
//
//        ui_value     = 32'h00_09_EE_01;
//        //tx_pma_delay = 7'd107;
//        tx_pma_delay = 7'd33; // To match simulation check with Jayavel/Sreedhar why it is different than SSDV
//        rx_pma_delay = 7'd95;
//
//        tx_ptp_extra_latency = tx_pma_delay * ui_value;
//        rx_ptp_extra_latency = rx_pma_delay * ui_value;
//
//        `uvm_info("eth_ptp_base_sequence", "\Configure TX extra latencyn",UVM_LOW)
//        //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hA0A, {1'b0, tx_ptp_extra_latency[8+:31]});
////YC        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{1'b0, tx_ptp_extra_latency[8+:31]});
//        `uvm_info("eth_ptp_base_sequence", "Configure RX extra latency\n",UVM_LOW)
//        //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hB06, {1'b1, rx_ptp_extra_latency[8+:31]});
////YC        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{1'b1, rx_ptp_extra_latency[8+:31]});
//   end     

        `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
        `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)

//`ifdef RSFEC
//
//        // Check if RX RSFEC is fully aligned
//        `uvm_info("eth_ptp_base_sequence", "Waiting for RSFEC alignment locked\n",UVM_LOW)
//        do begin
//            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h150, read_data, 1);
//            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_lane_rx_stat"), read_data, 1);
//        end
//        while(read_data[1] === 1'b1);
//
//        // Read unprocessed VL offset data and calculate
//        for(ln = 0; ln < 4; ln++) begin
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading rsfec_ln_mapping_rx_%0d", ln),UVM_NONE)
//            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1A0 + (ln*4), read_data, 1);
//            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_ln_mapping_rx") + (ln*4), read_data, 1);
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("rsfec_ln_mapping_rx_%0d = 32'h%0h",ln,read_data),UVM_NONE)
//            if(read_data == 32'h0) phy_ln0_map = ln;
//
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading rsfec_ln_skew_rx_%0d", ln),UVM_NONE)
//            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1B0 + (ln*4), read_data, 1);
//            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_ln_skew_rx") + (ln*4), read_data, 1);
//            skew_ln[ln] = read_data;
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("rsfec_ln_skew_rx_%0d = 32'h%0h",ln,skew_ln[ln]),UVM_NONE)
//
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading rsfec_cw_pos_rx_%0d", ln),UVM_NONE)
//            cw_pos_rx[ln] = 32'h0;
//            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1C0 + (ln*4), read_data, 1);
//            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_cw_pos_rx") + (ln*4), read_data, 1);
//            cw_pos_rx[ln][7:0] = read_data[7:0];
//            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1C0 + (ln*4) + 1, read_data, 1);
//            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_cw_pos_rx") + (ln*4) + 1, read_data, 1);
//            cw_pos_rx[ln][12:8] = read_data[4:0];
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("rsfec_cw_pos_rx_%0d = 32'h%0h",ln,cw_pos_rx[ln]),UVM_NONE)
//        end
//
//        min_val = skew_ln.min(); 
//        min_skew = min_val.pop_front();
//        `uvm_info("eth_ptp_base_vl_offset", $sformatf("min skew value = 32'h%0h",min_skew),UVM_NONE)
//
//        lane_skew_adjust = skew_ln[phy_ln0_map] - min_skew + (skew_ln.sum()/4);
//        `uvm_info("eth_ptp_base_vl_offset", $sformatf("lane_skew_adjust = 32'h%0h",lane_skew_adjust),UVM_NONE)
//
//        //Tlat_final = (lane_skew_adjust*80 + cw_pos_rx[phy_ln0_map][4:0]) * 0.038788;
//        Tlat_final = (lane_skew_adjust*80 + cw_pos_rx[phy_ln0_map][4:0]);
//        `uvm_info("eth_ptp_base_vl_offset", $sformatf("Tlat_final = 32'h%0h",Tlat_final),UVM_NONE)
//
//        dskw_delay.selected_pl = phy_ln0_map;
//        dskw_delay.deskew_delay = Tlat_final;
//
//        `uvm_info("eth_ptp_base_vl_offset", "Generate VL offset data\n",UVM_LOW)
//        generate_vl_data_fec_mode(dskw_delay);
//
//`else
//        // Check if VL offset data is ready
//        `uvm_info("eth_ptp_base_vl_offset", "Waiting for VL offset data ready\n",UVM_LOW)
////YC        do begin
//          //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10, read_data, 1);
////YC          p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG,read_data, 1);
////YC        end
////YC        while(read_data[31] !== 1'b1);
//
//        // Read unprocessed VL offset data and calculate
//        for(vl = 0; vl < 20; vl++) begin
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading VL offset data for VL %0d",vl),UVM_NONE)
//            //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10 + (vl*2), read_data, 1);
////YC            p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG + (vl*2),read_data, 1);
//            {vl_data[vl].am_count,
//             vl_data[vl].ba_pos,
//             vl_data[vl].ba_phase,
//             vl_data[vl].gb_state} = read_data[23:0];
//
//            //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10 + (vl*2)+1, read_data, 1);
////YC            p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG + (vl*2)+1,read_data, 1);
//            {vl_data[vl].local_pl,
//             vl_data[vl].remote_vl,
//             vl_data[vl].local_vl} = read_data[11:0];
//
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Calculating VL offset data for VL %0d",vl),UVM_NONE)
//            calculate_vl_offset(vl_data[vl]);
//        end
//
//`endif
//       
//        // Configure calculated VL offset data
//        for(vl = 0; vl < 20; vl++) begin
//            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Writing VL offset data for VL %0d", vl),UVM_NONE)
//            //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hC40 + (vl*2), {25'h0, vl_offset_load_arr[vl][6:0]});
//            //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hC40 + (vl*2)+1, vl_offset_load_arr[vl][38:7]);
////YC            p_sequencer.env.reg_write(`REGISTERS_ptp_vl0_offset_cfg_0_OFFSET_REG + (vl*2), {25'h0, vl_offset_load_arr[vl][6:0]});
////YC            p_sequencer.env.reg_write(`REGISTERS_ptp_vl0_offset_cfg_0_OFFSET_REG + (vl*2)+1, vl_offset_load_arr[vl][38:7]);
//        end

        `uvm_info("ptp_rx_fifo_stress_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
        `uvm_info("ptp_rx_fifo_stress_sequence", "RX PTP ready\n",UVM_LOW)
    
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
        //Actual PTP traffic after PTP ready
        `uvm_create_on(eth_seq, p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        //Actual PTP traffic after PTP ready
        `uvm_create_on(eth_seq, p_sequencer.v_m_sqr);
      end
////==========================================
`ifdef ENABLE_ETH_VIP
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_multicast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_broadcast_source_addr_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
			p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);

      `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
      exception = new();
      ///** Create the exception list */
      exception_list = new("exception_list", exception);
      `endif
     std::randomize(f_type) with {f_type inside {ETH_VLAN_FRAME ,ETH_STACKED_VLAN_FRAME ,ETH_DATA_FRAME};};
     std::randomize(f_type)with {f_type dist {ETH_VLAN_FRAME := 30 ,ETH_STACKED_VLAN_FRAME := 10 ,ETH_DATA_FRAME :=60};};
    // std::randomize(mix_rule) with {mix_rule inside {1,2,3};};
     std::randomize(mix_rule) with {mix_rule ==3 ;}; //1 is all v1 frames, 3 without v1 is 2

     if (f_type == ETH_VLAN_FRAME)
     size =42;
     else if (f_type == ETH_STACKED_VLAN_FRAME)
     size =38;
     else
     size =46;
     //$display ("\n\n\n\n+++++++++++++++++++++++++++++++++++++TYPE=%s++++++++++++++++++", f_type);
     //$display("\n\n\n\nMIX_RULE=%d\n\n\n\n\n",mix_rule);
     eth_seq.fb609905_rule = mix_rule;
     eth_seq.pl_size = size;
     if(mix_rule == 3)
       eth_seq.ptp = 1'b1;
     eth_seq.fr_type = f_type;
     eth_seq.sequence_length = 100;

     eth_seq.num_words_local = (p_sequencer.env.spy_if.speed == _10G) ? 1: //[TODO] Need to update with actual values
                        (p_sequencer.env.spy_if.speed == _25G) ? 1:
                        (p_sequencer.env.spy_if.speed == _40G) ? 2:
                        (p_sequencer.env.spy_if.speed == _50G) ? 2:
                        (p_sequencer.env.spy_if.speed == _100G)? 4:
                        (p_sequencer.env.spy_if.speed == _200G)? 8:16;



    `ifdef ENABLE_ETH_VIP
		p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_INTER_FRAME_GAP, 1 );
#30ns;
           p_sequencer.env.spy_if.its_check_disable = 1;
            repeat(300) begin
            $display("repeat loop start executing");
            //      err_seq.send_error_frame(exception_list,num_of_frames,.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.ifg(1),.en_short_packet(en_short_packet),.one_exception(1'b1));i
            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 1; //disable scb
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=0;
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=0;
            uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable),UVM_LOW);
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
            `endif

            p_sequencer.env.m_ptp_tx_ref_model.bypass_queue = 1; //disable ptp_tx_ref_model
            p_sequencer.env.m_ptp_tx_ref_model.flush_frames();
            p_sequencer.env.m_ptp_tx_ref_model.reset_model();
            err_seq.send_packet_13();
           // #20ns;
            end
#10us;
            p_sequencer.env.m_ptp_tx_ref_model.bypass_queue = 0; //enable ptp_tx_ref_model
            p_sequencer.env.spy_if.its_check_disable = 0;

            p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0; //enable scb
            p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
            p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable=1;  
            p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable=1;
            //Enable avst monitor assertions after getting lock
            `ifdef ENABLE_ETH_VIP
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(1);
            p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(1);
            `endif
            send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,50); //sending packets from vip to ensure correct working of scb and ref_model
     `endif

#100ns;			
      if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
         eth_seq.start(p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
         eth_seq.start(p_sequencer.v_m_sqr);
      end
endtask
endclass : ptp_rx_fifo_stress_sequence
