// PTP port connection
wire i_clk_tx_tod_ip0;
wire i_clk_rx_tod_ip0;
wire [1:0] i_ptp_ts_req_ip0;
//wire [15:0] i_ptp_fp_ip0;
wire [31:0] i_ptp_fp_ip0; //set to max
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
//wire [15:0] o_ptp_ets_fp_ip0;
wire [63:0] o_ptp_ets_fp_ip0; //set to max*2
wire [1:0] o_ptp_ets_valid_ip0;
wire [9:0] o_ptp_ets_vl_ip0;
wire [191:0] o_ptp_rx_its_ip0;
wire [1:0] o_ptp_rx_its_valid_ip0;
wire [9:0] o_ptp_rx_its_vl_ip0;
wire [15:0] i_ptp_eb_offset_ip0;    //used for monitoring only
logic [15:0]   ptp_eb_offset_r_ip0; //not in GDR anymore but used for monitoring

logic [1:0] ptp_format_r_ip0;
logic [1:0] ptp_req_r_ip0; //2step
logic [1:0] ptp_ets_r_ip0; //1step
logic [1:0] ptp_cf_r_ip0;
logic [1:0] ptp_0csum_r_ip0;
logic [1:0] ptp_eb_r_ip0;
//logic [15:0]  ptp_fp_r_ip0;
logic [31:0]  ptp_fp_r_ip0; //set to max
logic [31:0] ptp_ts_offset_r_ip0;
logic [31:0] ptp_cf_offset_r_ip0;
logic [31:0] ptp_csum_offset_r_ip0;
logic [1:0] ptp_asym_lat_en_r_ip0;
logic [1:0] ptp_p2p_en_r_ip0;
logic [1:0] ptp_asym_sign_r_ip0;
logic [13:0] ptp_asym_p2p_idx_r_ip0;
logic act_sop_ip0;

//QHIP_ACC_TESTING
`include "acc_mon_sig_assigns_ip0.sv"

//WB debug signals
`include "WB_debug_signal_ip0.sv"


//Dummy client_tx_if
client_tx_if  seg_tx_if_ip0();

//Instantiate ptp_tx_interface and ptp_tx_rtb_module
ptp_tx_interface#(.NUM_WORDS(x),.FP_WIDTH(y)) ptp_tx_if_ip0 (clk_tx_ip0,clk_rx_ip0,reset_ip0);
ptp_tx_rtb_module ptp_tx_rtb_ip0(.mon_if(ptp_tx_if_ip0),.v_if_seg(seg_tx_if_ip0),.inst_num(0));


wire   clk_tx_div_ip0;
wire   clk_rec_div_ip0;
reg i_clk_ptp_sample_ip0 = 0;

assign i_clk_tx_tod_ip0 = clk_tx_div_ip0; 
assign i_clk_rx_tod_ip0 = clk_rec_div_ip0; 
always begin
    #4375  i_clk_ptp_sample_ip0 = ~i_clk_ptp_sample_ip0; // set to 114.2857MHz
end

assign spy_if_ip0.ptp_cf_r=ptp_cf_r_ip0; 
assign spy_if_ip0.o_tx_ptp_ready = dut.o_tx_ptp_ready_ip0;
assign spy_if_ip0.o_rx_ptp_ready = dut.o_rx_ptp_ready_ip0;

assign act_sop_ip0 = tx_avst_if_ip0.startofpacket && dut.o_tx_ready_ip0;
//flop at rising edge of SOP to avoid race condition when EOP/SOP at the same clock
always @(posedge act_sop_ip0) begin
    ptp_req_r_ip0          <= eth_sideband_if_ip0.ptp_req ;
    ptp_fp_r_ip0           <= eth_sideband_if_ip0.ptp_fp ;
    ptp_ets_r_ip0          <= eth_sideband_if_ip0.ptp_ets ;
    ptp_cf_r_ip0           <= eth_sideband_if_ip0.ptp_cf ;
    ptp_0csum_r_ip0        <= eth_sideband_if_ip0.ptp_0csum ;
    ptp_eb_r_ip0           <= eth_sideband_if_ip0.ptp_eb ;
    ptp_format_r_ip0       <= eth_sideband_if_ip0.ptp_format ;
    ptp_ts_offset_r_ip0    <= eth_sideband_if_ip0.ptp_ts_offset ;
    ptp_cf_offset_r_ip0    <= eth_sideband_if_ip0.ptp_cf_offset ;
    ptp_csum_offset_r_ip0  <= eth_sideband_if_ip0.ptp_csum_offset ;
    ptp_asym_lat_en_r_ip0  <= eth_sideband_if_ip0.ptp_asym_lat_en ; 
    ptp_p2p_en_r_ip0       <= eth_sideband_if_ip0.ptp_p2p_en ;
    ptp_asym_sign_r_ip0    <= eth_sideband_if_ip0.ptp_asym_sign;
    ptp_asym_p2p_idx_r_ip0 <= eth_sideband_if_ip0.ptp_asym_p2p_idx;
    ptp_eb_offset_r_ip0    <= eth_sideband_if_ip0.ptp_eb_offset ; //not in GDR anymore but used for monitoring
end

// Sideband PTP fields gated with tx_avst SOP alinged inputs
assign i_ptp_ts_req_ip0       = ptp_req_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
//assign i_ptp_fp_ip0           = ptp_fp_r_ip0 & {16{tx_avst_if_ip0.startofpacket}};
assign i_ptp_fp_ip0           = ptp_fp_r_ip0 & {32{tx_avst_if_ip0.startofpacket}}; //set to max, only 32 bit here because avst input up to 200G only
assign i_ptp_ins_ets_ip0      = ptp_ets_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_ins_cf_ip0       = ptp_cf_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_zero_csum_ip0    = ptp_0csum_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_update_eb_ip0    = ptp_eb_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_ts_format_ip0    = ptp_format_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_ts_offset_ip0    = ptp_ts_offset_r_ip0 & {31{tx_avst_if_ip0.startofpacket}};
assign i_ptp_cf_offset_ip0    = ptp_cf_offset_r_ip0 & {31{tx_avst_if_ip0.startofpacket}};
assign i_ptp_csum_offset_ip0  = ptp_csum_offset_r_ip0 & {31{tx_avst_if_ip0.startofpacket}};
assign i_ptp_eb_offset_ip0    = ptp_eb_offset_r_ip0 & {16{tx_avst_if_ip0.startofpacket}};  //not in GDR anymore but used for monitoring
assign i_ptp_tx_its_ip0       = eth_sideband_if_ip0.ptp_ts & {191{tx_avst_if_ip0.startofpacket}};
assign i_ptp_p2p_ip0          = ptp_p2p_en_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_asym_ip0         = ptp_asym_lat_en_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_asym_sign_ip0    = ptp_asym_sign_r_ip0 & {2{tx_avst_if_ip0.startofpacket}};
assign i_ptp_asym_p2p_idx_ip0 = ptp_asym_p2p_idx_r_ip0 & {14{tx_avst_if_ip0.startofpacket}};

assign i_ptp_tx_tod_ip0          = eth_sideband_if_ip0.ptp_tx_tod;
assign i_ptp_rx_tod_ip0          = eth_sideband_if_ip0.ptp_rx_tod;

assign ptp_tx_if_ip0.o_ptp_ets_valid= eth_sideband_if_ip0.ptp_valid; 
assign ptp_tx_if_ip0.o_ptp_ets      = eth_sideband_if_ip0.ptp_ets_o;      
assign ptp_tx_if_ip0.o_ptp_ets_fp   = eth_sideband_if_ip0.ptp_fp_o;
assign ptp_tx_if_ip0.o_ptp_ets_vl   = o_ptp_ets_vl_ip0;
assign ptp_tx_if_ip0.o_ptp_its_vl   = o_ptp_rx_its_vl_ip0;
assign ptp_tx_if_ip0.o_ptp_rx_sop   = rx_startofpacket_ip0;          
assign ptp_tx_if_ip0.o_ptp_rx_its   = eth_sideband_if_ip0.ptp_rx_its; 
assign ptp_tx_if_ip0.o_ptp_rx_valid = rx_valid_ip0; 
assign ptp_tx_if_ip0.o_ptp_rx_its_valid = o_ptp_rx_its_valid_ip0; 

assign eth_sideband_if_ip0.ptp_valid = o_ptp_ets_valid_ip0; 
assign eth_sideband_if_ip0.ptp_ets_o = o_ptp_ets_ip0;     
assign eth_sideband_if_ip0.ptp_fp_o = o_ptp_ets_fp_ip0; 
assign eth_sideband_if_ip0.ptp_rx_its = o_ptp_rx_its_ip0;  
assign eth_sideband_if_ip0.tx_ptp_ready = tx_ptp_ready_ip0;
assign eth_sideband_if_ip0.rx_ptp_ready = rx_ptp_ready_ip0;      

assign eth_sideband_if_ip0.dut_tx_sop = dut.i_tx_startofpacket_ip0;
assign eth_sideband_if_ip0.dut_tx_valid = dut.i_tx_valid_ip0;
//assign eth_sideband_if_ip0.dut_tx_ready = dut.o_tx_ready_ip0;
assign eth_sideband_if_ip0.dut_ptp_req = dut.i_ptp_ts_req_ip0;
assign eth_sideband_if_ip0.dut_ptp_fp = dut.i_ptp_fp_ip0;
assign eth_sideband_if_ip0.dut_ptp_ets = dut.i_ptp_ins_ets_ip0;
assign eth_sideband_if_ip0.dut_ptp_cf = dut.i_ptp_ins_cf_ip0;
assign eth_sideband_if_ip0.dut_ptp_0csum = dut.i_ptp_zero_csum_ip0;
assign eth_sideband_if_ip0.dut_ptp_eb = dut.i_ptp_update_eb_ip0;
assign eth_sideband_if_ip0.dut_ptp_ts_offset = dut.i_ptp_ts_offset_ip0;
assign eth_sideband_if_ip0.dut_ptp_cf_offset = dut.i_ptp_cf_offset_ip0;
assign eth_sideband_if_ip0.dut_ptp_csum_offset = dut.i_ptp_csum_offset_ip0;
assign eth_sideband_if_ip0.dut_ptp_eb_offset = i_ptp_eb_offset_ip0; //used for monitoring
assign eth_sideband_if_ip0.dut_ptp_ts = dut.i_ptp_tx_its_ip0;
assign eth_sideband_if_ip0.tx_skip_crc = dut.i_tx_skip_crc_ip0;
assign eth_sideband_if_ip0.dut_ptp_asym_lat_en = dut.i_ptp_asym_ip0;
assign eth_sideband_if_ip0.dut_ptp_p2p_en = dut.i_ptp_p2p_ip0;
assign eth_sideband_if_ip0.dut_ptp_asym_sign = dut.i_ptp_asym_sign_ip0;
assign eth_sideband_if_ip0.dut_ptp_asym_p2p_idx = dut.i_ptp_asym_p2p_idx_ip0;

assign i_ptp_tx_tod_valid_ip0 = 1;//temp assign to 1
assign i_ptp_rx_tod_valid_ip0 = 1;//temp assign to 1

initial begin
   //uvm_config_db#(ptp_tx_vif)::set(null,"*","ptp_tx_interface",ptp_tx_if_ip0); 
   uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","ptp_tx_rtb_path","ptp_tx_rtb_ip0");
end     

   assign spy_if_ip0.o_tx_am = eth_env_top.dut.ip0.top_ip0.sip_inst.hi_tx_ptp_sync_am; //above commented code should work till that its a workaround 
   assign spy_if_ip0.o_rx_am = eth_env_top.dut.ip0.top_ip0.sip_inst.hi_rx_ptp_sync_am;


   reg avalon_st_tx_ready_dut1;
   reg avalon_st_tx_ready_dut2;
   reg avalon_st_tx_ready_dut3;

   `ifdef RDY_LAT
       always @ (posedge clk_ip0) begin
           if (reset_ip0) begin
//               tx_ready_ip0 <= 1'b0;
               avalon_st_tx_ready_dut1 <= 1'b0;
               avalon_st_tx_ready_dut2 <= 1'b0;
               avalon_st_tx_ready_dut3 <= 1'b0;
           end else begin
               avalon_st_tx_ready_dut1 <= dut.o_tx_ready_ip0;
               avalon_st_tx_ready_dut2 <= avalon_st_tx_ready_dut1;
               avalon_st_tx_ready_dut3 <= avalon_st_tx_ready_dut2;
           end
       end
     if (`RDY_LAT==0) begin
       assign eth_sideband_if_ip0.dut_tx_ready = dut.o_tx_ready_ip0;
     end else if (`RDY_LAT==1) begin
       assign eth_sideband_if_ip0.dut_tx_ready = avalon_st_tx_ready_dut1;
     end else if (`RDY_LAT==2) begin
       assign eth_sideband_if_ip0.dut_tx_ready = avalon_st_tx_ready_dut2;
     end else if (`RDY_LAT==3) begin
       assign eth_sideband_if_ip0.dut_tx_ready = avalon_st_tx_ready_dut3;
     end

   `else
       assign th_sideband_if_ip0.dut_tx_ready = dut.o_tx_ready_ip0;
   `endif
