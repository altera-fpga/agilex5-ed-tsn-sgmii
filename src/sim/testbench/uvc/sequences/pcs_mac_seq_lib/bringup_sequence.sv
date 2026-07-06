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


class bringup_sequence extends eth_base_sequence;

  `uvm_object_utils(bringup_sequence)

  bit [47:0] dest_address='h01_80_c2_00_00_01;

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=10;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

virtual task body();
    `uvm_info("eth_seq_lib", "running bringup sequence with incremental data \n",UVM_LOW)
    fork
        begin   //AVST TX - VIP RX
            
            eth_packet req_mac;
            `uvm_create_on(req_mac, p_sequencer.tx_seqr);
            for(int i = 0; i < num_of_frames; i++) begin
            
            req_mac.payload_size_c.constraint_mode(0);
            `uvm_rand_send_with(req_mac,{frame_type == ETH_DATA_FRAME; frame_payload_type == NORMAL; payload.size == 'd46; payload_typ== INCR;})
            
            end
            
        end      

            `ifdef ENABLE_ETH_VIP
        begin   //VIP TX - AVST RX
            svt_ethernet_transaction req_vip;
            `uvm_create_on(req_vip, p_sequencer.eth_vip_seqr_inst);
            for(int i = 0; i < num_of_frames; i++) begin

                req_vip.reasonable_byte_count.constraint_mode(0);
                `uvm_rand_send_with (req_vip, {req_vip.command_type == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME; req_vip.command_mode_data == svt_ethernet_enum_pkg::ETH_INCR; req_vip.byte_count =='d46; })

            end
        end
            `endif
    join

  
  endtask
endclass
