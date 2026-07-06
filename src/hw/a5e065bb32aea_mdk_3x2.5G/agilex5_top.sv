//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************

// Derive channel and width from hps_emif_topology

// Find and print each number individually

import mrphy_pkg::*;
import dr_pkg::*;

module agilex5_top #(parameter NUM_PHY=3)(
//Additional refclk_bti to preserve Etile XCVR
// Clock and Reset
input  logic          fpga_clk_100,
output logic          fpga_led_pio,
input  logic          fpga_button_pio,
//HPS
// HPS EMIF
output  logic         emif_hps_emif_mem_0_mem_ck_t,
output  logic         emif_hps_emif_mem_0_mem_ck_c,
output  logic [16:0]  emif_hps_emif_mem_0_mem_a,
output  logic         emif_hps_emif_mem_0_mem_act_n,
output  logic [1:0]   emif_hps_emif_mem_0_mem_ba,
output  logic [1:0]   emif_hps_emif_mem_0_mem_bg,
output  logic         emif_hps_emif_mem_0_mem_cke,
output  logic         emif_hps_emif_mem_0_mem_cs_n,
output  logic         emif_hps_emif_mem_0_mem_odt,
output  logic         emif_hps_emif_mem_0_mem_reset_n,
output  logic         emif_hps_emif_mem_0_mem_par,
input   logic         emif_hps_emif_mem_0_mem_alert_n,
input   logic         emif_hps_emif_oct_0_oct_rzqin,
input   logic         emif_hps_emif_ref_clk_0_clk,
inout   wire [3:0]    emif_hps_emif_mem_0_mem_dqs_t,
inout   wire [3:0]    emif_hps_emif_mem_0_mem_dqs_c,
inout   wire [31:0]   emif_hps_emif_mem_0_mem_dq,

output  logic         hps_sdmmc_CCLK, 
inout   wire          hps_sdmmc_CMD,          
inout   wire          hps_sdmmc_D0,          
inout   wire          hps_sdmmc_D1,          
inout   wire          hps_sdmmc_D2,        
inout   wire          hps_sdmmc_D3,        

input   logic         usb31_io_vbus_det,                  
input   logic         usb31_io_flt_bar,                   
output  logic [1:0]   usb31_io_usb_ctrl,
input   logic         usb31_io_usb31_id,                  
input   logic         usb31_phy_refclk_p_clk,                        
input   logic         usb31_phy_rx_serial_n_i_rx_serial_n,
input   logic         usb31_phy_rx_serial_p_i_rx_serial_p,
output  logic         usb31_phy_tx_serial_n_o_tx_serial_n,
output  logic         usb31_phy_tx_serial_p_o_tx_serial_p,

inout   wire          hps_usb1_DATA0,         
inout   wire          hps_usb1_DATA1,      
inout   wire          hps_usb1_DATA2,        
inout   wire          hps_usb1_DATA3,       
inout   wire          hps_usb1_DATA4,        
inout   wire          hps_usb1_DATA5,      
inout   wire          hps_usb1_DATA6,      
inout   wire          hps_usb1_DATA7,         
input   logic         hps_usb1_CLK,         
output  logic         hps_usb1_STP,       
input   logic         hps_usb1_DIR,        
input   logic         hps_usb1_NXT, 
input   logic         hps_uart0_RX,       
output  logic         hps_uart0_TX, 
inout   wire          hps_gpio0_io0,
inout   wire          hps_gpio0_io10,
output  logic [NUM_PHY-1:0] pp_app_tx_serial_data,
output  logic [NUM_PHY-1:0] pp_app_tx_serial_data_n,
input   logic [NUM_PHY-1:0] emac_ptp_trig,
output  logic [NUM_PHY-1:0] emac_ptp_pps,
input   logic [NUM_PHY-1:0] app_pp_rx_serial_data,
input   logic [NUM_PHY-1:0] app_pp_rx_serial_data_n,

input   logic  osc_clk,
inout   wire   i2c_scl,
inout   wire   i2c_sda,
input          sfp28_int,
input          sfp28_tx_fault,
input          sfp28_los,
input          sfp28_mod_det,
output         sfp28_tx_disable,
inout   wire   c3_emac0_mdio_mdio,
output  logic  c3_emac0_mdio_mdc,

inout  wire        hps_io_i2c_emac1_sda,
inout  wire        hps_io_i2c_emac1_scl,    

input   logic  hps_osc_clk,
input   logic  fpga_reset_n

);

logic system_clk_100;
logic clk_100_out_clk1_clk;
logic ninit_done;
logic fpga_reset_n_debounced_logic;
logic fpga_reset_n_debounced;
logic system_reset;
logic h2f_reset;

assign combined_reset_n = fpga_reset_n & ~h2f_reset & ~ninit_done;
assign system_clk_100   = fpga_clk_100;

altera_reset_synchronizer #(
    .ASYNC_RESET (1),
    .DEPTH       (2)
) sys_rst_inst (
    .reset_in  (~combined_reset_n),
    .clk       (system_clk_100),
    .reset_out (system_reset)
);
             
logic [4-1:0]  fpga_debounced_buttons;
logic          heartbeat_led;
logic [22:0]   heartbeat_count;

assign heartbeat_led = ~heartbeat_count[22];
assign fpga_led_pio = heartbeat_led;

logic app_pp_emac0_mdio_mdi0;		
logic pp_app_emac0_mdio_mdo0;
logic pp_app_emac0_mdio_mdoe0;
logic csr_rst;
logic avmm_rst;
logic [NUM_PHY-1:0] phy_reset;
logic sys_pll_locked;
logic io_pll_locked;
logic pll_reset;
logic [NUM_PHY-1:0] src_grant, src_priority, src_req;
logic o_pma_clk;
logic [NUM_PHY-1:0] reg_mrphy_pll_lock, reg_tx_rdy, reg_rx_rdy, reg_blk_lock;
logic [3*NUM_PHY - 1:0] reg_op_speed;						
logic [NUM_PHY-1:0] phy_tx_rst_n, phy_rx_rst_n;
logic [NUM_PHY-1:0] ack_rst_n, ack_tx_rst_n, ack_rx_rst_n;
logic [NUM_PHY-1:0] emac_mac_rst_tx_n, emac_mac_rst_rx_n;
logic [NUM_PHY-1:0] o_rst_n, csr_o_rst_n, sync_ack_i_rst_n, sync_mrphy_pll_lock_i;
logic [NUM_PHY-1:0] sync_rx_ready_i, sync_tx_ready_i;
//HPS - MRPHY
logic [7:0] hps_mrphy_data [NUM_PHY-1:0];
logic [7:0] mrphy_hps_data [NUM_PHY-1:0];
logic [2:0] mac_speed [NUM_PHY-1:0];

logic [NUM_PHY-1:0] hps_mrphy_data_vld;
logic [NUM_PHY-1:0] hps_mrphy_err;
logic [NUM_PHY-1:0] gmii8b_rst_tx_n, gmii8b_rst_rx_n, tx_digitalreset, rx_digitalreset;
logic [NUM_PHY-1:0] mrphy_hps_data_vld;
logic [NUM_PHY-1:0] mrphy_hps_err;
logic [NUM_PHY-1:0] mac_col_det;
logic [NUM_PHY-1:0] mac_car_sense;
logic [NUM_PHY-1:0] mrphy_hps_tx_clk;
logic [NUM_PHY-1:0] mrphy_hps_rx_clk;
logic [NUM_PHY-1:0] hps_mrphy_tx_clk; 
//Avalon interface logics
logic        csr_waitrequest; 
logic [31:0] csr_readdata;     
logic        csr_readdatavalid;
logic [0:0]  csr_burstcount;   
logic [31:0] csr_writedata;    
logic [6:0]  csr_address;      
logic        csr_write;        
logic        csr_read;         
logic [3:0]  csr_byteenable;  
logic        csr_debugaccess;
logic 	     mm_bridge_0140_017f_m0_write;
logic 	     mm_bridge_0140_017f_m0_read;
logic        mm_bridge_0140_017f_m0_waitrequest;
logic [15:0] mm_bridge_0140_017f_m0_readdata;
logic  	     mm_bridge_0140_017f_m0_readdatavalid;
logic        mm_bridge_0380_03ff_m0_write;
logic  	     mm_bridge_0380_03ff_m0_read;
logic  	     mm_bridge_0380_03ff_m0_waitrequest;
logic [15:0] mm_bridge_0380_03ff_m0_readdata;
logic        mm_bridge_0380_03ff_m0_readdatavalid;
logic  	     mm_bridge_01c0_01ff_m0_write;
logic        mm_bridge_01c0_01ff_m0_read;
logic  	     mm_bridge_01c0_01ff_m0_waitrequest;
logic [15:0] mm_bridge_01c0_01ff_m0_readdata;
logic        mm_bridge_01c0_01ff_m0_readdatavalid;
logic  	     mm_bridge_0240_027f_m0_write;
logic  	     mm_bridge_0240_027f_m0_read;
logic        mm_bridge_0240_027f_m0_waitrequest;
logic [15:0] mm_bridge_0240_027f_m0_readdata;
logic  	     mm_bridge_0240_027f_m0_readdatavalid;
logic  	     mm_bridge_0280_02ff_m0_write;
logic  	     mm_bridge_0280_02ff_m0_read;
logic        mm_bridge_0280_02ff_m0_waitrequest;
logic [15:0] mm_bridge_0280_02ff_m0_readdata;
logic  	     mm_bridge_0280_02ff_m0_readdatavalid;
logic  	     mm_bridge_0400_04ff_m0_write;
logic  	     mm_bridge_0400_04ff_m0_read;
logic        mm_bridge_0400_04ff_m0_waitrequest;
logic [31:0] mm_bridge_0400_04ff_m0_readdata;
logic  	     mm_bridge_0400_04ff_m0_readdatavalid;

logic	i2c_scl_oe;
logic	i2c_sda_oe;
logic	i2c_scl_in;
logic	i2c_sda_in;
logic	i2c_intr;
logic	sfp28_int_reg1;
logic	sfp28_int_reg2;
logic	sfp28_tx_fault_reg1;
logic	sfp28_tx_fault_reg2;
logic	sfp28_los_reg1;
logic	sfp28_los_reg2;
logic	sfp28_mod_det_reg1;
logic	sfp28_mod_det_reg2;

//AVMM master to phymgmt
logic [31:0] i2c_csr_readdata;    
logic [31:0] i2c_csr_writedata;    
logic [7:0] i2c_csr_address;      
logic        i2c_csr_write;        
logic        i2c_csr_read;     
logic        i2c_csr_waitrequest;     
logic        i2c_csr_readdatavalid;  
logic        i2c_csr_readdatavalid_delay;   
//Avalon interface logics to MDIO IP
logic        mdio_csr_waitrequest; 
logic [31:0] mdio_csr_readdata;     
logic        mdio_csr_readdatavalid;
logic [0:0]  mdio_csr_burstcount;   
logic [31:0] mdio_csr_writedata;    
logic [5:0]  mdio_csr_address;      
logic        mdio_csr_write;        
logic        mdio_csr_read;         
logic [3:0]  mdio_csr_byteenable;  
logic        mdio_csr_debugaccess;
logic	     app_pp_emac0_mdio_mdi;		
logic	     pp_app_emac0_mdio_mdo;
logic	     pp_app_emac0_mdio_mdoe;
//PHY0 
logic        mm_bridge_1_m0_waitrequest; 
logic [15:0] mm_bridge_1_m0_readdata;     
logic        mm_bridge_1_m0_readdatavalid;
logic [0:0]  mm_bridge_1_m0_burstcount;   
logic [15:0] mm_bridge_1_m0_writedata;    
logic [4:0]  mm_bridge_1_m0_address;      
logic        mm_bridge_1_m0_write;        
logic        mm_bridge_1_m0_read;         
logic [1:0]  mm_bridge_1_m0_byteenable;  
logic        mm_bridge_1_m0_debugaccess;
//PHY1
logic        mm_bridge_3_m0_waitrequest; 
logic [15:0] mm_bridge_3_m0_readdata;     
logic        mm_bridge_3_m0_readdatavalid;
logic [0:0]  mm_bridge_3_m0_burstcount;   
logic [15:0] mm_bridge_3_m0_writedata;    
logic [4:0]  mm_bridge_3_m0_address;      
logic        mm_bridge_3_m0_write;        
logic        mm_bridge_3_m0_read;         
logic [1:0]  mm_bridge_3_m0_byteenable;  
logic        mm_bridge_3_m0_debugaccess;
//PHY2
logic        mm_bridge_5_m0_waitrequest; 
logic [15:0] mm_bridge_5_m0_readdata;     
logic        mm_bridge_5_m0_readdatavalid;
logic [0:0]  mm_bridge_5_m0_burstcount;   
logic [15:0] mm_bridge_5_m0_writedata;    
logic [4:0]  mm_bridge_5_m0_address;      
logic        mm_bridge_5_m0_write;        
logic        mm_bridge_5_m0_read;         
logic [1:0]  mm_bridge_5_m0_byteenable;  
logic        mm_bridge_5_m0_debugaccess;
//DR Controller signals
logic 		    mm_bridge_dr_ctrl_m0_waitrequest   ;
logic [31:0]	mm_bridge_dr_ctrl_m0_readdata      ;
logic 		    mm_bridge_dr_ctrl_m0_readdatavalid ;
logic 		    mm_bridge_dr_ctrl_m0_burstcount    ;
logic [31:0]    mm_bridge_dr_ctrl_m0_writedata     ;
logic [6:0]	    mm_bridge_dr_ctrl_m0_address       ;
logic 		    mm_bridge_dr_ctrl_m0_write         ;
logic 		    mm_bridge_dr_ctrl_m0_read          ;
logic [3:0]	    mm_bridge_dr_ctrl_m0_byteenable    ;
logic 		    mm_bridge_dr_ctrl_m0_debugaccess   ;
logic 		    dr_err_status;
logic [14:0]        dr_profile_id;
logic               dr_in_progress;
logic               o_fast_sim_clk_sel;
logic [NUM_PHY-1:0] o_src_pause_request;
logic [NUM_PHY-1:0] i_src_pause_grant; 
logic [NUM_PHY-1:0] latency_measure_clk;
logic [NUM_PHY-1:0] latency_sclk;
logic               measure_clk;
logic               sclk;
logic               tsn_gts_0_c0_clk;
logic               fabric_reset_bridge_0_out_reset_reset;
logic               o_pma_cpu_clk;
logic [30:0]        f2h_irq1_irq;


assign f2h_irq1_irq[30:0]    = {28'b0,i2c_intr,2'b0};

//PHY Interfaces
mrphy_csr_if      csr_if      [NUM_PHY]();
mrphy_mac_tx_if   mac_tx_if   [NUM_PHY]();
mrphy_mac_rx_if   mac_rx_if   [NUM_PHY]();
mrphy_adapter_if  adapter_if  [NUM_PHY]();
mrphy_latency_if  latency_if  [NUM_PHY]();
mrphy_reset_if    reset_if    [NUM_PHY]();
mrphy_serial_if   serial_if   [NUM_PHY]();
mrphy_misc_if     misc_if     [NUM_PHY]();
mrphy_reconfig_if reconfig_if [NUM_PHY]();

// DR/Control interfaces
dr_lavmm_if        dr_lavmm_if [NUM_PHY]();
pause_if           pause_if    [NUM_PHY]();
grant_if           grant_if    [NUM_PHY]();

// Shared signals as individual logics
logic [5:0] one_hot_sel;


//PHY0 assignments
assign  mm_bridge_1_m0_waitrequest    = csr_if[0].waitrequest ; 
assign  mm_bridge_1_m0_readdata       = csr_if[0].readdata ;   
assign  csr_if[0].clk                 = clk_100_out_clk1_clk;   
assign  csr_if[0].burstcount          = mm_bridge_1_m0_burstcount;   
assign  csr_if[0].writedata           = mm_bridge_1_m0_writedata;    
assign  csr_if[0].address             = mm_bridge_1_m0_address;      
assign  csr_if[0].write               = mm_bridge_1_m0_write;        
assign  csr_if[0].read                = mm_bridge_1_m0_read;      
assign  csr_if[0].byteenable          = mm_bridge_1_m0_byteenable; 
assign  csr_if[0].debugaccess         = mm_bridge_1_m0_debugaccess;
assign  mm_bridge_1_m0_readdatavalid  = !mm_bridge_1_m0_waitrequest;

assign mac_tx_if[0].mac_speed = {mac_speed[0][2],~mac_speed[0][0]}; 
assign reg_op_speed[2:0] = misc_if[0].operating_speed;
assign misc_if[0].xcvr_mode = one_hot_sel[1]? 2'b00: 2'b01;


//PHY1 assignments                   
assign mm_bridge_3_m0_waitrequest     = csr_if[1].waitrequest; 
assign mm_bridge_3_m0_readdata        = csr_if[1].readdata;  
assign csr_if[1].clk                  = clk_100_out_clk1_clk;
assign csr_if[1].burstcount           = mm_bridge_3_m0_burstcount;   
assign csr_if[1].writedata            = mm_bridge_3_m0_writedata;    
assign csr_if[1].address              = mm_bridge_3_m0_address;      
assign csr_if[1].write                = mm_bridge_3_m0_write;        
assign csr_if[1].read                 = mm_bridge_3_m0_read;         
assign csr_if[1].byteenable           = mm_bridge_3_m0_byteenable;  
assign csr_if[1].debugaccess          = mm_bridge_3_m0_debugaccess;
assign mm_bridge_3_m0_readdatavalid  = !mm_bridge_3_m0_waitrequest;

assign mac_tx_if[1].mac_speed = {mac_speed[1][2],~mac_speed[1][0]};
assign reg_op_speed[5:3] = misc_if[1].operating_speed;
assign misc_if[1].xcvr_mode = one_hot_sel[3] ? 2'b00: 2'b01;


//PHY2 assignments
assign mm_bridge_5_m0_waitrequest    = csr_if[2].waitrequest; 
assign mm_bridge_5_m0_readdata       = csr_if[2].readdata;  
assign csr_if[2].clk                 = clk_100_out_clk1_clk;
assign csr_if[2].burstcount          = mm_bridge_5_m0_burstcount;   
assign csr_if[2].writedata           = mm_bridge_5_m0_writedata;    
assign csr_if[2].address             = mm_bridge_5_m0_address;      
assign csr_if[2].write               = mm_bridge_5_m0_write;        
assign csr_if[2].read                = mm_bridge_5_m0_read;         
assign csr_if[2].byteenable          = mm_bridge_5_m0_byteenable;  
assign csr_if[2].debugaccess         = mm_bridge_5_m0_debugaccess;
assign mm_bridge_5_m0_readdatavalid  = !mm_bridge_5_m0_waitrequest;

assign mac_tx_if[2].mac_speed = {mac_speed[2][2],~mac_speed[2][0]};
assign reg_op_speed[8:6] = misc_if[2].operating_speed;
assign misc_if[2].xcvr_mode = one_hot_sel[5]? 2'b00: 2'b01;


//PHY Assignments
genvar p;
generate
for (p = 0; p < NUM_PHY; p = p + 1) begin 
    assign mac_tx_if[p].tx_d = hps_mrphy_data[p];
    assign mac_tx_if[p].txen = hps_mrphy_data_vld[p];
    assign mac_tx_if[p].txer =  hps_mrphy_err[p]; 
    assign mrphy_hps_data[p] = mac_rx_if[p].rxd; 
    assign mrphy_hps_data_vld[p] = mac_rx_if[p].rxdv;
    assign mrphy_hps_err[p] = mac_rx_if[p].rxer;
    assign adapter_if[p].gmii8b_tx_clkin  = hps_mrphy_tx_clk[p];
    assign adapter_if[p].gmii8b_tx_rst_n  = gmii8b_rst_tx_n[p];
    assign adapter_if[p].gmii8b_rx_rst_n  = gmii8b_rst_rx_n[p]; 
    assign mrphy_hps_rx_clk[p] = adapter_if[p].gmii8b_rx_clkout;
    assign mrphy_hps_tx_clk[p] = adapter_if[p].gmii8b_tx_clkout;
    assign reset_if[p].reset = fabric_reset_bridge_0_out_reset_reset; 
    assign reset_if[p].rx_digitalreset  = rx_digitalreset[p]; 
    assign reset_if[p].tx_digitalreset  = tx_digitalreset[p]; 
    assign reset_if[p].i_rst_n          = o_rst_n[p];
    assign reset_if[p].i_tx_rst_n       = phy_tx_rst_n[p];     
    assign reset_if[p].i_rx_rst_n       = phy_rx_rst_n[p]; 
    assign ack_rst_n[p] = reset_if[p].o_rst_ack_n;       
    assign ack_tx_rst_n[p] = reset_if[p].o_tx_rst_ack_n;
    assign ack_rx_rst_n[p] = reset_if[p].o_rx_rst_ack_n;                           
    assign reg_mrphy_pll_lock[p] = misc_if[p].mrphy_pll_lock;                   
    assign reg_tx_rdy[p] = misc_if[p].tx_ready;                      
    assign reg_rx_rdy[p] = misc_if[p].rx_ready;
    assign misc_if[p].rx_cdr_refclk_p = osc_clk;
    assign misc_if[p].tx_pll_refclk_p = osc_clk;
    assign pp_app_tx_serial_data[p] = serial_if[p].tx_serial_data; 
    assign pp_app_tx_serial_data_n[p] = serial_if[p].tx_serial_data_n;
    assign serial_if[p].rx_serial_data = app_pp_rx_serial_data[p];
    assign serial_if[p].rx_serial_data_n =app_pp_rx_serial_data_n[p];
    assign reg_blk_lock[p] = misc_if[p].rx_is_lockedtodata;
    assign pause_if[p].src_pause_request = o_src_pause_request[p];
    assign i_src_pause_grant[p] = pause_if[p].src_pause_grant;   
    assign grant_if[p].rs_grant = src_grant[p];
    assign src_req[p] = grant_if[p].rs_request;
    assign latency_measure_clk[p] = measure_clk;
    assign latency_sclk[p]        =sclk;
    assign latency_if[p].measure_clk = latency_measure_clk;
    assign latency_if[p].sclk = latency_sclk;
    assign reconfig_if[p].clk = 1'b0;
    assign reconfig_if[p].reset = 1'b0;
    assign reconfig_if[p].write = 1'b0;
    assign reconfig_if[p].read = 1'b0;
    assign reconfig_if[p].address = 18'h0;
    assign reconfig_if[p].be = 4'h0;
    assign reconfig_if[p].writedata = 32'h0;
    assign dr_lavmm_if[p].clk = clk_100_out_clk1_clk;
end
endgenerate


// DR Wrapper Instance
mrphy_dr_wrapper #(.NUM_PHY(NUM_PHY)) dr_wrap_inst (
 .csr_if      (csr_if),
 .mac_tx_if   (mac_tx_if),
 .mac_rx_if   (mac_rx_if),
 .adapter_if  (adapter_if),
 .latency_if  (latency_if),
 .reset_if    (reset_if),
 .serial_if   (serial_if),
 .misc_if     (misc_if),
 .reconfig_if (reconfig_if),

 // DR/Control interfaces
 .dr_lavmm_if (dr_lavmm_if),
 .pause_if    (pause_if),
 .grant_if    (grant_if),

 // Shared signals 
 .one_hot_sel              (one_hot_sel),
 .i_pma_cu_clk_bank0       (o_pma_cpu_clk),
 .i_system_pll_clk_mrphy_0 (tsn_gts_0_c0_clk),
 .i_system_pll_lock_mrphy_0(sys_pll_locked),
 .i_system_pll_lock_mrphy_1(sys_pll_locked),
 .i_system_pll_lock_mrphy_2(sys_pll_locked)
);

//DR Controller
dr_ctrl #(
 .DRMIFMEM_INIT_FILE("support_logic/mr_top/synth/dr.mif")
) dr_ctrl_inst (
  .i_rst_n                       (~avmm_rst),
  .i_csr_clk                     (clk_100_out_clk1_clk),
  .i_cpu_clk                     (clk_100_out_clk1_clk),
  .o_profile_id                  (dr_profile_id),
  .o_in_progress                 (dr_in_progress),
  .o_err_status                  (dr_err_status),
  .o_fast_sim_clk_sel            (o_fast_sim_clk_sel),
  .i_host_avmm_address           (mm_bridge_dr_ctrl_m0_address ),
  .o_host_avmm_readdatavalid     (mm_bridge_dr_ctrl_m0_readdatavalid ),
  .i_host_avmm_read              (mm_bridge_dr_ctrl_m0_read ),
  .i_host_avmm_write             (mm_bridge_dr_ctrl_m0_write ),
  .o_host_avmm_readdata          (mm_bridge_dr_ctrl_m0_readdata ),
  .i_host_avmm_writedata         (mm_bridge_dr_ctrl_m0_writedata ),
  .o_host_avmm_waitrequest       (mm_bridge_dr_ctrl_m0_waitrequest ),
  .o_one_hot_sel                 (one_hot_sel),
  .o_src_pause_request           (o_src_pause_request),
  .i_src_pause_grant             (i_src_pause_grant),
  .o_ch0_lavmm_addr              (dr_lavmm_if[0].addr),
  .o_ch0_lavmm_be                (dr_lavmm_if[0].be),
  .o_ch0_lavmm_write             (dr_lavmm_if[0].write ),
  .o_ch0_lavmm_read              (dr_lavmm_if[0].read ),
  .o_ch0_lavmm_wdata             (dr_lavmm_if[0].wdata ),
  .i_ch0_lavmm_rdata             (dr_lavmm_if[0].rdata ),
  .i_ch0_lavmm_rdata_valid       (dr_lavmm_if[0].rdata_valid ),
  .i_ch0_lavmm_waitreq           (dr_lavmm_if[0].waitreq ),
  .o_ch0_lavmm_rstn              (dr_lavmm_if[0].rstn ),
  .o_ch1_lavmm_addr              (dr_lavmm_if[1].addr ),
  .o_ch1_lavmm_be                (dr_lavmm_if[1].be ),
  .o_ch1_lavmm_write             (dr_lavmm_if[1].write ),
  .o_ch1_lavmm_read              (dr_lavmm_if[1].read ),
  .o_ch1_lavmm_wdata             (dr_lavmm_if[1].wdata ),
  .i_ch1_lavmm_rdata             (dr_lavmm_if[1].rdata ),
  .i_ch1_lavmm_rdata_valid       (dr_lavmm_if[1].rdata_valid ),
  .i_ch1_lavmm_waitreq           (dr_lavmm_if[1].waitreq ),
  .o_ch1_lavmm_rstn              (dr_lavmm_if[1].rstn ),
  .o_ch2_lavmm_addr              (dr_lavmm_if[2].addr ),
  .o_ch2_lavmm_be                (dr_lavmm_if[2].be ),
  .o_ch2_lavmm_write             (dr_lavmm_if[2].write ),
  .o_ch2_lavmm_read              (dr_lavmm_if[2].read ),
  .o_ch2_lavmm_wdata             (dr_lavmm_if[2].wdata ),
  .i_ch2_lavmm_rdata             (dr_lavmm_if[2].rdata ),
  .i_ch2_lavmm_rdata_valid       (dr_lavmm_if[2].rdata_valid ),
  .i_ch2_lavmm_waitreq           (dr_lavmm_if[2].waitreq ),
  .o_ch2_lavmm_rstn              (dr_lavmm_if[2].rstn )
 );

 
// Qsys Top module
qsys_top soc_inst (
 .clk_100_clk                                        (system_clk_100),
 .fabric_reset_bridge_0_out_reset_reset              (fabric_reset_bridge_0_out_reset_reset),
 .clk_100_out_clk_1_clk                              (clk_100_out_clk1_clk), 
 .ninit_done_ninit_done                              (ninit_done),
 .csr_rst_reset_n			                         (csr_rst),
 .h2f_reset_reset			                         (h2f_reset),
 //.emac_ptp_clk_clk          	   	                 ('b0), 
 .emac_timestamp_data_data_in    	                 (64'b0),
 .emac_timestamp_clk_clk    	   	                 ('b0),
 .emac0_ptp_mac_ptp_trig		                     (emac_ptp_trig[0]),
 .emac0_ptp_mac_ptp_pps			                     (emac_ptp_pps[0]),
 .emac0_ptp_mac_ptp_tstmp_data		                 (),	
 .emac0_ptp_mac_ptp_tstmp_en		                 (),
 .emac0_mac_tx_clk_o        	   	                 (hps_mrphy_tx_clk[0]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac0_mac_tx_clk_i        	   	                 (mrphy_hps_tx_clk[0]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac0_mac_rx_clk           		                 (mrphy_hps_rx_clk[0]),
 .emac0_mac_rst_tx_n         	   	                 (emac_mac_rst_tx_n[0]),
 .emac0_mac_rst_rx_n         	   	                 (emac_mac_rst_rx_n[0]),
 .emac0_mac_txen             	   	                 (hps_mrphy_data_vld[0]),
 .emac0_mac_txer             	   	                 (hps_mrphy_err[0]    ),
 .emac0_mac_rxdv             		                 (mrphy_hps_data_vld[0]),
 .emac0_mac_rxer             	   	                 (mrphy_hps_err[0]    ),
 .emac0_mac_rxd              	   	                 (mrphy_hps_data[0]	),
 .emac0_mac_col              	   	                 ('b0),
 .emac0_mac_crs              	   	                 ('b0),
 .emac0_mac_speed            		                 (mac_speed[0]),
 .emac0_mac_txd_o            	   	                 (hps_mrphy_data[0]),
 .emac1_ptp_mac_ptp_trig		                     (emac_ptp_trig[1]),
 .emac1_ptp_mac_ptp_pps			                     (emac_ptp_pps[1]),
 .emac1_ptp_mac_ptp_tstmp_data		                 (),	
 .emac1_ptp_mac_ptp_tstmp_en		                 (),
 .emac1_mac_tx_clk_o         	   	                 (hps_mrphy_tx_clk[1]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac1_mac_tx_clk_i         	   	                 (mrphy_hps_tx_clk[1]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac1_mac_rx_clk           	   	                 (mrphy_hps_rx_clk[1]),
 .emac1_mac_rst_tx_n         		                 (emac_mac_rst_tx_n[1]),
 .emac1_mac_rst_rx_n         	   	                 (emac_mac_rst_rx_n[1]),
 .emac1_mac_txen             	   	                 (hps_mrphy_data_vld[1]),
 .emac1_mac_txer             	   	                 (hps_mrphy_err[1]    ),
 .emac1_mac_rxdv             	   	                 (mrphy_hps_data_vld[1]),
 .emac1_mac_rxer             		                 (mrphy_hps_err[1]    ),
 .emac1_mac_rxd              	   	                 (mrphy_hps_data[1]	),
 .emac1_mac_col              	   	                 ('b0),
 .emac1_mac_crs              	   	                 ('b0),
 .emac1_mac_speed            	   	                 (mac_speed[1]),
 .emac1_mac_txd_o            		                 (hps_mrphy_data[1]),
 .emac2_ptp_mac_ptp_trig		                     (emac_ptp_trig[2]),
 .emac2_ptp_mac_ptp_pps			                     (emac_ptp_pps[2]),
 .emac2_ptp_mac_ptp_tstmp_data		                 (),	
 .emac2_ptp_mac_ptp_tstmp_en		                 (),
 .emac2_mac_tx_clk_o         	   	                 (hps_mrphy_tx_clk[2]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac2_mac_tx_clk_i         	   	                 (mrphy_hps_tx_clk[2]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac2_mac_rx_clk           	   	                 (mrphy_hps_rx_clk[2]),
 .emac2_mac_rst_tx_n         	   	                 (emac_mac_rst_tx_n[2]),
 .emac2_mac_rst_rx_n         		                 (emac_mac_rst_rx_n[2]),
 .emac2_mac_txen             	   	                 (hps_mrphy_data_vld[2]),
 .emac2_mac_txer             	   	                 (hps_mrphy_err[2]    ),
 .emac2_mac_rxdv             	   	                 (mrphy_hps_data_vld[2]),
 .emac2_mac_rxer             	   	                 (mrphy_hps_err[2]    ),
 .emac2_mac_rxd             		                 (mrphy_hps_data[2]	),
 .emac2_mac_col             	   	                 ('b0),
 .emac2_mac_crs             	   	                 ('b0),
 .emac2_mac_speed           	   	                 (mac_speed[2]),
 .emac2_mac_txd_o           	   	                 (hps_mrphy_data[2]),
 .hps_io_i2c_emac1_sda                                  (hps_io_i2c_emac1_sda),
 .hps_io_i2c_emac1_scl                                  (hps_io_i2c_emac1_scl),
 .emif_hps_emif_mem_ck_0_mem_ck_t                    (emif_hps_emif_mem_0_mem_ck_t),
 .emif_hps_emif_mem_ck_0_mem_ck_c                    (emif_hps_emif_mem_0_mem_ck_c),
 .emif_hps_emif_mem_0_mem_a                          (emif_hps_emif_mem_0_mem_a),
 .emif_hps_emif_mem_0_mem_act_n                      (emif_hps_emif_mem_0_mem_act_n),
 .emif_hps_emif_mem_0_mem_ba                         (emif_hps_emif_mem_0_mem_ba),
 .emif_hps_emif_mem_0_mem_bg                         (emif_hps_emif_mem_0_mem_bg),
 .emif_hps_emif_mem_0_mem_cke                        (emif_hps_emif_mem_0_mem_cke),
 .emif_hps_emif_mem_0_mem_cs_n                       (emif_hps_emif_mem_0_mem_cs_n),
 .emif_hps_emif_mem_0_mem_odt                        (emif_hps_emif_mem_0_mem_odt),
 .emif_hps_emif_mem_reset_n_mem_reset_n              (emif_hps_emif_mem_0_mem_reset_n),
 .emif_hps_emif_mem_0_mem_par                        (emif_hps_emif_mem_0_mem_par),
 .emif_hps_emif_mem_0_mem_alert_n                    (emif_hps_emif_mem_0_mem_alert_n),
 .emif_hps_emif_mem_0_mem_dqs_t                      (emif_hps_emif_mem_0_mem_dqs_t),
 .emif_hps_emif_mem_0_mem_dqs_c                      (emif_hps_emif_mem_0_mem_dqs_c),
 .emif_hps_emif_mem_0_mem_dq                         (emif_hps_emif_mem_0_mem_dq),
 .emif_hps_emif_oct_0_oct_rzqin                      (emif_hps_emif_oct_0_oct_rzqin),
 .emif_hps_emif_ref_clk_0_clk                        (emif_hps_emif_ref_clk_0_clk),
 .hps_io_sdmmc_cclk                                  (hps_sdmmc_CCLK),   
 .hps_io_sdmmc_cmd                                   (hps_sdmmc_CMD), 
 .hps_io_sdmmc_data0                                 (hps_sdmmc_D0),          
 .hps_io_sdmmc_data1                                 (hps_sdmmc_D1),          
 .hps_io_sdmmc_data2                                 (hps_sdmmc_D2),         
 .hps_io_sdmmc_data3                                 (hps_sdmmc_D3),        
 .hps_io_uart0_rx                                    (hps_uart0_RX),          
 .hps_io_uart0_tx                                    (hps_uart0_TX), 
 .usb31_io_vbus_det                                  (usb31_io_vbus_det), 
 .usb31_io_flt_bar                                   (usb31_io_flt_bar),                   
 .usb31_io_usb_ctrl                                  (usb31_io_usb_ctrl),
 .usb31_io_usb31_id                                  (usb31_io_usb31_id),                  
 .usb31_phy_refclk_p_clk                             (usb31_phy_refclk_p_clk),                        
 .usb31_phy_rx_serial_n_i_rx_serial_n                (usb31_phy_rx_serial_n_i_rx_serial_n),
 .usb31_phy_rx_serial_p_i_rx_serial_p                (usb31_phy_rx_serial_p_i_rx_serial_p),
 .usb31_phy_tx_serial_n_o_tx_serial_n                (usb31_phy_tx_serial_n_o_tx_serial_n),
 .usb31_phy_tx_serial_p_o_tx_serial_p                (usb31_phy_tx_serial_p_o_tx_serial_p),
 .usb31_phy_pma_cpu_clk_clk                          (o_pma_cpu_clk),
 .o_pma_cu_clk_clk                                   (o_pma_cpu_clk),
 .hps_io_usb1_clk                                    (hps_usb1_CLK), 
 .hps_io_usb1_stp                                    (hps_usb1_STP), 
 .hps_io_usb1_dir                                    (hps_usb1_DIR),
 // Todo clarify for NXT or NXR
 .hps_io_usb1_nxt                                    (hps_usb1_NXT),
 .hps_io_usb1_data0                                  (hps_usb1_DATA0),
 .hps_io_usb1_data1                                  (hps_usb1_DATA1), 
 .hps_io_usb1_data2                                  (hps_usb1_DATA2), 
 .hps_io_usb1_data3                                  (hps_usb1_DATA3), 
 .hps_io_usb1_data4                                  (hps_usb1_DATA4), 
 .hps_io_usb1_data5                                  (hps_usb1_DATA5),
 .hps_io_usb1_data6                                  (hps_usb1_DATA6), 
 .hps_io_usb1_data7                                  (hps_usb1_DATA7),
 .hps_io_gpio0                                       (hps_gpio0_io0),
 .hps_io_gpio10                                      (hps_gpio0_io10),
 .f2h_irq1_in_irq                                    (f2h_irq1_irq),
 //.fpga2hps_interrupt_irq                           (fpga2hps_interrupt_irq),
 .hps_io_hps_osc_clk                                 (hps_osc_clk), 
 .o_src_rs_grant_src_rs_grant                        (src_grant), 
 .i_src_rs_priority_src_rs_priority                  (src_priority),
 .i_src_rs_req_src_rs_req                            (src_req),   
 .mm_bridge_0140_017f_m0_waitrequest	             (mm_bridge_0140_017f_m0_waitrequest), 
 .mm_bridge_0140_017f_m0_readdata	                 (mm_bridge_0140_017f_m0_readdata),     
 .mm_bridge_0140_017f_m0_readdatavalid	             (mm_bridge_0140_017f_m0_readdatavalid),
 .mm_bridge_0140_017f_m0_burstcount	                 (),   
 .mm_bridge_0140_017f_m0_writedata	                 (),    
 .mm_bridge_0140_017f_m0_address	                 (),      
 .mm_bridge_0140_017f_m0_write		                 (mm_bridge_0140_017f_m0_write),        
 .mm_bridge_0140_017f_m0_read		                 (mm_bridge_0140_017f_m0_read),        
 .mm_bridge_0140_017f_m0_byteenable	                 (),   
 .mm_bridge_0140_017f_m0_debugaccess	             (),
 .mm_bridge_0380_03ff_m0_waitrequest	             (mm_bridge_0380_03ff_m0_waitrequest), 
 .mm_bridge_0380_03ff_m0_readdata	                 (mm_bridge_0380_03ff_m0_readdata),    
 .mm_bridge_0380_03ff_m0_readdatavalid	             (mm_bridge_0380_03ff_m0_readdatavalid),
 .mm_bridge_0380_03ff_m0_burstcount	                 (),   
 .mm_bridge_0380_03ff_m0_writedata	                 (),    
 .mm_bridge_0380_03ff_m0_address	                 (),      
 .mm_bridge_0380_03ff_m0_write		                 (mm_bridge_0380_03ff_m0_write),        
 .mm_bridge_0380_03ff_m0_read		                 (mm_bridge_0380_03ff_m0_read),         
 .mm_bridge_0380_03ff_m0_byteenable	                 (),   
 .mm_bridge_0380_03ff_m0_debugaccess	             (),   	
 .mm_bridge_01c0_01ff_m0_waitrequest	             (mm_bridge_01c0_01ff_m0_waitrequest), 
 .mm_bridge_01c0_01ff_m0_readdata	                 (mm_bridge_01c0_01ff_m0_readdata),    
 .mm_bridge_01c0_01ff_m0_readdatavalid	             (mm_bridge_01c0_01ff_m0_readdatavalid),
 .mm_bridge_01c0_01ff_m0_burstcount	                 (),   
 .mm_bridge_01c0_01ff_m0_writedata	                 (),    
 .mm_bridge_01c0_01ff_m0_address	                 (),     
 .mm_bridge_01c0_01ff_m0_write		                 (mm_bridge_01c0_01ff_m0_write),       
 .mm_bridge_01c0_01ff_m0_read		                 (mm_bridge_01c0_01ff_m0_read),       
 .mm_bridge_01c0_01ff_m0_byteenable	                 (),
 .mm_bridge_01c0_01ff_m0_debugaccess	             (),  
 .mm_bridge_0240_027f_m0_waitrequest	             (mm_bridge_0240_027f_m0_waitrequest),  
 .mm_bridge_0240_027f_m0_readdata	                 (mm_bridge_0240_027f_m0_readdata),     
 .mm_bridge_0240_027f_m0_readdatavalid	             (mm_bridge_0240_027f_m0_readdatavalid),
 .mm_bridge_0240_027f_m0_burstcount	                 (),   
 .mm_bridge_0240_027f_m0_writedata	                 (),    
 .mm_bridge_0240_027f_m0_address	                 (),      
 .mm_bridge_0240_027f_m0_write		                 (mm_bridge_0240_027f_m0_write),        
 .mm_bridge_0240_027f_m0_read		                 (mm_bridge_0240_027f_m0_read),         
 .mm_bridge_0240_027f_m0_byteenable	                 (),  
 .mm_bridge_0240_027f_m0_debugaccess	             (),  
 .mm_bridge_0280_02ff_m0_waitrequest	             (mm_bridge_0280_02ff_m0_waitrequest),  
 .mm_bridge_0280_02ff_m0_readdata	                 (mm_bridge_0280_02ff_m0_readdata),     
 .mm_bridge_0280_02ff_m0_readdatavalid	             (mm_bridge_0280_02ff_m0_readdatavalid),
 .mm_bridge_0280_02ff_m0_burstcount	                 (),   
 .mm_bridge_0280_02ff_m0_writedata	                 (),    
 .mm_bridge_0280_02ff_m0_address	                 (),      
 .mm_bridge_0280_02ff_m0_write		                 (mm_bridge_0280_02ff_m0_write),        
 .mm_bridge_0280_02ff_m0_read		                 (mm_bridge_0280_02ff_m0_read),         
 .mm_bridge_0280_02ff_m0_byteenable	                 (),  
 .mm_bridge_0280_02ff_m0_debugaccess	             (),  
 .mm_bridge_0400_04ff_m0_waitrequest	             (mm_bridge_0400_04ff_m0_waitrequest),
 .mm_bridge_0400_04ff_m0_readdata	                 (mm_bridge_0400_04ff_m0_readdata),
 .mm_bridge_0400_04ff_m0_readdatavalid               (mm_bridge_0400_04ff_m0_readdatavalid),
 .mm_bridge_0400_04ff_m0_burstcount	                 (),
 .mm_bridge_0400_04ff_m0_writedata	                 (),
 .mm_bridge_0400_04ff_m0_address	                 (),
 .mm_bridge_0400_04ff_m0_write		                 (mm_bridge_0400_04ff_m0_write),
 .mm_bridge_0400_04ff_m0_read		                 (mm_bridge_0400_04ff_m0_read),
 .mm_bridge_0400_04ff_m0_byteenable	                 (),
 .mm_bridge_0400_04ff_m0_debugaccess	             (),
 .mm_bridge_0500_05ff_m0_waitrequest	             (mdio_csr_waitrequest),
 .mm_bridge_0500_05ff_m0_readdata	                 (mdio_csr_readdata),
 .mm_bridge_0500_05ff_m0_readdatavalid               (mdio_csr_readdatavalid),
 .mm_bridge_0500_05ff_m0_burstcount	                 (),
 .mm_bridge_0500_05ff_m0_writedata	                 (mdio_csr_writedata),
 .mm_bridge_0500_05ff_m0_address                     (mdio_csr_address),
 .mm_bridge_0500_05ff_m0_write		                 (mdio_csr_write),
 .mm_bridge_0500_05ff_m0_read		                 (mdio_csr_read),
 .mm_bridge_0500_05ff_m0_byteenable	                 (),
 .mm_bridge_0500_05ff_m0_debugaccess	             (),
 .mm_bridge_0600_06ff_m0_waitrequest	             (i2c_csr_waitrequest),
 .mm_bridge_0600_06ff_m0_readdata	                 (i2c_csr_readdata),
 .mm_bridge_0600_06ff_m0_readdatavalid               (i2c_csr_readdatavalid),
 .mm_bridge_0600_06ff_m0_burstcount	                 (),
 .mm_bridge_0600_06ff_m0_writedata	                 (i2c_csr_writedata),
 .mm_bridge_0600_06ff_m0_address	                 (i2c_csr_address[5:0]),
 .mm_bridge_0600_06ff_m0_write		                 (i2c_csr_write),
 .mm_bridge_0600_06ff_m0_read		                 (i2c_csr_read),
 .mm_bridge_0600_06ff_m0_byteenable	                 (),  
 .mm_bridge_0600_06ff_m0_debugaccess	             (),
 .phy_clk_clk                                        (fpga_clk_100),
 .i2c_csr_readdata                                   (i2c_csr_readdata),
 .i2c_csr_writedata                                  (i2c_csr_writedata),
 .i2c_csr_address                                    (i2c_csr_address[3:0]),
 .i2c_csr_write                                      (i2c_csr_write),
 .i2c_csr_read                                       (i2c_csr_read),
 .i2c_interrupt_sender_irq                           (i2c_intr),
 .i2c_serial_sda_in                                  (i2c_sda_in),
 .i2c_serial_scl_in                                  (i2c_scl_in),
 .i2c_serial_sda_oe                                  (i2c_sda_oe),
 .i2c_serial_scl_oe                                  (i2c_scl_oe),
 .phy_reset_reset                                    (~csr_rst),
 .i_refclk_rdy_data                                  (1'b1), //Driving this to 1
 .iopll_locked_export	                             (io_pll_locked),
 .iopll_reset_reset  			                     (pll_reset),
 .fabric_iopll_0_outclk0_clk                         (measure_clk),     
 .fabric_iopll_0_outclk1_clk                         (sclk),              
 .mm_bridge_0_m0_waitrequest                         (csr_waitrequest),
 .mm_bridge_0_m0_readdata                            (csr_readdata),
 .mm_bridge_0_m0_readdatavalid                       (csr_readdatavalid),
 .mm_bridge_0_m0_burstcount                          (csr_burstcount),
 .mm_bridge_0_m0_writedata                           (csr_writedata),
 .mm_bridge_0_m0_address                             (csr_address),
 .mm_bridge_0_m0_write                               (csr_write),
 .mm_bridge_0_m0_read                                (csr_read),
 .mm_bridge_0_m0_byteenable                          (csr_byteenable),
 .mm_bridge_0_m0_debugaccess                         (csr_debugaccess),
 .phy_rst_reset                                      (phy_reset[0]),
 .avmm_reset_reset	                                 (avmm_rst),
 .reset_reset_n                                      (~system_reset),
 .fabric_mm_bridge_1_m0_waitrequest                  (mm_bridge_1_m0_waitrequest),        
 .fabric_mm_bridge_1_m0_readdata                     (mm_bridge_1_m0_readdata),           
 .fabric_mm_bridge_1_m0_readdatavalid                (mm_bridge_1_m0_readdatavalid),      
 .fabric_mm_bridge_1_m0_burstcount                   (mm_bridge_1_m0_burstcount),         
 .fabric_mm_bridge_1_m0_writedata                    (mm_bridge_1_m0_writedata),          
 .fabric_mm_bridge_1_m0_address                      (mm_bridge_1_m0_address),            
 .fabric_mm_bridge_1_m0_write                        (mm_bridge_1_m0_write),              
 .fabric_mm_bridge_1_m0_read                         (mm_bridge_1_m0_read),               
 .fabric_mm_bridge_1_m0_byteenable                   (mm_bridge_1_m0_byteenable),         
 .fabric_mm_bridge_1_m0_debugaccess                  (mm_bridge_1_m0_debugaccess),        
 .fabric_mm_bridge_3_m0_waitrequest                  (mm_bridge_3_m0_waitrequest),  
 .fabric_mm_bridge_3_m0_readdata                     (mm_bridge_3_m0_readdata),     
 .fabric_mm_bridge_3_m0_readdatavalid                (mm_bridge_3_m0_readdatavalid),
 .fabric_mm_bridge_3_m0_burstcount                   (mm_bridge_3_m0_burstcount),   
 .fabric_mm_bridge_3_m0_writedata                    (mm_bridge_3_m0_writedata),    
 .fabric_mm_bridge_3_m0_address                      (mm_bridge_3_m0_address),      
 .fabric_mm_bridge_3_m0_write                        (mm_bridge_3_m0_write),        
 .fabric_mm_bridge_3_m0_read                         (mm_bridge_3_m0_read),         
 .fabric_mm_bridge_3_m0_byteenable                   (mm_bridge_3_m0_byteenable),   
 .fabric_mm_bridge_3_m0_debugaccess                  (mm_bridge_3_m0_debugaccess), 
 .fabric_mm_bridge_5_m0_waitrequest                  (mm_bridge_5_m0_waitrequest),  
 .fabric_mm_bridge_5_m0_readdata                     (mm_bridge_5_m0_readdata),     
 .fabric_mm_bridge_5_m0_readdatavalid                (mm_bridge_5_m0_readdatavalid),
 .fabric_mm_bridge_5_m0_burstcount                   (mm_bridge_5_m0_burstcount),   
 .fabric_mm_bridge_5_m0_writedata                    (mm_bridge_5_m0_writedata),    
 .fabric_mm_bridge_5_m0_address                      (mm_bridge_5_m0_address),      
 .fabric_mm_bridge_5_m0_write                        (mm_bridge_5_m0_write),        
 .fabric_mm_bridge_5_m0_read                         (mm_bridge_5_m0_read),         
 .fabric_mm_bridge_5_m0_byteenable                   (mm_bridge_5_m0_byteenable),   
 .fabric_mm_bridge_5_m0_debugaccess                  (mm_bridge_5_m0_debugaccess), 
 .fabric_mm_bridge_dr_ctrl_m0_waitrequest            (mm_bridge_dr_ctrl_m0_waitrequest),  
 .fabric_mm_bridge_dr_ctrl_m0_readdata               (mm_bridge_dr_ctrl_m0_readdata),     
 .fabric_mm_bridge_dr_ctrl_m0_readdatavalid          (mm_bridge_dr_ctrl_m0_readdatavalid),
 .fabric_mm_bridge_dr_ctrl_m0_burstcount             (mm_bridge_dr_ctrl_m0_burstcount),   
 .fabric_mm_bridge_dr_ctrl_m0_writedata              (mm_bridge_dr_ctrl_m0_writedata),    
 .fabric_mm_bridge_dr_ctrl_m0_address                (mm_bridge_dr_ctrl_m0_address),      
 .fabric_mm_bridge_dr_ctrl_m0_write                  (mm_bridge_dr_ctrl_m0_write),        
 .fabric_mm_bridge_dr_ctrl_m0_read                   (mm_bridge_dr_ctrl_m0_read),         
 .fabric_mm_bridge_dr_ctrl_m0_byteenable             (mm_bridge_dr_ctrl_m0_byteenable),   
 .fabric_mm_bridge_dr_ctrl_m0_debugaccess            (mm_bridge_dr_ctrl_m0_debugaccess),
 .fabric_intel_systemclk_gts_0_o_pll_lock_o_pll_lock        (sys_pll_locked),
 .intel_systemclk_gts_0_refclk_xcvr_clk	             (osc_clk),
 .fabric_intel_systemclk_gts_0_o_syspll_c0_clk       (tsn_gts_0_c0_clk)
);

//Generating mdio/i2c_csr_readdatavalid signal
always @(posedge fpga_clk_100) begin 
    if(csr_rst == 1'b0) begin
        mdio_csr_readdatavalid  <= 1'b0 ;
		i2c_csr_readdatavalid  <= 1'b0 ;
		i2c_csr_readdatavalid_delay <= 1'b0 ;
    end else begin  
		mdio_csr_readdatavalid <= mdio_csr_read & ~mdio_csr_waitrequest;
		i2c_csr_readdatavalid_delay <= i2c_csr_read;
		i2c_csr_readdatavalid <= i2c_csr_readdatavalid_delay;
		//i2c_csr_readdatavalid  <= i2c_csr_read & ~i2c_csr_waitrequest;
	end
end	

//Generating i2c_csr_waitrequest signal
always @(posedge fpga_clk_100)	begin
//		if(csr_rst == 1'b0)
//			i2c_csr_waitrequest <= 1'b1;
//		else if((i2c_csr_waitrequest != 0) && (i2c_csr_read)) //(i2c_csr_write | i2c_csr_read))
//			i2c_csr_waitrequest <= 1'b0;
//		else
			i2c_csr_waitrequest <= 1'b0;//1'b1;
end
		
assign i2c_scl_in = i2c_scl;
assign i2c_scl = i2c_scl_oe ? 1'b0 : 1'bz;
	   
assign i2c_sda_in = i2c_sda;
assign i2c_sda = i2c_sda_oe ? 1'b0 : 1'bz;

always @(posedge fpga_clk_100)	begin
	sfp28_int_reg1 <= sfp28_int;
	sfp28_tx_fault_reg1 <= sfp28_tx_fault;
	sfp28_los_reg1 <= sfp28_los;
	sfp28_mod_det_reg1 <= sfp28_mod_det;
end

always @(posedge fpga_clk_100)	begin
	sfp28_int_reg2 <= sfp28_int_reg1;
	sfp28_tx_fault_reg2 <= sfp28_tx_fault_reg1;
	sfp28_los_reg2 <= sfp28_los_reg1;
	sfp28_mod_det_reg2 <= sfp28_mod_det_reg1;
end

//Reset controller
rst_ctrl #(.NUM_PHY(NUM_PHY)) rst_ctrl_inst (
 .app_pp_h2f_reset		(h2f_reset),
 .app_pp_system_rst_n	(~system_reset),
 .app_pp_system_clk		(fpga_clk_100),
 .app_pp_ninit_done		(ninit_done),
 .app_pp_pll_locked		(io_pll_locked), //Connect this to iopll_locked_export (io_pll_locked),
 .pp_app_pll_rst		(pll_reset),	 //Connect this to iopll_reset_reset
 .pp_app_csr_rst_n		(csr_rst),
 .pp_app_avmm_rst		(avmm_rst),
 .csr_o_rst_n			(csr_o_rst_n),
 .sync_ack_i_rst_n		(sync_ack_i_rst_n),
 .sync_mrphy_pll_lock_i	(sync_mrphy_pll_lock_i),
 .sync_rx_ready_i		(sync_rx_ready_i),
 .sync_tx_ready_i		(sync_tx_ready_i),
 .o_rst_n				(o_rst_n),
 .emac_mac_rst_tx_n		(emac_mac_rst_tx_n),
 .emac_mac_rst_rx_n		(emac_mac_rst_rx_n),
 .phy_reset             (phy_reset),
 .gmii8b_rst_tx_n       (gmii8b_rst_tx_n),
 .tx_digitalreset       (tx_digitalreset),
 .gmii8b_rst_rx_n       (gmii8b_rst_rx_n),
 .rx_digitalreset		(rx_digitalreset)
); 
	
//CSR Register space
csr_shell #(.NUM_PHY(NUM_PHY)) usr_csr_space (
//input
 .csr_clk		     	(fpga_clk_100),
 .reset					(avmm_rst),
 .csr_wr_data			(csr_writedata),
 .csr_read				(csr_read),			
 .csr_write				(csr_write),
 .csr_byteenable		(csr_byteenable),
 .csr_address			(csr_address),
 .csr_waitrequest		(csr_waitrequest),	
 .csr_rd_data			(csr_readdata),
 .csr_rd_vld			(csr_readdatavalid),
 .mrphy_pll_lock_i	    (reg_mrphy_pll_lock),
 .rx_ready_i			(reg_rx_rdy),
 .tx_ready_i            (reg_tx_rdy),
 .rx_block_lock_i       (reg_blk_lock),//Check1 - if this connection is correct
 .reg_op_speed          (reg_op_speed),
 .ack_i_rst_n           (ack_rst_n),
 .ack_i_tx_rst_n        (ack_tx_rst_n),
 .ack_i_rx_rst_n        (ack_rx_rst_n),
 .we_dr_err_stat_i      (dr_err_status),	
 .dr_in_progress        (dr_in_progress), 
 .phy_delay_i			(16'b0),//Check1 - Temp, Driving to 0
 .csr_o_rst_n			(csr_o_rst_n),
 .o_tx_rst_n			(phy_tx_rst_n),
 .o_rx_rst_n			(phy_rx_rst_n),
 .sync_ack_i_rst_n		(sync_ack_i_rst_n),
 .sync_mrphy_pll_lock_i	(sync_mrphy_pll_lock_i),
 .sync_rx_ready_i		(sync_rx_ready_i),
 .sync_tx_ready_i		(sync_tx_ready_i),
 .sfp28_int_i       	(sfp28_int),
 .sfp28_tx_fault_i      (sfp28_tx_fault),
 .sfp28_los_i           (sfp28_los),
 .sfp28_mod_det_i       (sfp28_mod_det),
 .sfp28_tx_disable_o    (sfp28_tx_disable)
);

tsn_rsvd_csr#(.DATA_WIDTH(16)
) csr_0140_017f ( 
 .clk				(fpga_clk_100),
 .rst				(avmm_rst),
 .write_i			(mm_bridge_0140_017f_m0_write),
 .read_i			(mm_bridge_0140_017f_m0_read),
 .waitrequest_o		(mm_bridge_0140_017f_m0_waitrequest),
 .readdata_o		(mm_bridge_0140_017f_m0_readdata),
 .readdatavalid_o	(mm_bridge_0140_017f_m0_readdatavalid)			
);
		
tsn_rsvd_csr#(.DATA_WIDTH(16)
) csr_0380_03ff (
 .clk				(fpga_clk_100),
 .rst				(avmm_rst),
 .write_i			(mm_bridge_0380_03ff_m0_write),
 .read_i			(mm_bridge_0380_03ff_m0_read),
 .waitrequest_o		(mm_bridge_0380_03ff_m0_waitrequest),
 .readdata_o		(mm_bridge_0380_03ff_m0_readdata),
 .readdatavalid_o	(mm_bridge_0380_03ff_m0_readdatavalid)			
);


assign src_priority = 'b0;
assign c3_emac0_mdio_mdio = (~pp_app_emac0_mdio_mdoe) ? pp_app_emac0_mdio_mdo : 1'bz;
assign app_pp_emac0_mdio_mdi  = c3_emac0_mdio_mdio;
		
tsn_rsvd_csr #(.DATA_WIDTH(16)
) csr_01c0_01ff (
 .clk				(fpga_clk_100),
 .rst				(avmm_rst),
 .write_i			(mm_bridge_01c0_01ff_m0_write),
 .read_i			(mm_bridge_01c0_01ff_m0_read),
 .waitrequest_o		(mm_bridge_01c0_01ff_m0_waitrequest),
 .readdata_o		(mm_bridge_01c0_01ff_m0_readdata),
 .readdatavalid_o	(mm_bridge_01c0_01ff_m0_readdatavalid)			
);

tsn_rsvd_csr #(.DATA_WIDTH(16)
) csr_0240_027f (
 .clk				(fpga_clk_100),
 .rst				(avmm_rst),
 .write_i			(mm_bridge_0240_027f_m0_write),
 .read_i			(mm_bridge_0240_027f_m0_read),
 .waitrequest_o		(mm_bridge_0240_027f_m0_waitrequest),
 .readdata_o		(mm_bridge_0240_027f_m0_readdata),
 .readdatavalid_o	(mm_bridge_0240_027f_m0_readdatavalid)			
);

tsn_rsvd_csr #(.DATA_WIDTH(16)
) csr_0280_02ff (
 .clk				(fpga_clk_100),
 .rst				(avmm_rst),
 .write_i			(mm_bridge_0280_02ff_m0_write),
 .read_i			(mm_bridge_0280_02ff_m0_read),
 .waitrequest_o		(mm_bridge_0280_02ff_m0_waitrequest),
 .readdata_o		(mm_bridge_0280_02ff_m0_readdata),
 .readdatavalid_o	(mm_bridge_0280_02ff_m0_readdatavalid)	
);
		
tsn_rsvd_csr csr_0400_04ff (
 .clk				(fpga_clk_100),
 .rst				(avmm_rst),
 .write_i			(mm_bridge_0400_04ff_m0_write),
 .read_i			(mm_bridge_0400_04ff_m0_read),
 .waitrequest_o		(mm_bridge_0400_04ff_m0_waitrequest),
 .readdata_o		(mm_bridge_0400_04ff_m0_readdata),
 .readdatavalid_o	(mm_bridge_0400_04ff_m0_readdatavalid)			
);
		
//ETHERNET MDIO Core IP
altera_eth_mdio avmm2mdio (
 .clk               (fpga_clk_100)          //   input,   width = 1,       clock.clk
 ,.reset		    (~csr_rst)              //   input,   width = 1, clock_reset.reset
 ,.csr_read         (mdio_csr_read       )  //   input,   width = 1,         csr.write
 ,.csr_write        (mdio_csr_write      )  //   input,   width = 1,            .read
 ,.csr_address      (mdio_csr_address    )  //   input,   width = 6,            .address
 ,.csr_writedata    (mdio_csr_writedata  )  //   input,  width = 32,            .writedata
 ,.csr_readdata     (mdio_csr_readdata   )  //  output,  width = 32,            .readdata
 ,.csr_waitrequest	(mdio_csr_waitrequest)	//  output,   width = 1,            .waitrequest
 ,.mdc              (c3_emac0_mdio_mdc)     //  output,   width = 1,        mdio.mdc
 ,.mdio_in          (app_pp_emac0_mdio_mdi) //   input,   width = 1,            .mdio_in
 ,.mdio_out         (pp_app_emac0_mdio_mdo) //  output,   width = 1,            .mdio_out
 ,.mdio_oen         (pp_app_emac0_mdio_mdoe)//  output,   width = 1,            .mdio_oen		
);

always @(posedge system_clk_100 or posedge system_reset) begin
  if (system_reset)
    heartbeat_count <= 23'd0;
  else
    heartbeat_count <= heartbeat_count + 23'd1;
end

endmodule

