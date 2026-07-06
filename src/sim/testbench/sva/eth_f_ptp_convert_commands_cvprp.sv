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

// generate for (i=0; i<WORDS; i++) begin:cv_word
// `altuvm_sva_cover(SPTP_SHORT_PKT_COV, ((i_tx_valid & cmd_tx_sop[i])|-> good_size_packet[i]==1'b0), (posedge i_clk) , (!i_rst_n) )
generate if (WORDS>2) begin:size_cover
`altuvm_sva_cover(SPTP_SHORT_PKT_COV, ((i_tx_valid[WORDS] & |cmd_tx_sop)|-> |good_size_packet==1'b0), (posedge i_clk) , (!i_rst_n) )
// end
`altuvm_sva_cover(SPTP_PREAMBLE_PASSTHRU_COV, (i_tx_valid[WORDS] & |cmd_tx_sop & i_cfg_tx_pp & |good_size_packet), (posedge i_clk) , (!i_rst_n) )
end
endgenerate

generate for (i=0; i<WORDS; i++) begin:cvp_word
`altuvm_sva_cover(SPTP_PTP_CMD_NO    , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_ins_type[i]==3'b000), (posedge i_clk) , (!i_rst_n) )
//`altuvm_sva_cover(SPTP_PTP_CMD_TSv1  , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_ins_type[i]==3'b001), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ETS   , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_ins_type[i]==3'b010), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_CF    , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_ins_type[i]==3'b011), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_CFP2P , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_ins_type[i]==3'b101), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMEB , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_byte_offset[i]==3'b110), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_EB    , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_byte_offset[i]==3'b010), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMZCS, ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_byte_offset[i]==3'b101), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ZCS   , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_byte_offset[i]==3'b001), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASM   , ((i_tx_valid[i] & cmd_tx_sop[i])|=>  cmd_byte_offset[i]==3'b100), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASM_SIGN_0, ((cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][7]==1'b0), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASM_SIGN_1, ((cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][7]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B6E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][6]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B5E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][5]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B4E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][4]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B3E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][3]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B2E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][2]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B1E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][1]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_ASMP2P_IDX_B0E1, ((cmd_ins_type[i]==3'b101 || cmd_byte_offset[i]==3'b110 || cmd_byte_offset[i]==3'b101 || cmd_byte_offset[i]==3'b100) |-> asm_p2p_sign_idx[i][0]==1'b1), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_EB_EMPTY7   , (i_tx_eop_pline[0][i] |-> (i_tx_empty_pline[0][i]==3'b111)), (posedge i_clk) , (!i_rst_n) )
`altuvm_sva_cover(SPTP_PTP_CMD_EB_EMPTY0TO6, (i_tx_eop_pline[0][i] |-> (i_tx_empty_pline[0][i]<3'b111)), (posedge i_clk) , (!i_rst_n) )
end
endgenerate

generate if (WORDS==16) begin:cvp_e400g
`altuvm_sva_cover(SPTP_E400G_TWO_PTP_CMD_IN_ONE_CYCLE, (i_tx_valid[WORDS] && (upword_ptp_cmd && loword_ptp_cmd)), (posedge i_clk) , (!i_rst_n) )
end
endgenerate

