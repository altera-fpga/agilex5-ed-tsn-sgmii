string       _msg_id = $sformatf("%m");

class mux_comm_concrete extends mux_comm_abstract;

   //
   // Constructor: new
   //
   // Creates instance of this UVM object.
   //
   // Parameter(s):
   //  name - Name of the instance.
   //
   function new(string name = "mux_comm_concrete");
      super.new(name);
      m_class_type = name;
   endfunction : new

   //
   // Function: set_config
   //
   // This task is used to provide the tasks and functions in this interface
   // with a handle to the BFM configuration that has been provided to the
   // <mux_env>.
   //
   // Parameter(s):
   //  _config - A handle to the configuration object.
   //
   virtual function void set_config(mux_env_config _config);
      if (!$cast(m_config, _config))
         `uvm_error("CAST-FAILURE", $sformatf(
            "%0s : Failed to get pointer to the config", m_hier))
   endfunction : set_config

   //
   // Macros: mux_monitor_signal
   // Handy macro that will be used to monitor signals
   //
   `define mux_monitor_signal(NAME, VAL, IS_OUT, OUT_VAL)\
      `"NAME`" : begin\
         string msg, msg_new;\
         int i, j;\
         if(IS_OUT == 1)  begin \
           ``OUT_VAL = ``NAME``;\
         end\
         else begin\
           msg = {`"NAME`", $sformatf("='h%0H", ``VAL``)};\
           `uvm_info(_msg_id, {"Wait for ", msg}, UVM_HIGH)\
           wait (``NAME`` == ``VAL``);\
           `uvm_info(_msg_id, {"Detected ", msg}, UVM_HIGH)\
         end\
      end

   `define mux_monitor_transition(NAME, B_VAL, A_VAL)\
      `"NAME`" : begin\
         string msg;\
         msg = {`"NAME`", $sformatf("='h%0H", ``B_VAL``)};\
         `uvm_info(_msg_id, {"Wait for ", msg}, UVM_HIGH)\
         wait (``NAME`` == ``B_VAL``);\
         `uvm_info(_msg_id, {"Detected ", msg}, UVM_HIGH)\
         msg = {`"NAME`", $sformatf("='h%0H", ``A_VAL``)};\
         `uvm_info(_msg_id, {"Wait for ", msg}, UVM_HIGH)\
         wait (``NAME`` == ``A_VAL``);\
         `uvm_info(_msg_id, {"Detected ", msg}, UVM_HIGH)\
      end


   // Wait for cvp clock
   `define mux_wait_clock(NAME,VAL)\
      `"NAME`" : begin\
         repeat(value) @(posedge ``NAME``);\
      end

   //
   // Macros: mux_drive_signal
   // Handy macro that will be used to control reset signals
   //
   `define mux_drive_signal(NAME, VAL, CLOCK="")\
      `"NAME`" : begin\
         /**/\
         /* Wait for synchronized clock edge */\
         /**/\
         if (CLOCK != "")\
         begin\
            cru_rtb.g_mon.m_bfm.wait_for_signal(CLOCK);\
         end\
         /**/\
         /* Drive reset signal to the value specified (Active mode) */\
         /**/\
         if (IS_ACTIVE == uvm_pkg::UVM_ACTIVE)\
         begin\
            ``NAME`` = ``VAL``;\
            `uvm_info(_msg_id, {\
               "Drove i_", `"NAME`", $sformatf("='h%0H", ``VAL``)\
            }, UVM_HIGH)\
         end\
         /**/\
         /* Monitor reset signal drive to the specified value (passive mode) */\
         /**/\
         else\
         begin\
            string msg;\
            msg = {"i_", `"NAME`", $sformatf("='h%0H", ``VAL``)};\
            `uvm_info(_msg_id, {"Wait for ", msg}, UVM_HIGH)\
            wait (``NAME`` == ``VAL``);\
            `uvm_info(_msg_id, {"Detected ", msg}, UVM_HIGH)\
         end\
      end


      task drive(string name, bit[127:0] value);
        case(name)
          default: begin
            `uvm_fatal(_msg_id, {"Signal ", name, " is not registered under drive_signal control"})
          end
        endcase
      endtask

      //
      task monitor(string name, bit [127:0] value, bit is_out = 0, output int test_out);
        case(name)
          default: begin
            `uvm_fatal(_msg_id, {"Signal ", name, " is not registered under monitor_signal control"})
          end
        endcase
      endtask

      // Wait for Clock
      task wait_clk(string name,int value = 1);
      endtask
   
      task monitor_transition(string name , bit [127:0]  b_value , bit[127:0] a_value);
        case(name)
          default: begin
            `uvm_fatal(_msg_id, {"Signal ", name, " is not registered under monitor_transition control"})
          end
        endcase
      endtask
endclass : mux_comm_concrete

// Create and get the communication interface concrete class
function mux_comm_concrete get_comm();
   // Concrete class handle
   static   mux_comm_concrete  m_comm;
   // Create the concrete class
   if (m_comm == null)
      m_comm = new("m_comm");
   return m_comm;
endfunction : get_comm

function bit init_comm();
   // Set the concrete class for Comm into UVM configuration table
   `altuvm_set_concrete(mux_comm_concrete, get_comm())
   return 1;
endfunction : init_comm

// Bit which indicate the concrete class initialization has succeeded
bit comm_initialized = init_comm();
