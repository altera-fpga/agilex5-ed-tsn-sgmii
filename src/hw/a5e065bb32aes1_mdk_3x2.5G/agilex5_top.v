//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// Copyright(c) 2019-2021 Intel Corporation.
//
//****************************************************************************
// This is a generated system top level RTL file. 

// Derive channel and width from hps_emif_topology

// Find and print each number individually

module agilex5_top #(parameter NUM_PHY=3)(
//Additional refclk_bti to preserve Etile XCVR
// Clock and Reset
input    wire          fpga_clk_100,

output   wire          fpga_led_pio,
input    wire          fpga_button_pio,
//HPS
// HPS EMIF
output   wire          emif_hps_emif_mem_0_mem_ck_t,
output   wire          emif_hps_emif_mem_0_mem_ck_c,
output   wire [16:0]   emif_hps_emif_mem_0_mem_a,
output   wire          emif_hps_emif_mem_0_mem_act_n,
output   wire [1:0]    emif_hps_emif_mem_0_mem_ba,
output   wire [1:0]    emif_hps_emif_mem_0_mem_bg,
output   wire          emif_hps_emif_mem_0_mem_cke,
output   wire          emif_hps_emif_mem_0_mem_cs_n,
output   wire          emif_hps_emif_mem_0_mem_odt,
output   wire          emif_hps_emif_mem_0_mem_reset_n,
output   wire          emif_hps_emif_mem_0_mem_par,
input    wire          emif_hps_emif_mem_0_mem_alert_n,
input    wire          emif_hps_emif_oct_0_oct_rzqin,
input    wire          emif_hps_emif_ref_clk_0_clk,
inout    wire [3:0]    emif_hps_emif_mem_0_mem_dqs_t,
inout    wire [3:0]    emif_hps_emif_mem_0_mem_dqs_c,
inout    wire [31:0]   emif_hps_emif_mem_0_mem_dq,
output   wire          hps_sdmmc_CCLK, 
inout    wire          hps_sdmmc_CMD,          
inout    wire          hps_sdmmc_D0,          
inout    wire          hps_sdmmc_D1,          
inout    wire          hps_sdmmc_D2,        
inout    wire          hps_sdmmc_D3,        

input    wire          usb31_io_vbus_det,                  
input    wire          usb31_io_flt_bar,                   
output   wire [1:0]    usb31_io_usb_ctrl,
input    wire          usb31_io_usb31_id,                  
input    wire          usb31_phy_refclk_p_clk,             
//input    wire          usb31_phy_refclk_p_clk(n),             
input    wire          usb31_phy_rx_serial_n_i_rx_serial_n,
input    wire          usb31_phy_rx_serial_p_i_rx_serial_p,
output   wire          usb31_phy_tx_serial_n_o_tx_serial_n,
output   wire          usb31_phy_tx_serial_p_o_tx_serial_p,
inout    wire          hps_usb1_DATA0,         
inout    wire          hps_usb1_DATA1,      
inout    wire          hps_usb1_DATA2,        
inout    wire          hps_usb1_DATA3,       
inout    wire          hps_usb1_DATA4,        
inout    wire          hps_usb1_DATA5,      
inout    wire          hps_usb1_DATA6,      
inout    wire          hps_usb1_DATA7,         
input    wire          hps_usb1_CLK,         
output   wire          hps_usb1_STP,       
input    wire          hps_usb1_DIR,        
input    wire          hps_usb1_NXT, 
input    wire          hps_uart0_RX,       
output   wire          hps_uart0_TX, 
inout    wire          hps_gpio0_io0,
inout    wire          hps_gpio0_io10,

inout wire 			          c3_emac0_mdio_mdio0,
output wire 				  c3_emac0_mdio_mdc0,
output wire 	[NUM_PHY-1:0] pp_app_tx_serial_data,
output wire 	[NUM_PHY-1:0] pp_app_tx_serial_data_n,
input wire      [NUM_PHY-1:0] emac_ptp_trig,
output wire     [NUM_PHY-1:0] emac_ptp_pps,
input wire 		[NUM_PHY-1:0] app_pp_rx_serial_data,
input wire 		[NUM_PHY-1:0] app_pp_rx_serial_data_n,
input wire					  osc_clk,

inout	wire			i2c_scl,
inout	wire			i2c_sda,
input          sfp28_int,
input          sfp28_tx_fault,
input          sfp28_los,
input          sfp28_mod_det,
output         sfp28_tx_disable,
inout   wire 			c3_emac0_mdio_mdio,
output  wire 			c3_emac0_mdio_mdc,






input    wire          hps_osc_clk,
input    wire          fpga_reset_n

);

wire                   system_clk_100;
wire                   ninit_done;
wire                   fpga_reset_n_debounced_wire;
reg                    fpga_reset_n_debounced;
wire                   system_reset;
wire                 h2f_reset;

assign                combined_reset_n = fpga_reset_n & ~h2f_reset
& ~ninit_done;

altera_reset_synchronizer #(
    .ASYNC_RESET (1),
    .DEPTH       (2)
) sys_rst_inst (
    .reset_in  (~combined_reset_n),
    .clk       (system_clk_100),
    .reset_out (system_reset)
);
             
assign                 system_clk_100   = fpga_clk_100;

wire [4-1:0]        fpga_debounced_buttons;
wire                   heartbeat_led;
reg  [22:0]            heartbeat_count;
assign                 heartbeat_led = ~heartbeat_count[22];
assign                 fpga_led_pio = heartbeat_led;
wire	app_pp_emac0_mdio_mdi0;		
wire	pp_app_emac0_mdio_mdo0;
wire	pp_app_emac0_mdio_mdoe0;
//wire h2f_reset;
wire csr_rst;
wire avmm_rst;
wire phy_reset;
wire sys_pll_locked;
wire io_pll_locked;
wire pll_reset;
wire    [NUM_PHY-1:0] src_grant, src_priority, src_req;
wire    o_pma_clk;
wire	[NUM_PHY-1:0] reg_mrphy_pll_lock, reg_tx_rdy, reg_rx_rdy, 
						  reg_blk_lock;
wire    [3*NUM_PHY - 1:0] reg_op_speed;						
wire	[NUM_PHY-1:0] phy_tx_rst_n, phy_rx_rst_n;
wire 	[NUM_PHY-1:0] ack_rst_n, ack_tx_rst_n, ack_rx_rst_n;
wire 	[NUM_PHY-1:0] emac_mac_rst_tx_n, emac_mac_rst_rx_n;
wire	[NUM_PHY-1:0] o_rst_n, csr_o_rst_n, sync_ack_i_rst_n, sync_mrphy_pll_lock_i,
		      sync_rx_ready_i, sync_tx_ready_i;
//HPS - MRPHY
wire		[7:0]	hps_mrphy_data 		[NUM_PHY-1:0];
wire		[NUM_PHY-1:0]		hps_mrphy_data_vld;
wire		[NUM_PHY-1:0]		hps_mrphy_err;
wire 		[NUM_PHY-1:0]		gmii8b_rst_tx_n, gmii8b_rst_rx_n, tx_digitalreset, rx_digitalreset;
wire		[7:0]  mrphy_hps_data [NUM_PHY-1:0];
wire		[NUM_PHY-1:0]		mrphy_hps_data_vld;
wire		[NUM_PHY-1:0]		mrphy_hps_err;
wire		[2:0] 	mac_speed [NUM_PHY-1:0];
wire 		[NUM_PHY-1:0]		mac_col_det;
wire		[NUM_PHY-1:0]		mac_car_sense;
wire 		[NUM_PHY-1:0]		mrphy_hps_tx_clk;
wire 		[NUM_PHY-1:0]		mrphy_hps_rx_clk;
wire 		[NUM_PHY-1:0]		hps_mrphy_tx_clk; 
//Avalon interface wires
wire        csr_waitrequest; 
wire [31:0] csr_readdata;     
wire        csr_readdatavalid;
wire [0:0]  csr_burstcount;   
wire [31:0] csr_writedata;    
wire [6:0]  csr_address;      
wire        csr_write;        
wire        csr_read;         
wire [3:0]  csr_byteenable;  
wire        csr_debugaccess;
wire 	    mm_bridge_0140_017f_m0_write;
wire 	    mm_bridge_0140_017f_m0_read;
wire        mm_bridge_0140_017f_m0_waitrequest;
wire [15:0] mm_bridge_0140_017f_m0_readdata;
wire  	    mm_bridge_0140_017f_m0_readdatavalid;
wire        mm_bridge_0380_03ff_m0_write;
wire  	    mm_bridge_0380_03ff_m0_read;
wire  	    mm_bridge_0380_03ff_m0_waitrequest;
wire [31:0] mm_bridge_0380_03ff_m0_readdata;
wire        mm_bridge_0380_03ff_m0_readdatavalid;
wire  	    mm_bridge_01c0_01ff_m0_write;
wire        mm_bridge_01c0_01ff_m0_read;
wire  	    mm_bridge_01c0_01ff_m0_waitrequest;
wire [31:0] mm_bridge_01c0_01ff_m0_readdata;
wire        mm_bridge_01c0_01ff_m0_readdatavalid;
wire  	    mm_bridge_0240_027f_m0_write;
wire  	    mm_bridge_0240_027f_m0_read;
wire        mm_bridge_0240_027f_m0_waitrequest;
wire [31:0] mm_bridge_0240_027f_m0_readdata;
wire  	    mm_bridge_0240_027f_m0_readdatavalid;
wire  	    mm_bridge_0280_02ff_m0_write;
wire  	    mm_bridge_0280_02ff_m0_read;
wire        mm_bridge_0280_02ff_m0_waitrequest;
wire [31:0] mm_bridge_0280_02ff_m0_readdata;
wire  	    mm_bridge_0280_02ff_m0_readdatavalid;
wire  	    mm_bridge_0400_04ff_m0_write;
wire  	    mm_bridge_0400_04ff_m0_read;
wire        mm_bridge_0400_04ff_m0_waitrequest;
wire [31:0] mm_bridge_0400_04ff_m0_readdata;
wire  	    mm_bridge_0400_04ff_m0_readdatavalid;
wire		i2c_scl_oe;
wire		i2c_sda_oe;
wire		i2c_scl_in;
wire		i2c_sda_in;
wire		i2c_intr;
reg		sfp28_int_reg1;
reg		sfp28_int_reg2;
reg		sfp28_tx_fault_reg1;
reg		sfp28_tx_fault_reg2;
reg		sfp28_los_reg1;
reg		sfp28_los_reg2;
reg		sfp28_mod_det_reg1;
reg		sfp28_mod_det_reg2;
//reg		sfp28_tx_disable;
//AVMM master to phymgmt
wire [31:0] i2c_csr_readdata;    
wire [31:0] i2c_csr_writedata;    
wire [10:0] i2c_csr_address;      
wire        i2c_csr_write;        
wire        i2c_csr_read;     
reg         i2c_csr_waitrequest;     
reg         i2c_csr_readdatavalid;  
reg         i2c_csr_readdatavalid_delay;   
//Avalon interface wires to MDIO IP
wire        mdio_csr_waitrequest; 
wire [31:0] mdio_csr_readdata;     
reg         mdio_csr_readdatavalid;
wire [0:0]  mdio_csr_burstcount;   
wire [31:0] mdio_csr_writedata;    
wire [5:0]  mdio_csr_address;      
wire        mdio_csr_write;        
wire        mdio_csr_read;         
wire [3:0]  mdio_csr_byteenable;  
wire        mdio_csr_debugaccess;
wire	app_pp_emac0_mdio_mdi;		
wire	pp_app_emac0_mdio_mdo;
wire	pp_app_emac0_mdio_mdoe;

wire [31:0]            f2h_irq1_irq;
assign                 f2h_irq1_irq[31:0]    = {29'b0,i2c_intr,2'b0};
wire                   o_pma_cpu_clk;



// Qsys Top module
qsys_top soc_inst (
.clk_100_clk                               (system_clk_100),
.ninit_done_ninit_done                     (ninit_done),
//.led_pio_external_connection_in_port       (fpga_led_internal),
//.led_pio_external_connection_out_port      (fpga_led_internal),
//.dipsw_pio_external_connection_export      (fpga_dipsw_pio),
//.button_pio_external_connection_export     (fpga_debounced_buttons),

 .csr_rst_reset_n							(csr_rst),
 //.ocm_clk1_clk								(),
 //.ocm_reset1_reset							(),
 //.ocm_reset1_reset_req						(),
 .h2f_reset_reset							(h2f_reset),
 .emac_ptp_clk_clk          	   	   	    ('b0), 
 .emac_timestamp_data_data_in    	   	    (64'b0),
 .emac_timestamp_clk_clk    	   	   	    ('b0),
 .emac0_ptp_mac_ptp_trig			    (emac_ptp_trig[0]),
 .emac0_ptp_mac_ptp_pps				    (emac_ptp_pps[0]),
 .emac0_ptp_mac_ptp_tstmp_data			    (),	
 .emac0_ptp_mac_ptp_tstmp_en			    (),
 .emac0_mac_tx_clk_o        	   	   	    (hps_mrphy_tx_clk[0]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac0_mac_tx_clk_i        	   	   	    (mrphy_hps_tx_clk[0]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac0_mac_rx_clk           		 	   (mrphy_hps_rx_clk[0]),
 .emac0_mac_rst_tx_n         	   	   	   (emac_mac_rst_tx_n[0]),
 .emac0_mac_rst_rx_n         	   	   	   (emac_mac_rst_rx_n[0]),
 .emac0_mac_txen             	   	   	   (hps_mrphy_data_vld[0]),
 .emac0_mac_txer             	   	   	   (hps_mrphy_err[0]    ),
 .emac0_mac_rxdv             		 	   (mrphy_hps_data_vld[0]),
 .emac0_mac_rxer             	   	   	   (mrphy_hps_err[0]    ),
 .emac0_mac_rxd              	   	   	   (mrphy_hps_data[0]	),
 .emac0_mac_col              	   	   	   ('b0),
 .emac0_mac_crs              	   	   	   ('b0),
 .emac0_mac_speed            		 	   (mac_speed[0]),
 .emac0_mac_txd_o            	   	   	   (hps_mrphy_data[0]),
 .emac1_ptp_mac_ptp_trig			    (emac_ptp_trig[1]),
 .emac1_ptp_mac_ptp_pps				    (emac_ptp_pps[1]),
 .emac1_ptp_mac_ptp_tstmp_data			    (),	
 .emac1_ptp_mac_ptp_tstmp_en			    (),
 .emac1_mac_tx_clk_o         	   	   	   (hps_mrphy_tx_clk[1]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac1_mac_tx_clk_i         	   	   	   (mrphy_hps_tx_clk[1]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac1_mac_rx_clk           	   	   	   (mrphy_hps_rx_clk[1]),
 .emac1_mac_rst_tx_n         		 	   (emac_mac_rst_tx_n[1]),
 .emac1_mac_rst_rx_n         	   	   	   (emac_mac_rst_rx_n[1]),
 .emac1_mac_txen             	   	   	   (hps_mrphy_data_vld[1]),
 .emac1_mac_txer             	   	   	   (hps_mrphy_err[1]    ),
 .emac1_mac_rxdv             	   	   	   (mrphy_hps_data_vld[1]),
 .emac1_mac_rxer             		 	   (mrphy_hps_err[1]    ),
 .emac1_mac_rxd              	   	   	   (mrphy_hps_data[1]	),
 .emac1_mac_col              	   	   	   ('b0),
 .emac1_mac_crs              	   	   	   ('b0),
 .emac1_mac_speed            	   	   	   (mac_speed[1]),
 .emac1_mac_txd_o            		 	   (hps_mrphy_data[1]),
 .emac2_ptp_mac_ptp_trig			    (emac_ptp_trig[2]),
 .emac2_ptp_mac_ptp_pps				    (emac_ptp_pps[2]),
 .emac2_ptp_mac_ptp_tstmp_data			    (),	
 .emac2_ptp_mac_ptp_tstmp_en			    (),
 .emac2_mac_tx_clk_o         	   	   	   (hps_mrphy_tx_clk[2]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac2_mac_tx_clk_i         	   	   	   (mrphy_hps_tx_clk[2]), //HA - Check this, connecting to get rid of IOPLL Fitter error
 .emac2_mac_rx_clk           	   	   	   (mrphy_hps_rx_clk[2]),
 .emac2_mac_rst_tx_n         	   	   	   (emac_mac_rst_tx_n[2]),
 .emac2_mac_rst_rx_n         		 	   (emac_mac_rst_rx_n[2]),
 .emac2_mac_txen             	   	   	   (hps_mrphy_data_vld[2]),
 .emac2_mac_txer             	   	   	   (hps_mrphy_err[2]    ),
 .emac2_mac_rxdv             	   	   	   (mrphy_hps_data_vld[2]),
 .emac2_mac_rxer             	   	   	   (mrphy_hps_err[2]    ),
 .emac2_mac_rxd             		       (mrphy_hps_data[2]	),
 .emac2_mac_col             	   	       ('b0),
 .emac2_mac_crs             	   	       ('b0),
 .emac2_mac_speed           	   	       (mac_speed[2]),
 .emac2_mac_txd_o           	   	       (hps_mrphy_data[2]),
// .osc_clk_clk							   (osc_clk),
.emif_hps_emif_mem_ck_0_mem_ck_t           (emif_hps_emif_mem_0_mem_ck_t),
.emif_hps_emif_mem_ck_0_mem_ck_c           (emif_hps_emif_mem_0_mem_ck_c),
.emif_hps_emif_mem_0_mem_a                 (emif_hps_emif_mem_0_mem_a),
.emif_hps_emif_mem_0_mem_act_n             (emif_hps_emif_mem_0_mem_act_n),
.emif_hps_emif_mem_0_mem_ba                (emif_hps_emif_mem_0_mem_ba),
.emif_hps_emif_mem_0_mem_bg                (emif_hps_emif_mem_0_mem_bg),
.emif_hps_emif_mem_0_mem_cke               (emif_hps_emif_mem_0_mem_cke),
.emif_hps_emif_mem_0_mem_cs_n              (emif_hps_emif_mem_0_mem_cs_n),
.emif_hps_emif_mem_0_mem_odt               (emif_hps_emif_mem_0_mem_odt),
.emif_hps_emif_mem_reset_n_mem_reset_n     (emif_hps_emif_mem_0_mem_reset_n),
.emif_hps_emif_mem_0_mem_par               (emif_hps_emif_mem_0_mem_par),
.emif_hps_emif_mem_0_mem_alert_n           (emif_hps_emif_mem_0_mem_alert_n),
.emif_hps_emif_mem_0_mem_dqs_t             (emif_hps_emif_mem_0_mem_dqs_t),
.emif_hps_emif_mem_0_mem_dqs_c             (emif_hps_emif_mem_0_mem_dqs_c),
.emif_hps_emif_mem_0_mem_dq                (emif_hps_emif_mem_0_mem_dq),
.emif_hps_emif_oct_0_oct_rzqin             (emif_hps_emif_oct_0_oct_rzqin),
.emif_hps_emif_ref_clk_0_clk               (emif_hps_emif_ref_clk_0_clk),
.hps_io_sdmmc_cclk                         (hps_sdmmc_CCLK),   
.hps_io_sdmmc_cmd                          (hps_sdmmc_CMD), 
.hps_io_sdmmc_data0                        (hps_sdmmc_D0),          
.hps_io_sdmmc_data1                        (hps_sdmmc_D1),          
.hps_io_sdmmc_data2                        (hps_sdmmc_D2),         
.hps_io_sdmmc_data3                        (hps_sdmmc_D3),        
.hps_io_uart0_rx                           (hps_uart0_RX),          
.hps_io_uart0_tx                           (hps_uart0_TX), 
.usb31_io_vbus_det                         (usb31_io_vbus_det), 
.usb31_io_flt_bar                          (usb31_io_flt_bar),                   
.usb31_io_usb_ctrl                         (usb31_io_usb_ctrl),
.usb31_io_usb31_id                         (usb31_io_usb31_id),                  
.usb31_phy_refclk_p_clk                    (usb31_phy_refclk_p_clk),             
//.usb31_phy_refclk_n_clk                    (usb31_phy_refclk_p_clk(n)),             
.usb31_phy_rx_serial_n_i_rx_serial_n       (usb31_phy_rx_serial_n_i_rx_serial_n),
.usb31_phy_rx_serial_p_i_rx_serial_p       (usb31_phy_rx_serial_p_i_rx_serial_p),
.usb31_phy_tx_serial_n_o_tx_serial_n       (usb31_phy_tx_serial_n_o_tx_serial_n),
.usb31_phy_tx_serial_p_o_tx_serial_p       (usb31_phy_tx_serial_p_o_tx_serial_p),
.usb31_phy_pma_cpu_clk_clk                 (o_pma_cpu_clk),
.o_pma_cu_clk_clk                          (o_pma_cpu_clk),
.hps_io_usb1_clk                           (hps_usb1_CLK), 
.hps_io_usb1_stp                           (hps_usb1_STP), 
.hps_io_usb1_dir                           (hps_usb1_DIR),
// Todo clarify for NXT or NXR
.hps_io_usb1_nxt                           (hps_usb1_NXT),
.hps_io_usb1_data0                         (hps_usb1_DATA0),
.hps_io_usb1_data1                         (hps_usb1_DATA1), 
.hps_io_usb1_data2                         (hps_usb1_DATA2), 
.hps_io_usb1_data3                         (hps_usb1_DATA3), 
.hps_io_usb1_data4                         (hps_usb1_DATA4), 
.hps_io_usb1_data5                         (hps_usb1_DATA5),
.hps_io_usb1_data6                         (hps_usb1_DATA6), 
.hps_io_usb1_data7                         (hps_usb1_DATA7),
.hps_io_gpio0                          (hps_gpio0_io0),
.hps_io_gpio10                          (hps_gpio0_io10),
.f2h_irq1_in_irq                              (f2h_irq1_irq),
//.fpga2hps_interrupt_irq                      (fpga2hps_interrupt_irq),
.hps_io_hps_osc_clk                        (hps_osc_clk), 
.o_src_rs_grant_src_rs_grant                         (src_grant), 
.i_src_rs_priority_src_rs_priority                   (src_priority),
.i_src_rs_req_src_rs_req                             (src_req),   
.phy_0_gmii8b_tx_clkin_clk                         			(hps_mrphy_tx_clk[0]),	//HA - Check this, connecting to get rid of IOPLL Fitter error  
.phy_0_gmii8b_tx_rst_n_gmii8b_tx_rst_n             			(gmii8b_rst_tx_n[0]),
.phy_0_gmii8b_rx_rst_n_gmii8b_rx_rst_n            			(gmii8b_rst_rx_n[0]),
.phy_0_gmii8b_rx_clkout_clk                         		(mrphy_hps_rx_clk[0]),		
.phy_0_gmii8b_tx_clkout_clk                         		(mrphy_hps_tx_clk[0]),
.phy_0_rx_clkout_clk						(),			
.phy_0_tx_clkout_clk						(),
//.phy_0_rx_clkout_clk						(rx_clkout[0]),			//HA - Exported to get around fitter error
//.phy_0_tx_clkout_clk						(tx_clkout[0]),
.phy_0_rx_digitalreset_rx_digitalreset              		(rx_digitalreset[0]),
.phy_0_tx_digitalreset_tx_digitalreset                      (tx_digitalreset[0]),
.phy_0_gmii8b_mac_txen_export                               (hps_mrphy_data_vld[0]),
.phy_0_gmii8b_mac_tx_d_export                               (hps_mrphy_data[0]),
.phy_0_gmii8b_mac_txer_export                               (hps_mrphy_err[0]),
.phy_0_gmii8b_mac_rxdv_export                       		(mrphy_hps_data_vld[0]),
.phy_0_gmii8b_mac_rxd_export                                (mrphy_hps_data[0]),
.phy_0_gmii8b_mac_rxer_export                               (mrphy_hps_err[0]),
.phy_0_gmii8b_mac_speed_export                              ({mac_speed[0][2],~mac_speed[0][0]}), //ww23.1-conersion logic as shared by Emil //mac_speed[0][1:0]), 
.phy_0_operating_speed_export                               (reg_op_speed[2:0]),
.phy_0_mrphy_pll_lock_pll_locked_stable             		(reg_mrphy_pll_lock[0]),
//.phy_0_i_src_ch_pause_request_o_src_ch_pause_request        (1'b0),
//.phy_0_o_src_ch_pause_grant_i_src_ch_pause_grant            (),
.phy_0_i_rst_n_i_rst_n                                      (o_rst_n[0]),
.phy_0_o_rst_ack_n_o_rst_ack_n                              (ack_rst_n[0]),
.phy_0_i_tx_rst_n_i_tx_rst_n                       			(phy_tx_rst_n[0]),
.phy_0_i_rx_rst_n_i_rx_rst_n                                (phy_rx_rst_n[0]),
.phy_0_o_tx_rst_ack_n_o_tx_rst_ack_n                        (ack_tx_rst_n[0]),
.phy_0_o_rx_rst_ack_n_o_rx_rst_ack_n                        (ack_rx_rst_n[0]),
.phy_0_tx_ready_tx_ready                                    (reg_tx_rdy[0]),
.phy_0_rx_ready_rx_ready                           			(reg_rx_rdy[0]),
.phy_0_xcvr_mode_export                                     (2'b01),				//HA - Check once
.phy_0_i_pma_cu_clk_clk                                     (o_pma_cpu_clk),
.phy_0_i_system_pll_lock_system_pll_lock                    (sys_pll_locked),
.phy_0_i_src_rs_grant_src_rs_grant                          (src_grant[0]),
.phy_0_o_src_rs_req_src_rs_req                     	    (src_req[0]),
.phy_0_tx_serial_data_o_tx_serial_data                      (pp_app_tx_serial_data[0]),  
.phy_0_tx_serial_data_n_o_tx_serial_data_n                  (pp_app_tx_serial_data_n[0]),
.phy_0_rx_serial_data_i_rx_serial_data                      (app_pp_rx_serial_data[0]),  
.phy_0_rx_serial_data_n_i_rx_serial_data_n                  (app_pp_rx_serial_data_n[0]),
.phy_0_rx_is_lockedtodata_o_rx_is_lockedtodata		    (reg_blk_lock[0]),
.phy_0_tx_pll_refclk_p_clk				    (osc_clk),
//.phy_0_tx_pll_refclk_n_clk				    (),
.phy_0_rx_cdr_refclk_p_clk				    (osc_clk),
//.phy_0_rx_cdr_refclk_n_clk				    (),
//.srcss_o_src_rs_grant_src_rs_grant                 (src_grant),
//.srcss_i_src_rs_priority_src_rs_priority           (src_priority),      //Driving to 0
//.srcss_i_src_rs_req_src_rs_req                     (src_req),           
//.srcss_o_pma_cu_clk_clk                  (o_pma_clk),
//Transceiver reconfiguration interface from 10G Multi-rate Reconfig - unused
//.rsif_write                        ('b0),      //input    
//.rsif_read                         ('b0),      //input
//.rsif_address                      (18'b0),      //input
//.rsif_byteenable                   (4'b0),      //input
//.rsif_writedata                    (32'b0),      //input
//.rsif_readdata                     (),         //output
//.rsif_waitrequest                  (),         //output
//.rsif_readdatavalid                (),         //output
.phy_1_gmii8b_tx_clkin_clk                          		(hps_mrphy_tx_clk[1]),	//HA - Check this, connecting to get rid of IOPLL Fitter error 
.phy_1_gmii8b_tx_rst_n_gmii8b_tx_rst_n                      (gmii8b_rst_tx_n[1]),
.phy_1_gmii8b_rx_rst_n_gmii8b_rx_rst_n                      (gmii8b_rst_rx_n[1]),
.phy_1_gmii8b_rx_clkout_clk                         		(mrphy_hps_rx_clk[1]),		
.phy_1_gmii8b_tx_clkout_clk                         		(mrphy_hps_tx_clk[1]),
//.phy_1_rx_clkout_clk						(rx_clkout[1]),			//HA - Exported to get around fitter erro
//.phy_1_tx_clkout_clk						(tx_clkout[1]),
.phy_1_rx_digitalreset_rx_digitalreset                      (rx_digitalreset[1]),
.phy_1_tx_digitalreset_tx_digitalreset                      (tx_digitalreset[1]),
.phy_1_gmii8b_mac_txen_export                      			(hps_mrphy_data_vld[1]),
.phy_1_gmii8b_mac_tx_d_export                               (hps_mrphy_data[1]),
.phy_1_gmii8b_mac_txer_export                               (hps_mrphy_err[1]),
.phy_1_gmii8b_mac_rxdv_export                               (mrphy_hps_data_vld[1]),
.phy_1_gmii8b_mac_rxd_export                                (mrphy_hps_data[1]),
.phy_1_gmii8b_mac_rxer_export                      			(mrphy_hps_err[1]),
.phy_1_gmii8b_mac_speed_export                              ({mac_speed[1][2],~mac_speed[1][0]}),
//ww23.1-conersion logic as shared by Emil //mac_speed[1][1:0]), 
.phy_1_operating_speed_export                               (reg_op_speed[5:3]),
.phy_1_mrphy_pll_lock_pll_locked_stable                     (reg_mrphy_pll_lock[1]),
//.phy_1_i_src_ch_pause_request_o_src_ch_pause_request        (),
//.phy_1_o_src_ch_pause_grant_i_src_ch_pause_grant   			(),
.phy_1_i_rst_n_i_rst_n                                      (o_rst_n[1]),
.phy_1_o_rst_ack_n_o_rst_ack_n                              (ack_rst_n[1]),
.phy_1_i_tx_rst_n_i_tx_rst_n                                (phy_tx_rst_n[1]),
.phy_1_i_rx_rst_n_i_rx_rst_n                                (phy_rx_rst_n[1]),
.phy_1_o_tx_rst_ack_n_o_tx_rst_ack_n               			(ack_tx_rst_n[1]),
.phy_1_o_rx_rst_ack_n_o_rx_rst_ack_n                        (ack_rx_rst_n[1]),
.phy_1_tx_ready_tx_ready                                    (reg_tx_rdy[1]),
.phy_1_rx_ready_rx_ready                                    (reg_rx_rdy[1]),
.phy_1_xcvr_mode_export                                     (2'b01),
.phy_1_i_pma_cu_clk_clk                            			(o_pma_cpu_clk),
.phy_1_i_system_pll_lock_system_pll_lock                    (sys_pll_locked),
.phy_1_i_src_rs_grant_src_rs_grant                          (src_grant[1]),
.phy_1_o_src_rs_req_src_rs_req                              (src_req[1]),
.phy_1_tx_serial_data_o_tx_serial_data                      (pp_app_tx_serial_data[1]),  
.phy_1_tx_serial_data_n_o_tx_serial_data_n        			(pp_app_tx_serial_data_n[1]),
.phy_1_rx_serial_data_i_rx_serial_data                      (app_pp_rx_serial_data[1]),  
.phy_1_rx_serial_data_n_i_rx_serial_data_n                  (app_pp_rx_serial_data_n[1]),
.phy_1_rx_is_lockedtodata_o_rx_is_lockedtodata		    	(reg_blk_lock[1]),
.phy_1_tx_pll_refclk_p_clk                                  (osc_clk),
//.phy_1_tx_pll_refclk_n_clk                                  (),
.phy_1_rx_cdr_refclk_p_clk                                  (osc_clk),
//.phy_1_rx_cdr_refclk_n_clk                                  (),
.phy_2_gmii8b_tx_clkin_clk                                  (hps_mrphy_tx_clk[2]),	//HA - Check this, connecting to get rid of IOPLL Fitter error 
.phy_2_gmii8b_tx_rst_n_gmii8b_tx_rst_n                      (gmii8b_rst_tx_n[2]),
.phy_2_gmii8b_rx_rst_n_gmii8b_rx_rst_n              		(gmii8b_rst_rx_n[2]),
//.phy_2_rx_clkout_clk										(rx_clkout[2]),		//HA - Exported to get around fitter error
//.phy_2_tx_clkout_clk										(tx_clkout[2]),
.phy_2_gmii8b_rx_clkout_clk                         		(mrphy_hps_rx_clk[2]),		//HA - Should be there for other macs as well
.phy_2_gmii8b_tx_clkout_clk                         		(mrphy_hps_tx_clk[2]),
.phy_2_rx_digitalreset_rx_digitalreset                      (rx_digitalreset[2]),
.phy_2_tx_digitalreset_tx_digitalreset                      (tx_digitalreset[2]),
.phy_2_gmii8b_mac_txen_export                               (hps_mrphy_data_vld[2]),
.phy_2_gmii8b_mac_tx_d_export                               (hps_mrphy_data[2]),
.phy_2_gmii8b_mac_txer_export                    			(hps_mrphy_err[2]),
.phy_2_gmii8b_mac_rxdv_export                               (mrphy_hps_data_vld[2]),
.phy_2_gmii8b_mac_rxd_export                                (mrphy_hps_data[2]),
.phy_2_gmii8b_mac_rxer_export                               (mrphy_hps_err[2]),
.phy_2_gmii8b_mac_speed_export                              ({mac_speed[2][2],~mac_speed[2][0]}),
//ww23.1-conersion logic as shared by Emil //mac_speed[2][1:0]), 
.phy_2_operating_speed_export                       		(reg_op_speed[8:6]),
.phy_2_mrphy_pll_lock_pll_locked_stable                     (reg_mrphy_pll_lock[2]),
//.phy_2_i_src_ch_pause_request_o_src_ch_pause_request        (),
//.phy_2_o_src_ch_pause_grant_i_src_ch_pause_grant            (),
.phy_2_i_rst_n_i_rst_n                                      (o_rst_n[2]),
.phy_2_o_rst_ack_n_o_rst_ack_n                     			(ack_rst_n[2]),
.phy_2_i_tx_rst_n_i_tx_rst_n                                (phy_tx_rst_n[2]),
.phy_2_i_rx_rst_n_i_rx_rst_n                                (phy_rx_rst_n[2]),
.phy_2_o_tx_rst_ack_n_o_tx_rst_ack_n                        (ack_tx_rst_n[2]),
.phy_2_o_rx_rst_ack_n_o_rx_rst_ack_n                        (ack_rx_rst_n[2]),
.phy_2_tx_ready_tx_ready                           			(reg_tx_rdy[2]),
.phy_2_rx_ready_rx_ready                                    (reg_rx_rdy[2]),
.phy_2_xcvr_mode_export                                     (2'b01),
.phy_2_i_pma_cu_clk_clk                                     (o_pma_cpu_clk),
.phy_2_i_system_pll_lock_system_pll_lock                    (sys_pll_locked),
.phy_2_i_src_rs_grant_src_rs_grant                  		(src_grant[2]),
.phy_2_o_src_rs_req_src_rs_req                              (src_req[2]),
.phy_2_tx_serial_data_o_tx_serial_data                      (pp_app_tx_serial_data[2]),  
.phy_2_tx_serial_data_n_o_tx_serial_data_n                  (pp_app_tx_serial_data_n[2]),
.phy_2_rx_serial_data_i_rx_serial_data                      (app_pp_rx_serial_data[2]),  
.phy_2_rx_serial_data_n_i_rx_serial_data_n         			(app_pp_rx_serial_data_n[2]),
.phy_2_rx_is_lockedtodata_o_rx_is_lockedtodata		    (reg_blk_lock[2]),
.phy_2_tx_pll_refclk_p_clk                                  (osc_clk),
//.phy_2_tx_pll_refclk_n_clk                                  (),
.phy_2_rx_cdr_refclk_p_clk                                  (osc_clk),
//.phy_2_rx_cdr_refclk_n_clk                                  (),
.mm_bridge_0140_017f_m0_waitrequest	(mm_bridge_0140_017f_m0_waitrequest), 
.mm_bridge_0140_017f_m0_readdata	(mm_bridge_0140_017f_m0_readdata),     
.mm_bridge_0140_017f_m0_readdatavalid	(mm_bridge_0140_017f_m0_readdatavalid),
.mm_bridge_0140_017f_m0_burstcount	(),   
.mm_bridge_0140_017f_m0_writedata	(),    
.mm_bridge_0140_017f_m0_address		(),      
.mm_bridge_0140_017f_m0_write		(mm_bridge_0140_017f_m0_write),        
.mm_bridge_0140_017f_m0_read		(mm_bridge_0140_017f_m0_read),        
.mm_bridge_0140_017f_m0_byteenable	(),   
.mm_bridge_0140_017f_m0_debugaccess	(),
.mm_bridge_0380_03ff_m0_waitrequest	(mm_bridge_0380_03ff_m0_waitrequest), 
.mm_bridge_0380_03ff_m0_readdata	(mm_bridge_0380_03ff_m0_readdata),    
.mm_bridge_0380_03ff_m0_readdatavalid	(mm_bridge_0380_03ff_m0_readdatavalid),
.mm_bridge_0380_03ff_m0_burstcount	(),   
.mm_bridge_0380_03ff_m0_writedata	(),    
.mm_bridge_0380_03ff_m0_address		(),      
.mm_bridge_0380_03ff_m0_write		(mm_bridge_0380_03ff_m0_write),        
.mm_bridge_0380_03ff_m0_read		(mm_bridge_0380_03ff_m0_read),         
.mm_bridge_0380_03ff_m0_byteenable	(),   
.mm_bridge_0380_03ff_m0_debugaccess	(),   	
.mm_bridge_01c0_01ff_m0_waitrequest	(mm_bridge_01c0_01ff_m0_waitrequest), 
.mm_bridge_01c0_01ff_m0_readdata	(mm_bridge_01c0_01ff_m0_readdata),    
.mm_bridge_01c0_01ff_m0_readdatavalid	(mm_bridge_01c0_01ff_m0_readdatavalid),
.mm_bridge_01c0_01ff_m0_burstcount	(),   
.mm_bridge_01c0_01ff_m0_writedata	(),    
.mm_bridge_01c0_01ff_m0_address		(),     
.mm_bridge_01c0_01ff_m0_write		(mm_bridge_01c0_01ff_m0_write),       
.mm_bridge_01c0_01ff_m0_read		(mm_bridge_01c0_01ff_m0_read),       
.mm_bridge_01c0_01ff_m0_byteenable	(),
.mm_bridge_01c0_01ff_m0_debugaccess	(),  
.mm_bridge_0240_027f_m0_waitrequest	(mm_bridge_0240_027f_m0_waitrequest),  
.mm_bridge_0240_027f_m0_readdata	(mm_bridge_0240_027f_m0_readdata),     
.mm_bridge_0240_027f_m0_readdatavalid	(mm_bridge_0240_027f_m0_readdatavalid),
.mm_bridge_0240_027f_m0_burstcount	(),   
.mm_bridge_0240_027f_m0_writedata	(),    
.mm_bridge_0240_027f_m0_address		(),      
.mm_bridge_0240_027f_m0_write		(mm_bridge_0240_027f_m0_write),        
.mm_bridge_0240_027f_m0_read		(mm_bridge_0240_027f_m0_read),         
.mm_bridge_0240_027f_m0_byteenable	(),  
.mm_bridge_0240_027f_m0_debugaccess	(),  
.mm_bridge_0280_02ff_m0_waitrequest	(mm_bridge_0280_02ff_m0_waitrequest),  
.mm_bridge_0280_02ff_m0_readdata	(mm_bridge_0280_02ff_m0_readdata),     
.mm_bridge_0280_02ff_m0_readdatavalid	(mm_bridge_0280_02ff_m0_readdatavalid),
.mm_bridge_0280_02ff_m0_burstcount	 (),   
.mm_bridge_0280_02ff_m0_writedata	 (),    
.mm_bridge_0280_02ff_m0_address		 (),      
.mm_bridge_0280_02ff_m0_write		 (mm_bridge_0280_02ff_m0_write),        
.mm_bridge_0280_02ff_m0_read		 (mm_bridge_0280_02ff_m0_read),         
.mm_bridge_0280_02ff_m0_byteenable	 (),  
.mm_bridge_0280_02ff_m0_debugaccess	 (),  
.mm_bridge_0400_04ff_m0_waitrequest	 (mm_bridge_0400_04ff_m0_waitrequest),
.mm_bridge_0400_04ff_m0_readdata	 (mm_bridge_0400_04ff_m0_readdata),
.mm_bridge_0400_04ff_m0_readdatavalid(mm_bridge_0400_04ff_m0_readdatavalid),
.mm_bridge_0400_04ff_m0_burstcount	 (),
.mm_bridge_0400_04ff_m0_writedata	 (),
.mm_bridge_0400_04ff_m0_address		 (),
.mm_bridge_0400_04ff_m0_write		 (mm_bridge_0400_04ff_m0_write),
.mm_bridge_0400_04ff_m0_read		 (mm_bridge_0400_04ff_m0_read),
.mm_bridge_0400_04ff_m0_byteenable	 (),
.mm_bridge_0400_04ff_m0_debugaccess	 (),
.mm_bridge_0500_05ff_m0_waitrequest	 (mdio_csr_waitrequest),
.mm_bridge_0500_05ff_m0_readdata	 (mdio_csr_readdata),
.mm_bridge_0500_05ff_m0_readdatavalid(mdio_csr_readdatavalid),
.mm_bridge_0500_05ff_m0_burstcount	 (),
.mm_bridge_0500_05ff_m0_writedata	 (mdio_csr_writedata),
.mm_bridge_0500_05ff_m0_address		 (mdio_csr_address),
.mm_bridge_0500_05ff_m0_write		 (mdio_csr_write),
.mm_bridge_0500_05ff_m0_read		 (mdio_csr_read),
.mm_bridge_0500_05ff_m0_byteenable	 (),
.mm_bridge_0500_05ff_m0_debugaccess	 (),
.mm_bridge_0600_06ff_m0_waitrequest	 (i2c_csr_waitrequest),
.mm_bridge_0600_06ff_m0_readdata	 (i2c_csr_readdata),
.mm_bridge_0600_06ff_m0_readdatavalid(i2c_csr_readdatavalid),
.mm_bridge_0600_06ff_m0_burstcount	 (),
.mm_bridge_0600_06ff_m0_writedata	 (i2c_csr_writedata),
.mm_bridge_0600_06ff_m0_address		 (i2c_csr_address),
.mm_bridge_0600_06ff_m0_write		 (i2c_csr_write),
.mm_bridge_0600_06ff_m0_read		 (i2c_csr_read),
.mm_bridge_0600_06ff_m0_byteenable	 (),  
.mm_bridge_0600_06ff_m0_debugaccess	 (),
.phy_clk_clk                         (fpga_clk_100),
.i2c_csr_readdata                    (i2c_csr_readdata     ),
.i2c_csr_writedata                   (i2c_csr_writedata    ),
.i2c_csr_address                     (i2c_csr_address      ),
.i2c_csr_write                       (i2c_csr_write        ),
.i2c_csr_read                        (i2c_csr_read         ),
.i2c_interrupt_sender_irq            (i2c_intr),
.i2c_serial_sda_in                   (i2c_sda_in),
.i2c_serial_scl_in                   (i2c_scl_in),
.i2c_serial_sda_oe                   (i2c_sda_oe),
.i2c_serial_scl_oe                   (i2c_scl_oe),
.phy_reset_reset                     (~csr_rst),
.intel_systemclk_gts_0_o_pll_lock_o_pll_lock                (sys_pll_locked),
.intel_systemclk_gts_0_refclk_xcvr_clk			    (osc_clk),
.i_refclk_rdy_data                                          (1'b1),				//Driving this to 1
.iopll_locked_export								(io_pll_locked),
.iopll_reset_reset  								(pll_reset),
//.iopll_80m_clk_clk  								(),  //clock speed 80M latency_sclk -these both connected internally
//.iopll_153m_clk_clk 								(),  //clock speed 153Mhz for DL(latency_measure_clk)
.mm_bridge_0_m0_waitrequest                                 (csr_waitrequest),
.mm_bridge_0_m0_readdata                                    (csr_readdata),
.mm_bridge_0_m0_readdatavalid                      			(csr_readdatavalid),
.mm_bridge_0_m0_burstcount                                  (csr_burstcount),
.mm_bridge_0_m0_writedata                                   (csr_writedata),
.mm_bridge_0_m0_address                                     (csr_address),
.mm_bridge_0_m0_write                                       (csr_write),
.mm_bridge_0_m0_read                               			(csr_read),
.mm_bridge_0_m0_byteenable                                  (csr_byteenable),
.mm_bridge_0_m0_debugaccess                                 (csr_debugaccess),
.phy_rst_reset                                              (phy_reset),
.avmm_reset_reset					    (avmm_rst),
.reset_reset_n                             (~system_reset)
);

//Generating mdio/i2c_csr_readdatavalid signal
always @(posedge fpga_clk_100) begin
	if(csr_rst == 1'b0) begin
		mdio_csr_readdatavalid  <= 1'b0 ;
		i2c_csr_readdatavalid  <= 1'b0 ;
		i2c_csr_readdatavalid_delay <= 1'b0 ;
	end
	else begin  
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
	sfp28_int_reg1 <= sfp28_int_reg2;
	sfp28_tx_fault_reg1 <= sfp28_tx_fault_reg2;
	sfp28_los_reg1 <= sfp28_los_reg2;
	sfp28_mod_det_reg1 <= sfp28_mod_det_reg2;
end
		

		//Reset controller
		rst_ctrl #(.NUM_PHY(NUM_PHY)) rst_ctrl_inst (
			.app_pp_h2f_reset							 (h2f_reset),
			.app_pp_system_rst_n						 (~system_reset),
			.app_pp_system_clk							 (fpga_clk_100),
			.app_pp_ninit_done							 (ninit_done),
			.app_pp_pll_locked							 (io_pll_locked),    	//Connect this to iopll_locked_export (io_pll_locked),
			.pp_app_pll_rst								 (pll_reset),		//Connect this to iopll_reset_reset
			.pp_app_csr_rst_n							 (csr_rst),
			.pp_app_avmm_rst							 (avmm_rst),
			.csr_o_rst_n								 (csr_o_rst_n),
			.sync_ack_i_rst_n							 (sync_ack_i_rst_n),
			.sync_mrphy_pll_lock_i						 (sync_mrphy_pll_lock_i),
			.sync_rx_ready_i							 (sync_rx_ready_i),
			.sync_tx_ready_i							 (sync_tx_ready_i),
			.o_rst_n									 (o_rst_n),
			.emac_mac_rst_tx_n							 (emac_mac_rst_tx_n),
			.emac_mac_rst_rx_n							 (emac_mac_rst_rx_n),
			.phy_reset                                   (phy_reset),
			.gmii8b_rst_tx_n                             (gmii8b_rst_tx_n),
			.tx_digitalreset                             (tx_digitalreset),
			.gmii8b_rst_rx_n                             (gmii8b_rst_rx_n),
			.rx_digitalreset							 (rx_digitalreset)
		); 
	
		//CSR Register space
		csr_shell #(.NUM_PHY(NUM_PHY)) usr_csr_space (
			//input
			.csr_clk		     	(fpga_clk_100),
			.reset					(avmm_rst),
			.csr_wr_data			(csr_writedata),
			.csr_read				(csr_read),			
            .csr_write				(csr_write),
            .csr_byteenable			(csr_byteenable),
            .csr_address			(csr_address),
			.csr_waitrequest		(csr_waitrequest),	
			.csr_rd_data			(csr_readdata),
			.csr_rd_vld				(csr_readdatavalid),
			.mrphy_pll_lock_i	    (reg_mrphy_pll_lock),
	    	.rx_ready_i				(reg_rx_rdy),
	    	.tx_ready_i             (reg_tx_rdy),
	    	.rx_block_lock_i        (reg_blk_lock),					//Check1 - if this connection is correct
	    	.reg_op_speed            (reg_op_speed),
	    	.ack_i_rst_n            (ack_rst_n),
            .ack_i_tx_rst_n         (ack_tx_rst_n),
            .ack_i_rx_rst_n         (ack_rx_rst_n),
            .we_dr_err_stat_i       (1'b0),							//Check1 - Temp, Driving to 0
            .phy_delay_i			(16'b0),							//Check1 - Temp, Driving to 0
			.csr_o_rst_n			(csr_o_rst_n),
			.o_tx_rst_n			(phy_tx_rst_n),
			.o_rx_rst_n			(phy_rx_rst_n),
			.sync_ack_i_rst_n		(sync_ack_i_rst_n),
			.sync_mrphy_pll_lock_i	(sync_mrphy_pll_lock_i),
			.sync_rx_ready_i		(sync_rx_ready_i),
			.sync_tx_ready_i		(sync_tx_ready_i),
			.sfp28_int_i       		(sfp28_int),
			.sfp28_tx_fault_i       (sfp28_tx_fault),
			.sfp28_los_i            (sfp28_los),
			.sfp28_mod_det_i        (sfp28_mod_det),
			.sfp28_tx_disable_o     (sfp28_tx_disable)
			
	);

		tsn_rsvd_csr  #(.DATA_WIDTH(16)) 
				csr_0140_017f
			  ( .clk					(fpga_clk_100),
				.rst					(avmm_rst),
				.write_i				(mm_bridge_0140_017f_m0_write),
				.read_i					(mm_bridge_0140_017f_m0_read),
				.waitrequest_o			(mm_bridge_0140_017f_m0_waitrequest),
				.readdata_o				(mm_bridge_0140_017f_m0_readdata),
				.readdatavalid_o		(mm_bridge_0140_017f_m0_readdatavalid)			
		);
		
		tsn_rsvd_csr csr_0380_03ff (
				.clk					(fpga_clk_100),
				.rst					(avmm_rst),
				.write_i				(mm_bridge_0380_03ff_m0_write),
				.read_i					(mm_bridge_0380_03ff_m0_read),
				.waitrequest_o			(mm_bridge_0380_03ff_m0_waitrequest),
				.readdata_o				(mm_bridge_0380_03ff_m0_readdata),
				.readdatavalid_o		(mm_bridge_0380_03ff_m0_readdatavalid)			
		);



assign c3_emac0_mdio_mdio0 = pp_app_emac0_mdio_mdoe0 ? pp_app_emac0_mdio_mdo0 : 1'bz;
assign app_pp_emac0_mdio_mdi0  = c3_emac0_mdio_mdio0;


assign src_priority = 'b0;

		assign c3_emac0_mdio_mdio = (~pp_app_emac0_mdio_mdoe) ? pp_app_emac0_mdio_mdo : 1'bz;
		assign app_pp_emac0_mdio_mdi  = c3_emac0_mdio_mdio;
		
		tsn_rsvd_csr csr_01c0_01ff (
				.clk					(fpga_clk_100),
				.rst					(avmm_rst),
				.write_i				(mm_bridge_01c0_01ff_m0_write),
				.read_i					(mm_bridge_01c0_01ff_m0_read),
				.waitrequest_o			(mm_bridge_01c0_01ff_m0_waitrequest),
				.readdata_o				(mm_bridge_01c0_01ff_m0_readdata),
				.readdatavalid_o		(mm_bridge_01c0_01ff_m0_readdatavalid)			
		);

		tsn_rsvd_csr csr_0240_027f (
				.clk					(fpga_clk_100),
				.rst					(avmm_rst),
				.write_i				(mm_bridge_0240_027f_m0_write),
				.read_i					(mm_bridge_0240_027f_m0_read),
				.waitrequest_o			(mm_bridge_0240_027f_m0_waitrequest),
				.readdata_o				(mm_bridge_0240_027f_m0_readdata),
				.readdatavalid_o		(mm_bridge_0240_027f_m0_readdatavalid)			
		);

		tsn_rsvd_csr csr_0280_02ff (
				.clk					(fpga_clk_100),
				.rst					(avmm_rst),
				.write_i				(mm_bridge_0280_02ff_m0_write),
				.read_i					(mm_bridge_0280_02ff_m0_read),
				.waitrequest_o			(mm_bridge_0280_02ff_m0_waitrequest),
				.readdata_o				(mm_bridge_0280_02ff_m0_readdata),
				.readdatavalid_o		(mm_bridge_0280_02ff_m0_readdatavalid)	
		);
		
		tsn_rsvd_csr csr_0400_04ff (
				.clk					(fpga_clk_100),
				.rst					(avmm_rst),
				.write_i				(mm_bridge_0400_04ff_m0_write),
				.read_i					(mm_bridge_0400_04ff_m0_read),
				.waitrequest_o			(mm_bridge_0400_04ff_m0_waitrequest),
				.readdata_o				(mm_bridge_0400_04ff_m0_readdata),
				.readdatavalid_o		(mm_bridge_0400_04ff_m0_readdatavalid)			
		);
		
	//ETHERNET MDIO Core IP
	altera_eth_mdio avmm2mdio (
		 .clk               (fpga_clk_100)                 //   input,   width = 1,       clock.clk
		,.reset		        (~csr_rst)                 //   input,   width = 1, clock_reset.reset
		,.csr_read          (mdio_csr_read       )    //   input,   width = 1,         csr.write
		,.csr_write         (mdio_csr_write      )    //   input,   width = 1,            .read
		,.csr_address       (mdio_csr_address    )    //   input,   width = 6,            .address
		,.csr_writedata     (mdio_csr_writedata  )    //   input,  width = 32,            .writedata
		,.csr_readdata      (mdio_csr_readdata   )    //  output,  width = 32,            .readdata
		,.csr_waitrequest	(mdio_csr_waitrequest)	  //  output,   width = 1,            .waitrequest
		,.mdc               (c3_emac0_mdio_mdc)   //  output,   width = 1,        mdio.mdc
		,.mdio_in           (app_pp_emac0_mdio_mdi)   //   input,   width = 1,            .mdio_in
		,.mdio_out          (pp_app_emac0_mdio_mdo)   //  output,   width = 1,            .mdio_out
		,.mdio_oen          (pp_app_emac0_mdio_mdoe)  //  output,   width = 1,            .mdio_oen
		
	);

// debounce fpga_reset_n
debounce fpga_reset_n_debounce_inst (
.clk                                       (system_clk_100_internal),
.reset_n                                   (~ninit_done),
.data_in                                   (fpga_reset_n),
.data_out                                  (fpga_reset_n_debounced_wire)
);
defparam fpga_reset_n_debounce_inst.WIDTH = 1;
defparam fpga_reset_n_debounce_inst.POLARITY = "LOW";
defparam fpga_reset_n_debounce_inst.TIMEOUT = 10000;               // at 100Mhz this is a debounce time of 1ms
defparam fpga_reset_n_debounce_inst.TIMEOUT_WIDTH = 32;            // ceil(log2(TIMEOUT))

always @ (posedge system_clk_100_internal or posedge ninit_done)
begin
    if (ninit_done == 1'b1)
        fpga_reset_n_debounced <= 1'b0;
    else
        fpga_reset_n_debounced <= fpga_reset_n_debounced_wire;  
end

// Debounce logic to clean out glitches within 1ms
debounce debounce_inst (
.clk                                       (system_clk_100),
.reset_n                                   (~system_reset),  
.data_in                                   (fpga_button_pio),
.data_out                                  (fpga_debounced_buttons)
);
defparam debounce_inst.WIDTH = 4;
defparam debounce_inst.POLARITY = "LOW";
defparam debounce_inst.TIMEOUT = 10000;               // at 100Mhz this is a debounce time of 1ms
defparam debounce_inst.TIMEOUT_WIDTH = 32;            // ceil(log2(TIMEOUT))

always @(posedge system_clk_100 or posedge system_reset) begin
  if (system_reset)
    heartbeat_count <= 23'd0;
  else
    heartbeat_count <= heartbeat_count + 23'd1;
end

endmodule

