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

module alt_mge_rcfg_28nm #(
    parameter NUM_OF_CHANNEL        = 1,
    parameter DEVICE_FAMILY         = "Arria V"
) (
    input                                   clk,
    input                                   rst_n,
    
    input                           [ 1:0]  csr_rcfg_address,
    input                                   csr_rcfg_read,
    output reg                      [31:0]  csr_rcfg_readdata,
    input                                   csr_rcfg_write,
    input                           [31:0]  csr_rcfg_writedata,
    
    output reg  [NUM_OF_CHANNEL-1:0][ 1:0]  mode_selected,
    
    output reg  [NUM_OF_CHANNEL-1:0]        reconfig_busy,
    
    output [((NUM_OF_CHANNEL+2) * 70) - 1:0]reconfig_to_xcvr,    // +2 channels for two TX PLLs
    input  [((NUM_OF_CHANNEL+2) * 46) - 1:0]reconfig_from_xcvr   // +2 channels for two TX PLLs
);

//
// Local parameters declaration
//
// State definition
localparam STM_IDLE                             = 4'h0;
localparam STM_SET_LOGICAL_CHANNEL_NUMBER       = 4'h1;
localparam STM_SET_DIRECT_MODE                  = 4'h2;
localparam STM_SET_OFFSET                       = 4'h3;
localparam STM_READ                             = 4'h4;
localparam STM_WAIT_READ_BUSY                   = 4'h5;
localparam STM_GET_DATA                         = 4'h6;
localparam STM_SET_DATA                         = 4'h7;
localparam STM_WRITE                            = 4'h8;

// Address offset
localparam ADDR_STREAMER_LOGICAL_CHANNEL_NUMBER = 7'h38;
localparam ADDR_STREAMER_CONTROL_AND_STATUS     = 7'h3A;
localparam ADDR_STREAMER_OFFSET                 = 7'h3B;
localparam ADDR_STREAMER_DATA                   = 7'h3C;

localparam ADDR_PLL_RCFG_LOGICAL_CHANNEL_NUMBER = 7'h40;
localparam ADDR_PLL_RCFG_CONTROL_AND_STATUS     = 7'h42;
localparam ADDR_PLL_RCFG_OFFSET                 = 7'h43;
localparam ADDR_PLL_RCFG_DATA                   = 7'h44;

// State machine
reg    [3:0]                    state;
reg    [3:0]                    next_state;

reg    [9:0]                    logical_channel_number;
reg                             reconfig_start;

reg    [1:0]                    speed_select;

reg    [6:0]                    reconfig_mgmt_address;
reg                             reconfig_mgmt_read;
wire  [31:0]                    reconfig_mgmt_readdata;
wire                            reconfig_mgmt_waitrequest;
reg                             reconfig_mgmt_write;
reg   [31:0]                    reconfig_mgmt_writedata;

reg   [31:0]                    readdata;

reg    [1:0]                    wait_read_busy_counter;

wire                            xcvr_reconfig_busy;

reg                             switch_tx_pll;
reg    [1:0]                    streamer_count;

wire   [6:0]                    addr_logical_channel_number;
wire   [6:0]                    addr_control_and_status;
wire   [6:0]                    addr_offset;
wire   [6:0]                    addr_data;
wire   [6:0]                    rcfg_address;

wire  [31:0]                    pll_rcfg_offset;
wire  [31:0]                    pll_rcfg_1g_data;
wire  [31:0]                    pll_rcfg_2p5g_data;
wire  [31:0]                    pll_rcfg_data;

wire   [1:0][31:0]              streamer_offset;
wire   [1:0][31:0]              streamer_1g_data;
wire   [1:0][31:0]              streamer_2p5g_data;
wire   [1:0][31:0]              streamer_data;
wire   [1:0][31:0]              streamer_mask;

wire  [31:0]                    writedata_offset;
wire  [31:0]                    writedata_data;
wire  [31:0]                    writedata_write;

// Loop control variable
integer i;

// Data for reconfiguration
assign pll_rcfg_offset              = 32'h 1;

assign pll_rcfg_1g_data             = 32'h 1;
assign pll_rcfg_2p5g_data           = 32'h 0;
assign pll_rcfg_data                = (speed_select == 2'b00) ? pll_rcfg_1g_data : pll_rcfg_2p5g_data;

assign streamer_offset      [0]     = 32'h 0E;
assign streamer_offset      [1]     = 32'h 10;

assign streamer_1g_data     [0]     = 32'b 0000111010000000;
assign streamer_1g_data     [1]     = 32'b 1000010001010000;

assign streamer_2p5g_data   [0]     = 32'b 0110000101000000;
assign streamer_2p5g_data   [1]     = 32'b 1000001101100000;
assign streamer_data                = (speed_select == 2'b00) ? streamer_1g_data : streamer_2p5g_data;

assign streamer_mask        [0]     = 32'b 1111111111000000;
assign streamer_mask        [1]     = 32'b 0000011111110000;

assign addr_logical_channel_number  = switch_tx_pll ? ADDR_PLL_RCFG_LOGICAL_CHANNEL_NUMBER : ADDR_STREAMER_LOGICAL_CHANNEL_NUMBER;
assign addr_control_and_status      = switch_tx_pll ? ADDR_PLL_RCFG_CONTROL_AND_STATUS     : ADDR_STREAMER_CONTROL_AND_STATUS;
assign addr_offset                  = switch_tx_pll ? ADDR_PLL_RCFG_OFFSET                 : ADDR_STREAMER_OFFSET;
assign addr_data                    = switch_tx_pll ? ADDR_PLL_RCFG_DATA                   : ADDR_STREAMER_DATA;

assign writedata_offset             = switch_tx_pll ? pll_rcfg_offset : streamer_offset[streamer_count];
assign writedata_data               = switch_tx_pll ? pll_rcfg_data : (readdata & ~streamer_mask[streamer_count]) | (streamer_data[streamer_count] & streamer_mask[streamer_count]);
assign writedata_write              = switch_tx_pll ? 32'h1 : 32'h5;

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
                next_state = STM_SET_LOGICAL_CHANNEL_NUMBER;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_SET_LOGICAL_CHANNEL_NUMBER: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                
                // Configure to direct mode for streamer operation
                if(switch_tx_pll) begin
                    next_state = STM_SET_OFFSET;
                end
                else begin
                    next_state = STM_SET_DIRECT_MODE;
                end
            end
            else begin
                next_state = STM_SET_LOGICAL_CHANNEL_NUMBER;
            end
        end
        
        STM_SET_DIRECT_MODE: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_SET_OFFSET;
            end
            else begin
                next_state = STM_SET_DIRECT_MODE;
            end
        end
        
        STM_SET_OFFSET: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                if(switch_tx_pll) begin
                    next_state = STM_SET_DATA;
                end
                else begin
                    next_state = STM_READ;
                end
            end
            else begin
                next_state = STM_SET_OFFSET;
            end
        end
        
        STM_READ: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WAIT_READ_BUSY;
            end
            else begin
                next_state = STM_READ;
            end
        end
        
        STM_WAIT_READ_BUSY: begin
            if(&wait_read_busy_counter) begin
                next_state = STM_GET_DATA;
            end
            else begin
                next_state = STM_WAIT_READ_BUSY;
            end
        end
        
        STM_GET_DATA: begin
            if(reconfig_mgmt_read & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_SET_DATA;
            end
            else begin
                next_state = STM_GET_DATA;
            end
        end
        
        STM_SET_DATA: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE;
            end
            else begin
                next_state = STM_SET_DATA;
            end
        end
        
        STM_WRITE: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                if(streamer_count < 2'h1) begin
                    next_state = STM_SET_LOGICAL_CHANNEL_NUMBER;
                end
                else begin
                    next_state = STM_IDLE;
                end
            end
            else begin
                next_state = STM_WRITE;
            end
        end
        
        default: begin
            next_state = STM_IDLE;
        end
        
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reconfig_mgmt_address   <= 7'h0;
        reconfig_mgmt_read      <= 1'b0;
        reconfig_mgmt_write     <= 1'b0;
        reconfig_mgmt_writedata <= 32'h0;
        
        readdata                <= 32'h0;
        
        wait_read_busy_counter  <= 2'h0;
        
        switch_tx_pll           <= 1'b1;
        streamer_count          <= 2'h0;
    end
    else begin
        case(state)
            
            STM_IDLE: begin
                reconfig_mgmt_address   <= 7'h0;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= 1'b0;
                reconfig_mgmt_writedata <= 32'h0;
                
                switch_tx_pll           <= 1'b1;
                streamer_count          <= 2'h0;
            end
            
            STM_SET_LOGICAL_CHANNEL_NUMBER: begin
                reconfig_mgmt_address   <= addr_logical_channel_number;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= reconfig_mgmt_write ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_writedata <= {22'h0, logical_channel_number};
            end
            
            STM_SET_DIRECT_MODE: begin
                reconfig_mgmt_address   <= addr_control_and_status;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= reconfig_mgmt_write ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_writedata <= 32'h4;
            end
            
            STM_SET_OFFSET: begin
                reconfig_mgmt_address   <= addr_offset;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= reconfig_mgmt_write ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_writedata <= writedata_offset;
            end
            
            STM_READ: begin
                reconfig_mgmt_address   <= addr_control_and_status;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= reconfig_mgmt_write ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_writedata <= 32'h6;
                
                wait_read_busy_counter  <= 2'h0;
            end
            
            STM_WAIT_READ_BUSY: begin
                reconfig_mgmt_address   <= 7'h0;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= 1'b0;
                reconfig_mgmt_writedata <= 32'h0;
                
                wait_read_busy_counter  <= wait_read_busy_counter + 2'h1;
            end
            
            STM_GET_DATA: begin
                reconfig_mgmt_address   <= addr_data;
                reconfig_mgmt_read      <= reconfig_mgmt_read ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_write     <= 1'b0;
                reconfig_mgmt_writedata <= 32'h0;
                
                if(~reconfig_mgmt_waitrequest) begin
                    readdata            <= reconfig_mgmt_readdata;
                end
            end
            
            STM_SET_DATA: begin
                reconfig_mgmt_address   <= addr_data;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= reconfig_mgmt_write ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_writedata <= writedata_data;
            end
            
            STM_WRITE: begin
                reconfig_mgmt_address   <= addr_control_and_status;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= reconfig_mgmt_write ? reconfig_mgmt_waitrequest : ~xcvr_reconfig_busy;
                reconfig_mgmt_writedata <= writedata_write;
                
                if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                    if(switch_tx_pll) begin
                        // Switch from TX PLL reconfig mode to streamer mode
                        switch_tx_pll   <= 1'b0;
                    end
                    else begin
                        // Next streamer mode reconfig data
                        streamer_count  <= streamer_count + 2'h1;
                    end
                end
            end
            
            default: begin
                reconfig_mgmt_address   <= 7'h0;
                reconfig_mgmt_read      <= 1'b0;
                reconfig_mgmt_write     <= 1'b0;
                reconfig_mgmt_writedata <= 32'h0;
            end
            
        endcase
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
        speed_select            <= 2'b00;
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

// Transceiver reconfig IP
alt_mge_xcvr_rcfg u_xcvr_rcfg (
    // Clock & reset
    .mgmt_clk_clk               (clk),
    .mgmt_rst_reset             (~rst_n),
    
    // Management interface
    .reconfig_mgmt_address      (reconfig_mgmt_address),
    .reconfig_mgmt_write        (reconfig_mgmt_write),
    .reconfig_mgmt_read         (reconfig_mgmt_read),
    .reconfig_mgmt_writedata    (reconfig_mgmt_writedata),
    .reconfig_mgmt_readdata     (reconfig_mgmt_readdata),
    .reconfig_mgmt_waitrequest  (reconfig_mgmt_waitrequest),
    
    // Read from ROM
    .reconfig_mif_address       (),
    .reconfig_mif_read          (),
    .reconfig_mif_readdata      (16'h0),
    .reconfig_mif_waitrequest   (1'b0),
    
    // Reconfig busy status
    .reconfig_busy              (xcvr_reconfig_busy),
    
    // Reconfig interface to/from transceiver
    .reconfig_to_xcvr           (reconfig_to_xcvr),
    .reconfig_from_xcvr         (reconfig_from_xcvr)
);

// Mode selected output
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        // The reset value must match with default transceiver mode
        mode_selected <= {NUM_OF_CHANNEL{2'b01}};
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

endmodule
