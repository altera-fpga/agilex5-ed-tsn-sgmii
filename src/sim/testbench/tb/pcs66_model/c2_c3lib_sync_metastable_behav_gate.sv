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


// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_c3lib_sync_metastable_behav_gate.sv $
// $Revision: #15 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5 
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/c3lib_sync_metastable_behav_gate.sv
// Date: Fri Mar 17 14:27:26 2017
//-------------------------------------------------------------------------------
// *****************************************************************************
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
// *****************************************************************************
// Copyright © 2016 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
// *****************************************************************************
//  Description :  Behavioral model (incl. metastability) of a synchronizer
// *****************************************************************************

module c2_c3lib_sync_metastable_behav_gate #(

  parameter RESET_VAL        = 0,	// Reset value
  parameter SYNC_STAGES      = 2	// Number of sync stages (NOTE - min. 2)

) (

  clk,
  rst_n,
  data_in,
  data_out

);

  // Ports
  input		clk;
  input		rst_n;
  input		data_in;
  output	data_out;

  // Variables
  var	logic[ (SYNC_STAGES-1) : 0 ]	sync_regs;
`ifndef EMULATION_MODE_FOR_QPRIME_COMPILATION
  var	logic				meta_reg;
  integer				meta_counter;
  var	logic				meta_cycle;
  localparam				META_COUNT = 256;
  var	logic				en_metastability;
`endif

  // Reset value to eliminate truncation warning
  localparam reset_value = (RESET_VAL == 0) ? 1'b0 : 1'b1;

  // Enable/disable meta-stability control
`ifndef EMULATION_MODE_FOR_QPRIME_COMPILATION
  initial begin
    en_metastability = ($test$plusargs("C3LIB_META_SIM"));
  end
`endif

  // Sync Always block
  always @(negedge rst_n or posedge clk) begin
    if (rst_n == 1'b0)
      sync_regs[ (SYNC_STAGES-1) : 1 ] <= { (SYNC_STAGES-1) {reset_value} };
    else
      sync_regs[ (SYNC_STAGES-1) : 1 ] <= sync_regs[ (SYNC_STAGES-2) : 0 ];
  end

  //Add a filtering counter to reduce the occurance of "metastability" events
  //Useful for modeling low frequency of meta events such as a pseudo-sync event
`ifndef EMULATION_MODE_FOR_QPRIME_COMPILATION
  always @(negedge rst_n or posedge clk) begin
    if (rst_n == 1'b0) begin
      meta_counter <= 0; //up to 1024 cycles between meta events
      meta_cycle   <= 1'b0;
    end
    else begin
      if (meta_counter >= META_COUNT) begin
        meta_counter <= 0;
        meta_cycle   <= $random(); //every N cycles, randomly add an extra cycle to one or more bits ...
      end
      else begin
        meta_counter <= meta_counter + 1;
        meta_cycle   <= 1'b0;
      end
    end
  end
`endif

  // NF: both FF stages have reset
  always @(negedge rst_n or posedge clk) begin
    if (rst_n == 1'b0) begin
      sync_regs[ 0 ] <= reset_value;
`ifndef EMULATION_MODE_FOR_QPRIME_COMPILATION
      meta_reg       <= reset_value;
`endif
    end
    else begin
`ifndef EMULATION_MODE_FOR_QPRIME_COMPILATION
      meta_reg     <= data_in;
      sync_regs[0] <= (en_metastability == 1) ? meta_cycle?  meta_reg : data_in : data_in;
`else
      sync_regs[0] <= data_in;
`endif
    end
  end

  assign data_out = sync_regs[ (SYNC_STAGES-1) ];

endmodule

