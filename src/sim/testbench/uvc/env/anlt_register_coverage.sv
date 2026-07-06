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


//
// Template for UVM-compliant Coverage Class
//
`ifndef ANLT_REGISTER_COVERAGE__SV
`define ANLT_REGISTER_COVERAGE__SV

`define POST_MAX_VALUE 25
`define PRE_MAX_VALUE 16
`define MIN_VALUE 14
`define LT_LD_OVERIDE_COEFF_REGISTER(name,addr,address,data)\
	LT_``name``_LD_overide_coeff_register_cp : coverpoint data iff(addr == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) {\
	  wildcard bins LD_pre_overide_coeff_reserved_``name``_bin = {8'b????_??11};\
	  wildcard bins LD_pre_overide_coeff_inc_``name``_bin = {8'b????_??01};\
	  wildcard bins LD_pre_overide_coeff_dec_``name``_bin = {8'b????_??10};\
	  wildcard bins LD_pre_overide_coeff_hold_``name``_bin = {8'b????_??00};\
	  wildcard bins LD_zero_overide_coeff_reserved_``name``_bin = {8'b????_11??};\
	  wildcard bins LD_zero_overide_coeff_inc_``name``_bin = {8'b????_01??};\
	  wildcard bins LD_zero_overide_coeff_dec_``name``_bin = {8'b????_10??};\
	  wildcard bins LD_zero_overide_coeff_hold_``name``_bin = {8'b????_00??};\
	  wildcard bins LD_post_overide_coeff_reserved_``name``_bin = {8'b??11_????};\
	  wildcard bins LD_post_overide_coeff_inc_``name``_bin = {8'b??01_????};\
	  wildcard bins LD_post_overide_coeff_dec_``name``_bin = {8'b??10_????};\
	  wildcard bins LD_post_overide_coeff_hold_``name``_bin = {8'b??00_????};\
	  wildcard bins LD_init_coeff_``name``_bin_0 = {8'b?0??_????};\
	  wildcard bins LD_init_coeff_``name``_bin_1 = {8'b?1??_????};\
	  wildcard bins LD_preset_coeff_``name``_bin_0 = {8'b0???_????};\
	  wildcard bins LD_preset_coeff_``name``_bin_1 = {8'b1???_????};\
	}
`define LT_LD_COEFF_REGISTER(name,addr,address,data)\
	LT_``name``_LD_coeff_register_cp : coverpoint data iff(addr == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ ) {\
	  wildcard bins LD_pre_coeff_reserved_``name``_bin = {8'b????_??11};\
	  wildcard bins LD_pre_coeff_inc_``name``_bin = {8'b????_??01};\
	  wildcard bins LD_pre_coeff_dec_``name``_bin = {8'b????_??10};\
	  wildcard bins LD_pre_coeff_hold_``name``_bin = {8'b????_??00};\
	  wildcard bins LD_zero_coeff_reserved_``name``_bin = {8'b????_11??};\
	  wildcard bins LD_zero_coeff_inc_``name``_bin = {8'b????_01??};\
	  wildcard bins LD_zero_coeff_dec_``name``_bin = {8'b????_10??};\
	  wildcard bins LD_zero_coeff_hold_``name``_bin = {8'b????_00??};\
	  wildcard bins LD_post_coeff_reserved_``name``_bin = {8'b??11_????};\
	  wildcard bins LD_post_coeff_inc_``name``_bin = {8'b??01_????};\
	  wildcard bins LD_post_coeff_dec_``name``_bin = {8'b??10_????};\
	  wildcard bins LD_post_coeff_hold_``name``_bin = {8'b??00_????};\
	  wildcard bins LD_receiver_ready_``name``_bin_0 = {8'b?0??_????};\
	  wildcard bins LD_receiver_ready_``name``_bin_1 = {8'b?1??_????};\
	}
`define LT_LP_OVERIDE_COEFF_REGISTER(name,addr,address,data)\
	LT_``name``_LP_overide_coeff_register_cp : coverpoint data iff(addr == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) {\
	  wildcard bins LP_pre_overide_coeff_reserved_``name``_bin = {8'b????_??11};\
	  wildcard bins LP_pre_overide_coeff_inc_``name``_bin = {8'b????_??01};\
	  wildcard bins LP_pre_overide_coeff_dec_``name``_bin = {8'b????_??10};\
	  wildcard bins LP_pre_overide_coeff_hold_``name``_bin = {8'b????_??00};\
	  wildcard bins LP_zero_overide_coeff_reserved_``name``_bin = {8'b????_11??};\
	  wildcard bins LP_zero_overide_coeff_inc_``name``_bin = {8'b????_01??};\
	  wildcard bins LP_zero_overide_coeff_dec_``name``_bin = {8'b????_10??};\
	  wildcard bins LP_zero_overide_coeff_hold_``name``_bin = {8'b????_00??};\
	  wildcard bins LP_post_overide_coeff_reserved_``name``_bin = {8'b??11_????};\
	  wildcard bins LP_post_overide_coeff_inc_``name``_bin = {8'b??01_????};\
	  wildcard bins LP_post_overide_coeff_dec_``name``_bin = {8'b??10_????};\
	  wildcard bins LP_post_overide_coeff_hold_``name``_bin = {8'b??00_????};\
	  wildcard bins LP_init_coeff_``name``_bin_0 = {8'b?0??_????};\
	  wildcard bins LP_init_coeff_``name``_bin_1 = {8'b?1??_????};\
	  wildcard bins LP_preset_coeff_``name``_bin_0 = {8'b0???_????};\
	  wildcard bins LP_preset_coeff_``name``_bin_1 = {8'b1???_????};\
  }
`define LT_LP_COEFF_REGISTER(name,addr,address,data)\
	LT_``name``_LP_coeff_register_cp : coverpoint data iff(addr == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ ) {\
	  wildcard bins LP_pre_coeff_reserved_``name``_bin = {8'b????_??11};\
	  wildcard bins LP_pre_coeff_inc_``name``_bin = {8'b????_??01};\
	  wildcard bins LP_pre_coeff_dec_``name``_bin = {8'b????_??10};\
	  wildcard bins LP_pre_coeff_hold_``name``_bin = {8'b????_??00};\
	  wildcard bins LP_zero_coeff_reserved_``name``_bin = {8'b????_11??};\
	  wildcard bins LP_zero_coeff_inc_``name``_bin = {8'b????_01??};\
	  wildcard bins LP_zero_coeff_dec_``name``_bin = {8'b????_10??};\
	  wildcard bins LP_zero_coeff_hold_``name``_bin = {8'b????_00??};\
	  wildcard bins LP_post_coeff_reserved_``name``_bin = {8'b??11_????};\
	  wildcard bins LP_post_coeff_inc_``name``_bin = {8'b??01_????};\
	  wildcard bins LP_post_coeff_dec_``name``_bin = {8'b??10_????};\
	  wildcard bins LP_post_coeff_hold_``name``_bin = {8'b??00_????};\
	  wildcard bins LP_receiver_ready_``name``_bin_0 = {8'b?0??_????};\
	  wildcard bins LP_receiver_ready_``name``_bin_1 = {8'b?1??_????};\
	}
`define WRITE_AN_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE && addr == trans.address)\
         {\
           wildcard bins one0 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1};\
           wildcard bins one1 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x};\
           wildcard bins one2 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx};\
           wildcard bins one3 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx};\
           wildcard bins one4 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx};\
           wildcard bins one5 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx};\
           wildcard bins one6 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx};\
           wildcard bins one7 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx};\
           wildcard bins one8 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx};\
           wildcard bins one9 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx};\
           wildcard bins one10 = {32'bxxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx};\
           wildcard bins one11 = {32'bxxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx};\
           wildcard bins one12 = {32'bxxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx};\
           wildcard bins one13 = {32'bxxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx};\
           wildcard bins one14 = {32'bxxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx};\
           wildcard bins one15 = {32'bxxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx};\
           wildcard bins one16 = {32'bxxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx};\
           wildcard bins one17 = {32'bxxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx};\
           wildcard bins one18 = {32'bxxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one19 = {32'bxxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one20 = {32'bxxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one21 = {32'bxxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one22 = {32'bxxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one23 = {32'bxxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one24 = {32'bxxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one25 = {32'bxxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one26 = {32'bxxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one27 = {32'bxxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one28 = {32'bxxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one29 = {32'bxx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one30 = {32'bx1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins one31 = {32'b1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero0 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx0};\
           wildcard bins zero1 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx0x};\
           wildcard bins zero2 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx0xx};\
           wildcard bins zero3 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx0xxx};\
           wildcard bins zero4 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx0xxxx};\
           wildcard bins zero5 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx0xxxxx};\
           wildcard bins zero6 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x0xxxxxx};\
           wildcard bins zero7 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_0xxxxxxx};\
           wildcard bins zero8 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxx0_xxxxxxxx};\
           wildcard bins zero9 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxx0x_xxxxxxxx};\
           wildcard bins zero10 = {32'bxxxxxxxx_xxxxxxxx_xxxxx0xx_xxxxxxxx};\
           wildcard bins zero11 = {32'bxxxxxxxx_xxxxxxxx_xxxx0xxx_xxxxxxxx};\
           wildcard bins zero12 = {32'bxxxxxxxx_xxxxxxxx_xxx0xxxx_xxxxxxxx};\
           wildcard bins zero13 = {32'bxxxxxxxx_xxxxxxxx_xx0xxxxx_xxxxxxxx};\
           wildcard bins zero14 = {32'bxxxxxxxx_xxxxxxxx_x0xxxxxx_xxxxxxxx};\
           wildcard bins zero15 = {32'bxxxxxxxx_xxxxxxxx_0xxxxxxx_xxxxxxxx};\
           wildcard bins zero16 = {32'bxxxxxxxx_xxxxxxx0_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero17 = {32'bxxxxxxxx_xxxxxx0x_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero18 = {32'bxxxxxxxx_xxxxx0xx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero19 = {32'bxxxxxxxx_xxxx0xxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero20 = {32'bxxxxxxxx_xxx0xxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero21 = {32'bxxxxxxxx_xx0xxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero22 = {32'bxxxxxxxx_x0xxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero23 = {32'bxxxxxxxx_0xxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero24 = {32'bxxxxxxx0_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero25 = {32'bxxxxxx0x_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero26 = {32'bxxxxx0xx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero27 = {32'bxxxx0xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero28 = {32'bxxx0xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero29 = {32'bxx0xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero30 = {32'bx0xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           wildcard bins zero31 = {32'b0xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
         } 

`define READ_RW_REG_COV(name,addr,address,data,rst_data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == trans.address)\
         {\
         bins reset= {rst_data};\
         bins non_reset= {['h1:'hFFFF_FFFF]} with (!(item inside {rst_data}));\
   }

`define READ_RO_REG_COV(name,addr,address,data,rst_data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == trans.address)\
         {\
	         bins reset= {rst_data};\
         }

`uvm_analysis_imp_decl(_avmm_bus_anlt)

class anlt_register_coverage extends uvm_component;
 
  virtual spy_interface spy_if;
  bit register_cov_enable=1;
  bit [63:0] address;
  bit dis_reg_cov;
  bit frame_xfer_active;
  eth_anlt_f_csr_doc_urm anlt_reg_model;
  altuvm_avalon_mm_req_base trans;
  kr_cfg kr_cfg_inst;
//  registers_urm base_reg_model;

  //Port: avmm_bus
  //This port receives the avmm item from monitor
 uvm_analysis_imp_avmm_bus_anlt #(altuvm_avalon_mm_req_base, anlt_register_coverage) avmm_bus_anlt;

  `uvm_component_utils(anlt_register_coverage)

//==============================================================================
// Function: build_phase
//==============================================================================
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
//   kr_cfg_inst = kr_cfg::type_id::create("kr_cfg_inst", this);
//    env_ip             = new[1]; 

//      env_ip[0] = eth_env_env::type_id::create($sformatf("env_ip%0d", 0), this);
//    if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_vif", spy_if)) begin
`ifdef COV
  `ifdef ANLT
    if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
       `uvm_fatal("spy_interface", "failed to get spy_interface intf");
     end
`endif
`endif
   if(!uvm_config_db#(kr_cfg)::get(this, "", "kr_cfg_inst", kr_cfg_inst)) begin 
      `uvm_fatal("kr_cfg", "failed to get kr_cfginst object from test");
   end 
    if (!uvm_config_db#()::get(this,"","register_cov_enable",register_cov_enable)) begin
      `uvm_info("ANLT_Register_Coverage","ANLT Register Coverage is enable",UVM_MEDIUM);
    end
endfunction:build_phase


/* Gets the register or field value from ral and return as  bit vector*/
function int get_anlt_reg_field(string reg_name, string field_name = "");
    uvm_reg_field reg_field;
    uvm_reg       reg_select;

     reg_select = anlt_reg_model.get_reg_by_name(reg_name);
     if(field_name == "")
       return reg_select.get();
     else begin
       reg_field = reg_select.get_field_by_name(field_name);
       return reg_field.get();
     end
endfunction:get_anlt_reg_field

function int get_anlt_reg_offset(string reg_name);
    uvm_reg     reg_select;

    reg_select = anlt_reg_model.get_reg_by_name(reg_name);
    return reg_select.get_offset();

endfunction:get_anlt_reg_offset

/* Gets the register or field value from ral and return as  bit vector*/
function int get_anlt_reg_mirr_val(string reg_name, string field_name="");
    uvm_reg_field reg_field;
    uvm_reg reg_select;
    
    reg_select = anlt_reg_model.get_reg_by_name(reg_name);
    if(field_name == "") 
      return reg_select.get_mirrored_value();
    else begin
      reg_field  = reg_select.get_field_by_name(field_name);
      return reg_field.get_mirrored_value();
    end
endfunction

//function int gdr_ral_f_all_get(string regname, string fldname="");
//    uvm_reg_field fld_l;
//    uvm_reg reg_l;
//    uvm_reg regs[$];
//    reg_model.default_map.get_registers(regs);
//    foreach(regs[i]) begin
////      $display("Inside gdr_ral_f_all :%0s",regs[i].get_name());
//      if (regname == regs[i].get_name()) begin
//        reg_l = regs[i]; 
////      $display("Inside gdr_ral_f_all, value of register is :%0d",regs[i].get());
//        if(fldname == "") return reg_l.get();
//        else begin
//          fld_l  = reg_l.get_field_by_name(fldname);
////          $display("Inside gdr_ral_f_all, register field is :%0s",fld_l.get_name());
////          $display("Inside gdr_ral_f_all, value is :%0d",fld_l.get());
//          return fld_l.get();
//        end
//      end
//    end
//    `uvm_fatal("register_coverage", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
//endfunction

`ifdef ANLT
  `ifdef COV
covergroup anlt_register_cov;

//Register: seq_cfg   
   reset_seq_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"reset_seq")} {
      bins reset_0 = {0};
      bins reset_1 = {1};
   }
   disable_an_timer_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"disable_an_timer")} {
      bins  enable_an_timer = {0};
      bins  disable_an_timer = {1};
   }
   disable_lf_timer_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"disable_lf_timer")} {
      bins  enable_lf_timer = {0};
      bins  disable_lf_timer = {1};
   }
   seq_force_mode_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"seq_force_mode")} {
      bins  mode_no_force = {4'h0};
      bins  mode_10G_R1 = {4'h1};
      bins  mode_25G_R1 = {4'h2};
      bins  mode_50G_R2 = {4'h3};
      bins  mode_100G_R4 = {4'h4};
      bins  mode_40G_R4 = {4'h5};
      bins  mode_100G_R2 = {4'h6};
      bins  mode_50G_R1 = {4'h7};
      bins  mode_200G_R4 = {4'h8};
      bins  mode_400G_R8 = {4'h9};
      bins  mode_100G_R1 = {4'hA};
      bins  mode_200G_R2 = {4'hB};
      bins  mode_400G_R4 = {4'hC};
   }
   lf_failure_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"lt_failure_response")} {
      bins  lt_failure_response_0 = {0};
      bins  lt_failure_response_1 = {1};
   }
   link_fail_if_hiber_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"link_fail_if_hiber")} {
      bins  link_fail_if_hiber_0 = {0};
      bins  link_fail_if_hiber_1 = {1};
   }
   skip_lt_on_an_timeout_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"skip_lt_on_an_timeout")} {
      bins  skip_lt_on_an_timeout_0 = {0};
      bins  skip_lt_on_an_timeout_1 = {1};
   }
   kr_pause_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"kr_pause")} {
      bins  kr_pause_0 = {0};
      bins  kr_pause_1 = {1};
   }
//Register: seq_status   
   seq_link_ready_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_status"),"seq_link_ready")} {
      bins  seq_link_ready_0 = {0};
      bins  seq_link_ready_1 = {1};
   }
   seq_an_timeout_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_status"),"seq_an_timeout")} {
      bins  seq_an_timeout_0 = {0};
      bins  seq_an_timeout_1 = {1};
   }
   seq_lt_timeout_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_status"),"seq_lt_timeout")} {
      bins  seq_lt_timeout_0 = {0};
      bins  seq_lt_timeout_1 = {1};
   }
   seq_reconfig_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_status"),"seq_reconfig_mode")} {
      bins  mode_AN = {14'h0001};
      bins  mode_LT = {14'h0002};
      bins  mode_10G = {14'h0004};
      bins  mode_25G = {14'h0008};
      bins  mode_50G_R2 = {14'h0010};
      bins  mode_100G_R4 = {14'h0020};
      bins  mode_40G_R4 = {14'h0040};
      bins  mode_100G_R2 = {14'h0080};
      bins  mode_50G_R1 = {14'h0100};
      bins  mode_200G_R4 = {14'h0200};
      bins  mode_400G_R8 = {14'h0400};
      bins  mode_100G_R1 = {14'h0800};
      bins  mode_200G_R2 = {14'h1000};
      bins  mode_400G_R4 = {14'h2000};
   }
   kr_paused_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_status"),"kr_paused")} {
      bins  kr_paused_0 = {0};
      bins  kr_paused_1 = {1};
   }

//Register: an_cfg1
   enable_an_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"enable_an")} {
      bins  disable_an = {0};
      bins  enable_an = {1};
   }
   an_base_pages_ctrl_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"an_base_pages_ctrl")} {
      bins  an_base_pages_ctrl_0 = {0};
      bins  an_base_pages_ctrl_1 = {1};
   }
   an_next_pages_ctrl_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"an_next_pages_ctrl")} {
      bins  an_next_pages_ctrl_0 = {0};
      bins  an_next_pages_ctrl_1 = {1};
   }
   local_device_remote_fault_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"local_device_remote_fault")} {
      bins  local_device_remote_fault_0 = {0};
      bins  local_device_remote_fault_1 = {1};
   }
   override_an_parameters_enable_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"override_an_parameters_enable")} {
      bins  override_an_parameters_enable_0 = {0};
      bins  override_an_parameters_enable_1 = {1};
   }
   override_an_chan_enable_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"override_an_chan_enable")} {
      bins  override_an_chan_enable_0 = {0};
      bins  override_an_chan_enable_1 = {1};
   }
   ignore_nonce_field_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"ignore_nonce_field")} {
      bins  ignore_nonce_field_0 = {0};
      bins  ignore_nonce_field_1 = {1};
   }
   enable_consortium_next_page_send_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"enable_consortium_next_page_send")} {
      bins  enable_consortium_next_page_send_0 = {0};
      bins  enable_consortium_next_page_send_1 = {1};
   }
   enable_consortium_next_page_receive_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"enable_consortium_next_page_receive")} {
      bins  enable_consortium_next_page_receive_0 = {0};
      bins  enable_consortium_next_page_receive_1 = {1};
   }
   ignore_consortium_next_page_tech_ability_code_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"ignore_consortium_next_page_tech_ability_code")} {
      bins  ignore_consortium_next_page_tech_ability_code_0 = {0};
      bins  ignore_consortium_next_page_tech_ability_code_1 = {1};
   }

//Register: an_cfg2
   reset_an_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2"),"reset_an")} {
      bins  reset_an_0 = {0};
      bins  reset_an_1 = {1};
   }
   an_next_page_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2"),"an_next_page")} {
      bins  an_next_page_0 = {0};
      bins  an_next_page_1 = {1};
   }

//Register: an_status
   an_page_received_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_page_received")} {
      bins  an_page_received_0 = {0};
      bins  an_page_received_1 = {1};
   }
   an_complete_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_complete")} {
      bins  an_inprogress = {0};
      bins  an_complete = {1};
   }
   an_adv_remote_fault_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_adv_remote_fault")} {
      bins  an_adv_remote_fault_0 = {0};
      bins  an_adv_remote_fault_1 = {1};
   }
   an_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_ability")} {
      bins  an_ability_0 = {0};
      bins  an_ability_1 = {1};
   }
   an_status_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_status")} {
      bins  an_link_down = {0};
      bins  an_link_up = {1};
   }
   an_lp_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_lp_ability")} {
      bins  an_lp_ability_0 = {0};
      bins  an_lp_ability_1 = {1};
   }
   consortium_next_page_received_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"consortium_next_page_received")} {
      bins  consortium_next_page_received_0 = {0};
      bins  consortium_next_page_received_1 = {1};
   }
   negotiation_failure_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"negotiation_failure")} {
      bins  no_fail = {0};
      bins  failure = {1};
   }
   ieee_negotiated_port_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"ieee_negotiated_port_type")} {
      bins  negotiation_port_10G_KR = {12'h001};
      bins  negotiation_port_40G_KR4 = {12'h002};
      bins  negotiation_port_40G_CR4 = {12'h004};
      bins  negotiation_port_100G_KR4 = {12'h008};
      bins  negotiation_port_100G_CR4 = {12'h010};
      bins  negotiation_port_25G_KRS = {12'h020};
      bins  negotiation_port_25G_KR = {12'h040};
      bins  negotiation_port_50G_KR = {12'h080};
      bins  negotiation_port_100G_KR2 = {12'h100};
      bins  negotiation_port_200G_KR4 = {12'h200};
      bins  negotiation_port_100G_KR = {12'h400};
      bins  negotiation_port_200G_KR2 = {12'h800};
   }
   consortium_negotiated_port_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"consortium_negotiated_port_type")} {
      bins  negotiation_port_25G_KR1 = {5'h01};
      bins  negotiation_port_25G_CR1 = {5'h02};
      bins  negotiation_port_50G_KR2 = {5'h04};
      bins  negotiation_port_50G_CR2 = {5'h08};
      bins  negotiation_port_400G_KR8 = {5'h10};
    }
   consortium_negotiated_port_type_cont_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"consortium_negotiated_port_type_cont")} {
      bins  negotiation_port_400G_KR4 = {1};
    }
   rs_fec_negotiated_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"rs_fec_negotiated")} {
      bins  rs_fec_negotiated_0 = {0};
      bins  rs_fec_negotiated_1 = {0};
    }
   ll_fec_negotiated_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"ll_fec_negotiated")} {
      bins  ll_fec_negotiated_0 = {0};
      bins  ll_fec_negotiated_1 = {0};
    }


//Register: an_cfg3
   user_base_page_low_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg3"),"user_base_page_low")} {
      wildcard bins  nxt_page = {16'b1???_????_????_????};
      wildcard bins  ack = {16'b?1??_????_????_????};
      wildcard bins  remote_fault = {16'b??1?_????_????_????};
      wildcard bins  pause_bits_3 = {16'b???1_????_????_????};
      wildcard bins  pause_bits_2 = {16'b????_1???_????_????};
      wildcard bins  pause_bits_1 = {16'b????_?1??_????_????};
      wildcard bins  echoed_nonce_5 = {16'b????_??1?_????_????};
      wildcard bins  echoed_nonce_4 = {16'b????_???1_????_????};
      wildcard bins  echoed_nonce_3 = {16'b????_????_1???_????};
      wildcard bins  echoed_nonce_2 = {16'b????_????_?1??_????};
      wildcard bins  echoed_nonce_1 = {16'b????_????_??1?_????};
      wildcard bins  selector_5 = {16'b????_????_???1_????};
      wildcard bins  selector_4 = {16'b????_????_????_1???};
      wildcard bins  selector_3 = {16'b????_????_????_?1??};
      wildcard bins  selector_2 = {16'b????_????_????_??1?};
      wildcard bins  selector_1 = {16'b????_????_????_???1};
    }

//Register: an_cfg4
   user_base_page_high_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg4"),"user_base_page_high")} {
      wildcard bins  tx_nonce_bits_1 = {16'b????_????_????_???1};
      wildcard bins  tx_nonce_bits_2 = {16'b????_????_????_??1?};
      wildcard bins  tx_nonce_bits_3 = {16'b????_????_????_?1??};
      wildcard bins  tx_nonce_bits_4 = {16'b????_????_????_1???};
      wildcard bins  tx_nonce_bits_5 = {16'b????_????_???1_????};
      bins  tech_ability_bits = {['h20:'h3FFF_FFE0]};
      wildcard bins  fec_bits_1 = {32'b1???_????_????_????_????_????_????_????};
      wildcard bins  fec_bits_2 = {32'b?1??_????_????_????_????_????_????_????};
    }

//Register: an_cfg5
   user_next_page_low_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg5"),"user_next_page_low")} {
      wildcard bins  message_code_field = {['h1:'h0000_07FF]};
      wildcard bins  toggle_bit = {16'b????_1???_????_????};
      wildcard bins  ack2_bit = {16'b???1_????_????_????};
      wildcard bins  mp_bit = {16'b??1?_????_????_????};
      wildcard bins  ack_bit = {16'b?1??_????_????_????};
      wildcard bins  next_page_bit = {16'b1???_????_????_????};
    }

//Register: an_cfg6
   user_next_page_high_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg6"),"user_next_page_high")} {
      bins  unformatted_vode_field = {['h1:'hFFFF_FFFF]};
    }

//Register: an_status1
   lp_base_page_low_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status1"),"lp_base_page_low")} {
      wildcard bins  link_partner_selectorbits_1 = {16'b????_????_????_???1};
      wildcard bins  link_partner_selectorbits_2 = {16'b????_????_????_??1?};
      wildcard bins  link_partner_selectorbits_3 = {16'b????_????_????_?1??};
      wildcard bins  link_partner_selectorbits_4 = {16'b????_????_????_1???};
      wildcard bins  link_partner_selectorbits_5 = {16'b????_????_???1_????};
      wildcard bins  link_partner_echoednonce_bits_1 = {16'b????_????_??1?_????};
      wildcard bins  link_partner_echoednonce_bits_2 = {16'b????_????_?1??_????};
      wildcard bins  link_partner_echoednonce_bits_3 = {16'b????_????_1???_????};
      wildcard bins  link_partner_echoednonce_bits_4 = {16'b????_???1_????_????};
      wildcard bins  link_partner_echoednonce_bits_5 = {16'b????_??1?_????_????};
      wildcard bins  link_partner_pause_bits_1 = {16'b????_?1??_????_????};
      wildcard bins  link_partner_pause_bits_2 = {16'b????_1???_????_????};
      wildcard bins  link_partner_pause_bits_3 = {16'b???1_????_????_????};
      wildcard bins  link_partner_RF_bit = {16'b??1?_????_????_????};
      wildcard bins  link_partner_ack_bit = {16'b?1??_????_????_????};
      wildcard bins  link_partner_next_page_bit = {16'b1???_????_????_????};
    }
//Register: an_status2
   lp_base_page_high_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status2"),"lp_base_page_high")} {
      wildcard bins  tx_nonce_bits_1 = {16'b????_????_????_???1};
      wildcard bins  tx_nonce_bits_2 = {16'b????_????_????_??1?};
      wildcard bins  tx_nonce_bits_3 = {16'b????_????_????_?1??};
      wildcard bins  tx_nonce_bits_4 = {16'b????_????_????_1???};
      wildcard bins  tx_nonce_bits_5 = {16'b????_????_???1_????};
      bins  link_partner_tech_ability_bits = {['h20:'h3FFF_FFE0]};
      wildcard bins  link_partner_fec_bits_1 = {32'b1???_????_????_????_????_????_????_????};
      wildcard bins  link_partner_fec_bits_2 = {32'b?1??_????_????_????_????_????_????_????};
    }
//Register: an_status3
   lp_next_page_low_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status3"),"lp_next_page_low")} {
      bins  link_partner_message_code_field = {['h1:'h0000_07FF]};
      wildcard bins  link_partner_toggle_bit = {16'b????_1???_????_????};
      wildcard bins  link_partner_ack2_bit = {16'b???1_????_????_????};
      wildcard bins  link_partner_mp_bit = {16'b??1?_????_????_????};
      wildcard bins  link_partner_ack_bit = {16'b?1??_????_????_????};
      wildcard bins  link_partner_next_page_bit = {16'b1???_????_????_????};
    }
//Register: an_status4
   lp_next_page_high_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status4"),"lp_next_page_high")} {
      bins  link_partner_unformatted_bits = {['h1:'hFFFF_FFFF]};
    }
//Register: an_status6
   lp_consortium_next_page_tech_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status6"),"lp_consortium_next_page_tech")} {
      bins  unformatted_next_page_bits = {['h1:'h1FF]};
      bins  Consortium_25GBASE_KR1 = {'h200};
      bins  Consortium_25GBASE_CR1 = {'h400};
      bins  techability_50GBASE_KR2 = {'h2_0000};
      bins  techability_50GBASE_CR2 = {'h4_0000};
    }
//Register: an_cfg8
   override_an_channel_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_an_channel")} {
     bins  override_an_channel = {['h1:'h7]};
    }
   override_consortium_llfec_req_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_consortium_llfec_req")} {
     bins  override_consortium_llfec_req_1 = {1};
     bins  override_consortium_llfec_req_0 = {0};
    }
   override_consortium_llfec_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_consortium_llfec_ability")} {
     bins  llfec_50GBASE = {'h40};
     bins  llfec_100GBASE = {'h50};
     bins  llfec_200GBASE = {'h60};
     bins  llfec_400GBASE = {'h70};
   }
   override_rsfec_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_rsfec_ability")} {
     bins  override_rsfec_ability_1 = {1};
     bins  override_rsfec_ability_0 = {0};
   }
   override_25g_rsfec_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_25g_rsfec_ability")} {
     bins  override_25g_rsfec_ability_1 = {1};
     bins  override_25g_rsfec_ability_0 = {0};
   }
   override_rsfec_req_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_rsfec_req")} {
     bins  override_rsfec_req_1 = {1};
     bins  override_rsfec_req_0 = {0};
   }
   override_25g_rsfec_req_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_25g_rsfec_req")} {
     bins  override_25g_rsfec_req_1 = {1};
     bins  override_25g_rsfec_req_0 = {0};
   }
   override_ieee_port_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_ieee_port_ability")} {
     bins  port_ability_10GBASE_KR = {'h1000};
     bins  port_ability_40GBASE_KR4 = {'h2000};
     bins  port_ability_40GBASE_CR4 = {'h4000};
     bins  port_ability_100GBASE_KR4 = {'h8000};
     bins  port_ability_100GBASE_CR4 = {'h1_0000};
     bins  port_ability_25GBASE_KRS = {'h2_0000};
     bins  port_ability_25GBASE_KR = {'h4_0000};
     bins  port_ability_50GBASE_KR = {'h8_0000};
     bins  port_ability_100GBASE_KR2 = {'h10_0000};
     bins  port_ability_200GBASE_KR4 = {'h20_0000};
     bins  port_ability_100GBASE_KR = {'h40_0000};
     bins  port_ability_200GBASE_KR2 = {'h80_0000};
   }
  override_consortium_port_ability_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_consortium_port_ability")} {
     bins  port_ability_25GBASE_KR1 = {'h100_0000};
     bins  port_ability_25GBASE_CR1 = {'h200_0000};
     bins  port_ability_50GBASE_KR2 = {'h400_0000};
     bins  port_ability_50GBASE_CR2 = {'h800_0000};
     bins  port_ability_400GBASE_KR8 = {'h1000_0000};
   }
  override_ieee_port_ability_cont_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg8"),"override_ieee_port_ability_cont")} {
     bins  port_ability_400GBASE_KR4 = {'h200_0000};
   }
//Register: lt_cfg1
   enable_link_training_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg1"),"enable_link_training")} {
      bins  dis_lt = {0};
      bins  en_lt = {1};
    }
   dis_max_wait_tmr_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg1"),"dis_max_wait_tmr")} {
      bins  en_max_wait_tmr = {0};
      bins  dis_max_wait_tmr = {1};
    }
    
//Register: lt_cfg2
   restart_link_training_ln0_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln0")} {
      bins  ln0_lt_0 = {0};
      bins  ln0_lt_1 = {1};
    }
   restart_link_training_ln1_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln1")} {
      bins  ln1_lt_0 = {0};
      bins  ln1_lt_1 = {1};
    }
   restart_link_training_ln2_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln2")} {
      bins  ln2_lt_0 = {0};
      bins  ln2_lt_1 = {1};
    }
   restart_link_training_ln3_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln3")} {
      bins  ln3_lt_0 = {0};
      bins  ln3_lt_1 = {1};
    }
   restart_link_training_ln4_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln4")} {
      bins  ln4_lt_0 = {0};
      bins  ln4_lt_1 = {1};
    }
   restart_link_training_ln5_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln5")} {
      bins  ln5_lt_0 = {0};
      bins  ln5_lt_1 = {1};
    }
   restart_link_training_ln6_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln6")} {
      bins  ln6_lt_0 = {0};
      bins  ln6_lt_1 = {1};
    }
   restart_link_training_ln7_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2"),"restart_link_training_ln7")} {
      bins  ln7_lt_0 = {0};
      bins  ln7_lt_1 = {1};
    }

    
//Register: lt_status1
   link_trained_ln0_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln0")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln0_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln0")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln0_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln0")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln0_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln0")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln1_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln1")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln1_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln1")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln1_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln1")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln1_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln1")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln2_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln2")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln2_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln2")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln2_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln2")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln2_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln2")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln3_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln3")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln3_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln3")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln3_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln3")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln3_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln3")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln4_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln4")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln4_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln4")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln4_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln4")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln4_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln4")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln5_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln5")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln5_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln5")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln5_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln5")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln5_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln5")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln6_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln6")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln6_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln6")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln6_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln6")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln6_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln6")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }

    link_trained_ln7_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_trained_ln7")} {
      bins  link_trained_1 = {1};
      bins  link_trained_0 = {0};
    }
   link_training_frame_lock_ln7_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_frame_lock_ln7")} {
      bins  link_training_frame_lock_1 = {1};
      bins  link_training_frame_lock_0 = {0};
    }
   link_training_startup_ln7_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_startup_ln7")} {
      bins  link_training_startup_1 = {1};
      bins  link_training_startup_0 = {0};
    }
   link_training_failure_ln7_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1"),"link_training_failure_ln7")} {
      bins  link_training_failure_1 = {1};
      bins  link_training_failure_0 = {0};
    }


    sequencer_mode: coverpoint {spy_if.seq_mode} {
      bins AN_MODE = {14'h1};
      bins LT_MODE = {14'h2};
      bins DATA_MODE_10G = {14'h4} iff(kr_cfg_inst.is_speed_10g);
      bins DATA_MODE_25G = {14'h8} iff(kr_cfg_inst.is_speed_25g);
      bins DATA_MODE_40G = {14'h40} iff(kr_cfg_inst.is_speed_40g);
      bins DATA_MODE_50G_R2 = {14'h10} iff(kr_cfg_inst.is_speed_50g);
      bins DATA_MODE_50G_R1 = {14'h100} iff(kr_cfg_inst.is_speed_50g);
      bins DATA_MODE_100G_R4 = {14'h20} iff(kr_cfg_inst.is_speed_100g);
      bins DATA_MODE_100G_R2 = {14'h80} iff(kr_cfg_inst.is_speed_100g);
      bins DATA_MODE_100G_R1 = {14'h800} iff(kr_cfg_inst.is_speed_100g);
      bins DATA_MODE_200G_R4 = {14'h200} iff(kr_cfg_inst.is_speed_200g);
      bins DATA_MODE_200G_R2 = {14'h1000} iff(kr_cfg_inst.is_speed_200g);
      bins DATA_MODE_400G_R8 = {14'h400} iff(kr_cfg_inst.is_speed_400g);
      bins DATA_MODE_400G_R4 = {14'h2000} iff(kr_cfg_inst.is_speed_400g);
   }
   sequencer_mode_transitions_10g: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h4) iff(kr_cfg_inst.is_speed_10g);
      bins DATA_TO_AN_MODE = (14'h4=>14'h1) iff(kr_cfg_inst.is_speed_10g);
      bins DATA_TO_LT_MODE = (14'h4=>14'h2) iff(kr_cfg_inst.is_speed_10g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h4) iff(kr_cfg_inst.is_speed_10g);
   }
   sequencer_mode_transitions_25g: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h8) iff(kr_cfg_inst.is_speed_25g);
      bins DATA_TO_AN_MODE = (14'h8=>14'h1) iff(kr_cfg_inst.is_speed_25g);
      bins DATA_TO_LT_MODE = (14'h8=>14'h2) iff(kr_cfg_inst.is_speed_25g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h8) iff(kr_cfg_inst.is_speed_25g);
   }
   sequencer_mode_transitions_40g: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h40) iff(kr_cfg_inst.is_speed_40g);
      bins DATA_TO_AN_MODE = (14'h40=>14'h1) iff(kr_cfg_inst.is_speed_40g);
      bins DATA_TO_LT_MODE = (14'h40=>14'h2) iff(kr_cfg_inst.is_speed_40g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h40) iff(kr_cfg_inst.is_speed_40g);
   }
   sequencer_mode_transitions_50g_R2: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h10) iff(kr_cfg_inst.is_speed_50g);
      bins DATA_TO_AN_MODE = (14'h10=>14'h1) iff(kr_cfg_inst.is_speed_50g);
      bins DATA_TO_LT_MODE = (14'h10=>14'h2) iff(kr_cfg_inst.is_speed_50g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h10) iff(kr_cfg_inst.is_speed_50g);
   }
   sequencer_mode_transitions_50g_R1: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h100) iff(kr_cfg_inst.is_speed_50g);
      bins DATA_TO_AN_MODE = (14'h100=>14'h1) iff(kr_cfg_inst.is_speed_50g);
      bins DATA_TO_LT_MODE = (14'h100=>14'h2) iff(kr_cfg_inst.is_speed_50g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h100) iff(kr_cfg_inst.is_speed_50g);
   }
   sequencer_mode_transitions_100g_R4: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h20) iff(kr_cfg_inst.is_speed_100g);
      bins DATA_TO_AN_MODE = (14'h20=>14'h1) iff(kr_cfg_inst.is_speed_100g);
      bins DATA_TO_LT_MODE = (14'h20=>14'h2) iff(kr_cfg_inst.is_speed_100g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h20) iff(kr_cfg_inst.is_speed_100g);
   }
   sequencer_mode_transitions_100g_R2: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h80) iff(kr_cfg_inst.is_speed_100g);
      bins DATA_TO_AN_MODE = (14'h80=>14'h1) iff(kr_cfg_inst.is_speed_100g);
      bins DATA_TO_LT_MODE = (14'h80=>14'h2) iff(kr_cfg_inst.is_speed_100g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h80) iff(kr_cfg_inst.is_speed_100g);
   }
   sequencer_mode_transitions_100g_R1: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h800) iff(kr_cfg_inst.is_speed_100g);
      bins DATA_TO_AN_MODE = (14'h800=>14'h1) iff(kr_cfg_inst.is_speed_100g);
      bins DATA_TO_LT_MODE = (14'h800=>14'h2) iff(kr_cfg_inst.is_speed_100g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h800) iff(kr_cfg_inst.is_speed_100g);
   }
   sequencer_mode_transitions_200g_R4: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h200) iff(kr_cfg_inst.is_speed_200g);
      bins DATA_TO_AN_MODE = (14'h200=>14'h1) iff(kr_cfg_inst.is_speed_200g);
      bins DATA_TO_LT_MODE = (14'h200=>14'h2) iff(kr_cfg_inst.is_speed_200g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h200) iff(kr_cfg_inst.is_speed_200g);
   }
   sequencer_mode_transitions_200g_R2: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h1000) iff(kr_cfg_inst.is_speed_200g);
      bins DATA_TO_AN_MODE = (14'h1000=>14'h1) iff(kr_cfg_inst.is_speed_200g);
      bins DATA_TO_LT_MODE = (14'h1000=>14'h2) iff(kr_cfg_inst.is_speed_200g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h1000) iff(kr_cfg_inst.is_speed_200g);
   }
   sequencer_mode_transitions_400g_R8: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h400) iff(kr_cfg_inst.is_speed_400g);
      bins DATA_TO_AN_MODE = (14'h400=>14'h1) iff(kr_cfg_inst.is_speed_400g);
      bins DATA_TO_LT_MODE = (14'h400=>14'h2) iff(kr_cfg_inst.is_speed_400g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h400) iff(kr_cfg_inst.is_speed_400g);
   }
   sequencer_mode_transitions_400g_R4: coverpoint {spy_if.seq_mode} {
      bins AN_TO_LT_MODE = (14'h1=>14'h2);
      bins LT_TO_DATA_MODE = (14'h2=>14'h2000) iff(kr_cfg_inst.is_speed_400g);
      bins DATA_TO_AN_MODE = (14'h2000=>14'h1) iff(kr_cfg_inst.is_speed_400g);
      bins DATA_TO_LT_MODE = (14'h2000=>14'h2) iff(kr_cfg_inst.is_speed_400g);
      bins AN_TO_DATA_MODE = (14'h1=>14'h2000) iff(kr_cfg_inst.is_speed_400g);
   }

  lt_timeout_cp: coverpoint {spy_if.lt_timeout} {
     bins seq_lt_timeout             = {1};
  }

  lt_status_cp: coverpoint {spy_if.lt_failure[0],spy_if.lt_training[0],spy_if.lt_frame_lock[0],spy_if.lt_trained[0]}  {
     wildcard bins LT_good = {32'bxxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxx1};
     wildcard bins LT_fail = {32'bxxxxxxxx_xxxxxxxx_xxxx1xxx_xxxx1xxx}; 
  } 
  an_timeout_cp: coverpoint { spy_if.an_timeout} {
     bins seq_an_timeout             = {1};
  }
  
  reset_an_during_an_cp: coverpoint {spy_if.reset_seq} iff(spy_if.seq_mode[0] == 1) {
    bins reset_an_during_an = {1};
  }

  reset_an_during_lt_cp: coverpoint {spy_if.reset_seq} iff(spy_if.seq_mode[1] == 1) {
    bins reset_an_during_lt = {1};
  }

  reset_an_during_data_cp: coverpoint {spy_if.reset_seq} iff(spy_if.seq_mode > 2) {
    bins reset_an_during_data = {1};
  }
   
  hi_ber_cp: coverpoint {spy_if.o_rx_hi_ber} {
     bins hi_ber_assert = (0=>1);
  }
  am_loss_cp: coverpoint {spy_if.rx_am_lock} {  //Need to check for 25G rx_am_lock support? 
     bins am_lock_deassert = (1=>0);
  }
  an_status_cross: cross an_status_cp , an_complete_cp, negotiation_failure_cp {
     bins AN_GOOD = binsof (an_complete_cp.an_complete);
     bins AN_FAIL = binsof (negotiation_failure_cp.failure);
     bins AN_COMPLETE = binsof (an_complete_cp.an_complete) && binsof (an_status_cp.an_link_up);
     ignore_bins my_ignore_bins1 = binsof (an_status_cp) intersect {1} && binsof (an_complete_cp) intersect {0};
     ignore_bins my_ignore_bins2 = binsof (negotiation_failure_cp) intersect {1} && binsof (an_complete_cp) intersect {1} && binsof (an_status_cp) intersect {1};
  }
  an_failure_cross: cross enable_link_training_cp, an_timeout_cp, skip_lt_on_an_timeout_cp, disable_an_timer_cp;  

 // transitions from LT mode    
  lt_failure_cross: cross lf_failure_cp , lt_status_cp , enable_an_cp, disable_lf_timer_cp,dis_max_wait_tmr_cp;  
  lt_timeout_cross: cross lf_failure_cp , lt_timeout_cp , enable_an_cp, disable_lf_timer_cp,dis_max_wait_tmr_cp;  
 
//  lf_hiber_hiber_cross: cross link_fail_hiber_cp,hi_ber_cp,an_en_dis_cp,disable_lf_timer_cp;
//  lf_hiber_amloss_cross: cross link_fail_hiber_cp,am_loss_cp,an_en_dis_cp,disable_lf_timer_cp;
//  tx_user_base_page_np_rf_cross : cross user_base_page_cp , tx_user_base_page_cp , an_status_cross;
//  rx_user_base_page_cp_cross : cross rx_user_base_page_cp, an_status_cross;
//  override_an_tech_cons_parameter_cross : cross override_an_cons_parameter_cp, override_an_tech_cons_parameter_cp, an_status_cross;
//  override_an_fec_parameter_cross : cross override_an_parameter_cp, override_an_fec_cp, an_status_cross;
//  override_an_pause_parameter_cross : cross override_an_parameter_cp, override_an_pause_cp, an_status_cross;


//  anlt_seq_cfg          : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//                        {
//			  wildcard bins reset_seq_0             = {16'b????_????_????_???0};
//			  wildcard bins reset_seq_1             = {16'b????_????_????_???1};
//			  wildcard bins disable_an_timer_0      = {16'b????_????_????_??0?};
//			  wildcard bins disable_an_timer_1      = {16'b????_????_????_??1?};
//			  wildcard bins disable_lf_timer_0      = {16'b????_????_????_?0??};
//			  wildcard bins disable_lf_timer_1      = {16'b????_????_????_?1??};
//			  wildcard bins seq_force_mode_no_force = {16'b????_????_0000_????};
//			  wildcard bins seq_force_mode_50GB_R2  = {16'b????_????_0010_????};
//			  wildcard bins seq_force_mode_100GB_R4 = {16'b????_????_0011_????};
//			  wildcard bins lt_failure_response_0   = {16'b???0_????_????_????}; 
//			  wildcard bins lt_failure_response_1   = {16'b???1_????_????_????}; 
//			  wildcard bins link_fail_if_hiber_0    = {16'b??0?_????_????_????}; 
//			  wildcard bins link_fail_if_hiber_1    = {16'b??1?_????_????_????}; 
//			  wildcard bins skip_lt_on_an_timeout_0 = {16'b?0??_????_????_????}; 
//			  wildcard bins skip_lt_on_an_timeout_1 = {16'b?1??_????_????_????}; 
//			}
//
//  anlt_seq_status       : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ))
//                        {
//			  wildcard bins seq_link_ready_0             = {16'b????_????_????_???0};
//			  wildcard bins seq_link_ready_1             = {16'b????_????_????_???1};
//			  wildcard bins seq_an_timeout_0             = {16'b????_????_????_??0?};
//			  wildcard bins seq_an_timeout_1             = {16'b????_????_????_??1?};
//			  wildcard bins seq_lt_timeout_0             = {16'b????_????_????_?0??};
//			  wildcard bins seq_lt_timeout_1             = {16'b????_????_????_?1??};
//			  wildcard bins seq_reconfig_mode_an         = {16'b??00_0001_????_????};
//			  wildcard bins seq_reconfig_mode_lt         = {16'b??00_0010_????_????};
//			  wildcard bins seq_reconfig_mode_50G_data   = {16'b??01_0000_????_????};
//			  wildcard bins seq_reconfig_mode_100G_data  = {16'b??10_0000_????_????};
//			}
//
//  an_cfg1_byte_0_1       : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//  			{
//			  wildcard bins enable_an_0 = {16'b????_????_????_????};
//			  wildcard bins enable_an_1 = {16'b????_????_????_???1};
//			  wildcard bins an_base_pages_ctrl_0 = {16'b????_????_????_??0?};
//			  wildcard bins an_base_pages_ctrl_1 = {16'b????_????_????_??1?};
//			  wildcard bins an_next_pages_ctrl_0 = {16'b????_????_????_?0??};
//			  wildcard bins an_next_pages_ctrl_1 = {16'b????_????_????_?1??};
//			  wildcard bins local_device_remote_fault_0 = {16'b????_????_????_0???};
//			  wildcard bins local_device_remote_fault_1 = {16'b????_????_????_1???};
//			  wildcard bins force_tx_nonce_value_0 = {16'b????_????_???0_????};
//			  wildcard bins force_tx_nonce_value_1 = {16'b????_????_???1_????};
//			  wildcard bins override_an_parameters_enable_0 = {16'b????_????_??0?_????};
//			  wildcard bins override_an_parameters_enable_1 = {16'b????_????_??1?_????};
//			  wildcard bins ignore_nonce_field_0 = {16'b????_????_0???_????};
//			  wildcard bins ignore_nonce_field_1 = {16'b????_????_1???_????};
//			  wildcard bins enable_consortium_next_page_send_0 = {16'b????_???0_????_????};
//			  wildcard bins enable_consortium_next_page_send_1 = {16'b????_???1_????_????};
//			  wildcard bins enable_consortium_next_page_receive_0 = {16'b????_??0?_????_????};
//			  wildcard bins enable_consortium_next_page_receive_1 = {16'b????_??1?_????_????};
//			  wildcard bins enable_consortium_next_page_override_0 = {16'b????_?0??_????_????};
//			  wildcard bins enable_consortium_next_page_override_1 = {16'b????_?1??_????_????};
//			  wildcard bins ignore_consortium_next_page_tech_ability_code_0 = {16'b????_0???_????_????};
//			  wildcard bins ignore_consortium_next_page_tech_ability_code_1 = {16'b????_1???_????_????};
//			}
//
//  an_cfg1_consortium_oui : coverpoint {trans.data_bytes[3],trans.data_bytes[2]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE));
//
//  an_cfg2_byte_0_1	: coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//			  wildcard bins an_cfg2_reset_an_0 = {16'b????_????_????_???0};
//			  wildcard bins an_cfg2_reset_an_1 = {16'b????_????_????_???1};
//			  wildcard bins an_cfg2_restart_an_txsm_0 = {16'b????_????_???0_????};
//			  wildcard bins an_cfg2_restart_an_txsm_1 = {16'b????_????_???1_????};
//			  wildcard bins an_cfg2_an_next_page_0 = {16'b????_???0_????_????};
//			  wildcard bins an_cfg2_an_next_page_1 = {16'b????_???1_????_????};
//			}
//
//  an_cfg2_consortium_oui_upper	: coverpoint {trans.data_bytes[3]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE));
//
//  an_status_byte_0	: coverpoint {trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//			  wildcard bins an_status_an_page_received_0 = {8'b????_??0?};
//			  wildcard bins an_status_an_page_received_1 = {8'b????_??1?};
//			  wildcard bins an_status_an_complete_0 = {8'b????_?0??};
//			  wildcard bins an_status_an_complete_1 = {8'b????_?1??};
//			  wildcard bins an_status_an_adv_remote_fault_0 = {8'b????_0???};
//			  wildcard bins an_status_an_adv_remote_fault_1 = {8'b????_1???};
//			  wildcard bins an_status_an_rxsm_idle_0 = {8'b???0_????};
//			  wildcard bins an_status_an_rxsm_idle_1 = {8'b???1_????};
//			  wildcard bins an_status_an_ability_0 = {8'b??0?_????};
//			  wildcard bins an_status_an_ability_1 = {8'b??1?_????};
//			  wildcard bins an_status_an_status_0 = {8'b?0??_????};
//			  wildcard bins an_status_an_status_1 = {8'b?1??_????};
//			  wildcard bins an_status_an_lp_ability_0 = {8'b0???_????};
//			  wildcard bins an_status_an_lp_ability_1 = {8'b1???_????};
//			}
//
//  an_status_byte_1	: coverpoint {trans.data_bytes[1]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//			  wildcard bins an_status_baser_fec_negotiated_en_0 = {8'b????_???0};
//			  wildcard bins an_status_baser_fec_negotiated_en_1 = {8'b????_???1};
//			  wildcard bins an_status_an_failure_0 = {8'b????_??0?};
//			  wildcard bins an_status_an_failure_1 = {8'b????_??1?};
//			  wildcard bins an_status_consortium_next_page_received_0 = {8'b????_?0??};
//			  wildcard bins an_status_consortium_next_page_received_1 = {8'b????_?1??};
//			  wildcard bins an_status_negotiation_failure_0 = {8'b????_0???};
//			  wildcard bins an_status_negotiation_failure_1 = {8'b????_1???};
//			}
//
//  an_status_ieee_negotiated_port_type	: coverpoint {trans.data_bytes[2][6:0],trans.data_bytes[1][7:4]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//  					{
//					  bins base_1000_kx =           {11'b000_0000_0000};
//					  bins base_10G_kx4 =           {11'b000_0000_0000};
//					  bins base_10G_kr =            {11'b000_0000_0000};
//					  bins base_40G_kr4 =           {11'b000_0000_0000};
//					  bins base_40G_cr4 =           {11'b000_0000_0000};
//					  bins base_100G_cr10 =         {11'b000_0000_0000};
//					  bins base_100G_kp4 =          {11'b000_0000_0000};
//					  bins base_100G_kr4 =          {11'b000_0000_0000};
//					  bins base_100G_cr4 =          {11'b000_0000_0000};
//					  bins base_25G_kr_s_or_cr_s =  {11'b000_0000_0000};
//					  bins base_25G_kr_or_cr =      {11'b000_0000_0000};
//					}
//
//  an_status_byte_3	: coverpoint {trans.data_bytes[3]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//		  	  wildcard bins an_status_consortium_negotiated_port_type_25Gbase_kr1 = {8'b????_0001};
//		  	  wildcard bins an_status_consortium_negotiated_port_type_25Gbase_cr1 = {8'b????_0010};
//		  	  wildcard bins an_status_consortium_negotiated_port_type_50Gbase_kr2 = {8'b????_0100};
//		  	  wildcard bins an_status_consortium_negotiated_port_type_50Gbase_cr2 = {8'b????_1000};
//			  wildcard bins rs_fec_negotiated_0 = {8'b?0??_????};
//			  wildcard bins rs_fec_negotiated_1 = {8'b?1??_????};
//			}
//









//   reset_seq_during_an_cp : coverpoint {trans.data_bytes[0][0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[0]==1) 
//   {
//      bins reset_seq_during_an = {1};
//   }
//   reset_seq_during_lt_cp : coverpoint {trans.data_bytes[0][0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[1]==1) 
//   {
//      bins reset_seq_during_lt = {1};
//   }
//   reset_seq_during_data_cp : coverpoint {trans.data_bytes[0][0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[3]==1) 
//   {
//      bins reset_seq_during_data = {1};
//   }
//   lt_failure_response_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"lt_failure_response")} {
//      bins lt_failure_response_0 = {0};
//      bins lt_failure_response_1 = {1};
//   }
//   an_en_dis_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"enable_an")} {
//      bins an_enable = {1};
//      bins an_disable = {0};
//   }
//   lt_en_dis_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg1"),"enable_link_training")} {
//      bins lt_enable = {1};
//      bins lt_disable = {0};
//   }  
////  disable_an_timer_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"disable_an_timer")} {
////     bins an_timer_dis = {1};
////     bins an_timer_en = {0};
////  }
////
////  disable_lf_timer_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"disable_lf_timer")} {
////     bins lf_timer_dis = {1};
////     bins lf_timer_en = {0};
////  }
//  dis_max_wait_timer_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg1"),"dis_max_wait_tmr")} {
//     bins max_wait_timer_dis = {1};
//     bins max_wait_timer_en = {0};
//  }
//  LT_status_cp : coverpoint {trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_status1")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)) 
//  {
//     wildcard bins LT_good = {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1} iff(kr_cfg_inst.is_speed_25g);
//     wildcard bins LT_fail = {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx} iff(kr_cfg_inst.is_speed_25g);
//  } 
//  skip_LT_on_an_timeout_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"skip_lt_on_an_timeout")} {
//     bins skip_LT_on_an_timeout_0 = {0};
//     bins skip_LT_on_an_timeout_1 = {1};
//  }
//  an_timeout_cp : coverpoint {trans.data_bytes[0][1]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)) 
//  {
//     bins seq_an_timeout             = {1};
//  }
//  lt_timeout_cp : coverpoint {trans.data_bytes[0][2]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)) 
//  {
//     bins seq_lt_timeout             = {1};
//  }
//  an_page_rcv_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_page_received")} {
//    bins pg_rcv = {1};
//  }  
////  an_complete_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_complete")} {
////    bins an_complete = {1};
////    bins an_progress = {0};
////  }
//  an_adv_rf_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_adv_remote_fault")} {
//    bins an_adv_rf_1 = {1};
//    bins an_adv_rf_0 = {0};
//  }
//  an_phy_an_abl_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_ability")} {
//    bins an_phy_an_abl_1 = {1};
//  }
//  an_link_status_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_status")} {
//    bins an_link_up = {1};
//    bins an_link_down = {0};
//  }
//  an_lp_ablt_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_lp_ability")} {
//    bins an_lp_able = {1};
//    bins an_lp_unable = {0};
//  }
//  an_baser_fec_able_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"baser_fec_negotiated_en")} {
//    bins able = {1};
//    bins unable = {0};
//  }
//  an_failure_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"an_failure")} {
//    bins failure = {1};
//    bins no_fail = {0};
//  }
//  an_neg_failure_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"negotiation_failure")} {
//    bins failure = {1};
//    bins no_fail = {0};
//  }
//  an_ieee_neg_port_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"ieee_negotiated_port_type")} {
//     wildcard bins _25GBASE_CR = {12'b????_??1?_????} iff(kr_cfg_inst.is_speed_25g);
//     wildcard bins _100GBASE_KR4 = {12'b????_1???_????};
//     wildcard bins _100GBASE_CR4 = {12'b???1_????_????};
//  }
//  an_rsfec_negotiated_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status"),"rs_fec_negotiated")} {
//    bins rsfec = {1};
//    bins norsfec = {0};
//  }
////  an_status_cross : cross an_link_status_cp , an_complete_cp, an_neg_failure_cp {
////     bins AN_GOOD = binsof (an_complete_cp.an_complete);
////     bins AN_FAIL = binsof (an_neg_failure_cp.failure);
////     bins AN_COMPLETE = binsof (an_complete_cp.an_complete) && binsof (an_link_status_cp.an_link_up);
////     ignore_bins my_ignore_bins1 = binsof (an_link_status_cp) intersect {1} && binsof (an_complete_cp) intersect {0};
////     ignore_bins my_ignore_bins2 = binsof (an_neg_failure_cp) intersect {1} && binsof (an_complete_cp) intersect {1} && binsof (an_link_status_cp) intersect {1};
////  }
//  // transitions from LT mode    
//  lt_failure_cross : cross lt_failure_response_cp , LT_status_cp , an_en_dis_cp, disable_lf_timer_cp,dis_max_wait_timer_cp;  
//  lt_timeout_cross : cross lt_failure_response_cp , lt_timeout_cp , an_en_dis_cp, disable_lf_timer_cp,dis_max_wait_timer_cp;  
//
//  // transitions from Data mode
//  link_fail_hiber_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg"),"link_fail_if_hiber")} {
//     bins link_fail_hiber_0 = {0};
//     bins link_fail_hiber_1 = {1};
//  }
//  hi_ber_cp: coverpoint {spy_if.o_rx_hi_ber} {
//     bins hi_ber_assert = (0=>1);
//  }
//  am_loss_cp: coverpoint {spy_if.rx_am_lock} {  //Need to check for 25G rx_am_lock support? 
//     bins am_lock_deassert = (1=>0);
//  }
//  lf_hiber_hiber_cross: cross link_fail_hiber_cp,hi_ber_cp,an_en_dis_cp,disable_lf_timer_cp;
//  lf_hiber_amloss_cross: cross link_fail_hiber_cp,am_loss_cp,an_en_dis_cp,disable_lf_timer_cp;
//     
//
//  // transitions from AN mode
//  an_failure_cross: cross lt_en_dis_cp, an_timeout_cp, skip_LT_on_an_timeout_cp, disable_an_timer_cp;  
//    
//  reset_an_during_an_cp	: coverpoint {trans.data_bytes[0][0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[0] == 1) 
//  {
//    bins reset_an_during_an = {1};
//  }
//
//  reset_an_during_lt_cp	: coverpoint {trans.data_bytes[0][0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[1] == 1) 
//  {
//    bins reset_an_during_lt = {1};
//  }
//  reset_an_during_data_cp	: coverpoint {trans.data_bytes[0][0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[3] == 1) 
//  {
//    bins reset_an_during_data = {1};
//  }
//
//  user_base_page_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"an_base_pages_ctrl")} {
//    bins base_page_ctrl = {1};
//  }
//
//  next_base_page_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"an_next_pages_ctrl")} {
//    bins next_base_page_1 = {1};
//    bins next_base_page_0 = {0};
//  }
//
//  tx_user_base_page_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg3"),"user_base_page_low")} {
//     wildcard bins tx_next_page_bit_0 = {16'b0???_????_????_????};
//     wildcard bins tx_next_page_bit_1 = {16'b1???_????_????_????};
//     wildcard bins tx_RF_bit_0 = {16'b??0?_????_????_????};
//     wildcard bins tx_RF_bit_1 = {16'b??1?_????_????_????};
//     wildcard bins pause_0 = {16'b????_00??_????_????};
//     wildcard bins pause_1 = {16'b????_01??_????_????};
//     wildcard bins pause_2 = {16'b????_10??_????_????};
//     wildcard bins pause_3 = {16'b????_11??_????_????};
//  }
//
//  tx_user_base_page_np_rf_cross : cross user_base_page_cp , tx_user_base_page_cp , an_status_cross;
//  
//  rx_user_base_page_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_status1"),"lp_base_page_low")} {
//     wildcard bins rx_next_page_bit_0 = {16'b0???_????_????_????};
//     wildcard bins rx_next_page_bit_1 = {16'b1???_????_????_????};
//     wildcard bins rx_RF_bit_0 = {16'b??0?_????_????_????};
//     wildcard bins rx_RF_bit_1 = {16'b??1?_????_????_????};
//     wildcard bins pause_0 = {16'b????_00??_????_????};
//     wildcard bins pause_1 = {16'b????_01??_????_????};
//     wildcard bins pause_2 = {16'b????_10??_????_????};
//     wildcard bins pause_3 = {16'b????_11??_????_????};
//  } 
//  rx_user_base_page_cp_cross : cross rx_user_base_page_cp, an_status_cross;
//     
//    
//  override_an_parameter_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1"),"override_an_parameters_enable")} {
//    bins override_an_parameter = {1};
//  }
//  
//  /*override_an_tech_parameter_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg3"),"override_an_tech")} {//REVISIT: Aditya
//    wildcard bins override_an_tech_parameter_0_0 = {8'b????_???0};
//    wildcard bins override_an_tech_parameter_1_0 = {8'b????_??0?};
//    wildcard bins override_an_tech_parameter_2_0 = {8'b????_?0??};
//    wildcard bins override_an_tech_parameter_3_0 = {8'b????_0???};
//    wildcard bins override_an_tech_parameter_4_0 = {8'b???0_????};
//    wildcard bins override_an_tech_parameter_5_0 = {8'b??0?_????};
//    wildcard bins override_an_tech_parameter_6_0 = {8'b?0??_????};
//    wildcard bins override_an_tech_parameter_7_0 = {8'b0???_????};
////    wildcard bins override_an_tech_parameter_0_1 = {8'b????_???1};
////    wildcard bins override_an_tech_parameter_1_1 = {8'b????_??1?};
////    wildcard bins override_an_tech_parameter_2_1 = {8'b????_?1??};
////    wildcard bins override_an_tech_parameter_3_1 = {8'b????_1???};
////    wildcard bins override_an_tech_parameter_4_1 = {8'b???1_????};
////    wildcard bins override_an_tech_parameter_5_1 = {8'b??1?_????};
//    wildcard bins override_an_tech_parameter_6_1 = {8'b?1??_????};
//    wildcard bins override_an_tech_parameter_7_1 = {8'b1???_????};
//  }*/
// /* override_an_tech_parameter_100g_cr4_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg5"),"override_an_tech_22_8")} {
//    wildcard bins override_an_tech_100g_cr4_parameter_0 = {16'b????_????_????_???0};
//    wildcard bins override_an_tech_100g_cr4_parameter_1 = {16'b????_????_????_???1};
//  }
//  override_an_fec_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg3"),"override_an_fec")} {
//    wildcard bins override_an_fec_parameter_0_0 = {4'b????_???0};
//    wildcard bins override_an_fec_parameter_0_1 = {4'b????_???1};
//    wildcard bins override_an_fec_parameter_1_0 = {4'b????_??0?};
//    wildcard bins override_an_fec_parameter_1_1 = {4'b????_??1?};
//  }
//  override_an_pause_cp : coverpoint {get_anlt_reg_mirr_val($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg3"),"override_an_pause")} {
//    wildcard bins override_an_pause_parameter_0_0 = {3'b??0};
//    wildcard bins override_an_pause_parameter_0_1 = {3'b??1};
//    wildcard bins override_an_pause_parameter_1_0 = {3'b?0?};
//    wildcard bins override_an_pause_parameter_1_1 = {3'b?1?};
//  } */
//    // All values on an_tech override
//  //override_an_tech_parameter_cross : cross override_an_parameter_cp, override_an_tech_parameter_cp, an_status_cross;
//  //override_an_tech_parameter_cr4_cross : cross override_an_parameter_cp, override_an_tech_parameter_100g_cr4_cp, an_status_cross;
//  //override_an_fec_parameter_cross : cross override_an_parameter_cp, override_an_fec_cp, an_status_cross;
//  //override_an_pause_parameter_cross : cross override_an_parameter_cp, override_an_pause_cp, an_status_cross;
//
//  restart_lt_cp : coverpoint {trans.data_bytes[0][3:0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) && spy_if.seq_mode[1]==1) 
//  {
//    wildcard bins lane0 = {4'bxxx1};
//    wildcard bins lane1 = {4'bxx1x}; 
//    wildcard bins lane2 = {4'bx1xx};
//    wildcard bins lane3 = {4'b1xxx};
//  }
//
////Revisit: vinoth2x - Check XCVR registers for GDR
//  /*post_coeff_xcvr_value_cp : coverpoint {trans.data_bytes[1][5:0]} iff(`CR2EPCSREGMAP_hssi_cr2_pma_tx_buf_104_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) {
//    bins post_xcvr_coeff_max = {`POST_MAX_VALUE};//VPOSTRULE =25
//    bins post_xcvr_coeff_min = {`MIN_VALUE};//VODMINRULE = 14
//    bins post_xcvr_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins post_xcvr_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  zero_coeff_xcvr_value_cp : coverpoint {trans.data_bytes[1][4:0]} iff(`CR2EPCSREGMAP_hssi_cr2_pma_tx_ser_108_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) {
//    bins zero_xcvr_coeff_max = {`POST_MAX_VALUE};
//    bins zero_xcvr_coeff_min = {`MIN_VALUE};
//    bins zero_xcvr_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins zero_xcvr_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  pre_coeff_xcvr_value_cp : coverpoint {trans.data_bytes[3][4:0]} iff(`CR2EPCSREGMAP_hssi_cr2_pma_tx_buf_104_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) {
//    bins pre_xcvr_coeff_max = {`PRE_MAX_VALUE};//VPRERULE = 16
//    bins pre_xcvr_coeff_min = {`MIN_VALUE};
//    bins pre_xcvr_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins pre_xcvr_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `PRE_MAX_VALUE);
//  }
//  post_lane0_coeff_value_cp : coverpoint {trans.data_bytes[1][5:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln0_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins post_lane0_coeff_max = {`POST_MAX_VALUE};//VPOSTRULE =25
//    bins post_lane0_coeff_min = {`MIN_VALUE};//VODMINRULE = 14
//    bins post_lane0_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins post_lane0_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  zero_lane0_coeff_value_cp : coverpoint {trans.data_bytes[0][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln0_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins zero_lane0_coeff_max = {`POST_MAX_VALUE};
//    bins zero_lane0_coeff_min = {`MIN_VALUE};
//    bins zero_lane0_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins zero_lane0_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  pre_lane0_coeff_value_cp : coverpoint {trans.data_bytes[2][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln0_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins pre_lane0_coeff_max = {`PRE_MAX_VALUE};//VPRERULE = 16
//    bins pre_lane0_coeff_min = {`MIN_VALUE};
//    bins pre_lane0_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins pre_lane0_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `PRE_MAX_VALUE);
//  }
//  post_lane1_coeff_value_cp : coverpoint {trans.data_bytes[1][5:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln1_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins post_lane1_coeff_max = {`POST_MAX_VALUE};//VPOSTRULE =25
//    bins post_lane1_coeff_min = {`MIN_VALUE};//VODMINRULE = 14
//    bins post_lane1_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins post_lane1_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  zero_lane1_coeff_value_cp : coverpoint {trans.data_bytes[0][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln1_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins zero_lane1_coeff_max = {`POST_MAX_VALUE};
//    bins zero_lane1_coeff_min = {`MIN_VALUE};
//    bins zero_lane1_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins zero_lane1_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  pre_lane1_coeff_value_cp : coverpoint {trans.data_bytes[2][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln1_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins pre_lane1_coeff_max = {`PRE_MAX_VALUE};//VPRERULE = 16
//    bins pre_lane1_coeff_min = {`MIN_VALUE};
//    bins pre_lane1_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins pre_lane1_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `PRE_MAX_VALUE);
//  }
//  post_lane2_coeff_value_cp : coverpoint {trans.data_bytes[1][5:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln2_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) {
//    bins post_lane2_coeff_max = {`POST_MAX_VALUE};//VPOSTRULE =25
//    bins post_lane2_coeff_min = {`MIN_VALUE};//VODMINRULE = 14
//    bins post_lane2_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins post_lane2_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  zero_lane2_coeff_value_cp : coverpoint {trans.data_bytes[0][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln2_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins zero_lane2_coeff_max = {`POST_MAX_VALUE};
//    bins zero_lane2_coeff_min = {`MIN_VALUE};
//    bins zero_lane2_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins zero_lane2_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  pre_lane2_coeff_value_cp : coverpoint {trans.data_bytes[2][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln2_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins pre_lane2_coeff_max = {`PRE_MAX_VALUE};//VPRERULE = 16
//    bins pre_lane2_coeff_min = {`MIN_VALUE};
//    bins pre_lane2_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins pre_lane2_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `PRE_MAX_VALUE);
//  }
//  post_lane3_coeff_value_cp : coverpoint {trans.data_bytes[1][5:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln3_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins post_lane3_coeff_max = {`POST_MAX_VALUE};//VPOSTRULE =25
//    bins post_lane3_coeff_min = {`MIN_VALUE};//VODMINRULE = 14
//    bins post_lane3_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins post_lane3_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  zero_lane3_coeff_value_cp : coverpoint {trans.data_bytes[0][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln3_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins zero_lane3_coeff_max = {`POST_MAX_VALUE};
//    bins zero_lane3_coeff_min = {`MIN_VALUE};
//    bins zero_lane3_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins zero_lane3_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `POST_MAX_VALUE);
//  }
//  pre_lane3_coeff_value_cp : coverpoint {trans.data_bytes[2][4:0]} //[FIXME] iff(`REGISTERS_lt_txeq1_ln3_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
//  {
//    bins pre_lane3_coeff_max = {`PRE_MAX_VALUE};//VPRERULE = 16
//    bins pre_lane3_coeff_min = {`MIN_VALUE};
//    bins pre_lane3_coeff_less_than_min = {1} iff(trans.data_bytes[1] < `MIN_VALUE);
//    bins pre_lane3_coeff_greater_than_max = {1} iff(trans.data_bytes[1] > `PRE_MAX_VALUE);
//  }
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_OVERIDE_COEFF_REGISTER(lane0,`REGISTERS_lt_frame_ln0_OFFSET_REG,address,trans.data_bytes[0])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_OVERIDE_COEFF_REGISTER(lane1,`REGISTERS_lt_frame_ln1_OFFSET_REG,address,trans.data_bytes[0])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_OVERIDE_COEFF_REGISTER(lane2,`REGISTERS_lt_frame_ln2_OFFSET_REG,address,trans.data_bytes[0])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_OVERIDE_COEFF_REGISTER(lane3,`REGISTERS_lt_frame_ln3_OFFSET_REG,address,trans.data_bytes[0])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_COEFF_REGISTER(lane0,`REGISTERS_lt_frame_ln0_OFFSET_REG,address,trans.data_bytes[1])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_COEFF_REGISTER(lane1,`REGISTERS_lt_frame_ln1_OFFSET_REG,address,trans.data_bytes[1])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_COEFF_REGISTER(lane2,`REGISTERS_lt_frame_ln2_OFFSET_REG,address,trans.data_bytes[1])
//// FIXME-MISSING_REG_IN_GDR  `LT_LD_COEFF_REGISTER(lane3,`REGISTERS_lt_frame_ln3_OFFSET_REG,address,trans.data_bytes[1])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_OVERIDE_COEFF_REGISTER(lane0,`REGISTERS_lt_frame_ln0_OFFSET_REG,address,trans.data_bytes[2])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_OVERIDE_COEFF_REGISTER(lane1,`REGISTERS_lt_frame_ln1_OFFSET_REG,address,trans.data_bytes[2])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_OVERIDE_COEFF_REGISTER(lane2,`REGISTERS_lt_frame_ln2_OFFSET_REG,address,trans.data_bytes[2])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_OVERIDE_COEFF_REGISTER(lane3,`REGISTERS_lt_frame_ln3_OFFSET_REG,address,trans.data_bytes[2])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_COEFF_REGISTER(lane0,`REGISTERS_lt_frame_ln0_OFFSET_REG,address,trans.data_bytes[3])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_COEFF_REGISTER(lane1,`REGISTERS_lt_frame_ln1_OFFSET_REG,address,trans.data_bytes[3])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_COEFF_REGISTER(lane2,`REGISTERS_lt_frame_ln2_OFFSET_REG,address,trans.data_bytes[3])
//// FIXME-MISSING_REG_IN_GDR  `LT_LP_COEFF_REGISTER(lane3,`REGISTERS_lt_frame_ln3_OFFSET_REG,address,trans.data_bytes[3])
//
//*/
//
// anlt_seq_cfg          : coverpoint {trans.data_bytes[1],trans.data_bytes[0]}  iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_cfg")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//                        {
//			  wildcard bins reset_seq_0             = {16'b????_????_????_???0};
//			  wildcard bins reset_seq_1             = {16'b????_????_????_???1};
//			  wildcard bins disable_an_timer_0      = {16'b????_????_????_??0?};
//			  wildcard bins disable_an_timer_1      = {16'b????_????_????_??1?};
//			  wildcard bins disable_lf_timer_0      = {16'b????_????_????_?0??};
//			  wildcard bins disable_lf_timer_1      = {16'b????_????_????_?1??};
//			  wildcard bins seq_force_mode_no_force = {16'b????_????_0000_????};
//			  wildcard bins seq_force_mode_50GB_R2  = {16'b????_????_0010_????};
//			  wildcard bins seq_force_mode_100GB_R4 = {16'b????_????_0011_????};
//			  wildcard bins lt_failure_response_0   = {16'b???0_????_????_????}; 
//			  wildcard bins lt_failure_response_1   = {16'b???1_????_????_????}; 
//			  wildcard bins link_fail_if_hiber_0    = {16'b??0?_????_????_????}; 
//			  wildcard bins link_fail_if_hiber_1    = {16'b??1?_????_????_????}; 
//			  wildcard bins skip_lt_on_an_timeout_0 = {16'b?0??_????_????_????}; 
//			  wildcard bins skip_lt_on_an_timeout_1 = {16'b?1??_????_????_????}; 
//			}
//
//  anlt_seq_status       : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"seq_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ))
//                        {
//			  wildcard bins seq_link_ready_0             = {16'b????_????_????_???0};
//			  wildcard bins seq_link_ready_1             = {16'b????_????_????_???1};
//			  wildcard bins seq_an_timeout_0             = {16'b????_????_????_??0?};
//			  wildcard bins seq_an_timeout_1             = {16'b????_????_????_??1?};
//			  wildcard bins seq_lt_timeout_0             = {16'b????_????_????_?0??};
//			  wildcard bins seq_lt_timeout_1             = {16'b????_????_????_?1??};
//			  wildcard bins seq_reconfig_mode_an         = {16'b??00_0001_????_????};
//			  wildcard bins seq_reconfig_mode_lt         = {16'b??00_0010_????_????};
//			  wildcard bins seq_reconfig_mode_50G_data   = {16'b??01_0000_????_????};
//			  wildcard bins seq_reconfig_mode_100G_data  = {16'b??10_0000_????_????};
//			}
//
//  an_cfg1_byte_0_1       : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//  			{
//			  wildcard bins enable_an_0 = {16'b????_????_????_????};
//			  wildcard bins enable_an_1 = {16'b????_????_????_???1};
//			  wildcard bins an_base_pages_ctrl_0 = {16'b????_????_????_??0?};
//			  wildcard bins an_base_pages_ctrl_1 = {16'b????_????_????_??1?};
//			  wildcard bins an_next_pages_ctrl_0 = {16'b????_????_????_?0??};
//			  wildcard bins an_next_pages_ctrl_1 = {16'b????_????_????_?1??};
//			  wildcard bins local_device_remote_fault_0 = {16'b????_????_????_0???};
//			  wildcard bins local_device_remote_fault_1 = {16'b????_????_????_1???};
//			  wildcard bins force_tx_nonce_value_0 = {16'b????_????_???0_????};
//			  wildcard bins force_tx_nonce_value_1 = {16'b????_????_???1_????};
//			  wildcard bins override_an_parameters_enable_0 = {16'b????_????_??0?_????};
//			  wildcard bins override_an_parameters_enable_1 = {16'b????_????_??1?_????};
//			  wildcard bins ignore_nonce_field_0 = {16'b????_????_0???_????};
//			  wildcard bins ignore_nonce_field_1 = {16'b????_????_1???_????};
//			  wildcard bins enable_consortium_next_page_send_0 = {16'b????_???0_????_????};
//			  wildcard bins enable_consortium_next_page_send_1 = {16'b????_???1_????_????};
//			  wildcard bins enable_consortium_next_page_receive_0 = {16'b????_??0?_????_????};
//			  wildcard bins enable_consortium_next_page_receive_1 = {16'b????_??1?_????_????};
//			  wildcard bins enable_consortium_next_page_override_0 = {16'b????_?0??_????_????};
//			  wildcard bins enable_consortium_next_page_override_1 = {16'b????_?1??_????_????};
//			  wildcard bins ignore_consortium_next_page_tech_ability_code_0 = {16'b????_0???_????_????};
//			  wildcard bins ignore_consortium_next_page_tech_ability_code_1 = {16'b????_1???_????_????};
//			}
//
//  an_cfg1_consortium_oui : coverpoint {trans.data_bytes[3],trans.data_bytes[2]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg1")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE));
//
//  an_cfg2_byte_0_1	: coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//			  wildcard bins an_cfg2_reset_an_0 = {16'b????_????_????_???0};
//			  wildcard bins an_cfg2_reset_an_1 = {16'b????_????_????_???1};
//			  wildcard bins an_cfg2_restart_an_txsm_0 = {16'b????_????_???0_????};
//			  wildcard bins an_cfg2_restart_an_txsm_1 = {16'b????_????_???1_????};
//			  wildcard bins an_cfg2_an_next_page_0 = {16'b????_???0_????_????};
//			  wildcard bins an_cfg2_an_next_page_1 = {16'b????_???1_????_????};
//			}
//
//  an_cfg2_consortium_oui_upper	: coverpoint {trans.data_bytes[3]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_cfg2")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE));
//
//  an_status_byte_0	: coverpoint {trans.data_bytes[0]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//			  wildcard bins an_status_an_page_received_0 = {8'b????_??0?};
//			  wildcard bins an_status_an_page_received_1 = {8'b????_??1?};
//			  wildcard bins an_status_an_complete_0 = {8'b????_?0??};
//			  wildcard bins an_status_an_complete_1 = {8'b????_?1??};
//			  wildcard bins an_status_an_adv_remote_fault_0 = {8'b????_0???};
//			  wildcard bins an_status_an_adv_remote_fault_1 = {8'b????_1???};
//			  wildcard bins an_status_an_rxsm_idle_0 = {8'b???0_????};
//			  wildcard bins an_status_an_rxsm_idle_1 = {8'b???1_????};
//			  wildcard bins an_status_an_ability_0 = {8'b??0?_????};
//			  wildcard bins an_status_an_ability_1 = {8'b??1?_????};
//			  wildcard bins an_status_an_status_0 = {8'b?0??_????};
//			  wildcard bins an_status_an_status_1 = {8'b?1??_????};
//			  wildcard bins an_status_an_lp_ability_0 = {8'b0???_????};
//			  wildcard bins an_status_an_lp_ability_1 = {8'b1???_????};
//			}
//
//  an_status_byte_1	: coverpoint {trans.data_bytes[1]}  iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//			  wildcard bins an_status_baser_fec_negotiated_en_0 = {8'b????_???0};
//			  wildcard bins an_status_baser_fec_negotiated_en_1 = {8'b????_???1};
//			  wildcard bins an_status_an_failure_0 = {8'b????_??0?};
//			  wildcard bins an_status_an_failure_1 = {8'b????_??1?};
//			  wildcard bins an_status_consortium_next_page_received_0 = {8'b????_?0??};
//			  wildcard bins an_status_consortium_next_page_received_1 = {8'b????_?1??};
//			  wildcard bins an_status_negotiation_failure_0 = {8'b????_0???};
//			  wildcard bins an_status_negotiation_failure_1 = {8'b????_1???};
//			}
//
//  an_status_ieee_negotiated_port_type	: coverpoint {trans.data_bytes[2][6:0],trans.data_bytes[1][7:4]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//  					{
//					  bins base_1000_kx =           {11'b000_0000_0001};
//					  bins base_10G_kx4 =           {11'b000_0000_0010};
//					  bins base_10G_kr =            {11'b000_0000_0100};
//					  bins base_40G_kr4 =           {11'b000_0000_1000};
//					  bins base_40G_cr4 =           {11'b000_0001_0000};
//					  bins base_100G_cr10 =         {11'b000_0010_0000};
//					  bins base_100G_kp4 =          {11'b000_0100_0000};
//					  bins base_100G_kr4 =          {11'b000_1000_0000};
//					  bins base_100G_cr4 =          {11'b001_0000_0000};
//					  bins base_25G_kr_s_or_cr_s =  {11'b010_0000_0000};
//					  bins base_25G_kr_or_cr =      {11'b100_0000_0000};
//					}
//
//  an_status_byte_3	: coverpoint {trans.data_bytes[3]} iff(get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status")) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//			{
//		  	  wildcard bins an_status_consortium_negotiated_port_type_25Gbase_kr1 = {8'b????_0001};
//		  	  wildcard bins an_status_consortium_negotiated_port_type_25Gbase_cr1 = {8'b????_0010};
//		  	  wildcard bins an_status_consortium_negotiated_port_type_50Gbase_kr2 = {8'b????_0100};
//		  	  wildcard bins an_status_consortium_negotiated_port_type_50Gbase_cr2 = {8'b????_1000};
//			  wildcard bins rs_fec_negotiated_0 = {8'b?0??_????};
//			  wildcard bins rs_fec_negotiated_1 = {8'b?1??_????};
//			}
//

endgroup : anlt_register_cov



//----------------------------------------------------------------------
// Sampling based register coverage according to functionality
//----------------------------------------------------------------------
covergroup lt_reg_cg;
/*
  prbs_ln0_pattern_select_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln0"),"lt_prbs_pattern_select_ln0")
  {
    bins prbs_cl92_0 = {0};
    bins prbs_cl92_1 = {1};
    bins prbs_cl92_2 = {2};
    bins prbs_cl92_3 = {3};
    bins prbs_cl72   = {4};
  }

  prbs_ln0_seed_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln0"),"lt_prbs_seed_ln0")
  {
    bins prbs_seed_0 = {11'h57e};
    bins prbs_seed_1 = {11'h645};
    bins prbs_seed_2 = {11'h72d};
    bins prbs_seed_3 = {11'h7b6};
  }
  prbs_ln0_cross : cross prbs_ln0_pattern_select_cp , prbs_ln0_seed_cp {
    bins cl72_cl93_mix =          binsof(prbs_ln0_pattern_select_cp) intersect {0} &&
                                  binsof(prbs_ln0_pattern_select_cp) intersect {1} &&
                                  binsof(prbs_ln0_pattern_select_cp) intersect {2} &&
                                  binsof(prbs_ln0_pattern_select_cp) intersect {3}; 

    ignore_bins IGNORE_cl72_cl93_mix = binsof (prbs_ln0_pattern_select_cp) intersect {4};
  }

  prbs_ln1_pattern_select_cp :coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln1"),"lt_prbs_pattern_select_ln1")
  {
    bins prbs_cl92_0 = {0};
    bins prbs_cl92_1 = {1};
    bins prbs_cl92_2 = {2};
    bins prbs_cl92_3 = {3};
    bins prbs_cl72   = {4};
  }

  prbs_ln1_seed_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln1"),"lt_prbs_seed_ln1")
  {
    bins prbs_seed_0 = {11'h57e};
    bins prbs_seed_1 = {11'h645};
    bins prbs_seed_2 = {11'h72d};
    bins prbs_seed_3 = {11'h7b6};
  }

  prbs_ln1_cross : cross prbs_ln1_pattern_select_cp , prbs_ln1_seed_cp {
    bins cl72_cl93_mix =          binsof(prbs_ln1_pattern_select_cp) intersect {0} &&
                                  binsof(prbs_ln1_pattern_select_cp) intersect {1} &&
                                  binsof(prbs_ln1_pattern_select_cp) intersect {2} &&
                                  binsof(prbs_ln1_pattern_select_cp) intersect {3}; 

    ignore_bins IGNORE_cl72_cl93_mix = binsof (prbs_ln1_pattern_select_cp) intersect {4};
  }


  prbs_ln2_pattern_select_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln2"),"lt_prbs_pattern_select_ln2")
  {
    bins prbs_cl92_0 = {0};
    bins prbs_cl92_1 = {1};
    bins prbs_cl92_2 = {2};
    bins prbs_cl92_3 = {3};
    bins prbs_cl72   = {4};
  }

  prbs_ln2_seed_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln2"),"lt_prbs_seed_ln2")
  {
    bins prbs_seed_0 = {11'h57e};
    bins prbs_seed_1 = {11'h645};
    bins prbs_seed_2 = {11'h72d};
    bins prbs_seed_3 = {11'h7b6};
  }

   prbs_ln2_cross : cross prbs_ln2_pattern_select_cp , prbs_ln2_seed_cp {
    bins cl72_cl93_mix =          binsof(prbs_ln2_pattern_select_cp) intersect {0} &&
                                  binsof(prbs_ln2_pattern_select_cp) intersect {1} &&
                                  binsof(prbs_ln2_pattern_select_cp) intersect {2} &&
                                  binsof(prbs_ln2_pattern_select_cp) intersect {3}; 

    ignore_bins IGNORE_cl72_cl93_mix = binsof (prbs_ln2_pattern_select_cp) intersect {4};
  }

  prbs_ln3_pattern_select_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln3"),"lt_prbs_pattern_select_ln3")
  {
    bins prbs_cl92_0 = {0};
    bins prbs_cl92_1 = {1};
    bins prbs_cl92_2 = {2};
    bins prbs_cl92_3 = {3};
    bins prbs_cl72   = {4};
  }

  prbs_ln3_seed_cp : coverpoint get_anlt_reg_field($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln3"),"lt_prbs_seed_ln3")
  {
    bins prbs_seed_0 = {11'h57e};
    bins prbs_seed_1 = {11'h645};
    bins prbs_seed_2 = {11'h72d};
    bins prbs_seed_3 = {11'h7b6};
  }

   prbs_ln3_cross : cross prbs_ln3_pattern_select_cp , prbs_ln3_seed_cp {
    bins cl72_cl93_mix =          binsof(prbs_ln3_pattern_select_cp) intersect {0} &&
                                  binsof(prbs_ln3_pattern_select_cp) intersect {1} &&
                                  binsof(prbs_ln3_pattern_select_cp) intersect {2} &&
                                  binsof(prbs_ln3_pattern_select_cp) intersect {3}; 

    ignore_bins IGNORE_cl72_cl93_mix = binsof (prbs_ln3_pattern_select_cp) intersect {4};
  }*/

endgroup 

covergroup write_reg_cov;

`WRITE_AN_REGISTER_COVERAGE(seq_cfg,`ETH_ANLT_F_CSR_port0_seq_cfg_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(seq_status,`ETH_ANLT_F_CSR_port0_seq_status_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg1,`ETH_ANLT_F_CSR_port0_an_cfg1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg2,`ETH_ANLT_F_CSR_port0_an_cfg2_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_status,`ETH_ANLT_F_CSR_port0_an_status_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg3,`ETH_ANLT_F_CSR_port0_an_cfg3_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg4,`ETH_ANLT_F_CSR_port0_an_cfg4_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg5,`ETH_ANLT_F_CSR_port0_an_cfg5_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg6,`ETH_ANLT_F_CSR_port0_an_cfg6_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_status1,`ETH_ANLT_F_CSR_port0_an_status1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_status2,`ETH_ANLT_F_CSR_port0_an_status2_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_status3,`ETH_ANLT_F_CSR_port0_an_status3_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_status4,`ETH_ANLT_F_CSR_port0_an_status4_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`WRITE_AN_REGISTER_COVERAGE(an_status5,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status5")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_cfg8,`ETH_ANLT_F_CSR_port0_an_cfg8_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(an_status6,`ETH_ANLT_F_CSR_port0_an_status6_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(lt_cfg1,`ETH_ANLT_F_CSR_port0_lt_cfg1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(lt_cfg2,`ETH_ANLT_F_CSR_port0_lt_cfg2_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_AN_REGISTER_COVERAGE(lt_status1,`ETH_ANLT_F_CSR_port0_lt_status1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`WRITE_AN_REGISTER_COVERAGE(lt_cfg3_ln0,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln0")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`WRITE_AN_REGISTER_COVERAGE(lt_cfg3_ln1,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln1")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`WRITE_AN_REGISTER_COVERAGE(lt_cfg3_ln2,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln2")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`WRITE_AN_REGISTER_COVERAGE(lt_cfg3_ln3,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln3")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})

       //Revisit: vinoth2x
/*write_invalid_address: coverpoint address iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) {
       //bins invalid_addr[64] = {['h0:'hFFFF]};
       bins invalid_addr_0 = {'h0};
       bins invalid_addr_1 = {['h1:'h2FE]};
       bins invalid_addr_2 = {'h2FF};
       bins invalid_phy[6] = {[16'h300:16'h3FF]};
       bins invalid_tx_mac[6] = {[16'h400:16'h4FF]};
       bins invalid_rx_mac[6] = {[16'h500:16'h5FF]};
       `ifdef G100
       bins invalid_addr_3 = {16'h600};
       bins invalid_addr_4 = {[16'h601:16'h7FE]};
       bins invalid_addr_5 = {16'h7FF};
       `else
       bins invalid_tx_flow_control[6] = {[16'h600:16'h6FF]};
       bins invalid_rx_flow_control[6] = {[16'h700:16'h7FF]};
       `endif
       bins invalid_tx_stats[6] = {[16'h800:16'h8FF]};
       bins invalid_rx_stats[6] = {[16'h900:16'h9FF]};
       bins invalid_addr_6 = {16'hA00};
       bins invalid_addr_7 = {[16'hA01:16'hBFE]};
       bins invalid_addr_8 = {16'hBFF};
       `ifdef G100
       bins invalid_tx_rsfec[6] = {[16'hC00:16'hCFF]};
       bins invalid_rx_rsfec[6] = {[16'hD00:16'hDFF]};
       `else
       bins invalid_addr_9 = {16'hC00};
       bins invalid_addr_10 = {[16'hC01:16'hDFE]};
       bins invalid_addr_11 = {16'hDFF};
       `endif
       bins invalid_addr_12 = {16'hE00};
       bins invalid_addr_13 = {[16'hE01:16'hFFFE]};
       bins invalid_addr_14 = {16'hFFFF};
       //Ignoring valid addresses
       `ifdef G100
       ignore_bins ignore_addr = {'h300, 'h301, 'h302, 'h303, 'h304, 'h310, 'h312, 'h313, 'h314, 'h315, 'h321, 'h322, 'h323, 'h324, 'h325, 'h326, 'h327, 'h328, 'h329, 'h330, 'h331, 'h332, 'h333, 'h340, 'h341, 'h342, 'h343, 'h344, 'h400, 'h401, 'h402, 'h403, 'h404, 'h405, 'h406, 'h407, 'h408, 'h40a, 'h500, 'h501, 'h502, 'h503, 'h504, 'h506, 'h507, 'h508, 'h50a, 'h800, 'h801, 'h802, 'h803, 'h804, 'h805, 'h806, 'h807, 'h808, 'h809, 'h80a, 'h80b, 'h80c, 'h80d, 'h80e, 'h80f, 'h810, 'h811, 'h812, 'h813, 'h814, 'h815, 'h816, 'h817, 'h818, 'h819, 'h81a, 'h81b, 'h81c, 'h81d, 'h81e, 'h81f, 'h820, 'h821, 'h822, 'h823, 'h824, 'h825, 'h826, 'h827, 'h828, 'h829, 'h82a, 'h82b, 'h82c, 'h82d, 'h82e, 'h82f, 'h830, 'h831, 'h832, 'h833, 'h834, 'h835, 'h845, 'h846, 'h860, 'h861, 'h862, 'h863, 'h900, 'h901, 'h902, 'h903, 'h904, 'h905, 'h906, 'h907, 'h908, 'h909, 'h90a, 'h90b, 'h90c, 'h90d, 'h90e, 'h90f, 'h910, 'h911, 'h912, 'h913, 'h914, 'h915, 'h916, 'h917, 'h918, 'h919, 'h91a, 'h91b, 'h91c, 'h91d, 'h91e, 'h91f, 'h920, 'h921, 'h922, 'h923, 'h924, 'h925, 'h926, 'h927, 'h928, 'h929, 'h92a, 'h92b, 'h92c, 'h92d, 'h92e, 'h92f, 'h930, 'h931, 'h932, 'h933, 'h934, 'h935, 'h945, 'h946, 'h960, 'h961, 'h962, 'h963, 'hc00, 'hc01, 'hc02, 'hc03, 'hc04, 'hc05, 'hc06, 'hc07, 'hd00, 'hd01, 'hd02, 'hd03, 'hd04, 'hd05, 'hd06, 'hd07, 'hd08};
       `else
        ignore_bins ignore_addr = {'h300, 'h301, 'h302, 'h303, 'h304, 'h310, 'h312, 'h313, 'h314, 'h315, 'h321, 'h322, 'h323, 'h324, 'h325, 'h326, 'h327, 'h328, 'h329, 'h330, 'h331, 'h340, 'h341, 'h342, 'h400, 'h401, 'h402, 'h403, 'h404, 'h405, 'h406, 'h407, 'h408, 'h40a, 'h500, 'h501, 'h502, 'h503, 'h504, 'h506, 'h507, 'h508, 'h50a, 'h600, 'h601, 'h602, 'h603, 'h604, 'h605, 'h606, 'h60a, 'h60d, 'h60e, 'h60f, 'h610, 'h620, 'h621, 'h622, 'h623, 'h624, 'h625, 'h626, 'h627, 'h628, 'h629, 'h62a, 'h62b, 'h62c, 'h62d, 'h62e, 'h62f, 'h640, 'h641, 'h700, 'h701, 'h702, 'h703, 'h704, 'h705, 'h707, 'h708, 'h800, 'h801, 'h802, 'h803, 'h804, 'h805, 'h806, 'h807, 'h808, 'h809, 'h80a, 'h80b, 'h80c, 'h80d, 'h80e, 'h80f, 'h810, 'h811, 'h812, 'h813, 'h814, 'h815, 'h816, 'h817, 'h818, 'h819, 'h81a, 'h81b, 'h81c, 'h81d, 'h81e, 'h81f, 'h820, 'h821, 'h822, 'h823, 'h824, 'h825, 'h826, 'h827, 'h828, 'h829, 'h82a, 'h82b, 'h82c, 'h82d, 'h82e, 'h82f, 'h830, 'h831, 'h832, 'h833, 'h834, 'h835, 'h845, 'h846, 'h860, 'h861, 'h862, 'h863, 'h900, 'h901, 'h902, 'h903, 'h904, 'h905, 'h906, 'h907, 'h908, 'h909, 'h90a, 'h90b, 'h90c, 'h90d, 'h90e, 'h90f, 'h910, 'h911, 'h912, 'h913, 'h914, 'h915, 'h916, 'h917, 'h918, 'h919, 'h91a, 'h91b, 'h91c, 'h91d, 'h91e, 'h91f, 'h920, 'h921, 'h922, 'h923, 'h924, 'h925, 'h926, 'h927, 'h928, 'h929, 'h92a, 'h92b, 'h92c, 'h92d, 'h92e, 'h92f, 'h930, 'h931, 'h932, 'h933, 'h934, 'h935, 'h945, 'h946, 'h960, 'h961, 'h962, 'h963};
       `endif
    }*/


endgroup

covergroup read_reg_cov;

`READ_RW_REG_COV(seq_cfg_csr,`ETH_ANLT_F_CSR_port0_seq_cfg_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_seq_cfg_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(seq_status_csr,`ETH_ANLT_F_CSR_port0_seq_status_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_seq_status_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(an_cfg1_csr,`ETH_ANLT_F_CSR_port0_an_cfg1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg1_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(an_cfg2_csr,`ETH_ANLT_F_CSR_port0_an_cfg2_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg2_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(an_status_csr,`ETH_ANLT_F_CSR_port0_an_status_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_status_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(an_cfg3_csr,`ETH_ANLT_F_CSR_port0_an_cfg3_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg3_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(an_cfg4_csr,`ETH_ANLT_F_CSR_port0_an_cfg4_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg4_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(an_cfg5_csr,`ETH_ANLT_F_CSR_port0_an_cfg5_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg5_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(an_cfg6_csr,`ETH_ANLT_F_CSR_port0_an_cfg6_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg6_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(an_status1_csr,`ETH_ANLT_F_CSR_port0_an_status1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_status1_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(an_status2_csr,`ETH_ANLT_F_CSR_port0_an_status2_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_status2_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(an_status3_csr,`ETH_ANLT_F_CSR_port0_an_status3_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_status3_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(an_status4_csr,`ETH_ANLT_F_CSR_port0_an_status4_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_status4_csr_RESET_VALUE_REG)
//`READ_RO_REG_COV(an_status5,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"an_status5")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REG_COV(an_cfg8_csr,`ETH_ANLT_F_CSR_port0_an_cfg8_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_cfg8_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(an_status6_csr,`ETH_ANLT_F_CSR_port0_an_status6_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_an_status6_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(lt_cfg1_csr,`ETH_ANLT_F_CSR_port0_lt_cfg1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_lt_cfg1_csr_RESET_VALUE_REG)
`READ_RW_REG_COV(lt_cfg2_csr,`ETH_ANLT_F_CSR_port0_lt_cfg2_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_lt_cfg2_csr_RESET_VALUE_REG)
`READ_RO_REG_COV(lt_status1_csr,`ETH_ANLT_F_CSR_port0_lt_status1_csr_OFFSET_REG,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]},`ETH_ANLT_F_CSR_port0_lt_status1_csr_RESET_VALUE_REG)
//`READ_RW_REG_COV(lt_cfg3_ln0,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln0")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`READ_RW_REG_COV(lt_cfg3_ln1,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln1")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`READ_RW_REG_COV(lt_cfg3_ln2,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln2")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//`READ_RW_REG_COV(lt_cfg3_ln3,get_anlt_reg_offset($sformatf("port%0d_%0s_csr",address[11:8],"lt_cfg3_ln3")),address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})


       //Revisit: vinoth2x
/*read_invalid_address: coverpoint address iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ) {
       //bins invalid_addr[64] = {['h0:'hFFFF]};
       bins invalid_addr_0 = {'h0};
       bins invalid_addr_1 = {['h1:'h2FE]};
       bins invalid_addr_2 = {'h2FF};
       bins invalid_phy[6] = {[16'h300:16'h3FF]};
       bins invalid_tx_mac[6] = {[16'h400:16'h4FF]};
       bins invalid_rx_mac[6] = {[16'h500:16'h5FF]};
       `ifdef G100
       bins invalid_addr_3 = {16'h600};
       bins invalid_addr_4 = {[16'h601:16'h7FE]};
       bins invalid_addr_5 = {16'h7FF};
       `else
       bins invalid_tx_flow_control[6] = {[16'h600:16'h6FF]};
       bins invalid_rx_flow_control[6] = {[16'h700:16'h7FF]};
       `endif
       bins invalid_tx_stats[6] = {[16'h800:16'h8FF]};
       bins invalid_rx_stats[6] = {[16'h900:16'h9FF]};
       bins invalid_addr_6 = {16'hA00};
       bins invalid_addr_7 = {[16'hA01:16'hBFE]};
       bins invalid_addr_8 = {16'hBFF};
       `ifdef G100
       bins invalid_tx_rsfec[6] = {[16'hC00:16'hCFF]};
       bins invalid_rx_rsfec[6] = {[16'hD00:16'hDFF]};
       `else
       bins invalid_addr_9 = {16'hC00};
       bins invalid_addr_10 = {[16'hC01:16'hDFE]};
       bins invalid_addr_11 = {16'hDFF};
       `endif
       bins invalid_addr_12 = {16'hE00};
       bins invalid_addr_13 = {[16'hE01:16'hFFFE]};
       bins invalid_addr_14 = {16'hFFFF};
       //Ignoring valid addresses
       `ifdef G100
       ignore_bins ignore_addr = {'h300, 'h301, 'h302, 'h303, 'h304, 'h310, 'h312, 'h313, 'h314, 'h315, 'h321, 'h322, 'h323, 'h324, 'h325, 'h326, 'h327, 'h328, 'h329, 'h330, 'h331, 'h332, 'h333, 'h340, 'h341, 'h342, 'h343, 'h344, 'h400, 'h401, 'h402, 'h403, 'h404, 'h405, 'h406, 'h407, 'h408, 'h40a, 'h500, 'h501, 'h502, 'h503, 'h504, 'h506, 'h507, 'h508, 'h50a, 'h800, 'h801, 'h802, 'h803, 'h804, 'h805, 'h806, 'h807, 'h808, 'h809, 'h80a, 'h80b, 'h80c, 'h80d, 'h80e, 'h80f, 'h810, 'h811, 'h812, 'h813, 'h814, 'h815, 'h816, 'h817, 'h818, 'h819, 'h81a, 'h81b, 'h81c, 'h81d, 'h81e, 'h81f, 'h820, 'h821, 'h822, 'h823, 'h824, 'h825, 'h826, 'h827, 'h828, 'h829, 'h82a, 'h82b, 'h82c, 'h82d, 'h82e, 'h82f, 'h830, 'h831, 'h832, 'h833, 'h834, 'h835, 'h845, 'h846, 'h860, 'h861, 'h862, 'h863, 'h900, 'h901, 'h902, 'h903, 'h904, 'h905, 'h906, 'h907, 'h908, 'h909, 'h90a, 'h90b, 'h90c, 'h90d, 'h90e, 'h90f, 'h910, 'h911, 'h912, 'h913, 'h914, 'h915, 'h916, 'h917, 'h918, 'h919, 'h91a, 'h91b, 'h91c, 'h91d, 'h91e, 'h91f, 'h920, 'h921, 'h922, 'h923, 'h924, 'h925, 'h926, 'h927, 'h928, 'h929, 'h92a, 'h92b, 'h92c, 'h92d, 'h92e, 'h92f, 'h930, 'h931, 'h932, 'h933, 'h934, 'h935, 'h945, 'h946, 'h960, 'h961, 'h962, 'h963, 'hc00, 'hc01, 'hc02, 'hc03, 'hc04, 'hc05, 'hc06, 'hc07, 'hd00, 'hd01, 'hd02, 'hd03, 'hd04, 'hd05, 'hd06, 'hd07, 'hd08};
       `else
        ignore_bins ignore_addr = {'h300, 'h301, 'h302, 'h303, 'h304, 'h310, 'h312, 'h313, 'h314, 'h315, 'h321, 'h322, 'h323, 'h324, 'h325, 'h326, 'h327, 'h328, 'h329, 'h330, 'h331, 'h340, 'h341, 'h342, 'h400, 'h401, 'h402, 'h403, 'h404, 'h405, 'h406, 'h407, 'h408, 'h40a, 'h500, 'h501, 'h502, 'h503, 'h504, 'h506, 'h507, 'h508, 'h50a, 'h600, 'h601, 'h602, 'h603, 'h604, 'h605, 'h606, 'h60a, 'h60d, 'h60e, 'h60f, 'h610, 'h620, 'h621, 'h622, 'h623, 'h624, 'h625, 'h626, 'h627, 'h628, 'h629, 'h62a, 'h62b, 'h62c, 'h62d, 'h62e, 'h62f, 'h640, 'h641, 'h700, 'h701, 'h702, 'h703, 'h704, 'h705, 'h707, 'h708, 'h800, 'h801, 'h802, 'h803, 'h804, 'h805, 'h806, 'h807, 'h808, 'h809, 'h80a, 'h80b, 'h80c, 'h80d, 'h80e, 'h80f, 'h810, 'h811, 'h812, 'h813, 'h814, 'h815, 'h816, 'h817, 'h818, 'h819, 'h81a, 'h81b, 'h81c, 'h81d, 'h81e, 'h81f, 'h820, 'h821, 'h822, 'h823, 'h824, 'h825, 'h826, 'h827, 'h828, 'h829, 'h82a, 'h82b, 'h82c, 'h82d, 'h82e, 'h82f, 'h830, 'h831, 'h832, 'h833, 'h834, 'h835, 'h845, 'h846, 'h860, 'h861, 'h862, 'h863, 'h900, 'h901, 'h902, 'h903, 'h904, 'h905, 'h906, 'h907, 'h908, 'h909, 'h90a, 'h90b, 'h90c, 'h90d, 'h90e, 'h90f, 'h910, 'h911, 'h912, 'h913, 'h914, 'h915, 'h916, 'h917, 'h918, 'h919, 'h91a, 'h91b, 'h91c, 'h91d, 'h91e, 'h91f, 'h920, 'h921, 'h922, 'h923, 'h924, 'h925, 'h926, 'h927, 'h928, 'h929, 'h92a, 'h92b, 'h92c, 'h92d, 'h92e, 'h92f, 'h930, 'h931, 'h932, 'h933, 'h934, 'h935, 'h945, 'h946, 'h960, 'h961, 'h962, 'h963};
       `endif
    }*/

endgroup
`endif
`endif

//----------------------------------------------------------------------
//Function: write
//This function gets avalon uvc transaction 
//----------------------------------------------------------------------
virtual function void write_avmm_bus_anlt(altuvm_avalon_mm_req_base tr);
   `uvm_info("anlt_register_coverage", $sformatf("avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   $cast(trans,tr.clone());
   `uvm_info("anlt_register_coverage", $sformatf("avmm transaction \n %0s",trans.sprint()), UVM_DEBUG);
   address = trans.address>>2;
   `uvm_info("anlt_register_coverage", $sformatf("avmm transaction address %0h",address), UVM_HIGH);
   `ifdef ANLT
     `ifdef COV
   if(dis_reg_cov==0) begin
     //Revist
     anlt_register_cov.sample();
   end
   `uvm_info("anlt_register_coverage", $sformatf("avmm transaction \n %0s",tr.sprint()), UVM_LOW);
     //Revist
     read_reg_cov.sample();
     write_reg_cov.sample();
  `endif
`endif
endfunction : write_avmm_bus_anlt

//==============================================================================
// Function: new
//============================================================================== 
function new(string name, uvm_component parent);
   super.new(name,parent);
   avmm_bus_anlt = new("avmm_bus_anlt", this);
   // Get Dyn cfg obj
   //if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
   //   `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   //end
   `ifdef ANLT
     `ifdef COV
   anlt_register_cov = new();
   lt_reg_cg = new();
   write_reg_cov = new();
   read_reg_cov = new();
   `endif
 `endif
endfunction: new

function void report_phase(uvm_phase phase);
   super.report_phase(phase);
   if(frame_xfer_active) begin
     //print_reg_data_for_debug();
   end
   else begin
     `uvm_info(get_name(),"BEWARE : NO FRAME TRANSMITTED DURING SIMULATION. PLEASE CHECK IF THIS IS DESIRED\n",UVM_NONE)
   end
endfunction:report_phase

task run_phase(uvm_phase phase);
   super.run_phase(phase);
   `ifdef ANLT
     `ifdef COV
   fork
     begin
       forever begin
         @(spy_if.seq_mode);
         if(spy_if.seq_mode[1] == 1'b1)
           anlt_register_cov.sample();
	    end
    end
    begin
         forever begin
          @(spy_if.seq_mode);
          anlt_register_cov.sample();
         end
    end
    begin
         forever begin
          @(spy_if.rx_pcs_ready);
          anlt_register_cov.sample();
         end
      end
      begin
         forever begin
            @(spy_if.rx_am_lock);
            anlt_register_cov.sample();
         end
      end
      begin
         forever begin
            @(spy_if.o_rx_hi_ber);
            anlt_register_cov.sample();
         end
      end
   join
 `endif
 `endif
   
endtask : run_phase  

endclass: anlt_register_coverage

`endif // ANLT_REGISTER_COVERAGE__SV
