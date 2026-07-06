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


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Description : 
//
// Top Level SGMII Receive Converter.
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
(*altera_attribute = {"SUPPRESS_DA_RULE_INTERNAL=\"D102\"" } *)
module alt_mge16_pcs_top_rx_converter (

   pcs_clk_reset,
   mac_clk_reset,
   pcs_clk,
   mac_clk,
   mac_clkena,
   pcs_clkena,
   sgmii_speed_rx_mac_clk,
   sgmii_speed_rx_phy_clk,
   sw_reset_rx_mac_clk,
   sw_reset_rx_phy_clk,
   pcs_data,
   pcs_dv,
   pcs_err,
   pcs_dv_single_bit,
   rx_lane_alignment,
   mac_data,
   mac_dv,
   mac_err,
   mac_mii_data,
   mac_mii_dv,
   mac_mii_err,
   calc_clk,
   latency_adj,
   sync_status,
   wa_boundary,
   eccstatus,
   latency_sclk,
   latency_sclk_reset,
   latency_xcvr_rx
);
   
parameter SYNCHRONIZER_DEPTH = 3;
parameter DEVICE_FAMILY    = "Arria 10";                 //  Device family name   
parameter ENABLE_PHASE_CALC = 0;
parameter ENABLE_ECC = 0;


//*********************************************************************************
// 1588's PCS Latency in unit of GMII16b clock cycles
//*********************************************************************************
// Arria 10
//   Hard FIFO = Fast Register mode
//   PCS Latency (simulation) = 13.5 cycles
// 
// Arria V
//   Hard FIFO = FIFO mode
//   PCS Latency (simulation) = 14.5 cycles
//   FIFO Latency = 2.0 to 3.0 cycles (data sheet),
//                  3.0 cycles (simulation),
//                  2.5 cycles (average, -0.5 from simulation)
//   PCS Latency (average) = 14.0 cycles
//---------------------------------------------------------------------------------

// Latency from PMA parallel output to FIFO write enabled input (In unit of clock cycle, frac. clock cycle)
localparam PHASE_CALC_ADJ_0 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd512} : // 15.50 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd512} : // 13.50 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd0}   : // 14.00 cycles
                                                              {6'd13,10'd512};
localparam PHASE_CALC_ADJ_1 = (DEVICE_FAMILY == "Stratix 10")? {6'd16,10'd563} : // 15.55 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd563} : // 13.55 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd51}  : // 14.05 cycles
                                                              {6'd13,10'd563};
localparam PHASE_CALC_ADJ_2 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd614} : // 15.60 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd614} : // 13.60 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd102} : // 14.10 cycles
                                                              {6'd13,10'd614};
localparam PHASE_CALC_ADJ_3 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd666} : // 15.65 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd666} : // 13.65 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd154} : // 14.15 cycles
                                                              {6'd13,10'd666}; 
localparam PHASE_CALC_ADJ_4 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd717} : // 15.70 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd717} : // 13.70 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd205} : // 14.20 cycles
                                                              {6'd13,10'd717};
localparam PHASE_CALC_ADJ_5 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd768} : // 15.75 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd768} : // 13.75 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd256} : // 14.25 cycles
                                                              {6'd13,10'd768};
localparam PHASE_CALC_ADJ_6 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd819} : // 15.80 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd819} : // 13.80 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd307} : // 14.30 cycles
                                                              {6'd13,10'd819};
localparam PHASE_CALC_ADJ_7 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd870} : // 15.85 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd870} : // 13.85 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd358} : // 14.35 cycles
                                                              {6'd13,10'd870};
localparam PHASE_CALC_ADJ_8 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd922} : // 15.90 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd922} : // 13.90 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd410} : // 14.40 cycles
                                                              {6'd13,10'd922};
localparam PHASE_CALC_ADJ_9 = (DEVICE_FAMILY == "Stratix 10") ? {6'd16,10'd973} : // 15.95 cycles + 1 cycle for case:433815
                              (DEVICE_FAMILY == "Arria 10") ? {6'd13,10'd973} : // 13.95 cycles
                              (DEVICE_FAMILY == "Arria V")  ? {6'd14,10'd461} : // 14.45 cycles
                                                              {6'd13,10'd973};

// Latency from FIFO output to MII/GMII interface (In unit of clock cycle)
localparam INTERNAL_LATENCY_1000 = 6'd1;
localparam INTERNAL_LATENCY_100  = 6'd4;
localparam INTERNAL_LATENCY_10   = 6'd49;

localparam FRAC_CYCLE = 10;
localparam SAMPLE_SIZE = (ENABLE_PHASE_CALC==0)? 0 : 64;
localparam RM_DEL_INS_WIDTH = 3;
localparam MAX_SHIFT = 7; // number left-shifting/multiplication for lower speed. e.g. 10/100m
localparam RM_DEL_INS_WIDTH_ADJ = RM_DEL_INS_WIDTH + MAX_SHIFT + FRAC_CYCLE;
localparam FF_WIDTH = ENABLE_PHASE_CALC == 0 ? 20 : 20+RM_DEL_INS_WIDTH_ADJ; // to transfer octet_del_num_out from pcs_clk to mac_clk

localparam CALC_CNTR_WIDTH = 7;
localparam CNTR_WIDTH = 11;
localparam SAMPLING_WINDOW_SIZE_CALC = 7'd75;
localparam SAMPLING_WINDOW_SIZE = 11'd117;
localparam sync_stages = 2;

input   pcs_clk_reset;          //  Asynchronous Reset - pcs_clk Domain
input   mac_clk_reset;          //  Asynchronous Reset - mac_clk Domain
input   pcs_clk;                //  125MHz Receive PCS Clock
input   mac_clk;                //  Receive MAC Clock
input   mac_clkena;             //  Receive MAC clock enable
input   pcs_clkena;
input   [1:0] sgmii_speed_rx_mac_clk; //  Signal Detect from PMA
input   [1:0] sgmii_speed_rx_phy_clk; //  Signal Detect from PMA
input   sw_reset_rx_mac_clk;    //  SW Synchronous Reset           
input   sw_reset_rx_phy_clk;    //  SW Synchronous Reset           
input   [15:0] pcs_data;        //  GMII Data enhancement for 1G/2.5G
input   [1:0] pcs_dv;           //  GMII Data Valid enhancement for 1G/2.5G        
input   [1:0] pcs_err;          //  GMII Error enhancement for 1G/2.5G           
input   pcs_dv_single_bit;      //  Single bit GMII Data Valid for rate match FIFO
input   rx_lane_alignment;      //  RX realignment, add latency by half cycle if asserted
output  [15:0] mac_data;        //  GMII Data enhancement for 1G/2.5G   
output  [1:0] mac_dv;           //  GMII Data Valid enhancement for 1G/2.5G           
output  [1:0] mac_err;          //  GMII Error enhancement for 1G/2.5G    
output  [3:0] mac_mii_data;     //  MII Data
output  mac_mii_dv;             //  MII Data Valid        
output  mac_mii_err;            //  MII Error
input   calc_clk;
output  [21:0] latency_adj;
input   [1:0] sync_status;      //  phy sync status enhancement for 1G/2.5G  
input   [4:0] wa_boundary;      //  word aligner boundary
output  [1:0] eccstatus;        //  ECC status
input   latency_sclk;
input   latency_sclk_reset;
input   [11:0] latency_xcvr_rx;


reg     [15:0] mac_data;        // enhancement for 1G/2.5G 
reg     [1:0] mac_dv;           // enhancement for 1G/2.5G 
reg     [1:0] mac_err;          // enhancement for 1G/2.5G 

reg     [21:0] latency_adj;

wire    ff_afull;                   //  FIFO Almost Full
wire    ff_wren;                    //  FIFO Write Enable           
wire    [FF_WIDTH-1:0] ff_data_in;  //  FIFO Data Input
wire    ff_aempty;                  //  FIFO Almost Empty
wire    ff_rden;                    //  FIFO Read Enable                                  
wire    [FF_WIDTH-1:0] ff_data_out; //  FIFO Data Output
wire    clk_ena;                    //  Clock Enable (MII Mode)
reg     mii_clk_ena;                //  Clock Enable (MII Mode)
wire    mii_ena;                    //  MII Interface Enable

wire    [1:0] eth_speed_reg2_macclk;
reg     [1:0] eth_speed_reg3_macclk;

wire    [1:0] eth_speed_reg2_pcsclk;
reg     [1:0] eth_speed_reg3_pcsclk;

reg     eth_speed_change_macclk;
reg     eth_speed_change_pcsclk;

reg    reset_ff_rd;
reg    reset_ff_wr;
wire   reset_calc_clk;

reg    [4:0] af_threshold;
reg    [4:0] ae_threshold;

wire   [1:0] sync_status_macclk;
wire         octet_del_en_start_wrclk;
wire         octet_del_en_start_macclk;
wire                            octet_ins_en;  
wire [RM_DEL_INS_WIDTH_ADJ-1:0] octet_ins_num;
wire [11:0] latency_adj_w;
reg [CNTR_WIDTH-1:0] sampling_win_size_wr; // 1588 sampling window size in pcs_clk cycle
reg [CNTR_WIDTH-1:0] sampling_win_size_rd; // 1588 sampling window size in mac_clk cycle

// ECC
// -------------
wire [36:0] ff_data_in_ecc;
wire [36:0] ff_data_out_ecc;
reg  [1:0]  eccstatus_dsw;
wire        err_detected_dsw;
wire        err_fatal_dsw;
wire        err_corrected_dsw;

alt_mge16_pcs_reset_synchronizer reset_sync_2 (
    .clk(calc_clk),
    .reset_in(reset_ff_rd),
    .reset_out(reset_calc_clk)
    );

assign eth_speed_reg2_macclk = sgmii_speed_rx_mac_clk;
assign eth_speed_reg2_pcsclk = sgmii_speed_rx_phy_clk;

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_DEL_EN_MAC_CLK(
   .clk(mac_clk), // INPUT
   .reset_n(~mac_clk_reset), //INPUT
   .din(octet_del_en_start_wrclk), //INPUT
   .dout(octet_del_en_start_macclk));// OUTPUT

alt_mge16_pcs_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_SYNC_STATUS_MAC_CLK(
   .clk(mac_clk), // INPUT
   .reset_n(~mac_clk_reset), //INPUT
   .din(sync_status[0]), //INPUT
   .dout(sync_status_macclk[0]));// OUTPUT
    
always@(posedge mac_clk_reset or posedge mac_clk)
begin

        if (mac_clk_reset==1'b1)
        begin
                eth_speed_reg3_macclk <= 2'b10;
        end
        else
        begin
                eth_speed_reg3_macclk <= eth_speed_reg2_macclk;
        end
        
end

always@(posedge pcs_clk_reset or posedge pcs_clk)
begin

        if (pcs_clk_reset==1'b1)
        begin
                eth_speed_reg3_pcsclk <= 2'b10;
        end
        else
        begin
                eth_speed_reg3_pcsclk <= eth_speed_reg2_pcsclk;
        end
        
end

always@(posedge mac_clk_reset or posedge mac_clk)
    begin
    if (mac_clk_reset==1'b1)
        begin
        mii_clk_ena <= 1'b0 ;        
        end
    else begin
         if (mac_clkena == 1'b1) begin
            mii_clk_ena <= ~mii_clk_ena;
            end
         end
    end

assign clk_ena = (eth_speed_reg2_macclk==2'b10) ? 1'b1 : mii_clk_ena;

always@(posedge pcs_clk_reset or posedge pcs_clk)
    begin
        if (pcs_clk_reset==1'b1)
            begin
            reset_ff_wr  <= 1'b1 ;
            end
        else
            begin            
            reset_ff_wr  <= eth_speed_change_pcsclk|sw_reset_rx_phy_clk;
            end
    end
    
always@(posedge mac_clk_reset or posedge mac_clk)
    begin
        if (mac_clk_reset==1'b1)
            begin
            reset_ff_rd  <= 1'b1 ;
            end
        else
            begin            
            reset_ff_rd  <= eth_speed_change_macclk|sw_reset_rx_mac_clk;
            end
    end

	
//////ED


wire [15:0] pcs_data_sgmii;
wire [1:0] pcs_en_sgmii;
wire [1:0] pcs_err_sgmii;
wire [15:0] pcs_data_gige;
wire [1:0] pcs_dv_gige;
wire [1:0] pcs_err_gige;

	

assign   pcs_data_gige =   (eth_speed_reg2_pcsclk[1]) ? pcs_data : pcs_data_sgmii;
assign   pcs_dv_gige =     (eth_speed_reg2_pcsclk[1]) ? pcs_dv : pcs_en_sgmii;
assign   pcs_err_gige =    (eth_speed_reg2_pcsclk[1]) ? pcs_err : pcs_err_sgmii;

alt_mge16_pcs_sgmii_8_to_16_converter U_RXSGMIICV (
          .reset(reset_ff_wr),
          .clk(pcs_clk),
          .rx_ena(pcs_clkena),
		  .pcs_data_out(pcs_data_sgmii),
          .pcs_en_out(pcs_en_sgmii),
          .pcs_err_out(pcs_err_sgmii),
          .pcs_data_in(pcs_data),
          .pcs_en_in(pcs_dv),
          .pcs_err_in(pcs_err));	
	
	
	
alt_mge16_pcs_rx_converter U_RXC (
          .clk(pcs_clk),
          .reset(reset_ff_wr),
          .sw_reset(sw_reset_rx_phy_clk),
          .eth_speed(eth_speed_reg2_pcsclk),
          .pcs_data(pcs_data_gige),
          .pcs_dv(pcs_dv_gige),
          .pcs_err(pcs_err_gige),
          .ff_afull(ff_afull),
          .ff_wren(ff_wren),
          .ff_data(ff_data_in),
          .sampling_win_size_wr(sampling_win_size_wr),
          .octet_del_en(octet_del_en_start_wrclk));
defparam
   U_RXC.RM_DEL_INS_WIDTH      = RM_DEL_INS_WIDTH,
   U_RXC.RM_DEL_INS_WIDTH_ADJ  = RM_DEL_INS_WIDTH_ADJ,
   U_RXC.FRAC_CYCLE            = FRAC_CYCLE,
   U_RXC.CNTR_WIDTH            = CNTR_WIDTH,
   U_RXC.ENABLE_PHASE_CALC     = ENABLE_PHASE_CALC;

always@(posedge pcs_clk_reset or posedge pcs_clk)
    begin
        if (pcs_clk_reset==1'b1)
            begin
            af_threshold <= 5'd28;
            end
        else
            begin
            af_threshold <= (eth_speed_reg2_pcsclk == 2'b10) ? 5'd16 : 5'd28; // AF Threshold set to 16 for 1000Mbps, for 10/100Mbps set to 28
            end
    end

always@(posedge mac_clk_reset or posedge mac_clk)
    begin
        if (mac_clk_reset==1'b1)
            begin
            ae_threshold <= 5'd4;
            end
        else
            begin
            ae_threshold <= (eth_speed_reg2_macclk == 2'b10) ? 5'd4 : 5'd2; // AE Threshold set to 4 for 1000Mbps, for 10/100Mbps set to 2
            end
    end

generate if (ENABLE_ECC == 1 && FF_WIDTH == 30)
begin
   // U_DSW with ECC protection
   alt_mge16_pcs_ecc_enc_x30_wrapper U_ECC_ENC_DSW
   (
      .data (ff_data_in),
      .q (ff_data_in_ecc)
   );

   alt_mge16_pcs_ecc_dec_x30 U_ECC_DEC_DSW
   (
      .data(ff_data_out_ecc),
      .q(ff_data_out),
      .err_corrected(err_corrected_dsw),
      .err_detected(err_detected_dsw),
      .err_fatal(err_fatal_dsw)
   );

   always @(posedge mac_clk or posedge reset_ff_rd)
   begin
      if (reset_ff_rd)
      begin
         eccstatus_dsw <= 2'b0;
      end
      else
      begin
         if (ff_rden)
         begin
            eccstatus_dsw <= {err_detected_dsw, err_fatal_dsw};
         end
         else
         begin
            eccstatus_dsw <= 2'b0;
         end
      end
   end

   assign eccstatus = eccstatus_dsw;

   // ADDR_WIDTH tied to ae_threshold/af_threshold data width
   // latency_adj_w data width must be at least ADDR_WIDTH + 6 (fractional).
   alt_mge16_pcs_a_fifo_24 #(.FF_WIDTH(37),
                          .ADDR_WIDTH(5), 
                          .DEPTH(32),
                          .SAMPLE_SIZE(SAMPLE_SIZE),
                          .DEVICE_FAMILY(DEVICE_FAMILY))
      U_DSW (
             .reset_wclk(reset_ff_wr),
             .reset_rclk(reset_ff_rd),
             .wclk(pcs_clk),
             .wclk_ena(1'b1),
             .wren(ff_wren),
             .din(ff_data_in_ecc),
             .rclk(mac_clk),
             .rclk_ena(mac_clkena),
             .rden(ff_rden),
             .dout(ff_data_out_ecc),
             .afull(ff_afull),
             .aempty(ff_aempty),
             .af_threshold(af_threshold),
             .ae_threshold(ae_threshold),
             .calc_clk(calc_clk),
             .reset_calc_clk(reset_calc_clk),
             .clk_125(mac_clk),
             .reset_clk_125(mac_clk_reset),
             .latadj(latency_adj_w));
end
else if (ENABLE_ECC == 1 && FF_WIDTH == 10)
begin
   // U_DSW with ECC protection
   alt_mge16_pcs_ecc_enc_x10_wrapper U_ECC_ENC_DSW
   (
      .data (ff_data_in),
      .q (ff_data_in_ecc[14:0])
   );

   alt_mge16_pcs_ecc_dec_x10 U_ECC_DEC_DSW
   (
      .data(ff_data_out_ecc[14:0]),
      .q(ff_data_out),
      .err_corrected(err_corrected_dsw),
      .err_detected(err_detected_dsw),
      .err_fatal(err_fatal_dsw)
   );

   always @(posedge mac_clk or posedge reset_ff_rd)
   begin
      if (reset_ff_rd)
      begin
         eccstatus_dsw <= 2'b0;
      end
      else
      begin
         if (ff_rden)
         begin
            eccstatus_dsw <= {err_detected_dsw, err_fatal_dsw};
         end
         else
         begin
            eccstatus_dsw <= 2'b0;
         end
      end
   end

   assign eccstatus = eccstatus_dsw;
   assign ff_data_in_ecc[36:15] = 22'b0;
   assign ff_data_out_ecc[36:15] = 22'b0;

   // ADDR_WIDTH tied to ae_threshold/af_threshold data width
   // latency_adj_w data width must be at least ADDR_WIDTH + 6 (fractional).
   alt_mge16_pcs_a_fifo_24 #(.FF_WIDTH(15),
                          .ADDR_WIDTH(5), 
                          .DEPTH(32),
                          .SAMPLE_SIZE(SAMPLE_SIZE),
                          .DEVICE_FAMILY(DEVICE_FAMILY))
      U_DSW (
             .reset_wclk(reset_ff_wr),
             .reset_rclk(reset_ff_rd),
             .wclk(pcs_clk),
             .wclk_ena(1'b1),
             .wren(ff_wren),
             .din(ff_data_in_ecc[14:0]),
             .rclk(mac_clk),
             .rclk_ena(mac_clkena),
             .rden(ff_rden),
             .dout(ff_data_out_ecc[14:0]),
             .afull(ff_afull),
             .aempty(ff_aempty),
             .af_threshold(af_threshold),
             .ae_threshold(ae_threshold),
             .calc_clk(calc_clk),
             .reset_calc_clk(reset_calc_clk),
             .clk_125(mac_clk),
             .reset_clk_125(mac_clk_reset),
             .latadj(latency_adj_w));

end
else
begin
   // ADDR_WIDTH tied to ae_threshold/af_threshold data width
   // latency_adj_w data width must be at least ADDR_WIDTH + 6 (fractional).
   alt_mge16_pcs_a_fifo_24 #(.FF_WIDTH(FF_WIDTH),
                          .ADDR_WIDTH(5), 
                          .DEPTH(32),
                          .SAMPLE_SIZE(SAMPLE_SIZE),
                          .DEVICE_FAMILY(DEVICE_FAMILY))
      U_DSW (
             .reset_wclk(reset_ff_wr),
             .reset_rclk(reset_ff_rd),
             .wclk(pcs_clk),
             .wclk_ena(1'b1),
             .wren(ff_wren),
             .din(ff_data_in),
             .rclk(mac_clk),
             .rclk_ena(mac_clkena),
             .rden(ff_rden),
             .dout(ff_data_out),
             .afull(ff_afull),
             .aempty(ff_aempty),
             .af_threshold(af_threshold),
             .ae_threshold(ae_threshold),
             .calc_clk(calc_clk),
             .reset_calc_clk(reset_calc_clk),
             .clk_125(mac_clk),
             .reset_clk_125(mac_clk_reset),
             .latadj(latency_adj_w));

   assign ff_data_in_ecc = 37'b0;
   assign ff_data_out_ecc = 37'b0;
   assign err_detected_dsw = 1'b0;
   assign err_fatal_dsw = 1'b0;
   assign err_corrected_dsw = 1'b0;
   assign eccstatus = 2'b0;

end
endgenerate

alt_mge16_pcs_rx_fifo_rd #(.RM_DEL_INS_WIDTH(RM_DEL_INS_WIDTH),
                        .RM_DEL_INS_WIDTH_ADJ(RM_DEL_INS_WIDTH_ADJ),
                        .FRAC_CYCLE(FRAC_CYCLE),
                        .CNTR_WIDTH(CNTR_WIDTH))
   U_FFRD (
          .clk(mac_clk),
          .reset(reset_ff_rd),
          .clk_ena(clk_ena),
          .eth_speed(eth_speed_reg2_macclk),
          .rclk_ena(mac_clkena),
          .ff_dataout_dv(ff_data_out[17:16]),
          .ff_aempty(ff_aempty),
          .ff_rden(ff_rden),
          .sampling_win_size_rd(sampling_win_size_rd),
          .octet_ins_num(octet_ins_num),
          .octet_ins_en(octet_ins_en),
          .pcs_dv_single_bit(pcs_dv_single_bit));
//U_FFRD will use pcs_dv to predict SOP to prevent IDLE insertion at beginning of SOP. 
//Any change to the latency of pcs_dv must revisit this module.
          
assign mii_ena = (eth_speed_reg2_macclk==2'b10) ? 1'b0 : 1'b1 ;     //sbalasun: dont have to worry about MII for phase 1 of 1G/2.5G
          
alt_mge16_pcs_mii_tx_if_pcs #(.SYNCHRONIZER_DEPTH(SYNCHRONIZER_DEPTH))
    U_RXMII (
          .reset(mac_clk_reset),
          .tx_clk(mac_clk),
          .tx_clkena(mac_clkena),
          .clk_ena(clk_ena),
          .enan(mii_ena),
          .mii_txd_i(ff_data_out[7:0]),
          .mii_txdv_i(ff_data_out[8]),
          .mii_txerr_i(ff_data_out[9]),
          .mii_txd(mac_mii_data),
          .mii_txdv(mac_mii_dv),
          .mii_txerr(mac_mii_err));
          
always@(posedge mac_clk_reset or posedge mac_clk)
begin

        if (mac_clk_reset==1'b1)
        begin
        
                mac_err  <= 2'b00 ;
                mac_dv   <= 2'b00 ;
                mac_data <= 16'h0 ;
                
        end
        else
        begin
             if (mac_clkena == 1'b1) begin
        
		
            if (eth_speed_reg2_macclk==2'b11) 		//sbalasun:temporary for 1g
               begin
                  mac_err[0]  <= ff_data_out[9]; 
                  mac_dv[0]   <= ff_data_out[8]; 
                  mac_data[7:0] <= ff_data_out[7:0]; 
               end
               else
			   begin
                  mac_err  <= ff_data_out[19:18]; 
                  mac_dv   <= ff_data_out[17:16]; 
                  mac_data <= ff_data_out[15:0]; 
               end
   
        end
       end 
end

//ethernet speed change detection
always@(posedge mac_clk_reset or posedge mac_clk)
  begin: process_8
  if (mac_clk_reset == 1'b1)
     begin
         eth_speed_change_macclk <= 1'b 0;
     end
  else
     begin
      if (eth_speed_reg3_macclk != eth_speed_reg2_macclk)
       begin
         eth_speed_change_macclk <= 1'b 1;
       end
      else
       begin
         eth_speed_change_macclk <= 1'b 0;
       end
     end  
  end

always@(posedge pcs_clk_reset or posedge pcs_clk)
  begin: process_8b
  if (pcs_clk_reset == 1'b1)
     begin
         eth_speed_change_pcsclk <= 1'b 0;
     end
  else
     begin
      if (eth_speed_reg3_pcsclk != eth_speed_reg2_pcsclk)
       begin
         eth_speed_change_pcsclk <= 1'b 1;
       end
      else
       begin
         eth_speed_change_pcsclk <= 1'b 0;
       end
     end  
  end
   
   
   
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 1588 Latency Measurement
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
// normal condition
// latency_adj = latency_adj_fifo + latency_adj_speed
// latency_adj_fifo  = latency_adj_w * speed_multiplier
// latency_adj_speed = phase_calc_adj_reg + latency_adj_speed_const + wren_offset_mac - wren_offset_adjust

// if rate match happens, freeze the latency_adj (latency_adj_reg), and make the adjustment (+octet_ins_num / -octet_del_num)
// deletion : latency_adj = latency_adj_reg - octet_del_num;
// insertion: latency_adj = latency_adj_reg + octet_ins_num;

// PPM correction
// ppm_gap   : used in normal condition. it eliminates the inaccuracy caused by averager (in phase calculator) when ppm presents.
// ppm_accum_rm : used if rate match happens. it gives ppm effect to the freezed latency_adj.
// ppm_accum_normal : used in normal condition. it gives ppm effect to latency_adj. This is needed as
// latency_adj_fifo doesn't show ppm effect immediately every cycle, it shows accummulated ppm effect once in a while.
// note: accumulate ppm only at eff_clk_ena.

wire        ff_data_in_dv;
wire [7:0]  ff_data_in_data;
reg         wren_offset_found;
reg  [6:0]  wren_offset;
wire [6:0]  wren_offset_adjust;
wire [6:0]  wren_offset_mac;

reg   [4:0]  wa_boundary_reg;
reg   [15:0] phase_calc_adj_reg;

wire [5:0] latency_adj_speed_const;
reg  [18:0] latency_adj_speed;

reg  [16:0] latency_adj_fifo;
reg  [31:0] latency_adj_reg;
reg  [21:0] latency_adj_sum;
 
// Latency measured across FIFO (in unit of entries) need to be converted to number of clock cycle (per 8ns period)
// note: latency_adj_fifo has 6-bit to represent fractional cycle
always @ (posedge mac_clk_reset or posedge mac_clk) begin
	if (mac_clk_reset) begin
		latency_adj_fifo <= 17'h0;
	end else begin
        latency_adj_fifo <= (eth_speed_reg2_macclk == 2'b10) ? {5'd0,latency_adj_w} :
                            (eth_speed_reg2_macclk == 2'b01) ? {5'd0,latency_adj_w} :
                                                               {5'd0,latency_adj_w} ;
	end
end
 
assign latency_adj_speed_const = (eth_speed_reg2_macclk == 2'b10) ? INTERNAL_LATENCY_1000 :
                                 (eth_speed_reg2_macclk == 2'b01) ? INTERNAL_LATENCY_100 :
                                 INTERNAL_LATENCY_10;

assign wren_offset_adjust = (eth_speed_reg2_macclk == 2'b10) ? 7'd1 :
                            (eth_speed_reg2_macclk == 2'b01) ? 7'd10 :
                            7'd100;

// Calculate the offset of write enabled from the boundary of SFD (0xD5)
assign ff_data_in_dv   = ff_data_in[8];
assign ff_data_in_data = ff_data_in[7:0];

always @ (posedge reset_ff_wr or posedge pcs_clk) begin
	if (reset_ff_wr) begin
		wren_offset_found <= 1'b0;
        wren_offset <= 7'h0;
	end else begin
         if(!wren_offset_found) begin
             if (!(ff_data_in_dv && (ff_data_in_data == 8'hD5))) begin
                 wren_offset <= 7'h0;
                 wren_offset_found <= 1'b0;
             end
             else if (ff_wren) begin
                 wren_offset <= wren_offset + 7'h1;
                 wren_offset_found <= 1'b1;
             end
             else begin
                 wren_offset <= wren_offset + 7'h1;
                 wren_offset_found <= 1'b0;
             end
         end
         else begin
             wren_offset <= wren_offset;
             wren_offset_found <= 1'b1;
         end
	end
end
   
alt_mge_phy_std_synchronizer_bundle #(7,SYNCHRONIZER_DEPTH) U_SYNC_WREN_OFFSET(
 .clk(mac_clk),
 .reset_n(~mac_clk_reset),
 .din(wren_offset),
 .dout(wren_offset_mac));

// capture word aligner boundary only when the sync status is HIGH
always @ (posedge mac_clk_reset or posedge mac_clk) begin
	if (mac_clk_reset) begin
		wa_boundary_reg <= 5'h0;
	end else begin
		wa_boundary_reg <= wa_boundary;
	end
end

// different path delay cycle for different wa_boundary
always @ (posedge mac_clk_reset or posedge mac_clk) begin
	if (mac_clk_reset) begin
		phase_calc_adj_reg <= PHASE_CALC_ADJ_0;
	end else begin
		phase_calc_adj_reg <= wa_boundary_reg == 5'h0 ? PHASE_CALC_ADJ_0 :
							  wa_boundary_reg == 5'h1 ? PHASE_CALC_ADJ_1 :
							  wa_boundary_reg == 5'h2 ? PHASE_CALC_ADJ_2 :
							  wa_boundary_reg == 5'h3 ? PHASE_CALC_ADJ_3 :
							  wa_boundary_reg == 5'h4 ? PHASE_CALC_ADJ_4 :
							  wa_boundary_reg == 5'h5 ? PHASE_CALC_ADJ_5 :
							  wa_boundary_reg == 5'h6 ? PHASE_CALC_ADJ_6 :
							  wa_boundary_reg == 5'h7 ? PHASE_CALC_ADJ_7 :
							  wa_boundary_reg == 5'h8 ? PHASE_CALC_ADJ_8 :
							  wa_boundary_reg == 5'h9 ? PHASE_CALC_ADJ_9 :
							  PHASE_CALC_ADJ_0;
	end
end

reg [11:0] latency_accum_xcvr;
generate if(DEVICE_FAMILY == "Stratix 10") 
begin
	wire [11:0] latency_accum_out;
	wire latency_accum_val; 

    // cross over to 125MHz domain
    alt_mge16_pcs_clock_crosser 
	#(.BITS_PER_SYMBOL(12))
    latency_pulse_delay_transfer (.in_clk(latency_sclk),
                                  .in_reset(latency_sclk_reset),
                                  .in_ready(),
                                  .in_valid(1'b1),
                                  .in_data(latency_xcvr_rx),
                                  .out_clk(mac_clk),
                                  .out_reset(mac_clk_reset),
                                  .out_ready(1'b1),
                                  .out_valid(latency_accum_val),
                                  .out_data(latency_accum_out));
	
	always @ (posedge mac_clk or posedge mac_clk_reset) begin
        if (mac_clk_reset) begin
            latency_accum_xcvr <= {12{1'b0}};
        end else begin      
            if (latency_accum_val) begin
                latency_accum_xcvr <= latency_accum_out;
            end else begin
                latency_accum_xcvr <= latency_accum_xcvr;
            end        
        end
    end	
end else begin
   always @ (posedge mac_clk or posedge mac_clk_reset) begin
         if (mac_clk_reset) 
            latency_accum_xcvr <= {12{1'b0}};
         else      
            latency_accum_xcvr <= {12{1'b0}};     
     end
end
endgenerate 

// rate match latency handling
// number of deletion is tagged with packet to cross clock domain from wr_clk to rd_clk
// octet_ins_en or octet_del_en is essential to freeze latency_adj_reg
wire                            octet_del_en; 
wire                            octet_del_en_end; 
//wire [RM_DEL_INS_WIDTH-1:0]     octet_del_num_out;
wire [RM_DEL_INS_WIDTH_ADJ-1:0] octet_del_num;

generate if (ENABLE_PHASE_CALC == 0)
begin
   assign octet_del_num     = 0;
end else begin
   assign octet_del_num     = ff_data_out[FF_WIDTH-1:FF_WIDTH-RM_DEL_INS_WIDTH_ADJ];
end
endgenerate

assign octet_del_en_end  = octet_del_en_start_macclk ? ((octet_del_num == 0) ? 1'b0 : 1'b1) : 1'b0;
assign octet_del_en      = octet_del_en_start_macclk | octet_del_en_end;
// Timing issue! Multiplication moved back to wr_clk domain (before data go into fifo) 
// To close timing on AV and CV, the following are derived:
// original equation: octet_del_num (cycle) = (octet_del_num_out<<FRAC_CYCLE)*multi_factor
// 1gbps  : multi_factor = 1
// 100mbps: multi_factor = 10 = (8+2) = (<<3 + <<1)
// 10mbps : multi_factor = 100 = (64+32+4) = (<<6 + <<5 + <<2)
// assign octet_del_num     = (eth_speed_reg2_macclk == 2'b10) ? (octet_del_num_out<<(FRAC_CYCLE)) :
                           // (eth_speed_reg2_macclk == 2'b01) ? ((octet_del_num_out<<(FRAC_CYCLE+3)) + (octet_del_num_out<<(FRAC_CYCLE+1))) :
                           // ((octet_del_num_out<<(FRAC_CYCLE+6)) + (octet_del_num_out<<(FRAC_CYCLE+5)) + (octet_del_num_out<<(FRAC_CYCLE+2)));



// PPM Inaccuracy correction
// effective ppm correction = accummulated ppm (at mac_clkena & clk_ena time only) * multi_factor
// mac_clkena & clk_ena  gives 1/multi_factor effect to accummulated_ppm, and thus cancel off with 
// multiplication of multi_factor that comes after.
localparam PPM_CNTR_WIDTH = 20; // ppm counter: 20-bit of fractional cycle
localparam FIFO_FRAC_WIDTH = 6; // fractional cycle width of latency_adj_fifo

wire [PPM_CNTR_WIDTH-1:0] ppm;  // 20-bit ppm in fractional cycle unit
wire ppm_sign;                  // 1 if clk_a faster than clk_b

alt_mge16_pcs_1588_ppm_counter
#(
    .PPM_CNTR_WIDTH(PPM_CNTR_WIDTH)
    ) ppm_cntr_1588
    (
    .clk_a(mac_clk),
    .clk_b(pcs_clk),
    .rst_a_n(~mac_clk_reset),
    .rst_b_n(~pcs_clk_reset),
    .clk_a_sync_status(sync_status_macclk[0]),
    .ppm_sign(ppm_sign),
    .ppm(ppm)
    );

// effective clk_ena
// wire eff_clk_ena;
// assign eff_clk_ena = mac_clkena & clk_ena;

/* Accummulated at latency_adj_reg (fractional cycle width increased) to close timing
// ppm_accum_rm
reg  [31:0]                     ppm_accum_rm_reg;
wire [21:0]                     ppm_accum_rm;

assign ppm_accum_rm = ppm_accum_rm_reg[31:10]; // cut the extra 10 bits of fractional cycle

// ppm_accum_rm_reg: accummulate ppm (20-bit fractional cycle)
always @(posedge mac_clk_reset or posedge mac_clk) begin
    if (mac_clk_reset) begin
        ppm_accum_rm_reg <= {32{1'b0}};
    end
    else begin
        if (octet_ins_en | octet_del_en) begin
            //if (eff_clk_ena) begin
                ppm_accum_rm_reg <= ppm_accum_rm_reg + ppm;
            //end
            //else begin
            //    ppm_accum_rm_reg <= ppm_accum_rm_reg;
            //end
        end
        else begin
            ppm_accum_rm_reg <= ppm;
        end    
    end
end
*/

// ppm_accum_normal
reg  [31:0] ppm_accum_normal_reg;
wire [21:0] ppm_accum_normal;
wire [FIFO_FRAC_WIDTH-1:0] latency_adj_fifo_frac;
reg  [FIFO_FRAC_WIDTH-1:0] latency_adj_fifo_frac_pre;
wire latency_adj_fifo_frac_update = (latency_adj_fifo_frac_pre == latency_adj_fifo_frac) ? 1'b0 : 1'b1;

assign latency_adj_fifo_frac = latency_adj_fifo[FIFO_FRAC_WIDTH-1:0];
// ppm_accum_normal is aligned to latency_adj_sum
assign ppm_accum_normal = ppm_accum_normal_reg[31:10]; // cut the extra 10-bit of frac. cycle

// ppm_accum_normal_reg: accummulate ppm (20-bit fractional cycle)
always @(posedge mac_clk_reset or posedge mac_clk) begin
    if (mac_clk_reset) begin
        latency_adj_fifo_frac_pre <= {FIFO_FRAC_WIDTH{1'b0}};
        ppm_accum_normal_reg      <= {32{1'b0}};
    end
    else begin
        latency_adj_fifo_frac_pre <= latency_adj_fifo_frac;
        
        if (latency_adj_fifo_frac_update) begin
            // latency_adj_fifo_sum updated, re-accummulate ppm
            ppm_accum_normal_reg <= {32{1'b0}};
        end
        else begin
            //if (eff_clk_ena) begin
                ppm_accum_normal_reg <= ppm_accum_normal_reg + ppm;
            //end
        end    
    end
end

// ppm_gap = max_drift/2 = (64 calc_clk cycle * ppm/cycle) / 2 = (32 calc_clk cycle * ppm/cycle)
reg [CNTR_WIDTH-1:0] sampling_win_size_rd_2; // stores number of rd_clk cycle that equivalent to 32 calc_clk cycle
reg [CNTR_WIDTH-1:0] ppm_gap_cntr;
reg  [31:0]          ppm_gap_reg;
reg  [21:0]          ppm_gap;

always @ (posedge mac_clk_reset or posedge mac_clk) begin
	if (mac_clk_reset) begin
        ppm_gap_cntr <= {CNTR_WIDTH{1'b0}};
        ppm_gap_reg <= 32'd0;
        ppm_gap     <= 22'd0;
        
	end else begin
        if (ppm_gap_cntr == 0)begin
            ppm_gap_cntr <= sampling_win_size_rd_2;
            ppm_gap      <= ppm_gap_reg[31:10];
            ppm_gap_reg  <= 32'd0;
        end
        else begin
            ppm_gap_cntr <= ppm_gap_cntr - 11'd1;
            //if (eff_clk_ena) begin
                ppm_gap_reg  <= ppm_gap_reg + ppm;
            //end
        end
        
    end
end

wire [21:0] ppm_normal;
// ppm_sign = 1: rd_clk faster than wr_clk (-ve ppm)
// ppm_sign = 0: rd clk slower than wr_clk (+ve ppm)
//assign ppm_normal = ppm_sign ? (ppm_gap - ppm_accum_normal) : (ppm_gap + ppm_accum_normal);
assign ppm_normal = 22'b0;
                                  
// 1588 latency measurement output
always @ (posedge mac_clk_reset or posedge mac_clk) begin
	if (mac_clk_reset) begin
		latency_adj_speed <= 19'h0;
         latency_adj       <= 22'h0;
         latency_adj_reg   <= 32'h0;
         latency_adj_sum   <= 22'h0;
	end else begin
		latency_adj_speed <= phase_calc_adj_reg                             // 16-bit
                             + {latency_adj_speed_const,{FRAC_CYCLE{1'b0}}}; // 6-bit + 10-bit
                             // Following offset adjustment is used when 1588 with SGMII is supported
                             // Leave these code disable for now until it is required later
                             // + {wren_offset_mac,{FRAC_CYCLE{1'b0}}}         // 7-bit + 10-bit
                             // - {wren_offset_adjust,{FRAC_CYCLE{1'b0}}};     // 7-bit + 10-bit
                             
         if (ENABLE_PHASE_CALC==0) begin
             latency_adj_sum <= latency_adj_speed;
             latency_adj_reg <= {latency_adj_speed, 10'd0};
             latency_adj     <= latency_adj_speed;
         end
         else begin
             // timing closure
             latency_adj_sum     <= {latency_accum_xcvr,4'd0} + {latency_adj_fifo,4'd0} + {6'd1, rx_lane_alignment, {(FRAC_CYCLE-1){1'b0}}} + {{3{latency_adj_speed[18]}}, latency_adj_speed};
             
             // Freeze latency_adj_reg when rate match enabled
             if (octet_ins_en) begin
                 latency_adj_reg     <= latency_adj_reg - ppm; // ppm_accum_rm
                 latency_adj         <= (latency_adj_reg[31:10] + octet_ins_num);
             end
             else if (octet_del_en) begin
                 latency_adj_reg     <= latency_adj_reg + ppm; // ppm_accum_rm
                 latency_adj         <= (latency_adj_reg[31:10] - octet_del_num);
             end
             else begin
                 // latency_adj_fifo has only 6-bit for fractional cycle, append 4 more bit for high accuracy latency measurement (latency_adj)
                 // add 1 cycle because there is 1 more latency in FIFO 
                 // latency_adj_reg     <= ({latency_adj_fifo,4'd0} + {6'd1, {FRAC_CYCLE{1'b0}}} + latency_adj_speed + ppm_normal);
                 // latency_adj         <= ({latency_adj_fifo,4'd0} + {6'd1, {FRAC_CYCLE{1'b0}}} + latency_adj_speed + ppm_normal); 
                 latency_adj_reg     <= {(latency_adj_sum + ppm_normal), 10'd0};
                 latency_adj         <= (latency_adj_sum + ppm_normal); 
             end
         end
	end
end


// 1588: latency unit conversion
// sampling_win_size_wr/rd shows 1588's sampling window size in unit of wr/rd clock cycle (converted from calc clk cycle)
// calculator latency (calc_clk=80mhz) : numdata= 1calc_clk, accum = 1calc_clk, path_delay_transfer = ~5calc_clk, window=64calc_clk, latadj=1rd_clk
// Therefore, SAMPLING_WINDOW_SIZE_CALC is about 70. allocate 5 more cycles to serve as buffer.
// assume worst case calc_clk is 10 times slower than rd/wr_clk. rd/wr_cntr number is therefore 10 times (4-left-shift) larger than calc_cntr number.
reg [CNTR_WIDTH-1:0] wr_cntr;
reg [CNTR_WIDTH-1:0] rd_cntr;
wire wr_counting;
wire rd_counting;
reg [CALC_CNTR_WIDTH-1:0] calc_cntr;
reg calc_counting;
reg [2:0] rest_time_cntr;

// used to calculate ppm_gap
wire rd_counting_2;
reg rd_counting_2_pre;
reg calc_counting_2;

// decreasing counter at calc_clk
always @(posedge reset_calc_clk or posedge calc_clk) begin
    if (reset_calc_clk) begin
        calc_cntr       <= {CALC_CNTR_WIDTH{1'b0}};
        calc_counting   <= 1'b0;
        calc_counting_2 <= 1'b0;
        rest_time_cntr  <= 3'd0;
    end
    else begin
        
        if (calc_cntr == {CALC_CNTR_WIDTH{1'b0}}) begin
            calc_cntr       <= SAMPLING_WINDOW_SIZE_CALC;
            calc_counting   <= 1'b0;
            calc_counting_2 <= 1'b0;
            rest_time_cntr  <= 3'd5;
        end
        else begin
            if (rest_time_cntr == 3'd0) begin
                calc_cntr     <= calc_cntr - 7'd1;
                calc_counting <= 1'b1;
                
                if (calc_cntr < (SAMPLING_WINDOW_SIZE_CALC - 7'd32)) begin
                    calc_counting_2 <= 1'b0;
                end
                else begin
                    calc_counting_2 <= 1'b1;
                end
            end
            else begin
                calc_cntr       <= SAMPLING_WINDOW_SIZE_CALC;
                calc_counting   <= 1'b0;
                calc_counting_2 <= 1'b0;
                rest_time_cntr  <= rest_time_cntr - 3'd1;
            end
        end
    end
end

alt_mge16_pcs_std_synchronizer #(sync_stages) wr_couting_transfer(
    .clk(pcs_clk),
    .reset_n(~reset_ff_wr),
    .din(calc_counting),
    .dout(wr_counting));

alt_mge_phy_std_synchronizer_bundle #(2, sync_stages) rd_couting_transfer(
    .clk(mac_clk),
    .reset_n(~reset_ff_rd),
    .din({calc_counting, calc_counting_2}),
    .dout({rd_counting, rd_counting_2}));

// increasing counter at pcs_clk (wr)
always @(posedge reset_ff_wr or posedge pcs_clk) begin
    if (reset_ff_wr) begin
        wr_cntr <= {CNTR_WIDTH{1'b0}};
        sampling_win_size_wr <= SAMPLING_WINDOW_SIZE;
    end
    else begin
        if (wr_counting) begin
            wr_cntr <= wr_cntr + 11'd1;
        end
        else begin // rest time
            if (wr_cntr != {CNTR_WIDTH{1'b0}}) begin
                sampling_win_size_wr <= wr_cntr;
            end
            wr_cntr <= {CNTR_WIDTH{1'b0}};
        end
    end
end

// increasing counter at mac_clk (rd)

always @(posedge reset_ff_rd or posedge mac_clk) begin
    if (reset_ff_rd) begin
        rd_cntr <= {CNTR_WIDTH{1'b0}};
        sampling_win_size_rd <= SAMPLING_WINDOW_SIZE;
        sampling_win_size_rd_2 <= {CNTR_WIDTH{1'b0}};
        rd_counting_2_pre <= 1'b0;
    end
    else begin
        rd_counting_2_pre <= rd_counting_2;
        if (rd_counting) begin
            rd_cntr <= rd_cntr + 11'd1;
            
            if (~rd_counting_2 & rd_counting_2_pre) begin // drop edge of rd_counting_2
                sampling_win_size_rd_2 <= rd_cntr;
            end
        end
        else begin // rest time
            if (rd_cntr != {CNTR_WIDTH{1'b0}}) begin
                sampling_win_size_rd <= rd_cntr;
            end
            rd_cntr <= {CNTR_WIDTH{1'b0}};
        end
    end
end
// end of latency unit conversion

endmodule // module top_rx_converter
