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


class preamble_and_crc_pass_sequence_cov extends eth_base_sequence;
  
    preamble_sequence tx_seq;
    bit preamble_pass;
    bit rx_crc;
    bit [47:0] src_address;
    
    uvm_reg_data_t rd_data;
    uvm_reg_data_t txmac_ehip_cfg;
    uvm_reg_data_t rxmac_ehip_cfg;
  
    `uvm_object_utils(preamble_and_crc_pass_sequence_cov)
  
    function new(string name = "seq_0");
       super.new(name);
       `ifdef UVM_POST_VERSION_1_1
           set_automatic_phase_objection(1);
       `endif
       tx_seq=new("tx_seq");  
    endfunction:new

    virtual task body();
       `uvm_info(get_full_name(), "running preamble_and_crc_pass_sequence_cov\n",UVM_LOW)

       `ifdef ENABLE_ETH_VIP
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE); 
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
        p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `endif
       
        if(p_sequencer.env.dyn_rcfg_obj_inst.sa==1) begin
          src_address = $random();
          src_address[40]=0;
          $display("Source address %0h",src_address);
          p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[31:0]);
          p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[47:32]);
       end
      
       //reduce simulation time for 10M and 100M 
       if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
          prog_reg();
       `ifdef ENABLE_ETH_VIP
          fork
            send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,5);  
            send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,5);  
          join
          p_sequencer.env.wait_client_rx_frames_done(.exp_num(5),.timeout_time(1ms));
          p_sequencer.env.wait_tx_frames_received(.exp_num(5),.timeout_time(1ms)); 
        `endif
       end else begin     
       
         `ifdef ENABLE_ETH_VIP
           `uvm_info ("preamble_and_crc_pass_sequence_cov","Starting the traffic",UVM_LOW)
           
            repeat (4) begin
              prog_reg();
              fork
               begin
                 if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG)
                   tx_seq.start(p_sequencer.v_m_sqr);
                 else 
                   tx_seq.start(p_sequencer.tx_seqr);
               end
               begin
                 send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,50);  
               end
              join
            end
         `else
             prog_reg();
             if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG)
	         tx_seq.start(p_sequencer.v_m_sqr);
             else 
               tx_seq.start(p_sequencer.tx_seqr);
         `endif
       end 
   endtask

task prog_reg();

    preamble_pass = 0;
    p_sequencer.env.reg_read(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    txmac_ehip_cfg = {rd_data[31:1],preamble_pass};
    p_sequencer.env.reg_read(`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    rxmac_ehip_cfg = {rd_data[31:1],preamble_pass};
    // programing crc value 0,1 randomly
    p_sequencer.env.reg_read(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rd_data,1);
    if(rd_data[1] == 0)
     begin
     rx_crc = $urandom_range(0,1);
     p_sequencer.env.reg_write(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc); 
     p_sequencer.env.dyn_rcfg_obj_inst.crc_pass = rx_crc;
     end
   
    `uvm_info("preamble_sequence", $sformatf("Setting %0d to RX,TX Preamble pass",preamble_pass), UVM_MEDIUM)
    p_sequencer.env.reg_write(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),txmac_ehip_cfg); 
    p_sequencer.env.reg_write(`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rxmac_ehip_cfg);

endtask
endclass


