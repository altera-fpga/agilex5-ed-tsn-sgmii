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

module alt_mge_phy_usxg32_tx_data_mux (

    input wire          clk_312_5,
    input wire          reset_312_5_n,

    input wire [31:0]   tx_xgmii_rep_data_in,
    input wire [3:0]    tx_xgmii_rep_control_in,
    input wire          tx_xgmii_rep_valid_in,
    
    input wire [31:0]   tx_xgmii_auto_neg_data_in,
    input wire [3:0]    tx_xgmii_auto_neg_control_in,
    input wire          tx_xgmii_auto_neg_valid_in,
    
    input wire [31:0]   tx_xgmii_umii_fault_data_in,
    input wire [3:0]    tx_xgmii_umii_fault_control_in,
    input wire          tx_xgmii_umii_fault_valid_in,
    
    output reg  [31:0]  tx_xgmii_mux_data_out,
    output reg  [3:0]   tx_xgmii_mux_control_out,  
    output reg          tx_xgmii_mux_valid_out


);

localparam SYM_ERR          = 8'hFE;
localparam SYM_SEQ          = 8'h9C;
localparam SYM_REMOTE_FAULT      = 8'h02;
localparam SYM_LOCAL_FAULT  = 8'h01;
localparam SYM_IDLE         = 8'h07;


reg     detect_error;
reg     detect_link_fault;
reg     detect_umii_fault;
reg     detect_auto_eng;




always @ (*)
    begin
    // error condition. if error then pass the error out only. no need to latch the error. 
    if(tx_xgmii_rep_valid_in && ((tx_xgmii_rep_control_in[0] == 1'b1 && tx_xgmii_rep_data_in[7:0] == SYM_ERR) ||
    (tx_xgmii_rep_control_in[1] == 1'b1 && tx_xgmii_rep_data_in[15:8] == SYM_ERR) ||
    (tx_xgmii_rep_control_in[2] == 1'b1 && tx_xgmii_rep_data_in[23:16] == SYM_ERR) ||
    (tx_xgmii_rep_control_in[3] == 1'b1 && tx_xgmii_rep_data_in[31:24] == SYM_ERR)))
        begin
        detect_error = 1'b1;
        end
    else
        begin
        detect_error = 1'b0;
        end
    
    // remote fault condition. 
    if(tx_xgmii_rep_valid_in && (tx_xgmii_rep_control_in[0] == 1'b1 && tx_xgmii_rep_data_in[7:0] == SYM_SEQ) &&
    (tx_xgmii_rep_control_in[3] == 1'b0 && (tx_xgmii_rep_data_in[31:24] == SYM_REMOTE_FAULT || tx_xgmii_rep_data_in[31:24] == SYM_LOCAL_FAULT)))
        begin
        detect_link_fault = 1'b1;
        end
    else
        begin
        detect_link_fault = 1'b0;
        end
     
    detect_umii_fault = tx_xgmii_umii_fault_valid_in;
    detect_auto_eng = tx_xgmii_auto_neg_valid_in;

    end


    
always @ (posedge clk_312_5)
    begin
    if(!reset_312_5_n)
        begin
        tx_xgmii_mux_data_out <= {SYM_IDLE,SYM_IDLE,SYM_IDLE,SYM_IDLE};
        tx_xgmii_mux_control_out <= 4'b1111;
        tx_xgmii_mux_valid_out <= 1'b1;
        end
    else
        begin
        if(detect_umii_fault)
            begin
            tx_xgmii_mux_data_out <= tx_xgmii_umii_fault_data_in;
            tx_xgmii_mux_control_out <= tx_xgmii_umii_fault_control_in;
            tx_xgmii_mux_valid_out <= tx_xgmii_umii_fault_valid_in;
            end
        else if (detect_auto_eng && ~detect_error && ~detect_link_fault)    
            begin
            tx_xgmii_mux_data_out <= tx_xgmii_auto_neg_data_in;
            tx_xgmii_mux_control_out <= tx_xgmii_auto_neg_control_in;
            tx_xgmii_mux_valid_out <= tx_xgmii_auto_neg_valid_in;
            end
        else
        
            begin
            tx_xgmii_mux_data_out <= tx_xgmii_rep_data_in;
            tx_xgmii_mux_control_out <= tx_xgmii_rep_control_in;
            tx_xgmii_mux_valid_out <= tx_xgmii_rep_valid_in;
            end
        end
    end
    
    
   
endmodule



