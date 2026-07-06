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
// $File: /data/jbharatk/softip/acds/main/regtest/ip/ethernet/alt_ethernet/testbench/uvc/agent $
// $Revision: #1 $
// $Date: 2017/8/9 $
// $Author: rrajeeva$
//==============================================================================

`ifndef PTP_TOD_DRV__SV
`define PTP_TOD_DRV__SV


//==============================================================================
// Class: ptp_tod_drv
// ptp tod driver drives Time of Day (TOD) on every clock 
//==============================================================================
 
//typedef  bit[95:0] bit96;

class ptp_tod_drv extends uvm_driver;

  
  virtual eth_sideband_interface v_if;
//  virtual client_tx_if v_if_seg;
    
    //virtual client_tx_if#(.NUM_WORDS(16)) v_if_seg;
    //typedef virtual client_tx_if#(.NUM_WORDS(16)) seg_tx;
  virtual spy_interface spy_if;
  ptp_config m_ptp_config;
  dyn_rcfg dyn_rcfg_obj_inst; 
 // bit [47:0] tod_secs,ing_secs;
 // bit [31:0] tod_nsecs,ing_nsecs;
 // bit [15:0] tod_fnsecs;
 // int tod_ref_ns=0;
 // int ing_ref_ns=0;
 // logic ptp_cf_r;
 string rtb_path; 
 
  ptp_tod_drv_abstract ptp_tod_drv_abs;

  int transaction_id=0;
 
  extern function new(string name = "ptp_tod_drv",uvm_component parent);
  
  `uvm_component_utils_begin(ptp_tod_drv)
  `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   //extern virtual function bit96 get_tod_timestamp();
   //extern virtual function bit96 get_ing_timestamp();
   extern virtual function void set_config(ptp_config _config);
   extern function transfer_obj;
endclass: ptp_tod_drv

//==============================================================================
// Function: new
// Create a object for analysis port for mon
//==============================================================================
function ptp_tod_drv::new(string name = "ptp_tod_drv",uvm_component parent);
  super.new(name, parent);
endfunction: new

//==============================================================================
// Function: build_phase
//==============================================================================
function void ptp_tod_drv::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual eth_sideband_interface)::get(this, "", "mst_if", v_if)) begin
    `uvm_fatal("PTP_TOD_DRV","Virtual interface not configured!");
  end
 if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
    `uvm_fatal("PTP_TOD_DRV","Virtual spy interface not configured!");
  end

   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin
      `uvm_fatal("PTP_TOD_DRV","Seg interface not configured!");
   end 
   //else if(dyn_rcfg_obj_inst.mode == MACSEG) begin
   //   `uvm_info("ptp tod driver",$psprintf("Getting MACSEG interface"),UVM_LOW);
   //   if(!uvm_config_db#(seg_tx)::get(this,"","seg_tx_if",v_if_seg)) begin
   //      `uvm_fatal("client_tx_monitor","client_tx_if object is not found");  
   //   end
   //end
 
 
  
/*`ifndef QHIP_ACC_TESTING  
  tod_secs= m_ptp_config.tod_seconds_part;
  tod_nsecs=m_ptp_config.tod_ns_part;
  tod_fnsecs=m_ptp_config.tod_fns_part;
  ing_secs= m_ptp_config.ing_seconds_part;
  ing_nsecs=m_ptp_config.ing_ns_part;
`else
  tod_secs=0;
  tod_nsecs=0;
  tod_fnsecs=0;
  ing_secs=0;
  ing_nsecs=0;
`endif  
*/
 if(rtb_path=="") //null
       	`uvm_fatal("client_tx_driverr","rtb_path is not set");

 
if(!uvm_config_db#(ptp_tod_drv_abstract)::get(null,rtb_path,"CONCRETE_DRIVER",ptp_tod_drv_abs))
		`uvm_fatal("client_tx_driver","ptp_tx_driver concrete object is not set");
transfer_obj();

ptp_tod_drv_abs.clear_all_ts;

  //m_ptp_config=ptp_config::type_id::create("m_ptp_config",this);
endfunction: build_phase

//==============================================================================
// Function: connect_phase
// get the interface using the configuration database
//==============================================================================
function void ptp_tod_drv::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase

//==============================================================================
// Function: end_of_elaboration_phase
//==============================================================================
function void ptp_tod_drv::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase); 
endfunction: end_of_elaboration_phase

 // this is to transfer objects received in build phase to concrete class 
function ptp_tod_drv::transfer_obj(); 
   	ptp_tod_drv_abs.dyn_rcfg_obj_inst= dyn_rcfg_obj_inst; 
    ptp_tod_drv_abs.spy_if = spy_if;
    ptp_tod_drv_abs.v_if   = v_if;
    ptp_tod_drv_abs.m_ptp_config = m_ptp_config;
    //ptp_tod_drv_abs.v_if_seg = v_if_seg;
endfunction

//==============================================================================
// Task: run_phase
//==============================================================================
task ptp_tod_drv::run_phase(uvm_phase phase);
  super.run_phase(phase);

    `uvm_info("ptp tod driver",$psprintf("tod_seconds_part=%0d",m_ptp_config.tod_seconds_part),UVM_LOW);
    `uvm_info("ptp tod driver",$psprintf("ing_seconds_part=%0d",m_ptp_config.ing_seconds_part),UVM_LOW);
    `uvm_info("ptp tod driver",$psprintf("tod_ns_part=%0d",m_ptp_config.tod_ns_part),UVM_LOW);
    `uvm_info("ptp tod driver",$psprintf("tod_fns_part=%0f",m_ptp_config.tod_fns_part),UVM_LOW);
    `uvm_info("ptp tod driver",$psprintf("ing_ns_part=%0d",m_ptp_config.ing_ns_part),UVM_LOW);
  
   fork
      //TX
      forever begin
        ptp_tod_drv_abs.drv_tod_timestamp;
                 //v_if.drv_tx_tod_cb.ptp_rx_tod <= get_tod_timestamp;
      end
      forever begin
        ptp_tod_drv_abs.drv_ing_timestamp;
             end
      
      //RX
      forever begin
        ptp_tod_drv_abs.drv_rx_tod;

              end  
      
      forever fork
        forever begin
          @(m_ptp_config.tod_ns_part) begin
           ptp_tod_drv_abs.m_ptp_config.tod_ns_part = m_ptp_config.tod_ns_part;
           ptp_tod_drv_abs.update_tod_ns;
           end
         end
		forever begin
          @(m_ptp_config.tod_seconds_part) begin
           ptp_tod_drv_abs.m_ptp_config.tod_seconds_part = m_ptp_config.tod_seconds_part;
           ptp_tod_drv_abs.update_tod_seconds;
           end
         end
      forever begin
          @(m_ptp_config.ing_ns_part) begin
           ptp_tod_drv_abs.m_ptp_config.ing_ns_part = m_ptp_config.ing_ns_part;
           ptp_tod_drv_abs.update_ing_ns;
           end
         end
	  forever begin
          @(m_ptp_config.ing_seconds_part) begin
           ptp_tod_drv_abs.m_ptp_config.ing_seconds_part = m_ptp_config.ing_seconds_part;
           ptp_tod_drv_abs.update_ing_seconds;
           end
         end
            join
   //seg_tx drive
   if(dyn_rcfg_obj_inst.mode == MACSEG) begin
      fork
         //TX
         forever begin
            ptp_tod_drv_abs.seg_tx_tod_drv;
         end         

         forever begin 
            //TODO_GDR: add ptp_cf_r
           ptp_tod_drv_abs.drv_tx_its;
         end 

   
         //RX
         forever begin
           ptp_tod_drv_abs.drv_seg_rx_tod;
         end

      join_none
   end
   join_none
endtask: run_phase


//==============================================================================
// Function: start_of_simulation_phase
//==============================================================================
function void ptp_tod_drv::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
endfunction: start_of_simulation_phase

//==============================================================================
// Function: reset_phase
//==============================================================================
task ptp_tod_drv::reset_phase(uvm_phase phase);
  super.reset_phase(phase);
endtask: reset_phase

//==============================================================================
// Function: configure_phase
//==============================================================================
task ptp_tod_drv::configure_phase(uvm_phase phase);
  super.configure_phase(phase);
endtask:configure_phase

//==============================================================================
// Function: report_phase
//==============================================================================
function void ptp_tod_drv::report_phase(uvm_phase phase);
  super.report_phase(phase);
endfunction:report_phase

/*function bit96 ptp_tod_drv::get_tod_timestamp();
      bit [95:0] tod_timestamp,timestamp;
      bit [16:0] tod_fns_part;
      bit [31:0] tod_ns_max;

      timestamp[95:48] = tod_secs;
      tod_ns_max = $floor($realtime/1000) + tod_nsecs - tod_ref_ns; 
      tod_fns_part  = $floor(((($realtime - tod_ns_max[31:0] * 1000)/1000.0) + tod_fnsecs) * 65536);
      tod_ns_max = tod_ns_max + tod_fns_part[16] ;
      //if tod_ns_max is >= 1 billion ns then add seconds field by 1,reset ns
      //& fns fields & capture the timestamp, to use it as reference for
      //further TOD caluclations.
      if(tod_ns_max >= 32'd1000000000)begin
        tod_ref_ns <= $floor($realtime/1000);
        timestamp[95:48]=timestamp[95:48]+1;
	timestamp[47:16]=0;
      	timestamp[15:0] =0; 
       	tod_secs=timestamp[95:48];
	tod_nsecs=0;
      	tod_fnsecs=0;
        end
      else begin
      timestamp[47:16]=tod_ns_max;
      timestamp[15:0]  = tod_fns_part[15:0];
      end
      tod_timestamp = timestamp;
      return tod_timestamp;
endfunction

function bit96 ptp_tod_drv::get_ing_timestamp();
      bit [95:0] ing_timestamp,timestamp;
      bit [31:0] ing_ns_max;
      bit [47:0] ing_seconds;

      timestamp[95:48] = ing_secs;
      ing_ns_max = $floor($realtime/1000) + ing_nsecs - ing_ref_ns;
      if(ing_ns_max >= 32'd1000000000)begin
        ing_ref_ns <= $floor($realtime/1000);
        timestamp[95:48]=timestamp[95:48]+1;
	timestamp[47:16]=0;
      	timestamp[15:0] =0;
        ing_secs=timestamp[95:48];
	ing_nsecs=0;
       end
      else begin
      timestamp[47:16]=ing_ns_max;
      timestamp[15:0]  = $floor((($realtime) - ing_ns_max[31:0] * 1000)/1000.0 * 65536);
      end
      ing_timestamp = timestamp;
      return ing_timestamp;
endfunction*/

function void ptp_tod_drv::set_config(ptp_config _config);
         if (!$cast(m_ptp_config, _config))
            `uvm_error("CAST-FAILURE",
               "Failed to get pointer to the ptp_config")
endfunction : set_config


`endif // PTP_TOD_DRV__SV
