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


class vip_decoder_rand_sequence extends vip_error_base_sequence;
      
   `uvm_object_utils(vip_decoder_rand_sequence)
     alt_eth_error_vip_base_sequence err_seq;

   randc int ifg_value;
   int ifg_mac_tx;
   int num_frames;

   function new(string name = "vip_decoder_rand_sequence");
      super.new(name);
  `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
  `endif
   endfunction:new

   virtual task body();
      uvm_reg_data_t read_data; 
      
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

      ////////------------send traffic on Both sides with 10 frames and wait for traffic done.--------------------------////////////
      send_eth_frame(DATA_FRAME,ETH_VIP_MAC_BOTH,5);
      wait(p_sequencer.env.sb_mac_tx_vip_rx.rx_pkt_cnt==5); 
      wait(p_sequencer.env.sb_vip_tx_mac_rx.rx_pkt_cnt==5);

      // disable VIP TX checker
      //Since we are inserting the exception from tx side disabling the checkers 
       p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
        //bit 0: (set t0 0 to disable checker on tx side)
        //bit 1: (set t0 0 to disable checker on rx side)
        //bit 2: (set t0 0 to disable checker on checker arbiter)
        p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011); 
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


      exception = new();
      `uvm_info("vip_decoder_mixed_seq", $sformatf("check speed =%0d",p_sequencer.env.dyn_rcfg_obj_inst.speed), UVM_MEDIUM)
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed ==_200G || p_sequencer.env.dyn_rcfg_obj_inst.speed ==_400G )
      begin
       exception.error_kind = svt_ethernet_transaction_exception::BASER_WITH_RS_ERROR_KIND;
      `uvm_info("vip_decoder_mixed_seq", $sformatf("Exception added error_kind =%s ",exception.error_kind.name()), UVM_MEDIUM)
      end else begin
       exception.error_kind = svt_ethernet_transaction_exception::BASER_100G_ERROR_KIND;
      `uvm_info("vip_decoder_mixed_seq", $sformatf("Exception added error_kind =%s ",exception.error_kind.name()), UVM_MEDIUM)
      end
      
      
     // calling the exception task which contains 65 exceptions
      create_pcs_encoded66_exceptions(exception);

      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M}) begin
          num_frames = 10;    
      end else begin
          num_frames = 100;    
      end

    fork //Send parallel traffic 
     begin //T1
        for(int i =0; i<2; i++)
        begin
          randomize(ifg_value) with {(ifg_value inside {40,70}); };
          `uvm_info("vip_decoder_mixed_seq", $sformatf("ifg_value generated =%d",ifg_value), UVM_MEDIUM)
           `uvm_create_on(err_seq,p_sequencer.eth_vip_seqr_inst)
           err_seq.send_error_frame(.exception_list(exception_list),.no_of_frames(num_frames),.frame_size_min(frame_size_min),.frame_size_max(frame_size_max),.one_exception(1'b1),.ifg(ifg_value),.en_short_packet(en_short_packet));
           #200ns;
           p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.env.eth_ref_model_inst.vip_tx_count-p_sequencer.env.eth_ref_model_inst.drop_count),.timeout_time(frame_timeout_time));
           #400ns;
           `uvm_info("body", "Exiting ...", UVM_MEDIUM);
        end // for loop
     end //T1
     begin//T2 
      eth_packet req_mac;
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin 
          `uvm_create_on(req_mac, p_sequencer.v_m_sqr);
       end else begin 
           `uvm_create_on(req_mac, p_sequencer.tx_seqr);
       end
       for(int i = 0; i <= (num_frames/2); i++) begin
	      ifg_mac_tx = $urandom_range(25,50);
          `uvm_info("vip_decoder_mixed_seq", $sformatf("ifg_mac_tx generated =%d",ifg_mac_tx), UVM_MEDIUM)
          req_mac.payload_size_c.constraint_mode(0);
          req_mac.interpacket_gap_c.constraint_mode(0);
          req_mac.skip_tx_crc_insertion_c.constraint_mode(0);
          `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME;frame_payload_type == NORMAL; payload.size == 'd46; interpacket_gap ==ifg_mac_tx ;num_words == 4; skip_tx_crc_insertion ==1;})
       end 
    end//T2
  join
  
  // wait_client_rx_frame task terminates before VIP transmits all packets for 10m due to this will see 1 More TX than RX error
  if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_10M,_100M})begin
      #100us;    
  end

   endtask // body


 virtual task create_pcs_encoded66_exceptions(svt_ethernet_transaction_exception local_exception_seq);
   //#1 INSERT_SYNC_HEADER - 2'b10 - INSERT_ERR_BEFORE_START_FRAME
    exception_list = new("exception_list", exception);
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b10;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);
      `uvm_info("vip_decoder_mixed_seq", $sformatf("Exception added error_kind local =%s",  local_exception_seq.error_kind.name()), UVM_MEDIUM)
      `uvm_info("vip_decoder_mixed_seq", $sformatf("Exception added error_kind  inside_task =%s ",exception.error_kind.name()), UVM_MEDIUM)
    
    
   //#2 INSERT_SYNC_HEADER = 2'b10 - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b10;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);      

   //#3 INSERT_SYNC_HEADER - 2'b00 - INSERT_ERR_IN_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b00;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);

   //#4 INSERT_SYNC_HEADER - 2'11 - INSERT_ERR_IN_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b11;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);


   //#5 INSERT_SYNC_HEADER - 2'b00 - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b00;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#6 INSERT_SYNC_HEADER - 2'b11 - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b11;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#7 INSERT_SYNC_HEADER- 2'b00- INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b00 ;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#8 INSERT_SYNC_HEADER- 2'b11- INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b11;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#9 INSERT_SYNC_HEADER- 2'b00- INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b00 ;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#10 INSERT_SYNC_HEADER- 2'b11- INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_SYNC_HEADER;
    exception.baser_encoder_insert_sync_header_error = 2'b11;
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#11 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom(),{8'h4B}} - INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#12 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom(),{8'h4B}} -  INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);


   //#13 REPLACE_66B_ENCODED_DATA -  1E1E1E1E_1E1E1E1E  data INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h1e},{8'h1e},{8'h1e},{8'h1e},{8'h1e},{8'h1e},{8'h1e},{8'h1e}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#14 REPLACE_66B_ENCODED_DATA -  {$urandom, 1E}) data INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),{8'h1e}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#15 REPLACE_66B_ENCODED_DATA - {8'h0,0,0,0,1,0,8'h0,8'h4B}  data INSERT_ERR_AFTER_TRN_FRAME/ 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h0},{8'h0},{8'h0},{8'h0},{8'h1},{8'h0},{8'h0},{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME; 
    exception_list.add_exception(exception);

   //#16 REPLACE_66B_ENCODED_DATA - {8'h0,0,0,0,1,0,8'h0,8'h4B}  data INSERT_ERR_AFTER_TRN_FRAME/ 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h0},{8'h0},{8'h0},{8'h0},{8'h1},{8'h0},{8'h0},{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);


   //#17 REPLACE_66B_ENCODED_DATA - {$urandom, 8'4B} data INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME; 
    exception_list.add_exception(exception);

   //#18 REPLACE_66B_ENCODED_DATA - {$urandom, 8'4B} data INSERT_ERR_BEFORE_START_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);


   //#19 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#20 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#21 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#22 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#23 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hB4}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hB4}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#24 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hB4}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hB4}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#25 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#26 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#27 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#28 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#29 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#30 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#31 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF}} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#32 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#33 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h33} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h33}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#34 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h66} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h66}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#35 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h99} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h99}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#36 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h2D} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h2D}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

    //#37 REPLACE_72B_DATA_CONTROL - {1'b0,$urandom_range(0,255)} -  INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_72B_DATA_CONTROL;
    exception.baser_encoder_replace_72b_data_control0_error = {1'b0,$urandom_range(0,255)};      
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

   //#38 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h33} - INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h33}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#39 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h55} - INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h55}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#40 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h66} - INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h66}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#41 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h99} - INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h99}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

   //#42 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom(),8'h2D} - INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h2D}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

    //#43 REPLACE_72B_DATA_CONTROL - {1'b0,$urandom_range(0,255)} -  INSERT_ERR_AFTER_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_72B_DATA_CONTROL;
    exception.baser_encoder_replace_72b_data_control0_error = {1'b0,$urandom_range(0,255)};      
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

    //#44 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom()} - INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

    //#45 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom()} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

    //#46 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}- INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

    //#47 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

    //#48 REPLACE_66B_ENCODED_DATA - {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}}- INSERT_ERR_AFTER_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_AFTER_TRN_FRAME;
    exception_list.add_exception(exception);

    //#49 REPLACE_66B_ENCODED_DATA -{{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_BEFORE_START_FRAME;
    exception_list.add_exception(exception);

    //#50 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom(),{8'h1e}}- INSERT_ERR_IN_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h1e}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);

    //#51    REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom(),{8'h4b}}- INSERT_ERR_IN_TRN_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4b}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);

    //#52 REPLACE_66B_ENCODED_DATA -{{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}} - INSERT_ERR_BEFORE_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);

   //#53 REPLACE_66B_ENCODED_DATA -{{8'hd5},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h55},{8'h78}} - INSERT_ERR_IN_TRN_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);

    //#54 REPLACE_66B_ENCODED_DATA -  {$urandom(),$urandom()}- INSERT_ERR_IN_TRN_FRAM
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_TRN_FRAME;
    exception_list.add_exception(exception);

    //#55 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom(),{8'h1e}}  - INSERT_ERR_IN_START_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h1e}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

    //#56 REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom(),{8'h4b}}- INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom(),{8'h4b}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#57 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h87}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#58 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h99}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#59 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hAA}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#60 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h4B} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h4B}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#61 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hCC}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#62 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hD2}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#63 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hE1}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#64 REPLACE_66B_ENCODED_DATA - {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF} - INSERT_ERR_IN_START_FRAME
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'h07},{8'hFF}};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

   //#65   REPLACE_66B_ENCODED_DATA - {$urandom(),$urandom()}- INSERT_ERR_IN_START_FRAME 
    exception = new();
    exception.error_kind = local_exception_seq.error_kind;
    exception.baser_encoder_error_kind = svt_ethernet_transaction_exception::BASER_ENCODER_REPLACE_66B_ENCODED_DATA;
    exception.baser_encoder_replace_66b_encoded_data_error = {$urandom(),$urandom()};
    exception.baser_encoder_error_position = svt_ethernet_transaction_exception::BASER_ENCODER_INSERT_ERR_IN_START_FRAME;
    exception_list.add_exception(exception);

  endtask 
          
     
endclass // vip_decoder_rand_sequence


