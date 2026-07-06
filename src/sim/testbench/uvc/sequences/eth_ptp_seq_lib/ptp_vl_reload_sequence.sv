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


class ptp_vl_reload_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit link_down;
  int timeout_cntr;
  uvm_reg_data_t read_data;
  bit mix_rule;

  `uvm_object_utils(ptp_vl_reload_sequence)
  function new(string name = "ptp_vl_reload_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `uvm_info("eth_seq_lib", "running ptp_vl_reload_sequence\n",UVM_LOW)
//YC   p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   read_data[0]=1;
   read_data[1]=$urandom_range(0,1);
//YC   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
   mix_rule = $urandom();

   fork
    begin
      repeat(100) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
        std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
        randcase
        1:send_ptp_frame(ptp_op,f_type,1);  
        1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
        endcase
      end
    end
    begin
      repeat(100) begin
       randcase
       1:send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);
       1:send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
       endcase
      end
    end
   join
#10us;
// FIXME-MISSING_REG_IN_GDR   //p_sequencer.env.reg_read(`REGISTERS_ptp_vl_reload_int_OFFSET_REG,read_data,1);
   //if(read_data[0]==1) `uvm_error("ptp_vl_reload_sequence", $sformatf("vl_reload is 1 when link is up"));
   //disabling VIP checkers
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

`ifndef RSFEC

   //insert invalid sync hdrs 
   for(int i=0; i<65; i++) begin
      @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_66b_block);
      //insert_invalid_sync_hdr(m_seq_var);
      p_sequencer.env.ts_tasks_if.do_drv_err(`ETH_10G_MULTILANE_REPLACE_SYNC_HEADER_LANE0, 0);
   end

   fork begin //to terminate threads when link is down 
     fork 
       begin
         //check to see if lock lost
         wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready == 1'b0);
         link_down=1;
         //Check that blk lock, am_lock are deasserted
         if ( (p_sequencer.env.spy_if.rx_block_lock == 1'b0) && (p_sequencer.env.spy_if.rx_am_lock== 1'b0) ) begin
           `uvm_info(get_type_name(), $sformatf("block_lock and am_lock low as expected "), UVM_LOW)
         end
         else begin
           `uvm_fatal(get_type_name(), $sformatf("block_lock :%d and am_lock :%d signals expected to go low ", p_sequencer.env.spy_if.block_lock, p_sequencer.env.spy_if.rx_am_lock))
         end
       end
       begin
         //timeout check
         //while(am_lock_lost == 0) begin
         while(link_down== 0) begin
           @(p_sequencer.env.ts_tasks_if.event_10g_multilane_insert_align_block);
           `uvm_info(get_type_name(), $sformatf("incrementing timeout cntr :%d", timeout_cntr), UVM_LOW)
           timeout_cntr++;
           if(timeout_cntr == 60) begin
             break;
           end
         end
       end
     join_any
     disable fork;
   end
   join


   `uvm_info(get_type_name(), $sformatf("after first fork exit  timeout_cntr:%d", timeout_cntr), UVM_LOW)
   if(link_down == 1) begin
     `uvm_info(get_type_name(), $sformatf("LINK DOWN AS EXPECTED link_down:%d", link_down), UVM_LOW)
   end
   else if((timeout_cntr >= 50) && (link_down == 0)) begin
    `uvm_error(get_type_name(), $sformatf("TIMEOUT WAITING FOR LINK DOWN after invalid sync hdrs inserted lock_lost :%d, timeout_cntr :%d", link_down, timeout_cntr))
   end
`else
   fork : am_lock_loss
     begin
       p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_KR4_FEC_ENABLE_SVT_ERROR_INJECTION,1'b0);
       while(1)
       begin
          //Insert User Defined AM in 0 AM Transode at 1th Location such that only BIP is corrupted.
          p_sequencer.env.ts_tasks_if.do_drv_err(`ETH_ERR_KR4_FEC_USER_DEFINED_AM_AT_USER_LOCTION_IN_TRANSCODE,{64'h00_21_68_c1_00_de_97_3e,2'b11,5'b11111});
          @(p_sequencer.env.ts_tasks_if.event_kr4_fec_align4_insert );
       end
     end
     begin
       wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready == 1'b0);
       disable am_lock_loss;
     end
     begin
     repeat(120)
     @(p_sequencer.env.ts_tasks_if.event_kr4_fec_align4_insert );
     `uvm_fatal(get_type_name(), $sformatf("block_lock :%d and am_lock :%d signals expected to go low ", p_sequencer.env.spy_if.block_lock, p_sequencer.env.spy_if.rx_am_lock))
     end
   join
`endif
// FIXME-MISSING_REG_IN_GDR//YC   p_sequencer.env.reg_read(`REGISTERS_ptp_vl_reload_int_OFFSET_REG,read_data);
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
// FIXME-MISSING_REG_IN_GDR//YC   p_sequencer.env.reg_write(`REGISTERS_ptp_vl_reload_int_OFFSET_REG,0);
// FIXME-MISSING_REG_IN_GDR//YC   p_sequencer.env.reg_read(`REGISTERS_ptp_vl_reload_int_OFFSET_REG,read_data);

//Reloading VL offset  (copied form the ptp_base_seq)
   if(rand_latency) begin
     tx_extra_latency[31] = $urandom();
     tx_extra_latency[30:16] = $urandom_range(0,20);
     tx_extra_latency[15:0] = $urandom;

     rx_extra_latency[31] = $urandom();
     rx_extra_latency[30:16] = $urandom_range(0,20);
     rx_extra_latency[15:0] = $urandom;

     asym_latency[31] = $urandom();
     asym_latency[30:16] = $urandom_range(0,20);
     asym_latency[15:0] = $urandom;

     write_ptp_reg(tx_extra_latency,asym_latency,rx_extra_latency);

   end else begin

        ui_value     = 32'h00_09_EE_01;
        //tx_pma_delay = 7'd107;
        tx_pma_delay = 7'd33; // To match simulation check with Jayavel/Sreedhar why it is different than SSDV
        rx_pma_delay = 7'd95;

        tx_ptp_extra_latency = tx_pma_delay * ui_value;
        rx_ptp_extra_latency = rx_pma_delay * ui_value;

        `uvm_info("ptp_vl_reload_sequence", "\Configure TX extra latencyn",UVM_LOW)
        //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hA0A, {1'b0, tx_ptp_extra_latency[8+:31]});
//YC        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_tx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{1'b0, tx_ptp_extra_latency[8+:31]});
        `uvm_info("ptp_vl_reload_sequence", "Configure RX extra latency\n",UVM_LOW)
        //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hB06, {1'b1, rx_ptp_extra_latency[8+:31]});
//YC        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_ptp_extra_latency_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),{1'b1, rx_ptp_extra_latency[8+:31]});
   end     

        `uvm_info("ptp_vl_reload_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
        `uvm_info("ptp_vl_reload_sequence", "TX PTP ready\n",UVM_LOW)

`ifdef RSFEC

        // Check if RX RSFEC is fully aligned
        `uvm_info("ptp_vl_reload_sequence", "Waiting for RSFEC alignment locked\n",UVM_LOW)
        do begin
            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h150, read_data, 1);
            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_lane_rx_stat"), read_data, 1);
        end
        while(read_data[1] === 1'b1);

        // Read unprocessed VL offset data and calculate
        for(ln = 0; ln < 4; ln++) begin
            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading rsfec_ln_mapping_rx_%0d", ln),UVM_NONE)
            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1A0 + (ln*4), read_data, 1);
            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_ln_mapping_rx") + (ln*4), read_data, 1);
            `uvm_info("eth_ptp_base_vl_offset", $sformatf("rsfec_ln_mapping_rx_%0d = 32'h%0h",ln,read_data),UVM_NONE)
            if(read_data == 32'h0) phy_ln0_map = ln;

            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading rsfec_ln_skew_rx_%0d", ln),UVM_NONE)
            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1B0 + (ln*4), read_data, 1);
            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_ln_skew_rx") + (ln*4), read_data, 1);
            skew_ln[ln] = read_data;
            `uvm_info("eth_ptp_base_vl_offset", $sformatf("rsfec_ln_skew_rx_%0d = 32'h%0h",ln,skew_ln[ln]),UVM_NONE)

            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading rsfec_cw_pos_rx_%0d", ln),UVM_NONE)
            cw_pos_rx[ln] = 32'h0;
            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1C0 + (ln*4), read_data, 1);
            p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_cw_pos_rx") + (ln*4), read_data, 1);
            cw_pos_rx[ln][12:0] = read_data[12:0];
            
            /////
            // RAMI - No such register, all 13 bits are present in RSFEC_CFGCSR_CSR_rsfec_cw_pos_rx_0_OFFSET_REG itself // 
            /////
            //p_sequencer.env.reg_read(FEC_ADDR_OFFSET + 19'h1C0 + (ln*4) + 1, read_data, 1);
            //p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stat_e25g_stat_s0_rsfec_cw_pos_rx") + (ln*4) + 1, read_data, 1);
            //cw_pos_rx[ln][12:8] = read_data[4:0];
            `uvm_info("eth_ptp_base_vl_offset", $sformatf("rsfec_cw_pos_rx_%0d = 32'h%0h",ln,cw_pos_rx[ln]),UVM_NONE)
        end

        min_val = skew_ln.min(); 
        min_skew = min_val.pop_front();
        `uvm_info("eth_ptp_base_vl_offset", $sformatf("min skew value = 32'h%0h",min_skew),UVM_NONE)

        lane_skew_adjust = skew_ln[phy_ln0_map] - min_skew + (skew_ln.sum()/4);
        `uvm_info("eth_ptp_base_vl_offset", $sformatf("lane_skew_adjust = 32'h%0h",lane_skew_adjust),UVM_NONE)

        //Tlat_final = (lane_skew_adjust*80 + cw_pos_rx[phy_ln0_map][4:0]) * 0.038788;
        Tlat_final = (lane_skew_adjust*80 + cw_pos_rx[phy_ln0_map][4:0]);
        `uvm_info("eth_ptp_base_vl_offset", $sformatf("Tlat_final = 32'h%0h",Tlat_final),UVM_NONE)

        dskw_delay.selected_pl = phy_ln0_map;
        dskw_delay.deskew_delay = Tlat_final;

        `uvm_info("eth_ptp_base_vl_offset", "Generate VL offset data\n",UVM_LOW)
        generate_vl_data_fec_mode(dskw_delay);

`else
        // Check if VL offset data is ready
        `uvm_info("eth_ptp_base_vl_offset", "Waiting for VL offset data ready\n",UVM_LOW)
//YC        do begin
          //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10, read_data, 1);
//YC          p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG,read_data, 1);
//YC        end
//YC        while(read_data[31] !== 1'b1);

        // Read unprocessed VL offset data and calculate
        for(vl = 0; vl < 20; vl++) begin
            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Reading VL offset data for VL %0d",vl),UVM_NONE)
            //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10 + (vl*2), read_data, 1);
//YC            p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG + (vl*2),read_data, 1);
            {vl_data[vl].am_count,
             vl_data[vl].ba_pos,
             vl_data[vl].ba_phase,
             vl_data[vl].gb_state} = read_data[23:0];

            //p_sequencer.env.reg_read(ETH_ADDR_OFFSET + 19'hC10 + (vl*2)+1, read_data, 1);
//YC            p_sequencer.env.reg_read(`REGISTERS_ptp_vl0_offset_data_0_OFFSET_REG + (vl*2)+1,read_data, 1);
            {vl_data[vl].local_pl,
             vl_data[vl].remote_vl,
             vl_data[vl].local_vl} = read_data[11:0];

            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Calculating VL offset data for VL %0d",vl),UVM_NONE)
            calculate_vl_offset(vl_data[vl]);
        end

`endif
       
        // Configure calculated VL offset data
        for(vl = 0; vl < 20; vl++) begin
            `uvm_info("eth_ptp_base_vl_offset", $sformatf("Writing VL offset data for VL %0d", vl),UVM_NONE)
            //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hC40 + (vl*2), {25'h0, vl_offset_load_arr[vl][6:0]});
            //p_sequencer.env.reg_write(ETH_ADDR_OFFSET + 19'hC40 + (vl*2)+1, vl_offset_load_arr[vl][38:7]);
//YC            p_sequencer.env.reg_write(`REGISTERS_ptp_vl0_offset_cfg_0_OFFSET_REG + (vl*2), {25'h0, vl_offset_load_arr[vl][6:0]});
//YC            p_sequencer.env.reg_write(`REGISTERS_ptp_vl0_offset_cfg_0_OFFSET_REG + (vl*2)+1, vl_offset_load_arr[vl][38:7]);
        end

        `uvm_info("ptp_vl_reload_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
        wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
        `uvm_info("ptp_vl_reload_sequence", "RX PTP ready\n",UVM_LOW)

        fork
        begin
          repeat(100) begin
            if(mix_rule)
              std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
            else
              std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
            std::randomize(f_type) with {f_type inside {DATA_FRAME,VLAN_FRAME,STACKED_VLAN_FRAME};};
            randcase
            1:send_ptp_frame(ptp_op,f_type,1);  
            1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
            endcase
          end
        end
        begin
          repeat(100) begin
           randcase
           1:send_eth_frame_with_fix_size(RANDOM_FRAME,64,1,ETH_VIP_AVL_RX);
           1:send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);  
           endcase
          end
        end
        join


  endtask

endclass : ptp_vl_reload_sequence
