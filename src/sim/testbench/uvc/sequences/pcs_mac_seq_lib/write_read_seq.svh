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




import uvm_pkg::*;
`include "uvm_macros.svh"
import altuvm_pkg::*;
`include "altuvm_macros.svh"
import altuvm_avalon_mm_pkg::*;

class write_read_seq extends uvm_sequence;
   `uvm_object_utils(write_read_seq)
  // protected string seq_desc = "Single write followed by read transaction sequence.";
 // `uvm_declare_p_sequencer(altuvm_avalon_mm_sequencer)
  
   altuvm_avalon_mm_write_seq          write_seq;
   altuvm_avalon_mm_read_seq           read_seq;
   
   function new(string name = "write_read_seq");
      super.new(name);
   endfunction : new
   
   virtual task body();
   //   repeat (10)
    //  begin
         write_seq = altuvm_avalon_mm_write_seq::type_id::create("write");
         read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");

         `uvm_do_with(write_seq,{init_latency inside {[0:3]};
                                 foreach (byteenable[i]) byteenable[i] == 1;
         })

         `uvm_do_with(read_seq,{init_latency inside {[0:3]};
                                address   == write_seq.address;
                                num_bytes == write_seq.num_bytes;
                                foreach (byteenable[i]) byteenable[i] == write_seq.byteenable[i];
         })

         foreach (write_seq.writedata[i])
         begin
            byte unsigned writedata, readdata;
            writedata = write_seq.writedata[i] & {8{write_seq.byteenable[i]}};
            readdata  = read_seq.readdata[i]   & {8{write_seq.byteenable[i]}};
            if (readdata == writedata)  `uvm_info(get_type_name(),$sformatf("Read Check OK:\tACT=0x%0x\tEXP=0x%0x",readdata, writedata), UVM_MEDIUM)
            else  `uvm_error(get_type_name(),$sformatf("Read Check Failed:\tACT=0x%0x\tEXP=0x%0x",readdata, writedata))
         end
   //   end
      `uvm_info(get_type_name(), "DONE", UVM_NONE)
   endtask : body
endclass : write_read_seq

