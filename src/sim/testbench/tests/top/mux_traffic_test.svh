//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_TRAFFIC_TEST_SVH__
`define __MUX_TRAFFIC_TEST_SVH__

//------------------------------------------------------------------------------
// Class: mux_traffic_test
//
// Sample Traffic Transaction test for MUX.
//
//------------------------------------------------------------------------------
class mux_traffic_test extends mux_base_test;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   //    NONE

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils(mux_traffic_test)

   //
   // Constructor: new
   //
   // Creates instance of this UVM component.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //  parent - Handle to the hierarchical parent, *null* if none.
   //
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   //
   // Function: build_phase
   //
   // Configure the subcomponents based on the configuration object settings.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      m_eth_mst_agent_cfg.macsec_type = ETH_MACSEC_TYPE_256BIT;

      /** Set the configuration values for master agent */
      m_eth_mst_agent_cfg.mac_address[0] = 48'hF0_76_1E_8D_CD_3D;

      /** Programming Encryption Keys for transmit VIP agent vip_ethernet_mac */
      m_eth_mst_agent_cfg.macsec_key_256bit = new[6] ;
      m_eth_mst_agent_cfg.macsec_key_256bit[0] =  256'h12345EE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B11;
      m_eth_mst_agent_cfg.macsec_key_256bit[1] =  256'h23456EE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B22;
      m_eth_mst_agent_cfg.macsec_key_256bit[2] =  256'h34567EE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B33;
      m_eth_mst_agent_cfg.macsec_key_256bit[3] =  256'h45678EE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B44;
      m_eth_mst_agent_cfg.macsec_key_256bit[4] =  256'h56789EE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B55;
      m_eth_mst_agent_cfg.macsec_key_256bit[5] =  256'h6789AEE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B66;


      /** Programming SCI array for transmit VIP master agent  */
      m_eth_mst_agent_cfg.macsec_secure_channel_identifier = new[6] ;

      m_eth_mst_agent_cfg.macsec_secure_channel_identifier[0] =  64'h12761E8DCD3D0023;
      m_eth_mst_agent_cfg.macsec_secure_channel_identifier[1] =  64'h34761E8DCD3D0045;
      m_eth_mst_agent_cfg.macsec_secure_channel_identifier[2] =  64'h56761E8DCD3D0067;
      m_eth_mst_agent_cfg.macsec_secure_channel_identifier[3] =  64'h78761E8DCD3D0089;
      m_eth_mst_agent_cfg.macsec_secure_channel_identifier[4] =  64'h9A761E8DCD3D00AB;
      m_eth_mst_agent_cfg.macsec_secure_channel_identifier[5] =  64'hBC761E8DCD3D00CD;

      
      /** Programming SCI+AN lookup index array for transmit VIP master agent */
      /** This array has 1-1 correspondence with the key array mux_key_256bit 
          For E.g if {SCI,AN} match is found in location 6 i.e m_eth_mst_agent_cfg.mux_sci_an_index[5] =  {64'h78761E8DCD3D0089,2'h0};
          Key (For Encryption in this test) will be taken from corresponding location 6 of key array : 
          m_eth_mst_agent_cfg.mux_key_256bit[5] =  256'h6789AEE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B66; */

      m_eth_mst_agent_cfg.macsec_sci_an_index = new[6] ;
      m_eth_mst_agent_cfg.macsec_sci_an_index[0] =  {64'h12761E8DCD3D0023,2'h1};
      m_eth_mst_agent_cfg.macsec_sci_an_index[1] =  {64'h34761E8DCD3D0045,2'h0};
      m_eth_mst_agent_cfg.macsec_sci_an_index[2] =  {64'h56761E8DCD3D0067,2'h1};
      m_eth_mst_agent_cfg.macsec_sci_an_index[3] =  {64'hBC761E8DCD3D00CD,2'h0};
      m_eth_mst_agent_cfg.macsec_sci_an_index[4] =  {64'h9A761E8DCD3D00AB,2'h1};
      m_eth_mst_agent_cfg.macsec_sci_an_index[5] =  {64'h78761E8DCD3D0089,2'h0};

      /** Programming SCI+AN lookup index array for receive VIP slave agent */
      /** This array has 1-1 correspondence with the key array mux_key_256bit 
          For E.g if {SCI,AN} match is found in location 6 i.e m_eth_slv_agent_cfg.mux_sci_an_index[5] =  {64'h78761E8DCD3D0089,2'h0};
          Key (For Decryption in this test) will be taken from corresponding location 6 of key array : 
          m_eth_slv_agent_cfg.mux_key_256bit[5] =  256'h6789AEE909D7F54167FD1CA0B5D76908_1F2BDE1AEE655FDBAB80BD5295AE6B66; */

      m_eth_mst_agent_cfg.macsec_next_PN = new[6];
      m_eth_mst_agent_cfg.macsec_next_PN[0] = 64'h00000000_76D457E9;
      m_eth_mst_agent_cfg.macsec_next_PN[1] = 64'h00000000_76D457EA;
      m_eth_mst_agent_cfg.macsec_next_PN[2] = 64'h00000000_76D457EB;
      m_eth_mst_agent_cfg.macsec_next_PN[3] = 64'h00000000_76D457EC;
      m_eth_mst_agent_cfg.macsec_next_PN[4] = 64'h00000000_76D457ED;
      m_eth_mst_agent_cfg.macsec_next_PN[5] = 64'h00000000_76D457ED;

      m_eth_mst_agent_cfg.macsec_max_PN = new[6];
      m_eth_mst_agent_cfg.macsec_max_PN[0] = 64'h00000000_C0000000;
      m_eth_mst_agent_cfg.macsec_max_PN[1] = 64'h00000000_C0000000;
      m_eth_mst_agent_cfg.macsec_max_PN[2] = 64'h00000000_C0000000;
      m_eth_mst_agent_cfg.macsec_max_PN[3] = 64'h00000000_C0000000;
      m_eth_mst_agent_cfg.macsec_max_PN[4] = 64'h00000000_C0000000;
      m_eth_mst_agent_cfg.macsec_max_PN[5] = 64'h00000000_C0000000;

      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN = new[6];
      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN[0] = 64'h00000000_76D457E9;
      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN[1] = 64'h00000000_76D457EA;
      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN[2] = 64'h00000000_76D457EB;
      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN[3] = 64'h00000000_76D457EC;
      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN[4] = 64'h00000000_76D457ED;
      m_eth_mst_agent_cfg.macsec_lowest_acceptable_PN[5] = 64'h00000000_76D457ED;

      m_eth_mst_agent_cfg.macsec_replay_protection = new[6];
      m_eth_mst_agent_cfg.macsec_replay_protection[0] = 1'h1;
      m_eth_mst_agent_cfg.macsec_replay_protection[1] = 1'h1;
      m_eth_mst_agent_cfg.macsec_replay_protection[2] = 1'h1;
      m_eth_mst_agent_cfg.macsec_replay_protection[3] = 1'h1;
      m_eth_mst_agent_cfg.macsec_replay_protection[4] = 1'h1;
      m_eth_mst_agent_cfg.macsec_replay_protection[5] = 1'h1;

      m_eth_mst_agent_cfg.macsec_replay_window = new[6];
      m_eth_mst_agent_cfg.macsec_replay_window[0] = 32'h0;
      m_eth_mst_agent_cfg.macsec_replay_window[1] = 32'h0;
      m_eth_mst_agent_cfg.macsec_replay_window[2] = 32'h0;
      m_eth_mst_agent_cfg.macsec_replay_window[3] = 32'h0;
      m_eth_mst_agent_cfg.macsec_replay_window[4] = 32'h0;
      m_eth_mst_agent_cfg.macsec_replay_window[5] = 32'h0;


   endfunction : build_phase
   //
   // Task: run_phase
   //
   // Execute the sequence(s) in this phase.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   virtual task run_phase(uvm_phase phase);
      // Simple register sequence
      mux_traffic_seq   traffic_seq;

      //
      m_env.m_eth_env[0].m_eth_sqcr.write_cfg(m_eth_mst_agent_cfg);
      `ifdef MUX_DEBUG
      //for(int unsigned idx=0; idx < m_rtb_config.MAX_AXI_PORT; idx++) begin
      for(int unsigned idx=0; idx < 1; idx++) begin
        m_env.ethernet_mac_mst[idx].sequencer.write_cfg(m_eth_mst_agent_cfg);
        m_env.ethernet_mac_slv[idx].sequencer.write_cfg(m_eth_mst_agent_cfg);
      end
      `endif
      //
      super.run_phase(phase);

      // Create the sequences
      traffic_seq = mux_traffic_seq::type_id::create("traffic_seq", this);

      phase.raise_objection(this);

      `uvm_info(get_type_name(), "Start running Simple Transactions", UVM_LOW)
      traffic_seq.start(m_env.pick_sqcr());
      `uvm_info(get_type_name(), "Complete running Simple Transactions", UVM_LOW)

      phase.drop_objection(this);
   endtask : run_phase

endclass : mux_traffic_test

`endif//__MUX_TRAFFIC_TEST_SVH__
