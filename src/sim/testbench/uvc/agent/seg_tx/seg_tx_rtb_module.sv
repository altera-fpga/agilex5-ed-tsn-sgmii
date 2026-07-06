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


module seg_tx_rtb_module (client_tx_if uif_tx); 
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import eth_env_pkg::*;


	class driver_concrete extends seg_tx_driver_abstract; 
		bit[63:0] packed_words[$];
   		bit[2:0] packed_words_last_valid_bytes;
   		bit first_frame;
   		int last_frame_end=-1;
   		int num_words; 
   		bit last_byte_flag=0; //flag to indicate the next loop is sop
   		uvm_reg 	regs;
   		uvm_reg_data_t read_data;
         int unsigned randc_fp, temp_fp; 
         int unsigned fp_q[$];   //set to max         
		extern task monitor_ready(); 
		extern task bfm_drive_idle(); 
		extern task init(); 
		extern task bfm_drive_tran(eth_packet _tran);
		extern task drive_custom_interface(eth_packet _tran); 
		extern task gen_rdy_ltny();
		extern task drive_interm_idle(); 
		extern task num_words_update();
		extern task pack_words(eth_packet _tran);
		extern function bit select_upper_lower(int _sop_pos);
      extern virtual function int unsigned get_seg_fp_randc();
	endclass 

	class monitor_concrete extends seg_tx_monitor_abstract;
		uvm_reg 	regs,regs_link_fault,ptp_reg;
   		uvm_reg_data_t read_data,txmac_ehip_cfg,ptp_read_data;
   		bit txcrc_cover_preamble;
   		ptp_kind_e ptp_kind;
	    int num_ptp_pkts = 0;
	    bit [95:0] q_ptp_tx[$];
	    bit [95:0] o_ptp_ets;
	    bit [95:0] ts_diff_hex;
	    bit [7:0]  mon_ptp_val;
      bit [1:0] step1_2=0;//0:non ptp,1:1step,2:2step
      bit [1:0] tx_tod_state, rx_tod_state;
      bit ptp_odd,cf_odd,cs_odd;
      int tx_vl_num, rx_vl_num;
      logic sfc_tx, sfc_rx;
       logic [1:0] ipg;//mj
       logic [3:0] link_fault;//mj
     logic [31:0] link_fault_cfg;//mj
      int ptp_pkt_trans;
      int total_ptp_pkts,total_v2_pkts,total_1step_pkts,total_2step_pkts,total_ptp_rx_pkts;
      bit [1:0] rx_tod_bn_overflow, tx_tod_bn_overflow;      



      eth_packet m_tran,m_tran_clone;

		  extern task collect_tran();
   		extern task collect_ptp_tx_tran(int _sop_pos);
   		extern function int get_num_words();
   		extern function bit select_upper_lower(int _sop_pos);

      function new();
        super.new();
        
        `ifdef PTP_EN
        ptp_cg= new();
        ptp_rollover_cg=new();
       `endif
      endfunction

covergroup ptp_rollover_cg;

   ptp_pos_tod_1_bn_oflow_tx_cp: coverpoint tx_tod_bn_overflow {
     bins tod_tx_oflow = (2'b01 => 2'b10); 
  } 

//ptp_pos_tod_1_bn_oflow_rx_cp: coverpoint mon_if.ptp_rx_tod[47:16] {
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

  frame_size : coverpoint m_tran.seg_packed_bytes.size{
   // bins undersized={[9:63]};   maybe enable in error case
    bins min_size = {64};
    bins med_size = {[65:1500]};
    bins oversize = {[1500:$]};
} 
  frame_type: coverpoint m_tran.frame_type;

  //coverpoint pp_tx;

p2p_field:coverpoint mon_ptp_val[7] {
  bins no_p2p  ={0};
  bins p2p_req ={1};
}

ptp_tx_mix_pause_cp : coverpoint sfc_tx iff(spy_if.o_tx_ptp_ready)
{
  bins no_pfc_tx = {0};
  bins tx_pfc = {1};
}

ptp_rx_mix_pause_cp : coverpoint sfc_rx iff(spy_if.o_rx_ptp_ready)
{
  bins no_pfc_rx = {0};
  bins rx_pfc = {1};
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

//ptp_cf_offset:coverpoint mon_cf_offset {
//  bins valid_cf_min = {22};
//  bins valid_cf_normal = {[24:$]};
//}

ptp_cf_offset_upper:coverpoint uif_tx.mon_cb.i_ptp_cf_offset[31:16] {
  bins valid_cf_min = {22};
  bins valid_cf_normal = {[24:$]};
}
ptp_cf_offset_lowe:coverpoint uif_tx.mon_cb.i_ptp_cf_offset[15:0] {
  bins valid_cf_min = {22};
  bins valid_cf_normal = {[24:$]};
}



//ptp_cs_offset:coverpoint mon_cs_offset {
//  bins valid_cs_offset = {[40:$]};
//}

ptp_cs_offset_upper:coverpoint uif_tx.mon_cb.i_ptp_csum_offset[31:16] {
  bins valid_cs_offset = {[40:$]};
}
ptp_cs_offset_lower:coverpoint uif_tx.mon_cb.i_ptp_csum_offset[15:0] {
  bins valid_cs_offset = {[40:$]};
}


//ptp_ts_offset:coverpoint mon_ptp_offset {
//  bins valid_ptp_min = {20};
//  bins valid_ptp_high = {[24:$]};
//}

ptp_ts_offset_upper:coverpoint uif_tx.mon_cb.i_ptp_ts_offset[31:16] {
  bins valid_ptp_min = {20};
  bins valid_ptp_high = {[24:$]};
}
ptp_ts_offset_lower:coverpoint uif_tx.mon_cb.i_ptp_ts_offset[15:0] {
  bins valid_ptp_min = {20};
  bins valid_ptp_high = {[24:$]};
}


//ptp_tx_ipg:coverpoint m_tran.interpacket_gap {
  //option.auto_bin_max = 4 ;
//}

//ptp_tx_ipg:coverpoint m_tran.interpacket_gap {
//  option.auto_bin_max = 4 ;
//}

ptp_tx_ipg:coverpoint ipg {
    bins ipg_12 = {0};
    bins ipg_10 = {1};
    bins ipg_8 = {2};
    bins ipg_min = {3}; 

 // option.auto_bin_max = 4 ;
}

ptp_linkfault:coverpoint link_fault{
bins enable_linkfault ={[0:0]};
bins enable_unidir={[1:1]};
bins disable_rf={[2:2]};
bins force_rf ={[3:3]};
}


ptp_ingress:coverpoint uif_tx.mon_cb.i_ptp_tx_its {
  option.auto_bin_max = 4 ;
}

//ptp_cmd:coverpoint u_item.m_ptp_op {
ptp_cmd:coverpoint mon_ptp_val {
  bins ins_v2[]      = {8'b00010000, 8'b00010100, 8'b00010010, 8'b00010001, 8'b00010101, 8'b00010011};
  bins ins_cf_asm[]  = {8'b00001000, 8'b00001100, 8'b00001010, 8'b00001001, 8'b00001101, 8'b00001011};
  bins ins_cf_p2p[]  = {8'b10001000, 8'b10001100, 8'b10001010, 8'b10001001, 8'b10001101, 8'b10001011};
  bins ins_asm[]     = {8'b00000001, 8'b00000101, 8'b00000011};
} 
 

ptp_cmd_trans: coverpoint step1_2 {
  bins cmd_trans = (0 =>1), (1 => 0), (0 => 2), (2 => 0), (1 => 2), (2 => 1);
}


//ptp_asm_p2p_idx:coverpoint mon_i_asym_p2p_idx {
// bins  idx_low  = {[0:41]};
// bins  idx_mid  = {[42:83]};
// bins  idx_high = {[84:$]};
//}
ptp_asm_p2p_idx_upper:coverpoint uif_tx.mon_cb.i_ptp_asym_p2p_idx[13:7] {
 bins  idx_low  = {[0:41]};
 bins  idx_mid  = {[42:83]};
 bins  idx_high = {[84:$]};
}
ptp_asm_p2p_idx_lower:coverpoint uif_tx.mon_cb.i_ptp_asym_p2p_idx[6:0] {
 bins  idx_low  = {[0:41]};
 bins  idx_mid  = {[42:83]};
 bins  idx_high = {[84:$]};
}



//ptp_fp:coverpoint mon_i_ptp_tx_fp {
//  bins fp_1  = {[0:63]};
//  bins fp_2  = {[64:127]};
//  bins fp_3  = {[128:191]};
//  bins fp_4  = {[192:$]};
//}
ptp_fp_upper:coverpoint uif_tx.mon_cb.i_ptp_fp[15:8] {
  bins fp_1  = {[0:63]};
  bins fp_2  = {[64:127]};
  bins fp_3  = {[128:191]};
  bins fp_4  = {[192:$]};
}
ptp_fp_lower:coverpoint uif_tx.mon_cb.i_ptp_fp[7:0] {
  bins fp_1  = {[0:63]};
  bins fp_2  = {[64:127]};
  bins fp_3  = {[128:191]};
  bins fp_4  = {[192:$]};
}

ptp_fp_upper_32:coverpoint uif_tx.mon_cb.i_ptp_fp[63:32] iff (m_config.fp_width == 32) {
   bins fp_up_32[4] = {[0:$]};
}
ptp_fp_lower_32:coverpoint uif_tx.mon_cb.i_ptp_fp[31:0] iff (m_config.fp_width == 32) {
   bins fp_low_32[4] = {[0:$]};
}


//ptp_pos_tod_1_bn_oflow_tx_cp: coverpoint mon_if.ptp_tx_tod[47:16] {
//ptp_pos_tod_1_bn_oflow_tx_cp: coverpoint tx_tod_bn_overflow {
//   bins tod_tx_oflow = (2'b01 => 2'b10); 
//  } 
//
////ptp_pos_tod_1_bn_oflow_rx_cp: coverpoint mon_if.ptp_rx_tod[47:16] {
//ptp_pos_tod_1_bn_oflow_rx_cp: coverpoint rx_tod_bn_overflow {
//  bins tod_rx_oflow = (2'b01 => 2'b10); 
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

ptp_vl_debug_tx_50g_cp : coverpoint tx_vl_num iff (m_config.speed == _50G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
}

ptp_vl_debug_tx_100g_cp : coverpoint tx_vl_num iff (m_config.speed == _100G)
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

ptp_vl_debug_tx_200g_cp : coverpoint tx_vl_num iff (m_config.speed == _200G)
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

ptp_vl_debug_tx_400g_cp : coverpoint tx_vl_num iff (m_config.speed == _400G) {
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

ptp_vl_debug_rx_50g_cp : coverpoint rx_vl_num iff (m_config.speed == _50G)
{
  bins vl_num_0 = {0};
  bins vl_num_1 = {1};
  bins vl_num_2 = {2};
  bins vl_num_3 = {3};
}

ptp_vl_debug_rx_100g_cp : coverpoint rx_vl_num iff (m_config.speed == _100G)
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

ptp_vl_debug_rx_200g_cp : coverpoint rx_vl_num iff (m_config.speed == _200G)
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

ptp_vl_debug_rx_400g_cp : coverpoint rx_vl_num iff (m_config.speed == _400G)
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


cross ets,ptp_off{
ignore_bins no_eb_req=binsof(ets) intersect{0};
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

//TODO
//cross ptp_step1_2_non,pp{
//ignore_bins of_nop=binsof(ptp_step1_2_non) intersect{0};
//}

//cross ptp_op,ptp_version{
//ignore_bins of_nop=binsof(ptp_op) intersect{0};
//illegal_bins ptp2_ver1=binsof(ptp_op) intersect{2} && binsof(ptp_version) intersect{0};
//}

endgroup




   	endclass


   task monitor_concrete::collect_tran();
   //	eth_packet m_tran;
   	int repeat_num,j,size,eop_pos,sop_pos,num_word;
   	bit [31:0] tx_preamble_pass,rx_crc_cfg,rx_preamble_pass;

   	m_tran = eth_packet::type_id::create("m_tran");
      num_word=get_num_words();
   //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );//mj
   //DM_TODO: txmac_ehip_cfg = regs.get();//mj
    ipg=txmac_ehip_cfg[2:1];//mj
   //DM_TODO: regs_link_fault = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_link_fault_config_OFFSET_REG,m_config.speed), 1 );//mj
   //DM_TODO: link_fault_cfg = regs_link_fault.get();//mj
     link_fault=link_fault_cfg[28:0];//mj

`uvm_info(get_full_name(),$sformatf("link fault value is=%0h",link_fault), UVM_MEDIUM)
      fork 
 
    begin
      forever 
      begin 
         while(uif_tx.mon_cb.found_sop!==1)
            @(uif_tx.mon_cb);

         if(uif_tx.found_sop_pos.size()>0) begin
            sop_pos= uif_tx.found_sop_pos.pop_front();
            `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor found_sop_pos: %0d",sop_pos), UVM_LOW);
            if (m_config.ptp) begin
               collect_ptp_tx_tran(sop_pos);
            end
         
            //DEBUG
            foreach(uif_tx.mon_cb.in_frame[i])begin
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor inframe[%0d]: %0d -- 0",i,uif_tx.mon_cb.in_frame[i]), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor sop[%0d]: %0d , sop_pos: %0d -- 0",i,uif_tx.sop[i],sop_pos), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor eop[%0d]: %0d , eop_pos: %0d -- 0",i,uif_tx.eop[i],eop_pos), UVM_HIGH);
            end         
         end

         if(spy_if.o_tx_ptp_ready && (uif_tx.mon_cb.i_ptp_ts_req[0] || uif_tx.mon_cb.i_ptp_ts_req[1]))  ++ptp_pkt_trans;
         else ptp_pkt_trans = 0;
 
         sfc_tx = fc_if.tx_sfc;
 
         sfc_rx = fc_if.rx_sfc;
      
         size = num_word - sop_pos;
         m_tran.seg_packed_bytes=new[size]; 
         
         foreach(m_tran.seg_packed_bytes[i])
            m_tran.seg_packed_bytes[i]= uif_tx.mon_cb.data[sop_pos+i];
            
         $display("monitor_concrete:%t seg seg_packed_bytes is %p",$time,m_tran.seg_packed_bytes);
         if(uif_tx.found_eop_pos.size()>0) begin
            eop_pos=uif_tx.found_eop_pos.pop_front();
            `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor found_eop_pos: %0d",eop_pos), UVM_LOW);
         end
      
         if(uif_tx.mon_cb.found_eop==1 && (eop_pos > sop_pos))//sop & eop on the same cycle //make sure its not eop after sop situation 
         begin
         
            //DEBUG
               `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor in_frame_prev: %0d -- 1",uif_tx.mon_cb.in_frame_prev), UVM_HIGH);
            foreach(uif_tx.mon_cb.in_frame[i])begin
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor inframe[%0d]: %0d -- 1",i,uif_tx.mon_cb.in_frame[i]), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor sop[%0d]: %0d , sop_pos: %0d -- 1",i,uif_tx.sop[i],sop_pos), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor eop[%0d]: %0d , eop_pos: %0d -- 1",i,uif_tx.eop[i],eop_pos), UVM_HIGH);
            end
            
            m_tran.seg_packed_bytes=new[(eop_pos-sop_pos)+1](m_tran.seg_packed_bytes);
            m_tran.empty_bytes=uif_tx.mon_cb.eop_empty[eop_pos];
            m_tran.skip_tx_crc_insertion=uif_tx.mon_cb.skip_crc[eop_pos];
            m_tran.tx_error_insertion=uif_tx.mon_cb.error[eop_pos];
            $display("monitor_concrete:%t seg seg_packed_bytes is %p",$time,m_tran.seg_packed_bytes);
            //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
            //DM_TODO: tx_preamble_pass = regs.get();
            m_tran.seg_unpack_bytes(uif_tx.mon_cb.skip_crc[eop_pos],tx_preamble_pass[0]);
            
            //temp_fix stumulur 
            //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,m_config.speed), 1 );
            //DM_TODO: rx_crc_cfg=regs.get(); 
            //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
            //DM_TODO: txmac_ehip_cfg = regs.get();
            txcrc_cover_preamble = txmac_ehip_cfg[9]; 			
            
            
            if(rx_crc_cfg[0]==0)begin
               m_tran.fcs=0;
            end else begin
               m_tran.calc_crc32(txcrc_cover_preamble);//by default argument is 0
            end 
            
            m_tran.transaction_id++; //starting the transaction id from 0
            `uvm_info("seg_tx_monitor driver",$psprintf("Sending packet to ptp reference model \n %s",m_tran.sprint()),UVM_MEDIUM); 
            $cast(m_tran_clone,m_tran.clone());
            mmbox.put(m_tran_clone);
                  
            -> spy_if.TX_SEG_PKT_SENT;
              
            if(uif_tx.found_sop_pos.size()==0) // no more packets on the same cycle 
               @(uif_tx.mon_cb);
      
         end
         else
         begin 
            while(uif_tx.mon_cb.found_eop==0 ||(uif_tx.mon_cb.found_eop==1 && (eop_pos < sop_pos))) begin // continue if eop pos <sop pos ie sop after eop
               @(uif_tx.mon_cb);
               while(!uif_tx.mon_cb.vld)begin
                  @uif_tx.mon_cb;
               end            
            
               if(uif_tx.mon_cb.found_eop==1) begin 
                  eop_pos=uif_tx.found_eop_pos.pop_front();
                  m_tran.empty_bytes=uif_tx.mon_cb.eop_empty[eop_pos];
                  m_tran.skip_tx_crc_insertion=uif_tx.mon_cb.skip_crc[eop_pos];
                  m_tran.tx_error_insertion=uif_tx.mon_cb.error[eop_pos];
                  `uvm_info(get_type_name(),$sformatf("inside seg_tx monitor uif_tx.mon_cb.eop_empty[%0d]: %0h -- 2",eop_pos,uif_tx.mon_cb.eop_empty[eop_pos]), UVM_LOW);
                  repeat_num=eop_pos+1;
               end else begin
                     repeat_num=num_word;
               end
            
               repeat(repeat_num)
               begin 	
                  m_tran.seg_packed_bytes=new[m_tran.seg_packed_bytes.size()+1](m_tran.seg_packed_bytes); 
                  m_tran.seg_packed_bytes[m_tran.seg_packed_bytes.size()-1]= uif_tx.mon_cb.data[j] ;
                  j++; 
               end
               j=0;
            
               if(uif_tx.mon_cb.found_eop==1) 
               begin 
                  //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
                  //DM_TODO: rx_preamble_pass = regs.get();
                  //DM_TODO: m_tran.seg_unpack_bytes(uif_tx.mon_cb.skip_crc[eop_pos],rx_preamble_pass[0]); //why use rx_pp?
                  //DM_TODO: //temp_fix stumulur 
                  //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,m_config.speed), 1 );
                  //DM_TODO: rx_crc_cfg=regs.get(); 
                  //DM_TODO: 
                  //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
                  //DM_TODO: txmac_ehip_cfg = regs.get();
                  //DM_TODO: txcrc_cover_preamble = txmac_ehip_cfg[9];
                  
                  //if(rx_crc_cfg[0]==0) begin
                  //   m_tran.fcs=0;
                  //   m_tran.pack_bytes(0,txcrc_cover_preamble);
                  //end else begin
                  //   m_tran.calc_crc32(txcrc_cover_preamble);//by default argument is 0
                  //end
                  
                  if(rx_crc_cfg[0]==0)begin
                     m_tran.fcs=0;
                  end else begin
                     m_tran.calc_crc32(txcrc_cover_preamble);//by default argument is 0
                  end                   
                  
                  m_tran.transaction_id++; //starting the transaction id from 0
                  `uvm_info("seg_tx_monitor driver",$psprintf("Sending packet to ptp reference model \n %s",m_tran.sprint()),UVM_MEDIUM); 
                  $cast(m_tran_clone,m_tran.clone());
            	  mmbox.put(m_tran_clone);
                `ifdef PTP_EN
                ptp_cg.sample();
                `endif

                  -> spy_if.TX_SEG_PKT_SENT;

                  break; // breaking out of while loop when eop is asserted; this makes sure that pkt doesnt get collected in sop after eop on same cycle scenerio
               end  //found_eop
            end  // // continue if eop pos <sop pos ie sop after eop
         end //else encapusalting while
      end  // forever
    end //fork



     begin
    forever begin
      @(uif_tx.mon_cb);
      if (m_config.ptp)
      begin

    if(uif_tx.ptp_tx_tod[47:16] inside {['h3B9AC9F8 : 'h3B9AC9FF]})
    begin
     tx_tod_bn_overflow= 01; 
    end
   else if(uif_tx.ptp_tx_tod[47:16] inside {['h0 : 'h00000008]})
    begin
     tx_tod_bn_overflow= 10;  
     $display("tx bn overflow 10");
    end
   else begin
     tx_tod_bn_overflow=00;
    end

   if(uif_tx.ptp_rx_tod[47:16] inside {['h3B9AC9F8 : 'h3B9AC9FF]})
    begin
     rx_tod_bn_overflow= 01; 
    end
   else if(uif_tx.ptp_rx_tod[47:16] inside {['h0 : 'h00000008]})
    begin
     rx_tod_bn_overflow= 10;  
     $display("rx bn overflow 10");
    end
   else
    begin
     rx_tod_bn_overflow= 00;
    end


       if (uif_tx.ptp_tx_tod[31:16] inside {['hFFFE : 'hFFFF]} && uif_tx.ptp_tx_tod[32] == 0) //for tx ns rollover coverage
   begin
     tx_tod_state = 'b01; 
     $display("tx_tod_state 01");
   end

 else if (uif_tx.ptp_tx_tod[31:16] inside {['h0000 : 'h0002]} && uif_tx.ptp_tx_tod[32] == 1)
   begin
     tx_tod_state = 'b10;
     $display("tx_tod_state 10");
   end
 else
   begin
     tx_tod_state = 'b00;
   end

    if (uif_tx.ptp_rx_tod[31:16] inside {['hFFFE : 'hFFFF]} && uif_tx.ptp_rx_tod[32] == 0) //for rx ns rollover coverage
   begin
     rx_tod_state = 'b01; 
     $display("rx_tod_state 01");
   end

 else if (uif_tx.ptp_rx_tod[31:16] inside {['h0000 : 'h0002]} && uif_tx.ptp_rx_tod[32] == 1)
   begin
     rx_tod_state = 'b10;
     $display("rx_tod_state 10");
   end
 else
   begin
     rx_tod_state = 'b00;
   end
`ifdef PTP_EN
 ptp_rollover_cg.sample();
`endif
end // if ptp
end //forever
end //ptp fork

  join_none

   endtask: collect_tran 

   function int monitor_concrete::get_num_words(); 
   	case(m_config.speed) 
   		_400G: return(16); 
   		_200G: return(8); 
   		_100G: return(4); 
   		_50G,_40G : return(2); 
   		_25G,_10G : return(1); 
   	endcase 
   	endfunction
      
   //To select whether the seg signal is use for upper or lower
   //only for 400G
   function bit monitor_concrete::select_upper_lower(int _sop_pos);
   
      if(_sop_pos>=8 && _sop_pos<=15)begin
         return 1;
      end else begin
         return 0;
      end
   
   endfunction: select_upper_lower

   //This task is called per SOP so is ok to do it one by one
   task monitor_concrete::collect_ptp_tx_tran(int _sop_pos);
   
      bit seg_select;
      
      seg_select      = select_upper_lower(_sop_pos);

      //if(uif_tx.mon_cb.rdy == 1 )begin
      if(uif_tx.mon_cb.vld == 1 )begin
         $display("AMAR-1 is_ptp_seq %d",m_tran.is_ptp_seq);
         if(uif_tx.mon_cb.i_ptp_ts_req[seg_select] || uif_tx.mon_cb.i_ptp_ins_cf[seg_select] ||  uif_tx.mon_cb.i_ptp_ins_ets[seg_select]  || uif_tx.mon_cb.i_ptp_asym[seg_select] || uif_tx.mon_cb.i_ptp_p2p[seg_select])begin 
            m_tran.is_ptp_seq = 1;
         $display("AMAR-2 is_ptp_seq %d",m_tran.is_ptp_seq);
         end else begin
            m_tran.is_ptp_seq = 0;
         $display("AMAR-3 is_ptp_seq %d",m_tran.is_ptp_seq);
         end      
         $display("AMAR-4 is_ptp_seq %d",m_tran.is_ptp_seq);
      end

      if(uif_tx.mon_cb.i_ptp_ts_req[0] || uif_tx.mon_cb.i_ptp_ts_req[1])  //VR: ptp coverage 
       step1_2=2;
      else step1_2=1;
 
      //if(m_tran.is_ptp_seq == 1 && m_config.speed == _400G )
      //Need to update for non ptp packet also
      if(m_config.speed == _400G ) begin //change for 400g

         mon_ptp_val[7]  = uif_tx.mon_cb.i_ptp_p2p[seg_select];
         mon_ptp_val[6]  = uif_tx.mon_cb.i_ptp_ts_format[seg_select];
         mon_ptp_val[5]  = uif_tx.mon_cb.i_ptp_ts_req[seg_select];
         mon_ptp_val[4]  = uif_tx.mon_cb.i_ptp_ins_ets[seg_select];
         mon_ptp_val[3]  = uif_tx.mon_cb.i_ptp_ins_cf[seg_select];
         mon_ptp_val[2]  = uif_tx.mon_cb.i_ptp_0csum[seg_select];
         mon_ptp_val[1]  = uif_tx.mon_cb.i_ptp_update_eb[seg_select];
         mon_ptp_val[0]  = uif_tx.mon_cb.i_ptp_asym[seg_select];
         
   
         m_tran.m_ptp_op     = mon_ptp_val; 
         m_tran.ptp_offset   = uif_tx.mon_cb.i_ptp_ts_offset[(16*seg_select) +: 16];
         m_tran.cf_offset    = uif_tx.mon_cb.i_ptp_cf_offset[(16*seg_select) +: 16];
         if(mon_ptp_val[2]) m_tran.cs_offset    = uif_tx.mon_cb.i_ptp_csum_offset[(16*seg_select) +: 16];
         if(mon_ptp_val[1]) m_tran.cs_offset    = uif_tx.mon_cb.i_ptp_csum_offset[(16*seg_select) +: 16];
         m_tran.ingress_ts   = uif_tx.mon_cb.i_ptp_tx_its[(96*seg_select) +: 96];
         //m_tran.i_ptp_tx_fp  = uif_tx.mon_cb.i_ptp_fp[(8*seg_select) +: 8];
       
         for(int i=0; i<m_config.fp_width ; i++)begin
            m_tran.i_ptp_tx_fp[i]  = uif_tx.mon_cb.i_ptp_fp[seg_select*m_config.fp_width+i];
         end
         
         m_tran.asym_p2p_idx = uif_tx.mon_cb.i_ptp_asym_p2p_idx[(7*seg_select) +: 7];
         m_tran.asym_sign    = uif_tx.mon_cb.i_ptp_asym_sign[seg_select];
         

        
        /* if(mon_ptp_val inside {INS_NOOP,
            INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB,INS_V1_W_ASYM_LAT,INS_V1_W_ASYM_LAT_UDP_CS_0,INS_V1_W_ASYM_LAT_EB,
            INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,
            INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB,
            INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,                
            INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,INS_2STEP})
            ptp_kind = PTP_NORMAL;
         else 
            ptp_kind = PTP_ERR; */
         if (uif_tx.mon_cb.i_ptp_error[seg_select]) 
             ptp_kind = PTP_ERR; 
         else
          ptp_kind = PTP_NORMAL;
       
         m_tran.m_ptp_kind = ptp_kind;
       
      end else begin
         mon_ptp_val[7]  = uif_tx.mon_cb.i_ptp_p2p;      
         mon_ptp_val[6]  = uif_tx.mon_cb.i_ptp_ts_format;
         mon_ptp_val[5]  = uif_tx.mon_cb.i_ptp_ts_req;
         mon_ptp_val[4]  = uif_tx.mon_cb.i_ptp_ins_ets;
         mon_ptp_val[3]  = uif_tx.mon_cb.i_ptp_ins_cf;
         mon_ptp_val[2]  = uif_tx.mon_cb.i_ptp_0csum;
         mon_ptp_val[1]  = uif_tx.mon_cb.i_ptp_update_eb;
         mon_ptp_val[0]  = uif_tx.mon_cb.i_ptp_asym;

         m_tran.m_ptp_op     = mon_ptp_val; 
         m_tran.ptp_offset[15:0]   = uif_tx.mon_cb.i_ptp_ts_offset;
         m_tran.cf_offset[15:0]    = uif_tx.mon_cb.i_ptp_cf_offset;
         if(uif_tx.mon_cb.i_ptp_0csum) m_tran.cs_offset[15:0]    = uif_tx.mon_cb.i_ptp_csum_offset;
         if(uif_tx.mon_cb.i_ptp_update_eb) m_tran.cs_offset[15:0]    = uif_tx.mon_cb.i_ptp_csum_offset;
         m_tran.ingress_ts[95:0]   = uif_tx.mon_cb.i_ptp_tx_its;
         //m_tran.i_ptp_tx_fp[7:0]   = uif_tx.mon_cb.i_ptp_fp;

         for(int i=0; i<m_config.fp_width ; i++)begin
            m_tran.i_ptp_tx_fp[i]  = uif_tx.mon_cb.i_ptp_fp[i];
         end
         
         //m_tran.asym_p2p_idx[6:0]  = uif_tx.mon_cb.i_ptp_asym_p2p_idx[6:0];
         m_tran.asym_p2p_idx       = uif_tx.mon_cb.i_ptp_asym_p2p_idx;
         m_tran.asym_sign[0]       = uif_tx.mon_cb.i_ptp_asym_sign[0];

        /* if(mon_ptp_val inside {INS_NOOP,
            INS_V1,INS_V1_W_UDP_CS_0,INS_V1_W_EB,INS_V1_W_ASYM_LAT,INS_V1_W_ASYM_LAT_UDP_CS_0,INS_V1_W_ASYM_LAT_EB,
            INS_V2,INS_V2_W_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,
            INS_CF,INS_CF_W_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB,
            INS_P2P,INS_P2P_W_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,                
            INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,INS_2STEP})
            ptp_kind = PTP_NORMAL;
         else 
            ptp_kind = PTP_ERR;*/
          if (uif_tx.mon_cb.i_ptp_error[0]) 
             ptp_kind = PTP_ERR; 
         else
          ptp_kind = PTP_NORMAL;

       
         m_tran.m_ptp_kind = ptp_kind;

      end // !_400G speed


//       if (uif_tx.ptp_tx_tod[31:16] inside {['hFFFE : 'hFFFF]} && uif_tx.ptp_tx_tod[32] == 0) //for tx ns rollover coverage
//   begin
//     tx_tod_state = 'b01; 
//   end
//
// else if (uif_tx.ptp_tx_tod[31:16] inside {['h0000 : 'h0002]} && uif_tx.ptp_tx_tod[32] == 1)
//   begin
//     tx_tod_state = 'b10;
//   end
// else
//   begin
//     tx_tod_state = 'b00;
//   end
//
//    if (uif_tx.ptp_rx_tod[31:16] inside {['hFFFE : 'hFFFF]} && uif_tx.ptp_rx_tod[32] == 0) //for rx ns rollover coverage
//   begin
//     rx_tod_state = 'b01; 
//   end
//
// else if (uif_tx.ptp_rx_tod[31:16] inside {['h0000 : 'h0002]} && uif_tx.ptp_rx_tod[32] == 1)
//   begin
//     rx_tod_state = 'b10;
//   end
// else
//   begin
//     rx_tod_state = 'b00;
//   end

  ptp_odd=uif_tx.mon_cb.i_ptp_ts_offset%2;
  cf_odd=uif_tx.mon_cb.i_ptp_cf_offset%2;
  cs_odd=uif_tx.mon_cb.i_ptp_csum_offset%2;

  //tx_vl_num = spy_if.tx_o_vl_ss[0];  //Node 0 for 440G
  //$display("VR debug: tx_vl_num=%0d", tx_vl_num);
 //Temporary put default node first
 tx_vl_num = (m_config.speed==_50G)  ? spy_if.tx_o_vl_ss[7] : 
             (m_config.speed==_100G) ? spy_if.tx_o_vl_ss[3] :
             (m_config.speed==_200G) ? spy_if.tx_o_vl_ss[1] : spy_if.tx_o_vl_ss[0];  
  
 //rx_vl_num = spy_if.tx_o_vl_ss[0];
 // $display("VR debug: rx_vl_num=%0d", rx_vl_num);
 
 rx_vl_num = (m_config.speed==_50G)  ? spy_if.rx_o_vl_ss[7] : 
             (m_config.speed==_100G) ? spy_if.rx_o_vl_ss[3] :
             (m_config.speed==_200G) ? spy_if.rx_o_vl_ss[1] : spy_if.tx_o_vl_ss[0]; 
 
 //for ptp statistics coverage
  //DM_TODO: ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_ptp_pkts_OFFSET_REG,m_config.speed), 1 );
  //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
  //DM_TODO: //ptp_read_data = ptp_reg.get_mirrored_value();
  //DM_TODO: ptp_read_data = ptp_reg.get();
  //DM_TODO: total_ptp_pkts = ptp_read_data;
  //DM_TODO: $display("tot ptp= %0d", total_ptp_pkts);

  //DM_TODO: ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_1step_ptp_pkts_OFFSET_REG,m_config.speed), 1 );
  //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
  //DM_TODO: //ptp_read_data = ptp_reg.get_mirrored_value();
  //DM_TODO: ptp_read_data = ptp_reg.get();
  //DM_TODO: total_1step_pkts = ptp_read_data;
  //DM_TODO: $display("tot ptp= %0d", total_1step_pkts);
 
  //DM_TODO: ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_2step_ptp_pkts_OFFSET_REG,m_config.speed), 1 );
  //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
  //DM_TODO: //ptp_read_data = ptp_reg.get_mirrored_value();
  //DM_TODO: ptp_read_data = ptp_reg.get();
  //DM_TODO: total_2step_pkts = ptp_read_data;
  //DM_TODO: $display("tot ptp= %0d", total_2step_pkts);

  //DM_TODO: ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_tx_total_v2_ptp_pkts_OFFSET_REG,m_config.speed), 1 );
  //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
  //DM_TODO: //ptp_read_data = ptp_reg.get_mirrored_value();
  //DM_TODO: ptp_read_data = ptp_reg.get();
  //DM_TODO: total_v2_pkts = ptp_read_data;
  //DM_TODO: $display("tot ptp= %0d", total_v2_pkts);

  //DM_TODO: ptp_reg = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_stats_cntr_rx_total_ptp_ts_OFFSET_REG,m_config.speed), 1 );
  //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
  //DM_TODO: //ptp_read_data = ptp_reg.get_mirrored_value();
  //DM_TODO: ptp_read_data = ptp_reg.get();
  //DM_TODO: total_ptp_rx_pkts = ptp_read_data;
  //DM_TODO: $display("tot ptp= %0d", total_ptp_rx_pkts);


      
   endtask 

   task driver_concrete::num_words_update(); 
   	num_words  = (m_config.speed == _10G) ? 1: //[TODO] Need to update with actual values
                        (m_config.speed == _25G) ? 1:
                        (m_config.speed == _40G) ? 2:
                        (m_config.speed == _50G) ? 2:
                        (m_config.speed == _100G)? 4:
                        (m_config.speed == _200G)? 8:16;

   endtask
	
   task driver_concrete::gen_rdy_ltny(); 
   	while(1)
   	begin
	   	if(uif_tx.vld_ltny)
	   		uif_tx.ready_latency =  $urandom_range(1,8); 
	   	else 
	   		uif_tx.ready_latency = $urandom_range(11,200); 
	   	@uif_tx.rst_n; 
	end
   endtask 
   
   task driver_concrete::monitor_ready();
   	logic ready[$];
    logic ready_int[$];
    logic ready_val;
   	fork 
   	begin 
   	 	forever begin
   	 		@(uif_tx.mst_cb.rdy); 
       		ready.push_back(uif_tx.mst_cb.rdy);
   	 	end 
   	end 
   	begin 
   	 	forever begin 
   	 		wait(ready.size()>0);
   	 		ready_val=ready.pop_front(); 
   	 		ready_int.push_back(ready_val);
            fork 
            	begin 
		            repeat(uif_tx.ready_latency)begin              
		            	@(uif_tx.mst_cb);
		            end
		            uif_tx.mst_cb.vld <= ready_int.pop_front();
	           	end 
	        join_none	
   	 	end
   	end 
   	join
   endtask : monitor_ready

   task driver_concrete::bfm_drive_idle();
		//Need to check previous cycle the valid is it low. The previous cycle valid is sample using mon_cb.
      //If low then need to wait until 1 to avoid deasserting previous data early
      @(uif_tx.mst_cb);
      while(uif_tx.mon_cb.vld== 0) begin
	      @(uif_tx.mst_cb);
         //`uvm_info(get_type_name(), $sformatf(" bfm_drive_idle waiting vld:%d AT TIME :%t ",uif_tx.vld, $time), UVM_LOW)
      end
      
      for(int i=0; i<num_words; i++) begin
         uif_tx.mst_cb.in_frame[i] <= 'b0;
         uif_tx.mst_cb.data[i] <= 0;
         uif_tx.mst_cb.eop_empty[i] <= 0;
         uif_tx.mst_cb.error[i] <= 0;
         uif_tx.mst_cb.skip_crc[i] <= 0;
      end
        //idle_word_align = ~(idle_word_align);

      //`uvm_info(get_type_name(), $sformatf("bfm_drive_idle vld:%d AT TIME :%t ",uif_tx.vld, $time), UVM_DEBUG)
      while(uif_tx.mon_cb.vld== 0) begin
	      @(uif_tx.mst_cb);
         `uvm_info(get_type_name(), $sformatf(" bfm_drive_idle waiting vld:%d AT TIME :%t ",uif_tx.vld, $time), UVM_DEBUG)
      end
    endtask : bfm_drive_idle

   task driver_concrete::init();
      @(uif_tx.mst_cb);
      `uvm_info(get_type_name(), $sformatf(" AFTER RESET after advancing clk AT TIME :%t ",$time), UVM_NONE)
      for(int i=0; i<num_words; i++) begin
         uif_tx.mst_cb.data[i] <= $urandom();
         uif_tx.mst_cb.in_frame[i] <= '0;
         uif_tx.mst_cb.eop_empty[i] <= $urandom();
         uif_tx.mst_cb.error[i] <= $urandom();
         uif_tx.mst_cb.skip_crc[i] <= $urandom();
         uif_tx.mst_cb.vld <= 1'b0;
         //  uif_tx.mst_cb.o_ptp_ets <= 'h0;
         //  uif_tx.mst_cb.o_ptp_ets_valid <= 'h0;
         //  uif_tx.mst_cb.o_ptp_ets_fp <= 'h0;
         //   uif_tx.mst_cb.o_ptp_rx_its <= 'h0;
         //   uif_tx.mst_cb.o_ptp_ets_vl <= 'h0;
         uif_tx.mst_cb.i_ptp_ts_req <= 'h0;
         uif_tx.mst_cb.i_ptp_fp <= 'h0; 
         uif_tx.mst_cb.i_ptp_ins_ets <= 'h0;
         uif_tx.mst_cb.i_ptp_ins_cf <= 'h0;
         uif_tx.mst_cb.i_ptp_0csum <= 'h0;
         uif_tx.mst_cb.i_ptp_update_eb <= 'h0; 
         //uif_tx.mst_cb.i_ptp_format <= 'h0;
         uif_tx.mst_cb.i_ptp_ts_format <= 'h0;
         uif_tx.mst_cb.i_ptp_ts_offset <= 'h0;
         uif_tx.mst_cb.i_ptp_cf_offset <= 'h0;
         uif_tx.mst_cb.i_ptp_csum_offset <= 'h0;
         uif_tx.mst_cb.i_ptp_tx_its <= 'h0;
         uif_tx.mst_cb.temp_i_ptp_ts_req <= 'h0;     
         uif_tx.mst_cb.temp_i_ptp_ins_ets <= 'h0;          
         uif_tx.mst_cb.temp_i_ptp_ins_cf <= 'h0;          
         uif_tx.mst_cb.temp_i_ptp_0csum <= 'h0;         
         uif_tx.mst_cb.temp_i_ptp_update_eb <= 'h0;        
         uif_tx.mst_cb.temp_i_ptp_ts_format <= 'h0;       
         uif_tx.mst_cb.temp_i_ptp_p2p <= 'h0; //AM        
         uif_tx.mst_cb.temp_i_ptp_asym <= 'h0;//AM         
         uif_tx.mst_cb.temp_i_ptp_asym_sign <= 'h0;//AM         
         uif_tx.mst_cb.temp_i_ptp_ts_offset <= 'h0;     
         uif_tx.mst_cb.temp_i_ptp_cf_offset <= 'h0; 
         uif_tx.mst_cb.temp_i_ptp_csum_offset <= 'h0;
         uif_tx.mst_cb.temp_i_ptp_fp <= 'h0;
         uif_tx.mst_cb.temp_i_ptp_asym_p2p_idx <= 'h0;
         uif_tx.mst_cb.temp_i_ptp_error <= 'h0;
      end


      if (uif_tx.rst_n == 0) 
         @(posedge uif_tx.rst_n); 


      `uvm_info(get_type_name(), $sformatf("AFTER RESET AT TIME :%t ",$time), UVM_LOW)
      bfm_drive_idle();

      //loopback case
      //Wait for dsk_done, blk_lock, am_lock
      `ifndef ENABLE_ETH_VIP
        if(uif_tx.mst_cb.rx_pcs_fully_aligned !== 1) begin
             while (uif_tx.mst_cb.rx_pcs_fully_aligned !== 1)begin
               @(uif_tx.mst_cb);
               bfm_drive_idle();
             end
        end
       `endif
        
   endtask : init


   task driver_concrete::drive_interm_idle(); 
   	if(last_frame_end!=-1) //drive leftover segments at current cycle to 0 before moving on to the second packet(null)
	   begin
	     for(int i=last_frame_end+1;i<num_words; i++) begin
	        uif_tx.mst_cb.in_frame[i] <= 'b0;
	        uif_tx.mst_cb.data[i] <= 0;
	        uif_tx.mst_cb.eop_empty[i] <= 0;
	        uif_tx.mst_cb.error[i] <= 0;
	        uif_tx.mst_cb.skip_crc[i]<= 0;
	      end
	      last_frame_end=-1;
	   end
	   bfm_drive_idle();
       first_frame=1;
   endtask  

   task driver_concrete::bfm_drive_tran(eth_packet _tran);
        eth_packet driver_tran;
        string func_name = "bfm_drive_tran"; 
        bit pp_tx,pp_rx,txcrc_cover_preamble,rxcrc_cover_preamble,covers_preamble; 

        driver_tran = eth_packet ::type_id::create("driver_tran");
        driver_tran.copy(_tran);
        //cp_driver_tran_to_output(_tran);

        `uvm_info(get_type_name(), $sformatf("bfm_drive_tran extra_short_frame:%d, driver_tran.payload.size() :%d at time:%t",driver_tran.extra_short_frame, driver_tran.payload.size(), $time), UVM_NONE)
        //`uvm_info("e4hip_driver_concrete_bfm", $sformatf("driving frame: \n %0s",driver_tran.sprint(printer)), UVM_MEDIUM)
        `uvm_info(get_type_name(), $sformatf("driving frame: \n %0s",driver_tran.sprint()), UVM_NONE)

        //Get values of cfg settings
        `uvm_info(get_type_name(), $sformatf("m_config.preamble_passthrough:%h", m_config.preamble_passthrough), UVM_MEDIUM)
        //DM_TODO:  regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_txmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
   		//DM_TODO: read_data = regs.get();
   		//DM_TODO: pp_tx = read_data[0]; // pp on DUT TX 
   		//DM_TODO: txcrc_cover_preamble = read_data[9]; 
   		//DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
   		//DM_TODO: read_data=regs.get();
   		pp_rx= read_data[0]; // pp on DUT RX 
   		rxcrc_cover_preamble= read_data[1];
   		covers_preamble=rxcrc_cover_preamble&&txcrc_cover_preamble&&pp_tx&&pp_rx; // determines if preamble should be included in CRC calculation. 

         `uvm_info(get_full_name(), $sformatf("Preamble_passthrough %b, TXCRC cover preamble %0b",pp_tx,txcrc_cover_preamble), UVM_LOW)

         driver_tran.seg_pack_bytes(driver_tran.skip_tx_crc_insertion,pp_tx,covers_preamble);
        
        //`uvm_info("e4hip_driver_concrete_bfm", $sformatf("after packing, driving frame: \n %0s",driver_tran.sprint()), UVM_MEDIUM)

       // m_config.frm_cnt++;

         fork // to make sure only fork threads in this scope get disabled
        	begin 
		        fork: reset_or_drive
		          begin
		           drive_custom_interface(driver_tran);
		          end
		          begin
		           forever begin
			  	       if (uif_tx.rst_n == 0 ) break;
			  	       @(posedge uif_tx.clk) ;
			         end
		          end
		        join_any
		        #0;
		        disable fork ;
		   end
         join

         if (uif_tx.rst_n == 0 )begin
            for(int i=0; i<num_words; i++) uif_tx.mst_cb.in_frame[i] <= 'b0;
            first_frame = 1;
            //@(posedge uif_tx.clk) ;
            packed_words.delete();
         end

      endtask : bfm_drive_tran
      
      //Function to generate non-zero unique FP for PTP
      function int unsigned driver_concrete::get_seg_fp_randc();
         bit succ =0; 
         while(!succ) begin
            succ =  std::randomize(randc_fp) with 
                  {  foreach (randc_fp[i]){            
                        if(i>(m_config.fp_width-1)){
                           randc_fp[i]==0;                  
                        }
                     }
                     randc_fp!=0;   
                     unique {randc_fp,fp_q};};
         end  
         
         //If success push to queue
         fp_q.push_back(randc_fp);
         
         //Reset the queue if the size reach max
         if(fp_q.size() == ((2**m_config.fp_width)-1)) begin //minus 1 because value 0 is remove from the list
            `uvm_info("SegTX", "Reset fp_q",UVM_LOW)
            fp_q.delete();
         end
         
         `uvm_info(get_full_name(), $sformatf("SegTX: FP generated is = %0h",randc_fp), UVM_MEDIUM)
         
         return randc_fp;
      endfunction: get_seg_fp_randc
      
      //To select whether the seg signal is use for upper or lower (PTP)
      //only for 400G
      function bit driver_concrete::select_upper_lower(int _sop_pos);
         if(_sop_pos>=8 && _sop_pos<=15)begin
            return 1;
         end else begin
            return 0;
         end
      endfunction: select_upper_lower

      task driver_concrete::drive_custom_interface(eth_packet _tran);
      	int start_location,i,j;
      	int no_cycles=0;
         int sop_pos;
         bit seg_select;

      	if(first_frame==1)
	    	begin
	    		if(_tran.bus_rate==MODERATE)  
	    			no_cycles= $urandom_range(0,6); //bfm_Drive_idle adds a clk cycle in drive_bfm_interm task & hence 0 
	    		else if(_tran.bus_rate==FREE) 
	    			no_cycles= $urandom_range(7,15); 
	    		repeat(no_cycles) 
	    			@(uif_tx.mst_cb);
	        	start_location = $urandom_range(0,num_words-1);
	      	`uvm_info(get_type_name(), $sformatf("last_frame_end %0d start_location:%0d at no_of_idle_words need to be inserted in queue %0d", last_frame_end, start_location, no_cycles), UVM_NONE)
	      	repeat(start_location) begin
	        		packed_words.push_back(64'h0);
	      	end
	      end
         
         pack_words(_tran);
         //->packwords_first;
         i=last_frame_end+1;
         `uvm_info(get_type_name(), $sformatf("TX driver packed_words.size = %0d",packed_words.size), UVM_NONE)
         foreach(packed_words[i])begin
            `uvm_info(get_type_name(), $sformatf("TX driver packed_words[%0d] = %0h packed_words.size = %0d -- 1",i,packed_words[i],packed_words.size()), UVM_HIGH)
         end
         
         while(packed_words.size() >1)
         begin
            if(i==0)
            begin
               @uif_tx.mst_cb;
               `uvm_info(get_type_name(), $sformatf("TX driver checking valid -- 1"), UVM_HIGH)   
               while(!uif_tx.vld)begin
                  @uif_tx.mst_cb;
               end  
               for(int i=0;i<num_words; i++) begin // to make sure that eop_empty is driven 0's for a new cycle. 
	        		uif_tx.mst_cb.eop_empty[i]<=0;
	        		uif_tx.mst_cb.skip_crc[i]<=0;
	        	end                
            end
            
            for(int i=0;i<num_words && packed_words.size()>1;i++)
            begin 
               if(first_frame==1)
               begin
                  repeat(start_location)
                  begin
                     uif_tx.mst_cb.in_frame[i] <=0; 
                     uif_tx.mst_cb.data[i]<=packed_words.pop_front();
                     i++; 
               //		j--;
                  end
                  first_frame=0; 
                  last_byte_flag = 1;
                  `uvm_info(get_type_name(), $sformatf("TX driver asserting last_byte_flag -- 1"), UVM_NONE)
               end
               
               uif_tx.mst_cb.in_frame[i] <=1; 
               uif_tx.mst_cb.data[i]<=packed_words.pop_front();
               uif_tx.mst_cb.skip_crc[i]<=_tran.skip_tx_crc_insertion; //Skip CRC insertion should be driven for entire packet
               
               if(last_byte_flag == 1)begin
                  last_byte_flag = 0; //reset
                  `uvm_info(get_type_name(), $sformatf("TX driver deasserting last_byte_flag"), UVM_NONE)
                  sop_pos = i;
                  `uvm_info(get_type_name(), $sformatf("TX driver sop_pos is %0d",sop_pos), UVM_NONE)
                  
                  //Qualify with ptp==1 so that it dont get randomised accidentally and cause constraint issue
                  //temp_fp will be all 0 for non ptp
                  if(m_config.ptp == 1)begin
                     temp_fp = get_seg_fp_randc();
                  end
               end

               seg_select = select_upper_lower(sop_pos);
               `uvm_info(get_type_name(), $sformatf("TX driver seg_select is %0d",seg_select), UVM_HIGH)
               //if(_tran.is_ptp_seq == 1) begin //Remove so that when non ptp /packet comes it will also update the value
                  `uvm_info(get_type_name(), $sformatf("TX driver driving ptp signals"), UVM_HIGH)
                  //The real driving path will be taking care in seg_tx_if
                  //For 400G need to duplicate to upper and lower
                  if(m_config.speed == _400G)begin
                     uif_tx.mst_cb.temp_i_ptp_ts_req[seg_select]                 <= _tran.m_ptp_op[5];
                     uif_tx.mst_cb.temp_i_ptp_ins_ets[seg_select]                <= _tran.m_ptp_op[4];
                     uif_tx.mst_cb.temp_i_ptp_ins_cf[seg_select]                 <= _tran.m_ptp_op[3];
                     uif_tx.mst_cb.temp_i_ptp_0csum[seg_select]                  <= _tran.m_ptp_op[2];
                     uif_tx.mst_cb.temp_i_ptp_update_eb[seg_select]              <= _tran.m_ptp_op[1];   
                     uif_tx.mst_cb.temp_i_ptp_ts_format[seg_select]              <= _tran.m_ptp_op[6];
                     uif_tx.mst_cb.temp_i_ptp_p2p[seg_select]                    <= _tran.m_ptp_op[7];
                     uif_tx.mst_cb.temp_i_ptp_asym[seg_select]                   <= _tran.m_ptp_op[0];
                     uif_tx.mst_cb.temp_i_ptp_ts_offset[(16*seg_select) +: 16]   <= _tran.ptp_offset[15:0];   
                     uif_tx.mst_cb.temp_i_ptp_cf_offset[(16*seg_select) +: 16]   <= _tran.cf_offset[15:0];
                     uif_tx.mst_cb.temp_i_ptp_csum_offset[(16*seg_select) +: 16] <= _tran.cs_offset[15:0];//works as eb too   

                     for(int i=0; i<m_config.fp_width ; i++)begin
                        uif_tx.mst_cb.temp_i_ptp_fp[seg_select*m_config.fp_width+i] <= temp_fp[i]; //_tran.i_ptp_tx_fp[i];
                     end
                     
                     uif_tx.mst_cb.temp_i_ptp_asym_sign[seg_select]              <= _tran.asym_sign;
                     uif_tx.mst_cb.temp_i_ptp_asym_p2p_idx[(7*seg_select) +: 7]  <= _tran.asym_p2p_idx;
                     uif_tx.mst_cb.temp_i_ptp_error[seg_select]                  <= _tran.m_ptp_kind;
                  end else begin
                     uif_tx.mst_cb.temp_i_ptp_ts_req       <= _tran.m_ptp_op[5];
                     uif_tx.mst_cb.temp_i_ptp_ins_ets      <= _tran.m_ptp_op[4];
                     uif_tx.mst_cb.temp_i_ptp_ins_cf       <= _tran.m_ptp_op[3];
                     uif_tx.mst_cb.temp_i_ptp_0csum        <= _tran.m_ptp_op[2];
                     uif_tx.mst_cb.temp_i_ptp_update_eb    <= _tran.m_ptp_op[1];   
                     uif_tx.mst_cb.temp_i_ptp_ts_format    <= _tran.m_ptp_op[6];
                     uif_tx.mst_cb.temp_i_ptp_p2p          <= _tran.m_ptp_op[7];
                     uif_tx.mst_cb.temp_i_ptp_asym         <= _tran.m_ptp_op[0];
                     uif_tx.mst_cb.temp_i_ptp_ts_offset    <= _tran.ptp_offset[15:0];   
                     uif_tx.mst_cb.temp_i_ptp_cf_offset    <= _tran.cf_offset[15:0];   
                     uif_tx.mst_cb.temp_i_ptp_csum_offset  <= _tran.cs_offset[15:0];//works as eb too    

                     for(int i=0; i<m_config.fp_width ; i++)begin
                        uif_tx.mst_cb.temp_i_ptp_fp[i]     <= temp_fp[i]; //_tran.i_ptp_tx_fp[i];
                     end
                     
                     uif_tx.mst_cb.temp_i_ptp_asym_sign    <= _tran.asym_sign;                     
                     uif_tx.mst_cb.temp_i_ptp_asym_p2p_idx <= _tran.asym_p2p_idx;                  
                     uif_tx.mst_cb.temp_i_ptp_error        <= _tran.m_ptp_kind;

                  end
               //end
            end
            
            //If reach max segment then reset the segment pointer
            if(i>=num_words)
            begin
               i=0;
            end

         end
         
         foreach(packed_words[i])begin
            `uvm_info(get_type_name(), $sformatf("TX driver packed_words[%0d] = %0h -- 2",i,packed_words[i]), UVM_NONE)
         end
          
         //If packed_words is the last element, need to drive the previous cycle 1 clock based on valid == 1
         if(i==0)
         begin
            @uif_tx.mst_cb;
            `uvm_info(get_type_name(), $sformatf("TX driver checking valid -- 2"), UVM_NONE)             
            while(!uif_tx.vld)begin
               @uif_tx.mst_cb;
            end
         end
         //last segment 
         uif_tx.mst_cb.in_frame[i] <=0;
         uif_tx.mst_cb.data[i]<=packed_words.pop_front();
   		 uif_tx.mst_cb.eop_empty[i]<=(8-this.packed_words_last_valid_bytes);
   		 uif_tx.mst_cb.skip_crc[i]<=_tran.skip_tx_crc_insertion;
         last_byte_flag = 1;
         `uvm_info(get_type_name(), $sformatf("TX driver asserting last_byte_flag -- 2"), UVM_NONE)		
         
         uif_tx.mst_cb.error[i]<=_tran.tx_error_insertion;
         if(i==num_words-1)
            last_frame_end=-1;
         else
            last_frame_end=i;
         `uvm_info(get_type_name(), $sformatf("TX driver last_frame_end at segment %0d",last_frame_end), UVM_NONE)   

      endtask :drive_custom_interface

      task driver_concrete::pack_words(eth_packet _tran);
      	int valid_bytes=8;
      	logic[7:0] byte_value[8];
      	int pack_size;
      	pack_size=_tran.seg_packed_bytes.size();
      	{>>{byte_value}}=_tran.seg_packed_bytes[pack_size-1];
  
     foreach(_tran.seg_packed_bytes[i])begin
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function _tran.seg_packed_bytes[%0d] = %0h ,_tran.seg_packed_bytes_size = %d -- 1",i,_tran.seg_packed_bytes[i],_tran.seg_packed_bytes.size()), UVM_HIGH)
   end
 

      	foreach(byte_value[i])
         begin
            if(byte_value[i]===8'hx)
               valid_bytes--;
            else 
               break; 
         end
         this.packed_words_last_valid_bytes=valid_bytes;
         valid_bytes=8;
       	$display("driver_concrete,%t, last_valid_bytes is %d",$time,this.packed_words_last_valid_bytes);
         foreach(_tran.seg_packed_bytes[i]) begin
       		this.packed_words.push_back(_tran.seg_packed_bytes[i]);
                `uvm_info(get_type_name(), $sformatf("Inside tx_driver function packed_words[%d] = %h-- 2",i,packed_words[i]), UVM_HIGH)
         end
      endtask // pack_words
   
   //Create an object of concrete class & place it in config db. 
   driver_concrete conc_obj_driver; 
   monitor_concrete conc_obj_monitor;
   initial begin 
   	conc_obj_driver = new(); 
   	conc_obj_monitor = new();
   	uvm_config_db #(seg_tx_driver_abstract)::set(null,$sformatf("%m"),"CONCRETE_DRIVER",conc_obj_driver); 
   	uvm_config_db #(seg_tx_monitor_abstract)::set(null,$sformatf("%m"),"CONCRETE_MONITOR",conc_obj_monitor); 
   end 




endmodule 
