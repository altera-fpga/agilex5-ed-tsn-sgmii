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


//==============================================================================
// Cover Properties
//==============================================================================
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put coverage properties for this module here.         */
/*/////////////////////////////////////////////////////////////*/
// <<example>>: `altuvm_sva_cover(LABEL2, signal_a && !signal_b)
//------------------------------------------------------------------------------
// Macro: altuvm_sva_cover
// Macro for assertion coverage which synchronized with CLK and disabled when
// RST is true
//
//|`altuvm_sva_cover(LBL, EXPR, CLK=sva_event, RST=(sva_reset), MSG="")
//
// Example use cases:
//(code)
//`altuvm_sva_cover(D_IsThePastOf_Q, (q == $past(d))
//`altuvm_sva_cover(D_IsThePastOf_Q, (q == $past(d), (posedge myclk))
//`altuvm_sva_cover(D_IsThePastOf_Q, (q == $past(d),, (!myreset))
//`altuvm_sva_cover(D_IsThePastOf_Q,
//   (q == $past(d),,, $sformatf("d=%0d, q=%0d", d, q))
//(end)




genvar i;

generate
for (i=0; i<PKT_CYL; i++) begin: cvp_pkt
`altuvm_sva_cover(SPTP_TX_ETS_NATURAL_ROLLOVER,     (w_tx_ptp_ets_valid[i] && tx_ets_rollover[i]) , (posedge i_clk) , (!i_tx_rst_n) )
`altuvm_sva_cover(SPTP_TX_ETS_BILLION_ROLLOVER,     (w_tx_ptp_ets_valid[i] && tx_ets_rollover_billion[i]  ) , (posedge i_clk) , (!i_tx_rst_n) )
`altuvm_sva_cover(SPTP_RX_ITS_TOD_NATURAL_ROLLOVER, (w_rx_ptp_its_valid[i] && rx_tod_rollover[i]          ) , (posedge i_clk) , (!i_rx_rst_n) )
`altuvm_sva_cover(SPTP_RX_ITS_TOD_BILLION_ROLLOVER, (w_rx_ptp_its_valid[i] && rx_tod_rollover_billion[i]  ) , (posedge i_clk) , (!i_rx_rst_n) )
end

if (WORDS<8) begin: cvp_10gto100g
`altuvm_sva_cover(SPTP_RX_VALID_DEASSERT_DURING_ITS_FORMATION_10GTO100G, (|w_rx_sop |-> ##[1:RX_PLNUM] ~i_rx_valid) , (posedge i_clk) , (!i_rx_rst_n) )
end
else if (WORDS==8) begin: cvp_200g
`altuvm_sva_cover(SPTP_BACK2BACK_ITS_200G, (o_rx_ptp_its_valid && $past(o_rx_ptp_its_valid,1)) , (posedge i_clk) , (!i_rx_rst_n) )
`altuvm_sva_cover(SPTP_BACK2BACK_ETS_200G, (o_tx_ptp_ets_valid && $past(o_tx_ptp_ets_valid,1)) , (posedge i_clk) , (!i_tx_rst_n) )
end
else if (WORDS==16) begin: cvp_400g
`altuvm_sva_cover(SPTP_BACK2BACK_ITS_400G, (o_rx_ptp_its_valid[0] && o_rx_ptp_its_valid[1]) , (posedge i_clk) , (!i_rx_rst_n) )
`altuvm_sva_cover(SPTP_BACK2BACK_ETS_400G, (o_tx_ptp_ets_valid[0] && o_tx_ptp_ets_valid[1]) , (posedge i_clk) , (!i_tx_rst_n) )
`altuvm_sva_cover(SPTP_UPPER_ITS_400G,     (o_rx_ptp_its_valid[1]                         ) , (posedge i_clk) , (!i_rx_rst_n) )
`altuvm_sva_cover(SPTP_UPPER_ETS_400G,     (o_tx_ptp_ets_valid[1]                         ) , (posedge i_clk) , (!i_tx_rst_n) )
`altuvm_sva_cover(SPTP_LOWER_ITS_400G,     (o_rx_ptp_its_valid[0]                         ) , (posedge i_clk) , (!i_rx_rst_n) )
`altuvm_sva_cover(SPTP_LOWER_ETS_400G,     (o_tx_ptp_ets_valid[0]                         ) , (posedge i_clk) , (!i_tx_rst_n) )
end
endgenerate
