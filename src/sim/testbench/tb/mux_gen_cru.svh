//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_GEN_CRU_SVH__
`define __MUX_GEN_CRU_SVH__

//------------------------------------------------------------------------------
// Class: mux_gen_cru
//
// Random Variant's contraint for CRU generation for MUX.
//
//------------------------------------------------------------------------------
class mux_gen_cru extends uvm_object;

   //---------------------------------------------------------------------------
   // Random variables
   //---------------------------------------------------------------------------
   rand  longint  unsigned  m_freqtimex1000      [string];
   rand  longint  unsigned  m_skew               [string];
   rand  longint  unsigned  m_init_time          [string];
   rand  longint  unsigned  m_time_bfore_assert  [string];
   rand  longint  unsigned  m_time_bfore_deassert[string];

   //---------------------------------------------------------------------------
   // Fixed variable
   //---------------------------------------------------------------------------
         real        m_freqtime[string];
         string      m_unit    [string];

   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_object_utils(mux_gen_cru)


   //---------------------------------------------------------------------------
   // Constraints
   //---------------------------------------------------------------------------
   /////////////////////////////////////////////////////////////////////////
   // NOTE:
   // All the frequencies or period (floating points with 3 decimal points)
   // are multiplied with 1000 to make as integers.
   // When post_randomize, only divided by 1000 to get the floating point
   // value.
   /////////////////////////////////////////////////////////////////////////

/*///////////////////////////////////////////////////////////////////////////*/
/* TODO: Add constraints for each of the clocks and resets here.             */
/*///////////////////////////////////////////////////////////////////////////*/
// NOTE:
// Below are examples.
///////////////////////////////////////////////////////////////////////////////
   constraint m_freqtime_cpu_clk_c {
      m_freqtimex1000["cpu_clk"] inside {[100000:400000]};
   }
   constraint m_freqtime_reconfig_clk_c {
      m_freqtimex1000["reconfig_clk"] == 3927232;
   }

   constraint m_skew_cpu_clk_c {
      m_skew["cpu_clk"] inside {[0:25000]};
   }
   constraint m_skew_reconfig_clk_c {
      m_skew["reconfig_clk"] inside {[0:25000]};
   }

   constraint m_init_time_cpu_reset_c {
    m_init_time["cpu_reset"] inside {[50000:100000]};
  }
   constraint m_init_time_reconfig_reset_c {
    m_init_time["reconfig_reset"] inside {[50000:100000]};
  }

   constraint m_time_bfore_assert_cpu_reset_c {
      m_time_bfore_assert["cpu_reset"] inside {[0:10000]};
   }
   constraint m_time_bfore_assert_reconfig_reset_c {
      m_time_bfore_assert["reconfig_reset"] inside {[0:10000]};
   }

   constraint m_time_bfore_deassert_cpu_reset_c {
      m_time_bfore_deassert["cpu_reset"] inside {[0:10000]};
   }
   constraint m_time_bfore_deassert_reconfig_reset_c {
      m_time_bfore_deassert["reconfig_reset"] inside {[0:10000]};
   }

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   // Initialize all assoc. arrays to 0.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new(string name = "mux_gen_cru");
      super.new(name);
/*///////////////////////////////////////////////////////////////////////////*/
/* TODO: Set the associative arrays for each of the clocks and resets to 0   */
/*       to avoid having warning messages.                                   */
/*///////////////////////////////////////////////////////////////////////////*/
// NOTE:
// Below are examples.
///////////////////////////////////////////////////////////////////////////////
      m_freqtimex1000["cpu_clk"]              = 0;
      m_freqtimex1000["reconfig_clk"]         = 0;
      m_skew["cpu_clk"]                       = 0;
      m_skew["reconfig_clk"]                  = 0;
      m_init_time["cpu_reset"]                = 0;
      m_init_time["reconfig_reset"]           = 0;
      m_time_bfore_assert["cpu_reset"]        = 0;
      m_time_bfore_assert["reconfig_reset"]   = 0;
      m_time_bfore_deassert["cpu_reset"]      = 0;
      m_time_bfore_deassert["reconfig_reset"] = 0;
   endfunction : new
   //
   // Function: post_randomize
   //
   // To post process the randomized variables.
   //
   function void post_randomize();
   ////////////////////////////////////////////////////////////////////////
   // NOTE:
   // It is possible to have m_unit = "fs"/"ps"/"ns"/"us".
   ////////////////////////////////////////////////////////////////////////
   // NOTE:
   // The m_freqtimex100 is either period value x 1000 or
   // frequency value x 1000.
   // In order to get back the actual value:
   //    m_freqtime[clock_name] = m_freqtimex1000[clock_name] / 1000
   ////////////////////////////////////////////////////////////////////////
   // NOTE:
   // Below are examples.
   ////////////////////////////////////////////////////////////////////////
      foreach (m_freqtimex1000[clock_name]) begin
         if (clock_name == "cpu_clk") m_unit[clock_name] = "MHz";
         else                         m_unit[clock_name] = "ps";
         m_freqtime[clock_name] = real'(m_freqtimex1000[clock_name]) / 1000;
      end
   endfunction : post_randomize

endclass : mux_gen_cru

`endif
