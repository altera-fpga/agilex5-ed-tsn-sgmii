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


class alt_eth_error_vip_base_sequence extends svt_ethernet_transaction_base_sequence; 

   int unsigned sequence_length = 1;
   svt_ethernet_transaction_exception_list exception_list;
   bit [15:0] byte_count;
   
   /** UVM object utility macro */
   `uvm_object_utils(alt_eth_error_vip_base_sequence)
     
     /** Class constructor */
     function new (string name = "alt_eth_error_vip_base_sequence",int sequence_length=1);
      	super.new(name);
	this.sequence_length = sequence_length;
     endfunction : new

   /** Raise an objection if this is the parent sequence */
   virtual task pre_body();
      uvm_phase phase;
      super.pre_body();
`ifdef SVT_UVM_12_OR_HIGHER
      phase = get_starting_phase();
`else
       phase = starting_phase;
`endif
      if (phase!=null) begin
	 phase.raise_objection(this);
      end
   endtask: pre_body
   
   /** Drop an objection if this is the parent sequence */
   virtual task post_body();
      uvm_phase phase;
      super.post_body();
`ifdef SVT_UVM_12_OR_HIGHER
      phase = get_starting_phase();
`else
      phase = starting_phase;
`endif
      if (phase!=null) begin
	 phase.drop_objection(this);
      end
   endtask: post_body
 
   virtual task body();
      bit status;
      
      `svt_xvm_note("body", "Entered ...");
      super.body();
      
      `svt_xvm_create (req) 
	
	repeat(sequence_length) begin
	   `svt_xvm_rand_send_with(req, {
					 req.byte_count          == byte_count; 
					 req.mac_inter_frame_gap == 12;
					 req.command_type        == svt_ethernet_enum_pkg::ETH_MAC_DATA_FRAME;
					 req.exception_list == exception_list;
					 })
	     end
      `svt_xvm_note("body" ," Exited ...");
    
   endtask: body

   // This task takes in an exception list and number of frames to send. It will send vip frames with one or more exceptions from the list as well as good frames in between. Frame size is provided as arguement
   virtual task send_error_frame(svt_ethernet_transaction_exception_list exception_list, int no_of_frames=10, bit one_exception = 1'b0, int ifg = 12, bit [15:0] frame_size_min = 8, bit [15:0] frame_size_max = 10000, bit en_short_packet=0, bit en_runt_packet=0);
      svt_ethernet_transaction_exception_list local_exception_list;   
      svt_ethernet_transaction_exception local_exception;
      bit [7:0] num_exceptions;
      int 	exception_idx;
      uvm_printer printer;
      bit [15:0] frame_size;
  bit [7:0]  pre_sfd[8];
      bit [15:0] len_type;

      
      // From the passed exception list, send one or more exceptions to the sequence. Each sequence may have zero, one or more exceptions from the list
      for (int j=0; j<no_of_frames;j++) begin
	 `svt_xvm_create (req) 
	   num_exceptions = exception_list.exceptions.size();
	 `uvm_info("Exception added", $sformatf("Number of exceptions = %0d",num_exceptions), UVM_LOW)
	   local_exception = new();
	 local_exception_list = new("exception_list", exception);
	 for (int i=0;i<num_exceptions;i++) begin
	    if (one_exception) begin
	       // It is half as expected to not to insert exception 
	       exception_idx = $urandom_range(0,num_exceptions*2);
	       if (exception_idx<num_exceptions) begin
		  local_exception = exception_list.get_exception(exception_idx);
		  local_exception_list.add_exception(local_exception);
		  `uvm_info("Exception added", $sformatf("Added exception"), UVM_MEDIUM)
          $display("send_error_frame: pkt = %0d exception added",j);
		    local_exception.print(printer);
		  break;
	       end else begin
		  `uvm_info("Exception added", $sformatf("No exception added"), UVM_MEDIUM)
          $display("send_error_frame: pkt = %0d No exception added",j);
		    break;
	       end
	    end else begin
	       // if just more than one exception in the list, add one or more to the sequence 
	       randcase
		 60: begin
		    local_exception = exception_list.get_exception(i);
		    local_exception_list.add_exception(local_exception);
		    `uvm_info("Exception added", $sformatf("Added exception %s", local_exception.frame_error_kind.name()), UVM_DEBUG)
		      end
		 40: begin
		    /* Do not add an exception */
		    `uvm_info("Exception added", $sformatf("No exception"), UVM_DEBUG)
		      end
	       endcase
	    end
	 end // for (int i=0;i<num_exceptions;i++)
	 pre_sfd = {8'h55,8'h55,8'h55,8'h55,8'h55,8'h55,8'h55,8'hd5};
	 if (local_exception_list != null) begin
	    if (local_exception_list.exceptions.size()>0) begin
	       local_exception = local_exception_list.get_exception(0);
	       if (local_exception.error_kind==svt_ethernet_transaction_exception::FRAME_ERROR_KIND && local_exception.frame_error_kind == svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS) begin		 
		 pre_sfd = {local_exception.frame_send_invalid_preamble_bits_error[55:48],
			    local_exception.frame_send_invalid_preamble_bits_error[47:40],
			    local_exception.frame_send_invalid_preamble_bits_error[39:32],
			    local_exception.frame_send_invalid_preamble_bits_error[31:24],
			    local_exception.frame_send_invalid_preamble_bits_error[23:16],
			    local_exception.frame_send_invalid_preamble_bits_error[15:8],
			    local_exception.frame_send_invalid_preamble_bits_error[7:0],
			    8'hd5};
	       end	       
	       if (local_exception.error_kind==svt_ethernet_transaction_exception::FRAME_ERROR_KIND && local_exception.frame_error_kind == svt_ethernet_transaction_exception::FRAME_INVALID_SFD) begin		 
		 pre_sfd = {8'h55,8'h55,8'h55,8'h55,8'h55,8'h55,8'h55,local_exception.frame_invalid_sfd_error};
	       end
	    end
	 end
	 if (en_runt_packet) begin
	    if (!std::randomize(frame_size) with {frame_size dist {
		                          //HSD : https://hsdes.intel.com/appstore/article/#/16014807823  
								  //[2:14] :/ 30,
								  //[15:63] :/ 40,
								  [26:63] :/ 70,
								  [64:128] :/ 30
								  }; 
								  //Shabbir: 50G HIP issue open for packet size=12(here, frame_size=8 generates 12 bytes packet). FB 584180
								  //`ifdef G50  dsamantx:FIXME for GDR 50G if issue persists
								  //  frame_size != 8;
								  //`endif
								  })
	      `uvm_error("std::randomize", $sformatf("Randomize ipg_col_rem fail"))
	 ;	
	 end else begin 
	   if (en_short_packet) begin
	      if (!std::randomize(frame_size) with {frame_size dist {
	      						  [frame_size_min:63] :/ 40,
	      						  [64:1522] :/ 40,
	      						  [1523:frame_size_max] :/ 5
	      						  }; 
	      						  //Shabbir: 50G HIP issue open for packet size=12(here, frame_size=8 generates 12 bytes packet). FB 584180
	      						  //`ifdef G50  dsamantx:FIXME for GDR 50G if issue persists
	      						  //  frame_size != 8;
	      						  //`endif
	      						  })
	        `uvm_error("std::randomize", $sformatf("Randomize ipg_col_rem fail"))
	   ;	
	   end else begin
	      if (!std::randomize(frame_size) with {frame_size dist {
	      						  [frame_size_min:63] :/ 0,
	      						  [64:1522] :/ 40,
	      						  [1523:frame_size_max] :/ 5
	      						  };})
	        `uvm_error("std::randomize", $sformatf("Randomize ipg_col_rem fail"))
	      ;	
	   end
     end
	     
	 if (frame_size<1522) begin
	    req.user_packet_type = svt_ethernet_enum_pkg::DATA_FRAME;
	    if(frame_size>22)
	      len_type = frame_size-22; // pre+sfd+sa+da+lentype = 22	
	    else
	      len_type = 0;
	 end else begin
	    req.user_packet_type = svt_ethernet_enum_pkg::JUMBO_DATA_FRAME;
	    std::randomize(len_type) with {len_type inside {
							    16'h5555,
							    16'haaaa,
							    16'h8870
							    };};
	 end
	 req.exception_list = local_exception_list;
	 req.disable_mac_pad = 1'b1;
	 req.reasonable_mac_inter_frame_gap.constraint_mode(0);
	 req.reasonable_mac_pad_bits.constraint_mode(0);
	 req.reasonable_byte_count.constraint_mode(0);

	 req.user_no_of_bytes = frame_size;
	 req.user_pkt_data = new[frame_size];
         req.reasonable_command_type.constraint_mode(0);
	 foreach(req.user_pkt_data[k]) begin // Initialize preamble/sfd
	    if (k<8)
	      req.user_pkt_data[k] = pre_sfd[k];
	    else if (k<20) // sa+da
	      req.user_pkt_data[k] = $urandom();
	    else if (k<22) begin
	       if (k==20)
		 req.user_pkt_data[k] = len_type[15:8];
	       else
		 req.user_pkt_data[k] = len_type[7:0];
	    end else
	      req.user_pkt_data[k] = j;
	 end
	 `svt_xvm_rand_send_with(req, 
				 {
	    req.byte_count          == frame_size; 
	    req.mac_inter_frame_gap == ifg;
	    req.command_type        == svt_ethernet_enum_pkg::ETH_USER_FRAME_WITH_PREAMBLE_SFD_HEADER;
	 })
	   ;
	   req.print(); 

	 end // for (int j=0; j<no_of_frames;j++)
   endtask // send_error_frame

   `include "alt_eth_error_vip_base_sequence_tasks.svh"
 
endclass : alt_eth_error_vip_base_sequence
