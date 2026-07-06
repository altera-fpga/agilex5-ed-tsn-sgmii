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


//THis file maps the signal required for IPG checker
`ifdef JSON_EN
   `define TX_MII_I_CLK_25 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_clk_tx
   `define MII_TX_VALID_25 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_25 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_25 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.d[31:0]
   `define MII_TX_C_LANE_25 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.c[3:0]
   
   `define TX_MII_I_CLK_50 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_clk_tx
   `define MII_TX_VALID_50 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_50 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_50_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_50_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_50_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_50_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].c[3:0]
   
   `define TX_MII_I_CLK_100 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_clk_tx
   `define MII_TX_VALID_100 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_100 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_100_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_100_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_100_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_100_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].c[3:0]
   `define MII_TX_DATA_LANE_100_2 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[2].d[31:0]
   `define MII_TX_C_LANE_100_2 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[2].c[3:0]
   `define MII_TX_DATA_LANE_100_3 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[3].d[31:0]
   `define MII_TX_C_LANE_100_3 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[3].c[3:0]
   
   `define TX_MII_I_CLK_200 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_clk_tx
   `define MII_TX_VALID_200 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_200 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_200_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_200_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_200_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_200_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[1].c[3:0]
   `define MII_TX_DATA_LANE_200_2 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[2].d[31:0]
   `define MII_TX_C_LANE_200_2 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[2].c[3:0]
   `define MII_TX_DATA_LANE_200_3 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[3].d[31:0]
   `define MII_TX_C_LANE_200_3 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[3].c[3:0]
   `define MII_TX_DATA_LANE_200_4 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[4].d[31:0]
   `define MII_TX_C_LANE_200_4 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[4].c[3:0]
   `define MII_TX_DATA_LANE_200_5 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[5].d[31:0]
   `define MII_TX_C_LANE_200_5 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[5].c[3:0]
   `define MII_TX_DATA_LANE_200_6 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[6].d[31:0]
   `define MII_TX_C_LANE_200_6 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[6].c[3:0]
   `define MII_TX_DATA_LANE_200_7 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[7].d[31:0]
   `define MII_TX_C_LANE_200_7 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[7].c[3:0]
   
   `define TX_MII_I_CLK_400 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_clk_tx
   `define MII_TX_VALID_400 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_400 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_400_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_400_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_400_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_400_1 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[1].c[3:0]
   `define MII_TX_DATA_LANE_400_2 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[2].d[31:0]
   `define MII_TX_C_LANE_400_2 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[2].c[3:0]
   `define MII_TX_DATA_LANE_400_3 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[3].d[31:0]
   `define MII_TX_C_LANE_400_3 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[3].c[3:0]
   `define MII_TX_DATA_LANE_400_4 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[4].d[31:0]
   `define MII_TX_C_LANE_400_4 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[4].c[3:0]
   `define MII_TX_DATA_LANE_400_5 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[5].d[31:0]
   `define MII_TX_C_LANE_400_5 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[5].c[3:0]
   `define MII_TX_DATA_LANE_400_6 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[6].d[31:0]
   `define MII_TX_C_LANE_400_6 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[6].c[3:0]
   `define MII_TX_DATA_LANE_400_7 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[7].d[31:0]
   `define MII_TX_C_LANE_400_7 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[7].c[3:0]
   `define MII_TX_DATA_LANE_400_8 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[8].d[31:0]
   `define MII_TX_C_LANE_400_8 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[8].c[3:0]
   `define MII_TX_DATA_LANE_400_9 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[9].d[31:0]
   `define MII_TX_C_LANE_400_9 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[9].c[3:0]
   `define MII_TX_DATA_LANE_400_10 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[10].d[31:0]
   `define MII_TX_C_LANE_400_10 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[10].c[3:0]
   `define MII_TX_DATA_LANE_400_11 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[11].d[31:0]
   `define MII_TX_C_LANE_400_11 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[11].c[3:0]
   `define MII_TX_DATA_LANE_400_12 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[12].d[31:0]
   `define MII_TX_C_LANE_400_12 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[12].c[3:0]
   `define MII_TX_DATA_LANE_400_13 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[13].d[31:0]
   `define MII_TX_C_LANE_400_13 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[13].c[3:0]
   `define MII_TX_DATA_LANE_400_14 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[14].d[31:0]
   `define MII_TX_C_LANE_400_14 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[14].c[3:0]
   `define MII_TX_DATA_LANE_400_15 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[15].d[31:0]
   `define MII_TX_C_LANE_400_15 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[15].c[3:0]
   
   //`define MII_TX_DATA_LANE_3  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[255:192]
   //`define MII_TX_DATA_LANE_2  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[191:128]
   //`define MII_TX_DATA_LANE_1  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[127:64]
   //`define MII_TX_DATA_LANE_0  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[63:0]
   //`define MII_TX_C_LANE_3  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[31:24] 
   //`define MII_TX_C_LANE_2  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[23:16]
   //`define MII_TX_C_LANE_1  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[15:8]
   //`define MII_TX_C_LANE_0  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[7:0]
   `define MII_TX_DATA_LANE_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.d[31:0]
   `define MII_TX_C_LANE_0 dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.c[3:0]
   //`define TX_MII_I_CLK         eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.clk
   `define TX_MII_I_CLK dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_clk_tx
   //`define EMPTY_BYTES_LANE_3   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[214:212] 
   //`define EMPTY_BYTES_LANE_2   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[144:142] 
   //`define EMPTY_BYTES_LANE_1   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[74:72] 
   //`define EMPTY_BYTES_LANE_0   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[4:2] 
   //
   //`define SOP_TX_MAC_I_LANE_3  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[215]
   //`define SOP_TX_MAC_I_LANE_2  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[145]
   //`define SOP_TX_MAC_I_LANE_1  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[75]
   //`define SOP_TX_MAC_I_LANE_0  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[5]
   //`define MII_TX_VALID  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_valid
   //`define MII_TX_VALID dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0.tx_mac.mii_valid
   `define MII_TX_VALID dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0.o_mii_am_valid
`else
   `define TX_MII_I_CLK_25 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_clk_tx
   `define MII_TX_VALID_25 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_25 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_25 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.d[31:0]
   `define MII_TX_C_LANE_25 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.c[3:0]
   
   `define TX_MII_I_CLK_50 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_clk_tx
   `define MII_TX_VALID_50 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_50 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_50_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_50_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_50_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_50_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].c[3:0]
   
   `define TX_MII_I_CLK_100 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_clk_tx
   `define MII_TX_VALID_100 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_100 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_100_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_100_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_100_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_100_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[1].c[3:0]
   `define MII_TX_DATA_LANE_100_2 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[2].d[31:0]
   `define MII_TX_C_LANE_100_2 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[2].c[3:0]
   `define MII_TX_DATA_LANE_100_3 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[3].d[31:0]
   `define MII_TX_C_LANE_100_3 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_100g_50g[0].u_gdr_ehip_100g_pcs.i_mac_mii[3].c[3:0]
   
   `define TX_MII_I_CLK_200 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_clk_tx
   `define MII_TX_VALID_200 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_200 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_200_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_200_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_200_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_200_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[1].c[3:0]
   `define MII_TX_DATA_LANE_200_2 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[2].d[31:0]
   `define MII_TX_C_LANE_200_2 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[2].c[3:0]
   `define MII_TX_DATA_LANE_200_3 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[3].d[31:0]
   `define MII_TX_C_LANE_200_3 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[3].c[3:0]
   `define MII_TX_DATA_LANE_200_4 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[4].d[31:0]
   `define MII_TX_C_LANE_200_4 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[4].c[3:0]
   `define MII_TX_DATA_LANE_200_5 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[5].d[31:0]
   `define MII_TX_C_LANE_200_5 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[5].c[3:0]
   `define MII_TX_DATA_LANE_200_6 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[6].d[31:0]
   `define MII_TX_C_LANE_200_6 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[6].c[3:0]
   `define MII_TX_DATA_LANE_200_7 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[7].d[31:0]
   `define MII_TX_C_LANE_200_7 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_200g[0].u_gdr_ehip_200g_pcs.i_mac_mii[7].c[3:0]
   
   `define TX_MII_I_CLK_400 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_clk_tx
   `define MII_TX_VALID_400 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID_400 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii_am_valid 
   `define MII_TX_DATA_LANE_400_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[0].d[31:0]
   `define MII_TX_C_LANE_400_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[0].c[3:0]
   `define MII_TX_DATA_LANE_400_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[1].d[31:0]
   `define MII_TX_C_LANE_400_1 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[1].c[3:0]
   `define MII_TX_DATA_LANE_400_2 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[2].d[31:0]
   `define MII_TX_C_LANE_400_2 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[2].c[3:0]
   `define MII_TX_DATA_LANE_400_3 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[3].d[31:0]
   `define MII_TX_C_LANE_400_3 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[3].c[3:0]
   `define MII_TX_DATA_LANE_400_4 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[4].d[31:0]
   `define MII_TX_C_LANE_400_4 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[4].c[3:0]
   `define MII_TX_DATA_LANE_400_5 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[5].d[31:0]
   `define MII_TX_C_LANE_400_5 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[5].c[3:0]
   `define MII_TX_DATA_LANE_400_6 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[6].d[31:0]
   `define MII_TX_C_LANE_400_6 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[6].c[3:0]
   `define MII_TX_DATA_LANE_400_7 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[7].d[31:0]
   `define MII_TX_C_LANE_400_7 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[7].c[3:0]
   `define MII_TX_DATA_LANE_400_8 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[8].d[31:0]
   `define MII_TX_C_LANE_400_8 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[8].c[3:0]
   `define MII_TX_DATA_LANE_400_9 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[9].d[31:0]
   `define MII_TX_C_LANE_400_9 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[9].c[3:0]
   `define MII_TX_DATA_LANE_400_10 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[10].d[31:0]
   `define MII_TX_C_LANE_400_10 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[10].c[3:0]
   `define MII_TX_DATA_LANE_400_11 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[11].d[31:0]
   `define MII_TX_C_LANE_400_11 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[11].c[3:0]
   `define MII_TX_DATA_LANE_400_12 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[12].d[31:0]
   `define MII_TX_C_LANE_400_12 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[12].c[3:0]
   `define MII_TX_DATA_LANE_400_13 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[13].d[31:0]
   `define MII_TX_C_LANE_400_13 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[13].c[3:0]
   `define MII_TX_DATA_LANE_400_14 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[14].d[31:0]
   `define MII_TX_C_LANE_400_14 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[14].c[3:0]
   `define MII_TX_DATA_LANE_400_15 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[15].d[31:0]
   `define MII_TX_C_LANE_400_15 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.u_gdr_ehip_400g_pcs.i_mac_mii[15].c[3:0]
   
   //`define MII_TX_DATA_LANE_3  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[255:192]
   //`define MII_TX_DATA_LANE_2  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[191:128]
   //`define MII_TX_DATA_LANE_1  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[127:64]
   //`define MII_TX_DATA_LANE_0  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_d[63:0]
   //`define MII_TX_C_LANE_3  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[31:24] 
   //`define MII_TX_C_LANE_2  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[23:16]
   //`define MII_TX_C_LANE_1  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[15:8]
   //`define MII_TX_C_LANE_0  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_c[7:0]
   `define MII_TX_DATA_LANE_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.d[31:0]
   `define MII_TX_C_LANE_0 dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii.c[3:0]
   //`define TX_MII_I_CLK         eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.clk
   `define TX_MII_I_CLK dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_clk_tx
   //`define EMPTY_BYTES_LANE_3   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[214:212] 
   //`define EMPTY_BYTES_LANE_2   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[144:142] 
   //`define EMPTY_BYTES_LANE_1   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[74:72] 
   //`define EMPTY_BYTES_LANE_0   eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[4:2] 
   //
   //`define SOP_TX_MAC_I_LANE_3  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[215]
   //`define SOP_TX_MAC_I_LANE_2  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[145]
   //`define SOP_TX_MAC_I_LANE_1  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[75]
   //`define SOP_TX_MAC_I_LANE_0  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.din[5]
   //`define MII_TX_VALID  eth_env_top.dut.top.alt_s100.alt_e100s10_mac.txm.tx_mii_valid
   //`define MII_TX_VALID dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0.tx_mac.mii_valid
   `define MII_TX_VALID dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.i_mac_mii_valid 
   `define MII_AM_VALID dut_top__tiles.z1577a_x0_y0_n0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar1.ehip_par_50g_0.genblk1.ehip_mac_50g_0.o_mii_am_valid
`endif

//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_am_valid    =   `MII_AM_VALID;
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.tx_mii_i_clk        =   `TX_MII_I_CLK          ;        
//DM TODO commenting for compile clean //assign eth_sideband_if.mii_tx_data_lane_3  =   `MII_TX_DATA_LANE_3   ; 
//DM TODO commenting for compile clean //assign eth_sideband_if.mii_tx_data_lane_2  =   `MII_TX_DATA_LANE_2   ; 
//DM TODO commenting for compile clean //assign eth_sideband_if.mii_tx_data_lane_1  =   `MII_TX_DATA_LANE_1   ; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_0  =   `MII_TX_DATA_LANE_0   ; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_valid        =   `MII_TX_VALID   ; 
//DM TODO commenting for compile clean 
//DM TODO commenting for compile clean //assign eth_sideband_if.mii_tx_c_lane_3 = `MII_TX_C_LANE_3;  
//DM TODO commenting for compile clean //assign eth_sideband_if.mii_tx_c_lane_2 = `MII_TX_C_LANE_2;  
//DM TODO commenting for compile clean //assign eth_sideband_if.mii_tx_c_lane_1 = `MII_TX_C_LANE_1;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_0 = `MII_TX_C_LANE_0;  
//DM TODO commenting for compile clean 
//DM TODO commenting for compile clean /////////////////////////////////////////////////////
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.tx_mii_i_clk_25g        = `TX_MII_I_CLK_25;        
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_valid_25g        = `MII_TX_VALID_25; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_am_valid_25g        = `MII_AM_VALID_25; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_25g    = `MII_TX_DATA_LANE_25; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_25g       = `MII_TX_C_LANE_25;  
//DM TODO commenting for compile clean 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.tx_mii_i_clk_50g           = `TX_MII_I_CLK_50;        
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_valid_50g           = `MII_TX_VALID_50; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_50g[0]    = `MII_TX_DATA_LANE_50_0; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_50g[0]       = `MII_TX_C_LANE_50_0;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_50g[1]    = `MII_TX_DATA_LANE_50_1; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_50g[1]       = `MII_TX_C_LANE_50_1;  
//DM TODO commenting for compile clean 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.tx_mii_i_clk_100g           = `TX_MII_I_CLK_100;        
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_valid_100g           = `MII_TX_VALID_100; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_am_valid_100g           = `MII_AM_VALID_100; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_100g[0]    = `MII_TX_DATA_LANE_100_0; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_100g[0]       = `MII_TX_C_LANE_100_0;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_100g[1]    = `MII_TX_DATA_LANE_100_1; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_100g[1]       = `MII_TX_C_LANE_100_1;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_100g[2]    = `MII_TX_DATA_LANE_100_2; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_100g[2]       = `MII_TX_C_LANE_100_2;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_100g[3]    = `MII_TX_DATA_LANE_100_3; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_100g[3]       = `MII_TX_C_LANE_100_3;  
//DM TODO commenting for compile clean 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.tx_mii_i_clk_200g           = `TX_MII_I_CLK_200;        
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_valid_200g           = `MII_TX_VALID_200; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_am_valid_200g           = `MII_AM_VALID_200; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[0]    = `MII_TX_DATA_LANE_200_0; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[0]       = `MII_TX_C_LANE_200_0;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[1]    = `MII_TX_DATA_LANE_200_1; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[1]       = `MII_TX_C_LANE_200_1;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[2]    = `MII_TX_DATA_LANE_200_2; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[2]       = `MII_TX_C_LANE_200_2;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[3]    = `MII_TX_DATA_LANE_200_3; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[3]       = `MII_TX_C_LANE_200_3;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[4]    = `MII_TX_DATA_LANE_200_4; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[4]       = `MII_TX_C_LANE_200_4;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[5]    = `MII_TX_DATA_LANE_200_5; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[5]       = `MII_TX_C_LANE_200_5;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[6]    = `MII_TX_DATA_LANE_200_6; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[6]       = `MII_TX_C_LANE_200_6;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_200g[7]    = `MII_TX_DATA_LANE_200_7; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_200g[7]       = `MII_TX_C_LANE_200_7;  
//DM TODO commenting for compile clean 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.tx_mii_i_clk_400g           = `TX_MII_I_CLK_400;        
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_valid_400g           = `MII_TX_VALID_400; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_am_valid_400g           = `MII_AM_VALID_400; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[0]    = `MII_TX_DATA_LANE_400_0; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[0]       = `MII_TX_C_LANE_400_0;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[1]    = `MII_TX_DATA_LANE_400_1; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[1]       = `MII_TX_C_LANE_400_1;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[2]    = `MII_TX_DATA_LANE_400_2; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[2]       = `MII_TX_C_LANE_400_2;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[3]    = `MII_TX_DATA_LANE_400_3; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[3]       = `MII_TX_C_LANE_400_3;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[4]    = `MII_TX_DATA_LANE_400_4; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[4]       = `MII_TX_C_LANE_400_4;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[5]    = `MII_TX_DATA_LANE_400_5; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[5]       = `MII_TX_C_LANE_400_5;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[6]    = `MII_TX_DATA_LANE_400_6; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[6]       = `MII_TX_C_LANE_400_6;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[7]    = `MII_TX_DATA_LANE_400_7; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[7]       = `MII_TX_C_LANE_400_7; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[8]    = `MII_TX_DATA_LANE_400_8; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[8]       = `MII_TX_C_LANE_400_8;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[9]    = `MII_TX_DATA_LANE_400_9; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[9]       = `MII_TX_C_LANE_400_9;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[10]    = `MII_TX_DATA_LANE_400_10; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[10]       = `MII_TX_C_LANE_400_10;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[11]    = `MII_TX_DATA_LANE_400_11; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[11]       = `MII_TX_C_LANE_400_11;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[12]    = `MII_TX_DATA_LANE_400_12; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[12]       = `MII_TX_C_LANE_400_12;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[13]    = `MII_TX_DATA_LANE_400_13; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[13]       = `MII_TX_C_LANE_400_13;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[14]    = `MII_TX_DATA_LANE_400_14; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[14]       = `MII_TX_C_LANE_400_14;  
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_data_lane_400g[15]    = `MII_TX_DATA_LANE_400_15; 
//DM TODO commenting for compile clean assign eth_sideband_if_ip0.mii_tx_c_lane_400g[15]       = `MII_TX_C_LANE_400_15;  
////////////////////////////////////////////////////
