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
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/seq_item $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: jbharatk $
//==============================================================================

`ifndef VECTOR_UVC_PACKET__SV
`define VECTOR_UVC_PACKET__SV

//==============================================================================
// Class: vector_uvc_packet
// This is the transaction class for vector packet 
//==============================================================================

class vector_uvc_packet extends uvm_sequence_item;

//Variable : bit
//This field represents status_data 
  bit [39:0] status_data;
  
//Variable : bit
//This field represents status_error 
  bit [6:0] status_error;

//Variable : bit
//This field represents transaction id 
  bit [31:0] transaction_id=0;
 
  `uvm_object_utils_begin(vector_uvc_packet)
    `uvm_field_int(status_data,UVM_ALL_ON)
    `uvm_field_int(status_error,UVM_ALL_ON)
    `uvm_field_int(transaction_id,UVM_ALL_ON)
  `uvm_object_utils_end

//==============================================================================
// Class: new
// Constructor 
//==============================================================================
function new(string name = "vector_uvc_packet");
  super.new(name);
endfunction : new

//==============================================================================
// Class: do_compare
// Comparison Method 
//==============================================================================
/*virtual function bit do_compare( uvm_object rhs,uvm_comparer comparer);
  vector_uvc_packet to;
  bit passed;
  string s;
  passed = 1;
  
  if ( ! $cast( to, rhs ) ) return 0;
 
  if (this.status_data[15:0] != to.status_data[15:0])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch PAYLOAD_BYTE_COUNT, Expected: %x, Actual: %x\n",this.status_data[15:0], to.status_data[15:0])};
  end
  
  if (this.status_data[31:16] != to.status_data[31:16])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch FRAME_BYTE_COUNT, Expected: %x, Actual: %x\n",this.status_data[31:16], to.status_data[31:16])};
  end
  
  if (this.status_data[32] != to.status_data[32])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch SVLANE, Expected: %x, Actual: %x\n",this.status_data[32], to.status_data[32])};
  end
     
  if (this.status_data[33] != to.status_data[33])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch RVLANE, Expected: %x, Actual: %x\n",this.status_data[33], to.status_data[33])};
  end

  if (this.status_data[34] != to.status_data[34])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch CONTROL FRAME, Expected: %x, Actual: %x\n",this.status_data[34], to.status_data[34])};
  end

  if (this.status_data[35] != to.status_data[35])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch PUASE FRAME, Expected: %x, Actual: %x\n",this.status_data[35], to.status_data[35])};
  end

  if (this.status_data[36] != to.status_data[36])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch BRODCAST FRAME, Expected: %x, Actual: %x\n",this.status_data[36], to.status_data[36])};
  end
  
  if (this.status_data[37] != to.status_data[37])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch MULTICAST FRAME, Expected: %x, Actual: %x\n",this.status_data[37], to.status_data[37])};
  end
  
  if (this.status_data[38] != to.status_data[38])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch UNICAST FRAME, Expected: %x, Actual: %x\n",this.status_data[38], to.status_data[38])};
  end
  
  if (this.status_data[39] != to.status_data[39])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch FLOWCONTROL FRAME, Expected: %x, Actual: %x\n",this.status_data[39], to.status_data[39])};
  end
  
  if (this.status_error[1] != to.status_error[1])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch Oversized Frame, Expected: %x, Actual: %x\n",this.status_error[1], to.status_error[1])};
  end
  
  if (this.status_error[2] != to.status_error[2])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch Payload Length Error, Expected: %x, Actual: %x\n",this.status_error[2], to.status_error[2])};
  end
  
  if (this.status_error[0] != to.status_error[0])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch Phy Error, Expected: %x, Actual: %x\n",this.status_error[0], to.status_error[0])};
  end
  
  if (this.status_error[1] != to.status_error[1])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch CRC Error, Expected: %x, Actual: %x\n",this.status_error[1], to.status_error[1])};
  end
  
  if (this.status_error[2] != to.status_error[2])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch Undersize Error, Expected: %x, Actual: %x\n",this.status_error[2], to.status_error[2])};
  end
  
  if (this.status_error[3] != to.status_error[3])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch Oversize Error, Expected: %x, Actual: %x\n",this.status_error[3], to.status_error[3])};
  end
  
  if (this.status_error[4] != to.status_error[4])
  begin
    passed = 0;
    s = {s, $sformatf("\tMismatch Length Error, Expected: %x, Actual: %x\n",this.status_error[4], to.status_error[4])};
  end
  
  if (!passed)
  begin
    `uvm_error(get_type_name(), $sformatf("Mismatch found\n %0s",s));
  end
  
  return passed;
  endfunction
*/
endclass

`endif //VECTOR_UVC_PACKET__SV
