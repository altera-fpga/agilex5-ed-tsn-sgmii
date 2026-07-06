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


class eth_ptp_tx_user_flow_sequence extends eth_base_sequence;
  `uvm_object_utils(eth_ptp_tx_user_flow_sequence)

  //Put as reference (set to Max after compare ETH8/9)
  localparam PL = 8;
  localparam VL = 20;

  logic         [30:0] tx_const_delay;
  logic                tx_const_delay_sign;
  logic [PL-1:0][30:0] tx_apulse_offset;
  logic [PL-1:0]       tx_apulse_offset_sign;
  logic [PL-1:0][19:0] tx_apulse_wdelay;
  logic [PL-1:0][28:0] tx_apulse_time;
  logic         [28:0] tx_apulse_time_max;
  logic         [2:0]  tx_ref_pl;
  logic [PL-1:0][31:0] tx_am_actual_time;
  logic         [31:0] tx_am_actual_time_max;
  logic         [31:0] tx_tam_adjust;
  logic         [31:0] tx_tam_adjust_2c;
  logic         [31:0] tx_external_phy_delay = 0; // standardize magnitude-only signal to have 2^n number of bits
  logic         [31:0] tx_pma_delay_ui; // standardize magnitude-only signal to have 2^n number of bits
  logic         [31:0] tx_pma_delay_ns; // some variant needs 32bits (4bits ns)
  logic         [31:0] tx_extra_latency;
  logic [VL-1:0][31:0] tx_vl_offset;
  logic[31:0] tx_data_const_delay, tx_apulse_data_offset;
  uvm_status_e  status;
  bit[31:0] read_data;

  //=====================Test local Macro Start=========================================//
`define write_mac_cfg_tx_ptp_vl_offset(SPEED, VL) \
    do begin \
	p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_vl_offset_``VL``.vl_offset.set(tx_vl_offset[``VL``]);   \
    end while (p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_vl_offset_``VL``.vl_offset.get() != tx_vl_offset[``VL``]);   \
    p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_vl_offset_``VL``.write(status, p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_vl_offset_``VL``.get());

    
`define write_ptp_tx_lane_cal_data(LANE) \
   p_sequencer.env.reg_model.ptp_tx_lane``LANE``_calc_data_offset.read(status, read_data); \
   #100ns; \
   tx_apulse_data_offset = p_sequencer.env.reg_model.ptp_tx_lane``LANE``_calc_data_offset.data_offset.get(); \
   tx_apulse_offset     [``LANE``]   = tx_apulse_data_offset[30:0]; \
   tx_apulse_offset_sign[``LANE``]   = tx_apulse_data_offset[31]; \
   p_sequencer.env.reg_model.ptp_tx_lane``LANE``_calc_data_wiredelay.read(status, read_data); \
   #100ns; \
   tx_apulse_wdelay     [``LANE``]   = p_sequencer.env.reg_model.ptp_tx_lane``LANE``_calc_data_wiredelay.data_wiredelay.get(); \
   p_sequencer.env.reg_model.ptp_tx_lane``LANE``_calc_data_time.read(status, read_data); \
   #100ns; \
   tx_apulse_time       [``LANE``]   = p_sequencer.env.reg_model.ptp_tx_lane``LANE``_calc_data_time.data_time.get();  

`define wr_tx_extra_lat(SPEED) \
do begin \
    p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_extra_latency.extra_latency.set(tx_extra_latency); \
    #100ns; \
end while (p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_extra_latency.extra_latency.get() != tx_extra_latency); \
p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_extra_latency.write(status, p_sequencer.env.reg_model.``SPEED``_mac_cfg_tx_ptp_extra_latency.get());

  //=====================Test local Macro End=========================================//


 function new(string name = "eth_ptp_tx_user_flow_sequence");
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
    logic [27:0] ui;

	
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_10G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 1;
        ui = 28'h18D3019;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 1;
	ui = 32'h9EE00A;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin
	var_PL = 1;
	var_VL = 4;
        ui = 28'h04D19EC;	
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
	var_PL = 2;
	var_VL = 4;
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
        ui = 28'h0268CF3;	
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
	var_PL = 2;
	var_VL = 20;
        ui = 28'h04D19EC;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
	var_PL = 4;
	var_VL = 20;
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
        ui = 28'h09A33CD;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
	var_PL = 4;
	var_VL = 8;
        ui = 28'h04D19EC;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin
	var_PL = 2;
	var_VL = 8;
        ui = 28'h0268CF3;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
	var_PL = 8;
	var_VL = 16;
	ui = 32'h4D19EC;
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin
	var_PL = 4;
	var_VL = 16;
        ui = 28'h0268CF3;	
    end 
    
   // PMA Delays 1: Barak; 0: UX
   if (p_sequencer.env.dyn_rcfg_obj_inst.trans_type == 1) begin // BARAK
      tx_pma_delay_ui = 120;
       
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         //NA, only with UX
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin 
         tx_pma_delay_ui = 1094;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin 
         //NA, only with UX
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin  
         tx_pma_delay_ui = 552;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         tx_pma_delay_ui = 1094;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin  
         tx_pma_delay_ui = 276;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         tx_pma_delay_ui = 552;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         tx_pma_delay_ui = 1094;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         tx_pma_delay_ui = 276;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         tx_pma_delay_ui = 552;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         tx_pma_delay_ui = 276;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_10G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         //NA, only with UX
      end 
   end
   else if (p_sequencer.env.dyn_rcfg_obj_inst.trans_type == 0) begin //UX
      if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         tx_pma_delay_ui = 158;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin 
         //NA, only with Barak
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin 
         tx_pma_delay_ui = 80;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin  
         tx_pma_delay_ui = 158;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         //NA, only with Barak
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 4) begin  
         tx_pma_delay_ui = 80;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         tx_pma_delay_ui = 158;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
          //NA, only with Barak	
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 2) begin  
         tx_pma_delay_ui = 80;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         tx_pma_delay_ui = 158;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         tx_pma_delay_ui = 80;
      end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_10G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1) begin  
         tx_pma_delay_ui = 80;
      end      
   end
    
   `uvm_info("body", "started eth_ptp_tx_user_flow_sequence ...", UVM_NONE)
    

   
   // Step 1
   // After power up or reset, wait until TX raw offset data are ready
   `uvm_info("body", "Poll for TX Raw Offset Data ready...", UVM_NONE)
   do begin
       p_sequencer.env.reg_model.ptp_status.read(status, read_data);
       #100ns;
   end
   while (p_sequencer.env.reg_model.ptp_status.tx_ptp_offset_data_valid.get()==0);

   // Step 2
   // Read TX raw offset data from IP
   `uvm_info("body", "Read TX Raw Offset Data ...", UVM_NONE)
   do begin
       p_sequencer.env.reg_model.ptp_tx_lane_calc_data_constdelay.read(status, read_data);
       #100ns;
   end
   while (p_sequencer.env.reg_model.ptp_tx_lane_calc_data_constdelay.data_constdelay.get()==0);
   tx_data_const_delay = p_sequencer.env.reg_model.ptp_tx_lane_calc_data_constdelay.data_constdelay.get();
   tx_const_delay      = tx_data_const_delay[30:0];
   tx_const_delay_sign = tx_data_const_delay[31];

  
   `uvm_info("body", "Write to TX Lane Cal Data ...", UVM_NONE)
   //Lane 0
   `write_ptp_tx_lane_cal_data(0)
   //Lane 1
   if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {2, 4, 8}) begin
       `write_ptp_tx_lane_cal_data(1)
   end
  
   //Lane 2, 3
   if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {4, 8}) begin
       `write_ptp_tx_lane_cal_data(2)
       `write_ptp_tx_lane_cal_data(3)
   end
  
   //Lane 4, 5, 6, 7
   if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {8}) begin
       `write_ptp_tx_lane_cal_data(4)
       `write_ptp_tx_lane_cal_data(5)
       `write_ptp_tx_lane_cal_data(6)
       `write_ptp_tx_lane_cal_data(7)
   end

    // Step 3
    // Determine TX reference lane
    // Step 3a
    //Detect rollover for asyncpulse time
    ptp_max_apluse_time(var_PL,tx_apulse_time,tx_apulse_time_max);

   for (int pl=0; pl<var_PL; pl++) begin
      if (tx_apulse_time_max - tx_apulse_time[pl] > 29'h01F4_0000)  begin // > 500ns
         if (tx_apulse_time_max[27:24] == 4'hF)
            tx_apulse_time[pl] = tx_apulse_time[pl] + 29'h1000_0000;
         else
            tx_apulse_time[pl] = tx_apulse_time[pl] + 29'h0A00_0000;
      end
   end 
    
    // Calculate actual time of TX Alignment Marker at TX PMA parallel data interface
    for (int pl = 0; pl < var_PL; pl++) begin
        tx_am_actual_time[pl]   =     (tx_apulse_time[pl])
                                + (tx_apulse_offset_sign[pl] ? -tx_apulse_offset[pl] : tx_apulse_offset[pl])
                                - (tx_apulse_wdelay[pl]);
    end

    // Step 3b
    // Determine TX reference lane
      if(p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 1)begin

         tx_ref_pl = 0;
         tx_am_actual_time_max = tx_am_actual_time[0];      
      
      end else begin
      
         ptp_max_ref_ln(p_sequencer.env.dyn_rcfg_obj_inst.ch_num,tx_am_actual_time,tx_am_actual_time_max,tx_ref_pl);

      end


    // Step 4
    // Calculate TX offsets
    // Step 4a
    // Calculate TX TAM adjust

    tx_tam_adjust   =     (tx_const_delay_sign              ? -tx_const_delay              : tx_const_delay)
    + (tx_apulse_offset_sign[tx_ref_pl] ? -tx_apulse_offset[tx_ref_pl] : tx_apulse_offset[tx_ref_pl])
    - (tx_apulse_wdelay[tx_ref_pl]);

    // Convert to 2's complement for TAM adjust
    //tx_tam_adjust_2c = convert_2s_complement (tx_tam_adjust)
    tx_tam_adjust_2c    = tx_tam_adjust;


    // Step 4b
    // Calculate TX extra latency
    // Convert unit of TX PMA delay from UI to nanoseconds
    tx_pma_delay_ns     = ((tx_pma_delay_ui * ui) >> (28 - 16));
    //TODO: HSD https://hsdes.intel.com/resource/1508284645
    //tx_pma_delay_ns      = 32'h7BA3D; //7.7275ns; - eth12
    //tx_pma_delay_ns      = 32'h7C1F0; //7.7275ns; - eth12
    //tx_pma_delay_ns      = 32'h3174B; //snap13.4 3.091ns; - eth7/17
    //tx_pma_delay_ns     = 31'hAB0A4; //10.69ns - eth8
    //tx_pma_delay_ns      = 31'h2FAE1; //2.98ns; - eth9
    
    // Total up all extra latency together
    tx_extra_latency    = tx_pma_delay_ns + tx_external_phy_delay;

    // Step 4c
    //Calculate TX virtual lane offsets
    //Using VL0 as reference virtual lane, assign TX virtual lane offset values according to virtual lane order as described in section 9.2.3.
    //Not use for 10G/25G
    for (int vl = 0; vl < var_VL; vl++) begin
       if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type==NOFEC) begin
	   tx_vl_offset[vl]    = 44'((vl - (vl % var_PL)) / var_PL * (1 * ui)) >> (28 - 16);
       end 
       else if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type==RSFECKR) begin
	   tx_vl_offset[vl]    = 44'((vl - (vl % var_PL)) / var_PL * (66 * ui)) >> (28 - 16);
       end 
       else if (p_sequencer.env.dyn_rcfg_obj_inst.fec_type inside {RSFECKP, LLFEC}) begin
	   tx_vl_offset[vl]    = 44'((vl - (vl % var_PL)) / var_PL * (68 * ui)) >> (28 - 16);
       end 
       else begin
	   tx_vl_offset[vl]    = 0;
       end
    end

    // Step 5
    // Write the determined TX reference lane into IP
    `uvm_info("body", "Write to TX Reference Lane ...", UVM_NONE)
    do begin
        p_sequencer.env.reg_model.ptp_ref_lane.tx_ref_lane.set(tx_ref_pl);
        #100ns;
    end while (p_sequencer.env.reg_model.ptp_ref_lane.tx_ref_lane.get() != tx_ref_pl);
    p_sequencer.env.reg_model.ptp_ref_lane.write(status, p_sequencer.env.reg_model.ptp_ref_lane.get());

    // Step 6
    // Write the calculated TX offsets to IP
    // Step 6a
    // Write TX virtual lane offsets
    `uvm_info("body", "Write to TX Virtual Lane Offsets ...", UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) begin
	`write_mac_cfg_tx_ptp_vl_offset(e50, 0)
	`write_mac_cfg_tx_ptp_vl_offset(e50, 1)
	`write_mac_cfg_tx_ptp_vl_offset(e50, 2)
	`write_mac_cfg_tx_ptp_vl_offset(e50, 3)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
	`write_mac_cfg_tx_ptp_vl_offset(e100, 0)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 1)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 2)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 3)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 4)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 5)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 6)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 7)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 8)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 9)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 10)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 11)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 12)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 13)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 14)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 15)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 16)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 17)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 18)
	`write_mac_cfg_tx_ptp_vl_offset(e100, 19)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G) begin
	`write_mac_cfg_tx_ptp_vl_offset(e200, 0)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 1)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 2)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 3)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 4)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 5)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 6)
	`write_mac_cfg_tx_ptp_vl_offset(e200, 7)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
	`write_mac_cfg_tx_ptp_vl_offset(e400, 0)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 1)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 2)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 3)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 4)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 5)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 6)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 7)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 8)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 9)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 10)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 11)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 12)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 13)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 14)
	`write_mac_cfg_tx_ptp_vl_offset(e400, 15)
    end 

    // Step 6b
    // Write TX extra latency
    `uvm_info("body", "Write to TX Extra Latency ...", UVM_NONE)
    if (p_sequencer.env.dyn_rcfg_obj_inst.speed inside {_25G, _10G}) begin
        `wr_tx_extra_lat(e25)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_50G) begin
        `wr_tx_extra_lat(e50)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_100G) begin
        `wr_tx_extra_lat(e100)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_200G) begin
        `wr_tx_extra_lat(e200)
    end 
    else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_400G) begin
        `wr_tx_extra_lat(e400)
    end 

    // Step 6c
    // Write TX TAM adjust
    `uvm_info("body", "Write to TX TAM adjust ...", UVM_NONE)
    do begin
        p_sequencer.env.reg_model.ptp_tx_tam_adjust.tam_adjust.set(tx_tam_adjust_2c);
        #100ns;
   end while (p_sequencer.env.reg_model.ptp_tx_tam_adjust.tam_adjust.get() != tx_tam_adjust_2c);
   p_sequencer.env.reg_model.ptp_tx_tam_adjust.write(status, p_sequencer.env.reg_model.ptp_tx_tam_adjust.get());

  //DEBUG
  p_sequencer.env.spy_if.tx_const_delay = tx_const_delay;
  p_sequencer.env.spy_if.tx_const_delay_sign = tx_const_delay_sign;
  p_sequencer.env.spy_if.tx_apulse_offset = tx_apulse_offset;
  p_sequencer.env.spy_if.tx_apulse_offset_sign = tx_apulse_offset_sign;
  p_sequencer.env.spy_if.tx_apulse_wdelay = tx_apulse_wdelay;
  p_sequencer.env.spy_if.tx_apulse_time = tx_apulse_time;
  p_sequencer.env.spy_if.tx_apulse_time_max = tx_apulse_time_max;
  p_sequencer.env.spy_if.tx_ref_pl = tx_ref_pl;
  p_sequencer.env.spy_if.tx_am_actual_time = tx_am_actual_time;
  p_sequencer.env.spy_if.tx_am_actual_time_max = tx_am_actual_time_max;
  p_sequencer.env.spy_if.tx_tam_adjust = tx_tam_adjust;
  p_sequencer.env.spy_if.tx_tam_adjust_2c = tx_tam_adjust_2c;
  p_sequencer.env.spy_if.tx_external_phy_delay = tx_external_phy_delay;
  p_sequencer.env.spy_if.tx_pma_delay_ui = tx_pma_delay_ui;
  p_sequencer.env.spy_if.tx_pma_delay_ns = tx_pma_delay_ns;
  p_sequencer.env.spy_if.tx_extra_latency = tx_extra_latency;
  p_sequencer.env.spy_if.tx_vl_offset = tx_vl_offset;
  p_sequencer.env.spy_if.tx_data_const_delay = tx_data_const_delay;
  p_sequencer.env.spy_if.tx_apulse_data_offset = tx_apulse_data_offset;


   //Step8
   //Notify soft PTP that user flow configuration is completed
   //TODO: Need to use SIP register programming. Workaround currently while waiting for YY to provide new RAL file.
   //uvm_hdl_force("eth_env_top.dut.ip0.top_ip0.sip_inst.PTP_SOFT_GEN.soft_ptp.i_tx_ptp_user_cfg_done",1'b1);
	`uvm_info("body", "Write TX User Cfg Done ...", UVM_NONE)
	do begin
	    p_sequencer.env.reg_model.ptp_tx_user_cfg_status.tx_user_cfg_done.set(1);
	    #100ns;
	end while (p_sequencer.env.reg_model.ptp_tx_user_cfg_status.tx_user_cfg_done.get()==0);
	p_sequencer.env.reg_model.ptp_tx_user_cfg_status.write(status, p_sequencer.env.reg_model.ptp_tx_user_cfg_status.get());


   //Step9
   //Wait until TX PTP is ready
    `uvm_info("body", "Poll for TX PTP READY ...", UVM_NONE)
    do begin
        p_sequencer.env.reg_model.ptp_status.read(status, read_data);
        #100ns;
    end while (p_sequencer.env.reg_model.ptp_status.tx_ptp_ready.get() != 1);

    `uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: tx_const_delay = 'h%h", tx_const_delay[30:0]), UVM_MEDIUM);
    `uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: tx_const_delay_sign = 'h%h", tx_const_delay_sign), UVM_MEDIUM);
    for(int pl=0; pl < var_PL; pl++) begin
	`uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; tx_apulse_offset = 'h%h", pl, tx_apulse_offset[pl][30:0]), UVM_MEDIUM);
	`uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; tx_apulse_offset_sign = 'h%h", pl, tx_apulse_offset_sign[pl]), UVM_MEDIUM);
	`uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: PL num: 'h%h; tx_apulse_wdelay = 'h%h", pl, tx_apulse_wdelay[pl][19:0]), UVM_MEDIUM);
    end
    `uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: tx_tam_adjust = 'h%h", tx_tam_adjust[31:0]), UVM_MEDIUM);
    `uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: tx_tam_adjust_2c = 'h%h", tx_tam_adjust_2c[31:0]), UVM_MEDIUM);
    `uvm_info("eth_ptp_tx_user_flow_sequence", $sformatf("GDR_PTP_INFO: tx_extra_latency = 'h%h", tx_extra_latency[31:0]), UVM_MEDIUM);

    `uvm_info("body", "Completed eth_ptp_tx_user_flow_sequence ...", UVM_NONE)
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
   output [28:0]         apulse_time_max;
     
   apulse_time_max  = apulse_time[0];
   for (int x=1; x<num_entry; x++) begin
      if (apulse_time[x] > apulse_time_max) begin
         apulse_time_max = apulse_time[x];
      end
   end				
endtask

endclass : eth_ptp_tx_user_flow_sequence
