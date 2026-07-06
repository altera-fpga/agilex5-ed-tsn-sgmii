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


`define STRINGIFY(x) `"x`"
class ptp_ro_registers_sequence extends eth_ptp_base_sequence;
  
  
  bit avmm_readdatavalid;
    uvm_reg_data_t addr;
  uvm_status_e status;
  uvm_reg 	regs_org[$],regs[$];
  bit compare_disable[integer];
  bit [31:0] max_address = 'h9f4;  
  bit [31:0] min_address = 'h820;
  bit [17:0] avmm_addr;
  int reg_index[$];
  bit [31:0] backdoor_read_data;
  bit [31:0] prev_backdoor_read_data;
  int num_reset;
  bit [2:0] rst_sig,rst_sig_1;
  bit reset_done;
  bit regs_done=0;
  int rst_sel; //1 : ip_rst  2: Tx and RX rst 
  int rst_sig_1; //1 : ip_rst  2: Tx and RX rst
    eth_ptp_config_sequence eth_ptp_config_seq;
ptp_op_e ptp_op;

  uvm_reg 	select_reg;
uvm_reg_data_t mir_data;
string eth_reg_name;

  string gdr_mac_stats,gdr_mac;
  string gdr_ehip_stats;
  string ptp_csr_ptp_reg;
  string tile_path;
  bit[15:0] reg_addr;

  `uvm_object_utils(ptp_ro_registers_sequence)

  function new(string name = "ptp_ro_registers_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  
  endfunction:new

  virtual task body();
  super.body();

  tile_path = `STRINGIFY(`FTILE_TOP_PATH);
   //from stats base
 
    `uvm_info("body", "started ptp ro register sequence ...", UVM_NONE)
if ((p_sequencer.env.spy_if.speed == _25G) || (p_sequencer.env.spy_if.speed == _10G) )
begin
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.gdr_e4hip_mac1cfgtop.gen_cfg[8].mac_cfg.gdr_mac_stats"};
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0"};
  gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[4].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
end
else if (p_sequencer.env.spy_if.speed == _400G)
begin
  gdr_mac_stats ={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.gdr_e4hip_mac0cfgtop.gen_cfg[0].mac_cfg.gdr_mac_stats"};
 // gdr_mac_stats ="eth_f_hw__tiles.ftile_s20_v0__eth_f_hw__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_400g_0.genblk1.ehip_mac_400g_0";
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_400g_0.genblk1.ehip_mac_400g_0"};
 gdr_ehip_stats={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[0].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
 end
 else if (p_sequencer.env.spy_if.speed == _50G)
begin
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.gdr_e4hip_mac1cfgtop.gen_cfg[0].mac_cfg.gdr_mac_stats"};
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0"};
  gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[3].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
end
 else if (p_sequencer.env.spy_if.speed == _200G)    
begin
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.gdr_e4hip_mac0cfgtop.gen_cfg[1].mac_cfg.gdr_mac_stats"};
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_200g_0.genblk1.ehip_mac_200g_0"};
  gdr_ehip_stats= {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[1].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
end 
 else if (p_sequencer.env.spy_if.speed == _100G)
begin
  gdr_mac_stats = {tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.gdr_e4hip_mac0cfgtop.gen_cfg[3].mac_cfg.gdr_mac_stats"};
  gdr_mac={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar0.ehip_par_200g_0.genblk1.ehip_mac_200g_0"};
 gdr_ehip_stats={tile_path,".z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_cfgcsr.gdr_ehip_cfgtop_400.gen_ctrl.generate_cfg[2].tslib_avmm_glb_loc_arb.gen_config.gdr_ehip_stats"};
 end

  ptp_csr_ptp_reg= "eth_env_top.dut.ip0.top_ip0.sip_inst.csr_inst.g_ptp.soft_ptp_csr.ptp_reg";
 
  $display("gdr_mac_stats= %s", gdr_mac_stats);
  $display("gdr_mac= %s", gdr_mac);
  $display("gdr_ehip_stats= %s", gdr_ehip_stats);
    //Demoting common error
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_avb_threshold_limit_reached.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.err_check_rx.svt_err_ip_ext_mobility_header_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    `endif

    // apply_hard_reset(0,0,1,11);
    // `ifdef CRETE3
    //   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    // `else  
    //   rx_pcs_ready_timeout();//Shabbir - FB 534015
    // `endif  

    //For tx error insertion
    //enable_tx_error_insertion();//Disabling Tx error insertion for every tests

    //muralasx: FIXME fix register code as GDR reg_model isn't available
    //VR//rand_regs();
    
    //HSD 16011077291  : TODO : Reset valu needs to match
    //FIXME: Workaround for now is to reset the register fields manually, revisit after HSD fix
    //GDR has a new register to take care of
    //p_sequencer.env.reg_write(`GET_REG_ADDR(ehip_cfg_config_ctrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b00);


    //Need to clear stat registers as Mlab RAM is not initialized. FB 489113
    clear_stat_counters();
    #400ns;
    //p_sequencer.env.eth_ref_model_inst.dis_fc_assertion=1;
    
    //FIXME Shabbir: currently DV is not able to capture read data x, so clear parity error in any case
    //Read status regsiters for parity error
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_TX_CNTR_STATUS_OFFSET_REG,read_data_tx,1);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_RX_CNTR_STATUS_OFFSET_REG,read_data_rx,1);

    //if(read_data_tx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end
    //if(read_data_rx[0]!==0) begin
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end

    #100ns;
    //parity error should get cleared now
    //FIXME Shabbir: currently DV is not able to capture read data x
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_TX_CNTR_STATUS_OFFSET_REG,read_data_tx,1);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_RX_CNTR_STATUS_OFFSET_REG,read_data_rx,1);
    #0;
    //FIXME EHIP Shabbir: FB 505364, need to fix DV, scripts
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rx_pause_fwd_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h1);
    //Shabbir: disabling en_sfc/pfc, so SFC frames are not processed and traffic will not be halted on TX side even with fc1 which prevents AVST tiemout
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxsfc_ehip_cfg_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'h0);

  //end from stat base

  
 // repeat(20) begin
 //  send_frames();
 //  end
#100ns;
//  p_sequencer.env.apply_reset("hard",0,0,1,11); TODO GDR
    p_sequencer.reg_model.default_map.get_registers(regs_org);
    enable_disable_anlt_reset();

        
    `uvm_info(get_name(), $sformatf("max_address =%0h ", max_address), UVM_MEDIUM)

 //  foreach(regs_org[i]) 
 //   begin
 //     if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
 //     begin
 //       regs.push_back(regs_org[i]);
 //     end
 //   end 


   uvm_hdl_force("eth_env_top.avmm_rtb_asm.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);
   uvm_hdl_force("eth_env_top.avmm_rtb_p2p.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);

   `uvm_info(get_full_name(), "Executing RO registers seq ...", UVM_LOW)


   //Sending traffic in both TX/RX paths
   //write_asym_p2p_latency();

   fork
     begin
       repeat(10) begin
         std::randomize(ptp_op) with {ptp_op inside {INS_V2,INS_NOOP,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,10);
     end
   join

#10us;

num_reset = 1;
   //Apply hard tx/rx/ip reset single/multiple times 
   for(int i=0;i<num_reset;i++) begin
      rst_sel = $urandom_range(1,4);
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      rst_sig = rst_sig_1 | rst_sig;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :1 rst_sig_1 := %0d",i,rst_sig_1),UVM_LOW)
       p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
            repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
            //#1200ns; 
   end

   //reconfig_for_an(rst_sig);
      `uvm_info(get_full_name(), "RECONFIG FOR AN DONE",UVM_LOW)

      read_regs();

    endtask

    task read_regs();
      fork 
      begin
     
           


min_address ='h820;
    max_address = 'h9f4;

foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        if(!(regs_org[i].get_address() inside {'h8f0,'h8f4,'h900,'h904,'h920,'h924,'h940,'h944,'h960,'h964,'h980,'h984,'h9a0,'h9a4,'h9c0,'h9c4,'h9e0,'h9e4})) begin
          regs.push_back(regs_org[i]);
        end
      end
    end 
foreach(regs[i])
      begin
        reg_addr = regs[i].get_address(); 
        //$display("DEBUG Reg_addr=%0h", reg_addr);
        `uvm_info(get_full_name(), $sformatf(" Reg_addr %0h ",reg_addr),UVM_LOW)
      //  wait(!p_sequencer.env.spy_if.rx_pcs_ready)
        wait(reset_done);
        p_sequencer.env.reg_write(reg_addr, 'hFFFFFFFF); 
        compare_read_data(reg_addr, 32'b0); 

      end





     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_vl_ss_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
      `uvm_info("RO_REG_READ", "READING REG", UVM_MEDIUM)
      addr       = `GET_REG_ADDR(mac_stats_rx_vl_ss_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
      compare_read_data(addr, 32'b0);


     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);



      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);


      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

     

      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

     

      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

     
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

     

      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

     
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_2_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_3_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_4_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_5_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_6_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_7_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_8_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_9_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_10_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_11_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_12_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_13_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_14_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);
     
      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_15_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);

      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ts_ss_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ts_ss_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);


      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ts_ss_mid_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ts_ss_mid_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);


      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_tx_ts_ss_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_tx_ts_ss_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);


      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ts_ss_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ts_ss_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);


      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ts_ss_mid_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ts_ss_mid_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0);


      
     wait_for_rx_pcs_ready();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_stats_rx_ts_ss_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'hFFFFFFFF);
     addr       = `GET_REG_ADDR(mac_stats_rx_ts_ss_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed);
     compare_read_data(addr, 32'b0); 
     

//foreach(regs[i])
//    begin
//
//      if(regs[i].get_address() inside {'h8f0,'h8f4,'h900,'h904,'h920,'h924,'h940,'h944,'h960,'h964,'h980,'h984,'h9a0,'h9a4,'h9c0,'h9c4,'h9e0,'h9e4})
//		regs.delete(i);
//    end 

 //   foreach(regs[i])
 //   begin
 //       reg_addr = regs[i].get_address(); 
 //       $display("VR DEBUG Reg_addr=%0h", reg_addr);
 //   end

    min_address ='h1114;
    max_address = 'h11b4;
foreach(regs_org[i]) 
    begin
      if(regs_org[i].get_address() >= min_address && regs_org[i].get_address() <= max_address) 
      begin
        regs.push_back(regs_org[i]);
      end
    end 
  //  $display("DEBUG regs= %p",regs);
foreach(regs[i])
      begin
        reg_addr = regs[i].get_address(); 
        //$display("DEBUG Reg_addr=%0h", reg_addr);
        `uvm_info(get_full_name(), $sformatf(" Reg_addr %0h ",reg_addr),UVM_LOW)
       // wait(!p_sequencer.env.spy_if.rx_pcs_ready)
        wait(reset_done);
        p_sequencer.env.reg_write(reg_addr, 'hFFFFFFFF); 
        compare_read_data(reg_addr, 32'b0); 

      end
 
      regs_done =1;
     // $display("Regs done");

     end //fork 1st block

 begin
   forever begin
    wait (p_sequencer.env.spy_if.rx_pcs_ready);
    reset_done =0;
     for(int i=0;i<num_reset;i++) begin
        rst_sel = $urandom_range(1,4);
        if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
        else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
        else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
        else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
        rst_sig = rst_sig_1 | rst_sig;
        `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :1 rst_sig_1 := %0d",i,rst_sig_1),UVM_LOW)
         p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
        //repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
        `uvm_info(get_full_name(), $sformatf("Reset done"),UVM_LOW)
        
       
   end //for
  // @(posedge p_sequencer.env.reset_if.tx_rst_ack_n);
   //reset_done =1;
 //end
 end //forever
 end //fork 2nd block
 
  begin forever 
   begin
     `uvm_info(get_full_name(), $sformatf("Waiting for Reset Ack"),UVM_LOW)
     @(posedge p_sequencer.env.reset_if.tx_rst_ack_n);
     reset_done =1;
     `uvm_info(get_full_name(), $sformatf("Got Reset Ack"),UVM_LOW)
    end
  end
   join_any

 //  $display("Fork join done");
  `uvm_info(get_full_name(), $sformatf("Out of fork join"),UVM_LOW)
         endtask

task wait_for_rx_pcs_ready;
  `uvm_info(get_full_name(), $sformatf("Waiting for !rx pcs ready and reset done"),UVM_LOW)
  //wait(!p_sequencer.env.spy_if.rx_pcs_ready && reset_done);
  wait(reset_done);
  `uvm_info(get_full_name(), $sformatf("Done waiting for !rx pcs ready and reset done"),UVM_LOW)
endtask

task compare_read_data(uvm_reg_data_t addr, uvm_reg_data_t exp_data);
uvm_reg_data_t read_data;

  select_reg = p_sequencer.reg_model.default_map.get_reg_by_offset(addr);
  select_reg.read(status,.value(read_data), .map(p_sequencer.reg_model.default_map));
      if(read_data != exp_data)
       `uvm_error("RO_REG_READ", $sformatf("Register(%s) read data mismatch exp_data= %0h, actual data = %0h",select_reg.get_name(), exp_data, read_data))
      else
       `uvm_info("RO_REG_READ",  $sformatf("Register(%s) read data match value = %0h, exp_value= %0h",select_reg.get_name(), read_data, exp_data), UVM_MEDIUM)

endtask

endclass

