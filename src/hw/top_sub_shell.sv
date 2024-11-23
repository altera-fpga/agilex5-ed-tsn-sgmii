module ghrd_agilex5_top
#(parameter NUM_PHY = 3,
  parameter DR_ENABLE = 0
  )
	(
	 input wire		 	app_pp_osc_clk,
	 input wire	 		fpga_clk_100,
	 
	 //Reset
	 input    wire  	fpga_reset_n,

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
	 
	 //MDIO Interface
	 input wire 			app_pp_emac0_mdio_mdi,		
	 output wire 			pp_app_emac0_mdio_mdo,
	 output wire			pp_app_emac0_mdio_mdoe,
	 output wire 			pp_app_emac0_mdio_mdc,
	 
	 //I2C Interface
	 output wire			pp_app_i2c_scl_oe,
	 output wire			pp_app_i2c_sda_oe,
	 input	wire			app_pp_i2c_sda_in,
	 input	wire			app_pp_i2c_scl_in,
	 output	wire			pp_app_i2c_intr,
	 
	 
	 //MRPHY TX, RX
	 output wire 	[NUM_PHY-1:0]  pp_app_tx_serial_data,
	 output wire 	[NUM_PHY-1:0]  pp_app_tx_serial_data_n,
	 input wire 	[NUM_PHY-1:0]  app_pp_rx_serial_data,
	 input wire 	[NUM_PHY-1:0]  app_pp_rx_serial_data_n	  
	
	);
	 
	 
endmodule


module tsn_custom_logic	
	#(parameter NUM_PHY =3,
	  parameter DR_ENABLE=0
	  )
	(	
		input wire	 		fpga_clk_100,
		input wire  		fpga_reset_n,
		input wire 			h2f_reset,
		input wire			init_done,
		input wire			io_pll_locked,
		output wire			phy_reset,
		
		//CSR Interface
		input  [31:0]			csr_wr_data,
		input   wire			csr_read,
		input   wire 			csr_write,
		input   wire 	[3:0]	csr_byteenable,
		input   wire	[4:0]	csr_address,
		output  wire 	[31:0]  csr_rd_data,
		output  wire 			csr_rd_vld,
		
		//User CSR space
		input  wire [NUM_PHY-1:0]		mrphy_pll_lock_i,
		input  wire [NUM_PHY-1:0]		rx_ready_i,
		input  wire [NUM_PHY-1:0]		tx_ready_i,
		input  wire [NUM_PHY-1:0]		rx_block_lock_i,
		input  wire [NUM_PHY-1:0] [2:0]	op_speed_i,
		input  wire	[NUM_PHY-1:0]   	ack_i_rst_n,
		input  wire [NUM_PHY-1:0]		ack_i_tx_rst_n,
		input  wire [NUM_PHY-1:0]		ack_i_rx_rst_n,
		input  wire 					we_dr_err_stat_i,				//Check - How to drive this signal
		input  wire [15:0] 				phy_delay_i, 					//Check - How to drive this signal
		output  wire [NUM_PHY-1:0]		o_rst_n,
		output  wire [NUM_PHY-1:0]		o_tx_rst_n,
		output  wire [NUM_PHY-1:0]		o_rx_rst_n
		
	);
	
endmodule




Error: add_connection subsys_debug.hps_m_master ext_hps_m_master.windowed_slave: No interface named subsys_debug.hps_m_master.
Error: set_connection_parameter_value subsys_debug.hps_m_master/ext_hps_m_master.windowed_slave baseAddress 0x0: No interface named subsys_debug.hps_m_master.

Error: add_connection clk_100.out_clk subsys_hps.f2sdram_clk: No interface named subsys_hps.f2sdram_clk.		
Error: add_connection rst_in.out_reset subsys_hps.f2sdram_rst: No interface named subsys_hps.f2sdram_rst.					f2sdram_width
Error: add_connection clk_100.out_clk subsys_hps.hps2fpga_clk: No interface named subsys_hps.hps2fpga_clk.					h2f_width
Error: add_connection rst_in.out_reset subsys_hps.hps2fpga_rst: No interface named subsys_hps.hps2fpga_rst.
Error: set_interface_property usb31_io EXPORT_OF subsys_hps.usb31_io: No interface named subsys_hps.usb31_io.
Error: set_interface_property hps_io EXPORT_OF subsys_hps.hps_io: No interface named subsys_hps.hps_io.
Error: set_interface_property usb31_phy_pma_cpu_clk EXPORT_OF subsys_hps.usb31_phy_pma_cpu_clk
Error: set_interface_property usb31_phy_refclk_p EXPORT_OF subsys_hps.usb31_phy_refclk_p
Error: set_interface_property usb31_phy_refclk_n EXPORT_OF subsys_hps.usb31_phy_refclk_n
Error: set_interface_property usb31_phy_rx_serial_n EXPORT_OF subsys_hps.usb31_phy_rx_serial_n
Error: set_interface_property usb31_phy_rx_serial_n EXPORT_OF subsys_hps.usb31_phy_rx_serial_n
