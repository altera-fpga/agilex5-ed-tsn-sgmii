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


//class eth_csr_rst_no_impact_master_read_directed_sequence extends eth_base_sequence;
//  uvm_reg_data_t rd_data;
//
//  `uvm_object_utils(eth_csr_rst_no_impact_master_read_directed_sequence)
//
//  function new(string name = "eth_csr_rst_no_impact_master_read_directed_sequence");
//    super.new(name);
//	  `ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
//  endfunction:new
//
//  virtual task body();
//  
//
//    //disabling register coverage
//    p_sequencer.env.dis_reg_cov=1; //disabling register coverage
//    dis_stats_chk=1;
//    p_sequencer.env.apply_reset("hard",0,0,1,11);
//
//    fork
//      begin
//        p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//      end
//      begin
//        wait(p_sequencer.env.spy_if.master_read==1);
//        `uvm_info("eth_csr_rst_no_impact_master_read_directed_sequence", "SPY_IF master_read started ...", UVM_NONE)
//        #150ns;
//		    uvm_hdl_force("eth_env_top.dut.i_csr_rst_n",0);
//        #100ns;
//		    uvm_hdl_release("eth_env_top.dut.i_csr_rst_n");
//        wait(p_sequencer.env.spy_if.cfg_load_done==0);
//        wait(p_sequencer.env.spy_if.cfg_load_done==1);
//        `uvm_info("eth_csr_rst_no_impact_master_read_directed_sequence", "SPY_IF cfg_load_done after forced CSR reset...", UVM_NONE)
//        p_sequencer.env.reg_read(19'h40a,rd_data,1);
//      end
//    join
//
//
//`ifdef ENABLE_ETH_VIP
//    fork
//      send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
//      send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
//    join
//`else
//    if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSONLY) begin
//       send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,200);  
//       #500us;
//    end
//    else begin
//       send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10); 
//    end
//`endif
//
//  endtask//body
//
//endclass//eth_csr_rst_no_impact_master_read_directed_sequence
