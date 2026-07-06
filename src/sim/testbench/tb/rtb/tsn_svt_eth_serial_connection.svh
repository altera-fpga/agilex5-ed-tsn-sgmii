   /*
   svt_ethernet_txrx_if svt_ethernet_txrx_if[NUM_INST](reference_clk);
   svt_ethernet_txrx_if uif_pcs66[NUM_INST](reference_clk); 
   eth_testsuite_tasks_intf ts_tasks_if[NUM_INST]();
   */
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin : eth_serial
         assign svt_ethernet_txrx_if[n].rx_lane[`NUM_LANES_IP0-1:0]  = pp_app_tx_serial_data[n];  
         assign app_pp_rx_serial_data[n] = svt_ethernet_txrx_if[n].tx_lane[`NUM_LANES_IP0-1:0]; 
         assign app_pp_rx_serial_data_n[n] = ~app_pp_rx_serial_data[n];

         svt_ethernet_xxm_bfm_driver svt_ethernet_drv(svt_ethernet_txrx_if[n]); 
         svt_ethernet_xxm_mon_chk_driver svt_ethernet_mon_chk(svt_ethernet_txrx_if[n]);

         defparam svt_ethernet_mon_chk.ETH_JUMBO_FRAME_SIZE=70000; 
         defparam svt_ethernet_drv.ETH_JUMBO_FRAME_SIZE=70000;
         assign svt_ethernet_txrx_if[n].reset = svt_reset[n];

         initial begin
            ts_tasks_if[n].ip = 0; 
            uvm_config_db#(virtual eth_testsuite_tasks_intf)::set(uvm_root::get(),$psprintf("*env_ip%0d", n),"ts_tasks_if",ts_tasks_if[n]);
            uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),$psprintf("*env_ip%0d", n), "if_port", svt_ethernet_txrx_if[n]);
         end
      end
   endgenerate

