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



///*class ptp_sfc_sequence extends eth_ptp_base_sequence;
//  ptp_op_e ptp_op;
//  frame_type f_type;
//  `uvm_object_utils(ptp_sfc_sequence)
// 
//  bit      ready_drop;//should pause enable or disable tx transmission,will cause ready to be dropped,tx of en tx pause q no
//  bit[7:0] rx_pfc_en;//rx_pause_en 
//  bit      rx_fc_fwd;//rx frame fwd
//  bit[47:0] rx_da; 
//  bit[1:0] rx_fc_en;//en dis sfc pfc on rx path 
//  uvm_event_pool event_pool;
//  uvm_event wait_fc_reg_write;
//
//function new(string name = "seq_0");
//    super.new(name);
//   `ifdef UVM_POST_VERSION_1_1
//       set_automatic_phase_objection(1);
//   `endif
//    event_pool = new();
//    event_pool = event_pool.get_global_pool();
//    wait_fc_reg_write = event_pool.get("fc_reg_write");
// endfunction:new
//
//  virtual task body();
//   rx_da={$urandom,$urandom}; 
//   p_sequencer.env.sb_mac_tx_vip_rx.fc_flag_en = 1;
//
//   p_sequencer.env.apply_reset("hard",0,0,1,11);
//
//  `uvm_info("eth_seq_lib", "running ptp_sfc_sequence\n",UVM_LOW)
//    `ifdef ANLT
//      p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//    `endif
//   wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==1);
//    p_sequencer.env.flow_agent.flow_mon.flow_control=1;
//    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_xof_en_tx_pause_qnumber_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1); 
//    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_enable_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),8'h01); 
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1); 
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[31:0]); //same da for loopback mode only
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_daddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_da[47:32]); 
//   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),8'h03);
//
//`uvm_info("fc_fb_seq", "=========================FLOW CONTROL INFO FOR THIS SIMULATION===================\n",UVM_LOW)
//    `uvm_info("fc_fb_seq", "=========================RX PATH===================\n",UVM_LOW)
//    `uvm_info("fc_fb_seq",$sformatf("Ports Enabled for output:%h...\n",rx_pfc_en),UVM_LOW)
//    if(rx_fc_fwd) `uvm_info("fc_fb_seq","Control frames will be forwarded on rx user interface...\n",UVM_LOW)
//    else `uvm_info("fc_fb_seq","Control frames will not be forwarded on rx user interface...\n",UVM_LOW)
//    `uvm_info("fc_fb_seq",$sformatf("RX DEST ADDR in VIP mode:%h...\n",rx_da),UVM_LOW)
//    if(rx_fc_en[1]) `uvm_info("fc_fb_seq","PFC frames will be passed by DUT...\n",UVM_LOW)
//    if(rx_fc_en[0]) `uvm_info("fc_fb_seq","SFC frames will be passed by DUT...\n",UVM_LOW)
//  
//   `ifndef ANLT
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
// `endif
//
//   //loading VL offset  (copied form the ptp_base_seq)
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
//        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{1'b0, tx_ptp_extra_latency[8+:31]});
//        `uvm_info("eth_ptp_base_sequence", "Configure RX extra latency\n",UVM_LOW)
//        //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hB06, {1'b1, rx_ptp_extra_latency[8+:31]});
//        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{1'b1, rx_ptp_extra_latency[8+:31]});
//   end     
//
//        `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
//        wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
//        `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)
//
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
//        do begin
//          //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10, read_data, 1);
////YC          p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG,read_data, 1);
//        end
//        while(read_data[31] !== 1'b1);
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
//
//        `uvm_info("ptp_sfc_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
//        wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
//        `uvm_info("ptp_sfc_sequence", "RX PTP ready\n",UVM_LOW)
//
//   wait_fc_reg_write.trigger();
//      `uvm_info("fc_fb_seq", "All fc registers are written, triggered event..\n",UVM_LOW)
//      `uvm_info("fc_fb_seq", "This test will run in Pause Mode...\n",UVM_LOW)
//      `ifdef ENABLE_ETH_VIP
//      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
//      p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
//      `endif
//   fork
//     begin
//      repeat(200) begin
//        std::randomize(ptp_op) with {ptp_op inside {[INS_NOOP:INS_2STEP]}; ptp_op != INS_INVALID_V1 ; ptp_op != INS_INVALID_V2;ptp_op != INS_INVALID_CS_EB_V1; ptp_op != INS_INVALID_CS_EB_V2;ptp_op != INS_INVALID_ETS_V1;ptp_op != INS_INVALID_ETS_V2;};
//        std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
//        randcase
//        3:send_ptp_frame(ptp_op,f_type,1);  
//        1:send_eth_frame(CONTROL_FRAME,AVL_TX_ETH_VIP,1);
//        endcase
//      end
//    end
//    begin
//          repeat(5) begin
//           send_eth_frame(SFC_XOFF_FRAME,ETH_VIP_AVL_RX,1);  
//          #200ns send_eth_frame(SFC_XON_FRAME,ETH_VIP_AVL_RX,1);  
//          end
//    end 
//    join
// endtask
//endclass */
