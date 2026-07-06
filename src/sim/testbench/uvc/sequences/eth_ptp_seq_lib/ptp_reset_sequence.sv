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


class ptp_reset_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit [2:0] rst_sig;
  bit mix_rule;

  `uvm_object_utils(ptp_reset_sequence)
  function new(string name = "ptp_reset_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new


 virtual task body();
   process p_tx;
   process p_rx;
   super.body();
//YC   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;
   `uvm_info("eth_seq_lib", "running ptp_reset_sequence\n",UVM_LOW)
   mix_rule = $urandom();
   fork
     forever begin
//YC       if(p_sequencer.env.dyn_rcfg_obj_inst.lf==1) begin
//YC         @(negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
//YC         p_sequencer.env.m_ptp_tx_ref_model.reset_model();
//YC       end
//YC       else begin
         @(negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n));
         p_sequencer.env.m_ptp_tx_ref_model.reset_model();
//YC       end
     end
   join_none
  
   fork
     begin
       repeat(50) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);  
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
     end
   join

   //Just a delay to make sure frame transfered
// FIXME-MISSING_REG_IN_GDR//YC   for(int i=0;i<25;i++) begin p_sequencer.env.reg_read(`REGISTERS_PHY_CONFIG_OFFSET_REG,read_data);  end

   rst_sig = $urandom_range(1,7);
   `uvm_info("ptp_reset_sequence", $sformatf("1 : rst_sig := %0p",rst_sig),UVM_NONE)
//YC   apply_hard_reset(rst_sig[2],rst_sig[1],rst_sig[0],$urandom_range(21,50));
   //if (rst_sig[2]==1'b1 || rst_sig[0]) p_sequencer.env.m_ptp_tx_ref_model.reset_model();
//YC   wait_for_dut_n_vip_link_up(rst_sig[2],rst_sig[1],rst_sig[0]);
   if(rst_sig[1]==1 || rst_sig[0]==1)
     vl_reload();

   fork : reset_thread_1
     begin
       `uvm_info("ptp_reset_sequence", $sformatf("Sending frames on TX"),UVM_NONE)
       p_tx = process :: self();
       repeat(50) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);  
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
         `uvm_info("ptp_reset_sequence", $sformatf("Sending frames on RX"),UVM_NONE)
         p_rx = process :: self();
         send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,50);
     end
     begin
       //midsim reset after random frame transfer
       `ifdef ENABLE_ETH_VIP
       for(int j=0;j<$urandom_range (20,40);j++) begin
         p_sequencer.env.m_snps_eth_pcs66_agent.eth_agent[0].monitor.EVENT_RX_FRAME_ACCEPTED.wait_trigger();
       end
       `endif

       rst_sig = $urandom_range(1,7);
       fork 
         begin
           `uvm_info("ptp_reset_sequence", $sformatf("3 : rst_sig := %0p",rst_sig),UVM_NONE)
//YC           apply_hard_reset(rst_sig[2],rst_sig[1],rst_sig[0],$urandom_range(21,50));
           //if (rst_sig[2]==1'b1 || rst_sig[0]) p_sequencer.env.m_ptp_tx_ref_model.reset_model();
//YC           wait_for_dut_n_vip_link_up(rst_sig[2],rst_sig[1],rst_sig[0]);
           if(rst_sig[1]==1 || rst_sig[0]==1)
             vl_reload();
         end  
         begin
	         //#200ns;
	         p_tx.kill();
	         p_rx.kill();
         end
       join 	 
       disable reset_thread_1; 
     end
     begin
       @ (negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
       //#1;
       p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n );
       p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n  & p_sequencer.env.reset_if.rx_rst_n);
       p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n);
       p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
//YC       p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = ~(p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n);
//YC      uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_vip_tx_mac_rx.scb_dis:%0d \n sb_mac_tx_vip_rx.scb_dis :%0d,  sb_vec_vip_tx_mac_rx.sb_enable:%0d, sb_vec_mac_tx_vip_rx.sb_enable:%0d, sb_mac_tx_vip_rx_lf.scb_dis:%0d ", p_sequencer.env.sb_vip_tx_mac_rx.scb_dis ,p_sequencer.env.sb_mac_tx_vip_rx.scb_dis,p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable,p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable,p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis),UVM_NONE);
     end
     join

     `ifdef ENABLE_ETH_VIP
   //Rx reset can cause DUT tx to transmit fault. This can corrupt DUT tx frame. 
   //Below check will make sure that such erroneous frames are transmitted before we enable VIP rx checkers.

   if((rst_sig[2] == 1 &&  rst_sig[0] == 0) || (rst_sig[1] == 1 && rst_sig[0] == 0)) begin // Tx or Rx reset only
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
     //bit 0: (set t0 0 to disable checker on tx side)
     //bit 1: (set t0 0 to disable checker on rx side)
     //bit 2: (set t0 0 to disable checker on checker arbiter)
     //m_env.m_snps_phy_bfm.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
     p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

     repeat(10) @(p_sequencer.env.spy_if.event_mac_idle_detected_rx); 

      //enable all rule checks 
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
   end

  `endif
    
     //Enable scoreboards after pcs ready goes high
     p_sequencer.env.sb_vip_tx_mac_rx.scb_dis = 0;
     p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;
     p_sequencer.env.sb_vec_vip_tx_mac_rx.sb_enable = 1;
     p_sequencer.env.sb_vec_mac_tx_vip_rx.sb_enable = 1;
//YC     p_sequencer.env.sb_mac_tx_vip_rx_lf.scb_dis = 0; 

   //do some normal frame transfer
   fork
     begin
       repeat(25) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {INS_NOOP,INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         randcase
         4:send_ptp_frame(ptp_op,RANDOM_FRAME,1);  
         1:send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,1);
         endcase
       end
     end
     begin
       send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,25);
     end
   join


   `uvm_info("ptp_reset_sequence", "Exiting ptp_reset_sequence...", UVM_LOW)

 endtask

endclass : ptp_reset_sequence
