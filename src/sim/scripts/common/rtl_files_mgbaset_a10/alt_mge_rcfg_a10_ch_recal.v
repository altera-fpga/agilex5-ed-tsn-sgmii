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

module alt_mge_rcfg_a10_ch_recal #(
    // Avalon-MM interface
    parameter AVM_ADDR_WIDTH = 10
)
(
    input                       clk,
    input                       rst_n,
    
    input                       reconfig_start,
    output                      reconfig_busy,
    
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
localparam STM_IDLE                 = 5'b00001;
localparam STM_WRITE_CAL_CTRL_USER  = 5'b00010;
localparam STM_WAIT_WAITREQUEST     = 5'b00100;
localparam STM_WRITE_RECAL          = 5'b01000;
localparam STM_WRITE_CAL_CTRL_UC    = 5'b10000;

// XCVR address offset
localparam CAL_CTRL_ADDR            = 10'h000;
localparam UC_CAL_ADDR              = 10'h100;

// State machine
reg   [4:0]                         state;
reg   [4:0]                         next_state;

// Logical PLL
wire  [3:0]                         logical_pll_src_lower;
wire  [3:0]                         logical_pll_src_upper;
wire  [3:0]                         logical_pll_src_selected;
wire  [7:0]                         logical_pll_src_encoded;

reg                                 reconfig_read_r;
reg                                 reconfig_write_r;
reg   [AVM_ADDR_WIDTH-1:0]          reconfig_address_r;
reg   [31:0]                        reconfig_writedata_r;

// Reconfig flow control
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
                next_state = STM_WRITE_CAL_CTRL_USER;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_WRITE_CAL_CTRL_USER: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WAIT_WAITREQUEST;
            end
            else begin
                next_state = STM_WRITE_CAL_CTRL_USER;
            end
        end
        
        STM_WAIT_WAITREQUEST: begin
            if(~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE_RECAL;
            end
            else begin
                next_state = STM_WAIT_WAITREQUEST;
            end
        end
        
        STM_WRITE_RECAL: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE_CAL_CTRL_UC;
            end
            else begin
                next_state = STM_WRITE_RECAL;
            end
        end
        
        STM_WRITE_CAL_CTRL_UC: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_IDLE;
            end
            else begin
                next_state = STM_WRITE_CAL_CTRL_UC;
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
        reconfig_busy_r <= 1'b0;
    end
    else begin
        
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
// Avalon MM master interface
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        reconfig_read_r         <= 1'b0;
        reconfig_write_r        <= 1'b0;
        reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
        reconfig_writedata_r    <= 32'h0;
    end
    else begin
        case(state)
            
            STM_IDLE: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
            end
            
            STM_WRITE_CAL_CTRL_USER: begin
                reconfig_address_r      <= CAL_CTRL_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h2;
            end
            
            STM_WAIT_WAITREQUEST: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
            end
            
            STM_WRITE_RECAL: begin
                reconfig_address_r      <= UC_CAL_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h26;
            end
            
            STM_WRITE_CAL_CTRL_UC: begin
                reconfig_address_r      <= CAL_CTRL_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h3;
            end
            
            default: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
            end
            
        endcase
        
    end
end

assign reconfig_mgmt_read = reconfig_read_r;
assign reconfig_mgmt_write = reconfig_write_r;
assign reconfig_mgmt_address = reconfig_address_r;
assign reconfig_mgmt_writedata = reconfig_writedata_r;

endmodule
