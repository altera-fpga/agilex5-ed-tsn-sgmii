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


`ifndef ETH_SEQ_LIB
`define ETH_SEQ_LIB

`ifdef ENABLE_ETH_VIP
class alt_eth_vip_base_sequence extends uvm_sequence #(svt_ethernet_transaction); 

  int unsigned sequence_length = 1;
  frame_type eth_frame;
  bit [1:0] sel;
  bit[9:0] sequence_cycle = 50;
  svt_ethernet_enum_pkg::link_fault_sequence_type_enum link_fault_type;
  bit [47:0] dest_address;
  bit supplementary_addr_en; 
  bit [47:0] supplementary_addr;
  int pl_size;
  int len_type;
  bit encap_pkt;

   /** UVM object utility macro */
   `uvm_object_utils(alt_eth_vip_base_sequence)

   /** Class constructor */
   function new (string name = "alt_eth_vip_base_sequence",int sequence_length=1);
      	super.new(name);
       this.sequence_length = sequence_length;
   endfunction : new

   /** Raise an objection if this is the parent sequence */
   virtual task pre_body();
  uvm_phase phase;
  super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
  if (phase!=null) begin
    phase.raise_objection(this);
  end
   endtask: pre_body
   
   /** Drop an objection if this is the parent sequence */
   virtual task post_body();
  uvm_phase phase;
  super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
       phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
  if (phase!=null) begin
    phase.drop_objection(this);
  end
   endtask: post_body

   virtual task body();
    bit status;
    //int pl_size;
    //int len_type;

    
    `uvm_info("body", "Entered ...", UVM_MEDIUM)

    for(int i = 0; i < sequence_length; i++) begin
      `uvm_info("body", $sformatf("Calling `uvm_do, iteration=%0d %s", i,eth_frame.name()), UVM_MEDIUM)

     if(eth_frame == USER_DEFINED_FRAME) begin
        //void'(std::randomize(pl_size) with {pl_size dist {[46:1500] := 70, [1501:3000] := 30};});
        //void'(std::randomize(len_type) with {len_type >= 'h600;});
        `uvm_info(get_name(),$sformatf("sending user_defined frame from VIP"),UVM_LOW)
        `uvm_create(req)
         req.address               = 48'h112233445566;
         //req.command_mode_data     = svt_ethernet_enum_pkg::ETH_INCR;//local_command_mode_data;
         req.command_type          = svt_ethernet_enum_pkg::ETH_USER_FRAME;  
         req.user_packet_type      = svt_ethernet_enum_pkg:: DATA_FRAME;
         req.enable_apply_user_pkt = 1;
         req.length_type = len_type;
         req.enable_apply_length_type = 1;

        req.user_pkt_data = new[pl_size];

         for(int i = 0; i<pl_size ;i++ ) begin
           req.user_pkt_data[i] = i;
         end
       `uvm_send(req)  
      end                      
      else  if(eth_frame == FRAME_CRC_COVERS_PREAMBLE) begin
       `uvm_send(req)  
      end
      else if(eth_frame == IPV4_FRAME) begin
          if(encap_pkt == 0) begin
            `uvm_info("ST3a", $sformatf("Not a encap packet"), UVM_MEDIUM)
                  `uvm_create(req)
                  req.reasonable_layer3_packet_type_disable.constraint_mode(0);
            req.reasonable_layer4_packet_type_disable.constraint_mode(0);    
            //Added as per C3- used Define "SVT_COMP" for to use latest version of synopsys testsuite i.e 2019.03 and above - If required qhip also need to add define further
                  `uvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; 
                                          req.layer3_packet_type  == svt_ethernet_enum_pkg::PKT_L3_IPV4;
                                          req.layer4_packet_type  == svt_ethernet_enum_pkg::PKT_L4_TCP;})
          end
	
          else begin //UDP+VXLAN
            `uvm_info("ST3a", $sformatf("ST3a: pl_size = %0d", pl_size), UVM_MEDIUM)
              `uvm_create(req)
              req.reasonable_layer_encapsulation_type_disable.constraint_mode(0);
              req.reasonable_layer_encapsulation_type.constraint_mode(0);
              req.reasonable_outer_udp_da.constraint_mode(0);
              req.length_type           = len_type;
              req.user_pkt_data = new[pl_size];

              for(int i = 0; i<pl_size ;i++ ) begin
                req.user_pkt_data[i] = i;
              end
              
              `uvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; 
                                          req.layer_encapsulation_type == svt_ethernet_enum_pkg::PKT_ENCAP_VXLAN_OVER_IPV4;})
                            
          end
	
  end
      else if(eth_frame == IPV6_FRAME) begin
        `uvm_create(req)
        req.reasonable_layer3_packet_type_disable.constraint_mode(0); 
				req.reasonable_layer4_packet_type_disable.constraint_mode(0);    //Added as per C3-used Define "SVT_COMP" for to use latest version of synopsys testsuite i.e 2019.03 and above - If required qhip also need to add define further
        `uvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; 
                                  req.layer3_packet_type  == svt_ethernet_enum_pkg::PKT_L3_IPV6;
                                  req.layer4_packet_type  == svt_ethernet_enum_pkg::PKT_L4_TCP;})
      end 
      else   if(eth_frame == DATA_FRAME) begin
        `ifdef ANLT
          `uvm_do_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; byte_count inside {[64:1500]};})
        `else
          `uvm_do_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; })
        `endif
      end
      else if(eth_frame == MCAST_DATA_FRAME) begin
      `uvm_create(req)
      req.reasonable_command_type.constraint_mode(0);

      `uvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                               svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};address[40] == 'b1;}) 
      end
      else if(eth_frame == BCAST_DATA_FRAME) begin
      `uvm_create(req)
      req.reasonable_command_type.constraint_mode(0);

      `uvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                               svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
         					                             svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};address == 'hffffffffffff;})
      end
      else if(eth_frame == UCAST_DATA_FRAME) begin
        `uvm_create(req)
         req.reasonable_command_type.constraint_mode(0);
         if( supplementary_addr_en == 1'b0) begin
          `uvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                 svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};address[40] == 'b0;})
         end
         else begin //supplementary_addr_en == 1
        `uvm_create(req)
         req.reasonable_command_type.constraint_mode(0);
         `uvm_rand_send_with (req, {command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,
                                                 svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME,
           					                             svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,
          					                             svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};address == supplementary_addr;})
        end //supplementary_addr_en
      end
      else if(eth_frame == MCAST_CTRL_FRAME) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0); 
        `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; address[40] == 'h1;})
      end
      else if(eth_frame == BCAST_CTRL_FRAME) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
        `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; address == 'hffffffffffff;})
      end
      else if(eth_frame == UCAST_CTRL_FRAME) begin
        if( supplementary_addr_en == 1'b0) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
        `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; address[40] == 'h0;})
        end else begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
        `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; address == supplementary_addr;})
        end 
     end
      else if(eth_frame == VLAN_FRAME) begin
      `uvm_do_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME; })
      end
      else if(eth_frame == JUMBO_DATA_FRAME) begin
         `uvm_create(req)
         req.reasonable_command_type.constraint_mode(0);
         `uvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME;})  
      end
      else if(eth_frame == STACKED_VLAN_FRAME) begin
      `uvm_do_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME; })
      end
      else if(eth_frame == JUMBO_VLAN_FRAME) begin
         `uvm_create(req)
         req.reasonable_command_type.constraint_mode(0);
         `uvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME;})  
      end
      else if(eth_frame == JUMBO_STACKED_VLAN_FRAME) begin
         `uvm_create(req)
         req.reasonable_command_type.constraint_mode(0);
	 `uvm_rand_send_with(req, {command_type == svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME;}) 
      end
      else if(eth_frame == CONTROL_FRAME) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
        `uvm_rand_send_with(req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME,svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; 
                                  address == dest_address;})
      end
      else if(eth_frame == PFC_FRAME) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
       if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME; 
                              address == dest_address;})
        end
        else begin
          // XON packets
          `uvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME;
                              foreach(req.mac_ppp_timer[idx])
                                req.mac_ppp_timer[idx] == 16'h0;
                                address == dest_address;})
        end  
      end
    else if(eth_frame == SFC_XOFF_FRAME) begin
        `uvm_create(req)
         req.reasonable_address.constraint_mode(0);
         req.reasonable_mac_inter_frame_gap.constraint_mode(0);
         `uvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; 
                                    req.mac_ctrl_parameter == 16'h40;
                                    mac_inter_frame_gap==10;
                                    address inside {dest_address,48'h01_80_c2_00_00_01};})
      end
    else if( eth_frame == SFC_XOFF_MAX_FRAME) begin
        `uvm_create(req)
         req.reasonable_address.constraint_mode(0);
         req.reasonable_mac_inter_frame_gap.constraint_mode(0);
         req.reasonable_mac_ctrl_parameter.constraint_mode(0);
         `uvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; 
                                    req.mac_ctrl_parameter == 16'h5fff;
                                    mac_inter_frame_gap==10;
                                    address == dest_address; })
      end 
    else if(eth_frame == SFC_XON_FRAME) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
         req.reasonable_mac_inter_frame_gap.constraint_mode(0);
   //     if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
     //     `uvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; 
       //                        address inside {dest_address,48'h01_80_c2_00_00_01};})
     //   end
       // else begin
          // XON packets
          `uvm_rand_send_with (req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME;
                               req.mac_ctrl_parameter == 16'h0;
                                mac_inter_frame_gap==10;
                               address inside {dest_address,48'h01_80_c2_00_00_01};})
     //   end
      end
      else if(eth_frame == SFC_FRAME) begin
        `uvm_create(req)
        req.reasonable_address.constraint_mode(0);
        if($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME; 
                               address == dest_address; })
        end
        else begin
          // XON packets
          `uvm_create(req)
          req.reasonable_address.constraint_mode(0);
          `uvm_rand_send_with(req, {req.command_type == svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME;
                              req.mac_ctrl_parameter == 16'h0;
                              address == dest_address; })
        end
      end 
      else if(eth_frame == RANDOM_FRAME) begin
      `uvm_create(req)
      req.reasonable_command_type.constraint_mode(0);
      `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME};})
      end
      else if(eth_frame == UNDERSIZE_FRAME) begin
         `uvm_create(req)
         req.reasonable_command_type.constraint_mode(0);
         req.reasonable_byte_count.constraint_mode(0);
	 req.disable_mac_pad = 1;
	 sel = $urandom_range(1,3);
	 //NOTE : min frame size > 26 , FB-476081 (S10,100G)
	 if(sel== 1) begin 
           `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME}; byte_count inside {[46:100]};})  
	   //  once FB- 476157 resolved change byte_count to 9:45 for <26 byte condition or as per design fix
	 end
	 else if (sel == 2) begin 
           `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_STACKED_VLAN_FRAME}; byte_count inside {[38:100]};})
	   //  once FB- 476157 resolved change byte_count to 5:45 for < 26 byte condition or as per design fix
	 end 
	 else begin 
           `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_JUMBO_VLAN_FRAME}; byte_count inside {[42:100]};})
	   //  once FB- 476157 resolved change byte_count to 1:45 for <26 byte condtion or as per design fix 
	 end 
      end
      else if(eth_frame == IPG_STRESS) begin
         `uvm_create(req)
         req.reasonable_mac_inter_frame_gap.constraint_mode(0);
         `uvm_rand_send_with (req, {req.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME,svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME,svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME};mac_inter_frame_gap==1;byte_count inside {[46:53]};})
      end

      else if(eth_frame == LINK_FAULT) begin
         `uvm_create(req)
	 req.command_type = svt_ethernet_enum_pkg::ETH_MAC_LINK_FAULT_SEQUENCE;
	 req.link_fault_sequence_type = link_fault_type; 
	 req.link_fault_sequence_cycle = sequence_cycle;
	 `uvm_send(req);
      end
      else  begin
     `uvm_error("alt_eth_vip_base_sequence", $sformatf("Invalid frame type %0s",eth_frame.name()));
      end
    end
  endtask: body

  `include "alt_eth_vip_base_sequence_tasks.svh"

endclass : alt_eth_vip_base_sequence

`include "alt_eth_vip_pcs66_base_sequence.sv"

`include "alt_eth_vip_custom_sequence.sv"

//dsamantx :this below two sequences imported from DR 
`include "eth_rx_simple_pause_sequence.sv"

`include "eth_rx_simple_pfc_sequence.sv"

`include "alt_eth_error_vip_base_sequence.sv"
`endif

class alt_eth_avalonst_base_sequence extends uvm_sequence #(eth_packet);
  `uvm_object_utils(alt_eth_avalonst_base_sequence)
  int unsigned sequence_length = 1;
  frame_type eth_frame;
  int payload_size;
  int ipg;
  int bandwidth;
  int pack_size;  
  int coverage_s;
  int num_words_local;
  bit encap_pkt;

  function new(string name = "base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

virtual task body();
    bit status;
    int pl_size;
    bit[15:0] plsize, udp_len, ip_len, inner_len;
    bit[31:0] dw0, dw1, dw2, dw3, dw4;
    bit[3:0]  ver, ihl;
    bit[2:0]  flags;
    bit[7:0]  tos, ttl, protocol;
    bit[15:0] pl_len, iden, csum;
    bit[12:0] foffset;
    bit[47:0] iSA, iDA;
    
    `uvm_info("body", "Entered ...", UVM_MEDIUM)

    for(int i = 0; i < sequence_length; i++) begin
      `uvm_info("body", $sformatf("Calling `uvm_do, iteration=%0d %s", i,eth_frame.name()), UVM_MEDIUM)

      if(eth_frame == IPV4_FRAME) begin
	if(encap_pkt == 0) begin
           `uvm_do_with(req,{frame_type == ETH_IPV4_FRAME; frame_payload_type == NORMAL; num_words==num_words_local;})
	end
        else begin //IPV4 encap pkt
	   `uvm_info("ST3", $sformatf("ST3: payload_size = %0d", payload_size), UVM_MEDIUM)

           `uvm_create(req)
           req.frame_type = ETH_IPV4_FRAME;
	   req.eth_type_or_length = 'h0800;
           req.payload_size_c.constraint_mode(0);
	   plsize = payload_size;
           ip_len = plsize;
           udp_len = plsize -20;
  	   ver = 'h4; ihl = 'h5; tos = $urandom_range(255, 1); 
	   iden = $urandom_range(255, 100);
	   flags = 'b010; foffset = $urandom_range(8, 1);
	   ttl = $urandom_range(255, 4); protocol = 'h7; csum = 0;
	   dw0 = {ver, ihl, tos, plsize};
	   dw1 = {iden, flags, foffset};
	   dw2 = {ttl, protocol, csum};
	   dw3 = 32'ha1a2a3a4; //IP source addr
	   dw4 = 32'hb1b2b3b4; //Ip dest addr
	   iSA = 48'h4455_6677_8899; 
	   iDA = 47'haabb_ccdd_eeff;

           req.payload = new[plsize];

           //IPV4
	   req.payload[0] = dw0[31:24];  req.payload[1] = dw0[23:16]; req.payload[2] = dw0[15:8]; req.payload[3] = dw0[7:0];
           req.payload[4] = dw1[31:24];  req.payload[5] = dw1[23:16]; req.payload[6] = dw1[15:8]; req.payload[7] = dw1[7:0];
           req.payload[8] = dw2[31:24];  req.payload[9] = dw2[23:16]; req.payload[10] = dw2[15:8]; req.payload[11] = dw2[7:0];
           req.payload[12] = dw3[31:24];  req.payload[13] = dw3[23:16]; req.payload[14] = dw3[15:8]; req.payload[15] = dw3[7:0]; 
           req.payload[16] = dw4[31:24];  req.payload[17] = dw4[23:16]; req.payload[18] = dw4[15:8]; req.payload[19] = dw4[7:0]; 

           //UDP
           req.payload[20] = 'h11;  req.payload[21] = 'h22; req.payload[22] = 'h12; req.payload[23] = 'hB5; //Src_addr + dest_addr
           req.payload[24] = udp_len[15:8];  req.payload[25] = udp_len[7:0]; req.payload[26] = 'h00; req.payload[27] = 'h00; //length, csum=0

           //VxLAN
           req.payload[28] = 'h08;  req.payload[29] = 'h0; req.payload[30] = 'h0; req.payload[31] = 'h0; //Flags+Rsvr
           req.payload[32] = 'h0;  req.payload[33] = 'h12; req.payload[34] = 'h34; req.payload[35] = 'h00;

	   //Inner ehternet packet
	   inner_len = plsize - 50;
           req.payload[36] = iSA[47:40]; req.payload[37] = iSA[39:32]; req.payload[38] = iSA[31:24]; req.payload[39] = iSA[23:16];
           req.payload[40] = iSA[15:8]; req.payload[41] = iSA[7:0]; req.payload[42] = iDA[47:40]; req.payload[43] = iDA[39:32];
           req.payload[44] = iDA[31:24]; req.payload[45] = iDA[23:16]; req.payload[46] = iDA[15:8]; req.payload[47] = iDA[7:0];
           req.payload[48] = inner_len[15:8];  req.payload[49] = inner_len[7:0];

           for(int i = 50; i<req.payload.size() ;i++ ) begin
              req.payload[i] = i;
           end

           `uvm_send(req)
	end
      end
      else if(eth_frame == IPV6_FRAME)
        `uvm_do_with(req,{frame_type == ETH_IPV6_FRAME; frame_payload_type == NORMAL; num_words==num_words_local;})
      else if(eth_frame == USER_DEFINED_FRAME) begin
        `uvm_create(req)
        req.payload_size_c.constraint_mode(0);
        void'(std::randomize(pl_size) with {pl_size dist {[46:1500] := 70, [1501:3000] := 30};});
        `uvm_rand_send_with(req,{frame_type == ETH_USER_DEFINED_FRAME; payload.size == pl_size; frame_payload_type == NORMAL; num_words==num_words_local;})
      end  
      else   if(eth_frame == DATA_FRAME)
           begin
	      if(bandwidth==1)
	      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;interpacket_gap==ipg;payload.size==payload_size;num_words==num_words_local;})
              else if(coverage_s==1)
	      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; interpacket_gap==ipg;payload.size==payload_size;num_words==num_words_local;})
		else
		      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
      end  
      else if(eth_frame == VLAN_FRAME)
     `uvm_do_with(req,{frame_type == ETH_VLAN_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
      else if(eth_frame == STACKED_VLAN_FRAME)
     `uvm_do_with(req,{frame_type == ETH_STACKED_VLAN_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
      else if(eth_frame == JUMBO_DATA_FRAME)
     	   begin
		   if(bandwidth==1)
	      `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL;interpacket_gap==ipg;payload.size==payload_size;num_words==num_words_local;})
              else if (coverage_s==1)
	      `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME;interpacket_gap==ipg;payload.size==payload_size;num_words==num_words_local;})
	      else
	      `uvm_do_with(req,{frame_type == ETH_JUMBO_DATA_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
      end	
      else if(eth_frame == JUMBO_VLAN_FRAME)
     `uvm_do_with(req,{frame_type == ETH_JUMBO_VLAN_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
      else if(eth_frame == JUMBO_STACKED_VLAN_FRAME)
     `uvm_do_with(req,{frame_type == ETH_JUMBO_STACKED_VLAN_FRAME;frame_payload_type == NORMAL;num_words==num_words_local;})
      else if(eth_frame == CONTROL_FRAME) begin
        if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_do_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL;num_words==num_words_local;})
        end  
        else begin
          // XON packets
          `uvm_do_with(req,{frame_type inside {ETH_SFC_FRAME,ETH_PFC_FRAME}; frame_payload_type == NORMAL;num_words==num_words_local;
                            foreach(pfc_pause_quanta[idx])
                              pfc_pause_quanta[idx] == 16'h0;
                            sfc_pause_quanta == 16'h0;})
        end
      end  
      else if(eth_frame == PFC_FRAME) begin
        if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
        end
        else begin
          // XON packets
          `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;
                            foreach(pfc_pause_quanta[idx])
                              pfc_pause_quanta[idx] == 16'h0;num_words==num_words_local;})
        end  
      end    
      else if(eth_frame == SFC_FRAME) begin
        if ($urandom_range(0,1) % 2 == 0) begin
          // XOFF packets
          `uvm_do_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type == NORMAL;num_words==num_words_local;})
        end
        else begin
          // XON packets
          `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; frame_payload_type == NORMAL;
                            sfc_pause_quanta == 16'h0;num_words==num_words_local;})
        end  
      end 
        else if(eth_frame == RANDOM_FRAME) begin
        `uvm_do_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == NORMAL;num_words==num_words_local;})
      end
      else if(eth_frame == UNDERSIZE_FRAME) begin
        `uvm_do_with(req,{frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME};frame_payload_type == UNDERSIZE;num_words==num_words_local;})
      end
      else if(eth_frame == IPG_STRESS) begin
        `uvm_create(req)
        //pl_size = (46 + (64 * $urandom_range(0,10)));
        pl_size = (46 + (64 * $urandom_range(0,10)));
        req.interpacket_gap_c.constraint_mode(0);
        req.skip_tx_crc_insertion_c.constraint_mode(0);
        `uvm_info("DBG", $sformatf("Calling `uvm_do, pl_sise = %0d", pl_size), UVM_MEDIUM)
        `uvm_rand_send_with(req,{frame_type inside {ETH_DATA_FRAME}; frame_payload_type == NORMAL; payload.size==pl_size;interpacket_gap==0;bus_rate==BUSY;num_words==num_words_local;skip_tx_crc_insertion==1;})
      end
      else 
     `uvm_error("alt_eth_avalonst_base_sequence", $sformatf("Invalid frame type %0s",eth_frame.name()));
    end
  endtask: body

  `include "alt_eth_avalonst_base_sequence_tasks.svh"

endclass

`include "alt_eth_avalonst_custom_sequence.sv"
`include "tsn_top_params.svh"

class eth_base_sequence extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(eth_base_sequence)
  `uvm_declare_p_sequencer(eth_virtual_sequencer)
  uvm_reg 	regs[$];
  uvm_reg 	select_reg;
  uvm_reg_data_t read_data;
  uvm_reg_data_t tx_max_frame_size=0;
  uvm_reg_data_t rx_max_frame_size=0;
  uvm_reg_data_t tx_pad_control;
  `ifdef ENABLE_ETH_VIP
  svt_ethernet_transaction eth_pkt;
  `endif
  bit dis_stats_chk=0;
  bit rx_am_valid_high =1'b0;
  bit dis_ehip_drop_frame_cntr=0; 
  int num_of_frames;
  bit [47:0] dest_address='h01_80_c2_00_00_01;
  bit no_traffic=0;
  uvm_reg_data_t stats_tx_counter[string]; // To store stats counter values
  uvm_reg_data_t stats_rx_counter[string]; // To store stats counter values
  typedef enum {ALL_REG,COMM_REG,EHIP_REG,MAC_CFG_REG,MAC_STAT_REG,LPHY_FEC_REG} reg_type; 
  reg_type set_reg_range;
  bit [47:0] src_address;

  function new(string name = "base_seq");
   super.new(name);
   `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
   `endif
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
     void'(std::randomize(num_of_frames) with { num_of_frames dist {[500:700]:=35 , [701:1000]:=25 , [1001:2000]:=20 , [2001:3000]:=10 , [3001:5000]:=10};});
   end    
   `ifdef ENABLE_ETH_VIP
   eth_pkt = new ("eth_pkt");
   `endif

  endfunction:new

  `ifdef ENABLE_ETH_VIP
   //`ifdef ANLT   //dsamantx: FIX ME for GDR ANLT
   //  task setup_anlt();
   //   bit [31:0] an_c0_reg;
   //   bit [31:0] an_b0_reg;
   //   // C0
   //   an_c0_reg = {16'h737D,8'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1};
// FIXME-MISSING_REG_IN_GDR   //   p_sequencer.env.reg_write(`REGISTERS_an_cfg1_OFFSET_REG,an_c0_reg);
   //   // B0
   //   an_b0_reg = {17'b0,1'b0,1'b0,1'b0,9'b0,1'b0,1'b0,1'b1};
// FIXME-MISSING_REG_IN_GDR   //   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,an_b0_reg);
   //   // Reset SEQ
   //   read_data=32'b0;
// FIXME-MISSING_REG_IN_GDR   //   p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data,.disable_check(1'b1));
   //   read_data[`REGISTERS_anlt_seq_cfg_reset_seq_BITOFFSET_FIELD]=1'b1;
// FIXME-MISSING_REG_IN_GDR   //   p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
   //  endtask // setup_anlt
   //`endif
  `endif

  /*
  task reg_write_xcvr_full(uvm_reg_data_t addr,uvm_reg_data_t data,input bit [7:0] select=8'hFF );
    reg_write_xcvr(addr,data[7:0],select);
    reg_write_xcvr(addr+1,data[15:8],select);
    reg_write_xcvr(addr+2,data[23:16],select);
    reg_write_xcvr(addr+3,data[31:24],select);
  endtask : reg_write_xcvr_full
*/
  /*
task reg_write_xcvr(uvm_reg_data_t addr,uvm_reg_data_t data,input bit [7:0] select=8'hFF);
   // dsamantx : FIX ME for GDR_XCVR as we never tested
   uvm_status_e      status;
   uvm_reg 	regs_0[$],regs_1[$],regs_2[$],regs_3[$],regs_4[$],regs_5[$],regs_6[$],regs_7[$];
   uvm_reg 	select_reg_0,select_reg_1,select_reg_2,select_reg_3,select_reg_4,select_reg_5,select_reg_6,select_reg_7;
   bit reg_not_found_0 =1,reg_not_found_1 =1,reg_not_found_2 =1,reg_not_found_3 =1,reg_not_found_4 =1,reg_not_found_5 =1,reg_not_found_6 =1,reg_not_found_7 =1;
   altuvm_avalon_mm_write_seq write_seq_0,write_seq_1,write_seq_2,write_seq_3,write_seq_4,write_seq_5,write_seq_6,write_seq_7;

   //muralasx: FIXME for GDR 
   case(p_sequencer.env.dyn_rcfg_obj_inst.ch_num)
    2: select = select & 8'b00000011;
    4: select = select & 8'b00001111;
    8: select = select & 8'b11111111;
   endcase

   fork
     begin
       if(select[0] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_0.default_map.get_registers(regs_0);
         foreach(regs_0[i]) begin
           if (addr == regs_0[i].get_address()) begin
             select_reg_0 = regs_0[i];
             reg_not_found_0 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 0  Register(%s) address 'h%0h write data :'h%0h",select_reg_0.get_name(),addr,data), UVM_NONE)
             select_reg_0.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_0.default_map));
           end
         end  
       end
     end
     begin
       if(select[1] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_1.default_map.get_registers(regs_1);
         foreach(regs_1[i]) begin
           if (addr == regs_1[i].get_address()) begin
             select_reg_1 = regs_1[i];
             reg_not_found_1 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 1  Register(%s) address 'h%0h write data :'h%0h",select_reg_1.get_name(),addr,data), UVM_NONE)
             select_reg_1.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_1.default_map));
           end
         end  
       end
     end
     begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[2] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_2.default_map.get_registers(regs_2);
         foreach(regs_2[i]) begin
           if (addr == regs_2[i].get_address()) begin
             select_reg_2 = regs_2[i];
             reg_not_found_2 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 2  Register(%s) address 'h%0h write data :'h%0h",select_reg_2.get_name(),addr,data), UVM_NONE)
             select_reg_2.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_2.default_map));
           end
         end  
       end
      end 
     end
     begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[3] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_3.default_map.get_registers(regs_3);
         foreach(regs_3[i]) begin
           if (addr == regs_3[i].get_address()) begin
             select_reg_3 = regs_3[i];
             reg_not_found_3 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 3  Register(%s) address 'h%0h write data :'h%0h",select_reg_3.get_name(),addr,data), UVM_NONE)
             select_reg_3.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_3.default_map));
           end
         end  
       end
      end 
     end
     begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_200G,_400G}) begin
       if(select[4] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_4.default_map.get_registers(regs_4);
         foreach(regs_4[i]) begin
           if (addr == regs_4[i].get_address()) begin
             select_reg_4 = regs_4[i];
             reg_not_found_4 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 4  Register(%s) address 'h%0h write data :'h%0h",select_reg_4.get_name(),addr,data), UVM_NONE)
             select_reg_4.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_4.default_map));
           end
         end  
       end
      end 
     end
     begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[5] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_5.default_map.get_registers(regs_5);
         foreach(regs_5[i]) begin
           if (addr == regs_5[i].get_address()) begin
             select_reg_5 = regs_5[i];
             reg_not_found_5 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 5  Register(%s) address 'h%0h write data :'h%0h",select_reg_5.get_name(),addr,data), UVM_NONE)
             select_reg_5.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_5.default_map));
           end
         end  
       end
      end 
     end
     begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[6] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_6.default_map.get_registers(regs_6);
         foreach(regs_6[i]) begin
           if (addr == regs_6[i].get_address()) begin
             select_reg_6 = regs_6[i];
             reg_not_found_6 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 6  Register(%s) address 'h%0h write data :'h%0h",select_reg_6.get_name(),addr,data), UVM_NONE)
             select_reg_6.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_6.default_map));
           end
         end  
       end
      end 
     end
     begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[7] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_7.default_map.get_registers(regs_7);
         foreach(regs_7[i]) begin
           if (addr == regs_7[i].get_address()) begin
             select_reg_7 = regs_7[i];
             reg_not_found_7 = 0 ;
             `uvm_info("AVMM REG WRITE", $sformatf("XCVR : 7  Register(%s) address 'h%0h write data :'h%0h",select_reg_7.get_name(),addr,data), UVM_NONE)
             select_reg_7.write(status,.value(data), .map(p_sequencer.env.xcvr_reg_model_7.default_map));
           end
         end  
       end
      end 
     end
   join

   fork
     begin
       if(select[0] === 1'b1) begin
         if(reg_not_found_0 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 0   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_0 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_0, p_sequencer.xcvr_avmm_sequencer_0, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                //`ifdef CRETE3   //dsamantx:FIXME for GDR
                //writedata[0] == data[7:0]; 
		//`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
		//`endif
              })
         end   
       end
     end
     begin
       if(select[1] === 1'b1) begin
         if(reg_not_found_1 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 1   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_1 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_1, p_sequencer.xcvr_avmm_sequencer_1, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
               // `ifdef CRETE3
               //  writedata[0] == data[7:0]; 
	       // `else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
	//	`endif
              })
         end   
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G,_200G,_400G}) begin
       if(select[2] === 1'b1) begin
         if(reg_not_found_2 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 2   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_2 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_2, p_sequencer.xcvr_avmm_sequencer_2, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                //`ifdef CRETE3
                // writedata[0] == data[7:0]; 
		//`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
		//`endif
              })
         end   
       end
      end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G,_200G,_400G}) begin
       if(select[3] === 1'b1) begin
         if(reg_not_found_3 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 3   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_3 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_3, p_sequencer.xcvr_avmm_sequencer_3, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                //`ifdef CRETE3
                // writedata[0] == data[7:0]; 
		//`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
		//`endif
              })
         end   
       end
      end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[4] === 1'b1) begin
         if(reg_not_found_4 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 4   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_4 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_4, p_sequencer.xcvr_avmm_sequencer_4, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                //`ifdef CRETE3
                // writedata[0] == data[7:0]; 
		//`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
		//`endif
              })
         end   
       end
      end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[5] === 1'b1) begin
         if(reg_not_found_5 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 5   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_5 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_5, p_sequencer.xcvr_avmm_sequencer_5, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
        //        `ifdef CRETE3
        //         writedata[0] == data[7:0]; 
	//	`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
	//	`endif
              })
         end   
       end
      end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[6] === 1'b1) begin
         if(reg_not_found_6 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 6   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_6 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_6, p_sequencer.xcvr_avmm_sequencer_6, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
               // `ifdef CRETE3
               //  writedata[0] == data[7:0]; 
		//`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
		//`endif
              })
         end   
       end
      end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[7] === 1'b1) begin
         if(reg_not_found_7 == 1) begin
           `uvm_warning("AVMM REG WRITE", $sformatf("XCVR : 7   No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
           write_seq_7 = altuvm_avalon_mm_write_seq::type_id::create("write");
           `uvm_do_on_with(write_seq_7, p_sequencer.xcvr_avmm_sequencer_7, {
                 init_latency inside {[0:3]};
                 address   == addr<<2;
                 foreach (byteenable[i]) byteenable[i] == 1;
                //`ifdef CRETE3
                // writedata[0] == data[7:0]; 
		//`else
	    	 writedata[0] == data[7:0]; 
	    	 writedata[1] == data[15:8]; 
	    	 writedata[2] == data[23:16]; 
	    	 writedata[3] == data[31:24]; 
		//`endif
              })
         end   
       end
      end
     end
    //`endif vinoth2x
   join

 endtask  


  task reg_read_xcvr_full(uvm_reg_data_t addr,ref uvm_reg_data_t read_data[4][8],input bit [7:0] select = 8'hFF,input bit disable_check=0);
      reg_read_xcvr(addr,read_data[0],select,disable_check);
      reg_read_xcvr(addr+1,read_data[1],select,disable_check);
      reg_read_xcvr(addr+2,read_data[2],select,disable_check);
      reg_read_xcvr(addr+3,read_data[3],select,disable_check);
  endtask : reg_read_xcvr_full

  task reg_read_xcvr(uvm_reg_data_t addr,ref uvm_reg_data_t read_data[8],input bit [7:0] select = 8'hFF,input bit disable_check=0);
   // dsamantx : FIXME for GDR XCVR
   uvm_status_e      status;
   uvm_reg 	regs_0[$],regs_1[$],regs_2[$],regs_3[$],regs_4[$],regs_5[$],regs_6[$],regs_7[$];
   uvm_reg 	select_reg_0,select_reg_1,select_reg_2,select_reg_3,select_reg_4,select_reg_5,select_reg_6,select_reg_7;
   altuvm_avalon_mm_read_seq           read_seq_0,read_seq_1,read_seq_2,read_seq_3,read_seq_4,read_seq_5,read_seq_6,read_seq_7;
   bit [31:0] rsvd_val = 'd0;
   bit reg_not_found_0 =1,reg_not_found_1 =1,reg_not_found_2 =1,reg_not_found_3 =1,reg_not_found_4 =1,reg_not_found_5 =1,reg_not_found_6 =1,reg_not_found_7 =1;

   //muralasx: FIXME for GDR 
   case(p_sequencer.env.dyn_rcfg_obj_inst.ch_num)
    2: select = select & 8'b00000011;
    4: select = select & 8'b00001111;
    8: select = select & 8'b11111111;
   endcase

   read_data = {32'h0,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0,32'h0};
   fork
     begin
       if(select[0] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_0.default_map.get_registers(regs_0);
         foreach(regs_0[i]) begin
           if (addr == regs_0[i].get_address()) begin
             select_reg_0 = regs_0[i];
             reg_not_found_0 = 0 ;
             select_reg_0.read(status,.value(read_data[0]), .map(p_sequencer.env.xcvr_reg_model_0.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 0  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_0.get_name(),addr,read_data[0],select_reg_0.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_0.get_mirrored_value() != read_data[0])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 0  Register(%s) read data mismatch for address %h",select_reg_0.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 0  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_0.get_name(),addr,read_data[0]), UVM_NONE)
   	     end
           end	
         end  
       end
     end
     begin
       if(select[1] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_1.default_map.get_registers(regs_1);
         foreach(regs_1[i]) begin
           if (addr == regs_1[i].get_address()) begin
             select_reg_1 = regs_1[i];
             reg_not_found_1 = 0 ;
             select_reg_1.read(status,.value(read_data[1]), .map(p_sequencer.env.xcvr_reg_model_1.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 1  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_1.get_name(),addr,read_data[1],select_reg_1.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_1.get_mirrored_value() != read_data[1])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 1  Register(%s) read data mismatch for address %h",select_reg_1.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 1  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_1.get_name(),addr,read_data[1]), UVM_NONE)
   	     end
           end	
         end  
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G,_200G,_400G}) begin
       if(select[2] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_2.default_map.get_registers(regs_2);
         foreach(regs_2[i]) begin
           if (addr == regs_2[i].get_address()) begin
             select_reg_2 = regs_2[i];
             reg_not_found_2 = 0 ;
             select_reg_2.read(status,.value(read_data[2]), .map(p_sequencer.env.xcvr_reg_model_2.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 2  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_2.get_name(),addr,read_data[2],select_reg_2.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_2.get_mirrored_value() != read_data[2])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 2  Register(%s) read data mismatch for address %h",select_reg_2.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 2  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_2.get_name(),addr,read_data[2]), UVM_NONE)
   	     end
           end	
         end  
       end
      end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G,_200G,_400G}) begin
       if(select[3] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_3.default_map.get_registers(regs_3);
         foreach(regs_3[i]) begin
           if (addr == regs_3[i].get_address()) begin
             select_reg_3 = regs_3[i];
             reg_not_found_3 = 0 ;
             select_reg_3.read(status,.value(read_data[3]), .map(p_sequencer.env.xcvr_reg_model_3.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 3  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_3.get_name(),addr,read_data[3],select_reg_3.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_3.get_mirrored_value() != read_data[3])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 3  Register(%s) read data mismatch for address %h",select_reg_3.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 3  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_3.get_name(),addr,read_data[3]), UVM_NONE)
   	     end
           end	
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[4] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_4.default_map.get_registers(regs_4);
         foreach(regs_4[i]) begin
           if (addr == regs_4[i].get_address()) begin
             select_reg_4 = regs_4[i];
             reg_not_found_4 = 0 ;
             select_reg_4.read(status,.value(read_data[4]), .map(p_sequencer.env.xcvr_reg_model_4.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 4  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_4.get_name(),addr,read_data[4],select_reg_4.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_4.get_mirrored_value() != read_data[4])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 4  Register(%s) read data mismatch for address %h",select_reg_4.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 4  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_4.get_name(),addr,read_data[4]), UVM_NONE)
   	     end
           end	
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[5] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_5.default_map.get_registers(regs_5);
         foreach(regs_5[i]) begin
           if (addr == regs_5[i].get_address()) begin
             select_reg_5 = regs_5[i];
             reg_not_found_5 = 0 ;
             select_reg_5.read(status,.value(read_data[5]), .map(p_sequencer.env.xcvr_reg_model_5.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 5  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_5.get_name(),addr,read_data[5],select_reg_5.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_5.get_mirrored_value() != read_data[5])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 5  Register(%s) read data mismatch for address %h",select_reg_5.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 5  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_5.get_name(),addr,read_data[5]), UVM_NONE)
   	     end
           end	
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[6] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_6.default_map.get_registers(regs_6);
         foreach(regs_6[i]) begin
           if (addr == regs_6[i].get_address()) begin
             select_reg_6 = regs_6[i];
             reg_not_found_6 = 0 ;
             select_reg_6.read(status,.value(read_data[6]), .map(p_sequencer.env.xcvr_reg_model_6.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 6  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_6.get_name(),addr,read_data[6],select_reg_6.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_6.get_mirrored_value() != read_data[6])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 6  Register(%s) read data mismatch for address %h",select_reg_6.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 6  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_6.get_name(),addr,read_data[6]), UVM_NONE)
   	     end
           end	
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       if(select[7] === 1'b1) begin
         p_sequencer.env.xcvr_reg_model_7.default_map.get_registers(regs_7);
         foreach(regs_7[i]) begin
           if (addr == regs_7[i].get_address()) begin
             select_reg_7 = regs_7[i];
             reg_not_found_7 = 0 ;
             select_reg_7.read(status,.value(read_data[7]), .map(p_sequencer.env.xcvr_reg_model_7.default_map));
   	     if(disable_check == 0)begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 7  Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h",select_reg_7.get_name(),addr,read_data[7],select_reg_7.get_mirrored_value()), UVM_NONE)
   	       if(select_reg_7.get_mirrored_value() != read_data[7])
   	       `uvm_error("AVMM REG READ", $sformatf("XCVR : 7  Register(%s) read data mismatch for address %h",select_reg_7.get_name(),addr));
   	     end
   	     else begin
   	       `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] XCVR : 7  Register(%s) address 'h%0h actual read data :'h%0h",select_reg_7.get_name(),addr,read_data[7]), UVM_NONE)
   	     end
           end	
         end  
       end
       end
     end
    //`endif  vinoth2x
   join

   fork
     begin
       if(select[0] === 1'b1) begin
         if(reg_not_found_0 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 0 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_0  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_0, p_sequencer.xcvr_avmm_sequencer_0, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[0] = {read_seq_0.readdata[3],read_seq_0.readdata[2],read_seq_0.readdata[1],read_seq_0.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[0]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 0  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[0],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 0  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[0],rsvd_val), UVM_NONE)
           end
         end  
       end  
     end
     begin
       if(select[1] === 1'b1) begin
         if(reg_not_found_1 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 1 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_1  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_1, p_sequencer.xcvr_avmm_sequencer_1, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[1] = {read_seq_1.readdata[3],read_seq_1.readdata[2],read_seq_1.readdata[1],read_seq_1.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[1]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 1  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[1],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 1  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[1],rsvd_val), UVM_NONE)
           end    
         end  
       end  
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[2] === 1'b1) begin
         if(reg_not_found_2 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 2 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_2  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_2, p_sequencer.xcvr_avmm_sequencer_2, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[2] = {read_seq_2.readdata[3],read_seq_2.readdata[2],read_seq_2.readdata[1],read_seq_2.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[2]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 2  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[2],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 2  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[2],rsvd_val), UVM_NONE)
           end 
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[3] === 1'b1) begin
         if(reg_not_found_3 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 3 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_3  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_3, p_sequencer.xcvr_avmm_sequencer_3, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[3] = {read_seq_3.readdata[3],read_seq_3.readdata[2],read_seq_3.readdata[1],read_seq_3.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[3]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 3  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[3],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 3  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[3],rsvd_val), UVM_NONE)
           end    
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[4] === 1'b1) begin
         if(reg_not_found_4 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 4 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_4  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_4, p_sequencer.xcvr_avmm_sequencer_4, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[4] = {read_seq_4.readdata[3],read_seq_4.readdata[2],read_seq_4.readdata[1],read_seq_4.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[4]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 4  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[4],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 4  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[4],rsvd_val), UVM_NONE)
           end    
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[5] === 1'b1) begin
         if(reg_not_found_5 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 5 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_5  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_5, p_sequencer.xcvr_avmm_sequencer_3, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[5] = {read_seq_5.readdata[3],read_seq_5.readdata[2],read_seq_5.readdata[1],read_seq_5.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[5]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 5  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[5],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 5  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[5],rsvd_val), UVM_NONE)
           end    
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[6] === 1'b1) begin
         if(reg_not_found_6 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 6 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_6  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_6, p_sequencer.xcvr_avmm_sequencer_6, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[6] = {read_seq_6.readdata[3],read_seq_6.readdata[2],read_seq_6.readdata[1],read_seq_6.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[6]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 6  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[6],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 6  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[6],rsvd_val), UVM_NONE)
           end    
         end  
       end
       end
     end
     begin
       if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside{_100G,_200G,_400G}) begin
       if(select[7] === 1'b1) begin
         if(reg_not_found_7 == 1) begin
           `uvm_warning("AVMM REG READ", $sformatf("XCVR 7 : No Register found with address :%0h,it seems reserved space",addr));
           read_seq_7  = altuvm_avalon_mm_read_seq::type_id::create("read");
           `uvm_do_on_with(read_seq_7, p_sequencer.xcvr_avmm_sequencer_7, {
                           init_latency inside {[0:3]};
                           address   == addr << 2;  
                           foreach (byteenable[i]) byteenable[i] == 1;
           })
           read_data[7] = {read_seq_7.readdata[3],read_seq_7.readdata[2],read_seq_7.readdata[1],read_seq_7.readdata[0]};
           if(disable_check == 0) begin
             if(rsvd_val != read_data[7]) 
               `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 7  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[7],rsvd_val))
             else 
               `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] XCVR : 7  Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data[7],rsvd_val), UVM_NONE)
           end    
         end  
       end
       end
     end
    //`endif  vinoth2x
   join

 endtask
   */
 `include "eth_base_sequence_tasks.svh"

 `ifdef ENABLE_ETH_VIP
 task send_link_fault( svt_ethernet_enum_pkg::link_fault_sequence_type_enum link_fault_type,bit[ 9:0] sequence_cycle);
   alt_eth_vip_base_sequence eth_seq;
   `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
   eth_seq.eth_frame = LINK_FAULT;
   eth_seq.sequence_cycle = sequence_cycle; 
   eth_seq.link_fault_type = link_fault_type; 
   `uvm_info("send_remote_link_fault", $sformatf("sending %0s frame from vip tx",link_fault_type.name()),UVM_MEDIUM);
   eth_seq.start(p_sequencer.eth_vip_seqr_inst);
 endtask
 
 task generate_hiber();
   p_sequencer.env.mac_66_err_callback.enable_injection = 1;
   p_sequencer.env.mac_66_err_callback.err_inj_cnt = 0;
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
   while(p_sequencer.env.mac_66_err_callback.err_inj_cnt < 60)
   begin
     #10ns;
   end
   p_sequencer.env.mac_66_err_callback.enable_injection = 0;
 endtask


 `endif

 task send_eth_frame(frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int no_of_frames=1, bit short_packet =0, bit supplementary_addr_en=0, bit[47:0] supplementary_addr='h0);
   alt_eth_avalonst_base_sequence avl_tx_pkt;
   int num_words_local;
   `ifdef ENABLE_ETH_VIP
      // RX PATH
      alt_eth_vip_base_sequence eth_seq;
      if((path == ETH_VIP_AVL_RX) || (path == ETH_VIP_MAC_BOTH)) begin
         `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
         eth_seq.eth_frame = f_type;
         eth_seq.sequence_length = no_of_frames;
         eth_seq.dest_address = dest_address;
         eth_seq.supplementary_addr_en = supplementary_addr_en;
         eth_seq.supplementary_addr = supplementary_addr;
         `uvm_info("send_eth_frame", $sformatf("sending %0s frame from vip tx",f_type.name()),UVM_MEDIUM);
         eth_seq.req = eth_pkt;
         eth_seq.start(p_sequencer.eth_vip_seqr_inst);

         
      end
      // TX Path in PCS66 mode
      if((path == OTN_MODE) || (path == FLEXE_MODE)) begin
         alt_eth_vip_pcs66_base_sequence eth_seq_otn_flexe;
         `uvm_create_on(eth_seq_otn_flexe, p_sequencer.eth_vip_seqr_inst_otn_flexe);
         eth_seq_otn_flexe.eth_frame = f_type;
         eth_seq_otn_flexe.sequence_length = no_of_frames;
         `uvm_info("send_eth_frame", $sformatf("sending %0s frame from vip tx",f_type.name()),UVM_MEDIUM);
         eth_seq_otn_flexe.start(p_sequencer.eth_vip_seqr_inst_otn_flexe);
      end
   `endif
    num_words_local = (p_sequencer.env.spy_if.speed == _10G) ? 1: //[TODO] Need to update with actual values
                        (p_sequencer.env.spy_if.speed == _25G) ? 1:
                        (p_sequencer.env.spy_if.speed == _40G) ? 2:
                        (p_sequencer.env.spy_if.speed == _50G) ? 2:
                        (p_sequencer.env.spy_if.speed == _100G)? 4:
                        (p_sequencer.env.spy_if.speed == _200G)? 8:16;
   // TX Path MAC/PCS_ONLY
   if (p_sequencer.env.dyn_rcfg_obj_inst.mode inside {PCSONLY,PCSMAC,MACSEG}) begin
     if((path == AVL_TX_ETH_VIP) || (path == ETH_VIP_MAC_BOTH)) begin
     	if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSONLY) begin
           `uvm_create_on(avl_tx_pkt, p_sequencer.env.mii_tx_agent.m_sqr);
        end else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin
           `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
           `uvm_create_on(avl_tx_pkt,p_sequencer.v_m_sqr);
        end 
        
        avl_tx_pkt.eth_frame = f_type;
        avl_tx_pkt.sequence_length = no_of_frames;
        avl_tx_pkt.bandwidth=0;
        avl_tx_pkt.num_words_local=num_words_local;
        if(short_packet == 1) begin
           avl_tx_pkt.payload_size=650;
           avl_tx_pkt.ipg = 1;
           avl_tx_pkt.coverage_s = 1;
        end
        tx_pad_control = p_sequencer.env.gdr_ral_get("tx_pad_control");
        if((tx_pad_control[0]==1'b0) && (f_type == UNDERSIZE_FRAME) && (p_sequencer.env.eth_ref_model_inst.tx_underflow_case ==1'b0)) begin //If padding is disabled, client should not send undersized frames
          f_type = DATA_FRAME;
          avl_tx_pkt.eth_frame = f_type;
        end
        
        `uvm_info("send_eth_frame", $sformatf("sending %0s frame from avalon tx",f_type.name()),UVM_MEDIUM);
        
        if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSONLY) begin
           avl_tx_pkt.start(p_sequencer.env.mii_tx_agent.m_sqr);
        end else if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin
           avl_tx_pkt.start(p_sequencer.tx_seqr);
        end
        else if (p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
        	  avl_tx_pkt.start(p_sequencer.v_m_sqr);
        end 
     end // if ((path == AVL_TX_ETH_VIP) || (path == ETH_VIP_MAC_BOTH))
  end // if(mode inside {PCSONLY,PCSMAC,MACSEG)

  

 endtask // send_eth_frame

 task send_constrained_eth_frame(frame_type f_type = DATA_FRAME,xfer_path path = AVL_TX_ETH_VIP,int no_of_frames=1,int payloadsize= 1,int coverage_s=0,int packet_size=0, bit encap=0);
   alt_eth_avalonst_base_sequence avl_tx_pkt;

  `ifdef ENABLE_ETH_VIP
   alt_eth_vip_base_sequence eth_seq;
   if((path == ETH_VIP_AVL_RX) || (path == ETH_VIP_MAC_BOTH)) begin
    `uvm_create_on(eth_seq, p_sequencer.eth_vip_seqr_inst);
     eth_seq.eth_frame = f_type;
     eth_seq.sequence_length = no_of_frames;
     eth_seq.pl_size = payloadsize;
     eth_seq.len_type = packet_size;
     eth_seq.encap_pkt = encap;
     //dsamantx : FIXEME - for explicit payload from client is not constrained. Do we need to control the payload?
     `uvm_info("send_eth_frame", $sformatf("sending %0s frame from vip tx",f_type.name()),UVM_MEDIUM);
     eth_seq.start(p_sequencer.eth_vip_seqr_inst);
   end
  `endif
   
   if((path == AVL_TX_ETH_VIP) || (path == ETH_VIP_MAC_BOTH)) begin
    `uvm_create_on(avl_tx_pkt, p_sequencer.tx_seqr);
     avl_tx_pkt.eth_frame = f_type;
     avl_tx_pkt.sequence_length = no_of_frames;
     avl_tx_pkt.payload_size=payloadsize;
     avl_tx_pkt.encap_pkt = encap;

     if(coverage_s==0)
      avl_tx_pkt.bandwidth=1;
     else
     avl_tx_pkt.bandwidth=0;
     avl_tx_pkt.pack_size=packet_size;	
     avl_tx_pkt.coverage_s=coverage_s;
     if(payloadsize==46)    
       avl_tx_pkt.ipg=1;
     else
       avl_tx_pkt.ipg=0;
     `uvm_info("send_eth_frame", $sformatf("sending %0s frame from avalon tx",f_type.name()),UVM_MEDIUM);
     avl_tx_pkt.start(p_sequencer.tx_seqr);
   end
 endtask // send_eth_frame


 task wait_all_frames_to_be_done(int txdp_pkt_num=0 ,int rxdp_pkt_num =txdp_pkt_num );
      string func_name = "wait_all_frames_to_be_done";
      
      p_sequencer.txdp_pkt_cnt=p_sequencer.txdp_pkt_cnt+txdp_pkt_num;
      `ifdef ENABLE_ETH_VIP
        p_sequencer.rxdp_pkt_cnt=p_sequencer.rxdp_pkt_cnt+rxdp_pkt_num;
      `endif
      `uvm_info(get_full_name(), $sformatf("%s:sequence_pkt_length TX_cnt:%0d RX_cnt:%0d so Waiting for transmission to be done ",func_name,txdp_pkt_num,rxdp_pkt_num), UVM_LOW)
      fork
        p_sequencer.env.wait_mac_tx_frames_done(.exp_num(p_sequencer.txdp_pkt_cnt));
        p_sequencer.env.wait_tx_frames_received(.exp_num(p_sequencer.txdp_pkt_cnt));
        `ifdef ENABLE_ETH_VIP
         p_sequencer.env.wait_vip_tx_frames_done(.exp_num(p_sequencer.rxdp_pkt_cnt));
         p_sequencer.env.wait_client_rx_frames_done(.exp_num(p_sequencer.rxdp_pkt_cnt-p_sequencer.env.eth_ref_model_inst.drop_count));
        `endif
      join
      `uvm_info(get_full_name(), $sformatf("%s:Waiting for total TXDP_PKT :%0d RXDP_PKT :%0d transmitted successfully ",func_name,p_sequencer.txdp_pkt_cnt,p_sequencer.rxdp_pkt_cnt), UVM_LOW)

 endtask


  task concurrent_tx_dis();
    bit[31:0]    reg_base_addr;
    bit[3:0]     byte_en;
    int          num_shift;
    // bit[31:0]    rd_data, wr_data;
    uvm_reg_data_t rd_data, wr_data;

      //Turn off TxDisable
      if(NUM_PHY == 3) begin
         reg_base_addr = 'h1002_0180;
         num_shift     = 1; 
         wr_data       = 0;
         byte_en       = 'b1100;
         p_sequencer.env.reg_write_axi('hB, reg_base_addr, wr_data, byte_en, num_shift);
         p_sequencer.env.reg_read_axi('hB, reg_base_addr, rd_data, num_shift);
  
         reg_base_addr = 'h1002_0200;
         p_sequencer.env.reg_write_axi('hB, reg_base_addr, wr_data, byte_en, num_shift);
         p_sequencer.env.reg_read_axi('hB, reg_base_addr, rd_data, num_shift);
      end

  endtask : concurrent_tx_dis
  

 `ifdef ENABLE_ETH_VIP
    //This funciton will give control to access registers from compliance testsuite. Refer cl73_compliance_seq_lib.sv and dut_reg_write/read tasks in nvs_eth_dut_status_check_status_task for usage
   virtual task check_reg_wr_rd();
    // TBD if (p_sequencer.env.dyn_rcfg_obj_inst.mode != OTN && p_sequencer.env.dyn_rcfg_obj_inst.mode != FLEXE) begin
    // TBD  fork
    // TBD    begin
    // TBD      while(1)
    // TBD      begin
    // TBD        p_sequencer.env.ts_tasks_if.dut_reg_read_req();
    // TBD        p_sequencer.env.reg_read(p_sequencer.env.ts_tasks_if.addr,read_data);
    // TBD        p_sequencer.env.ts_tasks_if.read_data = read_data;
    // TBD        p_sequencer.env.ts_tasks_if.dut_reg_read_done();
    // TBD      end
    // TBD    end
    // TBD    begin
    // TBD      while(1)
    // TBD      begin
    // TBD        p_sequencer.env.ts_tasks_if.dut_reg_write_req();
    // TBD        p_sequencer.env.reg_write(p_sequencer.env.ts_tasks_if.addr,p_sequencer.env.ts_tasks_if.write_data);
    // TBD        p_sequencer.env.ts_tasks_if.dut_reg_write_done();
    // TBD      end
    // TBD    end
    // TBD  //dsamantx :FIXME FOR GDR ANLT
    // TBD  //`ifdef CRETE3
    // TBD  //begin
    // TBD  // if(p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
    // TBD  //  begin
    // TBD  //    while(1)
    // TBD  //    begin
    // TBD  //      p_sequencer.env.ts_tasks_if.spico_restart_req();
    // TBD  //      reset_spico();
    // TBD  //      p_sequencer.env.ts_tasks_if.spico_restart_done();
    // TBD  //    end
    // TBD  //  end
    // TBD  //end
    // TBD  //`endif
    // TBD  join_none
    // TBD //`endif
    // TBD //`endif
    // TBD end
   endtask; // check_reg_wr_rd
 `endif //  `ifdef ENABLE_ETH_VIP

  task enable_disable_anlt_reset();
   //dsamantx :FIX ME FOR GDR ANLT
   //if(p_sequencer.env.dyn_rcfg_obj_inst.anlt==1) begin
  //  enable_disable_lt(0);
  //  enable_disable_an(0);
// FIXME-MISSING_REG_IN_GDR  //  p_sequencer.env.reg_read(`REGISTERS_anlt_seq_cfg_OFFSET_REG,read_data);
  //  read_data[0] = 1;
// FIXME-MISSING_REG_IN_GDR  //  p_sequencer.env.reg_write(`REGISTERS_anlt_seq_cfg_OFFSET_REG, read_data);
  //end
  endtask

  task enable_disable_lt(bit LT_en);
    `uvm_info(get_name(), $sformatf("LT_en:%0d",LT_en), UVM_NONE);
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
    read_data[0] = LT_en;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_lt_cfg1_OFFSET_REG,read_data);
  endtask

  task enable_disable_an(bit AN_en);
    `uvm_info(get_name(), $sformatf("AN_en:%0d",AN_en), UVM_NONE);
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_an_cfg1_OFFSET_REG,read_data);
    end
    else begin
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_read(`REGISTERS_an_cfg1_OFFSET_REG,read_data,1); //Consortium ignored
    end
    read_data[0] = AN_en;
// FIXME-MISSING_REG_IN_GDR    p_sequencer.env.reg_write(`REGISTERS_an_cfg1_OFFSET_REG,read_data);
  endtask

  `ifdef UVM_VERSION_1_0
  virtual task pre_body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);
  endtask:pre_body

  virtual task post_body();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask:post_body
  `endif

  virtual task body();

    if(p_sequencer.env.dyn_rcfg_obj_inst.sa==1) begin
      `uvm_info(get_name(),$sformatf("Source Address Insertion parameter selected\n"),UVM_NONE);      
       src_address = $random();
       src_address[40]=0;
       $display("Source address %0h",src_address);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[31:0]);
       p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[47:32]);
    end
   
  endtask : body
  
  `ifdef UVM_VERSION_1_1
  virtual task pre_start();
    `ifdef ENABLE_ETH_VIP
      if (p_sequencer.env.dyn_rcfg_obj_inst.mode inside {PCSONLY,OTN,FLEXE}) begin
         //Disabling vector scoreboard and stat checking in PCS_ONLY mode
         dis_stats_chk=1;
         dis_vec_sb();
      end
    `endif
  endtask:pre_start

  virtual task post_start();
    //use no_traffic for tests which doesn't send any traffic like some of CL73 testsuite cases
    `ifdef ENABLE_ETH_VIP
      if(no_traffic==0)
      begin
        #4000ns;//Wait till all packets are reached to VIP/DUT RX
      end
      //read and compare all stats at the end of all stat sequence
      if(p_sequencer.env.dyn_rcfg_obj_inst.enable_stas_count == 1 && !dis_stats_chk )   
      begin 
        `uvm_info("eth_base_sequence", "read and compare all stats at the end of sequence", UVM_NONE)
        read_and_compare_stats();
      end 
    `endif
  endtask:post_start
  `endif
   

 // `ifdef ANLT    //dsamantx :FIX ME for GDR ANLT
 //  `ifdef CRETE3
   task reset_spico(bit an_only=1'b0);
    /* //dsamantx :FIX ME for GDR ANLT as here all are hard coded path
      string func_name = "reset_spico";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
      fork: wait_reg_toggle
	 begin
	    `uvm_info(get_type_name(), $sformatf("%s: Waiting for reg_203/reg_207",func_name), UVM_LOW);
	    if (an_only) begin
	       wait (p_sequencer.env.spy_if.reg_203[p_sequencer.env.dyn_rcfg_obj_inst.ch_num]==8'h81);
	       wait (p_sequencer.env.spy_if.reg_207[p_sequencer.env.dyn_rcfg_obj_inst.ch_num]==8'h80);
	       if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num==0) begin
		  // Force i_sbus_reset_in_sim high for 200ns
		//`ifdef G100 vinoth2x
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		  `ifdef FALCON_MESA
		      //`ifdef PTP_MODE vinoth2x
                      if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                      end
                    //`else vinoth2x
                      else begin
                    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                      end
                    //`endif //PTP vinoth2x
		  `else
                   //`ifdef PTP_MODE vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                    end
                    //`else vinoth2x
                    else begin
		    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                    end
                    //`endif //PTP vinoth2x
		  `endif //FALCON_MESA
                  end
                  else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25//G25 vinoth2x
		  //`ifdef RSFEC vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
		    `ifdef FALCON_MESA
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		    `else
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		    `endif
                    end
                    else begin
		  //`else vinoth2x
		    `ifdef FALCON_MESA
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		    `else
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		    `endif
                    end
                    end
		  //`endif vinoth2x
		//`endif vinoth2x
		  #200ns;
		//`ifdef G100 vinoth2x
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		  `ifdef FALCON_MESA
		    //`ifdef PTP_MODE vinoth2x
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                     end
                     else begin
		     //`else vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                     end
		     //`endif //PTP vinoth2x
		  `else //FALCON_MESA
		     //`ifdef PTP_MODE vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                      end
                      else begin
		     //`else vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                    end
		    //`endif //PTP vinoth2x
		  `endif //FALCON_MESA
                  end
                  else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25//G25 vinoth2x
		  //`ifdef RSFEC vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
		    `ifdef FALCON_MESA
		      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		    `else
		      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		    `endif
                    end
                    else begin
		  //`else vinoth2x
		     `ifdef FALCON_MESA
		        uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		        uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		     `else
		        uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		        uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		     `endif
                    end
                   end
		  //`endif vinoth2x
		//`endif vinoth2x
	       end else if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num==1) begin
		//`ifdef G100 vinoth2x
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		 `ifdef FALCON_MESA
		  //`ifdef PTP_MODE vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  end
                  else begin
                  //`else  vinoth2x
                      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  end
                   //`endif //PTP vinoth2x
                 `else //FALCON_MESA
		  //`ifdef PTP_MODE vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  end
                  else begin
		   //`else //PTP vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  end
	 	   //`endif //PTP vinoth2x
		  `endif //FALCON_MESA
                 end
                else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25// G25 vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		//`endif vinoth2x
                end
		  #200ns;
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		//`ifdef G100 vinoth2x
		`ifdef FALCON_MESA
		  //`ifdef PTP_MODE vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		   uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                   end
                   else begin
		   //`else //PTP vinoth2x
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		   uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		    //`endif //PTP vinoth2x
                    end
    		   `else
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                    //`ifdef PTP_MODE vinoth2x
		    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		     //`else //PTP vinoth2x
                     end
                     else begin
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		    //`endif //PTP vinoth2x
                    end
		  `endif //FALCON_MESA
                  end
                else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25// G25 vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		//`endif vinoth2x
                end
	       end else if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num==2) begin
               if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		`ifdef G100 vinoth2x
		 `ifdef FALCON_MESA
                  //`ifdef PTP_MODE vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                   end
		   //`else //PTP vinoth2x
                   else begin
       		   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                   end
                   //`endif //PTP vinoth2x
                 `else //FALCON_MESA
                   if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		   //`ifdef PTP_MODE vinoth2x
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                   end
                   else begin
                   //`else //PTP vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                   end
                    //`endif //PTP vinoth2x
		  `endif //FALCON_MESA
                  end
                  else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25//G25 vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		  //`endif vinoth2x
                  end
		  #200ns;
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		//`ifdef G100 vinoth2x
		`ifdef FALCON_MESA
		 //`ifdef PTP_MODE vinoth2x
                 if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                  end
                  else begin
		  //`else //PTP end
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                   //`endif //PTP vinoth2x
                  end
		`else
		   //`ifdef PTP_MODE vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                   end
                   else begin
                    //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		   //`endif //PTP vinoth2x
                   end
		  `endif //FALCON_MESA
                  end
                  else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25//G25 vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		//`endif vinoth2x
                end
	       end else if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num==3) begin
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		//`ifdef G100 vinoth2x
		 `ifdef FALCON_MESA
		  //`ifdef PTP_MODE vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  end
                  else begin
	 	  //`else //PTP vinoth2x
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		  //`endif //PTP vinoth2x
                  end
                 //`else vinoth2x
                 //`ifdef PTP_MODE vinoth2x
                 if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
 		    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 end
                 else begin
		  //`else //PTP vinoth2x
		    uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		   //`endif //PTP vinoth2x
                  end
		  `endif //FACOL_MESA
                 end
                 else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25 //G25 vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		//`endif vinoth2x
                end
		  #200ns;
		//`ifdef G100 vinoth2x
                if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		`ifdef FALCON_MESA
                 //`ifdef PTP_MODE vinoth2x
                 if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		   uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                   end
                   else begin
		   //`else //PTP vinoth2x
                   uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		   uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                   //`endif //PTP vinoth2x
                   end
    		`else
                  //`ifdef PTP_MODE vinoth2x
                  if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                  end
                  else begin
		  //`else //PTP vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		   //`endif //PTP vinoth2x
                   end
		  `endif //FALCON_MESA
                end
                else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		//`elsif G10_25//G25 vinoth2x
		  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		//`endif vinoth2x
                end
	       end
	    end else begin
	       fork
		  begin
		     wait (p_sequencer.env.spy_if.reg_203[0]==8'h81);
		     wait (p_sequencer.env.spy_if.reg_207[0]==8'h80);
		     // Force i_sbus_reset_in_sim high for 200ns
		   //`ifdef G100 vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		     `ifdef FALCON_MESA
			//`ifdef PTP_MODE vinoth2x
                        if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
			uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                         end
                         else begin
                         //`else //PTP vinoth2x
		        uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
			//`endif //PTP vinoth2x
                        end
		     `else
			//`ifdef PTP_MODE vinoth2x
                        if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
			uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                        end
                        else begin
			//`else //PTP vinoth2x
		        uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       //`endif //PTP vinoth2x
                       end
		     `endif //FALCON_MESA
                     end
                   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     //`ifdef RSFEC vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
		       `ifdef FALCON_MESA
		          uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       `else
		          uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       `endif
                     end
                     else begin
		     //`else vinoth2x
		       `ifdef FALCON_MESA
		          uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       `else
		          uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       `endif
		     //`endif vinoth2x
                     end
		   //`endif vinoth2x
                   end
		     #200ns;
		   //`ifdef G100 vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		     `ifdef FALCON_MESA
                       //`ifdef PTP_MODE vinoth2x
                       if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
			uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		        uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                        end
                        else begin
			//`else //PTP vinoth2x
		        uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		        uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
			//`endif //PTP vinoth2x
                        end
		     `else
			//`ifdef PTP_MODE vinoth2x
                        if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
			 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		        uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                        end
                        else begin
                        //`else //PTP vinoth2x
		        uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		        uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                       //`endif //PTP vinoth2x
                       end
		     `endif //FALCON_MESA
                   end
                   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     //`ifdef RSFEC vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
		        `ifdef FALCON_MESA
		           uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		           uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		        `else
		           uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		           uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		        `endif
                        end
                     else begin
		     //`else vinoth2x
		        `ifdef FALCON_MESA
		           uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		           uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		        `else
		           uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		           uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		        `endif
		     //`endif vinoth2x
                     end
		   //`endif vinoth2x
                   end
		     `uvm_info(get_type_name(), $sformatf("%s: CH0 sbus_reset done",func_name), UVM_LOW)
		  end
		`ifdef G100// TODO: Multi channel need to revisit for 10/25G
		  begin
		     wait (p_sequencer.env.spy_if.reg_203[1]==8'h81);
		     wait (p_sequencer.env.spy_if.reg_207[1]==8'h80);
		     // Force i_sbus_reset_in_sim high for 200ns
		   //`ifdef G100 vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		   `ifdef FALCON_MESA
                    //`ifdef PTP_MODE vinoth2x
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                    end
                    else begin
		    //`else //PTP vinoth2x
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		     //`endif //PTP vinoth2x
                     end
       		   `else
                    //`ifdef PTP_MODE vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                     end
                     else begin
		    //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       //`endif //PTP vinoth2x
                      end
		     `endif //FALCON_MESA
                     end
                   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		   //`endif vinoth2x
                   end
		     #200ns;
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		   //`ifdef G100 vinoth2x
		    `ifdef FALCON_MESA
                      //`ifdef PTP_MODE vinoth2x
                      if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                       end
                       else begin
                       //`else //PTP vinoth2x
          	      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		       //`endif //PTP vinoth2x
                       end
		    `else
                      //`ifdef PTP_MODE vinoth2x
                      if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                     end
                     else begin
		     //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		       //`endif //PTP vinoth2x
                     end
		     `endif //FALCON_MESA
                   end
                   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[1].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		   //`endif vinoth2x
                   end
		     `uvm_info(get_type_name(), $sformatf("%s: CH1 sbus_reset done",func_name), UVM_LOW)
		  end
		  begin
		     wait (p_sequencer.env.spy_if.reg_203[2]==8'h81);
		     wait (p_sequencer.env.spy_if.reg_207[2]==8'h80);
		     // Force i_sbus_reset_in_sim high for 200ns
		   //`ifdef G100 vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		   `ifdef FALCON_MESA
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		    //`ifdef PTP_MODE vinoth2x
		      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                     end
                     else begin
		     //`else //PTP vinoth2x
        	      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		     //`endif //PTP vinoth2x
                     end
       		    `else
                     //`ifdef PTP_MODE vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                      end
                      else begin
		      //`else //PTP vinoth2x
		       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       //`endif //PTP vinoth2x
                       end
		     `endif //FALCON_MESA
                     end
                   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		   //`endif vinoth2x
                   end
		     #200ns;
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		   //`ifdef G100 vinoth2x
		   `ifdef FALCON_MESA
		     //`ifdef PTP_MODE vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                     end
                     else begin
		     //`else //PTP	 vinoth2x
          	      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		      //`endif //PTP vinoth2x
                      end
     		    `else
                     if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		     //`ifdef PTP_MODE vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                     end
                     else begin
		     //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		      //`endif //PTP vinoth2x
                      end
		     `endif //FALCON_MESA
                     end
                   else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[2].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		   //`endif vinoth2x
                   end
		     `uvm_info(get_type_name(), $sformatf("%s: CH2 sbus_reset done",func_name), UVM_LOW)
		  end
		  begin
		     wait (p_sequencer.env.spy_if.reg_203[3]==8'h81);
		     wait (p_sequencer.env.spy_if.reg_207[3]==8'h80);
		     // Force i_sbus_reset_in_sim high for 200ns
		   //`ifdef G100 vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		   `ifdef FALCON_MESA
		     //`ifdef PTP_MODE vinoth2x
                     if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                      end
                      else begin
		      //`else //PTP vinoth2x
         	     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                      //`endif //PTP vinoth2x
                      end
       		    `else
                      //`ifdef PTP_MODE vinoth2x
                      if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                      end
                      else begin
		      //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		       //`endif //PTP vinoth2x
                       end
		     `endif //FALCON_MESA
                    end
                    else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
		   //`endif vinoth2x
                   end
		     #200ns;
		   //`ifdef G100 vinoth2x
                   if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) begin
		   `ifdef FALCON_MESA
		    //`ifdef PTP_MODE vinoth2x
                    if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                     end
                     else begin
		     //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                      //`endif //PTP vinoth2x
                      end
      		    `else
                      //`ifdef PTP_MODE vinoth2x
                      if(p_sequencer.env.dyn_rcfg_obj_inst.ptp) begin
                     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NOFEC_PTP_PR.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                      end
                      else begin
		      //`else //PTP vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.E100GX4_NO_FEC.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
                       end
		       //`endif //PTP vinoth2x
		     `endif //FALCON_MESA
                     end
                    else if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G, _25G}) begin
		   //`elsif G10_25//G25 vinoth2x
		     uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
		     uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[3].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
		   //`endif vinoth2x
                   end
		     `uvm_info(get_type_name(), $sformatf("%s: CH3 sbus_reset done",func_name), UVM_LOW)
		  end
		`endif
	       join
	    end
	    disable wait_reg_toggle;
	 end
	 begin
	    #1ms;
	    `uvm_warning(get_type_name(), $sformatf("%s: Timeout waiting for reg_203/reg_207",func_name));
	 end
      join_any
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
    */ //dsamantx :FIX ME for GDR ANLT
   endtask // reset_spico

task reset_spico_25g(bit an_only=1'b0);
      /*dsamantx :FIX ME for GDR ANLT
      string func_name = "reset_spico_25g";
      `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW);
      fork: wait_reg_toggle
      begin
        `uvm_info(get_type_name(), $sformatf("%s: Waiting for reg_203/reg_207",func_name), UVM_LOW);
        if (an_only) begin
           wait (p_sequencer.env.spy_if.reg_203[0]==8'h81);
           wait (p_sequencer.env.spy_if.reg_207[0]==8'h80);
           //`ifdef RSFEC vinoth2x
           if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
              `ifdef FALCON_MESA
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 #200ns;
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                 uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `else
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 #200ns;
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                 uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `endif
            end
            else begin
           //`else vinoth2x
              `ifdef FALCON_MESA
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 #200ns;
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                 uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `else
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 #200ns;
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                 uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `endif
           //`endif vinoth2x
           end
        end
        else begin
            wait (p_sequencer.env.spy_if.reg_203[0]==8'h81);
            wait (p_sequencer.env.spy_if.reg_207[0]==8'h80);
            //`ifdef RSFEC vinoth2x
            if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type) begin
              `ifdef FALCON_MESA
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 #200ns;
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                 uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `else
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                 #200ns;
                 uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                 uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY_RSFEC.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `endif
              end
              else begin
            //`else vinoth2x
               // Force i_sbus_reset_in_sim high for 200ns
               `ifdef FALCON_MESA
                  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  #200ns;
                  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_fm_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_fm_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
               `else
                  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",1);
                  #200ns;
                  uvm_hdl_force("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim",0);
                  uvm_hdl_release("eth_env_top.dut.top.alt_ehipc3_hard_inst.SL_NPHY.altera_xcvr_native_inst.alt_ehipc3_nphy_elane_sim.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.i_sbus_reset_in_sim");
              `endif
            //`endif vinoth2x
            end
        end
        disable wait_reg_toggle;
      end
      begin
         #1ms;
         `uvm_warning(get_type_name(), $sformatf("%s: Timeout waiting for reg_203/reg_207",func_name));
      end
      join
      `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
      *///dsamantx :FIX ME FOR GDR ANLT
endtask // reset_spico_25g
   
   //`endif //  `ifdef CRETE3
  //`endif
endclass

  `ifdef NON_ANLT_PTP

//DM_TODO: `include "eth_ipg_col_rem_sequence.sv"
`include "eth_mac_switch_speed_sequence.sv"

`include "sanity_sequence.sv"
`include "sanity_reg.sv"

//TSN Sequences ---------
`include "tsn_sanity_sequence.sv"
`include "tsn_sanity_reg.sv"
`include "tsn_csr_regs.sv"
`include "tsn_mphy_regs.sv"
`include "tsn_mphy_traffic_seq.sv"
`include "tsn_csr_mphy_regs.sv"
`include "tsn_csr_mphy_regs_traffic.sv"
`include "tsn_mphy_dl_regs.sv"
`include "tsn_mid_txreset_seq.sv"
`include "tsn_midsim_rst_seq.sv"
`include "tsn_mphy_rst_seq.sv"
`include "tsn_perf_test_seq.sv"
`include "tsn_perf_mix_pktsize_seq.sv"
`include "tsn_perf_large_pktsize_seq.sv"
`include "tsn_mphy_dl_measure.sv"
`include "tsn_eth64B_rxtx_traffic.sv"
`include "tsn_eth128B_rxtx_traffic.sv"
`include "tsn_eth256B_rxtx_traffic.sv"
`include "tsn_eth1518B_rxtx_traffic.sv"
`include "tsn_eth1522B_rxtx_traffic.sv"
`include "tsn_eth1526B_rxtx_traffic.sv"
`include "tsn_ucsr_mphy_cov_regs.sv"
`include "tsn_eth_mix_rxtx_traffic.sv"
`include "tsn_encap_pkts_seq.sv"

//End TSN Sequences -----

`ifdef COMPL_TC
`include "cl46_compliance_seq_lib.sv";
`include "cl36_compliance_seq_lib.sv";
`include "cl4_compliance_seq_lib.sv";
`endif

`include "auto_neg_sanity_sequence.sv"
`ifdef ETH_MULTI_PORT
	`include "sanity_loopback_sequence.sv"
	`include "auto_neg_rst_during_data_sequence.sv"
	`include "auto_neg_rst_during_an_sequence.sv"
	`include "auto_neg_diff_ability_sequence.sv"
	`include "bringup_sequence.sv"
	`include "pcs66_sanity_sequence.sv"
	`include "short_packet_sequence.sv"
	`include "fixed_stress_sequence.sv"
	`include "updown_stress_sequence.sv"
	`include "coverage_sequence.sv"
`else
//`include "sanity_loopback_sequence.sv"
//TODO LL10G `include "auto_neg_rst_during_data_sequence.sv"
//TODO LL10G `include "auto_neg_rst_during_an_sequence.sv"
//TODO LL10G `include "auto_neg_diff_ability_sequence.sv"
//`include "bringup_sequence.sv"
//`include "pcs66_sanity_sequence.sv"
//`include "short_packet_sequence.sv"
//`include "fixed_stress_sequence.sv"
//`include "updown_stress_sequence.sv"
//`include "coverage_sequence.sv"
`endif

`include "mac_payload_increment_cov_sequence.sv"

`include "sanity_1k_sequence.sv"

`include "extended_reset_sanity_sequence.sv"

`include "pcs_sanity_sequence.sv"

`include "bandwidth_sequence.sv"

`include "fc_rand_seq.sv"

`include "eth_fc_cov_seq.sv"

`include "mac_control_cov_seq.sv"

//DM_TODO: remove `include "fc_fb_seq.sv"

//DM_TODO: remove `include "fc_fb_seq1.sv"
//DM_TDODO: remove `include "fc_pfc_rand_seq.sv"

//DM_TODO : uncomment `include "eth_fc_rxfwd_rand_seq.sv"
`include "eth_fc_rxfwd_rand_seq.sv"
`include "eth_tx_rx_packet_control_seq.sv"
 `include "eth_supplementary_addr_chk_seq.sv"
`include "eth_rx_overflow_seq.sv"
`include "eth_mac_frame_mgbaset_rx_cov_sequence.sv"
`include "eth_mac_frame_mgbaset_tx_cov_sequence.sv"

////*******************************************************************************
//// Sequence Name: tx_padding_sequence
//// Descriptions: 
//// 1. running for every Parameter combination.
//// 2. Toggle reset.randomize bit8 of rxmac control
//// 3. Register value of MAC_CRC_CONFIG and max_frame_size is randomized.
//// 4. 300-500 Packets of sizes 1-8, 9-64, >64 of random patterns are sent on MAC TX.
////*******************************************************************************
//`include "tx_padding_sequence.sv"

////*******************************************************************************
//// Sequence Name: preamble_pass_sequence
//// Descriptions: 
//// 1. every Parameter combination is run. 
//// 2. Toggle reset.
//// 3. max_frame_size is randomized.
//// 4. 300-500 Packets of random sizes and patterns are sent back to back from 
////    TX as well as RX.
////*******************************************************************************
`include "preamble_pass_sequence.sv"

////=============================================================================================================
////*******************************************************************************
//// Sequence Name: crc_pass_sequence
//// Descriptions: 
//// 1. run for every combination of Parameter values .
//// 2. Toggle reset.Register value of MAC_CRC_CONFIG and max_frame_size is randomized.
//// 3. 300-500 Packets of random sizes (<64 and >64) are sent back to back from TX.
////*******************************************************************************
`include "crc_pass_sequence.sv"
`ifdef ETH_MULTI_PORT
`include "tx_underflow_sequence.sv"
`else
//`include "tx_underflow_sequence.sv"
`endif
//DM_TODO: uncomment `include "crc_includes_preamble_sequence.sv"
// fov coverage
`include "preamble_and_crc_pass_sequence_cov.sv"
`include "vip_sanity_sequence.sv"

`ifdef ENABLE_ETH_VIP
    `include "eth_malf_decoder_seq_lib.sv"
//DM_TODO: uncomment `include "vip_oversize_frame_sequence.sv"
`endif

//DM_TODO: uncomment `include "eth_avalonst_to_serial_simplex_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_avalonst_to_serial_duplex_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_hard_reset_recovery_hw_issue_sequence.sv"
 
`include "eth_hard_reset_recovery_sequence.sv"
 
//DM_TODO: uncomment `include "eth_hard_reset_recovery_rst_delay_sequence.sv"
 
`include "eth_soft_reset_recovery_sequence.sv"
 
//DM_TODO: uncomment `include "eth_b2b_hard_reset_recovery_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_b2b_hard_reset_recovery_short_frames_sequence.sv"
//DM_TODO: uncomment 
`include "eth_ipg_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_undersize_frame_sequence.sv"
//DM_TODO: uncomment 
`include "eth_txmax_payload_frame_sequence.sv"
//DM_TODO: uncomment 
`ifdef ENABLE_ETH_VIP
`include "eth_rxmax_payload_frame_sequence.sv"
//DM_TODO: uncomment `include "eth_rxmax_payload_frame_sequence_fb_523238.sv"
`endif
//DM_TODO: uncomment 
//DM_TODO: uncomment //This sequence test  csr register read-write access value.
//DM_TODO: uncomment `include "eth_register_access_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_sip_reg_access_sequence.sv"
//DM_TODO: uncomment `include "eth_hip_reg_access_sequence.sv"
`include "eth_register_mac_access_sequence.sv"
`include "eth_register_pcs_access_sequence.sv"
`include "eth_register_mac_invalid_addr_sequence.sv"
//DM_TODO: uncomment `include "eth_register_access_sequence_1.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_access_sequence_2.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_access_sequence_3.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_access_sequence_4.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_access_sequence_5.sv"
`include "eth_register_access_sequence_6.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_timeout_seq.sv"
//DM_TODO: uncomment 
//`include "eth_xcvr_register_access_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //`ifdef CRETE3
//DM_TODO: uncomment `include "eth_register_rsfec_reset_sequence.sv"
//DM_TODO: uncomment //`endif
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_ip_sloop_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_register_ip_hard_reset_sequence
//DM_TODO: uncomment //This sequence test the csr register reset value.
//DM_TODO: uncomment `include "eth_register_ip_hard_reset_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_phy_reg_sequence
//DM_TODO: uncomment //This sequence test the csr register reset value.
//DM_TODO: uncomment `include "eth_phy_reg_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_phy_deskew_reg_sequence
//DM_TODO: uncomment //This sequence test the csr register reset value.
//DM_TODO: uncomment `include "eth_phy_deskew_reg_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_phy_deskew_reg_sequence_1
//DM_TODO: uncomment //This sequence test the csr register reset value.
//DM_TODO: uncomment `include "eth_phy_deskew_reg_sequence_1.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_phy_deskew_reg_sequence
//DM_TODO: uncomment //This sequence test the csr register reset value.
//DM_TODO: uncomment `include "eth_phy_deskew_reg_sequence_FB_509441.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_phy_deskew_reg_sequence_1
//DM_TODO: uncomment //This sequence test the csr register reset value.
//DM_TODO: uncomment `include "eth_phy_deskew_reg_sequence_1_FB_509441.sv"
//DM_TODO: uncomment 
  //Class : eth_padding_sequence
  //new sequence
  `include "eth_padding_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment //Class : eth_rx_padding_sequence
//DM_TODO: uncomment `include "eth_rx_padding_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment // This is more a directed testcase for eth_rx_padding_sequence to do max_rx_size boundary sweeping
//DM_TODO: uncomment `include "eth_rx_boundary_sweep_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_write_reserved_space_FF.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_write_reserved_space.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_register_write_reserved_space_1.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment // Space Range : 'hF00-'h7FFF
//DM_TODO: uncomment `include "eth_register_write_reserved_space_2.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment // Space Range : 'h8000-'hFFFF
//DM_TODO: uncomment `include "eth_register_write_reserved_space_3.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_reset_during_access_register.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_soft_reset_during_access_register.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_phy_frmerr_reg_sequence.sv"
//DM_TODO: uncomment 
`ifdef ENABLE_ETH_VIP
`include "eth_link_fault_sequences.sv"
`include "eth_rsfec_sequences.sv"
`include "eth_stat_checkers_sequence_library.sv"
`include "pcs_seq_lib.sv"
`endif
`endif
//DM_TODO: uncomment `ifdef ENABLE_ETH_VIP
//DM_TODO: uncomment `include "eth_an_sequence_lib.sv"
//DM_TODO: uncomment `include "eth_lt_sequences.sv"
//DM_TODO: uncomment `endif
//DM_TODO: uncomment `include "eth_register_write_reserved_space_anlt_ptp.sv"
//DM_TODO: uncomment `include "eth_soft_kr_register_access_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "fb_495115_hard_rst_seq.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "fb_495115_soft_rst_seq.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "sweep_parameter_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_xcvr_tx_rx_cal_force_seq.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_reset_code_coverage_for_txrx_ch_rst_inst.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_reset_state_code_coverage.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_packet_ext.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_txrx_crc_cover_preamble_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment 
//DM_TODO: uncomment `ifdef ENABLE_ETH_VIP
//DM_TODO: uncomment `include "eth_ref_clk_code_coverage.sv"
//DM_TODO: uncomment `endif
`endif
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_rx_reset_recovery_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_tx_reset_recovery_sequence.sv"
//DM_TODO: uncomment 
//DM_TODO: uncomment `include "eth_csr_rst_during_master_read_directed_sequence.sv"
//DM_TODO: uncomment `include "eth_csr_rst_no_impact_master_read_directed_sequence.sv"
