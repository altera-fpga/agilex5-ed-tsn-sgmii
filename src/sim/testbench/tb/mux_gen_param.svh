//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Module: mux_gen_param
//
// Random Variant's contraint definition and variant file generator for
// MUX.
//
//------------------------------------------------------------------------------

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "mux.svh"  // All the Enum types is defined in this file


//---------------------------------------------------------------------------
// Random constraint definition class (Base Class)
//---------------------------------------------------------------------------
class gen_param_base extends uvm_object;

   //------------------------------------------------------------------------
   // Fixed variable - control using plusargs.
   //------------------------------------------------------------------------
   //    NONE

   //------------------------------------------------------------------------
   // Random variables
   //------------------------------------------------------------------------
   rand  device_e          m_device_family;
   rand  int   unsigned    m_bit_rate;       // <<example>>
/*///////////////////////////////////////////////////////////////////////////*/
/* TODO: Add variables for each of the IP parameters, with "rand" keyword.   */
/*///////////////////////////////////////////////////////////////////////////*/

   //------------------------------------------------------------------------
   // Register class with factory
   //------------------------------------------------------------------------
   `uvm_object_utils(gen_param_base)

   //------------------------------------------------------------------------
   // Constraints
   //------------------------------------------------------------------------
/*///////////////////////////////////////////////////////////////////////////*/
/* TODO: Add constraints for each of the variables for IP parameters.        */
/*///////////////////////////////////////////////////////////////////////////*/
// NOTE:
// Below is example.
///////////////////////////////////////////////////////////////////////////////
   constraint bit_rate_c {
      m_bit_rate inside {614, 1228, 2457, 3072, 4915, 6144, 9830, 10137};
   }

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new (string name = "gen_param_base");
      super.new(name);
   endfunction : new
endclass : gen_param_base

//============================================================================//

`ifndef __GEN_PARAM_OBJ__
   class gen_param_obj extends gen_param_base;
      //------------------------------------------------------------------------
      // Fixed variable - control using plusargs.
      //------------------------------------------------------------------------
      //    NONE

      //------------------------------------------------------------------------
      // Register class with factory
      //------------------------------------------------------------------------
      `uvm_object_utils(gen_param_obj)

      //------------------------------------------------------------------------
      // Further Constraints
      //------------------------------------------------------------------------
      //    NONE

      //
      // Constructor: new
      //
      // Creates instance of this UVM object.
      //
      // Parameter(s):
      //  name - Name of the instance.
      //
      function new (string name = "gen_param_obj");
         super.new(name);
      endfunction : new
   endclass : gen_param_obj
`else
typedef class gen_param_obj;
`endif

   //---------------------------------------------------------------------------
   // Test to generate Variant file
   //---------------------------------------------------------------------------
   class gen_param_test extends uvm_test;

      string         dev_family_str;
      device_e       dev_family_type;
      bit            dev_family_plusarg;
      gen_param_obj  m_const;
      string         param_name;
      int            fp;

      //------------------------------------------------------------------------
      // Register class with factory
      //------------------------------------------------------------------------
      `uvm_component_utils(gen_param_test)


      function new (string name, uvm_component parent);
         super.new(name, parent);

         //---------------------------------------------------------------------
         // Get from plusargs
         //---------------------------------------------------------------------
         if ($value$plusargs("DEVICE_FAMILY=%s", dev_family_str)) begin
            case (dev_family_str)
               "Arria10"  : dev_family_type = Arria10;
               "StratixV" : dev_family_type = StratixV;
               default    : dev_family_type = StratixV;
            endcase
            dev_family_plusarg = 1;
         end
      endfunction : new


      task run_phase(uvm_phase phase);
         //---------------------------------------------------------------------
         // Create constraint class
         //---------------------------------------------------------------------
         m_const = gen_param_obj::type_id::create("m_const");

         //---------------------------------------------------------------------
         // Randomize (and fix) the variables
         //---------------------------------------------------------------------
         if (!m_const.randomize() with {
               (dev_family_plusarg) -> (m_device_family == dev_family_type);
            })
            `uvm_fatal("gen_param", "randomization failed.")

         // Post-process before start generate the file
         // dealing with strings with "space" or "dot"
         case (m_const.m_device_family.name())
            "StratixV" : dev_family_str = "Stratix V";
            "Arria10"  : dev_family_str = "Arria 10";
            default    : dev_family_str = "Stratix V";
         endcase

         //---------------------------------------------------------------------
         // Generate random variant file
         //---------------------------------------------------------------------
         if (!$value$plusargs("XML_NAME=%s", param_name))
            param_name = $sformatf("mux_rand");

         // Open output file
         fp = $fopen({param_name, "\.xml"});

         // Printing header
         $fdisplay(fp, "<!-- This variant file is generated using seed value of %0d-->", $get_initial_random_seed());
         // Printing Variant definitions
         $fdisplay(fp, "<PARAMETERIZATIONS>");
         $fdisplay(fp, "   <!--For Debug-->");
         $fdisplay(fp, "   <PARAMETERIZATION name=\"%0s\" enabled=\"1\">", param_name);
         $fdisplay(fp, "      <!--MUX HW.TCL parameters-->");
/*/////////////////////////////////////////////////////////////////////////////////////////////*/
/* TODO: Add all the IP parameters here, where the value is given by the randomized variables. */
/*/////////////////////////////////////////////////////////////////////////////////////////////*/
// NOTE:
// Below are examples.
/////////////////////////////////////////////////////////////////////////////////////////////////
         $fdisplay(fp, "      <PARAMETER name=\"DEVICE_FAMILY\"       type=\"ip\" value=\"%0s\"/>", dev_family_str);
         $fdisplay(fp, "      <PARAMETER name=\"BIT_RATE\"            type=\"ip\" value=\"%0d\"/>", m_const.m_bit_rate);

         /////////////////////////////////////////////////////////////////////////
         // NOTE:
         // The below Testbench Parameters values need to be in-synced with
         // mux_tb_defaults.svh and also the variant files (*.xml).
         /////////////////////////////////////////////////////////////////////////
         $fdisplay(fp, "      <!--Testbench ONLY parameters-->");
         $fdisplay(fp, "      <PARAMETER name=\"CLK_OUT_NUM\"         type=\"tb\" value=\"4\"/>");
         $fdisplay(fp, "      <PARAMETER name=\"CLK_IN_NUM\"          type=\"tb\" value=\"0\"/>");
         $fdisplay(fp, "      <PARAMETER name=\"RST_OUT_NUM\"         type=\"tb\" value=\"4\"/>");
         $fdisplay(fp, "      <PARAMETER name=\"RST_IN_NUM\"          type=\"tb\" value=\"0\"/>");
         $fdisplay(fp, "   </PARAMETERIZATION>");
         $fdisplay(fp, "</PARAMETERIZATIONS>");

         // Close file
         $fclose(fp);
      endtask : run_phase
   endclass : gen_param_test

module mux_gen_param();
   initial run_test("gen_param_test");
endmodule : mux_gen_param
