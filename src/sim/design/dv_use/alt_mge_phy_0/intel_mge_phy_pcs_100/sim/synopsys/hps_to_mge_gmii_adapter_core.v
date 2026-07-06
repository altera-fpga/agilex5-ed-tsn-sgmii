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


module hps_to_mge_gmii_adapter_core (
    input               clk,                // peri_clock
    input               rst_n,              // peri_reset
                        
    input               addr,               // avalon_slave
    input               read,               // avalon_slave
    input               write,              // avalon_slave
    input [31:0]        writedata,          // avalon_slave
    output [31:0]       readdata,           // avalon_slave

    input               mac_tx_clk_o,       // hps_gmii
    output              mac_tx_clk_i,       // hps_gmii
    output              mac_rx_clk,         // hps_gmii
    input               mac_rst_tx_n,       // hps_gmii
    input               mac_rst_rx_n,       // hps_gmii
    input [7:0]         mac_txd,            // hps_gmii
    input               mac_txen,           // hps_gmii
    input               mac_txer,           // hps_gmii
    output              mac_rxdv,           // hps_gmii
    output              mac_rxer,           // hps_gmii
    output [7:0]        mac_rxd,            // hps_gmii
    output              mac_col,            // hps_gmii
    output              mac_crs,            // hps_gmii
    input [1:0]         mac_speed,          // hps_gmii


    input               pll_125m_clk,       // pll_125m_clk
    input               pll_25m_clk,        // pll_25m_clock
    input               pll_2_5m_clk,       // pll_2_5m_clock
    input               pll_locked,         // pll_locked

    input               phy_rx_clkout,      // multirate phy gmii
    input               phy_rx_clkena,      // multirate phy gmii
    input               phy_tx_clkout,      // multirate phy gmii
    input               phy_tx_clkena,      // multirate phy gmii
    input  [2:0]        phy_speed,    // multirate phy gmii
	 
    output [15:0]       gmii16b_tx_d,       // multirate phy gmii
    output [1:0]        gmii16b_tx_en,      // multirate phy gmii
    output [1:0]        gmii16b_tx_err,      // multirate phy gmii
    input [15:0]        gmii16b_rx_d,       // multirate phy gmii
    input [1:0]         gmii16b_rx_dv,      // multirate phy gmii
	 input                tx_disable,
	 output [6:0]          adapter_status ,
    output              pll_locked_stable,
    input [1:0]         gmii16b_rx_err       // multirate phy gmii

);

// Local Registers
wire           local_rst_n;
wire           rstn_sync_pll_125;
wire           rstn_sync_pll_25;
wire           rstn_sync_pll_2_5;
wire           tx_sync_wr_rstn;
wire           tx_sync_rd_rstn;
wire           rx_sync_wr_rstn;
wire           rx_sync_rd_rstn;
wire           speed_sel_tx;
wire           speed_sel_rx;
//wire           tx_disable;

wire           buf_tx_clk;
wire           buf_rx_clk;
wire           clk_rx_mux_rstn;

wire  [19:0]   tx_pack_wr_data;
wire           tx_pack_wr_en;
wire  [19:0]   txbuffer_rd_data;
wire           txbuf_overflow;
wire           txbuf_underflow;

wire  [19:0]   rx_pack_wr_data;
wire           rx_buf_rd_en;
wire  [19:0]   rxbuffer_rd_data;

reg   [7:0]    mac_txd_d;
reg            mac_txen_d;
reg            mac_txer_d;
reg   [1:0]    mac_speed_int;
reg   [2:0]    phy_speed_int;
reg            speed_match;
reg            missalign;

assign pll_locked_stable = pll_locked & clk_rx_mux_rstn ;

function integer clog2;
   input [31:0] value;  // Input variable
   for (clog2=0; value>0; clog2=clog2+1) 
   value = value>>'d1;
endfunction

localparam TX_BUFFER_DEPTH  = 16;
localparam TX_BUFFER_ASIZE  = clog2(TX_BUFFER_DEPTH - 1);
localparam RX_BUFFER_DEPTH  = 16;
localparam RX_BUFFER_ASIZE  = clog2(RX_BUFFER_DEPTH - 1);


always @(posedge mac_tx_clk_o) begin
   mac_speed_int <= mac_speed;
   phy_speed_int <= phy_speed;
   
   if ((mac_speed_int[1] == 1'b0 && phy_speed_int[2:0] == 3'b001) ||
	     (mac_speed_int[1] == 1'b0 && phy_speed_int[2:0] == 3'b100) ||
         (mac_speed_int[1:0] == 2'b11 && phy_speed_int[2:0] == 3'b010) ||
         (mac_speed_int[1:0] == 2'b10 && phy_speed_int[2:0] == 3'b011)) 
      speed_match <= 1'b1;
   else
      speed_match <= 1'b0; 
      
end

always @(posedge mac_tx_clk_o or negedge tx_sync_wr_rstn) begin
   if (tx_sync_wr_rstn == 1'b0)
      missalign   <= 1'b0;
   else if (tx_disable == 1'b1)
      missalign   <= 1'b0;
   else if ( (mac_txd_d != 8'b0 || mac_txer_d != 1'b0) && mac_txen_d == 1'b0)
      missalign   <= 1'b1;
end
// mac_speed encoding: 
// 2'b0X 1000 Mbps (GMII)
// 2'b11 100 Mbps (MII)
// 2'b10 10 Mbps (MII)
assign speed_sel_tx = mac_speed_int[1];

// phy_speed encoding: 
// 3'b001 1000 Mbps (GMII)
// 3'b010 100 Mbps (MII)
// 3'b011 10 Mbps (MII)
assign speed_sel_rx = (phy_speed_int[2]== 1'b0) ? phy_speed_int[1] : 1'b0;

assign mac_col = 1'b0;
assign mac_crs = 1'b0;

//hps_mge_csr u_csr (
//    // inputs
//    .clk             (clk),
//    .rst_n           (rst_n),
//    .addr            (addr),
//    .read            (read),
//    .write           (write),
//    .writedata       (writedata),
//    .txbuf_overflow    (txbuf_overflow),
//    .txbuf_underflow   (txbuf_underflow),
//    .pll_locked      (pll_locked),
//    .isreset_tx      (~tx_sync_wr_rstn),
//    .isreset_rx      (~rx_sync_wr_rstn),
//    .speed_match     (speed_match),
//    .missalign       (missalign),
//    // outputs
//    .readdata        (readdata),
//    .tx_disable      (tx_disable)
//
//);
assign adapter_status = {missalign, speed_match, ~rx_sync_wr_rstn, ~tx_sync_wr_rstn, pll_locked, txbuf_underflow, txbuf_overflow} ;
assign local_rst_n = ~tx_disable & pll_locked;

hps_mge_reset_synchronizer u_mac_tx_clk_o_rst_sync (
   .clk        (mac_tx_clk_o),
   .rst_n      (local_rst_n  & mac_rst_tx_n & speed_match),
   .rst_sync_n (tx_sync_wr_rstn)
);

hps_mge_reset_synchronizer u_clk125_rst_sync (
   .clk        (pll_125m_clk),
   .rst_n      (pll_locked),
   .rst_sync_n (rstn_sync_pll_125)
);

hps_mge_reset_synchronizer u_clk25_rst_sync (
   .clk        (pll_25m_clk),
   .rst_n      (pll_locked),
   .rst_sync_n (rstn_sync_pll_25)
);

hps_mge_reset_synchronizer u_clk2_5_rst_sync (
   .clk        (pll_2_5m_clk),
   .rst_n      (pll_locked),
   .rst_sync_n (rstn_sync_pll_2_5)
);

// -----------------------------
//          TX
// -----------------------------
hps_to_mge_clk_mux_macspeed u_clk_tx_mux(
   .clk_in1    (pll_125m_clk),  //input       
   .rstn_clk1  (rstn_sync_pll_125),  //input       
   .clk_in2    (pll_25m_clk),  //input       
   .rstn_clk2  (rstn_sync_pll_25),  //input       
   .clk_in3    (pll_2_5m_clk),  //input       
   .rstn_clk3  (rstn_sync_pll_2_5),  //input       
   .sel        (mac_speed_int),  //input [1:0]   
   .rstn_out   (),   //output      //  async from clk_out
   .clk_out    (buf_tx_clk)   //output      

);

assign mac_tx_clk_i = buf_tx_clk;

hps_mge_reset_synchronizer u_rd_tx_rst (
   .clk        (phy_tx_clkout),
   .rst_n      (tx_sync_wr_rstn),
   .rst_sync_n (tx_sync_rd_rstn)
);

always @(posedge mac_tx_clk_o) begin
   mac_txd_d      <= mac_txd;
   mac_txen_d     <= mac_txen;
   mac_txer_d     <= mac_txer;
end

//{{mac_txer, mac_txen, mac_txd[7:0]}{mac_txer, mac_txen, mac_txd[7:0]}}
hps_mge_data_packer u_tx_data_packer (
   .tx_clk         (mac_tx_clk_o),
   .rst_n          (tx_sync_wr_rstn),
   .mac_txd        (mac_txd_d),
   .mac_txen       (mac_txen_d),
   .mac_txer       (mac_txer_d),
   .sel            (speed_sel_tx),
   .wr_data_pack   (tx_pack_wr_data),
   .wr_en_pack     (tx_pack_wr_en)
);

hps_mge_elasticbuffer #(
   .BUFFER_DEPTH    (TX_BUFFER_DEPTH),
   .BUFFER_ASIZE    (TX_BUFFER_ASIZE)
) u_txbuffer (
   .wr_clk     (mac_tx_clk_o),
   .wr_en      (tx_pack_wr_en),
   .wr_rst_n   (tx_sync_wr_rstn),
   .wr_data    (tx_pack_wr_data),
   .rd_clk     (phy_tx_clkout),
   .rd_en      (phy_tx_clkena),
   .rd_rst_n   (tx_sync_rd_rstn),
   .rd_data    (txbuffer_rd_data),
   .err_overflow    (txbuf_overflow),
   .err_underflow   (txbuf_underflow)
);

assign gmii16b_tx_d  = txbuffer_rd_data[15:0];
assign gmii16b_tx_en = txbuffer_rd_data[17:16];
assign gmii16b_tx_err = txbuffer_rd_data[19:18];


// -----------------------------
//          RX
// -----------------------------
hps_to_mge_clk_mux_physpeed u_clk_rx_mux(
   .clk_in1    (pll_125m_clk),  //input       
   .rstn_clk1  (rstn_sync_pll_125),  //input       
   .clk_in2    (pll_25m_clk),  //input       
   .rstn_clk2  (rstn_sync_pll_25),  //input       
   .clk_in3    (pll_2_5m_clk),  //input       
   .rstn_clk3  (rstn_sync_pll_2_5),  //input       
   .sel        (phy_speed_int),  //input [1:0]   
   .rstn_out   (clk_rx_mux_rstn),   //output      //  async from clk_out
   .clk_out    (buf_rx_clk)   //output      

);
assign mac_rx_clk = buf_rx_clk;

hps_mge_reset_synchronizer u_rd_rx_rst (
   .clk        (buf_rx_clk),
   .rst_n      (clk_rx_mux_rstn & mac_rst_rx_n & pll_locked),
   .rst_sync_n (rx_sync_rd_rstn)
);

hps_mge_reset_synchronizer u_wr_rx_rst (
   .clk        (phy_rx_clkout),
   .rst_n      (rx_sync_rd_rstn),
   .rst_sync_n (rx_sync_wr_rstn)
);

hps_mge_elasticbuffer #(
   .BUFFER_DEPTH    (RX_BUFFER_DEPTH),
   .BUFFER_ASIZE    (RX_BUFFER_ASIZE)
) u_rxbuffer (
   .wr_clk     (phy_rx_clkout),
   .wr_en      (phy_rx_clkena),
   .wr_rst_n   (rx_sync_wr_rstn),
   .wr_data    (rx_pack_wr_data),
   .rd_clk     (buf_rx_clk),
   .rd_en      (rx_buf_rd_en),
   .rd_rst_n   (rx_sync_rd_rstn),
   .rd_data    (rxbuffer_rd_data),
   .err_overflow    (),
   .err_underflow   ()
);

hps_mge_data_unpacker u_rx_data_unpacker(
    .rx_clk       (buf_rx_clk),
    .rst_n        (rx_sync_rd_rstn),
    .rd_data_pack (rxbuffer_rd_data),
    .sel          (speed_sel_rx),
    .rx_buf_rd_en (rx_buf_rd_en),
    .mac_rxd      (mac_rxd),
	 .mac_rxdv     (mac_rxdv),
    .mac_rxer     (mac_rxer)
);

assign rx_pack_wr_data  = {gmii16b_rx_err,gmii16b_rx_dv,gmii16b_rx_d};

endmodule
