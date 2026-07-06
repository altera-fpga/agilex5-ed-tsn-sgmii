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



(* icm_name="sm_pld_rx_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_pld_rx_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_PCIE, SEL_PCIE_BOND, SEL_ETH, SEL_UNUSED */
    )
    (
        input [39:0] i_eth,
        input [79:0] i_pcie,
        input [79:0] i_pcie_bond,
        output [79:0] o_rx_data
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_pld_rx_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_pld_rx_mux (
        .i_eth(i_eth),
        .i_pcie(i_pcie),
        .i_pcie_bond(i_pcie_bond),
        .o_rx_data(o_rx_data)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_PCIE" == sel ) begin : sel_is_PCIE
            assign o_rx_data = i_pcie;
        end : sel_is_PCIE
        if ( "SEL_PCIE_BOND" == sel ) begin : sel_is_PCIE_BOND
            assign o_rx_data = i_pcie_bond;
        end : sel_is_PCIE_BOND
        if ( "SEL_ETH" == sel ) begin : sel_is_ETH
            assign o_rx_data = {40'b0, i_eth};
        end : sel_is_ETH
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_pld_rx_mux

(* icm_name="sm_pld_tx_demux", module_type="decoder", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_pld_tx_demux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_PCIE, SEL_PCIE_BOND, SEL_ETH, SEL_UNUSED */
    )
    (
        input i_ss_tx_fifo_rd_empty,
        input i_ss_tx_fifo_rd_pempty,
        input [79:0] i_tx_data,
        output [39:0] o_eth,
        output [79:0] o_pcie,
        output [79:0] o_pcie_bond,
        output o_ss_tx_fifo_rd_en
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_pld_tx_demux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_pld_tx_demux (
        .i_ss_tx_fifo_rd_empty(i_ss_tx_fifo_rd_empty),
        .i_ss_tx_fifo_rd_pempty(i_ss_tx_fifo_rd_pempty),
        .i_tx_data(i_tx_data),
        .o_eth(o_eth),
        .o_pcie(o_pcie),
        .o_pcie_bond(o_pcie_bond),
        .o_ss_tx_fifo_rd_en(o_ss_tx_fifo_rd_en)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_PCIE" == sel ) begin : sel_is_PCIE
            assign o_pcie = i_tx_data;
            assign o_eth = 40'b0;
            assign o_pcie_bond = 80'b0;
        end : sel_is_PCIE
        if ( "SEL_PCIE_BOND" == sel ) begin : sel_is_PCIE_BOND
            assign o_pcie = /* REVIEW */ 80'b0;
            assign o_eth = /* REVIEW */ 40'b0;
            assign o_pcie_bond = /* REVIEW */ 80'b0;
        end : sel_is_PCIE_BOND
        if ( "SEL_ETH" == sel ) begin : sel_is_ETH
            assign o_pcie = 80'b0;
            assign o_eth = i_tx_data[39:0];
            assign o_pcie_bond = 80'b0;
        end : sel_is_ETH
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_pld_tx_demux

(* icm_name="sm_hssi_pld_chnl_rx_fifo_wr_clk_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_ETH_OR_PTP, SEL_PCIE, SEL_PCIE_TOP, SEL_UNUSED */
    )
    (
        input i_eth_or_ptp,
        input i_pcie,
        input i_pcie_top,
        output o_rxfifo_ss_write_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_hssi_pld_chnl_rx_fifo_wr_clk_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux (
        .i_eth_or_ptp(i_eth_or_ptp),
        .i_pcie(i_pcie),
        .i_pcie_top(i_pcie_top),
        .o_rxfifo_ss_write_clk(o_rxfifo_ss_write_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_ETH_OR_PTP" == sel ) begin : sel_is_ETH_OR_PTP
            assign o_rxfifo_ss_write_clk = i_eth_or_ptp;
        end : sel_is_ETH_OR_PTP
        if ( "SEL_PCIE" == sel ) begin : sel_is_PCIE
            assign o_rxfifo_ss_write_clk = i_pcie;
        end : sel_is_PCIE
        if ( "SEL_PCIE_TOP" == sel ) begin : sel_is_PCIE_TOP
            assign o_rxfifo_ss_write_clk = i_pcie_top;
        end : sel_is_PCIE_TOP
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_hssi_pld_chnl_rx_fifo_wr_clk_mux


(* icm_name="sm_hssi_pld_chnl_tx_fifo_rd_clk_mux", module_type="mux", simple_name="UNKNOWN", atom_type__std *)
module tennm_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux 
    #(
        parameter sel                                                = "SEL_UNUSED"                   /* Settings: SEL_ETH_OR_PTP, SEL_PCIE, SEL_PCIE_TOP, SEL_UNUSED */
    )
    (
        input i_eth_or_ptp,
        input i_pcie,
        input i_pcie_top,
        output o_tx_fifo_ss_read_clk
    );

`ifdef DDM_BASED_COREIP_GENERATOR
    sm_hssi_pld_chnl_tx_fifo_rd_clk_mux 
`ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    #(
        .sel(sel)
    )
`endif // ifdef DEFINE_SF_RTL_MODULE_PARAMETERS
    x_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux (
        .i_eth_or_ptp(i_eth_or_ptp),
        .i_pcie(i_pcie),
        .i_pcie_top(i_pcie_top),
        .o_tx_fifo_ss_read_clk(o_tx_fifo_ss_read_clk)
        );
`else // ifdef DDM_BASED_COREIP_GENERATOR
    generate
        if ( "SEL_ETH_OR_PTP" == sel ) begin : sel_is_ETH_OR_PTP
            assign o_tx_fifo_ss_read_clk = i_eth_or_ptp;
        end : sel_is_ETH_OR_PTP
        if ( "SEL_PCIE" == sel ) begin : sel_is_PCIE
            assign o_tx_fifo_ss_read_clk = i_pcie;
        end : sel_is_PCIE
        if ( "SEL_PCIE_TOP" == sel ) begin : sel_is_PCIE_TOP
            assign o_tx_fifo_ss_read_clk = i_pcie_top;
        end : sel_is_PCIE_TOP
    endgenerate
`endif // ifdef DDM_BASED_COREIP_GENERATOR

endmodule // tennm_sm_hssi_pld_chnl_tx_fifo_rd_clk_mux
