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


class eth_rsfec_error_counter_reset_sequence extends eth_base_sequence;
 uvm_reg 	regs;
 rand int no_of_symbol_corrpt_cnt;
 bit [3:0] symbol_position;
 bit [5:0] group_position;
 int unique_bit;
 string case_no;
 bit success;
 bit [3:0] list_q[$];
 bit [5:0] list_g[$];
 int total_uncorrected_cw;
 int act_uncorrected_cw;
 int symbol_pos[]; 

  `uvm_object_utils(eth_rsfec_error_counter_reset_sequence)

   constraint num_symbol_corr_cnt_c {
    (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) ->  no_of_symbol_corrpt_cnt dist {16:=80, [17:20]:=20};     
    (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) ->  no_of_symbol_corrpt_cnt dist {8:=80, [9:15]:=20};     
    (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC)   ->  no_of_symbol_corrpt_cnt dist {8:=80, [9:15]:=20};     
  }

  function new(string name = "eth_rsfec_error_counter_reset_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();

  if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == NOFEC) begin
     `uvm_info(get_name(),$sformatf("FEC not enabled , sending random traffic"),UVM_NONE);       
     send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,20); 
   end else begin

      send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,2); 
      
      total_uncorrected_cw = 0;
    // disabling the valid ready assertion during the reset
   // when ever we apply reset ready_latency values chenages and this
   // assertion is in gluelogic so we disabling the assertion
   if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin
     uvm_hdl_force("eth_env_top.seg_tx_if_ip0.disable_valid_ready_assertion",1);
   end

   `ifdef ENABLE_ETH_VIP
	 p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_startofpacket(0);
	 p_sequencer.env.ts_tasks_if.set_enable_a_non_missing_endofpacket(0);
   `endif

      //Disabling all scorebord as error injection is uncorrectable
      p_sequencer.env.dynamic_enable_disable_scoreboards(1);
   
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

      if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
         symbol_pos = new[543];
         for(int i =0 ; i <543 ; i++) begin
            symbol_pos[i] = i+1;
         end
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin
         symbol_pos = new[527];
         for(int i =0 ; i <527 ; i++) begin
            symbol_pos[i] = i+1;
         end
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin
         symbol_pos = new[271];
         for(int i =0 ; i <271 ; i++) begin
            symbol_pos[i] = i+1;
         end
      end

      case_no = "case : 1 : ";

         this.randomize();      
         `uvm_info(get_name(), $sformatf(" %s Symbol corruption: no_of_symbol_corrpt_cnt = %0d", case_no,no_of_symbol_corrpt_cnt), UVM_NONE);
         symbol_pos.shuffle();
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
                              /*if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,543);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,527);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,271);
                              end*/
                              p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = symbol_pos[m];
                              end
                 _400G,_200G: begin 
                              /*if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,543);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,527);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,271);
                              end */  
                              p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = symbol_pos[m];
                            end
             endcase      
          end //end for for loop

          total_uncorrected_cw = total_uncorrected_cw + 80;
          `uvm_info(get_name(),$sformatf(" Injecting  total_uncorrectable_cw =%0d",total_uncorrected_cw),UVM_LOW);

          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G) begin
            group_position = $urandom_range(0,32);
            `uvm_info(get_name(), $sformatf("%s corrupt group position = %0d", case_no ,group_position), UVM_NONE);
            p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[group_position] = 1'b1;
          end

          @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
          `uvm_info(get_name(),$sformatf(" waiting for total uncorruted CW count to become %0d",total_uncorrected_cw),UVM_NONE);
          // Spec Limitation: RSFEC SYNC lost will happen if we send more than 2 uncorrupted codewords
           repeat(40) begin
              p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
              repeat(2) @(p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection);
              p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 0;
              repeat(2) @(p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection);
           end
           `uvm_info(get_name(),$sformatf(" wait done for total uncorrupted CW count to become %0d",total_uncorrected_cw),UVM_NONE);  

        end
        join

        p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
        act_uncorrected_cw = read_data; 

        if(total_uncorrected_cw != act_uncorrected_cw) begin
          `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_uncorrected_cw = %0d, act_uncorrected_cw =%0d ",total_uncorrected_cw,act_uncorrected_cw));
        end else begin
          `uvm_info(get_name(),$sformatf(" Matched act_uncorrected_cw with exp_uncorrected_cw "),UVM_NONE);
        end

        //Special check for 200G and 400G
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G) begin
           if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) begin
               p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s4_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
           end else begin
               p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s8_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
           end
           act_uncorrected_cw = read_data; 

           if(total_uncorrected_cw != act_uncorrected_cw) begin
             `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_uncorrected_cw = %0d, act_uncorrected_cw =%0d ",total_uncorrected_cw,act_uncorrected_cw));
           end else begin
             `uvm_info(get_name(),$sformatf(" Matched act_uncorrected_cw with exp_uncorrected_cw "),UVM_NONE);
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

       //Removed case2 & case 3 from C3,  Rollover functionality check for correctable/uncorrectable counter
       //Assumting this should be part of IP level testplan
       //-----------------------------------------------------------------
       //Case - 2 : reset value check of counter , error inject same as case 3 
       //-----------------------------------------------------------------
       case_no = "case : 2 : ";
       `uvm_info(get_name(), $sformatf(" %s  reset value check of counter ", case_no), UVM_NONE);

       p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
       p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));

       //disable VIP checker again due VIP Reset
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);

       program_rsfec_debug_cfg_registers();
       check_rsfec_am_lock();
       read_rsfec_cw_registers();
      
       //-----------------------------------------------------------------
       //Case - 3 : After Reset; Symbol corruption
       //-----------------------------------------------------------------
       case_no = "case : 3 : ";
       `uvm_info(get_name(), $sformatf(" %s  After reset Symbol corruption : no_of_symbol_corrpt_cnt =%0d ", case_no, no_of_symbol_corrpt_cnt), UVM_NONE);
       symbol_pos.shuffle();

       //Turn off HI BER monitor (rxpcs_conf[20]) not requied - Not testing rollover functionlaity

       fork
           begin 
             send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,20); 
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
                              /*if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,543);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,527);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,271);
                              end*/
                              p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = symbol_pos[m];
                              end
                 _400G,_200G: begin 
                              /*if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKP) begin
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,543);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == RSFECKR) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,527);
                              end else if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type == LLFEC) begin  
                                p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = $urandom_range(1,271);
                              end   */
                              p_sequencer.env.mac_rs_fec_err_encoder_callback.local_rs_fec_corrupt_encoder_160bits_error[m] = symbol_pos[m];
                            end
             endcase      
          end //end for for loop

          total_uncorrected_cw = 20;
          `uvm_info(get_name(),$sformatf(" Injecting  total_uncorrectable_cw =%0d",total_uncorrected_cw),UVM_LOW);

          if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _40G) begin
            group_position = $urandom_range(0,32);
            `uvm_info(get_name(), $sformatf("%s corrupt group position = %0d", case_no ,group_position), UVM_NONE);
            p_sequencer.env.mac_rs_fec_err_encoder_callback.local_160bits_error_pos[group_position] = 1'b1;
          end

          @p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection;
          `uvm_info(get_name(),$sformatf(" waiting for total uncorruted CW count to become %0d",total_uncorrected_cw),UVM_NONE);
          // Spec Limitation: RSFEC SYNC lost will happen if we send more than 2 uncorrupted codewords
           repeat(10) begin
              p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 1;
              repeat(2) @(p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection);
              p_sequencer.env.mac_rs_fec_err_encoder_callback.error_injection_enable = 0;
              repeat(2) @(p_sequencer.env.mac_rs_fec_err_encoder_callback.group_error_injection);
           end
           `uvm_info(get_name(),$sformatf(" wait done for total uncorrupted CW count to become %0d",total_uncorrected_cw),UVM_NONE);  

        end
        join
   
        p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
        act_uncorrected_cw = read_data; 

        if(total_uncorrected_cw != act_uncorrected_cw) begin
          `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_uncorrected_cw = %0d, act_uncorrected_cw =%0d ",total_uncorrected_cw,act_uncorrected_cw));
        end else begin
          `uvm_info(get_name(),$sformatf(" Matched act_uncorrected_cw with exp_uncorrected_cw "),UVM_NONE);
        end

        //Special Check for 200G and 400G
        if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G || p_sequencer.env.dyn_rcfg_obj_inst.speed == _400G) begin
           if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _200G) begin
               p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s4_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
           end else begin
               p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s8_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
           end
           act_uncorrected_cw = read_data; 

           if(total_uncorrected_cw != act_uncorrected_cw) begin
             `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_uncorrected_cw = %0d, act_uncorrected_cw =%0d ",total_uncorrected_cw,act_uncorrected_cw));
           end else begin
             `uvm_info(get_name(),$sformatf(" Matched act_uncorrected_cw with exp_uncorrected_cw "),UVM_NONE);
           end
        end

        //Not enabling scoreboard (DUT will not send traffic if o_rx_hi_ber set to 1)    
        //uncorrectable CWS will set o_rx_hi_ber as 1 ( if ber_count > 'd97)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_ENABLE_ALL_RULE,1);
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b111);
   
        send_eth_frame(RANDOM_FRAME,ETH_VIP_MAC_BOTH,5); 
        #200ns;
   
        check_rsfec_am_lock();
        read_rsfec_cw_registers();

        p_sequencer.env.reg_read(p_sequencer.env.gdr_ral_offset("fec_stats_e25g_stat_s0_rsfec_uncorr_cw_cnt_lo"),read_data,1); 
        act_uncorrected_cw = read_data; 

        if(total_uncorrected_cw != act_uncorrected_cw) begin
          `uvm_error(get_name(),$sformatf("Mismatch for corrected CW : total_uncorrected_cw = %0d, act_uncorrected_cw =%0d ",total_uncorrected_cw,act_uncorrected_cw));
        end else begin
          `uvm_info(get_name(),$sformatf(" Matched act_uncorrected_cw with exp_uncorrected_cw "),UVM_NONE);
        end
   
    end

 endtask
endclass
