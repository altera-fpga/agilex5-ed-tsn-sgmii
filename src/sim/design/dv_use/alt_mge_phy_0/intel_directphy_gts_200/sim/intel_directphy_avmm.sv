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

`timescale 1 ps/1 ps 
module intel_directphy_avmm #(
    parameter          num_sys_cop                                              = 1,
    parameter   [3:0]  num_xcvr_per_sys                                         = 1,
    parameter          l_num_aib_per_xcvr                                       = 1,
    parameter   [4:0]  l_sys_aibs                                               = 1,
    parameter          l_tx_enable                                              = 1,
    parameter          l_rx_enable                                              = 1,
    parameter          fec_enable                                               = 1'b0,
    parameter          l_soft_csr_enable                                        = 0,
    parameter [11:0]   l_line_rate_p1ghz                                        = 12'd250,
    parameter          xcvr_type                                                = 1'b0,
    parameter          modulation_type                                          = 1'b0,
    parameter          avmm1_split                                              = 0,
    parameter          avmm1_readdv_enable                                      = 0,
    parameter          l_av1_enable                                             = 0,
    parameter          l_av1_aib_enable                                         = 0,
    parameter          l_num_avmm1                                              = 1,
    parameter          l_av1_ifaces                                             = 1,
    parameter          l_av1_addr_bits                                          = 14,
    parameter          DATA_WIDTH                                               = 32
    ) (  

  input   [l_av1_ifaces-1:0]                  reconfig_pdp_clk,         //   reconfig_pdp_clk.clk
  input   [l_av1_ifaces-1:0]                  reconfig_pdp_reset,       // reconfig_pdp_reset.reset
  input   [l_av1_ifaces-1:0]                  reconfig_pdp_write,       //  reconfig_pdp_avmm.write
  input   [l_av1_ifaces-1:0]                  reconfig_pdp_read,        //                   .read
  input   [l_av1_addr_bits*l_av1_ifaces-1:0]  reconfig_pdp_address,     //                   .address
  input   [l_av1_ifaces*DATA_WIDTH/8-1:0]     reconfig_pdp_byteenable,  //                   .byteenable
  input   [l_av1_ifaces*DATA_WIDTH-1:0]       reconfig_pdp_writedata,   //                   .writedata
  output  [l_av1_ifaces*DATA_WIDTH-1:0]       reconfig_pdp_readdata,    //                   .readdata
  output  [l_av1_ifaces-1:0]                  reconfig_pdp_waitrequest, //                   .waitrequest
  output  [l_av1_ifaces-1:0]                  reconfig_pdp_readdatavalid, //                 .readdatavalid

  ////  for AVMM1 bb ports
    
  output        [l_num_avmm1-1:0]         pldif_o_lavmm_clk,//1*LANES
  output        [l_num_avmm1-1:0]         pldif_o_lavmm_rstn,//1*LANES
  output        [(20)*l_num_avmm1-1:0]      pldif_o_lavmm_addr, // Actually it is only 12bits from reconfig interface 
  output        [4*l_num_avmm1-1:0]       pldif_o_lavmm_be,
  output        [l_num_avmm1-1:0]         pldif_o_lavmm_read,//1*LANES
  output        [32*l_num_avmm1-1:0]      pldif_o_lavmm_wdata,//32*LANES
  output        [l_num_avmm1-1:0]         pldif_o_lavmm_write,//1*LANES
  input         [32*l_num_avmm1-1:0]      pldif_i_lavmm_rdata,//32*LANES
  input         [l_num_avmm1-1:0]         pldif_i_lavmm_rdata_valid,//1*LANES
  input         [l_num_avmm1-1:0]         pldif_i_lavmm_waitreq,//1*LANES

  // ctrl and status signals
  output   [num_xcvr_per_sys*num_sys_cop-1:0]    tx_clear_alarm,
  output   [num_xcvr_per_sys*num_sys_cop-1:0]    rx_clear_alarm,
  input    [num_xcvr_per_sys*num_sys_cop-1:0]    tx_alarm,                       
  input    [num_xcvr_per_sys*num_sys_cop-1:0]    rx_alarm,
  output   [num_sys_cop-1:0]                     dphy_reset_soft_tx_rst,
  output   [num_sys_cop-1:0]                     dphy_reset_soft_rx_rst,
  output   [num_sys_cop-1:0]                     dphy_reset_tx_rst_ovr,
  output   [num_sys_cop-1:0]                     dphy_reset_rx_rst_ovr,
  input    [num_sys_cop-1:0]                     dphy_reset_status_tx_rst_ack_n_i,
  input    [num_sys_cop-1:0]                     dphy_reset_status_rx_rst_ack_n_i,
  input    [num_sys_cop-1:0]                     dphy_reset_status_tx_ready_i,
  input    [num_sys_cop-1:0]                     dphy_reset_status_rx_ready_i,
  input    [num_sys_cop*num_xcvr_per_sys-1:0]    phy_tx_pll_locked_tx_pll_locked_i,
  input    [num_sys_cop*num_xcvr_per_sys-1:0]    phy_rx_cdr_locked_rx_cdr_locked_i,
  input    [num_sys_cop*num_xcvr_per_sys-1:0]    phy_rx_cdr_locked_rx_cdr_locked2data_i,
  output   [num_sys_cop-1:0]                     src_ctrl_rx_ignore_locked2data

);




  //\TODO  TEMPORARILY COPIED FUNCTION UNTIL TILE_IP HANDLES PACKAGES PROPERLY
    localparam integer MAX_CHARS_ALT_XCVR_NATIVE_S10 = 86; // To accomodate LONG parameter lists.
    localparam EN_32_8_BRIDGE = 0; // To accomodate LONG parameter lists.
  ////////////////////////////////////////////////////////////////////
  // Convert an integer to a string
  function [MAX_CHARS_ALT_XCVR_NATIVE_S10*8-1:0] int2str_alt_xcvr_native_s10(
    input integer in_int
  );
    integer i;
    integer this_char;
    i = 0;
    int2str_alt_xcvr_native_s10 = "";
    do
    begin
      this_char = (in_int % 10) + 48;
      int2str_alt_xcvr_native_s10[i*8+:8] = this_char[7:0];
      i=i+1;
      in_int = in_int / 10; 
    end
    while(in_int > 0);
  endfunction

 
localparam  ifs_psys    = (!avmm1_split)? 1 : (l_av1_aib_enable)? num_xcvr_per_sys*l_num_aib_per_xcvr : (fec_enable)? 1 : num_xcvr_per_sys ;
localparam  aib_pif     = (!avmm1_split)? num_xcvr_per_sys*l_num_aib_per_xcvr: (l_av1_aib_enable)? 1 :
                          (fec_enable)? num_xcvr_per_sys*l_num_aib_per_xcvr : l_num_aib_per_xcvr ;
localparam  ch_sel_bits = ((l_av1_addr_bits-18)==0) ? 1 : (l_av1_addr_bits-18);

//`ifdef ch_sel_bits > 0
	wire [ch_sel_bits-1:0]             ch_sel;
//`else
//	wire [0:0]             ch_sel;
//`endif
// to calculate number of enabled and disabled aibs per system
localparam  num_aib_ena_pif = (l_av1_aib_enable)? aib_pif : 1;
localparam  num_aib_dis_pif = aib_pif - num_aib_ena_pif;
localparam  BE_WIDTH    = DATA_WIDTH/8;
localparam  [15:0] aib_used_flag = (l_av1_aib_enable)? 16'hffff : (fec_enable)? 16'h0001 : (l_num_aib_per_xcvr==4)? 16'h1111 : (l_num_aib_per_xcvr==2)? 16'h5555 : 16'hffff;
localparam  [2:0] duplex_mode = (l_tx_enable)? ( l_rx_enable? 3'b011: 3'b010) : (l_rx_enable? 3'b001 : 3'b000);


wire    [DATA_WIDTH-1:0]      m32_mux_readdata    [l_av1_ifaces-1:0];
wire    [l_av1_ifaces-1:0]    m32_mux_waitrequest;
wire    [l_av1_ifaces-1:0]    m32_mux_readdatavalid;

logic   [num_sys_cop-1:0]     soft_csr_select;
logic   [num_sys_cop-1:0]     soft_csr_select_reg;
wire    [DATA_WIDTH-1:0]      soft_csr_readdata    [num_sys_cop-1:0];
wire    [num_sys_cop-1:0]     soft_csr_readdatavalid;
wire    [num_sys_cop-1:0]     soft_csr_waitrequest;

logic   [l_av1_ifaces-1:0]    m32_hip_select;

wire    [l_av1_ifaces-1:0]    m32_read;
wire    [l_av1_ifaces-1:0]    m32_write;
wire    [DATA_WIDTH-1:0]      m32_writedata   [l_av1_ifaces-1:0];
wire    [DATA_WIDTH-1:0]      m32_readdata    [l_av1_ifaces-1:0];
wire    [l_av1_ifaces-1:0]    m32_waitrequest;
wire    [l_av1_ifaces-1:0]    m32_readdatavalid;
wire    [l_av1_addr_bits-1:0] m32_address     [l_av1_ifaces-1:0];
wire    [l_av1_addr_bits+2:0] m32_address_exp [l_av1_ifaces-1:0];  // add bit [16, 1:0] for physical(expanded) addr
wire    [3:0]                 m32_byteenable  [l_av1_ifaces-1:0];

//logic   [num_xcvr_per_sys*num_sys_cop-1:0]    tx_clear_alarm_d;
//logic   [num_xcvr_per_sys*num_sys_cop-1:0]    rx_clear_alarm_d;
logic   [num_xcvr_per_sys*num_sys_cop-1:0]    tx_clear_alarm_csr;
logic   [num_xcvr_per_sys*num_sys_cop-1:0]    rx_clear_alarm_csr;


genvar ig, ifs_idx, aib_idx,i_xcvr;
generate
  if (l_av1_enable) begin:av1_ena
    	for(ig=0;ig<num_sys_cop;ig=ig+1) begin: av1_sys 
      		for (ifs_idx=0; ifs_idx<ifs_psys; ifs_idx=ifs_idx+1) begin: av1_ifs
			localparam  av1_idx     = (ig*ifs_psys+ifs_idx)*aib_pif;
			localparam  av1_dis_idx = av1_idx + num_aib_ena_pif;
			localparam  sys_ifs_idx = ig*ifs_psys + ifs_idx;
			// per xcvr read/write signals for soft csr and avmm port
			wire [aib_pif-1:0] ch_write, ch_read, ch_waitrequest;
			wire [aib_pif-1:0] [7:0] ch_readdata;

			assign reconfig_pdp_readdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH] = m32_mux_readdata[sys_ifs_idx];

        	assign reconfig_pdp_waitrequest[sys_ifs_idx]  = m32_mux_waitrequest[sys_ifs_idx];
			assign reconfig_pdp_readdatavalid[sys_ifs_idx]= m32_mux_readdatavalid[sys_ifs_idx];
        	assign m32_read[sys_ifs_idx]         = reconfig_pdp_read[sys_ifs_idx];
        	assign m32_write[sys_ifs_idx]        = reconfig_pdp_write[sys_ifs_idx];
        	assign m32_address[sys_ifs_idx]      = reconfig_pdp_address[sys_ifs_idx*l_av1_addr_bits+:l_av1_addr_bits];
        	assign m32_byteenable[sys_ifs_idx]   = reconfig_pdp_byteenable[sys_ifs_idx*BE_WIDTH+:BE_WIDTH];
        	assign m32_writedata[sys_ifs_idx]    = reconfig_pdp_writedata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH];


       		// soft csr, only the 1st interface in a system has the soft CSR
			if (l_soft_csr_enable && (ifs_idx==0)) begin : w_scsr  
                        if(avmm1_split) begin
                            assign m32_mux_waitrequest[sys_ifs_idx]   = (soft_csr_select[ig])? soft_csr_waitrequest[ig] : pldif_i_lavmm_waitreq[sys_ifs_idx];//m32_waitrequest[sys_ifs_idx];
                            assign m32_mux_readdatavalid[sys_ifs_idx] = ((avmm1_readdv_enable)? soft_csr_select_reg[ig] : soft_csr_select[ig])? soft_csr_readdatavalid[ig] : pldif_i_lavmm_rdata_valid[sys_ifs_idx];//m32_readdatavalid[sys_ifs_idx];
                            assign m32_mux_readdata[sys_ifs_idx]      = ((avmm1_readdv_enable)? soft_csr_select_reg[ig] : soft_csr_select[ig])? soft_csr_readdata[ig] : pldif_i_lavmm_rdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH];//m32_readdata[sys_ifs_idx];
                        end else begin
                                assign m32_mux_waitrequest[sys_ifs_idx]   = (soft_csr_select[ig])? soft_csr_waitrequest[ig] : pldif_i_lavmm_waitreq[ch_sel];//m32_waitrequest[sys_ifs_idx];
                                assign m32_mux_readdatavalid[sys_ifs_idx] = ((avmm1_readdv_enable)? soft_csr_select_reg[ig] : soft_csr_select[ig])? soft_csr_readdatavalid[ig] : pldif_i_lavmm_rdata_valid[ch_sel];//m32_readdatavalid[sys_ifs_idx];
                                assign m32_mux_readdata[sys_ifs_idx]      = ((avmm1_readdv_enable)? soft_csr_select_reg[ig] : soft_csr_select[ig])? soft_csr_readdata[ig] : pldif_i_lavmm_rdata[ch_sel*DATA_WIDTH+:DATA_WIDTH];//m32_readdata[sys_ifs_idx];
                        end
                        
                        always_comb begin
                            soft_csr_select[ig]     = 1'b0;
                            m32_hip_select[sys_ifs_idx]  = 1'b0;
                            case (m32_address_exp[sys_ifs_idx][16:0]) inside 
                                [17'h00400:17'h007ff] : m32_hip_select[sys_ifs_idx]  = 1'b1;
                                [17'h00800:17'h00fff] : soft_csr_select[ig] = 1'b1;
                            default: m32_hip_select[sys_ifs_idx]  = 1'b1;
                            endcase;
                        end
            
                        always_ff @(posedge reconfig_pdp_clk[sys_ifs_idx]) begin
                            soft_csr_select_reg[ig] <= soft_csr_select[ig];
                        end
//            
//                        always_ff @(posedge reconfig_pdp_clk[sys_ifs_idx]) begin
//                                tx_clear_alarm_d[ig] <= tx_alarm[ig];
//                        rx_clear_alarm_d[ig] <= rx_alarm[ig];
//                        end
//            
//                    
                        assign tx_clear_alarm[ig] = tx_clear_alarm_csr[ig];
                        assign rx_clear_alarm[ig] = rx_clear_alarm_csr[ig];
            
            
                        intel_directphy_csr_wrap # (
                        .enable_readdv              (avmm1_readdv_enable),
                        .line_rate_p1ghz            (l_line_rate_p1ghz),
                        .xcvr_type                  (xcvr_type),
                        .modulation_type            (modulation_type),
                        .num_xcvr                   (num_xcvr_per_sys),
                        .num_aib                    (l_num_aib_per_xcvr*num_xcvr_per_sys),
                        .fec_enable                 (fec_enable),
                        .duplex_mode                (duplex_mode)  
                        ) intel_directphy_csr_wrap_inst (
                        .src_ctrl_tx_clear_alarm                            (tx_clear_alarm_csr  [ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .src_ctrl_rx_clear_alarm                            (rx_clear_alarm_csr  [ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .src_alarms_tx_alarm_i                              (tx_alarm        [ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .src_alarms_rx_alarm_i                              (rx_alarm        [ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .dphy_reset_soft_tx_rst                             (dphy_reset_soft_tx_rst[ig]),
                        .dphy_reset_soft_rx_rst                             (dphy_reset_soft_rx_rst[ig]),
                        .dphy_reset_tx_rst_ovr                              (dphy_reset_tx_rst_ovr[ig]),
                        .dphy_reset_rx_rst_ovr                              (dphy_reset_rx_rst_ovr[ig]),
                        .dphy_reset_status_tx_rst_ack_n_i                   (dphy_reset_status_tx_rst_ack_n_i[ig]),
                        .dphy_reset_status_rx_rst_ack_n_i                   (dphy_reset_status_rx_rst_ack_n_i[ig]),
                        .dphy_reset_status_tx_ready_i                       (dphy_reset_status_tx_ready_i[ig]),
                        .dphy_reset_status_rx_ready_i                       (dphy_reset_status_rx_ready_i[ig]),
                        .phy_tx_pll_locked_tx_pll_locked_i                  (phy_tx_pll_locked_tx_pll_locked_i[ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .phy_rx_cdr_locked_rx_cdr_locked_i                  (phy_rx_cdr_locked_rx_cdr_locked_i[ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .phy_rx_cdr_locked_rx_cdr_locked2data_i             (phy_rx_cdr_locked_rx_cdr_locked2data_i[ig*num_xcvr_per_sys+:num_xcvr_per_sys]),
                        .src_ctrl_rx_ignore_locked2data                     (src_ctrl_rx_ignore_locked2data[ig]),
                        .clk                                                (reconfig_pdp_clk[sys_ifs_idx]),
                        .reset                                              (reconfig_pdp_reset[sys_ifs_idx]),
                        .writedata                                          (m32_writedata[sys_ifs_idx]),
                        .read                                               (m32_read[sys_ifs_idx] & soft_csr_select[ig]),
                        .write                                              (m32_write[sys_ifs_idx] & soft_csr_select[ig]),
                        .byteenable                                         (m32_byteenable[sys_ifs_idx]),
                        .readdata                                           (soft_csr_readdata[ig]),
                        .readdatavalid                                      (soft_csr_readdatavalid[ig]),
                        .waitrequest                                        (soft_csr_waitrequest[ig]),
                        .address                                            ({m32_address[sys_ifs_idx][2:0], 2'b00})  
            
                            );
	    // TODO : coonect ports, parameter, and data/valid, waitrequest
	    // back to main I/F
            end   else begin : no_scsr
                    assign m32_hip_select[sys_ifs_idx] = 1'b1;
                    //assign m32_mux_waitrequest[sys_ifs_idx]   =  pldif_i_lavmm_waitreq[sys_ifs_idx];//m32_waitrequest[sys_ifs_idx];
                    //assign m32_mux_readdatavalid[sys_ifs_idx] =  pldif_i_lavmm_rdata_valid[sys_ifs_idx];//m32_readdatavalid[sys_ifs_idx];
                    //assign m32_mux_readdata[sys_ifs_idx]      =  pldif_i_lavmm_rdata[sys_ifs_idx];//m32_readdata[sys_ifs_idx];
		    if(avmm1_split) begin
                    	assign m32_mux_waitrequest[sys_ifs_idx]   = pldif_i_lavmm_waitreq[sys_ifs_idx];//m32_waitrequest[sys_ifs_idx];
                        assign m32_mux_readdatavalid[sys_ifs_idx] = pldif_i_lavmm_rdata_valid[sys_ifs_idx];//m32_readdatavalid[sys_ifs_idx];
                        assign m32_mux_readdata[sys_ifs_idx]      = pldif_i_lavmm_rdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH];//m32_readdata[sys_ifs_idx];
                    end else begin
                        assign m32_mux_waitrequest[sys_ifs_idx]   = pldif_i_lavmm_waitreq[ch_sel];//m32_waitrequest[sys_ifs_idx];
                        assign m32_mux_readdatavalid[sys_ifs_idx] = pldif_i_lavmm_rdata_valid[ch_sel];//m32_readdatavalid[sys_ifs_idx];
                        assign m32_mux_readdata[sys_ifs_idx]      = pldif_i_lavmm_rdata[ch_sel*DATA_WIDTH+:DATA_WIDTH];//m32_readdata[sys_ifs_idx];
		    end
	    end

	    assign m32_address_exp[sys_ifs_idx] = {1'b0,m32_address[sys_ifs_idx], 2'b00};
//	`ifdef ch_sel_bits > 0
		assign ch_sel  = ((l_av1_addr_bits-18)==0) ? 0 : m32_address_exp[sys_ifs_idx][l_av1_addr_bits+2-1-:ch_sel_bits];
//	`else
//		assign ch_sel  = 0;
//	`endif

	if(avmm1_split) begin
			assign pldif_o_lavmm_clk[sys_ifs_idx]						= reconfig_pdp_clk[sys_ifs_idx] ;
			assign pldif_o_lavmm_rstn[sys_ifs_idx]						= ~reconfig_pdp_reset[sys_ifs_idx] ;

			assign pldif_o_lavmm_addr[sys_ifs_idx*(20)+:20]		= m32_address_exp[sys_ifs_idx][(20)-1:0];
			assign pldif_o_lavmm_be[sys_ifs_idx*BE_WIDTH+:BE_WIDTH]				= m32_byteenable[sys_ifs_idx];
			assign pldif_o_lavmm_read[sys_ifs_idx]						= m32_read[sys_ifs_idx] & m32_hip_select[sys_ifs_idx];
			assign pldif_o_lavmm_wdata[sys_ifs_idx*DATA_WIDTH+:DATA_WIDTH]			= m32_writedata[sys_ifs_idx];
			assign pldif_o_lavmm_write[sys_ifs_idx]						= m32_write[sys_ifs_idx] & m32_hip_select[sys_ifs_idx];	
	end else begin
				for(i_xcvr=0;i_xcvr<num_xcvr_per_sys;i_xcvr=i_xcvr+1) begin: num_xcvr
					//assign ch_sel  = m32_address_exp[sys_ifs_idx][l_av1_addr_bits+2-1-:ch_sel_bits];
					
					assign pldif_o_lavmm_clk[(i_xcvr+ig)]						= reconfig_pdp_clk[0];
					assign pldif_o_lavmm_rstn[(i_xcvr+ig)]						= ~reconfig_pdp_reset[0];

					assign pldif_o_lavmm_addr[(i_xcvr+ig)*(20)+:(20)]		= m32_address_exp[sys_ifs_idx][(20)-1:0];
					assign pldif_o_lavmm_be[(i_xcvr+ig)*BE_WIDTH+:BE_WIDTH]				= m32_byteenable[sys_ifs_idx];
					assign pldif_o_lavmm_read[(i_xcvr+ig)]						= m32_read[sys_ifs_idx] & m32_hip_select[sys_ifs_idx] & (ch_sel == i_xcvr);
					assign pldif_o_lavmm_wdata[(i_xcvr+ig)*DATA_WIDTH+:DATA_WIDTH]			= m32_writedata[sys_ifs_idx];
					assign pldif_o_lavmm_write[(i_xcvr+ig)]						= m32_write[sys_ifs_idx] & m32_hip_select[sys_ifs_idx] & (ch_sel == i_xcvr);

				end
	end

      end  // av1_ifs
    end   // av1_sys
  end   // av1_ena
  else begin:av1_dis
      assign  reconfig_pdp_readdata        = 'h0;
      assign  reconfig_pdp_waitrequest     = 'h0;
      assign  reconfig_pdp_readdatavalid   = 'h0;
      assign  pld_avmm1_clk_rowclk         = 'h0;
      assign  pld_avmm1_read               = 'h0;
      assign  pld_avmm1_reg_addr           = 'h0;
      assign  pld_avmm1_request            = 'h0;
      assign  pld_avmm1_reserved_in        = 'h0;
      assign  pld_avmm1_write              = 'h0;
      assign  pld_avmm1_writedata          = 'h0; 
  end                                      
                                           
    if (!l_av1_enable || !l_soft_csr_enable ) begin: g_nocsr
        assign  dphy_reset_soft_tx_rst = 'h0; 
        assign  dphy_reset_soft_rx_rst = 'h0; 
        assign  dphy_reset_tx_rst_ovr  = 'h0; 
        assign  dphy_reset_rx_rst_ovr  = 'h0; 

        assign  src_ctrl_rx_ignore_locked2data = 'h0; 
        
        assign tx_clear_alarm          = 'h0;
        assign rx_clear_alarm          = 'h0;
        
        
    end

endgenerate

    
 

endmodule

