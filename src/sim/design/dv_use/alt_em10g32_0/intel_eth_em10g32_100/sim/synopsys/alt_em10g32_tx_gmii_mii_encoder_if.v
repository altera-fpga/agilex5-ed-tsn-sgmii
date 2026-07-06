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


`timescale 1ns / 1ns
module alt_em10g32_tx_gmii_mii_encoder_if (

    reset,                  //INPUT :  Reset
    tx_clk,                 //INPUT :  MII Clock
    tx_clkena,              //INPUT :  Clock Enable
    enan,                   //INPUT :  Enable
    mii_txd,                //OUTPUT:  MII transmit data
    mii_txdv,               //OUTPUT:  MII transmit frame enable  
    mii_txerr,              //OUTPUT:  MII transmit frame error
    mii_txd_i,              //INPUT :  MII transmit data
    mii_txdv_i,             //INPUT :  MII transmit frame enable  
    mii_txerr_i             //INPUT :  MII transmit frame error
);

parameter GBIT_ONLY              = 1;   //  Gigabit only
parameter SYNCHRONIZER_DEPTH 	 = 3;   //  Number of synchronizer
parameter SYNC_RESET_N           = 1;

input   reset;                  //  Reset
input   tx_clk;                 //  MII Clock
input   tx_clkena;              //  Clock Enable
input   enan;                   //  Enable
output  [3:0] mii_txd;          //  MII transmit data
output  mii_txdv;               //  MII transmit frame enable  
output  mii_txerr;              //  MII transmit frame error
input   [7:0] mii_txd_i;        //  MII transmit data
input   mii_txdv_i;             //  MII transmit frame enable  
input   mii_txerr_i;            //  MII transmit frame error

//  Aligned MII Interface
//  ---------------------

reg     [3:0] mii_txd_int;      //  MII transmit data
reg     mii_txdv_int;           //  MII transmit frame enable  
reg     mii_txerr_int;          //  MII transmit frame error

wire    enan_reg2;

reg     mii_pos;

generate if (SYNC_RESET_N == 1) begin
always @(posedge tx_clk) begin
    if(reset) begin
        mii_pos <= 1'b0;
    end
    else begin
        if(tx_clkena) begin
            if(mii_txdv_i) begin
                mii_pos <= ~mii_pos;
            end
            else begin
                mii_pos <= 1'b0;
            end
        end
    end
end
end else begin
always @(posedge tx_clk or posedge reset) begin
    if(reset) begin
        mii_pos <= 1'b0;
    end
    else begin
        if(tx_clkena) begin
            if(mii_txdv_i) begin
                mii_pos <= ~mii_pos;
            end
            else begin
                mii_pos <= 1'b0;
            end
        end
    end
end
end
endgenerate

generate if (GBIT_ONLY == 1)
    begin
    
    alt_em10g32_std_synchronizer #(SYNCHRONIZER_DEPTH) U_SYNC_1(
      .clk(tx_clk), // INPUT
      .reset_n(~reset), //INPUT
      .din(enan), //INPUT
      .dout(enan_reg2));//OUTPUT
    
    end
else
    begin
    
    assign enan_reg2 = 1'b0;
    
    end
endgenerate

assign mii_txd   = mii_txd_int;
assign mii_txdv  = mii_txdv_int;
assign mii_txerr = mii_txerr_int;

generate if (SYNC_RESET_N == 1) begin
always @(posedge tx_clk)
    begin : process_1
    if (reset == 1'b 1)
        begin
        mii_txd_int   <= {4{1'b 0}};
        mii_txdv_int  <= 1'b 0; 
        mii_txerr_int <= 1'b 0; 
        end
    else
        begin
			if (tx_clkena == 1'b1) begin
                if (enan_reg2 == 1'b 0) begin
                
                    mii_txdv_int  <= mii_txdv_i;
                    mii_txerr_int <= mii_txerr_i;
                    
                    if (mii_pos == 1'b 1) begin
                        mii_txd_int <= mii_txd_i[7:4];
                    end
                    else begin
                        mii_txd_int <= mii_txd_i[3:0];
                    end
                    
                end
                else begin
                    mii_txd_int   <= {4{1'b 0}};
                    mii_txdv_int  <= 1'b 0;
                    mii_txerr_int <= 1'b 0;
		      end
	        end
		end
    end 
end else begin
always @(posedge reset or posedge tx_clk)
    begin : process_1
    if (reset == 1'b 1)
        begin
        mii_txd_int   <= {4{1'b 0}};
        mii_txdv_int  <= 1'b 0; 
        mii_txerr_int <= 1'b 0; 
        end
    else
        begin
			if (tx_clkena == 1'b1) begin
                if (enan_reg2 == 1'b 0) begin
                
                    mii_txdv_int  <= mii_txdv_i;
                    mii_txerr_int <= mii_txerr_i;
                    
                    if (mii_pos == 1'b 1) begin
                        mii_txd_int <= mii_txd_i[7:4];
                    end
                    else begin
                        mii_txd_int <= mii_txd_i[3:0];
                    end
                    
                end
                else begin
                    mii_txd_int   <= {4{1'b 0}};
                    mii_txdv_int  <= 1'b 0;
                    mii_txerr_int <= 1'b 0;
		      end
	        end
		end
    end 
end 
endgenerate


endmodule

