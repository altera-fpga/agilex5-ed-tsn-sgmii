//==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//==============================================================================

//------------------------------------------------------------------------------
// Class: tsn 
//
// Common Enum Type and constant definition for TSN.
//
//------------------------------------------------------------------------------

   //---------------------------------------------------------------------------
   // Type definition
   //---------------------------------------------------------------------------
   /*/////////////////////////////////////*/
   /* TODO: Define the enum type here.    */
   /*/////////////////////////////////////*/
   typedef enum {StratixV, Arria10}                       device_e;

   //typedef enum {_10G,_25G,_40G,_50G,_100G,_200G,_400G}   speed_e;
   //---------------------------------------------------------------------------
   // Custom Macros, Defines
   //---------------------------------------------------------------------------
   //

   //---------------------------------------------------------------------------
   // common functions/tasks
   //---------------------------------------------------------------------------
   //
   // Function: pow
   //
   // Function to calculate the valid value range for data
   //
   // Parameters:
   // - val : Power of twos value
   //
   // Returns:
   // calculated 2^val-1
   //
   function bit[1023:0] pow (int val);
      if (val == 0)
         pow = 0;
      else
         pow = (2 ** val) - 1;
   endfunction : pow
   //
   // Function: create_global_event
   //
   // Create uvm_event and put it in the global event pool
   //
   // Parameter(s):
   //  event_name -  name of event.
   //
   // Return :
   //    uvm_event
   //
   function uvm_event create_global_event(string event_name);
      uvm_event_pool    event_pool;
      uvm_event         evt;
      event_pool = uvm_event_pool::get_global_pool();
      
      if (event_pool.exists(event_name)) begin
         `uvm_error("create_global_event", $sformatf("%0s is already existed",event_name))
      end
      else begin
         evt = new(event_name);
         `uvm_info("create_global_event", $sformatf("Create new event %0s",event_name), UVM_MEDIUM)
         event_pool.add(event_name,evt);
      end
      return evt;
   endfunction: create_global_event
   //
   // Function: get_global_event
   //
   // Get uvm_event from the global event pool
   //
   // Parameter(s):
   //  event_name -  name of event.
   //
   // Return :
   //    uvm_event
   //
   function uvm_event get_global_event(string event_name);
      uvm_event_pool    event_pool;
      uvm_event         evt;
      event_pool = uvm_event_pool::get_global_pool();
      
      if (!event_pool.exists(event_name)) begin
         `uvm_error("get_global_event", $sformatf("%0s not found",event_name))
      end
      else begin
         evt = event_pool.get(event_name);
      end
      return evt;
   endfunction: get_global_event
   //
   // Function: trigger_global_event
   //
   // trigger event in the global event pool
   //
   // Parameter(s):
   //  event_name -  name of event.
   //
   function void trigger_global_event(string event_name);
      uvm_event_pool    event_pool;
      uvm_event         evt;
      event_pool = uvm_event_pool::get_global_pool();
      
      if (!event_pool.exists(event_name)) begin
         `uvm_error("trigger_global_event", $sformatf("%0s not found",event_name))
      end
      else begin
         evt = event_pool.get(event_name);
         `uvm_info("trigger_global_event", $sformatf("Trigger global event %0s ",event_name), UVM_MEDIUM)
         evt.trigger();
      end
   endfunction: trigger_global_event
   //
   // Task: hdl_read_peek
   //
   // UVM backdoor read (peek) that directly use uvm_hdl_read.
   // It will perform immediately.
   //
   // Parameters:
   // - fld : Register Field
   // - hdl_path: The HDL path of the Register Field in string
   // - rd_data : Returned Read Data
   //
   task hdl_read_peek(uvm_reg_field fld, string hdl_path, output uvm_reg_data_t rd_data);
      bit                 mirror_update;
      uvm_reg_data_t      desired_value;

      //First get the desired value from this register field
      desired_value = fld.get();
      void'(uvm_hdl_read(hdl_path, rd_data));
      if (rd_data != desired_value) begin
         //Update the URM m_mirrorred_value after backdoor read using VPI. 
         mirror_update = fld.predict(rd_data,,UVM_PREDICT_READ, UVM_BACKDOOR);
         if (!mirror_update)
            `uvm_error("hdl_read_peek", $sformatf(
               "mirror update failed for field = %0s of register = %0s",
               fld.get_name(), fld.get_parent().get_name()))
         //After the predict(), both m_mirrored_value, m_desired_value are updated.
         //As we want to update the m_mirrored_value only, restore back the original
         //m_desired_value that captured earlier back to m_desired_value.
         fld.set(desired_value);
      end
   endtask : hdl_read_peek
