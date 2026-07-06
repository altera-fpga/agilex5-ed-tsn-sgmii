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



//FIXME BEFORE RUNNING THIS SEQ:as rx_parity_error & tx_parity_error are not available in F-tile according to designers

class parity_err_seq_fb489674 extends eth_base_sequence;
  `uvm_object_utils(parity_err_seq_fb489674)
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    uvm_reg_data_t read_data_tx;
    uvm_reg_data_t read_data_rx;
    string func_name="body";
    `uvm_info("body", "started parity_err_seq_fb489674 ...", UVM_NONE)

    // apply_hard_reset(0,0,1,11);
    // p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

    //Read status regsiters for parity error
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);

    if(read_data_tx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=1, clearing it",func_name));
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    end
    if(read_data_rx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=1, clearing it",func_name));
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    end

    #100ns;

    //parity error should get cleared now
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    if(read_data_tx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=1",func_name));
    end
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
    if(read_data_rx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=1",func_name));
    end

    clear_stat_counters();
    #400ns;

    //Read status regsiters for parity error
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);

    //if(read_data_tx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=1, clearing it",func_name));
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_tx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end
    //if(read_data_rx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=1, clearing it",func_name));
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_cntr_rx_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),'b010);
    //end

    #100ns;

    //parity error should get cleared now
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_tx,1);
    if(read_data_tx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: TX_CNTR_STATUS has parity error TX_CNTR_STATUS[0]=1",func_name));
    end
    //FIXME p_sequencer.env.reg_read(`GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_rx,1);
    if(read_data_rx[0]==1) begin
      `uvm_error("parity_err_seq_fb489674", $sformatf("%s: RX_CNTR_STATUS has parity error RX_CNTR_STATUS[0]=1",func_name));
    end

    `uvm_info("body", "ended parity_err_seq_fb489674 ...", UVM_NONE)
  endtask

endclass:parity_err_seq_fb489674
