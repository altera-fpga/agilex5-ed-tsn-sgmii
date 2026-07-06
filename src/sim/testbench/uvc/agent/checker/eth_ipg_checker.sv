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
// $File:  $
// $Revision	:  		$
// $Date	:  	$
// $Author	: pjoshi	$
//==============================================================================

`ifndef __ETH_IPG_CHECKER__
`define __ETH_IPG_CHECKER__
//==============================================================================
// Class: eth_ipg_checker
//
// EHIP IPG checker for Ethernet S10 Core
//
//==============================================================================

class eth_ipg_checker extends uvm_component;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   bit                  ipg_check_enable;
   bit                  additional_ipg_enb;
   typedef virtual eth_sideband_interface dut_int_sigs; 
   dut_int_sigs eth_dut_sig_if;
   bit                  start_check_en;
   int                  start_check_after_n_frames, first_valid_am, prev_valid_am;
   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;

   bit [3:0]            sop_found, eop_found;
   bit                  first_frame;
   int                  drv_ipg_bytes, drv_ipg_bytes_q[$],  i_total_ipg, i_ipg_bytes_frame;
   int                  o_first_frame, o_sop_found, o_eop_found, o_ipg_bytes, o_ipg_bytes_q[$], o_num_frames, o_ipg_bytes_frame, o_am_idle_bytes;
   real                 o_avg_ipg, i_avg_ipg, o_total_ipg, o_num_of_gaps, o_num_of_gaps_on_am;

   real   avg_ipg,ipg_rem; 
    //Object: reg_model 
    //This is register model handle 
    registers_urm reg_model; 
    bit [1:0] tx_avg_ipg;
    bit [15:0] ipg_col_rem;
    bit  am_count_en = 1'b0; 
    uvm_reg 	regs;
   
   logic mii_clk;
   logic mii_valid;
   logic am_valid;
   logic [31:0] mii_d[16];   
   logic [3:0]  mii_c[16];  
   int am_count,am_count1,am_count2;
   
   int ipg_incr;
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(eth_ipg_checker)
     `uvm_field_int(ipg_check_enable, UVM_ALL_ON)
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
      //
      // Creating the analysis ports
      //
      drv_ipg_bytes = 0;
      first_frame = 1;
      sop_found = 0;
      eop_found = 0;

      o_sop_found = 0;
      o_eop_found = 0;
      o_ipg_bytes = 0;
      o_num_of_gaps = 0;
      o_num_frames = 0;
      o_total_ipg = 0;
      o_avg_ipg = 0;
      o_ipg_bytes_frame = 0;
      o_first_frame = 0;
      first_valid_am = 0;
      prev_valid_am= 0;
      am_count=0;
      am_count2=0;
 
      start_check_after_n_frames = 1;
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
   endfunction : new

   //
   // Function: build_phase
   //
   // Parameter(s):
   //  phase - Current UVM phase.
   function void build_phase(uvm_phase phase);
      bit en_checker;
      super.build_phase(phase);

       uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
        if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in rx packet adapter");  
       uvm_config_db#(dut_int_sigs)::get(this, "", "mst_if", eth_dut_sig_if);
       if (eth_dut_sig_if == null)  `uvm_fatal("NO_CONN", "Sideband signal interface not connected to the interface");   
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
   endfunction : connect_phase

   /* Gets the register or field value from ral and return as  bit vector*/
   function int gdr_ral_get(string regname, string fldname="");
       uvm_reg_field fld_l;
       uvm_reg reg_l;
       uvm_reg regs[$];
       //ll_TODO: remove case (dyn_rcfg_obj_inst.speed)
       //ll_TODO: remove _10G : regname = {"e25_",regname};
       //ll_TODO: remove _25G : regname = {"e25_",regname};
       //ll_TODO: remove _50G : regname = {"e50_",regname};
       //ll_TODO: remove _40G : regname = {"e100_",regname};
       //ll_TODO: remove _100G : regname = {"e100_",regname};
       //ll_TODO: remove _200G : regname = {"e200_",regname};
       //ll_TODO: remove _400G : regname = {"e400_",regname};
       //ll_TODO: remove endcase 
       reg_model.default_map.get_registers(regs);
       foreach(regs[i]) begin
         if (regname == regs[i].get_name()) begin
           reg_l = regs[i]; 
           `uvm_info("ETH_REF_MODEL",$psprintf("RAL get register :%0s, value %0h",reg_l.get_name(),reg_l.get()),UVM_MEDIUM);
           if(fldname == "") return reg_l.get();
           else begin
             fld_l  = reg_l.get_field_by_name(fldname);
             `uvm_info("ETH_REF_MODEL",$psprintf("RAL get field :%0s, value %0h",fldname,fld_l.get()),UVM_MEDIUM);
             return fld_l.get();
           end
         end
       end
       `uvm_fatal("eth_ref_model", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
   endfunction

   task run_phase(uvm_phase phase);
     super.run_phase(phase);
     @(posedge eth_dut_sig_if.rx_pcs_ready); begin
      monitor_output_tx_mac_interface();
    end
   endtask

   task monitor_output_tx_mac_interface();
     fork
     begin
       forever begin
         case (dyn_rcfg_obj_inst.speed)
         _10G :  begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_25g) ; 
                    mii_valid = eth_dut_sig_if.mii_tx_valid_25g ; 
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_25g  ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_25g  ; 
		            am_valid = eth_dut_sig_if.mii_am_valid_25g ;
                    ipg_incr = 4; 
                    end 
         _25G :  begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_25g) ;
                    mii_valid = eth_dut_sig_if.mii_tx_valid_25g ; 
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_25g  ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_25g  ;
		            am_valid = eth_dut_sig_if.mii_am_valid_25g ;
                    ipg_incr = 4; 
                 end
         _40G : begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_100g);
                    mii_valid = eth_dut_sig_if.mii_tx_valid_100g; 
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_100g[0] ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_100g[0] ; 
                    mii_d[1] = eth_dut_sig_if.mii_tx_data_lane_100g[1] ; 
                    mii_c[1] = eth_dut_sig_if.mii_tx_c_lane_100g[1] ; 
                    mii_d[2] = eth_dut_sig_if.mii_tx_data_lane_100g[2] ; 
                    mii_c[2] = eth_dut_sig_if.mii_tx_c_lane_100g[2] ; 
                    mii_d[3] = eth_dut_sig_if.mii_tx_data_lane_100g[3] ; 
                    mii_c[3] = eth_dut_sig_if.mii_tx_c_lane_100g[3] ; 
		            am_valid = eth_dut_sig_if.mii_am_valid_100g ;
                    ipg_incr = 16; 
                 end
         _50G :  begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_50g) ; 
                    mii_valid = eth_dut_sig_if.mii_tx_valid_50g ;
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_50g[0]  ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_50g[0]  ; 
                    mii_d[1] = eth_dut_sig_if.mii_tx_data_lane_50g[1]  ; 
                    mii_c[1] = eth_dut_sig_if.mii_tx_c_lane_50g[1]  ; 
		            am_valid = eth_dut_sig_if.mii_am_valid_50g ;
                    ipg_incr = 4; 
                 end
         _100G : begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_100g);
                    mii_valid = eth_dut_sig_if.mii_tx_valid_100g; 
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_100g[0] ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_100g[0] ; 
                    mii_d[1] = eth_dut_sig_if.mii_tx_data_lane_100g[1] ; 
                    mii_c[1] = eth_dut_sig_if.mii_tx_c_lane_100g[1] ; 
                    mii_d[2] = eth_dut_sig_if.mii_tx_data_lane_100g[2] ; 
                    mii_c[2] = eth_dut_sig_if.mii_tx_c_lane_100g[2] ; 
                    mii_d[3] = eth_dut_sig_if.mii_tx_data_lane_100g[3] ; 
                    mii_c[3] = eth_dut_sig_if.mii_tx_c_lane_100g[3] ; 
		            am_valid = eth_dut_sig_if.mii_am_valid_100g ;
                    ipg_incr = 16; 
                 end
         _200G : begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_200g); 
                    mii_valid = eth_dut_sig_if.mii_tx_valid_200g;
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_200g[0] ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_200g[0] ; 
                    mii_d[1] = eth_dut_sig_if.mii_tx_data_lane_200g[1] ; 
                    mii_c[1] = eth_dut_sig_if.mii_tx_c_lane_200g[1] ; 
                    mii_d[2] = eth_dut_sig_if.mii_tx_data_lane_200g[2] ; 
                    mii_c[2] = eth_dut_sig_if.mii_tx_c_lane_200g[2] ; 
                    mii_d[3] = eth_dut_sig_if.mii_tx_data_lane_200g[3] ; 
                    mii_c[3] = eth_dut_sig_if.mii_tx_c_lane_200g[3] ; 
                    mii_d[4] = eth_dut_sig_if.mii_tx_data_lane_200g[4] ; 
                    mii_c[4] = eth_dut_sig_if.mii_tx_c_lane_200g[4] ; 
                    mii_d[5] = eth_dut_sig_if.mii_tx_data_lane_200g[5] ; 
                    mii_c[5] = eth_dut_sig_if.mii_tx_c_lane_200g[5] ; 
                    mii_d[6] = eth_dut_sig_if.mii_tx_data_lane_200g[6] ; 
                    mii_c[6] = eth_dut_sig_if.mii_tx_c_lane_200g[6] ; 
                    mii_d[7] = eth_dut_sig_if.mii_tx_data_lane_200g[7] ; 
                    mii_c[7] = eth_dut_sig_if.mii_tx_c_lane_200g[7] ; 
		            am_valid = eth_dut_sig_if.mii_am_valid_200g ;
                    ipg_incr = 32; 
                 end
         _400G : begin 
                    @(negedge eth_dut_sig_if.tx_mii_i_clk_400g);
                    mii_valid = eth_dut_sig_if.mii_tx_valid_400g;
                    mii_d[0] = eth_dut_sig_if.mii_tx_data_lane_400g[0] ; 
                    mii_c[0] = eth_dut_sig_if.mii_tx_c_lane_400g[0] ; 
                    mii_d[1] = eth_dut_sig_if.mii_tx_data_lane_400g[1] ; 
                    mii_c[1] = eth_dut_sig_if.mii_tx_c_lane_400g[1] ; 
                    mii_d[2] = eth_dut_sig_if.mii_tx_data_lane_400g[2] ; 
                    mii_c[2] = eth_dut_sig_if.mii_tx_c_lane_400g[2] ; 
                    mii_d[3] = eth_dut_sig_if.mii_tx_data_lane_400g[3] ; 
                    mii_c[3] = eth_dut_sig_if.mii_tx_c_lane_400g[3] ; 
                    mii_d[4] = eth_dut_sig_if.mii_tx_data_lane_400g[4] ; 
                    mii_c[4] = eth_dut_sig_if.mii_tx_c_lane_400g[4] ; 
                    mii_d[5] = eth_dut_sig_if.mii_tx_data_lane_400g[5] ; 
                    mii_c[5] = eth_dut_sig_if.mii_tx_c_lane_400g[5] ; 
                    mii_d[6] = eth_dut_sig_if.mii_tx_data_lane_400g[6] ; 
                    mii_c[6] = eth_dut_sig_if.mii_tx_c_lane_400g[6] ; 
                    mii_d[7] = eth_dut_sig_if.mii_tx_data_lane_400g[7] ; 
                    mii_c[7] = eth_dut_sig_if.mii_tx_c_lane_400g[7] ; 
                    mii_d[8] = eth_dut_sig_if.mii_tx_data_lane_400g[8] ; 
                    mii_c[8] = eth_dut_sig_if.mii_tx_c_lane_400g[8] ; 
                    mii_d[9] = eth_dut_sig_if.mii_tx_data_lane_400g[9] ; 
                    mii_c[9] = eth_dut_sig_if.mii_tx_c_lane_400g[9] ; 
                    mii_d[10] = eth_dut_sig_if.mii_tx_data_lane_400g[10] ; 
                    mii_c[10] = eth_dut_sig_if.mii_tx_c_lane_400g[10] ; 
                    mii_d[11] = eth_dut_sig_if.mii_tx_data_lane_400g[11] ; 
                    mii_c[11] = eth_dut_sig_if.mii_tx_c_lane_400g[11] ; 
                    mii_d[12] = eth_dut_sig_if.mii_tx_data_lane_400g[12] ; 
                    mii_c[12] = eth_dut_sig_if.mii_tx_c_lane_400g[12] ; 
                    mii_d[13] = eth_dut_sig_if.mii_tx_data_lane_400g[13] ; 
                    mii_c[13] = eth_dut_sig_if.mii_tx_c_lane_400g[13] ; 
                    mii_d[14] = eth_dut_sig_if.mii_tx_data_lane_400g[14] ; 
                    mii_c[14] = eth_dut_sig_if.mii_tx_c_lane_400g[14] ; 
                    mii_d[15] = eth_dut_sig_if.mii_tx_data_lane_400g[15] ; 
                    mii_c[15] = eth_dut_sig_if.mii_tx_c_lane_400g[15] ; 
		            am_valid = eth_dut_sig_if.mii_am_valid_400g ;
                    ipg_incr = 64; 
                 end
         endcase 
         if(ipg_check_enable) begin
           if(!mii_valid)
		     begin
             if(start_check_en) begin 
                // non valid transaction does not counted as IPG 
               //  o_ipg_bytes = o_ipg_bytes + ipg_incr; // 1 Clock 32 idles bytes
                // o_am_idle_bytes = o_am_idle_bytes + ipg_incr ;
                // o_avg_ipg   = o_total_ipg/o_num_of_gaps;
                // o_num_of_gaps_on_am = o_num_of_gaps;
               `uvm_info(get_type_name(), $sformatf("IPG Checker: o_num_of_gaps:%0d o_total_ipg:%0d o_avg_ipg:%0f o_num_of_gaps_on_am:%0d",o_num_of_gaps,o_total_ipg,o_avg_ipg,o_num_of_gaps_on_am),UVM_HIGH)
             end
             prev_valid_am = first_valid_am;
           end
           else begin
             case (dyn_rcfg_obj_inst.speed)
             _10G: begin
                      `uvm_info(get_type_name(), $sformatf("33 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                      if(!o_sop_found) begin
                        o_sop_found = search_sop(mii_c[0],mii_d[0]);
                      end
                      else begin
                        o_eop_found = search_eop(mii_c[0],mii_d[0]);
                        o_sop_found = ! o_eop_found;
                      end
                   end
             _25G: begin
                     `uvm_info(get_type_name(), $sformatf("33 output 25g o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                        if(!o_sop_found) begin
                          o_sop_found = search_sop(mii_c[0],mii_d[0]);
                       end
                       else begin
                          o_eop_found = search_eop(mii_c[0],mii_d[0]);
                          o_sop_found = ! o_eop_found;
                        end
		     end
             _40G: begin
                      `uvm_info(get_type_name(), $sformatf("33 100 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                      for(int i =0; i<=3;i++) begin
                        automatic int j = i;
                        if(!o_sop_found) begin
                          o_sop_found = search_sop(mii_c[j],mii_d[j]);
                        end
                        else begin
                          o_eop_found = search_eop(mii_c[j],mii_d[j]);
                          o_sop_found = ! o_eop_found;
                        end
                      end
                   end
             _50G: begin
                      `uvm_info(get_type_name(), $sformatf("33 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                      for(int i =0; i<=1;i++) begin
                        automatic int j = i;
                        if(!o_sop_found) begin
                          o_sop_found = search_sop(mii_c[j],mii_d[j]);
                        end
                        else begin
                          o_eop_found = search_eop(mii_c[j],mii_d[j]);
                          o_sop_found = ! o_eop_found;
                        end
                      end
                   end
             _100G: begin
                      `uvm_info(get_type_name(), $sformatf("33 100 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                      for(int i =0; i<=3;i++) begin
                        automatic int j = i;
                        if(!o_sop_found) begin
                          o_sop_found = search_sop(mii_c[j],mii_d[j]);
                        end
                        else begin
                          o_eop_found = search_eop(mii_c[j],mii_d[j]);
                          o_sop_found = ! o_eop_found;
                        end
                      end
                   end
             _200G: begin
                      `uvm_info(get_type_name(), $sformatf("33 200 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                      for(int i =0; i<=7;i++) begin
                        automatic int j = i;
                        if(!o_sop_found) begin
                          o_sop_found = search_sop(mii_c[j],mii_d[j]);
                        end
                        else begin
                          o_eop_found = search_eop(mii_c[j],mii_d[j]);
                          o_sop_found = ! o_eop_found;
                        end
                      end
                   end
             _400G: begin
                      `uvm_info(get_type_name(), $sformatf("33 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
                      for(int i =0; i<=15;i++) begin
                        automatic int j = i;
                        if(!o_sop_found) begin
                          o_sop_found = search_sop(mii_c[j],mii_d[j]);
                        end
                        else begin
                          o_eop_found = search_eop(mii_c[j],mii_d[j]);
                          o_sop_found = ! o_eop_found;
                        end
                      end
                   end
              endcase
             `uvm_info(get_type_name(), $sformatf("44 output o_ipg_bytes:%0d, IPG bytes:%0d o_total_ipg:%0d o_avg_ipg:%0d",o_ipg_bytes,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
           end

           if(o_ipg_bytes_q.size() != 0) begin
               start_check_en = 1;
               `uvm_info(get_type_name(), $sformatf("IPG Checker: Output frames:%0d IPG bytes:%0d	o_total_ipg:%0d	o_avg_ipg:%0d",o_num_frames,o_ipg_bytes_frame,o_total_ipg,o_avg_ipg),UVM_HIGH)
               `uvm_info(get_type_name(), $sformatf("drv_ipg_bytes:%0d  sop_found:'b%b eop_found:'b%b first_frame:%0d\n",drv_ipg_bytes,sop_found,eop_found,first_frame), UVM_HIGH)
             o_num_frames ++;
             o_ipg_bytes_frame = 0;
             o_ipg_bytes_frame = o_ipg_bytes_q.pop_front();
             if(start_check_en) begin
               o_num_of_gaps =  o_num_of_gaps + 1;
               o_total_ipg = o_total_ipg + o_ipg_bytes_frame;
               `uvm_info(get_type_name(), $sformatf("IPG Checker: LOAD o_num_of_gaps:%0d o_ipg_bytes_frame:%0d	o_total_ipg:%0d",o_num_of_gaps,o_ipg_bytes_frame,o_total_ipg),UVM_MEDIUM)
             end
           end
         end // chk_enable
       end 
     end //fork
     join_none
   endtask //monitor_output_tx_mac_interface

// Function: search_sop
// Find the FB (SOP ) in data packet and once we get the fb at the mii interface 
// igone that 64 bit of data as Header is not considered as IPG. 

   function automatic bit search_sop(logic [3:0] ctrl, logic [31:0] data);
     bit sop_set= 0;
     bit discard_ipg= 0;
     int j;
       `uvm_info(get_type_name(), $sformatf("Called  SOP detect with mii_d: %0h, mii_c: %0h\n",data,ctrl), UVM_HIGH)

   foreach(ctrl[i])
     begin
       j = i*8;
	    if ((ctrl[i]) & (data[j +:8] == 'hfb)) 
          discard_ipg = 1'b1;  
     end  

     for(int k=0, l=0; k<4; k++) begin
       l = k*8;
       `uvm_info(get_type_name(), $sformatf("Checking  SOP detect with mii_d: %0h, mii_c: %0h\n",data[l +: 8],ctrl[k]), UVM_HIGH)
       if(ctrl[k] && data[l +: 8] == 'hfb) begin
         //`uvm_info(get_type_name(), $sformatf("sop is found on ctrl[%0d] data:%h\n", k, data[l +: 8]), UVM_NONE)
          sop_set = 1;
          am_count_en = 1'b0;  
           am_count =0;
       `uvm_info(get_type_name(), $sformatf("SOP detected \n"), UVM_MEDIUM)
         if(o_first_frame) begin
           eth_dut_sig_if.ipg_value = o_ipg_bytes;
           o_ipg_bytes_q.push_back(o_ipg_bytes);
           am_count2 = am_count2 + am_count1;
          `uvm_info(get_type_name(), $sformatf("loading IDLE bytes o_ipg_bytes %d am_count %0d\n",o_ipg_bytes,am_count2), UVM_LOW)
         end
         o_ipg_bytes = 0;
         am_count1 = 0;
         o_first_frame = 1;
         return(sop_set);
       end
       else begin
         if((!discard_ipg) & o_first_frame) o_ipg_bytes ++ ;
          `uvm_info(get_type_name(), $sformatf("Checking  EOP detect with mii_valid:%0h, am_valid:%0h,mii_d: %0h,mii_c :%0h, am_count_en: %0h,am_count =%d  o_first_frame: %0h\n",mii_valid,am_valid, data[l +: 8],ctrl[3:0],am_count_en,am_count,o_first_frame), UVM_LOW)
	 if (am_count_en && mii_valid && (ctrl[3:0]=='hf) && am_valid) begin
	    am_count=1; 
	    $display("AM at idles seen");
         end
          `uvm_info(get_type_name(), $sformatf("incrementing IDLE bytes SOP 2 o_ipg_bytes %0d am_count %d \n", o_ipg_bytes,am_count), UVM_LOW)
       end
     end
     if (am_count) begin
       am_count1=am_count1+1;
     end
     `uvm_info(get_type_name(), $sformatf("am_count2 is %0d am_count %d, am_count1 %d",am_count2,am_count,am_count1),UVM_LOW);
     return(sop_set);
   endfunction

// Function: search_eop
// Find the FD (EOP )as the end of data packet, FD and remaing bytes in that 64 bits of mii data is considerred as IPG 

   function automatic bit search_eop(logic [3:0] ctrl, logic [31:0] data);
     bit eop_set= 0;
       `uvm_info(get_type_name(), $sformatf("Called  EOP detect with mii_d: %0h, mii_c: %0h\n",data,ctrl), UVM_HIGH)
     for(int k=0,l=0; k<=3; k++) begin
       l = k*8;
       `uvm_info(get_type_name(), $sformatf("Checking  EOP detect with mii_d: %0h, mii_c: %0h\n",data[l +: 8],ctrl[k]), UVM_HIGH)
       if(eop_set == 0 && ctrl[k] && (data[l +: 8] == 'hfd || data[l +: 8] == 'hfe)) begin
       //`uvm_info(get_type_name(), $sformatf("eop is found on ctrl[%0d] data:%h\n", k, data[l +: 8]), UVM_NONE)
        //return(1);
         eop_set = 1;
         am_count_en = 1'b1;
         `uvm_info(get_type_name(), $sformatf("EOP detected \n"), UVM_MEDIUM)
       end
       if(eop_set) begin
         o_ipg_bytes ++ ;
         `uvm_info(get_type_name(), $sformatf("incrementing IDLE bytes EOP 2 o_ipg_bytes %0d \n", o_ipg_bytes), UVM_MEDIUM)
	//chethan     if (mii_valid && (ctrl[3:0]=='hf) && am_valid) begin
	//chethan          am_count=1;
	//chethan          $display("AM at idles seen");
        //chethan  end
       end
     end //for
      //chethan if (am_count) begin
      //chethan   am_count2=am_count2+1;
      //chethan end
     `uvm_info(get_type_name(), $sformatf("am_count2 is %0d",am_count2),UVM_MEDIUM);
     //return(0);
     return(eop_set);
   endfunction


   function void check_phase(uvm_phase phase);
     real wins_size;
     super.check_phase(phase);
     //if(ipg_check_enable) begin
      // Read IPG configuration
      //avg_ipg = 32'd12 ; //regs.get_mirrored_value();
      //ll_TODO: remove tx_avg_ipg = gdr_ral_get("mac_cfg_txmac_ehip_cfg","ipg");
     if(dyn_rcfg_obj_inst.ll_speed inside {_1G,_100M,_10M}) begin
        tx_avg_ipg = gdr_ral_get("tx_ipg_10M_100M_1G","ipg_10M_100M_1g");
        avg_ipg = tx_avg_ipg; //ll_TODO: recheck the values
     end else begin
        tx_avg_ipg = gdr_ral_get("tx_ipg_10g","avg_ipg_10g");
        case (tx_avg_ipg)
          0: avg_ipg = 8;
          1: avg_ipg = 12;
        endcase  
     end
      `uvm_info(get_full_name(), $sformatf("Configured IPG value = %0d",avg_ipg), UVM_NONE)
      ipg_col_rem = 0;
      //ll_TODO: remove ipg_col_rem = gdr_ral_get("mac_cfg_ipg_col_rem","ipg_col_rem");
      //ll_TODO: remove case (dyn_rcfg_obj_inst.speed)
      //ll_TODO: remove   _25G  : ipg_rem = 8;
      //ll_TODO: remove   _40G  : ipg_rem = 4;
      //ll_TODO: remove   _50G  : ipg_rem = 4;
      //ll_TODO: remove   _100G : ipg_rem = 20;
      //ll_TODO: remove   _200G : ipg_rem = 16;
      //ll_TODO: remove   _400G : ipg_rem = 32;
      //ll_TODO: remove endcase

       if(ipg_check_enable)
        begin
          `uvm_info(get_type_name(), $sformatf("Configured ipg_col_rem = %0d, ipg_rem value = %0d, am_count=%0d",ipg_col_rem,ipg_rem,am_count2),UVM_MEDIUM);
          `uvm_info(get_type_name(), $sformatf("Total IPG value:%0d number of gaps :%0d",o_total_ipg,o_num_of_gaps), UVM_NONE)
           // chethan o_avg_ipg = (o_total_ipg-(am_count2*ipg_col_rem*ipg_rem)) / (o_num_of_gaps);
           o_avg_ipg = (o_total_ipg-((am_count2*ipg_col_rem)+ipg_rem)) / (o_num_of_gaps);
           if(additional_ipg_enb) wins_size=1.2; else wins_size=0.5;  //Note: Enhancement is required for additional_ipg.
           if(o_avg_ipg < (avg_ipg - wins_size) || o_avg_ipg > (avg_ipg + 0.5)) begin
//             `uvm_error(get_type_name(), $sformatf("Avg IPG is not near to configured value. Configured value:%0d output Avg ipg:%0.2f",avg_ipg,o_avg_ipg))
             `uvm_error(get_type_name(), $sformatf("Avg IPG is not near to configured value. Configured value:%0d output Avg ipg:%f",avg_ipg,o_avg_ipg))
           end
           else begin
             `uvm_info(get_type_name(), $sformatf("Avg IPG is near to configured value. Configured value:%0d output Avg ipg:%f",avg_ipg,o_avg_ipg), UVM_NONE)
           end
         end
   endfunction


endclass : eth_ipg_checker

`endif // __ETH_IPG_CHECKER__
