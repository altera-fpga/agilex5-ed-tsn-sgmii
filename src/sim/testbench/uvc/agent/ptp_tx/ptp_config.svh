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
// Created by: 
//==============================================================================

`ifndef __PTP_CONFIG_SVH__
`define __PTP_CONFIG_SVH__

//------------------------------------------------------------------------------
// Class: ptp_config
//
//
//------------------------------------------------------------------------------
class ptp_config extends uvm_object;

   rand bit [47:0] tod_seconds_part; 
   rand bit [31:0] tod_ns_part;
        real       tod_fns_part;
   rand bit [47:0] ing_seconds_part; 
   rand bit [31:0] ing_ns_part;
        bit        rand_tod = 1;
        bit        user_tod = 0;
  rand bit         large_ing_than_tod_s;
  rand bit         large_ing_than_tod_ns;


   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils_begin(ptp_config)
    `uvm_field_int(tod_seconds_part, UVM_ALL_ON)
    `uvm_field_int(tod_ns_part, UVM_ALL_ON)
    `uvm_field_int(ing_seconds_part, UVM_ALL_ON)
    `uvm_field_int(ing_ns_part, UVM_ALL_ON)
    `uvm_field_int(rand_tod, UVM_ALL_ON)
    `uvm_field_int(user_tod, UVM_ALL_ON)
    `uvm_field_real(tod_fns_part, UVM_ALL_ON)
    `uvm_field_int(large_ing_than_tod_s, UVM_ALL_ON)
    `uvm_field_int(large_ing_than_tod_ns, UVM_ALL_ON)
   `uvm_object_utils_end
      
   //---------------------------------------------------------------------------
   // Constraints
   //---------------------------------------------------------------------------
   constraint tod_ingress_control_c {
           if(rand_tod==1'b1) {
             tod_seconds_part inside {[0:48'hEFFF_FFFF_FFFF]};
             tod_ns_part inside {['d0:'d850000]};  // 0us - 850us
             ing_ns_part inside {['d0:'d850000]};  // 0us - 850us
           }

           if(user_tod==1'b1 || rand_tod==1'b1) {
             //Differance between tod and ing seconds part is [0:3]
             if(large_ing_than_tod_s==0) { 
                 (tod_seconds_part > ing_seconds_part);
                 (tod_seconds_part - ing_seconds_part) inside {[0:2]};
             }
             else {
                 (ing_seconds_part > tod_seconds_part);
                 (ing_seconds_part - tod_seconds_part) inside {[0:3]};
             }
   
             //Differance between tod and ing ns part is [0:250] us
             if(large_ing_than_tod_ns==0) { 
                  (tod_ns_part > ing_ns_part);
                  (tod_ns_part - ing_ns_part) inside {[32'd0:32'd250000]};
             } 
             else { 
                  (ing_ns_part > tod_ns_part);
                  (ing_ns_part - tod_ns_part) inside {[32'd0:32'd250000]};
             } 
          
           }
           else {
             tod_seconds_part == 0;
             ing_seconds_part == 0;
             tod_ns_part == 0;
             ing_ns_part == 0;
             //ing_ns_part inside {[-500:-50]}; // 50ns - 500ns
           }
   }
   //keeping large_ing_than_tod_s = 0 as we do not want to generate ingree TS  > egress TS
   constraint large_ing_than_tod_s_c {
     large_ing_than_tod_s == 0;
   }
    
   constraint order {solve large_ing_than_tod_s before tod_seconds_part,ing_seconds_part;
                     solve large_ing_than_tod_ns before tod_ns_part,ing_ns_part;
                    } 

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new(string name = "ptp_config");
      super.new(name);
   endfunction : new
  

endclass : ptp_config

`endif//__PTP_CONFIG_SVH__
