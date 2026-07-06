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


class eth_ptp_rx_user_flow_sequence extends eth_base_sequence;
  `uvm_object_utils(eth_ptp_rx_user_flow_sequence)

  `include "eth_f_ptp_fw_vl_calc.sv"
  // Firmware
  // Common TX & RX
  localparam  PL = 8;
  localparam  VL = 20;
  localparam  FL = 16;

  // RX
  //logic         [3:0]  pl_fl_map;
  int  pl_fl_map;
  logic [15:0]  [14:0] rx_fec_cw_pos_fl;
  logic [15:0]  [3:0]  rx_fec_ln_mapping_fl;
  logic [FL-1:0][14:0] rx_fec_cw_pos;
  logic [FL-1:0][3:0]  rx_fec_ln_mapping; //unused
  logic [FL-1:0][30:0] rx_xcvr_if_pulse_adj = 0;
  logic         [30:0] rx_const_delay;
  logic                rx_const_delay_sign;
  logic [PL-1:0][30:0] rx_apulse_offset;
  logic [PL-1:0]       rx_apulse_offset_sign;
  logic [PL-1:0][19:0] rx_apulse_wdelay;
  logic [PL-1:0][28:0] rx_apulse_time;
  logic         [28:0] rx_apulse_time_max;
  logic         [2:0]  cw_pos_upper_bit;
  logic [20-1:0] rx_spulse_offset_sign = 0;
  logic [20-1:0][31:0] rx_spulse_offset;
  logic         [2:0]  rx_ref_pl;
  logic         [3:0]  rx_ref_fl;
  logic         [4:0]  rx_ref_vl;
  logic [20-1:0][31:0] rx_am_actual_time;
  logic         [31:0] rx_am_actual_time_max;
  logic         [31:0] rx_am_actual_time_min;
  logic         [31:0] rx_tam_adjust;
  logic         [31:0] rx_tam_adjust_2c;
  logic         [31:0] rx_external_phy_delay = 0; // standardize magnitude-only signal to have 2^n number of bits
  logic         [31:0] rx_pma_delay_ui; // standardize magnitude-only signal to have 2^n number of bits
  logic         [31:0] rx_pma_delay_ns; // some variant needs 32bits (4bits ns)
  logic         [31:0] rx_extra_latency;
  logic [VL-1:0][31:0] rx_vl_offset;
  logic         [31:0] rx_data_const_delay, rx_apulse_data_offset;
  logic         [6:0]  rx_pcs_bitslip_cnt;
  logic                rx_pcs_dlpulse_aligned;
  logic [20-1:0][1:0]  rx_vl_local_pl;
  logic         [4:0]  rx_am_maxtime_loop_cnt;
  logic         [4:0]  rx_ref_maxtime;
  logic         [6:0]  rx_pcs_dlpulse_cnt;
  logic         [34:0] bslip_p_dlpulse;
  uvm_status_e  status;
  bit[31:0] read_data;
  eth_ptp_xcvr_config_sequence eth_ptp_xcvr_config_sequence_i;

  //=====================Test local Macro Start=========================================//
`define write_ptp_rx_lane_cal_data(LANE) \
    p_sequencer.env.reg_model.ptp_rx_lane``LANE``_calc_data_offset.read(status, read_data); \
    #100ns; \
    rx_apulse_data_offset = p_sequencer.env.reg_model.ptp_rx_lane``LANE``_calc_data_offset.data_offset.get(); \
    rx_apulse_offset     [``LANE``]   = rx_apulse_data_offset[30:0]; \
    rx_apulse_offset_sign[``LANE``]   = rx_apulse_data_offset[31]; \
    p_sequencer.env.reg_model.ptp_rx_lane``LANE``_calc_data_wiredelay.read(status, read_data); \
    #100ns; \
    rx_apulse_wdelay     [``LANE``]   = p_sequencer.env.reg_model.ptp_rx_lane``LANE``_calc_data_wiredelay.data_wiredelay.get(); \
    p_sequencer.env.reg_model.ptp_rx_lane``LANE``_calc_data_time.read(status, read_data); \
    #100ns; \
    rx_apulse_time       [``LANE``]   = p_sequencer.env.reg_model.ptp_rx_lane``LANE``_calc_data_time.data_time.get();  

`define write_mac_cfg_rx_ptp_vl_offset(SPEED, VL) \
    do begin \
	p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_vl_offset_``VL``.vl_offset.set(rx_vl_offset[``VL``]);   \
    end while (p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_vl_offset_``VL``.vl_offset.get() != rx_vl_offset[``VL``]);   \
    p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_vl_offset_``VL``.write(status, p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_vl_offset_``VL``.get());   

`define poll_rx_pcs_aligned_nofec(SPEED) \
    do begin \
       p_sequencer.env.reg_model.``SPEED``_ehip_stats_phy_rxpcs_status.read(status, read_data); \
       #100ns; \
    end \
    while (p_sequencer.env.reg_model.``SPEED``_ehip_stats_phy_rxpcs_status.rx_aligned.get()==0); 

`define poll_rx_pcs_aligned_fec(SPEED, LANE) \
    do begin \
       p_sequencer.env.reg_model.``SPEED``_fec_stats_e25g_stat_s``LANE``_rsfec_aggr_rx_stat.read(status, read_data); \
       #100ns; \
    end \
    while (p_sequencer.env.reg_model.``SPEED``_fec_stats_e25g_stat_s``LANE``_rsfec_aggr_rx_stat.not_align.get()==1); 

`define get_rsfec_cw_ln_mapping(SPEED, VL) \
    p_sequencer.env.reg_model.``SPEED``_fec_stats_e25g_stat_s``VL``_rsfec_cw_pos_rx.read(status, read_data); \
    #100ns; \
    rx_fec_cw_pos_fl   [``VL``] = p_sequencer.env.reg_model.``SPEED``_fec_stats_e25g_stat_s``VL``_rsfec_cw_pos_rx.num.get(); 
    //p_sequencer.env.reg_model.``SPEED``_fec_stats_e25g_stat_s``VL``_rsfec_ln_mapping_rx.read(status, read_data); \
    //#100ns; \
    //rx_fec_ln_mapping_fl[``VL``] = p_sequencer.env.reg_model.``SPEED``_fec_stats_e25g_stat_s``VL``_rsfec_ln_mapping_rx.fec_lane.get(); 

`define wr_rx_extra_lat(SPEED) \
    do begin \
        p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_extra_latency.extra_latency.set(rx_extra_latency); \
        #100ns; \
    end while (p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_extra_latency.extra_latency.get() != rx_extra_latency); \
    p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_extra_latency.write(status, p_sequencer.env.reg_model.``SPEED``_mac_cfg_rx_ptp_extra_latency.get());

`define get_ehip_stats_ptp_vl_data_hi(SPEED, VL) \
    p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.read(status, read_data); \
    rx_pcs_vl_data_hi[``VL``].ptp_al_pos_50g           = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.ptp_al_pos_50g.get(); \
    rx_pcs_vl_data_hi[``VL``].local_vl                 = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.local_vl.get(); \
    rx_pcs_vl_data_hi[``VL``].local_pl                 = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.local_pl.get(); \
    rx_pcs_vl_data_hi[``VL``].vlane_num                = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.vlane_num.get(); \
    rx_pcs_vl_data_hi[``VL``].ptp_gb33to66_occupancy   = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.ptp_gb33to66_occupancy.get(); \
    rx_pcs_vl_data_hi[``VL``].ptp_gb110_occupancy      = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.ptp_gb110_occupancy.get(); \
    rx_pcs_vl_data_hi[``VL``].ptp_am_detect_occupancy  = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.ptp_am_detect_occupancy.get(); \
    rx_pcs_vl_data_hi[``VL``].ptp_blk_align_occupancy  = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.ptp_blk_align_occupancy.get(); \
    rx_pcs_vl_data_hi[``VL``].spare                    = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_hi_``VL``.Spare.get();

`define get_ehip_stats_ptp_vl_data_lo(SPEED, VL) \
    p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.read(status, read_data); \
    rx_pcs_vl_data_lo[``VL``].local_vl                = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.local_vl.get(); \
    rx_pcs_vl_data_lo[``VL``].ptp_am_count            = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.ptp_am_count.get(); \
    rx_pcs_vl_data_lo[``VL``].ptp_al_pos              = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.ptp_al_pos.get(); \
    rx_pcs_vl_data_lo[``VL``].ptp_al_blk_phase        = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.ptp_al_blk_phase.get(); \
    rx_pcs_vl_data_lo[``VL``].ptp_gbstate             = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.ptp_gbstate.get(); \
    rx_pcs_vl_data_lo[``VL``].spare                   = p_sequencer.env.reg_model.``SPEED``_ehip_stats_ptp_vl_data_lo_``VL``.spare.get();

  //=====================Test local Macro End=========================================//


 function new(string name = "eth_ptp_rx_user_flow_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 task body();
    // Firmware
    // Common TX & RX
    int var_PL;
    int var_VL;
    int var_FL;
    int var_SPEED;
    logic [27:0] ui;
    
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_10G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 1;
	var_SPEED = 10;
        ui = 28'h18D3019;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 1;
	var_SPEED = 25;
	ui = 32'h9EE00A;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 4;
	var_SPEED = 50;
        ui = 28'h04D19EC;	
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
	var_PL = 2;
	var_VL = 4;
	var_SPEED = 50;
	if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==RSFECKP) begin
	    ui = 28'h09A33CD;
	end
	else begin
	    ui = 28'h09EE00A;
	end
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 20;
	var_SPEED = 100;
        ui = 28'h0268CF3;	
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
	var_PL = 2;
	var_VL = 20;
	var_SPEED = 100;
        ui = 28'h04D19EC;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
	var_PL = 4;
	var_VL = 20;
	var_SPEED = 100;
	if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==RSFECKP) begin
	    ui = 28'h09A33CD;
	end
	else begin
	    ui = 28'h09EE00A;
	end
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
	var_PL = 8;
	var_VL = 8;
	var_SPEED = 200;
        ui = 28'h09A33CD;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
	var_PL = 4;
	var_VL = 8;
	var_SPEED = 200;
        ui = 28'h04D19EC;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
	var_PL = 2;
	var_VL = 8;
	var_SPEED = 200;
        ui = 28'h0268CF3;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
	var_PL = 8;
	var_VL = 16;
	var_SPEED = 400;
	ui = 32'h4D19EC;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
	var_PL = 4;
	var_VL = 16;
	var_SPEED = 400;
        ui = 28'h0268CF3;	
    end

    //Var_FL (AIB_LANES) calculation
    var_FL = var_SPEED/25;
    
   // PMA Delays 1: Barak; 0: UX
   if (p_sequencer.env.dyn_rcfg_obj_inst.trans_type == 1) begin //BARAK
      rx_pma_delay_ui = 358;
      
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         //NA, only with UX
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin 
         rx_pma_delay_ui = 1037;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin 
         //NA, only with UX
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin  
         rx_pma_delay_ui = 589;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         rx_pma_delay_ui = 1037;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
         rx_pma_delay_ui = 295;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         rx_pma_delay_ui = 589;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         rx_pma_delay_ui = 1037;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
         rx_pma_delay_ui = 295;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         rx_pma_delay_ui = 589;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
         rx_pma_delay_ui = 295;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_10G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         //NA, only with UX
      end
       
   end
   else if (p_sequencer.env.dyn_rcfg_obj_inst.trans_type == 0) begin //UX
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         rx_pma_delay_ui = 176;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin 
         //NA, only with Barak
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         rx_pma_delay_ui = 88;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
         rx_pma_delay_ui = 176;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         //NA, only with Barak
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
         rx_pma_delay_ui = 88;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
         rx_pma_delay_ui = 176;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         //NA, only with Barak	
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
         rx_pma_delay_ui = 88;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
         rx_pma_delay_ui = 176;	
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
         rx_pma_delay_ui = 88;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_10G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
         rx_pma_delay_ui = 88;
      end      
       
       
   end
   `uvm_info("body", "started eth_ptp_rx_user_flow_sequence ...", UVM_NONE)

    // Step 1
    // After power up, reset or link down, wait until RX PCS is fully aligned
    `uvm_info("body", "Poll for RX PCS aligned ...", UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin
	`poll_rx_pcs_aligned_nofec(e25)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) begin
	if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	    `poll_rx_pcs_aligned_nofec(e50)
	end else begin
	    `poll_rx_pcs_aligned_fec(e50,0)
        end
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
	if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	    `poll_rx_pcs_aligned_nofec(e100)
	end else begin
	    `poll_rx_pcs_aligned_fec(e100,0)
        end
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G) begin
	if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	    `poll_rx_pcs_aligned_nofec(e200)
	end else begin
	    `poll_rx_pcs_aligned_fec(e200,0)
        end
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
        if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	    `poll_rx_pcs_aligned_nofec(e400)
        end else begin
	    `poll_rx_pcs_aligned_fec(e400,0)
        end
    end 

    // Step 2
    // Configure RX FEC codeword position into transceiver
    // Step 2a
    // Read RX FEC codeword position and FEC lane mapping for each PMA lane
    // Determine mapping from PMA lane to FEC lane
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type!=NOFEC) begin

	//For FEC Variants
	//Note: FEC Lane Number: 400G --> 16; 200G --> 8; 100G --> 4; 50G --> 2; 25G --> 1 
	`uvm_info("body", "Determine mapping from PMA to FEC Lane ...", UVM_NONE)
       if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G,_10G}) begin
	    `get_rsfec_cw_ln_mapping(e25,0)
	end 
	else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) begin
	    `get_rsfec_cw_ln_mapping(e50,0)
	    `get_rsfec_cw_ln_mapping(e50,1)
	end 
	else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
	    `get_rsfec_cw_ln_mapping(e100,0)
	    `get_rsfec_cw_ln_mapping(e100,1)
	    `get_rsfec_cw_ln_mapping(e100,2)
	    `get_rsfec_cw_ln_mapping(e100,3)
	end 
	else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G) begin
	    `get_rsfec_cw_ln_mapping(e200,0)
	    `get_rsfec_cw_ln_mapping(e200,1)
	    `get_rsfec_cw_ln_mapping(e200,2)
	    `get_rsfec_cw_ln_mapping(e200,3)
	    `get_rsfec_cw_ln_mapping(e200,4)
	    `get_rsfec_cw_ln_mapping(e200,5)
	    `get_rsfec_cw_ln_mapping(e200,6)
	    `get_rsfec_cw_ln_mapping(e200,7)
	end 
	else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
	    `get_rsfec_cw_ln_mapping(e400,0)
	    `get_rsfec_cw_ln_mapping(e400,1)
	    `get_rsfec_cw_ln_mapping(e400,2)
	    `get_rsfec_cw_ln_mapping(e400,3)
	    `get_rsfec_cw_ln_mapping(e400,4)
	    `get_rsfec_cw_ln_mapping(e400,5)
	    `get_rsfec_cw_ln_mapping(e400,6)
	    `get_rsfec_cw_ln_mapping(e400,7)
	    `get_rsfec_cw_ln_mapping(e400,8)
	    `get_rsfec_cw_ln_mapping(e400,9)
	    `get_rsfec_cw_ln_mapping(e400,10)
	    `get_rsfec_cw_ln_mapping(e400,11)
	    `get_rsfec_cw_ln_mapping(e400,12)
	    `get_rsfec_cw_ln_mapping(e400,13)
	    `get_rsfec_cw_ln_mapping(e400,14)
	    `get_rsfec_cw_ln_mapping(e400,15)
	end 

	pl_fl_map = var_SPEED / 25 / var_PL;

	for (int fl = 0; fl < var_FL; fl++) begin
	    rx_fec_cw_pos[fl]       = rx_fec_cw_pos_fl[fl][14:0];
	end

	// Step 2b
	// Calculate pulse adjustments
	for (int fl = 0; fl < var_FL; fl++) begin
	    rx_xcvr_if_pulse_adj[fl] = rx_fec_cw_pos[fl];
	end

	// Step 2c
	// Write the pulse adjustments into IP
	`uvm_do_with(eth_ptp_xcvr_config_sequence_i, {foreach (i_rx_xcvr_if_pulse_adj[i]) i_rx_xcvr_if_pulse_adj[i] == rx_xcvr_if_pulse_adj[i]; i_rx_pl_fl_map == pl_fl_map;}) 


	// Step 2d
	// Notify soft PTP that pulse adjustments have been configured
	`uvm_info("body", "Write RX FEC CW POS CFG Done ...", UVM_NONE)
	do begin
	    p_sequencer.env.reg_model.ptp_rx_user_cfg_status.rx_fec_cw_pos_cfg_done.set(1);
	    #100ns;
	end while (p_sequencer.env.reg_model.ptp_rx_user_cfg_status.rx_fec_cw_pos_cfg_done.get()==0);
	p_sequencer.env.reg_model.ptp_rx_user_cfg_status.write(status, p_sequencer.env.reg_model.ptp_rx_user_cfg_status.get());

    end
    else begin
	rx_fec_cw_pos_fl     = '{default:15'h0000};				
	rx_xcvr_if_pulse_adj = '{default:31'h0000_0000};		
    end

    // Step 3
    // Wait until RX raw offset data are ready
    `uvm_info("body", "Poll for RX PTP Offset Data valid ...", UVM_NONE)
    do begin
	p_sequencer.env.reg_model.ptp_status.read(status, read_data);
	#100ns;
    end
    while (p_sequencer.env.reg_model.ptp_status.rx_ptp_offset_data_valid.get()==0);

    // Step 4
    // Read RX raw offset data from IP
    `uvm_info("body", "Read RX Raw Offset Data ...", UVM_NONE)
    do begin
        p_sequencer.env.reg_model.ptp_rx_lane_calc_data_constdelay.read(status, read_data);
        #100ns;
    end
    while (p_sequencer.env.reg_model.ptp_rx_lane_calc_data_constdelay.data_constdelay.get()==0);
    rx_data_const_delay = p_sequencer.env.reg_model.ptp_rx_lane_calc_data_constdelay.data_constdelay.get();
    rx_const_delay      = rx_data_const_delay[30:0];
    rx_const_delay_sign = rx_data_const_delay[31];

    `uvm_info("body", "Write RX PTP Lane Cal Data ...", UVM_NONE)
    //Lane 0
    `write_ptp_rx_lane_cal_data(0)
    //Lane 1
    if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {2, 4, 8}) begin
	`write_ptp_rx_lane_cal_data(1)
    end

    //Lane 2, 3
    if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {4, 8}) begin
	`write_ptp_rx_lane_cal_data(2)
	`write_ptp_rx_lane_cal_data(3)
    end

    //Lane 4, 5, 6, 7
    if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {8}) begin
	`write_ptp_rx_lane_cal_data(4)
	`write_ptp_rx_lane_cal_data(5)
	`write_ptp_rx_lane_cal_data(6)
	`write_ptp_rx_lane_cal_data(7)
    end

    // For 10G/25G No Fec
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G} && p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
        p_sequencer.env.reg_model.e25_ehip_stats_pcs_bitslip_cnt.read(status, read_data);
	rx_pcs_bitslip_cnt = p_sequencer.env.reg_model.e25_ehip_stats_pcs_bitslip_cnt.bitslip_cnt.get();
	rx_pcs_dlpulse_aligned = p_sequencer.env.reg_model.e25_ehip_stats_pcs_bitslip_cnt.dlpulse_alignment.get();
    end

    // Step 5
    // Determine RX reference lane
    // Step 5a
    // Determine sync pulse (Alignment Marker) offsets with reference to async pulse
    cw_pos_upper_bit    = 5;  
                                            
   if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
      if(p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_100G, _50G}) begin
         if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) begin
            `get_ehip_stats_ptp_vl_data_hi(e50, 0)
            `get_ehip_stats_ptp_vl_data_hi(e50, 1)
            `get_ehip_stats_ptp_vl_data_hi(e50, 2)
            `get_ehip_stats_ptp_vl_data_hi(e50, 3)
            `get_ehip_stats_ptp_vl_data_lo(e50, 0)
            `get_ehip_stats_ptp_vl_data_lo(e50, 1)
            `get_ehip_stats_ptp_vl_data_lo(e50, 2)
            `get_ehip_stats_ptp_vl_data_lo(e50, 3)
         end else begin
            `get_ehip_stats_ptp_vl_data_hi(e100, 0)
            `get_ehip_stats_ptp_vl_data_hi(e100, 1)
            `get_ehip_stats_ptp_vl_data_hi(e100, 2)
            `get_ehip_stats_ptp_vl_data_hi(e100, 3)
            `get_ehip_stats_ptp_vl_data_hi(e100, 4)
            `get_ehip_stats_ptp_vl_data_hi(e100, 5)
            `get_ehip_stats_ptp_vl_data_hi(e100, 6)
            `get_ehip_stats_ptp_vl_data_hi(e100, 7)
            `get_ehip_stats_ptp_vl_data_hi(e100, 8)
            `get_ehip_stats_ptp_vl_data_hi(e100, 9)
            `get_ehip_stats_ptp_vl_data_hi(e100, 10)
            `get_ehip_stats_ptp_vl_data_hi(e100, 11)
            `get_ehip_stats_ptp_vl_data_hi(e100, 12)
            `get_ehip_stats_ptp_vl_data_hi(e100, 13)
            `get_ehip_stats_ptp_vl_data_hi(e100, 14)
            `get_ehip_stats_ptp_vl_data_hi(e100, 15)
            `get_ehip_stats_ptp_vl_data_hi(e100, 16)
            `get_ehip_stats_ptp_vl_data_hi(e100, 17)
            `get_ehip_stats_ptp_vl_data_hi(e100, 18)
            `get_ehip_stats_ptp_vl_data_hi(e100, 19)
            `get_ehip_stats_ptp_vl_data_lo(e100, 0)
            `get_ehip_stats_ptp_vl_data_lo(e100, 1)
            `get_ehip_stats_ptp_vl_data_lo(e100, 2)
            `get_ehip_stats_ptp_vl_data_lo(e100, 3)
            `get_ehip_stats_ptp_vl_data_lo(e100, 4)
            `get_ehip_stats_ptp_vl_data_lo(e100, 5)
            `get_ehip_stats_ptp_vl_data_lo(e100, 6)
            `get_ehip_stats_ptp_vl_data_lo(e100, 7)
            `get_ehip_stats_ptp_vl_data_lo(e100, 8)
            `get_ehip_stats_ptp_vl_data_lo(e100, 9)
            `get_ehip_stats_ptp_vl_data_lo(e100, 10)
            `get_ehip_stats_ptp_vl_data_lo(e100, 11)
            `get_ehip_stats_ptp_vl_data_lo(e100, 12)
            `get_ehip_stats_ptp_vl_data_lo(e100, 13)
            `get_ehip_stats_ptp_vl_data_lo(e100, 14)
            `get_ehip_stats_ptp_vl_data_lo(e100, 15)
            `get_ehip_stats_ptp_vl_data_lo(e100, 16)
            `get_ehip_stats_ptp_vl_data_lo(e100, 17)
            `get_ehip_stats_ptp_vl_data_lo(e100, 18)
            `get_ehip_stats_ptp_vl_data_lo(e100, 19)
         end
         for (int vl = 0; vl < var_VL; vl++) begin
            generate_vl_data(rx_pcs_vl_data_hi[vl], rx_pcs_vl_data_lo[vl]);
            rx_spulse_offset[vl]    = 64'(((2560*66) - rx_non_fec_vl_offset[vl][31:0]) * ui) >> (28 - 16); // HW to use different value than 2560
            rx_vl_local_pl[vl]	   = rx_non_fec_vl_local_pl[vl]; 
         end
      end else begin //For 25G ( can be negative - need to support)
            rx_pcs_dlpulse_cnt = rx_pcs_dlpulse_aligned ? 7'd33 : 7'd0;            
            bslip_p_dlpulse          = 35'((rx_pcs_bitslip_cnt + rx_pcs_dlpulse_cnt) * ui);
            rx_spulse_offset[0]      = {8'h00, bslip_p_dlpulse[34:12]}; // bslip_p_dlpulse >> (28 - 16)
            rx_spulse_offset_sign[0] = 1'b0;


            //if (rx_pcs_bitslip_cnt > (rx_pcs_dlpulse_aligned*33)) begin // positive
            //    rx_spulse_offset[0]      = ((rx_pcs_bitslip_cnt - rx_pcs_dlpulse_aligned*33) * ui) >> (28 - 16); // (rx_pcs_bitslip_cnt - rx_pcs_dlpulse_aligned ? 33 : 0) * ui;
            //    rx_spulse_offset_sign[0] = 1'b0;
            //end
            //else begin // negative
            //    rx_spulse_offset[0]      = ((rx_pcs_dlpulse_aligned*33 - rx_pcs_bitslip_cnt) * ui) >> (28 - 16);
            //    rx_spulse_offset_sign[0] = 1'b1;
            //end
      end
   end else begin //For FEC

        for (int fl=0; fl<var_FL; fl++) begin
	    if ((rx_xcvr_if_pulse_adj[fl] + (rx_xcvr_if_pulse_adj[fl-(fl%pl_fl_map)]& {(cw_pos_upper_bit){1'b1}})) >  rx_xcvr_if_pulse_adj[fl-(fl% pl_fl_map)])begin
		rx_spulse_offset[fl]      = 43'((rx_xcvr_if_pulse_adj[fl] - rx_xcvr_if_pulse_adj[fl-(fl%pl_fl_map)] + 
		                            (rx_xcvr_if_pulse_adj[fl-(fl%pl_fl_map)]& {(cw_pos_upper_bit){1'b1}})) * ui * pl_fl_map) >> (28 - 16); 
		rx_spulse_offset_sign[fl] = 1'b0;
	    end
	    else begin
		rx_spulse_offset[fl]      = 43'((rx_xcvr_if_pulse_adj[fl-(fl%pl_fl_map)] - rx_xcvr_if_pulse_adj[fl] - 
		                            (rx_xcvr_if_pulse_adj[fl-(fl%pl_fl_map)]& {(cw_pos_upper_bit){1'b1}})) * ui * pl_fl_map) >> (28 - 16);  
		rx_spulse_offset_sign[fl] = 1'b1;
	    end
        end


   end

   //Step 5b
   //Detect rollover of async pulse time
   ptp_max_apluse_time(var_PL, rx_apulse_time, rx_apulse_time_max);
   for (int pl=0; pl<var_PL; pl++) begin
       if (rx_apulse_time_max - rx_apulse_time[pl] > 29'h01F4_0000)  begin // > 500ns
	   if (rx_apulse_time_max[27:24] == 4'hF) begin
	       rx_apulse_time[pl] = rx_apulse_time[pl] + 29'h1000_0000;			
	    end
	    else begin
		   rx_apulse_time[pl] = rx_apulse_time[pl] + 29'h0A00_0000;		
	    end	
	end
    end

   //Step 5c
   //Calculate actual time of RX Alignment Marker at RX PMA parallel data interface
   if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	for (int vl = 0; vl < var_VL; vl++) begin
            rx_am_actual_time[vl]   =     (rx_apulse_time[rx_vl_local_pl[vl]])
                                        + (rx_apulse_offset_sign[rx_vl_local_pl[vl]] ? -rx_apulse_offset[rx_vl_local_pl[vl]] : rx_apulse_offset[rx_vl_local_pl[vl]])
                                        - (rx_apulse_wdelay[rx_vl_local_pl[vl]])
                                        + (rx_spulse_offset_sign[vl] ? -rx_spulse_offset[vl]: rx_spulse_offset[vl]);
        end
    end 
    else begin //For FEC
	for (int fl = 0; fl < var_FL; fl++) begin
	    rx_am_actual_time[fl]   =     (rx_apulse_time[(fl-(fl%pl_fl_map))/pl_fl_map])
	                                + (rx_apulse_offset_sign[(fl-(fl%pl_fl_map))/pl_fl_map] ? -rx_apulse_offset[(fl-(fl%pl_fl_map))/pl_fl_map] : rx_apulse_offset[(fl-(fl%pl_fl_map))/pl_fl_map])
	                                - (rx_apulse_wdelay[(fl-(fl%pl_fl_map))/pl_fl_map])
                                        + (rx_spulse_offset_sign[fl] ? -rx_spulse_offset[fl]: rx_spulse_offset[fl]);
	end
    end


    // Step 5d
    // Determine RX reference lane
    if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	rx_am_maxtime_loop_cnt = var_VL;	
    end
    else begin
	rx_am_maxtime_loop_cnt = var_FL;	
    end 

    // Step 6
    // Calculate RX offsets
    // Step 6a
    // Calculate RX TAM adjust
   if(p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
      //skyeow: the following is needed for single lane and not PL=1. PL=1 of multilane still need to determine rx_ref_maxtime and rx_am_actual_time_max through ptp_max_ref_ln
      //if (var_PL == 1) begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}) begin
         rx_ref_vl = 0;
         rx_ref_pl = 0;
      end
      else begin
         ptp_max_ref_ln(rx_am_maxtime_loop_cnt, rx_am_actual_time, rx_am_actual_time_max, rx_ref_maxtime);	
         rx_ref_vl = rx_ref_maxtime;
         rx_ref_pl = rx_pcs_vl_data_hi[rx_ref_vl].local_pl;
      end
      rx_tam_adjust   =     (rx_const_delay_sign              ? -rx_const_delay              : rx_const_delay)
                          + (rx_apulse_offset_sign[rx_ref_pl] ? -rx_apulse_offset[rx_ref_pl] : rx_apulse_offset[rx_ref_pl])
                          - (rx_apulse_wdelay[rx_ref_pl])
                          + (rx_spulse_offset_sign[rx_ref_vl] ?  -rx_spulse_offset[rx_ref_vl] : rx_spulse_offset[rx_ref_vl]);        
   end
   else begin //FEC
      //skyeow: the following is needed for single lane and not PL=1. PL=1 of multilane still need to determine rx_ref_maxtime and rx_am_actual_time_max through ptp_max_ref_ln
      //if (var_PL == 1) begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_10G,_25G}) begin
         rx_ref_fl = 0;
         rx_ref_pl = 0;
      end
      else begin
         ptp_max_ref_ln(rx_am_maxtime_loop_cnt, rx_am_actual_time, rx_am_actual_time_max, rx_ref_maxtime);
	 rx_ref_fl = rx_ref_maxtime;
	 rx_ref_pl = (rx_ref_fl-(rx_ref_fl%pl_fl_map))/pl_fl_map;
      end
      rx_tam_adjust   =     (rx_const_delay_sign              ? -rx_const_delay              : rx_const_delay)
                          + (rx_apulse_offset_sign[rx_ref_pl] ? -rx_apulse_offset[rx_ref_pl] : rx_apulse_offset[rx_ref_pl])
                          - (rx_apulse_wdelay[rx_ref_pl])
                          + (rx_spulse_offset_sign[rx_ref_fl] ?  -rx_spulse_offset[rx_ref_fl] : rx_spulse_offset[rx_ref_fl]);        
   end

    // Convert to 2's complement for TAM adjust
    //rx_tam_adjust_2c = convert_2s_complement (rx_tam_adjust)
    rx_tam_adjust_2c    = rx_tam_adjust;


    // Step 6b
    // Calculate RX extra latency
    // Convert unit of RX PMA delay from UI to nanoseconds
    rx_pma_delay_ns = ((rx_pma_delay_ui * ui) >> (28 - 16));
    
    // Total up all extra latency together
    rx_extra_latency[30:0]  = rx_pma_delay_ns + rx_external_phy_delay;
    rx_extra_latency[31]    = 1'b1;

    // Step 6c
    // Calculate RX virtual lane offsets
    // Using determined reference virtual lane, assign RX virtual lane offset values as described in section 9.2.3.
    for (int vl = 0; vl < var_VL; vl++) begin
	
	//Non FEC Variant
	if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin 
	    if(p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G)begin
		rx_vl_offset[vl]    = 44'(ui / 2) >> (28 - 16);
	    end 
	    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G)begin
		rx_vl_offset[vl]    = 44'(2 * ui) >> (28 - 16);
	    end         
	end 
	//FEC Variant
	else if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type==RSFECKR) begin
	    rx_vl_offset[vl]    = 44'((vl - (vl % var_PL)) / var_PL * (66 * ui)) >> (28 - 16);
	end 
	else if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside {RSFECKP, LLFEC}) begin
	    rx_vl_offset[vl]    = 44'((vl - (vl % var_PL)) / var_PL * (68 * ui)) >> (28 - 16);
	end 
	else begin
	    rx_vl_offset[vl]    = 0;
	end
    end

    // Step 7
    // Write the determined RX reference lane into IP
    // This step need to skip for 10G and 25G
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_50G, _100G, _200G, _400G}) begin
	`uvm_info("body", "Write RX Reference Lane ...", UVM_NONE)
	do begin
	    p_sequencer.env.reg_model.ptp_ref_lane.rx_ref_lane.set(rx_ref_pl);
	    #100ns;
	end while (p_sequencer.env.reg_model.ptp_ref_lane.rx_ref_lane.get() != rx_ref_pl);
	p_sequencer.env.reg_model.ptp_ref_lane.write(status, p_sequencer.env.reg_model.ptp_ref_lane.get());
    end

    // Step 8
    // Write the calculated RX offsets to IP
    // Step 8a
    // Write RX virtual lane offsets
    // This step need to skip for 10G and 25G
    `uvm_info("body", "Write RX Virtual Lane Offsets ...", UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) begin
	`write_mac_cfg_rx_ptp_vl_offset(e50, 0)
	`write_mac_cfg_rx_ptp_vl_offset(e50, 1)
	`write_mac_cfg_rx_ptp_vl_offset(e50, 2)
	`write_mac_cfg_rx_ptp_vl_offset(e50, 3)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
	`write_mac_cfg_rx_ptp_vl_offset(e100, 0)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 1)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 2)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 3)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 4)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 5)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 6)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 7)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 8)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 9)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 10)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 11)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 12)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 13)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 14)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 15)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 16)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 17)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 18)
	`write_mac_cfg_rx_ptp_vl_offset(e100, 19)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G) begin
	`write_mac_cfg_rx_ptp_vl_offset(e200, 0)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 1)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 2)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 3)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 4)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 5)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 6)
	`write_mac_cfg_rx_ptp_vl_offset(e200, 7)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
	`write_mac_cfg_rx_ptp_vl_offset(e400, 0)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 1)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 2)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 3)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 4)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 5)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 6)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 7)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 8)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 9)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 10)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 11)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 12)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 13)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 14)
	`write_mac_cfg_rx_ptp_vl_offset(e400, 15)
    end 

    // Step 8b
    // Write RX extra latency
    `uvm_info("body", "Write RX Extra Latency ...", UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G, _10G}) begin
	`wr_rx_extra_lat(e25)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) begin
	`wr_rx_extra_lat(e50)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
	`wr_rx_extra_lat(e100)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G) begin
	`wr_rx_extra_lat(e200)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
	`wr_rx_extra_lat(e400)
    end 

    // Step 8c
    // Write RX TAM adjust 
    `uvm_info("body", "Write RX Tam Adjust ...", UVM_NONE)
    do begin
	p_sequencer.env.reg_model.ptp_rx_tam_adjust.tam_adjust.set(rx_tam_adjust_2c);
	#100ns;
    end while (p_sequencer.env.reg_model.ptp_rx_tam_adjust.tam_adjust.get() != rx_tam_adjust_2c);
    p_sequencer.env.reg_model.ptp_rx_tam_adjust.write(status, p_sequencer.env.reg_model.ptp_rx_tam_adjust.get());

    `uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: rx_const_delay = 'h%h", rx_const_delay[30:0]), UVM_MEDIUM);
    `uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: rx_const_delay_sign = 'h%h", rx_const_delay_sign), UVM_MEDIUM);
    for(int pl; pl < var_PL; pl++) begin
	`uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; rx_fec_cw_pos = 'h%h", pl, rx_fec_cw_pos[pl][14:0]), UVM_MEDIUM);
	`uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; rx_apulse_offset = 'h%h", pl, rx_apulse_offset[pl][30:0]), UVM_MEDIUM);
	`uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; rx_apulse_offset_sign = 'h%h", pl, rx_apulse_offset_sign[pl]), UVM_MEDIUM);
	`uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; rx_apulse_wdelay = 'h%h", pl, rx_apulse_wdelay[pl][19:0]), UVM_MEDIUM);
    end
    `uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: rx_tam_adjust = 'h%h", rx_tam_adjust[31:0]), UVM_MEDIUM);
    `uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: rx_tam_adjust_2c = 'h%h", rx_tam_adjust_2c[31:0]), UVM_MEDIUM);
    `uvm_info("eth_ptp_rx_user_flow_sequence", $sformatf("GDR_PTP_INFO: rx_extra_latency = 'h%h", rx_extra_latency[31:0]), UVM_MEDIUM);



//  p_sequencer.env.spy_if.pl_fl_map = pl_fl_map;
  p_sequencer.env.spy_if.rx_fec_cw_pos_fl = rx_fec_cw_pos_fl;
  p_sequencer.env.spy_if.rx_fec_ln_mapping_fl = rx_fec_ln_mapping_fl;
  p_sequencer.env.spy_if.rx_fec_cw_pos = rx_fec_cw_pos;
  p_sequencer.env.spy_if.rx_fec_ln_mapping = rx_fec_ln_mapping;
  p_sequencer.env.spy_if.rx_xcvr_if_pulse_adj = rx_xcvr_if_pulse_adj;
  p_sequencer.env.spy_if.rx_const_delay = rx_const_delay;
  p_sequencer.env.spy_if.rx_const_delay_sign = rx_const_delay_sign;
  p_sequencer.env.spy_if.rx_apulse_offset = rx_apulse_offset;
  p_sequencer.env.spy_if.rx_apulse_offset_sign = rx_apulse_offset_sign;
  p_sequencer.env.spy_if.rx_apulse_wdelay = rx_apulse_wdelay;
  p_sequencer.env.spy_if.rx_apulse_time = rx_apulse_time;
  p_sequencer.env.spy_if.cw_pos_upper_bit = cw_pos_upper_bit;
  p_sequencer.env.spy_if.rx_spulse_offset_sign = rx_spulse_offset_sign;
  p_sequencer.env.spy_if.rx_spulse_offset = rx_spulse_offset;
  p_sequencer.env.spy_if.rx_ref_pl = rx_ref_pl;
  p_sequencer.env.spy_if.rx_ref_fl = rx_ref_fl;
  p_sequencer.env.spy_if.rx_ref_vl = rx_ref_vl;
  p_sequencer.env.spy_if.rx_am_actual_time = rx_am_actual_time;
  p_sequencer.env.spy_if.rx_am_actual_time_max = rx_am_actual_time_max;
  p_sequencer.env.spy_if.rx_am_actual_time_min = rx_am_actual_time_min;
  p_sequencer.env.spy_if.rx_tam_adjust = rx_tam_adjust;
  p_sequencer.env.spy_if.rx_tam_adjust_2c = rx_tam_adjust_2c;
  p_sequencer.env.spy_if.rx_external_phy_delay = rx_external_phy_delay;
  p_sequencer.env.spy_if.rx_pma_delay_ui = rx_pma_delay_ui;
  p_sequencer.env.spy_if.rx_pma_delay_ns = rx_pma_delay_ns;
  p_sequencer.env.spy_if.rx_extra_latency = rx_extra_latency;
  p_sequencer.env.spy_if.rx_vl_offset = rx_vl_offset;
  p_sequencer.env.spy_if.rx_data_const_delay = rx_data_const_delay;
  p_sequencer.env.spy_if.rx_apulse_data_offset = rx_apulse_data_offset;
  p_sequencer.env.spy_if.rx_pcs_bitslip_cnt = rx_pcs_bitslip_cnt;
  p_sequencer.env.spy_if.rx_pcs_dlpulse_aligned = rx_pcs_dlpulse_aligned;
  p_sequencer.env.spy_if.rx_vl_local_pl = rx_vl_local_pl;
  p_sequencer.env.spy_if.rx_am_maxtime_loop_cnt = rx_am_maxtime_loop_cnt;
  p_sequencer.env.spy_if.rx_ref_maxtime = rx_ref_maxtime;
  p_sequencer.env.spy_if.rx_non_fec_vl_offset = rx_non_fec_vl_offset;
  p_sequencer.env.spy_if.rx_non_fec_vl_local_pl = rx_non_fec_vl_local_pl;
  p_sequencer.env.spy_if.rx_non_fec_vl_remote_pl = rx_non_fec_vl_remote_pl;
  p_sequencer.env.spy_if.rx_pcs_dlpulse_cnt = rx_pcs_dlpulse_cnt;
  p_sequencer.env.spy_if.bslip_p_dlpulse = bslip_p_dlpulse;  
  


   //Step 10
   //Notify soft PTP that user flow configuration is completed
   //TODO: Need to use SIP register programming. Workaround currently while waiting for YY to provide new RAL file.
   //uvm_hdl_force("eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.i_rx_ptp_user_cfg_done",1'b1);
    `uvm_info("body", "Write RX User Cfg Done ...", UVM_NONE)
    do begin
	p_sequencer.env.reg_model.ptp_rx_user_cfg_status.rx_user_cfg_done.set(1);
	#100ns;
    end while (p_sequencer.env.reg_model.ptp_rx_user_cfg_status.rx_user_cfg_done.get() == 0);
    p_sequencer.env.reg_model.ptp_rx_user_cfg_status.write(status, p_sequencer.env.reg_model.ptp_rx_user_cfg_status.get());	
	
   
   //Step 11
   //Wait until RX PTP is ready
    `uvm_info("body", "Poll for RX PTP Ready is 1 ...", UVM_NONE)
    do begin
	p_sequencer.env.reg_model.ptp_status.read(status, read_data);
	#100ns;
    end while (p_sequencer.env.reg_model.ptp_status.rx_ptp_ready.get() != 1);


    `uvm_info("body", "Completed eth_ptp_rx_user_flow_sequence ...", UVM_NONE)
 endtask : body

 task ptp_max_ref_ln;
     input  logic [4:0]          num_entry;
     input  logic [20-1:0][31:0] am_actual_time;
     output logic [31:0]         am_actual_time_max;
     output logic [4:0]          ref_lane_idx;
     
     
     ref_lane_idx        = 0;
     am_actual_time_max  = am_actual_time[0];
     for (int x=1; x<num_entry; x++) begin
	 // Both negatives
	 if (am_actual_time[x][31] && am_actual_time_max[31]) begin
	     if (am_actual_time[x] > am_actual_time_max) begin
		 ref_lane_idx       = x;
		 am_actual_time_max = am_actual_time[x];
	     end
	 end
	 // One positive, one negative
	 else if (!am_actual_time[x][31] && am_actual_time_max[31]) begin
	     ref_lane_idx       = x;
	     am_actual_time_max = am_actual_time[x];

	 end
	 // One negative, one positive
	 else if (am_actual_time[x][31] && !am_actual_time_max[31]) begin
	     // No change
	 end
	 // Both positives
	 else begin
	     if (am_actual_time[x] > am_actual_time_max) begin
		 ref_lane_idx       = x;
		 am_actual_time_max = am_actual_time[x];
	     end
	 end		
     end			
 endtask : ptp_max_ref_ln
 task ptp_max_apluse_time;
     input  [4:0]          num_entry;
     input  [16-1:0][28:0] apulse_time;
     output [27:0]         apulse_time_max;
     
     apulse_time_max  = apulse_time[0];
     for (int x=1; x<num_entry; x++) begin
	 if (apulse_time[x] > apulse_time_max) begin
	     apulse_time_max = apulse_time[x];
	 end
     end				
endtask
endclass : eth_ptp_rx_user_flow_sequence
