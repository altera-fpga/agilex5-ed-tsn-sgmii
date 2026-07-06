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
// $File: 
// $Revision:
// $Date: 
// $Author:
// Created by:
//==============================================================================

`ifndef __EHIP_MII_TX_DRIVER_SVH__
`define __EHIP_MII_TX_DRIVER_SVH__
typedef class eth_packet;
//------------------------------------------------------------------------------
//  Class: ehip_mii_tx_driver
//
//  This class defines the EHIP_CLIENT_TX driver for the
//  <ehip_client_tx_agent>.
//  It currently uses the standard Altera BFM to interact with the DUT.
//
//------------------------------------------------------------------------------
class ehip_mii_tx_driver extends uvm_driver #(eth_packet);
   virtual ehip_mii_tx_if   uif;
   virtual spy_interface    spy_if;
   dyn_rcfg          m_config;
   // Analysis ports
   uvm_analysis_port #(eth_packet) m_ap;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------

   // Semaphore to ensure the pipelined request to response control

   bit[63:0] packed_words[$];
   bit[7:0] packed_control[$];
   bit[7:0] packed_words_fd_location;
   int num_words_driver;
   bit first_frame;
   bit first_vld;
   int num_words; 
   int am_ins_cnt; 
   int am_ins_cyc; 
   bit[31:0] valid_count;
   int am_insert_count;
   bit am_insert_in_progress = 0;
   bit next_start_on_same_cycle = 0;
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(ehip_mii_tx_driver)
       `uvm_field_object(m_config,     UVM_PRINT)
//      `uvm_field_object(m_rtb_config, UVM_PRINT)
   `uvm_component_utils_end

   //
   // Constructor: new
   //
   // Creates instance of this UVM component.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //  parent - Handle to the hierarchical parent, *null* if none.
   //
   function new(string name, uvm_component parent);
      super.new(name, parent);
      this.packed_words_fd_location = 8'b0000_0000;
      this.num_words_driver = 4;
      this.first_frame = 1;
      this.first_vld= 1;
      //this.num_words = `NUM_WORDS_NEW;       
   endfunction : new
//==============================================================================
// Function: build_phase
//==============================================================================
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     m_ap = new("m_ap", this);
     if(!uvm_config_db#(virtual ehip_mii_tx_if)::get(this, "", "mii_tx_if", uif)) begin
       `uvm_fatal("ehip_mii_tx_drv","Virtul mii_interface not configured!");
     end
     if(!uvm_config_db#(virtual spy_interface)::get(this,"","spy_if_mii",spy_if))begin
       `uvm_fatal("ehip_mii_tx_drv","Virtul spy_interface not configured!");
     end
     if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", m_config))begin
      `uvm_error("ehip_mii_tx_drv","config object is not found"); 
     end
   endfunction: build_phase      
   //
   // Task: run_phase
   //
   // Wait for requests from the sequencer and pass them to the driver for
   // execution.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   task run_phase(uvm_phase phase);

     fork
     begin
         update_dyn_obj();
     end
       begin
         drive_tran();  // To drive the DUT signals to desire values
       end
       begin
         drive_mii_interface();
       end
     begin
         drive_am_insert();
       end
       begin
         monitor_rdy(); 
       end
     join
   endtask : run_phase
//--------------------------------------------------------------------
//   update_dyn_obj
//--------------------------------------------------------------------
   task update_dyn_obj();
       forever begin
            @(uif.clk);
            if(m_config.fec_type inside {RSFECKP, RSFECKR, LLFEC}) begin
                num_words  = (m_config.speed == _25G) ? 1:
                             (m_config.speed == _50G) ? 2:
                             (m_config.speed == _100G)? 4:
                             (m_config.speed == _200G)? 8:
                             (m_config.speed == _400G)? 16:4;
                am_ins_cnt = (m_config.speed == _25G) ? 1280:
                             (m_config.speed == _50G) ? 640:
                             (m_config.speed == _100G)? 1280:
                             (m_config.speed == _200G)? 640:
                             (m_config.speed == _400G)? 640:1280;
                am_ins_cyc = (m_config.speed == _25G) ? 4:
                             (m_config.speed == _50G) ? 2:
                             (m_config.speed == _100G)? 5:
                             (m_config.speed == _200G)? 2:
                             (m_config.speed == _400G)? 2:5;
            end
            else begin
                num_words  = (m_config.speed == _10G) ? 1:
                             (m_config.speed == _25G) ? 1:
                             (m_config.speed == _40G) ? 2:
                             (m_config.speed == _50G) ? 2:
                             (m_config.speed == _100G)? 4:4;
                am_ins_cnt = (m_config.speed == _40G) ? 128:
                             (m_config.speed == _50G) ? 512:
                             (m_config.speed == _100G)? 320:320;
                am_ins_cyc = (m_config.speed == _40G) ? 2:
                             (m_config.speed == _50G) ? 2:
                             (m_config.speed == _100G)? 5:5;
            end

       end
   endtask
//--------------------------------------------------------------------
/////////////////////////////////
// initial signal drive
/////////////////////////////////
   task init();

     @(uif.mst_cb);

     uif.mst_cb.vld <= 1'b0;
     uif.mst_cb.dsk_marker <= '0;
       
     for(int i=0; i<num_words; i++) begin
       uif.mst_cb.data[i] <= {8{8'h07}};
       uif.mst_cb.ctl[i] <= {8{1'b1}};
     end

   endtask : init

   //
   // Task: drive_tran
   //
   //  Task to get the sequence item from sequencer and call 
   //  bfm_drive_tran task and drive the transaction through interface
   //  to the DUT.
   //
   task drive_tran();
     eth_packet m_tran;
 
     uif.mst_cb.am_insert <= 0;
     init();

     forever begin : b_FOREVER_DRV_TRAN
        seq_item_port.try_next_item(m_tran);
        if (m_tran == null) begin
          @(uif.mst_cb);
        end  
        else begin
          @(uif.mst_cb);

          // Drive the request
          bfm_drive_tran(m_tran);

          seq_item_port.item_done();
        end
     end : b_FOREVER_DRV_TRAN
   endtask: drive_tran

   

   // Unpach the received transaction and pack words in 8bytes bundle 
   task bfm_drive_tran(eth_packet _tran);
     eth_packet driver_tran;

     driver_tran = eth_packet ::type_id::create("driver_tran");
     driver_tran.copy(_tran);

     `uvm_info(get_name(), $sformatf("Printing packet in bfm_drive_trans %0s",driver_tran.sprint()), UVM_LOW)

     driver_tran.pack_bytes(1'b0,1'b1); // supal : check if arguments are correct or not

     pack_words(driver_tran);

   endtask : bfm_drive_tran


   // Drive packed workds on mii interface
   task drive_mii_interface();

     bit begin_of_transfer  = 1'b1;

     forever begin : loop_drive_mii_interface
       if(this.packed_words.size > 0) begin
         while(this.packed_words.size > 0) begin
	     `uvm_info(get_name(),$sformatf("\nbegin_of_transfer = %0d\npacked_words = %0d\nvld = %0d\nam_insert_in_progress = %0d ",begin_of_transfer,this.packed_words.size(),uif.vld,am_insert_in_progress),UVM_DEBUG);
           if((uif.vld == 0) || (am_insert_in_progress == 1)) begin
             @(posedge uif.clk);
           end
           else begin
             if(begin_of_transfer == 1'b1) begin
               start_from_random_location_new();
               begin_of_transfer = 1'b0;
             end 
             else begin
               drive_data_new(0,0);
             end
             @(posedge uif.clk);
           end
         end // while(this.packed_words.size > 0)
       end
       else begin
	     `uvm_info(get_name(),$sformatf("\nbegin_of_transfer = %0d\npacked_words = %0d\nvld = %0d\nam_insert_in_progress = %0d ",begin_of_transfer,this.packed_words.size(),uif.vld,am_insert_in_progress),UVM_DEBUG);
         drive_idles();
         begin_of_transfer = 1'b1;
       end
     end : loop_drive_mii_interface

   endtask : drive_mii_interface 

   // If no packets are recived from sequence, drive Idles
   task drive_idles();

     if((uif.vld == 0) || (am_insert_in_progress == 1)) begin
       @(posedge uif.clk);
     end
     else begin
       for(int i=0; i<num_words; i++) begin
         uif.mst_cb.data[i] <= {8{8'h07}};
         uif.mst_cb.ctl[i] <= {8{1'b1}};
       end
       @(posedge uif.clk);
     end
   endtask : drive_idles

   // Drive am insert signals at the reguler am period 
   task automatic drive_am_insert();
     int valid_count;

     forever begin : f_loop_drive_am_insert
       @(uif.mst_cb);
      /*Instead of `defines added below logic to work on 10G & 25G*/
      // AM insert is not required for single with NOFEC type)
      if(m_config.speed == _10G || (m_config.speed == _25G && m_config.fec_type == NOFEC)) 
          continue;
       //
       if(uif.mst_cb.vld == 1) begin
         valid_count++;
       end

       if(valid_count == am_ins_cnt) begin //am_insert logic
         am_insert_count = 0;
         valid_count = 0;
         uif.mst_cb.am_insert <= 1;
         am_insert_in_progress = 1;

         while(am_insert_count < am_ins_cyc) begin
           if(uif.mst_cb.vld == 1) begin
             am_insert_count++;
             @(uif.mst_cb);
             `uvm_info(get_name(), $sformatf("drive_am_insert insert_am asserted AT TIME :%t, am_insert_count %d ", $time, am_insert_count), UVM_DEBUG)
             valid_count++;
           end
           else if(uif.mst_cb.vld == 0) begin
             @(uif.mst_cb);
             `uvm_info(get_name(), $sformatf("drive_am_insert insert_am: held AT TIME :%t, as vld:%d is low, am_insert_count :%d", $time, uif.mst_cb.vld, am_insert_count), UVM_DEBUG)
           end
         end //while

         if(uif.mst_cb.vld !== 1) begin
           while(uif.mst_cb.vld !== 1) begin
             @(uif.mst_cb);
           end
           `uvm_info(get_name(), $sformatf("drive_am_insert valid_count:%d held AT TIME :%t, am_insert_count :%d", valid_count, $time, am_insert_count), UVM_DEBUG)
         end
         uif.mst_cb.am_insert <= 0;
         `uvm_info(get_name(), $sformatf("drive_am_insert reset insert_am AT TIME :%t, am_insert_count :%d", $time, am_insert_count),UVM_DEBUG)
         am_insert_count = 0;
         am_insert_in_progress = 0;
         `uvm_info(get_name(), $sformatf("drive_am_insert reset insert_am AT TIME :%t, reset am_insert_count :%d, reset valid_count :%d, am_insert_in_progress:%d", $time, am_insert_count, valid_count, am_insert_in_progress),UVM_DEBUG)
       end
     end : f_loop_drive_am_insert  
   endtask : drive_am_insert

   // Monitor ready signals from the DUT and drive valid signal accordiglly 
   task monitor_rdy();

     forever begin
       @(uif.mst_cb);    
       fork
         begin
           uif.mst_cb.vld <= uif.mst_cb.rdy;
         end
       join_none
     end
   endtask : monitor_rdy


   // Pack 8 bytes words, Insert idles to maintain IPG   
   task pack_words(eth_packet _tran);

     bit[7:0] local_packed_bytes[];
     bit[7:0] local_packed_control[];
     int r_count; 

     local_packed_bytes = new[_tran.packed_bytes.size()+1];

     foreach(_tran.packed_bytes[i]) begin
     	local_packed_bytes[i] = _tran.packed_bytes[i];
     end
     local_packed_bytes[local_packed_bytes.size()-1] = 8'hfd;

     if(local_packed_bytes.size() %8 == 0) begin
       local_packed_control = new[local_packed_bytes.size()/8];
     end
     else begin
       local_packed_control = new[(local_packed_bytes.size()/8) + 1];
     end

     if(_tran.ipg_idle_ins_en == 1'b1) begin
       if(m_config.speed != _10G && m_config.speed != _25G) begin
       r_count = (_tran.interpacket_gap%8 == 0) ? (_tran.interpacket_gap/8) : ((_tran.interpacket_gap/8) + 1) ;
       repeat (r_count) begin
         this.packed_words.push_back({8{8'h07}});
	     this.packed_control.push_back({8{1'b1}});
       end
       end
       else begin
       r_count = (_tran.interpacket_gap%16 == 0) ? (_tran.interpacket_gap/16) : ((_tran.interpacket_gap/16) + 1) ;
       repeat (r_count) begin
         this.packed_words.push_back({16{8'h07}});
	     this.packed_control.push_back({16{1'b1}});
       end
       if(r_count < 5) begin
         repeat(5) this.packed_words.push_back({16{8'h07}});
	     repeat(5) this.packed_control.push_back({16{1'b1}});
       end
       end
     end

     for(int packed_bytes_index = 0; packed_bytes_index < local_packed_bytes.size(); packed_bytes_index = packed_bytes_index + 'd8) begin
       if(packed_bytes_index + 'd8 > local_packed_bytes.size()) begin
         if((local_packed_bytes.size() - packed_bytes_index) == 'd7) begin
           this.packed_words.push_back({8'h07,local_packed_bytes[packed_bytes_index+'d6],
  	         		        local_packed_bytes[packed_bytes_index+'d5],local_packed_bytes[packed_bytes_index+'d4],
  	         		        local_packed_bytes[packed_bytes_index+'d3],local_packed_bytes[packed_bytes_index+'d2],
  	         		        local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1100_0000;				
	 end
         if((local_packed_bytes.size() - packed_bytes_index) == 'd6) begin
           this.packed_words.push_back({8'h07,8'h07,
  	         		        local_packed_bytes[packed_bytes_index+'d5],local_packed_bytes[packed_bytes_index+'d4],
  	         		        local_packed_bytes[packed_bytes_index+'d3],local_packed_bytes[packed_bytes_index+'d2],
  	         		        local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1110_0000;				
	 end
         if((local_packed_bytes.size() - packed_bytes_index) == 'd5) begin
           this.packed_words.push_back({8'h07,8'h07,
  	         		        8'h07,local_packed_bytes[packed_bytes_index+'d4],
  	         		        local_packed_bytes[packed_bytes_index+'d3],local_packed_bytes[packed_bytes_index+'d2],
  	         		        local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1111_0000;				
	 end
         if((local_packed_bytes.size() - packed_bytes_index) == 'd4) begin
           this.packed_words.push_back({8'h07,8'h07,
  	         		        8'h07,8'h07,
  	         		        local_packed_bytes[packed_bytes_index+'d3],local_packed_bytes[packed_bytes_index+'d2],
  	         		        local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1111_1000;				
	 end
         if((local_packed_bytes.size() - packed_bytes_index) == 'd3) begin
           this.packed_words.push_back({8'h07,8'h07,
  	         		        8'h07,8'h07,
  	         		        8'h07,local_packed_bytes[packed_bytes_index+'d2],
  	         		        local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1111_1100;				
	 end
         if((local_packed_bytes.size() - packed_bytes_index) == 'd2) begin
           this.packed_words.push_back({8'h07,8'h07,
  	         		        8'h07,8'h07,
  	         		        8'h07,8'h07,
  	         		        local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1111_1110;				
	 end
         if((local_packed_bytes.size() - packed_bytes_index) == 'd1) begin
           this.packed_words.push_back({8'h07,8'h07,
  	         		        8'h07,8'h07,
  	         		        8'h07,8'h07,
  	         		        8'h07,local_packed_bytes[packed_bytes_index+'d0]});
	   local_packed_control[packed_bytes_index/8] = 8'b1111_1111;				
	 end
       end
       else begin
         this.packed_words.push_back({local_packed_bytes[packed_bytes_index+'d7],local_packed_bytes[packed_bytes_index+'d6],
  	         		      local_packed_bytes[packed_bytes_index+'d5],local_packed_bytes[packed_bytes_index+'d4],
  	         		      local_packed_bytes[packed_bytes_index+'d3],local_packed_bytes[packed_bytes_index+'d2],
  	         		      local_packed_bytes[packed_bytes_index+'d1],local_packed_bytes[packed_bytes_index+'d0]});
	 if((local_packed_bytes.size() - packed_bytes_index) == 'd8)begin
	   local_packed_control[packed_bytes_index/8] = 8'b1000_0000;				
	 end
	 else if(packed_bytes_index == 0) begin
	   local_packed_control[packed_bytes_index/8] = 8'b0000_0001;				
	 end
	 else begin
	   local_packed_control[packed_bytes_index/8] = 8'b0000_0000;				
	 end
       end				    
     end

     foreach(local_packed_control[i]) begin
       this.packed_control.push_back(local_packed_control[i]);
     end

     `uvm_info("ehip_mii_tx_driver_bfm", $sformatf("DEBUG || Size of Packing word='d%d & Pcaking control='d%d",this.packed_words.size(),this.packed_control.size()), UVM_LOW)
     foreach(this.packed_words[i]) begin
     `uvm_info("ehip_mii_tx_driver_bfm", $sformatf("DEBUG || Packing word='h%h & Pcaking control='h%h",this.packed_words[i],this.packed_control[i]), UVM_DEBUG)
     end

   endtask // pack_words 
   //--------------------drive_data_new--------------------
   //based on start_word, data & control is driven on respective lanes.
   //For Ex: For 100G if start_word=3, then actual data will be driven on 0th lane of intf &
   //remaining lanes will be updated with packed_words/ idles. 

   task drive_data_new(int start_word, bit begin_of_transfer);
	`uvm_info(get_name(),$sformatf("drive_data_new %0d",uif.mst_cb.vld),UVM_DEBUG)
	for(int i=0;i<num_words;i++) begin
	    if(i==start_word) begin
	      if(begin_of_transfer == 1'b1) begin
		 set_start_control_new(i);
	      end
	      uif.mst_cb.data[i] <= this.packed_words.pop_front();
	      if(begin_of_transfer == 1'b0) begin
		 check_eop_new(i);
	      end
	      for(int k=num_words-i-1;k>0;k--)begin
		  if(this.packed_words.size() >0)begin
	            uif.mst_cb.data[num_words-k] <= this.packed_words.pop_front();
		    check_eop_new(num_words-k);
		  end
		  else begin
	            uif.mst_cb.data[num_words-k] <= {8{8'h07}};
	            uif.mst_cb.ctl[num_words-k]  <= {8{1'b1}};
		  end
	      end
	    end
	end
   endtask
   // Drive 8 bytes of data on interface
   task set_start_control_new(int word);
     `uvm_info(get_name(),$sformatf("set_start_control_new word %0d",word),UVM_DEBUG)
      uif.mst_cb.ctl[word] <= this.packed_control.pop_front(); 
   endtask

   task check_eop_new(int word);
        `uvm_info(get_name(),$sformatf("check_eop_new word %0d",word),UVM_DEBUG)
	   if(this.packed_words.size() >0) begin
		   uif.mst_cb.ctl[word] <= this.packed_control.pop_front();
                  `uvm_info(get_name(),$sformatf("inside check_eop_new word %0d",word),UVM_DEBUG)
	   end
	   else begin
		set_eop_new(word);  
	   end
   endtask

   task start_from_random_location_new();
      int start_location;
      start_location = $urandom_range(0,num_words-1);
      `uvm_info("ehip_mii_tx_driver_bfm", $sformatf("start_from_random_location start_location:%d , at time:%t",start_location, $time), UVM_DEBUG)
      for(int i=0;i<start_location;i++) begin
	 uif.mst_cb.data[num_words-i-1] <= {8{8'h07}};
	 uif.mst_cb.ctl[num_words-i-1]  <= {8{1'b1}};
      end
      drive_data_new(start_location,1);
   endtask
	   


   task set_eop_new(int word);
     `uvm_info(get_name(),$sformatf("set_eop_new word %0d",word),UVM_DEBUG)
       uif.mst_cb.ctl[word] <= this.packed_control.pop_front();
       this.packed_words_fd_location = 8'b0000_0000;
   endtask


endclass : ehip_mii_tx_driver

`endif//__EHIP_MII_TX_DRIVER_SVH__
