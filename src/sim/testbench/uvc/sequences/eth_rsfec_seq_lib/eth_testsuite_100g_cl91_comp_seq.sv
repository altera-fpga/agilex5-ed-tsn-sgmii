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


class eth_testsuite_100g_cl91_comp_seq extends eth_base_sequence;
  
  `uvm_object_utils(eth_testsuite_100g_cl91_comp_seq)

  integer first_case, last_case;
  
  function new(string name = "eth_testsuite_100g_cl91_comp_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
    if($value$plusargs("ETH_FIRST_TEST=%d",first_case)) begin
      `uvm_info("eth_testsuite_100g_cl91_comp_seq", $psprintf("First case selected from run define %d",first_case), UVM_NONE)
    end
    else begin
      first_case = 1;
    end
    if($value$plusargs("ETH_LAST_TEST=%d",last_case)) begin
      `uvm_info("eth_testsuite_100g_cl91_comp_seq", $psprintf("Last case selected from run define %d",last_case), UVM_NONE)
    end
    else begin
      last_case = 1;
    end
  endfunction:new

  virtual task pre_body();
  endtask; // pre_body
   
  virtual task body();
//   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
    `uvm_info("eth_testsuite_100g_cl91_comp_seq", "Executing eth_testsuite_100g_cl91_comp_seq ...", UVM_NONE)
    `ifdef ANLT 
      //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1)); 
      `uvm_info("eth_testsuite_100g_cl91_comp_seq", "For ANLT wait_rx_pcs_ready done...", UVM_NONE)
    `endif
    wait(p_sequencer.env.master_agent.mast_agt_if.ehip_ready && p_sequencer.env.master_agent.mast_agt_if.rx_pcs_ready);
    `uvm_info("eth_testsuite_100g_cl91_comp_seq", "wait_rx_pcs_ready done ...", UVM_NONE)
    #500ns;
    //muralasx: FIXME for GDR 
    //start_testsuite_test(), testsuite_case_select() & wait_for_testsuite_test_finish() methods are not implemented in GDR test suite tasks interface. 
    //p_sequencer.env.ts_tasks_if.start_testsuite_test();
    `uvm_info("eth_testsuite_100g_cl91_comp_seq", "start_testsuite_test done ...", UVM_NONE)
    //p_sequencer.env.ts_tasks_if.testsuite_case_select("ETH_KR4_FEC_COMP_TP",first_case,last_case);
    `uvm_info("eth_testsuite_100g_cl91_comp_seq", $psprintf("testsuite_case_select done. first_case=%0d last_case=%0d ...",first_case,last_case), UVM_NONE)
    //p_sequencer.env.ts_tasks_if.wait_for_testsuite_test_finish();
    `uvm_info("eth_testsuite_100g_cl91_comp_seq", "Exiting eth_testsuite_100g_cl91_comp_seq ...", UVM_NONE) 

 //FIX ME : uncomment following line once RAL model is in place of rsfec
 //   //RTL is taking some time to update the counter values so making delayed reads
 //   #500ns;
 //
 //   if(first_case == 'd20 || first_case == 'd21 || first_case == 'd22 || first_case == 'd31) begin
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data,1);
 //     p_sequencer.env.read_data_chk(read_data,'h1);
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data); 
 //   end

 //   if(first_case == 'd24 || first_case == 'd25 ) begin
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data,1); 
 //     p_sequencer.env.read_data_chk(read_data,'h1);
 //   end

 //   if(first_case == 'd26 ) begin
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data);
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data,1); 
 //     p_sequencer.env.read_data_chk(read_data,'h2);
 //   end

 //  if(first_case == 'd30 ) begin
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data,1);
 //     p_sequencer.env.read_data_chk(read_data,'h7);
// FIXME-MISSING_REG_IN_GDR //     p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data,1); 
 //     p_sequencer.env.read_data_chk(read_data,'h1);
 //   end
  endtask
endclass : eth_testsuite_100g_cl91_comp_seq
