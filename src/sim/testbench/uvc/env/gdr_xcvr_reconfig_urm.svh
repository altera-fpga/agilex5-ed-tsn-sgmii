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



// Class: gdr_barak_quad
//------------------------------------------------------------------------------
class gdr_xcvr_reconfig_urm extends uvm_reg_block;
   `uvm_object_utils(gdr_xcvr_reconfig_urm)

   //---------------------------------------------------------------------------
   // Group: Variables
   //---------------------------------------------------------------------------
   //
   // URM Sub-instance
   //
   rand gdr_barak_quad_urm                      u_gdr_barak_quad_urm;
   rand gdr_ux_quad_avmm_cfgcsr_urm             u_gdr_ux_quad_urm;
   
   //
   // Knobs that can be used to disable the creation of the URM instance
   // Default is enabled!
   //
   bit                                          u_barak_quad_disable = 1;
   bit                                          u_ux_quad_disable = 1;
   //
   // Address map instances
   //
   uvm_reg_map                                  config_map;

   //---------------------------------------------------------------------------
   // UVM Methods
   //---------------------------------------------------------------------------
   //
   // Function: new
   //    Class contructor
   //
   // Parameters:
   //    - name : class's string based name
   //
   function new (string n = "gdr_xcvr_reconfig_urm");
      super.new(n, build_coverage(UVM_CVR_ALL));
   endfunction : new
   //
   // Function: build
   //    Build function
   //
   function void build();
      //
      // Create address map(s)
      //
      config_map  = create_map("config_map", `UVM_REG_ADDR_WIDTH'h0, 4, UVM_LITTLE_ENDIAN, 1);
      default_map = config_map;
      `uvm_info(get_type_name(), {"get_full_name() = ", get_full_name()}, UVM_MEDIUM)
      //
      // Construct Sub-URM instances
      //
      if (!uvm_config_db#(bit)::get(null, get_full_name(), "u_barak_quad_disable", u_barak_quad_disable))
      begin
         u_barak_quad_disable = 0;
      end
      `uvm_info("gdr_bk_quad_urm", $sformatf("BK u_barak_quad_disable: 'h%h", u_barak_quad_disable), UVM_MEDIUM);
      if (!u_barak_quad_disable)
      begin
         u_gdr_barak_quad_urm = gdr_barak_quad_urm::type_id::create("u_gdr_barak_quad_urm",,get_full_name());
         u_gdr_barak_quad_urm.configure(this);
         u_gdr_barak_quad_urm.build();
         config_map.add_submap(u_gdr_barak_quad_urm.config_map, `BK_QUAD_TOP_BASE_ADDR);
         `uvm_info("gdr_bk_quad_urm", $sformatf("BK QUAD Address Map Offset: 'h%h", config_map.get_submap_offset(u_gdr_barak_quad_urm.default_map)), UVM_MEDIUM);
      end
      else
      begin
         u_gdr_barak_quad_urm.rand_mode(0);
      end
      if (!uvm_config_db#(bit)::get(null, get_full_name(), "u_ux_quad_disable", u_ux_quad_disable))
      begin
         u_ux_quad_disable = 0;
      end
      `uvm_info("gdr_ux_quad_urm", $sformatf("UX u_ux_quad_disable: 'h%h", u_ux_quad_disable), UVM_MEDIUM);
      if (!u_ux_quad_disable)
      begin
         u_gdr_ux_quad_urm = gdr_ux_quad_avmm_cfgcsr_urm::type_id::create("u_gdr_ux_quad_urm",,get_full_name());
         u_gdr_ux_quad_urm.configure(this);
         u_gdr_ux_quad_urm.build();
         config_map.add_submap(u_gdr_ux_quad_urm.default_map, `UX_QUAD_TOP_BASE_ADDR);
         `uvm_info("gdr_ux_quad_urm", $sformatf("UX QUAD Address Map Offset: 'h%h", config_map.get_submap_offset(u_gdr_ux_quad_urm.default_map)), UVM_MEDIUM);
      end
      else
      begin
         u_gdr_ux_quad_urm.rand_mode(0);
      end
   endfunction : build
   //
   // Function : set_hdl_path_root
   // Override the base's set_hdl_path_root() and call the subsequent
   // URM block's set_hdl_path_root
   //
   function void set_hdl_path_root (string path, string kind = "RTL");
      super.set_hdl_path_root(path, kind);
      if (!u_barak_quad_disable)
      begin
         u_gdr_barak_quad_urm.set_hdl_path_root({path, ".u_gdr_barak_quad_urm"}, kind);
      end
      if (!u_ux_quad_disable)
      begin
         u_gdr_ux_quad_urm.set_hdl_path_root({path, ".u_gdr_ux_quad_urm"}, kind);
      end
   endfunction : set_hdl_path_root

endclass : gdr_xcvr_reconfig_urm
