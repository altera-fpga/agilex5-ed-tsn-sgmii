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
module alt_mge_phy_xgmii_1588_latency 
  #(
    parameter TX_RX=0,              // 0: TX FIFO (without ppm correction) 1: RX FIFO (with ppm correction)
    parameter OFFSET=0,
    parameter NUMDATA_WIDTH = 5,
    parameter RM_DEL_INS_WIDTH = 4,
    parameter RM_SM_WIDTH = 2,
    parameter IDWIDTH = 40,
    parameter OUT_INTG_WIDTH = 6,
    parameter OUT_FRAC_WIDTH = 10,
    parameter DEVICE_FAMILY = "Arria V"
    )(
      input wire                                     sample_clk,
      input wire                                     sample_rst_n,

      input wire                                     clk,
      input wire                                     rst_n,

      input wire [NUMDATA_WIDTH-1:0]                 numdata,
      input wire [RM_DEL_INS_WIDTH-1:0]              octet_del_num,
      input wire [RM_SM_WIDTH-1:0]                   wr_del_sm,
      input wire [RM_DEL_INS_WIDTH-1:0]              octet_ins_num,
      input wire                                     octet_del_en,
      input wire                                     octet_ins_en,
      input wire                                     sample_clk_data_valid,
      input wire                                     clk_block_lock,
      
      input   wire                                   latency_sclk,
      input   wire                                   latency_sclk_reset,
      input   wire [11:0]                            latency_xcvr,

      output reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] latency_adj // OUT_INTG_WIDTH+OUT_FRAC_WIDTH = TSWIDTH (declared in wrapper)
      );

    // local parameters
    localparam FRAME_WIDTH       = 66;
    localparam FIFO_FRAC_WIDTH   = 6;
    localparam APPEND_FRAC_WIDTH = (OUT_FRAC_WIDTH-FIFO_FRAC_WIDTH);
    localparam ACCUM_WIDTH       = 12; // >= numdata_width + log2(frame_width*queue_depth) = 5 + 7
    
    localparam XCVR_APPEND_FRAC_WIDTH = 12;
    
    // internal registers and wires
    reg                                          valid;
    reg  [NUMDATA_WIDTH-1:0]                     numdata_reg;
    reg  [NUMDATA_WIDTH-1:0]                     numdata_q[FRAME_WIDTH-1:0];
    reg  [6:0]                                   numdata_valid_idx, numdata_valid_idx_m1, numdata_valid_idx_reg; // data width=log2(FRAME_WIDTH*QUEUE_DEPTH)
    reg  [ACCUM_WIDTH-1:0]                       latency_accum;
    wire [ACCUM_WIDTH-1:0]                       latency_accum_out;
    reg  [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH+3:0]    latency_adj_fifo_r;
    wire [OUT_INTG_WIDTH+FIFO_FRAC_WIDTH-1:0]    latency_adj_fifo;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0]     latency_adj_fifo_sum;
    reg                                          latency_add_state;
	wire [11:0] latency_xcvr_div2;
	
	assign latency_xcvr_div2 = latency_xcvr >> 1;  // /2 to convert from fast clock cycle to slow clock cycle. 

    
    reg  [12+XCVR_APPEND_FRAC_WIDTH-1:0]     latency_accum_xcvr_sum;
    
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] latency_accum_xcvr;
    
    generate if(DEVICE_FAMILY == "Stratix 10") 
    begin
        wire latency_accum_val_xcvr;
        reg [11:0] latency_accum_out_xcvr;
        // reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH - 1:0] latency_accum_xcvr_tx_div66;
        // reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH - 1:0] latency_accum_xcvr_rx_div66;
        // reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH - 1:0] latency_accum_xcvr_tx_mult40;
        // reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH - 1:0] latency_accum_xcvr_rx_mult40;

        // cross over to 125MHz domain
        alt_mge16_pcs_clock_crosser 
            #(.BITS_PER_SYMBOL(12))
        latency_pulse_rx_transfer (.in_clk(latency_sclk),
                                  .in_reset(latency_sclk_reset),
                                  .in_ready(),
                                  .in_valid(1'b1),
                                  .in_data(latency_xcvr_div2),
                                  .out_clk(clk),
                                  .out_reset(~rst_n),
                                  .out_ready(1'b1),
                                  .out_valid(latency_accum_val_xcvr),
                                  .out_data(latency_accum_out_xcvr));
                                  
    
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
                   //latency_accum_xcvr_rx_div66 <= (((latency_accum_out_xcvr_rx << (10+(FIFO_FRAC_WIDTH))) - ((latency_accum_out_xcvr_rx << (5+(FIFO_FRAC_WIDTH))) - (latency_accum_out_xcvr_rx << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                   //          >> 16) // divide by 65536
                   //          / 1;   // QUEUE_DEPTH=1
                   
                   latency_accum_xcvr_sum <= ({latency_accum_out_xcvr,{10{1'b0}}} >> 1) - ({latency_accum_out_xcvr,{10{1'b0}}} >> 6) + ({latency_accum_out_xcvr,{10{1'b0}}} >> 11) 
                                               + ({latency_accum_out_xcvr,{10{1'b0}}} >> 3) - ({latency_accum_out_xcvr,{10{1'b0}}} >> 8) + ({latency_accum_out_xcvr,{10{1'b0}}} >> 13);  
        
                    
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
    always @(posedge sample_clk or negedge sample_rst_n) begin
        if (sample_rst_n == 0) begin
            numdata_valid_idx <= 7'd0;
            numdata_valid_idx_reg <= 7'd1;
            numdata_valid_idx_m1 <= 7'd65; // FRAME_WIDTH*QUEUE_DEPTH-1
            latency_accum <= {ACCUM_WIDTH{1'b0}};
            valid <= 1'b0;
            numdata_q <= '{FRAME_WIDTH{1'b0}};
            numdata_reg <= {NUMDATA_WIDTH{1'b0}};
        end else begin
            if (numdata_valid_idx == 7'd65) begin // FRAME_WIDTH*QUEUE_DEPTH-1
                valid <= 1'b1;
                numdata_valid_idx <= 7'd0;
                numdata_valid_idx_reg <= 7'd1;
                numdata_reg <= numdata_q[0];
            end else begin
                valid <= valid;
                numdata_valid_idx <= numdata_valid_idx + 7'd1;
                numdata_valid_idx_reg <= numdata_valid_idx + 7'd2;
                if (valid) begin
                    numdata_reg <= numdata_q[numdata_valid_idx_reg];
                end else begin
                    numdata_reg <= {NUMDATA_WIDTH{1'b0}};
                end
            end
    
            if (numdata_valid_idx_m1 == 7'd65) begin // FRAME_WIDTH*QUEUE_DEPTH-1
                numdata_valid_idx_m1 <= 7'd0;
            end else begin
                numdata_valid_idx_m1 <= numdata_valid_idx_m1 + 7'd1;
            end


            numdata_q[numdata_valid_idx] <= numdata;

            latency_accum <= (latency_accum + numdata) - numdata_reg;

            // Build some assertions to avoid overflow
        end
    end

    // transfer accummulated fill-level / numdata
    wire latency_accum_val;

    alt_mge16_pcs_clock_crosser #(
        .BITS_PER_SYMBOL(ACCUM_WIDTH),
        .USE_OUTPUT_PIPELINE(1)
    ) latency_transfer (
        .in_clk(sample_clk),
        .in_reset(~sample_rst_n),
        .in_ready(),
        .in_valid(valid),
        .in_data({latency_accum}),
        .out_clk(clk),
        .out_reset(~rst_n),
        .out_ready(1'b1),
        .out_valid(latency_accum_val),
        .out_data({latency_accum_out})
    );

    // latency_adj_fifo_sum = latency_adj_fifo + PCS Offset
    // This is the full formula (too slow)
    //         latency_adj <= OFFSET + 
    //                        (latency_accum_out << OUT_FRAC_WIDTH) / (FRAME_WIDTH*QUEUE_DEPTH) -
    //                        ((sm_out) ? (1'b1 << OUT_FRAC_WIDTH) : 0);

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            latency_adj_fifo_sum <= OFFSET;
            latency_add_state <= 1'b0;
            latency_adj_fifo_r <= {(OUT_INTG_WIDTH+FIFO_FRAC_WIDTH){1'b0}};
        end else begin
            if (latency_accum_val) begin
                // Rather than divide by 66...
                // 1/66 ~= 993/65536 ~= (1024 - 31)/65536
                // error = 0.0000004x, where x = accum. fill level = avg. fill level * 66
                // max fill level = 32  ==>  max error = 0.0008448cycle / 5.40672 ps (negligible)
                latency_adj_fifo_r <= (((latency_accum_out << (10+FIFO_FRAC_WIDTH)) - ((latency_accum_out << (5+FIFO_FRAC_WIDTH)) - (latency_accum_out << (FIFO_FRAC_WIDTH))) ) // x (1024 - 31)
                             >> 16) // divide by 65536
                             / 1;   // QUEUE_DEPTH=1
                             
                latency_add_state <= 1'b1;
            end else if (latency_add_state) begin
                latency_adj_fifo_sum <= latency_accum_xcvr[OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] + {latency_adj_fifo,{APPEND_FRAC_WIDTH{1'b0}}} + OFFSET;
                latency_add_state <= 1'b0;
            end else begin
                latency_adj_fifo_sum <= latency_adj_fifo_sum;
                latency_add_state <= 1'b0;
            end
        end
    end
    
    assign latency_adj_fifo = latency_adj_fifo_r[OUT_INTG_WIDTH+FIFO_FRAC_WIDTH-1:0];


    // Inaccuracy caused by ppm
    localparam PPM_CNTR_WIDTH=20; // ppm counter: 20-bit of fractional cycle
    wire [PPM_CNTR_WIDTH-1:0] ppm_out;
    wire [PPM_CNTR_WIDTH-1:0] ppm;
    wire ppm_sign;
    
    assign ppm = (TX_RX) ? ppm_out : {PPM_CNTR_WIDTH{1'b0}};
    
    alt_mge_phy_xgmii_1588_ppm_counter
    #(
        .PPM_CNTR_WIDTH(PPM_CNTR_WIDTH)
        ) ppm_cntr
        (
        .clk_a(clk),
        .clk_a_data_valid (1'b1),
        .clk_b(sample_clk),
        .rst_a_n(rst_n),
        .rst_b_n(sample_rst_n),
        .clk_b_data_valid(sample_clk_data_valid),
        .clk_a_block_lock(clk_block_lock),
        .ppm_sign(ppm_sign),
        .speed_mode (3'd1),
        .ppm(ppm_out)
        );
     
    // ppm_gap : used in normal condition. it eliminates the inaccuracy caused by averager (in phase calculator) when ppm presents.
    // ppm_gap = max_drift/2 = (66 sample_clk cycle * ppm/cycle) / 2 = (IDWIDTH clk cycle * ppm/cycle) / 2
    reg [5:0]  ppm_gap_cntr;
    reg [OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1:0] ppm_gap_reg;
    reg [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_gap;
    
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            ppm_gap_cntr <= {6{1'b0}};
            ppm_gap_reg  <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            ppm_gap      <= {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};
            
        end else begin
            if (ppm_gap_cntr == 6'd0)begin
                ppm_gap_cntr <= (IDWIDTH >> 1);     // (IDWIDTH clk cycle) / 2
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
    wire [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_accum_normal;
    wire [FIFO_FRAC_WIDTH-1:0] latency_adj_fifo_frac;
    reg  [FIFO_FRAC_WIDTH-1:0] latency_adj_fifo_frac_pre;
    
    assign latency_adj_fifo_frac = latency_adj_fifo[FIFO_FRAC_WIDTH-1:0];
    assign ppm_accum_normal = ppm_accum_normal_reg[(OUT_INTG_WIDTH+PPM_CNTR_WIDTH-1):(PPM_CNTR_WIDTH-OUT_FRAC_WIDTH)]; // cut the extra 10-bit of frac. cycle
    
    // ppm_accum_normal_reg: accummulate ppm (20-bit fractional cycle)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            latency_adj_fifo_frac_pre <= {FIFO_FRAC_WIDTH{1'b0}};
            ppm_accum_normal_reg      <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
        end
        else begin
            latency_adj_fifo_frac_pre <= latency_adj_fifo_frac;
            
            if (latency_adj_fifo_frac_pre != latency_adj_fifo_frac) begin
                // latency_adj_fifo_sum updated, re-accummulate ppm
                ppm_accum_normal_reg <= {(OUT_INTG_WIDTH+PPM_CNTR_WIDTH){1'b0}};
            end
            else begin
                ppm_accum_normal_reg <= ppm_accum_normal_reg + ppm;
            end    
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
    
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] octet_del_num_reg;
    reg  [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] latency_adj_reg;
    wire [OUT_INTG_WIDTH+OUT_FRAC_WIDTH-1:0] ppm_normal;
    
    // ppm_sign = 1: rd_clk faster than wr_clk (-ve ppm)
    // ppm_sign = 0: rd clk slower than wr_clk (+ve ppm)
    //assign ppm_normal = (TX_RX) ? (ppm_sign ? (ppm_gap - ppm_accum_normal) : (ppm_gap + ppm_accum_normal) ) : // RX
    //                              {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};                                    // TX
    assign ppm_normal = {(OUT_INTG_WIDTH+OUT_FRAC_WIDTH){1'b0}};

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            octet_del_num_reg   <= 'd0;
            latency_adj         <= OFFSET;
            latency_adj_reg     <= OFFSET;
        end else begin
            octet_del_num_reg <= (octet_del_num<<(OUT_FRAC_WIDTH-1));
            if(octet_del_en) begin // ratematch / deletion
                latency_adj         <= latency_adj_reg - octet_del_num_reg + ppm_accum_rm;
                latency_adj_reg     <= latency_adj_reg;
            end
            else if(octet_ins_en) begin // ratematch / insertion
                latency_adj         <= latency_adj_reg + (octet_ins_num<<(OUT_FRAC_WIDTH-1)) - ppm_accum_rm;
                latency_adj_reg     <= latency_adj_reg;
            end
            else begin // normal
                if (wr_del_sm == 2'b01) begin
                    latency_adj         <= latency_adj_fifo_sum - 10'b100_000_0000 + ppm_normal;
                    latency_adj_reg     <= latency_adj_fifo_sum - 10'b100_000_0000 + ppm_normal;
                end
                else if (wr_del_sm == 2'b10) begin
                    latency_adj         <= latency_adj_fifo_sum + 10'b100_000_0000 + ppm_normal;
                    latency_adj_reg     <= latency_adj_fifo_sum + 10'b100_000_0000 + ppm_normal;           
                end
                else begin
                    latency_adj         <= latency_adj_fifo_sum + ppm_normal;
                    latency_adj_reg     <= latency_adj_fifo_sum + ppm_normal;
                end
            end
        end
    end


endmodule // alt_mge_phy_xgmii_1588_latency
