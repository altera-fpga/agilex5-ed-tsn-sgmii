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


`ifndef DYN_RCFG__SV
`define DYN_RCFG__SV
//Class : dyn_rcfg
//This is dynamic config object class
//Variable : enum

// Enums for dynamic config object
// typedef enum {_400G,_200G,_100G,_50G,_40G,_25G,_10G} speed_e;
// typedef enum {MACSEG, PCSMAC, PCSONLY, OTN, FLEXE} mode_e;
typedef enum {_MGE, _MGBASET, _USXGMII, _XGMII, _BASERS10,_NF10G, _MGBASETA10, _BASERA10, _NF1G} llvar_e;
typedef enum {_SM} device_mode_e;

class dyn_rcfg extends uvm_sequence_item;

   rand speed_e speed;
   rand speed_e ll_speed;
   rand llvar_e ll_var;
   rand device_mode_e device_mode;
   rand int ch_num;
   rand bit trans_type; 
   rand bit ptp; 
   rand bit enable_an; 
   rand bit enable_lt;
   rand bit anlt;  
   rand bit[3:0] an_chan0;
   rand bit cr_mode;
   rand bit rx_fc_fwd; 
   rand bit sa; 
   rand bit txvlan; 
   rand bit rxvlan; 
   rand bit en_mx_frsz; 
   rand bit en_async_adp; 
   rand bit preamble_passthrough; 
   rand bit sfd; 
   rand bit [1:0] lf; 
   rand bit [1:0] rxbyte_rem; 
   rand bit [1:0] fc_rdy_drop; 
   rand bit [1:0] rdy_lat; 
   rand bit [1:0] phyrefclk; 
   rand bit [1:0] syspll; 
   rand bit [39:0] syspllcnt; 
   rand int cadnum; 
   rand int cadden; 
   rand int ipg; 
   //rand bit [2:0] fec_type; 
   rand fec_type_e fec_type; 
   rand int tx_frm_size; 
   rand int rx_frm_size; 
   rand int ipg_rm_perperiod;
   rand mode_e mode;
   rand bit [1:0] fc;  // Just in case FC gets controlled via param
   rand int fp_width; // for ptp only

   /* ALEX: FIXME
    Just kept below 2 variables reference to make compile clean as its erferenced so many times, remove these after proper fix*/
   bit skew_test;
   bit crc_pass;
   //dsamantx:keeping below 3 variables to make compile clean and this might be necessary for tb_cfg.
   bit enable_stas_count;
   rand bit strict_preamble;
   bit rm_rx_pads;

   bit cl72prbs;
   bit [1:0] anpause;
   bit crmode;
   bit rfg_en;
   int ltkr;
   bit synthan;
   bit synthlt;

   rand bit [15:0] active_node;
   rand bit [15:0] anlt_en_node;

   `uvm_object_utils_begin(dyn_rcfg)
     `uvm_field_enum(speed_e,speed,UVM_ALL_ON)
     `uvm_field_enum(speed_e,ll_speed,UVM_ALL_ON)
     `uvm_field_enum(llvar_e,ll_var,UVM_ALL_ON)
     `uvm_field_enum(device_mode_e,device_mode,UVM_ALL_ON)
     `uvm_field_int(ch_num,UVM_ALL_ON)
     `uvm_field_int(trans_type,UVM_ALL_ON)
     `uvm_field_int(ptp,UVM_ALL_ON)
     `uvm_field_int(enable_an,UVM_ALL_ON)
     `uvm_field_int(enable_lt,UVM_ALL_ON)
     `uvm_field_int(an_chan0,UVM_ALL_ON)
     `uvm_field_int(cr_mode,UVM_ALL_ON)
     `uvm_field_int(rx_fc_fwd,UVM_ALL_ON)
     `uvm_field_int(sa,UVM_ALL_ON)
     `uvm_field_int(txvlan,UVM_ALL_ON)
     `uvm_field_int(rxvlan,UVM_ALL_ON)
     `uvm_field_int(en_mx_frsz,UVM_ALL_ON)
     `uvm_field_int(en_async_adp,UVM_ALL_ON)
     `uvm_field_int(preamble_passthrough,UVM_ALL_ON)
     `uvm_field_int(strict_preamble,UVM_ALL_ON)
     `uvm_field_int(sfd,UVM_ALL_ON)
     `uvm_field_int(lf,UVM_ALL_ON)
     `uvm_field_int(rxbyte_rem,UVM_ALL_ON)
     `uvm_field_int(crc_pass,UVM_ALL_ON)
     `uvm_field_int(rm_rx_pads,UVM_ALL_ON)
     `uvm_field_int(fc_rdy_drop,UVM_ALL_ON)
     `uvm_field_int(rdy_lat,UVM_ALL_ON)
     `uvm_field_int(phyrefclk,UVM_ALL_ON)
     `uvm_field_int(syspll,UVM_ALL_ON)
     `uvm_field_int(syspllcnt,UVM_ALL_ON)
     `uvm_field_int(cadnum,UVM_ALL_ON)
     `uvm_field_int(cadden,UVM_ALL_ON)
     `uvm_field_int(ipg,UVM_ALL_ON)
     `uvm_field_enum(fec_type_e,fec_type,UVM_ALL_ON)
     `uvm_field_int(tx_frm_size,UVM_ALL_ON)
     `uvm_field_int(rx_frm_size,UVM_ALL_ON)
     `uvm_field_int(ipg_rm_perperiod,UVM_ALL_ON)
     `uvm_field_enum(mode_e,mode,UVM_ALL_ON)
     `uvm_field_int(fc,UVM_ALL_ON)
     `uvm_field_int(active_node,UVM_ALL_ON)
     `uvm_field_int(anlt_en_node,UVM_ALL_ON)
     `uvm_field_int(anlt,UVM_ALL_ON)
     `uvm_field_int(fp_width,UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "dyn_rcfg");
      super.new(name);
   endfunction : new

   constraint speed_c {
      if (mode==PCSMAC) speed inside {_100G,_50G,_40G,_25G,_10G};
      else speed inside {_400G,_200G,_100G,_50G,_40G,_25G,_10G};	
      solve mode before speed;
   }    

   constraint ch_num_c {
      if (speed==_400G)      ch_num inside {4,8};   // 4,8 - PAM4
      else if (speed==_200G) ch_num inside {2,4,8}; // 2,4 - PAM4; 8 - NRZ
      else if (speed==_100G) ch_num inside {1,2,4}; // 1,2 - PAM4; 4 - NRZ
      else if (speed==_50G)  ch_num inside {1,2};   // 1   - PAM4; 2 - NRZ
      else if (speed==_40G)  ch_num == 4;           // NRZ
      else if (speed==_25G)  ch_num == 1;           // NRZ
      else                   ch_num == 1;           // NRZ
   }
 

endclass // dyn_rcfg
`endif
