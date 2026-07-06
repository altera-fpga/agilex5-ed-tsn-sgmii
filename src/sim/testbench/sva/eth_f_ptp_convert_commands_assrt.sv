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


//------------------------------------------------------------------------------
// Include File: eth_f_ptp_state_ctrl_assrt
//
// (White Box) Assertions declaration eth_f_ptp module.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put assertion properties for this module here.        */
/*/////////////////////////////////////////////////////////////*/
genvar i;

property SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_loword(i);
      disable iff ((eth_env_top.spy_if_ip0.dis_sva == 1)| (eth_env_top.reset_if_ip0.csr_rst_n == 0) | (eth_env_top.reset_if_ip0.tx_rst_n == 0) | (eth_env_top.reset_if_ip0.rx_rst_n == 0) | (eth_env_top.spy_if_ip0.soft_tx_rst == 1) | (eth_env_top.spy_if_ip0.soft_rx_rst == 1)) (i_tx_valid & i_tx_sop_pline[0][i] & (i_tx_ptp_ins_ets[0]|i_tx_ptp_ins_cf[0]|i_tx_ptp_ins_cs[0]|i_tx_ptp_ins_eb[0]|i_tx_ptp_ins_asm[0])) |-> !i_tx_skip_crc[i];
endproperty
property SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_upword(i);
      disable iff ((eth_env_top.spy_if_ip0.dis_sva == 1)| (eth_env_top.reset_if_ip0.csr_rst_n == 0) | (eth_env_top.reset_if_ip0.tx_rst_n == 0) | (eth_env_top.reset_if_ip0.rx_rst_n == 0) | (eth_env_top.spy_if_ip0.soft_tx_rst == 1) | (eth_env_top.spy_if_ip0.soft_rx_rst == 1)) (i_tx_valid & i_tx_sop_pline[0][i] & (i_tx_ptp_ins_ets[1]|i_tx_ptp_ins_cf[1]|i_tx_ptp_ins_cs[1]|i_tx_ptp_ins_eb[1]|i_tx_ptp_ins_asm[1])) |-> !i_tx_skip_crc[i];
endproperty
    
generate if (PKT_CYL==2) begin: eth_400g
    for (i=0; i<8; i++) begin:loword400g
        SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_loword_CHECK_i: assert property (@(posedge i_clk)SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_loword(i)) else `uvm_error($sformatf("%m"),"ERROR: SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP i_tx_skip_crc must be zero when i_tx_ptp_ins__ets/cf/cs/eb/asm asserts");
    end
    for (i=8; i<WORDS; i++) begin:upword400g
        SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_upword_CHECK_i: assert property (@(posedge i_clk)SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_upword(i)) else `uvm_error($sformatf("%m"),"ERROR: SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP i_tx_skip_crc must be zero when i_tx_ptp_ins__ets/cf/cs/eb/asm asserts");
    end
end
else begin: eth_200g_to_10g
    for (i=0; i<WORDS; i++) begin:loword
        SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_loword_CHECK_i: assert property (@(posedge i_clk)SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP_loword(i)) else `uvm_error($sformatf("%m"),"ERROR: SPTP_SKIP_CRC_MUST_BE_0_FOR_1STEP i_tx_skip_crc must be zero when i_tx_ptp_ins__ets/cf/cs/eb/asm asserts");
    end
end
endgenerate