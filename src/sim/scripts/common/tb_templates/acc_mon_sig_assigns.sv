`define gdr_acc_mon_assign(NODE=0,MACPAR=0,INST=50g_0,GENBLK=1,SUBBLK=0) \
assign spy_if_ip0.tx_word_align[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.o_word_align_txpcs;\
assign spy_if_ip0.tx_mii_d[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.o_mii[0].d[63:0];\
assign spy_if_ip0.tx_mii_c[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.o_mii[0].c[7:0]; \
assign spy_if_ip0.tx_mii_valid[``NODE``]  = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.o_mii_valid; \
assign spy_if_ip0.tx_am_valid[``NODE``]   = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.o_mii_am_valid; \
assign spy_if_ip0.tx_mii_clk[``NODE``]    = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.i_clk; \
assign spy_if_ip0.rx_word_align[``NODE``]    = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.i_pcs_word_align; \
assign spy_if_ip0.rx_mii_clk[``NODE``]    = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.i_clk; \
assign spy_if_ip0.rx_mii_d[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.hw_mii_d[63:0];\
assign spy_if_ip0.rx_mii_c[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.hw_mii_c[7:0]; \
assign spy_if_ip0.rx_mii_valid[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.i_pcs_valid; \
assign spy_if_ip0.rx_am_valid[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.i_pcs_am_valid; \
assign spy_if_ip0.tx_load_data_valid[``NODE``]= `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.tam.o_load_data_valid[0]; \
assign spy_if_ip0.rx_load_data_valid[``NODE``]= `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.tam.o_load_data_valid[0]; \
assign spy_if_ip0.tx_tam_adj_load_data_valid[``NODE``]= `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.tam_adj.o_load_data_valid[0]; \
assign spy_if_ip0.rx_tam_adj_load_data_valid[``NODE``]= `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.tam_adj.o_load_data_valid[0]; \
assign spy_if_ip0.tx_load_data[``NODE``]      = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.tam.o_load_data[0]; \
assign spy_if_ip0.rx_load_data[``NODE``]      = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.tam.o_load_data[0]; \
assign spy_if_ip0.tx_tam_adj_load_data[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.tx_mac.ptp_tx.tam_adj.o_load_data[0]; \
assign spy_if_ip0.rx_tam_adj_load_data[``NODE``] = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_mac.gdr_ehip_mac.gdr_e4hip_macpar``MACPAR``.ehip_par_``INST``.genblk``GENBLK``.ehip_mac_``SUBBLK``.rx_mac.ptp_rx.tam_adj.o_load_data[0]; 

`gdr_acc_mon_assign(30,1,50g_1,8,50g_7)
`gdr_acc_mon_assign(29,1,50g_0,8,50g_7)
`gdr_acc_mon_assign(28,1,50g_1,7,50g_6)
`gdr_acc_mon_assign(27,1,50g_0,7,50g_6)
`gdr_acc_mon_assign(26,1,50g_1,6,50g_5)
`gdr_acc_mon_assign(25,1,50g_0,6,50g_5)
`gdr_acc_mon_assign(24,1,50g_1,5,50g_4)
`gdr_acc_mon_assign(23,1,50g_0,5,50g_4)
`gdr_acc_mon_assign(22,1,50g_1,4,50g_3)
`gdr_acc_mon_assign(21,1,50g_0,4,50g_3)
`gdr_acc_mon_assign(20,1,50g_1,3,50g_2)
`gdr_acc_mon_assign(19,1,50g_0,3,50g_2)
`gdr_acc_mon_assign(18,1,50g_1,2,50g_1)
`gdr_acc_mon_assign(17,1,50g_0,2,50g_1)
`gdr_acc_mon_assign(16,1,50g_1,1,50g_0)
`gdr_acc_mon_assign(15,1,50g_0,1,50g_0)
`gdr_acc_mon_assign(14,1,50g_0,8,50g_7)

`gdr_acc_mon_assign(13,1,50g_0,7,50g_6)
`gdr_acc_mon_assign(12,1,50g_1,6,50g_5)
`gdr_acc_mon_assign(11,1,50g_0,5,50g_4)
`gdr_acc_mon_assign(10,1,50g_1,4,50g_3)
`gdr_acc_mon_assign(9,1,50g_0,3,50g_2)
`gdr_acc_mon_assign(8,1,50g_0,2,50g_1)
`gdr_acc_mon_assign(7,1,50g_0,1,50g_0)

`gdr_acc_mon_assign(6,0,200g_1,2,200g_1)
`gdr_acc_mon_assign(5,0,200g_0,2,200g_1)
`gdr_acc_mon_assign(4,0,200g_1,1,200g_0)
`gdr_acc_mon_assign(3,0,200g_0,1,200g_0)
`gdr_acc_mon_assign(2,0,200g_0,2,200g_1)
`gdr_acc_mon_assign(1,0,200g_0,1,200g_0)

`gdr_acc_mon_assign(0,0,400g_0,1,400g_0)

//assign spy_if_ip0.i_tx_ptp_sync_am     = eth_env_top.dut.ip0.eth_f_0.sip_inst.PTP_SOFT_GEN.soft_ptp.i_tx_ptp_sync_am;
//assign spy_if_ip0.i_tx_ptp_async_pulse = eth_env_top.dut.ip0.eth_f_0.sip_inst.i_tx_ptp_async_pulse[0:0];
//assign spy_if_ip0.i_rx_ptp_sync_am     = eth_env_top.dut.ip0.eth_f_0.sip_inst.PTP_SOFT_GEN.soft_ptp.i_rx_ptp_sync_am; 
//assign spy_if_ip0.i_rx_ptp_async_pulse = eth_env_top.dut.ip0.eth_f_0.sip_inst.i_rx_ptp_async_pulse[0:0];

assign spy_if_ip0.i_tx_ptp_sync_am     = eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.i_tx_ptp_sync_am;
assign spy_if_ip0.i_tx_ptp_async_pulse = eth_env_top.dut.ip0.top_ip0.sip_inst.i_tx_ptp_async_pulse[0:0];
assign spy_if_ip0.i_rx_ptp_sync_am     = eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.i_rx_ptp_sync_am; 
assign spy_if_ip0.i_rx_ptp_async_pulse = eth_env_top.dut.ip0.top_ip0.sip_inst.i_rx_ptp_async_pulse[0:0];
