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


class ptp_bandwidth_sequence extends eth_ptp_base_sequence;
  `uvm_object_utils(ptp_bandwidth_sequence)
   ptp_base_size_sequence eth_seq;
 eth_transaction_frame_type f_type;
 eth_ptp_config_sequence eth_ptp_config_seq;
int size;
int mix_rule;

  function new(string name = "ptp_bandwidth_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   `uvm_info("body", "started ptp_bandwidth_sequence ...", UVM_NONE)
   p_sequencer.env.apply_reset("hard",0,0,1,11);
   
   `uvm_do(eth_ptp_config_seq)   
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

        `uvm_info("ptp_bandwidth_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
        `uvm_info("ptp_bandwidth_sequence", "RX PTP ready\n",UVM_LOW)
    
       std::randomize(mix_rule) with {mix_rule inside {1,2};};
     //Actual PTP traffic after PTP ready
     for(size=60; size < 100 ; size++) begin
       `uvm_create_on(eth_seq, p_sequencer.tx_seqr);
       std::randomize(f_type) with {f_type inside {ETH_DATA_FRAME};};
       
       eth_seq.fb609905_rule = mix_rule;
       eth_seq.pl_size = size;
       eth_seq.fr_type = f_type;
       eth_seq.sequence_length = 10000;
       eth_seq.ipg = 0;
       eth_seq.bandwidth = 1;
       eth_seq.start(p_sequencer.tx_seqr);
     end
endtask
endclass : ptp_bandwidth_sequence
