// Start DUT port wires
  logic [1023:0]       tx_mii_d_ip0;
  logic [1023:0]       rx_mii_d_ip0;
  logic [127:0]        tx_mii_c_ip0;
  logic [127:0]        rx_mii_c_ip0;
  logic [63:0]       dut_mii_tx_data_ip0;
  logic [63:0]       dut_mii_rx_data_ip0;
  logic [7:0]        dut_mii_tx_ctrl_ip0;
  logic [7:0]        dut_mii_rx_ctrl_ip0;
  logic                    tx_mii_valid_ip0;
  logic                    tx_mii_am_ip0;
  logic                    tx_mii_ready_ip0;
  logic                    rx_mii_valid_ip0;
  logic                    rx_mii_am_valid_ip0;
  logic                    rx_block_lock_ip0;
  logic                    i_clk_a_ip0;
  logic                    i_clk_b_ip0;
  logic                    clk_status_ip0=0;
  logic                    reset_ip0;
  wire 	                   rx_pcs_ready_ip0;
  wire                     rx_pause_ip0;
  wire 		           tx_lanes_stable_ip0;    
  wire 			   rx_hi_ber_ip0;            
  wire 			   rx_am_lock_ip0;            
  wire 			   local_fault_status_ip0;            
  wire 			   remote_fault_status_ip0;            
  reg  	                   stats_snapshot_ip0;
  wire  	           rx_block_lock_ip0;              
  wire                     clk_ip0;
  wire                     clk_tx_ip0;
  wire                     clk_rx_ip0;
  wire                     reconfig_clk_ip0;
  logic                    clk_ref_ip0=0;       
  logic                    clk_sys_ip0=0;       
  reg                      rst_n_ip0;
  wire                     rst_ack_n_ip0;
  reg                      tx_rst_n_ip0;
  wire                     tx_rst_ack_n_ip0;
  reg  	                   rx_rst_n_ip0;
  wire                     rx_rst_ack_n_ip0;
  wire 			   rx_pcs_fully_aligned_ip0;            
  logic                    reconfig_reset_ip0;    
  wire 		           tx_pll_locked_ip0;    
  wire 		           cdr_locked_ip0;    
  reg                      custom_cadence_ip0;
  reg  	                   reconfig_eth_write_ip0;         
  reg  	                   reconfig_eth_read_ip0;          
  reg [19:0]               reconfig_eth_addr_ip0;       
  reg [31:0]               reconfig_eth_writedata_ip0;     
  reg  [3:0]               reconfig_eth_byteenable_ip0;         
  wire [31:0]               reconfig_eth_readdata_ip0;      
  wire 	                   reconfig_eth_waitrequest_ip0;   
  wire 	                   reconfig_eth_readdata_valid_ip0; 
  wire 	                   tx_tod_clk;
  wire 	                   rx_tod_clk; 
  wire                     i_clk_sys;
  reg  	                  reconfig_xcvr0_write_ip0;         
  reg  	                  reconfig_xcvr0_read_ip0;
  reg  [3:0]              reconfig_xcvr0_byteenable_ip0;  
  reg [19:0]              reconfig_xcvr0_address_ip0;       
  reg [31:0]              reconfig_xcvr0_writedata_ip0;     
  wire [31:0]              reconfig_xcvr0_readdata_ip0;
  wire 	                  reconfig_xcvr0_waitrequest_ip0;   
  wire 	                  reconfig_xcvr0_readdata_valid_ip0; 

// end DUT port wires

`include "basic_test_params_ip0.v"

   assign i_clk_sys = clk_sys_ip0;
   always begin #500ps clk_sys_ip0 = ~clk_sys_ip0;
   force eth_env_top.dut.ip0.top_ip0.i_src_ip_clk = clk_sys_ip0;
   end

`define CAL_MII_DATA_CTRL_IP0(ITN,SRC,DEFAULT)\
      (((spy_if_ip0.speed == _10G)  && ((ITN-1)<1)) || ((spy_if_ip0.speed == _25G)  && ((ITN-1)<1)) || ((spy_if_ip0.speed == _40G)  && ((ITN-1)<2)) || ((spy_if_ip0.speed == _50G)  && ((ITN-1)<2)) || ((spy_if_ip0.speed == _100G) && ((ITN-1)<4)) || ((spy_if_ip0.speed == _200G) && ((ITN-1)<8)) || ((spy_if_ip0.speed == _400G) && ((ITN-1)<16))) ? SRC : DEFAULT
`define INST_IP0 1//Note for Kanishk: 1 for 10/25G, 2 for 40/50G, 4 for 100G, 8 for 200G and 16 for 400G 

  ehip_mii_tx_if             mii_tx_uif_ip0();
  ehip_mii_tx_if             mii_rx_uif_ip0();
  reset_if                   reset_if_ip0();
  vector_uvc_interface       eth_vector_rx_if_ip0(clk_pll_ip0,reset_ip0);
  eth_sideband_interface eth_sideband_if_ip0(.rst(reset_ip0),
                                              .clk(clk_pll_ip0),
                                              .tx_tod_clk(tx_tod_clk),
                                              .rx_tod_clk(rx_tod_clk));
  spy_interface#(.IP("ip0")) spy_if_ip0(); 

   initial begin
     ts_tasks_if[0].event_load_align_marker_error    = svt_ethernet_drv_0.Bfm.event_load_align_marker_error; //Alex: added for pcs_am_lock sequencce support 
     spy_if_ip0.event_mac_idle_detected_rx           = svt_ethernet_mon_chk_0.Chk.event_mac_idle_detected_rx;
     spy_if_ip0.event_chk_no_eop_tx                  = svt_ethernet_mon_chk_0.Chk.event_chk_no_term_char_found_tx;
     ts_tasks_if[0].event_10g_multilane_insert_align_block = svt_ethernet_drv_0.Bfm.multilane_10g.event_insert_align_block; 
     ts_tasks_if[0].event_10g_multilane_insert_66b_block   = svt_ethernet_drv_0.Bfm.event_10g_multilane_insert_66b_block;  
     ts_tasks_if[0].event_xsbi_66b_block_loaded = svt_ethernet_drv_0.Bfm.event_xsbi_66b_block_loaded; // added for pcs_err_druing_lock sequence 25G
     ts_tasks_if[0].event_insert_xxvsbi_align_marker    = svt_ethernet_drv_0.Bfm.event_insert_xxvsbi_align_marker; //added for pcs_wrong_am_interval sequence 25G
   end
  initial begin
      uvm_config_db #(virtual ehip_mii_tx_if)::set(uvm_root::get(),"*env_ip0","mii_tx_if",mii_tx_uif_ip0);  //PRASH
      uvm_config_db #(virtual ehip_mii_tx_if)::set(uvm_root::get(),"*env_ip0","mii_rx_if",mii_rx_uif_ip0);  //PRASH
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","dut_name","*dut_25g_ip0");    //PRASH not used anywhere     
      uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "mst_if",eth_sideband_if_ip0); 
      uvm_config_db #(v_if1)::set(uvm_root::get(),"*env_ip0", "slv_if",eth_sideband_if_ip0); 
      uvm_config_db #(virtual vector_uvc_interface)::set(uvm_root::get(), "*env_ip0.rx_vector_agent*","vector_if",eth_vector_rx_if_ip0); //PRASH
      `ifdef ENABLE_ETH_VIP
     ts_tasks_if[0].ip = 0; //ALEX new: ts_task_if[i].ip = i, for INST[i] which needs SEG template
        uvm_config_db#(virtual eth_testsuite_tasks_intf)::set(uvm_root::get(),"*env_ip0","ts_tasks_if",ts_tasks_if[0]);  //PRASH
        uvm_config_db#(virtual svt_ethernet_txrx_if)::set(uvm_root::get(),"*env_ip0", "if_port", svt_ethernet_txrx_if[0]); //PRASH
        `ifndef NON_ANLT_PTP 
          uvm_config_db#(virtual svt_ethernet_test_suite_if)::set(uvm_root::get(),"*ts_component0*", "if_directed", directed_if[0]); //PRASH
        `endif
      `endif
      uvm_config_db #(virtual reset_if)::set (null, "*env_ip0", "slv_if", reset_if_ip0); 
      uvm_config_db #(v_if2)::set (null, "*env_ip0", "spy_interface", spy_if_ip0); 
      uvm_config_db #(v_if2)::set (uvm_root::get(),"*.mii_tx_agent*", "spy_if_mii", spy_if_ip0); 
  end

  assign mii_tx_uif_ip0.clk              = clk_pll_ip0;//div64_ip0;   //[TODO]
  assign mii_tx_uif_ip0.rst_n            = reset_if_ip0.tx_rst_n;
  assign mii_rx_uif_ip0.clk              = clk_pll_ip0;//div64_ip0;   //[TODO]
  assign mii_rx_uif_ip0.rst_n            = reset_if_ip0.rx_rst_n;
  assign tx_mii_valid_ip0              = mii_tx_uif_ip0.vld;
  assign tx_mii_am_ip0                 = mii_tx_uif_ip0.am_insert;
  assign mii_tx_uif_ip0.rdy              = tx_mii_ready_ip0;
  assign mii_rx_uif_ip0.vld              = rx_mii_valid_ip0;
  assign mii_rx_uif_ip0.am               = rx_mii_am_valid_ip0;
  assign mii_rx_uif_ip0.rx_am_lock       = rx_am_lock_ip0;
  assign mii_rx_uif_ip0.rx_blk_lock      = rx_block_lock_ip0;
  assign mii_tx_uif_ip0.rx_pcs_fully_aligned	   = rx_pcs_fully_aligned_ip0;

  //TODO: FIXME multi dimensional array issue 
  assign mii_rx_uif_ip0.data[0]          = rx_mii_d_ip0;
  assign mii_rx_uif_ip0.data[1]          = (spy_if_ip0.speed inside {_40G, _50G, _100G, _200G, _400G}) ? rx_mii_d_ip0[127:64] : 'b0;
  assign mii_rx_uif_ip0.data[2]          = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? rx_mii_d_ip0[191:128] : 'b0;
  assign mii_rx_uif_ip0.data[3]          = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? rx_mii_d_ip0[255:192] : 'b0;
  assign mii_rx_uif_ip0.data[4]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_d_ip0[319:256] : 'b0;
  assign mii_rx_uif_ip0.data[5]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_d_ip0[383:320] : 'b0;
  assign mii_rx_uif_ip0.data[6]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_d_ip0[447:384] : 'b0;
  assign mii_rx_uif_ip0.data[7]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_d_ip0[511:448] : 'b0;
  assign mii_rx_uif_ip0.data[8]          = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[575:512] : 'b0;
  assign mii_rx_uif_ip0.data[9]          = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[639:576] : 'b0;
  assign mii_rx_uif_ip0.data[10]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[703:640] : 'b0;
  assign mii_rx_uif_ip0.data[11]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[767:704] : 'b0;
  assign mii_rx_uif_ip0.data[12]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[831:768] : 'b0;
  assign mii_rx_uif_ip0.data[13]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[895:832] : 'b0;
  assign mii_rx_uif_ip0.data[14]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[959:896] : 'b0;
  assign mii_rx_uif_ip0.data[15]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_d_ip0[1023:960] : 'b0;

  assign mii_rx_uif_ip0.ctl[0]           = rx_mii_c_ip0;
  assign mii_rx_uif_ip0.ctl[1]          = (spy_if_ip0.speed inside {_40G, _50G, _100G, _200G, _400G}) ? rx_mii_c_ip0[15:8] : 'b0;
  assign mii_rx_uif_ip0.ctl[2]          = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? rx_mii_c_ip0[23:16] : 'b0;
  assign mii_rx_uif_ip0.ctl[3]          = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? rx_mii_c_ip0[31:24] : 'b0;
  assign mii_rx_uif_ip0.ctl[4]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_c_ip0[39:32] : 'b0;
  assign mii_rx_uif_ip0.ctl[5]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_c_ip0[47:40] : 'b0;
  assign mii_rx_uif_ip0.ctl[6]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_c_ip0[55:48] : 'b0;
  assign mii_rx_uif_ip0.ctl[7]          = (spy_if_ip0.speed inside {_200G, _400G}) ? rx_mii_c_ip0[63:56] : 'b0;
  assign mii_rx_uif_ip0.ctl[8]          = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[71:64] : 'b0;
  assign mii_rx_uif_ip0.ctl[9]          = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[79:72] : 'b0;
  assign mii_rx_uif_ip0.ctl[10]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[87:80] : 'b0;
  assign mii_rx_uif_ip0.ctl[11]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[95:88] : 'b0;
  assign mii_rx_uif_ip0.ctl[12]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[103:96] : 'b0;
  assign mii_rx_uif_ip0.ctl[13]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[111:104] : 'b0;
  assign mii_rx_uif_ip0.ctl[14]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[119:112] : 'b0;
  assign mii_rx_uif_ip0.ctl[15]         = (spy_if_ip0.speed inside {_400G}) ? rx_mii_c_ip0[127:120] : 'b0;

  assign tx_mii_d_ip0[63:0]              = mii_tx_uif_ip0.data[0];
  assign tx_mii_d_ip0[127:64]            = (spy_if_ip0.speed inside {_40G, _50G, _100G, _200G, _400G}) ? mii_tx_uif_ip0.data[1] : 'b0;
  assign tx_mii_d_ip0[191:128]           = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? mii_tx_uif_ip0.data[2] : 'b0;
  assign tx_mii_d_ip0[255:192]           = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? mii_tx_uif_ip0.data[3] : 'b0;
  assign tx_mii_d_ip0[319:256]           = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.data[4] : 'b0;
  assign tx_mii_d_ip0[383:320]           = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.data[5] : 'b0;
  assign tx_mii_d_ip0[447:384]           = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.data[6] : 'b0;
  assign tx_mii_d_ip0[511:448]           = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.data[7] : 'b0;
  assign tx_mii_d_ip0[575:512]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[8] : 'b0;
  assign tx_mii_d_ip0[639:576]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[9] : 'b0;
  assign tx_mii_d_ip0[703:640]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[10] : 'b0;
  assign tx_mii_d_ip0[767:704]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[11] : 'b0;
  assign tx_mii_d_ip0[831:768]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[12] : 'b0;
  assign tx_mii_d_ip0[895:832]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[13] : 'b0;
  assign tx_mii_d_ip0[959:896]           = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[14] : 'b0;
  assign tx_mii_d_ip0[1023:960]          = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.data[15] : 'b0;

  assign tx_mii_c_ip0[7:0]                    = mii_tx_uif_ip0.ctl[0];
  assign tx_mii_c_ip0[15:8]            = (spy_if_ip0.speed inside {_40G, _50G, _100G, _200G, _400G}) ? mii_tx_uif_ip0.ctl[1] : 'b0;
  assign tx_mii_c_ip0[23:16]            = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? mii_tx_uif_ip0.ctl[2] : 'b0;
  assign tx_mii_c_ip0[31:24]            = (spy_if_ip0.speed inside {_100G, _200G, _400G}) ? mii_tx_uif_ip0.ctl[3] : 'b0;
  assign tx_mii_c_ip0[39:32]            = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.ctl[4] : 'b0;
  assign tx_mii_c_ip0[47:40]            = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.ctl[5] : 'b0;
  assign tx_mii_c_ip0[55:48]            = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.ctl[6] : 'b0;
  assign tx_mii_c_ip0[63:56]            = (spy_if_ip0.speed inside {_200G, _400G}) ? mii_tx_uif_ip0.ctl[7] : 'b0;
  assign tx_mii_c_ip0[71:64]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[8] : 'b0;
  assign tx_mii_c_ip0[79:72]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[9] : 'b0;
  assign tx_mii_c_ip0[87:80]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[10] : 'b0;
  assign tx_mii_c_ip0[95:88]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[11] : 'b0;
  assign tx_mii_c_ip0[103:96]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[12] : 'b0;
  assign tx_mii_c_ip0[111:104]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[13] : 'b0;
  assign tx_mii_c_ip0[119:112]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[14] : 'b0;
  assign tx_mii_c_ip0[127:120]            = (spy_if_ip0.speed inside {_400G}) ? mii_tx_uif_ip0.ctl[15] : 'b0;

  
  assign rst_n_ip0                       = reset_if_ip0.csr_rst_n;
  assign tx_rst_n_ip0                    = reset_if_ip0.tx_rst_n;
  assign rx_rst_n_ip0                    = reset_if_ip0.rx_rst_n;
  
  assign reset_if_ip0.rst_ack_n = rst_ack_n_ip0; 
  assign reset_if_ip0.tx_rst_ack_n = tx_rst_ack_n_ip0; 
  assign reset_if_ip0.rx_rst_ack_n = rx_rst_ack_n_ip0;

  assign custom_cadence_ip0         = eth_sideband_if_ip0.custom_cadence;
  assign stats_snapshot_ip0         = eth_sideband_if_ip0.snapshot_en;
  assign eth_sideband_if_ip0.tx_lane_stable = tx_lanes_stable_ip0;
  assign eth_sideband_if_ip0.rx_pcs_ready   = rx_pcs_ready_ip0;
  assign eth_sideband_if_ip0.rx_pause       = rx_pause_ip0;

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
    assign reconfig_xcvr0_address_ip0         = {3'b0,avmm_xcvr_if_ip0_0.address[17:2]};
    assign reconfig_xcvr0_writedata_ip0       = avmm_xcvr_if_ip0_0.writedata;
    assign avmm_xcvr_if_ip0_0.readdata         = reconfig_xcvr0_readdata_ip0;
    assign avmm_xcvr_if_ip0_0.waitrequest      = reconfig_xcvr0_waitrequest_ip0;    
    assign avmm_xcvr_if_ip0_0.readdatavalid    = reconfig_xcvr0_readdata_valid_ip0;

    assign clk_rx_ip0 = clk_pll_ip0;
    assign clk_tx_ip0 = clk_pll_ip0;

  //generate 
  //    for(genvar l=16; l>0; l--) begin:MII_IP0
  //       assign mii_tx_data_ip0[l-1]   = `CAL_MII_DATA_CTRL_IP0(l,mii_tx_uif_ip0.data[l-1],64'h0);
  //       assign mii_tx_ctrl_ip0[l-1]   = `CAL_MII_DATA_CTRL_IP0(l,mii_tx_uif_ip0.ctl[l-1] ,8'h0 );
  //       assign mii_rx_data_ip0[l-1]   = `CAL_MII_DATA_CTRL_IP0(l,dut_mii_rx_data_ip0[l-1],64'h0);
  //       assign mii_rx_ctrl_ip0[l-1]   = `CAL_MII_DATA_CTRL_IP0(l,dut_mii_rx_ctrl_ip0[l-1],8'h0 );
  //    end
  //endgenerate
  //generate
  //    for(genvar i=0;i<`INST_IP0;i++)begin:DUT_MII_IP0
  //       assign dut_mii_tx_data_ip0[i] =  mii_tx_data_ip0[`INST_IP0-i-1];
  //       assign dut_mii_tx_ctrl_ip0[i] =  mii_tx_ctrl_ip0[`INST_IP0-i-1];
  //       assign mii_rx_uif_ip0.data[i] =  mii_rx_data_ip0[`INST_IP0-i-1];
  //       assign mii_rx_uif_ip0.ctl[i]  =  mii_rx_ctrl_ip0[`INST_IP0-i-1];
  //    end
  //endgenerate

  //-----------------------------------------------------------------------------
  // UVC Instances
  //-----------------------------------------------------------------------------
  altera_avalon_mm_if #(`AVMM_CFG_SHARED_INF_INST) avmm_if_ip0 (
	 		     .clk                       (clk_status_ip0),
	 		     .reset                     (reconfig_reset_ip0)
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
	 		            .reset                     (reconfig_reset_ip0)
               );
   altuvm_avalon_mm_rtb #(`AVMM_XCVR_CFG_SHARED_INF_INST,
           .IS_ACTIVE                 (UVM_ACTIVE),
           .BFM_TYPE                  (altuvm_avalon_mm_pkg::AVALON_MM_MASTER)
               ) avmm_xcvr_rtb_ip0_0 (.uif(avmm_xcvr_if_ip0_0));

   initial begin        
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0","avmm_xcvr_rtb_path_0","avmm_xcvr_rtb_ip0_0");
   end  

   //Adding AVMM interface for ENV hierarchy
  // initial begin
  //     uvm_config_db #(virtual altera_avalon_mm_if)::set(null,"*env_ip0*","status_if",avmm_if_ip0);
  // end

     bit 				    soft_reset_ip0;
     bit[31:0] REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
     assign REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_ip0.address[17:0] == `REGISTERS_eth_reset_OFFSET_REG) && (avmm_if_ip0.write == 1'b1)) ? avmm_if_ip0.writedata : REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
     assign  soft_reset_ip0 =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];


     assign spy_if_ip0.eio_soft_rst =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
     assign spy_if_ip0.tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[1];
     assign spy_if_ip0.rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[2];     
  //-----------------------------------------------------------------------------
  // VIP Instances 
  //-----------------------------------------------------------------------------
`ifdef ENABLE_ETH_VIP

   svt_ethernet_xxm_bfm_driver     svt_ethernet_drv_0(svt_ethernet_txrx_if[0]); 
   svt_ethernet_xxm_mon_chk_driver svt_ethernet_mon_chk_0(svt_ethernet_txrx_if[0]); 

        always @(reset_if_ip0.csr_rst_n or soft_reset_ip0 or reset_if_ip0.vip_rst or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or spy_if_ip0.tx_soft_rst or spy_if_ip0.rx_soft_rst)
        begin
            `uvm_info("event",$sformatf("change in reset triggered\n"),UVM_LOW);
            svt_ethernet_txrx_if[0].reset = (~reset_if_ip0.csr_rst_n | soft_reset_ip0 | reset_if_ip0.vip_rst | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | spy_if_ip0.tx_soft_rst | spy_if_ip0.rx_soft_rst);  
        end

  `endif

    always @(tx_lanes_stable_ip0 or reset_if_ip0.csr_rst_n or reset_if_ip0.tx_rst_n or reset_if_ip0.rx_rst_n or soft_reset_ip0)
    begin
       assertion_on_off_reset[0] = (~tx_lanes_stable_ip0 | ~reset_if_ip0.csr_rst_n | ~reset_if_ip0.tx_rst_n | ~reset_if_ip0.rx_rst_n | soft_reset_ip0); 
    end


   assign reconfig_clk_ip0     = clk_status_ip0;
   assign clk_ip0              = clk_pll_ip0;
   assign reset_ip0            = ~reset_if_ip0.csr_rst_n;
   assign reset_if_ip0.clock   = clk_status_ip0;

  initial begin
    assign reconfig_reset_ip0 =  reset_if_ip0.reconfig_rst_n;
    #500ns;
    assign reconfig_reset_ip0 =  ~reset_if_ip0.reconfig_rst_n;
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

      initial
       begin
     //This assertion is disabeld based on discussion with uvc owner,i.e reset is applied by user
     avmm_rtb_ip0.monitor.u_bfm.master_assertion.enable_a_half_cycle_reset_legal = 0;
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
//HSD:16013763023
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


   // interface connections spy_if
   assign spy_if_ip0.o_rx_hi_ber = rx_hi_ber_ip0;
   assign spy_if_ip0.rx_am_lock = rx_am_lock_ip0;
   assign spy_if_ip0.rx_block_lock = rx_block_lock_ip0;
   assign spy_if_ip0.rx_pcs_ready = rx_pcs_ready_ip0;
   assign spy_if_ip0.soft_reset = soft_reset_ip0;
   assign spy_if_ip0.clk                  = clk_ref_ip0;
   assign spy_if_ip0.rx_dsk_done     = eth_env_top.dut.ip0.top_ip0.sip_inst.ehip_rx_dsk_done ;
   assign spy_if_ip0.o_tx_ready     = eth_env_top.dut.o_tx_mii_ready_ip0 ;
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

`ifdef CR3TOP_SIMPLE_SERDES
   initial 
   begin 
           #10ns  ;
   end
`endif 


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
  //-----------------------------------------------------------------------------
  // Expected DUT port connections [begin]
  //-----------------------------------------------------------------------------
	          .i_tx_mii_d(dut_mii_tx_data_ip0),            // mii tx data 
	          .i_tx_mii_c(dut_mii_tx_ctrl_ip0),            // mii tx control
	          .i_tx_mii_valid(i_tx_mii_valid_ip0),         // mii tx valid
	          .i_tx_mii_am(i_tx_mii_am_ip0),               // mii tx am insert
	          .o_tx_mii_ready(o_tx_mii_ready),             // mii tx ready 
	          .o_rx_mii_d(dut_mii_rx_data_ip0),            // mii rx data
	          .o_rx_mii_c(dut_mii_rx_ctrl_ip0),            // mii rx control   
	          .o_rx_mii_valid(o_rx_mii_valid_ip0),         // mii rx valid            
	          .o_rx_mii_am_valid(o_rx_mii_am_valid_ip0),       // mii rx AM          
	          .o_rx_am_lock(o_rx_am_lock_ip0),    // Asserted when RX PCS has found detected alignment markers and deskewed PCS lanes.
	          .o_rx_block_lock(o_rx_block_lock_ip0)// Asserted when 66b block alignment is finished on all PCS lanes

  //-----------------------------------------------------------------------------
  // Expected DUT port connections [end]
  //-----------------------------------------------------------------------------
  */
