if {0} {
   unset phy_ip_params
}

set phy_ip_params [dict create]

dict set phy_ip_params profile_cnt "1"
set ::global_corename alt_mge_phy_0_intel_directphy_gts_200_twelxbq
# -------------------------------- #
# --- Default Profile settings --- #
# -------------------------------- #
dict set phy_ip_params xcvr_type_profile0 "FGT"
dict set phy_ip_params num_sys_cop_profile0 "1"
dict set phy_ip_params pma_data_rate_profile0 "3125"
dict set phy_ip_params pma_width_profile0 "20"
dict set phy_ip_params clocking_mode_profile0 "syspll"
dict set phy_ip_params duplex_mode_profile0 "duplex"
dict set phy_ip_params pma_outclk_freq_mhz_profile0 "156.25"
dict set phy_ip_params syspll_outclk_freq_mhz_profile0 "322.265625"
dict set phy_ip_params tx_pll_txuserclk_div_profile0 "100"
dict set phy_ip_params tx_pll_txuserclk1_enable_profile0 "1"
dict set phy_ip_params tx_pll_txuserclk2_enable_profile0 "0"
dict set phy_ip_params rx_cdr_rxuserclk_div_profile0 "40"
dict set phy_ip_params rx_cdr_rxuserclk_enable_profile0 "1"
dict set phy_ip_params pldif_rx_clkout_freq_mhz_profile0 "156.25"
dict set phy_ip_params pldif_rx_clkout2_freq_mhz_profile0 "312.5"
dict set phy_ip_params pldif_tx_clkout_freq_mhz_profile0 "161.132812"
dict set phy_ip_params pldif_tx_clkout2_freq_mhz_profile0 "156.25"
dict set phy_ip_params pldif_tx_clkout2_sel_profile0 "TX_WORD_CLK"
dict set phy_ip_params pldif_rx_clkout2_sel_profile0 "RX_USER_CLK1"
