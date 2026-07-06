`define dbg_reg_sig(NODE=0,MACPAR=0,INST=50g_0,GENBLK=1,SUBBLK=0) \
assign spy_if_ip0.rx_o_tam_dbg[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.its.o_tam_dbg; \
assign spy_if_ip0.rx_o_load_data_valid[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.tam.o_load_data_valid; \
assign spy_if_ip0.rx_o_tam_adj_dbg[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.its.o_tam_adj_dbg; \
assign spy_if_ip0.rx_o_ts_ss[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.its.o_ts_ss; \
assign spy_if_ip0.rx_o_vl_ss[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.its.o_vl_ss; \
assign spy_if_ip0.tx_o_tam_dbg[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.ets.o_tam_dbg; \
assign spy_if_ip0.tx_o_load_data_valid[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.tam.o_load_data_valid; \
assign spy_if_ip0.tx_o_tam_adj_dbg[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.ets.o_tam_adj_dbg; \
assign spy_if_ip0.tx_o_ts_ss[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.ets.o_ts_ss; \
assign spy_if_ip0.tx_o_vl_ss[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.ets.o_vl_ss; \
assign spy_if_ip0.rx_mac_mii_clk[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.i_clk; \
assign spy_if_ip0.tx_mac_clk[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.i_clk; \
assign spy_if_ip0.remote_fault[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.remote_fault; \
assign spy_if_ip0.local_fault[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.local_fault; \
assign spy_if_ip0.wb_tx_ets_valid[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.ets.o_egr_ts_valid; \
assign spy_if_ip0.wb_tx_ets_vl[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.ets.o_vl[4:0]; \
assign spy_if_ip0.wb_rx_its_valid[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.its.o_ing_ts_valid; \
assign spy_if_ip0.wb_rx_its_vl[``NODE``]=`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.its.o_vl[4:0]; \
assign  spy_if_ip0.fault[``NODE``]=spy_if_ip0.local_fault[``NODE``] | spy_if_ip0.remote_fault[``NODE``]; 
assign spy_if_ip0.soft_tx_rst=eth_env_top.dut.ip0.top_ip0.sip_inst.tx_dp_rst;
assign spy_if_ip0.soft_rx_rst=eth_env_top.dut.ip0.top_ip0.sip_inst.rx_dp_rst;

assign spy_if_ip0.ptp_tx_state[2:0]=eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.tx_state[2:0];
assign spy_if_ip0.ptp_rx_state[2:0]=eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.rx_state[2:0];

`dbg_reg_sig(30,1,50g_1,8,50g_7)
`dbg_reg_sig(29,1,50g_0,8,50g_7)
`dbg_reg_sig(28,1,50g_1,7,50g_6)
`dbg_reg_sig(27,1,50g_0,7,50g_6)
`dbg_reg_sig(26,1,50g_1,6,50g_5)
`dbg_reg_sig(25,1,50g_0,6,50g_5)
`dbg_reg_sig(24,1,50g_1,5,50g_4)
`dbg_reg_sig(23,1,50g_0,5,50g_4)
`dbg_reg_sig(22,1,50g_1,4,50g_3)
`dbg_reg_sig(21,1,50g_0,4,50g_3)
`dbg_reg_sig(20,1,50g_1,3,50g_2)
`dbg_reg_sig(19,1,50g_0,3,50g_2)
`dbg_reg_sig(18,1,50g_1,2,50g_1)
`dbg_reg_sig(17,1,50g_0,2,50g_1)
`dbg_reg_sig(16,1,50g_1,1,50g_0)
`dbg_reg_sig(15,1,50g_0,1,50g_0)
`dbg_reg_sig(14,1,50g_0,8,50g_7)

`dbg_reg_sig(13,1,50g_0,7,50g_6)
`dbg_reg_sig(12,1,50g_1,6,50g_5)
`dbg_reg_sig(11,1,50g_0,5,50g_4)
`dbg_reg_sig(10,1,50g_1,4,50g_3)
`dbg_reg_sig(9,1,50g_0,3,50g_2)
`dbg_reg_sig(8,1,50g_0,2,50g_1)
`dbg_reg_sig(7,1,50g_0,1,50g_0)

`dbg_reg_sig(6,0,200g_1,2,200g_1)
`dbg_reg_sig(5,0,200g_0,2,200g_1)
`dbg_reg_sig(4,0,200g_1,1,200g_0)
`dbg_reg_sig(3,0,200g_0,1,200g_0)
`dbg_reg_sig(2,0,200g_0,2,200g_1)
`dbg_reg_sig(1,0,200g_0,1,200g_0)

`dbg_reg_sig(0,0,400g_0,1,400g_0) 
