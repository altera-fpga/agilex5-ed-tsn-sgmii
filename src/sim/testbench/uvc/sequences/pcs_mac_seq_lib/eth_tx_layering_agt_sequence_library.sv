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


//
// Template for UVM-compliant sequence library
//


`ifndef ETH_TX_LAYERING_SQR_SEQUENCE_LIBRARY__SV
`define ETH_TX_LAYERING_SQR_SEQUENCE_LIBRARY__SV


typedef class eth_packet;

class eth_tx_layering_sqr_sequence_library extends uvm_sequence_library # (eth_packet);
  
  `uvm_object_utils(eth_tx_layering_sqr_sequence_library)
  `uvm_sequence_library_utils(eth_tx_layering_sqr_sequence_library)

  function new(string name = "simple_seq_lib");
    super.new(name);
    init_sequence_library();
  endfunction

endclass  

class base_sequence extends uvm_sequence #(eth_packet);
  `uvm_object_utils(base_sequence)
  function new(string name = "base_seq");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  `ifdef UVM_VERSION_1_0
  virtual task pre_body();
    if (starting_phase != null)
      starting_phase.raise_objection(this);
 
  endtask:pre_body

 
  virtual task post_body();
    if (starting_phase != null)
      starting_phase.drop_objection(this);
  endtask:post_body
  `endif
  
  `ifdef UVM_VERSION_1_1
  virtual task pre_start();
    if((get_parent_sequence() == null) && (starting_phase != null))
      starting_phase.raise_objection(this, "Starting");
  endtask:pre_start

  virtual task post_start();
    if ((get_parent_sequence() == null) && (starting_phase != null))
      starting_phase.drop_objection(this, "Ending");
  endtask:post_start
  `endif
endclass
//=============================================================================================================
class fc_pause_sequence extends base_sequence;
   bit[15:0] pause_quanta[9];
   bit[8:0] fc_mode;
   bit pause_pfc;
   bit same_holdoff;
   bit [15:0] same_holdoff_quanta;
 
  `uvm_object_utils(fc_pause_sequence)
 function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    `uvm_create(req)
     assert(req.randomize)
     req.fc_mode=fc_mode;
     req.pause=pause_pfc;
     foreach(pause_quanta[i]) begin
       if(req.width_type==LESS)  req.xoff_width[i]=pause_quanta[i]/2;
       if(req.width_type==EQUAL) req.xoff_width[i]=pause_quanta[i];
       if(req.width_type==MORE)  req.xoff_width[i]=pause_quanta[i]*2;
     end
        `uvm_send(req) //signal
    endtask
endclass

class fc_err_sequence extends base_sequence;
  `uvm_object_utils(fc_err_sequence)
  `uvm_add_to_seq_lib(fc_err_sequence,eth_tx_layering_sqr_sequence_library)
   bit[7:0] q_no=$urandom;
  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
  `uvm_do_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type==UNDERSIZE;})
 #100 `uvm_do_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type==UNDERSIZE;sfc_pause_quanta==0;})
  `uvm_do_with(req,{frame_type == ETH_PFC_FRAME; pfc_class_en_vect[1]==q_no;frame_payload_type==UNDERSIZE;})
 #100 `uvm_do_with(req,{frame_type == ETH_SFC_FRAME; frame_payload_type==UNDERSIZE;pfc_class_en_vect[1]==q_no;pfc_pause_quanta[q_no]==0;})
  endtask
endclass

//=====================================================================================================================
class padding_sequence extends base_sequence;
  int seq_cnt=300;
  int FOR_coverage =0;      
  `uvm_object_utils(padding_sequence)
  `uvm_add_to_seq_lib(padding_sequence,eth_tx_layering_sqr_sequence_library)

  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   $display("padding_seqeunce : seq_cnt=%0d",seq_cnt);
   repeat(seq_cnt) begin 
      `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; payload.size dist{0:=40,[1:45]:=40,[46:1500]:=20};})
   end

   if(FOR_coverage == 1) begin
     //frame_length_mac_tx_pad_svlan_cp
     for(int i = 0; i<40; i++)  begin
      `uvm_do_with(req,{frame_type == ETH_STACKED_VLAN_FRAME;eth_type_or_length ==i;})
     end

     //frame_length_mac_tx_pad_vlan_cp
     for(int i = 0; i<43; i++)  begin
      `uvm_do_with(req,{frame_type == ETH_VLAN_FRAME;eth_type_or_length ==i;})
     end
    FOR_coverage = 0; 
   end
   endtask
endclass

class padding_sequence_cfg extends base_sequence;
  `uvm_object_utils(padding_sequence_cfg)
  `uvm_add_to_seq_lib(padding_sequence_cfg,eth_tx_layering_sqr_sequence_library)

  function new(string name = "seq_0");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   repeat(300)  `uvm_do_with(req,{frame_type == ETH_DATA_FRAME; frame_payload_type==NORMAL;})
  endtask
endclass

class preamble_sequence extends base_sequence;
  int itr_cnt=300;
 `uvm_object_utils(preamble_sequence)
  `uvm_add_to_seq_lib(preamble_sequence, eth_tx_layering_sqr_sequence_library)

  function new(string name = "preamble_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   $display("running preamble sequence: itr_cnt =%0d",itr_cnt);
 repeat(itr_cnt) begin
   `uvm_create(req);
   req.preamble_c.constraint_mode(0);
    `uvm_rand_send_with(req,{frame_type==ETH_DATA_FRAME;preamble[63:56]==8'hfb; });
 end
  endtask
endclass

class preamble_sequence_cfg extends base_sequence;
  `uvm_object_utils(preamble_sequence_cfg)
  `uvm_add_to_seq_lib(preamble_sequence_cfg, eth_tx_layering_sqr_sequence_library)

  function new(string name = "preamble_sequence_cfg");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
   $display("running preamble sequence");
 repeat(300) begin
   `uvm_create(req);
   req.preamble_c.constraint_mode(0);
   `uvm_rand_send_with(req,{frame_type==ETH_DATA_FRAME;preamble[63:56]==8'hfb;frame_payload_type==NORMAL; });
   end
  endtask
endclass


`endif // ETH_TX_LAYERING_SQR_SEQUENCE_LIBRARY__SV
