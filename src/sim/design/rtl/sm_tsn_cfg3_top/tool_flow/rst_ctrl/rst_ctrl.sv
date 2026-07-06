`timescale 1ns/1ps
module rst_ctrl
	(
	 input var logic 		app_pp_h2f_reset,					//HPS to Fabric, Active High
	 input var logic 		app_pp_system_rst_n,				//FPGA Reset,	 Active Low
	 input var logic 		app_pp_system_clk,					//System Clk
	 input var logic 		app_pp_csr_clk,						//Not used - same as system_clk
	 
	 input var logic 		app_pp_ninit_done,					//init done - Active Low
	 
	 input var logic 		app_pp_pll_locked,					//Active High
	 
     output var logic 		pp_app_phy_rst_n,					//Active Low
	 output var logic 		pp_app_csr_rst_n					//Active Low
	 );
	 
	 logic 					sysclk_h2f_reset_n;
	 logic					sysclk_system_rst_n;
	 logic 					sysclk_pwron_rdy;
	 logic 					sysclk_ninit_done;
	 logic					sysclk_pll_locked;
	 wire 					h2f_reset_n;
	 
	 assign h2f_reset_n = ~app_pp_h2f_reset;		//Input h2f reset is Active High
	 
	 
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
	 //Synchronizer for h2f_reset - CSR Clk
	 altera_std_synchronizer_nocut  syncr_h2f_reset_csr_clk (
		.clk		(app_pp_csr_clk),
		 reset_n	(app_pp_h2f_reset),
		.din 	 	(1'b1),
		.dout		(csrclk_h2f_reset)
		);
		
	 //Synchronizer for system_rst_n - CSR Clk
	 altera_std_synchronizer_nocut  syncr_system_reset_csr_clk (
		.clk		(app_pp_csr_clk),
		 reset_n	(app_pp_system_rst_n),
		.din 	 	(1'b1),
		.dout		(csrclk_system_rst_n)
		);
	*/
	 //Reset Synchronizer for app_pp_ninit_done - System Clk
	 altera_std_synchronizer_nocut  syncr_init_done_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(app_pp_ninit_done),
		.din 	 	(1'b1),
		.dout		(sysclk_ninit_done)
		);	 

	 //Synchronizer for app_pp_pll_locked - System Clk
	 altera_std_synchronizer_nocut  syncr_pll_lock_sys_clk (
		.clk		(app_pp_system_clk),
		.reset_n	(1'b1),
		.din 	 	(app_pp_pll_locked),
		.dout		(sysclk_pll_locked)
		);	
		
	
	assign sysclk_pwron_rdy = ~sysclk_ninit_done & sysclk_pll_locked;
	//assign csrclk_pwron_rdy = ~csrclk_ninit_done & ~csrclk_pll_locked;
	
	always @(posedge app_pp_system_clk) begin
	
		if(~sysclk_pwron_rdy)
			begin
				pp_app_phy_rst_n <= 1'b0;
				pp_app_csr_rst_n <= 1'b0;
			end
		
		else 
			begin
				pp_app_phy_rst_n <= (sysclk_h2f_reset_n | sysclk_system_rst_n);
				pp_app_csr_rst_n <= (sysclk_h2f_reset_n | sysclk_system_rst_n);
			end
		
	end
		
		
endmodule	
