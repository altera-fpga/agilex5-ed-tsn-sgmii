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


module eth_f_ptp_sva
#(
    parameter APUL_MEAS         = 0,
    parameter PL                = 1,
    parameter WORDS             = 1,
    parameter PKT_CYL           = 1,
    parameter XCVR_TYPE         = 0,
    parameter PTP_FP_WIDTH      = 8,
    parameter DEBUG             = 0
) (
    // Configuration [quasi-static]
    input  logic                [2:0] i_cfg_speed,
    input  logic                [2:0] i_cfg_rsfec,
    input  logic                [4:0] i_cfg_pl,
    input  logic                      i_cfg_tx_pp,
    // Clock and Reset
    input  logic                      i_ptp_clk,          // sys/2
    input  logic                      i_ptp_sample_clk,   // 250MHz or 114.28 MHz (TBD)
    input  logic                      i_tx_tod_clk,
    input  logic                      i_rx_tod_clk,
    input  logic                      i_tx_srst_n,
    input  logic                      i_rx_srst_n,
    input  logic                      i_tx_tod_srst_n,
    input  logic                      i_rx_tod_srst_n,
    input  logic                      i_tx_samp_srst_n,
    input  logic                      i_rx_samp_srst_n,
    // CSR: calculation data to user [ptp_clk, sample_clk]
    input  logic                      o_tx_apulse_wdly_valid,   // sample_clk
    input  logic                      o_tx_apulse_offset_valid, // sample_clk
    input  logic                      o_tx_apulse_time_valid,   // ptp_clk
    input  logic                      o_rx_apulse_wdly_valid,   // sample_clk
    input  logic                      o_rx_apulse_offset_valid, // sample_clk
    input  logic                      o_rx_apulse_time_valid,   // ptp_clk
    input  logic [PL-1:0][19:0]       o_tx_apulse_wdly,         // sample_clk
    input  logic [PL-1:0][31:0]       o_tx_apulse_offset,       // sample_clk
    input  logic [PL-1:0][27:0]       o_tx_apulse_time,         // ptp_clk
    input  logic [PL-1:0][19:0]       o_rx_apulse_wdly,         // sample_clk
    input  logic [PL-1:0][31:0]       o_rx_apulse_offset,       // sample_clk
    input  logic [PL-1:0][27:0]       o_rx_apulse_time,         // ptp_clk
    input  logic               [31:0] o_tx_const_adjust,        // combi
    input  logic               [31:0] o_rx_const_adjust,        // combi
    // CSR: Reference lane [tod_clk]
    input  logic                [2:0] i_tx_ref_lane,
    input  logic                [2:0] i_rx_lal,
    // CSR: TAM adjust [ptp_clk]
    input  logic               [31:0] i_tx_calc_adjust,
    input  logic               [31:0] i_rx_calc_adjust,
    // CSR & EHIP Interface: 50G/100G nonFEC only - RX virtual lane offset user cfg done [ptp_clk]
    input  logic                      o_rx_ptp_vl_snapshot,       // (shared interface) request HIP to snapshot raw data, at the same time notify user via CSR that HIP has snapshot
    // CSR: FEC only - RX FEC codeword position user cfg done [ptp_clk]
    input  logic                      i_rx_fec_cw_pos_user_cfg_done,
    // CSR: User Configuration done [ptp_clk]
    input  logic                      i_tx_ptp_user_cfg_done,
    input  logic                      i_rx_ptp_user_cfg_done,
    input  logic                      o_tx_ptp_user_cfg_done_clrn,
    input  logic                      o_rx_ptp_user_cfg_done_clrn,
    // CSR: UI measurement [ptp_clk]
    input  logic                      o_tx_tam_valid,
    input  logic               [15:0] o_tx_tam_cnt,  
    input  logic               [47:0] o_tx_tam_ui,   
    input  logic                      o_rx_tam_valid,
    input  logic               [15:0] o_rx_tam_cnt,  
    input  logic               [47:0] o_rx_tam_ui,
    // User Interface: TX Framing Interface [ptp_clk]
    input  logic                      i_tx_pkt_valid,
    input  logic [WORDS-1:0]          i_tx_pkt_inframe,
    input  logic [WORDS-1:0][63:0]    i_tx_pkt_data,
    input  logic [WORDS-1:0][2:0]     i_tx_pkt_empty,
    input  logic [WORDS-1:0]          i_tx_pkt_error,
    input  logic [WORDS-1:0]          i_tx_pkt_skip_crc,
    // EHIP Interface: TX Framing Interface [ptp_clk]
    input  logic                      o_tx_pkt_valid,
    input  logic [WORDS-1:0]          o_tx_pkt_inframe,
    input  logic [WORDS-1:0][63:0]    o_tx_pkt_data,
    input  logic [WORDS-1:0][2:0]     o_tx_pkt_empty,
    input  logic [WORDS-1:0]          o_tx_pkt_error,
    input  logic [WORDS-1:0]          o_tx_pkt_skip_crc,
    // EHIP Interface: RX Framing Interface [ptp_clk]
    input  logic                      i_rx_pkt_valid,
    input  logic [WORDS-1:0]          i_rx_pkt_inframe,
    input  logic [WORDS-1:0][63:0]    i_rx_pkt_data,
    input  logic [WORDS-1:0][2:0]     i_rx_pkt_empty,
    input  logic [WORDS-1:0][1:0]     i_rx_pkt_error,
    input  logic [WORDS-1:0]          i_rx_pkt_fcs_error,
    input  logic [WORDS-1:0][2:0]     i_rx_pkt_status,
    // User Interface: RX Framing Interface [ptp_clk]
    input  logic                      o_rx_pkt_valid,
    input  logic [WORDS-1:0]          o_rx_pkt_inframe,
    input  logic [WORDS-1:0][63:0]    o_rx_pkt_data,
    input  logic [WORDS-1:0][2:0]     o_rx_pkt_empty,
    input  logic [WORDS-1:0][1:0]     o_rx_pkt_error,
    input  logic [WORDS-1:0]          o_rx_pkt_fcs_error,
    input  logic [WORDS-1:0][2:0]     o_rx_pkt_status,
    // User Interface: TOD Interface [ptp_clk, tod_clk]
    input  logic                      i_tx_ptp_tod_valid,
    input  logic               [95:0] i_tx_ptp_tod,
    input  logic                      i_rx_ptp_tod_valid,
    input  logic               [95:0] i_rx_ptp_tod,
    // User Interface: TX 1-step Command [ptp_clk]
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ins_ets,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ins_cf,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ins_cs,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ins_eb,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ets_format,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ins_asm,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ins_p2p,
    input  logic [PKT_CYL-1:0]        i_tx_ptp_asm_sign,
    input  logic [PKT_CYL-1:0][6:0]   i_tx_ptp_asm_p2p_idx,
    input  logic [PKT_CYL-1:0][15:0]  i_tx_ptp_offset_ts,
    input  logic [PKT_CYL-1:0][15:0]  i_tx_ptp_offset_cf,
    input  logic [PKT_CYL-1:0][15:0]  i_tx_ptp_offset_cs,
    input  logic [PKT_CYL-1:0][95:0]  i_tx_ptp_rt_its,
    // User Interface: TX 2-step Timestamp Request [ptp_clk]
    input  logic [PKT_CYL-1:0]        i_tx_ptp_req_ets,
    input  logic [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]   i_tx_ptp_req_fp,
    // EHIP Interface: TX 1-step and 2-step Command [ptp_clk]
    input  logic [WORDS-1:0][2:0]     o_tx_ptp_ins_type,
    input  logic [WORDS-1:0][4:0]     o_tx_ptp_ts,
    input  logic [WORDS-1:0]          o_tx_ptp_fp,
    // EHIP Interface: TX 2-step Timestamp Return [ptp_clk]
    input  logic [PKT_CYL-1:0]        i_tx_ptp_ets_valid,
    input  logic [WORDS-1:0][2:0]     i_tx_ptp_ets,
    input  logic [WORDS-1:0]          i_tx_ptp_ets_fp,
    input  logic [PKT_CYL-1:0][3:0]   i_tx_ptp_ets_vl,
    // User Interface: TX 2-step Timestamp Return [ptp_clk]
    input  logic [PKT_CYL-1:0]        o_tx_ptp_ets_valid,
    input  logic [PKT_CYL-1:0][95:0]  o_tx_ptp_ets,
    input  logic [PKT_CYL-1:0][PTP_FP_WIDTH-1:0]   o_tx_ptp_ets_fp,
    input  logic [PKT_CYL-1:0][4:0]   o_tx_ptp_ets_vl,
    // EHIP Interface: RX Timestamp Return [ptp_clk]
    input  logic [WORDS-1:0]          i_rx_ptp_its,
    input  logic [PKT_CYL-1:0][3:0]   i_rx_ptp_its_vl,
    // User Interface: RX Timestamp Return [ptp_clk]
    input  logic [PKT_CYL-1:0]        o_rx_ptp_its_valid,
    input  logic [PKT_CYL-1:0][95:0]  o_rx_ptp_its,
    input  logic [PKT_CYL-1:0][4:0]   o_rx_ptp_its_vl,
    // EHIP Interface: Reference Timestamp
    input  logic [PL-1:0]             o_tx_ptp_async_cal_sel,
    input  logic [PL-1:0]             o_rx_ptp_async_cal_sel,
    input  logic [PL-1:0]             o_ptp_async_cal_pulse,
    input  logic [PL-1:0]             i_tx_ptp_async_pulse,
    input  logic [PL-1:0]             i_rx_ptp_async_pulse,
    input  logic                      i_tx_ptp_sync_am,
    input  logic                      i_rx_ptp_sync_am,
    // EHIP Interface: Status [async]
    input  logic [PL-1:0]             i_stat_rxpll_lock,
    // CSR & User Interface: PTP Status [ptp_clk]
    input  logic                      o_tx_ptp_offset_data_valid,
    input  logic                      o_rx_ptp_offset_data_valid,
    input  logic                      o_tx_ptp_ready,
    input  logic                      o_rx_ptp_ready,
    // internal (add comma above)
    input  logic                      idle_period,
    input  logic                      int_rx_valid,
    input  logic [WORDS-1:0]          rev_in_rx_pkt_inframe
    
);

logic       rx_inframe_p1;
logic       valid_eop;

generate if (WORDS==1) begin: sva_valid_eop
    
   assign valid_eop = (i_rx_pkt_valid & ~i_rx_pkt_inframe & rx_inframe_p1);
   
   always @(posedge i_ptp_clk or negedge i_rx_srst_n) begin
       if (~i_rx_srst_n) begin
            rx_inframe_p1   <= 1'b0;
       end
       else begin
           if (i_rx_pkt_valid) begin
               rx_inframe_p1   <=  i_rx_pkt_inframe;
           end
       end
    end
end
endgenerate   
   //---------------------------------------------------------------------------
   // Add all of the automated assertions control and setup
   //---------------------------------------------------------------------------
   `altuvm_sva_setup(eth_f_ptp_sva, posedge, i_ptp_clk, ($sampled(i_rx_srst_n) !== 1))

   //---------------------------------------------------------------------------
   // Assertions, Cover Directives, Covergroup
   //---------------------------------------------------------------------------
   `include "eth_f_ptp_cvprp.sv"
   `include "eth_f_ptp_assrt.sv"

endmodule : eth_f_ptp_sva
