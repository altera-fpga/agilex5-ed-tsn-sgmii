
`ifndef ETH_ENV_TOP__SV
`define ETH_ENV_TOP__SV
`timescale 1ps/1fs
`include "reset_if.sv"
`include "mstr_slv_intfs.incl"
`ifdef ENABLE_ETH_VIP
       `include "eth_testsuite_tasks_intf.sv"
       
       /** Inclusion of SVT ETHERNET UVM package */
       `include "svt_ethernet.uvm.pkg"
       `ifdef ETH_MULTI_PORT
         `include "svt_ethernet_multi_port.uvm.pkg"
       `endif
       
       /** Inclusion of SVT ETHERNET TEST Suite UVM package */
       //`include "svt_ethernet_test_suite.uvm.pkg"
       
       /** Inclusion of Directed TEST Suite Interface hooked up to VIP Test Suite Static Instance */
       `ifndef NON_ANLT_PTP 
       `include "svt_ethernet_test_suite_if.svi"
       `endif

       `ifdef COMPL_TC
         `ifdef ETH_MULTI_PORT
           `include "svt_ethernet_test_suite_multi_port_if.svi"
           `include "svt_ethernet_test_suite_if.svi"
         `else
           `include "svt_ethernet_test_suite_if.svi"
         `endif
       `endif
       
       /** Inclusion of TXRX interface */
       `ifdef ETH_MULTI_PORT
         `include "svt_ethernet_multi_port_txrx_if.svi"
       `endif	 
       `include "svt_ethernet_txrx_if.svi"
       //  `include "nvs_eth_tests.v"
       `ifndef NON_ANLT_PTP 
       `ifdef ETH_PROTECT
        `include `NVS_SOURCE_MAP_SUITE_MODULE_V(ethernet_test_suite_svt,latest,svt_ethernet_test_suite_top)
       `else
       `include "svt_ethernet_test_suite_top.v"
       `endif
       `endif

       `ifdef COMPL_TC
         `ifdef ETH_PROTECT
           `ifdef ETH_MULTI_PORT
              `include `NVS_SOURCE_MAP_SUITE_MODULE_V(ethernet_test_suite_svt,latest,svt_ethernet_test_suite_multi_port_top)
           `else
              `include `NVS_SOURCE_MAP_SUITE_MODULE_V(ethernet_test_suite_svt,latest,svt_ethernet_test_suite_top)
           `endif
         `else
           `ifdef ETH_MULTI_PORT
             `include "svt_ethernet_test_suite_multi_port_top.v"
             `include "svt_ethernet_test_suite_top.v"
           `else
             `include "svt_ethernet_test_suite_top.v"
           `endif
         `endif
       `endif
       
       /** Test Suite Macro responsible for tying the static VIP components to Test Suite */
       /** `SVT_ETHERNET_TEST_SUITE_MULTI_PORT_TOP_COMPILE (INST_NUM, TEST_INST_PATH, BFM_PATH, CHK_PATH, BFM_MAC_PATH) */
       /** ??? INST_NUM: Test suite instance/index number (for multiple test suite instances index number is unique */
       /** ??? TEST_INST_PATH: Top-level instance where test suite is instantiated. */
       /** ??? BFM_PATH:  Static component of VIP BFM instance used to drive test suite stimulus. */
       /** ??? CHK_PATH: . Static component of VIP Monitor/Checker instance used to perform the protocol parsing of traffic available on VIP physical interface tx_lane/rx_lane. */
       /** ??? BFM_MAC_PATH: Required only when DUT is in-between two VIP Instances where VIP0 is in PCS (serial/parallel) or PMA DUT - VIP1 (MAC). For standalone PCS setup, the BFM_MAC_PATH can be programmed as <NULL> i.e. ""  */
       
       `ifndef NON_ANLT_PTP 
         `ifndef PTP_EN
         `SVT_ETHERNET_TEST_SUITE_TOP_COMPILE(0,eth_env_top, eth_env_top.svt_ethernet_drv_0.Bfm, eth_env_top.svt_ethernet_mon_chk_0.Chk,"")
          `endif
        `endif

        `ifdef COMPL_TC
          `ifdef ETH_MULTI_PORT
            `SVT_ETHERNET_TEST_SUITE_MULTI_PORT_TOP_COMPILE(0,eth_env_top,eth_env_top.svt_ethernet_drv_0,eth_env_top.svt_ethernet_mon_chk_0,"")
          `else  //ifndef ETH_MULTI_PORT
           `SVT_ETHERNET_TEST_SUITE_TOP_COMPILE(0,eth_env_top,eth_env_top.svt_ethernet_drv_0.Bfm,eth_env_top.svt_ethernet_mon_chk_0.Chk,"")
          `endif
        `endif

`endif

`include "gdr_tb_defines.v"

`include "pam4_encoder_decoder.sv"

`ifdef PTP_EN
	`include "eth_ptp_sva_bind.sv"
   `ifdef ENABLE_ETH_VIP
      `include "serial_monitor.sv"

      //function to determine pam4 or nrz
      function automatic bit isPAM4 (string _speed_lane);
         typedef enum {_10G_1,_25G_1,_40G_4,_50G_2,_100G_4,_200G_8,_400G_16} nrz_e;
         nrz_e nrz_list;
         nrz_list = nrz_list.first();
         do
         begin
            if(nrz_list.name() == _speed_lane)begin
               $display("Variant is NRZ");
               return 0;
            end
            nrz_list = nrz_list.next();
         end
         while(nrz_list != nrz_list.first);
         //If not found anything, return 1
         $display("Variant is PAM4");
         return 1;
      endfunction: isPAM4

   `endif
`endif

module eth_env_top();

   localparam NUM_INST = `NUM_INST; 
   //localparam NUM_INST = `NUM_10G + `NUM_25G + `NUM_40G + `NUM_50G + `NUM_100G + `NUM_200G + `NUM_400G; // Combo speeds (Intelligence in script in checking max NUM_INST)

   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import altuvm_pkg::*;
   `include "altuvm_macros.svh"
   import altuvm_avalon_st_test_pkg::*;
   import altuvm_avalon_mm_test_pkg::*;
   import reset_uvc_pkg::*;

`ifdef ENABLE_ETH_VIP
   import svt_ethernet_uvm_pkg::*;
   import svt_uvm_pkg::*;
   `include "vip_clk_gen.sv"
   //Tasks to call testsuite tasks/events
   `include "eth_testsuite_tasks.sv"

   `ifdef ETH_MULTI_PORT
      svt_ethernet_multi_port_txrx_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) svt_ethernet_txrx_if[NUM_INST]();
   `else
      svt_ethernet_txrx_if svt_ethernet_txrx_if[NUM_INST](reference_clk); 
   `endif
    svt_ethernet_txrx_if uif_pcs66[NUM_INST](reference_clk); 
    eth_testsuite_tasks_intf ts_tasks_if[NUM_INST]();
     /** Instantiate Test Suite Signal Mapping Interface for tying DUT key events to VIP Test suite */
      `ifndef NON_ANLT_PTP 
       svt_ethernet_signal_mapping_if signal_map_if[NUM_INST]();   //schauh1x 
       svt_ethernet_test_suite_if directed_if[NUM_INST](); 
     `endif
     `ifdef COMPL_TC
      `ifdef ETH_MULTI_PORT
        svt_ethernet_signal_mapping_multi_port_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) signal_map_if();
        svt_ethernet_test_suite_multi_port_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) directed_if();
      `else
        svt_ethernet_signal_mapping_if signal_map_if();
        svt_ethernet_test_suite_if directed_if(); 
      `endif
     `endif
`endif
   import vector_uvc_pkg::*;
   import eth_env_pkg::*;
   //defparam eth_env_top.dut.dm_top.CFG_FIRMWARE = "../../fw_sram.hex"; 
 `ifndef PTP_EN
   `ifdef JSON_EN
      defparam dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = 4;   //To enable fast link-up
      defparam dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e200g_top.u_e200g_lphy.LOG2_MRK = 4;   //To enable fast link-up
   `else
      //defparam dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = 4;
      //defparam dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e200g_top.u_e200g_lphy.LOG2_MRK = 4;
   `endif
 `else
   //PTP - To enable fast link-up
   `ifdef JSON_EN
   defparam dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = X;
   `else
//   defparam dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.LOG2_MRK = X;
   `endif
 `endif
 `ifdef NON_ANLT_PTP
    `ifdef JSON_EN
        defparam dut_top__tiles.dut_top__tile_0__reset_controller.init_fname = "../../dut_top__tiles__dut_top__tile_0.mif";
    `else
//        defparam dut_top__tiles.z1577a_x0_y0_n0__reset_controller.init_fname = "../../dut_top__tiles__z1577a_x0_y0_n0.mif";
    `endif
`endif
`ifdef ETH_MGE
      `ifdef ETH_MGE_A10
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_0_INIT_FILE = "../../alt_mge_rcfg_a10_xcvr_1g.mif";
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_1_INIT_FILE = "../../alt_mge_rcfg_a10_xcvr_2p5g.mif";
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_2_INIT_FILE = "../../alt_mge_rcfg_a10_xcvr_2p5g.mif";
       `else
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg.u_mif_master.MODE_0_INIT_FILE = "../../alt_mge_phy_reconfig_parameters_CFG0.mif";
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg.u_mif_master.MODE_1_INIT_FILE = "../../alt_mge_phy_reconfig_parameters_CFG1.mif";
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg.u_mif_master.MODE_2_INIT_FILE = "../../alt_mge_phy_reconfig_parameters_CFG1.mif";
      `endif
`endif
    
`ifdef ETH_MGBASET
    `ifndef ETH_SM_MGBASET 
      `ifdef ETH_MGBASET_A10
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_0_INIT_FILE = "../../alt_mge_rcfg_a10_xcvr_1g.mif"; 
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_1_INIT_FILE = "../../alt_mge_rcfg_a10_xcvr_2p5g.mif";
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_2_INIT_FILE = "../../alt_mge_rcfg_a10_xcvr_10g.mif";
      `else
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_0_INIT_FILE = "../../alt_mge_phy_reconfig_parameters_CFG0.mif"; 
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_1_INIT_FILE = "../../alt_mge_phy_reconfig_parameters_CFG1.mif";
          defparam eth_env_top.dut.U_DUT_WRAPPER.U_DUT.u_rcfg_a10.u_mif_master.MODE_2_INIT_FILE = "../../alt_mge_phy_reconfig_parameters_CFG2.mif";
      `endif
    `endif
`endif 
 
`ifndef PTP_EN
    // Added by atiwari2, for fastening of the sim
 //   defparam eth_env_top.dut.ip0.top_ip0.sip_inst.clk_mon_inst.SIM_HURRY = 1'b1;
 //   defparam eth_env_top.dut.ip0.top_ip0.sip_inst.clk_mon_inst.SIM_EMULATE =1'b1;
`endif
 
//`ifdef PTP_EN
//    //Default acc testing is on
//   //TODO_GDR: Need a better way to override the RTL param
//      defparam eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_ACC_MODE = 32'h1; //to turn on/off accuracy measurement
//    
//`endif
   
`include "altuvm_avalon_st_uvc_defines.svh"
`include "altuvm_avalon_st_tb_defines.svh"
`include "altuvm_avalon_mm_tb_defines.svh"
`include "avst_params_10G.sv"
`include "avst_params_25G.sv"
`include "avst_params_50G.sv"
`include "avst_params_40G.sv"
`include "avst_params_100G.sv"
`include "params_avmm.sv"
`ALTUVM_AVALON_ST_RTB_TB_PARAM_PRINT

`include "eth_ipg_chk_defines.vh"
    //---------------------------------------------------------------------------
    //  Signals
    //---------------------------------------------------------------------------


    bit async_mac_clk_tx,async_mac_clk_rx;
    int phase_shift;
    int freq_var_tx=390;
    int freq_var_rx=390;
    int max_phase_shift;
    int Fmin_Tx;
    int Fmin_Rx;
    bit enable_async_clk;
    logic i_refclk2pll=0;
    logic i_refclk2syspll=0;
    logic clk_156p25=0;
    logic clk_106p25=0;
    logic flux_clk_ip0=0;
    real refclk2pll_pulse_width;
    real refclk2syspll_pulse_width;
    logic refclk=0;


  // Clock Generation
   parameter sim_cycle = 2.56;
   
   // Reset Delay Paramerster
   parameter rst_delay = 50;

// Below code replaced as per DR.
// Need to check with sindhu FIXME ALEX
//   initial
//   begin
//     enable_async_clk = 0;
//     max_phase_shift = `CLK_FREQ(((`preamble_passthrough & 1) ? 0:8),((`rx_bytes_to_remove == 0 )? 0:4),`ipg_script);
//     Fmin  = 1000000 / (`CLK_FREQ(((`preamble_passthrough & 1) ? 0:8),((`rx_bytes_to_remove == 0)? 0:4),`ipg_script)*2);
//     phase_shift = $urandom_range(1,max_phase_shift);
//     `uvm_info("eth_ehip_gdr_top", $sformatf("-------------------------------------------" ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("half clok period        =%d",max_phase_shift ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("phase_shift             =%d",phase_shift ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("Fmin(Mhz)               =%d",Fmin ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("`preamble_passthrough   =%d",`preamble_passthrough ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("`rx_bytes_to_remove     =%d",`rx_bytes_to_remove ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("`ipg_script             =%d",`ipg_script ), UVM_NONE)
//     `uvm_info("eth_ehip_gdr_top", $sformatf("-------------------------------------------" ), UVM_NONE)
//     for( int i=0;i<phase_shift;i++) 
//     begin
//      #1ps;
//     end
//     enable_async_clk = 1;
//   end
//
//   always
//   begin
//    #`CLK_FREQ(((`preamble_passthrough & 1) ? 0:8),((`rx_bytes_to_remove == 0)? 0:4),`ipg_script) async_mac_clk_tx = ~ async_mac_clk_tx;
//   end
//
//   always
//   begin
//     if(enable_async_clk == 1'b1) begin
//     #`CLK_FREQ(((`preamble_passthrough & 1) ? 0:8),((`rx_bytes_to_remove == 0)? 0:4),`ipg_script) async_mac_clk_rx = ~ async_mac_clk_rx;
//     end
//     else
//     begin
//      #1ps;
//      async_mac_clk_rx = 0;
//     end
//   end

initial
   begin
     enable_async_clk = 0;
     #1ps; 
     if(spy_if_ip0.speed==_100G && spy_if_ip0.preamble_passthrough==0) //rxbyte_rem=0,ipg=1
     begin
     std::randomize (freq_var_tx) with {freq_var_tx dist {340000:=50,[340001:400000]:=25,[400001:500000]:=25};}; //minRx +1Mhz
     std::randomize (freq_var_rx) with {freq_var_rx dist {340000:=50,[340001:400000]:=25,[400001:400000]:=25};}; //minRx +1Mhz
     end
     else if(spy_if_ip0.speed==_100G && spy_if_ip0.preamble_passthrough==1) //rxbyte_rem=0,ipg=1
     begin
     std::randomize (freq_var_tx) with {freq_var_tx dist {380000:=50,[380001:450000]:=25,[450001:500000]:=25};}; 
     std::randomize (freq_var_rx) with {freq_var_rx dist {381000:=50,[381001:450000]:=25,[450001:500000]:=25};};
     end
     else if(spy_if_ip0.speed==_40G) ////rxbyte_rem=0,ipg=1,pp=0 
     begin
     std::randomize (freq_var_tx) with {freq_var_tx dist {312500:=50,[312501:400000]:=15,[400001:450000]:=20,[450001:500000]:=15};};  //calculation done with pp=0 for speeds other than 100G
     std::randomize (freq_var_rx) with {freq_var_rx dist {313500:=50,[313501:400000]:=15,[400001:450000]:=20,[450001:500000]:=15};};  
     end
     else if(spy_if_ip0.speed==_10G) ////rxbyte_rem=0,ipg=1,pp=0
     begin
     std::randomize (freq_var_tx) with {freq_var_tx dist {156250:=50,[156251:300000]:=15,[300001:400000]:=20,[400001:500000]:=15};}; 
     std::randomize (freq_var_rx) with {freq_var_rx dist {157250:=50,[157251:300000]:=15,[300001:450000]:=20,[400001:500000]:=15};};  
     end
     else if(spy_if_ip0.speed==_50G || spy_if_ip0.speed==_25G) ////rxbyte_rem=0,ipg=1,pp=0
     begin
     std::randomize (freq_var_tx) with {freq_var_tx dist {390625:=50,[390626:450000]:=30,[450001:500000]:=20};};  
     std::randomize (freq_var_rx) with {freq_var_rx dist {391625:=50,[391626:450000]:=30,[450001:500000]:=20};};  
     end
     else
     $display("Speed is not valid for async");
 
     $display("FREQ SET TO: Tx:%0d Mhz Rx:%0d MHz",freq_var_tx,freq_var_rx); 
     max_phase_shift=`CLK_FREQ(freq_var_rx);
     Fmin_Tx=1000000/(`CLK_FREQ(freq_var_tx)*2);
     Fmin_Rx=1000000/(`CLK_FREQ(freq_var_rx)*2);
     phase_shift = $urandom_range(1,max_phase_shift); 
     $display("phase_shift count:%0d",phase_shift);
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("-------------------------------------------" ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("half clok period        =%d",max_phase_shift ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("phase_shift             =%d",phase_shift ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("TX Fmin(Mhz)               =%d",Fmin_Tx ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("RX Fmin(Mhz)               =%d",Fmin_Rx ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("preamble_passthrough   =%d",spy_if_ip0.preamble_passthrough ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("`rx_bytes_to_remove     =%d",spy_if_ip0.rxbyte_rem ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("`ipg_script             =%d",spy_if_ip0.ipg ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("-------------------------------------------" ), UVM_NONE)
     for( int i=0;i<phase_shift;i++) 
     begin
      #1ps;
     end
     enable_async_clk = 1;
	     //#HSD : 16012971982
     spy_if_ip0.async_clk_freq_tx = Fmin_Tx;
     spy_if_ip0.async_clk_freq_rx = Fmin_Rx;
     `uvm_info("Divya_eth_ehip_gdr_top_head", $sformatf("ASYNC TX clk=%0d , RX clk=%d",spy_if_ip0.async_clk_freq_tx,spy_if_ip0.async_clk_freq_rx), UVM_NONE)
    
     `ifdef PTP_EN 
     //<<===TODO SRC AUTO WORKAROUND - eth7,17,12,10 - HSD#https://hsdes.intel.com/appstore/article/#/22011517187
     // hijack this initial begin for cdr lock workaround
     //force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_ref_ts_capture_u.i_rxpll_lock = x;
     //TODO SRC AUTIO WORKAROUND ===>>
	  
	  //HSD#PFC issue (only for eth12) https://hsdes.intel.com/appstore/article/#/1508480333
	  //force eth_env_top.eth_fc_if_ip0.assertion_off = 1;	  
     
    `endif
     `ifndef PTP_EN 
//       if(spy_if_ip0.trans_type ==1 &&(spy_if_ip0.fec_type==3 || spy_if_ip0.fec_type==4)) begin
//
//        if(spy_if_ip0.ch_num ==1 || spy_if_ip0.ch_num ==2 || spy_if_ip0.ch_num == 4) begin
//         force `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.serdes_lane_wrap_ins.ip758brktop_serdes_lane_top_lane3_ins.brk_lane_ana_top_ins.brk_lane_ana_wrap_ins.ip758brktop_lane_top.brk_simple_ana_ins.div33_34_sel[1:0]= 2'b11;
//         end
//
//        if(spy_if_ip0.ch_num ==2 || spy_if_ip0.ch_num == 4) begin
//         force `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.serdes_lane_wrap_ins.ip758brktop_serdes_lane_top_lane2_ins.brk_lane_ana_top_ins.brk_lane_ana_wrap_ins.ip758brktop_lane_top.brk_simple_ana_ins.div33_34_sel[1:0]= 2'b11;
//         end
//      
//        if(spy_if_ip0.ch_num == 4) begin
//         force `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.serdes_lane_wrap_ins.ip758brktop_serdes_lane_top_lane1_ins.brk_lane_ana_top_ins.brk_lane_ana_wrap_ins.ip758brktop_lane_top.brk_simple_ana_ins.div33_34_sel[1:0]= 2'b11;
//         force `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.u_ip758brktop.serdes_wrap_ins.serdes_lane_wrap_ins.ip758brktop_serdes_lane_top_lane0_ins.brk_lane_ana_top_ins.brk_lane_ana_wrap_ins.ip758brktop_lane_top.brk_simple_ana_ins.div33_34_sel[1:0]= 2'b11;
//         end
//       end
    `endif
   end

   always
   begin
    #`CLK_FREQ(freq_var_tx) async_mac_clk_tx = ~ async_mac_clk_tx;
   end

   always
   begin
     if(enable_async_clk == 1'b1) begin
    #`CLK_FREQ(freq_var_rx) async_mac_clk_rx = ~ async_mac_clk_rx;
     end
     else
     begin
      #1ps;
      async_mac_clk_rx = 0;
     end
   end
   //async clk logic ends

   // int unsigned : ts_num_of_test_done
   // This variable is used to count test_case_ends event for slected number of cases from testsuite
   int unsigned ts_num_of_test_done;
   // reg : start_snps_testsuite
   // This is used to trigger start in testsuite
   reg start_snps_testsuite = 0;
   logic skip_crc; 
   uvm_event_pool a_event_pool;
   uvm_event assertion_event;

   logic[NUM_INST-1:0] assertion_on_off_reset;

   typedef virtual eth_sideband_interface v_if1;
   typedef virtual spy_interface v_if2;
 
    initial
    begin
      a_event_pool = new();
      a_event_pool = a_event_pool.get_global_pool();
      assertion_event = a_event_pool.get("assertion_event");
    end
    always begin
        #2ns flux_clk_ip0 = ~flux_clk_ip0; 
    end
    always begin 
         #3.2ns clk_156p25 = ~clk_156p25;
    end
    always begin 
         #4.706ns clk_106p25 = ~clk_106p25;
    end
    always begin
         //#3200 i_refclk2pll = ~i_refclk2pll;
         #refclk2pll_pulse_width i_refclk2pll = ~i_refclk2pll;
    end 
    always begin
         #refclk2syspll_pulse_width i_refclk2syspll = ~i_refclk2syspll;
    end 
    initial begin
       refclk2pll_pulse_width = 1551.515151; //322.26MHz
       refclk2syspll_pulse_width = 1600;
	    #10;
       //case(spy_if_ip0.phyrefclk)
       // 0: refclk2pll_pulse_width = 3200;
       // 1: refclk2pll_pulse_width = 1551.515151;
       // 2: refclk2pll_pulse_width = 1600;
       // 3: refclk2pll_pulse_width = 775.757575;
       //endcase
       //case(spy_if_ip0.syspllcnt)
       // 40'd8300781250: refclk2syspll_pulse_width = 3200;
       // 40'd9031250000: refclk2syspll_pulse_width = 2941;
       // 40'd9500000000: refclk2syspll_pulse_width = 5000;
       // 40'd10000000000: refclk2syspll_pulse_width = 5000;
       // 40'd8700000000: refclk2syspll_pulse_width = 5000;
       // default: $error("SYSPLLCST value %0d is out of range",spy_if_ip0.syspllcnt); 
       //endcase

     `uvm_info("eth_ehip_gdr_top_head", $sformatf("refclk2syspll pulse width %0d",refclk2syspll_pulse_width ), UVM_NONE)
     `uvm_info("eth_ehip_gdr_top_head", $sformatf("refclk2pll pulse width %0f",refclk2pll_pulse_width ), UVM_NONE)

      if ($test$plusargs("DUT_TX_POS_PPM")) begin
         refclk2pll_pulse_width = 3199.68;
      end
      else if ($test$plusargs("DUT_TX_NEG_PPM")) begin
         refclk2pll_pulse_width = 3200.32;
      end
    end

    `ifdef NON_ANLT_PTP
//      dut_top__tiles dut_top__tiles_inst();
    `endif  
//mprash2x

`ifdef ENABLE_ETH_VIP
   `ifdef ETH_MULTI_PORT
          assign dut.refclk= svt_ethernet_txrx_if[0].xsbi_tx_clk;
   `else
       `ifndef ETH_BASERS10_ARRIA 
       `ifndef ETH_MGBASET
        `ifndef ETH_MGE_A10 
         `ifndef ETH_NF_10G
           assign dut.refclk= svt_ethernet_txrx_if[0].gmii_tx_clk;
       `endif  
       `endif  
       `endif  
       `endif  
   `endif
`else 
   always begin
      #776ps refclk = ~refclk;
   end
   `ifdef ETH_MULTI_PORT
     assign dut.refclk = refclk;
   `endif
`endif
`ifdef ETH_SM_MGBASET
               assign dut.refclk= clk_156p25;//svt_ethernet_txrx_if[0].gmii_tx_clk;
               // assign dut.refclk= svt_ethernet_txrx_if[0].gmii_tx_clk;
       `endif 


 
`ifdef PTP_EN
   logic clk_status_ip0=0;
   //---------------------------------------------------------------------------
   //  P2P Reconfig
   //---------------------------------------------------------------------------
   altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_p2p (
                                                                  .clk                       (clk_status_ip0),
                                                                  .reset                     (reset_ip0)
                                                                  );
   altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,
                          .IS_ACTIVE                 (UVM_ACTIVE),
                          .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
                          ) avmm_rtb_p2p (.uif(avmm_if_p2p));

   initial begin
      uvm_config_db#(string)::set(uvm_root::get(),"*top_env","p2p_avmm_rtb_path","avmm_rtb_p2p");
   end


   //---------------------------------------------------------------------------
   //  ASM Reconfig
   //---------------------------------------------------------------------------
   altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_asm (
                                                                  .clk                       (clk_status_ip0),
                                                                  .reset                     (reset_ip0)
                                                                  );
   altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,
                          .IS_ACTIVE                 (UVM_ACTIVE),
                          .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
                          ) avmm_rtb_asm (.uif(avmm_if_asm));

   initial begin
      uvm_config_db#(string)::set(uvm_root::get(),"*top_env","asm_avmm_rtb_path","avmm_rtb_asm");
   end

   // Connections
 wire [16:0]    i_reconfig_ptp_p2p_addr_ip0;
 wire [3:0]     i_reconfig_ptp_p2p_byteenable_ip0;
 wire           o_reconfig_ptp_p2p_readdata_valid_ip0;
 wire           i_reconfig_ptp_p2p_read_ip0;
 wire           i_reconfig_ptp_p2p_write_ip0;
 wire [31:0]    o_reconfig_ptp_p2p_readdata_ip0;
 wire [31:0]    i_reconfig_ptp_p2p_writedata_ip0;
 wire           o_reconfig_ptp_p2p_waitrequest_ip0;
 wire [16:0]    i_reconfig_ptp_asym_addr_ip0;
 wire [3:0]     i_reconfig_ptp_asym_byteenable_ip0;
 wire           o_reconfig_ptp_asym_readdata_valid_ip0;
 wire           i_reconfig_ptp_asym_read_ip0;
 wire           i_reconfig_ptp_asym_write_ip0;
 wire [31:0]    o_reconfig_ptp_asym_readdata_ip0;
 wire [31:0]    i_reconfig_ptp_asym_writedata_ip0;
 wire           o_reconfig_ptp_asym_waitrequest_ip0;

     assign i_reconfig_ptp_asym_write_ip0          = avmm_if_asm.write;
     assign i_reconfig_ptp_asym_read_ip0           = avmm_if_asm.read;
     assign i_reconfig_ptp_asym_addr_ip0           = avmm_if_asm.address;
     assign i_reconfig_ptp_asym_writedata_ip0      = avmm_if_asm.writedata;
     assign i_reconfig_ptp_asym_byteenable_ip0     = 4'hf;
     assign avmm_if_asm.readdata         = o_reconfig_ptp_asym_readdata_ip0;
     assign avmm_if_asm.waitrequest      = o_reconfig_ptp_asym_waitrequest_ip0;
     assign avmm_if_asm.readdatavalid    = o_reconfig_ptp_asym_readdata_valid_ip0;

     assign i_reconfig_ptp_p2p_write_ip0          = avmm_if_p2p.write;
     assign i_reconfig_ptp_p2p_read_ip0           = avmm_if_p2p.read;
     assign i_reconfig_ptp_p2p_addr_ip0           = avmm_if_p2p.address;
     assign i_reconfig_ptp_p2p_writedata_ip0      = avmm_if_p2p.writedata;
     assign i_reconfig_ptp_p2p_byteenable_ip0     = 4'hf;
     assign avmm_if_p2p.readdata         = o_reconfig_ptp_p2p_readdata_ip0;
     assign avmm_if_p2p.waitrequest      = o_reconfig_ptp_p2p_waitrequest_ip0;
     assign avmm_if_p2p.readdatavalid    = o_reconfig_ptp_p2p_readdata_valid_ip0;


    initial begin
     `ifdef FAST_CLK
     force  avmm_rtb_p2p.master.u.u_bfm.command_timeout=3000;
     force  avmm_rtb_asm.master.u.u_bfm.command_timeout=3000;
     `else
     force  avmm_rtb_p2p.master.u.u_bfm.command_timeout=300;
     force  avmm_rtb_asm.master.u.u_bfm.command_timeout=300;
     `endif

    end

`endif

//END COMMON-HEAD
