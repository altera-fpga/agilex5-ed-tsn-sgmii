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


module alt_mge_phy_0_intel_adme_gts_100_m3ka7xa #(
                parameter avmm1_is_used                 = 0,
                parameter avmm1_ehip_port_count         = 1,
                parameter avmm1_pma_type                = "FGT",
                parameter avmm1_pma_modulation          = "NRZ",
                parameter avmm1_pma_datarate            = "25781.25",
                parameter avmm1_ehip_port_frac_skipping = 0,
                parameter avmm1_ehip_frac_size          = 25, 
                parameter avmm1_duplex_mode             = "duplex",
                parameter avmm1_expose_local_port       = 0,
                parameter avmm1_addr_width              = 14,
                parameter avmm1_slave_map               = "",
                parameter avmm1_has_rdv                 = 0,

		parameter avmm2_is_used                 = 0,
                parameter avmm2_pma_port_count          = 1,
                parameter avmm2_pma_type                = "FGT",
                parameter avmm2_pma_modulation          = "NRZ",
                parameter avmm2_pma_datarate            = "25781.25",
                parameter avmm2_duplex_mode             = "duplex",
                parameter avmm2_expose_local_port       = 0,
                parameter avmm2_addr_width              = 18,
                parameter avmm2_slave_map               = "",
                parameter avmm2_has_rdv                 = 0,

                parameter ip_name    = "",
                parameter DATA_WIDTH = 32
	) (

		input  wire                         avmm1_clk_user,             
		input  wire                         avmm1_reset_user,           
		input  wire [avmm1_addr_width-1:0]  avmm1_address_user,         
		input  wire [DATA_WIDTH/8-1:0]      avmm1_byte_enable_user,     
		input  wire                         avmm1_write_user,           
		input  wire                         avmm1_read_user,            
		input  wire [DATA_WIDTH-1:0]        avmm1_write_data_user,      
		output wire [DATA_WIDTH-1:0]        avmm1_read_data_user,       
		output wire                         avmm1_waitrequest_user,     
		output wire                         avmm1_read_data_valid_user, 

		output wire                         avmm1_clk_tile,             
		output wire                         avmm1_reset_tile,           
		output wire [avmm1_addr_width-1:0]  avmm1_address_tile,         
		output wire [DATA_WIDTH/8-1:0]      avmm1_byte_enable_tile,     
		output wire                         avmm1_write_tile,           
		output wire                         avmm1_read_tile,            
		output wire [DATA_WIDTH-1:0]        avmm1_write_data_tile,      
		input  wire [DATA_WIDTH-1:0]        avmm1_read_data_tile,       
		input  wire                         avmm1_waitrequest_tile,     
		input  wire                         avmm1_read_data_valid_tile,  


		input  wire                         avmm2_clk_user,             
		input  wire                         avmm2_reset_user,           
		input  wire [avmm2_addr_width-1:0]  avmm2_address_user,         
		input  wire [DATA_WIDTH/8-1:0]      avmm2_byte_enable_user,     
		input  wire                         avmm2_write_user,           
		input  wire                         avmm2_read_user,            
		input  wire [DATA_WIDTH-1:0]        avmm2_write_data_user,      
		output wire [DATA_WIDTH-1:0]        avmm2_read_data_user,       
		output wire                         avmm2_waitrequest_user,     
		output wire                         avmm2_read_data_valid_user, 

		output wire                         avmm2_clk_tile,             
		output wire                         avmm2_reset_tile,           
		output wire [avmm2_addr_width-1:0]  avmm2_address_tile,         
		output wire [DATA_WIDTH/8-1:0]      avmm2_byte_enable_tile,     
		output wire                         avmm2_write_tile,           
		output wire                         avmm2_read_tile,            
		output wire [DATA_WIDTH-1:0]        avmm2_write_data_tile,      
		input  wire [DATA_WIDTH-1:0]        avmm2_read_data_tile,       
		input  wire                         avmm2_waitrequest_tile,     
		input  wire                         avmm2_read_data_valid_tile

	);

// Pass-through's: (also fanned in to JTAG ADME)
   assign  avmm1_reset_tile = avmm1_reset_user;
   assign  avmm2_reset_tile = avmm2_reset_user;

   assign  avmm1_clk_tile = avmm1_clk_user;
   assign  avmm2_clk_tile = avmm2_clk_user;

   assign  avmm1_read_data_user = avmm1_read_data_tile;
   assign  avmm2_read_data_user = avmm2_read_data_tile;



// AVMM1:
   if (avmm1_is_used) begin: ftile_adme1

            // Raw JTAG signals
            wire [avmm1_addr_width-1:0]              jtag_address;
            wire [DATA_WIDTH/8-1:0]                  jtag_byteenable;
            wire [DATA_WIDTH-1:0]                    jtag_writedata;
            wire [DATA_WIDTH-1:0]                    jtag_readdata;
            wire                                     jtag_waitrequest;
	    wire                                     jtag_readdatavalid;

            wire                                     jtag_write;
            wire                                     jtag_read;
            wire                                     jtag_read_write;
            wire                                     user_read_write;

	    assign  jtag_read_write =       jtag_read | jtag_write;
	    assign  user_read_write = avmm1_read_user | avmm1_write_user;
	    assign  jtag_byteenable = {(DATA_WIDTH/8){1'b1}};
	    assign  jtag_readdata   = avmm1_read_data_tile;


            // When doing RTL sims, remove the altera_debug_master_endpoint, as 
            // there is no RTL simulation model.  Pre and Post Fit sims are ok.
            `ifdef ALTERA_RESERVED_QIS


              altera_debug_master_endpoint
              #(
                .ADDR_WIDTH                            ( avmm1_addr_width ),
                .DATA_WIDTH                            ( DATA_WIDTH                    ),
                .HAS_RDV                               ( avmm1_has_rdv                 ),
                .SLAVE_MAP                             ( avmm1_slave_map               ),
                .PREFER_HOST                           ( " "                           ),
                .CLOCK_RATE_CLK                        ( 0                             )
              ) adme (
                .clk                                   ( avmm1_clk_user                ),
                .reset                                 ( avmm1_reset_user              ),
                .master_write                          ( jtag_write                    ),
                .master_read                           ( jtag_read                     ),
                .master_address                        ( jtag_address                  ),
                .master_writedata                      ( jtag_writedata                ),
                .master_waitrequest                    ( jtag_waitrequest              ),
                .master_readdatavalid                  ( jtag_readdatavalid            ),  // 1'b0 before.  Why?
                .master_readdata                       ( jtag_readdata                 )
              );
            `else
               // Simulation: no ADME activity 
              assign jtag_write                         = 1'b0;
              assign jtag_read                          = 1'b0;
              assign jtag_address                       = {avmm1_addr_width{1'b0}};
                  // jtag_byteenable: always 0
              assign jtag_writedata                     = {DATA_WIDTH{1'b0}};
            `endif


	    // arbiter 
            alt_xcvr_avmm_arb #(
              .TOTAL_MASTERS (2),
              .CHANNELS ( 1 ),
              .ADDRESS_WIDTH (avmm1_addr_width),
              .DATA_WIDTH  (DATA_WIDTH)
            ) 
            avmm1_adme_arb_inst (
              .ini_clk           ( avmm1_clk_user   ),
              .ini_reset         ( avmm1_reset_user ),
                       
              .ini_read          ( {jtag_read,          avmm1_read_user            } ),
              .ini_write         ( {jtag_write,         avmm1_write_user           } ),
              .ini_address       ( {jtag_address,       avmm1_address_user         } ),
              .ini_byteenable    ( {jtag_byteenable,    avmm1_byte_enable_user     } ),
              .ini_writedata     ( {jtag_writedata,     avmm1_write_data_user      } ),
              .ini_read_write    ( {jtag_read_write,    user_read_write            } ),
              .ini_waitrequest   ( {jtag_waitrequest,   avmm1_waitrequest_user     } ),
              .ini_readdatavalid ( {jtag_readdatavalid, avmm1_read_data_valid_user } ),

              .avmm_waitrequest  ( avmm1_waitrequest_tile     ),
	      .avmm_readdatavalid( avmm1_read_data_valid_tile ),
              .avmm_read         ( avmm1_read_tile            ),
              .avmm_write        ( avmm1_write_tile           ),
              .avmm_address      ( avmm1_address_tile         ),
              .avmm_byteenable   ( avmm1_byte_enable_tile     ),
              .avmm_writedata    ( avmm1_write_data_tile      )
	    );
        end   
   else begin: no_adme1 
             assign         avmm1_address_tile = avmm1_address_user;
             assign     avmm1_byte_enable_tile = avmm1_byte_enable_user;
             assign           avmm1_write_tile = avmm1_write_user;
             assign            avmm1_read_tile = avmm1_read_user;
             assign      avmm1_write_data_tile = avmm1_write_data_user;

             assign     avmm1_waitrequest_user = avmm1_waitrequest_tile;
	     assign avmm1_read_data_valid_user = avmm1_read_data_valid_tile;
   end 



// AVMM2:
   if (avmm2_is_used) begin: ftile_adme2

            // Raw JTAG signals
            wire [avmm2_addr_width-1:0]              jtag_address;
            wire [DATA_WIDTH/8-1:0]                  jtag_byteenable;
            wire [DATA_WIDTH-1:0]                    jtag_writedata;
            wire [DATA_WIDTH-1:0]                    jtag_readdata;
            wire                                     jtag_waitrequest;
	    wire                                     jtag_readdatavalid;

            wire                                     jtag_write;
            wire                                     jtag_read;
            wire                                     jtag_read_write;
            wire                                     user_read_write;

	    assign  jtag_read_write =       jtag_read | jtag_write;
	    assign  user_read_write = avmm2_read_user | avmm2_write_user;
	    assign  jtag_byteenable = {(DATA_WIDTH/8){1'b1}};
	    assign  jtag_readdata   = avmm2_read_data_tile;

            // When doing RTL sims, remove the altera_debug_master_endpoint, as 
            // there is no RTL simulation model.  Pre and Post Fit sims are ok.
            `ifdef ALTERA_RESERVED_QIS

              altera_debug_master_endpoint
              #(
                .ADDR_WIDTH                            ( avmm2_addr_width ),
                .DATA_WIDTH                            ( DATA_WIDTH                    ),
                .HAS_RDV                               ( avmm2_has_rdv                 ),
                .SLAVE_MAP                             ( avmm2_slave_map               ),
                .PREFER_HOST                           ( " "                           ),
                .CLOCK_RATE_CLK                        ( 0                             )
              ) adme (
                .clk                                   ( avmm2_clk_user                ),
                .reset                                 ( avmm2_reset_user              ),
                .master_write                          ( jtag_write                    ),
                .master_read                           ( jtag_read                     ),
                .master_address                        ( jtag_address                  ),
                .master_writedata                      ( jtag_writedata                ),
                .master_waitrequest                    ( jtag_waitrequest              ),
                .master_readdatavalid                  ( jtag_readdatavalid            ),  // 1'b0 before.  Why?
                .master_readdata                       ( jtag_readdata                 )
              );
            `else
              assign jtag_write                         = 1'b0;
              assign jtag_read                          = 1'b0;
              assign jtag_address                       = {avmm2_addr_width{1'b0}};
              assign jtag_writedata                     = {DATA_WIDTH{1'b0}};
            `endif


	    // arbiter 
            alt_xcvr_avmm_arb #(
              .TOTAL_MASTERS (2),
              .CHANNELS ( 1 ),
              .ADDRESS_WIDTH (avmm2_addr_width),
              .DATA_WIDTH  (DATA_WIDTH)
            ) 
            avmm2_adme_arb_inst (
              .ini_clk           ( avmm2_clk_user   ),
              .ini_reset         ( avmm2_reset_user ),
                       
              .ini_read          ( {jtag_read,          avmm2_read_user            } ),
              .ini_write         ( {jtag_write,         avmm2_write_user           } ),
              .ini_address       ( {jtag_address,       avmm2_address_user         } ),
              .ini_byteenable    ( {jtag_byteenable,    avmm2_byte_enable_user     } ),
              .ini_writedata     ( {jtag_writedata,     avmm2_write_data_user      } ),
              .ini_read_write    ( {jtag_read_write,    user_read_write            } ),
              .ini_waitrequest   ( {jtag_waitrequest,   avmm2_waitrequest_user     } ),
              .ini_readdatavalid ( {jtag_readdatavalid, avmm2_read_data_valid_user } ),

              .avmm_waitrequest  ( avmm2_waitrequest_tile     ),
	      .avmm_readdatavalid( avmm2_read_data_valid_tile ),
              .avmm_read         ( avmm2_read_tile            ),
              .avmm_write        ( avmm2_write_tile           ),
              .avmm_address      ( avmm2_address_tile         ),
              .avmm_byteenable   ( avmm2_byte_enable_tile     ),
              .avmm_writedata    ( avmm2_write_data_tile      )
	    );
        end   
   else begin: no_adme2 
             assign         avmm2_address_tile = avmm2_address_user;
             assign     avmm2_byte_enable_tile = avmm2_byte_enable_user;
             assign           avmm2_write_tile = avmm2_write_user;
             assign            avmm2_read_tile = avmm2_read_user;
             assign      avmm2_write_data_tile = avmm2_write_data_user;

             assign     avmm2_waitrequest_user = avmm2_waitrequest_tile;
	     assign avmm2_read_data_valid_user = avmm2_read_data_valid_tile;
   end 

endmodule

