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
--- Date :Tue Apr 17 15:31:23 PDT 2018
----------------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------------------------------
--- UVM Register Model
--- Component Name: xcvr_reconfig
--- File Ref: /data/karlche1/crete3eRDL/xcvr_reconfig_csrgen_output/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_xcvr_reconfig_1.0.xml
--- Options: packageNaming :false, compFileNaming : false 
--- Magillem Version :   5.8.2.3_engineering
----------------------------------------------------------------------------------------------------*/


`ifndef __XCVR_RECONFIG_URM_SVH__
`define __XCVR_RECONFIG_URM_SVH__

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_rst_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_rst_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_rst_ctrl_urm  )

      rand uvm_reg_field cfg_sft_rst_tx_n;
      rand uvm_reg_field cfg_sft_rst_rx_n;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_sft_rst_tx_n_value : coverpoint cfg_sft_rst_tx_n.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_sft_rst_rx_n_value : coverpoint cfg_sft_rst_rx_n.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_rst_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_sft_rst_tx_n = uvm_reg_field::type_id::create("cfg_sft_rst_tx_n");
         // configure
         cfg_sft_rst_tx_n.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_sft_rst_rx_n = uvm_reg_field::type_id::create("cfg_sft_rst_rx_n");
         // configure
         cfg_sft_rst_rx_n.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
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
      
endclass : xcvr_reconfig_reg_xcvrif_rst_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_ctrl0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_ctrl0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_ctrl0_urm  )

      rand uvm_reg_field cfg_clk_en_tx;
      rand uvm_reg_field cfg_clk_en_full_tx;
      rand uvm_reg_field cfg_tx_data_in_sel;
      rand uvm_reg_field cfg_tx_clk_out_sel;
      rand uvm_reg_field cfg_tx_clk_dp_sel;
      rand uvm_reg_field cfg_tx_adapt_order_sel;
      rand uvm_reg_field cfg_tx_ml_sel;
      rand uvm_reg_field cfg_clk_en_tx_gbx;
      rand uvm_reg_field cfg_clk_en_tx_datapath;
      rand uvm_reg_field cfg_clk_en_pcs_d2_tx;
      rand uvm_reg_field cfg_clk_en_fec_d2_tx;
      rand uvm_reg_field cfg_clk_en_ehip_d2_tx;
      rand uvm_reg_field cfg_clk_en_direct_tx;
      rand uvm_reg_field cfg_clk_en_rx;
      rand uvm_reg_field cfg_clk_en_full_rx;
      rand uvm_reg_field cfg_clk_en_half_rx;
      rand uvm_reg_field cfg_clk_en_div66_rx;
      rand uvm_reg_field cfg_rx_adapt_order_sel;
      rand uvm_reg_field cfg_rx_adapter_sel;
      rand uvm_reg_field cfg_rx_revbitorder;
      rand uvm_reg_field cfg_rx_c_revbitorder;
      rand uvm_reg_field cfg_clk_en_fifo_rd_rx;
      rand uvm_reg_field cfg_clk_en_fifo_rx;
      rand uvm_reg_field cfg_rx_ml_sel;
      rand uvm_reg_field cfg_rx_fifo_clk_sel;
      rand uvm_reg_field cfg_clk_en_rx_adapt;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_clk_en_tx_value : coverpoint cfg_clk_en_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_full_tx_value : coverpoint cfg_clk_en_full_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_data_in_sel_value : coverpoint cfg_tx_data_in_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_tx_clk_out_sel_value : coverpoint cfg_tx_clk_out_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_clk_dp_sel_value : coverpoint cfg_tx_clk_dp_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_adapt_order_sel_value : coverpoint cfg_tx_adapt_order_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_ml_sel_value : coverpoint cfg_tx_ml_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_clk_en_tx_gbx_value : coverpoint cfg_clk_en_tx_gbx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_tx_datapath_value : coverpoint cfg_clk_en_tx_datapath.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_pcs_d2_tx_value : coverpoint cfg_clk_en_pcs_d2_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_fec_d2_tx_value : coverpoint cfg_clk_en_fec_d2_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_ehip_d2_tx_value : coverpoint cfg_clk_en_ehip_d2_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_direct_tx_value : coverpoint cfg_clk_en_direct_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_rx_value : coverpoint cfg_clk_en_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_full_rx_value : coverpoint cfg_clk_en_full_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_half_rx_value : coverpoint cfg_clk_en_half_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_div66_rx_value : coverpoint cfg_clk_en_div66_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_adapt_order_sel_value : coverpoint cfg_rx_adapt_order_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_adapter_sel_value : coverpoint cfg_rx_adapter_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_rx_revbitorder_value : coverpoint cfg_rx_revbitorder.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_c_revbitorder_value : coverpoint cfg_rx_c_revbitorder.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_fifo_rd_rx_value : coverpoint cfg_clk_en_fifo_rd_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_fifo_rx_value : coverpoint cfg_clk_en_fifo_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_ml_sel_value : coverpoint cfg_rx_ml_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_rx_fifo_clk_sel_value : coverpoint cfg_rx_fifo_clk_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_clk_en_rx_adapt_value : coverpoint cfg_clk_en_rx_adapt.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_ctrl0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_clk_en_tx = uvm_reg_field::type_id::create("cfg_clk_en_tx");
         // configure
         cfg_clk_en_tx.configure(
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
         cfg_clk_en_full_tx = uvm_reg_field::type_id::create("cfg_clk_en_full_tx");
         // configure
         cfg_clk_en_full_tx.configure(
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
         cfg_tx_data_in_sel = uvm_reg_field::type_id::create("cfg_tx_data_in_sel");
         // configure
         cfg_tx_data_in_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_tx_clk_out_sel = uvm_reg_field::type_id::create("cfg_tx_clk_out_sel");
         // configure
         cfg_tx_clk_out_sel.configure(
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
         cfg_tx_clk_dp_sel = uvm_reg_field::type_id::create("cfg_tx_clk_dp_sel");
         // configure
         cfg_tx_clk_dp_sel.configure(
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
         cfg_tx_adapt_order_sel = uvm_reg_field::type_id::create("cfg_tx_adapt_order_sel");
         // configure
         cfg_tx_adapt_order_sel.configure(
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
         cfg_tx_ml_sel = uvm_reg_field::type_id::create("cfg_tx_ml_sel");
         // configure
         cfg_tx_ml_sel.configure(
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
         cfg_clk_en_tx_gbx = uvm_reg_field::type_id::create("cfg_clk_en_tx_gbx");
         // configure
         cfg_clk_en_tx_gbx.configure(
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
         cfg_clk_en_tx_datapath = uvm_reg_field::type_id::create("cfg_clk_en_tx_datapath");
         // configure
         cfg_clk_en_tx_datapath.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_pcs_d2_tx = uvm_reg_field::type_id::create("cfg_clk_en_pcs_d2_tx");
         // configure
         cfg_clk_en_pcs_d2_tx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_fec_d2_tx = uvm_reg_field::type_id::create("cfg_clk_en_fec_d2_tx");
         // configure
         cfg_clk_en_fec_d2_tx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_ehip_d2_tx = uvm_reg_field::type_id::create("cfg_clk_en_ehip_d2_tx");
         // configure
         cfg_clk_en_ehip_d2_tx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_direct_tx = uvm_reg_field::type_id::create("cfg_clk_en_direct_tx");
         // configure
         cfg_clk_en_direct_tx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_rx = uvm_reg_field::type_id::create("cfg_clk_en_rx");
         // configure
         cfg_clk_en_rx.configure(
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
         cfg_clk_en_full_rx = uvm_reg_field::type_id::create("cfg_clk_en_full_rx");
         // configure
         cfg_clk_en_full_rx.configure(
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
         cfg_clk_en_half_rx = uvm_reg_field::type_id::create("cfg_clk_en_half_rx");
         // configure
         cfg_clk_en_half_rx.configure(
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
         cfg_clk_en_div66_rx = uvm_reg_field::type_id::create("cfg_clk_en_div66_rx");
         // configure
         cfg_clk_en_div66_rx.configure(
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
         cfg_rx_adapt_order_sel = uvm_reg_field::type_id::create("cfg_rx_adapt_order_sel");
         // configure
         cfg_rx_adapt_order_sel.configure(
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
         cfg_rx_adapter_sel = uvm_reg_field::type_id::create("cfg_rx_adapter_sel");
         // configure
         cfg_rx_adapter_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_revbitorder = uvm_reg_field::type_id::create("cfg_rx_revbitorder");
         // configure
         cfg_rx_revbitorder.configure(
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
         cfg_rx_c_revbitorder = uvm_reg_field::type_id::create("cfg_rx_c_revbitorder");
         // configure
         cfg_rx_c_revbitorder.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_fifo_rd_rx = uvm_reg_field::type_id::create("cfg_clk_en_fifo_rd_rx");
         // configure
         cfg_clk_en_fifo_rd_rx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_fifo_rx = uvm_reg_field::type_id::create("cfg_clk_en_fifo_rx");
         // configure
         cfg_clk_en_fifo_rx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_ml_sel = uvm_reg_field::type_id::create("cfg_rx_ml_sel");
         // configure
         cfg_rx_ml_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_fifo_clk_sel = uvm_reg_field::type_id::create("cfg_rx_fifo_clk_sel");
         // configure
         cfg_rx_fifo_clk_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_rx_adapt = uvm_reg_field::type_id::create("cfg_clk_en_rx_adapt");
         // configure
         cfg_clk_en_rx_adapt.configure(
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
      
endclass : xcvr_reconfig_reg_xcvrif_ctrl0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_ctrl1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_ctrl1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_ctrl1_urm  )

      rand uvm_reg_field cfg_revbitorder;
      rand uvm_reg_field cfg_c_revbitorder;
      rand uvm_reg_field cfg_tx_bitslip;
      rand uvm_reg_field cfg_sh_location;
      rand uvm_reg_field cfg_tx_dskew_ml_sel;
      rand uvm_reg_field cfg_tx_deskew_sts;
      rand uvm_reg_field cfg_rx_tag_sel;
      rand uvm_reg_field cfg_rx_rden_sel;
      rand uvm_reg_field cfg_en_tx_deskew;
      rand uvm_reg_field cfg_rx_bitslip;
      rand uvm_reg_field cfg_rx_pcs_data_sel;
      rand uvm_reg_field cfg_rx_sh_location;
      rand uvm_reg_field cfg_xcvrif_bonding_slv_config;
      rand uvm_reg_field cfg_rst_en_rx;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_revbitorder_value : coverpoint cfg_revbitorder.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_c_revbitorder_value : coverpoint cfg_c_revbitorder.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_bitslip_value : coverpoint cfg_tx_bitslip.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_sh_location_value : coverpoint cfg_sh_location.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_dskew_ml_sel_value : coverpoint cfg_tx_dskew_ml_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_tx_deskew_sts_value : coverpoint cfg_tx_deskew_sts.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_rx_tag_sel_value : coverpoint cfg_rx_tag_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_rden_sel_value : coverpoint cfg_rx_rden_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_tx_deskew_value : coverpoint cfg_en_tx_deskew.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_rx_bitslip_value : coverpoint cfg_rx_bitslip.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_pcs_data_sel_value : coverpoint cfg_rx_pcs_data_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_sh_location_value : coverpoint cfg_rx_sh_location.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_xcvrif_bonding_slv_config_value : coverpoint cfg_xcvrif_bonding_slv_config.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rst_en_rx_value : coverpoint cfg_rst_en_rx.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_ctrl1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_revbitorder = uvm_reg_field::type_id::create("cfg_revbitorder");
         // configure
         cfg_revbitorder.configure(
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
         cfg_c_revbitorder = uvm_reg_field::type_id::create("cfg_c_revbitorder");
         // configure
         cfg_c_revbitorder.configure(
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
         cfg_tx_bitslip = uvm_reg_field::type_id::create("cfg_tx_bitslip");
         // configure
         cfg_tx_bitslip.configure(
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
         cfg_sh_location = uvm_reg_field::type_id::create("cfg_sh_location");
         // configure
         cfg_sh_location.configure(
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
         cfg_tx_dskew_ml_sel = uvm_reg_field::type_id::create("cfg_tx_dskew_ml_sel");
         // configure
         cfg_tx_dskew_ml_sel.configure(
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
         cfg_tx_deskew_sts = uvm_reg_field::type_id::create("cfg_tx_deskew_sts");
         // configure
         cfg_tx_deskew_sts.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (10),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_tag_sel = uvm_reg_field::type_id::create("cfg_rx_tag_sel");
         // configure
         cfg_rx_tag_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_rden_sel = uvm_reg_field::type_id::create("cfg_rx_rden_sel");
         // configure
         cfg_rx_rden_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_en_tx_deskew = uvm_reg_field::type_id::create("cfg_en_tx_deskew");
         // configure
         cfg_en_tx_deskew.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_bitslip = uvm_reg_field::type_id::create("cfg_rx_bitslip");
         // configure
         cfg_rx_bitslip.configure(
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
         cfg_rx_pcs_data_sel = uvm_reg_field::type_id::create("cfg_rx_pcs_data_sel");
         // configure
         cfg_rx_pcs_data_sel.configure(
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
         cfg_rx_sh_location = uvm_reg_field::type_id::create("cfg_rx_sh_location");
         // configure
         cfg_rx_sh_location.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_xcvrif_bonding_slv_config = uvm_reg_field::type_id::create("cfg_xcvrif_bonding_slv_config");
         // configure
         cfg_xcvrif_bonding_slv_config.configure(
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
         cfg_rst_en_rx = uvm_reg_field::type_id::create("cfg_rst_en_rx");
         // configure
         cfg_rst_en_rx.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_ctrl1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_gb_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_gb_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_gb_ctrl_urm  )

      rand uvm_reg_field cfg_gb_idwidth;
      rand uvm_reg_field cfg_gb_odwidth;
      rand uvm_reg_field cfg_rx_gb_idwidth;
      rand uvm_reg_field cfg_rx_gb_odwidth;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_gb_idwidth_value : coverpoint cfg_gb_idwidth.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_gb_odwidth_value : coverpoint cfg_gb_odwidth.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_rx_gb_idwidth_value : coverpoint cfg_rx_gb_idwidth.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_rx_gb_odwidth_value : coverpoint cfg_rx_gb_odwidth.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_gb_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_gb_idwidth = uvm_reg_field::type_id::create("cfg_gb_idwidth");
         // configure
         cfg_gb_idwidth.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_gb_odwidth = uvm_reg_field::type_id::create("cfg_gb_odwidth");
         // configure
         cfg_gb_odwidth.configure(
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
         cfg_rx_gb_idwidth = uvm_reg_field::type_id::create("cfg_rx_gb_idwidth");
         // configure
         cfg_rx_gb_idwidth.configure(
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
         cfg_rx_gb_odwidth = uvm_reg_field::type_id::create("cfg_rx_gb_odwidth");
         // configure
         cfg_rx_gb_odwidth.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_gb_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm  )

      rand uvm_reg_field cfg_rxfifo_e_thld;
      rand uvm_reg_field cfg_rxfifo_ae_thld;
      rand uvm_reg_field cfg_rxfifo_f_thld;
      rand uvm_reg_field cfg_rxfifo_af_thld;
      rand uvm_reg_field cfg_rxfifo_rd_empty;
      rand uvm_reg_field cfg_rxfifo_wr_full;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rxfifo_e_thld_value : coverpoint cfg_rxfifo_e_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_rxfifo_ae_thld_value : coverpoint cfg_rxfifo_ae_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_rxfifo_f_thld_value : coverpoint cfg_rxfifo_f_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_rxfifo_af_thld_value : coverpoint cfg_rxfifo_af_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_rxfifo_rd_empty_value : coverpoint cfg_rxfifo_rd_empty.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rxfifo_wr_full_value : coverpoint cfg_rxfifo_wr_full.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rxfifo_e_thld = uvm_reg_field::type_id::create("cfg_rxfifo_e_thld");
         // configure
         cfg_rxfifo_e_thld.configure(
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
         cfg_rxfifo_ae_thld = uvm_reg_field::type_id::create("cfg_rxfifo_ae_thld");
         // configure
         cfg_rxfifo_ae_thld.configure(
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
         cfg_rxfifo_f_thld = uvm_reg_field::type_id::create("cfg_rxfifo_f_thld");
         // configure
         cfg_rxfifo_f_thld.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rxfifo_af_thld = uvm_reg_field::type_id::create("cfg_rxfifo_af_thld");
         // configure
         cfg_rxfifo_af_thld.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rxfifo_rd_empty = uvm_reg_field::type_id::create("cfg_rxfifo_rd_empty");
         // configure
         cfg_rxfifo_rd_empty.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rxfifo_wr_full = uvm_reg_field::type_id::create("cfg_rxfifo_wr_full");
         // configure
         cfg_rxfifo_wr_full.configure(
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
      
endclass : xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm  )

      rand uvm_reg_field cfg_txfifo_e_thld;
      rand uvm_reg_field cfg_txfifo_ae_thld;
      rand uvm_reg_field cfg_txfifo_f_thld;
      rand uvm_reg_field cfg_txfifo_af_thld;
      rand uvm_reg_field cfg_txfifo_ph_comp;
      rand uvm_reg_field cfg_txfifo_wr_full;
      rand uvm_reg_field cfg_txfifo_rd_empty;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_txfifo_e_thld_value : coverpoint cfg_txfifo_e_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_txfifo_ae_thld_value : coverpoint cfg_txfifo_ae_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_txfifo_f_thld_value : coverpoint cfg_txfifo_f_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_txfifo_af_thld_value : coverpoint cfg_txfifo_af_thld.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_txfifo_ph_comp_value : coverpoint cfg_txfifo_ph_comp.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_txfifo_wr_full_value : coverpoint cfg_txfifo_wr_full.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_txfifo_rd_empty_value : coverpoint cfg_txfifo_rd_empty.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_txfifo_e_thld = uvm_reg_field::type_id::create("cfg_txfifo_e_thld");
         // configure
         cfg_txfifo_e_thld.configure(
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
         cfg_txfifo_ae_thld = uvm_reg_field::type_id::create("cfg_txfifo_ae_thld");
         // configure
         cfg_txfifo_ae_thld.configure(
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
         cfg_txfifo_f_thld = uvm_reg_field::type_id::create("cfg_txfifo_f_thld");
         // configure
         cfg_txfifo_f_thld.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_txfifo_af_thld = uvm_reg_field::type_id::create("cfg_txfifo_af_thld");
         // configure
         cfg_txfifo_af_thld.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_txfifo_ph_comp = uvm_reg_field::type_id::create("cfg_txfifo_ph_comp");
         // configure
         cfg_txfifo_ph_comp.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_txfifo_wr_full = uvm_reg_field::type_id::create("cfg_txfifo_wr_full");
         // configure
         cfg_txfifo_wr_full.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_txfifo_rd_empty = uvm_reg_field::type_id::create("cfg_txfifo_rd_empty");
         // configure
         cfg_txfifo_rd_empty.configure(
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
      
endclass : xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm  )

      rand uvm_reg_field cfg_tx_reset_val_31_0;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_tx_reset_val_31_0_value : coverpoint cfg_tx_reset_val_31_0.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_tx_reset_val_31_0 = uvm_reg_field::type_id::create("cfg_tx_reset_val_31_0");
         // configure
         cfg_tx_reset_val_31_0.configure(
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
      
endclass : xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm  )

      rand uvm_reg_field cfg_tx_reset_val_63_32;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_tx_reset_val_63_32_value : coverpoint cfg_tx_reset_val_63_32.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_tx_reset_val_63_32 = uvm_reg_field::type_id::create("cfg_tx_reset_val_63_32");
         // configure
         cfg_tx_reset_val_63_32.configure(
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
      
endclass : xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm  )

      rand uvm_reg_field cfg_tx_reset_val_66_64;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_tx_reset_val_66_64_value : coverpoint cfg_tx_reset_val_66_64.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_tx_reset_val_66_64 = uvm_reg_field::type_id::create("cfg_tx_reset_val_66_64");
         // configure
         cfg_tx_reset_val_66_64.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_rxbit_stat_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_rxbit_stat_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_rxbit_stat_urm  )

      rand uvm_reg_field cfg_rx_bit_position;
      rand uvm_reg_field cfg_rx_latency_bit_for_async;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rx_bit_position_value : coverpoint cfg_rx_bit_position.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
          cfg_rx_latency_bit_for_async_value : coverpoint cfg_rx_latency_bit_for_async.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_rxbit_stat_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rx_bit_position = uvm_reg_field::type_id::create("cfg_rx_bit_position");
         // configure
         cfg_rx_bit_position.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (7'b0000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_latency_bit_for_async = uvm_reg_field::type_id::create("cfg_rx_latency_bit_for_async");
         // configure
         cfg_rx_latency_bit_for_async.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (7'b0000000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_rxbit_stat_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm  )

      rand uvm_reg_field status_tx_gbx;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          status_tx_gbx_value : coverpoint status_tx_gbx.value {
             bins all[8] = {[21'h0:21'h1fffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         status_tx_gbx = uvm_reg_field::type_id::create("status_tx_gbx");
         // configure
         status_tx_gbx.configure(
         .parent                 ( this ),
         .size                   (21),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (21'b000000000000000000000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm  )

      rand uvm_reg_field status_rx_gbx;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          status_rx_gbx_value : coverpoint status_rx_gbx.value {
             bins all[8] = {[14'h0:14'h3fff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         status_rx_gbx = uvm_reg_field::type_id::create("status_rx_gbx");
         // configure
         status_rx_gbx.configure(
         .parent                 ( this ),
         .size                   (14),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (14'b00000000000000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm  )

      rand uvm_reg_field cfg_sel_bit_counter_adder;
      rand uvm_reg_field cfg_rx_bit_counter_rollover;
      rand uvm_reg_field cfg_reset_rx_bit_counter;
      rand uvm_reg_field cfg_clk_en_div66_tx;
      rand uvm_reg_field cfg_clk_en_sclk_tx;
      rand uvm_reg_field cfg_tx_fifo_lat_en;
      rand uvm_reg_field cfg_clk_en_sclk_rx;
      rand uvm_reg_field cfg_rx_fifo_lat_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_sel_bit_counter_adder_value : coverpoint cfg_sel_bit_counter_adder.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_rx_bit_counter_rollover_value : coverpoint cfg_rx_bit_counter_rollover.value {
             bins all[8] = {[13'h0:13'h1fff]};
             illegal_bins bad = default;
          }
          cfg_reset_rx_bit_counter_value : coverpoint cfg_reset_rx_bit_counter.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_div66_tx_value : coverpoint cfg_clk_en_div66_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_clk_en_sclk_tx_value : coverpoint cfg_clk_en_sclk_tx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_fifo_lat_en_value : coverpoint cfg_tx_fifo_lat_en.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_clk_en_sclk_rx_value : coverpoint cfg_clk_en_sclk_rx.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_fifo_lat_en_value : coverpoint cfg_rx_fifo_lat_en.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_sel_bit_counter_adder = uvm_reg_field::type_id::create("cfg_sel_bit_counter_adder");
         // configure
         cfg_sel_bit_counter_adder.configure(
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
         cfg_rx_bit_counter_rollover = uvm_reg_field::type_id::create("cfg_rx_bit_counter_rollover");
         // configure
         cfg_rx_bit_counter_rollover.configure(
         .parent                 ( this ),
         .size                   (13),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (13'b0000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_reset_rx_bit_counter = uvm_reg_field::type_id::create("cfg_reset_rx_bit_counter");
         // configure
         cfg_reset_rx_bit_counter.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_div66_tx = uvm_reg_field::type_id::create("cfg_clk_en_div66_tx");
         // configure
         cfg_clk_en_div66_tx.configure(
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
         cfg_clk_en_sclk_tx = uvm_reg_field::type_id::create("cfg_clk_en_sclk_tx");
         // configure
         cfg_clk_en_sclk_tx.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_tx_fifo_lat_en = uvm_reg_field::type_id::create("cfg_tx_fifo_lat_en");
         // configure
         cfg_tx_fifo_lat_en.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_clk_en_sclk_rx = uvm_reg_field::type_id::create("cfg_clk_en_sclk_rx");
         // configure
         cfg_clk_en_sclk_rx.configure(
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
         cfg_rx_fifo_lat_en = uvm_reg_field::type_id::create("cfg_rx_fifo_lat_en");
         // configure
         cfg_rx_fifo_lat_en.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
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
      
endclass : xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm  )

      rand uvm_reg_field cfg_rb_dcc_byp;
      rand uvm_reg_field cfg_rb_dcc_en;
      rand uvm_reg_field cfg_rb_cont_cal;
      rand uvm_reg_field cfg_rb_dcc_manual_up;
      rand uvm_reg_field cfg_rb_dcc_manual_dn;
      rand uvm_reg_field cfg_rb_clkdiv;
      rand uvm_reg_field cfg_rb_selflock;
      rand uvm_reg_field cfg_rb_half_code;
      rand uvm_reg_field cfg_rb_nfrzdrv;
      rand uvm_reg_field cfg_rb_dcc_req;
      rand uvm_reg_field cfg_rb_dcc_req_ovr;
      rand uvm_reg_field cfg_rb_dcc_dft;
      rand uvm_reg_field cfg_rb_dcc_dft_sel;
      rand uvm_reg_field cfg_idll_entest;
      rand uvm_reg_field cfg_test_clk_pll_en_n;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_rb_dcc_byp_value : coverpoint cfg_rb_dcc_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_en_value : coverpoint cfg_rb_dcc_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_cont_cal_value : coverpoint cfg_rb_cont_cal.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_manual_up_value : coverpoint cfg_rb_dcc_manual_up.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_manual_dn_value : coverpoint cfg_rb_dcc_manual_dn.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          cfg_rb_clkdiv_value : coverpoint cfg_rb_clkdiv.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          cfg_rb_selflock_value : coverpoint cfg_rb_selflock.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_half_code_value : coverpoint cfg_rb_half_code.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_nfrzdrv_value : coverpoint cfg_rb_nfrzdrv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_req_value : coverpoint cfg_rb_dcc_req.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_req_ovr_value : coverpoint cfg_rb_dcc_req_ovr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_dft_value : coverpoint cfg_rb_dcc_dft.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rb_dcc_dft_sel_value : coverpoint cfg_rb_dcc_dft_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_idll_entest_value : coverpoint cfg_idll_entest.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_test_clk_pll_en_n_value : coverpoint cfg_test_clk_pll_en_n.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_rb_dcc_byp = uvm_reg_field::type_id::create("cfg_rb_dcc_byp");
         // configure
         cfg_rb_dcc_byp.configure(
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
         cfg_rb_dcc_en = uvm_reg_field::type_id::create("cfg_rb_dcc_en");
         // configure
         cfg_rb_dcc_en.configure(
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
         cfg_rb_cont_cal = uvm_reg_field::type_id::create("cfg_rb_cont_cal");
         // configure
         cfg_rb_cont_cal.configure(
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
         cfg_rb_dcc_manual_up = uvm_reg_field::type_id::create("cfg_rb_dcc_manual_up");
         // configure
         cfg_rb_dcc_manual_up.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rb_dcc_manual_dn = uvm_reg_field::type_id::create("cfg_rb_dcc_manual_dn");
         // configure
         cfg_rb_dcc_manual_dn.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rb_clkdiv = uvm_reg_field::type_id::create("cfg_rb_clkdiv");
         // configure
         cfg_rb_clkdiv.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b001),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rb_selflock = uvm_reg_field::type_id::create("cfg_rb_selflock");
         // configure
         cfg_rb_selflock.configure(
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
         cfg_rb_half_code = uvm_reg_field::type_id::create("cfg_rb_half_code");
         // configure
         cfg_rb_half_code.configure(
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
         cfg_rb_nfrzdrv = uvm_reg_field::type_id::create("cfg_rb_nfrzdrv");
         // configure
         cfg_rb_nfrzdrv.configure(
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
         cfg_rb_dcc_req = uvm_reg_field::type_id::create("cfg_rb_dcc_req");
         // configure
         cfg_rb_dcc_req.configure(
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
         cfg_rb_dcc_req_ovr = uvm_reg_field::type_id::create("cfg_rb_dcc_req_ovr");
         // configure
         cfg_rb_dcc_req_ovr.configure(
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
         cfg_rb_dcc_dft = uvm_reg_field::type_id::create("cfg_rb_dcc_dft");
         // configure
         cfg_rb_dcc_dft.configure(
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
         cfg_rb_dcc_dft_sel = uvm_reg_field::type_id::create("cfg_rb_dcc_dft_sel");
         // configure
         cfg_rb_dcc_dft_sel.configure(
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
         cfg_idll_entest = uvm_reg_field::type_id::create("cfg_idll_entest");
         // configure
         cfg_idll_entest.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_test_clk_pll_en_n = uvm_reg_field::type_id::create("cfg_test_clk_pll_en_n");
         // configure
         cfg_test_clk_pll_en_n.configure(
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
      
endclass : xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm  )

      rand uvm_reg_field cfg_dcc_csr_core_rst_en;
      rand uvm_reg_field cfg_dcc_csr_en_fsm;
      rand uvm_reg_field cfg_dcc_csr_rst_invert;
      rand uvm_reg_field cfg_dcc_csr_up_invert;
      rand uvm_reg_field cfg_dcc_csr_dn_invert;
      rand uvm_reg_field cfg_dcc_csr_updn_en;
      rand uvm_reg_field cfg_dcc_csr_mux_sel;
      rand uvm_reg_field cfg_dcc_csr_resv;
      rand uvm_reg_field cfg_dcc_csr_dll_sel;
      rand uvm_reg_field cfg_dcc_csr_dly_ovr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_dcc_csr_core_rst_en_value : coverpoint cfg_dcc_csr_core_rst_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_en_fsm_value : coverpoint cfg_dcc_csr_en_fsm.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_rst_invert_value : coverpoint cfg_dcc_csr_rst_invert.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_up_invert_value : coverpoint cfg_dcc_csr_up_invert.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_dn_invert_value : coverpoint cfg_dcc_csr_dn_invert.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_updn_en_value : coverpoint cfg_dcc_csr_updn_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_mux_sel_value : coverpoint cfg_dcc_csr_mux_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_resv_value : coverpoint cfg_dcc_csr_resv.value {
             bins all[8] = {[10'h0:10'h3ff]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_dll_sel_value : coverpoint cfg_dcc_csr_dll_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_dly_ovr_value : coverpoint cfg_dcc_csr_dly_ovr.value {
             bins all[8] = {[10'h0:10'h3ff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_dcc_csr_core_rst_en = uvm_reg_field::type_id::create("cfg_dcc_csr_core_rst_en");
         // configure
         cfg_dcc_csr_core_rst_en.configure(
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
         cfg_dcc_csr_en_fsm = uvm_reg_field::type_id::create("cfg_dcc_csr_en_fsm");
         // configure
         cfg_dcc_csr_en_fsm.configure(
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
         cfg_dcc_csr_rst_invert = uvm_reg_field::type_id::create("cfg_dcc_csr_rst_invert");
         // configure
         cfg_dcc_csr_rst_invert.configure(
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
         cfg_dcc_csr_up_invert = uvm_reg_field::type_id::create("cfg_dcc_csr_up_invert");
         // configure
         cfg_dcc_csr_up_invert.configure(
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
         cfg_dcc_csr_dn_invert = uvm_reg_field::type_id::create("cfg_dcc_csr_dn_invert");
         // configure
         cfg_dcc_csr_dn_invert.configure(
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
         cfg_dcc_csr_updn_en = uvm_reg_field::type_id::create("cfg_dcc_csr_updn_en");
         // configure
         cfg_dcc_csr_updn_en.configure(
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
         cfg_dcc_csr_mux_sel = uvm_reg_field::type_id::create("cfg_dcc_csr_mux_sel");
         // configure
         cfg_dcc_csr_mux_sel.configure(
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
         cfg_dcc_csr_resv = uvm_reg_field::type_id::create("cfg_dcc_csr_resv");
         // configure
         cfg_dcc_csr_resv.configure(
         .parent                 ( this ),
         .size                   (10),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (10'b0000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_dcc_csr_dll_sel = uvm_reg_field::type_id::create("cfg_dcc_csr_dll_sel");
         // configure
         cfg_dcc_csr_dll_sel.configure(
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
         cfg_dcc_csr_dly_ovr = uvm_reg_field::type_id::create("cfg_dcc_csr_dly_ovr");
         // configure
         cfg_dcc_csr_dly_ovr.configure(
         .parent                 ( this ),
         .size                   (10),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (10'b0000000000),
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
      
endclass : xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm  )

      rand uvm_reg_field cfg_dcc_csr_dft_msel;
      rand uvm_reg_field cfg_dcc_csr_dly_ovr_10;
      rand uvm_reg_field cfg_dcc_csr_resv_10;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_dcc_csr_dft_msel_value : coverpoint cfg_dcc_csr_dft_msel.value {
             bins all[8] = {[22'h0:22'h3fffff]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_dly_ovr_10_value : coverpoint cfg_dcc_csr_dly_ovr_10.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_dcc_csr_resv_10_value : coverpoint cfg_dcc_csr_resv_10.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_dcc_csr_dft_msel = uvm_reg_field::type_id::create("cfg_dcc_csr_dft_msel");
         // configure
         cfg_dcc_csr_dft_msel.configure(
         .parent                 ( this ),
         .size                   (22),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (22'b0000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_dcc_csr_dly_ovr_10 = uvm_reg_field::type_id::create("cfg_dcc_csr_dly_ovr_10");
         // configure
         cfg_dcc_csr_dly_ovr_10.configure(
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
         cfg_dcc_csr_resv_10 = uvm_reg_field::type_id::create("cfg_dcc_csr_resv_10");
         // configure
         cfg_dcc_csr_resv_10.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
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
      
endclass : xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm  )

      rand uvm_reg_field cfg_dcc_done;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_dcc_done_value : coverpoint cfg_dcc_done.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_dcc_done = uvm_reg_field::type_id::create("cfg_dcc_done");
         // configure
         cfg_dcc_done.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvrif_test_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvrif_test_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvrif_test_ctrl_urm  )

      rand uvm_reg_field cfg_tbus_sel;
      rand uvm_reg_field cfg_test_serd_en_wind_short_cnt_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_tbus_sel_value : coverpoint cfg_tbus_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_test_serd_en_wind_short_cnt_en_value : coverpoint cfg_test_serd_en_wind_short_cnt_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvrif_test_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_tbus_sel = uvm_reg_field::type_id::create("cfg_tbus_sel");
         // configure
         cfg_tbus_sel.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_test_serd_en_wind_short_cnt_en = uvm_reg_field::type_id::create("cfg_test_serd_en_wind_short_cnt_en");
         // configure
         cfg_test_serd_en_wind_short_cnt_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_reg_xcvrif_test_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_core_to_cntl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_core_to_cntl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_core_to_cntl_urm  )

      rand uvm_reg_field cfg_core_to_cntl;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_core_to_cntl_value : coverpoint cfg_core_to_cntl.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_core_to_cntl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_core_to_cntl = uvm_reg_field::type_id::create("cfg_core_to_cntl");
         // configure
         cfg_core_to_cntl.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b1010101010101010),
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
      
endclass : xcvr_reconfig_reg_interrupt_core_to_cntl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_if_reg_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_if_reg_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_if_reg_urm  )

      rand uvm_reg_field cfg_int_if_data;
      rand uvm_reg_field cfg_int_if_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_if_data_value : coverpoint cfg_int_if_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_if_code_value : coverpoint cfg_int_if_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_if_reg_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_if_data = uvm_reg_field::type_id::create("cfg_int_if_data");
         // configure
         cfg_int_if_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_if_code = uvm_reg_field::type_id::create("cfg_int_if_code");
         // configure
         cfg_int_if_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_if_reg_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_if_rcv_data_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_if_rcv_data_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_if_rcv_data_urm  )

      rand uvm_reg_field cfg_int_if_rcv_data;
      rand uvm_reg_field cfg_core_int_fw_crc_err;
      rand uvm_reg_field cfg_core_int_seq_to_err;
      rand uvm_reg_field cfg_ssr_alert_sbe;
      rand uvm_reg_field cfg_ssr_alert_dbe;
      rand uvm_reg_field cfg_core_int_req_stat;
      rand uvm_reg_field cfg_core_int_in_prog_assert;
      rand uvm_reg_field cfg_core_int_in_progress;
      rand uvm_reg_field cfg_signal_ok;
      rand uvm_reg_field cfg_rx_rdy;
      rand uvm_reg_field cfg_tx_rdy;
      rand uvm_reg_field cfg_link_loopback_en;
      rand uvm_reg_field cfg_core_int_pwrseq_active;
      rand uvm_reg_field cfg_core_int_pwrseq_done;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_if_rcv_data_value : coverpoint cfg_int_if_rcv_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_core_int_fw_crc_err_value : coverpoint cfg_core_int_fw_crc_err.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_seq_to_err_value : coverpoint cfg_core_int_seq_to_err.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_ssr_alert_sbe_value : coverpoint cfg_ssr_alert_sbe.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_ssr_alert_dbe_value : coverpoint cfg_ssr_alert_dbe.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_req_stat_value : coverpoint cfg_core_int_req_stat.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_in_prog_assert_value : coverpoint cfg_core_int_in_prog_assert.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_in_progress_value : coverpoint cfg_core_int_in_progress.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_signal_ok_value : coverpoint cfg_signal_ok.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_rx_rdy_value : coverpoint cfg_rx_rdy.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_tx_rdy_value : coverpoint cfg_tx_rdy.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_link_loopback_en_value : coverpoint cfg_link_loopback_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_pwrseq_active_value : coverpoint cfg_core_int_pwrseq_active.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_pwrseq_done_value : coverpoint cfg_core_int_pwrseq_done.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_if_rcv_data_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_if_rcv_data = uvm_reg_field::type_id::create("cfg_int_if_rcv_data");
         // configure
         cfg_int_if_rcv_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_int_fw_crc_err = uvm_reg_field::type_id::create("cfg_core_int_fw_crc_err");
         // configure
         cfg_core_int_fw_crc_err.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_int_seq_to_err = uvm_reg_field::type_id::create("cfg_core_int_seq_to_err");
         // configure
         cfg_core_int_seq_to_err.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ssr_alert_sbe = uvm_reg_field::type_id::create("cfg_ssr_alert_sbe");
         // configure
         cfg_ssr_alert_sbe.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_ssr_alert_dbe = uvm_reg_field::type_id::create("cfg_ssr_alert_dbe");
         // configure
         cfg_ssr_alert_dbe.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_int_req_stat = uvm_reg_field::type_id::create("cfg_core_int_req_stat");
         // configure
         cfg_core_int_req_stat.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_int_in_prog_assert = uvm_reg_field::type_id::create("cfg_core_int_in_prog_assert");
         // configure
         cfg_core_int_in_prog_assert.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("W1C"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_core_int_in_progress = uvm_reg_field::type_id::create("cfg_core_int_in_progress");
         // configure
         cfg_core_int_in_progress.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_signal_ok = uvm_reg_field::type_id::create("cfg_signal_ok");
         // configure
         cfg_signal_ok.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_rx_rdy = uvm_reg_field::type_id::create("cfg_rx_rdy");
         // configure
         cfg_rx_rdy.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_tx_rdy = uvm_reg_field::type_id::create("cfg_tx_rdy");
         // configure
         cfg_tx_rdy.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_link_loopback_en = uvm_reg_field::type_id::create("cfg_link_loopback_en");
         // configure
         cfg_link_loopback_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_int_pwrseq_active = uvm_reg_field::type_id::create("cfg_core_int_pwrseq_active");
         // configure
         cfg_core_int_pwrseq_active.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_int_pwrseq_done = uvm_reg_field::type_id::create("cfg_core_int_pwrseq_done");
         // configure
         cfg_core_int_pwrseq_done.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_interrupt_if_rcv_data_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_core_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_core_status_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_core_status_urm  )

      rand uvm_reg_field cfg_core_status;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_core_status_value : coverpoint cfg_core_status.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_core_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_core_status = uvm_reg_field::type_id::create("cfg_core_status");
         // configure
         cfg_core_status.configure(
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
      
endclass : xcvr_reconfig_reg_interrupt_core_status_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_if_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_if_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_if_ctrl_urm  )

      rand uvm_reg_field cfg_core_int_request;
      rand uvm_reg_field cfg_restart_seq_sm;
      rand uvm_reg_field cfg_core_int_cntl_ovr_en;
      rand uvm_reg_field cfg_core_int_window_en;
      rand uvm_reg_field cfg_core_int_window_grpid;
      rand uvm_reg_field cfg_core_stat_sel_msw;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_core_int_request_value : coverpoint cfg_core_int_request.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_restart_seq_sm_value : coverpoint cfg_restart_seq_sm.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_cntl_ovr_en_value : coverpoint cfg_core_int_cntl_ovr_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_window_en_value : coverpoint cfg_core_int_window_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_core_int_window_grpid_value : coverpoint cfg_core_int_window_grpid.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          cfg_core_stat_sel_msw_value : coverpoint cfg_core_stat_sel_msw.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_if_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_core_int_request = uvm_reg_field::type_id::create("cfg_core_int_request");
         // configure
         cfg_core_int_request.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_restart_seq_sm = uvm_reg_field::type_id::create("cfg_restart_seq_sm");
         // configure
         cfg_restart_seq_sm.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_core_int_cntl_ovr_en = uvm_reg_field::type_id::create("cfg_core_int_cntl_ovr_en");
         // configure
         cfg_core_int_cntl_ovr_en.configure(
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
         cfg_core_int_window_en = uvm_reg_field::type_id::create("cfg_core_int_window_en");
         // configure
         cfg_core_int_window_en.configure(
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
         cfg_core_int_window_grpid = uvm_reg_field::type_id::create("cfg_core_int_window_grpid");
         // configure
         cfg_core_int_window_grpid.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_core_stat_sel_msw = uvm_reg_field::type_id::create("cfg_core_stat_sel_msw");
         // configure
         cfg_core_stat_sel_msw.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_reg_interrupt_if_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_enable_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_enable_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_enable_urm  )

      rand uvm_reg_field cfg_en_seq0;
      rand uvm_reg_field cfg_en_seq1;
      rand uvm_reg_field cfg_en_seq2;
      rand uvm_reg_field cfg_en_seq3;
      rand uvm_reg_field cfg_en_seq4;
      rand uvm_reg_field cfg_en_seq5;
      rand uvm_reg_field cfg_en_seq6;
      rand uvm_reg_field cfg_en_seq7;
      rand uvm_reg_field cfg_en_seq8;
      rand uvm_reg_field cfg_en_seq9;
      rand uvm_reg_field cfg_en_seq10;
      rand uvm_reg_field cfg_en_seq11;
      rand uvm_reg_field cfg_en_seq12;
      rand uvm_reg_field cfg_en_seq13;
      rand uvm_reg_field cfg_en_seq14;
      rand uvm_reg_field cfg_en_seq15;
      rand uvm_reg_field cfg_en_seq16;
      rand uvm_reg_field cfg_en_seq17;
      rand uvm_reg_field cfg_en_seq18;
      rand uvm_reg_field cfg_en_seq19;
      rand uvm_reg_field cfg_serdes_en_seq;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_en_seq0_value : coverpoint cfg_en_seq0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq1_value : coverpoint cfg_en_seq1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq2_value : coverpoint cfg_en_seq2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq3_value : coverpoint cfg_en_seq3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq4_value : coverpoint cfg_en_seq4.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq5_value : coverpoint cfg_en_seq5.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq6_value : coverpoint cfg_en_seq6.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq7_value : coverpoint cfg_en_seq7.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq8_value : coverpoint cfg_en_seq8.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq9_value : coverpoint cfg_en_seq9.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq10_value : coverpoint cfg_en_seq10.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq11_value : coverpoint cfg_en_seq11.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq12_value : coverpoint cfg_en_seq12.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq13_value : coverpoint cfg_en_seq13.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq14_value : coverpoint cfg_en_seq14.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq15_value : coverpoint cfg_en_seq15.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq16_value : coverpoint cfg_en_seq16.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq17_value : coverpoint cfg_en_seq17.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq18_value : coverpoint cfg_en_seq18.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_en_seq19_value : coverpoint cfg_en_seq19.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          cfg_serdes_en_seq_value : coverpoint cfg_serdes_en_seq.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_enable_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_en_seq0 = uvm_reg_field::type_id::create("cfg_en_seq0");
         // configure
         cfg_en_seq0.configure(
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
         cfg_en_seq1 = uvm_reg_field::type_id::create("cfg_en_seq1");
         // configure
         cfg_en_seq1.configure(
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
         cfg_en_seq2 = uvm_reg_field::type_id::create("cfg_en_seq2");
         // configure
         cfg_en_seq2.configure(
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
         cfg_en_seq3 = uvm_reg_field::type_id::create("cfg_en_seq3");
         // configure
         cfg_en_seq3.configure(
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
         cfg_en_seq4 = uvm_reg_field::type_id::create("cfg_en_seq4");
         // configure
         cfg_en_seq4.configure(
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
         cfg_en_seq5 = uvm_reg_field::type_id::create("cfg_en_seq5");
         // configure
         cfg_en_seq5.configure(
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
         cfg_en_seq6 = uvm_reg_field::type_id::create("cfg_en_seq6");
         // configure
         cfg_en_seq6.configure(
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
         cfg_en_seq7 = uvm_reg_field::type_id::create("cfg_en_seq7");
         // configure
         cfg_en_seq7.configure(
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
         cfg_en_seq8 = uvm_reg_field::type_id::create("cfg_en_seq8");
         // configure
         cfg_en_seq8.configure(
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
         cfg_en_seq9 = uvm_reg_field::type_id::create("cfg_en_seq9");
         // configure
         cfg_en_seq9.configure(
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
         cfg_en_seq10 = uvm_reg_field::type_id::create("cfg_en_seq10");
         // configure
         cfg_en_seq10.configure(
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
         cfg_en_seq11 = uvm_reg_field::type_id::create("cfg_en_seq11");
         // configure
         cfg_en_seq11.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_en_seq12 = uvm_reg_field::type_id::create("cfg_en_seq12");
         // configure
         cfg_en_seq12.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_en_seq13 = uvm_reg_field::type_id::create("cfg_en_seq13");
         // configure
         cfg_en_seq13.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_en_seq14 = uvm_reg_field::type_id::create("cfg_en_seq14");
         // configure
         cfg_en_seq14.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_en_seq15 = uvm_reg_field::type_id::create("cfg_en_seq15");
         // configure
         cfg_en_seq15.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         cfg_en_seq16 = uvm_reg_field::type_id::create("cfg_en_seq16");
         // configure
         cfg_en_seq16.configure(
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
         cfg_en_seq17 = uvm_reg_field::type_id::create("cfg_en_seq17");
         // configure
         cfg_en_seq17.configure(
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
         cfg_en_seq18 = uvm_reg_field::type_id::create("cfg_en_seq18");
         // configure
         cfg_en_seq18.configure(
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
         cfg_en_seq19 = uvm_reg_field::type_id::create("cfg_en_seq19");
         // configure
         cfg_en_seq19.configure(
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
         cfg_serdes_en_seq = uvm_reg_field::type_id::create("cfg_serdes_en_seq");
         // configure
         cfg_serdes_en_seq.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_enable_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_0_urm  )

      rand uvm_reg_field cfg_int_seq0_data;
      rand uvm_reg_field cfg_int_seq0_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq0_data_value : coverpoint cfg_int_seq0_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq0_code_value : coverpoint cfg_int_seq0_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq0_data = uvm_reg_field::type_id::create("cfg_int_seq0_data");
         // configure
         cfg_int_seq0_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq0_code = uvm_reg_field::type_id::create("cfg_int_seq0_code");
         // configure
         cfg_int_seq0_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_1_urm  )

      rand uvm_reg_field cfg_int_seq1_data;
      rand uvm_reg_field cfg_int_seq1_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq1_data_value : coverpoint cfg_int_seq1_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq1_code_value : coverpoint cfg_int_seq1_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq1_data = uvm_reg_field::type_id::create("cfg_int_seq1_data");
         // configure
         cfg_int_seq1_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq1_code = uvm_reg_field::type_id::create("cfg_int_seq1_code");
         // configure
         cfg_int_seq1_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_2_urm  )

      rand uvm_reg_field cfg_int_seq2_data;
      rand uvm_reg_field cfg_int_seq2_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq2_data_value : coverpoint cfg_int_seq2_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq2_code_value : coverpoint cfg_int_seq2_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq2_data = uvm_reg_field::type_id::create("cfg_int_seq2_data");
         // configure
         cfg_int_seq2_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq2_code = uvm_reg_field::type_id::create("cfg_int_seq2_code");
         // configure
         cfg_int_seq2_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_3_urm  )

      rand uvm_reg_field cfg_int_seq3_data;
      rand uvm_reg_field cfg_int_seq3_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq3_data_value : coverpoint cfg_int_seq3_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq3_code_value : coverpoint cfg_int_seq3_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq3_data = uvm_reg_field::type_id::create("cfg_int_seq3_data");
         // configure
         cfg_int_seq3_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq3_code = uvm_reg_field::type_id::create("cfg_int_seq3_code");
         // configure
         cfg_int_seq3_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_4_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_4_urm  )

      rand uvm_reg_field cfg_int_seq4_data;
      rand uvm_reg_field cfg_int_seq4_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq4_data_value : coverpoint cfg_int_seq4_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq4_code_value : coverpoint cfg_int_seq4_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq4_data = uvm_reg_field::type_id::create("cfg_int_seq4_data");
         // configure
         cfg_int_seq4_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq4_code = uvm_reg_field::type_id::create("cfg_int_seq4_code");
         // configure
         cfg_int_seq4_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_4_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_5_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_5_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_5_urm  )

      rand uvm_reg_field cfg_int_seq5_data;
      rand uvm_reg_field cfg_int_seq5_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq5_data_value : coverpoint cfg_int_seq5_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq5_code_value : coverpoint cfg_int_seq5_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_5_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq5_data = uvm_reg_field::type_id::create("cfg_int_seq5_data");
         // configure
         cfg_int_seq5_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq5_code = uvm_reg_field::type_id::create("cfg_int_seq5_code");
         // configure
         cfg_int_seq5_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_5_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_6_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_6_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_6_urm  )

      rand uvm_reg_field cfg_int_seq6_data;
      rand uvm_reg_field cfg_int_seq6_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq6_data_value : coverpoint cfg_int_seq6_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq6_code_value : coverpoint cfg_int_seq6_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_6_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq6_data = uvm_reg_field::type_id::create("cfg_int_seq6_data");
         // configure
         cfg_int_seq6_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq6_code = uvm_reg_field::type_id::create("cfg_int_seq6_code");
         // configure
         cfg_int_seq6_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_6_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_7_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_7_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_7_urm  )

      rand uvm_reg_field cfg_int_seq7_data;
      rand uvm_reg_field cfg_int_seq7_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq7_data_value : coverpoint cfg_int_seq7_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq7_code_value : coverpoint cfg_int_seq7_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_7_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq7_data = uvm_reg_field::type_id::create("cfg_int_seq7_data");
         // configure
         cfg_int_seq7_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq7_code = uvm_reg_field::type_id::create("cfg_int_seq7_code");
         // configure
         cfg_int_seq7_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_7_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_8_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_8_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_8_urm  )

      rand uvm_reg_field cfg_int_seq8_data;
      rand uvm_reg_field cfg_int_seq8_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq8_data_value : coverpoint cfg_int_seq8_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq8_code_value : coverpoint cfg_int_seq8_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_8_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq8_data = uvm_reg_field::type_id::create("cfg_int_seq8_data");
         // configure
         cfg_int_seq8_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq8_code = uvm_reg_field::type_id::create("cfg_int_seq8_code");
         // configure
         cfg_int_seq8_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_8_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_9_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_9_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_9_urm  )

      rand uvm_reg_field cfg_int_seq9_data;
      rand uvm_reg_field cfg_int_seq9_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq9_data_value : coverpoint cfg_int_seq9_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq9_code_value : coverpoint cfg_int_seq9_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_9_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq9_data = uvm_reg_field::type_id::create("cfg_int_seq9_data");
         // configure
         cfg_int_seq9_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq9_code = uvm_reg_field::type_id::create("cfg_int_seq9_code");
         // configure
         cfg_int_seq9_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_9_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_10_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_10_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_10_urm  )

      rand uvm_reg_field cfg_int_seq10_data;
      rand uvm_reg_field cfg_int_seq10_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq10_data_value : coverpoint cfg_int_seq10_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq10_code_value : coverpoint cfg_int_seq10_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_10_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq10_data = uvm_reg_field::type_id::create("cfg_int_seq10_data");
         // configure
         cfg_int_seq10_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq10_code = uvm_reg_field::type_id::create("cfg_int_seq10_code");
         // configure
         cfg_int_seq10_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_10_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_11_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_11_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_11_urm  )

      rand uvm_reg_field cfg_int_seq11_data;
      rand uvm_reg_field cfg_int_seq11_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq11_data_value : coverpoint cfg_int_seq11_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq11_code_value : coverpoint cfg_int_seq11_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_11_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq11_data = uvm_reg_field::type_id::create("cfg_int_seq11_data");
         // configure
         cfg_int_seq11_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq11_code = uvm_reg_field::type_id::create("cfg_int_seq11_code");
         // configure
         cfg_int_seq11_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_11_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_12_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_12_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_12_urm  )

      rand uvm_reg_field cfg_int_seq12_data;
      rand uvm_reg_field cfg_int_seq12_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq12_data_value : coverpoint cfg_int_seq12_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq12_code_value : coverpoint cfg_int_seq12_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_12_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq12_data = uvm_reg_field::type_id::create("cfg_int_seq12_data");
         // configure
         cfg_int_seq12_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq12_code = uvm_reg_field::type_id::create("cfg_int_seq12_code");
         // configure
         cfg_int_seq12_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_12_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_13_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_13_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_13_urm  )

      rand uvm_reg_field cfg_int_seq13_data;
      rand uvm_reg_field cfg_int_seq13_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq13_data_value : coverpoint cfg_int_seq13_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq13_code_value : coverpoint cfg_int_seq13_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_13_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq13_data = uvm_reg_field::type_id::create("cfg_int_seq13_data");
         // configure
         cfg_int_seq13_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq13_code = uvm_reg_field::type_id::create("cfg_int_seq13_code");
         // configure
         cfg_int_seq13_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_13_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_14_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_14_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_14_urm  )

      rand uvm_reg_field cfg_int_seq14_data;
      rand uvm_reg_field cfg_int_seq14_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq14_data_value : coverpoint cfg_int_seq14_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq14_code_value : coverpoint cfg_int_seq14_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_14_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq14_data = uvm_reg_field::type_id::create("cfg_int_seq14_data");
         // configure
         cfg_int_seq14_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq14_code = uvm_reg_field::type_id::create("cfg_int_seq14_code");
         // configure
         cfg_int_seq14_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_14_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_15_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_15_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_15_urm  )

      rand uvm_reg_field cfg_int_seq15_data;
      rand uvm_reg_field cfg_int_seq15_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq15_data_value : coverpoint cfg_int_seq15_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq15_code_value : coverpoint cfg_int_seq15_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_15_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq15_data = uvm_reg_field::type_id::create("cfg_int_seq15_data");
         // configure
         cfg_int_seq15_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq15_code = uvm_reg_field::type_id::create("cfg_int_seq15_code");
         // configure
         cfg_int_seq15_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_15_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_16_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_16_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_16_urm  )

      rand uvm_reg_field cfg_int_seq16_data;
      rand uvm_reg_field cfg_int_seq16_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq16_data_value : coverpoint cfg_int_seq16_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq16_code_value : coverpoint cfg_int_seq16_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_16_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq16_data = uvm_reg_field::type_id::create("cfg_int_seq16_data");
         // configure
         cfg_int_seq16_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq16_code = uvm_reg_field::type_id::create("cfg_int_seq16_code");
         // configure
         cfg_int_seq16_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_16_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_17_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_17_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_17_urm  )

      rand uvm_reg_field cfg_int_seq17_data;
      rand uvm_reg_field cfg_int_seq17_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq17_data_value : coverpoint cfg_int_seq17_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq17_code_value : coverpoint cfg_int_seq17_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_17_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq17_data = uvm_reg_field::type_id::create("cfg_int_seq17_data");
         // configure
         cfg_int_seq17_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq17_code = uvm_reg_field::type_id::create("cfg_int_seq17_code");
         // configure
         cfg_int_seq17_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_17_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_18_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_18_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_18_urm  )

      rand uvm_reg_field cfg_int_seq18_data;
      rand uvm_reg_field cfg_int_seq18_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq18_data_value : coverpoint cfg_int_seq18_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq18_code_value : coverpoint cfg_int_seq18_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_18_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq18_data = uvm_reg_field::type_id::create("cfg_int_seq18_data");
         // configure
         cfg_int_seq18_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq18_code = uvm_reg_field::type_id::create("cfg_int_seq18_code");
         // configure
         cfg_int_seq18_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_18_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_19_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_19_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_19_urm  )

      rand uvm_reg_field cfg_int_seq19_data;
      rand uvm_reg_field cfg_int_seq19_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq19_data_value : coverpoint cfg_int_seq19_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq19_code_value : coverpoint cfg_int_seq19_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_19_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq19_data = uvm_reg_field::type_id::create("cfg_int_seq19_data");
         // configure
         cfg_int_seq19_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq19_code = uvm_reg_field::type_id::create("cfg_int_seq19_code");
         // configure
         cfg_int_seq19_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_19_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_interrupt_seq_serdes_en_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_interrupt_seq_serdes_en_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_interrupt_seq_serdes_en_urm  )

      rand uvm_reg_field cfg_int_seq_serdes_en_data;
      rand uvm_reg_field cfg_int_seq_serdes_en_code;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_int_seq_serdes_en_data_value : coverpoint cfg_int_seq_serdes_en_data.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
          cfg_int_seq_serdes_en_code_value : coverpoint cfg_int_seq_serdes_en_code.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_interrupt_seq_serdes_en_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_int_seq_serdes_en_data = uvm_reg_field::type_id::create("cfg_int_seq_serdes_en_data");
         // configure
         cfg_int_seq_serdes_en_data.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_int_seq_serdes_en_code = uvm_reg_field::type_id::create("cfg_int_seq_serdes_en_code");
         // configure
         cfg_int_seq_serdes_en_code.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_reg_interrupt_seq_serdes_en_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvr_refclk_sel_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvr_refclk_sel_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvr_refclk_sel_urm  )

      rand uvm_reg_field cfg_refclk_sel;
      rand uvm_reg_field cfg_refclk_scratch;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_refclk_sel_value : coverpoint cfg_refclk_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          cfg_refclk_scratch_value : coverpoint cfg_refclk_scratch.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvr_refclk_sel_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_refclk_sel = uvm_reg_field::type_id::create("cfg_refclk_sel");
         // configure
         cfg_refclk_sel.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_refclk_scratch = uvm_reg_field::type_id::create("cfg_refclk_scratch");
         // configure
         cfg_refclk_scratch.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
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
      
endclass : xcvr_reconfig_reg_xcvr_refclk_sel_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xcvr_hwdec_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xcvr_hwdec_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xcvr_hwdec_urm  )

      rand uvm_reg_field cfg_hw_mode_sel;
      rand uvm_reg_field cfg_sel_hw_decode_mode;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cfg_hw_mode_sel_value : coverpoint cfg_hw_mode_sel.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
          cfg_sel_hw_decode_mode_value : coverpoint cfg_sel_hw_decode_mode.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xcvr_hwdec_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cfg_hw_mode_sel = uvm_reg_field::type_id::create("cfg_hw_mode_sel");
         // configure
         cfg_hw_mode_sel.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (7'b0000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         cfg_sel_hw_decode_mode = uvm_reg_field::type_id::create("cfg_sel_hw_decode_mode");
         // configure
         cfg_sel_hw_decode_mode.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_reg_xcvr_hwdec_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_r_usr_outbox_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_r_usr_outbox_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_r_usr_outbox_urm  )

      rand uvm_reg_field usr_msg;
      rand uvm_reg_field send_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          usr_msg_value : coverpoint usr_msg.value {
             bins all[8] = {[30'h0:30'h3fffffff]};
             illegal_bins bad = default;
          }
          send_msg_value : coverpoint send_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_r_usr_outbox_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         usr_msg = uvm_reg_field::type_id::create("usr_msg");
         // configure
         usr_msg.configure(
         .parent                 ( this ),
         .size                   (30),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (30'b000000000000000000000000000000),
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
      
endclass : xcvr_reconfig_reg_r_usr_outbox_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_r_usr_inbox_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_r_usr_inbox_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_r_usr_inbox_urm  )

      rand uvm_reg_field usr_msg;
      rand uvm_reg_field autoclear_dis;
      rand uvm_reg_field new_msg;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          usr_msg_value : coverpoint usr_msg.value {
             bins all[8] = {[30'h0:30'h3fffffff]};
             illegal_bins bad = default;
          }
          autoclear_dis_value : coverpoint autoclear_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          new_msg_value : coverpoint new_msg.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_r_usr_inbox_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         usr_msg = uvm_reg_field::type_id::create("usr_msg");
         // configure
         usr_msg.configure(
         .parent                 ( this ),
         .size                   (30),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (30'b000000000000000000000000000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         autoclear_dis = uvm_reg_field::type_id::create("autoclear_dis");
         // configure
         autoclear_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         new_msg = uvm_reg_field::type_id::create("new_msg");
         // configure
         new_msg.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_r_usr_inbox_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_tx_chnl_dprio0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_tx_chnl_dprio0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_tx_chnl_dprio0_urm  )

      rand uvm_reg_field chnl_dp_map_mode;
      rand uvm_reg_field usertest_sel;
      rand uvm_reg_field fifo_empty;
      rand uvm_reg_field fifo_full;
      rand uvm_reg_field phcomp_rd_delay;
      rand uvm_reg_field double_read;
      rand uvm_reg_field stop_read;
      rand uvm_reg_field stop_write;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          chnl_dp_map_mode_value : coverpoint chnl_dp_map_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          usertest_sel_value : coverpoint usertest_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_empty_value : coverpoint fifo_empty.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          fifo_full_value : coverpoint fifo_full.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          phcomp_rd_delay_value : coverpoint phcomp_rd_delay.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          double_read_value : coverpoint double_read.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          stop_read_value : coverpoint stop_read.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          stop_write_value : coverpoint stop_write.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_tx_chnl_dprio0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         chnl_dp_map_mode = uvm_reg_field::type_id::create("chnl_dp_map_mode");
         // configure
         chnl_dp_map_mode.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         usertest_sel = uvm_reg_field::type_id::create("usertest_sel");
         // configure
         usertest_sel.configure(
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
         fifo_empty = uvm_reg_field::type_id::create("fifo_empty");
         // configure
         fifo_empty.configure(
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
         fifo_full = uvm_reg_field::type_id::create("fifo_full");
         // configure
         fifo_full.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         phcomp_rd_delay = uvm_reg_field::type_id::create("phcomp_rd_delay");
         // configure
         phcomp_rd_delay.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         double_read = uvm_reg_field::type_id::create("double_read");
         // configure
         double_read.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         stop_read = uvm_reg_field::type_id::create("stop_read");
         // configure
         stop_read.configure(
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
         stop_write = uvm_reg_field::type_id::create("stop_write");
         // configure
         stop_write.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
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
      
endclass : xcvr_reconfig_tx_chnl_dprio0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_tx_chnl_dprio1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_tx_chnl_dprio1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_tx_chnl_dprio1_urm  )

      rand uvm_reg_field fifo_pempty;
      rand uvm_reg_field dv_gating_en;
      rand uvm_reg_field rev_lpbk;
      rand uvm_reg_field fifo_pfull;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fifo_pempty_value : coverpoint fifo_pempty.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          dv_gating_en_value : coverpoint dv_gating_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rev_lpbk_value : coverpoint rev_lpbk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_pfull_value : coverpoint fifo_pfull.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_tx_chnl_dprio1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fifo_pempty = uvm_reg_field::type_id::create("fifo_pempty");
         // configure
         fifo_pempty.configure(
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
         dv_gating_en = uvm_reg_field::type_id::create("dv_gating_en");
         // configure
         dv_gating_en.configure(
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
         rev_lpbk = uvm_reg_field::type_id::create("rev_lpbk");
         // configure
         rev_lpbk.configure(
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
         fifo_pfull = uvm_reg_field::type_id::create("fifo_pfull");
         // configure
         fifo_pfull.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
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
      
endclass : xcvr_reconfig_tx_chnl_dprio1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_tx_chnl_dprio2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_tx_chnl_dprio2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_tx_chnl_dprio2_urm  )

      rand uvm_reg_field wa_en;
      rand uvm_reg_field fifo_power_mode;
      rand uvm_reg_field stretch_num_stages;
      rand uvm_reg_field datapath_tb_sel;
      rand uvm_reg_field wr_adj_en;
      rand uvm_reg_field rd_adj_en;
      rand uvm_reg_field async_txelecidle_rstval;
      rand uvm_reg_field async_hip_aib_fsr_in_bit0_rstval;
      rand uvm_reg_field async_hip_aib_fsr_in_bit1_rstval;
      rand uvm_reg_field async_hip_aib_fsr_in_bit2_rstval;
      rand uvm_reg_field async_hip_aib_fsr_in_bit3_rstval;
      rand uvm_reg_field async_pld_pmaif_mask_tx_pll_rstval;
      rand uvm_reg_field async_hip_aib_fsr_out_bit0_rstval;
      rand uvm_reg_field async_hip_aib_fsr_out_bit1_rstval;
      rand uvm_reg_field async_hip_aib_fsr_out_bit2_rstval;
      rand uvm_reg_field async_hip_aib_fsr_out_bit3_rstval;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          wa_en_value : coverpoint wa_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_power_mode_value : coverpoint fifo_power_mode.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          stretch_num_stages_value : coverpoint stretch_num_stages.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          datapath_tb_sel_value : coverpoint datapath_tb_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          wr_adj_en_value : coverpoint wr_adj_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rd_adj_en_value : coverpoint rd_adj_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_txelecidle_rstval_value : coverpoint async_txelecidle_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_in_bit0_rstval_value : coverpoint async_hip_aib_fsr_in_bit0_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_in_bit1_rstval_value : coverpoint async_hip_aib_fsr_in_bit1_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_in_bit2_rstval_value : coverpoint async_hip_aib_fsr_in_bit2_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_in_bit3_rstval_value : coverpoint async_hip_aib_fsr_in_bit3_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_pld_pmaif_mask_tx_pll_rstval_value : coverpoint async_pld_pmaif_mask_tx_pll_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_out_bit0_rstval_value : coverpoint async_hip_aib_fsr_out_bit0_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_out_bit1_rstval_value : coverpoint async_hip_aib_fsr_out_bit1_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_out_bit2_rstval_value : coverpoint async_hip_aib_fsr_out_bit2_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_aib_fsr_out_bit3_rstval_value : coverpoint async_hip_aib_fsr_out_bit3_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_tx_chnl_dprio2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         wa_en = uvm_reg_field::type_id::create("wa_en");
         // configure
         wa_en.configure(
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
         fifo_power_mode = uvm_reg_field::type_id::create("fifo_power_mode");
         // configure
         fifo_power_mode.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         stretch_num_stages = uvm_reg_field::type_id::create("stretch_num_stages");
         // configure
         stretch_num_stages.configure(
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
         datapath_tb_sel = uvm_reg_field::type_id::create("datapath_tb_sel");
         // configure
         datapath_tb_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         wr_adj_en = uvm_reg_field::type_id::create("wr_adj_en");
         // configure
         wr_adj_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rd_adj_en = uvm_reg_field::type_id::create("rd_adj_en");
         // configure
         rd_adj_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         async_txelecidle_rstval = uvm_reg_field::type_id::create("async_txelecidle_rstval");
         // configure
         async_txelecidle_rstval.configure(
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
         async_hip_aib_fsr_in_bit0_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_in_bit0_rstval");
         // configure
         async_hip_aib_fsr_in_bit0_rstval.configure(
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
         async_hip_aib_fsr_in_bit1_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_in_bit1_rstval");
         // configure
         async_hip_aib_fsr_in_bit1_rstval.configure(
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
         async_hip_aib_fsr_in_bit2_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_in_bit2_rstval");
         // configure
         async_hip_aib_fsr_in_bit2_rstval.configure(
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
         async_hip_aib_fsr_in_bit3_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_in_bit3_rstval");
         // configure
         async_hip_aib_fsr_in_bit3_rstval.configure(
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
         async_pld_pmaif_mask_tx_pll_rstval = uvm_reg_field::type_id::create("async_pld_pmaif_mask_tx_pll_rstval");
         // configure
         async_pld_pmaif_mask_tx_pll_rstval.configure(
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
         async_hip_aib_fsr_out_bit0_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_out_bit0_rstval");
         // configure
         async_hip_aib_fsr_out_bit0_rstval.configure(
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
         async_hip_aib_fsr_out_bit1_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_out_bit1_rstval");
         // configure
         async_hip_aib_fsr_out_bit1_rstval.configure(
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
         async_hip_aib_fsr_out_bit2_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_out_bit2_rstval");
         // configure
         async_hip_aib_fsr_out_bit2_rstval.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         async_hip_aib_fsr_out_bit3_rstval = uvm_reg_field::type_id::create("async_hip_aib_fsr_out_bit3_rstval");
         // configure
         async_hip_aib_fsr_out_bit3_rstval.configure(
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
      
endclass : xcvr_reconfig_tx_chnl_dprio2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_tx_chnl_dprio3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_tx_chnl_dprio3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_tx_chnl_dprio3_urm  )

      rand uvm_reg_field fifo_rd_clk_sel;
      rand uvm_reg_field fifo_wr_clk_scg_en;
      rand uvm_reg_field fifo_rd_clk_scg_en;
      rand uvm_reg_field osc_clk_scg_en;
      rand uvm_reg_field hrdrst_rx_osc_clk_scg_en;
      rand uvm_reg_field hip_osc_clk_scg_en;
      rand uvm_reg_field free_run_div_clk;
      rand uvm_reg_field hrdrst_rst_sm_dis;
      rand uvm_reg_field hrdrst_dcd_caldone_byp;
      rand uvm_reg_field hrdrst_dll_lock_byp;
      rand uvm_reg_field hrdrst_align_byp;
      rand uvm_reg_field hrdrst_user_ctl_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fifo_rd_clk_sel_value : coverpoint fifo_rd_clk_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_scg_en_value : coverpoint fifo_wr_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_scg_en_value : coverpoint fifo_rd_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          osc_clk_scg_en_value : coverpoint osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rx_osc_clk_scg_en_value : coverpoint hrdrst_rx_osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hip_osc_clk_scg_en_value : coverpoint hip_osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          free_run_div_clk_value : coverpoint free_run_div_clk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rst_sm_dis_value : coverpoint hrdrst_rst_sm_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_dcd_caldone_byp_value : coverpoint hrdrst_dcd_caldone_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_dll_lock_byp_value : coverpoint hrdrst_dll_lock_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_align_byp_value : coverpoint hrdrst_align_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_user_ctl_en_value : coverpoint hrdrst_user_ctl_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_tx_chnl_dprio3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fifo_rd_clk_sel = uvm_reg_field::type_id::create("fifo_rd_clk_sel");
         // configure
         fifo_rd_clk_sel.configure(
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
         fifo_wr_clk_scg_en = uvm_reg_field::type_id::create("fifo_wr_clk_scg_en");
         // configure
         fifo_wr_clk_scg_en.configure(
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
         fifo_rd_clk_scg_en = uvm_reg_field::type_id::create("fifo_rd_clk_scg_en");
         // configure
         fifo_rd_clk_scg_en.configure(
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
         osc_clk_scg_en = uvm_reg_field::type_id::create("osc_clk_scg_en");
         // configure
         osc_clk_scg_en.configure(
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
         hrdrst_rx_osc_clk_scg_en = uvm_reg_field::type_id::create("hrdrst_rx_osc_clk_scg_en");
         // configure
         hrdrst_rx_osc_clk_scg_en.configure(
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
         hip_osc_clk_scg_en = uvm_reg_field::type_id::create("hip_osc_clk_scg_en");
         // configure
         hip_osc_clk_scg_en.configure(
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
         free_run_div_clk = uvm_reg_field::type_id::create("free_run_div_clk");
         // configure
         free_run_div_clk.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_rst_sm_dis = uvm_reg_field::type_id::create("hrdrst_rst_sm_dis");
         // configure
         hrdrst_rst_sm_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_dcd_caldone_byp = uvm_reg_field::type_id::create("hrdrst_dcd_caldone_byp");
         // configure
         hrdrst_dcd_caldone_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_dll_lock_byp = uvm_reg_field::type_id::create("hrdrst_dll_lock_byp");
         // configure
         hrdrst_dll_lock_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_align_byp = uvm_reg_field::type_id::create("hrdrst_align_byp");
         // configure
         hrdrst_align_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_user_ctl_en = uvm_reg_field::type_id::create("hrdrst_user_ctl_en");
         // configure
         hrdrst_user_ctl_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_tx_chnl_dprio3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_rx_chnl_dprio0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_rx_chnl_dprio0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_rx_chnl_dprio0_urm  )

      rand uvm_reg_field chnl_dp_map_mode;
      rand uvm_reg_field pcs_testbus_sel;
      rand uvm_reg_field pld_8g_a1a2_k1k2_flag_poll_byp;
      rand uvm_reg_field pld_10g_krfec_rx_diag_data_stat_poll_byp;
      rand uvm_reg_field pld_pma_pcie_sw_done_poll_byp;
      rand uvm_reg_field pld_pma_reser_in_poll_byp;
      rand uvm_reg_field pld_pma_testbus_poll_byp;
      rand uvm_reg_field pld_test_data_poll_byp;
      rand uvm_reg_field pld_8g_wa_boundary_poll_byp;
      rand uvm_reg_field pcspma_testbus_sel;
      rand uvm_reg_field fifo_empty;
      rand uvm_reg_field fifo_mode;
      rand uvm_reg_field wm_en;
      rand uvm_reg_field fifo_full;
      rand uvm_reg_field phcomp_rd_delay;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          chnl_dp_map_mode_value : coverpoint chnl_dp_map_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          pcs_testbus_sel_value : coverpoint pcs_testbus_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          pld_8g_a1a2_k1k2_flag_poll_byp_value : coverpoint pld_8g_a1a2_k1k2_flag_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_10g_krfec_rx_diag_data_stat_poll_byp_value : coverpoint pld_10g_krfec_rx_diag_data_stat_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_pma_pcie_sw_done_poll_byp_value : coverpoint pld_pma_pcie_sw_done_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_pma_reser_in_poll_byp_value : coverpoint pld_pma_reser_in_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_pma_testbus_poll_byp_value : coverpoint pld_pma_testbus_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_test_data_poll_byp_value : coverpoint pld_test_data_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_8g_wa_boundary_poll_byp_value : coverpoint pld_8g_wa_boundary_poll_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pcspma_testbus_sel_value : coverpoint pcspma_testbus_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_empty_value : coverpoint fifo_empty.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          fifo_mode_value : coverpoint fifo_mode.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          wm_en_value : coverpoint wm_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_full_value : coverpoint fifo_full.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          phcomp_rd_delay_value : coverpoint phcomp_rd_delay.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_rx_chnl_dprio0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         chnl_dp_map_mode = uvm_reg_field::type_id::create("chnl_dp_map_mode");
         // configure
         chnl_dp_map_mode.configure(
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
         pcs_testbus_sel = uvm_reg_field::type_id::create("pcs_testbus_sel");
         // configure
         pcs_testbus_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_8g_a1a2_k1k2_flag_poll_byp = uvm_reg_field::type_id::create("pld_8g_a1a2_k1k2_flag_poll_byp");
         // configure
         pld_8g_a1a2_k1k2_flag_poll_byp.configure(
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
         pld_10g_krfec_rx_diag_data_stat_poll_byp = uvm_reg_field::type_id::create("pld_10g_krfec_rx_diag_data_stat_poll_byp");
         // configure
         pld_10g_krfec_rx_diag_data_stat_poll_byp.configure(
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
         pld_pma_pcie_sw_done_poll_byp = uvm_reg_field::type_id::create("pld_pma_pcie_sw_done_poll_byp");
         // configure
         pld_pma_pcie_sw_done_poll_byp.configure(
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
         pld_pma_reser_in_poll_byp = uvm_reg_field::type_id::create("pld_pma_reser_in_poll_byp");
         // configure
         pld_pma_reser_in_poll_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_pma_testbus_poll_byp = uvm_reg_field::type_id::create("pld_pma_testbus_poll_byp");
         // configure
         pld_pma_testbus_poll_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_test_data_poll_byp = uvm_reg_field::type_id::create("pld_test_data_poll_byp");
         // configure
         pld_test_data_poll_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_8g_wa_boundary_poll_byp = uvm_reg_field::type_id::create("pld_8g_wa_boundary_poll_byp");
         // configure
         pld_8g_wa_boundary_poll_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pcspma_testbus_sel = uvm_reg_field::type_id::create("pcspma_testbus_sel");
         // configure
         pcspma_testbus_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_empty = uvm_reg_field::type_id::create("fifo_empty");
         // configure
         fifo_empty.configure(
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
         fifo_mode = uvm_reg_field::type_id::create("fifo_mode");
         // configure
         fifo_mode.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         wm_en = uvm_reg_field::type_id::create("wm_en");
         // configure
         wm_en.configure(
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
         fifo_full = uvm_reg_field::type_id::create("fifo_full");
         // configure
         fifo_full.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         phcomp_rd_delay = uvm_reg_field::type_id::create("phcomp_rd_delay");
         // configure
         phcomp_rd_delay.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_rx_chnl_dprio0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_rx_chnl_dprio1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_rx_chnl_dprio1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_rx_chnl_dprio1_urm  )

      rand uvm_reg_field double_write;
      rand uvm_reg_field stop_read;
      rand uvm_reg_field stop_write;
      rand uvm_reg_field fifo_pempty;
      rand uvm_reg_field adapter_lpbk_mode;
      rand uvm_reg_field aib_lpbk_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          double_write_value : coverpoint double_write.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          stop_read_value : coverpoint stop_read.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          stop_write_value : coverpoint stop_write.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_pempty_value : coverpoint fifo_pempty.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          adapter_lpbk_mode_value : coverpoint adapter_lpbk_mode.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          aib_lpbk_en_value : coverpoint aib_lpbk_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_rx_chnl_dprio1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         double_write = uvm_reg_field::type_id::create("double_write");
         // configure
         double_write.configure(
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
         stop_read = uvm_reg_field::type_id::create("stop_read");
         // configure
         stop_read.configure(
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
         stop_write = uvm_reg_field::type_id::create("stop_write");
         // configure
         stop_write.configure(
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
         fifo_pempty = uvm_reg_field::type_id::create("fifo_pempty");
         // configure
         fifo_pempty.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         adapter_lpbk_mode = uvm_reg_field::type_id::create("adapter_lpbk_mode");
         // configure
         adapter_lpbk_mode.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_lpbk_en = uvm_reg_field::type_id::create("aib_lpbk_en");
         // configure
         aib_lpbk_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_rx_chnl_dprio1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_rx_chnl_dprio2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_rx_chnl_dprio2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_rx_chnl_dprio2_urm  )

      rand uvm_reg_field fifo_pfull;
      rand uvm_reg_field fifo_power_mode;
      rand uvm_reg_field usertest_sel;
      rand uvm_reg_field hrdrst_user_ctl_en;
      rand uvm_reg_field wr_adj_en;
      rand uvm_reg_field rd_adj_en;
      rand uvm_reg_field async_ltr_rstval;
      rand uvm_reg_field async_ltd_b_rstval;
      rand uvm_reg_field async_pld_8g_sig_det_out_rstval;
      rand uvm_reg_field async_pld_10g_rx_crc32_err_rstval;
      rand uvm_reg_field async_rx_fifo_align_clr_rstval;
      rand uvm_reg_field async_hip_en;
      rand uvm_reg_field parity_sel;
      rand uvm_reg_field stretch_num_stages;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          fifo_pfull_value : coverpoint fifo_pfull.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          fifo_power_mode_value : coverpoint fifo_power_mode.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          usertest_sel_value : coverpoint usertest_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          hrdrst_user_ctl_en_value : coverpoint hrdrst_user_ctl_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          wr_adj_en_value : coverpoint wr_adj_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rd_adj_en_value : coverpoint rd_adj_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_ltr_rstval_value : coverpoint async_ltr_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_ltd_b_rstval_value : coverpoint async_ltd_b_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_pld_8g_sig_det_out_rstval_value : coverpoint async_pld_8g_sig_det_out_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_pld_10g_rx_crc32_err_rstval_value : coverpoint async_pld_10g_rx_crc32_err_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_rx_fifo_align_clr_rstval_value : coverpoint async_rx_fifo_align_clr_rstval.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          async_hip_en_value : coverpoint async_hip_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          parity_sel_value : coverpoint parity_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          stretch_num_stages_value : coverpoint stretch_num_stages.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_rx_chnl_dprio2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         fifo_pfull = uvm_reg_field::type_id::create("fifo_pfull");
         // configure
         fifo_pfull.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_power_mode = uvm_reg_field::type_id::create("fifo_power_mode");
         // configure
         fifo_power_mode.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         usertest_sel = uvm_reg_field::type_id::create("usertest_sel");
         // configure
         usertest_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         hrdrst_user_ctl_en = uvm_reg_field::type_id::create("hrdrst_user_ctl_en");
         // configure
         hrdrst_user_ctl_en.configure(
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
         wr_adj_en = uvm_reg_field::type_id::create("wr_adj_en");
         // configure
         wr_adj_en.configure(
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
         rd_adj_en = uvm_reg_field::type_id::create("rd_adj_en");
         // configure
         rd_adj_en.configure(
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
         async_ltr_rstval = uvm_reg_field::type_id::create("async_ltr_rstval");
         // configure
         async_ltr_rstval.configure(
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
         async_ltd_b_rstval = uvm_reg_field::type_id::create("async_ltd_b_rstval");
         // configure
         async_ltd_b_rstval.configure(
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
         async_pld_8g_sig_det_out_rstval = uvm_reg_field::type_id::create("async_pld_8g_sig_det_out_rstval");
         // configure
         async_pld_8g_sig_det_out_rstval.configure(
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
         async_pld_10g_rx_crc32_err_rstval = uvm_reg_field::type_id::create("async_pld_10g_rx_crc32_err_rstval");
         // configure
         async_pld_10g_rx_crc32_err_rstval.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         async_rx_fifo_align_clr_rstval = uvm_reg_field::type_id::create("async_rx_fifo_align_clr_rstval");
         // configure
         async_rx_fifo_align_clr_rstval.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         async_hip_en = uvm_reg_field::type_id::create("async_hip_en");
         // configure
         async_hip_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         parity_sel = uvm_reg_field::type_id::create("parity_sel");
         // configure
         parity_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (2'b00),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         stretch_num_stages = uvm_reg_field::type_id::create("stretch_num_stages");
         // configure
         stretch_num_stages.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_rx_chnl_dprio2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_rx_chnl_dprio3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_rx_chnl_dprio3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_rx_chnl_dprio3_urm  )

      rand uvm_reg_field datapath_tb_sel;
      rand uvm_reg_field internal_clk1_sel0;
      rand uvm_reg_field internal_clk1_sel1;
      rand uvm_reg_field internal_clk1_sel2;
      rand uvm_reg_field internal_clk1_sel3;
      rand uvm_reg_field txfiford_prect_sel;
      rand uvm_reg_field txfiford_postct_sel;
      rand uvm_reg_field txfifowr_postct_sel;
      rand uvm_reg_field txfifowr_from_aib_sel;
      rand uvm_reg_field rxfiford_to_aib_sel;
      rand uvm_reg_field fifo_wr_clk_sel;
      rand uvm_reg_field fifo_rd_clk_sel;
      rand uvm_reg_field latency_src_sel;
      rand uvm_reg_field internal_clk1_sel;
      rand uvm_reg_field internal_clk2_sel;
      rand uvm_reg_field fifo_wr_clk_scg_en;
      rand uvm_reg_field fifo_rd_clk_scg_en;
      rand uvm_reg_field osc_clk_scg_en;
      rand uvm_reg_field hrdrst_rx_osc_clk_scg_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          datapath_tb_sel_value : coverpoint datapath_tb_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          internal_clk1_sel0_value : coverpoint internal_clk1_sel0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk1_sel1_value : coverpoint internal_clk1_sel1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk1_sel2_value : coverpoint internal_clk1_sel2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk1_sel3_value : coverpoint internal_clk1_sel3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          txfiford_prect_sel_value : coverpoint txfiford_prect_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          txfiford_postct_sel_value : coverpoint txfiford_postct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          txfifowr_postct_sel_value : coverpoint txfifowr_postct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          txfifowr_from_aib_sel_value : coverpoint txfifowr_from_aib_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfiford_to_aib_sel_value : coverpoint rxfiford_to_aib_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_sel_value : coverpoint fifo_wr_clk_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_sel_value : coverpoint fifo_rd_clk_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          latency_src_sel_value : coverpoint latency_src_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk1_sel_value : coverpoint internal_clk1_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          internal_clk2_sel_value : coverpoint internal_clk2_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_scg_en_value : coverpoint fifo_wr_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_scg_en_value : coverpoint fifo_rd_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          osc_clk_scg_en_value : coverpoint osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rx_osc_clk_scg_en_value : coverpoint hrdrst_rx_osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_rx_chnl_dprio3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         datapath_tb_sel = uvm_reg_field::type_id::create("datapath_tb_sel");
         // configure
         datapath_tb_sel.configure(
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
         internal_clk1_sel0 = uvm_reg_field::type_id::create("internal_clk1_sel0");
         // configure
         internal_clk1_sel0.configure(
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
         internal_clk1_sel1 = uvm_reg_field::type_id::create("internal_clk1_sel1");
         // configure
         internal_clk1_sel1.configure(
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
         internal_clk1_sel2 = uvm_reg_field::type_id::create("internal_clk1_sel2");
         // configure
         internal_clk1_sel2.configure(
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
         internal_clk1_sel3 = uvm_reg_field::type_id::create("internal_clk1_sel3");
         // configure
         internal_clk1_sel3.configure(
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
         txfiford_prect_sel = uvm_reg_field::type_id::create("txfiford_prect_sel");
         // configure
         txfiford_prect_sel.configure(
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
         txfiford_postct_sel = uvm_reg_field::type_id::create("txfiford_postct_sel");
         // configure
         txfiford_postct_sel.configure(
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
         txfifowr_postct_sel = uvm_reg_field::type_id::create("txfifowr_postct_sel");
         // configure
         txfifowr_postct_sel.configure(
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
         txfifowr_from_aib_sel = uvm_reg_field::type_id::create("txfifowr_from_aib_sel");
         // configure
         txfifowr_from_aib_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfiford_to_aib_sel = uvm_reg_field::type_id::create("rxfiford_to_aib_sel");
         // configure
         rxfiford_to_aib_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_wr_clk_sel = uvm_reg_field::type_id::create("fifo_wr_clk_sel");
         // configure
         fifo_wr_clk_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_sel = uvm_reg_field::type_id::create("fifo_rd_clk_sel");
         // configure
         fifo_rd_clk_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         latency_src_sel = uvm_reg_field::type_id::create("latency_src_sel");
         // configure
         latency_src_sel.configure(
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
         internal_clk1_sel = uvm_reg_field::type_id::create("internal_clk1_sel");
         // configure
         internal_clk1_sel.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         internal_clk2_sel = uvm_reg_field::type_id::create("internal_clk2_sel");
         // configure
         internal_clk2_sel.configure(
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
         fifo_wr_clk_scg_en = uvm_reg_field::type_id::create("fifo_wr_clk_scg_en");
         // configure
         fifo_wr_clk_scg_en.configure(
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
         fifo_rd_clk_scg_en = uvm_reg_field::type_id::create("fifo_rd_clk_scg_en");
         // configure
         fifo_rd_clk_scg_en.configure(
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
         osc_clk_scg_en = uvm_reg_field::type_id::create("osc_clk_scg_en");
         // configure
         osc_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_rx_osc_clk_scg_en = uvm_reg_field::type_id::create("hrdrst_rx_osc_clk_scg_en");
         // configure
         hrdrst_rx_osc_clk_scg_en.configure(
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
      
endclass : xcvr_reconfig_rx_chnl_dprio3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_rx_chnl_dprio4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_rx_chnl_dprio4_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_rx_chnl_dprio4_urm  )

      rand uvm_reg_field pma_coreclkin_sel;
      rand uvm_reg_field free_run_div_clk;
      rand uvm_reg_field hrdrst_rst_sm_dis;
      rand uvm_reg_field hrdrst_dcd_caldone_byp;
      rand uvm_reg_field rmfflag_stretch_en;
      rand uvm_reg_field rmfflag_stretch_num_stages;
      rand uvm_reg_field internal_clk2_sel0;
      rand uvm_reg_field internal_clk2_sel1;
      rand uvm_reg_field internal_clk2_sel2;
      rand uvm_reg_field internal_clk2_sel3;
      rand uvm_reg_field rxfifowr_prect_sel;
      rand uvm_reg_field rxfifowr_postct_sel;
      rand uvm_reg_field rxfiford_postct_sel;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          pma_coreclkin_sel_value : coverpoint pma_coreclkin_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          free_run_div_clk_value : coverpoint free_run_div_clk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rst_sm_dis_value : coverpoint hrdrst_rst_sm_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_dcd_caldone_byp_value : coverpoint hrdrst_dcd_caldone_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rmfflag_stretch_en_value : coverpoint rmfflag_stretch_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rmfflag_stretch_num_stages_value : coverpoint rmfflag_stretch_num_stages.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          internal_clk2_sel0_value : coverpoint internal_clk2_sel0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk2_sel1_value : coverpoint internal_clk2_sel1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk2_sel2_value : coverpoint internal_clk2_sel2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk2_sel3_value : coverpoint internal_clk2_sel3.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfifowr_prect_sel_value : coverpoint rxfifowr_prect_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfifowr_postct_sel_value : coverpoint rxfifowr_postct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfiford_postct_sel_value : coverpoint rxfiford_postct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_rx_chnl_dprio4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         pma_coreclkin_sel = uvm_reg_field::type_id::create("pma_coreclkin_sel");
         // configure
         pma_coreclkin_sel.configure(
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
         free_run_div_clk = uvm_reg_field::type_id::create("free_run_div_clk");
         // configure
         free_run_div_clk.configure(
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
         hrdrst_rst_sm_dis = uvm_reg_field::type_id::create("hrdrst_rst_sm_dis");
         // configure
         hrdrst_rst_sm_dis.configure(
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
         hrdrst_dcd_caldone_byp = uvm_reg_field::type_id::create("hrdrst_dcd_caldone_byp");
         // configure
         hrdrst_dcd_caldone_byp.configure(
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
         rmfflag_stretch_en = uvm_reg_field::type_id::create("rmfflag_stretch_en");
         // configure
         rmfflag_stretch_en.configure(
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
         rmfflag_stretch_num_stages = uvm_reg_field::type_id::create("rmfflag_stretch_num_stages");
         // configure
         rmfflag_stretch_num_stages.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         internal_clk2_sel0 = uvm_reg_field::type_id::create("internal_clk2_sel0");
         // configure
         internal_clk2_sel0.configure(
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
         internal_clk2_sel1 = uvm_reg_field::type_id::create("internal_clk2_sel1");
         // configure
         internal_clk2_sel1.configure(
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
         internal_clk2_sel2 = uvm_reg_field::type_id::create("internal_clk2_sel2");
         // configure
         internal_clk2_sel2.configure(
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
         internal_clk2_sel3 = uvm_reg_field::type_id::create("internal_clk2_sel3");
         // configure
         internal_clk2_sel3.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifowr_prect_sel = uvm_reg_field::type_id::create("rxfifowr_prect_sel");
         // configure
         rxfifowr_prect_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifowr_postct_sel = uvm_reg_field::type_id::create("rxfifowr_postct_sel");
         // configure
         rxfifowr_postct_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfiford_postct_sel = uvm_reg_field::type_id::create("rxfiford_postct_sel");
         // configure
         rxfiford_postct_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
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
      
endclass : xcvr_reconfig_rx_chnl_dprio4_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_dprio_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_dprio_status_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_dprio_status_urm  )

      rand uvm_reg_field rx_chnl;
      rand uvm_reg_field tx_chnl;
      rand uvm_reg_field sr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rx_chnl_value : coverpoint rx_chnl.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          tx_chnl_value : coverpoint tx_chnl.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          sr_value : coverpoint sr.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_dprio_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rx_chnl = uvm_reg_field::type_id::create("rx_chnl");
         // configure
         rx_chnl.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_chnl = uvm_reg_field::type_id::create("tx_chnl");
         // configure
         tx_chnl.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         sr = uvm_reg_field::type_id::create("sr");
         // configure
         sr.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (16),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_dprio_status_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_aib_dprio_ctrl0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_aib_dprio_ctrl0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_aib_dprio_ctrl0_urm  )

      rand uvm_reg_field aib_dprio0_ctrl_0;
      rand uvm_reg_field aib_dprio0_ctrl_1;
      rand uvm_reg_field aib_dprio0_ctrl_2;
      rand uvm_reg_field aib_dprio0_ctrl_3;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          aib_dprio0_ctrl_0_value : coverpoint aib_dprio0_ctrl_0.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          aib_dprio0_ctrl_1_value : coverpoint aib_dprio0_ctrl_1.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          aib_dprio0_ctrl_2_value : coverpoint aib_dprio0_ctrl_2.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          aib_dprio0_ctrl_3_value : coverpoint aib_dprio0_ctrl_3.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_aib_dprio_ctrl0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         aib_dprio0_ctrl_0 = uvm_reg_field::type_id::create("aib_dprio0_ctrl_0");
         // configure
         aib_dprio0_ctrl_0.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         aib_dprio0_ctrl_1 = uvm_reg_field::type_id::create("aib_dprio0_ctrl_1");
         // configure
         aib_dprio0_ctrl_1.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         aib_dprio0_ctrl_2 = uvm_reg_field::type_id::create("aib_dprio0_ctrl_2");
         // configure
         aib_dprio0_ctrl_2.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         aib_dprio0_ctrl_3 = uvm_reg_field::type_id::create("aib_dprio0_ctrl_3");
         // configure
         aib_dprio0_ctrl_3.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_aib_dprio_ctrl0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_aib_dprio_ctrl1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_aib_dprio_ctrl1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_aib_dprio_ctrl1_urm  )

      rand uvm_reg_field aib_dprio1_ctrl_4;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          aib_dprio1_ctrl_4_value : coverpoint aib_dprio1_ctrl_4.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_aib_dprio_ctrl1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         aib_dprio1_ctrl_4 = uvm_reg_field::type_id::create("aib_dprio1_ctrl_4");
         // configure
         aib_dprio1_ctrl_4.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_aib_dprio_ctrl1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_sr_dprio_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_sr_dprio_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_sr_dprio_ctrl_urm  )

      rand uvm_reg_field reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          reserved_value : coverpoint reserved.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_sr_dprio_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         reserved = uvm_reg_field::type_id::create("reserved");
         // configure
         reserved.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (16'b0000000000000000),
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
      
endclass : xcvr_reconfig_sr_dprio_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_avmm1_dprio_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_avmm1_dprio_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_avmm1_dprio_ctrl_urm  )

      rand uvm_reg_field reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          reserved_value : coverpoint reserved.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_avmm1_dprio_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         reserved = uvm_reg_field::type_id::create("reserved");
         // configure
         reserved.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_avmm1_dprio_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_avmm2_dprio_ctrl_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_avmm2_dprio_ctrl_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_avmm2_dprio_ctrl_urm  )

      rand uvm_reg_field reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          reserved_value : coverpoint reserved.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_avmm2_dprio_ctrl_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         reserved = uvm_reg_field::type_id::create("reserved");
         // configure
         reserved.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_avmm2_dprio_ctrl_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_spare_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_spare_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_spare_urm  )

      rand uvm_reg_field reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          reserved_value : coverpoint reserved.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_spare_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         reserved = uvm_reg_field::type_id::create("reserved");
         // configure
         reserved.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_spare_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm  )

      rand uvm_reg_field txfifo_empty;
      rand uvm_reg_field txfifo_mode;
      rand uvm_reg_field txfifo_full;
      rand uvm_reg_field phcomp_rd_del;
      rand uvm_reg_field txfifo_pempty;
      rand uvm_reg_field indv;
      rand uvm_reg_field fifo_stop_rd;
      rand uvm_reg_field fifo_stop_wr;
      rand uvm_reg_field kk;
      rand uvm_reg_field tx_fifo_power_mode;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          txfifo_empty_value : coverpoint txfifo_empty.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          txfifo_mode_value : coverpoint txfifo_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          txfifo_full_value : coverpoint txfifo_full.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          phcomp_rd_del_value : coverpoint phcomp_rd_del.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          txfifo_pempty_value : coverpoint txfifo_pempty.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          indv_value : coverpoint indv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_stop_rd_value : coverpoint fifo_stop_rd.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_stop_wr_value : coverpoint fifo_stop_wr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          kk_value : coverpoint kk.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          tx_fifo_power_mode_value : coverpoint tx_fifo_power_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         txfifo_empty = uvm_reg_field::type_id::create("txfifo_empty");
         // configure
         txfifo_empty.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (5'b00000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         txfifo_mode = uvm_reg_field::type_id::create("txfifo_mode");
         // configure
         txfifo_mode.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         txfifo_full = uvm_reg_field::type_id::create("txfifo_full");
         // configure
         txfifo_full.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (5'b00000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         phcomp_rd_del = uvm_reg_field::type_id::create("phcomp_rd_del");
         // configure
         phcomp_rd_del.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         txfifo_pempty = uvm_reg_field::type_id::create("txfifo_pempty");
         // configure
         txfifo_pempty.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (5'b00000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         indv = uvm_reg_field::type_id::create("indv");
         // configure
         indv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_stop_rd = uvm_reg_field::type_id::create("fifo_stop_rd");
         // configure
         fifo_stop_rd.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_stop_wr = uvm_reg_field::type_id::create("fifo_stop_wr");
         // configure
         fifo_stop_wr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         kk = uvm_reg_field::type_id::create("kk");
         // configure
         kk.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (5'b00000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_fifo_power_mode = uvm_reg_field::type_id::create("tx_fifo_power_mode");
         // configure
         tx_fifo_power_mode.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm  )

      rand uvm_reg_field comp_cnt;
      rand uvm_reg_field us_master;
      rand uvm_reg_field ds_master;
      rand uvm_reg_field us_bypass_pipeln;
      rand uvm_reg_field ds_bypass_pipeln;
      rand uvm_reg_field compin_sel;
      rand uvm_reg_field bonding_dft_en;
      rand uvm_reg_field bonding_dft_val;
      rand uvm_reg_field dv_bond;
      rand uvm_reg_field gb_tx_idwidth;
      rand uvm_reg_field gb_tx_odwidth;
      rand uvm_reg_field dv_gen;
      rand uvm_reg_field fifo_double_write;
      rand uvm_reg_field frmgen_mfrm_length;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          comp_cnt_value : coverpoint comp_cnt.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          us_master_value : coverpoint us_master.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          ds_master_value : coverpoint ds_master.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          us_bypass_pipeln_value : coverpoint us_bypass_pipeln.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          ds_bypass_pipeln_value : coverpoint ds_bypass_pipeln.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          compin_sel_value : coverpoint compin_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          bonding_dft_en_value : coverpoint bonding_dft_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          bonding_dft_val_value : coverpoint bonding_dft_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          dv_bond_value : coverpoint dv_bond.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          gb_tx_idwidth_value : coverpoint gb_tx_idwidth.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          gb_tx_odwidth_value : coverpoint gb_tx_odwidth.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          dv_gen_value : coverpoint dv_gen.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_double_write_value : coverpoint fifo_double_write.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          frmgen_mfrm_length_value : coverpoint frmgen_mfrm_length.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         comp_cnt = uvm_reg_field::type_id::create("comp_cnt");
         // configure
         comp_cnt.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         us_master = uvm_reg_field::type_id::create("us_master");
         // configure
         us_master.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         ds_master = uvm_reg_field::type_id::create("ds_master");
         // configure
         ds_master.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         us_bypass_pipeln = uvm_reg_field::type_id::create("us_bypass_pipeln");
         // configure
         us_bypass_pipeln.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (10),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         ds_bypass_pipeln = uvm_reg_field::type_id::create("ds_bypass_pipeln");
         // configure
         ds_bypass_pipeln.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         compin_sel = uvm_reg_field::type_id::create("compin_sel");
         // configure
         compin_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         bonding_dft_en = uvm_reg_field::type_id::create("bonding_dft_en");
         // configure
         bonding_dft_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         bonding_dft_val = uvm_reg_field::type_id::create("bonding_dft_val");
         // configure
         bonding_dft_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         dv_bond = uvm_reg_field::type_id::create("dv_bond");
         // configure
         dv_bond.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         gb_tx_idwidth = uvm_reg_field::type_id::create("gb_tx_idwidth");
         // configure
         gb_tx_idwidth.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         gb_tx_odwidth = uvm_reg_field::type_id::create("gb_tx_odwidth");
         // configure
         gb_tx_odwidth.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         dv_gen = uvm_reg_field::type_id::create("dv_gen");
         // configure
         dv_gen.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_double_write = uvm_reg_field::type_id::create("fifo_double_write");
         // configure
         fifo_double_write.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         frmgen_mfrm_length = uvm_reg_field::type_id::create("frmgen_mfrm_length");
         // configure
         frmgen_mfrm_length.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm  )

      rand uvm_reg_field frmgen_mfrm_length;
      rand uvm_reg_field frmgen_bypass;
      rand uvm_reg_field frmgen_pipeln;
      rand uvm_reg_field frmgen_pyld_ins;
      rand uvm_reg_field sh_err;
      rand uvm_reg_field frmgen_burst;
      rand uvm_reg_field word_mark;
      rand uvm_reg_field frmgen_wordslip;
      rand uvm_reg_field tx_pld_pma_fpll_num_phase_shifts_polling_bypass;
      rand uvm_reg_field fsr_pld_txelecidle_rst_val;
      rand uvm_reg_field fsr_hip_fsr_in_bit0_rst_val;
      rand uvm_reg_field fsr_hip_fsr_in_bit1_rst_val;
      rand uvm_reg_field fsr_hip_fsr_in_bit2_rst_val;
      rand uvm_reg_field fsr_hip_fsr_in_bit3_rst_val;
      rand uvm_reg_field fsr_mask_tx_pll_rst_val;
      rand uvm_reg_field fsr_hip_fsr_out_bit0_rst_val;
      rand uvm_reg_field fsr_hip_fsr_out_bit1_rst_val;
      rand uvm_reg_field fsr_hip_fsr_out_bit2_rst_val;
      rand uvm_reg_field fsr_hip_fsr_out_bit3_rst_val;
      rand uvm_reg_field tx_pld_8g_tx_boundary_sel_polling_bypass;
      rand uvm_reg_field tx_pld_10g_tx_bitslip_polling_bypass;
      rand uvm_reg_field tx_hip_aib_ssr_in_polling_bypass;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          frmgen_mfrm_length_value : coverpoint frmgen_mfrm_length.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          frmgen_bypass_value : coverpoint frmgen_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          frmgen_pipeln_value : coverpoint frmgen_pipeln.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          frmgen_pyld_ins_value : coverpoint frmgen_pyld_ins.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          sh_err_value : coverpoint sh_err.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          frmgen_burst_value : coverpoint frmgen_burst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          word_mark_value : coverpoint word_mark.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          frmgen_wordslip_value : coverpoint frmgen_wordslip.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_pld_pma_fpll_num_phase_shifts_polling_bypass_value : coverpoint tx_pld_pma_fpll_num_phase_shifts_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_pld_txelecidle_rst_val_value : coverpoint fsr_pld_txelecidle_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_in_bit0_rst_val_value : coverpoint fsr_hip_fsr_in_bit0_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_in_bit1_rst_val_value : coverpoint fsr_hip_fsr_in_bit1_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_in_bit2_rst_val_value : coverpoint fsr_hip_fsr_in_bit2_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_in_bit3_rst_val_value : coverpoint fsr_hip_fsr_in_bit3_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_mask_tx_pll_rst_val_value : coverpoint fsr_mask_tx_pll_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_out_bit0_rst_val_value : coverpoint fsr_hip_fsr_out_bit0_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_out_bit1_rst_val_value : coverpoint fsr_hip_fsr_out_bit1_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_out_bit2_rst_val_value : coverpoint fsr_hip_fsr_out_bit2_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_hip_fsr_out_bit3_rst_val_value : coverpoint fsr_hip_fsr_out_bit3_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_pld_8g_tx_boundary_sel_polling_bypass_value : coverpoint tx_pld_8g_tx_boundary_sel_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_pld_10g_tx_bitslip_polling_bypass_value : coverpoint tx_pld_10g_tx_bitslip_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_hip_aib_ssr_in_polling_bypass_value : coverpoint tx_hip_aib_ssr_in_polling_bypass.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         frmgen_mfrm_length = uvm_reg_field::type_id::create("frmgen_mfrm_length");
         // configure
         frmgen_mfrm_length.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         frmgen_bypass = uvm_reg_field::type_id::create("frmgen_bypass");
         // configure
         frmgen_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         frmgen_pipeln = uvm_reg_field::type_id::create("frmgen_pipeln");
         // configure
         frmgen_pipeln.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         frmgen_pyld_ins = uvm_reg_field::type_id::create("frmgen_pyld_ins");
         // configure
         frmgen_pyld_ins.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (10),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         sh_err = uvm_reg_field::type_id::create("sh_err");
         // configure
         sh_err.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         frmgen_burst = uvm_reg_field::type_id::create("frmgen_burst");
         // configure
         frmgen_burst.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         word_mark = uvm_reg_field::type_id::create("word_mark");
         // configure
         word_mark.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         frmgen_wordslip = uvm_reg_field::type_id::create("frmgen_wordslip");
         // configure
         frmgen_wordslip.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_pld_pma_fpll_num_phase_shifts_polling_bypass = uvm_reg_field::type_id::create("tx_pld_pma_fpll_num_phase_shifts_polling_bypass");
         // configure
         tx_pld_pma_fpll_num_phase_shifts_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_pld_txelecidle_rst_val = uvm_reg_field::type_id::create("fsr_pld_txelecidle_rst_val");
         // configure
         fsr_pld_txelecidle_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_in_bit0_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_in_bit0_rst_val");
         // configure
         fsr_hip_fsr_in_bit0_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_in_bit1_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_in_bit1_rst_val");
         // configure
         fsr_hip_fsr_in_bit1_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_in_bit2_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_in_bit2_rst_val");
         // configure
         fsr_hip_fsr_in_bit2_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_in_bit3_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_in_bit3_rst_val");
         // configure
         fsr_hip_fsr_in_bit3_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_mask_tx_pll_rst_val = uvm_reg_field::type_id::create("fsr_mask_tx_pll_rst_val");
         // configure
         fsr_mask_tx_pll_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_out_bit0_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_out_bit0_rst_val");
         // configure
         fsr_hip_fsr_out_bit0_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_out_bit1_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_out_bit1_rst_val");
         // configure
         fsr_hip_fsr_out_bit1_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_out_bit2_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_out_bit2_rst_val");
         // configure
         fsr_hip_fsr_out_bit2_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_hip_fsr_out_bit3_rst_val = uvm_reg_field::type_id::create("fsr_hip_fsr_out_bit3_rst_val");
         // configure
         fsr_hip_fsr_out_bit3_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_pld_8g_tx_boundary_sel_polling_bypass = uvm_reg_field::type_id::create("tx_pld_8g_tx_boundary_sel_polling_bypass");
         // configure
         tx_pld_8g_tx_boundary_sel_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_pld_10g_tx_bitslip_polling_bypass = uvm_reg_field::type_id::create("tx_pld_10g_tx_bitslip_polling_bypass");
         // configure
         tx_pld_10g_tx_bitslip_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_hip_aib_ssr_in_polling_bypass = uvm_reg_field::type_id::create("tx_hip_aib_ssr_in_polling_bypass");
         // configure
         tx_hip_aib_ssr_in_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (4'b0000),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm  )

      rand uvm_reg_field pld_clk1_delay_en;
      rand uvm_reg_field pld_clk1_delay_sel;
      rand uvm_reg_field pld_clk1_inv_en;
      rand uvm_reg_field tx_fastbond_wren;
      rand uvm_reg_field fifo_rd_clk_frm_gen_scg_en;
      rand uvm_reg_field fpll_shared_direct_async_in_sel;
      rand uvm_reg_field aib_clk1_sel;
      rand uvm_reg_field aib_clk2_sel;
      rand uvm_reg_field fifo_rd_clk_sel;
      rand uvm_reg_field tx_pld_pma_fpll_cnt_sel_polling_bypass;
      rand uvm_reg_field pld_clk1_sel;
      rand uvm_reg_field pld_clk2_sel;
      rand uvm_reg_field fifo_rd_clk_scg_en;
      rand uvm_reg_field fifo_wr_clk_scg_en;
      rand uvm_reg_field osc_clk_scg_en;
      rand uvm_reg_field hrdrst_rx_osc_clk_scg_en;
      rand uvm_reg_field hip_osc_clk_scg_en;
      rand uvm_reg_field hrdrst_rst_sm_dis;
      rand uvm_reg_field hrdrst_dcd_cal_done_by_pass;
      rand uvm_reg_field hrdrst_user_ctl_en;
      rand uvm_reg_field tx_fastbond_rden;
      rand uvm_reg_field ds_last_chnl;
      rand uvm_reg_field us_last_chnl;
      rand uvm_reg_field tx_usertest_sel;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          pld_clk1_delay_en_value : coverpoint pld_clk1_delay_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_clk1_delay_sel_value : coverpoint pld_clk1_delay_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          pld_clk1_inv_en_value : coverpoint pld_clk1_inv_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_fastbond_wren_value : coverpoint tx_fastbond_wren.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_frm_gen_scg_en_value : coverpoint fifo_rd_clk_frm_gen_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fpll_shared_direct_async_in_sel_value : coverpoint fpll_shared_direct_async_in_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          aib_clk1_sel_value : coverpoint aib_clk1_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          aib_clk2_sel_value : coverpoint aib_clk2_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_sel_value : coverpoint fifo_rd_clk_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          tx_pld_pma_fpll_cnt_sel_polling_bypass_value : coverpoint tx_pld_pma_fpll_cnt_sel_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_clk1_sel_value : coverpoint pld_clk1_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_clk2_sel_value : coverpoint pld_clk2_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_scg_en_value : coverpoint fifo_rd_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_scg_en_value : coverpoint fifo_wr_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          osc_clk_scg_en_value : coverpoint osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rx_osc_clk_scg_en_value : coverpoint hrdrst_rx_osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hip_osc_clk_scg_en_value : coverpoint hip_osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rst_sm_dis_value : coverpoint hrdrst_rst_sm_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_dcd_cal_done_by_pass_value : coverpoint hrdrst_dcd_cal_done_by_pass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_user_ctl_en_value : coverpoint hrdrst_user_ctl_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_fastbond_rden_value : coverpoint tx_fastbond_rden.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          ds_last_chnl_value : coverpoint ds_last_chnl.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          us_last_chnl_value : coverpoint us_last_chnl.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_usertest_sel_value : coverpoint tx_usertest_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         pld_clk1_delay_en = uvm_reg_field::type_id::create("pld_clk1_delay_en");
         // configure
         pld_clk1_delay_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_delay_sel = uvm_reg_field::type_id::create("pld_clk1_delay_sel");
         // configure
         pld_clk1_delay_sel.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_inv_en = uvm_reg_field::type_id::create("pld_clk1_inv_en");
         // configure
         pld_clk1_inv_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_fastbond_wren = uvm_reg_field::type_id::create("tx_fastbond_wren");
         // configure
         tx_fastbond_wren.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_frm_gen_scg_en = uvm_reg_field::type_id::create("fifo_rd_clk_frm_gen_scg_en");
         // configure
         fifo_rd_clk_frm_gen_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fpll_shared_direct_async_in_sel = uvm_reg_field::type_id::create("fpll_shared_direct_async_in_sel");
         // configure
         fpll_shared_direct_async_in_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_clk1_sel = uvm_reg_field::type_id::create("aib_clk1_sel");
         // configure
         aib_clk1_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (10),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_clk2_sel = uvm_reg_field::type_id::create("aib_clk2_sel");
         // configure
         aib_clk2_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_sel = uvm_reg_field::type_id::create("fifo_rd_clk_sel");
         // configure
         fifo_rd_clk_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_pld_pma_fpll_cnt_sel_polling_bypass = uvm_reg_field::type_id::create("tx_pld_pma_fpll_cnt_sel_polling_bypass");
         // configure
         tx_pld_pma_fpll_cnt_sel_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_sel = uvm_reg_field::type_id::create("pld_clk1_sel");
         // configure
         pld_clk1_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk2_sel = uvm_reg_field::type_id::create("pld_clk2_sel");
         // configure
         pld_clk2_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_scg_en = uvm_reg_field::type_id::create("fifo_rd_clk_scg_en");
         // configure
         fifo_rd_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_wr_clk_scg_en = uvm_reg_field::type_id::create("fifo_wr_clk_scg_en");
         // configure
         fifo_wr_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         osc_clk_scg_en = uvm_reg_field::type_id::create("osc_clk_scg_en");
         // configure
         osc_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_rx_osc_clk_scg_en = uvm_reg_field::type_id::create("hrdrst_rx_osc_clk_scg_en");
         // configure
         hrdrst_rx_osc_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hip_osc_clk_scg_en = uvm_reg_field::type_id::create("hip_osc_clk_scg_en");
         // configure
         hip_osc_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_rst_sm_dis = uvm_reg_field::type_id::create("hrdrst_rst_sm_dis");
         // configure
         hrdrst_rst_sm_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_dcd_cal_done_by_pass = uvm_reg_field::type_id::create("hrdrst_dcd_cal_done_by_pass");
         // configure
         hrdrst_dcd_cal_done_by_pass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_user_ctl_en = uvm_reg_field::type_id::create("hrdrst_user_ctl_en");
         // configure
         hrdrst_user_ctl_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_fastbond_rden = uvm_reg_field::type_id::create("tx_fastbond_rden");
         // configure
         tx_fastbond_rden.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         ds_last_chnl = uvm_reg_field::type_id::create("ds_last_chnl");
         // configure
         ds_last_chnl.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         us_last_chnl = uvm_reg_field::type_id::create("us_last_chnl");
         // configure
         us_last_chnl.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_usertest_sel = uvm_reg_field::type_id::create("tx_usertest_sel");
         // configure
         tx_usertest_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm  )

      rand uvm_reg_field stretch_num_stages;
      rand uvm_reg_field tx_datapath_tb_sel;
      rand uvm_reg_field tx_fifo_write_latency_adjust;
      rand uvm_reg_field tx_fifo_read_latency_adjust;
      rand uvm_reg_field rxfifo_empty;
      rand uvm_reg_field rx_fastbond_wren;
      rand uvm_reg_field rxfifo_full;
      rand uvm_reg_field fifo_double_read;
      rand uvm_reg_field dv_mode;
      rand uvm_reg_field rxfifo_pempty;
      rand uvm_reg_field fifo_stop_rd;
      rand uvm_reg_field fifo_stop_wr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stretch_num_stages_value : coverpoint stretch_num_stages.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          tx_datapath_tb_sel_value : coverpoint tx_datapath_tb_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          tx_fifo_write_latency_adjust_value : coverpoint tx_fifo_write_latency_adjust.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_fifo_read_latency_adjust_value : coverpoint tx_fifo_read_latency_adjust.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfifo_empty_value : coverpoint rxfifo_empty.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          rx_fastbond_wren_value : coverpoint rx_fastbond_wren.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          rxfifo_full_value : coverpoint rxfifo_full.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          fifo_double_read_value : coverpoint fifo_double_read.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          dv_mode_value : coverpoint dv_mode.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfifo_pempty_value : coverpoint rxfifo_pempty.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          fifo_stop_rd_value : coverpoint fifo_stop_rd.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_stop_wr_value : coverpoint fifo_stop_wr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stretch_num_stages = uvm_reg_field::type_id::create("stretch_num_stages");
         // configure
         stretch_num_stages.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_datapath_tb_sel = uvm_reg_field::type_id::create("tx_datapath_tb_sel");
         // configure
         tx_datapath_tb_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_fifo_write_latency_adjust = uvm_reg_field::type_id::create("tx_fifo_write_latency_adjust");
         // configure
         tx_fifo_write_latency_adjust.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_fifo_read_latency_adjust = uvm_reg_field::type_id::create("tx_fifo_read_latency_adjust");
         // configure
         tx_fifo_read_latency_adjust.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifo_empty = uvm_reg_field::type_id::create("rxfifo_empty");
         // configure
         rxfifo_empty.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_fastbond_wren = uvm_reg_field::type_id::create("rx_fastbond_wren");
         // configure
         rx_fastbond_wren.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifo_full = uvm_reg_field::type_id::create("rxfifo_full");
         // configure
         rxfifo_full.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_double_read = uvm_reg_field::type_id::create("fifo_double_read");
         // configure
         fifo_double_read.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         dv_mode = uvm_reg_field::type_id::create("dv_mode");
         // configure
         dv_mode.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifo_pempty = uvm_reg_field::type_id::create("rxfifo_pempty");
         // configure
         rxfifo_pempty.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_stop_rd = uvm_reg_field::type_id::create("fifo_stop_rd");
         // configure
         fifo_stop_rd.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_stop_wr = uvm_reg_field::type_id::create("fifo_stop_wr");
         // configure
         fifo_stop_wr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm  )

      rand uvm_reg_field rxfifo_pfull;
      rand uvm_reg_field indv;
      rand uvm_reg_field rx_true_b4b;
      rand uvm_reg_field rxfifo_mode;
      rand uvm_reg_field phcomp_rd_del;
      rand uvm_reg_field lpbk_mode;
      rand uvm_reg_field rx_fifo_write_latency_adjust;
      rand uvm_reg_field comp_cnt;
      rand uvm_reg_field us_master;
      rand uvm_reg_field ds_master;
      rand uvm_reg_field us_bypass_pipeln;
      rand uvm_reg_field ds_bypass_pipeln;
      rand uvm_reg_field compin_sel;
      rand uvm_reg_field bonding_dft_en;
      rand uvm_reg_field bonding_dft_val;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rxfifo_pfull_value : coverpoint rxfifo_pfull.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          indv_value : coverpoint indv.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_true_b4b_value : coverpoint rx_true_b4b.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfifo_mode_value : coverpoint rxfifo_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          phcomp_rd_del_value : coverpoint phcomp_rd_del.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          lpbk_mode_value : coverpoint lpbk_mode.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_fifo_write_latency_adjust_value : coverpoint rx_fifo_write_latency_adjust.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          comp_cnt_value : coverpoint comp_cnt.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          us_master_value : coverpoint us_master.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          ds_master_value : coverpoint ds_master.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          us_bypass_pipeln_value : coverpoint us_bypass_pipeln.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          ds_bypass_pipeln_value : coverpoint ds_bypass_pipeln.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          compin_sel_value : coverpoint compin_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          bonding_dft_en_value : coverpoint bonding_dft_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          bonding_dft_val_value : coverpoint bonding_dft_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rxfifo_pfull = uvm_reg_field::type_id::create("rxfifo_pfull");
         // configure
         rxfifo_pfull.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         indv = uvm_reg_field::type_id::create("indv");
         // configure
         indv.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_true_b4b = uvm_reg_field::type_id::create("rx_true_b4b");
         // configure
         rx_true_b4b.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifo_mode = uvm_reg_field::type_id::create("rxfifo_mode");
         // configure
         rxfifo_mode.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         phcomp_rd_del = uvm_reg_field::type_id::create("phcomp_rd_del");
         // configure
         phcomp_rd_del.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         lpbk_mode = uvm_reg_field::type_id::create("lpbk_mode");
         // configure
         lpbk_mode.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_fifo_write_latency_adjust = uvm_reg_field::type_id::create("rx_fifo_write_latency_adjust");
         // configure
         rx_fifo_write_latency_adjust.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         comp_cnt = uvm_reg_field::type_id::create("comp_cnt");
         // configure
         comp_cnt.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         us_master = uvm_reg_field::type_id::create("us_master");
         // configure
         us_master.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         ds_master = uvm_reg_field::type_id::create("ds_master");
         // configure
         ds_master.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         us_bypass_pipeln = uvm_reg_field::type_id::create("us_bypass_pipeln");
         // configure
         us_bypass_pipeln.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         ds_bypass_pipeln = uvm_reg_field::type_id::create("ds_bypass_pipeln");
         // configure
         ds_bypass_pipeln.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         compin_sel = uvm_reg_field::type_id::create("compin_sel");
         // configure
         compin_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         bonding_dft_en = uvm_reg_field::type_id::create("bonding_dft_en");
         // configure
         bonding_dft_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         bonding_dft_val = uvm_reg_field::type_id::create("bonding_dft_val");
         // configure
         bonding_dft_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm  )

      rand uvm_reg_field asn_wait_for_dll_reset_cnt;
      rand uvm_reg_field asn_wait_for_pma_pcie_sw_done_cnt;
      rand uvm_reg_field reserved0;
      rand uvm_reg_field rx_pld_8g_eidleinfersel_polling_bypass;
      rand uvm_reg_field rx_pld_pma_eye_monitor_polling_bypass;
      rand uvm_reg_field rx_pld_pma_pcie_switch_polling_bypass;
      rand uvm_reg_field rx_pld_pma_reser_out_polling_bypass;
      rand uvm_reg_field fsr_pld_ltr_rst_val;
      rand uvm_reg_field fsr_pld_ltd_b_rst_val;
      rand uvm_reg_field fsr_pld_8g_sigdet_out_rst_val;
      rand uvm_reg_field fsr_pld_10g_rx_crc32_err_rst_val;
      rand uvm_reg_field fsr_pld_rx_fifo_align_clr_rst_val;
      rand uvm_reg_field rx_prbs_flags_sr_enable;
      rand uvm_reg_field rx_usertest_sel;
      rand uvm_reg_field reserved1;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          asn_wait_for_dll_reset_cnt_value : coverpoint asn_wait_for_dll_reset_cnt.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          asn_wait_for_pma_pcie_sw_done_cnt_value : coverpoint asn_wait_for_pma_pcie_sw_done_cnt.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          reserved0_value : coverpoint reserved0.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          rx_pld_8g_eidleinfersel_polling_bypass_value : coverpoint rx_pld_8g_eidleinfersel_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_pld_pma_eye_monitor_polling_bypass_value : coverpoint rx_pld_pma_eye_monitor_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_pld_pma_pcie_switch_polling_bypass_value : coverpoint rx_pld_pma_pcie_switch_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_pld_pma_reser_out_polling_bypass_value : coverpoint rx_pld_pma_reser_out_polling_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_pld_ltr_rst_val_value : coverpoint fsr_pld_ltr_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_pld_ltd_b_rst_val_value : coverpoint fsr_pld_ltd_b_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_pld_8g_sigdet_out_rst_val_value : coverpoint fsr_pld_8g_sigdet_out_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_pld_10g_rx_crc32_err_rst_val_value : coverpoint fsr_pld_10g_rx_crc32_err_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fsr_pld_rx_fifo_align_clr_rst_val_value : coverpoint fsr_pld_rx_fifo_align_clr_rst_val.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_prbs_flags_sr_enable_value : coverpoint rx_prbs_flags_sr_enable.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_usertest_sel_value : coverpoint rx_usertest_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved1_value : coverpoint reserved1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         asn_wait_for_dll_reset_cnt = uvm_reg_field::type_id::create("asn_wait_for_dll_reset_cnt");
         // configure
         asn_wait_for_dll_reset_cnt.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         asn_wait_for_pma_pcie_sw_done_cnt = uvm_reg_field::type_id::create("asn_wait_for_pma_pcie_sw_done_cnt");
         // configure
         asn_wait_for_pma_pcie_sw_done_cnt.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         reserved0 = uvm_reg_field::type_id::create("reserved0");
         // configure
         reserved0.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_pld_8g_eidleinfersel_polling_bypass = uvm_reg_field::type_id::create("rx_pld_8g_eidleinfersel_polling_bypass");
         // configure
         rx_pld_8g_eidleinfersel_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_pld_pma_eye_monitor_polling_bypass = uvm_reg_field::type_id::create("rx_pld_pma_eye_monitor_polling_bypass");
         // configure
         rx_pld_pma_eye_monitor_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_pld_pma_pcie_switch_polling_bypass = uvm_reg_field::type_id::create("rx_pld_pma_pcie_switch_polling_bypass");
         // configure
         rx_pld_pma_pcie_switch_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_pld_pma_reser_out_polling_bypass = uvm_reg_field::type_id::create("rx_pld_pma_reser_out_polling_bypass");
         // configure
         rx_pld_pma_reser_out_polling_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_pld_ltr_rst_val = uvm_reg_field::type_id::create("fsr_pld_ltr_rst_val");
         // configure
         fsr_pld_ltr_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_pld_ltd_b_rst_val = uvm_reg_field::type_id::create("fsr_pld_ltd_b_rst_val");
         // configure
         fsr_pld_ltd_b_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_pld_8g_sigdet_out_rst_val = uvm_reg_field::type_id::create("fsr_pld_8g_sigdet_out_rst_val");
         // configure
         fsr_pld_8g_sigdet_out_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_pld_10g_rx_crc32_err_rst_val = uvm_reg_field::type_id::create("fsr_pld_10g_rx_crc32_err_rst_val");
         // configure
         fsr_pld_10g_rx_crc32_err_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fsr_pld_rx_fifo_align_clr_rst_val = uvm_reg_field::type_id::create("fsr_pld_rx_fifo_align_clr_rst_val");
         // configure
         fsr_pld_rx_fifo_align_clr_rst_val.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_prbs_flags_sr_enable = uvm_reg_field::type_id::create("rx_prbs_flags_sr_enable");
         // configure
         rx_prbs_flags_sr_enable.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_usertest_sel = uvm_reg_field::type_id::create("rx_usertest_sel");
         // configure
         rx_usertest_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved1 = uvm_reg_field::type_id::create("reserved1");
         // configure
         reserved1.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm  )

      rand uvm_reg_field stretch_num_stages;
      rand uvm_reg_field rx_datapath_tb_sel;
      rand uvm_reg_field rx_fifo_read_latency_adjust;
      rand uvm_reg_field pld_clk1_delay_en;
      rand uvm_reg_field pld_clk1_delay_set;
      rand uvm_reg_field pld_clk1_inv_en;
      rand uvm_reg_field reserved;
      rand uvm_reg_field aib_clk1_sel;
      rand uvm_reg_field aib_clk2_sel;
      rand uvm_reg_field fifo_wr_clk_sel;
      rand uvm_reg_field fifo_rd_clk_sel;
      rand uvm_reg_field pld_clk1_sel;
      rand uvm_reg_field sclk_sel;
      rand uvm_reg_field fifo_wr_clk_scg_en;
      rand uvm_reg_field fifo_rd_clk_scg_en;
      rand uvm_reg_field pma_hclk_scg_en;
      rand uvm_reg_field osc_clk_scg_en;
      rand uvm_reg_field hrdrst_rx_osc_clk_scg_en;
      rand uvm_reg_field fifo_wr_clk_del_sm_scg_en;
      rand uvm_reg_field fifo_rd_clk_ins_sm_scg_en;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          stretch_num_stages_value : coverpoint stretch_num_stages.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          rx_datapath_tb_sel_value : coverpoint rx_datapath_tb_sel.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          rx_fifo_read_latency_adjust_value : coverpoint rx_fifo_read_latency_adjust.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_clk1_delay_en_value : coverpoint pld_clk1_delay_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pld_clk1_delay_set_value : coverpoint pld_clk1_delay_set.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          pld_clk1_inv_en_value : coverpoint pld_clk1_inv_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved_value : coverpoint reserved.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          aib_clk1_sel_value : coverpoint aib_clk1_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          aib_clk2_sel_value : coverpoint aib_clk2_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_sel_value : coverpoint fifo_wr_clk_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_sel_value : coverpoint fifo_rd_clk_sel.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
          pld_clk1_sel_value : coverpoint pld_clk1_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          sclk_sel_value : coverpoint sclk_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_scg_en_value : coverpoint fifo_wr_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_scg_en_value : coverpoint fifo_rd_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          pma_hclk_scg_en_value : coverpoint pma_hclk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          osc_clk_scg_en_value : coverpoint osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rx_osc_clk_scg_en_value : coverpoint hrdrst_rx_osc_clk_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_wr_clk_del_sm_scg_en_value : coverpoint fifo_wr_clk_del_sm_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          fifo_rd_clk_ins_sm_scg_en_value : coverpoint fifo_rd_clk_ins_sm_scg_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         stretch_num_stages = uvm_reg_field::type_id::create("stretch_num_stages");
         // configure
         stretch_num_stages.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_datapath_tb_sel = uvm_reg_field::type_id::create("rx_datapath_tb_sel");
         // configure
         rx_datapath_tb_sel.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_fifo_read_latency_adjust = uvm_reg_field::type_id::create("rx_fifo_read_latency_adjust");
         // configure
         rx_fifo_read_latency_adjust.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_delay_en = uvm_reg_field::type_id::create("pld_clk1_delay_en");
         // configure
         pld_clk1_delay_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_delay_set = uvm_reg_field::type_id::create("pld_clk1_delay_set");
         // configure
         pld_clk1_delay_set.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_inv_en = uvm_reg_field::type_id::create("pld_clk1_inv_en");
         // configure
         pld_clk1_inv_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved = uvm_reg_field::type_id::create("reserved");
         // configure
         reserved.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_clk1_sel = uvm_reg_field::type_id::create("aib_clk1_sel");
         // configure
         aib_clk1_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_clk2_sel = uvm_reg_field::type_id::create("aib_clk2_sel");
         // configure
         aib_clk2_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (18),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_wr_clk_sel = uvm_reg_field::type_id::create("fifo_wr_clk_sel");
         // configure
         fifo_wr_clk_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_sel = uvm_reg_field::type_id::create("fifo_rd_clk_sel");
         // configure
         fifo_rd_clk_sel.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (2'b00),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pld_clk1_sel = uvm_reg_field::type_id::create("pld_clk1_sel");
         // configure
         pld_clk1_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         sclk_sel = uvm_reg_field::type_id::create("sclk_sel");
         // configure
         sclk_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_wr_clk_scg_en = uvm_reg_field::type_id::create("fifo_wr_clk_scg_en");
         // configure
         fifo_wr_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (25),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_scg_en = uvm_reg_field::type_id::create("fifo_rd_clk_scg_en");
         // configure
         fifo_rd_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (26),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         pma_hclk_scg_en = uvm_reg_field::type_id::create("pma_hclk_scg_en");
         // configure
         pma_hclk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         osc_clk_scg_en = uvm_reg_field::type_id::create("osc_clk_scg_en");
         // configure
         osc_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_rx_osc_clk_scg_en = uvm_reg_field::type_id::create("hrdrst_rx_osc_clk_scg_en");
         // configure
         hrdrst_rx_osc_clk_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_wr_clk_del_sm_scg_en = uvm_reg_field::type_id::create("fifo_wr_clk_del_sm_scg_en");
         // configure
         fifo_wr_clk_del_sm_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (30),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         fifo_rd_clk_ins_sm_scg_en = uvm_reg_field::type_id::create("fifo_rd_clk_ins_sm_scg_en");
         // configure
         fifo_rd_clk_ins_sm_scg_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (31),
         .access                 ("RW"),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm  )

      rand uvm_reg_field internal_clk1_sel1;
      rand uvm_reg_field internal_clk1_sel2;
      rand uvm_reg_field txfiford_post_ct_sel;
      rand uvm_reg_field txfifowr_post_ct_sel;
      rand uvm_reg_field internal_clk2_sel1;
      rand uvm_reg_field internal_clk2_sel2;
      rand uvm_reg_field rxfifowr_post_ct_sel;
      rand uvm_reg_field rxfiford_post_ct_sel;
      rand uvm_reg_field free_run_div_clk;
      rand uvm_reg_field hrdrst_rst_sm_dis;
      rand uvm_reg_field hrdrst_dll_lock_bypass;
      rand uvm_reg_field hrdrst_align_bypass;
      rand uvm_reg_field hrdrst_user_ctl_en;
      rand uvm_reg_field reserved0;
      rand uvm_reg_field ds_last_chnl;
      rand uvm_reg_field us_last_chnl;
      rand uvm_reg_field reserved1;
      rand uvm_reg_field hdpldadapt_sr_sr_testbus_sel;
      rand uvm_reg_field reserved2;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          internal_clk1_sel1_value : coverpoint internal_clk1_sel1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk1_sel2_value : coverpoint internal_clk1_sel2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          txfiford_post_ct_sel_value : coverpoint txfiford_post_ct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          txfifowr_post_ct_sel_value : coverpoint txfifowr_post_ct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk2_sel1_value : coverpoint internal_clk2_sel1.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          internal_clk2_sel2_value : coverpoint internal_clk2_sel2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfifowr_post_ct_sel_value : coverpoint rxfifowr_post_ct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rxfiford_post_ct_sel_value : coverpoint rxfiford_post_ct_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          free_run_div_clk_value : coverpoint free_run_div_clk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_rst_sm_dis_value : coverpoint hrdrst_rst_sm_dis.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_dll_lock_bypass_value : coverpoint hrdrst_dll_lock_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_align_bypass_value : coverpoint hrdrst_align_bypass.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hrdrst_user_ctl_en_value : coverpoint hrdrst_user_ctl_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved0_value : coverpoint reserved0.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          ds_last_chnl_value : coverpoint ds_last_chnl.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          us_last_chnl_value : coverpoint us_last_chnl.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved1_value : coverpoint reserved1.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          hdpldadapt_sr_sr_testbus_sel_value : coverpoint hdpldadapt_sr_sr_testbus_sel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved2_value : coverpoint reserved2.value {
             bins all[8] = {[12'h0:12'hfff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         internal_clk1_sel1 = uvm_reg_field::type_id::create("internal_clk1_sel1");
         // configure
         internal_clk1_sel1.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         internal_clk1_sel2 = uvm_reg_field::type_id::create("internal_clk1_sel2");
         // configure
         internal_clk1_sel2.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         txfiford_post_ct_sel = uvm_reg_field::type_id::create("txfiford_post_ct_sel");
         // configure
         txfiford_post_ct_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         txfifowr_post_ct_sel = uvm_reg_field::type_id::create("txfifowr_post_ct_sel");
         // configure
         txfifowr_post_ct_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         internal_clk2_sel1 = uvm_reg_field::type_id::create("internal_clk2_sel1");
         // configure
         internal_clk2_sel1.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         internal_clk2_sel2 = uvm_reg_field::type_id::create("internal_clk2_sel2");
         // configure
         internal_clk2_sel2.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfifowr_post_ct_sel = uvm_reg_field::type_id::create("rxfifowr_post_ct_sel");
         // configure
         rxfifowr_post_ct_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (6),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxfiford_post_ct_sel = uvm_reg_field::type_id::create("rxfiford_post_ct_sel");
         // configure
         rxfiford_post_ct_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (7),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         free_run_div_clk = uvm_reg_field::type_id::create("free_run_div_clk");
         // configure
         free_run_div_clk.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_rst_sm_dis = uvm_reg_field::type_id::create("hrdrst_rst_sm_dis");
         // configure
         hrdrst_rst_sm_dis.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_dll_lock_bypass = uvm_reg_field::type_id::create("hrdrst_dll_lock_bypass");
         // configure
         hrdrst_dll_lock_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (10),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_align_bypass = uvm_reg_field::type_id::create("hrdrst_align_bypass");
         // configure
         hrdrst_align_bypass.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hrdrst_user_ctl_en = uvm_reg_field::type_id::create("hrdrst_user_ctl_en");
         // configure
         hrdrst_user_ctl_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (12),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved0 = uvm_reg_field::type_id::create("reserved0");
         // configure
         reserved0.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         ds_last_chnl = uvm_reg_field::type_id::create("ds_last_chnl");
         // configure
         ds_last_chnl.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         us_last_chnl = uvm_reg_field::type_id::create("us_last_chnl");
         // configure
         us_last_chnl.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved1 = uvm_reg_field::type_id::create("reserved1");
         // configure
         reserved1.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         hdpldadapt_sr_sr_testbus_sel = uvm_reg_field::type_id::create("hdpldadapt_sr_sr_testbus_sel");
         // configure
         hdpldadapt_sr_sr_testbus_sel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved2 = uvm_reg_field::type_id::create("reserved2");
         // configure
         reserved2.configure(
         .parent                 ( this ),
         .size                   (12),
         .lsb_pos                (20),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (12'b000000000000),
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
      
endclass : xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_aibnd_32B_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_aibnd_32B_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_aibnd_32B_urm  )

      rand uvm_reg_field aib_dllstr_align_dy_ctl_static;
      rand uvm_reg_field aib_dllstr_align_dy_ctlsel;
      rand uvm_reg_field reserved0;
      rand uvm_reg_field aib_tx_dcc_dy_ctlsel;
      rand uvm_reg_field aib_tx_dcc_dy_ctl_static;
      rand uvm_reg_field aib_tx_dcc_byp;
      rand uvm_reg_field aib_tx_dcc_en;
      rand uvm_reg_field aib_tx_dcc_cont_cal;
      rand uvm_reg_field reserved1;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          aib_dllstr_align_dy_ctl_static_value : coverpoint aib_dllstr_align_dy_ctl_static.value {
             bins all[8] = {[10'h0:10'h3ff]};
             illegal_bins bad = default;
          }
          aib_dllstr_align_dy_ctlsel_value : coverpoint aib_dllstr_align_dy_ctlsel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved0_value : coverpoint reserved0.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          aib_tx_dcc_dy_ctlsel_value : coverpoint aib_tx_dcc_dy_ctlsel.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          aib_tx_dcc_dy_ctl_static_value : coverpoint aib_tx_dcc_dy_ctl_static.value {
             bins all[8] = {[10'h0:10'h3ff]};
             illegal_bins bad = default;
          }
          aib_tx_dcc_byp_value : coverpoint aib_tx_dcc_byp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          aib_tx_dcc_en_value : coverpoint aib_tx_dcc_en.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          aib_tx_dcc_cont_cal_value : coverpoint aib_tx_dcc_cont_cal.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          reserved1_value : coverpoint reserved1.value {
             bins all[4] = {[2'h0:2'h3]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_aibnd_32B_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         aib_dllstr_align_dy_ctl_static = uvm_reg_field::type_id::create("aib_dllstr_align_dy_ctl_static");
         // configure
         aib_dllstr_align_dy_ctl_static.configure(
         .parent                 ( this ),
         .size                   (10),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (10'b0000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_dllstr_align_dy_ctlsel = uvm_reg_field::type_id::create("aib_dllstr_align_dy_ctlsel");
         // configure
         aib_dllstr_align_dy_ctlsel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (10),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved0 = uvm_reg_field::type_id::create("reserved0");
         // configure
         reserved0.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (11),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (5'b00000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_tx_dcc_dy_ctlsel = uvm_reg_field::type_id::create("aib_tx_dcc_dy_ctlsel");
         // configure
         aib_tx_dcc_dy_ctlsel.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_tx_dcc_dy_ctl_static = uvm_reg_field::type_id::create("aib_tx_dcc_dy_ctl_static");
         // configure
         aib_tx_dcc_dy_ctl_static.configure(
         .parent                 ( this ),
         .size                   (10),
         .lsb_pos                (17),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (10'b0000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_tx_dcc_byp = uvm_reg_field::type_id::create("aib_tx_dcc_byp");
         // configure
         aib_tx_dcc_byp.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (27),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_tx_dcc_en = uvm_reg_field::type_id::create("aib_tx_dcc_en");
         // configure
         aib_tx_dcc_en.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (28),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         aib_tx_dcc_cont_cal = uvm_reg_field::type_id::create("aib_tx_dcc_cont_cal");
         // configure
         aib_tx_dcc_cont_cal.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (29),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved1 = uvm_reg_field::type_id::create("reserved1");
         // configure
         reserved1.configure(
         .parent                 ( this ),
         .size                   (2),
         .lsb_pos                (30),
         .access                 ("RW"),
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
      
endclass : xcvr_reconfig_reg_hssi_aibnd_32B_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm  )

      rand uvm_reg_field r_tx_chnl_datapath_status_0;
      rand uvm_reg_field wa_error;
      rand uvm_reg_field wa_error_cnt;
      rand uvm_reg_field r_rx_chnl_datapath_status_0_res_5_7;
      rand uvm_reg_field reserved;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          r_tx_chnl_datapath_status_0_value : coverpoint r_tx_chnl_datapath_status_0.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
          wa_error_value : coverpoint wa_error.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          wa_error_cnt_value : coverpoint wa_error_cnt.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          r_rx_chnl_datapath_status_0_res_5_7_value : coverpoint r_rx_chnl_datapath_status_0_res_5_7.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          reserved_value : coverpoint reserved.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         r_tx_chnl_datapath_status_0 = uvm_reg_field::type_id::create("r_tx_chnl_datapath_status_0");
         // configure
         r_tx_chnl_datapath_status_0.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (8'b00000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         wa_error = uvm_reg_field::type_id::create("wa_error");
         // configure
         wa_error.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         wa_error_cnt = uvm_reg_field::type_id::create("wa_error_cnt");
         // configure
         wa_error_cnt.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (9),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         r_rx_chnl_datapath_status_0_res_5_7 = uvm_reg_field::type_id::create("r_rx_chnl_datapath_status_0_res_5_7");
         // configure
         r_rx_chnl_datapath_status_0_res_5_7.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (3'b000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         reserved = uvm_reg_field::type_id::create("reserved");
         // configure
         reserved.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (1),
         .reset                  (16'b0000000000000000),
         .has_reset              (0),
         .is_rand                (1),
         .individually_accessible(1));
         
      endfunction : build

      function void sample_values();
         super.sample_values();
         if (get_coverage(UVM_CVR_FIELD_VALS)) begin
            if(cg_field_values!=null) cg_field_values.sample();
         end
      endfunction
      
endclass : xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_revid_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_revid_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_revid_urm  )

      rand uvm_reg_field id;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          id_value : coverpoint id.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_revid_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         id = uvm_reg_field::type_id::create("id");
         // configure
         id.configure(
         .parent                 ( this ),
         .size                   (32),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (0),
         .reset                  (32'b00010001000100010010000000010101),
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
      
endclass : xcvr_reconfig_reg_phy_revid_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_scratch_register_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_scratch_register_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_scratch_register_urm  )

      rand uvm_reg_field scratch;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          scratch_value : coverpoint scratch.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_scratch_register_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         scratch = uvm_reg_field::type_id::create("scratch");
         // configure
         scratch.configure(
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
      
endclass : xcvr_reconfig_reg_phy_scratch_register_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_name_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_name_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_name_urm  )

      rand uvm_reg_field id;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          id_value : coverpoint id.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_name_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         id = uvm_reg_field::type_id::create("id");
         // configure
         id.configure(
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
      
endclass : xcvr_reconfig_reg_phy_name_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_name_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_name_1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_name_1_urm  )

      rand uvm_reg_field id;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          id_value : coverpoint id.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_name_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         id = uvm_reg_field::type_id::create("id");
         // configure
         id.configure(
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
      
endclass : xcvr_reconfig_reg_phy_name_1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_name_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_name_2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_name_2_urm  )

      rand uvm_reg_field id;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          id_value : coverpoint id.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_name_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         id = uvm_reg_field::type_id::create("id");
         // configure
         id.configure(
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
      
endclass : xcvr_reconfig_reg_phy_name_2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_ehip_mode_muxes_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_ehip_mode_muxes_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_ehip_mode_muxes_urm  )

      rand uvm_reg_field txpcsmux_sel;
      rand uvm_reg_field rxpcsmux_sel;
      rand uvm_reg_field rxmacmux_sel;
      rand uvm_reg_field rxpldmux_sel;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          txpcsmux_sel_value : coverpoint txpcsmux_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          rxpcsmux_sel_value : coverpoint rxpcsmux_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          rxmacmux_sel_value : coverpoint rxmacmux_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          rxpldmux_sel_value : coverpoint rxpldmux_sel.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_ehip_mode_muxes_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         txpcsmux_sel = uvm_reg_field::type_id::create("txpcsmux_sel");
         // configure
         txpcsmux_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (3),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         rxpcsmux_sel = uvm_reg_field::type_id::create("rxpcsmux_sel");
         // configure
         rxpcsmux_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (15),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rxmacmux_sel = uvm_reg_field::type_id::create("rxmacmux_sel");
         // configure
         rxmacmux_sel.configure(
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
         rxpldmux_sel = uvm_reg_field::type_id::create("rxpldmux_sel");
         // configure
         rxpldmux_sel.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (21),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
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
      
endclass : xcvr_reconfig_reg_ehip_mode_muxes_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_ehip_pcs_modes_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_ehip_pcs_modes_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_ehip_pcs_modes_urm  )

      rand uvm_reg_field use_enc;
      rand uvm_reg_field use_scr;
      rand uvm_reg_field select_tx_am;
      rand uvm_reg_field use_striper;
      rand uvm_reg_field use_am_insert;
      rand uvm_reg_field use_dsc;
      rand uvm_reg_field select_rx_am;
      rand uvm_reg_field use_aligner;
      rand uvm_reg_field use_rx_50g;
      rand uvm_reg_field rx_test_pattern_mode;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          use_enc_value : coverpoint use_enc.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          use_scr_value : coverpoint use_scr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          select_tx_am_value : coverpoint select_tx_am.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          use_striper_value : coverpoint use_striper.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          use_am_insert_value : coverpoint use_am_insert.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          use_dsc_value : coverpoint use_dsc.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          select_rx_am_value : coverpoint select_rx_am.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          use_aligner_value : coverpoint use_aligner.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          use_rx_50g_value : coverpoint use_rx_50g.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_test_pattern_mode_value : coverpoint rx_test_pattern_mode.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_ehip_pcs_modes_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         use_enc = uvm_reg_field::type_id::create("use_enc");
         // configure
         use_enc.configure(
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
         use_scr = uvm_reg_field::type_id::create("use_scr");
         // configure
         use_scr.configure(
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
         select_tx_am = uvm_reg_field::type_id::create("select_tx_am");
         // configure
         select_tx_am.configure(
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
         use_striper = uvm_reg_field::type_id::create("use_striper");
         // configure
         use_striper.configure(
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
         use_am_insert = uvm_reg_field::type_id::create("use_am_insert");
         // configure
         use_am_insert.configure(
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
         use_dsc = uvm_reg_field::type_id::create("use_dsc");
         // configure
         use_dsc.configure(
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
         select_rx_am = uvm_reg_field::type_id::create("select_rx_am");
         // configure
         select_rx_am.configure(
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
         use_aligner = uvm_reg_field::type_id::create("use_aligner");
         // configure
         use_aligner.configure(
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
         use_rx_50g = uvm_reg_field::type_id::create("use_rx_50g");
         // configure
         use_rx_50g.configure(
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
         rx_test_pattern_mode = uvm_reg_field::type_id::create("rx_test_pattern_mode");
         // configure
         rx_test_pattern_mode.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (11),
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
      
endclass : xcvr_reconfig_reg_ehip_pcs_modes_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_ehip_clk_gating_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_ehip_clk_gating_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_ehip_clk_gating_urm  )

      rand uvm_reg_field en_ptpclk;
      rand uvm_reg_field en_pcsclk;
      rand uvm_reg_field en_macclk;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          en_ptpclk_value : coverpoint en_ptpclk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          en_pcsclk_value : coverpoint en_pcsclk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          en_macclk_value : coverpoint en_macclk.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_ehip_clk_gating_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         en_ptpclk = uvm_reg_field::type_id::create("en_ptpclk");
         // configure
         en_ptpclk.configure(
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
         en_pcsclk = uvm_reg_field::type_id::create("en_pcsclk");
         // configure
         en_pcsclk.configure(
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
         en_macclk = uvm_reg_field::type_id::create("en_macclk");
         // configure
         en_macclk.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (2),
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
      
endclass : xcvr_reconfig_reg_ehip_clk_gating_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_config_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_config_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_config_urm  )

      rand uvm_reg_field eio_sys_rst;
      rand uvm_reg_field soft_tx_rst;
      rand uvm_reg_field soft_rx_rst;
      rand uvm_reg_field set_ref_lock;
      rand uvm_reg_field set_data_lock;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eio_sys_rst_value : coverpoint eio_sys_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          soft_tx_rst_value : coverpoint soft_tx_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          soft_rx_rst_value : coverpoint soft_rx_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          set_ref_lock_value : coverpoint set_ref_lock.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          set_data_lock_value : coverpoint set_data_lock.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_config_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eio_sys_rst = uvm_reg_field::type_id::create("eio_sys_rst");
         // configure
         eio_sys_rst.configure(
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
         soft_tx_rst = uvm_reg_field::type_id::create("soft_tx_rst");
         // configure
         soft_tx_rst.configure(
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
         soft_rx_rst = uvm_reg_field::type_id::create("soft_rx_rst");
         // configure
         soft_rx_rst.configure(
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
         set_ref_lock = uvm_reg_field::type_id::create("set_ref_lock");
         // configure
         set_ref_lock.configure(
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
         set_data_lock = uvm_reg_field::type_id::create("set_data_lock");
         // configure
         set_data_lock.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (5),
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
      
endclass : xcvr_reconfig_reg_phy_config_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_pma_sloop_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_pma_sloop_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_pma_sloop_urm  )

      rand uvm_reg_field sloop;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          sloop_value : coverpoint sloop.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_pma_sloop_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         sloop = uvm_reg_field::type_id::create("sloop");
         // configure
         sloop.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (4'b0000),
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
      
endclass : xcvr_reconfig_reg_phy_pma_sloop_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_tx_pll_locked_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_tx_pll_locked_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_tx_pll_locked_urm  )

      rand uvm_reg_field tx_pll_locked;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          tx_pll_locked_value : coverpoint tx_pll_locked.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_tx_pll_locked_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         tx_pll_locked = uvm_reg_field::type_id::create("tx_pll_locked");
         // configure
         tx_pll_locked.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
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
      
endclass : xcvr_reconfig_reg_phy_tx_pll_locked_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_eiofreq_locked_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_eiofreq_locked_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_eiofreq_locked_urm  )

      rand uvm_reg_field eio_freq_lock;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          eio_freq_lock_value : coverpoint eio_freq_lock.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_eiofreq_locked_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         eio_freq_lock = uvm_reg_field::type_id::create("eio_freq_lock");
         // configure
         eio_freq_lock.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (0),
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
      
endclass : xcvr_reconfig_reg_phy_eiofreq_locked_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_tx_corepll_locked_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_tx_corepll_locked_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_tx_corepll_locked_urm  )

      rand uvm_reg_field tx_pcs_ready;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          tx_pcs_ready_value : coverpoint tx_pcs_ready.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_tx_corepll_locked_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         tx_pcs_ready = uvm_reg_field::type_id::create("tx_pcs_ready");
         // configure
         tx_pcs_ready.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_phy_tx_corepll_locked_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_frame_error_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_frame_error_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_frame_error_urm  )

      rand uvm_reg_field frmerr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          frmerr_value : coverpoint frmerr.value {
             bins all[8] = {[20'h0:20'hfffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_frame_error_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         frmerr = uvm_reg_field::type_id::create("frmerr");
         // configure
         frmerr.configure(
         .parent                 ( this ),
         .size                   (20),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_phy_frame_error_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_sclr_frame_error_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_sclr_frame_error_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_sclr_frame_error_urm  )

      rand uvm_reg_field clr_frmerr;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          clr_frmerr_value : coverpoint clr_frmerr.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_sclr_frame_error_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         clr_frmerr = uvm_reg_field::type_id::create("clr_frmerr");
         // configure
         clr_frmerr.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
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
      
endclass : xcvr_reconfig_reg_phy_sclr_frame_error_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_eio_sftreset_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_eio_sftreset_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_eio_sftreset_urm  )

      rand uvm_reg_field rrst;
      rand uvm_reg_field trst;
      rand uvm_reg_field force_tx_pld_deskew_done;
      rand uvm_reg_field force_hip_ready;
      rand uvm_reg_field tx_mac_in_rst;
      rand uvm_reg_field tx_pcs_in_rst;
      rand uvm_reg_field rx_mac_in_rst;
      rand uvm_reg_field rx_pcs_in_rst;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rrst_value : coverpoint rrst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          trst_value : coverpoint trst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          force_tx_pld_deskew_done_value : coverpoint force_tx_pld_deskew_done.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          force_hip_ready_value : coverpoint force_hip_ready.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_mac_in_rst_value : coverpoint tx_mac_in_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          tx_pcs_in_rst_value : coverpoint tx_pcs_in_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_mac_in_rst_value : coverpoint rx_mac_in_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          rx_pcs_in_rst_value : coverpoint rx_pcs_in_rst.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_eio_sftreset_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rrst = uvm_reg_field::type_id::create("rrst");
         // configure
         rrst.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         trst = uvm_reg_field::type_id::create("trst");
         // configure
         trst.configure(
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
         force_tx_pld_deskew_done = uvm_reg_field::type_id::create("force_tx_pld_deskew_done");
         // configure
         force_tx_pld_deskew_done.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (13),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         force_hip_ready = uvm_reg_field::type_id::create("force_hip_ready");
         // configure
         force_hip_ready.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_mac_in_rst = uvm_reg_field::type_id::create("tx_mac_in_rst");
         // configure
         tx_mac_in_rst.configure(
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
         tx_pcs_in_rst = uvm_reg_field::type_id::create("tx_pcs_in_rst");
         // configure
         tx_pcs_in_rst.configure(
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
         rx_mac_in_rst = uvm_reg_field::type_id::create("rx_mac_in_rst");
         // configure
         rx_mac_in_rst.configure(
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
         rx_pcs_in_rst = uvm_reg_field::type_id::create("rx_pcs_in_rst");
         // configure
         rx_pcs_in_rst.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (19),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (1'b1),
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
      
endclass : xcvr_reconfig_reg_phy_eio_sftreset_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_rxpcs_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_rxpcs_status_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_rxpcs_status_urm  )

      rand uvm_reg_field rx_aligned;
      rand uvm_reg_field hi_ber;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rx_aligned_value : coverpoint rx_aligned.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          hi_ber_value : coverpoint hi_ber.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_rxpcs_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rx_aligned = uvm_reg_field::type_id::create("rx_aligned");
         // configure
         rx_aligned.configure(
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
         hi_ber = uvm_reg_field::type_id::create("hi_ber");
         // configure
         hi_ber.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_phy_rxpcs_status_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_pcs_err_inj_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_pcs_err_inj_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_pcs_err_inj_urm  )

      rand uvm_reg_field inj_err;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          inj_err_value : coverpoint inj_err.value {
             bins all[8] = {[20'h0:20'hfffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_pcs_err_inj_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         inj_err = uvm_reg_field::type_id::create("inj_err");
         // configure
         inj_err.configure(
         .parent                 ( this ),
         .size                   (20),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (20'b00000000000000000000),
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
      
endclass : xcvr_reconfig_reg_phy_pcs_err_inj_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_am_lock_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_am_lock_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_am_lock_urm  )

      rand uvm_reg_field am_lock;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          am_lock_value : coverpoint am_lock.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_am_lock_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         am_lock = uvm_reg_field::type_id::create("am_lock");
         // configure
         am_lock.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_phy_am_lock_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_lanes_deskewed_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_lanes_deskewed_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_lanes_deskewed_urm  )

      rand uvm_reg_field dskew_status;
      rand uvm_reg_field dskew_chng;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dskew_status_value : coverpoint dskew_status.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          dskew_chng_value : coverpoint dskew_chng.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_lanes_deskewed_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dskew_status = uvm_reg_field::type_id::create("dskew_status");
         // configure
         dskew_status.configure(
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
         dskew_chng = uvm_reg_field::type_id::create("dskew_chng");
         // configure
         dskew_chng.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (1),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_phy_lanes_deskewed_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_ber_count_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_ber_count_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_ber_count_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_ber_count_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
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
      
endclass : xcvr_reconfig_reg_phy_ber_count_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_pcs_vlane0_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_pcs_vlane0_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_pcs_vlane0_urm  )

      rand uvm_reg_field vlane0;
      rand uvm_reg_field vlane1;
      rand uvm_reg_field vlane2;
      rand uvm_reg_field vlane3;
      rand uvm_reg_field vlane4;
      rand uvm_reg_field vlane5;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          vlane0_value : coverpoint vlane0.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane1_value : coverpoint vlane1.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane2_value : coverpoint vlane2.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane3_value : coverpoint vlane3.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane4_value : coverpoint vlane4.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane5_value : coverpoint vlane5.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_pcs_vlane0_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         vlane0 = uvm_reg_field::type_id::create("vlane0");
         // configure
         vlane0.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane1 = uvm_reg_field::type_id::create("vlane1");
         // configure
         vlane1.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane2 = uvm_reg_field::type_id::create("vlane2");
         // configure
         vlane2.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (10),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane3 = uvm_reg_field::type_id::create("vlane3");
         // configure
         vlane3.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (15),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane4 = uvm_reg_field::type_id::create("vlane4");
         // configure
         vlane4.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (20),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane5 = uvm_reg_field::type_id::create("vlane5");
         // configure
         vlane5.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (25),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
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
      
endclass : xcvr_reconfig_reg_phy_pcs_vlane0_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_pcs_vlane1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_pcs_vlane1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_pcs_vlane1_urm  )

      rand uvm_reg_field vlane6;
      rand uvm_reg_field vlane7;
      rand uvm_reg_field vlane8;
      rand uvm_reg_field vlane9;
      rand uvm_reg_field vlane10;
      rand uvm_reg_field vlane11;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          vlane6_value : coverpoint vlane6.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane7_value : coverpoint vlane7.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane8_value : coverpoint vlane8.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane9_value : coverpoint vlane9.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane10_value : coverpoint vlane10.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane11_value : coverpoint vlane11.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_pcs_vlane1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         vlane6 = uvm_reg_field::type_id::create("vlane6");
         // configure
         vlane6.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane7 = uvm_reg_field::type_id::create("vlane7");
         // configure
         vlane7.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane8 = uvm_reg_field::type_id::create("vlane8");
         // configure
         vlane8.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (10),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane9 = uvm_reg_field::type_id::create("vlane9");
         // configure
         vlane9.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (15),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane10 = uvm_reg_field::type_id::create("vlane10");
         // configure
         vlane10.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (20),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane11 = uvm_reg_field::type_id::create("vlane11");
         // configure
         vlane11.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (25),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
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
      
endclass : xcvr_reconfig_reg_phy_pcs_vlane1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_pcs_vlane2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_pcs_vlane2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_pcs_vlane2_urm  )

      rand uvm_reg_field vlane12;
      rand uvm_reg_field vlane13;
      rand uvm_reg_field vlane14;
      rand uvm_reg_field vlane15;
      rand uvm_reg_field vlane16;
      rand uvm_reg_field vlane17;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          vlane12_value : coverpoint vlane12.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane13_value : coverpoint vlane13.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane14_value : coverpoint vlane14.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane15_value : coverpoint vlane15.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane16_value : coverpoint vlane16.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane17_value : coverpoint vlane17.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_pcs_vlane2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         vlane12 = uvm_reg_field::type_id::create("vlane12");
         // configure
         vlane12.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane13 = uvm_reg_field::type_id::create("vlane13");
         // configure
         vlane13.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane14 = uvm_reg_field::type_id::create("vlane14");
         // configure
         vlane14.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (10),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane15 = uvm_reg_field::type_id::create("vlane15");
         // configure
         vlane15.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (15),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane16 = uvm_reg_field::type_id::create("vlane16");
         // configure
         vlane16.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (20),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane17 = uvm_reg_field::type_id::create("vlane17");
         // configure
         vlane17.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (25),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
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
      
endclass : xcvr_reconfig_reg_phy_pcs_vlane2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_pcs_vlane3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_pcs_vlane3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_pcs_vlane3_urm  )

      rand uvm_reg_field vlane18;
      rand uvm_reg_field vlane19;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          vlane18_value : coverpoint vlane18.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          vlane19_value : coverpoint vlane19.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_pcs_vlane3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         vlane18 = uvm_reg_field::type_id::create("vlane18");
         // configure
         vlane18.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         vlane19 = uvm_reg_field::type_id::create("vlane19");
         // configure
         vlane19.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (5),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (5'b11111),
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
      
endclass : xcvr_reconfig_reg_phy_pcs_vlane3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_refclk_khz_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_refclk_khz_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_refclk_khz_urm  )

      rand uvm_reg_field khz_ref;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          khz_ref_value : coverpoint khz_ref.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_refclk_khz_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         khz_ref = uvm_reg_field::type_id::create("khz_ref");
         // configure
         khz_ref.configure(
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
      
endclass : xcvr_reconfig_reg_phy_refclk_khz_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_recclk_khz_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_recclk_khz_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_recclk_khz_urm  )

      rand uvm_reg_field khz_rx;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          khz_rx_value : coverpoint khz_rx.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_recclk_khz_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         khz_rx = uvm_reg_field::type_id::create("khz_rx");
         // configure
         khz_rx.configure(
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
      
endclass : xcvr_reconfig_reg_phy_recclk_khz_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_txclk_khz_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_txclk_khz_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_txclk_khz_urm  )

      rand uvm_reg_field khz_tx;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          khz_tx_value : coverpoint khz_tx.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_txclk_khz_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         khz_tx = uvm_reg_field::type_id::create("khz_tx");
         // configure
         khz_tx.configure(
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
      
endclass : xcvr_reconfig_reg_phy_txclk_khz_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_tx_pld_conf_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_tx_pld_conf_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_tx_pld_conf_urm  )

      rand uvm_reg_field tx_ehip_mode;
      rand uvm_reg_field tx_fifo_afull;
      rand uvm_reg_field tx_deskew_chan_sel;
      rand uvm_reg_field tx_deskew_clear;
      rand uvm_reg_field sel_50gx2;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          tx_ehip_mode_value : coverpoint tx_ehip_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          tx_fifo_afull_value : coverpoint tx_fifo_afull.value {
             bins all[8] = {[5'h0:5'h1f]};
             illegal_bins bad = default;
          }
          tx_deskew_chan_sel_value : coverpoint tx_deskew_chan_sel.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          tx_deskew_clear_value : coverpoint tx_deskew_clear.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          sel_50gx2_value : coverpoint sel_50gx2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_tx_pld_conf_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         tx_ehip_mode = uvm_reg_field::type_id::create("tx_ehip_mode");
         // configure
         tx_ehip_mode.configure(
         .parent                 ( this ),
         .size                   (3),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (3'b000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         tx_fifo_afull = uvm_reg_field::type_id::create("tx_fifo_afull");
         // configure
         tx_fifo_afull.configure(
         .parent                 ( this ),
         .size                   (5),
         .lsb_pos                (8),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (5'b00000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(1));
         
         // create bitfield  
         tx_deskew_chan_sel = uvm_reg_field::type_id::create("tx_deskew_chan_sel");
         // configure
         tx_deskew_chan_sel.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (16),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_deskew_clear = uvm_reg_field::type_id::create("tx_deskew_clear");
         // configure
         tx_deskew_clear.configure(
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
         sel_50gx2 = uvm_reg_field::type_id::create("sel_50gx2");
         // configure
         sel_50gx2.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
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
      
endclass : xcvr_reconfig_reg_tx_pld_conf_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_tx_pld_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_tx_pld_status_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_tx_pld_status_urm  )

      rand uvm_reg_field tx_dsk_eval_done;
      rand uvm_reg_field tx_dsk_status;
      rand uvm_reg_field tx_dsk_monitor_err;
      rand uvm_reg_field tx_dsk_active_chans;
      rand uvm_reg_field err_tx_avst_fifo_underflow;
      rand uvm_reg_field err_tx_avst_fifo_empty;
      rand uvm_reg_field err_tx_avst_fifo_overflow;
      
      		
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
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          tx_dsk_active_chans_value : coverpoint tx_dsk_active_chans.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          err_tx_avst_fifo_underflow_value : coverpoint err_tx_avst_fifo_underflow.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          err_tx_avst_fifo_empty_value : coverpoint err_tx_avst_fifo_empty.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          err_tx_avst_fifo_overflow_value : coverpoint err_tx_avst_fifo_overflow.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_tx_pld_status_urm");
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
         .size                   (6),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         tx_dsk_active_chans = uvm_reg_field::type_id::create("tx_dsk_active_chans");
         // configure
         tx_dsk_active_chans.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (16),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         err_tx_avst_fifo_underflow = uvm_reg_field::type_id::create("err_tx_avst_fifo_underflow");
         // configure
         err_tx_avst_fifo_underflow.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (22),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b0),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         err_tx_avst_fifo_empty = uvm_reg_field::type_id::create("err_tx_avst_fifo_empty");
         // configure
         err_tx_avst_fifo_empty.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (23),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (1'b1),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         err_tx_avst_fifo_overflow = uvm_reg_field::type_id::create("err_tx_avst_fifo_overflow");
         // configure
         err_tx_avst_fifo_overflow.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (24),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_tx_pld_status_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_phy_rxpma_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_phy_rxpma_status_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_phy_rxpma_status_urm  )

      rand uvm_reg_field rd_numdata;
      rand uvm_reg_field err_overflow;
      rand uvm_reg_field err_skew;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rd_numdata_value : coverpoint rd_numdata.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          err_overflow_value : coverpoint err_overflow.value {
             bins all[8] = {[4'h0:4'hf]};
             illegal_bins bad = default;
          }
          err_skew_value : coverpoint err_skew.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_phy_rxpma_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rd_numdata = uvm_reg_field::type_id::create("rd_numdata");
         // configure
         rd_numdata.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (8),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         err_overflow = uvm_reg_field::type_id::create("err_overflow");
         // configure
         err_overflow.configure(
         .parent                 ( this ),
         .size                   (4),
         .lsb_pos                (12),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (4'b0000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         err_skew = uvm_reg_field::type_id::create("err_skew");
         // configure
         err_skew.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (16),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_phy_rxpma_status_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_rx_pld_conf_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_rx_pld_conf_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_rx_pld_conf_urm  )

      rand uvm_reg_field rx_ehip_mode;
      rand uvm_reg_field use_lane_ptp;
      rand uvm_reg_field sel_50gx2;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          rx_ehip_mode_value : coverpoint rx_ehip_mode.value {
             bins all[8] = {[3'h0:3'h7]};
             illegal_bins bad = default;
          }
          use_lane_ptp_value : coverpoint use_lane_ptp.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
          sel_50gx2_value : coverpoint sel_50gx2.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_rx_pld_conf_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         rx_ehip_mode = uvm_reg_field::type_id::create("rx_ehip_mode");
         // configure
         rx_ehip_mode.configure(
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
         use_lane_ptp = uvm_reg_field::type_id::create("use_lane_ptp");
         // configure
         use_lane_ptp.configure(
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
         sel_50gx2 = uvm_reg_field::type_id::create("sel_50gx2");
         // configure
         sel_50gx2.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (4),
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
      
endclass : xcvr_reconfig_reg_rx_pld_conf_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_rx_pld_status_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_rx_pld_status_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_rx_pld_status_urm  )

      rand uvm_reg_field buf_err_50g;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          buf_err_50g_value : coverpoint buf_err_50g.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_rx_pld_status_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         buf_err_50g = uvm_reg_field::type_id::create("buf_err_50g");
         // configure
         buf_err_50g.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (0),
         .access                 ("RO"),
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
      
endclass : xcvr_reconfig_reg_rx_pld_status_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_rxpcs_conf_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_rxpcs_conf_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_rxpcs_conf_urm  )

      rand uvm_reg_field am_interval;
      rand uvm_reg_field rx_pcs_max_skew;
      rand uvm_reg_field use_hi_ber_monitor;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          am_interval_value : coverpoint am_interval.value {
             bins all[8] = {[14'h0:14'h3fff]};
             illegal_bins bad = default;
          }
          rx_pcs_max_skew_value : coverpoint rx_pcs_max_skew.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          use_hi_ber_monitor_value : coverpoint use_hi_ber_monitor.value {
             bins all[2] = {[1'h0:1'h1]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_rxpcs_conf_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         am_interval = uvm_reg_field::type_id::create("am_interval");
         // configure
         am_interval.configure(
         .parent                 ( this ),
         .size                   (14),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (14'b11111111111111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         rx_pcs_max_skew = uvm_reg_field::type_id::create("rx_pcs_max_skew");
         // configure
         rx_pcs_max_skew.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (14),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (6'b111111),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         use_hi_ber_monitor = uvm_reg_field::type_id::create("use_hi_ber_monitor");
         // configure
         use_hi_ber_monitor.configure(
         .parent                 ( this ),
         .size                   (1),
         .lsb_pos                (20),
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
      
endclass : xcvr_reconfig_reg_rxpcs_conf_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_1_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_2_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_3_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_4_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_4_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_4_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_5_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_5_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_5_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_5_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_5_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_6_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_6_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_6_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_6_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_6_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_7_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_7_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_7_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_7_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_7_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_8_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_8_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_8_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_8_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_8_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_9_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_9_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_9_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_9_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_9_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_10_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_10_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_10_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_10_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_10_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_11_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_11_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_11_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_11_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_11_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_12_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_12_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_12_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_12_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_12_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_13_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_13_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_13_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_13_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_13_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_14_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_14_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_14_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_14_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_14_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_15_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_15_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_15_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_15_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_15_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_16_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_16_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_16_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_16_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_16_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_17_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_17_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_17_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_17_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_17_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_18_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_18_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_18_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_18_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_18_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_bip_counter_19_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_bip_counter_19_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_bip_counter_19_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[16'h0:16'hffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_bip_counter_19_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (16),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
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
      
endclass : xcvr_reconfig_reg_bip_counter_19_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_am_encoding_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_am_encoding_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_am_encoding_urm  )

      rand uvm_reg_field am;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          am_value : coverpoint am.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_am_encoding_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         am = uvm_reg_field::type_id::create("am");
         // configure
         am.configure(
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
      
endclass : xcvr_reconfig_reg_am_encoding_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_am_encoding_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_am_encoding_1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_am_encoding_1_urm  )

      rand uvm_reg_field am;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          am_value : coverpoint am.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_am_encoding_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         am = uvm_reg_field::type_id::create("am");
         // configure
         am.configure(
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
      
endclass : xcvr_reconfig_reg_am_encoding_1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_am_encoding_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_am_encoding_2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_am_encoding_2_urm  )

      rand uvm_reg_field am;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          am_value : coverpoint am.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_am_encoding_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         am = uvm_reg_field::type_id::create("am");
         // configure
         am.configure(
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
      
endclass : xcvr_reconfig_reg_am_encoding_2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_am_encoding_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_am_encoding_3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_am_encoding_3_urm  )

      rand uvm_reg_field am;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          am_value : coverpoint am.value {
             bins all[8] = {[24'h0:24'hffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_am_encoding_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         am = uvm_reg_field::type_id::create("am");
         // configure
         am.configure(
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
      
endclass : xcvr_reconfig_reg_am_encoding_3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_xus_timer_window_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_xus_timer_window_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_xus_timer_window_urm  )

      rand uvm_reg_field cycles;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          cycles_value : coverpoint cycles.value {
             bins all[8] = {[21'h0:21'h1fffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_xus_timer_window_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         cycles = uvm_reg_field::type_id::create("cycles");
         // configure
         cycles.configure(
         .parent                 ( this ),
         .size                   (21),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (21'b000110001001011000111),
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
      
endclass : xcvr_reconfig_reg_xus_timer_window_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_ber_invalid_count_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_ber_invalid_count_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_ber_invalid_count_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[7'h0:7'h7f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_ber_invalid_count_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
         .parent                 ( this ),
         .size                   (7),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (7'b1100001),
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
      
endclass : xcvr_reconfig_reg_ber_invalid_count_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_err_block_cnt_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_err_block_cnt_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_err_block_cnt_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_err_block_cnt_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
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
      
endclass : xcvr_reconfig_reg_err_block_cnt_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_rx_pcs_int_err_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_rx_pcs_int_err_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_rx_pcs_int_err_urm  )

      rand uvm_reg_field vector;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          vector_value : coverpoint vector.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_rx_pcs_int_err_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         vector = uvm_reg_field::type_id::create("vector");
         // configure
         vector.configure(
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
      
endclass : xcvr_reconfig_reg_rx_pcs_int_err_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_rx_pcs_int_err_mask_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_rx_pcs_int_err_mask_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_rx_pcs_int_err_mask_urm  )

      rand uvm_reg_field vector;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          vector_value : coverpoint vector.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_rx_pcs_int_err_mask_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         vector = uvm_reg_field::type_id::create("vector");
         // configure
         vector.configure(
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
      
endclass : xcvr_reconfig_reg_rx_pcs_int_err_mask_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dsk_depth_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dsk_depth_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dsk_depth_urm  )

      rand uvm_reg_field depth0;
      rand uvm_reg_field depth1;
      rand uvm_reg_field depth2;
      rand uvm_reg_field depth3;
      rand uvm_reg_field depth4;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          depth0_value : coverpoint depth0.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth1_value : coverpoint depth1.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth2_value : coverpoint depth2.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth3_value : coverpoint depth3.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth4_value : coverpoint depth4.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dsk_depth_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         depth0 = uvm_reg_field::type_id::create("depth0");
         // configure
         depth0.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth1 = uvm_reg_field::type_id::create("depth1");
         // configure
         depth1.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth2 = uvm_reg_field::type_id::create("depth2");
         // configure
         depth2.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (12),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth3 = uvm_reg_field::type_id::create("depth3");
         // configure
         depth3.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (18),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth4 = uvm_reg_field::type_id::create("depth4");
         // configure
         depth4.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (24),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
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
      
endclass : xcvr_reconfig_reg_dsk_depth_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dsk_depth_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dsk_depth_1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dsk_depth_1_urm  )

      rand uvm_reg_field depth0;
      rand uvm_reg_field depth1;
      rand uvm_reg_field depth2;
      rand uvm_reg_field depth3;
      rand uvm_reg_field depth4;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          depth0_value : coverpoint depth0.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth1_value : coverpoint depth1.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth2_value : coverpoint depth2.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth3_value : coverpoint depth3.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth4_value : coverpoint depth4.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dsk_depth_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         depth0 = uvm_reg_field::type_id::create("depth0");
         // configure
         depth0.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth1 = uvm_reg_field::type_id::create("depth1");
         // configure
         depth1.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth2 = uvm_reg_field::type_id::create("depth2");
         // configure
         depth2.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (12),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth3 = uvm_reg_field::type_id::create("depth3");
         // configure
         depth3.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (18),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth4 = uvm_reg_field::type_id::create("depth4");
         // configure
         depth4.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (24),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
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
      
endclass : xcvr_reconfig_reg_dsk_depth_1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dsk_depth_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dsk_depth_2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dsk_depth_2_urm  )

      rand uvm_reg_field depth0;
      rand uvm_reg_field depth1;
      rand uvm_reg_field depth2;
      rand uvm_reg_field depth3;
      rand uvm_reg_field depth4;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          depth0_value : coverpoint depth0.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth1_value : coverpoint depth1.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth2_value : coverpoint depth2.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth3_value : coverpoint depth3.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth4_value : coverpoint depth4.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dsk_depth_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         depth0 = uvm_reg_field::type_id::create("depth0");
         // configure
         depth0.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth1 = uvm_reg_field::type_id::create("depth1");
         // configure
         depth1.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth2 = uvm_reg_field::type_id::create("depth2");
         // configure
         depth2.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (12),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth3 = uvm_reg_field::type_id::create("depth3");
         // configure
         depth3.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (18),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth4 = uvm_reg_field::type_id::create("depth4");
         // configure
         depth4.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (24),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
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
      
endclass : xcvr_reconfig_reg_dsk_depth_2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dsk_depth_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dsk_depth_3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dsk_depth_3_urm  )

      rand uvm_reg_field depth0;
      rand uvm_reg_field depth1;
      rand uvm_reg_field depth2;
      rand uvm_reg_field depth3;
      rand uvm_reg_field depth4;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          depth0_value : coverpoint depth0.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth1_value : coverpoint depth1.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth2_value : coverpoint depth2.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth3_value : coverpoint depth3.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
          depth4_value : coverpoint depth4.value {
             bins all[8] = {[6'h0:6'h3f]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dsk_depth_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         depth0 = uvm_reg_field::type_id::create("depth0");
         // configure
         depth0.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (0),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth1 = uvm_reg_field::type_id::create("depth1");
         // configure
         depth1.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (6),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth2 = uvm_reg_field::type_id::create("depth2");
         // configure
         depth2.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (12),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth3 = uvm_reg_field::type_id::create("depth3");
         // configure
         depth3.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (18),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
         .has_reset              (1),
         .is_rand                (1),
         .individually_accessible(0));
         
         // create bitfield  
         depth4 = uvm_reg_field::type_id::create("depth4");
         // configure
         depth4.configure(
         .parent                 ( this ),
         .size                   (6),
         .lsb_pos                (24),
         .access                 ("RO"),
         .volatile               (1),
         .reset                  (6'b000000),
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
      
endclass : xcvr_reconfig_reg_dsk_depth_3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm  )

      rand uvm_reg_field count;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          count_value : coverpoint count.value {
             bins all[8] = {[32'h0:32'hffffffff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         count = uvm_reg_field::type_id::create("count");
         // configure
         count.configure(
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
      
endclass : xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dprio_control_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dprio_control_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dprio_control_urm  )

      rand uvm_reg_field dprio;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dprio_value : coverpoint dprio.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dprio_control_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dprio = uvm_reg_field::type_id::create("dprio");
         // configure
         dprio.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_reg_dprio_control_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dprio_control_1_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dprio_control_1_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dprio_control_1_urm  )

      rand uvm_reg_field dprio;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dprio_value : coverpoint dprio.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dprio_control_1_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dprio = uvm_reg_field::type_id::create("dprio");
         // configure
         dprio.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_reg_dprio_control_1_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dprio_control_2_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dprio_control_2_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dprio_control_2_urm  )

      rand uvm_reg_field dprio;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dprio_value : coverpoint dprio.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dprio_control_2_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dprio = uvm_reg_field::type_id::create("dprio");
         // configure
         dprio.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_reg_dprio_control_2_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dprio_control_3_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dprio_control_3_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dprio_control_3_urm  )

      rand uvm_reg_field dprio;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dprio_value : coverpoint dprio.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dprio_control_3_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dprio = uvm_reg_field::type_id::create("dprio");
         // configure
         dprio.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_reg_dprio_control_3_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dprio_control_4_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dprio_control_4_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dprio_control_4_urm  )

      rand uvm_reg_field dprio;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dprio_value : coverpoint dprio.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dprio_control_4_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dprio = uvm_reg_field::type_id::create("dprio");
         // configure
         dprio.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_reg_dprio_control_4_urm

/*-----------------------------------------------------------------------------------------------
---  xcvr_reconfig_reg_dprio_control_5_urm Register Definition
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_reg_dprio_control_5_urm  extends uvm_reg;

      `uvm_object_utils(xcvr_reconfig_reg_dprio_control_5_urm  )

      rand uvm_reg_field dprio;
      
      		
      covergroup cg_field_values ();
          option.per_instance = 1;
          dprio_value : coverpoint dprio.value {
             bins all[8] = {[8'h0:8'hff]};
             illegal_bins bad = default;
          }
      endgroup : cg_field_values

      // Constructor
      function new(string name = "xcvr_reconfig_reg_dprio_control_5_urm");
         super.new(name,32,build_coverage(UVM_CVR_FIELD_VALS));
            if (has_coverage(UVM_CVR_FIELD_VALS)) begin  
         cg_field_values = new();
         cg_field_values.set_inst_name({get_full_name(), ".cg_field_values"});
         end
      
      endfunction : new

      // Build
      virtual function void build();
         // create bitfield  
         dprio = uvm_reg_field::type_id::create("dprio");
         // configure
         dprio.configure(
         .parent                 ( this ),
         .size                   (8),
         .lsb_pos                (0),
         .access                 ("RW"),
         .volatile               (0),
         .reset                  (8'b00000000),
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
      
endclass : xcvr_reconfig_reg_dprio_control_5_urm


/*-----------------------------------------------------------------------------------------------
--- xcvr_reconfig Block Definition : 
-----------------------------------------------------------------------------------------------*/
class xcvr_reconfig_urm  extends  uvm_reg_block;

       `uvm_object_utils(xcvr_reconfig_urm  )

      rand xcvr_reconfig_reg_xcvrif_rst_ctrl_urm  xcvrif_rst_ctrl;
      rand xcvr_reconfig_reg_xcvrif_ctrl0_urm  xcvrif_ctrl0;
      rand xcvr_reconfig_reg_xcvrif_ctrl1_urm  xcvrif_ctrl1;
      rand xcvr_reconfig_reg_xcvrif_gb_ctrl_urm  xcvrif_gb_ctrl;
      rand xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm  xcvrif_rxfifo_threshold;
      rand xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm  xcvrif_txfifo_threshold;
      rand xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm  xcvrif_tx_reset_val0;
      rand xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm  xcvrif_tx_reset_val1;
      rand xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm  xcvrif_tx_reset_val2;
      rand xcvr_reconfig_reg_xcvrif_rxbit_stat_urm  xcvrif_rxbit_stat;
      rand xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm  xcvrif_tx_gbx_stat;
      rand xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm  xcvrif_rx_gbx_stat;
      rand xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm  xcvrif_det_lat_cfg;
      rand xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm  xcvrif_dcc_ctrl;
      rand xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm  xcvrif_dcc_csr0;
      rand xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm  xcvrif_dcc_csr1;
      rand xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm  xcvrif_dcc_stat;
      rand xcvr_reconfig_reg_xcvrif_test_ctrl_urm  xcvrif_test_ctrl;
      rand xcvr_reconfig_reg_interrupt_core_to_cntl_urm  interrupt_core_to_cntl;
      rand xcvr_reconfig_reg_interrupt_if_reg_urm  interrupt_if_reg;
      rand xcvr_reconfig_reg_interrupt_if_rcv_data_urm  interrupt_if_rcv_data;
      rand xcvr_reconfig_reg_interrupt_core_status_urm  interrupt_core_status;
      rand xcvr_reconfig_reg_interrupt_if_ctrl_urm  interrupt_if_ctrl;
      rand xcvr_reconfig_reg_interrupt_seq_enable_urm  interrupt_seq_enable;
      rand xcvr_reconfig_reg_interrupt_seq_0_urm  interrupt_seq_0;
      rand xcvr_reconfig_reg_interrupt_seq_1_urm  interrupt_seq_1;
      rand xcvr_reconfig_reg_interrupt_seq_2_urm  interrupt_seq_2;
      rand xcvr_reconfig_reg_interrupt_seq_3_urm  interrupt_seq_3;
      rand xcvr_reconfig_reg_interrupt_seq_4_urm  interrupt_seq_4;
      rand xcvr_reconfig_reg_interrupt_seq_5_urm  interrupt_seq_5;
      rand xcvr_reconfig_reg_interrupt_seq_6_urm  interrupt_seq_6;
      rand xcvr_reconfig_reg_interrupt_seq_7_urm  interrupt_seq_7;
      rand xcvr_reconfig_reg_interrupt_seq_8_urm  interrupt_seq_8;
      rand xcvr_reconfig_reg_interrupt_seq_9_urm  interrupt_seq_9;
      rand xcvr_reconfig_reg_interrupt_seq_10_urm  interrupt_seq_10;
      rand xcvr_reconfig_reg_interrupt_seq_11_urm  interrupt_seq_11;
      rand xcvr_reconfig_reg_interrupt_seq_12_urm  interrupt_seq_12;
      rand xcvr_reconfig_reg_interrupt_seq_13_urm  interrupt_seq_13;
      rand xcvr_reconfig_reg_interrupt_seq_14_urm  interrupt_seq_14;
      rand xcvr_reconfig_reg_interrupt_seq_15_urm  interrupt_seq_15;
      rand xcvr_reconfig_reg_interrupt_seq_16_urm  interrupt_seq_16;
      rand xcvr_reconfig_reg_interrupt_seq_17_urm  interrupt_seq_17;
      rand xcvr_reconfig_reg_interrupt_seq_18_urm  interrupt_seq_18;
      rand xcvr_reconfig_reg_interrupt_seq_19_urm  interrupt_seq_19;
      rand xcvr_reconfig_reg_interrupt_seq_serdes_en_urm  interrupt_seq_serdes_en;
      rand xcvr_reconfig_reg_xcvr_refclk_sel_urm  xcvr_refclk_sel;
      rand xcvr_reconfig_reg_xcvr_hwdec_urm  xcvr_hwdec;
      rand xcvr_reconfig_reg_r_usr_outbox_urm  r_usr_outbox;
      rand xcvr_reconfig_reg_r_usr_inbox_urm  r_usr_inbox;
      rand xcvr_reconfig_tx_chnl_dprio0_urm  r_dprio0_tx;
      rand xcvr_reconfig_tx_chnl_dprio1_urm  r_dprio1_tx;
      rand xcvr_reconfig_tx_chnl_dprio2_urm  r_dprio2_tx;
      rand xcvr_reconfig_tx_chnl_dprio3_urm  r_dprio3_tx;
      rand xcvr_reconfig_rx_chnl_dprio0_urm  r_dprio0_rx;
      rand xcvr_reconfig_rx_chnl_dprio1_urm  r_dprio1_rx;
      rand xcvr_reconfig_rx_chnl_dprio2_urm  r_dprio2_rx;
      rand xcvr_reconfig_rx_chnl_dprio3_urm  r_dprio3_rx;
      rand xcvr_reconfig_rx_chnl_dprio4_urm  r_dprio4_rx;
      rand xcvr_reconfig_dprio_status_urm  r_dprio_status;
      rand xcvr_reconfig_aib_dprio_ctrl0_urm  r_aibdprio0;
      rand xcvr_reconfig_aib_dprio_ctrl1_urm  r_aibdprio1;
      rand xcvr_reconfig_sr_dprio_ctrl_urm  r_dprio_sr;
      rand xcvr_reconfig_avmm1_dprio_ctrl_urm  r_dprio_avmm1;
      rand xcvr_reconfig_avmm2_dprio_ctrl_urm  r_dprio_avmm2;
      rand xcvr_reconfig_spare_urm  r_spare0;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm  hssi_pldadapt_tx_300;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm  hssi_pldadapt_tx_304;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm  hssi_pldadapt_tx_308;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm  hssi_pldadapt_tx_30C;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm  hssi_pldadapt_tx_310;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm  hssi_pldadapt_tx_314;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm  hssi_pldadapt_tx_31C;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm  hssi_pldadapt_tx_320;
      rand xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm  hssi_pldadapt_tx_324;
      rand xcvr_reconfig_reg_hssi_aibnd_32B_urm  hssi_aibnd_32B;
      rand xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm  hssi_ppt_rx_chnl_330;
      rand xcvr_reconfig_reg_phy_revid_urm  phy_revid;
      rand xcvr_reconfig_reg_phy_scratch_register_urm  phy_scratch;
      rand xcvr_reconfig_reg_phy_name_urm  phy_name_0;
      rand xcvr_reconfig_reg_phy_name_1_urm  phy_name_1;
      rand xcvr_reconfig_reg_phy_name_2_urm  phy_name_2;
      rand xcvr_reconfig_reg_ehip_mode_muxes_urm  phy_ehip_mode_muxes;
      rand xcvr_reconfig_reg_ehip_pcs_modes_urm  phy_ehip_pcs_modes;
      rand xcvr_reconfig_reg_ehip_clk_gating_urm  phy_ehip_clock_gating;
      rand xcvr_reconfig_reg_phy_config_urm  phy_config;
      rand xcvr_reconfig_reg_phy_pma_sloop_urm  phy_pma_sloop;
      rand xcvr_reconfig_reg_phy_tx_pll_locked_urm  phy_tx_pll_locked;
      rand xcvr_reconfig_reg_phy_eiofreq_locked_urm  phy_eiofreq_locked;
      rand xcvr_reconfig_reg_phy_tx_corepll_locked_urm  phy_tx_corepll_locked;
      rand xcvr_reconfig_reg_phy_frame_error_urm  phy_frame_error;
      rand xcvr_reconfig_reg_phy_sclr_frame_error_urm  phy_sclr_frame_error;
      rand xcvr_reconfig_reg_phy_eio_sftreset_urm  phy_eio_sftreset;
      rand xcvr_reconfig_reg_phy_rxpcs_status_urm  phy_rxpcs_status;
      rand xcvr_reconfig_reg_phy_pcs_err_inj_urm  err_inj;
      rand xcvr_reconfig_reg_phy_am_lock_urm  am_lock;
      rand xcvr_reconfig_reg_phy_lanes_deskewed_urm  lanes_deskewed;
      rand xcvr_reconfig_reg_phy_ber_count_urm  ber_count;
      rand xcvr_reconfig_reg_phy_pcs_vlane0_urm  pcs_vlane_0;
      rand xcvr_reconfig_reg_phy_pcs_vlane1_urm  pcs_vlane_1;
      rand xcvr_reconfig_reg_phy_pcs_vlane2_urm  pcs_vlane_2;
      rand xcvr_reconfig_reg_phy_pcs_vlane3_urm  pcs_vlane_3;
      rand xcvr_reconfig_reg_phy_refclk_khz_urm  phy_refclk_khz;
      rand xcvr_reconfig_reg_phy_recclk_khz_urm  phy_recclk_khz;
      rand xcvr_reconfig_reg_phy_txclk_khz_urm  phy_txclk_khz;
      rand xcvr_reconfig_reg_tx_pld_conf_urm  tx_pld_conf;
      rand xcvr_reconfig_reg_tx_pld_status_urm  tx_pld_status;
      rand xcvr_reconfig_reg_phy_rxpma_status_urm  phy_rxpma_status;
      rand xcvr_reconfig_reg_rx_pld_conf_urm  rx_pld_conf;
      rand xcvr_reconfig_reg_rx_pld_status_urm  rx_pld_status;
      rand xcvr_reconfig_reg_rxpcs_conf_urm  rxpcs_conf;
      rand xcvr_reconfig_reg_bip_counter_urm  bip_counter_0;
      rand xcvr_reconfig_reg_bip_counter_1_urm  bip_counter_1;
      rand xcvr_reconfig_reg_bip_counter_2_urm  bip_counter_2;
      rand xcvr_reconfig_reg_bip_counter_3_urm  bip_counter_3;
      rand xcvr_reconfig_reg_bip_counter_4_urm  bip_counter_4;
      rand xcvr_reconfig_reg_bip_counter_5_urm  bip_counter_5;
      rand xcvr_reconfig_reg_bip_counter_6_urm  bip_counter_6;
      rand xcvr_reconfig_reg_bip_counter_7_urm  bip_counter_7;
      rand xcvr_reconfig_reg_bip_counter_8_urm  bip_counter_8;
      rand xcvr_reconfig_reg_bip_counter_9_urm  bip_counter_9;
      rand xcvr_reconfig_reg_bip_counter_10_urm  bip_counter_10;
      rand xcvr_reconfig_reg_bip_counter_11_urm  bip_counter_11;
      rand xcvr_reconfig_reg_bip_counter_12_urm  bip_counter_12;
      rand xcvr_reconfig_reg_bip_counter_13_urm  bip_counter_13;
      rand xcvr_reconfig_reg_bip_counter_14_urm  bip_counter_14;
      rand xcvr_reconfig_reg_bip_counter_15_urm  bip_counter_15;
      rand xcvr_reconfig_reg_bip_counter_16_urm  bip_counter_16;
      rand xcvr_reconfig_reg_bip_counter_17_urm  bip_counter_17;
      rand xcvr_reconfig_reg_bip_counter_18_urm  bip_counter_18;
      rand xcvr_reconfig_reg_bip_counter_19_urm  bip_counter_19;
      rand xcvr_reconfig_reg_am_encoding_urm  am_encoding_0;
      rand xcvr_reconfig_reg_am_encoding_1_urm  am_encoding_1;
      rand xcvr_reconfig_reg_am_encoding_2_urm  am_encoding_2;
      rand xcvr_reconfig_reg_am_encoding_3_urm  am_encoding_3;
      rand xcvr_reconfig_reg_xus_timer_window_urm  xus_timer_window;
      rand xcvr_reconfig_reg_ber_invalid_count_urm  ber_invalid_count;
      rand xcvr_reconfig_reg_err_block_cnt_urm  err_block_cnt;
      rand xcvr_reconfig_reg_rx_pcs_int_err_urm  rx_pcs_int_err;
      rand xcvr_reconfig_reg_rx_pcs_int_err_mask_urm  rx_pcs_int_err_mask;
      rand xcvr_reconfig_reg_dsk_depth_urm  dsk_depth_0;
      rand xcvr_reconfig_reg_dsk_depth_1_urm  dsk_depth_1;
      rand xcvr_reconfig_reg_dsk_depth_2_urm  dsk_depth_2;
      rand xcvr_reconfig_reg_dsk_depth_3_urm  dsk_depth_3;
      rand xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm  rx_pcs_test_err_cnt;
      rand xcvr_reconfig_reg_dprio_control_urm  dprio_control_0;
      rand xcvr_reconfig_reg_dprio_control_1_urm  dprio_control_1;
      rand xcvr_reconfig_reg_dprio_control_2_urm  dprio_control_2;
      rand xcvr_reconfig_reg_dprio_control_3_urm  dprio_control_3;
      rand xcvr_reconfig_reg_dprio_control_4_urm  dprio_control_4;
      rand xcvr_reconfig_reg_dprio_control_5_urm  dprio_control_5;
      
      // uvm_reg_map _map;

      //Constructor
      function new(string name = "xcvr_reconfig_urm");
         super.new(name,build_coverage(UVM_CVR_ALL));
         endfunction : new

      //Build
      virtual function void build();
         
         // Create registers
         xcvrif_rst_ctrl = xcvr_reconfig_reg_xcvrif_rst_ctrl_urm::type_id::create("xcvrif_rst_ctrl");
         xcvrif_rst_ctrl.configure(this,null,"");
         xcvrif_rst_ctrl.build();
         // hdl path
         xcvrif_rst_ctrl.add_hdl_path_slice("xcvrif_rst_ctrl_cfg_sft_rst_tx_n",0,1);
         xcvrif_rst_ctrl.add_hdl_path_slice("xcvrif_rst_ctrl_cfg_sft_rst_rx_n",1,1);
         
         // Create registers
         xcvrif_ctrl0 = xcvr_reconfig_reg_xcvrif_ctrl0_urm::type_id::create("xcvrif_ctrl0");
         xcvrif_ctrl0.configure(this,null,"");
         xcvrif_ctrl0.build();
         // hdl path
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_tx",0,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_full_tx",1,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_tx_data_in_sel",2,3);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_tx_clk_out_sel",5,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_tx_clk_dp_sel",6,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_tx_adapt_order_sel",7,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_tx_ml_sel",8,2);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_tx_gbx",10,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_tx_datapath",11,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_pcs_d2_tx",12,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_fec_d2_tx",13,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_ehip_d2_tx",14,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_direct_tx",15,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_rx",16,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_full_rx",17,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_half_rx",18,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_div66_rx",19,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_rx_adapt_order_sel",20,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_rx_adapter_sel",21,2);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_rx_revbitorder",23,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_rx_c_revbitorder",24,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_fifo_rd_rx",25,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_fifo_rx",26,1);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_rx_ml_sel",27,2);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_rx_fifo_clk_sel",29,2);
         xcvrif_ctrl0.add_hdl_path_slice("xcvrif_ctrl0_cfg_clk_en_rx_adapt",31,1);
         
         // Create registers
         xcvrif_ctrl1 = xcvr_reconfig_reg_xcvrif_ctrl1_urm::type_id::create("xcvrif_ctrl1");
         xcvrif_ctrl1.configure(this,null,"");
         xcvrif_ctrl1.build();
         // hdl path
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_revbitorder",0,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_c_revbitorder",1,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_tx_bitslip",3,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_sh_location",5,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_tx_dskew_ml_sel",8,2);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_tx_deskew_sts_i",10,3);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_rx_tag_sel",13,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_rx_rden_sel",14,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_en_tx_deskew",16,3);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_rx_bitslip",21,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_rx_pcs_data_sel",22,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_rx_sh_location",27,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_xcvrif_bonding_slv_config",28,1);
         xcvrif_ctrl1.add_hdl_path_slice("xcvrif_ctrl1_cfg_rst_en_rx",29,3);
         
         // Create registers
         xcvrif_gb_ctrl = xcvr_reconfig_reg_xcvrif_gb_ctrl_urm::type_id::create("xcvrif_gb_ctrl");
         xcvrif_gb_ctrl.configure(this,null,"");
         xcvrif_gb_ctrl.build();
         // hdl path
         xcvrif_gb_ctrl.add_hdl_path_slice("xcvrif_gb_ctrl_cfg_gb_idwidth",4,3);
         xcvrif_gb_ctrl.add_hdl_path_slice("xcvrif_gb_ctrl_cfg_gb_odwidth",8,2);
         xcvrif_gb_ctrl.add_hdl_path_slice("xcvrif_gb_ctrl_cfg_rx_gb_idwidth",12,2);
         xcvrif_gb_ctrl.add_hdl_path_slice("xcvrif_gb_ctrl_cfg_rx_gb_odwidth",16,3);
         
         // Create registers
         xcvrif_rxfifo_threshold = xcvr_reconfig_reg_xcvrif_rxfifo_threshold_urm::type_id::create("xcvrif_rxfifo_threshold");
         xcvrif_rxfifo_threshold.configure(this,null,"");
         xcvrif_rxfifo_threshold.build();
         // hdl path
         xcvrif_rxfifo_threshold.add_hdl_path_slice("xcvrif_rxfifo_threshold_cfg_rxfifo_e_thld",0,5);
         xcvrif_rxfifo_threshold.add_hdl_path_slice("xcvrif_rxfifo_threshold_cfg_rxfifo_ae_thld",6,5);
         xcvrif_rxfifo_threshold.add_hdl_path_slice("xcvrif_rxfifo_threshold_cfg_rxfifo_f_thld",12,5);
         xcvrif_rxfifo_threshold.add_hdl_path_slice("xcvrif_rxfifo_threshold_cfg_rxfifo_af_thld",18,5);
         xcvrif_rxfifo_threshold.add_hdl_path_slice("xcvrif_rxfifo_threshold_cfg_rxfifo_rd_empty",30,1);
         xcvrif_rxfifo_threshold.add_hdl_path_slice("xcvrif_rxfifo_threshold_cfg_rxfifo_wr_full",31,1);
         
         // Create registers
         xcvrif_txfifo_threshold = xcvr_reconfig_reg_xcvrif_txfifo_threshold_urm::type_id::create("xcvrif_txfifo_threshold");
         xcvrif_txfifo_threshold.configure(this,null,"");
         xcvrif_txfifo_threshold.build();
         // hdl path
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_e_thld",0,5);
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_ae_thld",6,5);
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_f_thld",12,5);
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_af_thld",18,5);
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_ph_comp",28,2);
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_wr_full",30,1);
         xcvrif_txfifo_threshold.add_hdl_path_slice("xcvrif_txfifo_threshold_cfg_txfifo_rd_empty",31,1);
         
         // Create registers
         xcvrif_tx_reset_val0 = xcvr_reconfig_reg_xcvrif_tx_reset_val0_urm::type_id::create("xcvrif_tx_reset_val0");
         xcvrif_tx_reset_val0.configure(this,null,"");
         xcvrif_tx_reset_val0.build();
         // hdl path
         xcvrif_tx_reset_val0.add_hdl_path_slice("xcvrif_tx_reset_val0_cfg_tx_reset_val_31_0",0,32);
         
         // Create registers
         xcvrif_tx_reset_val1 = xcvr_reconfig_reg_xcvrif_tx_reset_val1_urm::type_id::create("xcvrif_tx_reset_val1");
         xcvrif_tx_reset_val1.configure(this,null,"");
         xcvrif_tx_reset_val1.build();
         // hdl path
         xcvrif_tx_reset_val1.add_hdl_path_slice("xcvrif_tx_reset_val1_cfg_tx_reset_val_63_32",0,32);
         
         // Create registers
         xcvrif_tx_reset_val2 = xcvr_reconfig_reg_xcvrif_tx_reset_val2_urm::type_id::create("xcvrif_tx_reset_val2");
         xcvrif_tx_reset_val2.configure(this,null,"");
         xcvrif_tx_reset_val2.build();
         // hdl path
         xcvrif_tx_reset_val2.add_hdl_path_slice("xcvrif_tx_reset_val2_cfg_tx_reset_val_66_64",0,3);
         
         // Create registers
         xcvrif_rxbit_stat = xcvr_reconfig_reg_xcvrif_rxbit_stat_urm::type_id::create("xcvrif_rxbit_stat");
         xcvrif_rxbit_stat.configure(this,null,"");
         xcvrif_rxbit_stat.build();
         // hdl path
         xcvrif_rxbit_stat.add_hdl_path_slice("xcvrif_rxbit_stat_cfg_rx_bit_position_i",0,7);
         xcvrif_rxbit_stat.add_hdl_path_slice("xcvrif_rxbit_stat_cfg_rx_latency_bit_for_async_i",8,7);
         
         // Create registers
         xcvrif_tx_gbx_stat = xcvr_reconfig_reg_xcvrif_tx_gbx_stat_urm::type_id::create("xcvrif_tx_gbx_stat");
         xcvrif_tx_gbx_stat.configure(this,null,"");
         xcvrif_tx_gbx_stat.build();
         // hdl path
         xcvrif_tx_gbx_stat.add_hdl_path_slice("xcvrif_tx_gbx_stat_status_tx_gbx_i",0,21);
         
         // Create registers
         xcvrif_rx_gbx_stat = xcvr_reconfig_reg_xcvrif_rx_gbx_stat_urm::type_id::create("xcvrif_rx_gbx_stat");
         xcvrif_rx_gbx_stat.configure(this,null,"");
         xcvrif_rx_gbx_stat.build();
         // hdl path
         xcvrif_rx_gbx_stat.add_hdl_path_slice("xcvrif_rx_gbx_stat_status_rx_gbx_i",0,14);
         
         // Create registers
         xcvrif_det_lat_cfg = xcvr_reconfig_reg_xcvrif_det_lat_cfg_urm::type_id::create("xcvrif_det_lat_cfg");
         xcvrif_det_lat_cfg.configure(this,null,"");
         xcvrif_det_lat_cfg.build();
         // hdl path
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_sel_bit_counter_adder",0,2);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_rx_bit_counter_rollover",4,13);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_reset_rx_bit_counter",19,1);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_clk_en_div66_tx",20,1);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_clk_en_sclk_tx",24,1);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_tx_fifo_lat_en",25,2);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_clk_en_sclk_rx",28,1);
         xcvrif_det_lat_cfg.add_hdl_path_slice("xcvrif_det_lat_cfg_cfg_rx_fifo_lat_en",29,2);
         
         // Create registers
         xcvrif_dcc_ctrl = xcvr_reconfig_reg_xcvrif_dcc_ctrl_urm::type_id::create("xcvrif_dcc_ctrl");
         xcvrif_dcc_ctrl.configure(this,null,"");
         xcvrif_dcc_ctrl.build();
         // hdl path
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_byp",0,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_en",1,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_cont_cal",2,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_manual_up",3,5);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_manual_dn",8,5);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_clkdiv",13,3);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_selflock",16,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_half_code",17,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_nfrzdrv",18,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_req",19,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_req_ovr",20,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_dft",28,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_rb_dcc_dft_sel",29,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_idll_entest",30,1);
         xcvrif_dcc_ctrl.add_hdl_path_slice("xcvrif_dcc_ctrl_cfg_test_clk_pll_en_n",31,1);
         
         // Create registers
         xcvrif_dcc_csr0 = xcvr_reconfig_reg_xcvrif_dcc_csr0_reg_urm::type_id::create("xcvrif_dcc_csr0");
         xcvrif_dcc_csr0.configure(this,null,"");
         xcvrif_dcc_csr0.build();
         // hdl path
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_core_rst_en",0,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_en_fsm",1,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_rst_invert",2,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_up_invert",3,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_dn_invert",4,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_updn_en",5,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_mux_sel",6,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_resv",7,10);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_dll_sel",17,1);
         xcvrif_dcc_csr0.add_hdl_path_slice("xcvrif_dcc_csr0_cfg_dcc_csr_dly_ovr",18,10);
         
         // Create registers
         xcvrif_dcc_csr1 = xcvr_reconfig_reg_xcvrif_dcc_csr1_reg_urm::type_id::create("xcvrif_dcc_csr1");
         xcvrif_dcc_csr1.configure(this,null,"");
         xcvrif_dcc_csr1.build();
         // hdl path
         xcvrif_dcc_csr1.add_hdl_path_slice("xcvrif_dcc_csr1_cfg_dcc_csr_dft_msel",0,22);
         xcvrif_dcc_csr1.add_hdl_path_slice("xcvrif_dcc_csr1_cfg_dcc_csr_dly_ovr_10",22,1);
         xcvrif_dcc_csr1.add_hdl_path_slice("xcvrif_dcc_csr1_cfg_dcc_csr_resv_10",23,1);
         
         // Create registers
         xcvrif_dcc_stat = xcvr_reconfig_reg_xcvrif_dcc_stat_reg_urm::type_id::create("xcvrif_dcc_stat");
         xcvrif_dcc_stat.configure(this,null,"");
         xcvrif_dcc_stat.build();
         // hdl path
         xcvrif_dcc_stat.add_hdl_path_slice("xcvrif_dcc_stat_cfg_dcc_done_i",0,1);
         
         // Create registers
         xcvrif_test_ctrl = xcvr_reconfig_reg_xcvrif_test_ctrl_urm::type_id::create("xcvrif_test_ctrl");
         xcvrif_test_ctrl.configure(this,null,"");
         xcvrif_test_ctrl.build();
         // hdl path
         xcvrif_test_ctrl.add_hdl_path_slice("xcvrif_test_ctrl_cfg_tbus_sel",4,4);
         xcvrif_test_ctrl.add_hdl_path_slice("xcvrif_test_ctrl_cfg_test_serd_en_wind_short_cnt_en",31,1);
         
         // Create registers
         interrupt_core_to_cntl = xcvr_reconfig_reg_interrupt_core_to_cntl_urm::type_id::create("interrupt_core_to_cntl");
         interrupt_core_to_cntl.configure(this,null,"");
         interrupt_core_to_cntl.build();
         // hdl path
         interrupt_core_to_cntl.add_hdl_path_slice("interrupt_core_to_cntl_cfg_core_to_cntl",0,16);
         
         // Create registers
         interrupt_if_reg = xcvr_reconfig_reg_interrupt_if_reg_urm::type_id::create("interrupt_if_reg");
         interrupt_if_reg.configure(this,null,"");
         interrupt_if_reg.build();
         // hdl path
         interrupt_if_reg.add_hdl_path_slice("interrupt_if_reg_cfg_int_if_data",0,16);
         interrupt_if_reg.add_hdl_path_slice("interrupt_if_reg_cfg_int_if_code",16,16);
         
         // Create registers
         interrupt_if_rcv_data = xcvr_reconfig_reg_interrupt_if_rcv_data_urm::type_id::create("interrupt_if_rcv_data");
         interrupt_if_rcv_data.configure(this,null,"");
         interrupt_if_rcv_data.build();
         // hdl path
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_int_if_rcv_data_i",0,16);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_fw_crc_err_i",16,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_seq_to_err_i",17,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_ssr_alert_sbe_i",18,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_ssr_alert_dbe_i",19,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_req_stat_i",22,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_in_prog_assert",23,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_in_progress_i",24,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_signal_ok_i",25,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_rx_rdy_i",26,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_tx_rdy_i",27,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_link_loopback_en_i",29,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_pwrseq_active_i",30,1);
         interrupt_if_rcv_data.add_hdl_path_slice("interrupt_if_rcv_data_cfg_core_int_pwrseq_done_i",31,1);
         
         // Create registers
         interrupt_core_status = xcvr_reconfig_reg_interrupt_core_status_urm::type_id::create("interrupt_core_status");
         interrupt_core_status.configure(this,null,"");
         interrupt_core_status.build();
         // hdl path
         interrupt_core_status.add_hdl_path_slice("interrupt_core_status_cfg_core_status_i",0,32);
         
         // Create registers
         interrupt_if_ctrl = xcvr_reconfig_reg_interrupt_if_ctrl_urm::type_id::create("interrupt_if_ctrl");
         interrupt_if_ctrl.configure(this,null,"");
         interrupt_if_ctrl.build();
         // hdl path
         interrupt_if_ctrl.add_hdl_path_slice("interrupt_if_ctrl_cfg_core_int_request",0,1);
         interrupt_if_ctrl.add_hdl_path_slice("interrupt_if_ctrl_cfg_restart_seq_sm",8,1);
         interrupt_if_ctrl.add_hdl_path_slice("interrupt_if_ctrl_cfg_core_int_cntl_ovr_en",16,1);
         interrupt_if_ctrl.add_hdl_path_slice("interrupt_if_ctrl_cfg_core_int_window_en",17,1);
         interrupt_if_ctrl.add_hdl_path_slice("interrupt_if_ctrl_cfg_core_int_window_grpid",20,2);
         interrupt_if_ctrl.add_hdl_path_slice("interrupt_if_ctrl_cfg_core_stat_sel_msw",24,1);
         
         // Create registers
         interrupt_seq_enable = xcvr_reconfig_reg_interrupt_seq_enable_urm::type_id::create("interrupt_seq_enable");
         interrupt_seq_enable.configure(this,null,"");
         interrupt_seq_enable.build();
         // hdl path
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq0",0,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq1",1,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq2",2,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq3",3,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq4",4,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq5",5,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq6",6,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq7",7,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq8",8,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq9",9,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq10",10,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq11",11,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq12",12,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq13",13,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq14",14,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq15",15,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq16",16,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq17",17,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq18",18,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_en_seq19",19,1);
         interrupt_seq_enable.add_hdl_path_slice("interrupt_seq_enable_cfg_serdes_en_seq",31,1);
         
         // Create registers
         interrupt_seq_0 = xcvr_reconfig_reg_interrupt_seq_0_urm::type_id::create("interrupt_seq_0");
         interrupt_seq_0.configure(this,null,"");
         interrupt_seq_0.build();
         // hdl path
         interrupt_seq_0.add_hdl_path_slice("interrupt_seq_0_cfg_int_seq0_data",0,16);
         interrupt_seq_0.add_hdl_path_slice("interrupt_seq_0_cfg_int_seq0_code",16,16);
         
         // Create registers
         interrupt_seq_1 = xcvr_reconfig_reg_interrupt_seq_1_urm::type_id::create("interrupt_seq_1");
         interrupt_seq_1.configure(this,null,"");
         interrupt_seq_1.build();
         // hdl path
         interrupt_seq_1.add_hdl_path_slice("interrupt_seq_1_cfg_int_seq1_data",0,16);
         interrupt_seq_1.add_hdl_path_slice("interrupt_seq_1_cfg_int_seq1_code",16,16);
         
         // Create registers
         interrupt_seq_2 = xcvr_reconfig_reg_interrupt_seq_2_urm::type_id::create("interrupt_seq_2");
         interrupt_seq_2.configure(this,null,"");
         interrupt_seq_2.build();
         // hdl path
         interrupt_seq_2.add_hdl_path_slice("interrupt_seq_2_cfg_int_seq2_data",0,16);
         interrupt_seq_2.add_hdl_path_slice("interrupt_seq_2_cfg_int_seq2_code",16,16);
         
         // Create registers
         interrupt_seq_3 = xcvr_reconfig_reg_interrupt_seq_3_urm::type_id::create("interrupt_seq_3");
         interrupt_seq_3.configure(this,null,"");
         interrupt_seq_3.build();
         // hdl path
         interrupt_seq_3.add_hdl_path_slice("interrupt_seq_3_cfg_int_seq3_data",0,16);
         interrupt_seq_3.add_hdl_path_slice("interrupt_seq_3_cfg_int_seq3_code",16,16);
         
         // Create registers
         interrupt_seq_4 = xcvr_reconfig_reg_interrupt_seq_4_urm::type_id::create("interrupt_seq_4");
         interrupt_seq_4.configure(this,null,"");
         interrupt_seq_4.build();
         // hdl path
         interrupt_seq_4.add_hdl_path_slice("interrupt_seq_4_cfg_int_seq4_data",0,16);
         interrupt_seq_4.add_hdl_path_slice("interrupt_seq_4_cfg_int_seq4_code",16,16);
         
         // Create registers
         interrupt_seq_5 = xcvr_reconfig_reg_interrupt_seq_5_urm::type_id::create("interrupt_seq_5");
         interrupt_seq_5.configure(this,null,"");
         interrupt_seq_5.build();
         // hdl path
         interrupt_seq_5.add_hdl_path_slice("interrupt_seq_5_cfg_int_seq5_data",0,16);
         interrupt_seq_5.add_hdl_path_slice("interrupt_seq_5_cfg_int_seq5_code",16,16);
         
         // Create registers
         interrupt_seq_6 = xcvr_reconfig_reg_interrupt_seq_6_urm::type_id::create("interrupt_seq_6");
         interrupt_seq_6.configure(this,null,"");
         interrupt_seq_6.build();
         // hdl path
         interrupt_seq_6.add_hdl_path_slice("interrupt_seq_6_cfg_int_seq6_data",0,16);
         interrupt_seq_6.add_hdl_path_slice("interrupt_seq_6_cfg_int_seq6_code",16,16);
         
         // Create registers
         interrupt_seq_7 = xcvr_reconfig_reg_interrupt_seq_7_urm::type_id::create("interrupt_seq_7");
         interrupt_seq_7.configure(this,null,"");
         interrupt_seq_7.build();
         // hdl path
         interrupt_seq_7.add_hdl_path_slice("interrupt_seq_7_cfg_int_seq7_data",0,16);
         interrupt_seq_7.add_hdl_path_slice("interrupt_seq_7_cfg_int_seq7_code",16,16);
         
         // Create registers
         interrupt_seq_8 = xcvr_reconfig_reg_interrupt_seq_8_urm::type_id::create("interrupt_seq_8");
         interrupt_seq_8.configure(this,null,"");
         interrupt_seq_8.build();
         // hdl path
         interrupt_seq_8.add_hdl_path_slice("interrupt_seq_8_cfg_int_seq8_data",0,16);
         interrupt_seq_8.add_hdl_path_slice("interrupt_seq_8_cfg_int_seq8_code",16,16);
         
         // Create registers
         interrupt_seq_9 = xcvr_reconfig_reg_interrupt_seq_9_urm::type_id::create("interrupt_seq_9");
         interrupt_seq_9.configure(this,null,"");
         interrupt_seq_9.build();
         // hdl path
         interrupt_seq_9.add_hdl_path_slice("interrupt_seq_9_cfg_int_seq9_data",0,16);
         interrupt_seq_9.add_hdl_path_slice("interrupt_seq_9_cfg_int_seq9_code",16,16);
         
         // Create registers
         interrupt_seq_10 = xcvr_reconfig_reg_interrupt_seq_10_urm::type_id::create("interrupt_seq_10");
         interrupt_seq_10.configure(this,null,"");
         interrupt_seq_10.build();
         // hdl path
         interrupt_seq_10.add_hdl_path_slice("interrupt_seq_10_cfg_int_seq10_data",0,16);
         interrupt_seq_10.add_hdl_path_slice("interrupt_seq_10_cfg_int_seq10_code",16,16);
         
         // Create registers
         interrupt_seq_11 = xcvr_reconfig_reg_interrupt_seq_11_urm::type_id::create("interrupt_seq_11");
         interrupt_seq_11.configure(this,null,"");
         interrupt_seq_11.build();
         // hdl path
         interrupt_seq_11.add_hdl_path_slice("interrupt_seq_11_cfg_int_seq11_data",0,16);
         interrupt_seq_11.add_hdl_path_slice("interrupt_seq_11_cfg_int_seq11_code",16,16);
         
         // Create registers
         interrupt_seq_12 = xcvr_reconfig_reg_interrupt_seq_12_urm::type_id::create("interrupt_seq_12");
         interrupt_seq_12.configure(this,null,"");
         interrupt_seq_12.build();
         // hdl path
         interrupt_seq_12.add_hdl_path_slice("interrupt_seq_12_cfg_int_seq12_data",0,16);
         interrupt_seq_12.add_hdl_path_slice("interrupt_seq_12_cfg_int_seq12_code",16,16);
         
         // Create registers
         interrupt_seq_13 = xcvr_reconfig_reg_interrupt_seq_13_urm::type_id::create("interrupt_seq_13");
         interrupt_seq_13.configure(this,null,"");
         interrupt_seq_13.build();
         // hdl path
         interrupt_seq_13.add_hdl_path_slice("interrupt_seq_13_cfg_int_seq13_data",0,16);
         interrupt_seq_13.add_hdl_path_slice("interrupt_seq_13_cfg_int_seq13_code",16,16);
         
         // Create registers
         interrupt_seq_14 = xcvr_reconfig_reg_interrupt_seq_14_urm::type_id::create("interrupt_seq_14");
         interrupt_seq_14.configure(this,null,"");
         interrupt_seq_14.build();
         // hdl path
         interrupt_seq_14.add_hdl_path_slice("interrupt_seq_14_cfg_int_seq14_data",0,16);
         interrupt_seq_14.add_hdl_path_slice("interrupt_seq_14_cfg_int_seq14_code",16,16);
         
         // Create registers
         interrupt_seq_15 = xcvr_reconfig_reg_interrupt_seq_15_urm::type_id::create("interrupt_seq_15");
         interrupt_seq_15.configure(this,null,"");
         interrupt_seq_15.build();
         // hdl path
         interrupt_seq_15.add_hdl_path_slice("interrupt_seq_15_cfg_int_seq15_data",0,16);
         interrupt_seq_15.add_hdl_path_slice("interrupt_seq_15_cfg_int_seq15_code",16,16);
         
         // Create registers
         interrupt_seq_16 = xcvr_reconfig_reg_interrupt_seq_16_urm::type_id::create("interrupt_seq_16");
         interrupt_seq_16.configure(this,null,"");
         interrupt_seq_16.build();
         // hdl path
         interrupt_seq_16.add_hdl_path_slice("interrupt_seq_16_cfg_int_seq16_data",0,16);
         interrupt_seq_16.add_hdl_path_slice("interrupt_seq_16_cfg_int_seq16_code",16,16);
         
         // Create registers
         interrupt_seq_17 = xcvr_reconfig_reg_interrupt_seq_17_urm::type_id::create("interrupt_seq_17");
         interrupt_seq_17.configure(this,null,"");
         interrupt_seq_17.build();
         // hdl path
         interrupt_seq_17.add_hdl_path_slice("interrupt_seq_17_cfg_int_seq17_data",0,16);
         interrupt_seq_17.add_hdl_path_slice("interrupt_seq_17_cfg_int_seq17_code",16,16);
         
         // Create registers
         interrupt_seq_18 = xcvr_reconfig_reg_interrupt_seq_18_urm::type_id::create("interrupt_seq_18");
         interrupt_seq_18.configure(this,null,"");
         interrupt_seq_18.build();
         // hdl path
         interrupt_seq_18.add_hdl_path_slice("interrupt_seq_18_cfg_int_seq18_data",0,16);
         interrupt_seq_18.add_hdl_path_slice("interrupt_seq_18_cfg_int_seq18_code",16,16);
         
         // Create registers
         interrupt_seq_19 = xcvr_reconfig_reg_interrupt_seq_19_urm::type_id::create("interrupt_seq_19");
         interrupt_seq_19.configure(this,null,"");
         interrupt_seq_19.build();
         // hdl path
         interrupt_seq_19.add_hdl_path_slice("interrupt_seq_19_cfg_int_seq19_data",0,16);
         interrupt_seq_19.add_hdl_path_slice("interrupt_seq_19_cfg_int_seq19_code",16,16);
         
         // Create registers
         interrupt_seq_serdes_en = xcvr_reconfig_reg_interrupt_seq_serdes_en_urm::type_id::create("interrupt_seq_serdes_en");
         interrupt_seq_serdes_en.configure(this,null,"");
         interrupt_seq_serdes_en.build();
         // hdl path
         interrupt_seq_serdes_en.add_hdl_path_slice("interrupt_seq_serdes_en_cfg_int_seq_serdes_en_data",0,16);
         interrupt_seq_serdes_en.add_hdl_path_slice("interrupt_seq_serdes_en_cfg_int_seq_serdes_en_code",16,16);
         
         // Create registers
         xcvr_refclk_sel = xcvr_reconfig_reg_xcvr_refclk_sel_urm::type_id::create("xcvr_refclk_sel");
         xcvr_refclk_sel.configure(this,null,"");
         xcvr_refclk_sel.build();
         // hdl path
         xcvr_refclk_sel.add_hdl_path_slice("xcvr_refclk_sel_cfg_refclk_sel",0,4);
         xcvr_refclk_sel.add_hdl_path_slice("xcvr_refclk_sel_cfg_refclk_scratch",28,4);
         
         // Create registers
         xcvr_hwdec = xcvr_reconfig_reg_xcvr_hwdec_urm::type_id::create("xcvr_hwdec");
         xcvr_hwdec.configure(this,null,"");
         xcvr_hwdec.build();
         // hdl path
         xcvr_hwdec.add_hdl_path_slice("xcvr_hwdec_cfg_hw_mode_sel",0,7);
         xcvr_hwdec.add_hdl_path_slice("xcvr_hwdec_cfg_sel_hw_decode_mode",31,1);
         
         // Create registers
         r_usr_outbox = xcvr_reconfig_reg_r_usr_outbox_urm::type_id::create("r_usr_outbox");
         r_usr_outbox.configure(this,null,"");
         r_usr_outbox.build();
         // hdl path
         r_usr_outbox.add_hdl_path_slice("r_usr_outbox_usr_msg",0,30);
         r_usr_outbox.add_hdl_path_slice("r_usr_outbox_send_msg",31,1);
         
         // Create registers
         r_usr_inbox = xcvr_reconfig_reg_r_usr_inbox_urm::type_id::create("r_usr_inbox");
         r_usr_inbox.configure(this,null,"");
         r_usr_inbox.build();
         // hdl path
         r_usr_inbox.add_hdl_path_slice("r_usr_inbox_usr_msg",0,30);
         r_usr_inbox.add_hdl_path_slice("r_usr_inbox_autoclear_dis",30,1);
         r_usr_inbox.add_hdl_path_slice("r_usr_inbox_new_msg",31,1);
         
         // Create registers
         r_dprio0_tx = xcvr_reconfig_tx_chnl_dprio0_urm::type_id::create("r_dprio0_tx");
         r_dprio0_tx.configure(this,null,"");
         r_dprio0_tx.build();
         // hdl path
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_chnl_dp_map_mode",0,3);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_usertest_sel",9,1);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_fifo_empty",11,5);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_fifo_full",19,5);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_phcomp_rd_delay",24,3);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_double_read",27,1);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_stop_read",28,1);
         r_dprio0_tx.add_hdl_path_slice("r_dprio0_tx_stop_write",29,1);
         
         // Create registers
         r_dprio1_tx = xcvr_reconfig_tx_chnl_dprio1_urm::type_id::create("r_dprio1_tx");
         r_dprio1_tx.configure(this,null,"");
         r_dprio1_tx.build();
         // hdl path
         r_dprio1_tx.add_hdl_path_slice("r_dprio1_tx_fifo_pempty",0,5);
         r_dprio1_tx.add_hdl_path_slice("r_dprio1_tx_dv_gating_en",5,1);
         r_dprio1_tx.add_hdl_path_slice("r_dprio1_tx_rev_lpbk",6,1);
         r_dprio1_tx.add_hdl_path_slice("r_dprio1_tx_fifo_pfull",7,5);
         
         // Create registers
         r_dprio2_tx = xcvr_reconfig_tx_chnl_dprio2_urm::type_id::create("r_dprio2_tx");
         r_dprio2_tx.configure(this,null,"");
         r_dprio2_tx.build();
         // hdl path
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_wa_en",0,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_fifo_power_mode",1,2);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_stretch_num_stages",8,3);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_datapath_tb_sel",11,3);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_wr_adj_en",14,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_rd_adj_en",15,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_txelecidle_rstval",16,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_in_bit0_rstval",17,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_in_bit1_rstval",18,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_in_bit2_rstval",19,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_in_bit3_rstval",20,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_pld_pmaif_mask_tx_pll_rstval",21,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_out_bit0_rstval",22,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_out_bit1_rstval",23,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_out_bit2_rstval",24,1);
         r_dprio2_tx.add_hdl_path_slice("r_dprio2_tx_async_hip_aib_fsr_out_bit3_rstval",25,1);
         
         // Create registers
         r_dprio3_tx = xcvr_reconfig_tx_chnl_dprio3_urm::type_id::create("r_dprio3_tx");
         r_dprio3_tx.configure(this,null,"");
         r_dprio3_tx.build();
         // hdl path
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_fifo_rd_clk_sel",0,2);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_fifo_wr_clk_scg_en",6,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_fifo_rd_clk_scg_en",7,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_osc_clk_scg_en",8,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hrdrst_rx_osc_clk_scg_en",9,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hip_osc_clk_scg_en",10,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_free_run_div_clk",11,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hrdrst_rst_sm_dis",12,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hrdrst_dcd_caldone_byp",13,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hrdrst_dll_lock_byp",14,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hrdrst_align_byp",15,1);
         r_dprio3_tx.add_hdl_path_slice("r_dprio3_tx_hrdrst_user_ctl_en",17,1);
         
         // Create registers
         r_dprio0_rx = xcvr_reconfig_rx_chnl_dprio0_urm::type_id::create("r_dprio0_rx");
         r_dprio0_rx.configure(this,null,"");
         r_dprio0_rx.build();
         // hdl path
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_chnl_dp_map_mode",0,3);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pcs_testbus_sel",5,3);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_8g_a1a2_k1k2_flag_poll_byp",8,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_10g_krfec_rx_diag_data_stat_poll_byp",9,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_pma_pcie_sw_done_poll_byp",10,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_pma_reser_in_poll_byp",11,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_pma_testbus_poll_byp",12,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_test_data_poll_byp",13,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pld_8g_wa_boundary_poll_byp",14,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_pcspma_testbus_sel",15,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_fifo_empty",16,5);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_fifo_mode",21,2);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_wm_en",23,1);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_fifo_full",24,5);
         r_dprio0_rx.add_hdl_path_slice("r_dprio0_rx_phcomp_rd_delay",29,3);
         
         // Create registers
         r_dprio1_rx = xcvr_reconfig_rx_chnl_dprio1_urm::type_id::create("r_dprio1_rx");
         r_dprio1_rx.configure(this,null,"");
         r_dprio1_rx.build();
         // hdl path
         r_dprio1_rx.add_hdl_path_slice("r_dprio1_rx_double_write",0,1);
         r_dprio1_rx.add_hdl_path_slice("r_dprio1_rx_stop_read",1,1);
         r_dprio1_rx.add_hdl_path_slice("r_dprio1_rx_stop_write",2,1);
         r_dprio1_rx.add_hdl_path_slice("r_dprio1_rx_fifo_pempty",4,5);
         r_dprio1_rx.add_hdl_path_slice("r_dprio1_rx_adapter_lpbk_mode",14,2);
         r_dprio1_rx.add_hdl_path_slice("r_dprio1_rx_aib_lpbk_en",24,1);
         
         // Create registers
         r_dprio2_rx = xcvr_reconfig_rx_chnl_dprio2_urm::type_id::create("r_dprio2_rx");
         r_dprio2_rx.configure(this,null,"");
         r_dprio2_rx.build();
         // hdl path
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_fifo_pfull",1,5);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_fifo_power_mode",6,2);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_usertest_sel",14,2);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_hrdrst_user_ctl_en",16,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_wr_adj_en",17,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_rd_adj_en",18,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_async_ltr_rstval",21,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_async_ltd_b_rstval",22,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_async_pld_8g_sig_det_out_rstval",23,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_async_pld_10g_rx_crc32_err_rstval",24,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_async_rx_fifo_align_clr_rstval",25,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_async_hip_en",26,1);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_parity_sel",27,2);
         r_dprio2_rx.add_hdl_path_slice("r_dprio2_rx_stretch_num_stages",29,3);
         
         // Create registers
         r_dprio3_rx = xcvr_reconfig_rx_chnl_dprio3_urm::type_id::create("r_dprio3_rx");
         r_dprio3_rx.configure(this,null,"");
         r_dprio3_rx.build();
         // hdl path
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_datapath_tb_sel",0,4);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_internal_clk1_sel0",4,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_internal_clk1_sel1",5,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_internal_clk1_sel2",6,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_internal_clk1_sel3",7,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_txfiford_prect_sel",8,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_txfiford_postct_sel",9,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_txfifowr_postct_sel",10,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_txfifowr_from_aib_sel",11,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_rxfiford_to_aib_sel",12,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_fifo_wr_clk_sel",13,3);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_fifo_rd_clk_sel",16,3);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_latency_src_sel",19,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_internal_clk1_sel",20,4);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_internal_clk2_sel",24,4);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_fifo_wr_clk_scg_en",28,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_fifo_rd_clk_scg_en",29,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_osc_clk_scg_en",30,1);
         r_dprio3_rx.add_hdl_path_slice("r_dprio3_rx_hrdrst_rx_osc_clk_scg_en",31,1);
         
         // Create registers
         r_dprio4_rx = xcvr_reconfig_rx_chnl_dprio4_urm::type_id::create("r_dprio4_rx");
         r_dprio4_rx.configure(this,null,"");
         r_dprio4_rx.build();
         // hdl path
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_pma_coreclkin_sel",0,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_free_run_div_clk",1,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_hrdrst_rst_sm_dis",2,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_hrdrst_dcd_caldone_byp",3,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_rmfflag_stretch_en",4,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_rmfflag_stretch_num_stages",5,3);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_internal_clk2_sel0",8,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_internal_clk2_sel1",9,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_internal_clk2_sel2",10,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_internal_clk2_sel3",11,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_rxfifowr_prect_sel",12,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_rxfifowr_postct_sel",13,1);
         r_dprio4_rx.add_hdl_path_slice("r_dprio4_rx_rxfiford_postct_sel",14,1);
         
         // Create registers
         r_dprio_status = xcvr_reconfig_dprio_status_urm::type_id::create("r_dprio_status");
         r_dprio_status.configure(this,null,"");
         r_dprio_status.build();
         // hdl path
         r_dprio_status.add_hdl_path_slice("r_dprio_status_rx_chnl",0,8);
         r_dprio_status.add_hdl_path_slice("r_dprio_status_tx_chnl",8,8);
         r_dprio_status.add_hdl_path_slice("r_dprio_status_sr",16,8);
         
         // Create registers
         r_aibdprio0 = xcvr_reconfig_aib_dprio_ctrl0_urm::type_id::create("r_aibdprio0");
         r_aibdprio0.configure(this,null,"");
         r_aibdprio0.build();
         // hdl path
         r_aibdprio0.add_hdl_path_slice("r_aibdprio0_aib_dprio0_ctrl_0",0,8);
         r_aibdprio0.add_hdl_path_slice("r_aibdprio0_aib_dprio0_ctrl_1",8,8);
         r_aibdprio0.add_hdl_path_slice("r_aibdprio0_aib_dprio0_ctrl_2",16,8);
         r_aibdprio0.add_hdl_path_slice("r_aibdprio0_aib_dprio0_ctrl_3",24,8);
         
         // Create registers
         r_aibdprio1 = xcvr_reconfig_aib_dprio_ctrl1_urm::type_id::create("r_aibdprio1");
         r_aibdprio1.configure(this,null,"");
         r_aibdprio1.build();
         // hdl path
         r_aibdprio1.add_hdl_path_slice("r_aibdprio1_aib_dprio1_ctrl_4",0,8);
         
         // Create registers
         r_dprio_sr = xcvr_reconfig_sr_dprio_ctrl_urm::type_id::create("r_dprio_sr");
         r_dprio_sr.configure(this,null,"");
         r_dprio_sr.build();
         // hdl path
         r_dprio_sr.add_hdl_path_slice("r_dprio_sr_reserved",0,16);
         
         // Create registers
         r_dprio_avmm1 = xcvr_reconfig_avmm1_dprio_ctrl_urm::type_id::create("r_dprio_avmm1");
         r_dprio_avmm1.configure(this,null,"");
         r_dprio_avmm1.build();
         // hdl path
         r_dprio_avmm1.add_hdl_path_slice("r_dprio_avmm1_reserved",0,8);
         
         // Create registers
         r_dprio_avmm2 = xcvr_reconfig_avmm2_dprio_ctrl_urm::type_id::create("r_dprio_avmm2");
         r_dprio_avmm2.configure(this,null,"");
         r_dprio_avmm2.build();
         // hdl path
         r_dprio_avmm2.add_hdl_path_slice("r_dprio_avmm2_reserved",0,8);
         
         // Create registers
         r_spare0 = xcvr_reconfig_spare_urm::type_id::create("r_spare0");
         r_spare0.configure(this,null,"");
         r_spare0.build();
         // hdl path
         r_spare0.add_hdl_path_slice("r_spare0_reserved",0,8);
         
         // Create registers
         hssi_pldadapt_tx_300 = xcvr_reconfig_reg_hssi_pldadapt_tx_300_urm::type_id::create("hssi_pldadapt_tx_300");
         hssi_pldadapt_tx_300.configure(this,null,"");
         hssi_pldadapt_tx_300.build();
         // hdl path
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_txfifo_empty",0,5);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_txfifo_mode",5,3);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_txfifo_full",8,5);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_phcomp_rd_del",13,3);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_txfifo_pempty",16,5);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_indv",21,1);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_fifo_stop_rd",22,1);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_fifo_stop_wr",23,1);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_kk",24,5);
         hssi_pldadapt_tx_300.add_hdl_path_slice("hssi_pldadapt_tx_300_tx_fifo_power_mode",29,3);
         
         // Create registers
         hssi_pldadapt_tx_304 = xcvr_reconfig_reg_hssi_pldadapt_tx_304_urm::type_id::create("hssi_pldadapt_tx_304");
         hssi_pldadapt_tx_304.configure(this,null,"");
         hssi_pldadapt_tx_304.build();
         // hdl path
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_comp_cnt",0,8);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_us_master",8,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_ds_master",9,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_us_bypass_pipeln",10,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_ds_bypass_pipeln",11,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_compin_sel",12,2);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_bonding_dft_en",14,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_bonding_dft_val",15,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_dv_bond",16,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_gb_tx_idwidth",17,3);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_gb_tx_odwidth",20,2);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_dv_gen",22,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_fifo_double_write",23,1);
         hssi_pldadapt_tx_304.add_hdl_path_slice("hssi_pldadapt_tx_304_frmgen_mfrm_length",24,8);
         
         // Create registers
         hssi_pldadapt_tx_308 = xcvr_reconfig_reg_hssi_pldadapt_tx_308_urm::type_id::create("hssi_pldadapt_tx_308");
         hssi_pldadapt_tx_308.configure(this,null,"");
         hssi_pldadapt_tx_308.build();
         // hdl path
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_frmgen_mfrm_length",0,8);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_frmgen_bypass",8,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_frmgen_pipeln",9,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_frmgen_pyld_ins",10,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_sh_err",11,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_frmgen_burst",12,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_word_mark",13,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_frmgen_wordslip",14,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_tx_pld_pma_fpll_num_phase_shifts_polling_bypass",15,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_pld_txelecidle_rst_val",16,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_in_bit0_rst_val",17,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_in_bit1_rst_val",18,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_in_bit2_rst_val",19,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_in_bit3_rst_val",20,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_mask_tx_pll_rst_val",21,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_out_bit0_rst_val",22,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_out_bit1_rst_val",23,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_out_bit2_rst_val",24,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_fsr_hip_fsr_out_bit3_rst_val",25,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_tx_pld_8g_tx_boundary_sel_polling_bypass",26,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_tx_pld_10g_tx_bitslip_polling_bypass",27,1);
         hssi_pldadapt_tx_308.add_hdl_path_slice("hssi_pldadapt_tx_308_tx_hip_aib_ssr_in_polling_bypass",28,4);
         
         // Create registers
         hssi_pldadapt_tx_30C = xcvr_reconfig_reg_hssi_pldadapt_tx_30C_urm::type_id::create("hssi_pldadapt_tx_30C");
         hssi_pldadapt_tx_30C.configure(this,null,"");
         hssi_pldadapt_tx_30C.build();
         // hdl path
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_pld_clk1_delay_en",0,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_pld_clk1_delay_sel",1,4);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_pld_clk1_inv_en",5,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_tx_fastbond_wren",6,2);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_fifo_rd_clk_frm_gen_scg_en",8,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_fpll_shared_direct_async_in_sel",9,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_aib_clk1_sel",10,2);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_aib_clk2_sel",12,2);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_fifo_rd_clk_sel",14,2);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_tx_pld_pma_fpll_cnt_sel_polling_bypass",16,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_pld_clk1_sel",17,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_pld_clk2_sel",18,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_fifo_rd_clk_scg_en",19,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_fifo_wr_clk_scg_en",20,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_osc_clk_scg_en",21,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_hrdrst_rx_osc_clk_scg_en",22,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_hip_osc_clk_scg_en",23,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_hrdrst_rst_sm_dis",24,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_hrdrst_dcd_cal_done_by_pass",25,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_hrdrst_user_ctl_en",26,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_tx_fastbond_rden",27,2);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_ds_last_chnl",29,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_us_last_chnl",30,1);
         hssi_pldadapt_tx_30C.add_hdl_path_slice("hssi_pldadapt_tx_30C_tx_usertest_sel",31,1);
         
         // Create registers
         hssi_pldadapt_tx_310 = xcvr_reconfig_reg_hssi_pldadapt_tx_310_urm::type_id::create("hssi_pldadapt_tx_310");
         hssi_pldadapt_tx_310.configure(this,null,"");
         hssi_pldadapt_tx_310.build();
         // hdl path
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_stretch_num_stages",0,3);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_tx_datapath_tb_sel",3,3);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_tx_fifo_write_latency_adjust",6,1);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_tx_fifo_read_latency_adjust",7,1);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_rxfifo_empty",8,6);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_rx_fastbond_wren",14,2);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_rxfifo_full",16,6);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_fifo_double_read",22,1);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_dv_mode",23,1);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_rxfifo_pempty",24,6);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_fifo_stop_rd",30,1);
         hssi_pldadapt_tx_310.add_hdl_path_slice("hssi_pldadapt_tx_310_fifo_stop_wr",31,1);
         
         // Create registers
         hssi_pldadapt_tx_314 = xcvr_reconfig_reg_hssi_pldadapt_tx_314_urm::type_id::create("hssi_pldadapt_tx_314");
         hssi_pldadapt_tx_314.configure(this,null,"");
         hssi_pldadapt_tx_314.build();
         // hdl path
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_rxfifo_pfull",0,6);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_indv",6,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_rx_true_b4b",7,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_rxfifo_mode",8,3);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_phcomp_rd_del",11,3);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_lpbk_mode",14,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_rx_fifo_write_latency_adjust",15,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_comp_cnt",16,8);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_us_master",24,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_ds_master",25,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_us_bypass_pipeln",26,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_ds_bypass_pipeln",27,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_compin_sel",28,2);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_bonding_dft_en",30,1);
         hssi_pldadapt_tx_314.add_hdl_path_slice("hssi_pldadapt_tx_314_bonding_dft_val",31,1);
         
         // Create registers
         hssi_pldadapt_tx_31C = xcvr_reconfig_reg_hssi_pldadapt_tx_31C_urm::type_id::create("hssi_pldadapt_tx_31C");
         hssi_pldadapt_tx_31C.configure(this,null,"");
         hssi_pldadapt_tx_31C.build();
         // hdl path
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_asn_wait_for_dll_reset_cnt",0,8);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_asn_wait_for_pma_pcie_sw_done_cnt",8,8);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_reserved0",16,4);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_rx_pld_8g_eidleinfersel_polling_bypass",20,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_rx_pld_pma_eye_monitor_polling_bypass",21,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_rx_pld_pma_pcie_switch_polling_bypass",22,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_rx_pld_pma_reser_out_polling_bypass",23,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_fsr_pld_ltr_rst_val",24,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_fsr_pld_ltd_b_rst_val",25,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_fsr_pld_8g_sigdet_out_rst_val",26,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_fsr_pld_10g_rx_crc32_err_rst_val",27,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_fsr_pld_rx_fifo_align_clr_rst_val",28,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_rx_prbs_flags_sr_enable",29,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_rx_usertest_sel",30,1);
         hssi_pldadapt_tx_31C.add_hdl_path_slice("hssi_pldadapt_tx_31C_reserved1",31,1);
         
         // Create registers
         hssi_pldadapt_tx_320 = xcvr_reconfig_reg_hssi_pldadapt_tx_320_urm::type_id::create("hssi_pldadapt_tx_320");
         hssi_pldadapt_tx_320.configure(this,null,"");
         hssi_pldadapt_tx_320.build();
         // hdl path
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_stretch_num_stages",0,3);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_rx_datapath_tb_sel",3,4);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_rx_fifo_read_latency_adjust",7,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_pld_clk1_delay_en",8,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_pld_clk1_delay_set",9,4);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_pld_clk1_inv_en",13,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_reserved",14,2);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_aib_clk1_sel",16,2);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_aib_clk2_sel",18,2);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_fifo_wr_clk_sel",20,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_fifo_rd_clk_sel",21,2);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_pld_clk1_sel",23,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_sclk_sel",24,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_fifo_wr_clk_scg_en",25,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_fifo_rd_clk_scg_en",26,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_pma_hclk_scg_en",27,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_osc_clk_scg_en",28,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_hrdrst_rx_osc_clk_scg_en",29,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_fifo_wr_clk_del_sm_scg_en",30,1);
         hssi_pldadapt_tx_320.add_hdl_path_slice("hssi_pldadapt_tx_320_fifo_rd_clk_ins_sm_scg_en",31,1);
         
         // Create registers
         hssi_pldadapt_tx_324 = xcvr_reconfig_reg_hssi_pldadapt_tx_324_urm::type_id::create("hssi_pldadapt_tx_324");
         hssi_pldadapt_tx_324.configure(this,null,"");
         hssi_pldadapt_tx_324.build();
         // hdl path
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_internal_clk1_sel1",0,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_internal_clk1_sel2",1,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_txfiford_post_ct_sel",2,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_txfifowr_post_ct_sel",3,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_internal_clk2_sel1",4,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_internal_clk2_sel2",5,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_rxfifowr_post_ct_sel",6,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_rxfiford_post_ct_sel",7,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_free_run_div_clk",8,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_hrdrst_rst_sm_dis",9,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_hrdrst_dll_lock_bypass",10,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_hrdrst_align_bypass",11,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_hrdrst_user_ctl_en",12,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_reserved0",13,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_ds_last_chnl",14,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_us_last_chnl",15,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_reserved1",16,3);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_hdpldadapt_sr_sr_testbus_sel",19,1);
         hssi_pldadapt_tx_324.add_hdl_path_slice("hssi_pldadapt_tx_324_reserved2",20,12);
         
         // Create registers
         hssi_aibnd_32B = xcvr_reconfig_reg_hssi_aibnd_32B_urm::type_id::create("hssi_aibnd_32B");
         hssi_aibnd_32B.configure(this,null,"");
         hssi_aibnd_32B.build();
         // hdl path
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_dllstr_align_dy_ctl_static",0,10);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_dllstr_align_dy_ctlsel",10,1);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_reserved0",11,5);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_tx_dcc_dy_ctlsel",16,1);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_tx_dcc_dy_ctl_static",17,10);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_tx_dcc_byp",27,1);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_tx_dcc_en",28,1);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_aib_tx_dcc_cont_cal",29,1);
         hssi_aibnd_32B.add_hdl_path_slice("hssi_aibnd_32B_reserved1",30,2);
         
         // Create registers
         hssi_ppt_rx_chnl_330 = xcvr_reconfig_reg_hssi_ppt_rx_chnl_330_urm::type_id::create("hssi_ppt_rx_chnl_330");
         hssi_ppt_rx_chnl_330.configure(this,null,"");
         hssi_ppt_rx_chnl_330.build();
         // hdl path
         hssi_ppt_rx_chnl_330.add_hdl_path_slice("hssi_ppt_rx_chnl_330_r_tx_chnl_datapath_status_0",0,8);
         hssi_ppt_rx_chnl_330.add_hdl_path_slice("hssi_ppt_rx_chnl_330_wa_error",8,1);
         hssi_ppt_rx_chnl_330.add_hdl_path_slice("hssi_ppt_rx_chnl_330_wa_error_cnt",9,4);
         hssi_ppt_rx_chnl_330.add_hdl_path_slice("hssi_ppt_rx_chnl_330_r_rx_chnl_datapath_status_0_res_5_7",13,3);
         hssi_ppt_rx_chnl_330.add_hdl_path_slice("hssi_ppt_rx_chnl_330_reserved",16,16);
         
         // Create registers
         phy_revid = xcvr_reconfig_reg_phy_revid_urm::type_id::create("phy_revid");
         phy_revid.configure(this,null,"");
         phy_revid.build();
         // hdl path
         
         // Create registers
         phy_scratch = xcvr_reconfig_reg_phy_scratch_register_urm::type_id::create("phy_scratch");
         phy_scratch.configure(this,null,"");
         phy_scratch.build();
         // hdl path
         phy_scratch.add_hdl_path_slice("phy_scratch_scratch",0,32);
         
         // Create registers
         phy_name_0 = xcvr_reconfig_reg_phy_name_urm::type_id::create("phy_name_0");
         phy_name_0.configure(this,null,"");
         phy_name_0.build();
         // hdl path
         
         // Create registers
         phy_name_1 = xcvr_reconfig_reg_phy_name_1_urm::type_id::create("phy_name_1");
         phy_name_1.configure(this,null,"");
         phy_name_1.build();
         // hdl path
         
         // Create registers
         phy_name_2 = xcvr_reconfig_reg_phy_name_2_urm::type_id::create("phy_name_2");
         phy_name_2.configure(this,null,"");
         phy_name_2.build();
         // hdl path
         
         // Create registers
         phy_ehip_mode_muxes = xcvr_reconfig_reg_ehip_mode_muxes_urm::type_id::create("phy_ehip_mode_muxes");
         phy_ehip_mode_muxes.configure(this,null,"");
         phy_ehip_mode_muxes.build();
         // hdl path
         phy_ehip_mode_muxes.add_hdl_path_slice("phy_ehip_mode_muxes_txpcsmux_sel",3,3);
         phy_ehip_mode_muxes.add_hdl_path_slice("phy_ehip_mode_muxes_rxpcsmux_sel",15,3);
         phy_ehip_mode_muxes.add_hdl_path_slice("phy_ehip_mode_muxes_rxmacmux_sel",18,3);
         phy_ehip_mode_muxes.add_hdl_path_slice("phy_ehip_mode_muxes_rxpldmux_sel",21,3);
         
         // Create registers
         phy_ehip_pcs_modes = xcvr_reconfig_reg_ehip_pcs_modes_urm::type_id::create("phy_ehip_pcs_modes");
         phy_ehip_pcs_modes.configure(this,null,"");
         phy_ehip_pcs_modes.build();
         // hdl path
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_enc",0,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_scr",1,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_select_tx_am",2,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_striper",3,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_am_insert",4,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_dsc",7,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_select_rx_am",8,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_aligner",9,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_use_rx_50g",10,1);
         phy_ehip_pcs_modes.add_hdl_path_slice("phy_ehip_pcs_modes_rx_test_pattern_mode",11,1);
         
         // Create registers
         phy_ehip_clock_gating = xcvr_reconfig_reg_ehip_clk_gating_urm::type_id::create("phy_ehip_clock_gating");
         phy_ehip_clock_gating.configure(this,null,"");
         phy_ehip_clock_gating.build();
         // hdl path
         phy_ehip_clock_gating.add_hdl_path_slice("phy_ehip_clock_gating_en_ptpclk",0,1);
         phy_ehip_clock_gating.add_hdl_path_slice("phy_ehip_clock_gating_en_pcsclk",1,1);
         phy_ehip_clock_gating.add_hdl_path_slice("phy_ehip_clock_gating_en_macclk",2,1);
         
         // Create registers
         phy_config = xcvr_reconfig_reg_phy_config_urm::type_id::create("phy_config");
         phy_config.configure(this,null,"");
         phy_config.build();
         // hdl path
         phy_config.add_hdl_path_slice("phy_config_eio_sys_rst",0,1);
         phy_config.add_hdl_path_slice("phy_config_soft_tx_rst",1,1);
         phy_config.add_hdl_path_slice("phy_config_soft_rx_rst",2,1);
         phy_config.add_hdl_path_slice("phy_config_set_ref_lock",4,1);
         phy_config.add_hdl_path_slice("phy_config_set_data_lock",5,1);
         
         // Create registers
         phy_pma_sloop = xcvr_reconfig_reg_phy_pma_sloop_urm::type_id::create("phy_pma_sloop");
         phy_pma_sloop.configure(this,null,"");
         phy_pma_sloop.build();
         // hdl path
         phy_pma_sloop.add_hdl_path_slice("phy_pma_sloop_sloop",0,4);
         
         // Create registers
         phy_tx_pll_locked = xcvr_reconfig_reg_phy_tx_pll_locked_urm::type_id::create("phy_tx_pll_locked");
         phy_tx_pll_locked.configure(this,null,"");
         phy_tx_pll_locked.build();
         // hdl path
         phy_tx_pll_locked.add_hdl_path_slice("phy_tx_pll_locked_tx_pll_locked_i",0,4);
         
         // Create registers
         phy_eiofreq_locked = xcvr_reconfig_reg_phy_eiofreq_locked_urm::type_id::create("phy_eiofreq_locked");
         phy_eiofreq_locked.configure(this,null,"");
         phy_eiofreq_locked.build();
         // hdl path
         phy_eiofreq_locked.add_hdl_path_slice("phy_eiofreq_locked_eio_freq_lock_i",0,4);
         
         // Create registers
         phy_tx_corepll_locked = xcvr_reconfig_reg_phy_tx_corepll_locked_urm::type_id::create("phy_tx_corepll_locked");
         phy_tx_corepll_locked.configure(this,null,"");
         phy_tx_corepll_locked.build();
         // hdl path
         phy_tx_corepll_locked.add_hdl_path_slice("phy_tx_corepll_locked_tx_pcs_ready_i",0,1);
         
         // Create registers
         phy_frame_error = xcvr_reconfig_reg_phy_frame_error_urm::type_id::create("phy_frame_error");
         phy_frame_error.configure(this,null,"");
         phy_frame_error.build();
         // hdl path
         phy_frame_error.add_hdl_path_slice("phy_frame_error_frmerr_i",0,20);
         
         // Create registers
         phy_sclr_frame_error = xcvr_reconfig_reg_phy_sclr_frame_error_urm::type_id::create("phy_sclr_frame_error");
         phy_sclr_frame_error.configure(this,null,"");
         phy_sclr_frame_error.build();
         // hdl path
         phy_sclr_frame_error.add_hdl_path_slice("phy_sclr_frame_error_clr_frmerr",0,1);
         
         // Create registers
         phy_eio_sftreset = xcvr_reconfig_reg_phy_eio_sftreset_urm::type_id::create("phy_eio_sftreset");
         phy_eio_sftreset.configure(this,null,"");
         phy_eio_sftreset.build();
         // hdl path
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_rrst",0,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_trst",2,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_force_tx_pld_deskew_done",13,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_force_hip_ready",14,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_tx_mac_in_rst",16,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_tx_pcs_in_rst",17,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_rx_mac_in_rst",18,1);
         phy_eio_sftreset.add_hdl_path_slice("phy_eio_sftreset_rx_pcs_in_rst",19,1);
         
         // Create registers
         phy_rxpcs_status = xcvr_reconfig_reg_phy_rxpcs_status_urm::type_id::create("phy_rxpcs_status");
         phy_rxpcs_status.configure(this,null,"");
         phy_rxpcs_status.build();
         // hdl path
         phy_rxpcs_status.add_hdl_path_slice("phy_rxpcs_status_rx_aligned_i",0,1);
         phy_rxpcs_status.add_hdl_path_slice("phy_rxpcs_status_hi_ber_i",1,1);
         
         // Create registers
         err_inj = xcvr_reconfig_reg_phy_pcs_err_inj_urm::type_id::create("err_inj");
         err_inj.configure(this,null,"");
         err_inj.build();
         // hdl path
         err_inj.add_hdl_path_slice("err_inj_inj_err",0,20);
         
         // Create registers
         am_lock = xcvr_reconfig_reg_phy_am_lock_urm::type_id::create("am_lock");
         am_lock.configure(this,null,"");
         am_lock.build();
         // hdl path
         am_lock.add_hdl_path_slice("am_lock_am_lock_i",0,1);
         
         // Create registers
         lanes_deskewed = xcvr_reconfig_reg_phy_lanes_deskewed_urm::type_id::create("lanes_deskewed");
         lanes_deskewed.configure(this,null,"");
         lanes_deskewed.build();
         // hdl path
         lanes_deskewed.add_hdl_path_slice("lanes_deskewed_dskew_status_i",0,1);
         lanes_deskewed.add_hdl_path_slice("lanes_deskewed_dskew_chng_i",1,1);
         
         // Create registers
         ber_count = xcvr_reconfig_reg_phy_ber_count_urm::type_id::create("ber_count");
         ber_count.configure(this,null,"");
         ber_count.build();
         // hdl path
         ber_count.add_hdl_path_slice("ber_count_count_i",0,32);
         
         // Create registers
         pcs_vlane_0 = xcvr_reconfig_reg_phy_pcs_vlane0_urm::type_id::create("pcs_vlane_0");
         pcs_vlane_0.configure(this,null,"");
         pcs_vlane_0.build();
         // hdl path
         pcs_vlane_0.add_hdl_path_slice("pcs_vlane_0_vlane0_i",0,5);
         pcs_vlane_0.add_hdl_path_slice("pcs_vlane_0_vlane1_i",5,5);
         pcs_vlane_0.add_hdl_path_slice("pcs_vlane_0_vlane2_i",10,5);
         pcs_vlane_0.add_hdl_path_slice("pcs_vlane_0_vlane3_i",15,5);
         pcs_vlane_0.add_hdl_path_slice("pcs_vlane_0_vlane4_i",20,5);
         pcs_vlane_0.add_hdl_path_slice("pcs_vlane_0_vlane5_i",25,5);
         
         // Create registers
         pcs_vlane_1 = xcvr_reconfig_reg_phy_pcs_vlane1_urm::type_id::create("pcs_vlane_1");
         pcs_vlane_1.configure(this,null,"");
         pcs_vlane_1.build();
         // hdl path
         pcs_vlane_1.add_hdl_path_slice("pcs_vlane_1_vlane6_i",0,5);
         pcs_vlane_1.add_hdl_path_slice("pcs_vlane_1_vlane7_i",5,5);
         pcs_vlane_1.add_hdl_path_slice("pcs_vlane_1_vlane8_i",10,5);
         pcs_vlane_1.add_hdl_path_slice("pcs_vlane_1_vlane9_i",15,5);
         pcs_vlane_1.add_hdl_path_slice("pcs_vlane_1_vlane10_i",20,5);
         pcs_vlane_1.add_hdl_path_slice("pcs_vlane_1_vlane11_i",25,5);
         
         // Create registers
         pcs_vlane_2 = xcvr_reconfig_reg_phy_pcs_vlane2_urm::type_id::create("pcs_vlane_2");
         pcs_vlane_2.configure(this,null,"");
         pcs_vlane_2.build();
         // hdl path
         pcs_vlane_2.add_hdl_path_slice("pcs_vlane_2_vlane12_i",0,5);
         pcs_vlane_2.add_hdl_path_slice("pcs_vlane_2_vlane13_i",5,5);
         pcs_vlane_2.add_hdl_path_slice("pcs_vlane_2_vlane14_i",10,5);
         pcs_vlane_2.add_hdl_path_slice("pcs_vlane_2_vlane15_i",15,5);
         pcs_vlane_2.add_hdl_path_slice("pcs_vlane_2_vlane16_i",20,5);
         pcs_vlane_2.add_hdl_path_slice("pcs_vlane_2_vlane17_i",25,5);
         
         // Create registers
         pcs_vlane_3 = xcvr_reconfig_reg_phy_pcs_vlane3_urm::type_id::create("pcs_vlane_3");
         pcs_vlane_3.configure(this,null,"");
         pcs_vlane_3.build();
         // hdl path
         pcs_vlane_3.add_hdl_path_slice("pcs_vlane_3_vlane18_i",0,5);
         pcs_vlane_3.add_hdl_path_slice("pcs_vlane_3_vlane19_i",5,5);
         
         // Create registers
         phy_refclk_khz = xcvr_reconfig_reg_phy_refclk_khz_urm::type_id::create("phy_refclk_khz");
         phy_refclk_khz.configure(this,null,"");
         phy_refclk_khz.build();
         // hdl path
         phy_refclk_khz.add_hdl_path_slice("phy_refclk_khz_khz_ref_i",0,32);
         
         // Create registers
         phy_recclk_khz = xcvr_reconfig_reg_phy_recclk_khz_urm::type_id::create("phy_recclk_khz");
         phy_recclk_khz.configure(this,null,"");
         phy_recclk_khz.build();
         // hdl path
         phy_recclk_khz.add_hdl_path_slice("phy_recclk_khz_khz_rx_i",0,32);
         
         // Create registers
         phy_txclk_khz = xcvr_reconfig_reg_phy_txclk_khz_urm::type_id::create("phy_txclk_khz");
         phy_txclk_khz.configure(this,null,"");
         phy_txclk_khz.build();
         // hdl path
         phy_txclk_khz.add_hdl_path_slice("phy_txclk_khz_khz_tx_i",0,32);
         
         // Create registers
         tx_pld_conf = xcvr_reconfig_reg_tx_pld_conf_urm::type_id::create("tx_pld_conf");
         tx_pld_conf.configure(this,null,"");
         tx_pld_conf.build();
         // hdl path
         tx_pld_conf.add_hdl_path_slice("tx_pld_conf_tx_ehip_mode",0,3);
         tx_pld_conf.add_hdl_path_slice("tx_pld_conf_tx_fifo_afull",8,5);
         tx_pld_conf.add_hdl_path_slice("tx_pld_conf_tx_deskew_chan_sel",16,6);
         tx_pld_conf.add_hdl_path_slice("tx_pld_conf_tx_deskew_clear",22,1);
         tx_pld_conf.add_hdl_path_slice("tx_pld_conf_sel_50gx2",23,1);
         
         // Create registers
         tx_pld_status = xcvr_reconfig_reg_tx_pld_status_urm::type_id::create("tx_pld_status");
         tx_pld_status.configure(this,null,"");
         tx_pld_status.build();
         // hdl path
         tx_pld_status.add_hdl_path_slice("tx_pld_status_tx_dsk_eval_done_i",0,1);
         tx_pld_status.add_hdl_path_slice("tx_pld_status_tx_dsk_status_i",1,3);
         tx_pld_status.add_hdl_path_slice("tx_pld_status_tx_dsk_monitor_err_i",8,6);
         tx_pld_status.add_hdl_path_slice("tx_pld_status_tx_dsk_active_chans_i",16,6);
         tx_pld_status.add_hdl_path_slice("tx_pld_status_err_tx_avst_fifo_underflow_i",22,1);
         tx_pld_status.add_hdl_path_slice("tx_pld_status_err_tx_avst_fifo_empty_i",23,1);
         tx_pld_status.add_hdl_path_slice("tx_pld_status_err_tx_avst_fifo_overflow_i",24,1);
         
         // Create registers
         phy_rxpma_status = xcvr_reconfig_reg_phy_rxpma_status_urm::type_id::create("phy_rxpma_status");
         phy_rxpma_status.configure(this,null,"");
         phy_rxpma_status.build();
         // hdl path
         phy_rxpma_status.add_hdl_path_slice("phy_rxpma_status_rd_numdata_i",8,4);
         phy_rxpma_status.add_hdl_path_slice("phy_rxpma_status_err_overflow_i",12,4);
         phy_rxpma_status.add_hdl_path_slice("phy_rxpma_status_err_skew_i",16,1);
         
         // Create registers
         rx_pld_conf = xcvr_reconfig_reg_rx_pld_conf_urm::type_id::create("rx_pld_conf");
         rx_pld_conf.configure(this,null,"");
         rx_pld_conf.build();
         // hdl path
         rx_pld_conf.add_hdl_path_slice("rx_pld_conf_rx_ehip_mode",0,3);
         rx_pld_conf.add_hdl_path_slice("rx_pld_conf_use_lane_ptp",3,1);
         rx_pld_conf.add_hdl_path_slice("rx_pld_conf_sel_50gx2",4,1);
         
         // Create registers
         rx_pld_status = xcvr_reconfig_reg_rx_pld_status_urm::type_id::create("rx_pld_status");
         rx_pld_status.configure(this,null,"");
         rx_pld_status.build();
         // hdl path
         rx_pld_status.add_hdl_path_slice("rx_pld_status_buf_err_50g_i",0,1);
         
         // Create registers
         rxpcs_conf = xcvr_reconfig_reg_rxpcs_conf_urm::type_id::create("rxpcs_conf");
         rxpcs_conf.configure(this,null,"");
         rxpcs_conf.build();
         // hdl path
         rxpcs_conf.add_hdl_path_slice("rxpcs_conf_am_interval",0,14);
         rxpcs_conf.add_hdl_path_slice("rxpcs_conf_rx_pcs_max_skew",14,6);
         rxpcs_conf.add_hdl_path_slice("rxpcs_conf_use_hi_ber_monitor",20,1);
         
         // Create registers
         bip_counter_0 = xcvr_reconfig_reg_bip_counter_urm::type_id::create("bip_counter_0");
         bip_counter_0.configure(this,null,"");
         bip_counter_0.build();
         // hdl path
         bip_counter_0.add_hdl_path_slice("bip_counter_0_count_i",0,16);
         
         // Create registers
         bip_counter_1 = xcvr_reconfig_reg_bip_counter_1_urm::type_id::create("bip_counter_1");
         bip_counter_1.configure(this,null,"");
         bip_counter_1.build();
         // hdl path
         bip_counter_1.add_hdl_path_slice("bip_counter_1_count_i",0,16);
         
         // Create registers
         bip_counter_2 = xcvr_reconfig_reg_bip_counter_2_urm::type_id::create("bip_counter_2");
         bip_counter_2.configure(this,null,"");
         bip_counter_2.build();
         // hdl path
         bip_counter_2.add_hdl_path_slice("bip_counter_2_count_i",0,16);
         
         // Create registers
         bip_counter_3 = xcvr_reconfig_reg_bip_counter_3_urm::type_id::create("bip_counter_3");
         bip_counter_3.configure(this,null,"");
         bip_counter_3.build();
         // hdl path
         bip_counter_3.add_hdl_path_slice("bip_counter_3_count_i",0,16);
         
         // Create registers
         bip_counter_4 = xcvr_reconfig_reg_bip_counter_4_urm::type_id::create("bip_counter_4");
         bip_counter_4.configure(this,null,"");
         bip_counter_4.build();
         // hdl path
         bip_counter_4.add_hdl_path_slice("bip_counter_4_count_i",0,16);
         
         // Create registers
         bip_counter_5 = xcvr_reconfig_reg_bip_counter_5_urm::type_id::create("bip_counter_5");
         bip_counter_5.configure(this,null,"");
         bip_counter_5.build();
         // hdl path
         bip_counter_5.add_hdl_path_slice("bip_counter_5_count_i",0,16);
         
         // Create registers
         bip_counter_6 = xcvr_reconfig_reg_bip_counter_6_urm::type_id::create("bip_counter_6");
         bip_counter_6.configure(this,null,"");
         bip_counter_6.build();
         // hdl path
         bip_counter_6.add_hdl_path_slice("bip_counter_6_count_i",0,16);
         
         // Create registers
         bip_counter_7 = xcvr_reconfig_reg_bip_counter_7_urm::type_id::create("bip_counter_7");
         bip_counter_7.configure(this,null,"");
         bip_counter_7.build();
         // hdl path
         bip_counter_7.add_hdl_path_slice("bip_counter_7_count_i",0,16);
         
         // Create registers
         bip_counter_8 = xcvr_reconfig_reg_bip_counter_8_urm::type_id::create("bip_counter_8");
         bip_counter_8.configure(this,null,"");
         bip_counter_8.build();
         // hdl path
         bip_counter_8.add_hdl_path_slice("bip_counter_8_count_i",0,16);
         
         // Create registers
         bip_counter_9 = xcvr_reconfig_reg_bip_counter_9_urm::type_id::create("bip_counter_9");
         bip_counter_9.configure(this,null,"");
         bip_counter_9.build();
         // hdl path
         bip_counter_9.add_hdl_path_slice("bip_counter_9_count_i",0,16);
         
         // Create registers
         bip_counter_10 = xcvr_reconfig_reg_bip_counter_10_urm::type_id::create("bip_counter_10");
         bip_counter_10.configure(this,null,"");
         bip_counter_10.build();
         // hdl path
         bip_counter_10.add_hdl_path_slice("bip_counter_10_count_i",0,16);
         
         // Create registers
         bip_counter_11 = xcvr_reconfig_reg_bip_counter_11_urm::type_id::create("bip_counter_11");
         bip_counter_11.configure(this,null,"");
         bip_counter_11.build();
         // hdl path
         bip_counter_11.add_hdl_path_slice("bip_counter_11_count_i",0,16);
         
         // Create registers
         bip_counter_12 = xcvr_reconfig_reg_bip_counter_12_urm::type_id::create("bip_counter_12");
         bip_counter_12.configure(this,null,"");
         bip_counter_12.build();
         // hdl path
         bip_counter_12.add_hdl_path_slice("bip_counter_12_count_i",0,16);
         
         // Create registers
         bip_counter_13 = xcvr_reconfig_reg_bip_counter_13_urm::type_id::create("bip_counter_13");
         bip_counter_13.configure(this,null,"");
         bip_counter_13.build();
         // hdl path
         bip_counter_13.add_hdl_path_slice("bip_counter_13_count_i",0,16);
         
         // Create registers
         bip_counter_14 = xcvr_reconfig_reg_bip_counter_14_urm::type_id::create("bip_counter_14");
         bip_counter_14.configure(this,null,"");
         bip_counter_14.build();
         // hdl path
         bip_counter_14.add_hdl_path_slice("bip_counter_14_count_i",0,16);
         
         // Create registers
         bip_counter_15 = xcvr_reconfig_reg_bip_counter_15_urm::type_id::create("bip_counter_15");
         bip_counter_15.configure(this,null,"");
         bip_counter_15.build();
         // hdl path
         bip_counter_15.add_hdl_path_slice("bip_counter_15_count_i",0,16);
         
         // Create registers
         bip_counter_16 = xcvr_reconfig_reg_bip_counter_16_urm::type_id::create("bip_counter_16");
         bip_counter_16.configure(this,null,"");
         bip_counter_16.build();
         // hdl path
         bip_counter_16.add_hdl_path_slice("bip_counter_16_count_i",0,16);
         
         // Create registers
         bip_counter_17 = xcvr_reconfig_reg_bip_counter_17_urm::type_id::create("bip_counter_17");
         bip_counter_17.configure(this,null,"");
         bip_counter_17.build();
         // hdl path
         bip_counter_17.add_hdl_path_slice("bip_counter_17_count_i",0,16);
         
         // Create registers
         bip_counter_18 = xcvr_reconfig_reg_bip_counter_18_urm::type_id::create("bip_counter_18");
         bip_counter_18.configure(this,null,"");
         bip_counter_18.build();
         // hdl path
         bip_counter_18.add_hdl_path_slice("bip_counter_18_count_i",0,16);
         
         // Create registers
         bip_counter_19 = xcvr_reconfig_reg_bip_counter_19_urm::type_id::create("bip_counter_19");
         bip_counter_19.configure(this,null,"");
         bip_counter_19.build();
         // hdl path
         bip_counter_19.add_hdl_path_slice("bip_counter_19_count_i",0,16);
         
         // Create registers
         am_encoding_0 = xcvr_reconfig_reg_am_encoding_urm::type_id::create("am_encoding_0");
         am_encoding_0.configure(this,null,"");
         am_encoding_0.build();
         // hdl path
         am_encoding_0.add_hdl_path_slice("am_encoding_0_am",0,24);
         
         // Create registers
         am_encoding_1 = xcvr_reconfig_reg_am_encoding_1_urm::type_id::create("am_encoding_1");
         am_encoding_1.configure(this,null,"");
         am_encoding_1.build();
         // hdl path
         am_encoding_1.add_hdl_path_slice("am_encoding_1_am",0,24);
         
         // Create registers
         am_encoding_2 = xcvr_reconfig_reg_am_encoding_2_urm::type_id::create("am_encoding_2");
         am_encoding_2.configure(this,null,"");
         am_encoding_2.build();
         // hdl path
         am_encoding_2.add_hdl_path_slice("am_encoding_2_am",0,24);
         
         // Create registers
         am_encoding_3 = xcvr_reconfig_reg_am_encoding_3_urm::type_id::create("am_encoding_3");
         am_encoding_3.configure(this,null,"");
         am_encoding_3.build();
         // hdl path
         am_encoding_3.add_hdl_path_slice("am_encoding_3_am",0,24);
         
         // Create registers
         xus_timer_window = xcvr_reconfig_reg_xus_timer_window_urm::type_id::create("xus_timer_window");
         xus_timer_window.configure(this,null,"");
         xus_timer_window.build();
         // hdl path
         xus_timer_window.add_hdl_path_slice("xus_timer_window_cycles",0,21);
         
         // Create registers
         ber_invalid_count = xcvr_reconfig_reg_ber_invalid_count_urm::type_id::create("ber_invalid_count");
         ber_invalid_count.configure(this,null,"");
         ber_invalid_count.build();
         // hdl path
         ber_invalid_count.add_hdl_path_slice("ber_invalid_count_count",0,7);
         
         // Create registers
         err_block_cnt = xcvr_reconfig_reg_err_block_cnt_urm::type_id::create("err_block_cnt");
         err_block_cnt.configure(this,null,"");
         err_block_cnt.build();
         // hdl path
         err_block_cnt.add_hdl_path_slice("err_block_cnt_count_i",0,32);
         
         // Create registers
         rx_pcs_int_err = xcvr_reconfig_reg_rx_pcs_int_err_urm::type_id::create("rx_pcs_int_err");
         rx_pcs_int_err.configure(this,null,"");
         rx_pcs_int_err.build();
         // hdl path
         rx_pcs_int_err.add_hdl_path_slice("rx_pcs_int_err_vector_i",0,32);
         
         // Create registers
         rx_pcs_int_err_mask = xcvr_reconfig_reg_rx_pcs_int_err_mask_urm::type_id::create("rx_pcs_int_err_mask");
         rx_pcs_int_err_mask.configure(this,null,"");
         rx_pcs_int_err_mask.build();
         // hdl path
         rx_pcs_int_err_mask.add_hdl_path_slice("rx_pcs_int_err_mask_vector",0,32);
         
         // Create registers
         dsk_depth_0 = xcvr_reconfig_reg_dsk_depth_urm::type_id::create("dsk_depth_0");
         dsk_depth_0.configure(this,null,"");
         dsk_depth_0.build();
         // hdl path
         dsk_depth_0.add_hdl_path_slice("dsk_depth_0_depth0_i",0,6);
         dsk_depth_0.add_hdl_path_slice("dsk_depth_0_depth1_i",6,6);
         dsk_depth_0.add_hdl_path_slice("dsk_depth_0_depth2_i",12,6);
         dsk_depth_0.add_hdl_path_slice("dsk_depth_0_depth3_i",18,6);
         dsk_depth_0.add_hdl_path_slice("dsk_depth_0_depth4_i",24,6);
         
         // Create registers
         dsk_depth_1 = xcvr_reconfig_reg_dsk_depth_1_urm::type_id::create("dsk_depth_1");
         dsk_depth_1.configure(this,null,"");
         dsk_depth_1.build();
         // hdl path
         dsk_depth_1.add_hdl_path_slice("dsk_depth_1_depth0_i",0,6);
         dsk_depth_1.add_hdl_path_slice("dsk_depth_1_depth1_i",6,6);
         dsk_depth_1.add_hdl_path_slice("dsk_depth_1_depth2_i",12,6);
         dsk_depth_1.add_hdl_path_slice("dsk_depth_1_depth3_i",18,6);
         dsk_depth_1.add_hdl_path_slice("dsk_depth_1_depth4_i",24,6);
         
         // Create registers
         dsk_depth_2 = xcvr_reconfig_reg_dsk_depth_2_urm::type_id::create("dsk_depth_2");
         dsk_depth_2.configure(this,null,"");
         dsk_depth_2.build();
         // hdl path
         dsk_depth_2.add_hdl_path_slice("dsk_depth_2_depth0_i",0,6);
         dsk_depth_2.add_hdl_path_slice("dsk_depth_2_depth1_i",6,6);
         dsk_depth_2.add_hdl_path_slice("dsk_depth_2_depth2_i",12,6);
         dsk_depth_2.add_hdl_path_slice("dsk_depth_2_depth3_i",18,6);
         dsk_depth_2.add_hdl_path_slice("dsk_depth_2_depth4_i",24,6);
         
         // Create registers
         dsk_depth_3 = xcvr_reconfig_reg_dsk_depth_3_urm::type_id::create("dsk_depth_3");
         dsk_depth_3.configure(this,null,"");
         dsk_depth_3.build();
         // hdl path
         dsk_depth_3.add_hdl_path_slice("dsk_depth_3_depth0_i",0,6);
         dsk_depth_3.add_hdl_path_slice("dsk_depth_3_depth1_i",6,6);
         dsk_depth_3.add_hdl_path_slice("dsk_depth_3_depth2_i",12,6);
         dsk_depth_3.add_hdl_path_slice("dsk_depth_3_depth3_i",18,6);
         dsk_depth_3.add_hdl_path_slice("dsk_depth_3_depth4_i",24,6);
         
         // Create registers
         rx_pcs_test_err_cnt = xcvr_reconfig_reg_rx_pcs_test_err_cnt_urm::type_id::create("rx_pcs_test_err_cnt");
         rx_pcs_test_err_cnt.configure(this,null,"");
         rx_pcs_test_err_cnt.build();
         // hdl path
         rx_pcs_test_err_cnt.add_hdl_path_slice("rx_pcs_test_err_cnt_count_i",0,32);
         
         // Create registers
         dprio_control_0 = xcvr_reconfig_reg_dprio_control_urm::type_id::create("dprio_control_0");
         dprio_control_0.configure(this,null,"");
         dprio_control_0.build();
         // hdl path
         dprio_control_0.add_hdl_path_slice("dprio_control_0_dprio",0,8);
         
         // Create registers
         dprio_control_1 = xcvr_reconfig_reg_dprio_control_1_urm::type_id::create("dprio_control_1");
         dprio_control_1.configure(this,null,"");
         dprio_control_1.build();
         // hdl path
         dprio_control_1.add_hdl_path_slice("dprio_control_1_dprio",0,8);
         
         // Create registers
         dprio_control_2 = xcvr_reconfig_reg_dprio_control_2_urm::type_id::create("dprio_control_2");
         dprio_control_2.configure(this,null,"");
         dprio_control_2.build();
         // hdl path
         dprio_control_2.add_hdl_path_slice("dprio_control_2_dprio",0,8);
         
         // Create registers
         dprio_control_3 = xcvr_reconfig_reg_dprio_control_3_urm::type_id::create("dprio_control_3");
         dprio_control_3.configure(this,null,"");
         dprio_control_3.build();
         // hdl path
         dprio_control_3.add_hdl_path_slice("dprio_control_3_dprio",0,8);
         
         // Create registers
         dprio_control_4 = xcvr_reconfig_reg_dprio_control_4_urm::type_id::create("dprio_control_4");
         dprio_control_4.configure(this,null,"");
         dprio_control_4.build();
         // hdl path
         dprio_control_4.add_hdl_path_slice("dprio_control_4_dprio",0,8);
         
         // Create registers
         dprio_control_5 = xcvr_reconfig_reg_dprio_control_5_urm::type_id::create("dprio_control_5");
         dprio_control_5.configure(this,null,"");
         dprio_control_5.build();
         // hdl path
         dprio_control_5.add_hdl_path_slice("dprio_control_5_dprio",0,8);
         
      
         // Create the address map
         default_map = create_map("",  `UVM_REG_ADDR_WIDTH'h0, 1, UVM_LITTLE_ENDIAN,1);
         //this.default_map = this.default_map;
         
         //mapping
         this.default_map.add_reg(xcvrif_rst_ctrl, `UVM_REG_ADDR_WIDTH'h0, "RW");
         this.default_map.add_reg(xcvrif_ctrl0, `UVM_REG_ADDR_WIDTH'h4, "RW");
         this.default_map.add_reg(xcvrif_ctrl1, `UVM_REG_ADDR_WIDTH'h8, "RW");
         this.default_map.add_reg(xcvrif_gb_ctrl, `UVM_REG_ADDR_WIDTH'hc, "RW");
         this.default_map.add_reg(xcvrif_rxfifo_threshold, `UVM_REG_ADDR_WIDTH'h10, "RW");
         this.default_map.add_reg(xcvrif_txfifo_threshold, `UVM_REG_ADDR_WIDTH'h14, "RW");
         this.default_map.add_reg(xcvrif_tx_reset_val0, `UVM_REG_ADDR_WIDTH'h18, "RW");
         this.default_map.add_reg(xcvrif_tx_reset_val1, `UVM_REG_ADDR_WIDTH'h1c, "RW");
         this.default_map.add_reg(xcvrif_tx_reset_val2, `UVM_REG_ADDR_WIDTH'h20, "RW");
         this.default_map.add_reg(xcvrif_rxbit_stat, `UVM_REG_ADDR_WIDTH'h24, "RO");
         this.default_map.add_reg(xcvrif_tx_gbx_stat, `UVM_REG_ADDR_WIDTH'h28, "RO");
         this.default_map.add_reg(xcvrif_rx_gbx_stat, `UVM_REG_ADDR_WIDTH'h2c, "RO");
         this.default_map.add_reg(xcvrif_det_lat_cfg, `UVM_REG_ADDR_WIDTH'h30, "RW");
         this.default_map.add_reg(xcvrif_dcc_ctrl, `UVM_REG_ADDR_WIDTH'h34, "RW");
         this.default_map.add_reg(xcvrif_dcc_csr0, `UVM_REG_ADDR_WIDTH'h38, "RW");
         this.default_map.add_reg(xcvrif_dcc_csr1, `UVM_REG_ADDR_WIDTH'h3c, "RW");
         this.default_map.add_reg(xcvrif_dcc_stat, `UVM_REG_ADDR_WIDTH'h40, "RO");
         this.default_map.add_reg(xcvrif_test_ctrl, `UVM_REG_ADDR_WIDTH'h7c, "RW");
         this.default_map.add_reg(interrupt_core_to_cntl, `UVM_REG_ADDR_WIDTH'h80, "RW");
         this.default_map.add_reg(interrupt_if_reg, `UVM_REG_ADDR_WIDTH'h84, "RW");
         this.default_map.add_reg(interrupt_if_rcv_data, `UVM_REG_ADDR_WIDTH'h88, "RW");
         this.default_map.add_reg(interrupt_core_status, `UVM_REG_ADDR_WIDTH'h8c, "RO");
         this.default_map.add_reg(interrupt_if_ctrl, `UVM_REG_ADDR_WIDTH'h90, "RW");
         this.default_map.add_reg(interrupt_seq_enable, `UVM_REG_ADDR_WIDTH'h94, "RW");
         this.default_map.add_reg(interrupt_seq_0, `UVM_REG_ADDR_WIDTH'h98, "RW");
         this.default_map.add_reg(interrupt_seq_1, `UVM_REG_ADDR_WIDTH'h9c, "RW");
         this.default_map.add_reg(interrupt_seq_2, `UVM_REG_ADDR_WIDTH'ha0, "RW");
         this.default_map.add_reg(interrupt_seq_3, `UVM_REG_ADDR_WIDTH'ha4, "RW");
         this.default_map.add_reg(interrupt_seq_4, `UVM_REG_ADDR_WIDTH'ha8, "RW");
         this.default_map.add_reg(interrupt_seq_5, `UVM_REG_ADDR_WIDTH'hac, "RW");
         this.default_map.add_reg(interrupt_seq_6, `UVM_REG_ADDR_WIDTH'hb0, "RW");
         this.default_map.add_reg(interrupt_seq_7, `UVM_REG_ADDR_WIDTH'hb4, "RW");
         this.default_map.add_reg(interrupt_seq_8, `UVM_REG_ADDR_WIDTH'hb8, "RW");
         this.default_map.add_reg(interrupt_seq_9, `UVM_REG_ADDR_WIDTH'hbc, "RW");
         this.default_map.add_reg(interrupt_seq_10, `UVM_REG_ADDR_WIDTH'hc0, "RW");
         this.default_map.add_reg(interrupt_seq_11, `UVM_REG_ADDR_WIDTH'hc4, "RW");
         this.default_map.add_reg(interrupt_seq_12, `UVM_REG_ADDR_WIDTH'hc8, "RW");
         this.default_map.add_reg(interrupt_seq_13, `UVM_REG_ADDR_WIDTH'hcc, "RW");
         this.default_map.add_reg(interrupt_seq_14, `UVM_REG_ADDR_WIDTH'hd0, "RW");
         this.default_map.add_reg(interrupt_seq_15, `UVM_REG_ADDR_WIDTH'hd4, "RW");
         this.default_map.add_reg(interrupt_seq_16, `UVM_REG_ADDR_WIDTH'hd8, "RW");
         this.default_map.add_reg(interrupt_seq_17, `UVM_REG_ADDR_WIDTH'hdc, "RW");
         this.default_map.add_reg(interrupt_seq_18, `UVM_REG_ADDR_WIDTH'he0, "RW");
         this.default_map.add_reg(interrupt_seq_19, `UVM_REG_ADDR_WIDTH'he4, "RW");
         this.default_map.add_reg(interrupt_seq_serdes_en, `UVM_REG_ADDR_WIDTH'he8, "RW");
         this.default_map.add_reg(xcvr_refclk_sel, `UVM_REG_ADDR_WIDTH'hec, "RW");
         this.default_map.add_reg(xcvr_hwdec, `UVM_REG_ADDR_WIDTH'hfc, "RW");
         this.default_map.add_reg(r_usr_outbox, `UVM_REG_ADDR_WIDTH'h200, "RW");
         this.default_map.add_reg(r_usr_inbox, `UVM_REG_ADDR_WIDTH'h204, "RW");
         this.default_map.add_reg(r_dprio0_tx, `UVM_REG_ADDR_WIDTH'h208, "RW");
         this.default_map.add_reg(r_dprio1_tx, `UVM_REG_ADDR_WIDTH'h20c, "RW");
         this.default_map.add_reg(r_dprio2_tx, `UVM_REG_ADDR_WIDTH'h210, "RW");
         this.default_map.add_reg(r_dprio3_tx, `UVM_REG_ADDR_WIDTH'h214, "RW");
         this.default_map.add_reg(r_dprio0_rx, `UVM_REG_ADDR_WIDTH'h218, "RW");
         this.default_map.add_reg(r_dprio1_rx, `UVM_REG_ADDR_WIDTH'h21c, "RW");
         this.default_map.add_reg(r_dprio2_rx, `UVM_REG_ADDR_WIDTH'h220, "RW");
         this.default_map.add_reg(r_dprio3_rx, `UVM_REG_ADDR_WIDTH'h224, "RW");
         this.default_map.add_reg(r_dprio4_rx, `UVM_REG_ADDR_WIDTH'h228, "RW");
         this.default_map.add_reg(r_dprio_status, `UVM_REG_ADDR_WIDTH'h22c, "RO");
         this.default_map.add_reg(r_aibdprio0, `UVM_REG_ADDR_WIDTH'h230, "RW");
         this.default_map.add_reg(r_aibdprio1, `UVM_REG_ADDR_WIDTH'h234, "RW");
         this.default_map.add_reg(r_dprio_sr, `UVM_REG_ADDR_WIDTH'h238, "RW");
         this.default_map.add_reg(r_dprio_avmm1, `UVM_REG_ADDR_WIDTH'h23c, "RW");
         this.default_map.add_reg(r_dprio_avmm2, `UVM_REG_ADDR_WIDTH'h240, "RW");
         this.default_map.add_reg(r_spare0, `UVM_REG_ADDR_WIDTH'h2fc, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_300, `UVM_REG_ADDR_WIDTH'h300, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_304, `UVM_REG_ADDR_WIDTH'h304, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_308, `UVM_REG_ADDR_WIDTH'h308, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_30C, `UVM_REG_ADDR_WIDTH'h30c, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_310, `UVM_REG_ADDR_WIDTH'h310, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_314, `UVM_REG_ADDR_WIDTH'h314, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_31C, `UVM_REG_ADDR_WIDTH'h31c, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_320, `UVM_REG_ADDR_WIDTH'h320, "RW");
         this.default_map.add_reg(hssi_pldadapt_tx_324, `UVM_REG_ADDR_WIDTH'h324, "RW");
         this.default_map.add_reg(hssi_aibnd_32B, `UVM_REG_ADDR_WIDTH'h32b, "RW");
         this.default_map.add_reg(hssi_ppt_rx_chnl_330, `UVM_REG_ADDR_WIDTH'h330, "RW");
         this.default_map.add_reg(phy_revid, `UVM_REG_ADDR_WIDTH'h6400, "RO");
         this.default_map.add_reg(phy_scratch, `UVM_REG_ADDR_WIDTH'h6401, "RW");
         this.default_map.add_reg(phy_name_0, `UVM_REG_ADDR_WIDTH'h6402, "RO");
         this.default_map.add_reg(phy_name_1, `UVM_REG_ADDR_WIDTH'h6403, "RO");
         this.default_map.add_reg(phy_name_2, `UVM_REG_ADDR_WIDTH'h6404, "RO");
         this.default_map.add_reg(phy_ehip_mode_muxes, `UVM_REG_ADDR_WIDTH'h640d, "RW");
         this.default_map.add_reg(phy_ehip_pcs_modes, `UVM_REG_ADDR_WIDTH'h640e, "RW");
         this.default_map.add_reg(phy_ehip_clock_gating, `UVM_REG_ADDR_WIDTH'h640f, "RW");
         this.default_map.add_reg(phy_config, `UVM_REG_ADDR_WIDTH'h6410, "RW");
         this.default_map.add_reg(phy_pma_sloop, `UVM_REG_ADDR_WIDTH'h6413, "RW");
         this.default_map.add_reg(phy_tx_pll_locked, `UVM_REG_ADDR_WIDTH'h6420, "RO");
         this.default_map.add_reg(phy_eiofreq_locked, `UVM_REG_ADDR_WIDTH'h6421, "RO");
         this.default_map.add_reg(phy_tx_corepll_locked, `UVM_REG_ADDR_WIDTH'h6422, "RO");
         this.default_map.add_reg(phy_frame_error, `UVM_REG_ADDR_WIDTH'h6423, "RO");
         this.default_map.add_reg(phy_sclr_frame_error, `UVM_REG_ADDR_WIDTH'h6424, "RW");
         this.default_map.add_reg(phy_eio_sftreset, `UVM_REG_ADDR_WIDTH'h6425, "RW");
         this.default_map.add_reg(phy_rxpcs_status, `UVM_REG_ADDR_WIDTH'h6426, "RO");
         this.default_map.add_reg(err_inj, `UVM_REG_ADDR_WIDTH'h6427, "RW");
         this.default_map.add_reg(am_lock, `UVM_REG_ADDR_WIDTH'h6428, "RO");
         this.default_map.add_reg(lanes_deskewed, `UVM_REG_ADDR_WIDTH'h6429, "RO");
         this.default_map.add_reg(ber_count, `UVM_REG_ADDR_WIDTH'h642a, "RO");
         this.default_map.add_reg(pcs_vlane_0, `UVM_REG_ADDR_WIDTH'h6430, "RO");
         this.default_map.add_reg(pcs_vlane_1, `UVM_REG_ADDR_WIDTH'h6431, "RO");
         this.default_map.add_reg(pcs_vlane_2, `UVM_REG_ADDR_WIDTH'h6432, "RO");
         this.default_map.add_reg(pcs_vlane_3, `UVM_REG_ADDR_WIDTH'h6433, "RO");
         this.default_map.add_reg(phy_refclk_khz, `UVM_REG_ADDR_WIDTH'h6440, "RO");
         this.default_map.add_reg(phy_recclk_khz, `UVM_REG_ADDR_WIDTH'h6441, "RO");
         this.default_map.add_reg(phy_txclk_khz, `UVM_REG_ADDR_WIDTH'h6442, "RO");
         this.default_map.add_reg(tx_pld_conf, `UVM_REG_ADDR_WIDTH'h6450, "RW");
         this.default_map.add_reg(tx_pld_status, `UVM_REG_ADDR_WIDTH'h6451, "RO");
         this.default_map.add_reg(phy_rxpma_status, `UVM_REG_ADDR_WIDTH'h6454, "RO");
         this.default_map.add_reg(rx_pld_conf, `UVM_REG_ADDR_WIDTH'h6455, "RW");
         this.default_map.add_reg(rx_pld_status, `UVM_REG_ADDR_WIDTH'h6456, "RO");
         this.default_map.add_reg(rxpcs_conf, `UVM_REG_ADDR_WIDTH'h6460, "RW");
         this.default_map.add_reg(bip_counter_0, `UVM_REG_ADDR_WIDTH'h6461, "RO");
         this.default_map.add_reg(bip_counter_1, `UVM_REG_ADDR_WIDTH'h6462, "RO");
         this.default_map.add_reg(bip_counter_2, `UVM_REG_ADDR_WIDTH'h6463, "RO");
         this.default_map.add_reg(bip_counter_3, `UVM_REG_ADDR_WIDTH'h6464, "RO");
         this.default_map.add_reg(bip_counter_4, `UVM_REG_ADDR_WIDTH'h6465, "RO");
         this.default_map.add_reg(bip_counter_5, `UVM_REG_ADDR_WIDTH'h6466, "RO");
         this.default_map.add_reg(bip_counter_6, `UVM_REG_ADDR_WIDTH'h6467, "RO");
         this.default_map.add_reg(bip_counter_7, `UVM_REG_ADDR_WIDTH'h6468, "RO");
         this.default_map.add_reg(bip_counter_8, `UVM_REG_ADDR_WIDTH'h6469, "RO");
         this.default_map.add_reg(bip_counter_9, `UVM_REG_ADDR_WIDTH'h646a, "RO");
         this.default_map.add_reg(bip_counter_10, `UVM_REG_ADDR_WIDTH'h646b, "RO");
         this.default_map.add_reg(bip_counter_11, `UVM_REG_ADDR_WIDTH'h646c, "RO");
         this.default_map.add_reg(bip_counter_12, `UVM_REG_ADDR_WIDTH'h646d, "RO");
         this.default_map.add_reg(bip_counter_13, `UVM_REG_ADDR_WIDTH'h646e, "RO");
         this.default_map.add_reg(bip_counter_14, `UVM_REG_ADDR_WIDTH'h646f, "RO");
         this.default_map.add_reg(bip_counter_15, `UVM_REG_ADDR_WIDTH'h6470, "RO");
         this.default_map.add_reg(bip_counter_16, `UVM_REG_ADDR_WIDTH'h6471, "RO");
         this.default_map.add_reg(bip_counter_17, `UVM_REG_ADDR_WIDTH'h6472, "RO");
         this.default_map.add_reg(bip_counter_18, `UVM_REG_ADDR_WIDTH'h6473, "RO");
         this.default_map.add_reg(bip_counter_19, `UVM_REG_ADDR_WIDTH'h6474, "RO");
         this.default_map.add_reg(am_encoding_0, `UVM_REG_ADDR_WIDTH'h6476, "RW");
         this.default_map.add_reg(am_encoding_1, `UVM_REG_ADDR_WIDTH'h6477, "RW");
         this.default_map.add_reg(am_encoding_2, `UVM_REG_ADDR_WIDTH'h6478, "RW");
         this.default_map.add_reg(am_encoding_3, `UVM_REG_ADDR_WIDTH'h6479, "RW");
         this.default_map.add_reg(xus_timer_window, `UVM_REG_ADDR_WIDTH'h647a, "RW");
         this.default_map.add_reg(ber_invalid_count, `UVM_REG_ADDR_WIDTH'h647b, "RW");
         this.default_map.add_reg(err_block_cnt, `UVM_REG_ADDR_WIDTH'h647c, "RO");
         this.default_map.add_reg(rx_pcs_int_err, `UVM_REG_ADDR_WIDTH'h647d, "RO");
         this.default_map.add_reg(rx_pcs_int_err_mask, `UVM_REG_ADDR_WIDTH'h647e, "RW");
         this.default_map.add_reg(dsk_depth_0, `UVM_REG_ADDR_WIDTH'h647f, "RO");
         this.default_map.add_reg(dsk_depth_1, `UVM_REG_ADDR_WIDTH'h6480, "RO");
         this.default_map.add_reg(dsk_depth_2, `UVM_REG_ADDR_WIDTH'h6481, "RO");
         this.default_map.add_reg(dsk_depth_3, `UVM_REG_ADDR_WIDTH'h6482, "RO");
         this.default_map.add_reg(rx_pcs_test_err_cnt, `UVM_REG_ADDR_WIDTH'h6483, "RO");
         this.default_map.add_reg(dprio_control_0, `UVM_REG_ADDR_WIDTH'h6484, "RW");
         this.default_map.add_reg(dprio_control_1, `UVM_REG_ADDR_WIDTH'h6485, "RW");
         this.default_map.add_reg(dprio_control_2, `UVM_REG_ADDR_WIDTH'h6486, "RW");
         this.default_map.add_reg(dprio_control_3, `UVM_REG_ADDR_WIDTH'h6487, "RW");
         this.default_map.add_reg(dprio_control_4, `UVM_REG_ADDR_WIDTH'h6488, "RW");
         this.default_map.add_reg(dprio_control_5, `UVM_REG_ADDR_WIDTH'h6489, "RW");
         
         void'(set_coverage(UVM_CVR_FIELD_VALS));
         
      endfunction : build

endclass : xcvr_reconfig_urm


`endif //__XCVR_RECONFIG_URM_SVH__
