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


`ifndef ETH_REF_MODEL
`define ETH_REF_MODEL

`uvm_analysis_imp_decl(_vip_tx)
`uvm_analysis_imp_decl(_vip_rx)
`uvm_analysis_imp_decl(_reset_port)
`uvm_analysis_imp_decl(_avmm_bus_in)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_0)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_1)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_2)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_3)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_4)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_5)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_6)
`uvm_analysis_imp_decl(_xcvr_avmm_bus_in_7)

`ifdef DEVICE_SM
`uvm_analysis_imp_decl(_mac_avmm_bus_in)
`uvm_analysis_imp_decl(_rcfgf_avmm_bus_in)
`endif

`uvm_analysis_imp_decl(_stat_checker_tx)
`uvm_analysis_imp_decl(_vector_tx)
`uvm_analysis_imp_decl(_decoder_rx)
`uvm_analysis_imp_decl(_avst_rx)


//Class: eth_ref_model
//This class is a referance model to process the expected packet and updating expected registers value
class eth_ref_model extends uvm_component;
eth_env_env eth_env;

 `ifdef ENABLE_ETH_VIP
 
 //Port: item_collected_vip_tx
 //This port receives trasmitted item from vip monitor
 uvm_analysis_imp_vip_tx #(svt_ethernet_transaction, eth_ref_model) item_collected_vip_tx;
 
 //Port: item_collected_vip_tx
 //This port receives item received by vip monitor
 uvm_analysis_imp_vip_rx #(svt_ethernet_transaction, eth_ref_model) item_collected_vip_rx;
 
 //Port: eth_vector_tx
 //This port receives eth_packet item from layering mon
 uvm_analysis_imp_vector_tx #(eth_packet , eth_ref_model) eth_vector_tx; 
 
 `endif

 //Port: item_collected_reset_port
 //This port receives item collected by reset uvc monitor
 uvm_analysis_imp_reset_port #(reset_transaction, eth_ref_model) item_collected_reset_port;

 //Port: eth_tx_to_dest
 //This port sends eth_packet item to scoreboard
 uvm_analysis_port #(eth_packet) eth_tx_to_dest; 

 //Port: eth_rx_to_dest
 //This port sends eth_packet item to scoreboard
 uvm_analysis_port #(eth_packet) eth_rx_to_dest; 
 
 //Port: eth_stat_tx
 //This port receives eth_packet item from layering mon
 uvm_analysis_imp_stat_checker_tx #(eth_packet , eth_ref_model) eth_stat_tx; 
 
 //Port: eth_decoder_rx
 //This port receives eth_packet item from layering mon
 uvm_analysis_imp_decoder_rx #(eth_packet , eth_ref_model) eth_decoder_rx; 
 //Port: item_collected_avst_rx
 //This port receives item received by AVST RX monitor
 uvm_analysis_imp_avst_rx #(eth_packet, eth_ref_model) eth_avst_rx;


 //Port: vip_tx_to_sb
 //This port sends vector_uvc_packet item to scoreboard
 uvm_analysis_port #(vector_uvc_packet) vip_tx_to_sb; 

 //Port: vector_tx_to_sb
 //This port sends vector_uvc_packet item to scoreboard
 uvm_analysis_port #(vector_uvc_packet) vector_tx_to_sb; 
 
 //Port: avmm_bus_in
 //This port receives the avmm item from monitor
 uvm_analysis_imp_avmm_bus_in #(altuvm_avalon_mm_req_base, eth_ref_model) avmm_bus_in;

`ifdef DEVICE_SM
 uvm_analysis_imp_avmm_bus_in #(altuvm_avalon_mm_req_base, eth_ref_model) mac_avmm_bus_in;
 uvm_analysis_imp_avmm_bus_in #(altuvm_avalon_mm_req_base, eth_ref_model) rcfg_avmm_bus_in;

`endif

 uvm_analysis_imp_xcvr_avmm_bus_in_0 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_0;
 uvm_analysis_imp_xcvr_avmm_bus_in_1 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_1;
 uvm_analysis_imp_xcvr_avmm_bus_in_2 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_2;
 uvm_analysis_imp_xcvr_avmm_bus_in_3 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_3;
 uvm_analysis_imp_xcvr_avmm_bus_in_4 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_4;
 uvm_analysis_imp_xcvr_avmm_bus_in_5 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_5;
 uvm_analysis_imp_xcvr_avmm_bus_in_6 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_6;
 uvm_analysis_imp_xcvr_avmm_bus_in_7 #(altuvm_avalon_mm_req_base, eth_ref_model) xcvr_avmm_bus_in_7;

 //Port: vip_tx_to_rxmac_cov
 //This port sends eth_packet item to scoreboard
 uvm_analysis_port #(eth_packet) vip_tx_to_rxmac_cov; 


 //Object: reg_model
 //This is register model handle
 registers_urm reg_model;

 xcvr_reconfig_urm xcvr_reg_model[8];

 typedef virtual eth_fc_interface v_if2;
   v_if2 rx_fc_if;
 typedef virtual eth_sideband_interface vif;
 vif sideband_if; 
   virtual spy_interface spy_if;
   virtual reset_if reset_if; 
 //Object: transaction_id_tx
 //This is vip tx packet transaction count 
 int transaction_id_tx=0;
 
 //Object: transaction_id_rx
 //This is vip rx packet transaction count 
 int transaction_id_rx=0;
   
 //Object: transaction_id_vip_tx_dut_rx
 //This is vip_tx_dut_rx packet transaction count for vector
 int transaction_id_vip_tx_dut_rx=0;
 
 //Object: transaction_id_dut_tx_vip_rx
 //This is dut_tx_vip_rx packet transaction count for vector 
 int transaction_id_dut_tx_vip_rx=0;

 //Object: enable_rx_drops
 //This is to control if bad/malformed frames received by RXMAC should be dropped 
   bit enable_rx_drops;

   //Object: drop_count
   //This is to keep count of frames being dropped by RXMAC
   int drop_count;  
   bit sip_limit =0;  

   //Object: vip_tx_count
   //This is to keep count of frames transmitted from VIP_TX
   int vip_tx_count;  
   int vip_rx_count;  

   bit truncated_frame = 0;
//rx stats variables  
  bit [63:0] rx_fragment_cntr,rx_jabber_cntr,rx_fcs_cntr,rx_fcserr_okpkt,rx_mcast_data_err_cntr,rx_bcast_data_err_cntr,rx_ucast_data_err_cntr,rx_mcast_ctrl_err_cntr,rx_bcast_ctrl_err_cntr,rx_ucast_ctrl_err_cntr,
             rx_pause_err_cntr,rx_64b_cntr,rx_65bto127b_cntr,rx_128bto255b_cntr,rx_256bto511b_cntr,rx_512bto1023b_cntr,rx_1024bto1518b_cntr,rx_1519btomax_cntr,rx_oversize_cntr,rx_mcast_data_ok_cntr,rx_ucast_data_ok_cntr,
             rx_bcast_data_ok_cntr,rx_mcast_ctrl_ok_cntr,rx_ucast_ctrl_ok_cntr,rx_bcast_ctrl_ok_cntr,rx_pause_ok_cntr,rx_runt_cntr,rx_payload_ok_cntr,rx_frame_ok_cntr,rx_frame_dropped_cntr,rx_malformed_cntr,rx_pfc_ok_cntr,rx_pfc_err_cntr,rx_badlt_frame,rx_lenerr_frame,rx_st_frame,rxmac_adapt_dropped_cntr,rx_stats_framesOK,rx_stats_framesErr,rx_stats_ifErrors;
  int frame_size_rx;
//tx stats variables  
  bit [63:0] tx_fragment_cntr,tx_jabber_cntr,tx_fcs_cntr,tx_fcserr_okpkt,tx_mcast_data_err_cntr,tx_bcast_data_err_cntr,tx_ucast_data_err_cntr,tx_mcast_ctrl_err_cntr,tx_bcast_ctrl_err_cntr,tx_ucast_ctrl_err_cntr,
             tx_pause_err_cntr,tx_64b_cntr,tx_65bto127b_cntr,tx_128bto255b_cntr,tx_256bto511b_cntr,tx_512bto1023b_cntr,tx_1024bto1518b_cntr,tx_1519btomax_cntr,tx_oversize_cntr,tx_mcast_data_ok_cntr,tx_ucast_data_ok_cntr,
             tx_bcast_data_ok_cntr,tx_mcast_ctrl_ok_cntr,tx_ucast_ctrl_ok_cntr,tx_bcast_ctrl_ok_cntr,tx_pause_ok_cntr,tx_runt_cntr,tx_payload_ok_cntr,tx_frame_ok_cntr,tx_frame_dropped_cntr,tx_malformed_cntr,tx_pfc_ok_cntr,tx_pfc_err_cntr,tx_badlt_frame,tx_lenerr_frame,tx_st_frame,tx_stats_framesOK,tx_stats_framesErr,tx_stats_ifErrors;
  int frame_size_tx;
  int tx_octet_error;
  int malformed_frame_cnt;
  bit [47:0] rx_pause_addr;
  bit [47:0] tx_pfc_daddr;
  bit [47:0] tx_pfc_saddr;

//Random snapshot variable

   bit [31:0] shadow_req_tx;
   bit [31:0] 	shadow_req_grant_tx;
   bit 		snap_req_grant_tx;
   bit [31:0] shadow_req_rx;
   bit [31:0] 	shadow_req_grant_rx;
   bit 		snap_req_grant_rx;
   //frame size indicator
   bit [31:0] shadow_req;
   int 	 max_extra_short_frame_size;
   bit 	 malformed_test_rx = 1'b0;
   bit 	 malformed_case = 1'b0;
   bit   tx_underflow_case = 1'b0;
   bit [31:0]  adapt_cntr;
   bit   tx_stats_clr;
   bit   rx_stats_clr;
   string  file_vip_tx_trans_log = "vip_tx_trans.log";
   integer file_vip_tx_trans_log_id;// = $fopen(file_vip_tx_trans_log,"a");

   string  file_vip_rx_trans_log = "vip_rx_trans.log";
   integer file_vip_rx_trans_log_id;// = $fopen(file_vip_rx_trans_log,"a");

   // JA: FB 524678; record previous frame_size to decide whether to drop/keep frame
   eth_packet packets_drop_decide[2];
   int 	   cumulative_ipg=0;
   bit 	   first_rx_packet=1;
   time    new_packet_time;
   int 	   packets_drop_decide_idx=0;
   bit 	   packet_stall=0;
   bit [31:0] rx_control_frame_fwd;
   bit [31:0] en_rxsfc_pfc;
   bit [31:0] en_txsfc_pfc;
   bit [47:0] rx_pause_daddr; 
   bit     dis_fc_assertion;
   bit [7:0] en_bit_vector;
   bit [7:0] rx_pfc_en;
   int     dist_between_two_starts; 
   bit     frame_already_dropped;
   string  env_name;

   // Added by atiwari for sip reg prediction
   bit sip=0;
   bit [2:0] eth_rate,rsfec_type,flow_control_mode,client_intf;
   bit anlt_enable,modulation_type,ptp_enable,xcvr_type;
   bit [3:0] num_lanes;
   bit rst_ack_n,tx_rst_ack_n,rx_rst_ack_n;
   bit [2:0] tx_lane_current_state,rx_lane_current_state;
   bit tx_lanes_stable,rx_pcs_ready,rx_dsk_done;
   bit rfault,lfault;
   bit [15:0] ehip_tx_transfer_ready,ehip_rx_transfer_ready;
   bit [31:0] clk_tx_khz,clk_rx_khz,clk_pll_khz,clk_tx_div_khz,clk_rec_div64_khz,clk_rec_div_khz;
   bit enable_rsfec;
   int sip_start_addr = 'h100;
   int sip_end_addr   = 'h0FFC;
   bit [31:0] gui_option_reg,eth_reset_status_reg,phy_tx_pll_locked_reg,phy_eiofreq_locked_reg, pcs_status_reg, link_fault_status_reg,aib_transfer_ready_status_reg;
   bit [47:0] trans_err_status;
   bit eop_pkt_corrupt;
   uvm_cmdline_processor inst;   
   string m_sequence; 
   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;

  // Local variables for supplementary_addr_chk_seq
  bit[47:0] primary_addr; 
  bit[47:0] supplementary_addr; 
  bit[3:0]  supplementary_addr_sel;
  bit EN_ALLUCAST =1'b0 ;
  bit EN_ALLMCAST =1'b0 ;

//Compliance testing
`ifdef ENABLE_ETH_VIP
  `ifdef COMPL_TC
    `ifdef ETH_MULTI_PORT
       virtual svt_ethernet_signal_mapping_multi_port_if #(.NUMBER_OF_PORTS(`NUM_OF_PORTS)) signal_map_if;
    `else
       virtual svt_ethernet_signal_mapping_if signal_map_if;
    `endif
  `endif
`endif

 
//Factory declaration
`uvm_component_utils_begin(eth_ref_model)
`uvm_component_utils_end

//Function: new
//This is class constructor and used to create port instances
function new(string name = "eth_ref_model",uvm_component parent = null);
  super.new(name, parent);
  
  `ifdef ENABLE_ETH_VIP
   item_collected_vip_tx = new("item_collected_vip_tx", this);
   item_collected_vip_rx = new("item_collected_vip_rx", this);
   eth_vector_tx = new("eth_vector_tx", this); //Vector port 
  `endif

   eth_tx_to_dest = new("eth_tx_to_dest", this); 
   eth_rx_to_dest = new("eth_rx_to_dest", this); 
   vip_tx_to_rxmac_cov = new("vip_tx_to_rxmac_cov ", this); 
   eth_stat_tx = new("eth_stat_tx", this); 
  
   vip_tx_to_sb = new("vip_tx_to_sb", this); 
   vector_tx_to_sb = new("vector_tx_to_sb", this); 
   
   item_collected_reset_port = new("item_collected_reset_port", this); 
   
   avmm_bus_in = new("avmm_bus_in", this); 

   `ifdef DEVICE_SM
   mac_avmm_bus_in = new("mac_avmm_bus_in", this); 
   rcfg_avmm_bus_in = new("rcfg_avmm_bus_in", this);
   `endif


   xcvr_avmm_bus_in_0 = new("xcvr_avmm_bus_in_0", this); 
   xcvr_avmm_bus_in_1 = new("xcvr_avmm_bus_in_1", this);
   xcvr_avmm_bus_in_2 = new("xcvr_avmm_bus_in_2", this); 
   xcvr_avmm_bus_in_3 = new("xcvr_avmm_bus_in_3", this); 
   xcvr_avmm_bus_in_4 = new("xcvr_avmm_bus_in_4", this); 
   xcvr_avmm_bus_in_5 = new("xcvr_avmm_bus_in_5", this); 
   xcvr_avmm_bus_in_6 = new("xcvr_avmm_bus_in_6", this); 
   xcvr_avmm_bus_in_7 = new("xcvr_avmm_bus_in_7", this); 
 

   eth_decoder_rx = new("eth_decoder_rx",this);
   eth_avst_rx = new("eth_avst_rx",this);

   // Get Dyn cfg obj ///PRASH NOA Fix forbelow PCSONLY object access
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end
`ifdef ENABLE_ETH_VIP
  `ifdef COMPL_TC
    `ifdef ETH_MULTI_PORT
       uvm_config_db#(virtual svt_ethernet_signal_mapping_multi_port_if#(.NUMBER_OF_PORTS(`NUM_OF_PORTS)))::get(this,"", "signal_map_if", signal_map_if);
    `else
       uvm_config_db#(virtual svt_ethernet_signal_mapping_if)::get(this,"", "signal_map_if", signal_map_if);
    `endif
  `endif
`endif


   ////
   if (dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG}) begin
   uvm_config_db#(v_if2)::get(this, "", "mst_if", rx_fc_if);
   if (rx_fc_if == null)  `uvm_fatal("NO_CONN", "failed to get fc interface in rx pkt adapter"); 
   foreach(rx_fc_if.xoff[i]) rx_fc_if.xoff[i]=0;
   foreach(rx_fc_if.xon[i]) rx_fc_if.xon[i]=0;
   end
   if (!uvm_config_db#(vif)::get(this, "", "mst_if", sideband_if)) begin
      `uvm_fatal("AGT/NOVIF", "No virtual interface specified for this agent instance")
   end
   // Added by atiwari2
   // Reset IF
   if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
        `uvm_fatal("eth_ref_model", "failed to get spy_interface intf");
   end
// SPY IF
   if(!uvm_config_db#(virtual reset_if)::get(this, "", "slv_if", reset_if)) begin
       `uvm_fatal("eth_ref_model", "failed to get reset_if intf");
   end

   enable_rx_drops=1'b1;
   drop_count=0;
   vip_tx_count=0;
   cumulative_ipg=0;
   first_rx_packet=1;
   new_packet_time = 0;
   packets_drop_decide_idx=0;

endfunction: new

function void build_phase(uvm_phase phase);
    
    if(!uvm_config_db#(string)::get(this,"","env_name", env_name)) begin
        `uvm_fatal("env_name_ref_model", "failed to get env_name");
    end        
    
   inst = uvm_cmdline_processor::get_inst();
   inst.get_arg_value("+m_sequence=",m_sequence);

endfunction: build_phase


function void connect_phase(uvm_phase phase);           
    
    file_vip_tx_trans_log_id = $fopen({env_name,"_",file_vip_tx_trans_log},"a");
    file_vip_rx_trans_log_id = $fopen({env_name,"_",file_vip_rx_trans_log},"a");

endfunction:connect_phase

//function void write_vector_tx(eth_packet t);

//endfunction

/* Gets the register or field value from ral and return as  bit vector*/
function int gdr_ral_get(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    //case (dyn_rcfg_obj_inst.speed)
    //_10G : regname = {"e25_",regname};
    //_25G : regname = {"e25_",regname};
    //_50G : regname = {"e50_",regname};
    //_40G : regname = {"e100_",regname};
    //_100G : regname = {"e100_",regname};
    //_200G : regname = {"e200_",regname};
    //_400G : regname = {"e400_",regname};
    //endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        `uvm_info("ETH_REF_MODEL",$psprintf("RAL get register :%0s, value %0h",reg_l.get_name(),reg_l.get()),UVM_MEDIUM);
        if(fldname == "") return reg_l.get();
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
          `uvm_info("ETH_REF_MODEL",$psprintf("RAL get field :%0s, value %0h",fldname,fld_l.get()),UVM_MEDIUM);
          return fld_l.get();
        end
      end
    end
    `uvm_fatal("eth_ref_model", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

function int gdr_ral_mirror(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    //case (dyn_rcfg_obj_inst.speed)
    //_10G : regname = {"e25_",regname};
    //_25G : regname = {"e25_",regname};
    //_50G : regname = {"e50_",regname};
    //_40G : regname = {"e100_",regname};
    //_100G : regname = {"e100_",regname};
    //_200G : regname = {"e200_",regname};
    //_400G : regname = {"e400_",regname};
    //endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        `uvm_info("ETH_REF_MODEL",$psprintf("RAL mirror register :%0s, value %0h",reg_l.get_name(),reg_l.get_mirrored_value()),UVM_MEDIUM);
        if(fldname == "") return reg_l.get_mirrored_value();
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
          `uvm_info("ETH_REF_MODEL",$psprintf("RAL mirror register :%0s, value %0h",fldname,fld_l.get_mirrored_value()),UVM_MEDIUM);
          return fld_l.get_mirrored_value();
        end
      end
    end
    `uvm_fatal("eth_ref_model", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction


/* Gets the register or field value from ral and return as  bit vector*/
function void gdr_ral_predict(string regname, string fldname="",uvm_reg_data_t value, uvm_predict_e kind, uvm_reg_map map);
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    //case (dyn_rcfg_obj_inst.speed)
    //_10G : regname = {"e25_",regname};
    //_25G : regname = {"e25_",regname};
    //_50G : regname = {"e50_",regname};
    //_40G : regname = {"e100_",regname};
    //_100G : regname = {"e100_",regname};
    //_200G : regname = {"e200_",regname};
    //_400G : regname = {"e400_",regname};
    //endcase 
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        if(fldname == "") begin
          `uvm_info("ETH_REF_MODEL",$psprintf("RAL predict register :%0s, value %0h",reg_l.get_name(),value),UVM_MEDIUM);
          reg_l.predict(.value(value), .kind(kind), .map(map));
          return;
        end
        //else begin
        //  fld_l  = reg_l.get_field_by_name(fldname);
        //  return fld_l.get();
        //end
      end
    end
    `uvm_fatal("eth_ref_model", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

 `ifdef ENABLE_ETH_VIP

//Function: print_transaction
//This function prints the ethernet frame in specific formate
 function void print_transaction(svt_ethernet_transaction trans,bit [95:0] side = "VIP TX FRAME",int trans_cnt=0,integer file_id=0);
  reg [79:0] print_buffer;
  bit [7:0] temp_buffer_reg;
  int temp_pointer;
  bit [11:0] column_length; 
  string print_message;

  print_message = {print_message,"\n"};
  print_message = {print_message,"+-----+--+--+--+--+--+--+--+--+--+--+\n"};
  print_message = {print_message,$psprintf("|           %0s:%0d           \n",side,trans_cnt)};
  print_message = {print_message,"+-----+--+--+--+--+--+--+--+--+--+--+\n"};
  print_message = {print_message,"| NDX | 0| 1| 2| 3| 4| 5| 6| 7| 8| 9|\n"};
  print_message = {print_message,"+-----+--+--+--+--+--+--+--+--+--+--+\n"};
  foreach(trans.complete_data_frame[i]) begin
    temp_buffer_reg = trans.complete_data_frame[i];
    print_buffer = {temp_buffer_reg,print_buffer[79:8]};
    temp_pointer = temp_pointer + 1;

    if(i == (trans.complete_data_frame.size() - 1)) begin
      while(temp_pointer != 10) begin
        print_buffer = {8'hxx,print_buffer[79:8]};
        temp_pointer = temp_pointer + 1;
      end
      print_message = {print_message,$psprintf("|%d |%h|%h|%h|%h|%h|%h|%h|%h|%h|%h|\n",column_length,
                                                                                       print_buffer[7:0],
                                                                                       print_buffer[15:8],
                                                                                       print_buffer[23:16],
                                                                                       print_buffer[31:24],
                                                                                       print_buffer[39:32],
                                                                                       print_buffer[47:40],
                                                                                       print_buffer[55:48],
                                                                                       print_buffer[63:56],
                                                                                       print_buffer[71:64], 
                                                                                       print_buffer[79:72])}; 
    end
    else begin
      if(temp_pointer == 10) begin
        print_message = {print_message,$psprintf("|%d |%h|%h|%h|%h|%h|%h|%h|%h|%h|%h|\n",column_length,
                                                                                         print_buffer[7:0],
                                                                                         print_buffer[15:8],
                                                                                         print_buffer[23:16],
                                                                                         print_buffer[31:24],
                                                                                         print_buffer[39:32],
                                                                                         print_buffer[47:40],
                                                                                         print_buffer[55:48],
                                                                                         print_buffer[63:56],
                                                                                         print_buffer[71:64], 
                                                                                         print_buffer[79:72])}; 
        temp_pointer = 0;
        print_buffer = {80{1'bx}};
        column_length = column_length + 1;
      end
    end  
  end  
  print_message = {print_message,"+-----+--+--+--+--+--+--+--+--+--+--+\n"};
  $fwrite(file_id,"%s\n",print_message);
  `uvm_info("print_transaction",$psprintf("%s",print_message),UVM_DEBUG);
endfunction

//Function: write_vip_tx
//This function gets the trasmitted vip ethernet frame and converts into ethenet packet and send to scoreboard as expected packet
function void write_vip_tx(svt_ethernet_transaction t);
   string func_name = "write_vip_tx";
   eth_packet trans;
   bit pp;
   bit rx_vlan_disable;
   bit [31:0] rx_ctrl_reg;
   bit [31:0] rx_size_reg;
   bit [31:0] rx_pfc_control;
   //bit [31:0] rxmac_ctrl;
   bit [7:0]  rm_pad_payload[]; // Used to remove padded data from transaction payload
   bit fe_in_frame=0;
   int frame_size_l;
   int temp;
   int val=0;
   bit pad_removal;
   uvm_reg 	regs;
   uvm_reg      rxmac_adapt_dropped_31_0_reg;
   svt_ethernet_transaction t_clone;
   trans_err_status=t.trans_err_check_status;
   
   `uvm_info(get_name(), $sformatf("%s: vip packet is received at vip tx analysis port...",func_name),UVM_MEDIUM)
   //`uvm_info(get_name(),$psprintf("Packet received in scoreboard write_tx  function  : \n",t.print),UVM_MEDIUM);
    t.print;
   `uvm_info(get_name(),$psprintf("Packet received in scoreboard write_tx trans_err_check_status: %0x \n",t.trans_err_check_status),UVM_MEDIUM);
   eop_pkt_corrupt = eth_env.corrupt_eop();
   `uvm_info(get_name(),$sformatf("eop_pkt_corrupt is %0d",eop_pkt_corrupt),UVM_MEDIUM);
   `uvm_info(get_name(), $sformatf("Start offset of current frame is %0d",dist_between_two_starts),UVM_MEDIUM)
   if (malformed_test_rx==1'b1)
     return;
   
   $cast(t_clone,t.clone());
   if (t_clone.complete_data_frame.size==0) begin       
      `uvm_error("eth_ref_model_write_tx_empty_frame_err", $sformatf("%s: Empty frame received from Synopsys VIP monitor",func_name));
      //return;
   end
   vip_tx_count++;
   trans = eth_packet::type_id::create("trans");
   trans.packed_bytes=new[t_clone.complete_data_frame.size](t_clone.complete_data_frame);
   // JA: Save start offset
   trans.start_offset_bytes = dist_between_two_starts;
   
   rx_ctrl_reg = gdr_ral_get("rx_padcrc_control"); //gdr_ral_get("mac_cfg_mac_crc_config");
   rx_ctrl_reg[0] = ~rx_ctrl_reg[0];
   `uvm_info("ref model ", $sformatf(" rx_ctrl_reg %0d",rx_ctrl_reg), UVM_NONE);
   rx_size_reg = gdr_ral_get("mac_cfg_max_rx_size_config");
   `uvm_info("ref model ", $sformatf(" write value in mac_cfg_rxmac_control , rx_size_reg %0d",rx_size_reg), UVM_MEDIUM);
   rx_vlan_disable = gdr_ral_get("rx_vlan_detection","rx_vlan_detection_disable");
   `uvm_info("ref model ", $sformatf(" write_vip_tx : rx vlan detection=%0d", rx_vlan_disable), UVM_MEDIUM);
   pad_removal = rx_ctrl_reg[1];
   `uvm_info("ref model ", $sformatf(" write_vip_tx : pad removal is set to %0d", pad_removal), UVM_MEDIUM);

      rx_control_frame_fwd = gdr_ral_get("rx_frame_control");
  // chethan rx_pause_fwd = gdr_ral_get("rx_frame_control","FWD_PAUSE"); //gdr_ral_get("mac_cfg_rx_pause_fwd","rx_pause_fwd");
   //DM_TODO: en_rxsfc_pfc = gdr_ral_get("mac_cfg_rxsfc_ehip_cfg");
   //DM_TODO: rx_pause_daddr[31:0] = gdr_ral_get("mac_cfg_rx_pause_daddrl");
   //DM_TODO: rx_pause_daddr[47:32] = gdr_ral_get("mac_cfg_rx_pause_daddrh");
   rx_pfc_control = gdr_ral_get("rx_pfc_control"); //gdr_ral_get("mac_cfg_rx_pause_enable");

   pp = gdr_ral_get("rx_custom_preamble_forward");//gdr_ral_get("mac_cfg_rxmac_ehip_cfg");
   `uvm_info("ref model ", $sformatf("pp value is %0d",pp), UVM_MEDIUM);
   //**FC REG** pfc enable
   if (dyn_rcfg_obj_inst.mode==PCSMAC || dyn_rcfg_obj_inst.mode==MACSEG) begin
      rx_fc_if.pfc_enable=gdr_ral_get("rx_pfc_control","rx_pfc_en");//gdr_ral_get("mac_cfg_rx_pause_enable");
      //DM_TODO: rx_fc_if.pause_enable=gdr_ral_get("mac_cfg_tx_xof_en_tx_pause_qnumber");
      `uvm_info("ref model ", $sformatf("RX pause fwd: %0b, Rx pause dest addr: %0h, en_rxsfc: %0b, en_rxpfc: %0b ",rx_control_frame_fwd[3], rx_pause_daddr, en_rxsfc_pfc[0], en_rxsfc_pfc[1]), UVM_MEDIUM);
   end

   max_extra_short_frame_size = 25;
   
   //HSD: https://hsdes.intel.com/appstore/article/#/16018655893
   `ifdef ETH_MULTI_PORT
       temp = 0;
   `else
       temp = 20;
   `endif 

   `uvm_info("ref model", $sformatf("write_vip_tx : temp = %0d",temp), UVM_NONE);
   for(int i = temp; i < trans.packed_bytes.size(); i++) begin
      //`uvm_info("ref model", $sformatf("MS_DBG: trans.packed_bytes[%0d]=%0h",i,trans.packed_bytes[i]),UVM_NONE);     
      if(trans.packed_bytes[i] == 'hFE) begin
         val++;
      end
   end
   if((val == 3 )||(val>3)) begin
         fe_in_frame = 1;
   end

  
   `uvm_info("ref model", $sformatf("write_vip_tx : fe_in_frame = %0d and value is %0d",fe_in_frame,val), UVM_NONE);

   //invoke unpack functions based on size
   if(trans.packed_bytes.size() <= max_extra_short_frame_size) begin
       //`uvm_info("ETH REF MODEL", $sformatf("%s: skew_test:%d with size:%d",func_name, dyn_rcfg_obj_inst.skew_test, trans.packed_bytes.size()),UVM_MEDIUM)
       if (dyn_rcfg_obj_inst.mode==PCSONLY) begin
	      trans.unpack_bytes_extra_short_frame(1'b1,1'b1,"vip_tx_mac_rx");
       end else if (dyn_rcfg_obj_inst.mode==OTN) begin
	      trans.unpack_bytes_extra_short_frame(1'b1,1'b1,"vip_tx_mac_rx");
       end else if (dyn_rcfg_obj_inst.mode==FLEXE) begin
	      trans.unpack_bytes_extra_short_frame(1'b1,1'b1,"vip_tx_mac_rx");
       end else begin
	      trans.unpack_bytes_extra_short_frame((rx_ctrl_reg[0] && !rx_ctrl_reg[1]),pp,"vip_tx_mac_rx");
       end
   end
   else begin
      if (dyn_rcfg_obj_inst.mode==PCSONLY) begin
         trans.unpack_bytes(1'b1,1'b1,"vip_tx_mac_rx");
      end else if (dyn_rcfg_obj_inst.mode==OTN) begin
         trans.unpack_bytes(1'b1,1'b1,"vip_tx_mac_rx");
      end else if (dyn_rcfg_obj_inst.mode==FLEXE) begin
         trans.unpack_bytes(1'b1,1'b1,"vip_tx_mac_rx");
      end else begin
         trans.unpack_bytes((rx_ctrl_reg[0] && !rx_ctrl_reg[1]),pp,"vip_tx_mac_rx");
      end
   end

   vip_tx_to_rxmac_cov.write(trans);

   //check for predicted drop, dont send to status checker.stats checker


   frame_size_l = trans.packed_bytes.size();
   // For frames that are not dropped, in case of preamble passthrough, assign true preamble for check, else (case that preamble is not received at client) assign standard preamble so that comparison passes
   if (pp)
     trans.preamble = {trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]};
   else
     trans.preamble = 64'hfb555555_555555d5;   
   
   // Assign expected error vector indication
   `uvm_info("REF_MODEL", $sformatf("Value of pp is %0h, packed_byte[0] is %0h, packed_byte[7] is %0h, trans_err_check_status is %0x, packed bytes size is %0d, destination_addr byte is %0h",pp,trans.packed_bytes[0],trans.packed_bytes[7], t_clone.trans_err_check_status,(trans.packed_bytes.size()),trans.packed_bytes[8]),UVM_MEDIUM)
   //if (({trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]} != 64'hfb555555_555555d5) && !t_clone.trans_err_check_status[28]) begin // Bad preamble/sfd should not cause frame to be declared as malformed
   if (((trans.packed_bytes[0] != 8'hfb || trans.packed_bytes[7] != 8'hd5) && !t_clone.trans_err_check_status[28] && (dyn_rcfg_obj_inst.ll_var != _MGE || dyn_rcfg_obj_inst.ll_var != _NF1G)) || ((trans.packed_bytes[0] != 8'h55 || trans.packed_bytes[7] != 8'hd5) && !t_clone.trans_err_check_status[28] && (dyn_rcfg_obj_inst.ll_var == _MGE || dyn_rcfg_obj_inst.ll_var == _NF1G ))) begin // Bad preamble/sfd should not cause frame to be declared as malformed
      trans.rx_error[0] = (trans.packed_bytes.size() < 26); 
      trans.rx_error[1] = t_clone.trans_err_check_status[10] || ((trans.packed_bytes.size()-8)<64);
   end else begin
     if (dyn_rcfg_obj_inst.speed!=_50G) begin
       //trans.rx_error[0] = (t_clone.trans_err_check_status[26] || t_clone.trans_err_check_status[28] ||  (trans.packed_bytes.size() < 26)); // Malformed packet / Phy err without preamble error (that is tested separately)
       trans.rx_error[0] = (t_clone.trans_err_check_status[26]  ||  (fe_in_frame == 1 && t_clone.trans_err_check_status[28]) ); // Malformed packet / Phy err without preamble error (that is tested separately) //Control character in frame does not make it MALFORMED
       trans.rx_error[1] = t_clone.trans_err_check_status[10] || t_clone.trans_err_check_status[26] || t_clone.trans_err_check_status[28] ; // FCS error without preamble error (that is tested separately). As per EHIP spec. undersize frame does not indicate CRC error so removed
       malformed_frame_cnt = (t_clone.trans_err_check_status[26] || t_clone.trans_err_check_status[28]);
     end
     else begin
       trans.rx_error[0] = (t_clone.trans_err_check_status[26] || (trans.packed_bytes.size() < 26)); // Malformed packet / Phy err without preamble error (that is tested separately)
//DM_TODO: COnfirm behavior      trans.rx_error[1] = t_clone.trans_err_check_status[10] || t_clone.trans_err_check_status[26] || t_clone.trans_err_check_status[28]; // FCS error without preamble error (that is tested separately). As per EHIP spec. undersize frame does not indicate CRC error.
       trans.rx_error[1] = t_clone.trans_err_check_status[10]; // FCS error without preamble error (that is tested separately). As per EHIP spec. undersize frame does not indicate CRC error.
       malformed_frame_cnt = t_clone.trans_err_check_status[26];
     end
   end

   `ifdef ETH_MGBASET
     if(((trans.packed_bytes[0] != 8'hfb || trans.packed_bytes[7] != 8'hd5) && !t_clone.trans_err_check_status[28] && dyn_rcfg_obj_inst.ll_speed == _10G) || ((trans.packed_bytes[0] != 8'h55 || trans.packed_bytes[7] != 8'hd5) && !t_clone.trans_err_check_status[28] && dyn_rcfg_obj_inst.ll_speed != _10G)) begin
        trans.rx_error[0] = (trans.packed_bytes.size() < 26); 
         trans.rx_error[1] = t_clone.trans_err_check_status[10] || ((trans.packed_bytes.size()-8)<64);
     end
     else begin 
       trans.rx_error[0] = (t_clone.trans_err_check_status[26]  ||  (fe_in_frame == 1 && t_clone.trans_err_check_status[28]) ); // Malformed packet / Phy err without preamble error
       trans.rx_error[1] = t_clone.trans_err_check_status[10] || t_clone.trans_err_check_status[26] || t_clone.trans_err_check_status[28] ; // FCS error without preamble error 
     end   
   `endif 

   if (vip_tx_drop_frame(trans,trans.rx_error[0],trans.rx_error[1])) begin
   `uvm_info("REF_MODEL", $sformatf("ENTERING VIP_TX_DROP_FRAME"),UVM_MEDIUM) //PAVITHRA
    frame_already_dropped=1;
    cumulative_ipg=cumulative_ipg+trans.packed_bytes.size()+t.mac_inter_frame_gap;
    return;
   end
   
   `uvm_info("REF_MODEL", $sformatf("The value of o_rx_error[0] is %0h and o_rx_error[1] is %0h, DA byte is %0h , %0h",trans.rx_error[0],trans.rx_error[1],trans.packed_bytes[8],trans.packed_bytes[9]),UVM_MEDIUM)
   if(m_sequence == "crc_includes_preamble_sequence") begin
      trans.rx_error[1] = 0; // Sending CRC calculated including preamble
   end
   
   //rx flow control xon/xoff toggling logic
   if (dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG}) begin  //PRASH
     rx_flow_control(trans);
   end
   
//   check_enforce_max_rx(trans,frame_size_l,truncated_frame);

   if ( (({trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]} != 64'hfb555555_555555d5) && (dyn_rcfg_obj_inst.ll_var != _MGE || dyn_rcfg_obj_inst.ll_var != _NF1G || ((dyn_rcfg_obj_inst.ll_var == _MGBASET || dyn_rcfg_obj_inst.ll_var == _MGBASETA10) && dyn_rcfg_obj_inst.ll_speed == _10G) )) || (({trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]} != 64'h55555555_555555d5) && (dyn_rcfg_obj_inst.ll_var == _MGE || dyn_rcfg_obj_inst.ll_var == _NF1G || ((dyn_rcfg_obj_inst.ll_var == _MGBASET || dyn_rcfg_obj_inst.ll_var == _MGBASETA10) && dyn_rcfg_obj_inst.ll_speed != _10G) )))  begin // Bad preamble/sfd should not cause frame to be declared as malformed
//      stat_checker_rx(trans,1'b0,1'b0);
      stat_checker_rx(trans,trans.rx_error[1],malformed_frame_cnt);
      check_enforce_max_rx(trans,frame_size_l,truncated_frame); // HSD 16011501026
      if(check_rx_pause_fwd(trans))
        return;
         if(packet_stall==0) begin
           if(truncated_frame === 1)  begin
             vip_tx_vector(trans,1'b1,trans.rx_error[0]); //Send transaction to vip_tx_vector, for truncated frames, crc error is expected
           end
           else begin
             vip_tx_vector(trans,trans.rx_error[1],trans.rx_error[0]); //Send transaction to vip_tx_vector
           end
         end
   end else begin
      stat_checker_rx(trans,trans.rx_error[1],malformed_frame_cnt);
      check_enforce_max_rx(trans,frame_size_l,truncated_frame); // HSD 16011501026
       if(check_rx_pause_fwd(trans))
        return;
       if(packet_stall==0) begin
           if(truncated_frame === 1)  begin
             vip_tx_vector(trans,1'b1,trans.rx_error[0]); //Send transaction to vip_tx_vector, for truncated frames, crc error is expected
           end
           else begin
            vip_tx_vector(trans,trans.rx_error[1],trans.rx_error[0]); //Send transaction to vip_tx_vector
           end
       end
   end

   if(truncated_frame === 1)  begin
     trans.rx_error[1] = 1'b1; // As frame is truncated, FCS error is expected.
   end

   //GDR: if((trans.packed_bytes.size()-8)<64) trans.rx_error[1] = 1'b1; // As per EHIP spec. undersize frame indicate CRC error in rx_error port (not in STAT so set here)

   //GDR : Malformed , Length Error and undersized error can not come togather for a frame FB -520217
   /*if(trans.rx_error[0] != 1) begin
     if ((frame_size_l-8)>rx_size_reg)
       trans.rx_error[3] = 1; // Oversize, 8 bytes preamble is not included in frame size
     else if((frame_size_l-8)<64)
       trans.rx_error[2] = 1; // Undersize
     else if(truncated_frame === 1'b0) //If frame is > max rx size and enforce_max_rx is set 1, truncted frame will have less payload then eth_type_or_length field. But length error is not expected for this case. 
     trans.rx_error[4] = (trans.frame_type == ETH_DATA_FRAME) ? ((trans.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans.payload.size() < trans.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans.frame_type == ETH_VLAN_FRAME) && rx_vlan_disable == 0) ? ((trans.eth_type_or_length inside {[0:16'h600]}) ? ((trans.payload.size() < trans.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans.frame_type == ETH_STACKED_VLAN_FRAME) &&  rx_vlan_disable == 0) ? ((trans.eth_type_or_length inside {[0:16'h600]}) ? ((trans.payload.size() < trans.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : 1'b0; //Length Error
     //DM_TODO: relook trans.rx_error[4] = trans.rx_error[4] && gdr_ral_get("mac_cfg_rxmac_control","en_plen"); //RMAC_CONTROL.en_plen.get();
   end*/

   if ((frame_size_l-8)>rx_size_reg) begin
       trans.rx_error[3] = 1; // Oversize, 8 bytes preamble is not included in frame size
   end else if((frame_size_l-8)<64) begin
      trans.rx_error[2] = 1; // Undersize
   end
   
   if(truncated_frame === 1'b0) //If frame is > max rx size and enforce_max_rx is set 1, truncted frame will have less payload then eth_type_or_length field. But length error is not expected for this case. 
     trans.rx_error[4] = (trans.frame_type == ETH_DATA_FRAME) ? ((trans.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans.payload.size() < trans.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans.frame_type == ETH_VLAN_FRAME) && rx_vlan_disable == 0) ? ((trans.eth_type_or_length inside {[0:16'h600]}) ? ((trans.payload.size() < trans.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans.frame_type == ETH_STACKED_VLAN_FRAME) &&  rx_vlan_disable == 0) ? ((trans.eth_type_or_length inside {[0:16'h600]}) ? ((trans.payload.size() < trans.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : 1'b0; //Length Error
     //DM_TODO: relook trans.rx_error[4] = trans.rx_error[4] && gdr_ral_get("mac_cfg_rxmac_control","en_plen"); //RMAC_CONTROL.en_plen.get();
   
   trans.rx_error[5] = 1'b0;
   //rx_vlan_disable = gdr_ral_get("mac_cfg_rxmac_control","disable_rxvlan");
   if( t_clone.trans_err_check_status[26]) begin
     trans.ignore_pkt = 1;
   end  
   // Remove Padded data if rxmac_control.remove_rx_pad is enable and rx CRC forwarding is set to disable
   if(rx_ctrl_reg[1] === 1'b1 && rx_ctrl_reg[0] === 1'b0) begin
      if(((trans.eth_type_or_length <= 1500) && (trans.payload.size() > trans.eth_type_or_length)) && (((rx_vlan_disable == 1'b0) && (trans.frame_type==ETH_VLAN_FRAME || trans.frame_type==ETH_STACKED_VLAN_FRAME)) 
           || (trans.frame_type == ETH_DATA_FRAME))) begin
         rm_pad_payload = new[trans.payload.size()](trans.payload);
	     trans.payload.delete();
	     trans.payload = new[trans.eth_type_or_length](rm_pad_payload);
      end
   end
   if((pad_removal) && (trans.eth_type_or_length != trans.payload.size()) && (t_clone.trans_err_check_status[8])) begin
     trans.seen_len_err_with_pad_removal = 1'b1;
   end

   trans.interpacket_gap = t.mac_inter_frame_gap;
   // <IPG3><Frame2><IPG2><Frame1><IPG1><Frame0><IPG0=0>(first frame)>
   // FB 524678: If Frame0+IPG1>40bytes, then frame1 will be dropped.
   // Wait till first two frames are collected, then decide to send frame to sb or not.
   if (packet_stall==1) begin
      if(first_rx_packet==0) begin
	     new_packet_time=$time;
	     packets_drop_decide[0]=packets_drop_decide[1];  
	     packets_drop_decide_idx++;    
	     $cast(packets_drop_decide[1],trans.clone());
	     if ((packets_drop_decide[1].start_offset_bytes-packets_drop_decide[0].start_offset_bytes)<40) begin
	        `uvm_info("ETH REF MODEL", $sformatf("%s: FB 524678. 2 frames with starts separated by < 40 bytes found. Distance between two starts %0d. Dropping first frame",func_name,(packets_drop_decide[1].start_offset_bytes-packets_drop_decide[0].start_offset_bytes)),UVM_NONE)
	         drop_count++;
             rxmac_adapt_dropped_cntr = rxmac_adapt_dropped_cntr + 1;
             //  if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
             //DM_TODO:if(sideband_if.snapshot_en!=1) begin// FIXME Can't use register of shadow request fb:596887 
	         //DM_TODO:   reg_model.rxmac_adapt_dropped_31_0.predict(.value(rxmac_adapt_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
             //DM_TODO:   reg_model.rxmac_adapt_dropped_63_32.predict(.value(rxmac_adapt_dropped_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
             //DM_TODO:end
	     end else begin 
	        if ((({packets_drop_decide[0].packed_bytes[0],packets_drop_decide[0].packed_bytes[1],packets_drop_decide[0].packed_bytes[2],packets_drop_decide[0].packed_bytes[3],packets_drop_decide[0].packed_bytes[4],packets_drop_decide[0].packed_bytes[5],packets_drop_decide[0].packed_bytes[6],packets_drop_decide[0].packed_bytes[7]} != 64'hfb555555_555555d5) && (dyn_rcfg_obj_inst.ll_var != _MGE || dyn_rcfg_obj_inst.ll_var != _NF1G || ((dyn_rcfg_obj_inst.ll_var == _MGBASET || dyn_rcfg_obj_inst.ll_var ==_MGBASETA10) && dyn_rcfg_obj_inst.ll_speed == _10G) )) || (({packets_drop_decide[0].packed_bytes[0],packets_drop_decide[0].packed_bytes[1],packets_drop_decide[0].packed_bytes[2],packets_drop_decide[0].packed_bytes[3],packets_drop_decide[0].packed_bytes[4],packets_drop_decide[0].packed_bytes[5],packets_drop_decide[0].packed_bytes[6],packets_drop_decide[0].packed_bytes[7]} != 64'h55555555_555555d5) && (dyn_rcfg_obj_inst.ll_var == _MGE || dyn_rcfg_obj_inst.ll_var == _NF1G || ((dyn_rcfg_obj_inst.ll_var == _MGBASET || dyn_rcfg_obj_inst.ll_var == _MGBASETA10) && dyn_rcfg_obj_inst.ll_speed != _10G)))) begin // Bad preamble/sfd should not cause frame to be declared as malformed
               if(check_rx_pause_fwd(packets_drop_decide[0]))
               return;
               if(truncated_frame === 1)  begin
                  vip_tx_vector(packets_drop_decide[0],1'b1,packets_drop_decide[0].rx_error[0]); //Send transaction to vip_tx_vector, for truncated frames, crc error is expected
               end       
               else begin
                  vip_tx_vector(packets_drop_decide[0],packets_drop_decide[0].rx_error[1],packets_drop_decide[0].rx_error[0]); //Send transaction to vip_tx_vector
               end
            end else begin
               if(check_rx_pause_fwd(trans))
               return;
               if(truncated_frame === 1)  begin
                  vip_tx_vector(packets_drop_decide[0],1'b1,packets_drop_decide[0].rx_error[0]); //Send transaction to vip_tx_vector, for truncated frames, crc error is expected
               end
               else begin
                  vip_tx_vector(packets_drop_decide[0],packets_drop_decide[0].rx_error[1],packets_drop_decide[0].rx_error[0]); //Send transaction to vip_tx_vector
               end
            end
            //MS_DBG: transaction_id_tx = transaction_id_tx + 1;
	        packets_drop_decide[0].transaction_id = transaction_id_tx;
	        transaction_id_tx = transaction_id_tx + 1; 
	        print_transaction(t,"VIP TX FRAME", transaction_id_tx,file_vip_tx_trans_log_id);
            packets_drop_decide[0].pack_bytes(!(rx_ctrl_reg[0]),pp); //mprash2x 
	        eth_tx_to_dest.write(packets_drop_decide[0]);
	        frame_already_dropped=0;
	     end
	     cumulative_ipg=0;
	     packets_drop_decide_idx--;
      end else begin  
	     transaction_id_tx = transaction_id_tx + 1;
	     trans.transaction_id = transaction_id_tx;  
	     packets_drop_decide_idx++; 
         print_transaction(t,"VIP TX FRAME", transaction_id_tx,file_vip_tx_trans_log_id);
	     $cast(packets_drop_decide[1],trans.clone());
   	     first_rx_packet=0;
	     new_packet_time=$time;
      end // else: !if(first_rx_packet==0)
   end else begin
      transaction_id_tx = transaction_id_tx + 1;
      trans.transaction_id = transaction_id_tx;
      print_transaction(t,"VIP TX FRAME", transaction_id_tx,file_vip_tx_trans_log_id);
      trans.pack_bytes(!(rx_ctrl_reg[0]),pp); //mprash2x 
      eth_tx_to_dest.write(trans);
   end
   
 endfunction

 //Function: stat_checker_rx
//This function gets the trasmitted vip ethernet frame and incremets the rx stat counters
function void stat_checker_rx(eth_packet trans_stat_rx,bit crc_error,bit malformed_error);
   string func_name = "stat_checker_rx";
   int length_error_rx;
   int illegal_length_type_field;
   bit [31:0] rxmac_ctrl;
   bit rx_vlan_disable;
   int tag_overhead;
   int cnt_frame_bytes = 0;
   uvm_reg 	regs_rx;
   bit oversize_err;
   bit undersize_err;
   `uvm_info("ETH REF MODEL", "tb cfg in stat_checker_rx",UVM_MEDIUM);
   
   //rxmac_ctrl = gdr_ral_get("mac_cfg_rxmac_control");
   rx_vlan_disable = gdr_ral_get("rx_vlan_detection","rx_vlan_detection_disable");
   `uvm_info("ref model ", $sformatf(" write_vip_tx : rx vlan detection=%0d", rx_vlan_disable), UVM_MEDIUM);
   
   if(trans_stat_rx.frame_type==ETH_VLAN_FRAME || trans_stat_rx.frame_type==ETH_JUMBO_VLAN_FRAME) begin
     frame_size_rx = trans_stat_rx.payload.size() + 22; 
     if(rx_vlan_disable ==0) begin
       tag_overhead = 4;  
     end
   end
   else if (trans_stat_rx.frame_type==ETH_STACKED_VLAN_FRAME || trans_stat_rx.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
     frame_size_rx = trans_stat_rx.payload.size() + 26; 
     if(rx_vlan_disable ==0) begin
       tag_overhead = 8;  
     end
   end
   else begin
     frame_size_rx = trans_stat_rx.payload.size() + 18;
     tag_overhead = 0;  
   end

   //DM_TODO: rx_pause_addr[31:0] = gdr_ral_get("mac_cfg_rx_pause_daddrl");//reg_model.rx_pause_daddrl.get();
   //DM_TODO: rx_pause_addr[47:32] = gdr_ral_get("mac_cfg_rx_pause_daddrh");//reg_model.rx_pause_daddrh.get();
   //DM_TODO: tx_pfc_daddr[31:0] = gdr_ral_get("mac_cfg_tx_pfc_daddrl");//reg_model.rx_pause_daddrl.get();
   //DM_TODO: tx_pfc_daddr[47:32] = gdr_ral_get("mac_cfg_tx_pfc_daddrh");//reg_model.rx_pause_daddrh.get();
   //DM_TODO: tx_pfc_saddr[31:0] = gdr_ral_get("mac_cfg_tx_pfc_saddrl");//reg_model.rx_pause_daddrl.get();
   //DM_TODO: tx_pfc_saddr[47:32] = gdr_ral_get("mac_cfg_tx_pfc_saddrh");//reg_model.rx_pause_daddrh.get();
   length_error_rx = (trans_stat_rx.frame_type == ETH_DATA_FRAME) ? ((trans_stat_rx.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans_stat_rx.payload.size() < trans_stat_rx.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans_stat_rx.frame_type == ETH_VLAN_FRAME) && rx_vlan_disable == 0) ? ((trans_stat_rx.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans_stat_rx.payload.size() < trans_stat_rx.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans_stat_rx.frame_type == ETH_STACKED_VLAN_FRAME) && rx_vlan_disable == 0) ? ((trans_stat_rx.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans_stat_rx.payload.size() < trans_stat_rx.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : 1'b0;

   if(trans_stat_rx.eth_type_or_length == 'h8808) 
     oversize_err = (frame_size_rx > 'd64) ? 1 : 0;
   else
     oversize_err = (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead)) ? 1 : 0;

   undersize_err = (frame_size_rx < 'd64) ? 1 : 0;

   if(trans_stat_rx.eth_type_or_length == 'h8808) 
     cnt_frame_bytes = 2;
   //DM_TODO: remove length_error_rx = length_error_rx && gdr_ral_get("mac_cfg_rxmac_control","en_plen");

   illegal_length_type_field = trans_stat_rx.eth_type_or_length inside {[1501:1535]} ? 1 : 0 ;

   illegal_length_type_field = illegal_length_type_field && (!(rx_vlan_disable==1 && (trans_stat_rx.frame_type == ETH_VLAN_FRAME || trans_stat_rx.frame_type==ETH_JUMBO_VLAN_FRAME || trans_stat_rx.frame_type==ETH_STACKED_VLAN_FRAME || trans_stat_rx.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME)));
   `uvm_info("ETH REF MODEL", $sformatf("for malformed case frame_size_rx =%0d",frame_size_rx),UVM_MEDIUM)
   if(frame_size_rx < 1518 && frame_size_rx > 1512 && malformed_case && malformed_error) begin//This condition is specifically for eth_malformed_stat_test_sequence.1518 is rx_max_size.
     frame_size_rx = 1520;
   end
   if(trans_stat_rx.eth_type_or_length == 'h8808) begin
     cnt_frame_bytes = 2;
   end
 
   //  trans_stat_rx.preamble = 64'hfb555555_555555d5;
   `uvm_info("ETH REF MODEL", $sformatf("frame_size_rx =%0d, dest_address[40] = %b ,trans_stat_rx.frame_type = %s , length_error_rx = %0d",frame_size_rx,trans_stat_rx.dest_address[40],trans_stat_rx.frame_type,length_error_rx),UVM_MEDIUM)
   `uvm_info("ETH REF MODEL", $sformatf("frame_size_rx =%0d,trans_stat_rx.frame_type = %s, length_error_rx = %0d, malformed err is %0d, crc_err is %0d, control frame bytes %0d",frame_size_rx,trans_stat_rx.frame_type,length_error_rx,malformed_error,crc_error, cnt_frame_bytes),UVM_MEDIUM)
   `uvm_info("ETH REF MODEL", $sformatf("crc_error = %0d",crc_error),UVM_MEDIUM)
   `uvm_info("ETH REF MODEL", $sformatf("malformed_error = %0d",malformed_error),UVM_MEDIUM)
   `uvm_info("ETH REF MODEL", $sformatf("reg_model.RXMAC_SIZE_CONFIG = %0d",gdr_ral_get("mac_cfg_max_rx_size_config")),UVM_MEDIUM)
	 `uvm_info("ETH REF MODEL", $sformatf("shadow_req_grant_rx = %0b , shadow_req_rx = %0b , snap_req_grant_rx = %0b",shadow_req_grant_rx,shadow_req_rx,snap_req_grant_rx),UVM_MEDIUM)
	 `uvm_info("ETH REF MODEL", $sformatf("shadow_req_grant_tx = %0b , shadow_req_tx = %0b , snap_req_grant_rx = %0b snapshot signal = %0b",shadow_req_grant_tx,shadow_req_tx,snap_req_grant_rx,sideband_if.snapshot_en),UVM_MEDIUM)


   //Frame starts
   rx_st_frame = rx_st_frame + 1;
   spy_if.rx_st_frame = rx_st_frame ;
   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     gdr_ral_predict(.regname("mac_stats_cntr_rx_st_lo"),.value(rx_st_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     gdr_ral_predict(.regname("mac_stats_cntr_rx_st_hi"),.value(rx_st_frame[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end
   if(!undersize_err && !oversize_err && !length_error_rx && !crc_error && !malformed_error) begin
     rx_stats_framesOK = rx_stats_framesOK + 1;
     spy_if.rx_stats_framesOK = rx_stats_framesOK;
   end
   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     gdr_ral_predict(.regname("rx_stats_framesOK0"),.value(rx_stats_framesOK[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     gdr_ral_predict(.regname("rx_stats_framesOK1"),.value(rx_stats_framesOK[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end   
   if((oversize_err || length_error_rx || crc_error || malformed_error) && (!undersize_err)) begin
     rx_stats_framesErr = rx_stats_framesErr + 1;
     spy_if.rx_stats_framesErr = rx_stats_framesErr;
   end
   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     gdr_ral_predict(.regname("rx_stats_framesErr0"),.value(rx_stats_framesErr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     gdr_ral_predict(.regname("rx_stats_framesErr1"),.value(rx_stats_framesErr[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end   
   if(undersize_err || oversize_err || length_error_rx || crc_error || malformed_error) begin
     rx_stats_ifErrors = rx_stats_ifErrors + 1;
     spy_if.rx_stats_ifErrors = rx_stats_ifErrors;
   end
   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     gdr_ral_predict(.regname("rx_stats_ifErrors0"),.value(rx_stats_ifErrors[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     gdr_ral_predict(.regname("rx_stats_ifErrors1"),.value(rx_stats_ifErrors[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end     
   // Fragment frame counter
   // Fragment frame counter
   //HSD on malformed packet definition - 16010992360
   if((frame_size_rx < 'd64) && (crc_error)) begin  
   //if(frame_size_rx < 'd64 && (crc_error)) begin
     rx_fragment_cntr = rx_fragment_cntr + 1;
     spy_if.rx_fragment_cntr = rx_fragment_cntr;
     //GDR-HSD :16011596035/16010658355 :For 200/400G fragment counter should be 0 upon read.
     if(dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       rx_fragment_cntr = 0;
       spy_if.rx_fragment_cntr = rx_fragment_cntr;
     end
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_fragments_lo"),.value(rx_fragment_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // Jabber frame counter
   if(crc_error && oversize_err) begin
     rx_jabber_cntr = rx_jabber_cntr + 1;
     spy_if.rx_jabber_cntr = rx_jabber_cntr;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_jabbers_lo"),.value(rx_jabber_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // Frame with FCS error counter, DM only increments this register when CRC
   // error is there (not malformed)
    //rx_stats_framesCRCErr0
   if(!oversize_err && !undersize_err && crc_error) begin // Added size_ok as per HSD 16011461656 
     rx_fcs_cntr = rx_fcs_cntr + 1;
     spy_if.rx_fcs_cntr = rx_fcs_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_fcs_lo"),.value(rx_fcs_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
//rx_stats_etherStatsCRCErr0
   // FCS ok error counter 
   if(!oversize_err && !undersize_err && crc_error)
   begin
     rx_fcserr_okpkt = rx_fcserr_okpkt + 1;
     spy_if.rx_fcserr_okpkt = rx_fcserr_okpkt ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_fcs_err_okpkt_lo"),.value(rx_fcserr_okpkt[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // MCAST data frame related counters
   if((trans_stat_rx.packed_bytes.size()-8) >=14 && trans_stat_rx.dest_address[40] == 'h1 && trans_stat_rx.eth_type_or_length != 'h8808) begin
     if((trans_stat_rx.dest_address != 'hff_ff_ff_ff_ff_ff && (crc_error || malformed_error || length_error_rx || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead)) )) && !(frame_size_rx < 'd64)) begin
	 `uvm_info("stats_ref_model", $sformatf("Received MCAST frame with Error, dest addr is %0h, crc error is %0h, malformed error is %0h, frame size is %0h",trans_stat_rx.dest_address,crc_error,malformed_error,frame_size_rx),UVM_MEDIUM)
       rx_mcast_data_err_cntr = rx_mcast_data_err_cntr + 1;
       spy_if.rx_mcast_data_err_cntr = rx_mcast_data_err_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_err_lo"),.value(rx_mcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
     if(trans_stat_rx.dest_address != 'hff_ff_ff_ff_ff_ff && !(crc_error || malformed_error || length_error_rx || (frame_size_rx < 'd64) || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead)))) begin
       rx_mcast_data_ok_cntr = rx_mcast_data_ok_cntr + 1;
       spy_if.rx_mcast_data_ok_cntr = rx_mcast_data_ok_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_lo"),.value(rx_mcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_hi"),.value(rx_mcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // BCAST data frame related counters
   if((trans_stat_rx.packed_bytes.size()-8) >=14 && trans_stat_rx.dest_address == 'hff_ff_ff_ff_ff_ff && trans_stat_rx.eth_type_or_length != 'h8808) begin
     if((crc_error || malformed_error || length_error_rx || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead))) && !(frame_size_rx < 'd64)) begin
       rx_bcast_data_err_cntr = rx_bcast_data_err_cntr + 1;
       spy_if.rx_bcast_data_err_cntr = rx_bcast_data_err_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_err_lo"),.value(rx_bcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
     if(!(crc_error || malformed_error || length_error_rx || (frame_size_rx < 'd64) || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead )))) begin
       rx_bcast_data_ok_cntr = rx_bcast_data_ok_cntr + 1;
       spy_if.rx_bcast_data_ok_cntr = rx_bcast_data_ok_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_lo"),.value(rx_bcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_hi"),.value(rx_bcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // UCAST data frame related counters
   // It will be updated only for the frames with frame size more than or equal to 14bytes(only for rx side)
   if((trans_stat_rx.packed_bytes.size()-8) >=14 && trans_stat_rx.dest_address[40] == 'h0 && trans_stat_rx.eth_type_or_length != 'h8808 ) begin
     if((crc_error || malformed_error|| length_error_rx || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead ))) && !(frame_size_rx < 'd64)) begin
       rx_ucast_data_err_cntr = rx_ucast_data_err_cntr + 1;
       spy_if.rx_ucast_data_err_cntr = rx_ucast_data_err_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_err_lo"),.value(rx_ucast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
     if(!(crc_error || malformed_error || length_error_rx || (frame_size_rx < 'd64) || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead )))) begin
       rx_ucast_data_ok_cntr = rx_ucast_data_ok_cntr + 1;
       spy_if.rx_ucast_data_ok_cntr = rx_ucast_data_ok_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_lo"),.value(rx_ucast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_hi"),.value(rx_ucast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // MCAST control frame counters
   // It will be updated only for the frames with frame size more than or equal to 14bytes(only for rx side)
   if((trans_stat_rx.packed_bytes.size()-8) >=14 && trans_stat_rx.dest_address[40] == 'h1 && trans_stat_rx.eth_type_or_length == 'h8808) begin
     //DM_TODO : if(trans_stat_rx.dest_address != 'hff_ff_ff_ff_ff_ff && (crc_error || malformed_error)) begin
     //DM_TODO :   rx_mcast_ctrl_err_cntr = rx_mcast_ctrl_err_cntr + 1;
     //DM_TODO :   spy_if.rx_mcast_ctrl_err_cntr = rx_mcast_ctrl_err_cntr ;
     //DM_TODO :   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO :   gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_err_lo"),.value(rx_mcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO :   end
     //DM_TODO : end
     if(trans_stat_rx.dest_address != 'hff_ff_ff_ff_ff_ff && !(crc_error || malformed_error || length_error_rx || (frame_size_rx!=64))) begin
       if(trans_stat_rx.eth_type_or_length == 'h8808) begin // Updated as per RTL, CHECK DM_TODO
         rx_mcast_ctrl_ok_cntr = rx_mcast_ctrl_ok_cntr + 1;
         spy_if.rx_mcast_ctrl_ok_cntr = rx_mcast_ctrl_ok_cntr ;
         if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_lo"),.value(rx_mcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_hi"),.value(rx_mcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
       end
     end
   end
   // BCAST control frame counters
   // It will be updated only for the frames with frame size more than or equal to 14bytes(only for rx side)
   if((trans_stat_rx.packed_bytes.size()-8) >=14 && trans_stat_rx.dest_address == 'hff_ff_ff_ff_ff_ff && trans_stat_rx.eth_type_or_length == 'h8808) begin
     //DM_TODO: if(crc_error || malformed_error) begin
     //DM_TODO:   rx_bcast_ctrl_err_cntr = rx_bcast_ctrl_err_cntr + 1;
     //DM_TODO:   spy_if.rx_bcast_ctrl_err_cntr = rx_bcast_ctrl_err_cntr ;
     //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_err_lo"),.value(rx_bcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
     if((trans_stat_rx.packed_bytes.size()-8) >=14 && !(crc_error || malformed_error || length_error_rx || oversize_err || undersize_err)) begin
       if(trans_stat_rx.eth_type_or_length == 'h8808) begin //Updated according to RTL, Check DM_TODO
         rx_bcast_ctrl_ok_cntr = rx_bcast_ctrl_ok_cntr + 1;
         spy_if.rx_bcast_ctrl_ok_cntr = rx_bcast_ctrl_ok_cntr ;
         if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_lo"),.value(rx_bcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_hi"),.value(rx_bcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
       end
     end
   end
   // UCAST control frame counters
   if((trans_stat_rx.packed_bytes.size()-8) >=14 && trans_stat_rx.dest_address[40] == 'h0 && trans_stat_rx.eth_type_or_length == 'h8808) begin
     //DM_TODO: if(crc_error || malformed_error) begin
     //DM_TODO:   rx_ucast_ctrl_err_cntr = rx_ucast_ctrl_err_cntr + 1;
     //DM_TODO:   spy_if.rx_ucast_ctrl_err_cntr = rx_ucast_ctrl_err_cntr ;
     //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_err_lo"),.value(rx_ucast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
     if(!(crc_error || malformed_error || length_error_rx || oversize_err || undersize_err)) begin
       if(trans_stat_rx.eth_type_or_length == 'h8808) begin //Updated according to RTL, Check DM_TODO
         rx_ucast_ctrl_ok_cntr = rx_ucast_ctrl_ok_cntr + 1;
         spy_if.rx_ucast_ctrl_ok_cntr = rx_ucast_ctrl_ok_cntr ;
         if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_lo"),.value(rx_ucast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_hi"),.value(rx_ucast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
       end
     end
   end
   // PAUSE error/ok counters
   // It will be updated only for the frames with frame size more than or equal to 16bytes(only for rx side)
   if( (trans_stat_rx.packed_bytes.size()-8) >=16 && trans_stat_rx.payload[0] == 'h0 && trans_stat_rx.payload[1] == 'h1 && trans_stat_rx.eth_type_or_length == 'h8808 && (trans_stat_rx.dest_address[40] == 'h0 || (trans_stat_rx.dest_address == 'h180_c200_0001))) begin
     //DM_TODO: if(crc_error || malformed_error) begin
     //DM_TODO:   rx_pause_err_cntr = rx_pause_err_cntr + 1;
     //DM_TODO:   spy_if.rx_pause_err_cntr = rx_pause_err_cntr ;
     //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_err_lo"),.value(rx_pause_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
     if(!(crc_error || malformed_error || length_error_rx || oversize_err || undersize_err)) begin
       rx_pause_ok_cntr = rx_pause_ok_cntr + 1;
       spy_if.rx_pause_ok_cntr = rx_pause_ok_cntr ;
       if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_lo"),.value(rx_pause_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_hi"),.value(rx_pause_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // pfc error/ok counters
   // It will be updated only for the frames with frame size more than or equal to 16bytes(only for rx side)
   if((trans_stat_rx.packed_bytes.size()-8) >=16 && trans_stat_rx.payload[0] == 'h1 && trans_stat_rx.payload[1] == 'h1 && trans_stat_rx.eth_type_or_length == 'h8808 && trans_stat_rx.dest_address == rx_pause_addr && frame_size_rx==64 ) begin
     //DM_TODO: if(crc_error || malformed_error) begin
     //DM_TODO:   rx_pfc_err_cntr = rx_pfc_err_cntr + 1;
     //DM_TODO:   spy_if.rx_pfc_err_cntr = rx_pfc_err_cntr ;
     //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_err_lo"),.value(rx_pfc_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
  // PFC not present in DM   if(!(crc_error || malformed_error|| length_error_rx || oversize_err || undersize_err)) begin
  // PFC not present in DM     rx_pfc_ok_cntr = rx_pfc_ok_cntr + 1;
  // PFC not present in DM     spy_if.rx_pfc_ok_cntr = rx_pfc_ok_cntr ;
  // PFC not present in DM     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
  // PFC not present in DM     gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_lo"),.value(rx_pfc_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
  // PFC not present in DM     gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_hi"),.value(rx_pfc_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
  // PFC not present in DM     end
  // PFC not present in DM   end
   end
   // Different frame sizes related counters
   if(frame_size_rx=='d64) begin
     rx_64b_cntr = rx_64b_cntr + 1;
     spy_if.rx_64b_cntr = rx_64b_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_lo"),.value(rx_64b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_hi"),.value(rx_64b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_rx >= 'd65 && frame_size_rx <= 'd127) begin
     rx_65bto127b_cntr = rx_65bto127b_cntr + 1;
     spy_if.rx_65bto127b_cntr = rx_65bto127b_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_lo"),.value(rx_65bto127b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_hi"),.value(rx_65bto127b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_rx >= 'd128 && frame_size_rx <= 'd255) begin
     rx_128bto255b_cntr = rx_128bto255b_cntr + 1;
     spy_if.rx_128bto255b_cntr = rx_128bto255b_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_lo"),.value(rx_128bto255b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_hi"),.value(rx_128bto255b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_rx >= 'd256 && frame_size_rx <= 'd511) begin
     rx_256bto511b_cntr = rx_256bto511b_cntr + 1;
     spy_if.rx_256bto511b_cntr = rx_256bto511b_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_lo"),.value(rx_256bto511b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_hi"),.value(rx_256bto511b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_rx >= 'd512 && frame_size_rx <= 'd1023) begin
     rx_512bto1023b_cntr = rx_512bto1023b_cntr + 1;
     spy_if.rx_512bto1023b_cntr = rx_512bto1023b_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_lo"),.value(rx_512bto1023b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_hi"),.value(rx_512bto1023b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_rx >= 'd1024 && frame_size_rx <= 'd1518) begin
     rx_1024bto1518b_cntr = rx_1024bto1518b_cntr + 1;
     spy_if.rx_1024bto1518b_cntr = rx_1024bto1518b_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_lo"),.value(rx_1024bto1518b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_hi"),.value(rx_1024bto1518b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // GDR : if(frame_size_rx >= 'd1519 && frame_size_rx <= gdr_ral_get("mac_cfg_max_rx_size_config")) begin
    if(frame_size_rx >= 'd1519) begin 
     rx_1519btomax_cntr = rx_1519btomax_cntr + 1;
     spy_if.rx_1519btomax_cntr = rx_1519btomax_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_lo"),.value(rx_1519btomax_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_hi"),.value(rx_1519btomax_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // OVERSIZED frame counter
   if((frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead)) && (!crc_error)) begin // Updated according to RTL, Check DM_TODO
	 rx_oversize_cntr = rx_oversize_cntr + 1;
     spy_if.rx_oversize_cntr = rx_oversize_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_oversize_lo"),.value(rx_oversize_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // RUNT frame counter
   if((frame_size_rx < 64) && (!crc_error)) begin //Updated according to RTL, Check DM_TODO
     rx_runt_cntr = rx_runt_cntr + 1;
     spy_if.rx_runt_cntr = rx_runt_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_runt_lo"),.value(rx_runt_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // Malformed frame
   //DM_TODO: if(malformed_error == 1) begin
   //DM_TODO:   rx_malformed_cntr = rx_malformed_cntr + 1;
   //DM_TODO:   spy_if.rx_malformed_cntr = rx_malformed_cntr ;
   //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_rx_malformed_lo"),.value(rx_malformed_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // Badlt frame
   //DM_TODO: if(illegal_length_type_field == 1) begin
   //DM_TODO:   rx_badlt_frame = rx_badlt_frame + 1;
   //DM_TODO:   spy_if.rx_badlt_frame = rx_badlt_frame ;
   //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_rx_badlt_lo"),.value(rx_badlt_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // lenerr frame
   //DM_TODO: if(length_error_rx == 1 && trans_stat_rx.payload.size() > 0)  begin
   //DM_TODO:   rx_lenerr_frame = rx_lenerr_frame + 1;
   //DM_TODO:   spy_if.rx_lenerr_frame = rx_lenerr_frame ;
   //DM_TODO:   if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_rx_lenerr_lo"),.value(rx_lenerr_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   // PAYLOAD size ok counter
   // HSD 16011471383 (BAD packets (of oversize and error size? or else) included in octet count)
   //if(frame_size_rx >= 64 && frame_size_rx <= gdr_ral_get("mac_cfg_max_rx_size_config") && !crc_error && !malformed_error && !illegal_length_type_field) begin
//   if(!(crc_error || malformed_error || length_error_rx || (frame_size_rx > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead)) || (frame_size_rx < 'd64) || ((trans_stat_rx.eth_type_or_length == 'h8808) && (frame_size_rx != 'h64)))) 
//   Vairable cnt_frame_bytes should be 2 only for control frames since RTL
//   counts header as 20 bytes for control frames
 if(!(crc_error || malformed_error || length_error_rx || oversize_err || undersize_err))
   begin
     if(rx_vlan_disable==0) begin
       rx_payload_ok_cntr = (rx_payload_ok_cntr + trans_stat_rx.payload.size()) - cnt_frame_bytes;
     end
     else begin
       if(trans_stat_rx.frame_type==ETH_VLAN_FRAME || trans_stat_rx.frame_type==ETH_JUMBO_VLAN_FRAME) begin
         rx_payload_ok_cntr = (rx_payload_ok_cntr + trans_stat_rx.payload.size() + 4) - cnt_frame_bytes;
       end
       else if (trans_stat_rx.frame_type==ETH_STACKED_VLAN_FRAME || trans_stat_rx.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
         rx_payload_ok_cntr = (rx_payload_ok_cntr + trans_stat_rx.payload.size() + 8) - cnt_frame_bytes;
       end
       else begin
         rx_payload_ok_cntr = (rx_payload_ok_cntr + trans_stat_rx.payload.size()) - cnt_frame_bytes;
       end
     end
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       spy_if.rx_payload_ok_cntr = rx_payload_ok_cntr ;
       gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_lo"),.value(rx_payload_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_hi"),.value(rx_payload_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // FRAME size ok counter
   // HSD 16011471383 (BAD packets (of oversize and error size? or else) included in octet count)
   //if(frame_size_rx >= 64 && frame_size_rx <= gdr_ral_get("mac_cfg_max_rx_size_config") && !crc_error && !malformed_error && !illegal_length_type_field) begin
   //if(!malformed_error ) DUT is counting malformed packets
    begin
     rx_frame_ok_cntr = rx_frame_ok_cntr + frame_size_rx;
     spy_if.rx_frame_ok_cntr = rx_frame_ok_cntr ;
     if(snap_req_grant_rx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_rx_octetsok_lo"),.value(rx_frame_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_octetsok_hi"),.value(rx_frame_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end

   `uvm_info("ETH REF MODEL", "Packet received at rx stat checker...",UVM_MEDIUM)
   trans_stat_rx.print;
 endfunction:stat_checker_rx


//Function: write_vip_rx
//This function gets the received vip ethernet frame by monitor and converts into ethenet packet and send to scoreboard actual packet
 function void write_vip_rx(svt_ethernet_transaction t);
   uvm_reg 	regs;
   string func_name = "write_vip_rx";
   eth_packet trans;
    svt_ethernet_transaction t_clone;    
    bit pp;
    //{muralasx}
    //Added explicit displays.
   `uvm_info(get_name(), "vip packet is received in ref model at vip rx analysis port...",UVM_MEDIUM)
   `uvm_info(get_name(), $sformatf("%s: vip packet is received at vip rx analysis port...",func_name),UVM_MEDIUM)
   //`uvm_info(get_name(),$psprintf("Packet received in scoreboard write_rx  function  : \n",t.print),UVM_MEDIUM);
    t.print;
   `uvm_info(get_name(),$psprintf("Packet received in scoreboard write_rx trans_err_check_status: %0x \n",t.trans_err_check_status),UVM_MEDIUM);
   $cast(t_clone,t.clone());
   
   if (t_clone.complete_data_frame.size==0) begin     
      `uvm_error("ETH REF MODE", $sformatf("%s: Empty frame received from Synopsys VIP monitor",func_name));
      return;
   end

   trans = eth_packet::type_id::create("trans", this);
   if (sip_limit ==1) begin
      trans.sip_limit_test =1;
      `uvm_info(get_name(), $sformatf("%s:sip_limit_test is set to %0d ",func_name,trans.sip_limit_test),UVM_MEDIUM);
   end 

   if(t_clone.trans_err_check_status[26]==1 && t_clone.trans_err_check_status[0]==0 && t_clone.complete_data_frame.size <= 34) begin
     // For malform frames,DUT will replace some of the frame data with 'hFE. 
     // This error bytes will not be considered as part of frame by VIP.
     // So frame sampled by VIP may have less bytes then original.
     // If sampled frame has less then 34 bytes, then unpack_bytes method of eth_packet may result in generating nagative value for array size. 
     // t_clone.trans_err_check_status[0]==0 condition cross check that VIP is not reporting malform frame because of bad preamble/sfd
     trans.packed_bytes=new[34](t_clone.complete_data_frame);
   end
   else begin
     trans.packed_bytes=new[t_clone.complete_data_frame.size](t_clone.complete_data_frame);
   end 

   pp = gdr_ral_get("tx_preamble_control","preamble_passthorugh");//gdr_ral_get("mac_cfg_txmac_ehip_cfg");
   if(pp) max_extra_short_frame_size = 25;
   else max_extra_short_frame_size = 17;

   //invoke unpack functions based on size
   if(trans.packed_bytes.size() <= max_extra_short_frame_size) begin
     trans.unpack_bytes_extra_short_frame(trans.skip_tx_crc_insertion,pp,"vip_rx_mac_tx");
   end
   else if (sip_limit == 1 && (dyn_rcfg_obj_inst.mode inside {FLEXE,OTN,PCSONLY})) begin //HSD: 16013867273
     trans.unpack_bytes(1'b1,1'b1,"vip_tx_mac_rx",1'b1);
   end  
   else begin
     //DM_Todo: trans.unpack_bytes(0,pp,"vip_rx_mac_tx");
     trans.unpack_bytes(0,0,"vip_rx_mac_tx");
   end
   
   `ifdef ENABLE_ETH_VIP
   //reverse the order of fcs - only for MACSEG, 2step packets/ non ptp packets in VIP mode. All other 1 step ptp packets will have crc recalculate again and reverse to correct order in scoreboard
   //This is because the unpack_bytes is following AVST method to unpack - MSB to LSB. It should be LSB to MSB for MACSEG
   // dsamantx : We changed the order of fcs while sending pkt to scoreboard. this fix is not required for base IP.
   `uvm_info("ref model ", $sformatf("Before reversing the order of TX FCS %0h",trans.fcs), UVM_MEDIUM);
   if(dyn_rcfg_obj_inst.mode== MACSEG && dyn_rcfg_obj_inst.ptp == 1)begin
      if(trans.is_ptp_seq == 1)begin
         if((trans.m_ptp_op == INS_2STEP) || (trans.m_ptp_op == INS_NOOP))begin
            trans.fcs = {<<byte{trans.fcs}};
         end      
      end else begin //non ptp packets
         //Flow control packets coming from FC mon has fcs reverse, so no need to reverse again
         if((trans.frame_type != ETH_PFC_FRAME) && (trans.frame_type != ETH_SFC_FRAME))begin
            trans.fcs = {<<byte{trans.fcs}};
         end
      end
   end
   `uvm_info("ref model ", $sformatf("After reversing the order of TX FCS %0h",trans.fcs), UVM_MEDIUM);
   `endif   
   
   
   if(t_clone.trans_err_check_status[10]==1) begin
     trans.seen_rx_fcs_error_insertion = 1;
     `uvm_info(get_type_name(),$sformatf("fcs error seen in vip rx monitor fcs:%0d",t_clone.trans_err_check_status[10]), UVM_MEDIUM)
   end
   if(m_sequence == "crc_includes_preamble_sequence") begin 
     trans.seen_rx_fcs_error_insertion = 1; // VIP caluculates CRC including preamble
     trans.rx_error[1] = 1;
   end

   if((t_clone.trans_err_check_status[28]==1)|| (t_clone.trans_err_check_status[11]==1)) begin
     trans.seen_tx_error_insertion = 1;
     `uvm_info(get_type_name(),$sformatf("malformed error seen in vip rx monitor fcs:%0d",t_clone.trans_err_check_status[28]), UVM_MEDIUM)
   end
  //in cretes pause quanta for non selected queues are dont care so they are
  //being excluded from comparison 
 /* if(trans.frame_type==ETH_PFC_FRAME) begin
     int j=0;
  foreach(trans.payload[i])
    $display("payload[%d]=%h \n",i,trans.payload[i]);

     for(int i=0;i<8;i++) begin
       if(trans.pfc_class_en_vect[1][i]==0) begin
         trans.payload[4+j]=0;
         trans.payload[5+j]=0;
         j+=2; 
       end
       end
   end*/
   transaction_id_rx = transaction_id_rx + 1;
   trans.transaction_id = transaction_id_rx;
   print_transaction(t,"VIP RX FRAME", transaction_id_rx,file_vip_rx_trans_log_id);  
   eth_rx_to_dest.write(trans);
 endfunction

//Function: write_vector_tx
//This function gets the received transaction from the layering monitor and send to scoreboard expected packet
//function void write_vector_tx(eth_packet t);
//  int frame_size;
//  string func_name = "write_vector_tx";
//  bit [31:0] txmac_ctrl;
//  vector_uvc_packet trans; // Vector packet instance
//  eth_packet t_clone;    // Ethernet packet instance
//  uvm_reg regs_tx;
//   
//  txmac_ctrl = gdr_ral_get("mac_cfg_txmac_control");
//  `uvm_info("ETH REF MODEL", $sformatf(" write value in mac_cfg_txmac_control , txmac_ctrl %0d",txmac_ctrl), UVM_MEDIUM);
//  `uvm_info("ETH REF MODEL", $sformatf("%s: Ethernet Packet received at dut_tx_vip_rx...",func_name),UVM_MEDIUM)
//  //t.print();
//  $cast(t_clone,t.clone());
////  `uvm_info("ETH REF MODEL", $sformatf("%s: Clone Packet received at dut_tx_vip_rx...",func_name),UVM_MEDIUM)
////  t_clone.print();
//
//  if(t_clone.frame_type==ETH_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_VLAN_FRAME) begin
//    frame_size = t_clone.payload.size() + 22;   
//  end
//  else if (t_clone.frame_type==ETH_STACKED_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
//    frame_size = t_clone.payload.size() + 26; 
//  end
//  else begin
//    frame_size = t_clone.payload.size() + 18;
//  end
//
//   `uvm_info("ETH REF MODEL", $sformatf("frame_size =%0h, dest_address = %0h",frame_size,t_clone.dest_address),UVM_MEDIUM)
//FIXME-GDR//   `uvm_info("ETH REF MODEL", $sformatf("reg_model.MAX_TX_SIZE_CONFIG = %0h",gdr_ral_get("mac_cfg_max_tx_size_config")),UVM_MEDIUM)
//
//  trans = vector_uvc_packet::type_id::create("trans", this); //Create transaction
//  `uvm_info("ETH REF MODEL", $sformatf(" write value in mac_cfg_txmac_control , txmac_ctrl[1] = %0d",txmac_ctrl[1]), UVM_MEDIUM);
//  vector_status_data(t_clone,frame_size,txmac_ctrl[1],trans); //Call vector status data
//    
//FIXME-GDR//  if(frame_size > gdr_ral_get("mac_cfg_max_tx_size_config")) 
//  begin // OVERSIZED ERROR 
//    trans.status_error[`TX_OVERSIZED_ERROR] = 1;
//    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:OVERSIZED_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
//  end
//  
//  if(t_clone.frame_type == ETH_DATA_FRAME)
//  begin
//    if(t_clone.eth_type_or_length inside {[0:16'h5DC]})
//    begin
//      if(t_clone.payload.size() < t_clone.eth_type_or_length) 
//      begin
//        trans.status_error[`TX_LENGTH_ERROR] = 1;
//        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
//      end  
//    end
//  end
//  else if(t_clone.frame_type == ETH_VLAN_FRAME && (txmac_ctrl[1] == 0))
//  begin
//    if(t_clone.eth_type_or_length inside {[0:16'h5DC]})
//    begin
//      if(t_clone.payload.size() < t_clone.eth_type_or_length) 
//      begin
//        trans.status_error[`TX_LENGTH_ERROR] = 1;
//        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
//      end  
//    end
//  end
//  else if(t_clone.frame_type == ETH_STACKED_VLAN_FRAME && (txmac_ctrl[1] == 0))
//  begin
//    if(t_clone.eth_type_or_length inside {[0:16'h5DC]})
//    begin
//      if(t_clone.payload.size() < t_clone.eth_type_or_length) 
//      begin
//        trans.status_error[`TX_LENGTH_ERROR] = 1;
//        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
//      end  
//    end
//  end
//  
//  //Print transaction ID
//  transaction_id_dut_tx_vip_rx = transaction_id_dut_tx_vip_rx + 1;
//  trans.transaction_id = transaction_id_dut_tx_vip_rx;
//  `uvm_info("ETH REF MODE", $sformatf("transaction_id_dut_tx_vip_rx=%0d",transaction_id_dut_tx_vip_rx),UVM_MEDIUM);
//  
//  //Send transaction to scoreboard
//  vector_tx_to_sb.write(trans);
//  `uvm_info(get_type_name(), $sformatf("after processed expected packet in ref_model from dut_tx_vip_rx: \n %s",t_clone.sprint()), UVM_DEBUG)
//endfunction//write_vector_tx

//Function: write_vector_tx
//This function gets the received transaction from the layering monitor and send to scoreboard expected packet
function void write_vector_tx(eth_packet t);
  int frame_size;
  string func_name = "write_vector_tx";
  bit tx_vlan_disable;
  bit tx_padding;
  bit tx_crc_control;
  vector_uvc_packet trans; // Vector packet instance
  eth_packet t_clone;    // Ethernet packet instance
  uvm_reg regs_tx;
  uvm_reg tx_pad_control;
  int tag_overhead;
   
  tx_vlan_disable = gdr_ral_get("tx_vlan_detection","tx_vlan_detection_disable");
  `uvm_info("ETH REF MODEL", $sformatf(" write_vector_tx: tx_vlan_disable = %0d",tx_vlan_disable), UVM_MEDIUM);
  tx_padding = gdr_ral_get("tx_pad_control","pad_insertion_en");
  tx_crc_control = gdr_ral_get("tx_crc_control","crc_insertion");
  `uvm_info("ETH REF MODEL", $sformatf(" write_vector_tx: tx_vlan_disable = %0d",tx_vlan_disable), UVM_MEDIUM);
  `uvm_info("ETH REF MODEL", $sformatf("%s: Ethernet Packet received at dut_tx_vip_rx...",func_name),UVM_MEDIUM)
  //t.print();
  $cast(t_clone,t.clone());
  `uvm_info("ETH REF MODEL", $sformatf("%s: Clone Packet received at dut_tx_vip_rx...",func_name),UVM_MEDIUM)
  t_clone.print();

  if(t_clone.frame_type==ETH_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_VLAN_FRAME) begin
    frame_size = t_clone.payload.size() + 22;   
    if(tx_vlan_disable ==0) begin
      tag_overhead =  4;
    end
  end
  else if (t_clone.frame_type==ETH_STACKED_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
    frame_size = t_clone.payload.size() + 26; 
    if(tx_vlan_disable ==0) begin
      tag_overhead =  8;
    end
  end
  else begin
    frame_size = t_clone.payload.size() + 18;
    tag_overhead =  0;
  end

   `uvm_info("ETH REF MODEL", $sformatf("frame_size =%0h, dest_address = %0h",frame_size,t_clone.dest_address),UVM_MEDIUM)

  trans = vector_uvc_packet::type_id::create("trans", this); //Create transaction
  vector_status_data(t_clone,frame_size,tx_vlan_disable,0,trans); //Call vector status data
  if(t_clone.seen_tx_error_insertion == 1'b1) begin
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:CLIENT_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
    trans.status_error[`TX_CLIENT_ERROR] = 1;
  end

  if(t_clone.underflow_condition == 1'b1) begin
    trans.status_error[`TX_UNDERFLOW_ERROR_STATUS] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:UNDERFLOW_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
  end

  if((frame_size > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead)) || ((t_clone.eth_type_or_length == 'h8808) && (frame_size > 'd64)))
  begin // OVERSIZED ERROR 
    trans.status_error[`TX_OVERSIZED_ERROR] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:OVERSIZED_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
  end

  if(frame_size < 64) 
  begin // UNDERSIZED ERROR 
    trans.status_error[`TX_UNDERSIZED_ERROR] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:OVERSIZED_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
  end  
  if((frame_size < 33) && (tx_padding == 1'b0) && (tx_crc_control == 1'b1)) begin //Underflow condition validation
    trans.status_error[`TX_UNDERSIZED_ERROR] = 0;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:OVERSIZED_ERROR not asserted FROM DUT_TX_VIP_RX", UVM_MEDIUM)
  end
  
  if(t_clone.frame_type == ETH_DATA_FRAME)
  begin
    if(t_clone.eth_type_or_length inside {[0:16'h5FF]})
    begin
      if(t_clone.payload.size() < t_clone.eth_type_or_length) 
      begin
        trans.status_error[`TX_LENGTH_ERROR] = 1;
        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
      end  
    end
  end
  else if(t_clone.frame_type == ETH_VLAN_FRAME && (tx_vlan_disable == 0))
  begin
    if(t_clone.eth_type_or_length inside {[0:16'h5FF]})
    begin
      if(t_clone.payload.size() < t_clone.eth_type_or_length) 
      begin
        trans.status_error[`TX_LENGTH_ERROR] = 1;
        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
      end  
    end
  end
  else if(t_clone.frame_type == ETH_STACKED_VLAN_FRAME && (tx_vlan_disable == 0))
  begin
    if(t_clone.eth_type_or_length inside {[0:16'h5FF]})
    begin
      if(t_clone.payload.size() < t_clone.eth_type_or_length) 
      begin
        trans.status_error[`TX_LENGTH_ERROR] = 1;
        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM DUT_TX_VIP_RX", UVM_MEDIUM)
      end  
    end
  end
  
  //Print transaction ID
  transaction_id_dut_tx_vip_rx = transaction_id_dut_tx_vip_rx + 1;
  trans.transaction_id = transaction_id_dut_tx_vip_rx;
  `uvm_info("ETH REF MODE", $sformatf("transaction_id_dut_tx_vip_rx=%0d",transaction_id_dut_tx_vip_rx),UVM_MEDIUM);
  
  //Send transaction to scoreboard
  vector_tx_to_sb.write(trans);
  `uvm_info(get_type_name(), $sformatf("after processed expected packet in ref_model from dut_tx_vip_rx: \n %s",t_clone.sprint()), UVM_DEBUG)
endfunction//write_vector_tx


//Function: vip_tx_vector
//This function gets the trasmitted vip ethernet frame and converts into ethenet packet for vector and send to scoreboard as expected packet
function void vip_tx_vector(eth_packet t,bit crc_error,bit malformed_error);
  int frame_size; 
  string func_name = "write_vip_tx_vector";
  bit truncated_frame = 0;
  bit rx_vlan_disable;
  vector_uvc_packet trans; //Vector packet instance
  eth_packet t_clone;   // Ethernet packet insance
  uvm_reg regs_rx;
  bit crc_error_tx_vector;
  int tag_overhead =0;
   
  crc_error_tx_vector = crc_error;
   rx_vlan_disable = gdr_ral_get("rx_vlan_detection","rx_vlan_detection_disable");
   `uvm_info("ref model ", $sformatf(" vip_tx_vector : rx vlan detection=%0d", rx_vlan_disable), UVM_MEDIUM);
  `uvm_info("ETH REF MODEL", $sformatf("%s: Ethernet Packet received at vip_tx_dut_rx...",func_name),UVM_MEDIUM)
 // t.print();
  $cast(t_clone,t.clone());
 // `uvm_info("ETH REF MODEL", $sformatf("%s: Clone Packet received at vip_tx_dut_rx...",func_name),UVM_MEDIUM)
 // t_clone.print();

  if(t_clone.frame_type==ETH_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_VLAN_FRAME) begin
    frame_size = t_clone.payload.size() + 22;   
    if(rx_vlan_disable == 0) begin
      tag_overhead = 4;
    end
  end
  else if (t_clone.frame_type==ETH_STACKED_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
    frame_size = t_clone.payload.size() + 26; 
    if(rx_vlan_disable == 0) begin
      tag_overhead = 8;
    end
  end
  else begin
    frame_size = t_clone.payload.size() + 18;
    tag_overhead = 0;
  end

  `uvm_info("ETH REF MODEL", $sformatf("frame_size =%0h, dest_address = %0h",frame_size,t_clone.dest_address),UVM_MEDIUM)
  `uvm_info("ETH REF MODEL", $sformatf("reg_model.RXMAC_SIZE_CONFIG = %0h",gdr_ral_get("mac_cfg_max_rx_size_config")),UVM_MEDIUM)
  
  vector_status_data(t_clone,frame_size,rx_vlan_disable,crc_error_tx_vector,trans); //Vector status data
 // check_enforce_max_rx(t_clone,frame_size,truncated_frame);
  `uvm_info("REF_MODEL", $sformatf("frame_size =%0h, payload size is=%0d, dest_address = %0h, malformed bit is %0h, crc_error_tx_vector is %0h, truncated_frame=%0d",frame_size,t_clone.payload.size(),t_clone.dest_address,malformed_error,crc_error_tx_vector,truncated_frame),UVM_MEDIUM)
  
  if(malformed_error) begin // PHY ERROR or MALFORMED ERROR 
    trans.status_error[`RX_PHY_ERROR] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:PHY_ERROR", UVM_MEDIUM)
  end
  if(crc_error_tx_vector || malformed_error) begin // CRC ERROR 
    trans.status_error[`RX_CRC_ERROR] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:CRC_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
  end
  
  
    //Malformed , Length Error and undersized error can not come togather for a frame FB -520217  
    if(truncated_frame == 1) begin
        trans.status_error[`RX_OVERSIZED_ERROR] = 1;
        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:OVERSIZED_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
    end else if(((frame_size) > (gdr_ral_get("mac_cfg_max_rx_size_config") + tag_overhead)) || ((t_clone.eth_type_or_length == 'h8808 && (t_clone.frame_type == ETH_SFC_FRAME || t_clone.frame_type ==ETH_PFC_FRAME)) && (frame_size > 'd64))) begin // OVERSIZED ERROR 
        trans.status_error[`RX_OVERSIZED_ERROR] = 1;
        `uvm_info(get_type_name(), "VECTOR_REF_MODEL:OVERSIZED_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
    end else if(frame_size < 'd64) begin // UNDERSIZED ERROR
      trans.status_error[`RX_UNDERSIZED_ERROR] = 1;
      `uvm_info(get_type_name(), "VECTOR_REF_MODEL:UNDERSIZED_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
    end
    // else begin
      //GDR:  if(t_clone.frame_type == ETH_DATA_FRAME && gdr_ral_get("mac_cfg_rxmac_control","en_plen") && truncated_frame==0)
      //https://hsdes.intel.com/appstore/article/#/16018766235
      //if(t_clone.frame_type == ETH_DATA_FRAME && truncated_frame==0 && frame_size > 'd63) 
      if(t_clone.frame_type == ETH_DATA_FRAME && truncated_frame==0  )
      begin
        if(t_clone.eth_type_or_length inside {[0:16'h5FF]})
        begin
          if(t_clone.payload.size() < t_clone.eth_type_or_length) 
          begin
            trans.status_error[`RX_LENGTH_ERROR] = 1;
            `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
          end  
        end
      end
      //DM_TODO: remove else if(t_clone.frame_type == ETH_VLAN_FRAME && (rx_vlan_disable == 0) && gdr_ral_get("mac_cfg_rxmac_control","en_plen") && truncated_frame==0)
      else if(t_clone.frame_type == ETH_VLAN_FRAME && (rx_vlan_disable == 0) && truncated_frame==0)
       begin
        if(t_clone.eth_type_or_length inside {[0:16'h5FF]})
        begin
          if(t_clone.payload.size() < t_clone.eth_type_or_length) 
          begin
            trans.status_error[`RX_LENGTH_ERROR] = 1;
            `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
          end  
        end
      end
      //DM_TODO: remove else if(t_clone.frame_type == ETH_STACKED_VLAN_FRAME && (rx_vlan_disable == 0) && gdr_ral_get("mac_cfg_rxmac_control","en_plen") && truncated_frame==0)
      else if(t_clone.frame_type == ETH_STACKED_VLAN_FRAME && (rx_vlan_disable == 0) && truncated_frame==0)
      begin
        if(t_clone.eth_type_or_length inside {[0:16'h5FF]})
        begin
          if(t_clone.payload.size() < t_clone.eth_type_or_length) 
          begin
            trans.status_error[`RX_LENGTH_ERROR] = 1;
            `uvm_info(get_type_name(), "VECTOR_REF_MODEL:LENGTH_ERROR FROM VIP_TX_DUT_RX", UVM_MEDIUM)
          end  
        end
      end
    //end
  
    `uvm_info("REF_MODEL", $sformatf("frame_size =%0h, dest_address = %0h, trans.status_error is %0h, trans.status_data is %0h",frame_size,t_clone.dest_address,trans.status_error,trans.status_data),UVM_MEDIUM)
  //Transaction ID count vip_tx_dut_rx
  transaction_id_vip_tx_dut_rx = transaction_id_vip_tx_dut_rx + 1;
  trans.transaction_id = transaction_id_vip_tx_dut_rx;
  `uvm_info("ETH REF MODE", $sformatf("transaction_id_vip_tx_dut_rx=%0d",transaction_id_vip_tx_dut_rx),UVM_MEDIUM);
  
  //Send transaction to scoreboard
  vip_tx_to_sb.write(trans);
  `uvm_info(get_type_name(), $sformatf("after processed expected packet in ref_model from vip_tx_dut_rx: \n %s",t_clone.sprint()), UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("after processed expected packet in ref_model from vip_tx_dut_rx (vector): \n %s",trans.sprint()), UVM_MEDIUM)
endfunction //vip_tx_vector
`endif//Enable vip

   

   function void write_decoder_rx(eth_packet t);
      string func_name = "write_decoder_rx";
      eth_packet trans;
      bit [31:0] rx_ctrl_reg;
      bit [31:0] rx_size_reg;
      uvm_reg 	regs;
      
      if (malformed_test_rx==1'b0)
	      return;
      
      $cast(trans,t.clone());
      trans.packed_bytes = t.packed_bytes;

      rx_ctrl_reg = gdr_ral_get("rx_padcrc_control"); //gdr_ral_get("mac_cfg_mac_crc_config");
      rx_ctrl_reg[0] = ~rx_ctrl_reg[0];
      `uvm_info("ref model ", $sformatf(" write_decoder_rx : rx_ctrl_reg %0d",rx_ctrl_reg), UVM_NONE);
      rx_size_reg = gdr_ral_get("mac_cfg_max_rx_size_config");

      vip_tx_count++;
      max_extra_short_frame_size = 25;
      
      if(trans.packed_bytes.size() <= max_extra_short_frame_size) begin
	     trans.unpack_bytes_extra_short_frame(rx_ctrl_reg[0],dyn_rcfg_obj_inst.preamble_passthrough,"vip_tx_mac_rx");
      end else begin
	     trans.unpack_bytes(rx_ctrl_reg[0],dyn_rcfg_obj_inst.preamble_passthrough,"vip_tx_mac_rx");
      end
      
      `ifdef ENABLE_ETH_VIP
        vip_tx_vector(trans,trans.rx_error[1],trans.rx_error[0]); //Send transaction to vip_tx_vector
      `endif//Enable vip
      
      if (vip_tx_drop_frame(trans,0,0))
	      return; 

      `ifdef ENABLE_ETH_VIP
       if(trans.rx_error[0] == 0) begin
          stat_checker_rx(trans,trans.rx_error[1],trans.rx_error[0]);  
       end
      `endif//Enable vip

      // For frames that are not dropped, in case of preamble passthrough, assign true preamble for check, else (case that preamble is not received at client) assign standard preamble so that comparison passes
      if (dyn_rcfg_obj_inst.preamble_passthrough)
	      trans.preamble = {trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]};
      else
	      trans.preamble = 64'hfb555555_555555d5;
      
      trans.rx_error[2] = (trans.payload.size()<46); // Undersize
      trans.rx_error[3] = (trans.payload.size()>rx_size_reg); // Oversize
      trans.rx_error[4] = (trans.eth_type_or_length<16'h600)? (trans.eth_type_or_length!=trans.payload.size()):1'b0; // Length Error
      trans.rx_error[5] = 1'b0;
      
      transaction_id_tx = transaction_id_tx + 1;
      trans.transaction_id = transaction_id_tx;
      `uvm_info("ETH REF MODEL", "Packet received at decoder rx port...",UVM_MEDIUM)
      //trans.print;
      eth_tx_to_dest.write(trans);
      
   endfunction // write_decoder_rx

//Function: write_avst_rx
//This function gets the received transaction from the avst RX monitor. This was needed only for malform packets to update stats
   function void write_avst_rx(eth_packet t);
      string func_name = "write_avst_rx";
      eth_packet trans;
      bit [31:0] rx_ctrl_reg;
      bit [31:0] rx_size_reg;
      uvm_reg 	regs;
      
      if (malformed_test_rx==1'b0)
	return;
      
      $cast(trans,t.clone());
      trans.packed_bytes = t.packed_bytes;
      
      rx_ctrl_reg = gdr_ral_get("rx_padcrc_control"); //gdr_ral_get("mac_cfg_mac_crc_config");
      rx_ctrl_reg[0] = ~rx_ctrl_reg[0];
      `uvm_info("ref model ", $sformatf(" write_avst_rx : rx_ctrl_reg %0d",rx_ctrl_reg), UVM_NONE);

      rx_size_reg = gdr_ral_get("mac_cfg_max_rx_size_config");

      //vip_tx_count++;
      max_extra_short_frame_size = 25;
      
      //invoke unpack functions based on size
      if(trans.packed_bytes.size() <= max_extra_short_frame_size) begin
	     trans.unpack_bytes_extra_short_frame(rx_ctrl_reg[0],dyn_rcfg_obj_inst.preamble_passthrough,"vip_tx_mac_rx");
      end else begin
	     trans.unpack_bytes(rx_ctrl_reg[0],dyn_rcfg_obj_inst.preamble_passthrough,"vip_tx_mac_rx");
      end
      
      //`ifdef ENABLE_ETH_VIP
      //  vip_tx_vector(trans,trans.rx_error[1],trans.rx_error[0]); //Send transaction to vip_tx_vector
      //`endif//Enable vip
      if (vip_tx_drop_frame(trans,0,0))
	      return; 

      `ifdef ENABLE_ETH_VIP
        if(trans.rx_error[0] == 1) begin
          stat_checker_rx(trans,trans.rx_error[1],malformed_frame_cnt);  
        end
      `endif//Enable vip

      // For frames that are not dropped, in case of preamble passthrough, assign true preamble for check, else (case that preamble is not received at client) assign standard preamble so that comparison passes
//      if (tb_cfg.preamble_passthrough)
//	trans.preamble = {trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]};
//      else
//	trans.preamble = 64'hfb555555_555555d5;
//      
//      trans.rx_error[2] = (trans.payload.size()<46); // Undersize
//      trans.rx_error[3] = (trans.payload.size()>rx_size_reg); // Oversize
//      trans.rx_error[4] = (trans.eth_type_or_length<16'h600)? (trans.eth_type_or_length!=trans.payload.size()):1'b0; // Length Error
//      trans.rx_error[5] = 1'b0;
//      
//      transaction_id_tx = transaction_id_tx + 1;
//      trans.transaction_id = transaction_id_tx;
//      `uvm_info("ETH REF MODEL", "Packet received at decoder rx port...",UVM_MEDIUM)
//   //   trans.print;
//      eth_tx_to_dest.write(trans);
      
   endfunction // write_avst_rx

   
 function void write_stat_checker_tx(eth_packet t);
   string func_name = "write_stat_checker_tx";
   bit tx_vlan_disable;
   int length_error_tx;
   int illegal_length_type_field_tx;
   int tag_overhead;
   eth_packet trans_stat_tx;
   uvm_reg 	regs_tx;
   bit oversize_err;
   bit undersize_err;
   int cnt_frame_bytes = 0;
   
   tx_vlan_disable = gdr_ral_get("tx_vlan_detection","tx_vlan_detection_disable"); //gdr_ral_get("mac_cfg_txmac_control")
   //DM_TODO: en_txsfc_pfc = gdr_ral_get("mac_cfg_txsfc_ehip_cfg");
   $cast(trans_stat_tx,t.clone());
   //trans_stat_tx.unpack_bytes(tb_cfg.crc_pass,tb_cfg.preamble_passthrough,"vip_rx_mac_tx");
   if (trans_stat_tx ==null) begin     
      `uvm_error("ETH REF MODE", $sformatf("%s: Empty frame received from TX monitor",func_name));
      return;
   end    
   `uvm_info("ETH REF MODEL", $sformatf("%s: Packet received at stat tx...",func_name),UVM_MEDIUM)
   if(trans_stat_tx.frame_type==ETH_VLAN_FRAME || trans_stat_tx.frame_type==ETH_JUMBO_VLAN_FRAME) begin
     frame_size_tx = trans_stat_tx.payload.size() + 22;   
     if(tx_vlan_disable == 0) begin
       tag_overhead = 4;
     end
   end
   else if (trans_stat_tx.frame_type==ETH_STACKED_VLAN_FRAME || trans_stat_tx.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
     frame_size_tx = trans_stat_tx.payload.size() + 26; 
     if(tx_vlan_disable == 0) begin
       tag_overhead = 8;
     end 
   end
   else begin
     frame_size_tx = trans_stat_tx.payload.size() + 18;
     tag_overhead = 0;
   end
    length_error_tx = (trans_stat_tx.frame_type == ETH_DATA_FRAME) ? ((trans_stat_tx.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans_stat_tx.payload.size() < trans_stat_tx.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans_stat_tx.frame_type == ETH_VLAN_FRAME) && tx_vlan_disable == 0) ? ((trans_stat_tx.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans_stat_tx.payload.size() < trans_stat_tx.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : ((trans_stat_tx.frame_type == ETH_STACKED_VLAN_FRAME) && tx_vlan_disable == 0) ? ((trans_stat_tx.eth_type_or_length inside {[0:16'h5FF]}) ? ((trans_stat_tx.payload.size() < trans_stat_tx.eth_type_or_length) ? 1'b1 : 1'b0) : 1'b0) : 1'b0;

   if(trans_stat_tx.eth_type_or_length == 'h8808) 
     oversize_err = (frame_size_tx > 'd64) ? 1 : 0;
   else
     oversize_err = (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead)) ? 1 : 0;

   undersize_err = (frame_size_tx < 'd64) ? 1 : 0;

   if(trans_stat_tx.eth_type_or_length == 'h8808) 
     cnt_frame_bytes = 2;

    //DM_TODO : remove length_error_tx = length_error_tx && gdr_ral_get("mac_cfg_txmac_ehip_cfg","tx_plen_en");
    illegal_length_type_field_tx = trans_stat_tx.eth_type_or_length inside {[1501:1535]} ? 1 : 0;
    
    illegal_length_type_field_tx = illegal_length_type_field_tx && (!(tx_vlan_disable==1 && (trans_stat_tx.frame_type == ETH_VLAN_FRAME || trans_stat_tx.frame_type==ETH_JUMBO_VLAN_FRAME || trans_stat_tx.frame_type==ETH_STACKED_VLAN_FRAME || trans_stat_tx.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME)));

   `uvm_info("ETH REF MODEL", $sformatf("frame_size_tx = %0d, seen_tx_error_insertion = %0d length_error_tx = %0d, oversize_err = %0d, undersize_err = %0d",frame_size_tx,trans_stat_tx.seen_tx_error_insertion,length_error_tx, oversize_err, undersize_err),UVM_MEDIUM)
   `uvm_info("ETH REF MODEL", $sformatf("frame_size_tx = %0d, dest_address[40] = %0b seen_tx_error_insertion = %0d length_error_tx = %0d",frame_size_tx,trans_stat_tx.dest_address[40],trans_stat_tx.seen_tx_error_insertion,length_error_tx),UVM_MEDIUM)
  `uvm_info("ETH REF MODEL", $sformatf("reg_model.MAX_TX_SIZE_CONFIG = %0d",gdr_ral_get("mac_cfg_max_tx_size_config")),UVM_MEDIUM)
	 `uvm_info("ETH REF MODEL", $sformatf("shadow_req_grant_rx = %0b , shadow_req_rx = %0b , snap_req_grant_rx = %0b",shadow_req_grant_rx,shadow_req_rx,snap_req_grant_rx),UVM_MEDIUM)
	 `uvm_info("ETH REF MODEL", $sformatf("shadow_req_grant_tx = %0b , shadow_req_tx = %0b , snap_req_grant_tx = %0b snapshot_en signal = %0b",shadow_req_grant_tx,shadow_req_tx,snap_req_grant_tx,sideband_if.snapshot_en),UVM_MEDIUM)
   //`uvm_info("ETH REF MODEL", $sformatf("%s: Packet received at vip tx stat...",func_name),UVM_MEDIUM)
   //trans_stat_tx.print;
   //Frame starts
   tx_st_frame = tx_st_frame + 1;
   spy_if.tx_st_frame = tx_st_frame ;
   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_st_lo"),.value(tx_st_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_st_hi"),.value(tx_st_frame[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end
   if(!oversize_err && !undersize_err && !trans_stat_tx.seen_tx_error_insertion && !length_error_tx) begin
     tx_stats_framesOK = tx_stats_framesOK + 1;
   end
   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("tx_stats_framesOK0"),.value(tx_stats_framesOK[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("tx_stats_framesOK1"),.value(tx_stats_framesOK[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end
   if((oversize_err || trans_stat_tx.seen_tx_error_insertion || length_error_tx) && !undersize_err) begin
     tx_stats_framesErr = tx_stats_framesErr + 1;
   end
   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("tx_stats_framesErr0"),.value(tx_stats_framesErr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("tx_stats_framesErr1"),.value(tx_stats_framesErr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end   
   if(oversize_err || undersize_err || trans_stat_tx.seen_tx_error_insertion || length_error_tx) begin
     tx_stats_ifErrors = tx_stats_ifErrors + 1;
   end
   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("tx_stats_ifErrors0"),.value(tx_stats_ifErrors[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("tx_stats_ifErrors1"),.value(tx_stats_ifErrors[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   end      
   
   // Fragment frame counter
   //DM_TODO: if(frame_size_tx < 'd64 && trans_stat_tx.seen_tx_error_insertion) begin
   //DM_TODO:   tx_fragment_cntr = tx_fragment_cntr + 1;
   //DM_TODO:   spy_if.tx_fragment_cntr = tx_fragment_cntr ;
   //DM_TODO:   //tx_fragment_cntr = 0;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_fragments_lo"),.value(tx_fragment_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // Jabber frame counter
   //DM_TODO: if(frame_size_tx > gdr_ral_get("mac_cfg_max_tx_size_config") && trans_stat_tx.seen_tx_error_insertion) begin
   //DM_TODO:   tx_jabber_cntr = tx_jabber_cntr + 1;
   //DM_TODO:   spy_if.tx_jabber_cntr = tx_jabber_cntr ;
   //DM_TODO:   //tx_jabber_cntr = 0;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_jabbers_lo"),.value(tx_jabber_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // Frame with FCS error counter
   //DM_TODO: if((frame_size_tx >='d64) && (frame_size_tx <= gdr_ral_get("mac_cfg_max_tx_size_config")) && trans_stat_tx.seen_tx_error_insertion) begin
   //DM_TODO:   tx_fcs_cntr = tx_fcs_cntr + 1;
   //DM_TODO:   spy_if.tx_fcs_cntr = tx_fcs_cntr ;
   //DM_TODO:   //tx_fcs_cntr = 0;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_fcs_lo"),.value(tx_fcs_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // FCS ok error counter
   //DM_TODO: if(frame_size_tx >='d64 && frame_size_tx <= gdr_ral_get("mac_cfg_max_tx_size_config") && trans_stat_tx.seen_tx_error_insertion) begin
   //DM_TODO:   tx_fcserr_okpkt = tx_fcserr_okpkt + 1;
   //DM_TODO:   spy_if.tx_fcserr_okpkt = tx_fcserr_okpkt ;
   //DM_TODO:   //tx_fcserr_okpkt = 0;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_fcs_err_okpkt_lo"),.value(tx_fcserr_okpkt[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   // MCAST data frame related counters
   if( trans_stat_tx.dest_address[40] == 'h1 && trans_stat_tx.eth_type_or_length != 'h8808) begin
     if((trans_stat_tx.dest_address != 'hff_ff_ff_ff_ff_ff && (trans_stat_tx.seen_tx_error_insertion || length_error_tx  || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead)))) && !(frame_size_tx < 'd64)) begin
       tx_mcast_data_err_cntr = tx_mcast_data_err_cntr + 1;
       spy_if.tx_mcast_data_err_cntr = tx_mcast_data_err_cntr ;
       //tx_mcast_data_err_cntr = 0;
       if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_err_lo"),.value(tx_mcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
     if(trans_stat_tx.dest_address != 'hff_ff_ff_ff_ff_ff && !trans_stat_tx.seen_tx_error_insertion && !length_error_tx && !((frame_size_tx < 'd64) || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead)))) begin
       tx_mcast_data_ok_cntr = tx_mcast_data_ok_cntr + 1;
       spy_if.tx_mcast_data_ok_cntr = tx_mcast_data_ok_cntr ;
       if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_lo"),.value(tx_mcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_hi"),.value(tx_mcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // BCAST data frame related counters
   if(trans_stat_tx.dest_address == 'hff_ff_ff_ff_ff_ff && trans_stat_tx.eth_type_or_length != 'h8808) begin
     if((trans_stat_tx.seen_tx_error_insertion || length_error_tx  || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead))) && !(frame_size_tx < 'd64)) begin
       tx_bcast_data_err_cntr = tx_bcast_data_err_cntr + 1;
       spy_if.tx_bcast_data_err_cntr = tx_bcast_data_err_cntr ;
       //tx_bcast_data_err_cntr = 0;
       if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_err_lo"),.value(tx_bcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end 
     if(!length_error_tx  && !((frame_size_tx < 'd64) || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead)))) begin
         tx_bcast_data_ok_cntr = tx_bcast_data_ok_cntr + 1;
         spy_if.tx_bcast_data_ok_cntr = tx_bcast_data_ok_cntr ;
         if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_lo"),.value(tx_bcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_hi"),.value(tx_bcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
     end
   end
   // UCAST data frame related counters
   if( trans_stat_tx.dest_address[40] == 'h0 && trans_stat_tx.eth_type_or_length != 'h8808) begin
      if((trans_stat_tx.seen_tx_error_insertion || length_error_tx  || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead))) && !(frame_size_tx < 'd64)) begin
        tx_ucast_data_err_cntr = tx_ucast_data_err_cntr + 1;
        spy_if.tx_ucast_data_err_cntr = tx_ucast_data_err_cntr ;
        //tx_ucast_data_err_cntr = 0;
        if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
        gdr_ral_predict(.regname("mac_stats_cntr_tx_utcast_data_err_lo"),.value(tx_ucast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        end
      end
     if(!trans_stat_tx.seen_tx_error_insertion && !length_error_tx && !((frame_size_tx < 'd64) || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead)))) begin
         tx_ucast_data_ok_cntr = tx_ucast_data_ok_cntr + 1;
         spy_if.tx_ucast_data_ok_cntr = tx_ucast_data_ok_cntr ;
         if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_lo"),.value(tx_ucast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_hi"),.value(tx_ucast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
     end
   end
   // MCAST control frame counters
   if( trans_stat_tx.dest_address[40] == 'h1 && trans_stat_tx.eth_type_or_length == 'h8808 && frame_size_tx >='d64 && frame_size_tx <= gdr_ral_get("mac_cfg_max_tx_size_config")) begin
     //DM_TODO: if(trans_stat_tx.dest_address != 'hff_ff_ff_ff_ff_ff && trans_stat_tx.seen_tx_error_insertion) begin
     //DM_TODO:   tx_mcast_ctrl_err_cntr = tx_mcast_ctrl_err_cntr + 1;
     //DM_TODO:   spy_if.tx_mcast_ctrl_err_cntr = tx_mcast_ctrl_err_cntr ;
     //DM_TODO:   //tx_mcast_ctrl_err_cntr = 0;
     //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_err_lo"),.value(tx_mcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
     if(trans_stat_tx.dest_address != 'hff_ff_ff_ff_ff_ff && !trans_stat_tx.seen_tx_error_insertion && !length_error_tx && frame_size_tx==64) begin
       if(trans_stat_tx.frame_type == ETH_SFC_FRAME || trans_stat_tx.frame_type == ETH_PFC_FRAME) begin 
         tx_mcast_ctrl_ok_cntr = tx_mcast_ctrl_ok_cntr + 1;
         spy_if.tx_mcast_ctrl_ok_cntr = tx_mcast_ctrl_ok_cntr ;
         if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_lo"),.value(tx_mcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_hi"),.value(tx_mcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
       end
     end
   end
   // BCAST control frame counters
   if(trans_stat_tx.dest_address == 'hff_ff_ff_ff_ff_ff && trans_stat_tx.eth_type_or_length == 'h8808 && frame_size_tx >='d64 && frame_size_tx <= gdr_ral_get("mac_cfg_max_tx_size_config")) begin
     //DM_TODO: if(trans_stat_tx.seen_tx_error_insertion) begin
     //DM_TODO:   tx_bcast_ctrl_err_cntr = tx_bcast_ctrl_err_cntr + 1;
     //DM_TODO:   spy_if.tx_bcast_ctrl_err_cntr = tx_bcast_ctrl_err_cntr ;
     //DM_TODO:   //tx_bcast_ctrl_err_cntr = 0;
     //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_err_lo"),.value(tx_bcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
     if(!trans_stat_tx.seen_tx_error_insertion && !length_error_tx && frame_size_tx==64) begin
       if(trans_stat_tx.frame_type == ETH_SFC_FRAME || trans_stat_tx.frame_type == ETH_PFC_FRAME) begin 
         tx_bcast_ctrl_ok_cntr = tx_bcast_ctrl_ok_cntr + 1;
         spy_if.tx_bcast_ctrl_ok_cntr = tx_bcast_ctrl_ok_cntr ;
         if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_lo"),.value(tx_bcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_hi"),.value(tx_bcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
       end
     end
   end
   // UCAST control frame counters
   if(trans_stat_tx.dest_address[40] == 'h0 && trans_stat_tx.eth_type_or_length == 'h8808 && frame_size_tx >='d64 && frame_size_tx <= gdr_ral_get("mac_cfg_max_tx_size_config")) begin
     //DM_TODO: if(trans_stat_tx.seen_tx_error_insertion) begin
     //DM_TODO:   tx_ucast_ctrl_err_cntr = tx_ucast_ctrl_err_cntr + 1;
     //DM_TODO:   spy_if.tx_ucast_ctrl_err_cntr = tx_ucast_ctrl_err_cntr ;
     //DM_TODO:   //tx_ucast_ctrl_err_cntr = 0;
     //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_err_lo"),.value(tx_ucast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:   end
     //DM_TODO: end
     if(!trans_stat_tx.seen_tx_error_insertion && !length_error_tx && frame_size_tx==64) begin
       if(trans_stat_tx.frame_type == ETH_SFC_FRAME || trans_stat_tx.frame_type == ETH_PFC_FRAME) begin 
         tx_ucast_ctrl_ok_cntr = tx_ucast_ctrl_ok_cntr + 1;
         spy_if.tx_ucast_ctrl_ok_cntr = tx_ucast_ctrl_ok_cntr ;
         if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_lo"),.value(tx_ucast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_hi"),.value(tx_ucast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         end
       end
     end
   end
   // PAUSE error/ok counters
   //if(trans_stat_tx.payload[0] == 'h0 && trans_stat_tx.payload[1] == 'h1 && trans_stat_tx.src_address == tx_pfc_saddr && trans_stat_tx.dest_address == tx_pfc_daddr && trans_stat_tx.eth_type_or_length == 'h8808 && frame_size_tx==64 && en_txsfc_pfc[0] == 'h1) begin // Alekh: For received pause packet in TX,  no need to match ADDR CFG
   if(trans_stat_tx.payload[0] == 'h0 && trans_stat_tx.payload[1] == 'h1 && trans_stat_tx.eth_type_or_length == 'h8808 && frame_size_tx==64 && trans_stat_tx.dest_address[40] == 'h0) begin
     //DM_TODO: if(trans_stat_tx.seen_tx_error_insertion) begin
     //DM_TODO:   tx_pause_err_cntr = tx_pause_err_cntr + 1;
     //DM_TODO:   spy_if.tx_pause_err_cntr = tx_pause_err_cntr ;
     //DM_TODO:   //tx_pause_err_cntr = 0;
     //DM_TODO:  if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_err_lo"),.value(tx_pause_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:  end
     //DM_TODO: end 
     if(!trans_stat_tx.seen_tx_error_insertion && frame_size_tx==64) begin
       tx_pause_ok_cntr = tx_pause_ok_cntr + 1;
       spy_if.tx_pause_ok_cntr = tx_pause_ok_cntr ;
       if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_lo"),.value(tx_pause_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_hi"),.value(tx_pause_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // PFC error/ok counters
   if( trans_stat_tx.payload[0] == 'h1 && trans_stat_tx.payload[1] == 'h1 && trans_stat_tx.eth_type_or_length == 'h8808 && frame_size_tx==64 && en_txsfc_pfc[1] == 'h1) begin
     //DM_TODO: if(trans_stat_tx.seen_tx_error_insertion) begin
     //DM_TODO:   tx_pfc_err_cntr = tx_pfc_err_cntr + 1;
     //DM_TODO:   spy_if.tx_pfc_err_cntr = tx_pfc_err_cntr ;
     //DM_TODO:   //tx_pause_err_cntr = 0;
     //DM_TODO:  if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
     //DM_TODO:   gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_err_lo"),.value(tx_pfc_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     //DM_TODO:  end
     //DM_TODO: end 
     if( !trans_stat_tx.seen_tx_error_insertion && frame_size_tx==64) begin
       tx_pfc_ok_cntr = tx_pfc_ok_cntr + 1;
       spy_if.tx_pfc_ok_cntr = tx_pfc_ok_cntr ;
       if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_lo"),.value(tx_pfc_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_hi"),.value(tx_pfc_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       end
     end
   end
   // Different frame sizes related counters
   if(frame_size_tx=='d64) begin
     tx_64b_cntr = tx_64b_cntr + 1;
     spy_if.tx_64b_cntr = tx_64b_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_lo"),.value(tx_64b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_hi"),.value(tx_64b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_tx >= 'd65 && frame_size_tx <= 'd127) begin
     tx_65bto127b_cntr = tx_65bto127b_cntr + 1;
     spy_if.tx_65bto127b_cntr = tx_65bto127b_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_lo"),.value(tx_65bto127b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_hi"),.value(tx_65bto127b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_tx >= 'd128 && frame_size_tx <= 'd255) begin
     tx_128bto255b_cntr = tx_128bto255b_cntr + 1;
     spy_if.tx_128bto255b_cntr = tx_128bto255b_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_lo"),.value(tx_128bto255b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_hi"),.value(tx_128bto255b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   if(frame_size_tx >= 'd256 && frame_size_tx <= 'd511) begin
     tx_256bto511b_cntr = tx_256bto511b_cntr + 1;
     spy_if.tx_256bto511b_cntr = tx_256bto511b_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_lo"),.value(tx_256bto511b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_hi"),.value(tx_256bto511b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   `uvm_info("ETH REF MODEL", "tx_frame_ok_cntr_1",UVM_MEDIUM)
     end
   end
   if(frame_size_tx >= 'd512 && frame_size_tx <= 'd1023) begin
     tx_512bto1023b_cntr = tx_512bto1023b_cntr + 1;
     spy_if.tx_512bto1023b_cntr = tx_512bto1023b_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_lo"),.value(tx_512bto1023b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_hi"),.value(tx_512bto1023b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   `uvm_info("ETH REF MODEL", "tx_frame_ok_cntr_2",UVM_MEDIUM)
     end
   end
   if(frame_size_tx >= 'd1024 && frame_size_tx <= 'd1518) begin
     tx_1024bto1518b_cntr = tx_1024bto1518b_cntr + 1;
     spy_if.tx_1024bto1518b_cntr = tx_1024bto1518b_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_lo"),.value(tx_1024bto1518b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_hi"),.value(tx_1024bto1518b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   `uvm_info("ETH REF MODEL", "tx_frame_ok_cntr_3",UVM_MEDIUM)
     end
   end
   // GDR: if(frame_size_tx >= 'd1519 && frame_size_tx <= gdr_ral_get("mac_cfg_max_tx_size_config")) begin
    if(frame_size_tx >= 'd1519) begin
     tx_1519btomax_cntr = tx_1519btomax_cntr + 1;
     spy_if.tx_1519btomax_cntr = tx_1519btomax_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_lo"),.value(tx_1519btomax_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_hi"),.value(tx_1519btomax_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // OVERSIZED frame counter
   if(oversize_err) begin
     tx_oversize_cntr = tx_oversize_cntr + 1;
     spy_if.tx_oversize_cntr = tx_oversize_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_oversize_lo"),.value(tx_oversize_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // RUNT frame counter
   if(frame_size_tx < 64) begin
     tx_runt_cntr = tx_runt_cntr + 1;
     spy_if.tx_runt_cntr = tx_runt_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_runt_lo"),.value(tx_runt_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end
   // Malformed frames
   //DM_TODO: if(trans_stat_tx.seen_tx_error_insertion == 1) begin
   //DM_TODO:   //Refer HSD : 22012524219
   //DM_TODO:   //tx_malformed_cntr = tx_malformed_cntr + 1;
   //DM_TODO:   spy_if.tx_malformed_cntr = tx_malformed_cntr ;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_malformed_lo"),.value(tx_malformed_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // Badlt frames
   //DM_TODO: if(illegal_length_type_field_tx == 1) begin
   //DM_TODO:   tx_badlt_frame = tx_badlt_frame + 1;
   //DM_TODO:   spy_if.tx_badlt_frame = tx_badlt_frame ;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_badlt_lo"),.value(tx_badlt_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   //DM_TODO: // lenerr frames
   //DM_TODO: if(length_error_tx == 1 && (gdr_ral_get("mac_cfg_txmac_ehip_cfg","tx_plen_en"))) begin //HSD 16011482424
   //DM_TODO:   tx_lenerr_frame = tx_lenerr_frame + 1;
   //DM_TODO:   spy_if.tx_lenerr_frame = tx_lenerr_frame ;
   //DM_TODO:   if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
   //DM_TODO:     gdr_ral_predict(.regname("mac_stats_cntr_tx_lenerr_lo"),.value(tx_lenerr_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
   //DM_TODO:   end
   //DM_TODO: end
   // PAYLOAD size ok counter
   // HSD 16011471383 (BAD packets (of oversize and error size? or else) included in octet count)
   //if(frame_size_rx >= 64 && frame_size_rx <= gdr_ral_get("mac_cfg_max_rx_size_config") && !crc_error && !malformed_error && !illegal_length_type_field) begin
//   if(!(trans_stat_tx.seen_tx_error_insertion || length_error_tx || (frame_size_tx < 'd64) || (frame_size_tx > (gdr_ral_get("mac_cfg_max_tx_size_config") + tag_overhead))) || ((trans_stat_tx.eth_type_or_length == 'h8808) && (frame_size_tx != 'h64))) 
   if(!(trans_stat_tx.seen_tx_error_insertion || length_error_tx || oversize_err || undersize_err))
   begin
     if(tx_vlan_disable==0) begin
       tx_payload_ok_cntr = (tx_payload_ok_cntr + trans_stat_tx.payload.size()) - cnt_frame_bytes;
     end
     else begin
       if(trans_stat_tx.frame_type==ETH_VLAN_FRAME || trans_stat_tx.frame_type==ETH_JUMBO_VLAN_FRAME) begin
         tx_payload_ok_cntr = (tx_payload_ok_cntr + trans_stat_tx.payload.size() + 4) - cnt_frame_bytes;
       end
       else if (trans_stat_tx.frame_type==ETH_STACKED_VLAN_FRAME || trans_stat_tx.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
         tx_payload_ok_cntr = (tx_payload_ok_cntr + trans_stat_tx.payload.size() + 8) - cnt_frame_bytes;
       end
       else begin
         tx_payload_ok_cntr = (tx_payload_ok_cntr + trans_stat_tx.payload.size()) - cnt_frame_bytes;
       end
     end
     if(trans_stat_tx.seen_tx_error_insertion) tx_octet_error += 8;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       spy_if.tx_payload_ok_cntr = tx_payload_ok_cntr ;
       gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_lo"),.value(tx_payload_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_hi"),.value(tx_payload_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end
   end

   `uvm_info("ETH REF MODEL", "tx_payload_ok_cntr",UVM_MEDIUM)
   // FRAME size ok counter
   // HSD 16011471383 (BAD packets (of oversize and error size? or else) included in octet count)
   //if(frame_size_rx >= 64 && frame_size_rx <= gdr_ral_get("mac_cfg_max_rx_size_config") && !crc_error && !malformed_error && !illegal_length_type_field) begin

     tx_frame_ok_cntr = tx_frame_ok_cntr + frame_size_tx;
     spy_if.tx_frame_ok_cntr = tx_frame_ok_cntr ;
     if(snap_req_grant_tx!=1 && sideband_if.snapshot_en!=1) begin
       gdr_ral_predict(.regname("mac_stats_cntr_tx_octetsok_lo"),.value(tx_frame_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_octetsok_hi"),.value(tx_frame_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
     end

 endfunction:write_stat_checker_tx

//Function: priority_status_data HSD 16010938180
function priority_status_data(ref vector_uvc_packet trans);
  if(dyn_rcfg_obj_inst.mode== PCSMAC) begin
    if (trans.status_data[`S_VLAN_FRAME]) begin trans.status_data = 0; trans.status_data[`S_VLAN_FRAME] = 1'b1;  end
    else if (trans.status_data[`PAUSE_FRAME]) begin trans.status_data = 0; trans.status_data[`PAUSE_FRAME] = 1'b1;  trans.status_data[`CONTROL_FRAME] = 1'b1; end //TODO Currently aligning with RTL and HSD comments, have to fix accodingly to FS
    else if (trans.status_data[`CONTROL_FRAME]) begin trans.status_data = 0; trans.status_data[`CONTROL_FRAME] = 1'b1;  end
    else if (trans.status_data[`ILLEGAL_LT_FRAME]) begin trans.status_data = 0; end // No Indication in AVST
    else if (trans.status_data[`PFC_FRAME]) begin trans.status_data = 0;  end // No Indication in AVST
    else if (trans.status_data[`BRAODCAST_FRAME]) begin trans.status_data = 0; trans.status_data[`BRAODCAST_FRAME] = 1'b1;  end
  end
  if(dyn_rcfg_obj_inst.mode== MACSEG) begin
    if (trans.status_data[`S_VLAN_FRAME]) begin trans.status_data = 0; trans.status_data[`S_VLAN_FRAME] = 1'b1;  end
    else if (trans.status_data[`PAUSE_FRAME]) begin trans.status_data = 0; trans.status_data[`PAUSE_FRAME] = 1'b1;  end
    else if (trans.status_data[`CONTROL_FRAME]) begin trans.status_data = 0; trans.status_data[`CONTROL_FRAME] = 1'b1;  end
    else if (trans.status_data[`ILLEGAL_LT_FRAME]) begin trans.status_data = 0; trans.status_data[`ILLEGAL_LT_FRAME] = 1'b1;  end
    else if (trans.status_data[`PFC_FRAME]) begin trans.status_data = 0; trans.status_data[`PFC_FRAME] = 1'b1;  end
    else if (trans.status_data[`BRAODCAST_FRAME]) begin trans.status_data = 0; trans.status_data[`BRAODCAST_FRAME] = 1'b1;  end
  end
endfunction:priority_status_data
 
//Function: vector_status_data
//Collect status data using of eth_packet transaction & send to sb for comparison
function vector_status_data(eth_packet t_clone,input int frame_size,int unsigned vlan_disable,bit crc_error,output vector_uvc_packet trans);
 
   int ctrl_header_bytes;
  
  //DM_TODO : rx_pause_addr[31:0] = gdr_ral_get("mac_cfg_rx_pause_daddrl");//reg_model.rx_pause_daddrl.get();
  //DM_TODO : rx_pause_addr[47:32] = gdr_ral_get("mac_cfg_rx_pause_daddrh");//reg_model.rx_pause_daddrh.get();
  `uvm_info(get_type_name(), $sformatf(" rx_pause_addr from ref_model %h",rx_pause_addr), UVM_MEDIUM)

  trans = vector_uvc_packet::type_id::create("trans", this);
  `uvm_info(get_type_name(), $sformatf("before processed expected packet in ref_model for vip_tx_rx_vector: \n %s",t_clone.sprint()), UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("inside vector_status_data t_clone: \n %s",t_clone.sprint()), UVM_MEDIUM)
  //`uvm_info(get_type_name(), $sformatf("inside vector_status_data trans: \n %s",trans.sprint()), UVM_MEDIUM)
  `uvm_info(get_type_name(), $sformatf("vlan_disable=%0d crc_error=%0b",vlan_disable,crc_error), UVM_MEDIUM) 
  if(t_clone.eth_type_or_length == 'h8808 && (t_clone.frame_type == ETH_SFC_FRAME || t_clone.frame_type ==ETH_PFC_FRAME) ) begin
    ctrl_header_bytes = 2;
  end
  else begin
    ctrl_header_bytes = 0;
  end
   if(frame_size <= 'hFFFF) begin
      if(vlan_disable == 0) begin
        trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START] = (t_clone.payload.size() - ctrl_header_bytes); // Payload size 
        `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: status_data[15:0] = %0d",trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START]), UVM_MEDIUM)
      end
      else begin
        if(t_clone.frame_type == ETH_VLAN_FRAME || t_clone.frame_type == ETH_JUMBO_VLAN_FRAME) begin
          trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START] = (t_clone.payload.size() + 4) - ctrl_header_bytes; // Payload size 
          `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: VLAN : status_data[15:0] = %0d",trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START]), UVM_MEDIUM)
        end
        else if(t_clone.frame_type==ETH_STACKED_VLAN_FRAME || t_clone.frame_type == ETH_JUMBO_STACKED_VLAN_FRAME) begin
          trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START] = (t_clone.payload.size() + 8) - ctrl_header_bytes; // Payload size 
          `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: SVLAN: status_data[15:0] = %0d",trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START]), UVM_MEDIUM)
        end
        else begin
          trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START] = t_clone.payload.size() - ctrl_header_bytes; // Payload size 
          `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: DATA:PAUSE: status_data[15:0] = %0d",trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START]), UVM_MEDIUM)
        end
      end
   end
   else begin
    trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START] = 'hFFFF;
      `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: Frame_size > 'hFFFF, status_data[15:0] = %0h",trans.status_data[`PAYLOAD_LENGTH_END:`PAYLOAD_LENGTH_START]), UVM_MEDIUM)
   end
   
    
  if(frame_size <= 'hFFFF) begin
    trans.status_data[`FRAME_LENGTH_END:`FRAME_LENGTH_START] = frame_size; 
    `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: status_data[31:16] = %0d",trans.status_data[`FRAME_LENGTH_END:`FRAME_LENGTH_START]), UVM_MEDIUM)
    end
  else begin
    trans.status_data[`FRAME_LENGTH_END:`FRAME_LENGTH_START] = 'hFFFF; 
     `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL: Frame_size > 'hFFFF, status_data[31:16] = %0h",trans.status_data[`FRAME_LENGTH_END:`FRAME_LENGTH_START]), UVM_MEDIUM)
  end
  
    
  if((t_clone.frame_type == ETH_STACKED_VLAN_FRAME || t_clone.frame_type == ETH_JUMBO_STACKED_VLAN_FRAME) && vlan_disable==0) begin  //VLAN FRAME//TODO check when vlan detection is enable ? 
    trans.status_data[`S_VLAN_FRAME] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:S_VLAN_FRAME", UVM_MEDIUM)
  end
  if((t_clone.frame_type == ETH_VLAN_FRAME || t_clone.frame_type == ETH_JUMBO_VLAN_FRAME) && vlan_disable==0) begin  // STACKED VLAN FRAME  
    trans.status_data[`R_VLAN_FRAME] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:R_VLAN_FRAME", UVM_MEDIUM)
  end
  if(t_clone.eth_type_or_length == 16'h8808 && (t_clone.frame_type == ETH_SFC_FRAME || t_clone.frame_type ==ETH_PFC_FRAME)) begin // CONTROL FRAME 
    trans.status_data[`CONTROL_FRAME] = 1;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:CONTROL_FRAME", UVM_MEDIUM)
    `uvm_info(get_type_name(), $sformatf("VECTOR_REF_MODEL:pause_frame dest_address =%h  rx_pause_addr=%h  en_rxsfc_pfc=%d rx_pfc_en=%0d crc_error=%d",t_clone.dest_address,rx_pause_addr,en_rxsfc_pfc[0],rx_pfc_en,crc_error), UVM_MEDIUM)
    if(t_clone.eth_type_or_length == 16'h8808 && t_clone.payload[0] == 'h0 && t_clone.payload[1] == 'h1 && ((t_clone.dest_address[40] == 1'h0) || (t_clone.dest_address=='h180_c200_0001))) begin // PAUSE FRAME
      trans.status_data[`PAUSE_FRAME] = 1;
      `uvm_info(get_type_name(), "VECTOR_REF_MODEL:PAUSE_FRAME", UVM_MEDIUM)
    end
   if(t_clone.eth_type_or_length == 16'h8808 && t_clone.payload[0] == 'h1 && t_clone.payload[1] == 'h1 && (t_clone.dest_address=='h180_c200_0001)) begin // PAUSE FRAME
      trans.status_data[`PFC_FRAME] = 1;
      `uvm_info(get_type_name(), "VECTOR_REF_MODEL:PAUSE_FRAME", UVM_MEDIUM)
    end
    else if(t_clone.eth_type_or_length == 16'h8808 && t_clone.payload[0] == 'h0 && t_clone.payload[1] == 'h1 && t_clone.payload.size() == 'd54 && t_clone.dest_address == rx_pause_addr ) begin // PAUSE FRAME
      trans.status_data[`FLOWCONTROL_FRAME] = 1;
      `uvm_info(get_type_name(), "VECTOR_REF_MODEL:malformed SFC PAUSE_FRAME", UVM_MEDIUM)
    end
  end
  if(t_clone.dest_address == 48'hFF_FF_FF_FF_FF_FF) begin // BROADCAST FRAME
    trans.status_data[`BRAODCAST_FRAME] = 1 ;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:BRAODCAST_FRAME", UVM_MEDIUM)
  end
  if(t_clone.dest_address[40] == 1'h1 && t_clone.dest_address != 48'hFF_FF_FF_FF_FF_FF) begin // MULTICAST FRAME
    trans.status_data[`MULTICAST_FRAME] = 1 ;
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:MULTICAST_FRAME", UVM_MEDIUM)
  end
  if(t_clone.dest_address[40] == 1'h0) begin // UNICAST FRAME
    trans.status_data[`UNICAST_FRAME] = 1 ; //1. GDR RTL does not suppoer UCAST. SO have to make it 0 in trans item for scb to sync correctly
    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:UNICAST_FRAME", UVM_MEDIUM)
  end
//  if((t_clone.eth_type_or_length > 'd1518 && t_clone.eth_type_or_length != 16'h8808 ) || 
//     (t_clone.frame_type == ETH_VLAN_FRAME || t_clone.frame_type == ETH_JUMBO_VLAN_FRAME) ||
//     (t_clone.frame_type == ETH_STACKED_VLAN_FRAME || t_clone.frame_type == ETH_JUMBO_STACKED_VLAN_FRAME)) begin // ETH Type Non FC Frame
//    trans.status_data[`ETYPE_NONFC_FRAME] = 1;
//    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:ETYPE_NONFC_FRAME", UVM_MEDIUM)
//  end
// Not present in DM  if((t_clone.eth_type_or_length inside {[1501:1535]}) && (!(vlan_disable==1 && (t_clone.frame_type == ETH_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_VLAN_FRAME || t_clone.frame_type==ETH_STACKED_VLAN_FRAME || t_clone.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME))))begin // ILLEGAL LT Frame
// Not present in DM    trans.status_data[`ILLEGAL_LT_FRAME] = 1;
// Not present in DM    `uvm_info(get_type_name(), "VECTOR_REF_MODEL:ILLEGAL_LT_FRAME", UVM_MEDIUM)
// Not present in DM  end
  //priority_status_data(trans);
endfunction//vector_status_data

//Function: write_reset_port
//This function gets reset uvc transaction and resets the register model based on it
function void write_reset_port(reset_transaction tr);
   `uvm_info("ref model ", $sformatf(" in write_reset_port \n %0s",tr.sprint()), UVM_DEBUG);
   if(tr.assert_ip_reset == 1'b1)
   begin
     reset_ral_and_stats_counters();

   end
endfunction 

function void write_xcvr_avmm_bus_in_0(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 0 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[0].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
   //`uvm_info("AVMMM TRANS ADDR",$sformatf("AVMMM transaction address\n %0h",((tr.address)>>2) - (((tr.address)>>2)%4)) ,UVM_MEDIUM)
     if( tr.address  == regs[i].get_address())
     begin
      `uvm_info("GET REG ADDR",$sformatf("Getting reg address\n %0h",regs[i].get_address()) ,UVM_MEDIUM)
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[0].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[0].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[0].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[0].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[0].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 0 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_0

function void write_xcvr_avmm_bus_in_1(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 1 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[1].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[1].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[1].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[1].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[1].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[1].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 1 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_1


function void write_xcvr_avmm_bus_in_2(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 2 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[2].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[2].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[2].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[2].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[2].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[2].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 2 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_2

function void write_xcvr_avmm_bus_in_3(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 3 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[3].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[3].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[3].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[3].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[3].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[3].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 3 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_3

function void write_xcvr_avmm_bus_in_4(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 4 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[4].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[4].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[4].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[4].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[4].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[4].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 4 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_4

function void write_xcvr_avmm_bus_in_5(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 5 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[5].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[5].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[5].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[5].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[5].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[5].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 5 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_5

function void write_xcvr_avmm_bus_in_6(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 6 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[6].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[6].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[6].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[6].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[6].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[6].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 6 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_6

function void write_xcvr_avmm_bus_in_7(altuvm_avalon_mm_req_base tr);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   logic [31:0] rd_data;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("XCVR 7 : xcvr avmm transaction \n %0s",tr.sprint()), UVM_DEBUG);
   xcvr_reg_model[7].default_map.get_registers(regs);
   foreach(regs[i]) 
   begin
     if( (((tr.address)>>2) - (((tr.address)>>2)%4)) == regs[i].get_address())
     begin
       select_reg = regs[i];
       reg_not_found = 0 ;

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
       end
       
       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
        `ifdef CRETE3
         rd_data = select_reg.get();
         if((((tr.address)>>2)%4) == 0) begin
           rd_data[7:0] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[7].default_map));
         end
         else if((((tr.address)>>2)%4) == 1) begin
           rd_data[15:8] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[7].default_map));
         end
         else if((((tr.address)>>2)%4) == 2) begin
           rd_data[23:16] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[7].default_map));
         end
         else begin
           rd_data[31:24] = tr.data_bytes[0];
           select_reg.predict(.value({rd_data}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[7].default_map));
         end
	`else
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(xcvr_reg_model[7].default_map));
	`endif
       end
     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("XCVR 7 : No Register found with address :%0h",(tr.address)));
   end
endfunction // write_xcvr_avmm_bus_in_7

//Function: write_reset_port
//This function gets avalon uvc transaction, this function is for debuggin purpose only 
function void write_avmm_bus_in(altuvm_avalon_mm_req_base tr);
 uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   bit reg_not_found =1;

   `uvm_info("ref model ", $sformatf("avmm transaction \n %0s",tr.sprint()), UVM_MEDIUM);
   reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
     if (tr.address[17:2] == regs[i].get_address())
     begin
       `uvm_info(get_name(), $sformatf("MS_DBG: Register found with address :%0h", tr.address[17:2]),UVM_NONE);
       select_reg = regs[i];
       reg_not_found = 0 ;
       //Have to predit CNTR_STATUS register as it is RO and RAL mirrored value don't get updated because set_auto_predict is 0.

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_READ)
       begin
         //DM_TODO: check if(select_reg.get_address() == `GET_REG_ADDR(ehip_stats_aibif_status_OFFSET_REG,dyn_rcfg_obj_inst.speed)) begin
         //DM_TODO: check  select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         //DM_TODO: check end
      end

       if(tr.transaction == altuvm_avalon_mm_pkg::AVALON_MM_WRITE)
       begin
           select_reg.predict(.value({tr.data_bytes[3],tr.data_bytes[2],tr.data_bytes[1],tr.data_bytes[0]}),.kind(UVM_PREDICT_WRITE), .map(reg_model.default_map));
           if(select_reg.get_address() == `GET_REG_ADDR(tx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed) && tr.data_bytes[0] == 8'h1) begin
              check_to_clr_stat_cntr(1,0);
           end
           if(select_reg.get_address() == `GET_REG_ADDR(rx_stats_clr_OFFSET_REG,dyn_rcfg_obj_inst.speed) && tr.data_bytes[0] == 8'h1) begin
              check_to_clr_stat_cntr(0,1);
           end
       end

     end
   end
   if(reg_not_found == 1)
   begin
     `uvm_warning("ref model", $sformatf("No Register found with address :%0h",(tr.address)));
   end
endfunction // write_avmm_bus_in

//function void sip_reg_predict();
//
//     // Added by Abhishek Tiwari (atiwari2) , Logic for predicion of SIP regs
//
//     // qhip_scrath is skipped
//     // eth_reset - writing to this register causes reset and dut may
//     // behave differently
//     // Ported the code from eth_env to here (eth_ref_model)
// // default value as per speed and other state
//   case (dyn_rcfg_obj_inst.speed)
//        _10G : eth_rate='h0;
//        _25G : eth_rate='h1;
//        _40G : eth_rate='h2;
//        _50G : eth_rate='h3;
//        _100G : eth_rate='h4;
//        _200G : eth_rate='h5;
//        _400G : eth_rate='h6;
//   endcase
//   
//   case (dyn_rcfg_obj_inst.fec_type)
//        FCFEC: rsfec_type = 'h1;
//        RSFECKR: rsfec_type = 'h2;
//        RSFECKP: rsfec_type = 'h3;
//        LLFEC: rsfec_type = 'h4;
//        NOFEC: rsfec_type = 'h0;
//   endcase 
//   
//   case (dyn_rcfg_obj_inst.fc)
//        0: flow_control_mode = 'h6;
//        1: flow_control_mode = 'h5;
//        2: flow_control_mode = 'h0;
//   endcase
//
//   case (dyn_rcfg_obj_inst.trans_type)
//        0: xcvr_type ='h0; //UX
//        1: xcvr_type ='h1; //BK
//   endcase
//
//   case (dyn_rcfg_obj_inst.ch_num)
//        1: num_lanes ='h1;
//        2: num_lanes ='h2;
//        4: num_lanes ='h4;
//        8: num_lanes ='h8;
//   endcase
//
//   case (dyn_rcfg_obj_inst.mode) 
//        MACSEG : client_intf ='h0;
//        PCSMAC : client_intf ='h1;
//        PCSONLY : client_intf ='h2;
//        OTN : client_intf ='h3;
//        FLEXE : client_intf ='h4;
//   endcase
//   
//   if (dyn_rcfg_obj_inst.ptp == 0 ) //ptp
//        ptp_enable = 'h0;
//   else //if (dyn_rcfg_obj_inst.ptp == 1 )  //ptp
//        ptp_enable = 'h1;
//
//   if (dyn_rcfg_obj_inst.anlt == 0 ) //anlt
//        anlt_enable ='h0;
//   else //if (dyn_rcfg_obj_inst.anlt == 1 )  //anlt
//        anlt_enable ='h1;
//
//   case (dyn_rcfg_obj_inst.speed)
//        _10G : modulation_type = 'h0;
//        _25G : modulation_type = 'h0;
//        _40G : modulation_type = 'h0;
//        _50G :begin 
//                 if (dyn_rcfg_obj_inst.ch_num == 1 )
//                   modulation_type = 'h1;
//                 else if (dyn_rcfg_obj_inst.ch_num == 2 )
//                   modulation_type = 'h0;
//              end
//        _100G : begin 
//                 if (dyn_rcfg_obj_inst.ch_num == 1 )
//                   modulation_type = 'h1;
//                 else if (dyn_rcfg_obj_inst.ch_num == 2 )
//                   modulation_type = 'h1;
//                 else if (dyn_rcfg_obj_inst.ch_num == 4 )
//                   modulation_type = 'h0;
//              end
// 
//        _200G : begin 
//                 if (dyn_rcfg_obj_inst.ch_num == 2 )
//                   modulation_type = 'h1;
//                 else if (dyn_rcfg_obj_inst.ch_num == 4 )
//                   modulation_type = 'h1;
//                 else if (dyn_rcfg_obj_inst.ch_num == 8 )
//                   modulation_type = 'h0;
//              end
//
//        _400G : begin
//                 if (dyn_rcfg_obj_inst.ch_num == 4 )
//                   modulation_type = 'h1;
//                 else if (dyn_rcfg_obj_inst.ch_num == 8 )
//                   modulation_type = 'h1;
//              end
//
//   endcase
//
//     //gui_option_reg = {7'b0,num_lanes,xcvr_type,client_intf,flow_control_mode,ptp_enable,rsfec_type,modulation_type,anlt_enable,eth_rate,3'h3,2'b1};
//     //reg_model.gui_option.predict(.value(gui_option_reg[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//
//     // `ETH_F_ALL_eth_reset_status_OFFSET_REG 
//     case (reset_if.rst_ack_n)
//         0  : rst_ack_n = 1'h0;
//         1  : rst_ack_n = 1'h1;
//     endcase
//     case (reset_if.tx_rst_ack_n)
//         0  : tx_rst_ack_n = 1'h0;
//         1  : tx_rst_ack_n = 1'h1;
//     endcase
//     case (reset_if.rx_rst_ack_n)
//         0  : rx_rst_ack_n = 1'h0;
//         1  : rx_rst_ack_n = 1'h1;
//     endcase
//     if ((sideband_if.tx_lane_stable==1) && (reset_if.tx_rst_ack_n =1))
//         tx_lane_current_state = 3'h6;
//     else if ((sideband_if.tx_lane_stable==0) && (reset_if.rst_ack_n ==1'b1 ) && (reset_if.tx_rst_ack_n =1))
//         tx_lane_current_state = 3'h4;
//     else if ((sideband_if.tx_lane_stable==0) && (reset_if.rst_ack_n ==1'b0 ) && (reset_if.tx_rst_ack_n =0))
//         tx_lane_current_state = 3'h5;
//     else if ((~sideband_if.rst ==1'b0 ) && (reset_if.tx_rst_ack_n =0))
//         tx_lane_current_state = 3'h1;
//     else 
//         tx_lane_current_state = 3'h0;
//     
//     /*if ((spy_if.rx_pcs_ready==1) && (reset_if.rx_rst_ack_n =1))
//         rx_lane_current_state = 3'h6;
//     else if ((spy_if.rx_pcs_ready==0) && (reset_if.rst_ack_n ==1'b1 ) && (reset_if.rx_rst_ack_n =1))
//         rx_lane_current_state = 3'h4;
//     else if ((spy_if.rx_pcs_ready==0) && (reset_if.rst_ack_n ==1'b0 ) && (reset_if.rx_rst_ack_n =0))
//         rx_lane_current_state = 3'h5;
//     else if ((~sideband_if.rst ==1'b0 ) && (reset_if.rx_rst_ack_n =0))
//         rx_lane_current_state = 3'h1;
//     else 
//         rx_lane_current_state = 3'h0;*/
//
//     if(reset_if.rx_rst_ack_n ==1'b1) begin
//         rx_lane_current_state = 3'h6;
//     end else if((reset_if.rst_ack_n ==1'b0 ) && (reset_if.rx_rst_ack_n ==0))begin
//         rx_lane_current_state = 3'h5;
//     end else if ((~sideband_if.rst ==1'b0 ) && (reset_if.rx_rst_ack_n ==0)) begin
//         rx_lane_current_state = 3'h1;
//     end else begin
//        rx_lane_current_state = 3'h0;     
//     end
//
//
//     //eth_reset_status_reg = {8'h0,8'h0,1'b0,rx_lane_current_state,1'b0,tx_lane_current_state,5'h0,rx_rst_ack_n,tx_rst_ack_n,rst_ack_n};
//	 //`uvm_info("ETH REF MODEL", $sformatf("SIP_REG_PREDICT_eth_reset_status:: eth_reset_status_reg = %h ",eth_reset_status_reg ),UVM_NONE)
//     //reg_model.eth_reset_status.predict(.value(eth_reset_status_reg[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_phy_tx_pll_locked_OFFSET_REG 
//     //phy_tx_pll_locked_reg = {24'h0,spy_if.tx_pll_locked};
//     //reg_model.phy_tx_pll_locked.predict(.value(phy_tx_pll_locked_reg[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_phy_eiofreq_locked_OFFSET_REG 
//     //phy_eiofreq_locked_reg = {24'h0,spy_if.cdr_lock};
//     //reg_model.phy_eiofreq_locked.predict(.value(phy_eiofreq_locked_reg),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_pcs_status_OFFSET_REG 
//     if (sideband_if.tx_lane_stable==1)
//       tx_lanes_stable =1'h1;  
//     else //if (sideband_if.tx_lane_stable==0)
//       tx_lanes_stable =1'h0;     
//     if (spy_if.rx_pcs_ready==1)
//       rx_pcs_ready =1'h1;  
//     else //if (spy_if.rx_pcs_ready==0)
//       rx_pcs_ready =1'h0;  
//     if(spy_if.rx_dsk_done==1) begin
//         rx_dsk_done = 1'h1;
//     end else begin
//         rx_dsk_done = 1'h0;
//     end
//     //pcs_status_reg =  {28'h0,rx_pcs_ready,tx_lanes_stable,1'b0,rx_dsk_done};
//     //reg_model.pcs_status.predict(.value(pcs_status_reg[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_link_fault_status_OFFSET_REG 
//     if (spy_if.rf_status ==1) 
//       rfault ='h1;  
//     else //if (spy_if.remote_fault==0)
//       rfault ='h0;
//     if (spy_if.lf_status ==1)
//       lfault = 'h1;  
//     else //if (spy_if.local_fault==0)
//     lfault = 'h0;  
//     //link_fault_status_reg = {30'h0,rfault,lfault};
//     //reg_model.link_fault_status.predict(.value(link_fault_status_reg[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_aib_transfer_ready_status_OFFSET_REG
//     case (dyn_rcfg_obj_inst.speed)
//          _25G   : ehip_tx_transfer_ready = 16'h0001;
//          _50G   : ehip_tx_transfer_ready = 16'h0003;
//          _100G  : ehip_tx_transfer_ready = 16'h000F;
//          _200G  : ehip_tx_transfer_ready = 16'h00FF;
//          _400G  : ehip_tx_transfer_ready = 16'hFFFF;
//     endcase
//     case (dyn_rcfg_obj_inst.speed)
//          _25G   : ehip_rx_transfer_ready = 16'h0001;
//          _50G   : ehip_rx_transfer_ready = 16'h0003;
//          _100G  : ehip_rx_transfer_ready = 16'h000F;
//          _200G  : ehip_rx_transfer_ready = 16'h00FF;
//          _400G  : ehip_rx_transfer_ready = 16'hFFFF;
//     endcase
//     aib_transfer_ready_status_reg = {ehip_tx_transfer_ready,ehip_rx_transfer_ready};
//     reg_model.aib_transfer_ready_status.predict(.value(aib_transfer_ready_status_reg[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_clk_tx_khz_OFFSET_REG 
//     if(dyn_rcfg_obj_inst.en_async_adp) begin
//	     //#HSD : 16012971982
//	     clk_tx_khz=spy_if.async_clk_freq_tx;
//     end else begin	     
//       case (dyn_rcfg_obj_inst.speed)
//          _10G   : clk_tx_khz = 'h186;
//          _25G   : clk_tx_khz = 'h186;
//          _40G   : clk_tx_khz = 'h186;
//          _50G   : clk_tx_khz = 'h186;
//          _100G  : clk_tx_khz = 'h186;
//          _200G  : clk_tx_khz = 'h186;
//          _400G  : clk_tx_khz = 'h186;
//       endcase
//     end  
//     reg_model.clk_tx_khz.predict(.value({clk_tx_khz}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_clk_rx_khz_OFFSET_REG 
//     if(dyn_rcfg_obj_inst.en_async_adp) begin
//	     clk_rx_khz=spy_if.async_clk_freq_rx;
//     end else begin	     
//     case (dyn_rcfg_obj_inst.speed)
//          _10G   : clk_rx_khz = 'h193;
//          _25G   : clk_rx_khz = 'h193;
//          _40G   : clk_rx_khz = 'h193;
//          _50G   : clk_rx_khz = 'h193;
//          _100G  : clk_rx_khz = 'h193;
//          _200G  : clk_rx_khz = 'h193;
//          _400G  : clk_rx_khz = 'h193;
//     endcase
//     end
//     reg_model.clk_rx_khz.predict(.value({clk_rx_khz}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_clk_pll_khz_OFFSET_REG
//     case (dyn_rcfg_obj_inst.speed)
//          _10G   : clk_pll_khz = 'h193;
//          _25G   : clk_pll_khz = 'h193;
//          _40G   : clk_pll_khz = 'h193;
//          _50G   : clk_pll_khz = 'h193;
//          _100G  : clk_pll_khz = 'h193;
//          _200G  : clk_pll_khz = 'h19F;
//          _400G  : clk_pll_khz = 'h19F;
//     endcase
//
//     reg_model.clk_pll_khz.predict(.value({clk_pll_khz}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_clk_tx_div_khz_OFFSET_REG
//     case (dyn_rcfg_obj_inst.speed)
//          _10G   : clk_tx_div_khz = 'h9C;
//          _25G   : begin
//	           if(dyn_rcfg_obj_inst.syspllcnt == 'd8300781250 || 'd8056640625)
//                     clk_tx_div_khz ='h186;
//		   end
//          _40G   : clk_tx_div_khz = 'h138;
//          _50G   : clk_tx_div_khz = 'h186;
//          _100G  : clk_tx_div_khz = 'h186;
//          _200G  : clk_tx_div_khz = 'h186;
//          _400G  : clk_tx_div_khz = 'h186;
//     endcase
// 
//     reg_model.clk_tx_div_khz.predict(.value({clk_tx_div_khz}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_clk_rec_div64_khz_OFFSET_REG
//     case (dyn_rcfg_obj_inst.speed)
//          _10G   : clk_rec_div64_khz = 'hA1;
//          _25G   : case (dyn_rcfg_obj_inst.fec_type)
//                        NOFEC   : clk_rec_div64_khz ='h193;  
//                        FCFEC   : clk_rec_div64_khz ='h193;  
//                        RSFECKR : clk_rec_div64_khz ='h193;  
//                        LLFEC   : clk_rec_div64_khz ='h19F;
//                        RSFECKP : clk_rec_div64_khz ='h19F;
//                   endcase
//          _40G   : clk_rec_div64_khz = 'hA1;
//          _50G   : clk_rec_div64_khz = 'h193;
//          _100G  : clk_rec_div64_khz = 'h193;
//          _200G  : clk_rec_div64_khz = 'h19F;
//          _400G  : clk_rec_div64_khz = 'h19F;
//     endcase
//     reg_model.clk_rec_div64_khz.predict(.value({clk_rec_div64_khz}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_clk_rec_div_khz_OFFSET_REG 
//     case (dyn_rcfg_obj_inst.speed)
//          _10G   : clk_rec_div_khz = 'h9C;
//          _25G   : case (dyn_rcfg_obj_inst.fec_type)
//                        NOFEC   : clk_rec_div_khz ='h186;  
//                        FCFEC   : clk_rec_div_khz ='h186;  
//                        RSFECKR : clk_rec_div_khz ='h186;  
//                        LLFEC   : clk_rec_div_khz ='h186;
//                        RSFECKP : clk_rec_div_khz ='h186;
//                   endcase
//          _40G   : clk_rec_div_khz = 'h138;
//          _50G   : clk_rec_div_khz = 'h186;
//          _100G  : clk_rec_div_khz = 'h186;
//          _200G  : clk_rec_div_khz = 'h186;
//          _400G  : clk_rec_div_khz = 'h186;
//     endcase
//     reg_model.clk_rec_div_khz.predict(.value({clk_rec_div_khz}),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//
//     //`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG 
//     if(sideband_if.snapshot_en == 0) begin 
//      reg_model.rxmac_adapt_dropped_31_0.predict(.value(rxmac_adapt_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//     end
//
//     //`ETH_F_ALL_rxmac_adapt_dropped_63_32_OFFSET_REG 
//     if(sideband_if.snapshot_en == 0) begin 
//      reg_model.rxmac_adapt_dropped_63_32.predict(.value(rxmac_adapt_dropped_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
//     end
//
//endfunction // sip_reg_predict


   function bit vip_tx_drop_frame(eth_packet trans, bit malformed, bit crc_error);
      string func_name="vip_tx_drop_frame";
      bit [31:0] rx_crc_pass;
      bit [31:0] rx_preamble_pass;
      bit [31:0] rx_pfc_control;
      bit [31:0] rx_frame_control; 
      int drop_frame_size;
      bit wrong_preamble;
      uvm_reg 	regs;
      int act_packed_byte_size;
      
      rx_crc_pass = gdr_ral_get("rx_padcrc_control"); //gdr_ral_get("mac_cfg_mac_crc_config");
      // Value 1 removes CRC Bytes in DM      rx_crc_pass[0] = ~rx_crc_pass[0];
      rx_preamble_pass = gdr_ral_get("rx_custom_preamble_forward"); //gdr_ral_get("mac_cfg_rxmac_ehip_cfg");
            
      if(rx_preamble_pass[0] == 1 && rx_crc_pass[0] == 1)      drop_frame_size = 9;
	  else if(rx_preamble_pass[0] == 1 && rx_crc_pass[0] == 0) drop_frame_size = 13;
	  else if(rx_preamble_pass[0] == 0 && rx_crc_pass[0] == 1) drop_frame_size = 17;
      else                                                     drop_frame_size = 21;
      
      drop_frame_size = 21;
      rx_pfc_control = gdr_ral_get("rx_pfc_control");
      rx_frame_control = gdr_ral_get("rx_frame_control");

      `uvm_info("ETH REF MODEL", $sformatf("malformed %0d , crc_error %0d ",malformed,crc_error),UVM_MEDIUM) //PAVITHRA 
      // for supplementary_addr_chk_seq
      EN_ALLUCAST  = gdr_ral_get("rx_frame_control","EN_ALLUCAST"); 
      EN_ALLMCAST  = gdr_ral_get("rx_frame_control","EN_ALLMCAST"); 
      `uvm_info("ETH REF MODEL", $sformatf("EN_ALLUCAST  %0h, EN_ALLMCAST %0h",EN_ALLUCAST,EN_ALLMCAST),UVM_MEDIUM)
      primary_addr = {gdr_ral_get("mac_cfg_txmac_saddrh"), gdr_ral_get("mac_cfg_txmac_saddrl")};
      supplementary_addr_sel[0] = gdr_ral_get("rx_frame_control","EN_SUPP0");  // getting supplementary addr_sel
      supplementary_addr_sel[1] = gdr_ral_get("rx_frame_control","EN_SUPP1");  // getting supplementary addr_sel
      supplementary_addr_sel[2] = gdr_ral_get("rx_frame_control","EN_SUPP2");  // getting supplementary addr_sel
      supplementary_addr_sel[3] = gdr_ral_get("rx_frame_control","EN_SUPP3");  // getting supplementary addr_sel
      `uvm_info("ETH REF MODEL", $sformatf("supplementary_addr_sel  %0h",supplementary_addr_sel),UVM_MEDIUM)
      case(supplementary_addr_sel[3:0])                        // getting supplementary address
       4'b0001: supplementary_addr = {gdr_ral_get("rx_frame_spaddr0_1"), gdr_ral_get("rx_frame_spaddr0_0")}; 
       4'b0010: supplementary_addr = {gdr_ral_get("rx_frame_spaddr1_1"), gdr_ral_get("rx_frame_spaddr1_0")};   
       4'b0100: supplementary_addr = {gdr_ral_get("rx_frame_spaddr2_1"), gdr_ral_get("rx_frame_spaddr2_0")};
       4'b1000: supplementary_addr = {gdr_ral_get("rx_frame_spaddr3_1"), gdr_ral_get("rx_frame_spaddr3_0")};
       default: supplementary_addr = {gdr_ral_get("rx_frame_spaddr0_1"), gdr_ral_get("rx_frame_spaddr0_0")};
      endcase
     `uvm_info("ETH REF MODEL", $sformatf(" primary_addr  %0h supplementary_addr  %0h supplementary_addr_sel  %0h",primary_addr,supplementary_addr,supplementary_addr_sel[3:0]),UVM_MEDIUM)
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 


      act_packed_byte_size = trans.packed_bytes.size();
      //HSD : 16011924764 && 22012822441 
      if(dyn_rcfg_obj_inst.preamble_passthrough == 1 && dyn_rcfg_obj_inst.speed inside {_40G,_50G} && dyn_rcfg_obj_inst.mode==PCSMAC)  begin
        act_packed_byte_size = act_packed_byte_size-8 ;      
      end
       if((trans.packed_bytes[0] == 8'hfe)||(trans.packed_bytes[1] == 8'hfe)||(trans.packed_bytes[2] == 8'hfe)||(trans.packed_bytes[3] == 8'hfe)||(trans.packed_bytes[4] == 8'hfe)||(trans.packed_bytes[5] == 8'hfe)||(trans.packed_bytes[6] == 8'hfe)||(trans.packed_bytes[7] == 8'hfe)) begin
      `uvm_info(get_name(),$sformatf("Error on Preamble, this packet should be dropped, dest_addr is %0h and size of packed bytes is %0d, preamble is %0h %0h %0h %0h %0h %0h %0h %0h",trans.dest_address,trans.packed_bytes.size(),trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]),UVM_NONE); 
      wrong_preamble = 1'b1;
       end

      
      `uvm_info(get_name(),$sformatf("drop_frame_size=%0d, act_packed_byte_size=%0d ,trans.frame_type=%s", drop_frame_size,act_packed_byte_size,trans.frame_type),UVM_NONE);
      `uvm_info(get_name(),$sformatf("rx_frame_control[3]=%0d rx_frame_control[4]=%0d", rx_frame_control[3],rx_frame_control[4],),UVM_NONE);
      // Frames size < 9 should be dropped. Ref. Table 28 of ehip specification
     //  if (enable_rx_drops == 1'b1) begin
     //HSD - 16011786533 Packet with SFD/Preamble corrupted must dropped- trans_status[28],[26]
     //HSD - 16011962399 eop_pkt_corrupt update
      `uvm_info(get_name(),$sformatf("Size of packed bytes is %0d, preamble is %0h %0h %0h %0h %0h %0h %0h %0h",trans.packed_bytes.size(),trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6],trans.packed_bytes[7]),UVM_MEDIUM); 
       //if ((act_packed_byte_size < drop_frame_size) || (({trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[3],trans.packed_bytes[4],trans.packed_bytes[5],trans.packed_bytes[6]} != 56'hfb555555_555555 ) || (trans.packed_bytes[7] != 8'hd5 ))
       `ifdef ETH_MGE   
            if ((act_packed_byte_size < drop_frame_size) || (trans.packed_bytes[7] != 8'hd5 )
	       || (wrong_preamble == 1'b1) || ((rx_frame_control[3] == 0) && (trans.frame_type==ETH_PFC_FRAME)) || (rx_frame_control[4]==0 && trans.frame_type==ETH_SFC_FRAME)       || (trans.dest_address[40]==1 && EN_ALLMCAST == 1'b0 ) 
               || (trans.dest_address[40]==0 && EN_ALLUCAST == 1'b0 && trans.dest_address != primary_addr && trans.dest_address != supplementary_addr )
	       )
       `elsif ETH_NF_1G
             if ((act_packed_byte_size < drop_frame_size) || (trans.packed_bytes[7] != 8'hd5 )
	       || (wrong_preamble == 1'b1) || ((rx_frame_control[3] == 0) && (trans.frame_type==ETH_PFC_FRAME)) || (rx_frame_control[4]==0 && trans.frame_type==ETH_SFC_FRAME)       || (trans.dest_address[40]==1 && EN_ALLMCAST == 1'b0 ) 
               || (trans.dest_address[40]==0 && EN_ALLUCAST == 1'b0 && trans.dest_address != primary_addr && trans.dest_address != supplementary_addr )
	       )
        `elsif ETH_MGBASET
             if ((act_packed_byte_size < drop_frame_size) || (trans.packed_bytes[7] != 8'hd5 )
	       || (wrong_preamble == 1'b1) || ((rx_frame_control[3] == 0) && (trans.frame_type==ETH_PFC_FRAME)) || (rx_frame_control[4]==0 && trans.frame_type==ETH_SFC_FRAME)       || (trans.dest_address[40]==1 && EN_ALLMCAST == 1'b0 ) 
               || (trans.dest_address[40]==0 && EN_ALLUCAST == 1'b0 && trans.dest_address != primary_addr && trans.dest_address != supplementary_addr )
	       )  
        `else
        if ((act_packed_byte_size < drop_frame_size) || (trans.packed_bytes[0] !=8'hfb) || (trans.packed_bytes[7] != 8'hd5 )
               || (wrong_preamble == 1'b1) || ((rx_frame_control[3] == 0) && (trans.frame_type==ETH_PFC_FRAME)) || (rx_frame_control[4]==0 && trans.frame_type==ETH_SFC_FRAME)
                //Supplimentary check
               || (trans.dest_address[40]==1 && EN_ALLMCAST == 1'b0 ) 
               || (trans.dest_address[40]==0 && EN_ALLUCAST == 1'b0 && trans.dest_address != primary_addr && trans.dest_address != supplementary_addr )
               || (spy_if.o_rx_hi_ber == 1)
               ) 
       `endif
         begin
	      `uvm_info("ETH REF MODEL", $sformatf("%s: Packet received < %0d bytes or wrong preamble = %0d, Frame should be dropped drop_counters %0d",func_name,drop_frame_size,wrong_preamble,drop_count),UVM_MEDIUM)
	      `uvm_info("ETH REF MODEL", $sformatf("%s: Dropped packet dest addr is %0h, act_pkt_size is %0h, trans err+chk_status is %0b",func_name,trans.dest_address,act_packed_byte_size,trans_err_status),UVM_MEDIUM)
	      `uvm_info("ETH REF MODEL", $sformatf("%s: Preamble byte 0 is %0h, 1 is %0h, 2 is %0h, 6 is %0h, 7 is %0h",func_name,trans.packed_bytes[0],trans.packed_bytes[1],trans.packed_bytes[2],trans.packed_bytes[5],trans.packed_bytes[6]),UVM_MEDIUM)
               if( EN_ALLMCAST == 1'b0) `uvm_info("ETH REF MODEL", $sformatf("%s: Dropping MCAST FRAME dest addr is %0h, act_pkt_size is %0h, dest_address[40] bit  %0b",func_name,trans.dest_address,act_packed_byte_size,trans.dest_address[40]),UVM_MEDIUM)
               if( EN_ALLUCAST == 1'b0) `uvm_info("ETH REF MODEL", $sformatf("%s: Dropping UCAST FRAME dest addr is %0h, act_pkt_size is %0h, dest_address[40] bit  %0b",func_name,trans.dest_address,act_packed_byte_size,trans.dest_address[40]),UVM_MEDIUM)
	      drop_count++;
              rx_frame_dropped_cntr = rx_frame_dropped_cntr + 1;
              spy_if.rx_frame_dropped_cntr = rx_frame_dropped_cntr;
              if((rx_frame_control[4] == 0 && trans.frame_type==ETH_PFC_FRAME) || (rx_frame_control[3]==0 && trans.frame_type==ETH_SFC_FRAME)) begin //DM_TODO: Confirm behavior
                 //if((rx_pfc_control[16] == 0 && trans.frame_type==ETH_PFC_FRAME) || (xx_pause_control[4]==0 && trans.frame_type==ETH_SFC_FRAME)) begin //DM_TODO: Confirm behavior
	         `uvm_info("ETH REF MODEL", $sformatf("Dropped SFC/PFC frame, incrementing stats, source addr is %0h",trans.src_address),UVM_MEDIUM)
                `ifdef ENABLE_ETH_VIP
                 stat_checker_rx(trans,crc_error,malformed);
                 `endif
              end
`ifdef COMPL_TC
   `ifdef ETH_MULTI_PORT
         ->signal_map_if.signal_map_if[0].event_rx_frame_rejected; 
   `else
         ->signal_map_if.event_rx_frame_rejected; 
   `endif
`endif
	     return (1'b1);
      end    
     
      //else if ( EN_ALLUCAST == 1'b0  || EN_ALLMCAST == 1'b0 ) begin
      //  if (trans.dest_address[40]==1 && EN_ALLMCAST == 1'b0 )  begin // dropping MCAST frame
      //   `uvm_info("ETH REF MODEL", $sformatf("%s: Dropping MCAST FRAME dest addr is %0h, act_pkt_size is %0h, dest_address[40] bit  %0b",func_name,trans.dest_address,act_packed_byte_size,trans.dest_address[40]),UVM_MEDIUM)
      //         return (1'b1);
      //  end
      //   //Dropping UCAST frames if EN_ALLUCAST  IS NOT SET and dest_address  not matching with primary address or supplementary_addr 
      //  if (trans.dest_address[40]==0 && EN_ALLUCAST == 1'b0 && (trans.dest_address != primary_addr || (trans.dest_address != supplementary_addr && supplementary_addr_sel != 0 )))  begin
      //   `uvm_info("ETH REF MODEL", $sformatf("%s: Dropping UCAST FRAME dest addr is %0h, act_pkt_size is %0h, dest_address[40] bit  %0b",func_name,trans.dest_address,act_packed_byte_size,trans.dest_address[40]),UVM_MEDIUM)
      //         return (1'b1);
      //  end 
      //end
//      `ifdef G50
      `ifdef ENABLE_ETH_VIP
      else if (dyn_rcfg_obj_inst.speed==_50G && dyn_rcfg_obj_inst.mode==PCSMAC) begin
//      else begin
        if(rx_crc_pass[0]==1) drop_frame_size = 9;
        else drop_frame_size = 13;
        
        if ((trans.packed_bytes.size()-8) < drop_frame_size) begin//Frames will be dropped by adapter//FB 590559 : Frames that are less than 13 octets (9 for crc passthrough) will be dropped. 
	        `uvm_info("ETH REF MODEL", $sformatf("%s: Packet received < %0d bytes. Frame should be dropped",func_name,drop_frame_size),UVM_NONE)
	  drop_count++;
          stat_checker_rx(trans,1'b1,1'b0);
	  rxmac_adapt_dropped_cntr = rxmac_adapt_dropped_cntr + 1;
	  return (1'b1);
	end
      end
//      `endif
//       end
      `endif
      
      else // if (enable_rx_drops == 1'b1)
	return (1'b0);
     return(1'b0);
   endfunction; // vip_tx_drop_frame

  function bit check_rx_pause_fwd(eth_packet trans);
   // Forward control Frames
   // 0:Drop valid pause/pfc frames
   // 1:Forward all pause/pfc frames
   if(rx_control_frame_fwd[3] == 1'b0 && rx_control_frame_fwd[4] == 1'b0  ) begin
     if(trans.eth_type_or_length == 16'h8808 && 
       ((trans.payload[0] == 'h0 && trans.payload[1] == 'h1) || (trans.payload[0] == 'h1 && trans.payload[1] == 'h1)) && trans.dest_address == rx_pause_daddr)
	     return(1'b1);
	   else 
	     return(1'b0);
	 end
	 //else begin
	 //  if(trans.eth_type_or_length == 16'h8808 && 
   //    (((trans.payload[0] == 'h0 && trans.payload[1] == 'h1) && en_sfc_pfc[0] == 1'b0) || ((trans.payload[0] == 'h1 && trans.payload[1] == 'h1) && en_sfc_pfc[1] == 1'b0)) &&
   //    trans.dest_address == rx_pause_daddr)
	 //    return (1'b1);
	 //  else 
	 //    return (1'b0);
	 //end
  endfunction

////////////*************************////////////////////

  function clr_adapt_stat_cntr();
    string func_name = "clr_adapt_stat_cntr";
    //DM_TODO: adapt_cntr = reg_model.rxmac_adapt_dropped_control.get();
    //DM_TODO:   rxmac_adapt_dropped_cntr=0;
    //DM_TODO: if(sideband_if.snapshot_en == 0) begin // FIXME Can't use register of shadow request fb:596887
    //DM_TODO:   reg_model.rxmac_adapt_dropped_31_0.predict(.value(rxmac_adapt_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
    //DM_TODO:   reg_model.rxmac_adapt_dropped_63_32.predict(.value(rxmac_adapt_dropped_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
    //DM_TODO:   end
  endfunction:clr_adapt_stat_cntr



  function void check_to_clr_stat_cntr(bit tx_stats_clr, bit rx_stats_clr);
    string func_name = "check_to_clr_stat_cntr";

    `uvm_info("ETH REF MODE", $sformatf("check_to_clr_stat_cntr: tx_stats_clr = %0d, rx_stats_clr = %0d",tx_stats_clr,rx_stats_clr),UVM_NONE);

    if(rx_stats_clr == 1) begin      
        rx_fragment_cntr=0;
        rx_jabber_cntr=0;
        rx_fcs_cntr=0;
        rx_fcserr_okpkt=0;
        rx_mcast_data_err_cntr=0;
        rx_bcast_data_err_cntr=0;
        rx_ucast_data_err_cntr=0;
        rx_mcast_ctrl_err_cntr=0;
        rx_bcast_ctrl_err_cntr=0;
        rx_ucast_ctrl_err_cntr=0;
        rx_pause_err_cntr=0;
        rx_pfc_err_cntr=0;
        rx_64b_cntr=0;
        rx_65bto127b_cntr=0;
        rx_128bto255b_cntr=0;
        rx_256bto511b_cntr=0;
        rx_512bto1023b_cntr=0;
        rx_1024bto1518b_cntr=0;
        rx_1519btomax_cntr=0;
        rx_oversize_cntr=0;
        rx_mcast_data_ok_cntr=0;
        rx_ucast_data_ok_cntr=0;
        rx_bcast_data_ok_cntr=0;
        rx_mcast_ctrl_ok_cntr=0;
        rx_ucast_ctrl_ok_cntr=0;
        rx_bcast_ctrl_ok_cntr=0;
        rx_pause_ok_cntr=0;
        rx_pfc_ok_cntr=0;
        rx_runt_cntr=0;
        rx_payload_ok_cntr=0;
        rx_frame_ok_cntr=0;
        rx_frame_dropped_cntr=0;
        rx_malformed_cntr=0;
        rx_badlt_frame=0;
        rx_lenerr_frame=0;
        rx_st_frame=0;
        rx_stats_framesOK=0;
        rx_stats_framesErr=0;
        rx_stats_ifErrors=0;
       
        gdr_ral_predict(.regname("mac_stats_cntr_rx_fragments_lo"),.value(rx_fragment_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_jabbers_lo"),.value(rx_jabber_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_fcs_lo"),.value(rx_fcs_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_fcs_err_okpkt_lo"),.value(rx_fcserr_okpkt[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_err_lo"),.value(rx_mcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_lo"),.value(rx_mcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_hi"),.value(rx_mcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_err_lo"),.value(rx_bcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_lo"),.value(rx_bcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_hi"),.value(rx_bcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_err_lo"),.value(rx_ucast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_lo"),.value(rx_ucast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_hi"),.value(rx_ucast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_err_lo"),.value(rx_mcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_lo"),.value(rx_mcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_hi"),.value(rx_mcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_err_lo"),.value(rx_bcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_lo"),.value(rx_bcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_hi"),.value(rx_bcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO:gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_err_lo"),.value(rx_ucast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_lo"),.value(rx_ucast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_hi"),.value(rx_ucast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_err_lo"),.value(rx_pause_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_err_lo"),.value(rx_pfc_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_lo"),.value(rx_pause_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_hi"),.value(rx_pause_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_lo"),.value(rx_pfc_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_hi"),.value(rx_pfc_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_lo"),.value(rx_64b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_hi"),.value(rx_64b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_lo"),.value(rx_65bto127b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_hi"),.value(rx_65bto127b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_lo"),.value(rx_128bto255b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_hi"),.value(rx_128bto255b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_lo"),.value(rx_256bto511b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_hi"),.value(rx_256bto511b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_lo"),.value(rx_512bto1023b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_hi"),.value(rx_512bto1023b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_lo"),.value(rx_1024bto1518b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_hi"),.value(rx_1024bto1518b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_lo"),.value(rx_1519btomax_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_hi"),.value(rx_1519btomax_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_oversize_lo"),.value(rx_oversize_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_runt_lo"),.value(rx_runt_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_lo"),.value(rx_payload_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_hi"),.value(rx_payload_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_octetsok_lo"),.value(rx_frame_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_octetsok_hi"),.value(rx_frame_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_dropped_lo"),.value(rx_frame_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_malformed_lo"),.value(rx_malformed_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_badlt_lo"),.value(rx_badlt_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_lenerr_lo"),.value(rx_lenerr_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_st_lo"),.value(rx_st_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_rx_st_hi"),.value(rx_st_frame[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("rx_stats_framesOK0"),.value(rx_stats_framesOK[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("rx_stats_framesOK1"),.value(rx_stats_framesOK[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("rx_stats_framesErr0"),.value(rx_stats_framesErr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("rx_stats_framesErr1"),.value(rx_stats_framesErr[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("rx_stats_ifErrors0"),.value(rx_stats_ifErrors[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("rx_stats_ifErrors1"),.value(rx_stats_ifErrors[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
    end
    
    if(tx_stats_clr == 1) begin        
        tx_fragment_cntr=0;
        tx_jabber_cntr=0;
        tx_fcs_cntr=0;
        tx_fcserr_okpkt=0;
        tx_mcast_data_err_cntr=0;
        tx_bcast_data_err_cntr=0;
        tx_ucast_data_err_cntr=0;
        tx_mcast_ctrl_err_cntr=0;
        tx_bcast_ctrl_err_cntr=0;
        tx_ucast_ctrl_err_cntr=0;
        tx_pause_err_cntr=0;
        tx_pfc_err_cntr=0;
        tx_64b_cntr=0;
        tx_65bto127b_cntr=0;
        tx_128bto255b_cntr=0;
        tx_256bto511b_cntr=0;
        tx_512bto1023b_cntr=0;
        tx_1024bto1518b_cntr=0;
        tx_1519btomax_cntr=0;
        tx_oversize_cntr=0;
        tx_mcast_data_ok_cntr=0;
        tx_ucast_data_ok_cntr=0;
        tx_bcast_data_ok_cntr=0;
        tx_mcast_ctrl_ok_cntr=0;
        tx_ucast_ctrl_ok_cntr=0;
        tx_bcast_ctrl_ok_cntr=0;
        tx_pause_ok_cntr=0;
        tx_pfc_ok_cntr=0;
        tx_runt_cntr=0;
        tx_payload_ok_cntr=0;
        tx_frame_ok_cntr=0;
        tx_frame_dropped_cntr=0;
        tx_malformed_cntr=0;
        tx_badlt_frame=0;
        tx_lenerr_frame=0;
        tx_st_frame=0;
        tx_stats_framesOK=0;
        tx_stats_framesErr=0;
        tx_stats_ifErrors=0;
       
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_fragments_lo"),.value(tx_fragment_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_jabbers_lo"),.value(tx_jabber_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_fcs_lo"),.value(tx_fcs_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_fcs_err_okpkt_lo"),.value(tx_fcserr_okpkt[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_err_lo"),.value(tx_mcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_lo"),.value(tx_mcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_hi"),.value(tx_mcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_err_lo"),.value(tx_bcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_lo"),.value(tx_bcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_hi"),.value(tx_bcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_utcast_data_err_lo"),.value(tx_ucast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_lo"),.value(tx_ucast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_hi"),.value(tx_ucast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_err_lo"),.value(tx_mcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_lo"),.value(tx_mcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_hi"),.value(tx_mcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_err_lo"),.value(tx_bcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_lo"),.value(tx_bcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_hi"),.value(tx_bcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_err_lo"),.value(tx_ucast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_lo"),.value(tx_ucast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_hi"),.value(tx_ucast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_err_lo"),.value(tx_pause_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_err_lo"),.value(tx_pfc_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_lo"),.value(tx_pause_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_hi"),.value(tx_pause_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_lo"),.value(tx_pfc_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_hi"),.value(tx_pfc_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_lo"),.value(tx_64b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_hi"),.value(tx_64b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_lo"),.value(tx_65bto127b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_hi"),.value(tx_65bto127b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_lo"),.value(tx_128bto255b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_hi"),.value(tx_128bto255b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_lo"),.value(tx_256bto511b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_hi"),.value(tx_256bto511b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_lo"),.value(tx_512bto1023b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_hi"),.value(tx_512bto1023b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_lo"),.value(tx_1024bto1518b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_hi"),.value(tx_1024bto1518b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_lo"),.value(tx_1519btomax_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_hi"),.value(tx_1519btomax_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_oversize_lo"),.value(tx_oversize_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_runt_lo"),.value(tx_runt_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_lo"),.value(tx_payload_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_hi"),.value(tx_payload_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_octetsok_lo"),.value(tx_frame_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_octetsok_hi"),.value(tx_frame_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_dropped_lo"),.value(tx_frame_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_malformed_lo"),.value(tx_malformed_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_badlt_lo"),.value(tx_badlt_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_lenerr_lo"),.value(tx_lenerr_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_st_lo"),.value(tx_st_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("mac_stats_cntr_tx_st_hi"),.value(tx_st_frame[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("tx_stats_framesOK0"),.value(tx_stats_framesOK[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("tx_stats_framesOK1"),.value(tx_stats_framesOK[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("tx_stats_framesErr0"),.value(tx_stats_framesErr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("tx_stats_framesErr1"),.value(tx_stats_framesErr[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("tx_stats_ifErrors0"),.value(tx_stats_ifErrors[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
        gdr_ral_predict(.regname("tx_stats_ifErrors1"),.value(tx_stats_ifErrors[61:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
    end

  endfunction:check_to_clr_stat_cntr

  function predict_stats_registers();
       gdr_ral_predict(.regname("mac_stats_cntr_rx_fragments_lo"),.value(rx_fragment_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_jabbers_lo"),.value(rx_jabber_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_fcs_lo"),.value(rx_fcs_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_fcs_err_okpkt_lo"),.value(rx_fcserr_okpkt[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_err_lo"),.value(rx_mcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_lo"),.value(rx_mcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_data_ok_hi"),.value(rx_mcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_err_lo"),.value(rx_bcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_lo"),.value(rx_bcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_data_ok_hi"),.value(rx_bcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_err_lo"),.value(rx_ucast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_lo"),.value(rx_ucast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_data_ok_hi"),.value(rx_ucast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_err_lo"),.value(rx_mcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_lo"),.value(rx_mcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_mcast_ctrl_hi"),.value(rx_mcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_err_lo"),.value(rx_bcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_lo"),.value(rx_bcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_bcast_ctrl_hi"),.value(rx_bcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_err_lo"),.value(rx_ucast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_lo"),.value(rx_ucast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_ucast_ctrl_hi"),.value(rx_ucast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_err_lo"),.value(rx_pause_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_err_lo"),.value(rx_pfc_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_lo"),.value(rx_pause_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_pause_hi"),.value(rx_pause_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_lo"),.value(rx_pfc_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_pfc_hi"),.value(rx_pfc_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_lo"),.value(rx_64b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_64b_hi"),.value(rx_64b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_lo"),.value(rx_65bto127b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_65to127b_hi"),.value(rx_65bto127b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_lo"),.value(rx_128bto255b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_128to255b_hi"),.value(rx_128bto255b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_lo"),.value(rx_256bto511b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_256to511b_hi"),.value(rx_256bto511b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_lo"),.value(rx_512bto1023b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_512to1023b_hi"),.value(rx_512bto1023b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_lo"),.value(rx_1024bto1518b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1024to1518b_hi"),.value(rx_1024bto1518b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_lo"),.value(rx_1519btomax_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_1519tomaxb_hi"),.value(rx_1519btomax_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_oversize_lo"),.value(rx_oversize_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_runt_lo"),.value(rx_runt_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_lo"),.value(rx_payload_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_payloadoctetsok_hi"),.value(rx_payload_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_octetsok_lo"),.value(rx_frame_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_octetsok_hi"),.value(rx_frame_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_dropped_lo"),.value(rx_frame_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_malformed_lo"),.value(rx_malformed_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_badlt_lo"),.value(rx_badlt_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_rx_lenerr_lo"),.value(rx_lenerr_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_st_lo"),.value(rx_st_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_rx_st_hi"),.value(rx_st_frame[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: reg_model.rxmac_adapt_dropped_31_0.predict(.value(rxmac_adapt_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: reg_model.rxmac_adapt_dropped_63_32.predict(.value(rxmac_adapt_dropped_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));

       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_fragments_lo"),.value(tx_fragment_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_jabbers_lo"),.value(tx_jabber_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_fcs_lo"),.value(tx_fcs_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_fcs_err_okpkt_lo"),.value(tx_fcserr_okpkt[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_err_lo"),.value(tx_mcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_lo"),.value(tx_mcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_data_ok_hi"),.value(tx_mcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_err_lo"),.value(tx_bcast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_lo"),.value(tx_bcast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_data_ok_hi"),.value(tx_bcast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_err_lo"),.value(tx_ucast_data_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_lo"),.value(tx_ucast_data_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_data_ok_hi"),.value(tx_ucast_data_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_err_lo"),.value(tx_mcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_lo"),.value(tx_mcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_mcast_ctrl_hi"),.value(tx_mcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_err_lo"),.value(tx_bcast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_lo"),.value(tx_bcast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_bcast_ctrl_hi"),.value(tx_bcast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_err_lo"),.value(tx_ucast_ctrl_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_lo"),.value(tx_ucast_ctrl_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_ucast_ctrl_hi"),.value(tx_ucast_ctrl_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_err_lo"),.value(tx_pause_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_err_lo"),.value(tx_pfc_err_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_lo"),.value(tx_pause_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pause_hi"),.value(tx_pause_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_lo"),.value(tx_pfc_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_pfc_hi"),.value(tx_pfc_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_lo"),.value(tx_64b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_64b_hi"),.value(tx_64b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_lo"),.value(tx_65bto127b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_65to127b_hi"),.value(tx_65bto127b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_lo"),.value(tx_128bto255b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_128to255b_hi"),.value(tx_128bto255b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_lo"),.value(tx_256bto511b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_256to511b_hi"),.value(tx_256bto511b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_lo"),.value(tx_512bto1023b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_512to1023b_hi"),.value(tx_512bto1023b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_lo"),.value(tx_1024bto1518b_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1024to1518b_hi"),.value(tx_1024bto1518b_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_lo"),.value(tx_1519btomax_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_1519tomaxb_hi"),.value(tx_1519btomax_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_oversize_lo"),.value(tx_oversize_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_runt_lo"),.value(tx_runt_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_lo"),.value(tx_payload_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_payloadoctetsok_hi"),.value(tx_payload_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_octetsok_lo"),.value(tx_frame_ok_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_octetsok_hi"),.value(tx_frame_ok_cntr[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_dropped_lo"),.value(tx_frame_dropped_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_malformed_lo"),.value(tx_malformed_cntr[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_badlt_lo"),.value(tx_badlt_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       //DM_TODO: gdr_ral_predict(.regname("mac_stats_cntr_tx_lenerr_lo"),.value(tx_lenerr_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_st_lo"),.value(tx_st_frame[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
       gdr_ral_predict(.regname("mac_stats_cntr_tx_st_hi"),.value(tx_st_frame[63:32]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));


  endfunction : predict_stats_registers

   function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $fclose(file_vip_rx_trans_log_id);
    $fclose(file_vip_tx_trans_log_id);
   endfunction:report_phase

   task run_phase(uvm_phase phase);
      time packet_wait_timeout=5us;
      forever begin
	      if (packet_stall==1) begin
	         if (first_rx_packet==0) begin
	            while(packets_drop_decide_idx>0) begin
                   if (($time-new_packet_time)>=10us) begin
		              `uvm_info("eth_ref_sb", $sformatf("Sent last frame"), UVM_MEDIUM)
		              first_rx_packet=1;
		              packets_drop_decide_idx--;
                      `uvm_info("eth_ref_sb", $sformatf("Sending last eth frame to scoreboard with trans_id=%0d",transaction_id_tx),UVM_MEDIUM)
                      packets_drop_decide[1].transaction_id = transaction_id_tx; 
		              eth_tx_to_dest.write(packets_drop_decide[1]);
                      `ifdef ENABLE_ETH_VIP
                      vip_tx_vector(packets_drop_decide[1],packets_drop_decide[1].rx_error[1],packets_drop_decide[1].rx_error[0]); //Send transaction to vip_tx_vector
                      `endif
		           end
		           #10ns;
	            end	       
	            #10ns;
	         end else begin
	            #10ns;
	         end // else: !if(first_rx_packet==0)
	         if (packets_drop_decide_idx>2 || packets_drop_decide_idx<0)
	            `uvm_fatal("ETH_REF_MODEL", $sformatf("packets_drop_decide_idx out of bounds: %0d",packets_drop_decide_idx));
	      end  else begin
	         #10ns;
	      end
      end //forever end
   endtask // run_phase
   
 function void force_lsb_stat_regs(bit[63:0] val);
     tx_fragment_cntr=val;
     tx_jabber_cntr=val;
     tx_fcs_cntr=val;
     tx_fcserr_okpkt=val;
     tx_mcast_data_err_cntr=val;
     tx_bcast_data_err_cntr=val;
     tx_ucast_data_err_cntr=val;
     tx_mcast_ctrl_err_cntr=val;
     tx_bcast_ctrl_err_cntr=val;
     tx_ucast_ctrl_err_cntr=val;
     tx_pause_err_cntr=val;
     tx_64b_cntr=val;
     tx_65bto127b_cntr=val;
     tx_128bto255b_cntr=val;
     tx_256bto511b_cntr=val;
     tx_512bto1023b_cntr=val;
     tx_1024bto1518b_cntr=val;
     tx_1519btomax_cntr=val;
     tx_oversize_cntr=val;
     tx_mcast_data_ok_cntr=val;
     tx_ucast_data_ok_cntr=val;
     tx_bcast_data_ok_cntr=val;
     tx_mcast_ctrl_ok_cntr=val;
     tx_ucast_ctrl_ok_cntr=val;
     tx_bcast_ctrl_ok_cntr=val;
     tx_pause_ok_cntr=val;
     tx_runt_cntr=val;
     tx_payload_ok_cntr=val;
     tx_frame_ok_cntr=val;
     tx_frame_dropped_cntr=val;
     tx_malformed_cntr=val;
     tx_pfc_ok_cntr=val;
     tx_pfc_err_cntr=val;
     tx_badlt_frame=val;
     tx_lenerr_frame=val;
     tx_st_frame=val;

     rx_fragment_cntr=val;
     rx_jabber_cntr=val;
     rx_fcs_cntr=val;
     rx_fcserr_okpkt=val;
     rx_mcast_data_err_cntr=val;
     rx_bcast_data_err_cntr=val;
     rx_ucast_data_err_cntr=val;
     rx_mcast_ctrl_err_cntr=val;
     rx_bcast_ctrl_err_cntr=val;
     rx_ucast_ctrl_err_cntr=val;
     rx_pause_err_cntr=val;
     rx_64b_cntr=val;
     rx_65bto127b_cntr=val;
     rx_128bto255b_cntr=val;
     rx_256bto511b_cntr=val;
     rx_512bto1023b_cntr=val;
     rx_1024bto1518b_cntr=val;
     rx_1519btomax_cntr=val;
     rx_oversize_cntr=val;
     rx_mcast_data_ok_cntr=val;
     rx_ucast_data_ok_cntr=val;
     rx_bcast_data_ok_cntr=val;
     rx_mcast_ctrl_ok_cntr=val;
     rx_ucast_ctrl_ok_cntr=val;
     rx_bcast_ctrl_ok_cntr=val;
     rx_pause_ok_cntr=val;
     rx_runt_cntr=val;
     rx_payload_ok_cntr=val;
     rx_frame_ok_cntr=val;
     rx_frame_dropped_cntr=val;
     rx_malformed_cntr=val;
     rx_pfc_ok_cntr=val;
     rx_pfc_err_cntr=val;
     rx_badlt_frame=val;
     rx_lenerr_frame=val;
     rx_st_frame=val;
     rxmac_adapt_dropped_cntr=val;
     predict_stats_registers();
   endfunction : force_lsb_stat_regs

function void reset_ral_and_stats_counters();
  reg_model.reset();
  rx_fragment_cntr=0;
  rx_jabber_cntr=0;
  rx_fcs_cntr=0;
  rx_fcserr_okpkt=0;
  rx_mcast_data_err_cntr=0;
  rx_bcast_data_err_cntr=0;
  rx_ucast_data_err_cntr=0;
  rx_mcast_ctrl_err_cntr=0;
  rx_bcast_ctrl_err_cntr=0;
  rx_ucast_ctrl_err_cntr=0;
  rx_pause_err_cntr=0;
  rx_pfc_err_cntr=0;
  rx_64b_cntr=0;
  rx_65bto127b_cntr=0;
  rx_128bto255b_cntr=0;
  rx_256bto511b_cntr=0;
  rx_512bto1023b_cntr=0;
  rx_1024bto1518b_cntr=0;
  rx_1519btomax_cntr=0;
  rx_oversize_cntr=0;
  rx_mcast_data_ok_cntr=0;
  rx_ucast_data_ok_cntr=0;
  rx_bcast_data_ok_cntr=0;
  rx_mcast_ctrl_ok_cntr=0;
  rx_ucast_ctrl_ok_cntr=0;
  rx_bcast_ctrl_ok_cntr=0;
  rx_pause_ok_cntr=0;
  rx_pfc_ok_cntr=0;
  rx_runt_cntr=0;
  rx_payload_ok_cntr=0;
  rx_frame_ok_cntr=0;
  rx_frame_dropped_cntr=0;
  rx_malformed_cntr=0;
  rx_badlt_frame=0;
  rx_lenerr_frame=0;
  rx_st_frame=0;
  tx_fragment_cntr=0;
  tx_jabber_cntr=0;
  tx_fcs_cntr=0;
  tx_fcserr_okpkt=0;
  tx_mcast_data_err_cntr=0;
  tx_bcast_data_err_cntr=0;
  tx_ucast_data_err_cntr=0;
  tx_mcast_ctrl_err_cntr=0;
  tx_bcast_ctrl_err_cntr=0;
  tx_ucast_ctrl_err_cntr=0;
  tx_pause_err_cntr=0;
  tx_pfc_err_cntr=0;
  tx_64b_cntr=0;
  tx_65bto127b_cntr=0;
  tx_128bto255b_cntr=0;
  tx_256bto511b_cntr=0;
  tx_512bto1023b_cntr=0;
  tx_1024bto1518b_cntr=0;
  tx_1519btomax_cntr=0;
  tx_oversize_cntr=0;
  tx_mcast_data_ok_cntr=0;
  tx_ucast_data_ok_cntr=0;
  tx_bcast_data_ok_cntr=0;
  tx_mcast_ctrl_ok_cntr=0;
  tx_ucast_ctrl_ok_cntr=0;
  tx_bcast_ctrl_ok_cntr=0;
  tx_pause_ok_cntr=0;
  tx_pfc_ok_cntr=0;
  tx_runt_cntr=0;
  tx_payload_ok_cntr=0;
  tx_frame_ok_cntr=0;
  tx_frame_dropped_cntr=0;
  tx_malformed_cntr=0;
  tx_badlt_frame=0;
  tx_lenerr_frame=0;
  tx_st_frame=0;
  rxmac_adapt_dropped_cntr=0;
endfunction: reset_ral_and_stats_counters

function check_enforce_max_rx(eth_packet trans,output int frame_size_l,output bit truncated_frame_l);

  int frame_size,max_rx_size_config; 
  bit [31:0] rx_ctrl_reg;

  if(trans.frame_type==ETH_VLAN_FRAME || trans.frame_type==ETH_JUMBO_VLAN_FRAME) begin
    frame_size = trans.payload.size() + 22;   
  end
  else if (trans.frame_type==ETH_STACKED_VLAN_FRAME || trans.frame_type==ETH_JUMBO_STACKED_VLAN_FRAME) begin
    frame_size = trans.payload.size() + 26; 
  end
  else begin
    frame_size = trans.payload.size() + 18;
  end

  max_rx_size_config =  gdr_ral_get("mac_cfg_max_rx_size_config");
  rx_ctrl_reg        = gdr_ral_get("rx_padcrc_control"); 
  rx_ctrl_reg[0] = ~rx_ctrl_reg[0];

  // 0:Ovesized frames are not altered
  // 1:Frames are ended with FCS error if they exceed the programmed rx max frame size
  // Sets the maximum size of a RX frame in octets before it will be counted as an oversize frame
  //DM_TODO: recheck if(frame_size > max_rx_size_config && gdr_ral_get("mac_cfg_rxmac_control","enforce_max_rx")) begin
  if(0) begin
    //trans.rx_error[1] = 1'b1; // As frame is truncated, FCS error is expected.
    truncated_frame_l = 1; // As frame is truncated, Refmodel needs to ignore length error. 

    //Remove the extra bytes from end of the packet
    if(frame_size - max_rx_size_config <= 4)begin
      `uvm_info(get_type_name(), $sformatf("frame_size - max_rx_size_config : %0d, fcs:'h%d",frame_size - max_rx_size_config,trans.fcs), UVM_MEDIUM)
      if(frame_size - max_rx_size_config == 1) trans.fcs[7:0]   = 8'h0;
      else if(frame_size - max_rx_size_config == 2) trans.fcs[15:0]  = 16'h0;
      else if(frame_size - max_rx_size_config == 3) trans.fcs[23:0]  = 24'h0;
      else if(frame_size - max_rx_size_config == 4) trans.fcs[31:0]  = 32'h0;
      //DM_TODO: remove if(gdr_ral_get("mac_cfg_mac_crc_config","forward_rx_crc")) begin
      if(rx_ctrl_reg[0] == 1) begin
        if(frame_size - max_rx_size_config == 1)  begin
          trans.fcs[23:0] = trans.fcs[31:8];
          trans.fcs[31:24] = trans.payload[trans.payload.size()-1];
          trans.payload    = new[trans.payload.size() - 1](trans.payload);
        end
        if(frame_size - max_rx_size_config == 2)  begin
          trans.fcs[15:0] = trans.fcs[31:16];
          trans.fcs[31:24] = trans.payload[trans.payload.size()-2];
          trans.fcs[23:16] = trans.payload[trans.payload.size()-1];
          trans.payload    = new[trans.payload.size() - 2](trans.payload);
        end
        if(frame_size - max_rx_size_config == 3)  begin
          trans.fcs[7:0] = trans.fcs[31:24];
          trans.fcs[31:24] = trans.payload[trans.payload.size()-3];
          trans.fcs[23:16] = trans.payload[trans.payload.size()-2];
          trans.fcs[15:8] = trans.payload[trans.payload.size()-1];
          trans.payload    = new[trans.payload.size() - 3](trans.payload);
        end
        if(frame_size - max_rx_size_config == 4)  begin
          trans.fcs[31:24] = trans.payload[trans.payload.size()-4];
          trans.fcs[23:16] = trans.payload[trans.payload.size()-3];
          trans.fcs[15:8]  = trans.payload[trans.payload.size()-2];
          trans.fcs[7:0]   = trans.payload[trans.payload.size()-1];
          trans.payload    = new[trans.payload.size() - 4](trans.payload);
        end
        `uvm_info(get_type_name(), $sformatf("payload.size():%0d fcs:'h%h",trans.payload.size(),trans.fcs), UVM_MEDIUM)
	frame_size_l = frame_size - (frame_size - max_rx_size_config);
        `uvm_info(get_type_name(), $sformatf("Frame size after truncating frame : %0d",frame_size_l), UVM_MEDIUM)
      end
      `uvm_info(get_type_name(), $sformatf("frame_size - max_rx_size_config : %0d, fcs:'h%h",frame_size - max_rx_size_config,trans.fcs), UVM_MEDIUM)
    end
    else if((frame_size - max_rx_size_config > 4) && (frame_size - max_rx_size_config <= trans.payload.size() + 4)) begin
      `uvm_info(get_type_name(), $sformatf("frame_size - max_rx_size_config : %0d, payload.size() + 4:%0d",frame_size - max_rx_size_config,trans.payload.size() + 4), UVM_MEDIUM)
      trans.payload = new[trans.payload.size() - (frame_size - max_rx_size_config - 4)](trans.payload);
      trans.fcs[31:0]  = 'h0;
      `uvm_info(get_type_name(), $sformatf("frame_size - max_rx_size_config : %0d, payload.size() + 4:%0d",frame_size - max_rx_size_config,trans.payload.size() + 4), UVM_MEDIUM)
      `uvm_info(get_type_name(), $sformatf("fcs:%0d",trans.fcs), UVM_MEDIUM)

      // Copy last four bytes from payload to CRC
      //DM_TODO : remove if(gdr_ral_get("mac_cfg_mac_crc_config","forward_rx_crc")) begin
      if(rx_ctrl_reg[0] == 1) begin
        trans.fcs[31:24] = trans.payload[trans.payload.size()-4];
        trans.fcs[23:16] = trans.payload[trans.payload.size()-3];
        trans.fcs[15:8]  = trans.payload[trans.payload.size()-2];
        trans.fcs[7:0]   = trans.payload[trans.payload.size()-1];
        trans.payload    = new[trans.payload.size() - 4](trans.payload);
      end
      `uvm_info(get_type_name(), $sformatf("payload.size():%0d fcs:'h%h",trans.payload.size(),trans.fcs), UVM_MEDIUM)
	
      frame_size_l = frame_size - (frame_size - max_rx_size_config);
      `uvm_info(get_type_name(), $sformatf("Frame size after truncating frame : %0d",frame_size_l), UVM_MEDIUM)
    end
  end
  else begin
    frame_size_l = trans.packed_bytes.size(); 
    truncated_frame_l = 0;
  end

endfunction : check_enforce_max_rx

function void rx_flow_control(eth_packet trans);
   if (dyn_rcfg_obj_inst.mode==PCSMAC || dyn_rcfg_obj_inst.mode==MACSEG) begin
      if(dis_fc_assertion == 0) begin 
	 `uvm_info(get_name(), $psprintf("vip packet is received at vip tx analysis port: \n ",trans.print),UVM_MEDIUM)
	 trans.print;
	   if(trans.eth_type_or_length==16'h8808 && trans.dest_address == rx_pause_daddr && trans.rx_error == 'h0) begin
              if(trans.frame_type==ETH_SFC_FRAME) begin
		 if(en_rxsfc_pfc[0]==1'b1) begin
		    rx_fc_if.pause=0;
		    if(trans.payload[3]!=0) begin
                       rx_fc_if.pause_quanta[8][15:8]=trans.payload[2];
                       rx_fc_if.pause_quanta[8][7:0]=trans.payload[3];
                       rx_fc_if.xoff[8]+=1;
                       rx_fc_if.xon[8]=0;
		    end 
		    else begin
                       rx_fc_if.xon[8]+=1;
                       rx_fc_if.xoff[8]=0;
		    end   
		 end
              end//sfc
              else begin
	       //if(en_rxsfc_pfc[1]==1'b1) begin
	       if(rx_pfc_en!=8'h0) begin// #HSD 16012123882 
		 rx_fc_if.pause=1;
		 en_bit_vector=trans.payload[3];
		 if(trans.payload[5]!=0) begin //xoff
		    rx_fc_if.pause_quanta[0][15:8]=trans.payload[4];
		    rx_fc_if.pause_quanta[0][7:0]=trans.payload[5];
		    rx_fc_if.pause_quanta[1][15:8]=trans.payload[6];
		    rx_fc_if.pause_quanta[1][7:0]=trans.payload[7];
		    rx_fc_if.pause_quanta[2][15:8]=trans.payload[8];
		    rx_fc_if.pause_quanta[2][7:0]=trans.payload[9];
		    rx_fc_if.pause_quanta[3][15:8]=trans.payload[10];
		    rx_fc_if.pause_quanta[3][7:0]=trans.payload[11];
		    rx_fc_if.pause_quanta[4][15:8]=trans.payload[12];
		    rx_fc_if.pause_quanta[4][7:0]=trans.payload[13];
		    rx_fc_if.pause_quanta[5][15:8]=trans.payload[14];
		    rx_fc_if.pause_quanta[5][7:0]=trans.payload[15];
		    rx_fc_if.pause_quanta[6][15:8]=trans.payload[16];
		    rx_fc_if.pause_quanta[6][7:0]=trans.payload[17];
		    rx_fc_if.pause_quanta[7][15:8]=trans.payload[18];
		    rx_fc_if.pause_quanta[7][7:0]=trans.payload[19];
		    if(trans.payload[3][0] && rx_pfc_en[0])//enable bit vector
                      begin
			 rx_fc_if.xoff[0]+=1;
			 rx_fc_if.xon[0]=0;
		      end 
		    if(trans.payload[3][1] && rx_pfc_en[1])//enable bit vector
                      begin
			 rx_fc_if.xoff[1]+=1;
			 rx_fc_if.xon[1]=0;
		      end 
		    if(trans.payload[3][2] && rx_pfc_en[2])//enable bit vector
                      begin
			 rx_fc_if.xoff[2]+=1;
			 rx_fc_if.xon[2]=0;
		      end 
		    if(trans.payload[3][3] && rx_pfc_en[3])//enable bit vector
                      begin
			 rx_fc_if.xoff[3]+=1;
			 rx_fc_if.xon[3]=0;
		      end 
		    if(trans.payload[3][4] && rx_pfc_en[4])//enable bit vector
                      begin
			 rx_fc_if.xoff[4]+=1;
			 rx_fc_if.xon[4]=0;
		      end 
		    if(trans.payload[3][5] && rx_pfc_en[5])//enable bit vector
                      begin
			 rx_fc_if.xoff[5]+=1;
			 rx_fc_if.xon[5]=0;
		      end 
		    if(trans.payload[3][6] && rx_pfc_en[6])//enable bit vector
                      begin
			 rx_fc_if.xoff[6]+=1;
			 rx_fc_if.xon[6]=0;
		      end 
		    if(trans.payload[3][7] && rx_pfc_en[7])//enable bit vector
                      begin
			 rx_fc_if.xoff[7]+=1;
			 rx_fc_if.xon[7]=0;
		      end 
		 end//xoff
		 else begin
		    if(trans.payload[3][0] && rx_pfc_en[0])//enable bit vector
                      begin
			 rx_fc_if.xon[0]+=1;
			 rx_fc_if.xoff[0]=0;
		      end 
		    if(trans.payload[3][1] && rx_pfc_en[1])//enable bit vector
                      begin
			 rx_fc_if.xon[1]+=1;
			 rx_fc_if.xoff[1]=0;
		      end 
		    if(trans.payload[3][2] && rx_pfc_en[2])//enable bit vector
                      begin
			 rx_fc_if.xon[2]+=1;
			 rx_fc_if.xoff[2]=0;
		      end 
		    if(trans.payload[3][3] && rx_pfc_en[3])//enable bit vector
                      begin
			 rx_fc_if.xon[3]+=1;
			 rx_fc_if.xoff[3]=0;
		      end 
		    if(trans.payload[3][4] && rx_pfc_en[4])//enable bit vector
                      begin
			 rx_fc_if.xon[4]+=1;
			 rx_fc_if.xoff[4]=0;
		      end 
		    if(trans.payload[3][5] && rx_pfc_en[5])//enable bit vector
                      begin
			 rx_fc_if.xon[5]+=1;
			 rx_fc_if.xoff[5]=0;
		      end 
		    if(trans.payload[3][6] && rx_pfc_en[6])//enable bit vector
		      begin
			 rx_fc_if.xon[6]+=1;
			 rx_fc_if.xoff[6]=0;
		      end 
		    if(trans.payload[3][7] && rx_pfc_en[7])//enable bit vector
                      begin
			 rx_fc_if.xon[7]+=1;
			 rx_fc_if.xoff[7]=0;
                      end 
		 end//xon
		 foreach(rx_fc_if.xoff[i])
		   $display("xoff[%d]=%d",i,rx_fc_if.xoff[i]);
		 foreach(rx_fc_if.xon[i])
		   $display("xon[%d]=%d",i,rx_fc_if.xon[i]);
		end//en_rxsfc_pfc
              end//pfc
	   end//Control
      end//dis_fc_assertion
   end // if (dyn_rcfg_obj_inst.mode==PCSMAC)
   
endfunction

endclass: eth_ref_model


 `endif // RESET_DRV__SV

