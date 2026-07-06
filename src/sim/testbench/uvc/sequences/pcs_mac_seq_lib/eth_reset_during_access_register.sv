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


class eth_reset_during_access_register extends eth_base_sequence;
  uvm_reg_data_t read_data;

  `uvm_object_utils(eth_reset_during_access_register)

  function new(string name = "eth_reset_during_access_register");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    //disabling register coverage
    //p_sequencer.env.dis_reg_cov=1; //disabling register coverage

    `uvm_info ("eth_reset_during_access_register",$psprintf ("value of rx_pcs_ready =%d",p_sequencer.env.spy_if.rx_pcs_ready),UVM_LOW) 
    wait(p_sequencer.env.spy_if.rx_pcs_ready == 1'b1);

    for(int i = 1;i <= 1;i++)
    begin
      fork 
        begin
          p_sequencer.env.reg_write('h11D0,'h55555555);
          `uvm_info ("eth_reset_during_access_register","completed write operation",UVM_LOW) 
        end
        begin
          repeat($urandom_range(1,5)) @(posedge p_sequencer.env.reset_if.clock);
          p_sequencer.env.apply_reset("hard",0,0,1,11);
        end
      join_any
      wait(p_sequencer.env.spy_if.rx_pcs_ready == 1'b1);
    end


    for(int j = 1;j <= 1;j++)
    begin
      fork 
        begin
          p_sequencer.env.reg_read('h11D0,read_data);
        end
        begin
          repeat($urandom_range(1,5)) @(posedge p_sequencer.env.reset_if.clock);
          p_sequencer.env.apply_reset("hard",0,0,1,11);
        end
      join_any
      wait(p_sequencer.env.spy_if.rx_pcs_ready == 1'b1);
    end

    dis_stats_chk=1;
  endtask//body
endclass//eth_reset_during_access_register
