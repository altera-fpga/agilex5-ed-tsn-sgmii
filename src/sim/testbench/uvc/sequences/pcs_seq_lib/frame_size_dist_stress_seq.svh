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


class frame_size_dist_stress_sequence extends pcs_base_sequence;
//  sequence_0 tx_seq;
  bit rx_crc_pass;
  `uvm_object_utils(frame_size_dist_stress_sequence)

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
   svt_ethernet_transaction xact;

  function new(string name = "frame_size_dist_stress_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif

    if ($value$plusargs("num_frames=%d",num_frames)) begin
      transaction_count = num_frames;
    end
    else begin
      //transaction_count = 1000;
      transaction_count = 20000;
    end
    `uvm_info(get_full_name(), $sformatf("test run for num_frames = %0d",transaction_count), UVM_LOW)
 endfunction:new

  virtual task body();

    bit OK;
    bit core_enable;
    bit fcs_enabled;
    bit [15:0] rand_len;
    //enum {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_JUMBO_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME, svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME} frame_type;

    `uvm_info(get_type_name(), "FRAME SIZE DIST STRES SEQ BEGIN", UVM_LOW)
    apply_hard_reset(0,0,1,11);
    rx_crc_pass=$urandom;
    //dut link up
    p_sequencer.env.wait_rx_pcs_ready();

 
   //pcs_mac register not accessible in pcs_only mode   
   //reg_write(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_crc_pass); 
   `uvm_info(get_type_name(), "DONE!!! WRITING TO REG", UVM_LOW)
 //  tx_seq.start(p_sequencer.tx_seqr);

     //-------------------------------------------------------------------
     // Fire 100 Data Packets from VIP of random length.
     //-------------------------------------------------------------------


     for(int z =0 ; z < transaction_count; z++) begin
          OK = std::randomize(vip_ipg) with {vip_ipg >= 1; vip_ipg <= 12;};
          if (!OK) `uvm_fatal (get_type_name(), "VIP TX IPG randomization failed!")

          //OK = std::randomize(frame_type) with {frame_type inside {ETH_MAC_DATA_FRAME, ETH_MAC_VLAN_FRAME, ETH_MAC_JUMBO_DATA_FRAME, ETH_MAC_STACKED_VLAN_FRAME, ETH_MAC_CONTROL_FRAME, ETH_MAC_PPP_FRAME};
          //JUMBO not in this run ADD FIXME RR
          //OK = std::randomize(frame_type) with {frame_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME, svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME};};
          //if (!OK) `uvm_fatal (get_type_name(), "VIP TX FRAME TYPE randomization failed!")
        
        //`uvm_create(xact)
        `uvm_create_on(xact, p_sequencer.eth_vip_seqr_inst);
        //xact.reasonable_constraint_mode(0);
        xact.reasonable_byte_count.constraint_mode(0);
        xact.reasonable_mac_inter_frame_gap.constraint_mode(0);

       randcase 
         1: begin 
           //varied 
           //if(!xact.randomize() with {xact.command_type == frame_type; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count inside { [32'd46:32'd1500]}; xact.mac_inter_frame_gap == vip_ipg;}) begin
           if(!xact.randomize() with {xact.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME, svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count inside { [32'd46:32'd1500]}; xact.mac_inter_frame_gap == vip_ipg;}) begin
             `uvm_fatal(get_type_name(),$sformatf("frame randomization failed"))
           end
         end
         1: begin  
           //skew small
           //if(!xact.randomize() with {xact.command_type == frame_type; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count dist { [32'd46:32'd100] :=80, [32'd101: 32'd1500] :=20}; xact.mac_inter_frame_gap == vip_ipg;}) begin
           if(!xact.randomize() with {xact.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME, svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count dist { [32'd46:32'd100] :=80, [32'd101: 32'd1500] :=20}; xact.mac_inter_frame_gap == vip_ipg;}) begin
             `uvm_fatal(get_type_name(),$sformatf("frame randomization failed"))
           end
         end
         1: begin  
           //skew large 
           //if(!xact.randomize() with {xact.command_type == frame_type; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count dist { [32'd46:32'd100] :=10, [32'd101:32'd1500] :=90}; xact.mac_inter_frame_gap == vip_ipg;}) begin
           if(!xact.randomize() with {xact.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME, svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count dist { [32'd46:32'd100] :=10, [32'd101:32'd1500] :=90}; xact.mac_inter_frame_gap == vip_ipg;}) begin
             `uvm_fatal(get_type_name(),$sformatf("frame randomization failed"))
           end
         end
         1: begin  
           //equal small/large dist
           //if(!xact.randomize() with {xact.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; xact.address  == 48'h112233445566; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count dist { [32'd46:32'd100] :=50, [32'd101:32'd1500] :=50}; xact.mac_inter_frame_gap == vip_ipg;}) begin
           if(!xact.randomize() with {xact.command_type inside {svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME, svt_ethernet_enum_pkg::ETH_MAC_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_STACKED_VLAN_FRAME, svt_ethernet_enum_pkg::ETH_MAC_CONTROL_FRAME, svt_ethernet_enum_pkg::ETH_MAC_PPP_FRAME}; xact.command_mode_data == svt_ethernet_enum_pkg::ETH_DECR; xact.byte_count dist { [32'd46:32'd100] :=50, [32'd101:32'd1500] :=50}; xact.mac_inter_frame_gap == vip_ipg;}) begin
             `uvm_fatal(get_type_name(),$sformatf("frame randomization failed"))
           end
         end
       endcase 

        /** Inject the directed transaction in the output stream of Ethernet sequencer.*/
         `uvm_send(xact)

        `uvm_info("body", "DATA_FRAME has finished", UVM_LOW)
     end
    `uvm_info(get_type_name(), "FRAME SIZE DIST STRES SEQ END", UVM_LOW)
     endtask



endclass
