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


class frame_size_dist_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
  `uvm_object_utils(frame_size_dist_sequence)

   int transaction_count=1000;
   int num_frames;
   bit vip_mix_error_frames_on = 1;
   bit pyld_size_rand_on = 1;
   bit pyld_type_rand_on = 1;
   int rx_max_frame_size = 'd1500;
   int lane_num;
   int rx_am_valid_counts,rx_counts;
   int error_case;
   int error_case_no;
   int packet_size;
   int vip_ipg,pyld_size;
   string scb_inst_name;
   int pause_delay;

  function new(string name = "frame_size_dist_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif

    if ($value$plusargs("num_frames=%d",num_frames)) begin
      transaction_count = num_frames;
    end
    else begin
      //transaction_count = 1000;
      transaction_count = 100;
    end
    `uvm_info(get_full_name(), $sformatf("test run for num_frames = %0d",transaction_count), UVM_LOW)
 endfunction:new

  virtual task body();

    bit OK;
    bit core_enable;
    bit fcs_enabled;
    bit [15:0] rand_len;

    `uvm_info(get_type_name(), "FRAME SIZE DIST SEQ BEGIN", UVM_LOW)

    rx_crc_pass=$urandom;

   //pcs_mac register not accessible in pcs_only mode   
   //p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   `uvm_info(get_type_name(), "DONE!!! WRITING TO REG", UVM_LOW)
 //  tx_seq.start(p_sequencer.tx_seqr);

   //disable rule checks after delay why needed FIXME RR ??
   #500ns;
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
   //bit 0: (set t0 0 to disable checker on tx side)
   //bit 1: (set t0 0 to disable checker on rx side)
   //bit 2: (set t0 0 to disable checker on checker arbiter)
   //.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
   p_sequencer.env.ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b001);

     //-------------------------------------------------------------------
     // Fire 100 Data Packets from VIP of random length.
     //-------------------------------------------------------------------


     for(int z =0 ; z < transaction_count; z++) begin
       if (vip_mix_error_frames_on) begin
          OK = std::randomize(vip_ipg) with {vip_ipg >= 1; vip_ipg < 5;};

          if (!OK) `uvm_fatal (get_type_name(), "VIP TX IPG randomization failed!")
       end


       //OK = std::randomize(error_case) with { error_case dist {1:=20 , 2:=20 , 3:=10 , 4:=20 , 5:=10 , 6:=20};};
       OK = std::randomize(error_case) with { error_case dist {1:=20 , 2:=20 , 3:=10 , 4:=20 , 5:=10};};

       `uvm_info(get_name(),$sformatf("case := %0d",error_case),UVM_LOW)

       //---------------------------------------------------------
       //send_user_defined_packet
       // - sqr_name
       // - byte_size
       // - preamble_err
       // - sfd_err
       // - fcs_enabled
       // - frame_num
       //---------------------------------------------------------
//       fcs_enabled = 0;
       case(error_case)
//         0: begin
//              packet_size =  $urandom_range(7,7);
//              send_user_defined_packet(sequencer_name,packet_size,0,0,1,z);
//            end
//         1: begin
//              packet_size =  $urandom_range(8,8);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         2: begin
//              packet_size =  $urandom_range(9,9);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         3: begin
//              packet_size =  $urandom_range(10,10);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         4: begin
//              packet_size =  $urandom_range(11,11);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         5: begin
//              packet_size =  $urandom_range(12,12);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         6: begin
//              packet_size =  $urandom_range(13,13);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         7: begin
//              packet_size =  $urandom_range(14,14);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         8: begin
//              packet_size =  $urandom_range(15,15);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         9: begin
//              packet_size =  $urandom_range(16,16);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
//         10: begin
//              packet_size =  $urandom_range(20,20);
//              send_user_defined_packet(sequencer_name,packet_size,fcs_enabled,z);
//            end
         1: begin
              packet_size =  $urandom_range(8,13);
              fcs_enabled = 1; // vip will not insert CRC
              rand_len =  0;
              send_user_defined_packet(packet_size,fcs_enabled, z);
            end
         2: begin
              packet_size =  $urandom_range(14,19);
              fcs_enabled = 1; // vip will not insert CRC
              rand_len =  0;
              send_user_defined_packet(packet_size,fcs_enabled, z);
            end
         3: begin
              packet_size =  $urandom_range(20,21);
              fcs_enabled = 1; // vip will not insert CRC
              rand_len =  0;
              send_user_defined_packet(packet_size,fcs_enabled, z);
            end
         4: begin
              rand_len = $urandom_range(46,500);
              fcs_enabled = 0; // vip will calculate and insert CRC automatically after payload
              send_valid_frame(rand_len,fcs_enabled,z);
            end
         5: begin
              rand_len = $urandom_range(500,1500);
              fcs_enabled = 0; // vip will calculate and insert CRC automatically after payload
              send_valid_frame(rand_len,fcs_enabled,z);
            end
         //FIXME RR check if pause needed in this mix 
         //6: begin
         //     fcs_enabled = 0; // vip will calculate and insert CRC automatically after payload
         //     send_pause_frame(fcs_enabled,z);
         //   end
         endcase
     end

    `uvm_info(get_type_name(), "FRAME SIZE DIST SEQ END", UVM_LOW)
   endtask : body


//   //-------------------------------------------------------------------
//   // send SFC pause
//   //-------------------------------------------------------------------
//   task send_pause_frame(bit fcs_enabled, int frame_num);
//     `uvm_info(get_name(),$sformatf("frame_num(pause_frame) := %0d",frame_num),UVM_LOW)
//     `uvm_info(get_name(),$sformatf("fcs_enabled := %0d",fcs_enabled),UVM_LOW)
//     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_USER_DEFINED_PREAMBLE_SFD_HEADER_PAYLOAD, 0 );
//     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_USER_DEFINED_HEADER_PAYLOAD,0);
//     // If fcs enabled= 1, then VIP wont calculate FCS on its own
//     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_FRAME_WITHOUT_FCS,0);
//     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_INTER_FRAME_GAP, vip_ipg );
//     pause_delay = $urandom_range(1,50);
//     `uvm_info(get_name(),$sformatf("sending pause frame with pause_quanta := %0d",pause_delay),UVM_LOW)
//     send_sfc_pause_frame(pause_delay);
//   endtask : send_pause_frame


   //-------------------------------------------------------------------
   // send valid frame
   //-------------------------------------------------------------------
   task send_valid_frame(bit[15:0] rand_len, bit fcs_enabled, int frame_num);

     `uvm_info(get_name(),$sformatf("frame_num(valid_frame) := %0d",frame_num),UVM_LOW)
     `uvm_info(get_name(),$sformatf("pl_len := 0x%0h (decimal = %0d)",rand_len,rand_len),UVM_LOW)
     `uvm_info(get_name(),$sformatf("fcs_enabled := %0d",fcs_enabled),UVM_LOW)
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_USER_DEFINED_PREAMBLE_SFD_HEADER_PAYLOAD, 0 );
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_USER_DEFINED_HEADER_PAYLOAD,0);
     // If fcs enabled= 1, then VIP wont calculate FCS on its own
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_FRAME_WITHOUT_FCS,0);
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_DATA,`ETH_INCR);
     // Configuring the IPG between frames
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_INTER_FRAME_GAP, vip_ipg );
      p_sequencer.env.ts_tasks_if.do_drv_cmd(`ETH_MAC_DATA_FRAME,`ETH_MAC1_INDVL_ADDRESS,rand_len);

   endtask : send_valid_frame

   //-------------------------------------------------------------------
   // start sending user defined packet
   //-------------------------------------------------------------------
   task send_user_defined_packet(int byte_size, bit fcs_enabled, int frame_num);
     bit [7:0] user_pkt_data[];
     user_pkt_data =  new[byte_size];

     `uvm_info(get_name(),$sformatf("frame_num(shot_frame) := %0d",frame_num),UVM_LOW)
     `uvm_info(get_name(),$sformatf("byte_size := %0d",byte_size),UVM_LOW)
     `uvm_info(get_name(),$sformatf("fcs_enabled := %0d",fcs_enabled),UVM_LOW)
     for(int i=0; i < byte_size; i++) begin
       if(i<7) begin
         user_pkt_data[i]=8'h55;
       end
       if(i==7) begin
         user_pkt_data[i]=8'hD5;
       end
       if(i>7) begin
         user_pkt_data[i]=$urandom;
       end
     end

     `uvm_info(get_name(),$sformatf("user_pkt_data := %0p",user_pkt_data),UVM_LOW)

      // Enabling the user to configure the header and payload
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_USER_DEFINED_PREAMBLE_SFD_HEADER_PAYLOAD, 1 );
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_USER_DEFINED_HEADER_PAYLOAD,0);
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_PKT_SIZE,`ETH_BYTE);
     // If fcs enabled= 1, then VIP wont calculate FCS on its own
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_FRAME_WITHOUT_FCS,fcs_enabled);

     // Forming the custom packet inside VIP
     for(int j=0; j < byte_size; j++) begin
       p_sequencer.env.ts_tasks_if.do_drv_pkt(j,user_pkt_data[j]);
     end

     // Configuring the IPG between frames
     p_sequencer.env.ts_tasks_if.do_drv_cfg(`ETH_MODE_MAC_INTER_FRAME_GAP, vip_ipg );
      p_sequencer.env.ts_tasks_if.do_drv_cmd(`ETH_MAC_DATA_FRAME,`ETH_MAC1_INDVL_ADDRESS,byte_size);
     `uvm_info(get_type_name(), $sformatf("Sending frame num %0d,with size of %0d bytes",frame_num,byte_size), UVM_LOW)

   endtask : send_user_defined_packet

endclass
