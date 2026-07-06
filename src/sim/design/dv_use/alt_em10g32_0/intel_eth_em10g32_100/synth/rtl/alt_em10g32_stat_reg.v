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
module alt_em10g32_stat_reg (

 			//Common clock and Reset
            clk,
            csr_reset_n,
            
			//CSR Interface
            csr_read,
            csr_address,
            csr_readdata,
            csr_write,
            csr_writedata,
            
			//Av-ST Data Sink
			stat_sink_valid,
			stat_sink_data,
            stat_sink_error,
            
            // Parameters
            enable_pfc
	);
    
   // global parameters
   parameter SYNC_RESET_N = 1;
   
   // =head1 LOCAL PARAMETERS
 
   // =head2 Avalon Streaming
   localparam STATUS_WIDTH                   = 40;  // Streaming Number of symbols per word
   localparam ERROR_WIDTH                    = 7;

   // =head2 Avalon MM
   localparam CSR_DATAPATH_WIDTH 	     = 32;
   localparam CSR_ADDRESS_WIDTH              = 6; // 64 addresses
   
   // =head2 Others (size of statistic registers)
   localparam OCTET_REG_WIDTH	             = 64;
   localparam REG_WIDTH			     = 36;
   
   localparam CASE_WIDTH        = 2;
   localparam CASE_RESET_VALUE  = 2'b00;
   localparam CASE_CLEAR        = 2'b00;
   localparam CASE_CLEAR_UPDATE = 2'b01;
   localparam CASE_UPDATE       = 2'b10;
   localparam CASE_UNCHANGED    = 2'b11;
   
   // =head2 Clock Interface
   input                                                 clk;
   input                                                 csr_reset_n;
   
   // =head2 Avalon MM Slave CSR Interface
   input                                                 csr_read;
   input                                                 csr_write;
   input       [(CSR_ADDRESS_WIDTH)-1:0]                 csr_address;
   output      [(CSR_DATAPATH_WIDTH)-1:0]	             csr_readdata;
   input       [(CSR_DATAPATH_WIDTH)-1:0]	             csr_writedata;

       
   // =head2 Avalon ST DataIn (Sink) Interface
   input                                                 stat_sink_valid;
   input       [(STATUS_WIDTH)-1:0]                      stat_sink_data;
   input       [(ERROR_WIDTH)-1:0]                       stat_sink_error;
   
   // Parameters
   input                                                 enable_pfc;

   
// For debugging purpose: to change reset value for statistic registers to other value than 0
localparam REG_RESET_VALUE = {REG_WIDTH{1'b0}};
localparam OCTET_REG_RESET_VALUE = {OCTET_REG_WIDTH{1'b0}};

// Set PIPELINE_STATUS to 1 for better timing, but use more resources
localparam PIPELINE_STATUS = 0;



 // ----------------------------------------------------------------------------
 // Local registers and wire declarations
 // ----------------------------------------------------------------------------
	
	// Statistics Registers (wraparound counters)	
	reg [(REG_WIDTH-1):0] framesOK;
        reg [(REG_WIDTH-1):0] framesErr;
        reg [(REG_WIDTH-1):0] framesCRCErr;
        reg [(REG_WIDTH-1):0] pauseMACCtrlFrames;
        reg [(REG_WIDTH-1):0] pfcMACCtrlFrames;
        reg [(REG_WIDTH-1):0] ifErrors;
        reg [(REG_WIDTH-1):0] unicastFramesOK;
        reg [(REG_WIDTH-1):0] unicastFramesErr;
        reg [(REG_WIDTH-1):0] multicastFramesOK;
        reg [(REG_WIDTH-1):0] multicastFramesErr;
        reg [(REG_WIDTH-1):0] broadcastFramesOK;
        reg [(REG_WIDTH-1):0] broadcastFramesErr;        
        reg [(REG_WIDTH-1):0] etherStatsPkts;
        reg [(REG_WIDTH-1):0] etherStatsUndersizePkts;
        reg [(REG_WIDTH-1):0] etherStatsPkts64Octets;
        reg [(REG_WIDTH-1):0] etherStatsPkts65to127Octets;
        reg [(REG_WIDTH-1):0] etherStatsPkts128to255Octets;
        reg [(REG_WIDTH-1):0] etherStatsPkts256to511Octets;
        reg [(REG_WIDTH-1):0] etherStatsPkts512to1023Octets;
        reg [(REG_WIDTH-1):0] etherStatsPkts1024to1518Octets;
        reg [(REG_WIDTH-1):0] etherStatsPkts1519toXOctets;
        reg [(REG_WIDTH-1):0] etherStatsFragments;
        reg [(REG_WIDTH-1):0] etherStatsJabbers;
        reg [(REG_WIDTH-1):0] etherStatsOversizePkts;
        reg [(REG_WIDTH-1):0] etherStatsCRCErr;
        reg [(REG_WIDTH-1):0] unicastMACCtrlFrames;
        reg [(REG_WIDTH-1):0] multicastMACCtrlFrames;
        reg [(REG_WIDTH-1):0] broadcastMACCtrlFrames;

        reg [(OCTET_REG_WIDTH-1):0] octetsOK;
        reg [(OCTET_REG_WIDTH-1):0] etherStatsOctets;
        
        // Event to control value of statistics counters
        reg [(CASE_WIDTH-1):0] case_framesOK;
        reg [(CASE_WIDTH-1):0] case_framesErr;
        reg [(CASE_WIDTH-1):0] case_framesCRCErr;
        reg [(CASE_WIDTH-1):0] case_pauseMACCtrlFrames;
        reg [(CASE_WIDTH-1):0] case_pfcMACCtrlFrames;
        reg [(CASE_WIDTH-1):0] case_ifErrors;
        reg [(CASE_WIDTH-1):0] case_unicastFramesOK;
        reg [(CASE_WIDTH-1):0] case_unicastFramesErr;
        reg [(CASE_WIDTH-1):0] case_multicastFramesOK;
        reg [(CASE_WIDTH-1):0] case_multicastFramesErr;
        reg [(CASE_WIDTH-1):0] case_broadcastFramesOK;
        reg [(CASE_WIDTH-1):0] case_broadcastFramesErr;        
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts;
        reg [(CASE_WIDTH-1):0] case_etherStatsUndersizePkts;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts64Octets;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts65to127Octets;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts128to255Octets;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts256to511Octets;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts512to1023Octets;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts1024to1518Octets;
        reg [(CASE_WIDTH-1):0] case_etherStatsPkts1519toXOctets;
        reg [(CASE_WIDTH-1):0] case_etherStatsFragments;
        reg [(CASE_WIDTH-1):0] case_etherStatsJabbers;
        reg [(CASE_WIDTH-1):0] case_etherStatsOversizePkts;
        reg [(CASE_WIDTH-1):0] case_etherStatsCRCErr;
        reg [(CASE_WIDTH-1):0] case_unicastMACCtrlFrames;
        reg [(CASE_WIDTH-1):0] case_multicastMACCtrlFrames;
        reg [(CASE_WIDTH-1):0] case_broadcastMACCtrlFrames;
        reg [(CASE_WIDTH-1):0] case_octetsOK;
        reg [(CASE_WIDTH-1):0] case_etherStatsOctets;
        
        // Soft reset
        reg clr;

        // Shadow register
        reg [31:0] msb_reg;

        // Wires
        reg error;
        reg valid;

        // Avalon-ST data sink
        reg stat_sink_valid_reg;
        
        wire [15:0] payload_length_w;
        wire [15:0] pkt_length_w;
        
        reg [15:0] payload_length;
        reg [15:0] payload_length_reg;
        reg [15:0] pkt_length;
        reg [15:0] pkt_length_reg;
        //reg svlan_pkt;
        //reg vlan_pkt;
        reg control_frame;
        reg pause_pkt;
        reg pfc_pkt;
        reg broadcast_pkt;
        reg multicast_pkt;
        reg unicast_pkt;
        
        //reg phy_err;
        reg crc_err;
        //reg user_err;
        //reg underflow_err;
        reg undersize_frame_err;
        reg oversize_frame_err;
        //reg payload_length_err; 

	// Output registers 
 	reg                             csr_read_reg; // Read latency of 2
 	reg [(CSR_DATAPATH_WIDTH)-1:0]  csr_readdata;

    // Pipelined registers
    //reg [(OCTET_REG_WIDTH-1):0] octetsOK_inc;
    //reg [(OCTET_REG_WIDTH-1):0] etherStatsOctets_inc;
    
    reg pkt_length_eq_64;
    reg pkt_length_gt_64;
    reg pkt_length_lt_128;
    reg pkt_length_lt_256;
    reg pkt_length_gt_eq_256;
    reg pkt_length_gt_eq_128;
    reg pkt_length_lt_512;
    reg pkt_length_gt_eq_512;
    reg pkt_length_lt_1024;
    reg pkt_length_gt_eq_1024;
    reg pkt_length_lt_eq_1518;
    reg pkt_length_gt_1518;

// ###########################################################################################
// ---------------------------------------------------------------------------
// Av-ST data sink interface mapping
// ---------------------------------------------------------------------------
// ###########################################################################################
assign payload_length_w = stat_sink_data[15:0];
assign pkt_length_w = stat_sink_data[31:16];

generate if (PIPELINE_STATUS == 1)
    begin : PIPELINE_STATUS_PROCESS
	if (SYNC_RESET_N == 1) begin
        always @(posedge clk) begin
            if (!csr_reset_n) begin
                stat_sink_valid_reg <= 1'b0;
                
                payload_length <= 1'b0;
                pkt_length <= 1'b0;
                //svlan_pkt <= 1'b0;
                //vlan_pkt <= 1'b0;
                control_frame <= 1'b0;
                pause_pkt <= 1'b0;
                pfc_pkt <= 1'b0;
                broadcast_pkt <= 1'b0;
                multicast_pkt <= 1'b0;
                unicast_pkt <= 1'b0;
                
                undersize_frame_err <= 1'b0;
                oversize_frame_err <= 1'b0;
                //payload_length_err <= 1'b0;
                crc_err <= 1'b0;
                //underflow_err <= 1'b0;
                //user_err <= 1'b0;
                //phy_err <= 1'b0;
                
                error <= 1'b0;
                valid <= 1'b0;
                
                //octetsOK_inc <= {OCTET_REG_WIDTH{1'b0}};
                //etherStatsOctets_inc <= {OCTET_REG_WIDTH{1'b0}};
                
                pkt_length_eq_64 <= 1'b0;
                pkt_length_gt_64 <= 1'b0;
                pkt_length_lt_128 <= 1'b0;
                pkt_length_lt_256 <= 1'b0;
                pkt_length_gt_eq_256 <= 1'b0;
                pkt_length_gt_eq_128 <= 1'b0;
                pkt_length_lt_512 <= 1'b0;
                pkt_length_gt_eq_512 <= 1'b0;
                pkt_length_lt_1024 <= 1'b0;
                pkt_length_gt_eq_1024 <= 1'b0;
                pkt_length_lt_eq_1518 <= 1'b0;
                pkt_length_gt_1518 <= 1'b0;
            end
            else begin
                stat_sink_valid_reg <= stat_sink_valid;
                
                // ---------------------------------------------------------------------------
                // Av-ST data sink interface mapping
                // ---------------------------------------------------------------------------
                payload_length <= payload_length_w;
                pkt_length <= pkt_length_w;
                //svlan_pkt <= stat_sink_data[32];
                //vlan_pkt <= stat_sink_data[33];
                control_frame <= stat_sink_data[34];
                pause_pkt <= stat_sink_data[35];
                pfc_pkt <= (enable_pfc) ? stat_sink_data[39] : 1'b0;
                broadcast_pkt <= stat_sink_data[36];
                multicast_pkt <= stat_sink_data[37];
                unicast_pkt <= stat_sink_data[38];
                
                undersize_frame_err <= stat_sink_error[0];
                oversize_frame_err <= stat_sink_error[1];
                //payload_length_err <= stat_sink_error[2];
                crc_err <= stat_sink_error[3];
                //underflow_err <= stat_sink_error[4];
                //user_err <= stat_sink_error[5];
                //phy_err <= stat_sink_error[6];
                
                // ---------------------------------------------------------------------------
                // Error detector
                // ---------------------------------------------------------------------------
                error <= |stat_sink_error;
                
                // ---------------------------------------------------------------------------
                // Valid packet detector
                // Equivalent:
                //     valid = unicast_pkt | multicast_pkt | broadcast_pkt | pause_pkt | control_frame | pfc_pkt;
                // ---------------------------------------------------------------------------
                valid <= (enable_pfc) ? |(stat_sink_data[39:34]) : |(stat_sink_data[38:34]);
                
                // ---------------------------------------------------------------------------
                // Counters addition
                // ---------------------------------------------------------------------------
                //octetsOK_inc <= octetsOK_inc + payload_length_w;
                //etherStatsOctets_inc <= etherStatsOctets_inc + pkt_length_w;
                
                // ---------------------------------------------------------------------------
                // Packet length checking
                // ---------------------------------------------------------------------------
                pkt_length_eq_64 <= (pkt_length_w == 64) ? 1'b1 : 1'b0;
                pkt_length_gt_64 <= (pkt_length_w > 64) ? 1'b1 : 1'b0;
                pkt_length_lt_128 <= (!(|(pkt_length_w[15:7]))) ? 1'b1 : 1'b0; // < 128
                pkt_length_gt_eq_128 <= ((|(pkt_length_w[15:7]))) ? 1'b1 : 1'b0; // >= 128
                pkt_length_lt_256 <= (!(|(pkt_length_w[15:8]))) ? 1'b1 : 1'b0; // < 256
                pkt_length_gt_eq_256 <= ((|(pkt_length_w[15:8]))) ? 1'b1 : 1'b0; // >= 256
                pkt_length_lt_512 <= (!(|(pkt_length_w[15:9]))) ? 1'b1 : 1'b0; // < 512
                pkt_length_gt_eq_512 <= ((|(pkt_length_w[15:9]))) ? 1'b1 : 1'b0; // >= 512
                pkt_length_lt_1024 <= (!(|(pkt_length_w[15:10]))) ? 1'b1 : 1'b0; // < 1024
                pkt_length_gt_eq_1024 <= ((|(pkt_length_w[15:10]))) ? 1'b1 : 1'b0; // >= 1024
                pkt_length_lt_eq_1518 <= (pkt_length_w <= 1518) ? 1'b1 : 1'b0;
                pkt_length_gt_1518 <= (pkt_length_w > 1518) ? 1'b1 : 1'b0;
            end
        end
        end else begin
	always @(posedge clk or negedge csr_reset_n) begin
            if (!csr_reset_n) begin
                stat_sink_valid_reg <= 1'b0;
                
                payload_length <= 1'b0;
                pkt_length <= 1'b0;
                //svlan_pkt <= 1'b0;
                //vlan_pkt <= 1'b0;
                control_frame <= 1'b0;
                pause_pkt <= 1'b0;
                pfc_pkt <= 1'b0;
                broadcast_pkt <= 1'b0;
                multicast_pkt <= 1'b0;
                unicast_pkt <= 1'b0;
                
                undersize_frame_err <= 1'b0;
                oversize_frame_err <= 1'b0;
                //payload_length_err <= 1'b0;
                crc_err <= 1'b0;
                //underflow_err <= 1'b0;
                //user_err <= 1'b0;
                //phy_err <= 1'b0;
                
                error <= 1'b0;
                valid <= 1'b0;
                
                //octetsOK_inc <= {OCTET_REG_WIDTH{1'b0}};
                //etherStatsOctets_inc <= {OCTET_REG_WIDTH{1'b0}};
                
                pkt_length_eq_64 <= 1'b0;
                pkt_length_gt_64 <= 1'b0;
                pkt_length_lt_128 <= 1'b0;
                pkt_length_lt_256 <= 1'b0;
                pkt_length_gt_eq_256 <= 1'b0;
                pkt_length_gt_eq_128 <= 1'b0;
                pkt_length_lt_512 <= 1'b0;
                pkt_length_gt_eq_512 <= 1'b0;
                pkt_length_lt_1024 <= 1'b0;
                pkt_length_gt_eq_1024 <= 1'b0;
                pkt_length_lt_eq_1518 <= 1'b0;
                pkt_length_gt_1518 <= 1'b0;
            end
            else begin
                stat_sink_valid_reg <= stat_sink_valid;
                
                // ---------------------------------------------------------------------------
                // Av-ST data sink interface mapping
                // ---------------------------------------------------------------------------
                payload_length <= payload_length_w;
                pkt_length <= pkt_length_w;
                //svlan_pkt <= stat_sink_data[32];
                //vlan_pkt <= stat_sink_data[33];
                control_frame <= stat_sink_data[34];
                pause_pkt <= stat_sink_data[35];
                pfc_pkt <= (enable_pfc) ? stat_sink_data[39] : 1'b0;
                broadcast_pkt <= stat_sink_data[36];
                multicast_pkt <= stat_sink_data[37];
                unicast_pkt <= stat_sink_data[38];
                
                undersize_frame_err <= stat_sink_error[0];
                oversize_frame_err <= stat_sink_error[1];
                //payload_length_err <= stat_sink_error[2];
                crc_err <= stat_sink_error[3];
                //underflow_err <= stat_sink_error[4];
                //user_err <= stat_sink_error[5];
                //phy_err <= stat_sink_error[6];
                
                // ---------------------------------------------------------------------------
                // Error detector
                // ---------------------------------------------------------------------------
                error <= |stat_sink_error;
                
                // ---------------------------------------------------------------------------
                // Valid packet detector
                // Equivalent:
                //     valid = unicast_pkt | multicast_pkt | broadcast_pkt | pause_pkt | control_frame | pfc_pkt;
                // ---------------------------------------------------------------------------
                valid <= (enable_pfc) ? |(stat_sink_data[39:34]) : |(stat_sink_data[38:34]);
                
                // ---------------------------------------------------------------------------
                // Counters addition
                // ---------------------------------------------------------------------------
                //octetsOK_inc <= octetsOK_inc + payload_length_w;
                //etherStatsOctets_inc <= etherStatsOctets_inc + pkt_length_w;
                
                // ---------------------------------------------------------------------------
                // Packet length checking
                // ---------------------------------------------------------------------------
                pkt_length_eq_64 <= (pkt_length_w == 64) ? 1'b1 : 1'b0;
                pkt_length_gt_64 <= (pkt_length_w > 64) ? 1'b1 : 1'b0;
                pkt_length_lt_128 <= (!(|(pkt_length_w[15:7]))) ? 1'b1 : 1'b0; // < 128
                pkt_length_gt_eq_128 <= ((|(pkt_length_w[15:7]))) ? 1'b1 : 1'b0; // >= 128
                pkt_length_lt_256 <= (!(|(pkt_length_w[15:8]))) ? 1'b1 : 1'b0; // < 256
                pkt_length_gt_eq_256 <= ((|(pkt_length_w[15:8]))) ? 1'b1 : 1'b0; // >= 256
                pkt_length_lt_512 <= (!(|(pkt_length_w[15:9]))) ? 1'b1 : 1'b0; // < 512
                pkt_length_gt_eq_512 <= ((|(pkt_length_w[15:9]))) ? 1'b1 : 1'b0; // >= 512
                pkt_length_lt_1024 <= (!(|(pkt_length_w[15:10]))) ? 1'b1 : 1'b0; // < 1024
                pkt_length_gt_eq_1024 <= ((|(pkt_length_w[15:10]))) ? 1'b1 : 1'b0; // >= 1024
                pkt_length_lt_eq_1518 <= (pkt_length_w <= 1518) ? 1'b1 : 1'b0;
                pkt_length_gt_1518 <= (pkt_length_w > 1518) ? 1'b1 : 1'b0;
            end
        end
        end
    end
    else
    begin
        always @(*) begin
            stat_sink_valid_reg = stat_sink_valid;
            
            // ---------------------------------------------------------------------------
            // Av-ST data sink interface mapping
            // ---------------------------------------------------------------------------
            payload_length = payload_length_w;
            pkt_length = pkt_length_w;
            //svlan_pkt = stat_sink_data[32];
            //vlan_pkt = stat_sink_data[33];
            control_frame = stat_sink_data[34];
            pause_pkt = stat_sink_data[35];
            pfc_pkt = (enable_pfc) ? stat_sink_data[39] : 1'b0;
            broadcast_pkt = stat_sink_data[36];
            multicast_pkt = stat_sink_data[37];
            unicast_pkt = stat_sink_data[38];
            
            undersize_frame_err = stat_sink_error[0];
            oversize_frame_err = stat_sink_error[1];
            //payload_length_err = stat_sink_error[2];
            crc_err = stat_sink_error[3];
            //underflow_err = stat_sink_error[4];
            //user_err = stat_sink_error[5];
            //phy_err = stat_sink_error[6];
            
            // ---------------------------------------------------------------------------
            // Error detector
            // ---------------------------------------------------------------------------
            error = |stat_sink_error;
            
            // ---------------------------------------------------------------------------
            // Valid packet detector
            // Equivalent:
            //     valid = unicast_pkt | multicast_pkt | broadcast_pkt | pause_pkt | control_frame | pfc_pkt;
            // ---------------------------------------------------------------------------
            valid = (enable_pfc) ? |(stat_sink_data[39:34]) : |(stat_sink_data[38:34]);
            
            // ---------------------------------------------------------------------------
            // Counters addition
            // ---------------------------------------------------------------------------
            //octetsOK_inc = octetsOK_inc + payload_length_w;
            //etherStatsOctets_inc = etherStatsOctets_inc + pkt_length_w;
            
            // ---------------------------------------------------------------------------
            // Packet length checking
            // ---------------------------------------------------------------------------
            pkt_length_eq_64 = (pkt_length_w == 64) ? 1'b1 : 1'b0;
            pkt_length_gt_64 = (pkt_length_w > 64) ? 1'b1 : 1'b0;
            pkt_length_lt_128 = (!(|(pkt_length_w[15:7]))) ? 1'b1 : 1'b0; // < 128
            pkt_length_gt_eq_128 = ((|(pkt_length_w[15:7]))) ? 1'b1 : 1'b0; // >= 128
            pkt_length_lt_256 = (!(|(pkt_length_w[15:8]))) ? 1'b1 : 1'b0; // < 256
            pkt_length_gt_eq_256 = ((|(pkt_length_w[15:8]))) ? 1'b1 : 1'b0; // >= 256
            pkt_length_lt_512 = (!(|(pkt_length_w[15:9]))) ? 1'b1 : 1'b0; // < 512
            pkt_length_gt_eq_512 = ((|(pkt_length_w[15:9]))) ? 1'b1 : 1'b0; // >= 512
            pkt_length_lt_1024 = (!(|(pkt_length_w[15:10]))) ? 1'b1 : 1'b0; // < 1024
            pkt_length_gt_eq_1024 = ((|(pkt_length_w[15:10]))) ? 1'b1 : 1'b0; // >= 1024
            pkt_length_lt_eq_1518 = (pkt_length_w <= 1518) ? 1'b1 : 1'b0;
            pkt_length_gt_1518 = (pkt_length_w > 1518) ? 1'b1 : 1'b0;
        end
    end
endgenerate

// Pipelined so that the Octets counter could be updated correctly
generate if (SYNC_RESET_N == 1) begin
always @(posedge clk) begin
    if (!csr_reset_n) begin
        payload_length_reg <= 1'b0;
        pkt_length_reg <= 1'b0;
    end
    else begin
        payload_length_reg <= payload_length;
        pkt_length_reg <= pkt_length;
    end
end
end else begin
always @(posedge clk or negedge csr_reset_n) begin
    if (!csr_reset_n) begin
        payload_length_reg <= 1'b0;
        pkt_length_reg <= 1'b0;
    end
    else begin
        payload_length_reg <= payload_length;
        pkt_length_reg <= pkt_length;
    end
end
end 
endgenerate

// ###########################################################################################
// ---------------------------------------------------------------------------
// CSR Interface and Register Space
// ---------------------------------------------------------------------------
// ###########################################################################################
// ---------------------------------------------------------------------------
// Control register and status register
// This block handles the write transaction from the Avalon-MM csr interface.
// Setting '1' to clr (soft reset) will reset all statistic registers.
// Soft reset will be self-cleared.
// ---------------------------------------------------------------------------
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
	    if (!csr_reset_n) begin
		    clr <= 1'b0; 
	    end
	    else begin
		if (csr_write == 1'b1 && csr_address == 6'b0) begin
			clr <= csr_writedata[0]; 
		end
                else begin
                        clr <= 1'b0;
                end
	    end
    end    
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
    	    if (!csr_reset_n) begin
    		    clr <= 1'b0; 
    	    end
    	    else begin
    		if (csr_write == 1'b1 && csr_address == 6'b0) begin
    			clr <= csr_writedata[0]; 
    		end
                    else begin
                            clr <= 1'b0;
                    end
    	    end
    end  
    end
    endgenerate
// ---------------------------------------------------------------------------
// Control register and status register
// This block handles the read transaction from the Avalon-MM csr interface. 
// A read transaction to address '0' will read the value of soft reset
// Address '1' is reserved
// A read transaction to a statistic register will clear the particular register
// - A read transaction to a valid even address (other than 0) will read from the 32 lower-bits of the associated register. 
//   The higher-bits of the register will be written to the shadow register.
//   The shadow register will always be overwritten by the next read transaction to any valid even address. 
// - A read transaction to a valid odd address will read from the shadow register.
// ---------------------------------------------------------------------------
generate if (SYNC_RESET_N == 1) begin
always @(posedge clk) begin
	    if (!csr_reset_n) begin
                csr_read_reg <= 1'b0;
                csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
                msb_reg <= 32'b0;
	    end
	    else begin
            csr_read_reg <= csr_read;
            
            if (clr) begin
                csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
                msb_reg <= 32'b0;
	        end
	        else begin
                if (csr_read_reg == 1'b1) begin
                    if(&(csr_address[5:1])) begin // csr_address >= 6'h3E
                        csr_readdata <= 32'b0;
                    end
                    else if(csr_address[0]) begin
                        if(~(|(csr_address[5:1]))) begin // csr_address == 6'h1
                            csr_readdata <= 32'b0;
                        end
                        else begin  // for all counters MSB addresses
                            csr_readdata <= msb_reg;
                        end
                    end
                    else begin
                        case (csr_address)
                            6'h0: begin
                                    csr_readdata <= {{31{1'b0}}, clr};
                                  end
                            6'h2: begin
                                    csr_readdata <= framesOK[31:0];
                                    msb_reg <= {28'b0,framesOK[35:32]}; 
                                  end
                            //6'h3: csr_readdata <= msb_reg;
                            6'h4: begin
                                    csr_readdata <= framesErr[31:0];
                                    msb_reg <= {28'b0,framesErr[35:32]};
                                  end
                            //6'h5: csr_readdata <= msb_reg;
                            6'h6: begin
                                    csr_readdata <= framesCRCErr[31:0];
                                    msb_reg <= {28'b0,framesCRCErr[35:32]};
                                  end
                            //6'h7: csr_readdata <= msb_reg;
                            6'h8: begin
                                    csr_readdata <= octetsOK[31:0];
                                    msb_reg <= octetsOK[63:32];
                                  end
                            //6'h9: csr_readdata <= msb_reg;
                            6'hA: begin
                                    csr_readdata <= pauseMACCtrlFrames[31:0];
                                    msb_reg <= {28'b0,pauseMACCtrlFrames[35:32]};
                                  end
                            //6'hB: csr_readdata <= msb_reg;
                            6'hC: begin
                                    csr_readdata <= ifErrors[31:0];
                                    msb_reg <= {28'b0, ifErrors[35:32]};
                                  end
                            //6'hD: csr_readdata <= msb_reg;
                            6'hE: begin
                                    csr_readdata <= unicastFramesOK[31:0];
                                    msb_reg <= {28'b0,unicastFramesOK[35:32]};
                                  end
                            //6'hF: csr_readdata <= msb_reg;
                            6'h10: begin
                                    csr_readdata <= unicastFramesErr[31:0];
                                    msb_reg <= {28'b0,unicastFramesErr[35:32]};
                                   end
                            //6'h11: csr_readdata <= msb_reg;
                            6'h12: begin
                                    csr_readdata <= multicastFramesOK[31:0];
                                    msb_reg <= {28'b0,multicastFramesOK[35:32]};
                                   end
                            //6'h13: csr_readdata <= msb_reg;
                            6'h14: begin
                                    csr_readdata <= multicastFramesErr[31:0];
                                    msb_reg <= {28'b0,multicastFramesErr[35:32]};
                                   end
                            //6'h15: csr_readdata <= msb_reg;
                            6'h16: begin
                                    csr_readdata <= broadcastFramesOK[31:0];
                                    msb_reg <= {28'b0,broadcastFramesOK[35:32]};
                                   end
                            //6'h17: csr_readdata <= msb_reg;
                            6'h18: begin
                                    csr_readdata <= broadcastFramesErr[31:0];
                                    msb_reg <= {28'b0,broadcastFramesErr[35:32]};
                                   end
                            //6'h19: csr_readdata <= msb_reg;
                            6'h1A: begin
                                    csr_readdata <= etherStatsOctets[31:0];
                                    msb_reg <= etherStatsOctets[63:32];
                                   end
                            //6'h1B: csr_readdata <= msb_reg;
                            6'h1C: begin
                                    csr_readdata <= etherStatsPkts[31:0];
                                    msb_reg <= {28'b0,etherStatsPkts[35:32]};
                                   end
                            //6'h1D: csr_readdata <= msb_reg;
                            6'h1E: begin
                                    csr_readdata <= etherStatsUndersizePkts[31:0];
                                    msb_reg <= {28'b0,etherStatsUndersizePkts[35:32]};
                                   end
                            //6'h1F: csr_readdata <= msb_reg;
                            6'h20: begin
                                    csr_readdata <= etherStatsOversizePkts[31:0];
                                    msb_reg <= {28'b0,etherStatsOversizePkts[35:32]};
                                   end 
                            //6'h21: csr_readdata <= msb_reg;
                            6'h22: begin
                                    csr_readdata <= etherStatsPkts64Octets[31:0];
                                    msb_reg <= {28'b0,etherStatsPkts64Octets[35:32]};
                                   end
                            //6'h23: csr_readdata <= msb_reg;
                            6'h24: begin
                                    csr_readdata <= etherStatsPkts65to127Octets[31:0];
                                    msb_reg <= {28'b0, etherStatsPkts65to127Octets[35:32]};
                                   end
                            //6'h25: csr_readdata <= msb_reg;
                            6'h26: begin
                                    csr_readdata <= etherStatsPkts128to255Octets[31:0];
                                    msb_reg <= {28'b0, etherStatsPkts128to255Octets[35:32]};
                                   end
                            //6'h27: csr_readdata <= msb_reg;
                            6'h28: begin
                                    csr_readdata <= etherStatsPkts256to511Octets[31:0];
                                    msb_reg <= {28'b0, etherStatsPkts256to511Octets[35:32]};
                                   end
                            //6'h29: csr_readdata <= msb_reg;
                            6'h2A: begin
                                    csr_readdata <= etherStatsPkts512to1023Octets[31:0];
                                    msb_reg <= {28'b0, etherStatsPkts512to1023Octets[35:32]};
                                   end
                            //6'h2B: csr_readdata <= msb_reg;
                            6'h2C: begin
                                    csr_readdata <= etherStatsPkts1024to1518Octets[31:0];
                                    msb_reg <= {28'b0, etherStatsPkts1024to1518Octets[35:32]};
                                   end
                            //6'h2D: csr_readdata <= msb_reg;
                            6'h2E: begin
                                    csr_readdata <= etherStatsPkts1519toXOctets[31:0];
                                    msb_reg <= {28'b0, etherStatsPkts1519toXOctets[35:32]};
                                   end
                            //6'h2F: csr_readdata <= msb_reg;
                            6'h30: begin
                                    csr_readdata <= etherStatsFragments[31:0];
                                    msb_reg <= {28'b0,etherStatsFragments[35:32]};
                                   end 
                            //6'h31: csr_readdata <= msb_reg;
                            6'h32: begin
                                    csr_readdata <= etherStatsJabbers[31:0];
                                    msb_reg <= {28'b0,etherStatsJabbers[35:32]};
                                   end 
                            //6'h33: csr_readdata <= msb_reg;
                            6'h34: begin
                                    csr_readdata <= etherStatsCRCErr[31:0];
                                    msb_reg <= {28'b0,etherStatsCRCErr[35:32]};
                                   end 
                            //6'h35: csr_readdata <= msb_reg;
                            6'h36: begin
                                    csr_readdata <= unicastMACCtrlFrames[31:0];
                                    msb_reg <= {28'b0, unicastMACCtrlFrames[35:32]};
                                   end 
                            //6'h37: csr_readdata <= msb_reg;
                            6'h38: begin
                                    csr_readdata <= multicastMACCtrlFrames[31:0];
                                    msb_reg <= {28'b0, multicastMACCtrlFrames[35:32]};
                                   end 
                            //6'h39: csr_readdata <= msb_reg;
                            6'h3A: begin
                                    csr_readdata <= broadcastMACCtrlFrames[31:0];
                                    msb_reg <= {28'b0, broadcastMACCtrlFrames[35:32]};
                                   end 
                            //6'h3B: csr_readdata <= msb_reg;
                            6'h3C: begin
                                    csr_readdata <= (enable_pfc) ? pfcMACCtrlFrames[31:0] : 32'b0;
                                    msb_reg <= (enable_pfc) ? {28'b0,pfcMACCtrlFrames[35:32]} : 32'b0;
                                   end
                            //6'h3D: csr_readdata <= msb_reg;
                            default: begin 
                                        csr_readdata <= 32'b0;
                                        msb_reg <= 32'b0;
                                    end
                        endcase
                    end
                end
            end
        end	     
    end
    end else begin
   always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            csr_read_reg <= 1'b0;
            csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
            msb_reg <= 32'b0;
        end
        else begin
        csr_read_reg <= csr_read;
        
        if (clr) begin
            csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
            msb_reg <= 32'b0;
            end
            else begin
            if (csr_read_reg == 1'b1) begin
                if(&(csr_address[5:1])) begin // csr_address >= 6'h3E
                    csr_readdata <= 32'b0;
                end
                else if(csr_address[0]) begin
                    if(~(|(csr_address[5:1]))) begin // csr_address == 6'h1
                        csr_readdata <= 32'b0;
                    end
                    else begin  // for all counters MSB addresses
                        csr_readdata <= msb_reg;
                    end
                end
                else begin
                    case (csr_address)
                        6'h0: begin
                                csr_readdata <= {{31{1'b0}}, clr};
                              end
                        6'h2: begin
                                csr_readdata <= framesOK[31:0];
                                msb_reg <= {28'b0,framesOK[35:32]}; 
                              end
                        //6'h3: csr_readdata <= msb_reg;
                        6'h4: begin
                                csr_readdata <= framesErr[31:0];
                                msb_reg <= {28'b0,framesErr[35:32]};
                              end
                        //6'h5: csr_readdata <= msb_reg;
                        6'h6: begin
                                csr_readdata <= framesCRCErr[31:0];
                                msb_reg <= {28'b0,framesCRCErr[35:32]};
                              end
                        //6'h7: csr_readdata <= msb_reg;
                        6'h8: begin
                                csr_readdata <= octetsOK[31:0];
                                msb_reg <= octetsOK[63:32];
                              end
                        //6'h9: csr_readdata <= msb_reg;
                        6'hA: begin
                                csr_readdata <= pauseMACCtrlFrames[31:0];
                                msb_reg <= {28'b0,pauseMACCtrlFrames[35:32]};
                              end
                        //6'hB: csr_readdata <= msb_reg;
                        6'hC: begin
                                csr_readdata <= ifErrors[31:0];
                                msb_reg <= {28'b0, ifErrors[35:32]};
                              end
                        //6'hD: csr_readdata <= msb_reg;
                        6'hE: begin
                                csr_readdata <= unicastFramesOK[31:0];
                                msb_reg <= {28'b0,unicastFramesOK[35:32]};
                              end
                        //6'hF: csr_readdata <= msb_reg;
                        6'h10: begin
                                csr_readdata <= unicastFramesErr[31:0];
                                msb_reg <= {28'b0,unicastFramesErr[35:32]};
                               end
                        //6'h11: csr_readdata <= msb_reg;
                        6'h12: begin
                                csr_readdata <= multicastFramesOK[31:0];
                                msb_reg <= {28'b0,multicastFramesOK[35:32]};
                               end
                        //6'h13: csr_readdata <= msb_reg;
                        6'h14: begin
                                csr_readdata <= multicastFramesErr[31:0];
                                msb_reg <= {28'b0,multicastFramesErr[35:32]};
                               end
                        //6'h15: csr_readdata <= msb_reg;
                        6'h16: begin
                                csr_readdata <= broadcastFramesOK[31:0];
                                msb_reg <= {28'b0,broadcastFramesOK[35:32]};
                               end
                        //6'h17: csr_readdata <= msb_reg;
                        6'h18: begin
                                csr_readdata <= broadcastFramesErr[31:0];
                                msb_reg <= {28'b0,broadcastFramesErr[35:32]};
                               end
                        //6'h19: csr_readdata <= msb_reg;
                        6'h1A: begin
                                csr_readdata <= etherStatsOctets[31:0];
                                msb_reg <= etherStatsOctets[63:32];
                               end
                        //6'h1B: csr_readdata <= msb_reg;
                        6'h1C: begin
                                csr_readdata <= etherStatsPkts[31:0];
                                msb_reg <= {28'b0,etherStatsPkts[35:32]};
                               end
                        //6'h1D: csr_readdata <= msb_reg;
                        6'h1E: begin
                                csr_readdata <= etherStatsUndersizePkts[31:0];
                                msb_reg <= {28'b0,etherStatsUndersizePkts[35:32]};
                               end
                        //6'h1F: csr_readdata <= msb_reg;
                        6'h20: begin
                                csr_readdata <= etherStatsOversizePkts[31:0];
                                msb_reg <= {28'b0,etherStatsOversizePkts[35:32]};
                               end 
                        //6'h21: csr_readdata <= msb_reg;
                        6'h22: begin
                                csr_readdata <= etherStatsPkts64Octets[31:0];
                                msb_reg <= {28'b0,etherStatsPkts64Octets[35:32]};
                               end
                        //6'h23: csr_readdata <= msb_reg;
                        6'h24: begin
                                csr_readdata <= etherStatsPkts65to127Octets[31:0];
                                msb_reg <= {28'b0, etherStatsPkts65to127Octets[35:32]};
                               end
                        //6'h25: csr_readdata <= msb_reg;
                        6'h26: begin
                                csr_readdata <= etherStatsPkts128to255Octets[31:0];
                                msb_reg <= {28'b0, etherStatsPkts128to255Octets[35:32]};
                               end
                        //6'h27: csr_readdata <= msb_reg;
                        6'h28: begin
                                csr_readdata <= etherStatsPkts256to511Octets[31:0];
                                msb_reg <= {28'b0, etherStatsPkts256to511Octets[35:32]};
                               end
                        //6'h29: csr_readdata <= msb_reg;
                        6'h2A: begin
                                csr_readdata <= etherStatsPkts512to1023Octets[31:0];
                                msb_reg <= {28'b0, etherStatsPkts512to1023Octets[35:32]};
                               end
                        //6'h2B: csr_readdata <= msb_reg;
                        6'h2C: begin
                                csr_readdata <= etherStatsPkts1024to1518Octets[31:0];
                                msb_reg <= {28'b0, etherStatsPkts1024to1518Octets[35:32]};
                               end
                        //6'h2D: csr_readdata <= msb_reg;
                        6'h2E: begin
                                csr_readdata <= etherStatsPkts1519toXOctets[31:0];
                                msb_reg <= {28'b0, etherStatsPkts1519toXOctets[35:32]};
                               end
                        //6'h2F: csr_readdata <= msb_reg;
                        6'h30: begin
                                csr_readdata <= etherStatsFragments[31:0];
                                msb_reg <= {28'b0,etherStatsFragments[35:32]};
                               end 
                        //6'h31: csr_readdata <= msb_reg;
                        6'h32: begin
                                csr_readdata <= etherStatsJabbers[31:0];
                                msb_reg <= {28'b0,etherStatsJabbers[35:32]};
                               end 
                        //6'h33: csr_readdata <= msb_reg;
                        6'h34: begin
                                csr_readdata <= etherStatsCRCErr[31:0];
                                msb_reg <= {28'b0,etherStatsCRCErr[35:32]};
                               end 
                        //6'h35: csr_readdata <= msb_reg;
                        6'h36: begin
                                csr_readdata <= unicastMACCtrlFrames[31:0];
                                msb_reg <= {28'b0, unicastMACCtrlFrames[35:32]};
                               end 
                        //6'h37: csr_readdata <= msb_reg;
                        6'h38: begin
                                csr_readdata <= multicastMACCtrlFrames[31:0];
                                msb_reg <= {28'b0, multicastMACCtrlFrames[35:32]};
                               end 
                        //6'h39: csr_readdata <= msb_reg;
                        6'h3A: begin
                                csr_readdata <= broadcastMACCtrlFrames[31:0];
                                msb_reg <= {28'b0, broadcastMACCtrlFrames[35:32]};
                               end 
                        //6'h3B: csr_readdata <= msb_reg;
                        6'h3C: begin
                                csr_readdata <= (enable_pfc) ? pfcMACCtrlFrames[31:0] : 32'b0;
                                msb_reg <= (enable_pfc) ? {28'b0,pfcMACCtrlFrames[35:32]} : 32'b0;
                               end
                        //6'h3D: csr_readdata <= msb_reg;
                        default: begin 
                                    csr_readdata <= 32'b0;
                                    msb_reg <= 32'b0;
                                end
                    endcase
                end
            end
        end
    end	     
end
end 
endgenerate
generate if(SYNC_RESET_N == 1) begin
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment framesOK
  // - Number of successfully transmitted/received frames. (good frames only including control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          framesOK <= REG_RESET_VALUE;
          case_framesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_framesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2)) begin
                  if (stat_sink_valid_reg & valid & !error) begin
                      case_framesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_framesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & valid & !error) begin
                      case_framesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_framesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_framesOK)
              CASE_CLEAR:         framesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  framesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        framesOK <= framesOK + 1'b1;
              CASE_UNCHANGED:     framesOK <= framesOK;
              default:            framesOK <= framesOK;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment framesErr
  // - Number of not successfully transmitted/received frames. (error frames only including control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk ) begin
      if (!csr_reset_n) begin
          framesErr <= REG_RESET_VALUE;
          case_framesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_framesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h4)) begin
                  if (stat_sink_valid_reg & valid & error) begin
                      case_framesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_framesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & valid & error) begin
                      case_framesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_framesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_framesErr)
              CASE_CLEAR:         framesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  framesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        framesErr <= framesErr + 1'b1;
              CASE_UNCHANGED:     framesErr <= framesErr;
              default:            framesErr <= framesErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment framesCRCErr 
  // - Number of frames transmitted/received with CRC error. 
  //   (error frames including control frames but excluding frames with length smaller than 64 bytes or greater than the configured maximum length)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          framesCRCErr <= REG_RESET_VALUE;
          case_framesCRCErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_framesCRCErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h6)) begin
                  if (stat_sink_valid_reg & !oversize_frame_err & !undersize_frame_err & valid & crc_err) begin
                      case_framesCRCErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_framesCRCErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !oversize_frame_err  & !undersize_frame_err & valid & crc_err) begin
                      case_framesCRCErr <= CASE_UPDATE;
                  end
                  else begin
                      case_framesCRCErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_framesCRCErr)
              CASE_CLEAR:         framesCRCErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  framesCRCErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        framesCRCErr <= framesCRCErr + 1'b1;
              CASE_UNCHANGED:     framesCRCErr <= framesCRCErr;
              default:            framesCRCErr <= framesCRCErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment pauseMACCtrlFrames
  // - Number of valid PAUSE frames transmitted/received
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          pauseMACCtrlFrames <= REG_RESET_VALUE;
          case_pauseMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_pauseMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'hA)) begin
                  if (stat_sink_valid_reg & pause_pkt & !error) begin
                      case_pauseMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_pauseMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & pause_pkt & !error)  begin
                      case_pauseMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_pauseMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_pauseMACCtrlFrames)
              CASE_CLEAR:         pauseMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  pauseMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        pauseMACCtrlFrames <= pauseMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     pauseMACCtrlFrames <= pauseMACCtrlFrames;
              default:            pauseMACCtrlFrames <= pauseMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment pfcMACCtrlFrames
  // - Number of valid PAUSE frames transmitted/received
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          pfcMACCtrlFrames <= REG_RESET_VALUE;
          case_pfcMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_pfcMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h3C)) begin
                  if (stat_sink_valid_reg & pfc_pkt & !error) begin
                      case_pfcMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_pfcMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & pfc_pkt & !error)  begin
                      case_pfcMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_pfcMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_pfcMACCtrlFrames)
              CASE_CLEAR:         pfcMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  pfcMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        pfcMACCtrlFrames <= pfcMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     pfcMACCtrlFrames <= pfcMACCtrlFrames;
              default:            pfcMACCtrlFrames <= pfcMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment ifErrors
  // - The total number of packets that contain error and invalid packets.(error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          ifErrors <= REG_RESET_VALUE;
          case_ifErrors <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_ifErrors <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'hC)) begin
                  if (stat_sink_valid_reg & (error | !valid)) begin
                      case_ifErrors <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_ifErrors <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & (error | !valid))  begin
                      case_ifErrors <= CASE_UPDATE;
                  end
                  else begin
                      case_ifErrors <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_ifErrors)
              CASE_CLEAR:         ifErrors <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  ifErrors <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        ifErrors <= ifErrors + 1'b1;
              CASE_UNCHANGED:     ifErrors <= ifErrors;
              default:            ifErrors <= ifErrors;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment unicastFramesOK 
  // - Number of frames that are successfully received/transmitted (without error) and are directed to unicast address. 
  //     (good frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk ) begin
      if (!csr_reset_n) begin
          unicastFramesOK <= REG_RESET_VALUE;
          case_unicastFramesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_unicastFramesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'hE)) begin
                  if (stat_sink_valid_reg & !error & unicast_pkt & !control_frame) begin
                      case_unicastFramesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_unicastFramesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !error & unicast_pkt & !control_frame)  begin
                      case_unicastFramesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_unicastFramesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_unicastFramesOK)
              CASE_CLEAR:         unicastFramesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  unicastFramesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        unicastFramesOK <= unicastFramesOK + 1'b1;
              CASE_UNCHANGED:     unicastFramesOK <= unicastFramesOK;
              default:            unicastFramesOK <= unicastFramesOK;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment unicastFramesErr 
  // - Number of frames that are successfully received (with error) and are directed to unicast address. (error frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          unicastFramesErr <= REG_RESET_VALUE;
          case_unicastFramesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_unicastFramesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h10)) begin
                  if (stat_sink_valid_reg & error & unicast_pkt & !control_frame) begin
                      case_unicastFramesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_unicastFramesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & error & unicast_pkt & !control_frame)  begin
                      case_unicastFramesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_unicastFramesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_unicastFramesErr)
              CASE_CLEAR:         unicastFramesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  unicastFramesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        unicastFramesErr <= unicastFramesErr + 1'b1;
              CASE_UNCHANGED:     unicastFramesErr <= unicastFramesErr;
              default:            unicastFramesErr <= unicastFramesErr;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment multicastFramesOK
  // - Number of successfully transmitted frames to a multicast address only. (good frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          multicastFramesOK <= REG_RESET_VALUE;
          case_multicastFramesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_multicastFramesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h12)) begin
                  if (stat_sink_valid_reg & !error & multicast_pkt & !control_frame) begin
                      case_multicastFramesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_multicastFramesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !error & multicast_pkt & !control_frame)  begin
                      case_multicastFramesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_multicastFramesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_multicastFramesOK)
              CASE_CLEAR:         multicastFramesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  multicastFramesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        multicastFramesOK <= multicastFramesOK + 1'b1;
              CASE_UNCHANGED:     multicastFramesOK <= multicastFramesOK;
              default:            multicastFramesOK <= multicastFramesOK;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment multicastFramesErr 
  // - Number of not successfully transmitted frames to a multicast address only. (error frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          multicastFramesErr <= REG_RESET_VALUE;
          case_multicastFramesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_multicastFramesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h14)) begin
                  if (stat_sink_valid_reg & error & multicast_pkt & !control_frame) begin
                      case_multicastFramesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_multicastFramesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & error & multicast_pkt & !control_frame)  begin
                      case_multicastFramesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_multicastFramesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_multicastFramesErr)
              CASE_CLEAR:         multicastFramesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  multicastFramesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        multicastFramesErr <= multicastFramesErr + 1'b1;
              CASE_UNCHANGED:     multicastFramesErr <= multicastFramesErr;
              default:            multicastFramesErr <= multicastFramesErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment broadcastFramesOK
  // - Number of the frames that were successfully transmitted to a broadcast address. (good frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          broadcastFramesOK <= REG_RESET_VALUE;
          case_broadcastFramesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_broadcastFramesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h16)) begin
                  if (stat_sink_valid_reg & !error & broadcast_pkt & !control_frame) begin
                      case_broadcastFramesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_broadcastFramesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !error & broadcast_pkt & !control_frame)  begin
                      case_broadcastFramesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_broadcastFramesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_broadcastFramesOK)
              CASE_CLEAR:         broadcastFramesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  broadcastFramesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        broadcastFramesOK <= broadcastFramesOK + 1'b1;
              CASE_UNCHANGED:     broadcastFramesOK <= broadcastFramesOK;
              default:            broadcastFramesOK <= broadcastFramesOK;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment broadcastFramesErr
  // - Number of the frames that were not successfully transmitted to a broadcast address (error frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          broadcastFramesErr <= REG_RESET_VALUE;
          case_broadcastFramesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_broadcastFramesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h18)) begin
                  if (stat_sink_valid_reg & error & broadcast_pkt & !control_frame) begin
                      case_broadcastFramesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_broadcastFramesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & error & broadcast_pkt & !control_frame)  begin
                      case_broadcastFramesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_broadcastFramesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_broadcastFramesErr)
              CASE_CLEAR:         broadcastFramesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  broadcastFramesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        broadcastFramesErr <= broadcastFramesErr + 1'b1;
              CASE_UNCHANGED:     broadcastFramesErr <= broadcastFramesErr;
              default:            broadcastFramesErr <= broadcastFramesErr;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts
  // - The total number of packets received. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts <= REG_RESET_VALUE;
          case_etherStatsPkts <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h1C)) begin
                  if (stat_sink_valid_reg) begin
                      case_etherStatsPkts <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg)  begin
                      case_etherStatsPkts <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts)
              CASE_CLEAR:         etherStatsPkts <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts <= etherStatsPkts + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts <= etherStatsPkts;
              default:            etherStatsPkts <= etherStatsPkts;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsUndersizePkts
  // - The total number of packets received that were less than 64 octets. (error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsUndersizePkts <= REG_RESET_VALUE;
          case_etherStatsUndersizePkts <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsUndersizePkts <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h1E)) begin
                  if (stat_sink_valid_reg & undersize_frame_err & !crc_err) begin
                      case_etherStatsUndersizePkts <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsUndersizePkts <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & undersize_frame_err & !crc_err)  begin
                      case_etherStatsUndersizePkts <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsUndersizePkts <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsUndersizePkts)
              CASE_CLEAR:         etherStatsUndersizePkts <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsUndersizePkts <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsUndersizePkts <= etherStatsUndersizePkts + 1'b1;
              CASE_UNCHANGED:     etherStatsUndersizePkts <= etherStatsUndersizePkts;
              default:            etherStatsUndersizePkts <= etherStatsUndersizePkts;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsOversizePkts 
  // - The total number of packets received that were longer than the configured maximum packet length. (error and invalid packets) 
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsOversizePkts <= REG_RESET_VALUE;
          case_etherStatsOversizePkts <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsOversizePkts <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h20)) begin
                  if (stat_sink_valid_reg & oversize_frame_err & !crc_err) begin
                      case_etherStatsOversizePkts <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsOversizePkts <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & oversize_frame_err & !crc_err)  begin
                      case_etherStatsOversizePkts <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsOversizePkts <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsOversizePkts)
              CASE_CLEAR:         etherStatsOversizePkts <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsOversizePkts <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsOversizePkts <= etherStatsOversizePkts + 1'b1;
              CASE_UNCHANGED:     etherStatsOversizePkts <= etherStatsOversizePkts;
              default:            etherStatsOversizePkts <= etherStatsOversizePkts;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts64Octets 
  // - The total number of packets received that were 64 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts64Octets <= REG_RESET_VALUE;
          case_etherStatsPkts64Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts64Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h22)) begin
                  if (stat_sink_valid_reg && pkt_length_eq_64) begin
                      case_etherStatsPkts64Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts64Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_eq_64)  begin
                      case_etherStatsPkts64Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts64Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts64Octets)
              CASE_CLEAR:         etherStatsPkts64Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts64Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts64Octets <= etherStatsPkts64Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts64Octets <= etherStatsPkts64Octets;
              default:            etherStatsPkts64Octets <= etherStatsPkts64Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts65to127Octets
  // - The total number of packets received that were between 65 and 127 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts65to127Octets <= REG_RESET_VALUE;
          case_etherStatsPkts65to127Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts65to127Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h24)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_64 && pkt_length_lt_128) begin
                      case_etherStatsPkts65to127Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts65to127Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_64 && pkt_length_lt_128)  begin
                      case_etherStatsPkts65to127Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts65to127Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts65to127Octets)
              CASE_CLEAR:         etherStatsPkts65to127Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts65to127Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts65to127Octets <= etherStatsPkts65to127Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts65to127Octets <= etherStatsPkts65to127Octets;
              default:            etherStatsPkts65to127Octets <= etherStatsPkts65to127Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts128to255Octets
  // - The total number of packets received that were between 128 and 255 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts128to255Octets <= REG_RESET_VALUE;
          case_etherStatsPkts128to255Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts128to255Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h26)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_128 && pkt_length_lt_256) begin
                      case_etherStatsPkts128to255Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts128to255Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_128 && pkt_length_lt_256)  begin
                      case_etherStatsPkts128to255Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts128to255Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts128to255Octets)
              CASE_CLEAR:         etherStatsPkts128to255Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts128to255Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts128to255Octets <= etherStatsPkts128to255Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts128to255Octets <= etherStatsPkts128to255Octets;
              default:            etherStatsPkts128to255Octets <= etherStatsPkts128to255Octets;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts256to511Octets 
  // - The total number of packets received that were between 256 and 511 octets in length1. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts256to511Octets <= REG_RESET_VALUE;
          case_etherStatsPkts256to511Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts256to511Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h28)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_256 && pkt_length_lt_512) begin
                      case_etherStatsPkts256to511Octets <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_etherStatsPkts256to511Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_256 && pkt_length_lt_512)  begin
                      case_etherStatsPkts256to511Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts256to511Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts256to511Octets)
              CASE_CLEAR:         etherStatsPkts256to511Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts256to511Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts256to511Octets <= etherStatsPkts256to511Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts256to511Octets <= etherStatsPkts256to511Octets;
              default:            etherStatsPkts256to511Octets <= etherStatsPkts256to511Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts512to1023Octets 
  // - The total number of packets received that were between 512 and 1023 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts512to1023Octets <= REG_RESET_VALUE;
          case_etherStatsPkts512to1023Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts512to1023Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2A)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_512 && pkt_length_lt_1024) begin
                      case_etherStatsPkts512to1023Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts512to1023Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_512 && pkt_length_lt_1024)  begin
                      case_etherStatsPkts512to1023Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts512to1023Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts512to1023Octets)
              CASE_CLEAR:         etherStatsPkts512to1023Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts512to1023Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts512to1023Octets <= etherStatsPkts512to1023Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts512to1023Octets <= etherStatsPkts512to1023Octets;
              default:            etherStatsPkts512to1023Octets <= etherStatsPkts512to1023Octets;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts1024to1518Octets 
  // - The total number of packets received that were between 1024 and 1518 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts1024to1518Octets <= REG_RESET_VALUE;
          case_etherStatsPkts1024to1518Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts1024to1518Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2C)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_1024 && pkt_length_lt_eq_1518) begin
                      case_etherStatsPkts1024to1518Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts1024to1518Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_1024 && pkt_length_lt_eq_1518)  begin
                      case_etherStatsPkts1024to1518Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts1024to1518Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts1024to1518Octets)
              CASE_CLEAR:         etherStatsPkts1024to1518Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts1024to1518Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts1024to1518Octets <= etherStatsPkts1024to1518Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts1024to1518Octets <= etherStatsPkts1024to1518Octets;
              default:            etherStatsPkts1024to1518Octets <= etherStatsPkts1024to1518Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts1519toXOctets 
  // - The total number of packets received that were greater than 1519 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsPkts1519toXOctets <= REG_RESET_VALUE;
          case_etherStatsPkts1519toXOctets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts1519toXOctets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2E)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_1518) begin
                      case_etherStatsPkts1519toXOctets <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_etherStatsPkts1519toXOctets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_1518) begin
                      case_etherStatsPkts1519toXOctets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts1519toXOctets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts1519toXOctets)
              CASE_CLEAR:         etherStatsPkts1519toXOctets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts1519toXOctets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts1519toXOctets <= etherStatsPkts1519toXOctets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts1519toXOctets <= etherStatsPkts1519toXOctets;
              default:            etherStatsPkts1519toXOctets <= etherStatsPkts1519toXOctets;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsFragments 
  // - The total number of packets received that were less than 64 octets with CRC error. (error and invalid packets with CRC error)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsFragments <= REG_RESET_VALUE;
          case_etherStatsFragments <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsFragments <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h30)) begin
                  if (stat_sink_valid_reg & undersize_frame_err & crc_err) begin
                      case_etherStatsFragments <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsFragments <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & undersize_frame_err & crc_err)  begin
                      case_etherStatsFragments <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsFragments <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsFragments)
              CASE_CLEAR:         etherStatsFragments <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsFragments <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsFragments <= etherStatsFragments + 1'b1;
              CASE_UNCHANGED:     etherStatsFragments <= etherStatsFragments;
              default:            etherStatsFragments <= etherStatsFragments;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsJabbers 
  // - The total number of packets received that were longer than the configured maximum packet length with CRC error. (error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsJabbers <= REG_RESET_VALUE;
          case_etherStatsJabbers <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsJabbers <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h32)) begin
                  if (stat_sink_valid_reg & oversize_frame_err & crc_err) begin
                      case_etherStatsJabbers <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsJabbers <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & oversize_frame_err & crc_err)  begin
                      case_etherStatsJabbers <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsJabbers <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsJabbers)
              CASE_CLEAR:         etherStatsJabbers <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsJabbers <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsJabbers <= etherStatsJabbers + 1'b1;
              CASE_UNCHANGED:     etherStatsJabbers <= etherStatsJabbers;
              default:            etherStatsJabbers <= etherStatsJabbers;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsCRCErr
  // - The total number of packets received that had a length between 64 and the configured maximum packet length with CRC error. (error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsCRCErr <= REG_RESET_VALUE;
          case_etherStatsCRCErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsCRCErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h34)) begin
                  if (stat_sink_valid_reg & !oversize_frame_err & !undersize_frame_err & crc_err) begin
                      case_etherStatsCRCErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsCRCErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !oversize_frame_err  & !undersize_frame_err & crc_err) begin
                      case_etherStatsCRCErr <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsCRCErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsCRCErr)
              CASE_CLEAR:         etherStatsCRCErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsCRCErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsCRCErr <= etherStatsCRCErr + 1'b1;
              CASE_UNCHANGED:     etherStatsCRCErr <= etherStatsCRCErr;
              default:            etherStatsCRCErr <= etherStatsCRCErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment unicastMACCtrlFrames 
  // - Number of valid control frames transmitted/received to the unicast address. (good frames only)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          unicastMACCtrlFrames <= REG_RESET_VALUE;
          case_unicastMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_unicastMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h36)) begin
                  if (stat_sink_valid_reg & unicast_pkt & control_frame & !error) begin
                      case_unicastMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_unicastMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & unicast_pkt & control_frame & !error) begin
                      case_unicastMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_unicastMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_unicastMACCtrlFrames)
              CASE_CLEAR:         unicastMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  unicastMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        unicastMACCtrlFrames <= unicastMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     unicastMACCtrlFrames <= unicastMACCtrlFrames;
              default:            unicastMACCtrlFrames <= unicastMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment multicastMACCtrlFrames 
  // - Number of valid control frames transmitted/received to a multicast address. (good frames only)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          multicastMACCtrlFrames <= REG_RESET_VALUE;
          case_multicastMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_multicastMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h38)) begin
                  if (stat_sink_valid_reg & multicast_pkt & control_frame & !error) begin
                      case_multicastMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_multicastMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & multicast_pkt & control_frame & !error) begin
                      case_multicastMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_multicastMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_multicastMACCtrlFrames)
              CASE_CLEAR:         multicastMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  multicastMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        multicastMACCtrlFrames <= multicastMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     multicastMACCtrlFrames <= multicastMACCtrlFrames;
              default:            multicastMACCtrlFrames <= multicastMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment broadcastMACCtrlFrames 
  // - Number of valid control frames transmitted/received to a broadcast address. (good frames only)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk ) begin
      if (!csr_reset_n) begin
          broadcastMACCtrlFrames <= REG_RESET_VALUE;
          case_broadcastMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_broadcastMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h3A)) begin
                  if (stat_sink_valid_reg & broadcast_pkt & control_frame & !error) begin
                      case_broadcastMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_broadcastMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & broadcast_pkt & control_frame & !error) begin
                      case_broadcastMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_broadcastMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_broadcastMACCtrlFrames)
              CASE_CLEAR:         broadcastMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  broadcastMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        broadcastMACCtrlFrames <= broadcastMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     broadcastMACCtrlFrames <= broadcastMACCtrlFrames;
              default:            broadcastMACCtrlFrames <= broadcastMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment octetsOK
  // - A count of data and padding octets in frames that are successfully transmitted/receive. (good frames only including control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          octetsOK <= OCTET_REG_RESET_VALUE;
          case_octetsOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_octetsOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h8)) begin
                  if (stat_sink_valid_reg & !error & valid) begin
                      case_octetsOK <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_octetsOK <= CASE_CLEAR;
                  end
              end 
              else begin
                  if (stat_sink_valid_reg & !error & valid) begin
                      case_octetsOK <= CASE_UPDATE;
                  end
                  else begin
                      case_octetsOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_octetsOK)
              CASE_CLEAR:         octetsOK <= OCTET_REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  octetsOK <= OCTET_REG_RESET_VALUE + payload_length_reg; 
              CASE_UPDATE:        octetsOK <= octetsOK + payload_length_reg;
              CASE_UNCHANGED:     octetsOK <= octetsOK;
              default:            octetsOK <= octetsOK;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsOctets
  // - The total number of octets of data received on the network (good, error and invalid packets excluding framing bits but including FCS octets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk) begin
      if (!csr_reset_n) begin
          etherStatsOctets <= OCTET_REG_RESET_VALUE;
          case_etherStatsOctets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsOctets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h1A)) begin
                  if (stat_sink_valid_reg) begin
                      case_etherStatsOctets <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_etherStatsOctets <= CASE_CLEAR;
                  end
              end
              else begin
                  if(stat_sink_valid_reg) begin
                      case_etherStatsOctets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsOctets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsOctets)
              CASE_CLEAR:         etherStatsOctets <= OCTET_REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsOctets <= OCTET_REG_RESET_VALUE + pkt_length_reg; 
              CASE_UPDATE:        etherStatsOctets <= etherStatsOctets + pkt_length_reg;
              CASE_UNCHANGED:     etherStatsOctets <= etherStatsOctets;
              default:            etherStatsOctets <= etherStatsOctets;
          endcase
      end
  end
end else begin
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment framesOK
  // - Number of successfully transmitted/received frames. (good frames only including control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          framesOK <= REG_RESET_VALUE;
          case_framesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_framesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2)) begin
                  if (stat_sink_valid_reg & valid & !error) begin
                      case_framesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_framesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & valid & !error) begin
                      case_framesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_framesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_framesOK)
              CASE_CLEAR:         framesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  framesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        framesOK <= framesOK + 1'b1;
              CASE_UNCHANGED:     framesOK <= framesOK;
              default:            framesOK <= framesOK;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment framesErr
  // - Number of not successfully transmitted/received frames. (error frames only including control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          framesErr <= REG_RESET_VALUE;
          case_framesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_framesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h4)) begin
                  if (stat_sink_valid_reg & valid & error) begin
                      case_framesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_framesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & valid & error) begin
                      case_framesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_framesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_framesErr)
              CASE_CLEAR:         framesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  framesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        framesErr <= framesErr + 1'b1;
              CASE_UNCHANGED:     framesErr <= framesErr;
              default:            framesErr <= framesErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment framesCRCErr 
  // - Number of frames transmitted/received with CRC error. 
  //   (error frames including control frames but excluding frames with length smaller than 64 bytes or greater than the configured maximum length)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          framesCRCErr <= REG_RESET_VALUE;
          case_framesCRCErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_framesCRCErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h6)) begin
                  if (stat_sink_valid_reg & !oversize_frame_err & !undersize_frame_err & valid & crc_err) begin
                      case_framesCRCErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_framesCRCErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !oversize_frame_err  & !undersize_frame_err & valid & crc_err) begin
                      case_framesCRCErr <= CASE_UPDATE;
                  end
                  else begin
                      case_framesCRCErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_framesCRCErr)
              CASE_CLEAR:         framesCRCErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  framesCRCErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        framesCRCErr <= framesCRCErr + 1'b1;
              CASE_UNCHANGED:     framesCRCErr <= framesCRCErr;
              default:            framesCRCErr <= framesCRCErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment pauseMACCtrlFrames
  // - Number of valid PAUSE frames transmitted/received
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          pauseMACCtrlFrames <= REG_RESET_VALUE;
          case_pauseMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_pauseMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'hA)) begin
                  if (stat_sink_valid_reg & pause_pkt & !error) begin
                      case_pauseMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_pauseMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & pause_pkt & !error)  begin
                      case_pauseMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_pauseMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_pauseMACCtrlFrames)
              CASE_CLEAR:         pauseMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  pauseMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        pauseMACCtrlFrames <= pauseMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     pauseMACCtrlFrames <= pauseMACCtrlFrames;
              default:            pauseMACCtrlFrames <= pauseMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment pfcMACCtrlFrames
  // - Number of valid PAUSE frames transmitted/received
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          pfcMACCtrlFrames <= REG_RESET_VALUE;
          case_pfcMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_pfcMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h3C)) begin
                  if (stat_sink_valid_reg & pfc_pkt & !error) begin
                      case_pfcMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_pfcMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & pfc_pkt & !error)  begin
                      case_pfcMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_pfcMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_pfcMACCtrlFrames)
              CASE_CLEAR:         pfcMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  pfcMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        pfcMACCtrlFrames <= pfcMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     pfcMACCtrlFrames <= pfcMACCtrlFrames;
              default:            pfcMACCtrlFrames <= pfcMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment ifErrors
  // - The total number of packets that contain error and invalid packets.(error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          ifErrors <= REG_RESET_VALUE;
          case_ifErrors <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_ifErrors <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'hC)) begin
                  if (stat_sink_valid_reg & (error | !valid)) begin
                      case_ifErrors <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_ifErrors <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & (error | !valid))  begin
                      case_ifErrors <= CASE_UPDATE;
                  end
                  else begin
                      case_ifErrors <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_ifErrors)
              CASE_CLEAR:         ifErrors <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  ifErrors <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        ifErrors <= ifErrors + 1'b1;
              CASE_UNCHANGED:     ifErrors <= ifErrors;
              default:            ifErrors <= ifErrors;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment unicastFramesOK 
  // - Number of frames that are successfully received/transmitted (without error) and are directed to unicast address. 
  //     (good frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          unicastFramesOK <= REG_RESET_VALUE;
          case_unicastFramesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_unicastFramesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'hE)) begin
                  if (stat_sink_valid_reg & !error & unicast_pkt & !control_frame) begin
                      case_unicastFramesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_unicastFramesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !error & unicast_pkt & !control_frame)  begin
                      case_unicastFramesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_unicastFramesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_unicastFramesOK)
              CASE_CLEAR:         unicastFramesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  unicastFramesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        unicastFramesOK <= unicastFramesOK + 1'b1;
              CASE_UNCHANGED:     unicastFramesOK <= unicastFramesOK;
              default:            unicastFramesOK <= unicastFramesOK;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment unicastFramesErr 
  // - Number of frames that are successfully received (with error) and are directed to unicast address. (error frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          unicastFramesErr <= REG_RESET_VALUE;
          case_unicastFramesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_unicastFramesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h10)) begin
                  if (stat_sink_valid_reg & error & unicast_pkt & !control_frame) begin
                      case_unicastFramesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_unicastFramesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & error & unicast_pkt & !control_frame)  begin
                      case_unicastFramesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_unicastFramesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_unicastFramesErr)
              CASE_CLEAR:         unicastFramesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  unicastFramesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        unicastFramesErr <= unicastFramesErr + 1'b1;
              CASE_UNCHANGED:     unicastFramesErr <= unicastFramesErr;
              default:            unicastFramesErr <= unicastFramesErr;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment multicastFramesOK
  // - Number of successfully transmitted frames to a multicast address only. (good frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          multicastFramesOK <= REG_RESET_VALUE;
          case_multicastFramesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_multicastFramesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h12)) begin
                  if (stat_sink_valid_reg & !error & multicast_pkt & !control_frame) begin
                      case_multicastFramesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_multicastFramesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !error & multicast_pkt & !control_frame)  begin
                      case_multicastFramesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_multicastFramesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_multicastFramesOK)
              CASE_CLEAR:         multicastFramesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  multicastFramesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        multicastFramesOK <= multicastFramesOK + 1'b1;
              CASE_UNCHANGED:     multicastFramesOK <= multicastFramesOK;
              default:            multicastFramesOK <= multicastFramesOK;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment multicastFramesErr 
  // - Number of not successfully transmitted frames to a multicast address only. (error frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          multicastFramesErr <= REG_RESET_VALUE;
          case_multicastFramesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_multicastFramesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h14)) begin
                  if (stat_sink_valid_reg & error & multicast_pkt & !control_frame) begin
                      case_multicastFramesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_multicastFramesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & error & multicast_pkt & !control_frame)  begin
                      case_multicastFramesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_multicastFramesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_multicastFramesErr)
              CASE_CLEAR:         multicastFramesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  multicastFramesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        multicastFramesErr <= multicastFramesErr + 1'b1;
              CASE_UNCHANGED:     multicastFramesErr <= multicastFramesErr;
              default:            multicastFramesErr <= multicastFramesErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment broadcastFramesOK
  // - Number of the frames that were successfully transmitted to a broadcast address. (good frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          broadcastFramesOK <= REG_RESET_VALUE;
          case_broadcastFramesOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_broadcastFramesOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h16)) begin
                  if (stat_sink_valid_reg & !error & broadcast_pkt & !control_frame) begin
                      case_broadcastFramesOK <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_broadcastFramesOK <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !error & broadcast_pkt & !control_frame)  begin
                      case_broadcastFramesOK <= CASE_UPDATE;
                  end
                  else begin
                      case_broadcastFramesOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_broadcastFramesOK)
              CASE_CLEAR:         broadcastFramesOK <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  broadcastFramesOK <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        broadcastFramesOK <= broadcastFramesOK + 1'b1;
              CASE_UNCHANGED:     broadcastFramesOK <= broadcastFramesOK;
              default:            broadcastFramesOK <= broadcastFramesOK;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment broadcastFramesErr
  // - Number of the frames that were not successfully transmitted to a broadcast address (error frames only excluding control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          broadcastFramesErr <= REG_RESET_VALUE;
          case_broadcastFramesErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_broadcastFramesErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h18)) begin
                  if (stat_sink_valid_reg & error & broadcast_pkt & !control_frame) begin
                      case_broadcastFramesErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_broadcastFramesErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & error & broadcast_pkt & !control_frame)  begin
                      case_broadcastFramesErr <= CASE_UPDATE;
                  end
                  else begin
                      case_broadcastFramesErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_broadcastFramesErr)
              CASE_CLEAR:         broadcastFramesErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  broadcastFramesErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        broadcastFramesErr <= broadcastFramesErr + 1'b1;
              CASE_UNCHANGED:     broadcastFramesErr <= broadcastFramesErr;
              default:            broadcastFramesErr <= broadcastFramesErr;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts
  // - The total number of packets received. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts <= REG_RESET_VALUE;
          case_etherStatsPkts <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h1C)) begin
                  if (stat_sink_valid_reg) begin
                      case_etherStatsPkts <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg)  begin
                      case_etherStatsPkts <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts)
              CASE_CLEAR:         etherStatsPkts <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts <= etherStatsPkts + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts <= etherStatsPkts;
              default:            etherStatsPkts <= etherStatsPkts;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsUndersizePkts
  // - The total number of packets received that were less than 64 octets. (error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsUndersizePkts <= REG_RESET_VALUE;
          case_etherStatsUndersizePkts <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsUndersizePkts <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h1E)) begin
                  if (stat_sink_valid_reg & undersize_frame_err & !crc_err) begin
                      case_etherStatsUndersizePkts <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsUndersizePkts <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & undersize_frame_err & !crc_err)  begin
                      case_etherStatsUndersizePkts <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsUndersizePkts <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsUndersizePkts)
              CASE_CLEAR:         etherStatsUndersizePkts <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsUndersizePkts <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsUndersizePkts <= etherStatsUndersizePkts + 1'b1;
              CASE_UNCHANGED:     etherStatsUndersizePkts <= etherStatsUndersizePkts;
              default:            etherStatsUndersizePkts <= etherStatsUndersizePkts;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsOversizePkts 
  // - The total number of packets received that were longer than the configured maximum packet length. (error and invalid packets) 
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsOversizePkts <= REG_RESET_VALUE;
          case_etherStatsOversizePkts <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsOversizePkts <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h20)) begin
                  if (stat_sink_valid_reg & oversize_frame_err & !crc_err) begin
                      case_etherStatsOversizePkts <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsOversizePkts <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & oversize_frame_err & !crc_err)  begin
                      case_etherStatsOversizePkts <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsOversizePkts <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsOversizePkts)
              CASE_CLEAR:         etherStatsOversizePkts <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsOversizePkts <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsOversizePkts <= etherStatsOversizePkts + 1'b1;
              CASE_UNCHANGED:     etherStatsOversizePkts <= etherStatsOversizePkts;
              default:            etherStatsOversizePkts <= etherStatsOversizePkts;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts64Octets 
  // - The total number of packets received that were 64 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts64Octets <= REG_RESET_VALUE;
          case_etherStatsPkts64Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts64Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h22)) begin
                  if (stat_sink_valid_reg && pkt_length_eq_64) begin
                      case_etherStatsPkts64Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts64Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_eq_64)  begin
                      case_etherStatsPkts64Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts64Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts64Octets)
              CASE_CLEAR:         etherStatsPkts64Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts64Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts64Octets <= etherStatsPkts64Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts64Octets <= etherStatsPkts64Octets;
              default:            etherStatsPkts64Octets <= etherStatsPkts64Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts65to127Octets
  // - The total number of packets received that were between 65 and 127 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts65to127Octets <= REG_RESET_VALUE;
          case_etherStatsPkts65to127Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts65to127Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h24)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_64 && pkt_length_lt_128) begin
                      case_etherStatsPkts65to127Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts65to127Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_64 && pkt_length_lt_128)  begin
                      case_etherStatsPkts65to127Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts65to127Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts65to127Octets)
              CASE_CLEAR:         etherStatsPkts65to127Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts65to127Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts65to127Octets <= etherStatsPkts65to127Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts65to127Octets <= etherStatsPkts65to127Octets;
              default:            etherStatsPkts65to127Octets <= etherStatsPkts65to127Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts128to255Octets
  // - The total number of packets received that were between 128 and 255 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts128to255Octets <= REG_RESET_VALUE;
          case_etherStatsPkts128to255Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts128to255Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h26)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_128 && pkt_length_lt_256) begin
                      case_etherStatsPkts128to255Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts128to255Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_128 && pkt_length_lt_256)  begin
                      case_etherStatsPkts128to255Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts128to255Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts128to255Octets)
              CASE_CLEAR:         etherStatsPkts128to255Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts128to255Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts128to255Octets <= etherStatsPkts128to255Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts128to255Octets <= etherStatsPkts128to255Octets;
              default:            etherStatsPkts128to255Octets <= etherStatsPkts128to255Octets;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts256to511Octets 
  // - The total number of packets received that were between 256 and 511 octets in length1. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts256to511Octets <= REG_RESET_VALUE;
          case_etherStatsPkts256to511Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts256to511Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h28)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_256 && pkt_length_lt_512) begin
                      case_etherStatsPkts256to511Octets <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_etherStatsPkts256to511Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_256 && pkt_length_lt_512)  begin
                      case_etherStatsPkts256to511Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts256to511Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts256to511Octets)
              CASE_CLEAR:         etherStatsPkts256to511Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts256to511Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts256to511Octets <= etherStatsPkts256to511Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts256to511Octets <= etherStatsPkts256to511Octets;
              default:            etherStatsPkts256to511Octets <= etherStatsPkts256to511Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts512to1023Octets 
  // - The total number of packets received that were between 512 and 1023 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts512to1023Octets <= REG_RESET_VALUE;
          case_etherStatsPkts512to1023Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts512to1023Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2A)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_512 && pkt_length_lt_1024) begin
                      case_etherStatsPkts512to1023Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts512to1023Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_512 && pkt_length_lt_1024)  begin
                      case_etherStatsPkts512to1023Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts512to1023Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts512to1023Octets)
              CASE_CLEAR:         etherStatsPkts512to1023Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts512to1023Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts512to1023Octets <= etherStatsPkts512to1023Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts512to1023Octets <= etherStatsPkts512to1023Octets;
              default:            etherStatsPkts512to1023Octets <= etherStatsPkts512to1023Octets;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts1024to1518Octets 
  // - The total number of packets received that were between 1024 and 1518 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts1024to1518Octets <= REG_RESET_VALUE;
          case_etherStatsPkts1024to1518Octets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts1024to1518Octets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2C)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_1024 && pkt_length_lt_eq_1518) begin
                      case_etherStatsPkts1024to1518Octets <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts1024to1518Octets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_eq_1024 && pkt_length_lt_eq_1518)  begin
                      case_etherStatsPkts1024to1518Octets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts1024to1518Octets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts1024to1518Octets)
              CASE_CLEAR:         etherStatsPkts1024to1518Octets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts1024to1518Octets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts1024to1518Octets <= etherStatsPkts1024to1518Octets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts1024to1518Octets <= etherStatsPkts1024to1518Octets;
              default:            etherStatsPkts1024to1518Octets <= etherStatsPkts1024to1518Octets;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsPkts1519toXOctets 
  // - The total number of packets received that were greater than 1519 octets in length. (good, error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsPkts1519toXOctets <= REG_RESET_VALUE;
          case_etherStatsPkts1519toXOctets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsPkts1519toXOctets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h2E)) begin
                  if (stat_sink_valid_reg && pkt_length_gt_1518) begin
                      case_etherStatsPkts1519toXOctets <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_etherStatsPkts1519toXOctets <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg && pkt_length_gt_1518) begin
                      case_etherStatsPkts1519toXOctets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsPkts1519toXOctets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsPkts1519toXOctets)
              CASE_CLEAR:         etherStatsPkts1519toXOctets <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsPkts1519toXOctets <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsPkts1519toXOctets <= etherStatsPkts1519toXOctets + 1'b1;
              CASE_UNCHANGED:     etherStatsPkts1519toXOctets <= etherStatsPkts1519toXOctets;
              default:            etherStatsPkts1519toXOctets <= etherStatsPkts1519toXOctets;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsFragments 
  // - The total number of packets received that were less than 64 octets with CRC error. (error and invalid packets with CRC error)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsFragments <= REG_RESET_VALUE;
          case_etherStatsFragments <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsFragments <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h30)) begin
                  if (stat_sink_valid_reg & undersize_frame_err & crc_err) begin
                      case_etherStatsFragments <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsFragments <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & undersize_frame_err & crc_err)  begin
                      case_etherStatsFragments <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsFragments <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsFragments)
              CASE_CLEAR:         etherStatsFragments <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsFragments <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsFragments <= etherStatsFragments + 1'b1;
              CASE_UNCHANGED:     etherStatsFragments <= etherStatsFragments;
              default:            etherStatsFragments <= etherStatsFragments;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsJabbers 
  // - The total number of packets received that were longer than the configured maximum packet length with CRC error. (error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsJabbers <= REG_RESET_VALUE;
          case_etherStatsJabbers <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsJabbers <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h32)) begin
                  if (stat_sink_valid_reg & oversize_frame_err & crc_err) begin
                      case_etherStatsJabbers <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsJabbers <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & oversize_frame_err & crc_err)  begin
                      case_etherStatsJabbers <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsJabbers <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsJabbers)
              CASE_CLEAR:         etherStatsJabbers <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsJabbers <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsJabbers <= etherStatsJabbers + 1'b1;
              CASE_UNCHANGED:     etherStatsJabbers <= etherStatsJabbers;
              default:            etherStatsJabbers <= etherStatsJabbers;
          endcase
      end
  end
  
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsCRCErr
  // - The total number of packets received that had a length between 64 and the configured maximum packet length with CRC error. (error and invalid packets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsCRCErr <= REG_RESET_VALUE;
          case_etherStatsCRCErr <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsCRCErr <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h34)) begin
                  if (stat_sink_valid_reg & !oversize_frame_err & !undersize_frame_err & crc_err) begin
                      case_etherStatsCRCErr <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_etherStatsCRCErr <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & !oversize_frame_err  & !undersize_frame_err & crc_err) begin
                      case_etherStatsCRCErr <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsCRCErr <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsCRCErr)
              CASE_CLEAR:         etherStatsCRCErr <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsCRCErr <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        etherStatsCRCErr <= etherStatsCRCErr + 1'b1;
              CASE_UNCHANGED:     etherStatsCRCErr <= etherStatsCRCErr;
              default:            etherStatsCRCErr <= etherStatsCRCErr;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment unicastMACCtrlFrames 
  // - Number of valid control frames transmitted/received to the unicast address. (good frames only)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          unicastMACCtrlFrames <= REG_RESET_VALUE;
          case_unicastMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_unicastMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h36)) begin
                  if (stat_sink_valid_reg & unicast_pkt & control_frame & !error) begin
                      case_unicastMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_unicastMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & unicast_pkt & control_frame & !error) begin
                      case_unicastMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_unicastMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_unicastMACCtrlFrames)
              CASE_CLEAR:         unicastMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  unicastMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        unicastMACCtrlFrames <= unicastMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     unicastMACCtrlFrames <= unicastMACCtrlFrames;
              default:            unicastMACCtrlFrames <= unicastMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment multicastMACCtrlFrames 
  // - Number of valid control frames transmitted/received to a multicast address. (good frames only)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          multicastMACCtrlFrames <= REG_RESET_VALUE;
          case_multicastMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_multicastMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h38)) begin
                  if (stat_sink_valid_reg & multicast_pkt & control_frame & !error) begin
                      case_multicastMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_multicastMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & multicast_pkt & control_frame & !error) begin
                      case_multicastMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_multicastMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_multicastMACCtrlFrames)
              CASE_CLEAR:         multicastMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  multicastMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        multicastMACCtrlFrames <= multicastMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     multicastMACCtrlFrames <= multicastMACCtrlFrames;
              default:            multicastMACCtrlFrames <= multicastMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment broadcastMACCtrlFrames 
  // - Number of valid control frames transmitted/received to a broadcast address. (good frames only)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          broadcastMACCtrlFrames <= REG_RESET_VALUE;
          case_broadcastMACCtrlFrames <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_broadcastMACCtrlFrames <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h3A)) begin
                  if (stat_sink_valid_reg & broadcast_pkt & control_frame & !error) begin
                      case_broadcastMACCtrlFrames <= CASE_CLEAR_UPDATE;
                  end
                  else begin
                      case_broadcastMACCtrlFrames <= CASE_CLEAR;
                  end
              end
              else begin
                  if (stat_sink_valid_reg & broadcast_pkt & control_frame & !error) begin
                      case_broadcastMACCtrlFrames <= CASE_UPDATE;
                  end
                  else begin
                      case_broadcastMACCtrlFrames <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_broadcastMACCtrlFrames)
              CASE_CLEAR:         broadcastMACCtrlFrames <= REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  broadcastMACCtrlFrames <= REG_RESET_VALUE + 1'b1;
              CASE_UPDATE:        broadcastMACCtrlFrames <= broadcastMACCtrlFrames + 1'b1;
              CASE_UNCHANGED:     broadcastMACCtrlFrames <= broadcastMACCtrlFrames;
              default:            broadcastMACCtrlFrames <= broadcastMACCtrlFrames;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment octetsOK
  // - A count of data and padding octets in frames that are successfully transmitted/receive. (good frames only including control frames)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          octetsOK <= OCTET_REG_RESET_VALUE;
          case_octetsOK <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_octetsOK <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h8)) begin
                  if (stat_sink_valid_reg & !error & valid) begin
                      case_octetsOK <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_octetsOK <= CASE_CLEAR;
                  end
              end 
              else begin
                  if (stat_sink_valid_reg & !error & valid) begin
                      case_octetsOK <= CASE_UPDATE;
                  end
                  else begin
                      case_octetsOK <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_octetsOK)
              CASE_CLEAR:         octetsOK <= OCTET_REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  octetsOK <= OCTET_REG_RESET_VALUE + payload_length_reg; 
              CASE_UPDATE:        octetsOK <= octetsOK + payload_length_reg;
              CASE_UNCHANGED:     octetsOK <= octetsOK;
              default:            octetsOK <= octetsOK;
          endcase
      end
  end
  
  // ###########################################################################################
  // ---------------------------------------------------------------------------
  // Increment etherStatsOctets
  // - The total number of octets of data received on the network (good, error and invalid packets excluding framing bits but including FCS octets)
  // ---------------------------------------------------------------------------
  // ###########################################################################################
  always @(posedge clk or negedge csr_reset_n) begin
      if (!csr_reset_n) begin
          etherStatsOctets <= OCTET_REG_RESET_VALUE;
          case_etherStatsOctets <= CASE_RESET_VALUE;
      end
      else begin
          if (clr) begin
              case_etherStatsOctets <= CASE_CLEAR;
          end
          else begin
              if ((csr_read) && (csr_address == 6'h1A)) begin
                  if (stat_sink_valid_reg) begin
                      case_etherStatsOctets <= CASE_CLEAR_UPDATE; 
                  end
                  else begin
                      case_etherStatsOctets <= CASE_CLEAR;
                  end
              end
              else begin
                  if(stat_sink_valid_reg) begin
                      case_etherStatsOctets <= CASE_UPDATE;
                  end
                  else begin
                      case_etherStatsOctets <= CASE_UNCHANGED;
                  end
              end
          end
          
          case (case_etherStatsOctets)
              CASE_CLEAR:         etherStatsOctets <= OCTET_REG_RESET_VALUE;
              CASE_CLEAR_UPDATE:  etherStatsOctets <= OCTET_REG_RESET_VALUE + pkt_length_reg; 
              CASE_UPDATE:        etherStatsOctets <= etherStatsOctets + pkt_length_reg;
              CASE_UNCHANGED:     etherStatsOctets <= etherStatsOctets;
              default:            etherStatsOctets <= etherStatsOctets;
          endcase
      end
  end
end
endgenerate
endmodule

