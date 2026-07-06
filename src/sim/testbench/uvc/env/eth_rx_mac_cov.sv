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

`ifndef ETH_RX_MAC_COV__SV
`define ETH_RX_MAC_COV__SV

typedef enum {TYPE_S_0,TYPE_S_1,TYPE_S_2,TYPE_S_3,TYPE_D_0,TYPE_D_1,TYPE_D_2,TYPE_D_3,TYPE_C_0,TYPE_C_1,TYPE_C_2,TYPE_C_3,TYPE_T_0,TYPE_T_1,TYPE_T_2,TYPE_T_3,TYPE_E_0,TYPE_E_1,TYPE_E_2,TYPE_E_3} data_type_enum;

`define SYNC_HEADER_COV\
  bins valid_01 = {2'b01};\
  bins valid_10 = {2'b10};\
  bins invalid_11 = {2'b11};\
  bins invalid_00 = {2'b00};

`define BTF_COV\
  bins BTF_1E = {8'h1E};\
  bins BTF_78 = {8'h78};\
  bins BTF_4B = {8'h4B};\
  bins BTF_87 = {8'h87};\
  bins BTF_99 = {8'h99};\
  bins BTF_AA = {8'hAA};\
  bins BTF_B4 = {8'hB4};\
  bins BTF_CC = {8'hCC};\
  bins BTF_D2 = {8'hD2};\
  bins BTF_E1 = {8'hE1};\
  bins BTF_FF = {8'hFF};\
  bins invalid_BTF = default;

`define R_TYPE_COV\
  bins c_type_bin_1 = {64'h1E00_0000_0000_0000};\
  bins c_type_bin_2 = {64'h4B??_????_????_????};\
  bins s_type_bin = {64'h78??_????_????_????} ;\
  bins t_type_bin_1 = {64'h87??_????_????_????};\
  bins t_type_bin_2 = {64'h99??_????_????_????};\
  bins t_type_bin_3 = {64'hAA??_????_????_????};\
  bins t_type_bin_4 = {64'hB4??_????_????_????};\
  bins t_type_bin_5 = {64'hCC??_????_????_????};\
  bins t_type_bin_6 = {64'hD2??_????_????_????};\
  bins t_type_bin_7 = {64'hE1??_????_????_????};\
  bins t_type_bin_8 = {64'hFF??_????_????_????};\
  bins e_type_bin = default;

`define DATA_TYPE(lane)\
  if(trans.pcs66_d``lane[1:0]==1) begin\
    if(trans.pcs66_d``lane[9:2]==8'h78) begin\
      data_type[``lane] = TYPE_S_``lane;\
    end\
    else if (trans.pcs66_d``lane[9:2] inside {8'h87,8'h99,8'hAA,8'hB4,8'hCC,8'hD2,8'hE1,8'hFF}) begin\
      data_type[``lane] = TYPE_T_``lane;\
    end\
    else if ((trans.pcs66_d``lane[9:2] == 8'h1E && trans.pcs66_d``lane[65:10]==55'h0) || trans.pcs66_d``lane[9:2]==8'h4B) begin\
      data_type[``lane] = TYPE_C_``lane;\
    end\
    else begin\
      data_type[``lane] = TYPE_E_``lane;\
    end\
  end\
  else if(trans.pcs66_d``lane[1:0]==2) begin\
    data_type[``lane] = TYPE_D_``lane;\
  end\
  else if (trans.pcs66_d``lane[1:0] == 0 || trans.pcs66_d``lane[1:0] == 3) begin\
    data_type[``lane] = TYPE_E_``lane;\
  end

`uvm_analysis_imp_decl(_vip_tx_pkt_size)

class eth_rx_mac_cov extends uvm_component;

  // eth_param_tb tb_cfg; 
   registers_urm reg_model;
   uvm_reg_data_t tx_preamble_ctrl;
   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;
   eth_packet tr;
   virtual spy_interface spy_if;
   virtual reset_if reset_if; 
   uvm_analysis_imp_vip_tx_pkt_size #(eth_packet, eth_rx_mac_cov) item_collected_vip_tx_pkt_size;
 //  `uvm_analysis_imp_decl(_pcs66)
   //uvm_analysis_imp_pcs66 #(eth_pcs66b_seq_item, eth_rx_mac_cov) cov_pcs66_export;
   bit 	 strict_sop_cg;
   bit preamble_check;
   bit sfd_check;
   bit good_preamble_cg;
   bit good_sfd_cg;   
   bit crc_pass_cg;   
   bit preamble_pass_cg;   
   bit [31:0] frame_size_cg;   
   bit [55:0] good_preamble_value = 56'hfb555555555555;
   bit [55:0] preamble_diff;
   bit [55:0] input_premble_value;
   bit [7:0]  good_sfd_value = 8'hd5;
   bit [7:0]  sfd_diff;
   bit [7:0]  input_sfd_value;
   bit [1:0] sync_header_0,sync_header_1,sync_header_2,sync_header_3;
   bit [7:0] BTF_0 ,BTF_1,BTF_2,BTF_3;
   bit [55:0] data_0,data_1,data_2,data_3;
   data_type_enum data_type[4];
   data_type_enum data_type_pre;
            
   `uvm_component_utils(eth_rx_mac_cov)
 
  covergroup strict_preamble_sfd;
    strict_sfd_cp : coverpoint  strict_sop_cg {
                        bins sfd_0 = {0};
                        bins sfd_1 = {1}; 
                        ignore_bins ignr_sfd_1 = {1} iff(dyn_rcfg_obj_inst.sfd == 0); 
                    }
        
    preamble_check_cg : coverpoint preamble_check {
       bins preamble_chk_1 = {1};
    }

    sfd_check_cg : coverpoint sfd_check {
       bins sfd_chk_1 = {1};
    }
 
     cross_all:cross strict_sfd_cp,preamble_check_cg,sfd_check_cg,good_preamble_cg,good_sfd_cg ;
     
     preamble_err_position : coverpoint preamble_diff {
     //HSD # 16012407139	     
     /* wildcard bins    post_55 = {56'b1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_54 = {56'bx1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_53 = {56'bxx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_52 = {56'bxxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_51 = {56'bxxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_50 = {56'bxxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_49 = {56'bxxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_48 = {56'bxxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx}; */
	wildcard bins    post_47 = {56'bxxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_46 = {56'bxxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_45 = {56'bxxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_44 = {56'bxxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_43 = {56'bxxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_42 = {56'bxxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_41 = {56'bxxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_40 = {56'bxxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_39 = {56'bxxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_38 = {56'bxxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_37 = {56'bxxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_36 = {56'bxxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_35 = {56'bxxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_34 = {56'bxxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_33 = {56'bxxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_32 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_31 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_30 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_29 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_28 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_27 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_26 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_25 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_24 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_23 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_22 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_21 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_20 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_19 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_18 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_17 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_16 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx_xxxxxxxx};
	wildcard bins    post_15 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx_xxxxxxxx};
	wildcard bins    post_14 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx_xxxxxxxx};
	wildcard bins    post_13 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx_xxxxxxxx};
	wildcard bins    post_12 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx_xxxxxxxx};
	wildcard bins    post_11 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx_xxxxxxxx};
	wildcard bins    post_10 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx_xxxxxxxx};
	wildcard bins    post_9 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x_xxxxxxxx};
	wildcard bins    post_8 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1_xxxxxxxx};
	wildcard bins    post_7 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_1xxxxxxx};
	wildcard bins    post_6 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_x1xxxxxx};
	wildcard bins    post_5 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xx1xxxxx};
	wildcard bins    post_4 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxx1xxxx};
	wildcard bins    post_3 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxx1xxx};
	wildcard bins    post_2 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxx1xx};
	wildcard bins    post_1 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxx1x};
	wildcard bins    post_0 = {56'bxxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxxx_xxxxxxx1};
     }
     sfd_err_position: coverpoint sfd_diff {
	bins    post_7 = {1<<7};
	bins    post_6 = {1<<6};
	bins    post_5 = {1<<5};
	bins    post_4 = {1<<4};
	bins    post_3 = {1<<3};
	bins    post_2 = {1<<2};
	bins    post_1 = {1<<1};
	bins    post_0 = {1<<0};
     }
       endgroup // strict_preamble_sfd

   /*covergroup pcs66_decoder_cg ;
    
     sync_hearder_0_cp : coverpoint sync_header_0
     {
       `SYNC_HEADER_COV
     }
     sync_hearder_1_cp : coverpoint sync_header_1
     {
       `SYNC_HEADER_COV
     }
`ifdef G100
     sync_hearder_2_cp : coverpoint sync_header_2
     {
       `SYNC_HEADER_COV
     }
     sync_hearder_3_cp : coverpoint sync_header_3
     {
       `SYNC_HEADER_COV
     }
`endif
     BTF_0_cp : coverpoint BTF_0 iff(sync_header_0==1)
     {
       `BTF_COV
     }
     BTF_1_cp : coverpoint BTF_1 iff(sync_header_1==1)
     {
       `BTF_COV
     }
`ifdef G100
     BTF_2_cp : coverpoint BTF_2 iff(sync_header_2==1)
     {
       `BTF_COV
     }
     BTF_3_cp : coverpoint BTF_3 iff(sync_header_3==1)
     {
       `BTF_COV
     }
`endif
     TYPE_S_TO_D_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_S_0 && data_type[1]==TYPE_D_1) || (data_type[1]==TYPE_S_1 && data_type[2]==TYPE_D_2) || (data_type[2]==TYPE_S_2 && data_type[3]==TYPE_D_3) || (data_type_pre == TYPE_S_3 && data_type[0]==TYPE_D_0)) 
     {
       bins type_s_to_d_bin = {1} ;
     }
     TYPE_S_TO_C_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_S_0 && data_type[1]==TYPE_C_1) || (data_type[1]==TYPE_S_1 && data_type[2]==TYPE_C_2) || (data_type[2]==TYPE_S_2 && data_type[3]==TYPE_C_3) || (data_type_pre == TYPE_S_3 && data_type[0]==TYPE_C_0))
     {
       bins type_s_to_c_bin = {1};
     }
     TYPE_S_TO_T_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_S_0 && data_type[1]==TYPE_T_1) || (data_type[1]==TYPE_S_1 && data_type[2]==TYPE_T_2) || (data_type[2]==TYPE_S_2 && data_type[3]==TYPE_T_3) || (data_type_pre == TYPE_S_3 && data_type[0]==TYPE_T_0))
     {
       bins type_s_to_t_bin = {1};
     }
     TYPE_S_TO_E_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_S_0 && data_type[1]==TYPE_E_1) || (data_type[1]==TYPE_S_1 && data_type[2]==TYPE_E_2) || (data_type[2]==TYPE_S_2 && data_type[3]==TYPE_E_3) || (data_type_pre == TYPE_S_3 && data_type[0]==TYPE_E_0))
     {
       bins type_s_to_e_bin = {1};
     }
     TYPE_D_TO_S_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_D_0 && data_type[1]==TYPE_S_1) || (data_type[1]==TYPE_D_1 && data_type[2]==TYPE_S_2) || (data_type[2]==TYPE_D_2 && data_type[3]==TYPE_D_3) || (data_type_pre == TYPE_D_3 && data_type[0]==TYPE_S_0))
     {
       bins type_d_to_s_bin = {1};
     }
     TYPE_D_TO_C_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_D_0 && data_type[1]==TYPE_C_1) || (data_type[1]==TYPE_D_1 && data_type[2]==TYPE_C_2) || (data_type[2]==TYPE_D_2 && data_type[3]==TYPE_C_3) || (data_type_pre == TYPE_D_3 && data_type[0]==TYPE_C_0))
     {
       bins type_d_to_c_bin = {1};
     }
     TYPE_D_TO_E_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_D_0 && data_type[1]==TYPE_E_1) || (data_type[1]==TYPE_D_1 && data_type[2]==TYPE_E_2) || (data_type[2]==TYPE_D_2 && data_type[3]==TYPE_E_3) || (data_type_pre == TYPE_D_3 && data_type[0]==TYPE_E_0))
     {
       bins type_d_to_e_bin = {1};
     }
     TYPE_D_TO_T_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_D_0 && data_type[1]==TYPE_T_1) || (data_type[1]==TYPE_D_1 && data_type[2]==TYPE_T_2) || (data_type[2]==TYPE_D_2 && data_type[3]==TYPE_T_3) || (data_type_pre == TYPE_D_3 && data_type[0]==TYPE_T_0))
     {
       bins type_d_to_t_bin = {1};
     }
     TYPE_T_TO_S_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_T_0 && data_type[1]==TYPE_S_1) || (data_type[1]==TYPE_T_1 && data_type[2]==TYPE_S_2) || (data_type[2]==TYPE_T_2 && data_type[3]==TYPE_S_3) || (data_type_pre == TYPE_T_3 && data_type[0]==TYPE_S_0))
     {
       bins type_t_to_s_bin = {1};
     }
     TYPE_T_TO_C_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_T_0 && data_type[1]==TYPE_C_1) || (data_type[1]==TYPE_T_1 && data_type[2]==TYPE_C_2) || (data_type[2]==TYPE_T_2 && data_type[3]==TYPE_C_3) || (data_type_pre == TYPE_T_3 && data_type[0]==TYPE_C_0))
     {
       bins type_t_to_c_bin = {1};
     }
     TYPE_T_TO_E_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_T_0 && data_type[1]==TYPE_E_1) || (data_type[1]==TYPE_T_1 && data_type[2]==TYPE_E_2) || (data_type[2]==TYPE_T_2 && data_type[3]==TYPE_E_3) || (data_type_pre == TYPE_T_3 && data_type[0]==TYPE_E_0))
     {
       bins type_t_to_e_bin = {1};
     }
     TYPE_T_TO_D_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_T_0 && data_type[1]==TYPE_D_1) || (data_type[1]==TYPE_T_1 && data_type[2]==TYPE_D_2) || (data_type[2]==TYPE_T_2 && data_type[3]==TYPE_D_3) || (data_type_pre == TYPE_T_3 && data_type[0]==TYPE_D_0))
     {
       bins type_t_to_d_bin = {1};
     }
     TYPE_C_TO_D_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_C_0 && data_type[1]==TYPE_D_1) || (data_type[1]==TYPE_C_1 && data_type[2]==TYPE_D_2) || (data_type[2]==TYPE_C_2 && data_type[3]==TYPE_D_3) || (data_type_pre == TYPE_C_3 && data_type[0]==TYPE_D_0))
     {
       bins type_c_to_d_bin = {1};
     }
     TYPE_C_TO_S_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_C_0 && data_type[1]==TYPE_S_1) || (data_type[1]==TYPE_C_1 && data_type[2]==TYPE_S_2) || (data_type[2]==TYPE_C_2 && data_type[3]==TYPE_S_3) || (data_type_pre == TYPE_C_3 && data_type[0]==TYPE_S_0))
     {
       bins type_c_to_s_bin = {1};
     }
     TYPE_C_TO_E_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_C_0 && data_type[1]==TYPE_E_1) || (data_type[1]==TYPE_C_1 && data_type[2]==TYPE_E_2) || (data_type[2]==TYPE_C_2 && data_type[3]==TYPE_E_3) || (data_type_pre == TYPE_C_3 && data_type[0]==TYPE_E_0))
     {
       bins type_c_to_e_bin = {1};
     }
     TYPE_C_TO_T_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_C_0 && data_type[1]==TYPE_T_1) || (data_type[1]==TYPE_C_1 && data_type[2]==TYPE_T_2) || (data_type[2]==TYPE_C_2 && data_type[3]==TYPE_T_3) || (data_type_pre == TYPE_C_3 && data_type[0]==TYPE_T_0))
     {
       bins type_c_to_t_bin = {1};
     }
     TYPE_E_TO_T_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_E_0 && data_type[1]==TYPE_T_1) || (data_type[1]==TYPE_E_1 && data_type[2]==TYPE_T_2) || (data_type[2]==TYPE_E_2 && data_type[3]==TYPE_T_3) || (data_type_pre == TYPE_E_3 && data_type[0]==TYPE_T_0))
     {
       bins type_e_to_t_bin = {1};
     }
     TYPE_E_TO_C_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_E_0 && data_type[1]==TYPE_C_1) || (data_type[1]==TYPE_E_1 && data_type[2]==TYPE_C_2) || (data_type[2]==TYPE_E_2 && data_type[3]==TYPE_C_3) || (data_type_pre == TYPE_E_3 && data_type[0]==TYPE_C_0))
     {
       bins type_e_to_c_bin = {1};
     }
     TYPE_E_TO_D_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_E_0 && data_type[1]==TYPE_D_1) || (data_type[1]==TYPE_E_1 && data_type[2]==TYPE_D_2) || (data_type[2]==TYPE_E_2 && data_type[3]==TYPE_D_3) || (data_type_pre == TYPE_E_3 && data_type[0]==TYPE_D_0))
     {
       bins type_e_to_d_bin = {1};
     }
     TYPE_E_TO_S_TRANSITION_cp : coverpoint ((data_type[0]==TYPE_E_0 && data_type[1]==TYPE_S_1) || (data_type[1]==TYPE_E_1 && data_type[2]==TYPE_S_2) || (data_type[2]==TYPE_E_2 && data_type[3]==TYPE_S_3) || (data_type_pre == TYPE_E_3 && data_type[0]==TYPE_S_0))
     {
       bins type_e_to_s_bin = {1};
     }
          
   endgroup : pcs66_decoder_cg
*/

   covergroup f_size_rx;
      Frame_size_rx : coverpoint tr.packed_bytes.size{
      	 bins reg_0x16    = {64};
         bins reg_0x18    = {[65:127]};
	 bins reg_0x1a   = {[128:255]};
	 bins reg_0x1c=	{[256:511]};
	 bins reg_0x1e=	{[512:1023]};
	 bins reg_0x20={[1024:1518]};
	 bins reg_0x22={[1519:$]};
     	 }
	endgroup : f_size_rx

  covergroup f_size_short_rx;
     Frame_size_rx_short : coverpoint frame_size_cg {
      	 bins short_frame_range[]    = {[8:63]};
      }
     crc_pass_cp : coverpoint crc_pass_cg {
	ignore_bins pcs_flexe_otn_crc_ignored = {0,1} iff(dyn_rcfg_obj_inst.mode == PCSONLY || dyn_rcfg_obj_inst.mode == FLEXE || dyn_rcfg_obj_inst.mode == OTN);
     }  	
     preamble_pass_cp : coverpoint preamble_pass_cg{
         ignore_bins ignr_pp_1 = {1} ;
	  
     }
     cross_short:cross Frame_size_rx_short,crc_pass_cp,preamble_pass_cp;
  endgroup : f_size_short_rx

`ifdef ANLT

  covergroup anlt_parameters_cg;
  //Revisit: vinoth2x - check for GDR
 /*   AN_CHAN_cp : coverpoint tb_cfg.anchan {
      bins channel_1 = {0};
      bins channel_2 = {1};
      bins channel_3 = {2};
      bins channel_4 = {3};
    }
    link_traing_kr_cp : coverpoint tb_cfg.ltkr{
      bins bin_500 = {500};
      bins bin_501 = {501};
      bins bin_502 = {502};
      bins bin_503 = {503};
      bins bin_504 = {504};
      bins bin_505 = {505};
      bins bin_506 = {506};
      bins bin_507 = {507};
      bins bin_508 = {508};
      bins bin_509 = {509};
      bins bin_510 = {510};
    }
    AN_PAUSE_cp : coverpoint tb_cfg.anpause {
      bins bins_0 = {0};
      bins bins_1 = {1};
      bins bins_2 = {2};
      bins bins_3 = {3};
//      bins bins_4 = {4};
//      bins bins_5 = {5};
//      bins bins_6 = {6};
//      bins bins_7 = {7};
    }
    AN_TECH_cp : coverpoint tb_cfg.crmode {
      bins crmode_0 = {0};
      bins crmode_1 = {1};
      bins other_value = default;
    }
    enable_anlt_cp : coverpoint tb_cfg.anlt_en { 
      bins anlt_0 = {0};
      bins anlt_1 = {1};
    }
    synth_an_cp : coverpoint tb_cfg.synthan {
      bins synthan_0 = {0};
      bins synthan_1 = {1};
    }
    synth_lt_cp : coverpoint tb_cfg.synthlt {
      bins synthlt_0 = {0};
      bins synthlt_1 = {1};
    }
    anlt_parameter_cross : cross  AN_CHAN_cp , link_traing_kr_cp , AN_PAUSE_cp , AN_TECH_cp , enable_anlt_cp ,synth_an_cp , synth_lt_cp ;
*/
  endgroup : anlt_parameters_cg
`ifdef ANLT
  covergroup hard_rst_during_anlt_cg;
    hard_rst_during_an_cp : coverpoint spy_if.seq_mode[0] {
      bins hard_rst_during_an = {1};
    }
    hard_rst_during_lt_cp : coverpoint spy_if.lt_training {
      wildcard bins hard_rst_during_lt_0 = {4'bxxx1};
      wildcard bins hard_rst_during_lt_1 = {4'bxx1x};
      wildcard bins hard_rst_during_lt_2 = {4'bx1xx};
      wildcard bins hard_rst_during_lt_3 = {4'b1xxx};
    }
  endgroup : hard_rst_during_anlt_cg

  covergroup hiber_anlt_cg;
  //Revisit: vinoth2x - check for GDR
    /*hiber_anlt_cp : coverpoint spy_if.o_rx_hi_ber iff(tb_cfg.anlt_en==1){
      bins hiber_anlt = {1};
    }*/
  endgroup : hiber_anlt_cg

  covergroup am_lock_loss_cg;
  //Revisit: vinoth2x - check for GDR
    /*am_lock_loss_cp : coverpoint spy_if.rx_am_lock iff(tb_cfg.anlt_en==1) {
      bins am_lock_loss = {0};
    }*/
  endgroup : am_lock_loss_cg

  covergroup pcs_status_good_cg;
  //Revisit: vinoth2x - check for GDR
    /*pcs_status_good_cp : coverpoint spy_if.rx_pcs_ready iff(tb_cfg.anlt_en==1){
      bins pcs_status_good = {1};
    }*/
  endgroup : pcs_status_good_cg

 `endif  
 `endif // G100
   virtual    function void write_vip_tx_pkt_size(eth_packet trans);
   //   bit [31:0] rx_ctrl_reg;
      bit [31:0] rx_crc_ctrl;
     
      uvm_reg 	regs;
      
      regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_frame_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
    //   rx_ctrl_reg = regs.get();
      regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
       rx_crc_ctrl = regs.get();

      input_premble_value = {trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6]};
      input_sfd_value = trans.packed_bytes[7];
      `uvm_info("eth_rx_mac_cov",$sformatf(" Input preamble ; %0h Input sfd : %0h",input_premble_value,input_sfd_value),UVM_MEDIUM);
      trans.print;

      regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
       tx_preamble_ctrl= regs.get();
      
      this.preamble_diff = good_preamble_value^input_premble_value;
      this.sfd_diff = good_sfd_value^input_sfd_value;    
      this.strict_sop_cg=dyn_rcfg_obj_inst.sfd;
      this.preamble_check=1;
      this.sfd_check=1;
      this.good_preamble_cg=(input_premble_value==good_preamble_value);
      this.good_sfd_cg=(input_sfd_value==good_sfd_value);
      this.crc_pass_cg=rx_crc_ctrl[0];
      //chethan this.preamble_pass_cg=dyn_rcfg_obj_inst.preamble_passthrough;
      if(dyn_rcfg_obj_inst.speed inside {_50G,_40G} && dyn_rcfg_obj_inst.mode == PCSMAC)
         this.preamble_pass_cg = (dyn_rcfg_obj_inst.preamble_passthrough) ; // en_pp is always set to 1 in RTL.However, in TB we still treat is as no PP.
      else
         this.preamble_pass_cg = tx_preamble_ctrl[0];
      this.frame_size_cg = trans.packed_bytes.size();
      f_size_short_rx.sample();
     if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC )
       strict_preamble_sfd.sample();
      
   endfunction

   /*virtual function void write_pcs66(eth_pcs66b_seq_item trans);
     sync_header_0 = trans.pcs66_d0[1:0];
     sync_header_1 = trans.pcs66_d1[1:0];
`ifdef G100
     sync_header_2 = trans.pcs66_d2[1:0];
     sync_header_3 = trans.pcs66_d3[1:0];
`endif
     BTF_0 = trans.pcs66_d0[9:2];
     BTF_1 = trans.pcs66_d1[9:2];
`ifdef G100
     BTF_2 = trans.pcs66_d2[9:2];
     BTF_3 = trans.pcs66_d3[9:2];
`endif
     data_0 = trans.pcs66_d0[65:10];
     data_1 = trans.pcs66_d1[65:10];
`ifdef G100
     data_2 = trans.pcs66_d2[65:10];
     data_3 = trans.pcs66_d3[65:10];
`endif
     `DATA_TYPE(0);
     `DATA_TYPE(1);
`ifdef G100
     `DATA_TYPE(2);
     `DATA_TYPE(3);
`endif

     pcs66_decoder_cg.sample();

`ifdef G100
     if(trans.pcs66_d3[1:0]==1) begin
       if(trans.pcs66_d3[9:2]==8'h78) begin
         data_type_pre = TYPE_S_3; 
       end
       else if (trans.pcs66_d3[9:2] inside {8'h87,8'h99,8'hAA,8'hB4,8'hCC,8'hD2,8'hE1,8'hFF}) begin
         data_type_pre = TYPE_T_3;
       end
       else if ((trans.pcs66_d3[9:2] == 8'h1E && trans.pcs66_d3[65:10]==55'h0) || trans.pcs66_d3[9:2]==8'h4B) begin
         data_type_pre = TYPE_C_3;
       end
       else begin
         data_type_pre = TYPE_E_3;
       end
     end
     else if(trans.pcs66_d3[1:0]==2) begin
       data_type_pre = TYPE_D_3;
     end
     else if (trans.pcs66_d3[1:0] == 0 || trans.pcs66_d3[1:0] == 3) begin
       data_type_pre = TYPE_E_3;
     end
`endif
`ifdef G50
     if(trans.pcs66_d1[1:0]==1) begin
       if(trans.pcs66_d1[9:2]==8'h78) begin
         data_type_pre = TYPE_S_3; 
       end
       else if (trans.pcs66_d1[9:2] inside {8'h87,8'h99,8'hAA,8'hB4,8'hCC,8'hD2,8'hE1,8'hFF}) begin
         data_type_pre = TYPE_T_3;
       end
       else if ((trans.pcs66_d1[9:2] == 8'h1E && trans.pcs66_d1[65:10]==55'h0) || trans.pcs66_d1[9:2]==8'h4B) begin
         data_type_pre = TYPE_C_3;
       end
       else begin
         data_type_pre = TYPE_E_3;
       end
     end
     else if(trans.pcs66_d1[1:0]==2) begin
       data_type_pre = TYPE_D_3;
     end
     else if (trans.pcs66_d1[1:0] == 0 || trans.pcs66_d1[1:0] == 3) begin
       data_type_pre = TYPE_E_3;
     end
`endif
   endfunction */



   function new(string name, uvm_component parent);
      super.new(name,parent);
      // Get Dyn cfg obj
      if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
        `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object");
      end
      item_collected_vip_tx_pkt_size = new("item_collected_vip_tx_pkt_size ",this);
      //cov_pcs66_export = new("cov_pcs66_export",this);
      if(dyn_rcfg_obj_inst.mode == MACSEG || dyn_rcfg_obj_inst.mode == PCSMAC )
        strict_preamble_sfd = new();
      //pcs66_decoder_cg = new();
      f_size_short_rx = new();
      `ifdef G100
      anlt_parameters_cg = new();
      `ifdef ANLT
      hard_rst_during_anlt_cg = new();
      hiber_anlt_cg = new();
      am_lock_loss_cg = new();
      pcs_status_good_cg = new();
      `endif
      `endif //G100
     // uvm_config_db#(eth_param_tb)::get(this, "", "tb_config", tb_cfg);
     // if (tb_cfg == null)  `uvm_fatal("NO_CONN", "failed to get config db in eth_rx_mac_cov");
      if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
        `uvm_fatal("eth_rx_mac_cov", "failed to get spy_interface intf");
      end
      if(!uvm_config_db#(virtual reset_if)::get(this, "", "slv_if", reset_if)) begin
       `uvm_fatal("eth_rx_mac_cov", "failed to get reset_if intf");
      end
      
      `ifdef G100
        anlt_parameters_cg.sample();
      `endif //G100
    
    endfunction: new

`ifdef ANLT
`ifdef G100
task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
    fork
      begin
      @(negedge reset_if.csr_rst_n);
      hard_rst_during_anlt_cg.sample();
      end
      begin
      @(posedge spy_if.rx_pcs_ready);
      wait(spy_if.rx_pcs_ready==1);
      pcs_status_good_cg.sample();
      end
      begin
      @(posedge spy_if.o_rx_hi_ber);
      wait (spy_if.o_rx_hi_ber==1);
      hiber_anlt_cg.sample();
      end
      begin
      @(negedge spy_if.rx_am_lock);
      wait(spy_if.rx_am_lock==0 && spy_if.rx_block_lock==1);
      am_lock_loss_cg.sample();
      end
    join_none
    @(posedge spy_if.clk);
  end
endtask : run_phase  
`endif //G100
`endif
endclass: eth_rx_mac_cov

`endif // ETH_RX_MAC_COV__SV

