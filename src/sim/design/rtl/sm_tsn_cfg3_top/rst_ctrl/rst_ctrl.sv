`timescale 1ns/1ps
module rst_ctrl
	(
	 input var logic 		app_pp_h2f_reset,
	 input var logic 		app_pp_system_rst_n,
	 input var logic 		app_pp_system_clk,
	 input var logic 		app_pp_csr_clk,
	 
	 input var logic 		app_pp_ninit_done,
	 
	 input var logic 		app_pp_pll_locked,
	 
     output var logic 		pp_app_phy_rst_n,
	 output var logic 		pp_app_csr_rst_n
	 );
	 
	 logic 					sysclk_h2f_reset;
	 logic					sysclk_system_rst_n;
	 logic					csrclk_h2f_reset;
	 logic                  csrclk_system_rst_n;
	 logic 					sysclk_pwron_rdy, csrclk_pwron_rdy;
	 logic 					csrclk_ninit_done;
	 logic					csrclk_pll_locked;
	 
	 
	 
	 //Synchronizer for h2f_reset - System Clk
	 ipbb_asyn_to_syn_rst  syncr_h2f_reset_sys_clk (
		.clk		(app_pp_system_clk),
		.asyn_rst 	(app_pp_h2f_reset),
		.syn_rst	(sysclk_h2f_reset)
		);
		
	 //Synchronizer for system_rst_n - System Clk
	 ipbb_asyn_to_syn_rst  syncr_system_reset_sys_clk (
		.clk		(app_pp_system_clk),
		.asyn_rst 	(app_pp_system_rst_n),
		.syn_rst	(sysclk_system_rst_n)
		);	 
	 
	 //Synchronizer for h2f_reset - CSR Clk
	 ipbb_asyn_to_syn_rst  syncr_h2f_reset_csr_clk (
		.clk		(app_pp_csr_clk),
		.asyn_rst 	(app_pp_h2f_reset),
		.syn_rst	(csrclk_h2f_reset)
		);
		
	 //Synchronizer for system_rst_n - CSR Clk
	 ipbb_asyn_to_syn_rst  syncr_system_reset_csr_clk (
		.clk		(app_pp_csr_clk),
		.asyn_rst 	(app_pp_system_rst_n),
		.syn_rst	(csrclk_system_rst_n)
		);

	 //Synchronizer for app_pp_ninit_done - CSR Clk
	 ipbb_asyn_to_syn_rst  syncr_init_done_csr_clk (
		.clk		(app_pp_csr_clk),
		.asyn_rst 	(app_pp_ninit_done),
		.syn_rst	(csrclk_ninit_done)
		);	 

	 //Synchronizer for app_pp_pll_locked - CSR Clk
	 ipbb_asyn_to_syn_rst  syncr_pll_lock_csr_clk (
		.clk		(app_pp_csr_clk),
		.asyn_rst 	(app_pp_pll_locked),
		.syn_rst	(csrclk_pll_locked)
		);	
		
	
	assign sysclk_pwron_rdy = ~app_pp_ninit_done & ~app_pp_pll_locked;
	assign csrclk_pwron_rdy = ~csrclk_ninit_done & ~csrclk_pll_locked;
	
	always @(posedge app_pp_system_clk) begin
	
		if(~sysclk_pwron_rdy)
				pp_app_phy_rst_n <= 1'b1;
		
		else 
				pp_app_phy_rst_n <= (sysclk_h2f_reset | sysclk_system_rst_n);
		
	end
	
	
	always @(posedge app_pp_csr_clk) begin
	
		if(~csrclk_pwron_rdy)
				pp_app_csr_rst_n <= 1'b1;
		
		else 
				pp_app_csr_rst_n <= (csrclk_h2f_reset | csrclk_system_rst_n);
		
	end		
	
		
		
endmodule	
