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



`ifndef ETH_PACKET__SV
`define ETH_PACKET__SV
//Class : eth_packet
//This is layer agent transaction class
//Variable : enum
  typedef enum {LOW,HEAVY} congestion;
  typedef enum {LESS,EQUAL,MORE} duration;  //less than,equal to or more than pause quanta

//`include "params.sv"
//`include "basic_test_params.v"
class eth_packet extends uvm_sequence_item;
 uvm_cmdline_processor  inst;
 string m_sequence = "vip_sanity_sequence";   
 // rand ptp_constraint_base 
  bit speed_400G;
 
  bit ignore_pkt;
  bit expect_response;
  bit [16:0] fc_mode;
  bit pause;
  // This bit is set from sequence and it has to hold same value across all components
  static bit sip_limit_test;
  static bit sip_limit_info_per_pkt_pack_bytes[$];
  static bit sip_limit_info_per_pkt_unpack_bytes[$];
  static bit sip_limit_info_per_pkt_seg_pack[$];
  static bit sip_limit_info_per_pkt_seg_unpack[$];
//  bit pfc;
  rand int no_fc_frames;
  bit [15:0] xoff_width[9];

  rand congestion cong_type;
  rand duration width_type;
//This field represents frame type
  rand eth_transaction_frame_type frame_type;
  rand int num_words=1;

//Variable : bit
//This field represents preamble
  rand bit [63:0] preamble     = 'hFB555555555555D5;

//Variable : bit
//This field represents destination address
  rand bit [47:0] dest_address = 'hD0D1D2D3_D4D5;

//Variable : bit
//This field represents source address
  rand bit [47:0] src_address  = 'hF0F1F2F3_F4F5;

//Variable : bit
//This field represents length or type
  rand bit [15:0] eth_type_or_length=64;

//Variable : bit
//This field represents SFC pause_quanta
  rand bit [15:0] sfc_pause_quanta;

//Variable : bit
//This field represents PFC class enable vector
  rand bit [7:0] pfc_class_en_vect[2];

//Variable : bit
//This field represents PFC pause_quanta
  rand bit [15:0] pfc_pause_quanta[8];

//Variable : array
//This field represents payload
  rand bit [7:0]  payload[];
  rand payload_type payload_typ;

//Variable : bit
//This field represents crc
  rand bit [31:0] fcs  = 32'h0;
  rand bit skip_tx_crc_insertion ;

//Variable : bit
//This field represents vlan_tag
  rand bit [31:0] vlan_tag=8100;

//Variable : bit
//This field represents stacked_vlan_tag
  rand bit [31:0] stacked_vlan_tag=8100;

//Variable : bit
//This field represents payload size type either normal or undersize
  rand frame_payload_size frame_payload_type=NORMAL;

//Variable : bit
//This field represents interpacket gap
  rand bit[31:0] interpacket_gap=0;
  rand bit       ipg_idle_ins_en;

//Variable : bit
//This field represents errouneous packet
  bit malformed_packet =0;
  rand bit [31:0]packet_size;   
    
//Variable : bit
//This field represents error insertion in fcs
   bit tx_fcs_error_insertion;
   bit tx_error_insertion;
   bit seen_tx_fcs_error_insertion;
   bit seen_rx_fcs_error_insertion;
   bit seen_tx_error_insertion;
   bit seen_len_err_with_pad_removal;
   bit underflow_condition;
//Represents how busy seg BFM bus is 
   rand seg_bus bus_rate=BUSY; 
//Variable : bit
// These field represent local fields
  bit[7:0] packed_bytes[];
  bit[7:0] l_packed_bytes[];
 bit [7:0] l_packed_bytes1[]; 
  logic[63:0] l_seg_packed_bytes[];
  logic[63:0] seg_packed_bytes[];
  logic[7:0] temp_seg_packed_bytes[];

  bit [31:0] transaction_id=0;
  bit [31:0] pause_transaction_id=0;
  //For tracker
  time start_time;
  time end_time;
  int timeDivisor; 

// Variable: bit
// This field represents rx error vector
  bit [5:0] rx_error;

//Indicates extra_short_frame for special unpack
  bit extra_short_frame;
  int extra_short_frame_size;

   // start offset in bytes
   longint start_offset_bytes;
 
 int fc_queues; 
 int empty_bytes=0;

 //PTP related variables
   rand bit is_ptp_seq;
   rand ptp_op_e m_ptp_op;
   rand ptp_kind_e m_ptp_kind;
  // rand bit [7:0] i_ptp_tx_fp;
  // rand bit [95:0] ingress_ts;
   //rand bit[15:0] ptp_offset;
   //rand bit[15:0] cf_offset;
   //rand bit[15:0] cs_offset;

   //rand bit [15:0] i_ptp_tx_fp;
   rand bit [31:0] i_ptp_tx_fp; //set to max
   rand bit [191:0] ingress_ts; //obselete to be removed. already driven by TOD driver using sim time
   rand bit[31:0] ptp_offset;
   rand bit[31:0] cf_offset;
   rand bit[31:0] cs_offset;

   bit[79:0] original_bytes;
   bit[63:0] original_cf_bytes;
   bit[15:0] original_cs_bytes;
   integer ptp_offset_word_counter;
   integer cf_offset_word_counter;
   integer cs_offset_word_counter;
   bit [7:0] fixed_payload;
   static int seq_id;
   bit ptp_opcodes_rand_en;
   rand bit ptp_ff_offsets_rand_en;
   rand bit ptp_ff_even_offsets; 
   rand bit ptp_ff_odd_offsets; 
   bit ptp_pp_en;
   rand bit [3:0]  preamble_offset;
	 rand bit [3:0]  eop_bytes;
   rand bit asym_sign;
   rand bit [6:0] asym_p2p_idx;
	 rand bit is_vlan_f;
	 rand bit is_svlan_f;
    
   typedef logic[7:0] temp_seg_bytes_t[$];
   bit[6:0] rx_mac_error;



  `uvm_object_utils_begin(eth_packet)
    `uvm_field_enum(eth_transaction_frame_type,frame_type,UVM_ALL_ON)
    `uvm_field_enum(frame_payload_size,frame_payload_type,UVM_ALL_ON)
    `uvm_field_int(is_ptp_seq,UVM_ALL_ON)
    `uvm_field_enum(ptp_op_e, m_ptp_op, UVM_ALL_ON)
    `uvm_field_int(preamble,UVM_ALL_ON)
    `uvm_field_int(dest_address,UVM_ALL_ON)
    `uvm_field_int(src_address,UVM_ALL_ON)
    `uvm_field_int(eth_type_or_length,UVM_ALL_ON);
    `uvm_field_int(vlan_tag,UVM_ALL_ON);
    `uvm_field_int(stacked_vlan_tag,UVM_ALL_ON);
    `uvm_field_int(ignore_pkt,UVM_ALL_ON);
    `uvm_field_array_int(payload,UVM_ALL_ON)
    `uvm_field_int(fcs, UVM_ALL_ON)
    `uvm_field_int(empty_bytes, UVM_ALL_ON)
    `uvm_field_int(sip_limit_test,UVM_ALL_ON)
    `uvm_field_int(tx_error_insertion, UVM_ALL_ON)
    `uvm_field_int(skip_tx_crc_insertion, UVM_ALL_ON)
    `uvm_field_int(tx_fcs_error_insertion, UVM_ALL_ON)
    `uvm_field_int(seen_tx_error_insertion, UVM_ALL_ON)
    `uvm_field_int(seen_tx_fcs_error_insertion, UVM_ALL_ON)
    `uvm_field_int(seen_rx_fcs_error_insertion, UVM_ALL_ON)
    `uvm_field_int(seen_len_err_with_pad_removal, UVM_ALL_ON)
    `uvm_field_int(underflow_condition, UVM_ALL_ON)
    `uvm_field_int(rx_mac_error, UVM_ALL_ON)
    `uvm_field_int(interpacket_gap, UVM_ALL_ON)
    `uvm_field_int(ipg_idle_ins_en, UVM_ALL_ON)
    `uvm_field_int(transaction_id, UVM_ALL_ON)
    `uvm_field_int(rx_error, UVM_ALL_ON)
    `uvm_field_int(extra_short_frame, UVM_ALL_ON)
    `uvm_field_int(extra_short_frame_size, UVM_ALL_ON)
    `uvm_field_int(is_ptp_seq,UVM_ALL_ON)
    `uvm_field_enum(ptp_op_e, m_ptp_op, UVM_ALL_ON)
    `uvm_field_enum(seg_bus,bus_rate,UVM_ALL_ON)
    `uvm_field_enum(ptp_kind_e, m_ptp_kind, UVM_ALL_ON)
    `uvm_field_int(i_ptp_tx_fp, UVM_ALL_ON)
    `uvm_field_int(ingress_ts,UVM_ALL_ON)
    `uvm_field_int(ptp_offset,UVM_ALL_ON)
    `uvm_field_int(cf_offset,UVM_ALL_ON)
    `uvm_field_int(cs_offset,UVM_ALL_ON)
    `uvm_field_int(original_bytes,UVM_ALL_ON)
    `uvm_field_int(original_cs_bytes,UVM_ALL_ON)
    `uvm_field_int(original_cf_bytes,UVM_ALL_ON)
    `uvm_field_int(asym_sign,UVM_ALL_ON)
    `uvm_field_int(asym_p2p_idx,UVM_ALL_ON)

    `uvm_field_int(ptp_offset_word_counter,UVM_ALL_ON)
    `uvm_field_int(cf_offset_word_counter,UVM_ALL_ON)
    `uvm_field_int(cs_offset_word_counter,UVM_ALL_ON)
    `uvm_field_int(fixed_payload,UVM_ALL_ON)
    `uvm_field_int(start_time,UVM_ALL_ON)
    `uvm_field_int(end_time,UVM_ALL_ON) 
    `uvm_field_int(seq_id,UVM_ALL_ON)
    `uvm_field_int(ptp_opcodes_rand_en, UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(no_fc_frames,UVM_ALL_ON)
    `uvm_field_enum(congestion, cong_type,UVM_ALL_ON)
    `uvm_field_enum(duration,width_type,UVM_ALL_ON)
    `uvm_field_int(start_offset_bytes,UVM_ALL_ON)
    `uvm_field_array_int(packed_bytes,UVM_ALL_ON)
    `uvm_field_array_int(seg_packed_bytes,UVM_ALL_ON)
    `uvm_field_int(is_vlan_f,UVM_ALL_ON) 
    `uvm_field_int(is_svlan_f,UVM_ALL_ON)     
    `uvm_field_int(ptp_ff_offsets_rand_en,UVM_ALL_ON)     
    `uvm_field_int(preamble_offset,UVM_ALL_ON)     
   `uvm_object_utils_end

   function new(string name = "eth_packet");
      super.new(name);
        inst = uvm_cmdline_processor::get_inst();
  	inst.get_arg_value("+m_sequence=",m_sequence);
  	`uvm_info("eth_gdr_base_test", $psprintf("sequnce set from commnad line is %0s",m_sequence),UVM_NONE);
   endfunction : new

//constraints

//Begin PTP ones
constraint ptp_sig_width {
 if (speed_400G != 1)
   cf_offset    <= 16'hFFFF;
   cs_offset    <= 16'hFFFF;
   //i_ptp_tx_fp  <= 8'hFF;
   i_ptp_tx_fp  <= 32'hFFFF_FFFF; //set to max
   ingress_ts   <= 96'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF;  
   ptp_offset   <= 16'hFFFF;
 
}
constraint ptp_idx_c {
    asym_p2p_idx inside {[0:127]};  
}

constraint ptp_common_c {
   // Specify the order of the PTP
   solve is_ptp_seq before m_ptp_kind, m_ptp_op, ptp_offset, cf_offset, cs_offset;
   solve m_ptp_kind before m_ptp_op, ptp_offset, cf_offset, cs_offset;
   solve m_ptp_op before ptp_offset, cf_offset, cs_offset;
}

constraint is_ptp_seq_constraint {
	 soft is_ptp_seq == 0;
}

constraint ptp_kind_c {
	soft m_ptp_kind == PTP_NORMAL;
}

constraint ptp_ff_offsets_rand_en_c {
	 soft ptp_ff_offsets_rand_en == 1;
}

constraint ptp_ops_c {
	 if ((m_ptp_kind == PTP_NORMAL) && is_ptp_seq) {
        m_ptp_op inside {INS_NOOP,INS_V1,INS_V1_W_ASYM_LAT,INS_V1_W_UDP_CS_0,INS_V1_W_ASYM_LAT_UDP_CS_0,INS_V1_W_EB,INS_V1_W_ASYM_LAT_EB,
                                  INS_V2,INS_V2_W_ASYM_LAT,INS_V2_W_UDP_CS_0,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_EB,INS_V2_W_ASYM_LAT_EB,
                                  INS_CF,INS_CF_W_ASYM_LAT,INS_CF_W_UDP_CS_0,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_EB,INS_CF_W_ASYM_LAT_EB,
                                  INS_P2P,INS_P2P_W_ASYM_LAT,INS_P2P_W_UDP_CS_0,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_EB,INS_P2P_W_ASYM_LAT_EB,
                                  INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB,
                         INS_2STEP}; 
   }
}

constraint ptp_ff_offsets_rules_c{

   solve payload.size() before ptp_offset, cf_offset, cs_offset;
   solve preamble_offset before ptp_offset, cf_offset, cs_offset;
   solve ptp_ff_offsets_rand_en before ptp_offset, cf_offset, cs_offset;
   solve is_vlan_f before ptp_offset, cf_offset, cs_offset;
   solve is_svlan_f before ptp_offset, cf_offset, cs_offset;

   if (is_ptp_seq && m_ptp_kind== PTP_NORMAL) {

      if (ptp_ff_offsets_rand_en) {

         // lower range max is picked so lower header types will have a gap
         if(ptp_pp_en == 0) {
            cf_offset!=23;
            ! (ptp_offset inside { [21:23] });
         }
   
         ptp_offset >= 20 + preamble_offset+ this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8;
         cf_offset  >= 22 + preamble_offset+ this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8;
         cs_offset  >= 24 + preamble_offset+ this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8;
				 
         // upper range         ########## UPPER LIMIT ##################

         if((m_ptp_op == INS_V2) || (m_ptp_op == INS_V2_W_ASYM_LAT)|| (m_ptp_op == INS_V2_W_UDP_CS_0) ||(m_ptp_op == INS_V2_W_ASYM_LAT_UDP_CS_0))
             ptp_offset <= ((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - 10);
         else if((m_ptp_op == INS_V2_W_EB) || (m_ptp_op == INS_V2_W_ASYM_LAT_EB))
             ptp_offset <= ((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - 10 - 2);
         
         if ((m_ptp_op == INS_V2_W_EB) ||(m_ptp_op == INS_P2P_W_EB) || (m_ptp_op == INS_CF_W_ASYM_LAT_EB)|| (m_ptp_op == INS_P2P_W_ASYM_LAT_EB) || (m_ptp_op == INS_ASYM_LAT_EB)) 
            cf_offset <=  ((payload.size() + 14 +  preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - 8 -2);
         else
            cf_offset <=  ((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - 8);

         if (((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8)%8) == 0) {
            eop_bytes == 8;
         } else {                                                                                                             
            eop_bytes == (payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8)%8;
         }


         if ((m_ptp_op == INS_V2_W_EB) || (m_ptp_op == INS_V2_W_ASYM_LAT_EB) || 
            (m_ptp_op == INS_CF_W_EB) || (m_ptp_op == INS_CF_W_ASYM_LAT_EB) ||
            (m_ptp_op == INS_P2P_W_EB) || (m_ptp_op == INS_P2P_W_ASYM_LAT_EB) ||
            (m_ptp_op == INS_ASYM_LAT_EB)) {
						
            //cs_offset == ((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - eop_bytes - 2); //EB always at last 2 bytes of packet
            cs_offset == ((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - 2); //EB always at last 2 bytes of packet
         } else {
            cs_offset <=  ((payload.size() + 14 + preamble_offset + this.is_vlan_f*4 + !this.is_vlan_f*this.is_svlan_f*8) - eop_bytes - 2);
         }
         

         // non overlapping
         ptp_offset != cf_offset;
         ptp_offset != cs_offset;
         cf_offset  != cs_offset;

         if (ptp_offset > cf_offset) {
            if ((m_ptp_op == INS_V2) || (m_ptp_op == INS_V2_W_ASYM_LAT) || (m_ptp_op == INS_V2_W_UDP_CS_0) || 
                (m_ptp_op == INS_V2_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op == INS_V2_W_EB) || (m_ptp_op == INS_V2_W_ASYM_LAT_EB)) {
            ptp_offset >= (cf_offset + 10);
            cf_offset  <= (ptp_offset -10);
               cs_offset  >= (ptp_offset + 10);
            }
            else {
            ptp_offset >= (cf_offset + 8);
            cf_offset  <= (ptp_offset - 8);
               cs_offset  >= (ptp_offset + 8);
            }
         }

         if (cf_offset > ptp_offset) {
            if ((m_ptp_op == INS_V2) || (m_ptp_op == INS_V2_W_ASYM_LAT) || (m_ptp_op == INS_V2_W_UDP_CS_0) || 
                (m_ptp_op == INS_V2_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op == INS_V2_W_EB) || (m_ptp_op == INS_V2_W_ASYM_LAT_EB)) {
               ptp_offset <= (cf_offset - 10);
               cf_offset  >= (ptp_offset + 10);
               cs_offset  >= (cf_offset + 8);
            }
            else {
               ptp_offset <= (cf_offset - 8);
               cf_offset  >= (ptp_offset + 8);
               cs_offset  >= (cf_offset + 8);
            }
         }

         if (ptp_ff_even_offsets) {
            ptp_offset % 2 == 0;
            cf_offset % 2 == 0;
            cs_offset %2 == 0;
         } else {
           ptp_offset % 2 == 1;
           cf_offset % 2 == 1;
           cs_offset %2 == 1;
        }


      }//ptp offset rand en
      else {
         ptp_offset dist { [16:19]  := 3, [39:60] := 2, [237:243] := 3};
         cf_offset inside{[16:50]};
      }  
   }

   if (is_ptp_seq && m_ptp_kind== PTP_ERR) {

	ptp_offset dist {[0:14] := 4, [15:22]:=2, [this.payload.size()+14+preamble_offset:65536]:=4};
	cf_offset dist {[0:14] := 4, [15:22]:=2, [this.payload.size()+14+preamble_offset:65536]:=4};
        cs_offset dist {[0:14] := 4, [15:22]:=2, [this.payload.size()+14+preamble_offset:65536]:=4};
   }
}


constraint asym_sign_c {

   solve m_ptp_op before asym_sign;
   
   if((m_ptp_kind == PTP_NORMAL) && is_ptp_seq){
   
      if(m_ptp_op inside { INS_V1_W_ASYM_LAT,INS_V1_W_ASYM_LAT_UDP_CS_0,INS_V1_W_ASYM_LAT_EB,
                     INS_V2_W_ASYM_LAT,INS_V2_W_ASYM_LAT_UDP_CS_0,INS_V2_W_ASYM_LAT_EB,
                     INS_CF_W_ASYM_LAT,INS_CF_W_ASYM_LAT_UDP_CS_0,INS_CF_W_ASYM_LAT_EB,
                     INS_P2P_W_ASYM_LAT,INS_P2P_W_ASYM_LAT_UDP_CS_0,INS_P2P_W_ASYM_LAT_EB,
                     INS_ASYM_LAT,INS_ASYM_LAT_CS_0,INS_ASYM_LAT_EB}) {
                        asym_sign inside {1,0};
                     } else {
                        asym_sign == 0;
                     }    
   }                 

}

constraint ptp_peamble_en_c {
   if(ptp_pp_en==1)   preamble_offset ==8 ;
   else               preamble_offset ==0 ;
}

constraint is_ptp_fp_c {
   i_ptp_tx_fp != 0; // README, should I set it 255?

    

}

//End PTP ones

constraint flow_control_frames_c {
  (cong_type==HEAVY) -> no_fc_frames inside{[5:10]};
  (cong_type==LOW) -> no_fc_frames inside{[1:5]};
   solve cong_type before no_fc_frames;
}
constraint frame_type_c {
frame_type inside {ETH_VLAN_FRAME,ETH_STACKED_VLAN_FRAME,ETH_DATA_FRAME,ETH_JUMBO_DATA_FRAME,ETH_JUMBO_VLAN_FRAME,ETH_JUMBO_STACKED_VLAN_FRAME,ETH_SFC_FRAME,ETH_PFC_FRAME,ETH_MISC_CONTROL_FRAME,ETH_IPV4_FRAME,ETH_IPV6_FRAME,ETH_USER_DEFINED_FRAME};
}
constraint is_vlan_svlan_f {
solve frame_type before is_vlan_f;
solve frame_type before is_svlan_f;
if ((frame_type ==ETH_VLAN_FRAME) ||(frame_type == ETH_JUMBO_VLAN_FRAME))
	 is_vlan_f == 1;
	else
		is_vlan_f == 0;
if ((frame_type ==ETH_STACKED_VLAN_FRAME) ||(frame_type == ETH_JUMBO_STACKED_VLAN_FRAME))
      is_svlan_f == 1;
	else
		is_svlan_f == 0;
}

constraint frame_payload_type_c {
  frame_payload_type inside {NORMAL,UNDERSIZE};
}

constraint sfc_pause_quanta_c {
  sfc_pause_quanta inside {[0:100]};
}

constraint pfc_pause_quanta_c {
  foreach(pfc_pause_quanta[idx]) {
    pfc_pause_quanta[idx] inside {[0:100]};
  }
}

constraint pfc_class_en_vect_c {
  pfc_class_en_vect[0] == 8'h0;
  pfc_class_en_vect[1] inside {[8'h0:8'hFF]}; // no need of this but writing for readability
}

constraint skip_tx_crc_insertion_c {
//`ifdef CRETE3
//   if((`async&&1) && !(`ptp_enable&&1))
//    {
//    skip_tx_crc_insertion==`skip_tx;
//    }
//    else
// `endif
    {
    skip_tx_crc_insertion inside {0,1};
    ((m_ptp_kind == PTP_NORMAL || m_ptp_kind == PTP_ERR) && is_ptp_seq && m_ptp_op!=INS_NOOP && m_ptp_op!=INS_2STEP) -> (skip_tx_crc_insertion==0);
    }
     solve m_ptp_op before skip_tx_crc_insertion;
     
}

constraint payload_size_c {

   if((frame_type == ETH_JUMBO_DATA_FRAME) || (frame_type == ETH_JUMBO_VLAN_FRAME) || (frame_type == ETH_JUMBO_STACKED_VLAN_FRAME))
   {
     if(frame_payload_type == NORMAL)
     payload.size inside {[32'd1501: 32'd19900]};
     else
     payload.size inside {[32'd0: 32'd45]};
   }
   else if (frame_type == ETH_VLAN_FRAME)
   {
     if(frame_payload_type == NORMAL)
       payload.size inside {[32'd42: 32'd1500]};
     else
       payload.size inside {[32'd0: 32'd41]};
   }
   else if (frame_type == ETH_STACKED_VLAN_FRAME)
   {
     if(frame_payload_type == NORMAL)
       payload.size inside {[32'd38: 32'd1500]};
     else
       payload.size inside {[32'd0: 32'd37]};
   }
   else if ((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME) || (frame_type == ETH_MISC_CONTROL_FRAME))
   {
     if(frame_payload_type == NORMAL)
       payload.size inside {32'd46};
     else
       payload.size inside {[32'd0: 32'd37]};
   }
   else
   {
     if(frame_payload_type == NORMAL)
       payload.size inside {[32'd46: 32'd1500]};
     else
       payload.size inside {[32'd0: 32'd45]};
   }
   solve frame_type before eth_type_or_length;
   solve frame_type before payload.size;
   solve frame_type before frame_payload_type;
   solve payload.size before eth_type_or_length;
   solve frame_payload_type before payload.size;
   }

constraint length_type_c {
   if((frame_type == ETH_DATA_FRAME))
    eth_type_or_length == payload.size;
   if (frame_type == ETH_VLAN_FRAME)
   {
    eth_type_or_length == payload.size;
    vlan_tag[31:16] =='h8100;
    vlan_tag[11:0] inside {[2:'hFFE]};
   }
   if (frame_type == ETH_STACKED_VLAN_FRAME)
   {
    eth_type_or_length == payload.size;
    vlan_tag[31:16] =='h8100;
    stacked_vlan_tag[31:16] =='h8100;
    stacked_vlan_tag[11:0] inside {[2:'hFFE]};
    vlan_tag[11:0] inside {[2:'hFFE]};
   }

   if(frame_type == ETH_JUMBO_DATA_FRAME)
   {
    eth_type_or_length == 'h8870;
   }
   if((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME) || (frame_type == ETH_MISC_CONTROL_FRAME))
   {
    eth_type_or_length == 'h8808;
   }

   if(frame_type == ETH_JUMBO_STACKED_VLAN_FRAME)
   {
    vlan_tag[31:16] =='h8100;
    stacked_vlan_tag[31:16] =='h8100;
    stacked_vlan_tag[11:0] inside {[2:'hFFE]};
    vlan_tag[11:0] inside {[2:'hFFE]};
    eth_type_or_length == 'h8870;
   }

  if(frame_type == ETH_JUMBO_VLAN_FRAME )
  {
    vlan_tag[31:16] =='h8100;
    vlan_tag[11:0] inside {[2:'hFFE]};
    eth_type_or_length == 'h8870;
   }
  if(frame_type == ETH_IPV4_FRAME )
  {
    eth_type_or_length == 'h0800;
  }
  if(frame_type == ETH_IPV6_FRAME )
  {
    eth_type_or_length == 'h86DD;
  }
  if(frame_type == ETH_USER_DEFINED_FRAME)
  {
    eth_type_or_length >= 'h600;
    eth_type_or_length != 'h8808;
    eth_type_or_length != 'h8870;
    eth_type_or_length != 'h0800;
    eth_type_or_length != 'h86DD;
  }


 //   eth_type_or_length inside {payload.size,'h8870,'h8808};
}

constraint preamble_c {
  this.preamble == 'hFB555555555555D5;
}

constraint dest_address_c {
 if ((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME) || (frame_type == ETH_MISC_CONTROL_FRAME))
       dest_address[40]==0;
   else dest_address dist {48'hD5D4D3D2D1D1 := 1, 48'hFFFFFFFFFFFF := 1,48'hD6D4D3D2D1D0 := 1};
   solve frame_type before dest_address;
}

constraint src_address_c {
   src_address[40] == 0;
}

constraint interpacket_gap_c {
  if ((payload.size ==  32'd46) || (payload.size ==  32'd42) || (payload.size ==  32'd38)) // all possible 64B frames
     this.interpacket_gap inside {['h1:25]};
  else   
     this.interpacket_gap inside {['h0:25]};
}

constraint ipg_idle_ins_en_c {
  soft this.ipg_idle_ins_en == 1;
}

function void pre_randomize();
   sip_limit_info_per_pkt_pack_bytes.push_front(sip_limit_test);
   `uvm_info ("PRE_RANDOMIZE",$psprintf ("sip limit size %d Full list %p",sip_limit_info_per_pkt_pack_bytes.size(),sip_limit_info_per_pkt_pack_bytes),UVM_LOW)

   sip_limit_info_per_pkt_seg_pack.push_front(sip_limit_test);
   `uvm_info ("PRE_RANDOMIZE",$psprintf ("sip limit size %d Full list %p",sip_limit_info_per_pkt_seg_pack.size(),sip_limit_info_per_pkt_seg_pack),UVM_LOW)

   // sip_limit_info_per_pkt_seg_unpack: Used in Segmented TX RTB Monitor to understand  
   // the size or siplimit information for the packet coming outside
   sip_limit_info_per_pkt_seg_unpack.push_front(sip_limit_test);
   `uvm_info ("PRE_RANDOMIZE",$psprintf ("sip limit size %d Full list %p",sip_limit_info_per_pkt_seg_unpack.size(),sip_limit_info_per_pkt_seg_unpack),UVM_LOW)

   // This is required for the ref_model to understand the size or siplimit information for the packet coming outside
   // This is required in both AVST & Segmented interfaces 
   sip_limit_info_per_pkt_unpack_bytes.push_front(sip_limit_test);
   `uvm_info ("PRE_RANDOMIZE",$psprintf ("sip limit size %d Full list %p",sip_limit_info_per_pkt_unpack_bytes.size(),sip_limit_info_per_pkt_unpack_bytes),UVM_LOW)
endfunction



//Method : pack_bytes
//This method does byte packing
function pack_bytes(bit crc_passthrough,bit preamble_passthrough);
  int preamble_ptr;
  int crc_ptr;
  bit sip_limit_tmp;


  `uvm_info ("pack_bytes",$psprintf ("acked bytes sip limit size %d Full list %p",sip_limit_info_per_pkt_pack_bytes.size(),sip_limit_info_per_pkt_pack_bytes),UVM_LOW)
  sip_limit_tmp = sip_limit_info_per_pkt_pack_bytes.pop_back();
  `uvm_info ("pack_bytes",$psprintf ("packed bytes sip_limit_tmp %d",sip_limit_tmp),UVM_LOW)
  // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
  `uvm_info ("pack_bytes",$psprintf ("packed bytes sip_limit_test %d",sip_limit_test),UVM_LOW)

   if((frame_type == ETH_DATA_FRAME) || (frame_type == ETH_IPV4_FRAME) || 
     (frame_type == ETH_IPV6_FRAME) || (frame_type == ETH_USER_DEFINED_FRAME)) begin
     if (sip_limit_tmp == 0) begin
          `uvm_info(get_type_name(),$sformatf("ABT_0 sip_limit_tmp:'%h",sip_limit_tmp), UVM_LOW)
          this.l_packed_bytes 	     = new[this.payload.size() + 22 + 4 ];
     end
     else begin
          `uvm_info(get_type_name(),$sformatf("ABT_1 sip_limit_tmp:'%h",sip_limit_tmp), UVM_LOW)
          this.l_packed_bytes 	     = new[this.payload.size() +2];
    end
   end
  if (frame_type == ETH_VLAN_FRAME)
  this.l_packed_bytes 	     = new[this.payload.size() + 4 + 22 + 4 ];

  if (frame_type == ETH_STACKED_VLAN_FRAME)
  this.l_packed_bytes 	     = new[this.payload.size() + 8 + 22 + 4 ];

  if (frame_type == ETH_JUMBO_DATA_FRAME)
  this.l_packed_bytes 	     = new[this.payload.size() + 22 + 4 ];

 if (frame_type == ETH_JUMBO_VLAN_FRAME)
  this.l_packed_bytes 	     = new[this.payload.size() + 4 + 22 + 4 ];

 if (frame_type == ETH_JUMBO_STACKED_VLAN_FRAME)
  this.l_packed_bytes 	     = new[this.payload.size() + 8 + 22 + 4 ];

 if((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME) || (frame_type == ETH_MISC_CONTROL_FRAME))
    this.l_packed_bytes 	     = new[this.payload.size() + 22 + 4 ];


 if (sip_limit_tmp ==0) begin
  this.l_packed_bytes[0] 		 = this.preamble[63:56];
  this.l_packed_bytes[1] 		 = this.preamble[55:48];
  this.l_packed_bytes[2] 		 = this.preamble[47:40];
  this.l_packed_bytes[3] 		 = this.preamble[39:32];
  this.l_packed_bytes[4] 		 = this.preamble[31:24];
  this.l_packed_bytes[5] 		 = this.preamble[23:16];
  this.l_packed_bytes[6] 		 = this.preamble[15:8];
  this.l_packed_bytes[7] 		 = this.preamble[7:0];

  this.l_packed_bytes[8] 		 = this.dest_address[47:40];
  this.l_packed_bytes[9] 		 = this.dest_address[39:32];
  this.l_packed_bytes[10] 		 = this.dest_address[31:24];
  this.l_packed_bytes[11] 		 = this.dest_address[23:16];
  this.l_packed_bytes[12] 		 = this.dest_address[15:8];
  this.l_packed_bytes[13] 		 = this.dest_address[7:0];

  this.l_packed_bytes[14] 		 = this.src_address[47:40];
  this.l_packed_bytes[15] 		 = this.src_address[39:32];
  this.l_packed_bytes[16] 		 = this.src_address[31:24];
  this.l_packed_bytes[17] 		 = this.src_address[23:16];
  this.l_packed_bytes[18] 		 = this.src_address[15:8];
  this.l_packed_bytes[19] 		 = this.src_address[7:0];
 end
  if(this.tx_fcs_error_insertion && crc_passthrough==0) begin
    //this.fcs = $urandom();
    this.fcs = ($urandom()%10 !==0) ? $urandom() : 32'h0 ;
    `uvm_info(get_type_name(),$sformatf("fcs error is inserted fcs:32'%h",this.fcs), UVM_LOW)
  end

 if((frame_type == ETH_DATA_FRAME) || (frame_type == ETH_JUMBO_DATA_FRAME) || (frame_type == ETH_IPV4_FRAME) || 
     (frame_type == ETH_IPV6_FRAME) || (frame_type == ETH_USER_DEFINED_FRAME)) begin
     if (sip_limit_tmp ==0) begin
        this.l_packed_bytes[20] 		 = this.eth_type_or_length[15:8];
        this.l_packed_bytes[21] 		 = this.eth_type_or_length[7:0];
     end
     else
      begin
        l_packed_bytes[payload.size()+0] 	= this.eth_type_or_length[15:8];;
        l_packed_bytes[payload.size()+1] 	= this.eth_type_or_length[7:0];;
      
      end


     foreach(this.payload[i]) begin
        if (sip_limit_tmp) 
            this.l_packed_bytes[i] 	 = this.payload[i];
        else
            this.l_packed_bytes[22 + i] 	 = this.payload[i];
     end

     if (sip_limit_tmp ==0) begin
        l_packed_bytes[22 + payload.size()+0] 	= this.fcs[31:24];
        l_packed_bytes[22 + payload.size()+1] 	= this.fcs[23:16];
        l_packed_bytes[22 + payload.size()+2] 	= this.fcs[15:8];
        l_packed_bytes[22 + payload.size()+3] 	= this.fcs[7:0];
     end
    `uvm_info(get_type_name(),$sformatf("inside data pkt fcs:32'%h",this.fcs), UVM_LOW)
  end


  if((frame_type == ETH_VLAN_FRAME) || (frame_type == ETH_JUMBO_VLAN_FRAME))begin

     {this.l_packed_bytes[20],this.l_packed_bytes[21],this.l_packed_bytes[22],this.l_packed_bytes[23]} = vlan_tag;

     this.l_packed_bytes[24] 		 = this.eth_type_or_length[15:8];
     this.l_packed_bytes[25] 		 = this.eth_type_or_length[7:0];

     foreach(this.payload[i]) begin
        this.l_packed_bytes[26 + i] 	 = this.payload[i];
     end

     l_packed_bytes[26 + payload.size()+0] 	= this.fcs[31:24];
     l_packed_bytes[26 + payload.size()+1] 	= this.fcs[23:16];
     l_packed_bytes[26 + payload.size()+2] 	= this.fcs[15:8];
     l_packed_bytes[26 + payload.size()+3] 	= this.fcs[7:0];

  end

  if((frame_type == ETH_STACKED_VLAN_FRAME) || (frame_type == ETH_JUMBO_STACKED_VLAN_FRAME))begin

     {this.l_packed_bytes[20],this.l_packed_bytes[21],this.l_packed_bytes[22],this.l_packed_bytes[23]} = vlan_tag;
     {this.l_packed_bytes[24],this.l_packed_bytes[25],this.l_packed_bytes[26],this.l_packed_bytes[27]} = stacked_vlan_tag;

       this.l_packed_bytes[28] 		 = this.eth_type_or_length[15:8];
       this.l_packed_bytes[29] 		 = this.eth_type_or_length[7:0];

       foreach(this.payload[i]) begin
          this.l_packed_bytes[30 + i] 	 = this.payload[i];
       end

       l_packed_bytes[30 + payload.size()+0] 	= this.fcs[31:24];
       l_packed_bytes[30 + payload.size()+1] 	= this.fcs[23:16];
       l_packed_bytes[30 + payload.size()+2] 	= this.fcs[15:8];
       l_packed_bytes[30 + payload.size()+3] 	= this.fcs[7:0];
  end
  if(frame_type == ETH_SFC_FRAME) begin
     //{this.l_packed_bytes[20] , this.l_packed_bytes[21]}		 = 'h8808;
     this.l_packed_bytes[20] 		 = this.eth_type_or_length[15:8];
     this.l_packed_bytes[21] 		 = this.eth_type_or_length[7:0];

     this.l_packed_bytes[22] 		 = 'h0;
     this.l_packed_bytes[23] 		 = 'h1;
 sfc_pause_quanta = {this.payload[2],this.payload[3]}; 
     {this.l_packed_bytes[24] , this.l_packed_bytes[25]}		 = sfc_pause_quanta;

     foreach(this.payload[i]) begin
          this.l_packed_bytes[26 + i] 	 = 0;
     end

     l_packed_bytes[22 + payload.size()+0] 	= this.fcs[31:24];
     l_packed_bytes[22 + payload.size()+1] 	= this.fcs[23:16];
     l_packed_bytes[22 + payload.size()+2] 	= this.fcs[15:8];
     l_packed_bytes[22 + payload.size()+3] 	= this.fcs[7:0];
  end
  if(frame_type == ETH_PFC_FRAME) begin
     //{this.l_packed_bytes[20] , this.l_packed_bytes[21]}		 = 'h8808;
     this.l_packed_bytes[20] 		 = this.eth_type_or_length[15:8];
     this.l_packed_bytes[21] 		 = this.eth_type_or_length[7:0];

     this.l_packed_bytes[22] 		 = 'h1;
     this.l_packed_bytes[23] 		 = 'h1;

   //  this.l_packed_bytes[24] 		 = this.pfc_class_en_vect[0];//0;
   //  this.l_packed_bytes[25] 		 = this.pfc_class_en_vect[1];//$urandom();

  this.l_packed_bytes[24] 		 = this.payload[2]; // supal : new_change
     this.l_packed_bytes[25] 		 = this.payload[3]; // supal : new_change

     this.pfc_pause_quanta[0] = {this.payload[4],this.payload[5]};   // supal : new_change  
     this.pfc_pause_quanta[1] = {this.payload[6],this.payload[7]};   // supal : new_change
     this.pfc_pause_quanta[2] = {this.payload[8],this.payload[9]};   // supal : new_change
     this.pfc_pause_quanta[3] = {this.payload[10],this.payload[11]}; // supal : new_change 
     this.pfc_pause_quanta[4] = {this.payload[12],this.payload[13]}; // supal : new_change 
     this.pfc_pause_quanta[5] = {this.payload[14],this.payload[15]}; // supal : new_change 
     this.pfc_pause_quanta[6] = {this.payload[16],this.payload[17]}; // supal : new_change 
     this.pfc_pause_quanta[7] = {this.payload[18],this.payload[19]};
  {this.l_packed_bytes[26] , this.l_packed_bytes[27]}	= this.pfc_pause_quanta[0];// supal : new_change  
     {this.l_packed_bytes[28] , this.l_packed_bytes[29]}	= this.pfc_pause_quanta[1];// supal : new_change   
     {this.l_packed_bytes[30] , this.l_packed_bytes[31]}	= this.pfc_pause_quanta[2];// supal : new_change   
     {this.l_packed_bytes[32] , this.l_packed_bytes[33]}	= this.pfc_pause_quanta[3];// supal : new_change   
     {this.l_packed_bytes[34] , this.l_packed_bytes[35]}	= this.pfc_pause_quanta[4];// supal : new_change   
     {this.l_packed_bytes[36] , this.l_packed_bytes[37]}	= this.pfc_pause_quanta[5];// supal : new_change 
     {this.l_packed_bytes[38] , this.l_packed_bytes[39]}	= this.pfc_pause_quanta[6];// supal : new_change   
     {this.l_packed_bytes[40] , this.l_packed_bytes[41]}	= this.pfc_pause_quanta[7];// supal : new_change   



     l_packed_bytes[22 + payload.size()+0] 	= this.fcs[31:24];
     l_packed_bytes[22 + payload.size()+1] 	= this.fcs[23:16];
     l_packed_bytes[22 + payload.size()+2] 	= this.fcs[15:8];
     l_packed_bytes[22 + payload.size()+3] 	= this.fcs[7:0];
  end

  if(frame_type == ETH_MISC_CONTROL_FRAME) begin
     //{this.l_packed_bytes[20] , this.l_packed_bytes[21]}		 = 'h8808;
     this.l_packed_bytes[20] 		 = this.eth_type_or_length[15:8];
     this.l_packed_bytes[21] 		 = this.eth_type_or_length[7:0];

     this.l_packed_bytes[22] 		 = 'hFF;
     this.l_packed_bytes[23] 		 = 'hFF;

   //  this.l_packed_bytes[24] 		 = this.pfc_class_en_vect[0];//0;
   //  this.l_packed_bytes[25] 		 = this.pfc_class_en_vect[1];//$urandom();

  this.l_packed_bytes[24] 		 = this.payload[2]; // supal : new_change
     this.l_packed_bytes[25] 		 = this.payload[3]; // supal : new_change

     this.pfc_pause_quanta[0] = {this.payload[4],this.payload[5]};   // supal : new_change  
     this.pfc_pause_quanta[1] = {this.payload[6],this.payload[7]};   // supal : new_change
     this.pfc_pause_quanta[2] = {this.payload[8],this.payload[9]};   // supal : new_change
     this.pfc_pause_quanta[3] = {this.payload[10],this.payload[11]}; // supal : new_change 
     this.pfc_pause_quanta[4] = {this.payload[12],this.payload[13]}; // supal : new_change 
     this.pfc_pause_quanta[5] = {this.payload[14],this.payload[15]}; // supal : new_change 
     this.pfc_pause_quanta[6] = {this.payload[16],this.payload[17]}; // supal : new_change 
     this.pfc_pause_quanta[7] = {this.payload[18],this.payload[19]};
  {this.l_packed_bytes[26] , this.l_packed_bytes[27]}	= this.pfc_pause_quanta[0];// supal : new_change  
     {this.l_packed_bytes[28] , this.l_packed_bytes[29]}	= this.pfc_pause_quanta[1];// supal : new_change   
     {this.l_packed_bytes[30] , this.l_packed_bytes[31]}	= this.pfc_pause_quanta[2];// supal : new_change   
     {this.l_packed_bytes[32] , this.l_packed_bytes[33]}	= this.pfc_pause_quanta[3];// supal : new_change   
     {this.l_packed_bytes[34] , this.l_packed_bytes[35]}	= this.pfc_pause_quanta[4];// supal : new_change   
     {this.l_packed_bytes[36] , this.l_packed_bytes[37]}	= this.pfc_pause_quanta[5];// supal : new_change 
     {this.l_packed_bytes[38] , this.l_packed_bytes[39]}	= this.pfc_pause_quanta[6];// supal : new_change   
     {this.l_packed_bytes[40] , this.l_packed_bytes[41]}	= this.pfc_pause_quanta[7];// supal : new_change   



     l_packed_bytes[22 + payload.size()+0] 	= this.fcs[31:24];
     l_packed_bytes[22 + payload.size()+1] 	= this.fcs[23:16];
     l_packed_bytes[22 + payload.size()+2] 	= this.fcs[15:8];
     l_packed_bytes[22 + payload.size()+3] 	= this.fcs[7:0];
  end

  if (preamble_passthrough == 1 )
  begin
    preamble_ptr = 0;
  end
  else
  begin
    preamble_ptr = 8;
  end

  if(crc_passthrough == 1) begin
    crc_ptr = 4 ;
  end
  else
  begin
    crc_ptr = 0 ;
  end

   `ifdef SHORT


  l_packed_bytes1=new[l_packed_bytes.size];	
  $display("%d",packet_size);
  l_packed_bytes1 =new[packet_size](l_packed_bytes);
  l_packed_bytes= new[packet_size];	
  l_packed_bytes=l_packed_bytes1; 
  
 packed_bytes=new[packet_size];	

  foreach(packed_bytes[i])
  packed_bytes[i] = l_packed_bytes[i+preamble_ptr];
  `else
  if (sip_limit_tmp) 
      packed_bytes = new[l_packed_bytes.size()];
  else
      packed_bytes = new[l_packed_bytes.size() - preamble_ptr - crc_ptr];
  foreach(packed_bytes[i])begin
    if (sip_limit_tmp==0) 
	  packed_bytes[i] = l_packed_bytes[i+preamble_ptr];
    else
	  packed_bytes[i] = l_packed_bytes[i];
  end
  `endif


endfunction

//Method : pack_bytes
//This method does byte unpacking
virtual function unpack_bytes(bit crc_passthrough,bit preamble_passthrough,string side="mac_rx_vip_tx",bit nonmac_sip_limit=1'b0);
  int array_index=0;
  int packed_bytes_size ;
  bit sip_limit_tmp;
 
  is_vlan_f =0;
  is_svlan_f =0;
  `uvm_info ("unpack_bytes",$psprintf ("unpacked bytes sip limit size %d Full list %p",sip_limit_info_per_pkt_unpack_bytes.size(),sip_limit_info_per_pkt_unpack_bytes),UVM_LOW)
  `uvm_info ("unpack_bytes",$sformatf("nonmac_sip_limit = %0d",nonmac_sip_limit),UVM_MEDIUM);
  if (nonmac_sip_limit == 1) //HSD: 16013867273
    sip_limit_tmp = this.sip_limit_test;
  else  
    sip_limit_tmp = sip_limit_info_per_pkt_unpack_bytes.pop_back();
  `uvm_info ("unpack_bytes",$psprintf (" unpacked bytes sip_limit_tmp %d",sip_limit_tmp),UVM_LOW)
  // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
  `uvm_info ("unpack_bytes",$psprintf (" unpacked bytes sip_limit_test %d",sip_limit_test),UVM_LOW)


 
 if (sip_limit_tmp==0) begin
  if (preamble_passthrough == 1 )
  begin
    this.preamble = {this.packed_bytes[0],this.packed_bytes[1],this.packed_bytes[2],this.packed_bytes[3],this.packed_bytes[4],this.packed_bytes[5],this.packed_bytes[6],
                     this.packed_bytes[7]};
    array_index = 0 ;
  end
  else begin
    if(side == "vip_tx_mac_rx")  array_index = 0 ;
    `ifdef ETH_MULTI_PORT
      else if(side == "vip_rx_mac_tx" ) array_index = 0 ;
    `else
      else if(side == "vip_rx_mac_tx" ) 
       if(this.packed_bytes[5] == 'h55 && this.packed_bytes[6] == 'hd5) begin
	 array_index=1;
       end else begin
         array_index=0;
       end	
    `endif
    else array_index = 8 ;

    this.preamble = 64'hfb555555_555555d5;
  end

  this.dest_address =  {this.packed_bytes[8 - array_index ],this.packed_bytes[9 - array_index ],this.packed_bytes[10 - array_index],
                         this.packed_bytes[11 - array_index],this.packed_bytes[12 - array_index],this.packed_bytes[13 - array_index]};


  this.src_address  =  {this.packed_bytes[14 - array_index],this.packed_bytes[15 - array_index],this.packed_bytes[16 - array_index],
			 this.packed_bytes[17 - array_index],this.packed_bytes[18 - array_index],this.packed_bytes[19 - array_index]};
 end
 else // SIP_LIMIT_TEST == 1
   begin
     array_index = 0 ;
     packed_bytes_size =  packed_bytes.size();
   end

 if (sip_limit_tmp==0) 
begin // SIP_LIMIT_TEST == O
  ////////////////////////////////////////////
  // ETH_DATA_FRAME
  ///////////////////////////////////////////
  if({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} < 'h600)
  begin
    frame_type = ETH_DATA_FRAME;
 if (sip_limit_tmp==0) begin

    this.eth_type_or_length  = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]};

      if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index)];
      else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
      else begin
        if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
	else  this.payload 	     = new[packed_bytes.size() - (22 - array_index) ];
      end
 end
      foreach(this.payload[i]) begin
        if (sip_limit_tmp==0) begin
               this.payload[i]    = this.packed_bytes[i + ( 22 - array_index)];
        end
        else
               this.payload[i]    = this.packed_bytes[i];
        end


        if (sip_limit_tmp==0) begin
             this.fcs[31:24] = this.packed_bytes[(22 - array_index ) + payload.size()+3];
             this.fcs[23:16] = this.packed_bytes[(22 - array_index ) + payload.size()+2];
             this.fcs[15:8]  = this.packed_bytes[(22 - array_index ) + payload.size()+1];
             this.fcs[7:0]   = this.packed_bytes[(22 - array_index ) + payload.size()+0];
        end     
  end
  else
  begin //not data
    ////////////////////////////////////////////
    // ETH_JUMBO_VLAN_FRAME and ETH_VLAN_FRAME
    ///////////////////////////////////////////
    if(({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h8100) && ({this.packed_bytes[24 - array_index],this.packed_bytes[25 - array_index]} != 'h8100))
    begin

      vlan_tag = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index],this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]};

      this.eth_type_or_length  = {this.packed_bytes[24 - array_index],this.packed_bytes[25 - array_index]};

      if(eth_type_or_length == 'h8870)
      begin
        frame_type = ETH_JUMBO_VLAN_FRAME;
        is_vlan_f  = 1;
        is_svlan_f = 0;

        if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[packed_bytes.size() - (26 - array_index) - 4 ];
        else
        begin
          if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (26 - array_index) - 4 ];
          else  this.payload 	     = new[packed_bytes.size() - (26 - array_index) ];
        end
      end //8870
      else
      begin
        frame_type = ETH_VLAN_FRAME;
        is_vlan_f  = 1;
        is_svlan_f = 0;

        if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[packed_bytes.size() - (26 - array_index) - 4 ];
        else  begin
          if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (26 - array_index) - 4 ];
          else  this.payload 	     = new[packed_bytes.size() - (26 - array_index) ];
        end
      end //not 8870

      foreach(this.payload[i]) begin
       this.payload[i]    = this.packed_bytes[i + (26 - array_index)];
      end

      this.fcs[31:24] = this.packed_bytes[(26 - array_index) + payload.size()+3];
      this.fcs[23:16] = this.packed_bytes[(26 - array_index) + payload.size()+2];
      this.fcs[15:8]  = this.packed_bytes[(26 - array_index) + payload.size()+1];
      this.fcs[7:0]   = this.packed_bytes[(26 - array_index) + payload.size()+0];
    end
    ////////////////////////////////////////////////
    // JUMBO STACK VLAN FRAME and STACK VLAN FRAME//
    //////////////////////////////////////////////
    else if(({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h8100) && ({this.packed_bytes[24 - array_index],this.packed_bytes[25 - array_index]} == 'h8100))
    begin

      vlan_tag = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index],this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]};
      stacked_vlan_tag = {this.packed_bytes[24 - array_index],this.packed_bytes[25 - array_index],this.packed_bytes[26 - array_index],this.packed_bytes[27 - array_index]};

      this.eth_type_or_length  = {this.packed_bytes[28 - array_index],this.packed_bytes[29 - array_index]};

      if(eth_type_or_length == 'h8870)
      begin
        frame_type = ETH_JUMBO_STACKED_VLAN_FRAME;
        is_svlan_f = 1;
        is_vlan_f  = 0;
        if(side == "vip_tx_mac_rx")  this.payload 	     = new[packed_bytes.size() - (30 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[packed_bytes.size() - (30 - array_index) - 4 ];
        else
        begin
          if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (30 - array_index) - 4 ];
          else  this.payload 	     = new[packed_bytes.size() - (30 - array_index) ];
        end
      end //8870
      else
      begin
        frame_type = ETH_STACKED_VLAN_FRAME;
        is_svlan_f = 1;
        is_vlan_f  = 0;
        if(side == "vip_tx_mac_rx")  this.payload 	     = new[packed_bytes.size() - (30 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[packed_bytes.size() - (30 - array_index) - 4 ];
        else
        begin
          if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (30 - array_index) - 4 ];
          else   this.payload 	     = new[packed_bytes.size() - (30 - array_index) ];
        end
      end//not 8870

      foreach(this.payload[i]) begin
       this.payload[i]    = this.packed_bytes[i + ( 30 - array_index)];
      end

      this.fcs[31:24] = this.packed_bytes[(30 - array_index) + payload.size()+3];
      this.fcs[23:16] = this.packed_bytes[(30 - array_index) + payload.size()+2];
      this.fcs[15:8]  = this.packed_bytes[(30 - array_index) + payload.size()+1];
      this.fcs[7:0]   = this.packed_bytes[(30 - array_index) + payload.size()+0];
    end
    ////////////////////////////////////////////
    // ETH_JUMBO_DATA_FRAME
    ///////////////////////////////////////////
    else if({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h8870)
    begin

      frame_type = ETH_JUMBO_DATA_FRAME;

      this.eth_type_or_length  = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]};

      if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index)];
      else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
      else
      begin
        if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
	      else                      this.payload 	     = new[packed_bytes.size() - (22 - array_index) ];
      end

      foreach(this.payload[i]) begin
       this.payload[i]    = this.packed_bytes[i + ( 22 - array_index)];
      end

      this.fcs[31:24] = this.packed_bytes[(22 - array_index ) + payload.size()+3];
      this.fcs[23:16] = this.packed_bytes[(22 - array_index ) + payload.size()+2];
      this.fcs[15:8]  = this.packed_bytes[(22 - array_index ) + payload.size()+1];
      this.fcs[7:0]   = this.packed_bytes[(22 - array_index ) + payload.size()+0];
    end
    ////////////////////////////////////////////
    // ETH_CONTROL_FRAME
    ///////////////////////////////////////////
    else if({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h8808)//flow control packets
    begin
      //frame_type = ETH_CONTROL_FRAME;
      this.eth_type_or_length  = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]};
      if({this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]} == 16'h0101) frame_type = ETH_PFC_FRAME;
      if({this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]} == 16'h0001) frame_type = ETH_SFC_FRAME;
      if({this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]} == 16'hFFFF) frame_type = ETH_MISC_CONTROL_FRAME;
      if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index)];
      else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
      else begin
        if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
	      else   this.payload 	     = new[packed_bytes.size() - (22 - array_index) ];
	    end

	    // PFC or SFC ?
      foreach(this.payload[i]) this.payload[i]    = this.packed_bytes[i + ( 22 - array_index)];
	    if (frame_type == ETH_SFC_FRAME) begin
        this.sfc_pause_quanta = {this.payload[2],this.payload[3]};
      end
      else begin // ETH_PFC_FRAME
        this.pfc_class_en_vect[0] = this.payload[2] ;
        this.pfc_class_en_vect[1] = this.payload[3] ;
        this.pfc_pause_quanta[0]  = {this.payload[4],this.payload[5]};
        this.pfc_pause_quanta[1]  = {this.payload[6],this.payload[7]};
        this.pfc_pause_quanta[2]  = {this.payload[8],this.payload[9]};
        this.pfc_pause_quanta[3]  = {this.payload[10],this.payload[11]};
        this.pfc_pause_quanta[4]  = {this.payload[12],this.payload[13]};
        this.pfc_pause_quanta[5]  = {this.payload[14],this.payload[15]};
        this.pfc_pause_quanta[6]  = {this.payload[16],this.payload[17]};
        this.pfc_pause_quanta[7]  = {this.payload[18],this.payload[19]};
      end

      // if(crc_passthrough) begin
      this.fcs[31:24] = this.packed_bytes[(22 - array_index ) + payload.size()+3];
      this.fcs[23:16] = this.packed_bytes[(22 - array_index ) + payload.size()+2];
      this.fcs[15:8]  = this.packed_bytes[(22 - array_index ) + payload.size()+1];
      this.fcs[7:0]   = this.packed_bytes[(22 - array_index ) + payload.size()+0];
      //end
      //else this.fcs=0;
    end
   ////////////////////////////////////////////
   // ETH_IPV4_FRAME & ETH_IPV6_FRAME
    ///////////////////////////////////////////
    else if(({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h0800) || 
            ({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h86DD))
    begin
      if ({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} == 'h0800)
        frame_type = ETH_IPV4_FRAME;
      else 
        frame_type = ETH_IPV6_FRAME;
      
      this.eth_type_or_length  = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]};

        if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index)];
        else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
        else begin
          if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
	        else                      this.payload 	     = new[packed_bytes.size() - (22 - array_index) ];
        end

        foreach(this.payload[i])
         this.payload[i]    = this.packed_bytes[i + ( 22 - array_index)];

      this.fcs[31:24] = this.packed_bytes[(22 - array_index ) + payload.size()+3];
      this.fcs[23:16] = this.packed_bytes[(22 - array_index ) + payload.size()+2];
      this.fcs[15:8]  = this.packed_bytes[(22 - array_index ) + payload.size()+1];
      this.fcs[7:0]   = this.packed_bytes[(22 - array_index ) + payload.size()+0];
    end
  ////////////////////////////////////////////
    // ETH_DATA_FRAME (Oversized)
    ///////////////////////////////////////////
    else if({this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]} >= 'h600)
    begin
      frame_type = ETH_USER_DEFINED_FRAME;
     if (sip_limit_tmp==0) begin
      this.eth_type_or_length  = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]};

        if(side == "vip_tx_mac_rx") this.payload 	     = new[packed_bytes.size() - (26 - array_index)];
        else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
        else begin
          if(crc_passthrough == 1)  this.payload 	     = new[packed_bytes.size() - (22 - array_index) - 4 ];
	        else                      this.payload 	     = new[packed_bytes.size() - (22 - array_index) ];
        end
     end
        foreach(this.payload[i]) begin
            if (sip_limit_tmp==0) begin
                 this.payload[i]    = this.packed_bytes[i + ( 22 - array_index)];
            end
            else begin
                 this.payload[i]    = this.packed_bytes[i ];
            end
        end
     if (sip_limit_tmp==0) begin
      this.fcs[31:24] = this.packed_bytes[(22 - array_index ) + payload.size()+3];
      this.fcs[23:16] = this.packed_bytes[(22 - array_index ) + payload.size()+2];
      this.fcs[15:8]  = this.packed_bytes[(22 - array_index ) + payload.size()+1];
      this.fcs[7:0]   = this.packed_bytes[(22 - array_index ) + payload.size()+0];
     end 
    end
    else begin
       `uvm_error("ETH Trans", $sformatf("Ethernet Frame has not been unpacked properly"));
    end

  end
end // SIP_LIMIT_TEST == O
else // SIP_LIMIT_TEST == 1
begin
 ////////////////////////////////////////////
  // ETH_DATA_FRAME
  ///////////////////////////////////////////
  if({this.packed_bytes[packed_bytes_size - 1],this.packed_bytes[packed_bytes_size]} < 'h600)
  begin
    frame_type = ETH_DATA_FRAME;
    this.eth_type_or_length  = {this.packed_bytes[packed_bytes_size - 1],this.packed_bytes[packed_bytes_size]};
    this.payload 	     = new[packed_bytes.size()];
    
    foreach(this.payload[i]) begin
      this.payload[i]    = this.packed_bytes[i];
    end
  end
end // SIP_LIMIT_TEST == 1
  if(side == "vip_tx_mac_rx") begin
    if(crc_passthrough == 0) this.fcs = 0 ;
  end

endfunction

//Method : pack_bytes
//This method does crc calculaiton
function bit[31:0] calc_crc32(bit txcrc_cover_preamble=0);
  bit [31:0] crc = 32'hFF_FF_FF_FF;
  pack_bytes(1,txcrc_cover_preamble);
  for(int i=0;i<this.packed_bytes.size();i++)
  begin
    if(i == 0)
    begin
      crc = 32'hFF_FF_FF_FF;
      crc = evolve_crc32_byte(crc,packed_bytes[i]);
    end
    else
    begin
      crc = evolve_crc32_byte(crc,packed_bytes[i]);
    end
  end
  crc      = inv_rev(crc);
  crc      = byte_rev (crc);
  this.fcs = crc;
  `uvm_info(get_type_name(),$sformatf("inside calc_crc32:32'%h",this.fcs), UVM_LOW)
endfunction

function bit[31:0] evolve_crc32_byte(bit[31:0] crc_in,bit[7:0] data);
  int k = 0;
  bit[31:0] poly;
  bit[31:0] msb;

  poly      = 32'h04c11db7;
  msb 	= 0;
  for (k=0; k<8; k++)
    begin
       msb    = crc_in & 32'h80000000;
       crc_in = crc_in << 1;
       if (msb != 0)
       begin
         crc_in = crc_in ^ poly;
       end
       if (data & 'h1)
       begin
    	 crc_in = crc_in ^ poly;
       end
       data >>= 1;
    end
  return (crc_in);
endfunction

function bit[31:0] inv_rev (bit[31:0] crc);
  bit[31:0] new_crc = 0;
  bit[31:0] rd_mask = 1;
  bit[31:0] set_mask = 32'h80000000;
  int n = 0;
  for (n=0; n<32; n++) begin
     if ((crc & rd_mask) == 0)
       begin
          new_crc |= set_mask;
       end
     set_mask >>= 1;
     rd_mask <<= 1;
  end
  return (new_crc);
endfunction

function bit[31:0] byte_rev (bit[31:0] crc);
  bit[31:0] tmp = 0;
  int n = 0;
  for (n=0; n<4; n++)
  begin
    tmp = (tmp << 8) | crc & 'hff;
    crc >>= 8;
  end
  return (tmp);
endfunction
   function automatic string timeToString(time timeVal, int decimalShift = 3, int precision = 2);
      string formatString;
      string retString;
      longint timeValPS;

      // convert time value to ps if it isn't already.
      timeValPS = real'(timeVal) * real'(real'(10)**real'(12+timeDivisor));
      // create formating string
      $sformat(formatString,"%%.%1df",precision);
      // create time string
      $sformat(retString,formatString,
         real'(longint'(longint'(timeValPS)/(real'(10)**real'(decimalShift-precision)))) / real'(10**precision)
      );
      if (decimalShift == 3) return {retString," ns"};
      else if (decimalShift == 6) return {retString," us"};
      else return retString;
   endfunction: timeToString
//Method : print_transaction
//This method prints the eth packet in byte format
function string print_transaction(integer frame_count = 1,bit[1:0] mode=2'b0,string side = "", bit seg_mode=0, bit[2:0] eop_empty = 0);
      string   str,temp_str,tmp_data_str,temp_str2;
      int      row_count;
      logic[7:0] temp_packed_bytes[$];
  //    //Assign packed_bytes to temp variable
      if(seg_mode == 0)begin
         temp_packed_bytes = packed_bytes;
      end else begin

         `ifdef ENABLE_ETH_VIP

	   if(m_sequence != "bandwidth_sequence") begin
            if(seg_packed_bytes.size()>0)begin

               // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
               foreach(this.seg_packed_bytes[i])begin
                  `uvm_info(get_type_name(),$sformatf("Inside print_transaction seg_packed_bytes[%0d: %0h]",i,this.seg_packed_bytes[i]), UVM_HIGH)
               end    
               
               temp_packed_bytes = seg_to_avst_pack_bytes(seg_packed_bytes);
      
               //Remove empty bytes
               for(int i = 0 ; i < eop_empty ; i++)begin
                  void'(temp_packed_bytes.pop_back());
               end

            end else begin

               temp_packed_bytes = packed_bytes;

            end
           end else begin
             // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
             foreach(this.seg_packed_bytes[i])begin
               `uvm_info(get_type_name(),$sformatf("Inside print_transaction seg_packed_bytes[%0d: %0h]",i,this.seg_packed_bytes[i]), UVM_HIGH)
             end    
             temp_packed_bytes = seg_to_avst_pack_bytes(seg_packed_bytes);
             //Remove empty bytes
             for(int i = 0 ; i < eop_empty ; i++)begin
                void'(temp_packed_bytes.pop_back());
             end
	   end
         `else

         // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
         foreach(this.seg_packed_bytes[i])begin
            `uvm_info(get_type_name(),$sformatf("Inside print_transaction seg_packed_bytes[%0d: %0h]",i,this.seg_packed_bytes[i]), UVM_HIGH)
         end    
         
         temp_packed_bytes = seg_to_avst_pack_bytes(seg_packed_bytes);

         //Remove empty bytes
         for(int i = 0 ; i < eop_empty ; i++)begin
            void'(temp_packed_bytes.pop_back());
         end

         `endif 
         
      end
      //Padded with 0 if no preamble for better visual in tracker comparison
      if(temp_packed_bytes.size()!=0)begin
         if(mode == 2'b01)begin
            repeat(8)begin
               if(temp_packed_bytes.size()>0)begin
                  temp_packed_bytes.delete(0);
               end
            end
         end else if (mode == 2'b10) begin
            repeat(8)begin
               temp_packed_bytes.push_front(8'h00);
            end
         end
      end
      str = {str, "+-----------------------------------------+\n"};
      temp_str = $psprintf("0x%0h",preamble);
      str = {str, $sformatf( "| PREAMBLE: %29s |\n",temp_str)};
      temp_str = $psprintf("0x%0h",dest_address);
      str = {str, $sformatf( "| DEST ADDR: %28s |\n",temp_str)};
      temp_str = $psprintf("0x%0h",src_address);
      str = {str, $sformatf( "| SRC ADDR: %29s |\n",temp_str)};
      temp_str = $psprintf("%0h",is_vlan_f);
      str = {str, $sformatf( "| IS VLAN: %30s |\n",temp_str)}; 
      temp_str = $psprintf("%0h",is_svlan_f);
      str = {str, $sformatf( "| IS SVLAN: %29s |\n",temp_str)};  
  //    if(is_vlan == 1'b0 && is_stacked_vlan == 1'b0) begin
  //       temp_str = $psprintf("%0d",eth_type_or_length);
  //       str = {str, $sformatf( "| TYPE/LENGTH(BYTE): %20s |\n",temp_str)};
  //    end
  //    else if(is_vlan == 1'b1) begin
  //       temp_str = $psprintf("0x%0h",eth_type_vlan);
  //       str = {str, $sformatf( "| VLAN TYPE: HEX : %22s |\n",temp_str)};
  //       temp_str = $psprintf("%0d",eth_length_vlan);
  //       str = {str, $sformatf( "| LENGTH: DEC: %26s |\n",temp_str)};
  //    end
  //    else if(is_stacked_vlan == 1'b1) begin
  //       temp_str = $psprintf("0x%0h",eth_type_vlan);
  //       str = {str, $sformatf( "| VLAN TYPE: HEX : %22s |\n",temp_str)};
  //       temp_str = $psprintf("0x%0h",eth_type_stacked_vlan);
  //       str = {str, $sformatf( "| SVLAN TYPE: HEX: %22s |\n",temp_str)};
  //       temp_str = $psprintf("%0d",eth_length_vlan);
  //       str = {str, $sformatf( "| LENGTH: DEC: %26s |\n",temp_str)};
  //    end
      temp_str = $psprintf("%0h",is_ptp_seq);
      str = {str, $sformatf( "| IS PTP PACKET: %24s |\n",temp_str)};
      temp_str = $psprintf("%0s",m_ptp_op.name());
      str = {str, $sformatf( "| OPCODE: %31s |\n",temp_str)};
  //    temp_str = $psprintf("%0s",m_ptp_sub_op.name());
  //    str = {str, $sformatf( "| SUB-OPCODE: %27s |\n",temp_str)};
      temp_str = $psprintf("%0h",ptp_offset);
      str = {str, $sformatf( "| TS OFFSET (HEX): %22s |\n",temp_str)};
      temp_str = $psprintf("%0h",cs_offset);
      str = {str, $sformatf( "| CS OFFSET (HEX): %22s |\n",temp_str)};
      temp_str = $psprintf("%0h",cf_offset);
      str = {str, $sformatf( "| CF OFFSET (HEX): %22s |\n",temp_str)};
      
      temp_str = $psprintf("%0d",asym_p2p_idx);
      str = {str, $sformatf( "| ASYM/P2P IDX (DEC): %19s |\n",temp_str)};
      temp_str = $psprintf("%0d",asym_sign);
      str = {str, $sformatf( "| ASYM DIR: %29s |\n",temp_str)};
      
  //    temp_str = $psprintf("%0h",seen_ctrl_err_tx_mon);
  //    str = {str, $sformatf( "| seen_ctrl_err_tx_mon: %17s |\n",temp_str)};
  //    temp_str = $psprintf("%0h",seen_ctrl_err_rx_mon);
  //    str = {str, $sformatf( "| seen_ctrl_err_rx_mon: %17s |\n",temp_str)};
      //TODO: Add more PTP info
      str = {str, "+-------+----------------+----------------+------+----------------------------------------------------+\n"};
      str = {str, "|       |                |                |      |                                                    |\n"};
      str = {str, "|  FRM  |   Start Time   |     End Time   |      |                       RAW DATA                     |\n"};
      str = {str, "|   #   |      (ns)      |       (ns)     |      | 00 01 02 03  04 05 06 07  08 09 10 11  12 13 14 15 |\n"};
      str = {str, "+-------+----------------+----------------+------+----------------------------------------------------+\n"};
      //Frame Count number Column
      temp_str = $psprintf("%0d",frame_count);
      str = {str, $sformatf("| %-5s |",temp_str)};
      //Start Time Column
      $sformat(temp_str, " %-14s | ", timeToString(start_time));
      str = {str, temp_str};
      //End Time Column
      if (temp_packed_bytes.size() <= 16) $sformat(temp_str, "%-14s |x%4h |", timeToString(end_time),row_count);
      else temp_str = {"               |x",$psprintf("%4h |",row_count)};
      str = {str, temp_str};

      temp_str = "";
      tmp_data_str = "";

      //Data Column
      for(int i =0; i <temp_packed_bytes.size(); i++)begin

         //If no preamble_passthrough added with -- within byte 0 to 7
         if(i%16 == 0) begin //Start/End

            tmp_data_str = "";
            tmp_data_str = ((i>=0 && i<=7) && (mode == 2'b10)) ? {tmp_data_str,"--"}  : {tmp_data_str,$psprintf("%02h" , temp_packed_bytes[i])};

         end else if ((i%(16/4))== 0 ) begin //Every 4 bytes

            tmp_data_str = ((i>=0 && i<=7) && (mode == 2'b10)) ? {tmp_data_str,"  --"}:{tmp_data_str,$psprintf("  %02h", temp_packed_bytes[i])};

         end else begin //every other bytes

            tmp_data_str = ((i>=0 && i<=7) && (mode == 2'b10)) ? {tmp_data_str," --"} :{tmp_data_str,$psprintf(" %02h" , temp_packed_bytes[i])};

         end


         if (i>3 && (i%16==0)) begin
            if (temp_packed_bytes.size()-i-1 < 16) begin // First line of initial portion of the tracker info
               $sformat(temp_str2, "\n|       |                | %14s |x%4h |", timeToString(end_time),row_count);
               temp_str = { temp_str, temp_str2};
            end else begin // Other line of initial portion of the tracker info
               $sformat(temp_str2, "\n|       |                |                |x%4h |",row_count);
               temp_str = { temp_str, temp_str2};
            end
         end

         //Append data every 16 bytes or when i reach the end of data
         if ((i+1)%16==0 || (i == temp_packed_bytes.size() - 1)) begin

            temp_str = {temp_str , $psprintf(" %-50s |", tmp_data_str)};

            row_count = row_count + 16;
         end


      end

      str = {str, temp_str};
      str = {str, "\n+-------+----------------+----------------+------+----------------------------------------------------+\n\n"};


      return str;
endfunction



//Method : post_randomize
//This method does post_randomization
function void post_randomize();

    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_start::is_ptp_seq=%0b, operation=%s", this.is_ptp_seq, this.m_ptp_op.name()), UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_start::ptp_ff_offsets_rand_en=%0b, ptp_ff_even_offsets=%0b, ptp_ff_odd_offsets=%0b", 
                                      this.ptp_ff_offsets_rand_en, this.ptp_ff_even_offsets, this.ptp_ff_odd_offsets), UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_start::i_ptp_tx_fp=%0d, payload_size=%0d, ts_offset=%0d, cf_offset=%0d, cs_offset=%0d, ingress_ts=%0h",
                                      this.i_ptp_tx_fp, payload.size(), this.ptp_offset, this.cf_offset, this.cs_offset, this.ingress_ts), UVM_LOW)

  //  Added by atiwari2, stopping the overriding of incremental generated
  //  data incase payload_type is assigned, else random payload
  if (payload_typ==INCR) begin
    foreach(this.payload[i])
      this.payload[i] = i;
  end else begin
    randcase
     5 : begin
            foreach(this.payload[i]) begin
               this.payload[i] = 0;
             end
          end
     5 : begin
            foreach(this.payload[i]) begin
               this.payload[i] = 'hFF;
             end
          end
     90 : begin
            foreach(this.payload[i]) begin
               this.payload[i] = $urandom();
             end
          end
     endcase
  end

    if(frame_type == ETH_SFC_FRAME) begin
      foreach(this.payload[i])
        this.payload[4+i] = 0;

        {this.payload[0],this.payload[1]} = 'h00001;
        {this.payload[2],this.payload[3]} = sfc_pause_quanta;
    end
    else if (frame_type == ETH_PFC_FRAME) begin
      foreach(this.payload[i])
        this.payload[20+i] = 0;

        {this.payload[0],this.payload[1]} = 'h0101;
        this.payload[2] = this.pfc_class_en_vect[0];
        this.payload[3] = this.pfc_class_en_vect[1];
        this.payload[4] =  this.pfc_pause_quanta[0][15:8];
        this.payload[5] =  this.pfc_pause_quanta[0][7:0];
        this.payload[6] =  this.pfc_pause_quanta[1][15:8];
        this.payload[7] =  this.pfc_pause_quanta[1][7:0];
        this.payload[8] =  this.pfc_pause_quanta[2][15:8];
        this.payload[9] =  this.pfc_pause_quanta[2][7:0];
        this.payload[10] = this.pfc_pause_quanta[3][15:8];
        this.payload[11] = this.pfc_pause_quanta[3][7:0];
        this.payload[12] = this.pfc_pause_quanta[4][15:8];
        this.payload[13] = this.pfc_pause_quanta[4][7:0];
        this.payload[14] = this.pfc_pause_quanta[5][15:8];
        this.payload[15] = this.pfc_pause_quanta[5][7:0];
        this.payload[16] = this.pfc_pause_quanta[6][15:8];
        this.payload[17] = this.pfc_pause_quanta[6][7:0];
        this.payload[18] = this.pfc_pause_quanta[7][15:8];
        this.payload[19] = this.pfc_pause_quanta[7][7:0];
    end
        else if (frame_type == ETH_MISC_CONTROL_FRAME) begin
      foreach(this.payload[i])
        this.payload[20+i] = 0;

        {this.payload[0],this.payload[1]} = 'hFFFF;
        this.payload[2] = this.pfc_class_en_vect[0];
        this.payload[3] = this.pfc_class_en_vect[1];
        this.payload[4] =  this.pfc_pause_quanta[0][15:8];
        this.payload[5] =  this.pfc_pause_quanta[0][7:0];
        this.payload[6] =  this.pfc_pause_quanta[1][15:8];
        this.payload[7] =  this.pfc_pause_quanta[1][7:0];
        this.payload[8] =  this.pfc_pause_quanta[2][15:8];
        this.payload[9] =  this.pfc_pause_quanta[2][7:0];
        this.payload[10] = this.pfc_pause_quanta[3][15:8];
        this.payload[11] = this.pfc_pause_quanta[3][7:0];
        this.payload[12] = this.pfc_pause_quanta[4][15:8];
        this.payload[13] = this.pfc_pause_quanta[4][7:0];
        this.payload[14] = this.pfc_pause_quanta[5][15:8];
        this.payload[15] = this.pfc_pause_quanta[5][7:0];
        this.payload[16] = this.pfc_pause_quanta[6][15:8];
        this.payload[17] = this.pfc_pause_quanta[6][7:0];
        this.payload[18] = this.pfc_pause_quanta[7][15:8];
        this.payload[19] = this.pfc_pause_quanta[7][7:0];
    end


  /*  if (payload_typ == PTP_DEBUG) begin
      // For PTP debug, keep incremental and fixed payload across packets.
      this.fixed_payload = ++seq_id;
         if (this.is_ptp_seq ==1) begin
            foreach(this.payload[i]) this.payload[i] = fixed_payload;
            i_ptp_tx_fp = seq_id % 'd255; // fp is a 8-bit bus.
            `uvm_info(get_full_name(), $sformatf("is_ptp_seq::is_ptp_seq=%0d, payload_typ=%s, seq_id=%0d, fixed_payload=%0d",
               is_ptp_seq, frame_type.name(), seq_id, fixed_payload), UVM_NONE)
         end */
   
	
    

    if (this.is_ptp_seq == 0) begin // NON PTP packet
          this.m_ptp_op = INS_NOOP;
          this.i_ptp_tx_fp=0;
          this.ingress_ts=0;
          this.ptp_offset=0;
          this.cf_offset=0;
          this.cs_offset=0;
    end else begin
          if(this.m_ptp_op == INS_2STEP) begin
               this.ingress_ts=0;
               this.ptp_offset=0;
               this.cf_offset=0;
               this.cs_offset=0;
          end
    end

    if (frame_payload_type == UNDERSIZE) begin
      if (this.is_ptp_seq == 0) begin // NON PTP packet
          this.m_ptp_op = INS_NOOP;
          this.i_ptp_tx_fp=0;
          this.ingress_ts=0;
          this.ptp_offset=0;
          this.cf_offset=0;
          this.cs_offset=0;
      end
		end

    if(((this.m_ptp_op == INS_V1) || (this.m_ptp_op == INS_V1_W_UDP_CS_0) || (this.m_ptp_op == INS_V1_W_EB) || (this.m_ptp_op == INS_V1_W_ASYM_LAT)    || 
                                                              (this.m_ptp_op == INS_V1_W_ASYM_LAT_UDP_CS_0) || (this.m_ptp_op == INS_V1_W_ASYM_LAT_EB) ||
        (this.m_ptp_op == INS_V2) || (this.m_ptp_op == INS_V2_W_UDP_CS_0) || (this.m_ptp_op == INS_V2_W_EB) || (this.m_ptp_op == INS_V2_W_ASYM_LAT)    || 
                                                              (this.m_ptp_op == INS_V2_W_ASYM_LAT_UDP_CS_0) || (this.m_ptp_op == INS_V2_W_ASYM_LAT_EB) ||
        (this.m_ptp_op == INS_CF) || (this.m_ptp_op == INS_CF_W_UDP_CS_0) || (this.m_ptp_op == INS_CF_W_EB) || (this.m_ptp_op == INS_CF_W_ASYM_LAT)    ||
                                                              (this.m_ptp_op == INS_CF_W_ASYM_LAT_UDP_CS_0) || (this.m_ptp_op == INS_CF_W_ASYM_LAT_EB)) && (this.is_ptp_seq == 1)) begin

         byte offset_pos = 'd14; //6+6+2

			   //This will be indicator for which cycle to set the offset
			   //The driver will have to take care of the preamble passthrough setting when counting
			   //up to this word
         if (!ptp_ff_offsets_rand_en) begin
			              if((this.ptp_offset > this.payload.size() -12)||
                       (this.cf_offset > this.payload.size() -8)||
                       (this.cs_offset > this.payload.size() -2)) begin
                            randcase
                                   50: begin
			   	                                this.ptp_offset = this.payload.size()-12;
                                          this.cf_offset  = this.ptp_offset-8;
			                                    this.cs_offset  = this.ptp_offset+10;
                                   end
                                   50: begin
			   	                                this.cf_offset  = this.payload.size()-10;
                                          this.ptp_offset = this.cf_offset-10;
			                                    this.cs_offset  = this.cf_offset+8;
                                   end
                            endcase
			              end

         end //ptp_ff_offset

 //       if (frame_type == ETH_VLAN_FRAME) begin
 //             if (this.ptp_offset < 'd18) 
 //                   this.ptp_offset = this.ptp_offset + 4;
 //       end

 //       if (frame_type == ETH_STACKED_VLAN_FRAME) begin
 //             if (this.ptp_offset < 'd22) 
 //                   this.ptp_offset = this.ptp_offset + 8;
 //       end
//to avoid overlapping
//if((this.ptp_offset > this.cf_offset) && (ptp_offset-cf_offset <8))  this.ptp_offset +=8;
//if((this.ptp_offset < this.cf_offset) && (cf_offset-ptp_offset <10)) this.cf_offset +=10;
         // till here.
			   this.ptp_offset_word_counter = (this.ptp_offset/8)+1;
			   this.cf_offset_word_counter  = (this.cf_offset/8)+1;
			   this.cs_offset_word_counter  = (this.cs_offset/8)+1;

         if (frame_type == ETH_VLAN_FRAME) offset_pos = 'd18;
         if (frame_type == ETH_STACKED_VLAN_FRAME) offset_pos = 'd22;

			   this.original_bytes = {this.payload[(this.ptp_offset)-(offset_pos) - preamble_offset],
                                this.payload[(this.ptp_offset+1)-(offset_pos) - preamble_offset],
					                      this.payload[(this.ptp_offset+2)-(offset_pos) - preamble_offset],
                                this.payload[(this.ptp_offset+3)-(offset_pos) - preamble_offset],
					                      this.payload[(this.ptp_offset+4)-(offset_pos) - preamble_offset],
                                this.payload[(this.ptp_offset+5)-(offset_pos) - preamble_offset],
					                      this.payload[(this.ptp_offset+6)-(offset_pos) - preamble_offset],
                                this.payload[(this.ptp_offset+7)-(offset_pos) - preamble_offset],
					                      this.payload[(this.ptp_offset+8)-(offset_pos) - preamble_offset],
                                this.payload[(this.ptp_offset+9)-(offset_pos) - preamble_offset]};

			   this.original_cf_bytes = {this.payload[(this.cf_offset)-(offset_pos) - preamble_offset],
                                   this.payload[(this.cf_offset+1)-(offset_pos) - preamble_offset],
						                       this.payload[(this.cf_offset+2)-(offset_pos) - preamble_offset],
                                   this.payload[(this.cf_offset+3)-(offset_pos) - preamble_offset],
						                       this.payload[(this.cf_offset+4)-(offset_pos) - preamble_offset],
                                   this.payload[(this.cf_offset+5)-(offset_pos) - preamble_offset],
						                       this.payload[(this.cf_offset+6)-(offset_pos) - preamble_offset],
                                   this.payload[(this.cf_offset+7)-(offset_pos) - preamble_offset]};

			   this.original_cs_bytes = {this.payload[(this.cs_offset)-(offset_pos) - preamble_offset],
                                   this.payload[(this.cs_offset+1)-(offset_pos) - preamble_offset]};

         `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_end::ts_wc=%0d, cf_wc=%0d, cs_wc=%0d",
                                               this.ptp_offset_word_counter, this.cf_offset_word_counter, this.cs_offset_word_counter), UVM_LOW)

		end

    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_end::is_ptp_seq=%0b, operation=%s", this.is_ptp_seq, this.m_ptp_op.name()), UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_end::i_ptp_tx_fp=%0d, payload_size=%0d, ts_offset=%0d, cf_offset=%0d, cs_offset=%0d, ingress_ts=%0h",
                                      this.i_ptp_tx_fp, payload.size(), this.ptp_offset, this.cf_offset, this.cs_offset, this.ingress_ts), UVM_LOW)

    this.calc_crc32();

endfunction : post_randomize

//Method : print_transaction
//This method over writes compare method
 virtual function bit do_compare( uvm_object rhs, uvm_comparer comparer );
      eth_packet to;
      bit passed;
      string s;
      passed = 1;

      if ( ! $cast( to, rhs ) ) return 0;

      if (this.preamble != to.preamble)
      begin
         passed = 0;
         s = {s, $sformatf("\tMismatch Preamble, Expected: %x, Actual: %x\n",this.preamble, to.preamble)};
      end

      if (this.dest_address != to.dest_address)
      begin
         passed = 0;
         s = {s, $sformatf("\tMismatch Destination Address, Expected: %x, Actual: %x\n", this.dest_address, to.dest_address)};
      end

      if (this.src_address != to.src_address)
      begin
         passed = 0;
         s = {s, $sformatf("\tMismatch Source Address, Expected: %x, Actual %x\n", this.src_address, to.src_address)};
      end

      if (this.eth_type_or_length != to.eth_type_or_length)
      begin
        passed = 0;
        s = {s, $sformatf("\tMismatch Eth Type/Length , Expected (decimalhex):%d / %x, Actual (decimal/hex): %d / %x\n", this.eth_type_or_length, this.eth_type_or_length, to.eth_type_or_length, to.eth_type_or_length)};
      end

      if(this.frame_type != to.frame_type)
      begin
        passed = 0;
         s = {s, $sformatf("\tMismatch Source Address, Expected: %x, Actual %x\n", this.frame_type.name(), to.frame_type.name())};
      end

      if (this.frame_type == ETH_VLAN_FRAME)
      begin
        if (this.vlan_tag != to.vlan_tag)
        begin
           passed = 0;
           s = {s, $sformatf("\tMismatch Source Address, Expected: %x, Actual %x\n", this.vlan_tag, to.vlan_tag)};
        end
      end

      if (this.frame_type == ETH_STACKED_VLAN_FRAME)
      begin
        if (this.vlan_tag != to.vlan_tag)
        begin
           passed = 0;
           s = {s, $sformatf("\tMismatch Source Address, Expected: %x, Actual %x\n", this.vlan_tag, to.vlan_tag)};
        end

        if (this.stacked_vlan_tag != to.stacked_vlan_tag)
        begin
           passed = 0;
           s = {s, $sformatf("\tMismatch Source Address, Expected: %x, Actual %x\n", this.vlan_tag, to.vlan_tag)};
        end
      end

      if(this.payload.size() != to.payload.size()) begin
        passed = 0;
        s = {s, $sformatf("\tMismatch Payload Size, Expected: %d, Actual %d\n", this.payload.size(), to.payload.size())};
      end
      else begin
        foreach (this.payload[i]) begin
          if(this.payload[i] != to.payload[i]) begin
            passed = 0;
            s = {s, $sformatf("\tMismatch Payload Data, Index: %d, Expected: %x, Actual %x\n", i,this.payload[i], to.payload[i])};
          end
        end
      end

      if(this.fcs != to.fcs) begin
        passed = 0;
        s = {s, $sformatf("\tMismatch on expected FCS: Expected: %x, Actual: %x\n", this.fcs,to.fcs)};
      end

      if (!passed)
      begin
         `uvm_error(get_type_name(), $sformatf("Mismatch found\n %0s",s));
      end

      return passed;

    endfunction

   virtual function unpack_bytes_extra_short_frame(bit rx_crc_passthrough_enabled, bit preamble_passthrough,string side="mac_rx_vip_tx");
     int start_num =0;

      `uvm_info(get_type_name(),$sformatf("ABT_this.extra_short_frame_rx_mon  %d, rx_crc_passthrough=%0d, preamble_passthrough=%0d ", start_num,rx_crc_passthrough_enabled,preamble_passthrough), UVM_LOW)
      `uvm_info(get_type_name(),$sformatf("sip_limit_test=%0d ", sip_limit_test), UVM_LOW)

     this.extra_short_frame = 1;

     if (sip_limit_test==0) begin
        if(preamble_passthrough == 1) begin
           this.extra_short_frame_size = this.packed_bytes.size() - 8;
        end
        else begin
           this.extra_short_frame_size = this.packed_bytes.size();
        end

        if(preamble_passthrough == 1) begin
          this.preamble = {this.packed_bytes[0], this.packed_bytes[1], this.packed_bytes[2], this.packed_bytes[3],this.packed_bytes[4],this.packed_bytes[5], this.packed_bytes[6], this.packed_bytes[7]};
          start_num = 8;
        end
        else begin
          start_num = 0;
        end
     
        if(side == "vip_tx_mac_rx")  start_num = 8 ;
        else if(side == "vip_rx_mac_tx" ) start_num = 8 ;
     end

     if (sip_limit_test==0) begin
       if(this.packed_bytes.size()>20 && this.packed_bytes[20]=='h81) begin
          for(int k = 0; k< this.extra_short_frame_size; k++) begin
                 if(k ==  0) this.dest_address[47:40] =      this.packed_bytes[start_num + 0]  ;
                 if(k ==  1) this.dest_address[39:32] =      this.packed_bytes[start_num + 1]  ;
                 if(k ==  2) this.dest_address[31:24] =      this.packed_bytes[start_num + 2]  ;
                 if(k ==  3) this.dest_address[23:16] =      this.packed_bytes[start_num + 3]  ;
                 if(k ==  4) this.dest_address[15:8] =       this.packed_bytes[start_num + 4]  ;
                 if(k ==  5) this.dest_address[7:0] =        this.packed_bytes[start_num + 5]  ;
                 if(k ==  6) this.src_address[47:40] =       this.packed_bytes[start_num + 6]  ;
                 if(k ==  7) this.src_address[39:32] =       this.packed_bytes[start_num + 7]  ;
                 if(k ==  8) this.src_address[31:24] =       this.packed_bytes[start_num + 8]  ;
                 if(k ==  9) this.src_address[23:16] =       this.packed_bytes[start_num + 9]  ;
                 if(k ==  10)this.src_address[15:8] =        this.packed_bytes[start_num + 10] ;
                 if(k ==  11)this.src_address[7:0] =         this.packed_bytes[start_num + 11] ;
                 if(k ==  12)this.vlan_tag[31:24]   =	   this.packed_bytes[start_num + 12] ;
                 if(k ==  13)this.vlan_tag[23:16]   =  	   this.packed_bytes[start_num + 13] ;
                 if(k ==  14)this.vlan_tag[15:8]   =	   this.packed_bytes[start_num + 14] ;
                 if(k ==  15)this.vlan_tag[7:0]   =  	   this.packed_bytes[start_num + 15] ;
                 if(this.packed_bytes[20]=='h81 && this.packed_bytes[24]!=='h81)
                 begin
                     if(k ==  16)this.eth_type_or_length[15:8]   =  	   this.packed_bytes[start_num + 16] ;
                     if(k ==  17)this.eth_type_or_length[7:0]   =  	   this.packed_bytes[start_num + 17] ;
                 end
                 else
                 begin
	                 if(k ==  16)this.stacked_vlan_tag[31:24]   =	   this.packed_bytes[start_num + 16] ;
                     if(k ==  17)this.stacked_vlan_tag[23:16]   =  	   	   this.packed_bytes[start_num + 17] ;
                     if(k ==  18)this.stacked_vlan_tag[15:8]   =	           this.packed_bytes[start_num + 18] ;
                     if(k ==  19)this.stacked_vlan_tag[7:0]   =  	           this.packed_bytes[start_num + 19] ;
                     if(k ==  20)this.eth_type_or_length[15:0]   =  	   	   this.packed_bytes[start_num + 20] ;
                     if(k ==  21)this.eth_type_or_length[15:0]   =  	           this.packed_bytes[start_num + 21] ;
	             end
            
          end
          if(preamble_passthrough == 1) begin
	         if (this.packed_bytes[20]=='h81 && this.packed_bytes[24] !=='h81) begin
		           if(this.packed_bytes.size() == 21) begin this.vlan_tag[23:0] = 0;this.eth_type_or_length[15:0] = 0;  end	
		        	else if(this.packed_bytes.size() == 22) begin this.vlan_tag[15:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       	       	else if(this.packed_bytes.size() == 23) begin this.vlan_tag[7:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       	       	else if(this.packed_bytes.size() == 24)   begin this.eth_type_or_length[15:0] = 0; end
       	       	else if(this.packed_bytes.size() == 25)   begin this.eth_type_or_length[7:0] = 0; end
		     end
		     else
		     begin
		         if     (this.packed_bytes.size() == 22)    begin this.vlan_tag[15:0] = 0;this.stacked_vlan_tag[31:0]='h81000000; this.eth_type_or_length[15:0] = 0; end
		         else if  (this.packed_bytes.size() == 23)    begin this.vlan_tag[7:0] = 0;this.stacked_vlan_tag[31:0]='h81000000; this.eth_type_or_length[15:0] = 0; end
		         else if(this.packed_bytes.size() == 25)  begin  this.stacked_vlan_tag[23:0]='h0 ; this.eth_type_or_length[15:0]=0; end
       	       		     else if(this.packed_bytes.size() == 26)   begin this.stacked_vlan_tag[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
       	       		     else if(this.packed_bytes.size() == 27)   begin this.stacked_vlan_tag[7:0] = 0; this.eth_type_or_length[15:0] = 0; end		                     
       	       		     else if(this.packed_bytes.size() == 28)   begin this.eth_type_or_length[15:0] = 0; end
       	       		     else if(this.packed_bytes.size() == 29)   begin this.eth_type_or_length[7:0] = 0; end
		     end
          end
          else begin
	         if (this.packed_bytes[12]=='h81 && this.packed_bytes[16] !=='h81  ) begin
			    if(this.packed_bytes.size() == 13) begin this.vlan_tag[23:0] = 0;this.eth_type_or_length[15:0] = 0;  end
			    else if(this.packed_bytes.size() == 14) begin this.vlan_tag[15:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       			else if(this.packed_bytes.size() == 15) begin this.vlan_tag[7:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       			else if(this.packed_bytes.size() == 16)   begin this.eth_type_or_length[15:0] = 0; end
       			else if(this.packed_bytes.size() == 17)   begin this.eth_type_or_length[7:0] = 0; end
		     end
		     else
		     begin
				     if     (this.packed_bytes.size() == 14)    begin this.vlan_tag[15:0] = 0;this.stacked_vlan_tag[31:0]='h81000000; this.eth_type_or_length[15:0] = 0; end
     				     else if(this.packed_bytes.size() == 15)   begin this.vlan_tag[7:0] = 0;this.stacked_vlan_tag[31:0]='h81000000 ; this.eth_type_or_length[15:0]=0; end
     				     else if(this.packed_bytes.size() == 17)   begin this.stacked_vlan_tag[23:0] = 0;this.stacked_vlan_tag[31:0]='h81000000 ; this.eth_type_or_length[15:0]=0; end
       				     else if(this.packed_bytes.size() == 18)   begin this.stacked_vlan_tag[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
       				     else if(this.packed_bytes.size() == 19)   begin this.stacked_vlan_tag[7:0] = 0; this.eth_type_or_length[15:0] = 0; end					     
       				     else if(this.packed_bytes.size() == 20)   begin this.eth_type_or_length[15:0] = 0; end
       				     else if(this.packed_bytes.size() == 21)   begin this.eth_type_or_length[7:0] = 0; end
			 end
          end

		  if(rx_crc_passthrough_enabled ==0) begin
		 	`uvm_info(get_type_name(),$sformatf("packed_bytes.size is %0d",this.packed_bytes.size()), UVM_LOW)
           	if     (this.packed_bytes.size() == 21)    begin this.src_address[23:0] = 0; this.eth_type_or_length[15:0] = 0; end
           	else if(this.packed_bytes.size() == 22)   begin 
		   	this.src_address[15:0] = 0; this.eth_type_or_length[15:0] = 0;
		   		`uvm_info(get_type_name(),$sformatf("packed_bytes.size is %0d and src_address is %0h and eth_type is %0h",this.packed_bytes.size(),this.src_address,this.eth_type_or_length), UVM_LOW)
		   	end
          	else if(this.packed_bytes.size() == 23)   begin this.src_address[7:0] = 0; this.eth_type_or_length[15:0] = 0; end
           	else if(this.packed_bytes.size() == 24)   begin this.eth_type_or_length[15:0] = 0; end
           	else if(this.packed_bytes.size() == 25)   begin this.eth_type_or_length[7:0] = 0; end
          end
			 `uvm_info(get_type_name(),$sformatf("dest_address is %0h,scr_address is %0h and eth_type is %0h",this.dest_address,this.src_address,this.eth_type_or_length), UVM_LOW)
     //end
      end else begin   

         //for(int k = 0; k< this.packed_bytes.size() - start_num; k++) begin
         for(int k = 0; k< this.extra_short_frame_size; k++) begin
           if(k ==  0) this.dest_address[47:40] =      this.packed_bytes[start_num + 0]  ;
           if(k ==  1) this.dest_address[39:32] =      this.packed_bytes[start_num + 1]  ;
           if(k ==  2) this.dest_address[31:24] =      this.packed_bytes[start_num + 2]  ;
           if(k ==  3) this.dest_address[23:16] =      this.packed_bytes[start_num + 3]  ;
           if(k ==  4) this.dest_address[15:8] =       this.packed_bytes[start_num + 4]  ;
           if(k ==  5) this.dest_address[7:0] =        this.packed_bytes[start_num + 5]  ;
           if(k ==  6) this.src_address[47:40] =       this.packed_bytes[start_num + 6]  ;
           if(k ==  7) this.src_address[39:32] =       this.packed_bytes[start_num + 7]  ;
           if(k ==  8) this.src_address[31:24] =       this.packed_bytes[start_num + 8]  ;
           if(k ==  9) this.src_address[23:16] =       this.packed_bytes[start_num + 9]  ;
           if(k ==  10)this.src_address[15:8] =        this.packed_bytes[start_num + 10] ;
           if(k ==  11)this.src_address[7:0] =         this.packed_bytes[start_num + 11] ;
           if(k ==  12)this.eth_type_or_length[15:8] = this.packed_bytes[start_num + 12] ;
           if(k ==  13)this.eth_type_or_length[7:0] =  this.packed_bytes[start_num + 13] ;
         end

         if(preamble_passthrough == 1) begin
           if     (this.packed_bytes.size() == 9)  begin this.dest_address[39:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 10)  begin this.dest_address[31:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 11)  begin this.dest_address[23:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 12)  begin this.dest_address[15:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 13)  begin this.dest_address[7:0]  = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 14)  begin this.src_address[47:0]  = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 15)  begin this.src_address[39:0]  = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 16)  begin this.src_address[31:0]  = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 17)  begin this.src_address[23:0]  = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 18) begin this.src_address[15:0]  = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 19) begin this.src_address[7:0]   = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 20) begin this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 21) begin this.eth_type_or_length[7:0] = 0; end
         end
         else begin
           if     (this.packed_bytes.size() == 9)    begin this.src_address[23:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 10)   begin this.src_address[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 11)   begin this.src_address[7:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 12)   begin this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 13)   begin this.eth_type_or_length[7:0] = 0; end
         end
        
         if(rx_crc_passthrough_enabled ==0) begin
           if     (this.packed_bytes.size() == 21)    begin this.src_address[23:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 22)   begin this.src_address[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 23)   begin this.src_address[7:0] = 0; this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 24)   begin this.eth_type_or_length[15:0] = 0; end
           else if(this.packed_bytes.size() == 25)   begin this.eth_type_or_length[7:0] = 0; end
         end

      end
  end
  
  if (sip_limit_test==0) begin
	     this.payload=new[0];
  end
  else begin
	     this.payload=new[packed_bytes.size()];
  end

    `uvm_info(get_type_name(),$sformatf("payload size =%0d",this.payload.size()),UVM_MEDIUM); 
    `uvm_info(get_type_name(),$sformatf("this.extra_short_frame: %0d, this.extra_short_frame_size:%0d ", this.extra_short_frame, this.extra_short_frame_size), UVM_MEDIUM)

   endfunction // unpack_bytes_extra_short_frame

   virtual function seg_unpack_bytes_extra_short_frame(bit rx_crc_passthrough_enabled, bit preamble_passthrough,string side="mac_rx_vip_tx");
     int start_num =0;
     bit [7:0] temp_bytes[$];

//reversing byte in each segment .
	foreach(this.seg_packed_bytes[i])begin
  		this.seg_packed_bytes[i] = {<<byte{this.seg_packed_bytes[i]}};
                end
        $display("after revering byte order in each segment");
        $display(seg_packed_bytes);
//after reversing split each segment into 8 bytes.
           this.temp_seg_packed_bytes = {>>byte{this.seg_packed_bytes}};
        $display("after spliting byte order in each segment");
        $display(seg_packed_bytes);
//remove empty bytes
           temp_bytes = this.temp_seg_packed_bytes;
           repeat(empty_bytes)begin
                void'(temp_bytes.pop_back());
           end
           this.temp_seg_packed_bytes = temp_bytes;
        $display("after empty  bytes");
        $display(temp_seg_packed_bytes);


     this.extra_short_frame = 1;
     if(preamble_passthrough == 1) begin
       this.extra_short_frame_size = this.temp_seg_packed_bytes.size() - 8;
     end
     else begin
       this.extra_short_frame_size = this.temp_seg_packed_bytes.size();
     end

     if(preamble_passthrough == 1) begin
       {>>{this.preamble}} = {>>{this.temp_seg_packed_bytes[0:7]}};
       start_num = 8;
     end
     else begin
       start_num = 0;
     end
     if(side == "vip_tx_mac_rx")  start_num = 8 ;
     else if(side == "vip_rx_mac_tx" ) start_num = 8 ;
   if(this.temp_seg_packed_bytes.size()>20 && this.temp_seg_packed_bytes[20]=='h81)
     begin
          for(int k = 0; k< this.extra_short_frame_size; k++) begin
       if(k ==  0) this.dest_address[47:40] =      this.temp_seg_packed_bytes[start_num + 0]  ;
       if(k ==  1) this.dest_address[39:32] =      this.temp_seg_packed_bytes[start_num + 1]  ;
       if(k ==  2) this.dest_address[31:24] =      this.temp_seg_packed_bytes[start_num + 2]  ;
       if(k ==  3) this.dest_address[23:16] =      this.temp_seg_packed_bytes[start_num + 3]  ;
       if(k ==  4) this.dest_address[15:8] =       this.temp_seg_packed_bytes[start_num + 4]  ;
       if(k ==  5) this.dest_address[7:0] =        this.temp_seg_packed_bytes[start_num + 5]  ;
       if(k ==  6) this.src_address[47:40] =       this.temp_seg_packed_bytes[start_num + 6]  ;
       if(k ==  7) this.src_address[39:32] =       this.temp_seg_packed_bytes[start_num + 7]  ;
       if(k ==  8) this.src_address[31:24] =       this.temp_seg_packed_bytes[start_num + 8]  ;
       if(k ==  9) this.src_address[23:16] =       this.temp_seg_packed_bytes[start_num + 9]  ;
       if(k ==  10)this.src_address[15:8] =        this.temp_seg_packed_bytes[start_num + 10] ;
       if(k ==  11)this.src_address[7:0] =         this.temp_seg_packed_bytes[start_num + 11] ;
       if(k ==  12)this.vlan_tag[31:24]   =	   this.temp_seg_packed_bytes[start_num + 12] ;
       if(k ==  13)this.vlan_tag[23:16]   =  	   this.temp_seg_packed_bytes[start_num + 13] ;
       if(k ==  14)this.vlan_tag[15:8]   =	   this.temp_seg_packed_bytes[start_num + 14] ;
       if(k ==  15)this.vlan_tag[7:0]   =  	   this.temp_seg_packed_bytes[start_num + 15] ;
       if(this.temp_seg_packed_bytes[20]=='h81 && this.temp_seg_packed_bytes[24]!=='h81)
       begin
       if(k ==  16)this.eth_type_or_length[15:8]   =  	   this.temp_seg_packed_bytes[start_num + 16] ;
       if(k ==  17)this.eth_type_or_length[7:0]   =  	   this.temp_seg_packed_bytes[start_num + 17] ;
       end
       else
       begin
	       if(k ==  16)this.stacked_vlan_tag[31:24]   =	   this.temp_seg_packed_bytes[start_num + 16] ;
       if(k ==  17)this.stacked_vlan_tag[23:16]   =  	   	   this.temp_seg_packed_bytes[start_num + 17] ;
       if(k ==  18)this.stacked_vlan_tag[15:8]   =	           this.temp_seg_packed_bytes[start_num + 18] ;
       if(k ==  19)this.stacked_vlan_tag[7:0]   =  	           this.temp_seg_packed_bytes[start_num + 19] ;
       if(k ==  20)this.eth_type_or_length[15:0]   =  	   	   this.temp_seg_packed_bytes[start_num + 20] ;
       if(k ==  21)this.eth_type_or_length[15:0]   =  	           this.temp_seg_packed_bytes[start_num + 21] ;
	end
            
end
     if(preamble_passthrough == 1) begin
	     if (this.temp_seg_packed_bytes[20]=='h81 && this.temp_seg_packed_bytes[24] !=='h81) begin
		        if(this.temp_seg_packed_bytes.size() == 21) begin this.vlan_tag[23:0] = 0;this.eth_type_or_length[15:0] = 0;  end	
		     	else if(this.temp_seg_packed_bytes.size() == 22) begin this.vlan_tag[15:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       			else if(this.temp_seg_packed_bytes.size() == 23) begin this.vlan_tag[7:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       			else if(this.temp_seg_packed_bytes.size() == 24)   begin this.eth_type_or_length[15:0] = 0; end
       			else if(this.temp_seg_packed_bytes.size() == 25)   begin this.eth_type_or_length[7:0] = 0; end
		end
		else
		begin
			  if     (this.temp_seg_packed_bytes.size() == 22)    begin this.vlan_tag[15:0] = 0;this.stacked_vlan_tag[31:0]='h81000000; this.eth_type_or_length[15:0] = 0; end
		 	else if  (this.temp_seg_packed_bytes.size() == 23)    begin this.vlan_tag[7:0] = 0;this.stacked_vlan_tag[31:0]='h81000000; this.eth_type_or_length[15:0] = 0; end
			else if(this.temp_seg_packed_bytes.size() == 25)  begin  this.stacked_vlan_tag[23:0]='h0 ; this.eth_type_or_length[15:0]=0; end
       				     else if(this.temp_seg_packed_bytes.size() == 26)   begin this.stacked_vlan_tag[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
       				     else if(this.temp_seg_packed_bytes.size() == 27)   begin this.stacked_vlan_tag[7:0] = 0; this.eth_type_or_length[15:0] = 0; end		                     
       				     else if(this.temp_seg_packed_bytes.size() == 28)   begin this.eth_type_or_length[15:0] = 0; end
       				     else if(this.temp_seg_packed_bytes.size() == 29)   begin this.eth_type_or_length[7:0] = 0; end
			      	     end
               end
     
     else begin
	if (this.temp_seg_packed_bytes[12]=='h81 && this.temp_seg_packed_bytes[16] !=='h81  ) begin
			if(this.seg_packed_bytes.size() == 13) begin this.vlan_tag[23:0] = 0;this.eth_type_or_length[15:0] = 0;  end
			else if(this.temp_seg_packed_bytes.size() == 14) begin this.vlan_tag[15:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       			else if(this.temp_seg_packed_bytes.size() == 15) begin this.vlan_tag[7:0] = 0;this.eth_type_or_length[15:0] = 0;  end
       			else if(this.temp_seg_packed_bytes.size() == 16)   begin this.eth_type_or_length[15:0] = 0; end
       			else if(this.temp_seg_packed_bytes.size() == 17)   begin this.eth_type_or_length[7:0] = 0; end
		end
		else
		begin
				     if     (this.temp_seg_packed_bytes.size() == 14)    begin this.vlan_tag[15:0] = 0;this.stacked_vlan_tag[31:0]='h81000000; this.eth_type_or_length[15:0] = 0; end
     				     else if(this.temp_seg_packed_bytes.size() == 15)   begin this.vlan_tag[7:0] = 0;this.stacked_vlan_tag[31:0]='h81000000 ; this.eth_type_or_length[15:0]=0; end
     				     else if(this.temp_seg_packed_bytes.size() == 17)   begin this.stacked_vlan_tag[23:0] = 0;this.stacked_vlan_tag[31:0]='h81000000 ; this.eth_type_or_length[15:0]=0; end
					     
       				     else if(this.temp_seg_packed_bytes.size() == 18)   begin this.stacked_vlan_tag[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
       				     else if(this.temp_seg_packed_bytes.size() == 19)   begin this.stacked_vlan_tag[7:0] = 0; this.eth_type_or_length[15:0] = 0; end					     
       				     else if(this.temp_seg_packed_bytes.size() == 20)   begin this.eth_type_or_length[15:0] = 0; end
       				     else if(this.temp_seg_packed_bytes.size() == 21)   begin this.eth_type_or_length[7:0] = 0; end
			      	     end
               end

     //end
 end
 else
 begin   


     //for(int k = 0; k< this.packed_bytes.size() - start_num; k++) begin
     for(int k = 0; k< this.extra_short_frame_size; k++) begin
       if(k ==  0) this.dest_address[47:40] =      this.temp_seg_packed_bytes[start_num + 0]  ;
       if(k ==  1) this.dest_address[39:32] =      this.temp_seg_packed_bytes[start_num + 1]  ;
       if(k ==  2) this.dest_address[31:24] =      this.temp_seg_packed_bytes[start_num + 2]  ;
       if(k ==  3) this.dest_address[23:16] =      this.temp_seg_packed_bytes[start_num + 3]  ;
       if(k ==  4) this.dest_address[15:8] =       this.temp_seg_packed_bytes[start_num + 4]  ;
       if(k ==  5) this.dest_address[7:0] =        this.temp_seg_packed_bytes[start_num + 5]  ;
       if(k ==  6) this.src_address[47:40] =       this.temp_seg_packed_bytes[start_num + 6]  ;
       if(k ==  7) this.src_address[39:32] =       this.temp_seg_packed_bytes[start_num + 7]  ;
       if(k ==  8) this.src_address[31:24] =       this.temp_seg_packed_bytes[start_num + 8]  ;
       if(k ==  9) this.src_address[23:16] =       this.temp_seg_packed_bytes[start_num + 9]  ;
       if(k ==  10)this.src_address[15:8] =        this.temp_seg_packed_bytes[start_num + 10] ;
       if(k ==  11)this.src_address[7:0] =         this.temp_seg_packed_bytes[start_num + 11] ;
       if(k ==  12)this.eth_type_or_length[15:8] = this.temp_seg_packed_bytes[start_num + 12] ;
       if(k ==  13)this.eth_type_or_length[7:0] =  this.temp_seg_packed_bytes[start_num + 13] ;
     end

     if(preamble_passthrough == 1) begin
       if     (this.temp_seg_packed_bytes.size() == 9)  begin this.dest_address[39:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 10)  begin this.dest_address[31:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 11)  begin this.dest_address[23:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 12)  begin this.dest_address[15:0] = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 13)  begin this.dest_address[7:0]  = 0; this.src_address[47:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 14)  begin this.src_address[47:0]  = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 15)  begin this.src_address[39:0]  = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 16)  begin this.src_address[31:0]  = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 17)  begin this.src_address[23:0]  = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 18) begin this.src_address[15:0]  = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 19) begin this.src_address[7:0]   = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 20) begin this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 21) begin this.eth_type_or_length[7:0] = 0; end
     end
     else begin
       if     (this.temp_seg_packed_bytes.size() == 9)    begin this.src_address[23:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 10)   begin this.src_address[15:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 11)   begin this.src_address[7:0] = 0; this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 12)   begin this.eth_type_or_length[15:0] = 0; end
       else if(this.temp_seg_packed_bytes.size() == 13)   begin this.eth_type_or_length[7:0] = 0; end
     end
  end
	     this.payload=new[0];


     `uvm_info(get_type_name(),$sformatf("this.extra_short_frame: %0d, this.extra_short_frame_size:%0d ", this.extra_short_frame, this.extra_short_frame_size), UVM_MEDIUM)

   endfunction // seg_unpack_bytes_extra_short_frame
   //----------------------------------------------------------------------------
   // PTP Functional Coverage
   // add display message of trans fields for which one wants to see coverage
   //----------------------------------------------------------------------------
   function string ptp_fcov_log(int frame_count);
     string s;
     s = {s,$sformatf("PTP_OPCODE[%0d] := %s\n",frame_count,m_ptp_op.name())};
     s = {s,$sformatf("is_ptp_seq[%0d] := %d\n",frame_count,is_ptp_seq)};
     s = {s,$sformatf("PL_SIZE[%0d] := %d\n",frame_count,payload.size())};
     s = {s,$sformatf("PTP_OFFSET[%0d] := %d\n",frame_count,ptp_offset)};
     s = {s,$sformatf("CF_OFFSET[%0d] := %d\n",frame_count,cf_offset)};
     s = {s,$sformatf("CS_OFFSET[%0d] := %d\n",frame_count,cs_offset)};
     s = {s,$sformatf("EB_OFFSET[%0d] := %d\n",frame_count,cs_offset)};
     s = {s,$sformatf("-------------------------------------------------------\n")};
     return s;
   endfunction : ptp_fcov_log

   task modify_v1(ptp_op_e m_ptp_op, bit[15:0] ptp_offset, bit[15:0] cs_offset, bit is_vlan, is_stacked_vlan,
      bit m_rx_crc_fwd_en, bit m_dut_crc_insert_en, bit tx_preamble_passthrough, bit [79:0] ts_bytes, bit [63:0] cf_bytes, bit [15:0] cs_bytes );

      byte offset_pos = 'd14;
      if (is_vlan == 1) offset_pos = 'd18;
      if (is_stacked_vlan == 1) offset_pos = 'd22;
      //if (tx_preamble_passthrough ==1 ) offset_pos =  offset_pos + 8; // refer FB#602624

       `uvm_info(get_type_name(),$sformatf("modify_v1::ptp_offset=%0d, cs_offset=%0d, \
          offset_pos=%0d ",
          ptp_offset, cs_offset, offset_pos), UVM_FULL)

      // Note: Copying the actual PTP field values
      for (byte i=0; i<8; i++) begin
         this.payload[(ptp_offset-offset_pos) + i] = ts_bytes[(7-i)*8+:8];
      end

      if( (m_ptp_op === INS_V1_W_EB) || (m_ptp_op === INS_V1_W_ASYM_LAT_EB) ) begin
         this.payload[cs_offset-offset_pos] = cs_bytes[15:8];
         this.payload[cs_offset-offset_pos+1] = cs_bytes[7:0];
      end

      if( (m_ptp_op === INS_V1_W_UDP_CS_0) || (m_ptp_op === INS_V1_W_ASYM_LAT_UDP_CS_0) ) begin
         this.payload[cs_offset-offset_pos] = 8'h0;
         this.payload[cs_offset-offset_pos+1] = 8'h0;
      end

     
      // Recalculate CRC for the expected packet as a PTP packet content is changed by the DUT.
      if (m_rx_crc_fwd_en == 1'b1) begin
         `uvm_info(get_type_name(),$sformatf("re_calc_crc32:before::rx_crc_passthrough_enabled :%b, disable_tx_crc_insertion: %b, this.fcs :%x,",
            m_rx_crc_fwd_en, m_dut_crc_insert_en, this.fcs), UVM_FULL)
         if (m_dut_crc_insert_en == 1'b1) calc_crc32();
         `uvm_info(get_type_name(),$sformatf("re_calc_crc32:after::this.fcs :%x",this.fcs), UVM_FULL)
      end

   endtask

   task modify_v2(ptp_op_e m_ptp_op, bit[15:0] ptp_offset, bit[15:0] cf_offset, bit[15:0] cs_offset,
      bit is_vlan, is_stacked_vlan, bit m_rx_crc_fwd_en, bit m_dut_crc_insert_en,
      bit tx_preamble_passthrough, bit [79:0] ts_bytes, bit [63:0] cf_bytes, bit [15:0] cs_bytes);

      byte offset_pos = 'd14;
      if (is_vlan == 1) offset_pos = 'd18;
      if (is_stacked_vlan == 1) offset_pos = 'd22;
      //if (tx_preamble_passthrough ==1 ) offset_pos =  offset_pos + 8; // refer FB#602624

      `uvm_info(get_type_name(),$sformatf("modify_v2::ptp_offset=%0d, cf_offset=%0d, \
         cs_offset=%0d, offset_pos=%0d ",
         ptp_offset, cf_offset, cs_offset, offset_pos), UVM_MEDIUM)

      // Copying the actual PTP field values 
      for (byte i=0; i<10; i++) begin
         this.payload[(ptp_offset-offset_pos) + i] =  ts_bytes[(9-i)*8+:8];
      end
      for (byte i=0; i<8; i++) begin
         // this.payload[(cf_offset-14) + i] = 8'hBB;
         this.payload[(cf_offset-offset_pos) + i] =  cf_bytes[(7-i)*8+:8];
      end
      if( (m_ptp_op === INS_V2_W_EB) || (m_ptp_op === INS_V2_W_ASYM_LAT_EB) ) begin
         this.payload[cs_offset-offset_pos] = cs_bytes[15:8];
         this.payload[cs_offset-offset_pos+1] = cs_bytes[7:0];
      end

      if( (m_ptp_op === INS_V2_W_UDP_CS_0) || (m_ptp_op === INS_V2_W_ASYM_LAT_UDP_CS_0) ) begin
         this.payload[cs_offset-offset_pos] = 8'h0;
         this.payload[cs_offset-offset_pos+1] = 8'h0;
      end

      // Recalculate CRC for the expected packet as a PTP packet content is changed by the DUT.
      if (m_rx_crc_fwd_en == 1'b1) begin
         `uvm_info(get_type_name(),$sformatf("re_calc_crc32:before::rx_crc_passthrough_enabled :%b, disable_tx_crc_insertion: %b, this.fcs :%x,",
            m_rx_crc_fwd_en, m_dut_crc_insert_en, this.fcs), UVM_FULL)
         if (m_dut_crc_insert_en == 1'b1) calc_crc32();
         `uvm_info(get_type_name(),$sformatf("re_calc_crc32:after::this.fcs :%x",this.fcs), UVM_FULL)
      end
      
      //Update seg_packed_bytes
      {<<{seg_packed_bytes}} = {<<{packed_bytes}};

   endtask
   
   task modify_cf(ptp_op_e m_ptp_op, bit[15:0] cf_offset, bit[15:0] cs_offset, bit is_vlan, is_stacked_vlan,
      bit m_rx_crc_fwd_en, bit m_dut_crc_insert_en, bit tx_preamble_passthrough, bit [79:0] ts_bytes, bit [63:0] cf_bytes, bit [15:0] cs_bytes);

      byte offset_pos = 'd14;
      if (is_vlan == 1) offset_pos = 'd18;
      if (is_stacked_vlan == 1) offset_pos = 'd22;
      //if (tx_preamble_passthrough ==1 ) offset_pos =  offset_pos + 8; // refer FB#602624

       `uvm_info(get_type_name(),$sformatf("modify_cf::cf_offset=%0d, cs_offset=%0d, \
          offset_pos=%0d",
          cf_offset, cs_offset, offset_pos), UVM_MEDIUM)

      // Copying the actual PTP field values 
      for (byte i=0; i<8; i++) begin
         this.payload[(cf_offset-offset_pos) + i] =  cf_bytes[(7-i)*8+:8];
      end

      if( (m_ptp_op === INS_CF_W_EB) || (m_ptp_op === INS_CF_W_ASYM_LAT_EB) ||(m_ptp_op === INS_ASYM_LAT_EB) || (m_ptp_op === INS_P2P_W_ASYM_LAT_EB) || (m_ptp_op === INS_P2P_W_EB) ) begin
            this.payload[cs_offset-offset_pos] = cs_bytes[15:8];
            this.payload[cs_offset-offset_pos+1] = cs_bytes[7:0];
      end

      if( (m_ptp_op === INS_CF_W_UDP_CS_0) || (m_ptp_op === INS_CF_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op === INS_ASYM_LAT_CS_0) || (m_ptp_op === INS_P2P_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op === INS_P2P_W_UDP_CS_0) ) begin
         this.payload[cs_offset-offset_pos] = 8'h0;
         this.payload[cs_offset-offset_pos+1] = 8'h0;
      end


       // Recalculate CRC for the expected packet as a PTP packet content is changed by the DUT.
       if (m_rx_crc_fwd_en == 1'b1) begin
          `uvm_info(get_type_name(),$sformatf("re_calc_crc32:before::rx_crc_passthrough_enabled :%b, disable_tx_crc_insertion: %b, this.fcs :%x,",
             m_rx_crc_fwd_en, m_dut_crc_insert_en, this.fcs), UVM_FULL)
          if (m_dut_crc_insert_en == 1'b1) calc_crc32();
          `uvm_info(get_type_name(),$sformatf("re_calc_crc32:after::this.fcs :%x",this.fcs), UVM_FULL)
       end

      //Update seg_packed_bytes
      {<<{seg_packed_bytes}} = {<<{packed_bytes}};      

   endtask   

function seg_pack_bytes(bit crc_passthrough,bit preamble_passthrough,bit covers_preamble); //TODO: remove covers_preamble
  int preamble_ptr;
  bit [7:0] temp_sfc_payload[];
  bit [7:0] temp_pfc_payload[];
  int crc_ptr,p_size;
  int empty_bytes; 
  int num_bytes;//store num bytes exclude payloads 

 
  bit sip_limit_tmp;


  `uvm_info ("seg_pack_bytes",$psprintf ("seg_packed bytes sip limit size %d Full list %p",sip_limit_info_per_pkt_seg_pack.size(),sip_limit_info_per_pkt_seg_pack),UVM_LOW)
  sip_limit_tmp = sip_limit_info_per_pkt_seg_pack.pop_back();
  `uvm_info ("seg_pack_bytes",$psprintf ("seg_packed bytes sip_limit_tmp %d",sip_limit_tmp),UVM_LOW)
  // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
  `uvm_info ("seg_pack_bytes",$psprintf ("seg packed bytes sip_limit_test %d",sip_limit_test),UVM_LOW)

 
  `uvm_info(get_type_name(),$sformatf("inside seg_pack_bytes crc_passthrough : %0d, preamble_passthrough: %0d",crc_passthrough, preamble_passthrough), UVM_LOW)
   foreach(payload[i])begin
      `uvm_info(get_type_name(),$sformatf("inside seg_pack_bytes payload %0h",payload[i]), UVM_HIGH)
   end  

//Rounding up the pcaked_bytes size in 8 bytes 
   if((frame_type == ETH_DATA_FRAME) || (frame_type == ETH_IPV4_FRAME) || 
     (frame_type == ETH_IPV6_FRAME) || (frame_type == ETH_USER_DEFINED_FRAME))
   begin
      `uvm_info(get_type_name(),$sformatf("inside seg_pack_bytes sip_limit_tmp %d",sip_limit_tmp), UVM_MEDIUM)
   	if(sip_limit_tmp)
         begin
   		p_size=$ceil((this.payload.size()+4)/8);
  		this.l_seg_packed_bytes 	     = new[p_size];
                 `uvm_info(get_type_name(),$sformatf("inside seg_pack_bytes sip_limit_tmp=%d l_seg_packed_bytes =%d " ,sip_limit_tmp,l_seg_packed_bytes.size()), UVM_MEDIUM)
         end
        else
         begin
   		p_size=$ceil((this.payload.size() + 22 + 4 )/8);
  		this.l_seg_packed_bytes 	     = new[p_size];
         end
   end
  if (frame_type == ETH_VLAN_FRAME)
  	begin
  		p_size=$ceil((this.payload.size() + 4 + 22 + 4)/8);
  		this.l_seg_packed_bytes 	     = new[p_size];
  	end

  if (frame_type == ETH_STACKED_VLAN_FRAME)
	  begin
	  	p_size=$ceil((this.payload.size() + 8 + 22 + 4)/8);
	  	this.l_seg_packed_bytes 	     = new[p_size];
	  end

  if (frame_type == ETH_JUMBO_DATA_FRAME)
	  begin
	  	p_size=$ceil((this.payload.size() + 22 + 4)/8);
	  	this.l_seg_packed_bytes 	     = new[p_size];
	  end

 if (frame_type == ETH_JUMBO_VLAN_FRAME)
	 begin
	 	p_size=$ceil((this.payload.size() + 4 + 22 + 4)/8);
	  	this.l_seg_packed_bytes 	     = new[p_size];
	  end

 if (frame_type == ETH_JUMBO_STACKED_VLAN_FRAME)
 	begin
 		p_size=$ceil((this.payload.size() + 8 + 22 + 4)/8);
  		this.l_seg_packed_bytes 	     = new[p_size];
  	end

 if((frame_type == ETH_SFC_FRAME) || (frame_type == ETH_PFC_FRAME) || (frame_type == ETH_MISC_CONTROL_FRAME))
 	begin
 		p_size=$ceil((this.payload.size() + 22 + 4) /8);
    	this.l_seg_packed_bytes 	     = new[p_size];
    end

   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function p_size: %0d -- 1",p_size), UVM_NONE)

  if(this.tx_fcs_error_insertion && crc_passthrough==0) begin
    //this.fcs = $urandom();
    this.fcs = ($urandom()%10 !==0) ? $urandom() : 32'h0 ;
    `uvm_info(get_type_name(),$sformatf("fcs error is inserted fcs:32'%h",this.fcs), UVM_LOW)
  end

 if((frame_type == ETH_DATA_FRAME) || (frame_type == ETH_JUMBO_DATA_FRAME) || (frame_type == ETH_IPV4_FRAME) || 
     (frame_type == ETH_IPV6_FRAME) || (frame_type == ETH_USER_DEFINED_FRAME)) 
 begin
      `uvm_info(get_type_name(),$sformatf("inside data pkt fcs -- 1: 32'%h",this.fcs), UVM_LOW)      
      //If crc passthrough - 1 then need to consider to add fcs to the data to drive
      if(sip_limit_tmp == 1)
      begin
         if(crc_passthrough == 1)begin
           {>>{this.l_seg_packed_bytes}} = {>>{this.payload,this.fcs}};
           num_bytes =($bits({this.eth_type_or_length,this.fcs})/8); 
          `uvm_info(get_type_name(),$sformatf("inside data pkt chethan num_bytes %d",num_bytes), UVM_LOW)      
         end else begin
           {>>{this.l_seg_packed_bytes}} = {>>{this.payload}};
           num_bytes = ($bits({this.eth_type_or_length})/8); 
          `uvm_info(get_type_name(),$sformatf("inside data pkt chethan num_bytes %d",num_bytes), UVM_LOW)      
         end
      end
      else
        begin
         if(crc_passthrough == 1)begin
           {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}};
           num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.fcs})/8); 
         end else begin
           {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}};
           num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length})/8); 
         end
       end
    `uvm_info(get_type_name(),$sformatf("inside data pkt fcs -- 2: 32'%h",this.fcs), UVM_LOW)
  end

  if((frame_type == ETH_VLAN_FRAME) || (frame_type == ETH_JUMBO_VLAN_FRAME))begin
      if(crc_passthrough == 1)begin
         {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length,this.payload,this.fcs}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length,this.fcs})/8);
      end else begin
         {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length,this.payload}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length})/8);
      end
  	end

  if((frame_type == ETH_STACKED_VLAN_FRAME) || (frame_type == ETH_JUMBO_STACKED_VLAN_FRAME))begin
      if(crc_passthrough == 1)begin
         {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length,this.payload,this.fcs}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length,this.fcs})/8);
      end else begin
         {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length,this.payload}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length})/8);
      end
 	end
  if(frame_type == ETH_SFC_FRAME) begin
     //{this.l_seg_packed_bytes[20] , this.l_seg_packed_bytes[21]}		 = 'h8808;
      sfc_pause_quanta = {this.payload[2],this.payload[3]}; 
      temp_sfc_payload = new[this.payload.size() -4];
      foreach(temp_sfc_payload[i]) begin
        temp_sfc_payload[i] = 0;
      end
     if(crc_passthrough == 1)begin
         {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h0,8'h1,sfc_pause_quanta,temp_sfc_payload,this.fcs}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h0,8'h1,sfc_pause_quanta,this.fcs})/8);
     end else begin
         {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h0,8'h1,sfc_pause_quanta,temp_sfc_payload}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h0,8'h1,sfc_pause_quanta})/8);
     end
  end
  if((frame_type == ETH_PFC_FRAME) || (frame_type == ETH_MISC_CONTROL_FRAME))  begin
     //{this.l_seg_packed_bytes[20] , this.l_seg_packed_bytes[21]}		 = 'h8808;

     this.pfc_pause_quanta[0] = {this.payload[4],this.payload[5]};   // supal : new_change  
     this.pfc_pause_quanta[1] = {this.payload[6],this.payload[7]};   // supal : new_change
     this.pfc_pause_quanta[2] = {this.payload[8],this.payload[9]};   // supal : new_change
     this.pfc_pause_quanta[3] = {this.payload[10],this.payload[11]}; // supal : new_change 
     this.pfc_pause_quanta[4] = {this.payload[12],this.payload[13]}; // supal : new_change 
     this.pfc_pause_quanta[5] = {this.payload[14],this.payload[15]}; // supal : new_change 
     this.pfc_pause_quanta[6] = {this.payload[16],this.payload[17]}; // supal : new_change 
     this.pfc_pause_quanta[7] = {this.payload[18],this.payload[19]};
     
     temp_pfc_payload = new[this.payload.size()-20];
     foreach(temp_pfc_payload[i]) begin
        temp_pfc_payload[i] = 0;
     end
    
     //TODO_GDR: check num_bytes 
     if(crc_passthrough == 1)begin
      {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h1,8'h1,this.payload[2],this.payload[3],this.pfc_pause_quanta,temp_pfc_payload,this.fcs}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h1,8'h1,this.payload[2],this.payload[3],this.fcs})/8);
     end else begin
      {>>{this.l_seg_packed_bytes}} = {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h1,8'h1,this.payload[2],this.payload[3],this.pfc_pause_quanta,temp_pfc_payload}};
         num_bytes = ($bits({this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,8'h1,8'h1,this.payload[2],this.payload[3]})/8);
     end
  end
  
  `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function frame_type %0s",frame_type.name()), UVM_NONE)
  `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function preamble %0h",preamble), UVM_NONE)
  `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function dest_address %0h",dest_address), UVM_NONE)
  `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function src_address %0h",src_address), UVM_NONE)
  `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function eth_type_or_length %0h",eth_type_or_length), UVM_NONE)
  `uvm_info(get_type_name(),$sformatf("inside data pkt fcs -- 3: 32'%h",this.fcs), UVM_LOW)
 
   foreach(payload[i])begin
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function payload[%0d] = %0h -- 1",i,payload[i]), UVM_HIGH)
   end  
  
   foreach(l_seg_packed_bytes[i])begin
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function l_seg_packed_bytes[%0d] = %0h -- 1",i,l_seg_packed_bytes[i]), UVM_HIGH)
   end    

   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function num_bytes: %0d -- 1",num_bytes), UVM_NONE)

  if (preamble_passthrough == 1 )
  begin
    preamble_ptr = 0;
  end
  else
  begin
    preamble_ptr = 1;
  end

  if(crc_passthrough == 1) begin //skip_
    crc_ptr = 0.5 ;
  end
  else
  begin
    crc_ptr = 0 ;
  end
  if(sip_limit_tmp == 1)  //skip_
    preamble_ptr = 0;
  
   `ifdef SHORT
	  $display("SHORT packet_size is %d",packet_size);
	  l_seg_packed_bytes=new[packet_size](l_seg_packed_bytes); 
	  seg_packed_bytes=new[packet_size];	

	  foreach(seg_packed_bytes[i])
	  seg_packed_bytes[i] = l_seg_packed_bytes[i+preamble_ptr];
	`else
	  //p_size=$ceil(preamble_ptr+crc_ptr);
          p_size=preamble_ptr; //TODO:crc_ptr //$floor(preamble_ptr+crc_ptr);
	

         if (sip_limit_tmp == 0 ) 
           seg_packed_bytes = new[l_seg_packed_bytes.size() - p_size];
         else
           seg_packed_bytes = new[l_seg_packed_bytes.size()];
	 
	  foreach(seg_packed_bytes[i])
           begin
            if (sip_limit_tmp == 0 ) 
	      seg_packed_bytes[i] = l_seg_packed_bytes[i+preamble_ptr];
            else
	      seg_packed_bytes[i] = l_seg_packed_bytes[i];
           end

   foreach(seg_packed_bytes[i])begin
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function seg_packed_bytes[%0d] = %0h ,seg_packed_bytes_size = %d -- 1",i,seg_packed_bytes[i],seg_packed_bytes.size()), UVM_HIGH)
   end    
     //Adjust num_bytes based on p_size (include or remove pp)

     num_bytes = num_bytes - (p_size*8);
  	`endif
   
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function p_size: %0d -- 2",p_size), UVM_NONE)
   
   //Process unused/empty bytes that was padded with 0 with stream operator previously
   //value must not be >= 8
   if(frame_type == ETH_PFC_FRAME) begin
      empty_bytes = (8*seg_packed_bytes.size) - (num_bytes + ($bits(pfc_pause_quanta)/8)+ temp_pfc_payload.size); //only payload 2 and 3 and has been added previously + 8 of the pfc_pause_quanta size
   end else if(frame_type ==ETH_SFC_FRAME) begin
      empty_bytes = (8*seg_packed_bytes.size) - (num_bytes + temp_sfc_payload.size); 
   end else begin
      empty_bytes = (8*seg_packed_bytes.size) - (num_bytes + payload.size); 
   end
   `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function empty_bytes: %0d, frame type %s, num_bytes %0d, payload_size %0d",empty_bytes,frame_type.name(), num_bytes, payload.size), UVM_NONE)

   //Padded back with X
   for(int i = 0; i< empty_bytes; i++)begin
      seg_packed_bytes[seg_packed_bytes.size() - 1][(i*8) +:8] = 8'hx;
   end 

   
  //byte order in seg BFM's each segment is left to right MSB goes first 
  foreach(seg_packed_bytes[i])
  	seg_packed_bytes[i] = {<<byte{seg_packed_bytes[i]}};
   
   foreach(seg_packed_bytes[i])begin
      `uvm_info(get_type_name(), $sformatf("Inside seg_pack_bytes function seg_packed_bytes[%0d] = %0h -- 2",i,seg_packed_bytes[i]), UVM_HIGH)
   end    

endfunction: seg_pack_bytes

//For TX/RX SEG monitors
virtual function seg_unpack_bytes(bit crc_passthrough,bit preamble_passthrough,string side="mac_rx_vip_tx");
  int array_index=0;
  bit [7:0] packet_type[];
  logic [63:0] temp_packed[];
  logic [7:0]  temp_bytes[$];
  bit sip_limit_tmp;

  `uvm_info ("seg_unpack_bytes",$psprintf ("seg_unpacked bytes sip limit size %d Full list %p",sip_limit_info_per_pkt_seg_unpack.size(),sip_limit_info_per_pkt_seg_unpack),UVM_LOW)
  sip_limit_tmp = sip_limit_info_per_pkt_seg_unpack.pop_back();
  `uvm_info ("seg_unpack_bytes",$psprintf ("seg_unpacked bytes sip_limit_tmp %d",sip_limit_tmp),UVM_LOW)
  // before unpacking, reverse the byte order in each segment so fields like preamble,dest address match expected packet format 
  `uvm_info ("seg_unpack_bytes",$psprintf ("seg unpacked bytes sip_limit_test %d",sip_limit_test),UVM_LOW)
  foreach(this.seg_packed_bytes[i])
  	this.seg_packed_bytes[i] = {<<byte{this.seg_packed_bytes[i]}};
 
 if(sip_limit_tmp == 0 )
 //if(this.sip_limit_test == 0 )
  begin 
    if (preamble_passthrough == 1 )
     begin
     	{>>{this.preamble,this.dest_address,this.src_address,packet_type}}={>>{this.seg_packed_bytes}} ;
     	temp_packed=this.seg_packed_bytes;
       array_index = 0 ;
     end
     else begin
       if(side == "vip_tx_mac_rx")  array_index = 0 ;
       else if(side == "vip_rx_mac_tx" ) array_index = 0 ;
       else array_index = 8 ;
       temp_packed={64'hfb555555_555555d5,this.seg_packed_bytes};
       
      foreach(temp_packed[i])begin
         `uvm_info(get_type_name(), $sformatf("Inside seg_unpack_bytes function temp_packed[%0d] = %0h",i,temp_packed[i]), UVM_HIGH)
      end      
       
       {>>{this.preamble,this.dest_address,this.src_address,packet_type}}={>>{temp_packed}} ;
      end
  end
 else // sip-limit_test == 1
  begin
     temp_packed=this.seg_packed_bytes;
     array_index = 0 ;
     frame_type = ETH_DATA_FRAME;
   {packet_type[0],packet_type[1]} = 'h500;
  end   
  //Put into a temporary byte so that we can remove empty bytes later
  {>>{temp_bytes}} = temp_packed;
  
  //Remove empty bytes
  repeat(empty_bytes)begin
      void'(temp_bytes.pop_back());
  end
  
  //Debug
  `uvm_info(get_type_name(),$sformatf("empty_bytes is: %0d",empty_bytes), UVM_LOW)
  `uvm_info(get_type_name(),$sformatf("crc_passthrough is: %0d",crc_passthrough), UVM_LOW)
  foreach(temp_packed[i])begin
   `uvm_info(get_type_name(),$sformatf("temp_packed[%0d]: %h",i,temp_packed[i]), UVM_HIGH)
  end
  foreach(temp_bytes[i])begin
   `uvm_info(get_type_name(),$sformatf("temp_bytes[%0d]: %h",i,temp_bytes[i]), UVM_HIGH)
  end  
  
  ////////////////////////////////////////////
  // ETH_DATA_FRAME
  ///////////////////////////////////////////
  if({packet_type[0],packet_type[1]} < 'h600)
  begin
    frame_type = ETH_DATA_FRAME;
    
 //if(this.sip_limit_test == 1 )
 if(sip_limit_tmp == 1 )
   this.payload 	     = new[(seg_packed_bytes.size()*8)];
 else
   begin
      if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
      else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4 ];
      else begin
        if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4];
		else  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index)];
      end
   end


 if (sip_limit_tmp == 1 )
 //if (sip_limit_test == 1 )
    begin
      if(crc_passthrough == 1)begin
         {>>{this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      end else begin
         {>>{this.payload}}={>>{temp_bytes}};
      end
    end
 else
    begin
      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};
      end 
    end
      
  end
  else
  begin //not data
    ////////////////////////////////////////////
    // ETH_JUMBO_VLAN_FRAME and ETH_VLAN_FRAME
    ///////////////////////////////////////////
    if(({packet_type[0],packet_type[1]} == 'h8100) && ({packet_type[4],packet_type[5]} != 'h8100))
    begin
 
      if({packet_type[4],packet_type[5]}== 'h8870)
      begin
        frame_type = ETH_JUMBO_VLAN_FRAME;
        is_vlan_f  = 1;
        is_svlan_f = 0;
 
        if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index) - 4 ];
        else
        begin
          if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index) - 4];
          else  this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
        end
      end //8870
      else
      begin
        frame_type = ETH_VLAN_FRAME;
        is_vlan_f  = 1;
        is_svlan_f = 0;
 
        if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index) - 4 ];
        else  begin
          if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index) - 4];
          else  this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
        end
      end //not 8870

      //{>>{this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
 

      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};//{>>{temp_packed}};
      end
 
    end
    ////////////////////////////////////////////////
    // JUMBO STACK VLAN FRAME and STACK VLAN FRAME//
    //////////////////////////////////////////////
    else if(( {packet_type[0],packet_type[1]} == 'h8100) && ( {packet_type[4],packet_type[5]}== 'h8100))
    begin
 
      vlan_tag = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index],this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]};
      stacked_vlan_tag = {this.packed_bytes[24 - array_index],this.packed_bytes[25 - array_index],this.packed_bytes[26 - array_index],this.packed_bytes[27 - array_index]};
 
      this.eth_type_or_length  = {this.packed_bytes[28 - array_index],this.packed_bytes[29 - array_index]};
 
      if({packet_type[8],packet_type[9]} == 'h8870)
      begin
        frame_type = ETH_JUMBO_STACKED_VLAN_FRAME;
        is_svlan_f = 1;
        is_vlan_f  = 0;
        if(side == "vip_tx_mac_rx")  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index) - 4 ];
        else
        begin
          if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index) - 4];
          else  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index)];
        end
      end //8870
      else
      begin
        frame_type = ETH_STACKED_VLAN_FRAME;
        is_svlan_f  = 1;
        is_vlan_f  = 0;
        if(side == "vip_tx_mac_rx")  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index) - 4 ];
        else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index) - 4 ];
        else
        begin
          if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index) - 4];
          else   this.payload 	     = new[(seg_packed_bytes.size()*8) - (30 - array_index)];
        end
      end//not 8870
      //{>>{this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
 
      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,vlan_tag,stacked_vlan_tag,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};
      end
      
    end
    ////////////////////////////////////////////
    // ETH_JUMBO_DATA_FRAME
    ///////////////////////////////////////////
    else if({packet_type[0],packet_type[1]}== 'h8870)
    begin
 
      frame_type = ETH_JUMBO_DATA_FRAME;
 
      if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
      else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4 ];
      else
      begin
        if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4];
	      else                      this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index)];
      end

      //{>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};
      end      
      
    end
    ////////////////////////////////////////////
    // ETH_CONTROL_FRAME
    ///////////////////////////////////////////
    else if({packet_type[0],packet_type[1]}== 'h8808)//flow control packets
    begin
      //frame_type = ETH_CONTROL_FRAME;
      this.eth_type_or_length  = {this.packed_bytes[20 - array_index],this.packed_bytes[21 - array_index]};
      if({this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]} == 16'h0101) frame_type = ETH_PFC_FRAME;
      if({this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]} == 16'h0001) frame_type = ETH_SFC_FRAME;
      if({this.packed_bytes[22 - array_index],this.packed_bytes[23 - array_index]} == 16'hFFFF) frame_type = ETH_MISC_CONTROL_FRAME;
      if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
      else if(side == "vip_rx_mac_tx" )  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4 ];
      else begin
        if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4];
	      else   this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index)];
	    end

	  //{>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
     
      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};//{>>{temp_packed}};
      end      
      
	    // PFC or SFC ?
        if (frame_type == ETH_SFC_FRAME) begin
        this.sfc_pause_quanta = {this.payload[2],this.payload[3]};
      	end
      	else begin // ETH_PFC_FRAME
        this.pfc_class_en_vect[0] = this.payload[2] ;
        this.pfc_class_en_vect[1] = this.payload[3] ;
        this.pfc_pause_quanta[0]  = {this.payload[4],this.payload[5]};
        this.pfc_pause_quanta[1]  = {this.payload[6],this.payload[7]};
        this.pfc_pause_quanta[2]  = {this.payload[8],this.payload[9]};
        this.pfc_pause_quanta[3]  = {this.payload[10],this.payload[11]};
        this.pfc_pause_quanta[4]  = {this.payload[12],this.payload[13]};
        this.pfc_pause_quanta[5]  = {this.payload[14],this.payload[15]};
        this.pfc_pause_quanta[6]  = {this.payload[16],this.payload[17]};
        this.pfc_pause_quanta[7]  = {this.payload[18],this.payload[19]};
      	end
 
    end
   ////////////////////////////////////////////
   // ETH_IPV4_FRAME & ETH_IPV6_FRAME
    ///////////////////////////////////////////
    else if(({packet_type[0],packet_type[1]} == 'h0800) || 
            ({packet_type[0],packet_type[1]} == 'h86DD))
    begin
      if ({packet_type[0],packet_type[1]} == 'h0800)
        frame_type = ETH_IPV4_FRAME;
      else 
        frame_type = ETH_IPV6_FRAME;
      
        if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
        else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4 ];
        else begin
          if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4];
	        else                      this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index)];
        end
       //{>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};//{>>{temp_packed}};
      end       
 
    end
  ////////////////////////////////////////////
    // ETH_DATA_FRAME (Oversized)
    ///////////////////////////////////////////
    else if({packet_type[0],packet_type[1]}>= 'h600)
    begin
      frame_type = ETH_USER_DEFINED_FRAME;
      
        if(side == "vip_tx_mac_rx") this.payload 	     = new[(seg_packed_bytes.size()*8) - (26 - array_index)];
        else if(side == "vip_rx_mac_tx" ) this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4 ];
        else begin
          if(crc_passthrough == 1)  this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index) - 4];
	        else                      this.payload 	     = new[(seg_packed_bytes.size()*8) - (22 - array_index)];
        end
        //{>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};//{>>{temp_packed}};
      if(crc_passthrough == 1)begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload,this.fcs}}={>>{temp_bytes}};
      end else begin
         {>>{this.preamble,this.dest_address,this.src_address,this.eth_type_or_length,this.payload}}={>>{temp_bytes}};
      end         
    end
    else begin
       `uvm_error("ETH Trans", $sformatf("Ethernet Frame has not been unpacked properly"));
    end
 
  end
 
  if(side == "vip_tx_mac_rx") begin
    if(crc_passthrough == 0) this.fcs = 0 ;
  end
 
endfunction: seg_unpack_bytes


virtual function temp_seg_bytes_t seg_to_avst_pack_bytes(logic[63:0] _seg_bytes[$]);
   temp_seg_bytes_t seg_bytes_r;
   
   foreach(_seg_bytes[i])begin
      for(int j=8; j>0; j--)begin
         //Push MSB first
         seg_bytes_r.push_back(_seg_bytes[i][((j*8)-1) -:8]);
      end
   end
   
   return seg_bytes_r;
endfunction: seg_to_avst_pack_bytes



   task ptp_v1_frame_mod(bit[63:0] timestamp_received, bit rx_preamble_passthrough);

      integer ptp_offset_used;

      pack_bytes(1'b0,rx_preamble_passthrough);
      if(rx_preamble_passthrough == 1) begin
      	ptp_offset_used = this.ptp_offset + 8;
      end
      else begin
      	ptp_offset_used = this.ptp_offset;
      end
      this.packed_bytes[ptp_offset_used]     = timestamp_received[63:56];
      this.packed_bytes[ptp_offset_used+1]   = timestamp_received[55:48];
      this.packed_bytes[ptp_offset_used+2]   = timestamp_received[47:40];
      this.packed_bytes[ptp_offset_used+3]   = timestamp_received[39:32];
      this.packed_bytes[ptp_offset_used+4]   = timestamp_received[31:24];
      this.packed_bytes[ptp_offset_used+5]   = timestamp_received[23:16];
      this.packed_bytes[ptp_offset_used+6]   = timestamp_received[15:8];
      this.packed_bytes[ptp_offset_used+7]   = timestamp_received[7:0];
      unpack_bytes(1'b0,rx_preamble_passthrough);
   endtask

   task reset_original_bytes(bit preamble_passthrough, is_vlan, is_stacked_vlan);

      byte offset_pos = 'd14;
      if (is_vlan == 1) offset_pos = 'd18;
      if (is_stacked_vlan == 1) offset_pos = 'd22;
      //if (tx_preamble_passthrough ==1 ) offset_pos =  offset_pos + 8; // refer FB#602624

      this.original_bytes = {this.payload[(this.ptp_offset)  -(offset_pos)],
                             this.payload[(this.ptp_offset+1)-(offset_pos)],
			                       this.payload[(this.ptp_offset+2)-(offset_pos)],
                             this.payload[(this.ptp_offset+3)-(offset_pos)],
			                       this.payload[(this.ptp_offset+4)-(offset_pos)],
                             this.payload[(this.ptp_offset+5)-(offset_pos)],
			                       this.payload[(this.ptp_offset+6)-(offset_pos)],
                             this.payload[(this.ptp_offset+7)-(offset_pos)],
			                       this.payload[(this.ptp_offset+8)-(offset_pos)],
                             this.payload[(this.ptp_offset+9)-(offset_pos)]};
                             this.original_cf_bytes = {this.payload[this.cf_offset-offset_pos],this.payload[this.cf_offset+1-offset_pos],
      		                   this.payload[this.cf_offset+2-offset_pos],this.payload[this.cf_offset+3-offset_pos],
      		                   this.payload[this.cf_offset+4-offset_pos],this.payload[this.cf_offset+5-offset_pos],
      		                   this.payload[this.cf_offset+6-offset_pos],this.payload[this.cf_offset+7-offset_pos]};
                             this.original_cs_bytes = {this.payload[this.cs_offset-offset_pos],this.payload[this.cs_offset+1-offset_pos]};
   endtask

   task modify_cf_bytes(bit[95:0] tod_delta, bit preamble_passthrough, is_vlan, is_stacked_vlan);

      bit [47:0] seconds_field;
      bit [47:0] nanosec_field;
      bit [15:0] fr_ns_field;
      byte offset_pos = 'd14;
      if (is_vlan == 1) offset_pos = 'd18;
      if (is_stacked_vlan == 1) offset_pos = 'd22;
      if (preamble_passthrough ==1) offset_pos =  offset_pos + 8;

      // Throw the cf.orig into 64-bits data
      // this.original_cf_bytes = {this.payload[this.cf_offset-offset_pos],this.payload[this.cf_offset+1-offset_pos],
      // 		this.payload[this.cf_offset+2-offset_pos],this.payload[this.cf_offset+3-offset_pos],
      // 		this.payload[this.cf_offset+4-offset_pos],this.payload[this.cf_offset+5-offset_pos],
      // 		this.payload[this.cf_offset+6-offset_pos],this.payload[this.cf_offset+7-offset_pos]};

      this.original_cf_bytes = this.ingress_ts[63:0];
      `uvm_info(get_type_name(), $sformatf("modify_cf_bytes:original_cf:%0h",this.original_cf_bytes), UVM_MEDIUM)

      // Add the delta, assumption: no rollover
      seconds_field = tod_delta[95:48];
      fr_ns_field   = tod_delta[15:0];
      `uvm_info(get_name(),$sformatf("modify_cf_bytes : tod_delta := 0x%0h (decimal = %0d)",tod_delta,tod_delta),UVM_LOW)
      `uvm_info(get_name(),$sformatf("modify_cf_bytes : seconds_field := 0x%0h (decimal = %0d)",seconds_field,seconds_field),UVM_LOW)

      //Conversion logic for tod_delta
      if (seconds_field > 0) begin
         tod_delta[63:0] = tod_delta[47:0] + (((seconds_field) * (10**9)) << 16); // converting from s to ns
      end
      else begin
         tod_delta[63:0] = tod_delta[47:0];
      end

      `uvm_info(get_name(),$sformatf("modify_cf_bytes : modified tod_delta := 0x%0h (decimal = %0d)",tod_delta,tod_delta),UVM_LOW)
      `uvm_info(get_name(),$sformatf("modify_cf_bytes : seconds_field := 0x%0h (decimal = %0d)",seconds_field,seconds_field),UVM_LOW)
      `uvm_info(get_name(),$sformatf("modify_cf_bytes : nanosec_field := 0x%0h (decimal = %0d)",nanosec_field,nanosec_field),UVM_LOW)

      this.original_cf_bytes = this.original_cf_bytes + tod_delta[63:0];
      `uvm_info(get_type_name(), $sformatf("modify_cf_bytes:updated_cf:%0h, tod_delta=%0h",
         this.original_cf_bytes, tod_delta), UVM_MEDIUM)

      // Push the new CF bytes back onto the payload bytes
      for (int i=0; i<8; i++)begin
         this.payload[(this.cf_offset + (7-i)) - offset_pos] = this.original_cf_bytes[i*8+:8];
         `uvm_info(get_type_name(), $sformatf("modify_cf_bytes:update_payload_bytes: %0h, cf_bytes=%0h",
            this.payload[(this.cf_offset + i) - offset_pos], this.original_cf_bytes[i*8+:8]), UVM_MEDIUM)
      end

   endtask

   function void set_ptp_op (ptp_op_e mode);
      this.m_ptp_op = mode;
      `uvm_info(get_type_name(), $sformatf("ptp_op::mode=%s, ",this.m_ptp_op), UVM_FULL)
   endfunction

endclass

`endif
