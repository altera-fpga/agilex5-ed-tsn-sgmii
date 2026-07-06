//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_TRAFFIC_SEQ_SVH__
`define __MUX_TRAFFIC_SEQ_SVH__

//------------------------------------------------------------------------------
// Class: mux_traffic_seq
//
// MUX Register Sequence.
//
//------------------------------------------------------------------------------
class mux_traffic_seq extends mux_base_seq;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   //    NONE

   //---------------------------------------------------------------------------
   // Variables
   //---------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils(mux_traffic_seq)

   //---------------------------------------------------------------------------
   // Constraints
   //---------------------------------------------------------------------------

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //
   function new(string name = "mux_traffic_seq");
      super.new(name);
   endfunction : new

   //
   // Task: pre_body
   //
   // UVM sequence's pre_body task.
   //
   virtual task pre_body();
      super.pre_body();
   endtask : pre_body

   //
   // Task: body
   //
   // UVM sequence's body task.
   //
   virtual task body();
     // 
     svt_ethernet_transaction eth_trans;
     //
     repeat(m_env.m_env_config.pargs.trans_count) begin
      `ifdef MUX_DEBUG
       `uvm_create_on(eth_trans,m_env.ethernet_mac_mst[0].sequencer)
       `else
       `uvm_create_on(eth_trans, m_env.m_eth_env[0].m_eth_sqcr)
      `endif
       eth_trans.reasonable_mac_inter_frame_gap.constraint_mode(0);
       eth_trans.reasonable_layer2_packet_type_disable.constraint_mode(0);
       eth_trans.reasonable_command_type.constraint_mode(0);
       eth_trans.reasonable_select_macsec_sci.constraint_mode(0); //Shut off reasonable constraint which otherwise selects mux_secure_channel_identifier[0] by default
       eth_trans.user_pkt_data = new[42];
       if(!eth_trans.randomize() with {eth_trans.command_type == svt_ethernet_enum_pkg::ETH_USER_FRAME;
                                       eth_trans.address  == 48'hE2_01_06_D7_CD_0D;
                                       eth_trans.layer2_packet_type == svt_ethernet_enum_pkg::PKT_L2_MACSEC;
                                       eth_trans.select_macsec_sci == 32'd3; // LOOK_HERE->Selects mux_secure_channel_identifier[3] programmed in tests/ts.gmii_layer2_256bit_mux_test.sv
                                                                            //  LOOK_HERE -> mac_cfg.mux_secure_channel_identifier[3] =  64'h78761E8DCD3D0089;
                                       eth_trans.macsec_association_number       == 2'h0; // LOOK_HERE -> The SCI & AN will be concatenated and searched for a match in the new array mac_cfg.mux_sci_an_index
                                                         // LOOK_HERE -> A match is found in location 6 of the new array : mac_cfg.mux_sci_an_index[5] =  {64'h78761E8DCD3D0089,2'h0};
                                                         // LOOK_HERE -> Encryption Key is taken from corresponding location 6 of key array : mac_cfg.mux_key_256bit
                                                         // LOOK_HERE -> mac_cfg.mux_key_256bit[5] =  256'h6789AEE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B66;

                                                         // LOOK_HERE -> Receive VIP will decode SCI and AN from incoming packet : SCI=64'h78761E8DCD3D0089 & AN=2'h0;
                                                         // LOOK_HERE -> These 2 fields will be concatenated and match looked for in array : phy_cfg.mux_sci_an_index
                                                         // LOOK_HERE -> A match is found in location 6 of the new array : phy_cfg.mux_sci_an_index[5] =  {64'h78761E8DCD3D0089,2'h0};
                                                         // LOOK_HERE -> Decryption Key is taken from corresponding location 6 of key array : phy_cfg.mux_key_256bit
                                                         // LOOK_HERE -> phy_cfg.mux_key_256bit[5] =  256'h6789AEE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B66;
                                       eth_trans.user_packet_type == svt_ethernet_enum_pkg::DATA_FRAME ; // UNTAGGED DATA FRAME
                                       eth_trans.enable_apply_user_pkt == 1; // Enable for user payload programming
                                       eth_trans.mac_inter_frame_gap == 12;
                                       eth_trans.macsec_tag_control_info_V_bit  == 1'b0;
                                       eth_trans.macsec_tag_control_info_ES_bit == 1'b0; 
                                       eth_trans.macsec_tag_control_info_SC_bit  == 1'b1;
                                       eth_trans.macsec_tag_control_info_SCB_bit == 1'b0;
                                       eth_trans.macsec_tag_control_info_E_bit   == 1'b1;
                                       eth_trans.macsec_tag_control_info_C_bit   == 1'b1;
                                       }) begin
         `uvm_fatal(get_type_name(),$sformatf("frame randomization failed"))
       end
       `uvm_info("mux_traffic_seq", $sformatf("Randomized transaction...\n %s", eth_trans.sprint()), UVM_LOW);
       `uvm_send(eth_trans)
       `uvm_info("mux_traffic_seq", $sformatf("transaction driving done..."), UVM_LOW);
     end
   endtask : body

   //
   // Task: post_body
   //
   // UVM sequence's post_body task.
   //
   virtual task post_body();
      super.post_body();
   endtask : post_body

endclass : mux_traffic_seq

`endif//__MUX_TRAFFIC_SEQ_SVH__
