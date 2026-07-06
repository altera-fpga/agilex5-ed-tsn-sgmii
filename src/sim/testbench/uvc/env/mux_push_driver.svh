//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_PUSH_DRIVER__
`define __MUX_PUSH_DRIVER__

class mux_push_driver extends uvm_push_driver;

  `uvm_blocking_put_imp_decl(_0)
  `uvm_analysis_imp_decl(_axi_egress)
  `uvm_analysis_imp_decl(_vip_debug)
  //
  mux_env               m_env;

  // Variables
  svt_ethernet_transaction        vip_tx_trans_q[$];
  svt_ethernet_transaction        vip_debug_trans_q[$];
  svt_axi_master_base_sequence    axi_mst_seq;
  svt_axi_slave_response_sequence axi_slv_seq;

  // Ports
  uvm_blocking_put_imp_0#(svt_ethernet_transaction, mux_push_driver) put_imp0;
  uvm_analysis_imp_axi_egress#(svt_axi_transaction, mux_push_driver) axi_egress;
  uvm_analysis_imp_vip_debug#(svt_ethernet_transaction,mux_push_driver) vip_debug;

  //
  int   port_num;
  bit   start_slv_seq;

  //Factory registration
  `uvm_component_utils_begin(mux_push_driver)
  `uvm_component_utils_end
  
  //----------------------------------------------
  // New
  //----------------------------------------------
  function new(string name = "mux_push_driver", uvm_component parent);
    //
    super.new(name, parent);
    //
    put_imp0 = new("put_imp0",this);
    axi_egress = new("axi_egress", this);
    vip_debug = new("vip_debug", this);
  endfunction
  
  //------------------------------------------
  //
  //------------------------------------------
  function void build_phase(uvm_phase phase);
    //
    super.build_phase(phase);
    //
  endfunction

  task run_phase (uvm_phase phase);
     axi_slv_seq=svt_axi_slave_response_sequence::type_id::create("axi_slv_seq", this);
     axi_slv_seq.p_sequencer = m_env.m_axi_st_env.slave[port_num].sequencer;
     //
     //
     fork
     begin
       wait(start_slv_seq == 1);
       axi_slv_seq.randomize();
       axi_slv_seq.start(m_env.m_axi_st_env.slave[port_num].sequencer);
     end
     join_none

    //
     `ifdef MUX_DEBUG
     forever begin
       wait(vip_debug_trans_q.size > 0);
       $display ("AS_DBG_PUSH_DRIVER : Calling convert and send task in push driver");
       convert_and_send();
     end
     `endif
  endtask
  //------------------------------------------
  //
  //------------------------------------------
  task convert_and_send();
    svt_ethernet_transaction     lcl_eth_trans;
    svt_axi_master_transaction   lcl_axi_trans;
    //
    //if(vip_tx_trans_q.size > 0) begin
    if(vip_tx_trans_q.size > 0 || vip_debug_trans_q.size > 0) begin
      //
      lcl_eth_trans = svt_ethernet_transaction::type_id::create("lcl_eth_trans");
      `ifdef MUX_DEBUG
        lcl_eth_trans = vip_debug_trans_q.pop_front();
      `else
        lcl_eth_trans = vip_tx_trans_q.pop_front();
      `endif
      //
      lcl_axi_trans = svt_axi_master_transaction::type_id::create("lcl_axi_trans");
      //
      conv_eth_to_axi(lcl_eth_trans, lcl_axi_trans);
      // Start AXI sequence on AXI master sequencer
      axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");
      //
      axi_mst_seq.p_sequencer = m_env.m_axi_st_env.master[port_num].sequencer;
      //
      start_slv_seq = 1;
      axi_mst_seq.start_item(.item(lcl_axi_trans),
                             .sequencer(m_env.m_axi_st_env.master[port_num].sequencer));
      axi_mst_seq.finish_item(lcl_axi_trans);
      `uvm_info(get_type_name(), $sformatf("Completed driving AXI sequence"), UVM_LOW);
      //
      lcl_eth_trans = null;
      lcl_axi_trans = null;
      axi_mst_seq   = null;
    end
  endtask

  //------------------------------------------
  //
  //------------------------------------------
  task put_0(svt_ethernet_transaction trans);
    svt_ethernet_transaction lcl_trans;
    //
    lcl_trans = new;
    $cast(lcl_trans, trans);
    //
    `uvm_info(get_name(), $sformatf("Received Ethernet frame \n %s", lcl_trans.sprint), UVM_LOW);
    `uvm_info(get_type_name(), $sformatf("address    = 0x%x", lcl_trans.address), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("byte_count = 0x%x", lcl_trans.byte_count), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("command_mode_data = %s", lcl_trans.command_mode_data.name), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("command_pkt_size = %s", lcl_trans.command_pkt_size.name), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("command_type = %s", lcl_trans.command_type.name), UVM_LOW)

    //
    for(int idx=0; idx < lcl_trans.complete_data_frame.size; idx++) begin
      `uvm_info(get_type_name(), $sformatf("data_frame[%0d] = 0x%x", idx, lcl_trans.complete_data_frame[idx]), UVM_LOW)
    end

    // Store to a queue
    vip_tx_trans_q.push_back(lcl_trans);

    //
    convert_and_send();
  endtask

  //------------------------------------------
  //
  //------------------------------------------
  function void write_axi_egress(svt_axi_transaction trans);
    // 
    svt_axi_transaction      lcl_axi_trans;
    svt_ethernet_transaction lcl_eth_trans;
    lcl_axi_trans = new;
    $cast(lcl_axi_trans, trans);
    //
    `uvm_info(get_type_name(), $sformatf("Received AXI trans: \n %s", lcl_axi_trans.sprint()), UVM_LOW)
    //
    conv_axi_to_eth(lcl_axi_trans, lcl_eth_trans);
    // Write transaction out
  endfunction

  //------------------------------------------
  //
  //------------------------------------------
  function void write_vip_debug(svt_ethernet_transaction trans);
    svt_ethernet_transaction lcl_trans;
    //
    lcl_trans = new;
    $cast(lcl_trans, trans.clone());
    //
    $display("AS_DBG_PUSH_DRIVER_VIP_DEBUG: Transaction being pushed to queue");
    vip_debug_trans_q.push_back(lcl_trans);
  endfunction

  virtual function void conv_eth_to_axi(ref svt_ethernet_transaction     eth_trans,
                                        ref svt_axi_master_transaction   axi_trans);
    int unsigned axi_data_width; 
    int unsigned axi_burst_length;
    int unsigned eth_frame_size;
    //
    bit[`SVT_AXI_MAX_TDATA_WIDTH-1:0] lcl_tdata[];
    bit[`SVT_AXI_TKEEP_WIDTH-1:0]     lcl_tkeep[];
    bit[`SVT_AXI_MAX_TUSER_WIDTH-1:0] lcl_tuser[];
    //
    svt_configuration          lcl_cfg;
    svt_axi_port_configuration lcl_port_cfg;


    eth_frame_size = eth_trans.complete_data_frame.size;
    //
    m_env.m_axi_st_env.master[port_num].sequencer.get_cfg(lcl_cfg);
    $cast(lcl_port_cfg, lcl_cfg);
    axi_trans.port_cfg = lcl_port_cfg;
    //
    if(m_env.m_env_config.eth_speed == mux_pkg::_25G) begin
      axi_data_width = 8; // 8 byte = 64 bits
    end
    axi_burst_length = (eth_frame_size%axi_data_width == 0) ? (eth_frame_size/axi_data_width)
                                                            : (eth_frame_size/axi_data_width + 1);
    //
    `uvm_info(get_type_name(), $sformatf("axi_burst_length = %0d", axi_burst_length), UVM_LOW)
    //// //
    //// axi_trans.stream_burst_length = axi_burst_length;
    //// axi_trans.tdata               = new [axi_burst_length];
    //// axi_trans.tkeep               = new [axi_burst_length];
    //// axi_trans.tuser               = new [axi_burst_length];
    //// axi_trans.tvalid_delay        = new [axi_burst_length];
    //
    lcl_tdata = new[axi_burst_length];
    lcl_tkeep = new[axi_burst_length];
    lcl_tuser = new[axi_burst_length];

    //
    for(int unsigned burst_idx=0; burst_idx < axi_burst_length; burst_idx++) begin
      for(int unsigned data_idx=0; data_idx < axi_data_width; data_idx++) begin
        //
        if(burst_idx != (axi_burst_length-1)) begin
          lcl_tkeep[burst_idx] = 8'hFF;
          lcl_tuser[burst_idx] = 'h0; // Fixme: Need more data to drive this
        end
        else begin
          lcl_tkeep[burst_idx] = (8'hFF >> (8 - (eth_frame_size%axi_data_width)));
          lcl_tuser[burst_idx] = 'h0; // Fixme: Need more data to drive this
        end
        lcl_tdata[burst_idx][8*data_idx +: 8] = eth_trans.complete_data_frame[(burst_idx*axi_burst_length) + data_idx];
      end
    end
    //
    axi_trans.randomize() with {
      axi_trans.xact_type == svt_axi_transaction::DATA_STREAM;
      axi_trans.stream_burst_length == axi_burst_length;
      foreach(axi_trans.tdata[i])
      {axi_trans.tdata[i] == lcl_tdata[i];
       axi_trans.tkeep[i] == lcl_tkeep[i];
       axi_trans.tuser[i] == lcl_tuser[i];
       axi_trans.tvalid_delay[i] == 'h0;} 
    };
    //
    `uvm_info(get_type_name(), $sformatf("Converted AXI trans:\n%s", axi_trans.sprint()), UVM_LOW)
  endfunction

  //------------------------------------------
  //
  //------------------------------------------
  virtual function void conv_axi_to_eth(ref svt_axi_transaction          axi_trans,
                                        ref svt_ethernet_transaction     eth_trans);
    // ?? 
  endfunction

endclass : mux_push_driver

`endif // __MUX_PUSH_DRIVER__
