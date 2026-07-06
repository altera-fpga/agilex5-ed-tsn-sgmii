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


class eth_short_frame_test_sequence extends eth_stat_base_sequence;

  `uvm_object_utils(eth_short_frame_test_sequence)
  uvm_reg 	regs_1[$];
  uvm_reg 	select_reg_1[$];
  bit [31:0] read_data_1[$];
  bit temp;
  bit temp_1;
  int itr_cnt;
  int loop_cnt;
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
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   
     
   itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 1:5;
   loop_cnt = $urandom_range(5,10);
   #800ns;
   read_and_compare_stats(0);
   p_sequencer.reg_model.default_map.get_registers(regs_1);
   foreach(regs_1[i]) begin
     read_data_1[i] = regs_1[i].get_mirrored_value();
   end


   repeat(itr_cnt) begin
    fork
       begin
        repeat(loop_cnt) begin
         randcase
           1:send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,ETH_VIP_AVL_RX);
           1:send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(64,150),1,ETH_VIP_AVL_RX);
         endcase
        end
        temp = 1;
       end  
       begin
        repeat(loop_cnt) begin
          randcase
            1:send_eth_frame_with_fix_size(UNDERSIZE_FRAME,-1,1,AVL_TX_ETH_VIP);
            1:send_eth_frame_with_fix_size(DATA_FRAME,$urandom_range(64,150),1,AVL_TX_ETH_VIP);
          endcase  
         end
        temp_1 = 1;
       end
   //    begin
   //     while(temp==0&&temp_1==0) begin
   //     //  read_and_compare_stats_in_between(0);
   //     end
//       end  
    join
    temp = 0;
    temp_1 = 0;
   end
   #900ns;
   p_sequencer.env.wait_client_rx_frames_done(.exp_num(itr_cnt*loop_cnt),.timeout_time(1ms));
   p_sequencer.env.wait_tx_frames_received(.exp_num(itr_cnt*loop_cnt),.timeout_time(1ms));
   
   p_sequencer.env.eth_ref_model_inst.predict_stats_registers();
  `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,3);  
 `endif
   $display("end eth_short_frame_test_sequence");
    // Read all stats registers.
    read_and_compare_stats();
   
  endtask

/* task reg_read_in_between(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit disable_check=0);
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
   */

/*task reg_read_in_between(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf,bit[31:0]data_expected=0);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   altuvm_avalon_mm_read_seq           read_seq;
   bit [31:0] rsvd_val = 'd0;
   int masked_val;
   bit[31:0] byte_en_mask;
   uvm_reg_data_t mir_data;
   
   select_reg = p_sequencer.reg_model.default_map.get_reg_by_offset(addr);

    // if ((select_reg != null) && (byte_enable == 'hf))
	if( select_reg != null) begin
        $display("INFO->Checking after read task call");
        
        mir_data = select_reg.get_mirrored_value();

        read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
        read_seq.set_sequencer( p_sequencer.env.virtual_sequencer_inst.status_seqr);
        read_seq.randomize() with {
              init_latency inside {[0:3]};
              address   == {addr, 2'b00};
              foreach (byteenable[i]) byteenable[i] == byte_enable[i];
           }; 

        `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable '%p,mir_data:%0h ",select_reg.get_name(),addr,byte_enable,mir_data), UVM_NONE)
        read_seq.start(p_sequencer.env.virtual_sequencer_inst.status_seqr);
  
        read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
        
        if(byte_enable=='h0) begin
          `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable 'h0 ",select_reg.get_name(),addr), UVM_NONE)
          byte_enable='hf;
        end

        for(int i=0;i<4;i++) byte_en_mask[((8*(i+1))-1) -: 8] = byte_enable[i]?'hff:'h0;
        mir_data = mir_data & byte_en_mask ;

        //Coverage sample only for stat registers
        if(addr inside {['h800:'h835],['h860:'h863],['h900:'h935],['h960:'h963]})
          select_reg.sample_values();

        // disable_check is 2 bit variable for read comparision where 0=normal_check; 1=disable_check; 2=WO masked check; 3=both WO & RO masked check
        if(disable_check == 0)begin
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register(%s) address 'h%0h expected data : 'h%0h actual read data :'h%0h ",select_reg.get_name(),addr,mir_data,read_data), UVM_NONE)
          if(mir_data <= read_data)
            `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED IN BETWEEN READ] Match - Register(%s) address 'h%0h expected data : 'h%0h actual read data :'h%0h",select_reg.get_name(),addr,mir_data,read_data), UVM_NONE)
          else`uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else if(disable_check == 2)begin
          masked_val=p_sequencer.env.set_masked_val(addr,0);
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED & WO MASK enabled] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h masked_val : 'h%0h",select_reg.get_name(),addr,read_data,mir_data,masked_val), UVM_NONE)
          if((mir_data & masked_val) != read_data)
            `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else if(disable_check == 3)begin
          masked_val=p_sequencer.env.set_masked_val(addr,2);
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED & b/WO/RO MASK enabled] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h masked_val : 'h%0h",select_reg.get_name(),addr,read_data,mir_data,masked_val), UVM_NONE)
          if((mir_data & masked_val) != (read_data & masked_val))
            `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else begin
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] Register(%s) address 'h%0h actual read data :'h%0h",select_reg.get_name(),addr,read_data), UVM_NONE)
        end
    end
   else //select_reg == null
    begin
        $display("INFO-> Register not present in RAL Checking INSIDE selcet_reg is null read env task Attributes");
       `uvm_warning("AVMM REG READ", $sformatf("No Register found with address :%0h,it seems reserved space",addr));
       read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
       read_seq.set_sequencer( p_sequencer.env.virtual_sequencer_inst.status_seqr );
       read_seq.randomize() with {
             init_latency inside {[0:3]};
             address   =={ addr,2'b00};
             foreach (byteenable[i]) byteenable[i] == 1;
          }; 
       read_seq.start(p_sequencer.env.virtual_sequencer_inst.status_seqr);
  
       read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
        $display("INFO->Checking read_data_value=%0h,addr=%0h,data_expected=%0h",read_data,addr,data_expected);

       if(disable_check == 0) begin
          rsvd_val = data_expected;
          if(rsvd_val != read_data)
            `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val))
          else 
            `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val), UVM_NONE)
       end
    end
 endtask
 */


   task read_and_compare_stats_in_between(input bit disable_check=0);
#2000ns;
/*
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
   */
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);

   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(rx_stats_framesOK0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(rx_stats_framesOK1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(rx_stats_framesErr0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(rx_stats_framesErr1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(tx_stats_framesOK0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(tx_stats_framesOK1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(tx_stats_framesErr0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(tx_stats_framesErr1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(tx_stats_ifErrors0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(tx_stats_ifErrors1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(rx_stats_ifErrors0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);
   p_sequencer.env.reg_read_in_between(`GET_REG_ADDR(rx_stats_ifErrors1_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,disable_check);   
 endtask : read_and_compare_stats_in_between
  
endclass:eth_short_frame_test_sequence
