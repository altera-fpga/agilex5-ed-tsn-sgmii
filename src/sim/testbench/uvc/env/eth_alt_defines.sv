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



//Enum : eth_alt_defines
//This enum defines the supported ethenet frame type
typedef enum {DATA_FRAME,VLAN_FRAME,JUMBO_DATA_FRAME,STACKED_VLAN_FRAME,JUMBO_VLAN_FRAME,JUMBO_STACKED_VLAN_FRAME,CONTROL_FRAME,PFC_FRAME,SFC_FRAME,SFC_XOFF_FRAME,SFC_XON_FRAME,RANDOM_FRAME,UNDERSIZE_FRAME,IPG_STRESS,LINK_FAULT,MCAST_DATA_FRAME,BCAST_DATA_FRAME,UCAST_DATA_FRAME,MCAST_CTRL_FRAME,BCAST_CTRL_FRAME,UCAST_CTRL_FRAME,IPV4_FRAME,IPV6_FRAME,USER_DEFINED_FRAME,PADDED_FRAME,FRAME_CRC_COVERS_PREAMBLE,SFC_XOFF_MAX_FRAME,MISC_CONTROL_FRAME} frame_type;
typedef enum {ETH_DATA_FRAME,ETH_VLAN_FRAME,ETH_JUMBO_DATA_FRAME,ETH_STACKED_VLAN_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME,ETH_SFC_FRAME,ETH_PFC_FRAME,ETH_MISC_CONTROL_FRAME,ETH_UNDERSIZE_FRAME,ETH_MCAST_DATA_FRAME,ETH_BCAST_DATA_FRAME,ETH_UCAST_DATA_FRAME,ETH_MCAST_CTRL_FRAME,ETH_BCAST_CTRL_FRAME,ETH_UCAST_CTRL_FRAME,ETH_IPV4_FRAME,ETH_IPV6_FRAME,ETH_USER_DEFINED_FRAME} eth_transaction_frame_type;

`include "gdr_tb_defines.v"
typedef enum {BUSY,MODERATE,FREE} seg_bus;

//Enum : xfer_path
//This enum defines data transfer path
typedef enum {ETH_VIP_AVL_RX,AVL_TX_ETH_VIP,ETH_VIP_MAC_BOTH,OTN_MODE,FLEXE_MODE} xfer_path;

typedef enum {RAND,INCR,PTP_DEBUG} payload_type;
typedef enum {NORMAL,UNDERSIZE} frame_payload_size;

`ifdef ETH_MULTI_PORT
 `define MAC_CFG mac_cfg.cfg[0]
 `define M_SNPS_ETH_PCS66_AGENT m_snps_eth_pcs66_agent.eth_agent[0]
 `define SEQUENCER sequencer.sequencer[0]
`else
 `define MAC_CFG mac_cfg
 `define M_SNPS_ETH_PCS66_AGENT m_snps_eth_pcs66_agent
 `define SEQUENCER sequencer
`endif

`define GMII_D_WIDTH 256
`define GMII_C_WIDTH 32
`define DUT_IOPLL_CLK eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.iopll_tx
`define DUT_ADAPTER_ENA eth_env_top.dut.U_DUT.phy.alt_mge_phy_0.mge_pcs.genblk1.u_hps_to_mge_gmii_adapter_core
`define P2P_CFG_BASE_ADDR 'h5000
`define ASM_CFG_BASE_ADDR 'h5000

//Need to review for BK internal register base address between CFG vs TOP
`define BARAK_CFG_BASE_ADDR 'hf0000
`define BARAK_IP758_BASE_ADDR 'h00000000

//Temporary Barak assign to 0 as not yet enable
`define BK_QUAD_TOP_BASE_ADDR 'h00000000
`define UX_QUAD_TOP_BASE_ADDR 'hf0000

// PTP cheat sheet, page 38 says always use V2 format for insert_cf - check with design team
// ptp_op_e = (p2p, ts_format, insert_2step, insert_1step, insert_cf, udp_cs_0, add_eb, ptp_asym_latency_en)

typedef enum {INS_NOOP                     = 8'b00000000,

              INS_V1                       = 8'b01010000, 
              INS_V1_W_UDP_CS_0            = 8'b01010100, 
              INS_V1_W_EB                  = 8'b01010010, 
              INS_V1_W_ASYM_LAT            = 8'b01010001, 
              INS_V1_W_ASYM_LAT_UDP_CS_0   = 8'b01010101, 
              INS_V1_W_ASYM_LAT_EB         = 8'b01010011, 

              INS_V2                       = 8'b00010000, 
              INS_V2_W_UDP_CS_0            = 8'b00010100, 
              INS_V2_W_EB                  = 8'b00010010, 
              INS_V2_W_ASYM_LAT            = 8'b00010001, 
              INS_V2_W_ASYM_LAT_UDP_CS_0   = 8'b00010101, 
              INS_V2_W_ASYM_LAT_EB         = 8'b00010011, 

              INS_CF                       = 8'b00001000,
              INS_CF_W_UDP_CS_0            = 8'b00001100, 
              INS_CF_W_EB                  = 8'b00001010,
              INS_CF_W_ASYM_LAT            = 8'b00001001, 
              INS_CF_W_ASYM_LAT_UDP_CS_0   = 8'b00001101,
              INS_CF_W_ASYM_LAT_EB         = 8'b00001011,
              
              INS_P2P                      = 8'b10001000, 
              INS_P2P_W_UDP_CS_0           = 8'b10001100, 
              INS_P2P_W_EB                 = 8'b10001010, 
              INS_P2P_W_ASYM_LAT           = 8'b10001001, 
              INS_P2P_W_ASYM_LAT_UDP_CS_0  = 8'b10001101, 
              INS_P2P_W_ASYM_LAT_EB        = 8'b10001011,             

              INS_ASYM_LAT                 = 8'b00000001,
              INS_ASYM_LAT_CS_0            = 8'b00000101,
              INS_ASYM_LAT_EB              = 8'b00000011,

              INS_2STEP                    = 8'b00100000,
              //Invalid Opcodes
              INS_INVALID_ETS_V1           = 8'b01011110,
              INS_INVALID_ETS_V2           = 8'b00011110,
              INS_INVALID_V1               = 8'b01001110,
              INS_INVALID_V2               = 8'b00001110,
              INS_INVALID_CS_EB_V1         = 8'b01000110,
              INS_INVALID_CS_EB_V2         = 8'b00000110

} ptp_op_e;

typedef enum {PTP_NORMAL, PTP_ERR} ptp_kind_e;

typedef enum {
              TX_AM = 0,
              RX_AM = 1,
              TX_UI = 2,
              RX_UI = 3,
              RX_VL = 4
} load_opcode_type_e;


typedef enum {PRESET,INITIALIZE,CO_EFF_POS,CO_EFF_ZERO,CO_EFF_NEG,CO_EFF_ALL,DEFAULT} eth_lt_command_type;
typedef enum {HOLD=0,INC=1,DEC=2,RES=3} eth_lt_coeff_upd;
`define POSTCOEFFMIN 25
`define POSTCOEFFMAX 0
`define PRECOEFFMIN 16
`define PRECOEFFMAX 0
`define MAINCOEFFMIN 14
`define MAINCOEFFMAX 30

// Structure for VL offset data collection
parameter BILLION_NS = 48'd65536_000_000_000; // Fractional shift of Timestamp  1000_000_000 * 2^16

typedef struct packed {
                  bit [38]    vl_offset_time_sign; 
                  bit [37:23] vl_offset_time_ns; 
                  bit [22:7]  vl_offset_time_fns; 
                  bit [6:5]   local_pl;
                  bit [4:0]   remote_vl;

} rx_vl_offset_data_s;
// Structure for VL offset data collection

// Enums for dynamic config object
typedef enum {_400G,_200G,_100G,_50G,_40G,_25G,_10G,_5G,_2p5G,_1G,_100M,_10M} speed_e;
typedef enum {MACSEG, PCSMAC, PCSONLY, OTN, FLEXE} mode_e;
typedef enum {NOFEC, FCFEC, RSFECKR, RSFECKP, LLFEC} fec_type_e;
typedef enum {IEEE, CONSORTIUM, IEEE_CONSORTIUM} anlt_std_e;

// Below defines to conviniently access static paths through testssuite_task_if
`define BFM_FUNCTION(bfm_path,func_path) \
            if(ip == 0)      $root.``bfm_path``_0.``func_path``; //\
            `ifdef INST_1 else if(ip == 1) $root.``bfm_path``_1.``func_path``; `endif  \
            `ifdef INST_2 else if(ip == 2) $root.``bfm_path``_2.``func_path``; `endif \
            `ifdef INST_3 else if(ip == 3) $root.``bfm_path``_3.``func_path``; `endif \
            `ifdef INST_4 else if(ip == 4) $root.``bfm_path``_4.``func_path``; `endif \
            `ifdef INST_5 else if(ip == 5) $root.``bfm_path``_5.``func_path``; `endif \
            `ifdef INST_6 else if(ip == 6) $root.``bfm_path``_6.``func_path``; `endif \
            `ifdef INST_7 else if(ip == 7) $root.``bfm_path``_7.``func_path``; `endif \
            `ifdef INST_8 else if(ip == 8) $root.``bfm_path``_8.``func_path``; `endif \
            `ifdef INST_9 else if(ip == 9) $root.``bfm_path``_9.``func_path``; `endif \
            `ifdef INST_10 else if(ip == 10) $root.``bfm_path``_10.``func_path``; `endif \
            `ifdef INST_11 else if(ip == 11) $root.``bfm_path``_11.``func_path``; `endif \
            `ifdef INST_12 else if(ip == 12) $root.``bfm_path``_12.``func_path``; `endif \
            `ifdef INST_13 else if(ip == 13) $root.``bfm_path``_13.``func_path``; `endif \
            `ifdef INST_14 else if(ip == 14) $root.``bfm_path``_14.``func_path``; `endif \
            `ifdef INST_15 else if(ip == 15) $root.``bfm_path``_15.``func_path``; `endif 

`define FLEXE_BFM_FUNCTION(bfm_path,func_path) \
            `ifdef INST_FLEXE_0 if(ip == 0)      $root.``bfm_path``_0.``func_path``; `endif  \
            `ifdef INST_FLEXE_1 if(ip == 1) $root.``bfm_path``_1.``func_path``; `endif  \
            `ifdef INST_FLEXE_2 if(ip == 2) $root.``bfm_path``_2.``func_path``; `endif  \
            `ifdef INST_FLEXE_3 if(ip == 3) $root.``bfm_path``_3.``func_path``; `endif  \
            `ifdef INST_FLEXE_4 if(ip == 4) $root.``bfm_path``_4.``func_path``; `endif  \
            `ifdef INST_FLEXE_5 if(ip == 5) $root.``bfm_path``_5.``func_path``; `endif  \
            `ifdef INST_FLEXE_6 if(ip == 6) $root.``bfm_path``_6.``func_path``; `endif  \
            `ifdef INST_FLEXE_7 if(ip == 7) $root.``bfm_path``_7.``func_path``; `endif  \
            `ifdef INST_FLEXE_8 if(ip == 8) $root.``bfm_path``_8.``func_path``; `endif  \
            `ifdef INST_FLEXE_9 if(ip == 9) $root.``bfm_path``_9.``func_path``; `endif  \
            `ifdef INST_FLEXE_10 if(ip == 10) $root.``bfm_path``_10.``func_path``; `endif  \
            `ifdef INST_FLEXE_11 if(ip == 11) $root.``bfm_path``_11.``func_path``; `endif  \
            `ifdef INST_FLEXE_12 if(ip == 12) $root.``bfm_path``_12.``func_path``; `endif  \
            `ifdef INST_FLEXE_13 if(ip == 13) $root.``bfm_path``_13.``func_path``; `endif  \
            `ifdef INST_FLEXE_14 if(ip == 14) $root.``bfm_path``_14.``func_path``; `endif  \
            `ifdef INST_FLEXE_15 if(ip == 15) $root.``bfm_path``_15.``func_path``; `endif  \

`define OTN_BFM_FUNCTION(bfm_path,func_path) \
            `ifdef INST_OTN_0 if(ip == 0)      $root.``bfm_path``_0.``func_path``; `endif  \
            `ifdef INST_OTN_1 if(ip == 1) $root.``bfm_path``_1.``func_path``; `endif  \
            `ifdef INST_OTN_2 if(ip == 2) $root.``bfm_path``_2.``func_path``; `endif  \
            `ifdef INST_OTN_3 if(ip == 3) $root.``bfm_path``_3.``func_path``; `endif  \
            `ifdef INST_OTN_4 if(ip == 4) $root.``bfm_path``_4.``func_path``; `endif  \
            `ifdef INST_OTN_5 if(ip == 5) $root.``bfm_path``_5.``func_path``; `endif  \
            `ifdef INST_OTN_6 if(ip == 6) $root.``bfm_path``_6.``func_path``; `endif  \
            `ifdef INST_OTN_7 if(ip == 7) $root.``bfm_path``_7.``func_path``; `endif  \
            `ifdef INST_OTN_8 if(ip == 8) $root.``bfm_path``_8.``func_path``; `endif  \
            `ifdef INST_OTN_9 if(ip == 9) $root.``bfm_path``_9.``func_path``; `endif  \
            `ifdef INST_OTN_10 if(ip == 10) $root.``bfm_path``_10.``func_path``; `endif  \
            `ifdef INST_OTN_11 if(ip == 11) $root.``bfm_path``_11.``func_path``; `endif  \
            `ifdef INST_OTN_12 if(ip == 12) $root.``bfm_path``_12.``func_path``; `endif  \
            `ifdef INST_OTN_13 if(ip == 13) $root.``bfm_path``_13.``func_path``; `endif  \
            `ifdef INST_OTN_14 if(ip == 14) $root.``bfm_path``_14.``func_path``; `endif  \
	    `ifdef INST_OTN_15 if(ip == 15) $root.``bfm_path``_15.``func_path``; `endif  \

`define BFM_WAIT(bfm_path,var_path,val) \
            if(ip == 0)       wait($root.``bfm_path``[0].``var_path``==``val``); //\
            `ifdef INST_1 else if(ip == 1)  wait($root.``bfm_path``[1].``var_path``==``val``); `endif \
            `ifdef INST_2 else if(ip == 2)  wait($root.``bfm_path``[2].``var_path``==``val``); `endif \
            `ifdef INST_3 else if(ip == 3)  wait($root.``bfm_path``[3].``var_path``==``val``); `endif \
            `ifdef INST_4 else if(ip == 4)  wait($root.``bfm_path``[4].``var_path``==``val``); `endif \
            `ifdef INST_5 else if(ip == 5)  wait($root.``bfm_path``[5].``var_path``==``val``); `endif \
            `ifdef INST_6 else if(ip == 6)  wait($root.``bfm_path``[6].``var_path``==``val``); `endif \
            `ifdef INST_7 else if(ip == 7)  wait($root.``bfm_path``[7].``var_path``==``val``); `endif \
            `ifdef INST_8 else if(ip == 8)  wait($root.``bfm_path``[8].``var_path``==``val``); `endif \
            `ifdef INST_9 else if(ip == 9)  wait($root.``bfm_path``[9].``var_path``==``val``); `endif \
            `ifdef INST_10 else if(ip == 10) wait($root.``bfm_path``[10].``var_path``==``val``); `endif \
            `ifdef INST_11 else if(ip == 11) wait($root.``bfm_path``[11].``var_path``==``val``); `endif \
            `ifdef INST_12 else if(ip == 12) wait($root.``bfm_path``[12].``var_path``==``val``); `endif \
            `ifdef INST_13 else if(ip == 13) wait($root.``bfm_path``[13].``var_path``==``val``); `endif \
            `ifdef INST_14 else if(ip == 14) wait($root.``bfm_path``[14].``var_path``==``val``); `endif \
            `ifdef INST_15 else if(ip == 15) wait($root.``bfm_path``[15].``var_path``==``val``); `endif 

`define RTB_FUNCTION(rtb_path,func_path) \
            if(ip == 0)      $root.``rtb_path``_ip0.``func_path``; //\
            `ifdef INST_1 else if(ip == 1) $root.``rtb_path``_ip1.``func_path``; `endif \
            `ifdef INST_2 else if(ip == 2) $root.``rtb_path``_ip2.``func_path``; `endif \
            `ifdef INST_3 else if(ip == 3) $root.``rtb_path``_ip3.``func_path``; `endif \
            `ifdef INST_4 else if(ip == 4) $root.``rtb_path``_ip4.``func_path``; `endif \
            `ifdef INST_5 else if(ip == 5) $root.``rtb_path``_ip5.``func_path``; `endif \
            `ifdef INST_6 else if(ip == 6) $root.``rtb_path``_ip6.``func_path``; `endif \
            `ifdef INST_7 else if(ip == 7) $root.``rtb_path``_ip7.``func_path``; `endif \
            `ifdef INST_8 else if(ip == 8) $root.``rtb_path``_ip8.``func_path``; `endif \
            `ifdef INST_9 else if(ip == 9) $root.``rtb_path``_ip9.``func_path``; `endif \
            `ifdef INST_10 else if(ip == 10) $root.``rtb_path``_ip10.``func_path``; `endif \
            `ifdef INST_11 else if(ip == 11) $root.``rtb_path``_ip11.``func_path``; `endif \
            `ifdef INST_12 else if(ip == 12) $root.``rtb_path``_ip12.``func_path``; `endif \
            `ifdef INST_13 else if(ip == 13) $root.``rtb_path``_ip13.``func_path``; `endif \
            `ifdef INST_14 else if(ip == 14) $root.``rtb_path``_ip14.``func_path``; `endif \
            `ifdef INST_15 else if(ip == 15) $root.``rtb_path``_ip15.``func_path``; `endif 

`define RTB_XCVR_FUNCTION(num_lanes,rtb_path,func_path) \
            $root.``rtb_path``_0.``func_path``; //\
            `ifdef INST_0 //\
            `ifdef NUM_LANES_IP0_2 $root.``rtb_path``_1.``func_path``; `endif //\
            `ifdef NUM_LANES_IP0_4 $root.``rtb_path``_1.``func_path``; $root.``rtb_path``_2.``func_path``; $root.``rtb_path``_3.``func_path``;`endif \
            `ifdef NUM_LANES_IP0_8 $root.``rtb_path``_1.``func_path``; $root.``rtb_path``_2.``func_path``; $root.``rtb_path``_3.``func_path``; $root.``rtb_path``_4.``func_path``;$root.``rtb_path``_5.``func_path``; $root.``rtb_path``_6.``func_path``; $root.``rtb_path``_7.``func_path``;`endif \
             `endif //\    
          
// eth_testsuite_task_if defines END


// Get Register address based on speed
  `define GET_REG_ADDR(reg_name,speed) `reg_name
//  `define GET_REG_ADDR(reg_name,speed) (speed == _10G || speed==_25G)?`reg_name:\
//                                       (speed==_50G)?`ETH_F_ALL_``e50_``reg_name:\
//				       (speed==_100G || speed==_40G)?`ETH_F_ALL_``e100_``reg_name:\
//				       (speed==_200G)?`ETH_F_ALL_``e200_``reg_name:\
//				                      `ETH_F_ALL_``e400_``reg_name

