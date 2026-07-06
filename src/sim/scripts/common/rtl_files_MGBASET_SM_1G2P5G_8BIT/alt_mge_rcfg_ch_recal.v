// (C) 2001-2021 Intel Corporation. All rights reserved.
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

module alt_mge_rcfg_ch_recal #(
    // Avalon-MM interface
    parameter AVM_ADDR_WIDTH = 10,
    parameter DEVICE_FAMILY  = "Arria 10"
)
(
    input                       clk,
    input                       rst_n,
    
    input                       tx_cal_busy,
    input                       rx_cal_busy,
    
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
localparam STM_IDLE                  = 7'b0000001;
localparam STM_READ_RECAL            = 7'b0000010;
localparam STM_WRITE_RECAL           = 7'b0000100;
localparam STM_READ_CDR_RATE_SWITCH  = 7'b0001000;
localparam STM_WRITE_CDR_RATE_SWITCH = 7'b0010000;
localparam STM_WRITE_CAL_CTRL_UC     = 7'b0100000;
localparam STM_WAIT_CAL_BUSY         = 7'b1000000;

// XCVR address offset
localparam CAL_CTRL_ADDR            = 10'h000;
localparam UC_CAL_ADDR              = 10'h100;
localparam CDR_RATE_SWITCH_ADDR     = 10'h166;

// State machine
reg   [6:0]                         state;
reg   [6:0]                         next_state;

reg                                 reconfig_read_r;
reg                                 reconfig_write_r;
reg   [AVM_ADDR_WIDTH-1:0]          reconfig_address_r;
reg   [31:0]                        reconfig_writedata_r;

// Reconfig flow control
reg                                 reconfig_busy_r;

reg   [31:0]                        cal_status;
reg   [31:0]                        cdr_status;
reg                                 tx_cal_busy_r;
reg                                 rx_cal_busy_r;
reg                                 tx_cal_done;
reg                                 rx_cal_done;

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
                next_state = STM_READ_RECAL;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_READ_RECAL: begin
            if(reconfig_mgmt_read & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE_RECAL;
            end
            else begin
                next_state = STM_READ_RECAL;
            end
        end
        
        STM_WRITE_RECAL: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = (DEVICE_FAMILY == "Arria 10") ? STM_READ_CDR_RATE_SWITCH : STM_WRITE_CAL_CTRL_UC;
            end
            else begin
                next_state = STM_WRITE_RECAL;
            end
        end
        
        STM_READ_CDR_RATE_SWITCH: begin
            if(reconfig_mgmt_read & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE_CDR_RATE_SWITCH;
            end
            else begin
                next_state = STM_READ_CDR_RATE_SWITCH;
            end
        end
        
        STM_WRITE_CDR_RATE_SWITCH: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WRITE_CAL_CTRL_UC;
            end
            else begin
                next_state = STM_WRITE_CDR_RATE_SWITCH;
            end
        end
        
        STM_WRITE_CAL_CTRL_UC: begin
            if(reconfig_mgmt_write & ~reconfig_mgmt_waitrequest) begin
                next_state = STM_WAIT_CAL_BUSY;
            end
            else begin
                next_state = STM_WRITE_CAL_CTRL_UC;
            end
        end
        
        STM_WAIT_CAL_BUSY: begin
            if(tx_cal_done & rx_cal_done) begin
                next_state = STM_IDLE;
            end
            else begin
                next_state = STM_WAIT_CAL_BUSY;
            end
        end

        default: begin
            next_state = STM_IDLE;
        end
        
    endcase
end

//
// Check for *_cal_busy status
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        tx_cal_busy_r <= 1'b0;
        rx_cal_busy_r <= 1'b0;
        tx_cal_done <= 1'b0;
        rx_cal_done <= 1'b0;
    end
    else begin
        tx_cal_busy_r <= tx_cal_busy;
        rx_cal_busy_r <= rx_cal_busy;
        
        if (tx_cal_busy_r & ~tx_cal_busy) begin
            tx_cal_done <= 1'b1;
        end
        else begin
            if (state == STM_WAIT_CAL_BUSY) begin
                tx_cal_done <= tx_cal_done;
            end
            else begin
                tx_cal_done <= 1'b0;
            end
        end
        
        if (rx_cal_busy_r & ~rx_cal_busy) begin
            rx_cal_done <= 1'b1;
        end
        else begin
            if (state == STM_WAIT_CAL_BUSY) begin
                rx_cal_done <= rx_cal_done;
            end
            else begin
                rx_cal_done <= 1'b0;
            end
        end
        
    end
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
        cal_status              <= 32'h0;
        cdr_status              <= 32'h0;
    end
    else begin
        case(state)
            
            STM_IDLE: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
            end
            
            STM_READ_RECAL: begin
                reconfig_address_r      <= UC_CAL_ADDR;
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= ~reconfig_read_r | reconfig_mgmt_waitrequest;
                reconfig_writedata_r    <= 32'h0;
                
                if(~reconfig_mgmt_waitrequest) begin
                    cal_status              <= reconfig_mgmt_readdata;
                end
            end
            
            STM_WRITE_RECAL: begin
                reconfig_address_r      <= UC_CAL_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= (DEVICE_FAMILY == "Arria 10") ? (cal_status & ~(32'h62)) | 32'h22
                                                                         : (cal_status & ~(32'h3)) | 32'h3;
                cal_status              <= cal_status;
            end
            
            STM_READ_CDR_RATE_SWITCH: begin
                reconfig_address_r      <= CDR_RATE_SWITCH_ADDR;
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= ~reconfig_read_r | reconfig_mgmt_waitrequest;
                reconfig_writedata_r    <= 32'h0;
                
                if(~reconfig_mgmt_waitrequest) begin
                    cdr_status              <= reconfig_mgmt_readdata;
                end
            end
            
            STM_WRITE_CDR_RATE_SWITCH: begin
                reconfig_address_r      <= CDR_RATE_SWITCH_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= (cdr_status & ~(32'h80)) | 32'h0;
                cdr_status              <= cdr_status;
            end
            
            STM_WRITE_CAL_CTRL_UC: begin
                reconfig_address_r      <= CAL_CTRL_ADDR;
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h1;
            end
            
            STM_WAIT_CAL_BUSY: begin
                reconfig_address_r      <= {AVM_ADDR_WIDTH{1'b0}};
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_writedata_r    <= 32'h0;
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
