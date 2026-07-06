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
// Include File: eth_f_ptp_assrt
//
// (White Box) Assertions declaration eth_f_ptp module.
//
//------------------------------------------------------------------------------
/*/////////////////////////////////////////////////////////////*/
/* TODO: Put assertion properties for this module here.        */
/*/////////////////////////////////////////////////////////////*/

genvar i;

generate if (WORDS==1) begin:assrt_10g25g
property SPTP_RX_VALID_NO_INFRAME_ASSRT;
    (idle_period & int_rx_valid) |-> !(|rev_in_rx_pkt_inframe);
endproperty
SPTP_RX_VALID_NO_INFRAME_ASSRT_CHECK_i: assert property (@(posedge i_ptp_clk) SPTP_RX_VALID_NO_INFRAME_ASSRT) else `uvm_error($sformatf("%m"),"ERROR: SPTP_RX_VALID_NO_INFRAME_ASSRT inframe=1 at (idle && rx_valid=1) is not expected");
end
endgenerate

generate for (i=0; i<PL; i++) begin: assrt_pl

// if (APUL_MEAS==1) begin:dt1
    property SPTP_TXDT_VALUE_10G_ADV_MODE;
        ((APUL_MEAS==1 && i_cfg_speed==0) && $rose(o_tx_apulse_offset_valid)) |-> (o_tx_apulse_offset[i] >= {1'b1, 15'd44,16'd52429}); // 7*6.4ns
    endproperty
    SPTP_TXDT_VALUE_10G_ADV_MODE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_TXDT_VALUE_10G_ADV_MODE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_TXDT_VALUE_10G_ADV_MODE 10G advanced mode, dt should larger than 7*6.4ns!");

    property SPTP_TXDT_VALUE_25GTO400G_ADV_MODE;
        ((APUL_MEAS==1 && i_cfg_speed!=0) && $rose(o_tx_apulse_offset_valid)) |-> (o_tx_apulse_offset[i]>= {1'b1, 15'd17,16'd60293}); // 7*2.56ns
    endproperty
    SPTP_TXDT_VALUE_25GTO400G_ADV_MODE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_TXDT_VALUE_25GTO400G_ADV_MODE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_TXDT_VALUE_25GTO400G_ADV_MODE 25G-400G advanced mode, dt should larger than 7*2.56ns!");

    property SPTP_RXDT_VALUE_10G_ADV_MODE;
        ((APUL_MEAS==1 && i_cfg_speed==0) && $rose(o_rx_apulse_offset_valid)) |-> (o_rx_apulse_offset[i] >= {1'b1, 15'd44,16'd52429}); // 7*6.4ns
    endproperty
    SPTP_RXDT_VALUE_10G_ADV_MODE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_RXDT_VALUE_10G_ADV_MODE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_RXDT_VALUE_10G_ADV_MODE 10G advanced mode, dt should larger than 7*6.4ns!");

    property SPTP_RXDT_VALUE_25GTO400G_ADV_MODE;
        ((APUL_MEAS==1 && i_cfg_speed!=0) && $rose(o_rx_apulse_offset_valid)) |-> (o_rx_apulse_offset[i]>= {1'b1, 15'd17,16'd60293}); // 7*2.56ns
    endproperty
    SPTP_RXDT_VALUE_25GTO400G_ADV_MODE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_RXDT_VALUE_25GTO400G_ADV_MODE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_RXDT_VALUE_25GTO400G_ADV_MODE 25G-400G advanced mode, dt should larger than 7*2.56ns!");
// end
// else begin: dt0
    property SPTP_TXDT_VALUE_BASIC_MODE;
        ((APUL_MEAS==0) && $rose(o_tx_apulse_offset_valid)) |-> (o_tx_apulse_offset[i] == {1'b1, 15'd6,16'h6666}); // 2.5*2.56=6.4ns
    endproperty
    SPTP_TXDT_VALUE_BASIC_MODE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_TXDT_VALUE_BASIC_MODE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_TXDT_VALUE_BASIC_MODE 10G-400G basic mode dt should equal 2.5*2.56ns!");

    property SPTP_RXDT_VALUE_BASIC_MODE;
        ((APUL_MEAS==0) && $rose(o_rx_apulse_offset_valid)) |-> (o_rx_apulse_offset[i] == {1'b1, 15'd6,16'h6666}); // 2.5*2.56=6.4ns
    endproperty
    SPTP_RXDT_VALUE_BASIC_MODE_CHECK_i: assert property (@(posedge i_ptp_clk)SPTP_RXDT_VALUE_BASIC_MODE) else `uvm_error($sformatf("%m"),"ERROR: SPTP_RXDT_VALUE_BASIC_MODE 10G-400G basic mode dt should equal 2.5*2.56ns!");
// end    
end
endgenerate
