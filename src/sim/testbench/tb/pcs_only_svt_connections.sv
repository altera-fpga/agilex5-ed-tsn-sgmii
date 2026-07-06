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



`ifdef EHIP_50GX2
parameter int   AM_INS_CYC = 2;
parameter int     AM_INS_CNT = 510;
parameter int     NUM_WORDS = 2;
`else
parameter int     AM_INS_CYC = 5;
 `ifdef RSFEC
parameter int     AM_INS_CNT = 1275;
 `else 
parameter int     AM_INS_CNT = 315;
 `endif
parameter int     NUM_WORDS = 4;
`endif

bit         pcs66_txdata_valid_hack;
//  wire        i_n_aib_hr_clk[0];
logic                pcs66_tx_vld;
logic                pcs66_tx_rdy;
logic                pcs66_tx_am_insert;
logic[263:0]         pcs66_tx_data;
logic                pcs66_avst_tx_am_insert; 
logic                o_avst_am_insert;
logic[263:0] pcs66_data_x4;
logic        pcs66_data_x4_valid;
logic [5:0] avst_latency;
logic                pcs66_rx_vld;
logic                pcs66_rx_am;
logic[263:0]         pcs66_rx_data;
logic [263:0] o_avst_data;
logic o_avst_valid;
logic [263:0] otn_am_insert_dout;
logic otn_am_insert_dout_vld;
logic otn_am;

//---------------------------------------------------------------------------
// Clocking blocks for internal signals that we use to drive/sample without
// having a UVC for them
//---------------------------------------------------------------------------
`ifndef EHIP_PCS_ONLY 
assign svt_tx_if_pcs66_100G.reset = (~dut.top.o_tx_lanes_stable | ~reset_if_100G.csr_rst_n | ~reset_if_100G.tx_rst_n | ~reset_if_100G.rx_rst_n );
`endif   
clocking pcs66_drv_cb @ (posedge o_clk_pll_div64);
   // Revisit, 2015.09, Elab Issue // default input #1step output #(client_tx_uif.clock_period * 0.8);
   //pcs66data, vld, insert_am
   //output   dsk_marker;
   inout pcs66_tx_am_insert;
   inout pcs66_tx_data;
   inout pcs66_tx_vld;
   inout pcs66_avst_tx_am_insert;
endclocking : pcs66_drv_cb

clocking pcs66_mon_cb @ (posedge o_clk_pll_div64);
   // Revisit, 2015.09, Elab Issue // default input #1step output #(client_tx_uif.clock_period * 0.8);
   //rdy
   input pcs66_tx_rdy;
endclocking : pcs66_mon_cb

//      assign pcs66_tx_rdy = <dut o_tx_ready> //supal

task drive_pcs66_am_insert();
   bit[31:0] tx_rdy_count;
   bit [31:0] am_insert_count;
   forever begin

      //if (~uif.mst_cb.hip_ready ) begin  // cora - hold off on am_insert until tx deskew is done
      //if (~h2a_ch0_hip_aib_fsr_out[0] ) begin  // cora - hold off on am_insert until tx deskew is done
      if (~dut.o_ehip_ready) begin  // cora - hold off on am_insert until tx deskew is done
         tx_rdy_count= 0;
         pcs66_drv_cb.pcs66_tx_am_insert <= 0;
      end
      else if(pcs66_mon_cb.pcs66_tx_rdy == 1) begin
         tx_rdy_count++;
      end

      //if(tx_rdy_count == m_config.am_interval) begin //am_insert logic
      if(tx_rdy_count == AM_INS_CNT) begin //am_insert logic

         am_insert_count = 0;
         pcs66_drv_cb.pcs66_tx_am_insert <= 1;
         //am_insert_in_progress = 1;

         //while(am_insert_count < am_insert_cycles) begin
         while(am_insert_count < AM_INS_CYC) begin
            if(pcs66_mon_cb.pcs66_tx_rdy == 1) begin
               am_insert_count++;
               @(pcs66_mon_cb);
               `uvm_info("drive_pcs66_am_insert", $sformatf("insert_am asserted AT TIME :%t, am_insert_count %d ", $time, am_insert_count), UVM_FULL)
		 end
            else if(pcs66_mon_cb.pcs66_tx_rdy == 0) begin
               @(pcs66_mon_cb);
               `uvm_info("drive_pcs66_am_insert", $sformatf("insert_am: held AT TIME :%t, as rdy:%d is low, am_insert_count :%d", $time, pcs66_mon_cb.pcs66_tx_rdy, am_insert_count), UVM_FULL)
		 end
         end //while

         //Check whether shadow_vld is 0 If 0, then valid_count must hold its previous value until shadow_vld is 1
         if(pcs66_mon_cb.pcs66_tx_rdy !== 1) begin
            while(pcs66_mon_cb.pcs66_tx_rdy !== 1) begin
               @(pcs66_mon_cb);
            end
            `uvm_info("drive_pcs66_am_insert", $sformatf("tx_rdy_count:%d held AT TIME :%t, as rdy:%d is low, am_insert_count :%d", tx_rdy_count, $time, pcs66_mon_cb.pcs66_tx_rdy, am_insert_count), UVM_FULL)
              end

         pcs66_drv_cb.pcs66_tx_am_insert <= 0;
         //`uvm_info(m_config.m_msg_id, $sformatf("drive_data reset insert_am AT TIME :%t, am_insert_count :%d", $time, am_insert_count), UVM_FULL)
         am_insert_count = 0;
         tx_rdy_count = 0;
         //am_insert_in_progress = 0;
         //`uvm_info(m_config.m_msg_id, $sformatf("drive_data reset insert_am AT TIME :%t, reset am_insert_count :%d, reset valid_count :%d", $time, am_insert_count, valid_count), UVM_FULL)
         //`uvm_info(m_config.m_msg_id, $sformatf("drive_data reset insert_am AT TIME :%t, reset am_insert_count :%d, reset valid_count :%d, am_insert_in_progress:%d", $time, am_insert_count, valid_count, am_insert_in_progress), UVM_FULL)

      end
      @(pcs66_mon_cb);
   end

endtask:drive_pcs66_am_insert

initial begin
   drive_pcs66_am_insert();
end  
   
`ifndef EHIP_PCS_ONLY 
   flex_e_1to4_gearbox #(
			 .AWIDTH (11),       // depth of Rate-Match FIFO is 2^ADWIDTH -- test case is restricted to the inevitable overflow of this FIFO due to AM insertions
			 .DWIDTH (66)        // 66b PCS data width
			 )
   u_flex_e_1to4_gearbox_tx (
			     // bfm
			     //.i_clk_a           (clk.pcs64_66_clk ),
			     .i_clk_a           (xgmii66_clk),
			     .i_rst_a_n         (dut.o_rx_pcs_ready), //supal : need to see this async reset for the 1562Mhz domain
			     .i_bfm_data        (svt_tx_if_pcs66_100G.tx_lane[65:0] ),
			     //.i_bfm_dvalid      (1'b1 ),
			     .i_bfm_dvalid      (pcs66_txdata_valid_hack),   // Disable data while BFM outputs Zs
			     // dut
			     .i_clk_b           (o_clk_pll_div64),
			     // .i_clk_b           (clk.pcs64_66_clk),
			     .i_rst_b_n         (dut.o_ehip_ready),
			     .i_pop             (pcs66_mon_cb.pcs66_tx_rdy && ~pcs66_drv_cb.pcs66_tx_am_insert ),  // stall for alignment marker insertion
			     .o_data            (pcs66_data_x4),
			     .o_data_available  (pcs66_data_x4_valid),
			     .o_err_underflow   ( ),
			     .o_err_overflow    ( )   //
			     );

   flex_e_4to1_gearbox  #(
			  .AWIDTH (6),    // depth of Rate-Match FIFO is 2^AWIDTH
			  .DWIDTH (66)    // 66b PCS data width
			  )
   u_flex_e_4to1_gearbox_rx (
			     // dut
			     .i_clk_a         (o_clk_pll_div64 ),
			     //   .i_clk_a         (clk.pcs64_66_clk),
			     .i_rst_a_n       (dut.o_rx_pcs_ready),
			     .i_data          (pcs66_rx_data) ,
			     .i_dvalid        (pcs66_rx_vld && ~pcs66_rx_am  ),  // drop AM cycles -  BFM cannot process AMs
			     // bfm
			     .i_clk_b         (xgmii66_clk),
			     .i_rst_b_n       ( dut.o_ehip_ready),
			     .o_bfm_data      (svt_tx_if_pcs66_100G.rx_lane[65:0]),
			     .o_bfm_dvalid    (xgmii66_rx_valid  ),
			     .o_err_overflow  ( )
			     );

   //supal : following signals connected with dut
   // pcs66_rx_data
   // pcs66_rx_vld
   // pcs66_rx_am

   assign avst_latency = $urandom_range(1,25);
   logic p2h_ch0_pld_pcs_tx_clk_out_x1;
   assign #0.1 p2h_ch0_pld_pcs_tx_clk_out_x1 = o_clk_pll_div64;
   flex_e_avst_tx_if # (
			.DWIDTH (264)   // dut data width
			)
   u_flex_e_avst_tx_if (
			.i_clk            (p2h_ch0_pld_pcs_tx_clk_out_x1),
			.i_rst_n          (dut.o_ehip_ready),
			.i_avst_latency   (avst_latency),
			.i_avst_ready     (pcs66_mon_cb.pcs66_tx_rdy),
			//.i_avst_ready     (pcs66_tx_rdy),
			.i_data_available (pcs66_data_x4_valid ),
			.i_data_null      ({4{56'h0, 8'h1E, 2'b01}} ),       // send IDLEs when BFM data unavailable -- should only be necessary at start-up
			.i_data           (pcs66_data_x4),
			.i_am_insert      (pcs66_drv_cb.pcs66_tx_am_insert ),
			// dut
			.o_am_insert      (o_avst_am_insert),  // to DUT
			.o_avst_data      (o_avst_data),  // to DUT
			.o_avst_valid     (o_avst_valid)   // to DUT
			//.o_avst_data      (o_avst_data),  // to DUT
			//.o_avst_valid     (o_avst_valid)   // to DUT
			);

   cr2ev0_c2_ehip_tx_tagger_5way #(
				   .VLANE_SET          (0)
				   )
   u_otn_am_tagger_0 (
		      .i_clk              (o_clk_pll_div64),
		      .i_cfg              ({24'h90_7467, 24'hF0_c4E6, 24'hC5_65AB, 24'hA2_793D, 20'h0, 4'd0,1'b1,5'd0}),
		      .i_cfg_half_width   (1'b0),
		      .i_cfg_skip_tags    (1'b0),
		      .i_cfg_err_inj      ('0),
		      .i_rst_n            (reset_if_100G.csr_rst_n),
		      .i_mode_100g        (1'b1),
		      .i_valid            (o_avst_valid ),
		      .i_din              (o_avst_data[(66*(0+1)-1): 66*0]),
		      .i_am_insert        (o_avst_am_insert),
		      .o_dout_am          (otn_am),
		      .o_dout_vld         (otn_am_insert_dout_vld),
		      .o_dout             (otn_am_insert_dout[(66*(0+1)-1): (66*0)])
		      );


   cr2ev0_c2_ehip_tx_tagger_5way #(
				   .VLANE_SET          (1)
				   )
   u_otn_am_tagger_1 (
		      .i_clk              (o_clk_pll_div64),
		      .i_cfg              ({24'h90_7467, 24'hF0_c4E6, 24'hC5_65AB, 24'hA2_793D, 20'h0, 4'd0,1'b1,5'd0}),
		      .i_cfg_half_width   (1'b0),
		      .i_cfg_skip_tags    (1'b0),
		      .i_cfg_err_inj      ('0),
		      .i_rst_n            (reset_if_100G.csr_rst_n),
		      .i_mode_100g        (1'b1),
		      .i_valid            (o_avst_valid ),
		      .i_din              (o_avst_data[(66*(1+1)-1): 66*1]),
		      .i_am_insert        (o_avst_am_insert),
		      .o_dout_am          (), //1 bit
		      //.o_dout_vld         (otn_am_insert_dout_vld),
		      .o_dout_vld         (), //only 1 bit for tx_vld
		      .o_dout             (otn_am_insert_dout[(66*(1+1)-1): (66*1)])
		      );

   cr2ev0_c2_ehip_tx_tagger_5way #(
				   .VLANE_SET          (2)
				   )
   u_otn_am_tagger_2 (
		      .i_clk              (o_clk_pll_div64),
		      .i_cfg              ({24'h90_7467, 24'hF0_c4E6, 24'hC5_65AB, 24'hA2_793D, 20'h0, 4'd0,1'b1,5'd0}),
		      .i_cfg_half_width   (1'b0),
		      .i_cfg_skip_tags    (1'b0),
		      .i_cfg_err_inj      ('0),
		      .i_rst_n            (reset_if_100G.csr_rst_n),
		      .i_mode_100g        (1'b1),
		      .i_valid            (o_avst_valid ),
		      .i_din              (o_avst_data[(66*(2+1)-1): 66*2]),
		      .i_am_insert        (o_avst_am_insert),
		      .o_dout_am          (),
		      //.o_dout_vld         (otn_am_insert_dout_vld),
		      .o_dout_vld         (), //only 1 bit for tx_vld
		      .o_dout             (otn_am_insert_dout[(66*(2+1)-1): (66*2)])
		      );

   cr2ev0_c2_ehip_tx_tagger_5way #(
				   .VLANE_SET          (3)
				   )
   u_otn_am_tagger_3 (
		      .i_clk              (o_clk_pll_div64),
		      .i_cfg              ({24'h90_7467, 24'hF0_c4E6, 24'hC5_65AB, 24'hA2_793D, 20'h0, 4'd0,1'b1,5'd0}),
		      .i_cfg_half_width   (1'b0),
		      .i_cfg_skip_tags    (1'b0),
		      .i_cfg_err_inj      ('0),
		      .i_rst_n            (reset_if_100G.csr_rst_n),
		      .i_mode_100g        (1'b1),
		      .i_valid            (o_avst_valid ),
		      .i_din              (o_avst_data[(66*(3+1)-1): 66*3]),
		      .i_am_insert        (o_avst_am_insert),
		      .o_dout_am          (),
		      //.o_dout_vld         (otn_am_insert_dout_vld),
		      .o_dout_vld         (), //only 1 bit for tx_vld
		      .o_dout             (otn_am_insert_dout[(66*(3+1)-1): (66*3)])
		      );

   //supal : following signals will be connected to DUT
   // pcs66_avst_tx_am_insert
   // pcs66_tx_data
   // pcs66_tx_vld
   initial begin
 `ifdef FLEXE_MODE
      assign pcs66_tx_data = o_avst_data;
      assign pcs66_tx_vld = o_avst_valid;
      assign pcs66_avst_tx_am_insert = o_avst_am_insert;
 `endif
 `ifdef OTN_MODE
      //else if( (m_bfm.ehip_mode == ehip_core_bcm_config::EHIP_OTN_NO_FEC) || (m_bfm.ehip_mode == ehip_core_bcm_config::EHIP_OTN) ) begin
      assign pcs66_tx_data = otn_am_insert_dout;
      assign pcs66_tx_vld = otn_am_insert_dout_vld;
      assign pcs66_avst_tx_am_insert = otn_am; 
 `endif
   end

   //Bit 66 of rx_lane VIP expects the DUT to assert this as soon as the DUT starts transmission of valid 66 Bit data
   assign svt_tx_if_pcs66_100G.rx_lane[66] = pcs66_txdata_valid_hack;
`endif
   initial begin
      pcs66_txdata_valid_hack = 1'b0;
      wait (dut.o_rx_pcs_ready);
      #1000ns;
      pcs66_txdata_valid_hack = 1'b1;
   end
