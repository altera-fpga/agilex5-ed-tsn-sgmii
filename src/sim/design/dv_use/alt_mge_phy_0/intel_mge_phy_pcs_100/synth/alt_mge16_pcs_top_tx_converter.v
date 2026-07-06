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
// Top Level SGMII Transmit Converter
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_top_tx_converter (

   pcs_clk_reset,
   mac_clk_reset,
   pcs_clk,
   mac_clk,
   mac_clkena,
   latency_sclk,
   latency_sclk_reset,
   sgmii_speed_tx_mac_clk,
   sgmii_speed_tx_phy_clk,
   sw_reset_tx_mac_clk,
   sw_reset_tx_phy_clk,
   mac_data,
   mac_en,
   mac_err,
   mac_mii_data,
   mac_mii_en,
   mac_mii_err,
   pcs_data,
   pcs_en,
   pcs_err,
   calc_clk,
   latency_adj,
   ptp_alignment,
   eccstatus,
   latency_xcvr_tx
);

parameter SYNCHRONIZER_DEPTH    = 3;                    //  Number of synchronizer
parameter DEVICE_FAMILY    = "Arria 10";                //  Device family name  
parameter ENABLE_PHASE_CALC = 0;
parameter ENABLE_ECC = 0;                               //  Enable ECC

//*********************************************************************************
// 1588's PCS Latency in unit of GMII16b clock cycles
//*********************************************************************************
// Arria 10
//   Hard FIFO = Fast Register mode
//   PCS Latency (simulation) = 8.0 cycles
// 
// Arria V
//   Hard FIFO = FIFO mode
//   PCS Latency (simulation) = 7.0 cycles
//   FIFO Latency = 3.0 - 4.0 cycles (data sheet),
//                  3.0 cycles (simulation),
//                  3.5 cycles (average)
//   PCS Latency (average) = 7.5 cycles
//---------------------------------------------------------------------------------

// Latency from FIFO output to PMA parallel input (In unit of clock cycle)
localparam PHASE_CALC_ADJ_AV = {6'd7,6'd32};  // 7.5 cycles
localparam PHASE_CALC_ADJ_A10 = {6'd8,6'd0}; // 8.0 cycles
localparam PHASE_CALC_ADJ_S10 = {6'd9,6'd0}; // 8.0 cycles + 1 cycle for case:433815

// Latency from MII/GMII interface to FIFO write enabled input (In unit of clock cycle)
localparam INTERNAL_LATENCY_1000 = {8'd2,6'd0};
localparam INTERNAL_LATENCY_100_ALIGN_0 = {8'd15,6'd0};
localparam INTERNAL_LATENCY_100_ALIGN_1 = {8'd15,6'd0}; // Adjustment done in TSE MAC
localparam INTERNAL_LATENCY_10_ALIGN_0 = {8'd150,6'd0};
localparam INTERNAL_LATENCY_10_ALIGN_1 = {8'd150,6'd0}; // Adjustment done in TSE MAC


   
input   pcs_clk_reset;          //  Asynchronous Reset - pcs_clk Domain
input   mac_clk_reset;          //  Asynchronous Reset - mac_clk Domain
input   pcs_clk;                //  125MHz Receive PCS Clock
input   mac_clk;                //  Receive MAC Clock
input   mac_clkena;             //  Receive MAC Clock Enable
input   latency_sclk;           //  Sampling clock for AIB FIFO measurement
input   latency_sclk_reset;
input   [1:0] sgmii_speed_tx_mac_clk; //  Signal Detect from PMA      
input   [1:0] sgmii_speed_tx_phy_clk; //  Signal Detect from PMA      
input   sw_reset_tx_mac_clk;    //  Software Reset
input   sw_reset_tx_phy_clk;    //  Software Reset
input   [15:0] mac_data;        //  GMII Data to support 1G and 2.5G
input   [1:0] mac_en;           //  GMII Data Valid to support 1G and 2.5G
input   [1:0] mac_err;          //  GMII Error to support 1G and 2.5G
input   [3:0] mac_mii_data;     //  MII Data
input   mac_mii_en;             //  MII Data Valid        
input   mac_mii_err;            //  MII Error 
output  [15:0] pcs_data;        //  GMII Data to support 1G and 2.5G
output  [1:0] pcs_en;           //  GMII Data Valid to support 1G and 2.5G        
output  [1:0] pcs_err;          //  GMII Errorto support 1G and 2.5G

input calc_clk;
output [21:0] latency_adj;      // 12-bit cycle, 10-bit fractional cycle
output  ptp_alignment;			// For 1588 mii alignment

output [1:0] eccstatus;         // ECC status

input  [11:0] latency_xcvr_tx;

localparam SAMPLE_SIZE = (ENABLE_PHASE_CALC==0)? 0 : 64;

   

wire    [15:0] pcs_data; 
wire    [1:0] pcs_en; 
wire    [1:0] pcs_err;
reg [21:0] latency_adj;

wire    ff_wren;                //  FIFO Write Enable
reg     [19:0] ff_din;          //  FIFO Inout Data to support 1G and 2.5G
wire    ff_afull;               //  FIFO Almost Full
wire    clk_ena;                //  Clock Enable (MII Mode)
reg     mii_clk_ena;            //  Clock Enable (MII Mode)
wire    [7:0] mac_mii_data_o;   //  MII Data
wire    mac_mii_en_o;           //  MII Data Valid        
wire    mac_mii_err_o;          //  MII Error

wire    mii_alignment_status;   //  MII Alignment Status for Latency Calculation

// I/O Registers
// -------------

reg     [15:0] mac_data_reg;     //  GMII Data
reg     [1:0] mac_en_reg;        //  GMII Data Valid        
reg     [1:0] mac_err_reg;       //  GMII Error                    

//  FIFO Read Data
//  --------------

wire    ff_rden;                //  FIFO Read Enable
wire    [19:0] ff_dout;          //  FIFO Output Data  
wire    ff_aempty;              //  FIFO Almost Empty

wire    [1:0] eth_speed_reg2_macclk;
reg     [1:0] eth_speed_reg3_macclk;

wire    [1:0] eth_speed_reg2_pcsclk;
reg     [1:0] eth_speed_reg3_pcsclk;

reg     eth_speed_change_macclk;
reg     eth_speed_change_pcsclk;

reg    reset_ff_rd;
reg    reset_ff_wr;
wire   reset_calc_clk;
wire   ptp_alignment;

// ECC
// -------------
wire [14:0] ff_din_ecc;
wire [14:0] ff_dout_ecc;
reg  [1:0]  eccstatus_dsw;
reg  [1:0]  eccstatus_txcv;
wire        err_detected_dsw;
wire        err_fatal_dsw;
wire        err_corrected_dsw;

alt_mge16_pcs_reset_synchronizer reset_sync_2 (
   .clk(calc_clk),
   .reset_in(reset_ff_rd),
   .reset_out(reset_calc_clk)
   );

assign eth_speed_reg2_macclk = sgmii_speed_tx_mac_clk;
assign eth_speed_reg2_pcsclk = sgmii_speed_tx_phy_clk;

always@(posedge mac_clk_reset or posedge mac_clk)
begin

        if (mac_clk_reset==1'b1)
        begin
                eth_speed_reg3_macclk <= 2'b10 ;
        end
        else
        begin
                eth_speed_reg3_macclk <= eth_speed_reg2_macclk ;
        end
        
end

always@(posedge pcs_clk_reset or posedge pcs_clk)
begin

        if (pcs_clk_reset==1'b1)
        begin
                eth_speed_reg3_pcsclk <= 2'b10 ;
        end
        else
        begin
                eth_speed_reg3_pcsclk <= eth_speed_reg2_pcsclk ;
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
assign ptp_alignment = mii_clk_ena;

always@(posedge mac_clk_reset or posedge mac_clk)
begin

        if (mac_clk_reset==1'b1)
        begin
        
                mac_err_reg  <= 2'b00 ;
                mac_en_reg   <= 2'b00 ;
                mac_data_reg <= 15'h0 ;
                
        end
        else
        begin
                
            // if (mac_clkena == 1'b1) begin    //sbalasun: original TSE code          
                // mac_err_reg  <= mac_err ;
                // mac_en_reg   <= mac_en ; 
                // mac_data_reg <= mac_data ; 
            // end

         if (eth_speed_reg2_macclk ==2'b11)     //sbalasun: temporary for 1G
             begin
               mac_err_reg[0]    <= mac_err[0];
               mac_en_reg[0]     <= mac_en[0];
               mac_data_reg[7:0] <= mac_data[7:0];   
             end
         else                                   //sbalasun: temporary for 2.5G
             begin
               mac_err_reg        <= mac_err;
               mac_en_reg         <= mac_en;   
               mac_data_reg[15:0] <= mac_data;   
             end	
                        
        end
        
end

alt_mge16_pcs_mii_rx_if_pcs U_MII_IF (
   .reset(mac_clk_reset),
   .rx_clk(mac_clk),
   .rx_clkena(mac_clkena),
   .clk_ena(clk_ena),
   .mii_rxd(mac_mii_data),
   .mii_rxdv(mac_mii_en),
   .mii_rxerr(mac_mii_err),
   .mii_rxd_o(mac_mii_data_o),
   .mii_rxdv_o(mac_mii_en_o),
   .mii_rxerr_o(mac_mii_err_o),
   .mii_alignment_status(mii_alignment_status));

assign ff_wren = !ff_afull & clk_ena & mac_clkena;

/* always@(posedge mac_clk_reset or posedge mac_clk)
begin
   if (mac_clk_reset==1'b1)
   begin
      ff_din <= 20'h0 ;
   end
   else
   begin
      if (mac_clkena == 1'b1) begin
         if (eth_speed_reg2_macclk==2'b10)	//sbalasun:temporary for 2.5g
         begin
            ff_din <= {mac_err_reg, mac_en_reg, mac_data_reg}; 
         end
         else if (eth_speed_reg2_macclk==2'b11)	//sbalasun:temporary for 1G
         begin
            ff_din <= {mac_err_reg[0], mac_en_reg[0], mac_data_reg[7:0]}; 
         end
         else
         begin
            ff_din <= {mac_mii_err_o, mac_mii_en_o, mac_mii_data_o};
         end
      end
   end 
end */

always@(posedge mac_clk_reset or posedge mac_clk)
begin
   if (mac_clk_reset==1'b1)
   begin
      ff_din <= 20'h0 ;
   end
   else
   begin
      if (mac_clkena == 1'b1) begin
        
          if (eth_speed_reg2_macclk==2'b11)	//sbalasun:temporary for 1G
         begin
            ff_din <= {mac_err_reg[0], mac_en_reg[0], mac_data_reg[7:0]}; 
         end
         else
         begin
            ff_din <= {mac_err_reg, mac_en_reg, mac_data_reg};
         end
      end
   end 
end 

always@(posedge mac_clk_reset or posedge mac_clk)
    begin
        if (mac_clk_reset==1'b1)
            begin
            reset_ff_wr  <= 1'b1 ;
            end
        else
            begin            
            reset_ff_wr  <= eth_speed_change_macclk|sw_reset_tx_mac_clk;
            end
    end

always@(posedge pcs_clk_reset or posedge pcs_clk)
    begin
        if (pcs_clk_reset==1'b1)
            begin
            reset_ff_rd  <= 1'b1 ;
            end
        else
            begin            
            reset_ff_rd  <= eth_speed_change_pcsclk|sw_reset_tx_phy_clk;
            end
    end // always@ (posedge pcs_clk_reset or posedge pcs_clk)

   // these latencies has 6-bit of fractional cycle
   wire [11:0] latency_adj_w;
   reg  [16:0] latency_adj_fifo;
   wire [11:0] latency_adj_device_const;
   wire [13:0] latency_adj_speed_const;
   wire [17:0] latency_adj_out;
   
generate if(DEVICE_FAMILY == "Arria V")
begin
   assign latency_adj_device_const = PHASE_CALC_ADJ_AV;
end else if(DEVICE_FAMILY == "Arria 10")
begin
   assign latency_adj_device_const = PHASE_CALC_ADJ_A10;   
end else if(DEVICE_FAMILY == "Stratix 10")
begin
   assign latency_adj_device_const = PHASE_CALC_ADJ_S10;   
end
endgenerate 


reg [11:0] latency_accum_xcvr;

generate if(DEVICE_FAMILY == "Stratix 10") 
begin

  // need to convert to 156 cycle --  latency_xcvr_tx = 
 
    wire [11:0] latency_accum_out;
	wire latency_accum_val; 
    // cross over to 125MHz domain
    alt_mge16_pcs_clock_crosser 
	#(.BITS_PER_SYMBOL(12))
    latency_pulse_delay_transfer (.in_clk(latency_sclk),
                                  .in_reset(latency_sclk_reset),
                                  .in_ready(),
                                  .in_valid(1'b1),
                                  .in_data(latency_xcvr_tx),
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
end 
else begin
    always @ (posedge mac_clk or posedge mac_clk_reset) begin
         if (mac_clk_reset) 
            latency_accum_xcvr <= {12{1'b0}};
         else      
            latency_accum_xcvr <= {12{1'b0}};     
     end
end
endgenerate 
   
   always @ (posedge mac_clk_reset or posedge mac_clk)
   begin
		if (mac_clk_reset)
		begin
			latency_adj_fifo <= 17'h0;
			latency_adj      <= 22'h0;
		end else begin
			latency_adj_fifo <= (eth_speed_reg2_macclk == 2'b10) ? {5'd0,latency_adj_w} :
                                (eth_speed_reg2_macclk == 2'b01) ? {5'd0,latency_adj_w} :
                                                                   {5'd0,latency_adj_w} ;
            // append 4-more-bit of fractional cycle (total 10-bit)
            latency_adj <= {latency_adj_out, 4'd0};
		end
	end
   
   assign latency_adj_speed_const = (eth_speed_reg2_macclk == 2'b10) ? INTERNAL_LATENCY_1000 :
                                    (eth_speed_reg2_macclk == 2'b01) ? (mii_alignment_status ? INTERNAL_LATENCY_100_ALIGN_1 : INTERNAL_LATENCY_100_ALIGN_0) :
                                    (mii_alignment_status ? INTERNAL_LATENCY_10_ALIGN_1 : INTERNAL_LATENCY_10_ALIGN_0);

   assign latency_adj_out = (ENABLE_PHASE_CALC==0)?
                        latency_adj_device_const :
                        (latency_accum_xcvr + latency_adj_fifo + {6'd1,6'd0} + latency_adj_device_const + latency_adj_speed_const); //add 1 cycle because there is 1 more latency in FIFO
   
generate if (ENABLE_ECC == 1)
begin
   // U_DSW with ECC protection
   alt_mge16_pcs_ecc_enc_x10_wrapper U_ECC_ENC_DSW
   (
      .data (ff_din),
      .q (ff_din_ecc)
   );

   alt_mge16_pcs_ecc_dec_x10 U_ECC_DEC_DSW
   (
      .data(ff_dout_ecc),
      .q(ff_dout),
      .err_corrected(err_corrected_dsw),
      .err_detected(err_detected_dsw),
      .err_fatal(err_fatal_dsw)
   );

   always @(posedge pcs_clk or posedge reset_ff_rd)
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

   // ADDR_WIDTH tied to ae_threshold/af_threshold data width
   // latency_adj_w data width must be at least ADDR_WIDTH + 6 (fractional).
   alt_mge16_pcs_a_fifo_24 #(.FF_WIDTH(15),
                          .ADDR_WIDTH(4),
                          .DEPTH(16),
                          .SAMPLE_SIZE(SAMPLE_SIZE))
      U_DSW (
             .reset_wclk(reset_ff_wr),
             .reset_rclk(reset_ff_rd),
             .wclk(mac_clk),
             .wclk_ena(mac_clkena),
             .wren(ff_wren),
             .din(ff_din_ecc),
             .rclk(pcs_clk),
             .rclk_ena(1'b1),
             .rden(ff_rden),
             .dout(ff_dout_ecc),
             .afull(ff_afull),
             .aempty(ff_aempty),
             .af_threshold(4'd3),
             .ae_threshold(4'd3),
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
   alt_mge16_pcs_a_fifo_24 #(.FF_WIDTH(20),
                          .ADDR_WIDTH(4),
                          .DEPTH(16),
                          .SAMPLE_SIZE(SAMPLE_SIZE))
      U_DSW (
             .reset_wclk(reset_ff_wr),
             .reset_rclk(reset_ff_rd),
             .wclk(mac_clk),
             .wclk_ena(mac_clkena),
             .wren(ff_wren),
             .din(ff_din),
             .rclk(pcs_clk),
             .rclk_ena(1'b1),
             .rden(ff_rden),
             .dout(ff_dout),
             .afull(ff_afull),
             .aempty(ff_aempty),
             .af_threshold(4'd3),
             .ae_threshold(4'd3),
             .calc_clk(calc_clk),
             .reset_calc_clk(reset_calc_clk),
             .clk_125(mac_clk),
             .reset_clk_125(mac_clk_reset),
             .latadj(latency_adj_w));

   assign ff_din_ecc = 15'b0;
   assign ff_dout_ecc = 15'b0;
   assign err_detected_dsw = 1'b0;
   assign err_fatal_dsw = 1'b0;
   assign err_corrected_dsw = 1'b0;
   assign eccstatus = 2'b0;

end
endgenerate

generate if (ENABLE_ECC == 1)
begin

   always @(posedge pcs_clk or posedge reset_ff_rd)
   begin
      if (reset_ff_rd)
      begin
         eccstatus_txcv <= 2'b0;
      end
      else
      begin
         if (ff_rden)
         begin
            eccstatus_txcv <= eccstatus_dsw;
         end
         else
         begin
            eccstatus_txcv <= 2'b0;
         end
      end
   end
	
   assign eccstatus = eccstatus_txcv;

end
endgenerate

wire [15:0] pcs_data_sgmii;
wire [1:0] pcs_en_sgmii;
wire [1:0] pcs_err_sgmii;
wire [15:0] pcs_data_gige;
wire [1:0] pcs_en_gige;
wire [1:0] pcs_err_gige;

alt_mge16_pcs_tx_converter U_TXCV (
          .reset(reset_ff_rd),
          .sw_reset(sw_reset_tx_phy_clk),
          .clk(pcs_clk),
          .eth_speed(eth_speed_reg2_pcsclk),
          .ff_rden(ff_rden),
          .ff_aempty(ff_aempty),
          .ff_data(ff_dout),
          .pcs_data(pcs_data_gige),
          .pcs_en(pcs_en_gige),
          .pcs_err(pcs_err_gige));

//////ED

assign   pcs_data =   (eth_speed_reg2_macclk[1]) ? pcs_data_gige : pcs_data_sgmii;
assign   pcs_en =     (eth_speed_reg2_macclk[1]) ? pcs_en_gige : pcs_en_sgmii;
assign   pcs_err =    (eth_speed_reg2_macclk[1]) ? pcs_err_gige : pcs_err_sgmii;

alt_mge16_pcs_sgmii_16_to_8_converter U_TXSGMIICV (
          .reset(reset_ff_rd),
          .clk(pcs_clk),
		  .tx_ena (mac_clkena),
		  .pcs_data_out(pcs_data_sgmii),
          .pcs_en_out(pcs_en_sgmii),
          .pcs_err_out(pcs_err_sgmii),
          .pcs_data_in(pcs_data_gige),
          .pcs_en_in(pcs_en_gige),
          .pcs_err_in(pcs_err_gige));




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
  begin: process_8B
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


endmodule // module top_tx_converter

