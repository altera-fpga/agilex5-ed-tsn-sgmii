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


  
task send_fix_size_eth_frame(frame_type eth_frame = DATA_FRAME, int frame_size = 100, int no_of_frame = 1, bit unicast_addr =0, bit [47:0]ucast_addr = 0);
  bit status;
  `uvm_info("send_fix_size_eth_frame", "Entered ...", UVM_NONE)
    `uvm_info(get_full_name(), $psprintf("unicast_addr=  %0h ucast_addr =  %0h",unicast_addr,ucast_addr), UVM_NONE)
  for(int i = 0; i < no_of_frame; i++) begin

    `uvm_info("send_fix_size_eth_frame", $sformatf("Calling `uvm_do, iteration=%0d %s", i,eth_frame.name()), UVM_NONE)

    `svt_xvm_create (req)

    if(frame_size != -1) begin
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_command_type.constraint_mode(0);
      req.disable_mac_pad = 1;
    end

    if(eth_frame == DATA_FRAME) begin
      if(unicast_addr == 0) begin
        if(frame_size == -1) begin
          `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; })
        end
        else begin
          `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); })
        end
      end
      else begin
          `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); address == ucast_addr;})
      end
    end
    else if(eth_frame == MCAST_DATA_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
	                                                        svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
				       req.address[40] == 'b1;})
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                           svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
                                     solve command_type before byte_count;
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}) -> (byte_count == frame_size - 18);
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);
				     req.address[40] == 'b1;})
      end
    end
    else if(eth_frame == BCAST_DATA_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
	                                                        svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
				       req.address == 'hffffffffffff;})
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                           svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
                                     solve command_type before byte_count;
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}) -> (byte_count == frame_size - 18);
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);
				     req.address == 'hffffffffffff;})
      end
    end
    else if(eth_frame == UCAST_DATA_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
	                                                        svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
								svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
				       address[40] == 'b0;})
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                           svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
                                     solve command_type before byte_count;
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}) -> (byte_count == frame_size - 18);
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			             (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);
				     address[40] == 'b0;})
      end
    end
    else if(eth_frame == MCAST_CTRL_FRAME) begin
      req.reasonable_address.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; req.address[40] == 'h1;})
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); req.address[40] == 'h1;})
      end
    end
    else if(eth_frame == BCAST_CTRL_FRAME) begin
      req.reasonable_address.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; req.address == 'hffffffffffff;})
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); req.address == 'hffffffffffff;})
      end
    end
    else if(eth_frame == UCAST_CTRL_FRAME) begin
      req.reasonable_address.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; req.address[40] == 'h0;})
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); req.address[40] == 'h0;})
      end
    end

    else if(eth_frame == VLAN_FRAME) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME; })
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME; byte_count == (frame_size - 22);})
      end
    end
    else if(eth_frame == JUMBO_DATA_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME;})  
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME; byte_count == (frame_size - 18);})  
      end
    end
    else if(eth_frame == STACKED_VLAN_FRAME) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME; })
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME; byte_count == (frame_size - 26);})
      end
    end
    else if(eth_frame == JUMBO_VLAN_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME;})  
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME; byte_count == (frame_size - 22);})  
      end
    end
    else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME;}) 
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME; byte_count == (frame_size - 26);}) 
      end
    end
    else if(eth_frame == CONTROL_FRAME) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; })
      end
      else begin
        `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18);})
      end
    end
    else if(eth_frame == PFC_FRAME) begin
      if(unicast_addr == 0) begin
        if(frame_size == -1) begin
          `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; })
        end
        else begin
          `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18);})
        end
      end else begin
          req.reasonable_address.constraint_mode(0);
          `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); address == ucast_addr;})
      end
    end
    else if(eth_frame == SFC_FRAME) begin
      if(unicast_addr == 0) begin
        if(frame_size == -1) begin
          `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME}; })
        end
        else begin
          `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME}; byte_count == (frame_size - 18);})
        end
      end else begin 
           req.reasonable_address.constraint_mode(0);
          `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME}; byte_count == (frame_size - 18);address == ucast_addr;})
      end
    end
    else if(eth_frame == RANDOM_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                            svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
							    svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
							    svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
							    svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
							    svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};})
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                       svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					       svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
           					       svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,
           					       svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
           					       svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};
                                  solve command_type before byte_count;
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}) -> (byte_count == frame_size - 18);
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);})
      end
    end
    else if(eth_frame == PADDED_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_mac_pad_bits.constraint_mode(0);
      req.disable_mac_pad = 0;
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                           svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};
                                  solve command_type before byte_count;
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME}) -> (byte_count dist {0:=40,[1:10]:=40,[11:45]:=20});
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME}) -> (byte_count dist {0:=40,[1:10]:=40,[11:41]:=20}); 
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME}) -> (byte_count dist {0:=40,[1:10]:=40,[11:37]:=20}); })
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                           svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					           svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};
                                  solve command_type before byte_count;
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME}) -> (byte_count == frame_size - 18);
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);})
      end
    end
    else if(eth_frame == UNDERSIZE_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      req.reasonable_byte_count.constraint_mode(0);
      req.disable_mac_pad = 1;
      sel = $urandom_range(1,3);
      if(frame_size == -1) begin
        //NOTE : min frame size > 26 , FB-476081 (S10,100G)
        if(sel== 1) begin 
          `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[0:45]};})  
          //`svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[35:45]};})  
          //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
        end
        else if (sel == 2) begin 
          `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[0:37]};})
          //`svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[35:37]};})
          //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
        end 
        else begin 
          `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[0:41]};})
          //`svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[35:41]};})
          //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix 
        end 
      end
      else begin
        //NOTE : min frame size > 26 , FB-476081 (S10,100G)
        if(sel== 1) begin 
          //`svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[46:100]};})  
          `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; (byte_count == frame_size - 18);})  
          //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
        end
        else if (sel == 2) begin 
          //`svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[38:100]};})
          `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; (byte_count == frame_size - 22);})
          //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
        end 
        else begin 
          //`svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[42:100]};})
          `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; (byte_count == frame_size - 26);})
          //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix
        end
      end
    end
    else if(eth_frame == IPG_STRESS) begin
      if(frame_size == -1) begin
        req.reasonable_mac_inter_frame_gap.constraint_mode(0);
        `svt_xvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
	                                                    svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
						            svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};
				       mac_inter_frame_gap==1;
				       byte_count inside {[46:53]};})
      end
      else begin 
        req.reasonable_mac_inter_frame_gap.constraint_mode(0);
        `uvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                      svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
	  					    svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};
                                 solve command_type before byte_count;
			         (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME}) -> (byte_count == frame_size - 18);
			         (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			         (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);
			         mac_inter_frame_gap==1; })
      end
    end
    else 
   `uvm_error("alt_eth_vip_base_sequence", $sformatf("Invalid frame type %0s",eth_frame.name()));    
  end
endtask : send_fix_size_eth_frame


task send_vlan_control_rx_frame(frame_type eth_frame = DATA_FRAME, int frame_size = 100, int no_of_frame = 1, bit [47:0]dest_address = 0, int length_type_value=0);
 
  `uvm_info(get_full_name(), $psprintf("dest_address=  %0h length_type_value =  %0h",dest_address,length_type_value), UVM_NONE)

 for(int i = 0; i < no_of_frame; i++) begin
      `svt_xvm_create (req)
      req.reasonable_byte_count.constraint_mode(0);
      req.disable_mac_pad = 1;
      req.reasonable_address.constraint_mode(0);
      req.reasonable_length_type.constraint_mode(0);
      req.enable_apply_length_type = 1;

    if(eth_frame == VLAN_FRAME) begin
        `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME; byte_count == (frame_size - 22);length_type == length_type_value ;address == dest_address; })
    end

   if(eth_frame == DATA_FRAME) begin
      `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18);length_type == length_type_value ; address == dest_address ;})
   end

 end
endtask : send_vlan_control_rx_frame




task send_eth_control_frame(int no_of_frames=1, frame_type eth_frame = SFC_FRAME, bit [47:0] dest_address = 48'h01_80_C2_00_00_01, zero_quanta = 0);
  
  for(int i = 0; i < no_of_frames; i++) begin
    `svt_xvm_create (req)
    if(zero_quanta == 1) begin
       req.reasonable_mac_ctrl_parameter.constraint_mode(0);
       req.reasonable_mac_ppp_timer.constraint_mode(0);
    end
    if(eth_frame == PFC_FRAME)
      `svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; address==dest_address; })
    else
      `svt_xvm_rand_send_with(req, {req.command_type==svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME;address==dest_address; })
  end

endtask

