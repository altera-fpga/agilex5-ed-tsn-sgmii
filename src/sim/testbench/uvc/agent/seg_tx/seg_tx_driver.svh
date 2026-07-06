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


///==============================================================================
// Copyright (c) Programmable Solutions Group (PSG),
// Intel Corporation 2016 - present.
// All rights reserved.
//
//------------------------------------------------------------------------------
// TB/UVC Skeleton is created by: utbgen.pl by Hoong Han Leong
//==============================================================================

`ifndef __CLIENT_TX_DRIVER_SVH__
`define __CLIENT_TX_DRIVER_SVH__

//------------------------------------------------------------------------------
//  Class: client_tx_driver
//
//  This class defines the CLIENT_TX driver for the
//  <client_tx_agent>.
//  It currently uses the standard Altera BFM to interact with the DUT.
//
//------------------------------------------------------------------------------
typedef class eth_packet;
typedef class dyn_rcfg; 
class client_tx_driver extends uvm_driver#(eth_packet);

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   // Agent's configuration class
   dyn_rcfg          m_config;
   seg_tx_driver_abstract driver_abs; 
   string rtb_path; 
   uvm_cmdline_processor  inst;
   string m_sequence = "vip_sanity_sequence";
   `ifdef ENABLE_ETH_VIP
   virtual svt_ethernet_txrx_if vip_txrx_if; 
   `endif
   virtual spy_interface spy_if;

   // Semaphore to ensure the pipelined request to response control
   local semaphore response_copied = new(1);
    
   string  file_exp = "exp_drv_pkt.log";
   string  file_exp_seg = "exp_drv_pkt_1.log";
   integer file_exp_log_id; 
   integer file_seg_mon_pkt_id;
   registers_urm reg_model;
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(client_tx_driver)
      `uvm_field_object(m_config,     UVM_PRINT)
   `uvm_component_utils_end

   extern function new(string name, uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function transfer_obj(); 
   extern task run_phase(uvm_phase phase); 
   extern function void report_phase(uvm_phase phase);
   extern task drive_tran();
   extern task wait_for_completion(eth_packet _req);
   covergroup bus_rate with function sample(seg_bus rate); 
      coverpoint rate;
   endgroup


   function void sample(seg_bus rate); 
      bus_rate.sample(rate); 
   endfunction 


endclass:client_tx_driver
   //
   // Constructor: new
   //
   // Creates instance of this UVM component.
   //
   // Parameter(s):
   //  name   - Name of the instance.
   //  parent - Handle to the hierarchical parent, *null* if none.
   //
   function client_tx_driver::new(string name, uvm_component parent);
      super.new(name, parent);
      bus_rate =new();
   endfunction : new
   //
   // Function: build_phase
   //
   // Read the configuration information from the environment and use this to
   // locate the BFM.
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   //
   function void client_tx_driver::build_phase(uvm_phase phase);
      super.build_phase(phase);
         // SPY IF
  	 if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
       	 `uvm_fatal("spy_interface", "failed to get spy_interface intf seg drv");
  	 end
      //uvm_config_db#(client_tx_config)::get(this,,"seg_tx_cfg",m_config);
      if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", m_config))
      `uvm_error("client_tx_driver","config object is not found");
         
      `ifdef ENABLE_ETH_VIP
      	if(!uvm_config_db#(virtual svt_ethernet_txrx_if)::get(this,"", "seg_if_port", vip_txrx_if))
      		`uvm_fatal("client_tx_driver","svt_ethernet_txrx_if object is not found");
      `endif
      uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
        if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in seg_tx_driver");
        // Get concrete object from RTB module 
        if(rtb_path=="") //null
        	`uvm_fatal("client_tx_driver","rtb_path is not set");
        if(!uvm_config_db#(seg_tx_driver_abstract)::get(null,rtb_path,"CONCRETE_DRIVER",driver_abs))
			`uvm_fatal("client_tx_driver","seg_tx_driver concrete object is not set");        	
        transfer_obj(); 
   endfunction : build_phase

   // this is to transfer objects received in build phase to concrete class 
   function client_tx_driver::transfer_obj(); 
   	driver_abs.m_config= m_config; 
   	driver_abs.reg_model= reg_model;
   	endfunction
   //
   // Task: run_phase
   //
   // Wait for requests from the sequencer and pass them to the BFM for
   // execution.
   //
   // Parameter(s):
   //  phase - Current UVM phase.

   task client_tx_driver::run_phase(uvm_phase phase);
   	driver_abs.num_words_update(); 

      fork
      begin 
      //Have ready_latency generated for every reset
        driver_abs.gen_rdy_ltny();
      end 
	  begin
	     `uvm_info(get_type_name(), "CLIENT_TX Driver Starting to monitor rdy ", UVM_LOW)
	     driver_abs.monitor_ready();
	   end
      join_none

      //initialize the signals 
      driver_abs.init();
      
      // drive idles until VIP link is up 
      `ifdef ENABLE_ETH_VIP
      fork // to make sure only fork threads in this scope get disabled.
      begin
	     	fork 
         begin 
	      	`uvm_info(get_type_name(),$sformatf("CLIENT_TX Driver waiting for link up trigger :%t ", $time), UVM_LOW)
		 if(m_sequence != "bandwidth_sequence" && m_sequence != "sanity_loopback_sequence") begin			 
	      	@(vip_txrx_if.if_bfm.event_link_up); 
	      	`uvm_info(get_type_name(), $sformatf("CLIENT_TX Driver recd link up trigger :%t ", $time), UVM_LOW)
	      end
            end
	      begin
            forever
	      		driver_abs.bfm_drive_idle(); 
	      	end
	      join_any
	      disable fork; 
	   end
      join
      `endif
      file_exp_log_id =  $fopen({get_name(),file_exp},"a");
      file_seg_mon_pkt_id =  $fopen({get_name(),file_exp_seg},"a");
      drive_tran();  // To drive the DUT signals to desired values

   endtask : run_phase
   
   function void client_tx_driver::report_phase(uvm_phase phase);
      super.report_phase(phase);
      $fclose(file_exp_log_id);
      $fclose(file_seg_mon_pkt_id);
   endfunction:report_phase
   
   
   
  
   //
   // Task: drive_tran
   //
   //  Task to get the sequence item from sequencer and call the BFM's
   //  bfm_drive_tran task and drive the transaction through interface
   //  to the DUT.
   //
   task client_tx_driver::drive_tran();
      eth_packet m_tran;
      string task_name = "drive_tran";
      event packwords_first; 
      int   pkt_cnt;

      forever begin : b_FOREVER_DRV_TRAN
      //	fork 
      		//begin 
	      seq_item_port.try_next_item(m_tran);
	      if (m_tran == null) 
	       	driver_abs.drive_interm_idle();
	      else
		   begin
            // Drive the request
            $display("client_tx_driver: Before driving the packet");
            bus_rate.sample(m_tran.bus_rate); //sampling for bus rate coverage
            if(m_tran.bus_rate!=BUSY)
               driver_abs.drive_interm_idle();
            driver_abs.bfm_drive_tran(m_tran);
            `uvm_info(get_type_name(), $sformatf("Transaction Packet -> \n%0s",
               m_tran.convert2string()), UVM_NONE)
            pkt_cnt++;
            m_tran.transaction_id = pkt_cnt; 
               
		      $fwrite(file_exp_log_id,"Transaction no:%0d\n %s \n",m_tran.transaction_id,m_tran.sprint());
            $fwrite(file_seg_mon_pkt_id,"Transaction no:%0d\n %s \n",m_tran.transaction_id,m_tran.print_transaction(.frame_count(m_tran.transaction_id),.seg_mode(0)));  

		      // Trigger the parallel process to wait for the response
		      fork
		         wait_for_completion(m_tran);
		      join_none
		         
            // Wait for the response sequence item under wait_for_completion
            // to clone and copy the transaction_id
		      response_copied.get();
		      // Finish the request drive
            seq_item_port.item_done();

		         //   disable fork; 
		   end
      end : b_FOREVER_DRV_TRAN
   endtask: drive_tran

   //
   // Task: wait_for_completion
   //
   // Wait for the response and send back the response to the sequencer
   // if expect_responce is set.
   //
   // Parameter(s)
   //  _req - request transaction type eth_packet)
   //
   task client_tx_driver::wait_for_completion(eth_packet _req);
      eth_packet _rsp;

      `altuvm_assert($cast(_rsp, _req), get_type_name(),
         $sformatf({"Type casting failure: Received transaction type ",
         "%0s, not the expected type"}, _req.get_type_name()))

      // Set the request's IDs into the response sequence item
      _rsp.set_id_info(_req);

      // Allow the drive_tran to proceed to finish the item_done
      response_copied.put();

      // Send back completion to sequencer if response is expected
      if (_rsp.expect_response) begin
         `uvm_info(get_type_name(), $sformatf("CLIENT_TX has driven response ->%0s",
            _rsp.convert2string()), UVM_NONE)
         seq_item_port.put(_rsp);
      end
      else
         `uvm_info(get_type_name(), $sformatf("CLIENT_TX has done waiting for response ->%0s",
            _rsp.convert2string()), UVM_NONE)
   endtask : wait_for_completion



`endif//__CLIENT_TX_DRIVER_SVH__
