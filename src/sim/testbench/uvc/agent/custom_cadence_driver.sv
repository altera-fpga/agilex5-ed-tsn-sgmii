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
//  (C) 2014 Altera Corporation. All rights reserved.
//
//  Your use of Altera Corporation's design tools, logic functions and other
//  software and tools, and its AMPP partner logic functions, and any output
//  files from any of the foregoing (including device programming or simulation
//  files), and any associated documentation or information are expressly
//  subject to the terms and conditions of the Altera Program License
//  Subscription Agreement, Altera MegaCore Function License Agreement, or
//  other applicable license agreement, including, without limitation, that
//  your use is for the sole purpose of programming logic devices manufactured
//  by Altera and sold by Altera or its authorized distributors.  Please refer
//  to the applicable agreement for further details.
//------------------------------------------------------------------------------
//  $Id: $
//  $Change: $
//  $Author: nvashis  $
//  $DateTime:  $
//==============================================================================
//------------------------------------------------------------------------------
//  File:  custom_cadence_driver.svh
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Class:  custom_cadence_driver
// This class gets the transcation from AVST RX monitor and unpacks that
// packet and then passes that to scoreboard
//------------------------------------------------------------------------------
class custom_cadence_driver extends uvm_component;

    /*Sideband if pointer*/
    typedef virtual eth_sideband_interface v_if;
    v_if custom_if;
      //Object: reg_model
    //This is register model handle
    registers_urm       reg_model;
    uvm_reg 	        regs;
    dyn_rcfg            dyn_rcfg_obj_inst;

    /*Current object's parent env name*/
    string env_name;

      
   `uvm_component_utils(custom_cadence_driver)

    //Function: new
    //This is class constructor and used to create port instances
     function new(string        name   = "custom_cadence_driver",uvm_component parent = null );
      super.new(name, parent);
       endfunction : new

    //------------------------------------------------------------------------------
    //  Function:  build_phase
    //
    //  Acquire the configutation object and RAL model handle from the environment and use it to
    //  configure the rx adapter.
    //
    //  Parameters:
    //
    //  phase - Current UVM phase.
    //
    //  Return:
    //
    //  None
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
        if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in rx packet adapter");   
        uvm_config_db#(v_if)::get(this, "", "mst_if", custom_if);
        if (custom_if == null)  `uvm_fatal("NO_CONN", "failed to get sideband interface");
        if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
           `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
        end
        if(!uvm_config_db#(string)::get(this,"","env_name", env_name)) begin
            `uvm_fatal("env_name_rxpkt_adpter", "failed to get env_name");
        end        
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);           
        
         endfunction:connect_phase

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
       drive_cadence(dyn_rcfg_obj_inst.cadnum,dyn_rcfg_obj_inst.cadden);// inputs come from parameter list,These should be calculated by user and entered manually in gdr_*.csv
   endtask: run_phase

   task drive_cadence(int num,int denm);
int accum = 0;
int num_l = num;
int denom = denm;
while (1) begin
            @(posedge custom_if.clk);
             // if(!custom_if.rst) begin   //using i_clk_tx,actually should be o_clk_pll but since i_clk_tx/rx is sourced from o_clk_pll,tx clk is used
             accum += num_l;
             if (accum >= denom) begin
                 accum -= denom;
                 custom_if.custom_cadence <= 1;
             end 
             else custom_if.custom_cadence <= 0;
           // end
             // else custom_if.custom_cadence <= 0;
           
     end
endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
      endfunction:report_phase


endclass : custom_cadence_driver

