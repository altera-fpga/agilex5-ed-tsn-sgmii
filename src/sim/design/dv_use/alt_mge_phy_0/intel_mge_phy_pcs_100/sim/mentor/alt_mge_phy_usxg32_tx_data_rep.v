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


`timescale 1ps/1ps

module alt_mge_phy_usxg32_tx_data_rep
(

    input wire          clk_312_5,
    input wire          reset_312_5_n,
    
    input wire [31:0]   tx_xgmii_data_in,
    input wire [3:0]    tx_xgmii_control_in,
    input wire          tx_xgmii_valid_in,

    output reg [31:0]   tx_xgmii_data_out,
    output reg [3:0]    tx_xgmii_control_out,
    output reg          tx_xgmii_valid_out
    

);

localparam SYM_START            = 8'hFB;
localparam SYM_IDLE             = 8'h07;
localparam SYM_EFD              = 8'hFD;

reg [31:0]  tx_xgmii_data_in_dly1;
reg [3:0]  tx_xgmii_control_in_dly1;

reg detect_efd;
reg detect_start;

// this is first flop for PCS layer, hence need to 
always @ (posedge clk_312_5)
    begin
    if(!reset_312_5_n)
        begin
        tx_xgmii_data_in_dly1 <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
        tx_xgmii_control_in_dly1 <= 4'b1111;
        detect_efd <= 1'b0;
        detect_start <= 1'b0;
        end
    else
        begin
        if(tx_xgmii_valid_in)
            begin
            tx_xgmii_data_in_dly1 <= tx_xgmii_data_in;
            tx_xgmii_control_in_dly1 <= tx_xgmii_control_in;
            // previous module will make sure those valid will be hold during invalid cycle. 
            detect_efd <=   (tx_xgmii_data_in[7:0] == SYM_EFD && tx_xgmii_control_in[0] == 1'b1) |
                            (tx_xgmii_data_in[15:8] == SYM_EFD && tx_xgmii_control_in[1] == 1'b1) |
                            (tx_xgmii_data_in[23:16] == SYM_EFD && tx_xgmii_control_in[2] == 1'b1) |
                            (tx_xgmii_data_in[31:24] == SYM_EFD && tx_xgmii_control_in[3] == 1'b1);
            // detect_start <= tx_xgmii_data_in[7:0] == SYM_START && tx_xgmii_control_in[0] == 1'b1;  
            
            if(tx_xgmii_data_in[7:0] == SYM_START && tx_xgmii_control_in[0] == 1'b1)
                begin
                detect_start <= 1'b1;
                end
            else
                begin
                detect_start <= 1'b0;
                end
            end
        end
    end

always @ (posedge clk_312_5)
    begin
    tx_xgmii_valid_out <= 1'b1;
    if(!reset_312_5_n)
        begin
        tx_xgmii_data_out <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
        tx_xgmii_control_out <= 4'b1111;
        end
    else
        begin
            if(tx_xgmii_valid_in)
            begin
            tx_xgmii_data_out <= tx_xgmii_data_in;
            tx_xgmii_control_out <= tx_xgmii_control_in;
            end
        else
            begin
            if(detect_start)
                begin
                tx_xgmii_data_out <= {tx_xgmii_data_in_dly1[31:8],8'hAA};
                tx_xgmii_control_out <= 4'b0;        
                end
            else if(detect_efd)   
                begin
                tx_xgmii_data_out <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
                tx_xgmii_control_out <= 4'b1111;
                end
            else
                begin
                tx_xgmii_data_out <= tx_xgmii_data_in_dly1;
                tx_xgmii_control_out <= tx_xgmii_control_in_dly1;
                end
            end
        end    
    end

// assertion    
// no back to back START
//assert property ( @(posedge clk_312_5) disable iff (!reset_312_5_n) (tx_xgmii_data_out[7:0] == SYM_START && tx_xgmii_control_out[0])##1 |=> !(tx_xgmii_data_out[7:0] == SYM_START && tx_xgmii_control_out[0]) 
//else $error("back to back START");

// no back to back TERMINATE
//assert property ( @(posedge clk_312_5) disable iff (!reset_312_5_n) (tx_xgmii_data_out[7:0] == SYM_START && tx_xgmii_control_out[0])##1 |=> !(tx_xgmii_data_out[7:0] == SYM_START && tx_xgmii_control_out[0]) 
//else $error("back to back START");

endmodule 
