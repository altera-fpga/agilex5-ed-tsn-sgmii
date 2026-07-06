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


`ifndef SPY_INTERFACE__SV
 `define SPY_INTERFACE__SV

interface spy_interface;
    
   import eth_env_pkg::*;

   parameter string IP="ip0";
   parameter string DUT_TOP="\$root.eth_env_top.dut.";

   logic pcs_ready;
   logic block_lock;
   logic rx_am_lock;
   logic rx_block_lock;
   logic rx_pcs_ready;
   logic deskew_lock;
   logic rx_dsk_done;
   logic align_lock;
   logic ehip_ready;
   logic ptp_cf_r;
   logic [3:0] rx_is_lockedtodata;
   logic [7:0]  tx_pll_locked;
   logic [7:0] cdr_lock;
   logic  ipg_check_enable;
   bit initial_link_up_done=0;
   bit its_check_disable;
   bit ptp_acc_check_disable;
   bit 	       clk;
   wire [30:0]remote_fault;
   wire remote_fault_status;
   wire [30:0]local_fault;
   wire force_remote_fault;
   wire hi_ber;
   bit xus_timer_done_25g;
   bit xus_timer_done_anlt;
   bit xus_timer_done;
   bit o_rx_hi_ber;
   bit o_rx_valid;
   //bit [3:0] outframe;
   bit  stop_flow;
   logic tx_156_25_clk_sync;
   logic rx_156_25_clk_sync;
 
   bit [3:0] an_ch_sel;

   bit [31:0] debug_signal;
   
   bit [255:0]  mii_data_rx;
   bit [31:0] mii_ctrl_rx;  
   bit  mii_valid_rx;
   bit [63:0] mii_data3_tx;
   bit [63:0] mii_data2_tx;
   bit [63:0] mii_data1_tx;
   bit [63:0] mii_data0_tx;
   bit [7:0]  mii_ctrl3_tx;  
   bit [7:0]  mii_ctrl2_tx;  
   bit [7:0]  mii_ctrl1_tx;  
   bit [7:0]  mii_ctrl0_tx;  
   bit  mii_valid_tx;
   bit [4:0] tx_nonce;
   bit 	     is_100G=1;
   //   bit 	     dr_busy=0;
   bit 	     dr_busy;
   bit 	     soft_reset;
   bit 	     cfg_load_done;
   bit 	     dr_clk_gate;
   bit t_valid=0;    
   bit avst_tx_eop;
   bit avst_tx_sop;
   logic [9:0] sync_window3_cntr; 
   logic [9:0] sync_window2_cntr; 
   logic [9:0] sync_window1_cntr; 
   logic [9:0] sync_window0_cntr; 
   wire [30:0]fault;
   wire eio_soft_rst;
   wire tx_soft_rst;
   wire rx_soft_rst;

   bit soft_tx_rst;
   bit soft_rx_rst;
   wire [30:0]rx_mac_mii_clk;
   int async_clk_freq_tx;
   int async_clk_freq_rx;
   int async_clk_freq_tx_div;
   
   logic [30:0]wb_tx_ets_valid;
   logic [30:0][4:0] wb_tx_ets_vl;
   logic [30:0]wb_rx_its_valid;
   logic [30:0][4:0] wb_rx_its_vl;
   bit pcs_led_an_o;
   bit[2:0] an_state;

  //**************Ported signals for coverage
   logic [1:0] avalon_st_pause_data;
   logic csr_rx_tsfr_sts;
   logic csr_rx_tsfr_en_n;
   logic csr_tx_tsfr_en_n;
   logic csr_rx_pfc_ignore_pausefrm_1;
   logic csr_rx_pfc_fwd;
   logic [2:0] sig_speed_sel_en;
   logic [1:0] sig_avalon_st_pause_data;
   logic [15:0] sig_avalon_st_tx_pause_length_data;
   logic  sig_avalon_st_tx_pause_length_valid;
   logic [71:0] sig_xgmii_tx;
   logic  sig_gmii_tx_en;
   logic [1:0] sig_gmii16b_tx_en;
   logic [15:0] sig_avalon_st_tx_pfc_status_data;
   logic sig_avalon_st_tx_pfc_status_valid;
   logic [15:0] sig_avalon_st_tx_pfc_gen_data;
   logic [6:0] sig_avalon_st_txstatus_error;
   logic [6:0] sig_avalon_st_txstatus_error_reg;
   logic sig_avalon_st_txstatus_valid;
   logic sig_avalon_st_txstatus_valid_reg;
   logic [39:0] sig_avalon_st_txstatus_data;
   logic sig_avalon_st_tx_error;
   logic sig_avalon_st_tx_error_reg;
   logic sig_avalon_st_tx_endofpacket;
   logic sig_avalon_st_tx_valid;    
   logic [15:0] sig_avalon_st_rx_pause_length_data;
   logic sig_avalon_st_rx_pause_length_valid;
   logic [5:0] sig_avalon_st_rx_error;
   logic [5:0] sig_avalon_st_rx_error_reg;
   logic sig_avalon_st_rx_valid;
   logic sig_avalon_st_rx_valid_reg;
   logic sig_avalon_st_rx_endofpacket;
   logic sig_avalon_st_rx_endofpacket_reg;
   logic [6:0] sig_avalon_st_rxstatus_error;
   logic sig_gmii_rx_err_reg;
   logic sig_avalon_st_rxstatus_valid;
   logic sig_avalon_st_rxstatus_valid_reg;
   logic sig_gmii_rx_err;
   logic sig_mii_rx_err;
   logic xgmii_tx_valid;
   logic xgmii_rx_valid;
   logic [31:0] xgmii_tx_data;
   logic [31:0] xgmii_rx_data;
   logic [3:0] xgmii_tx_control;
   logic [3:0] xgmii_rx_control;
   logic sig_avalon_st_rx_ready;
   logic [1:0] sig_link_fault_status_xgmii_rx_data;
   logic [7:0] sig_avalon_st_rx_pfc_pause_data; 
   logic [2:0] sig_speed_sel;
   logic tx_pausefrm_en;
   logic tx_pausefrm_policy;
   logic tx_pad_insrt_en;
   logic [1:0] tx_pausefrm_xonxoff;  
   logic tx_crc_insrt_en;
   logic pfc_priority_num;
   logic enable_preamble_passthrough;
   logic tx_sa_override_en;
   logic tx_pipg_10g_dic;
   logic status_tx_datafrm_tsfr_en_sts;
   logic [15:0] tx_xoff_hqt0;
   logic [15:0] tx_xoff_hqt1;
   logic [15:0] tx_xoff_hqt2;
   logic [15:0] tx_xoff_hqt3;
   logic [15:0] tx_xoff_hqt4;
   logic [15:0] tx_xoff_hqt5;
   logic [15:0] tx_xoff_hqt6;
   logic [15:0] tx_xoff_hqt7;
   logic csr_rx_crc_chk;
   logic [15:0] tx_pfcfrm_pqt0; 
   logic tx_pfcfrm_en0; 
   logic [31:0] rx_frm_ctl;
   logic [31:0] rx_crcpad_ctl;
   logic rx_preamb_passthru_en;           
   logic [1:0]  rx_link_fault_status;
   
   //********************End of Ported signals   

   bit [4:0] ehip_reset_state;
   bit reset_ack;
   bit ehip_reset;
   bit ehip_reset_ack;
   bit ehip_reset_rx;
   bit ehip_reset_ack_rx;
   bit ehip_reset_tx;
   bit ehip_reset_ack_tx;
// `ifdef ANLT
   bit [3:0] an_arb_state;
   bit 	     an_done;
   bit 	     an_complete_vip_mon;
   bit 	     an_enable;
   bit 	     an_negfail;
   bit 	     an_page_rec;
   bit [3:0][3:0] lt_train_state;
   bit [7:0] 	  lt_training;
   bit [7:0] 	  lt_trained;
   bit [7:0] 	  lt_failure;
   bit [7:0] 	  lt_frame_lock;
   bit [7:0] 	  training_fail;
   bit [3:0] 	  lt_frame_sent;
   bit [3:0] 	  lt_start_wait_timer;
   bit 		  lt_timeout;
   bit 		  an_timeout;
   bit        reset_seq;
   bit [13:0] 	  seq_mode;
   bit [31:0] 	  an_status_c2;
   bit            seq_link_ready;
   bit [3:0] 	  kr_counter_is_running;
   bit [7:0]     rtl_mwt; 
   bit [64:0]    exp_mwt_min; 
   bit [64:0]    exp_mwt_max; 
   bit [64:0]    exp_mwt;
   bit [3:0]     kr_rst_req; //FIXME
// `endif //  `ifdef ANLT
   bit       	  o_tx_ready;
   bit       	  o_sl_tx_ready;
   bit       	  o_tx_lanes_stable;
   bit [7:0] 	  tx_serial;
   bit [7:0] 	  rx_serial;
   bit          mii_tx_clk;
   bit          data_valid_tx;
   bit [2:0]      an_chan;

   logic o_tx_ptp_ready;
   logic o_rx_ptp_ready;

   bit [2:0] ptp_tx_state;
   bit [2:0] ptp_rx_state;
   
   logic o_tx_am;
   logic o_rx_am;
   bit serial_log_start;

   bit [3:0][2:0]  ptp_ins_type;
   bit [3:0][2:0]  ptp_byte_offset;
   bit [3:0][23:0] ptp_ts;
   bit ptp_clk;

   bit [8:0]    mii_lane0_data_ctrl;
   bit [8:0]    mii_lane1_data_ctrl;
   bit [8:0]    mii_lane2_data_ctrl;
   bit [8:0]    mii_lane3_data_ctrl;
   bit          mii_tx_valid;
   bit          mii_tx_am_valid;
   bit [30:0]         tx_mac_clk;

   bit          mii_rx_valid;
   bit          mii_rx_am_valid;
   bit          rx_mac_clk;
   bit          rx_core_clk;
   bit          ptp_reading_vl_data;
   bit [83:0]   ptp_rx_ts;

   bit          gearbox_valid;
   bit          rf_status;
   bit [1:0]    lf_status;

   event cw_insert;
   event event_mac_idle_detected_rx;    
   event event_chk_start_cntrl_character_tx;   
   event event_chk_no_eop_tx;
   bit [3:0][31:0] spico_core_status;
   bit [3:0][7:0]  reg_203;
   bit [3:0][7:0]  reg_207;

   //copy of TB dyn_rcfg state
   speed_e speed;
   int ch_num;
   int inst_num=0;
   bit trans_type; 
   bit ptp; 
   bit anlt; 
   bit rx_fc_fwd; 
   bit sa; 
   bit txvlan; 
   bit rxvlan; 
   bit en_mx_frsz; 
   bit en_async_adp; 
   bit preamble_passthrough; 
   bit sfd; 
   bit [1:0] lf; 
   bit [1:0] rxbyte_rem; 
   bit [1:0] fc_rdy_drop; 
   bit [1:0] rdy_lat; 
   bit [1:0] phyrefclk; 
   int syspllcnt; 
   bit [1:0] syspll; 
   bit [1:0] ipg; 
   fec_type_e fec_type; 
   int tx_frm_size; 
   int rx_frm_size; 
   int ipg_rm_perperiod;
   mode_e mode;
   bit fc;  // Just in case FC gets controlled via param
   int fp_width;
   //OTN-FLEXE controls [begin]
   int  gear;
   real tx_freq;
   real rx_freq;
   int  am_ins_cyc;
   int  am_ins_cnt;
   //OTN-FLEXE controls [end]

   bit act_eop;

   
   //SEG
   //For sequence to use to detect packet sent and received
   event TX_SEG_PKT_SENT;
   event RX_SEG_PKT_RECEIVED;
   bit   seg_tx_found_sop;
   
   //For PTP midsim traffic reset
   bit   delayed_scb_en=0;

   //QHIP_ACC_TESTING
   wire [30:0]tx_word_align;
   wire [30:0][63:0] tx_mii_d;
   wire [30:0][7:0] tx_mii_c;
   wire [30:0]tx_mii_valid;
   wire [30:0]tx_am_valid;
   wire [30:0]tx_mii_clk;
   wire [30:0]rx_word_align;
   wire [30:0][63:0] rx_mii_d;
   wire [30:0][7:0] rx_mii_c;
   wire [30:0]rx_mii_valid;
   wire [30:0]rx_am_valid;
   wire [30:0]rx_mii_clk;
   wire [30:0]tx_load_data_valid;
   wire [30:0]tx_tam_adj_load_data_valid;
   wire [30:0][95:0]tx_load_data;
   wire [30:0][95:0]tx_tam_adj_load_data;
   wire [30:0]rx_load_data_valid;
   wire [30:0]rx_tam_adj_load_data_valid;
   wire [30:0][95:0]rx_load_data;
   wire [30:0][95:0]rx_tam_adj_load_data;

  //DEBUG WB register signals
    wire [30:0][1:0] tx_o_load_data_valid,rx_o_load_data_valid;
    wire [30:0][15:0][95:0]rx_o_tam_dbg,tx_o_tam_dbg; 
    wire [30:0][15:0][31:0]rx_o_tam_adj_dbg,tx_o_tam_adj_dbg;
    wire [30:0][95:0]rx_o_ts_ss,tx_o_ts_ss;
    wire [30:0][4:0]rx_o_vl_ss,tx_o_vl_ss ;
	 
   //-------------------------------------- 
   //For PTP user flow accuracy debug only
   //-------------------------------------- 
   localparam  PL = 8;
   localparam  VL = 20;
   localparam  FL = 16;
   
   //TX
   logic         [30:0] tx_const_delay;
   logic                tx_const_delay_sign;
   logic [PL-1:0][30:0] tx_apulse_offset;
   logic [PL-1:0]       tx_apulse_offset_sign;
   logic [PL-1:0][19:0] tx_apulse_wdelay;
   logic [PL-1:0][28:0] tx_apulse_time;
   logic         [28:0] tx_apulse_time_max;
   logic         [2:0]  tx_ref_pl;
   logic [PL-1:0][31:0] tx_am_actual_time;
   logic         [31:0] tx_am_actual_time_max;
   logic         [31:0] tx_tam_adjust;
   logic         [31:0] tx_tam_adjust_2c;
   logic         [31:0] tx_external_phy_delay = 0; // standardize magnitude-only signal to have 2^n number of bits
   logic         [31:0] tx_pma_delay_ui; // standardize magnitude-only signal to have 2^n number of bits
   logic         [31:0] tx_pma_delay_ns; // some variant needs 32bits (4bits ns)
   logic         [31:0] tx_extra_latency;
   logic [VL-1:0][31:0] tx_vl_offset;
   logic[31:0] tx_data_const_delay, tx_apulse_data_offset;   
   
   
   //RX
	int  pl_fl_map;
	logic [15:0]  [14:0] rx_fec_cw_pos_fl;
	logic [15:0]  [3:0]  rx_fec_ln_mapping_fl;
	logic [FL-1:0][14:0] rx_fec_cw_pos;
	logic [FL-1:0][3:0]  rx_fec_ln_mapping; //unused
	logic [FL-1:0][30:0] rx_xcvr_if_pulse_adj = 0;
	logic         [30:0] rx_const_delay;
	logic                rx_const_delay_sign;
	logic [PL-1:0][30:0] rx_apulse_offset;
	logic [PL-1:0]       rx_apulse_offset_sign;
	logic [PL-1:0][19:0] rx_apulse_wdelay;
	logic [PL-1:0][28:0] rx_apulse_time;
	logic         [28:0] rx_apulse_time_max;
	logic         [2:0]  cw_pos_upper_bit;
	logic [20-1:0] rx_spulse_offset_sign = 0;
	logic [20-1:0][31:0] rx_spulse_offset;
	logic         [2:0]  rx_ref_pl;
	logic         [3:0]  rx_ref_fl;
	logic         [4:0]  rx_ref_vl;
	logic [20-1:0][31:0] rx_am_actual_time;
	logic         [31:0] rx_am_actual_time_max;
	logic         [31:0] rx_am_actual_time_min;
	logic         [31:0] rx_tam_adjust;
	logic         [31:0] rx_tam_adjust_2c;
	logic         [31:0] rx_external_phy_delay = 0; // standardize magnitude-only signal to have 2^n number of bits
	logic         [31:0] rx_pma_delay_ui; // standardize magnitude-only signal to have 2^n number of bits
	logic         [31:0] rx_pma_delay_ns; // some variant needs 32bits (4bits ns)
	logic         [31:0] rx_extra_latency;
	logic [VL-1:0][31:0] rx_vl_offset;
	logic         [31:0] rx_data_const_delay, rx_apulse_data_offset;
	logic         [6:0]  rx_pcs_bitslip_cnt;
	logic                rx_pcs_dlpulse_aligned;
	logic [20-1:0][1:0]  rx_vl_local_pl;
	logic         [4:0]  rx_am_maxtime_loop_cnt;
	logic         [4:0]  rx_ref_maxtime;	
	logic [19:0][31:0]   rx_non_fec_vl_offset;
	logic [19:0][1:0]    rx_non_fec_vl_local_pl;
	logic [19:0][4:0]    rx_non_fec_vl_remote_pl;
   logic         [6:0]  rx_pcs_dlpulse_cnt;
   logic         [34:0] bslip_p_dlpulse;
   
   //PTP SVA
   bit                  dis_sva;

//rx stats variables  
  bit [63:0] rx_fragment_cntr,rx_jabber_cntr,rx_fcs_cntr,rx_fcserr_okpkt,rx_mcast_data_err_cntr,rx_bcast_data_err_cntr,rx_ucast_data_err_cntr,rx_mcast_ctrl_err_cntr,rx_bcast_ctrl_err_cntr,rx_ucast_ctrl_err_cntr,
             rx_pause_err_cntr,rx_64b_cntr,rx_65bto127b_cntr,rx_128bto255b_cntr,rx_256bto511b_cntr,rx_512bto1023b_cntr,rx_1024bto1518b_cntr,rx_1519btomax_cntr,rx_oversize_cntr,rx_mcast_data_ok_cntr,rx_ucast_data_ok_cntr,
             rx_bcast_data_ok_cntr,rx_mcast_ctrl_ok_cntr,rx_ucast_ctrl_ok_cntr,rx_bcast_ctrl_ok_cntr,rx_pause_ok_cntr,rx_runt_cntr,rx_payload_ok_cntr,rx_frame_ok_cntr,rx_frame_dropped_cntr,rx_malformed_cntr,rx_pfc_ok_cntr,rx_pfc_err_cntr,rx_badlt_frame,rx_lenerr_frame,rx_st_frame,rxmac_adapt_dropped_cntr,rx_stats_framesOK,rx_stats_framesErr,rx_stats_ifErrors;
  int frame_size_rx;
//tx stats variables  
  bit [63:0] tx_fragment_cntr,tx_jabber_cntr,tx_fcs_cntr,tx_fcserr_okpkt,tx_mcast_data_err_cntr,tx_bcast_data_err_cntr,tx_ucast_data_err_cntr,tx_mcast_ctrl_err_cntr,tx_bcast_ctrl_err_cntr,tx_ucast_ctrl_err_cntr,
             tx_pause_err_cntr,tx_64b_cntr,tx_65bto127b_cntr,tx_128bto255b_cntr,tx_256bto511b_cntr,tx_512bto1023b_cntr,tx_1024bto1518b_cntr,tx_1519btomax_cntr,tx_oversize_cntr,tx_mcast_data_ok_cntr,tx_ucast_data_ok_cntr,
             tx_bcast_data_ok_cntr,tx_mcast_ctrl_ok_cntr,tx_ucast_ctrl_ok_cntr,tx_bcast_ctrl_ok_cntr,tx_pause_ok_cntr,tx_runt_cntr,tx_payload_ok_cntr,tx_frame_ok_cntr,tx_frame_dropped_cntr,tx_malformed_cntr,tx_pfc_ok_cntr,tx_pfc_err_cntr,tx_badlt_frame,tx_lenerr_frame,tx_st_frame,tx_stats_framesOK,tx_stats_framesErr,tx_stats_ifErrors;
  int frame_size_tx;
  int malformed_frame_cnt;

   wire i_tx_ptp_sync_am;
   wire i_tx_ptp_async_pulse;
   wire i_rx_ptp_sync_am;
   wire i_rx_ptp_async_pulse;


   // FIXME : this is eth_7 local fake_reset variable, should not be used in any sim mode. Added this to fix the compile issue.will be removed in future. 
   logic [23:0]        pcs_aligned;
   logic [23:0]        pcs_rx_sf;      //ToDo: will revert this signal once fixed from PTP sequence 

//**************************************************************************************
//Divya- added for TileIP flow with fake reset sequence testing
//**************************************************************************************
//TODO: Temp used for PTP fake reset. To be removed once auto SRC is ready
    localparam DATA_RATE       = "25G"; //unused
    localparam AIB_LANES       = `PTP_NUM_WORDS_IP;
    localparam LANE_NUM        = `NUM_LANES_IP0;
    localparam FEC_LANES       = (`PTP_NUM_WORDS_IP==16 ? 4 : (`PTP_NUM_WORDS_IP == 8 ? 2 : 1)); //1;

//---------------------------------------------
localparam PKT_CLIENT_BASE_ADDR       = 32'h0200_0000;
localparam  cfg_pkt_client_ctrl_addr  = PKT_CLIENT_BASE_ADDR + 8'h00;
localparam  cfg_test_loop_cnt_addr    = PKT_CLIENT_BASE_ADDR + 8'h01;
localparam  cfg_rom_addr_addr         = PKT_CLIENT_BASE_ADDR + 8'h02;

//---------------------------------------------
logic         loopback_client_test, sys_rx_path_working, sys_tx_ready_working;
logic [31:0]  rdata, rdata1, rdata2, rdata3;
logic [31:0]  cfg_pkt_tx_cnt, cfg_pkt_rx_cnt;
logic [31:0]  stat_tx_sop_cnt, stat_tx_eop_cnt, stat_tx_err_cnt;
logic [31:0]  stat_rx_sop_cnt, stat_rx_eop_cnt, stat_rx_err_cnt;
logic [31:0]  stat_tx_eop_cnt_r, stat_rx_eop_cnt_r;

//---------------------------------------------
integer k;
logic [31:0]  cfg_test_loop_cnt;  
logic [15:0]  init_rom_start_addr;
logic [15:0]  init_rom_end_addr;
logic [31:0]  cfg_pkt_client_ctrl;
//---[0]= 1: start TX; 0: stop TX;
//---[4]= 1: loopback client enabled; 0: send packets from ROM; 
//---[8]= 1: clear packet TX/RX counters; self-clean;

wire [28:0] ehip_base_addr = (DATA_RATE == "400G") ? 'h5000 :
                             (DATA_RATE == "200G") ? 'h4000 :
                             (DATA_RATE == "100G") ? 'h3000 :
                             (DATA_RATE ==  "50G") ? 'h2000 :
                             (DATA_RATE ==  "40G") ? 'h3000 :
                             (DATA_RATE ==  "25G") ? 'h1000 : 
                                                     'h1000; // 10G

//---------------------------------------------
    // Clocks
    reg                          i_refclk2pll                = 1'b0; 
    reg                          i_refclk2syspll                = 1'b0; 
    reg                          i_reconfig_clk              = 0;

    //Resets
    reg                          i_tx_rst_n                  = 1'b1;
    reg                          i_rst_n                     = 1'b1;
    reg                          i_rx_rst_n                  = 1'b1;
    reg                          i_reconfig_reset            = 0;


    //Loopback
    bit                          loopback_enable;

	//TODO: Unused. To be remove once PTP move to GDR_RUN
    wire [LANE_NUM-1:0]          i_rx_serial; 
    wire [LANE_NUM-1:0]          i_rx_serial_n;  
    wire [LANE_NUM-1:0]          o_tx_serial;  
    wire [LANE_NUM-1:0]          o_tx_serial_n;  

    // Serial data interface
    assign i_rx_serial   = o_tx_serial;
    assign i_rx_serial_n = o_tx_serial_n;

   assign act_eop = avst_tx_eop && o_tx_ready;

   function void get_params(output longint param[string]);

     /*

     uvm_hdl_data_t str_rx_pause_daddr;
     uvm_hdl_data_t str_tx_pause_daddr;
     uvm_hdl_data_t str_tx_pause_saddr;
     uvm_hdl_data_t str_txmac_saddr;
     uvm_hdl_data_t flow_control;
     uvm_hdl_data_t flow_control_holdoff_mode;
     uvm_hdl_data_t sim_mode;
     bit[47:0] rx_pause_daddr_atoi;
     bit[47:0] tx_pause_daddr_atoi;
     bit[47:0] tx_pause_saddr_atoi;
     bit[47:0] txmac_saddr_atoi;
     uvm_hdl_data_t hdl_read_val_s;
      
     // uvm_hdl_read used to get RTL path ref runtime
     // void cast used instead of assert as uvm_hdl_read will fail implicitly, if at all 

     void'(uvm_hdl_read({DUT_TOP,IP,".rx_pause_daddr"},str_rx_pause_daddr));
     void'(uvm_hdl_read({DUT_TOP,IP,".tx_pause_daddr"},str_tx_pause_daddr));
     void'(uvm_hdl_read({DUT_TOP,IP,".tx_pause_saddr"},str_tx_pause_saddr));
     void'(uvm_hdl_read({DUT_TOP,IP,".txmac_saddr"},str_txmac_saddr));
     void'(uvm_hdl_read({DUT_TOP,IP,".flow_control"},flow_control));
     void'(uvm_hdl_read({DUT_TOP,IP,".flow_control_holdoff_mode"},flow_control_holdoff_mode));
     void'(uvm_hdl_read({DUT_TOP,IP,".sim_mode"},sim_mode));
     rx_pause_daddr_atoi = str_rx_pause_daddr.atoi();
     tx_pause_daddr_atoi = str_tx_pause_daddr.atoi();
     tx_pause_saddr_atoi = str_tx_pause_saddr.atoi();
     txmac_saddr_atoi = str_txmac_saddr.atoi();


     void'(uvm_hdl_read({DUT_TOP,IP,".rx_vlan_detection"},hdl_read_val_s)); 
     param["rx_vlan_detection"]=(hdl_read_val_s=="disable")?1:0;
     void'(uvm_hdl_read({DUT_TOP,IP,".rx_length_checking"},hdl_read_val_s)); 
     param["rx_length_checking"]=(hdl_read_val_s=="disable")?0:1;
     void'(uvm_hdl_read({DUT_TOP,IP,".enforce_max_frame_size"},hdl_read_val_s)); 
     param["enforce_max_frame_size"]=(hdl_read_val_s=="disable")?0:1;
     void'(uvm_hdl_read({DUT_TOP,IP,".remove_pads"},hdl_read_val_s)); 
     param["remove_pads"]=(hdl_read_val_s=="disable")?0:1;
     void'(uvm_hdl_read({DUT_TOP,IP,".tx_vlan_detection"},hdl_read_val_s)); 
     param["tx_vlan_detection"]=(hdl_read_val_s=="disable")?1:0;
     void'(uvm_hdl_read({DUT_TOP,IP,".source_address_insertion"},hdl_read_val_s)); 
     param["source_address_insertion"]=(hdl_read_val_s=="disable")?0:1;
     void'(uvm_hdl_read({DUT_TOP,IP,".tx_max_frame_size"},param["tx_max_frame_size"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".rx_max_frame_size"},param["rx_max_frame_size"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".rxcrc_covers_preamble"},param["rxcrc_covers_preamble"]));

     //am_encoding
     void'(uvm_hdl_read({DUT_TOP,IP,".am_encoding40g_0"},param["am_encoding40g_0"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".am_encoding40g_1"},param["am_encoding40g_1"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".am_encoding40g_2"},param["am_encoding40g_2"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".am_encoding40g_3"},param["am_encoding40g_3"]));

     //flow_control
     case(flow_control)
       "none" :         begin
                          param["flow_control[en_pfc_port]"] = 'h0; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 'h0; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h0; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h0; //[1]
                          param["flow_control[en_rx_pause]"] = 'h0; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h0; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h0; //[1]
                        end
       "sfc" :          begin
                          param["flow_control[en_pfc_port]"] = 9'b100000000; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 3'b001; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h0; //[1]
                          param["flow_control[en_rx_pause]"] = 8'b00000001; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h1; //[1]
                        end
       "sfc_no_xoff" :  begin
                          param["flow_control[en_pfc_port]"] = 9'b100000000; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 3'b000; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h0; //[1]
                          param["flow_control[en_rx_pause]"] = 8'b00000001; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h1; //[1]
                        end
       "pfc" :          begin
                          param["flow_control[en_pfc_port]"] = 9'b011111111; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 3'b001; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h0; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h1; //[1]
                          param["flow_control[en_rx_pause]"] = 8'b11111111; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h1; //[1]
                        end
       "pfc_no_xoff" :  begin
                          param["flow_control[en_pfc_port]"] = 9'b011111111; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 'h0; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h0; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h1; //[1]
                          param["flow_control[en_rx_pause]"] = 8'b11111111; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h1; //[1]
                        end
       "both" :         begin
                          param["flow_control[en_pfc_port]"] = 9'b111111111; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 3'b001; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h1; //[1]
                          param["flow_control[en_rx_pause]"] = 8'b11111111; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h1; //[1]
                        end
       "both_no_xoff" : begin
                          param["flow_control[en_pfc_port]"] = 9'b111111111; //[8:0]
                          param["flow_control[en_xoff_qnum_sel]"] = 3'b000; //[2:0]
                          param["flow_control[tx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[tx_en_pfc]"] = 'h1; //[1]
                          param["flow_control[en_rx_pause]"] = 8'b11111111; //[7:0]
                          param["flow_control[rx_en_sfc]"] = 'h1; //[0]
                          param["flow_control[rx_en_pfc]"] = 'h1; //[1]
                        end
     endcase

     //flowcontrol_holdoff_mode
     case(flow_control_holdoff_mode)
       "per_queue"  : begin
                        param["flow_control_holdoff_mode[en_holdoff]"] = 9'b111111111; //[8:0]
                        param["flow_control_holdoff_mode[en_holdoff_all]"] = 'h0; //[0]
                      end
       
       "uniform"    : begin
                        param["flow_control_holdoff_mode[en_holdoff]"] = 9'b111111111; //[8:0]
                        param["flow_control_holdoff_mode[en_holdoff_all]"] = 'h1; //[0]
                      end

       "no_holdoff" : begin
                        param["flow_control_holdoff_mode[en_holdoff]"] = 9'b000000000; //[8:0]
                        param["flow_control_holdoff_mode[en_holdoff_all]"] = 'h0; //[0]
                      end 
     endcase
    
     //forward_rx_pause_request
     void'(uvm_hdl_read({DUT_TOP,IP,".forward_rx_pause_requests "},hdl_read_val_s)); 
     param["forward_rx_pause_requests"]=(hdl_read_val_s== "disable")?0:1;

     //hi_ber_monitor
     void'(uvm_hdl_read({DUT_TOP,IP,".hi_ber_monitor"},param["hi_ber_monitor"]));

     //holdoff_quanta
     void'(uvm_hdl_read({DUT_TOP,IP,".holdoff_quanta"},param["holdoff_quanta"]));
     
     //ipg_removed_per_am_period
     void'(uvm_hdl_read({DUT_TOP,IP,".ipg_removed_per_am_period"},param["ipg_removed_per_am_period"]));
     
     //link_fault_mode 
     void'(uvm_hdl_read({DUT_TOP,IP,".link_fault_mode "},hdl_read_val_s));
     //FIXME: ALEX: In below statement,  is lf_bidir true then param[]=0 a bug ? Need to check and fix 
     param["link_fault_mode[1]"]=(hdl_read_val_s== "lf_off")?0:(hdl_read_val_s == "lf_bidir")?0:(hdl_read_val_s == "lf_unidir")?1:0;
     param["link_fault_mode[0]"]=(hdl_read_val_s== "lf_off")?0:(hdl_read_val_s == "lf_bidir")?1:(hdl_read_val_s == "lf_unidir")?1:0;

     //pause_quanta
     void'(uvm_hdl_read({DUT_TOP,IP,".pause_quanta"},param["pause_quanta"]));
    
     //pfc_holdoff_quanta_0/1/2/3/4/5/6/7
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_0"},param["pfc_holdoff_quanta_0"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_1"},param["pfc_holdoff_quanta_1"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_2"},param["pfc_holdoff_quanta_2"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_3"},param["pfc_holdoff_quanta_3"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_4"},param["pfc_holdoff_quanta_4"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_5"},param["pfc_holdoff_quanta_5"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_6"},param["pfc_holdoff_quanta_6"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_holdoff_quanta_7"},param["pfc_holdoff_quanta_7"]));

     //pfc_pause_quanta_0/1/2/3/4/5/6/7
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_0"},param["pfc_pause_quanta_0"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_1"},param["pfc_pause_quanta_1"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_2"},param["pfc_pause_quanta_2"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_3"},param["pfc_pause_quanta_3"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_4"},param["pfc_pause_quanta_4"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_5"},param["pfc_pause_quanta_5"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_6"},param["pfc_pause_quanta_6"]));
     void'(uvm_hdl_read({DUT_TOP,IP,".pfc_pause_quanta_7"},param["pfc_pause_quanta_7"]));

     //rx_pause_daddr
     param["rx_pause_daddr_atoi[31:0]"]=rx_pause_daddr_atoi[31:0];
     param["rx_pause_daddr_atoi[47:32]"]=rx_pause_daddr_atoi[47:32];

     //rx_pcs_maX_skew
     void'(uvm_hdl_read({DUT_TOP,IP,".rx_pcs_max_skew"},param["rx_pcs_max_skew"]));
     
     //rxcrc_covers_preamble
     void'(uvm_hdl_read({DUT_TOP,IP,".rxcrc_covers_preamble "},hdl_read_val_s)); 
     param["rxcrc_covers_preamble"]=(hdl_read_val_s== "disable")?0:1;

     //sim_mode
     case(sim_mode)
       "disable" : begin
                      if (speed==_100G)
                          param["am_period"] = 17'h13FFB; 
                      else if (speed==_50G)
                          param["am_period"] = 17'h3FFF; 
                      else if (speed==_25G)
                          param["am_period"] = 17'h13FFC;
                      else if (speed==_10G)
                          param["am_period"] = 17'h13FFC;
                   end 
       "enable"  : begin
                      if (speed==_100G) begin
                          param["am_period"] = 17'h13B; 
                          param["am_interval"] = 17'h3F; 
                      end
                      else if (speed==_50G) begin
                          param["am_period"] = 17'hFF; 
                          param["am_interval"] = 17'hFF; 
                      end
                      else if (speed==_25G) begin
                          param["am_period"] = 17'h13FF; 
                          param["am_interval"] = 17'h0;
		      end
                      else if (speed==_10G) begin
                          param["am_period"] = 17'h13FF; 
                          param["am_interval"] = 17'h0; 
                      end
                   end 
     endcase
     
     //tx_ipg_size
     void'(uvm_hdl_read({DUT_TOP,IP,".tx_ipg_size "},hdl_read_val_s)); 
     param["tx_ipg_size"]=(hdl_read_val_s== "ipg_12")?0:(hdl_read_val_s == "ipg_10")?1:(hdl_read_val_s == "ipg_8")?2:(hdl_read_val_s == "ipg_1")?3:0;

     //tx_pause_daddr
     param["tx_pause_daddr_atoi[31:0]"]=tx_pause_daddr_atoi[31:0];
     param["tx_pause_daddr_atoi[47:32]"]=tx_pause_daddr_atoi[47:32];

     //tx_pause_saddr
     param["tx_pause_saddr_atoi[31:0]"]=tx_pause_saddr_atoi[31:0];
     param["tx_pause_saddr_atoi[47:32]"]=tx_pause_saddr_atoi[47:32];
     
     //txcrc_covers_preamble
     void'(uvm_hdl_read({DUT_TOP,IP,".txcrc_covers_preamble "},hdl_read_val_s)); 
     param["txcrc_covers_preamble"]=(hdl_read_val_s== "disable")?0:1;

     //txmac_saddr
     param["txmac_saddr_atoi[31:0]"]=txmac_saddr_atoi[31:0];
     param["txmac_saddr_atoi[47:32]"]=txmac_saddr_atoi[47:32];
     
     //uniform_holdoff_quanta
     void'(uvm_hdl_read({DUT_TOP,IP,".uniform_holdoff_quanta"},param["uniform_holdoff_quanta"]));

   */

   endfunction : get_params

   //-----------------------------------------------------------------------------------
   //muralasx: Newly added methods in place of macros present in
   //eth_alt_defines
   //-----------------------------------------------------------------------------------
   function bit check_idle_tx_mii();
    case(speed)
      //FIXME with actual values. 
      _100G: return ((mii_data3_tx == 64'h0707_0707_0707_0707 || mii_data2_tx == 64'h0707_0707_0707_0707 || mii_data1_tx == 64'h0707_0707_0707_0707 || mii_data0_tx == 64'h0707_0707_0707_0707) && (mii_ctrl3_tx == 8'hFF || mii_ctrl2_tx == 8'hFF || mii_ctrl1_tx == 8'hFF || mii_ctrl0_tx == 8'hFF) && mii_valid_tx == 1'b1);
      _50G: return ((mii_data1_tx == 64'h0707_0707_0707_0707 || mii_data0_tx == 64'h0707_0707_0707_0707) && (mii_ctrl1_tx == 8'hFF || mii_ctrl0_tx == 8'hFF) && mii_valid_tx == 1'b1);
      _25G: return ((mii_data0_tx == 64'h0707_0707_0707_0707) && (mii_ctrl0_tx == 8'hFF) && mii_valid_tx == 1'b1);
    endcase
   endfunction
   function bit check_no_idle_tx_mii();
    case(speed)
      //FIXME with actual values. 
      _100G: return ((mii_data3_tx != 64'h0707_0707_0707_0707 || mii_data2_tx != 64'h0707_0707_0707_0707 || mii_data1_tx != 64'h0707_0707_0707_0707 || mii_data0_tx != 64'h0707_0707_0707_0707) && (mii_ctrl3_tx != 8'hFF || mii_ctrl2_tx != 8'hFF || mii_ctrl1_tx != 8'hFF || mii_ctrl0_tx != 8'hFF) && mii_valid_tx == 1'b1);
      _50G: return ((mii_data1_tx != 64'h0707_0707_0707_0707 || mii_data0_tx != 64'h0707_0707_0707_0707) && (mii_ctrl1_tx != 8'hFF || mii_ctrl0_tx != 8'hFF) && mii_valid_tx == 1'b1);
      _25G: return ((mii_data0_tx != 64'h0707_0707_0707_0707) && (mii_ctrl0_tx != 8'hFF) && mii_valid_tx == 1'b1);
    endcase
   endfunction
   function bit check_tx_mii_remote_fault();
    case(speed)
      _100G: return ((mii_data3_tx == 64'h9c00_0002_0000_0000 || mii_data2_tx == 64'h9c00_0002_0000_0000 || mii_data1_tx == 64'h9c00_0002_0000_0000 || mii_data0_tx == 64'h9c00_0002_0000_0000) && (mii_ctrl3_tx == 8'h80 || mii_ctrl2_tx == 8'h80 || mii_ctrl1_tx == 8'h80 || mii_ctrl0_tx == 8'h80) && mii_valid_tx == 1'b1);
      _50G:  return ((mii_data1_tx == 64'h9c00_0002_0000_0000 || mii_data0_tx == 64'h9c00_0002_0000_0000) && (mii_ctrl1_tx == 8'h80 || mii_ctrl0_tx == 8'h80) && mii_valid_tx == 1'b1);
      _25G:  return ((mii_data0_tx == 64'h9c00_0002_0000_0000) && (mii_ctrl0_tx == 8'h80) && mii_valid_tx == 1'b1);
    endcase
   endfunction 
   function bit check_no_tx_mii_remote_fault();
    case(speed)
      _100G: return ((mii_data3_tx != 64'h9c00_0002_0000_0000 || mii_data2_tx != 64'h9c00_0002_0000_0000 || mii_data1_tx != 64'h9c00_0002_0000_0000 || mii_data0_tx != 64'h9c00_0002_0000_0000) && (mii_ctrl3_tx != 8'h80 || mii_ctrl2_tx != 8'h80 || mii_ctrl1_tx != 8'h80 || mii_ctrl0_tx != 8'h80) && mii_valid_tx == 1'b1);
      _50G:  return ((mii_data1_tx != 64'h9c00_0002_0000_0000 || mii_data0_tx != 64'h9c00_0002_0000_0000) && (mii_ctrl1_tx != 8'h80 || mii_ctrl0_tx != 8'h80) && mii_valid_tx == 1'b1);
      _25G:  return ((mii_data0_tx != 64'h9c00_0002_0000_0000) && (mii_ctrl0_tx != 8'h80) && mii_valid_tx == 1'b1);
    endcase
   endfunction 
   function bit check_rx_mii_remote_fault();
    case(speed)
      _50G,_100G:  return ((mii_data_rx[255:192] == 64'h9c00_0002_0000_0000 || mii_data_rx[191:128] == 64'h9c00_0002_0000_0000 || mii_data_rx[127:64] == 64'h9c00_0002_0000_0000 || mii_data_rx[63:0] == 64'h9c00_0002_0000_0000) && (mii_ctrl_rx[31:24] == 8'h80 || mii_ctrl_rx[23:16] == 8'h80 || mii_ctrl_rx[15:8] == 8'h80 || mii_ctrl_rx[7:0] == 8'h80) && mii_valid_rx == 1'b1);
      _10G,_25G:  return ((mii_data_rx[255:192] == 64'h9c00_0002_9c00_0002 || mii_data_rx[191:128] == 64'h9c00_0002_9c00_0002 || mii_data_rx[127:64] == 64'h9c00_0002_9c00_0002 || mii_data_rx[63:0] == 64'h9c00_0002_9c00_0002) && (mii_ctrl_rx[31:24] == 8'h88 || mii_ctrl_rx[23:16] == 8'h88 || mii_ctrl_rx[15:8] == 8'h88 || mii_ctrl_rx[7:0] == 8'h88) && mii_valid_rx == 1'b1);
    endcase
   endfunction
  function bit check_rx_mii_local_fault();
    case(speed)
      _50G,_100G: return ((mii_data_rx[255:192] == 64'h9c00_0001_0000_0000 || mii_data_rx[191:128] == 64'h9c00_0001_0000_0000 || mii_data_rx[127:64] == 64'h9c00_0001_0000_0000 || mii_data_rx[63:0] == 64'h9c00_0001_0000_0000) && (mii_ctrl_rx[31:24] == 8'h80 || mii_ctrl_rx[23:16] == 8'h80 || mii_ctrl_rx[15:8] == 8'h80 || mii_ctrl_rx[7:0] == 8'h80) && mii_valid_rx == 1'b1);
      _10G,_25G:  return ((mii_data_rx[255:192] == 64'h9c00_0001_9c00_0001 || mii_data_rx[191:128] == 64'h9c00_0001_9c00_0001 || mii_data_rx[127:64] == 64'h9c00_0001_9c00_0001 || mii_data_rx[63:0] == 64'h9c00_0001_9c00_0001) && (mii_ctrl_rx[31:24] == 8'h88 || mii_ctrl_rx[23:16] == 8'h88 || mii_ctrl_rx[15:8] == 8'h88 || mii_ctrl_rx[7:0] == 8'h88) && mii_valid_rx == 1'b1);
    endcase
   endfunction
   //
   //-----------------------------------------------------------------------------------

   //For FB#602451
   logic tx_pma_ready;
   logic rx_pma_ready;
   
task drive_ptp_tod_valid();

`ifdef PTP_EN
  fork
   begin
     `uvm_info("drive_ptp_tod_valid_down",$psprintf("waiting for ptp_tx_state = 3"),UVM_MEDIUM)
   //  wait(ptp_tx_state == 'b011);
		 wait(eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.i_tx_apulse_offset_valid == 'b1)
     `uvm_info("drive_ptp_tod_valid_down",$sformatf("got ptp_tx_state = %b",ptp_tx_state),UVM_MEDIUM)
		 //@(posedge eth_env_top.dut.i_clk_tx_tod_ip0);
     force eth_env_top.dut.i_ptp_tx_tod_valid_ip0 = 0;
     //force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.tx_ptp_tod_valid_sync = 0;
     repeat($urandom_range(10,20)) begin
       @(posedge eth_env_top.dut.i_clk_tx_tod_ip0);
     end
     force eth_env_top.dut.i_ptp_tx_tod_valid_ip0 = 1;
     //release eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.tx_ptp_tod_valid_sync ;
   end
   begin
     `uvm_info("drive_ptp_tod_valid_down",$psprintf("waiting for ptp_rx_state = 3"),UVM_MEDIUM)
     //wait(ptp_rx_state == 'b011);
		 wait(eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.i_rx_apulse_offset_valid == 'b1)
     `uvm_info("drive_ptp_tod_valid_down",$sformatf("got ptp_rx_state = %b",ptp_rx_state),UVM_MEDIUM)
		 //@(posedge eth_env_top.dut.i_clk_rx_tod_ip0);
     force eth_env_top.dut.i_ptp_rx_tod_valid_ip0 = 0;
     //force eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.rx_ptp_tod_valid_sync = 0;
     repeat($urandom_range(10,20)) begin
       @(posedge eth_env_top.dut.i_clk_rx_tod_ip0);
     end
     force eth_env_top.dut.i_ptp_rx_tod_valid_ip0 = 1;
     //release eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.ptp_state_ctrl_u.rx_ptp_tod_valid_sync ;
   end

   begin
     `uvm_info("drive_ptp_tod_valid_down",$psprintf("waiting for ptp_tx_state = 6"),UVM_MEDIUM)
     wait(ptp_tx_state == 'b110);
     `uvm_info("drive_ptp_tod_valid_down",$sformatf("got ptp_tx_state = %b",ptp_tx_state),UVM_MEDIUM)
     force eth_env_top.dut.i_ptp_tx_tod_valid_ip0 = 0;
     repeat($urandom_range(10,20)) begin
       @(posedge eth_env_top.dut.i_clk_tx_tod_ip0);
     end
     force eth_env_top.dut.i_ptp_tx_tod_valid_ip0 = 1;
   end
   begin
     `uvm_info("drive_ptp_tod_valid_down",$psprintf("waiting for ptp_rx_state = 6"),UVM_MEDIUM)
     wait(ptp_rx_state == 'b110);
     `uvm_info("drive_ptp_tod_valid_down",$sformatf("got ptp_rx_state = %b",ptp_rx_state),UVM_MEDIUM)
     force eth_env_top.dut.i_ptp_rx_tod_valid_ip0 = 0;
     repeat($urandom_range(10,20)) begin
       @(posedge eth_env_top.dut.i_clk_rx_tod_ip0);
     end
     force eth_env_top.dut.i_ptp_rx_tod_valid_ip0 = 1;
   end

   begin
     `uvm_info("drive_ptp_tod_valid_down",$psprintf("waiting for ptp_tx_state = 7"),UVM_MEDIUM)
     wait(ptp_tx_state == 'b111);
     `uvm_info("drive_ptp_tod_valid_down",$sformatf("got ptp_tx_state = %b",ptp_tx_state),UVM_MEDIUM)
     force eth_env_top.dut.i_ptp_tx_tod_valid_ip0 = 0;
     repeat($urandom_range(10,20)) begin
       @(posedge eth_env_top.dut.i_clk_tx_tod_ip0);
     end
     force eth_env_top.dut.i_ptp_tx_tod_valid_ip0 = 1;
   end
   begin
     `uvm_info("drive_ptp_tod_valid_down",$psprintf("waiting for ptp_rx_state = 7"),UVM_MEDIUM)
     wait(ptp_rx_state == 'b111);
     `uvm_info("drive_ptp_tod_valid_down",$sformatf("got ptp_rx_state = %b",ptp_rx_state),UVM_MEDIUM)
     force eth_env_top.dut.i_ptp_rx_tod_valid_ip0 = 0;
     repeat($urandom_range(10,20)) begin
       @(posedge eth_env_top.dut.i_clk_rx_tod_ip0);
     end
     force eth_env_top.dut.i_ptp_rx_tod_valid_ip0 = 1;
   end
 join_none
`endif
endtask

`ifdef ANLT
task anlt_pcs_hiber(speed_e speed = _25G);
bit [20:0] xus_timer_preload;
  begin
    if (speed == _25G) begin
      xus_timer_preload = 20'd805000;
      $display("**** Force Start****");
     uvm_hdl_force("dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.u_rx_pcs.ehiplane_ber.xus_timer",xus_timer_preload);  
    repeat(2) @(clk);
     uvm_hdl_release("dut_top__tiles.dut_top__tile_0.z1577a.z1577a_inst.u_e400g_top.u_e4hip_top.gdr_e4hip_pcsaibif.gdr_e4hip_pcs.generate_pcs_25g[0].u_gdr_ehip_25g_pcs.u_rx_pcs.ehiplane_ber.xus_timer");
      $display("**** Force END****");
    end
  end
endtask
`endif

endinterface

`endif
