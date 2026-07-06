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


class eth_read_in_between_test_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_read_in_between_test_sequence)
   uvm_reg 	regs_1[$];
   uvm_reg 	select_reg_1[$];
  bit [31:0] read_data_1[$];
  bit temp;
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
   super.body();
 `ifdef ENABLE_ETH_VIP
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_flowcontrol_rsvrd_fields_within_paus_frame_not_zeroes.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   
    fork
      begin
        send_random_frames($urandom_range(50,100));
	    end  
      begin
        //read_and_compare_stats(1);//disable_check = 1 for register read
	    end  
    join
    #900ns;
    //muralasx: FIXME fix registers in below method, as GDR reg_model is not ready. 
    read_and_compare_stats(0);
    p_sequencer.reg_model.default_map.get_registers(regs_1);
    foreach(regs_1[i]) begin
      read_data_1[i] = regs_1[i].get_mirrored_value();
    end
    repeat(3) begin
     fork
        begin
          send_random_frames($urandom_range(20,30));
          temp = 1;
	      end  
        begin
          while(temp==0) begin
            read_and_compare_stats_in_between(0);
          end
	      end  
     join
     temp = 0;
    end
    #900ns;
    p_sequencer.env.eth_ref_model_inst.predict_stats_registers();
  `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
 `endif
   $display("end eth_read_in_between_test_sequence");
   
  endtask

  task reg_read_in_between(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit disable_check=0);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   bit reg_not_found =1;
   altuvm_avalon_mm_read_seq           read_seq;
   bit [31:0] rsvd_val = 'd3735929054;
   p_sequencer.reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
     if (addr == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;
       select_reg.read(status,.value(read_data), .map(p_sequencer.reg_model.default_map));
       if(disable_check == 0)begin
         `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg.get_name(),addr,read_data_1[i],read_data), UVM_NONE)
         if(read_data_1[i] <= read_data) begin
         `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Register(%s) address 'h%0h actual read data :'h%0h",select_reg.get_name(),read_data_1[i],read_data), UVM_NONE)
         end
         else begin
           `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
         end
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("AVMM REG READ", $sformatf("No Register found with address :%0h,it seems reserved space",addr));
     read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
     `uvm_do_on_with(read_seq, p_sequencer.status_seqr, {
           init_latency inside {[0:3]};
           address   == addr << 2;
           foreach (byteenable[i]) byteenable[i] == 1;
        })
     
     read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};

     if(disable_check == 0)
     begin
      if(rsvd_val != read_data)
        `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val))
      else 
        `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val), UVM_NONE)
     end
   end
   endtask

   task read_and_compare_stats_in_between(input bit disable_check=0);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

 endtask : read_and_compare_stats_in_between
  
endclass:eth_read_in_between_test_sequence
