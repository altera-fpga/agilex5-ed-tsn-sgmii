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


class eth_rsfec_correctable_codeword_sequence extends eth_base_sequence;
 
 uvm_reg 	regs;
 rand int no_of_symbol_corrpt_cnt;
 bit [3:0] symbol_position;
 bit [5:0] group_position;
 int unique_bit,group_cnt;
 string case_no;
 bit success;
 bit [3:0] list_q[$];
 bit [5:0] list_g[$];
 int total_corrected_cw=0;
 int act_corrected_cw;

  `uvm_object_utils(eth_rsfec_correctable_codeword_sequence)

  constraint num_symbol_corr_cnt_c {
    (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) ->  no_of_symbol_corrpt_cnt dist {[1:14]:=60, 15:=40};     
    (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) ->  no_of_symbol_corrpt_cnt dist {[1:6]:=60,   7:=40};     
    (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC)   ->  no_of_symbol_corrpt_cnt dist {[1:6]:=60,   7:=40};     
  }

  function new(string name = "eth_rsfec_correctable_codeword_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();

   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G ) begin
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_up_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_400g_pcs_invalid_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
   end else begin
       p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
   end

   if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC) begin
     `uvm_info(get_name(),$sformatf("FEC not enabled , sending random traffic"),UVM_NONE);       
     send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,20); 
   end else begin
   
     for(int i = 0; i < 2; i++) begin

        this.randomize();

        `uvm_info(get_name(), $sformatf(" Symbol corruption itr_no : %0d no_of_symbol_corrpt_cnt = %0d", i,no_of_symbol_corrpt_cnt), UVM_NONE);
       
        fork
        begin
          send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,50); 
        end
        begin
          p_sequencer.env.mac_rs_fec_err_encoder_callback.no_of_symbol_corrpt_cnt = no_of_symbol_corrpt_cnt;
          for(int m=0;m<no_of_symbol_corrpt_cnt;m++) begin
             
             case (p_sequencer.env.dyn_rcfg_obj_inst.speed)
               _100G,_40G : begin
                            success = std::randomize (symbol_position) with {unique{symbol_position,list_q};};
                            if(!success) `uvm_error(get_name(), $sformatf("randomisarion failed"));
                            list_q.push_back(symbol_position);
                            `uvm_info(get_name(), $sformatf("corrupt symbol position = %0d", symbol_position), UVM_NONE);
                            p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[symbol_position] = $urandom_range(1,'h3FF);
                            end
               _25G,_50G  : begin 
                              if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,543);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,527);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,271);
                              end
                            end
               _400G,_200G: begin 
                              if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,543);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,527);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,271);
                              end   
                            end
             endcase      
          end //end for for loop

           total_corrected_cw = total_corrected_cw + 50;
          `uvm_info(get_name(),$sformatf(" Injecting  total_correctable_cw =%0d",total_corrected_cw),UVM_LOW);

          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G) begin
            group_position = $urandom_range(0,32);
            `uvm_info(get_name(), $sformatf("%s corrupt group position = %0d", case_no ,group_position), UVM_NONE);
            p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[group_position] = 1'b1;
            @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
            p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
          end else begin
            @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
             p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
          end

          if(i == 0) begin
            `uvm_info(get_name(),$sformatf(" waiting for total corruted CW count to become 50"),UVM_NONE); 
             wait(p_sequencer.env.mac_rs_fec_err_encoder_callback.num_cws_corrupted == 50);
            `uvm_info(get_name(),$sformatf(" wait done for total corrupted CW count to become 50"),UVM_NONE);      
          end else if (i == 1) begin
            `uvm_info(get_name(),$sformatf(" waiting for total corruted CW count to become 100"),UVM_NONE); 
             wait(p_sequencer.env.mac_rs_fec_err_encoder_callback.num_cws_corrupted == 100);
            `uvm_info(get_name(),$sformatf(" wait done for total corrupted CW count to become 100"),UVM_NONE);       
          end
          p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 0;      

        end
        join

        p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_corr_cw_cnt_lo"),read_data,1); 
        act_corrected_cw = read_data; 

        if(total_corrected_cw != act_corrected_cw) begin
          `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_corrected_cw = %0d, act_corrected_cw =%0d ",total_corrected_cw,act_corrected_cw));
        end else begin
          `uvm_info(get_name(),$sformatf(" Matched act_corrected_cw with total_corrected_cw "),UVM_NONE);
        end

        //Special check for 200G & 400G
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G) begin
          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) begin
             p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s4_rsfec_corr_cw_cnt_lo"),read_data,1); 
          end else begin
             p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s8_rsfec_corr_cw_cnt_lo"),read_data,1); 
          end
          
          act_corrected_cw = read_data; 
 
          if(total_corrected_cw != act_corrected_cw) begin
            `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_corrected_cw = %0d, act_corrected_cw =%0d ",total_corrected_cw,act_corrected_cw));
          end else begin
            `uvm_info(get_name(),$sformatf(" Matched act_corrected_cw with total_corrected_cw "),UVM_NONE);
          end
        end

        check_rsfec_am_lock();
     
        read_rsfec_cw_registers();
     
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G) begin
          list_q = {}; 
          for(int m=0;m<16;m++) begin
            p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = 'h000; 
          end
          for(int m=0;m<33;m++) begin
            p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[m] = 1'b0;
          end
       end   

     end // end for iter  i
   end

 endtask
endclass   
