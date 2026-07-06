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


///// Commented below routies for sanity, Need to move to GDR testsuite task intf stucture before use
/////task force_rx_pma_rdy();
/////`ifndef EHIP
/////  force dut.top.rx_pma_ready[3:0] = $urandom()%15;
/////`endif
/////endtask : force_rx_pma_rdy 
/////
/////task release_rx_pma_rdy();
/////`ifndef EHIP
/////  release dut.top.rx_pma_ready[3:0];
/////`endif
/////endtask : release_rx_pma_rdy 
/////
/////task force_rand_rx_data(input [1:0] mode, bit [`NUM_CHANNELS-1:0] rand_ch=4'b1111);
/////
/////  //`ifdef G100
/////    //driving random data
/////    if(mode == 0) begin
/////       for (int i=0;i<`NUM_CHANNELS;i++) begin
/////	  case (i)
/////	    0: if (rand_ch[0]==1'b1) force dut.top.i_rx_serial[0] = $urandom()%4;
/////	    1: if (rand_ch[1]==1'b1) force dut.top.i_rx_serial[1] = $urandom()%4;
/////	    2: if (rand_ch[2]==1'b1) force dut.top.i_rx_serial[2] = $urandom()%4;
/////	    3: if (rand_ch[3]==1'b1) force dut.top.i_rx_serial[3] = $urandom()%4;
/////	    default: if (rand_ch[0]==1'b1) force dut.top.i_rx_serial[0] = $urandom()%4;
/////	  endcase
/////       end
/////    end
/////    else if(mode == 1) begin
/////      //force dut.top.rx_serial[3:0] = 'z;
/////
/////      //setb (xs propagate, no recovery even after reset from pre-lock cntr trigger)
/////      //force dut.top.alt_s100.rx_data_in = 'z;
/////      //force dut.top.alt_s100.rx_data_valid = 'z;
/////      `ifndef CRETE3
/////      //setc (block lock deasserted, link comes up as expected
/////      force dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.i_fec_rx_data = 'x;
/////      `else
/////         `ifdef G25
/////             // force dut.top.alt_ehipc3_hard_inst.genblk2.gen_native_phy[0].i_ehip_nphy_elane.alt_ehipc3_nphy_elane_sim.ehip_pmaRsfec_fec_rx_data = 'x;
/////         `elsif G10
/////             // TODO
/////         `else
/////           `ifdef RSFEC  //fb:576482 need to force with zero as x doesn't propogate 
/////             `ifdef PTP_MODE
/////                force eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_FEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.generate_RSFEC_block.inst_ct3_hssi_rsfec.ct3_hssi_rsfec_encrypted_inst.ct1_hssirtl_rsfec_wrap_inst.i_fec_rx_data[263:0]  = 0;
/////             `else
/////                force eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.generate_RSFEC_block.inst_ct3_hssi_rsfec.ct3_hssi_rsfec_encrypted_inst.ct1_hssirtl_rsfec_wrap_inst.i_fec_rx_data[263:0]  = 0;
/////              `endif
/////           `else
/////              force dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.i_fec_rx_data = 'x;
/////           `endif  
/////         `endif
/////      `endif
/////    end
/////    else begin
/////     `uvm_fatal("force_rand_rx_data", "INCORRECT SELECTION FOR FORCING RX DATA")
/////    end
/////  //`endif
/////endtask : force_rand_rx_data 
/////
/////task release_rand_rx_data(input [1:0] mode);
/////  //`ifdef G100
/////    if(mode == 0) begin
/////      release dut.top.i_rx_serial[3:0];
/////    end
/////    else if(mode == 1) begin
/////      `ifndef CRETE3
/////      release dut.top.alt_ehipc2_hard_inst.c2_ehip_core_inst.i_fec_rx_data;
/////      `else
/////          `ifdef G25
/////             // release dut.top.alt_ehipc3_hard_inst.genblk2.gen_native_phy[0].i_ehip_nphy_elane.alt_ehipc3_nphy_elane_sim.ehip_pmaRsfec_fec_rx_data;
/////          `elsif G10
/////            //TODO
/////          `else
/////           `ifdef RSFEC //fb:576482 need to force with zero as x doesn't propogate 
/////             `ifdef PTP_MODE
/////               release eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_FEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.generate_RSFEC_block.inst_ct3_hssi_rsfec.ct3_hssi_rsfec_encrypted_inst.ct1_hssirtl_rsfec_wrap_inst.i_fec_rx_data[263:0];
/////             `else
/////               release eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.generate_RSFEC_block.inst_ct3_hssi_rsfec.ct3_hssi_rsfec_encrypted_inst.ct1_hssirtl_rsfec_wrap_inst.i_fec_rx_data[263:0];
/////              `endif
/////           `else
/////            release dut.top.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.i_fec_rx_data;
/////           `endif
/////          `endif
/////      `endif
/////    end
/////    else begin
/////     `uvm_fatal("force_rand_rx_data", "INCORRECT SELECTION FOR FORCING RX DATA")
/////    end
/////    //release dut.top.rx_serial[3:0];
/////    //release dut.top.alt_s100.rx_data_in ;
/////    //release dut.top.alt_s100.rx_data_valid ;
/////  //`endif
/////endtask :release_rand_rx_data 
/////
/////task force_prelock_cntr(input [9:0] value);
/////  `ifndef RSFEC
/////  //`ifdef G100
/////      //force dut.top.alt_s100.rpcs.PCS.pctrl.cntr_prelock[9:0] = value;
/////  //`endif
/////  `endif
/////endtask : force_prelock_cntr 
/////
/////task release_prelock_cntr();
/////  `ifndef RSFEC
/////  //`ifdef G100
/////    //release dut.top.alt_s100.rpcs.PCS.pctrl.cntr_prelock[9:0];
/////  //`endif
/////  `endif
/////endtask :release_prelock_cntr
/////
/////
/////`ifdef ANLT
/////task wait_tx_an_reset();
/////   `ifndef CRETE3
/////   `uvm_info("wait_tx_an_reset", "Wait for TX_AN_RESET", UVM_NONE)
/////   wait (eth_env_top.dut.top.GENKR.alt_ehipc2_kr_inst.kr_top.AN_GEN.tx_an_reset==1'b1);
/////   @ (negedge eth_env_top.dut.top.GENKR.alt_ehipc2_kr_inst.kr_top.AN_GEN.tx_an_reset);
/////   `uvm_info("wait_tx_an_reset", "Wait for TX_AN_RESET done", UVM_NONE)
/////   `endif
/////endtask: wait_tx_an_reset
/////
/////task wait_tx_an_restart();
/////   `ifndef CRETE3
/////   `uvm_info("wait_tx_an_restart", "Wait for TX_AN_RESTART", UVM_NONE)
/////   @ (posedge eth_env_top.dut.top.GENKR.alt_ehipc2_kr_inst.kr_top.AN_GEN.an_restart);
/////   `uvm_info("wait_tx_an_restart", "Wait for TX_AN_RESTART done", UVM_NONE)
/////   `endif
/////endtask: wait_tx_an_restart
/////`endif
/////
/////
/////
