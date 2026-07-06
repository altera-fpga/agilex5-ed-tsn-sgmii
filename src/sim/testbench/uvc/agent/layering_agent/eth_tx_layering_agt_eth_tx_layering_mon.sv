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


// Template for UVM-compliant physical-level monitor
// 

`ifndef ETH_TX_LAYERING_MON__SV
`define ETH_TX_LAYERING_MON__SV
//`include "registers.vh"
//`include "registers_urm.svh"


typedef class eth_packet;
typedef class eth_tx_layering_mon;

class eth_tx_layering_mon_callbacks extends uvm_callback;
   // ToDo: Add additional relevant callbacks
   // ToDo: Use a task if callbacks can be blocking


   // Called at start of observed transaction
   virtual function void pre_trans(eth_tx_layering_mon xactor,
                                   eth_packet tr);
   endfunction: pre_trans


   // Called before acknowledging a transaction
   virtual function pre_ack(eth_tx_layering_mon xactor,
                            eth_packet tr);
   endfunction: pre_ack
   

   // Called at end of observed transaction
   virtual function void post_trans(eth_tx_layering_mon xactor,
                                    eth_packet tr);
   endfunction: post_trans

   
   // Callback method post_cb_trans can be used for coverage
   virtual task post_cb_trans(eth_tx_layering_mon xactor,
                              eth_packet tr);
   endtask: post_cb_trans

endclass: eth_tx_layering_mon_callbacks

   

class eth_tx_layering_mon extends uvm_monitor;
  uvm_reg_data_t read_data, ptp_read_data, read_data_1, crc_read_data;
  uvm_reg_data_t txmac_ehip_cfg;
  uvm_reg_data_t saddrl;
  uvm_reg_data_t saddrh;
  uvm_reg_data_t rd_data;
  registers_urm reg_model;
    uvm_reg 	regs,regs_link_fault, ptp_reg;
  bit pad_en=0;
  bit [1:0] step1_2=0;//0:non ptp,1:1step,2:2step
  int pad_size=0;
  int tx_fcs=0;
  bit [47:0] sa;
  bit sa_insert =0;
  bit sip_limit =0;
  bit[55:0] preamble_val_loc = 56'h555555555555d5;
 // logic [1:0] ipg;//mj
  //logic [3:0] link_fault;//mj
  //logic [31:0] link_fault_cfg;//mj
   int j,t;
 int ignore_pkt=0;
  uvm_analysis_port #(eth_packet) mon_analysis_port;  //TLM analysis port
  uvm_analysis_port #(eth_packet) mon_stat_tx_analysis_port;  //TLM analysis port
   uvm_analysis_imp #(avst_req_base,eth_tx_layering_mon) frm_avst_mon;
   typedef virtual eth_sideband_interface v_if;
   v_if mon_if;
 //eth_param_tb tb_cfg; 
  // Dynamic Config Obj
  dyn_rcfg dyn_rcfg_obj_inst;
  virtual spy_interface spy_if;
  virtual eth_fc_interface fc_if;

  eth_packet u_item;
 int transaction_id=0;
 bit        mon_is_ptp_seq;
 bit [7:0]  mon_ptp_val;
 bit [47:0] tx_tod, rx_tod;
 logic [1:0]  sfc_tx;
 logic  sfc_rx;
logic [1:0] ipg;//mj
logic [3:0] link_fault;//mj
  logic [31:0] link_fault_cfg;//mj
 int ptp_pkt_trans; 
 ptp_kind_e ptp_kind;
 ptp_op_e ptp_op;
 bit [15:0] mon_ptp_offset; 
 bit [15:0] mon_cf_offset; 
 bit [15:0] mon_cs_offset; 
 bit [95:0] mon_ingress_ts; 
 //bit [7:0]  mon_i_ptp_tx_fp;
 bit [31:0]  mon_i_ptp_tx_fp; //set to max 
 bit mon_i_asym_sign;
 bit [6:0] mon_i_asym_p2p_idx;
 bit [1:0] tx_tod_state, rx_tod_state; //for rollover coverage
 bit [1:0] rx_tod_bn_overflow, tx_tod_bn_overflow;
 int tx_vl_num, rx_vl_num;
 int total_ptp_pkts,total_v2_pkts,total_1step_pkts,total_2step_pkts,total_ptp_rx_pkts;
 bit ptp_odd,cf_odd,cs_odd;
 
   string  file_avst_pkt_mon = "avst_tx_lyring_mon_avst_pkt.log";
`ifndef NUM_CHANNELS
   integer file_avst_tx_lyring_mon_avst_pkt_id = $fopen(file_avst_pkt_mon,"a");
`else
   integer file_avst_tx_lyring_mon_avst_pkt_id;// = $fopen(file_avst_pkt_mon,"a");
`endif

   string  file_eth_pkt_mon = "avst_tx_lyring_mon_eth_pkt.log";
`ifndef NUM_CHANNELS
   integer file_avst_tx_lyring_mon_eth_pkt_id = $fopen(file_eth_pkt_mon,"a");
`else
   integer file_avst_tx_lyring_mon_eth_pkt_id;// = $fopen(file_eth_pkt_mon,"a");
`endif
   bit pp;
   bit txcrc_cover_preamble;
   bit tx_pad_control;
`ifdef NUM_CHANNELS
   string env_name;
`endif   

 extern function new(string name = "eth_tx_layering_mon",uvm_component parent);
   `uvm_register_cb(eth_tx_layering_mon,eth_tx_layering_mon_callbacks);
   `uvm_component_utils_begin(eth_tx_layering_mon)

   `uvm_component_utils_end

   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void end_of_elaboration_phase(uvm_phase phase);
   extern virtual function void start_of_simulation_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern virtual function void write(input avst_req_base l_item);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   extern protected virtual task tx_monitor();
   covergroup cg;
   Frame_size_tx : coverpoint u_item.packed_bytes.size{
 bins undersized={[9:63]};   
	 bins reg_0x16 = {64};
         bins reg_0x18 = {[65:127]};
	 bins reg_0x1a = {[128:255]};
	 bins reg_0x1c=	{[256:511]};
	 bins reg_0x1e=	{[512:1023]};
	 bins reg_0x20={[1024:1518]};
	 bins reg_0x22={[1519:$]};
      }
      preamble_val: coverpoint preamble_val_loc[55:0]{
      bins fixed={56'h555555555555d5};
      bins random=default;
      }
      small_frames: coverpoint pad_en{
      bins pad_done={1};
   }
      pad_amount: coverpoint pad_size{
       bins lo={[1:23]};
       bins hi={[24:46]};
      }
      //chethancrc_param: coverpoint dyn_rcfg_obj_inst.crc_pass{ // Missing in dyn_rcfg
      //chethan    bins dut_insert={1};
      //chethan    bins user_insert={0};
      //chethan }	 
      preamble_param: coverpoint pp{
          bins preamble_strip={0};
          ignore_bins preamble_passthrough_ignr={1};
 }	 
      rx_crc_reg: coverpoint crc_read_data[0]{
          bins crc_strip={0};
          bins crc_passthrough={1};
 }	 
      //chethan rl: coverpoint dyn_rcfg_obj_inst.rdy_lat;
   pad_en_cp: coverpoint pad_en{
      bins pad_one ={1};
      bins pad_zero={0};
   }

 cross_all:cross preamble_param,rx_crc_reg;    
 cross_pad:cross pad_en_cp,preamble_param,rx_crc_reg;
//chethan  cross_pad:cross pad_en,crc_param,preamble_param,rx_crc_reg,rl{
//chethan  ignore_bins of_crc=binsof(crc_param) intersect{0}  ; //if crc insert =1,no padding   
//chethan }
 crosspad_length:cross small_frames,pad_amount;
 pre_val:cross preamble_param,preamble_val;
 endgroup

covergroup ptp_rollover_cg;
ptp_pos_tod_1_bn_oflow_tx_cp: coverpoint tx_tod_bn_overflow {
  bins tod_tx_oflow = (2'b01 => 2'b10); 
} 

ptp_pos_tod_1_bn_oflow_rx_cp: coverpoint rx_tod_bn_overflow {
  bins tod_rx_oflow = (2'b01 => 2'b10); 
}
 

ptp_ets_24_bit_rollover_cp: coverpoint tx_tod_state {
  bins ets_rollover = (2'b01 => 2'b10);
}

rx_tod_24_bit_rollover_cp: coverpoint rx_tod_state{
  bins rx_tod_24_bit = (2'b01 => 2'b10);
}

endgroup

covergroup ptp_cg;
ptp_step1_2_non:  coverpoint step1_2 {
    bins nop    ={0};
    bins step1  ={1};
    bins step2  ={2};
    ignore_bins not_vld = {3};
  }
  frame_size : coverpoint u_item.packed_bytes.size{
   // bins undersized={[9:63]};   maybe enable in error case
    bins min_size = {64};
    bins med_size = {[65:1500]};
    bins oversize = {[1500:$]};
}
  frame_type: coverpoint u_item.frame_type;
coverpoint pp;  

p2p_field:coverpoint mon_ptp_val[7] {
  bins no_p2p  ={0};
  bins p2p_req ={1};
}


ptp_version:coverpoint mon_ptp_val[6] {
  bins v1_64={0};
  ignore_bins v1_96={1};
}

ets:coverpoint mon_ptp_val[4] {
  bins no_ets={0};
  bins ets_req={1};
}

corr_field:coverpoint mon_ptp_val[3] {
  bins no_cf={0};
  bins cf_req={1};
}

csum_field:coverpoint mon_ptp_val[2] {
  bins no_csum={0};
  bins csum_req={1};
}

eb_field:coverpoint mon_ptp_val[1] {
  bins no_eb={0};
  bins eb_req={1};
}

asym_field:coverpoint mon_ptp_val[0] {
  bins no_asym={0};
  bins asym_req={1};
}

ptp_cf_offset:coverpoint mon_cf_offset {
  bins valid_cf_min = {22};
  bins valid_cf_normal = {[24:$]};
}

ptp_cs_offset:coverpoint mon_cs_offset {
  bins valid_cs_offset = {[40:$]};
}

ptp_ts_offset:coverpoint mon_ptp_offset {
  bins valid_ptp_min = {20};
  bins valid_ptp_high = {[24:$]};
}

//ptp_tx_ipg:coverpoint u_item.interpacket_gap {
 // option.auto_bin_max = 4 ;
//}


//ptp_tx_ipg:coverpoint u_item.interpacket_gap {
 // option.auto_bin_max = 4 ;
//}


ptp_tx_ipg:coverpoint ipg {
    bins ipg_12 = {0};
    bins ipg_10 = {1};
    bins ipg_8 = {2};
    bins ipg_min = {3}; 

 // option.auto_bin_max = 4 ;
}

//ptp_linkfault:coverpoint link_fault{
//bins enable_linkfault ={[0:0]};
//bins enable_unidir={[1:1]};
//bins disable_rf={[2:2]};
//bins force_rf ={[3:3]};
//}

link_fault_en_lf: coverpoint link_fault[0] {
 bins en_lf_0 = {0};
 bins en_lf_1 = {1};
  }

link_fault_en_uni: coverpoint link_fault[1] {
 bins en_uni_0 = {0};
 bins en_uni_1 = {1};
  }

link_fault_dis_rf: coverpoint link_fault[2] {
 bins dis_rf_0 = {0};
 bins dis_rf_1 = {1};
  }

link_fault_force_rf: coverpoint link_fault[3] {
 bins force_rf_0 = {0};
 bins force_rf_1 = {1};
  }

ptp_ingress:coverpoint mon_ingress_ts {
  option.auto_bin_max = 4 ;
}

ptp_cmd:coverpoint u_item.m_ptp_op {
  bins ins_v2[]      = {8'b00010000, 8'b00010100, 8'b00010010, 8'b00010001, 8'b00010101, 8'b00010011};
  bins ins_cf_asm[]  = {8'b00001000, 8'b00001100, 8'b00001010, 8'b00001001, 8'b00001101, 8'b00001011};
  bins ins_cf_p2p[]  = {8'b10001000, 8'b10001100, 8'b10001010, 8'b10001001, 8'b10001101, 8'b10001011};
  bins ins_asm[]     = {8'b00000001, 8'b00000101, 8'b00000011};
} 
 

ptp_cmd_trans: coverpoint step1_2 {
  bins cmd_trans = (0 =>1), (1 => 0), (0 => 2), (2 => 0), (1 => 2), (2 => 1);
}


ptp_asm_p2p_idx:coverpoint mon_i_asym_p2p_idx {
 bins  idx_low  = {[0:41]};
 bins  idx_mid  = {[42:83]};
 bins  idx_high = {[84:$]};
}

ptp_fp:coverpoint mon_i_ptp_tx_fp {
  //bins fp_1  = {[0:63]};
  //bins fp_2  = {[64:127]};
  //bins fp_3  = {[128:191]};
  //bins fp_4  = {[192:$]};
  bins fp_all[4] = {[0:$]};
}

//ptp_pos_tod_1_bn_oflow_tx_cp: coverpoint mon_if.ptp_tx_tod[47:16] {
//  bins tod_tx_oflow = (32'h3B9AC9FF => 32'h3B9ACA00); 
//} 
//
//ptp_pos_tod_1_bn_oflow_rx_cp: coverpoint mon_if.ptp_rx_tod[47:16] {
//  bins tod_rx_oflow = (32'h3B9AC9FF => 32'h3B9ACA00); 
//} 
//
//ptp_ets_24_bit_rollover_cp: coverpoint tx_tod_state {
//  bins ets_rollover = (2'b01 => 2'b10);
//}
//
//rx_tod_24_bit_rollover_cp: coverpoint rx_tod_state{
//  bins rx_tod_24_bit = (2'b01 => 2'b10);
//}



ptp_off: coverpoint ptp_odd;
cf_off: coverpoint cf_odd;
cs_off: coverpoint cs_odd;
cross ets,ptp_off{
ignore_bins no_eb_req=binsof(ets) intersect{0};
}

ptp_total_ptp_pkt_cp : coverpoint total_ptp_pkts {
  bins tot_pkts = {[1:$]};
}
ptp_total_v2_pkt_cp : coverpoint total_v2_pkts {
  bins tot_v2_pkts = {[1:$]};
}
ptp_total_1step_pkt_cp : coverpoint total_1step_pkts {
  bins tot_1step_pkts = {[1:$]};
}
ptp_total_2step_pkt_cp : coverpoint total_2step_pkts {
  bins tot_2step_pkts = {[1:$]};
}
ptp_total_ptp_rx_pkt_cp : coverpoint total_ptp_rx_pkts {
  bins tot_rx_pkts = {[1:$]};
}

cross ptp_off,ptp_cmd;

cross ptp_step1_2_non,ptp_cmd;

cross corr_field,cf_off{
ignore_bins no_eb_req=binsof(corr_field) intersect{0};
}

 
cross eb_field,cs_off{
ignore_bins no_eb_req=binsof(eb_field) intersect{0};
}

cross csum_field,cs_off{
ignore_bins no_eb_req=binsof(csum_field) intersect{0};
}

cross ptp_step1_2_non,frame_size{
ignore_bins of_nop=binsof(ptp_step1_2_non) intersect{0};
}

//cross latency,ptp_op {
//ignore_bins noptp_latency=binsof(ptp_op) intersect{0};
//}

cross ets,ptp_version,csum_field,eb_field{
ignore_bins ets_eb_cs=binsof(csum_field) intersect{1} && binsof(eb_field) intersect{1};
}

cross corr_field,ptp_version,csum_field,eb_field{
ignore_bins cf_eb_cs=binsof(csum_field) intersect{1} && binsof(eb_field) intersect{1};
}

//cross ets,corr_field{
//illegal_bins ets_cf=binsof(ets) intersect{1} && binsof(corr_field) intersect{1};
//}

cross ptp_step1_2_non,frame_type{
ignore_bins of_nop=binsof(ptp_step1_2_non) intersect{0};
}

cross ptp_step1_2_non,pp{
ignore_bins of_nop=binsof(ptp_step1_2_non) intersect{0};
}

cross pp,ptp_cmd;

ptp_tx_mix_pause_cp : coverpoint sfc_tx iff(ptp_pkt_trans > 0)
{
  bins no_pfc_tx = {0};
  bins tx_pfc = {1};
}

ptp_rx_mix_pause_cp : coverpoint sfc_rx iff(spy_if.o_rx_ptp_ready)
{
  bins no_pfc_rx = {0};
  bins rx_pfc = {1};
}

//cross ptp_op,ptp_version{
//ignore_bins of_nop=binsof(ptp_op) intersect{0};
//illegal_bins ptp2_ver1=binsof(ptp_op) intersect{2} && binsof(ptp_version) intersect{0};
//}

ptp_vl_debug_tx_50g_cp : coverpoint tx_vl_num iff (dyn_rcfg_obj_inst.speed == _50G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
}

ptp_vl_debug_tx_100g_cp : coverpoint tx_vl_num iff (dyn_rcfg_obj_inst.speed == _100G)
{
   bins vl_num_0 = {0};
   bins vl_num_1 = {1};
   bins vl_num_2 = {2};
   bins vl_num_3 = {3};
   bins vl_num_4 = {4};
   bins vl_num_5 = {5};
   bins vl_num_6 = {6};
   bins vl_num_7 = {7};
   bins vl_num_8 = {8};
   bins vl_num_9 = {9};
   bins vl_num_10 = {10};
   bins vl_num_11 = {11};
   bins vl_num_12 = {12};
   bins vl_num_13 = {13};
   bins vl_num_14 = {14};
   bins vl_num_15 = {15};          
   bins vl_num_16 = {16};          
   bins vl_num_17 = {17};          
   bins vl_num_18 = {18};          
   bins vl_num_19 = {19};
}

ptp_vl_debug_tx_200g_cp : coverpoint tx_vl_num iff (dyn_rcfg_obj_inst.speed == _200G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
  bins vl_num_4 = {4};
  bins vl_num_5 = {5};
  bins vl_num_6 = {6};
  bins vl_num_7 = {7};
}

ptp_vl_debug_tx_400g_cp : coverpoint tx_vl_num iff (dyn_rcfg_obj_inst.speed == _400G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
  bins vl_num_4 = {4};
  bins vl_num_5 = {5};
  bins vl_num_6 = {6};
  bins vl_num_7 = {7};
  bins vl_num_8 = {8};
  bins vl_num_9 = {9};
  bins vl_num_10 = {10};
  bins vl_num_11 = {11};
  bins vl_num_12 = {12};
  bins vl_num_13 = {13};
  bins vl_num_14 = {14};
  bins vl_num_15 = {15};
}


ptp_vl_debug_rx_50g_cp : coverpoint rx_vl_num iff (dyn_rcfg_obj_inst.speed == _50G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
}

ptp_vl_debug_rx_100g_cp : coverpoint rx_vl_num iff (dyn_rcfg_obj_inst.speed == _100G)
{
   bins vl_num_0 = {0};
   bins vl_num_1 = {1};
   bins vl_num_2 = {2};
   bins vl_num_3 = {3};
   bins vl_num_4 = {4};
   bins vl_num_5 = {5};
   bins vl_num_6 = {6};
   bins vl_num_7 = {7};
   bins vl_num_8 = {8};
   bins vl_num_9 = {9};
   bins vl_num_10 = {10};
   bins vl_num_11 = {11};
   bins vl_num_12 = {12};
   bins vl_num_13 = {13};
   bins vl_num_14 = {14};
   bins vl_num_15 = {15};          
   bins vl_num_16 = {16};          
   bins vl_num_17 = {17};          
   bins vl_num_18 = {18};          
   bins vl_num_19 = {19};
}

ptp_vl_debug_rx_200g_cp : coverpoint rx_vl_num iff (dyn_rcfg_obj_inst.speed == _200G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
  bins vl_num_4 = {4};
  bins vl_num_5 = {5};
  bins vl_num_6 = {6};
  bins vl_num_7 = {7};
}

ptp_vl_debug_rx_400g_cp : coverpoint rx_vl_num iff (dyn_rcfg_obj_inst.speed == _400G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
  bins vl_num_4 = {4};
  bins vl_num_5 = {5};
  bins vl_num_6 = {6};
  bins vl_num_7 = {7};
  bins vl_num_8 = {8};
  bins vl_num_9 = {9};
  bins vl_num_10 = {10};
  bins vl_num_11 = {11};
  bins vl_num_12 = {12};
  bins vl_num_13 = {13};
  bins vl_num_14 = {14};
  bins vl_num_15 = {15};
}

endgroup
 
endclass: eth_tx_layering_mon


function eth_tx_layering_mon::new(string name = "eth_tx_layering_mon",uvm_component parent);
   super.new(name, parent);
   mon_analysis_port = new ("mon_analysis_port",this);
   mon_stat_tx_analysis_port = new ("mon_stat_tx_analysis_port",this);
   frm_avst_mon = new("rm_avst_mon", this);
   cg=new;
    if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
   if(dyn_rcfg_obj_inst.ptp == 1) begin
     ptp_cg=new;
     ptp_rollover_cg=new;
 end
endfunction: new

function void eth_tx_layering_mon::write(input avst_req_base l_item);
  j=0;
t=0;
  $display("Received pkt frm layering monitor");
  if(l_item.protocol_error_eop == 1'b0)
  begin
  transaction_id = transaction_id + 1;
  `uvm_info("tx layering driver",$psprintf("Received pkt frm layering monitor \n",l_item.print()),UVM_LOW);
//  $fwrite(file_avst_tx_lyring_mon_avst_pkt_id,"Transaction no:%0d\n %s \n",transaction_id,l_item.convert2string());
  
   //DM_TODO: remove regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
   crc_read_data = regs.get_mirrored_value();
   crc_read_data[0] = ~crc_read_data[0];
   `uvm_info(get_full_name(), $sformatf("CRC config value = %0h",crc_read_data), UVM_MEDIUM)
   
   //DM_TODO: remove regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_preamble_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   txmac_ehip_cfg = regs.get();

   //DM_TODO: read proper register and update IPG for coverage
   //ipg=txmac_ehip_cfg[2:1];//mj
  
   //DM_TODO: enable for cov regs_link_fault = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   //DM_TODO: enable for cov link_fault_cfg = regs_link_fault.get();
   `uvm_info(get_full_name(), $sformatf("link_fault_cgf = %0h",link_fault_cfg), UVM_MEDIUM)
   
     link_fault=link_fault_cfg[28:0];//mj
   `uvm_info(get_full_name(), $sformatf("link_fault = %0h",link_fault), UVM_MEDIUM)



   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   saddrl = regs.get();
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   saddrh = regs.get();
   `uvm_info(get_full_name(), $sformatf("saddrl =%0h  saddrh = %0h",saddrl,saddrh), UVM_MEDIUM)
   //uvm_reg_data is 64 bits by default. 
   sa = {saddrh[15:0],saddrl[31:0]};
   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_src_addr_override_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   read_data = regs.get_mirrored_value();
   `uvm_info(get_full_name(), $sformatf("src_override read_data=%0h",read_data), UVM_MEDIUM)

   sa_insert = read_data[0]; 

if (sip_limit ==1)
    u_item.sip_limit_test =1;

   regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(tx_pad_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
   read_data_1 = regs.get_mirrored_value();
   tx_pad_control = read_data_1[0];
   `uvm_info(get_full_name(), $sformatf("Tx pad control=%0h",tx_pad_control), UVM_MEDIUM)

   if(dyn_rcfg_obj_inst.speed inside {_50G,_40G} && dyn_rcfg_obj_inst.mode == PCSMAC)
   pp = (dyn_rcfg_obj_inst.preamble_passthrough) ; // en_pp is always set to 1 in RTL, irrespective of GUI parameter value for 50G. However, in TB we still treat is as no PP.
   else
   pp = txmac_ehip_cfg[0];
   txcrc_cover_preamble = 0; //DM_TODO: recheck txmac_ehip_cfg[9]; 
   `uvm_info(get_full_name(), $sformatf("Read from register Preamble_passthrough %b",txmac_ehip_cfg[0]), UVM_LOW)
   `uvm_info(get_full_name(), $sformatf("CRC pass through RCVD at TX LAYERING MON = %0b,Preamble_passthrough %b, TXCRC cover preamble %0b",crc_read_data,pp,txcrc_cover_preamble), UVM_LOW)
   if(dyn_rcfg_obj_inst.speed inside {_50G,_40G} && dyn_rcfg_obj_inst.mode == PCSMAC) begin
     if(l_item.channel[0] && l_item.data_symbols.size<64) begin
     pad_en=1;
     pad_size=64-l_item.data_symbols.size; //dont know whether pkt will come or not
     end
     if(!l_item.channel[0] && l_item.data_symbols.size<60) begin
     pad_en=1;
     pad_size=60-l_item.data_symbols.size; //dont know whether pkt will come or not
     end
  end
  else begin
    if(tx_pad_control == 1'b1)  begin
      if(pp && l_item.channel[0] && l_item.data_symbols.size<72) begin
         pad_en=1;
         pad_size=72-l_item.data_symbols.size; //dont know whether pkt will come or not
      end
      if(pp && !l_item.channel[0] && l_item.data_symbols.size<68) begin
         pad_en=1;
         pad_size=68-l_item.data_symbols.size; //dont know whether pkt will come or not
      end
      if(!pp && l_item.channel[0] && l_item.data_symbols.size<64) begin
         pad_en=1;
         pad_size=64-l_item.data_symbols.size; //dont know whether pkt will come or not
      end
      if(!pp && !l_item.channel[0] && l_item.data_symbols.size<60) begin
         pad_en=1;
         pad_size=60-l_item.data_symbols.size; //dont know whether pkt will come or not
      end
    end
    else if(l_item.data_symbols.size<33) begin
      pad_en=1;
      pad_size=60-l_item.data_symbols.size; //dont know whether pkt will come or not
      u_item.underflow_condition = 1'b1;
      `uvm_info("shruti_dbg",$psprintf("Underflow condition added for packet \n",l_item.print()),UVM_LOW);
    end
    else begin
      pad_en = 0;
      u_item.underflow_condition = 1'b0;
    end
  end
  u_item.packed_bytes=new[l_item.data_symbols.size](l_item.data_symbols);


//Removed as per agreement with shabbirx
  //Added this code to predict frame size when tx error is inserted for that frame///////
if(dyn_rcfg_obj_inst.speed==_100G ) begin
  if(u_item.packed_bytes.size()% 8 > 0 && u_item.packed_bytes.size()% 8 < 8 && mon_if.tx_error) begin
    if(u_item.packed_bytes.size() > 56 && u_item.packed_bytes.size() < 64 && l_item.channel[0]) begin
      u_item.packed_bytes=new[64](l_item.data_symbols);
    end
    else if (u_item.packed_bytes.size() >= 56 && u_item.packed_bytes.size() < 64 && !l_item.channel[0]) begin
      u_item.packed_bytes=new[60](l_item.data_symbols);
    end
    else begin
      if(l_item.channel[0]) begin
        if (sip_limit ==1)
            u_item.packed_bytes=new[l_item.data_symbols.size](l_item.data_symbols);
        else
            u_item.packed_bytes=new[l_item.data_symbols.size + (8 - u_item.packed_bytes.size()% 8)](l_item.data_symbols);
      end
      else begin
         u_item.packed_bytes=new[(l_item.data_symbols.size + (8 - u_item.packed_bytes.size()% 8)) - 4 ](l_item.data_symbols);
      end
    end
  end
end
  //////////////////
if(dyn_rcfg_obj_inst.speed inside {_50G,_40G} && dyn_rcfg_obj_inst.mode == PCSMAC) begin
    t=-8;
 if(l_item.data_symbols.size<(22+t) || (l_item.data_symbols.size>=(20+t) && { u_item.packed_bytes[20+t],u_item.packed_bytes[21+t]}=='h8100 && l_item.data_symbols.size<(26+t)) || (l_item.data_symbols.size>=(22+t) &&{ u_item.packed_bytes[20+t],u_item.packed_bytes[21+t]}=='h8100 && {u_item.packed_bytes[24+t],u_item.packed_bytes[25+t]}=='h8100 && l_item.data_symbols.size<(30+t)))  
 		  u_item.unpack_bytes_extra_short_frame(l_item.channel[0],0);
 else
 		  u_item.unpack_bytes(l_item.channel[0],0);
  if (pp && (dyn_rcfg_obj_inst.speed inside {_50G,_40G}))  
    begin 
     u_item.preamble  = mon_if.mon_tx_preamble; 
     preamble_val_loc = mon_if.mon_tx_preamble;  
    end
end
else begin
  //u_item.unpack_bytes(!tb_cfg.crc_pass,pp);
   t= -8*(!pp);
	  if(l_item.data_symbols.size<(22+t) || (l_item.data_symbols.size>=(20+t) && { u_item.packed_bytes[20+t],u_item.packed_bytes[21+t]}=='h8100 && l_item.data_symbols.size<(26+t)) || (l_item.data_symbols.size>=(22+t) &&{ u_item.packed_bytes[20+t],u_item.packed_bytes[21+t]}=='h8100 && {u_item.packed_bytes[24+t],u_item.packed_bytes[25+t]}=='h8100 && l_item.data_symbols.size<(30+t)))  
 		 u_item.unpack_bytes_extra_short_frame(l_item.channel[0],pp);
 else
  		 u_item.unpack_bytes(l_item.channel[0],pp);

end

 
  u_item.transaction_id = transaction_id;
  `ifndef ENABLE_ETH_VIP
  u_item.rx_error[2:1] = 2'b00;
  `endif
  // if(pad_en && !mon_if.tx_error) begin
  // HSD https://hsdes.intel.com/resource/16011639844
  // https://hsdes.intel.com/resource/16011668483
  if(pad_en) begin
  $display("pad size is %d",pad_size);
  if(l_item.channel[0]) begin
    u_item.ignore_pkt=0;//this wont happen
    //In loopback mode : when tx_skip_crc is zero , DUT does not pad the frame hence DUT-rx will receive undersized frame with crc error
    `ifndef ENABLE_ETH_VIP
    u_item.rx_error[2:1] = 2'b11;
    `endif
  end
  else begin
  if(l_item.data_symbols.size<(22+t) && u_item.packed_bytes[20+t] !=='h81) 
		u_item.payload=new[u_item.payload.size+pad_size-22+(-t)+l_item.data_symbols.size] (u_item.payload);
		else if (l_item.data_symbols.size>=20+t && u_item.packed_bytes[20+t]=='h81 && u_item.packed_bytes[24+t] !=='h81 &&  l_item.data_symbols.size<26+t) 
		u_item.payload=new[u_item.payload.size+pad_size-26+(-t)+l_item.data_symbols.size] (u_item.payload);
		else if (l_item.data_symbols.size>=20+t && {u_item.packed_bytes[20+t],u_item.packed_bytes[21+t]}=='h8100 && u_item.packed_bytes[24+t] =='h81  &&l_item.data_symbols.size<30+t)
			u_item.payload=new[u_item.payload.size+pad_size-30+(-t)+l_item.data_symbols.size] (u_item.payload);			
		else
		u_item.payload=new[u_item.payload.size+pad_size] (u_item.payload);
end
  end
//muralasx: Adding below logic to update source address field when the parameter sa=1 & skip_crc=0
   if(l_item.channel[0]==0 && (dyn_rcfg_obj_inst.sa==1 || sa_insert==1)) begin
    u_item.src_address = sa;
    `uvm_info(get_full_name(), $sformatf("updating source addr = %0h",u_item.src_address), UVM_MEDIUM)
   end

    `ifdef ENABLE_ETH_VIP
if(spy_if.loopback_enable == 0) begin 
  if(l_item.channel[0]==0) begin
    u_item.calc_crc32();
      u_item.fcs={<<byte{u_item.fcs}};
      u_item.seen_tx_fcs_error_insertion = 0;
  end
  else begin 
    tx_fcs = u_item.fcs;
    u_item.calc_crc32();
    u_item.fcs={<<byte{u_item.fcs}};
    if(tx_fcs != u_item.fcs) begin
      u_item.seen_tx_fcs_error_insertion =1;
      `uvm_info(get_type_name(),$sformatf("fcs error seen in monitor fcs:32'%h",u_item.fcs), UVM_LOW)
    end
    else u_item.seen_tx_fcs_error_insertion = 0;
    u_item.fcs = tx_fcs;
  end
  if(mon_if.tx_error) u_item.seen_tx_error_insertion = 1;
  else u_item.seen_tx_error_insertion = 0;
  end else begin
//Loopback mode : DUT tx will inject CRC, on RX side DUT MAC will remove the
//CRC and forwards pkt to the client
  if(read_data==0 && l_item.channel[0]==1) u_item.fcs=0;
  if(read_data==1 && l_item.channel[0]==0) begin
      u_item.calc_crc32(txcrc_cover_preamble);
      u_item.fcs={<<byte{u_item.fcs}};
   end
end
 `else
  if(read_data[0]==0 && l_item.channel[0]==1) u_item.fcs=0;
  if(read_data[0]==1 && l_item.channel[0]==0) begin
      u_item.calc_crc32(txcrc_cover_preamble);
      u_item.fcs={<<byte{u_item.fcs}};
   end
  `endif
  if(txcrc_cover_preamble) begin
  u_item.rx_error[1] = 1'b1;
  u_item.seen_tx_fcs_error_insertion =1;
  end
 // Add PTP sidebands captured at SOP
 u_item.is_ptp_seq   = mon_is_ptp_seq;
 u_item.m_ptp_op     = mon_ptp_val;
 u_item.m_ptp_kind   = ptp_kind;
 u_item.ptp_offset   = mon_ptp_offset; 
 u_item.cf_offset    = mon_cf_offset; 
 u_item.cs_offset    = mon_cs_offset; 
 u_item.ingress_ts   = mon_ingress_ts; 
 u_item.i_ptp_tx_fp  = mon_i_ptp_tx_fp;
 u_item.asym_sign    = mon_i_asym_sign;
 u_item.asym_p2p_idx = mon_i_asym_p2p_idx;
  ptp_odd=mon_ptp_offset%2;
  cf_odd=mon_cf_offset%2;
  cs_odd=mon_cs_offset%2;

  //for ptp statistics coverage
//DM_TODO:  ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_ptp_pkts_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
//DM_TODO:  `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
//DM_TODO:  ptp_read_data = ptp_reg.get_mirrored_value();
//DM_TODO:  total_ptp_pkts = ptp_read_data;
//DM_TODO:  //$display("VR: tot ptp= %0d", total_ptp_pkts);
//DM_TODO:
//DM_TODO:  ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_1step_ptp_pkts_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
//DM_TODO:  `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
//DM_TODO:  ptp_read_data = ptp_reg.get_mirrored_value();
//DM_TODO:  total_1step_pkts = ptp_read_data;
//DM_TODO:  //$display("VR: tot ptp= %0d", total_1step_pkts);
//DM_TODO: 
//DM_TODO:  ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_2step_ptp_pkts_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
//DM_TODO:  `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
//DM_TODO:  ptp_read_data = ptp_reg.get_mirrored_value();
//DM_TODO:  total_2step_pkts = ptp_read_data;
//DM_TODO:  //$display("VR: tot ptp= %0d", total_2step_pkts);
//DM_TODO:
//DM_TODO:  ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_v2_ptp_pkts_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
//DM_TODO:  `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
//DM_TODO:  ptp_read_data = ptp_reg.get_mirrored_value();
//DM_TODO:  total_v2_pkts = ptp_read_data;
//DM_TODO:  //$display("VR: tot ptp= %0d", total_v2_pkts);
//DM_TODO:
//DM_TODO:  ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_rx_total_ptp_ts_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
//DM_TODO:  `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
//DM_TODO:  ptp_read_data = ptp_reg.get_mirrored_value();
//DM_TODO:  total_ptp_rx_pkts = ptp_read_data;
//DM_TODO:  //$display("VR: tot ptp= %0d", total_ptp_rx_pkts);

 tx_vl_num = (dyn_rcfg_obj_inst.speed==_50G)  ? spy_if.tx_o_vl_ss[7] : 
             (dyn_rcfg_obj_inst.speed==_100G) ? spy_if.tx_o_vl_ss[3] :
             (dyn_rcfg_obj_inst.speed==_200G) ? spy_if.tx_o_vl_ss[1] : spy_if.tx_o_vl_ss[0];
 // $display("VR debug: tx_vl_num=%0d", tx_vl_num);
 //.tx_o_vl_ss[NODE]
 
 rx_vl_num = (dyn_rcfg_obj_inst.speed==_50G)  ? spy_if.rx_o_vl_ss[7] : 
             (dyn_rcfg_obj_inst.speed==_100G) ? spy_if.rx_o_vl_ss[3] :
             (dyn_rcfg_obj_inst.speed==_200G) ? spy_if.rx_o_vl_ss[1] : spy_if.tx_o_vl_ss[0];
 // $display("VR debug: rx_vl_num=%0d", rx_vl_num);


 if(u_item.preamble[63:56]==8'hfb)  mon_analysis_port.write(u_item);
 else  `uvm_info(get_type_name(),$sformatf("preamble 1st byte isnt fb,packet expected to be dropped:32'%h",u_item.preamble), UVM_MEDIUM)

 mon_stat_tx_analysis_port.write(u_item);
`uvm_info(get_full_name(), $sformatf("CRC pass through RCVD at TX LAYERING MON = %0b,Preamble_passthrough %b, TXCRC cover preamble %0b",read_data,pp,txcrc_cover_preamble), UVM_LOW)
 cg.sample();

 if(dyn_rcfg_obj_inst.ptp == 1)
  ptp_cg.sample();
 pad_en=0;
   pad_size=0;

`uvm_info("tx layering driver",$psprintf("Sending packet to scoreaboard \n %s",u_item.sprint()),UVM_MEDIUM);
  $fwrite(file_avst_tx_lyring_mon_eth_pkt_id,"Transaction no:%0d\n %s \n",transaction_id,u_item.print_transaction(transaction_id));
end
else
begin
  `uvm_info(get_name(),$psprintf("Error packet received (packet without eop)...\n"),UVM_NONE);
end

endfunction: write

function void eth_tx_layering_mon::build_phase(uvm_phase phase);
   super.build_phase(phase);
   uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
   if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in in tx layering mon");   
   u_item=eth_packet::type_id::create("u_item",this);
 
   // Get Dyn cfg obj
  // if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
  //    `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
  // end
  if(!uvm_config_db#(virtual eth_fc_interface)::get(this, "", "mst_if", fc_if)) begin
       `uvm_fatal("env_name_tx_layer_mon", "failed to get fc interface");
  end

   if(!uvm_config_db#(string)::get(this,"","env_name", env_name)) begin
       `uvm_fatal("env_name_tx_layer_mon", "failed to get env_name");
   end

    if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
    `uvm_fatal("LAYERING_MON","Virtual spy interface not configured!");
  end


endfunction: build_phase

function void eth_tx_layering_mon::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   uvm_config_db#(v_if)::get(this, "", "mst_if", mon_if);
    //uvm_config_db#(eth_param_tb)::get(this, "", "tb_config", tb_cfg);
    
    file_avst_tx_lyring_mon_avst_pkt_id = $fopen({env_name,"_",file_avst_pkt_mon},"a");
    file_avst_tx_lyring_mon_eth_pkt_id  = $fopen({env_name,"_",file_eth_pkt_mon},"a");
    
endfunction: connect_phase

function void eth_tx_layering_mon::end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase); 
   //if (tb_cfg == null)  `uvm_fatal("NO_CONN", "failed to get config db in tx layering mon"); 
   if (mon_if == null)  `uvm_fatal("NO_CONN", "failed to get config db in tx layering mon"); 
endfunction: end_of_elaboration_phase


function void eth_tx_layering_mon::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
   //ToDo: Implement this phase here

endfunction: start_of_simulation_phase


task eth_tx_layering_mon::reset_phase(uvm_phase phase);
   super.reset_phase(phase);
   // ToDo: Implement reset here

endtask: reset_phase


task eth_tx_layering_mon::configure_phase(uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure your component here
endtask:configure_phase


task eth_tx_layering_mon::run_phase(uvm_phase phase);
   super.run_phase(phase);
  // phase.raise_objection(this,""); //Raise/drop objections in sequence file
   fork
      tx_monitor();
   join
  // phase.drop_objection(this);

endtask: run_phase


task eth_tx_layering_mon::tx_monitor();
  // Capture all PTP side band signals at SOP negedge based on DUT input (to work with race condition update), later to be passed at EOP along with packet contents at EOP
  forever begin
      @(mon_if.mon_cb);
      if(mon_if.mon_cb.dut_tx_sop==1'b1 && mon_if.mon_cb.dut_tx_valid==1'b1 && mon_if.mon_cb.dut_tx_ready==1'b1) begin
        if(mon_if.mon_cb.dut_ptp_req || mon_if.mon_cb.dut_ptp_cf ||  mon_if.mon_cb.dut_ptp_ets  || mon_if.mon_cb.dut_ptp_asym_lat_en || mon_if.mon_cb.dut_ptp_p2p_en  /*&& mon_if.mon_cb.tx_skip_crc==0*/) //2step dut_ptp_req,1step ets or cf, 2 step tx_skip_crc could be 0 or 1
//        if((mon_if.mon_cb.dut_ptp_req || mon_if.mon_cb.dut_ptp_cf ||  mon_if.mon_cb.dut_ptp_ets ) && mon_if.mon_cb.tx_skip_crc==0) //2step,1step ets or cf,if tx_skip_crc is 1 then adapter will mask the ptp operation for that frame
           begin
             mon_is_ptp_seq = 1;
             if(mon_if.mon_cb.dut_ptp_req) step1_2=2;
             else step1_2=1;
           end
        else begin
           mon_is_ptp_seq = 0;
              step1_2=0;
        end
       //tx_tod= mon_if.drv_cb.ptp_tx_tod[95:48];
       //rx_tod= mon_if.drv_cb.ptp_rx_tod[95:48];
        
        mon_ptp_val[0]= mon_if.mon_cb.dut_ptp_asym_lat_en;
        mon_ptp_val[1]= mon_if.mon_cb.dut_ptp_eb;
        mon_ptp_val[2]= mon_if.mon_cb.dut_ptp_0csum;
        mon_ptp_val[3]= mon_if.mon_cb.dut_ptp_cf;
        mon_ptp_val[4]= mon_if.mon_cb.dut_ptp_ets;
        mon_ptp_val[5]= mon_if.mon_cb.dut_ptp_req;
        mon_ptp_val[6]= mon_if.mon_cb.dut_ptp_format;
        mon_ptp_val[7]= mon_if.mon_cb.dut_ptp_p2p_en;
        if(mon_ptp_val inside {INS_NOOP,
            INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB,INS_V1_W_ASYM_LAT,INS_V1_W_ASYM_LAT_UDP_CS_0,INS_V1_W_ASYM_LAT_EB,
            INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,
            INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB,
            INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,                
            INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,INS_2STEP} && (!mon_if.mon_cb.ptp_error) )
        //{8'b00000000,8'b01010000,8'b01010100,8'b01010010,8'b01010001,8'b01010101,8'b01010011,8'b00010000,8'b00010100,8'b00010010,8'b00010001,8'b00010101,8'b00010011,8'b00001000,8'b00001100,8'b00001010,8'b00001001,8'b00001101,8'b00001011,8'b00100000,8'b10001000,8'b10001100,8'b10001010,8'b10001001,8'b10001101,8'b10001011})
          ptp_kind = PTP_NORMAL;
        else 
          ptp_kind = PTP_ERR;

 //if (mon_if.mon_cb.ptp_error)
 //         ptp_kind = PTP_ERR; 
 //        else
 //         ptp_kind = PTP_NORMAL;


        mon_ptp_offset  = mon_if.mon_cb.dut_ptp_ts_offset; 
        mon_cf_offset   = mon_if.mon_cb.dut_ptp_cf_offset; 

        if(mon_if.mon_cb.dut_ptp_0csum) mon_cs_offset   = mon_if.mon_cb.dut_ptp_csum_offset; // works as eb too
        if(mon_if.mon_cb.dut_ptp_eb) mon_cs_offset   = mon_if.mon_cb.dut_ptp_eb_offset; // works as eb too

        mon_ingress_ts  = mon_if.mon_cb.dut_ptp_ts; 
        mon_i_ptp_tx_fp = mon_if.mon_cb.dut_ptp_fp;
        mon_i_asym_sign = mon_if.mon_cb.dut_ptp_asym_sign;
        mon_i_asym_p2p_idx = mon_if.mon_cb.dut_ptp_asym_p2p_idx;
     end

     if (mon_is_ptp_seq) begin
     if(spy_if.o_tx_ptp_ready)  ++ptp_pkt_trans;
     else ptp_pkt_trans = 0;
 
     sfc_tx = fc_if.tx_sfc;
 
     sfc_rx = fc_if.rx_sfc;
 

    if(mon_if.ptp_tx_tod[47:16] inside {['h3B9AC9F8 : 'h3B9AC9FF]})
    begin
     tx_tod_bn_overflow= 01; 
    end
    else if(mon_if.ptp_tx_tod[47:16] inside {['h0 : 'h00000008]})
    begin
     tx_tod_bn_overflow= 10;  
    end
    else begin
     tx_tod_bn_overflow=00;
    end

     if(mon_if.ptp_rx_tod[47:16] inside {['h3B9AC9F8 : 'h3B9AC9FF]})
    begin
     rx_tod_bn_overflow= 01; 
    end
    else if(mon_if.ptp_rx_tod[47:16] inside {['h0 : 'h00000008]})
    begin
     rx_tod_bn_overflow= 10;  
    end
    else
    begin
     rx_tod_bn_overflow= 00;
    end

    if (mon_if.ptp_tx_tod[31:16] inside {['hFFFA : 'hFFFF]} && mon_if.ptp_tx_tod[32] == 0) //for tx ns rollover coverage
   begin
     tx_tod_state = 'b01; 
   end

 else if (mon_if.ptp_tx_tod[31:16] inside {['h0000 : 'h0006]} && mon_if.ptp_tx_tod[32] == 1)
   begin
     tx_tod_state = 'b10;
   end
 else
   begin
     tx_tod_state = 'b00;
   end


   if (mon_if.ptp_rx_tod[31:16] inside {['hFFFA : 'hFFFF]} && mon_if.ptp_rx_tod[32] == 0) //for rx ns rollover coverage
   begin
     rx_tod_state = 'b01; 
   end

 else if (mon_if.ptp_rx_tod[31:16] inside {['h0000 : 'h0006]} && mon_if.ptp_rx_tod[32] == 1)
   begin
     rx_tod_state = 'b10;
   end
 else
   begin
     rx_tod_state = 'b00;
   end
 ptp_rollover_cg.sample();
 end  //is_ptp_seq


   end
endtask: tx_monitor

function void eth_tx_layering_mon::report_phase(uvm_phase phase);
    super.report_phase(phase);
$fclose(file_avst_tx_lyring_mon_eth_pkt_id);
$fclose(file_avst_tx_lyring_mon_avst_pkt_id);
 `uvm_info("MONRPT", $psprintf("No of Packets ignored=%d",ignore_pkt),UVM_LOW);
endfunction:report_phase

`endif // ETH_TX_LAYERING_MON__SV



