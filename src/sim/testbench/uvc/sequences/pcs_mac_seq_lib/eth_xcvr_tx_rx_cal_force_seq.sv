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


class eth_xcvr_tx_rx_cal_force_seq extends eth_base_sequence;
  `uvm_object_utils(eth_xcvr_tx_rx_cal_force_seq)
  
  function new(string name = "eth_xcvr_tx_rx_cal_force_seq");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   endfunction:new

   virtual task body();
//   //dsamantx:FIX_ME entirely for GDR 
//   bit val;
//   bit [3:0] tx_rx_cal;
//   int unsigned delay;
//   val = 1'b1;
//   delay = $urandom_range(10,500);
//   tx_rx_cal = $urandom_range(1,15);
//   `uvm_info("TX_RX_CAL",$sformatf("TX_RX_CAL:%0d",tx_rx_cal), UVM_LOW)
//
//   p_sequencer.env.apply_reset("hard",0,0,1,11);
//
//   #500ns;
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//   `uvm_info("eth_xcvr_tx_rx_cal_force_seq", "Random Delay", UVM_MEDIUM)
//
//   repeat(delay) @(posedge p_sequencer.env.reset_if.clock);
//    
//   p_sequencer.env.dyn_rcfg_obj_inst.print();
//   //`ifndef CRETE3
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//   //`ifdef G100
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//   //  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//   //`endif 
//   //`endif
//   //`ifndef CRETE3   //dsamantx:FIX_ME for GDR
//   for(int i = 0;i <= 3;i++)
//   begin
//     if(tx_rx_cal[i] == 1) begin
//       case(i)
//         0: begin
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//            end
//         1: begin
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//            end
//       //`ifdef G100
//         2: begin
//            if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G )  begin
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//            end
//           end
//         3: begin
//            if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G )  begin
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy",val);
//              uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy",val);
//            end
//          end
//       //`endif
//       endcase
//     end
//   end
//   //`endif
//   `uvm_info("apply Randomisation", $sformatf(" Delay:%0d",delay), UVM_LOW)
//
//   `uvm_info("eth_xcvr_tx_rx_cal_force_seq", "Applying hard reset", UVM_MEDIUM)
//   p_sequencer.env.apply_reset("hard",0,0,1,11);
//     
//   repeat(delay) @(posedge p_sequencer.env.reset_if.clock);
//   fork 
//     begin
//       wait(p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready==1);
//       `uvm_error("rx_pcs_ready","rx_pcs_ready or lane_stable  is asserted within 100000ns")
//     end
//     begin
//       #200us; 
//       `uvm_info("rx_pcs_ready","rx_pcs_ready didn't asserted within 200us", UVM_MEDIUM)
//     end
//   join_any
//   disable fork;
//   `uvm_info("rx_pcs_ready", "Disabling fork", UVM_NONE)
//   //`ifndef CRETE3
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//   //`ifdef G100
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//   //  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//   //`endif
//   //`endif
//   `ifndef CRETE3
//   for(int j = 0;j <= 3;j++)
//   begin
//     if(tx_rx_cal[j] == 1) begin
//       case(j)
//         0: begin
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[0].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//            end
//         1: begin
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[1].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//            end
//       `ifdef G100
//         2: begin
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[2].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//            end
//         3: begin
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.tx_cal_busy");
//              uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_hard_inst.altera_xcvr_native_inst.g_native_phy_inst[3].s10_xcvr_native_inst.s10_xcvr_native_phy.rx_cal_busy");
//            end
//       `endif
//       endcase
//     end
//   end
//   `endif
//
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//   `ifdef ENABLE_ETH_VIP
//     fork
//       send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
//       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
//     join
//   `endif
//   
//   `uvm_info("eth_xcvr_tx_rx_cal_force_seq", "Sequence completed", UVM_MEDIUM)
  endtask
 
endclass
