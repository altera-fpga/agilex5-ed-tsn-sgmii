//Module CSR Shell
module csr_shell 
	#(parameter NUM_PHY = 1)
	(
	input  wire [NUM_PHY-1:0]		mrphy_pll_lock_i,
	input  wire [NUM_PHY-1:0]		rx_ready_i,
	input  wire [NUM_PHY-1:0]		tx_ready_i,
	input  wire [NUM_PHY-1:0]		rx_block_lock_i,
	 input  wire [NUM_PHY*3-1:0]     reg_op_speed,
	input  wire	[NUM_PHY-1:0]   	ack_i_rst_n,
	input  wire [NUM_PHY-1:0]		ack_i_tx_rst_n,
	input  wire [NUM_PHY-1:0]		ack_i_rx_rst_n,
	input  wire 		we_dr_err_stat_i,	//Check - How to drive this signal
	input  [15:0] 		phy_delay_i, //Check - How to drive this signal
	
	input 				csr_clk,
	input 				reset, 
	input  [31:0]		csr_wr_data,
	input  wire			csr_read,
	input  wire 		csr_write,
	input  [3:0]		csr_byteenable,
	input  [6:0]		csr_address,
 	output wire			csr_waitrequest,	
	output  [31:0]  	csr_rd_data,
	output  wire 		csr_rd_vld,
	
	output wire  [NUM_PHY-1:0] csr_o_rst_n,
	output wire  [NUM_PHY-1:0] o_tx_rst_n,
	output wire  [NUM_PHY-1:0] o_rx_rst_n,
	output wire  [NUM_PHY-1:0] sync_ack_i_rst_n,
	output wire  [NUM_PHY-1:0] sync_mrphy_pll_lock_i,
	output wire  [NUM_PHY-1:0] sync_rx_ready_i,
	output wire  [NUM_PHY-1:0] sync_tx_ready_i
	);
	
	
	//Unpacked -> packed as top level verilog file doesn't support 2D arrays
    wire [2:0] op_speed_i [NUM_PHY-1:0];
    generate
		genvar j;
		for (j=0; j<NUM_PHY; j=j+1)
			begin
			assign op_speed_i[j] = reg_op_speed[(3*(j+1))-1:3*j];
			end
	endgenerate
	
	


	reg waitrequest, rd_vld;
	
	wire [NUM_PHY-1:0]      sync_rx_block_lock_i, sync_ack_i_tx_rst_n, sync_ack_i_rx_rst_n;
	reg [NUM_PHY-1:0]       ack_i_rst_n_reg, ack_i_tx_rst_n_reg, ack_i_rx_rst_n_reg, mrphy_pll_lock_i_reg;


	always @(posedge csr_clk) begin		
		ack_i_rst_n_reg       <= ack_i_rst_n;
		ack_i_tx_rst_n_reg    <= ack_i_tx_rst_n;
		ack_i_rx_rst_n_reg    <= ack_i_rx_rst_n;
		mrphy_pll_lock_i_reg  <= mrphy_pll_lock_i;
	end
	
	assign csr_waitrequest = waitrequest;
	
	assign csr_rd_vld = rd_vld;

	//Generating waitrequest signal
		always @(posedge csr_clk)
			begin
				if(reset)
					waitrequest <= 1'b1;
				else if((waitrequest != 0) && (csr_write | csr_read))
					waitrequest <= 1'b0;
				else
					waitrequest <= 1'b1;
		end

	//Generating rd_vld signal
		always @(posedge csr_clk)
			begin
				 if(reset)
					rd_vld <= 1'b0;
				 else if ((rd_vld !=1) && csr_read)
					rd_vld <= 1'b1;
				 else
					rd_vld <= 1'b0;
			end
			

	generate
		genvar i;                                                     
		for(i=0; i<NUM_PHY; i=i+1)                                    
			begin
              altera_std_synchronizer_nocut  sync_mrphy_pll_lock_csr_clk (
                       .clk            (csr_clk),
                       .reset_n        (~reset),
                       .din            (mrphy_pll_lock_i_reg[i]),
                       .dout           (sync_mrphy_pll_lock_i[i])
                       );
              altera_std_synchronizer_nocut  sync_rx_ready_csr_clk (
                       .clk            (csr_clk),
                       .reset_n        (~reset),
                       .din            (rx_ready_i[i]),
                       .dout           (sync_rx_ready_i[i])
                       );
              altera_std_synchronizer_nocut  sync_tx_ready_csr_clk (
                       .clk            (csr_clk),
                       .reset_n        (~reset),
                       .din            (tx_ready_i[i]),
                       .dout           (sync_tx_ready_i[i])
                       );
              altera_std_synchronizer_nocut  sync_rx_block_lock_csr_clk (
                       .clk            (csr_clk),
                       .reset_n        (~reset),
                       .din            (rx_block_lock_i[i]),
                       .dout           (sync_rx_block_lock_i[i])
                       );
		/*
              altera_std_synchronizer_nocut  sync_op_speed_csr_clk (
					   .clk            (csr_clk),
					   .reset_n        (~reset),
					   .din            (op_speed_i[i]),
					   .dout           (sync_op_speed_i[i])
                       );*/
			  altera_std_synchronizer_nocut #(.rst_value(1)) sync_ack_i_rst_n_csr_clk	(
                        .clk            (csr_clk),
                        .reset_n        (~reset),
                        .din            (ack_i_rst_n_reg[i]),
                        .dout           (sync_ack_i_rst_n[i])
                       );
			  altera_std_synchronizer_nocut #(.rst_value(1)) sync_ack_i_tx_rst_n_csr_clk	(
                        .clk            (csr_clk),
                        .reset_n        (~reset),
                        .din            (ack_i_tx_rst_n_reg[i]),
                        .dout           (sync_ack_i_tx_rst_n[i])
        	           );	
			  altera_std_synchronizer_nocut #(.rst_value(1)) sync_ack_i_rx_rst_n_csr_clk	(
                        .clk            (csr_clk),
                        .reset_n        (~reset),
                        .din            (ack_i_rx_rst_n_reg[i]),
                        .dout           (sync_ack_i_rx_rst_n[i])
        		       );	
			end

				if(NUM_PHY == 3)
					begin
						user_csr_space_concurrent csr_inst (
						.clk										(csr_clk),
						.reset										(reset),
						.writedata									(csr_wr_data),
						.read										(csr_read),
						.write										(csr_write),
						.byteenable									(csr_byteenable),
						.readdata									(csr_rd_data),
						.readdatavalid								(),
						.address									(csr_address),
						.STATUS_REG_PHY_0_mrphy_pll_lock_i			(sync_mrphy_pll_lock_i[0]),
						.STATUS_REG_PHY_0_rx_ready_i				(sync_rx_ready_i[0]),
						.STATUS_REG_PHY_0_tx_ready_i				(sync_tx_ready_i[0]),
						.STATUS_REG_PHY_0_rx_block_lock_i			(sync_rx_block_lock_i[0]),
						.STATUS_REG_PHY_0_op_speed_i				(op_speed_i[0]),//Check once again after DR is instantiated - op_speed_i doesn't have  synchron															      //izer as it being driven by comb logic in MRPHY based on xcvr_mode signal
		                .we_RESET_CTRL_PHY_0_i_rst_n               (~sync_ack_i_rst_n[0]),
		                .RESET_CTRL_PHY_0_i_rst_n_i                (1'b1),                         //Clearing the reset
		                .RESET_CTRL_PHY_0_i_rst_n                  (csr_o_rst_n[0]),
		                .we_RESET_CTRL_PHY_0_i_tx_rst_n            (~sync_ack_i_tx_rst_n[0]),
		                .RESET_CTRL_PHY_0_i_tx_rst_n_i             (1'b1),                         //Clearing the reset 
		                .RESET_CTRL_PHY_0_i_tx_rst_n               (o_tx_rst_n[0]),
		                .we_RESET_CTRL_PHY_0_i_rx_rst_n            (~sync_ack_i_rx_rst_n[0]),
		                .RESET_CTRL_PHY_0_i_rx_rst_n_i             (1'b1),                         //Clearing the reset
		                .RESET_CTRL_PHY_0_i_rx_rst_n               (o_rx_rst_n[0]),
		                .we_DR_STATUS_dr_error_status              (we_dr_err_stat_i),     //Check - Driving same signal                           
		                .DR_STATUS_dr_error_status_i               (we_dr_err_stat_i), //Check - Driving same signal
		                .DR_STATUS_dr_error_status                 (),                                     //Check - Connect this to IRQ??
		                .DR_STATUS_dr_new_cfg_applied_i            (1'b0),             //Check - Driving to 0
		                .XCVR_MODE_xcvr_mode_phy0                  (),                 //Check - Use this to drive MRPHY??
 		                //.PHY_DELAY_Any_PHY_Delay_i                        (phy_delay_i)
 		                .STATUS_REG_PHY_1_mrphy_pll_lock_i         (sync_mrphy_pll_lock_i[1]),
 		                .STATUS_REG_PHY_1_rx_ready_i               (sync_rx_ready_i[1]),
 		                .STATUS_REG_PHY_1_tx_ready_i               (sync_tx_ready_i[1]),
 		                .STATUS_REG_PHY_1_rx_block_lock_i          (sync_rx_block_lock_i[1]),
 		                .STATUS_REG_PHY_1_op_speed_i               (op_speed_i[1]),		//op_speed_i doesn't have  synchronizer as it being driven by comb logic on xcvr_mode signal
 		                .we_RESET_CTRL_PHY_1_i_rst_n               (~sync_ack_i_rst_n[1]),
 		                .RESET_CTRL_PHY_1_i_rst_n_i                (1'b1),							 //Clearing the reset
 		                .RESET_CTRL_PHY_1_i_rst_n                  (csr_o_rst_n[1]),
 		                .we_RESET_CTRL_PHY_1_i_tx_rst_n            (~sync_ack_i_tx_rst_n[1]),
 		                .RESET_CTRL_PHY_1_i_tx_rst_n_i             (1'b1),							 //Clearing the reset
		                .RESET_CTRL_PHY_1_i_tx_rst_n               (o_tx_rst_n[1]),
		                .we_RESET_CTRL_PHY_1_i_rx_rst_n            (~sync_ack_i_rx_rst_n[1]),
		                .RESET_CTRL_PHY_1_i_rx_rst_n_i             (1'b1),							 //Clearing the reset
		                .RESET_CTRL_PHY_1_i_rx_rst_n               (o_rx_rst_n[1]),
		                .STATUS_REG_PHY_2_mrphy_pll_lock_i         (sync_mrphy_pll_lock_i[2]),
		                .STATUS_REG_PHY_2_rx_ready_i               (sync_rx_ready_i[2]),
		                .STATUS_REG_PHY_2_tx_ready_i               (sync_tx_ready_i[2]),
		                .STATUS_REG_PHY_2_rx_block_lock_i          (sync_rx_block_lock_i[2]),
		                .STATUS_REG_PHY_2_op_speed_i               (op_speed_i[2]),		//op_speed_i doesn't have  synchronizer as it being driven by comb logic on xcvr_mode signal
		                .we_RESET_CTRL_PHY_2_i_rst_n               (~sync_ack_i_rst_n[2]),
		                .RESET_CTRL_PHY_2_i_rst_n_i                (1'b1),							 //Clearing the reset
		                .RESET_CTRL_PHY_2_i_rst_n                  (csr_o_rst_n[2]),
		                .we_RESET_CTRL_PHY_2_i_tx_rst_n            (~sync_ack_i_tx_rst_n[2]),
		                .RESET_CTRL_PHY_2_i_tx_rst_n_i             (1'b1),							 //Clearing the reset
						.RESET_CTRL_PHY_2_i_tx_rst_n               (o_tx_rst_n[2]),
						.we_RESET_CTRL_PHY_2_i_rx_rst_n            (~sync_ack_i_rx_rst_n[2]),
						.RESET_CTRL_PHY_2_i_rx_rst_n_i             (1'b1),							 //Clearing the reset
						.RESET_CTRL_PHY_2_i_rx_rst_n               (o_rx_rst_n[2]),
						.XCVR_MODE_xcvr_mode_phy1                  (),
						.XCVR_MODE_xcvr_mode_phy2                  ()
					);
					end

				else
					begin
						user_csr_space_config3 csr_inst (
						 .clk										(csr_clk),
						 .reset										(reset),
						 .writedata									(csr_wr_data),
						 .read										(csr_read),
						 .write										(csr_write),
						 .byteenable								(csr_byteenable),
						 .readdata									(csr_rd_data),
						 .readdatavalid								(),
						 .address									(csr_address),
						 .STATUS_REG_mrphy_pll_lock_i				(sync_mrphy_pll_lock_i[0]),
						 .STATUS_REG_rx_ready_i						(sync_rx_ready_i[0]),
						 .STATUS_REG_tx_ready_i						(sync_tx_ready_i[0]),
						 .STATUS_REG_rx_block_lock_i				(sync_rx_block_lock_i[0]),
						 .STATUS_REG_op_speed_i						(op_speed_i[0]),
		                 .we_RESET_CTRL_i_rst_n               		(~sync_ack_i_rst_n[0]),
		                 .RESET_CTRL_i_rst_n_i                		(1'b1),                         //Clearing the reset
		                 .RESET_CTRL_i_rst_n                  		(csr_o_rst_n[0]),
		                 .we_RESET_CTRL_i_tx_rst_n            		(~sync_ack_i_tx_rst_n[0]),
		                 .RESET_CTRL_i_tx_rst_n_i             		(1'b1),                         //Clearing the reset
		                 .RESET_CTRL_i_tx_rst_n               		(o_tx_rst_n[0]),
		                 .we_RESET_CTRL_i_rx_rst_n            		(~sync_ack_i_rx_rst_n[0]),
		                 .RESET_CTRL_i_rx_rst_n_i             	    (1'b1),                         //Clearing the reset
		                 .RESET_CTRL_i_rx_rst_n               	    (o_rx_rst_n[0]),
		                 .we_DR_STATUS_dr_error_status        	    (we_dr_err_stat_i),     //Check - Driving same signal                           
		                 .DR_STATUS_dr_error_status_i         	    (we_dr_err_stat_i), //Check - Driving same signal
		                 .DR_STATUS_dr_error_status                 (),                 //Check - Connect this to IRQ??
		                 .DR_STATUS_dr_new_cfg_applied_i            (1'b0),             //Check - Driving to 0
		                 .XCVR_MODE_xcvr_mode                       ()                  //Check - Use this to drive MRPHY??
					);
					end
			endgenerate
	//CSR Instance

		
endmodule
		
		
		
	
	
	
