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
// $File: //depot/altuvm/rel/0.8/product/altuvm_avalon_mm/src/uvc/altuvm_avalon_mm_reg_adapter_eth.svh $
// $Revision: #1 $
// $Date: 2015/09/08 $
// $Author: abmpkhan $
//==============================================================================

`ifndef __ALTUVM_AVALON_MM_REG_ADAPTER_SVH_ETH__
`define __ALTUVM_AVALON_MM_REG_ADAPTER_SVH_ETH__

//------------------------------------------------------------------------------
// Class:  altuvm_avalon_mm_reg_adapter_eth
//
// This class is used in conjuction with the UVM register model and the
// <altuvm_avalon_mm_agent> verfication component.
// To use this adapter, the following steps must be taken:
//
//------------------------------------------------------------------------------
class altuvm_avalon_mm_reg_adapter_eth extends altuvm_reg_adapter;
   `uvm_object_utils(altuvm_avalon_mm_reg_adapter_eth)
   //
   //  Function: new
   //
   //  Standard constructor arguments for <uvm_reg_adapter>:
   //  ~name~ is the name of the instance.
   //
   function new(string name = "altuvm_avalon_mm_reg_adapter_eth");
      super.new(name);
      provides_responses = 1;
   endfunction : new
   //
   //  Function: reg2bus
   //
   //  Convert a UVM abstract register transaction to an operation on the
   //  Avalon-MM bus.
   //
   function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
      altuvm_avalon_mm_req bus_req;
      uvm_reg_item item;
      int n_bytes;

      `uvm_info(get_type_name(), "Calling reg2bus", UVM_DEBUG)

      bus_req = altuvm_avalon_mm_req::type_id::create("REGISTER_REQUEST");
      bus_req.transaction = (rw.kind == UVM_READ) ? AVALON_MM_READ: AVALON_MM_WRITE;
      bus_req.expect_response = 1;
      bus_req.is_uvm_reg  = 1;
      bus_req.burst_count = 1;
      //
      // We need to have a provison to compare compatible bus widths or to make them compatible.
      //
      item = get_item();
      `ifdef ANLT
      bus_req.address = rw.addr; //ANLT AVMM address scheme is unchanged
      `else
      bus_req.address = rw.addr; // Shifting removed ,ref. HSD 16011528539
      `endif

      n_bytes = (rw.n_bits) / 8;
      bus_req.data_bytes  = new[n_bytes];
      bus_req.byte_enable = new[n_bytes];
      bus_req.len         = n_bytes;
      bus_req.waitreq     = new[1];
      bus_req.waitreq[0]  = 0;
      //
      //
      // provision to compare data bus width
      //
      if(this.get_name() inside {"xcvr_reg_adpt_0","xcvr_reg_adpt_1","xcvr_reg_adpt_2","xcvr_reg_adpt_3","rsfec_reg_adpt"}) begin
        `ifdef CRETE3
        if (item.map.get_n_bytes() != `UVM_REG_DATA_WIDTH/32)
	`else
        if (item.map.get_n_bytes() != `UVM_REG_DATA_WIDTH/8)
	`endif
        begin
           `uvm_fatal(get_type_name(), "Data bus size mismatch");
        end
      end
      else begin
        if (item.map.get_n_bytes() != `UVM_REG_DATA_WIDTH/8)
        begin
           `uvm_fatal(get_type_name(), "Data bus size mismatch");
        end
      end

      foreach (bus_req.data_bytes[i])
      begin
         bus_req.data_bytes[i] = rw.data[i*8 +: 8];
      end

      foreach (bus_req.byte_enable[i])
      begin
         bus_req.byte_enable[i] = rw.byte_en[i];
      end
      //
      //Debug/trace Information from uvm_reg_item
      //
      bus_req.lineno      = item.lineno;
      bus_req.filename    = item.fname;

      `uvm_info(get_type_name(), "Done calling reg2bus", UVM_DEBUG)

      //
      // Provision to do 1 byte transaction.
      //
      return bus_req;
   endfunction : reg2bus
   //
   //  Function: bus2reg
   //
   //  Convert an operation on the Avalon-MM bus to a UVM abstract register
   //  transaction.
   //
   function void bus2reg(uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      altuvm_avalon_mm_req_base reg_resp;
      `uvm_info(get_type_name(), "Calling bus2reg", UVM_DEBUG)
      if (!$cast(reg_resp, bus_item))
      begin
         `uvm_fatal("NOT_AVA_MM_TYPE", $sformatf(
            "Provided bus_item=%0s is not of the correct type=altuvm_avalon_mm_req_base",
            bus_item.get_type_name()))
         return;
      end
      rw.kind = (reg_resp.transaction == AVALON_MM_WRITE) ? UVM_WRITE: UVM_READ;
      rw.addr = reg_resp.address >> 2;
      foreach (reg_resp.data_bytes[i])
      begin
         rw.data[i*8+:8] = reg_resp.data_bytes[i];
         rw.byte_en[i]   = reg_resp.byte_enable[i];
      end
      rw.status = UVM_IS_OK;
      rw.n_bits = (reg_resp.burst_count*4*8);
      `uvm_info(get_type_name(), "Done calling bus2reg", UVM_DEBUG)
      return;
   endfunction : bus2reg

endclass : altuvm_avalon_mm_reg_adapter_eth

`endif//__ALTUVM_AVALON_MM_REG_ADAPTER_SVH_ETH__
