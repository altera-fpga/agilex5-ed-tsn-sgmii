


// START COMMON-TAIL

// Generated DUT top instance, sample dut_top instance for single 25G

// end DUT top instance

 initial
 begin
    //Shabbir: Start dumping after pcs_rx_ready
    if($test$plusargs("en_dump_later")) begin
      $display($time,"en_dump_later");
      `ifdef CR3TOP_SIMPLE_SERDES
      #108000ns;
      `else
      #453000ns;
      `endif
      $display($time,"en_dump_later:enabling dump");
    end
    if ($test$plusargs("wait_pcs_dump"))
      wait (spy_if_ip0.rx_pcs_ready==1);

    `ifdef DUMP_ON
       $vcdpluson();
    `endif
    `ifdef FSDB_ON
       //fsdb dumping options
       $fsdbDumpvars("+all");
       `ifdef RESET_DUMP_OFF
         wait(eth_env_top.reset_if_ip0.csr_rst_n==0)
         $fsdbDumpoff;
         wait(eth_env_top.reset_if_ip0.csr_rst_n==1)
         $fsdbDumpon;
       `endif	 
     `endif 
 end // initial begin

 initial begin
   run_test();
 end
 
endmodule: eth_env_top

`endif // ETH_ENV_TOP__SV

