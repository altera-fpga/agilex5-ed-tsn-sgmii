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


class parameter_sweep_cov extends uvm_component;
  `uvm_component_utils(parameter_sweep_cov)
  bit rxvlan , txvlan, rx_fc_fwd, sa, en_mx_frsz , preamble_passthrough , sfd, phyrefclk;
  bit [3:0] ipg;
  bit [1:0] rdy_lat , rxbyte_rem , lf , fc_rdy_drop;
  bit [16:0] rxfrmsize, txfrmsize;
  bit [8:0] speed;
  bit [2:0] ifc,fec_type;
  bit en_async_adp , trans_type, s_preamble;
  bit [1:0] fc;
  int async_ftx_100_pp0, async_ftx_100_pp1, async_ftx_25_50, async_ftx_40, async_ftx_10;
  int async_frx_100_pp0, async_frx_100_pp1, async_frx_25_50, async_frx_40, async_frx_10;
  int ignore_flag_pp0_100G=1, ignore_flag_pp1_100G=1, ignore_flag_25G_50G=1, ignore_flag_40G=1, ignore_flag_10G=1;

   realtime time_TX_pos, time_TX_neg, time_RX_pos, time_RX_neg;
   real TX_period, RX_period;
   int TX_freq, RX_freq;   

  dyn_rcfg dyn_rcfg_ps_obj_inst;
  virtual spy_interface spy_if;
  virtual eth_sideband_interface sideband_if;


  function new(string name, uvm_component parent);
      super.new(name,parent);
      // Get Dyn cfg obj
      if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_ps_obj_inst)) begin 
        `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_ps_obj_inst object");
      end
      if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
      `uvm_fatal("spy_interface", "failed to get spy_interface intf");
      end
      uvm_config_db#(virtual spy_interface)::set(this,"*","spy_interface", spy_if);   

     if(!uvm_config_db#(virtual eth_sideband_interface)::get(this, "", "mst_if", sideband_if)) begin
      `uvm_fatal("eth_sideband_interface", "failed to get sideband intf");
     end
     uvm_config_db #(virtual eth_sideband_interface)::set(this,"*", "mst_if",sideband_if);
     uvm_config_db #(virtual eth_sideband_interface)::set(this,"*", "slv_if",sideband_if);

      parameter_sweep_cg = new();
  endfunction 

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if(dyn_rcfg_ps_obj_inst.en_async_adp==1 && dyn_rcfg_ps_obj_inst.mode==PCSMAC) begin
     wait(spy_if.rx_pcs_ready == 1'b1);
     $display("Sampling parameter_sweep_coverage at %0t",$time);
     fork //To calculate Time Period For Async Clk
      begin
       @(posedge sideband_if.clk_tx)
       begin
       time_TX_pos = $realtime;
       end
       @(negedge sideband_if.clk_tx)
       begin
       time_TX_neg = $realtime;
       end
       TX_period = (time_TX_neg-time_TX_pos)*2;
       TX_freq = (1000000/TX_period)*1000;
      end
      begin
       @(posedge sideband_if.clk_rx)
       begin
       time_RX_pos = $realtime;
       end
       @(negedge sideband_if.clk_rx)
       begin
       time_RX_neg = $realtime;
       end
       RX_period = (time_RX_neg-time_RX_pos)*2;
       RX_freq = (1000000/RX_period)*1000;
     end
     join
     case (dyn_rcfg_ps_obj_inst.speed)
       _100G:
         if(dyn_rcfg_ps_obj_inst.preamble_passthrough)
         begin
          async_ftx_100_pp1 = TX_freq;
          async_frx_100_pp1 = RX_freq;
          ignore_flag_pp1_100G=0;
         end
         else
         begin
          async_ftx_100_pp0 = TX_freq;
          async_frx_100_pp0 = RX_freq;
          ignore_flag_pp0_100G=0;
         end
       _50G:
          begin
           async_ftx_25_50 = TX_freq;
           async_frx_25_50 = RX_freq;
           ignore_flag_25G_50G=0;
          end
       _40G:
          begin
           async_ftx_40 = TX_freq;
           async_frx_40 = RX_freq;
           ignore_flag_40G=0;
          end 
       _25G:
          begin
           async_ftx_25_50 = TX_freq;
           async_frx_25_50 = RX_freq;
           ignore_flag_25G_50G=0;
          end
       _10G:
          begin
           async_ftx_10 = TX_freq;
           async_frx_10 = RX_freq;
           ignore_flag_10G=0;
          end
       endcase
       parameter_sweep_cg.sample();
       $display("Sampling Done at %0t",$time);
     end //en_async_adp==1
     else begin
      parameter_sweep_cg.sample();
      $display("Sampling Done at %0t",$time);
     end
  endtask  

  covergroup parameter_sweep_cg;
    
    speed_cp: coverpoint dyn_rcfg_ps_obj_inst.speed {
        bins speed_400 = {3'b000}; //400
        bins speed_200 = {3'b001}; //200
        bins speed_100 = {3'b010}; //100
        bins speed_50 = {3'b011}; //50
        bins speed_40 = {3'b100}; //40
        bins speed_25 = {3'b101}; //25
        bins speed_10 = {3'b110}; //10
      }
    
    ifc_cp: coverpoint dyn_rcfg_ps_obj_inst.mode {
      bins ifc_0 = {3'b00};
      bins ifc_1 = {3'b01};
      //bins ifc_2 = {3'b10};
      //bins ifc_3 = {3'b011};
      //bins ifc_4 = {3'b100};
    }

    fec_type_cp: coverpoint dyn_rcfg_ps_obj_inst.fec_type {
      bins fec_type_0 = {3'b00};
      bins fec_type_1 = {3'b01};
      bins fec_type_2 = {3'b10};
      bins fec_type_3 = {3'b11};
      bins fec_type_4 = {3'b100};
    }

    trans_type_cp: coverpoint dyn_rcfg_ps_obj_inst.trans_type {
      bins trans_type_0 = {0};
      bins trans_type_1 = {1};
    }

    syspll_cp: coverpoint dyn_rcfg_ps_obj_inst.syspll {
      bins syspll_0 = {0};
      bins syspll_1 = {1};
      bins syspll_2 = {2};
      bins syspll_3 = {3};
    }

    syspllcnt_cp : coverpoint dyn_rcfg_ps_obj_inst.syspllcnt {
      bins syspll_830 = {8300781250};
      bins syspll_870 = {8700000000};
      bins syspll_903 = {9031250000};
      // HSD : 16012204509
      //bins syspll_950 = {9500000000};
      //bins syspll_1000 = {10000000000};
    }

    en_async_adp_cp: coverpoint dyn_rcfg_ps_obj_inst.en_async_adp {
      //ignore_bins ignr_en_async_adp_1 = {1} iff(dyn_rcfg_ps_obj_inst.mode!=PCSMAC);
      bins en_async_adp_0 = {0};
      bins en_async_adp_1 = {1};
    }

    async_freq_TX_100G: coverpoint async_ftx_100_pp0 {
    //ignore_bins ignr_min_freq = {340000} iff(ignore_flag_pp0_100G);
    //ignore_bins ignr_freq_1 = {[340001:400000]} iff(ignore_flag_pp0_100G);
    //ignore_bins ignr_freq_2 = {[400001:500000]} iff(ignore_flag_pp0_100G);
    bins min_freq = {340000};
    bins freq_1 = {[340001:400000]};
    bins freq_2 = {[400001:500000]};
    }   
 
    async_freq_TX_100G_PP1: coverpoint async_ftx_100_pp1 {
    //ignore_bins ignr_min_freq = {380000} iff(ignore_flag_pp1_100G);
    //ignore_bins ignr_freq_1 = {[380001:450000]} iff(ignore_flag_pp1_100G);
    //ignore_bins ignr_freq_2 = {[450001:500000]} iff(ignore_flag_pp1_100G);
    bins min_freq = {380000};
    bins freq_1 = {[380001:450000]};
    bins freq_2 = {[450001:500000]};
    }   

    async_freq_TX_25G_50G: coverpoint async_ftx_25_50 {
    //ignore_bins ignr_min_freq = {390625} iff(ignore_flag_25G_50G);
    //ignore_bins ignr_freq_1 = {[390626:450000]} iff(ignore_flag_25G_50G);
    //ignore_bins ignr_freq_2 = {[450001:500000]} iff(ignore_flag_25G_50G);
    bins min_freq = {390625};
    bins freq_1 = {[390626:450000]};
    bins freq_2 = {[450001:500000]};
    }   

    async_freq_TX_40G: coverpoint async_ftx_40 {
    //ignore_bins ignr_min_freq = {312500} iff(ignore_flag_40G);
    //ignore_bins ignr_freq_1 = {[312501:400000]} iff(ignore_flag_40G);
    //ignore_bins ignr_freq_2 = {[400001:450000]} iff(ignore_flag_40G);
    //ignore_bins ignr_freq_3 = {[450001:500000]} iff(ignore_flag_40G);
    bins min_freq = {312500};
    bins freq_1 = {[312501:400000]};
    bins freq_2 = {[400001:450000]};
    bins freq_3 = {[450001:500000]};
    }   

    async_freq_TX_10G: coverpoint async_ftx_10 {
    //ignore_bins ignr_min_freq = {156250} iff(ignore_flag_10G);
    //ignore_bins ignr_freq_1 = {[156251:300000]} iff(ignore_flag_10G);
    //ignore_bins ignr_freq_2 = {[300001:400000]} iff(ignore_flag_10G);
    //ignore_bins ignr_freq_3 = {[400001:500000]} iff(ignore_flag_10G);
    bins min_freq = {156250};
    bins freq_1 = {[156251:300000]};
    bins freq_2 = {[300001:400000]};
    bins freq_3 = {[400001:500000]};
    }   


    async_freq_RX_100G: coverpoint async_frx_100_pp0 {
    //ignore_bins ignr_min_freq = {340000} iff(ignore_flag_pp0_100G);
    //ignore_bins ignr_freq_1 = {[340001:400000]} iff(ignore_flag_pp0_100G);
    //ignore_bins ignr_freq_2 = {[400001:500000]} iff(ignore_flag_pp0_100G);
    bins min_freq = {340000};
    bins freq_1 = {[340001:400000]};
    bins freq_2 = {[400001:500000]};
    }   

    async_freq_RX_100G_PP1: coverpoint async_frx_100_pp1 {
    //ignore_bins ignr_min_freq = {381000} iff(ignore_flag_pp1_100G);
    //ignore_bins ignr_freq_1 = {[381001:450000]} iff(ignore_flag_pp1_100G);
    //ignore_bins ignr_freq_2 = {[450001:500000]} iff(ignore_flag_pp1_100G);
    bins min_freq = {381000};
    bins freq_1 = {[381001:450000]};
    bins freq_2 = {[450001:500000]};
    }   

    async_freq_RX_25G_50G: coverpoint async_frx_25_50 {
    //ignore_bins ignr_min_freq = {391625} iff(ignore_flag_25G_50G);
    //ignore_bins ignr_freq_1 = {[391626:450000]} iff(ignore_flag_25G_50G);
    //ignore_bins ignr_freq_2 = {[450001:500000]} iff(ignore_flag_25G_50G);
    bins min_freq = {391625};
    bins freq_1 = {[391626:450000]};
    bins freq_2 = {[450001:500000]};
    }   

    async_freq_RX_40G: coverpoint async_frx_40 {
    //ignore_bins ignr_min_freq = {313500} iff(ignore_flag_40G);
    //ignore_bins ignr_freq_1 = {[313501:400000]} iff(ignore_flag_40G);
    //ignore_bins ignr_freq_2 = {[400001:450000]} iff(ignore_flag_40G);
    //ignore_bins ignr_freq_3 = {[450001:500000]} iff(ignore_flag_40G);
    bins min_freq = {313500};
    bins freq_1 = {[313501:400000]};
    bins freq_2 = {[400001:450000]};
    bins freq_3 = {[450001:500000]};
    }   

    async_freq_RX_10G: coverpoint async_frx_10 {
    //ignore_bins ignr_min_freq = {157250} iff(ignore_flag_10G);
    //ignore_bins ignr_freq_1 = {[157251:300000]} iff(ignore_flag_10G);
    //ignore_bins ignr_freq_2 = {[300001:400000]} iff(ignore_flag_10G);
    //ignore_bins ignr_freq_3 = {[400001:500000]} iff(ignore_flag_10G);
    bins min_freq = {157250};
    bins freq_1 = {[157251:300000]};
    bins freq_2 = {[300001:400000]};
    bins freq_3 = {[400001:500000]};
    }
   
    s_preamble_cp: coverpoint dyn_rcfg_ps_obj_inst.strict_preamble {
      bins s_preamble_0 = {0};
      bins s_preamble_1 = {1};
    }

    fc_cp: coverpoint dyn_rcfg_ps_obj_inst.fc {
      bins fc_0 = {2'b00};
      bins fc_1 = {2'b01};
      bins fc_2 = {2'b10};
    }

    rxvlan_cp: coverpoint dyn_rcfg_ps_obj_inst.rxvlan {
      bins rxvlan_0 = {0};
      bins rxvlan_1 = {1};
    }

    txvlan_cp: coverpoint dyn_rcfg_ps_obj_inst.txvlan {
      bins txvlan_0 = {0};
      bins txvlan_1 = {1};
    }

    rdy_lat_cp: coverpoint dyn_rcfg_ps_obj_inst.rdy_lat {
      bins rdy_lat_0 = {2'b00};
      bins rdy_lat_1 = {2'b01};
      bins rdy_lat_2 = {2'b10};
      bins rdy_lat_3 = {2'b11};
    }

    rxbyte_rem_cp: coverpoint dyn_rcfg_ps_obj_inst.rxbyte_rem {
      bins rxbyte_rem_0 = {2'b00};
      bins rxbyte_rem_1 = {2'b01};
      bins rxbyte_rem_2 = {2'b10};
    //  bins rxbyte_rem_3 = {2'b11};
    }

    lf_cp: coverpoint dyn_rcfg_ps_obj_inst.lf {
      bins lf_0 = {2'b00};
      bins lf_1 = {2'b01};
      bins lf_2 = {2'b10};
    }


    rx_fc_fwd_cp: coverpoint dyn_rcfg_ps_obj_inst.rx_fc_fwd {
      bins rx_fc_fwd_0 = {0};
      bins rx_fc_fwd_1 = {1};
    }

    sa_cp: coverpoint dyn_rcfg_ps_obj_inst.sa {
      bins sa_0 = {0};
      bins sa_1 = {1};
    }

    en_mx_frsz_cp : coverpoint dyn_rcfg_ps_obj_inst.en_mx_frsz {
      bins en_mx_frsz_0 = {0};
      bins en_mx_frsz_1 = {1};
    }

    tx_frsz_cp : coverpoint dyn_rcfg_ps_obj_inst.tx_frm_size {
      bins tx_frsz_min   = {[65:16384]};      
      bins tx_frsz_mid1  = {[16385:32768]};      
      bins tx_frsz_mid2  = {[32769:49152]};      
      bins tx_frsz_max   = {[49153:65535]};      
    }

    rx_frsz_cp : coverpoint dyn_rcfg_ps_obj_inst.rx_frm_size {
      bins rx_frsz_min   = {[65:16384]};      
      bins rx_frsz_mid1  = {[16385:32768]};      
      bins rx_frsz_mid2  = {[32769:49152]};      
      bins rx_frsz_max   = {[49153:65535]};      
    }

    preamble_passthrough_cp: coverpoint dyn_rcfg_ps_obj_inst.preamble_passthrough {
      bins preamble_passthrough_0 = {0};
      bins preamble_passthrough_1 = {1};
      //ignore_bins preamble_passthrough_ignr = {0} iff((dyn_rcfg_ps_obj_inst.speed==_50G || dyn_rcfg_ps_obj_inst.speed==_40G) && dyn_rcfg_ps_obj_inst.mode==PCSMAC);
    }

    sfd_cp: coverpoint dyn_rcfg_ps_obj_inst.sfd {
      bins sfd_0 = {0};
      bins sfd_1 = {1};
    }

    fc_rdy_drop_cp: coverpoint dyn_rcfg_ps_obj_inst.fc_rdy_drop {
      bins fc_rdy_drop_0 = {2'b00};
      bins fc_rdy_drop_1 = {2'b01};
      bins fc_rdy_drop_2 = {2'b10};
      bins fc_rdy_drop_3 = {2'b11};
    }

    phyrefclk_cp: coverpoint dyn_rcfg_ps_obj_inst.phyrefclk {
      bins phyrefclk_0 = {0};
      bins phyrefclk_1 = {1};
      //ignore_bins ignr_phyrefclk_1 = {1} iff(dyn_rcfg_ps_obj_inst.speed inside {3'b001,3'b000});  //GDR:Should be removed once HSD is fixed
    }

    ipg_cp: coverpoint dyn_rcfg_ps_obj_inst.ipg {
      bins ipg_0 = {4'b0001};
      bins ipg_1 = {4'b1000};
      bins ipg_2 = {4'b1010};
      bins ipg_3 = {4'b1100};
    }

    additional_ipg_cp : coverpoint dyn_rcfg_ps_obj_inst.ipg_rm_perperiod {
      bins addl_ipg_min  = {[0:4134]};
      bins addl_ipg_mid1 = {[4135:8268]};
      bins addl_ipg_mid2 = {[8269:12402]};
      bins addl_ipg_max  = {[12403:16536]};
    }

    crs_speed_x_transtype : cross speed_cp, trans_type_cp;
    crs_speed_x_ifc       : cross speed_cp, ifc_cp;
    crs_speed_x_fec       : cross speed_cp, fec_type_cp;
    crs_speed_x_enasync   : cross speed_cp, en_async_adp_cp;
    crs_speed_x_preamble  : cross speed_cp, s_preamble_cp;
    crs_speed_x_sfd       : cross speed_cp, sfd_cp;
    crs_speed_x_pp        : cross speed_cp, preamble_passthrough_cp;
    crs_speed_x_fc        : cross speed_cp, fc_cp;
    crs_speed_x_fcrdydrop : cross speed_cp, fc_rdy_drop_cp;
    crs_speed_x_txvlan    : cross speed_cp, txvlan_cp;
    crs_speed_x_rxvlan    : cross speed_cp, rxvlan_cp;
    crs_speed_x_rdylat    : cross speed_cp, rdy_lat_cp;
    crs_speed_x_rxbyterem : cross speed_cp, rxbyte_rem_cp;
    crs_speed_x_lf        : cross speed_cp, lf_cp;
    crs_speed_x_fcfwd     : cross speed_cp, rx_fc_fwd_cp;
    crs_speed_x_sa        : cross speed_cp, sa_cp;
    crs_speed_x_enmaxfrsz : cross speed_cp, en_mx_frsz_cp;
    crs_speed_x_txfrsz    : cross speed_cp, tx_frsz_cp;
    crs_speed_x_rxfrsz    : cross speed_cp, rx_frsz_cp;
    crs_speed_x_phyrefclk : cross speed_cp, phyrefclk_cp;
    crs_speed_x_syspll    : cross speed_cp, syspll_cp;
    crs_speed_x_syspllcnt : cross speed_cp, syspllcnt_cp;
    crs_speed_x_ipg       : cross speed_cp, ipg_cp;
    crs_speed_x_addlipg   : cross speed_cp, additional_ipg_cp;
    
    //Todo : Delete commented code after exclusions are added
    /*cross_400_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_400_ifc = cross_400_ifc with (speed_cp != 3'b000);
    }
    cross_400_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_400_fec = cross_400_fec with (speed_cp != 3'b000) ;
    }
    cross_400_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_400_trans_type = cross_400_trans_type with (speed_cp != 3'b000) ;
    }
    cross_400_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_400_en_async = cross_400_en_async with (speed_cp != 3'b000) ;
    }
    cross_400_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_400_s_preamble = cross_400_s_preamble with (speed_cp != 3'b000) ;
    }
    cross_400_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_400_fc = cross_400_fc with (speed_cp != 3'b000) ;
    }
    cross_400_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_400_rxvlan = cross_400_rxvlan with (speed_cp != 3'b000) ;
    }
    cross_400_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_400_txvlan = cross_400_txvlan with (speed_cp != 3'b000) ;
    }
    cross_400_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_400_rdy_lat = cross_400_rdy_lat with (speed_cp != 3'b000) ;
    }
    cross_400_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_400_rxbyte_rem = cross_400_rxbyte_rem with (speed_cp != 3'b000) ;
    }
    cross_400_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_400_lf = cross_400_lf with (speed_cp != 3'b000) ;
    }
    cross_400_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_400_rx_fc_fwd = cross_400_rx_fc_fwd with (speed_cp != 3'b000) ;
    }
    cross_400_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_400_sa = cross_400_sa with (speed_cp != 3'b000) ;
    }
    cross_400_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_400_en_mx_frsz = cross_400_en_mx_frsz with (speed_cp != 3'b000) ;
    }
    cross_400_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_400_pp = cross_400_pp with (speed_cp != 3'b000) ;
    }
    cross_400_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_400_sfd = cross_400_sfd with (speed_cp != 3'b000) ;
    }
    cross_400_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_400_fc_rdy_drop = cross_400_fc_rdy_drop with (speed_cp != 3'b000) ;
    }
    cross_400_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_400_phyrefclk = cross_400_phyrefclk with (speed_cp != 3'b000) ;
    }
    cross_400_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_400_ipg = cross_400_ipg with (speed_cp != 3'b000) ;
    }


    cross_200_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_200_ifc = cross_200_ifc with (speed_cp != 3'b001) ;
    }
    cross_200_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_200_fec = cross_200_fec with (speed_cp != 3'b001) ;
    }
    cross_200_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_200_trans_type = cross_200_trans_type with (speed_cp != 3'b001) ;
    }
    cross_200_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_200_en_async = cross_200_en_async with (speed_cp != 3'b001) ;
    }
    cross_200_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_200_s_preamble = cross_200_s_preamble with (speed_cp != 3'b001) ;
    }
    cross_200_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_200_fc = cross_200_fc with (speed_cp != 3'b001) ;
    }
    cross_200_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_200_rxvlan = cross_200_rxvlan with (speed_cp != 3'b001) ;
    }
    cross_200_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_200_txvlan = cross_200_txvlan with (speed_cp != 3'b001) ;
    }
    cross_200_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_200_rdy_lat = cross_200_rdy_lat with (speed_cp != 3'b001) ;
    }
    cross_200_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_200_rxbyte_rem = cross_200_rxbyte_rem with (speed_cp != 3'b001) ;
    }
    cross_200_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_200_lf = cross_200_lf with (speed_cp != 3'b001) ;
    }
    cross_200_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_200_rx_fc_fwd = cross_200_rx_fc_fwd with (speed_cp != 3'b001) ;
    }
    cross_200_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_200_sa = cross_200_sa with (speed_cp != 3'b001) ;
    }
    cross_200_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_200_en_mx_frsz = cross_200_en_mx_frsz with (speed_cp != 3'b001) ;
    }
    cross_200_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_200_pp = cross_200_pp with (speed_cp != 3'b001) ;
    }
    cross_200_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_200_sfd = cross_200_sfd with (speed_cp != 3'b001) ;
    }
    cross_200_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_200_fc_rdy_drop = cross_200_fc_rdy_drop with (speed_cp != 3'b001) ;
    }
    cross_200_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_200_phyrefclk = cross_200_phyrefclk with (speed_cp != 3'b001) ;
    }
    cross_200_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_200_ipg = cross_200_ipg with (speed_cp != 3'b001) ;
    }



    cross_100_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_100_ifc = cross_100_ifc with (speed_cp != 3'b010) ;
    }
    cross_100_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_100_fec = cross_100_fec with (speed_cp != 3'b010) ;
    }
    cross_100_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_100_trans_type = cross_100_trans_type with (speed_cp != 3'b010) ;
    }
    cross_100_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_100_en_async = cross_100_en_async with (speed_cp != 3'b010) ;
    }
    cross_100_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_100_s_preamble = cross_100_s_preamble with (speed_cp != 3'b010) ;
    }
    cross_100_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_100_fc = cross_100_fc with (speed_cp != 3'b010) ;
    }
    cross_100_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_100_rxvlan = cross_100_rxvlan with (speed_cp != 3'b010) ;
    }
    cross_100_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_100_txvlan = cross_100_txvlan with (speed_cp != 3'b010) ;
    }
    cross_100_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_100_rdy_lat = cross_100_rdy_lat with (speed_cp != 3'b010) ;
    }
    cross_100_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_100_rxbyte_rem = cross_100_rxbyte_rem with (speed_cp != 3'b010) ;
    }
    cross_100_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_100_lf = cross_100_lf with (speed_cp != 3'b010) ;
    }
    cross_100_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_100_rx_fc_fwd = cross_100_rx_fc_fwd with (speed_cp != 3'b010) ;
    }
    cross_100_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_100_sa = cross_100_sa with (speed_cp != 3'b010) ;
    }
    cross_100_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_100_en_mx_frsz = cross_100_en_mx_frsz with (speed_cp != 3'b010) ;
    }
    cross_100_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_100_pp = cross_100_pp with (speed_cp != 3'b010) ;
    }
    cross_100_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_100_sfd = cross_100_sfd with (speed_cp != 3'b010) ;
    }
    cross_100_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_100_fc_rdy_drop = cross_100_fc_rdy_drop with (speed_cp != 3'b010) ;
    }
    cross_100_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_100_phyrefclk = cross_100_phyrefclk with (speed_cp != 3'b010) ;
    }
    cross_100_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_100_ipg = cross_100_ipg with (speed_cp != 3'b010) ;
    }



    cross_50_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_50_ifc = cross_50_ifc with (speed_cp != 3'b011) ;
    }
    cross_50_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_50_fec = cross_50_fec with (speed_cp != 3'b011) ;
    }
    cross_50_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_50_trans_type = cross_50_trans_type with (speed_cp != 3'b011) ;
    }
    cross_50_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_50_en_async = cross_50_en_async with (speed_cp != 3'b011) ;
    }
    cross_50_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_50_s_preamble = cross_50_s_preamble with (speed_cp != 3'b011) ;
    }
    cross_50_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_50_fc = cross_50_fc with (speed_cp != 3'b011) ;
    }
    cross_50_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_50_rxvlan = cross_50_rxvlan with (speed_cp != 3'b011) ;
    }
    cross_50_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_50_txvlan = cross_50_txvlan with (speed_cp != 3'b011) ;
    }
    cross_50_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_50_rdy_lat = cross_50_rdy_lat with (speed_cp != 3'b011) ;
    }
    cross_50_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_50_rxbyte_rem = cross_50_rxbyte_rem with (speed_cp != 3'b011) ;
    }
    cross_50_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_50_lf = cross_50_lf with (speed_cp != 3'b011) ;
    }
    cross_50_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_50_rx_fc_fwd = cross_50_rx_fc_fwd with (speed_cp != 3'b011) ;
    }
    cross_50_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_50_sa = cross_50_sa with (speed_cp != 3'b011) ;
    }
    cross_50_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_50_en_mx_frsz = cross_50_en_mx_frsz with (speed_cp != 3'b011) ;
    }
    cross_50_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_50_pp = cross_50_pp with (speed_cp != 3'b011) ;
    }
    cross_50_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_50_sfd = cross_50_sfd with (speed_cp != 3'b011) ;
    }
    cross_50_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_50_fc_rdy_drop = cross_50_fc_rdy_drop with (speed_cp != 3'b011) ;
    }
    cross_50_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_50_phyrefclk = cross_50_phyrefclk with (speed_cp != 3'b011) ;
    }
    cross_50_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_50_ipg = cross_50_ipg with (speed_cp != 3'b011) ;
    }



    cross_40_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_40_ifc = cross_40_ifc with (speed_cp != 3'b100) ;
    }
    cross_40_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_40_fec = cross_40_fec with (speed_cp != 3'b100) ;
    }
    cross_40_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_40_trans_type = cross_40_trans_type with (speed_cp != 3'b100) ;
    }
    cross_40_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_40_en_async = cross_40_en_async with (speed_cp != 3'b100) ;
    }
    cross_40_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_40_s_preamble = cross_40_s_preamble with (speed_cp != 3'b100) ;
    }
    cross_40_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_40_fc = cross_40_fc with (speed_cp != 3'b100) ;
    }
    cross_40_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_40_rxvlan = cross_40_rxvlan with (speed_cp != 3'b100) ;
    }
    cross_40_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_40_txvlan = cross_40_txvlan with (speed_cp != 3'b100) ;
    }
    cross_40_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_40_rdy_lat = cross_40_rdy_lat with (speed_cp != 3'b100) ;
    }
    cross_40_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_40_rxbyte_rem = cross_40_rxbyte_rem with (speed_cp != 3'b100) ;
    }
    cross_40_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_40_lf = cross_40_lf with (speed_cp != 3'b100) ;
    }
    cross_40_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_40_rx_fc_fwd = cross_40_rx_fc_fwd with (speed_cp != 3'b100) ;
    }
    cross_40_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_40_sa = cross_40_sa with (speed_cp != 3'b100) ;
    }
    cross_40_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_40_en_mx_frsz = cross_40_en_mx_frsz with (speed_cp != 3'b100) ;
    }
    cross_40_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_40_pp = cross_40_pp with (speed_cp != 3'b100) ;
    }
    cross_40_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_40_sfd = cross_40_sfd with (speed_cp != 3'b100) ;
    }
    cross_40_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_40_fc_rdy_drop = cross_40_fc_rdy_drop with (speed_cp != 3'b100) ;
    }
    cross_40_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_40_phyrefclk = cross_40_phyrefclk with (speed_cp != 3'b100) ;
    }
    cross_40_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_40_ipg = cross_40_ipg with (speed_cp != 3'b100) ;
    }



    cross_25_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_25_ifc = cross_25_ifc with (speed_cp != 3'b101) ;
    }
    cross_25_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_25_fec = cross_25_fec with (speed_cp != 3'b101) ;
    }
    cross_25_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_25_trans_type = cross_25_trans_type with (speed_cp != 3'b101) ;
    }
    cross_25_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_25_en_async = cross_25_en_async with (speed_cp != 3'b101) ;
    }
    cross_25_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_25_s_preamble = cross_25_s_preamble with (speed_cp != 3'b101) ;
    }
    cross_25_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_25_fc = cross_25_fc with (speed_cp != 3'b101) ;
    }
    cross_25_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_25_rxvlan = cross_25_rxvlan with (speed_cp != 3'b101) ;
    }
    cross_25_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_25_txvlan = cross_25_txvlan with (speed_cp != 3'b101) ;
    }
    cross_25_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_25_rdy_lat = cross_25_rdy_lat with (speed_cp != 3'b101) ;
    }
    cross_25_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_25_rxbyte_rem = cross_25_rxbyte_rem with (speed_cp != 3'b101) ;
    }
    cross_25_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_25_lf = cross_25_lf with (speed_cp != 3'b101) ;
    }
    cross_25_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_25_rx_fc_fwd = cross_25_rx_fc_fwd with (speed_cp != 3'b101) ;
    }
    cross_25_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_25_sa = cross_25_sa with (speed_cp != 3'b101) ;
    }
    cross_25_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_25_en_mx_frsz = cross_25_en_mx_frsz with (speed_cp != 3'b101) ;
    }
    cross_25_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_25_pp = cross_25_pp with (speed_cp != 3'b101) ;
    }
    cross_25_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_25_sfd = cross_25_sfd with (speed_cp != 3'b101) ;
    }
    cross_25_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_25_fc_rdy_drop = cross_25_fc_rdy_drop with (speed_cp != 3'b101) ;
    }
    cross_25_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_25_phyrefclk = cross_25_phyrefclk with (speed_cp != 3'b101) ;
    }
    cross_25_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_25_ipg = cross_25_ipg with (speed_cp != 3'b101) ;
    }


    cross_10_ifc: cross speed_cp, ifc_cp {
      ignore_bins ignr_sp_10_ifc = cross_10_ifc with (speed_cp != 3'b110) ;
    }
    cross_10_fec: cross speed_cp, fec_type_cp {
      ignore_bins ignr_sp_10_fec = cross_10_fec with (speed_cp != 3'b110) ;
    }
    cross_10_trans_type: cross speed_cp, trans_type_cp {
      ignore_bins ignr_sp_10_trans_type = cross_10_trans_type with (speed_cp != 3'b110) ;
    }
    cross_10_en_async: cross speed_cp, en_async_adp_cp {
      ignore_bins ignr_sp_10_en_async = cross_10_en_async with (speed_cp != 3'b110) ;
    }
    cross_10_s_preamble : cross speed_cp, s_preamble_cp {
      ignore_bins ignr_sp_10_s_preamble = cross_10_s_preamble with (speed_cp != 3'b110) ;
    }
    cross_10_fc : cross speed_cp, fc_cp {
      ignore_bins ignr_sp_10_fc = cross_10_fc with (speed_cp != 3'b110) ;
    }
    cross_10_rxvlan : cross speed_cp, rxvlan_cp {
      ignore_bins ignr_sp_10_rxvlan = cross_10_rxvlan with (speed_cp != 3'b110) ;
    }
    cross_10_txvlan : cross speed_cp, txvlan_cp {
      ignore_bins ignr_sp_10_txvlan = cross_10_txvlan with (speed_cp != 3'b110) ;
    }
    cross_10_rdy_lat : cross speed_cp, rdy_lat_cp {
      ignore_bins ignr_sp_10_rdy_lat = cross_10_rdy_lat with (speed_cp != 3'b110) ;
    }
    cross_10_rxbyte_rem : cross speed_cp, rxbyte_rem_cp {
      ignore_bins ignr_sp_10_rxbyte_rem = cross_10_rxbyte_rem with (speed_cp != 3'b110) ;
    }
    cross_10_lf : cross speed_cp, lf_cp {
      ignore_bins ignr_sp_10_lf = cross_10_lf with (speed_cp != 3'b110) ;
    }
    cross_10_rx_fc_fwd : cross speed_cp, rx_fc_fwd_cp {
      ignore_bins ignr_sp_10_rx_fc_fwd = cross_10_rx_fc_fwd with (speed_cp != 3'b110) ;
    }
    cross_10_sa : cross speed_cp, sa_cp {
      ignore_bins ignr_sp_10_sa = cross_10_sa with (speed_cp != 3'b110) ;
    }
    cross_10_en_mx_frsz : cross speed_cp, en_mx_frsz_cp {
      ignore_bins ignr_sp_10_en_mx_frsz = cross_10_en_mx_frsz with (speed_cp != 3'b110) ;
    }
    cross_10_pp : cross speed_cp, preamble_passthrough_cp {
      ignore_bins ignr_sp_10_pp = cross_10_pp with (speed_cp != 3'b110) ;
    }
    cross_10_sfd : cross speed_cp, sfd_cp {
      ignore_bins ignr_sp_10_sfd = cross_10_sfd with (speed_cp != 3'b110) ;
    }
    cross_10_fc_rdy_drop : cross speed_cp, fc_rdy_drop_cp {
      ignore_bins ignr_sp_10_fc_rdy_drop = cross_10_fc_rdy_drop with (speed_cp != 3'b110) ;
    }
    cross_10_phyrefclk : cross speed_cp, phyrefclk_cp {
      ignore_bins ignr_sp_10_phyrefclk = cross_10_phyrefclk with (speed_cp != 3'b110) ;
    }
    cross_10_ipg : cross speed_cp, ipg_cp {
      ignore_bins ignr_sp_10_ipg = cross_10_ipg with (speed_cp != 3'b110) ;
    }*/


  endgroup

endclass
