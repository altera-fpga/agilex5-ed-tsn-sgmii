// 50G AVST assertion

// Define: RX_EOP_IP0
// This define used to indicate RX EOP 
`define RX_EOP_IP0 dut.o_rx_endofpacket_ip0
`define RX_SOP_IP0 dut.o_rx_startofpacket_ip0

// Define: RX_VALID_IP0
// This define used to indicate RX VALID 
`define RX_VALID_IP0 dut.o_rx_status_valid_ip0 

// Define: CLK_RXMAC_IP0
// This define used to indicate CLK_RXMAC 
`define CLK_RXMAC_IP0 dut.i_clk_rx_ip0
`define CLK_TXMAC_IP0 dut.i_clk_tx_ip0

`define TX_EMPTY_IP0 dut.i_tx_empty_ip0
//sequence read_nohold_ip0;
//   (~avmm_if_ip0.waitrequest) ##1 (avmm_if_ip0.readdatavalid);
//endsequence
//
//sequence read_hold_ip0;
//   (avmm_if_ip0.waitrequest) ##[1:25] (~avmm_if_ip0.waitrequest) ##1 (avmm_if_ip0.readdatavalid);
//endsequence
//
//// assertion :p_readdata_waitreq_ip0
//// This assert property checks the relation between waitreq and readvalid 
//p_readdata_waitreq_ip0 : assert property (@(posedge clk_status_ip0) avmm_if_ip0.read==1 |=> ($past(avmm_if_ip0.waitrequest)==1 or avmm_if_ip0.readdatavalid==1)) else 
//    uvm_report_error("tb_assertions",$psprintf("ASSERT FAILURE: waitrequest should go high because DUT is unable to complete transaction in one cycle"));
//
//// assertion :p_readhold_readnohold_ip0
//// This assertion checks the read cycle hold or no hold condtion
//p_readhold_readnohold_ip0 : assert property (@(posedge clk_status_ip0) avmm_if_ip0.read==1 |-> read_nohold_ip0 or read_hold_ip0) else 
//    uvm_report_error("tb_assertions",$psprintf("ASSERT FAILURE: AVMM Protocol violation for READ, waitrequest and/or readdata_valid signal not following protocol"));

property read_data_x_ip0(reg enable);
  disable iff(enable !== 1'b1)
  $rose(avmm_if_ip0.readdatavalid)  |-> (!($isunknown(avmm_if_ip0.readdata))); 
endproperty

property T_clk_ip0(real clk_period,reg enable,int unsigned expected_margin);
  time current_time;
  disable iff(enable !== 1'b1)
    (('1,current_time=$realtime) |=> (((clk_period-expected_margin) < ($realtime - current_time)) && ((clk_period+expected_margin) > ($realtime - current_time)))); 
endproperty

readdata_x_ip0:assert property (@(posedge clk_status_ip0)read_data_x_ip0(reset_if_ip0.csr_rst_n))
else
`uvm_error("readdata_x_ip0", $sformatf("avmm read data is 'x'"));

property signal_check_ip0(bit tri_cnd,bit mon_cnd,bit enable);
  disable iff(enable == 0 || $time==0)
`ifdef ANLT
  $rose(tri_cnd) |=> ##15 mon_cnd == 1'b0 [*2]; 
`else
  //HSD : 16013538962 increasing the range
  $rose(tri_cnd) |=> ##[5:10] mon_cnd == 1'b0 [*2]; 
`endif
endproperty
// assertion :check_tx_soft_rst_ip0
// This assertion checks tx mac reset and relation with o_tx_lanes_stable 
check_tx_soft_rst_ip0:assert property (@(posedge clk_status_ip0)signal_check_ip0((!REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[1]),dut.o_tx_lanes_stable_ip0,reset_if_ip0.csr_rst_n))
else
`uvm_error("check_tx_soft_rst_ip0", $sformatf("tx soft reset and o_tx_lanes_stable relation is incorrect"));

// assertion :check_rx_soft_rst_ip0
// This assertion checks rx mac reset and relation with o_rx_pcs_ready 
check_rx_soft_rst_ip0:assert property (@(posedge clk_status_ip0)signal_check_ip0(REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[2],dut.o_rx_pcs_ready_ip0,reset_if_ip0.csr_rst_n))
else
`uvm_error("check_rx_soft_rst_ip0", $sformatf("rx soft reset and o_rx_pcs_ready relation is incorrect "));

// assertion :check_soft_csr_rst_ip0
// This assertion checks csr reset and relation with o_tx_lanes_stable and o_rx_pcs_ready
check_soft_csr_rst_ip0:assert property (@(posedge clk_status_ip0)signal_check_ip0(REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0],(dut.o_tx_lanes_stable_ip0 & dut.o_rx_pcs_ready_ip0 ), reset_if_ip0.csr_rst_n))
else
`uvm_error("check_soft_csr_rst_ip0", $sformatf("eio soft reset ,o_tx_lanes_stable ,and o_rx_pcs_ready relation is incorrect"));

// assertion :check_tx_hard_rst_ip0
// This assertion checks o_tx_lanes_stable with referance to tx  reset assertion
check_tx_hard_rst_ip0:assert property (@(posedge clk_status_ip0)signal_check_ip0(reset_if_ip0.tx_rst_n,dut.o_tx_lanes_stable_ip0,1))
else
`uvm_error("check_tx_hard_rst_ip0", $sformatf("tx_rst_n (tx hard reset) and o_tx_lanes_stable relation is incorrect"));

// assertion :check_rx_hard_rst_ip0
// This assertion checks rx mac reset and relation with o_rx_pcs_ready 
check_rx_hard_rst_ip0:assert property (@(posedge clk_status_ip0)signal_check_ip0(!reset_if_ip0.rx_rst_n,dut.o_rx_pcs_ready_ip0,1))
else
`uvm_error("check_rx_hard_rst_ip0", $sformatf("rx_rst_n (rx hard reset) and o_rx_pcs_ready relation is incorrect "));

// assertion :check_hard_csr_rst_ip0
// This assertion checks csr reset and relation with o_tx_lanes_stable and o_rx_pcs_ready HSD:16011780789
check_hard_csr_rst_ip0:assert property (@(posedge clk_status_ip0)signal_check_ip0(reset_if_ip0.csr_rst_n,(dut.o_tx_lanes_stable_ip0 & dut.o_rx_pcs_ready_ip0 ),1))
else
`uvm_error("check_hard_csr_rst_ip0", $sformatf("csr_rst_n hard reset ,o_tx_lanes_stable ,and o_rx_pcs_ready relation is incorrect"));

//Assertion Sequence: eop_valid_posedge_align_ip0
sequence eop_valid_posedge_align_ip0;
  $rose(`RX_VALID_IP0) ##0 $rose(`RX_EOP_IP0);
endsequence

//Assertion Sequence: eop_valid_negedge_align_ip0
sequence eop_valid_negedge_align_ip0;
  $fell(`RX_VALID_IP0) || $rose(`RX_SOP_IP0) ; // ##0 $fell(`RX_EOP_IP0); HSD:16011780982
endsequence

//Assertion: eop_valid_align_ip0
//This  assertion checks the rx eop & rx valid should be align for rx data sample
property eop_valid_align_ip0(reg enable);
  disable iff(enable !== 1'b1)
  eop_valid_posedge_align_ip0 |-> ##1 eop_valid_negedge_align_ip0;
endproperty

eopvalid_align_ip0:assert property (@(posedge `CLK_RXMAC_IP0)eop_valid_align_ip0(reset_if_ip0.csr_rst_n & dut.o_rx_pcs_ready_ip0 & dut.o_tx_lanes_stable_ip0 & dut.o_rx_valid_ip0))
else
`uvm_error("eop_valid_align_ip0", $sformatf("RX_EOP_VALID_NOT_ALIGN"));

//Assertion: b2b_packet_ip0
property b2b_packet_ip0(reg enable);
  disable iff(enable !== 1'b1)  `TX_EMPTY_IP0 == 0;
endproperty

b2bpacket_ip0:assert property (@(posedge `CLK_TXMAC_IP0)b2b_packet_ip0(spy_if_ip0.ipg_check_enable))
else
`uvm_error("b2b_packet_ip0", $sformatf("TX_EMPTY_NOT_0"));

