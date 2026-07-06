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

module alt_mge_phy_usxg32_rx_top #(
    parameter XGMII_32_DWIDTH   = 32,
    parameter XGMII_32_CWIDTH   = 4,
    parameter XGMII_64_DWIDTH   = 64,
    parameter XGMII_64_CWIDTH   = 8,
    parameter DEVICE_FAMILY     = "Arria V",
    parameter TSWIDTH           = 16,
    parameter IDWIDTH           = 40,
    parameter RX_OFFSET         = 16'h29D6,
    parameter ENABLE_IEEE1588   = 0,
    parameter FF_ADDR_WIDTH     = 5    // FIFO Depth (address width) 
) (
    input  wire                         rx_xgmii_clk,
    input  wire                         rx_pma_clk,
    input  wire                         rx_rec_div33_clk,
    input  wire                         rx_fm_ff_sample_clk,
    
    input  wire                         rx_xgmii_rst_n,
    input  wire                         rx_pma_rst_n,
    input  wire                         rx_rec_div33_clk_rst_n,
    input  wire                         rx_fm_ff_sample_clk_rst_n,
    
    input  wire                         rx_xgmii_64_valid_in,
    input  wire [XGMII_64_CWIDTH-1:0]   rx_xgmii_64_control_in,
    input  wire [XGMII_64_DWIDTH-1:0]   rx_xgmii_64_data_in,
    
    output wire                         rx_xgmii_32_valid_out,
    output wire [XGMII_32_CWIDTH-1:0]   rx_xgmii_32_control_out,
    output wire [XGMII_32_DWIDTH-1:0]   rx_xgmii_32_data_out,
    
    output wire                         rx_xgmii_32_ext_valid_out,
    output wire [XGMII_32_CWIDTH-1:0]   rx_xgmii_32_ext_control_out,
    output wire [XGMII_32_DWIDTH-1:0]   rx_xgmii_32_ext_data_out,
    
    input  wire                         rx_block_lock_in,
    output wire                         rx_block_lock_out,
    // ED
    input  wire                         rx_reset_latency_sclk,
    output wire [TSWIDTH-1:0]           rx_latency_adj,
    input  wire                         latency_sclk,
    input  wire [11:0]                  latency_xcvr_rx,
    
    input  wire [2:0]                   operating_speed,
    
    // Agilex USXGMII 1588 PTP sync pulse from eth_f NPHY to MAC
    input  wire                         rx_xgmii_dl_sync_pulse_in,
    output wire                         rx_xgmii_dl_sync_pulse_out
);

    wire                                rx_xgmii_64_xcvr2wadpt_valid;
    wire [XGMII_64_CWIDTH-1:0]          rx_xgmii_64_xcvr2wadpt_control;
    wire [XGMII_64_DWIDTH-1:0]          rx_xgmii_64_xcvr2wadpt_data;
    
    wire                                rx_xgmii_32_wadpt2drep_valid;
    wire [XGMII_32_CWIDTH-1:0]          rx_xgmii_32_wadpt2drep_control;
    wire [XGMII_32_DWIDTH-1:0]          rx_xgmii_32_wadpt2drep_data;
    
    wire                                rx_xgmii_32_drep2rmff_valid;
    wire [XGMII_32_CWIDTH-1:0]          rx_xgmii_32_drep2rmff_control;
    wire [XGMII_32_DWIDTH-1:0]          rx_xgmii_32_drep2rmff_data;
    
    wire                                rx_xgmii_32_rmff2mac_valid;
    wire [XGMII_32_CWIDTH-1:0]          rx_xgmii_32_rmff2mac_control;
    wire [XGMII_32_DWIDTH-1:0]          rx_xgmii_32_rmff2mac_data;
    
    wire                                rx_block_lock_xcvr2wadpt_valid;
    wire                                rx_block_lock_wadpt2drep_valid;
    wire                                rx_block_lock_drep2rmff_valid;
    wire                                rx_block_lock_rmff2mac_valid;
    
    // Edmond : pipeline 1 stage to correct back fd cycle valid signal
    reg                                 rx_xgmii_64_valid_in_reg;
    reg [XGMII_64_CWIDTH-1:0]           rx_xgmii_64_control_in_reg;
    reg [XGMII_64_DWIDTH-1:0]           rx_xgmii_64_data_in_reg;
    reg                                 rx_block_lock_in_reg;
    
    wire                                rx_xgmii_32_wadpt2ccfifo_valid;
    wire [XGMII_32_CWIDTH-1:0]          rx_xgmii_32_wadpt2ccfifo_control;
    wire [XGMII_32_DWIDTH-1:0]          rx_xgmii_32_wadpt2ccfifo_data;
    wire                                rx_block_lock_wadpt2ccfifo_valid;
    wire                                rx_xgmii_32_wadpt2ccfifo_dl_sync_pulse;
    
    wire                                rx_xgmii_32_ccfifo2derep_valid;
    wire [XGMII_32_CWIDTH-1:0]          rx_xgmii_32_ccfifo2derep_control;
    wire [XGMII_32_DWIDTH-1:0]          rx_xgmii_32_ccfifo2derep_data;
    wire                                rx_block_lock_ccfifo2derep_valid;
    wire                                rx_xgmii_32_ccfifo2pcs_dl_sync_pulse;
    
    // PTP RX Sync pulse from Agilex F-Tile Ethernet Native PHY
    wire                                rx_xgmii_64_xcvr2wadpt_dl_sync_pulse;
    
    assign rx_xgmii_64_xcvr2wadpt_dl_sync_pulse = (ENABLE_IEEE1588 && (DEVICE_FAMILY=="Agilex")) ? rx_xgmii_dl_sync_pulse_in            : 1'b0;
    assign rx_xgmii_dl_sync_pulse_out           = (ENABLE_IEEE1588 && (DEVICE_FAMILY=="Agilex")) ? rx_xgmii_32_ccfifo2pcs_dl_sync_pulse : 1'b0;

    //assign rx_xgmii_64_xcvr2wadpt_valid   = rx_xgmii_64_valid_in;
    //assign rx_xgmii_64_xcvr2wadpt_control = rx_xgmii_64_control_in;
    //assign rx_xgmii_64_xcvr2wadpt_data    = rx_xgmii_64_data_in;

    //assign rx_block_lock_xcvr2wadpt_valid = rx_block_lock_in;

    // ED insert 1 adapter to correct back FD cycle data valid signal for 1588 variant only
    reg                                 data_valid_in_reg;
    reg [XGMII_64_CWIDTH-1:0]           control_in_reg;
    reg [XGMII_64_DWIDTH-1:0]           data_in_reg;
    reg                                 block_lock_in_reg;
    reg                                 invert;
    assign rx_xgmii_64_xcvr2wadpt_valid   = (ENABLE_IEEE1588 && (DEVICE_FAMILY=="Stratix 10")) ? rx_xgmii_64_valid_in_reg   : rx_xgmii_64_valid_in;
    assign rx_xgmii_64_xcvr2wadpt_control = (ENABLE_IEEE1588 && (DEVICE_FAMILY=="Stratix 10")) ? rx_xgmii_64_control_in_reg : rx_xgmii_64_control_in;
    assign rx_xgmii_64_xcvr2wadpt_data    = (ENABLE_IEEE1588 && (DEVICE_FAMILY=="Stratix 10")) ? rx_xgmii_64_data_in_reg    : rx_xgmii_64_data_in;
    assign rx_block_lock_xcvr2wadpt_valid = (ENABLE_IEEE1588 && (DEVICE_FAMILY=="Stratix 10")) ? rx_block_lock_in_reg       : rx_block_lock_in;

    assign check_fd = rx_xgmii_64_valid_in &(rx_xgmii_64_control_in =='b10000000 | rx_xgmii_64_control_in =='b11000000| rx_xgmii_64_control_in =='b11100000 | rx_xgmii_64_control_in =='b11110000 | rx_xgmii_64_control_in =='b11111000 | rx_xgmii_64_control_in =='b11111100 |rx_xgmii_64_control_in =='b11111110 |(rx_xgmii_64_control_in =='b11111111 & rx_xgmii_64_data_in[7:0]=='hfd) );
    always @(posedge rx_pma_clk or negedge rx_pma_rst_n) begin
        if (rx_pma_rst_n == 1'b0) begin
            data_in_reg <= 'd0;
            control_in_reg <= 'd0;
            block_lock_in_reg <= 'd0;
            data_valid_in_reg <= 'd0;

        end
        else begin
            data_in_reg <= rx_xgmii_64_data_in;
            control_in_reg <= rx_xgmii_64_control_in;
            block_lock_in_reg <= rx_block_lock_in;
            data_valid_in_reg <= rx_xgmii_64_valid_in;
        end
    end

    always @(posedge rx_pma_clk or negedge rx_pma_rst_n) begin
        if (rx_pma_rst_n == 1'b0) begin
            rx_xgmii_64_valid_in_reg <= 'd0;
            rx_xgmii_64_control_in_reg <= 'd0;
            rx_xgmii_64_data_in_reg <= 'd0;
            rx_block_lock_in_reg <= 'd0;
            invert <= 1'b0;
        end
        else begin
            rx_xgmii_64_control_in_reg <= control_in_reg;
            rx_xgmii_64_data_in_reg <= data_in_reg;
            rx_block_lock_in_reg <= block_lock_in_reg;
            if (check_fd) begin
                rx_xgmii_64_valid_in_reg <=  ~ data_valid_in_reg;
                invert <= 1'b1;
            end
            else if (invert) begin
                rx_xgmii_64_valid_in_reg <=  ~ data_valid_in_reg;
                invert <= 1'b0;
            end 
            else begin
                rx_xgmii_64_valid_in_reg <=  data_valid_in_reg;
                invert <= 1'b0;
            end
        end
    end
    // Edmond end

    // Agilex USXGMII 1588 RX data flow: NPHY -> Clock Compensation FIFO -> Data Dereplication -> Rate Match FIFO -> ...
    generate
    if ((DEVICE_FAMILY == "Agilex") && (ENABLE_IEEE1588 == 1)) begin: WDAPT2CCFIFO2DEREP2RMFIFO
        alt_mge_phy_usxg32_rx_64_to_32_wadpt width_adpt_64_to_32 (
            .clk                (rx_pma_clk),                       // Write Domain Clock
            .rst_n              (rx_pma_rst_n),                     // Write Domain Active low Reset
            
            .data_valid_in      (rx_xgmii_64_xcvr2wadpt_valid),     // Write Data In Valid
            .control_in         (rx_xgmii_64_xcvr2wadpt_control),   // Frame information 
            .data_in            (rx_xgmii_64_xcvr2wadpt_data),      // Write Data In
            .block_lock_in      (rx_block_lock_xcvr2wadpt_valid),   // Block Lock In (aligned to data_in)
            .dl_sync_pulse_in   (rx_xgmii_64_xcvr2wadpt_dl_sync_pulse),
            
            .data_valid_out     (rx_xgmii_32_wadpt2ccfifo_valid),   // Read Data Out Valid
            .control_out        (rx_xgmii_32_wadpt2ccfifo_control), // Frame information
            .data_out           (rx_xgmii_32_wadpt2ccfifo_data),    // Read Data Out
            .block_lock_out     (rx_block_lock_wadpt2ccfifo_valid), // Block Lock Out (aligned to data_out)
            .dl_sync_pulse_out  (rx_xgmii_32_wadpt2ccfifo_dl_sync_pulse)
        );
        
        assign rx_xgmii_32_ext_valid_out   = rx_xgmii_32_wadpt2ccfifo_valid;
        assign rx_xgmii_32_ext_control_out = rx_xgmii_32_wadpt2ccfifo_control;
        assign rx_xgmii_32_ext_data_out    = rx_xgmii_32_wadpt2ccfifo_data;

        alt_mge_phy_usxg32_rx_clockcomp_fifo #(
            .RX_DWIDTH                  (XGMII_32_DWIDTH),
            .RX_CWIDTH                  (XGMII_32_CWIDTH)
        ) rx_clockcomp_fifo (
            .rx_xgmii_clk               (rx_rec_div33_clk),
            .rx_pma_clk                 (rx_pma_clk),
            
            .rx_xgmii_rst_n             (rx_rec_div33_clk_rst_n),
            .rx_pma_rst_n               (rx_pma_rst_n),
            
            .rx_xgmii_valid_in          (rx_xgmii_32_wadpt2ccfifo_valid),
            .rx_xgmii_control_in        (rx_xgmii_32_wadpt2ccfifo_control),
            .rx_xgmii_data_in           (rx_xgmii_32_wadpt2ccfifo_data),
            .rx_xgmii_block_lock_in     (rx_block_lock_wadpt2ccfifo_valid),
            .rx_xgmii_dl_sync_pulse_in (rx_xgmii_32_wadpt2ccfifo_dl_sync_pulse),
            
            .rx_xgmii_valid_out         (rx_xgmii_32_ccfifo2derep_valid),
            .rx_xgmii_control_out       (rx_xgmii_32_ccfifo2derep_control),
            .rx_xgmii_data_out          (rx_xgmii_32_ccfifo2derep_data),
            .rx_xgmii_block_lock_out    (rx_block_lock_ccfifo2derep_valid),
            .rx_xgmii_dl_sync_pulse_out(rx_xgmii_32_ccfifo2pcs_dl_sync_pulse)
        );

        alt_mge_phy_usxg32_rx_data_derep derep (
            .clk            (rx_rec_div33_clk),
            .rst_n          (rx_rec_div33_clk_rst_n),
            .speed_mode     (operating_speed),
            
            .data_valid_in  (rx_xgmii_32_ccfifo2derep_valid),
            .control_in     (rx_xgmii_32_ccfifo2derep_control),
            .data_in        (rx_xgmii_32_ccfifo2derep_data),
            .block_lock_in  (rx_block_lock_ccfifo2derep_valid),
            
            .data_valid_out (rx_xgmii_32_drep2rmff_valid),
            .control_out    (rx_xgmii_32_drep2rmff_control),
            .data_out       (rx_xgmii_32_drep2rmff_data),
            .block_lock_out (rx_block_lock_drep2rmff_valid)
        );
        
        alt_mge_phy_usxg32_rx_rm_fifo_top #(
            .FAWIDTH            (FF_ADDR_WIDTH),
            .DATA_WIDTH         (XGMII_32_DWIDTH),                  // PCS data width
            .CONTROL_WIDTH      (XGMII_32_CWIDTH),                  // PCS control width
            //.FAWIDTH            (FAWIDTH),                          // FIFO Depth (address width) 
            //.ISWIDTH            (7),                                // RX Gearbox Selector width
            .TSWIDTH            (TSWIDTH),
            .IDWIDTH            (IDWIDTH),                          // PCS/PMA IF width
            .OFFSET             (RX_OFFSET),                        // PCS latency
            .ENABLE_IEEE1588    (ENABLE_IEEE1588),
            .DEVICE_FAMILY      (DEVICE_FAMILY)

        ) rm_fifo (
            .wr_rst_n       (rx_rec_div33_clk_rst_n),               // Write Domain Active low Reset
            .rd_rst_n       (rx_xgmii_rst_n),                       // Read Domain Active low Reset
            .sample_rst_n   (rx_fm_ff_sample_clk_rst_n),            // Sampling Active low Reset
            .wr_clk         (rx_rec_div33_clk),                     // Write Domain Clock
            .rd_clk         (rx_xgmii_clk),                         // Read Domain Clock
            .sample_clk     (rx_fm_ff_sample_clk),                  // Sampling Clock
            .control_in     (rx_xgmii_32_drep2rmff_control),        // Frame information 
            .data_in        (rx_xgmii_32_drep2rmff_data),           // Write Data In
            .data_valid_in  (rx_xgmii_32_drep2rmff_valid),          // Write Data In Valid
            .block_lock_in  (rx_block_lock_drep2rmff_valid),        // Block Lock In (aligned to data_in)
            .r_pempty       (5'd2),                                 // FIFO partially empty threshold
            .r_pfull        (5'd15),                                // FIFO partially full threshold
            .r_empty        ({FF_ADDR_WIDTH{1'b0}}),                // FIFO empty threshold
            .r_full         ({FF_ADDR_WIDTH{1'b1}}),                // FIFO full threshold
            .r_write_ctrl   (1'b0),                                 // RX FIFO clock comp mode write option
            .speed_mode     (operating_speed),                      // control FIFO read rate
            
            .control_out    (rx_xgmii_32_rmff2mac_control),         // Frame information
            .data_out       (rx_xgmii_32_rmff2mac_data),            // Read Data Out
            .data_valid_out (rx_xgmii_32_rmff2mac_valid),           // Read Data Out Valid
            .block_lock_out (rx_block_lock_rmff2mac_valid),         // Block Lock Out (aligned to data_out)
            .rd_empty       (),                                     // Read empty
            .rd_pempty      (),                                     // Read partial empty
            .rd_pfull       (),                                     // Read partial full 
            .wr_oflw_err    (),                                     // Overflow error
            // ED
            .latency_adj            (rx_latency_adj),               // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
            .latency_sclk           (latency_sclk),
            .latency_xcvr_rx        (latency_xcvr_rx),   
            .latency_sclk_reset     (rx_reset_latency_sclk),
            .fifo_insert    (),                                     // 10G BaseR Insertion Flag
            .fifo_del       ()                                      // 10G BaseR Insertion Flag (Async)
        );
        
    end
    
    else begin
        alt_mge_phy_usxg32_rx_64_to_32_wadpt width_adpt_64_to_32 (
            .clk                (rx_pma_clk),                       // Write Domain Clock
            .rst_n              (rx_pma_rst_n),                     // Write Domain Active low Reset
            
            .data_valid_in      (rx_xgmii_64_xcvr2wadpt_valid),     // Write Data In Valid
            .control_in         (rx_xgmii_64_xcvr2wadpt_control),   // Frame information 
            .data_in            (rx_xgmii_64_xcvr2wadpt_data),      // Write Data In
            .block_lock_in      (rx_block_lock_xcvr2wadpt_valid),   // Block Lock In (aligned to data_in)
            .dl_sync_pulse_in  (1'b0),
            
            .data_valid_out     (rx_xgmii_32_wadpt2drep_valid),     // Read Data Out Valid
            .control_out        (rx_xgmii_32_wadpt2drep_control),   // Frame information
            .data_out           (rx_xgmii_32_wadpt2drep_data),      // Read Data Out
            .block_lock_out     (rx_block_lock_wadpt2drep_valid),   // Block Lock Out (aligned to data_out)
            .dl_sync_pulse_out ()
        );

        assign rx_xgmii_32_ext_valid_out   = rx_xgmii_32_wadpt2drep_valid;
        assign rx_xgmii_32_ext_control_out = rx_xgmii_32_wadpt2drep_control;
        assign rx_xgmii_32_ext_data_out    = rx_xgmii_32_wadpt2drep_data;

        alt_mge_phy_usxg32_rx_data_derep derep (
            .clk            (rx_pma_clk),
            .rst_n          (rx_pma_rst_n),
            .speed_mode     (operating_speed),
            
            .data_valid_in  (rx_xgmii_32_wadpt2drep_valid),
            .control_in     (rx_xgmii_32_wadpt2drep_control),
            .data_in        (rx_xgmii_32_wadpt2drep_data),
            .block_lock_in  (rx_block_lock_wadpt2drep_valid),
            
            .data_valid_out (rx_xgmii_32_drep2rmff_valid),
            .control_out    (rx_xgmii_32_drep2rmff_control),
            .data_out       (rx_xgmii_32_drep2rmff_data),
            .block_lock_out (rx_block_lock_drep2rmff_valid)
        );
        
        alt_mge_phy_usxg32_rx_rm_fifo_top #(
            .FAWIDTH            (FF_ADDR_WIDTH),
            .DATA_WIDTH         (XGMII_32_DWIDTH),                  // PCS data width
            .CONTROL_WIDTH      (XGMII_32_CWIDTH),                  // PCS control width
            //.FAWIDTH            (FAWIDTH),                          // FIFO Depth (address width) 
            //.ISWIDTH            (7),                                // RX Gearbox Selector width
            .TSWIDTH            (TSWIDTH),
            .IDWIDTH            (IDWIDTH),                          // PCS/PMA IF width
            .OFFSET             (RX_OFFSET),                        // PCS latency
            .ENABLE_IEEE1588    (ENABLE_IEEE1588),
            .DEVICE_FAMILY      (DEVICE_FAMILY)
            
        ) rm_fifo (
            .wr_rst_n       (rx_pma_rst_n),                         // Write Domain Active low Reset
            .rd_rst_n       (rx_xgmii_rst_n),                       // Read Domain Active low Reset
            .sample_rst_n   (rx_pma_rst_n),                         // Sampling Active low reset
            .wr_clk         (rx_pma_clk),                           // Write Domain Clock
            .rd_clk         (rx_xgmii_clk),                         // Read Domain Clock
            .sample_clk     (rx_pma_clk),                           // Sampling Clock
            .control_in     (rx_xgmii_32_drep2rmff_control),        // Frame information 
            .data_in        (rx_xgmii_32_drep2rmff_data),           // Write Data In
            .data_valid_in  (rx_xgmii_32_drep2rmff_valid),          // Write Data In Valid
            .block_lock_in  (rx_block_lock_drep2rmff_valid),        // Block Lock In (aligned to data_in)
            .r_pempty       (5'd2),                                 // FIFO partially empty threshold
            .r_pfull        (5'd15),                                // FIFO partially full threshold
            .r_empty        ({FF_ADDR_WIDTH{1'b0}}),                // FIFO empty threshold
            .r_full         ({FF_ADDR_WIDTH{1'b1}}),                // FIFO full threshold
            .r_write_ctrl   (1'b0),                                 // RX FIFO clock comp mode write option
            .speed_mode     (operating_speed),                      // control FIFO read rate
            
            .control_out    (rx_xgmii_32_rmff2mac_control),         // Frame information
            .data_out       (rx_xgmii_32_rmff2mac_data),            // Read Data Out
            .data_valid_out (rx_xgmii_32_rmff2mac_valid),           // Read Data Out Valid
            .block_lock_out (rx_block_lock_rmff2mac_valid),         // Block Lock Out (aligned to data_out)
            .rd_empty       (),                                     // Read empty
            .rd_pempty      (),                                     // Read partial empty
            .rd_pfull       (),                                     // Read partial full 
            .wr_oflw_err    (),                                     // Overflow error
            // ED
            .latency_adj            (rx_latency_adj),               // Latency Measurement (6-bit cycle, 10-bit frac. cycle)
            .latency_sclk           (latency_sclk),
            .latency_xcvr_rx        (latency_xcvr_rx),   
            .latency_sclk_reset     (rx_reset_latency_sclk),
            .fifo_insert    (),                                     // 10G BaseR Insertion Flag
            .fifo_del       ()                                      // 10G BaseR Insertion Flag (Async)
        );
        
    end
    endgenerate
    
    assign rx_xgmii_32_valid_out   = rx_xgmii_32_rmff2mac_valid;
    assign rx_xgmii_32_control_out = rx_xgmii_32_rmff2mac_control;
    assign rx_xgmii_32_data_out    = rx_xgmii_32_rmff2mac_data;
    assign rx_block_lock_out       = rx_block_lock_rmff2mac_valid;

endmodule
