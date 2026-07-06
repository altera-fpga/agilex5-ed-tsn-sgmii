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


//https://hsdes.intel.com/appstore/article/#/16011891387
//b2b reset
//Wait for initial ack toggle -> assert all ip_reset, tx_reset, rx_reset, -> wait for reset ack -> send 200 pkt -> assert ip_reset -> wait for rst_ack out of reset and ptp ready -> send 200 pkt

class ptp_b2b_reset_2step_accuracy_sequence extends eth_ptp_base_sequence;
  uvm_event_pool a_event_pool;
  uvm_event assertion_event;
  bit [2:0] rst_sig,rst_sig_1;
  //int tx_pkt_cnt;
  //int rx_pkt_cnt;
  //int frames=50;//number of frames selection 
  int num_reset;
   int rst_sel; //1 : ip_rst  2: Tx and RX rst 
   int rst_sig_1; //1 : ip_rst  2: Tx and RX rst
  ptp_op_e ptp_op;


  `uvm_object_utils(ptp_b2b_reset_2step_accuracy_sequence)

  eth_ptp_config_sequence eth_ptp_config_seq;
  
  function new(string name = "ptp_b2b_reset_2step_accuracy_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

   task reset_spm();

      fork
      begin
         //reset
         forever
         begin
            `uvm_info(get_full_name(), "waiting for Reset ...", UVM_LOW)
            @(negedge p_sequencer.env.reset_if.csr_rst_n , negedge p_sequencer.env.reset_if.tx_rst_n , negedge p_sequencer.env.reset_if.rx_rst_n);
            `uvm_info(get_full_name(), "Reset asserted, reset SPM by forcing SPM clock to 0", UVM_LOW)
            uvm_hdl_force("eth_env_top.spm_clk_gate", 'h0);
         end
      end
      begin
         //deassert
         forever
         begin
            @(posedge p_sequencer.env.reset_if.csr_rst_n , posedge p_sequencer.env.reset_if.tx_rst_n , posedge p_sequencer.env.reset_if.rx_rst_n);
            `uvm_info(get_full_name(), "Reset deasserted, enable SPM", UVM_LOW)
            uvm_hdl_force("eth_env_top.spm_clk_gate", 'h1);
         end
      end
      join_none
   endtask: reset_spm

  virtual task body();
   process p_tx;
   process p_rx;
   a_event_pool = new();
   a_event_pool = a_event_pool.get_global_pool();
   assertion_event = a_event_pool.get("assertion_event");
   assertion_event.trigger();
   p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count = 0;
   
   super.body();
   reset_spm();
   dis_stats_chk=1;

   uvm_hdl_force("eth_env_top.avmm_rtb_asm.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);
   uvm_hdl_force("eth_env_top.avmm_rtb_p2p.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal",0);

   `uvm_info(get_full_name(), "Executing ptp_b2b_reset_2step_accuracy_sequence ...", UVM_LOW)

   //INS_2STEP/INS_NOOP/NON_PTP
   fork
   begin
//    repeat (20) @ (posedge p_sequencer.env.spy_if.o_tx_am);
//    `uvm_info("serial_wait", "Done waiting additional 20 TX_AMs before TX traffic\n",UVM_NONE)
     repeat(200) begin
       randcase
       1:send_ptp_frame(INS_2STEP,DATA_FRAME,1);
       1:send_ptp_frame(INS_2STEP,VLAN_FRAME,1);
       1:send_ptp_frame(INS_2STEP,STACKED_VLAN_FRAME,1);
       endcase
     end
   end
   begin
   `ifdef ENABLE_ETH_VIP
//     repeat (5) @ (posedge p_sequencer.env.spy_if.o_rx_am);
//     `uvm_info("serial_wait", "Done waiting additional 20 RX_AMs before RX traffic\n",UVM_NONE)
      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,200);
   `endif
   end
   join

   #10us;
   
   //num_reset = $urandom_range(1,2);
   num_reset = 1;
   //Apply hard tx/rx/ip reset single/multiple times 
   for(int i=0;i<num_reset;i++) begin
      rst_sel = 1;
      if(rst_sel == 1) rst_sig_1 = 1; // IP Reset
      else if(rst_sel == 2) rst_sig_1 = 6; // Tx+Rx Reset
      else if(rst_sel == 3) rst_sig_1 = 4; // Tx only Reset
      else if(rst_sel == 4) rst_sig_1 = 2; // Rx only Reset
      rst_sig = rst_sig_1 | rst_sig;
      `uvm_info(get_full_name(), $sformatf("loop_cnt %0d : stage :1 rst_sig_1 := %0d",i,rst_sig_1),UVM_LOW)
       p_sequencer.env.apply_reset("hard",rst_sig_1[2],rst_sig_1[1],rst_sig_1[0],$urandom_range(21,50));
       fork
          begin
             `uvm_do(eth_ptp_config_seq)
          end
          begin
             p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
          end
       join
       repeat ($urandom_range(0,15)) @(posedge p_sequencer.env.spy_if.clk);
   end

   reconfig_for_an(rst_sig);
   //p_sequencer.env.wait_for_linkup(.tx_sync(rst_sig[2]),.rx_sync(rst_sig[1]),.ip_sync(rst_sig[0]));
   `uvm_info(get_full_name(), "stage :1 Link Up Executing Traffic AFter Reset ...", UVM_LOW)

   //INS_2STEP/INS_NOOP/NON_PTP
   fork
   begin
//    repeat (20) @ (posedge p_sequencer.env.spy_if.o_tx_am);
//    `uvm_info("serial_wait", "Done waiting additional 20 TX_AMs before TX traffic\n",UVM_NONE)
     repeat(200) begin
       randcase
       1:send_ptp_frame(INS_2STEP,DATA_FRAME,1);
       1:send_ptp_frame(INS_2STEP,VLAN_FRAME,1);
       1:send_ptp_frame(INS_2STEP,STACKED_VLAN_FRAME,1);
       endcase
     end
   end
   begin
   `ifdef ENABLE_ETH_VIP
      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,200);
   `endif
   end
   join

   #10us;
   `uvm_info(get_full_name(), "stage :1 Traffic Done ...", UVM_LOW)
   `uvm_info(get_full_name(), "Exiting ptp_b2b_reset_2step_accuracy_sequence ...", UVM_LOW)
  endtask
endclass
