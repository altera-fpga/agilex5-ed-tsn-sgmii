//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __TSN_TB_SV__
`define __TSN_TB_SV__


`include "tsn_top_params.svh"
`include "tsn_tb_ports.svh"
`include "basic_test_params_ip0.v"

reg [NUM_PHY-1:0] rst_n_ip;
logic [NUM_PHY-1:0]  reset_ip;
logic clk_status_ip0=0;
logic clk_ref_ip0=0;
logic [NUM_PHY-1:0] reconfig_reset_ip;
logic [NUM_PHY-1:0] soft_reset_ip = 0;
bit[31:0] REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
logic sys_clk = 0;
logic sys_rst = 1;

defparam top_tb.dut.fpga_reset_n_debounce_inst.TIMEOUT = 40; 

tsn_rtb #(
   `TSN_RTB_PARAM_INST,
   .NUM_PHY(NUM_PHY),
   .IP_PATH          ("uvm_test_top.m_env"),
   .IS_ACTIVE        (uvm_pkg::UVM_ACTIVE),
   .DUT_PATH         ("top_tb.dut.dut"),
   .HDL_PATH         ("top_tb.rtb")
   //`include "bnic_tb_parameters_conn.svh"
) tsn_rtb_i (
   `include "tsn_tb_ports_conn.svh" 
);

agilex5_top #(
   `include "tsn_tb_parameters_conn.svh"
) dut (
   `include "tsn_dut_ports_conn.svh" 
);

/*
tsn_shell #(
   `include "tsn_tb_parameters_conn.svh"
) dut (
   `include "tsn_dut_ports_conn.svh" 
);

*/

`include "tsn_hps_rtb_inst.svh"


//********************************************************************

always begin #(CLOCK_PERIOD/2) clk_status_ip0= ~clk_status_ip0;    end

assign app_pp_system_clk = clk_status_ip0;

initial begin
   sys_rst = 0;
   #10us;
   sys_rst = 1;
end

//********************************************************************

reset_if reset_if_ip[NUM_PHY-1:0]();

assign reset_if_ip[0].rst_ack_n = `MRPHY(0).o_tx_rst_ack_n;
assign reset_if_ip[0].tx_rst_ack_n = `MRPHY(0).o_tx_rst_ack_n;
assign reset_if_ip[0].rx_rst_ack_n = `MRPHY(0).o_rx_rst_ack_n;
assign reset_if_ip[0].mac_tx_rst_ack_n = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_tx_ready[0:0]  & `MRPHY(0).mrphy_pll_lock ;
assign reset_if_ip[0].mac_rx_rst_ack_n = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0:0] & `MRPHY_INST(0).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
assign reset_if_ip[0].mac_rst_ack_n = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_tx_ready[0:0] & `MRPHY_INST(0).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      
//initial force `MRPHY(0).i_rst_n = reset_if_ip[0].csr_rst_n;
//initial force `MRPHY(0).i_tx_rst_n = reset_if_ip[0].tx_rst_n;
//initial force `MRPHY(0).i_rx_rst_n = reset_if_ip[0].rx_rst_n;
//initial force `MRPHY(0).gmii8b_tx_rst_n = reset_if_ip[0].mac_tx_rst_n;
//initial force `MRPHY(0).reset = ~reset_if_ip[0].mac_tx_rst_n;
//initial force `MRPHY(0).gmii8b_rx_rst_n = reset_if_ip[0].mac_rx_rst_n;
    
//initial force top_tb.dut.soc_inst.subsys_tsn.reset_ip.reset_ip.ninit_done = ~reset_if_ip[0].mac_tx_rst_n;    

generate
   if(NUM_PHY > 1) begin
      assign reset_if_ip[1].rst_ack_n = `MRPHY(1).o_tx_rst_ack_n;
      assign reset_if_ip[1].tx_rst_ack_n = `MRPHY(1).o_tx_rst_ack_n;
      assign reset_if_ip[1].rx_rst_ack_n = `MRPHY(1).o_rx_rst_ack_n;
      assign reset_if_ip[1].mac_tx_rst_ack_n = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_tx_ready[0:0]  & `MRPHY(1).mrphy_pll_lock ;
      assign reset_if_ip[1].mac_rx_rst_ack_n = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0:0] & `MRPHY_INST(1).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      assign reset_if_ip[1].mac_rst_ack_n = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_tx_ready[0:0] & `MRPHY_INST(1).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      
      //initial force `MRPHY(1).i_rst_n = reset_if_ip[1].csr_rst_n;
      //initial force `MRPHY(1).i_tx_rst_n = reset_if_ip[1].tx_rst_n;
      //initial force `MRPHY(1).i_rx_rst_n = reset_if_ip[1].rx_rst_n;
      //initial force `MRPHY(1).gmii8b_tx_rst_n = reset_if_ip[1].mac_tx_rst_n;
      //initial force `MRPHY(1).reset = ~reset_if_ip[1].mac_tx_rst_n;
      //initial force `MRPHY(1).gmii8b_rx_rst_n = reset_if_ip[1].mac_rx_rst_n;

      assign reset_if_ip[2].rst_ack_n = `MRPHY(2).o_tx_rst_ack_n;
      assign reset_if_ip[2].tx_rst_ack_n = `MRPHY(2).o_tx_rst_ack_n;
      assign reset_if_ip[2].rx_rst_ack_n = `MRPHY(2).o_rx_rst_ack_n;
      assign reset_if_ip[2].mac_tx_rst_ack_n = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_tx_ready[0:0]  & `MRPHY(2).mrphy_pll_lock ;
      assign reset_if_ip[2].mac_rx_rst_ack_n = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0:0] & `MRPHY_INST(2).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      assign reset_if_ip[2].mac_rst_ack_n = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_tx_ready[0:0] & `MRPHY_INST(2).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      
      //initial force `MRPHY(2).i_rst_n = reset_if_ip[2].csr_rst_n;
      //initial force `MRPHY(2).i_tx_rst_n = reset_if_ip[2].tx_rst_n;
      //initial force `MRPHY(2).i_rx_rst_n = reset_if_ip[2].rx_rst_n;
      //initial force `MRPHY(2).gmii8b_tx_rst_n = reset_if_ip[2].mac_tx_rst_n;
      //initial force `MRPHY(2).reset = ~reset_if_ip[2].mac_tx_rst_n;
      //initial force `MRPHY(2).gmii8b_rx_rst_n = reset_if_ip[2].mac_rx_rst_n;
   end
endgenerate


generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : rst_if
      assign rst_n_ip[n]    = reset_if_ip[0].csr_rst_n;
      assign reset_if_ip[n].clock = clk_status_ip0;
      initial force hps_rtb_i.mac_gen[n].reverse_adapter.tx_disable = ~reset_if_ip[0].mac_rx_rst_n;
      assign hps_rtb_i.mac_gen[n].mac.avalon_st_rx_ready = 1;
      assign hps_rtb_i.i_mac_tx_rst_n[n] = reset_if_ip[0].mac_tx_rst_n;
      assign hps_rtb_i.mac_rst_tx_n[n] = reset_if_ip[0].mac_tx_rst_n;
      assign hps_rtb_i.adpt_mac_rx_rst_n[n] = reset_if_ip[0].mac_tx_rst_n;
      assign hps_rtb_i.i_mac_rx_rst_n[n] = reset_if_ip[0].mac_rx_rst_n;
      assign hps_rtb_i.adpt_mac_tx_rst_n[n] = reset_if_ip[0].mac_rx_rst_n;
      assign hps_rtb_i.mac_rst_rx_n[n] = reset_if_ip[0].mac_rx_rst_n;
      assign reset_ip[n]= ~rst_n_ip[0];
      initial begin
         uvm_config_db #(virtual reset_if)::set (null, $psprintf("*env_ip%0d", n), "slv_if", reset_if_ip[n]);
      end
   end
endgenerate

//********************************************************************
/*
reset_if reset_if_ip[NUM_PHY-1:0]();

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : rst_if
      assign rst_n_ip[n]    = reset_if_ip[n].csr_rst_n;
      assign reset_if_ip[n].clock = clk_status_ip0; 
      if(n==0) begin
      assign reset_if_ip[n].rst_ack_n = `MRPHY(0).o_tx_rst_ack_n;
      assign reset_if_ip[n].tx_rst_ack_n = `MRPHY(0).o_tx_rst_ack_n;
      assign reset_if_ip[n].rx_rst_ack_n = `MRPHY(0).o_rx_rst_ack_n;
      assign reset_if_ip[n].mac_tx_rst_ack_n = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_tx_ready[0:0]  & `MRPHY(0).mrphy_pll_lock ;
      assign reset_if_ip[n].mac_rx_rst_ack_n = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0:0] & `MRPHY_INST(0).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      assign reset_if_ip[n].mac_rst_ack_n = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_tx_ready[0:0] & `MRPHY_INST(0).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      
      initial force `MRPHY(0).i_rst_n = reset_if_ip[n].csr_rst_n;
      initial force `MRPHY(0).i_tx_rst_n = reset_if_ip[n].tx_rst_n;
      initial force `MRPHY(0).i_rx_rst_n = reset_if_ip[n].rx_rst_n;
      initial force `MRPHY(0).gmii8b_tx_rst_n = reset_if_ip[n].mac_tx_rst_n;
      initial force `MRPHY(0).reset = ~reset_if_ip[n].mac_tx_rst_n;
      initial force `MRPHY(0).gmii8b_rx_rst_n = reset_if_ip[n].mac_rx_rst_n; 
      
      initial force `MRPHY(0).gmii8b_mac_txen =  hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxdv; //need to remove
      initial force `MRPHY(0).gmii8b_mac_tx_d = hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxd;
      initial force `MRPHY(0).gmii8b_mac_txer = hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxer;
      
      end
      else if(n==1) begin
      assign reset_if_ip[n].rst_ack_n = `MRPHY(1).o_tx_rst_ack_n;
      assign reset_if_ip[n].tx_rst_ack_n = `MRPHY(1).o_tx_rst_ack_n;
      assign reset_if_ip[n].rx_rst_ack_n = `MRPHY(1).o_rx_rst_ack_n;
      assign reset_if_ip[n].mac_tx_rst_ack_n = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_tx_ready[0:0]  & `MRPHY(1).mrphy_pll_lock ;
      assign reset_if_ip[n].mac_rx_rst_ack_n = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0:0] & `MRPHY_INST(1).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      assign reset_if_ip[n].mac_rst_ack_n = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_tx_ready[0:0] & `MRPHY_INST(1).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      
      initial force `MRPHY(1).i_rst_n = reset_if_ip[n].csr_rst_n;
      initial force `MRPHY(1).i_tx_rst_n = reset_if_ip[n].tx_rst_n;
      initial force `MRPHY(1).i_rx_rst_n = reset_if_ip[n].rx_rst_n;
      initial force `MRPHY(1).gmii8b_tx_rst_n = reset_if_ip[n].mac_tx_rst_n;
      initial force `MRPHY(1).reset = ~reset_if_ip[n].mac_tx_rst_n;
      initial force `MRPHY(1).gmii8b_rx_rst_n = reset_if_ip[n].mac_rx_rst_n;
      
      initial force `MRPHY(1).gmii8b_mac_txen =  hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxdv; //need to remove
      initial force `MRPHY(1).gmii8b_mac_tx_d = hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxd;
      initial force `MRPHY(1).gmii8b_mac_txer = hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxer;
      
      end
      else begin
      assign reset_if_ip[n].rst_ack_n = `MRPHY(2).o_tx_rst_ack_n;
      assign reset_if_ip[n].tx_rst_ack_n = `MRPHY(2).o_tx_rst_ack_n;
      assign reset_if_ip[n].rx_rst_ack_n = `MRPHY(2).o_rx_rst_ack_n;
      assign reset_if_ip[n].mac_tx_rst_ack_n = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_tx_ready[0:0]  & `MRPHY(2).mrphy_pll_lock ;
      assign reset_if_ip[n].mac_rx_rst_ack_n = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0:0] & `MRPHY_INST(2).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      assign reset_if_ip[n].mac_rst_ack_n = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_tx_ready[0:0] & `MRPHY_INST(2).mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;
      
      initial force `MRPHY(2).i_rst_n = reset_if_ip[n].csr_rst_n;
      initial force `MRPHY(2).i_tx_rst_n = reset_if_ip[n].tx_rst_n;
      initial force `MRPHY(2).i_rx_rst_n = reset_if_ip[n].rx_rst_n;
      initial force `MRPHY(2).gmii8b_tx_rst_n = reset_if_ip[n].mac_tx_rst_n;
      initial force `MRPHY(2).reset = ~reset_if_ip[n].mac_tx_rst_n;
      initial force `MRPHY(2).gmii8b_rx_rst_n = reset_if_ip[n].mac_rx_rst_n;
      
      initial force `MRPHY(2).gmii8b_mac_txen =  hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxdv; //need to remove
      initial force `MRPHY(2).gmii8b_mac_tx_d = hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxd;
      initial force `MRPHY(2).gmii8b_mac_txer = hps_rtb_i.mac_gen[n].reverse_adapter.mac_rxer;
      
      end
      initial force hps_rtb_i.mac_gen[n].reverse_adapter.tx_disable = ~reset_if_ip[n].mac_rx_rst_n;
      assign hps_rtb_i.mac_gen[n].mac.avalon_st_rx_ready = 1;
      assign hps_rtb_i.i_mac_tx_rst_n[n] = reset_if_ip[n].mac_tx_rst_n;
      assign hps_rtb_i.mac_rst_tx_n[n] = ~reset_if_ip[n].mac_tx_rst_n;
      assign hps_rtb_i.adpt_mac_rx_rst_n[n] = reset_if_ip[n].mac_tx_rst_n;
      assign hps_rtb_i.i_mac_rx_rst_n[n] = reset_if_ip[n].mac_rx_rst_n;
      assign hps_rtb_i.adpt_mac_tx_rst_n[n] = reset_if_ip[n].mac_rx_rst_n;
      assign hps_rtb_i.mac_rst_rx_n[n] = ~reset_if_ip[n].mac_rx_rst_n;
      assign reset_ip[n]= ~rst_n_ip[n];
      initial begin
         uvm_config_db #(virtual reset_if)::set (null, $psprintf("*env_ip%0d", n), "slv_if", reset_if_ip[n]); 
      end
      
      initial begin
         assign reconfig_reset_ip[n] =  1;//reset_if_ip[n].reconfig_rst_n;
         #500ns;
         assign reconfig_reset_ip[n] = 0;// ~reset_if_ip[n].reconfig_rst_n;
      end
      
   end
endgenerate
*/
initial begin
   assign reconfig_reset_ip =  'h111;//reset_if_ip[n].reconfig_rst_n;
   #500ns;
   assign reconfig_reset_ip = 'h0;// ~reset_if_ip[n].reconfig_rst_n;
end

//********************************************************************
/*
reset_if reset_if_ip0();
initial begin
   uvm_config_db #(virtual reset_if)::set (null, "*env_ip0", "slv_if", reset_if_ip0); 
end

assign rst_n_ip0    = reset_if_ip0.csr_rst_n;
initial force dut.mrphy_inst.i_rst_n = reset_if_ip0.csr_rst_n; //need to remove
initial force dut.mrphy_inst.gmii8b_mac_txen =  hps_rtb_i.mac_gen[0].reverse_adapter.mac_rxdv; //need to remove
initial force dut.mrphy_inst.gmii8b_mac_tx_d = hps_rtb_i.mac_gen[0].reverse_adapter.mac_rxd;
initial force dut.mrphy_inst.gmii8b_mac_txer = hps_rtb_i.mac_gen[0].reverse_adapter.mac_rxer;
initial force hps_rtb_i.mac_gen[0].reverse_adapter.tx_disable = ~reset_if_ip0.mac_rx_rst_n;
assign hps_rtb_i.mac_gen[0].mac.avalon_st_rx_ready = 1;

//assign tx_rst_n_ip0 = reset_if_ip0.tx_rst_n; //drive into i_tx_rst_n of phy, but csr is driving.
initial force dut.mrphy_inst.i_tx_rst_n = reset_if_ip0.tx_rst_n;
//assign rx_rst_n_ip0 = reset_if_ip0.rx_rst_n; //drive into i_rx_rst_n of phy, csr is driving
initial force dut.mrphy_inst.i_rx_rst_n = reset_if_ip0.rx_rst_n;

//assign mac_tx_rst_n_ip0 = reset_if_ip0.mac_tx_rst_n;
assign hps_rtb_i.i_mac_tx_rst_n = reset_if_ip0.mac_tx_rst_n;
assign hps_rtb_i.intel_agilex_5_soc_0_emac0_mac_rst_tx_n = ~reset_if_ip0.mac_tx_rst_n;
assign hps_rtb_i.adpt_mac_rx_rst_n = reset_if_ip0.mac_tx_rst_n;
initial force  dut.mrphy_inst.gmii8b_tx_rst_n = reset_if_ip0.mac_tx_rst_n;
initial force  dut.mrphy_inst.reset = ~reset_if_ip0.mac_tx_rst_n;

//assign mac_rx_rst_n_ip0 = reset_if_ip0.mac_rx_rst_n;
assign hps_rtb_i.i_mac_rx_rst_n = reset_if_ip0.mac_rx_rst_n;
assign hps_rtb_i.adpt_mac_tx_rst_n = reset_if_ip0.mac_rx_rst_n;
assign hps_rtb_i.intel_agilex_5_soc_0_emac0_mac_rst_rx_n = ~reset_if_ip0.mac_rx_rst_n;
initial force  dut.mrphy_inst.gmii8b_rx_rst_n = reset_if_ip0.mac_rx_rst_n;

//assign mac_rst_n_ip0 = reset_if_ip0.mac_rst_n;

assign reset_if_ip0.rst_ack_n          = dut.mrphy_inst.o_tx_rst_ack_n;//rst_ack_n_ip0; 
assign reset_if_ip0.tx_rst_ack_n       = dut.mrphy_inst.o_tx_rst_ack_n;//tx_rst_ack_n_ip0; 
assign reset_if_ip0.rx_rst_ack_n       = dut.mrphy_inst.o_rx_rst_ack_n;//rx_rst_ack_n_ip0; 
assign reset_if_ip0.mac_tx_rst_ack_n   = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_tx_ready[0:0]  & dut.mrphy_inst.mrphy_pll_lock ;//mac_tx_rst_ack_n_ip0; 
assign reset_if_ip0.mac_rx_rst_ack_n   = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_rx_ready[0:0] & dut.mrphy_inst.intel_mge_phy_0.mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;//mac_rx_rst_ack_n_ip0; 
assign reset_if_ip0.mac_rst_ack_n      = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_tx_ready[0:0] & dut.mrphy_inst.intel_mge_phy_0.mge_pcs.u_hps_to_mge_gmii_adapter_core.pll_locked_stable ;//mac_rst_ack_n_ip0;     
assign reset_ip0= ~rst_n_ip0;
assign reset_if_ip0.clock = clk_status_ip0;

initial begin
  assign reconfig_reset_ip0 =  reset_if_ip0.reconfig_rst_n;
  #500ns;
  assign reconfig_reset_ip0 =  ~reset_if_ip0.reconfig_rst_n;
end
*/
//********************************************************************


generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : eth_vector_if
      vector_uvc_interface eth_vector_if_ip(hps_rtb_i.mac_clk,reset_ip[n],hps_rtb_i.mac_clk);
      assign eth_vector_if_ip.status_valid_tx =hps_rtb_i.avalon_st_txstatus_valid[n];
      assign eth_vector_if_ip.status_data_tx =hps_rtb_i.avalon_st_txstatus_data[n][39:0];
      assign eth_vector_if_ip.status_error    = hps_rtb_i.avalon_st_rxstatus_error[n][6:0];
      assign eth_vector_if_ip.status_error_tx = hps_rtb_i.avalon_st_txstatus_error[n][6:0];
      assign eth_vector_if_ip.status_valid = hps_rtb_i.avalon_st_rxstatus_valid[n];
      assign eth_vector_if_ip.status_data  = hps_rtb_i.avalon_st_rxstatus_data[n];
      assign eth_vector_if_ip.end_offpacket = hps_rtb_i.avalon_st_rx_endofpacket[n];

      initial begin
         uvm_config_db #(virtual vector_uvc_interface)::set(uvm_root::get(), $psprintf("*env_ip%0d.vector_agent*",n),"vector_if",eth_vector_if_ip);
      end
   end
endgenerate

//********************************************************************
/*
vector_uvc_interface eth_vector_if_ip0(hps_rtb_i.mac_clk,reset_ip0,hps_rtb_i.mac_clk);

assign eth_vector_if_ip0.status_valid_tx =hps_rtb_i.avalon_st_txstatus_valid[0];
assign eth_vector_if_ip0.status_data_tx =hps_rtb_i.avalon_st_txstatus_data[0][39:0];
assign eth_vector_if_ip0.status_error    = hps_rtb_i.avalon_st_rxstatus_error[0][6:0];
assign eth_vector_if_ip0.status_error_tx = hps_rtb_i.avalon_st_txstatus_error[0][6:0];
assign eth_vector_if_ip0.status_valid = hps_rtb_i.avalon_st_rxstatus_valid[0];
assign eth_vector_if_ip0.status_data  = hps_rtb_i.avalon_st_rxstatus_data[0];
assign eth_vector_if_ip0.end_offpacket = hps_rtb_i.avalon_st_rx_endofpacket;

initial begin
  uvm_config_db #(virtual vector_uvc_interface)::set(uvm_root::get(), "*env_ip0.vector_agent*","vector_if",eth_vector_if_ip0);
end
*/
//********************************************************************

spy_interface #(.IP("ip0")) spy_if_ip[NUM_PHY-1:0]();

assign spy_if_ip[0].rx_block_lock = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(0).led_link;//rx_pcs_ready_ip0;
assign spy_if_ip[0].rx_pcs_ready = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(0).led_link;//rx_pcs_ready_ip0;

generate
   if(NUM_PHY > 1) begin
      assign spy_if_ip[1].rx_block_lock = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(1).led_link;//rx_pcs_ready_ip0;
      assign spy_if_ip[1].rx_pcs_ready = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(1).led_link;//rx_pcs_ready_ip0;
      assign spy_if_ip[2].rx_block_lock = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(2).led_link;//rx_pcs_ready_ip0;
      assign spy_if_ip[2].rx_pcs_ready = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(2).led_link;//rx_pcs_ready_ip0;
   end
endgenerate

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : spy_if
      assign spy_if_ip[n].eio_soft_rst =  0;//REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
      assign spy_if_ip[n].tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
      assign spy_if_ip[n].rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[8];
      assign spy_if_ip[n].soft_reset = soft_reset_ip[n];
      assign spy_if_ip[n].o_tx_ready =  hps_rtb_i.avalon_st_tx_ready[n];//tx_ready_ip0;
      assign spy_if_ip[n].sig_avalon_st_txstatus_valid  = hps_rtb_i.avalon_st_txstatus_valid[n];
      assign spy_if_ip[n].sig_avalon_st_txstatus_error  = hps_rtb_i.avalon_st_txstatus_error[n];
      assign spy_if_ip[n].sig_avalon_st_txstatus_data   = hps_rtb_i.avalon_st_txstatus_data[n];
      assign spy_if_ip[n].sig_avalon_st_tx_error        = hps_rtb_i.avalon_st_tx_error[n];
      assign spy_if_ip[n].sig_avalon_st_tx_valid        = hps_rtb_i.avalon_st_tx_valid[n];
      assign spy_if_ip[n].sig_avalon_st_tx_endofpacket  = hps_rtb_i.avalon_st_tx_endofpacket[n];
      assign spy_if_ip[n].sig_avalon_st_rx_error         = hps_rtb_i.avalon_st_rx_error[n];
      assign spy_if_ip[n].sig_avalon_st_rxstatus_valid   = hps_rtb_i.avalon_st_rxstatus_valid[n];
      assign spy_if_ip[n].sig_avalon_st_rxstatus_error   = hps_rtb_i.avalon_st_rxstatus_error[n];
      assign spy_if_ip[n].sig_avalon_st_rx_valid         = hps_rtb_i.avalon_st_rx_valid[n];
      assign spy_if_ip[n].sig_avalon_st_rx_endofpacket   = hps_rtb_i.avalon_st_rx_endofpacket[n];
      assign spy_if_ip[n].clk                           = clk_ref_ip0;
      assign spy_if_ip[n].avst_tx_eop		               = hps_rtb_i.avalon_st_tx_endofpacket[n];//tx_avst_if_ip0.endofpacket;		
      assign spy_if_ip[n].avst_tx_sop					      = hps_rtb_i.avalon_st_tx_startofpacket[n];//tx_avst_if_ip0.startofpacket;

      initial begin
         uvm_config_db #(virtual spy_interface)::set(null,$psprintf("*env_ip%0d",n),"spy_interface",spy_if_ip[n]);
         uvm_config_db#(string)::set(uvm_root::get(),$psprintf("*env_ip%0d*",n),"dut_name","*dut_10g_ip0");  
      end
   end
endgenerate

//********************************************************************

/*
spy_interface #(.IP("ip0")) spy_if_ip[NUM_PHY-1:0]();

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : spy_if 
      assign spy_if_ip[n].eio_soft_rst =  0;//REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
      assign spy_if_ip[n].tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
      assign spy_if_ip[n].rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[8];
      if(n==0) begin
      assign spy_if_ip[n].rx_block_lock = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(0).led_link;//rx_pcs_ready_ip0;
      assign spy_if_ip[n].rx_pcs_ready = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(0).led_link;//rx_pcs_ready_ip0;
      end
      else if(n==1) begin
      assign spy_if_ip[n].rx_block_lock = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(1).led_link;//rx_pcs_ready_ip0;
      assign spy_if_ip[n].rx_pcs_ready = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(1).led_link;//rx_pcs_ready_ip0;
      end
      else begin
      assign spy_if_ip[n].rx_block_lock = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(2).led_link;//rx_pcs_ready_ip0;
      assign spy_if_ip[n].rx_pcs_ready = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(2).led_link;//rx_pcs_ready_ip0;
      end
      assign spy_if_ip[n].soft_reset = soft_reset_ip[n];
      assign spy_if_ip[n].o_tx_ready =  hps_rtb_i.avalon_st_tx_ready[n];//tx_ready_ip0;
      assign spy_if_ip[n].sig_avalon_st_txstatus_valid  = hps_rtb_i.avalon_st_txstatus_valid[n];
      assign spy_if_ip[n].sig_avalon_st_txstatus_error  = hps_rtb_i.avalon_st_txstatus_error[n];
      assign spy_if_ip[n].sig_avalon_st_txstatus_data   = hps_rtb_i.avalon_st_txstatus_data[n];
      assign spy_if_ip[n].sig_avalon_st_tx_error        = hps_rtb_i.avalon_st_tx_error[n];
      assign spy_if_ip[n].sig_avalon_st_tx_valid        = hps_rtb_i.avalon_st_tx_valid[n];
      assign spy_if_ip[n].sig_avalon_st_tx_endofpacket  = hps_rtb_i.avalon_st_tx_endofpacket[n];
      assign spy_if_ip[n].sig_avalon_st_rx_error         = hps_rtb_i.avalon_st_rx_error[n];
      assign spy_if_ip[n].sig_avalon_st_rxstatus_valid   = hps_rtb_i.avalon_st_rxstatus_valid[n];
      assign spy_if_ip[n].sig_avalon_st_rxstatus_error   = hps_rtb_i.avalon_st_rxstatus_error[n];
      assign spy_if_ip[n].sig_avalon_st_rx_valid         = hps_rtb_i.avalon_st_rx_valid[n];
      assign spy_if_ip[n].sig_avalon_st_rx_endofpacket   = hps_rtb_i.avalon_st_rx_endofpacket[n];
      assign spy_if_ip[n].clk                           = clk_ref_ip0;
      assign spy_if_ip[n].avst_tx_eop		               = hps_rtb_i.avalon_st_tx_endofpacket[n];//tx_avst_if_ip0.endofpacket;		
      assign spy_if_ip[n].avst_tx_sop					      = hps_rtb_i.avalon_st_tx_startofpacket[n];//tx_avst_if_ip0.startofpacket;

      initial begin
         uvm_config_db #(virtual spy_interface)::set(null,$psprintf("*env_ip%0d",n),"spy_interface",spy_if_ip[n]);
         uvm_config_db#(string)::set(uvm_root::get(),$psprintf("*env_ip%0d*",n),"dut_name","*dut_10g_ip0");  
      end
   end
endgenerate
*/
//********************************************************************
/*
spy_interface #(.IP("ip0")) spy_if_ip0();

assign spy_if_ip0.eio_soft_rst =  0;//REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
assign spy_if_ip0.tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
assign spy_if_ip0.rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[8];

//assign spy_if_ip0.o_rx_hi_ber = rx_hi_ber_ip0;
//assign spy_if_ip0.rx_am_lock = rx_am_lock_ip0;
assign spy_if_ip0.rx_block_lock = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_rx_ready[0] & dut.mrphy_inst.led_link;//rx_pcs_ready_ip0;
assign spy_if_ip0.rx_pcs_ready = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_rx_ready[0] & dut.mrphy_inst.led_link;//rx_pcs_ready_ip0;
//assign spy_if_ip0.ehip_ready = ehip_ready_ip0; // RAMI-FIX port not available in GDR
assign spy_if_ip0.soft_reset = soft_reset_ip0;
assign spy_if_ip0.o_tx_ready =  hps_rtb_i.avalon_st_tx_ready[0];//tx_ready_ip0;

assign spy_if_ip0.sig_avalon_st_txstatus_valid  = hps_rtb_i.avalon_st_txstatus_valid[0];
assign spy_if_ip0.sig_avalon_st_txstatus_error  = hps_rtb_i.avalon_st_txstatus_error[0];
assign spy_if_ip0.sig_avalon_st_txstatus_data   = hps_rtb_i.avalon_st_txstatus_data[0];
assign spy_if_ip0.sig_avalon_st_tx_error        = hps_rtb_i.avalon_st_tx_error[0];
assign spy_if_ip0.sig_avalon_st_tx_valid        = hps_rtb_i.avalon_st_tx_valid[0];
assign spy_if_ip0.sig_avalon_st_tx_endofpacket  = hps_rtb_i.avalon_st_tx_endofpacket[0];
assign spy_if_ip0.sig_avalon_st_rx_error         = hps_rtb_i.avalon_st_rx_error[0];
assign spy_if_ip0.sig_avalon_st_rxstatus_valid   = hps_rtb_i.avalon_st_rxstatus_valid[0];
assign spy_if_ip0.sig_avalon_st_rxstatus_error   = hps_rtb_i.avalon_st_rxstatus_error[0];
assign spy_if_ip0.sig_avalon_st_rx_valid         = hps_rtb_i.avalon_st_rx_valid[0];
assign spy_if_ip0.sig_avalon_st_rx_endofpacket   = hps_rtb_i.avalon_st_rx_endofpacket[0];

//GDR_RX/TX_MAC connections
//assign spy_if_ip0.rf_status		= remote_fault_status_ip0;
assign spy_if_ip0.clk                           = clk_ref_ip0;
assign spy_if_ip0.avst_tx_eop		               = hps_rtb_i.avalon_st_tx_endofpacket[0];//tx_avst_if_ip0.endofpacket;		
assign spy_if_ip0.avst_tx_sop					      = hps_rtb_i.avalon_st_tx_startofpacket[0];//tx_avst_if_ip0.startofpacket;

initial begin
   uvm_config_db #(virtual spy_interface)::set(null,"*env_ip0","spy_interface",spy_if_ip0);
   uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","dut_name","*dut_10g_ip0");  
end
*/
//********************************************************************

assign hps_rtb_i.gmii16b_tx_clk[0]  = `MRPHY(0).tx_clkout;
assign hps_rtb_i.gmii16b_rx_clk[0]  = `MRPHY(0).rx_clkout;
assign hps_rtb_i.operating_speed[0] = `MRPHY(0).operating_speed;
assign hps_rtb_i.pll_125m_clk[0]    = `MRPHY_INST(0).iopll_tx.outclk_0;
assign hps_rtb_i.pll_25m_clk[0]     = `MRPHY_INST(0).iopll_tx.outclk_2;
assign hps_rtb_i.pll_2_5m_clk[0]    = `MRPHY_INST(0).iopll_tx.outclk_3;
assign hps_rtb_i.phy_tx_clkena[0]   = `MRPHY_INST(0).mge_pcs.u_hps_to_mge_gmii_adapter_core.phy_tx_clkena;
assign hps_rtb_i.iopll_lock[0]      = `MRPHY_INST(0).mrphy_pll_lock;
assign `MRPHY(0).gmii8b_tx_clkin = hps_rtb_i.adapter_rx_clk[0];

generate
   if(NUM_PHY > 1) begin
      assign hps_rtb_i.gmii16b_tx_clk[1]  = `MRPHY(1).tx_clkout;
      assign hps_rtb_i.gmii16b_rx_clk[1]  = `MRPHY(1).rx_clkout;
      assign hps_rtb_i.operating_speed[1] = `MRPHY(1).operating_speed;
      assign hps_rtb_i.pll_125m_clk[1]    = `MRPHY_INST(1).iopll_tx.outclk_0;
      assign hps_rtb_i.pll_25m_clk[1]     = `MRPHY_INST(1).iopll_tx.outclk_2;
      assign hps_rtb_i.pll_2_5m_clk[1]    = `MRPHY_INST(1).iopll_tx.outclk_3;
      assign hps_rtb_i.phy_tx_clkena[1]   = `MRPHY_INST(1).mge_pcs.u_hps_to_mge_gmii_adapter_core.phy_tx_clkena;
      assign hps_rtb_i.iopll_lock[1]      = `MRPHY_INST(1).mrphy_pll_lock;
      assign `MRPHY(1).gmii8b_tx_clkin = hps_rtb_i.adapter_rx_clk[1];

      assign hps_rtb_i.gmii16b_tx_clk[2]  = `MRPHY(2).tx_clkout;
      assign hps_rtb_i.gmii16b_rx_clk[2]  = `MRPHY(2).rx_clkout;
      assign hps_rtb_i.operating_speed[2] = `MRPHY(2).operating_speed;
      assign hps_rtb_i.pll_125m_clk[2]    = `MRPHY_INST(2).iopll_tx.outclk_0;
      assign hps_rtb_i.pll_25m_clk[2]     = `MRPHY_INST(2).iopll_tx.outclk_2;
      assign hps_rtb_i.pll_2_5m_clk[2]    = `MRPHY_INST(2).iopll_tx.outclk_3;
      assign hps_rtb_i.phy_tx_clkena[2]   = `MRPHY_INST(2).mge_pcs.u_hps_to_mge_gmii_adapter_core.phy_tx_clkena;
      assign hps_rtb_i.iopll_lock[2]      = `MRPHY_INST(2).mrphy_pll_lock;
      assign `MRPHY(2).gmii8b_tx_clkin = hps_rtb_i.adapter_rx_clk[2];
   end
endgenerate

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : hps_rtb_conn
      assign hps_rtb_i.avalon_st_pause_data[n] = 'h0;
      assign hps_rtb_i.csr_reset[n] = reconfig_reset_ip[n];
      assign hps_rtb_i.tx_avst_if_reset[n]   =  ~reset_if_ip[n].tx_rst_n | ~reset_if_ip[n].rx_rst_n | spy_if_ip[n].eio_soft_rst | spy_if_ip[n].tx_soft_rst | spy_if_ip[n].rx_soft_rst;
      assign hps_rtb_i.rx_avst_if_reset[n]   = ~reset_if_ip[n].rx_rst_n | spy_if_ip[n].eio_soft_rst | spy_if_ip[n].rx_soft_rst;
   end
endgenerate
assign hps_rtb_i.csr_clk            = clk_status_ip0;

//********************************************************************
/*
assign hps_rtb_i.gmii16b_tx_clk[0]  = dut.mrphy_inst.tx_clkout;
assign hps_rtb_i.gmii16b_rx_clk[0]  = dut.mrphy_inst.rx_clkout;
assign hps_rtb_i.operating_speed[0] = dut.mrphy_inst.operating_speed;
assign hps_rtb_i.pll_125m_clk[0]    = dut.mrphy_inst.intel_mge_phy_0.iopll_tx.outclk_0;
assign hps_rtb_i.pll_25m_clk[0]     = dut.mrphy_inst.intel_mge_phy_0.iopll_tx.outclk_2;
assign hps_rtb_i.pll_2_5m_clk[0]    = dut.mrphy_inst.intel_mge_phy_0.iopll_tx.outclk_3;
assign hps_rtb_i.phy_tx_clkena[0]   = dut.mrphy_inst.intel_mge_phy_0.mge_pcs.u_hps_to_mge_gmii_adapter_core.phy_tx_clkena;
assign hps_rtb_i.iopll_lock[0]      = dut.mrphy_inst.mrphy_pll_lock;
assign hps_rtb_i.avalon_st_pause_data[0] = 'h0;
assign hps_rtb_i.csr_clk            = clk_status_ip0;
assign hps_rtb_i.csr_reset = reconfig_reset_ip0;
assign hps_rtb_i.tx_avst_if_reset   =  ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | spy_if_ip0.eio_soft_rst | spy_if_ip0.tx_soft_rst | spy_if_ip0.rx_soft_rst;
assign hps_rtb_i.rx_avst_if_reset   = ~reset_if_ip0.rx_rst_n | spy_if_ip0.eio_soft_rst | spy_if_ip0.rx_soft_rst;
assign dut.mrphy_inst.gmii8b_tx_clkin = hps_rtb_i.adapter_rx_clk[0];
*/
//*********************************************************************

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : sideband_if
      eth_sideband_interface eth_sideband_if_ip(.rst(reset_ip[n]),
                                              //.clk(clk_pll_ip0),
                                              .clk(hps_rtb_i.mac_clk),
                                              .clk_tx(hps_rtb_i.mac_clk),
                                              .clk_rx(hps_rtb_i.mac_clk),
                                              .tx_tod_clk('b0),
                                              .rx_tod_clk('b0));


      assign hps_rtb_i.avalon_st_tx_error[n]         = eth_sideband_if_ip.tx_error; //todo
      assign eth_sideband_if_ip.tx_ready         = hps_rtb_i.avalon_st_tx_ready[n];       
      assign eth_sideband_if_ip.rx_valid         = hps_rtb_i.avalon_st_rx_valid[n];
      assign eth_sideband_if_ip.rx_sop           = hps_rtb_i.avalon_st_rx_startofpacket[n];
      assign eth_sideband_if_ip.tx_sop           = hps_rtb_i.avalon_st_tx_startofpacket[n];

      initial begin
         uvm_config_db #(virtual eth_sideband_interface)::set(uvm_root::get(),$psprintf("*env_ip%0d",n), "mst_if",eth_sideband_if_ip); 
         uvm_config_db #(virtual eth_sideband_interface)::set(uvm_root::get(),$psprintf("*env_ip%0d",n), "slv_if",eth_sideband_if_ip); 
      end
   end
endgenerate

assign sideband_if[0].eth_sideband_if_ip.tx_lane_stable   = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_tx_ready[0];
assign sideband_if[0].eth_sideband_if_ip.rx_pcs_ready     = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(0).led_link;

generate
   if(NUM_PHY > 1) begin
      assign sideband_if[1].eth_sideband_if_ip.tx_lane_stable   = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_tx_ready[0];
      assign sideband_if[1].eth_sideband_if_ip.rx_pcs_ready     = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(1).led_link;
      assign sideband_if[2].eth_sideband_if_ip.tx_lane_stable   = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_tx_ready[0];
      assign sideband_if[2].eth_sideband_if_ip.rx_pcs_ready     = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(2).led_link;
   end
endgenerate

//*********************************************************************
/*
eth_sideband_interface eth_sideband_if_ip0(.rst(reset_ip0),
                                              //.clk(clk_pll_ip0),
                                              .clk(hps_rtb_i.mac_clk),
                                              .clk_tx(hps_rtb_i.mac_clk),
                                              .clk_rx(hps_rtb_i.mac_clk),
                                              .tx_tod_clk('b0),
                                              .rx_tod_clk('b0));


assign hps_rtb_i.avalon_st_tx_error         = eth_sideband_if_ip0.tx_error; 
//assign stats_snapshot_ip0                 = eth_sideband_if_ip0.snapshot_en;
assign eth_sideband_if_ip0.tx_lane_stable   = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_tx_ready[0];
assign eth_sideband_if_ip0.rx_pcs_ready     = dut.mrphy_inst.intel_mge_phy_0.alt_mge_xcvr_directphy.o_rx_ready[0] & dut.mrphy_inst.led_link;
//assign eth_sideband_if_ip0.rx_pause       = rx_pause_ip0;
assign eth_sideband_if_ip0.tx_ready         = hps_rtb_i.avalon_st_tx_ready[0];       
assign eth_sideband_if_ip0.rx_valid         = hps_rtb_i.avalon_st_rx_valid[0];
assign eth_sideband_if_ip0.rx_sop           = hps_rtb_i.avalon_st_rx_startofpacket[0];
assign eth_sideband_if_ip0.tx_sop           = hps_rtb_i.avalon_st_tx_startofpacket[0];

initial begin
  uvm_config_db #(virtual eth_sideband_interface)::set(uvm_root::get(),"*env_ip0", "mst_if",eth_sideband_if_ip0); 
  uvm_config_db #(virtual eth_sideband_interface)::set(uvm_root::get(),"*env_ip0", "slv_if",eth_sideband_if_ip0); 
end
*/
//*********************************************************************

if(`phy_refclk_ip0 == 0 || `phy_refclk_ip0 == 156.250000) always #3200 clk_ref_ip0 = ~clk_ref_ip0;                
if(`phy_refclk_ip0 == 1 || `phy_refclk_ip0 == 322.265625) always #1551.51515 clk_ref_ip0 = ~clk_ref_ip0;
if(`phy_refclk_ip0 == 2 || `phy_refclk_ip0 == 312.500000) always #1600 clk_ref_ip0 = ~clk_ref_ip0;
if(`phy_refclk_ip0 == 3 || `phy_refclk_ip0 == 644.531250) always #775.757575  clk_ref_ip0 = ~clk_ref_ip0;

//system clk;
always #10000 sys_clk = ~sys_clk;

assign app_pp_osc_clk = clk_ref_ip0;
//assign app_pp_system_clk = sys_clk;
assign app_pp_system_rst_n = sys_rst;
assign hps_rtb_i.mac_clk = clk_ref_ip0;

//*********************************************************************

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : avmm_rcfg 
      altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_rcfg (
	 		            .clk                       (clk_status_ip0),
	 		            .reset                     (reconfig_reset_ip[n])
               );

      altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,
          .IS_ACTIVE                 (UVM_ACTIVE),
          .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
          ) avmm_rcfg_rtb_ip0 (.uif(avmm_if_rcfg));

      initial begin
         uvm_config_db#(string)::set(uvm_root::get(), $psprintf("*env_ip%0d", n),"avmm_rcfg_rtb_path", $psprintf("avmm_rcfg[%0d].avmm_rcfg_rtb_ip0",n));
         uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null, $psprintf("*env_ip%0d*",n),"status_rcfg_if",avmm_if_rcfg);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0;
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	      avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	      avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);              
         avmm_rcfg_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);              
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
         avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
      end
   end
endgenerate

assign `MRPHY(0).reconfig_write      = avmm_rcfg[0].avmm_if_rcfg.write;
assign `MRPHY(0).reconfig_read       = avmm_rcfg[0].avmm_if_rcfg.read;
assign `MRPHY(0).reconfig_address    = {3'b0, avmm_rcfg[0].avmm_if_rcfg.address[17:2]};
assign `MRPHY(0).reconfig_be         = avmm_rcfg[0].avmm_if_rcfg.byteenable;
assign `MRPHY(0).reconfig_writedata  = avmm_rcfg[0].avmm_if_rcfg.writedata;
assign avmm_rcfg[0].avmm_if_rcfg.readdata              = `MRPHY(0).reconfig_readdata;
assign avmm_rcfg[0].avmm_if_rcfg.waitrequest           = `MRPHY(0).reconfig_waitrequest;
assign avmm_rcfg[0].avmm_if_rcfg.readdatavalid         = ~`MRPHY(0).reconfig_waitrequest;

generate
   if(NUM_PHY > 1) begin
      assign `MRPHY(1).reconfig_write      = avmm_rcfg[1].avmm_if_rcfg.write;
      assign `MRPHY(1).reconfig_read       = avmm_rcfg[1].avmm_if_rcfg.read;
      assign `MRPHY(1).reconfig_address    = {3'b0, avmm_rcfg[1].avmm_if_rcfg.address[17:2]};
      assign `MRPHY(1).reconfig_be         = avmm_rcfg[1].avmm_if_rcfg.byteenable;
      assign `MRPHY(1).reconfig_writedata  = avmm_rcfg[1].avmm_if_rcfg.writedata;
      assign avmm_rcfg[1].avmm_if_rcfg.readdata              = `MRPHY(1).reconfig_readdata;
      assign avmm_rcfg[1].avmm_if_rcfg.waitrequest           = `MRPHY(1).reconfig_waitrequest;
      assign avmm_rcfg[1].avmm_if_rcfg.readdatavalid         = ~`MRPHY(1).reconfig_waitrequest;
      assign `MRPHY(2).reconfig_write      = avmm_rcfg[2].avmm_if_rcfg.write;
      assign `MRPHY(2).reconfig_read       = avmm_rcfg[2].avmm_if_rcfg.read;
      assign `MRPHY(2).reconfig_address    = {3'b0, avmm_rcfg[2].avmm_if_rcfg.address[17:2]};
      assign `MRPHY(2).reconfig_be         = avmm_rcfg[2].avmm_if_rcfg.byteenable;
      assign `MRPHY(2).reconfig_writedata  = avmm_rcfg[2].avmm_if_rcfg.writedata;
      assign avmm_rcfg[2].avmm_if_rcfg.readdata              = `MRPHY(2).reconfig_readdata;
      assign avmm_rcfg[2].avmm_if_rcfg.waitrequest           = `MRPHY(2).reconfig_waitrequest;
      assign avmm_rcfg[2].avmm_if_rcfg.readdatavalid         = ~`MRPHY(2).reconfig_waitrequest;
   end
endgenerate

//*********************************************************************
/*
altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_rcfg (
	 		            .clk                       (clk_status_ip0),
	 		            .reset                     (reconfig_reset_ip0)
               );

altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,
          .IS_ACTIVE                 (UVM_ACTIVE),
           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
               ) avmm_rcfg_rtb_ip0 (.uif(avmm_if_rcfg));


assign dut.mrphy_inst.reconfig_write      = avmm_if_rcfg.write;
assign dut.mrphy_inst.reconfig_read       = avmm_if_rcfg.read;
assign dut.mrphy_inst.reconfig_address    = {3'b0,avmm_if_rcfg.address[17:2]};
assign dut.mrphy_inst.reconfig_be         = avmm_if_rcfg.byteenable;
assign dut.mrphy_inst.reconfig_writedata  = avmm_if_rcfg.writedata;
assign avmm_if_rcfg.readdata              = dut.mrphy_inst.reconfig_readdata;
assign avmm_if_rcfg.waitrequest           = dut.mrphy_inst.reconfig_waitrequest;
assign avmm_if_rcfg.readdatavalid         = ~dut.mrphy_inst.reconfig_waitrequest;

initial begin
   uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_rcfg_rtb_path","avmm_rcfg_rtb_ip0");
   uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,"*env_ip0*","status_rcfg_if",avmm_if_rcfg);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0;
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);              
   avmm_rcfg_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);              
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
   avmm_rcfg_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
end
*/
//*********************************************************************
/*
wire [7:0] 	tx_pfc_ip0;
wire [1:0]  tx_pause_ip0;
wire [7:0] 	rx_pfc_ip0;
wire [1:0]  rx_pause_ip0;

eth_fc_interface eth_fc_if_ip0 (eth_sideband_if_ip0.clk_tx,reset_ip0); 

assign tx_pfc_ip0                    = eth_fc_if_ip0.tx_pfc;
assign hps_rtb_i.avalon_st_pause_data[0] = eth_fc_if_ip0.tx_sfc;
//assign tx_pause_ip0                  = eth_fc_if_ip0.tx_sfc;
assign eth_fc_if_ip0.rx_pfc          = rx_pfc_ip0;
assign eth_fc_if_ip0.rx_sfc          = rx_pause_ip0;

assign eth_fc_if_ip0.rx_pcs_ready = eth_sideband_if_ip0.rx_pcs_ready;
assign eth_fc_if_ip0.speed= spy_if_ip0.speed;
assign eth_fc_if_ip0.o_rx_valid= spy_if_ip0.o_rx_valid;
assign eth_fc_if_ip0.stop_flow= spy_if_ip0.stop_flow;
//assign eth_fc_if_ip0.startofpacket=tx_avst_if_ip0.startofpacket;
assign eth_fc_if_ip0.startofpacket=hps_rtb_i.avalon_st_tx_startofpacket[0];
//assign eth_fc_if_ip0.endofpacket=tx_avst_if_ip0.endofpacket;
assign eth_fc_if_ip0.endofpacket=hps_rtb_i.avalon_st_tx_endofpacket[0];
//assign eth_fc_if_ip0.ready=tx_avst_if_ip0.ready;
assign eth_fc_if_ip0.ready= hps_rtb_i.avalon_st_tx_ready[0];

initial begin
   uvm_config_db #(virtual eth_fc_interface)::set(uvm_root::get() ,"*env_ip0", "mst_if",eth_fc_if_ip0);
   uvm_config_db #(virtual eth_fc_interface)::set(uvm_root::get() ,"*env_ip0", "slv_if",eth_fc_if_ip0);
end
*/
//*********************************************************************

wire [NUM_PHY-1:0] [7:0] 	tx_pfc_ip;
wire [NUM_PHY-1:0] [1:0]   tx_pause_ip;
wire [NUM_PHY-1:0] [7:0] 	rx_pfc_ip;
wire [NUM_PHY-1:0] [1:0]   rx_pause_ip;

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : eth_fc_if
      eth_fc_interface eth_fc_if_ip0 (hps_rtb_i.mac_clk,reset_ip[n]); 

      assign tx_pfc_ip[n]                    = eth_fc_if_ip0.tx_pfc;
      assign hps_rtb_i.avalon_st_pause_data[n] = eth_fc_if_ip0.tx_sfc;
      assign eth_fc_if_ip0.rx_pfc          = rx_pfc_ip[n];
      assign eth_fc_if_ip0.rx_sfc          = rx_pause_ip[n];
      
      assign eth_fc_if_ip0.speed= spy_if_ip[n].speed;
      assign eth_fc_if_ip0.o_rx_valid= spy_if_ip[n].o_rx_valid;
      assign eth_fc_if_ip0.stop_flow= spy_if_ip[n].stop_flow;
      assign eth_fc_if_ip0.startofpacket=hps_rtb_i.avalon_st_tx_startofpacket[n];
      assign eth_fc_if_ip0.endofpacket=hps_rtb_i.avalon_st_tx_endofpacket[n];
      assign eth_fc_if_ip0.ready= hps_rtb_i.avalon_st_tx_ready[n];

      initial begin
         uvm_config_db #(virtual eth_fc_interface)::set(uvm_root::get() ,$psprintf("*env_ip%0d", n), "mst_if",eth_fc_if_ip0);
         uvm_config_db #(virtual eth_fc_interface)::set(uvm_root::get() ,$psprintf("*env_ip%0d", n), "slv_if",eth_fc_if_ip0);
      end
   end
endgenerate

assign eth_fc_if[0].eth_fc_if_ip0.rx_pcs_ready = `MRPHY_INST(0).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(0).led_link;
generate
   if(NUM_PHY > 1) begin
      assign eth_fc_if[1].eth_fc_if_ip0.rx_pcs_ready = `MRPHY_INST(1).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(1).led_link;
      assign eth_fc_if[2].eth_fc_if_ip0.rx_pcs_ready = `MRPHY_INST(2).alt_mge_xcvr_directphy.o_rx_ready[0] & `MRPHY(2).led_link;
   end
endgenerate

//*********************************************************************

generate
   genvar n;
   for (n=0; n<NUM_PHY; n++) begin : rst_assign
      always @(reset_if_ip[n].csr_rst_n or soft_reset_ip[n] or reset_if_ip[n].vip_rst or reset_if_ip[n].tx_rst_n or reset_if_ip[n].rx_rst_n or spy_if_ip[n].tx_soft_rst or spy_if_ip[n].rx_soft_rst) begin
         `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);
         svt_reset[n] = (~reset_if_ip[n].csr_rst_n | ~reset_if_ip[n].tx_rst_n | ~reset_if_ip[n].rx_rst_n);
      end
   end
endgenerate

//*********************************************************************
/*
always @(reset_if_ip0.csr_rst_n or soft_reset_ip0 or reset_if_ip0.vip_rst or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or spy_if_ip0.tx_soft_rst or spy_if_ip0.rx_soft_rst) begin
   `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);
   svt_reset = (~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n);
end
*/
//*********************************************************************

//need to remove

initial begin
   //force top_tb.dut.soc_inst.subsys_tsn.reset_ip.ninit_done = 1;
   //force dut.rst_rel.ninit_done = 1;
   //force dut.rst_ctrl_inst.app_pp_h2f_reset = 1;
   //force dut.rst_ctrl_inst.app_pp_pll_locked = 0;
   //force top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.i_src_ch_pause_request = 'h0;
   //#20ns;
   //force dut.rst_ctrl_inst.app_pp_pll_locked = 1;

   //force top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.rx_cdr_refclk_n = ~top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.rx_cdr_refclk_p;
   //force top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.tx_pll_refclk_n[0:0] = ~top_tb.dut.soc_inst.subsys_tsn.intel_mge_phy_0.tx_pll_refclk_p[0:0];
end

initial begin
   force dut.rst_ctrl_inst.app_pp_h2f_reset = 1;
   #50us;
   force dut.rst_ctrl_inst.app_pp_h2f_reset = 0;
end

`endif
