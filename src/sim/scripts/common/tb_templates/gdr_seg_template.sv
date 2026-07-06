
///////////////
// start DUT <NUM_INST> wires
///////////////

   typedef logic [63:0] logicdata_ip0; // SINDHU-REF SEG data is 64,128,256,512,1024 for 10/25G, 40/50G, 100G, 200G, 400G
   typedef logic [2:0] logicempty_ip0; // SINDHU-REF SEG empty is 3,6,12,24,48 for 10/25G, 40/50G, 100G, 200G, 400G

   //SEG BFM intermediate signals 
   logic [63:0]		tx_mac_data_ip0;      // SINDHU-REF same as `logicdata_ip0
   reg 	          tx_mac_valid_ip0;
   wire       i_clk_sys;
   logic [0:0]  	tx_mac_inframe_ip0;   // SINDHU-REF [0:0] for 10/25G, [1:0] for 40/50G, [3:0] for 100G, [7:0] for 200G, [15:0] for 400G
   logic [2:0]		tx_mac_eop_empty_ip0; // SINDHU-REF same as `logicempty_ip0
   reg  	        tx_mac_ready_ip0;
   logic [0:0]		tx_mac_error_ip0;     // SINDHU-REF [0:0] for 10/25G, [1:0] for 40/50G, [3:0] for 100G, [7:0] for 200G, [15:0] for 400G 
   logic [0:0]  	tx_mac_skip_crc_ip0;      // dsamantx-REF same as tx_mac_error_ip0
   reg                  custom_cadence;
   
   logic [63:0]		rx_mac_data_ip0;      // SINDHU-REF same as `logicdata_ip0
   reg 	          rx_mac_valid_ip0;
   logic [0:0]  	rx_mac_inframe_ip0;   // SINDHU-REF [0:0] for 10/25G, [1:0] for 40/50G, [3:0] for 100G, [7:0] for 200G, [15:0] for 400G 
   logic [2:0]		rx_mac_eop_empty_ip0; // SINDHU-REF same as `logicempty_ip0
   logic [0:0]	 	rx_mac_fcs_error_ip0; // SINDHU-REF [0:0] for 10/25G, [1:0] for 40/50G, [3:0] for 100G, [7:0] for 200G, [15:0] for 400G   
   logic [1:0]		rx_mac_error_ip0;     // SINDHU-REF [1:0] for 10/25G, [3:0] for 40/50G, [7:0] for 100G, [15:0] for 200G, [31:0] for 400G
   logic [2:0]		rx_mac_status_ip0;    // SINDHU-REF same as `logicempty_ip0


   logic reset_ip0; 
   wire  clk_ip0;
   wire  rx_hi_ber_ip0;

   wire       clk_tx_ip0;
   wire       clk_rx_ip0;
   wire       reconfig_clk_ip0;
   wire       clk_pll_ip0;
   wire       clk_tx_div_ip0;
   wire       clk_rec_div64_ip0;
   wire       clk_rec_div_ip0;  
   logic      clk_ref_ip0=0;       
   logic      clk_sys_ip0=0;   


   logic      clk_status_ip0=0;
   
   reg  	    rst_n_ip0;
   wire       rst_ack_n_ip0;
   reg  	    tx_rst_n_ip0;
   wire       tx_rst_ack_n_ip0;
   reg  	    rx_rst_n_ip0;
   wire       rx_rst_ack_n_ip0;
   logic 		  reconfig_reset_ip0;    
   wire 		  tx_lanes_stable_ip0;    
   wire 		  rx_pcs_ready_ip0;  
   wire           rx_pause_ip0;

   wire 		  tx_pll_locked_ip0;    
   wire 		  cdr_locked_ip0;    
   
   wire  	    rx_block_lock_ip0;              
   wire 			rx_am_lock_ip0;            
   wire 			local_fault_status_ip0;            
   wire 			remote_fault_status_ip0;            
   reg  	    stats_snapshot_ip0;
   wire 			rx_bi_her_ip0;            
   wire 			rx_pcs_fully_aligned_ip0;            
   

   reg [39:0] rx_status_data_ip0;
   reg  	    rx_status_valid_ip0;


   reg  	     reconfig_eth_write_ip0;         
   reg  	     reconfig_eth_read_ip0;
   reg  [3:0]        reconfig_eth_byteenable_ip0;         
   reg  [19:0] reconfig_eth_addr_ip0;       
   reg  [31:0] reconfig_eth_writedata_ip0;     
   wire [31:0] reconfig_eth_readdata_ip0;      
   wire 	     reconfig_eth_waitrequest_ip0;   
   wire 	     reconfig_eth_readdata_valid_ip0; 

   reg  	     reconfig_xcvr0_write_ip0;         
   reg  	     reconfig_xcvr0_read_ip0;
   reg  [3:0]    reconfig_xcvr0_byteenable_ip0;   
   reg  [19:0] reconfig_xcvr0_address_ip0;       
   reg  [31:0] reconfig_xcvr0_writedata_ip0;     
   wire [31:0] reconfig_xcvr0_readdata_ip0;
   wire 	     reconfig_xcvr0_waitrequest_ip0;   
   wire 	     reconfig_xcvr0_readdata_valid_ip0; 
   wire [0:0] xcvrif_txfifo_pfull;
   wire [0:0] xcvrif_txfifo_pempty;
   wire [0:0] xcvrif_txfifo_empty;
   wire [0:0] xcvrif_hold_interrupt;

//   wire       tx_tod_clk,rx_tod_clk; //for PTP	

///////////////
// end DUT port wires 
///////////////

//any new addtions needs to be added after PORT wires

`include "basic_test_params_ip0.v"

   //// RAMI-FIX Do we need to do this for all speed per instance
   // dsamantx: Will be removed as these are old parameters.please check again.
   //defparam dut.sim_mode           = "enable";
   //defparam dut.ip0.sim_mode           = "enable";
   //defparam dut.ip0.tx_am_period    = "sim_only_am_period";
   //defparam dut.ip0.rx_am_interval  = "sim_only_am_interval";

 // Need to set these hierarchies per ip
 // PATH-FIX: `define GDR_RX_MAC_IP0 dut.ip0.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.u_rx_mac
 // PATH-FIX: `define GDR_TX_MAC_IP0 dut.ip0.alt_ehipc3_hard_inst.EHIP_CORE.c3_ehip_core_inst.ct3_hssi_ehip_core_encrypted_inst.ct1_hssirtl_ehip_core_inst.u_tx_mac
 // PATH-FIX: `define GDR_XCVR_IP0 dut.ip0.alt_ehipc3_hard_inst.Dynamic_Reconfig.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp

//*********************************************//  
//drajasek-driving src_ip_clk to 1Ghz
   assign i_clk_sys = clk_sys_ip0;
   always begin #500ps clk_sys_ip0 = ~clk_sys_ip0;
   force eth_env_top.dut.ip0.top_ip0.i_src_ip_clk = clk_sys_ip0;
   end
//*********************************************//   

   `ifndef ENABLE_ETH_VIP
   //Chintan : Changing parameter value only in loopback mode as VIP doesn't support CRC cover preamble feature
   //defparam dut.ip0.rxcrc_covers_preamble = `rxcrc_covers_preamble_ip0 ? "enable" : "disable";  //RAMI-FIX `rxcrc_covers_preamble_ip0 not there in basic_test_params
   //defparam dut.ip0.txcrc_covers_preamble = `txcrc_covers_preamble_ip0 ? "enable" : "disable";  //RAMI-FIX `txcrc_covers_preamble_ip0 not there in basic_test_params
   `endif
		
   //---------------------------------------------------------------------------
   //  UVC Instances 
   //---------------------------------------------------------------------------
   altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_ip0 (
								  .clk                       (clk_status_ip0),
								  .reset                     (reconfig_reset_ip0)
								  );
   altuvm_avalon_mm_rtb #(`AVMM_CFG_SHARED_INF_INST,		
			  .IS_ACTIVE                 (UVM_ACTIVE),
			  .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
			  ) avmm_rtb_ip0 (.uif(avmm_if_ip0));

   initial begin
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_rtb_path","avmm_rtb_ip0");
   end
   
   // AVMM IF
   initial begin
       uvm_config_db #(virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST))::set(null,"*env_ip0*","status_if",avmm_if_ip0);
   end

   altera_avalon_mm_if #(`AVMM_XCVR_CFG_SHARED_INF_INST) avmm_xcvr_if_ip0_0 (
	 		            .clk                       (clk_status_ip0),
	 		            .reset                     (reconfig_reset_ip0)
               );
   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,
           .IS_ACTIVE                 (UVM_ACTIVE),
           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
               ) avmm_xcvr_rtb_ip0_0 (.uif(avmm_xcvr_if_ip0_0));

   initial begin        
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");
   end            

	 reset_if reset_if_ip0();
	 initial begin
	    uvm_config_db #(virtual reset_if)::set (null, "*env_ip0", "slv_if", reset_if_ip0); 
	 end

 `ifdef ENABLE_ETH_VIP
 
/*
   // RAMI-FIX Do this for 100G and 100G w/FEC
   initial begin
        ts_tasks_if[0].event_xsbi_do_err_loaded = svt_ethernet_drv_0.Bfm.event_xsbi_do_err_loaded; 
        `ifdef RSFEC
        ts_tasks_if[0].event_kr4_fec_do_err_loaded = svt_ethernet_drv_0.Bfm.event_kr4_fec_do_err_loaded; 
        ts_tasks_if[0].event_load_align_marker_error = svt_ethernet_drv_0.Bfm.event_load_align_marker_error; 
        ts_tasks_if[0].event_rs_error_inserted = svt_ethernet_drv_0.Bfm.event_rs_error_inserted; 
        ts_tasks_if[0].event_kr4_fec_cw_transmitted = svt_ethernet_drv_0.Bfm.event_kr4_fec_cw_transmitted; 
        ts_tasks_if[0].event_kr4_fec_align4_insert = svt_ethernet_drv_0.Bfm.event_kr4_fec_align4_insert; 
        `endif
   end
*/

   initial begin 
     spy_if_ip0.event_mac_idle_detected_rx           = svt_ethernet_mon_chk_0.Chk.event_mac_idle_detected_rx; 
     ts_tasks_if[0].event_10g_multilane_insert_align_block = svt_ethernet_drv_0.Bfm.multilane_10g.event_insert_align_block; 
     ts_tasks_if[0].event_10g_multilane_insert_66b_block   = svt_ethernet_drv_0.Bfm.event_10g_multilane_insert_66b_block;   
     ts_tasks_if[0].event_load_align_marker_error = svt_ethernet_drv_0.Bfm.event_load_align_marker_error;
     spy_if_ip0.event_chk_no_eop_tx                  = svt_ethernet_mon_chk_0.Chk.event_chk_no_term_char_found_tx;
   end

   svt_ethernet_xxm_bfm_driver svt_ethernet_drv_0(svt_ethernet_txrx_if[0]);
   svt_ethernet_xxm_mon_chk_driver svt_ethernet_mon_chk_0(svt_ethernet_txrx_if[0]);

        defparam svt_ethernet_mon_chk_0.ETH_JUMBO_FRAME_SIZE=70000;
        defparam svt_ethernet_drv_0.ETH_JUMBO_FRAME_SIZE=70000;
   

 `endif 
 
     bit 				    soft_reset_ip0;
     bit[31:0] ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
     assign ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_ip0.address[17:0] == `ETH_F_ALL_eth_reset_OFFSET_REG) && (avmm_if_ip0.write == 1'b1)) ? avmm_if_ip0.writedata : ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
     assign  soft_reset_ip0 =  ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];

//`ifndef ANLT
     assign spy_if_ip0.eio_soft_rst =  ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
     assign spy_if_ip0.tx_soft_rst  =  ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0[1];
     assign spy_if_ip0.rx_soft_rst  =  ETH_F_ALL_eth_reset_OFFSET_REG_WRITE_DATA_IP0[2];     
//`endif
 //SEG BFM interfaces   

   client_tx_if#(.NUM_WORDS(16))  seg_tx_if_ip0(.clk (clk_pll_ip0), // SINDHU-REF NUM_WORDS=1 for 25 G, for 100G its 4, for 200G its 8 & 400G its 16 
					   .rst_n (!(reset_ip0 
						   | ~reset_if_ip0.tx_rst_n 
						   | spy_if_ip0.eio_soft_rst 
						   | spy_if_ip0.tx_soft_rst
						  )),
`ifdef PTP_EN
                                            .tx_tod_clk(eth_env_top.dut.i_clk_tx_tod_ip0),
                                            .rx_tod_clk(eth_env_top.dut.i_clk_rx_tod_ip0)						  
`else

                                            .tx_tod_clk('b0),
                                            .rx_tod_clk('b0)
`endif
						  );
						  
   client_rx_if#(.NUM_WORDS(16))  seg_rx_if_ip0(.clk (clk_pll_ip0),
					   .rst_n (!(reset_ip0 
						  | ~reset_if_ip0.rx_rst_n 
						  | spy_if_ip0.eio_soft_rst 
						  | spy_if_ip0.rx_soft_rst)));

    // SEG BFM RTB modules 
   seg_tx_rtb_module seg_tx_rtb_ip0(.uif_tx(seg_tx_if_ip0));
   seg_rx_rtb_module seg_rx_rtb_ip0(.uif_rx(seg_rx_if_ip0));

   initial begin 
   	uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","seg_tx_rtb_path","seg_tx_rtb_ip0");
   	uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","seg_rx_rtb_path","seg_rx_rtb_ip0");
   end


// //SEG BFM interfaces     
//
//   client_tx_if#(.NUM_WORDS(1))  seg_tx_if_ip0(.clk (clk_pll_ip0), // SINDHU-REF NUM_WORDS=1 for 25 G, for 100G its 4, for 200G its 8 & 400G its 16 
//					   .rst_n (!(reset_ip0 
//						   | ~reset_if_ip0.tx_rst_n 
//						   | spy_if_ip0.eio_soft_rst 
//						   | spy_if_ip0.tx_soft_rst 
//						  )));
//   client_rx_if#(.NUM_WORDS(1))  seg_rx_if_ip0(.clk (clk_pll_ip0),
//					   .rst_n (!(reset_ip0 
//						  | ~reset_if_ip0.rx_rst_n 
//						  | spy_if_ip0.eio_soft_rst 
//						  | spy_if_ip0.rx_soft_rst)));
//
//   initial begin 
//   	uvm_config_db#(virtual client_tx_if)::set(uvm_root::get(),"*", "seg_tx_if", seg_tx_if_ip0);
//   	uvm_config_db#(virtual client_rx_if)::set(uvm_root::get(),"*", "seg_rx_if", seg_rx_if_ip0);
//   end

   for(genvar i=0; i<1;i++) // SINDHU-REF i<1 for 10G/25G, 2 for 40G/50G, 4 for 100G, 8 for 200G and 16 for 400G
   begin
   	assign tx_mac_inframe_ip0[i]		   				= seg_tx_if_ip0.in_frame[i];
   	assign tx_mac_error_ip0[i]            		= seg_tx_if_ip0.error[i];
   	assign seg_rx_if_ip0.in_frame[i]			= rx_mac_inframe_ip0[i];
	assign tx_mac_skip_crc_ip0[i]     = seg_tx_if_ip0.skip_crc[i];
   end
   //AVST & SEG common signals (single bit)
   assign tx_mac_valid_ip0         = seg_tx_if_ip0.vld;
   assign seg_rx_if_ip0.vld    = rx_mac_valid_ip0;
   assign seg_tx_if_ip0.rdy	   = tx_mac_ready_ip0;
   assign seg_tx_if_ip0.rx_pcs_fully_aligned	   = rx_pcs_fully_aligned_ip0;
   assign {<<{seg_rx_if_ip0.fcs_error}}           = rx_mac_fcs_error_ip0; // check DUT fcs_error port 
   // SEG unpacked to packed conversions: static type casting
   assign tx_mac_eop_empty_ip0         =  {<<3{seg_tx_if_ip0.eop_empty}};
   assign tx_mac_data_ip0          	   =  {<<64{seg_tx_if_ip0.data}};//data[0] is MSB block
      
   //SEG DUT RX connections : error & status are collected by vector interface 
   assign {<<3{seg_rx_if_ip0.eop_empty}}       	= rx_mac_eop_empty_ip0; //packed to unpacked conversion 
   assign {<<64{seg_rx_if_ip0.data}}      		= rx_mac_data_ip0;
   assign {<<2{seg_rx_if_ip0.rx_error}}      	= rx_mac_error_ip0;
   assign {<<3{seg_rx_if_ip0.rx_status}}	    = rx_mac_status_ip0;
   //assign eth_vector_rx_if_ip0.status_error = seg_rx_if_ip0.rx_error; // FIXME stumulur vector interface needs update
   assign eth_vector_rx_if_ip0.status_valid = rx_status_valid_ip0;
   assign eth_vector_rx_if_ip0.status_data  = rx_status_data_ip0; 

//  defparam dut.ip0.SIM_SHORT_AM = 1;
 assign clk_rx_ip0 = ((`en_async_adp_ip0 & 1'b1) == 1) ? async_mac_clk_rx:clk_pll_ip0; //stumulur FIXME 
 assign clk_tx_ip0 = ((`en_async_adp_ip0 & 1'b1) == 1) ? async_mac_clk_tx:clk_pll_ip0;

 




    //DUT and other interface connections
    assign rst_n_ip0    = reset_if_ip0.csr_rst_n;
    assign tx_rst_n_ip0 = reset_if_ip0.tx_rst_n;
    assign rx_rst_n_ip0 = reset_if_ip0.rx_rst_n;


    assign reset_if_ip0.rst_ack_n = rst_ack_n_ip0; 
    assign reset_if_ip0.tx_rst_ack_n = tx_rst_ack_n_ip0; 
    assign reset_if_ip0.rx_rst_ack_n = rx_rst_ack_n_ip0;

    //assign tx_preamble_ip0      = eth_sideband_if_ip0.l2_tx_preamble; // RAMI-REF only for 40G/50G 
    assign eth_sideband_if_ip0.tx_lane_stable = tx_lanes_stable_ip0;
    assign eth_sideband_if_ip0.rx_pcs_ready   = rx_pcs_ready_ip0;
    assign eth_sideband_if_ip0.rx_pause       = rx_pause_ip0;
    //assign eth_sideband_if_ip0.l2_rx_preamble = rx_preamble_ip0;      // RAMI-REF only for 40G/50G 
    assign custom_cadence_ip0         = eth_sideband_if_ip0.custom_cadence;

    //assign eth_sideband_if_ip0.ehip_ready     = ehip_ready_ip0;       // RAMI-FIX port not available in GDR


	  assign stats_snapshot_ip0            = eth_sideband_if_ip0.snapshot_en;
    
    //CSR
    assign reconfig_eth_write_ip0           = avmm_if_ip0.write;
    assign reconfig_eth_read_ip0            = avmm_if_ip0.read;
    assign reconfig_eth_addr_ip0         = {3'b0,avmm_if_ip0.address[17:2]};
    assign reconfig_eth_byteenable_ip0      = avmm_if_ip0.byteenable;
    assign reconfig_eth_writedata_ip0       = avmm_if_ip0.writedata;
    assign avmm_if_ip0.readdata             = reconfig_eth_readdata_ip0;
    assign avmm_if_ip0.waitrequest          = reconfig_eth_waitrequest_ip0;    
    assign avmm_if_ip0.readdatavalid        = reconfig_eth_readdata_valid_ip0;
    
    // scaled based on number of phy channels
    assign reconfig_xcvr0_write_ip0           = avmm_xcvr_if_ip0_0.write;
    assign reconfig_xcvr0_read_ip0            = avmm_xcvr_if_ip0_0.read;
    assign reconfig_xcvr0_byteenable_ip0      = avmm_xcvr_if_ip0_0.byteenable;
    assign reconfig_xcvr0_address_ip0         =  {2'b00,avmm_xcvr_if_ip0_0.address[19:2]};
    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;
    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;
    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    
    assign avmm_xcvr_if_ip0_0.readdatavalid     = reconfig_xcvr0_readdata_valid_ip0;
    
   //FB 535148 (do it for appropiate DUT - RAMI-FIX do we need this???) 
   initial begin
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_read = 0;
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_write = 0;
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_writedata[7:0] = 0;
     // PATH-FIX: force dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_address[20:0] = 0;
     // PATH-FIX: repeat (5) 
     // PATH-FIX: @ (posedge dut.ip0.alt_ehipc3_hard_inst.i_reconfig_clk);
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_read ;
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_write ;
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_writedata[7:0] ;
     // PATH-FIX: release dut.ip0.alt_ehipc3_hard_inst.i_ehip_reconfig_address[20:0] ;
   end


    initial
    begin
      assertion_event.wait_ptrigger();
      `uvm_info("assertion_event", "IP0 out of assertion_event wait trigger", UVM_NONE)
    end

`ifdef ENABLE_ETH_VIP

    //FB-544895
//    `ifdef ANLT
//        always @(reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
//        begin
//            svt_ethernet_txrx_if[0].reset = ( ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0);  
//        end
//    `else
//        always @(reset_if_ip0.csr_rst_n or soft_reset_ip0)
//        begin
//            svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | soft_reset_ip0);  
//        end
//    `endif
        always @(reset_if_ip0.csr_rst_n or soft_reset_ip0 or reset_if_ip0.vip_rst or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or spy_if_ip0.tx_soft_rst or spy_if_ip0.rx_soft_rst)
        begin
            `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);
            svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | soft_reset_ip0 | reset_if_ip0.vip_rst | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | spy_if_ip0.tx_soft_rst | spy_if_ip0.rx_soft_rst);  
        end

//        initial 
//        begin
//            // Initial reset 
//            svt_ethernet_txrx_if[0].reset = 0;
//            #5us;
//            svt_ethernet_txrx_if[0].reset = 1;
//            #25us;
//            svt_ethernet_txrx_if[0].reset = 0;
//            @(posedge rx_pcs_ready_ip0);
//            forever 
//            begin
//              @(reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
//              svt_ethernet_txrx_if[0].reset = ( ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0);  
//            end    
//          end
    
`endif

	 always @(tx_lanes_stable_ip0 or reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
	   begin
	      assertion_on_off_reset[0] = (~tx_lanes_stable_ip0 | ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0); 
	   end


// RAMI-FIX clk_sys_ip0???

	 assign reconfig_clk_ip0     = clk_status_ip0;
	 assign clk_ip0              = clk_pll_ip0;
	 assign reset_ip0            = ~reset_if_ip0.csr_rst_n;
	 assign reset_if_ip0.clock   = clk_status_ip0;


initial begin
  assign reconfig_reset_ip0 =  reset_if_ip0.reconfig_rst_n;
  #500ns;
  assign reconfig_reset_ip0 =  ~reset_if_ip0.reconfig_rst_n;
end  

//`ifdef ANLT
//	 always begin
//            #3200 clk_ref_ip0 = ~clk_ref_ip0;
//	 end
//`else
//	 if(`phy_refclk_ip0 == 0 || `phy_refclk_ip0 == 322.265625) begin
//            always begin
//               #1551.51515 clk_ref_ip0 = ~clk_ref_ip0;
//            end
//	 end
//	 else begin
//            if(`phy_refclk_ip0 == 2 || `phy_refclk_ip0 == 156.250000)begin
//               always begin
//                  #3200 clk_ref_ip0 = ~clk_ref_ip0;                
//               end
//            end
//	 end
//         if(`phy_refclk_ip0 == 1 || `phy_refclk_ip0 == 644.531250) always #775.757575  clk_ref_ip0 = ~clk_ref_ip0;
//         if(`phy_refclk_ip0 == 3 || `phy_refclk_ip0 == 312.500000) always #1600 clk_ref_ip0 = ~clk_ref_ip0;
//`endif
	if(`phy_refclk_ip0 == 0 || `phy_refclk_ip0 == 156.250000) always #3200 clk_ref_ip0 = ~clk_ref_ip0;                
	if(`phy_refclk_ip0 == 1 || `phy_refclk_ip0 == 322.265625) always #1551.51515 clk_ref_ip0 = ~clk_ref_ip0;
	if(`phy_refclk_ip0 == 2 || `phy_refclk_ip0 == 312.500000) always #1600 clk_ref_ip0 = ~clk_ref_ip0;
	if(`phy_refclk_ip0 == 3 || `phy_refclk_ip0 == 644.531250) always #775.757575  clk_ref_ip0 = ~clk_ref_ip0;



//`ifdef ANLT
//    always begin #500ps clk_status_ip0= ~clk_status_ip0;    end //to speed up simulation
//`else
	//100MHz to 161.13MHz
	//Previously it is set to 1GHz which caused internal signal clock cross failed.
	//Now set to 100MHz
    `ifdef FAST_CLK
	 `ifdef PTP_EN
    	always begin 
         if(!($test$plusargs("PTP_REG_TEST")))begin
            #5000ps clk_status_ip0= ~clk_status_ip0;
         end else begin
            #500ps clk_status_ip0= ~clk_status_ip0;
         end
      end
	 `else
	   always begin #500ps clk_status_ip0= ~clk_status_ip0;    end
	 `endif
    `else
    	always begin #5ns clk_status_ip0= ~clk_status_ip0;    end
    `endif
//`endif


   `ifdef ENABLE_ETH_VIP
    initial
    begin
      spy_if_ip0.event_chk_start_cntrl_character_tx = eth_env_top.svt_ethernet_mon_chk_0.Chk.xgmii_checker.tx.event_chk_start_cntrl_character; // ip0 + chk_i
      spy_if_ip0.cw_insert = svt_ethernet_drv_0.Bfm.event_kr4_fec_cw_transmitted; // ip0 + drv_i
      spy_if_ip0.event_mac_idle_detected_rx = eth_env_top.svt_ethernet_mon_chk_0.Chk.event_mac_idle_detected_rx; // ip0 + chk_i
    end
    assign spy_if_ip0.mii_tx_clk = eth_env_top.svt_ethernet_mon_chk_0.Chk.xgmii_checker.tx.xgmii_clk; // ip0 + chk_i
    assign spy_if_ip0.data_valid_tx = eth_env_top.svt_ethernet_mon_chk_0.Chk.xgmii_checker.tx.data_valid; // ip0 + chk_i
    `endif

   
   
   
  `ifdef ENABLE_ETH_VIP
   //pass interface to env
   initial begin 
      //dsamantx:Need to revisit
     ts_tasks_if[0].ip = 0; //ALEX new: ts_task_if[i].ip = i, for INST[i] which needs SEG template
      uvm_config_db#(virtual eth_testsuite_tasks_intf)::set(uvm_root::get(),"*env_ip0","ts_tasks_if",ts_tasks_if[0]);
      uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),"*env_ip0", "if_port", svt_ethernet_txrx_if[0]);
      uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),"*", "seg_if_port", svt_ethernet_txrx_if[0]);
       `ifndef NON_ANLT_PTP 
       uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"*ts_component0*", "if_directed", directed_if[0]);    //vshridhx
      `endif 
    end

    // RAMI-FIX
	  //nvs_eth_tests u_tsbind_0 (
    // 	.reset ( svt_ethernet_txrx_if[0].reset ),          // ip0 - svt_ethernet_txrx_if[i]
    // 	.clock ( svt_ethernet_txrx_if[0].xgmii_tx_clk)     // ip0 - svt_ethernet_txrx_if[i]
    // 	,.start_test (start_snps_testsuite)
    // );

  `endif

   eth_sideband_interface eth_sideband_if_ip0(.rst(reset_ip0),
                                              //.clk(clk_pll_ip0),
                                              .clk(clk_tx_ip0),
`ifdef PTP_EN
                                              .tx_tod_clk(eth_env_top.dut.i_clk_tx_tod_ip0),
                                              .rx_tod_clk(eth_env_top.dut.i_clk_rx_tod_ip0));
`else
                                              .tx_tod_clk('b0),
                                              .rx_tod_clk('b0));
`endif

	vector_uvc_interface eth_vector_rx_if_ip0(clk_pll_ip0,reset_ip0);
         
         initial begin
            uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "mst_if",eth_sideband_if_ip0); 
            uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "slv_if",eth_sideband_if_ip0); 
            uvm_config_db #(virtual vector_uvc_interface)::set(uvm_root::get(), "*env_ip0.rx_vector_agent*","vector_if",eth_vector_rx_if_ip0);
         end
         
   
   //SPY IF
       spy_interface #(.IP("ip0")) spy_if_ip0(); // ALEX new: #(.IP("ip<i>)), for INST[i] which needs SEG template
        initial begin
            uvm_config_db #(v_if2)::set(null,"*env_ip0","spy_interface",spy_if_ip0);
            uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","dut_name","*dut_25g_ip0");  
                                                                                                 
        end
   

  
   assign eth_sideband_if_ip0.rx_valid                = rx_mac_valid_ip0;
   assign eth_sideband_if_ip0.rx_sop                  = seg_rx_if_ip0.found_sop;
   assign eth_sideband_if_ip0.tx_sop                  = seg_tx_if_ip0.found_sop;


         initial
           begin

              //This assertion is disabeld based on discussion with uvc owner,i.e reset is applied by user
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal   = 0;
              avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_waitrequest_during_reset = 0;              
              force eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_no_readdatavalid_during_reset =0;


	      //dsamantx : Accesing some register takes more time than 1us.
	      `ifdef FAST_CLK
	         eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.set_waitrequest_timeout(2000);
	      `else
	         eth_env_top.avmm_rtb_ip0.monitor.u_bfm.master_assertion.set_waitrequest_timeout(200);
        `endif

  		  `ifdef FAST_CLK
            force  avmm_rtb_ip0.master.u.u_bfm.command_timeout=3000;
        `else
        	force  avmm_rtb_ip0.master.u.u_bfm.command_timeout=300;
        `endif



              
              //Setting AVMM driver idle signal driving to 0
              avmm_rtb_ip0.master.u.u_bfm.set_idle_state_output_configuration(0);
              
             

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
              `ifdef FAST_CLK
              	force avmm_xcvr_rtb_ip0_0.master.u.u_bfm.command_timeout=1000; 
              	force avmm_xcvr_rtb_ip0_0.master.u.u_bfm.response_timeout=1000;
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

	 

   // interface connections spy_if
   assign spy_if_ip0.o_rx_hi_ber = rx_hi_ber_ip0;
   assign spy_if_ip0.rx_am_lock = rx_am_lock_ip0;
   assign spy_if_ip0.rx_block_lock = rx_block_lock_ip0;
   assign spy_if_ip0.rx_pcs_ready = rx_pcs_ready_ip0;
   //assign spy_if_ip0.ehip_ready = ehip_ready_ip0; // RAMI-FIX port not available in GDR
   assign spy_if_ip0.soft_reset = soft_reset_ip0;
   assign spy_if_ip0.seg_tx_found_sop = seg_tx_if_ip0.found_sop;
   
   //GDR_RX/TX_MAC connections
   assign spy_if_ip0.rf_status	= remote_fault_status_ip0;
   assign spy_if_ip0.lf_status	= local_fault_status_ip0;
   //assign spy_if_ip0.fault          = remote_fault_status_ip0 | local_fault_status_ip0;
                                          
   assign spy_if_ip0.clk                  = clk_ref_ip0;
   // PATH-FIX: assign spy_if_ip0.mii_data_rx					= `GDR_RX_MAC_IP0.mii_d;
   // PATH-FIX: assign spy_if_ip0.mii_ctrl_rx          = `GDR_RX_MAC_IP0.mii_c;
   // PATH-FIX: assign spy_if_ip0.mii_valid_rx					= `GDR_RX_MAC_IP0.mii_valid;
   
   // RAMI-FIX scale based on speed??
   //assign spy_if_ip0.mii_data3_tx          = `GDR_TX_MAC_IP0.packet_mii[3].d;
   //assign spy_if_ip0.mii_data2_tx          = `GDR_TX_MAC_IP0.packet_mii[2].d;
   //assign spy_if_ip0.mii_data1_tx          = `GDR_TX_MAC_IP0.packet_mii[1].d;
   // PATH-FIX: assign spy_if_ip0.mii_data0_tx          = `GDR_TX_MAC_IP0.packet_mii[0].d;
   //assign spy_if_ip0.mii_ctrl3_tx          = `GDR_TX_MAC_IP0.packet_mii[3].c;
   //assign spy_if_ip0.mii_ctrl2_tx          = `GDR_TX_MAC_IP0.packet_mii[2].c;
   //assign spy_if_ip0.mii_ctrl1_tx          = `GDR_TX_MAC_IP0.packet_mii[1].c;
   // PATH-FIX: assign spy_if_ip0.mii_ctrl0_tx          = `GDR_TX_MAC_IP0.packet_mii[0].c;
   // PATH-FIX: assign spy_if_ip0.mii_valid_tx		       = `GDR_TX_MAC_IP0.mii_valid;
   // PATH-FIX: assign spy_if_ip0.rx_mac_mii_clk	       = `GDR_RX_MAC_IP0.i_clk & `GDR_RX_MAC_IP0.mii_valid;
   // PATH-FIX: assign spy_if_ip0.o_rx_valid            = dut.ip0.alt_ehipc3_hard_inst.o_rx_valid; // RAMI-FIX GDR hier 
   // PATH-FIX: assign spy_if_ip0.stop_flow             = `GDR_TX_MAC_IP0.tag_gen.preamble.stop_flow;
   assign spy_if_ip0.rx_dsk_done     = eth_env_top.dut.ip0.top_ip0.sip_inst.ehip_rx_dsk_done ;
   `ifndef PTP_EN
        //assign spy_if_ip0.tx_pll_locked   = eth_env_top.dut.ip0.top_ip0.sip_inst.xcvr_txpll_locked[3:0];
        //assign spy_if_ip0.cdr_lock        = eth_env_top.dut.ip0.top_ip0.sip_inst.xcvr_rxcdr_locked[3:0];
        assign spy_if_ip0.tx_pll_locked   = eth_env_top.dut.ip0.top_ip0.sip_inst.tx_pll_locked_csr[7:0];
        assign spy_if_ip0.cdr_lock        = eth_env_top.dut.ip0.top_ip0.sip_inst.eiofreq_lock_csr[7:0];
   `endif



`ifdef CR3TOP_SIMPLE_SERDES

   initial 
   begin 

       // RAMI-FIX path for GDR and scales as per phy channels (possibly using GDR_XCVR_IP0)
       // PATH-FIX: force eth_env_top.dut.ip0.alt_ehipc3_hard_inst.Dynamic_Reconfig.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.ct1_hssirtl_c3xcvr_inst.die_specific_inst.x_c3xcvr.i_async_reset_n = 0;
       //force eth_env_top.dut.ip0
       //force eth_env_top.dut.ip0
       //force eth_env_top.dut.ip0
           #10ns  ;
       // PATH-FIX: release eth_env_top.dut.ip0.alt_ehipc3_hard_inst.Dynamic_Reconfig.altera_xcvr_native_inst.xcvr_native_s10_etile_0_example_design_4ln_ptp.g_xcvr_native_insts[0].ct3_xcvr_native_inst.inst_ct3_xcvr_channel.inst_ct3_hssi_xcvr.ct3_hssi_xcvr_encrypted_inst.ct1_hssirtl_c3xcvr_inst.die_specific_inst.x_c3xcvr.i_async_reset_n;
       //release eth_env_top.dut.ip0
       //release eth_env_top.dut.ip0
       //release eth_env_top.dut.ip0

   end

`endif 
   
   
            //For FB#602451 RAMI-FIX GDR hier, needed??
            //assign spy_if_ip0.tx_pma_ready = eth_env_top.dut.ip0.o_sl_tx_pma_ready[i];
            //assign spy_if_ip0.rx_pma_ready = eth_env_top.dut.ip0.o_sl_rx_pma_ready[i];
	    
 `ifndef NON_ANLT_PTP 
`ifndef PTP_EN
 `ifdef ENABLE_ETH_VIP       //schauh1x	
       `SVT_ETHERNET_TEST_SUITE_TOP_INST(0,signal_map_if[0],directed_if[0])
 `endif
 `endif
 `endif



