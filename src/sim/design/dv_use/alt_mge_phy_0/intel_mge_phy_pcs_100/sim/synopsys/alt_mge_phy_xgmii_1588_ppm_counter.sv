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


//------------------------------------------------------------------------
// Description:
// ppm counter
// run a counter at both pcs_clk and mac_clk domains respectively to know the ppm difference between these two clocks
// 'ppm' output gives ppm difference in fractional cycle unit
// ppm = (cntr_a - cntr_b)/cntr_a
// for easy division, cntr_b is sampled at time cntr_a equals to the following 3 values respectively:
// BIT_14: 0000_0100_0000_0000_0000 // 14-right-shift or 6-left-shift to perform division
// BIT_17: 0010_0000_0000_0000_0000 // 17-right-shift or 3-left-shift to perform division
// BIT_19: 1000_0000_0000_0000_0000 // 19-right-shift or 1-left-shift to perform division
//------------------------------------------------------------------------
`timescale 1 ps/1 ps
module alt_mge_phy_xgmii_1588_ppm_counter
  #(
    parameter PPM_CNTR_WIDTH = 20
    )
    (
    input  wire                     clk_a,            // clock a
    input  wire                     clk_b,            // clock b
    input  wire                     rst_a_n,          // reset a
    input  wire                     rst_b_n,          // reset b
    input  wire                     clk_a_data_valid, //usxgmii data valid, clk a
    input  wire                     clk_b_data_valid, // gearbox effect to clock b
    input  wire                     clk_a_block_lock, // block lock signal (sync-ed to clock a)
    output reg                      ppm_sign,         // 1 if clk_a faster than clk_b
    input wire [2:0]                      speed_mode,
    output reg [PPM_CNTR_WIDTH-1:0] ppm               // ppm calculated
     );

    localparam START  = 2'h0;          // ppm counter state 0
    localparam BIT_14 = 2'h1;          // ppm counter state 1
    localparam BIT_17 = 2'h2;          // ppm counter state 2
    localparam BIT_19 = 2'h3;          // ppm counter state 3

    reg  [1:0] state;
    reg  [PPM_CNTR_WIDTH-1:0] cntr_a;
    reg  sample_cntr_a;
    reg  run_cntr_a;
    reg  checked_bit19;
    reg  [1:0] rest_time;
    wire cntr_b_out_valid;
    wire [PPM_CNTR_WIDTH-1:0] cntr_b_out;
    reg  [PPM_CNTR_WIDTH-1:0] cntr_b;
    wire sample_cntr_b;
    wire run_cntr_b;
    wire rst_a_n_final_flop;
    reg rst_a_n_final;
    wire sync_rst_b_n, sync_rst_b;
    wire speed_change;
    reg [2:0] speed_mode_reg;
    wire [2:0] speed_mode_sync;

alt_mge_phy_std_synchronizer_bundle #(3, 3) speed_mode_5sync (
    .clk    (clk_a),
    .reset_n(rst_a_n),
    .din    (speed_mode),
    .dout   (speed_mode_sync)
);  
    

  always @ (posedge clk_a or negedge rst_a_n) begin
     if (~rst_a_n) begin
     speed_mode_reg <= 1'b0;
        
        end
        else begin
     
     speed_mode_reg <= speed_mode_sync;
     
     end 
 end
 assign speed_change = (speed_mode_reg == speed_mode_sync) ? 1 :0 ;
    // run cntr_a (initiator) only if both rst_a_n and rst_b_n are releaased, and block lock is up.
    // before block lock is up, clk_b_data_valid shows inaccurate ppm value.
    assign rst_a_n_final_flop = rst_a_n & sync_rst_b_n & clk_a_block_lock & speed_change;
    
    // Get rid of DA warning R101: Combinational logic used as a reset signal should be synchronized.
    always @ (posedge clk_a or negedge rst_a_n) begin
        if (~rst_a_n) begin
            rst_a_n_final <= 1'b0;
        
        end
        else begin
            rst_a_n_final <= rst_a_n_final_flop;
        end
    end

    // reset synchronizer
    alt_mge16_pcs_reset_synchronizer reset_sync (
        .clk        (clk_a),
        .reset_in   (~rst_b_n),
        .reset_out  (sync_rst_b)
    );
    assign sync_rst_b_n = ~sync_rst_b;
    
    // clk_a counter
	 //ED remove async Clear
	 always @(posedge clk_a or negedge rst_a_n_final) begin
    //always @(posedge clk_a or negedge rst_a_n_final) begin
        if (~rst_a_n_final) begin
            state <= 2'd0;
            cntr_a <= {PPM_CNTR_WIDTH{1'b0}};
            sample_cntr_a <= 1'b0;
            run_cntr_a <= 1'b0;
            rest_time <= 2'd0;
            ppm <= {PPM_CNTR_WIDTH{1'b0}};
            ppm_sign <= 1'b0;
            checked_bit19 <= 1'b0;
        end
        else begin
            case (state)
                START: begin
                
                    
                
                    run_cntr_a <= 1'b1;
                    checked_bit19 <= 1'b0;
                    if (clk_a_data_valid) begin
                    cntr_a <= cntr_a + 20'd1;
                    end 
                    if (cntr_a[14]) begin
                        sample_cntr_a <= 1'b1;
                        state <= BIT_14;
                    end
                    else begin
                        sample_cntr_a <= 1'b0;
                        state <= state;
                    end
                end
                BIT_14: begin
                    run_cntr_a <= 1'b1;
                    checked_bit19 <= 1'b0;
                     if (clk_a_data_valid) begin
                    cntr_a <= cntr_a + 20'd1;
                    end 
                   
                    if (cntr_b_out_valid) begin
                        if (cntr_b_out[14]) begin
                            ppm <= (cntr_b_out - 20'b0000_0100_0000_0000_0000) << 6;
                            ppm_sign <= 1'b0;
                        end
                        else begin
                            ppm <= (20'b0000_0100_0000_0000_0000 - cntr_b_out) << 6;
                            ppm_sign <= 1'b1;
                        end
                    end            
    
                    if (cntr_a[17]) begin
                        sample_cntr_a <= 1'b1;
                        state <= BIT_17;
                    end
                    else begin
                        sample_cntr_a <= 1'b0;
                        state <= state;
                    end                       
                
                end
                BIT_17: begin
                    // reset counter a
                    if (checked_bit19) begin
                        rest_time <= 2'd3;
                        run_cntr_a <= 1'b0;
                        cntr_a <= {PPM_CNTR_WIDTH{1'b0}};
                    end
                    else begin
                        if (rest_time == 2'd0) begin
                            rest_time <= 2'd0;
                            run_cntr_a <= 1'b1;
                             if (clk_a_data_valid) begin
                            cntr_a <= cntr_a + 20'd1;
                             end 
                            
                        end
                        else begin
                            rest_time <= rest_time - 2'd1;
                            run_cntr_a <= 1'b0;
                            cntr_a <= {PPM_CNTR_WIDTH{1'b0}};
                        end
                    end
                    checked_bit19 <= 1'b0;
                    
                    if (cntr_b_out_valid) begin
                        if (cntr_b_out[17]) begin
                            ppm <= (cntr_b_out - 20'b0010_0000_0000_0000_0000) << 3;
                            ppm_sign <= 1'b0;
                        end
                        else begin
                            ppm <= (20'b0010_0000_0000_0000_0000 - cntr_b_out) << 3;
                            ppm_sign <= 1'b1;
                        end
                    end            
    
                    if (cntr_a[19]) begin
                        sample_cntr_a <= 1'b1;
                        state <= BIT_19;
                    end
                    else begin
                        sample_cntr_a <= 1'b0;
                        state <= state;
                    end                       
                
                end
                BIT_19: begin
                    run_cntr_a <= 1'b0;
                    cntr_a <= {PPM_CNTR_WIDTH{1'b0}};
                    sample_cntr_a <= 1'b0;
                    checked_bit19 <= 1'b1;
                    if (cntr_b_out_valid) begin
                        if (cntr_b_out[19]) begin
                            ppm <= (cntr_b_out - 20'b1000_0000_0000_0000_0000) << 1;
                            ppm_sign <= 1'b0;
                        end
                        else begin
                            ppm <= (20'b1000_0000_0000_0000_0000 - cntr_b_out) << 1;
                            ppm_sign <= 1'b1;
                        end
                        state <= BIT_17;
                    end            
    
                end
                default: begin
                    state <= START;
                    run_cntr_a <= 1'b0;
                    cntr_a <= {PPM_CNTR_WIDTH{1'b0}};
                    sample_cntr_a <= 1'b0;
                    rest_time <= 2'd0;
                    ppm <= {PPM_CNTR_WIDTH{1'b0}};
                    ppm_sign <= 1'b0;
                    checked_bit19 <= 1'b0;
                end
            endcase
        
        end
    end
    
    // synchronizer clk_a to clk_b
    alt_mge_phy_std_synchronizer_bundle
    #(
        .width  (2),
        .depth  (2)
        ) counter_run_transfer (
        .clk    (clk_b),
        .reset_n(rst_b_n),
        .din    ({run_cntr_a, sample_cntr_a}),
        .dout   ({run_cntr_b, sample_cntr_b})
        ); 
    
    // clock crosser clk_b to clk_a
    alt_mge16_pcs_clock_crosser #(
        .BITS_PER_SYMBOL(PPM_CNTR_WIDTH),
        .USE_OUTPUT_PIPELINE(1)
    )
    ppm_cntr_b_transfer(.in_clk(clk_b),
                        .in_reset(~rst_b_n),
                        .in_ready(),
                        .in_valid(sample_cntr_b),
                        .in_data({cntr_b}),
                        .out_clk(clk_a),
                        .out_reset(~rst_a_n_final),
                        .out_ready(1'b1),
                        .out_valid(cntr_b_out_valid),
                        .out_data({cntr_b_out})
                        );
                        
    // clk_b counter
    always @(posedge clk_b or negedge rst_b_n) begin
        if (~rst_b_n) begin
            cntr_b <= {PPM_CNTR_WIDTH{1'b0}};
        end
        else begin
            if (~run_cntr_b) begin
                cntr_b <= {PPM_CNTR_WIDTH{1'b0}};
            end
            else begin
                if (clk_b_data_valid) begin
                    cntr_b <= cntr_b + 20'd1;
                end
            end
        end
    end

endmodule // ppm_counter
