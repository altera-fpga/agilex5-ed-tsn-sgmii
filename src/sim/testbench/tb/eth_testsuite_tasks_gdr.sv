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



for(genvar index_val=0;index_val< NUM_CHANNELS; index_val++) begin: VIP_TESTSUITE
class vip_test_suite_element extends vip_test_suite; 
task vip_do_drv_cfg (input [31:0] param, input [63:0] pvalue);
	SVT_INST[index_val].svt_ethernet_drv.do_cfg(param, pvalue);
        SVT_INST[index_val].svt_ethernet_drv.Bfm.do_cfg(param, pvalue);
endtask :vip_do_drv_cfg 

 task vip_do_mon_cfg (input [31:0] param, input [63:0] pvalue);
         SVT_INST[index_val].svt_ethernet_mon_chk.do_cfg(param, pvalue);
         SVT_INST[index_val].svt_ethernet_mon_chk.Chk.do_cfg(param, pvalue);
 endtask : vip_do_mon_cfg

task vip_wait_vip_rx_link_down();
 wait(svt_ethernet_txrx_if[index_val].if_mon.usr_chk_sync_up_rx === 0);
endtask 

task vip_wait_vip_rx_link_up();
 wait(svt_ethernet_txrx_if[index_val].if_mon.usr_chk_sync_up_rx === 1);
endtask

task vip_do_drv_cfg_pcs66(input [31:0] param, input [63:0] pvalue);
	 SVT_PCS66_INST_25G[index_val].svt_ethernet_drv_otn_flexe.do_cfg(param, pvalue);
         SVT_PCS66_INST_25G[index_val].svt_ethernet_drv_otn_flexe.Bfm.do_cfg(param, pvalue);
endtask

task vip_do_mon_cfg_pcs66 (input [31:0] param, input [63:0] pvalue);
         SVT_PCS66_INST_25G[index_val].svt_ethernet_mon_chk_otn_flexe.do_cfg(param, pvalue);
         SVT_PCS66_INST_25G[index_val].svt_ethernet_mon_chk_otn_flexe.Chk.do_cfg(param, pvalue);
 endtask : vip_do_mon_cfg_pcs66

function avst_set_enable_a_non_missing_startofpacket(bit en);
	AVST_RX[index_val].avst_rx_rtb.monitor.u_bfm.monitor_assertion.set_enable_a_non_missing_startofpacket(en);
endfunction	

function avst_set_enable_a_non_missing_endofpacket(bit en);
	AVST_RX[index_val].avst_rx_rtb.monitor.u_bfm.monitor_assertion.set_enable_a_non_missing_endofpacket(en);
endfunction

task vip_do_drv_err (input [31:0] param, input [71:0] pvalue);
	SVT_INST[index_val].svt_ethernet_drv.Bfm.do_err(param, pvalue);
endtask 

task vip_do_drv_cmd (input [31:0] cmd, input [63:0] address, input [31:0] byte_count);
	SVT_INST[index_val].svt_ethernet_drv.Bfm.do_cmd(cmd, address, byte_count);
endtask

task vip_do_drv_pkt (input [7:0] idx, input [7:0] data);
	SVT_INST[index_val].svt_ethernet_drv.Bfm.do_pkt(idx,data);
endtask 

endclass



vip_test_suite_element vip_test_suite_element_h = new();
initial vip_test_suite_inst[index_val] = vip_test_suite_element_h;

end: VIP_TESTSUITE

