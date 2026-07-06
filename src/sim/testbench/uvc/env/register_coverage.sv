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

`ifndef REGISTER_COVERAGE__SV
`define REGISTER_COVERAGE__SV
 //typedef logic[31:0] logic_b;
 //typedef logic_b logic_a[32];

`define STAT_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
           bins stat_zero = {'h0};\
           bins stat_non_zero = {['h1:'hFFFF_FFFF]} with (!(item inside {'hdead_c0de}));\
         }
`define STAT_REGISTER_COVERAGE_ZERO(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
           bins stat_zero = {'h0};\
         }
`define WRITE_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE && addr == address)\
         {\
	   bins access_done = {['h1:'hFFFF_FFFF]};\
         }
`define WRITE_MAC_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE && addr == address)\
         {\
	   bins access_done = {['h1:'hFFFF_FFFF]} with (item && (dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC));\
         }

	   // GDR : Individual bit coverage is not required, it is already
	   // tested in IP level, we just need to check whether access is
	   // worked or not.
           //wildcard bins one0 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1};\
           //wildcard bins one1 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x};\
           //wildcard bins one2 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx};\
           //wildcard bins one3 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx};\
           //wildcard bins one4 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx};\
           //wildcard bins one5 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx};\
           //wildcard bins one6 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx};\
           //wildcard bins one7 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx};\
           //wildcard bins one8 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx};\
           //wildcard bins one9 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx};\
           //wildcard bins one10 = {32'bxxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx};\
           //wildcard bins one11 = {32'bxxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx};\
           //wildcard bins one12 = {32'bxxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx};\
           //wildcard bins one13 = {32'bxxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx};\
           //wildcard bins one14 = {32'bxxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx};\
           //wildcard bins one15 = {32'bxxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx};\
           //wildcard bins one16 = {32'bxxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one17 = {32'bxxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one18 = {32'bxxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one19 = {32'bxxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one20 = {32'bxxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one21 = {32'bxxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one22 = {32'bxxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one23 = {32'bxxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one24 = {32'bxxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one25 = {32'bxxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one26 = {32'bxxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one27 = {32'bxxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one28 = {32'bxxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one29 = {32'bxx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one30 = {32'bx1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins one31 = {32'b1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero0 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx0};\
           //wildcard bins zero1 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx0x};\
           //wildcard bins zero2 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx0xx};\
           //wildcard bins zero3 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx0xxx};\
           //wildcard bins zero4 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx0xxxx};\
           //wildcard bins zero5 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx0xxxxx};\
           //wildcard bins zero6 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x0xxxxxx};\
           //wildcard bins zero7 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_0xxxxxxx};\
           //wildcard bins zero8 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxxx0_xxxxxxxx};\
           //wildcard bins zero9 =  {32'bxxxxxxxx_xxxxxxxx_xxxxxx0x_xxxxxxxx};\
           //wildcard bins zero10 = {32'bxxxxxxxx_xxxxxxxx_xxxxx0xx_xxxxxxxx};\
           //wildcard bins zero11 = {32'bxxxxxxxx_xxxxxxxx_xxxx0xxx_xxxxxxxx};\
           //wildcard bins zero12 = {32'bxxxxxxxx_xxxxxxxx_xxx0xxxx_xxxxxxxx};\
           //wildcard bins zero13 = {32'bxxxxxxxx_xxxxxxxx_xx0xxxxx_xxxxxxxx};\
           //wildcard bins zero14 = {32'bxxxxxxxx_xxxxxxxx_x0xxxxxx_xxxxxxxx};\
           //wildcard bins zero15 = {32'bxxxxxxxx_xxxxxxxx_0xxxxxxx_xxxxxxxx};\
           //wildcard bins zero16 = {32'bxxxxxxxx_xxxxxxx0_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero17 = {32'bxxxxxxxx_xxxxxx0x_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero18 = {32'bxxxxxxxx_xxxxx0xx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero19 = {32'bxxxxxxxx_xxxx0xxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero20 = {32'bxxxxxxxx_xxx0xxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero21 = {32'bxxxxxxxx_xx0xxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero22 = {32'bxxxxxxxx_x0xxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero23 = {32'bxxxxxxxx_0xxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero24 = {32'bxxxxxxx0_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero25 = {32'bxxxxxx0x_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero26 = {32'bxxxxx0xx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero27 = {32'bxxxx0xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero28 = {32'bxxx0xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero29 = {32'bxx0xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero30 = {32'bx0xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\
           //wildcard bins zero31 = {32'b0xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};\

//muralasx: Original
`define READ_RW_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
          // bins reset = {```name``_RESET_VALUE_REG};\
           bins non_reset = {['h1:'hFFFF_FFFF]} with (!(item inside {```name``_RESET_VALUE_REG}));\
         }
`define READ_RW_REGISTER_COVERAGE_10G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	  // bins reset= {`ETH_F_ALL_e25_``name``_RESET_VALUE_REG};\
           bins non_reset= {['h1:'hFFFF_FFFF]} with (!(item inside {```name``_RESET_VALUE_REG}));\
   }
`define READ_RW_REGISTER_COVERAGE_50G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	  // bins reset= {`ETH_F_ALL_e50_``name``_RESET_VALUE_REG};\
           bins non_reset= {['h1:'hFFFF_FFFF]} with (!(item inside {`ETH_F_ALL_e50_``name``_RESET_VALUE_REG}));\
	}
`define READ_RW_REGISTER_COVERAGE_100G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	  // bins reset= {`ETH_F_ALL_e100_``name``_RESET_VALUE_REG};\
           bins non_reset= {['h1:'hFFFF_FFFF]} with (!(item inside {`ETH_F_ALL_e100_``name``_RESET_VALUE_REG}));\
	 }
`define READ_RW_REGISTER_COVERAGE_200G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	  // bins reset= {`ETH_F_ALL_e200_``name``_RESET_VALUE_REG};\
           bins non_reset= {['h1:'hFFFF_FFFF]} with (!(item inside {`ETH_F_ALL_e200_``name``_RESET_VALUE_REG}));\
	 }
`define READ_RW_REGISTER_COVERAGE_400G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	 //  bins reset= {`ETH_F_ALL_e400_``name``_RESET_VALUE_REG};\
           bins non_reset= {['h1:'hFFFF_FFFF]} with (!(item inside {`ETH_F_ALL_e400_``name``_RESET_VALUE_REG}));\
	 }

//muralasx: Original
`define READ_RO_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
           bins reset = {`ETH_F_ALL_``name``_RESET_VALUE_REG};\
         }
//`define READ_RO_REGISTER_COVERAGE_10G(name,addr,address,data)\
  //cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
    //     {\
	  //       bins reset= {``name``_RESET_VALUE_REG};\
       //  }
`define READ_RO_REGISTER_COVERAGE_10G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	         bins reset= {```name``_RESET_VALUE_REG};\
         }
`define READ_RO_REGISTER_COVERAGE_50G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	         bins reset= {`ETH_F_ALL_e50_``name``_RESET_VALUE_REG};\
         }
`define READ_RO_REGISTER_COVERAGE_100G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	         bins reset= {`ETH_F_ALL_e100_``name``_RESET_VALUE_REG};\
         }
`define READ_RO_REGISTER_COVERAGE_200G(name,addr,address,data)\
  cp_``name : coverpoint data iff(1rans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	         bins reset= {`ETH_F_ALL_e200_``name``_RESET_VALUE_REG};\
         }
`define READ_RO_REGISTER_COVERAGE_400G(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
	         bins reset= {`ETH_F_ALL_e400_``name``_RESET_VALUE_REG};\
         }

`define READ_DUT_CONFIG_PARAM_REGISTER_COVERAGE(name,addr,address,data)\
  cp_``name : coverpoint data iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ && addr == address)\
         {\
           bins reset = {```name``_RESET_VALUE_REG};\
           bins non_reset = {['h1:'hFFFF_FFFF]} with (!(item inside {```name``_RESET_VALUE_REG}));\
           bins reg_off = {'hdead_c0de};\
         }



`uvm_analysis_imp_decl(_avmm_bus)
`uvm_analysis_imp_decl(_eth_frame_from_driver)
`uvm_analysis_imp_decl(_eth_frame_from_vip)
//`ifdef G40
`uvm_analysis_imp_decl(_pause_tx_pkt)
`uvm_analysis_imp_decl(_pause_rx_pkt)
//`uvm_analysis_imp_decl(_pause_tx_intf)
//`endif

class register_coverage extends uvm_component;
 
  virtual spy_interface spy_if;
  bit [1:0] tx_fc_csr_xon_xoff_2_bit_mode[8];
  bit register_cov_enable=1;
  altuvm_avalon_mm_req_base trans;
  eth_packet eth_trans;
  bit [63:0] address;
  bit dis_reg_cov;
  registers_urm reg_model;
  bit mac_tx_size_equal;
  bit mac_tx_size_greater_than;
  bit mac_tx_size_less_than;
  bit mac_rx_size_equal;
  bit mac_rx_size_greater_than;
  bit mac_rx_size_less_than;
  eth_transaction_frame_type frame_type;
  bit frame_xfer_active;
  bit rx_mac_control_en_plen;
  bit rx_mac_control_disable_rxvlan;
  bit rx_mac_control_en_check_sfd;
  bit rx_mac_control_en_strict_preamble;
  bit rx_mac_control_enforce_max_rx;
  bit rx_mac_control_remove_rx_pad;
  bit rx_mac_control_srst_n;
  bit rx_mac_control_lcg_en;
  bit tx_mac_control_disable_txvlan;
  bit tx_mac_control_disable_txmac;
  bit tx_mac_control_en_saddr_insert;
  bit tx_mac_control_use_am_insert;
  bit tx_mac_control_use_ptp;
  bit tx_mac_control_srst_n;
  bit tx_mac_control_lcg_en;
  bit txmac_ehip_cfg_en_pp;
  bit [1:0] txmac_ehip_cfg_ipg;
  bit [2:0] txmac_ehip_cfg_am_width;
  bit [2:0] txmac_ehip_cfg_flowreg_rate;
  bit txmac_ehip_cfg_txcrc_covers_preamble;
  bit [16:0] txmac_ehip_cfg_am_period;
  bit rxmac_ehip_cfg_en_pp;
  bit rxmac_ehip_cfg_rxcrc_covers_preamble;


   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;

  //Port: avmm_bus
  //This port receives the avmm item from monitor
 uvm_analysis_imp_avmm_bus #(altuvm_avalon_mm_req_base, register_coverage) avmm_bus;
 uvm_analysis_imp_eth_frame_from_driver #(eth_packet,register_coverage) eth_frame_from_driver;
 uvm_analysis_imp_eth_frame_from_vip #(eth_packet,register_coverage) eth_frame_from_vip;
 //`ifdef G40
   uvm_analysis_imp_pause_tx_pkt #(eth_packet,register_coverage) pause_tx_pkt;
   uvm_analysis_imp_pause_rx_pkt #(eth_packet,register_coverage) pause_rx_pkt;
//   uvm_analysis_imp_pause_tx_intf #(eth_packet,register_coverage) pause_tx_intf;
 //`endif

  `uvm_component_utils(register_coverage)

//==============================================================================
// Function: build_phase
//==============================================================================
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#()::get(this,"","register_cov_enable",register_cov_enable)) begin
      `uvm_info("Register_Coverage","Register Coverage is enable",UVM_MEDIUM);
    end
    if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
       `uvm_fatal("spy_interface", "failed to get spy_interface intf");
     end
   // Get Dyn cfg obj
   //if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
   //   `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   //end
endfunction:build_phase


/* Gets the register or field value from ral and return as  bit vector*/
function int gdr_ral_get(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    //DM_TODO: remove case (dyn_rcfg_obj_inst.speed)
    //DM_TODO: remove _10G : regname = {"e25_",regname};
    //DM_TODO: remove _25G : regname = {"e25_",regname};
    //DM_TODO: remove _50G : regname = {"e50_",regname};
    //DM_TODO: remove _40G : regname = {"e100_",regname};
    //DM_TODO: remove _100G : regname = {"e100_",regname};
    //DM_TODO: remove _200G : regname = {"e200_",regname};
    //DM_TODO: remove _400G : regname = {"e400_",regname};
    //DM_TODO: remove endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        if(fldname == "") return reg_l.get();
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
          return fld_l.get();
        end
      end
    end
    `uvm_fatal("register_coverage", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction 

/* Gets the register or field value from ral and return as  bit vector*/
function int gdr_ral_get_mirr_val(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    //DM_TODO: remove case (dyn_rcfg_obj_inst.speed)
    //DM_TODO: remove _10G : regname = {"e25_",regname};
    //DM_TODO: remove _25G : regname = {"e25_",regname};
    //DM_TODO: remove _50G : regname = {"e50_",regname};
    //DM_TODO: remove _40G : regname = {"e100_",regname};
    //DM_TODO: remove _100G : regname = {"e100_",regname};
    //DM_TODO: remove _200G : regname = {"e200_",regname};
    //DM_TODO: remove _400G : regname = {"e400_",regname};
    //DM_TODO: remove endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        if(fldname == "") return reg_l.get_mirrored_value();
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
          return fld_l.get_mirrored_value();
        end
      end
    end
    `uvm_fatal("register_coverage", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

function int gdr_ral_f_all_get(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
//      $display("Inside gdr_ral_f_all :%0s",regs[i].get_name());
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
//      $display("Inside gdr_ral_f_all, value of register is :%0d",regs[i].get());
        if(fldname == "") return reg_l.get();
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
//          $display("Inside gdr_ral_f_all, register field is :%0s",fld_l.get_name());
//          $display("Inside gdr_ral_f_all, value is :%0d",fld_l.get());
          return fld_l.get();
        end
      end
    end
    `uvm_fatal("register_coverage", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

//function logic_a one_m;
//  logic [31:0] bit_array[32];
//  logic [31:0] a = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx;
//  logic [31:0] b;
//  for(int i=0; i<32; i++) begin
//    b=a;
//    b[i] = 1;
//    bit_array[i] = b;
//    //bit_array[i] =  32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx | (1<i);
//   $display("bit_array[%d] = %8b",i,bit_array[i]);
//  end
//  return bit_array;
//endfunction
//
//function logic_a zero_m;
//  logic [31:0] bit_array[32];
//  logic [31:0] a = 32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx;
//  logic [31:0] b;
//  for(int i=0; i<32; i++) begin
//    b=a;
//    b[i] = 0;
//    bit_array[i] = b;
//    //bit_array[i] =  32'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx | (1<i);
//   $display("bit_array[%d] = %8b",i,bit_array[i]);
//  end
//  return bit_array;
//
//endfunction


covergroup register_cov;
  option.per_instance = 1;


  //PHY CONFIG  
   //eio_sys_rst           : coverpoint trans.data_bytes[0][0] //[FIXME] iff(`REGISTERS_PHY_CONFIG_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//   eio_sys_rst           : coverpoint trans.data_bytes[0][0] iff(`ETH_F_ALL_eth_reset_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//                        {
//                          bins eio_sys_rst_zero = {0};
//                          bins eio_sys_rst_one  = {1};
//                        }

   //soft_tx_rst           : coverpoint trans.data_bytes[0][1]//[FIXME] iff(`REGISTERS_PHY_CONFIG_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//   soft_tx_rst           : coverpoint trans.data_bytes[0][1] iff(`ETH_F_ALL_eth_reset_OFFSET_REG== address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//                        {
//                          bins soft_tx_rst_zero = {0};
//                          bins soft_tx_rst_one  = {1};
//                        }

  //soft_rxp_rst          : coverpoint trans.data_bytes[0][2]//[FIXME]  iff(`REGISTERS_PHY_CONFIG_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//  soft_rxp_rst          : coverpoint trans.data_bytes[0][2] iff(`ETH_F_ALL_eth_reset_OFFSET_REG == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
//                        {
//                          bins soft_rxp_rst_zero = {0};
//                          bins soft_rxp_rst_one  = {1};
//                        }


  
  //SCLR_FRM_ERR
//LL10G--> this is new register specific to DM
//sclr_frm_err          : coverpoint trans.data_bytes[0][0]  iff((`GET_REG_ADDR(SCLR_FRM_ERR_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ);                    
 
  //LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
  /*
  //RX PCS FULLY ALIGNED
   rx_pcs_fully_aligned  : coverpoint trans.data_bytes[0][0] iff((`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)                    
                          {
                              bins rx_pcs_fully_aligned_zero = {0};
                              bins rx_pcs_fully_aligned_one  = {1};
                             //rxpcs_status register will get updated only for NOFEC Modes 
                             ignore_bins ignr_rx_pcs_fully_aligned  = {0,1} iff(dyn_rcfg_obj_inst.speed inside {_200G,_400G} || dyn_rcfg_obj_inst.fec_type != NOFEC);
                           }
 //RX PCS Bit error rate status
   rx_pcs_bit_err_status  : coverpoint trans.data_bytes[0][1] iff((`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)                    
                          {
                              bins rx_pcs_bit_err_status_zero = {0};
                              bins rx_pcs_bit_err_status_one  = {1};
                           }	*/					   

  //MAX TX SIZE CONFIG
  max_tx_size_config    : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff ((`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
                        {
                          bins max_tx_size_config_40_4b0    = {['h40:'h4B0]};
                          bins max_tx_size_config_4b1_960   = {['h4B1:'h960]};
                          bins max_tx_size_config_961_e10   = {['h961:'hE10]};
                          bins max_tx_size_config_e11_12c0  = {['hE11:'h12C0]};
                          bins max_tx_size_config_12c1_1770 = {['h12C1:'h1770]};
                          bins max_tx_size_config_1771_1c20 = {['h1771:'h1C20]};
                          bins max_tx_size_config_1c21_20d0 = {['h1C21:'h20D0]};
                          bins max_tx_size_config_20d1_2580 = {['h20D1:'h2580]};
                        }

  //TX VLAN DETECTION
  tx_vlan_detection     : coverpoint trans.data_bytes[0][0] iff((`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)) 
                      {
                         bins tx_vlan_detection_zero = {0};
                         bins tx_vlan_detection_one  = {1};
                      }

  //RXMAC_SIZE_CONFIG
  rxmac_size_config     : coverpoint {trans.data_bytes[1],trans.data_bytes[0]} iff ((`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
                         {
                           bins rxmac_size_config_40_4b0    = {['h40:'h4B0]};
                           bins rxmac_size_config_4b1_960   = {['h4B1:'h960]};
                           bins rxmac_size_config_961_e10   = {['h961:'hE10]};
                           bins rxmac_size_config_e11_12c0  = {['hE11:'h12C0]};
                           bins rxmac_size_config_12c1_1770 = {['h12C1:'h1770]};
                           bins rxmac_size_config_1771_1c20 = {['h1771:'h1C20]};
                           bins rxmac_size_config_1c21_20d0 = {['h1C21:'h20D0]};
                           bins rxmac_size_config_20d1_2580 = {['h20D1:'h2580]};
                         }
  //MAC RX PAD CONFIG
  mac_pad_config        : coverpoint trans.data_bytes[0][0] iff((`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
                         {
                           bins mac_pad_config_0 = {0};
                           bins mac_pad_config_1 = {1};
                         }



  //MAC CRC CONFIG
  mac_crc_config        : coverpoint trans.data_bytes[0][1] iff((`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
                         {
                           bins mac_crc_config_0 = {0};
                           bins mac_crc_config_1 = {1};
                         }

  //RXMAC CONTROL
  rxmac_control_vlan    : coverpoint trans.data_bytes[0][0] iff((`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
                         {
                           bins rxmac_control_vlan_zero = {0};
                           bins rxmac_control_vlan_one  = {1};
                         } 

  rxmac_control_preambl : coverpoint trans.data_bytes[0][0] iff((`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && (trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ || trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE))
                         {
                           bins rxmac_control_preamble_zero = {0};
                           bins rxmac_control_preamble_one  = {1};
                         }


//STAT REGISTER
//TX STAT
`ifdef MAC_MODE
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_tx_stats_clr               ,(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed))		                    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_rx_stats_clr               ,(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed))		                    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_tx_stats_framesOK0         ,(`GET_REG_ADDR(tx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_tx_stats_framesOK1         ,(`GET_REG_ADDR(tx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_rx_stats_framesOK0         ,(`GET_REG_ADDR(rx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_rx_stats_framesOK1         ,(`GET_REG_ADDR(rx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_tx_stats_framesErr0        ,(`GET_REG_ADDR(tx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed))	                ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_tx_stats_framesErr1        ,(`GET_REG_ADDR(tx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed))	                ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_rx_stats_framesErr0        ,(`GET_REG_ADDR(rx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed))	                ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_rx_stats_framesErr1        ,(`GET_REG_ADDR(rx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed))	                ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_rx_fcs_lo   ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_mac_stats_cntr_rx_fcs_hi   ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_tx_stats_ifErrors0		 ,(`GET_REG_ADDR(tx_stats_ifErrors0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_tx_stats_ifErrors1	     ,(`GET_REG_ADDR(tx_stats_ifErrors1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_rx_stats_ifErrors0		 ,(`GET_REG_ADDR(rx_stats_ifErrors0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_rx_stats_ifErrors1		 ,(`GET_REG_ADDR(rx_stats_ifErrors1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(tx_utcast_data_err_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))  ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_utcast_data_err_63_31             ,(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))  ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_ucast_data_err_63_31              ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_mcast_data_err_63_32              ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_bcast_data_err_63_32              ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(mac_stats_cntr_tx_runt_lo		     ,(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(mac_stats_cntr_tx_runt_hi		     ,(`GET_REG_ADDR(mac_stats_cntr_tx_runt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	         	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(mac_stats_cntr_rx_runt_lo		     ,(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(mac_stats_cntr_rx_runt_hi		     ,(`GET_REG_ADDR(mac_stats_cntr_rx_runt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})

`STAT_REGISTER_COVERAGE(tx_mcast_data_err_31_0               ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_mcast_data_err_63_32              ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_bcast_data_err_63_32              ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_tx_octetsok_lo		,(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_mac_stats_cntr_tx_octetsok_hi		,(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_rx_octetsok_lo		,(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(REGISTERS_mac_stats_cntr_rx_octetsok_hi		,(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_oversize_63_32                    ,(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_oversize_63_32                    ,(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `STAT_REGISTER_COVERAGE_ZERO(mac_stats_cntr_rx_fragments_hi      ,(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
// PFC not present in DM`STAT_REGISTER_COVERAGE(RX_pfc_31_0		                     ,(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_jabbers_63_32                     ,(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_fcserr_63_32                      ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(tx_bcast_data_err_31_0               ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(tx_64B_31_0                         ,(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))               ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_64B_63_32                        ,(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))               ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_65to127_31_0                     ,(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_65to127_63_32                    ,(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_128to255_31_0                    ,(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_128to255_63_32                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_256to511_31_0                   ,(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_256to511_63_32                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_512to1023_31_0                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_512to1023_63_32                 ,(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_1024to1518b_31_0                ,(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_1024to1518b_63_32               ,(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_1519tomaxb_31_0                 ,(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_1519tomaxb_63_32                ,(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled 
`STAT_REGISTER_COVERAGE(tx_oversize_31_0                   ,(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(tx_mcast_data_ok_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_mcast_data_ok_63_32             ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_bcast_data_ok_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_bcast_data_ok_63_32             ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_ucast_data_ok_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_ucast_data_ok_63_32             ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_mcast_ctrl_ok_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_mcast_ctrl_ok_63_32             ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_bcast_ctrl_ok_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_bcast_ctrl_ok_63_32             ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_ucast_ctrl_ok_31_0              ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_ucast_ctrl_ok_63_32             ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(tx_pause_31_0                      ,(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))              ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_pause_63_32                     ,(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))              ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`STAT_REGISTER_COVERAGE(TX_st_31_0		                   ,(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(TX_st_63_32		                   ,(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
//PFC not present in DM`STAT_REGISTER_COVERAGE(TX_pfc_31_0		                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//PFC not present in DM`STAT_REGISTER_COVERAGE(TX_pfc_63_32		              ,(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(tx_payload_octetok_31_0           ,(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))     ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(tx_payload_octetok_63_32          ,(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))     ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})

//RX STAT

  rx_fragments_31_0        : coverpoint {trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]} iff((`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                        {
                          bins stat_zero = {0};
                          bins stat_non_zero = {['h1:'hFFFF_FFFF]};
                          ignore_bins ignr_rx_fragment_non_zero  = {['h1:'hFFFF_FFFF]} iff(dyn_rcfg_obj_inst.speed inside {_200G,_400G});
                        }
`STAT_REGISTER_COVERAGE(rx_jabbers_31_0                   ,(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))             ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_fcserr_31_0                    ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_mcast_data_err_31_0            ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_bcast_data_err_31_0            ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_ucast_data_err_31_0            ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_64B_31_0                       ,(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))                 ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_64B_63_32                      ,(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))                 ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_65to127_31_0                   ,(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_65to127_63_32                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_128to255_31_0                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_128to255_63_32                 ,(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_256to511_31_0                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_256to511_63_32                 ,(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_512to1023_31_0                 ,(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_512to1023_63_32                ,(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_1024to1518b_31_0               ,(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_1024to1518b_63_32              ,(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))         ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_1519tomaxb_31_0                ,(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_1519tomaxb_63_32               ,(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_oversize_31_0                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})   
`STAT_REGISTER_COVERAGE(rx_mcast_data_ok_31_0             ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_bcast_data_ok_31_0             ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_ucast_data_ok_31_0             ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_mcast_ctrl_ok_31_0             ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_mcast_ctrl_ok_63_32            ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_bcast_ctrl_ok_31_0             ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_bcast_ctrl_ok_63_32            ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_ucast_ctrl_ok_31_0             ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_ucast_ctrl_ok_63_32            ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))          ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_pause_31_0                     ,(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))               ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_pause_63_32                    ,(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))               ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(RX_st_31_0		                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(RX_st_63_32		                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
// PFC not present`STAT_REGISTER_COVERAGE(RX_pfc_63_32		             ,(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE(rx_payload_octetok_31_0          ,(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`STAT_REGISTER_COVERAGE_ZERO(rx_payload_octetok_63_32         ,(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))      ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`endif

tx_datapath_reset_cp      :   coverpoint gdr_ral_get("mac_reset_control","tx_datapath_reset")  
                                  {
                                bins tx_datapath_reset_0 = {0};
                                bins tx_datapath_reset_1 = {1};
                                   }
   rx_datapath_reset_cp       :   coverpoint gdr_ral_get("mac_reset_control","rx_datapath_reset")
                                    {
                                 bins rx_datapath_reset_0 = {0};
                                 bins rx_datapath_reset_1 = {1};
                                     } 


endgroup

covergroup write_reg_cov;

`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_txmac_saddrl				,(`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,dyn_rcfg_obj_inst.speed))			   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_txmac_saddrh				,(`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,dyn_rcfg_obj_inst.speed))			   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_reset_control	    ,(`GET_REG_ADDR(mac_reset_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_packet_control	    ,(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_transfer_status	    ,(`GET_REG_ADDR(tx_transfer_status_OFFSET_REG,dyn_rcfg_obj_inst.speed))			       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_pad_control     	    ,(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_crc_control	        ,(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_preamble_control      ,(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_src_addr_override	    ,(`GET_REG_ADDR(tx_src_addr_override_OFFSET_REG,dyn_rcfg_obj_inst.speed))			   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_vlan_detection	    ,(`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,dyn_rcfg_obj_inst.speed))			       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_ipg_10g               ,(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,dyn_rcfg_obj_inst.speed))			               ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_ipg_10M_100M_1G        ,(`GET_REG_ADDR(tx_ipg_10M_100M_1G_OFFSET_REG,dyn_rcfg_obj_inst.speed))			   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_underflow_counter0     ,(`GET_REG_ADDR(tx_underflow_counter0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_underflow_counter1     ,(`GET_REG_ADDR(tx_underflow_counter1_OFFSET_REG,dyn_rcfg_obj_inst.speed))	           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_pauseframe_control     ,(`GET_REG_ADDR(tx_pauseframe_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))	           ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_pause_quanta            ,(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed))	       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RXMAC_SIZE_CONFIG		  ,(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed))	   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_MAX_TX_SIZE_CONFIG	      ,(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed))	   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `WRITE_MAC_REGISTER_COVERAGE(REGISTERS_retransmit_xoff_holdoff_quanta,(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pauseframe_enable	       ,(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,dyn_rcfg_obj_inst.speed))	       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_priority_enable         ,(`GET_REG_ADDR(tx_pfc_priority_enable_OFFSET_REG,dyn_rcfg_obj_inst.speed))	       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_0			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_1			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_2			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_2_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_3			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_3_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_4			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_4_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_5			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_5_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_6			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_6_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_pause_quanta_7			,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_7_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_0			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))   ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_1			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_2			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_3			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_4			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_5			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_6			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_pfc_holdoff_quanta_7			,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_unidir_control	        ,(`GET_REG_ADDR(tx_unidir_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_transfer_control		    ,(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_transfer_status			,(`GET_REG_ADDR(rx_transfer_status_OFFSET_REG,dyn_rcfg_obj_inst.speed))	    	    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_padcrc_control			,(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_crccheck_control		    ,(`GET_REG_ADDR(rx_crccheck_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_custom_preamble_forward	,(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_preamble_control          ,(`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_control             ,(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_vlan_detection            ,(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr0_0           ,(`GET_REG_ADDR(rx_frame_spaddr0_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr0_1           ,(`GET_REG_ADDR(rx_frame_spaddr0_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr1_0           ,(`GET_REG_ADDR(rx_frame_spaddr1_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr1_1           ,(`GET_REG_ADDR(rx_frame_spaddr1_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr2_0           ,(`GET_REG_ADDR(rx_frame_spaddr2_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr2_1           ,(`GET_REG_ADDR(rx_frame_spaddr2_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr3_0           ,(`GET_REG_ADDR(rx_frame_spaddr3_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_frame_spaddr3_1           ,(`GET_REG_ADDR(rx_frame_spaddr3_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_pfc_control               ,(`GET_REG_ADDR(rx_pfc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))	 	            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_pktovrflow_error0         ,(`GET_REG_ADDR(rx_pktovrflow_error0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_pktovrflow_error1         ,(`GET_REG_ADDR(rx_pktovrflow_error1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_pktovrflow_etherStatsDropEvents0    ,(`GET_REG_ADDR(rx_pktovrflow_etherStatsDropEvents0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_pktovrflow_etherStatsDropEvents1    ,(`GET_REG_ADDR(rx_pktovrflow_etherStatsDropEvents1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_clr                 ,(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_clr                 ,(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_framesOK0           ,(`GET_REG_ADDR(tx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_framesOK1           ,(`GET_REG_ADDR(tx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_framesOK0           ,(`GET_REG_ADDR(rx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_framesOK1           ,(`GET_REG_ADDR(rx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_framesErr0          ,(`GET_REG_ADDR(tx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_framesErr1          ,(`GET_REG_ADDR(tx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_framesErr0          ,(`GET_REG_ADDR(rx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_framesErr1          ,(`GET_REG_ADDR(rx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_rx_fcs_lo     ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_rx_fcs_hi     ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_MCAST_DATA_ERR_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_MCAST_DATA_ERR_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_BCAST_DATA_ERR_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_BCAST_DATA_ERR_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(mac_stats_cntr_tx_runt_lo		        ,(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(mac_stats_cntr_tx_runt_hi		        ,(`GET_REG_ADDR(mac_stats_cntr_tx_runt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(mac_stats_cntr_rx_runt_lo		        ,(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(mac_stats_cntr_rx_runt_hi	         	,(`GET_REG_ADDR(mac_stats_cntr_rx_runt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_UCAST_DATA_ERR_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_UCAST_DATA_ERR_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_64B_31_0				    ,(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_64B_63_32				    ,(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_65to127B_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_65to127B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_128to255B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_128to255B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_256to511B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_256to511B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_512to1023B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_512to1023B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_1024to1518B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_1024to1518B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_1519toMAXB_31_0			,(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_1519toMAXB_63_32			,(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_OVERSIZE_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_OVERSIZE_63_31			,(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_MCAST_DATA_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_MCAST_DATA_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_BCAST_DATA_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_BCAST_DATA_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_UCAST_DATA_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_UCAST_DATA_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_MCAST_CTRL_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_MCAST_CTRL_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_BCAST_CTRL_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_BCAST_CTRL_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_UCAST_CTRL_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_UCAST_CTRL_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_PAUSE_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_PAUSE_63_32		       	,(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_ifErrors0			,(`GET_REG_ADDR(tx_stats_ifErrors0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_tx_stats_ifErrors1			,(`GET_REG_ADDR(tx_stats_ifErrors1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_ifErrors0			,(`GET_REG_ADDR(rx_stats_ifErrors0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_rx_stats_ifErrors1			,(`GET_REG_ADDR(rx_stats_ifErrors1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_tx_octetsok_lo,(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_tx_octetsok_hi,(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_rx_octetsok_lo,(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_mac_stats_cntr_rx_octetsok_hi,(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_st_31_0			     	,(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_st_63_32			     	,(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_pfc_31_0			     	,(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_pfc_63_32			     	,(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_Payload_OctetsOK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_TX_Payload_OctetsOK_63_32	,(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_FRAGMENTS_31_0			,(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_FRAGMENTS_63_31			,(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_JABBERS_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_JABBERS_63_31			    ,(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_FCSERR_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_FCSERR_63_32		     	,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_MCAST_DATA_ERR_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_MCAST_DATA_ERR_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_BCAST_DATA_ERR_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_BCAST_DATA_ERR_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_UCAST_DATA_ERR_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_UCAST_DATA_ERR_63_31		,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_64B_31_0				    ,(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_64B_63_32			     	,(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_65to127B_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_65to127B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_128to255B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_128to255B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_256to511B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_256to511B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_512to1023B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_512to1023B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_1024to1518B_31_0			,(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_1024to1518B_63_32			,(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_1519toMAXB_31_0			,(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_1519toMAXB_63_32			,(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_OVERSIZE_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_OVERSIZE_63_31			,(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_MCAST_DATA_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_MCAST_DATA_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_BCAST_DATA_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_BCAST_DATA_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_UCAST_DATA_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_UCAST_DATA_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_MCAST_CTRL_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_MCAST_CTRL_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_BCAST_CTRL_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_BCAST_CTRL_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_UCAST_CTRL_OK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_UCAST_CTRL_OK_63_32		,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_PAUSE_31_0			    ,(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_PAUSE_63_32		      	,(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_st_31_0			     	,(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_st_63_32			    	,(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_pfc_31_0				    ,(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_pfc_63_32				,(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_Payload_OctetsOK_31_0		,(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_Payload_OctetsOK_63_32    ,(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`ifdef ETH_MULTI_PORT 
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_usxgmii_control	            ,(`GET_REG_ADDR(usxgmii_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_usxgmii_status	            ,(`GET_REG_ADDR(usxgmii_status_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_usxgmii_an_resp_mode	        ,(`GET_REG_ADDR(usxgmii_an_resp_mode_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_usxgmii_dev_ability	        ,(`GET_REG_ADDR(usxgmii_dev_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_usxgmii_partner_ability       ,(`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_usxgmii_link_timer           ,(`GET_REG_ADDR(usxgmii_link_timer_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_phy_serial_loopback          ,(`GET_REG_ADDR(phy_serial_loopback_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_FRM_ERR                      ,(`GET_REG_ADDR(FRM_ERR_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`endif
//`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_SCLR_FRM_ERR                 ,(`GET_REG_ADDR(SCLR_FRM_ERR_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
//`WRITE_MAC_REGISTER_COVERAGE(REGISTERS_RX_PCS_FULLY_ALIGNED_S       ,(`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})

write_invalid_address: coverpoint address iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE) {
       bins invalid_ehip_pcs_stats_addr[2]  = {['h406:'h411],['h413:'h41F]} ;
       bins invalid_ehip_mac_config_addr[3] = {['h0  :'hF],['h12:'h1F],['h60:'h6F]};
       bins invalid_ehip_mac_addr_rsvd      = {['h71  :'h9F]}; 
    }

//chethan end // gaurded with MACSEG AND PCSMAC
endgroup

covergroup read_reg_cov_10g;//updated to 10g instead 25g

 `READ_RW_REGISTER_COVERAGE_10G(mac_cfg_max_tx_size_config               ,(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RW_REGISTER_COVERAGE_10G(mac_cfg_txmac_saddrl                     ,(`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
 `READ_RW_REGISTER_COVERAGE_10G(mac_cfg_txmac_saddrh                     ,(`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
`READ_RW_REGISTER_COVERAGE_10G(mac_reset_control	                     ,(`GET_REG_ADDR(mac_reset_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(tx_packet_control	                     ,(`GET_REG_ADDR(tx_packet_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_transfer_status	                     ,(`GET_REG_ADDR(tx_transfer_status_OFFSET_REG,dyn_rcfg_obj_inst.speed))			    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RW_REGISTER_COVERAGE_10G(mac_cfg_max_rx_size_config               ,(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//enabled
 `READ_RW_REGISTER_COVERAGE_10G(rx_padcrc_control                        ,(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})//mac_cfg_mac_crc_config
`READ_RW_REGISTER_COVERAGE_10G(tx_crc_control	                         ,(`GET_REG_ADDR(tx_crc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			        ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_preamble_control                       ,(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(tx_src_addr_override	                     ,(`GET_REG_ADDR(tx_src_addr_override_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(tx_vlan_detection	                     ,(`GET_REG_ADDR(tx_vlan_detection_OFFSET_REG,dyn_rcfg_obj_inst.speed))			    ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(tx_ipg_10g                                ,(`GET_REG_ADDR(tx_ipg_10g_OFFSET_REG,dyn_rcfg_obj_inst.speed))			            ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(tx_ipg_10M_100M_1G                        ,(`GET_REG_ADDR(tx_ipg_10M_100M_1G_OFFSET_REG,dyn_rcfg_obj_inst.speed))			 ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_underflow_counter0                     ,(`GET_REG_ADDR(tx_underflow_counter0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			  ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_underflow_counter1                     ,(`GET_REG_ADDR(tx_underflow_counter1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			  ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(tx_pauseframe_control                     ,(`GET_REG_ADDR(tx_pauseframe_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))	       ,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RW_REGISTER_COVERAGE_10G(mac_cfg_retransmit_xoff_holdoff_quanta   ,(`GET_REG_ADDR(mac_cfg_retransmit_xoff_holdoff_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RW_REGISTER_COVERAGE_10G(mac_cfg_tx_pause_quanta                  ,(`GET_REG_ADDR(mac_cfg_tx_pause_quanta_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RW_REGISTER_COVERAGE_10G(tx_pauseframe_enable	                 ,(`GET_REG_ADDR(tx_pauseframe_enable_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_0                ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_1               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_2               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_2_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_3               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_3_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_4               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_4_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_5               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_5_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_6               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_6_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_pause_quanta_7               ,(`GET_REG_ADDR(mac_cfg_pfc_pause_quanta_7_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_0             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_1             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_2             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_2_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_3             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_3_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_4             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_4_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_5             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_5_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_6             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_6_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_cfg_pfc_holdoff_quanta_7             ,(`GET_REG_ADDR(mac_cfg_pfc_holdoff_quanta_7_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(tx_unidir_control                        ,(`GET_REG_ADDR(tx_unidir_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_transfer_control		                 ,(`GET_REG_ADDR(rx_transfer_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//default value is 1 this cp will cover non-default value is 1:'hFFF
//`READ_RW_REGISTER_COVERAGE_10G(rx_crccheck_control		                 ,(`GET_REG_ADDR(rx_crccheck_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_custom_preamble_forward	             ,(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_preamble_control                       ,(`GET_REG_ADDR(rx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_control                          ,(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_vlan_detection                         ,(`GET_REG_ADDR(rx_vlan_detection_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr0_0                        ,(`GET_REG_ADDR(rx_frame_spaddr0_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr0_1                        ,(`GET_REG_ADDR(rx_frame_spaddr0_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr1_0                        ,(`GET_REG_ADDR(rx_frame_spaddr1_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]}) 
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr1_1                        ,(`GET_REG_ADDR(rx_frame_spaddr1_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr2_0                        ,(`GET_REG_ADDR(rx_frame_spaddr2_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr2_1                        ,(`GET_REG_ADDR(rx_frame_spaddr2_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr3_0                        ,(`GET_REG_ADDR(rx_frame_spaddr3_0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(rx_frame_spaddr3_1                        ,(`GET_REG_ADDR(rx_frame_spaddr3_1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]}) 
`READ_RO_REGISTER_COVERAGE_10G(rx_pfc_control                            ,(`GET_REG_ADDR(rx_pfc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_pktovrflow_error0                      ,(`GET_REG_ADDR(rx_pktovrflow_error0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_pktovrflow_error1                      ,(`GET_REG_ADDR(rx_pktovrflow_error1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_pktovrflow_etherStatsDropEvents0       ,(`GET_REG_ADDR(rx_pktovrflow_etherStatsDropEvents0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_pktovrflow_etherStatsDropEvents1       ,(`GET_REG_ADDR(rx_pktovrflow_etherStatsDropEvents1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
// Self-clear bit in RTL `READ_RW_REGISTER_COVERAGE_10G(tx_stats_clr                              ,(`GET_REG_ADDR(tx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
// Self-clear bit in RTL `READ_RW_REGISTER_COVERAGE_10G(rx_stats_clr                             ,(`GET_REG_ADDR(rx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_stats_framesOK0                        ,(`GET_REG_ADDR(tx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_stats_framesOK1                        ,(`GET_REG_ADDR(tx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_stats_framesOK0                        ,(`GET_REG_ADDR(rx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_stats_framesOK1                        ,(`GET_REG_ADDR(rx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_stats_framesErr0                       ,(`GET_REG_ADDR(tx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_stats_framesErr1                       ,(`GET_REG_ADDR(tx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_stats_framesErr0                       ,(`GET_REG_ADDR(rx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})   
`READ_RO_REGISTER_COVERAGE_10G(rx_stats_framesErr1                       ,(`GET_REG_ADDR(rx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_fcs_lo                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_fcs_hi                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_payloadoctetsok_lo      ,(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_payloadoctetsok_hi      ,(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_payloadoctetsok_lo      ,(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_payloadoctetsok_hi	     ,(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_octetsok_lo	         ,(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_octetsok_hi	         ,(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_octetsok_lo	          ,(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_octetsok_hi	          ,(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_st_lo				      ,(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_st_hi				      ,(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_runt_lo		          ,(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_runt_hi		          ,(`GET_REG_ADDR(mac_stats_cntr_tx_runt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_runt_lo		          ,(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_runt_hi		          ,(`GET_REG_ADDR(mac_stats_cntr_rx_runt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_64b_lo                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_64b_hi                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_65to127b_lo             ,(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_65to127b_hi             ,(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_128to255b_lo            ,(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_128to255b_hi            ,(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_256to511b_lo            ,(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_256to511b_hi            ,(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_512to1023b_lo           ,(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_512to1023b_hi           ,(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_1024to1518b_lo          ,(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_1024to1518b_hi           ,(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_1519tomaxb_lo           ,(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_1519tomaxb_hi           ,(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_oversize_lo             ,(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_oversize_hi             ,(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_mcast_data_ok_lo        ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_mcast_data_ok_hi        ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_bcast_data_ok_lo        ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_bcast_data_ok_hi        ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_ucast_data_ok_lo        ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_ucast_data_ok_hi        ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_mcast_data_err_lo       ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_mcast_data_err_hi       ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_bcast_data_err_lo       ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_bcast_data_err_hi       ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_utcast_data_err_lo      ,(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_utcast_data_err_hi      ,(`GET_REG_ADDR(mac_stats_cntr_tx_utcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_mcast_ctrl_lo           ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_mcast_ctrl_hi           ,(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_bcast_ctrl_lo           ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_bcast_ctrl_hi           ,(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_ucast_ctrl_lo           ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_ucast_ctrl_hi           ,(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_pause_lo                ,(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_pause_hi                ,(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_pause_lo                ,(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_pause_hi                ,(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_stats_ifErrors0			              ,(`GET_REG_ADDR(tx_stats_ifErrors0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(tx_stats_ifErrors1			              ,(`GET_REG_ADDR(tx_stats_ifErrors1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_stats_ifErrors0			              ,(`GET_REG_ADDR(rx_stats_ifErrors0_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(rx_stats_ifErrors1			              ,(`GET_REG_ADDR(rx_stats_ifErrors1_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_pfc_lo                  ,(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_tx_pfc_hi                   ,(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_fragments_lo           ,(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_fragments_hi           ,(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_jabbers_lo             ,(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_jabbers_hi             ,(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_fcs_err_okpkt_lo       ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_fcs_err_okpkt_hi       ,(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_mcast_data_err_lo       ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_mcast_data_err_hi       ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_bcast_data_err_lo      ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_bcast_data_err_hi      ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_ucast_data_err_lo      ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_ucast_data_err_hi      ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_64b_lo                 ,(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_64b_hi                 ,(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_65to127b_lo            ,(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_65to127b_hi             ,(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_128to255b_lo           ,(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_128to255b_hi           ,(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_256to511b_lo           ,(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_256to511b_hi           ,(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_512to1023b_lo           ,(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_512to1023b_hi          ,(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_1024to1518b_lo         ,(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_1024to1518b_hi         ,(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_1519tomaxb_lo          ,(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_1519tomaxb_hi          ,(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_oversize_lo            ,(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_oversize_hi            ,(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_mcast_data_ok_lo       ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_mcast_data_ok_hi       ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_bcast_data_ok_lo       ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_bcast_data_ok_hi       ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_ucast_data_ok_lo       ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_ucast_data_ok_hi       ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_mcast_ctrl_lo          ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_mcast_ctrl_hi          ,(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_bcast_ctrl_lo          ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_bcast_ctrl_hi          ,(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_ucast_ctrl_lo          ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_ucast_ctrl_hi           ,(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))		,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_st_lo                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_st_hi                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
 `READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_pfc_lo                 ,(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(mac_stats_cntr_rx_pfc_hi                  ,(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed))			,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`ifdef ETH_MULTI_PORT
`READ_RW_REGISTER_COVERAGE_10G(usxgmii_control	                         ,(`GET_REG_ADDR(usxgmii_control_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(usxgmii_status	                         ,(`GET_REG_ADDR(usxgmii_status_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(usxgmii_an_resp_mode	                    ,(`GET_REG_ADDR(usxgmii_an_resp_mode_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(usxgmii_dev_ability	                    ,(`GET_REG_ADDR(usxgmii_dev_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(usxgmii_partner_ability                  ,(`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(usxgmii_link_timer                      ,(`GET_REG_ADDR(usxgmii_link_timer_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RW_REGISTER_COVERAGE_10G(phy_serial_loopback                      ,(`GET_REG_ADDR(phy_serial_loopback_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`READ_RO_REGISTER_COVERAGE_10G(FRM_ERR                                  ,(`GET_REG_ADDR(FRM_ERR_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
`endif
//`READ_RW_REGISTER_COVERAGE_10G(SCLR_FRM_ERR                             ,(`GET_REG_ADDR(SCLR_FRM_ERR_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})
//LL10G -> masking RX_PCS_FULLY_ALIGNED_S_OFFSET_REG since this is not available in LL10G design
//`READ_RO_REGISTER_COVERAGE_10G(RX_PCS_FULLY_ALIGNED_S                   ,(`GET_REG_ADDR(RX_PCS_FULLY_ALIGNED_S_OFFSET_REG,dyn_rcfg_obj_inst.speed))	,address,{trans.data_bytes[3],trans.data_bytes[2],trans.data_bytes[1],trans.data_bytes[0]})

read_invalid_address: coverpoint address iff(trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ) {
       bins invalid_ehip_pcs_stats_addr_1[2] = {['h406:'h411],['h413:'h41F]};
       bins invalid_ehip_mac_config_addr_2[3] = {['h0:'hF],['h12:'h1D],['h60:'h6f]};
       bins invalid_ehip_mac_config_addr_3     = {['h71:'h9F]} ;
    }
    
endgroup

covergroup read_reg_cov_50g;
    // 50G not supported in DM
endgroup

covergroup read_reg_cov_100g;
    // 100G not supported in DM
endgroup

covergroup read_reg_cov_200g;
    // 200G not supported in DM
endgroup

covergroup read_reg_cov_400g;
    // 400G not supported in DM
endgroup

//----------------------------------------------------------------------
// Sampling based register coverage according to functionality
//----------------------------------------------------------------------
//covergroup register_cov_1;
 // option.per_instance = 1;
  //-------------------------------------------
  // REG : IPG_COL_REM 
  //-------------------------------------------
 // ipg_col_rem           : coverpoint gdr_ral_get("mac_cfg_ipg_col_rem")
 //                       {
 //                         bins ipg_col_rem_min = {'h1};
 //                         bins ipg_col_rem_rand = {['h2:'hFFFE]} with (!(item inside {`REGISTERS_ipg_col_rem_RESET_VALUE_REG}));
 //                         bins ipg_col_rem_max = {'hFFFF};
 //                       }
  //-------------------------------------------
  // REG : MAX_TX_SIZE_CONFIG 
  //-------------------------------------------
  //mac_tx_size_less_than_cp : coverpoint mac_tx_size_less_than             
  //                      {
  //                         bins mac_tx_size_less = {1};
 //                       }   
  //mac_tx_size_greater_than_cp : coverpoint mac_tx_size_greater_than             
  //                      {
  //                         bins mac_tx_size_greater = {1};
  //                      }   
 // mac_tx_size_equal_cp : coverpoint mac_tx_size_equal             
  //                      {
  //                         bins mac_tx_size_equal = {1};
  //                      }
  
  //endgroup 

//=======================================================================
covergroup tx_mac_cov_cg();
  option.per_instance = 1;
  //-------------------------------------------
  // REG : TX_MAC_CONTROL
  //-------------------------------------------
  tx_mac_control_disable_txvlan_cp        : coverpoint tx_mac_control_disable_txvlan;
  tx_mac_control_disable_txmac_cp         : coverpoint tx_mac_control_disable_txmac;
  tx_mac_control_en_saddr_insert_cp       : coverpoint tx_mac_control_en_saddr_insert;
  txmac_ehip_cfg_en_pp_cp                 : coverpoint txmac_ehip_cfg_en_pp
	                                        {
					        bins txmac_ehip_cfg_en_pp_zer0 = {0};  
						ignore_bins txmac_ehip_cfg_en_pp_one = {1};
				                }	  
//  txmac_ehip_cfg_txcrc_covers_preamble_cp : coverpoint txmac_ehip_cfg_txcrc_covers_preamble; 
  mac_tx_size_less_than_cp                : coverpoint mac_tx_size_less_than             
                                            {
                                             bins mac_tx_size_less = {1};
                                            }   
  mac_tx_size_greater_than_cp             : coverpoint mac_tx_size_greater_than             
                                            { 
                                             bins mac_tx_size_greater = {1};
                                            }   
  mac_tx_size_equal_cp                    : coverpoint mac_tx_size_equal             
                                            {
                                             bins mac_tx_size_equal = {1};
                                            }
 //-------------------------------------------
//REG: TX_packet_control
 //-------------------------------------------

  configure_tx_path_cp         :  coverpoint gdr_ral_get("tx_packet_control","configure_tx_path")
                                    {
                                   bins configure_txpath_0 = {0};  
                                   bins configure_txpath_1 = {1};
                                     }
 //-------------------------------------------
//REG : Tx_unidir_control
 //-------------------------------------------
    unidir_en_cp             :  coverpoint  gdr_ral_get("tx_unidir_control","unidir_en")
                                     {
                                   bins unidir_en_0 = {0};
                                   bins unidir_en_1 ={1};
				   ignore_bins ign_unidir_en_1 = {1};
                                     }
   remote_fault_gen_cp        : coverpoint gdr_ral_get("tx_unidir_control","remote_fault_gen")
                                     {
                                    bins remote_fault_gen_1 = {0};
			            ignore_bins ign_remote_fault_gen_1 = {1};
                                     }
   remote_fault_notify_cp      :  coverpoint gdr_ral_get("tx_unidir_control","remote_fault_notify") 
                                      {
                                     bins remote_fault_notify_0 = {0};
                                     bins remote_fault_notify_1 = {1};
				     ignore_bins ign_remote_fault_notify_1 = {1};
                                       }

 //-------------------------------------------
// REG : Tx_crc_control

    crc_insertion_cp          :   coverpoint gdr_ral_get("tx_crc_control","crc_insertion")
                                      {
                                      bins crc_insertion_0 = {1'b0};
                                      bins crc_insertion_1 = {1'b1};
                                       }

//REG : MAC_reset_control



 // tx_mac_control_use_am_insert_cp   : coverpoint tx_mac_control_use_am_insert
 //                                     {
 //			            	            ignore_bins tx_mac_control_use_am_insert = {0};
 //				                      }
  //tx_mac_control_use_ptp_cp : coverpoint tx_mac_control_use_ptp;--NA IN DM
 // tx_mac_control_srst_n_cp : coverpoint tx_mac_control_srst_n;--NA IN DM
  //tx_mac_control_lcg_en_cp : coverpoint tx_mac_control_lcg_en;--NA IN DM

endgroup



// ----------------------------------AN_Covergroup-----------------------
// ----------------------------------------------------------------------
`ifdef ETH_MULTI_PORT
covergroup an_cov_cg();
  option.per_instance = 1;
  //----------------------------------------------
  // REG : USXGMII_CONTROL
  //----------------------------------------------
  restart_an_cp                      : coverpoint trans.data_bytes[1][1]  iff((`GET_REG_ADDR(usxgmii_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE){

                                             bins restart_an_1 = {1} ;
                                             bins restart_an_0 = {0} ;              
                                          }
  usxgmii_speed_cp                   : coverpoint trans.data_bytes[0][4:2]  iff((`GET_REG_ADDR(usxgmii_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
  
                                          {
                                             bins speed_10m  = {3'b000} ;
                                             bins speed_100m = {3'b001} ; 
                                             bins speed_1g   = {3'b010};
                                             bins speed_10g  = {3'b011};
                                             bins speed_2p5g = {3'b100};
                                             bins speed_5g   = {3'b101};                
                                          }
  usxgmii_an_ena_cp                 : coverpoint trans.data_bytes[0][1]  iff((`GET_REG_ADDR(usxgmii_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                            bins an_ena_1 = {1} ;
                                            bins an_ena_0 = {0} ;  
                                          }

  usxgmii_ena_cp                    : coverpoint trans.data_bytes[0][0]  iff((`GET_REG_ADDR(usxgmii_control_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins ena_1  = {1} ;
                                             bins ena_10g_base_r  = {0} ;
					    ignore_bins ign_ena_10g_base_r = {0}; //Fixed to 1 in DM 
                                          }
  //----------------------------------------------
  // REG : USXGMII_STATUS
  //----------------------------------------------
  an_complete_cp                    : coverpoint trans.data_bytes[0][5]  iff((`GET_REG_ADDR(usxgmii_status_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins an_complete_1 = {1} ;
                                             bins an_complete_0 = {0} ;              
                                          }
  link_status_cp                    : coverpoint trans.data_bytes[0][2]  iff((`GET_REG_ADDR(usxgmii_status_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins link_status_0  = {0} ;
                                             bins link_status_1  = {1} ; 
                                          }
  //----------------------------------------------
  // REG : USXGMII_AN_RESP_MODE
  //----------------------------------------------

  duplex_an_resp_cp                    : coverpoint trans.data_bytes[0][3]  iff((`GET_REG_ADDR(usxgmii_an_resp_mode_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins duplex_resp_0  = {0} ;
                                             bins duplex_resp_1  = {1} ; 
                                          }
  speed_an_resp_cp                     : coverpoint trans.data_bytes[0][2]  iff((`GET_REG_ADDR(usxgmii_an_resp_mode_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins speed_resp_0  = {0} ;
                                             bins speed_resp_1  = {1} ; 
                                          }
  eee_cap_an_resp_cp                   : coverpoint trans.data_bytes[0][1]  iff((`GET_REG_ADDR(usxgmii_an_resp_mode_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins eee_capability_0  = {0} ;
                                             bins eee_capability_1  = {1} ; 
                                             ignore_bins ign_eee_capability_1 = {1};
                                          }
 eee_clk_stp_cap_an_resp_cp            : coverpoint trans.data_bytes[0][0]  iff((`GET_REG_ADDR(usxgmii_an_resp_mode_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins eee_clk_stp_0  = {0} ;
                                             bins eee_clk_stp_1  = {1} ;
                                             ignore_bins _ign_eee_clk_stp_1 = {1}; 
                                          }
  //----------------------------------------------
  // REG : USXGMII_DEV_ABILITY
  //----------------------------------------------
  duplex_dev_cp                    : coverpoint trans.data_bytes[1][4]  iff((`GET_REG_ADDR(usxgmii_dev_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins duplex_half_0  = {0} ;
                                             bins duplex_full_1  = {1} ; 
                                             ignore_bins ign_duplex_full_0 = {0};
                                          }
  speed_dev_cp                     : coverpoint trans.data_bytes[1][3:1]  iff((`GET_REG_ADDR(usxgmii_dev_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins speed_dev_10m  = {3'b000} ;
                                             bins speed_dev_100m = {3'b001} ; 
                                             bins speed_dev_1g   = {3'b010} ;
                                             bins speed_dev_10g  = {3'b011} ;
                                             bins speed_dev_2p5g = {3'b100} ;
                                             bins speed_dev_5g   = {3'b101} ; 
                                          }
  eee_cap_dev_cp                   : coverpoint trans.data_bytes[1][0]  iff((`GET_REG_ADDR(usxgmii_dev_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins eee_nt_sprtd  = {0} ;
                                             bins eee_sprtd   = {1} ;
                                             ignore_bins ign_eee_sprtd = {1}; 
                                          }
 eee_clk_stp_cap_dev_cp             : coverpoint trans.data_bytes[0][7]  iff((`GET_REG_ADDR(usxgmii_dev_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                             bins eee_clk_stp_nt_sprtd  = {0} ;
                                             bins eee_clk_stp_sprtd  = {1} ;
                                             ignore_bins ign_eee_clk_stp_sprtd = {1}; 
                                          }
  //----------------------------------------------
  // REG : USXGMII_PARTNER_ABILITY
  //----------------------------------------------
  link_cp                          : coverpoint trans.data_bytes[1][7]  iff((`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins link_down  = {0} ;
                                             bins link_up    = {1} ; 
                                          }
 acknowledge_cp                    : coverpoint trans.data_bytes[1][6]  iff((`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins ack_0    = {0} ;
                                             bins ack_1    = {1} ; 
                                          }
 duplex_partner_cp                 : coverpoint trans.data_bytes[1][4]  iff((`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins duplex_half_part_0  = {0} ;
                                             bins duplex_full_part_1  = {1} ; 
                                             ignore_bins ign_duplex_full_part_0 = {0};
                                          }

 speed_partner_cp                  : coverpoint trans.data_bytes[1][3:1]  iff((`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins speed_part_10m  = {3'b000} ;
				             ignore_bins ign_speed_part_10m = {3'b001,3'b010,3'b011,3'b100,3'b101} iff(dyn_rcfg_obj_inst.ll_speed inside {_10M});
                                             bins speed_part_100m = {3'b001} ; 
					     ignore_bins ign_speed_part_100m = {3'b000,3'b010,3'b011,3'b100,3'b101} iff(dyn_rcfg_obj_inst.ll_speed inside {_100M});
                                             bins speed_part_1g   = {3'b010} ;
					     ignore_bins ign_speed_part_1g = {3'b000,3'b001,3'b011,3'b100,3'b101} iff(dyn_rcfg_obj_inst.ll_speed inside {_1G});
                                             bins speed_part_10g  = {3'b011} ;
					     ignore_bins ign_speed_part_10g = {3'b000,3'b001,3'b010,3'b100,3'b101} iff (dyn_rcfg_obj_inst.ll_speed inside {_10G});
                                             bins speed_part_2p5g = {3'b100} ;
                                             ignore_bins ign_speed_part_2p5g = {3'b000,3'b001,3'b010,3'b011,3'b101} iff (dyn_rcfg_obj_inst.ll_speed inside {_2p5G});
                                             bins speed_part_5g   = {3'b101} ;
					     ignore_bins ign_speed_part_5g = {3'b000,3'b001,3'b010,3'b100,3'b011} iff (dyn_rcfg_obj_inst.ll_speed inside {_5G}); 
                                          }
 eee_cap_partner_cp                : coverpoint trans.data_bytes[1][0]  iff((`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins eee_part_nt_sprtd  = {0} ;
                                             bins eee_part_sprtd     = {1} ; 
                                             ignore_bins ign_eee_part_sprtd = {1};
                                          }
 eee_clk_stp_cap_partner_cp        : coverpoint trans.data_bytes[0][7]  iff((`GET_REG_ADDR(usxgmii_partner_ability_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
                                          {
                                             bins eee_clk_stp_part_nt_sprtd  = {0} ;
                                             bins eee_clk_stp_part_sprtd     = {1} ; 
                                             ignore_bins ign_eee_clk_stp_part_sprtd = {1}; 
                                          }

  //----------------------------------------------
  // REG : USXGMII_LINK_TIMER
  //----------------------------------------------
  usxgmii_link_timer_1_cp        : coverpoint {trans.data_bytes[2][3:0],trans.data_bytes[1][6:5]}  iff((`GET_REG_ADDR(usxgmii_link_timer_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
                                          {
                                          bins an_link_timer_1 = {['h00 : 'h1F]}; 
                                          }
  //----------------------------------------------
  // REG : PHY_SERIAL_LOOPBACK
  //----------------------------------------------
  phy_serial_loopback_cp        : coverpoint trans.data_bytes[0][0]  iff((`GET_REG_ADDR(phy_serial_loopback_OFFSET_REG,dyn_rcfg_obj_inst.speed)) == address && trans.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE){

                                             bins phy_serial_nt_en  = {0} ;
                                             bins phy_serial_en     = {1} ; 
                                          }
endgroup
`endif
//=======================================================================

//covergroup get_rx_mac_ehip_cfg_cov_cg();
 // option.per_instance = 1;
  //-------------------------------------------
  // REG : rxmac_ehip_cfg
  //-------------------------------------------
 // rxmac_ehip_cfg_en_pp_cp : coverpoint  rxmac_ehip_cfg_en_pp //Not changing pp value at run time for 40/50G
 // {
 //                         ignore_bins rxmac_ehip_cfg_en_pp_zero = {0} iff((dyn_rcfg_obj_inst.speed == _40G || dyn_rcfg_obj_inst.speed == _50G) && (dyn_rcfg_obj_inst.preamble_passthrough == 1) && (dyn_rcfg_obj_inst.mode == PCSMAC));
 //                         ignore_bins rxmac_ehip_cfg_en_pp_one  = {1} iff((dyn_rcfg_obj_inst.speed == _40G || dyn_rcfg_obj_inst.speed == _50G) && (dyn_rcfg_obj_inst.preamble_passthrough == 0) && (dyn_rcfg_obj_inst.mode == PCSMAC));
 //                       }

  //rxmac_ehip_cfg_rxcrc_covers_preamble_cp : coverpoint  rxmac_ehip_cfg_rxcrc_covers_preamble;
//endgroup

//=======================================================================

//covergroup get_tx_mac_ehip_cfg_cov_cg();
 // option.per_instance = 1;
 //-------------------------------------------
 // REG : txmac_ehip_cfg
 //-------------------------------------------
 // txmac_ehip_cfg_en_pp_cp : coverpoint txmac_ehip_cfg_en_pp //This register field is always 1 from RTL in 40/50G 
 // {
 //                     ignore_bins txmac_ehip_cfg_en_pp_zero = {0} iff((dyn_rcfg_obj_inst.speed == _40G || dyn_rcfg_obj_inst.speed == _50G));
 //                 }

 //  txmac_ehip_cfg_txcrc_covers_preamble_cp : coverpoint txmac_ehip_cfg_txcrc_covers_preamble;

//  txmac_ehip_cfg_am_period_cp : coverpoint txmac_ehip_cfg_am_period // calculated as (AM Insertion Period - AM Insertion cycles)*2
//  			      {
//			       bins txmac_ehip_cfg_am_width_400G       = {1276}   with (item &&  dyn_rcfg_obj_inst.speed == _400G);
//			       bins txmac_ehip_cfg_am_width_200G       = {1276}   with (item &&  dyn_rcfg_obj_inst.speed == _200G);
//			       bins txmac_ehip_cfg_am_width_100G_NOFEC = {630}    with (item && (dyn_rcfg_obj_inst.speed == _100G && dyn_rcfg_obj_inst.fec_type == NOFEC)) ;
//			       bins txmac_ehip_cfg_am_width_100G_FEC   = {2550}   with (item && (dyn_rcfg_obj_inst.speed == _100G && dyn_rcfg_obj_inst.fec_type !== NOFEC)) ;
//			       bins txmac_ehip_cfg_am_width_50G_NOFEC  = {1020}   with (item && (dyn_rcfg_obj_inst.speed == _50G  && dyn_rcfg_obj_inst.fec_type == NOFEC)) ;
//			       bins txmac_ehip_cfg_am_width_50G_FEC    = {1276}   with (item && (dyn_rcfg_obj_inst.speed == _50G  && dyn_rcfg_obj_inst.fec_type !== NOFEC)) ;
//			       bins txmac_ehip_cfg_am_width_40G        = {252}    with (item &&  dyn_rcfg_obj_inst.speed == _40G);
//			       bins txmac_ehip_cfg_am_width_25G        = {2552}   with (item &&  dyn_rcfg_obj_inst.speed == _25G);
//			      }
//endgroup  

//=======================================================================
covergroup rx_mac_cov_cg();
  option.per_instance = 1;
  //-------------------------------------------
  // REG : RXMAC_SIZE_CONFIG 
  //-------------------------------------------
  mac_rx_size_less_than_cp      : coverpoint mac_rx_size_less_than;             
  mac_rx_size_greater_than_cp   : coverpoint mac_rx_size_greater_than ;            
  mac_rx_size_equal_cp          : coverpoint mac_rx_size_equal;            
  //-------------------------------------------
  // REG : MAC_CRC_CONFIG
  //-------------------------------------------
  mac_crc_config_cp             : coverpoint gdr_ral_get("rx_padcrc_control","rx_pad_crc_removal")
                                {
				                   bins forward_rx_crc_0 = {1'b0}; 
				                   bins forward_rx_crc_1 = {1'b1}; 
			                 	}


  // REG: RX_FRAME_CONTROL
   
    EN_ALLUCAST_cp          : coverpoint gdr_ral_get("rx_frame_control","EN_ALLUCAST")
                               {
                                 bins en_allucast_0 = {0};
                                 bins en_allucast_1 = {1};
                                 }
    EN_ALLMCAST_cp          : coverpoint gdr_ral_get("rx_frame_control","EN_ALLMCAST")
                                {
                                bins en_allmcast_0 ={0};
                                bins en_allmcast_1= {1};
                               }
    EN_SUPP0_cp             : coverpoint gdr_ral_get("rx_frame_control","EN_SUPP0")
                                {
                                  bins en_supp0_0= {0};
                                  bins en_supp0_1 = {1};
                                }
    EN_SUPP1_cp            : coverpoint gdr_ral_get("rx_frame_control","EN_SUPP1")
                                {
                                 bins en_supp1_0 ={0};
                                 bins en_supp1_1 ={1};
                                }
    EN_SUPP2_cp            : coverpoint gdr_ral_get("rx_frame_control","EN_SUPP2")
                                {
                            
                               bins en_supp2_0= {0};
                               bins en_supp2_1 = {1};
                                 }
    EN_SUPP3_cp            : coverpoint gdr_ral_get("rx_frame_control","EN_SUPP3")
                                 {
                               bins en_supp3_0 = {0};
                               bins en_supp3_1 = {1};
                                 }
  
  
  //REG: Rx_custom_preamble_forward

       forward_preamble_cp       : coverpoint gdr_ral_get("rx_custom_preamble_forward","forward_preamble")
                                        {
                                          bins forward_preamble_0={0};
                                          bins forward_preamble_1= {1};
					  ignore_bins ign_forward_preamble_1 = {1};
					 
                                        }
   //REG : Rx_crccheck_control
    
       crc_check_en_cp            : coverpoint gdr_ral_get("rx_crccheck_control","crc_check_en")
                                        {
                                         bins crc_check_en_0 = {1'b0};
                                         bins crc_check_en_1 = {1'b1};
                                         }            

  //REG : Rx_padcrc_control
     
      rx_pad_crc_removal_cp            : coverpoint gdr_ral_get("rx_padcrc_control","rx_pad_crc_removal")
                                        {
                                           bins rx_pad_crc_removal_00 ={2'b00};
                                           bins rx_pad_crc_removal_01 ={2'b01};
                                           bins rx_pad_crc_removal_11 ={2'b11};
                                         }
         

  //REG: Rx_transfer_control

        rxpath_en_cp            :  coverpoint gdr_ral_get("rx_transfer_control","rxpath_en")
                                       {
                                          bins rxpath_en_0 = {0};
                                          bins rxpath_en_1 ={1};
					  
                                       }
  

  //-------------------------------------------
  // REG : RXMAC_CONTROL 
  //-------------------------------------------
  rx_mac_control_disable_rxvlan_cp     : coverpoint rx_mac_control_disable_rxvlan;
  rx_mac_control_remove_rx_pad_cp      : coverpoint rx_mac_control_remove_rx_pad;
// PP is not present in DM  rxmac_ehip_cfg_en_pp_cp              : coverpoint  rxmac_ehip_cfg_en_pp //Not changing pp value at run time for 40/50G
//                                         {
//                                          ignore_bins rxmac_ehip_cfg_en_pp_zero = {0} iff((dyn_rcfg_obj_inst.speed == _40G || dyn_rcfg_obj_inst.speed == _50G) && (dyn_rcfg_obj_inst.preamble_passthrough == 1) && (dyn_rcfg_obj_inst.mode == PCSMAC));
//                                          ignore_bins rxmac_ehip_cfg_en_pp_one  = {1} iff((dyn_rcfg_obj_inst.speed == _40G || dyn_rcfg_obj_inst.speed == _50G) && (dyn_rcfg_obj_inst.preamble_passthrough == 0) && (dyn_rcfg_obj_inst.mode == PCSMAC));
//                                         }

// Not present in DM  rxmac_ehip_cfg_rxcrc_covers_preamble_cp : coverpoint  rxmac_ehip_cfg_rxcrc_covers_preamble;
                                               
						
				  


endgroup   
//=======================================================================
//covergroup link_fault_cov_cg();
//  option.per_instance = 1;
//  //-------------------------------------------
//  // REG : REGISTERS_link_fault_config
//  //-------------------------------------------
//  link_fault_config : coverpoint gdr_ral_get("mac_cfg_link_fault_config") 
//                      {
//		        wildcard bins en_lf_0 = {4'b???0};
//		        wildcard bins en_lf_1 = {4'b???1};
//		        wildcard bins en_unidir_0 = {4'b??0?};
//		        wildcard bins en_unidir_1 = {4'b??1?};
//		        wildcard bins disable_rf_0 = {4'b?0??};
//		        wildcard bins disable_rf_1 = {4'b?1??};
//		        wildcard bins force_rf_0 = {4'b0???};
//		        wildcard bins force_rf_1 = {4'b1???};
//		      }
  //-------------------------------------------
  // REG : REGISTERS_link_fault_status 
  //-------------------------------------------
 // link_fault_status : coverpoint gdr_ral_get("ehip_cfg_link_fault_status") //bit_0 = local_fault , bit_1 = remote_fault
 //                     {
 //                       bins lfault  = {2'b01};
 //                       bins rfault  = {2'b10}; 
 //                     }
//endgroup
//----------------------------------------------------------------------
// Following covergroups are pause related - applicable to 40G only.
//----------------------------------------------------------------------
//`ifdef G40
bit valid_bin=1;
covergroup tx_fc_cg with function sample(bit[8:0] value);//,bit [7:0] PFC, bit [8] SFC);
  option.per_instance = 1;
//DM_TODO: reenable  //------------------------------------------------
//DM_TODO: reenable  // REG : TX_Flow_Control_Destination_Address_Lower
//DM_TODO: reenable  //------------------------------------------------
//DM_TODO: reenable
//DM_TODO: reenable//tx_fc_dest_addr_lower_cp : coverpoint gdr_ral_get("mac_cfg_tx_pfc_daddrl")
//DM_TODO: reenable//                            {
//DM_TODO: reenable//                              bins tx_fc_dest_addr_lower_other_value   = {['h0:'hFFFF_FFFF]} with (!(item inside {'hC200_0001}));
//DM_TODO: reenable//                            }
//DM_TODO: reenable//declared the coverpoint in a different way
//DM_TODO: reenable  tx_fc_dest_addr_lower_cp : coverpoint valid_bin
//DM_TODO: reenable                            {
//DM_TODO: reenable                              bins tx_fc_dest_addr_lower_other_value   = {1} iff (gdr_ral_get("mac_cfg_tx_pfc_daddrl")!= {32'hC200_0001});
//DM_TODO: reenable                            }
//DM_TODO: reenable  //------------------------------------------------
//DM_TODO: reenable  // REG : TX_Flow_Control_Destination_Address_Upper
//DM_TODO: reenable  //------------------------------------------------
//DM_TODO: reenable  tx_fc_dest_addr_upper_cp : coverpoint gdr_ral_get("mac_cfg_tx_pfc_daddrh")
//DM_TODO: reenable                            {
//DM_TODO: reenable                              bins tx_fc_dest_addr_upper_other_value   = {['h0:'hFFFF]} with (!(item inside {'h0180}));
//DM_TODO: reenable                            }
//DM_TODO: reenable  //-------------------------------------------
//DM_TODO: reenable  // REG : TX_Flow_Control_Source_Address_Lower
//DM_TODO: reenable  //-------------------------------------------
//DM_TODO: reenable
//DM_TODO: reenable//tx_fc_src_addr_lower_cp : coverpoint gdr_ral_get("mac_cfg_tx_pfc_saddrl")
//DM_TODO: reenable//                            {
//DM_TODO: reenable//                              bins tx_fc_source_addr_lower_other_value   = {['h0:'hFFFF_FFFF]} with (!(item inside {'hC200_0001}));
//DM_TODO: reenable//                            }
//DM_TODO: reenable//declared the coverpoint in a different way
//DM_TODO: reenable
//DM_TODO: reenable  tx_fc_src_addr_lower_cp : coverpoint valid_bin
//DM_TODO: reenable                            {
//DM_TODO: reenable                              bins tx_fc_source_addr_lower_other_value   = {1} iff (gdr_ral_get("mac_cfg_tx_pfc_saddrl") != {32'hC2000001});
//DM_TODO: reenable                            }
//DM_TODO: reenable  //-------------------------------------------
//DM_TODO: reenable  // REG : TX_Flow_Control_Source_Address_Upper
//DM_TODO: reenable  //-------------------------------------------
//DM_TODO: reenable  tx_fc_src_addr_upper_cp : coverpoint gdr_ral_get("mac_cfg_tx_pfc_saddrh")
//DM_TODO: reenable                            {
//DM_TODO: reenable                              bins tx_fc_source_addr_upper_other_value   = {['h0:'hFFFF]} with (!(item inside {'hE100}));
//DM_TODO: reenable                            }
//DM_TODO: reenable
//DM_TODO: reenable  //-------------------------------------------
//DM_TODO: reenable  // REG : txsfc_ehip_cfg 
//DM_TODO: reenable  //-------------------------------------------
//DM_TODO: reenable  txsfc_ehip_cfg_cp : coverpoint gdr_ral_get("mac_cfg_txsfc_ehip_cfg")
//DM_TODO: reenable   		    {
//DM_TODO: reenable		      bins txsfc_ehip_cfg_en_sfc_00 = {2'b00};
//DM_TODO: reenable		      bins txsfc_ehip_cfg_en_sfc_01 = {2'b01};
//DM_TODO: reenable		      bins txsfc_ehip_cfg_en_sfc_10 = {2'b10};
//DM_TODO: reenable		      bins txsfc_ehip_cfg_en_sfc_11 = {2'b11};
//DM_TODO: reenable		    }
//DM_TODO: reenable  
//-------------------------------------------
// REG : tx_pause_quanta 
//-------------------------------------------
  tx_pause_quanta_cp      : coverpoint gdr_ral_get("mac_cfg_tx_pause_quanta")
                            {
                             bins tx_pause_quanta_0 = {['h0:'h1000]};
                            }

//-------------------------------------------
// REG : TX_Flow_Control_Quanta_n (n= 1 to 8)
//-------------------------------------------
  tx_fc_quanta_1           : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_0")
                            {
                             bins tx_fc_quanta_1_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_2            : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_1")
                            {
                             bins tx_fc_quanta_2_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_3           : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_2")
                            {
                             bins tx_fc_quanta_3_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_4           : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_3")
                            {
                             bins tx_fc_quanta_4_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_5           : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_4")
                            {
                             bins tx_fc_quanta_5_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_6            : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_5")
                            {
                             bins tx_fc_quanta_6_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_7           : coverpoint gdr_ral_get("mac_cfg_pfc_pause_quanta_6")
                            {
                             bins tx_fc_quanta_7_0 = {['h0:'h1000]};
                            }
  tx_fc_quanta_8           : coverpoint  gdr_ral_get("mac_cfg_pfc_pause_quanta_7")
                            {
                             bins tx_fc_quanta_8_0 = {['h0:'h1000]};
                            }
  //------------------------------------------------------------------
  // REG :TX_Flow_Control_Signal_XOFF_Request_Hold_Quanta_n (n=1 to 8)
  //------------------------------------------------------------------
  tx_fc_hold_quanta_1      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_0")
                            {
                             bins tx_fc_hold_quanta_1_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_2      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_1") 
                            {
                             bins tx_fc_hold_quanta_2_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_3      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_2")
                            {
                             bins tx_fc_hold_quanta_3_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_4      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_3")
                            {
                            bins tx_fc_hold_quanta_4_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_5      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_4")
                            {
                            bins tx_fc_hold_quanta_5_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_6        : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_5")
                            {
                            bins tx_fc_hold_quanta_6_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_7      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_6")
                            {
                             bins tx_fc_hold_quanta_7_0 = {['h0:'h1000]};
                            }
  tx_fc_hold_quanta_8      : coverpoint gdr_ral_get("mac_cfg_pfc_holdoff_quanta_7")
                            {
                             bins tx_fc_hold_quanta_8_0 = {['h0:'h1000]};
                            }                             
  //-------------------------------------------
  // REG : TX_Flow_Control_Enable
  //-------------------------------------------
  //ENABLE_PFC parameter =1 is disabled for DM
  tx_flow_ctrl_en_0 : coverpoint value[0]
                      {
                        bins on_0 = {1};
                       bins off_0 = {0};
                       ignore_bins pfc_rsvd_0 = {1};
		      
                      }
  tx_flow_ctrl_en_1 : coverpoint value[1]
                      {
                        bins on_1 = {1};
                        bins off_1 = {0};
                        ignore_bins pfc_rsvd_1 = {1};
			
                      }
  tx_flow_ctrl_en_2 : coverpoint value[2]
                      {
                        bins on_2 = {1};
                        bins off_2 = {0};
		        ignore_bins pfc_rsvd_2 = {1};
                     }
  tx_flow_ctrl_en_3 : coverpoint value[3]
                      {
                        bins on_3 = {1};
                        bins off_3 = {0};
                        ignore_bins pfc_rsvd_3 = {1};  
          		}
  tx_flow_ctrl_en_4 : coverpoint value[4]
                      {
                        bins on_4 = {1};
                        bins off_4 = {0};
			ignore_bins pfc_rsvd_4 = {1};
                      }
  tx_flow_ctrl_en_5 : coverpoint value[5]
                      {
                        bins on_5 = {1};
                        bins off_5 = {0};
		        ignore_bins pfc_rsvd_5 = {1};
	        	}
  flow_ctrl_en_6   :  coverpoint value[6]
                      {
                       bins on_6 = {1};
                       bins off_6 = {0};
		       ignore_bins pfc_rsvd_6 = {1};
                      }
  tx_flow_ctrl_en_7 : coverpoint value[7]
                      {
                        bins on_7 = {1};
                        bins off_7 = {0};
		        ignore_bins pfc_rsvd_7 = {1};
                      }
  tx_flow_ctrl_en_8 : coverpoint value[8]
                      {
                       bins on_8 = {1};
                       bins off_8 = {0};
		       ignore_bins pfc_rsvd_8 = {1};
                      }


//REG : Tx_pauseframe_Enable

  pause_frame_enable_cp : coverpoint gdr_ral_get("tx_pauseframe_enable","pause_frame_enable")
                        {
                          bins pause_frame_enable_0 ={1};
                          bins pause_frame_enable_1 ={0};
                       }

//REG : Tx_pauseframe_control                          
  pause_frame_config_cp : coverpoint gdr_ral_get("tx_pauseframe_control","pause_frame_config")

                         {
                           bins pause_frame_config_00 = {2'b00};
                           bins pause_frame_config_01 = {2'b01};
                           bins pause_frame_config_10 = {2'b10};
                           }

endgroup
//=======================================================================
covergroup tx_fc_csr_xon_xoff_1_bit_cg with function sample(bit[31:0] value);
  option.per_instance = 1;
  //-------------------------------------------
  // REG : TX_Flow_Control_CSR_XON_XOFF
  //-------------------------------------------
  tx_fc_csr_xon_xoff_cp : coverpoint value[1:0]
                                  {
                                    bins no_req         = {2'b00};
                                    bins xon_req        = {2'b01};
                                    bins xoff_req       = {2'b10};
                                    bins trans_xoff_req = (2'b00=>2'b10);
                                    bins trans_xon_req  = (2'b10=>2'b01);
				    
                                  }
endgroup
//=======================================================================
covergroup rx_fc_cg with function sample(bit[7:0] rx_pfc_en);
  option.per_instance = 1;
  //-------------------------------------------
  // REG : RX_PFC_Enable
  //-------------------------------------------
  //ENABLE_PFC parameter is 0 for DM 
  rx_pfc_enable_0       : coverpoint rx_pfc_en[0]
                        {
                          bins rx_pfc_enable_0_value_0 = {0};
                          bins rx_pfc_enable_0_value_1 = {1};
                          ignore_bins rx_pfc_enable_0 = {0};
			  

                        }
  rx_pfc_enable_1       : coverpoint rx_pfc_en[1]
                        {
                          bins rx_pfc_enable_1_value_0 = {0};
                          bins rx_pfc_enable_1_value_1 = {1};
			  ignore_bins rx_pfc_enable_1 = {0};

                        }
  rx_pfc_enable_2       : coverpoint rx_pfc_en[2]
                        {
                          bins rx_pfc_enable_2_value_0 = {0};
                          bins rx_pfc_enable_2_value_1 = {1};
			  ignore_bins rx_pfc_enable_2 = {0};

                        }
  rx_pfc_enable_3       : coverpoint rx_pfc_en[3]
                        {
                          bins rx_pfc_enable_3_value_0 = {0};
                          bins rx_pfc_enable_3_value_1 = {1};
			  ignore_bins rx_pfc_enable_3 = {0};

                        }
  rx_pfc_enable_4       : coverpoint rx_pfc_en[4]
                        {
                          bins rx_pfc_enable_4_value_0 = {0};
                          bins rx_pfc_enable_4_value_1 = {1};
			  ignore_bins rx_pfc_enable_4 = {0};

                        }
  rx_pfc_enable_5       : coverpoint rx_pfc_en[5]
                        {
                          bins rx_pfc_enable_5_value_0 = {0};
                          bins rx_pfc_enable_5_value_1 = {1};
			  ignore_bins rx_pfc_enable_5 = {0};

                        }
  rx_pfc_enable_6       : coverpoint rx_pfc_en[6]
                        {
                          bins rx_pfc_enable_6_value_0 = {0};
                          bins rx_pfc_enable_6_value_1 = {1};
			  ignore_bins rx_pfc_enable_6 = {0};

                        }
  rx_pfc_enable_7       : coverpoint rx_pfc_en[7]
                        {
                          bins rx_pfc_enable_7_value_0 = {0};
                          bins rx_pfc_enable_7_value_1 = {1};
			  ignore_bins rx_pfc_enable_7 = {0};

                        }

//REG : RX_FRAME_CONTROL

         FWD_CONTROL_cp   : coverpoint gdr_ral_get("rx_frame_control","FWD_CONTROL")

                             {
                                bins fwd_control_0 ={0};
                                bins fwd_control_1 ={1};
                             }
         FWD_PAUSE_cp     : coverpoint gdr_ral_get("rx_frame_control","FWD_PAUSE")
                             {
                               //PAUSE frames are dropped at MAC , sampling will not happedn
                               //bins fwd_pause_0 ={0};
                               bins fwd_pause_1 ={1};
                             }           
      IGNORE_PAUSE_cp     : coverpoint gdr_ral_get("rx_frame_control","IGNORE_PAUSE")
                            {
                             bins ignore_pause_0 ={0};
                             bins ignore_pause_1={1};
                             }



  //--------------------------------------------------
  // REG :  rxsfc_ehip_cfg
  //--------------------------------------------------
//DM_TODO: reenable   rxsfc_ehip_cfg_cp : coverpoint gdr_ral_get("mac_cfg_rxsfc_ehip_cfg")
//DM_TODO: reenable   		    {
//DM_TODO: reenable 		      wildcard bins rxsfc_ehip_cfg_0 = {2'b?0};
//DM_TODO: reenable 		      wildcard bins rxsfc_ehip_cfg_1 = {2'b?1};
//DM_TODO: reenable 		      // Coverage for bit 1(en_pfc) is not covered as it is depricated. FB : 545712
//DM_TODO: reenable 		    }
//DM_TODO: reenable  
   //--------------------------------------------------
   // REG : RX_Flow_Control_Destination_Address_Lower 
  //--------------------------------------------------
  //
//DM_TODO: reenable   //rx_fc_dest_addr_lower : coverpoint gdr_ral_get("mac_cfg_rx_pause_daddrl")
//DM_TODO: reenable //                            {
//DM_TODO: reenable //                              bins rx_fc_dest_addr_lower_other_value   = {['h0:'hFFFF_FFFF]} with (!(item inside {'hC200_0001}));
//DM_TODO: reenable //                            }
//DM_TODO: reenable //declared the coverpoint in a different way
//DM_TODO: reenable   rx_fc_dest_addr_lower : coverpoint valid_bin
//DM_TODO: reenable                         {
//DM_TODO: reenable                           bins rx_fc_dest_addr_lower_other_value   = {1} iff (gdr_ral_get("mac_cfg_rx_pause_daddrl") != {32'hC200_0001});
//DM_TODO: reenable                         }
//DM_TODO: reenable   //--------------------------------------------------
//DM_TODO: reenable   // REG : RX_Flow_Control_Destination_Address_Upper
//DM_TODO: reenable   //--------------------------------------------------
//DM_TODO: reenable   rx_fc_dest_addr_upper : coverpoint gdr_ral_get("mac_cfg_rx_pause_daddrh")
//DM_TODO: reenable                         {
//DM_TODO: reenable                           bins rx_fc_dest_addr_upper_other_value   = {['h0:'hFFFF]} with (!(item inside {'h0180}));
//DM_TODO: reenable                         }  
endgroup 

covergroup rx_fc_fwd0_cg ();
  option.per_instance = 1;

  //--------------------------------------------------
  // REG : rx_pause_fwd 
  //--------------------------------------------------
   rx_pause_fwd_cp : coverpoint gdr_ral_get("rx_frame_control","FWD_PAUSE")
   		             {
 		              bins rx_pause_fwd_0 = {0};
		              bins rx_pause_fwd_1 = {1}; 
 		              }
endgroup

`ifdef ETH_MULTI_PORT
covergroup dynamic_speed_cg;
    option.per_instance = 1;
   cover_point_10G_trans : coverpoint gdr_ral_get("usxgmii_control","USXGMII_SPEED") {
	bins tran_10g_to_5g = (3'b011=>3'b101 );
	bins tran_10g_to_2p5g = (3'b011=>3'b100 );
        bins trans_10g_to_1g = (3'b011=>3'b010 );
        bins trans_10g_to_100m = (3'b011=>3'b001);
        bins trans_10g_to_10m = (3'b011=>3'b000 );
    }
    cover_point_1G_trans : coverpoint gdr_ral_get("usxgmii_control","USXGMII_SPEED") {
        bins tran_1g_to_5g = ( 3'b010=>3'b101 );
        bins tran_1g_to_2p5g = (3'b010=>3'b100 );
        bins trans_1g_to_10g = ( 3'b010=>3'b011 );
        bins trans_1g_to_100m = (3'b010=>3'b001);
        bins trans_1g_to_10m = ( 3'b010=>3'b000 );
    }
    cover_point_5G_trans : coverpoint gdr_ral_get("usxgmii_control","USXGMII_SPEED") {
        bins tran_5g_to_10g = (3'b101=>3'b011 );
        bins tran_5g_to_2p5g = (3'b101=>3'b100);
        bins trans_5g_to_1g = (3'b101=>3'b010 );
        bins trans_5g_to_100m = (3'b101=>3'b001);
        bins trans_5g_to_10m = ( 3'b101=>3'b000 );
    } 
    cover_point_2p5G_trans : coverpoint gdr_ral_get("usxgmii_control","USXGMII_SPEED") {
        bins tran_2p5g_to_10g = (3'b100=>3'b011 );
        bins tran_2p5g_to_5g = ( 3'b100=>3'b101 );
        bins trans_2p5g_to_1g = (3'b100=>3'b010 );
        bins trans_2p5g_to_100m = (3'b100 =>3'b001);
        bins trans_2p5g_to_10m = ( 3'b100=>3'b000 );
    }
    cover_point_100M_trans : coverpoint gdr_ral_get("usxgmii_control","USXGMII_SPEED") {
        bins tran_100m_to_10g = (3'b001=>3'b011 );
        bins tran_100m_to_5g = (3'b001=>3'b101 );
        bins trans_100m_to_1g = ( 3'b001=>3'b010 );
        bins trans_100m_to_2p5g = (3'b001=>3'b100);
        bins trans_100m_to_10m = ( 3'b001=>3'b000 );
    }
    cover_point_10M_trans : coverpoint gdr_ral_get("usxgmii_control","USXGMII_SPEED") {
        bins tran_10m_to_10g = ( 3'b000=>3'b011 );
        bins tran_10m_to_5g = ( 3'b000=>3'b101 );
        bins trans_10m_to_1g = ( 3'b000=>3'b010 );
        bins trans_10m_to_2p5g = ( 3'b000=>3'b100);
        bins trans_10m_to_100m = ( 3'b000=>3'b001 );
    }

endgroup
`endif
//`endif
//----------------------------------------------------------------------
// function to get eth frame from TB driver (dut_tx)
//----------------------------------------------------------------------
virtual function void write_eth_frame_from_driver(eth_packet tr);
  $cast(eth_trans,tr.clone());
  `uvm_info(get_name(),$sformatf("driver_frame := %s",eth_trans.sprint()),UVM_HIGH)
  frame_xfer_active = 1;
  fork
    begin
      //get_mac_tx_size_data(tr);
      get_tx_mac_control_data(tr);
      get_tx_mac_ehip_cfg_data(tr);
    //  if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) // not required for PCSONLY/FLEXE/OTN
         //register_cov_1.sample();
    end
  join_none  
endfunction : write_eth_frame_from_driver   
//----------------------------------------------------------------------
// function to get eth frame from VIP (dut_rx)
//----------------------------------------------------------------------
virtual function void write_eth_frame_from_vip(eth_packet tr);
  $cast(eth_trans,tr.clone());
  `uvm_info(get_name(),$sformatf("rx_vip_frame := %s",eth_trans.sprint()),UVM_HIGH)
  frame_xfer_active = 1;
 rxmac_ehip_cfg_en_pp = gdr_ral_get("rx_preamble_control","en_pp"); 

  fork
    begin
      get_mac_rx_size_data(tr);
      get_rx_mac_ehip_cfg_data(tr);
      get_rx_mac_control_data(tr);
      if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC )
        rx_mac_cov_cg.sample();
      rx_fc_fwd0_cg.sample();
    end
  join_none  
endfunction : write_eth_frame_from_vip 
//----------------------------------------------------------------------------------
// function to get pause frame in dut_tx direction either from pkt or from interface
//----------------------------------------------------------------------------------
virtual function void write_pause_tx_pkt(eth_packet tr);
//`ifdef G40
  bit [8:0] tx_flow_control_en;
  bit [7:0] tx_2_bit_fc_req_mode;
  bit [31:0] tx_fc_csr_xon_xoff_req_0;
  bit [7:0] tx_fc_csr_xon_xoff_req_1;
  $cast(eth_trans,tr.clone());
  frame_type = tr.frame_type;
  if ((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME)) begin
      tx_flow_control_en = gdr_ral_get("tx_pfc_priority_enable","tx_pfc_enable");
    //tx_2_bit_fc_req_mode = gdr_ral_get("TX_2_bit_Flow_Control_Request_Mode","TX_2_bit_Flow_Control_Request_Mode");
     tx_fc_csr_xon_xoff_req_0 = gdr_ral_get("tx_pauseframe_control");
    //tx_fc_csr_xon_xoff_req_1 = gdr_ral_get("TX_Flow_Control_CSR_XON_XOFF","Request_1");
    `uvm_info(get_name(),$sformatf("tx_pause_pkt := %s",eth_trans.sprint()),UVM_HIGH)
    if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) begin // not required for PCSONLY/FLEXE/OTN
      tx_fc_cg.sample(tx_flow_control_en);
      tx_fc_csr_xon_xoff_1_bit_cg.sample(tx_fc_csr_xon_xoff_req_0);
    end
  end
//`endif
endfunction : write_pause_tx_pkt
//----------------------------------------------------------------------
// function to get pause pkt from VIP (dut_rx)
//----------------------------------------------------------------------
virtual function void write_pause_rx_pkt(eth_packet tr);
//`ifdef G40
  bit [7:0] rx_pfc_en;
  $cast(eth_trans,tr.clone());
  frame_type = tr.frame_type;
  if ((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME)) begin
    rx_pfc_en = gdr_ral_get("rx_pfc_control");
    `uvm_info(get_name(),$sformatf("rx_pause_pkt := %s",eth_trans.sprint()),UVM_HIGH)
    if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) // not required for PCSONLY/FLEXE/OTN
      rx_fc_cg.sample(rx_pfc_en);
  end
//`endif
endfunction : write_pause_rx_pkt

//----------------------------------------------------------------------
// get preamble,sfd and vlan from the reigster based on speed
//----------------------------------------------------------------------
task get_rx_mac_control_data(eth_packet tr);
   rx_mac_control_disable_rxvlan = gdr_ral_get("rx_vlan_detection","rx_vlan_detection_disable");
   rx_mac_control_remove_rx_pad = gdr_ral_get("rx_padcrc_control","rx_pad_crc_removal");
endtask : get_rx_mac_control_data

//----------------------------------------------------------------------
// get mac enable,saddr_insert and vlan from the reigster based on speed
//----------------------------------------------------------------------
task get_tx_mac_control_data(eth_packet tr);
  $cast(eth_trans,tr.clone());
  `uvm_info(get_name(),$sformatf("driver_frame := %s",eth_trans.sprint()),UVM_HIGH)
   frame_xfer_active = 1;
   tx_mac_control_disable_txvlan = gdr_ral_get("tx_vlan_detection","tx_vlan_detection_disable");
   tx_mac_control_disable_txmac = gdr_ral_get("tx_packet_control","configure_tx_path");
   tx_mac_control_en_saddr_insert = gdr_ral_get("tx_src_addr_override","src_addr_override");
   txmac_ehip_cfg_en_pp = gdr_ral_get("tx_preamble_control","preamble_passthorugh"); 
   get_mac_tx_size_data(tr);
   if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC )  //not required for PCSONLY/FLEXE/OTN
    tx_mac_cov_cg.sample();
endtask : get_tx_mac_control_data

//----------------------------------------------------------------------
// get mac enable,saddr_insert and vlan from the reigster based on speed
//----------------------------------------------------------------------
task get_tx_mac_ehip_cfg_data(eth_packet tr);
  // txmac_ehip_cfg_en_pp = gdr_ral_get("tx_preamble_control","preamble_passthorugh"); 
  //DM_TODO: txmac_ehip_cfg_ipg = gdr_ral_get("mac_cfg_txmac_ehip_cfg","ipg");
  //DM_TODO: txmac_ehip_cfg_am_width =  gdr_ral_get("mac_cfg_txmac_ehip_cfg","am_width");
  //DM_TODO: txmac_ehip_cfg_flowreg_rate = gdr_ral_get("mac_cfg_txmac_ehip_cfg","flowreg_rate");
  //DM_TODO: txmac_ehip_cfg_txcrc_covers_preamble = gdr_ral_get("mac_cfg_txmac_ehip_cfg","txcrc_covers_preamble");
  //DM_TODO: txmac_ehip_cfg_am_period = gdr_ral_get("mac_cfg_txmac_ehip_cfg","am_period");
//  if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) //not required for PCSONLY/FLEXE/OTN
  //  get_tx_mac_ehip_cfg_cov_cg.sample();
endtask : get_tx_mac_ehip_cfg_data

//----------------------------------------------------------------------
// get mac enable,saddr_insert and vlan from the reigster based on speed
//----------------------------------------------------------------------
task get_rx_mac_ehip_cfg_data(eth_packet tr);
   //rxmac_ehip_cfg_en_pp = gdr_ral_get("rx_preamble_control","en_pp"); 
  //DM_TODO: rxmac_ehip_cfg_rxcrc_covers_preamble = gdr_ral_get("mac_cfg_rxmac_ehip_cfg","rxcrc_covers_preamble");
  //if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) // not required for PCSONLY/FLEXE/OTN
   //get_rx_mac_ehip_cfg_cov_cg.sample();
endtask : get_rx_mac_ehip_cfg_data

//------------------------------------------------------------------------------
// get incoming tx frame size and set variables of min,max and equal accordingly
//------------------------------------------------------------------------------
task get_mac_tx_size_data(eth_packet tr);
  int tx_frame_size;
  if(tr.frame_type==ETH_VLAN_FRAME || tr.frame_type==ETH_JUMBO_VLAN_FRAME) begin
    tx_frame_size = tr.payload.size() + 22;   
  end
  else if (tr.frame_type==ETH_STACKED_VLAN_FRAME || tr.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
    tx_frame_size = tr.payload.size() + 26; 
  end
  else begin
    tx_frame_size = tr.payload.size() + 18;
  end
  `uvm_info(get_name(),$sformatf("tx_frame_size := %0d -bytes",tx_frame_size),UVM_HIGH)
  if (tx_frame_size == gdr_ral_get("mac_cfg_max_tx_size_config"))
    mac_tx_size_equal = 1;
  else if (tx_frame_size >  gdr_ral_get("mac_cfg_max_tx_size_config"))
    mac_tx_size_greater_than = 1;
  else if (tx_frame_size <  gdr_ral_get("mac_cfg_max_tx_size_config"))
    mac_tx_size_less_than = 1;
endtask : get_mac_tx_size_data
//------------------------------------------------------------------------------
// get incoming rx frame size and set variables of min,max and equal accordingly
//------------------------------------------------------------------------------
task get_mac_rx_size_data(eth_packet tr);
  int rx_frame_size;
  if(tr.frame_type==ETH_VLAN_FRAME || tr.frame_type==ETH_JUMBO_VLAN_FRAME) begin
    rx_frame_size = tr.payload.size() + 22;   
  end
  else if (tr.frame_type==ETH_STACKED_VLAN_FRAME || tr.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
    rx_frame_size = tr.payload.size() + 26; 
  end
  else begin
    rx_frame_size = tr.payload.size() + 18;
  end
  `uvm_info(get_name(),$sformatf("rx_frame_size := %0d -bytes",rx_frame_size),UVM_HIGH)
  if (rx_frame_size == gdr_ral_get("mac_cfg_max_rx_size_config"))
    mac_rx_size_equal = 1;
  else if (rx_frame_size >  gdr_ral_get("mac_cfg_max_rx_size_config"))
    mac_rx_size_greater_than = 1;
  else if (rx_frame_size <  gdr_ral_get("mac_cfg_max_rx_size_config"))
    mac_rx_size_less_than = 1;
endtask : get_mac_rx_size_data
//----------------------------------------------------------------------
//Function: write
//This function gets avalon uvc transaction 
//----------------------------------------------------------------------
virtual function void write_avmm_bus(altuvm_avalon_mm_req_base tr);
   `uvm_info("register_coverage", $sformatf("avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   $cast(trans,tr.clone());
   `uvm_info("register_coverage", $sformatf("avmm transaction \n %0s",trans.sprint()), UVM_HIGH);
   address = trans.address;
   `uvm_info("register_coverage", $sformatf("avmm transaction address %0h, addr[17:2] = %0h",address, address[17:2]), UVM_MEDIUM);
   address = trans.address >> 2'b10;
   `uvm_info("register_coverage", $sformatf("avmm transaction address after shifting %0h",address), UVM_HIGH);   
   `uvm_info("register_coverage", $sformatf("register speed %0s",dyn_rcfg_obj_inst.speed), UVM_HIGH);
   
   if(dis_reg_cov==0) begin
     register_cov.sample();
     `ifdef ETH_MULTI_PORT
     an_cov_cg.sample(); 
     dynamic_speed_cg.sample();  
     `endif
   end
//   else begin
   
   case(dyn_rcfg_obj_inst.speed)
    _10G: read_reg_cov_10g.sample();//updated 25 to 10g
    _50G: read_reg_cov_50g.sample();
    _100G: read_reg_cov_100g.sample();
    _200G: read_reg_cov_200g.sample();
    _400G: read_reg_cov_400g.sample();
     endcase
     write_reg_cov.sample();
     
     //link_fault_cov_cg.sample();
//   end
endfunction : write_avmm_bus

//==============================================================================
// Function: new
//============================================================================== 
function new(string name, uvm_component parent);
   super.new(name,parent);
   avmm_bus = new("avmm_bus", this);
   eth_frame_from_driver = new("eth_frame_from_driver", this);
   eth_frame_from_vip = new("eth_frame_from_vip", this);
   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
//`ifdef G40
     pause_tx_pkt= new("pause_tx_pkt", this);
     pause_rx_pkt= new("pause_rx_pkt", this);
     if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) begin // not required for PCSONLY/FLEXE/OTN
       tx_fc_cg = new();
       rx_fc_cg = new();
       tx_fc_csr_xon_xoff_1_bit_cg = new();
     end
   //`endif
   register_cov = new();
   write_reg_cov = new();
   `ifdef ETH_MULTI_PORT
   an_cov_cg = new();
   dynamic_speed_cg = new();
   `endif
   //`ifdef G25
   if(dyn_rcfg_obj_inst.speed == _10G)//converted 25 to 10g
   read_reg_cov_10g = new();
  // `endif
  // `ifdef G50
   if(dyn_rcfg_obj_inst.speed == _50G)
   read_reg_cov_50g = new();
  // `endif
  // `ifdef G100
   if(dyn_rcfg_obj_inst.speed == _100G)
   read_reg_cov_100g = new();
   //`endif
  // `ifdef G200
   if(dyn_rcfg_obj_inst.speed == _200G)
   read_reg_cov_200g = new();
   //`endif
  // `ifdef G400
   if(dyn_rcfg_obj_inst.speed == _400G)
   read_reg_cov_400g = new();
   //`endif
   if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC ) begin //not required for PCSONLY/FLEXE/OTN
     //register_cov_1 = new();
     tx_mac_cov_cg = new();
     //get_tx_mac_ehip_cfg_cov_cg = new();
     //get_rx_mac_ehip_cfg_cov_cg = new();
     rx_mac_cov_cg = new();
   end 
   rx_fc_fwd0_cg = new();
//   link_fault_cov_cg = new();
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

//task print_reg_data_for_debug();
// `PRINT_REG_COV(IPG_COL_REM)
// `PRINT_REG_COV(MAX_TX_SIZE_CONFIG)
// `PRINT_REG_COV(TX_MAC_CONTROL)
// `PRINT_REG_COV(RXMAC_SIZE_CONFIG)
// `PRINT_REG_COV(MAC_CRC_CONFIG)
// `PRINT_REG_COV(RXMAC_CONTROL)
//endtask 

task run_phase(uvm_phase phase);
   super.run_phase(phase);

   fork
   `ifdef G40
      begin
      forever begin
         @(posedge spy_if.clk);
         if ( // remote_fault_detect
	      (spy_if.pcs_ready && 
	       ((spy_if.mii_data_rx[127:64] == 64'h9c00_0002_0000_0000 && spy_if.mii_ctrl_rx[15:8] == 8'h80) || (spy_if.mii_data_rx[63:0] == 64'h9c00_0002_0000_0000 &&  spy_if.mii_ctrl_rx[7:0] == 8'h80)) && 
	       spy_if.mii_valid_rx == 1'b1) ||
	      // local_fault_detect
	      (spy_if.pcs_ready && 
	       ((spy_if.mii_data_rx[127:64] == 64'h9c00_0001_0000_0000 && spy_if.mii_ctrl_rx[15:8] == 8'h80) || (spy_if.mii_data_rx[63:0] == 64'h9c00_0001_0000_0000 &&  spy_if.mii_ctrl_rx[7:0] == 8'h80)) && 
	       spy_if.mii_valid_rx == 1'b1)
	      ) begin
            //link_fault_cov_cg.sample();
         end  
      end // forever begin
      end
   `else 
      begin 
      forever begin
         @(posedge spy_if.clk);
         if ( // remote_fault_detect
	      (spy_if.pcs_ready && 
	       ((spy_if.mii_data_rx[255:192] == 64'h9c00_0002_0000_0000 && spy_if.mii_ctrl_rx[31:24] == 8'h80) || (spy_if.mii_data_rx[191:128] == 64'h9c00_0002_0000_0000 &&  spy_if.mii_ctrl_rx[23:16] == 8'h80) || (spy_if.mii_data_rx[127:64] == 64'h9c00_0002_0000_0000 && spy_if.mii_ctrl_rx[15:8] == 8'h80) || (spy_if.mii_data_rx[63:0] == 64'h9c00_0002_0000_0000 &&  spy_if.mii_ctrl_rx[7:0] == 8'h80)) && 
	       spy_if.mii_valid_rx == 1'b1) ||
	      // local_fault_detect
	      (spy_if.pcs_ready && 
	       ((spy_if.mii_data_rx[255:192] == 64'h9c00_0001_0000_0000 && spy_if.mii_ctrl_rx[31:24] == 8'h80) || (spy_if.mii_data_rx[191:128] == 64'h9c00_0001_0000_0000 &&  spy_if.mii_ctrl_rx[23:16] == 8'h80) || (spy_if.mii_data_rx[127:64] == 64'h9c00_0001_0000_0000 && spy_if.mii_ctrl_rx[15:8] == 8'h80) || (spy_if.mii_data_rx[63:0] == 64'h9c00_0001_0000_0000 &&  spy_if.mii_ctrl_rx[7:0] == 8'h80)) && 
	       spy_if.mii_valid_rx == 1'b1)
	      ) begin
            //link_fault_cov_cg.sample();
         end  
      end // forever begin
      end
   `endif
   join
   
endtask : run_phase  

endclass: register_coverage

`endif // REGISTER_COVERAGE__SV

