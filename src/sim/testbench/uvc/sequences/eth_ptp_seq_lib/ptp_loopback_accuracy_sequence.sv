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


class ptp_loopback_accuracy_sequence extends eth_ptp_base_sequence;
  ptp_op_e ptp_op;
  frame_type f_type;
  bit [2:0] rst_sig;
  int rand_rst_perd ;
  bit mix_rule;
  int rand_pkts = 0 ;

  `uvm_object_utils(ptp_loopback_accuracy_sequence)
  function new(string name = "ptp_loopback_accuracy_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new


 virtual task body();
   process p_tx;
   process p_rx;
   super.body();
   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;
   p_sequencer.env.m_ptp_tx_agent.m_ptp_tx_mon.dis_ptp_accuracy = 1'b0;
   p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1);
   `uvm_info("eth_seq_lib", "running ptp_loopback_accuracy_sequence\n",UVM_LOW)
   mix_rule = $urandom();
   fork
     forever begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.lf==1) begin
         @(negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
	 @(negedge p_sequencer.env.spy_if.o_tx_ptp_ready);
         @(posedge p_sequencer.env.spy_if.ptp_clk);
         p_sequencer.env.m_ptp_tx_ref_model.reset_model();
       end
       else begin
         @(negedge (p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n));
         p_sequencer.env.m_ptp_tx_ref_model.reset_model();
       end
     end
   join_none
  
     begin
       repeat(50) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {/*INS_NOOP,*/INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {/*INS_NOOP,*/INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         send_ptp_frame(ptp_op,RANDOM_FRAME,1);  
       end
     end

   //Just a delay to make sure frame transfered
// FIXME-MISSING_REG_IN_GDR   for(int i=0;i<25;i++) begin p_sequencer.env.reg_read(`REGISTERS_PHY_CONFIG_OFFSET_REG,read_data);  end

   rst_sig = $urandom_range(1,7);
   `uvm_info("ptp_loopback_accuracy_sequence", $sformatf("1 : rst_sig := %0p",rst_sig),UVM_NONE)
   rand_rst_perd = $urandom_range(21,50);
   fork
     begin
       p_sequencer.env.apply_reset("hard",rst_sig[2],rst_sig[1],1'b0,rand_rst_perd);
     end
     begin
       if (rst_sig[0] == 1'b1) begin
//FIXME recfg_rst_n is unavailable         p_sequencer.env.reset_if.recfg_rst_n = 1'b0;
         repeat(rand_rst_perd) @(posedge p_sequencer.env.reset_if.clock);
//FIXME         p_sequencer.env.reset_if.recfg_rst_n = 1'b1;
       end
     end
   join 
   p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(1'b0));
  // if(rst_sig[1]==1 || rst_sig[0]==1) begin
     vl_reload();
     p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1);
  // end

   fork : reset_thread_1
     begin
       `uvm_info("ptp_loopback_accuracy_sequence", $sformatf("Sending frames on TX"),UVM_NONE)
       p_tx = process :: self();
       repeat(50) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {/*INS_NOOP,*/INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {/*INS_NOOP,*/INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         send_ptp_frame(ptp_op,RANDOM_FRAME,1);  
       end
     end
     begin
       //midsim reset after random frame transfer
       // ADDED logic for reset will release in between 0 to 20 frames
       `uvm_info("ptp_loopback_accuracy_sequence", $sformatf("num_ptp_pkts Before wait"),UVM_NONE)
       rand_pkts = $urandom_range(50,70);
       do begin //{
	@(posedge p_sequencer.env.reset_if.clock);
	end//}
       while (p_sequencer.env.m_ptp_tx_agent.m_ptp_tx_mon.num_ptp_pkts != rand_pkts);
       `uvm_info("ptp_loopback_accuracy_sequence", $sformatf("num_ptp_pkts after wait"),UVM_NONE)

       rst_sig = $urandom_range(1,7);
       fork 
         begin
           `uvm_info("ptp_loopback_accuracy_sequence", $sformatf("3 : rst_sig := %0p",rst_sig),UVM_NONE)
         rand_rst_perd = $urandom_range(21,50);
         fork 
           begin
             p_sequencer.env.apply_reset("hard",rst_sig[2],rst_sig[1],1'b0,rand_rst_perd);
           end
           begin
             if (rst_sig[0] == 1'b1) begin
//FIXME               p_sequencer.env.reset_if.recfg_rst_n = 1'b0;
               repeat(rand_rst_perd) @(posedge p_sequencer.env.reset_if.clock);
//FIXME               p_sequencer.env.reset_if.recfg_rst_n = 1'b1;
             end
           end
         join 
           p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(1'b0));
       //    if(rst_sig[1]==1 || rst_sig[0]==1) begin
             vl_reload();
             p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),1);
       //    end
         end  
         begin
	   p_tx.kill();
         end
       join 	 
       disable reset_thread_1; 
     end
     begin
//FIXME recfg_rst_n unavailable in reset interface
       @ (negedge (/*p_sequencer.env.reset_if.recfg_rst_n &*/ p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.tx_rst_n & p_sequencer.env.reset_if.rx_rst_n));
       p_sequencer.env.sb_loopbk.scb_dis = ~(/*p_sequencer.env.reset_if.recfg_rst_n & */p_sequencer.env.reset_if.csr_rst_n & p_sequencer.env.reset_if.rx_rst_n & p_sequencer.env.reset_if.tx_rst_n );
      uvm_report_info(get_name(),$psprintf("SCB disabled because of reset \n sb_loopbk.scb_dis:%0d ", p_sequencer.env.sb_loopbk.scb_dis ),UVM_NONE);
     end
     join

       `uvm_info("ptp_loopback_accuracy_sequence", "Waiting for RX PCS Ready\n",UVM_LOW)
       do begin //{
	@(posedge p_sequencer.env.reset_if.clock);
	end//}
       while (p_sequencer.env.spy_if.rx_pcs_ready !== 1'b1);
       `uvm_info("ptp_loopback_accuracy_sequence", "RX PCS ready\n",UVM_LOW)
     //Enable scoreboards after pcs ready goes high
       p_sequencer.env.m_ptp_tx_ref_model.i_ptp_tx_fp_q={};
       p_sequencer.env.m_ptp_tx_ref_model.o_ptp_tx_fp_q={};
       p_sequencer.env.m_ptp_tx_ref_model.exp_egr_ts_frame_q={};
       p_sequencer.env.m_ptp_tx_ref_model.exp_eth_frame_q={};
       p_sequencer.env.sb_loopbk.scb_dis = 0;

   //do some normal frame transfer
   fork
     begin
       repeat(25) begin
        if(mix_rule)
          std::randomize(ptp_op) with {ptp_op inside {/*INS_NOOP,*/INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB};};
        else
          std::randomize(ptp_op) with {ptp_op inside {/*INS_NOOP,*/INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_2STEP};};
         send_ptp_frame(ptp_op,RANDOM_FRAME,1);  
       end
     end
   join


   `uvm_info("ptp_loopback_accuracy_sequence", "Exiting ptp_loopback_accuracy_sequence...", UVM_LOW)

 endtask

endclass : ptp_loopback_accuracy_sequence
