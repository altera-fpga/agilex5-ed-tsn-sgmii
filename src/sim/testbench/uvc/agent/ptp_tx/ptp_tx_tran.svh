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


//==============================================================================
// (C) 2011-2014 Altera Corporation. All rights reserved.
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
//
//------------------------------------------------------------------------------
// $File: $
// $Revision: $
// $Date: $
// $Author: $
// Created by: utbgen.pl by Hoong Han Leong
//==============================================================================

`ifndef __PTP_TX_TRAN_SVH__
`define __PTP_TX_TRAN_SVH__

//------------------------------------------------------------------------------
// Class: ptp_tx_tran
//
// This class defines the base for PTP_TX transaction.
//
//------------------------------------------------------------------------------
class ptp_tx_tran extends uvm_sequence_item;


   string      m_msg_id = {"PTP_TX", ".TRAN"};

   bit is_ptp_tx_tran;
   bit o_ptp_ets_valid ; 
   bit [95:0] o_ptp_ets ; 
   //bit [7:0] o_ptp_ets_fp; 
   bit [31:0] o_ptp_ets_fp; //set to max
   bit [4:0] o_ptp_ets_vl; 
   bit [4:0] i_ptp_ets_vl; 
   bit i_ptp_ets_vl_valid;
   bit [4:0] o_ptp_its_vl;
   bit [4:0] i_ptp_its_vl;
   bit i_ptp_its_vl_valid;
   bit o_ptp_its_vl_valid;
   bit ts_bytes_are_valid;
   bit [79:0] ts_bytes; //collect ts_bytes 
   bit cf_bytes_are_valid;
   bit [63:0] cf_bytes; //collect cf_bytes
   bit cs_bytes_are_valid;
   bit [15:0] cs_bytes; //collect cs_bytes
   bit [31:0] transaction_id;
    
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils_begin(ptp_tx_tran)
      `uvm_field_int(                o_ptp_ets_valid, UVM_ALL_ON)
      `uvm_field_int(                o_ptp_ets, UVM_ALL_ON)
      `uvm_field_int(                o_ptp_ets_fp, UVM_ALL_ON)
      `uvm_field_int(                o_ptp_ets_vl, UVM_ALL_ON)
      `uvm_field_int(                i_ptp_ets_vl, UVM_ALL_ON)
      `uvm_field_int(                i_ptp_ets_vl_valid, UVM_ALL_ON)
      `uvm_field_int(                o_ptp_its_vl, UVM_ALL_ON)
      `uvm_field_int(                i_ptp_its_vl, UVM_ALL_ON)
      `uvm_field_int(                i_ptp_its_vl_valid, UVM_ALL_ON)
      `uvm_field_int(                o_ptp_its_vl_valid, UVM_ALL_ON)
      `uvm_field_int(                ts_bytes_are_valid, UVM_ALL_ON | UVM_NOPACK)
      `uvm_field_int(                ts_bytes, UVM_ALL_ON | UVM_NOPACK)
      `uvm_field_int(                cf_bytes_are_valid, UVM_ALL_ON | UVM_NOPACK)
      `uvm_field_int(                cf_bytes, UVM_ALL_ON | UVM_NOPACK)
      `uvm_field_int(                cs_bytes_are_valid, UVM_ALL_ON | UVM_NOPACK)
      `uvm_field_int(                cs_bytes, UVM_ALL_ON | UVM_NOPACK)
      `uvm_field_int(		     transaction_id,UVM_ALL_ON | UVM_NOPACK)

   `uvm_object_utils_end

   //---------------------------------------------------------------------------
   // Constraints
   //---------------------------------------------------------------------------
// <<example>>: constraint wdata_c { wdata_c inside {['h1000:m_rtb_config.WDATA_MAX]}; }

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new(string name = "ptp_tx_tran");

      super.new(name);

      is_ptp_tx_tran = 1;

   endfunction : new
   //
   // Function: convert2string
   //
   // This function is called by do_print sprint method and is a way to convert
   // objects into string representation.
   //
   function string convert2string();
      return sprint();
   endfunction : convert2string
   //
   // Function: pre_randomize
   //
   function void pre_randomize();
   endfunction : pre_randomize

   //
   // Function: post_randomize
   //
   // Use the post_randomize to print the result of randomized call.
   //
   function void post_randomize();
      super.post_randomize();
      `uvm_info(m_msg_id, $sformatf(
            "post_randomize :\n%0s", convert2string()), UVM_HIGH)
   endfunction : post_randomize

endclass : ptp_tx_tran

`endif//__PTP_TX_TRAN_SVH__
