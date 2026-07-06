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


`timescale 1 ps/1 ps
module alt_mge_phy_usxgmii_1588_latency #(
    parameter TX_RX         = 0,        // 0: TX FIFO (without ppm correction) 1: RX FIFO (with ppm correction)
    parameter OFFSET        = 0,
    parameter NUMDATA_WIDTH = 5,
    parameter RM_DEL_INS_WIDTH = 4,
    parameter IDWIDTH       = 40,
    parameter OUT_INTG_WIDTH= 6,
    parameter OUT_FRAC_WIDTH= 10,
    parameter DEVICE_FAMILY = "Arria V"
) (
    input wire                                      sample_clk,
    input wire                                      sample_rst_n,

    input wire                                      wr_clk,
    input wire                                      wr_rst_n,

    input wire                                      clk,
    input wire                                      rst_n,

    input wire [NUMDATA_WIDTH-1:0]                  numdata,
    input wire [RM_DEL_INS_WIDTH-1:0]               octet_del_num,
    input wire [RM_DEL_INS_WIDTH-1:0]               octet_ins_num,
    input wire                                      octet_del_en,
    input wire                                      octet_ins_en,
    input wire                                      sample_clk_data_valid,
    input wire                                      rdclk_data_valid_out,
    input wire                                      clk_block_lock,

    input wire                                      latency_sclk,
    input wire                                      latency_sclk_reset,
    input wire [11:0]                               latency_xcvr,
    // ED
    input  wire [2:0]               speed_mode,                     // control FIFO read rate
    output reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0] latency_adj    // OUT_INTG_WIDTH+OUT_FRAC_WIDTH = TSWIDTH (declared in wrapper)
);

    // local parameters
    localparam FRAME_WIDTH       = 66;  // TX 
    localparam FRAME_WIDTH_10g   = 66;  // RX, 10g,5g, 2.5g
    localparam FRAME_WIDTH_1G    = 165; // RX 1g
    localparam FRAME_WIDTH_100M  = 825; // RX 100M

    localparam FIFO_FRAC_WIDTH   = 10;
    localparam APPEND_FRAC_WIDTH = (OUT_FRAC_WIDTH-FIFO_FRAC_WIDTH);
    localparam ACCUM_WIDTH       = 15;  // >= numdata_width + log2(frame_width*queue_depth) = 5 + 9. EDMOND: add extra 2 
    
    localparam XCVR_APPEND_FRAC_WIDTH = 12;
    
    // internal registers and wires
    reg                                             valid;
    reg                                             valid_tx;
    reg                                             valid_rx;
    reg                                             valid_10g;
    reg                                             valid_100M;
    reg                                             valid_1G;
    reg  [NUMDATA_WIDTH-1:0]                        numdata_reg;
    reg  [NUMDATA_WIDTH-1:0]                        numdata_reg_10g;
    reg  [NUMDATA_WIDTH-1:0]                        numdata_reg_100M;
    reg  [NUMDATA_WIDTH-1:0]                        numdata_reg_1G;
    reg  [NUMDATA_WIDTH-1:0]                        numdata_q[FRAME_WIDTH-1:0];
    reg  [NUMDATA_WIDTH-1:0]                        numdata_q_10g[FRAME_WIDTH-1:0];
    reg  [NUMDATA_WIDTH-1:0]                        numdata_q_1G[FRAME_WIDTH_1G-1:0];
    reg  [NUMDATA_WIDTH-1:0]                        numdata_q_100M[FRAME_WIDTH_100M-1:0];
    reg  [6:0]                                      numdata_valid_idx, numdata_valid_idx_reg; // data width=log2(FRAME_WIDTH*QUEUE_DEPTH)
    reg  [6:0]                                      numdata_valid_idx_10g, numdata_valid_idx_reg_10g; // data width=log2(FRAME_WIDTH*QUEUE_DEPTH)
    reg  [7:0]                                      numdata_valid_idx_1G, numdata_valid_idx_reg_1G; // data width=log2(FRAME_WIDTH*QUEUE_DEPTH)
    reg  [9:0]                                      numdata_valid_idx_100M, numdata_valid_idx_reg_100M; // data width=log2(FRAME_WIDTH*QUEUE_DEPTH)

    wire [ACCUM_WIDTH-1:0]                          latency_accum;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_10g;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_10g_reg;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_100M;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_100M_reg;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_1G;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_1G_reg;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_tx;
    reg  [ACCUM_WIDTH-1:0]                          latency_accum_tx_reg;
    // Set SYNCHRONIZER_IDENTIFICATION=OFF because speed_mode is a pseudo-static field
    (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg  [ACCUM_WIDTH-1:0]                       latency_accum_rx;
    wire [ACCUM_WIDTH-1:0]                          latency_accum_out;
    wire latency_accum_val;    
    
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]     latency_adj_fifo_r;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]     latency_adj_fifo_r_1G;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+6:0]   latency_adj_fifo_r_100M; 
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]     latency_adj_fifo_r_reg0;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]     latency_adj_fifo_r_reg1;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]     latency_adj_fifo_r_1G_reg0;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]     latency_adj_fifo_r_1G_reg1;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+6:0]   latency_adj_fifo_r_100M_reg0; 
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+6:0]   latency_adj_fifo_r_100M_reg1; 

    (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *) reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]    latency_adj_fifo_r1;
    wire [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH-1+8:0]    latency_adj_fifo;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0]     latency_adj_fifo_sum;
    reg                                          latency_add_state;
    reg                                          latency_add_state_reg;
	wire [11:0] latency_xcvr_div2;
	
	assign latency_xcvr_div2 = latency_xcvr >> 1;  // /2 to convert from fast clock cycle to slow clock cycle. 

    reg  [12+XCVR_APPEND_FRAC_WIDTH-1:0]     latency_accum_xcvr_sum;
    
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] latency_accum_xcvr;
    
    generate if(DEVICE_FAMILY == "Stratix 10") 
    begin
        wire latency_accum_val_xcvr;
        reg [11:0] latency_accum_out_xcvr;
        // cross over to 125MHz domain
        alt_mge16_pcs_clock_crosser #(
            .BITS_PER_SYMBOL    (12)
        ) latency_pulse_rx_transfer (
            .in_clk     (latency_sclk),
            .in_reset   (latency_sclk_reset),
            .in_ready   (),
            .in_valid   (1'b1),
            .in_data    (latency_xcvr_div2),
            .out_clk    (clk),
            .out_reset  (~rst_n),
            .out_ready  (1'b1),
            .out_valid  (latency_accum_val_xcvr),
            .out_data   (latency_accum_out_xcvr)
        );
    
        always @ (posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                latency_accum_xcvr_sum <= {(12+XCVR_APPEND_FRAC_WIDTH){1'b0}};
                latency_accum_xcvr <= {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};
            end else begin      
                
                if (latency_accum_val_xcvr) begin
                    // Converting from number of cycle per 257MHz to number of cycles per 156Mhz = (10G/40) / (10G/66) = 40/66 = (32 + 8) / 66
                    // Rather than divide by 66...
                    // 1/66 ~= 993/65536 ~= (1024 - 31)/65536
                    // error = 0.0000004x, where x = accum. fill level = avg. fill level * 66
                    // max fill level = 32  ==>  max error = 0.0008448cycle / 5.40672 ps (negligible)
                    // Input from latency_pulse_measurement has 4 fractional bit. Padding 6 fractional bits yield 10 fractional bits.
                    // latency_accum_xcvr_rx_div66 <= (((latency_accum_out_xcvr_rx << (10+(FIFO_FRAC_WIDTH))) - ((latency_accum_out_xcvr_rx << (5+(FIFO_FRAC_WIDTH))) - (latency_accum_out_xcvr_rx << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                    //          >> 16) // divide by 65536
                    //          / 1;   // QUEUE_DEPTH=1
                   
                    // latency_accum_xcvr_sum <= ({latency_accum_out_xcvr,{10{1'b0}}} >> 1) - ({latency_accum_out_xcvr,{10{1'b0}}} >> 6) + ({latency_accum_out_xcvr,{10{1'b0}}} >> 11) 
                    //                + ({latency_accum_out_xcvr,{10{1'b0}}} >> 3) - ({latency_accum_out_xcvr,{10{1'b0}}} >> 8) + ({latency_accum_out_xcvr,{10{1'b0}}} >> 13);
                    // for PMA width 32, formula = 2^-1 -2^-6 + 2^-11 only.
                    latency_accum_xcvr_sum <= ({latency_accum_out_xcvr,{10{1'b0}}} >> 1) - ({latency_accum_out_xcvr,{10{1'b0}}} >> 6) + ({latency_accum_out_xcvr,{10{1'b0}}} >> 11);
                   
                    latency_accum_xcvr <= latency_accum_xcvr_sum[OUT_INTG_WIDTH+OUT_FRAC_WIDTH+6-1:6];
                end else begin
                    latency_accum_xcvr_sum <= latency_accum_xcvr_sum;
                    
                    latency_accum_xcvr <= latency_accum_xcvr;
               end
            end
        end    
    end else begin
        always @ (posedge clk or negedge rst_n) begin
            if (~rst_n) begin
                latency_accum_xcvr_sum <= {(12+XCVR_APPEND_FRAC_WIDTH){1'b0}};
                latency_accum_xcvr <= {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};
            end else begin
                latency_accum_xcvr_sum <= {(12+XCVR_APPEND_FRAC_WIDTH){1'b0}};
                latency_accum_xcvr <= {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};
            end
        end
    end
    endgenerate 

    // accumulated fill-level / numdata
    reg numdata_valid_idx_is_65;
    reg numdata_valid_idx_10g_is_65;
    reg numdata_valid_idx_1G_is_164;
    reg numdata_valid_idx_100M_is_824;
    always @(posedge sample_clk or negedge sample_rst_n) begin
        if (sample_rst_n == 0) begin
            numdata_valid_idx <= 7'd0;
            numdata_valid_idx_10g <= 7'd0;
            numdata_valid_idx_1G <= 8'd0;
            numdata_valid_idx_100M <= 10'd0;
            //numdata_valid_idx_m1 <= 10'd65; // FRAME_WIDTH*QUEUE_DEPTH-1
            latency_accum_tx <= {ACCUM_WIDTH{1'b0}};
            latency_accum_tx_reg <= {ACCUM_WIDTH{1'b0}};
            latency_accum_10g <= {ACCUM_WIDTH{1'b0}};
            latency_accum_10g_reg <= {ACCUM_WIDTH{1'b0}};
            latency_accum_1G <= {ACCUM_WIDTH{1'b0}};
            latency_accum_1G_reg <= {ACCUM_WIDTH{1'b0}};
            latency_accum_100M <= {ACCUM_WIDTH{1'b0}};
            latency_accum_100M_reg <= {ACCUM_WIDTH{1'b0}};
            valid_tx <= 1'b0;
            valid_100M <= 1'b0;
            valid_1G <= 1'b0;
            valid_10g <= 1'b0;
            numdata_valid_idx_is_65 <= 1'b0;
            numdata_valid_idx_10g_is_65 <= 1'b0;
            numdata_valid_idx_1G_is_164 <= 1'b0;
            numdata_valid_idx_100M_is_824 <= 1'b0;
        end else begin
            if (!TX_RX) begin //TX FIFO
                numdata_valid_idx_is_65 <= numdata_valid_idx == 7'd65 ? 1'b1 : 1'b0; //check for 65 1 cycle earlier, thus is checking 64
                if (numdata_valid_idx_is_65) begin // FRAME_WIDTH*QUEUE_DEPTH-1
                    valid_tx <= 1'b1;
                    numdata_valid_idx <= 7'd0;
                    latency_accum_tx_reg <= {ACCUM_WIDTH{1'b0}};
                    latency_accum_tx <= latency_accum_tx_reg;
                end else begin
                    valid_tx <= 1'b0;
                    numdata_valid_idx <= numdata_valid_idx + 7'd1;
                    latency_accum_tx_reg <= latency_accum_tx_reg + numdata;
                    latency_accum_tx <= latency_accum_tx;
                end
            end
            else begin
            //ED: For RX 10G,5G,2.5G
                numdata_valid_idx_10g_is_65 <= numdata_valid_idx_10g == 7'd65 ? 1'b1 : 1'b0; //check for 65 1 cycle earlier, thus is checking 64
                if (numdata_valid_idx_10g_is_65) begin // FRAME_WIDTH*QUEUE_DEPTH-1
                    valid_10g <= 1'b1;
                    numdata_valid_idx_10g <= 7'd0;
                    latency_accum_10g_reg <= {ACCUM_WIDTH{1'b0}};
                    latency_accum_10g <= latency_accum_10g_reg;
                end else begin
                    valid_10g <= 1'b0;
                    numdata_valid_idx_10g <= numdata_valid_idx_10g + 7'd1;
                    latency_accum_10g_reg <= latency_accum_10g_reg + numdata;
                    latency_accum_10g <= latency_accum_10g;
                end

            //RX 1G
                numdata_valid_idx_1G_is_164 <= numdata_valid_idx_1G == 8'd164 ? 1'b1 : 1'b0; //check for 164 1 cycle earlier, thus is checking 163
                if (numdata_valid_idx_1G_is_164) begin // FRAME_WIDTH*QUEUE_DEPTH-1
                    valid_1G <= 1'b1;
                    numdata_valid_idx_1G <= 8'd0;
                    latency_accum_1G_reg <= {ACCUM_WIDTH{1'b0}};
                    latency_accum_1G <= latency_accum_1G_reg;
                end else begin
                    valid_1G <= 1'b0;
                    numdata_valid_idx_1G <= numdata_valid_idx_1G + 8'd1;
                    latency_accum_1G_reg <= latency_accum_1G_reg + numdata;
                    latency_accum_1G <= latency_accum_1G;
                end

            //RX 100M
                numdata_valid_idx_100M_is_824 <= numdata_valid_idx_100M == 10'd824 ? 1'b1 : 1'b0; //check for 824 1 cycle earlier, thus is checking 823
                if (numdata_valid_idx_100M_is_824) begin // FRAME_WIDTH*QUEUE_DEPTH-1
                    valid_100M <= 1'b1;
                    numdata_valid_idx_100M <= 10'd0;
                    latency_accum_100M_reg <= {ACCUM_WIDTH{1'b0}};
                    latency_accum_100M <= latency_accum_100M_reg;
                end else begin
                    valid_100M <= 1'b0;
                    numdata_valid_idx_100M <= numdata_valid_idx_100M + 10'd1;
                    latency_accum_100M_reg <= latency_accum_100M_reg + numdata;
                    latency_accum_100M <= latency_accum_100M;
                end

            // Build some assertions to avoid overflow
            end
         
        end
    end

    always @(posedge sample_clk or negedge sample_rst_n) begin
        if (sample_rst_n == 0) begin
            valid_rx <= 1'b0;
            latency_accum_rx <= {ACCUM_WIDTH{1'b0}};
        end else begin
            valid_rx <= ((speed_mode == 3'b000) || (speed_mode == 3'b101) || (speed_mode == 3'b100)) ? valid_10g :
                        ((speed_mode == 3'b001) ? valid_1G :
                        ((speed_mode == 3'b010) ? valid_100M:
                                                  valid_100M));
            if ((speed_mode == 3'b000) | (speed_mode == 3'b101) | (speed_mode == 3'b100)) begin
                latency_accum_rx <= latency_accum_10g;
            end else if (speed_mode == 3'b001) begin
                latency_accum_rx <= latency_accum_1G;
            end else if (speed_mode == 3'b010) begin
                latency_accum_rx <= latency_accum_100M;
            end else begin
                latency_accum_rx <= latency_accum_10g;
            end
        end
    end

    assign latency_accum = (!TX_RX)? latency_accum_tx :latency_accum_rx;

    assign valid = (!TX_RX)? valid_tx :valid_rx;
    // transfer accummulated fill-level / numdata

    alt_mge16_pcs_clock_crosser #(
        .BITS_PER_SYMBOL(ACCUM_WIDTH),
        .USE_OUTPUT_PIPELINE(1)
    ) latency_transfer (
        .in_clk     (sample_clk),
        .in_reset   (~sample_rst_n),
        .in_ready   (),
        .in_valid   (valid),
        .in_data    ({latency_accum}),
        .out_clk    (clk),
        .out_reset  (~rst_n),
        .out_ready  (1'b1),
        .out_valid  (latency_accum_val),
        .out_data   (latency_accum_out)
    );
    
    // latency_adj_fifo_sum = latency_adj_fifo + PCS Offset
    // This is the full formula (too slow)
    //         latency_adj <= OFFSET + 
    //                        (latency_accum_out << OUT_FRAC_WIDTH) / (FRAME_WIDTH*QUEUE_DEPTH) -
    //                        ((sm_out) ? (1'b1 << OUT_FRAC_WIDTH) : 0);
    // Latency from FIFO output to MII/GMII interface (In unit of clock cycle)??, RX OFFSET +0.334 for 10G accuracy adjust, other speed needs - back 0.334
    localparam INTERNAL_LATENCY_10G = {8'd0, 10'd0};
    localparam INTERNAL_LATENCY_5G = {8'd1,10'd0};
    localparam INTERNAL_LATENCY_2P5G  = {8'd3,10'd0};
    localparam INTERNAL_LATENCY_1G   = {8'd9,10'd0};
    localparam INTERNAL_LATENCY_100M   = {8'd99,10'd0};

    wire [17:0] latency_adj_speed_const;
    assign latency_adj_speed_const = (speed_mode == 3'b000) ? INTERNAL_LATENCY_10G :
                                     (speed_mode == 3'b101) ? INTERNAL_LATENCY_5G :
                                     (speed_mode == 3'b100) ? INTERNAL_LATENCY_2P5G :
                                     (speed_mode == 3'b001) ? INTERNAL_LATENCY_1G :
                                     (speed_mode == 3'b010) ? INTERNAL_LATENCY_100M :
                                     INTERNAL_LATENCY_100M;
    reg [18:0] latency_adj_fifo_sum_Offset_speed_constant;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]    latency_adj_fifo_r_x_1;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]    latency_adj_fifo_r_x_2;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]    latency_adj_fifo_r_x_4;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]    latency_adj_fifo_r_1G_x_10;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8:0]    latency_adj_fifo_r_100m_x_100;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0]     latency_adj_fifo_sum_pre;
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            latency_adj_fifo_sum <= OFFSET;
            latency_adj_fifo_sum_pre <= OFFSET;
            latency_adj_fifo_sum_Offset_speed_constant <= OFFSET;
            latency_adj_fifo_r <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_1G <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_100M <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+6){1'b0}};
            latency_adj_fifo_r_reg0 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_reg1 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_1G_reg0 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_1G_reg1 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_100M_reg0 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+6){1'b0}};
            latency_adj_fifo_r_100M_reg1 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+6){1'b0}};
            latency_adj_fifo_r1 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_x_1 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_x_2 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_x_4 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_1G_x_10 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            latency_adj_fifo_r_100m_x_100 <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
            
        end else begin
            if (!TX_RX) begin //TX FIFO

                if (latency_accum_val) begin
                    // Rather than divide by 66...
                    // 1/66 ~= 993/65536 ~= (1024 - 31)/65536
                    // error = 0.0000004x, where x = accum. fill level = avg. fill level * 66
                    // max fill level = 32  ==>  max error = 0.0008448cycle / 5.40672 ps (negligible)
                    latency_adj_fifo_r1 <= (((latency_accum_out[11:0] << (10+FIFO_FRAC_WIDTH)) - ((latency_accum_out[11:0] << (5+FIFO_FRAC_WIDTH)) - (latency_accum_out[11:0] << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                                 >> 16) // divide by 65536
                                 / 1;   // QUEUE_DEPTH=1
            
                end
                //ED change to x2 the accum_xcvr and adj_fifo as effective rate running at 156Mhz, but MAC TSU count with 312Mhz.
                latency_adj_fifo_sum <= ((latency_accum_xcvr[OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] + latency_adj_fifo) << 1) + OFFSET;
            
            end else begin //TX_RX=1 , RX FIFO
            
                if (speed_mode == 3'b000) begin
                   latency_adj_fifo_r1 <= latency_adj_fifo_r_x_1;
                end else if (speed_mode == 3'b101) begin //5G x speed multiplier x2
                    latency_adj_fifo_r1 <= latency_adj_fifo_r_x_2;
                end else if (speed_mode == 3'b100) begin //2.5G x speed multiplier x4
                    latency_adj_fifo_r1 <= latency_adj_fifo_r_x_4;
                end else if (speed_mode == 3'b001) begin     // 1G x speed multiplier x10
                    latency_adj_fifo_r1 <= latency_adj_fifo_r_1G_x_10 ;
                end else if (speed_mode == 3'b010) begin     // 100M x speed multiplier x100
                    latency_adj_fifo_r1 <= latency_adj_fifo_r_100m_x_100;
                end else begin   
                    latency_adj_fifo_r1 <= latency_adj_fifo_r_x_1;
                end

                latency_adj_fifo_r <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'(latency_adj_fifo_r_reg0 - latency_adj_fifo_r_reg1);
                latency_adj_fifo_r_1G <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'(latency_adj_fifo_r_1G_reg0 + latency_adj_fifo_r_1G_reg1);
                latency_adj_fifo_r_100M <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+6+1)'(latency_adj_fifo_r_100M_reg0 + latency_adj_fifo_r_100M_reg1);
                latency_adj_fifo_r_x_1 <= latency_adj_fifo_r;
                latency_adj_fifo_r_x_2 <= latency_adj_fifo_r << 1;
                latency_adj_fifo_r_x_4 <= latency_adj_fifo_r << 2;
                latency_adj_fifo_r_1G_x_10 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'((latency_adj_fifo_r_1G << 1) + (latency_adj_fifo_r_1G << 3));
                latency_adj_fifo_r_100m_x_100 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'((latency_adj_fifo_r_100M[27:0] << 6) + (latency_adj_fifo_r_100M[27:0]<< 5) + (latency_adj_fifo_r_100M[27:0] << 2));   
                if (latency_accum_val) begin
                    // Rather than divide by 66...
                    // 1/66 ~= 993/65536 ~= (1024 - 31)/65536
                    // error = 0.0000004x, where x = accum. fill level = avg. fill level * 66
                    // max fill level = 32  ==>  max error = 0.0008448cycle / 5.40672 ps (negligible)
                    //latency_adj_fifo_r_wo_speed_mult <= (((latency_accum_out << (10+FIFO_FRAC_WIDTH)) - ((latency_accum_out << (5+FIFO_FRAC_WIDTH)) - (latency_accum_out << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                    //EDMOND, /66 for 10G, 5G,2.5G
                    // latency_adj_fifo_r_reg <= (((latency_accum_out << (10+FIFO_FRAC_WIDTH)) - ((latency_accum_out << (5+FIFO_FRAC_WIDTH)) - (latency_accum_out << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                                 // >> 16)  // divide by 65536
                                 // / 1;    // QUEUE_DEPTH=1
                    // Separate into 2 registers for timing performance
                    latency_adj_fifo_r_reg0 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'((((latency_accum_out << (10+FIFO_FRAC_WIDTH)) ) // x (1024)
                                 >> 16) // divide by 65536
                                 / 1);  // QUEUE_DEPTH=1
                    latency_adj_fifo_r_reg1 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'(((((latency_accum_out << (5+FIFO_FRAC_WIDTH)) - (latency_accum_out << (FIFO_FRAC_WIDTH))) ) // x (32-1)
                                 >> 16) // divide by 65536
                                 / 1);  // QUEUE_DEPTH=1
                    
                    //EDMOND , /165 for 1G
                    // latency_adj_fifo_r_1G_reg <= (((latency_accum_out << (8+FIFO_FRAC_WIDTH)) + (latency_accum_out << (7+FIFO_FRAC_WIDTH)) + (latency_accum_out << (3+FIFO_FRAC_WIDTH)) + (latency_accum_out << (2+FIFO_FRAC_WIDTH)) + (latency_accum_out << (FIFO_FRAC_WIDTH)) ) // x (256+128+8+4+1)
                                 // >> 16) // divide by 65536
                                 // / 1;   // QUEUE_DEPTH=1
                    // Separate into 2 registers for timing performance
                    latency_adj_fifo_r_1G_reg0 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'((((latency_accum_out << (8+FIFO_FRAC_WIDTH)) + (latency_accum_out << (7+FIFO_FRAC_WIDTH)) ) // x (256+128)
                                 >> 16) // divide by 65536
                                 / 1);   // QUEUE_DEPTH=1
                    latency_adj_fifo_r_1G_reg1 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1)'((((latency_accum_out << (3+FIFO_FRAC_WIDTH)) + (latency_accum_out << (2+FIFO_FRAC_WIDTH)) + (latency_accum_out << (FIFO_FRAC_WIDTH)) ) // x (8+4+1)
                                 >> 16) // divide by 65536
                                 / 1);   // QUEUE_DEPTH=1
             
                     //EDMOND, /825 for 100M
                    //latency_adj_fifo_r_100M <= (((latency_accum_out << (7+FIFO_FRAC_WIDTH)) + (latency_accum_out << (5+FIFO_FRAC_WIDTH)) - (latency_accum_out << (FIFO_FRAC_WIDTH)) ) // x (128+32-1)
                        //         >> 17) // divide by 131072
                        //         / 1;   // QUEUE_DEPTH=1
                     //EDMOND, /825 for 100M  use 2^20
                    latency_adj_fifo_r_100M_reg0 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+6+1)'((((latency_accum_out << (10+FIFO_FRAC_WIDTH)) -(latency_accum_out << (3+FIFO_FRAC_WIDTH))) // x (1024-8)
                                 >> 20) // divide by 1048576
                                 / 1);  // QUEUE_DEPTH=1
                    latency_adj_fifo_r_100M_reg1 <= (OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3+8+1+6)'((((latency_accum_out << (8+FIFO_FRAC_WIDTH)) - (latency_accum_out << (FIFO_FRAC_WIDTH)) ) // x (256-1)
                                 >> 20) // divide by 1048576
                                 / 1);  // QUEUE_DEPTH=1

                end 
                //ED change to x2 the accum_xcvr and adj_fifo as effective rate running at 156Mhz, but MAC TSU count with 312Mhz.FOR RX, only accum xcvr needs x2
                latency_adj_fifo_sum_pre <= (latency_accum_xcvr[OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] <<1) + latency_adj_fifo;
                latency_adj_fifo_sum_Offset_speed_constant <= OFFSET + latency_adj_speed_const;
                latency_adj_fifo_sum <= latency_adj_fifo_sum_pre + latency_adj_fifo_sum_Offset_speed_constant;
            
            end
        end
    end
    
    assign latency_adj_fifo = latency_adj_fifo_r1[OUT_INTG_WIDTH+FIFO_FRAC_WIDTH-1+8:0];
    
    // Inaccuracy caused by ppm
    localparam PPM_CNTR_WIDTH=20;
    wire [PPM_CNTR_WIDTH-1:0] ppm_out;
    wire [PPM_CNTR_WIDTH-1:0] ppm;
    wire ppm_sign;
    // ED reduce to 10bits 
    wire  [10-1:0]    octet_del_num_adj;     // 1588's deletion number (after speed multiplication)
    wire  [10-1:0]    octet_ins_num_adj;     // 1588's deletion number (after speed multiplication)
    // 10gbps : multi_factor = 1
    // 5gbps  : multi_factor = 2
    // 2.5gbps: multi_factor = 4
    // 1gbps  : multi_factor = 10 = (8+2) = (<<3 + <<1)
    // 100mbps: multi_factor = 100 = (64+32+4) = (<<6 + <<5 + <<2)
    assign octet_del_num_adj  = (speed_mode == 3'b000) ? (octet_del_num) :
                                (speed_mode == 3'b101) ? (octet_del_num<<1) :
                                (speed_mode == 3'b100) ? (octet_del_num<<2) :
                                (speed_mode == 3'b001) ? ((octet_del_num<<3) + (octet_del_num<<1)) :
                                (speed_mode == 3'b010) ? ((octet_del_num<<6) + (octet_del_num<<5) + (octet_del_num<<2)):
                                ((octet_del_num<<6) + (octet_del_num<<5) + (octet_del_num<<2));
    
    
    assign octet_ins_num_adj  = (speed_mode == 3'b000) ? (octet_ins_num) :
                                (speed_mode == 3'b101) ? (octet_ins_num<<1) :
                                (speed_mode == 3'b100) ? (octet_ins_num<<2) :
                                (speed_mode == 3'b001) ? ((octet_ins_num<<3) + (octet_ins_num<<1)) :
                                (speed_mode == 3'b010) ? ((octet_ins_num<<6) + (octet_ins_num<<5) + (octet_ins_num<<2)):
                                ((octet_ins_num<<6) + (octet_ins_num<<5) + (octet_ins_num<<2));
    
    //  for v18.0, bug introduced as when we handle PPM for diff speeds , x1 for 10G, x2 for 5G, x4 for 2.5G, x10 for 1G, x100 for 100M. hardware results showed the latency value is inaccurate. 
    //  bug fixed in v18.1, removing the multiplication factor for PPM value for diff speeds.
      
    assign ppm = (TX_RX) ? ppm_out : {PPM_CNTR_WIDTH{1'b0}}; 
    
    wire clk_b;
    wire b_rst_n;

    assign clk_b   = (TX_RX) ? wr_clk   : sample_clk;
    assign b_rst_n = (TX_RX) ? wr_rst_n : sample_rst_n;

    alt_mge_phy_xgmii_1588_ppm_counter #(
        .PPM_CNTR_WIDTH(PPM_CNTR_WIDTH)
    ) ppm_cntr (
        .clk_a              (clk),
        .clk_a_data_valid   (rdclk_data_valid_out),
        .clk_b              (clk_b),
        .rst_a_n            (rst_n),
        .rst_b_n            (b_rst_n),
        .clk_b_data_valid   (sample_clk_data_valid),
        .clk_a_block_lock   (clk_block_lock),
        .speed_mode         (speed_mode),
        .ppm_sign           (ppm_sign),
        .ppm                (ppm_out)
    );

    // skyeow: IDWIDTH need to change here, it is different for 10G,5G,2.5G,1G and 100M
    // ppm_gap : used in normal condition. it eliminates the inaccuracy caused by averager (in phase calculator) when ppm presents.
    // ppm_gap = max_drift/2 = (66 sample_clk cycle * ppm/cycle) / 2 = (IDWIDTH clk cycle * ppm/cycle) / 2
    // ppm gap need to x1,x2,x4,x10,x100 according to speed. move the mulitplication in ppm_width calculation.

    reg [8:0] ppm_width;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ppm_width <= {9{1'b0}};
        end else begin
            if (speed_mode == 3'b101) begin         //5G 16 x2
                ppm_width <= 9'd32;     
            end
            else if (speed_mode == 3'b100)begin     //2.5G   8 x 4
                ppm_width <= 9'd32; 
                end
                
             else if (speed_mode == 3'b001)begin    //1G  8x10
                ppm_width <= 9'd80; 
                end
             else if (speed_mode == 3'b010)begin    //100M 4 x100
                ppm_width <= 9'd400; 
                end
            else begin
                ppm_width <= 9'd32;                 //10G x1
            end
        end
    end

    reg [8:0]  ppm_gap_cntr;
    reg [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_gap_reg;
    reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_gap;
    // remove async clear
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ppm_gap_cntr <= {9{1'b0}};
            ppm_gap_reg  <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            ppm_gap      <= {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};
            
        end else begin
            if (ppm_gap_cntr == 9'd0)begin
                ppm_gap_cntr <= ppm_width;
                ppm_gap      <= ppm_gap_reg[(OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1):(PPM_CNTR_WIDTH-OUT_FRAC_WIDTH)]; // cut extra 10 fractional cycle bits
                ppm_gap_reg  <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            end
            else begin
                ppm_gap_cntr <= ppm_gap_cntr - 6'd1;
                ppm_gap_reg  <= ppm_gap_reg + ppm;
            end
        end
    end

    // ppm_accum_rm : used if rate match happens. it gives ppm effect to the freezed latency_adj.
    reg  [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_accum_rm_reg;
    wire [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_accum_rm;
    
    assign ppm_accum_rm = ppm_accum_rm_reg[(OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1):(PPM_CNTR_WIDTH-OUT_FRAC_WIDTH)]; // cut the extra 10-bit of frac. cycle
    
    // ppm_accum_rm_reg: accummulate ppm (20-bit fractional cycle)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ppm_accum_rm_reg <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
        end
        else begin
            if (octet_ins_en | octet_del_en) begin
                ppm_accum_rm_reg <= ppm_accum_rm_reg + ppm;
            end
            else begin
                ppm_accum_rm_reg <= ppm;
            end
        end
    end

    // ppm_accum_normal : used in normal condition. it gives ppm effect to latency_adj. This is needed as
    // latency_adj_fifo doesn't show ppm effect immediately every cycle, it shows accummulated ppm effect once in a while.
    // this ppm correction is aligned to latency_adj_fifo_sum
    reg  [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_accum_normal_reg;
    reg  [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_accum_normal_reg0;
    reg  [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_accum_normal_reg1;
    reg  [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_accum_normal_reg2;
    reg  [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_accum_normal_reg3;
    wire [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_accum_normal;

    assign ppm_accum_normal = ppm_accum_normal_reg[(OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1):(PPM_CNTR_WIDTH-OUT_FRAC_WIDTH)]; // cut the extra 10-bit of frac. cycle
    // remove async clear
    // ppm_accum_normal_reg: accummulate ppm (20-bit fractional cycle)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ppm_accum_normal_reg      <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            ppm_accum_normal_reg0      <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            ppm_accum_normal_reg1      <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            ppm_accum_normal_reg2      <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            ppm_accum_normal_reg3      <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
        end
        else begin
            if (latency_accum_val) begin //when latency_accum_val is high, reset the ppm accum to 0
                // latency_adj_fifo_sum updated, re-accummulate ppm
                ppm_accum_normal_reg0 <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            end
            else begin
                ppm_accum_normal_reg0 <= ppm_accum_normal_reg0 + ppm;
            end
            ppm_accum_normal_reg1 <= ppm_accum_normal_reg0;
            ppm_accum_normal_reg2 <= ppm_accum_normal_reg1;
            ppm_accum_normal_reg3 <= ppm_accum_normal_reg2;
            ppm_accum_normal_reg <= ppm_accum_normal_reg3;
        end
    end
    
    // Latency Measurement Output - with ppm correction and rate match condition handling
    // Rate Match Latency Handling 1
    // Reg octet_del_num to align latency_adj to the respective FIFO's data_out
    // sv_rx_fifo/fifo_out to rx_clockcomp/data_out = 2-cycle delay (delete case)
    // sv_rx_fifo/d_out    to rx_clockcomp/data_out = 1-cycle delay (insert case)
    // register octet_del_num_reg = 1-cycle delay
    // latency_adj calculation    = 1-cycle delay
    
    // Rate Match Latency Handling 2 (after rate match handling 1 ends)
    // wr_del_sm=0 : fill level = actual data latency
    // wr_del_sm=1 : fill level > actual data latency by 0.5 (correction: -0.5)
    // wr_del_sm=2 : fill level < actual data latency by 0.5 (correction: +0.5)
    // wr_del_sm=3 : fill level > actual data latency by 1   (corrected in statemachine wr_en=0)
    
    // deletion/insertion number is divided by 2 and appended for fractional cycle bits
    
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+4:0] octet_del_num_reg;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0] latency_adj_octet_del;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0] latency_adj_octet_ins;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0] latency_adj_reg;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0] latency_adj_fifo_sum_plus_ppm_normal;
    reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1+8:0] ppm_normal;
    reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_tx_dummy/* synthesis noprune */;
    
    // remove async clear
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            octet_del_num_reg   <= 'd0;
            latency_adj_octet_del   <= 'd0;
            latency_adj         <= OFFSET;
            latency_adj_reg     <= OFFSET;
            //Ed try improve timing by reg octet_ins_num
            latency_adj_octet_ins   <= 'd0;
            ppm_normal   <= 'd0;
            ppm_tx_dummy   <= 'd0;
            latency_adj_fifo_sum_plus_ppm_normal   <= 'd0;
        end else begin
            // ppm_sign = 1: rd_clk faster than wr_clk (-ve ppm)
            // ppm_sign = 0: rd clk slower than wr_clk (+ve ppm)
            ppm_tx_dummy <= {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};
            //ppm_normal <= (TX_RX) ? (ppm_sign ? (ppm_gap - ppm_accum_normal) : (ppm_gap + ppm_accum_normal) ) : // RX
            //                         ppm_tx_dummy;                                    // TX
            ppm_normal   <= 'd0;
            latency_adj_fifo_sum_plus_ppm_normal <= latency_adj_fifo_sum + ppm_normal;
        
            octet_del_num_reg <= (octet_del_num_adj<<(OUT_FRAC_WIDTH));
            //skyeow: extra one clock cycle delay here, expected?
            latency_adj_octet_del <=  latency_adj_reg - octet_del_num_reg + ppm_accum_rm;
            latency_adj_octet_ins <= latency_adj_reg + (octet_ins_num_adj<<(OUT_FRAC_WIDTH)) - ppm_accum_rm;
            if(octet_del_en) begin      // ratematch / deletion
                latency_adj         <= latency_adj_octet_del;
                latency_adj_reg     <= latency_adj_reg;
            end
            else if(octet_ins_en) begin // ratematch / insertion
                latency_adj         <= latency_adj_octet_ins;
                latency_adj_reg     <= latency_adj_reg;
            end
            else begin                  // normal
                latency_adj         <= latency_adj_fifo_sum_plus_ppm_normal;
                latency_adj_reg     <= latency_adj_fifo_sum_plus_ppm_normal;
            end
        end
    end

endmodule // alt_mge_phy_usxgmii_1588_latency
