speed_e s1[5],s2[6]; 
int mac_tx_clk_period_ip0 =2482; //ps// if (spy_if_ip0.speed inside s1 && spy_if_ip0.fec_type inside fec1)
int mac_rx_clk_period_ip0=2482; 
int clk_tx_div_period_ip0=2560; //not 40G 
int clk_rec_div64_period_ip0=2482;//+-100ppm
int clk_rec_div66_period_ip0=2560;//+-100ppm
int expected_margin=25; // ps 
fec_type_e fec1[3],fec2[2],fec3[1]; 

initial begin
fec1='{ NOFEC, FCFEC, RSFECKR};
fec2= '{RSFECKP, LLFEC};
fec3= '{NOFEC};
s1='{ _200G,_100G,_50G,_40G,_25G};
s2='{_400G, _200G,_100G,_50G,_40G,_25G};
end


always @(spy_if_ip0.speed ,spy_if_ip0.fec_type) begin
//if(spy_if_ip0.speed inside {_10G,_40G}) begin
if(spy_if_ip0.speed == _10G) begin
	clk_tx_div_period_ip0=6402;
	clk_rec_div64_period_ip0=6206;
	clk_rec_div66_period_ip0=6402;
end
else if(spy_if_ip0.speed == _40G) begin
	clk_tx_div_period_ip0=3200;
	clk_rec_div64_period_ip0=6206;
	clk_rec_div66_period_ip0=3200;
end
else if (spy_if_ip0.speed inside s2 && spy_if_ip0.fec_type inside fec2) begin 
	clk_rec_div64_period_ip0=2409;
end
end 
always @(spy_if_ip0.syspll or dut.o_rx_pcs_ready_ip0) begin
	if(spy_if_ip0.syspll==0) begin
		mac_tx_clk_period_ip0=2482;
		mac_rx_clk_period_ip0=2482;
	end
	else if(spy_if_ip0.syspll==1) begin
		mac_tx_clk_period_ip0=2409;
		mac_rx_clk_period_ip0=2409;
	end
	else if(spy_if_ip0.syspll==2) begin
		mac_tx_clk_period_ip0=6202;
		mac_rx_clk_period_ip0=6202;
	end 
	else if(spy_if_ip0.syspll==3) begin
		case(spy_if_ip0.syspllcnt)
			40'd8300781250: mac_tx_clk_period_ip0 = 2409;
			40'd9031250000: mac_tx_clk_period_ip0 = 2214;
			40'd9500000000: mac_tx_clk_period_ip0 = 2105;
			40'd10000000000: mac_tx_clk_period_ip0 = 2000;
			40'd8700000000: mac_tx_clk_period_ip0 = 2299;
			default: $error("Inside clock assertion File: syspllcnt value %0d is out of range",spy_if_ip0.syspllcnt);
		endcase
	mac_rx_clk_period_ip0 = mac_tx_clk_period_ip0; 
	end
end


property T_clkasrt_ip0(real clk_period,reg enable,int unsigned expected_margin);
  time current_time;
  disable iff(enable !== 1'b1)
    (('1,current_time=$realtime) |=> (((clk_period-expected_margin) < ($realtime - current_time)) && ((clk_period+expected_margin) > ($realtime - current_time)))); 
endproperty

// assertion :clock_frequency_check_clk_rxmac_ip0
// This assertion checks rx mac clock period 
//clock_frequency_check_clk_rxmac_ip0:assert property (@(posedge dut.i_clk_rx_ip0)T_clkasrt_ip0(mac_rx_clk_period_ip0,(dut.o_rx_pcs_ready_ip0 && !spy_if_ip0.en_async_adp),expected_margin))
//else
//`uvm_error("clock_frequency_check_clk_rxmac_ip0", $sformatf("rx mac clock frequency is not correct"));
//
//// assertion :clock_frequency_check_clk_txmac_ip0
//// This assertion checks the read cycle hold or no hold condtion
//clock_frequency_check_clk_txmac_ip0:assert property (@(posedge dut.i_clk_tx_ip0)T_clkasrt_ip0(mac_tx_clk_period_ip0,(dut.o_rx_pcs_ready_ip0 && !spy_if_ip0.en_async_adp),expected_margin))
//else
//`uvm_error("clock_frequency_check_clk_txmac_ip0", $sformatf("tx mac clock frequency is not correct"));
//clock_frequency_asrt_check_clk_pll_ip0:assert property (@(posedge dut.o_clk_pll_ip0)T_clkasrt_ip0(mac_tx_clk_period_ip0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),expected_margin))
//else
//`uvm_error("clock_frequency_asrt_check_clk_pll_ip0", $sformatf("pll clock frequency is not correct"));
//
//// assertion :clock_frequency_asrt_check_clk_rec_div64_ip0
//// This assertion checks the read cycle hold or no hold condtion
//clock_frequency_asrt_check_clk_rec_div64_ip0:assert property (@(posedge dut.o_clk_rec_div64_ip0)T_clkasrt_ip0(clk_rec_div64_period_ip0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),expected_margin))
//else
//`uvm_error("clock_frequency_asrt_check_clk_rec_div64_ip0", $sformatf("rec div64 clock frequency is not correct"));
//
////Divya-temporary workaround as div66 changes are not part of repo
//
//// assertion :clock_frequency_check_clk_tx_div_ip0
//// This assertion checks the read cycle hold or no hold condtion
//clock_frequency_check_clk_tx_div_ip0:assert property (@(posedge dut.o_clk_tx_div_ip0)T_clkasrt_ip0(clk_tx_div_period_ip0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),expected_margin))
//else
//`uvm_error("clock_frequency_check_clk_tx_div_ip0", $sformatf("tx div clock frequency is not correct"));
//
//// assertion :clock_frequency_check_clk_rec_div_ip0
//// This assertion checks the read cycle hold or no hold condtion
//clock_frequency_check_clk_rec_div_ip0:assert property (@(posedge dut.o_clk_rec_div_ip0)T_clkasrt_ip0(clk_rec_div66_period_ip0,(dut.o_rx_pcs_ready_ip0 && !assertion_on_off_reset),expected_margin))
//else
//`uvm_error("clock_frequency_check_clk_rec_div_ip0", $sformatf("rec div clock frequency is not correct"));



