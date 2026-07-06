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

module alt_mge_rcfg_a10_txpll_switch #(
    // Avalon-MM interface
    parameter AVM_ADDR_WIDTH = 11
)
(
    input                       clk,
    input                       rst_n,
    
    input                       reconfig_start,
    output                      reconfig_busy,
    
    input  [1:0]                txpll_select, // Latched when reconfig start
    
    output [AVM_ADDR_WIDTH-1:0] reconfig_mgmt_address,
    output                      reconfig_mgmt_read,
    input  [31:0]               reconfig_mgmt_readdata,
    input                       reconfig_mgmt_waitrequest,
    output                      reconfig_mgmt_write,
    output [31:0]               reconfig_mgmt_writedata
);

//
// Local parameters declaration
//
// State definition
localparam STM_IDLE                 = 4'b001;
localparam STM_READ_HIP_DATA        = 4'b010;
localparam STM_WRITE_HIP_DATA       = 4'b100;

// XCVR address offset
localparam PLL_0_1_LOGICAL_ADDR     = 11'h117;
localparam PLL_3_4_LOGICAL_ADDR     = 11'h118;
localparam PLL_SELECT_MUX_ADDR      = 11'h111;

// State machine
reg   [2:0]                         state;
reg   [2:0]                         next_state;

// Logical PLL
wire  [3:0]                         logical_pll_src_lower;
wire  [3:0]                         logical_pll_src_upper;
wire  [3:0]                         logical_pll_src_selected;
wire  [7:0]                         logical_pll_src_encoded;

reg                                 reconfig_read_r;
reg                                 reconfig_write_r;
reg   [AVM_ADDR_WIDTH-1:0]          reconfig_address_r;
reg   [31:0]                        reconfig_writedata_r;
reg   [31:0]                        reconfig_readdata_r;

// Reconfig flow control
reg   [1:0]                         txpll_select_r;
reg                                 reconfig_busy_r;

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
                next_state = STM_READ_HIP_DATA;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_READ_HIP_DATA: begin
            if(reconfig_read_r & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE_HIP_DATA;
            end
            else begin
                next_state = STM_READ_HIP_DATA;
            end
        end
        
        STM_WRITE_HIP_DATA: begin
            if(reconfig_write_r & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_IDLE;
            end
            else begin
                next_state = STM_WRITE_HIP_DATA;
            end
        end
        
        default: begin
            next_state = STM_IDLE;
        end
        
    endcase
end

//
// Reconfiguration flow control
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        txpll_select_r <= 2'b00;
        reconfig_busy_r <= 1'b0;
    end
    else begin
        
        // Store the TX PLL selection index when reconfig start during idle
        // The value will hold during other states
        if(state == STM_IDLE) begin
            txpll_select_r <= txpll_select;
        end
        
        // Set status to busy when reconfig start
        if(state == STM_IDLE) begin
            if(reconfig_start) begin
                reconfig_busy_r <= 1'b1;
            end
            else begin
                reconfig_busy_r <= 1'b0;
            end
        end
        else begin
            reconfig_busy_r <= 1'b1;
        end
        
    end
end

assign reconfig_busy = reconfig_busy_r;

//
// Processing of memory content
//

assign {logical_pll_src_upper, logical_pll_src_lower} = reconfig_readdata_r[7:0];
assign logical_pll_src_selected = txpll_select_r[0] ? logical_pll_src_upper : logical_pll_src_lower;

assign logical_pll_src_encoded = {~logical_pll_src_selected[3],
                                   logical_pll_src_selected[1:0],
                                   logical_pll_src_selected[3],
                                   logical_pll_src_selected[3:0]
                                   };

//
// Avalon MM master interface
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        reconfig_read_r         <= 1'b0;
        reconfig_write_r        <= 1'b0;
        reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
        reconfig_writedata_r    <= 32'h0;
        reconfig_readdata_r     <= 32'h0;
    end
    else begin
        case(state)
            
            STM_IDLE: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
                reconfig_readdata_r     <= 32'h0;
            end
            
            STM_READ_HIP_DATA: begin
                reconfig_address_r      <= txpll_select[1] ? PLL_3_4_LOGICAL_ADDR : PLL_0_1_LOGICAL_ADDR;
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= ~reconfig_read_r | reconfig_mgmt_waitrequest;
                reconfig_writedata_r    <= 32'h0;
                
                if(~reconfig_mgmt_waitrequest) begin
                    reconfig_readdata_r <= reconfig_mgmt_readdata;
                end
            end
            
            STM_WRITE_HIP_DATA: begin
                reconfig_address_r      <= PLL_SELECT_MUX_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= logical_pll_src_encoded;
                reconfig_readdata_r     <= reconfig_readdata_r;
            end
            
            default: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
                reconfig_readdata_r     <= 32'h0;
            end
            
        endcase
    end
end

assign reconfig_mgmt_read = reconfig_read_r;
assign reconfig_mgmt_write = reconfig_write_r;
assign reconfig_mgmt_address = reconfig_address_r;
assign reconfig_mgmt_writedata = reconfig_writedata_r;

endmodule
