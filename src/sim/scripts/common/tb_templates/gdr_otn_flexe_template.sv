
//-----------------------------------------------------------------------------
// start DUT <NUM_INST> var
//-----------------------------------------------------------------------------
logic		     pcs66_txdata_valid_hack_ip0;
logic                pcs66_tx_vld_ip0;
logic                pcs66_tx_rdy_ip0;
logic                pcs66_tx_am_insert_ip0=0;
logic [1055:0]        pcs66_tx_data_ip0;
logic                pcs66_avst_tx_am_insert_ip0; 
logic                o_avst_am_insert_ip0;
logic [1055:0]        pcs66_data_x4_ip0;
logic                pcs66_data_x4_valid_ip0;
logic [5:0]           avst_latency_ip0;
logic [1055:0]       o_avst_data_tagger_in_ip0;
logic                pcs66_rx_vld_ip0;
logic                pcs66_rx_am_ip0;
logic [1055:0]        pcs66_rx_data_ip0;
logic [1055:0]        o_avst_data_ip0;
logic                o_avst_valid_ip0;
logic [1055:0]        otn_am_insert_dout_ip0;
logic                otn_am_insert_dout_vld_ip0;
logic                otn_am_ip0;
logic                p2h_ch0_pld_pcs_tx_clk_out_x1_ip0;
logic                i_clk_a_ip0;
logic                i_clk_b_ip0;
logic                clk_status_ip0;
wire 	             tx_tod_clk;
wire 	             rx_tod_clk; 
logic                reset_ip0;
wire 	             rx_pcs_ready_ip0;
wire 	             tx_lanes_stable_ip0;
wire 		     rx_pcs_fully_aligned_ip0; 
wire 		     rx_hi_ber_ip0;            
wire 		     rx_am_lock_ip0;            
wire 		     local_fault_status_ip0;            
wire 		     remote_fault_status_ip0;            
reg  	             stats_snapshot_ip0;
wire  	             rx_block_lock_ip0;              
wire                 clk_ip0;
wire                 clk_tx_ip0;
wire                 clk_rx_ip0;
wire                 reconfig_clk_ip0;
wire                 clk_pll_ip0;
logic                clk_ref_ip0=0;       
logic                clk_sys_ip0=0;   
logic                gearbox_tx_reset_a_ip0;     
reg                  rst_n_ip0;
wire                 rst_ack_n_ip0;
reg                  tx_rst_n_ip0;
wire                 tx_rst_ack_n_ip0;
reg  	             rx_rst_n_ip0;
wire                 rx_rst_ack_n_ip0;
logic                 reconfig_reset_ip0;    
wire 		     tx_pll_locked_ip0;    
wire 		     cdr_locked_ip0;    
reg                  custom_cadence_ip0;
wire                 i_clk_sys;
reg  	             reconfig_eth_write_ip0;         
reg  	             reconfig_eth_read_ip0;          
reg [19:0]           reconfig_eth_addr_ip0;       
reg [31:0]           reconfig_eth_writedata_ip0;     
reg  [3:0]           reconfig_eth_byteenable_ip0;         
wire [31:0]           reconfig_eth_readdata_ip0;      
wire 	             reconfig_eth_waitrequest_ip0;   
wire 	             reconfig_eth_readdatavalid_ip0; 
reg  	             reconfig_xcvr0_write_ip0;         
reg  	             reconfig_xcvr0_read_ip0;
reg  [3:0]           reconfig_xcvr0_byteenable_ip0;
reg [19:0]           reconfig_xcvr0_address_ip0;       
reg [31:0]           reconfig_xcvr0_writedata_ip0;     
wire [31:0]          reconfig_xcvr0_readdata_ip0;
wire 	             reconfig_xcvr0_waitrequest_ip0;   
wire 	             reconfig_xcvr0_readdata_valid_ip0; 

logic [1055:0]       rxdata_queue_ip0[$];
logic [1055:0]       gearbox_rx_data_ip0;
logic                gearbox_rx_valid_ip0;
logic [1055:0]       buffer_rx_data_ip0;
logic                buffer_rx_valid_ip0=0;
logic                xgmii66_rx_valid_ip0;
logic                cfg_half_width;  
logic                i_pop_ip0=0;

//-----------------------------------------------------------------------------
// end DUT port wires
//-----------------------------------------------------------------------------
`include "basic_test_params_ip0.v"
//`define CR3_EHIP_CORE_IP0 dut.top.ip0.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.die_specific_inst.x_ehip_core //[fixme][TODO]
   assign i_clk_sys = clk_sys_ip0;
   always begin #500ps clk_sys_ip0 = ~clk_sys_ip0;
   force eth_env_top.dut.ip0.top_ip0.i_src_ip_clk = clk_sys_ip0;
   end
//---------------------------------------------------------------------------
//  UVC Instances
//---------------------------------------------------------------------------

  altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_ip0 (
	 		     .clk                       (clk_status_ip0),
	 		     .reset                     (reset_ip0)
	 		     );

  altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,		
	 	  .IS_ACTIVE                 (UVM_ACTIVE),
	 	  .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
	 	  ) avmm_rtb_ip0 (.uif(avmm_if_ip0));

  initial begin
      uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,"*env_ip0*","status_if",avmm_if_ip0);
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_rtb_path","avmm_rtb_ip0");
  end
   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 (
	 		            .clk                       (clk_status_ip0),
	 		            .reset                     (reset_ip0)
               );
   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,
           .IS_ACTIVE                 (UVM_ACTIVE),
           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
               ) avmm_xcvr_rtb_ip0_0 (.uif(avmm_xcvr_if_ip0_0));
  
  initial begin        
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");
  end            

  reset_if       reset_if_ip0();
  vector_uvc_interface       eth_vector_rx_if_ip0(clk_pll_ip0,reset_ip0);
  eth_sideband_interface eth_sideband_if_ip0(.rst(reset_ip0),
                                              .clk(clk_pll_ip0),
                                              .tx_tod_clk(tx_tod_clk),
                                              .rx_tod_clk(rx_tod_clk));
  spy_interface #(.IP("ip0")) spy_if_ip0(); // ALEX new: #(.IP("ip<i>)), for INST[i] which needs OTN/FLEXE template

  initial begin
      uvm_config_db #(virtual reset_if)::set (null, "*env_ip0", "slv_if", reset_if_ip0); 
      uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "mst_if",eth_sideband_if_ip0); 
      uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "slv_if",eth_sideband_if_ip0); 
      uvm_config_db #(virtual vector_uvc_interface)::set(uvm_root::get(), "*env_ip0.rx_vector_agent*","vector_if",eth_vector_rx_if_ip0); //DSAM:not required,plz check
      `ifndef NON_ANLT_PTP 
         uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"*ts_component0*", "if_directed", directed_if[0]); //DSAM
       `endif
      uvm_config_db #(v_if2)::set (null, "*env_ip0", "spy_interface", spy_if_ip0); 
  end

  if(`phy_refclk_ip0 == 0 || `phy_refclk_ip0 == 156.250000) always #3200 clk_ref_ip0 = ~clk_ref_ip0;                
  if(`phy_refclk_ip0 == 1 || `phy_refclk_ip0 == 322.265625) always #1551.51515 clk_ref_ip0 = ~clk_ref_ip0;
  if(`phy_refclk_ip0 == 2 || `phy_refclk_ip0 == 312.500000) always #1600 clk_ref_ip0 = ~clk_ref_ip0;
  if(`phy_refclk_ip0 == 3 || `phy_refclk_ip0 == 644.531250) always #775.757575  clk_ref_ip0 = ~clk_ref_ip0;
  
  `ifdef FAST_CLK
       `ifdef PTP_EN
  	always begin #5000ps clk_status_ip0= ~clk_status_ip0;    end
       `else
         always begin #500ps clk_status_ip0= ~clk_status_ip0;    end
       `endif
  `else
  	always begin #5ns clk_status_ip0= ~clk_status_ip0;    end
  `endif
  `ifdef PTP_EN
    assign tx_tod_clk = eth_env_top.dut.i_clk_tx_tod_ip0;
    assign rx_tod_clk = eth_env_top.dut.i_clk_rx_tod_ip0;
  `else
    assign tx_tod_clk = 1'b0;
    assign rx_tod_clk = 1'b0;
  `endif

  assign reconfig_clk_ip0   = clk_status_ip0;
  assign clk_ip0            = clk_pll_ip0;
  assign reset_ip0          = ~reset_if_ip0.csr_rst_n;
  assign reset_if_ip0.clock = clk_status_ip0;
  assign clk_rx_ip0         = clk_pll_ip0;
  assign clk_tx_ip0         = clk_pll_ip0;
  assign rst_n_ip0          = reset_if_ip0.csr_rst_n;
  assign tx_rst_n_ip0       = reset_if_ip0.tx_rst_n;
  assign rx_rst_n_ip0       = reset_if_ip0.rx_rst_n;
  
  assign reset_if_ip0.rst_ack_n = rst_ack_n_ip0; 
  assign reset_if_ip0.tx_rst_ack_n = tx_rst_ack_n_ip0; 
  assign reset_if_ip0.rx_rst_ack_n = rx_rst_ack_n_ip0;

  //********************************************************//
  //drajasek-toggling this reset to reset the soft CSRs
  initial begin
    assign reconfig_reset_ip0 =  reset_if_ip0.reconfig_rst_n;
    #500ns;
    assign reconfig_reset_ip0 =  ~reset_if_ip0.reconfig_rst_n;
  end  
  //*****************************************************//
  bit 				    soft_reset_ip0;
  bit[31:0] REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0; //HSD 16013095102
  assign REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_ip0.address[17:0] == `REGISTERS_eth_reset_OFFSET_REG) && (avmm_if_ip0.write == 1'b1)) ? avmm_if_ip0.writedata : REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
  assign  soft_reset_ip0 =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
  assign spy_if_ip0.eio_soft_rst =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
  assign spy_if_ip0.tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[1];
  assign spy_if_ip0.rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[2];     
  
  assign spy_if_ip0.o_rx_hi_ber = rx_hi_ber_ip0;
  assign spy_if_ip0.rx_am_lock = rx_am_lock_ip0;
  assign spy_if_ip0.rx_block_lock = rx_block_lock_ip0;
  assign spy_if_ip0.rx_pcs_ready = rx_pcs_ready_ip0;
  assign spy_if_ip0.soft_reset = soft_reset_ip0;
  assign spy_if_ip0.clk                  = clk_ref_ip0;
  assign spy_if_ip0.rx_dsk_done     = eth_env_top.dut.ip0.top_ip0.sip_inst.ehip_rx_dsk_done ;
  assign spy_if_ip0.gearbox_valid   = (spy_if_ip0.speed == _10G || spy_if_ip0.speed == _40G) ? xgmii66_rx_valid_ip0 : buffer_rx_valid_ip0; 
  assign spy_if_ip0.o_tx_ready      = eth_env_top.dut.ip0.top_ip0.sip_inst.o_tx_pcs66_ready ;
   //GDR_RX/TX_MAC connections
   assign spy_if_ip0.rf_status		= remote_fault_status_ip0;
   assign spy_if_ip0.lf_status		= local_fault_status_ip0;
   //assign spy_if_ip0.fault          = remote_fault_status_ip0 | local_fault_status_ip0;

  `ifndef PTP_EN
    //assign spy_if_ip0.tx_pll_locked   = eth_env_top.dut.ip0.top_ip0.sip_inst.xcvr_txpll_locked[3:0];
    //assign spy_if_ip0.cdr_lock        = eth_env_top.dut.ip0.top_ip0.sip_inst.xcvr_rxcdr_locked[3:0];
    assign spy_if_ip0.tx_pll_locked   = eth_env_top.dut.ip0.top_ip0.sip_inst.tx_pll_locked_csr[7:0];
    assign spy_if_ip0.cdr_lock        = eth_env_top.dut.ip0.top_ip0.sip_inst.eiofreq_lock_csr[7:0];
  `endif
  assign custom_cadence_ip0         = eth_sideband_if_ip0.custom_cadence;
  assign stats_snapshot_ip0         = eth_sideband_if_ip0.snapshot_en;
  assign eth_sideband_if_ip0.tx_lane_stable = tx_lanes_stable_ip0;
  assign eth_sideband_if_ip0.rx_pcs_ready   = rx_pcs_ready_ip0;

  assign reconfig_eth_write_ip0           = avmm_if_ip0.write;
  assign reconfig_eth_read_ip0            = avmm_if_ip0.read;
  assign reconfig_eth_addr_ip0         = {3'b0,avmm_if_ip0.address[17:2]};
  assign reconfig_eth_byteenable_ip0      = avmm_if_ip0.byteenable;
  assign reconfig_eth_writedata_ip0       = avmm_if_ip0.writedata;
  assign avmm_if_ip0.readdata             = reconfig_eth_readdata_ip0;
  assign avmm_if_ip0.waitrequest          = reconfig_eth_waitrequest_ip0;    
  assign avmm_if_ip0.readdatavalid        = reconfig_eth_readdatavalid_ip0;
  
  // scaled based on number of phy channels
    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;
    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;
    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;
    assign reconfig_xcvr0_address_ip0         = {3'b0,avmm_xcvr_if_ip0_0.address[17:2]};
    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;
    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;
    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    
    assign avmm_xcvr_if_ip0_0.readdatavalid    = reconfig_xcvr0_readdata_valid_ip0;
//---------------------------------------------------------------------------
//  SVT Instances 
//---------------------------------------------------------------------------
  `ifdef ENABLE_ETH_VIP
     svt_ethernet_xxm_bfm_driver svt_ethernet_drv_0(svt_ethernet_txrx_if[0]);
     svt_ethernet_xxm_mon_chk_driver svt_ethernet_mon_chk_0(svt_ethernet_txrx_if[0]);
 
     initial begin
       ts_tasks_if[0].ip = 0; //ALEX new: ts_task_if[i].ip = i, for INST[i] which needs OTN/FLEXE template
       uvm_config_db#(virtual eth_testsuite_tasks_intf)::set(uvm_root::get(),"*env_ip0","ts_tasks_if",ts_tasks_if[0]);
       uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),"*env_ip0", "if_port", svt_ethernet_txrx_if[0]);
       uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),"*env_ip0", "pcs_tx_if_port", uif_pcs66[0]);

       spy_if_ip0.event_mac_idle_detected_rx           = svt_ethernet_mon_chk_0.Chk.event_mac_idle_detected_rx; 
       ts_tasks_if[0].event_10g_multilane_insert_align_block = svt_ethernet_drv_0.Bfm.multilane_10g.event_insert_align_block; 
       ts_tasks_if[0].event_10g_multilane_insert_66b_block   = svt_ethernet_drv_0.Bfm.event_10g_multilane_insert_66b_block;   
       ts_tasks_if[0].event_load_align_marker_error = svt_ethernet_drv_0.Bfm.event_load_align_marker_error;
       ts_tasks_if[0].event_xsbi_66b_block_loaded = svt_ethernet_drv_0.Bfm.event_xsbi_66b_block_loaded; // added for pcs_err_druing_lock sequence 25G
       ts_tasks_if[0].event_insert_xxvsbi_align_marker    = svt_ethernet_drv_0.Bfm.event_insert_xxvsbi_align_marker; //added for pcs_wrong_am_interval sequence 25G
       spy_if_ip0.event_chk_no_eop_tx                  = svt_ethernet_mon_chk_0.Chk.event_chk_no_term_char_found_tx;
     end

     svt_ethernet_xxm_bfm_driver svt_ethernet_drv_otn_flexe_0(uif_pcs66[0]);
     svt_ethernet_xxm_mon_chk_driver svt_ethernet_mon_chk_otn_flexe_0(uif_pcs66[0]);
 
     always @(reset_if_ip0.csr_rst_n or soft_reset_ip0 or reset_if_ip0.vip_rst or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or spy_if_ip0.tx_soft_rst or spy_if_ip0.rx_soft_rst)
     begin
        `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);
        svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | soft_reset_ip0 | reset_if_ip0.vip_rst | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | spy_if_ip0.tx_soft_rst | spy_if_ip0.rx_soft_rst);  
        uif_pcs66[0].reset            = (~reset_if_ip0.csr_rst_n | soft_reset_ip0 | reset_if_ip0.vip_rst | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | spy_if_ip0.tx_soft_rst | spy_if_ip0.rx_soft_rst);  
     end
  `endif

   always @(tx_lanes_stable_ip0 or reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
    begin
       assertion_on_off_reset[0] = (~tx_lanes_stable_ip0 | ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0); 
    end
/*added below logic in spy_if to support dyn rcfg*/
  initial begin  /*[TODO] muralasx: temp values, should be updated with actual values*/
    spy_if_ip0.gear       = 1;       //Kanishk-Note: 1 for 10/25G, 2 for 40/50G, 4 for 100G, 8 for 200G and 16 for 400G
    spy_if_ip0.tx_freq    = 390.625; //Kanishk-Note: 156.25 for 10G, 390.625 for 25G, 625 for 40G, 781.25 for 50G, 1562.5 for 100G, 3125 for 200G and 7250 for 400G
    spy_if_ip0.rx_freq    = 390.625; //Kanishk-Note: 156.25 for 10G, 390.625 for 25G, 312.5 for 40G, 390.625 for 50G, 390.625 for 100G, 390.625 for 200G and 390.625 for 400G
    #1;     //Just to take the value from spy if
    if(spy_if_ip0.fec_type inside {RSFECKP, LLFEC, RSFECKR}) begin
     spy_if_ip0.am_ins_cnt = (spy_if_ip0.speed == _25G) ? 1280:
                             (spy_if_ip0.speed == _50G) ? 640:
                             (spy_if_ip0.speed == _100G)? 1280:
                             (spy_if_ip0.speed == _200G)? 640:
                             (spy_if_ip0.speed == _400G)? 640:1280;
     spy_if_ip0.am_ins_cyc = (spy_if_ip0.speed == _25G) ? 4:
                             (spy_if_ip0.speed == _50G) ? 2:
                             (spy_if_ip0.speed == _100G)? 5:
                             (spy_if_ip0.speed == _200G)? 2:
                             (spy_if_ip0.speed == _400G)? 2:5;
    end
    else begin
     spy_if_ip0.am_ins_cnt = (spy_if_ip0.speed == _40G) ? 128:
                             (spy_if_ip0.speed == _50G) ? 512:
                             (spy_if_ip0.speed == _100G)? 1280:1280;
     spy_if_ip0.am_ins_cyc = (spy_if_ip0.speed == _40G) ? 2:
                             (spy_if_ip0.speed == _50G) ? 2:
                             (spy_if_ip0.speed == _100G)? 5:5;
    end
  end
  
 //---------------------------------------------------------------------------
 // Clocking blocks for internal signals that we use to drive/sample without
 // having a UVC for them
 //---------------------------------------------------------------------------
 clocking pcs66_drv_cb_ip0 @ (posedge clk_pll_ip0);
    inout pcs66_tx_am_insert_ip0;
    inout pcs66_tx_data_ip0;
    inout pcs66_tx_vld_ip0;
    inout pcs66_avst_tx_am_insert_ip0;
 endclocking : pcs66_drv_cb_ip0
 
 clocking pcs66_mon_cb_ip0 @ (posedge clk_pll_ip0);
    input pcs66_tx_rdy_ip0;
 endclocking : pcs66_mon_cb_ip0
 
 task drive_pcs66_am_insert_ip0();
    bit[31:0] tx_rdy_count=0;
    bit[31:0] am_insert_count;
    forever begin

       if((spy_if_ip0.speed inside {_10G,_25G}) && spy_if_ip0.fec_type == NOFEC) begin    
          //don't insert AM 
          //`uvm_info("am_insert",$sformatf("Inside 25G NOFEC mode"),UVM_NONE); 
          pcs66_drv_cb_ip0.pcs66_tx_am_insert_ip0 <= 0;
       end else begin   
          //if (~tx_lanes_stable_ip0) begin  //hold off on am_insert until tx deskew is done
          //   tx_rdy_count= 0;
          //   pcs66_drv_cb_ip0.pcs66_tx_am_insert_ip0 <= 0;
          //end else 
          if(pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0 == 1) begin
             tx_rdy_count++;
          end
 
          if(tx_rdy_count == spy_if_ip0.am_ins_cnt) begin //am_insert logic
             am_insert_count = 0;
             pcs66_drv_cb_ip0.pcs66_tx_am_insert_ip0 <= 1;
 
             while(am_insert_count < spy_if_ip0.am_ins_cyc) begin
                if(pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0 == 1) begin
                   am_insert_count++;
                   @(pcs66_mon_cb_ip0);
                   `uvm_info("drive_pcs66_am_insert", $sformatf("insert_am asserted AT TIME :%t, am_insert_count %d ", $time, am_insert_count), UVM_FULL)
 	        end
                else if(pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0 == 0) begin
                   @(pcs66_mon_cb_ip0);
                   `uvm_info("drive_pcs66_am_insert", $sformatf("insert_am: held AT TIME :%t, as rdy:%d is low, am_insert_count :%d", $time, pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0, am_insert_count), UVM_FULL)
 	        end
             end //while
 
             //Check whether shadow_vld is 0 If 0, then valid_count must hold its previous value until shadow_vld is 1
             if(pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0 !== 1) begin
                while(pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0 !== 1) begin
                   @(pcs66_mon_cb_ip0);
                end
                `uvm_info("drive_pcs66_am_insert", $sformatf("tx_rdy_count:%d held AT TIME :%t, as rdy:%d is low, am_insert_count :%d", tx_rdy_count, $time, pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0, am_insert_count), UVM_FULL)
                  end
 
             pcs66_drv_cb_ip0.pcs66_tx_am_insert_ip0 <= 0;
             am_insert_count = 0;
             tx_rdy_count = spy_if_ip0.am_ins_cyc;
          end
          //@(pcs66_mon_cb_ip0);
       end   
       @(pcs66_mon_cb_ip0);
    end
 
 endtask:drive_pcs66_am_insert_ip0
 
 initial begin
   fork
      drive_pcs66_am_insert_ip0();
   join_none
 end 

`ifdef ENABLE_ETH_VIP
 assign i_clk_a_ip0 = xgmii66_clk[0];    //[TODO] Need to port with actual clock
 `endif
 assign i_clk_b_ip0 = clk_pll_ip0; //o_clk_pll_div64_ip0; //[TODO] Need to port with actual clock  


`ifdef ENABLE_ETH_VIP
   always @ (posedge spy_if_ip0.clk) begin
     if(spy_if_ip0.initial_link_up_done == 0) //HSD: 16013092858
	     gearbox_tx_reset_a_ip0 = rx_pcs_ready_ip0;
     else
             gearbox_tx_reset_a_ip0 = tx_lanes_stable_ip0;
   end	     
   assign gearbox_rx_data_ip0 = (spy_if_ip0.speed == _10G || spy_if_ip0.speed == _40G) ? pcs66_rx_data_ip0 : buffer_rx_data_ip0;
   assign gearbox_rx_valid_ip0 = (spy_if_ip0.speed == _10G || spy_if_ip0.speed == _40G) ? (pcs66_rx_vld_ip0 && ~pcs66_rx_am_ip0) : buffer_rx_valid_ip0;

   flex_e_1toN_gearbox #(
			 .AWIDTH (11)       // depth of Rate-Match FIFO is 2^ADWIDTH -- test case is restricted to the inevitable overflow of this FIFO due to AM insertions
			 )
   u_flex_e_1toN_gearbox_tx_ip0 (
			     // bfm
			     .i_clk_a           (i_clk_a_ip0),
			     .i_rst_a_n         (gearbox_tx_reset_a_ip0), 
			     .i_bfm_data        (uif_pcs66[0].tx_lane[65:0] ),
			     .i_bfm_dvalid      (pcs66_txdata_valid_hack_ip0),   // Disable data while BFM outputs Zs
			     // dut
			     .i_clk_b           (i_clk_b_ip0),
			     .i_rst_b_n         (tx_lanes_stable_ip0),
			     .i_pop             (pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0 && ~pcs66_drv_cb_ip0.pcs66_tx_am_insert_ip0 ),  // stall for alignment marker insertion
      			     .source_freq_mhz   (spy_if_ip0.tx_freq),
      			     .gear              (spy_if_ip0.gear),
			     .o_data            (pcs66_data_x4_ip0),
			     .o_data_available  (pcs66_data_x4_valid_ip0),
			     .o_err_underflow   ( ),
			     .o_err_overflow    ( )   //
			     );

   flex_e_Nto1_gearbox  #(
			  .AWIDTH (15) //11)    // depth of Rate-Match FIFO is 2^AWIDTH
			  )
   u_flex_e_Nto1_gearbox_rx_ip0 (
			     // dut
			     .i_clk_a         (i_clk_b_ip0 ),
			     //   .i_clk_a         (clk.pcs64_66_clk),
			     .i_rst_a_n       (rx_pcs_ready_ip0),
			     //.i_data          (pcs66_rx_data_ip0) ,
			     //.i_dvalid        (pcs66_rx_vld_ip0 && ~pcs66_rx_am_ip0  ),  // drop AM cycles -  BFM cannot process AMs
			     .i_data          (gearbox_rx_data_ip0) ,
			     .i_dvalid        (gearbox_rx_valid_ip0),  // drop AM cycles -  BFM cannot process AMs
           		 .source_freq_mhz (spy_if_ip0.rx_freq),
           		 .gear            (spy_if_ip0.gear),
			 .i_pop           (i_pop_ip0),
			     // bfm
			     .i_clk_b         (i_clk_a_ip0),
			     .i_rst_b_n       (tx_lanes_stable_ip0),
			     .o_bfm_data      (uif_pcs66[0].rx_lane[65:0]),
			     .o_bfm_dvalid    (xgmii66_rx_valid_ip0  ),
			     .o_err_overflow  ( )
			     );
`endif

   assign avst_latency_ip0 = $urandom_range(1,25); //[TODO]
   assign #0.1 p2h_ch0_pld_pcs_tx_clk_out_x1_ip0 = clk_pll_ip0; //o_clk_pll_div64_ip0;

   flex_e_avst_tx_if # (
			)
   u_flex_e_avst_tx_if_ip0 (
			.i_clk            (p2h_ch0_pld_pcs_tx_clk_out_x1_ip0),
			.i_rst_n          (1),//(tx_lanes_stable_ip0),
			.i_avst_latency   (avst_latency_ip0),
			.i_avst_ready     (pcs66_mon_cb_ip0.pcs66_tx_rdy_ip0),
			.i_data_available (pcs66_data_x4_valid_ip0 ),
			.i_data_null      ({16{56'h0, 8'h1E, 2'b01}} ),       // send IDLEs when BFM data unavailable -- should only be necessary at start-up
			.i_data           (pcs66_data_x4_ip0),
			.i_am_insert      (pcs66_drv_cb_ip0.pcs66_tx_am_insert_ip0 ),
			// dut
			.o_am_insert      (o_avst_am_insert_ip0),
			.o_avst_data      (o_avst_data_ip0), 
			.o_avst_valid     (o_avst_valid_ip0) 
			);
//[TODO]
    assign o_avst_data_tagger_in_ip0 =  (spy_if_ip0.gear==1)? o_avst_data_ip0[1055 -:(1*66)]: 
                                        (spy_if_ip0.gear==2)? o_avst_data_ip0[1055 -:(2*66)]:
				                        (spy_if_ip0.gear==4)? o_avst_data_ip0[1055 -:(4*66)]:
				                        (spy_if_ip0.gear==8)? o_avst_data_ip0[1055 -:(8*66)]:
				                                              o_avst_data_ip0[1055 -:(16*66)] ;
   assign cfg_half_width_ip0 = ((spy_if_ip0.speed == _50G || spy_if_ip0.speed == _40G) && spy_if_ip0.mode ==OTN)? 1'b1 : 1'b0;   									      

             new_cr2ev0_c2_ehip_tx_tagger_5way #(
                   .VLANE_SET          (0)
               )
               u_otn_am_tagger_ip0 (
                   .i_clk              (clk_pll_ip0),
                   .i_cfg_half_width   (cfg_half_width_ip0),
                   .i_cfg_skip_tags    (1'b0),
                   .i_cfg_err_inj      ('0),
                   // HSD 16013291576
                   .i_rst_n            (~uif_pcs66[0].reset),
                   .i_mode_100g        (),
                   .i_vlane_set        (0),
                   .i_speed            (spy_if_ip0.speed.name()),
                   .i_valid            (o_avst_valid_ip0 ),
                   .i_din              (o_avst_data_tagger_in_ip0),
                   .i_am_insert        (o_avst_am_insert_ip0),
                   .o_dout_am          (otn_am_ip0),
                   .o_dout_vld         (otn_am_insert_dout_vld_ip0),
                   .o_dout             (otn_am_insert_dout_ip0)
               );
//

   initial begin
      assign pcs66_tx_data_ip0           = (spy_if_ip0.gear==1)? o_avst_data_ip0[1055 -: (1*66)] :
      					   (spy_if_ip0.mode==FLEXE)?( 
                                           (spy_if_ip0.gear==2)? o_avst_data_ip0[1055 -: (2*66)] :
			                   (spy_if_ip0.gear==4)? o_avst_data_ip0[1055 -: (4*66)] :
			                   (spy_if_ip0.gear==8)? o_avst_data_ip0[1055 -: (8*66)] :
			                                         o_avst_data_ip0[1055 -:(16*66)]):
								 otn_am_insert_dout_ip0;
      assign pcs66_tx_vld_ip0            = (spy_if_ip0.mode==FLEXE || (spy_if_ip0.mode==OTN && (spy_if_ip0.speed inside {_10G,_25G}) ))  ? o_avst_valid_ip0    :
      								      otn_am_insert_dout_vld_ip0; //HSD: 16012997893
      assign pcs66_avst_tx_am_insert_ip0 = (spy_if_ip0.mode==FLEXE || (spy_if_ip0.mode==OTN && (spy_if_ip0.speed == _25G && spy_if_ip0.fec_type != NOFEC)) ) ? o_avst_am_insert_ip0:
                                                                      otn_am_ip0;
   end

   //Bit 66 of rx_lane VIP expects the DUT to assert this as soon as the DUT starts transmission of valid 66 Bit data
   `ifdef ENABLE_ETH_VIP
   assign uif_pcs66[0].rx_lane[66] = pcs66_txdata_valid_hack_ip0;
   `endif

   initial begin
      pcs66_txdata_valid_hack_ip0 = 1'b0;
      wait (rx_pcs_ready_ip0);
      `uvm_info("",$sformatf("Disable FLEXE/OTN BFM data while BFM output is 'z"),UVM_NONE);
      wait ($isunknown(uif_pcs66[0].tx_lane[65:0]) == 0);
      #1us;
      pcs66_txdata_valid_hack_ip0 = 1'b1;
   end

   // RX DATA queue
   initial begin
     forever begin
        @ (posedge clk_pll_ip0);
        if(pcs66_rx_vld_ip0 == 1 && pcs66_rx_am_ip0 == 0 && rx_pcs_ready_ip0 == 1) begin
          rxdata_queue_ip0.push_back(pcs66_rx_data_ip0);
          `uvm_info("",$sformatf("rxdata_queue_size=%0d",rxdata_queue_ip0.size()),UVM_MEDIUM);
        end
     end
   end

   initial begin
       forever begin
          @ (posedge clk_pll_ip0);
	  if(spy_if_ip0.speed == _10G || spy_if_ip0.speed == _40G) begin
	     if(rx_pcs_ready_ip0 == 1 && tx_lanes_stable_ip0 == 1) begin
		  #25us;
		  i_pop_ip0 = 1;
	     end 
	     else begin
	        i_pop_ip0 = 0;
	     end
          end 
	  else begin
	     i_pop_ip0 = 1;
	  end
       end
   end  

   initial begin
      forever begin
          @ (posedge clk_pll_ip0);
          if(buffer_rx_valid_ip0 == 1) begin
             if(rx_pcs_ready_ip0 == 0) begin
                buffer_rx_valid_ip0 = 0; 
                rxdata_queue_ip0 = {};
                `uvm_info("",$sformatf("rx_pcs_ready is low, setting gearbox_rx_valid to %0d, rxdata_queue_size = %0d", buffer_rx_valid_ip0,rxdata_queue_ip0.size()),UVM_MEDIUM);
             end else begin
                buffer_rx_data_ip0 = rxdata_queue_ip0.pop_front();
                `uvm_info("",$sformatf("gearbox_rx : data = %0h, queue_size =%0d",buffer_rx_data_ip0,rxdata_queue_ip0.size()),UVM_MEDIUM);
             end  
         end else begin
             wait(rxdata_queue_ip0.size() > 10000);//6400
             buffer_rx_valid_ip0 = 1;   
            `uvm_info("",$sformatf("gearbox_rx : valid is high\n"),UVM_NONE);
         end
      end   
   end

   initial begin
     forever begin
        @(negedge uif_pcs66[0].reset);
        `uvm_info("",$sformatf("vip reset detected, flush out rxdata_queue"),UVM_NONE);
        rxdata_queue_ip0 = {};
     end
   end

   initial  begin
               //This assertion is disabeld based on discussion with uvc owner,i.e reset is applied by user
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
              //Setting AVMM driver idle signal driving to 0
              avmm_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);
              force eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;
              `ifdef FAST_CLK
                eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.set_waitrequest_timeout(2000);
                force  avmm_rtb_ip0.master.u.u_bfm.command_timeout=3000;
              `else
                eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.set_waitrequest_timeout(200);
                force  avmm_rtb_ip0.master.u.u_bfm.command_timeout=300;
              `endif
              // scaled based on number of phy channels
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset = 0;
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_read_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_b2b_write_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_readdatavalid(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_waitrequest_from_idle_to_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_continuous_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_idle_before_transaction(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_after_reset(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_byteenable(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_read_latency(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequest_without_command(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_read(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_waitrequested_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_after_reset(0);
              avmm_xcvr_rtb_ip0_0.monitor.u_bfm.master_coverage.set_enable_c_write_byteenable(0);
 //HSD: 16013763023             
              `ifdef FAST_CLK
                force avmm_xcvr_rtb_ip0_0.master.u.u_bfm.command_timeout=10000; 
                force avmm_xcvr_rtb_ip0_0.master.u.u_bfm.response_timeout=10000;
              `endif
              //AVMM covergroups
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
   end
   `ifndef NON_ANLT_PTP 
    `ifdef ENABLE_ETH_VIP       
         `SVT_ETHERNET_TEST_SUITE_TOP_INST(0,signal_map_if[0],directed_if[0])
    `endif
   `endif
   initial
   begin
     assertion_event.wait_ptrigger();
     `uvm_info("assertion_event", "IP0 out of assertion_event wait trigger", UVM_NONE)
    end
/*
//-----------------------------------------------------------------------
//Expected DUT port connections
//-----------------------------------------------------------------------
   `ifdef ENABLE_ETH_VIP
	 `ifndef EHIP_PCS_ONLY 
	 .i_tx_pcs66_d(pcs66_tx_data_ip0), 
	 .i_tx_pcs66_valid(pcs66_tx_vld_ip0),
	 .i_tx_pcs66_am(pcs66_avst_tx_am_insert_ip0),
         .o_tx_pcs66_ready(pcs66_tx_rdy_ip0), 
	 .o_rx_pcs66_d(pcs66_rx_data_ip0),
	 .o_rx_pcs66_valid(pcs66_rx_vld_ip0),   
	 .o_rx_pcs66_am_valid(pcs66_rx_am_ip0),
   `endif
   `endif
*/
