//Module CSR Shell
module csr_shell (
	input var logic 	mrphy_pll_lock_i,
	input var logic 	rx_ready_i,
	input var logic 	tx_ready_i,
	input var logic 	rx_block_lock_i,
	input var logic 	op_speed_i,
	input var logic	    ack_i_rst_n,
	input var logic 	ack_i_tx_rst_n,
	input var logic 	ack_i_rx_rst_n,
	input var logic 	we_dr_err_stat_i,	//Check - How to drive this signal
	input var [15:0] 	phy_delay_i, //Check - How to drive this signal
	
	input 				csr_clk,
	input 				reset, //Rename to correct reset
	input var [31:0]	csr_wr_data,
	input var logic		csr_read,
	input var logic 	csr_write,
	input var [3:0]		csr_byteenable,
	input var [4:0]		csr_address,
	
	output var [31:0]  	csr_rd_data,
	output var logic 	csr_rd_vld,
	
	output var logic 	o_rst_n,
	output var logic 	o_tx_rst_n,
	output var logic 	o_rx_rst_n
	);
	
	
	//CSR Instance
	user_csr_space csr_inst (
		.clk							(csr_clk),
		.reset							(reset),
		.writedata						(csr_wr_data),
		.read							(csr_read),
		.write							(csr_write),
		.byteenable						(csr_byteenable),
		.readdata						(csr_rd_data),
		.readdatavalid					(csr_rd_vld),
		.address						(csr_address),
		.STATUS_REG_mrphy_pll_lock_i	(mrphy_pll_lock_i),
		.STATUS_REG_rx_ready_i			(rx_ready_i),
		.STATUS_REG_tx_ready_i			(tx_ready_i),
		.STATUS_REG_rx_block_lock_i		(rx_block_lock_i),
		.STATUS_REG_op_speed_i			(op_speed_i),
		.we_RESET_CTRL_i_rst_n			(ack_i_rst_n),
		.RESET_CTRL_i_rst_n_i			(1'b1),				//Check - Clearing the reset
		.RESET_CTRL_i_rst_n				(o_rst_n),					
		.we_RESET_CTRL_i_tx_rst_n		(ack_i_tx_rst_n),
		.RESET_CTRL_i_tx_rst_n_i		(1'b1),				//Check - 
		.RESET_CTRL_i_tx_rst_n			(o_tx_rst_n),	
		.we_RESET_CTRL_i_rx_rst_n		(ack_i_rx_rst_n),
		.RESET_CTRL_i_rx_rst_n_i		(1'b1),				//Check -
		.RESET_CTRL_i_rx_rst_n			(o_rx_rst_n),
		.we_DR_STATUS_dr_error_status	(we_dr_err_stat_i),	//Check - Driving same signal				
		.DR_STATUS_dr_error_status_i	(we_dr_err_stat_i), //Check - Driving same signal
		.DR_STATUS_dr_error_status		(),					//Check - Connect this to IRQ??
		.PHY_DELAY_Any_PHY_Delay_i		(phy_delay_i)				
		);
		
		
endmodule
		
		
		
	
	
	
