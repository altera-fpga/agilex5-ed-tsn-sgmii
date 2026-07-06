
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


`ifndef ETH_ENV_ENV__SV
`define ETH_ENV_ENV__SV

import altuvm_avalon_st_test_pkg::*;
import vector_uvc_pkg::*;
import reset_uvc_pkg::*;
import altuvm_avalon_mm_pkg::*;


class eth_env_env extends uvm_env;
   
   uvm_reg_data_t phy_offset;
   int            inst_id = 0;

   bit rand_crc_cover_preamble;
   static int inst_no=0;
   int current_val;
   uvm_reg_data_t read_data;
   uvm_reg 	regs_pcs[$],regs[$]; 
   bit dis_ehip_drop_frame_cntr=0;
   int ts_tasks_if_id; /* Get and set testsuite_task_if intf_id*/
   int num_words; 
   string ptp_tx_rtb_path;
   int cover_disable_for_macseg;
   bit sip =1'b1;
   int sip_start_addr = 'h100;
   int sip_end_addr   = 'h0FFC;
   int inst_num;
   integer lane_order[20] = '{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
   bit enable_an;
   bit loopback_enable=0;

   eth_scoreboard sb_loopbk,sb_vip_tx_mac_rx,sb_mac_tx_vip_rx;
   //Vector scoreboard instances
   vector_uvc_scoreboard sb_vec_vip_tx_mac_rx,sb_vec_mac_tx_vip_rx;

   eth_tx_layering_agt master_agent;
   ehip_mii_tx_agent mii_tx_agent;
   eth_fc_agt flow_agent;

   altuvm_avalon_mm_agent       avmm_agt;
   altuvm_avalon_mm_config      avmm_agt_cfg;
   
   altuvm_avalon_mm_agent       avmm_agt_mac;
   altuvm_avalon_mm_config      avmm_agt_cfg_mac;

   altuvm_avalon_mm_agent       avmm_agt_rcfg;
   altuvm_avalon_mm_config      avmm_agt_cfg_rcfg;

   //This is register coverage instance
   register_coverage reg_cov;
   // AVST agnets
   avst_agent          tx_avst_agt,rx_avst_agt;
   // AVST Config Objects
   avst_config         tx_avst_agt_cfg, rx_avst_agt_cfg;

   //seg BFM agents & interfaces
   client_tx_agent seg_tx_agent;
   client_rx_agent seg_rx_agent;  
   eth_macseg_tx_layering_mon mast_mon_macseg_tx;
   eth_macseg_rx_layering_mon mast_mon_macseg_rx;
    
   

   //Rx-mac-packet adapter
   eth_avst_rx_pkt_adapter      rx_avst_pkt_adapter;

   reset_agent reset_uvc_inst;

   // Object :reset_uvc_inst 
   // This is virtual sequnecer instance 
   eth_virtual_sequencer virtual_sequencer_inst;
   eth_ipg_checker ipg_checker;

   svt_ethernet_agent m_snps_eth_pcs66_agent;
   svt_ethernet_agent  m_snps_flexe_otn_agent;

   // Object :reset_uvc_inst 
   svt_ethernet_agent_configuration mac_cfg;
   svt_ethernet_agent_configuration mac_cfg_otn_flexe;

   ethernet_mac_sb_callbacks mac_callback;
   //ethernet_mac_callbacks mac_test_callback;
   ethernet_usr_config_66b_scrambled_block_callbacks mac_usr_66_callback;
   ethernet_mac_baser_66b_err_inject_callback mac_66_err_callback;
   ethernet_mac_basex_err_inject_callback mac_err_callback; 
   ethernet_mac_rs_fec_err_encoder_callbacks  mac_rs_fec_err_encoder_callback;
   ethernet_xxvsbi_lsbi_bip_corruption_callback xxvsbi_lsbi_bip_corruption_callback;
   ethernet_rs_fec_bip_corruption_callbacks rs_fec_bip_corruption_callbacks ;
   ethernet_400g_bip_corruption_callback g400_bip_corruption_callback;
   ethernet_user_inject_callbacks g100_ck_corruption_callbacks;
   ethernet_txrx_bip_corruption_callback txrx_bip_corruption_callback;

   //---------------------------------------------------------------------------
   //  Wrapper interface to access TB tasks from sequence
   //---------------------------------------------------------------------------
   virtual eth_testsuite_tasks_intf ts_tasks_if;
   virtual svt_ethernet_txrx_if svt_ethernet_txrx_inst,svt_ethernet_pcs_mode_txrx_inst;
   virtual svt_ethernet_txrx_if svt_ethernet_pcs_mode_txrx_inst;

   ptp_tx_agent m_ptp_tx_agent;
   ptp_tx_ref_model m_ptp_tx_ref_model;
   ptp_config m_ptp_config;

   virtual reset_if reset_if; 
   virtual spy_interface spy_if;
   typedef virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) status_if;
   virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) mon_if_status;
   typedef virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) status_mac_if;
   virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) mon_if_mac_status;
   typedef virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) status_rcfg_if;
   virtual altera_avalon_mm_if#(`AVMM_CFG_SHARED_INF_INST) mon_if_rcfg_status;

   virtual ehip_mii_tx_if mii_tx_uif,mii_rx_uif;
   virtual eth_fc_interface fc_if;
   virtual eth_sideband_interface sideband_if;
   virtual eth_pcs66_interface eth_pcs66_if;
   int 	   tod_sec_part;
   real tod_ns_fns_part;
   int tod_ns_part;
   real tod_fns_part;

   // Object :eth_ref_model_inst 
   // This is referance model instance 
   eth_ref_model  eth_ref_model_inst;
   eth_ref_model  eth_ref_model_inst_pcs66;

   string avmm_rtb_path;
   string avmm_mac_rtb_path;
   string avmm_rcfg_rtb_path;
   string seg_tx_rtb_path;
   string seg_rx_rtb_path;
   string avst_tx_rtb_path;
   string avst_rx_rtb_path;
   string  env_name;
   string  dut_name;
   

   // Object :reg_model 
   // This is register model instance 
   registers_urm reg_model;
   
   // Object :reg_adpt 
   // This is register adapeter class instance for avmm protocol
   altuvm_avalon_mm_reg_adapter reg_adpt;
   altuvm_avalon_mm_reg_adapter reg_mac_adpt;
   altuvm_avalon_mm_reg_adapter reg_rcfg_adpt;
   

   // Object :reg_predictor
   altuvm_avalon_mm_reg_predictor reg_predictor;
   altuvm_avalon_mm_reg_predictor reg_mac_predictor;
   altuvm_avalon_mm_reg_predictor reg_rcfg_predictor;
   
   //Object: rx_vector_mon
   //This is vector Mon instance for rx
   vector_uvc_agent vector_agent;
   
   eth_env_cov cov;
   eth_rx_mac_cov rx_mac_cov; // Need to update for eth_param_tb
   parameter_sweep_cov ps_cov ; 
   eth_tx_layering_mon_2cov_connect mon2cov;

   //Ported from DM VMM environment
   altera_coverage_swip_eth_mac_frame_mgbaset_c eth_mac_frame_tx;
   altera_coverage_swip_eth_mac_frame_mgbaset_c eth_mac_frame_rx;
   altera_coverage_swip_eth_xgmii_ddr_c eth_xgmii_ddr_tx ;
   altera_coverage_swip_eth_xgmii_ddr_c eth_xgmii_ddr_rx;    

   // Dynamic Config Obj
   dyn_rcfg dyn_rcfg_obj_inst;

   uvm_cmdline_processor inst;
   string m_sequence;
   
    `uvm_component_utils(eth_env_env)

   extern function new(string name="eth_env_env", uvm_component parent=null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual function void connect_phase(uvm_phase phase);
   extern function void start_of_simulation_phase(uvm_phase phase);
   extern virtual task reset_phase(uvm_phase phase);
   extern virtual task configure_phase(uvm_phase phase);
   extern virtual task run_phase(uvm_phase phase);
   extern virtual function void report_phase(uvm_phase phase);
   extern virtual task shutdown_phase(uvm_phase phase);
   extern virtual function void update_ral_reset_value();
   extern virtual function int set_masked_val(uvm_reg_data_t addr, input bit[1:0] en_mask_fld =2 );
   extern virtual task reg_read(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf, bit[31:0]data_expected=0);
   extern virtual task reg_read_in_between(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf, bit[31:0]data_expected=0);
   extern virtual task reg_write(uvm_reg_data_t addr,uvm_reg_data_t data,uvm_reg_byte_en_t byte_enable='hf);
   extern virtual task read_and_compare_stats(input bit disable_check=0);
   extern virtual function void enable_snps_errors(string ERR_TYPE = "ALL");
   extern virtual function void disable_snps_errors(string ERR_TYPE = "ALL");
   extern virtual function void disable_all_snps_errors();
   extern virtual function void enable_all_snps_errors();
   extern virtual task wait_vip_tx_frames_done(int exp_num, time timeout_time=200us);
   extern virtual task wait_client_rx_frames_done(int exp_num, time timeout_time=200us, bit include_fc_pkt = 0 );
   extern virtual function int corrupt_eop ();
   extern virtual task configure_vip_ber();
   extern virtual task configure_vip_packets();

   extern virtual task wait_mac_tx_frames_done(int exp_num, time timeout_time=200us);
   extern virtual task wait_tx_frames_received(int exp_num, time timeout_time=200us, bit include_fc_pkt=0);
   extern virtual task apply_reconfig_reset();
   extern virtual task apply_reset(string rst_type="hard",bit tx_rst=0,bit rx_rst=0, bit ip_rst=1,int reset_period=11, int tx_dly=0, int rx_dly=0, int ip_dly=0, bit hold_reset=0);
   extern virtual task apply_vip_reset();
   extern virtual task wait_for_linkup(bit tx_sync=0,bit rx_sync=0,bit ip_sync=1, bit disable_vip_err=0); 
   extern virtual function void dynamic_enable_disable_scoreboards(bit enb_bit);
   extern virtual function void configure_vector_scoreboard();
   extern function void gdr_ral_set(string regname, string fldname, int fld_val);
   extern virtual function void read_data_chk(bit[31:0] act,bit[31:0] exp);
   extern virtual task write_stat_regs();
   extern virtual task reset_vip();
   extern virtual task read_status_registers();
   extern virtual task wait_avst_tx_frames_done(int exp_num, time timeout_time=200us);
   extern function void gdr_ral_reset(string regname, string fldname="");
   extern virtual task read_sip_status();
   extern virtual function int gdr_ral_offset(string regname);
   extern virtual function int gdr_ral_get(string regname, string fldname="");
   extern virtual function void gdr_ral_predict(string regname, 
                                           string fldname="",
                                           uvm_reg_data_t value, 
                                           uvm_predict_e kind, 
                                           uvm_reg_map map);
   extern virtual function void gdr_ral_set_reset(string regname, string fldname, int fld_val);
   extern virtual task apply_skew();
   extern virtual task apply_lane_reorder();
   extern virtual task gdr_ral_write(string regname,uvm_status_e status,uvm_reg_data_t value, uvm_reg_map map);
   extern virtual task gdr_ral_read(string regname,uvm_status_e status,ref uvm_reg_data_t value, uvm_reg_map map);
   extern virtual function void build_phy_cfg_agt();
   extern virtual function void build_mac_cfg_agt();
   extern virtual function void build_rcfg_agt();
   extern virtual function void build_fc_agt();
   extern virtual function void get_spy_if();
   extern virtual function void build_rst_agt();
   extern virtual function void get_sideband_if();
   extern virtual function void build_seg_agt();
   extern virtual function void build_tx_avst_agt();
   extern virtual function void build_rx_avst_agt();
   extern virtual function void build_ptp_tx_agt();
   extern virtual function void build_mii_tx_agt();
   extern virtual function void build_flexe_otn_agt();
   extern virtual function void build_coverage();
   extern virtual function void build_scoreboard();
   extern virtual function void build_pcs_agt();
   extern virtual function void build_callbacks();
   extern virtual function void add_callbacks();
   extern virtual task reg_read_axi(input uvm_reg_data_t addr,
                               input uvm_reg_data_t base_addr,
                               ref uvm_reg_data_t read_data,
                               input int num_shift = 2);
   extern virtual task reg_write_axi(input uvm_reg_data_t addr,
                               input uvm_reg_data_t base_addr,
                               input uvm_reg_data_t w_data,
                               input uvm_reg_byte_en_t byte_enable='hf,
                               input int num_shift = 2);

endclass: eth_env_env

//************************************************************************************

function int eth_env_env::gdr_ral_offset(string regname);
    uvm_reg reg_l;
    uvm_reg regs[$];
     
    $display("Register name %0s",regname);
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        $display("Register Name :: Reg name %0s -- URM name %0s",regname,regs[i].get_name());
        reg_l = regs[i]; 
        return reg_l.get_offset();
      end
    end
    `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s ",regname));
endfunction

//************************************************************************************

function int eth_env_env::gdr_ral_get(string regname, string fldname="");
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
     
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
    `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

//************************************************************************************

function void eth_env_env::gdr_ral_predict(string regname, 
                                           string fldname="",
                                           uvm_reg_data_t value, 
                                           uvm_predict_e kind, 
                                           uvm_reg_map map);
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
     
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        if(fldname == "") begin 
          reg_l.predict(.value(value), .kind(kind), .map(map));
          return;
        end
        else begin
          fld_l  = reg_l.get_field_by_name(fldname);
          fld_l.predict(.value(value), .kind(kind), .map(map));
          return ;
        end
      end
    end
    `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

//************************************************************************************

function void eth_env_env::gdr_ral_set_reset(string regname, string fldname, int fld_val);
    uvm_reg_field fld_l;
    uvm_reg reg_l;
    uvm_reg regs[$];
    bit err_flag=1'b1;
    if (sip ==0) begin
        case (dyn_rcfg_obj_inst.speed)
        _10G : regname = {"e25_",regname};
        _25G : regname = {"e25_",regname};
        _50G : regname = {"e50_",regname};
        _40G : regname = {"e100_",regname};
        _100G : regname = {"e100_",regname};
        _200G : regname = {"e200_",regname};
        _400G : regname = {"e400_",regname};
        endcase 
    end
    reg_model.default_map.get_registers(regs);
    foreach(regs[i]) begin
//	    $display("Inside gdr_ral_set_reset :%0s",regs[i].get_name());
      if (regname == regs[i].get_name()) begin
        reg_l = regs[i]; 
        fld_l  = reg_l.get_field_by_name(fldname);
        fld_l.set_reset(fld_val);
        // set_reset is not updating actual field value, so had to add below set operation
        // Or remove below set operation and call the update ral rest values after reset
        fld_l.set(fld_val);
	    $display(" Field %0s reset set to %0h",fldname, fld_val);
	err_flag=0;
      end
    end
    if(err_flag==1'b1) `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

//************************************************************************************

task eth_env_env::apply_skew();
  
#10ns; //give some time to detect posedge
`uvm_info("skew_task", "waiting for posedge of csr ...", UVM_NONE)

@(posedge reset_if.csr_rst_n);
#100ns;

`uvm_info("skew_task", "started to apply skew ...", UVM_NONE)

ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE0,2);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE1,4);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE2,4);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE3,3);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE4,6);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE5,3);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE6,2);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE7,6);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE8,8);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE9,4);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE10,6);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE11,7);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE12,6);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE13,2);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE14,3);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE15,7);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE16,8);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE17,4);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE18,3);
ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_SKEW_ON_LANE19,1);
endtask

//************************************************************************************

task eth_env_env::apply_lane_reorder();

   lane_order.shuffle();
   #10ns; //give some time to detect posedge
   `uvm_info("lane reorder_task", "waiting for posedge of csr ...", UVM_NONE)
   @(posedge reset_if.csr_rst_n);
   #100ns;
   `uvm_info("lane reorder_task", "started to apply lane reordering ...", UVM_NONE)

   foreach(lane_order[i])
      `uvm_info("RAND_SKEW", $sformatf("vl_reversal_lane[%0d] = %0d",i,lane_order[i]),UVM_NONE)

    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE0, lane_order[0]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE1, lane_order[1]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE2, lane_order[2]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE3, lane_order[3]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE4, lane_order[4]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE5, lane_order[5]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE6, lane_order[6]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE7, lane_order[7]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE8, lane_order[8]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE9, lane_order[9]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE10, lane_order[10]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE11, lane_order[11]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE12, lane_order[12]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE13, lane_order[13]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE14, lane_order[14]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE15, lane_order[15]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE16, lane_order[16]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE17, lane_order[17]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE18, lane_order[18]);
    ts_tasks_if.do_drv_cfg(`ETH_10G_MULTILANE_REVERSAL_LANE19, lane_order[19]);

endtask

//************************************************************************************

task eth_env_env::gdr_ral_write(string regname,uvm_status_e status,uvm_reg_data_t value, uvm_reg_map map);
   uvm_reg reg_l;
   uvm_reg regs[$];
   bit err_flag=1'b1;
     
   reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
         reg_l = regs[i]; 
	      reg_l.write(status,.value(value),.map(map));
	      err_flag=0;
      end
   end
   if(err_flag==1'b1) `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s ",regname));
endtask

//************************************************************************************

task eth_env_env::gdr_ral_read(string regname,uvm_status_e status,ref uvm_reg_data_t value, uvm_reg_map map);
   uvm_reg reg_l;
   uvm_reg regs[$];
   bit err_flag=1'b1;
     
   reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
      if (regname == regs[i].get_name()) begin
         reg_l = regs[i]; 
	      reg_l.read(status,.value(value),.map(map));
	      err_flag=0;
      end
   end
   if(err_flag==1'b1) `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s ",regname));
endtask

//************************************************************************************

function void eth_env_env::gdr_ral_set(string regname, string fldname, int fld_val);
   uvm_reg_field fld_l;
   uvm_reg reg_l;
   uvm_reg regs[$];
   bit err_flag=1'b1;
     
   reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
     if (regname == regs[i].get_name()) begin
         reg_l = regs[i]; 
         fld_l  = reg_l.get_field_by_name(fldname);
         fld_l.set(fld_val);
	      err_flag=0;
     end
   end
   if(err_flag==1'b1) `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

//************************************************************************************

function void eth_env_env::read_data_chk(bit[31:0] act,bit[31:0] exp);
   if(act != exp) begin
      `uvm_error("read_data_chk", $sformatf("comparision failed actual value:'h%h expected value:'h%0h",act,exp));
   end
   else begin
      `uvm_info("read_data_chk",$sformatf("comprision passed , actual value:'h%h expected value:'h%0h",act,exp), UVM_MEDIUM)
   end
endfunction

//************************************************************************************ 
 //Task: write_stat_regs
 //This task will write to all stats counter registers with random data
 task eth_env_env::write_stat_regs();
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());

   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   //DM_TODO: reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());
   reg_write(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),$urandom());

 endtask : write_stat_regs

//************************************************************************************

task eth_env_env::reset_vip();
   svt_ethernet_txrx_inst.reset = 0;
   if(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
      svt_ethernet_pcs_mode_txrx_inst.reset = 0;
   #10;
   svt_ethernet_txrx_inst.reset = 1;
   if(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
      svt_ethernet_pcs_mode_txrx_inst.reset = 1;
   #10;
   svt_ethernet_txrx_inst.reset = 0;
   if(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})
      svt_ethernet_pcs_mode_txrx_inst.reset = 0;
endtask // reset_vip

//************************************************************************************

 task eth_env_env::read_status_registers();
   uvm_reg 	regs[$];
   uvm_reg_data_t read_data;
 //  reg_read(`GET_REG_ADDR(ehip_stats_phy_frame_error_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data);
 //  reg_read(`GET_REG_ADDR(ehip_stats_phy_rxpcs_status_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data);
 //  reg_read(`GET_REG_ADDR(ehip_stats_am_lock_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data);
 //  reg_read(`ETH_F_ALL_clk_rx_khz_OFFSET_REG,read_data);
 //  reg_read(`ETH_F_ALL_clk_tx_khz_OFFSET_REG,read_data);
 //  reg_read(`ETH_F_ALL_clk_tx_khz_RS_OFFSET_REG,read_data);
 //  reg_read(`ETH_F_ALL_clk_rx_khz_RS_OFFSET_REG,read_data);
 endtask

//************************************************************************************

task eth_env_env::wait_avst_tx_frames_done(int exp_num, time timeout_time=200us);
   string func_name = "wait_avst_tx_frames_done";
   bit    condition_met;
   int  act_pkt_cnt;
      
   `uvm_info(get_type_name(), $sformatf("%s: Waiting for %0d transmitted by AVST",func_name,exp_num), UVM_NONE);
   condition_met = 1'b0;
   fork
      begin 
         while (condition_met!=1'b1) begin
	         if(master_agent.mast_mon.transaction_id<exp_num) begin
	 	         #10ns;
	         end
	         else begin 
	            condition_met=1'b1;
	            `uvm_info(get_type_name(), $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
	         end
	      end
	   end
	
      begin 
	      #(timeout_time); 
	      `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for %0d transmitted by AVST. Waited %0t.",func_name,exp_num,timeout_time));
	   end
   join_any
   disable fork;
endtask // wait_avst_tx_frames_done

//************************************************************************************

function int eth_env_env::set_masked_val(uvm_reg_data_t addr, input bit[1:0] en_mask_fld = 2);
   uvm_reg 	select_reg;
   uvm_reg_field flds[$];
   int lsb,masked_val;
   bit arr[string];
    
   // en_mask_fid is used for choosing the fields to be masked where 0=WO mask; 1=RO mask; 2=Both WO & RO register mask
   case(en_mask_fld)
      0: begin arr["WO"]=1; arr["RO"]=0; end
      1: begin arr["RO"]=1; arr["WO"]=0; end
      2: begin arr["WO"]=1; arr["RO"]=1; end
   endcase
   
   select_reg = reg_model.default_map.get_reg_by_offset(addr);
   masked_val='hFFFF_FFFF;
   if (select_reg != null) begin
      // masking WO fields
      flds={};
      select_reg.get_fields(flds);
      foreach (flds[i]) begin
         if(arr[flds[i].get_access()]==1) begin
	         lsb  = flds[i].get_lsb_pos();
            masked_val &= ~(((1 << flds[i].get_n_bits()) - 1) << lsb);
	         $display("masked value =%0b",masked_val);
         end
     end
     return masked_val;
   end
endfunction

//************************************************************************************

function eth_env_env::new(string name= "eth_env_env",uvm_component parent=null);
   super.new(name,parent);
   if ($value$plusargs("tod_sec_part=%d",tod_sec_part)) begin
      `uvm_info("ptp tod driver",$psprintf("TOD provided from user tod_sec_part=%0d",tod_sec_part),UVM_LOW);
   end
   if ($value$plusargs("tod_ns_fns_part=%f",tod_ns_fns_part)) begin
      `uvm_info("ptp tod driver",$psprintf("TOD provided from user tod_ns_fns_part=%0f",tod_ns_fns_part),UVM_LOW);
   end
   inst = uvm_cmdline_processor::get_inst();
   inst.get_arg_value("+m_sequence=",m_sequence);
   `uvm_info("eth_env_env", $psprintf("sequnce set from commnad line is %0s",m_sequence),UVM_NONE);
   if(m_sequence == "bandwidth_sequence" || m_sequence == "sanity_loopback_sequence") begin
      loopback_enable = 1;
      `uvm_info("loopback",$psprintf("value of loopback enable is =%0d",loopback_enable),UVM_NONE);
   end
   inst_no=inst_no+1;
   this.current_val = inst_no; 
endfunction:new

//************************************************************************************

function void eth_env_env::build_phy_cfg_agt();
   int cmd_timeout;
   int waitrequest_timeout;

   if(!uvm_config_db#(string)::get(this,"","avmm_rtb_path", avmm_rtb_path)) begin
      `uvm_fatal("avmm_rtb_path", "failed to get avmm_rtb_path");
   end
   `uvm_info(get_type_name(),$sformatf("AVMM Path: %s",avmm_rtb_path), UVM_LOW);
   avmm_agt_cfg = altuvm_avalon_mm_config::type_id::create("avmm_agt_cfg");
   avmm_agt_cfg.m_msg_id = "AVMM_CFG";
   
   //HSD:16010937814 : Taking the cmd_timeout & wait_timeout from itf script.
   if (!($value$plusargs("cmd_timeout=%d",cmd_timeout) && 
      $value$plusargs("waitrequest_timeout=%d",waitrequest_timeout))) begin
      cmd_timeout=3000;
      waitrequest_timeout=2000;
   end
   
   `uvm_info("AVMM_CFG",$psprintf("AVMM cfg cmd_timeout=%0d & waitrequest_timeout=%0d",
      cmd_timeout,waitrequest_timeout),UVM_LOW);
    avmm_agt_cfg.set_command_timeout(cmd_timeout);
    avmm_agt_cfg.set_waitrequest_timeout(waitrequest_timeout);
  

   `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", avmm_agt_cfg, "avmm_agt")
   avmm_agt = altuvm_avalon_mm_agent::type_id::create("avmm_agt", this);
   avmm_agt.set_rtb_path({"top_tb.hps_rtb_i.",avmm_rtb_path});

   if(!uvm_config_db#(status_if)::get(this, "", "status_if", mon_if_status)) begin
       `uvm_fatal("ETH_ENV","AVMM interfae not found"); 
   end

endfunction

//************************************************************************************

function void eth_env_env::build_mac_cfg_agt();
   int cmd_timeout;
   int waitrequest_timeout;

   if(!uvm_config_db#(string)::get(this,"","avmm_mac_rtb_path", avmm_mac_rtb_path)) begin
      `uvm_fatal("avmm_mac_rtb_path", "failed to get avmm_mac_rtb_path");
   end
   `uvm_info(get_type_name(),$sformatf("AVMM Path: %s",avmm_mac_rtb_path), UVM_LOW);
   avmm_agt_cfg_mac     = altuvm_avalon_mm_config::type_id::create("avmm_agt_cfg_mac");
   avmm_agt_cfg_mac.m_msg_id = "AVMM_CFG";
   cmd_timeout=3000;
   waitrequest_timeout=2000;
      
   `uvm_info("AVMM_CFG",$psprintf("AVMM cfg cmd_timeout=%0d & waitrequest_timeout=%0d",cmd_timeout,waitrequest_timeout),UVM_LOW);
   avmm_agt_cfg_mac.set_command_timeout(cmd_timeout);
   avmm_agt_cfg_mac.set_waitrequest_timeout(waitrequest_timeout);

   `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", avmm_agt_cfg_mac, "avmm_agt_mac")
   avmm_agt_mac  = altuvm_avalon_mm_agent::type_id::create("avmm_agt_mac", this);
   avmm_agt_mac.set_rtb_path({"top_tb.hps_rtb_i.",avmm_mac_rtb_path});

   if(!uvm_config_db#(status_mac_if)::get(this, "", "status_mac_if", mon_if_mac_status)) begin
       `uvm_fatal("ETH_ENV","AVMM MAC interfae not found"); 
   end
endfunction

//************************************************************************************

function void eth_env_env::build_rcfg_agt();
   int cmd_timeout;
   int waitrequest_timeout;

   if(!uvm_config_db#(string)::get(this,"","avmm_rcfg_rtb_path", avmm_rcfg_rtb_path)) begin
      `uvm_fatal("avmm_rcfg_rtb_path", "failed to get avmm_rcfg_rtb_path");
   end

   `uvm_info(get_type_name(),$sformatf("AVMM Path: %s",avmm_rcfg_rtb_path), UVM_LOW);
   avmm_agt_cfg_rcfg     = altuvm_avalon_mm_config::type_id::create("avmm_agt_cfg_rcfg");
   avmm_agt_cfg_rcfg.m_msg_id = "AVMM_CFG";
   cmd_timeout=3000;
   waitrequest_timeout=2000;
      
   `uvm_info("AVMM_CFG",$psprintf("AVMM cfg cmd_timeout=%0d & waitrequest_timeout=%0d",cmd_timeout,waitrequest_timeout),UVM_LOW);
   avmm_agt_cfg_rcfg.set_command_timeout(cmd_timeout);
   avmm_agt_cfg_rcfg.set_waitrequest_timeout(waitrequest_timeout);

   `altuvm_set_config_db(altuvm_avalon_mm_config, "m_config", avmm_agt_cfg_rcfg, "avmm_agt_rcfg")
   avmm_agt_rcfg  = altuvm_avalon_mm_agent::type_id::create("avmm_agt_rcfg", this);
   avmm_agt_rcfg.set_rtb_path({"top_tb.",avmm_rcfg_rtb_path});

   if(!uvm_config_db#(status_rcfg_if)::get(this, "", "status_rcfg_if", mon_if_rcfg_status)) begin
       `uvm_fatal("ETH_ENV","AVMM interfae not found"); 
   end

endfunction

//************************************************************************************

function void eth_env_env::build_fc_agt();
   if(!uvm_config_db#(virtual eth_fc_interface)::get(this, "", "mst_if", fc_if)) begin
      `uvm_fatal("eth_fc_interface", "failed to get fc_if intf"); 
   end
   uvm_config_db #(virtual eth_fc_interface)::set(this,"*", "mst_if",fc_if);
   uvm_config_db #(virtual eth_fc_interface)::set(this,"*", "slv_if",fc_if);
   flow_agent = eth_fc_agt::type_id::create("fc_agent",this);
endfunction

//************************************************************************************

function void eth_env_env::get_spy_if();
   if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
      `uvm_fatal("spy_interface", "failed to get spy_interface intf");
   end
   uvm_config_db#(virtual spy_interface)::set(this,"*","spy_interface", spy_if);
   if(m_sequence == "bandwidth_sequence" || m_sequence == "sanity_loopback_sequence") begin
      `uvm_info("eth_env_env", $psprintf("sequnce set from commnad line is %0s",m_sequence),UVM_NONE);
      spy_if.loopback_enable = 1;	   
   end
endfunction

//************************************************************************************

function void eth_env_env::build_rst_agt();
   if(!uvm_config_db#(virtual reset_if)::get(this, "", "slv_if", reset_if)) begin
      `uvm_fatal("reset_interface", "failed to get reset_if intf");
   end
   uvm_config_db#(virtual reset_if)::set(this,"*","slv_if", reset_if);
   reset_uvc_inst = reset_agent::type_id::create("reset_uvc_inst",this);
endfunction

//************************************************************************************

function void eth_env_env::get_sideband_if();
   if(!uvm_config_db#(virtual eth_sideband_interface)::get(this, "", "mst_if", sideband_if)) begin
      `uvm_fatal("eth_sideband_interface", "failed to get sideband intf");
   end
   uvm_config_db #(virtual eth_sideband_interface)::set(this,"*", "mst_if",sideband_if);
   uvm_config_db #(virtual eth_sideband_interface)::set(this,"*", "slv_if",sideband_if);
endfunction

//************************************************************************************

function void eth_env_env::build_seg_agt();
   seg_tx_agent = client_tx_agent::type_id::create("seg_tx_agent",this);
   seg_rx_agent = client_rx_agent::type_id::create("seg_rx_agent",this);
	// Additional layer is created for mac seg TX & RX monitor 
   mast_mon_macseg_tx = eth_macseg_tx_layering_mon::type_id::create("mast_mon_macseg_tx",this);
   mast_mon_macseg_rx = eth_macseg_rx_layering_mon::type_id::create("mast_mon_macseg_rx",this);
   if(!uvm_config_db#(string)::get(this,"","seg_tx_rtb_path", seg_tx_rtb_path)) begin
      `uvm_fatal("seg_tx_rtb_path", "failed to get seg_tx_rtb_path");
   end
   seg_tx_agent.set_rtb_path({"eth_env_top.",seg_tx_rtb_path});
   if(!uvm_config_db#(string)::get(this,"","seg_rx_rtb_path", seg_rx_rtb_path)) begin
      `uvm_fatal("seg_rx_rtb_path", "failed to get seg_rx_rtb_path");
   end
   seg_rx_agent.set_rtb_path({"eth_env_top.",seg_rx_rtb_path});
endfunction

//************************************************************************************

function void eth_env_env::build_tx_avst_agt();
   if(!uvm_config_db#(string)::get(this,"","avst_tx_rtb_path", avst_tx_rtb_path)) begin
      `uvm_fatal("avst_tx_rtb_path", "failed to get avst_tx_rtb_path");
   end
   `uvm_info(get_type_name(),$sformatf("AVST TX Path: %s",avst_tx_rtb_path), UVM_LOW);
   tx_avst_agt_cfg    = avst_config::type_id::create("tx_avst_agent_cfg",this);
   tx_avst_agt_cfg.m_msg_id    = "AVST_TX";
   tx_avst_agt_cfg.enable_tracker    = 1;
   `altuvm_set_config_db(avst_config,"m_config", tx_avst_agt_cfg,"tx_avst_agt")
   
   tx_avst_agt= avst_agent::type_id::create("tx_avst_agt", this);
   tx_avst_agt.set_rtb_path({"top_tb.hps_rtb_i.",avst_tx_rtb_path});
   master_agent = eth_tx_layering_agt::type_id::create("master_agent",this);
endfunction

//************************************************************************************

function void eth_env_env::build_rx_avst_agt();
   if(!uvm_config_db#(string)::get(this,"","avst_rx_rtb_path", avst_rx_rtb_path)) begin
      `uvm_fatal("avst_rx_rtb_path", "failed to get avst_rx_rtb_path");
   end
   `uvm_info(get_type_name(),$sformatf("AVST RX Path: %s",avst_rx_rtb_path), UVM_LOW);
   rx_avst_agt_cfg    = avst_config::type_id::create("agent_cfg",this);
   rx_avst_agt_cfg.m_msg_id    = "AVST_RX_MON";
   rx_avst_agt_cfg.enable_tracker    = 1;
   `altuvm_set_config_db(avst_config, "m_config", rx_avst_agt_cfg,    "rx_avst_agt")

   rx_avst_agt= avst_agent::type_id::create("rx_avst_agt", this);
   rx_avst_agt.set_rtb_path({"top_tb.hps_rtb_i.",avst_rx_rtb_path});
   rx_avst_pkt_adapter = eth_avst_rx_pkt_adapter::type_id::create("rx_avst_pkt_adapter", this);
endfunction

//************************************************************************************

function void eth_env_env::build_ptp_tx_agt();
   if(!uvm_config_db#(string)::get(this,"","ptp_tx_rtb_path", ptp_tx_rtb_path)) begin
      `uvm_fatal("ptp_tx_rtb_path", "failed to get ptp_tx_rtb_path");
   end                   
            
   m_ptp_tx_agent = ptp_tx_agent::type_id::create("m_ptp_tx_agent",this);
   m_ptp_tx_agent.set_rtb_path({"eth_env_top.",ptp_tx_rtb_path});

   m_ptp_tx_ref_model = ptp_tx_ref_model::type_id::create("m_ptp_tx_ref_model",this);
   m_ptp_config = ptp_config::type_id::create("m_ptp_config",this);
   if($value$plusargs("tod_sec_part=%d",tod_sec_part) && 
      $value$plusargs("tod_ns_fns_part=%f",tod_ns_fns_part)) begin
      tod_ns_part = $floor(tod_ns_fns_part);
      m_ptp_config.tod_fns_part = tod_ns_fns_part - tod_ns_part;
      m_ptp_config.rand_tod=0;
      m_ptp_config.user_tod=1;
      if(!m_ptp_config.randomize() with {
         tod_seconds_part == this.tod_sec_part; 
         tod_ns_part == local::tod_ns_part; })
         `uvm_error("ptp_config", "failed to randomize ptp_config");
   end
   else begin
      m_ptp_config.rand_tod=1;
      m_ptp_config.user_tod=0;
      if(!$test$plusargs("rx_its_debug_mode")) begin
         m_ptp_config.rand_tod=0;
         m_ptp_config.user_tod=0;
      end
      if(!m_ptp_config.randomize()) 
         `uvm_error("ptp_config", "failed to randomize ptp_config");
      uvm_config_db#(ptp_config)::set(this, "m_ptp_tx_agent", "ptp_config", m_ptp_config);
   end
endfunction

//************************************************************************************

function void eth_env_env::build_mii_tx_agt();
   if(!uvm_config_db#(virtual ehip_mii_tx_if)::get(this, "", "mii_tx_if", mii_tx_uif)) begin
      `uvm_fatal("mii_tx_if", "failed to get mii_tx_if intf");
   end 
   else begin
      uvm_config_db#(virtual ehip_mii_tx_if)::set(this, "*", "mii_tx_if", mii_tx_uif);
   end

   if(!uvm_config_db#(virtual ehip_mii_tx_if)::get(this, "", "mii_rx_if", mii_rx_uif)) begin
      `uvm_fatal("mii_tx_if", "failed to get mii_rx_if intf");
   end 
   else begin
      uvm_config_db#(virtual ehip_mii_tx_if)::set(this, "*", "mii_rx_if", mii_rx_uif);
   end   

   mii_tx_agent = ehip_mii_tx_agent::type_id::create("mii_tx_agent",this);

endfunction

//************************************************************************************

function void eth_env_env::build_flexe_otn_agt();
   // This is ethenet vip instance and related setting for PCS66 
   m_snps_flexe_otn_agent = svt_ethernet_agent::type_id::create("m_snps_flexe_otn_agent", this);
   m_snps_flexe_otn_agent.set_report_verbosity_level_hier(UVM_NONE); 
   uvm_config_db#(int)::set(this, "*.m_snps_flexe_otn_agent","is_active",UVM_ACTIVE);
            
   if (!uvm_config_db#(svt_ethernet_agent_configuration)::get(this, "", "mac_cfg_otn_flexe", mac_cfg_otn_flexe)) begin
      `uvm_fatal("svt_ethernet_agent_configuration", "failed to get mac_cfg_otn_flexe object from test");
   end
   else begin
      uvm_config_db#(svt_ethernet_agent_configuration)::set(this, "m_snps_flexe_otn_agent*", "cfg", mac_cfg_otn_flexe);
      `uvm_info("svt_ethernet_agent_configuration", $sformatf("SVT OTN/FLEXE VIP agent configuration : \n",mac_cfg_otn_flexe.print()), UVM_MEDIUM);
   end
         
   if(!uvm_config_db#(virtual svt_ethernet_txrx_if)::get(this, "", "pcs_tx_if_port", svt_ethernet_pcs_mode_txrx_inst)) begin
      `uvm_fatal("svt_ethernet_txrx_if", "failed to get svt_ethernet_txrx_if object from test");
   end 
   else begin
      `uvm_info("svt_ethernet_txrx_if", $sformatf("rami-2 svt_ethernet_txrx_if intf ...=%0t", $time), UVM_MEDIUM)
      uvm_config_db#(virtual svt_ethernet_txrx_if)::set(this,"m_snps_flexe_otn_agent*", "if_port", svt_ethernet_pcs_mode_txrx_inst);
   end
endfunction

//************************************************************************************

function void eth_env_env::build_coverage();
   cov = eth_env_cov::type_id::create("cov",this); //Instantiating the coverage class
   rx_mac_cov = eth_rx_mac_cov::type_id::create("rx_mac_cov",this); //Instantiating the coverage class
   eth_mac_frame_tx = altera_coverage_swip_eth_mac_frame_mgbaset_c::type_id::create("eth_mac_frame_tx",this);
   eth_mac_frame_tx.tx_rx=1;
   eth_mac_frame_rx = altera_coverage_swip_eth_mac_frame_mgbaset_c::type_id::create("eth_mac_frame_rx",this);
   eth_mac_frame_rx.tx_rx=0;
   eth_xgmii_ddr_tx = altera_coverage_swip_eth_xgmii_ddr_c::type_id::create("eth_xgmii_ddr_tx",this);   
   eth_xgmii_ddr_tx.tx_rx=1;
   eth_xgmii_ddr_rx = altera_coverage_swip_eth_xgmii_ddr_c::type_id::create("eth_xgmii_ddr_rx",this);
   eth_xgmii_ddr_tx.tx_rx=0; 

   mon2cov  = eth_tx_layering_mon_2cov_connect::type_id::create("mon2cov", this);
   mon2cov.cov = cov;
endfunction

//************************************************************************************

function void eth_env_env::build_scoreboard();
   // This is vip tx port to mac rx port scoreboard instance 
   sb_vip_tx_mac_rx = eth_scoreboard::type_id::create("sb_vip_tx_mac_rx",this);
   
   // Object :sb_mac_tx_vip_rx 
   // This is mac tx to vip rx port scoreboard instance 
   sb_mac_tx_vip_rx = eth_scoreboard::type_id::create("sb_mac_tx_vip_rx",this);
   sb_mac_tx_vip_rx.tx_rx = 1'b1;
   
   // Object :sb_vec_vip_tx_mac_rx 
   // This is vector tx scoreboard instance 
   sb_vec_vip_tx_mac_rx = vector_uvc_scoreboard::type_id::create("sb_vec_vip_tx_mac_rx",this);

   // Object :sb_vec_mac_tx_vip_rx 
   // This is vector rx scoreboard instance 
   sb_vec_mac_tx_vip_rx = vector_uvc_scoreboard::type_id::create("sb_vec_mac_tx_vip_rx",this);
endfunction

//************************************************************************************
   
function void eth_env_env::build_pcs_agt();
   m_snps_eth_pcs66_agent = svt_ethernet_agent::type_id::create("m_snps_eth_pcs66_agent", this);
   m_snps_eth_pcs66_agent.set_report_verbosity_level_hier(UVM_NONE); 
   uvm_config_db#(int)::set(this, "*.m_snps_eth_pcs66_agent","is_active",UVM_ACTIVE);
   if (!uvm_config_db#(svt_ethernet_agent_configuration)::get(this, "", "mac_cfg", mac_cfg)) begin
      `uvm_fatal("svt_ethernet_agent_configuration", "failed to get mac_cfg object from test");      
   end
   else begin
      uvm_config_db#(svt_ethernet_agent_configuration)::set(this, "m_snps_eth_pcs66_agent*", "cfg", mac_cfg);
      `uvm_info("svt_ethernet_agent_configuration", $sformatf("SVT VIP agent configuration : \n",mac_cfg.print()), UVM_MEDIUM);
   end
   if(!uvm_config_db#(virtual svt_ethernet_txrx_if)::get(this, "", "if_port", svt_ethernet_txrx_inst)) begin
      `uvm_fatal("svt_ethernet_txrx_if", "failed to get svt_ethernet_txrx_if object from test");
   end
   else begin
      `uvm_info("svt_ethernet_txrx_if", $sformatf("rami-1 svt_ethernet_txrx_if intf ...=%0t", $time), UVM_MEDIUM)
      uvm_config_db#(virtual svt_ethernet_txrx_if)::set(this,"m_snps_eth_pcs66_agent*", "if_port", svt_ethernet_txrx_inst);
    end
endfunction

//************************************************************************************

function void eth_env_env::build_callbacks();
   mac_usr_66_callback = new("mac_usr_66_callback");
   mac_66_err_callback = new("mac_66_err_callback");
   mac_err_callback = new("mac_err_callback");
   
   mac_callback = new("mac_callback");
   //mac_test_callback = new("mac_test_callback");
   mac_rs_fec_err_encoder_callback = new("mac_rs_fec_err_encoder_callback");
   xxvsbi_lsbi_bip_corruption_callback = new("xxvsbi_lsbi_bip_corruption_callback");
   rs_fec_bip_corruption_callbacks = new("rs_fec_bip_corruption_callbacks");
   g400_bip_corruption_callback = new("g400_bip_corruption_callback");
   g100_ck_corruption_callbacks = new("g100_ck_corruption_callbacks");
   txrx_bip_corruption_callback = new("txrx_bip_corruption_callback");
   mac_callback.link_trans.cfg = `MAC_CFG;
endfunction

//************************************************************************************

function void eth_env_env::build_phase(uvm_phase phase);

   super.build_phase(phase);
   build_phy_cfg_agt();

   // Get Dyn cfg obj
   if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
      `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
   end 
   uvm_config_db #(dyn_rcfg)::set(this,"*", "dyn_rcfg_obj_inst",dyn_rcfg_obj_inst);

   if (dyn_rcfg_obj_inst.device_mode == _SM) begin
      build_mac_cfg_agt();
      build_rcfg_agt();
   end

   if(dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG}) begin 
      //PRASH 5.10 FLOW CONTROL INTERFACE(This is enabled for MAC AVST / MAC_SEG Client)
      build_fc_agt(); 
   end
   
   build_rst_agt();
   get_sideband_if();
   
   if(dyn_rcfg_obj_inst.mode == MACSEG) begin 
      build_seg_agt();
    end
    
   //Put outside as it is common for both MACSEG and AVST

   if(dyn_rcfg_obj_inst.mode == PCSMAC) begin
      build_tx_avst_agt();
      build_rx_avst_agt();
   end

   if(dyn_rcfg_obj_inst.mode == PCSMAC || 
      dyn_rcfg_obj_inst.mode == MACSEG ) begin
      if(dyn_rcfg_obj_inst.ptp == 1) begin
         build_ptp_tx_agt();
      end
   end
   
   if(dyn_rcfg_obj_inst.mode == PCSONLY) begin
      build_mii_tx_agt();
   end

   // Create IP checker 
   get_spy_if();
   ipg_checker   = eth_ipg_checker::type_id::create("ipg_checker",this);
   build_coverage();
   build_scoreboard();
   build_pcs_agt();
   build_callbacks();

   //get interface from top
   if(!uvm_config_db#(virtual eth_testsuite_tasks_intf)::get(this, "", "ts_tasks_if", ts_tasks_if)) begin
      `uvm_fatal("ts_tasks_if", "failed to get testsuite task intf");
   end
   uvm_config_db#(virtual eth_testsuite_tasks_intf)::set(this,"*", "ts_tasks_if", ts_tasks_if);

    //get interface from top
    
    if((dyn_rcfg_obj_inst.mode==OTN) || (dyn_rcfg_obj_inst.mode==FLEXE)) begin
      build_flexe_otn_agt();
   end  
   if(loopback_enable == 1) begin 
     sb_loopbk = eth_scoreboard::type_id::create("sb_loopbk",this);
   end


   
   if(!uvm_config_db#(string)::get(this,"","env_name", env_name)) begin
      `uvm_fatal("", "failed to get env_name");
   end

   if (!(dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})) begin
   if(!uvm_config_db#(string)::get(this,"","dut_name", dut_name)) begin
      `uvm_fatal("", "failed to get dut_name");
   end
   end

   
   // Object :virtual_sequencer_inst 
   // This is virtual sequnecer instance
   virtual_sequencer_inst = eth_virtual_sequencer::type_id::create("virtual_sequencer_inst",this); 
   
   // Object :eth_ref_model_inst 
   // This is ethenet ref model instance 
   eth_ref_model_inst = eth_ref_model::type_id::create("eth_ref_model_inst",this);

   if ((dyn_rcfg_obj_inst.mode==OTN) || (dyn_rcfg_obj_inst.mode==FLEXE)) begin
      eth_ref_model_inst_pcs66 = eth_ref_model::type_id::create("eth_ref_model_inst_pcs66",this);
   end

   //Object:vector_rx
   //This is ethernet tx vector instance
 
   vector_agent = vector_uvc_agent::type_id::create("vector_agent",this);

    // Below code is to disable the coverage of vector_uvc_mon if the interface is MACSEG
    if(dyn_rcfg_obj_inst.mode == MACSEG  || 
       dyn_rcfg_obj_inst.mode == PCSONLY || 
       dyn_rcfg_obj_inst.mode == OTN || 
       dyn_rcfg_obj_inst.mode == FLEXE )
    cover_disable_for_macseg  =1;
    set_config_int("*","cover_disable_for_macseg",cover_disable_for_macseg);
    ///---------------------------------------------------------------------------------

   // command line arguments
   inst = uvm_cmdline_processor::get_inst();
   inst.get_arg_value("+m_sequence=",m_sequence);

   //Object:reg_cov
   //This is register coverage instance create
   reg_cov = register_coverage::type_id::create("reg_cov",this);
   
   // Object :reg_adpt 
   // Register adapter instance creation
   reg_adpt = altuvm_avalon_mm_reg_adapter::type_id::create( .name( $sformatf("reg_adpt_%0d",current_val) ) );
   // Object :reg_model 
   // Register model istance creation and related setting
   //uvm_reg::include_coverage("*", UVM_CVR_ALL);
   reg_model = registers_urm::type_id::create($sformatf("reg_model_%0d",current_val), , get_full_name());
   reg_predictor = altuvm_avalon_mm_reg_predictor::type_id::create("reg_predictor", this);
   reg_model.build();

   //Update RAL reset valuse as per DUT parameter
   update_ral_reset_value();
   reg_model.reset();

   reg_model.lock_model();
   
   if (dyn_rcfg_obj_inst.trans_type == 0 ) begin //UX
      uvm_config_db#(bit)::set(null,"*","u_barak_quad_disable",1);
   end
   else begin //BK
      uvm_config_db#(bit)::set(null,"*","u_ux_quad_disable",1);
   end

   if (dyn_rcfg_obj_inst.device_mode == _SM) begin
     reg_mac_adpt = altuvm_avalon_mm_reg_adapter::type_id::create( .name( $sformatf("reg_mac_adpt_%0d",current_val) ) );
     //reg_model = registers_urm::type_id::create($sformatf("reg_model_%0d",current_val), , get_full_name());
     reg_mac_predictor = altuvm_avalon_mm_reg_predictor::type_id::create("reg_mac_predictor", this);
     //reg_model.build();
     reg_rcfg_adpt = altuvm_avalon_mm_reg_adapter::type_id::create( .name( $sformatf("reg_rcfg_adpt_%0d",current_val) ) );
     reg_rcfg_predictor = altuvm_avalon_mm_reg_predictor::type_id::create("reg_rcfg_predictor", this);
   end

    virtual_sequencer_inst.reg_model = reg_model;
    eth_ref_model_inst.reg_model = reg_model;
    
    if ((dyn_rcfg_obj_inst.mode==OTN) || (dyn_rcfg_obj_inst.mode==FLEXE)) begin
        eth_ref_model_inst_pcs66.reg_model = reg_model;
	
    end

    rx_mac_cov.reg_model = reg_model;
    eth_mac_frame_rx.reg_model = reg_model; 
    eth_mac_frame_tx.reg_model = reg_model; 
    reg_cov.reg_model = reg_model;
    uvm_config_db #(registers_urm)::set(this,"*", "reg_model",reg_model);
    
endfunction: build_phase

//************************************************************************************

function void eth_env_env::add_callbacks();
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,mac_callback);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,mac_66_err_callback);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(m_snps_eth_pcs66_agent.driver,mac_err_callback);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,xxvsbi_lsbi_bip_corruption_callback);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,rs_fec_bip_corruption_callbacks);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,g400_bip_corruption_callback);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,g100_ck_corruption_callbacks);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(`M_SNPS_ETH_PCS66_AGENT.driver,txrx_bip_corruption_callback);
   uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::display();
   uvm_callbacks#(svt_ethernet_pcs_force_encoded_data,svt_ethernet_pcs_force_encoded_data_callback)::add(`M_SNPS_ETH_PCS66_AGENT.encoded_driver,mac_usr_66_callback);
   uvm_callbacks#(svt_ethernet_pcs_force_encoded_data,svt_ethernet_pcs_force_encoded_data_callback)::display();

   if((dyn_rcfg_obj_inst.mode == OTN) || (dyn_rcfg_obj_inst.mode == FLEXE)) begin 
      // Connect eth_ref_model_inst_pcs66 to snps flexe/otn agent
      m_snps_flexe_otn_agent.monitor.item_collected_port_tx.connect(eth_ref_model_inst_pcs66.item_collected_vip_tx);
      m_snps_flexe_otn_agent.monitor.item_collected_port_rx.connect(eth_ref_model_inst_pcs66.item_collected_vip_rx);
      virtual_sequencer_inst.eth_vip_seqr_inst_otn_flexe = m_snps_flexe_otn_agent.sequencer  ;
      uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::add(m_snps_flexe_otn_agent.driver,mac_66_err_callback);
      uvm_callbacks#(svt_ethernet_txrx,svt_ethernet_txrx_callback)::display();
      uvm_callbacks#(svt_ethernet_pcs_force_encoded_data,svt_ethernet_pcs_force_encoded_data_callback)::add(m_snps_flexe_otn_agent.encoded_driver,mac_usr_66_callback);
      uvm_callbacks#(svt_ethernet_pcs_force_encoded_data,svt_ethernet_pcs_force_encoded_data_callback)::display();
   end
endfunction

//************************************************************************************

//************************************************************************************

//************************************************************************************

function void eth_env_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   
   eth_ref_model_inst.eth_env = this;
   flow_agent.flow_drv.env = this;
  
   if ((dyn_rcfg_obj_inst.mode==OTN) || (dyn_rcfg_obj_inst.mode==FLEXE)) begin
      eth_ref_model_inst_pcs66.eth_env = this;      
   end
   if (dyn_rcfg_obj_inst.mode == PCSMAC) begin
      master_agent.mast_drv.reg_model = this.reg_model;
      //Connecting the monitor's analysis ports with eth_scoreboard's expected analysis exports.
      tx_avst_agt.monitor_ap.connect(master_agent.mast_mon.frm_avst_mon);
      rx_avst_agt.monitor_ap.connect(rx_avst_pkt_adapter.frm_rx_avst_mon);
   end

   if(dyn_rcfg_obj_inst.mode == MACSEG) begin 
      if(dyn_rcfg_obj_inst.ptp == 1) begin
         seg_tx_agent.m_ap.connect(mast_mon_macseg_tx.frm_macseg_mon);
         //mast_mon_macseg_tx.mon_stat_tx_analysis_port.connect(m_ptp_tx_ref_model.a_imp_tx_layering_agt);
         mast_mon_macseg_tx.mon_analysis_port.connect(m_ptp_tx_ref_model.a_imp_tx_layering_agt);
         //PTP Tx agent (mon on ptp tx o/p) ->  PTP Tx Ref model
         m_ptp_tx_agent.m_ptp_tx_mon.m_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_mon);
         m_ptp_tx_agent.m_ptp_tx_mon.m_rx_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_rx_mon);
         m_ptp_tx_agent.m_ptp_tx_mon.m_wb_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_wb_mon);
         m_ptp_tx_agent.m_ptp_tx_mon.m_wb_rx_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_wb_rx_mon);
         //PTP Tx Ref model -> Eth scoreboard
         m_ptp_tx_ref_model.a_port.connect(sb_mac_tx_vip_rx.before_export);
         eth_ref_model_inst.eth_rx_to_dest.connect(m_ptp_tx_ref_model.a_imp_rx_avst_mon); //TODO
	      //eth_ref_model_inst.eth_rx_to_dest.connect(mast_mon_macseg_rx.frm_rx_macseg_mon);
         //mast_mon_macseg_rx.rx_mac_to_scb_ap.connect(m_ptp_tx_ref_model.a_imp_rx_avst_mon);
         //seg_tx_agent.m_ap.connect(m_ptp_tx_agent.m_ptp_tx_mon.a_imp_tx_layering_agt); 
         ////For checking TX Egress VS Rx Ingress. Writting in TX Ingress which have is_ptp_seq info
         seg_rx_agent.m_ap.connect(mast_mon_macseg_rx.frm_rx_macseg_mon);
         mast_mon_macseg_rx.rx_mac_to_scb_ap.connect(sb_vip_tx_mac_rx.after_export);
   	   //seg_rx_agent.m_ap.connect(sb_vip_tx_mac_rx.after_export);
       end 
       else begin
         //TX
         seg_tx_agent.m_ap.connect(mast_mon_macseg_tx.frm_macseg_mon);
         mast_mon_macseg_tx.mon_stat_tx_analysis_port.connect(eth_ref_model_inst.eth_stat_tx);
         mast_mon_macseg_tx.mon_analysis_port.connect(sb_mac_tx_vip_rx.before_export);
         seg_tx_agent.m_ap.connect(reg_cov.eth_frame_from_driver);
	      //RX
	      seg_rx_agent.m_ap.connect(mast_mon_macseg_rx.frm_rx_macseg_mon);
         mast_mon_macseg_rx.rx_mac_to_scb_ap.connect(sb_vip_tx_mac_rx.after_export);
         if(loopback_enable ==1) begin
            mast_mon_macseg_tx.mon_analysis_port.connect(sb_loopbk.before_export);
            mast_mon_macseg_rx.rx_mac_to_scb_ap.connect(sb_loopbk.after_export);
         end 
         else begin
            mast_mon_macseg_tx.mon_analysis_port.connect(sb_mac_tx_vip_rx.before_export);
            mast_mon_macseg_rx.rx_mac_to_scb_ap.connect(sb_vip_tx_mac_rx.after_export);
         end
      end   		
      eth_ref_model_inst.eth_rx_to_dest.connect(sb_mac_tx_vip_rx.after_export);
      eth_ref_model_inst.eth_tx_to_dest.connect(sb_vip_tx_mac_rx.before_export);
         
      eth_ref_model_inst.vip_tx_to_rxmac_cov.connect(rx_mac_cov.item_collected_vip_tx_pkt_size);//added for 2OOG coverage
   	virtual_sequencer_inst.v_m_sqr = seg_tx_agent.m_sqr;
   end

   if(dyn_rcfg_obj_inst.mode == PCSMAC) begin
      //Other monitor element will be connected to the after export of the scoreboard
      master_agent.mast_mon.mon_analysis_port.connect(cov.cov_export);
      uvm_config_db#(avst_sequencer)::set(this,"master_agent.mast_drv","lower_sqr",tx_avst_agt.m_sequencer);
      virtual_sequencer_inst.tx_seqr = master_agent.mast_sqr;
   end

   virtual_sequencer_inst.reset_seqr_inst = reset_uvc_inst.slv_seqr;
   virtual_sequencer_inst.status_seqr = avmm_agt.m_sequencer;
   if (dyn_rcfg_obj_inst.device_mode == _SM) begin
      virtual_sequencer_inst.status_mac_seqr = avmm_agt_mac.m_sequencer;
      virtual_sequencer_inst.status_rcfg_seqr = avmm_agt_rcfg.m_sequencer;
   end
   if(dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG}) begin
      virtual_sequencer_inst.fc_sqr = flow_agent.flow_sqr;
   end

        


   `M_SNPS_ETH_PCS66_AGENT.monitor.item_collected_port_tx.connect(eth_ref_model_inst.item_collected_vip_tx);
   `M_SNPS_ETH_PCS66_AGENT.monitor.item_collected_port_rx.connect(eth_ref_model_inst.item_collected_vip_rx);
   virtual_sequencer_inst.eth_vip_seqr_inst = m_snps_eth_pcs66_agent.`SEQUENCER  ;
   add_callbacks(); 
   
   if(dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG}) begin
   flow_agent.flow_mon.mon_analysis_port.connect(sb_mac_tx_vip_rx.before_export);
   flow_agent.flow_mon.mon_analysis_port.connect(eth_ref_model_inst.eth_stat_tx);
   end

   // flow_agent.flow_mon.mon_analysis_port.connect(eth_ref_model_inst.eth_vector_tx);

    if (dyn_rcfg_obj_inst.mode == PCSMAC) begin
      if (dyn_rcfg_obj_inst.ptp == 1) begin

            //Layering agent -> PTP Tx Ref model
            master_agent.mast_mon.mon_analysis_port.connect(m_ptp_tx_ref_model.a_imp_tx_layering_agt);
            //PTP Tx agent (mon on ptp tx o/p) ->  PTP Tx Ref model
            m_ptp_tx_agent.m_ptp_tx_mon.m_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_mon);
            m_ptp_tx_agent.m_ptp_tx_mon.m_rx_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_rx_mon);
            m_ptp_tx_agent.m_ptp_tx_mon.m_wb_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_wb_mon);
            m_ptp_tx_agent.m_ptp_tx_mon.m_wb_rx_ap.connect(m_ptp_tx_ref_model.a_imp_ptp_tx_wb_rx_mon);
            //PTP Tx Ref model -> Eth scoreboard
            m_ptp_tx_ref_model.a_port.connect(sb_mac_tx_vip_rx.before_export);
            //eth_ref_model_inst.eth_rx_to_dest.connect(sb_mac_tx_vip_rx.a_imp_rx_avst_mon); //TODO
            eth_ref_model_inst.eth_rx_to_dest.connect(m_ptp_tx_ref_model.a_imp_rx_avst_mon); //TODO
      end else begin
          if(loopback_enable == 1) begin
             master_agent.mast_mon.mon_analysis_port.connect(sb_loopbk.before_export);
             rx_avst_pkt_adapter.rx_mac_to_scb_ap.connect(sb_loopbk.after_export);
          end else begin 
             master_agent.mast_mon.mon_analysis_port.connect(sb_mac_tx_vip_rx.before_export);
             master_agent.mast_mon.mon_analysis_port.connect(eth_ref_model_inst.eth_vector_tx);
          end
      end

      if(loopback_enable == 0) begin
        eth_ref_model_inst.eth_rx_to_dest.connect(sb_mac_tx_vip_rx.after_export);
        eth_ref_model_inst.eth_tx_to_dest.connect(sb_vip_tx_mac_rx.before_export);
        rx_avst_pkt_adapter.rx_mac_to_scb_ap.connect(sb_vip_tx_mac_rx.after_export);

        rx_avst_pkt_adapter.rx_mac_to_scb_ap.connect(eth_ref_model_inst.eth_avst_rx);//This was done for malform tests to predict stats for malform frame
        master_agent.mast_mon.mon_stat_tx_analysis_port.connect(eth_ref_model_inst.eth_stat_tx);
        eth_ref_model_inst.vip_tx_to_rxmac_cov.connect(rx_mac_cov.item_collected_vip_tx_pkt_size);
      end

   end    


   if (dyn_rcfg_obj_inst.mode == PCSONLY) begin

       // MII TX Agent -> PCS ONLY TX SB
       mii_tx_agent.mii_tx_mon.m_ap.connect(sb_mac_tx_vip_rx.before_export);
       // Eth ref model -> PCS ONLY TX SB
       eth_ref_model_inst.eth_rx_to_dest.connect(sb_mac_tx_vip_rx.after_export);

       // Eth ref model -> PCS ONLY RX SB
       eth_ref_model_inst.eth_tx_to_dest.connect(sb_vip_tx_mac_rx.before_export);
       // mii rx monitor -> PCS ONLY RX SB
       mii_tx_agent.mii_rx_mon.m_ap.connect(sb_vip_tx_mac_rx.after_export);
      // for covering f_size_short_rx CG
      eth_ref_model_inst.vip_tx_to_rxmac_cov.connect(rx_mac_cov.item_collected_vip_tx_pkt_size);
   end    

   if ((dyn_rcfg_obj_inst.mode == OTN) || (dyn_rcfg_obj_inst.mode == FLEXE)) begin 

      eth_ref_model_inst.eth_tx_to_dest.connect(sb_vip_tx_mac_rx.before_export);//Expected Packet
      eth_ref_model_inst_pcs66.eth_rx_to_dest.connect(sb_vip_tx_mac_rx.after_export);//Actual Packet
      
      eth_ref_model_inst_pcs66.eth_tx_to_dest.connect(sb_mac_tx_vip_rx.before_export);
      eth_ref_model_inst.eth_rx_to_dest.connect(sb_mac_tx_vip_rx.after_export);

      // for covering f_size_short_rx CG
      eth_ref_model_inst.vip_tx_to_rxmac_cov.connect(rx_mac_cov.item_collected_vip_tx_pkt_size);
   end
   //Vector port RX connection
   eth_ref_model_inst.vip_tx_to_sb.connect(sb_vec_vip_tx_mac_rx.before_export);
   eth_ref_model_inst.vector_tx_to_sb.connect(sb_vec_mac_tx_vip_rx.before_export);
   if (dyn_rcfg_obj_inst.mode == MACSEG) seg_rx_agent.m_ap_vec.connect(sb_vec_vip_tx_mac_rx.after_export);
   else vector_agent.m_ap.connect(sb_vec_vip_tx_mac_rx.after_export);
   vector_agent.m_ap_tx.connect(sb_vec_mac_tx_vip_rx.after_export);


   reg_model.default_map.set_sequencer( .sequencer( avmm_agt.m_sequencer),.adapter(reg_adpt ) );
   if (dyn_rcfg_obj_inst.device_mode == _SM) begin
      reg_model.default_map.set_sequencer( .sequencer( avmm_agt_mac.m_sequencer),.adapter(reg_mac_adpt ) );
      reg_model.default_map.set_sequencer( .sequencer( avmm_agt_rcfg.m_sequencer),.adapter(reg_rcfg_adpt ) );
   end  


   reg_model.default_map.set_auto_predict(1); // In DR 0, but in C3 1 - RAMI_FIX

   virtual_sequencer_inst.env = this; 
   avmm_agt.monitor_ap.connect(eth_ref_model_inst.avmm_bus_in);
   if (dyn_rcfg_obj_inst.device_mode == _SM) begin
   avmm_agt_mac.monitor_ap.connect(eth_ref_model_inst.mac_avmm_bus_in);
   reg_mac_predictor.map =  reg_model.default_map;
   reg_mac_predictor.adapter = reg_mac_adpt;
   avmm_agt_rcfg.monitor_ap.connect(eth_ref_model_inst.rcfg_avmm_bus_in);
   reg_rcfg_predictor.map =  reg_model.default_map;
   reg_rcfg_predictor.adapter = reg_rcfg_adpt;
   end

   if (dyn_rcfg_obj_inst.ptp == 1) begin
      avmm_agt.monitor_ap.connect(m_ptp_tx_ref_model.avmm_bus_in_ptp);
   end

   reg_predictor.map =  reg_model.default_map;
   reg_predictor.adapter = reg_adpt;
   //avmm_agt.monitor_ap.connect(reg_predictor.bus_in);
   
   reset_uvc_inst.slv_mon.mon_analysis_port.connect(eth_ref_model_inst.item_collected_reset_port);

   //Register Coverage connection with avmm bus
   avmm_agt.monitor_ap.connect(reg_cov.avmm_bus);
   if (dyn_rcfg_obj_inst.device_mode == _SM) begin
   avmm_agt_mac.monitor_ap.connect(reg_cov.avmm_bus);
   avmm_agt.monitor_ap.connect(reg_cov.avmm_bus);
   end

   if (dyn_rcfg_obj_inst.mode == PCSMAC) begin
      master_agent.mast_mon.mon_analysis_port.connect(reg_cov.eth_frame_from_driver);
      master_agent.mast_mon.mon_analysis_port.connect(reg_cov.pause_tx_pkt);
   end
   
   eth_ref_model_inst.eth_tx_to_dest.connect(reg_cov.eth_frame_from_vip);
   if(dyn_rcfg_obj_inst.mode inside {PCSMAC,MACSEG}) begin 
   flow_agent.flow_mon.mon_analysis_port_cov.connect(reg_cov.pause_tx_pkt);
   end
   eth_ref_model_inst.eth_tx_to_dest.connect(reg_cov.pause_rx_pkt);
   rx_avst_pkt_adapter.rx_mac_to_scb_ap.connect(eth_mac_frame_rx.eth_frame);
   master_agent.mast_mon.mon_analysis_port.connect(eth_mac_frame_tx.eth_frame);
 
endfunction: connect_phase

//************************************************************************************

function void eth_env_env::start_of_simulation_phase(uvm_phase phase);
   super.start_of_simulation_phase(phase);
   `ifdef UVM_VERSION_1_0
   uvm_top.print_topology();  
   factory.print();          
   `endif
   
   `ifdef UVM_VERSION_1_1
	uvm_root::get().print_topology(); 
   uvm_factory::get().print();      
   `endif

   `ifdef UVM_POST_VERSION_1_1
	uvm_root::get().print_topology(); 
   uvm_factory::get().print();      
   `endif

   //ToDo : Implement this phase here 
endfunction: start_of_simulation_phase

//************************************************************************************

task eth_env_env::reset_phase(uvm_phase phase);
   super.run_phase(phase);
endtask:reset_phase

//************************************************************************************

task eth_env_env::configure_phase (uvm_phase phase);
   super.configure_phase(phase);
   //ToDo: Configure components here
   configure_vector_scoreboard(); // Alex: Added as per new GDR proposol, HSD 16010938180
endtask:configure_phase

//************************************************************************************

task eth_env_env::run_phase(uvm_phase phase);
   longint byte_count;
   //int dist_between_two_starts;
   super.run_phase(phase);

   fork
   begin
     if($test$plusargs("TOD_VALID_DOWN")) begin
     `uvm_info(get_full_name(),$psprintf("Calling drive_ptp_tod_valid task"),UVM_MEDIUM)
     spy_if.drive_ptp_tod_valid();
     `uvm_info(get_full_name(),$psprintf("Out of drive_ptp_tod_valid task"),UVM_MEDIUM)
     end
   end
   begin
   `ifdef ENABLE_ETH_VIP
   //Logic to count bytes between two consicutive Starts
   //in VIP TX monitor
   fork
     begin
       forever begin
         @(spy_if.mii_tx_clk);
         if(spy_if.data_valid_tx==1) byte_count = byte_count+4;
       end
     end
     begin
       forever begin
         @(spy_if.event_chk_start_cntrl_character_tx);
         eth_ref_model_inst.dist_between_two_starts=byte_count;
         //byte_count=0;
       end
     end
   join_none
   fork 
     begin
       forever begin
        @(posedge spy_if.fault or negedge spy_if.fault)
          #1;
          sb_mac_tx_vip_rx.scb_dis = spy_if.fault;
          if(sb_mac_tx_vip_rx.scb_dis == 1'b1)
          begin
            sb_mac_tx_vip_rx.flag = 1'b1;
          end
       end
     end
     begin //in hiber state of 2.5ms packet may get corrupted at rx mac
       forever begin
        @(posedge spy_if.hi_ber or negedge spy_if.hi_ber)
          sb_vip_tx_mac_rx.scb_dis = spy_if.hi_ber;
	  if(sb_vip_tx_mac_rx.scb_dis == 1'b1)
          begin
            sb_vip_tx_mac_rx.flag = 1'b1;
          end
       end
     end
   join
   `endif
   end
   join
    //ToDo: Run your simulation here
endtask:run_phase

//************************************************************************************

function void eth_env_env::report_phase(uvm_phase phase);
   super.report_phase(phase);
   //ToDo: Implement this phase here
endfunction:report_phase

//************************************************************************************

task eth_env_env::shutdown_phase(uvm_phase phase);
   super.shutdown_phase(phase);
   //ToDo: Implement this phase here
endtask:shutdown_phase

//************************************************************************************
task eth_env_env::reg_write(uvm_reg_data_t addr,uvm_reg_data_t data,uvm_reg_byte_en_t byte_enable='hf);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   altuvm_avalon_mm_write_seq write_seq;
   uvm_reg_data_t data_tmp;
   svt_axi_master_transaction       write_tran;
   svt_axi_master_transaction       axi_rsp;
   svt_axi_master_base_sequence     axi_mst_seq;
   svt_configuration                get_cfg;
   svt_axi_port_configuration       svt_port_cfg;

   select_reg = reg_model.default_map.get_reg_by_offset(addr);
   
   virtual_sequencer_inst.axi_mst_seqr.get_cfg(get_cfg);
   if (!$cast(svt_port_cfg, get_cfg)) begin
      `uvm_fatal("body", "Unable to $cast the configuration to a svt_axi_port_configuration class");
   end
   svt_port_cfg.wysiwyg_enable = 1;
   svt_port_cfg.ignore_wstrb_check_for_wysiwyg_format = 1;
   svt_port_cfg.addr_width = 29;
   svt_port_cfg.data_width = 32;

   //if ((select_reg != null) && (byte_enable == 'hf))
    if (select_reg != null)
    begin
     `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h write data :'h%0h byte_enable=%0b prev_value='h%0h",select_reg.get_name(),addr,data,byte_enable,select_reg.get()), UVM_NONE)
     data_tmp      = select_reg.get();
     write_seq = altuvm_avalon_mm_write_seq::type_id::create("write");
     axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");

     if (addr[14:13] == 'b11) begin
      //`uvm_create(write_tran)
      write_tran = svt_axi_master_transaction::type_id::create("write_tran");
      write_tran.port_cfg     = svt_port_cfg;
      write_tran.xact_type    = svt_axi_transaction::WRITE;
      write_tran.addr         = 32'h1002_0100 | {addr[11:0],1'b0};
      write_tran.burst_size   = svt_axi_transaction::BURST_SIZE_32BIT;
      write_tran.atomic_type  = svt_axi_transaction::NORMAL;
      write_tran.burst_length = 1;
      write_tran.burst_type = svt_axi_transaction::FIXED;
      write_tran.data         = new[write_tran.burst_length];
      write_tran.wstrb        = new[write_tran.burst_length];
      write_tran.wvalid_delay = new[write_tran.burst_length];
      write_tran.data[0] = data;
      if(addr[0] == 1)
         write_tran.wstrb[0] = 'b1100;
      else
         write_tran.wstrb[0] = 'b0011;
      //foreach (write_tran.wstrb[index]) 
      //    write_tran.wstrb[index] = ((1 << (1 << write_tran.burst_size)) - 1);
      foreach(write_tran.wstrb[i])
         $display("SMMM: wstrb = %0h", write_tran.wstrb[i]);

      //write_tran.wstrb[0] = {`SVT_AXI_WSTRB_WIDTH{1'b1}};//4'hf;
      axi_mst_seq.start_item(.item(write_tran), .sequencer(virtual_sequencer_inst.axi_mst_seqr));
      axi_mst_seq.finish_item(write_tran);
      axi_mst_seq.get_response(axi_rsp);

       write_seq.set_sequencer( virtual_sequencer_inst.status_seqr );
       write_seq.randomize() with { 
              init_latency inside {[0:3]};
              address   == {addr[11:0],2'b00};
              foreach (byteenable[i]) byteenable[i] == byte_enable[i];
	      writedata[0] == data[7:0];
	      writedata[1] == data[15:8]; 
	      writedata[2] == data[23:16];
	      writedata[3] == data[31:24]; 
           }; 
         write_seq.start(virtual_sequencer_inst.status_seqr);
       if(byte_enable=='h0) begin
        `uvm_info("BYTE_ENABLED", $sformatf("Register(%s) address 'h%0h byte_enable 'h0 ",select_reg.get_name(),addr), UVM_HIGH)
        byte_enable='hf;
       end
       @(negedge mon_if_status.write);
       for (int i=0; i<4; i++) begin
         if (byte_enable[i] == 1'b1) begin
	         data_tmp [(i*8)+:8]=data[(i*8)+:8];
	       end
       end
       end
     if (addr[14:13] == 0) begin
     `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h write data :'h%0h byte_enable=%0b prev_value='h%0h",select_reg.get_name(),addr,data,byte_enable,select_reg.get()), UVM_NONE)
       write_seq.set_sequencer( virtual_sequencer_inst.status_mac_seqr );
       write_seq.randomize() with { 
              init_latency inside {[0:3]};
              address   == {addr[11:0],2'b00};
              foreach (byteenable[i]) byteenable[i] == byte_enable[i];
	      writedata[0] == data[7:0];
	      writedata[1] == data[15:8]; 
	      writedata[2] == data[23:16];
	      writedata[3] == data[31:24]; 
           }; 
         write_seq.start(virtual_sequencer_inst.status_mac_seqr);
       if(byte_enable=='h0) begin
        `uvm_info("BYTE_ENABLED", $sformatf("Register(%s) address 'h%0h byte_enable 'h0 ",select_reg.get_name(),addr), UVM_HIGH)
        byte_enable='hf;
       end
       @(negedge mon_if_mac_status.write);
       for (int i=0; i<4; i++) begin
         if (byte_enable[i] == 1'b1) begin
	          data_tmp [(i*8)+:8]=data[(i*8)+:8];
	       end
       end
       end
     if (addr[14:13] == 'b10) begin
       write_seq.set_sequencer( virtual_sequencer_inst.status_rcfg_seqr );
       write_seq.randomize() with { 
              init_latency inside {[0:3]};
              address   == {addr[11:0],2'b00};
              foreach (byteenable[i]) byteenable[i] == byte_enable[i];
	      writedata[0] == data[7:0];
	      writedata[1] == data[15:8]; 
	      writedata[2] == data[23:16];
	      writedata[3] == data[31:24]; 
           }; 
         write_seq.start(virtual_sequencer_inst.status_rcfg_seqr);
       if(byte_enable=='h0) begin
        `uvm_info("BYTE_ENABLED", $sformatf("Register(%s) address 'h%0h byte_enable 'h0 ",select_reg.get_name(),addr), UVM_HIGH)
        byte_enable='hf;
       end
       @(negedge mon_if_rcfg_status.write);
       for (int i=0; i<4; i++) begin
         if (byte_enable[i] == 1'b1) begin
	         data_tmp [(i*8)+:8]=data[(i*8)+:8];
	        end
       end
       end


       select_reg.predict(.value(data_tmp),.kind(UVM_PREDICT_WRITE), .map(reg_model.default_map));
       `uvm_info("AVMM REG WRITE", $sformatf("Register(%s) address 'h%0h expected write data :'h%0h mirrored_data ='h%0h",select_reg.get_name(),addr,data_tmp, select_reg.get_mirrored_value()), UVM_NONE)
   end
   else
   begin
     `uvm_warning("AVMM REG WRITE", $sformatf("No Register found with address :%0h, write data : %0h it seems reserved space",addr,data));
     axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");
     write_seq = altuvm_avalon_mm_write_seq::type_id::create("write");
     if(addr[14:13] == 'b11) begin
      //`uvm_create(write_tran)
      write_tran = svt_axi_master_transaction::type_id::create("write_tran");
      write_tran.port_cfg     = svt_port_cfg;
      write_tran.xact_type    = svt_axi_transaction::WRITE;
      write_tran.addr         = 32'h1002_0100 | {addr[11:0],1'b0};
      write_tran.burst_size   = svt_axi_transaction::BURST_SIZE_32BIT;
      write_tran.atomic_type  = svt_axi_transaction::NORMAL;
      write_tran.burst_length = 1;
      write_tran.burst_type = svt_axi_transaction::FIXED;
      write_tran.data         = new[write_tran.burst_length];
      write_tran.wstrb        = new[write_tran.burst_length];
      write_tran.wvalid_delay = new[write_tran.burst_length];
      //write_tran.data_user    = new[write_tran.burst_length];
      write_tran.data[0] = data;
      if(addr[0] == 1)
         write_tran.wstrb[0] = 'b1100;
      else
         write_tran.wstrb[0] = 'b0011;
      //foreach (write_tran.wstrb[index]) 
      //    write_tran.wstrb[index] = ((1 << (1 << write_tran.burst_size)) - 1);
      foreach(write_tran.wstrb[i])
         $display("SMMM: wstrb = %0h", write_tran.wstrb[i]);

      //write_tran.wstrb[0] = 4'hf;
      axi_mst_seq.start_item(.item(write_tran), .sequencer(virtual_sequencer_inst.axi_mst_seqr));
      axi_mst_seq.finish_item(write_tran);
      axi_mst_seq.get_response(axi_rsp);

       write_seq.set_sequencer( virtual_sequencer_inst.status_seqr );
       write_seq.randomize() with {
              init_latency inside {[0:3]};
              address   == {addr[11:0],2'b00};
              foreach (byteenable[i]) byteenable[i] == 1;
	      writedata[0] == data[7:0]; 
	      writedata[1] == data[15:8]; 
	      writedata[2] == data[23:16]; 
	      writedata[3] == data[31:24]; 
           }; 
        write_seq.start(virtual_sequencer_inst.status_seqr);
      end     
      if(addr[14:13] == 0) begin
       write_seq.set_sequencer( virtual_sequencer_inst.status_mac_seqr );
       write_seq.randomize() with {
              init_latency inside {[0:3]};
              address   == {addr[11:0],2'b00};
              foreach (byteenable[i]) byteenable[i] == 1;
	      writedata[0] == data[7:0]; 
	      writedata[1] == data[15:8]; 
	      writedata[2] == data[23:16]; 
	      writedata[3] == data[31:24]; 
           }; 
        write_seq.start(virtual_sequencer_inst.status_mac_seqr);
      end     
      if(addr[14:13] == 'b10) begin
       write_seq.set_sequencer( virtual_sequencer_inst.status_rcfg_seqr );
       write_seq.randomize() with {
              init_latency inside {[0:3]};
              address   == {addr[11:0],2'b00};
              foreach (byteenable[i]) byteenable[i] == 1;
	      writedata[0] == data[7:0]; 
	      writedata[1] == data[15:8]; 
	      writedata[2] == data[23:16]; 
	      writedata[3] == data[31:24]; 
           }; 
        write_seq.start(virtual_sequencer_inst.status_rcfg_seqr);
      end




    end
 endtask

//************************************************************************************ 

task eth_env_env::reg_read_axi(input uvm_reg_data_t addr,
                               input uvm_reg_data_t base_addr,
                               ref uvm_reg_data_t read_data,
                               input int num_shift = 2);
   
   svt_axi_master_transaction       read_tran;
   svt_axi_master_transaction       axi_rsp;
   svt_axi_master_base_sequence     axi_mst_seq;
   svt_configuration                get_cfg;
   svt_axi_port_configuration       svt_port_cfg;
   uvm_reg_data_t                   addr_i;

   virtual_sequencer_inst.axi_mst_seqr.get_cfg(get_cfg);
   if (!$cast(svt_port_cfg, get_cfg)) begin
      `uvm_fatal("body", "Unable to $cast the configuration to a svt_axi_port_configuration class");
   end
   axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");
   addr_i |= addr[6:0];

   read_tran = svt_axi_master_transaction::type_id::create("read_tran");
   read_tran.port_cfg     = svt_port_cfg;
   read_tran.xact_type    = svt_axi_transaction::READ;
   read_tran.addr         = base_addr | (addr_i << num_shift);
   read_tran.burst_size   = (num_shift == 1)? svt_axi_transaction::BURST_SIZE_16BIT : svt_axi_transaction::BURST_SIZE_32BIT;
   read_tran.atomic_type  = svt_axi_transaction::NORMAL;
   read_tran.burst_length = 1;
   read_tran.burst_type = svt_axi_transaction::FIXED;
   read_tran.rresp        = new[read_tran.burst_length];
   read_tran.data         = new[read_tran.burst_length];
   read_tran.rready_delay = new[read_tran.burst_length];
   axi_mst_seq.start_item(.item(read_tran), .sequencer(virtual_sequencer_inst.axi_mst_seqr));
   axi_mst_seq.finish_item(read_tran);
   axi_mst_seq.get_response(axi_rsp);
   read_data = {axi_rsp.data[3], axi_rsp.data[2], axi_rsp.data[1], axi_rsp.data[0]};

endtask

//************************************************************************************

task eth_env_env::reg_write_axi(input uvm_reg_data_t addr,
                               input uvm_reg_data_t base_addr,
                               input uvm_reg_data_t w_data,
                               input uvm_reg_byte_en_t byte_enable='hf,
                               input int num_shift = 2);

   svt_axi_master_transaction       write_tran;
   svt_axi_master_transaction       axi_rsp;
   svt_axi_master_base_sequence     axi_mst_seq;
   svt_configuration                get_cfg;
   svt_axi_port_configuration       svt_port_cfg;
   uvm_reg_data_t                   addr_i;

   addr_i |= addr[6:0];
   virtual_sequencer_inst.axi_mst_seqr.get_cfg(get_cfg);
   if (!$cast(svt_port_cfg, get_cfg)) begin
      `uvm_fatal("body", "Unable to $cast the configuration to a svt_axi_port_configuration class");
   end
   axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");

   write_tran = svt_axi_master_transaction::type_id::create("write_tran");
   write_tran.port_cfg     = svt_port_cfg;
   write_tran.xact_type    = svt_axi_transaction::WRITE;
   write_tran.addr         = base_addr | (addr_i << num_shift);
   write_tran.burst_size   = (num_shift == 1)? svt_axi_transaction::BURST_SIZE_16BIT : svt_axi_transaction::BURST_SIZE_32BIT;
   write_tran.atomic_type  = svt_axi_transaction::NORMAL;
   write_tran.burst_length = 1;
   write_tran.burst_type = svt_axi_transaction::FIXED;
   write_tran.data         = new[write_tran.burst_length];
   write_tran.wstrb        = new[write_tran.burst_length];
   write_tran.wvalid_delay = new[write_tran.burst_length];
   write_tran.data[0] = w_data;
   write_tran.wstrb[0] = byte_enable;
   axi_mst_seq.start_item(.item(write_tran), .sequencer(virtual_sequencer_inst.axi_mst_seqr));
   axi_mst_seq.finish_item(write_tran);
   axi_mst_seq.get_response(axi_rsp);

endtask

//************************************************************************************

 //ll_Todo : make disable_check= 0 after RAL updates
 task eth_env_env::reg_read(uvm_reg_data_t addr,ref uvm_reg_data_t read_data,input bit[1:0] disable_check=0,uvm_reg_byte_en_t byte_enable='hf,bit[31:0]data_expected=0);
   uvm_status_e      status;
   uvm_reg 	regs[$];
   uvm_reg 	select_reg;
   altuvm_avalon_mm_read_seq           read_seq;
   bit [31:0] rsvd_val = 'd0;
   int masked_val;
   bit[31:0] byte_en_mask;
   uvm_reg_data_t mir_data;
   svt_axi_master_transaction       read_tran;
   svt_axi_master_transaction       axi_rsp;
   svt_axi_master_base_sequence     axi_mst_seq;
   svt_configuration                get_cfg;
   svt_axi_port_configuration       svt_port_cfg;

   select_reg = reg_model.default_map.get_reg_by_offset(addr);
   
   virtual_sequencer_inst.axi_mst_seqr.get_cfg(get_cfg);
   if (!$cast(svt_port_cfg, get_cfg)) begin
      `uvm_fatal("body", "Unable to $cast the configuration to a svt_axi_port_configuration class");
   end

    // if ((select_reg != null) && (byte_enable == 'hf))
	if( select_reg != null) begin
        $display("INFO->Checking after read task call");
        
        mir_data = select_reg.get_mirrored_value();
        
        axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");
        read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
        if(addr[14:13] == 'b11) begin
           $display("Reading PHY:");
          //`uvm_create(read_tran)
          read_tran = svt_axi_master_transaction::type_id::create("read_tran");
          read_tran.port_cfg     = svt_port_cfg;
          read_tran.xact_type    = svt_axi_transaction::READ;
          read_tran.addr         = 32'h1002_0100 | {addr[11:0], 1'b0};
          read_tran.burst_size   = svt_axi_transaction::BURST_SIZE_32BIT;
          read_tran.atomic_type  = svt_axi_transaction::NORMAL;
          read_tran.burst_length = 1;
          read_tran.burst_type = svt_axi_transaction::FIXED;
          read_tran.rresp        = new[read_tran.burst_length];
          read_tran.data         = new[read_tran.burst_length];
          read_tran.rready_delay = new[read_tran.burst_length];
          //read_tran.data_user    = new[read_tran.burst_length];
          axi_mst_seq.start_item(.item(read_tran), .sequencer(virtual_sequencer_inst.axi_mst_seqr));
          axi_mst_seq.finish_item(read_tran);
          axi_mst_seq.get_response(axi_rsp);

          read_seq.set_sequencer( virtual_sequencer_inst.status_seqr );
          read_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == {addr[11:0], 2'b00};
                foreach (byteenable[i]) byteenable[i] == byte_enable[i];
             }; 

          `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable '%p,mir_data:%0h ",select_reg.get_name(),addr,byte_enable,mir_data), UVM_NONE)
          read_seq.start(virtual_sequencer_inst.status_seqr);
        end
        if(addr[14:13] == 0) begin
          read_seq.set_sequencer( virtual_sequencer_inst.status_mac_seqr );
          read_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == {addr[11:0], 2'b00};
                foreach (byteenable[i]) byteenable[i] == byte_enable[i];
             }; 

          `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable '%p,mir_data:%0h ",select_reg.get_name(),addr,byte_enable,mir_data), UVM_NONE)
          read_seq.start(virtual_sequencer_inst.status_mac_seqr);
        end
        if(addr[14:13] == 'b10) begin
          read_seq.set_sequencer( virtual_sequencer_inst.status_rcfg_seqr );
          read_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == {addr[11:0], 2'b00};
                foreach (byteenable[i]) byteenable[i] == byte_enable[i];
             }; 

          `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable '%p,mir_data:%0h ",select_reg.get_name(),addr,byte_enable,mir_data), UVM_NONE)
          read_seq.start(virtual_sequencer_inst.status_rcfg_seqr);
        end
        
       if(addr[14:13] == 'b11) begin
         read_data = {axi_rsp.data[3], axi_rsp.data[2], axi_rsp.data[1], axi_rsp.data[0]};
         if(addr[0] == 1)
            read_data = read_data >> 16;
         $display("SMMM: read_data = %0h", read_data);
       end
       else begin
         read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
       end
        
        if(byte_enable=='h0) begin
          `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable 'h0 ",select_reg.get_name(),addr), UVM_NONE)
          byte_enable='hf;
        end

        for(int i=0;i<4;i++) byte_en_mask[((8*(i+1))-1) -: 8] = byte_enable[i]?'hff:'h0;
        mir_data = mir_data & byte_en_mask ;

        //Coverage sample only for stat registers
        if(addr inside {['h800:'h835],['h860:'h863],['h900:'h935],['h960:'h963]})
          select_reg.sample_values();

        // disable_check is 2 bit variable for read comparision where 0=normal_check; 1=disable_check; 2=WO masked check; 3=both WO & RO masked check
        if(disable_check == 0)begin
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register(%s) address 'h%0h expected data : 'h%0h actual read data :'h%0h ",select_reg.get_name(),addr,mir_data,read_data), UVM_NONE)
          if(mir_data != read_data)
          `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else if(disable_check == 2)begin
          masked_val=set_masked_val(addr,0);
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED & WO MASK enabled] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h masked_val : 'h%0h",select_reg.get_name(),addr,read_data,mir_data,masked_val), UVM_NONE)
          //GDR : if(addr inside {['h128:'h13C]}) begin
          //GDR :      // updated by atiwari2, added range of +/-32 , as clk mon need
          //GDR :      // some time to stablize, here to shortedn the sim time we have
          //GDR :      // taken the  range
          //GDR :     if(!((mir_data & masked_val) inside {[(read_data -'d32):(read_data + 'd32)]}))
          //GDR :         `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
          //GDR : end else 
          if((mir_data & masked_val) != read_data)
            `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else if(disable_check == 3)begin
          masked_val=set_masked_val(addr,2);
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED & b/WO/RO MASK enabled] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h masked_val : 'h%0h",select_reg.get_name(),addr,read_data,mir_data,masked_val), UVM_NONE)
          if((mir_data & masked_val) != (read_data & masked_val))
            `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else begin
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] Register(%s) address 'h%0h actual read data :'h%0h",select_reg.get_name(),addr,read_data), UVM_NONE)
        end
    end
   else //select_reg == null
    begin
        $display("INFO-> Register not present in RAL Checking INSIDE selcet_reg is null read env task Attributes");
       `uvm_warning("AVMM REG READ", $sformatf("No Register found with address :%0h,it seems reserved space",addr));
       axi_mst_seq = svt_axi_master_base_sequence::type_id::create("axi_mst_seq");
       read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
        if(addr[14:13] == 'b11) begin
           $display("Reading PHY1:");
          //`uvm_create(read_tran)
          read_tran = svt_axi_master_transaction::type_id::create("read_tran");
          read_tran.port_cfg     = svt_port_cfg;
          read_tran.xact_type    = svt_axi_transaction::READ;
          read_tran.addr         = 32'h1002_0100 | {addr[11:0], 1'b0};
          read_tran.burst_size   = svt_axi_transaction::BURST_SIZE_32BIT;
          read_tran.atomic_type  = svt_axi_transaction::NORMAL;
          read_tran.burst_length = 1;
          read_tran.burst_type = svt_axi_transaction::FIXED;
          read_tran.rresp        = new[read_tran.burst_length];
          read_tran.data         = new[read_tran.burst_length];
          read_tran.rready_delay = new[read_tran.burst_length];
          //read_tran.data_user    = new[read_tran.burst_length];
          axi_mst_seq.start_item(.item(read_tran), .sequencer(virtual_sequencer_inst.axi_mst_seqr));
          axi_mst_seq.finish_item(read_tran);
          axi_mst_seq.get_response(axi_rsp);

          read_seq.set_sequencer( virtual_sequencer_inst.status_seqr );
          read_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == {addr[11:0], 2'b00};
                foreach (byteenable[i]) byteenable[i] == byte_enable[i];
             }; 

          `uvm_info("AVMM REG READ", $sformatf("Register address 'h%0h byte_enable '%p ",addr,byte_enable), UVM_NONE)
          read_seq.start(virtual_sequencer_inst.status_seqr);
        end
        if(addr[14:13] == 0) begin
          read_seq.set_sequencer( virtual_sequencer_inst.status_mac_seqr );
          read_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == {addr[11:0], 2'b00};
                foreach (byteenable[i]) byteenable[i] == byte_enable[i];
             }; 
          `uvm_info("AVMM REG READ", $sformatf("Register address 'h%0h byte_enable '%p ",addr,byte_enable), UVM_NONE)

          read_seq.start(virtual_sequencer_inst.status_mac_seqr);
        end
        if(addr[14:13] == 'b10) begin
          read_seq.set_sequencer( virtual_sequencer_inst.status_rcfg_seqr );
          read_seq.randomize() with {
                init_latency inside {[0:3]};
                address   == {addr[11:0], 2'b00};
                foreach (byteenable[i]) byteenable[i] == byte_enable[i];
             }; 

          `uvm_info("AVMM REG READ", $sformatf("Register address 'h%0h byte_enable '%p ",addr,byte_enable), UVM_NONE)

          read_seq.start(virtual_sequencer_inst.status_rcfg_seqr);
        end
       
       if(addr[14:13] == 'b11) begin
         read_data = {axi_rsp.data[3], axi_rsp.data[2], axi_rsp.data[1], axi_rsp.data[0]};
         if(addr[0] == 1)
            read_data = read_data >> 16;
         $display("SMMM: read_data = %0h", read_data);
       end
       else begin
         read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
       end
        $display("INFO->Checking read_data_value=%0h,addr=%0h,data_expected=%0h",read_data,addr,data_expected);

       // Read data of the reserved register is supposed to 0 in GDR.
       if(disable_check == 0) begin
          rsvd_val = data_expected;
          if(rsvd_val != read_data)
            `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val))
          else 
            `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val), UVM_NONE)
       end
    end
 endtask

//************************************************************************************ 

task eth_env_env::reg_read_in_between(uvm_reg_data_t addr,
                                      ref uvm_reg_data_t read_data,
                                      input bit[1:0] disable_check=0,
                                      uvm_reg_byte_en_t byte_enable='hf,
                                      bit[31:0]data_expected=0);

   uvm_status_e      status;
   uvm_reg 	         regs[$];
   uvm_reg 	         select_reg;
   altuvm_avalon_mm_read_seq  read_seq;
   bit [31:0]        rsvd_val = 'd0;
   int               masked_val;
   bit[31:0]         byte_en_mask;
   uvm_reg_data_t    mir_data;
   
   select_reg = reg_model.default_map.get_reg_by_offset(addr);

	if( select_reg != null) begin
      $display("INFO->Checking after read task call");
      mir_data = select_reg.get_mirrored_value();
      read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
      read_seq.set_sequencer( virtual_sequencer_inst.status_seqr );
      read_seq.randomize() with {
              init_latency inside {[0:3]};
              address   == {addr, 2'b00};
              foreach (byteenable[i]) byteenable[i] == byte_enable[i];
      }; 

      `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable '%p,mir_data:%0h ",select_reg.get_name(),addr,byte_enable,mir_data), UVM_NONE)
      read_seq.start(virtual_sequencer_inst.status_seqr);
      read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
        
      if(byte_enable=='h0) begin
         `uvm_info("AVMM REG READ", $sformatf("Register(%s) address 'h%0h byte_enable 'h0 ",select_reg.get_name(),addr), UVM_NONE)
         byte_enable='hf;
      end

      for(int i=0;i<4;i++) byte_en_mask[((8*(i+1))-1) -: 8] = byte_enable[i]?'hff:'h0;
      mir_data = mir_data & byte_en_mask ;

      //Coverage sample only for stat registers
      if(addr inside {['h800:'h835],['h860:'h863],['h900:'h935],['h960:'h963]})
         select_reg.sample_values();

        // disable_check is 2 bit variable for read comparision where 0=normal_check; 1=disable_check; 2=WO masked check; 3=both WO & RO masked check
        if(disable_check == 0)begin
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register(%s) address 'h%0h expected data : 'h%0h actual read data :'h%0h ",select_reg.get_name(),addr,mir_data,read_data), UVM_NONE)
          if(mir_data > read_data)
          `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else if(disable_check == 2)begin
          masked_val=set_masked_val(addr,0);
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED & WO MASK enabled] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h masked_val : 'h%0h",select_reg.get_name(),addr,read_data,mir_data,masked_val), UVM_NONE)
          //GDR : if(addr inside {['h128:'h13C]}) begin
          //GDR :      // updated by atiwari2, added range of +/-32 , as clk mon need
          //GDR :      // some time to stablize, here to shortedn the sim time we have
          //GDR :      // taken the  range
          //GDR :     if(!((mir_data & masked_val) inside {[(read_data -'d32):(read_data + 'd32)]}))
          //GDR :         `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
          //GDR : end else 
          if((mir_data & masked_val) != read_data)
            `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else if(disable_check == 3)begin
          masked_val=set_masked_val(addr,2);
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED & b/WO/RO MASK enabled] Register(%s) address 'h%0h actual read data :'h%0h expected read data :'h%0h masked_val : 'h%0h",select_reg.get_name(),addr,read_data,mir_data,masked_val), UVM_NONE)
          if((mir_data & masked_val) != (read_data & masked_val))
            `uvm_error("AVMM REG READ", $sformatf("Register(%s) read data mismatch for address %h",select_reg.get_name(),addr));
        end
        else begin
          `uvm_info("AVMM REG READ", $sformatf("[COMPARISON DISABLED] Register(%s) address 'h%0h actual read data :'h%0h",select_reg.get_name(),addr,read_data), UVM_NONE)
        end
    end
   else //select_reg == null
    begin
        $display("INFO-> Register not present in RAL Checking INSIDE selcet_reg is null read env task Attributes");
       `uvm_warning("AVMM REG READ", $sformatf("No Register found with address :%0h,it seems reserved space",addr));
       read_seq  = altuvm_avalon_mm_read_seq::type_id::create("read");
       read_seq.set_sequencer( virtual_sequencer_inst.status_seqr );
       read_seq.randomize() with {
             init_latency inside {[0:3]};
             address   =={ addr,2'b00};
             foreach (byteenable[i]) byteenable[i] == 1;
          }; 
       read_seq.start(virtual_sequencer_inst.status_seqr);
  
       read_data = {read_seq.readdata[3],read_seq.readdata[2],read_seq.readdata[1],read_seq.readdata[0]};
        $display("INFO->Checking read_data_value=%0h,addr=%0h,data_expected=%0h",read_data,addr,data_expected);

       // Read data of the reserved register is supposed to 0 in GDR.
       if(disable_check == 0) begin
          rsvd_val = data_expected;
          if(rsvd_val != read_data)
            `uvm_error("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val))
          else 
            `uvm_info("AVMM REG READ", $sformatf("[COMPARISON ENABLED] Register address 'h%0h actual read data :'h%0h expected read data :%0h",addr,read_data,rsvd_val), UVM_NONE)
       end
    end
endtask

//************************************************************************************ 
task eth_env_env::read_and_compare_stats(input bit disable_check=0);
   #2000ns;
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_dropped_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,(disable_check||dis_ehip_drop_frame_cntr));
   //ll_TODO: reg_read(`ETH_F_ALL_rxmac_adapt_dropped_31_0_OFFSET_REG,read_data,disable_check);
   //ll_TODO: reg_read(`ETH_F_ALL_rxmac_adapt_dropped_63_32_OFFSET_REG,read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_malformed_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_badlt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_lenerr_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);

   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fragments_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_fcs_err_okpkt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_64b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_65to127b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_128to255b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_256to511b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_512to1023b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1024to1518b_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_1519tomaxb_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_oversize_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_data_ok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_mcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_bcast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_ucast_ctrl_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pause_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_runt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_payloadoctetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_octetsok_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_dropped_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_malformed_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_err_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_pfc_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_badlt_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   //ll_TODO: reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_lenerr_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_lo_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_st_hi_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(rx_stats_framesOK0_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(rx_stats_framesOK1_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(rx_stats_framesErr0_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);
   reg_read(`GET_REG_ADDR(rx_stats_framesErr1_OFFSET_REG,dyn_rcfg_obj_inst.speed),read_data,disable_check);

endtask : read_and_compare_stats

//************************************************************************************ 

function void eth_env_env::disable_all_snps_errors();
   string func_name = "disable_all_snps_errors";

   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.set_default_fail_effect_all_checks(svt_err_check_stats::NOTE);
   `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.set_default_fail_effect_all_checks(svt_err_check_stats::NOTE);
   if (dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
      m_snps_flexe_otn_agent.monitor.err_check_tx.set_default_fail_effect_all_checks(svt_err_check_stats::NOTE);
      m_snps_flexe_otn_agent.monitor.err_check_rx.set_default_fail_effect_all_checks(svt_err_check_stats::NOTE);
   end
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction // disable_all_snps_errors

//************************************************************************************

function void eth_env_env::enable_all_snps_errors();
   string func_name = "enable_all_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.set_default_fail_effect_all_checks(svt_err_check_stats::ERROR);
   `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.set_default_fail_effect_all_checks(svt_err_check_stats::ERROR);
   if (dyn_rcfg_obj_inst.mode inside {OTN,FLEXE}) begin
      m_snps_flexe_otn_agent.monitor.err_check_tx.set_default_fail_effect_all_checks(svt_err_check_stats::ERROR);
      m_snps_flexe_otn_agent.monitor.err_check_rx.set_default_fail_effect_all_checks(svt_err_check_stats::ERROR);
   end
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction // enable_all_snps_errors

//************************************************************************************

function void eth_env_env::disable_snps_errors(string ERR_TYPE = "ALL");
   string func_name = "disable_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   
   // FIXME: for different speeds in GDR
   //and also if particular snps error are required to be disabled.use extra code using ERR_TYPE
   
   if( ERR_TYPE== "ALL") begin
     
     if(dyn_rcfg_obj_inst.speed inside{_40G,_50G,_100G}) begin
       `uvm_info(get_type_name(), $sformatf("%s: Disabling 100G snps errors",func_name), UVM_LOW)
       //TX
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);   
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_seq_char_not_followed_by_zeroes_in_lane_4_to_7.set_default_fail_effect(svt_err_check_stats::IGNORE);
       //m_snps_eth_pcs66_agent.monitor.err_check_tx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::NOTE); // RAMI - newly added for 100G NoFEC->FEC bringup
       
       //RX
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::NOTE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);   
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
       
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); //Seen for eth_reset_during_dr_test in PERT 3510963 - RAMI
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);//{modified}
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::IGNORE);//Demote Error
       //pbenittx
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_am_order_within_transcode_block.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_tbd.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); 
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_multilane_high_ber.set_default_fail_effect(svt_err_check_stats::IGNORE);
       //if (dyn_rcfg_obj_inst.fec_type == 1) begin 
       //RX
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
       //TX
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup {muralasx}
       //end
       
       if (dyn_rcfg_obj_inst.mode == OTN) begin
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xlsbi_invalid_bip.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
       end
      end // if(dyn_rcfg_obj_inst.speed ==_100G)

     else if(dyn_rcfg_obj_inst.speed inside {_10G,_25G}) begin
         
          `uvm_info(get_type_name(), $sformatf("%s: Disabling 10G_25G snps errors",func_name), UVM_LOW)   
          //RX
	  if (dyn_rcfg_obj_inst.fec_type == FCFEC) begin
	    `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_fec_cl74_invalid_parity.set_default_fail_effect(svt_err_check_stats::IGNORE); 
            `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_fec_cl74_block_lock_lost.set_default_fail_effect(svt_err_check_stats::IGNORE);
          end
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); 

          //TX
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          

          if (dyn_rcfg_obj_inst.fec_type == RSFECKR || dyn_rcfg_obj_inst.fec_type == RSFECKP ) begin 
             //RX
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_invalid_bit_in_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);//{modified}
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);   
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup
             //TX
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::IGNORE);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);   
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup 
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE); // RAMI - newly added for 100G FEC bringup
          end
      end  //if (dyn_rcfg_obj_inst.speed inside {_10G,_25G})
      else if(dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       `uvm_info(get_type_name(), $sformatf("%s: Disabling 200G/400G snps errors",func_name), UVM_LOW)
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_invalid_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);
      end  //if (dyn_rcfg_obj_inst.speed inside {_200G,_400G})

      if(dyn_rcfg_obj_inst.mode == OTN || dyn_rcfg_obj_inst.mode == FLEXE) begin
	 `uvm_info(get_type_name(), $sformatf("%s: Disabling m_snps_flexe_otn_agent checks temporarily",func_name), UVM_LOW)   
          //RX
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          //TX
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);	   
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_mac_rsvrd_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::IGNORE);
          m_snps_flexe_otn_agent.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
     
      end
    end // if(ERR_TYPE=ALL)
   else if( ERR_TYPE== "MID_SIM_RST")
    begin
     `uvm_info(get_type_name(), $sformatf("%s: Disabling MID_SIM_RST snps errors",func_name), UVM_LOW)
     `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::IGNORE);
     `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::IGNORE);
     `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::IGNORE);
     `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::IGNORE);
     `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    end
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction // disable_snps_errors

//************************************************************************************

function void eth_env_env::enable_snps_errors(string ERR_TYPE = "ALL");
   string func_name = "enable_snps_errors";
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_LOW)
   
   if(ERR_TYPE == "ALL") begin
      if (dyn_rcfg_obj_inst.speed == _100G || dyn_rcfg_obj_inst.speed==_40G) begin
         `uvm_info(get_type_name(), $sformatf("%s: Enabling 100G snps errors",func_name), UVM_LOW)
         //TX
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_am_not_found.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_seq_char_not_followed_by_zeroes_in_lane_4_to_7.set_default_fail_effect(svt_err_check_stats::ERROR);
        //RX
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_frame_pattern_ffff0000.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs_last_2bit.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_autoadaptation_invalid_prbs.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_sfd_content.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_preamble_count.set_default_fail_effect(svt_err_check_stats::ERROR);
        
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_term_c_char_found.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_no_am_rcvd_at_am_boundary.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_term_c_char_not_followed_by_idle_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_start_c_char_after_start_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR); 
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_multilane_high_ber.set_default_fail_effect(svt_err_check_stats::ERROR);
        //if (dyn_rcfg_obj_ins.eth_agent[0]t.fec_type == 1) begin 
        //RX
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
        //TX
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_rs_fec_invalid_first_5bits_of_control_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_rsvrd_seq_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR); // RAMI - newly added for 100G FEC bringup   {muralasx}
        //end
        if (dyn_rcfg_obj_inst.mode == OTN) begin 
           `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_csbi_invalid_bip_rcvd.set_default_fail_effect(svt_err_check_stats::ERROR);
           `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        end
      end // if(dyn_rcfg_obj_inst.speed ==_100G)

      else if ((dyn_rcfg_obj_inst.speed == _25G) || (dyn_rcfg_obj_inst.speed ==_10G)) begin
         
          `uvm_info(get_type_name(), $sformatf("%s: Enabling 10G_25G snps_errors",func_name), UVM_LOW)   
          //RX
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);	   
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_no_start_c_char_before_term_c_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xsbi_signal_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);  
          //TX
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_sync_header.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_type_field.set_default_fail_effect(svt_err_check_stats::ERROR);	   
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_reserved_field.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_xsbi_err_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_invalid_block_with_ordered_set.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
          `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xsbi_reserved_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);

          if (dyn_rcfg_obj_inst.fec_type == RSFECKR || dyn_rcfg_obj_inst.fec_type == RSFECKP ) begin 
             //RX
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_invalid_bit_in_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
             //TX
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_btf.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_second_align_marker.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xxvsbi_lsbi_invalid_first_five_bit_of_transcode.set_default_fail_effect(svt_err_check_stats::ERROR);
             `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
          end
      end //if(dyn_rcfg_obj_inst.speed ==_10G || dyn_rcfg_obj_inst.speed ==_25G)
      else if(dyn_rcfg_obj_inst.speed inside {_200G,_400G}) begin
       `uvm_info(get_type_name(), $sformatf("%s: Enabling 200G/400G snps errors",func_name), UVM_LOW)
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_after_terminate.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_before_str.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
        `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_400g_pcs_invalid_checksum.set_default_fail_effect(svt_err_check_stats::ERROR);
      end  //if (dyn_rcfg_obj_inst.speed inside {_200G,_400G})
    end //if(ERR_TYPE==ALL)
   else if(ERR_TYPE == "MID_SIM_RST") begin
      
       `uvm_info(get_type_name(), $sformatf("%s: enabling MID_SIM_RST snps_errors",func_name), UVM_LOW)
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_within_data.set_default_fail_effect(svt_err_check_stats::ERROR);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_error_control_char.set_default_fail_effect(svt_err_check_stats::ERROR);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_control_char_in_frame_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_xgmii_error_c_char_not_allowed.set_default_fail_effect(svt_err_check_stats::ERROR);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_between_idle.set_default_fail_effect(svt_err_check_stats::ERROR);
       `M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_baser_cl82_unexpected_block_error_after_error.set_default_fail_effect(svt_err_check_stats::ERROR);
    end
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_LOW)
endfunction // enable_snps_errors


//************************************************************************************
// Function : eth_ref_model_inst 
// This method will update RAL reset valuse as per DUT parameter
function void eth_env_env::update_ral_reset_value();
 
endfunction : update_ral_reset_value

//************************************************************************************
 //dsamantx:Task added for checking frames as well as seq/test both can use single task & also supported for loopback
task eth_env_env::wait_mac_tx_frames_done(int exp_num, time timeout_time=200us);
   string func_name = "wait_mac_tx_frames_done";
   bit    condition_met;
   int  act_pkt_cnt;
      
   `uvm_info(get_type_name(), $sformatf("%s: Waiting for %0d transmitted by AVST",func_name,exp_num), UVM_NONE);
   condition_met = 1'b0;
   fork
      begin 
         while(condition_met!=1'b1) begin
            if(loopback_enable == 0) begin		 
	            if((sb_mac_tx_vip_rx.tx_pkt_cnt)<exp_num) begin
	               #10ns;
	            end
               else begin
	               condition_met=1'b1;
	               `uvm_info(get_type_name(), $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
	            end
	         end
            else begin
	  	         if (sb_loopbk.tx_pkt_cnt<exp_num) begin
	 	            #10ns;
	  	         end 
               else begin
		            condition_met=1'b1;
	               `uvm_info(get_type_name(), $sformatf("%s: %0d frames transmitted by AVST",func_name,exp_num), UVM_NONE);
		         end
            end
	      end
	   end

      begin 
	      #(timeout_time); 
         if(loopback_enable == 0) begin
	         act_pkt_cnt = (sb_mac_tx_vip_rx.tx_pkt_cnt) ;
         end 
         else begin
	         act_pkt_cnt = sb_loopbk.tx_pkt_cnt; 
	      end 
          
	      `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for %0d transmitted by AVST. Waited %0t.transmitted packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
	   end
    join_any
    disable fork;
endtask // wait_mac_tx_frames_done

//************************************************************************************

task eth_env_env::wait_tx_frames_received(int exp_num, 
                                          time timeout_time=200us, 
                                          bit include_fc_pkt=0);

   string func_name = "wait_tx_frames_received";
   bit    condition_met;
   int  act_pkt_cnt; 
   int total_pkt_cnt;
 
   `uvm_info(get_type_name(), $sformatf("%s: Waiting for %0d frames received by VIP",func_name,exp_num), UVM_NONE)
   condition_met = 1'b0;
   fork
      begin 
    	   while(condition_met!=1'b1) begin
	         if(loopback_enable == 0) begin		 
               total_pkt_cnt = ((include_fc_pkt == 1'b1) ? 
                              (sb_mac_tx_vip_rx.rx_pkt_cnt + sb_mac_tx_vip_rx.fc_rx_pkt_cnt) : 
                              sb_mac_tx_vip_rx.rx_pkt_cnt);
               if((total_pkt_cnt)<exp_num) begin
       	         #10ns;
	            end 
               else begin
      	         condition_met=1'b1;
      	         `uvm_info(get_type_name(), $sformatf("%s: %0d frames received by VIP",func_name,exp_num), UVM_NONE)
	            end
            end 
            else begin
               if(sb_loopbk.rx_pkt_cnt<exp_num) begin
                  #10ns;
               end 
               else begin
      	         condition_met=1'b1;
      	         `uvm_info(get_type_name(), $sformatf("%s: %0d frames received by VIP",func_name,exp_num), UVM_NONE)
	            end
            end
         end
      end

      begin 
         #(timeout_time); 
	      if(loopback_enable == 0) begin		 
	         act_pkt_cnt = total_pkt_cnt; 
	      end 
         else begin
	         act_pkt_cnt = sb_loopbk.rx_pkt_cnt; 
	      end
         `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for %0d frames received by VIP. Waited %0t. received packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
      end
   join_any
   disable fork;
endtask

//************************************************************************************   

task eth_env_env::wait_vip_tx_frames_done(int exp_num, time timeout_time=200us);
   string func_name = "wait_vip_tx_frames_done";
   bit    condition_met;
   int  act_pkt_cnt;
      
   `uvm_info(get_type_name(), $sformatf("%s: Waiting for %0d transmitted by VIP",func_name,exp_num), UVM_NONE);
   condition_met = 1'b0;

   fork
      begin 
         while (condition_met!=1'b1) begin
  	         if (eth_ref_model_inst.vip_tx_count<exp_num) begin
  		         #10ns;
  	         end
  	         else begin 
  	            condition_met=1'b1;
  	            `uvm_info(get_type_name(), $sformatf("%s: %0d frames transmitted by VIP",func_name,exp_num), UVM_NONE)
  	         end
         end
      end

      begin 
         #(timeout_time); 
      	`uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for %0d transmitted by VIP. Waited %0t.",
            func_name,exp_num,timeout_time));
      end
   join_any
   disable fork;
endtask // wait_vip_tx_frames_done

//************************************************************************************

task eth_env_env::wait_client_rx_frames_done(int exp_num, 
                                             time timeout_time=200us, 
                                             bit include_fc_pkt = 0);

   string func_name = "wait_rx_frames_received";
   bit    condition_met;
   int  act_pkt_cnt;
   int total_pck_cnt;

   `uvm_info(get_type_name(), $sformatf("%s: Waiting for %0d frames received by AVST",func_name,exp_num), UVM_NONE)
   condition_met = 1'b0;
       
   fork
      begin 
         while(condition_met!=1'b1) begin
            total_pck_cnt = (include_fc_pkt == 1) ? (sb_vip_tx_mac_rx.rx_pkt_cnt + sb_vip_tx_mac_rx.fc_rx_pkt_cnt): 
                            sb_vip_tx_mac_rx.rx_pkt_cnt;
	         if((total_pck_cnt)<exp_num) begin
               `uvm_info(get_type_name(), $sformatf("%s: %0d total frames received by AVST",
                  func_name,total_pck_cnt), UVM_NONE)
		         #10ns;
	         end
	         else begin 
		         condition_met=1'b1;
               `uvm_info(get_type_name(), $sformatf("%s: %0d total frames received by AVST",
                  func_name,total_pck_cnt), UVM_NONE)
		         `uvm_info(get_type_name(), $sformatf("%s: %0d frames received by AVST",func_name,exp_num), UVM_NONE)
            end
         end
      end

      begin 
         #(timeout_time); 
	      act_pkt_cnt = (total_pck_cnt); 
	      `uvm_error(get_type_name(), $sformatf("%s: Timeout waiting for %0d frames received by AVST. Waited %0t.received packet count %d",func_name,exp_num,timeout_time,act_pkt_cnt));
      end
    join_any
    disable fork; 
endtask // wait_client_rx_frames_done

//************************************************************************************  

task eth_env_env::wait_for_linkup(bit tx_sync=0,
                                  bit rx_sync=0,
                                  bit ip_sync=1, 
                                  bit disable_vip_err=0);

   string func_name = "wait_for_linkup";
   uvm_reg_data_t read_data;
   uvm_status_e      status;
   bit crc_cover_preamble;
   bit an_en=0;
   bit [1:0] disable_check = 1;
   bit [31:0] exp_an_status = 32'h0;
   bit [2:0] speed_sel;
   bit [2:0] an_speed;
   uvm_reg_data_t data_read;
   bit [31:0] nf_control_reg_1G;
   bit [31:0] data_read_1, control_data, speed_variant;
   uvm_reg_data_t ifmode_read;
   
   `uvm_info(get_type_name(), $sformatf("%s: BEGIN",func_name), UVM_NONE);
   `uvm_info(get_type_name(), $sformatf("%s: Wait for link up... tx_sync=%0d rx_sync=%0d ip_sync=%0d",
      func_name,tx_sync,rx_sync,ip_sync), UVM_MEDIUM);

   //Disable VIP errors during linkup
   if(rx_sync == 1) begin 
      disable_snps_errors("MID_SIM_RST");
   end
   if(ip_sync == 1) begin
      disable_snps_errors();
   end

   `uvm_info("wait_for_linkup","Configuring CSRs for MGBASET speed variants",UVM_NONE);

   if(dyn_rcfg_obj_inst.ll_speed == _10G)
      speed_variant = 2'b11;
   else if(dyn_rcfg_obj_inst.ll_speed == _5G)	
      speed_variant = 2'b10; //5G   
   else if(dyn_rcfg_obj_inst.ll_speed == _2p5G)	
      speed_variant = 2'b01; //2.5G   
   else begin	
      speed_variant = 2'b00; //1G or 100M or 10M
      reg_read(gdr_ral_offset("if_mode"),ifmode_read);
      `uvm_info("wait_for_linkup", $sformatf("if_mode register read value is  :'h%0h",ifmode_read), UVM_NONE);

      if(dyn_rcfg_obj_inst.ll_speed == _1G)
         ifmode_read = {12'b0,2'b10,1'b0,1'b1};
      else if(dyn_rcfg_obj_inst.ll_speed == _100M)
         ifmode_read = {12'b0,2'b01,1'b0,1'b1};
      else if(dyn_rcfg_obj_inst.ll_speed == _10M)
         ifmode_read = {12'b0,2'b00,1'b0,1'b1};
      else
         $display("\nIncorrect MGBASET Speed");
        
      `uvm_info("wait_for_linkup", $sformatf("if_mode register write value is  :'h%0h",ifmode_read), UVM_NONE);
      reg_write(gdr_ral_offset("if_mode"),ifmode_read);
   end
 
   `uvm_info("wait_for_linkup", $sformatf("speed_variant is  :'h%0h",speed_variant), UVM_NONE);
   data_read={15'b0,1'b1,14'b0,speed_variant};
   data_read[16]=1'b1;
   `uvm_info("wait_for_linkup", $sformatf("control register write value is  :'h%0h",data_read), UVM_NONE);

   if(dyn_rcfg_obj_inst.ll_var == _NF1G && dyn_rcfg_obj_inst.ll_speed == _1G)begin
      nf_control_reg_1G=32'h0000_0000;
      reg_write(gdr_ral_offset("control"),nf_control_reg_1G);
      `uvm_info("wait_for_linkup", $sformatf("control register write value is  :'h%0h",nf_control_reg_1G), UVM_NONE);
   end

   if(dyn_rcfg_obj_inst.ll_speed == _1G && dyn_rcfg_obj_inst.ll_var == _MGE) begin
      `uvm_info("linkup task", $sformatf("ll_speed is: %0s",dyn_rcfg_obj_inst.ll_speed), UVM_NONE);
      `uvm_info("linkup task", $sformatf("ll_var is: %0s",dyn_rcfg_obj_inst.ll_var), UVM_NONE);
      #20us;
   end
   else begin
      `uvm_info("linkup task", $sformatf("ll_speed is: %0s",dyn_rcfg_obj_inst.ll_speed), UVM_NONE);
      `uvm_info("linkup task", $sformatf("ll_var is: %0s",dyn_rcfg_obj_inst.ll_var), UVM_NONE);
      fork
         begin
            fork 
               begin
                  `uvm_info(get_type_name(), $sformatf("Waiting for Tx PMA ready to go high"), UVM_NONE);
                  wait(sideband_if.tx_lane_stable==1);
                  `uvm_info(get_type_name(), $sformatf("Done waiting for Tx PMA ready to go high"), UVM_NONE);
                  `uvm_info(get_type_name(), $sformatf("Waiting for Rx PMA ready to go high"), UVM_NONE);
                  wait(spy_if.rx_pcs_ready == 1'b1);
                  `uvm_info(get_type_name(), $sformatf("Done waiting Tx/Rx PMA Ready signals to go high"), UVM_NONE);
                  #55us; 
                  //TODO : rX Link is not up becuase of internal PFE reset , adding 55us delay to avoid reset condition 
                  #30us;
                  reg_read(16'h600B,read_data,disable_check);
                  `uvm_info("wait_for_linkup", $sformatf("data register read value is  :'h%0h",read_data), UVM_NONE);
                  read_data = {32'h0};
                  `uvm_info("wait_for_linkup", $sformatf("data register read value is  :'h%0h",read_data), UVM_NONE);
                  reg_write(16'h600B,read_data,disable_check);
                  `uvm_info("wait_for_linkup", $sformatf("data register read value is  :'h%0h",read_data), UVM_NONE);
                  reg_read(16'h600B,read_data,disable_check);
                  `uvm_info("wait_for_linkup", $sformatf("data register read value is  :'h%0h",read_data), UVM_NONE);
               end

               begin
                  if(loopback_enable==0) begin
                     `uvm_info(get_type_name(), $psprintf("wait vip rx link down"), UVM_NONE)
		               wait( reset_if.mac_rx_rst_ack_n == 1 && reset_if.mac_rx_rst_n == 1);

                     //ts_tasks_if.wait_vip_rx_link_down();
                     wait(svt_ethernet_txrx_inst.if_mon.usr_chk_sync_up_rx == 0);
                     `uvm_info(get_type_name(), $psprintf("wait vip rx link down Done"), UVM_NONE)
                     //ts_tasks_if.wait_vip_rx_link_up(); 
                     wait(svt_ethernet_txrx_inst.if_mon.usr_chk_sync_up_rx == 1);
                     `uvm_info(get_type_name(), $psprintf("wait vip_rx_link_up Done"), UVM_NONE)
                  end
               end
            join
         end
         begin
            #500us;
	         `uvm_error(get_type_name(), $sformatf("Timeout waiting for DUT/VIP Link-up"));
         end
      join_any
      disable fork; 
	
      reg_read(gdr_ral_offset("sgmii_status"),data_read,1);
      if(data_read[2]==1'b1) begin //sgmii_status bit 2 is LINK_STATUS bit and it should be high after linkup
     	   reg_model.sgmii_status.predict(.value(data_read[31:0]),.kind(UVM_PREDICT_DIRECT), .map(reg_model.default_map));
         //Updating the RO register with mirrored value
      end
      else begin
	      `uvm_error(get_type_name(), $sformatf("LINK_STATUS bit should be high after link-up"));	
      end 
   end
   `uvm_info(get_name(), "Reading user csr space", UVM_NONE)
   `uvm_info(get_name(), $psprintf("addr = 'h1002_0300, data = %0h", data_read), UVM_NONE)
   `uvm_info(get_type_name(), $sformatf("DM PCS operating speed configured is  :%0s",dyn_rcfg_obj_inst.ll_speed), UVM_NONE)   
   `uvm_info(get_type_name(), $sformatf("%s: END",func_name), UVM_NONE);
endtask

//************************************************************************************

task eth_env_env::apply_reconfig_reset();
   reset_sequence rst_seq_inst;

   rst_seq_inst=reset_sequence::type_id::create("rst_seq_inst",this);
   rst_seq_inst.assert_reconfig_reset    = 1;
   rst_seq_inst.assert_transmit_reset    = 0;
   rst_seq_inst.assert_receiver_reset    = 0;
   rst_seq_inst.assert_ip_reset          = 0;
   rst_seq_inst.assert_vip_reset         = 0;
   rst_seq_inst.start(virtual_sequencer_inst.reset_seqr_inst);
endtask

//************************************************************************************  
//Apply VIP reset
task eth_env_env::apply_vip_reset();
   reset_sequence rst_seq_inst;
   `uvm_info(get_type_name(),$sformatf("Inside apply_vip_reset task"),UVM_NONE);
   rst_seq_inst=reset_sequence::type_id::create("rst_seq_inst",this);
   rst_seq_inst.assert_reconfig_reset    = 0;
	rst_seq_inst.assert_transmit_reset    = 0;
   rst_seq_inst.assert_receiver_reset    = 0;
   rst_seq_inst.assert_ip_reset          = 0;
   rst_seq_inst.assert_vip_reset         = 1;
   rst_seq_inst.start(virtual_sequencer_inst.reset_seqr_inst);
endtask

//************************************************************************************  
// this task will apply soft/hard reset
task eth_env_env::apply_reset(string rst_type="hard",
                              bit tx_rst=0,
                              bit rx_rst=0, 
                              bit ip_rst=1,
                              int reset_period=11, 
                              int tx_dly=0, 
                              int rx_dly=0, 
                              int ip_dly=0, 
                              bit hold_reset=0);

   reset_sequence    rst_seq_inst;
   uvm_reg_data_t    read_data;
   uvm_reg_field     m_reg_field;
   uvm_status_e      status;
   uvm_reg           m_reg;
   uvm_reg 	         regs[$]; 
   uvm_reg_data_t    data_read;
    
   `uvm_info(get_type_name(), $sformatf("Calling apply_%s_reset() tx_rst:%0d rx_rst:%0d ip_rst:%0d",
      rst_type,tx_rst,rx_rst,ip_rst ), UVM_LOW)

   if(tx_rst == 1) begin
      //disabling vip checks before reset
      ts_tasks_if.do_mon_cfg(`ETH_DISABLE_ALL_RULE,0);
      //bit 0: (set t0 0 to disable checker on tx side)
      //bit 1: (set t0 0 to disable checker on rx side)
      //bit 2: (set t0 0 to disable checker on checker arbiter)
      ts_tasks_if.do_mon_cfg(`ETH_CHECKER_RULE_MODE,3'b011);
   end

   if(rx_rst == 1 || ip_rst == 1 || (tx_rst == 1 && dyn_rcfg_obj_inst.mode inside {OTN,FLEXE})) begin
      disable_all_snps_errors();
   end

   rst_seq_inst=reset_sequence::type_id::create("rst_seq_inst",this);

   //Data path  Reset check 
   if(tx_rst == 1 || rx_rst == 1 || ip_rst == 1 ) begin
      if(rst_type == "hard") begin
         rst_seq_inst.assert_reconfig_reset    = 0;
	      rst_seq_inst.assert_transmit_reset    = tx_rst;
         rst_seq_inst.assert_receiver_reset    = rx_rst;
         rst_seq_inst.assert_ip_reset          = ip_rst;
         rst_seq_inst.assert_vip_reset         = 0;
         rst_seq_inst.hold_reset               = hold_reset;
         rst_seq_inst.start(virtual_sequencer_inst.reset_seqr_inst);
         reg_model.default_map.get_registers(regs);
         foreach(regs[i]) begin
            regs[i].reset();
         end
      end
      else begin
         //------------------------------------------------------------------------------------------
         //IP data Path Reset
	      if(ip_rst == 1) begin 
            m_reg = reg_model.get_reg_by_name("eth_reset");
	         m_reg_field = m_reg.get_field_by_name("eio_sys_rst"); //Bit 0
            m_reg_field.set(1);
            m_reg.write(status,.value(m_reg.get())); 
            m_reg = reg_model.get_reg_by_name("eth_reset_status");
	         fork 
	            begin
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for IP RST ACK"),UVM_LOW);
		            wait( reset_if.rst_ack_n == 0 && reset_if.tx_rst_ack_n == 0 && reset_if.rx_rst_ack_n == 0) ;
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for IP RST ACK done"),UVM_LOW);
	               m_reg.read(status,.value(read_data));
		            if(read_data[2:0] != 3'h0 ) begin
		               `uvm_error(get_type_name(), $sformatf("Status Register Mismatch"));
		            end 
	            end

	            begin
                  if(dyn_rcfg_obj_inst.anlt == 1 ) begin //anlt
	                  #2ms;
                  end
                  else if(dyn_rcfg_obj_inst.ptp == 1 ) begin //ptp
                     #800us;
                  end
                  else begin
                     #120us; 
                  end
                  `uvm_error(get_type_name(), $sformatf("timeout for IP RST ACK"));
	            end
	         join_any
	         disable fork;  
	     
            m_reg = reg_model.get_reg_by_name("eth_reset");
	         m_reg_field = m_reg.get_field_by_name("eio_sys_rst"); //Bit 0
            m_reg_field.set(0);
	         m_reg.write(status,.value(m_reg.get()));
	         //check for status 
	         m_reg = reg_model.get_reg_by_name("eth_reset_status");

	         fork 
	            begin
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for IP RST ACK"),UVM_LOW);
		            wait(reset_if.rst_ack_n == 1 && reset_if.tx_rst_ack_n == 1 && reset_if.rx_rst_ack_n == 1) ;
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for IP RST ACK done"),UVM_LOW);
	               m_reg.read(status,.value(read_data));
		            if(read_data[2:0] != 3'h7 ) begin
		               `uvm_error(get_type_name(), $sformatf("Status Register Mismatch"));
		            end 
	            end

	            begin
                  if(dyn_rcfg_obj_inst.anlt == 1 ) begin //anlt
	                  #800us;
                  end
                  else if (dyn_rcfg_obj_inst.ptp == 1 ) begin //ptp
                     #800us;
                  end
                  else begin
                     #350us;
                  end
                  `uvm_error(get_type_name(), $sformatf("timeout for IP RST ACK"));
	            end
	         join_any
	        disable fork;  

         end //end of if(ip_rst==1)
         
         //------------------------------------------------------------------------------------------
         if(tx_rst == 1 && rx_rst == 1) begin
            reg_read(gdr_ral_offset("mac_reset_control"),data_read);
            data_read[0] = 1;
            data_read[8] = 1;
            `uvm_info("AVMM REG READ", $sformatf("Register with address mac_reset_control write data is :'h%0h",
               data_read), UVM_NONE);
            reg_write(gdr_ral_offset("mac_reset_control"),data_read);
            #1us;

	         fork 
	            begin
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to low"),UVM_LOW);
		            wait(spy_if.o_tx_ready == 0);
                  //reset_if.rst_ack_n == 0 && reset_if.tx_rst_ack_n == 0 && reset_if.rx_rst_ack_n == 0) ;
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to low  done"),UVM_LOW);
	            end

               begin
                  #200ns;    
                  repeat(200-20) begin // suppose to see ready 0 for 200ns but checking for less time
                     #1ns;
                     if(sideband_if.rx_valid == 1) 
                        `uvm_error("ETH Trans", $sformatf("AVST RX valid not paused properly"));
                  end
                  `uvm_info("",$sformatf("wait done for avst_rx_valid=0\n"),UVM_MEDIUM);
               end

	            begin
                  #20us; 
                  `uvm_error(get_type_name(), $sformatf("timeout for tx_ready to go low"));
	            end
	         join_any
	         disable fork;  
	     
            reg_read(gdr_ral_offset("mac_reset_control"),data_read);
            data_read[0] = 0;
            data_read[8] = 0;
            `uvm_info("AVMM REG READ", $sformatf("Register with address mac_reset_control write data is :'h%0h",
               data_read), UVM_NONE);
            reg_write(gdr_ral_offset("mac_reset_control"),data_read);

	         fork 
	            begin
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to high"),UVM_LOW);
		            wait(spy_if.o_tx_ready == 1); //reset_if.tx_rst_ack_n == 1 && reset_if.rx_rst_ack_n == 1) ;
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to high done"),UVM_LOW);
	            end

	            begin
                  #20us;
                  `uvm_error(get_type_name(), $sformatf("timeout for tx_ready to go high"));
	            end
	         join_any
	         disable fork;  
	   
         end  // end of if(tx_rst == 1 && rx_rst == 1)
         //------------------------------------------------------------------------------------------
         //TX Only Reset 
	      if(tx_rst == 1 && rx_rst == 0) begin
            reg_read(gdr_ral_offset("mac_reset_control"),data_read);
            data_read[0] = 1;
            `uvm_info("AVMM REG READ", $sformatf("Register with address mac_reset_control write data is :'h%0h",
               data_read), UVM_NONE);
            reg_write(gdr_ral_offset("mac_reset_control"),data_read);

	         fork 
	            begin
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to go low"),UVM_LOW);
		            wait(spy_if.o_tx_ready == 0);
                  //reset_if.rst_ack_n == 0 && reset_if.tx_rst_ack_n == 0 && reset_if.rx_rst_ack_n == 1) ;
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to go low done"),UVM_LOW);
	            end

	            begin
                  #20us; 
                  `uvm_error(get_type_name(), $sformatf("timeout for tx_ready to go low"));
	            end
	         join_any
	         disable fork;  
            #1us;
            reg_read(gdr_ral_offset("mac_reset_control"),data_read);
            data_read[0] = 0;
            `uvm_info("AVMM REG READ", $sformatf("Register with address mac_reset_control write data is :'h%0h",
               data_read), UVM_NONE);
            reg_write(gdr_ral_offset("mac_reset_control"),data_read);

	         fork 
	            begin
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to go high"),UVM_LOW);
		            wait(spy_if.o_tx_ready == 1);
                  //reset_if.rst_ack_n == 1 && reset_if.tx_rst_ack_n == 1 && reset_if.rx_rst_ack_n == 1) ;
                  `uvm_info(get_type_name(), $sformatf("PCR: wait for tx_ready to go high  done"),UVM_LOW);
	            end

	            begin
                  #20us;
                  `uvm_error(get_type_name(), $sformatf("timeout for tx_ready to go high"));
	            end
	         join_any
	         disable fork; 
         end 
         //------------------------------------------------------------------------------------------
         //RX Only Reset
	      if(rx_rst == 1 && tx_rst == 0) begin
            reg_read(gdr_ral_offset("mac_reset_control"),data_read);
            data_read[8] = 1;
            `uvm_info("AVMM REG READ", $sformatf("Register with address mac_reset_control write data is :'h%0h",
               data_read), UVM_NONE);
            reg_write(gdr_ral_offset("mac_reset_control"),data_read);
            fork
               begin
                  #5us;
                  `uvm_error("ETH Trans", $sformatf("TIMEOUT for rx_valid to become 0"));
               end
               begin
                  #200ns;    
                  repeat(200-20) begin // suppose to see ready 0 for 200ns but checking for less time
                     #1ns;
                     if(sideband_if.rx_valid == 1) 
                        `uvm_error("ETH Trans", $sformatf("AVST RX valid not paused properly"));
                  end
                  `uvm_info("",$sformatf("wait done for avst_rx_valid=0\n"),UVM_MEDIUM);
               end
            join_any  
            disable fork; 
         
            #10us;
            reg_read(gdr_ral_offset("mac_reset_control"),data_read);
            data_read[8] = 0;
            `uvm_info("AVMM REG READ", $sformatf("Register with address mac_reset_control write data is :'h%0h",
               data_read), UVM_NONE);
            reg_write(gdr_ral_offset("mac_reset_control"),data_read);
	      end
      end
   end
endtask : apply_reset

//************************************************************************************  
// This will enable/disable scoreboards
function void eth_env_env::dynamic_enable_disable_scoreboards(bit enb_bit);
   if(loopback_enable == 0) begin
      sb_mac_tx_vip_rx.scb_dis=enb_bit;
      sb_vip_tx_mac_rx.scb_dis=enb_bit;
      sb_vec_vip_tx_mac_rx.sb_enable=!enb_bit;
      sb_vec_mac_tx_vip_rx.sb_enable=!enb_bit;
   end else begin
      sb_loopbk.scb_dis=enb_bit;
   end
endfunction

//************************************************************************************  
// HSD 16011962399
// To check packet with no "FD"
function int eth_env_env::corrupt_eop();
   if(spy_if.event_chk_no_eop_tx.triggered) begin
      `uvm_info("env:ref", $sformatf("no_eop event triggered"),UVM_LOW);
      return(1'b1);
   end
   else begin
      `uvm_info("env:ref", $sformatf("no_eop event not triggered"),UVM_LOW);	     
      return(1'b0);	     
   end 
endfunction

//************************************************************************************

task eth_env_env::configure_vip_packets();
   //SNPS case :01205676, HSD: 16013867273
   `uvm_info(get_type_name(),"Configuring malformed packets for monitor Scorboarding",UVM_MEDIUM);
   if(dyn_rcfg_obj_inst.mode inside {FLEXE,OTN}) begin
      mac_cfg_otn_flexe.enable_mon_pkt_retain_on_framing_error=1;
      mac_cfg_otn_flexe.enable_mon_pkt_drop_on_framing_error=0;
   end
   if(dyn_rcfg_obj_inst.mode == PCSONLY) begin
      `MAC_CFG.enable_mon_pkt_retain_on_framing_error=1;
      `MAC_CFG.enable_mon_pkt_drop_on_framing_error=0;
   end	    
endtask

//************************************************************************************

task eth_env_env::configure_vip_ber();
      apply_vip_reset();
      `uvm_info(get_type_name(), $psprintf("wait for vip link to go up"), UVM_NONE)
      ts_tasks_if.wait_vip_rx_link_up();
      case(dyn_rcfg_obj_inst.speed)
          _100G : begin
                  `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                  `MAC_CFG.enable_ber     = 1;
                  `MAC_CFG.csbi_ber_limit = 1000;
                  `MAC_CFG.csbi_ber_timer = 300;
                  `M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(`MAC_CFG);
                  end
	  _25G  : begin
                `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                 `MAC_CFG.enable_ber     = 1;
	             `MAC_CFG.xxvsbi_ber_limit = 1000;
		         `MAC_CFG.xxvsbi_ber_timer = 300;
		         `M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(`MAC_CFG);
		 end
	  _50G  : begin
                `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                 `MAC_CFG.enable_ber     = 1;
	             `MAC_CFG.lsbi_ber_limit = 1000;
		         `MAC_CFG.lsbi_ber_timer = 300;
		         `M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(`MAC_CFG);
		 end
	  _40G  : begin
                `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                 `MAC_CFG.enable_ber     = 1;
	             `MAC_CFG.xlsbi_ber_limit = 1000;
		         `MAC_CFG.xlsbi_ber_timer = 300;
		         `M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(`MAC_CFG);
		 end
	  _10G  : begin
                `uvm_info(get_type_name(), $sformatf("Configuring VIP ber_timer to 300"),UVM_LOW);
                 `MAC_CFG.enable_ber     = 1;
	             `MAC_CFG.xsbi_ber_limit = 1000;
		         `MAC_CFG.xsbi_ber_timer = 300;
		         `M_SNPS_ETH_PCS66_AGENT.reconfigure_via_task(`MAC_CFG);
		 end
      endcase
      #10us;//VIP linkup is behaving differently for 100G, Adding this delay till VIP link up happnes //SNPS case: 01155649
      wait(sideband_if.rx_pcs_ready == 1'b1);
      `uvm_info(get_type_name(), $psprintf("wait for rx_pcs_ready to get asserted after BER config is done"), UVM_NONE)
endtask

//************************************************************************************
  // Alex: This will disable vector scoreboard as per GDR proposal
function void eth_env_env::configure_vector_scoreboard();
      
   sb_vec_vip_tx_mac_rx.sb_enable=1'b1;
   sb_vec_mac_tx_vip_rx.sb_enable=1'b1;
   // Keep following 3 lines as these are reserved in GDR
   sb_vec_vip_tx_mac_rx.vector_sb_check_dis["PAYLOAD_SIZE"] = 1'b0;
   sb_vec_vip_tx_mac_rx.vector_sb_check_dis["FRAME_SIZE"] = 1'b0;
   sb_vec_vip_tx_mac_rx.vector_sb_check_dis["UCAST_FRAME"] = 1'b1;
      // Below disables for HSD 16010992360
      // Enable after HSD resolves
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["TX_CRC_ERR"] = 1'b1;
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["TX_LEN_ERR"] = 1'b1;
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["RX_PHY_ERR"] = 1'b1;
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["RX_CRC_ERR"] = 1'b1;
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["RX_LEN_ERR"] = 1'b1;
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["UNDERSIZE_ERR"] = 1'b1;
//      sb_vec_vip_tx_mac_rx.vector_sb_check_dis["OVERSIZE_ERR"] = 1'b1;
endfunction

//************************************************************************************

function void eth_env_env::gdr_ral_reset(string regname, string fldname);
   uvm_reg_field fld_l;
   uvm_reg reg_l;
   uvm_reg regs[$];
     
   reg_model.default_map.get_registers(regs);
   foreach(regs[i]) begin
      $display("Inside gdr_ral_reset :%0s",regs[i].get_name());
      if(regname == regs[i].get_name()) begin
         reg_l = regs[i]; 
         if(fldname == "") begin 
            reg_l.reset();
         end
         else begin
            fld_l  = reg_l.get_field_by_name(fldname);
            fld_l.reset();
         end
	      return;
      end
   end
   `uvm_fatal("eth_env_env", $sformatf("failed to get register= %0s and field= %0s",regname, fldname));
endfunction

//************************************************************************************

task eth_env_env::read_sip_status();
    bit disable_check=3;
    `uvm_info("read_sip_reg", $sformatf("Reading the SIP Register Post Traffic is over with disable_check=%0d",disable_check),UVM_MEDIUM);
 endtask

//************************************************************************************ 

`endif // ETH_ENV_ENV__SV


