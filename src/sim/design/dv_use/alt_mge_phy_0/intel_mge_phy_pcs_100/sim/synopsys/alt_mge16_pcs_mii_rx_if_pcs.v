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


// -------------------------------------------------------------------------
// -------------------------------------------------------------------------
//
// Description : 
//
// Receive MII I/O Control
//
// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

`timescale 1ns/1ns
module alt_mge16_pcs_mii_rx_if_pcs (
   
   reset,
   rx_clk,
   rx_clkena,
   clk_ena,
   mii_rxd,
   mii_rxdv,
   mii_rxerr,
   mii_rxd_o,
   mii_rxdv_o,
   mii_rxerr_o,
   mii_alignment_status);
   
input   reset;                  //  Reset
input   rx_clk;                 //  MII Clock
input   rx_clkena;              //  Clock enable
input   clk_ena;                //  MII Clock Enable
input   [3:0] mii_rxd;          //  MII receive data
input   mii_rxdv;               //  MII receive frame enable  
input   mii_rxerr;              //  MII receive frame error
output  [7:0] mii_rxd_o;        //  MII receive data
output  mii_rxdv_o;             //  MII receive frame enable  
output  mii_rxerr_o;            //  MII receive frame error
output  mii_alignment_status;       //  Status of the alignment for latency calculation

reg     [3:0] mii_rxd_reg_0;
reg           mii_rxdv_reg_0;
reg           mii_rxerr_reg_0;
reg     [3:0] mii_rxd_reg_1;
reg           mii_rxdv_reg_1;
reg           mii_rxerr_reg_1;
reg     [3:0] mii_rxd_reg_2;
reg           mii_rxdv_reg_2;
reg           mii_rxerr_reg_2;

reg     packet_in_progress;
reg     align_pipeline_1_2;
//reg     alignment_error;

reg     [7:0] mii_rxd_o;
reg     mii_rxdv_o;
reg     mii_rxerr_o;

assign mii_alignment_status = align_pipeline_1_2;

always @(posedge rx_clk or posedge reset) begin
    if(reset) begin
        mii_rxd_reg_0   <= {4{1'b0}};
        mii_rxdv_reg_0  <= 1'b0;
        mii_rxerr_reg_0 <= 1'b0;
        
        mii_rxd_reg_1   <= {4{1'b0}};
        mii_rxdv_reg_1  <= 1'b0;
        mii_rxerr_reg_1 <= 1'b0;
        
        mii_rxd_reg_2   <= {4{1'b0}};
        mii_rxdv_reg_2  <= 1'b0;
        mii_rxerr_reg_2 <= 1'b0;
    end
    else begin
        if(rx_clkena) begin
            mii_rxd_reg_0   <= mii_rxd;
            mii_rxdv_reg_0  <= mii_rxdv;
            mii_rxerr_reg_0 <= mii_rxerr;
            
            mii_rxd_reg_1   <= mii_rxd_reg_0;
            mii_rxdv_reg_1  <= mii_rxdv_reg_0;
            mii_rxerr_reg_1 <= mii_rxerr_reg_0;
            
            mii_rxd_reg_2   <= mii_rxd_reg_1;
            mii_rxdv_reg_2  <= mii_rxdv_reg_1;
            mii_rxerr_reg_2 <= mii_rxerr_reg_1;
        end
    end
end

always @(posedge rx_clk or posedge reset) begin
    if(reset) begin
        packet_in_progress <= 1'b0;
        align_pipeline_1_2 <= 1'b1;
        //alignment_error <= 1'b0;
        
        mii_rxd_o <= {8{1'b0}};
        mii_rxdv_o <= 1'b0;
        mii_rxerr_o <= 1'b0;
    end
    else begin
        if(rx_clkena & clk_ena) begin
            
            // Detect packet start alignment, before any processing
            if(!packet_in_progress) begin
                
                //alignment_error <= 1'b0;
                
                // Align to pipeline 1 and pipeline 2
                if(mii_rxdv_reg_1 & mii_rxdv_reg_2) begin
                    packet_in_progress <= 1'b1;
                    align_pipeline_1_2 <= 1'b1;
                    
                    mii_rxd_o <= {mii_rxd_reg_1, mii_rxd_reg_2};
                    mii_rxdv_o <= 1'b1;
                    mii_rxerr_o <= mii_rxerr_reg_1 | mii_rxerr_reg_2;
                end
                
                // Align to pipeline 0 and pipeline 1
                else if(mii_rxdv_reg_0 & mii_rxdv_reg_1) begin
                    packet_in_progress <= 1'b1;
                    align_pipeline_1_2 <= 1'b0;
                    
                    mii_rxd_o <= {mii_rxd_reg_0, mii_rxd_reg_1};
                    mii_rxdv_o <= 1'b1;
                    mii_rxerr_o <= mii_rxerr_reg_0 | mii_rxerr_reg_1;
                end
                
                // No alignment detected
                else begin
                    packet_in_progress <= 1'b0;
                    align_pipeline_1_2 <= align_pipeline_1_2;
                    
                    mii_rxd_o <= {8{1'b0}};
                    mii_rxdv_o <= 1'b0;
                    mii_rxerr_o <= 1'b0;
                end
            end
            
            // After alignment is done, continuously output data
            else begin
                align_pipeline_1_2 <= align_pipeline_1_2;
                
                // If aligned to pipeline 1 and pipeline 2
                if(align_pipeline_1_2 == 1'b1) begin
                    if(mii_rxdv_reg_1 & mii_rxdv_reg_2) begin
                        packet_in_progress <= 1'b1;
                        //alignment_error <= 1'b0;
                        
                        mii_rxd_o <= {mii_rxd_reg_1, mii_rxd_reg_2};
                        mii_rxdv_o <= 1'b1;
                        mii_rxerr_o <= mii_rxerr_reg_1 | mii_rxerr_reg_2;
                    end
                    else if(mii_rxdv_reg_1 ^ mii_rxdv_reg_2) begin
                        packet_in_progress <= 1'b0;
                        //alignment_error <= 1'b1;
                        
                        mii_rxd_o <= {mii_rxd_reg_1, mii_rxd_reg_2};
                        mii_rxdv_o <= 1'b1;
                        mii_rxerr_o <= mii_rxerr_reg_1 | mii_rxerr_reg_2;
                    end
                    else begin
                        packet_in_progress <= 1'b0;
                        //alignment_error <= 1'b0;
                        
                        mii_rxd_o <= {8{1'b0}};
                        mii_rxdv_o <= 1'b0;
                        mii_rxerr_o <= 1'b0;
                    end
                end
                
                // If aligned to pipeline 0 and pipeline 1
                else if(align_pipeline_1_2 == 1'b0) begin
                    if(mii_rxdv_reg_0 & mii_rxdv_reg_1) begin
                        packet_in_progress <= 1'b1;
                        //alignment_error <= 1'b0;
                        
                        mii_rxd_o <= {mii_rxd_reg_0, mii_rxd_reg_1};
                        mii_rxdv_o <= 1'b1;
                        mii_rxerr_o <= mii_rxerr_reg_0 | mii_rxerr_reg_1;
                    end
                    else if(mii_rxdv_reg_0 ^ mii_rxdv_reg_1) begin
                        packet_in_progress <= 1'b0;
                        //alignment_error <= 1'b1;
                        
                        mii_rxd_o <= {mii_rxd_reg_0, mii_rxd_reg_1};
                        mii_rxdv_o <= 1'b1;
                        mii_rxerr_o <= mii_rxerr_reg_0 | mii_rxerr_reg_1;
                    end
                    else begin
                        packet_in_progress <= 1'b0;
                        //alignment_error <= 1'b0;
                        
                        mii_rxd_o <= {8{1'b0}};
                        mii_rxdv_o <= 1'b0;
                        mii_rxerr_o <= 1'b0;
                    end
                end
                
            end
        end
    end
end

endmodule // module mii_rx_if_pcs
