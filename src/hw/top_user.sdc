
#Temporary Constraint file added WW04.4

#Below user constraints as sugested by MRPHY IP team-WW08-HSD:https://hsdes.intel.com/appstore/article/#/14021451403
#2.5G - 3.2ns
##set exclusive clock groups
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|iopll_tx_outclk0"] 
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|iopll_tx_outclk2"] 
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|iopll_tx_outclk3"]

set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|iopll_tx_outclk0"] 
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|iopll_tx_outclk2"] 
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|iopll_tx_outclk3"]

set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|iopll_tx_outclk0"] 
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|iopll_tx_outclk2"] 
set_clock_groups -logically_exclusive -group [get_clocks "soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|iopll_tx_outclk3"]

set_clock_groups -logically_exclusive -group MAIN_CLOCK    

set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_0|iopll_tx_outclk2}] 
set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_0|iopll_tx_outclk3}] 
set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_0|iopll_tx_outclk0}]

set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_1|iopll_tx_outclk2}] 
set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_1|iopll_tx_outclk3}] 
set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_1|iopll_tx_outclk0}]

set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_2|iopll_tx_outclk2}] 
set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_2|iopll_tx_outclk3}] 
set_clock_groups -logically_exclusive -group [get_clocks {gmii8b_tx_clkin}] -group [get_clocks {intel_mge_phy_2|iopll_tx_outclk0}]

# recovery violations - Still need confirmation from IP/DL team
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|alt_mge_xcvr_directphy|o_tx_clkout2[0]}
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|alt_mge_xcvr_directphy|o_rx_clkout[0]}
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_0|intel_mge_phy_0|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|iopll_0|iopll_0_outclk1}

set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|alt_mge_xcvr_directphy|o_tx_clkout2[0]}
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|alt_mge_xcvr_directphy|o_rx_clkout[0]}
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_1|intel_mge_phy_1|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|iopll_0|iopll_0_outclk1}

set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|alt_mge_xcvr_directphy|o_tx_clkout2[0]}
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|alt_mge_xcvr_directphy|o_rx_clkout[0]}
set_clock_groups -asynchronous -group {soc_inst|subsys_tsn|intel_mge_phy_2|intel_mge_phy_2|alt_mge_xcvr_directphy_src_divided_osc_clk[0]} -group {soc_inst|subsys_tsn|iopll_0|iopll_0_outclk1}

set_clock_groups -asynchronous -group {MAIN_CLOCK} -group {soc_inst|subsys_tsn|iopll_0|iopll_0_outclk1}

#DRC constraint
#set_false_path -from [get_registers {rst_ctrl_inst|syncr_system_reset_sys_clk|dreg*}] -to [get_registers {rst_ctrl_inst|syncr_system_reset_sys_clk|din_s1}]