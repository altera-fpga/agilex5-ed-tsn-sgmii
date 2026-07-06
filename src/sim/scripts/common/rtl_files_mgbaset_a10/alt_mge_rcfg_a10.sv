// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.

`timescale 1 ps / 1 ps

module alt_mge_rcfg_a10 #(
    parameter NUM_OF_CHANNEL    = 1,
    parameter DEVICE_FAMILY     = "Arria 10",
    
    // Internal parameters, do not change
    parameter NUM_OF_CH_WIDTH   = log2ceil(NUM_OF_CHANNEL)
) ( 
    input                                   clk,
    input                                   rst_n,
    
    input                           [ 1:0]  csr_rcfg_address,
    input                                   csr_rcfg_read,
    input                                   csr_rcfg_write,
    input                           [31:0]  csr_rcfg_writedata,
    output reg                      [31:0]  csr_rcfg_readdata,
    
    output reg  [NUM_OF_CHANNEL-1:0][ 1:0]  mode_selected,
    
    output reg  [NUM_OF_CHANNEL-1:0]        reconfig_busy,
    
    output         [NUM_OF_CH_WIDTH + 9:0]  reconfig_xcvr_address,
    output                                  reconfig_xcvr_read,
    output                                  reconfig_xcvr_write,
    output                          [31:0]  reconfig_xcvr_writedata,
    input                           [31:0]  reconfig_xcvr_readdata,
    input                                   reconfig_xcvr_waitrequest
);

//
// Local parameters declaration
//

// State definition
localparam STM_IDLE                 = 5'b00001;
localparam STM_RECONFIG_XCVR        = 5'b00010;
localparam STM_RECONFIG_TXPLL       = 5'b00100;
localparam STM_RECONFIG_RXCDR       = 5'b01000;
localparam STM_RECONFIG_CH_RECAL    = 5'b10000;

// State machine
reg     [4:0]                   state;
reg     [4:0]                   next_state;

reg     [9:0]                   logical_channel_number;

reg                             reconfig_start;

reg     [1:0]                   speed_select;
wire    [1:0]                   txpll_select;
wire                            rx_cdr_refclk_select;

wire    [9:0]                   reconfig_mgmt_xcvr_address;
wire                            reconfig_mgmt_xcvr_read;
wire                            reconfig_mgmt_xcvr_write;
wire   [31:0]                   reconfig_mgmt_xcvr_writedata;
wire   [31:0]                   reconfig_mgmt_xcvr_readdata;
wire                            reconfig_mgmt_xcvr_waitrequest;

wire    [9:0]                   reconfig_mgmt_txpll_address;
wire                            reconfig_mgmt_txpll_read;
wire                            reconfig_mgmt_txpll_write;
wire   [31:0]                   reconfig_mgmt_txpll_writedata;
wire   [31:0]                   reconfig_mgmt_txpll_readdata;
wire                            reconfig_mgmt_txpll_waitrequest;

wire    [9:0]                   reconfig_mgmt_rxcdr_address;
wire                            reconfig_mgmt_rxcdr_read;
wire                            reconfig_mgmt_rxcdr_write;
wire   [31:0]                   reconfig_mgmt_rxcdr_writedata;
wire   [31:0]                   reconfig_mgmt_rxcdr_readdata;
wire                            reconfig_mgmt_rxcdr_waitrequest;

wire    [9:0]                   reconfig_mgmt_ch_recal_address;
wire                            reconfig_mgmt_ch_recal_read;
wire                            reconfig_mgmt_ch_recal_write;
wire   [31:0]                   reconfig_mgmt_ch_recal_writedata;
wire   [31:0]                   reconfig_mgmt_ch_recal_readdata;
wire                            reconfig_mgmt_ch_recal_waitrequest;

reg                             reconfig_xcvr_start;
wire                            reconfig_xcvr_busy;
reg                             reconfig_xcvr_busy_reg;
wire                            reconfig_xcvr_busy_negedge;

reg                             reconfig_txpll_start;
wire                            reconfig_txpll_busy;
reg                             reconfig_txpll_busy_reg;
wire                            reconfig_txpll_busy_negedge;

reg                             reconfig_rxcdr_start;
wire                            reconfig_rxcdr_busy;
reg                             reconfig_rxcdr_busy_reg;
wire                            reconfig_rxcdr_busy_negedge;

reg                             reconfig_ch_recal_start;
wire                            reconfig_ch_recal_busy;
reg                             reconfig_ch_recal_busy_reg;
wire                            reconfig_ch_recal_busy_negedge;

// Loop control variable
integer i;

assign reconfig_xcvr_address[NUM_OF_CH_WIDTH+9:10]  = logical_channel_number[NUM_OF_CH_WIDTH-1:0];
assign reconfig_xcvr_address[9:0]                   = (state == STM_RECONFIG_CH_RECAL) ? reconfig_mgmt_ch_recal_address   :
                                                      (state == STM_RECONFIG_TXPLL)    ? reconfig_mgmt_txpll_address      :
                                                      (state == STM_RECONFIG_RXCDR)    ? reconfig_mgmt_rxcdr_address      :
                                                                                         reconfig_mgmt_xcvr_address       ;
assign reconfig_xcvr_read                           = (state == STM_RECONFIG_CH_RECAL) ? reconfig_mgmt_ch_recal_read      :
                                                      (state == STM_RECONFIG_TXPLL)    ? reconfig_mgmt_txpll_read         :
                                                      (state == STM_RECONFIG_RXCDR)    ? reconfig_mgmt_rxcdr_read         :
                                                                                         reconfig_mgmt_xcvr_read          ;
assign reconfig_xcvr_write                          = (state == STM_RECONFIG_CH_RECAL) ? reconfig_mgmt_ch_recal_write     :
                                                      (state == STM_RECONFIG_TXPLL)    ? reconfig_mgmt_txpll_write        :
                                                      (state == STM_RECONFIG_RXCDR)    ? reconfig_mgmt_rxcdr_write        :
                                                                                         reconfig_mgmt_xcvr_write         ;
assign reconfig_xcvr_writedata                      = (state == STM_RECONFIG_CH_RECAL) ? reconfig_mgmt_ch_recal_writedata :
                                                      (state == STM_RECONFIG_TXPLL)    ? reconfig_mgmt_txpll_writedata    :
                                                      (state == STM_RECONFIG_RXCDR)    ? reconfig_mgmt_rxcdr_writedata    :
                                                                                         reconfig_mgmt_xcvr_writedata     ;

assign reconfig_mgmt_xcvr_readdata                  = reconfig_xcvr_readdata;
assign reconfig_mgmt_xcvr_waitrequest               = reconfig_xcvr_waitrequest;

assign reconfig_mgmt_txpll_readdata                 = reconfig_xcvr_readdata;
assign reconfig_mgmt_txpll_waitrequest              = reconfig_xcvr_waitrequest;

assign reconfig_mgmt_rxcdr_readdata                 = reconfig_xcvr_readdata;
assign reconfig_mgmt_rxcdr_waitrequest              = reconfig_xcvr_waitrequest;

assign reconfig_mgmt_ch_recal_readdata              = reconfig_xcvr_readdata;
assign reconfig_mgmt_ch_recal_waitrequest           = reconfig_xcvr_waitrequest;

//
// State machine
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        state <= STM_IDLE;
    end
    else begin
        state <= next_state;
    end
end

always @(*)
begin
    case(state)
        
        STM_IDLE: begin
            if(reconfig_start) begin
                next_state = STM_RECONFIG_XCVR;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_RECONFIG_XCVR: begin
            if(reconfig_xcvr_busy_negedge) begin
                next_state = STM_RECONFIG_TXPLL;
            end
            else begin
                next_state = STM_RECONFIG_XCVR;
            end
        end
        
        STM_RECONFIG_TXPLL: begin
            if(reconfig_txpll_busy_negedge) begin
                next_state = STM_RECONFIG_RXCDR;
            end
            else begin
                next_state = STM_RECONFIG_TXPLL;
            end
        end
        
        STM_RECONFIG_RXCDR: begin
            if(reconfig_rxcdr_busy_negedge) begin
                next_state = STM_RECONFIG_CH_RECAL;
            end
            else begin
                next_state = STM_RECONFIG_RXCDR;
            end
        end
        
        STM_RECONFIG_CH_RECAL: begin
            if(reconfig_ch_recal_busy_negedge) begin
                next_state = STM_IDLE;
            end
            else begin
                next_state = STM_RECONFIG_CH_RECAL;
            end
        end
        
        default: begin
            next_state = STM_IDLE;
        end
        
    endcase
end

assign reconfig_xcvr_busy_negedge = reconfig_xcvr_busy_reg & ~reconfig_xcvr_busy;
assign reconfig_txpll_busy_negedge = reconfig_txpll_busy_reg & ~reconfig_txpll_busy;
assign reconfig_rxcdr_busy_negedge = reconfig_rxcdr_busy_reg & ~reconfig_rxcdr_busy;
assign reconfig_ch_recal_busy_negedge = reconfig_ch_recal_busy_reg & ~reconfig_ch_recal_busy;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reconfig_xcvr_busy_reg <= 1'b0;
        reconfig_txpll_busy_reg <= 1'b0;
        reconfig_rxcdr_busy_reg <= 1'b0;
        reconfig_ch_recal_busy_reg <= 1'b0;
        
        reconfig_xcvr_start <= 1'b0;
        reconfig_txpll_start <= 1'b0;
        reconfig_rxcdr_start <= 1'b0;
        reconfig_ch_recal_start <= 1'b0;
    end
    else begin
        reconfig_xcvr_busy_reg <= reconfig_xcvr_busy;
        reconfig_txpll_busy_reg <= reconfig_txpll_busy;
        reconfig_rxcdr_busy_reg <= reconfig_rxcdr_busy;
        reconfig_ch_recal_busy_reg <= reconfig_ch_recal_busy;
        
        reconfig_xcvr_start <= reconfig_start;
        reconfig_txpll_start <= reconfig_xcvr_busy_negedge;
        reconfig_rxcdr_start <= reconfig_txpll_busy_negedge;
        reconfig_ch_recal_start <= reconfig_rxcdr_busy_negedge;
    end
end

// CSR Read
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        csr_rcfg_readdata <= 32'h00;
    end
    else begin
        if(csr_rcfg_read) begin
            case(csr_rcfg_address)
                
                // Logical channel number
                2'h0 : begin
                    csr_rcfg_readdata <= {22'h0, logical_channel_number};
                end
                
                // Control
                2'h1 : begin
                    csr_rcfg_readdata <= {15'h0, reconfig_start, 14'h0, speed_select};
                end
                
                // Status
                2'h2 : begin
                    csr_rcfg_readdata <= {31'h0, |reconfig_busy};
                end
                
                default: begin
                    csr_rcfg_readdata <= 32'h0;
                end
                
            endcase
        end
    end
end

// CSR Write
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        logical_channel_number  <= 10'h000;
        speed_select            <= 2'b11;
        reconfig_start          <= 1'b0;
    end
    else begin
        
        // Allow to write only when reconfiguration is not in progress
        if(state == STM_IDLE) begin
            
            if(csr_rcfg_write && (csr_rcfg_address == 2'h0)) begin
                logical_channel_number <= csr_rcfg_writedata[9:0];
            end
            
            if(csr_rcfg_write && (csr_rcfg_address == 2'h1)) begin
                speed_select <= csr_rcfg_writedata[1:0];
            end
            
            if(csr_rcfg_write && (csr_rcfg_address == 2'h1)) begin
                reconfig_start <= csr_rcfg_writedata[16];
            end
            
        end
        else begin
            
            // Self clear
            reconfig_start <= 1'b0;
            
        end
        
    end
end

assign txpll_select = (speed_select == 2'b00) ? 2'h1 :
                      (speed_select == 2'b01) ? 2'h0 : 2'h2;

assign rx_cdr_refclk_select = (speed_select[1] == 1'b0) ? 1'b0 : 1'b1;

alt_mge_rcfg_a10_mif_master #(
    // Device family
    .DEVICE_FAMILY              (DEVICE_FAMILY),
    
    // ROM initialization MIF file
    .MODE_0_INIT_FILE           ("alt_mge_rcfg_a10_xcvr_1g.mif"),
    .MODE_1_INIT_FILE           ("alt_mge_rcfg_a10_xcvr_2p5g.mif"),
    .MODE_2_INIT_FILE           ("alt_mge_rcfg_a10_xcvr_10g.mif")
) u_mif_master (
    .clk                        (clk),
    .rst_n                      (rst_n),
    
    .reconfig_start             (reconfig_xcvr_start),
    .reconfig_busy              (reconfig_xcvr_busy),
    
    .mif_select                 (speed_select[1] ? 2'b10 : speed_select),
    
    .reconfig_mgmt_address      (reconfig_mgmt_xcvr_address),
    .reconfig_mgmt_read         (reconfig_mgmt_xcvr_read),
    .reconfig_mgmt_readdata     (reconfig_mgmt_xcvr_readdata),
    .reconfig_mgmt_waitrequest  (reconfig_mgmt_xcvr_waitrequest),
    .reconfig_mgmt_write        (reconfig_mgmt_xcvr_write),
    .reconfig_mgmt_writedata    (reconfig_mgmt_xcvr_writedata)
);

alt_mge_rcfg_a10_txpll_switch u_txpll_switch (
    .clk                        (clk),
    .rst_n                      (rst_n),
    
    .reconfig_start             (reconfig_txpll_start),
    .reconfig_busy              (reconfig_txpll_busy),
    
    .txpll_select               (txpll_select),
    
    .reconfig_mgmt_address      (reconfig_mgmt_txpll_address),
    .reconfig_mgmt_read         (reconfig_mgmt_txpll_read),
    .reconfig_mgmt_readdata     (reconfig_mgmt_txpll_readdata),
    .reconfig_mgmt_waitrequest  (reconfig_mgmt_txpll_waitrequest),
    .reconfig_mgmt_write        (reconfig_mgmt_txpll_write),
    .reconfig_mgmt_writedata    (reconfig_mgmt_txpll_writedata)
);

alt_mge_rcfg_a10_rxcdr_switch u_rxcdr_switch (
    .clk                        (clk),
    .rst_n                      (rst_n),
    
    .reconfig_start             (reconfig_rxcdr_start),
    .reconfig_busy              (reconfig_rxcdr_busy),
    
    .rx_cdr_refclk_select       (rx_cdr_refclk_select),
    
    .reconfig_mgmt_address      (reconfig_mgmt_rxcdr_address),
    .reconfig_mgmt_read         (reconfig_mgmt_rxcdr_read),
    .reconfig_mgmt_readdata     (reconfig_mgmt_rxcdr_readdata),
    .reconfig_mgmt_waitrequest  (reconfig_mgmt_rxcdr_waitrequest),
    .reconfig_mgmt_write        (reconfig_mgmt_rxcdr_write),
    .reconfig_mgmt_writedata    (reconfig_mgmt_rxcdr_writedata)
);

alt_mge_rcfg_a10_ch_recal u_ch_recal (
    .clk                        (clk),
    .rst_n                      (rst_n),
    
    .reconfig_start             (reconfig_ch_recal_start),
    .reconfig_busy              (reconfig_ch_recal_busy),
    
    .reconfig_mgmt_address      (reconfig_mgmt_ch_recal_address),
    .reconfig_mgmt_read         (reconfig_mgmt_ch_recal_read),
    .reconfig_mgmt_readdata     (reconfig_mgmt_ch_recal_readdata),
    .reconfig_mgmt_waitrequest  (reconfig_mgmt_ch_recal_waitrequest),
    .reconfig_mgmt_write        (reconfig_mgmt_ch_recal_write),
    .reconfig_mgmt_writedata    (reconfig_mgmt_ch_recal_writedata)
);

// Mode selected output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        // The reset value must match with default transceiver mode
        mode_selected <= {NUM_OF_CHANNEL{2'b11}};
    end
    else begin
        if(reconfig_start) begin
            mode_selected[logical_channel_number] <= speed_select;
        end
    end
end

// Reconfig busy indication
always @(*) begin
    for(i = 0; i < NUM_OF_CHANNEL; i = i + 1) begin
        if(state != STM_IDLE) begin
            reconfig_busy[i] = (i == logical_channel_number) ? 1'b1 : 1'b0;
        end
        else begin
            reconfig_busy[i] = 1'b0;
        end
    end
end

// --------------------------------------------------
// Calculates the log2ceil of the input value
// --------------------------------------------------
function integer log2ceil;
    input integer val;
    integer i;
    
    begin
        i = 1;
        log2ceil = 0;
        
        if (val == 1) begin
            return 1;
        end
        
        while (i < val) begin
            log2ceil = log2ceil + 1;
            i = i << 1; 
        end
    end
endfunction

endmodule
