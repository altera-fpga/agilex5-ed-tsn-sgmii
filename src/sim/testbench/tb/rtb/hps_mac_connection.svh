
//logic reconfig_reset_ip0 = 0;

altera_avalon_st_if#(
	   `ALTUVM_AVALON_ST_INF_TB_PARAM_INST_10G, 
		.ST_SYMBOL_W(ST_SYMBOL_W_10G) 
		) tx_avst_if [NUM_PHY] (.clk(mac_clk), .reset(tx_avst_if_reset));


    generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin
         //assign tx_avst_if[n].clk               = mac_clk;
         //assign tx_avst_if[n].reset             = tx_avst_if_reset;
         assign tx_avst_if[n].ready             = avalon_st_tx_ready[n];
         assign avalon_st_tx_startofpacket[n]   = tx_avst_if[n].startofpacket;
         assign avalon_st_tx_endofpacket[n]     = tx_avst_if[n].endofpacket;
         assign avalon_st_tx_valid[n]           = tx_avst_if[n].valid;
         assign avalon_st_tx_empty[n]           = tx_avst_if[n].empty;
         assign avalon_st_tx_data[n]            = tx_avst_if[n].data;
         assign tx_skip_crc[n]                  = tx_avst_if[n].channel[0];
      end
   endgenerate
   
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin : avst_tx_rtb_ip
         altuvm_avalon_st_rtb#(
			       `ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_10G, 
			       `altuvm_avalon_st_symbol_param_inst(avst),
			       .ST_SYMBOL_W(ST_SYMBOL_W_10G), 
			       .IS_ACTIVE(UVM_ACTIVE),
			       .BFM_TYPE(altuvm_avalon_st_pkg::AVALON_ST_SOURCE)
			       ) avst_tx_rtb_ip (.uif(tx_avst_if[n] ));
	      initial begin
	         uvm_config_db#(string)::set(uvm_root::get(),$psprintf("*env_ip%0d", n),"avst_tx_rtb_path",$psprintf("avst_tx_rtb_ip[%0d].avst_tx_rtb_ip", n));
            avst_tx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_error(0);     
            avst_tx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_error_in_middle_of_packet(0);     
            avst_tx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_packet_with_idles(0);     
            avst_tx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_transaction_after_reset(0);
            force avst_tx_rtb_ip.source.u.u_bfm.response_timeout=500000;
            //Setting AVST driver idle signal driving to 0
            avst_tx_rtb_ip.source.u.u_bfm.set_idle_state_output_configuration(0);
	      end
      end
   endgenerate

   
   //****************************************************************************************

   altera_avalon_st_if#(
			      `ALTUVM_AVALON_ST_INF_TB_PARAM_INST_10G, 
			      .ST_SYMBOL_W(ST_SYMBOL_W_10G) 
			      ) rx_avst_if[NUM_PHY] (.clk(mac_clk), .reset(rx_avst_if_reset));
               

   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin
         //assign rx_avst_if[n].clk               = mac_clk;
         //assign rx_avst_if[n].reset             = rx_avst_if_reset;
         assign rx_avst_if[n].valid             = avalon_st_rx_valid[n];
         assign rx_avst_if[n].startofpacket     = avalon_st_rx_startofpacket[n];
         assign rx_avst_if[n].endofpacket       = avalon_st_rx_endofpacket[n];
         assign rx_avst_if[n].data              = avalon_st_rx_data[n];
         assign rx_avst_if[n].ready             = avalon_st_rx_ready[n];
         assign rx_avst_if[n].empty             = avalon_st_rx_empty[n];
         assign rx_avst_if[n].error             = avalon_st_rx_error[n];
      end
   endgenerate
   
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin : avst_rx_rtb_ip
         altuvm_avalon_st_rtb#(
			       `ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_10G, 
			       `altuvm_avalon_st_symbol_param_inst(avst),
			       .ST_SYMBOL_W(ST_SYMBOL_W_10G), 
			       .IS_ACTIVE(UVM_PASSIVE),
			       .BFM_TYPE(altuvm_avalon_st_pkg::AVALON_ST_MONITOR)
			       ) avst_rx_rtb_ip (.uif (rx_avst_if[n])
					      );

         initial begin
	         uvm_config_db#(string)::set(uvm_root::get(),$psprintf("*env_ip%0d", n),"avst_rx_rtb_path", $psprintf("avst_rx_rtb_ip[%0d].avst_rx_rtb_ip", n));
            avst_rx_rtb_ip.monitor.u_bfm.monitor_assertion.enable_a_non_missing_endofpacket   = 0;
            avst_rx_rtb_ip.monitor.u_bfm.monitor_assertion.set_enable_a_no_data_outside_packet(0);
            //AVST RX covergroup
            avst_rx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_transaction_after_reset(0);
            avst_rx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_valid_non_ready(0);
            avst_rx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_non_valid_non_ready(0);
            avst_rx_rtb_ip.monitor.u_bfm.monitor_coverage.set_enable_c_packet_with_back_pressure(0);
	      end
      end
   endgenerate

   //*************************************************************************************************************

   altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_mac[NUM_PHY] (.clk(csr_clk), .reset(csr_reset));
   
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin
         //assign avmm_if_mac[n].clk                 = csr_clk;
         //assign avmm_if_mac[n].reset               = csr_reset;
         assign csr_mac_write[n]                   = avmm_if_mac[n].write;
         assign csr_mac_read[n]                    = avmm_if_mac[n].read;
         assign csr_mac_address[n]                 = {3'b0,avmm_if_mac[n].address[17:2]};
         //assign reconfig_eth_mac_byteenable_ip0    = avmm_if_mac[n].byteenable;
         assign csr_mac_writedata[n]               = avmm_if_mac[n].writedata;
         assign avmm_if_mac[n].readdata            = csr_mac_readdata[n];
         assign avmm_if_mac[n].waitrequest         = csr_mac_waitrequest[n];
         assign avmm_if_mac[n].readdatavalid       = ~csr_mac_waitrequest[n];
      end
   endgenerate
   
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin : avmm_mac_rtb_ip 
         altuvm_avalon_mm_rtb #(
                  `AVMM_CFG_SHARED_INF_INST,
                  .IS_ACTIVE(UVM_ACTIVE),
                  .BFM_TYPE(altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
                              ) avmm_mac_rtb_ip (.uif(avmm_if_mac[n]));

         initial begin
         uvm_config_db#(string)::set(uvm_root::get(),$psprintf("*env_ip%0d", n),"avmm_mac_rtb_path", $psprintf("avmm_mac_rtb_ip[%0d].avmm_mac_rtb_ip", n));
         uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,$psprintf("*env_ip%0d", n),"status_mac_if",avmm_if_mac[0]);
         avmm_mac_rtb_ip.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
         avmm_mac_rtb_ip.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
         avmm_mac_rtb_ip.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0;
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	      avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	      avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);              
         avmm_mac_rtb_ip.master.u.u_bfm.set_idle_state_output_configuration(0);
         avmm_mac_rtb_ip.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
         repeat (10) @(posedge csr_clk);
         avmm_mac_rtb_ip.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
         end
      end
   endgenerate

   //*************************************************************************************************************
   // csr intf coming out from HPS
   
   altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if[NUM_PHY](.clk(csr_clk), .reset(csr_reset));
   
   initial begin
      //assign avmm_if.clk                     = csr_clk;
      //assign avmm_if.reset                   = csr_reset;
      /*
      force mm_bridge_0_m0_write            = avmm_if.write;
      force mm_bridge_0_m0_read             = avmm_if.read;
      force mm_bridge_0_m0_address          =  {3'b0,avmm_if.address[17:2]};
      force mm_bridge_0_m0_byteenable       = avmm_if.byteenable;
      force mm_bridge_0_m0_writedata        = avmm_if.writedata;
      assign avmm_if.readdata                = mm_bridge_0_m0_readdata;
      assign avmm_if.waitrequest             = mm_bridge_0_m0_waitrequest;    
      assign avmm_if.readdatavalid           = ~mm_bridge_0_m0_waitrequest;
      */
   end
   
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin : avmm_phy_rtb_ip
         altuvm_avalon_mm_rtb #(
            `AVMM_CFG_SHARED_INF_INST,		
			   .IS_ACTIVE                 (UVM_ACTIVE),
			   .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
			  ) avmm_rtb_ip0 (.uif(avmm_if[n]));

      initial begin
         uvm_config_db#(string)::set(uvm_root::get(),$psprintf("*env_ip%0d", n),"avmm_rtb_path", $psprintf("avmm_phy_rtb_ip[%0d].avmm_rtb_ip0", n));
      //uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","avmm_rtb_path","avmm_rtb_ip0");
      uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,$psprintf("*env_ip%0d*", n),"status_if",avmm_if[n]);
      avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
      avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
      avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_read_response_timeout = 0;
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
	   avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
	   avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
      avmm_rtb_ip0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);              
      avmm_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);              
      avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
      avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =1;
      end
   end
   endgenerate

   //*************************************************************************************************************
   
   svt_axi_if axi_if_i();
   
   initial begin
   force awid                             =  axi_if_i.master_if[0].awid;
   force awaddr                           =  axi_if_i.master_if[0].awaddr;
   force awlen                            =  axi_if_i.master_if[0].awlen;
   force awsize                           =  axi_if_i.master_if[0].awsize;
   force awburst                          =  axi_if_i.master_if[0].awburst;
   force awlock                           =  axi_if_i.master_if[0].awlock;
   force awcache                          =  axi_if_i.master_if[0].awcache;
   force awprot                           =  axi_if_i.master_if[0].awprot;
   force awvalid                          =  axi_if_i.master_if[0].awvalid;
   force wdata                            =  axi_if_i.master_if[0].wdata;
   force wstrb                            =  axi_if_i.master_if[0].wstrb;
   force wlast                            =  axi_if_i.master_if[0].wlast;
   force wvalid                           =  axi_if_i.master_if[0].wvalid;
   force bready                           =  axi_if_i.master_if[0].bready;
   force arid                             =  axi_if_i.master_if[0].arid;
   force araddr                           =  axi_if_i.master_if[0].araddr;
   force arlen                            =  axi_if_i.master_if[0].arlen;
   force arsize                           =  axi_if_i.master_if[0].arsize;
   force arburst                          =  axi_if_i.master_if[0].arburst;
   force arlock                           =  axi_if_i.master_if[0].arlock;
   force arcache                          =  axi_if_i.master_if[0].arcache;
   force arprot                           =  axi_if_i.master_if[0].arprot;
   force arvalid                          =  axi_if_i.master_if[0].arvalid;
   force rready                           =  axi_if_i.master_if[0].rready;
   end
   assign axi_if_i.common_aclk            =  csr_clk;
   assign axi_if_i.master_if[0].aclk      =  csr_clk;
   assign axi_if_i.master_if[0].aresetn   =  ~csr_reset;
   /*
   force awid                             =  axi_if_i.master_if[0].awid;
   force awaddr                           =  axi_if_i.master_if[0].awaddr;
   force awlen                            =  axi_if_i.master_if[0].awlen;
   force awsize                           =  axi_if_i.master_if[0].awsize;
   force awburst                          =  axi_if_i.master_if[0].awburst;
   force awlock                           =  axi_if_i.master_if[0].awlock;
   force awcache                          =  axi_if_i.master_if[0].awcache;
   force awprot                           =  axi_if_i.master_if[0].awprot;
   force awvalid                          =  axi_if_i.master_if[0].awvalid;
   */
   assign axi_if_i.master_if[0].awready   =  awready;
   /*
   force wdata                            =  axi_if_i.master_if[0].wdata;
   force wstrb                            =  axi_if_i.master_if[0].wstrb;
   force wlast                            =  axi_if_i.master_if[0].wlast;
   force wvalid                           =  axi_if_i.master_if[0].wvalid;
   */
   assign axi_if_i.master_if[0].wready    =  wready;
   assign axi_if_i.master_if[0].bid       =  bid;
   assign axi_if_i.master_if[0].bresp     =  bresp;
   assign axi_if_i.master_if[0].bvalid    =  bvalid;
   /*
   force bready                           =  axi_if_i.master_if[0].bready;
   force arid                             =  axi_if_i.master_if[0].arid;
   force araddr                           =  axi_if_i.master_if[0].araddr;
   force arlen                            =  axi_if_i.master_if[0].arlen;
   force arsize                           =  axi_if_i.master_if[0].arsize;
   force arburst                          =  axi_if_i.master_if[0].arburst;
   force arlock                           =  axi_if_i.master_if[0].arlock;
   force arcache                          =  axi_if_i.master_if[0].arcache;
   force arprot                           =  axi_if_i.master_if[0].arprot;
   force arvalid                          =  axi_if_i.master_if[0].arvalid;
   */
   assign axi_if_i.master_if[0].arready   =  arready;
   assign axi_if_i.master_if[0].rid       =  rid;
   assign axi_if_i.master_if[0].rdata     =  rdata;
   assign axi_if_i.master_if[0].rresp     =  rresp;
   assign axi_if_i.master_if[0].rlast     =  rlast;
   assign axi_if_i.master_if[0].rvalid    =  rvalid;
   //force rready                           =  axi_if_i.master_if[0].rready;

   initial begin
      uvm_config_db#(virtual svt_axi_if)::set(uvm_root::get(),"*top_env.m_axi_st_env*", "vif", axi_if_i);
      uvm_config_db#(svt_axi_vif)::set(uvm_root::get(), {IP_PATH,"*"}, "axi_vif", axi_if_i);
   end

   //*************************************************************************************************************
   
   generate
      genvar n;
      for (n=0; n<NUM_PHY; n++) begin
         initial begin
            force mac_speed[n] = 'h1;
         end
      end
   endgenerate

   
/*
   initial begin
      assign reconfig_reset_ip0 =  0;//reset_if_ip0.reconfig_rst_n;
      #500ns;
      assign reconfig_reset_ip0 =  1;//~reset_if_ip0.reconfig_rst_n;
   end
   */
