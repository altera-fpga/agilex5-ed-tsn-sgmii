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


class ptp_sync_latency_ctr_sequence extends eth_ptp_base_sequence;

  `uvm_object_utils(ptp_sync_latency_ctr_sequence)
  
  ptp_op_e ptp_op;
  bit mix_rule;
  
  function new(string name = "ptp_sync_latency_ctr_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new
  

  virtual task body();
    super.body();
    `uvm_info("eth_seq_lib", "running ptp_sync_latency_ctr_sequence\n",UVM_LOW)
    
    //applying a reset to re-calibrate 
    // reset logic 
 
    mix_rule= $urandom();
 
   `ifdef CRETE3
      fork
	begin
        p_sequencer.env.apply_reset("hard",1,1,1,$urandom_range(21,50));
        p_sequencer.env.wait_for_linkup(.tx_sync(1),.rx_sync(1),.ip_sync(1));
   	vl_reload();
	end
	begin
//FIXME	wait(p_sequencer.env.spy_if.ptp_tx_calibrate[0]==1);
//FIXME	uvm_hdl_force("eth_env_top.dut.top.ML_SOFT.ml_soft.ML_PTP.soft_ptp.i_tx_sclk_return",4'b0);
//FIXME 	@(negedge p_sequencer.env.spy_if.ptp_sclk[0]);
	#100ns;
//FIXME	@(posedge p_sequencer.env.spy_if.ptp_clk);
//FIXME	uvm_hdl_force("eth_env_top.dut.top.ML_SOFT.ml_soft.ML_PTP.soft_ptp.i_tx_sclk_return",4'b1111);
//FIXME        @(posedge p_sequencer.env.spy_if.ptp_clk);
//FIXME	uvm_hdl_release("eth_env_top.dut.top.ML_SOFT.ml_soft.ML_PTP.soft_ptp.i_tx_sclk_return");
	end
        begin
//FIXME        wait(p_sequencer.env.spy_if.ptp_rx_calibrate[0]==1);
//FIXME	uvm_hdl_force("eth_env_top.dut.top.ML_SOFT.ml_soft.ML_PTP.soft_ptp.i_rx_sclk_return",4'b0);
//FIXME 	@(negedge p_sequencer.env.spy_if.ptp_sclk[0]);
//FIXME	#50ns;
//FIXME	@(posedge p_sequencer.env.spy_if.ptp_clk);
//FIXME	uvm_hdl_force("eth_env_top.dut.top.ML_SOFT.ml_soft.ML_PTP.soft_ptp.i_rx_sclk_return",4'b1111);
//FIXME        @(posedge p_sequencer.env.spy_if.ptp_clk);
//FIXME	uvm_hdl_release("eth_env_top.dut.top.ML_SOFT.ml_soft.ML_PTP.soft_ptp.i_rx_sclk_return");
	end
      join
      
   `endif
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
         
     endtask

endclass : ptp_sync_latency_ctr_sequence
