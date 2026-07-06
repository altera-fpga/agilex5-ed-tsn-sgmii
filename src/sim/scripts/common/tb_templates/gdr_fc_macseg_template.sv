

   wire [7:0] 	tx_pfc_ip0;
   wire         tx_pause_ip0;
   wire [7:0] 	rx_pfc_ip0;
   wire      	  rx_pause_ip0;

eth_fc_interface eth_fc_if_ip0 (clk_pll_ip0,reset_ip0); 

	  assign tx_pfc_ip0                    = eth_fc_if_ip0.tx_pfc;
	  assign tx_pause_ip0                  = eth_fc_if_ip0.tx_sfc;
	  assign eth_fc_if_ip0.rx_pfc          = rx_pfc_ip0;
	  assign eth_fc_if_ip0.rx_sfc          = rx_pause_ip0;

assign eth_fc_if_ip0.rx_pcs_ready = eth_sideband_if_ip0.rx_pcs_ready;
assign eth_fc_if_ip0.speed= spy_if_ip0.speed;
assign eth_fc_if_ip0.o_rx_valid= spy_if_ip0.o_rx_valid;
assign eth_fc_if_ip0.stop_flow= spy_if_ip0.stop_flow;
assign eth_fc_if_ip0.startofpacket=seg_tx_if_ip0.found_sop;
assign eth_fc_if_ip0.endofpacket=seg_tx_if_ip0.found_eop;
assign eth_fc_if_ip0.ready=seg_tx_if_ip0.rdy;

        initial begin
            uvm_config_db #(virtual eth_fc_interface)::set(uvm_root::get() ,"*env_ip0", "mst_if",eth_fc_if_ip0);
            uvm_config_db #(virtual eth_fc_interface)::set(uvm_root::get() ,"*env_ip0", "slv_if",eth_fc_if_ip0);
         end

/*

 // DUT expected port connection

 		.i_tx_pfc(tx_pfc_ip0), 					
		.o_rx_pfc(rx_pfc_ip0)
		.i_tx_pause(tx_pause_ip0), 					
		.o_rx_pause(rx_pause_ip0),

*/

