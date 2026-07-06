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


`timescale 1ps/1ps

module ftile_efifo_wrapper_top #(
    parameter           ENABLE_TIMESTAMPING = 0
) (
    // clock and reset
    input               i_tx_fifo_wclk,        
    input               i_rx_fifo_wclk,        
    input               i_tx_fifo_rclk,        
    input               i_rx_fifo_rclk,        
    input               i_tx_fifo_rst_n_async,
    input               i_rx_fifo_rst_n_async,
  // 2X TBI data
    input   [19:0]      i_tx_2xtbi_datain,
    input               i_tx_dl_sync_pulse,
    // 4X TBI FIFO data out 
    output              o_tx_fifo_full,
    output              o_tx_fifo_rdempty,
    output [39:0]       o_tx_4xtbi_data,
    output              o_tx_4xtbi_wrdata_valid,
    output [ 1:0]       o_tx_dl_sync_pulse,
    // RX hard 80-bit interface
    input               i_rx_fifo_rd_en,
    input               i_rx_4xtbi_rd_data_valid,
    input   [39:0]      i_rx_4xtbi_data,
    input   [ 1:0]      i_rx_dl_sync_pulse,
    output  [19:0]      o_rx_2xtbi_dataout,
    output              o_rx_dl_sync_pulse,
    output              o_rx_fifo_rd_pempty
        
   
  
);

/********************************************************************
 * Parameters                                                       *
 ********************************************************************/
localparam RX_EFIFO_DEPTH = 32;
localparam TX_EFIFO_WIDTH = ENABLE_TIMESTAMPING ? 60 : 40;
localparam RX_EFIFO_WIDTH = ENABLE_TIMESTAMPING ? 42 : 40;

/********************************************************************
 * Wires and registers                                              *
 ********************************************************************/
wire [($clog2(RX_EFIFO_DEPTH)-1):0] RX_R_PFULL_PORT, RX_R_PEMPTY_PORT;
wire            wr_en_toggled;
wire [39:0]     wr_data_toggled;
wire            rd_en_toggled;
wire [39:0]     rx_soft_fifo_rd_data;
reg             por_cnt_done;

wire [TX_EFIFO_WIDTH-1:0]   wr_data_toggled_tx_efifo_in;
wire [TX_EFIFO_WIDTH-1:0]   tx_4xtbi_data_tx_efifo_out;
wire [ 1:0]                 tx_sync_pulse;

wire [RX_EFIFO_WIDTH-1:0]   rx_4xtbi_data_rx_efifo_in;
wire [RX_EFIFO_WIDTH-1:0]   rx_soft_fifo_rd_data_rx_efifo_out;
wire [ 1:0]                 rx_soft_fifo_rd_sync_pulse_rx_efifo_out;

assign wr_data_toggled_tx_efifo_in = ENABLE_TIMESTAMPING ? {{18{1'b0}}, tx_sync_pulse[1], tx_sync_pulse[0], wr_data_toggled} : wr_data_toggled;
assign o_tx_4xtbi_data             = ENABLE_TIMESTAMPING ? tx_4xtbi_data_tx_efifo_out[39:0]: tx_4xtbi_data_tx_efifo_out;
assign o_tx_dl_sync_pulse          = ENABLE_TIMESTAMPING ? {tx_4xtbi_data_tx_efifo_out[41], tx_4xtbi_data_tx_efifo_out[40]} : 2'b00;
assign rx_4xtbi_data_rx_efifo_in   = ENABLE_TIMESTAMPING ? {i_rx_dl_sync_pulse, i_rx_4xtbi_data} : i_rx_4xtbi_data;
assign rx_soft_fifo_rd_sync_pulse_rx_efifo_out = ENABLE_TIMESTAMPING ? rx_soft_fifo_rd_data_rx_efifo_out[41:40] : 2'b00;

/********************************************************************
 * TX and RX eFIFO                                                   *
 ********************************************************************/

    tse_ftile_efifo_wr_en_toggle #(
        .ENABLE_TIMESTAMPING        (ENABLE_TIMESTAMPING)
    ) tse_ftile_efifo_wr_en_toggle_0 (
        .clk                        (i_tx_fifo_wclk),
        .rst_n                      (i_tx_fifo_rst_n_async),
        .wr_en                      (1'b1),
        .data_in                    (i_tx_2xtbi_datain),
        .sync_pulse_in              (i_tx_dl_sync_pulse),
        .wr_en_toggled              (wr_en_toggled),
        .data_out                   (wr_data_toggled),
        .sync_pulse_out             (tx_sync_pulse)
    );


    ftile_efifo_ccc # (
        .WIDTH       (TX_EFIFO_WIDTH),
        .ADDR_WIDTH  (5),
        .SYNC_STAGES (3),
        `ifdef DEBUG_EFIFO  // only show in sim
        .DISABLE_WUSED (0), // for debug, to see fill level in binary
        .DISABLE_RUSED (0), // for debug, to see fill level in binary
        `endif
        .DISABLE_RAM (0)
    ) tx_efifo (
        .aclr   (~(i_tx_fifo_rst_n_async)),    
        .wclk   (i_tx_fifo_wclk),
        .wdata  (wr_data_toggled_tx_efifo_in),
        .wreq   (wr_en_toggled),
        .wfull  (o_tx_fifo_full),
        .rclk   (i_tx_fifo_rclk),
        .rdata  (tx_4xtbi_data_tx_efifo_out),
        .rreq   (1'b1),
        .rempty (o_tx_fifo_rdempty),
        .data_valid (o_tx_4xtbi_wrdata_valid)
    );

// ------------------------------------------------------------------
// RX eFIFO
// --------------------------------------------------------------------------------------------------------------------------------------------

assign RX_R_PFULL_PORT = 5'd27;
assign RX_R_PEMPTY_PORT = 5'd6;

always @ (posedge i_rx_fifo_rclk or negedge i_rx_fifo_rst_n_async) begin
    if (~i_rx_fifo_rst_n_async) begin
        por_cnt_done <= 1'b0;
    end else begin
        por_cnt_done <= por_cnt_done | ~o_rx_fifo_rd_pempty;
    end
end

tse_ftile_efifo_rd_en_toggle #(
    .ENABLE_TIMESTAMPING        (ENABLE_TIMESTAMPING)
) tse_ftile_efifo_rd_en_toggle_0 (
    .clk                        (i_rx_fifo_rclk),
    .rst_n                      (i_rx_fifo_rst_n_async),
    .rd_en                      (por_cnt_done),
    .data_in                    (rx_soft_fifo_rd_data_rx_efifo_out[39:0]),
    .sync_pulse_in              (rx_soft_fifo_rd_sync_pulse_rx_efifo_out),
    .rd_en_toggled              (rd_en_toggled),
    .data_out                   (o_rx_2xtbi_dataout),
    .sync_pulse_out             (o_rx_dl_sync_pulse)
);

ftile_efifo_async_fifo # (
    .DWIDTH                     (RX_EFIFO_WIDTH),
    .AWIDTH                     ($clog2(RX_EFIFO_DEPTH)),
    .SYNCSTAGE                  (3)
) rx_efifo (
    .wr_rst_n                   (i_rx_fifo_rst_n_async),
    .wr_clk                     (i_rx_fifo_wclk),
    .wr_en                      (i_rx_4xtbi_rd_data_valid),
    .wr_data                    (rx_4xtbi_data_rx_efifo_in),
    .rd_rst_n                   (i_rx_fifo_rst_n_async),
    .rd_clk                     (i_rx_fifo_rclk),
    .rd_en                      (rd_en_toggled),
    .r_pempty                   (RX_R_PEMPTY_PORT),
    .r_pfull                    (RX_R_PFULL_PORT),
    .r_empty                    (5'd0),
    .r_full                     (5'd31),
    .rd_data                    (rx_soft_fifo_rd_data_rx_efifo_out),
    .rd_numdata                 (),
    .wr_numdata                 (),
    .wr_full                    (),
    .wr_pfull                   (),
    .wr_empty                   (),
    .wr_pempty                  (),
    .rd_empty                   (),
    .rd_pempty                  (o_rx_fifo_rd_pempty),
    .rd_full                    (),
    .rd_pfull                   ()
);

/* always @ (posedge i_rx_fifo_wclk or negedge i_rx_fifo_rst_n_async) begin
    if (~i_rx_soft_fifo_rst_n_async) begin
        por_cnt_done <= 1'b0;
    end else begin
        por_cnt_done <= por_cnt_done | ~rd_pempty;
    end
end
 */
endmodule

