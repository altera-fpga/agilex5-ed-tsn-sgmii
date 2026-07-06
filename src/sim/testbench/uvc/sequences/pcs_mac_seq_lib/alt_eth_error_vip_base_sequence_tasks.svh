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


  
// frame_size = -1 : random payload, else fix paylod(calculated based on frame size and frame type)  
virtual task send_fcs_error_frame(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1,bit ucast_en=0,bit[47:0]unicast_addr=0,bit frame_length_64= 0);
    svt_ethernet_transaction_exception_list local_exception_list;   
    svt_ethernet_transaction_exception local_exception;

    bit [7:0] num_exceptions;
    bit [1:0] sel;
    uvm_printer printer;

   `svt_xvm_create (req)

    // Incorrect FCS
    local_exception = new();
    local_exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
    local_exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INCORRECT_FCS;

    local_exception_list = new("exception_list", local_exception);
    local_exception_list.add_exception(local_exception);
    `uvm_info("Exception added", $sformatf("Added exception %s", local_exception.frame_error_kind.name()), UVM_LOW)
    local_exception.print(printer);

    req.exception_list = local_exception_list;

     // frame_size = -1 : random payload
     // frame_size >= 1 : fixed payload 

    if(frame_size != -1) begin 
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_command_type.constraint_mode(0);
      req.disable_mac_pad = 1;
    end

    if(eth_frame == DATA_FRAME) begin
	if(ucast_en == 0) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; })
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); })
      end
    end
	else begin
		req.reasonable_address.constraint_mode(0);
		`svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18);address == unicast_addr; })
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
	if(ucast_en == 0) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; })
      end
      else begin
        `svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18);})
      end
    end else begin
	req.reasonable_address.constraint_mode(0);
		`svt_xvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18);address == unicast_addr;})
	end
	end
    else if(eth_frame == PFC_FRAME) begin
	if(ucast_en == 0) begin
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; byte_count == (frame_size - 18);})
     end
    end else begin
	req.reasonable_address.constraint_mode(0);
		`svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; byte_count == (frame_size - 18);address == unicast_addr;})
		end
	end	
    else if(eth_frame == SFC_FRAME) begin
	if(ucast_en == 0) begin
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; byte_count == (frame_size - 18);})
     end
    end else begin
	req.reasonable_address.constraint_mode(0);
		`svt_xvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; byte_count == (frame_size - 18);address == unicast_addr;})
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
    else if(eth_frame == UNDERSIZE_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      req.reasonable_byte_count.constraint_mode(0);
      req.disable_mac_pad = 1;
      sel = $urandom_range(1,3);
      //NOTE : min frame size > 26 , FB-476081 (S10,100G)
      if(sel== 1) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[0:45]};})  
        //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
      end
      else if (sel == 2) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[0:41]};})
        //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
      end 
      else begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[0:37]};})
        //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix 
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
//      else if(eth_frame == LINK_FAULT) begin
////         `uvm_create(req)
//	req.command_type = svt_ethernet_enum_pkg::ETH_MAC_LINK_FAULT_SEQUENCE;
//	req.link_fault_sequence_type = link_fault_type; 
//	req.link_fault_sequence_cycle = sequence_cycle; 
//      end
    else 
   `uvm_error("alt_eth_vip_base_sequence", $sformatf("Invalid frame type %0s",eth_frame.name()));

 endtask : send_fcs_error_frame

 virtual task send_length_error_frame(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1, bit [47:0] dest_address = 48'h0, int length_type_value = 0);
    svt_ethernet_transaction_exception_list local_exception_list;   
    svt_ethernet_transaction_exception local_exception;
    bit [7:0] num_exceptions;
    bit [1:0] sel;
    int range;
    uvm_printer printer;

   `svt_xvm_create (req)

       `uvm_info(get_full_name(), $psprintf("length_type_value=  %0d ",length_type_value), UVM_NONE)
    local_exception = new();
    //local_exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
    //local_exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_LENGTH_TYPE_FIELD_CORRECT_FCS;

    local_exception_list = new("exception_list", local_exception);
    local_exception_list.add_exception(local_exception);
    `uvm_info("Exception added", $sformatf("Added exception %s", local_exception.frame_error_kind.name()), UVM_LOW)
    local_exception.print(printer);

    req.exception_list = local_exception_list;

    // frame_size = -1 : random payload
    // frame_size >= 1 : fixed payload 
    std::randomize(range) with {range > -5 && range < 10;};

    if(frame_size != -1) begin 
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_command_type.constraint_mode(0);
      req.disable_mac_pad = 1;
    end
      req.reasonable_length_type.constraint_mode(0);
      req.enable_apply_length_type = 1;

    if(eth_frame == DATA_FRAME) begin
	if(length_type_value == 0) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; length_type == byte_count+range ;})
      end
      else begin
        `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); length_type == byte_count+range ;})
      end
    end
	else begin
		`svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); length_type == length_type_value  ;})
	end
   end 
    else if(eth_frame == VLAN_FRAME) begin
      if(length_type_value == 0) begin
        if(frame_size == -1) begin
          `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME;length_type == byte_count+range ; })
        end
        else begin
          `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME; byte_count == (frame_size - 22);length_type == byte_count+range ;})
        end
      end
      else begin
       `uvm_info(get_full_name(), $psprintf("VLAN length_type_value=  %0d ",length_type_value), UVM_NONE)
          `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME; byte_count == (frame_size - 22);length_type == length_type_value ;})
      end
    end
    else if(eth_frame == STACKED_VLAN_FRAME) begin
      if(length_type_value == 0) begin
        if(frame_size == -1) begin
          `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME;length_type == byte_count+range ; })
        end
        else begin
          `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME; byte_count == (frame_size - 26);length_type == byte_count+range ;})
        end
      end
      else begin
       `uvm_info(get_full_name(), $psprintf("SVLAN length_type_value=  %0d ",length_type_value), UVM_NONE)
         `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME; byte_count == (frame_size - 26);length_type == length_type_value ;})
      end
     end
    else if(eth_frame == RANDOM_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                            svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
							    svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME
							    };})
      end
      else begin
        `svt_xvm_rand_send_with(req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                       svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					       svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME
           					       };
                                  solve command_type before byte_count;
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME}) -> (byte_count == frame_size - 18);
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME}) -> (byte_count == frame_size - 22);
			          (command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME}) -> (byte_count == frame_size - 26);})
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
     req.reasonable_address.constraint_mode(0);
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; req.address[47:0]==dest_address ; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; req.address[47:0]==dest_address ; byte_count == (frame_size - 18);})
     end
    end
    else if(eth_frame == SFC_FRAME) begin
     req.reasonable_address.constraint_mode(0);
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; req.address[47:0]==dest_address ;})
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME;req.address[47:0]==dest_address ; byte_count == (frame_size - 18);})
     end
    end
     else if(eth_frame == JUMBO_VLAN_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
          `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME; byte_count == (frame_size - 22);length_type == length_type_value ;})
      end
    else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
         `svt_xvm_rand_send_with (req, {solve byte_count before length_type;req.command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME; byte_count == (frame_size - 26);length_type == length_type_value ;})
      end
    else 
   `uvm_error("send_length_error_frame", $sformatf("Invalid frame type %0s",eth_frame.name()));

 endtask : send_length_error_frame

virtual task send_sfd_preamble_error_frame(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1);
    svt_ethernet_transaction_exception_list local_exception_list;   
    svt_ethernet_transaction_exception local_exception;

    bit [7:0] num_exceptions;
    bit [1:0] sel;
    bit [7:0]  bad_sfd;
    bit [55:0] bad_preamble;
    uvm_printer printer;

   `svt_xvm_create (req)

    // Incorrect SFD/Preamble
    bad_preamble = $urandom;
    bad_sfd = $urandom;
    local_exception = new();
    local_exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
    local_exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
    local_exception.frame_send_invalid_preamble_bits_error = bad_preamble;

    local_exception_list = new("exception_list", local_exception);
    local_exception_list.add_exception(local_exception);
    
    local_exception = new();
    local_exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
    local_exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
    local_exception.frame_invalid_sfd_error = bad_sfd;
    local_exception_list.add_exception(local_exception);
    `uvm_info("Exception added", $sformatf("Added exception %s", local_exception.frame_error_kind.name()), UVM_LOW)
    local_exception.print(printer);

    req.exception_list = local_exception_list;

     // frame_size = -1 : random payload
     // frame_size >= 1 : fixed payload 

    if(frame_size != -1) begin 
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_command_type.constraint_mode(0);
      req.disable_mac_pad = 1;
    end

    if(eth_frame == DATA_FRAME) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; })
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); })
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
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); req.address == 'h1;})
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
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; byte_count == (frame_size - 18);})
     end
    end
    else if(eth_frame == SFC_FRAME) begin
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; byte_count == (frame_size - 18);})
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
    else if(eth_frame == UNDERSIZE_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      req.reasonable_byte_count.constraint_mode(0);
      req.disable_mac_pad = 1;
      sel = $urandom_range(1,3);
      //NOTE : min frame size > 26 , FB-476081 (S10,100G)
      if(sel== 1) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[0:45]};})  
        //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
      end
      else if (sel == 2) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[0:41]};})
        //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
      end 
      else begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[0:37]};})
        //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix 
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
//      else if(eth_frame == LINK_FAULT) begin
////         `uvm_create(req)
//	req.command_type = svt_ethernet_enum_pkg::ETH_MAC_LINK_FAULT_SEQUENCE;
//	req.link_fault_sequence_type = link_fault_type; 
//	req.link_fault_sequence_cycle = sequence_cycle; 
//      end
    else 
   `uvm_error("send_sfd_preamble_error_frame", $sformatf("Invalid frame type %0s",eth_frame.name()));


 endtask : send_sfd_preamble_error_frame

virtual task send_malformed_error_frame(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1, bit [47:0]dest_address = 48'h0);
    svt_ethernet_transaction_exception_list local_exception_list;   
    svt_ethernet_transaction_exception local_exception;

    bit [7:0] num_exceptions;
    bit [1:0] sel;
    uvm_printer printer;

   `svt_xvm_create (req)

    //Malformed frame 
//    local_exception = new();
//    local_exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
//    local_exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_REPLACE_TERMINATE_CONTROL_CHAR;
//    local_exception.xgmii_replace_terminate_control_char_error = 9'h1_df;
//
//    local_exception_list = new("exception_list", local_exception);
////    local_exception_list.add_exception(local_exception);
//    
//    `uvm_info("Exception added", $sformatf("Added exception %s", local_exception.frame_error_kind.name()), UVM_LOW)
//    local_exception.print(printer);
//
//    req.exception_list = local_exception_list;

     // frame_size = -1 : random payload
     // frame_size >= 1 : fixed payload 

    if(frame_size != -1) begin 
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_command_type.constraint_mode(0);
      req.disable_mac_pad = 1;
    end

    if(eth_frame == DATA_FRAME) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; })
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); })
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
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); req.address == 'h1;})
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
     req.reasonable_address.constraint_mode(0);
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; req.address[47:0]==dest_address ; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; req.address[47:0]==dest_address ; byte_count == (frame_size - 18);})
     end
    end
    else if(eth_frame == SFC_FRAME) begin
     req.reasonable_address.constraint_mode(0);
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME;req.address[47:0]==dest_address ; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; req.address[47:0]==dest_address ; byte_count == (frame_size - 18);})
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
    else if(eth_frame == UNDERSIZE_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      req.reasonable_byte_count.constraint_mode(0);
      req.disable_mac_pad = 1;
      sel = $urandom_range(1,3);
      //NOTE : min frame size > 26 , FB-476081 (S10,100G)
      if(sel== 1) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[0:45]};})  
        //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
      end
      else if (sel == 2) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[0:41]};})
        //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
      end 
      else begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[0:37]};})
        //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix 
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
//      else if(eth_frame == LINK_FAULT) begin
////         `uvm_create(req)
//	req.command_type = svt_ethernet_enum_pkg::ETH_MAC_LINK_FAULT_SEQUENCE;
//	req.link_fault_sequence_type = link_fault_type; 
//	req.link_fault_sequence_cycle = sequence_cycle; 
//      end
    else 
   `uvm_error("send_malformed_error_frame", $sformatf("Invalid frame type %0s",eth_frame.name()));


endtask : send_malformed_error_frame

virtual task send_error_inside_frame(int no_of_frames=10, frame_type eth_frame = DATA_FRAME, int frame_size = -1);
    svt_ethernet_transaction_exception_list local_exception_list;   
    svt_ethernet_transaction_exception local_exception;

    bit [7:0] num_exceptions;
    bit [1:0] sel;
    uvm_printer printer;

   `svt_xvm_create (req)

    //Malformed frame 
    local_exception = new();
    local_exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
    local_exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
    local_exception.xgmii_insert_8bytes_inbetween_frame_error = 72'hfffefefefefefefefe;

    local_exception_list = new("exception_list", local_exception);
    local_exception_list.add_exception(local_exception);
    
    `uvm_info("Exception added", $sformatf("Added exception %s", local_exception.frame_error_kind.name()), UVM_LOW)
    local_exception.print(printer);

    req.exception_list = local_exception_list;

     // frame_size = -1 : random payload
     // frame_size >= 1 : fixed payload 

    if(frame_size != -1) begin 
      req.reasonable_byte_count.constraint_mode(0);
      req.reasonable_command_type.constraint_mode(0);
      req.disable_mac_pad = 1;
    end

    if(eth_frame == DATA_FRAME) begin
      if(frame_size == -1) begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; })
      end
      else begin
        `svt_xvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count == (frame_size - 18); })
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
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; byte_count == (frame_size - 18); req.address == 'h1;})
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
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; byte_count == (frame_size - 18);})
     end
    end
    else if(eth_frame == SFC_FRAME) begin
     if(frame_size == -1) begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; })
     end
     else begin
       `svt_xvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; byte_count == (frame_size - 18);})
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
    else if(eth_frame == UNDERSIZE_FRAME) begin
      req.reasonable_command_type.constraint_mode(0);
      req.reasonable_byte_count.constraint_mode(0);
      req.disable_mac_pad = 1;
      sel = $urandom_range(1,3);
      //NOTE : min frame size > 26 , FB-476081 (S10,100G)
      if(sel== 1) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[0:45]};})  
        //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
      end
      else if (sel == 2) begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[0:41]};})
        //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
      end 
      else begin 
        `svt_xvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[0:37]};})
        //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix 
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
//      else if(eth_frame == LINK_FAULT) begin
////         `uvm_create(req)
//	req.command_type = svt_ethernet_enum_pkg::ETH_MAC_LINK_FAULT_SEQUENCE;
//	req.link_fault_sequence_type = link_fault_type; 
//	req.link_fault_sequence_cycle = sequence_cycle; 
//      end
    else 
   `uvm_error("send_error_inside_frame", $sformatf("Invalid frame type %0s",eth_frame.name()));


endtask : send_error_inside_frame
