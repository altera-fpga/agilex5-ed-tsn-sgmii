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


// *****************************************************************************
// This confidential and proprietary software may be used only as authorized by 
// a licensing agreement from ALTERA                                            
// copyright notice must be reproduced on all authorized copies.                
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are 
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and 
// other intellectual property laws.                                                  
// *****************************************************************************
//  Project Name:  Crete3                                   
//  Module Name :  c3lib_sync2_reset_lvt_gate
//  Author      :  tschebye                                   
//  Date        :  Wed May  4 11:15:47 2016                                 
//  Description :  Primitive wrapper for '2 stage synchronizer with clear on rst_n'
//                 maps to a16lvt16_2xarstsyncdff1_b2 (LVT, 2x drive strength)
// *****************************************************************************

module c2_c3lib_sync2_reset_lvt_gate( 

  clk, 
  rst_n, 
  data_in,
  data_out

  ); 

input		clk; 
input		rst_n; 
input		data_in;
output		data_out;

`ifdef INT_C3LIB_RTL_MODE

  c2_c3lib_sync_metastable_behav_gate #(

    .RESET_VAL	( 0 ),
    .SYNC_STAGES( 2 )

  ) u_c3lib_sync2_reset_lvt_gate ( 

    .clk	( clk      ),
    .rst_n	( rst_n    ),
    .data_in	( data_in  ),
    .data_out	( data_out )

  );

`else

  SSYNC2DFCCNQD1ALTBWP22P90ULVT uu_c3lib_sync2_reset_lvt_gate(
  
    .D		( data_in  ),
    .CP		( clk      ),
    .Q		( data_out ),
  
    .CDN	( rst_n ),
  
    .SE		( 1'b0 ),
    .SI		( 1'b0 )
  
  );

`endif

endmodule 

