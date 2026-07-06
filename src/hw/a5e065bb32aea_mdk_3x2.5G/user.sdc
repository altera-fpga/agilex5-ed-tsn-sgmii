
#Temporary Constraint file added WW04.4

#Below user constraints as sugested by MRPHY IP team-WW08-HSD:https://hsdes.intel.com/appstore/article/#/14021451403
#2.5G - 3.2ns

#set exclusive clock groups
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_outclk0"] 
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_outclk2"] 
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_iopll_tx_outclk3"]

set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_outclk0"] 
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_outclk2"] 
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_iopll_tx_outclk3"]

set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_outclk0"] 
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_outclk2"] 
set_clock_groups -logically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_iopll_tx_outclk3"]

set_clock_groups -physically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_tx_user_clk1_ref[0]"]
set_clock_groups -physically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_tx_user_clk1_ref[0]"]
set_clock_groups -physically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof0_tx_user_clk1_ref[0]"]

set_clock_groups -physically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_0_period_intel_mge_phy_0_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof1_tx_user_clk1_ref[0]"]
set_clock_groups -physically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_1_period_intel_mge_phy_1_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof1_tx_user_clk1_ref[0]"]
set_clock_groups -physically_exclusive -group [get_clocks "dr_wrap_inst|mr_top_inst|mrphy_2_period_intel_mge_phy_2_period_alt_mge_xcvr_directphy_period_U_base_profile0_period_sip_inst|prof1_tx_user_clk1_ref[0]"]


set_clock_groups -logically_exclusive -group MAIN_CLOCK    

set_clock_groups -asynchronous -group {MAIN_CLOCK} -group {soc_inst|fabric|iopll_0|iopll_0_outclk1}

#DRC constraints
set_false_path -to [get_pins {rst_ctrl_inst|syncr_h2f_reset_sys_clk|*|clrn}]
set_false_path -to [get_pins {rst_ctrl_inst|[*].syncr_mac_rx_rst_sys_clk|*|clrn}]
set_false_path -to [get_pins {rst_ctrl_inst|[*].syncr_mac_tx_rst_sys_clk|*|clrn}]


