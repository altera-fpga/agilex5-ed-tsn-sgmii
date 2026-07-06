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


task send_eth_frames_avalon_tx(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1, bit crc_pass = 1,int unicast_addr =0, bit [47:0]ucast_addr=0,int frame_length_64 = 0, bit misc_control_frame=0);

  bit [1:0] sel;

  `uvm_create (req)

  if(frame_size != -1) begin 
    req.payload_size_c.constraint_mode(0);
  end

  //if(crc_pass == 0 && frame_size inside {[0:63]}) begin
  //  //For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470.
  //  `uvm_info("send_eth_frames_avalon_tx",$sformatf("Frame size %0d is changed to 64 ",frame_size),UVM_NONE)
  //  frame_size = 64;
  //end

  if(eth_frame == DATA_FRAME) begin
    
     if(frame_size == -1) begin
       `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;})
     end else begin
       if(frame_length_64 == 0 ) begin
          if(unicast_addr == 0 ) begin
            if(misc_control_frame == 0) begin
              `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18); })
            end else begin
              req.length_type_c.constraint_mode(0);
              `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18); eth_type_or_length == 'h8808; })
            end
          end else begin
             req.dest_address_c.constraint_mode(0);
             `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);dest_address == ucast_addr; })
          end
       end else begin
            req.length_type_c.constraint_mode(0);
            `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18); eth_type_or_length == (frame_length_64 - 1); })
       end
     end
   end
   else if(eth_frame == MCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b1;})
    end
    else begin
      if(misc_control_frame) begin 
        `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18); eth_type_or_length == 'h8808; frame_payload_type == NORMAL; dest_address[40] == 'b1; })
      end
      else begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b1;})
                     end
    end
  end
  else if(eth_frame == BCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address == 'hffffffffffff;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       req.dest_address == 'hffffffffffff;})
    end
  end
  else if(eth_frame == UCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b0;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b0;})
    end
  end
  else if(eth_frame == MCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address[40] == 'h1;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address[40] == 'h1;})
    end
  end
  else if(eth_frame == BCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address == 'hffffffffffff;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address == 'hffffffffffff;})
    end
  end
  else if(eth_frame == UCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address[40] == 'h0;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address[40] == 'h0;})
    end
  end

  else if(eth_frame == VLAN_FRAME) begin
    if(frame_length_64 == 0 ) begin
        if(frame_size == -1) begin
          `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; })
        end
        else begin
          `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);})
        end
    end else begin //frame_length_64
        req.length_type_c.constraint_mode(0);
        req.payload_size_c.constraint_mode(0);
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);eth_type_or_length == frame_length_64;})
    end
  end
  else if(eth_frame == JUMBO_DATA_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL;})  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);})  
    end
  end
  else if(eth_frame == STACKED_VLAN_FRAME) begin
    if(frame_length_64 == 0 ) begin
        if(frame_size == -1) begin
          `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; })
        end
        else begin
          `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);})
        end
    end else begin //frame_length_64
         req.length_type_c.constraint_mode(0);
         req.payload_size_c.constraint_mode(0);
         `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26); eth_type_or_length == frame_length_64;})
    end
  end
  else if(eth_frame == JUMBO_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL;})  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);})  
    end
  end
  else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL;}) 
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);}) 
    end
  end
  else if(eth_frame == CONTROL_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18);})
    end
  end
  else if(eth_frame == PFC_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);})
    end
  end
  else if(eth_frame == SFC_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);})
    end
  end
  else if(eth_frame == MISC_CONTROL_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_MISC_CONTROL_FRAME; frame_payload_type == NORMAL; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_MISC_CONTROL_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);})
    end
  end
  
  else if(eth_frame == RANDOM_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL; })			  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL; })			  
    end
  end
  else if(eth_frame == UNDERSIZE_FRAME) begin
    if(frame_size == -1) begin
     // if(crc_pass == 1) begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == UNDERSIZE; }) 
     // end
     // else begin
     //   `uvm_info("send_eth_frames_avalon_tx", "For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470. Payload will be randomized within valid range.", UVM_NONE)
     //   `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL; }) 
     // end
    end
    else begin
      //if(crc_pass == 1) begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == UNDERSIZE;
                                 solve frame_type before payload.size;
                                 (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      	         	         (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		                 (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);}) 
      //end
      //else begin
      //  `uvm_info("send_eth_frames_avalon_tx", "For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470. Payload will be randomized within valid range.", UVM_NONE)
      //  `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL;
      //                           (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      //	         	         (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      //		                 (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);}) 
      //end
    end
  end
  else if(eth_frame == IPG_STRESS) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      					          ETH_STACKED_VLAN_FRAME};
      			       interpacket_gap==0;
			       frame_payload_type == NORMAL;			  
      			       payload.size inside {[46:53]};})
    end
    else begin 
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
        					  ETH_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
      			       interpacket_gap==0;
			       frame_payload_type == NORMAL; })			  
    end
  end
  else 
    `uvm_error("send_eth_frames_avalon_tx", $sformatf("Invalid frame type %0s",eth_frame.name()));
endtask : send_eth_frames_avalon_tx

task send_vlan_control_pause_eth_frame(int no_of_frames, int frame_size=-1,bit [47:0]dest_address = 48'h0 );
   `uvm_info("send_vlan_control_pause_eth_frame",$sformatf("dest_address = %0h",dest_address),UVM_NONE);
 for(int i = 0; i < no_of_frames; i++) begin
  `uvm_create (req)
 // if(frame_size != -1) begin 
    req.dest_address_c.constraint_mode(0);
    req.payload_size_c.constraint_mode(0);
    `uvm_rand_send_with(req,{frame_type == VLAN_FRAME; frame_payload_type == NORMAL;eth_type_or_length == 'h8808;dest_address == 48'hD6D4D3D2D1D0;})
//  end
 end
endtask



task send_eth_frames_avalon_tx_with_fcs_error(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1, bit crc_pass = 1, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP, bit ucast_en=0,bit[47:0]unicast_addr);

  bit [1:0] sel;
  `uvm_create (req)

  if(frame_size != -1) begin 
    req.payload_size_c.constraint_mode(0);
  end

  `uvm_info("send_eth_frames_avalon_tx_with_fcs_error", $sformatf("Path - AVL_TX_ETH_VIP : sending %0d %0s frame with frame size = %0d, unicast_addr =%0h",no_of_frames,eth_frame.name(),frame_size,unicast_addr),UVM_MEDIUM);

  //if(crc_pass == 0 && frame_size inside {[0:63]}) begin
  //  //For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470.
  //  `uvm_info("send_eth_frames_avalon_tx_with_fcs_error",$sformatf("Frame size %0d is changed to 64 ",frame_size),UVM_NONE)
  //  frame_size = 64;
  //end

  req.tx_fcs_error_insertion = $urandom_range(0,1);
  //req.tx_error_insertion = $urandom_range(0,1);//Disabling tx error insertion

  if(eth_frame == DATA_FRAME) begin
    if(ucast_en == 0) begin
      if(frame_size == -1) begin
        `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp;})
      end
      else begin
        `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq==is_ptp; })
      end
    end else begin
       req.dest_address_c.constraint_mode(0);
       `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq==is_ptp;dest_address == unicast_addr; })
    end
  end
  else if(eth_frame == MCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b1;is_ptp_seq==is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b1;is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == BCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address == 'hffffffffffff;is_ptp_seq==is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       req.dest_address == 'hffffffffffff;is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == UCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b0;is_ptp_seq==is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b0;is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == MCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address[40] == 'h1;is_ptp_seq==is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address[40] == 'h1;is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == BCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address == 'hffffffffffff;is_ptp_seq==is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address == 'hffffffffffff;is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == UCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address[40] == 'h0;is_ptp_seq==is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address[40] == 'h0;is_ptp_seq==is_ptp;})
    end
  end

  else if(eth_frame == VLAN_FRAME) begin
    if(ucast_en == 0) begin
      if(frame_size == -1) begin
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp; })
      end
      else begin
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);is_ptp_seq==is_ptp;})
      end
    end else begin
        req.dest_address_c.constraint_mode(0);
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);is_ptp_seq==is_ptp;dest_address == unicast_addr;})
    end
  end
  else if(eth_frame == JUMBO_DATA_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp;})  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq==is_ptp;})  
    end
  end
  else if(eth_frame == STACKED_VLAN_FRAME) begin
    if(ucast_en == 0) begin
      if(frame_size == -1) begin
        `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp; })
      end
      else begin
        `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);is_ptp_seq==is_ptp;})
      end
    end else begin
        req.dest_address_c.constraint_mode(0);
        `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);is_ptp_seq==is_ptp;dest_address == unicast_addr;})
    end
  end
  else if(eth_frame == JUMBO_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp;})  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);is_ptp_seq==is_ptp;})  
    end
  end
  else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp;}) 
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);is_ptp_seq==is_ptp;}) 
    end
  end
  else if(eth_frame == CONTROL_FRAME)  begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL;is_ptp_seq==is_ptp; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == PFC_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == SFC_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL;is_ptp_seq==is_ptp; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq==is_ptp;})
    end
  end
  else if(eth_frame == RANDOM_FRAME) begin
    if(frame_size == -1) begin
	if(is_ptp) begin
      	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;is_ptp_seq==is_ptp;m_ptp_op==ptp_op;})	
	end
	else begin
	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;})
	end		  
    end
    else begin
	if(is_ptp) begin
      	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;is_ptp_seq==is_ptp;m_ptp_op==ptp_op;})
	end
	else begin
	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;})
	end			  
    end
  end
  else if(eth_frame == UNDERSIZE_FRAME) begin
    if(frame_size == -1) begin
      //if(crc_pass == 1) begin
      if(req.tx_error_insertion == 0) begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == UNDERSIZE;is_ptp_seq==is_ptp; }) 
      end
      else begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};
	                         frame_payload_type == UNDERSIZE;
                                 solve frame_type before payload.size;
                                (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size inside {[0:37]});
                                (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size inside {[0:33]});
                                (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size inside {[0:29]});is_ptp_seq==is_ptp;})
      end
      //end
      //else begin
      //  `uvm_info("send_eth_frames_avalon_tx_with_fcs_error", "For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470. Payload will be randomized within valid range.", UVM_NONE)
      //  `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL; }) 
      //end
    end
    else begin
      //if(crc_pass == 1) begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};
	                         frame_payload_type == UNDERSIZE;
                                 solve frame_type before payload.size;
                                 (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      	         	         (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		                 (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);is_ptp_seq==is_ptp;}) 
      //end
      //else begin
      //  `uvm_info("send_eth_frames_avalon_tx_with_fcs_error", "For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470. Payload will be randomized within valid range.", UVM_NONE)
      //  `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL;
      //                           (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      //	         	         (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      //		                 (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);}) 
      //end
    end
  end
  else if(eth_frame == IPG_STRESS) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      					          ETH_STACKED_VLAN_FRAME};
      			       interpacket_gap==0;
			       frame_payload_type == NORMAL;			  
      			       payload.size inside {[46:53]};is_ptp_seq==is_ptp;})
    end
    else begin 
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
        					  ETH_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
      			       interpacket_gap==0;
			       frame_payload_type == NORMAL;is_ptp_seq==is_ptp; })			  
    end
  end
  else 
    `uvm_error("send_eth_frames_avalon_tx_with_fcs_error", $sformatf("Invalid frame type %0s",eth_frame.name()));
endtask : send_eth_frames_avalon_tx_with_fcs_error

task send_eth_frames_avalon_tx_with_length_error(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1, bit crc_pass = 1, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP,int length_type_value = 0);

  int range;

  `uvm_create (req)

  req.length_type_c.constraint_mode(0);
  if(frame_size != -1) begin 
    req.payload_size_c.constraint_mode(0);
  end
  //if(crc_pass == 0 && frame_size inside {[0:63]}) begin
  //  //For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470.
  //  `uvm_info("send_eth_frames_avalon_tx",$sformatf("Frame size %0d is changed to 64 ",frame_size),UVM_NONE)
  //  frame_size = 64;
  //end

  std::randomize(range) with {range > -5 && range < 10;};

  if(eth_frame == DATA_FRAME) begin
    if(length_type_value == 0) begin
      if(frame_size == -1) begin
        `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;eth_type_or_length == payload.size()+range;is_ptp_seq==is_ptp;})
      end
      else begin
        `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18); eth_type_or_length == (frame_size-18)+range;is_ptp_seq==is_ptp;})
      end
    end else begin
        `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18); eth_type_or_length == length_type_value;is_ptp_seq==is_ptp;})
    end
  end

  else if(eth_frame == VLAN_FRAME) begin
    if(length_type_value == 0) begin
      if(frame_size == -1) begin
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL;eth_type_or_length == payload.size()+range; vlan_tag[31:16] =='h8100;vlan_tag[11:0] inside {[2:'hFFE]};is_ptp_seq==is_ptp;})
      end
      else begin
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);eth_type_or_length == (frame_size-22)+range; vlan_tag[31:16] =='h8100;vlan_tag[11:0] inside {[2:'hFFE]};is_ptp_seq==is_ptp;})
      end
    end else begin
        `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);eth_type_or_length == length_type_value; vlan_tag[31:16] =='h8100;vlan_tag[11:0] inside {[2:'hFFE]};is_ptp_seq==is_ptp;})
    end
  end
  
  else if(eth_frame == STACKED_VLAN_FRAME) begin
    if(length_type_value == 0) begin
      if(frame_size == -1) begin
        `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL;eth_type_or_length == payload.size()+range;vlan_tag[31:16] =='h8100;stacked_vlan_tag[31:16] =='h8100;stacked_vlan_tag[11:0] inside {[2:'hFFE]};vlan_tag[11:0] inside {[2:'hFFE]};is_ptp_seq==is_ptp; })
      end
      else begin
        `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);eth_type_or_length == (frame_size-26)+range;vlan_tag[31:16] =='h8100;stacked_vlan_tag[31:16] =='h8100;stacked_vlan_tag[11:0] inside {[2:'hFFE]};vlan_tag[11:0] inside {[2:'hFFE]};is_ptp_seq==is_ptp; })
      end
    end else begin
        `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);eth_type_or_length == length_type_value;vlan_tag[31:16] =='h8100;stacked_vlan_tag[31:16] =='h8100;stacked_vlan_tag[11:0] inside {[2:'hFFE]};vlan_tag[11:0] inside {[2:'hFFE]};is_ptp_seq==is_ptp; })
    end
  end
  else if(eth_frame == RANDOM_FRAME) begin
    if(frame_size == -1) begin
	if(is_ptp) begin
      	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_STACKED_VLAN_FRAME
      						  };
			       frame_payload_type == NORMAL;is_ptp_seq==is_ptp;m_ptp_op==ptp_op; })
	end		
	else begin
	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_STACKED_VLAN_FRAME
      						  };
			       frame_payload_type == NORMAL;})
	end	  
    end
    else begin
	if(is_ptp) begin
      	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_STACKED_VLAN_FRAME
         					  };
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;is_ptp_seq==is_ptp;m_ptp_op==ptp_op; })
	end
	else begin
	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_STACKED_VLAN_FRAME
         					  };
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;})
	end			  
    end
  end
  
  else 
    `uvm_error("send_eth_frames_avalon_tx_with_length_error", $sformatf("Invalid frame type %0s",eth_frame.name()));
endtask : send_eth_frames_avalon_tx_with_length_error


task send_eth_control_frame(int no_of_frames=10, frame_type eth_frame = SFC_FRAME, bit [47:0] address = 48'h01_80_C2_00_00_01, zero_quanta = 0);
  
  for(int i = 0; i < no_of_frames; i++) begin
     `uvm_create (req)
     req.dest_address_c.constraint_mode(0);
    if(zero_quanta == 1) begin
       req.sfc_pause_quanta.rand_mode(0);
       req.pfc_pause_quanta.rand_mode(0);
       req.sfc_pause_quanta_c.constraint_mode(0);
       req.pfc_pause_quanta_c.constraint_mode(0);
    end
    if(eth_frame == PFC_FRAME)
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL; dest_address == address;})
    else
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL; dest_address == address;})
  end

endtask

task send_eth_frames_avalon_tx_with_tx_error(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1, bit crc_pass = 1, bit is_ptp = 0,ptp_op_e ptp_op=INS_NOOP);

  bit [1:0] sel;

  `uvm_create (req)

  if(frame_size != -1) begin 
    req.payload_size_c.constraint_mode(0);
  end

  if(frame_size inside {[49:64]}) begin
    //For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470.
    `uvm_info("send_eth_frames_avalon_tx_with_tx_error",$sformatf("Frame size %0d is changed to 64 ",frame_size),UVM_NONE)
    frame_size = $urandom_range(25,48);
  end

  req.tx_error_insertion = 1;

  if(eth_frame == DATA_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq == is_ptp; })
    end
  end
  else if(eth_frame == MCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b1;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b1;is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == BCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address == 'hffffffffffff;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       req.dest_address == 'hffffffffffff;is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == UCAST_DATA_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b0;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;			  
      			       dest_address[40] == 'b0;is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == MCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address[40] == 'h1;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address[40] == 'h1;is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == BCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address == 'hffffffffffff;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address == 'hffffffffffff;is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == UCAST_CTRL_FRAME) begin
    req.dest_address_c.constraint_mode(0);
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; dest_address[40] == 'h0;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18); dest_address[40] == 'h0;is_ptp_seq == is_ptp;})
    end
  end

  else if(eth_frame == VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == JUMBO_DATA_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp;})  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq == is_ptp;})  
    end
  end
  else if(eth_frame == STACKED_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == JUMBO_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp;})  
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 22);is_ptp_seq == is_ptp;})  
    end
  end
  else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp;}) 
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 26);is_ptp_seq == is_ptp;}) 
    end
  end
  else if(eth_frame == CONTROL_FRAME)  begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL;is_ptp_seq == is_ptp; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == PFC_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp;})
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == SFC_FRAME) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL;is_ptp_seq == is_ptp; })
    end
    else begin
      `uvm_rand_send_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL; payload.size == (frame_size - 18);is_ptp_seq == is_ptp;})
    end
  end
  else if(eth_frame == RANDOM_FRAME) begin
    if(frame_size == -1) begin
	if(is_ptp) begin
      	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;is_ptp_seq == is_ptp;m_ptp_op==ptp_op;})	
	end
	else begin
	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      						  ETH_JUMBO_DATA_FRAME,
      						  ETH_STACKED_VLAN_FRAME,
      						  ETH_JUMBO_VLAN_FRAME,
      						  ETH_JUMBO_STACKED_VLAN_FRAME};
			       frame_payload_type == NORMAL;})
	end		  
    end
    else begin
	if(is_ptp) begin
      	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL; is_ptp_seq == is_ptp;m_ptp_op==ptp_op;})	
	end
	else begin
	`uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
         					  ETH_JUMBO_DATA_FRAME,
         					  ETH_STACKED_VLAN_FRAME,
         					  ETH_JUMBO_VLAN_FRAME,
         					  ETH_JUMBO_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
			       frame_payload_type == NORMAL;})
	end
      		  
    end
  end
  else if(eth_frame == UNDERSIZE_FRAME) begin
    if(frame_size == -1) begin
      //if(crc_pass == 1) begin
      if(req.tx_error_insertion == 0) begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == UNDERSIZE;is_ptp_seq == is_ptp; }) 
      end
      else begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};
	                         frame_payload_type == UNDERSIZE;
                                 solve frame_type before payload.size;
                                (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size inside {[0:37]});
                                (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size inside {[0:33]});
                                (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size inside {[0:29]});is_ptp_seq == is_ptp;})
      end
      //end
      //else begin
      //  `uvm_info("send_eth_frames_avalon_tx_with_tx_error", "For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470. Payload will be randomized within valid range.", UVM_NONE)
      //  `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL; }) 
      //end
    end
    else begin
      //if(crc_pass == 1) begin
        `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};
	                         frame_payload_type == UNDERSIZE;
                                 solve frame_type before payload.size;
                                 (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      	         	         (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		                 (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);is_ptp_seq == is_ptp;}) 
      //end
      //else begin
      //  `uvm_info("send_eth_frames_avalon_tx_with_tx_error", "For TX CRC pass-through mode, the user is expected to provided frames with at least 64 bytes, Ref. FB : 489470. Payload will be randomized within valid range.", UVM_NONE)
      //  `uvm_rand_send_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL;
      //                           (frame_type inside {ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME}) -> (payload.size == frame_size - 18);
      //	         	         (frame_type inside {ETH_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      //		                 (frame_type inside {ETH_STACKED_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);}) 
      //end
    end
  end
  else if(eth_frame == IPG_STRESS) begin
    if(frame_size == -1) begin
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
      					          ETH_STACKED_VLAN_FRAME};
      			       interpacket_gap==0;
			       frame_payload_type == NORMAL;			  
      			       payload.size inside {[46:53]};is_ptp_seq == is_ptp;})
    end
    else begin 
      `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME,
                                                  ETH_VLAN_FRAME,
        					  ETH_STACKED_VLAN_FRAME};
                               solve frame_type before payload.size;
      		               (frame_type inside {ETH_DATA_FRAME}) -> (payload.size == frame_size - 18);
      		               (frame_type inside {ETH_VLAN_FRAME}) -> (payload.size == frame_size - 22);
      		               (frame_type inside {ETH_STACKED_VLAN_FRAME}) -> (payload.size == frame_size - 26);
      			       interpacket_gap==0;
			       frame_payload_type == NORMAL;is_ptp_seq == is_ptp;})			  
    end
  end
  else 
    `uvm_error("send_eth_frames_avalon_tx_with_tx_error", $sformatf("Invalid frame type %0s",eth_frame.name()));
endtask : send_eth_frames_avalon_tx_with_tx_error
