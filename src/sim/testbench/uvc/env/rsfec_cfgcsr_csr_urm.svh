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


/*----------------------------------------------------------------------------------------------------
--- Generated with Magillem Design Services S.A UVM generator.
--- MRV generator version : 0.1
--- Date :Thu Apr 19 14:53:49 PDT 2018
----------------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------------------------
--- UVM Register Model
--- Component Name: rsfec_cfgcsr_csr
--- File Ref: /data/karlche1/crete3eRDL/rsfec_cfgcsr_csr_csrgen_output/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_rsfec_cfgcsr_csr_1.0.xml
--- Magillem Version :   5.11.2.1
----------------------------------------------------------------------------------------------------*/

`ifndef __RSFEC_CFGCSR_CSR_URM_SVH__
`define __RSFEC_CFGCSR_CSR_URM_SVH__


/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm  )

      rand uvm_reg_field arbiter_base;
      rand uvm_reg_field usr_code;
      rand uvm_reg_field usr_key;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          arbiter_base_value : coverpoint arbiter_base.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          usr_code_value : coverpoint usr_code.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          usr_key_value : coverpoint usr_key.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         arbiter_base = uvm_reg_field::type_id::create("arbiter_base");
         // configure
         arbiter_base.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         usr_code = uvm_reg_field::type_id::create("usr_code");
         // configure
         usr_code.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         usr_key = uvm_reg_field::type_id::create("usr_key");
         // configure
         usr_key.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm  )

      rand uvm_reg_field rsfec_clk_sel;
      rand uvm_reg_field fec_lane_ena;
      rand uvm_reg_field clk_gating_dis;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rsfec_clk_sel_value : coverpoint rsfec_clk_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          fec_lane_ena_value : coverpoint fec_lane_ena.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          clk_gating_dis_value : coverpoint clk_gating_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rsfec_clk_sel = uvm_reg_field::type_id::create("rsfec_clk_sel");
         // configure
         rsfec_clk_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_lane_ena = uvm_reg_field::type_id::create("fec_lane_ena");
         // configure
         fec_lane_ena.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b1111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         clk_gating_dis = uvm_reg_field::type_id::create("clk_gating_dis");
         // configure
         clk_gating_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm  )

      rand uvm_reg_field core_tx_in_sel0;
      rand uvm_reg_field core_tx_in_sel1;
      rand uvm_reg_field core_tx_in_sel2;
      rand uvm_reg_field core_tx_in_sel3;
      rand uvm_reg_field core_tx_pcs_bypass;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          core_tx_in_sel0_value : coverpoint core_tx_in_sel0.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          core_tx_in_sel1_value : coverpoint core_tx_in_sel1.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          core_tx_in_sel2_value : coverpoint core_tx_in_sel2.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          core_tx_in_sel3_value : coverpoint core_tx_in_sel3.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          core_tx_pcs_bypass_value : coverpoint core_tx_pcs_bypass.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         core_tx_in_sel0 = uvm_reg_field::type_id::create("core_tx_in_sel0");
         // configure
         core_tx_in_sel0.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_tx_in_sel1 = uvm_reg_field::type_id::create("core_tx_in_sel1");
         // configure
         core_tx_in_sel1.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_tx_in_sel2 = uvm_reg_field::type_id::create("core_tx_in_sel2");
         // configure
         core_tx_in_sel2.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_tx_in_sel3 = uvm_reg_field::type_id::create("core_tx_in_sel3");
         // configure
         core_tx_in_sel3.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_tx_pcs_bypass = uvm_reg_field::type_id::create("core_tx_pcs_bypass");
         // configure
         core_tx_pcs_bypass.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm  )

      rand uvm_reg_field core_rx_out_sel0;
      rand uvm_reg_field core_rx_out_sel1;
      rand uvm_reg_field core_rx_out_sel2;
      rand uvm_reg_field core_rx_out_sel3;
      rand uvm_reg_field loopback_tx2rx;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          core_rx_out_sel0_value : coverpoint core_rx_out_sel0.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          core_rx_out_sel1_value : coverpoint core_rx_out_sel1.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          core_rx_out_sel2_value : coverpoint core_rx_out_sel2.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          core_rx_out_sel3_value : coverpoint core_rx_out_sel3.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          loopback_tx2rx_value : coverpoint loopback_tx2rx.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         core_rx_out_sel0 = uvm_reg_field::type_id::create("core_rx_out_sel0");
         // configure
         core_rx_out_sel0.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_rx_out_sel1 = uvm_reg_field::type_id::create("core_rx_out_sel1");
         // configure
         core_rx_out_sel1.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_rx_out_sel2 = uvm_reg_field::type_id::create("core_rx_out_sel2");
         // configure
         core_rx_out_sel2.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         core_rx_out_sel3 = uvm_reg_field::type_id::create("core_rx_out_sel3");
         // configure
         core_rx_out_sel3.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         loopback_tx2rx = uvm_reg_field::type_id::create("loopback_tx2rx");
         // configure
         loopback_tx2rx.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm  )

      rand uvm_reg_field testbus_sel;
      rand uvm_reg_field force_tx_pld_deskew_done;
      rand uvm_reg_field force_fec_ready;
      rand uvm_reg_field spare_bits;
      rand uvm_reg_field hwcfg_mode;
      rand uvm_reg_field hwcfg_ena;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          testbus_sel_value : coverpoint testbus_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          force_tx_pld_deskew_done_value : coverpoint force_tx_pld_deskew_done.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          force_fec_ready_value : coverpoint force_fec_ready.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          spare_bits_value : coverpoint spare_bits.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          hwcfg_mode_value : coverpoint hwcfg_mode.value {
             bins all[8] = {[15'h0:15'h7fff]};
             illegal_bins bad = default;
          }
          hwcfg_ena_value : coverpoint hwcfg_ena.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         testbus_sel = uvm_reg_field::type_id::create("testbus_sel");
         // configure
         testbus_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         force_tx_pld_deskew_done = uvm_reg_field::type_id::create("force_tx_pld_deskew_done");
         // configure
         force_tx_pld_deskew_done.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         force_fec_ready = uvm_reg_field::type_id::create("force_fec_ready");
         // configure
         force_fec_ready.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         spare_bits = uvm_reg_field::type_id::create("spare_bits");
         // configure
         spare_bits.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hwcfg_mode = uvm_reg_field::type_id::create("hwcfg_mode");
         // configure
         hwcfg_mode.configure(
         .parent                 ( this ),
         .size                   (15),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (15'b000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hwcfg_ena = uvm_reg_field::type_id::create("hwcfg_ena");
         // configure
         hwcfg_ena.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm  )

      rand uvm_reg_field tx_deskew_chan_sel;
      rand uvm_reg_field tx_deskew_clear;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          tx_deskew_chan_sel_value : coverpoint tx_deskew_chan_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          tx_deskew_clear_value : coverpoint tx_deskew_clear.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         tx_deskew_chan_sel = uvm_reg_field::type_id::create("tx_deskew_chan_sel");
         // configure
         tx_deskew_chan_sel.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_deskew_clear = uvm_reg_field::type_id::create("tx_deskew_clear");
         // configure
         tx_deskew_clear.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_top_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_top_status_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_top_status_urm  )

      rand uvm_reg_field avmm_timeout;
      rand uvm_reg_field spare_hold;
      rand uvm_reg_field clock_active;
      rand uvm_reg_field spare_stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          avmm_timeout_value : coverpoint avmm_timeout.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          spare_hold_value : coverpoint spare_hold.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          clock_active_value : coverpoint clock_active.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          spare_stat_value : coverpoint spare_stat.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_top_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         avmm_timeout = uvm_reg_field::type_id::create("avmm_timeout");
         // configure
         avmm_timeout.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         spare_hold = uvm_reg_field::type_id::create("spare_hold");
         // configure
         spare_hold.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         clock_active = uvm_reg_field::type_id::create("clock_active");
         // configure
         clock_active.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         spare_stat = uvm_reg_field::type_id::create("spare_stat");
         // configure
         spare_stat.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (4'bxxxx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_top_status_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_core_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_core_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_core_cfg_urm  )

      rand uvm_reg_field frac;
      rand uvm_reg_field eng_2lane_en;
      rand uvm_reg_field eng_enter_align;
      rand uvm_reg_field eng_exit_align;
      rand uvm_reg_field eng_test;
      
      typedef enum bit [1:0] {
      none = 2'h0,
      reserved1 = 2'h1,
      reserved2 = 2'h2,
      frac4 = 2'h3
       }  frac_enum;
       
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          frac_value : coverpoint frac.value {
             bins none = {none };
             bins reserved1 = {reserved1 };
             bins reserved2 = {reserved2 };
             bins frac4 = {frac4 };
             illegal_bins bad = default;
          }
          eng_2lane_en_value : coverpoint eng_2lane_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_enter_align_value : coverpoint eng_enter_align.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_exit_align_value : coverpoint eng_exit_align.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_test_value : coverpoint eng_test.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_core_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         frac = uvm_reg_field::type_id::create("frac");
         // configure
         frac.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_2lane_en = uvm_reg_field::type_id::create("eng_2lane_en");
         // configure
         eng_2lane_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_enter_align = uvm_reg_field::type_id::create("eng_enter_align");
         // configure
         eng_enter_align.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_exit_align = uvm_reg_field::type_id::create("eng_exit_align");
         // configure
         eng_exit_align.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_test = uvm_reg_field::type_id::create("eng_test");
         // configure
         eng_test.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_core_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg_urm  )

      rand uvm_reg_field fc;
      rand uvm_reg_field scr;
      rand uvm_reg_field indic_byp;
      rand uvm_reg_field rs544;
      rand uvm_reg_field eng_trans_byp;
      rand uvm_reg_field eng_sf_dis;
      rand uvm_reg_field eng_fec_3bad_dis;
      rand uvm_reg_field eng_am_5bad_dis;
      rand uvm_reg_field eng_blk_chk_dis;
      rand uvm_reg_field eng_swaps;
      rand uvm_reg_field eng_cons_25g;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fc_value : coverpoint fc.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          scr_value : coverpoint scr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          indic_byp_value : coverpoint indic_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rs544_value : coverpoint rs544.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_trans_byp_value : coverpoint eng_trans_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_sf_dis_value : coverpoint eng_sf_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_fec_3bad_dis_value : coverpoint eng_fec_3bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_am_5bad_dis_value : coverpoint eng_am_5bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_blk_chk_dis_value : coverpoint eng_blk_chk_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_swaps_value : coverpoint eng_swaps.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cons_25g_value : coverpoint eng_cons_25g.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fc = uvm_reg_field::type_id::create("fc");
         // configure
         fc.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         scr = uvm_reg_field::type_id::create("scr");
         // configure
         scr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         indic_byp = uvm_reg_field::type_id::create("indic_byp");
         // configure
         indic_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rs544 = uvm_reg_field::type_id::create("rs544");
         // configure
         rs544.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_trans_byp = uvm_reg_field::type_id::create("eng_trans_byp");
         // configure
         eng_trans_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_sf_dis = uvm_reg_field::type_id::create("eng_sf_dis");
         // configure
         eng_sf_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_fec_3bad_dis = uvm_reg_field::type_id::create("eng_fec_3bad_dis");
         // configure
         eng_fec_3bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_am_5bad_dis = uvm_reg_field::type_id::create("eng_am_5bad_dis");
         // configure
         eng_am_5bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_blk_chk_dis = uvm_reg_field::type_id::create("eng_blk_chk_dis");
         // configure
         eng_blk_chk_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_swaps = uvm_reg_field::type_id::create("eng_swaps");
         // configure
         eng_swaps.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cons_25g = uvm_reg_field::type_id::create("eng_cons_25g");
         // configure
         eng_cons_25g.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm  )

      rand uvm_reg_field fc;
      rand uvm_reg_field scr;
      rand uvm_reg_field indic_byp;
      rand uvm_reg_field rs544;
      rand uvm_reg_field eng_trans_byp;
      rand uvm_reg_field eng_sf_dis;
      rand uvm_reg_field eng_fec_3bad_dis;
      rand uvm_reg_field eng_am_5bad_dis;
      rand uvm_reg_field eng_blk_chk_dis;
      rand uvm_reg_field eng_swaps;
      rand uvm_reg_field eng_cons_25g;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fc_value : coverpoint fc.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          scr_value : coverpoint scr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          indic_byp_value : coverpoint indic_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rs544_value : coverpoint rs544.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_trans_byp_value : coverpoint eng_trans_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_sf_dis_value : coverpoint eng_sf_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_fec_3bad_dis_value : coverpoint eng_fec_3bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_am_5bad_dis_value : coverpoint eng_am_5bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_blk_chk_dis_value : coverpoint eng_blk_chk_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_swaps_value : coverpoint eng_swaps.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cons_25g_value : coverpoint eng_cons_25g.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fc = uvm_reg_field::type_id::create("fc");
         // configure
         fc.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         scr = uvm_reg_field::type_id::create("scr");
         // configure
         scr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         indic_byp = uvm_reg_field::type_id::create("indic_byp");
         // configure
         indic_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rs544 = uvm_reg_field::type_id::create("rs544");
         // configure
         rs544.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_trans_byp = uvm_reg_field::type_id::create("eng_trans_byp");
         // configure
         eng_trans_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_sf_dis = uvm_reg_field::type_id::create("eng_sf_dis");
         // configure
         eng_sf_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_fec_3bad_dis = uvm_reg_field::type_id::create("eng_fec_3bad_dis");
         // configure
         eng_fec_3bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_am_5bad_dis = uvm_reg_field::type_id::create("eng_am_5bad_dis");
         // configure
         eng_am_5bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_blk_chk_dis = uvm_reg_field::type_id::create("eng_blk_chk_dis");
         // configure
         eng_blk_chk_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_swaps = uvm_reg_field::type_id::create("eng_swaps");
         // configure
         eng_swaps.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cons_25g = uvm_reg_field::type_id::create("eng_cons_25g");
         // configure
         eng_cons_25g.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm  )

      rand uvm_reg_field fc;
      rand uvm_reg_field scr;
      rand uvm_reg_field indic_byp;
      rand uvm_reg_field rs544;
      rand uvm_reg_field eng_trans_byp;
      rand uvm_reg_field eng_sf_dis;
      rand uvm_reg_field eng_fec_3bad_dis;
      rand uvm_reg_field eng_am_5bad_dis;
      rand uvm_reg_field eng_blk_chk_dis;
      rand uvm_reg_field eng_swaps;
      rand uvm_reg_field eng_cons_25g;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fc_value : coverpoint fc.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          scr_value : coverpoint scr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          indic_byp_value : coverpoint indic_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rs544_value : coverpoint rs544.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_trans_byp_value : coverpoint eng_trans_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_sf_dis_value : coverpoint eng_sf_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_fec_3bad_dis_value : coverpoint eng_fec_3bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_am_5bad_dis_value : coverpoint eng_am_5bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_blk_chk_dis_value : coverpoint eng_blk_chk_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_swaps_value : coverpoint eng_swaps.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cons_25g_value : coverpoint eng_cons_25g.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fc = uvm_reg_field::type_id::create("fc");
         // configure
         fc.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         scr = uvm_reg_field::type_id::create("scr");
         // configure
         scr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         indic_byp = uvm_reg_field::type_id::create("indic_byp");
         // configure
         indic_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rs544 = uvm_reg_field::type_id::create("rs544");
         // configure
         rs544.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_trans_byp = uvm_reg_field::type_id::create("eng_trans_byp");
         // configure
         eng_trans_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_sf_dis = uvm_reg_field::type_id::create("eng_sf_dis");
         // configure
         eng_sf_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_fec_3bad_dis = uvm_reg_field::type_id::create("eng_fec_3bad_dis");
         // configure
         eng_fec_3bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_am_5bad_dis = uvm_reg_field::type_id::create("eng_am_5bad_dis");
         // configure
         eng_am_5bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_blk_chk_dis = uvm_reg_field::type_id::create("eng_blk_chk_dis");
         // configure
         eng_blk_chk_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_swaps = uvm_reg_field::type_id::create("eng_swaps");
         // configure
         eng_swaps.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cons_25g = uvm_reg_field::type_id::create("eng_cons_25g");
         // configure
         eng_cons_25g.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm  )

      rand uvm_reg_field fc;
      rand uvm_reg_field scr;
      rand uvm_reg_field indic_byp;
      rand uvm_reg_field rs544;
      rand uvm_reg_field eng_trans_byp;
      rand uvm_reg_field eng_sf_dis;
      rand uvm_reg_field eng_fec_3bad_dis;
      rand uvm_reg_field eng_am_5bad_dis;
      rand uvm_reg_field eng_blk_chk_dis;
      rand uvm_reg_field eng_swaps;
      rand uvm_reg_field eng_cons_25g;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fc_value : coverpoint fc.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          scr_value : coverpoint scr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          indic_byp_value : coverpoint indic_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rs544_value : coverpoint rs544.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_trans_byp_value : coverpoint eng_trans_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_sf_dis_value : coverpoint eng_sf_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_fec_3bad_dis_value : coverpoint eng_fec_3bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_am_5bad_dis_value : coverpoint eng_am_5bad_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_blk_chk_dis_value : coverpoint eng_blk_chk_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          eng_swaps_value : coverpoint eng_swaps.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cons_25g_value : coverpoint eng_cons_25g.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fc = uvm_reg_field::type_id::create("fc");
         // configure
         fc.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         scr = uvm_reg_field::type_id::create("scr");
         // configure
         scr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         indic_byp = uvm_reg_field::type_id::create("indic_byp");
         // configure
         indic_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rs544 = uvm_reg_field::type_id::create("rs544");
         // configure
         rs544.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_trans_byp = uvm_reg_field::type_id::create("eng_trans_byp");
         // configure
         eng_trans_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_sf_dis = uvm_reg_field::type_id::create("eng_sf_dis");
         // configure
         eng_sf_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_fec_3bad_dis = uvm_reg_field::type_id::create("eng_fec_3bad_dis");
         // configure
         eng_fec_3bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_am_5bad_dis = uvm_reg_field::type_id::create("eng_am_5bad_dis");
         // configure
         eng_am_5bad_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_blk_chk_dis = uvm_reg_field::type_id::create("eng_blk_chk_dis");
         // configure
         eng_blk_chk_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_swaps = uvm_reg_field::type_id::create("eng_swaps");
         // configure
         eng_swaps.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cons_25g = uvm_reg_field::type_id::create("eng_cons_25g");
         // configure
         eng_cons_25g.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm  )

      rand uvm_reg_field eng_cust_am_1st;
      rand uvm_reg_field eng_cust_log2_mrk;
      rand uvm_reg_field eng_cust_am_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_1st_value : coverpoint eng_cust_am_1st.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
          eng_cust_log2_mrk_value : coverpoint eng_cust_log2_mrk.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cust_am_en_value : coverpoint eng_cust_am_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_1st = uvm_reg_field::type_id::create("eng_cust_am_1st");
         // configure
         eng_cust_am_1st.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_log2_mrk = uvm_reg_field::type_id::create("eng_cust_log2_mrk");
         // configure
         eng_cust_log2_mrk.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_am_en = uvm_reg_field::type_id::create("eng_cust_am_en");
         // configure
         eng_cust_am_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm  )

      rand uvm_reg_field eng_cust_am_1st;
      rand uvm_reg_field eng_cust_log2_mrk;
      rand uvm_reg_field eng_cust_am_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_1st_value : coverpoint eng_cust_am_1st.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
          eng_cust_log2_mrk_value : coverpoint eng_cust_log2_mrk.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cust_am_en_value : coverpoint eng_cust_am_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_1st = uvm_reg_field::type_id::create("eng_cust_am_1st");
         // configure
         eng_cust_am_1st.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_log2_mrk = uvm_reg_field::type_id::create("eng_cust_log2_mrk");
         // configure
         eng_cust_log2_mrk.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_am_en = uvm_reg_field::type_id::create("eng_cust_am_en");
         // configure
         eng_cust_am_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm  )

      rand uvm_reg_field eng_cust_am_1st;
      rand uvm_reg_field eng_cust_log2_mrk;
      rand uvm_reg_field eng_cust_am_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_1st_value : coverpoint eng_cust_am_1st.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
          eng_cust_log2_mrk_value : coverpoint eng_cust_log2_mrk.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cust_am_en_value : coverpoint eng_cust_am_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_1st = uvm_reg_field::type_id::create("eng_cust_am_1st");
         // configure
         eng_cust_am_1st.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_log2_mrk = uvm_reg_field::type_id::create("eng_cust_log2_mrk");
         // configure
         eng_cust_log2_mrk.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_am_en = uvm_reg_field::type_id::create("eng_cust_am_en");
         // configure
         eng_cust_am_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm  )

      rand uvm_reg_field eng_cust_am_1st;
      rand uvm_reg_field eng_cust_log2_mrk;
      rand uvm_reg_field eng_cust_am_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_1st_value : coverpoint eng_cust_am_1st.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
          eng_cust_log2_mrk_value : coverpoint eng_cust_log2_mrk.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          eng_cust_am_en_value : coverpoint eng_cust_am_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_1st = uvm_reg_field::type_id::create("eng_cust_am_1st");
         // configure
         eng_cust_am_1st.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_log2_mrk = uvm_reg_field::type_id::create("eng_cust_log2_mrk");
         // configure
         eng_cust_log2_mrk.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         eng_cust_am_en = uvm_reg_field::type_id::create("eng_cust_am_en");
         // configure
         eng_cust_am_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm  )

      rand uvm_reg_field eng_cust_am_2nd;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_2nd_value : coverpoint eng_cust_am_2nd.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_2nd = uvm_reg_field::type_id::create("eng_cust_am_2nd");
         // configure
         eng_cust_am_2nd.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm  )

      rand uvm_reg_field eng_cust_am_2nd;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_2nd_value : coverpoint eng_cust_am_2nd.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_2nd = uvm_reg_field::type_id::create("eng_cust_am_2nd");
         // configure
         eng_cust_am_2nd.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm  )

      rand uvm_reg_field eng_cust_am_2nd;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_2nd_value : coverpoint eng_cust_am_2nd.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_2nd = uvm_reg_field::type_id::create("eng_cust_am_2nd");
         // configure
         eng_cust_am_2nd.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm  )

      rand uvm_reg_field eng_cust_am_2nd;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eng_cust_am_2nd_value : coverpoint eng_cust_am_2nd.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eng_cust_am_2nd = uvm_reg_field::type_id::create("eng_cust_am_2nd");
         // configure
         eng_cust_am_2nd.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_core_dft_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_core_dft_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_core_dft_cfg_urm  )

      rand uvm_reg_field pbist;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          pbist_value : coverpoint pbist.value {
             bins all[8] = {[22'h0:22'h3fffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_core_dft_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         pbist = uvm_reg_field::type_id::create("pbist");
         // configure
         pbist.configure(
         .parent                 ( this ),
         .size                   (22),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (22'b0000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_core_dft_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_misc_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_misc_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_misc_cfg_urm  )

      rand uvm_reg_field clk_present_period;
      rand uvm_reg_field avmm_timeout_control;
      rand uvm_reg_field disable_timeout_response;
      rand uvm_reg_field disable_timeout_reset;
      rand uvm_reg_field reset_async_intf;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          clk_present_period_value : coverpoint clk_present_period.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          avmm_timeout_control_value : coverpoint avmm_timeout_control.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          disable_timeout_response_value : coverpoint disable_timeout_response.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          disable_timeout_reset_value : coverpoint disable_timeout_reset.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reset_async_intf_value : coverpoint reset_async_intf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_misc_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         clk_present_period = uvm_reg_field::type_id::create("clk_present_period");
         // configure
         clk_present_period.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         avmm_timeout_control = uvm_reg_field::type_id::create("avmm_timeout_control");
         // configure
         avmm_timeout_control.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         disable_timeout_response = uvm_reg_field::type_id::create("disable_timeout_response");
         // configure
         disable_timeout_response.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         disable_timeout_reset = uvm_reg_field::type_id::create("disable_timeout_reset");
         // configure
         disable_timeout_reset.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (10),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reset_async_intf = uvm_reg_field::type_id::create("reset_async_intf");
         // configure
         reset_async_intf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_misc_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm  )

      rand uvm_reg_field tx_dsk_eval_done;
      rand uvm_reg_field tx_dsk_status;
      rand uvm_reg_field tx_dsk_monitor_err;
      rand uvm_reg_field tx_dsk_active_chans;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          tx_dsk_eval_done_value : coverpoint tx_dsk_eval_done.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_dsk_status_value : coverpoint tx_dsk_status.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          tx_dsk_monitor_err_value : coverpoint tx_dsk_monitor_err.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          tx_dsk_active_chans_value : coverpoint tx_dsk_active_chans.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         tx_dsk_eval_done = uvm_reg_field::type_id::create("tx_dsk_eval_done");
         // configure
         tx_dsk_eval_done.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_dsk_status = uvm_reg_field::type_id::create("tx_dsk_status");
         // configure
         tx_dsk_status.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_dsk_monitor_err = uvm_reg_field::type_id::create("tx_dsk_monitor_err");
         // configure
         tx_dsk_monitor_err.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (4),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_dsk_active_chans = uvm_reg_field::type_id::create("tx_dsk_active_chans");
         // configure
         tx_dsk_active_chans.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_reg_core_debug_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_reg_core_debug_cfg_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_reg_core_debug_cfg_urm  )

      rand uvm_reg_field shadow_req;
      rand uvm_reg_field shadow_clear;
      rand uvm_reg_field spare_bits;
      rand uvm_reg_field tx_rst;
      rand uvm_reg_field rx_rst;
      rand uvm_reg_field main_rst;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          shadow_req_value : coverpoint shadow_req.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          shadow_clear_value : coverpoint shadow_clear.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          spare_bits_value : coverpoint spare_bits.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          tx_rst_value : coverpoint tx_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_rst_value : coverpoint rx_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          main_rst_value : coverpoint main_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_reg_core_debug_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         shadow_req = uvm_reg_field::type_id::create("shadow_req");
         // configure
         shadow_req.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         shadow_clear = uvm_reg_field::type_id::create("shadow_clear");
         // configure
         shadow_clear.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         spare_bits = uvm_reg_field::type_id::create("spare_bits");
         // configure
         spare_bits.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_rst = uvm_reg_field::type_id::create("tx_rst");
         // configure
         tx_rst.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_rst = uvm_reg_field::type_id::create("rx_rst");
         // configure
         rx_rst.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         main_rst = uvm_reg_field::type_id::create("main_rst");
         // configure
         main_rst.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_reg_core_debug_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm  )

      rand uvm_reg_field hdr_inv;
      rand uvm_reg_field blk_inv;
      rand uvm_reg_field resync;
      rand uvm_reg_field pace_inv;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          hdr_inv_value : coverpoint hdr_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          blk_inv_value : coverpoint blk_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          resync_value : coverpoint resync.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pace_inv_value : coverpoint pace_inv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         hdr_inv = uvm_reg_field::type_id::create("hdr_inv");
         // configure
         hdr_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         blk_inv = uvm_reg_field::type_id::create("blk_inv");
         // configure
         blk_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         resync = uvm_reg_field::type_id::create("resync");
         // configure
         resync.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pace_inv = uvm_reg_field::type_id::create("pace_inv");
         // configure
         pace_inv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'bx),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm  )

      rand uvm_reg_field sf;
      rand uvm_reg_field not_locked;
      rand uvm_reg_field fec_3bad;
      rand uvm_reg_field am_5bad;
      rand uvm_reg_field hi_ser;
      rand uvm_reg_field corr_cw;
      rand uvm_reg_field uncorr_cw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sf_value : coverpoint sf.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_locked_value : coverpoint not_locked.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fec_3bad_value : coverpoint fec_3bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          am_5bad_value : coverpoint am_5bad.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ser_value : coverpoint hi_ser.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          corr_cw_value : coverpoint corr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          uncorr_cw_value : coverpoint uncorr_cw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sf = uvm_reg_field::type_id::create("sf");
         // configure
         sf.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_locked = uvm_reg_field::type_id::create("not_locked");
         // configure
         not_locked.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fec_3bad = uvm_reg_field::type_id::create("fec_3bad");
         // configure
         fec_3bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         am_5bad = uvm_reg_field::type_id::create("am_5bad");
         // configure
         am_5bad.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hi_ser = uvm_reg_field::type_id::create("hi_ser");
         // configure
         hi_ser.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         corr_cw = uvm_reg_field::type_id::create("corr_cw");
         // configure
         corr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         uncorr_cw = uvm_reg_field::type_id::create("uncorr_cw");
         // configure
         uncorr_cw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm  )

      rand uvm_reg_field not_align;
      rand uvm_reg_field not_deskew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          not_align_value : coverpoint not_align.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_deskew_value : coverpoint not_deskew.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         not_align = uvm_reg_field::type_id::create("not_align");
         // configure
         not_align.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_deskew = uvm_reg_field::type_id::create("not_deskew");
         // configure
         not_deskew.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm  )

      rand uvm_reg_field not_align;
      rand uvm_reg_field not_deskew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          not_align_value : coverpoint not_align.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_deskew_value : coverpoint not_deskew.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         not_align = uvm_reg_field::type_id::create("not_align");
         // configure
         not_align.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_deskew = uvm_reg_field::type_id::create("not_deskew");
         // configure
         not_deskew.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm  )

      rand uvm_reg_field not_align;
      rand uvm_reg_field not_deskew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          not_align_value : coverpoint not_align.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          not_deskew_value : coverpoint not_deskew.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         not_align = uvm_reg_field::type_id::create("not_align");
         // configure
         not_align.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         not_deskew = uvm_reg_field::type_id::create("not_deskew");
         // configure
         not_deskew.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm  )

      rand uvm_reg_field fec_lane;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fec_lane_value : coverpoint fec_lane.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fec_lane = uvm_reg_field::type_id::create("fec_lane");
         // configure
         fec_lane.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm  )

      rand uvm_reg_field fec_lane;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fec_lane_value : coverpoint fec_lane.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fec_lane = uvm_reg_field::type_id::create("fec_lane");
         // configure
         fec_lane.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm  )

      rand uvm_reg_field fec_lane;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fec_lane_value : coverpoint fec_lane.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fec_lane = uvm_reg_field::type_id::create("fec_lane");
         // configure
         fec_lane.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm  )

      rand uvm_reg_field fec_lane;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fec_lane_value : coverpoint fec_lane.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fec_lane = uvm_reg_field::type_id::create("fec_lane");
         // configure
         fec_lane.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm  )

      rand uvm_reg_field skew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          skew_value : coverpoint skew.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         skew = uvm_reg_field::type_id::create("skew");
         // configure
         skew.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (7'b0000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm  )

      rand uvm_reg_field skew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          skew_value : coverpoint skew.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         skew = uvm_reg_field::type_id::create("skew");
         // configure
         skew.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (7'b0000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm  )

      rand uvm_reg_field skew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          skew_value : coverpoint skew.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         skew = uvm_reg_field::type_id::create("skew");
         // configure
         skew.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (7'b0000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm  )

      rand uvm_reg_field skew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          skew_value : coverpoint skew.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         skew = uvm_reg_field::type_id::create("skew");
         // configure
         skew.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (7'b0000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm  )

      rand uvm_reg_field num;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          num_value : coverpoint num.value {
             bins all[8] = {[13'h0:13'h1fff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         num = uvm_reg_field::type_id::create("num");
         // configure
         num.configure(
         .parent                 ( this ),
         .size                   (13),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (13'b0000000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm  )

      rand uvm_reg_field num;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          num_value : coverpoint num.value {
             bins all[8] = {[13'h0:13'h1fff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         num = uvm_reg_field::type_id::create("num");
         // configure
         num.configure(
         .parent                 ( this ),
         .size                   (13),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (13'b0000000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm  )

      rand uvm_reg_field num;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          num_value : coverpoint num.value {
             bins all[8] = {[13'h0:13'h1fff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         num = uvm_reg_field::type_id::create("num");
         // configure
         num.configure(
         .parent                 ( this ),
         .size                   (13),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (13'b0000000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm  )

      rand uvm_reg_field num;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          num_value : coverpoint num.value {
             bins all[8] = {[13'h0:13'h1fff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         num = uvm_reg_field::type_id::create("num");
         // configure
         num.configure(
         .parent                 ( this ),
         .size                   (13),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (13'b0000000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm  )

      rand uvm_reg_field sbe;
      rand uvm_reg_field mbe;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sbe_value : coverpoint sbe.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          mbe_value : coverpoint mbe.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sbe = uvm_reg_field::type_id::create("sbe");
         // configure
         sbe.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         mbe = uvm_reg_field::type_id::create("mbe");
         // configure
         mbe.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm  )

      rand uvm_reg_field rate;
      rand uvm_reg_field pat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rate_value : coverpoint rate.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          pat_value : coverpoint pat.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rate = uvm_reg_field::type_id::create("rate");
         // configure
         rate.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pat = uvm_reg_field::type_id::create("pat");
         // configure
         pat.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm  )

      rand uvm_reg_field rate;
      rand uvm_reg_field pat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rate_value : coverpoint rate.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          pat_value : coverpoint pat.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rate = uvm_reg_field::type_id::create("rate");
         // configure
         rate.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pat = uvm_reg_field::type_id::create("pat");
         // configure
         pat.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm  )

      rand uvm_reg_field rate;
      rand uvm_reg_field pat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rate_value : coverpoint rate.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          pat_value : coverpoint pat.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rate = uvm_reg_field::type_id::create("rate");
         // configure
         rate.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pat = uvm_reg_field::type_id::create("pat");
         // configure
         pat.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm  )

      rand uvm_reg_field rate;
      rand uvm_reg_field pat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rate_value : coverpoint rate.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          pat_value : coverpoint pat.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rate = uvm_reg_field::type_id::create("rate");
         // configure
         rate.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pat = uvm_reg_field::type_id::create("pat");
         // configure
         pat.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_val_tx_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_val_tx_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_val_tx_urm  )

      rand uvm_reg_field inj0s;
      rand uvm_reg_field inj1s;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          inj0s_value : coverpoint inj0s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          inj1s_value : coverpoint inj1s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_val_tx_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         inj0s = uvm_reg_field::type_id::create("inj0s");
         // configure
         inj0s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         inj1s = uvm_reg_field::type_id::create("inj1s");
         // configure
         inj1s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_val_tx_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm  )

      rand uvm_reg_field inj0s;
      rand uvm_reg_field inj1s;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          inj0s_value : coverpoint inj0s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          inj1s_value : coverpoint inj1s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         inj0s = uvm_reg_field::type_id::create("inj0s");
         // configure
         inj0s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         inj1s = uvm_reg_field::type_id::create("inj1s");
         // configure
         inj1s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm  )

      rand uvm_reg_field inj0s;
      rand uvm_reg_field inj1s;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          inj0s_value : coverpoint inj0s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          inj1s_value : coverpoint inj1s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         inj0s = uvm_reg_field::type_id::create("inj0s");
         // configure
         inj0s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         inj1s = uvm_reg_field::type_id::create("inj1s");
         // configure
         inj1s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm  )

      rand uvm_reg_field inj0s;
      rand uvm_reg_field inj1s;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          inj0s_value : coverpoint inj0s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          inj1s_value : coverpoint inj1s.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         inj0s = uvm_reg_field::type_id::create("inj0s");
         // configure
         inj0s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         inj1s = uvm_reg_field::type_id::create("inj1s");
         // configure
         inj1s.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm

/*-----------------------------------------------------------------------------------------------
---  rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm  extends uvm_reg;

      `uvm_object_utils(rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm  )

      rand uvm_reg_field stat;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stat_value : coverpoint stat.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stat = uvm_reg_field::type_id::create("stat");
         // configure
         stat.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (32'b00000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm


/*-----------------------------------------------------------------------------------------------
--- rsfec_cfgcsr_csr Block Definition : 
-----------------------------------------------------------------------------------------------*/
class rsfec_cfgcsr_csr_urm  extends  uvm_reg_block;

       `uvm_object_utils(rsfec_cfgcsr_csr_urm  )

      rand rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm  arbiter_base_cfg;
      rand rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm  rsfec_top_clk_cfg;
      rand rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm  rsfec_top_tx_cfg;
      rand rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm  rsfec_top_rx_cfg;
      rand rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm  rsfec_top_eng_cfg;
      rand rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm  tx_aib_dsk_conf;
      rand rsfec_cfgcsr_csr_rsfec_top_status_urm  rsfec_status_hold;
      rand rsfec_cfgcsr_csr_rsfec_core_cfg_urm  rsfec_core_cfg;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg_urm  rsfec_lane_cfg_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm  rsfec_lane_cfg_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm  rsfec_lane_cfg_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm  rsfec_lane_cfg_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm  rsfec_lane_cfg1_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm  rsfec_lane_cfg1_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm  rsfec_lane_cfg1_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm  rsfec_lane_cfg1_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm  rsfec_lane_cfg2_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm  rsfec_lane_cfg2_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm  rsfec_lane_cfg2_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm  rsfec_lane_cfg2_3;
      rand rsfec_cfgcsr_csr_reg_core_dft_cfg_urm  rsfec_dft_cfg;
      rand rsfec_cfgcsr_csr_reg_misc_cfg_urm  rsfec_misc_cfg;
      rand rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm  tx_aib_dsk_status;
      rand rsfec_cfgcsr_csr_reg_core_debug_cfg_urm  rsfec_debug_cfg;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm  rsfec_lane_tx_stat_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm  rsfec_lane_tx_stat_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm  rsfec_lane_tx_stat_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm  rsfec_lane_tx_stat_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm  rsfec_lane_tx_hold_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm  rsfec_lane_tx_hold_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm  rsfec_lane_tx_hold_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm  rsfec_lane_tx_hold_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm  rsfec_lane_tx_inten_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm  rsfec_lane_tx_inten_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm  rsfec_lane_tx_inten_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm  rsfec_lane_tx_inten_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm  rsfec_lane_rx_stat_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm  rsfec_lane_rx_stat_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm  rsfec_lane_rx_stat_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm  rsfec_lane_rx_stat_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm  rsfec_lane_rx_hold_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm  rsfec_lane_rx_hold_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm  rsfec_lane_rx_hold_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm  rsfec_lane_rx_hold_3;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm  rsfec_lane_rx_inten_0;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm  rsfec_lane_rx_inten_1;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm  rsfec_lane_rx_inten_2;
      rand rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm  rsfec_lane_rx_inten_3;
      rand rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm  rsfec_lanes_rx_stat;
      rand rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm  rsfec_lanes_rx_hold;
      rand rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm  rsfec_lanes_rx_inten;
      rand rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm  rsfec_ln_mapping_rx_0;
      rand rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm  rsfec_ln_mapping_rx_1;
      rand rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm  rsfec_ln_mapping_rx_2;
      rand rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm  rsfec_ln_mapping_rx_3;
      rand rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm  rsfec_ln_skew_rx_0;
      rand rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm  rsfec_ln_skew_rx_1;
      rand rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm  rsfec_ln_skew_rx_2;
      rand rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm  rsfec_ln_skew_rx_3;
      rand rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm  rsfec_cw_pos_rx_0;
      rand rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm  rsfec_cw_pos_rx_1;
      rand rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm  rsfec_cw_pos_rx_2;
      rand rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm  rsfec_cw_pos_rx_3;
      rand rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm  rsfec_core_ecc_hold;
      rand rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm  rsfec_err_inj_tx_0;
      rand rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm  rsfec_err_inj_tx_1;
      rand rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm  rsfec_err_inj_tx_2;
      rand rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm  rsfec_err_inj_tx_3;
      rand rsfec_cfgcsr_csr_rsfec_err_val_tx_urm  rsfec_err_val_tx_0;
      rand rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm  rsfec_err_val_tx_1;
      rand rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm  rsfec_err_val_tx_2;
      rand rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm  rsfec_err_val_tx_3;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm  rsfec_corr_cw_cnt_0_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm  rsfec_corr_cw_cnt_0_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm  rsfec_corr_cw_cnt_1_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm  rsfec_corr_cw_cnt_1_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm  rsfec_corr_cw_cnt_2_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm  rsfec_corr_cw_cnt_2_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm  rsfec_corr_cw_cnt_3_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm  rsfec_corr_cw_cnt_3_hi;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm  rsfec_uncorr_cw_cnt_0_lo;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm  rsfec_uncorr_cw_cnt_0_hi;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm  rsfec_uncorr_cw_cnt_1_lo;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm  rsfec_uncorr_cw_cnt_1_hi;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm  rsfec_uncorr_cw_cnt_2_lo;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm  rsfec_uncorr_cw_cnt_2_hi;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm  rsfec_uncorr_cw_cnt_3_lo;
      rand rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm  rsfec_uncorr_cw_cnt_3_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm  rsfec_corr_syms_cnt_0_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm  rsfec_corr_syms_cnt_0_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm  rsfec_corr_syms_cnt_1_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm  rsfec_corr_syms_cnt_1_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm  rsfec_corr_syms_cnt_2_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm  rsfec_corr_syms_cnt_2_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm  rsfec_corr_syms_cnt_3_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm  rsfec_corr_syms_cnt_3_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm  rsfec_corr_0s_cnt_0_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm  rsfec_corr_0s_cnt_0_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm  rsfec_corr_0s_cnt_1_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm  rsfec_corr_0s_cnt_1_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm  rsfec_corr_0s_cnt_2_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm  rsfec_corr_0s_cnt_2_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm  rsfec_corr_0s_cnt_3_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm  rsfec_corr_0s_cnt_3_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm  rsfec_corr_1s_cnt_0_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm  rsfec_corr_1s_cnt_0_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm  rsfec_corr_1s_cnt_1_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm  rsfec_corr_1s_cnt_1_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm  rsfec_corr_1s_cnt_2_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm  rsfec_corr_1s_cnt_2_hi;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm  rsfec_corr_1s_cnt_3_lo;
      rand rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm  rsfec_corr_1s_cnt_3_hi;
      
      // uvm_reg_map _map;

      //Constructor
      function new(string name = "rsfec_cfgcsr_csr_urm");
         super.new(name,build_coverage(UVM_CVR_ALL));
         endfunction : new

      //Build
      virtual function void build();
         
         // Create registers
         arbiter_base_cfg = rsfec_cfgcsr_csr_reg_arbiter_base_cfg_urm::type_id::create("arbiter_base_cfg");
         arbiter_base_cfg.configure(this,null,"");
         arbiter_base_cfg.build();
         // hdl path
         arbiter_base_cfg.add_hdl_path_slice("arbiter_base_cfg_arbiter_base",0,1);
         arbiter_base_cfg.add_hdl_path_slice("arbiter_base_cfg_usr_code",2,6);
         arbiter_base_cfg.add_hdl_path_slice("arbiter_base_cfg_usr_key",16,16);
         
         // Create registers
         rsfec_top_clk_cfg = rsfec_cfgcsr_csr_reg_rsfec_top_clk_cfg_urm::type_id::create("rsfec_top_clk_cfg");
         rsfec_top_clk_cfg.configure(this,null,"");
         rsfec_top_clk_cfg.build();
         // hdl path
         rsfec_top_clk_cfg.add_hdl_path_slice("rsfec_top_clk_cfg_rsfec_clk_sel",0,3);
         rsfec_top_clk_cfg.add_hdl_path_slice("rsfec_top_clk_cfg_fec_lane_ena",8,4);
         rsfec_top_clk_cfg.add_hdl_path_slice("rsfec_top_clk_cfg_clk_gating_dis",15,1);
         
         // Create registers
         rsfec_top_tx_cfg = rsfec_cfgcsr_csr_reg_rsfec_top_tx_cfg_urm::type_id::create("rsfec_top_tx_cfg");
         rsfec_top_tx_cfg.configure(this,null,"");
         rsfec_top_tx_cfg.build();
         // hdl path
         rsfec_top_tx_cfg.add_hdl_path_slice("rsfec_top_tx_cfg_core_tx_in_sel0",0,3);
         rsfec_top_tx_cfg.add_hdl_path_slice("rsfec_top_tx_cfg_core_tx_in_sel1",4,3);
         rsfec_top_tx_cfg.add_hdl_path_slice("rsfec_top_tx_cfg_core_tx_in_sel2",8,3);
         rsfec_top_tx_cfg.add_hdl_path_slice("rsfec_top_tx_cfg_core_tx_in_sel3",12,3);
         rsfec_top_tx_cfg.add_hdl_path_slice("rsfec_top_tx_cfg_core_tx_pcs_bypass",28,4);
         
         // Create registers
         rsfec_top_rx_cfg = rsfec_cfgcsr_csr_reg_rsfec_top_rx_cfg_urm::type_id::create("rsfec_top_rx_cfg");
         rsfec_top_rx_cfg.configure(this,null,"");
         rsfec_top_rx_cfg.build();
         // hdl path
         rsfec_top_rx_cfg.add_hdl_path_slice("rsfec_top_rx_cfg_core_rx_out_sel0",0,2);
         rsfec_top_rx_cfg.add_hdl_path_slice("rsfec_top_rx_cfg_core_rx_out_sel1",4,2);
         rsfec_top_rx_cfg.add_hdl_path_slice("rsfec_top_rx_cfg_core_rx_out_sel2",8,2);
         rsfec_top_rx_cfg.add_hdl_path_slice("rsfec_top_rx_cfg_core_rx_out_sel3",12,2);
         rsfec_top_rx_cfg.add_hdl_path_slice("rsfec_top_rx_cfg_loopback_tx2rx",28,4);
         
         // Create registers
         rsfec_top_eng_cfg = rsfec_cfgcsr_csr_reg_rsfec_eng_cfg_urm::type_id::create("rsfec_top_eng_cfg");
         rsfec_top_eng_cfg.configure(this,null,"");
         rsfec_top_eng_cfg.build();
         // hdl path
         rsfec_top_eng_cfg.add_hdl_path_slice("rsfec_top_eng_cfg_testbus_sel",0,3);
         rsfec_top_eng_cfg.add_hdl_path_slice("rsfec_top_eng_cfg_force_tx_pld_deskew_done",4,1);
         rsfec_top_eng_cfg.add_hdl_path_slice("rsfec_top_eng_cfg_force_fec_ready",5,1);
         rsfec_top_eng_cfg.add_hdl_path_slice("rsfec_top_eng_cfg_spare_bits",8,8);
         rsfec_top_eng_cfg.add_hdl_path_slice("rsfec_top_eng_cfg_hwcfg_mode",16,15);
         rsfec_top_eng_cfg.add_hdl_path_slice("rsfec_top_eng_cfg_hwcfg_ena",31,1);
         
         // Create registers
         tx_aib_dsk_conf = rsfec_cfgcsr_csr_reg_tx_aib_dsk_conf_urm::type_id::create("tx_aib_dsk_conf");
         tx_aib_dsk_conf.configure(this,null,"");
         tx_aib_dsk_conf.build();
         // hdl path
         tx_aib_dsk_conf.add_hdl_path_slice("tx_aib_dsk_conf_tx_deskew_chan_sel",0,4);
         tx_aib_dsk_conf.add_hdl_path_slice("tx_aib_dsk_conf_tx_deskew_clear",7,1);
         
         // Create registers
         rsfec_status_hold = rsfec_cfgcsr_csr_rsfec_top_status_urm::type_id::create("rsfec_status_hold");
         rsfec_status_hold.configure(this,null,"");
         rsfec_status_hold.build();
         // hdl path
         rsfec_status_hold.add_hdl_path_slice("rsfec_status_hold_avmm_timeout",0,1);
         rsfec_status_hold.add_hdl_path_slice("rsfec_status_hold_spare_hold",1,1);
         rsfec_status_hold.add_hdl_path_slice("rsfec_status_hold_clock_active_i",2,1);
         rsfec_status_hold.add_hdl_path_slice("rsfec_status_hold_spare_stat_i",3,4);
         
         // Create registers
         rsfec_core_cfg = rsfec_cfgcsr_csr_rsfec_core_cfg_urm::type_id::create("rsfec_core_cfg");
         rsfec_core_cfg.configure(this,null,"");
         rsfec_core_cfg.build();
         // hdl path
         rsfec_core_cfg.add_hdl_path_slice("rsfec_core_cfg_frac",0,2);
         rsfec_core_cfg.add_hdl_path_slice("rsfec_core_cfg_eng_2lane_en",7,1);
         rsfec_core_cfg.add_hdl_path_slice("rsfec_core_cfg_eng_enter_align",8,4);
         rsfec_core_cfg.add_hdl_path_slice("rsfec_core_cfg_eng_exit_align",12,4);
         rsfec_core_cfg.add_hdl_path_slice("rsfec_core_cfg_eng_test",16,16);
         
         // Create registers
         rsfec_lane_cfg_0 = rsfec_cfgcsr_csr_rsfec_lane_cfg_urm::type_id::create("rsfec_lane_cfg_0");
         rsfec_lane_cfg_0.configure(this,null,"");
         rsfec_lane_cfg_0.build();
         // hdl path
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_fc",0,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_scr",1,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_indic_byp",2,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_rs544",3,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_trans_byp",16,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_sf_dis",17,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_fec_3bad_dis",18,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_am_5bad_dis",19,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_blk_chk_dis",20,1);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_swaps",21,4);
         rsfec_lane_cfg_0.add_hdl_path_slice("rsfec_lane_cfg_0_eng_cons_25g",25,1);
         
         // Create registers
         rsfec_lane_cfg_1 = rsfec_cfgcsr_csr_rsfec_lane_cfg_1_urm::type_id::create("rsfec_lane_cfg_1");
         rsfec_lane_cfg_1.configure(this,null,"");
         rsfec_lane_cfg_1.build();
         // hdl path
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_fc",0,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_scr",1,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_indic_byp",2,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_rs544",3,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_trans_byp",16,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_sf_dis",17,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_fec_3bad_dis",18,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_am_5bad_dis",19,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_blk_chk_dis",20,1);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_swaps",21,4);
         rsfec_lane_cfg_1.add_hdl_path_slice("rsfec_lane_cfg_1_eng_cons_25g",25,1);
         
         // Create registers
         rsfec_lane_cfg_2 = rsfec_cfgcsr_csr_rsfec_lane_cfg_2_urm::type_id::create("rsfec_lane_cfg_2");
         rsfec_lane_cfg_2.configure(this,null,"");
         rsfec_lane_cfg_2.build();
         // hdl path
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_fc",0,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_scr",1,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_indic_byp",2,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_rs544",3,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_trans_byp",16,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_sf_dis",17,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_fec_3bad_dis",18,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_am_5bad_dis",19,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_blk_chk_dis",20,1);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_swaps",21,4);
         rsfec_lane_cfg_2.add_hdl_path_slice("rsfec_lane_cfg_2_eng_cons_25g",25,1);
         
         // Create registers
         rsfec_lane_cfg_3 = rsfec_cfgcsr_csr_rsfec_lane_cfg_3_urm::type_id::create("rsfec_lane_cfg_3");
         rsfec_lane_cfg_3.configure(this,null,"");
         rsfec_lane_cfg_3.build();
         // hdl path
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_fc",0,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_scr",1,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_indic_byp",2,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_rs544",3,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_trans_byp",16,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_sf_dis",17,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_fec_3bad_dis",18,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_am_5bad_dis",19,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_blk_chk_dis",20,1);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_swaps",21,4);
         rsfec_lane_cfg_3.add_hdl_path_slice("rsfec_lane_cfg_3_eng_cons_25g",25,1);
         
         // Create registers
         rsfec_lane_cfg1_0 = rsfec_cfgcsr_csr_rsfec_lane_cfg1_urm::type_id::create("rsfec_lane_cfg1_0");
         rsfec_lane_cfg1_0.configure(this,null,"");
         rsfec_lane_cfg1_0.build();
         // hdl path
         rsfec_lane_cfg1_0.add_hdl_path_slice("rsfec_lane_cfg1_0_eng_cust_am_1st",0,24);
         rsfec_lane_cfg1_0.add_hdl_path_slice("rsfec_lane_cfg1_0_eng_cust_log2_mrk",24,4);
         rsfec_lane_cfg1_0.add_hdl_path_slice("rsfec_lane_cfg1_0_eng_cust_am_en",31,1);
         
         // Create registers
         rsfec_lane_cfg1_1 = rsfec_cfgcsr_csr_rsfec_lane_cfg1_1_urm::type_id::create("rsfec_lane_cfg1_1");
         rsfec_lane_cfg1_1.configure(this,null,"");
         rsfec_lane_cfg1_1.build();
         // hdl path
         rsfec_lane_cfg1_1.add_hdl_path_slice("rsfec_lane_cfg1_1_eng_cust_am_1st",0,24);
         rsfec_lane_cfg1_1.add_hdl_path_slice("rsfec_lane_cfg1_1_eng_cust_log2_mrk",24,4);
         rsfec_lane_cfg1_1.add_hdl_path_slice("rsfec_lane_cfg1_1_eng_cust_am_en",31,1);
         
         // Create registers
         rsfec_lane_cfg1_2 = rsfec_cfgcsr_csr_rsfec_lane_cfg1_2_urm::type_id::create("rsfec_lane_cfg1_2");
         rsfec_lane_cfg1_2.configure(this,null,"");
         rsfec_lane_cfg1_2.build();
         // hdl path
         rsfec_lane_cfg1_2.add_hdl_path_slice("rsfec_lane_cfg1_2_eng_cust_am_1st",0,24);
         rsfec_lane_cfg1_2.add_hdl_path_slice("rsfec_lane_cfg1_2_eng_cust_log2_mrk",24,4);
         rsfec_lane_cfg1_2.add_hdl_path_slice("rsfec_lane_cfg1_2_eng_cust_am_en",31,1);
         
         // Create registers
         rsfec_lane_cfg1_3 = rsfec_cfgcsr_csr_rsfec_lane_cfg1_3_urm::type_id::create("rsfec_lane_cfg1_3");
         rsfec_lane_cfg1_3.configure(this,null,"");
         rsfec_lane_cfg1_3.build();
         // hdl path
         rsfec_lane_cfg1_3.add_hdl_path_slice("rsfec_lane_cfg1_3_eng_cust_am_1st",0,24);
         rsfec_lane_cfg1_3.add_hdl_path_slice("rsfec_lane_cfg1_3_eng_cust_log2_mrk",24,4);
         rsfec_lane_cfg1_3.add_hdl_path_slice("rsfec_lane_cfg1_3_eng_cust_am_en",31,1);
         
         // Create registers
         rsfec_lane_cfg2_0 = rsfec_cfgcsr_csr_rsfec_lane_cfg2_urm::type_id::create("rsfec_lane_cfg2_0");
         rsfec_lane_cfg2_0.configure(this,null,"");
         rsfec_lane_cfg2_0.build();
         // hdl path
         rsfec_lane_cfg2_0.add_hdl_path_slice("rsfec_lane_cfg2_0_eng_cust_am_2nd",0,24);
         
         // Create registers
         rsfec_lane_cfg2_1 = rsfec_cfgcsr_csr_rsfec_lane_cfg2_1_urm::type_id::create("rsfec_lane_cfg2_1");
         rsfec_lane_cfg2_1.configure(this,null,"");
         rsfec_lane_cfg2_1.build();
         // hdl path
         rsfec_lane_cfg2_1.add_hdl_path_slice("rsfec_lane_cfg2_1_eng_cust_am_2nd",0,24);
         
         // Create registers
         rsfec_lane_cfg2_2 = rsfec_cfgcsr_csr_rsfec_lane_cfg2_2_urm::type_id::create("rsfec_lane_cfg2_2");
         rsfec_lane_cfg2_2.configure(this,null,"");
         rsfec_lane_cfg2_2.build();
         // hdl path
         rsfec_lane_cfg2_2.add_hdl_path_slice("rsfec_lane_cfg2_2_eng_cust_am_2nd",0,24);
         
         // Create registers
         rsfec_lane_cfg2_3 = rsfec_cfgcsr_csr_rsfec_lane_cfg2_3_urm::type_id::create("rsfec_lane_cfg2_3");
         rsfec_lane_cfg2_3.configure(this,null,"");
         rsfec_lane_cfg2_3.build();
         // hdl path
         rsfec_lane_cfg2_3.add_hdl_path_slice("rsfec_lane_cfg2_3_eng_cust_am_2nd",0,24);
         
         // Create registers
         rsfec_dft_cfg = rsfec_cfgcsr_csr_reg_core_dft_cfg_urm::type_id::create("rsfec_dft_cfg");
         rsfec_dft_cfg.configure(this,null,"");
         rsfec_dft_cfg.build();
         // hdl path
         rsfec_dft_cfg.add_hdl_path_slice("rsfec_dft_cfg_pbist",0,22);
         
         // Create registers
         rsfec_misc_cfg = rsfec_cfgcsr_csr_reg_misc_cfg_urm::type_id::create("rsfec_misc_cfg");
         rsfec_misc_cfg.configure(this,null,"");
         rsfec_misc_cfg.build();
         // hdl path
         rsfec_misc_cfg.add_hdl_path_slice("rsfec_misc_cfg_clk_present_period",4,4);
         rsfec_misc_cfg.add_hdl_path_slice("rsfec_misc_cfg_avmm_timeout_control",8,1);
         rsfec_misc_cfg.add_hdl_path_slice("rsfec_misc_cfg_disable_timeout_response",9,1);
         rsfec_misc_cfg.add_hdl_path_slice("rsfec_misc_cfg_disable_timeout_reset",10,1);
         rsfec_misc_cfg.add_hdl_path_slice("rsfec_misc_cfg_reset_async_intf",15,1);
         
         // Create registers
         tx_aib_dsk_status = rsfec_cfgcsr_csr_reg_tx_aib_dsk_status_urm::type_id::create("tx_aib_dsk_status");
         tx_aib_dsk_status.configure(this,null,"");
         tx_aib_dsk_status.build();
         // hdl path
         tx_aib_dsk_status.add_hdl_path_slice("tx_aib_dsk_status_tx_dsk_eval_done_i",0,1);
         tx_aib_dsk_status.add_hdl_path_slice("tx_aib_dsk_status_tx_dsk_status_i",1,3);
         tx_aib_dsk_status.add_hdl_path_slice("tx_aib_dsk_status_tx_dsk_monitor_err_i",4,4);
         tx_aib_dsk_status.add_hdl_path_slice("tx_aib_dsk_status_tx_dsk_active_chans_i",8,4);
         
         // Create registers
         rsfec_debug_cfg = rsfec_cfgcsr_csr_reg_core_debug_cfg_urm::type_id::create("rsfec_debug_cfg");
         rsfec_debug_cfg.configure(this,null,"");
         rsfec_debug_cfg.build();
         // hdl path
         rsfec_debug_cfg.add_hdl_path_slice("rsfec_debug_cfg_shadow_req",0,4);
         rsfec_debug_cfg.add_hdl_path_slice("rsfec_debug_cfg_shadow_clear",4,4);
         rsfec_debug_cfg.add_hdl_path_slice("rsfec_debug_cfg_spare_bits",16,8);
         rsfec_debug_cfg.add_hdl_path_slice("rsfec_debug_cfg_tx_rst",28,1);
         rsfec_debug_cfg.add_hdl_path_slice("rsfec_debug_cfg_rx_rst",29,1);
         rsfec_debug_cfg.add_hdl_path_slice("rsfec_debug_cfg_main_rst",31,1);
         
         // Create registers
         rsfec_lane_tx_stat_0 = rsfec_cfgcsr_csr_rsfec_lane_tx_stat_urm::type_id::create("rsfec_lane_tx_stat_0");
         rsfec_lane_tx_stat_0.configure(this,null,"");
         rsfec_lane_tx_stat_0.build();
         // hdl path
         rsfec_lane_tx_stat_0.add_hdl_path_slice("rsfec_lane_tx_stat_0_hdr_inv_i",0,1);
         rsfec_lane_tx_stat_0.add_hdl_path_slice("rsfec_lane_tx_stat_0_blk_inv_i",1,1);
         rsfec_lane_tx_stat_0.add_hdl_path_slice("rsfec_lane_tx_stat_0_resync_i",2,1);
         rsfec_lane_tx_stat_0.add_hdl_path_slice("rsfec_lane_tx_stat_0_pace_inv_i",3,1);
         
         // Create registers
         rsfec_lane_tx_stat_1 = rsfec_cfgcsr_csr_rsfec_lane_tx_stat_1_urm::type_id::create("rsfec_lane_tx_stat_1");
         rsfec_lane_tx_stat_1.configure(this,null,"");
         rsfec_lane_tx_stat_1.build();
         // hdl path
         rsfec_lane_tx_stat_1.add_hdl_path_slice("rsfec_lane_tx_stat_1_hdr_inv_i",0,1);
         rsfec_lane_tx_stat_1.add_hdl_path_slice("rsfec_lane_tx_stat_1_blk_inv_i",1,1);
         rsfec_lane_tx_stat_1.add_hdl_path_slice("rsfec_lane_tx_stat_1_resync_i",2,1);
         rsfec_lane_tx_stat_1.add_hdl_path_slice("rsfec_lane_tx_stat_1_pace_inv_i",3,1);
         
         // Create registers
         rsfec_lane_tx_stat_2 = rsfec_cfgcsr_csr_rsfec_lane_tx_stat_2_urm::type_id::create("rsfec_lane_tx_stat_2");
         rsfec_lane_tx_stat_2.configure(this,null,"");
         rsfec_lane_tx_stat_2.build();
         // hdl path
         rsfec_lane_tx_stat_2.add_hdl_path_slice("rsfec_lane_tx_stat_2_hdr_inv_i",0,1);
         rsfec_lane_tx_stat_2.add_hdl_path_slice("rsfec_lane_tx_stat_2_blk_inv_i",1,1);
         rsfec_lane_tx_stat_2.add_hdl_path_slice("rsfec_lane_tx_stat_2_resync_i",2,1);
         rsfec_lane_tx_stat_2.add_hdl_path_slice("rsfec_lane_tx_stat_2_pace_inv_i",3,1);
         
         // Create registers
         rsfec_lane_tx_stat_3 = rsfec_cfgcsr_csr_rsfec_lane_tx_stat_3_urm::type_id::create("rsfec_lane_tx_stat_3");
         rsfec_lane_tx_stat_3.configure(this,null,"");
         rsfec_lane_tx_stat_3.build();
         // hdl path
         rsfec_lane_tx_stat_3.add_hdl_path_slice("rsfec_lane_tx_stat_3_hdr_inv_i",0,1);
         rsfec_lane_tx_stat_3.add_hdl_path_slice("rsfec_lane_tx_stat_3_blk_inv_i",1,1);
         rsfec_lane_tx_stat_3.add_hdl_path_slice("rsfec_lane_tx_stat_3_resync_i",2,1);
         rsfec_lane_tx_stat_3.add_hdl_path_slice("rsfec_lane_tx_stat_3_pace_inv_i",3,1);
         
         // Create registers
         rsfec_lane_tx_hold_0 = rsfec_cfgcsr_csr_rsfec_lane_tx_hold_urm::type_id::create("rsfec_lane_tx_hold_0");
         rsfec_lane_tx_hold_0.configure(this,null,"");
         rsfec_lane_tx_hold_0.build();
         // hdl path
         rsfec_lane_tx_hold_0.add_hdl_path_slice("rsfec_lane_tx_hold_0_hdr_inv",0,1);
         rsfec_lane_tx_hold_0.add_hdl_path_slice("rsfec_lane_tx_hold_0_blk_inv",1,1);
         rsfec_lane_tx_hold_0.add_hdl_path_slice("rsfec_lane_tx_hold_0_resync",2,1);
         rsfec_lane_tx_hold_0.add_hdl_path_slice("rsfec_lane_tx_hold_0_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_hold_1 = rsfec_cfgcsr_csr_rsfec_lane_tx_hold_1_urm::type_id::create("rsfec_lane_tx_hold_1");
         rsfec_lane_tx_hold_1.configure(this,null,"");
         rsfec_lane_tx_hold_1.build();
         // hdl path
         rsfec_lane_tx_hold_1.add_hdl_path_slice("rsfec_lane_tx_hold_1_hdr_inv",0,1);
         rsfec_lane_tx_hold_1.add_hdl_path_slice("rsfec_lane_tx_hold_1_blk_inv",1,1);
         rsfec_lane_tx_hold_1.add_hdl_path_slice("rsfec_lane_tx_hold_1_resync",2,1);
         rsfec_lane_tx_hold_1.add_hdl_path_slice("rsfec_lane_tx_hold_1_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_hold_2 = rsfec_cfgcsr_csr_rsfec_lane_tx_hold_2_urm::type_id::create("rsfec_lane_tx_hold_2");
         rsfec_lane_tx_hold_2.configure(this,null,"");
         rsfec_lane_tx_hold_2.build();
         // hdl path
         rsfec_lane_tx_hold_2.add_hdl_path_slice("rsfec_lane_tx_hold_2_hdr_inv",0,1);
         rsfec_lane_tx_hold_2.add_hdl_path_slice("rsfec_lane_tx_hold_2_blk_inv",1,1);
         rsfec_lane_tx_hold_2.add_hdl_path_slice("rsfec_lane_tx_hold_2_resync",2,1);
         rsfec_lane_tx_hold_2.add_hdl_path_slice("rsfec_lane_tx_hold_2_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_hold_3 = rsfec_cfgcsr_csr_rsfec_lane_tx_hold_3_urm::type_id::create("rsfec_lane_tx_hold_3");
         rsfec_lane_tx_hold_3.configure(this,null,"");
         rsfec_lane_tx_hold_3.build();
         // hdl path
         rsfec_lane_tx_hold_3.add_hdl_path_slice("rsfec_lane_tx_hold_3_hdr_inv",0,1);
         rsfec_lane_tx_hold_3.add_hdl_path_slice("rsfec_lane_tx_hold_3_blk_inv",1,1);
         rsfec_lane_tx_hold_3.add_hdl_path_slice("rsfec_lane_tx_hold_3_resync",2,1);
         rsfec_lane_tx_hold_3.add_hdl_path_slice("rsfec_lane_tx_hold_3_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_inten_0 = rsfec_cfgcsr_csr_rsfec_lane_tx_inten_urm::type_id::create("rsfec_lane_tx_inten_0");
         rsfec_lane_tx_inten_0.configure(this,null,"");
         rsfec_lane_tx_inten_0.build();
         // hdl path
         rsfec_lane_tx_inten_0.add_hdl_path_slice("rsfec_lane_tx_inten_0_hdr_inv",0,1);
         rsfec_lane_tx_inten_0.add_hdl_path_slice("rsfec_lane_tx_inten_0_blk_inv",1,1);
         rsfec_lane_tx_inten_0.add_hdl_path_slice("rsfec_lane_tx_inten_0_resync",2,1);
         rsfec_lane_tx_inten_0.add_hdl_path_slice("rsfec_lane_tx_inten_0_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_inten_1 = rsfec_cfgcsr_csr_rsfec_lane_tx_inten_1_urm::type_id::create("rsfec_lane_tx_inten_1");
         rsfec_lane_tx_inten_1.configure(this,null,"");
         rsfec_lane_tx_inten_1.build();
         // hdl path
         rsfec_lane_tx_inten_1.add_hdl_path_slice("rsfec_lane_tx_inten_1_hdr_inv",0,1);
         rsfec_lane_tx_inten_1.add_hdl_path_slice("rsfec_lane_tx_inten_1_blk_inv",1,1);
         rsfec_lane_tx_inten_1.add_hdl_path_slice("rsfec_lane_tx_inten_1_resync",2,1);
         rsfec_lane_tx_inten_1.add_hdl_path_slice("rsfec_lane_tx_inten_1_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_inten_2 = rsfec_cfgcsr_csr_rsfec_lane_tx_inten_2_urm::type_id::create("rsfec_lane_tx_inten_2");
         rsfec_lane_tx_inten_2.configure(this,null,"");
         rsfec_lane_tx_inten_2.build();
         // hdl path
         rsfec_lane_tx_inten_2.add_hdl_path_slice("rsfec_lane_tx_inten_2_hdr_inv",0,1);
         rsfec_lane_tx_inten_2.add_hdl_path_slice("rsfec_lane_tx_inten_2_blk_inv",1,1);
         rsfec_lane_tx_inten_2.add_hdl_path_slice("rsfec_lane_tx_inten_2_resync",2,1);
         rsfec_lane_tx_inten_2.add_hdl_path_slice("rsfec_lane_tx_inten_2_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_tx_inten_3 = rsfec_cfgcsr_csr_rsfec_lane_tx_inten_3_urm::type_id::create("rsfec_lane_tx_inten_3");
         rsfec_lane_tx_inten_3.configure(this,null,"");
         rsfec_lane_tx_inten_3.build();
         // hdl path
         rsfec_lane_tx_inten_3.add_hdl_path_slice("rsfec_lane_tx_inten_3_hdr_inv",0,1);
         rsfec_lane_tx_inten_3.add_hdl_path_slice("rsfec_lane_tx_inten_3_blk_inv",1,1);
         rsfec_lane_tx_inten_3.add_hdl_path_slice("rsfec_lane_tx_inten_3_resync",2,1);
         rsfec_lane_tx_inten_3.add_hdl_path_slice("rsfec_lane_tx_inten_3_pace_inv",3,1);
         
         // Create registers
         rsfec_lane_rx_stat_0 = rsfec_cfgcsr_csr_rsfec_lane_rx_stat_urm::type_id::create("rsfec_lane_rx_stat_0");
         rsfec_lane_rx_stat_0.configure(this,null,"");
         rsfec_lane_rx_stat_0.build();
         // hdl path
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_sf_i",0,1);
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_not_locked_i",1,1);
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_fec_3bad_i",2,1);
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_am_5bad_i",3,1);
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_hi_ser_i",4,1);
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_corr_cw_i",5,1);
         rsfec_lane_rx_stat_0.add_hdl_path_slice("rsfec_lane_rx_stat_0_uncorr_cw_i",6,1);
         
         // Create registers
         rsfec_lane_rx_stat_1 = rsfec_cfgcsr_csr_rsfec_lane_rx_stat_1_urm::type_id::create("rsfec_lane_rx_stat_1");
         rsfec_lane_rx_stat_1.configure(this,null,"");
         rsfec_lane_rx_stat_1.build();
         // hdl path
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_sf_i",0,1);
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_not_locked_i",1,1);
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_fec_3bad_i",2,1);
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_am_5bad_i",3,1);
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_hi_ser_i",4,1);
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_corr_cw_i",5,1);
         rsfec_lane_rx_stat_1.add_hdl_path_slice("rsfec_lane_rx_stat_1_uncorr_cw_i",6,1);
         
         // Create registers
         rsfec_lane_rx_stat_2 = rsfec_cfgcsr_csr_rsfec_lane_rx_stat_2_urm::type_id::create("rsfec_lane_rx_stat_2");
         rsfec_lane_rx_stat_2.configure(this,null,"");
         rsfec_lane_rx_stat_2.build();
         // hdl path
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_sf_i",0,1);
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_not_locked_i",1,1);
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_fec_3bad_i",2,1);
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_am_5bad_i",3,1);
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_hi_ser_i",4,1);
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_corr_cw_i",5,1);
         rsfec_lane_rx_stat_2.add_hdl_path_slice("rsfec_lane_rx_stat_2_uncorr_cw_i",6,1);
         
         // Create registers
         rsfec_lane_rx_stat_3 = rsfec_cfgcsr_csr_rsfec_lane_rx_stat_3_urm::type_id::create("rsfec_lane_rx_stat_3");
         rsfec_lane_rx_stat_3.configure(this,null,"");
         rsfec_lane_rx_stat_3.build();
         // hdl path
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_sf_i",0,1);
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_not_locked_i",1,1);
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_fec_3bad_i",2,1);
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_am_5bad_i",3,1);
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_hi_ser_i",4,1);
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_corr_cw_i",5,1);
         rsfec_lane_rx_stat_3.add_hdl_path_slice("rsfec_lane_rx_stat_3_uncorr_cw_i",6,1);
         
         // Create registers
         rsfec_lane_rx_hold_0 = rsfec_cfgcsr_csr_rsfec_lane_rx_hold_urm::type_id::create("rsfec_lane_rx_hold_0");
         rsfec_lane_rx_hold_0.configure(this,null,"");
         rsfec_lane_rx_hold_0.build();
         // hdl path
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_sf",0,1);
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_not_locked",1,1);
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_fec_3bad",2,1);
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_am_5bad",3,1);
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_hi_ser",4,1);
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_corr_cw",5,1);
         rsfec_lane_rx_hold_0.add_hdl_path_slice("rsfec_lane_rx_hold_0_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_hold_1 = rsfec_cfgcsr_csr_rsfec_lane_rx_hold_1_urm::type_id::create("rsfec_lane_rx_hold_1");
         rsfec_lane_rx_hold_1.configure(this,null,"");
         rsfec_lane_rx_hold_1.build();
         // hdl path
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_sf",0,1);
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_not_locked",1,1);
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_fec_3bad",2,1);
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_am_5bad",3,1);
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_hi_ser",4,1);
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_corr_cw",5,1);
         rsfec_lane_rx_hold_1.add_hdl_path_slice("rsfec_lane_rx_hold_1_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_hold_2 = rsfec_cfgcsr_csr_rsfec_lane_rx_hold_2_urm::type_id::create("rsfec_lane_rx_hold_2");
         rsfec_lane_rx_hold_2.configure(this,null,"");
         rsfec_lane_rx_hold_2.build();
         // hdl path
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_sf",0,1);
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_not_locked",1,1);
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_fec_3bad",2,1);
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_am_5bad",3,1);
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_hi_ser",4,1);
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_corr_cw",5,1);
         rsfec_lane_rx_hold_2.add_hdl_path_slice("rsfec_lane_rx_hold_2_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_hold_3 = rsfec_cfgcsr_csr_rsfec_lane_rx_hold_3_urm::type_id::create("rsfec_lane_rx_hold_3");
         rsfec_lane_rx_hold_3.configure(this,null,"");
         rsfec_lane_rx_hold_3.build();
         // hdl path
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_sf",0,1);
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_not_locked",1,1);
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_fec_3bad",2,1);
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_am_5bad",3,1);
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_hi_ser",4,1);
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_corr_cw",5,1);
         rsfec_lane_rx_hold_3.add_hdl_path_slice("rsfec_lane_rx_hold_3_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_inten_0 = rsfec_cfgcsr_csr_rsfec_lane_rx_inten_urm::type_id::create("rsfec_lane_rx_inten_0");
         rsfec_lane_rx_inten_0.configure(this,null,"");
         rsfec_lane_rx_inten_0.build();
         // hdl path
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_sf",0,1);
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_not_locked",1,1);
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_fec_3bad",2,1);
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_am_5bad",3,1);
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_hi_ser",4,1);
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_corr_cw",5,1);
         rsfec_lane_rx_inten_0.add_hdl_path_slice("rsfec_lane_rx_inten_0_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_inten_1 = rsfec_cfgcsr_csr_rsfec_lane_rx_inten_1_urm::type_id::create("rsfec_lane_rx_inten_1");
         rsfec_lane_rx_inten_1.configure(this,null,"");
         rsfec_lane_rx_inten_1.build();
         // hdl path
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_sf",0,1);
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_not_locked",1,1);
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_fec_3bad",2,1);
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_am_5bad",3,1);
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_hi_ser",4,1);
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_corr_cw",5,1);
         rsfec_lane_rx_inten_1.add_hdl_path_slice("rsfec_lane_rx_inten_1_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_inten_2 = rsfec_cfgcsr_csr_rsfec_lane_rx_inten_2_urm::type_id::create("rsfec_lane_rx_inten_2");
         rsfec_lane_rx_inten_2.configure(this,null,"");
         rsfec_lane_rx_inten_2.build();
         // hdl path
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_sf",0,1);
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_not_locked",1,1);
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_fec_3bad",2,1);
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_am_5bad",3,1);
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_hi_ser",4,1);
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_corr_cw",5,1);
         rsfec_lane_rx_inten_2.add_hdl_path_slice("rsfec_lane_rx_inten_2_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lane_rx_inten_3 = rsfec_cfgcsr_csr_rsfec_lane_rx_inten_3_urm::type_id::create("rsfec_lane_rx_inten_3");
         rsfec_lane_rx_inten_3.configure(this,null,"");
         rsfec_lane_rx_inten_3.build();
         // hdl path
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_sf",0,1);
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_not_locked",1,1);
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_fec_3bad",2,1);
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_am_5bad",3,1);
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_hi_ser",4,1);
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_corr_cw",5,1);
         rsfec_lane_rx_inten_3.add_hdl_path_slice("rsfec_lane_rx_inten_3_uncorr_cw",6,1);
         
         // Create registers
         rsfec_lanes_rx_stat = rsfec_cfgcsr_csr_rsfec_lanes_rx_stat_urm::type_id::create("rsfec_lanes_rx_stat");
         rsfec_lanes_rx_stat.configure(this,null,"");
         rsfec_lanes_rx_stat.build();
         // hdl path
         rsfec_lanes_rx_stat.add_hdl_path_slice("rsfec_lanes_rx_stat_not_align_i",0,1);
         rsfec_lanes_rx_stat.add_hdl_path_slice("rsfec_lanes_rx_stat_not_deskew_i",1,1);
         
         // Create registers
         rsfec_lanes_rx_hold = rsfec_cfgcsr_csr_rsfec_lanes_rx_hold_urm::type_id::create("rsfec_lanes_rx_hold");
         rsfec_lanes_rx_hold.configure(this,null,"");
         rsfec_lanes_rx_hold.build();
         // hdl path
         rsfec_lanes_rx_hold.add_hdl_path_slice("rsfec_lanes_rx_hold_not_align",0,1);
         rsfec_lanes_rx_hold.add_hdl_path_slice("rsfec_lanes_rx_hold_not_deskew",1,1);
         
         // Create registers
         rsfec_lanes_rx_inten = rsfec_cfgcsr_csr_rsfec_lanes_rx_inten_urm::type_id::create("rsfec_lanes_rx_inten");
         rsfec_lanes_rx_inten.configure(this,null,"");
         rsfec_lanes_rx_inten.build();
         // hdl path
         rsfec_lanes_rx_inten.add_hdl_path_slice("rsfec_lanes_rx_inten_not_align",0,1);
         rsfec_lanes_rx_inten.add_hdl_path_slice("rsfec_lanes_rx_inten_not_deskew",1,1);
         
         // Create registers
         rsfec_ln_mapping_rx_0 = rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_urm::type_id::create("rsfec_ln_mapping_rx_0");
         rsfec_ln_mapping_rx_0.configure(this,null,"");
         rsfec_ln_mapping_rx_0.build();
         // hdl path
         rsfec_ln_mapping_rx_0.add_hdl_path_slice("rsfec_ln_mapping_rx_0_fec_lane_i",0,2);
         
         // Create registers
         rsfec_ln_mapping_rx_1 = rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_1_urm::type_id::create("rsfec_ln_mapping_rx_1");
         rsfec_ln_mapping_rx_1.configure(this,null,"");
         rsfec_ln_mapping_rx_1.build();
         // hdl path
         rsfec_ln_mapping_rx_1.add_hdl_path_slice("rsfec_ln_mapping_rx_1_fec_lane_i",0,2);
         
         // Create registers
         rsfec_ln_mapping_rx_2 = rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_2_urm::type_id::create("rsfec_ln_mapping_rx_2");
         rsfec_ln_mapping_rx_2.configure(this,null,"");
         rsfec_ln_mapping_rx_2.build();
         // hdl path
         rsfec_ln_mapping_rx_2.add_hdl_path_slice("rsfec_ln_mapping_rx_2_fec_lane_i",0,2);
         
         // Create registers
         rsfec_ln_mapping_rx_3 = rsfec_cfgcsr_csr_rsfec_ln_mapping_rx_3_urm::type_id::create("rsfec_ln_mapping_rx_3");
         rsfec_ln_mapping_rx_3.configure(this,null,"");
         rsfec_ln_mapping_rx_3.build();
         // hdl path
         rsfec_ln_mapping_rx_3.add_hdl_path_slice("rsfec_ln_mapping_rx_3_fec_lane_i",0,2);
         
         // Create registers
         rsfec_ln_skew_rx_0 = rsfec_cfgcsr_csr_rsfec_ln_skew_rx_urm::type_id::create("rsfec_ln_skew_rx_0");
         rsfec_ln_skew_rx_0.configure(this,null,"");
         rsfec_ln_skew_rx_0.build();
         // hdl path
         rsfec_ln_skew_rx_0.add_hdl_path_slice("rsfec_ln_skew_rx_0_skew_i",0,7);
         
         // Create registers
         rsfec_ln_skew_rx_1 = rsfec_cfgcsr_csr_rsfec_ln_skew_rx_1_urm::type_id::create("rsfec_ln_skew_rx_1");
         rsfec_ln_skew_rx_1.configure(this,null,"");
         rsfec_ln_skew_rx_1.build();
         // hdl path
         rsfec_ln_skew_rx_1.add_hdl_path_slice("rsfec_ln_skew_rx_1_skew_i",0,7);
         
         // Create registers
         rsfec_ln_skew_rx_2 = rsfec_cfgcsr_csr_rsfec_ln_skew_rx_2_urm::type_id::create("rsfec_ln_skew_rx_2");
         rsfec_ln_skew_rx_2.configure(this,null,"");
         rsfec_ln_skew_rx_2.build();
         // hdl path
         rsfec_ln_skew_rx_2.add_hdl_path_slice("rsfec_ln_skew_rx_2_skew_i",0,7);
         
         // Create registers
         rsfec_ln_skew_rx_3 = rsfec_cfgcsr_csr_rsfec_ln_skew_rx_3_urm::type_id::create("rsfec_ln_skew_rx_3");
         rsfec_ln_skew_rx_3.configure(this,null,"");
         rsfec_ln_skew_rx_3.build();
         // hdl path
         rsfec_ln_skew_rx_3.add_hdl_path_slice("rsfec_ln_skew_rx_3_skew_i",0,7);
         
         // Create registers
         rsfec_cw_pos_rx_0 = rsfec_cfgcsr_csr_rsfec_cw_pos_rx_urm::type_id::create("rsfec_cw_pos_rx_0");
         rsfec_cw_pos_rx_0.configure(this,null,"");
         rsfec_cw_pos_rx_0.build();
         // hdl path
         rsfec_cw_pos_rx_0.add_hdl_path_slice("rsfec_cw_pos_rx_0_num_i",0,13);
         
         // Create registers
         rsfec_cw_pos_rx_1 = rsfec_cfgcsr_csr_rsfec_cw_pos_rx_1_urm::type_id::create("rsfec_cw_pos_rx_1");
         rsfec_cw_pos_rx_1.configure(this,null,"");
         rsfec_cw_pos_rx_1.build();
         // hdl path
         rsfec_cw_pos_rx_1.add_hdl_path_slice("rsfec_cw_pos_rx_1_num_i",0,13);
         
         // Create registers
         rsfec_cw_pos_rx_2 = rsfec_cfgcsr_csr_rsfec_cw_pos_rx_2_urm::type_id::create("rsfec_cw_pos_rx_2");
         rsfec_cw_pos_rx_2.configure(this,null,"");
         rsfec_cw_pos_rx_2.build();
         // hdl path
         rsfec_cw_pos_rx_2.add_hdl_path_slice("rsfec_cw_pos_rx_2_num_i",0,13);
         
         // Create registers
         rsfec_cw_pos_rx_3 = rsfec_cfgcsr_csr_rsfec_cw_pos_rx_3_urm::type_id::create("rsfec_cw_pos_rx_3");
         rsfec_cw_pos_rx_3.configure(this,null,"");
         rsfec_cw_pos_rx_3.build();
         // hdl path
         rsfec_cw_pos_rx_3.add_hdl_path_slice("rsfec_cw_pos_rx_3_num_i",0,13);
         
         // Create registers
         rsfec_core_ecc_hold = rsfec_cfgcsr_csr_rsfec_core_ecc_hold_urm::type_id::create("rsfec_core_ecc_hold");
         rsfec_core_ecc_hold.configure(this,null,"");
         rsfec_core_ecc_hold.build();
         // hdl path
         rsfec_core_ecc_hold.add_hdl_path_slice("rsfec_core_ecc_hold_sbe",0,8);
         rsfec_core_ecc_hold.add_hdl_path_slice("rsfec_core_ecc_hold_mbe",8,8);
         
         // Create registers
         rsfec_err_inj_tx_0 = rsfec_cfgcsr_csr_rsfec_err_inj_tx_urm::type_id::create("rsfec_err_inj_tx_0");
         rsfec_err_inj_tx_0.configure(this,null,"");
         rsfec_err_inj_tx_0.build();
         // hdl path
         rsfec_err_inj_tx_0.add_hdl_path_slice("rsfec_err_inj_tx_0_rate",0,8);
         rsfec_err_inj_tx_0.add_hdl_path_slice("rsfec_err_inj_tx_0_pat",8,8);
         
         // Create registers
         rsfec_err_inj_tx_1 = rsfec_cfgcsr_csr_rsfec_err_inj_tx_1_urm::type_id::create("rsfec_err_inj_tx_1");
         rsfec_err_inj_tx_1.configure(this,null,"");
         rsfec_err_inj_tx_1.build();
         // hdl path
         rsfec_err_inj_tx_1.add_hdl_path_slice("rsfec_err_inj_tx_1_rate",0,8);
         rsfec_err_inj_tx_1.add_hdl_path_slice("rsfec_err_inj_tx_1_pat",8,8);
         
         // Create registers
         rsfec_err_inj_tx_2 = rsfec_cfgcsr_csr_rsfec_err_inj_tx_2_urm::type_id::create("rsfec_err_inj_tx_2");
         rsfec_err_inj_tx_2.configure(this,null,"");
         rsfec_err_inj_tx_2.build();
         // hdl path
         rsfec_err_inj_tx_2.add_hdl_path_slice("rsfec_err_inj_tx_2_rate",0,8);
         rsfec_err_inj_tx_2.add_hdl_path_slice("rsfec_err_inj_tx_2_pat",8,8);
         
         // Create registers
         rsfec_err_inj_tx_3 = rsfec_cfgcsr_csr_rsfec_err_inj_tx_3_urm::type_id::create("rsfec_err_inj_tx_3");
         rsfec_err_inj_tx_3.configure(this,null,"");
         rsfec_err_inj_tx_3.build();
         // hdl path
         rsfec_err_inj_tx_3.add_hdl_path_slice("rsfec_err_inj_tx_3_rate",0,8);
         rsfec_err_inj_tx_3.add_hdl_path_slice("rsfec_err_inj_tx_3_pat",8,8);
         
         // Create registers
         rsfec_err_val_tx_0 = rsfec_cfgcsr_csr_rsfec_err_val_tx_urm::type_id::create("rsfec_err_val_tx_0");
         rsfec_err_val_tx_0.configure(this,null,"");
         rsfec_err_val_tx_0.build();
         // hdl path
         rsfec_err_val_tx_0.add_hdl_path_slice("rsfec_err_val_tx_0_inj0s_i",0,8);
         rsfec_err_val_tx_0.add_hdl_path_slice("rsfec_err_val_tx_0_inj1s_i",8,8);
         
         // Create registers
         rsfec_err_val_tx_1 = rsfec_cfgcsr_csr_rsfec_err_val_tx_1_urm::type_id::create("rsfec_err_val_tx_1");
         rsfec_err_val_tx_1.configure(this,null,"");
         rsfec_err_val_tx_1.build();
         // hdl path
         rsfec_err_val_tx_1.add_hdl_path_slice("rsfec_err_val_tx_1_inj0s_i",0,8);
         rsfec_err_val_tx_1.add_hdl_path_slice("rsfec_err_val_tx_1_inj1s_i",8,8);
         
         // Create registers
         rsfec_err_val_tx_2 = rsfec_cfgcsr_csr_rsfec_err_val_tx_2_urm::type_id::create("rsfec_err_val_tx_2");
         rsfec_err_val_tx_2.configure(this,null,"");
         rsfec_err_val_tx_2.build();
         // hdl path
         rsfec_err_val_tx_2.add_hdl_path_slice("rsfec_err_val_tx_2_inj0s_i",0,8);
         rsfec_err_val_tx_2.add_hdl_path_slice("rsfec_err_val_tx_2_inj1s_i",8,8);
         
         // Create registers
         rsfec_err_val_tx_3 = rsfec_cfgcsr_csr_rsfec_err_val_tx_3_urm::type_id::create("rsfec_err_val_tx_3");
         rsfec_err_val_tx_3.configure(this,null,"");
         rsfec_err_val_tx_3.build();
         // hdl path
         rsfec_err_val_tx_3.add_hdl_path_slice("rsfec_err_val_tx_3_inj0s_i",0,8);
         rsfec_err_val_tx_3.add_hdl_path_slice("rsfec_err_val_tx_3_inj1s_i",8,8);
         
         // Create registers
         rsfec_corr_cw_cnt_0_lo = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_urm::type_id::create("rsfec_corr_cw_cnt_0_lo");
         rsfec_corr_cw_cnt_0_lo.configure(this,null,"");
         rsfec_corr_cw_cnt_0_lo.build();
         // hdl path
         rsfec_corr_cw_cnt_0_lo.add_hdl_path_slice("rsfec_corr_cw_cnt_0_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_0_hi = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_urm::type_id::create("rsfec_corr_cw_cnt_0_hi");
         rsfec_corr_cw_cnt_0_hi.configure(this,null,"");
         rsfec_corr_cw_cnt_0_hi.build();
         // hdl path
         rsfec_corr_cw_cnt_0_hi.add_hdl_path_slice("rsfec_corr_cw_cnt_0_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_1_lo = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_1_urm::type_id::create("rsfec_corr_cw_cnt_1_lo");
         rsfec_corr_cw_cnt_1_lo.configure(this,null,"");
         rsfec_corr_cw_cnt_1_lo.build();
         // hdl path
         rsfec_corr_cw_cnt_1_lo.add_hdl_path_slice("rsfec_corr_cw_cnt_1_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_1_hi = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_1_urm::type_id::create("rsfec_corr_cw_cnt_1_hi");
         rsfec_corr_cw_cnt_1_hi.configure(this,null,"");
         rsfec_corr_cw_cnt_1_hi.build();
         // hdl path
         rsfec_corr_cw_cnt_1_hi.add_hdl_path_slice("rsfec_corr_cw_cnt_1_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_2_lo = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_2_urm::type_id::create("rsfec_corr_cw_cnt_2_lo");
         rsfec_corr_cw_cnt_2_lo.configure(this,null,"");
         rsfec_corr_cw_cnt_2_lo.build();
         // hdl path
         rsfec_corr_cw_cnt_2_lo.add_hdl_path_slice("rsfec_corr_cw_cnt_2_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_2_hi = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_2_urm::type_id::create("rsfec_corr_cw_cnt_2_hi");
         rsfec_corr_cw_cnt_2_hi.configure(this,null,"");
         rsfec_corr_cw_cnt_2_hi.build();
         // hdl path
         rsfec_corr_cw_cnt_2_hi.add_hdl_path_slice("rsfec_corr_cw_cnt_2_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_3_lo = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_lo_3_urm::type_id::create("rsfec_corr_cw_cnt_3_lo");
         rsfec_corr_cw_cnt_3_lo.configure(this,null,"");
         rsfec_corr_cw_cnt_3_lo.build();
         // hdl path
         rsfec_corr_cw_cnt_3_lo.add_hdl_path_slice("rsfec_corr_cw_cnt_3_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_cw_cnt_3_hi = rsfec_cfgcsr_csr_rsfec_corr_cw_cnt_hi_3_urm::type_id::create("rsfec_corr_cw_cnt_3_hi");
         rsfec_corr_cw_cnt_3_hi.configure(this,null,"");
         rsfec_corr_cw_cnt_3_hi.build();
         // hdl path
         rsfec_corr_cw_cnt_3_hi.add_hdl_path_slice("rsfec_corr_cw_cnt_3_hi_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_0_lo = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_urm::type_id::create("rsfec_uncorr_cw_cnt_0_lo");
         rsfec_uncorr_cw_cnt_0_lo.configure(this,null,"");
         rsfec_uncorr_cw_cnt_0_lo.build();
         // hdl path
         rsfec_uncorr_cw_cnt_0_lo.add_hdl_path_slice("rsfec_uncorr_cw_cnt_0_lo_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_0_hi = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_urm::type_id::create("rsfec_uncorr_cw_cnt_0_hi");
         rsfec_uncorr_cw_cnt_0_hi.configure(this,null,"");
         rsfec_uncorr_cw_cnt_0_hi.build();
         // hdl path
         rsfec_uncorr_cw_cnt_0_hi.add_hdl_path_slice("rsfec_uncorr_cw_cnt_0_hi_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_1_lo = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_1_urm::type_id::create("rsfec_uncorr_cw_cnt_1_lo");
         rsfec_uncorr_cw_cnt_1_lo.configure(this,null,"");
         rsfec_uncorr_cw_cnt_1_lo.build();
         // hdl path
         rsfec_uncorr_cw_cnt_1_lo.add_hdl_path_slice("rsfec_uncorr_cw_cnt_1_lo_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_1_hi = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_1_urm::type_id::create("rsfec_uncorr_cw_cnt_1_hi");
         rsfec_uncorr_cw_cnt_1_hi.configure(this,null,"");
         rsfec_uncorr_cw_cnt_1_hi.build();
         // hdl path
         rsfec_uncorr_cw_cnt_1_hi.add_hdl_path_slice("rsfec_uncorr_cw_cnt_1_hi_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_2_lo = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_2_urm::type_id::create("rsfec_uncorr_cw_cnt_2_lo");
         rsfec_uncorr_cw_cnt_2_lo.configure(this,null,"");
         rsfec_uncorr_cw_cnt_2_lo.build();
         // hdl path
         rsfec_uncorr_cw_cnt_2_lo.add_hdl_path_slice("rsfec_uncorr_cw_cnt_2_lo_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_2_hi = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_2_urm::type_id::create("rsfec_uncorr_cw_cnt_2_hi");
         rsfec_uncorr_cw_cnt_2_hi.configure(this,null,"");
         rsfec_uncorr_cw_cnt_2_hi.build();
         // hdl path
         rsfec_uncorr_cw_cnt_2_hi.add_hdl_path_slice("rsfec_uncorr_cw_cnt_2_hi_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_3_lo = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_lo_3_urm::type_id::create("rsfec_uncorr_cw_cnt_3_lo");
         rsfec_uncorr_cw_cnt_3_lo.configure(this,null,"");
         rsfec_uncorr_cw_cnt_3_lo.build();
         // hdl path
         rsfec_uncorr_cw_cnt_3_lo.add_hdl_path_slice("rsfec_uncorr_cw_cnt_3_lo_stat_i",0,32);
         
         // Create registers
         rsfec_uncorr_cw_cnt_3_hi = rsfec_cfgcsr_csr_rsfec_uncorr_cw_cnt_hi_3_urm::type_id::create("rsfec_uncorr_cw_cnt_3_hi");
         rsfec_uncorr_cw_cnt_3_hi.configure(this,null,"");
         rsfec_uncorr_cw_cnt_3_hi.build();
         // hdl path
         rsfec_uncorr_cw_cnt_3_hi.add_hdl_path_slice("rsfec_uncorr_cw_cnt_3_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_0_lo = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_urm::type_id::create("rsfec_corr_syms_cnt_0_lo");
         rsfec_corr_syms_cnt_0_lo.configure(this,null,"");
         rsfec_corr_syms_cnt_0_lo.build();
         // hdl path
         rsfec_corr_syms_cnt_0_lo.add_hdl_path_slice("rsfec_corr_syms_cnt_0_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_0_hi = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_urm::type_id::create("rsfec_corr_syms_cnt_0_hi");
         rsfec_corr_syms_cnt_0_hi.configure(this,null,"");
         rsfec_corr_syms_cnt_0_hi.build();
         // hdl path
         rsfec_corr_syms_cnt_0_hi.add_hdl_path_slice("rsfec_corr_syms_cnt_0_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_1_lo = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_1_urm::type_id::create("rsfec_corr_syms_cnt_1_lo");
         rsfec_corr_syms_cnt_1_lo.configure(this,null,"");
         rsfec_corr_syms_cnt_1_lo.build();
         // hdl path
         rsfec_corr_syms_cnt_1_lo.add_hdl_path_slice("rsfec_corr_syms_cnt_1_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_1_hi = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_1_urm::type_id::create("rsfec_corr_syms_cnt_1_hi");
         rsfec_corr_syms_cnt_1_hi.configure(this,null,"");
         rsfec_corr_syms_cnt_1_hi.build();
         // hdl path
         rsfec_corr_syms_cnt_1_hi.add_hdl_path_slice("rsfec_corr_syms_cnt_1_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_2_lo = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_2_urm::type_id::create("rsfec_corr_syms_cnt_2_lo");
         rsfec_corr_syms_cnt_2_lo.configure(this,null,"");
         rsfec_corr_syms_cnt_2_lo.build();
         // hdl path
         rsfec_corr_syms_cnt_2_lo.add_hdl_path_slice("rsfec_corr_syms_cnt_2_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_2_hi = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_2_urm::type_id::create("rsfec_corr_syms_cnt_2_hi");
         rsfec_corr_syms_cnt_2_hi.configure(this,null,"");
         rsfec_corr_syms_cnt_2_hi.build();
         // hdl path
         rsfec_corr_syms_cnt_2_hi.add_hdl_path_slice("rsfec_corr_syms_cnt_2_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_3_lo = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_lo_3_urm::type_id::create("rsfec_corr_syms_cnt_3_lo");
         rsfec_corr_syms_cnt_3_lo.configure(this,null,"");
         rsfec_corr_syms_cnt_3_lo.build();
         // hdl path
         rsfec_corr_syms_cnt_3_lo.add_hdl_path_slice("rsfec_corr_syms_cnt_3_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_syms_cnt_3_hi = rsfec_cfgcsr_csr_rsfec_corr_syms_cnt_hi_3_urm::type_id::create("rsfec_corr_syms_cnt_3_hi");
         rsfec_corr_syms_cnt_3_hi.configure(this,null,"");
         rsfec_corr_syms_cnt_3_hi.build();
         // hdl path
         rsfec_corr_syms_cnt_3_hi.add_hdl_path_slice("rsfec_corr_syms_cnt_3_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_0_lo = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_urm::type_id::create("rsfec_corr_0s_cnt_0_lo");
         rsfec_corr_0s_cnt_0_lo.configure(this,null,"");
         rsfec_corr_0s_cnt_0_lo.build();
         // hdl path
         rsfec_corr_0s_cnt_0_lo.add_hdl_path_slice("rsfec_corr_0s_cnt_0_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_0_hi = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_urm::type_id::create("rsfec_corr_0s_cnt_0_hi");
         rsfec_corr_0s_cnt_0_hi.configure(this,null,"");
         rsfec_corr_0s_cnt_0_hi.build();
         // hdl path
         rsfec_corr_0s_cnt_0_hi.add_hdl_path_slice("rsfec_corr_0s_cnt_0_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_1_lo = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_1_urm::type_id::create("rsfec_corr_0s_cnt_1_lo");
         rsfec_corr_0s_cnt_1_lo.configure(this,null,"");
         rsfec_corr_0s_cnt_1_lo.build();
         // hdl path
         rsfec_corr_0s_cnt_1_lo.add_hdl_path_slice("rsfec_corr_0s_cnt_1_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_1_hi = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_1_urm::type_id::create("rsfec_corr_0s_cnt_1_hi");
         rsfec_corr_0s_cnt_1_hi.configure(this,null,"");
         rsfec_corr_0s_cnt_1_hi.build();
         // hdl path
         rsfec_corr_0s_cnt_1_hi.add_hdl_path_slice("rsfec_corr_0s_cnt_1_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_2_lo = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_2_urm::type_id::create("rsfec_corr_0s_cnt_2_lo");
         rsfec_corr_0s_cnt_2_lo.configure(this,null,"");
         rsfec_corr_0s_cnt_2_lo.build();
         // hdl path
         rsfec_corr_0s_cnt_2_lo.add_hdl_path_slice("rsfec_corr_0s_cnt_2_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_2_hi = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_2_urm::type_id::create("rsfec_corr_0s_cnt_2_hi");
         rsfec_corr_0s_cnt_2_hi.configure(this,null,"");
         rsfec_corr_0s_cnt_2_hi.build();
         // hdl path
         rsfec_corr_0s_cnt_2_hi.add_hdl_path_slice("rsfec_corr_0s_cnt_2_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_3_lo = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_lo_3_urm::type_id::create("rsfec_corr_0s_cnt_3_lo");
         rsfec_corr_0s_cnt_3_lo.configure(this,null,"");
         rsfec_corr_0s_cnt_3_lo.build();
         // hdl path
         rsfec_corr_0s_cnt_3_lo.add_hdl_path_slice("rsfec_corr_0s_cnt_3_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_0s_cnt_3_hi = rsfec_cfgcsr_csr_rsfec_corr_0s_cnt_hi_3_urm::type_id::create("rsfec_corr_0s_cnt_3_hi");
         rsfec_corr_0s_cnt_3_hi.configure(this,null,"");
         rsfec_corr_0s_cnt_3_hi.build();
         // hdl path
         rsfec_corr_0s_cnt_3_hi.add_hdl_path_slice("rsfec_corr_0s_cnt_3_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_0_lo = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_urm::type_id::create("rsfec_corr_1s_cnt_0_lo");
         rsfec_corr_1s_cnt_0_lo.configure(this,null,"");
         rsfec_corr_1s_cnt_0_lo.build();
         // hdl path
         rsfec_corr_1s_cnt_0_lo.add_hdl_path_slice("rsfec_corr_1s_cnt_0_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_0_hi = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_urm::type_id::create("rsfec_corr_1s_cnt_0_hi");
         rsfec_corr_1s_cnt_0_hi.configure(this,null,"");
         rsfec_corr_1s_cnt_0_hi.build();
         // hdl path
         rsfec_corr_1s_cnt_0_hi.add_hdl_path_slice("rsfec_corr_1s_cnt_0_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_1_lo = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_1_urm::type_id::create("rsfec_corr_1s_cnt_1_lo");
         rsfec_corr_1s_cnt_1_lo.configure(this,null,"");
         rsfec_corr_1s_cnt_1_lo.build();
         // hdl path
         rsfec_corr_1s_cnt_1_lo.add_hdl_path_slice("rsfec_corr_1s_cnt_1_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_1_hi = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_1_urm::type_id::create("rsfec_corr_1s_cnt_1_hi");
         rsfec_corr_1s_cnt_1_hi.configure(this,null,"");
         rsfec_corr_1s_cnt_1_hi.build();
         // hdl path
         rsfec_corr_1s_cnt_1_hi.add_hdl_path_slice("rsfec_corr_1s_cnt_1_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_2_lo = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_2_urm::type_id::create("rsfec_corr_1s_cnt_2_lo");
         rsfec_corr_1s_cnt_2_lo.configure(this,null,"");
         rsfec_corr_1s_cnt_2_lo.build();
         // hdl path
         rsfec_corr_1s_cnt_2_lo.add_hdl_path_slice("rsfec_corr_1s_cnt_2_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_2_hi = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_2_urm::type_id::create("rsfec_corr_1s_cnt_2_hi");
         rsfec_corr_1s_cnt_2_hi.configure(this,null,"");
         rsfec_corr_1s_cnt_2_hi.build();
         // hdl path
         rsfec_corr_1s_cnt_2_hi.add_hdl_path_slice("rsfec_corr_1s_cnt_2_hi_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_3_lo = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_lo_3_urm::type_id::create("rsfec_corr_1s_cnt_3_lo");
         rsfec_corr_1s_cnt_3_lo.configure(this,null,"");
         rsfec_corr_1s_cnt_3_lo.build();
         // hdl path
         rsfec_corr_1s_cnt_3_lo.add_hdl_path_slice("rsfec_corr_1s_cnt_3_lo_stat_i",0,32);
         
         // Create registers
         rsfec_corr_1s_cnt_3_hi = rsfec_cfgcsr_csr_rsfec_corr_1s_cnt_hi_3_urm::type_id::create("rsfec_corr_1s_cnt_3_hi");
         rsfec_corr_1s_cnt_3_hi.configure(this,null,"");
         rsfec_corr_1s_cnt_3_hi.build();
         // hdl path
         rsfec_corr_1s_cnt_3_hi.add_hdl_path_slice("rsfec_corr_1s_cnt_3_hi_stat_i",0,32);
         
      
         // Create the address map
         default_map = create_map("default_map",  `UVM_REG_ADDR_WIDTH'h0, 1, UVM_LITTLE_ENDIAN,1);
         //this.default_map = this.default_map;
         
         //mapping
         this.default_map.add_reg(arbiter_base_cfg, `UVM_REG_ADDR_WIDTH'h0, "RW");
         this.default_map.add_reg(rsfec_top_clk_cfg, `UVM_REG_ADDR_WIDTH'h4, "RW");
         this.default_map.add_reg(rsfec_top_tx_cfg, `UVM_REG_ADDR_WIDTH'h10, "RW");
         this.default_map.add_reg(rsfec_top_rx_cfg, `UVM_REG_ADDR_WIDTH'h14, "RW");
         this.default_map.add_reg(rsfec_top_eng_cfg, `UVM_REG_ADDR_WIDTH'h1c, "RW");
         this.default_map.add_reg(tx_aib_dsk_conf, `UVM_REG_ADDR_WIDTH'h20, "RW");
         this.default_map.add_reg(rsfec_status_hold, `UVM_REG_ADDR_WIDTH'h28, "RW");
         this.default_map.add_reg(rsfec_core_cfg, `UVM_REG_ADDR_WIDTH'h30, "RW");
         this.default_map.add_reg(rsfec_lane_cfg_0, `UVM_REG_ADDR_WIDTH'h40, "RW");
         this.default_map.add_reg(rsfec_lane_cfg_1, `UVM_REG_ADDR_WIDTH'h44, "RW");
         this.default_map.add_reg(rsfec_lane_cfg_2, `UVM_REG_ADDR_WIDTH'h48, "RW");
         this.default_map.add_reg(rsfec_lane_cfg_3, `UVM_REG_ADDR_WIDTH'h4c, "RW");
         this.default_map.add_reg(rsfec_lane_cfg1_0, `UVM_REG_ADDR_WIDTH'h50, "RW");
         this.default_map.add_reg(rsfec_lane_cfg1_1, `UVM_REG_ADDR_WIDTH'h54, "RW");
         this.default_map.add_reg(rsfec_lane_cfg1_2, `UVM_REG_ADDR_WIDTH'h58, "RW");
         this.default_map.add_reg(rsfec_lane_cfg1_3, `UVM_REG_ADDR_WIDTH'h5c, "RW");
         this.default_map.add_reg(rsfec_lane_cfg2_0, `UVM_REG_ADDR_WIDTH'h60, "RW");
         this.default_map.add_reg(rsfec_lane_cfg2_1, `UVM_REG_ADDR_WIDTH'h64, "RW");
         this.default_map.add_reg(rsfec_lane_cfg2_2, `UVM_REG_ADDR_WIDTH'h68, "RW");
         this.default_map.add_reg(rsfec_lane_cfg2_3, `UVM_REG_ADDR_WIDTH'h6c, "RW");
         this.default_map.add_reg(rsfec_dft_cfg, `UVM_REG_ADDR_WIDTH'hc0, "RW");
         this.default_map.add_reg(rsfec_misc_cfg, `UVM_REG_ADDR_WIDTH'hc4, "RW");
         this.default_map.add_reg(tx_aib_dsk_status, `UVM_REG_ADDR_WIDTH'h104, "RO");
         this.default_map.add_reg(rsfec_debug_cfg, `UVM_REG_ADDR_WIDTH'h108, "RW");
         this.default_map.add_reg(rsfec_lane_tx_stat_0, `UVM_REG_ADDR_WIDTH'h120, "RO");
         this.default_map.add_reg(rsfec_lane_tx_stat_1, `UVM_REG_ADDR_WIDTH'h124, "RO");
         this.default_map.add_reg(rsfec_lane_tx_stat_2, `UVM_REG_ADDR_WIDTH'h128, "RO");
         this.default_map.add_reg(rsfec_lane_tx_stat_3, `UVM_REG_ADDR_WIDTH'h12c, "RO");
         this.default_map.add_reg(rsfec_lane_tx_hold_0, `UVM_REG_ADDR_WIDTH'h130, "RW");
         this.default_map.add_reg(rsfec_lane_tx_hold_1, `UVM_REG_ADDR_WIDTH'h134, "RW");
         this.default_map.add_reg(rsfec_lane_tx_hold_2, `UVM_REG_ADDR_WIDTH'h138, "RW");
         this.default_map.add_reg(rsfec_lane_tx_hold_3, `UVM_REG_ADDR_WIDTH'h13c, "RW");
         this.default_map.add_reg(rsfec_lane_tx_inten_0, `UVM_REG_ADDR_WIDTH'h140, "RW");
         this.default_map.add_reg(rsfec_lane_tx_inten_1, `UVM_REG_ADDR_WIDTH'h144, "RW");
         this.default_map.add_reg(rsfec_lane_tx_inten_2, `UVM_REG_ADDR_WIDTH'h148, "RW");
         this.default_map.add_reg(rsfec_lane_tx_inten_3, `UVM_REG_ADDR_WIDTH'h14c, "RW");
         this.default_map.add_reg(rsfec_lane_rx_stat_0, `UVM_REG_ADDR_WIDTH'h150, "RO");
         this.default_map.add_reg(rsfec_lane_rx_stat_1, `UVM_REG_ADDR_WIDTH'h154, "RO");
         this.default_map.add_reg(rsfec_lane_rx_stat_2, `UVM_REG_ADDR_WIDTH'h158, "RO");
         this.default_map.add_reg(rsfec_lane_rx_stat_3, `UVM_REG_ADDR_WIDTH'h15c, "RO");
         this.default_map.add_reg(rsfec_lane_rx_hold_0, `UVM_REG_ADDR_WIDTH'h160, "RW");
         this.default_map.add_reg(rsfec_lane_rx_hold_1, `UVM_REG_ADDR_WIDTH'h164, "RW");
         this.default_map.add_reg(rsfec_lane_rx_hold_2, `UVM_REG_ADDR_WIDTH'h168, "RW");
         this.default_map.add_reg(rsfec_lane_rx_hold_3, `UVM_REG_ADDR_WIDTH'h16c, "RW");
         this.default_map.add_reg(rsfec_lane_rx_inten_0, `UVM_REG_ADDR_WIDTH'h170, "RW");
         this.default_map.add_reg(rsfec_lane_rx_inten_1, `UVM_REG_ADDR_WIDTH'h174, "RW");
         this.default_map.add_reg(rsfec_lane_rx_inten_2, `UVM_REG_ADDR_WIDTH'h178, "RW");
         this.default_map.add_reg(rsfec_lane_rx_inten_3, `UVM_REG_ADDR_WIDTH'h17c, "RW");
         this.default_map.add_reg(rsfec_lanes_rx_stat, `UVM_REG_ADDR_WIDTH'h180, "RO");
         this.default_map.add_reg(rsfec_lanes_rx_hold, `UVM_REG_ADDR_WIDTH'h188, "RW");
         this.default_map.add_reg(rsfec_lanes_rx_inten, `UVM_REG_ADDR_WIDTH'h18c, "RW");
         this.default_map.add_reg(rsfec_ln_mapping_rx_0, `UVM_REG_ADDR_WIDTH'h1a0, "RO");
         this.default_map.add_reg(rsfec_ln_mapping_rx_1, `UVM_REG_ADDR_WIDTH'h1a4, "RO");
         this.default_map.add_reg(rsfec_ln_mapping_rx_2, `UVM_REG_ADDR_WIDTH'h1a8, "RO");
         this.default_map.add_reg(rsfec_ln_mapping_rx_3, `UVM_REG_ADDR_WIDTH'h1ac, "RO");
         this.default_map.add_reg(rsfec_ln_skew_rx_0, `UVM_REG_ADDR_WIDTH'h1b0, "RO");
         this.default_map.add_reg(rsfec_ln_skew_rx_1, `UVM_REG_ADDR_WIDTH'h1b4, "RO");
         this.default_map.add_reg(rsfec_ln_skew_rx_2, `UVM_REG_ADDR_WIDTH'h1b8, "RO");
         this.default_map.add_reg(rsfec_ln_skew_rx_3, `UVM_REG_ADDR_WIDTH'h1bc, "RO");
         this.default_map.add_reg(rsfec_cw_pos_rx_0, `UVM_REG_ADDR_WIDTH'h1c0, "RO");
         this.default_map.add_reg(rsfec_cw_pos_rx_1, `UVM_REG_ADDR_WIDTH'h1c4, "RO");
         this.default_map.add_reg(rsfec_cw_pos_rx_2, `UVM_REG_ADDR_WIDTH'h1c8, "RO");
         this.default_map.add_reg(rsfec_cw_pos_rx_3, `UVM_REG_ADDR_WIDTH'h1cc, "RO");
         this.default_map.add_reg(rsfec_core_ecc_hold, `UVM_REG_ADDR_WIDTH'h1d0, "RW");
         this.default_map.add_reg(rsfec_err_inj_tx_0, `UVM_REG_ADDR_WIDTH'h1e0, "RW");
         this.default_map.add_reg(rsfec_err_inj_tx_1, `UVM_REG_ADDR_WIDTH'h1e4, "RW");
         this.default_map.add_reg(rsfec_err_inj_tx_2, `UVM_REG_ADDR_WIDTH'h1e8, "RW");
         this.default_map.add_reg(rsfec_err_inj_tx_3, `UVM_REG_ADDR_WIDTH'h1ec, "RW");
         this.default_map.add_reg(rsfec_err_val_tx_0, `UVM_REG_ADDR_WIDTH'h1f0, "RO");
         this.default_map.add_reg(rsfec_err_val_tx_1, `UVM_REG_ADDR_WIDTH'h1f4, "RO");
         this.default_map.add_reg(rsfec_err_val_tx_2, `UVM_REG_ADDR_WIDTH'h1f8, "RO");
         this.default_map.add_reg(rsfec_err_val_tx_3, `UVM_REG_ADDR_WIDTH'h1fc, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_0_lo, `UVM_REG_ADDR_WIDTH'h200, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_0_hi, `UVM_REG_ADDR_WIDTH'h204, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_1_lo, `UVM_REG_ADDR_WIDTH'h208, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_1_hi, `UVM_REG_ADDR_WIDTH'h20c, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_2_lo, `UVM_REG_ADDR_WIDTH'h210, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_2_hi, `UVM_REG_ADDR_WIDTH'h214, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_3_lo, `UVM_REG_ADDR_WIDTH'h218, "RO");
         this.default_map.add_reg(rsfec_corr_cw_cnt_3_hi, `UVM_REG_ADDR_WIDTH'h21c, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_0_lo, `UVM_REG_ADDR_WIDTH'h220, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_0_hi, `UVM_REG_ADDR_WIDTH'h224, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_1_lo, `UVM_REG_ADDR_WIDTH'h228, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_1_hi, `UVM_REG_ADDR_WIDTH'h22c, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_2_lo, `UVM_REG_ADDR_WIDTH'h230, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_2_hi, `UVM_REG_ADDR_WIDTH'h234, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_3_lo, `UVM_REG_ADDR_WIDTH'h238, "RO");
         this.default_map.add_reg(rsfec_uncorr_cw_cnt_3_hi, `UVM_REG_ADDR_WIDTH'h23c, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_0_lo, `UVM_REG_ADDR_WIDTH'h240, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_0_hi, `UVM_REG_ADDR_WIDTH'h244, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_1_lo, `UVM_REG_ADDR_WIDTH'h248, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_1_hi, `UVM_REG_ADDR_WIDTH'h24c, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_2_lo, `UVM_REG_ADDR_WIDTH'h250, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_2_hi, `UVM_REG_ADDR_WIDTH'h254, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_3_lo, `UVM_REG_ADDR_WIDTH'h258, "RO");
         this.default_map.add_reg(rsfec_corr_syms_cnt_3_hi, `UVM_REG_ADDR_WIDTH'h25c, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_0_lo, `UVM_REG_ADDR_WIDTH'h260, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_0_hi, `UVM_REG_ADDR_WIDTH'h264, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_1_lo, `UVM_REG_ADDR_WIDTH'h268, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_1_hi, `UVM_REG_ADDR_WIDTH'h26c, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_2_lo, `UVM_REG_ADDR_WIDTH'h270, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_2_hi, `UVM_REG_ADDR_WIDTH'h274, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_3_lo, `UVM_REG_ADDR_WIDTH'h278, "RO");
         this.default_map.add_reg(rsfec_corr_0s_cnt_3_hi, `UVM_REG_ADDR_WIDTH'h27c, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_0_lo, `UVM_REG_ADDR_WIDTH'h280, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_0_hi, `UVM_REG_ADDR_WIDTH'h284, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_1_lo, `UVM_REG_ADDR_WIDTH'h288, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_1_hi, `UVM_REG_ADDR_WIDTH'h28c, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_2_lo, `UVM_REG_ADDR_WIDTH'h290, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_2_hi, `UVM_REG_ADDR_WIDTH'h294, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_3_lo, `UVM_REG_ADDR_WIDTH'h298, "RO");
         this.default_map.add_reg(rsfec_corr_1s_cnt_3_hi, `UVM_REG_ADDR_WIDTH'h29c, "RO");
         
         void'(set_coverage(UVM_CVR_FIELD_VALS));
         
      endfunction : build

endclass : rsfec_cfgcsr_csr_urm


`endif // __RSFEC_CFGCSR_CSR_URM_SVH__
