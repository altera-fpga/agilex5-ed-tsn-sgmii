//This template file only include PTP related signals
///////////////
// start DUT <NUM_INST> wires
///////////////
 wire i_clk_tx_tod_ip0;
 wire i_clk_rx_tod_ip0;
 wire [1:0] i_ptp_ts_req_ip0;
 wire [15:0] i_ptp_fp_ip0;
 wire [1:0] i_ptp_ins_ets_ip0;
 wire [1:0] i_ptp_ins_cf_ip0;
 wire [1:0] i_ptp_zero_csum_ip0;
 wire [1:0] i_ptp_update_eb_ip0;
 wire [1:0] i_ptp_p2p_ip0;
 wire [1:0] i_ptp_asym_ip0;
 wire [1:0] i_ptp_asym_sign_ip0;
 wire [13:0] i_ptp_asym_p2p_idx_ip0;
 wire [1:0] i_ptp_ts_format_ip0;
 wire [31:0] i_ptp_ts_offset_ip0;
 wire [31:0] i_ptp_cf_offset_ip0;
 wire [31:0] i_ptp_csum_offset_ip0;
 wire [191:0] i_ptp_tx_its_ip0;
 reg [95:0] i_ptp_tx_tod_ip0;
 reg [95:0] i_ptp_rx_tod_ip0;
 wire tx_ptp_offset_data_valid_ip0;
 wire rx_ptp_offset_data_valid_ip0;
 wire tx_ptp_ready_ip0;
 wire rx_ptp_ready_ip0;
 wire [191:0] o_ptp_ets_ip0;
 wire [15:0] o_ptp_ets_fp_ip0;
 wire [1:0] o_ptp_ets_valid_ip0;
 wire [9:0] o_ptp_ets_vl_ip0;
 wire [191:0] o_ptp_rx_its_ip0;
 wire [1:0] o_ptp_rx_its_valid_ip0;
 wire [9:0] o_ptp_rx_its_vl_ip0;
 wire [15:0] o_ptp_eb_offset_ip0;

///////////////
// end DUT port wires 
/////////////// 

//QHIP_ACC_TESTING
`include "acc_mon_sig_assigns_ip0.sv"

//WB debug signals
`include "WB_debug_signal_ip0.sv"


//TODO REVIEW
assign i_clk_tx_tod_ip0 = clk_tx_div_ip0; 
assign i_clk_rx_tod_ip0 = clk_rec_div_ip0; 
reg i_clk_ptp_sample_ip0	= 1'b0; // 125M (TBD)   //internally generated    
//assign reconfig_reset_ip0 =  ~reset_if_ip0.csr_rst_n;
always
    #4375  i_clk_ptp_sample_ip0 = ~i_clk_ptp_sample_ip0; // set to 114.2857MHz 

   //<<=== TODO REVIEW later
   logic      clk_sys_ip0=0;       
   wire       i_clk_sys;
   assign i_clk_sys = clk_sys_ip0;
   always begin #1250ps clk_sys_ip0 = ~clk_sys_ip0;
   force eth_env_top.dut.ip0.top_ip0.i_src_ip_clk = clk_sys_ip0;
   end
   //TODO REVIEW ===>>

`include "basic_test_params_ip0.v"
//any new addtions needs to be added after PORT wires

   //---------------------------------------------------------------------------
   //  UVC Instances 
   //---------------------------------------------------------------------------

   //initial begin
   //  uvm_config_db #(ptp_tx)::set(null,"*","ptp_tx_interface",ptp_tx_if_ip0);
   //  //uvm_config_db #(virtual ptp_tx_interface)::set(null,"*","ptp_tx_interface",ptp_tx_if_ip0);
   //  uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","ptp_tx_rtb_path","ptp_tx_rtb_ip0");
   //end

   ptp_tx_interface#(.NUM_WORDS(x),.FP_WIDTH(y)) ptp_tx_if_ip0 (clk_tx_ip0,clk_rx_ip0,reset_ip0);
   ptp_tx_rtb_module ptp_tx_rtb_ip0(.mon_if(ptp_tx_if_ip0),.v_if_seg(seg_tx_if_ip0),.inst_num(0)); 
   
   initial begin
      uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","ptp_tx_rtb_path","ptp_tx_rtb_ip0");
   end

//---------------------------------ptp_signal-------------------------------------
assign i_ptp_ts_req_ip0       = seg_tx_if_ip0.i_ptp_ts_req;
assign i_ptp_fp_ip0           = seg_tx_if_ip0.i_ptp_fp;
assign i_ptp_ins_cf_ip0       = seg_tx_if_ip0.i_ptp_ins_cf;
assign i_ptp_ins_ets_ip0      = seg_tx_if_ip0.i_ptp_ins_ets;
assign i_ptp_zero_csum_ip0    = seg_tx_if_ip0.i_ptp_0csum; 
assign i_ptp_update_eb_ip0    = seg_tx_if_ip0.i_ptp_update_eb;
assign i_ptp_ts_format_ip0    = seg_tx_if_ip0.i_ptp_ts_format;
assign i_ptp_ts_offset_ip0    = seg_tx_if_ip0.i_ptp_ts_offset;
assign i_ptp_cf_offset_ip0    = seg_tx_if_ip0.i_ptp_cf_offset;
assign i_ptp_csum_offset_ip0  = seg_tx_if_ip0.i_ptp_csum_offset;
assign i_ptp_tx_its_ip0       = seg_tx_if_ip0.i_ptp_tx_its;

assign ptp_tx_if_ip0.o_ptp_ets_valid= o_ptp_ets_valid_ip0; 
assign ptp_tx_if_ip0.o_ptp_ets      = o_ptp_ets_ip0;      
assign ptp_tx_if_ip0.o_ptp_ets_fp   = o_ptp_ets_fp_ip0;
assign ptp_tx_if_ip0.o_ptp_ets_vl   = o_ptp_ets_vl_ip0;
assign ptp_tx_if_ip0.o_ptp_its_vl   = o_ptp_rx_its_vl_ip0;
//assign ptp_tx_if_ip0.o_ptp_rx_sop   = rx_startofpacket_ip0;  //need to fix        
assign ptp_tx_if_ip0.o_ptp_rx_sop   = {seg_rx_if_ip0.found_sop_upper,seg_rx_if_ip0.found_sop_lower};  //need to fix  
assign ptp_tx_if_ip0.o_ptp_rx_its   = o_ptp_rx_its_ip0; 
assign ptp_tx_if_ip0.o_ptp_rx_valid = rx_mac_valid_ip0;    // need to know
assign ptp_tx_if_ip0.o_ptp_rx_its_valid = o_ptp_rx_its_valid_ip0; 
//rk assign ptp_eb_offset_ip0    = seg_tx_if_ip0.      //eb_offset not required commented in the avst interface .
//rk assign ptp_tx_its_ip0       = eth_sideband_if_ip0.ptp_ts & {191{tx_avst_if_ip0.startofpacket}};

assign i_ptp_p2p_ip0     			= seg_tx_if_ip0.i_ptp_p2p; 
assign i_ptp_asym_ip0   			= seg_tx_if_ip0.i_ptp_asym;
assign i_ptp_asym_sign_ip0    	= seg_tx_if_ip0.i_ptp_asym_sign;
assign i_ptp_asym_p2p_idx_ip0 	= seg_tx_if_ip0.i_ptp_asym_p2p_idx;
assign i_ptp_tx_tod_ip0          = seg_tx_if_ip0.ptp_tx_tod;
assign i_ptp_rx_tod_ip0          = seg_tx_if_ip0.ptp_rx_tod;
//--------------------------------------------------------------------------------
assign i_ptp_tx_tod_valid_ip0 = 1;//temp assign to 1
assign i_ptp_rx_tod_valid_ip0 = 1;//temp assign to 1
    
//`ifdef ENABLE_ETH_VIP
//
//        always @(/*reset_if_ip0.csr_rst_n*/ eth_env_top.dut.i_tx_rst_n_ip0 or soft_reset_ip0) //TODO: Temporary workaround to use tx_rst_n to deassert VIP reset. Cannot use reset_if_ip0.csr_rst_n as it is assigned to rst_n_ip0 
//        begin
//            svt_ethernet_txrx_if[0].reset = (/*~reset_if_ip0.csr_rst_n | */soft_reset_ip0 | ~eth_env_top.dut.i_tx_rst_n_ip0); //TODO_GDR: Temporary workaround to use tx_rst_n to deassert VIP reset. Cannot use reset_if_ip0.csr_rst_n as it is assigned to rst_n_ip0 
//        end
////    `endif
//    
//`endif


	 //if(`phy_refclk_ip0 == 0 || `phy_refclk_ip0 == 156.250000) always #3200 clk_ref_ip0 = ~clk_ref_ip0;                
	 //if(`phy_refclk_ip0 == 1 || `phy_refclk_ip0 == 322.265625) always #1551.51515 clk_ref_ip0 = ~clk_ref_ip0;
	 //if(`phy_refclk_ip0 == 2 || `phy_refclk_ip0 == 312.500000) always #1600 clk_ref_ip0 = ~clk_ref_ip0;
	 //if(`phy_refclk_ip0 == 3 || `phy_refclk_ip0 == 644.531250) always #775.757575  clk_ref_ip0 = ~clk_ref_ip0;


   //eth_sideband_interface eth_sideband_if_ip0(eth_env_top.dut.i_clk_tx_tod_ip0,reset_ip0, eth_env_top.dut.i_clk_rx_tod_ip0); //TODO_GDR: HSD#https://hsdes.intel.com/resource/1507872745



	 

   // interface connections spy_if
   assign spy_if_ip0.o_tx_am = eth_env_top.dut.ptp_adpt_f.hip_inst.rx_parallel_ptp_data_aib7[3]; //above commented code should work till that its a workaround 
   assign spy_if_ip0.o_rx_am = eth_env_top.dut.ptp_adpt_f.hip_inst.rx_parallel_ptp_data_aib7[6];
	assign spy_if_ip0.ptp_cf_r= i_ptp_ins_cf_ip0; //TODO:not use in macseg?
	assign spy_if_ip0.o_tx_ptp_ready = eth_env_top.dut.o_tx_ptp_ready_ip0;
	assign spy_if_ip0.o_rx_ptp_ready = eth_env_top.dut.o_rx_ptp_ready_ip0;


