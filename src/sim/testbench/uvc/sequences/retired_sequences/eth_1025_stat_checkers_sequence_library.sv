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
// Sequence Name: eth1025_stat_base_sequence
// Descriptions: 
// 1. Base sequence for stat sequences
//*******************************************************************************
class eth1025_stat_base_sequence extends eth1025_base_sequence;
     uvm_reg_data_t read_data_tx;
     uvm_reg_data_t read_data_rx;
     `uvm_object_utils(eth1025_stat_base_sequence)
     
     function new(string name = "seq_0");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
          uvm_reg_data_t rd_data;
          string func_name="body";
          uvm_cmdline_processor  inst;
          string m_sequence = "vip1025_sanity_sequence";
          `uvm_info("body", "started eth1025_stat_base_sequence ...", UVM_NONE)
          //Enable vector scoreboard
          //en_vec_sb();
          
          //reducing num_of_frames to max 2.5K to reduce sim time for stats
          //if(num_of_frames > 2500) begin
          //  void'(std::randomize(num_of_frames) with { num_of_frames dist {[500:700]:=35 , [701:1000]:=25 , [1001:2000]:=20 , [2001:2500]:=10};});
          //end    
          //Shabbir- Rekha wants to complete stats tests in 8 hours
          if(num_of_frames > 600) begin
               void'(std::randomize(num_of_frames) with { num_of_frames dist {[100:200]:=45 , [201:400]:=35 , [401:600]:=20};});
          end    
          //Shabbir- cr3 link up takes ~5 times more than cr2e, hence num_of_frames has to be reduced to complete test in 8 hours
          `ifdef CRETE3
          
               if(num_of_frames > 300) begin
                    void'(std::randomize(num_of_frames) with { num_of_frames dist {[50:100]:=45 ,[101:200]:=35 , [201:300]:=20};});
               end    
               //For below sequences, need to reduce frame count to complete test in 8 hours
               inst = uvm_cmdline_processor::get_inst();
               inst.get_arg_value("+m_sequence=",m_sequence);
               
               if(num_of_frames > 70 && (m_sequence == "eth1025_stat_64B_MAXB_cnt_sequence"         || 
                    m_sequence == "eth1025_stat_crcerrokpkt_cnt_sequence"  || 
                    m_sequence == "eth1025_stat_reset_sequence"          || 
                    m_sequence == "eth1025_stat_shadowcopy_sequence"        || 
                    m_sequence == "eth1025_stats_fragments_rnt_cnt_sequence"    || 
                    m_sequence == "eth1025_stat_pause_cnt_sequence"    || 
                    m_sequence == "eth1025_stat_fcs_err_frame_seq")) begin
                    void'(std::randomize(num_of_frames) with { num_of_frames dist {[30:40]:=45 ,[41:60]:=35 , [61:70]:=20};});
               end
          
          `endif
          `uvm_info(get_name(),$sformatf("eth1025_stat_base_sequence: no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
          
          //Demoting common error
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          
          apply_hard_reset(0,0,1,11);
          
          `ifdef CRETE3
               p_sequencer.env.wait_rx_pcs_ready();
          `else  
               rx_pcs_ready_timeout();//Shabbir - FB 534015
          `endif  
          
          //For tx error insertion
          //enable_tx_error_insertion();//Disabling Tx error insertion for every tests
          
          rand_regs();
          
          //Need to clear stat registers as Mlab RAM is not initialized. FB 489113
          clear_stat_counters();
          #400ns;
          //p_sequencer.env.eth_ref_model_inst.dis_fc_assertion=1;
          
          //FIXME Shabbir: currently DV is not able to capture read data x, so clear parity error in any case
          //Read status regsiters for parity error
          //reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
          //reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
          
          //if(read_data_tx[0]!==0) begin
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
          //end
          //if(read_data_rx[0]!==0) begin
               reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
          //end
          
          #100ns;
          //parity error should get cleared now
          //FIXME Shabbir: currently DV is not able to capture read data x
          //reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
          //reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
          if(read_data_tx[0]!==0) begin
               `uvm_error("eth1025_stat_base_sequence", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=%0b",func_name,read_data_tx[0]));
          end
          if(read_data_rx[0]!==0) begin
               `uvm_error("eth1025_stat_base_sequence", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=%0b",func_name,read_data_rx[0]));
          end
          
          #0;
          //FIXME EHIP Shabbir: FB 505364, need to fix DV, scripts
          reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
          //Shabbir: disabling en_sfc/pfc, so SFC frames are not processed and traffic will not be halted on TX side even with fc1 which prevents AVST tiemout
          reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h0);
     
     endtask : body
     
     `ifdef UVM_VERSION_1_1
          virtual task post_start();
               string func_name="post_start";
               //Read status regsiters for parity error, it is checked in ref model
               //FIXME Shabbir: currently DV is not able to capture read data x
               //reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
               //reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
               if(read_data_tx[0]!==0) begin
                    `uvm_error("eth1025_stat_base_sequence", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=%0b",func_name,read_data_tx[0]));
               end
               if(read_data_rx[0]!==0) begin
                    `uvm_error("eth1025_stat_base_sequence", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=%0b",func_name,read_data_rx[0]));
               end
               super.post_start();
          endtask:post_start
     `endif
     
     virtual task sel_force_stat_regs(input bit _force_sel);
          bit [63:0] val;
          string cr_stats;
          // Initalised stat counters values
          val[63:0] = 'hffff_ffff_ffff_fffd;
          
          `uvm_info("[Force stats counters]", $psprintf("_force_sel value: %d ",_force_sel), UVM_NONE)
          
          case(_force_sel)
          
               0:     val[63:0] = {32'h0000_0000,$urandom_range(32'hffff_fff0,32'hffff_ffff)}; //lower 32bit MAX
               1:     val[63:0] = {32'hffff_ffff,$urandom_range(32'hffff_fff0,32'hffff_ffff)}; //upper 32bit MAX
               default:  $display("Selected default");//val[63:0] = $urandom_range(64'h0000_0000_ffff_fff0,64'h0000_0000_ffff_ffff); //lower 32bit MAX
          
          endcase
          
          `uvm_info("[Force stats counters]", $psprintf("Forced signals with value:64'h%h ",val), UVM_NONE)
          
          `ifdef CRETE3
            `ifdef FALCON_MESA
               cr_stats="eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_ehip_lane.ct3_hssi_ehip_lane_encrypted_inst.ct1_hssirtl_ehiplane_inst.die_specific_inst.x_ehiplane.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram"; 
            `else 
               cr_stats="eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_ehip_lane.ct3_hssi_ehip_lane_encrypted_inst.ct1_hssirtl_ehiplane_inst.die_specific_inst.x_ehiplane.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
            `endif //FALCON_MESA
          `else
               cr_stats="eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram";
          `endif
          
          //{eth_env_top.dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.ct1_hssi_cr2_ehip_core_encrypted_inst.ct1_hssirtl_c2_ehip_core_inst.u_ehip_cfgcsr.csr_arb.csr_stats.stats_ram[35:0][129:0]}
          for(int k=0;k<36;k++) begin
               uvm_hdl_force({cr_stats,$psprintf("[%0d][31:0]",k)},  val[31:0]);
               uvm_hdl_force({cr_stats,$psprintf("[%0d][63:32]",k)}, val[63:32]);
               uvm_hdl_force({cr_stats,$psprintf("[%0d][95:64]",k)}, val[31:0]);
               uvm_hdl_force({cr_stats,$psprintf("[%0d][127:96]",k)},val[63:32]);
          end
          p_sequencer.env.eth_ref_model_inst.force_lsb_stat_regs(val);
          //repeat(50) @(posedge spy_vif.u_ehip_core_u_tx_mac_i_clk);
          #5ns;
          `uvm_info("[Force stats counters]", $psprintf("Released signals\n"), UVM_NONE)
          
          for(int k=0;k<36;k++) begin
               uvm_hdl_release({cr_stats,$psprintf("[%0d][31:0]",k)});
               uvm_hdl_release({cr_stats,$psprintf("[%0d][63:32]",k)});
               uvm_hdl_release({cr_stats,$psprintf("[%0d][95:64]",k)});
               uvm_hdl_release({cr_stats,$psprintf("[%0d][127:96]",k)});
          end
          
     endtask : sel_force_stat_regs     
     
endclass:eth1025_stat_base_sequence


//*******************************************************************************
// Sequence Name: vip1025_sanity_sequence
// Descriptions: 
// 1.Shabbrir: creating temporary sequence to read stat registers 
//   for FB 480945. So designer can validate his fix
//*******************************************************************************
class stat1025_sanity_sequence extends eth1025_stat_base_sequence;
     
     `uvm_object_utils(stat1025_sanity_sequence)
     function new(string name = "stat1025_sanity_sequence");
     super.new(name);
          `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          super.body();
          `ifdef ENABLE_ETH_VIP
               fork
               send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,3);  
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
               join
          `else
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
          `endif
          $display("end stat sanity sequence");
     endtask
  
endclass:stat1025_sanity_sequence

//class fcs_error_sequence extends eth1025_stat_base_sequence;
////  sequence_0 tx_seq;
////  bit rx_crc_pass;
////  ethernet_random_sequence eth_seq;
//  `uvm_object_utils(fcs_error_sequence)
//  function new(string name = "seq_0");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
//// tx_seq=new("tx_seq");  
// endfunction:new
//
//  virtual task body();
////   $display("running stat sanity sequence");
////   apply_hard_reset(0,0,1,11);
////   rx_crc_pass=$urandom;
////   p_sequencer.env.wait_rx_pcs_ready();
////   reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
////   $display("DONE!!! WRITING TO REG");
////   clear_stat_counters();
////   #400ns;
// //  tx_seq.start(p_sequencer.tx_seqr);
//    super.body();
// `ifdef ENABLE_ETH_VIP
//        send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
//  `else
//        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
// `endif
//   $display("end stat sanity sequence");
//  endtask
//  //`ifdef UVM_VERSION_1_1
//  // virtual task post_start();
//  //  if ((get_parent_sequence() == null) && (starting_phase != null))
//  //    starting_phase.phase_done.set_drain_time(this, 2us);
//  //    read_1025_stats();
//  //    starting_phase.drop_objection(this, "Ending");
//  //endtask:post_start
//  //`endif
//endclass:fcs_error_sequence

// Fixme : Utpal - Added this sequence for debug purpose. Need to remove it later. 
//class eth_debug_seq extends eth1025_stat_base_sequence;
//
//  `uvm_object_utils(eth_debug_seq)
//
//  function new(string name = "eth_debug_seq");
//    super.new(name);
//	  `ifdef UVM_POST_VERSION_1_1
//    set_automatic_phase_objection(1);
//    `endif
//  endfunction:new
//
//  virtual task body();
//
//    //Enable vector scoreboard
//    //en_vec_sb();
//
//    //apply_hard_reset(0,0,1,11);
//    //`uvm_info("eth_debug_seq", "1. Apply csr reset", UVM_NONE)
//    //p_sequencer.env.wait_rx_pcs_ready();
//    //`uvm_info("eth_debug_seq", "wait_rx_pcs_ready done ...", UVM_NONE)
//
//    super.body();
//    fork
//      begin
//        randcase 
//          1: send_eth_frame_with_fix_size(DATA_FRAME,62,1,ETH_VIP_AVL_RX);
//        endcase
//      end  
//      begin
//        randcase 
//          1: send_eth_frame_with_fix_size(DATA_FRAME,62,1,AVL_TX_ETH_VIP);
//        endcase
//      end  
//    join
//
//    //#600ns; // Need this delay to adjust race condition in ref model
//    //read_1025_stats();
//    //`uvm_info("eth_debug_seq", " Read all stats counter registers", UVM_NONE)
//    //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    //#10ns;
//    //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//
//
//
//  endtask
//
//endclass: eth_debug_seq


//// Fixme : Utpal - Added this sequence for debug purpose. Need to remove it later. 
//class eth_debug_seq_1 extends eth1025_stat_base_sequence;
//
//  `uvm_object_utils(eth_debug_seq_1)
//
//  function new(string name = "eth_debug_seq_1");
//    super.new(name);
//	  `ifdef UVM_POST_VERSION_1_1
//    set_automatic_phase_objection(1);
//    `endif
//  endfunction:new
//
//  virtual task body();
//
//    //Enable vector scoreboard
//    //en_vec_sb();
//
//    //apply_hard_reset(0,0,1,11);
//    //`uvm_info("eth_debug_seq_1", "1. Apply csr reset", UVM_NONE)
//    //p_sequencer.env.wait_rx_pcs_ready();
//    //`uvm_info("eth_debug_seq_1", "wait_rx_pcs_ready done ...", UVM_NONE)
//    super.body();
//
//    send_directed_frames();
//
//    //#600ns;
//    //read_1025_stats();
//
//
//  endtask
//
//endclass: eth_debug_seq_1


//*******************************************************************************
// Sequence Name: eth1025_stats_fragments_rnt_cnt_sequence
// Descriptions:
// 1. Apply csr reset.
// 2. Read FRAGMENTS and RNT registers.
// 3. Send undersize frame with an FCS error or without an FCS Error randomly.
// 4. Read FRAGMENTS and RNT counter register
// 5. Repeat step 3 and step 4 five to ten time to ensure FRAGMENTS and RNT counters increments by 1.
// 6. Send undersize and normal frames without FCS Error and Read FRAGMENTS and RNT counter registers.
// 7. Send undersize and normal frames with FCS Error and Read FRAGMENTS and RNT counter registers.
// 8. Send 63/64/65 bytes frame with FCS error and read FRAGMENTS and RNT counter registers after each frame.
// 9. send 63/64/65 bytes frame without FCS error and read FRAGMENTS and RNT counter registers after each frame
// 10. Send undersize and normal with and without FCS Error frames randomly.
// 11. Read FRAGMENTS and RNT counter registers.
// 12. Send random frames such that read value of FRAGMENTS and RNT counters status register rollover from 32 bit value to 33 bit value  and read FRAGMENTS and RNT registers after each frame.
// 13. Send random frames such that read value of FRAGMENTS and RNT counter status registers reach to maximum value  
// 14. Read FRAGMENTS and RNT counter registers.
// 15. Send undersize and normal with and without FCS Error randomly after FRAGMENTS and RNT counter reaches to maximum value.
// 16. Read FRAGMENTS and RNT counter register to make sure counter does not rollover.
// 17. Read all stats counter registers
// This sequence can be used to drive fragment and runt frames from VIP 
//Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stats_fragments_rnt_cnt_sequence extends eth1025_stat_base_sequence;

     `uvm_object_utils(eth1025_stats_fragments_rnt_cnt_sequence)
     
     function new(string name = "eth1025_stats_fragments_rnt_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
     
     super.body();
     //Enable vector scoreboard
     //en_vec_sb();
     
     //apply_hard_reset(0,0,1,11);
     //`uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "1. Apply csr reset", UVM_NONE)
     //p_sequencer.env.wait_rx_pcs_ready();
     //`uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
     
     //Disable eth_scoreboard check as we are doing FCS error injection
     //enable_tx_error_insertion();     
     
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
     
     //clear_stat_counters();
     //#400ns;
     
     //read_registers();
     //`uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "2. Read FRAGMENTS and RNT registers.", UVM_NONE)
     
     repeat(num_of_frames/4) begin
          fork
          begin
               randcase 
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1);
               1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX);
               endcase
          end  
          begin
               randcase 
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);
               1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
               endcase
          end  
          join	
          read_registers();
     end
     
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "3. Send undersize frame with an FCS error or without an FCS Error randomly.", UVM_NONE)
     
     //   `ifdef ENABLE_ETH_VIP
     //    p_sequencer.env.ts_tasks_if.do_drv_err(`ETH_MAC_INCORRECT_FCS,72'h0);
     //   `endif
     //   `uvm_info("send_eth_frame_with_fcs_error", $sformatf("sending %0s frame with FCS error",f_type.name()),UVM_NONE);
     //   send_eth_frame(f_type,xfer_path path,1);
     
     //   send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);
     //   send_eth_frame_with_fcs_error(UNDERSIZE_FRAME,ETH_VIP_AVL_RX);
     //   send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);
     
     
     repeat(num_of_frames/4) begin
          fork
          begin
               randcase 
               1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX);
               endcase
          end  
          begin
               randcase 
               1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
               endcase
          end  
          join	
     end
     read_registers();
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "6. Send undersize and normal frames without FCS Error and Read FRAGMENTS and RNT counter registers.", UVM_NONE)
     
     repeat(num_of_frames/4) begin
          fork
          begin
               randcase 
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1);
               endcase
          end  
          begin
               randcase 
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);
               endcase
          end  
          join	
     end
     read_registers();
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "7. Send undersize and normal frames with FCS Error and Read FRAGMENTS and RNT counter registers.", UVM_NONE)
     
     //frame size = 63
     fork
          begin
          randcase
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,63);
               1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,63);
               1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,63);
          endcase
          end  
          begin
          randcase
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,63);
               1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,63);
               1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,63);
          endcase
          end  
     join	
     read_registers();
     
     
     //frame size = 64
     fork
          begin
          randcase
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,64);
               1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,64);
               1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,64);
          endcase
          end  
          begin
          randcase
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,64);
               1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,64);
               1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,64);
          endcase
          end  
     join	
     read_registers();
     
     
     //frame size = 65
     fork
          begin
          randcase
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,65);
               1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,65);
               1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,65);
          endcase
          end  
          begin
          randcase
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,65);
               1: send_eth_frame_with_fcs_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,65);
               1: send_eth_frame_with_fcs_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,65);
          endcase
          end  
     join	
     read_registers();
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "8. Send 63/64/65 bytes frame with FCS error and read FRAGMENTS and RNT counter registers after each frame.", UVM_NONE)
     
     
     //frame size = 63
     fork
          begin
          randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,63,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(VLAN_FRAME,63,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,63,1,ETH_VIP_AVL_RX);
          endcase
          end  
          begin
          randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,63,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(VLAN_FRAME,63,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,63,1,AVL_TX_ETH_VIP);
          endcase
          end  
     join	
     read_registers();
     
     //frame size = 64
     fork
          begin
          randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,64,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(VLAN_FRAME,64,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,64,1,ETH_VIP_AVL_RX);
          endcase
          end  
          begin
          randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,64,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(VLAN_FRAME,64,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,64,1,AVL_TX_ETH_VIP);
          endcase
          end  
     join	
     read_registers();
     
     //frame size = 65
     fork
          begin
          randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,65,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(VLAN_FRAME,65,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,65,1,ETH_VIP_AVL_RX);
          endcase
          end  
          begin
          randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,65,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(VLAN_FRAME,65,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,65,1,AVL_TX_ETH_VIP);
          endcase
          end  
     join	
     read_registers();
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "9. send 63/64/65 bytes frame without FCS error and read FRAGMENTS and RNT counter registers after each frame", UVM_NONE)
     
     repeat(num_of_frames/4) begin
          fork
          begin
               randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX);
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1);
               endcase
          end  
          begin
               randcase
               1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
               1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
               1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);
               endcase
          end  
          join	
     end
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "10. Send undersize and normal with and without FCS Error frames randomly.", UVM_NONE)
     
     read_registers();
     `uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "11. Read FRAGMENTS and RNT counter registers.", UVM_NONE)
     
     //    p_sequencer.env.ts_tasks_if.force_dut_signal("eth_env_top.dut.top.alt_s100.alt_e100s10_mac.u_stats_counters.u_rx_stats_counters.stats_ram_0_15.view_wdata",32'hFFFF_FFFE);
     //    #1ns;
     //    p_sequencer.env.ts_tasks_if.release_dut_signal("eth_env_top.dut.top.alt_s100.alt_e100s10_mac.u_stats_counters.u_rx_stats_counters.stats_ram_0_15.view_wdata");
     
     
     // Fixme : add code for the remaining part of the sequence after support for forcing register to fix value is added 
     
     //    force $root.eth_env_top.dut.top.alt_s100.csr.write = 1'b1;
     //    force $root.eth_env_top.dut.top.alt_s100.csr.address = 16'h900;
     //    force $root.eth_env_top.dut.top.alt_s100.csr.data_in = 32'hFFFF_FFFE;
     //    repeat(12) @(posedge $root.eth_env_top.dut.top.alt_s100.csr.csr_clk);
     //    release $root.eth_env_top.dut.top.alt_s100.csr.write;
     //    release $root.eth_env_top.dut.top.alt_s100.csr.address;
     //    release $root.eth_env_top.dut.top.alt_s100.csr.data_in;
     
     //    uvm_hdl_force($root.eth_env_top.dut.top.alt_s100.csr.write,1'b1);
     //    uvm_hdl_force($root.eth_env_top.dut.top.alt_s100.csr.address,16'h900);
     //    uvm_hdl_force($root.eth_env_top.dut.top.alt_s100.csr.data_in,32'hFFFF_FFFE);
     //   // (12) @(posedge $root.eth_env_top.dut.top.alt_s100.csr.csr_clk);
     //    #120ns; 
     //    uvm_hdl_release($root.eth_env_top.dut.top.alt_s100.csr.write);
     //    uvm_hdl_release($root.eth_env_top.dut.top.alt_s100.csr.address);
     //    uvm_hdl_release($root.eth_env_top.dut.top.alt_s100.csr.data_in);
     
     
     //#600ns; // Need this delay to adjust race condition in ref model
     //read_1025_stats();
     //`uvm_info("eth1025_stats_fragments_rnt_cnt_sequence", "17. Read all stats counter registers", UVM_NONE)
     
     endtask
     
     task read_registers();
     #2000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
     reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask
     
endclass : eth1025_stats_fragments_rnt_cnt_sequence



//*******************************************************************************
// Sequence Name: eth1025_stat_fcs_err_frame_seq
// Descriptions:
// 1. Apply csr reset.
// 2. Read FCSERR register.
// 3. Send one frame with FCS error (i.e oversize,undersize,normal)
// 4. Read FCSERR counter register
// 5. Repeat step 3 and step 4 five to ten time to ensure FCSERR counter increments by 1.
// 6. Send some frames without FCS error (i.e oversize,undersize,normal). 
// 7. Read FCSERR register
// 8. Send random  frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)
// 9. Read FCSERR register
// 10. Send random frames such that read value of FCSERR counter status register rollover from 32 bit value to 33 bit value  and read FCSERR register after each frame.
// 11. Send random frames such that read value of FCSERR counter status register reaches to maximum value  
// 12. Read FCSERR counter register
// 13. Send random frames after FCSERR counter reaches to maximum value.
// 14. Read FCSERR counter register to make sure counter does not rollover.
// 15. Read all stats counter registers
//Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_fcs_err_frame_seq extends eth1025_stat_base_sequence;

     `uvm_object_utils(eth1025_stat_fcs_err_frame_seq)
     
     function new(string name = "eth1025_stat_fcs_err_frame_seq");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();          
     
          //Enable vector scoreboard
          //en_vec_sb();
          
          //apply_hard_reset(0,0,1,11);
          //`uvm_info("eth1025_stat_fcs_err_frame_seq", "1. Apply csr reset", UVM_NONE)
          //p_sequencer.env.wait_rx_pcs_ready();
          //`uvm_info("eth1025_stat_fcs_err_frame_seq", "wait_rx_pcs_ready done ...", UVM_NONE)
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //clear_stat_counters();
          //#400ns;
          
          //read_registers();
          //`uvm_info("eth1025_stat_fcs_err_frame_seq", "2. Read FCSERR register.", UVM_NONE)
          
          repeat(num_of_frames/3) begin
               fork
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1); // undresize
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);// Noraml frame
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,10000));// Oversize frame
                    endcase
               end  
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1); // undresize
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);// Noraml frame
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,10000));// Oversize frame
                    endcase
               end  
               join	
               read_registers();
          end
          
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "3. Send one frame with FCS error (i.e oversize,undersize,normal)", UVM_NONE)
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "4. Read FCSERR counter register", UVM_NONE)
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "5. Repeat step 3 and step 4 five to ten time to ensure FCSERR counter increments by 1.", UVM_NONE)
          
          repeat(num_of_frames/3) begin
               fork
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX); //undresize
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX); //Normal
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(9601,10000),1,ETH_VIP_AVL_RX); //Oversize
                    endcase
               end  
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP); //undresize
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP); //Normal
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(9601,10000),1,AVL_TX_ETH_VIP); //Oversize
                    endcase
               end  
               join	
          end
          
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "6. Send some frames without FCS error (i.e oversize,undersize,normal).", UVM_NONE) 
          
          read_registers();
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "7. Read FCSERR register", UVM_NONE)
          
          repeat(num_of_frames/3) begin
               fork
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX); //undresize
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX); //Normal
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(9601,10000),1,ETH_VIP_AVL_RX); //Oversize
                         1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1); // undresize
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);// Noraml frame
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,10000));// Oversize frame
                    endcase
               end  
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP); //undresize
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP); //Normal
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(9601,10000),1,AVL_TX_ETH_VIP); //Oversize
                         1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1); // undresize
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);// Noraml frame
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,10000));// Oversize frame
                    endcase
               end  
               join	
          end
          
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "8. Send random  frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)", UVM_NONE)
          
          read_registers();
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "9. Read FCSERR register", UVM_NONE)
          
          // Fixme : add code for the remaining part of the sequence after support for forcing register to fix value is added
          
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "10. Send random frames such that read value of FCSERR counter status register rollover from 32 bit value to 33 bit value  and read FCSERR register after each frame.", UVM_NONE)
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "11. Send random frames such that read value of FCSERR counter status register reaches to maximum value", UVM_NONE)
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "12. Read FCSERR counter register", UVM_NONE)
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "13. Send random frames after FCSERR counter reaches to maximum value.", UVM_NONE)
          `uvm_info("eth1025_stat_fcs_err_frame_seq", "14. Read FCSERR counter register to make sure counter does not rollover.", UVM_NONE)
          
          //#600ns; // Need this delay to adjust race condition in ref model
          //read_1025_stats();
          //`uvm_info("eth1025_stat_fcs_err_frame_seq", "15. Read all stats counter registers", UVM_NONE)
     
     endtask
     
     task read_registers();
          #2000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask

endclass : eth1025_stat_fcs_err_frame_seq

//*******************************************************************************
// Sequence Name: eth1025_stat_reset_sequence_part_1
// Descriptions:
//Class : eth1025_stat_reset_sequence_part_1
// 1. Apply csr reset.
// 2. Read all stats counter register 
// 3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
// 4. Read all stats counter register .
// 5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
// 6. Repeat step 3 and 4.
// 7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
// 8. Read all stats counter register .
// 9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
// 10. Read all stats counter registers.
// 11. repeat step 6.
// 12. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
// 4. Read all stats counter registers.
// 13. read all stat regiters after sending some frames to make sure counter does not gts updated  
// 14. repeat step 7 to 10.
// 15. EHIP: check clear stats functionality
//*******************************************************************************
class eth1025_stat_reset_sequence_part_1 extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_reset_sequence_part_1)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_reset_sequence_part_1");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t read_data_tx;
          uvm_reg_data_t read_data_rx;
          bit skip_stat_reg_rd_l = 0;
          `uvm_info("body", "started eth1025_stat_reset_sequence_part_1 ...", UVM_NONE)
          super.body();
          
          if($test$plusargs("skip_stat_reg_rd")) begin
               skip_stat_reg_rd_l = 1;
          end
          else begin
               skip_stat_reg_rd_l = 0;
          end
          
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = num_of_frames/4;
          end
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          
          `ifdef RSFEC
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif
          
          
          //if(skip_stat_reg_rd_l === 0) begin
          //  //read and compare all stats at the begining of sequence
          //  `uvm_info("eth1025_stat_reset_sequence", "2. read and compare all stats at the begining of sequence", UVM_NONE)
          //  read_1025_stats();
          //end
          
          //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_reset_sequence_part_1", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; 
          `uvm_info("eth1025_stat_reset_sequence_part_1", "3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
          write_stat_regs();
          
          //4. Read all stats counter register .
          `uvm_info("eth1025_stat_reset_sequence_part_1", "4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter.
          `uvm_info("eth1025_stat_reset_sequence_part_1", "5. Apply eio_sys_rst,csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter", UVM_NONE)
          apply_rst_to_clear_stat_reg();
          
          //6. Repeat step 3 and 4.
          `uvm_info("eth1025_stat_reset_sequence_part_1", "6. Repeat step 3 and 4", UVM_NONE)
          `uvm_info("eth1025_stat_reset_sequence_part_1", "6.3. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; 
          `uvm_info("eth1025_stat_reset_sequence_part_1", "6.3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
          write_stat_regs();
          
          //4. Read all stats counter register .
          `uvm_info("eth1025_stat_reset_sequence_part_1", "6.4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          #400ns;
          
          `uvm_info("body", "ended eth1025_stat_reset_sequence_part_1 ...", UVM_NONE)
     endtask

endclass:eth1025_stat_reset_sequence_part_1


class eth1025_stat_reset_sequence_part_2 extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_reset_sequence_part_2)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_reset_sequence_part_2");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t read_data_tx;
          uvm_reg_data_t read_data_rx;
          bit skip_stat_reg_rd_l = 0;
          `uvm_info("body", "started eth1025_stat_reset_sequence_part_2 ...", UVM_NONE)
          super.body();
          
          if($test$plusargs("skip_stat_reg_rd")) begin
               skip_stat_reg_rd_l = 1;
          end
          else begin
               skip_stat_reg_rd_l = 0;
          end
          
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = num_of_frames/4;
          end
          
          //Disable vip errors
          demote_error();
          
          //if(skip_stat_reg_rd_l === 0) begin
          //  //read and compare all stats at the begining of sequence
          //  `uvm_info("eth1025_stat_reset_sequence_part_2", "2. read and compare all stats at the begining of sequence", UVM_NONE)
          //  read_1025_stats();
          //end
          
          //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_reset_sequence_part_2", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; 
          `uvm_info("eth1025_stat_reset_sequence_part_2", "3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
          write_stat_regs();
          
          //4. Read all stats counter register .
          `uvm_info("eth1025_stat_reset_sequence_part_2", "4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
          `uvm_info("eth1025_stat_reset_sequence_part_2", "7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly", UVM_NONE)
          apply_tx_rx_hard_soft_rst();
          //From apply_tx_rx_hard_soft_rst task, it will again enable vip error so we need to disable vip error again in below task call
          demote_error();
          
          `uvm_info("eth1025_stat_reset_sequence_part_2", "8. Read all stats counter register to check they retain value", UVM_NONE)
          read_1025_stats();
          
          `uvm_info("eth1025_stat_reset_sequence_part_2", "9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 to clear the stats counter and 10. Read all stats counter registers", UVM_NONE)
          apply_rst_to_clear_stat_reg();
          
          //11. repeat step 6
          `uvm_info("eth1025_stat_reset_sequence_part_2", "11. Repeat step 6", UVM_NONE)
          `uvm_info("eth1025_stat_reset_sequence_part_2", "11.6. Repeat step 3 and 4", UVM_NONE)
          `uvm_info("eth1025_stat_reset_sequence_part_2", "11.6.3. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; 
          `uvm_info("eth1025_stat_reset_sequence_part_2", "11.6.3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
          write_stat_regs();
          
          //4. Read all stats counter register .
          `uvm_info("eth1025_stat_reset_sequence_part_2", "11.6.4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          #400ns;
          
          `uvm_info("body", "ended eth1025_stat_reset_sequence_part_2 ...", UVM_NONE)
     endtask
     
     task demote_error();
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
     
          `ifdef RSFEC
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif     
     
     endtask
     
endclass:eth1025_stat_reset_sequence_part_2

class eth1025_stat_reset_sequence_part_3 extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_reset_sequence_part_3)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_reset_sequence_part_3");
     super.new(name);
     `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t read_data_tx;
          uvm_reg_data_t read_data_rx;
          bit skip_stat_reg_rd_l = 0;
          `uvm_info("body", "started eth1025_stat_reset_sequence_part_3 ...", UVM_NONE)
          super.body();
          
          if($test$plusargs("skip_stat_reg_rd")) begin
               skip_stat_reg_rd_l = 1;
          end
          else begin
               skip_stat_reg_rd_l = 0;
          end
          
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = num_of_frames/4;
          end
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame

          `ifdef RSFEC
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif          

          
          //if(skip_stat_reg_rd_l === 0) begin
          //  //read and compare all stats at the begining of sequence
          //  `uvm_info("eth1025_stat_reset_sequence_part_3", "2. read and compare all stats at the begining of sequence", UVM_NONE)
          //  read_1025_stats();
          //end
          
          //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_reset_sequence_part_3", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; 
          `uvm_info("eth1025_stat_reset_sequence_part_3", "3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
          write_stat_regs();
          
          //4. Read all stats counter register .
          `uvm_info("eth1025_stat_reset_sequence_part_3", "4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          
          //12. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
          `uvm_info("eth1025_stat_reset_sequence_part_3", "12. Apply shadow request", UVM_NONE)
          apply_shadow_request();
          read_1025_stats();//As per Mehul's feedback
          
          //13. read all stat regiters after sending some frames to make sure counter does not gets updated  
          `uvm_info("eth1025_stat_reset_sequence_part_3", "13. read all stat regiters after sending some frames to make sure counter does not gets updated", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; //572434250 FIXME Shabbir: wait till tx/rx frame is decoded by MAC and stat is updated
          read_1025_stats();//As per Mehul's feedback
          
          `uvm_info("eth1025_stat_reset_sequence_part_3", "13.1. clear shadow request", UVM_NONE)
          clear_shadow_request();
          
          #0;
          `uvm_info("eth1025_stat_reset_sequence_part_3", "13.2. Read all stats counter registers, they should have actual counter values as shadow request is cleared", UVM_NONE)
          read_1025_stats();
          #400ns;
          
          `uvm_info("body", "ended eth1025_stat_reset_sequence_part_3 ...", UVM_NONE)
     endtask

endclass:eth1025_stat_reset_sequence_part_3

class eth1025_stat_reset_sequence_part_4 extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_reset_sequence_part_4)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_reset_sequence_part_4");
     super.new(name);
     `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t read_data_tx;
          uvm_reg_data_t read_data_rx;
          bit skip_stat_reg_rd_l = 0;
          `uvm_info("body", "started eth1025_stat_reset_sequence_part_4 ...", UVM_NONE)
          super.body();
          
          if($test$plusargs("skip_stat_reg_rd")) begin
               skip_stat_reg_rd_l = 1;
          end
          else begin
               skip_stat_reg_rd_l = 0;
          end
          
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = num_of_frames/4;
          end
          
          //Disable vip errors
          demote_error();
          
          //if(skip_stat_reg_rd_l === 0) begin
          //  //read and compare all stats at the begining of sequence
          //  `uvm_info("eth1025_stat_reset_sequence_part_4", "2. read and compare all stats at the begining of sequence", UVM_NONE)
          //  read_1025_stats();
          //end
          
          //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_reset_sequence_part_4", "3. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          #700ns; 
          `uvm_info("eth1025_stat_reset_sequence_part_4", "3. send write request to these registers to make it is not overwritten by write request", UVM_NONE)
          write_stat_regs();
          
          //4. Read all stats counter register .
          `uvm_info("eth1025_stat_reset_sequence_part_4", "4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          
          //14. repeat step 7 to 10.
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14. repeat step 7 to 10", UVM_NONE)
          
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14.1. Apply shadow request again and apply reset/clear stat regs while shadow request is ON", UVM_NONE)
          apply_shadow_request();
          
          //7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14.7. Apply hard tx ,hard rx, soft tx or soft rx mac reset randomly", UVM_NONE)
          apply_tx_rx_hard_soft_rst();
          //From apply_tx_rx_hard_soft_rst task, it will again enable vip error so we need to disable vip error again in below task call
          demote_error();
          
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14.8. Read all stats counter register to check they retain value", UVM_NONE)
          read_1025_stats();
          
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14.9. Apply eio_sys_rst, csr reset or set CTRL_CONFIG register bit 0 and check stats counters are not reset and 14.10. Read all stats counter registers", UVM_NONE)
          apply_rst_to_clear_stat_reg();
          
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14.10. clear shadow request", UVM_NONE)
          clear_shadow_request();
          
          #0;
          `uvm_info("eth1025_stat_reset_sequence_part_4", "14.11. Read all stats counter registers, they should have actual counter values as shadow request is cleared", UVM_NONE)
          read_1025_stats();
          
          `uvm_info("eth1025_stat_reset_sequence_part_4", "15.1. Check clear stats functionality. Send frames to get counters incremented", UVM_NONE)
          send_directed_frames();
          send_random_frames(transaction_count);
          
          `uvm_info("eth1025_stat_reset_sequence_part_4", "15.2. Clear stats registers", UVM_NONE)
          clear_stat_counters();
          #400ns;
          
          `uvm_info("body", "ended eth1025_stat_reset_sequence_part_4 ...", UVM_NONE)
     endtask

     task demote_error();
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
     
          `ifdef RSFEC
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `endif     
     endtask

endclass:eth1025_stat_reset_sequence_part_4



//*******************************************************************************
// Sequence Name: eth1025_stat_jabbers_cnt_sequence
// Descriptions:
// 1. Apply csr reset.
// 2. Read JABBERS register and configure MAX PAYLOAD SIZE register with random value.
// 3. Send one oversize frame with FCS error 
// 4. Read JABBERS counter register
// 5. Repeat step 3 and step 4 five to ten time to ensure JABBERS counter increments by 1.
// 6. Send some oversize frames (>MAX PAYLAOD SIZE and MAXPAYLOADSIZE+1) without FCS error and Read JABBERS register.
// 7. Send some non oversize frame (< MAX PAYLAOD SIZE and = MAXPAYLAOD SIZE ) with and without FCS error 
// 8. Read JABBERS register 
// 9. Configure MAX PAYLOAD SIZE register with other than step 2 value.
// 10. Send random  frame (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error)
// 11. Read JABBERS register
// 12. Send random frames such that read value of JABBERS counter status register rollover from 32 bit value to 33 bit value  and read JABBERS register after each frame.
// 13. Send random frames such that read value of JABBERS counter status register reaches to maximum value  
// 14. Read JABBERS counter register
// 15. Send random frames after JABBERS counter reaches to maximum value.
// 16. Read JABBERS counter register to make sure counter does not rollover.
// 17. Read all stats counter registers
// This sequence can be used to drive jabber frames from VIP 
//Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_jabbers_cnt_sequence extends eth1025_stat_base_sequence;
  
     int frame_size_rx,frame_size_tx;
     //frame_type eth_frame;
     int frame_num_rx,frame_num_tx;
     
     `uvm_object_utils(eth1025_stat_jabbers_cnt_sequence)
     
     function new(string name = "eth1025_stat_jabbers_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", "Executing eth1025_stat_jabbers_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //Enable vector scoreboard
          //en_vec_sb();
          
          //`uvm_info("eth1025_stat_jabbers_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //p_sequencer.env.wait_rx_pcs_ready();
          //`uvm_info("eth1025_stat_jabbers_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
          
          ////Clearing stat counters
          //clear_stat_counters();
          //#400ns;
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          
          //2. Read JABBER register and configure MAX PAYLOAD SIZE register with random value.
          //read_registers();
          std::randomize(rx_max_frame_size) with {rx_max_frame_size dist {'d64 := 1, 'd16364 := 1, 'd9600 := 1, ['d64:'d16384] := 7}; };
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", $psprintf("2. Read JABBER register and configure RX MAX FRAME SIZE register with random value = %0d",rx_max_frame_size), UVM_NONE)
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
          
          std::randomize(tx_max_frame_size) with {tx_max_frame_size dist {'d64 := 1, 'd16384 := 1, 'd9600 := 1, ['d64:'d16384] := 7}; };
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", $psprintf("2. Read JABBER register and configure TX MAX FRAME SIZE register with random value = %0d",tx_max_frame_size), UVM_NONE)
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          
          
          //3. Send oversize frame with FCS error 
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", "3. Send oversize frame with FCS error", UVM_NONE)
          repeat(num_of_frames/4) begin
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               fork
               begin
                    frame_size_rx = $urandom_range(rx_max_frame_size+1,rx_max_frame_size+100);
                    send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
               end
               begin
                    frame_size_tx = $urandom_range(tx_max_frame_size+1,tx_max_frame_size+100);
                    send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_tx);
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
               end
               join
          end
          //4. Read JABBER counter register
          read_registers();
          
          //6. Send some oversize frames (>MAX PAYLAOD SIZE and MAXPAYLOADSIZE+1) without FCS error and Read JABBERS register.
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", "6. Send some oversize frames (>MAX PAYLAOD SIZE and MAXPAYLOADSIZE+1) without FCS error and Read JABBERS register.", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    frame_size_rx = $urandom_range(rx_max_frame_size+1,rx_max_frame_size+100);
                    //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
                    send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX);
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
               end
               begin
                    frame_size_tx = $urandom_range(tx_max_frame_size+1,tx_max_frame_size+100);
                    //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
                    send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
               end
               join
          end
          
          fork
          begin
               frame_size_rx = rx_max_frame_size+1;
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX);
               frame_num_rx++;
               `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
          end
          begin
               frame_size_tx = tx_max_frame_size+1;
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
               frame_num_tx++;
               `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
          end
          join
          read_registers();
          
          
          //7. Send some non oversize frame (< MAX PAYLAOD SIZE and = MAXPAYLAOD SIZE ) with and without FCS error 
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", "7. Send some non oversize frame (< MAX PAYLAOD SIZE and = MAXPAYLAOD SIZE ) with and without FCS error", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    frame_size_rx = $urandom_range(64,rx_max_frame_size);
                    //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
                    randcase
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);
                         1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
                    //read_registers();
               end
               begin
                    frame_size_tx = $urandom_range(64,tx_max_frame_size);
                    //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
                    randcase
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_tx);
                         1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
                    //read_registers();
               end
               join
          end
          read_registers();
          
          fork
          begin
               frame_size_rx = rx_max_frame_size;
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX);
               frame_num_rx++;
               `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
               //read_registers();
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);
               frame_num_rx++;
               `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
          end
          begin
               frame_size_tx = tx_max_frame_size;
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
               frame_num_tx++;
               `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
               //read_registers();
               //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
               send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_tx);
               frame_num_tx++;
               `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
          end
          join
          
          //8. Read JABBER counter register
          read_registers();
          
          //9. Configure MAX PAYLOAD SIZE register with other than step 2 value.
          rx_max_frame_size = $urandom_range(64,16384);
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
          tx_max_frame_size = $urandom_range(64,16364);
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          
          //10. Send random frame (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error)
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", "10. Send random frame (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error)", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    //randcase
                    //1:frame_size = $urandom_range(46,rx_max_frame_size-1);
                    //1:frame_size = $urandom_range(rx_max_frame_size,rx_max_frame_size+100);
                    //endcase
                    //std::randomize(eth_frame) with {eth_frame inside {[DATA_FRAME:JUMBO_STACKED_VLAN_FRAME]};};
                    std::randomize(frame_size_rx) with {frame_size_rx dist { [64:rx_max_frame_size] := 1, [rx_max_frame_size+1:rx_max_frame_size+100] := 1};};
                    randcase
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);
                         1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
               end
               begin
                    std::randomize(frame_size_tx) with {frame_size_tx dist { [64:tx_max_frame_size] := 1, [tx_max_frame_size+1:tx_max_frame_size+100] := 1};};
                    randcase
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_tx);
                         1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
               end
               join
          end
          read_registers();
          
          
          //Send frame with payload size 16000 to cover VIP functional coverage holes
          `uvm_info("eth1025_stat_jabbers_cnt_sequence", "11. Send frame with payload size 16000 to cover VIP functional coverage holes)", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    send_eth_frame_with_fix_size(RANDOM_FRAME,16018,1,ETH_VIP_AVL_RX);
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
               end
               begin
                    send_eth_frame_with_fix_size(RANDOM_FRAME,16018,1,AVL_TX_ETH_VIP);
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
               end
               join
          end
          read_registers();
          
          //Steps 12 to 15 is covered in eth1025_stat_counter_overflow sequence
     
     endtask
     
     //`ifdef UVM_VERSION_1_1
     //virtual task post_start();
     //  if ((get_parent_sequence() == null) && (starting_phase != null))
     //    starting_phase.phase_done.set_drain_time(this, 2us);
     //    read_1025_stats();
     //    starting_phase.drop_objection(this, "Ending");
     //endtask:post_start
     //`endif
     
     task read_registers();
          #2000ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask

endclass : eth1025_stat_jabbers_cnt_sequence


//*******************************************************************************
// Sequence Name: eth1025_stat_mcast_ctrl_cnt_sequence
// Descriptions:
//1. Apply csr reset.
//2. Read MCAST_CTRL_ERR and MCAST_CTRL_OK  registers.
//3. Send one multicast control frame with FCS error and without FCS randomly.
//4. Read MCAST_CTRL_ERR and MCAST_CTRL_OK  counter registers.
//5. Repeat step 3 and step 4 five to ten time to ensure MCAST_CTRL_ERR and MCAST_CTRL_OK counters increment by 1.
//6. Send some multicast control and normal data frames without fcs error and Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
//7. Send some multicast control and normal data frames with fcs error and Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
//8. Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
//9. Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
//10. Send random control frames such that read value of MCAST_CTRL_ERR and MCAST_CTRL_OK  counter status register rollover from 32 bit value to 33 bit value  and read MCAST_CTRL_ERR and MCAST_CTRL_OK  registers after each frame.
//11. Send random frames such that read value of MCAST_CTRL_ERR and MCAST_CTRL_OK  counter status register reaches to maximum value  
//12. Read MCAST_CTRL_ERR and MCAST_CTRL_OK counter register
//13. Send random multicast, unicast and broadcast   frames after MCAST_CTRL_ERR and MCAST_CTRL_OK  counter reaches to maximum value.
//14. Read MCAST_CTRL_ERR and MCAST_CTRL_OK counter register to make sure counter does not rollover.
//15. Read all stats counter registers
//Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_mcast_ctrl_cnt_sequence extends eth1025_stat_base_sequence;
     frame_type eth_frame;
     int frame_num_rx=0;
     int frame_num_tx=0;
     
     `uvm_object_utils(eth1025_stat_mcast_ctrl_cnt_sequence)
     
     function new(string name = "eth1025_stat_mcast_ctrl_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "Started eth1025_stat_mcast_ctrl_cnt_sequence...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //Enable vector scoreboard
          //en_vec_sb();
          ////Step 1: Apply csr reset.
          //`uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //`uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
          //p_sequencer.env.wait_rx_pcs_ready();
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //p_sequencer.env.mac_cfg.mac_expected_maximum_frame_length = 20000;
          
          //Extra Check. Set the bit 0 of CNTR_CONFIG register and wait for CNTR_STATUS bit 1 to clear stat counters 
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "Extra Check. Clear Stat Counters", UVM_NONE)
          //clear_stat_counters();
          //#400ns;
          
          ////Step 2: Read MCAST_CTRL_ERR and MCAST_CTRL_OK  registers.
          //`uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "2. Read MCAST CTRL ERR & OK registers.", UVM_NONE)
          //read_and_compare_destination_address_regs();
          
          //Step 3:Send one multicast control frame with FCS error and without FCS randomly.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "3. Send MCAST Control frame with an FCS error or without an FCS Error randomly.", UVM_NONE)
          fork 
          begin
               randcase 
                    1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with fcs RX
                    1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
               endcase
               frame_num_rx++;
               `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("3. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
          end
          begin
               randcase 
                    1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
                    1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
               endcase
               frame_num_tx++;
               `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("3. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
          end
          join
          //Step 4:Read MCAST_CTRL_ERR and MCAST_CTRL_OK  counter registers.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "4. Read MCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 5:Repeat step 3 and step 4 five to ten time to ensure MCAST_CTRL_ERR and MCAST_CTRL_OK counters increment by 1.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "5. Send MCAST Control frame with an FCS error or without an FCS Error randomly multiple times.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control Frame with FCS error RX
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("5. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("5. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "5. Read MCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          
          //Step 6:Send some multicast control and normal data frames without fcs error and Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "6. Send MCAST Control frame & data frame without an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,ETH_VIP_AVL_RX);//Data Frame RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("6. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//Data Frame RX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("6. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "6. Read MCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 7:Send some multicast control and normal data frames with fcs error and Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "7. Send MCAST Control frame & data frame with an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with FCS error RX
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//Data frame with FCS error RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("7. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with FCS error TX
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//Data frame with FCS error TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("7. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "7. Read MCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 8:Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "8. Send BCAST/UCAST/MCAST Control frame & data frame with an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               std::randomize(eth_frame) with {eth_frame inside {BCAST_CTRL_FRAME,BCAST_DATA_FRAME,UCAST_CTRL_FRAME,UCAST_DATA_FRAME,MCAST_CTRL_FRAME,MCAST_DATA_FRAME};};
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,eth_frame,ETH_VIP_AVL_RX,-1);//Control/Data Frame with fcs RX
                         1: send_eth_frame_with_fix_size(eth_frame,64,1,ETH_VIP_AVL_RX);//Control/Data frame without fcs RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("8. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,eth_frame,AVL_TX_ETH_VIP,-1);//Control/Data frame with FCS TX
                         1: send_eth_frame_with_fix_size(eth_frame,64,1,AVL_TX_ETH_VIP);//Control/Data frame without fcs TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", $sformatf("8. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          //Step 9:Read MCAST_CTRL_ERR and MCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "9. Read MCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          
          `uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "Ended eth1025_stat_mcast_ctrl_cnt_sequence...", UVM_NONE)
     endtask:body

endclass:eth1025_stat_mcast_ctrl_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_ucast_ctrl_cnt_sequence
// Descriptions:
//   1. Apply csr reset.
//   2. Read UCAST_CTRL_ERR and UCAST_CTRL_OK  registers.
//   3. Send one multicast control frame with FCS error and without FCS randomly.
//   4. Read UCAST_CTRL_ERR and UCAST_CTRL_OK  counter registers.
//   5. Repeat step 3 and step 4 five to ten time to ensure UCAST_CTRL_ERR and UCAST_CTRL_OK counters increment by 1.
//   6. Send some multicast control and normal data frames without fcs error and Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
//   7. Send some multicast control and normal data frames with fcs error and Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
//   8. Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
//   9. Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
//   10. Send random control frames such that read value of UCAST_CTRL_ERR and UCAST_CTRL_OK  counter status register rollover from 32 bit value to 33 bit value  and read UCAST_CTRL_ERR and UCAST_CTRL_OK  registers after each frame.
//   11. Send random frames such that read value of UCAST_CTRL_ERR and UCAST_CTRL_OK  counter status register reaches to maximum value  
//   12. Read UCAST_CTRL_ERR and UCAST_CTRL_OK counter register
//   13. Send random multicast, unicast and broadcast   frames after UCAST_CTRL_ERR and UCAST_CTRL_OK  counter reaches to maximum value.
//   14. Read UCAST_CTRL_ERR and UCAST_CTRL_OK counter register to make sure counter does not rollover.
//   15. Read all stats counter registers
//Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_ucast_ctrl_cnt_sequence extends eth1025_stat_base_sequence;
     frame_type eth_frame;
     int frame_num_rx=0;
     int frame_num_tx=0;
     
     `uvm_object_utils(eth1025_stat_ucast_ctrl_cnt_sequence)
     
     function new(string name = "eth1025_stat_ucast_ctrl_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "Started eth1025_stat_ucast_ctrl_cnt_sequence...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();          
          
          //Enable vector scoreboard
          //en_vec_sb();
          ////Step 1: Apply csr reset.
          //`uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //`uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
          //p_sequencer.env.wait_rx_pcs_ready();
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Extra Check. Set the bit 0 of CNTR_CONFIG register and wait for CNTR_STATUS bit 1 to clear stat counters 
          //`uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "Extra Check. Clear Stat Counters", UVM_NONE)
          //clear_stat_counters();
          //#400ns;
          
          ////Step 2: Read UCAST_CTRL_ERR and UCAST_CTRL_OK  registers.
          //`uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "2. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
          //read_and_compare_destination_address_regs();
          
          //Step 3:Send one multicast control frame with FCS error and without FCS randomly.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "3. Send UCAST Control frame with an FCS error or without an FCS Error randomly.", UVM_NONE)
          fork 
          begin
               randcase 
                    1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with fcs RX
                    1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
               endcase
               frame_num_rx++;
               `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("3. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
          end
          begin
               randcase 
                    1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
                    1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
               endcase
               frame_num_tx++;
               `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("3. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
          end
          join
          //Step 4:Read UCAST_CTRL_ERR and UCAST_CTRL_OK  counter registers.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "4. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 5:Repeat step 3 and step 4 five to ten time to ensure UCAST_CTRL_ERR and UCAST_CTRL_OK counters increment by 1.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "5. Send UCAST Control frame with an FCS error or without an FCS Error randomly multiple times.", UVM_NONE)
          repeat(num_of_frames/4) 
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control Frame with FCS error RX
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("5. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("5. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "5. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 6:Send some multicast control and normal data frames without fcs error and Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "6. Send UCAST Control frame & data frame without an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,ETH_VIP_AVL_RX);//Data Frame RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("6. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//Data Frame RX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("6. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "6. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 7:Send some multicast control and normal data frames with fcs error and Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "7. Send UCAST Control frame & data frame with an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with FCS error RX
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//Data frame with FCS error RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("7. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with FCS error TX
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//Data frame with FCS error TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("7. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "7. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 8:Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "8. Send BCAST/UCAST/MCAST Control frame & data frame with an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               std::randomize(eth_frame) with {eth_frame inside {BCAST_CTRL_FRAME,BCAST_DATA_FRAME,UCAST_CTRL_FRAME,UCAST_DATA_FRAME,MCAST_CTRL_FRAME,MCAST_DATA_FRAME};};
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,eth_frame,ETH_VIP_AVL_RX,-1);//Control/Data Frame with fcs RX
                         1: send_eth_frame_with_fix_size(eth_frame,64,1,ETH_VIP_AVL_RX);//Control/Data frame without fcs RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("8. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,eth_frame,AVL_TX_ETH_VIP,-1);//Control/Data frame with FCS TX
                         1: send_eth_frame_with_fix_size(eth_frame,64,1,AVL_TX_ETH_VIP);//Control/Data frame without fcs TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", $sformatf("8. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          //Step 9:Read UCAST_CTRL_ERR and UCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "9. Read UCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          
          `uvm_info("eth1025_stat_ucast_ctrl_cnt_sequence", "Ended eth1025_stat_ucast_ctrl_cnt_sequence...", UVM_NONE)
     endtask:body

endclass:eth1025_stat_ucast_ctrl_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_bcast_ctrl_cnt_sequence
// Descriptions:
//   1. Apply csr reset.
//   2. Read BCAST_CTRL_ERR and BCAST_CTRL_OK  registers.
//   3. Send one multicast control frame with FCS error and without FCS randomly.
//   4. Read BCAST_CTRL_ERR and BCAST_CTRL_OK  counter registers.
//   5. Repeat step 3 and step 4 five to ten time to ensure BCAST_CTRL_ERR and BCAST_CTRL_OK counters increment by 1.
//   6. Send some multicast control and normal data frames without fcs error and Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
//   7. Send some multicast control and normal data frames with fcs error and Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
//   8. Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
//   9. Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
//   10. Send random control frames such that read value of BCAST_CTRL_ERR and BCAST_CTRL_OK  counter status register rollover from 32 bit value to 33 bit value  and read BCAST_CTRL_ERR and BCAST_CTRL_OK  registers after each frame.
//   11. Send random frames such that read value of BCAST_CTRL_ERR and BCAST_CTRL_OK  counter status register reaches to maximum value  
//   12. Read BCAST_CTRL_ERR and BCAST_CTRL_OK counter register
//   13. Send random multicast, unicast and broadcast   frames after BCAST_CTRL_ERR and BCAST_CTRL_OK  counter reaches to maximum value.
//   14. Read BCAST_CTRL_ERR and BCAST_CTRL_OK counter register to make sure counter does not rollover.
//   15. Read all stats counter registers
//Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_bcast_ctrl_cnt_sequence extends eth1025_stat_base_sequence;
     frame_type eth_frame;
     int frame_num_rx=0;
     int frame_num_tx=0;
     
     `uvm_object_utils(eth1025_stat_bcast_ctrl_cnt_sequence)
     
     function new(string name = "eth1025_stat_bcast_ctrl_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "Started eth1025_stat_bcast_ctrl_cnt_sequence...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //Enable vector scoreboard
          //en_vec_sb();
          ////Step 1: Apply csr reset.
          //`uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //`uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
          //p_sequencer.env.wait_rx_pcs_ready();
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Extra Check. Set the bit 0 of CNTR_CONFIG register and wait for CNTR_STATUS bit 1 to clear stat counters 
          //`uvm_info("eth1025_stat_mcast_ctrl_cnt_sequence", "Extra Check. Clear Stat Counters", UVM_NONE)
          //clear_stat_counters();
          //#400ns;
          
          ////Step 2: Read BCAST_CTRL_ERR and BCAST_CTRL_OK  registers.
          //`uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "2. Read BCAST CTRL ERR & OK registers.", UVM_NONE)
          //read_and_compare_destination_address_regs();
          
          //Step 3:Send one multicast control frame with FCS error and without FCS randomly.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "3. Send BCAST Control frame with an FCS error or without an FCS Error randomly.", UVM_NONE)
          fork 
          begin
               randcase 
                    1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with fcs RX
                    1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
               endcase
               frame_num_rx++;
               `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("3. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
          end
          begin
               randcase 
                    1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
                    1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
               endcase
               frame_num_tx++;
               `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("3. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
          end
          join
          //Step 4:Read BCAST_CTRL_ERR and BCAST_CTRL_OK  counter registers.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "4. Read BCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 5:Repeat step 3 and step 4 five to ten time to ensure BCAST_CTRL_ERR and BCAST_CTRL_OK counters increment by 1.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "5. Send BCAST Control frame with an FCS error or without an FCS Error randomly multiple times.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control Frame with FCS error RX
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("5. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with fcs TX
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("5. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "5. Read BCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 6:Send some multicast control and normal data frames without fcs error and Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "6. Send BCAST Control frame & data frame without an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//Control frame without fcs RX
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,ETH_VIP_AVL_RX);//Data Frame RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("6. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//Data Frame RX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("6. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "6. Read BCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 7:Send some multicast control and normal data frames with fcs error and Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "7. Send BCAST Control frame & data frame with an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//Control frame with FCS error RX
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//Data frame with FCS error RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("7. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//Control frame with FCS error TX
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//Data frame with FCS error TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("7. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "7. Read BCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();
          
          //Step 8:Send random (i.e multicast,unicast,broadcast) control and data frames with FCS error or without FCS error.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "8. Send BCAST/UCAST/MCAST Control frame & data frame with an FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4)
          begin
               std::randomize(eth_frame) with {eth_frame inside {BCAST_CTRL_FRAME,BCAST_DATA_FRAME,UCAST_CTRL_FRAME,UCAST_DATA_FRAME,MCAST_CTRL_FRAME,MCAST_DATA_FRAME};};
               fork 
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,eth_frame,ETH_VIP_AVL_RX,-1);//Control/Data Frame with fcs RX
                         1: send_eth_frame_with_fix_size(eth_frame,64,1,ETH_VIP_AVL_RX);//Control/Data frame without fcs RX
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("8. frame_num_rx=%0d", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase 
                         1: send_eth_frame_with_fcs_error(1,eth_frame,AVL_TX_ETH_VIP,-1);//Control/Data frame with FCS TX
                         1: send_eth_frame_with_fix_size(eth_frame,64,1,AVL_TX_ETH_VIP);//Control/Data frame without fcs TX
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", $sformatf("8. frame_num_tx=%0d", frame_num_tx), UVM_LOW)
               end
               join
          end//repeat
          //Step 9:Read BCAST_CTRL_ERR and BCAST_CTRL_OK registers.
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "9. Read BCAST CTRL ERR & OK registers.", UVM_NONE)
          read_and_compare_destination_address_regs();          
          
          `uvm_info("eth1025_stat_bcast_ctrl_cnt_sequence", "Ended eth1025_stat_bcast_ctrl_cnt_sequence...", UVM_NONE)
     endtask:body

endclass:eth1025_stat_bcast_ctrl_cnt_sequence


//*******************************************************************************
// Sequence Name: eth1025_stat_mcastdata_cnt_sequence
// Descriptions:
// 1. Apply csr reset.
// 2.Read MCAST_DATA_OK and MCAST_DATA_ERR registers.
// 3. Send one multicast frame with FCS error or without FCS Error randomly (i.e oversize,undersize,normal)
// 4. Read MCAST_DATA_OK and MCAST_DATA_ERR counter registers
// 5. Repeat step 3 and step 4 five to ten times to ensure MCAST_DATA_OK and MCAST_DATA_ERR counters increment by 1.
// 6. Send some multicast frames without fcs error (i.e oversize,undersize,normal, control frames) and Read MCAST_DATA_OK and MCAST_DATA_ERR register
// 7. Send some multicast frames with fcs error (i.e oversize,undersize,normal, control frames) and Read MCAST_DATA_OK and MCAST_DATA_ERR register
// 8. Send random multicast, unicast and broadcast   frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error, control frames with and without fcs error)
// 9. Read MCAST_DATA_OK and MCAST_DATA_ERR  register
// 10. Send random frames such that read value of MCAST_DATA_OK and MCAST_DATA_ERR  counter status register rollover from 32 bit value to 33 bit value consecutively and read MCAST_DATA_OK and MCAST_DATA_ERR register after each frame.
// 11. Send random frames such that read value of MCAST_DATA_OK and MCAST_DATA_ERR counter status register reaches to maximum value  
// 12.Read MCAST_DATA_OK and MCAST_DATA_ERR  counter register
// 13. Send random multicast, unicast and broadcast   frames after MCAST_DATA_OK and MCAST_DATA_ERR counter reaches to maximum value.
// 14. Read MCAST_DATA_OK and MCAST_DATA_ERR counter register to make sure counter does not rollover.
// 15. Read all stats counter registers
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
// 
// PS : 
// 1 ) Before step 10/11, test may force the counter value near to max value or expected value to avoid large frame transfer.
//*******************************************************************************
class eth1025_stat_mcastdata_cnt_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_mcastdata_cnt_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "seq_0");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_mcastdata_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //en_vec_sb();
          ////1. Apply csr reset.
          //`uvm_info("eth1025_stat_mcastdata_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //rx_crc_pass=$urandom;
          //p_sequencer.env.wait_rx_pcs_ready();
          //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //$display("DONE!!! WRITING TO REG rx_crc_pass = %0b",rx_crc_pass);
          
          ////2. Read mcast stats counter register 
          //`uvm_info("eth1025_stat_mcastdata_cnt_sequence", "2. Read all stats counter register", UVM_NONE)
          //clear_stat_counters();
          //#400ns;
          //read_and_compare_destination_address_regs();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE); 
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Read register to get max_frame_size
          //read_max_frame_size();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(9601,9610),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
                         1: send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(9601,9610),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//normal frame with fcs
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//normal frame with fcs
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          send_random_frames(10);
          read_and_compare_destination_address_regs();
          
          //Force register to maximum value (rollover): TODO
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(9601,9610),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
                         1: send_eth_frame(MCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,$urandom_range(9601,9610),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(MCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
                         1: send_eth_frame_with_fix_size(MCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//control frame without fcs
                    endcase
               end
               join
          end
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//normal frame with fcs
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,MCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,MCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//normal frame with fcs
                    endcase
               end
               join
          end
          send_random_frames(10);
          #800ns; // To make sure all the frames are processed in DUT/Ref. model.
     
     endtask
     
     //`ifdef UVM_VERSION_1_1
     // virtual task post_start();
     //  if ((get_parent_sequence() == null) && (starting_phase != null))
     //    starting_phase.phase_done.set_drain_time(this, 2us);
     //    read_1025_stats();
     //    starting_phase.drop_objection(this, "Ending");
     //endtask:post_start
     //`endif

endclass : eth1025_stat_mcastdata_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_bcastdata_cnt_sequence
// Descriptions: Same steps as eth1025_stat_mcastdata_cnt_sequence
//               but for broadcast data frames
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_bcastdata_cnt_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_bcastdata_cnt_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "seq_0");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_bcastdata_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //en_vec_sb();
          ////1. Apply csr reset.
          //`uvm_info("eth1025_stat_bcastdata_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //rx_crc_pass=$urandom;
          //p_sequencer.env.wait_rx_pcs_ready();
          //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //$display("DONE!!! WRITING TO REG rx_crc_pass = %0b",rx_crc_pass);
          
          ////2. Read bcast stats counter register 
          //`uvm_info("eth1025_stat_bcastdata_cnt_sequence", "2. Read all stats counter register", UVM_NONE)
          //clear_stat_counters();
          //#400ns;
          //read_and_compare_destination_address_regs();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Read register to get max_frame_size
          //read_max_frame_size();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame(BCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(9601,9610),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
                         1: send_eth_frame(BCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(9601,9610),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//normal frame with fcs
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//normal frame with fcs
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          send_random_frames(10);
          read_and_compare_destination_address_regs();
          
          //Force register to maximum value (rollover): TODO
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(9601,9610),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
                         1: send_eth_frame(BCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,$urandom_range(9601,9610),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(BCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
                         1: send_eth_frame_with_fix_size(BCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//normal frame with fcs
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,BCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,BCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//normal frame with fcs
                    endcase
               end
               join
          end
          
          send_random_frames(10);
          #800ns; // To make sure all the frames are processed in DUT/Ref. model.
     
     endtask
     //`ifdef UVM_VERSION_1_1
     // virtual task post_start();
     //  if ((get_parent_sequence() == null) && (starting_phase != null))
     //    starting_phase.phase_done.set_drain_time(this, 2us);
     //    read_1025_stats();
     //    starting_phase.drop_objection(this, "Ending");
     //endtask:post_start
     //`endif

endclass : eth1025_stat_bcastdata_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_bcastdata_cnt_sequence
// Descriptions: Same steps as eth1025_stat_mcastdata_cnt_sequence
//               but for unicast data frames
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_ucastdata_cnt_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_ucastdata_cnt_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "eth1025_stat_ucastdata_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     if (!($value$plusargs("num_frames=%d",transaction_count))) begin
          transaction_count = 100;
     end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_ucastdata_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //en_vec_sb();
          ////1. Apply csr reset.
          //`uvm_info("eth1025_stat_ucastdata_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //rx_crc_pass=$urandom;
          //p_sequencer.env.wait_rx_pcs_ready();
          //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //$display("DONE!!! WRITING TO REG rx_crc_pass = %0b",rx_crc_pass);
          
          ////2. Read ucast stats counter register 
          //`uvm_info("eth1025_stat_ucastdata_cnt_sequence", "2. Read all stats counter register", UVM_NONE)
          //clear_stat_counters();
          //#400ns;
          //read_and_compare_destination_address_regs();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Read register to get max_frame_size
          //read_max_frame_size();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame(UCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs // Fixme : undersize range should be 27->63
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(9601,9610),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
                         1: send_eth_frame(UCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(9601,9610),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//good frame
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//normal frame with fcs
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//normal frame with fcs
                    endcase
               end
               join
          end
          read_and_compare_destination_address_regs();
          
          send_random_frames(10);
          read_and_compare_destination_address_regs();
          
          //Force register to maximum value (rollover): TODO
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(46,63),1,ETH_VIP_AVL_RX);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(9601,9610),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,ETH_VIP_AVL_RX);//control frame without fcs
                         1: send_eth_frame(UCAST_DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(27,63),1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,$urandom_range(9601,9610),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(UCAST_CTRL_FRAME,64,1,AVL_TX_ETH_VIP);//control frame without fcs
                         1: send_eth_frame_with_fix_size(UCAST_DATA_FRAME,-1,1,AVL_TX_ETH_VIP);//good frame
                    endcase
               end
               join
          end
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,ETH_VIP_AVL_RX,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,ETH_VIP_AVL_RX,-1);//normal frame with fcs
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(27,63));//undersize frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(9601,9610));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,UCAST_CTRL_FRAME,AVL_TX_ETH_VIP,-1);//control frame with fcs
                         1: send_eth_frame_with_fcs_error(1,UCAST_DATA_FRAME,AVL_TX_ETH_VIP,-1);//normal frame with fcs
                    endcase
               end
               join
          end
          send_random_frames(10);
          #800ns; // To make sure all the frames are processed in DUT/Ref. model.
     
     endtask
     //`ifdef UVM_VERSION_1_1
     // virtual task post_start();
     //  if ((get_parent_sequence() == null) && (starting_phase != null))
     //    starting_phase.phase_done.set_drain_time(this, 2us);
     //    read_1025_stats();
     //    starting_phase.drop_objection(this, "Ending");
     //endtask:post_start
     //`endif

endclass : eth1025_stat_ucastdata_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_shadowcopy_sequence
// Descriptions: 
//Class : eth1025_stat_shadowcopy_sequence
//1. Apply csr reset.
//2. Read all stats counter registers.
//3. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//4. Read all stats counter registers.
//5. Send random frames such that all stats counts have non reset value.
//6. Read all stats counter register.
//7. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
//8. Read all stats counter registers.
//9. Send random frames such that all stats counts have different value compare to step 5.
//10. Read all stats counter registers.
//11. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//12. Read all stats counter registers.
//13. Send random frames such that all stats counts have non reset value.
//14. Read all stats counter register.
//15. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
//16. Read all stats counter registers.
//17. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
//18. Send random frames such that all stats counts have non reset value.
//19. Read all stats counter registers.
//20. Set CNTR_CONFIG bit 0 to clear the stat counter.
//21. Read all stats counter registers. (?) 
//22. Send random frames such that all stats counts have non reset value.
//23. Read all stats counter registers.(?)
//24. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
//25. Read all stats counter registers.(?)
//*********************************************************************************
class eth1025_stat_shadowcopy_sequence_part_1 extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_shadowcopy_sequence_part_1)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_shadowcopy_sequence_part_1");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_shadowcopy_sequence_part_1 ...", UVM_NONE)
          super.body();
          ////Enable vector scoreboard
          //en_vec_sb();
          
          ////1. Apply csr reset.
          //`uvm_info("eth1025_stat_shadowcopy_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //p_sequencer.env.wait_rx_pcs_ready();
          
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = num_of_frames/6;
          end
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          
          //Read register to get max_frame_size
          read_max_frame_size();
          
          //2. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "2. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //3. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "3. Apply Shadow Request", UVM_NONE)
          apply_shadow_request();
          
          #100ns;
          //4. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "4. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //5. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "5. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_random_frames(transaction_count);
          
          #800ns;
          //6. Read all stats counter register .
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "6. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //7. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "7. Clear Shadow Request", UVM_NONE)
          clear_shadow_request();
          
          #100ns;
          //8. Read all stats counter register .
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "8. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //9. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "9. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_random_frames(transaction_count);
          
          #800ns;
          //10. Read all stats counter register .
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "10. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //11. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "11. Apply Shadow Request", UVM_NONE)
          apply_shadow_request();
          
          #100ns;
          //12. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "12. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //13. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "13. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_random_frames(transaction_count);
          
          #800ns;
          //14. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "14. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //15. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "15. Clear Shadow Request", UVM_NONE)
          clear_shadow_request();
          
          #100ns;
          //16. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_1", "16. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          `uvm_info("body", "ended eth1025_stat_shadowcopy_sequence ...", UVM_NONE)
     endtask:body

endclass:eth1025_stat_shadowcopy_sequence_part_1

class eth1025_stat_shadowcopy_sequence_part_2 extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_shadowcopy_sequence_part_2)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_shadowcopy_sequence_part_2");
     super.new(name);
     `ifdef UVM_POST_VERSION_1_1
          set_automatic_phase_objection(1);
     `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_shadowcopy_sequence_part_2 ...", UVM_NONE)
          super.body();
          ////Enable vector scoreboard
          //en_vec_sb();
          
          ////1. Apply csr reset.
          //`uvm_info("eth1025_stat_shadowcopy_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //p_sequencer.env.wait_rx_pcs_ready();
          
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = num_of_frames/6;
          end
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          
          //Read register to get max_frame_size
          read_max_frame_size();
          
          //2. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "2. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //17. Set the bit 2 of CNTR_CONFIG register and wait for  CNTR_STATUS bit 1 to accept the shadow request.
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "17. Apply Shadow Request", UVM_NONE)
          apply_shadow_request();
          
          //18. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "18. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_random_frames(transaction_count);
          
          #800ns;
          //19. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "19. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //20. Set CNTR_CONFIG bit 1 to clear the counter. 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "20. Set CNTR_CONFIG bit 0 to clear the stat counter.", UVM_NONE)
          clear_stat_counters(); 
          #400ns;
          
          //21. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "21. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //22. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "22. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_random_frames(transaction_count);
          
          #800ns;
          //23. Read all stats counter register 
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "23. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //24. Clear shadow register request and wait CNTR_STATUS bit 1 to accept.
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "24. Clear Shadow Request", UVM_NONE)
          clear_shadow_request();
          
          #0;
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "24.1. Read all stats counter register", UVM_NONE)
          read_1025_stats();
          
          //25. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_shadowcopy_sequence_part_2", "25. Send random frames such that all stats counts have non reset value", UVM_NONE)
          send_random_frames(transaction_count);
          #800ns;
          
          //25. Read all stats counter register 
          //`uvm_info("eth1025_stat_shadowcopy_sequence", "25. Read all stats counter register", UVM_NONE)
          //read_1025_stats();
          
          `uvm_info("body", "ended eth1025_stat_shadowcopy_sequence_part_2 ...", UVM_NONE)
     endtask:body

endclass:eth1025_stat_shadowcopy_sequence_part_2


//*******************************************************************************
// Sequence Name: eth1025_stat_oversize_cnt_sequence
// Descriptions:
// 1. Apply csr reset.
// 2.Read OVERSIZE register and configure MAX PAYLOAD SIZE register with random value.
// 3. Send one oversize frame with FCS error 
// or without FCS Error randomly.
// 4. Read OVERSIZE counter register
// 5. Repeat step 3 and step 4 five to ten time to ensure OVERSIZE counter increments by 1.
// 6. Send some oversize frames (>MAX PAYLAOD SIZE and MAXPAYLOADSIZE+1) without/without FCS error and Read OVERSIZE register.
// 7. Send some non oversize frame (< MAX PAYLAOD SIZE and = MAXPAYLAOD SIZE ) with and without FCS error 
// 8. Read OVERSIZE register 
// 9. Configure MAX PAYLOAD SIZE register with other than step 2 value.
// 10. Send random  frame (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error)
// 11. Read OVERSIZE register
// 12. Send random frames such that read value of OVERSIZE counter status register rollover from 32 bit value to 33 bit value  and read OVERSIZE register after each frame.
// 13. Send random frames such that read value of OVERSIZE counter status register reaches to maximum value  
// 14.Read OVERSIZE counter register
// 15. Send random frames after OVERSIZE counter reaches to maximum value.
// 16. Read OVERSIZE counter register to make sure counter does not rollover.
// 17. Read all stats counter registers
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
// 
// PS : 
// 1 ) Before step 12/13, test may force the counter value near to max value or expected value to avoid large frame transfer.
// 2) configure the MAX PAYLOAD SIZE register to determine the oversize criteria. cover the max,min,default and random value of these registers
//*******************************************************************************
class eth1025_stat_oversize_cnt_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_oversize_cnt_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "eth1025_stat_oversize_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_oversize_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          // en_vec_sb();
          // //1. Apply csr reset.
          // `uvm_info("eth1025_stat_oversize_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          // apply_hard_reset(0,0,1,11);
          // rx_crc_pass=$urandom;
          // p_sequencer.env.wait_rx_pcs_ready();
          // reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          // $display("DONE!!! WRITING TO REG rx_crc_pass = %0b",rx_crc_pass);
          //clear_stat_counters();
          //#400ns;
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          tx_max_frame_size = $urandom_range(9500,10000);
          rx_max_frame_size = $urandom_range(9500,10000);
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
          $display("tx_max_frame_size = %0d , rx_max_frame_size",tx_max_frame_size,rx_max_frame_size);
          
          fork
          begin
               randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                    1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                    1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10));//oversize frame with fcs: TODO
               endcase
          end
          begin
               randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                    1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                    1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10));//oversize frame with fcs: TODO
               endcase
          end
          join
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10));//oversize frame with fcs: TODO
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10));//oversize frame with fcs: TODO
                    endcase
               end
               join
          end
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size+1,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size+1);//oversize frame with fcs: TODO
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size+1,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size+1);//oversize frame with fcs: TODO
                    endcase
               end
               join
          end
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size-50,rx_max_frame_size-1),1,ETH_VIP_AVL_RX);//frame size < oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size-50,rx_max_frame_size-1));//frame size < oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size);//oversize frame with fcs: TODO
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size-50,tx_max_frame_size-1),1,AVL_TX_ETH_VIP);//frame size < oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size-50,tx_max_frame_size-1));//frame size < oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size);//oversize frame with fcs: TODO
                    endcase
               end
               join
          end
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          tx_max_frame_size = $urandom_range(1501,1536);
          rx_max_frame_size = $urandom_range(1501,1536);
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size+1,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size+1);//oversize frame with fcs: TODO
                         1: send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size+1,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size+1);//oversize frame with fcs: TODO
                         1: send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
                    endcase
               end
               join
          end
          
          //Force oversize stats register to max value : TODO
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size+1,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size+1);//oversize frame with fcs: TODO
                         1: send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    endcase
               end
               begin
                    randcase//Tx path 
                    //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size+1,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size+1);//oversize frame with fcs: TODO
                         1: send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
                    endcase
               end
               join
          end
          #900ns;
     
     endtask
     //`ifdef UVM_VERSION_1_1
     //   virtual task post_start();
     //    if ((get_parent_sequence() == null) && (starting_phase != null))
     //      starting_phase.phase_done.set_drain_time(this, 2us);
     //      read_1025_stats();
     //      starting_phase.drop_objection(this, "Ending");
     //  endtask:post_start
     //`endif
endclass : eth1025_stat_oversize_cnt_sequence


//*******************************************************************************
// Sequence Name: eth1025_stat_octetsok_cnt_sequence
// Descriptions:
// 1. Apply csr reset.
// 2. Read PayloadOctetsOK and FrameOctetsOK registers.
// 3. Send normal , oversize data or control frames without an  Error.
// 4. Read PayloadOctetsOK and FrameOctetsOK counter registers
// 5. Repeat step 3 and step 4 five to ten time to ensure PayloadOctetsOK and FrameOctetsOK counters increments cumulatively.
// 6. Send undersize frames without an error and Read PayloadOctetsOK and FrameOctetsOK counter registers.
// 7. Send undersize , normal and oversize frames with FCS Error and Read PayloadOctetsOK and FrameOctetsOK counter registers.
// 8. Send control frames and read PayloadOctetsOK and FrameOctetsOK counter registers after each frame.
// 9. Send random frames such that read value of PayloadOctetsOK and FrameOctetsOK counters status register rollover from 32 bit value to 33 bit value  and read PayloadOctetsOK and FrameOctetsOK registers after each frame.
// 10. Send random frames such that read value of PayloadOctetsOK and FrameOctetsOK counter status registers reach to maximum value  
// 11.Read PayloadOctetsOK and FrameOctetsOK counter registers.
// 12. Send undersize and normal with and without FCS Error randomly after PayloadOctetsOK and FrameOctetsOK counter reaches to maximum value.
// 13. Read PayloadOctetsOK and FrameOctetsOK counter register to make sure counter does not rollover.
// 14. Read all stats counter registers
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
// 
// PS : before step 10/9, test may force the counter value near to max value or expected value to avoid large frame transfer.
// 
// Question : will all undersize frame generate FCS errors ?
//*******************************************************************************
class eth1025_stat_octetsok_cnt_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_octetsok_cnt_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "eth1025_stat_octetsok_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_stat_octetsok_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();
          
          //en_vec_sb();
          ////1. Apply csr reset.
          //`uvm_info("eth1025_stat_octetsok_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //rx_crc_pass=$urandom;
          //p_sequencer.env.wait_rx_pcs_ready();
          //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
          //$display("DONE!!! WRITING TO REG rx_crc_pass = %0b",rx_crc_pass);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //clear_stat_counters();
          //#400ns;
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          //reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          tx_max_frame_size = $urandom_range(9500,10000);
          rx_max_frame_size = $urandom_range(9500,10000);
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
               $display("tx_max_frame_size = %0d , rx_max_frame_size",tx_max_frame_size,rx_max_frame_size);
          
          fork
          begin
               randcase//Rx path 
               //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                    1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                    1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10));//oversize frame with fcs: TODO
                    1: send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                    1: send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);//Control frame without fcs RX
               endcase
          end
          begin
               randcase//Tx path 
               //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                    1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                    1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10));//oversize frame with fcs: TODO
                    1: send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
                    1: send_eth_frame_with_fix_size(CONTROL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
               endcase
          end
          join
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+1,rx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX,-1);
                         1: send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+1,tx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);
                         1: send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
                    endcase
               end
               join
          end
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size+1,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size+1);//oversize frame with fcs: TODO
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size+1,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size+1);//oversize frame with fcs: TODO
                    endcase
               end
               join
          end
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);//Control frame without fcs RX
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(CONTROL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                    endcase
               end
               join
          end
          #900ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          //Force oversize stats register to max value : TODO
          
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10),1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,rx_max_frame_size+1,1,ETH_VIP_AVL_RX);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(rx_max_frame_size+2,rx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size+1);//oversize frame with fcs: TODO
                         1: send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,1);//good frame
                         1: send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);//Control frame without fcs RX
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10),1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fix_size(DATA_FRAME,tx_max_frame_size+1,1,AVL_TX_ETH_VIP);//oversize frame without fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(tx_max_frame_size+2,tx_max_frame_size+10));//oversize frame with fcs: TODO
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size+1);//oversize frame with fcs: TODO
                         1: send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
                         1: send_eth_frame_with_fix_size(CONTROL_FRAME,64,1,AVL_TX_ETH_VIP);//Control frame without fcs TX
                    endcase
               end
               join
          end
          #900ns;

     endtask
//`ifdef UVM_VERSION_1_1
//   virtual task post_start();
//    if ((get_parent_sequence() == null) && (starting_phase != null))
//      starting_phase.phase_done.set_drain_time(this, 2us);
//      read_1025_stats();
//      starting_phase.drop_objection(this, "Ending");
//  endtask:post_start
//`endif
endclass : eth1025_stat_octetsok_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_crcerrokpkt_cnt_sequence
// Descriptions: 
// 1. Apply csr reset.
// 2. Read CRCERR_OKPKT register.
// 3. Send one normal frame (frame size >= 64) with FCS error 
// 4. Read CRCERR_OKPKT counter register
// 5. Repeat step 3 and step 4 five to ten time to ensure CRCERR_OKPKT counter increments by 1.
// 6. Send some frames without FCS error (i.e oversize, normal). 
// 7. Read FCSERR register
// 8. Send random  frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)
// 9. Read FCSERR register
// 10. Send random frames such that read value of CRCERR_OKPKT counter status register rollover from 32 bit value to 33 bit value  and read CRCERR_OKPKT register after each frame.
// 11. Send random frames such that read value of CRCERR_OKPKT counter status register reaches to maximum value  
// 12. Read CRCERR_OKPKT counter register
// 13. Send random frames after CRCERR_OKPKT counter reaches to maximum value.
// 14. Read CRCERR_OKPKT counter register to make sure counter does not rollover.
// 15. Read all stats counter registers
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_crcerrokpkt_cnt_sequence extends eth1025_stat_base_sequence;
  
     int frame_size_rx,frame_size_tx;
     int frame_num_tx,frame_num_rx;
     
     `uvm_object_utils(eth1025_stat_crcerrokpkt_cnt_sequence)
     
     function new(string name = "eth1025_stat_crcerrokpkt_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", "Executing eth1025_stat_crcerrokpkt_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();          
          
          //Shabbir- max 500 frames can be completed in 8 hours for this test
          if(num_of_frames>500) begin
               num_of_frames=500;
          end
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Enable vector scoreboard
          //en_vec_sb();
          
          //`uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //p_sequencer.env.wait_rx_pcs_ready();
          //`uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
          
          ////Clearing stat counters
          //clear_stat_counters();
          //#400ns;
          
          ////2. Read CRCERR_OKPKT register and configure MAX PAYLOAD SIZE register with random value.
          //`uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $psprintf("2. Read CRCERR_OKPKT register and configure MAX FRAME SIZE register with random value = %0d",rx_max_frame_size), UVM_NONE)
          //read_registers();
          std::randomize(rx_max_frame_size) with {rx_max_frame_size dist {'d64 := 1, 'd16384 := 1, 'd9600 := 1, ['d64:'d16384] := 7}; };
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
          std::randomize(tx_max_frame_size) with {tx_max_frame_size dist {'d64 := 1, 'd16384 := 1, 'd9600 := 1, ['d64:'d16384] := 7}; };
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          
          `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", "3. Send normal frame (frame size >= 64) with FCS error", UVM_NONE)
          repeat(num_of_frames/3) begin
               fork
               begin
                    send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX);
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $sformatf("RX frame_num=%0d with random frame size and FCS err", frame_num_rx), UVM_LOW)
               end
               begin
                    send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP);
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $sformatf("TX frame_num=%0d with random frame size and FCS err", frame_num_tx), UVM_LOW)
               end
               join	
               read_registers();
          end
          
          `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", "6. Send some frames without FCS error (i.e oversize, normal)", UVM_NONE)
          repeat(num_of_frames/3) begin
               std::randomize(frame_size_tx) with {frame_size_tx dist { [64:tx_max_frame_size] := 1, [tx_max_frame_size+1:tx_max_frame_size+100] := 1};};
               std::randomize(frame_size_rx) with {frame_size_rx dist { [64:rx_max_frame_size] := 1, [rx_max_frame_size+1:rx_max_frame_size+100] := 1};};
               fork
               begin
                    send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX); //oversize/normal
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $sformatf("RX frame_num=%0d, frame size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
               end
               begin
                    send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $sformatf("TX frame_num=%0d, frame size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
               end
               join	
          end
          read_registers();
          
          `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", "8. Send random frames (oversize with FCS Error, oversize without FCS Error, normal frame with FCS and without FCS error, undersize with FCS and without FCS error)", UVM_NONE)
          repeat(num_of_frames/3) begin
               std::randomize(frame_size_tx) with {frame_size_tx dist { [64:tx_max_frame_size] := 1, [tx_max_frame_size+1:tx_max_frame_size+100] := 1};};
               std::randomize(frame_size_rx) with {frame_size_rx dist { [64:rx_max_frame_size] := 1, [rx_max_frame_size+1:rx_max_frame_size+100] := 1};};
               fork
               begin
                    randcase
                         1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX); //oversize/normal
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);//oversize/normal with FCS error
                         1:send_eth_frame(UNDERSIZE_FRAME,ETH_VIP_AVL_RX,1);
                         1:send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,ETH_VIP_AVL_RX);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $sformatf("RX frame_num=%0d random frame", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase
                         1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP); //oversize/normal
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_rx);//oversize/normal with FCS error
                         //1:send_eth_frame(UNDERSIZE_FRAME,AVL_TX_ETH_VIP,1);
                         1:send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);//undersize frame without fcs
                         1:send_eth_frame_with_fcs_error(1,UNDERSIZE_FRAME,AVL_TX_ETH_VIP,-1);//undersize frame with fcs
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_crcerrokpkt_cnt_sequence", $sformatf("TX frame_num=%0d random frame", frame_num_tx), UVM_LOW)
               end
               join	
          end
          read_registers();
          
          //Step 10 to 14 (rollover/force counter) is covered in eth1025_stat_counter_overflow sequence
          
     
     endtask
     
     //`ifdef UVM_VERSION_1_1
     //virtual task post_start();
     //  if ((get_parent_sequence() == null) && (starting_phase != null))
     //    starting_phase.phase_done.set_drain_time(this, 2us);
     //    read_1025_stats();
     //    starting_phase.drop_objection(this, "Ending");
     //endtask:post_start
     //`endif
     
     task read_registers();
          #2000ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask

endclass : eth1025_stat_crcerrokpkt_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_64B_MAXB_cnt_sequence
// Descriptions:
// 1. Apply csr reset.
// 2.Read 64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  register.
// 3. Send one frame from each category stats counters start boundary  (i.e.. 63,64,65,128,256,,512,1024,1519 bytes) byte size. 
// 4.  Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3.
// 5. Send one frame from each category stats counters end boundary  (i.e.. 63,64,127,255,,511,1023,1518 and MAXB bytes) byte size. 
// 6.  Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 5.
// 7. Send some frames from each category stats counters  byte size boundary , have a frame size random between start and end boundary.
// 8. Read  64B,65to127B, 128to255B,256to511B, 512o1023B,1024to1518B,1519toMAXB register.
// 9. Send random frames such that read value of  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  counter status register rollover from 32 bit value to 33 bit value 
// 10.  read  64B, 5to127B, 128to255B, 256to511B, 512o1023B, 1024to1518B,1519toMAXB  register after each frame.
// 11. Send random frames such that read value of  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  counter status register reaches to maximum value  
// 12.Read  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB counter register
// 13. Send random frames after  64B, 65to127B, 128to255B, 256to511B, 512o1023B,1024to1518B,1519toMAXB  counter reaches to maximum value.
// 14. Read  64B,65to127B,128to255B, 256to511B, 512o1023B, 1024to1518B,1519toMAXB counter register to make sure counter does not rollover.
// 15. Read all stats counter registers
// 
// PS : 
// 1 ) Before step 9/11, test may force the counter value near to max value or expected value to avoid large frame transfer.
// 2) include normal, undersize ,oversize and control frames with and without FCS error in step 7 and 9
//*******************************************************************************
class eth1025_stat_64B_MAXB_cnt_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_64B_MAXB_cnt_sequence)
     
     function new(string name = "eth1025_stat_64B_MAXB_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          int rx_rpt_cnt=0;
          int tx_rpt_cnt=0;
          int rx_frame_size=0;
          int tx_frame_size=0;
          `uvm_info("body", "started eth1025_stat_64B_MAXB_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //3. Send one frame from each category stats counters start boundary  (i.e.. 63,64,65,128,256,,512,1024,1519 bytes) byte size. 
          //4. Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3.
          `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", "3. Send one frame from each category stats counters start boundary  (i.e.. 63,64,65,128,256,,512,1024,1519 bytes) byte size. 4. Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3", UVM_NONE)
          send_fix_size_frame(UNDERSIZE_FRAME,1,63);
          #700ns; //572434250 FIXME Shabbir: wait till tx/rx frame is decoded by MAC and stat is updated
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,64);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,65);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,128);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,256);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,512);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,1024);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,1519);
          #700ns;
          read_and_compare_frame_size_reg();
          
          //5. Send one frame from each category stats counters end boundary  (i.e.. 63,64,127,255,,511,1023,1518 and MAXB bytes) byte size. 
          //6.  Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 5.
          `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", "5. Send one frame from each category stats counters end boundary  (i.e.. 63,64,127,255,,511,1023,1518 and MAXB bytes) byte size. 6. Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3", UVM_NONE)
          send_fix_size_frame(UNDERSIZE_FRAME,1,63);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,64);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,127);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,255);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,511);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,1023);
          #700ns;
          read_and_compare_frame_size_reg();
          send_fix_size_frame(RANDOM_FRAME,1,1518);
          #700ns;
          read_and_compare_frame_size_reg();
          fork
          begin//begin1
               `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", $psprintf("RX Frame : RANDOM_FRAME with frame_size=%0d ",rx_max_frame_size), UVM_NONE)
               send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(rx_max_frame_size),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
          end//begin1
          begin//begin2
               `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", $psprintf("TX Frame : RANDOM_FRAME with frame_size=%0d ",tx_max_frame_size), UVM_NONE)
               send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(tx_max_frame_size),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
          end//begin2
          join
          #700ns;
          read_and_compare_frame_size_reg();
          
          //7. Send some frames from each category stats counters  byte size boundary , have a frame size random between start and end boundary.
          //8. Read  64B,65to127B, 128to255B,256to511B, 512o1023B,1024to1518B,1519toMAXB register.
          `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", "7. Send some frames from each category stats counters  byte size boundary , have a frame size random between start and end boundary. 8. Read  64B,65to127B, 128to255B,256to511B, 512o1023B,1024to1518B,1519toMAXB register.", UVM_NONE)
          fork
               send_fix_size_frame(UNDERSIZE_FRAME,num_of_frames/20,63);
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
               send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,64);
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
               send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(65,127));
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
               send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(128,255));
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
               send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(256,511));
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
               send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(512,1023));
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
               send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(1024,1518));
               send_random_frames(num_of_frames/20);
          join
          #700ns;
          read_and_compare_frame_size_reg();
          fork
          begin//begin1
               rx_rpt_cnt=num_of_frames/20;
               repeat (rx_rpt_cnt) begin
                    rx_frame_size=$urandom_range(1519,rx_max_frame_size);
                    `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", $psprintf("RX Frame : RANDOM_FRAME with frame_size=%0d ",rx_frame_size), UVM_NONE)
                    send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(rx_frame_size),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
               end
          end//begin1
          begin//begin2
               tx_rpt_cnt=num_of_frames/20;
               repeat (tx_rpt_cnt) begin
                    tx_frame_size=$urandom_range(1519,tx_max_frame_size);
                    `uvm_info("eth1025_stat_64B_MAXB_cnt_sequence", $psprintf("TX Frame : RANDOM_FRAME with frame_size=%0d ",tx_frame_size), UVM_NONE)
                    send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(tx_frame_size),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
               end
          end//begin2
          begin
               send_random_frames(num_of_frames/20);
          end
          join
          #700ns;
          read_and_compare_frame_size_reg();
          
          
          //Steps 9 to 15 is covered in eth1025_stat_counter_overflow sequence

          //PS : 
          //1 ) Before step 9/11, test may force the counter value near to max value or expected value to avoid large frame transfer.
          //2) include normal, undersize ,oversize and control frames with and without FCS error in step 7 and 9
          
          `uvm_info("body", "ended eth1025_stat_64B_MAXB_cnt_sequence ...", UVM_NONE)
     endtask
     
     task send_fix_size_frame(frame_type f_type = DATA_FRAME,int no_of_frames=1, int frame_size=64);
          repeat (no_of_frames) begin
               fork
               begin//begin1
                    `uvm_info("send_fix_size_frame", $psprintf("RX Frame : %0s with frame_size=%0d ",f_type.name(),frame_size), UVM_NONE)
                    send_eth_frame_with_fix_size(.eth_frame(f_type),.frame_size(frame_size),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
               end//begin1
               begin//begin2
                    `uvm_info("send_fix_size_frame", $psprintf("TX Frame : %0s with frame_size=%0d ",f_type.name(),frame_size), UVM_NONE)
                    send_eth_frame_with_fix_size(.eth_frame(f_type),.frame_size(frame_size),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
               end//begin2
               join
          end//repeat (no_of_frames) begin
     endtask: send_fix_size_frame

endclass:eth1025_stat_64B_MAXB_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_stat_pause_cnt_sequence
// Descriptions: 
// 1. Apply csr reset.
// 2. Read PAUSE_ERR and PAUSE  registers.
// 3. Send one pause control frame with FCS error or without FCS error randomly. 
// 4. Read  PAUSE_ERR and PAUSE  counter registers.
// 5. Repeat step 3 and step 4 five to ten time to ensure  PAUSE_ERR and PAUSE counter increments by 1.
// 6. Send some  control (pause and PFC ) and normal data frames without fcs error and Read  PAUSE_ERR and PAUSE registers.
// 7. Send some  control (pause and PFC ) and normal data frames with fcs error and Read  PAUSE_ERR and PAUSE registers.
// 8. Send random control frames (data , pause and PFC frames)with FCS error or without FCS Error randomly.
// 9. Read  PAUSE_ERR and PAUSE registers
// 10. Send random frames such that read value of  PAUSE_ERR and PAUSE  counter status register rollover from 32 bit value to 33 bit value  and read  PAUSE_ERR and PAUSE  registers after each frame.
// 11. Send random frames such that read value of  PAUSE_ERR and PAUSE  counter status register reaches to maximum value  
// 12. Read  PAUSE_ERR and PAUSE counter registers.
// 13. Send random frames after  PAUSE_ERR and PAUSE  counter reaches to maximum value.
// 14. Read  PAUSE_ERR and PAUSE counter register to make sure counter does not rollover.
// 15. Read all stats counter registers
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_stat_pause_cnt_sequence extends eth1025_stat_base_sequence;
  
     int frame_num_tx,frame_num_rx;
     
     `uvm_object_utils(eth1025_stat_pause_cnt_sequence)
     
     function new(string name = "eth1025_stat_pause_cnt_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
     endfunction:new
     
     virtual task body();
          `uvm_info("eth1025_stat_pause_cnt_sequence", "Executing eth1025_stat_pause_cnt_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();          
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          //Enable vector scoreboard
          //en_vec_sb();
          
          //`uvm_info("eth1025_stat_pause_cnt_sequence", "1. Apply csr reset", UVM_NONE)
          //apply_hard_reset(0,0,1,11);
          //p_sequencer.env.wait_rx_pcs_ready();
          //`uvm_info("eth1025_stat_pause_cnt_sequence", "wait_rx_pcs_ready done ...", UVM_NONE)
          //
          ////Clearing stat counters
          //clear_stat_counters();
          //#400ns;
          
          //`uvm_info("eth1025_stat_pause_cnt_sequence", "2. Read PAUSE_ERR and PAUSE registers", UVM_NONE)
          //read_registers();
          
          `uvm_info("eth1025_stat_pause_cnt_sequence", "3. Send one pause control frame with FCS error or without FCS error randomly.", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase
                         1:send_eth_frame(SFC_FRAME,ETH_VIP_AVL_RX,1);
                         1:send_eth_frame_with_fcs_error(1,SFC_FRAME,ETH_VIP_AVL_RX);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("RX frame_num=%0d, Pause frame with or without FCS error", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase
                         1:send_eth_frame(SFC_FRAME,AVL_TX_ETH_VIP,1);
                         1:send_eth_frame_with_fcs_error(1,SFC_FRAME,AVL_TX_ETH_VIP);
                    endcase 
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("TX frame_num=%0d Pause frame with or without FCS error", frame_num_tx), UVM_LOW)
               end
               join
               read_registers();
          end
          
          `uvm_info("eth1025_stat_pause_cnt_sequence", "6. Send some control (pause and PFC) and normal data frames without fcs error and Read PAUSE_ERR and PAUSE registers", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase
                         1:send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);
                         //1:send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);
                         1:send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("RX frame_num=%0d, Pause/PFC/NORMAL frame without FCS error", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase
                         1:send_eth_frame(CONTROL_FRAME,AVL_TX_ETH_VIP,1);
                         //1:send_eth_frame(PFC_FRAME,AVL_TX_ETH_VIP,1);
                         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("TX frame_num=%0d, Pause/PFC/NORMAL frame without FCS error", frame_num_tx), UVM_LOW)
               end
               join
          end
          read_registers();
          
          `uvm_info("eth1025_stat_pause_cnt_sequence", "7. Send some control (pause and PFC) and normal data frames with fcs error and Read PAUSE_ERR and PAUSE registers", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase
                         1:send_eth_frame_with_fcs_error(1,CONTROL_FRAME,ETH_VIP_AVL_RX);
                         //1:send_eth_frame_with_fcs_error(1,PFC_FRAME,ETH_VIP_AVL_RX);
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("RX frame_num=%0d, Pause/PFC/NORMAL frame with FCS error", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase
                         1:send_eth_frame_with_fcs_error(1,CONTROL_FRAME,AVL_TX_ETH_VIP);
                         //1:send_eth_frame_with_fcs_error(1,PFC_FRAME,AVL_TX_ETH_VIP);
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP);
                    endcase
                    frame_num_tx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("TX frame_num=%0d, Pause/PFC/NORMAL frame with FCS error", frame_num_tx), UVM_LOW)
               end
               join
          end
          read_registers();
          
          `uvm_info("eth1025_stat_pause_cnt_sequence", "8. Send random control frames (data, pause and PFC frames) with FCS error or without FCS Error randomly", UVM_NONE)
          repeat(num_of_frames/4) begin
               fork
               begin
                    randcase
                         1:send_eth_frame(CONTROL_FRAME,ETH_VIP_AVL_RX,1);
                         //1:send_eth_frame(PFC_FRAME,ETH_VIP_AVL_RX,1);
                         1:send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,1);
                         1:send_eth_frame_with_fcs_error(1,CONTROL_FRAME,ETH_VIP_AVL_RX);
                         //1:send_eth_frame_with_fcs_error(1,PFC_FRAME,ETH_VIP_AVL_RX);
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("RX frame_num=%0d, Pause/PFC/NORMAL frame with/without FCS error", frame_num_rx), UVM_LOW)
               end
               begin
                    randcase
                         1:send_eth_frame(CONTROL_FRAME,AVL_TX_ETH_VIP,1);
                         //1:send_eth_frame(PFC_FRAME,AVL_TX_ETH_VIP,1);
                         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
                         1:send_eth_frame_with_fcs_error(1,CONTROL_FRAME,AVL_TX_ETH_VIP);
                         //1:send_eth_frame_with_fcs_error(1,PFC_FRAME,AVL_TX_ETH_VIP);
                         1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP);
                    endcase
                    frame_num_rx++;
                    `uvm_info("eth1025_stat_pause_cnt_sequence", $sformatf("TX frame_num=%0d, Pause/PFC/NORMAL frame with/without FCS error", frame_num_tx), UVM_LOW)
               end
               join
          end
          read_registers();     
          
          //Steps 10 to 15 is covered in eth1025_stat_counter_overflow sequence
     
     endtask
     
     //`ifdef UVM_VERSION_1_1
     //virtual task post_start();
     //  if ((get_parent_sequence() == null) && (starting_phase != null))
     //    starting_phase.phase_done.set_drain_time(this, 2us);
     //    read_1025_stats();
     //    starting_phase.drop_objection(this, "Ending");
     //endtask:post_start
     //`endif
     
     task read_registers();
          #2000ns;
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          
          reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
          reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
     endtask

endclass : eth1025_stat_pause_cnt_sequence

//*******************************************************************************
// Sequence Name: eth1025_tx_error_test_sequence
// Descriptions: 
// 1. Apply reset
// 2. Randomly send data frames with l8_tx_error =1(Tx side )
// 3. Randomly send vlan/svlan frames with l8_tx_error =1 (Tx side)
// 4.  Randomly send undersized/oversized frames with l8_tx_error =1 (Tx side)
// 5.  Randomly send control frames with l8_tx_error =1 (Tx side)
// 6. Read all stats registers.All tx error related registers should be updated.DUT behavior is unpredictable for some stat counter when tx_error is inserted.(Ref. Section 5.5.3.5 in specification)
//*******************************************************************************
class eth1025_tx_error_test_sequence extends eth1025_stat_base_sequence;

     `uvm_object_utils(eth1025_tx_error_test_sequence)
     function new(string name = "eth1025_tx_error_test_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          super.body();
          enable_tx_error_insertion();
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
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
               send_directed_frames();
               send_random_frames(10);
               repeat($urandom_range(100,200)) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
                    endcase
               end
               begin
                    randcase
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_tx_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);//This task will insert Tx error in the frame(Tx side)
                         1: send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
                         1: send_eth_frame_with_tx_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,$urandom_range(30,48));
                    endcase
               end
               join
               end
          `else
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
          `endif
          $display("end eth1025_tx_error_test_sequence");
     endtask
     
     virtual task post_start();
          if ((get_parent_sequence() == null) && (starting_phase != null)) begin
               starting_phase.phase_done.set_drain_time(this, 10us);
          end
          `ifdef ENABLE_ETH_VIP
               //read and compare all stats at the end of all stat sequence
               #2000ns;//Wait till all packets are reached to VIP/DUT RX
               if(p_sequencer.env.tb_cfg.enable_stas_count == 1 && !dis_stats_chk )  
               begin 
                    `uvm_info("eth1025_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
                    read_and_compare_tx_error_stats();  
               end 
          `endif
          starting_phase.drop_objection(this, "Ending");
     endtask:post_start
     
endclass:eth1025_tx_error_test_sequence


//*******************************************************************************
// Sequence Name: eth1025_short_frame_test_sequence
// Descriptions: 
// 1. Apply reset.
// 2. Send back to back short frames , 8 < payload size < 64.(Number of frames > 50)
// 3. Read stats counters.
// 4. Randomly send frames with payload size  < 9 along with normal frames.
// 5. Read stats counters.
//*******************************************************************************
class eth1025_short_frame_test_sequence extends eth1025_stat_base_sequence;

     `uvm_object_utils(eth1025_short_frame_test_sequence)
     uvm_reg 	regs_1[$];
     uvm_reg 	select_reg_1[$];
     bit [31:0] read_data_1[$];
     bit temp;
     bit temp_1;
     
     function new(string name = "eth1025_short_frame_test_sequence");
          super.new(name);
               `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          super.body();
          
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
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
               
                    
               send_random_frames($urandom_range(50,100));
               #800ns;
               read_1025_stats(0);
               p_sequencer.reg_model.default_map.get_registers(regs_1);
               foreach(regs_1[i]) begin
                    read_data_1[i] = regs_1[i].get_mirrored_value();
               end
               repeat(3) begin
                    fork
                    begin
                         repeat($urandom_range(20,30)) begin
                              randcase
                                   1:send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX);
                                   1:send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(64,150),1,ETH_VIP_AVL_RX);
                              endcase
                         end
                         temp = 1;
                    end  
                    begin
                         repeat($urandom_range(20,30)) begin
                              randcase
                                   1:send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
                                   1:send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(64,150),1,AVL_TX_ETH_VIP);
                              endcase  
                         end
                         temp_1 = 1;
                    end
                    begin
                         while(temp==0&&temp_1==0) begin
                              read_1025_stats_in_between(0);
                         end
                    end  
                    join
               
                    temp = 0;
                    temp_1 = 0;
               end
               
               #900ns;
               p_sequencer.env.eth_ref_model_inst.predict_stats_registers();
          `else
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
          `endif
          $display("end eth1025_short_frame_test_sequence");
          
     endtask
          
     task reg_read_in_between(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit disable_check=0);
          uvm_status_e      status;
          uvm_reg 	regs[$];
          uvm_reg 	select_reg;
          bit reg_not_found =1;
          altuvm_avalon_mm_read_seq           read_seq;
          bit [31:0] rsvd_val = 'd3735929054;
          p_sequencer.reg_model.default_map.get_registers(regs);
          foreach(regs[i]) begin
               if (addr == regs[i].get_address())
               begin
                    select_reg = regs[i];
                    reg_not_found = 0 ;
                    select_reg.read(status,.value(read_data), .map(p_sequencer.reg_model.default_map));
                    if(disable_check == 0)begin
                         `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg.get_name(),addr,read_data_1[i],read_data), UVM_NONE)
                         if(read_data_1[i] <= read_data) begin
                              `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Register(%s) address 'h%0h actual read data :'h%0h",select_reg.get_name(),read_data_1[i],read_data), UVM_NONE)
                         end
                         else begin
                              `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
                         end
                    end
               end
          end
          if(reg_not_found == 1)
          begin
               `uvm_warning("AVMM REG READ", $sformatf("No Register found with address :%0h,it seems reserved space",addr));
               read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
               `uvm_do_on_with(read_seq, p_sequencer.status_seqr, {
                    init_latency inside {[0:3]};
                    address   == addr << 2;
                    foreach (byteenable[i]) byteenable[i] == 1;
               })
               
               read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
          
               if(disable_check == 0)
               begin
               if(rsvd_val != read_data)
                    `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val))
               else 
                    `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val), UVM_NONE)
               end
          end
     endtask
     
     task read_1025_stats_in_between(input bit disable_check=0);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
     
     endtask : read_1025_stats_in_between
  
endclass:eth1025_short_frame_test_sequence

//******************************************************************************
// Sequence Name: eth1025_read_in_between_test_sequence
// Descriptions: 
// Update any existing stat sequence to parallely 
// read stat regs while traffic is on and DUT is trying to update stat regs .
//******************************************************************************
class eth1025_read_in_between_test_sequence extends eth1025_stat_base_sequence;

     `uvm_object_utils(eth1025_read_in_between_test_sequence)
     uvm_reg 	regs_1[$];
     uvm_reg 	select_reg_1[$];
     bit [31:0] read_data_1[$];
     bit temp;
     
     function new(string name = "eth1025_read_in_between_test_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          // tx_seq=new("tx_seq");  
     endfunction:new
     
     virtual task body();
          super.body();
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
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          fork
          begin
               send_random_frames($urandom_range(50,100));
          end  
          begin
               //read_1025_stats(1);//disable_check = 1 for register read
          end  
          join
          
          #900ns;
          read_1025_stats(0);
          p_sequencer.reg_model.default_map.get_registers(regs_1);
          foreach(regs_1[i]) begin
               read_data_1[i] = regs_1[i].get_mirrored_value();
          end
          repeat(3) begin
               fork
               begin
                    send_random_frames($urandom_range(20,30));
                    temp = 1;
               end  
               begin
                    while(temp==0) begin
                         read_1025_stats_in_between(0);
                    end
               end  
               join
               temp = 0;
          end
          
          #900ns;
          p_sequencer.env.eth_ref_model_inst.predict_stats_registers();
          `else
               send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
          `endif
          $display("end eth1025_read_in_between_test_sequence");
          
     endtask
          
     task reg_read_in_between(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit disable_check=0);
          uvm_status_e      status;
          uvm_reg 	regs[$];
          uvm_reg 	select_reg;
          bit reg_not_found =1;
          altuvm_avalon_mm_read_seq           read_seq;
          bit [31:0] rsvd_val = 'd3735929054;
          
          p_sequencer.reg_model.default_map.get_registers(regs);
          foreach(regs[i]) begin
               if (addr == regs[i].get_address())
               begin
                    select_reg = regs[i];
                    reg_not_found = 0 ;
                    select_reg.read(status,.value(read_data), .map(p_sequencer.reg_model.default_map));
                    
                    if(disable_check == 0)begin
                         `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg.get_name(),addr,read_data_1[i],read_data), UVM_NONE)
                         if(read_data_1[i] <= read_data) begin
                              `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Register(%s) address 'h%0h actual read data :'h%0h",select_reg.get_name(),read_data_1[i],read_data), UVM_NONE)
                         end
                         else begin
                              `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
                         end
                    end
               end
          end
          if(reg_not_found == 1)
          begin
               `uvm_warning("AVMM REG READ", $sformatf("No Register found with address :%0h,it seems reserved space",addr));
               read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
               `uvm_do_on_with(read_seq, p_sequencer.status_seqr, {
                    init_latency inside {[0:3]};
                    address   == addr << 2;
                    foreach (byteenable[i]) byteenable[i] == 1;
               })
               
               read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
          
               if(disable_check == 0)
               begin
                    if(rsvd_val != read_data)
                         `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val))
                    else 
                         `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val), UVM_NONE)
               end
          end
     endtask
     
     task read_1025_stats_in_between(input bit disable_check=0);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
          reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
     
     endtask : read_1025_stats_in_between
  
endclass:eth1025_read_in_between_test_sequence

//*******************************************************************************
// Sequence Name: eth1025_length_error_test_sequence
// Descriptions: 
// 1. Apply reset
// 2. Randomly send data frames with less payload size than the length/type field(Tx and Rx side,payload < 1500) , also send frames with payload > 1500
// 3. Randomly send vlan/svlan frames with less payload size than the length/type field (Tx and Rx side, payload < 1500) ,also send vlan/svlan frames with payload > 1500
// 4. send frames with payload size between 1500 to 1536.(length error should be 0.)
// 5. Read all stats registers.
// Note: TX counter will not increment if tx_error signal is not asserted. To be covered in eth1025_tx_error_test_sequence
//*******************************************************************************
class eth1025_length_error_test_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_length_error_test_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "eth1025_length_error_test_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_length_error_test_sequence ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          //enable_tx_error_insertion();          
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1554));//error frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);//error frame
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(1501,1554));//error frame
                    endcase
               end
               join
          end
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame_with_fix_size(VLAN_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1558));//error frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,-1);//error frame
                         1: send_eth_frame_with_fix_size(VLAN_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,$urandom_range(1501,1558));//error frame
                    endcase
               end
               join
          end
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(1501,1562));//error frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,-1);//error frame
                         1: send_eth_frame_with_fix_size(STACKED_VLAN_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,$urandom_range(1501,1562));//error frame
                    endcase
               end
               join
          end
          
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,1518);//error frame
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,1554);//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,1522);//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,1558);//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,1526);//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,1562);//error frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,1518);//error frame
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,1554);//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,1522);//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,1558);//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,1526);//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,1562);//error frame
                    endcase
               end
               join
          end
          
          #900ns;
          tx_max_frame_size = $urandom_range(1000,1490);
          rx_max_frame_size = $urandom_range(1000,1490);
          reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
          reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
          repeat(num_of_frames/5) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size);//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size);//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,rx_max_frame_size);//error frame
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,ETH_VIP_AVL_RX,$urandom_range(46,60));//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(50,60));//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,ETH_VIP_AVL_RX,$urandom_range(54,60));//error frame
                    endcase
               end
               begin
                    randcase//Tx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size);//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size);//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,tx_max_frame_size);//error frame
                         1: send_eth_frame_with_length_error(1,DATA_FRAME,AVL_TX_ETH_VIP,$urandom_range(46,60));//error frame
                         1: send_eth_frame_with_length_error(1,VLAN_FRAME,AVL_TX_ETH_VIP,$urandom_range(50,60));//error frame
                         1: send_eth_frame_with_length_error(1,STACKED_VLAN_FRAME,AVL_TX_ETH_VIP,$urandom_range(54,60));//error frame
                    endcase
               end
               join
          end
          #900ns;
     
     endtask

endclass : eth1025_length_error_test_sequence

//*******************************************************************************
// Sequence Name: eth1025_vip_control_frame_coverage_sequence
// Descriptions: to hit coverage holes in SIP
//*******************************************************************************
class eth1025_vip_control_frame_coverage_sequence extends eth1025_stat_base_sequence;

     `uvm_object_utils(eth1025_vip_control_frame_coverage_sequence)
     int transaction_count;
     frame_type eth_frame;
     alt_eth_vip_base_sequence avl_rx_seq;
     alt_eth_avalonst_base_sequence avl_tx_seq;
     
     function new(string name = "seq_0");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_vip_control_frame_coverage_sequence...", UVM_NONE)
          super.body();
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          
          for(int i = 0; i < transaction_count; i++) begin
               std::randomize(eth_frame) with {eth_frame dist {SFC_FRAME := 1, PFC_FRAME := 1}; };
               `ifdef ENABLE_ETH_VIP
                    `uvm_create_on(avl_rx_seq, p_sequencer.eth_vip_seqr_inst);
                    `uvm_info("eth1025_vip_control_frame_coverage_sequence", $sformatf("sending %0s frame from vip tx",eth_frame.name()),UVM_NONE);
                    avl_rx_seq.send_eth_control_frame(1,eth_frame,,$urandom_range(0,1));
               `endif
          
               `uvm_create_on(avl_tx_seq, p_sequencer.tx_seqr);
               `uvm_info("eth1025_vip_control_frame_coverage_sequence", $sformatf("sending %0s frame from avalon tx",eth_frame.name()),UVM_NONE);
               avl_tx_seq.send_eth_control_frame(1,eth_frame,,$urandom_range(0,1));
          end
          
          //To cover rx_vector_uvc_mon::csr_bcast_frame::broadcast_one*med
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          send_eth_frame_with_fix_size(.eth_frame(BCAST_DATA_FRAME),.frame_size(45),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
   
     endtask


endclass

//*******************************************************************************
// Sequence Name: eth1025_dropped_frame_stat_test_sequence
// Descriptions: 
// 1. Apply reset
// 2. Randomly send frames which will be dropped by DUT (invalid SFD,invalid preamble,frame less than 9 bytes)
// 3. Read all stats registers.Dropped stats registers should be updated accordingly.
//*******************************************************************************
class eth1025_dropped_frame_stat_test_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_dropped_frame_stat_test_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "seq_0");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t rd_data;
          `uvm_info("body", "started eth1025_dropped_frame_stat_test_sequence ...", UVM_NONE)
          super.body();
          reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          rd_data[1]=$urandom_range(0,1);
          `uvm_info("eth1025_stat_base_sequence", $psprintf("Writing TX_MAC_CONTROL VLAN detection disable=%0b",rd_data[1]), UVM_NONE)
          reg_write(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
          reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
          rd_data[1]=$urandom_range(0,1);
          `uvm_info("eth1025_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL VLAN detection disable=%0b",rd_data[1]), UVM_NONE)
          rd_data[3]=1;
          rd_data[4]=1;
          `uvm_info("eth1025_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL SFD check=%0b, SYNOPT_STRICT_SOP=%0b",rd_data[3],p_sequencer.env.tb_cfg.strict_sop), UVM_NONE)
          `uvm_info("eth1025_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL PREAMBLE check=%0b, SYNOPT_STRICT_SOP=%0b",rd_data[4],p_sequencer.env.tb_cfg.strict_sop), UVM_NONE)
          reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data); 
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          
          repeat($urandom_range(5,10)) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_sfd_preamble_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
                    endcase
               end
               begin
                    send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
               end
               join
          end
          
          repeat($urandom_range(50,100)) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_sfd_preamble_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);//error frame
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
                    endcase
               end
               begin
                    send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
               end
               join
          end          
          
          #900ns;
     
     endtask

endclass : eth1025_dropped_frame_stat_test_sequence

//*******************************************************************************
// Sequence Name: eth1025_malformed_stat_test_sequence
// Descriptions: 
// 1. Apply reset
// 2. Randomly send frames with incorrect terminate character.(DATA/VLAN/SVLAN)
// 3. Randomly send frame with frame size less than 26 bytes.
// 4. Read all stats registers.Malfomed stats registers should be updated accordingly.
//*******************************************************************************
class eth1025_malformed_stat_test_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_malformed_stat_test_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "eth1025_malformed_stat_test_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_malformed_stat_test_sequence ...", UVM_NONE)
          super.body();
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          p_sequencer.env.eth_ref_model_inst.malformed_case = 1;
		  
         `ifdef ENABLE_ETH_VIP
		  p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
		  p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
		 
         `endif
		 
          repeat($urandom_range(15,20)) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_malformed_error(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//This task will insert malformed error (VIP - tx to DUT - rx)
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,ETH_VIP_AVL_RX);
                    endcase
               end
               begin
                    randcase
                         1: send_eth_frame_with_fix_size(DATA_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_fcs_error(1,DATA_FRAME,AVL_TX_ETH_VIP,-1);
                    endcase
               end
               join
          end
          
          repeat($urandom_range(50,100)) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_malformed_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,-1);//This task will insert malformed error (VIP - tx to DUT - rx)
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(18,22),1,ETH_VIP_AVL_RX);
                    endcase
               end
               begin
                    randcase
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
                    endcase
               end
               join
          end
          
          
     endtask
     
     
     virtual task post_start();
          if ((get_parent_sequence() == null) && (starting_phase != null)) begin
               starting_phase.phase_done.set_drain_time(this, 10us);
          end
          `ifdef ENABLE_ETH_VIP
               //read and compare all stats at the end of all stat sequence
               #2000ns;//Wait till all packets are reached to VIP/DUT RX
               if(p_sequencer.env.tb_cfg.enable_stas_count == 1 && !dis_stats_chk )  
               begin 
                    `uvm_info("eth1025_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
                    read_and_compare_malformed_stats();//Removing size related stats register's comparison Solvnet : 8001073319 - VIP does not send complete frame  
               end 
          `endif
          starting_phase.drop_objection(this, "Ending");
     endtask:post_start

endclass : eth1025_malformed_stat_test_sequence

//*******************************************************************************
// Sequence Name: eth1025_error_in_between_frame_test_sequence
// Descriptions: 
// 1. Apply reset
// 2. Randomly send frames with error characters in between data.(DATA/VLAN/SVLAN)
// 4. DUT should not give malformed error for this frame.
// 3. Read all stats registers.Malfomed stats registers should not be updated.
//*******************************************************************************
class eth1025_error_in_between_frame_test_sequence extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_error_in_between_frame_test_sequence)
     
     int transaction_count;
     //bit rx_crc_pass;
     
     function new(string name = "eth1025_error_in_between_frame_test_sequence");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = 100;
          end
     endfunction:new
     
     virtual task body();
          `uvm_info("body", "started eth1025_error_in_between_frame_test_sequence ...", UVM_NONE)
          super.body();
          
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
		 `ifdef ENABLE_ETH_VIP
		  p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
		  p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
		  p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
		  
         `endif
		  
          repeat($urandom_range(20,50)) begin
               fork
               begin
                    randcase//Rx path 
                         //(frame_num,frame_type,direction,frame_size,normal_frame,destination_address_type)
                         1: send_eth_frame_with_error_in_between(1,DATA_FRAME,ETH_VIP_AVL_RX,-1);//This task will insert malformed error (VIP - tx to DUT - rx)
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,ETH_VIP_AVL_RX);
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,$urandom_range(18,22),1,ETH_VIP_AVL_RX);
                    endcase
               end
               begin
                    randcase
                         1: send_eth_frame_with_fix_size(RANDOM_FRAME,-1,1,AVL_TX_ETH_VIP);
                         1: send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,-1);
                    endcase
               end
               join
          end
     
     
     endtask
  
endclass : eth1025_error_in_between_frame_test_sequence

//*******************************************************************************
// Sequence Name: fc1025_rand_seq
// Descriptions:
// 1. Force stats registers LSB, MSB to 'hffff_ffff
// 2. Send random frames to hit all counters
// 3. Stats counters should roll over
//eth1025_stat_counter_overflow will force LSB stats registers and check LSB registers gets overflow and RTL counts from MSB registers
//*******************************************************************************
class eth1025_stat_counter_overflow extends eth1025_stat_base_sequence;
     `uvm_object_utils(eth1025_stat_counter_overflow)
     
     int transaction_count;
     
     function new(string name = "eth1025_stat_counter_overflow");
          super.new(name);
          `ifdef UVM_POST_VERSION_1_1
               set_automatic_phase_objection(1);
          `endif
          if (!($value$plusargs("num_frames=%d",transaction_count))) begin
               transaction_count = $urandom_range(500,1000);//FIXME Shabbir: increase later after sequence is stable
          end
     endfunction:new
     
     virtual task body();
          uvm_reg_data_t read_data_tx;
          uvm_reg_data_t read_data_rx;
          `uvm_info("body", "started eth1025_stat_counter_overflow ...", UVM_NONE)
          super.body();
          
          //Disable eth_scoreboard check as we are doing FCS error injection
          enable_tx_error_insertion();          
          
          //Ignore expected VIP errors
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
          p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          
          `uvm_info("eth1025_stat_counter_overflow", "Force lower 32bit tx/rx stat registers", UVM_NONE)
          sel_force_stat_regs(0);
          
          `uvm_info("eth1025_stat_counter_overflow", "read and compare all stats after force -- 1", UVM_NONE)
          read_1025_stats();
          
          //3. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_counter_overflow", "3. Send random frames such that it overflows the lower 32 bit counters", UVM_NONE)
          send_directed_frames(,1);
          send_random_frames(transaction_count,1);
          
          `uvm_info("eth1025_stat_counter_overflow", "read and compare all stats after force and sending some transactions -- 2", UVM_NONE)
          read_1025_stats(,1); 
          //TODO: To implement counter check later, disable TX check as mentioned in Crete2E Section 5.5.3.5 the counter will increment not accurately if tx_error is asserted
          #700ns;
                    
          `uvm_info("eth1025_stat_counter_overflow", "Force upper 32bit tx/rx stat registers", UVM_NONE)
          sel_force_stat_regs(1);
          
          `uvm_info("eth1025_stat_counter_overflow", "read and compare all stats after force -- 3", UVM_NONE)
          read_1025_stats();
          
          //4. Send random frames such that all stats counts have non reset value and also send write request to these registers to make it is not overwritten by write request
          `uvm_info("eth1025_stat_counter_overflow", "4. Send random frames such that it overflows the upper 32 bit counters", UVM_NONE)
          send_directed_frames(,1);
          send_random_frames(transaction_count,1);
          
          `uvm_info("eth1025_stat_counter_overflow", "read and compare all stats after force and sending some transactions -- 4", UVM_NONE)
          //TODO: To implement counter check later, disable TX check as mentioned in Crete2E Section 5.5.3.5 the counter will increment not accurately if tx_error is asserted          
          read_1025_stats(,1);
          #700ns;

          
     endtask: body
     
     virtual task post_start();
          //use no_traffic for tests which doesn't send any traffic like some of CL73 testsuite cases
          if ((get_parent_sequence() == null) && (starting_phase != null) && no_traffic==0) begin
               starting_phase.phase_done.set_drain_time(this, 10us);
          end
          `ifdef ENABLE_ETH_VIP
               if(no_traffic==0)
               begin
                    #4000ns;//Wait till all packets are reached to VIP/DUT RX
               end
               //read and compare all stats at the end of all stat sequence
               if(p_sequencer.env.tb_cfg.enable_stas_count == 1 && !dis_stats_chk )  
               begin 
                    `uvm_info("eth_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
                    read_1025_stats(,1);
               end 
          `endif
          starting_phase.drop_objection(this, "Ending");
     endtask:post_start     
    

endclass : eth1025_stat_counter_overflow
