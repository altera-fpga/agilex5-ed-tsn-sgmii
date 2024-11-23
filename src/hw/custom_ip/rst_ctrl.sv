`timescale 1ns/1ps
module rst_ctrl
	#(parameter NUM_PHY = 1)
	(
	 input  wire 		app_pp_h2f_reset,					//HPS to Fabric, Active High
	 input  wire 		app_pp_system_rst_n,					//FPGA Reset,	 Active Low
	 input  wire 		app_pp_system_clk,					//System Clk
	                                                            
	 input  wire 		app_pp_ninit_done,					//init done - High at powerup, and goes low after init is done
	                                                         
	 input  wire 		app_pp_pll_locked,					//Active High
	                                                            
	 output reg 		pp_app_csr_rst_n,					//Active Low
	 output reg		pp_app_avmm_rst,					//Active High
	 output wire		pp_app_pll_rst,						//Active High
	 //CSR Reset signals
	 input wire [NUM_PHY-1:0] 	csr_o_rst_n,
	 input wire [NUM_PHY-1:0] 	sync_ack_i_rst_n,
	 input wire [NUM_PHY-1:0] 	sync_mrphy_pll_lock_i,
	 input wire [NUM_PHY-1:0] 	sync_rx_ready_i,
	 input wire [NUM_PHY-1:0] 	sync_tx_ready_i,
	 //MAC Resets from HPS
	 input wire [NUM_PHY-1:0] 	emac_mac_rst_tx_n,
	 input wire [NUM_PHY-1:0] 	emac_mac_rst_rx_n,
	 //Reset to PHY	
	 output reg [NUM_PHY-1:0]	o_rst_n,
	 output reg [NUM_PHY-1:0]	phy_reset,
	 output reg [NUM_PHY-1:0]	gmii8b_rst_tx_n,
	 output reg [NUM_PHY-1:0]	tx_digitalreset,
	 output reg [NUM_PHY-1:0]	gmii8b_rst_rx_n,
	 output reg [NUM_PHY-1:0]	rx_digitalreset
	 );
	 
	 wire 					sysclk_h2f_reset_n;
	 wire					sysclk_system_rst_n;
	 // wire 					sysclk_pwron_rdy;
	 // wire 					sysclk_ninit_done;
	 wire					sysclk_pll_locked;
	 wire 					h2f_reset_n;
	 // wire 					pwron_rdy;
	 // reg					phy_rst_n;
	 
	 //Negating these as synhronizers need -ve reset
	 assign h2f_reset_n = ~app_pp_h2f_reset;		//Input h2f reset is Active High
	 //assign init_done = ~app_pp_ninit_done
	 
	 //Reset Synchronizer for h2f_reset - System Clk
	 altera_std_synchronizer_nocut  syncr_h2f_reset_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(h2f_reset_n),
		.din 		(1'b1),
		.dout		(sysclk_h2f_reset_n)
		);
		
	 //Reset Synchronizer for system_rst_n - System Clk
	 altera_std_synchronizer_nocut  syncr_system_reset_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(app_pp_system_rst_n),
		.din 	 	(1'b1),
		.dout		(sysclk_system_rst_n)
		);	
	 /* 
	 //Reset Synchronizer for app_pp_ninit_done - System Clk
	 altera_std_synchronizer_nocut  syncr_init_done_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(app_pp_ninit_done),
		.din 	 	(1'b1),
		.dout		(sysclk_ninit_done)
		);	 
	 */
	 //Synchronizer for app_pp_pll_locked - System Clk
	 altera_std_synchronizer_nocut  syncr_pll_lock_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(1'b1),
		.din 	 	(app_pp_pll_locked),
		.dout		(sysclk_pll_locked)
		);	
	

    wire [NUM_PHY-1:0] sync_emac_mac_rst_tx_n, sync_emac_mac_rst_rx_n;

    generate
    genvar j;
    for(j=0; j<NUM_PHY; j =j+1)
    begin
		
	 //Reset Synchronizer for emac_mac_rst_tx_n - System Clk
	 altera_std_synchronizer_nocut  syncr_mac_tx_rst_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(emac_mac_rst_tx_n[j]),
		.din 	 	(1'b1),
		.dout		(sync_emac_mac_rst_tx_n[j])
		);
	
	 //Rest Synchronizer for emac_mac_rst_rx_n - System Clk
	 altera_std_synchronizer_nocut  syncr_mac_rx_rst_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(emac_mac_rst_rx_n[j]),
		.din 	 	(1'b1),
		.dout		(sync_emac_mac_rst_rx_n[j])
		);	
     end
     endgenerate

	//Used to reset IOPLL in tsn_subsystem
	assign pp_app_pll_rst = ~sysclk_h2f_reset_n | ~sysclk_system_rst_n | app_pp_ninit_done; 

	/*
	always @(posedge app_pp_system_clk) begin
	
		if(~sysclk_pll_locked)
			begin
				pp_app_csr_rst_n <= 1'b0;
				pp_app_avmm_rst <= 1'b1;
			end
		
		else 
			begin
				pp_app_csr_rst_n <= 1'b1;
				pp_app_avmm_rst <= 1'b0;
			end
		
	end
	*/
	reg [8:0] count;
	always @(posedge app_pp_system_clk) 
	begin
		if(~sysclk_pll_locked)
		begin
				pp_app_csr_rst_n <= 1'b0;
				pp_app_avmm_rst <= 1'b1;
				count <= 9'b0;
		end
		else
		begin
			if(~count[8]) begin
				pp_app_csr_rst_n <= 1'b0;
				pp_app_avmm_rst <= 1'b1;
				count <= count + 1'b1;
			end
			else begin
				pp_app_csr_rst_n <= 1'b1;
				pp_app_avmm_rst <= 1'b0;
				count <= count;
			end

		end
	end
	
	//assign pp_app_avmm_rst = ~o_rst_n;
	//assign pp_app_csr_rst_n = o_rst_n;


    generate
    genvar i;
    for(i=0; i<NUM_PHY; i =i+1)
    begin
	//Generating reset for HIP of PHY
	always @(posedge app_pp_system_clk)
	begin	
		if(~sysclk_pll_locked)
			o_rst_n[i] <= 1'b0;
		else if(~o_rst_n[i] & csr_o_rst_n[i] & sync_ack_i_rst_n[i])	//reset is asserted and no ack yet
			o_rst_n[i] <= 1'b0;
		else if(~o_rst_n[i] & csr_o_rst_n[i] & ~sync_ack_i_rst_n[i])	//reset is asserted by and ack is received
			o_rst_n[i] <= 1'b1;
		else
			o_rst_n[i] <= csr_o_rst_n[i];			        //Else, reset is driven by the csr bit
	end
	
	//Generating reset for SIP of PHY, phy_reset is reset on MRPHY
	always @(posedge app_pp_system_clk)
	begin
		if(~o_rst_n[i])
			phy_reset[i] <= 1'b1;
//		else if(phy_reset[i] &  (sync_mrphy_pll_lock_i[i] & sync_rx_ready_i[i] & sync_tx_ready_i[i]))
		else if(phy_reset[i] &  (sync_mrphy_pll_lock_i[i] & sync_tx_ready_i[i]))       //removing rx_ready dependancy
			phy_reset[i] <= 1'b0;
		else
			phy_reset[i] <= phy_reset[i];
	end
	
	//Generating gmii8b digitalreset tx reset signals
	always @(posedge app_pp_system_clk)
	begin
		if(~sync_emac_mac_rst_tx_n[i])				//Check - Might have to add o_rst_n
			begin
				gmii8b_rst_tx_n[i] <= 1'b0;
				tx_digitalreset[i] <= 1'b1;
			end
		else if (~gmii8b_rst_tx_n[i] & sync_tx_ready_i[i] & sync_mrphy_pll_lock_i[i])
			begin
				gmii8b_rst_tx_n[i] <= 1'b1;
				tx_digitalreset[i] <= 1'b0;			
			end
		else 
			begin
				gmii8b_rst_tx_n[i] <= gmii8b_rst_tx_n[i];
				tx_digitalreset[i] <= tx_digitalreset[i];
			end
	end

	//Generating gmii8b digitalreset rx reset signals
	always @(posedge app_pp_system_clk)
	begin
		if(~sync_emac_mac_rst_rx_n[i])
			begin
				gmii8b_rst_rx_n[i] <= 1'b0;
				rx_digitalreset[i] <= 1'b1;
			end
		else if (~gmii8b_rst_rx_n[i] & sync_rx_ready_i[i] & sync_mrphy_pll_lock_i[i])
			begin
				gmii8b_rst_rx_n[i] <= 1'b1;
				rx_digitalreset[i] <= 1'b0;			
			end
		else 
			begin
				gmii8b_rst_rx_n[i] <= gmii8b_rst_rx_n[i];
				rx_digitalreset[i] <= rx_digitalreset[i];
			end	
	end
     end
     endgenerate
	
endmodule	
