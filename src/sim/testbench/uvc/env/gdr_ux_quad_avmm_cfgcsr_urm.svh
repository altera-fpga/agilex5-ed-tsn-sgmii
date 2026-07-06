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
--- Date :Sat Mar 21 14:10:11 PDT 2020
----------------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------------------------
--- UVM Register Model
--- Component Name: gdr_ux_quad_avmm_cfgcsr
--- File Ref: /nfs/site/disks/gdr_rtl_3/users/chewang/tbdev/icm/client_0.local/gdr_ux_quad/ipxact/output_result/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_gdr_ux_quad_avmm_cfgcsr_1.0.xml
--- Magillem Version :   5.11.2.1
----------------------------------------------------------------------------------------------------*/

`ifndef __GDR_UX_QUAD_AVMM_CFGCSR_URM_SVH__
`define __GDR_UX_QUAD_AVMM_CFGCSR_URM_SVH__


/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm  )

      rand uvm_reg_field cfg_func_mode_l0;
      rand uvm_reg_field cfg_func_mode_l1;
      rand uvm_reg_field cfg_func_mode_l2;
      rand uvm_reg_field cfg_func_mode_l3;
      rand uvm_reg_field cfg_func_mode_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_func_mode_l0_value : coverpoint cfg_func_mode_l0.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_func_mode_l1_value : coverpoint cfg_func_mode_l1.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_func_mode_l2_value : coverpoint cfg_func_mode_l2.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_func_mode_l3_value : coverpoint cfg_func_mode_l3.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_func_mode_reserved_value : coverpoint cfg_func_mode_reserved.value {
             bins all[8] = {[20'h0:20'hfffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_func_mode_l0 = uvm_reg_field::type_id::create("cfg_func_mode_l0");
         // configure
         cfg_func_mode_l0.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b100),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_func_mode_l1 = uvm_reg_field::type_id::create("cfg_func_mode_l1");
         // configure
         cfg_func_mode_l1.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b100),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_func_mode_l2 = uvm_reg_field::type_id::create("cfg_func_mode_l2");
         // configure
         cfg_func_mode_l2.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b100),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_func_mode_l3 = uvm_reg_field::type_id::create("cfg_func_mode_l3");
         // configure
         cfg_func_mode_l3.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b100),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_func_mode_reserved = uvm_reg_field::type_id::create("cfg_func_mode_reserved");
         // configure
         cfg_func_mode_reserved.configure(
         .parent                 ( this ),
         .size                   (20),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (20'b00000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm  )

      rand uvm_reg_field cfg_bonding_ctrl_l0;
      rand uvm_reg_field cfg_bonding_ctrl_l1;
      rand uvm_reg_field cfg_bonding_ctrl_l2;
      rand uvm_reg_field cfg_bonding_ctrl_l3;
      rand uvm_reg_field cfg_bonding_enable_l0;
      rand uvm_reg_field cfg_bonding_enable_l1;
      rand uvm_reg_field cfg_bonding_enable_l2;
      rand uvm_reg_field cfg_bonding_enable_l3;
      rand uvm_reg_field cfg_bonding_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_bonding_ctrl_l0_value : coverpoint cfg_bonding_ctrl_l0.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_bonding_ctrl_l1_value : coverpoint cfg_bonding_ctrl_l1.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_bonding_ctrl_l2_value : coverpoint cfg_bonding_ctrl_l2.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_bonding_ctrl_l3_value : coverpoint cfg_bonding_ctrl_l3.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_bonding_enable_l0_value : coverpoint cfg_bonding_enable_l0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_bonding_enable_l1_value : coverpoint cfg_bonding_enable_l1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_bonding_enable_l2_value : coverpoint cfg_bonding_enable_l2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_bonding_enable_l3_value : coverpoint cfg_bonding_enable_l3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_bonding_ctrl_reserved_value : coverpoint cfg_bonding_ctrl_reserved.value {
             bins all[8] = {[12'h0:12'hfff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_bonding_ctrl_l0 = uvm_reg_field::type_id::create("cfg_bonding_ctrl_l0");
         // configure
         cfg_bonding_ctrl_l0.configure(
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
         cfg_bonding_ctrl_l1 = uvm_reg_field::type_id::create("cfg_bonding_ctrl_l1");
         // configure
         cfg_bonding_ctrl_l1.configure(
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
         cfg_bonding_ctrl_l2 = uvm_reg_field::type_id::create("cfg_bonding_ctrl_l2");
         // configure
         cfg_bonding_ctrl_l2.configure(
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
         cfg_bonding_ctrl_l3 = uvm_reg_field::type_id::create("cfg_bonding_ctrl_l3");
         // configure
         cfg_bonding_ctrl_l3.configure(
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
         cfg_bonding_enable_l0 = uvm_reg_field::type_id::create("cfg_bonding_enable_l0");
         // configure
         cfg_bonding_enable_l0.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_bonding_enable_l1 = uvm_reg_field::type_id::create("cfg_bonding_enable_l1");
         // configure
         cfg_bonding_enable_l1.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_bonding_enable_l2 = uvm_reg_field::type_id::create("cfg_bonding_enable_l2");
         // configure
         cfg_bonding_enable_l2.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_bonding_enable_l3 = uvm_reg_field::type_id::create("cfg_bonding_enable_l3");
         // configure
         cfg_bonding_enable_l3.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_bonding_ctrl_reserved = uvm_reg_field::type_id::create("cfg_bonding_ctrl_reserved");
         // configure
         cfg_bonding_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (12),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (12'b000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm  )

      rand uvm_reg_field cfg_datapath_loopback_en_l0;
      rand uvm_reg_field cfg_datapath_loopback_en_l1;
      rand uvm_reg_field cfg_datapath_loopback_en_l2;
      rand uvm_reg_field cfg_datapath_loopback_en_l3;
      rand uvm_reg_field cfg_datapath_loopback_en_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_datapath_loopback_en_l0_value : coverpoint cfg_datapath_loopback_en_l0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_datapath_loopback_en_l1_value : coverpoint cfg_datapath_loopback_en_l1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_datapath_loopback_en_l2_value : coverpoint cfg_datapath_loopback_en_l2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_datapath_loopback_en_l3_value : coverpoint cfg_datapath_loopback_en_l3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_datapath_loopback_en_reserved_value : coverpoint cfg_datapath_loopback_en_reserved.value {
             bins all[8] = {[28'h0:28'hfffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_datapath_loopback_en_l0 = uvm_reg_field::type_id::create("cfg_datapath_loopback_en_l0");
         // configure
         cfg_datapath_loopback_en_l0.configure(
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
         cfg_datapath_loopback_en_l1 = uvm_reg_field::type_id::create("cfg_datapath_loopback_en_l1");
         // configure
         cfg_datapath_loopback_en_l1.configure(
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
         cfg_datapath_loopback_en_l2 = uvm_reg_field::type_id::create("cfg_datapath_loopback_en_l2");
         // configure
         cfg_datapath_loopback_en_l2.configure(
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
         cfg_datapath_loopback_en_l3 = uvm_reg_field::type_id::create("cfg_datapath_loopback_en_l3");
         // configure
         cfg_datapath_loopback_en_l3.configure(
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
         cfg_datapath_loopback_en_reserved = uvm_reg_field::type_id::create("cfg_datapath_loopback_en_reserved");
         // configure
         cfg_datapath_loopback_en_reserved.configure(
         .parent                 ( this ),
         .size                   (28),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (28'b0000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm  )

      rand uvm_reg_field cfg_ck_gating_ctrl;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_ck_gating_ctrl_value : coverpoint cfg_ck_gating_ctrl.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_ck_gating_ctrl = uvm_reg_field::type_id::create("cfg_ck_gating_ctrl");
         // configure
         cfg_ck_gating_ctrl.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm  )

      rand uvm_reg_field cfg_rx_lat_bit_for_async;
      rand uvm_reg_field cfg_sel_rxbit_adder;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rx_lat_bit_for_async_value : coverpoint cfg_rx_lat_bit_for_async.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_sel_rxbit_adder_value : coverpoint cfg_sel_rxbit_adder.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[11'h0:11'h7ff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rx_lat_bit_for_async = uvm_reg_field::type_id::create("cfg_rx_lat_bit_for_async");
         // configure
         cfg_rx_lat_bit_for_async.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_sel_rxbit_adder = uvm_reg_field::type_id::create("cfg_sel_rxbit_adder");
         // configure
         cfg_sel_rxbit_adder.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (11),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (11'b00000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm  )

      rand uvm_reg_field cfg_rxbit_rollover;
      rand uvm_reg_field cfg_latpls_bw;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rxbit_rollover_value : coverpoint cfg_rxbit_rollover.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_latpls_bw_value : coverpoint cfg_latpls_bw.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[12'h0:12'hfff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rxbit_rollover = uvm_reg_field::type_id::create("cfg_rxbit_rollover");
         // configure
         cfg_rxbit_rollover.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_latpls_bw = uvm_reg_field::type_id::create("cfg_latpls_bw");
         // configure
         cfg_latpls_bw.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (12),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (12'b000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm  )

      rand uvm_reg_field cfg_rx_lat_bit_for_async;
      rand uvm_reg_field cfg_sel_rxbit_adder;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rx_lat_bit_for_async_value : coverpoint cfg_rx_lat_bit_for_async.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_sel_rxbit_adder_value : coverpoint cfg_sel_rxbit_adder.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[11'h0:11'h7ff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rx_lat_bit_for_async = uvm_reg_field::type_id::create("cfg_rx_lat_bit_for_async");
         // configure
         cfg_rx_lat_bit_for_async.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_sel_rxbit_adder = uvm_reg_field::type_id::create("cfg_sel_rxbit_adder");
         // configure
         cfg_sel_rxbit_adder.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (11),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (11'b00000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm  )

      rand uvm_reg_field cfg_rxbit_rollover;
      rand uvm_reg_field cfg_latpls_bw;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rxbit_rollover_value : coverpoint cfg_rxbit_rollover.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_latpls_bw_value : coverpoint cfg_latpls_bw.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[12'h0:12'hfff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rxbit_rollover = uvm_reg_field::type_id::create("cfg_rxbit_rollover");
         // configure
         cfg_rxbit_rollover.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_latpls_bw = uvm_reg_field::type_id::create("cfg_latpls_bw");
         // configure
         cfg_latpls_bw.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (12),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (12'b000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm  )

      rand uvm_reg_field cfg_rx_lat_bit_for_async;
      rand uvm_reg_field cfg_sel_rxbit_adder;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rx_lat_bit_for_async_value : coverpoint cfg_rx_lat_bit_for_async.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_sel_rxbit_adder_value : coverpoint cfg_sel_rxbit_adder.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[11'h0:11'h7ff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rx_lat_bit_for_async = uvm_reg_field::type_id::create("cfg_rx_lat_bit_for_async");
         // configure
         cfg_rx_lat_bit_for_async.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_sel_rxbit_adder = uvm_reg_field::type_id::create("cfg_sel_rxbit_adder");
         // configure
         cfg_sel_rxbit_adder.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (11),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (11'b00000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm  )

      rand uvm_reg_field cfg_rxbit_rollover;
      rand uvm_reg_field cfg_latpls_bw;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rxbit_rollover_value : coverpoint cfg_rxbit_rollover.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_latpls_bw_value : coverpoint cfg_latpls_bw.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[12'h0:12'hfff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rxbit_rollover = uvm_reg_field::type_id::create("cfg_rxbit_rollover");
         // configure
         cfg_rxbit_rollover.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_latpls_bw = uvm_reg_field::type_id::create("cfg_latpls_bw");
         // configure
         cfg_latpls_bw.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (12),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (12'b000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm  )

      rand uvm_reg_field cfg_rx_lat_bit_for_async;
      rand uvm_reg_field cfg_sel_rxbit_adder;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rx_lat_bit_for_async_value : coverpoint cfg_rx_lat_bit_for_async.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_sel_rxbit_adder_value : coverpoint cfg_sel_rxbit_adder.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[11'h0:11'h7ff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rx_lat_bit_for_async = uvm_reg_field::type_id::create("cfg_rx_lat_bit_for_async");
         // configure
         cfg_rx_lat_bit_for_async.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_sel_rxbit_adder = uvm_reg_field::type_id::create("cfg_sel_rxbit_adder");
         // configure
         cfg_sel_rxbit_adder.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (11),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (11'b00000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm  )

      rand uvm_reg_field cfg_rxbit_rollover;
      rand uvm_reg_field cfg_latpls_bw;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rxbit_rollover_value : coverpoint cfg_rxbit_rollover.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_latpls_bw_value : coverpoint cfg_latpls_bw.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[12'h0:12'hfff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rxbit_rollover = uvm_reg_field::type_id::create("cfg_rxbit_rollover");
         // configure
         cfg_rxbit_rollover.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_latpls_bw = uvm_reg_field::type_id::create("cfg_latpls_bw");
         // configure
         cfg_latpls_bw.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (12),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (12'b000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm  )

      rand uvm_reg_field cfg_rst_rxbit_cntr_l0;
      rand uvm_reg_field cfg_rxbit_cntr_pma_l0;
      rand uvm_reg_field cfg_rst_rxbit_cntr_l1;
      rand uvm_reg_field cfg_rxbit_cntr_pma_l1;
      rand uvm_reg_field cfg_rst_rxbit_cntr_l2;
      rand uvm_reg_field cfg_rxbit_cntr_pma_l2;
      rand uvm_reg_field cfg_rst_rxbit_cntr_l3;
      rand uvm_reg_field cfg_rxbit_cntr_pma_l3;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rst_rxbit_cntr_l0_value : coverpoint cfg_rst_rxbit_cntr_l0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rxbit_cntr_pma_l0_value : coverpoint cfg_rxbit_cntr_pma_l0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rst_rxbit_cntr_l1_value : coverpoint cfg_rst_rxbit_cntr_l1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rxbit_cntr_pma_l1_value : coverpoint cfg_rxbit_cntr_pma_l1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rst_rxbit_cntr_l2_value : coverpoint cfg_rst_rxbit_cntr_l2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rxbit_cntr_pma_l2_value : coverpoint cfg_rxbit_cntr_pma_l2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rst_rxbit_cntr_l3_value : coverpoint cfg_rst_rxbit_cntr_l3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rxbit_cntr_pma_l3_value : coverpoint cfg_rxbit_cntr_pma_l3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rst_rxbit_cntr_l0 = uvm_reg_field::type_id::create("cfg_rst_rxbit_cntr_l0");
         // configure
         cfg_rst_rxbit_cntr_l0.configure(
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
         cfg_rxbit_cntr_pma_l0 = uvm_reg_field::type_id::create("cfg_rxbit_cntr_pma_l0");
         // configure
         cfg_rxbit_cntr_pma_l0.configure(
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
         cfg_rst_rxbit_cntr_l1 = uvm_reg_field::type_id::create("cfg_rst_rxbit_cntr_l1");
         // configure
         cfg_rst_rxbit_cntr_l1.configure(
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
         cfg_rxbit_cntr_pma_l1 = uvm_reg_field::type_id::create("cfg_rxbit_cntr_pma_l1");
         // configure
         cfg_rxbit_cntr_pma_l1.configure(
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
         cfg_rst_rxbit_cntr_l2 = uvm_reg_field::type_id::create("cfg_rst_rxbit_cntr_l2");
         // configure
         cfg_rst_rxbit_cntr_l2.configure(
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
         cfg_rxbit_cntr_pma_l2 = uvm_reg_field::type_id::create("cfg_rxbit_cntr_pma_l2");
         // configure
         cfg_rxbit_cntr_pma_l2.configure(
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
         cfg_rst_rxbit_cntr_l3 = uvm_reg_field::type_id::create("cfg_rst_rxbit_cntr_l3");
         // configure
         cfg_rst_rxbit_cntr_l3.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rxbit_cntr_pma_l3 = uvm_reg_field::type_id::create("cfg_rxbit_cntr_pma_l3");
         // configure
         cfg_rxbit_cntr_pma_l3.configure(
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
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (24),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (24'b000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm  )

      rand uvm_reg_field cfg_dfd_clk_sel;
      rand uvm_reg_field cfg_clk_en_dfd_clk;
      rand uvm_reg_field cfg_dfd_mux_sel;
      rand uvm_reg_field cfg_dfd_extrig_muxsel;
      rand uvm_reg_field cfg_dfd_rsvd_muxsel;
      rand uvm_reg_field cfg_pattern_cntr_rst_b;
      rand uvm_reg_field cfg_pattern_cntr_data_sel;
      rand uvm_reg_field cfg_pattern_cntr_inc;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_dfd_clk_sel_value : coverpoint cfg_dfd_clk_sel.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_clk_en_dfd_clk_value : coverpoint cfg_clk_en_dfd_clk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dfd_mux_sel_value : coverpoint cfg_dfd_mux_sel.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_dfd_extrig_muxsel_value : coverpoint cfg_dfd_extrig_muxsel.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_dfd_rsvd_muxsel_value : coverpoint cfg_dfd_rsvd_muxsel.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_pattern_cntr_rst_b_value : coverpoint cfg_pattern_cntr_rst_b.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_pattern_cntr_data_sel_value : coverpoint cfg_pattern_cntr_data_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_pattern_cntr_inc_value : coverpoint cfg_pattern_cntr_inc.value {
             bins all[8] = {[9'h0:9'h1ff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_dfd_clk_sel = uvm_reg_field::type_id::create("cfg_dfd_clk_sel");
         // configure
         cfg_dfd_clk_sel.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_dfd_clk = uvm_reg_field::type_id::create("cfg_clk_en_dfd_clk");
         // configure
         cfg_clk_en_dfd_clk.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_dfd_mux_sel = uvm_reg_field::type_id::create("cfg_dfd_mux_sel");
         // configure
         cfg_dfd_mux_sel.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_dfd_extrig_muxsel = uvm_reg_field::type_id::create("cfg_dfd_extrig_muxsel");
         // configure
         cfg_dfd_extrig_muxsel.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_dfd_rsvd_muxsel = uvm_reg_field::type_id::create("cfg_dfd_rsvd_muxsel");
         // configure
         cfg_dfd_rsvd_muxsel.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_pattern_cntr_rst_b = uvm_reg_field::type_id::create("cfg_pattern_cntr_rst_b");
         // configure
         cfg_pattern_cntr_rst_b.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_pattern_cntr_data_sel = uvm_reg_field::type_id::create("cfg_pattern_cntr_data_sel");
         // configure
         cfg_pattern_cntr_data_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_pattern_cntr_inc = uvm_reg_field::type_id::create("cfg_pattern_cntr_inc");
         // configure
         cfg_pattern_cntr_inc.configure(
         .parent                 ( this ),
         .size                   (9),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (9'b000001111),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm  )

      rand uvm_reg_field cfg_rst_dfd_extrig_cntr;
      rand uvm_reg_field cfg_apb_rdata_sel;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rst_dfd_extrig_cntr_value : coverpoint cfg_rst_dfd_extrig_cntr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_apb_rdata_sel_value : coverpoint cfg_apb_rdata_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[30'h0:30'h3fffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rst_dfd_extrig_cntr = uvm_reg_field::type_id::create("cfg_rst_dfd_extrig_cntr");
         // configure
         cfg_rst_dfd_extrig_cntr.configure(
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
         cfg_apb_rdata_sel = uvm_reg_field::type_id::create("cfg_apb_rdata_sel");
         // configure
         cfg_apb_rdata_sel.configure(
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
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (30),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (30'b000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm  )

      rand uvm_reg_field cfg_rst_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rst_value_value : coverpoint cfg_rst_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rst_value = uvm_reg_field::type_id::create("cfg_rst_value");
         // configure
         cfg_rst_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm  )

      rand uvm_reg_field cfg_mapped_base;
      rand uvm_reg_field cfg_unmapped_base;
      rand uvm_reg_field cfg_fw_load_mode;
      rand uvm_reg_field cfg_fw_load_disable;
      rand uvm_reg_field cfg_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_mapped_base_value : coverpoint cfg_mapped_base.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_unmapped_base_value : coverpoint cfg_unmapped_base.value {
             bins all[8] = {[18'h0:18'h3ffff]};
             illegal_bins bad = default;
          }
          cfg_fw_load_mode_value : coverpoint cfg_fw_load_mode.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_fw_load_disable_value : coverpoint cfg_fw_load_disable.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_reserved_value : coverpoint cfg_reserved.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_mapped_base = uvm_reg_field::type_id::create("cfg_mapped_base");
         // configure
         cfg_mapped_base.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b1010),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_unmapped_base = uvm_reg_field::type_id::create("cfg_unmapped_base");
         // configure
         cfg_unmapped_base.configure(
         .parent                 ( this ),
         .size                   (18),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (18'b000100000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_fw_load_mode = uvm_reg_field::type_id::create("cfg_fw_load_mode");
         // configure
         cfg_fw_load_mode.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_fw_load_disable = uvm_reg_field::type_id::create("cfg_fw_load_disable");
         // configure
         cfg_fw_load_disable.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_reserved = uvm_reg_field::type_id::create("cfg_reserved");
         // configure
         cfg_reserved.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (24),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000001000011110100100000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000001001011110100100000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000001010011110100100000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm  )

      rand uvm_reg_field cfg_value;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_value_value : coverpoint cfg_value.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_value = uvm_reg_field::type_id::create("cfg_value");
         // configure
         cfg_value.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000001011011110100100000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm  )

      rand uvm_reg_field cfg_size;
      rand uvm_reg_field cfg_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_size_value : coverpoint cfg_size.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_reserved_value : coverpoint cfg_reserved.value {
             bins all[8] = {[28'h0:28'hfffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_size = uvm_reg_field::type_id::create("cfg_size");
         // configure
         cfg_size.configure(
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
         cfg_reserved = uvm_reg_field::type_id::create("cfg_reserved");
         // configure
         cfg_reserved.configure(
         .parent                 ( this ),
         .size                   (28),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (28'b0000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm  )

      rand uvm_reg_field cfg_size;
      rand uvm_reg_field cfg_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_size_value : coverpoint cfg_size.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_reserved_value : coverpoint cfg_reserved.value {
             bins all[8] = {[28'h0:28'hfffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_size = uvm_reg_field::type_id::create("cfg_size");
         // configure
         cfg_size.configure(
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
         cfg_reserved = uvm_reg_field::type_id::create("cfg_reserved");
         // configure
         cfg_reserved.configure(
         .parent                 ( this ),
         .size                   (28),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (28'b0000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm  )

      rand uvm_reg_field cfg_size;
      rand uvm_reg_field cfg_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_size_value : coverpoint cfg_size.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_reserved_value : coverpoint cfg_reserved.value {
             bins all[8] = {[28'h0:28'hfffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_size = uvm_reg_field::type_id::create("cfg_size");
         // configure
         cfg_size.configure(
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
         cfg_reserved = uvm_reg_field::type_id::create("cfg_reserved");
         // configure
         cfg_reserved.configure(
         .parent                 ( this ),
         .size                   (28),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (28'b0000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm  )

      rand uvm_reg_field cfg_size;
      rand uvm_reg_field cfg_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_size_value : coverpoint cfg_size.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_reserved_value : coverpoint cfg_reserved.value {
             bins all[8] = {[28'h0:28'hfffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_size = uvm_reg_field::type_id::create("cfg_size");
         // configure
         cfg_size.configure(
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
         cfg_reserved = uvm_reg_field::type_id::create("cfg_reserved");
         // configure
         cfg_reserved.configure(
         .parent                 ( this ),
         .size                   (28),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (28'b0000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm  )

      rand uvm_reg_field cfg_ctrl;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_ctrl_value : coverpoint cfg_ctrl.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_ctrl = uvm_reg_field::type_id::create("cfg_ctrl");
         // configure
         cfg_ctrl.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm  )

      rand uvm_reg_field status_busy;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          status_busy_value : coverpoint status_busy.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         status_busy = uvm_reg_field::type_id::create("status_busy");
         // configure
         status_busy.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm  )

      rand uvm_reg_field cfg_restart_seq_sm;
      rand uvm_reg_field cfg_skip_rd_seq;
      rand uvm_reg_field cfg_ctrl_reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_restart_seq_sm_value : coverpoint cfg_restart_seq_sm.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_skip_rd_seq_value : coverpoint cfg_skip_rd_seq.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_ctrl_reserved_value : coverpoint cfg_ctrl_reserved.value {
             bins all[8] = {[30'h0:30'h3fffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_restart_seq_sm = uvm_reg_field::type_id::create("cfg_restart_seq_sm");
         // configure
         cfg_restart_seq_sm.configure(
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
         cfg_skip_rd_seq = uvm_reg_field::type_id::create("cfg_skip_rd_seq");
         // configure
         cfg_skip_rd_seq.configure(
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
         cfg_ctrl_reserved = uvm_reg_field::type_id::create("cfg_ctrl_reserved");
         // configure
         cfg_ctrl_reserved.configure(
         .parent                 ( this ),
         .size                   (30),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (30'b000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm  )

      rand uvm_reg_field cfg_seqen_0to31;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seqen_0to31_value : coverpoint cfg_seqen_0to31.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seqen_0to31 = uvm_reg_field::type_id::create("cfg_seqen_0to31");
         // configure
         cfg_seqen_0to31.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm  )

      rand uvm_reg_field cfg_seqen_32to63;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seqen_32to63_value : coverpoint cfg_seqen_32to63.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seqen_32to63 = uvm_reg_field::type_id::create("cfg_seqen_32to63");
         // configure
         cfg_seqen_32to63.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm  )

      rand uvm_reg_field cfg_seq_rdwrb_0to31;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdwrb_0to31_value : coverpoint cfg_seq_rdwrb_0to31.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdwrb_0to31 = uvm_reg_field::type_id::create("cfg_seq_rdwrb_0to31");
         // configure
         cfg_seq_rdwrb_0to31.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm  )

      rand uvm_reg_field cfg_seq_rdwrb_32to63;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdwrb_32to63_value : coverpoint cfg_seq_rdwrb_32to63.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdwrb_32to63 = uvm_reg_field::type_id::create("cfg_seq_rdwrb_32to63");
         // configure
         cfg_seq_rdwrb_32to63.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm  )

      rand uvm_reg_field cfg_seq_data;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_data_value : coverpoint cfg_seq_data.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_data = uvm_reg_field::type_id::create("cfg_seq_data");
         // configure
         cfg_seq_data.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm  )

      rand uvm_reg_field cfg_seq_addr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_addr_value : coverpoint cfg_seq_addr.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_addr = uvm_reg_field::type_id::create("cfg_seq_addr");
         // configure
         cfg_seq_addr.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm  )

      rand uvm_reg_field cfg_seq_rdata_unmask;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_seq_rdata_unmask_value : coverpoint cfg_seq_rdata_unmask.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_seq_rdata_unmask = uvm_reg_field::type_id::create("cfg_seq_rdata_unmask");
         // configure
         cfg_seq_rdata_unmask.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (32'b00000000000000000000000000000000),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field send_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          send_msg_value : coverpoint send_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         send_msg = uvm_reg_field::type_id::create("send_msg");
         // configure
         send_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field new_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          new_msg_value : coverpoint new_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         new_msg = uvm_reg_field::type_id::create("new_msg");
         // configure
         new_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field send_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          send_msg_value : coverpoint send_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         send_msg = uvm_reg_field::type_id::create("send_msg");
         // configure
         send_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field new_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          new_msg_value : coverpoint new_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         new_msg = uvm_reg_field::type_id::create("new_msg");
         // configure
         new_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field send_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          send_msg_value : coverpoint send_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         send_msg = uvm_reg_field::type_id::create("send_msg");
         // configure
         send_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field new_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          new_msg_value : coverpoint new_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         new_msg = uvm_reg_field::type_id::create("new_msg");
         // configure
         new_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field send_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          send_msg_value : coverpoint send_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         send_msg = uvm_reg_field::type_id::create("send_msg");
         // configure
         send_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm  )

      rand uvm_reg_field msg;
      rand uvm_reg_field new_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          msg_value : coverpoint msg.value {
             bins all[8] = {[31'h0:31'h7fffffff]};
             illegal_bins bad = default;
          }
          new_msg_value : coverpoint new_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         msg = uvm_reg_field::type_id::create("msg");
         // configure
         msg.configure(
         .parent                 ( this ),
         .size                   (31),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (31'b0000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         new_msg = uvm_reg_field::type_id::create("new_msg");
         // configure
         new_msg.configure(
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm

/*-----------------------------------------------------------------------------------------------
---  gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm  extends uvm_reg;

      `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm  )

      rand uvm_reg_field cfg_lane_number;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_lane_number_value : coverpoint cfg_lane_number.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_lane_number = uvm_reg_field::type_id::create("cfg_lane_number");
         // configure
         cfg_lane_number.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (0),
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
      
endclass : gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm


/*-----------------------------------------------------------------------------------------------
--- gdr_ux_quad_avmm_cfgcsr Block Definition : 
-----------------------------------------------------------------------------------------------*/
class gdr_ux_quad_avmm_cfgcsr_urm  extends  uvm_reg_block;

       `uvm_object_utils(gdr_ux_quad_avmm_cfgcsr_urm  )

      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm  ux_q_mode_ctrl;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm  ux_q_bonding_ctrl;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm  ux_q_datapath_loopback_en;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm  ux_q_ck_gating_ctrl;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm  ux_q_dl_ctrl_a_l0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm  ux_q_dl_ctrl_b_l0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm  ux_q_dl_ctrl_a_l1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm  ux_q_dl_ctrl_b_l1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm  ux_q_dl_ctrl_a_l2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm  ux_q_dl_ctrl_b_l2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm  ux_q_dl_ctrl_a_l3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm  ux_q_dl_ctrl_b_l3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm  ux_q_dl_ctrl;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm  ux_q_dfd_ctrl_a;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm  ux_q_dfd_ctrl_b;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm  ux_q_rst_value_pre_user_mode;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm  ux_q_dpma_clk_mux;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm  ux0_static_ctrl_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm  ux0_static_ctrl_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm  ux0_static_ctrl_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm  ux1_static_ctrl_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm  ux1_static_ctrl_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm  ux1_static_ctrl_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm  ux2_static_ctrl_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm  ux2_static_ctrl_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm  ux2_static_ctrl_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm  ux3_static_ctrl_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm  ux3_static_ctrl_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm  ux3_static_ctrl_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm  ux0_static_ctrl_user_mode_enable_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm  ux0_static_ctrl_user_mode_enable_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm  ux0_static_ctrl_user_mode_enable_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm  ux1_static_ctrl_user_mode_enable_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm  ux1_static_ctrl_user_mode_enable_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm  ux1_static_ctrl_user_mode_enable_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm  ux2_static_ctrl_user_mode_enable_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm  ux2_static_ctrl_user_mode_enable_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm  ux2_static_ctrl_user_mode_enable_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm  ux3_static_ctrl_user_mode_enable_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm  ux3_static_ctrl_user_mode_enable_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm  ux3_static_ctrl_user_mode_enable_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm  ux0_static_ctrl_user_mode_override_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm  ux0_static_ctrl_user_mode_override_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm  ux0_static_ctrl_user_mode_override_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm  ux1_static_ctrl_user_mode_override_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm  ux1_static_ctrl_user_mode_override_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm  ux1_static_ctrl_user_mode_override_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm  ux2_static_ctrl_user_mode_override_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm  ux2_static_ctrl_user_mode_override_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm  ux2_static_ctrl_user_mode_override_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm  ux3_static_ctrl_user_mode_override_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm  ux3_static_ctrl_user_mode_override_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm  ux3_static_ctrl_user_mode_override_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm  ux_q_indirect_access_ctrl;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm  ux_q_fw_load_base_l0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm  ux_q_fw_load_base_l1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm  ux_q_fw_load_base_l2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm  ux_q_fw_load_base_l3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm  ux0_bonding_size;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm  ux1_bonding_size;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm  ux2_bonding_size;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm  ux3_bonding_size;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm  ux_q_cpi_seq_ctrl;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm  ux_q_cpi_seq_status;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm  ux_q_seq_ctrl_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm  ux_q_seq_ctrl_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm  ux_q_seq_ctrl_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm  ux_q_seq_ctrl_3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm  ux_q_seq_ctrl_4;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm  ux_q_seq_data_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm  ux_q_seq_data_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm  ux_q_seq_data_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm  ux_q_seq_data_3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm  ux_q_seq_data_4;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm  ux_q_seq_data_5;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm  ux_q_seq_data_6;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm  ux_q_seq_data_7;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm  ux_q_seq_data_8;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm  ux_q_seq_data_9;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm  ux_q_seq_data_10;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm  ux_q_seq_data_11;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm  ux_q_seq_data_12;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm  ux_q_seq_data_13;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm  ux_q_seq_data_14;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm  ux_q_seq_data_15;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm  ux_q_seq_data_16;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm  ux_q_seq_data_17;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm  ux_q_seq_data_18;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm  ux_q_seq_data_19;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm  ux_q_seq_data_20;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm  ux_q_seq_data_21;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm  ux_q_seq_data_22;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm  ux_q_seq_data_23;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm  ux_q_seq_data_24;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm  ux_q_seq_data_25;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm  ux_q_seq_data_26;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm  ux_q_seq_data_27;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm  ux_q_seq_data_28;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm  ux_q_seq_data_29;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm  ux_q_seq_data_30;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm  ux_q_seq_data_31;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm  ux_q_seq_data_32;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm  ux_q_seq_data_33;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm  ux_q_seq_data_34;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm  ux_q_seq_data_35;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm  ux_q_seq_data_36;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm  ux_q_seq_data_37;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm  ux_q_seq_data_38;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm  ux_q_seq_data_39;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm  ux_q_seq_data_40;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm  ux_q_seq_data_41;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm  ux_q_seq_data_42;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm  ux_q_seq_data_43;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm  ux_q_seq_data_44;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm  ux_q_seq_data_45;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm  ux_q_seq_data_46;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm  ux_q_seq_data_47;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm  ux_q_seq_data_48;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm  ux_q_seq_data_49;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm  ux_q_seq_data_50;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm  ux_q_seq_data_51;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm  ux_q_seq_data_52;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm  ux_q_seq_data_53;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm  ux_q_seq_data_54;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm  ux_q_seq_data_55;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm  ux_q_seq_data_56;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm  ux_q_seq_data_57;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm  ux_q_seq_data_58;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm  ux_q_seq_data_59;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm  ux_q_seq_data_60;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm  ux_q_seq_data_61;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm  ux_q_seq_data_62;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm  ux_q_seq_data_63;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm  ux_q_seq_addr_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm  ux_q_seq_addr_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm  ux_q_seq_addr_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm  ux_q_seq_addr_3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm  ux_q_seq_addr_4;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm  ux_q_seq_addr_5;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm  ux_q_seq_addr_6;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm  ux_q_seq_addr_7;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm  ux_q_seq_addr_8;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm  ux_q_seq_addr_9;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm  ux_q_seq_addr_10;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm  ux_q_seq_addr_11;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm  ux_q_seq_addr_12;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm  ux_q_seq_addr_13;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm  ux_q_seq_addr_14;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm  ux_q_seq_addr_15;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm  ux_q_seq_addr_16;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm  ux_q_seq_addr_17;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm  ux_q_seq_addr_18;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm  ux_q_seq_addr_19;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm  ux_q_seq_addr_20;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm  ux_q_seq_addr_21;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm  ux_q_seq_addr_22;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm  ux_q_seq_addr_23;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm  ux_q_seq_addr_24;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm  ux_q_seq_addr_25;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm  ux_q_seq_addr_26;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm  ux_q_seq_addr_27;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm  ux_q_seq_addr_28;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm  ux_q_seq_addr_29;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm  ux_q_seq_addr_30;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm  ux_q_seq_addr_31;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm  ux_q_seq_addr_32;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm  ux_q_seq_addr_33;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm  ux_q_seq_addr_34;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm  ux_q_seq_addr_35;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm  ux_q_seq_addr_36;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm  ux_q_seq_addr_37;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm  ux_q_seq_addr_38;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm  ux_q_seq_addr_39;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm  ux_q_seq_addr_40;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm  ux_q_seq_addr_41;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm  ux_q_seq_addr_42;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm  ux_q_seq_addr_43;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm  ux_q_seq_addr_44;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm  ux_q_seq_addr_45;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm  ux_q_seq_addr_46;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm  ux_q_seq_addr_47;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm  ux_q_seq_addr_48;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm  ux_q_seq_addr_49;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm  ux_q_seq_addr_50;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm  ux_q_seq_addr_51;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm  ux_q_seq_addr_52;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm  ux_q_seq_addr_53;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm  ux_q_seq_addr_54;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm  ux_q_seq_addr_55;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm  ux_q_seq_addr_56;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm  ux_q_seq_addr_57;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm  ux_q_seq_addr_58;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm  ux_q_seq_addr_59;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm  ux_q_seq_addr_60;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm  ux_q_seq_addr_61;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm  ux_q_seq_addr_62;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm  ux_q_seq_addr_63;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm  ux_q_seq_rdata_unmask_0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm  ux_q_seq_rdata_unmask_1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm  ux_q_seq_rdata_unmask_2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm  ux_q_seq_rdata_unmask_3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm  ux_q_seq_rdata_unmask_4;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm  ux_q_seq_rdata_unmask_5;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm  ux_q_seq_rdata_unmask_6;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm  ux_q_seq_rdata_unmask_7;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm  ux_q_seq_rdata_unmask_8;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm  ux_q_seq_rdata_unmask_9;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm  ux_q_seq_rdata_unmask_10;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm  ux_q_seq_rdata_unmask_11;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm  ux_q_seq_rdata_unmask_12;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm  ux_q_seq_rdata_unmask_13;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm  ux_q_seq_rdata_unmask_14;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm  ux_q_seq_rdata_unmask_15;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm  ux_q_seq_rdata_unmask_16;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm  ux_q_seq_rdata_unmask_17;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm  ux_q_seq_rdata_unmask_18;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm  ux_q_seq_rdata_unmask_19;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm  ux_q_seq_rdata_unmask_20;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm  ux_q_seq_rdata_unmask_21;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm  ux_q_seq_rdata_unmask_22;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm  ux_q_seq_rdata_unmask_23;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm  ux_q_seq_rdata_unmask_24;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm  ux_q_seq_rdata_unmask_25;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm  ux_q_seq_rdata_unmask_26;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm  ux_q_seq_rdata_unmask_27;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm  ux_q_seq_rdata_unmask_28;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm  ux_q_seq_rdata_unmask_29;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm  ux_q_seq_rdata_unmask_30;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm  ux_q_seq_rdata_unmask_31;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm  ux_q_seq_rdata_unmask_32;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm  ux_q_seq_rdata_unmask_33;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm  ux_q_seq_rdata_unmask_34;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm  ux_q_seq_rdata_unmask_35;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm  ux_q_seq_rdata_unmask_36;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm  ux_q_seq_rdata_unmask_37;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm  ux_q_seq_rdata_unmask_38;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm  ux_q_seq_rdata_unmask_39;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm  ux_q_seq_rdata_unmask_40;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm  ux_q_seq_rdata_unmask_41;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm  ux_q_seq_rdata_unmask_42;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm  ux_q_seq_rdata_unmask_43;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm  ux_q_seq_rdata_unmask_44;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm  ux_q_seq_rdata_unmask_45;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm  ux_q_seq_rdata_unmask_46;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm  ux_q_seq_rdata_unmask_47;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm  ux_q_seq_rdata_unmask_48;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm  ux_q_seq_rdata_unmask_49;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm  ux_q_seq_rdata_unmask_50;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm  ux_q_seq_rdata_unmask_51;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm  ux_q_seq_rdata_unmask_52;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm  ux_q_seq_rdata_unmask_53;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm  ux_q_seq_rdata_unmask_54;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm  ux_q_seq_rdata_unmask_55;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm  ux_q_seq_rdata_unmask_56;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm  ux_q_seq_rdata_unmask_57;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm  ux_q_seq_rdata_unmask_58;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm  ux_q_seq_rdata_unmask_59;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm  ux_q_seq_rdata_unmask_60;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm  ux_q_seq_rdata_unmask_61;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm  ux_q_seq_rdata_unmask_62;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm  ux_q_seq_rdata_unmask_63;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm  ux_q_mailbox_in_l0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm  ux_q_mailbox_out_l0;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm  ux_q_mailbox_in_l1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm  ux_q_mailbox_out_l1;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm  ux_q_mailbox_in_l2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm  ux_q_mailbox_out_l2;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm  ux_q_mailbox_in_l3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm  ux_q_mailbox_out_l3;
      rand gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm  ux_q_lane_number;
      
      // uvm_reg_map _map;

      //Constructor
      function new(string name = "gdr_ux_quad_avmm_cfgcsr_urm");
         super.new(name,build_coverage(UVM_CVR_ALL));
         endfunction : new

      //Build
      virtual function void build();
         
         // Create registers
         ux_q_mode_ctrl = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mode_ctrl_urm::type_id::create("ux_q_mode_ctrl");
         ux_q_mode_ctrl.configure(this,null,"");
         ux_q_mode_ctrl.build();
         // hdl path
         ux_q_mode_ctrl.add_hdl_path_slice("ux_q_mode_ctrl_cfg_func_mode_l0",0,3);
         ux_q_mode_ctrl.add_hdl_path_slice("ux_q_mode_ctrl_cfg_func_mode_l1",3,3);
         ux_q_mode_ctrl.add_hdl_path_slice("ux_q_mode_ctrl_cfg_func_mode_l2",6,3);
         ux_q_mode_ctrl.add_hdl_path_slice("ux_q_mode_ctrl_cfg_func_mode_l3",9,3);
         ux_q_mode_ctrl.add_hdl_path_slice("ux_q_mode_ctrl_cfg_func_mode_reserved",12,20);
         
         // Create registers
         ux_q_bonding_ctrl = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_bonding_ctrl_urm::type_id::create("ux_q_bonding_ctrl");
         ux_q_bonding_ctrl.configure(this,null,"");
         ux_q_bonding_ctrl.build();
         // hdl path
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_ctrl_l0",0,4);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_ctrl_l1",4,4);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_ctrl_l2",8,4);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_ctrl_l3",12,4);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_enable_l0",16,1);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_enable_l1",17,1);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_enable_l2",18,1);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_enable_l3",19,1);
         ux_q_bonding_ctrl.add_hdl_path_slice("ux_q_bonding_ctrl_cfg_bonding_ctrl_reserved",20,12);
         
         // Create registers
         ux_q_datapath_loopback_en = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_datapath_loopback_en_urm::type_id::create("ux_q_datapath_loopback_en");
         ux_q_datapath_loopback_en.configure(this,null,"");
         ux_q_datapath_loopback_en.build();
         // hdl path
         ux_q_datapath_loopback_en.add_hdl_path_slice("ux_q_datapath_loopback_en_cfg_datapath_loopback_en_l0",0,1);
         ux_q_datapath_loopback_en.add_hdl_path_slice("ux_q_datapath_loopback_en_cfg_datapath_loopback_en_l1",1,1);
         ux_q_datapath_loopback_en.add_hdl_path_slice("ux_q_datapath_loopback_en_cfg_datapath_loopback_en_l2",2,1);
         ux_q_datapath_loopback_en.add_hdl_path_slice("ux_q_datapath_loopback_en_cfg_datapath_loopback_en_l3",3,1);
         ux_q_datapath_loopback_en.add_hdl_path_slice("ux_q_datapath_loopback_en_cfg_datapath_loopback_en_reserved",4,28);
         
         // Create registers
         ux_q_ck_gating_ctrl = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_ck_gating_ctrl_urm::type_id::create("ux_q_ck_gating_ctrl");
         ux_q_ck_gating_ctrl.configure(this,null,"");
         ux_q_ck_gating_ctrl.build();
         // hdl path
         ux_q_ck_gating_ctrl.add_hdl_path_slice("ux_q_ck_gating_ctrl_cfg_ck_gating_ctrl",0,32);
         
         // Create registers
         ux_q_dl_ctrl_a_l0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l0_urm::type_id::create("ux_q_dl_ctrl_a_l0");
         ux_q_dl_ctrl_a_l0.configure(this,null,"");
         ux_q_dl_ctrl_a_l0.build();
         // hdl path
         ux_q_dl_ctrl_a_l0.add_hdl_path_slice("ux_q_dl_ctrl_a_l0_cfg_rx_lat_bit_for_async",0,18);
         ux_q_dl_ctrl_a_l0.add_hdl_path_slice("ux_q_dl_ctrl_a_l0_cfg_sel_rxbit_adder",18,3);
         ux_q_dl_ctrl_a_l0.add_hdl_path_slice("ux_q_dl_ctrl_a_l0_cfg_ctrl_reserved",21,11);
         
         // Create registers
         ux_q_dl_ctrl_b_l0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l0_urm::type_id::create("ux_q_dl_ctrl_b_l0");
         ux_q_dl_ctrl_b_l0.configure(this,null,"");
         ux_q_dl_ctrl_b_l0.build();
         // hdl path
         ux_q_dl_ctrl_b_l0.add_hdl_path_slice("ux_q_dl_ctrl_b_l0_cfg_rxbit_rollover",0,18);
         ux_q_dl_ctrl_b_l0.add_hdl_path_slice("ux_q_dl_ctrl_b_l0_cfg_latpls_bw",18,2);
         ux_q_dl_ctrl_b_l0.add_hdl_path_slice("ux_q_dl_ctrl_b_l0_cfg_ctrl_reserved",20,12);
         
         // Create registers
         ux_q_dl_ctrl_a_l1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l1_urm::type_id::create("ux_q_dl_ctrl_a_l1");
         ux_q_dl_ctrl_a_l1.configure(this,null,"");
         ux_q_dl_ctrl_a_l1.build();
         // hdl path
         ux_q_dl_ctrl_a_l1.add_hdl_path_slice("ux_q_dl_ctrl_a_l1_cfg_rx_lat_bit_for_async",0,18);
         ux_q_dl_ctrl_a_l1.add_hdl_path_slice("ux_q_dl_ctrl_a_l1_cfg_sel_rxbit_adder",18,3);
         ux_q_dl_ctrl_a_l1.add_hdl_path_slice("ux_q_dl_ctrl_a_l1_cfg_ctrl_reserved",21,11);
         
         // Create registers
         ux_q_dl_ctrl_b_l1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l1_urm::type_id::create("ux_q_dl_ctrl_b_l1");
         ux_q_dl_ctrl_b_l1.configure(this,null,"");
         ux_q_dl_ctrl_b_l1.build();
         // hdl path
         ux_q_dl_ctrl_b_l1.add_hdl_path_slice("ux_q_dl_ctrl_b_l1_cfg_rxbit_rollover",0,18);
         ux_q_dl_ctrl_b_l1.add_hdl_path_slice("ux_q_dl_ctrl_b_l1_cfg_latpls_bw",18,2);
         ux_q_dl_ctrl_b_l1.add_hdl_path_slice("ux_q_dl_ctrl_b_l1_cfg_ctrl_reserved",20,12);
         
         // Create registers
         ux_q_dl_ctrl_a_l2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l2_urm::type_id::create("ux_q_dl_ctrl_a_l2");
         ux_q_dl_ctrl_a_l2.configure(this,null,"");
         ux_q_dl_ctrl_a_l2.build();
         // hdl path
         ux_q_dl_ctrl_a_l2.add_hdl_path_slice("ux_q_dl_ctrl_a_l2_cfg_rx_lat_bit_for_async",0,18);
         ux_q_dl_ctrl_a_l2.add_hdl_path_slice("ux_q_dl_ctrl_a_l2_cfg_sel_rxbit_adder",18,3);
         ux_q_dl_ctrl_a_l2.add_hdl_path_slice("ux_q_dl_ctrl_a_l2_cfg_ctrl_reserved",21,11);
         
         // Create registers
         ux_q_dl_ctrl_b_l2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l2_urm::type_id::create("ux_q_dl_ctrl_b_l2");
         ux_q_dl_ctrl_b_l2.configure(this,null,"");
         ux_q_dl_ctrl_b_l2.build();
         // hdl path
         ux_q_dl_ctrl_b_l2.add_hdl_path_slice("ux_q_dl_ctrl_b_l2_cfg_rxbit_rollover",0,18);
         ux_q_dl_ctrl_b_l2.add_hdl_path_slice("ux_q_dl_ctrl_b_l2_cfg_latpls_bw",18,2);
         ux_q_dl_ctrl_b_l2.add_hdl_path_slice("ux_q_dl_ctrl_b_l2_cfg_ctrl_reserved",20,12);
         
         // Create registers
         ux_q_dl_ctrl_a_l3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_a_l3_urm::type_id::create("ux_q_dl_ctrl_a_l3");
         ux_q_dl_ctrl_a_l3.configure(this,null,"");
         ux_q_dl_ctrl_a_l3.build();
         // hdl path
         ux_q_dl_ctrl_a_l3.add_hdl_path_slice("ux_q_dl_ctrl_a_l3_cfg_rx_lat_bit_for_async",0,18);
         ux_q_dl_ctrl_a_l3.add_hdl_path_slice("ux_q_dl_ctrl_a_l3_cfg_sel_rxbit_adder",18,3);
         ux_q_dl_ctrl_a_l3.add_hdl_path_slice("ux_q_dl_ctrl_a_l3_cfg_ctrl_reserved",21,11);
         
         // Create registers
         ux_q_dl_ctrl_b_l3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_b_l3_urm::type_id::create("ux_q_dl_ctrl_b_l3");
         ux_q_dl_ctrl_b_l3.configure(this,null,"");
         ux_q_dl_ctrl_b_l3.build();
         // hdl path
         ux_q_dl_ctrl_b_l3.add_hdl_path_slice("ux_q_dl_ctrl_b_l3_cfg_rxbit_rollover",0,18);
         ux_q_dl_ctrl_b_l3.add_hdl_path_slice("ux_q_dl_ctrl_b_l3_cfg_latpls_bw",18,2);
         ux_q_dl_ctrl_b_l3.add_hdl_path_slice("ux_q_dl_ctrl_b_l3_cfg_ctrl_reserved",20,12);
         
         // Create registers
         ux_q_dl_ctrl = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dl_ctrl_urm::type_id::create("ux_q_dl_ctrl");
         ux_q_dl_ctrl.configure(this,null,"");
         ux_q_dl_ctrl.build();
         // hdl path
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rst_rxbit_cntr_l0",0,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rxbit_cntr_pma_l0",1,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rst_rxbit_cntr_l1",2,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rxbit_cntr_pma_l1",3,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rst_rxbit_cntr_l2",4,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rxbit_cntr_pma_l2",5,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rst_rxbit_cntr_l3",6,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_rxbit_cntr_pma_l3",7,1);
         ux_q_dl_ctrl.add_hdl_path_slice("ux_q_dl_ctrl_cfg_ctrl_reserved",8,24);
         
         // Create registers
         ux_q_dfd_ctrl_a = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_a_urm::type_id::create("ux_q_dfd_ctrl_a");
         ux_q_dfd_ctrl_a.configure(this,null,"");
         ux_q_dfd_ctrl_a.build();
         // hdl path
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_dfd_clk_sel",0,5);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_clk_en_dfd_clk",5,1);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_dfd_mux_sel",6,5);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_dfd_extrig_muxsel",11,5);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_dfd_rsvd_muxsel",16,5);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_pattern_cntr_rst_b",21,1);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_pattern_cntr_data_sel",22,1);
         ux_q_dfd_ctrl_a.add_hdl_path_slice("ux_q_dfd_ctrl_a_cfg_pattern_cntr_inc",23,9);
         
         // Create registers
         ux_q_dfd_ctrl_b = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dfd_ctrl_b_urm::type_id::create("ux_q_dfd_ctrl_b");
         ux_q_dfd_ctrl_b.configure(this,null,"");
         ux_q_dfd_ctrl_b.build();
         // hdl path
         ux_q_dfd_ctrl_b.add_hdl_path_slice("ux_q_dfd_ctrl_b_cfg_rst_dfd_extrig_cntr",0,1);
         ux_q_dfd_ctrl_b.add_hdl_path_slice("ux_q_dfd_ctrl_b_cfg_apb_rdata_sel",1,1);
         ux_q_dfd_ctrl_b.add_hdl_path_slice("ux_q_dfd_ctrl_b_cfg_ctrl_reserved",2,30);
         
         // Create registers
         ux_q_rst_value_pre_user_mode = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_rst_value_pre_user_mode_urm::type_id::create("ux_q_rst_value_pre_user_mode");
         ux_q_rst_value_pre_user_mode.configure(this,null,"");
         ux_q_rst_value_pre_user_mode.build();
         // hdl path
         ux_q_rst_value_pre_user_mode.add_hdl_path_slice("ux_q_rst_value_pre_user_mode_cfg_rst_value",0,32);
         
         // Create registers
         ux_q_dpma_clk_mux = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_dpma_clk_mux_urm::type_id::create("ux_q_dpma_clk_mux");
         ux_q_dpma_clk_mux.configure(this,null,"");
         ux_q_dpma_clk_mux.build();
         // hdl path
         ux_q_dpma_clk_mux.add_hdl_path_slice("ux_q_dpma_clk_mux_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_0_urm::type_id::create("ux0_static_ctrl_0");
         ux0_static_ctrl_0.configure(this,null,"");
         ux0_static_ctrl_0.build();
         // hdl path
         ux0_static_ctrl_0.add_hdl_path_slice("ux0_static_ctrl_0_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_1_urm::type_id::create("ux0_static_ctrl_1");
         ux0_static_ctrl_1.configure(this,null,"");
         ux0_static_ctrl_1.build();
         // hdl path
         ux0_static_ctrl_1.add_hdl_path_slice("ux0_static_ctrl_1_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_2_urm::type_id::create("ux0_static_ctrl_2");
         ux0_static_ctrl_2.configure(this,null,"");
         ux0_static_ctrl_2.build();
         // hdl path
         ux0_static_ctrl_2.add_hdl_path_slice("ux0_static_ctrl_2_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_0_urm::type_id::create("ux1_static_ctrl_0");
         ux1_static_ctrl_0.configure(this,null,"");
         ux1_static_ctrl_0.build();
         // hdl path
         ux1_static_ctrl_0.add_hdl_path_slice("ux1_static_ctrl_0_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_1_urm::type_id::create("ux1_static_ctrl_1");
         ux1_static_ctrl_1.configure(this,null,"");
         ux1_static_ctrl_1.build();
         // hdl path
         ux1_static_ctrl_1.add_hdl_path_slice("ux1_static_ctrl_1_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_2_urm::type_id::create("ux1_static_ctrl_2");
         ux1_static_ctrl_2.configure(this,null,"");
         ux1_static_ctrl_2.build();
         // hdl path
         ux1_static_ctrl_2.add_hdl_path_slice("ux1_static_ctrl_2_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_0_urm::type_id::create("ux2_static_ctrl_0");
         ux2_static_ctrl_0.configure(this,null,"");
         ux2_static_ctrl_0.build();
         // hdl path
         ux2_static_ctrl_0.add_hdl_path_slice("ux2_static_ctrl_0_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_1_urm::type_id::create("ux2_static_ctrl_1");
         ux2_static_ctrl_1.configure(this,null,"");
         ux2_static_ctrl_1.build();
         // hdl path
         ux2_static_ctrl_1.add_hdl_path_slice("ux2_static_ctrl_1_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_2_urm::type_id::create("ux2_static_ctrl_2");
         ux2_static_ctrl_2.configure(this,null,"");
         ux2_static_ctrl_2.build();
         // hdl path
         ux2_static_ctrl_2.add_hdl_path_slice("ux2_static_ctrl_2_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_0_urm::type_id::create("ux3_static_ctrl_0");
         ux3_static_ctrl_0.configure(this,null,"");
         ux3_static_ctrl_0.build();
         // hdl path
         ux3_static_ctrl_0.add_hdl_path_slice("ux3_static_ctrl_0_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_1_urm::type_id::create("ux3_static_ctrl_1");
         ux3_static_ctrl_1.configure(this,null,"");
         ux3_static_ctrl_1.build();
         // hdl path
         ux3_static_ctrl_1.add_hdl_path_slice("ux3_static_ctrl_1_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_2_urm::type_id::create("ux3_static_ctrl_2");
         ux3_static_ctrl_2.configure(this,null,"");
         ux3_static_ctrl_2.build();
         // hdl path
         ux3_static_ctrl_2.add_hdl_path_slice("ux3_static_ctrl_2_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_user_mode_enable_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_0_urm::type_id::create("ux0_static_ctrl_user_mode_enable_0");
         ux0_static_ctrl_user_mode_enable_0.configure(this,null,"");
         ux0_static_ctrl_user_mode_enable_0.build();
         // hdl path
         ux0_static_ctrl_user_mode_enable_0.add_hdl_path_slice("ux0_static_ctrl_user_mode_enable_0_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_user_mode_enable_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_1_urm::type_id::create("ux0_static_ctrl_user_mode_enable_1");
         ux0_static_ctrl_user_mode_enable_1.configure(this,null,"");
         ux0_static_ctrl_user_mode_enable_1.build();
         // hdl path
         ux0_static_ctrl_user_mode_enable_1.add_hdl_path_slice("ux0_static_ctrl_user_mode_enable_1_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_user_mode_enable_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_enable_2_urm::type_id::create("ux0_static_ctrl_user_mode_enable_2");
         ux0_static_ctrl_user_mode_enable_2.configure(this,null,"");
         ux0_static_ctrl_user_mode_enable_2.build();
         // hdl path
         ux0_static_ctrl_user_mode_enable_2.add_hdl_path_slice("ux0_static_ctrl_user_mode_enable_2_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_user_mode_enable_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_0_urm::type_id::create("ux1_static_ctrl_user_mode_enable_0");
         ux1_static_ctrl_user_mode_enable_0.configure(this,null,"");
         ux1_static_ctrl_user_mode_enable_0.build();
         // hdl path
         ux1_static_ctrl_user_mode_enable_0.add_hdl_path_slice("ux1_static_ctrl_user_mode_enable_0_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_user_mode_enable_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_1_urm::type_id::create("ux1_static_ctrl_user_mode_enable_1");
         ux1_static_ctrl_user_mode_enable_1.configure(this,null,"");
         ux1_static_ctrl_user_mode_enable_1.build();
         // hdl path
         ux1_static_ctrl_user_mode_enable_1.add_hdl_path_slice("ux1_static_ctrl_user_mode_enable_1_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_user_mode_enable_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_enable_2_urm::type_id::create("ux1_static_ctrl_user_mode_enable_2");
         ux1_static_ctrl_user_mode_enable_2.configure(this,null,"");
         ux1_static_ctrl_user_mode_enable_2.build();
         // hdl path
         ux1_static_ctrl_user_mode_enable_2.add_hdl_path_slice("ux1_static_ctrl_user_mode_enable_2_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_user_mode_enable_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_0_urm::type_id::create("ux2_static_ctrl_user_mode_enable_0");
         ux2_static_ctrl_user_mode_enable_0.configure(this,null,"");
         ux2_static_ctrl_user_mode_enable_0.build();
         // hdl path
         ux2_static_ctrl_user_mode_enable_0.add_hdl_path_slice("ux2_static_ctrl_user_mode_enable_0_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_user_mode_enable_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_1_urm::type_id::create("ux2_static_ctrl_user_mode_enable_1");
         ux2_static_ctrl_user_mode_enable_1.configure(this,null,"");
         ux2_static_ctrl_user_mode_enable_1.build();
         // hdl path
         ux2_static_ctrl_user_mode_enable_1.add_hdl_path_slice("ux2_static_ctrl_user_mode_enable_1_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_user_mode_enable_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_enable_2_urm::type_id::create("ux2_static_ctrl_user_mode_enable_2");
         ux2_static_ctrl_user_mode_enable_2.configure(this,null,"");
         ux2_static_ctrl_user_mode_enable_2.build();
         // hdl path
         ux2_static_ctrl_user_mode_enable_2.add_hdl_path_slice("ux2_static_ctrl_user_mode_enable_2_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_user_mode_enable_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_0_urm::type_id::create("ux3_static_ctrl_user_mode_enable_0");
         ux3_static_ctrl_user_mode_enable_0.configure(this,null,"");
         ux3_static_ctrl_user_mode_enable_0.build();
         // hdl path
         ux3_static_ctrl_user_mode_enable_0.add_hdl_path_slice("ux3_static_ctrl_user_mode_enable_0_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_user_mode_enable_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_1_urm::type_id::create("ux3_static_ctrl_user_mode_enable_1");
         ux3_static_ctrl_user_mode_enable_1.configure(this,null,"");
         ux3_static_ctrl_user_mode_enable_1.build();
         // hdl path
         ux3_static_ctrl_user_mode_enable_1.add_hdl_path_slice("ux3_static_ctrl_user_mode_enable_1_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_user_mode_enable_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_enable_2_urm::type_id::create("ux3_static_ctrl_user_mode_enable_2");
         ux3_static_ctrl_user_mode_enable_2.configure(this,null,"");
         ux3_static_ctrl_user_mode_enable_2.build();
         // hdl path
         ux3_static_ctrl_user_mode_enable_2.add_hdl_path_slice("ux3_static_ctrl_user_mode_enable_2_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_user_mode_override_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_0_urm::type_id::create("ux0_static_ctrl_user_mode_override_0");
         ux0_static_ctrl_user_mode_override_0.configure(this,null,"");
         ux0_static_ctrl_user_mode_override_0.build();
         // hdl path
         ux0_static_ctrl_user_mode_override_0.add_hdl_path_slice("ux0_static_ctrl_user_mode_override_0_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_user_mode_override_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_1_urm::type_id::create("ux0_static_ctrl_user_mode_override_1");
         ux0_static_ctrl_user_mode_override_1.configure(this,null,"");
         ux0_static_ctrl_user_mode_override_1.build();
         // hdl path
         ux0_static_ctrl_user_mode_override_1.add_hdl_path_slice("ux0_static_ctrl_user_mode_override_1_cfg_value",0,32);
         
         // Create registers
         ux0_static_ctrl_user_mode_override_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux0_static_ctrl_user_mode_override_2_urm::type_id::create("ux0_static_ctrl_user_mode_override_2");
         ux0_static_ctrl_user_mode_override_2.configure(this,null,"");
         ux0_static_ctrl_user_mode_override_2.build();
         // hdl path
         ux0_static_ctrl_user_mode_override_2.add_hdl_path_slice("ux0_static_ctrl_user_mode_override_2_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_user_mode_override_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_0_urm::type_id::create("ux1_static_ctrl_user_mode_override_0");
         ux1_static_ctrl_user_mode_override_0.configure(this,null,"");
         ux1_static_ctrl_user_mode_override_0.build();
         // hdl path
         ux1_static_ctrl_user_mode_override_0.add_hdl_path_slice("ux1_static_ctrl_user_mode_override_0_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_user_mode_override_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_1_urm::type_id::create("ux1_static_ctrl_user_mode_override_1");
         ux1_static_ctrl_user_mode_override_1.configure(this,null,"");
         ux1_static_ctrl_user_mode_override_1.build();
         // hdl path
         ux1_static_ctrl_user_mode_override_1.add_hdl_path_slice("ux1_static_ctrl_user_mode_override_1_cfg_value",0,32);
         
         // Create registers
         ux1_static_ctrl_user_mode_override_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux1_static_ctrl_user_mode_override_2_urm::type_id::create("ux1_static_ctrl_user_mode_override_2");
         ux1_static_ctrl_user_mode_override_2.configure(this,null,"");
         ux1_static_ctrl_user_mode_override_2.build();
         // hdl path
         ux1_static_ctrl_user_mode_override_2.add_hdl_path_slice("ux1_static_ctrl_user_mode_override_2_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_user_mode_override_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_0_urm::type_id::create("ux2_static_ctrl_user_mode_override_0");
         ux2_static_ctrl_user_mode_override_0.configure(this,null,"");
         ux2_static_ctrl_user_mode_override_0.build();
         // hdl path
         ux2_static_ctrl_user_mode_override_0.add_hdl_path_slice("ux2_static_ctrl_user_mode_override_0_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_user_mode_override_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_1_urm::type_id::create("ux2_static_ctrl_user_mode_override_1");
         ux2_static_ctrl_user_mode_override_1.configure(this,null,"");
         ux2_static_ctrl_user_mode_override_1.build();
         // hdl path
         ux2_static_ctrl_user_mode_override_1.add_hdl_path_slice("ux2_static_ctrl_user_mode_override_1_cfg_value",0,32);
         
         // Create registers
         ux2_static_ctrl_user_mode_override_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux2_static_ctrl_user_mode_override_2_urm::type_id::create("ux2_static_ctrl_user_mode_override_2");
         ux2_static_ctrl_user_mode_override_2.configure(this,null,"");
         ux2_static_ctrl_user_mode_override_2.build();
         // hdl path
         ux2_static_ctrl_user_mode_override_2.add_hdl_path_slice("ux2_static_ctrl_user_mode_override_2_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_user_mode_override_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_0_urm::type_id::create("ux3_static_ctrl_user_mode_override_0");
         ux3_static_ctrl_user_mode_override_0.configure(this,null,"");
         ux3_static_ctrl_user_mode_override_0.build();
         // hdl path
         ux3_static_ctrl_user_mode_override_0.add_hdl_path_slice("ux3_static_ctrl_user_mode_override_0_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_user_mode_override_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_1_urm::type_id::create("ux3_static_ctrl_user_mode_override_1");
         ux3_static_ctrl_user_mode_override_1.configure(this,null,"");
         ux3_static_ctrl_user_mode_override_1.build();
         // hdl path
         ux3_static_ctrl_user_mode_override_1.add_hdl_path_slice("ux3_static_ctrl_user_mode_override_1_cfg_value",0,32);
         
         // Create registers
         ux3_static_ctrl_user_mode_override_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux3_static_ctrl_user_mode_override_2_urm::type_id::create("ux3_static_ctrl_user_mode_override_2");
         ux3_static_ctrl_user_mode_override_2.configure(this,null,"");
         ux3_static_ctrl_user_mode_override_2.build();
         // hdl path
         ux3_static_ctrl_user_mode_override_2.add_hdl_path_slice("ux3_static_ctrl_user_mode_override_2_cfg_value",0,32);
         
         // Create registers
         ux_q_indirect_access_ctrl = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_indirect_access_ctrl_urm::type_id::create("ux_q_indirect_access_ctrl");
         ux_q_indirect_access_ctrl.configure(this,null,"");
         ux_q_indirect_access_ctrl.build();
         // hdl path
         ux_q_indirect_access_ctrl.add_hdl_path_slice("ux_q_indirect_access_ctrl_cfg_mapped_base",0,4);
         ux_q_indirect_access_ctrl.add_hdl_path_slice("ux_q_indirect_access_ctrl_cfg_unmapped_base",4,18);
         ux_q_indirect_access_ctrl.add_hdl_path_slice("ux_q_indirect_access_ctrl_cfg_fw_load_mode",22,1);
         ux_q_indirect_access_ctrl.add_hdl_path_slice("ux_q_indirect_access_ctrl_cfg_fw_load_disable",23,1);
         ux_q_indirect_access_ctrl.add_hdl_path_slice("ux_q_indirect_access_ctrl_cfg_reserved",24,8);
         
         // Create registers
         ux_q_fw_load_base_l0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l0_urm::type_id::create("ux_q_fw_load_base_l0");
         ux_q_fw_load_base_l0.configure(this,null,"");
         ux_q_fw_load_base_l0.build();
         // hdl path
         ux_q_fw_load_base_l0.add_hdl_path_slice("ux_q_fw_load_base_l0_cfg_value",0,32);
         
         // Create registers
         ux_q_fw_load_base_l1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l1_urm::type_id::create("ux_q_fw_load_base_l1");
         ux_q_fw_load_base_l1.configure(this,null,"");
         ux_q_fw_load_base_l1.build();
         // hdl path
         ux_q_fw_load_base_l1.add_hdl_path_slice("ux_q_fw_load_base_l1_cfg_value",0,32);
         
         // Create registers
         ux_q_fw_load_base_l2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l2_urm::type_id::create("ux_q_fw_load_base_l2");
         ux_q_fw_load_base_l2.configure(this,null,"");
         ux_q_fw_load_base_l2.build();
         // hdl path
         ux_q_fw_load_base_l2.add_hdl_path_slice("ux_q_fw_load_base_l2_cfg_value",0,32);
         
         // Create registers
         ux_q_fw_load_base_l3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_fw_load_base_l3_urm::type_id::create("ux_q_fw_load_base_l3");
         ux_q_fw_load_base_l3.configure(this,null,"");
         ux_q_fw_load_base_l3.build();
         // hdl path
         ux_q_fw_load_base_l3.add_hdl_path_slice("ux_q_fw_load_base_l3_cfg_value",0,32);
         
         // Create registers
         ux0_bonding_size = gdr_ux_quad_avmm_cfgcsr_reg_ux0_bonding_size_urm::type_id::create("ux0_bonding_size");
         ux0_bonding_size.configure(this,null,"");
         ux0_bonding_size.build();
         // hdl path
         ux0_bonding_size.add_hdl_path_slice("ux0_bonding_size_cfg_size",0,4);
         ux0_bonding_size.add_hdl_path_slice("ux0_bonding_size_cfg_reserved",4,28);
         
         // Create registers
         ux1_bonding_size = gdr_ux_quad_avmm_cfgcsr_reg_ux1_bonding_size_urm::type_id::create("ux1_bonding_size");
         ux1_bonding_size.configure(this,null,"");
         ux1_bonding_size.build();
         // hdl path
         ux1_bonding_size.add_hdl_path_slice("ux1_bonding_size_cfg_size",0,4);
         ux1_bonding_size.add_hdl_path_slice("ux1_bonding_size_cfg_reserved",4,28);
         
         // Create registers
         ux2_bonding_size = gdr_ux_quad_avmm_cfgcsr_reg_ux2_bonding_size_urm::type_id::create("ux2_bonding_size");
         ux2_bonding_size.configure(this,null,"");
         ux2_bonding_size.build();
         // hdl path
         ux2_bonding_size.add_hdl_path_slice("ux2_bonding_size_cfg_size",0,4);
         ux2_bonding_size.add_hdl_path_slice("ux2_bonding_size_cfg_reserved",4,28);
         
         // Create registers
         ux3_bonding_size = gdr_ux_quad_avmm_cfgcsr_reg_ux3_bonding_size_urm::type_id::create("ux3_bonding_size");
         ux3_bonding_size.configure(this,null,"");
         ux3_bonding_size.build();
         // hdl path
         ux3_bonding_size.add_hdl_path_slice("ux3_bonding_size_cfg_size",0,4);
         ux3_bonding_size.add_hdl_path_slice("ux3_bonding_size_cfg_reserved",4,28);
         
         // Create registers
         ux_q_cpi_seq_ctrl = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_ctrl_urm::type_id::create("ux_q_cpi_seq_ctrl");
         ux_q_cpi_seq_ctrl.configure(this,null,"");
         ux_q_cpi_seq_ctrl.build();
         // hdl path
         ux_q_cpi_seq_ctrl.add_hdl_path_slice("ux_q_cpi_seq_ctrl_cfg_ctrl",0,32);
         
         // Create registers
         ux_q_cpi_seq_status = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_cpi_seq_status_urm::type_id::create("ux_q_cpi_seq_status");
         ux_q_cpi_seq_status.configure(this,null,"");
         ux_q_cpi_seq_status.build();
         // hdl path
         ux_q_cpi_seq_status.add_hdl_path_slice("ux_q_cpi_seq_status_status_busy_i",0,32);
         
         // Create registers
         ux_q_seq_ctrl_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_0_urm::type_id::create("ux_q_seq_ctrl_0");
         ux_q_seq_ctrl_0.configure(this,null,"");
         ux_q_seq_ctrl_0.build();
         // hdl path
         ux_q_seq_ctrl_0.add_hdl_path_slice("ux_q_seq_ctrl_0_cfg_restart_seq_sm",0,1);
         ux_q_seq_ctrl_0.add_hdl_path_slice("ux_q_seq_ctrl_0_cfg_skip_rd_seq",1,1);
         ux_q_seq_ctrl_0.add_hdl_path_slice("ux_q_seq_ctrl_0_cfg_ctrl_reserved",2,30);
         
         // Create registers
         ux_q_seq_ctrl_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_1_urm::type_id::create("ux_q_seq_ctrl_1");
         ux_q_seq_ctrl_1.configure(this,null,"");
         ux_q_seq_ctrl_1.build();
         // hdl path
         ux_q_seq_ctrl_1.add_hdl_path_slice("ux_q_seq_ctrl_1_cfg_seqen_0to31",0,32);
         
         // Create registers
         ux_q_seq_ctrl_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_2_urm::type_id::create("ux_q_seq_ctrl_2");
         ux_q_seq_ctrl_2.configure(this,null,"");
         ux_q_seq_ctrl_2.build();
         // hdl path
         ux_q_seq_ctrl_2.add_hdl_path_slice("ux_q_seq_ctrl_2_cfg_seqen_32to63",0,32);
         
         // Create registers
         ux_q_seq_ctrl_3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_3_urm::type_id::create("ux_q_seq_ctrl_3");
         ux_q_seq_ctrl_3.configure(this,null,"");
         ux_q_seq_ctrl_3.build();
         // hdl path
         ux_q_seq_ctrl_3.add_hdl_path_slice("ux_q_seq_ctrl_3_cfg_seq_rdwrb_0to31",0,32);
         
         // Create registers
         ux_q_seq_ctrl_4 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_ctrl_4_urm::type_id::create("ux_q_seq_ctrl_4");
         ux_q_seq_ctrl_4.configure(this,null,"");
         ux_q_seq_ctrl_4.build();
         // hdl path
         ux_q_seq_ctrl_4.add_hdl_path_slice("ux_q_seq_ctrl_4_cfg_seq_rdwrb_32to63",0,32);
         
         // Create registers
         ux_q_seq_data_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_0_urm::type_id::create("ux_q_seq_data_0");
         ux_q_seq_data_0.configure(this,null,"");
         ux_q_seq_data_0.build();
         // hdl path
         ux_q_seq_data_0.add_hdl_path_slice("ux_q_seq_data_0_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_1_urm::type_id::create("ux_q_seq_data_1");
         ux_q_seq_data_1.configure(this,null,"");
         ux_q_seq_data_1.build();
         // hdl path
         ux_q_seq_data_1.add_hdl_path_slice("ux_q_seq_data_1_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_2_urm::type_id::create("ux_q_seq_data_2");
         ux_q_seq_data_2.configure(this,null,"");
         ux_q_seq_data_2.build();
         // hdl path
         ux_q_seq_data_2.add_hdl_path_slice("ux_q_seq_data_2_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_3_urm::type_id::create("ux_q_seq_data_3");
         ux_q_seq_data_3.configure(this,null,"");
         ux_q_seq_data_3.build();
         // hdl path
         ux_q_seq_data_3.add_hdl_path_slice("ux_q_seq_data_3_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_4 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_4_urm::type_id::create("ux_q_seq_data_4");
         ux_q_seq_data_4.configure(this,null,"");
         ux_q_seq_data_4.build();
         // hdl path
         ux_q_seq_data_4.add_hdl_path_slice("ux_q_seq_data_4_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_5 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_5_urm::type_id::create("ux_q_seq_data_5");
         ux_q_seq_data_5.configure(this,null,"");
         ux_q_seq_data_5.build();
         // hdl path
         ux_q_seq_data_5.add_hdl_path_slice("ux_q_seq_data_5_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_6 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_6_urm::type_id::create("ux_q_seq_data_6");
         ux_q_seq_data_6.configure(this,null,"");
         ux_q_seq_data_6.build();
         // hdl path
         ux_q_seq_data_6.add_hdl_path_slice("ux_q_seq_data_6_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_7 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_7_urm::type_id::create("ux_q_seq_data_7");
         ux_q_seq_data_7.configure(this,null,"");
         ux_q_seq_data_7.build();
         // hdl path
         ux_q_seq_data_7.add_hdl_path_slice("ux_q_seq_data_7_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_8 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_8_urm::type_id::create("ux_q_seq_data_8");
         ux_q_seq_data_8.configure(this,null,"");
         ux_q_seq_data_8.build();
         // hdl path
         ux_q_seq_data_8.add_hdl_path_slice("ux_q_seq_data_8_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_9 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_9_urm::type_id::create("ux_q_seq_data_9");
         ux_q_seq_data_9.configure(this,null,"");
         ux_q_seq_data_9.build();
         // hdl path
         ux_q_seq_data_9.add_hdl_path_slice("ux_q_seq_data_9_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_10 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_10_urm::type_id::create("ux_q_seq_data_10");
         ux_q_seq_data_10.configure(this,null,"");
         ux_q_seq_data_10.build();
         // hdl path
         ux_q_seq_data_10.add_hdl_path_slice("ux_q_seq_data_10_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_11 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_11_urm::type_id::create("ux_q_seq_data_11");
         ux_q_seq_data_11.configure(this,null,"");
         ux_q_seq_data_11.build();
         // hdl path
         ux_q_seq_data_11.add_hdl_path_slice("ux_q_seq_data_11_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_12 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_12_urm::type_id::create("ux_q_seq_data_12");
         ux_q_seq_data_12.configure(this,null,"");
         ux_q_seq_data_12.build();
         // hdl path
         ux_q_seq_data_12.add_hdl_path_slice("ux_q_seq_data_12_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_13 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_13_urm::type_id::create("ux_q_seq_data_13");
         ux_q_seq_data_13.configure(this,null,"");
         ux_q_seq_data_13.build();
         // hdl path
         ux_q_seq_data_13.add_hdl_path_slice("ux_q_seq_data_13_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_14 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_14_urm::type_id::create("ux_q_seq_data_14");
         ux_q_seq_data_14.configure(this,null,"");
         ux_q_seq_data_14.build();
         // hdl path
         ux_q_seq_data_14.add_hdl_path_slice("ux_q_seq_data_14_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_15 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_15_urm::type_id::create("ux_q_seq_data_15");
         ux_q_seq_data_15.configure(this,null,"");
         ux_q_seq_data_15.build();
         // hdl path
         ux_q_seq_data_15.add_hdl_path_slice("ux_q_seq_data_15_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_16 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_16_urm::type_id::create("ux_q_seq_data_16");
         ux_q_seq_data_16.configure(this,null,"");
         ux_q_seq_data_16.build();
         // hdl path
         ux_q_seq_data_16.add_hdl_path_slice("ux_q_seq_data_16_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_17 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_17_urm::type_id::create("ux_q_seq_data_17");
         ux_q_seq_data_17.configure(this,null,"");
         ux_q_seq_data_17.build();
         // hdl path
         ux_q_seq_data_17.add_hdl_path_slice("ux_q_seq_data_17_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_18 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_18_urm::type_id::create("ux_q_seq_data_18");
         ux_q_seq_data_18.configure(this,null,"");
         ux_q_seq_data_18.build();
         // hdl path
         ux_q_seq_data_18.add_hdl_path_slice("ux_q_seq_data_18_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_19 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_19_urm::type_id::create("ux_q_seq_data_19");
         ux_q_seq_data_19.configure(this,null,"");
         ux_q_seq_data_19.build();
         // hdl path
         ux_q_seq_data_19.add_hdl_path_slice("ux_q_seq_data_19_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_20 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_20_urm::type_id::create("ux_q_seq_data_20");
         ux_q_seq_data_20.configure(this,null,"");
         ux_q_seq_data_20.build();
         // hdl path
         ux_q_seq_data_20.add_hdl_path_slice("ux_q_seq_data_20_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_21 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_21_urm::type_id::create("ux_q_seq_data_21");
         ux_q_seq_data_21.configure(this,null,"");
         ux_q_seq_data_21.build();
         // hdl path
         ux_q_seq_data_21.add_hdl_path_slice("ux_q_seq_data_21_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_22 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_22_urm::type_id::create("ux_q_seq_data_22");
         ux_q_seq_data_22.configure(this,null,"");
         ux_q_seq_data_22.build();
         // hdl path
         ux_q_seq_data_22.add_hdl_path_slice("ux_q_seq_data_22_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_23 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_23_urm::type_id::create("ux_q_seq_data_23");
         ux_q_seq_data_23.configure(this,null,"");
         ux_q_seq_data_23.build();
         // hdl path
         ux_q_seq_data_23.add_hdl_path_slice("ux_q_seq_data_23_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_24 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_24_urm::type_id::create("ux_q_seq_data_24");
         ux_q_seq_data_24.configure(this,null,"");
         ux_q_seq_data_24.build();
         // hdl path
         ux_q_seq_data_24.add_hdl_path_slice("ux_q_seq_data_24_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_25 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_25_urm::type_id::create("ux_q_seq_data_25");
         ux_q_seq_data_25.configure(this,null,"");
         ux_q_seq_data_25.build();
         // hdl path
         ux_q_seq_data_25.add_hdl_path_slice("ux_q_seq_data_25_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_26 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_26_urm::type_id::create("ux_q_seq_data_26");
         ux_q_seq_data_26.configure(this,null,"");
         ux_q_seq_data_26.build();
         // hdl path
         ux_q_seq_data_26.add_hdl_path_slice("ux_q_seq_data_26_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_27 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_27_urm::type_id::create("ux_q_seq_data_27");
         ux_q_seq_data_27.configure(this,null,"");
         ux_q_seq_data_27.build();
         // hdl path
         ux_q_seq_data_27.add_hdl_path_slice("ux_q_seq_data_27_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_28 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_28_urm::type_id::create("ux_q_seq_data_28");
         ux_q_seq_data_28.configure(this,null,"");
         ux_q_seq_data_28.build();
         // hdl path
         ux_q_seq_data_28.add_hdl_path_slice("ux_q_seq_data_28_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_29 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_29_urm::type_id::create("ux_q_seq_data_29");
         ux_q_seq_data_29.configure(this,null,"");
         ux_q_seq_data_29.build();
         // hdl path
         ux_q_seq_data_29.add_hdl_path_slice("ux_q_seq_data_29_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_30 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_30_urm::type_id::create("ux_q_seq_data_30");
         ux_q_seq_data_30.configure(this,null,"");
         ux_q_seq_data_30.build();
         // hdl path
         ux_q_seq_data_30.add_hdl_path_slice("ux_q_seq_data_30_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_31 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_31_urm::type_id::create("ux_q_seq_data_31");
         ux_q_seq_data_31.configure(this,null,"");
         ux_q_seq_data_31.build();
         // hdl path
         ux_q_seq_data_31.add_hdl_path_slice("ux_q_seq_data_31_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_32 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_32_urm::type_id::create("ux_q_seq_data_32");
         ux_q_seq_data_32.configure(this,null,"");
         ux_q_seq_data_32.build();
         // hdl path
         ux_q_seq_data_32.add_hdl_path_slice("ux_q_seq_data_32_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_33 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_33_urm::type_id::create("ux_q_seq_data_33");
         ux_q_seq_data_33.configure(this,null,"");
         ux_q_seq_data_33.build();
         // hdl path
         ux_q_seq_data_33.add_hdl_path_slice("ux_q_seq_data_33_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_34 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_34_urm::type_id::create("ux_q_seq_data_34");
         ux_q_seq_data_34.configure(this,null,"");
         ux_q_seq_data_34.build();
         // hdl path
         ux_q_seq_data_34.add_hdl_path_slice("ux_q_seq_data_34_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_35 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_35_urm::type_id::create("ux_q_seq_data_35");
         ux_q_seq_data_35.configure(this,null,"");
         ux_q_seq_data_35.build();
         // hdl path
         ux_q_seq_data_35.add_hdl_path_slice("ux_q_seq_data_35_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_36 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_36_urm::type_id::create("ux_q_seq_data_36");
         ux_q_seq_data_36.configure(this,null,"");
         ux_q_seq_data_36.build();
         // hdl path
         ux_q_seq_data_36.add_hdl_path_slice("ux_q_seq_data_36_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_37 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_37_urm::type_id::create("ux_q_seq_data_37");
         ux_q_seq_data_37.configure(this,null,"");
         ux_q_seq_data_37.build();
         // hdl path
         ux_q_seq_data_37.add_hdl_path_slice("ux_q_seq_data_37_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_38 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_38_urm::type_id::create("ux_q_seq_data_38");
         ux_q_seq_data_38.configure(this,null,"");
         ux_q_seq_data_38.build();
         // hdl path
         ux_q_seq_data_38.add_hdl_path_slice("ux_q_seq_data_38_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_39 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_39_urm::type_id::create("ux_q_seq_data_39");
         ux_q_seq_data_39.configure(this,null,"");
         ux_q_seq_data_39.build();
         // hdl path
         ux_q_seq_data_39.add_hdl_path_slice("ux_q_seq_data_39_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_40 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_40_urm::type_id::create("ux_q_seq_data_40");
         ux_q_seq_data_40.configure(this,null,"");
         ux_q_seq_data_40.build();
         // hdl path
         ux_q_seq_data_40.add_hdl_path_slice("ux_q_seq_data_40_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_41 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_41_urm::type_id::create("ux_q_seq_data_41");
         ux_q_seq_data_41.configure(this,null,"");
         ux_q_seq_data_41.build();
         // hdl path
         ux_q_seq_data_41.add_hdl_path_slice("ux_q_seq_data_41_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_42 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_42_urm::type_id::create("ux_q_seq_data_42");
         ux_q_seq_data_42.configure(this,null,"");
         ux_q_seq_data_42.build();
         // hdl path
         ux_q_seq_data_42.add_hdl_path_slice("ux_q_seq_data_42_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_43 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_43_urm::type_id::create("ux_q_seq_data_43");
         ux_q_seq_data_43.configure(this,null,"");
         ux_q_seq_data_43.build();
         // hdl path
         ux_q_seq_data_43.add_hdl_path_slice("ux_q_seq_data_43_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_44 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_44_urm::type_id::create("ux_q_seq_data_44");
         ux_q_seq_data_44.configure(this,null,"");
         ux_q_seq_data_44.build();
         // hdl path
         ux_q_seq_data_44.add_hdl_path_slice("ux_q_seq_data_44_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_45 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_45_urm::type_id::create("ux_q_seq_data_45");
         ux_q_seq_data_45.configure(this,null,"");
         ux_q_seq_data_45.build();
         // hdl path
         ux_q_seq_data_45.add_hdl_path_slice("ux_q_seq_data_45_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_46 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_46_urm::type_id::create("ux_q_seq_data_46");
         ux_q_seq_data_46.configure(this,null,"");
         ux_q_seq_data_46.build();
         // hdl path
         ux_q_seq_data_46.add_hdl_path_slice("ux_q_seq_data_46_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_47 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_47_urm::type_id::create("ux_q_seq_data_47");
         ux_q_seq_data_47.configure(this,null,"");
         ux_q_seq_data_47.build();
         // hdl path
         ux_q_seq_data_47.add_hdl_path_slice("ux_q_seq_data_47_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_48 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_48_urm::type_id::create("ux_q_seq_data_48");
         ux_q_seq_data_48.configure(this,null,"");
         ux_q_seq_data_48.build();
         // hdl path
         ux_q_seq_data_48.add_hdl_path_slice("ux_q_seq_data_48_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_49 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_49_urm::type_id::create("ux_q_seq_data_49");
         ux_q_seq_data_49.configure(this,null,"");
         ux_q_seq_data_49.build();
         // hdl path
         ux_q_seq_data_49.add_hdl_path_slice("ux_q_seq_data_49_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_50 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_50_urm::type_id::create("ux_q_seq_data_50");
         ux_q_seq_data_50.configure(this,null,"");
         ux_q_seq_data_50.build();
         // hdl path
         ux_q_seq_data_50.add_hdl_path_slice("ux_q_seq_data_50_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_51 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_51_urm::type_id::create("ux_q_seq_data_51");
         ux_q_seq_data_51.configure(this,null,"");
         ux_q_seq_data_51.build();
         // hdl path
         ux_q_seq_data_51.add_hdl_path_slice("ux_q_seq_data_51_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_52 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_52_urm::type_id::create("ux_q_seq_data_52");
         ux_q_seq_data_52.configure(this,null,"");
         ux_q_seq_data_52.build();
         // hdl path
         ux_q_seq_data_52.add_hdl_path_slice("ux_q_seq_data_52_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_53 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_53_urm::type_id::create("ux_q_seq_data_53");
         ux_q_seq_data_53.configure(this,null,"");
         ux_q_seq_data_53.build();
         // hdl path
         ux_q_seq_data_53.add_hdl_path_slice("ux_q_seq_data_53_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_54 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_54_urm::type_id::create("ux_q_seq_data_54");
         ux_q_seq_data_54.configure(this,null,"");
         ux_q_seq_data_54.build();
         // hdl path
         ux_q_seq_data_54.add_hdl_path_slice("ux_q_seq_data_54_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_55 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_55_urm::type_id::create("ux_q_seq_data_55");
         ux_q_seq_data_55.configure(this,null,"");
         ux_q_seq_data_55.build();
         // hdl path
         ux_q_seq_data_55.add_hdl_path_slice("ux_q_seq_data_55_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_56 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_56_urm::type_id::create("ux_q_seq_data_56");
         ux_q_seq_data_56.configure(this,null,"");
         ux_q_seq_data_56.build();
         // hdl path
         ux_q_seq_data_56.add_hdl_path_slice("ux_q_seq_data_56_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_57 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_57_urm::type_id::create("ux_q_seq_data_57");
         ux_q_seq_data_57.configure(this,null,"");
         ux_q_seq_data_57.build();
         // hdl path
         ux_q_seq_data_57.add_hdl_path_slice("ux_q_seq_data_57_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_58 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_58_urm::type_id::create("ux_q_seq_data_58");
         ux_q_seq_data_58.configure(this,null,"");
         ux_q_seq_data_58.build();
         // hdl path
         ux_q_seq_data_58.add_hdl_path_slice("ux_q_seq_data_58_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_59 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_59_urm::type_id::create("ux_q_seq_data_59");
         ux_q_seq_data_59.configure(this,null,"");
         ux_q_seq_data_59.build();
         // hdl path
         ux_q_seq_data_59.add_hdl_path_slice("ux_q_seq_data_59_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_60 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_60_urm::type_id::create("ux_q_seq_data_60");
         ux_q_seq_data_60.configure(this,null,"");
         ux_q_seq_data_60.build();
         // hdl path
         ux_q_seq_data_60.add_hdl_path_slice("ux_q_seq_data_60_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_61 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_61_urm::type_id::create("ux_q_seq_data_61");
         ux_q_seq_data_61.configure(this,null,"");
         ux_q_seq_data_61.build();
         // hdl path
         ux_q_seq_data_61.add_hdl_path_slice("ux_q_seq_data_61_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_62 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_62_urm::type_id::create("ux_q_seq_data_62");
         ux_q_seq_data_62.configure(this,null,"");
         ux_q_seq_data_62.build();
         // hdl path
         ux_q_seq_data_62.add_hdl_path_slice("ux_q_seq_data_62_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_data_63 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_data_63_urm::type_id::create("ux_q_seq_data_63");
         ux_q_seq_data_63.configure(this,null,"");
         ux_q_seq_data_63.build();
         // hdl path
         ux_q_seq_data_63.add_hdl_path_slice("ux_q_seq_data_63_cfg_seq_data",0,32);
         
         // Create registers
         ux_q_seq_addr_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_0_urm::type_id::create("ux_q_seq_addr_0");
         ux_q_seq_addr_0.configure(this,null,"");
         ux_q_seq_addr_0.build();
         // hdl path
         ux_q_seq_addr_0.add_hdl_path_slice("ux_q_seq_addr_0_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_1_urm::type_id::create("ux_q_seq_addr_1");
         ux_q_seq_addr_1.configure(this,null,"");
         ux_q_seq_addr_1.build();
         // hdl path
         ux_q_seq_addr_1.add_hdl_path_slice("ux_q_seq_addr_1_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_2_urm::type_id::create("ux_q_seq_addr_2");
         ux_q_seq_addr_2.configure(this,null,"");
         ux_q_seq_addr_2.build();
         // hdl path
         ux_q_seq_addr_2.add_hdl_path_slice("ux_q_seq_addr_2_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_3_urm::type_id::create("ux_q_seq_addr_3");
         ux_q_seq_addr_3.configure(this,null,"");
         ux_q_seq_addr_3.build();
         // hdl path
         ux_q_seq_addr_3.add_hdl_path_slice("ux_q_seq_addr_3_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_4 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_4_urm::type_id::create("ux_q_seq_addr_4");
         ux_q_seq_addr_4.configure(this,null,"");
         ux_q_seq_addr_4.build();
         // hdl path
         ux_q_seq_addr_4.add_hdl_path_slice("ux_q_seq_addr_4_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_5 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_5_urm::type_id::create("ux_q_seq_addr_5");
         ux_q_seq_addr_5.configure(this,null,"");
         ux_q_seq_addr_5.build();
         // hdl path
         ux_q_seq_addr_5.add_hdl_path_slice("ux_q_seq_addr_5_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_6 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_6_urm::type_id::create("ux_q_seq_addr_6");
         ux_q_seq_addr_6.configure(this,null,"");
         ux_q_seq_addr_6.build();
         // hdl path
         ux_q_seq_addr_6.add_hdl_path_slice("ux_q_seq_addr_6_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_7 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_7_urm::type_id::create("ux_q_seq_addr_7");
         ux_q_seq_addr_7.configure(this,null,"");
         ux_q_seq_addr_7.build();
         // hdl path
         ux_q_seq_addr_7.add_hdl_path_slice("ux_q_seq_addr_7_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_8 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_8_urm::type_id::create("ux_q_seq_addr_8");
         ux_q_seq_addr_8.configure(this,null,"");
         ux_q_seq_addr_8.build();
         // hdl path
         ux_q_seq_addr_8.add_hdl_path_slice("ux_q_seq_addr_8_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_9 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_9_urm::type_id::create("ux_q_seq_addr_9");
         ux_q_seq_addr_9.configure(this,null,"");
         ux_q_seq_addr_9.build();
         // hdl path
         ux_q_seq_addr_9.add_hdl_path_slice("ux_q_seq_addr_9_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_10 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_10_urm::type_id::create("ux_q_seq_addr_10");
         ux_q_seq_addr_10.configure(this,null,"");
         ux_q_seq_addr_10.build();
         // hdl path
         ux_q_seq_addr_10.add_hdl_path_slice("ux_q_seq_addr_10_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_11 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_11_urm::type_id::create("ux_q_seq_addr_11");
         ux_q_seq_addr_11.configure(this,null,"");
         ux_q_seq_addr_11.build();
         // hdl path
         ux_q_seq_addr_11.add_hdl_path_slice("ux_q_seq_addr_11_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_12 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_12_urm::type_id::create("ux_q_seq_addr_12");
         ux_q_seq_addr_12.configure(this,null,"");
         ux_q_seq_addr_12.build();
         // hdl path
         ux_q_seq_addr_12.add_hdl_path_slice("ux_q_seq_addr_12_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_13 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_13_urm::type_id::create("ux_q_seq_addr_13");
         ux_q_seq_addr_13.configure(this,null,"");
         ux_q_seq_addr_13.build();
         // hdl path
         ux_q_seq_addr_13.add_hdl_path_slice("ux_q_seq_addr_13_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_14 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_14_urm::type_id::create("ux_q_seq_addr_14");
         ux_q_seq_addr_14.configure(this,null,"");
         ux_q_seq_addr_14.build();
         // hdl path
         ux_q_seq_addr_14.add_hdl_path_slice("ux_q_seq_addr_14_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_15 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_15_urm::type_id::create("ux_q_seq_addr_15");
         ux_q_seq_addr_15.configure(this,null,"");
         ux_q_seq_addr_15.build();
         // hdl path
         ux_q_seq_addr_15.add_hdl_path_slice("ux_q_seq_addr_15_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_16 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_16_urm::type_id::create("ux_q_seq_addr_16");
         ux_q_seq_addr_16.configure(this,null,"");
         ux_q_seq_addr_16.build();
         // hdl path
         ux_q_seq_addr_16.add_hdl_path_slice("ux_q_seq_addr_16_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_17 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_17_urm::type_id::create("ux_q_seq_addr_17");
         ux_q_seq_addr_17.configure(this,null,"");
         ux_q_seq_addr_17.build();
         // hdl path
         ux_q_seq_addr_17.add_hdl_path_slice("ux_q_seq_addr_17_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_18 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_18_urm::type_id::create("ux_q_seq_addr_18");
         ux_q_seq_addr_18.configure(this,null,"");
         ux_q_seq_addr_18.build();
         // hdl path
         ux_q_seq_addr_18.add_hdl_path_slice("ux_q_seq_addr_18_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_19 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_19_urm::type_id::create("ux_q_seq_addr_19");
         ux_q_seq_addr_19.configure(this,null,"");
         ux_q_seq_addr_19.build();
         // hdl path
         ux_q_seq_addr_19.add_hdl_path_slice("ux_q_seq_addr_19_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_20 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_20_urm::type_id::create("ux_q_seq_addr_20");
         ux_q_seq_addr_20.configure(this,null,"");
         ux_q_seq_addr_20.build();
         // hdl path
         ux_q_seq_addr_20.add_hdl_path_slice("ux_q_seq_addr_20_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_21 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_21_urm::type_id::create("ux_q_seq_addr_21");
         ux_q_seq_addr_21.configure(this,null,"");
         ux_q_seq_addr_21.build();
         // hdl path
         ux_q_seq_addr_21.add_hdl_path_slice("ux_q_seq_addr_21_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_22 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_22_urm::type_id::create("ux_q_seq_addr_22");
         ux_q_seq_addr_22.configure(this,null,"");
         ux_q_seq_addr_22.build();
         // hdl path
         ux_q_seq_addr_22.add_hdl_path_slice("ux_q_seq_addr_22_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_23 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_23_urm::type_id::create("ux_q_seq_addr_23");
         ux_q_seq_addr_23.configure(this,null,"");
         ux_q_seq_addr_23.build();
         // hdl path
         ux_q_seq_addr_23.add_hdl_path_slice("ux_q_seq_addr_23_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_24 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_24_urm::type_id::create("ux_q_seq_addr_24");
         ux_q_seq_addr_24.configure(this,null,"");
         ux_q_seq_addr_24.build();
         // hdl path
         ux_q_seq_addr_24.add_hdl_path_slice("ux_q_seq_addr_24_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_25 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_25_urm::type_id::create("ux_q_seq_addr_25");
         ux_q_seq_addr_25.configure(this,null,"");
         ux_q_seq_addr_25.build();
         // hdl path
         ux_q_seq_addr_25.add_hdl_path_slice("ux_q_seq_addr_25_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_26 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_26_urm::type_id::create("ux_q_seq_addr_26");
         ux_q_seq_addr_26.configure(this,null,"");
         ux_q_seq_addr_26.build();
         // hdl path
         ux_q_seq_addr_26.add_hdl_path_slice("ux_q_seq_addr_26_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_27 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_27_urm::type_id::create("ux_q_seq_addr_27");
         ux_q_seq_addr_27.configure(this,null,"");
         ux_q_seq_addr_27.build();
         // hdl path
         ux_q_seq_addr_27.add_hdl_path_slice("ux_q_seq_addr_27_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_28 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_28_urm::type_id::create("ux_q_seq_addr_28");
         ux_q_seq_addr_28.configure(this,null,"");
         ux_q_seq_addr_28.build();
         // hdl path
         ux_q_seq_addr_28.add_hdl_path_slice("ux_q_seq_addr_28_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_29 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_29_urm::type_id::create("ux_q_seq_addr_29");
         ux_q_seq_addr_29.configure(this,null,"");
         ux_q_seq_addr_29.build();
         // hdl path
         ux_q_seq_addr_29.add_hdl_path_slice("ux_q_seq_addr_29_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_30 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_30_urm::type_id::create("ux_q_seq_addr_30");
         ux_q_seq_addr_30.configure(this,null,"");
         ux_q_seq_addr_30.build();
         // hdl path
         ux_q_seq_addr_30.add_hdl_path_slice("ux_q_seq_addr_30_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_31 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_31_urm::type_id::create("ux_q_seq_addr_31");
         ux_q_seq_addr_31.configure(this,null,"");
         ux_q_seq_addr_31.build();
         // hdl path
         ux_q_seq_addr_31.add_hdl_path_slice("ux_q_seq_addr_31_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_32 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_32_urm::type_id::create("ux_q_seq_addr_32");
         ux_q_seq_addr_32.configure(this,null,"");
         ux_q_seq_addr_32.build();
         // hdl path
         ux_q_seq_addr_32.add_hdl_path_slice("ux_q_seq_addr_32_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_33 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_33_urm::type_id::create("ux_q_seq_addr_33");
         ux_q_seq_addr_33.configure(this,null,"");
         ux_q_seq_addr_33.build();
         // hdl path
         ux_q_seq_addr_33.add_hdl_path_slice("ux_q_seq_addr_33_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_34 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_34_urm::type_id::create("ux_q_seq_addr_34");
         ux_q_seq_addr_34.configure(this,null,"");
         ux_q_seq_addr_34.build();
         // hdl path
         ux_q_seq_addr_34.add_hdl_path_slice("ux_q_seq_addr_34_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_35 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_35_urm::type_id::create("ux_q_seq_addr_35");
         ux_q_seq_addr_35.configure(this,null,"");
         ux_q_seq_addr_35.build();
         // hdl path
         ux_q_seq_addr_35.add_hdl_path_slice("ux_q_seq_addr_35_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_36 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_36_urm::type_id::create("ux_q_seq_addr_36");
         ux_q_seq_addr_36.configure(this,null,"");
         ux_q_seq_addr_36.build();
         // hdl path
         ux_q_seq_addr_36.add_hdl_path_slice("ux_q_seq_addr_36_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_37 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_37_urm::type_id::create("ux_q_seq_addr_37");
         ux_q_seq_addr_37.configure(this,null,"");
         ux_q_seq_addr_37.build();
         // hdl path
         ux_q_seq_addr_37.add_hdl_path_slice("ux_q_seq_addr_37_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_38 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_38_urm::type_id::create("ux_q_seq_addr_38");
         ux_q_seq_addr_38.configure(this,null,"");
         ux_q_seq_addr_38.build();
         // hdl path
         ux_q_seq_addr_38.add_hdl_path_slice("ux_q_seq_addr_38_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_39 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_39_urm::type_id::create("ux_q_seq_addr_39");
         ux_q_seq_addr_39.configure(this,null,"");
         ux_q_seq_addr_39.build();
         // hdl path
         ux_q_seq_addr_39.add_hdl_path_slice("ux_q_seq_addr_39_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_40 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_40_urm::type_id::create("ux_q_seq_addr_40");
         ux_q_seq_addr_40.configure(this,null,"");
         ux_q_seq_addr_40.build();
         // hdl path
         ux_q_seq_addr_40.add_hdl_path_slice("ux_q_seq_addr_40_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_41 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_41_urm::type_id::create("ux_q_seq_addr_41");
         ux_q_seq_addr_41.configure(this,null,"");
         ux_q_seq_addr_41.build();
         // hdl path
         ux_q_seq_addr_41.add_hdl_path_slice("ux_q_seq_addr_41_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_42 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_42_urm::type_id::create("ux_q_seq_addr_42");
         ux_q_seq_addr_42.configure(this,null,"");
         ux_q_seq_addr_42.build();
         // hdl path
         ux_q_seq_addr_42.add_hdl_path_slice("ux_q_seq_addr_42_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_43 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_43_urm::type_id::create("ux_q_seq_addr_43");
         ux_q_seq_addr_43.configure(this,null,"");
         ux_q_seq_addr_43.build();
         // hdl path
         ux_q_seq_addr_43.add_hdl_path_slice("ux_q_seq_addr_43_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_44 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_44_urm::type_id::create("ux_q_seq_addr_44");
         ux_q_seq_addr_44.configure(this,null,"");
         ux_q_seq_addr_44.build();
         // hdl path
         ux_q_seq_addr_44.add_hdl_path_slice("ux_q_seq_addr_44_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_45 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_45_urm::type_id::create("ux_q_seq_addr_45");
         ux_q_seq_addr_45.configure(this,null,"");
         ux_q_seq_addr_45.build();
         // hdl path
         ux_q_seq_addr_45.add_hdl_path_slice("ux_q_seq_addr_45_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_46 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_46_urm::type_id::create("ux_q_seq_addr_46");
         ux_q_seq_addr_46.configure(this,null,"");
         ux_q_seq_addr_46.build();
         // hdl path
         ux_q_seq_addr_46.add_hdl_path_slice("ux_q_seq_addr_46_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_47 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_47_urm::type_id::create("ux_q_seq_addr_47");
         ux_q_seq_addr_47.configure(this,null,"");
         ux_q_seq_addr_47.build();
         // hdl path
         ux_q_seq_addr_47.add_hdl_path_slice("ux_q_seq_addr_47_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_48 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_48_urm::type_id::create("ux_q_seq_addr_48");
         ux_q_seq_addr_48.configure(this,null,"");
         ux_q_seq_addr_48.build();
         // hdl path
         ux_q_seq_addr_48.add_hdl_path_slice("ux_q_seq_addr_48_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_49 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_49_urm::type_id::create("ux_q_seq_addr_49");
         ux_q_seq_addr_49.configure(this,null,"");
         ux_q_seq_addr_49.build();
         // hdl path
         ux_q_seq_addr_49.add_hdl_path_slice("ux_q_seq_addr_49_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_50 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_50_urm::type_id::create("ux_q_seq_addr_50");
         ux_q_seq_addr_50.configure(this,null,"");
         ux_q_seq_addr_50.build();
         // hdl path
         ux_q_seq_addr_50.add_hdl_path_slice("ux_q_seq_addr_50_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_51 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_51_urm::type_id::create("ux_q_seq_addr_51");
         ux_q_seq_addr_51.configure(this,null,"");
         ux_q_seq_addr_51.build();
         // hdl path
         ux_q_seq_addr_51.add_hdl_path_slice("ux_q_seq_addr_51_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_52 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_52_urm::type_id::create("ux_q_seq_addr_52");
         ux_q_seq_addr_52.configure(this,null,"");
         ux_q_seq_addr_52.build();
         // hdl path
         ux_q_seq_addr_52.add_hdl_path_slice("ux_q_seq_addr_52_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_53 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_53_urm::type_id::create("ux_q_seq_addr_53");
         ux_q_seq_addr_53.configure(this,null,"");
         ux_q_seq_addr_53.build();
         // hdl path
         ux_q_seq_addr_53.add_hdl_path_slice("ux_q_seq_addr_53_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_54 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_54_urm::type_id::create("ux_q_seq_addr_54");
         ux_q_seq_addr_54.configure(this,null,"");
         ux_q_seq_addr_54.build();
         // hdl path
         ux_q_seq_addr_54.add_hdl_path_slice("ux_q_seq_addr_54_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_55 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_55_urm::type_id::create("ux_q_seq_addr_55");
         ux_q_seq_addr_55.configure(this,null,"");
         ux_q_seq_addr_55.build();
         // hdl path
         ux_q_seq_addr_55.add_hdl_path_slice("ux_q_seq_addr_55_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_56 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_56_urm::type_id::create("ux_q_seq_addr_56");
         ux_q_seq_addr_56.configure(this,null,"");
         ux_q_seq_addr_56.build();
         // hdl path
         ux_q_seq_addr_56.add_hdl_path_slice("ux_q_seq_addr_56_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_57 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_57_urm::type_id::create("ux_q_seq_addr_57");
         ux_q_seq_addr_57.configure(this,null,"");
         ux_q_seq_addr_57.build();
         // hdl path
         ux_q_seq_addr_57.add_hdl_path_slice("ux_q_seq_addr_57_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_58 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_58_urm::type_id::create("ux_q_seq_addr_58");
         ux_q_seq_addr_58.configure(this,null,"");
         ux_q_seq_addr_58.build();
         // hdl path
         ux_q_seq_addr_58.add_hdl_path_slice("ux_q_seq_addr_58_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_59 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_59_urm::type_id::create("ux_q_seq_addr_59");
         ux_q_seq_addr_59.configure(this,null,"");
         ux_q_seq_addr_59.build();
         // hdl path
         ux_q_seq_addr_59.add_hdl_path_slice("ux_q_seq_addr_59_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_60 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_60_urm::type_id::create("ux_q_seq_addr_60");
         ux_q_seq_addr_60.configure(this,null,"");
         ux_q_seq_addr_60.build();
         // hdl path
         ux_q_seq_addr_60.add_hdl_path_slice("ux_q_seq_addr_60_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_61 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_61_urm::type_id::create("ux_q_seq_addr_61");
         ux_q_seq_addr_61.configure(this,null,"");
         ux_q_seq_addr_61.build();
         // hdl path
         ux_q_seq_addr_61.add_hdl_path_slice("ux_q_seq_addr_61_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_62 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_62_urm::type_id::create("ux_q_seq_addr_62");
         ux_q_seq_addr_62.configure(this,null,"");
         ux_q_seq_addr_62.build();
         // hdl path
         ux_q_seq_addr_62.add_hdl_path_slice("ux_q_seq_addr_62_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_addr_63 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_addr_63_urm::type_id::create("ux_q_seq_addr_63");
         ux_q_seq_addr_63.configure(this,null,"");
         ux_q_seq_addr_63.build();
         // hdl path
         ux_q_seq_addr_63.add_hdl_path_slice("ux_q_seq_addr_63_cfg_seq_addr",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_0_urm::type_id::create("ux_q_seq_rdata_unmask_0");
         ux_q_seq_rdata_unmask_0.configure(this,null,"");
         ux_q_seq_rdata_unmask_0.build();
         // hdl path
         ux_q_seq_rdata_unmask_0.add_hdl_path_slice("ux_q_seq_rdata_unmask_0_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_1_urm::type_id::create("ux_q_seq_rdata_unmask_1");
         ux_q_seq_rdata_unmask_1.configure(this,null,"");
         ux_q_seq_rdata_unmask_1.build();
         // hdl path
         ux_q_seq_rdata_unmask_1.add_hdl_path_slice("ux_q_seq_rdata_unmask_1_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_2_urm::type_id::create("ux_q_seq_rdata_unmask_2");
         ux_q_seq_rdata_unmask_2.configure(this,null,"");
         ux_q_seq_rdata_unmask_2.build();
         // hdl path
         ux_q_seq_rdata_unmask_2.add_hdl_path_slice("ux_q_seq_rdata_unmask_2_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_3_urm::type_id::create("ux_q_seq_rdata_unmask_3");
         ux_q_seq_rdata_unmask_3.configure(this,null,"");
         ux_q_seq_rdata_unmask_3.build();
         // hdl path
         ux_q_seq_rdata_unmask_3.add_hdl_path_slice("ux_q_seq_rdata_unmask_3_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_4 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_4_urm::type_id::create("ux_q_seq_rdata_unmask_4");
         ux_q_seq_rdata_unmask_4.configure(this,null,"");
         ux_q_seq_rdata_unmask_4.build();
         // hdl path
         ux_q_seq_rdata_unmask_4.add_hdl_path_slice("ux_q_seq_rdata_unmask_4_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_5 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_5_urm::type_id::create("ux_q_seq_rdata_unmask_5");
         ux_q_seq_rdata_unmask_5.configure(this,null,"");
         ux_q_seq_rdata_unmask_5.build();
         // hdl path
         ux_q_seq_rdata_unmask_5.add_hdl_path_slice("ux_q_seq_rdata_unmask_5_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_6 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_6_urm::type_id::create("ux_q_seq_rdata_unmask_6");
         ux_q_seq_rdata_unmask_6.configure(this,null,"");
         ux_q_seq_rdata_unmask_6.build();
         // hdl path
         ux_q_seq_rdata_unmask_6.add_hdl_path_slice("ux_q_seq_rdata_unmask_6_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_7 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_7_urm::type_id::create("ux_q_seq_rdata_unmask_7");
         ux_q_seq_rdata_unmask_7.configure(this,null,"");
         ux_q_seq_rdata_unmask_7.build();
         // hdl path
         ux_q_seq_rdata_unmask_7.add_hdl_path_slice("ux_q_seq_rdata_unmask_7_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_8 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_8_urm::type_id::create("ux_q_seq_rdata_unmask_8");
         ux_q_seq_rdata_unmask_8.configure(this,null,"");
         ux_q_seq_rdata_unmask_8.build();
         // hdl path
         ux_q_seq_rdata_unmask_8.add_hdl_path_slice("ux_q_seq_rdata_unmask_8_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_9 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_9_urm::type_id::create("ux_q_seq_rdata_unmask_9");
         ux_q_seq_rdata_unmask_9.configure(this,null,"");
         ux_q_seq_rdata_unmask_9.build();
         // hdl path
         ux_q_seq_rdata_unmask_9.add_hdl_path_slice("ux_q_seq_rdata_unmask_9_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_10 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_10_urm::type_id::create("ux_q_seq_rdata_unmask_10");
         ux_q_seq_rdata_unmask_10.configure(this,null,"");
         ux_q_seq_rdata_unmask_10.build();
         // hdl path
         ux_q_seq_rdata_unmask_10.add_hdl_path_slice("ux_q_seq_rdata_unmask_10_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_11 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_11_urm::type_id::create("ux_q_seq_rdata_unmask_11");
         ux_q_seq_rdata_unmask_11.configure(this,null,"");
         ux_q_seq_rdata_unmask_11.build();
         // hdl path
         ux_q_seq_rdata_unmask_11.add_hdl_path_slice("ux_q_seq_rdata_unmask_11_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_12 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_12_urm::type_id::create("ux_q_seq_rdata_unmask_12");
         ux_q_seq_rdata_unmask_12.configure(this,null,"");
         ux_q_seq_rdata_unmask_12.build();
         // hdl path
         ux_q_seq_rdata_unmask_12.add_hdl_path_slice("ux_q_seq_rdata_unmask_12_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_13 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_13_urm::type_id::create("ux_q_seq_rdata_unmask_13");
         ux_q_seq_rdata_unmask_13.configure(this,null,"");
         ux_q_seq_rdata_unmask_13.build();
         // hdl path
         ux_q_seq_rdata_unmask_13.add_hdl_path_slice("ux_q_seq_rdata_unmask_13_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_14 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_14_urm::type_id::create("ux_q_seq_rdata_unmask_14");
         ux_q_seq_rdata_unmask_14.configure(this,null,"");
         ux_q_seq_rdata_unmask_14.build();
         // hdl path
         ux_q_seq_rdata_unmask_14.add_hdl_path_slice("ux_q_seq_rdata_unmask_14_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_15 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_15_urm::type_id::create("ux_q_seq_rdata_unmask_15");
         ux_q_seq_rdata_unmask_15.configure(this,null,"");
         ux_q_seq_rdata_unmask_15.build();
         // hdl path
         ux_q_seq_rdata_unmask_15.add_hdl_path_slice("ux_q_seq_rdata_unmask_15_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_16 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_16_urm::type_id::create("ux_q_seq_rdata_unmask_16");
         ux_q_seq_rdata_unmask_16.configure(this,null,"");
         ux_q_seq_rdata_unmask_16.build();
         // hdl path
         ux_q_seq_rdata_unmask_16.add_hdl_path_slice("ux_q_seq_rdata_unmask_16_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_17 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_17_urm::type_id::create("ux_q_seq_rdata_unmask_17");
         ux_q_seq_rdata_unmask_17.configure(this,null,"");
         ux_q_seq_rdata_unmask_17.build();
         // hdl path
         ux_q_seq_rdata_unmask_17.add_hdl_path_slice("ux_q_seq_rdata_unmask_17_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_18 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_18_urm::type_id::create("ux_q_seq_rdata_unmask_18");
         ux_q_seq_rdata_unmask_18.configure(this,null,"");
         ux_q_seq_rdata_unmask_18.build();
         // hdl path
         ux_q_seq_rdata_unmask_18.add_hdl_path_slice("ux_q_seq_rdata_unmask_18_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_19 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_19_urm::type_id::create("ux_q_seq_rdata_unmask_19");
         ux_q_seq_rdata_unmask_19.configure(this,null,"");
         ux_q_seq_rdata_unmask_19.build();
         // hdl path
         ux_q_seq_rdata_unmask_19.add_hdl_path_slice("ux_q_seq_rdata_unmask_19_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_20 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_20_urm::type_id::create("ux_q_seq_rdata_unmask_20");
         ux_q_seq_rdata_unmask_20.configure(this,null,"");
         ux_q_seq_rdata_unmask_20.build();
         // hdl path
         ux_q_seq_rdata_unmask_20.add_hdl_path_slice("ux_q_seq_rdata_unmask_20_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_21 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_21_urm::type_id::create("ux_q_seq_rdata_unmask_21");
         ux_q_seq_rdata_unmask_21.configure(this,null,"");
         ux_q_seq_rdata_unmask_21.build();
         // hdl path
         ux_q_seq_rdata_unmask_21.add_hdl_path_slice("ux_q_seq_rdata_unmask_21_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_22 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_22_urm::type_id::create("ux_q_seq_rdata_unmask_22");
         ux_q_seq_rdata_unmask_22.configure(this,null,"");
         ux_q_seq_rdata_unmask_22.build();
         // hdl path
         ux_q_seq_rdata_unmask_22.add_hdl_path_slice("ux_q_seq_rdata_unmask_22_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_23 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_23_urm::type_id::create("ux_q_seq_rdata_unmask_23");
         ux_q_seq_rdata_unmask_23.configure(this,null,"");
         ux_q_seq_rdata_unmask_23.build();
         // hdl path
         ux_q_seq_rdata_unmask_23.add_hdl_path_slice("ux_q_seq_rdata_unmask_23_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_24 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_24_urm::type_id::create("ux_q_seq_rdata_unmask_24");
         ux_q_seq_rdata_unmask_24.configure(this,null,"");
         ux_q_seq_rdata_unmask_24.build();
         // hdl path
         ux_q_seq_rdata_unmask_24.add_hdl_path_slice("ux_q_seq_rdata_unmask_24_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_25 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_25_urm::type_id::create("ux_q_seq_rdata_unmask_25");
         ux_q_seq_rdata_unmask_25.configure(this,null,"");
         ux_q_seq_rdata_unmask_25.build();
         // hdl path
         ux_q_seq_rdata_unmask_25.add_hdl_path_slice("ux_q_seq_rdata_unmask_25_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_26 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_26_urm::type_id::create("ux_q_seq_rdata_unmask_26");
         ux_q_seq_rdata_unmask_26.configure(this,null,"");
         ux_q_seq_rdata_unmask_26.build();
         // hdl path
         ux_q_seq_rdata_unmask_26.add_hdl_path_slice("ux_q_seq_rdata_unmask_26_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_27 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_27_urm::type_id::create("ux_q_seq_rdata_unmask_27");
         ux_q_seq_rdata_unmask_27.configure(this,null,"");
         ux_q_seq_rdata_unmask_27.build();
         // hdl path
         ux_q_seq_rdata_unmask_27.add_hdl_path_slice("ux_q_seq_rdata_unmask_27_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_28 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_28_urm::type_id::create("ux_q_seq_rdata_unmask_28");
         ux_q_seq_rdata_unmask_28.configure(this,null,"");
         ux_q_seq_rdata_unmask_28.build();
         // hdl path
         ux_q_seq_rdata_unmask_28.add_hdl_path_slice("ux_q_seq_rdata_unmask_28_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_29 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_29_urm::type_id::create("ux_q_seq_rdata_unmask_29");
         ux_q_seq_rdata_unmask_29.configure(this,null,"");
         ux_q_seq_rdata_unmask_29.build();
         // hdl path
         ux_q_seq_rdata_unmask_29.add_hdl_path_slice("ux_q_seq_rdata_unmask_29_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_30 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_30_urm::type_id::create("ux_q_seq_rdata_unmask_30");
         ux_q_seq_rdata_unmask_30.configure(this,null,"");
         ux_q_seq_rdata_unmask_30.build();
         // hdl path
         ux_q_seq_rdata_unmask_30.add_hdl_path_slice("ux_q_seq_rdata_unmask_30_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_31 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_31_urm::type_id::create("ux_q_seq_rdata_unmask_31");
         ux_q_seq_rdata_unmask_31.configure(this,null,"");
         ux_q_seq_rdata_unmask_31.build();
         // hdl path
         ux_q_seq_rdata_unmask_31.add_hdl_path_slice("ux_q_seq_rdata_unmask_31_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_32 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_32_urm::type_id::create("ux_q_seq_rdata_unmask_32");
         ux_q_seq_rdata_unmask_32.configure(this,null,"");
         ux_q_seq_rdata_unmask_32.build();
         // hdl path
         ux_q_seq_rdata_unmask_32.add_hdl_path_slice("ux_q_seq_rdata_unmask_32_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_33 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_33_urm::type_id::create("ux_q_seq_rdata_unmask_33");
         ux_q_seq_rdata_unmask_33.configure(this,null,"");
         ux_q_seq_rdata_unmask_33.build();
         // hdl path
         ux_q_seq_rdata_unmask_33.add_hdl_path_slice("ux_q_seq_rdata_unmask_33_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_34 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_34_urm::type_id::create("ux_q_seq_rdata_unmask_34");
         ux_q_seq_rdata_unmask_34.configure(this,null,"");
         ux_q_seq_rdata_unmask_34.build();
         // hdl path
         ux_q_seq_rdata_unmask_34.add_hdl_path_slice("ux_q_seq_rdata_unmask_34_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_35 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_35_urm::type_id::create("ux_q_seq_rdata_unmask_35");
         ux_q_seq_rdata_unmask_35.configure(this,null,"");
         ux_q_seq_rdata_unmask_35.build();
         // hdl path
         ux_q_seq_rdata_unmask_35.add_hdl_path_slice("ux_q_seq_rdata_unmask_35_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_36 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_36_urm::type_id::create("ux_q_seq_rdata_unmask_36");
         ux_q_seq_rdata_unmask_36.configure(this,null,"");
         ux_q_seq_rdata_unmask_36.build();
         // hdl path
         ux_q_seq_rdata_unmask_36.add_hdl_path_slice("ux_q_seq_rdata_unmask_36_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_37 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_37_urm::type_id::create("ux_q_seq_rdata_unmask_37");
         ux_q_seq_rdata_unmask_37.configure(this,null,"");
         ux_q_seq_rdata_unmask_37.build();
         // hdl path
         ux_q_seq_rdata_unmask_37.add_hdl_path_slice("ux_q_seq_rdata_unmask_37_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_38 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_38_urm::type_id::create("ux_q_seq_rdata_unmask_38");
         ux_q_seq_rdata_unmask_38.configure(this,null,"");
         ux_q_seq_rdata_unmask_38.build();
         // hdl path
         ux_q_seq_rdata_unmask_38.add_hdl_path_slice("ux_q_seq_rdata_unmask_38_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_39 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_39_urm::type_id::create("ux_q_seq_rdata_unmask_39");
         ux_q_seq_rdata_unmask_39.configure(this,null,"");
         ux_q_seq_rdata_unmask_39.build();
         // hdl path
         ux_q_seq_rdata_unmask_39.add_hdl_path_slice("ux_q_seq_rdata_unmask_39_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_40 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_40_urm::type_id::create("ux_q_seq_rdata_unmask_40");
         ux_q_seq_rdata_unmask_40.configure(this,null,"");
         ux_q_seq_rdata_unmask_40.build();
         // hdl path
         ux_q_seq_rdata_unmask_40.add_hdl_path_slice("ux_q_seq_rdata_unmask_40_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_41 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_41_urm::type_id::create("ux_q_seq_rdata_unmask_41");
         ux_q_seq_rdata_unmask_41.configure(this,null,"");
         ux_q_seq_rdata_unmask_41.build();
         // hdl path
         ux_q_seq_rdata_unmask_41.add_hdl_path_slice("ux_q_seq_rdata_unmask_41_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_42 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_42_urm::type_id::create("ux_q_seq_rdata_unmask_42");
         ux_q_seq_rdata_unmask_42.configure(this,null,"");
         ux_q_seq_rdata_unmask_42.build();
         // hdl path
         ux_q_seq_rdata_unmask_42.add_hdl_path_slice("ux_q_seq_rdata_unmask_42_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_43 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_43_urm::type_id::create("ux_q_seq_rdata_unmask_43");
         ux_q_seq_rdata_unmask_43.configure(this,null,"");
         ux_q_seq_rdata_unmask_43.build();
         // hdl path
         ux_q_seq_rdata_unmask_43.add_hdl_path_slice("ux_q_seq_rdata_unmask_43_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_44 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_44_urm::type_id::create("ux_q_seq_rdata_unmask_44");
         ux_q_seq_rdata_unmask_44.configure(this,null,"");
         ux_q_seq_rdata_unmask_44.build();
         // hdl path
         ux_q_seq_rdata_unmask_44.add_hdl_path_slice("ux_q_seq_rdata_unmask_44_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_45 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_45_urm::type_id::create("ux_q_seq_rdata_unmask_45");
         ux_q_seq_rdata_unmask_45.configure(this,null,"");
         ux_q_seq_rdata_unmask_45.build();
         // hdl path
         ux_q_seq_rdata_unmask_45.add_hdl_path_slice("ux_q_seq_rdata_unmask_45_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_46 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_46_urm::type_id::create("ux_q_seq_rdata_unmask_46");
         ux_q_seq_rdata_unmask_46.configure(this,null,"");
         ux_q_seq_rdata_unmask_46.build();
         // hdl path
         ux_q_seq_rdata_unmask_46.add_hdl_path_slice("ux_q_seq_rdata_unmask_46_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_47 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_47_urm::type_id::create("ux_q_seq_rdata_unmask_47");
         ux_q_seq_rdata_unmask_47.configure(this,null,"");
         ux_q_seq_rdata_unmask_47.build();
         // hdl path
         ux_q_seq_rdata_unmask_47.add_hdl_path_slice("ux_q_seq_rdata_unmask_47_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_48 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_48_urm::type_id::create("ux_q_seq_rdata_unmask_48");
         ux_q_seq_rdata_unmask_48.configure(this,null,"");
         ux_q_seq_rdata_unmask_48.build();
         // hdl path
         ux_q_seq_rdata_unmask_48.add_hdl_path_slice("ux_q_seq_rdata_unmask_48_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_49 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_49_urm::type_id::create("ux_q_seq_rdata_unmask_49");
         ux_q_seq_rdata_unmask_49.configure(this,null,"");
         ux_q_seq_rdata_unmask_49.build();
         // hdl path
         ux_q_seq_rdata_unmask_49.add_hdl_path_slice("ux_q_seq_rdata_unmask_49_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_50 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_50_urm::type_id::create("ux_q_seq_rdata_unmask_50");
         ux_q_seq_rdata_unmask_50.configure(this,null,"");
         ux_q_seq_rdata_unmask_50.build();
         // hdl path
         ux_q_seq_rdata_unmask_50.add_hdl_path_slice("ux_q_seq_rdata_unmask_50_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_51 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_51_urm::type_id::create("ux_q_seq_rdata_unmask_51");
         ux_q_seq_rdata_unmask_51.configure(this,null,"");
         ux_q_seq_rdata_unmask_51.build();
         // hdl path
         ux_q_seq_rdata_unmask_51.add_hdl_path_slice("ux_q_seq_rdata_unmask_51_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_52 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_52_urm::type_id::create("ux_q_seq_rdata_unmask_52");
         ux_q_seq_rdata_unmask_52.configure(this,null,"");
         ux_q_seq_rdata_unmask_52.build();
         // hdl path
         ux_q_seq_rdata_unmask_52.add_hdl_path_slice("ux_q_seq_rdata_unmask_52_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_53 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_53_urm::type_id::create("ux_q_seq_rdata_unmask_53");
         ux_q_seq_rdata_unmask_53.configure(this,null,"");
         ux_q_seq_rdata_unmask_53.build();
         // hdl path
         ux_q_seq_rdata_unmask_53.add_hdl_path_slice("ux_q_seq_rdata_unmask_53_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_54 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_54_urm::type_id::create("ux_q_seq_rdata_unmask_54");
         ux_q_seq_rdata_unmask_54.configure(this,null,"");
         ux_q_seq_rdata_unmask_54.build();
         // hdl path
         ux_q_seq_rdata_unmask_54.add_hdl_path_slice("ux_q_seq_rdata_unmask_54_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_55 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_55_urm::type_id::create("ux_q_seq_rdata_unmask_55");
         ux_q_seq_rdata_unmask_55.configure(this,null,"");
         ux_q_seq_rdata_unmask_55.build();
         // hdl path
         ux_q_seq_rdata_unmask_55.add_hdl_path_slice("ux_q_seq_rdata_unmask_55_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_56 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_56_urm::type_id::create("ux_q_seq_rdata_unmask_56");
         ux_q_seq_rdata_unmask_56.configure(this,null,"");
         ux_q_seq_rdata_unmask_56.build();
         // hdl path
         ux_q_seq_rdata_unmask_56.add_hdl_path_slice("ux_q_seq_rdata_unmask_56_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_57 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_57_urm::type_id::create("ux_q_seq_rdata_unmask_57");
         ux_q_seq_rdata_unmask_57.configure(this,null,"");
         ux_q_seq_rdata_unmask_57.build();
         // hdl path
         ux_q_seq_rdata_unmask_57.add_hdl_path_slice("ux_q_seq_rdata_unmask_57_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_58 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_58_urm::type_id::create("ux_q_seq_rdata_unmask_58");
         ux_q_seq_rdata_unmask_58.configure(this,null,"");
         ux_q_seq_rdata_unmask_58.build();
         // hdl path
         ux_q_seq_rdata_unmask_58.add_hdl_path_slice("ux_q_seq_rdata_unmask_58_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_59 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_59_urm::type_id::create("ux_q_seq_rdata_unmask_59");
         ux_q_seq_rdata_unmask_59.configure(this,null,"");
         ux_q_seq_rdata_unmask_59.build();
         // hdl path
         ux_q_seq_rdata_unmask_59.add_hdl_path_slice("ux_q_seq_rdata_unmask_59_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_60 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_60_urm::type_id::create("ux_q_seq_rdata_unmask_60");
         ux_q_seq_rdata_unmask_60.configure(this,null,"");
         ux_q_seq_rdata_unmask_60.build();
         // hdl path
         ux_q_seq_rdata_unmask_60.add_hdl_path_slice("ux_q_seq_rdata_unmask_60_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_61 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_61_urm::type_id::create("ux_q_seq_rdata_unmask_61");
         ux_q_seq_rdata_unmask_61.configure(this,null,"");
         ux_q_seq_rdata_unmask_61.build();
         // hdl path
         ux_q_seq_rdata_unmask_61.add_hdl_path_slice("ux_q_seq_rdata_unmask_61_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_62 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_62_urm::type_id::create("ux_q_seq_rdata_unmask_62");
         ux_q_seq_rdata_unmask_62.configure(this,null,"");
         ux_q_seq_rdata_unmask_62.build();
         // hdl path
         ux_q_seq_rdata_unmask_62.add_hdl_path_slice("ux_q_seq_rdata_unmask_62_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_seq_rdata_unmask_63 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_seq_rdata_unmask_63_urm::type_id::create("ux_q_seq_rdata_unmask_63");
         ux_q_seq_rdata_unmask_63.configure(this,null,"");
         ux_q_seq_rdata_unmask_63.build();
         // hdl path
         ux_q_seq_rdata_unmask_63.add_hdl_path_slice("ux_q_seq_rdata_unmask_63_cfg_seq_rdata_unmask",0,32);
         
         // Create registers
         ux_q_mailbox_in_l0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l0_urm::type_id::create("ux_q_mailbox_in_l0");
         ux_q_mailbox_in_l0.configure(this,null,"");
         ux_q_mailbox_in_l0.build();
         // hdl path
         ux_q_mailbox_in_l0.add_hdl_path_slice("ux_q_mailbox_in_l0_msg",0,31);
         ux_q_mailbox_in_l0.add_hdl_path_slice("ux_q_mailbox_in_l0_send_msg",31,1);
         
         // Create registers
         ux_q_mailbox_out_l0 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l0_urm::type_id::create("ux_q_mailbox_out_l0");
         ux_q_mailbox_out_l0.configure(this,null,"");
         ux_q_mailbox_out_l0.build();
         // hdl path
         ux_q_mailbox_out_l0.add_hdl_path_slice("ux_q_mailbox_out_l0_msg",0,31);
         ux_q_mailbox_out_l0.add_hdl_path_slice("ux_q_mailbox_out_l0_new_msg",31,1);
         
         // Create registers
         ux_q_mailbox_in_l1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l1_urm::type_id::create("ux_q_mailbox_in_l1");
         ux_q_mailbox_in_l1.configure(this,null,"");
         ux_q_mailbox_in_l1.build();
         // hdl path
         ux_q_mailbox_in_l1.add_hdl_path_slice("ux_q_mailbox_in_l1_msg",0,31);
         ux_q_mailbox_in_l1.add_hdl_path_slice("ux_q_mailbox_in_l1_send_msg",31,1);
         
         // Create registers
         ux_q_mailbox_out_l1 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l1_urm::type_id::create("ux_q_mailbox_out_l1");
         ux_q_mailbox_out_l1.configure(this,null,"");
         ux_q_mailbox_out_l1.build();
         // hdl path
         ux_q_mailbox_out_l1.add_hdl_path_slice("ux_q_mailbox_out_l1_msg",0,31);
         ux_q_mailbox_out_l1.add_hdl_path_slice("ux_q_mailbox_out_l1_new_msg",31,1);
         
         // Create registers
         ux_q_mailbox_in_l2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l2_urm::type_id::create("ux_q_mailbox_in_l2");
         ux_q_mailbox_in_l2.configure(this,null,"");
         ux_q_mailbox_in_l2.build();
         // hdl path
         ux_q_mailbox_in_l2.add_hdl_path_slice("ux_q_mailbox_in_l2_msg",0,31);
         ux_q_mailbox_in_l2.add_hdl_path_slice("ux_q_mailbox_in_l2_send_msg",31,1);
         
         // Create registers
         ux_q_mailbox_out_l2 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l2_urm::type_id::create("ux_q_mailbox_out_l2");
         ux_q_mailbox_out_l2.configure(this,null,"");
         ux_q_mailbox_out_l2.build();
         // hdl path
         ux_q_mailbox_out_l2.add_hdl_path_slice("ux_q_mailbox_out_l2_msg",0,31);
         ux_q_mailbox_out_l2.add_hdl_path_slice("ux_q_mailbox_out_l2_new_msg",31,1);
         
         // Create registers
         ux_q_mailbox_in_l3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_in_l3_urm::type_id::create("ux_q_mailbox_in_l3");
         ux_q_mailbox_in_l3.configure(this,null,"");
         ux_q_mailbox_in_l3.build();
         // hdl path
         ux_q_mailbox_in_l3.add_hdl_path_slice("ux_q_mailbox_in_l3_msg",0,31);
         ux_q_mailbox_in_l3.add_hdl_path_slice("ux_q_mailbox_in_l3_send_msg",31,1);
         
         // Create registers
         ux_q_mailbox_out_l3 = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_mailbox_out_l3_urm::type_id::create("ux_q_mailbox_out_l3");
         ux_q_mailbox_out_l3.configure(this,null,"");
         ux_q_mailbox_out_l3.build();
         // hdl path
         ux_q_mailbox_out_l3.add_hdl_path_slice("ux_q_mailbox_out_l3_msg",0,31);
         ux_q_mailbox_out_l3.add_hdl_path_slice("ux_q_mailbox_out_l3_new_msg",31,1);
         
         // Create registers
         ux_q_lane_number = gdr_ux_quad_avmm_cfgcsr_reg_ux_q_lane_number_urm::type_id::create("ux_q_lane_number");
         ux_q_lane_number.configure(this,null,"");
         ux_q_lane_number.build();
         // hdl path
         
      
         // Create the address map
         default_map = create_map("default_map",  `UVM_REG_ADDR_WIDTH'h0, 4, UVM_LITTLE_ENDIAN,1);
         //this.default_map = this.default_map;
         
         //mapping
         this.default_map.add_reg(ux_q_mode_ctrl, `UVM_REG_ADDR_WIDTH'h0, "RW");
         this.default_map.add_reg(ux_q_bonding_ctrl, `UVM_REG_ADDR_WIDTH'h4, "RW");
         this.default_map.add_reg(ux_q_datapath_loopback_en, `UVM_REG_ADDR_WIDTH'h8, "RW");
         this.default_map.add_reg(ux_q_ck_gating_ctrl, `UVM_REG_ADDR_WIDTH'hc, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_a_l0, `UVM_REG_ADDR_WIDTH'h10, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_b_l0, `UVM_REG_ADDR_WIDTH'h14, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_a_l1, `UVM_REG_ADDR_WIDTH'h18, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_b_l1, `UVM_REG_ADDR_WIDTH'h1c, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_a_l2, `UVM_REG_ADDR_WIDTH'h20, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_b_l2, `UVM_REG_ADDR_WIDTH'h24, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_a_l3, `UVM_REG_ADDR_WIDTH'h28, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl_b_l3, `UVM_REG_ADDR_WIDTH'h2c, "RW");
         this.default_map.add_reg(ux_q_dl_ctrl, `UVM_REG_ADDR_WIDTH'h30, "RW");
         this.default_map.add_reg(ux_q_dfd_ctrl_a, `UVM_REG_ADDR_WIDTH'h34, "RW");
         this.default_map.add_reg(ux_q_dfd_ctrl_b, `UVM_REG_ADDR_WIDTH'h38, "RW");
         this.default_map.add_reg(ux_q_rst_value_pre_user_mode, `UVM_REG_ADDR_WIDTH'h3c, "RW");
         this.default_map.add_reg(ux_q_dpma_clk_mux, `UVM_REG_ADDR_WIDTH'h40, "RW");
         this.default_map.add_reg(ux0_static_ctrl_0, `UVM_REG_ADDR_WIDTH'h44, "RW");
         this.default_map.add_reg(ux0_static_ctrl_1, `UVM_REG_ADDR_WIDTH'h48, "RW");
         this.default_map.add_reg(ux0_static_ctrl_2, `UVM_REG_ADDR_WIDTH'h4c, "RW");
         this.default_map.add_reg(ux1_static_ctrl_0, `UVM_REG_ADDR_WIDTH'h50, "RW");
         this.default_map.add_reg(ux1_static_ctrl_1, `UVM_REG_ADDR_WIDTH'h54, "RW");
         this.default_map.add_reg(ux1_static_ctrl_2, `UVM_REG_ADDR_WIDTH'h58, "RW");
         this.default_map.add_reg(ux2_static_ctrl_0, `UVM_REG_ADDR_WIDTH'h5c, "RW");
         this.default_map.add_reg(ux2_static_ctrl_1, `UVM_REG_ADDR_WIDTH'h60, "RW");
         this.default_map.add_reg(ux2_static_ctrl_2, `UVM_REG_ADDR_WIDTH'h64, "RW");
         this.default_map.add_reg(ux3_static_ctrl_0, `UVM_REG_ADDR_WIDTH'h68, "RW");
         this.default_map.add_reg(ux3_static_ctrl_1, `UVM_REG_ADDR_WIDTH'h6c, "RW");
         this.default_map.add_reg(ux3_static_ctrl_2, `UVM_REG_ADDR_WIDTH'h70, "RW");
         this.default_map.add_reg(ux0_static_ctrl_user_mode_enable_0, `UVM_REG_ADDR_WIDTH'h74, "RW");
         this.default_map.add_reg(ux0_static_ctrl_user_mode_enable_1, `UVM_REG_ADDR_WIDTH'h78, "RW");
         this.default_map.add_reg(ux0_static_ctrl_user_mode_enable_2, `UVM_REG_ADDR_WIDTH'h7c, "RW");
         this.default_map.add_reg(ux1_static_ctrl_user_mode_enable_0, `UVM_REG_ADDR_WIDTH'h80, "RW");
         this.default_map.add_reg(ux1_static_ctrl_user_mode_enable_1, `UVM_REG_ADDR_WIDTH'h84, "RW");
         this.default_map.add_reg(ux1_static_ctrl_user_mode_enable_2, `UVM_REG_ADDR_WIDTH'h88, "RW");
         this.default_map.add_reg(ux2_static_ctrl_user_mode_enable_0, `UVM_REG_ADDR_WIDTH'h8c, "RW");
         this.default_map.add_reg(ux2_static_ctrl_user_mode_enable_1, `UVM_REG_ADDR_WIDTH'h90, "RW");
         this.default_map.add_reg(ux2_static_ctrl_user_mode_enable_2, `UVM_REG_ADDR_WIDTH'h94, "RW");
         this.default_map.add_reg(ux3_static_ctrl_user_mode_enable_0, `UVM_REG_ADDR_WIDTH'h98, "RW");
         this.default_map.add_reg(ux3_static_ctrl_user_mode_enable_1, `UVM_REG_ADDR_WIDTH'h9c, "RW");
         this.default_map.add_reg(ux3_static_ctrl_user_mode_enable_2, `UVM_REG_ADDR_WIDTH'ha0, "RW");
         this.default_map.add_reg(ux0_static_ctrl_user_mode_override_0, `UVM_REG_ADDR_WIDTH'ha4, "RW");
         this.default_map.add_reg(ux0_static_ctrl_user_mode_override_1, `UVM_REG_ADDR_WIDTH'ha8, "RW");
         this.default_map.add_reg(ux0_static_ctrl_user_mode_override_2, `UVM_REG_ADDR_WIDTH'hac, "RW");
         this.default_map.add_reg(ux1_static_ctrl_user_mode_override_0, `UVM_REG_ADDR_WIDTH'hb0, "RW");
         this.default_map.add_reg(ux1_static_ctrl_user_mode_override_1, `UVM_REG_ADDR_WIDTH'hb4, "RW");
         this.default_map.add_reg(ux1_static_ctrl_user_mode_override_2, `UVM_REG_ADDR_WIDTH'hb8, "RW");
         this.default_map.add_reg(ux2_static_ctrl_user_mode_override_0, `UVM_REG_ADDR_WIDTH'hbc, "RW");
         this.default_map.add_reg(ux2_static_ctrl_user_mode_override_1, `UVM_REG_ADDR_WIDTH'hc0, "RW");
         this.default_map.add_reg(ux2_static_ctrl_user_mode_override_2, `UVM_REG_ADDR_WIDTH'hc4, "RW");
         this.default_map.add_reg(ux3_static_ctrl_user_mode_override_0, `UVM_REG_ADDR_WIDTH'hc8, "RW");
         this.default_map.add_reg(ux3_static_ctrl_user_mode_override_1, `UVM_REG_ADDR_WIDTH'hcc, "RW");
         this.default_map.add_reg(ux3_static_ctrl_user_mode_override_2, `UVM_REG_ADDR_WIDTH'hd0, "RW");
         this.default_map.add_reg(ux_q_indirect_access_ctrl, `UVM_REG_ADDR_WIDTH'hd4, "RW");
         this.default_map.add_reg(ux_q_fw_load_base_l0, `UVM_REG_ADDR_WIDTH'hd8, "RW");
         this.default_map.add_reg(ux_q_fw_load_base_l1, `UVM_REG_ADDR_WIDTH'hdc, "RW");
         this.default_map.add_reg(ux_q_fw_load_base_l2, `UVM_REG_ADDR_WIDTH'he0, "RW");
         this.default_map.add_reg(ux_q_fw_load_base_l3, `UVM_REG_ADDR_WIDTH'he4, "RW");
         this.default_map.add_reg(ux0_bonding_size, `UVM_REG_ADDR_WIDTH'he8, "RW");
         this.default_map.add_reg(ux1_bonding_size, `UVM_REG_ADDR_WIDTH'hec, "RW");
         this.default_map.add_reg(ux2_bonding_size, `UVM_REG_ADDR_WIDTH'hf0, "RW");
         this.default_map.add_reg(ux3_bonding_size, `UVM_REG_ADDR_WIDTH'hf4, "RW");
         this.default_map.add_reg(ux_q_cpi_seq_ctrl, `UVM_REG_ADDR_WIDTH'hf8, "RW");
         this.default_map.add_reg(ux_q_cpi_seq_status, `UVM_REG_ADDR_WIDTH'hfc, "RO");
         this.default_map.add_reg(ux_q_seq_ctrl_0, `UVM_REG_ADDR_WIDTH'hf000, "RW");
         this.default_map.add_reg(ux_q_seq_ctrl_1, `UVM_REG_ADDR_WIDTH'hf004, "RW");
         this.default_map.add_reg(ux_q_seq_ctrl_2, `UVM_REG_ADDR_WIDTH'hf008, "RW");
         this.default_map.add_reg(ux_q_seq_ctrl_3, `UVM_REG_ADDR_WIDTH'hf00c, "RW");
         this.default_map.add_reg(ux_q_seq_ctrl_4, `UVM_REG_ADDR_WIDTH'hf010, "RW");
         this.default_map.add_reg(ux_q_seq_data_0, `UVM_REG_ADDR_WIDTH'hf100, "RW");
         this.default_map.add_reg(ux_q_seq_data_1, `UVM_REG_ADDR_WIDTH'hf104, "RW");
         this.default_map.add_reg(ux_q_seq_data_2, `UVM_REG_ADDR_WIDTH'hf108, "RW");
         this.default_map.add_reg(ux_q_seq_data_3, `UVM_REG_ADDR_WIDTH'hf10c, "RW");
         this.default_map.add_reg(ux_q_seq_data_4, `UVM_REG_ADDR_WIDTH'hf110, "RW");
         this.default_map.add_reg(ux_q_seq_data_5, `UVM_REG_ADDR_WIDTH'hf114, "RW");
         this.default_map.add_reg(ux_q_seq_data_6, `UVM_REG_ADDR_WIDTH'hf118, "RW");
         this.default_map.add_reg(ux_q_seq_data_7, `UVM_REG_ADDR_WIDTH'hf11c, "RW");
         this.default_map.add_reg(ux_q_seq_data_8, `UVM_REG_ADDR_WIDTH'hf120, "RW");
         this.default_map.add_reg(ux_q_seq_data_9, `UVM_REG_ADDR_WIDTH'hf124, "RW");
         this.default_map.add_reg(ux_q_seq_data_10, `UVM_REG_ADDR_WIDTH'hf128, "RW");
         this.default_map.add_reg(ux_q_seq_data_11, `UVM_REG_ADDR_WIDTH'hf12c, "RW");
         this.default_map.add_reg(ux_q_seq_data_12, `UVM_REG_ADDR_WIDTH'hf130, "RW");
         this.default_map.add_reg(ux_q_seq_data_13, `UVM_REG_ADDR_WIDTH'hf134, "RW");
         this.default_map.add_reg(ux_q_seq_data_14, `UVM_REG_ADDR_WIDTH'hf138, "RW");
         this.default_map.add_reg(ux_q_seq_data_15, `UVM_REG_ADDR_WIDTH'hf13c, "RW");
         this.default_map.add_reg(ux_q_seq_data_16, `UVM_REG_ADDR_WIDTH'hf140, "RW");
         this.default_map.add_reg(ux_q_seq_data_17, `UVM_REG_ADDR_WIDTH'hf144, "RW");
         this.default_map.add_reg(ux_q_seq_data_18, `UVM_REG_ADDR_WIDTH'hf148, "RW");
         this.default_map.add_reg(ux_q_seq_data_19, `UVM_REG_ADDR_WIDTH'hf14c, "RW");
         this.default_map.add_reg(ux_q_seq_data_20, `UVM_REG_ADDR_WIDTH'hf150, "RW");
         this.default_map.add_reg(ux_q_seq_data_21, `UVM_REG_ADDR_WIDTH'hf154, "RW");
         this.default_map.add_reg(ux_q_seq_data_22, `UVM_REG_ADDR_WIDTH'hf158, "RW");
         this.default_map.add_reg(ux_q_seq_data_23, `UVM_REG_ADDR_WIDTH'hf15c, "RW");
         this.default_map.add_reg(ux_q_seq_data_24, `UVM_REG_ADDR_WIDTH'hf160, "RW");
         this.default_map.add_reg(ux_q_seq_data_25, `UVM_REG_ADDR_WIDTH'hf164, "RW");
         this.default_map.add_reg(ux_q_seq_data_26, `UVM_REG_ADDR_WIDTH'hf168, "RW");
         this.default_map.add_reg(ux_q_seq_data_27, `UVM_REG_ADDR_WIDTH'hf16c, "RW");
         this.default_map.add_reg(ux_q_seq_data_28, `UVM_REG_ADDR_WIDTH'hf170, "RW");
         this.default_map.add_reg(ux_q_seq_data_29, `UVM_REG_ADDR_WIDTH'hf174, "RW");
         this.default_map.add_reg(ux_q_seq_data_30, `UVM_REG_ADDR_WIDTH'hf178, "RW");
         this.default_map.add_reg(ux_q_seq_data_31, `UVM_REG_ADDR_WIDTH'hf17c, "RW");
         this.default_map.add_reg(ux_q_seq_data_32, `UVM_REG_ADDR_WIDTH'hf180, "RW");
         this.default_map.add_reg(ux_q_seq_data_33, `UVM_REG_ADDR_WIDTH'hf184, "RW");
         this.default_map.add_reg(ux_q_seq_data_34, `UVM_REG_ADDR_WIDTH'hf188, "RW");
         this.default_map.add_reg(ux_q_seq_data_35, `UVM_REG_ADDR_WIDTH'hf18c, "RW");
         this.default_map.add_reg(ux_q_seq_data_36, `UVM_REG_ADDR_WIDTH'hf190, "RW");
         this.default_map.add_reg(ux_q_seq_data_37, `UVM_REG_ADDR_WIDTH'hf194, "RW");
         this.default_map.add_reg(ux_q_seq_data_38, `UVM_REG_ADDR_WIDTH'hf198, "RW");
         this.default_map.add_reg(ux_q_seq_data_39, `UVM_REG_ADDR_WIDTH'hf19c, "RW");
         this.default_map.add_reg(ux_q_seq_data_40, `UVM_REG_ADDR_WIDTH'hf1a0, "RW");
         this.default_map.add_reg(ux_q_seq_data_41, `UVM_REG_ADDR_WIDTH'hf1a4, "RW");
         this.default_map.add_reg(ux_q_seq_data_42, `UVM_REG_ADDR_WIDTH'hf1a8, "RW");
         this.default_map.add_reg(ux_q_seq_data_43, `UVM_REG_ADDR_WIDTH'hf1ac, "RW");
         this.default_map.add_reg(ux_q_seq_data_44, `UVM_REG_ADDR_WIDTH'hf1b0, "RW");
         this.default_map.add_reg(ux_q_seq_data_45, `UVM_REG_ADDR_WIDTH'hf1b4, "RW");
         this.default_map.add_reg(ux_q_seq_data_46, `UVM_REG_ADDR_WIDTH'hf1b8, "RW");
         this.default_map.add_reg(ux_q_seq_data_47, `UVM_REG_ADDR_WIDTH'hf1bc, "RW");
         this.default_map.add_reg(ux_q_seq_data_48, `UVM_REG_ADDR_WIDTH'hf1c0, "RW");
         this.default_map.add_reg(ux_q_seq_data_49, `UVM_REG_ADDR_WIDTH'hf1c4, "RW");
         this.default_map.add_reg(ux_q_seq_data_50, `UVM_REG_ADDR_WIDTH'hf1c8, "RW");
         this.default_map.add_reg(ux_q_seq_data_51, `UVM_REG_ADDR_WIDTH'hf1cc, "RW");
         this.default_map.add_reg(ux_q_seq_data_52, `UVM_REG_ADDR_WIDTH'hf1d0, "RW");
         this.default_map.add_reg(ux_q_seq_data_53, `UVM_REG_ADDR_WIDTH'hf1d4, "RW");
         this.default_map.add_reg(ux_q_seq_data_54, `UVM_REG_ADDR_WIDTH'hf1d8, "RW");
         this.default_map.add_reg(ux_q_seq_data_55, `UVM_REG_ADDR_WIDTH'hf1dc, "RW");
         this.default_map.add_reg(ux_q_seq_data_56, `UVM_REG_ADDR_WIDTH'hf1e0, "RW");
         this.default_map.add_reg(ux_q_seq_data_57, `UVM_REG_ADDR_WIDTH'hf1e4, "RW");
         this.default_map.add_reg(ux_q_seq_data_58, `UVM_REG_ADDR_WIDTH'hf1e8, "RW");
         this.default_map.add_reg(ux_q_seq_data_59, `UVM_REG_ADDR_WIDTH'hf1ec, "RW");
         this.default_map.add_reg(ux_q_seq_data_60, `UVM_REG_ADDR_WIDTH'hf1f0, "RW");
         this.default_map.add_reg(ux_q_seq_data_61, `UVM_REG_ADDR_WIDTH'hf1f4, "RW");
         this.default_map.add_reg(ux_q_seq_data_62, `UVM_REG_ADDR_WIDTH'hf1f8, "RW");
         this.default_map.add_reg(ux_q_seq_data_63, `UVM_REG_ADDR_WIDTH'hf1fc, "RW");
         this.default_map.add_reg(ux_q_seq_addr_0, `UVM_REG_ADDR_WIDTH'hf200, "RW");
         this.default_map.add_reg(ux_q_seq_addr_1, `UVM_REG_ADDR_WIDTH'hf204, "RW");
         this.default_map.add_reg(ux_q_seq_addr_2, `UVM_REG_ADDR_WIDTH'hf208, "RW");
         this.default_map.add_reg(ux_q_seq_addr_3, `UVM_REG_ADDR_WIDTH'hf20c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_4, `UVM_REG_ADDR_WIDTH'hf210, "RW");
         this.default_map.add_reg(ux_q_seq_addr_5, `UVM_REG_ADDR_WIDTH'hf214, "RW");
         this.default_map.add_reg(ux_q_seq_addr_6, `UVM_REG_ADDR_WIDTH'hf218, "RW");
         this.default_map.add_reg(ux_q_seq_addr_7, `UVM_REG_ADDR_WIDTH'hf21c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_8, `UVM_REG_ADDR_WIDTH'hf220, "RW");
         this.default_map.add_reg(ux_q_seq_addr_9, `UVM_REG_ADDR_WIDTH'hf224, "RW");
         this.default_map.add_reg(ux_q_seq_addr_10, `UVM_REG_ADDR_WIDTH'hf228, "RW");
         this.default_map.add_reg(ux_q_seq_addr_11, `UVM_REG_ADDR_WIDTH'hf22c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_12, `UVM_REG_ADDR_WIDTH'hf230, "RW");
         this.default_map.add_reg(ux_q_seq_addr_13, `UVM_REG_ADDR_WIDTH'hf234, "RW");
         this.default_map.add_reg(ux_q_seq_addr_14, `UVM_REG_ADDR_WIDTH'hf238, "RW");
         this.default_map.add_reg(ux_q_seq_addr_15, `UVM_REG_ADDR_WIDTH'hf23c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_16, `UVM_REG_ADDR_WIDTH'hf240, "RW");
         this.default_map.add_reg(ux_q_seq_addr_17, `UVM_REG_ADDR_WIDTH'hf244, "RW");
         this.default_map.add_reg(ux_q_seq_addr_18, `UVM_REG_ADDR_WIDTH'hf248, "RW");
         this.default_map.add_reg(ux_q_seq_addr_19, `UVM_REG_ADDR_WIDTH'hf24c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_20, `UVM_REG_ADDR_WIDTH'hf250, "RW");
         this.default_map.add_reg(ux_q_seq_addr_21, `UVM_REG_ADDR_WIDTH'hf254, "RW");
         this.default_map.add_reg(ux_q_seq_addr_22, `UVM_REG_ADDR_WIDTH'hf258, "RW");
         this.default_map.add_reg(ux_q_seq_addr_23, `UVM_REG_ADDR_WIDTH'hf25c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_24, `UVM_REG_ADDR_WIDTH'hf260, "RW");
         this.default_map.add_reg(ux_q_seq_addr_25, `UVM_REG_ADDR_WIDTH'hf264, "RW");
         this.default_map.add_reg(ux_q_seq_addr_26, `UVM_REG_ADDR_WIDTH'hf268, "RW");
         this.default_map.add_reg(ux_q_seq_addr_27, `UVM_REG_ADDR_WIDTH'hf26c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_28, `UVM_REG_ADDR_WIDTH'hf270, "RW");
         this.default_map.add_reg(ux_q_seq_addr_29, `UVM_REG_ADDR_WIDTH'hf274, "RW");
         this.default_map.add_reg(ux_q_seq_addr_30, `UVM_REG_ADDR_WIDTH'hf278, "RW");
         this.default_map.add_reg(ux_q_seq_addr_31, `UVM_REG_ADDR_WIDTH'hf27c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_32, `UVM_REG_ADDR_WIDTH'hf280, "RW");
         this.default_map.add_reg(ux_q_seq_addr_33, `UVM_REG_ADDR_WIDTH'hf284, "RW");
         this.default_map.add_reg(ux_q_seq_addr_34, `UVM_REG_ADDR_WIDTH'hf288, "RW");
         this.default_map.add_reg(ux_q_seq_addr_35, `UVM_REG_ADDR_WIDTH'hf28c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_36, `UVM_REG_ADDR_WIDTH'hf290, "RW");
         this.default_map.add_reg(ux_q_seq_addr_37, `UVM_REG_ADDR_WIDTH'hf294, "RW");
         this.default_map.add_reg(ux_q_seq_addr_38, `UVM_REG_ADDR_WIDTH'hf298, "RW");
         this.default_map.add_reg(ux_q_seq_addr_39, `UVM_REG_ADDR_WIDTH'hf29c, "RW");
         this.default_map.add_reg(ux_q_seq_addr_40, `UVM_REG_ADDR_WIDTH'hf2a0, "RW");
         this.default_map.add_reg(ux_q_seq_addr_41, `UVM_REG_ADDR_WIDTH'hf2a4, "RW");
         this.default_map.add_reg(ux_q_seq_addr_42, `UVM_REG_ADDR_WIDTH'hf2a8, "RW");
         this.default_map.add_reg(ux_q_seq_addr_43, `UVM_REG_ADDR_WIDTH'hf2ac, "RW");
         this.default_map.add_reg(ux_q_seq_addr_44, `UVM_REG_ADDR_WIDTH'hf2b0, "RW");
         this.default_map.add_reg(ux_q_seq_addr_45, `UVM_REG_ADDR_WIDTH'hf2b4, "RW");
         this.default_map.add_reg(ux_q_seq_addr_46, `UVM_REG_ADDR_WIDTH'hf2b8, "RW");
         this.default_map.add_reg(ux_q_seq_addr_47, `UVM_REG_ADDR_WIDTH'hf2bc, "RW");
         this.default_map.add_reg(ux_q_seq_addr_48, `UVM_REG_ADDR_WIDTH'hf2c0, "RW");
         this.default_map.add_reg(ux_q_seq_addr_49, `UVM_REG_ADDR_WIDTH'hf2c4, "RW");
         this.default_map.add_reg(ux_q_seq_addr_50, `UVM_REG_ADDR_WIDTH'hf2c8, "RW");
         this.default_map.add_reg(ux_q_seq_addr_51, `UVM_REG_ADDR_WIDTH'hf2cc, "RW");
         this.default_map.add_reg(ux_q_seq_addr_52, `UVM_REG_ADDR_WIDTH'hf2d0, "RW");
         this.default_map.add_reg(ux_q_seq_addr_53, `UVM_REG_ADDR_WIDTH'hf2d4, "RW");
         this.default_map.add_reg(ux_q_seq_addr_54, `UVM_REG_ADDR_WIDTH'hf2d8, "RW");
         this.default_map.add_reg(ux_q_seq_addr_55, `UVM_REG_ADDR_WIDTH'hf2dc, "RW");
         this.default_map.add_reg(ux_q_seq_addr_56, `UVM_REG_ADDR_WIDTH'hf2e0, "RW");
         this.default_map.add_reg(ux_q_seq_addr_57, `UVM_REG_ADDR_WIDTH'hf2e4, "RW");
         this.default_map.add_reg(ux_q_seq_addr_58, `UVM_REG_ADDR_WIDTH'hf2e8, "RW");
         this.default_map.add_reg(ux_q_seq_addr_59, `UVM_REG_ADDR_WIDTH'hf2ec, "RW");
         this.default_map.add_reg(ux_q_seq_addr_60, `UVM_REG_ADDR_WIDTH'hf2f0, "RW");
         this.default_map.add_reg(ux_q_seq_addr_61, `UVM_REG_ADDR_WIDTH'hf2f4, "RW");
         this.default_map.add_reg(ux_q_seq_addr_62, `UVM_REG_ADDR_WIDTH'hf2f8, "RW");
         this.default_map.add_reg(ux_q_seq_addr_63, `UVM_REG_ADDR_WIDTH'hf2fc, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_0, `UVM_REG_ADDR_WIDTH'hf300, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_1, `UVM_REG_ADDR_WIDTH'hf304, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_2, `UVM_REG_ADDR_WIDTH'hf308, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_3, `UVM_REG_ADDR_WIDTH'hf30c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_4, `UVM_REG_ADDR_WIDTH'hf310, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_5, `UVM_REG_ADDR_WIDTH'hf314, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_6, `UVM_REG_ADDR_WIDTH'hf318, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_7, `UVM_REG_ADDR_WIDTH'hf31c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_8, `UVM_REG_ADDR_WIDTH'hf320, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_9, `UVM_REG_ADDR_WIDTH'hf324, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_10, `UVM_REG_ADDR_WIDTH'hf328, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_11, `UVM_REG_ADDR_WIDTH'hf32c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_12, `UVM_REG_ADDR_WIDTH'hf330, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_13, `UVM_REG_ADDR_WIDTH'hf334, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_14, `UVM_REG_ADDR_WIDTH'hf338, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_15, `UVM_REG_ADDR_WIDTH'hf33c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_16, `UVM_REG_ADDR_WIDTH'hf340, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_17, `UVM_REG_ADDR_WIDTH'hf344, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_18, `UVM_REG_ADDR_WIDTH'hf348, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_19, `UVM_REG_ADDR_WIDTH'hf34c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_20, `UVM_REG_ADDR_WIDTH'hf350, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_21, `UVM_REG_ADDR_WIDTH'hf354, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_22, `UVM_REG_ADDR_WIDTH'hf358, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_23, `UVM_REG_ADDR_WIDTH'hf35c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_24, `UVM_REG_ADDR_WIDTH'hf360, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_25, `UVM_REG_ADDR_WIDTH'hf364, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_26, `UVM_REG_ADDR_WIDTH'hf368, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_27, `UVM_REG_ADDR_WIDTH'hf36c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_28, `UVM_REG_ADDR_WIDTH'hf370, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_29, `UVM_REG_ADDR_WIDTH'hf374, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_30, `UVM_REG_ADDR_WIDTH'hf378, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_31, `UVM_REG_ADDR_WIDTH'hf37c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_32, `UVM_REG_ADDR_WIDTH'hf380, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_33, `UVM_REG_ADDR_WIDTH'hf384, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_34, `UVM_REG_ADDR_WIDTH'hf388, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_35, `UVM_REG_ADDR_WIDTH'hf38c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_36, `UVM_REG_ADDR_WIDTH'hf390, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_37, `UVM_REG_ADDR_WIDTH'hf394, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_38, `UVM_REG_ADDR_WIDTH'hf398, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_39, `UVM_REG_ADDR_WIDTH'hf39c, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_40, `UVM_REG_ADDR_WIDTH'hf3a0, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_41, `UVM_REG_ADDR_WIDTH'hf3a4, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_42, `UVM_REG_ADDR_WIDTH'hf3a8, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_43, `UVM_REG_ADDR_WIDTH'hf3ac, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_44, `UVM_REG_ADDR_WIDTH'hf3b0, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_45, `UVM_REG_ADDR_WIDTH'hf3b4, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_46, `UVM_REG_ADDR_WIDTH'hf3b8, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_47, `UVM_REG_ADDR_WIDTH'hf3bc, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_48, `UVM_REG_ADDR_WIDTH'hf3c0, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_49, `UVM_REG_ADDR_WIDTH'hf3c4, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_50, `UVM_REG_ADDR_WIDTH'hf3c8, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_51, `UVM_REG_ADDR_WIDTH'hf3cc, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_52, `UVM_REG_ADDR_WIDTH'hf3d0, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_53, `UVM_REG_ADDR_WIDTH'hf3d4, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_54, `UVM_REG_ADDR_WIDTH'hf3d8, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_55, `UVM_REG_ADDR_WIDTH'hf3dc, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_56, `UVM_REG_ADDR_WIDTH'hf3e0, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_57, `UVM_REG_ADDR_WIDTH'hf3e4, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_58, `UVM_REG_ADDR_WIDTH'hf3e8, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_59, `UVM_REG_ADDR_WIDTH'hf3ec, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_60, `UVM_REG_ADDR_WIDTH'hf3f0, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_61, `UVM_REG_ADDR_WIDTH'hf3f4, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_62, `UVM_REG_ADDR_WIDTH'hf3f8, "RW");
         this.default_map.add_reg(ux_q_seq_rdata_unmask_63, `UVM_REG_ADDR_WIDTH'hf3fc, "RW");
         this.default_map.add_reg(ux_q_mailbox_in_l0, `UVM_REG_ADDR_WIDTH'hffd0, "RW");
         this.default_map.add_reg(ux_q_mailbox_out_l0, `UVM_REG_ADDR_WIDTH'hffd4, "RW");
         this.default_map.add_reg(ux_q_mailbox_in_l1, `UVM_REG_ADDR_WIDTH'hffd8, "RW");
         this.default_map.add_reg(ux_q_mailbox_out_l1, `UVM_REG_ADDR_WIDTH'hffdc, "RW");
         this.default_map.add_reg(ux_q_mailbox_in_l2, `UVM_REG_ADDR_WIDTH'hffe0, "RW");
         this.default_map.add_reg(ux_q_mailbox_out_l2, `UVM_REG_ADDR_WIDTH'hffe4, "RW");
         this.default_map.add_reg(ux_q_mailbox_in_l3, `UVM_REG_ADDR_WIDTH'hffe8, "RW");
         this.default_map.add_reg(ux_q_mailbox_out_l3, `UVM_REG_ADDR_WIDTH'hffec, "RW");
         this.default_map.add_reg(ux_q_lane_number, `UVM_REG_ADDR_WIDTH'hfffc, "RO");
         
         void'(set_coverage(UVM_CVR_FIELD_VALS));
         
      endfunction : build

endclass : gdr_ux_quad_avmm_cfgcsr_urm

`endif // __GDR_UX_QUAD_AVMM_CFGCSR_URM_SVH__
