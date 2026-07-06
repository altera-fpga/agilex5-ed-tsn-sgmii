// 100G AVST assertion
`define CLK_TXMAC_IP0 dut.i_clk_tx_ip0

`define TX_EMPTY_IP0 dut.i_tx_empty_ip0
fec_type_e fec1[3],fec2[2]; 

int PLL_DIV64_CLK_PERIOD_IP0 = 2482;
int REC_DIV64_CLK_PERIOD_IP0 = 2482;

initial begin
fec1='{ NOFEC, FCFEC, RSFECKR};
fec2= '{RSFECKP, LLFEC};
$display("rx_pcs_ready asserted at %0t",$time);
end

// Define :MAC_TX_CLK_PERIOD_IP0
// This define used to indicate the clock period of mac tx clock
`define MAC_TX_CLK_PERIOD_IP0    2482

// Define :MAC_RX_CLK_PERIOD_IP0
// This define used to indicate the clock period of mac rx clock
`define MAC_RX_CLK_PERIOD_IP0    2482

// Define :PLL_DIV64_CLK_PERIOD_IP0
// This define used to indicate the clock period of pll div64 
always @(spy_if_ip0.fec_type) begin 
if(spy_if_ip0.fec_type inside fec2) begin
PLL_DIV64_CLK_PERIOD_IP0 = 2409;
$display("FEC_TYPE=%0d at %0t with pll_value=%0d",spy_if_ip0.fec_type,$time,PLL_DIV64_CLK_PERIOD_IP0);
end


// Define :REC_DIV64_CLK_PERIOD_IP0
// This define used to indicate the clock period of rec div64
if(spy_if_ip0.fec_type inside fec2) begin
REC_DIV64_CLK_PERIOD_IP0= 2409;
$display("FEC_TYPE=%0d at %0t with rec_div64=%0d",spy_if_ip0.fec_type,$time,REC_DIV64_CLK_PERIOD_IP0);
end
end

always @(spy_if_ip0.syspll or dut.o_rx_pcs_ready_ip0) begin
	if(spy_if_ip0.syspll==0) begin
		PLL_DIV64_CLK_PERIOD_IP0=2482;
		
	end
	else if(spy_if_ip0.syspll==1) begin
		PLL_DIV64_CLK_PERIOD_IP0=2409;
		
	end
	else if(spy_if_ip0.syspll==2) begin
		PLL_DIV64_CLK_PERIOD_IP0=6202;
		
	end 
	else if(spy_if_ip0.syspll==3) begin
		case(spy_if_ip0.syspllcnt)
			40'd8300781250: PLL_DIV64_CLK_PERIOD_IP0 = 2409;
			40'd9031250000: PLL_DIV64_CLK_PERIOD_IP0 = 2214;
			40'd9500000000: PLL_DIV64_CLK_PERIOD_IP0= 2105;
			40'd10000000000:PLL_DIV64_CLK_PERIOD_IP0 = 2000;
			40'd8700000000: PLL_DIV64_CLK_PERIOD_IP0 = 2299;
			default: $error("Inside clock assertion File: syspllcnt value %0d is out of range",spy_if_ip0.syspllcnt);
		endcase
	end
end
// Define :PLL_DIV66_CLK_PERIOD_IP0
// This define used to indicate the clock period of pll div66
//`define PLL_DIV66_CLK_PERIOD_IP0    2484
`define PLL_DIV66_CLK_PERIOD_IP0    2560   //not for 40G/10G
// Define :REC_DIV66_CLK_PERIOD_IP0
// This define used to indicate the clock period of rec div66
//`define REC_DIV66_CLK_PERIOD_IP0     2484
`define REC_DIV66_CLK_PERIOD_IP0     2560    //not for 40G/10G

//Define: EXPECTED_MARGIN_DIV64_IP0
//This define used to indicate the expected margin for div66
// DIV64_IP0 - 402.8320 +/- 2% = (410.8866 - 394.7753) = (2433 - 2533)
`define EXPECTED_MARGIN_DIV64_IP0 50

//Define: EXPECTED_MARGIN_DIV66_IP0
//This define used to indicate the expected margin for div64
// DIV66_IP0 - 390.625 +/- 2% = (398.4375 - 382.8125) = (2509 - 2612)
`define EXPECTED_MARGIN_DIV66_IP0 51

// Define: RX_EOP_IP0
// This define used to indicate RX EOP 
`define RX_EOP_IP0 dut.o_rx_endofpacket_ip0

// Define: RX_VALID_IP0
// This define used to indicate RX VALID 
`define RX_VALID_IP0 dut.o_rx_status_valid_ip0 

// Define: CLK_RXMAC_IP0
// This define used to indicate CLK_RXMAC 
`define CLK_RXMAC_IP0 dut.i_clk_rx_ip0


// RAMI-FIX should be part of ANLT
//bit[31:0] REGISTERS_ANLT_SEQ_CFG_OFFSET_REG_WRITE_DATA_IP0;
//assign REGISTERS_ANLT_SEQ_CFG_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_ip0.address[17:2] == `REGISTERS_anlt_seq_cfg_OFFSET_REG) && (avmm_if_ip0.write == 1'b1)) ? avmm_if_ip0.writedata : 'h0;
//assign spy_if_ip0.anlt_seq_cfg_soft_rst  =  REGISTERS_ANLT_SEQ_CFG_OFFSET_REG_WRITE_DAT_IP0A[0];

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

// assertion :clock_frequency_check_clk_rxmac_ip0
// This assertion checks rx mac clock period 
//clock_frequency_check_clk_rxmac_ip0:assert property (@(posedge dut.i_clk_rx_ip0)T_clk_ip0(`MAC_RX_CLK_PERIOD_IP0,dut.o_rx_pcs_ready_ip0))
//else
//`uvm_error("clock_frequency_check_clk_rxmac_ip0", $sformatf("rx mac clock frequency is not correct"));

// assertion :clock_frequency_check_clk_txmac_ip0
// This assertion checks the read cycle hold or no hold condtion
//clock_frequency_check_clk_txmac_ip0:assert property (@(posedge dut.i_clk_tx_ip0)T_clk_ip0(`MAC_TX_CLK_PERIOD_IP0,dut.o_tx_lanes_stable_ip0))
//else
//`uvm_error("clock_frequency_check_clk_txmac_ip0", $sformatf("tx mac clock frequency is not correct"));

// assertion :clock_frequency_check_clk_pll_ip0
// This assertion checks the read cycle hold or no hold condtion
clock_frequency_check_clk_pll_ip0:assert property (@(posedge dut.o_clk_pll_ip0)T_clk_ip0(PLL_DIV64_CLK_PERIOD_IP0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),`EXPECTED_MARGIN_DIV64_IP0))
else
`uvm_error("clock_frequency_check_clk_pll_ip0", $sformatf("pll clock frequency is not correct"));

// assertion :clock_frequency_check_clk_rec_div64_ip0
// This assertion checks the read cycle hold or no hold condtion
clock_frequency_check_clk_rec_div64_ip0:assert property (@(posedge dut.o_clk_rec_div64_ip0)T_clk_ip0(REC_DIV64_CLK_PERIOD_IP0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),`EXPECTED_MARGIN_DIV64_IP0))
else
`uvm_error("clock_frequency_check_clk_rec_div64_ip0", $sformatf("rec div64 clock frequency is not correct"));

// assertion :clock_frequency_check_clk_tx_div_ip0
// This assertion checks the read cycle hold or no hold condtion
/*clock_frequency_check_clk_tx_div_ip0:assert property (@(posedge dut.o_clk_tx_div_ip0)T_clk_ip0(`PLL_DIV66_CLK_PERIOD_IP0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),`EXPECTED_MARGIN_DIV66_IP0))
else
`uvm_error("clock_frequency_check_clk_tx_div_ip0", $sformatf("tx div clock frequency is not correct"));

// assertion :clock_frequency_check_clk_rec_div_ip0
// This assertion checks the read cycle hold or no hold condtion
clock_frequency_check_clk_rec_div_ip0:assert property (@(posedge dut.o_clk_rec_div_ip0)T_clk_ip0(`REC_DIV66_CLK_PERIOD_IP0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),`EXPECTED_MARGIN_DIV66_IP0))
else
`uvm_error("clock_frequency_check_clk_rec_div_ip0", $sformatf("rec div clock frequency is not correct"));*/

property signal_check_ip0(bit tri_cnd,bit mon_cnd,bit enable);
  disable iff(enable == 0 || $time==0)
`ifdef ANLT
  $rose(tri_cnd) |=> ##15 mon_cnd == 1'b0 [*2]; 
`else
  $rose(tri_cnd) |=> ##[1:10] mon_cnd == 1'b0 [*2]; 
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
property valid_eop_posedge_align_ip0(reg enable);
  disable iff(enable !== 1'b1)
  $rose(`RX_VALID_IP0) |-> $rose(`RX_EOP_IP0);
endproperty

//commenting assertion based on HSD:16011780982
//Assertion Sequence: eop_valid_negedge_align_ip0
///property valid_eop_negedge_align_ip0(reg enable);
//  disable iff(enable !== 1'b1)
//  $fell(`RX_VALID_IP0) |-> (`RX_EOP_IP0);
//endproperty

property eop_valid_negedge_align_ip0(reg enable);
  disable iff(enable !== 1'b1)
  $rose(`RX_EOP_IP0) |-> ##[1:50] $fell(`RX_EOP_IP0) ; // HSD:16011780982
endproperty

property eop_valid_posedge_align_ip0(reg enable);
  disable iff(enable !== 1'b1)
  $rose(`RX_EOP_IP0) |-> $rose(`RX_VALID_IP0)  ;
endproperty

property b2b_packet_ip0(reg enable);
  disable iff(enable !== 1'b1)  `TX_EMPTY_IP0 == 0;
endproperty

b2bpacket_ip0:assert property (@(posedge `CLK_TXMAC_IP0)b2b_packet_ip0(spy_if_ip0.ipg_check_enable))
else
`uvm_error("b2b_packet_ip0", $sformatf("TX_EMPTY_NOT_0"));

valid_eop_posedge_align_assertion_ip0: assert property (@(posedge `CLK_RXMAC_IP0) valid_eop_posedge_align_ip0(reset_if_ip0.csr_rst_n & dut.o_rx_pcs_ready_ip0 & dut.o_tx_lanes_stable_ip0))
else
`uvm_error("eop_valid_align_ip0", $sformatf("RX_EOP_VALID_NOT_ALIGN"));
//commenting assertion based on HSD:16011780982
//valid_eop_negedge_align_assertion_ip0: assert property (@(posedge `CLK_RXMAC_IP0) valid_eop_negedge_align_ip0(reset_if_ip0.csr_rst_n & dut.o_rx_pcs_ready_ip0 & dut.o_tx_lanes_stable_ip0))
//else
//`uvm_error("eop_valid_align_ip0", $sformatf("RX_EOP_VALID_NOT_ALIGN"));
eop_valid_posedge_align_assertion_ip0: assert property (@(posedge `CLK_RXMAC_IP0) eop_valid_posedge_align_ip0(reset_if_ip0.csr_rst_n & dut.o_rx_pcs_ready_ip0 & dut.o_tx_lanes_stable_ip0))
else
`uvm_error("eop_valid_align_ip0", $sformatf("RX_EOP_VALID_NOT_ALIGN"));
eop_valid_negedge_align_assertion_ip0: assert property (@(posedge `CLK_RXMAC_IP0) eop_valid_negedge_align_ip0(reset_if_ip0.csr_rst_n & dut.o_rx_pcs_ready_ip0 & dut.o_tx_lanes_stable_ip0))
else
`uvm_error("eop_valid_align_ip0", $sformatf("RX_EOP_VALID_NOT_ALIGN"));
