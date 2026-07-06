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


`timescale 1 ps / 1 ps

module alt_mge_phy_usxg32_tx_clockcomp_fifo #(
    parameter FAWIDTH           = 5,
    parameter TSWIDTH           = 16,
    parameter IDWIDTH           = 32,
    parameter TX_DWIDTH         = 64,
    parameter TX_CWIDTH         = 8,
    parameter DEVICE_FAMILY     = "Arria V",
    parameter ENABLE_IEEE1588   = 0,
    parameter OFFSET            = 16'h29D6
) (
    input  wire                 tx_xgmii_clk,
    input  wire                 tx_pma_clk,
    
    input  wire                 tx_xgmii_rst_n,
    input  wire                 tx_pma_rst_n,
    
    input  wire                 tx_xgmii_valid_in,
    input  wire [TX_CWIDTH-1:0] tx_xgmii_control_in,
    input  wire [TX_DWIDTH-1:0] tx_xgmii_data_in,
    
    output wire                 tx_xgmii_valid_out,
    output wire [TX_CWIDTH-1:0] tx_xgmii_control_out,
    output wire [TX_DWIDTH-1:0] tx_xgmii_data_out,
    // ED
    //output wire [TSWIDTH-1:0]   latency_adj,     // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
	input  wire                 latency_sclk,
	input  wire                 latency_sclk_reset,
	input  wire [11:0]          latency_xcvr_tx,
    
    output wire [TSWIDTH-1:0]   tx_latency_adj,
    
    input  wire                 tx_xgmii_dl_sync_pulse_in,      // Agilex USXGMII 1588 PTP sync pulse from DET_LAT latency measurement module
    output wire                 tx_xgmii_dl_sync_pulse_out      // Agilex USXGMII 1588 PTP sync pulse output to eth_f NPHY
);

    // Parameter for Agilex USXGMII 1588 TX sync pulse width
    localparam DL_SYNC_PULSE_WIDTH = ((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588) ? 1'b1 : 1'b0;

    wire                rd_pempty;
    wire                wr_full;

    wire                fifo_wr_en;
    // ED
    wire [FAWIDTH-1:0]  rd_numdata;

    wire [6:0]          gb_idwidth; // Gearbox Input Width
    wire [6:0]          gb_odwidth; // Gearbox Output Width

    wire                gap_cnt_en;
    reg                 first_read;
    reg                 rd_val;
    reg  [31:0]         sel_cnt_r;
    wire [6:0]          sel_cnt;
    reg  [2:0]          gap_cnt;
    wire [7:0]          m_selcnt;
    
    wire                tx_xgmii_dl_sync_pulse;
    
    // Add 1 bit of width for Agilex USXGMII 1588 TX sync pulse
    wire [TX_CWIDTH + TX_DWIDTH + DL_SYNC_PULSE_WIDTH-1:0] wr_data;
    wire [TX_CWIDTH + TX_DWIDTH + DL_SYNC_PULSE_WIDTH-1:0] rd_data;
    
    generate if((DEVICE_FAMILY=="Agilex") && ENABLE_IEEE1588)
    begin: TXCCFIFO_SYNC_PULSE
        assign wr_data = {tx_xgmii_dl_sync_pulse_in, tx_xgmii_control_in, tx_xgmii_data_in};
        assign {tx_xgmii_dl_sync_pulse, tx_xgmii_control_out, tx_xgmii_data_out} = rd_data;
    end
    else
    begin
        assign wr_data = {tx_xgmii_control_in, tx_xgmii_data_in};
        assign {tx_xgmii_dl_sync_pulse, tx_xgmii_control_out, tx_xgmii_data_out} = {1'b0, rd_data};
    end
    endgenerate
    
    //assign tx_latency_adj = 16'h0;

    // Delay match with read latency of dcfifo
    // To ensure no invalid data transfer to HSSI
    assign tx_xgmii_valid_out = rd_val;
    assign fifo_wr_en = (tx_xgmii_valid_in && !(wr_full));
    
    // To ensure sync pulse output when read operation is valid
    assign tx_xgmii_dl_sync_pulse_out  = tx_xgmii_valid_out && tx_xgmii_dl_sync_pulse;

    alt_mge_phy_async_fifo_fpga #(
        .DWIDTH        (TX_CWIDTH + TX_DWIDTH + DL_SYNC_PULSE_WIDTH),  // FIFO Input data width
        .AWIDTH        (FAWIDTH),           // FIFO Depth (address width) 
        .SYNCSTAGE     (5),                 // Metastable hardening stages, internally minus 3 in dcfifo
        .RESET_LF      (0)                  // Output Local Faults
    ) async_fifo (
        // Write
        .wr_clk         (tx_xgmii_clk),     // Write Domain Clock
        .wr_rst_n       (tx_xgmii_rst_n),   // Write Domain Active low Reset
        .wr_srst_n      (1'b1),             // Write Domain Active low Reset Synchronous
        
        .wr_en          (fifo_wr_en),       // Write Data Enable
        .wr_data        (wr_data),          // Write Data In
        
        // Read
        .rd_clk         (tx_pma_clk),       // Read Domain Clock
        .rd_rst_n       (tx_pma_rst_n),     // Read Domain Active low Reset
        .rd_srst_n      (1'b1),             // Read Domain Active low Reset Synchronous
        
        .rd_en          (rd_val),           // Read Data Enable
        .rd_data        (rd_data),          // Read Data Out
        .rd_data_next   (),                 // Read Data Out
        
        // Threshold
        .r_pempty       (5'd2),             // FIFO partially empty threshold
        .r_pfull        (5'd23),            // FIFO partially full threshold
        .r_empty        (5'd0),             // FIFO empty threshold
        .r_full         (5'd31),            // FIFO full threshold
        
        // Fill Level
        .rd_numdata     (rd_numdata),       // Number of Data available in Read clock
        .wr_numdata     (),                 // Number of Data available in Write clock
        
        // Full & empty Status
        .wr_empty       (),                 // FIFO Empty
        .wr_pempty      (),                 // FIFO Partial Empty
        .wr_full        (wr_full),          // FIFO Full
        .wr_pfull       (),                 // FIFO Parial Full
        .rd_empty       (),                 // FIFO Empty
        .rd_pempty      (rd_pempty),        // FIFO Partial Empty
        .rd_full        (),                 // FIFO Full
        .rd_pfull       ()                  // FIFO Partial Full
    );

    alt_mge_phy_usxgmii_1588_latency #(
        .TX_RX          (0),                 // 0: TX FIFO (without ppm correction)
        .OFFSET         (OFFSET),            // TX PCS Offset temp put 0 
        .NUMDATA_WIDTH  (5),                 // the greater number out of FAWIDTH in TX & RX
        .IDWIDTH        (IDWIDTH),           // RX only - ppm correction (Gearbox Input Data Width)
        .DEVICE_FAMILY  (DEVICE_FAMILY)
    ) alt_mge_phy_usxgmii_1588_latency (
        .sample_clk     (tx_pma_clk),
        .sample_rst_n   (tx_pma_rst_n),
        .wr_clk         (1'b0),
        .wr_rst_n       (1'b0),
        .clk            (tx_xgmii_clk),
        .rst_n          (tx_xgmii_rst_n),
        .numdata        (rd_numdata),
        .octet_del_num  (4'b0000),          // RX only - rate match latency adjustment
        //.wr_del_sm      (2'b00),            // RX only - rate match latency adjustment
        .octet_ins_num  (4'b0000),          // RX only - rate match latency adjustment
        .octet_del_en   (1'b0),             // RX only - rate match latency adjustment
        .octet_ins_en   (1'b0),             // RX only - rate match latency adjustment
        .sample_clk_data_valid  (1'b0),     // RX only - ppm correction (pma_clk data_valid) unused for tx
        .clk_block_lock (1'b0),             // RX only - ppm correction (mac_clk block_lock/rx_data_ready)
        //ED
        .speed_mode     (3'b000),
        .rdclk_data_valid_out   (1'b1),     // valid toggle for <10G speed..
        .latency_sclk   (latency_sclk),
        .latency_sclk_reset     (latency_sclk_reset),
        .latency_xcvr   (latency_xcvr_tx),
        .latency_adj    (tx_latency_adj)
    );

    assign gb_idwidth = 7'd66;
    assign gb_odwidth = 7'd32;
    assign gap_cnt_en = ~first_read;
    assign sel_cnt = sel_cnt_r[6:0];
    assign m_selcnt = (gb_idwidth + sel_cnt);

    always @(negedge tx_pma_rst_n or posedge tx_pma_clk) begin
        if (tx_pma_rst_n == 1'b0) begin
            first_read <= 1'b1;
        end
        else if (~rd_pempty && first_read) begin
            first_read <= 1'b0;
        end
    end

    always @(negedge tx_pma_rst_n or posedge tx_pma_clk) begin
        if (tx_pma_rst_n == 1'b0) begin
            rd_val      <= 1'b0;
            sel_cnt_r   <= 'd0;
            gap_cnt     <= 'd0;
        end
        else begin
            rd_val  <= ~gap_cnt_en ? 1'b0 :
                       (gap_cnt == 'd0) ? 1'b1
                       : 1'b0;
            
            if (gap_cnt_en) begin
                if (gap_cnt == 'd0) begin 
                    // calculate next MUX selection
                    if (m_selcnt >= gb_odwidth * 'd5) begin
                        sel_cnt_r <= (m_selcnt-gb_odwidth * 'd5);
                        gap_cnt <= 'd4;
                    end
                    else if (m_selcnt >= gb_odwidth * 'd4) begin
                        sel_cnt_r <= (m_selcnt-gb_odwidth * 'd4);
                        gap_cnt <= 'd3;
                    end
                    else if (m_selcnt >= gb_odwidth * 'd3) begin
                        sel_cnt_r <= (m_selcnt-gb_odwidth * 'd3);
                        gap_cnt <= 'd2;
                    end
                    else if (m_selcnt >= gb_odwidth * 'd2) begin
                        sel_cnt_r <= (m_selcnt-gb_odwidth * 'd2);
                        gap_cnt <= 'd1;
                    end
                    else begin 
                        sel_cnt_r <= (m_selcnt-gb_odwidth);
                        gap_cnt <= 'd0;
                    end
                end
                else begin
                    gap_cnt <= gap_cnt-1'b1;
                end
            end
        end
    end

endmodule
