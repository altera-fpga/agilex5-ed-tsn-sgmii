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


//class eth_single_error_injection_sequence extends eth_base_sequence;
// uvm_reg 	regs;
// bit[31:0] tx_bit_mask;
// bit[32:0] symbol_error_mask;
// bit [5:0] symbol_position;
// int unique_bit;
// string case_no;
// bit [5:0] list_g[$];
// bit success;
// int no_of_symbol_corrpt_cnt;
//
//  `uvm_object_utils(eth_single_error_injection_sequence)
//
//  function new(string name = "eth_single_error_injection_sequence");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
// endfunction:new
//
//  virtual task body();
//
//   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
//  
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//   p_sequencer.env.reg_write(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG ,'hFFFF_FFFF);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//
//   no_of_symbol_corrpt_cnt = $urandom_range(1,7);
//
//   for(int m=0;m<no_of_symbol_corrpt_cnt;m++) begin
//         success = std::randomize (symbol_position) with {{symbol_position<33};unique{symbol_position,list_g};};
//         if(!success) `uvm_error(get_name(), $sformatf("%s randomisarion failed",case_no));
//	 list_g.push_back(symbol_position);
//         `uvm_info(get_name(), $sformatf(" %s corrupt symbol_position  = %0d", case_no,symbol_position), UVM_NONE);
//	 symbol_error_mask[symbol_position] =1 ;
//      end
//   list_g = {};
//
//   tx_bit_mask[17:8] = $urandom();
//   tx_bit_mask[3:0]  = $urandom();
//   tx_bit_mask[24]   = symbol_error_mask[32];
//
//   p_sequencer.env.reg_write(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG ,tx_bit_mask);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//   p_sequencer.env.reg_write(`REGISTERS_TX_Symbol_Error_Mask_OFFSET_REG ,symbol_error_mask);
//
//   fork 
//   begin
//      send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50); 
//   end
//   begin
//     repeat(100) begin
//       p_sequencer.env.reg_write(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG ,'hFFFF_FFFE);
//       p_sequencer.env.reg_read(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG,read_data);
//       p_sequencer.env.reg_read(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG,read_data);
//       p_sequencer.env.reg_read(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG,read_data);
//     end
//   end
//   join
//  
//  no_of_symbol_corrpt_cnt = $urandom_range(8,32);
//
//   for(int m=0;m<no_of_symbol_corrpt_cnt;m++) begin
//         success = std::randomize (symbol_position) with {{symbol_position<33};unique{symbol_position,list_g};};
//         if(!success) `uvm_error(get_name(), $sformatf("%s randomisarion failed",case_no));
//	 list_g.push_back(symbol_position);
//         `uvm_info(get_name(), $sformatf(" %s corrupt symbol_position  = %0d", case_no,symbol_position), UVM_NONE);
//	 symbol_error_mask[symbol_position] =1 ;
//      end
//   list_g = {};
//
//   tx_bit_mask[17:8] = $urandom();
//   tx_bit_mask[3:0]  = $urandom();
//   tx_bit_mask[24]   = symbol_error_mask[32];
//
//   p_sequencer.env.reg_write(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG ,tx_bit_mask);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//   p_sequencer.env.reg_write(`REGISTERS_TX_Symbol_Error_Mask_OFFSET_REG ,symbol_error_mask);
//
//   fork 
//   begin
//      send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50); 
//   end
//   begin
//     repeat(100) begin
//       p_sequencer.env.reg_write(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG ,'hFFFF_FFFE);
//       p_sequencer.env.reg_read(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG,read_data);
//       p_sequencer.env.reg_read(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG,read_data);
//       p_sequencer.env.reg_read(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG,read_data);
//     end
//   end
//   join
//
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(100),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data);
//
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(100),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data);
//  
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
//
// endtask
//endclass
//
//class eth_multi_error_injection_sequence extends eth_base_sequence;
// uvm_reg 	regs;
// bit[31:0] tx_bit_mask;
// bit[32:0] symbol_error_mask;
// bit [5:0] symbol_position;
// int unique_bit;
// string case_no;
// bit [5:0] list_g[$];
// bit success;
// int no_of_symbol_corrpt_cnt;
//
//  `uvm_object_utils(eth_multi_error_injection_sequence)
//
//  function new(string name = "eth_multi_error_injection_sequence");
//    super.new(name);
//	`ifdef UVM_POST_VERSION_1_1
//     set_automatic_phase_objection(1);
//    `endif
// endfunction:new
//
//  virtual task body();
//
//   p_sequencer.env.apply_reset(.rst_type("hard"),.ip_rst(1),.reset_period(11));
//  
//   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
//
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//   p_sequencer.env.reg_write(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG ,'hFFFF_FFFF);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//
//   no_of_symbol_corrpt_cnt = $urandom_range(1,7);
//
//   for(int m=0;m<no_of_symbol_corrpt_cnt;m++) begin
//         success = std::randomize (symbol_position) with {{symbol_position<33};unique{symbol_position,list_g};};
//         if(!success) `uvm_error(get_name(), $sformatf("%s randomisarion failed",case_no));
//	 list_g.push_back(symbol_position);
//         `uvm_info(get_name(), $sformatf(" %s corrupt symbol_position  = %0d", case_no,symbol_position), UVM_NONE);
//	 symbol_error_mask[symbol_position] =1 ;
//      end
//   list_g = {};
//
//   tx_bit_mask[17:8] = $urandom();
//   tx_bit_mask[3:0]  = $urandom();
//   tx_bit_mask[24]   = symbol_error_mask[32];
//
//   p_sequencer.env.reg_write(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG ,tx_bit_mask);
//   p_sequencer.env.reg_read(`REGISTERS_TX_Bit_Error_Mask_OFFSET_REG,read_data);
//   p_sequencer.env.reg_write(`REGISTERS_TX_Symbol_Error_Mask_OFFSET_REG ,symbol_error_mask);
//
//   fork 
//   begin
//      send_eth_frame(RANDOM_FRAME,AVL_TX_ETH_VIP,50); 
//   end
//   begin
//       p_sequencer.env.reg_write(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG ,'hFFFF_FFEF);
//       #100ns
//       p_sequencer.env.reg_write(`REGISTERS_TX_Error_Insertion_Enable_OFFSET_REG ,'h0000_0000);
//   end
//   join
//
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(100),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data);
//
// FIXME-MISSING_REG_IN_GDR//   regs = p_sequencer.env.reg_model.default_map.get_reg_by_offset(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG);
//   regs.predict(.value(0),.kind(UVM_PREDICT_DIRECT), .map( p_sequencer.env.reg_model.default_map));
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Corrected_CW_Counter_OFFSET_REG,read_data); 
// FIXME-MISSING_REG_IN_GDR//   p_sequencer.env.reg_read(`REGISTERS_RX_Uncorrected_CW_Counter_OFFSET_REG,read_data); 
//
// endtask
//endclass
