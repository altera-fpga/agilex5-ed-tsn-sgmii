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


(* icm_name="sm_flux_rx_demux", module_type="decoder", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_flux_rx_demux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_PCIE_PCS, SEL_XCVRIF, SEL_UNUSED */
    )
    (
        input [39:0] i_rx_data,
        output [39:0] o_pcie_pcs,
        output [31:0] o_xcvrif
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_flux_rx_demux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_flux_rx_demux (
        .i_rx_data(i_rx_data),
        .o_pcie_pcs(o_pcie_pcs),
        .o_xcvrif(o_xcvrif)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_PCIE_PCS" == sel ) begin : sel_is_PCIE_PCS
            assign o_pcie_pcs = i_rx_data;
        end : sel_is_PCIE_PCS
        if ( "SEL_XCVRIF" == sel ) begin : sel_is_XCVRIF
            assign o_xcvrif = i_rx_data[31:0];
	    assign o_pcie_pcs = 1'b0;
        end : sel_is_XCVRIF
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_flux_rx_demux

(* icm_name="sm_flux_rx_rxword_clk_demux", module_type="decoder", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_flux_rx_rxword_clk_demux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_ETH_RXWORD_CLK, SEL_PCIE_RXWORD_CLK, SEL_UNUSED */
    )
    (
        input i_ock_pcs_rxword,
        output o_eth_rxword_clk,
        output o_pcie_rxword_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_flux_rx_rxword_clk_demux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_flux_rx_rxword_clk_demux (
        .i_ock_pcs_rxword(i_ock_pcs_rxword),
        .o_eth_rxword_clk(o_eth_rxword_clk),
        .o_pcie_rxword_clk(o_pcie_rxword_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_ETH_RXWORD_CLK" == sel ) begin : sel_is_ETH_RXWORD_CLK
            assign o_eth_rxword_clk = i_ock_pcs_rxword;
	    assign o_pcie_rxword_clk = 1'b0;
        end : sel_is_ETH_RXWORD_CLK
        if ( "SEL_PCIE_RXWORD_CLK" == sel ) begin : sel_is_PCIE_RXWORD_CLK
            assign o_pcie_rxword_clk = i_ock_pcs_rxword;
        end : sel_is_PCIE_RXWORD_CLK
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_flux_rx_rxword_clk_demux

(* icm_name="sm_flux_tx_txword_clk_demux", module_type="decoder", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_flux_tx_txword_clk_demux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_ETH_TXWORD_CLK, SEL_PCIE_TXWORD_CLK, SEL_UNUSED */
    )
    (
        input i_ock_pcs_txword,
        output o_eth_txword_clk,
        output o_pcie_txword_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_flux_tx_txword_clk_demux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_flux_tx_txword_clk_demux (
        .i_ock_pcs_txword(i_ock_pcs_txword),
        .o_eth_txword_clk(o_eth_txword_clk),
        .o_pcie_txword_clk(o_pcie_txword_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_ETH_TXWORD_CLK" == sel ) begin : sel_is_ETH_TXWORD_CLK
            assign o_eth_txword_clk = i_ock_pcs_txword;
	    assign o_pcie_txword_clk = 1'b0;
        end : sel_is_ETH_TXWORD_CLK
        if ( "SEL_PCIE_TXWORD_CLK" == sel ) begin : sel_is_PCIE_TXWORD_CLK
            assign o_pcie_txword_clk = i_ock_pcs_txword;
	    assign o_eth_txword_clk = 1'b0;
        end : sel_is_PCIE_TXWORD_CLK
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_flux_tx_txword_clk_demux

(* icm_name="sm_flux_tx_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_flux_tx_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_PCIE_PCS, SEL_XCVRIF, SEL_UNUSED */
    )
    (
        input [39:0] i_pcie_pcs,
        input [31:0] i_xcvrif,
        output [39:0] o_tx_data
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_flux_tx_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_flux_tx_mux (
        .i_pcie_pcs(i_pcie_pcs),
        .i_xcvrif(i_xcvrif),
        .o_tx_data(o_tx_data)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_PCIE_PCS" == sel ) begin : sel_is_PCIE_PCS
            assign o_tx_data = i_pcie_pcs;
        end : sel_is_PCIE_PCS
        if ( "SEL_XCVRIF" == sel ) begin : sel_is_XCVRIF
            assign o_tx_data = {8'b0, i_xcvrif};
        end : sel_is_XCVRIF
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_flux_tx_mux

(* icm_name="sm_flux_tx_txword_clk_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_flux_tx_txword_clk_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_XCVR_TXWORD_CLK, SEL_UX_OCK_PMA_CLK, SEL_UNUSED */
    )
    (
        input i_ux_ock_pma_clk,
        input i_xcvr_txword_clk,
        output o_pcs_txword
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_flux_tx_txword_clk_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_flux_tx_txword_clk_mux (
        .i_ux_ock_pma_clk(i_ux_ock_pma_clk),
        .i_xcvr_txword_clk(i_xcvr_txword_clk),
        .o_pcs_txword(o_pcs_txword)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_XCVR_TXWORD_CLK" == sel ) begin : sel_is_XCVR_TXWORD_CLK
            assign o_pcs_txword = i_xcvr_txword_clk;
        end : sel_is_XCVR_TXWORD_CLK
        if ( "SEL_UX_OCK_PMA_CLK" == sel ) begin : sel_is_UX_OCK_PMA_CLK
            assign o_pcs_txword = i_ux_ock_pma_clk;
        end : sel_is_UX_OCK_PMA_CLK
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_flux_tx_txword_clk_mux

(* icm_name="sm_xcvrif_rx_ch_clk_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_xcvrif_rx_ch_clk_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_RXWORD_CLK, SEL_SYS_CLK, SEL_UNUSED */
    )
    (
        input i_ground_clk,
        input i_rxword_clk,
        input i_sys_clk,
        output o_eth_rx_ch_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_xcvrif_rx_ch_clk_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_xcvrif_rx_ch_clk_mux (
        .i_ground_clk(i_ground_clk),
        .i_rxword_clk(i_rxword_clk),
        .i_sys_clk(i_sys_clk),
        .o_eth_rx_ch_clk(o_eth_rx_ch_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_RXWORD_CLK" == sel ) begin : sel_is_RXWORD_CLK
            assign o_eth_rx_ch_clk = i_rxword_clk;
        end : sel_is_RXWORD_CLK
        if ( "SEL_SYS_CLK" == sel ) begin : sel_is_SYS_CLK
            assign o_eth_rx_ch_clk = i_sys_clk;
        end : sel_is_SYS_CLK
        if ( "SEL_UNUSED" == sel ) begin : sel_is_UNUSED
            assign o_eth_rx_ch_clk = i_ground_clk;
        end : sel_is_UNUSED
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_xcvrif_rx_ch_clk_mux

(* icm_name="sm_xcvrif_tx_ch_clk_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_xcvrif_tx_ch_clk_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_TXWORD_CLK, SEL_SYS_CLK, SEL_UNUSED */
    )
    (
        input i_ground_clk,
        input i_sys_clk,
        input i_txword_clk,
        output o_eth_tx_ch_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_xcvrif_tx_ch_clk_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_xcvrif_tx_ch_clk_mux (
        .i_ground_clk(i_ground_clk),
        .i_sys_clk(i_sys_clk),
        .i_txword_clk(i_txword_clk),
        .o_eth_tx_ch_clk(o_eth_tx_ch_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_TXWORD_CLK" == sel ) begin : sel_is_TXWORD_CLK
            assign o_eth_tx_ch_clk = i_txword_clk;
        end : sel_is_TXWORD_CLK
        if ( "SEL_SYS_CLK" == sel ) begin : sel_is_SYS_CLK
            assign o_eth_tx_ch_clk = i_sys_clk;
        end : sel_is_SYS_CLK
        if ( "SEL_UNUSED" == sel ) begin : sel_is_UNUSED
            assign o_eth_tx_ch_clk = i_ground_clk;
        end : sel_is_UNUSED
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_xcvrif_tx_ch_clk_mux

(* icm_name="sm_flux_dpma_clk_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_flux_dpma_clk_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_LOCAL_SYSPLL_C2_CLK, SEL_GLOBAL_DOWNWARD_SYSPLL_C2_CLK, SEL_GLOBAL_UPWARD_SYSPLL_C2_CLK, SEL_CNOC_CLK, SEL_UNUSED */
    )
    (
        input i_cnoc_clk,
        input i_global_downward_syspll_c2_clk,
        input i_global_upward_syspll_c2_clk,
        input i_local_syspll_c2_clk,
        output o_ux_dpma_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_flux_dpma_clk_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_flux_dpma_clk_mux (
        .i_cnoc_clk(i_cnoc_clk),
        .i_global_downward_syspll_c2_clk(i_global_downward_syspll_c2_clk),
        .i_global_upward_syspll_c2_clk(i_global_upward_syspll_c2_clk),
        .i_local_syspll_c2_clk(i_local_syspll_c2_clk),
        .o_ux_dpma_clk(o_ux_dpma_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_LOCAL_SYSPLL_C2_CLK" == sel ) begin : sel_is_LOCAL_SYSPLL_C2_CLK
            assign o_ux_dpma_clk = i_local_syspll_c2_clk;
        end : sel_is_LOCAL_SYSPLL_C2_CLK
        if ( "SEL_GLOBAL_DOWNWARD_SYSPLL_C2_CLK" == sel ) begin : sel_is_GLOBAL_DOWNWARD_SYSPLL_C2_CLK
            assign o_ux_dpma_clk = i_global_downward_syspll_c2_clk;
        end : sel_is_GLOBAL_DOWNWARD_SYSPLL_C2_CLK
        if ( "SEL_GLOBAL_UPWARD_SYSPLL_C2_CLK" == sel ) begin : sel_is_GLOBAL_UPWARD_SYSPLL_C2_CLK
            assign o_ux_dpma_clk = i_global_upward_syspll_c2_clk;
        end : sel_is_GLOBAL_UPWARD_SYSPLL_C2_CLK
        if ( "SEL_CNOC_CLK" == sel ) begin : sel_is_CNOC_CLK
            assign o_ux_dpma_clk = i_cnoc_clk;
        end : sel_is_CNOC_CLK
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_flux_dpma_clk_mux

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "jdaUczDmknd1j2HuPjy2WibKQVNvjDAujm2msitPRQoSFM04DSnFOv0NrtpdX9wrEXFRSeF81hifny2PNSYSx2xbOYWohtJE59kvSVpRk/5J+3xhF/pnYEmSr+fA5rANOS6fNQCkK4f0YSNgBEN5vciEqUoettmRJ9wpaoO4wE8Lj97m69uhnOhz9+QnQN0/xq50SaYZiq9mlvbuEQSq5FYqTlYbfMHbID9Wx8jVEPNzCI1DDgNtT+v/8fLX9NA479otpw+AATIX2OUItvWxWiPK36DpQJRUt3Cngzo7+NMTnPbCTRziwAxrHBy1toHy/8aNnO7jq8vSAFcd9REpetMQm5YNLq7F/tv7k8RVDjNDp/JeKlndm4YJduxbPAXGUSsA/eECWSEmRsvFvVVYWaSUFU+vprmF9fSo3hZeGs3Y7D+1T3ilnvtnuKvO8anuwv2ljzmUtvc6nA8DAUZgbMjZaMlaEejKwgBvrX1MHkns5x7RMJgUXzwvVNCPwmcNGDBMgTqrmoUxiDuOZ+Dwl07mW2aIlquvIeRItRwmnvx79Rp5JaFQKNLf6OvwuZD4+T3aZ02+h22ncnt1VjJarsRjzVxENgzvy0AWdUIYssIf7GWmalAeDV9ty+utCf/lrcNcvDpal2e87aghlJmcWovFjqJuk7ob+kv7oaikQEO37dnwCiqWe4UmuFcO+b4e4HDAATRv05xN+YmEYmBXsJ+gaMy07yZ7HdB8LkEgGV1k4NDvMd/SQHxu/OBjeLJArSwvkUmBUnEf3R0K4vMTo1nIPjYGp0Bp9JRdCx3mdUrB2GOxToCrkRyB8bcSnwsYZOxFxvTJtI4fflyJz6DZkiZrGNvMHQaYBaIoUNKxhw+pV/qKorybY4X2lmEE6Y2hrR8EuG4u9/Kr/X0Jdn9leWRvDN1+7lyZTN7OFQCieEzbn+oOfOCIcjr5Vzr6cZw+F6//VasrJO25ylKUxnczUUbm3UgsQISD7DW0SuKKiauNxMwSvnt1xTll8UEHmvfJ"
`endif
