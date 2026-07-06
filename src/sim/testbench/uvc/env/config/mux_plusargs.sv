//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

`ifndef __MUX_PLUSARGS_
`define __MUX_PLUSARGS_
class mux_plusargs extends uvm_object;

  //------------------------
  // Factory registration
  //------------------------
  `uvm_object_utils_begin(mux_plusargs)
    `uvm_field_int(trans_count, UVM_PRINT)
  `uvm_object_utils_end


  //------------------------
  // Variables declaration
  //------------------------
  rand int     trans_count;


  //-------------------------
  // Constraints declaration
  //-------------------------
  constraint trans_count_c {
     trans_count inside {[1:100]};
  }


  //---------------------------------------------------
  // Function		: new()
  // Description	: Class constructor and it also 
  //                     calls set_plusargs() 
  //---------------------------------------------------
  function new (string name = "mux_plusargs");
     super.new(name);
     set_plusargs();
  endfunction : new



  //--------------------------------------------------
  // Function		: set_plusargs()
  // Description	: This function sets the value
  //                     for all the plusargs 
  //--------------------------------------------------
  function void set_plusargs();
    // Should be used to control number of ethernet frames sent from a sequence.
    if($value$plusargs("trans_count=%d", trans_count)) begin
      `uvm_info(get_name(), $psprintf("The value of trans_count=%0d", trans_count), UVM_LOW)
    end
    else begin
    end
  endfunction
endclass
`endif // __MUX_PLUSARGS_
