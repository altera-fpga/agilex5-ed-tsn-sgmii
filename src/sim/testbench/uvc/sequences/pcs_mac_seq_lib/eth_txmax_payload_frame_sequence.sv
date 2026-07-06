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


class eth_txmax_payload_frame_sequence extends eth_base_sequence;
  alt_eth_avalonst_custom_sequence avl_tx_pkt;
  uvm_reg_data_t read_data,cfg_payload_size,tx_max_read_data;
  int frame_count = 0;

  `uvm_object_utils(eth_txmax_payload_frame_sequence)
  
  function new(string name = "eth_txmax_payload_frame_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();

    
    `uvm_info("eth_txmax_payload_frame_sequence", "Executing eth_txmax_payload_frame_sequence ...", UVM_LOW)
    `ifdef ENABLE_ETH_VIP
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
     p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_read_data);
    
    if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
    end
    else begin
        `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
    end
    
    avl_tx_pkt.byte_count = $urandom_range(46,tx_max_read_data);
    frame_count++;
    `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) 
        avl_tx_pkt.start(p_sequencer.v_m_sqr);
    else
        avl_tx_pkt.start(p_sequencer.tx_seqr);
    #100ns;

    if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
    end
    else begin
    `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
    end
    avl_tx_pkt.byte_count = $urandom_range(tx_max_read_data,tx_max_read_data+100);
    frame_count++;
    `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) 
        avl_tx_pkt.start(p_sequencer.v_m_sqr);
    else
    avl_tx_pkt.start(p_sequencer.tx_seqr);
    p_sequencer.env.wait_tx_frames_received(.exp_num(frame_count),.timeout_time(1ms));
    read_registers();


    //to reduce simulation time, not running it for 10M and 100M
    if(!(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M} )) begin
       for(int i=0;i<2;i++) 
       begin
         cfg_payload_size  = $urandom_range(64,'hFFF0);
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
         p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_read_data);
        
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
           `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
         end
         else begin
         `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
         end
         avl_tx_pkt.byte_count = $urandom_range(tx_max_read_data - 50,tx_max_read_data);
         frame_count++;
         `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
          if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) 
            avl_tx_pkt.start(p_sequencer.v_m_sqr);
          else
            avl_tx_pkt.start(p_sequencer.tx_seqr);
         read_registers();
         
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
           `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
         end
         else begin
         `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
         end
         
         avl_tx_pkt.byte_count = $urandom_range(tx_max_read_data,tx_max_read_data + 10);
         frame_count++;
         `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) 
           avl_tx_pkt.start(p_sequencer.v_m_sqr);
         else
           avl_tx_pkt.start(p_sequencer.tx_seqr);
         read_registers();
       end

       for(int m='hFFF0;m<'hFFFF;m++)
       begin
         cfg_payload_size = m;
         p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),cfg_payload_size);
         p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_read_data);

         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
           `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
         end
         else begin
         `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
         end
         avl_tx_pkt.byte_count = $urandom_range(m-10,m);
         frame_count++;
         `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) 
           avl_tx_pkt.start(p_sequencer.v_m_sqr);
         else
           avl_tx_pkt.start(p_sequencer.tx_seqr);
         read_registers();
         
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
           `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
         end
         else begin
         `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
         end
         avl_tx_pkt.byte_count = $urandom_range(m,'hFFFF);
         frame_count++;
         `uvm_info(get_name(),$sformatf("Frame No. : %0d , payload_size = %0d",frame_count,avl_tx_pkt.byte_count),UVM_NONE)
         if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) 
           avl_tx_pkt.start(p_sequencer.v_m_sqr);
         else
           avl_tx_pkt.start(p_sequencer.tx_seqr);
         read_registers();
       end
    end

    `uvm_info("eth_txmax_payload_frame_sequence", "Exiting eth_txmax_payload_frame_sequence ...", UVM_LOW)
  endtask
  
  task read_registers();
    #2000ns; // Need this delay to make sure all packets are processed in RTL/Ref. Model before read.  
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  endtask

endclass
