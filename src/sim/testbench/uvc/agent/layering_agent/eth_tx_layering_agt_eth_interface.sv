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


//
// Template for UVM-compliant interface
//

`ifndef ETH_SIDEBAND_INTERFACE__SV
`define ETH_SIDEBAND_INTERFACE__SV

interface eth_sideband_interface #(
//VCS coverage off
   //`ifdef LAY__PARAM_ANSI
     parameter                 WIDTH_0_TO_1_BIT_CHANGE                            = 0, 
   parameter                 WIDTH_7_TO_15_BIT_CHANGE                           = 7,
   parameter                 WIDTH_6_TO_13_BIT_CHANGE                           = 6,
   parameter                 WIDTH_15_TO_31_BIT_CHANGE                          = 15,
   parameter                 WIDTH_95_TO_191_BIT_CHANGE                         = 95
      //`LAY__PARAM_ANSI
  // `endif
  // parameter   real           OUT_DELAY_RATIO = 0.2
) (
   input bit clk, //streaming clk 
   input bit clk_tx, //streaming clk 
   input bit clk_rx, //streaming clk 
   input bit rst, 
   input bit rx_tod_clk /*for ptp*/, 
   //input bit cadence_clk /*for custom cadence*/, //use streaming clk - i_clk_tx
   input bit tx_tod_clk /*for ptp*/);

   logic          tx_lane_stable;
   logic          rx_pcs_ready;
   logic          ehip_ready;
   logic          tx_ready;
   logic          tx_error;
   logic  [63:0]  temp_pre;
   logic  [63:0]  l2_tx_preamble;
   logic  [63:0]  l2_rx_preamble;
   logic tx_skip_crc;  
   logic custom_cadence;
   bit snapshot_en;  
   logic  [63:0]  mon_tx_preamble;
   logic rx_pause;

 // ****************PTP INTERFACE**************************************
  //2step
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_req;
 //logic [WIDTH_7_TO_15_BIT_CHANGE:0] ptp_fp;
 logic [31:0] ptp_fp; //set to max
//1 step
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_ets;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_cf;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_0csum;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_eb;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_format;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_asym_lat_en;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_asym_sign;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] ptp_p2p_en;
 logic [WIDTH_6_TO_13_BIT_CHANGE:0] ptp_asym_p2p_idx;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] ptp_ts_offset;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] ptp_cf_offset;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] ptp_csum_offset;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] ptp_eb_offset;
 //logic [191:0] ptp_ts;
 logic [WIDTH_95_TO_191_BIT_CHANGE:0] ptp_ts;
 logic [95:0] ptp_tx_tod;
 logic [95:0] ptp_rx_tod;
//tx output
  logic ptp_valid;
  //logic [191:0] ptp_ets_o;
  logic [191:0] ptp_ets_o;
 // logic [15:0] ptp_fp_o;
  logic [63:0] ptp_fp_o; //set to max*2

// Newly added to work with race condition fix for min sized packets
 logic  dut_tx_valid;
 logic  dut_tx_ready;
 //logic [1:0] dut_ptp_req;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_req;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_asym_lat_en;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_asym_sign;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_p2p_en;
 logic [WIDTH_6_TO_13_BIT_CHANGE:0] dut_ptp_asym_p2p_idx;
// logic [WIDTH_7_TO_15_BIT_CHANGE:0] dut_ptp_fp;
 logic [31:0] dut_ptp_fp; //set to max
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_ets;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_cf;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_0csum;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_eb;
 logic [WIDTH_0_TO_1_BIT_CHANGE:0] dut_ptp_format;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] dut_ptp_ts_offset;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] dut_ptp_cf_offset;
 logic [WIDTH_15_TO_31_BIT_CHANGE:0] dut_ptp_csum_offset;
 logic [31:0] dut_ptp_eb_offset;
 logic ptp_error;
 //logic [191:0] dut_ptp_ts;
 logic [WIDTH_95_TO_191_BIT_CHANGE:0] dut_ptp_ts;
 logic dut_tx_sop;
 logic dut_custom_cadence;

 logic  tx_valid;

 // RX-PTP interface
 logic rx_sop;
 logic rx_valid;
 //logic [191:0] ptp_rx_its;//output
 logic [WIDTH_95_TO_191_BIT_CHANGE:0] ptp_rx_its;//output

//Status Output
logic tx_ptp_ready;
logic rx_ptp_ready;

 logic tx_sop;
 
 //debug
 logic [31:0] debug_tod_ns_max_b4;
 logic [31:0] debug_tod_ns_max_after;
 logic [31:0] debug_tod_nsecs;
 logic [31:0] debug_tx_tod_ref_ns_b4;
 logic [31:0] debug_tx_tod_ref_ns_after;
 logic [31:0] debug_rx_tod_ref_ns_b4;
 logic [31:0] debug_rx_tod_ref_ns_after; 
 logic [16:0] debug_tod_fns_part;
 logic [15:0] debug_tod_fnsecs;
 logic [47:0] debug_tod_secs;
 real         debug_realtime;
 
///////////////////////////////////////////////////////////////////////////////////// 
    logic tx_mii_i_clk_25g;        
    logic tx_mii_i_clk_50g;        
    logic tx_mii_i_clk_100g;        
    logic tx_mii_i_clk_200g;        
    logic tx_mii_i_clk_400g;        

    logic mii_tx_valid_25g;  
    logic mii_tx_valid_50g;  
    logic mii_tx_valid_100g; 
    logic mii_tx_valid_200g; 
    logic mii_tx_valid_400g;

    logic mii_am_valid_25g;  
    logic mii_am_valid_50g;  
    logic mii_am_valid_100g; 
    logic mii_am_valid_200g; 
    logic mii_am_valid_400g;

    logic [31:0]mii_tx_data_lane_400g[16]; 
    logic [31:0]mii_tx_data_lane_200g[8]; 
    logic [31:0]mii_tx_data_lane_100g[4]; 
    logic [31:0]mii_tx_data_lane_50g[2]; 
    logic [31:0]mii_tx_data_lane_25g; 
   
    logic [3:0]mii_tx_c_lane_400g[16]; 
    logic [3:0]mii_tx_c_lane_200g[8]; 
    logic [3:0]mii_tx_c_lane_100g[4]; 
    logic [3:0]mii_tx_c_lane_50g[2]; 
    logic [3:0]mii_tx_c_lane_25g; 
 ////////////////////////////////////////////////////////////////////////////////////////////////


  //Variable: tx_mii_i_clk
   // Signal to hold the input clock of the TX-MAC
    logic tx_mii_i_clk;        
   
   //Variable: mii_tx_data_lane_3
   //Signal to map the TX MAC mii output data of the lane 3
    logic [63:0]mii_tx_data_lane_3; 
   //Variable: mii_tx_data_lane_2
   //Signal to map the TX MAC mii output data of the lane 2
    logic [63:0]mii_tx_data_lane_2; 
   //Variable: mii_tx_data_lane_1
   //Signal to map the TX MAC mii output data of the lane 1
    logic [63:0]mii_tx_data_lane_1; 
   //Variable: mii_tx_data_lane_0
   //Signal to map the TX MAC mii output data of the lane 0
    logic [63:0]mii_tx_data_lane_0; 
   //Variable: mii_tx_valid
   //Signal to map the TX MAC mii output data valid
    logic mii_tx_valid; 
    //Singal to map MAC am_valid
    logic mii_am_valid;
   //Variable: mii_tx_c_lane_3
   //Signal to map the TX MAC mii output control of the lane 3
    logic [7:0]mii_tx_c_lane_3; 
   //Variable: mii_tx_c_lane_2
   //Signal to map the TX MAC mii output control of the lane 2
    logic [7:0]mii_tx_c_lane_2; 
   //Variable: mii_tx_c_lane_1
   //Signal to map the TX MAC mii output control of the lane 1
    logic [7:0]mii_tx_c_lane_1; 
   //Variable: mii_tx_c_lane_0
   //Signal to map the TX MAC mii output control of the lane 0
    logic [7:0]mii_tx_c_lane_0; 
   
   //Variable: ipg_value
   //Signal to map the ipg_value observed by IPG monitor
    int ipg_value; 

    clocking drv_cb@(posedge clk); 
      output ptp_ts;
    endclocking:drv_cb

     clocking drv_tx_tod_cb@(posedge tx_tod_clk); 
      output ptp_tx_tod;
    endclocking:drv_tx_tod_cb
  
 
    clocking drv_rx_tod_cb@(posedge rx_tod_clk);
      output ptp_rx_tod;
    endclocking:drv_rx_tod_cb    
    
    modport drv_if(clocking drv_cb,input clk,input rst);

    clocking mon_cb@(negedge clk); 
      input dut_ptp_ts;
      input dut_tx_ready;
      input dut_tx_valid;
      input dut_tx_sop;
      input dut_ptp_ets;
      input dut_ptp_cf;
      input dut_ptp_req;
      input dut_ptp_asym_lat_en;
      input dut_ptp_asym_sign;
      input dut_ptp_asym_p2p_idx;
      input dut_ptp_p2p_en;
      input dut_ptp_0csum;
      input dut_ptp_eb;
      input dut_ptp_format;
      input dut_ptp_ts_offset;
      input dut_ptp_cf_offset;
      input dut_ptp_csum_offset;
      input dut_ptp_eb_offset;
      input dut_ptp_fp;
      input ptp_error;
      input dut_custom_cadence;
      input tx_skip_crc;
    endclocking:mon_cb

    modport mon_if(clocking mon_cb,input clk,input rst);

endinterface: eth_sideband_interface

`endif // ETH_SIDEBAND_INTERFACE__SV

