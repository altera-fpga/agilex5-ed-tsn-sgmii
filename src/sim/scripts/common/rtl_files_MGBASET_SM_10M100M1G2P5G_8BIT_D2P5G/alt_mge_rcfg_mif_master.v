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

module alt_mge_rcfg_mif_master #(
    // ROM initialization MIF file
    parameter MODE_0_INIT_FILE          = "mode_0.mif",
    parameter MODE_1_INIT_FILE          = "mode_1.mif",
    parameter MODE_2_INIT_FILE          = "mode_2.mif",
    
    // MIF data format
    parameter MIF_DATA_OFFSET_LSB       = 0,
    parameter MIF_DATA_OFFSET_MSB       = 7,
    parameter MIF_DATA_WIDTH            = MIF_DATA_OFFSET_MSB - MIF_DATA_OFFSET_LSB + 1,
    parameter MIF_BIT_MASK_OFFSET_LSB   = 8,
    parameter MIF_BIT_MASK_OFFSET_MSB   = 15,
    parameter MIF_BIT_MASK_WIDTH        = MIF_BIT_MASK_OFFSET_MSB - MIF_BIT_MASK_OFFSET_LSB + 1,
    parameter MIF_DPRIO_ADDR_OFFSET_LSB = 16,
    parameter MIF_DPRIO_ADDR_OFFSET_MSB = 25,
    parameter MIF_DPRIO_ADDR_WIDTH      = MIF_DPRIO_ADDR_OFFSET_MSB - MIF_DPRIO_ADDR_OFFSET_LSB + 1,
    
    // ROM size
    // Assume largest size of 256 depth, this could be overridden by user if actual MIF size is smaller
    parameter MIF_DEPTH                 = 256,
    parameter MIF_ADDR_WIDTH            = 8,
    parameter MIF_CONTENT_WIDTH         = 26,
    
    // Index of MIF to be read from ROM and write to registers
    // Specify the largest range based on MIF_DEPTH, the state machine will end when all 1s are read from the ROM
    parameter MIF_READ_START_OFFSET     = 8'd0,
    parameter MIF_READ_NUM              = 9'd256,
    
    // Avalon-MM interface
    parameter AVM_ADDR_WIDTH            = MIF_DPRIO_ADDR_WIDTH,
    
    // Device family
    parameter DEVICE_FAMILY             = "Arria 10"
)
(
    input                       clk,
    input                       rst_n,
    
    input                       reconfig_start,
    output                      reconfig_busy,
    
    input  [1:0]                mif_select, // Latched when reconfig start
    
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
localparam STM_READ_MEM_DATA        = 5'b00010;
localparam STM_WAIT_MEM_DATA        = 5'b00100;
localparam STM_READ_HIP_DATA        = 5'b01000;
localparam STM_WRITE_HIP_DATA       = 5'b10000;

// State machine
reg   [4:0]                         state;
reg   [4:0]                         next_state;

// Avalon-MM master control
wire  [AVM_ADDR_WIDTH-1:0]          reconfig_address;
wire  [31:0]                        reconfig_writedata;

reg                                 reconfig_read_r;
reg                                 reconfig_write_r;
reg   [AVM_ADDR_WIDTH-1:0]          reconfig_address_r;
reg   [31:0]                        reconfig_writedata_r;
reg   [31:0]                        reconfig_readdata_r;

// Reconfig flow control
reg   [1:0]                         mif_select_r;
reg                                 reconfig_busy_r;
reg                                 reconfig_last_addr;
reg   [MIF_ADDR_WIDTH-1:0]          write_count;

// ROM related signals
wire                                rom_mode_0_clken;
wire  [MIF_ADDR_WIDTH-1:0]          rom_mode_0_addr_ptr;
wire  [MIF_CONTENT_WIDTH-1:0]       rom_mode_0_data_out;

wire                                rom_mode_1_clken;
wire  [MIF_ADDR_WIDTH-1:0]          rom_mode_1_addr_ptr;
wire  [MIF_CONTENT_WIDTH-1:0]       rom_mode_1_data_out;

wire                                rom_mode_2_clken;
wire  [MIF_ADDR_WIDTH-1:0]          rom_mode_2_addr_ptr;
wire  [MIF_CONTENT_WIDTH-1:0]       rom_mode_2_data_out;

wire  [MIF_CONTENT_WIDTH-1:0]       rom_data_out;

// Processed memory content
wire  [MIF_DPRIO_ADDR_WIDTH-1:0]    dprio_addr;
wire  [MIF_BIT_MASK_WIDTH-1:0]      dprio_bit_mask;
wire  [MIF_DATA_WIDTH-1:0]          dprio_data;
wire  [MIF_DATA_WIDTH-1:0]          dprio_writedata;

// ROM address counter
wire  [MIF_ADDR_WIDTH-1:0]          rom_addr_ptr_init;
reg   [MIF_ADDR_WIDTH-1:0]          rom_addr_ptr;
reg                                 rom_data_valid_p1;
reg                                 rom_data_valid_p2;
wire                                rom_data_valid;

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
                next_state = STM_READ_MEM_DATA;
            end
            else begin
                next_state = STM_IDLE;
            end
        end
        
        STM_READ_MEM_DATA: begin
            next_state = STM_WAIT_MEM_DATA;
        end
        
        STM_WAIT_MEM_DATA: begin
            if(rom_data_valid) begin
                if(&rom_data_out) begin
                    // If content of MIF is all 1s, it indicates end of reconfiguration data
                    next_state = STM_IDLE;
                end
                else begin
                    next_state = STM_READ_HIP_DATA;
                end
            end
            else begin
                next_state = STM_WAIT_MEM_DATA;
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
                if(reconfig_last_addr) begin
                    next_state = STM_IDLE;
                end
                else begin
                    next_state = STM_READ_MEM_DATA;
                end
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
        mif_select_r <= 2'b00;
        reconfig_busy_r <= 1'b0;
        reconfig_last_addr <= 1'b0;
        write_count <= {MIF_ADDR_WIDTH{1'b0}};
    end
    else begin
        
        // Store the MIF selection index when reconfig start during idle
        // The value will hold during other states
        if(state == STM_IDLE) begin
            mif_select_r <= mif_select;
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
        
        // Indicates last data to configure
        reconfig_last_addr <= (write_count >= MIF_READ_NUM - 1);
        
        // Count number of successful write
        if(state == STM_IDLE) begin
            write_count <= {MIF_ADDR_WIDTH{1'b0}};
        end
        else if(state == STM_WRITE_HIP_DATA) begin
            if(reconfig_write_r & ~reconfig_mgmt_waitrequest) begin
                write_count <= write_count + {{(MIF_ADDR_WIDTH-1){1'b0}}, 1'b1};
            end
        end
        
    end
end

assign reconfig_busy = reconfig_busy_r;

//
// ROM access control
//
assign rom_mode_0_clken = reconfig_busy_r & (mif_select_r == 2'b00);
assign rom_mode_1_clken = reconfig_busy_r & (mif_select_r == 2'b01);
assign rom_mode_2_clken = reconfig_busy_r & (mif_select_r == 2'b10);

assign rom_mode_0_addr_ptr = rom_addr_ptr;
assign rom_mode_1_addr_ptr = rom_addr_ptr;
assign rom_mode_2_addr_ptr = rom_addr_ptr;

assign rom_data_out = (mif_select_r == 2'b00) ? rom_mode_0_data_out :
                      (mif_select_r == 2'b01) ? rom_mode_1_data_out :
                      rom_mode_2_data_out;

assign rom_addr_ptr_init = MIF_READ_START_OFFSET;

//
// ROM: Mode 0
//
alt_mge_rcfg_mif_rom #(
    .INIT_FILE  (MODE_0_INIT_FILE),
    .DEPTH      (MIF_DEPTH),
    .ADDR_WIDTH (MIF_ADDR_WIDTH),
    .DATA_WIDTH (MIF_CONTENT_WIDTH),
    .DEVICE_FAMILY (DEVICE_FAMILY)
) u_rom_mode_0 (
    .clock      (clk),
    .clken      (rom_mode_0_clken),
    .address    (rom_mode_0_addr_ptr),
    .q          (rom_mode_0_data_out)
);

//
// ROM: Mode 1
//
alt_mge_rcfg_mif_rom #(
    .INIT_FILE  (MODE_1_INIT_FILE),
    .DEPTH      (MIF_DEPTH),
    .ADDR_WIDTH (MIF_ADDR_WIDTH),
    .DATA_WIDTH (MIF_CONTENT_WIDTH),
    .DEVICE_FAMILY (DEVICE_FAMILY)
) u_rom_mode_1 (
    .clock      (clk),
    .clken      (rom_mode_1_clken),
    .address    (rom_mode_1_addr_ptr),
    .q          (rom_mode_1_data_out)
);

//
// ROM: Mode 2
//
alt_mge_rcfg_mif_rom #(
    .INIT_FILE  (MODE_2_INIT_FILE),
    .DEPTH      (MIF_DEPTH),
    .ADDR_WIDTH (MIF_ADDR_WIDTH),
    .DATA_WIDTH (MIF_CONTENT_WIDTH),
    .DEVICE_FAMILY (DEVICE_FAMILY)
) u_rom_mode_2 (
    .clock      (clk),
    .clken      (rom_mode_2_clken),
    .address    (rom_mode_2_addr_ptr),
    .q          (rom_mode_2_data_out)
);

//
// Processing of memory content
//
assign dprio_data       = rom_data_out[MIF_DATA_OFFSET_MSB       : MIF_DATA_OFFSET_LSB];
assign dprio_bit_mask   = rom_data_out[MIF_BIT_MASK_OFFSET_MSB   : MIF_BIT_MASK_OFFSET_LSB];
assign dprio_addr       = rom_data_out[MIF_DPRIO_ADDR_OFFSET_MSB : MIF_DPRIO_ADDR_OFFSET_LSB];
assign dprio_writedata  = dprio_data & dprio_bit_mask;

assign reconfig_address = dprio_addr;
assign reconfig_writedata = dprio_writedata;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        rom_addr_ptr <= {MIF_ADDR_WIDTH{1'b0}};
        rom_data_valid_p1 <= 1'b0;
        rom_data_valid_p2 <= 1'b0;
    end
    else begin
        // Read from start index when reconfig start during idle
        if(state == STM_IDLE) begin
            rom_addr_ptr <= rom_addr_ptr_init;
        end
        else if(state == STM_WRITE_HIP_DATA) begin
            // Count up whenever Avalon-MM not busy, which indicates success of write
            if(reconfig_write_r & ~reconfig_mgmt_waitrequest) begin
                rom_addr_ptr <= rom_addr_ptr + {{(MIF_ADDR_WIDTH-1){1'b0}}, 1'b1};
            end
        end
        
        // Read latency of the ROM is 2 clock cycles
        if(state == STM_READ_MEM_DATA) begin
            rom_data_valid_p1 <= 1'b1;
        end
        else begin
            rom_data_valid_p1 <= 1'b0;
        end
        
        rom_data_valid_p2 <= rom_data_valid_p1;
        
    end
end

assign rom_data_valid = rom_data_valid_p2;

//
// Avalon MM master interface
//
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n) begin
        reconfig_read_r <= 1'b0;
        reconfig_write_r <= 1'b0;
        reconfig_address_r <= {AVM_ADDR_WIDTH{1'b0}};
        reconfig_writedata_r <= 32'h0;
        reconfig_readdata_r <= 32'h0;
    end
    else begin
        reconfig_address_r <= reconfig_address;
        reconfig_writedata_r <= (reconfig_readdata_r & ~(dprio_bit_mask)) | reconfig_writedata;
        
        case(state)
            
            STM_IDLE: begin
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_readdata_r     <= 32'h0;
            end
            
            STM_READ_MEM_DATA: begin
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_readdata_r     <= 32'h0;
            end
            
            STM_WAIT_MEM_DATA: begin
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
                reconfig_readdata_r     <= 32'h0;
            end
            
            STM_READ_HIP_DATA: begin
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= ~reconfig_read_r | reconfig_mgmt_waitrequest;
                
                if(~reconfig_mgmt_waitrequest) begin
                    reconfig_readdata_r <= reconfig_mgmt_readdata;
                end
            end
            
            STM_WRITE_HIP_DATA: begin
                reconfig_write_r        <= ~reconfig_write_r | reconfig_mgmt_waitrequest;
                reconfig_read_r         <= 1'b0;
                reconfig_readdata_r     <= reconfig_readdata_r;
            end
            
            default: begin
                reconfig_write_r        <= 1'b0;
                reconfig_read_r         <= 1'b0;
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
