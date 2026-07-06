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


class eth_rxmax_payload_frame_sequence extends eth_base_sequence;
  alt_eth_vip_custom_sequence eth_seq;
  uvm_reg_data_t read_data,cfg_payload_size,rx_max_read_data;
  int frame_count = 0;
  
  `uvm_object_utils(eth_rxmax_payload_frame_sequence)
  
  function new(string name = "eth_rxmax_payload_frame_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();

    
    `uvm_info("eth_rxmax_payload_frame_sequence", "Executing eth_rxmax_payload_frame_sequence ...", UVM_LOW)
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   // p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
   // read_data[7]=0;//$urandom_range(0,1); // writing 0 to make sequence pass
   // `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL : enforce max rx = %0b",read_data[7]), UVM_NONE)
   // p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);
    `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
    eth_seq.payload_length = $urandom_range(46,rx_max_read_data);
    frame_count++;
    `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
    eth_seq.start(p_sequencer.eth_vip_seqr_inst);

    `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
    eth_seq.payload_length = $urandom_range(rx_max_read_data,rx_max_read_data+100);
    frame_count++;
    `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
    eth_seq.start(p_sequencer.eth_vip_seqr_inst);
    p_sequencer.env.wait_client_rx_frames_done(.exp_num(frame_count),.timeout_time(1ms));
    read_registers();

    //Simulation time reduction for 10M and 100M
    if(!(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M} )) begin
      for(int i=0;i<2;i++) 
      begin
        cfg_payload_size  = $urandom_range(64,'hFFF0);
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
        p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);
       
        `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
        eth_seq.payload_length = $urandom_range(rx_max_read_data - 50,rx_max_read_data);
        frame_count++;
        `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
        eth_seq.start(p_sequencer.eth_vip_seqr_inst);
        read_registers();
        
        `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
        eth_seq.payload_length = $urandom_range(rx_max_read_data,rx_max_read_data + 10);
        frame_count++;
        `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
        eth_seq.start(p_sequencer.eth_vip_seqr_inst);
        read_registers();
      end

      for(int m='hFFF0;m<'hFFFF;m++)
      begin
        cfg_payload_size = m;
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
        p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);

        `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
        eth_seq.payload_length = $urandom_range(m-10,m);
        frame_count++;
        `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
        eth_seq.start(p_sequencer.eth_vip_seqr_inst);
        read_registers();
        
        `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
        eth_seq.payload_length = $urandom_range(m,'hFFFF);
        frame_count++;
        `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
        eth_seq.start(p_sequencer.eth_vip_seqr_inst);
        read_registers();
      end
    end

    /*
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
    read_data[7]= 1;
    `uvm_info("eth_stat_base_sequence", $psprintf("Writing RXMAC_CONTROL : enforce max rx = %0b",read_data[7]), UVM_NONE)
    p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

    repeat(10) begin
      cfg_payload_size = $urandom_range('hFFF0,'hFFFF);
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
      p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_read_data);

      `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
      eth_seq.payload_length = $urandom_range(cfg_payload_size + 1,cfg_payload_size + 1000);
      frame_count++;
      `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,eth_seq.payload_length),UVM_NONE)
      eth_seq.start(p_sequencer.eth_vip_seqr_inst);
      read_registers();
    end
    */
   
   
    `uvm_info("eth_rxmax_payload_frame_sequence", "Exiting eth_rxmax_payload_frame_sequence ...", UVM_LOW)
  endtask

  task read_registers();
    #2000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  endtask

endclass
