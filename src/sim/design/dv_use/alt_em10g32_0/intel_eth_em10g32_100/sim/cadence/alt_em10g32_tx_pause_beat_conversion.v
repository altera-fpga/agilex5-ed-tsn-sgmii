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


`timescale 1ns / 1ns
module alt_em10g32_tx_pause_beat_conversion(
    
    //Common clock and Reset
    clk,
    reset_n,
    
    // Pause Quanta Sink
    pause_quanta_sink_valid,
    pause_quanta_sink_data,
    
    // Pause Beat Source
    pause_beat_src_valid,
    pause_beat_src_data,
	
    // Pause Quanta is XON
    pq_is_xon,
    // speed
    speed_sel
    );

    // =head1 GLOBAL PARAMETERS
    parameter ENABLE_1G10G_MAC              = 0;
    parameter ENABLE_10GBASER_REG_MODE      = 0;
    
    // =head2 Avalon Streaming
    localparam BITSPERSYMBOL                = 8;  // Streaming Data symbol width in bits
    localparam SYMBOLSPERBEAT               = 8;  // Streaming Number of symbols per word
    
    // =head1 LOCAL PARAMETERS
    
    // =head2 Avalon Streaming
    localparam DATA_WIDTH                   = BITSPERSYMBOL * SYMBOLSPERBEAT;
    
    localparam PAUSE_QUANTA_WIDTH           = 16;
    localparam PAUSE_BEAT_WIDTH             = 32;
    
    localparam PAUSEQ_TO_BEATS              = divceil(512, DATA_WIDTH); // Value of 1 pause quanta in beats
    
    //Update the latency number if in any case the module between tx_packet_backpressure <= x => tx_gmii_encoder changes it latency.
    //Latency for backpressure data valid deassertion, till tx_encoder's tx_en goes low.
    //It take 254cycle of timer counts to propogate !data_valid until tx_en goes low.  
    //Base on simulation 254cycle@6.4ns is giving an additional of 128bits time delay@GMII.
    //128bit@gmii = 16cycle@8ns = 128ns
    //128ns/6.4ns= 20 cycle   
    // Set GMII_PATH_LATENCY to 234
    // Uodated: measure from frame_gen, frm_sink_eop assertion to rs layer gmii_tx_en deassertion
    // for NGBase-T mode, all the path latency will be 0. This is because there is no clock cross 
    
    localparam GMII_5G_PATH_LATENCY         = 20;
    localparam GMII_2_5G_PATH_LATENCY       = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 45 : 
                                              (ENABLE_1G10G_MAC == 5) ? 40 : 95;
                                              // should be 32 only for nbaset. i added some buffer
    localparam GMII_PATH_LATENCY            = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 112 :
                                              (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7) ? 234 : 
                                              (ENABLE_1G10G_MAC == 5) ? 100 : 16'd234;
    localparam MII_100_PATH_LATENCY         = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 1242 :
                                              (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7) ? 2544 : 16'd2399;
    localparam MII_10_PATH_LATENCY         =  (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 12493 :
                                              (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7) ? 25493 : 16'd24056;
    //localparam MII_100_PATH_LATENCY         = 2399;
  //  localparam MII_10_PATH_LATENCY          = 24056;
    localparam GMII_5G_PAUSEQ_TO_BEATS      = 16'd32; // Half of 10G rate
    localparam GMII_2_5G_PAUSEQ_TO_BEATS    = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 16'd32 : 16'd64;                                              
                                              //156.25MHz: 512/16 * 156.25/156.25 = 32
                                              //312.5MHz: 512/16 * 312.5/156.25 = 64
    localparam GMII_PAUSEQ_TO_BEATS         = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 16'd80 :
                                              (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7) ? 16'd160 : 16'd160;
                                                        //156.25MHz: 512/16 * 156.25/62.5 = 80
                                                        //312.5MHz: 512/16 * 312.5/62.5 = 160
                                                        //312.5MHz: 512/8 * 312.5/125 = 160
                                                        
                                                        
    localparam MII_100_PAUSEQ_TO_BEATS      = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 16'd800 :
                                              (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7) ? 16'd1600 : 16'd1600;
    //localparam MII_100_PAUSEQ_TO_BEATS      = 16'd1600; //312.5MHz: 512/4 * 312.5/25 = 1600
    localparam MII_10_PAUSEQ_TO_BEATS       = (ENABLE_1G10G_MAC == 3 || ENABLE_1G10G_MAC == 6) ? 16'd8000 :
                                              (ENABLE_1G10G_MAC == 4 || ENABLE_1G10G_MAC == 7) ? 16'd16000 : 16'd16000;
    //localparam MII_10_PAUSEQ_TO_BEATS       = 16'd16000;//312.5MHz: 512/4 * 312.5/2.5 = 16000
    
    
    
    // =head1 PINS
    
    // =head2 Clock Interface
    input                               clk;
    input                               reset_n;
    
    // =head2 Avalon ST Pause Quanta Sink Interface
    input                               pause_quanta_sink_valid;
    input [PAUSE_QUANTA_WIDTH - 1:0]    pause_quanta_sink_data;
    
    input [2:0]                         speed_sel;
	
    // =head2 Avalon ST Pause Beat Source Interface
    output                              pause_beat_src_valid;
    output reg[PAUSE_BEAT_WIDTH - 1:0]  pause_beat_src_data;
    
    output reg                          pq_is_xon; // This signal is align to pause_beat_src_valid
    
    wire    [31:0]                      result_pause_quanta;
    wire    [15:0]                      sel_pause_quanta;
    
    wire    reset;
    
    assign reset = !reset_n;


    reg pause_quanta_sink_valid_pline1;
    reg pause_quanta_sink_valid_pline2;
    reg pause_quanta_sink_valid_pline3;
    reg pause_quanta_sink_valid_pline4;
    
    reg pq_is_xoff1_pline1;
    reg pq_is_xoff2_pline1;
    reg pq_is_xoff3_pline1;
    reg pq_is_xoff4_pline1;
    reg pq_is_xoff5_pline1;
    reg pq_is_xoff6_pline1;
    reg pq_is_xoff1_pline2;
    reg pq_is_xoff2_pline2;
    reg pq_is_xoff_pline3;
    
    wire    [31:0]  result000; //10G    
    wire    [31:0]  result001; //1G   
    wire    [31:0]  result010; //100M   
    wire    [31:0]  result011; //10M
    wire    [31:0]  result100; //2.5G
    wire    [31:0]  result101; //5G
	
	wire	[31:0]	result001_frm_mult;
	wire	[31:0]	result010_frm_mult;
	wire	[31:0]	result011_frm_mult;
    wire    [31:0]  result100_frm_mult;
    wire    [31:0]  result101_frm_mult;

    //  ENABLE_1G10G_MAC ALLOWED_RANGES
    //  "0:10G"
    //  "1:1G/10G"
    //  "2:10M/100M/1G/10G"
    //  "3:1G/2.5G"
    //  "4:1G/2.5G/5G/10G (MGBASE-T)"
    //  "5:1G/2.5G/5G/10G (NGBASE-T)"
	
	assign result001 = (ENABLE_1G10G_MAC != 0)?result001_frm_mult:32'b0;
	assign result010 = ((ENABLE_1G10G_MAC == 2) || (ENABLE_1G10G_MAC == 5) || (ENABLE_1G10G_MAC == 6) || (ENABLE_1G10G_MAC == 7))?result010_frm_mult:32'b0;
	assign result011 = ((ENABLE_1G10G_MAC == 2) || (ENABLE_1G10G_MAC == 5) || (ENABLE_1G10G_MAC == 6) || (ENABLE_1G10G_MAC == 7))?result011_frm_mult:32'b0;
    assign result100 = ((ENABLE_1G10G_MAC == 3) || (ENABLE_1G10G_MAC == 4) || (ENABLE_1G10G_MAC == 5) || (ENABLE_1G10G_MAC == 6)|| (ENABLE_1G10G_MAC == 7))?result100_frm_mult:32'b0;
    assign result101 = ((ENABLE_1G10G_MAC == 4) || (ENABLE_1G10G_MAC == 5 ) || (ENABLE_1G10G_MAC == 6 ) || (ENABLE_1G10G_MAC == 7 ))?result101_frm_mult:32'b0;
    
    assign pause_beat_src_valid = pause_quanta_sink_valid_pline4;

    // SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!reset_n)
            begin
            pq_is_xoff1_pline1 <= 1'b0;
            pq_is_xoff2_pline1 <= 1'b0;
            pq_is_xoff3_pline1 <= 1'b0;
            pq_is_xoff4_pline1 <= 1'b0;
            pq_is_xoff5_pline1 <= 1'b0;
            pq_is_xoff6_pline1 <= 1'b0;
            pq_is_xoff1_pline2 <= 1'b0;
            pq_is_xoff2_pline2 <= 1'b0;
            pq_is_xoff_pline3  <= 1'b0;
            pq_is_xon          <= 1'b0;
            end
        else
            begin
            // Separate 16-bit OR operation into 6 flops for better timing performance
            pq_is_xoff1_pline1 <= (|pause_quanta_sink_data[2:0]);
            pq_is_xoff2_pline1 <= (|pause_quanta_sink_data[5:3]);
            pq_is_xoff3_pline1 <= (|pause_quanta_sink_data[8:6]);
            pq_is_xoff4_pline1 <= (|pause_quanta_sink_data[11:9]);
            pq_is_xoff5_pline1 <= (|pause_quanta_sink_data[14:12]);
            pq_is_xoff6_pline1 <= (pause_quanta_sink_data[15]);
            pq_is_xoff1_pline2 <= (pq_is_xoff1_pline1 | pq_is_xoff2_pline1 | pq_is_xoff3_pline1);
            pq_is_xoff2_pline2 <= (pq_is_xoff4_pline1 | pq_is_xoff5_pline1 | pq_is_xoff6_pline1);
            pq_is_xoff_pline3  <= (pq_is_xoff1_pline2 | pq_is_xoff2_pline2);
            pq_is_xon          <= !pq_is_xoff_pline3;
            end
        end

    // SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if (pq_is_xoff_pline3)
            begin
            case(speed_sel)
            3'b000:pause_beat_src_data <= result000;
            3'b001:pause_beat_src_data <= result001 + GMII_PATH_LATENCY;
            3'b010:pause_beat_src_data <= result010 + MII_100_PATH_LATENCY;
            3'b011:pause_beat_src_data <= result011 + MII_10_PATH_LATENCY;
            3'b100:pause_beat_src_data <= result100 + GMII_2_5G_PATH_LATENCY;
            3'b101:pause_beat_src_data <= result101 + GMII_5G_PATH_LATENCY;
            default:pause_beat_src_data <= 32'b0;
            endcase
            end
        else
            begin
            pause_beat_src_data <= 32'b0;
            end
        end
    

    // SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!reset_n)
            begin
            pause_quanta_sink_valid_pline1 <= 1'b0;
            pause_quanta_sink_valid_pline2 <= 1'b0;
            pause_quanta_sink_valid_pline3 <= 1'b0;
            pause_quanta_sink_valid_pline4 <= 1'b0;
            end
        else
            begin
            pause_quanta_sink_valid_pline1 <= pause_quanta_sink_valid;
            pause_quanta_sink_valid_pline2 <= pause_quanta_sink_valid_pline1;
            pause_quanta_sink_valid_pline3 <= pause_quanta_sink_valid_pline2;
            pause_quanta_sink_valid_pline4 <= pause_quanta_sink_valid_pline3;
            end
        end
        
   
    
    lpm_mult  #(
    .lpm_hint               ("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"),
    .lpm_pipeline           (3),
    .lpm_representation     ("UNSIGNED"),
    .lpm_type               ("LPM_MULT"),
    .lpm_widtha             (16),
    .lpm_widthb             (16),
    .lpm_widthp             (32)
    )mutiplyer001 (
    	.clock (clk),
		.dataa (pause_quanta_sink_data),
		.datab (GMII_PAUSEQ_TO_BEATS),  //direct use the value because of integer is 32 bits and it will cause vhdl simulation
		.result (result001_frm_mult),
		.aclr (1'b0),
        .sclr (1'b0),
		.clken (1'b1),
		.sum (1'b0)
   
    ); 
    
    
generate
if(ENABLE_10GBASER_REG_MODE) begin : BASER_REG_MODE_MULT
    assign result000 = (pause_quanta_sink_data << 4) + (pause_quanta_sink_data >> 1) + 1'b1;
end
else begin : LPM_MULT
    lpm_mult  #(
    .lpm_hint               ("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"),
    .lpm_pipeline           (3),
    .lpm_representation     ("UNSIGNED"),
    .lpm_type               ("LPM_MULT"),
    .lpm_widtha             (16),
    .lpm_widthb             (16),
    .lpm_widthp             (32)
    
    )mutiplyer000 (
    	.clock (clk),
		.dataa (pause_quanta_sink_data),
		.datab (16'd16),
		.result (result000),
		.aclr (1'b0),
        .sclr (1'b0),
		.clken (1'b1),
		.sum (1'b0)
   
    ); 
end
endgenerate
    
    
    lpm_mult  #(
    .lpm_hint               ("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"),
    .lpm_pipeline           (3),
    .lpm_representation     ("UNSIGNED"),
    .lpm_type               ("LPM_MULT"),
    .lpm_widtha             (16),
    .lpm_widthb             (16),
    .lpm_widthp             (32)
    
    )mutiplyer010 (
    	.clock (clk),
		.dataa (pause_quanta_sink_data),
		.datab (MII_100_PAUSEQ_TO_BEATS),
		.result (result010_frm_mult),
		.aclr (1'b0),
        .sclr (1'b0),
		.clken (1'b1),
		.sum (1'b0)
   
    );
    
    lpm_mult  #(
    .lpm_hint               ("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"),
    .lpm_pipeline           (3),
    .lpm_representation     ("UNSIGNED"),
    .lpm_type               ("LPM_MULT"),
    .lpm_widtha             (16),
    .lpm_widthb             (16),
    .lpm_widthp             (32)   
    
    )mutiplyer011 (
    	.clock (clk),
		.dataa (pause_quanta_sink_data),
		.datab (MII_10_PAUSEQ_TO_BEATS),
		.result (result011_frm_mult),
		.aclr (1'b0),
        .sclr (1'b0),
		.clken (1'b1),
		.sum (1'b0)
   
    );
   
lpm_mult  #(
    .lpm_hint               ("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"),
    .lpm_pipeline           (3),
    .lpm_representation     ("UNSIGNED"),
    .lpm_type               ("LPM_MULT"),
    .lpm_widtha             (16),
    .lpm_widthb             (16),
    .lpm_widthp             (32)   
    
) mutiplyer100 (
  	.clock (clk),
	.dataa (pause_quanta_sink_data),
	.datab (GMII_2_5G_PAUSEQ_TO_BEATS),
	.result (result100_frm_mult),
	.aclr (1'b0),
    .sclr (1'b0),
	.clken (1'b1),
	.sum (1'b0)
);        

lpm_mult  #(
    .lpm_hint               ("INPUT_B_IS_CONSTANT=YES,MAXIMIZE_SPEED=5"),
    .lpm_pipeline           (3),
    .lpm_representation     ("UNSIGNED"),
    .lpm_type               ("LPM_MULT"),
    .lpm_widtha             (16),
    .lpm_widthb             (16),
    .lpm_widthp             (32)
    
) mutiplyer101 (
  	.clock (clk),
	.dataa (pause_quanta_sink_data),
	.datab (GMII_5G_PAUSEQ_TO_BEATS),
	.result (result101_frm_mult),
	.aclr (1'b0),
    .sclr (1'b0),
	.clken (1'b1),
	.sum (1'b0)
);
    
    
    // --------------------------------------------------
    // Calculates the divceil of the input value (m/n)
    // --------------------------------------------------
    function integer divceil;
        input integer m;
		input integer n;
        integer i;
        
        begin
            i = m % n;
            divceil = (m/n);
            if (i > 0) begin
                divceil = divceil + 1;
			end
        end
    endfunction
    
endmodule

// =head1 SEE ALSO
// 
// =cut
