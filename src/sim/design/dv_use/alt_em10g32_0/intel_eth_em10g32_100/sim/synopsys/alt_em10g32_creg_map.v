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


`timescale 1 ps / 1 ps
module alt_em10g32_creg_map (
    // Clock & Reset
    csr_clk,
    csr_clk_rst_n,

    // Register Inputs and Outputs
    revision_id,
    mac_capability,
    pri_macaddr_bit31to0,
    pri_macaddr_bit47to32,
    wait_request_timeout,
    wait_request_timeout_in,
    tx_data_path_reset,
    rx_data_path_reset,
    tx_tsfr_en_n,
    tx_datafrm_tsfr_en_sts,
    tx_busy,
    tx_rst_sts,
    tx_pad_insrt_en,
    tx_crcctl_reserved,
    tx_crc_insrt_en,
    tx_preamb_passthru_en,
    tx_sa_override_en,
    tx_max_datafrmlen,
    txvlandet_dis,
    tx_pipg10g_dic,
    tx_pipg1g_fixed,
    tx_udf_errcnt_bit31to0,
    tx_udf_errcnt_bit35to32,
    tx_pausefrm_xonxoff,
    tx_pausefrm_xonxoff_valid_internal,
    csr_tx_pause_xonxoff_ctrl_clr_internal,
    tx_pausefrm_pqt,
    tx_pausefrm_xoff_hqt,
    tx_pausefrm_en,
    tx_pausefrm_policy,
    tx_pfcfrm_en0,
    tx_pfcfrm_en1,
    tx_pfcfrm_en2,
    tx_pfcfrm_en3,
    tx_pfcfrm_en4,
    tx_pfcfrm_en5,
    tx_pfcfrm_en6,
    tx_pfcfrm_en7,
    tx_pfcfrm_pqt0,
    tx_pfcfrm_pqt1,
    tx_pfcfrm_pqt2,
    tx_pfcfrm_pqt3,
    tx_pfcfrm_pqt4,
    tx_pfcfrm_pqt5,
    tx_pfcfrm_pqt6,
    tx_pfcfrm_pqt7,
    tx_xoff_hqt0,
    tx_xoff_hqt1,
    tx_xoff_hqt2,
    tx_xoff_hqt3,
    tx_xoff_hqt4,
    tx_xoff_hqt5,
    tx_xoff_hqt6,
    tx_xoff_hqt7,
    tx_unidirectional_en,
    tx_unidirectional_remote_fault_dis,
    tx_unidirectional_force_remote_fault,
    rx_tsfr_en_n,
    rx_tsfr_sts,
    rx_busy,
    rx_rst_sts,
    rx_crcpad_rem,
    rx_crc_reserved,
    rx_crc_chk,
    rx_preambctl_fwd,
    rx_preamb_passthru_en,
    rx_allucast_en,
    rx_allmcast_en,
    rx_fwd_ctlfrm,
    rx_fwd_pausefrm,
    rx_ignore_pausefrm,
    rx_suppaddr_en0,
    rx_suppaddr_en1,
    rx_suppaddr_en2,
    rx_suppaddr_en3,
    rx_max_datafrmlen,
    rxvlandet_dis,
    rx_supp_macaddr_bit31to0_0,
    rx_supp_macaddr_bit47to32_0,
    rx_supp_macaddr_bit31to0_1,
    rx_supp_macaddr_bit47to32_1,
    rx_supp_macaddr_bit31to0_2,
    rx_supp_macaddr_bit47to32_2,
    rx_supp_macaddr_bit31to0_3,
    rx_supp_macaddr_bit47to32_3,
    rx_pfc_ignore_pausefrm_0,
    rx_pfc_ignore_pausefrm_1,
    rx_pfc_ignore_pausefrm_2,
    rx_pfc_ignore_pausefrm_3,
    rx_pfc_ignore_pausefrm_4,
    rx_pfc_ignore_pausefrm_5,
    rx_pfc_ignore_pausefrm_6,
    rx_pfc_ignore_pausefrm_7,
    rx_pfc_fwd,
    rx_pkt_ovrflw_errcnt_bit31to0,
    rx_pkt_ovrflw_errcnt_bit35to32,
    rx_pkt_ovrflw_etherstatsdropevents_bit31to0,
    rx_pkt_ovrflw_etherstatsdropevents_bit35to32,
    tx_period_10g,
    tx_adj_fracns_10g,
    tx_adj_ns_10g,
    tx_period_1g,
    tx_adj_fracns_1g,
    tx_adj_ns_1g,
    tx_asymmetry,
    tx_p2p_dir_egress,
    cf_overflow_ingress,
    cf_overflow_ingress_status_in,
    cf_overflow_egress,
    cf_overflow_egress_status_in,
    cf_rt_gt_eq_4s,
    cf_rt_gt_eq_4s_status_in,
    cf_rt_neg,
    cf_rt_neg_status_in,
    rx_period_10g,
    rx_adj_fracns_10g,
    rx_adj_ns_10g,
    rx_period_1g,
    rx_adj_fracns_1g,
    rx_adj_ns_1g,
    rx_p2p_val_ns,
    rx_p2p_val_valid,
    rx_p2p_val_fns,
    ecc_corrected_err,
    ecc_corrected_err_status_in,
    ecc_fatal_err,
    ecc_fatal_err_status_in,
    ecc_corrected_err_ena,
    ecc_fatal_err_ena,
    tx_adptdcff_rdwtrmrk_dis,
    tx_adptdcff_rdwtrmrk,
    tx_adptdcff_vldpkt_minwt,

    // Avalon-MM Slave
    avs_address,
    avs_read,
    avs_write,
    avs_writedata,
    avs_readdata,
    avs_waitrequest,

    // Parameters
    insert_st_adaptor,
    enable_tx,
    enable_rx,
    enable_tx_crc,
    enable_supp_addr,
    enable_pfc,
    enable_preamble_passthrough,
    pfc_priority_num,
    enable_timestamping,
    enable_asymmetry,
    enable_p2p,
    enable_mem_ecc,
    enable_1g10g_mac,
    enable_unidirectional,
    enable_txrx_datapath_n
);
parameter SYNC_RESET_N = 1;
// Clock & Reset
input                csr_clk;
input                csr_clk_rst_n;

// Register Inputs and Outputs
input      [ 7:0]    revision_id;
input      [31:0]    mac_capability;
output reg [31:0]    pri_macaddr_bit31to0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    pri_macaddr_bit47to32 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           wait_request_timeout;
input                wait_request_timeout_in;
output reg           tx_data_path_reset;
output reg           rx_data_path_reset;
output reg           tx_tsfr_en_n;
input                tx_datafrm_tsfr_en_sts;
input                tx_busy;
input                tx_rst_sts;
output reg           tx_pad_insrt_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
input                tx_crcctl_reserved;
output reg           tx_crc_insrt_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_preamb_passthru_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_sa_override_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_max_datafrmlen /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           txvlandet_dis /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [ 7:0]    tx_pipg10g_dic /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [ 7:0]    tx_pipg1g_fixed /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
input      [31:0]    tx_udf_errcnt_bit31to0;
input      [ 3:0]    tx_udf_errcnt_bit35to32;
output reg [ 1:0]    tx_pausefrm_xonxoff;
output reg           tx_pausefrm_xonxoff_valid_internal;
input                csr_tx_pause_xonxoff_ctrl_clr_internal;
output reg [15:0]    tx_pausefrm_pqt /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pausefrm_xoff_hqt /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pausefrm_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [ 1:0]    tx_pausefrm_policy /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en4 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en5 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en6 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_pfcfrm_en7 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt4 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt5 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt6 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_pfcfrm_pqt7 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt4 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt5 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt6 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    tx_xoff_hqt7 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_unidirectional_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_unidirectional_remote_fault_dis /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           tx_unidirectional_force_remote_fault /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_tsfr_en_n;
input                rx_tsfr_sts;
input                rx_busy;
input                rx_rst_sts;
output reg [ 1:0]    rx_crcpad_rem /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
input                rx_crc_reserved;
output reg           rx_crc_chk;
output reg           rx_preambctl_fwd;
output reg           rx_preamb_passthru_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_allucast_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_allmcast_en /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_fwd_ctlfrm /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_fwd_pausefrm /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_ignore_pausefrm /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_suppaddr_en0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_suppaddr_en1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_suppaddr_en2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_suppaddr_en3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    rx_max_datafrmlen /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rxvlandet_dis /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [31:0]    rx_supp_macaddr_bit31to0_0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    rx_supp_macaddr_bit47to32_0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [31:0]    rx_supp_macaddr_bit31to0_1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    rx_supp_macaddr_bit47to32_1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [31:0]    rx_supp_macaddr_bit31to0_2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    rx_supp_macaddr_bit47to32_2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [31:0]    rx_supp_macaddr_bit31to0_3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [15:0]    rx_supp_macaddr_bit47to32_3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_0 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_1 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_2 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_3 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_4 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_5 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_6 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_ignore_pausefrm_7 /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg           rx_pfc_fwd /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
input      [31:0]    rx_pkt_ovrflw_errcnt_bit31to0;
input      [ 3:0]    rx_pkt_ovrflw_errcnt_bit35to32;
input      [31:0]    rx_pkt_ovrflw_etherstatsdropevents_bit31to0;
input      [ 3:0]    rx_pkt_ovrflw_etherstatsdropevents_bit35to32;
output reg [19:0]    tx_period_10g;
output reg [15:0]    tx_adj_fracns_10g;
output reg [15:0]    tx_adj_ns_10g;
output reg [19:0]    tx_period_1g;
output reg [15:0]    tx_adj_fracns_1g;
output reg [15:0]    tx_adj_ns_1g;
output reg [18:0]    tx_asymmetry;
output reg           tx_p2p_dir_egress;
output reg           cf_overflow_ingress;
input                cf_overflow_ingress_status_in;
output reg           cf_overflow_egress;
input                cf_overflow_egress_status_in;
output reg           cf_rt_gt_eq_4s;
input                cf_rt_gt_eq_4s_status_in;
output reg           cf_rt_neg;
input                cf_rt_neg_status_in;
output reg [19:0]    rx_period_10g;
output reg [15:0]    rx_adj_fracns_10g;
output reg [15:0]    rx_adj_ns_10g;
output reg [19:0]    rx_period_1g;
output reg [15:0]    rx_adj_fracns_1g;
output reg [15:0]    rx_adj_ns_1g;
output reg [29:0]    rx_p2p_val_ns;
output reg           rx_p2p_val_valid;
output reg [15:0]    rx_p2p_val_fns;
output reg           ecc_corrected_err;
input                ecc_corrected_err_status_in;
output reg           ecc_fatal_err;
input                ecc_fatal_err_status_in;
output reg           ecc_corrected_err_ena;
output reg           ecc_fatal_err_ena;
output reg           tx_adptdcff_rdwtrmrk_dis /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [ 2:0]    tx_adptdcff_rdwtrmrk /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
output reg [ 2:0]    tx_adptdcff_vldpkt_minwt /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;

// Avalon-MM Slave
input      [ 9:0]    avs_address;
input                avs_read;
input                avs_write;
input      [31:0]    avs_writedata;
output reg [31:0]    avs_readdata;
output               avs_waitrequest;

// Parameters
input                insert_st_adaptor;
input                enable_tx;
input                enable_rx;
input                enable_tx_crc;
input                enable_supp_addr;
input                enable_pfc;
input                enable_preamble_passthrough;
input      [ 3:0]    pfc_priority_num;
input                enable_timestamping;
input                enable_asymmetry;
input                enable_p2p;
input                enable_mem_ecc;
input                enable_1g10g_mac;
input                enable_unidirectional;
input                enable_txrx_datapath_n;

// Internal Signals for CSR Read
wire       [31:0]    rev_id;
wire       [31:0]    capability;
wire       [31:0]    pri_macaddr_lower;
wire       [31:0]    pri_macaddr_1_upper;
wire       [31:0]    mac_common_status;
wire       [31:0]    data_path_reset;
wire       [31:0]    tx_pktctl;
wire       [31:0]    tx_pktsts;
wire       [31:0]    tx_padctl;
wire       [31:0]    tx_crcctl;
wire       [31:0]    tx_preambctl;
wire       [31:0]    tx_sa_override;
wire       [31:0]    tx_frmctl;
wire       [31:0]    txvlandetection_dis;
wire       [31:0]    tx_pipg_10g;
wire       [31:0]    tx_pipg_1g;
wire       [31:0]    tx_udf_stat_0;
wire       [31:0]    tx_udf_stat_1;
wire       [31:0]    tx_pausectl;
wire       [31:0]    tx_pausefrm_pq;
wire       [31:0]    tx_pausefrm_hqt;
wire       [31:0]    tx_pausefrm_genctl;
wire       [31:0]    tx_pfcfrm_en;
wire       [31:0]    tx_pfcfrm_pq0;
wire       [31:0]    tx_pfcfrm_pq1;
wire       [31:0]    tx_pfcfrm_pq2;
wire       [31:0]    tx_pfcfrm_pq3;
wire       [31:0]    tx_pfcfrm_pq4;
wire       [31:0]    tx_pfcfrm_pq5;
wire       [31:0]    tx_pfcfrm_pq6;
wire       [31:0]    tx_pfcfrm_pq7;
wire       [31:0]    tx_pfcfrm_hq0;
wire       [31:0]    tx_pfcfrm_hq1;
wire       [31:0]    tx_pfcfrm_hq2;
wire       [31:0]    tx_pfcfrm_hq3;
wire       [31:0]    tx_pfcfrm_hq4;
wire       [31:0]    tx_pfcfrm_hq5;
wire       [31:0]    tx_pfcfrm_hq6;
wire       [31:0]    tx_pfcfrm_hq7;
wire       [31:0]    tx_unidirectional_feature;
wire       [31:0]    rx_pktctl;
wire       [31:0]    rx_pktsts;
wire       [31:0]    rx_crcpad_ctl;
wire       [31:0]    rx_crc_ctl;
wire       [31:0]    rx_preamb_fwd_ctl;
wire       [31:0]    rx_preamb_pt;
wire       [31:0]    rx_frm_ctl;
wire       [31:0]    rx_frm_ctl_maxlen;
wire       [31:0]    rxvlandetection_dis;
wire       [31:0]    rx_supp_macaddr_lower_0;
wire       [31:0]    rx_supp_macaddr_upper_0;
wire       [31:0]    rx_supp_macaddr_lower_1;
wire       [31:0]    rx_supp_macaddr_upper_1;
wire       [31:0]    rx_supp_macaddr_lower_2;
wire       [31:0]    rx_supp_macaddr_upper_2;
wire       [31:0]    rx_supp_macaddr_lower_3;
wire       [31:0]    rx_supp_macaddr_upper_3;
wire       [31:0]    rx_pfc_ctl;
wire       [31:0]    rx_pkt_ovrflw_errcnt_lower;
wire       [31:0]    rx_pkt_ovrflw_errcnt_upper;
wire       [31:0]    rx_pkt_ovrflw_etherstatsdropevents_lower;
wire       [31:0]    rx_pkt_ovrflw_etherstatsdropevents_upper;
wire       [31:0]    tx_period10g;
wire       [31:0]    tx_adjns_10g;
wire       [31:0]    tx_adjfracns_10g;
wire       [31:0]    tx_period1g;
wire       [31:0]    tx_adjns_1g;
wire       [31:0]    tx_adjfracns_1g;
wire       [31:0]    tx_asymm;
wire       [31:0]    tx_p2p_dir;
wire       [31:0]    cf_error;
wire       [31:0]    rx_period10g;
wire       [31:0]    rx_adjns_10g;
wire       [31:0]    rx_adjfracns_10g;
wire       [31:0]    rx_period1g;
wire       [31:0]    rx_adjns_1g;
wire       [31:0]    rx_adjfracns_1g;
wire       [31:0]    rx_p2p_vd_ns;
wire       [31:0]    rx_p2p_fns;
wire       [31:0]    ecc_status;
wire       [31:0]    ecc_status_ena;
wire       [31:0]    test_mode;

assign avs_waitrequest = 1'b0;
generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        pri_macaddr_bit31to0[31:0] <= 32'h00000000;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h010) begin
                pri_macaddr_bit31to0[31:0] <= avs_writedata[31:0];
            end
        end
    end
  end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        pri_macaddr_bit31to0[31:0] <= 32'h00000000;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h010) begin
                pri_macaddr_bit31to0[31:0] <= avs_writedata[31:0];
            end
        end
    end
  end 
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        pri_macaddr_bit47to32[15:0] <= 16'h0000;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h011) begin
                pri_macaddr_bit47to32[15:0] <= avs_writedata[15:0];
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        pri_macaddr_bit47to32[15:0] <= 16'h0000;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h011) begin
                pri_macaddr_bit47to32[15:0] <= avs_writedata[15:0];
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        wait_request_timeout <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h01E) begin
                wait_request_timeout <= (avs_writedata[0] == 1'b1) ? 1'b0 : wait_request_timeout | wait_request_timeout_in;
            end
        end
        else begin
            wait_request_timeout <= wait_request_timeout | wait_request_timeout_in;
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        wait_request_timeout <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h01E) begin
                wait_request_timeout <= (avs_writedata[0] == 1'b1) ? 1'b0 : wait_request_timeout | wait_request_timeout_in;
            end
        end
        else begin
            wait_request_timeout <= wait_request_timeout | wait_request_timeout_in;
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_data_path_reset <= 1'b0;
        rx_data_path_reset <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h01F) begin
                tx_data_path_reset <= avs_writedata[0];
            end
        end
        if(avs_write) begin
            if(avs_address == 10'h01F) begin
                rx_data_path_reset <= avs_writedata[8];
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_data_path_reset <= 1'b0;
        rx_data_path_reset <= 1'b0;
    end
    else begin
        if(avs_write) begin
            if(avs_address == 10'h01F) begin
                tx_data_path_reset <= avs_writedata[0];
            end
        end
        if(avs_write) begin
            if(avs_address == 10'h01F) begin
                rx_data_path_reset <= avs_writedata[8];
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_tsfr_en_n <= enable_txrx_datapath_n;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h020) begin
                    tx_tsfr_en_n <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin 
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_tsfr_en_n <= enable_txrx_datapath_n;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h020) begin
                    tx_tsfr_en_n <= avs_writedata[0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pad_insrt_en <= 1'b1;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h024) begin
                    tx_pad_insrt_en <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pad_insrt_en <= 1'b1;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h024) begin
                    tx_pad_insrt_en <= avs_writedata[0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_crc_insrt_en <= 1'b1;
    end
    else begin
        if(enable_tx & enable_tx_crc) begin
            if(avs_write) begin
                if(avs_address == 10'h026) begin
                    tx_crc_insrt_en <= avs_writedata[1];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk  or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_crc_insrt_en <= 1'b1;
    end
    else begin
        if(enable_tx & enable_tx_crc) begin
            if(avs_write) begin
                if(avs_address == 10'h026) begin
                    tx_crc_insrt_en <= avs_writedata[1];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_preamb_passthru_en <= 1'b0;
    end
    else begin
        if(enable_tx & enable_preamble_passthrough) begin
            if(avs_write) begin
                if(avs_address == 10'h028) begin
                    tx_preamb_passthru_en <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_preamb_passthru_en <= 1'b0;
    end
    else begin
        if(enable_tx & enable_preamble_passthrough) begin
            if(avs_write) begin
                if(avs_address == 10'h028) begin
                    tx_preamb_passthru_en <= avs_writedata[0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_sa_override_en <= 1'b0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02A) begin
                    tx_sa_override_en <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_sa_override_en <= 1'b0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02A) begin
                    tx_sa_override_en <= avs_writedata[0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_max_datafrmlen[15:0] <= 16'h5EE;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02C) begin
                    tx_max_datafrmlen[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_max_datafrmlen[15:0] <= 16'h5EE;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02C) begin
                    tx_max_datafrmlen[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        txvlandet_dis <= 1'b0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02D) begin
                    txvlandet_dis <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        txvlandet_dis <= 1'b0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02D) begin
                    txvlandet_dis <= avs_writedata[0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pipg10g_dic[ 7:0] <= 8'h01;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02E) begin
                    tx_pipg10g_dic[ 7:0] <= avs_writedata[ 7:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pipg10g_dic[ 7:0] <= 8'h01;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02E) begin
                    tx_pipg10g_dic[ 7:0] <= avs_writedata[ 7:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pipg1g_fixed[ 7:0] <= 8'h0C;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02F) begin
                    tx_pipg1g_fixed[ 7:0] <= avs_writedata[ 7:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pipg1g_fixed[ 7:0] <= 8'h0C;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h02F) begin
                    tx_pipg1g_fixed[ 7:0] <= avs_writedata[ 7:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_xonxoff[ 1:0] <= 2'h0;
        tx_pausefrm_xonxoff_valid_internal <= 1'b0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h040) begin
                    tx_pausefrm_xonxoff[ 1:0] <= avs_writedata[ 1:0];
                end
            end
            else if(csr_tx_pause_xonxoff_ctrl_clr_internal) begin
                tx_pausefrm_xonxoff[ 1:0] <= 2'h0;
            end
            tx_pausefrm_xonxoff_valid_internal <= avs_write && (avs_address == 10'h040);
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_xonxoff[ 1:0] <= 2'h0;
        tx_pausefrm_xonxoff_valid_internal <= 1'b0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h040) begin
                    tx_pausefrm_xonxoff[ 1:0] <= avs_writedata[ 1:0];
                end
            end
            else if(csr_tx_pause_xonxoff_ctrl_clr_internal) begin
                tx_pausefrm_xonxoff[ 1:0] <= 2'h0;
            end
            tx_pausefrm_xonxoff_valid_internal <= avs_write && (avs_address == 10'h040);
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_pqt[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h042) begin
                    tx_pausefrm_pqt[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_pqt[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h042) begin
                    tx_pausefrm_pqt[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_xoff_hqt[15:0] <= 16'h0001;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h043) begin
                    tx_pausefrm_xoff_hqt[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_xoff_hqt[15:0] <= 16'h0001;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h043) begin
                    tx_pausefrm_xoff_hqt[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_en <= 1'b1;
        tx_pausefrm_policy[ 1:0] <= 2'h0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h044) begin
                    tx_pausefrm_en <= avs_writedata[0];
                end
            end
        end
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h044) begin
                    tx_pausefrm_policy[ 1:0] <= avs_writedata[ 2:1];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pausefrm_en <= 1'b1;
        tx_pausefrm_policy[ 1:0] <= 2'h0;
    end
    else begin
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h044) begin
                    tx_pausefrm_en <= avs_writedata[0];
                end
            end
        end
        if(enable_tx) begin
            if(avs_write) begin
                if(avs_address == 10'h044) begin
                    tx_pausefrm_policy[ 1:0] <= avs_writedata[ 2:1];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_en0 <= 1'b0;
        tx_pfcfrm_en1 <= 1'b0;
        tx_pfcfrm_en2 <= 1'b0;
        tx_pfcfrm_en3 <= 1'b0;
        tx_pfcfrm_en4 <= 1'b0;
        tx_pfcfrm_en5 <= 1'b0;
        tx_pfcfrm_en6 <= 1'b0;
        tx_pfcfrm_en7 <= 1'b0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en0 <= avs_writedata[0];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en1 <= avs_writedata[1];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en2 <= avs_writedata[2];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en3 <= avs_writedata[3];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en4 <= avs_writedata[4];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en5 <= avs_writedata[5];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en6 <= avs_writedata[6];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en7 <= avs_writedata[7];
                end
            end
        end
    end
  end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_en0 <= 1'b0;
        tx_pfcfrm_en1 <= 1'b0;
        tx_pfcfrm_en2 <= 1'b0;
        tx_pfcfrm_en3 <= 1'b0;
        tx_pfcfrm_en4 <= 1'b0;
        tx_pfcfrm_en5 <= 1'b0;
        tx_pfcfrm_en6 <= 1'b0;
        tx_pfcfrm_en7 <= 1'b0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en0 <= avs_writedata[0];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en1 <= avs_writedata[1];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en2 <= avs_writedata[2];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en3 <= avs_writedata[3];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en4 <= avs_writedata[4];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en5 <= avs_writedata[5];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en6 <= avs_writedata[6];
                end
            end
        end
        if(enable_tx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h046) begin
                    tx_pfcfrm_en7 <= avs_writedata[7];
                end
            end
        end
    end
  end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt0[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h048) begin
                    tx_pfcfrm_pqt0[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt0[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h048) begin
                    tx_pfcfrm_pqt0[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate
generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt1[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h049) begin
                    tx_pfcfrm_pqt1[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt1[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h049) begin
                    tx_pfcfrm_pqt1[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt2[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h04A) begin
                    tx_pfcfrm_pqt2[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt2[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h04A) begin
                    tx_pfcfrm_pqt2[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt3[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h04B) begin
                    tx_pfcfrm_pqt3[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt3[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h04B) begin
                    tx_pfcfrm_pqt3[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt4[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h04C) begin
                    tx_pfcfrm_pqt4[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt4[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h04C) begin
                    tx_pfcfrm_pqt4[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt5[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h04D) begin
                    tx_pfcfrm_pqt5[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end  else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt5[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h04D) begin
                    tx_pfcfrm_pqt5[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt6[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h04E) begin
                    tx_pfcfrm_pqt6[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt6[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h04E) begin
                    tx_pfcfrm_pqt6[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt7[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h04F) begin
                    tx_pfcfrm_pqt7[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_pfcfrm_pqt7[15:0] <= 16'h0;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h04F) begin
                    tx_pfcfrm_pqt7[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt0[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h058) begin
                    tx_xoff_hqt0[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt0[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h058) begin
                    tx_xoff_hqt0[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt1[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h059) begin
                    tx_xoff_hqt1[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt1[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h059) begin
                    tx_xoff_hqt1[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt2[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h05A) begin
                    tx_xoff_hqt2[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt2[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h05A) begin
                    tx_xoff_hqt2[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt3[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h05B) begin
                    tx_xoff_hqt3[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt3[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h05B) begin
                    tx_xoff_hqt3[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt4[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h05C) begin
                    tx_xoff_hqt4[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt4[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h05C) begin
                    tx_xoff_hqt4[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt5[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h05D) begin
                    tx_xoff_hqt5[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt5[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h05D) begin
                    tx_xoff_hqt5[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt6[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h05E) begin
                    tx_xoff_hqt6[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt6[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h05E) begin
                    tx_xoff_hqt6[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt7[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h05F) begin
                    tx_xoff_hqt7[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_xoff_hqt7[15:0] <= 16'h1;
    end
    else begin
        if(enable_tx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h05F) begin
                    tx_xoff_hqt7[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_unidirectional_en <= 1'b0;
        tx_unidirectional_remote_fault_dis <= 1'b0;
        tx_unidirectional_force_remote_fault <= 1'b0;
    end
    else begin
        if(enable_tx & enable_unidirectional) begin
            if(avs_write) begin
                if(avs_address == 10'h070) begin
                    tx_unidirectional_en <= avs_writedata[0];
                end
            end
        end
        if(enable_tx & enable_unidirectional) begin
            if(avs_write) begin
                if(avs_address == 10'h070) begin
                    tx_unidirectional_remote_fault_dis <= avs_writedata[1];
                end
            end
        end
        if(enable_tx & enable_unidirectional) begin
            if(avs_write) begin
                if(avs_address == 10'h070) begin
                    tx_unidirectional_force_remote_fault <= avs_writedata[2];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_unidirectional_en <= 1'b0;
        tx_unidirectional_remote_fault_dis <= 1'b0;
        tx_unidirectional_force_remote_fault <= 1'b0;
    end
    else begin
        if(enable_tx & enable_unidirectional) begin
            if(avs_write) begin
                if(avs_address == 10'h070) begin
                    tx_unidirectional_en <= avs_writedata[0];
                end
            end
        end
        if(enable_tx & enable_unidirectional) begin
            if(avs_write) begin
                if(avs_address == 10'h070) begin
                    tx_unidirectional_remote_fault_dis <= avs_writedata[1];
                end
            end
        end
        if(enable_tx & enable_unidirectional) begin
            if(avs_write) begin
                if(avs_address == 10'h070) begin
                    tx_unidirectional_force_remote_fault <= avs_writedata[2];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_tsfr_en_n <= enable_txrx_datapath_n;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0A0) begin
                    rx_tsfr_en_n <= avs_writedata[0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_crcpad_rem[ 1:0] <= 2'h1;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0A4) begin
                    rx_crcpad_rem[ 1:0] <= avs_writedata[ 1:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_crc_chk <= 1'b1;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0A6) begin
                    rx_crc_chk <= avs_writedata[1];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_preambctl_fwd <= 1'b0;
    end
    else begin
        if(enable_rx & enable_preamble_passthrough) begin
            if(avs_write) begin
                if(avs_address == 10'h0A8) begin
                    rx_preambctl_fwd <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_tsfr_en_n <= enable_txrx_datapath_n;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0A0) begin
                    rx_tsfr_en_n <= avs_writedata[0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_crcpad_rem[ 1:0] <= 2'h1;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0A4) begin
                    rx_crcpad_rem[ 1:0] <= avs_writedata[ 1:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_crc_chk <= 1'b1;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0A6) begin
                    rx_crc_chk <= avs_writedata[1];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_preambctl_fwd <= 1'b0;
    end
    else begin
        if(enable_rx & enable_preamble_passthrough) begin
            if(avs_write) begin
                if(avs_address == 10'h0A8) begin
                    rx_preambctl_fwd <= avs_writedata[0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_preamb_passthru_en <= 1'b0;
    end
    else begin
        if(enable_rx & enable_preamble_passthrough) begin
            if(avs_write) begin
                if(avs_address == 10'h0AA) begin
                    rx_preamb_passthru_en <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_preamb_passthru_en <= 1'b0;
    end
    else begin
        if(enable_rx & enable_preamble_passthrough) begin
            if(avs_write) begin
                if(avs_address == 10'h0AA) begin
                    rx_preamb_passthru_en <= avs_writedata[0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_allucast_en <= 1'b1;
        rx_allmcast_en <= 1'b1;
        rx_fwd_ctlfrm <= 1'b0;
        rx_fwd_pausefrm <= 1'b0;
        rx_ignore_pausefrm <= 1'b0;
        rx_suppaddr_en0 <= 1'b0;
        rx_suppaddr_en1 <= 1'b0;
        rx_suppaddr_en2 <= 1'b0;
        rx_suppaddr_en3 <= 1'b0;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_allucast_en <= avs_writedata[0];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_allmcast_en <= avs_writedata[1];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_fwd_ctlfrm <= avs_writedata[3];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_fwd_pausefrm <= avs_writedata[4];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_ignore_pausefrm <= avs_writedata[5];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en0 <= avs_writedata[16];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en1 <= avs_writedata[17];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en2 <= avs_writedata[18];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en3 <= avs_writedata[19];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_allucast_en <= 1'b1;
        rx_allmcast_en <= 1'b1;
        rx_fwd_ctlfrm <= 1'b0;
        rx_fwd_pausefrm <= 1'b0;
        rx_ignore_pausefrm <= 1'b0;
        rx_suppaddr_en0 <= 1'b0;
        rx_suppaddr_en1 <= 1'b0;
        rx_suppaddr_en2 <= 1'b0;
        rx_suppaddr_en3 <= 1'b0;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_allucast_en <= avs_writedata[0];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_allmcast_en <= avs_writedata[1];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_fwd_ctlfrm <= avs_writedata[3];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_fwd_pausefrm <= avs_writedata[4];
                end
            end
        end
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_ignore_pausefrm <= avs_writedata[5];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en0 <= avs_writedata[16];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en1 <= avs_writedata[17];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en2 <= avs_writedata[18];
                end
            end
        end
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0AC) begin
                    rx_suppaddr_en3 <= avs_writedata[19];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_max_datafrmlen[15:0] <= 16'h5EE;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AE) begin
                    rx_max_datafrmlen[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rxvlandet_dis <= 1'b0;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AF) begin
                    rxvlandet_dis <= avs_writedata[0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_0[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B0) begin
                    rx_supp_macaddr_bit31to0_0[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_0[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B1) begin
                    rx_supp_macaddr_bit47to32_0[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_max_datafrmlen[15:0] <= 16'h5EE;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AE) begin
                    rx_max_datafrmlen[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rxvlandet_dis <= 1'b0;
    end
    else begin
        if(enable_rx) begin
            if(avs_write) begin
                if(avs_address == 10'h0AF) begin
                    rxvlandet_dis <= avs_writedata[0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_0[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B0) begin
                    rx_supp_macaddr_bit31to0_0[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_0[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B1) begin
                    rx_supp_macaddr_bit47to32_0[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_1[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B2) begin
                    rx_supp_macaddr_bit31to0_1[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_1[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B3) begin
                    rx_supp_macaddr_bit47to32_1[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_2[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B4) begin
                    rx_supp_macaddr_bit31to0_2[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_2[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B5) begin
                    rx_supp_macaddr_bit47to32_2[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_1[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B2) begin
                    rx_supp_macaddr_bit31to0_1[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_1[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B3) begin
                    rx_supp_macaddr_bit47to32_1[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_2[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B4) begin
                    rx_supp_macaddr_bit31to0_2[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_2[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B5) begin
                    rx_supp_macaddr_bit47to32_2[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_3[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B6) begin
                    rx_supp_macaddr_bit31to0_3[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_3[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B7) begin
                    rx_supp_macaddr_bit47to32_3[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit31to0_3[31:0] <= 32'h00000000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B6) begin
                    rx_supp_macaddr_bit31to0_3[31:0] <= avs_writedata[31:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_supp_macaddr_bit47to32_3[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_supp_addr) begin
            if(avs_write) begin
                if(avs_address == 10'h0B7) begin
                    rx_supp_macaddr_bit47to32_3[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_pfc_ignore_pausefrm_0 <= 1'b1;
        rx_pfc_ignore_pausefrm_1 <= 1'b1;
        rx_pfc_ignore_pausefrm_2 <= 1'b1;
        rx_pfc_ignore_pausefrm_3 <= 1'b1;
        rx_pfc_ignore_pausefrm_4 <= 1'b1;
        rx_pfc_ignore_pausefrm_5 <= 1'b1;
        rx_pfc_ignore_pausefrm_6 <= 1'b1;
        rx_pfc_ignore_pausefrm_7 <= 1'b1;
        rx_pfc_fwd <= 1'b0;
    end
    else begin
        if(enable_rx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_0 <= avs_writedata[0];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_1 <= avs_writedata[1];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_2 <= avs_writedata[2];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_3 <= avs_writedata[3];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_4 <= avs_writedata[4];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_5 <= avs_writedata[5];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_6 <= avs_writedata[6];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_7 <= avs_writedata[7];
                end
            end
        end
        if(enable_rx & enable_pfc) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_fwd <= avs_writedata[16];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_pfc_ignore_pausefrm_0 <= 1'b1;
        rx_pfc_ignore_pausefrm_1 <= 1'b1;
        rx_pfc_ignore_pausefrm_2 <= 1'b1;
        rx_pfc_ignore_pausefrm_3 <= 1'b1;
        rx_pfc_ignore_pausefrm_4 <= 1'b1;
        rx_pfc_ignore_pausefrm_5 <= 1'b1;
        rx_pfc_ignore_pausefrm_6 <= 1'b1;
        rx_pfc_ignore_pausefrm_7 <= 1'b1;
        rx_pfc_fwd <= 1'b0;
    end
    else begin
        if(enable_rx & enable_pfc && (pfc_priority_num > 0)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_0 <= avs_writedata[0];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 1)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_1 <= avs_writedata[1];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 2)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_2 <= avs_writedata[2];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 3)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_3 <= avs_writedata[3];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 4)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_4 <= avs_writedata[4];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 5)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_5 <= avs_writedata[5];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 6)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_6 <= avs_writedata[6];
                end
            end
        end
        if(enable_rx & enable_pfc && (pfc_priority_num > 7)) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_ignore_pausefrm_7 <= avs_writedata[7];
                end
            end
        end
        if(enable_rx & enable_pfc) begin
            if(avs_write) begin
                if(avs_address == 10'h0C0) begin
                    rx_pfc_fwd <= avs_writedata[16];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_period_10g[19:0] <= 20'h33333;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h100) begin
                    tx_period_10g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_adj_fracns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h102) begin
                    tx_adj_fracns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_adj_ns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h104) begin
                    tx_adj_ns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_period_1g[19:0] <= 20'h80000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h108) begin
                    tx_period_1g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_period_10g[19:0] <= 20'h33333;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h100) begin
                    tx_period_10g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_adj_fracns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h102) begin
                    tx_adj_fracns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_adj_ns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h104) begin
                    tx_adj_ns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_period_1g[19:0] <= 20'h80000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h108) begin
                    tx_period_1g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_adj_fracns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h10A) begin
                    tx_adj_fracns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_adj_ns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h10C) begin
                    tx_adj_ns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_asymmetry[18:0] <= 19'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_asymmetry) begin
            if(avs_write) begin
                if(avs_address == 10'h110) begin
                    tx_asymmetry[18:0] <= avs_writedata[18:0];
                end
            end
        end
    end
end

always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        tx_p2p_dir_egress <= 1'b0;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h112) begin
                    tx_p2p_dir_egress <= avs_writedata[0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_adj_fracns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h10A) begin
                    tx_adj_fracns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_adj_ns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h10C) begin
                    tx_adj_ns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_asymmetry[18:0] <= 19'h0000;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_asymmetry) begin
            if(avs_write) begin
                if(avs_address == 10'h110) begin
                    tx_asymmetry[18:0] <= avs_writedata[18:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_p2p_dir_egress <= 1'b0;
    end
    else begin
        if(enable_tx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h112) begin
                    tx_p2p_dir_egress <= avs_writedata[0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        cf_overflow_ingress <= 1'b0;
        cf_overflow_egress <= 1'b0;
        cf_rt_gt_eq_4s <= 1'b0;
        cf_rt_neg <= 1'b0;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_overflow_ingress <= (avs_writedata[0] == 1'b1) ? 1'b0 : cf_overflow_ingress | cf_overflow_ingress_status_in;
                end
            end
            else begin
                cf_overflow_ingress <= cf_overflow_ingress | cf_overflow_ingress_status_in;
            end
        end
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_overflow_egress <= (avs_writedata[16] == 1'b1) ? 1'b0 : cf_overflow_egress | cf_overflow_egress_status_in;
                end
            end
            else begin
                cf_overflow_egress <= cf_overflow_egress | cf_overflow_egress_status_in;
            end
        end
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_rt_gt_eq_4s <= (avs_writedata[17] == 1'b1) ? 1'b0 : cf_rt_gt_eq_4s | cf_rt_gt_eq_4s_status_in;
                end
            end
            else begin
                cf_rt_gt_eq_4s <= cf_rt_gt_eq_4s | cf_rt_gt_eq_4s_status_in;
            end
        end
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_rt_neg <= (avs_writedata[18] == 1'b1) ? 1'b0 : cf_rt_neg | cf_rt_neg_status_in;
                end
            end
            else begin
                cf_rt_neg <= cf_rt_neg | cf_rt_neg_status_in;
            end
        end
    end
end

always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        rx_period_10g[19:0] <= 20'h33333;
    end
    else begin
        if(enable_rx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h120) begin
                    rx_period_10g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        cf_overflow_ingress <= 1'b0;
        cf_overflow_egress <= 1'b0;
        cf_rt_gt_eq_4s <= 1'b0;
        cf_rt_neg <= 1'b0;
    end
    else begin
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_overflow_ingress <= (avs_writedata[0] == 1'b1) ? 1'b0 : cf_overflow_ingress | cf_overflow_ingress_status_in;
                end
            end
            else begin
                cf_overflow_ingress <= cf_overflow_ingress | cf_overflow_ingress_status_in;
            end
        end
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_overflow_egress <= (avs_writedata[16] == 1'b1) ? 1'b0 : cf_overflow_egress | cf_overflow_egress_status_in;
                end
            end
            else begin
                cf_overflow_egress <= cf_overflow_egress | cf_overflow_egress_status_in;
            end
        end
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_rt_gt_eq_4s <= (avs_writedata[17] == 1'b1) ? 1'b0 : cf_rt_gt_eq_4s | cf_rt_gt_eq_4s_status_in;
                end
            end
            else begin
                cf_rt_gt_eq_4s <= cf_rt_gt_eq_4s | cf_rt_gt_eq_4s_status_in;
            end
        end
        if(enable_tx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h114) begin
                    cf_rt_neg <= (avs_writedata[18] == 1'b1) ? 1'b0 : cf_rt_neg | cf_rt_neg_status_in;
                end
            end
            else begin
                cf_rt_neg <= cf_rt_neg | cf_rt_neg_status_in;
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_period_10g[19:0] <= 20'h33333;
    end
    else begin
        if(enable_rx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h120) begin
                    rx_period_10g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end
end 
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        rx_adj_fracns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h122) begin
                    rx_adj_fracns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_adj_ns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h124) begin
                    rx_adj_ns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_period_1g[19:0] <= 20'h80000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h128) begin
                    rx_period_1g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_adj_fracns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h12A) begin
                    rx_adj_fracns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_adj_fracns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h122) begin
                    rx_adj_fracns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_adj_ns_10g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping) begin
            if(avs_write) begin
                if(avs_address == 10'h124) begin
                    rx_adj_ns_10g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_period_1g[19:0] <= 20'h80000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h128) begin
                    rx_period_1g[19:0] <= avs_writedata[19:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_adj_fracns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h12A) begin
                    rx_adj_fracns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_adj_ns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h12C) begin
                    rx_adj_ns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_p2p_val_ns[29:0] <= 30'h00000000;
        rx_p2p_val_valid <= 1'b0;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h12E) begin
                    rx_p2p_val_ns[29:0] <= avs_writedata[29:0];
                end
            end
        end
        if(enable_rx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h12E) begin
                    rx_p2p_val_valid <= avs_writedata[30];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        rx_p2p_val_fns[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h130) begin
                    rx_p2p_val_fns[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        ecc_corrected_err <= 1'b0;
        ecc_fatal_err <= 1'b0;
    end
    else begin
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h240) begin
                    ecc_corrected_err <= (avs_writedata[0] == 1'b1) ? 1'b0 : ecc_corrected_err | ecc_corrected_err_status_in;
                end
            end
            else begin
                ecc_corrected_err <= ecc_corrected_err | ecc_corrected_err_status_in;
            end
        end
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h240) begin
                    ecc_fatal_err <= (avs_writedata[1] == 1'b1) ? 1'b0 : ecc_fatal_err | ecc_fatal_err_status_in;
                end
            end
            else begin
                ecc_fatal_err <= ecc_fatal_err | ecc_fatal_err_status_in;
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_adj_ns_1g[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_1g10g_mac) begin
            if(avs_write) begin
                if(avs_address == 10'h12C) begin
                    rx_adj_ns_1g[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_p2p_val_ns[29:0] <= 30'h00000000;
        rx_p2p_val_valid <= 1'b0;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h12E) begin
                    rx_p2p_val_ns[29:0] <= avs_writedata[29:0];
                end
            end
        end
        if(enable_rx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h12E) begin
                    rx_p2p_val_valid <= avs_writedata[30];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        rx_p2p_val_fns[15:0] <= 16'h0000;
    end
    else begin
        if(enable_rx & enable_timestamping & enable_p2p) begin
            if(avs_write) begin
                if(avs_address == 10'h130) begin
                    rx_p2p_val_fns[15:0] <= avs_writedata[15:0];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ecc_corrected_err <= 1'b0;
        ecc_fatal_err <= 1'b0;
    end
    else begin
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h240) begin
                    ecc_corrected_err <= (avs_writedata[0] == 1'b1) ? 1'b0 : ecc_corrected_err | ecc_corrected_err_status_in;
                end
            end
            else begin
                ecc_corrected_err <= ecc_corrected_err | ecc_corrected_err_status_in;
            end
        end
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h240) begin
                    ecc_fatal_err <= (avs_writedata[1] == 1'b1) ? 1'b0 : ecc_fatal_err | ecc_fatal_err_status_in;
                end
            end
            else begin
                ecc_fatal_err <= ecc_fatal_err | ecc_fatal_err_status_in;
            end
        end
    end
end
end
endgenerate

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        ecc_corrected_err_ena <= 1'b0;
        ecc_fatal_err_ena <= 1'b0;
    end
    else begin
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h241) begin
                    ecc_corrected_err_ena <= avs_writedata[0];
                end
            end
        end
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h241) begin
                    ecc_fatal_err_ena <= avs_writedata[1];
                end
            end
        end
    end
end

always @(posedge csr_clk) begin
    if(!csr_clk_rst_n) begin
        tx_adptdcff_rdwtrmrk_dis <= 1'b0;
        tx_adptdcff_rdwtrmrk[ 2:0] <= 3'h2;
        tx_adptdcff_vldpkt_minwt[ 2:0] <= 3'h2;
    end
    else begin
        if(enable_tx & insert_st_adaptor) begin
            if(avs_write) begin
                if(avs_address == 10'h3F0) begin
                    tx_adptdcff_rdwtrmrk_dis <= avs_writedata[0];
                end
            end
        end
        if(enable_tx & insert_st_adaptor) begin
            if(avs_write) begin
                if(avs_address == 10'h3F0) begin
                    tx_adptdcff_rdwtrmrk[ 2:0] <= avs_writedata[ 3:1];
                end
            end
        end
        if(enable_tx & insert_st_adaptor) begin
            if(avs_write) begin
                if(avs_address == 10'h3F0) begin
                    tx_adptdcff_vldpkt_minwt[ 2:0] <= avs_writedata[19:17];
                end
            end
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        ecc_corrected_err_ena <= 1'b0;
        ecc_fatal_err_ena <= 1'b0;
    end
    else begin
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h241) begin
                    ecc_corrected_err_ena <= avs_writedata[0];
                end
            end
        end
        if(enable_mem_ecc) begin
            if(avs_write) begin
                if(avs_address == 10'h241) begin
                    ecc_fatal_err_ena <= avs_writedata[1];
                end
            end
        end
    end
end

always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        tx_adptdcff_rdwtrmrk_dis <= 1'b0;
        tx_adptdcff_rdwtrmrk[ 2:0] <= 3'h2;
        tx_adptdcff_vldpkt_minwt[ 2:0] <= 3'h2;
    end
    else begin
        if(enable_tx & insert_st_adaptor) begin
            if(avs_write) begin
                if(avs_address == 10'h3F0) begin
                    tx_adptdcff_rdwtrmrk_dis <= avs_writedata[0];
                end
            end
        end
        if(enable_tx & insert_st_adaptor) begin
            if(avs_write) begin
                if(avs_address == 10'h3F0) begin
                    tx_adptdcff_rdwtrmrk[ 2:0] <= avs_writedata[ 3:1];
                end
            end
        end
        if(enable_tx & insert_st_adaptor) begin
            if(avs_write) begin
                if(avs_address == 10'h3F0) begin
                    tx_adptdcff_vldpkt_minwt[ 2:0] <= avs_writedata[19:17];
                end
            end
        end
    end
end
end
endgenerate


assign rev_id[0] = revision_id[0];
assign rev_id[1] = revision_id[1];
assign rev_id[2] = revision_id[2];
assign rev_id[3] = revision_id[3];
assign rev_id[4] = revision_id[4];
assign rev_id[5] = revision_id[5];
assign rev_id[6] = revision_id[6];
assign rev_id[7] = revision_id[7];
assign rev_id[8] = 1'b0;
assign rev_id[9] = 1'b0;
assign rev_id[10] = 1'b0;
assign rev_id[11] = 1'b0;
assign rev_id[12] = 1'b0;
assign rev_id[13] = 1'b0;
assign rev_id[14] = 1'b0;
assign rev_id[15] = 1'b0;
assign rev_id[16] = 1'b0;
assign rev_id[17] = 1'b0;
assign rev_id[18] = 1'b0;
assign rev_id[19] = 1'b0;
assign rev_id[20] = 1'b0;
assign rev_id[21] = 1'b0;
assign rev_id[22] = 1'b0;
assign rev_id[23] = 1'b0;
assign rev_id[24] = 1'b0;
assign rev_id[25] = 1'b0;
assign rev_id[26] = 1'b0;
assign rev_id[27] = 1'b0;
assign rev_id[28] = 1'b0;
assign rev_id[29] = 1'b0;
assign rev_id[30] = 1'b0;
assign rev_id[31] = 1'b0;

assign capability[0] = mac_capability[0];
assign capability[1] = mac_capability[1];
assign capability[2] = mac_capability[2];
assign capability[3] = mac_capability[3];
assign capability[4] = mac_capability[4];
assign capability[5] = mac_capability[5];
assign capability[6] = mac_capability[6];
assign capability[7] = mac_capability[7];
assign capability[8] = mac_capability[8];
assign capability[9] = mac_capability[9];
assign capability[10] = mac_capability[10];
assign capability[11] = mac_capability[11];
assign capability[12] = mac_capability[12];
assign capability[13] = mac_capability[13];
assign capability[14] = mac_capability[14];
assign capability[15] = mac_capability[15];
assign capability[16] = mac_capability[16];
assign capability[17] = mac_capability[17];
assign capability[18] = mac_capability[18];
assign capability[19] = mac_capability[19];
assign capability[20] = mac_capability[20];
assign capability[21] = mac_capability[21];
assign capability[22] = mac_capability[22];
assign capability[23] = mac_capability[23];
assign capability[24] = mac_capability[24];
assign capability[25] = mac_capability[25];
assign capability[26] = mac_capability[26];
assign capability[27] = mac_capability[27];
assign capability[28] = mac_capability[28];
assign capability[29] = mac_capability[29];
assign capability[30] = mac_capability[30];
assign capability[31] = mac_capability[31];

assign pri_macaddr_lower[0] = pri_macaddr_bit31to0[0];
assign pri_macaddr_lower[1] = pri_macaddr_bit31to0[1];
assign pri_macaddr_lower[2] = pri_macaddr_bit31to0[2];
assign pri_macaddr_lower[3] = pri_macaddr_bit31to0[3];
assign pri_macaddr_lower[4] = pri_macaddr_bit31to0[4];
assign pri_macaddr_lower[5] = pri_macaddr_bit31to0[5];
assign pri_macaddr_lower[6] = pri_macaddr_bit31to0[6];
assign pri_macaddr_lower[7] = pri_macaddr_bit31to0[7];
assign pri_macaddr_lower[8] = pri_macaddr_bit31to0[8];
assign pri_macaddr_lower[9] = pri_macaddr_bit31to0[9];
assign pri_macaddr_lower[10] = pri_macaddr_bit31to0[10];
assign pri_macaddr_lower[11] = pri_macaddr_bit31to0[11];
assign pri_macaddr_lower[12] = pri_macaddr_bit31to0[12];
assign pri_macaddr_lower[13] = pri_macaddr_bit31to0[13];
assign pri_macaddr_lower[14] = pri_macaddr_bit31to0[14];
assign pri_macaddr_lower[15] = pri_macaddr_bit31to0[15];
assign pri_macaddr_lower[16] = pri_macaddr_bit31to0[16];
assign pri_macaddr_lower[17] = pri_macaddr_bit31to0[17];
assign pri_macaddr_lower[18] = pri_macaddr_bit31to0[18];
assign pri_macaddr_lower[19] = pri_macaddr_bit31to0[19];
assign pri_macaddr_lower[20] = pri_macaddr_bit31to0[20];
assign pri_macaddr_lower[21] = pri_macaddr_bit31to0[21];
assign pri_macaddr_lower[22] = pri_macaddr_bit31to0[22];
assign pri_macaddr_lower[23] = pri_macaddr_bit31to0[23];
assign pri_macaddr_lower[24] = pri_macaddr_bit31to0[24];
assign pri_macaddr_lower[25] = pri_macaddr_bit31to0[25];
assign pri_macaddr_lower[26] = pri_macaddr_bit31to0[26];
assign pri_macaddr_lower[27] = pri_macaddr_bit31to0[27];
assign pri_macaddr_lower[28] = pri_macaddr_bit31to0[28];
assign pri_macaddr_lower[29] = pri_macaddr_bit31to0[29];
assign pri_macaddr_lower[30] = pri_macaddr_bit31to0[30];
assign pri_macaddr_lower[31] = pri_macaddr_bit31to0[31];

assign pri_macaddr_1_upper[0] = pri_macaddr_bit47to32[0];
assign pri_macaddr_1_upper[1] = pri_macaddr_bit47to32[1];
assign pri_macaddr_1_upper[2] = pri_macaddr_bit47to32[2];
assign pri_macaddr_1_upper[3] = pri_macaddr_bit47to32[3];
assign pri_macaddr_1_upper[4] = pri_macaddr_bit47to32[4];
assign pri_macaddr_1_upper[5] = pri_macaddr_bit47to32[5];
assign pri_macaddr_1_upper[6] = pri_macaddr_bit47to32[6];
assign pri_macaddr_1_upper[7] = pri_macaddr_bit47to32[7];
assign pri_macaddr_1_upper[8] = pri_macaddr_bit47to32[8];
assign pri_macaddr_1_upper[9] = pri_macaddr_bit47to32[9];
assign pri_macaddr_1_upper[10] = pri_macaddr_bit47to32[10];
assign pri_macaddr_1_upper[11] = pri_macaddr_bit47to32[11];
assign pri_macaddr_1_upper[12] = pri_macaddr_bit47to32[12];
assign pri_macaddr_1_upper[13] = pri_macaddr_bit47to32[13];
assign pri_macaddr_1_upper[14] = pri_macaddr_bit47to32[14];
assign pri_macaddr_1_upper[15] = pri_macaddr_bit47to32[15];
assign pri_macaddr_1_upper[16] = 1'b0;
assign pri_macaddr_1_upper[17] = 1'b0;
assign pri_macaddr_1_upper[18] = 1'b0;
assign pri_macaddr_1_upper[19] = 1'b0;
assign pri_macaddr_1_upper[20] = 1'b0;
assign pri_macaddr_1_upper[21] = 1'b0;
assign pri_macaddr_1_upper[22] = 1'b0;
assign pri_macaddr_1_upper[23] = 1'b0;
assign pri_macaddr_1_upper[24] = 1'b0;
assign pri_macaddr_1_upper[25] = 1'b0;
assign pri_macaddr_1_upper[26] = 1'b0;
assign pri_macaddr_1_upper[27] = 1'b0;
assign pri_macaddr_1_upper[28] = 1'b0;
assign pri_macaddr_1_upper[29] = 1'b0;
assign pri_macaddr_1_upper[30] = 1'b0;
assign pri_macaddr_1_upper[31] = 1'b0;

assign mac_common_status[0] = wait_request_timeout;
assign mac_common_status[1] = 1'b0;
assign mac_common_status[2] = 1'b0;
assign mac_common_status[3] = 1'b0;
assign mac_common_status[4] = 1'b0;
assign mac_common_status[5] = 1'b0;
assign mac_common_status[6] = 1'b0;
assign mac_common_status[7] = 1'b0;
assign mac_common_status[8] = 1'b0;
assign mac_common_status[9] = 1'b0;
assign mac_common_status[10] = 1'b0;
assign mac_common_status[11] = 1'b0;
assign mac_common_status[12] = 1'b0;
assign mac_common_status[13] = 1'b0;
assign mac_common_status[14] = 1'b0;
assign mac_common_status[15] = 1'b0;
assign mac_common_status[16] = 1'b0;
assign mac_common_status[17] = 1'b0;
assign mac_common_status[18] = 1'b0;
assign mac_common_status[19] = 1'b0;
assign mac_common_status[20] = 1'b0;
assign mac_common_status[21] = 1'b0;
assign mac_common_status[22] = 1'b0;
assign mac_common_status[23] = 1'b0;
assign mac_common_status[24] = 1'b0;
assign mac_common_status[25] = 1'b0;
assign mac_common_status[26] = 1'b0;
assign mac_common_status[27] = 1'b0;
assign mac_common_status[28] = 1'b0;
assign mac_common_status[29] = 1'b0;
assign mac_common_status[30] = 1'b0;
assign mac_common_status[31] = 1'b0;

assign data_path_reset[0] = tx_data_path_reset;
assign data_path_reset[1] = 1'b0;
assign data_path_reset[2] = 1'b0;
assign data_path_reset[3] = 1'b0;
assign data_path_reset[4] = 1'b0;
assign data_path_reset[5] = 1'b0;
assign data_path_reset[6] = 1'b0;
assign data_path_reset[7] = 1'b0;
assign data_path_reset[8] = rx_data_path_reset;
assign data_path_reset[9] = 1'b0;
assign data_path_reset[10] = 1'b0;
assign data_path_reset[11] = 1'b0;
assign data_path_reset[12] = 1'b0;
assign data_path_reset[13] = 1'b0;
assign data_path_reset[14] = 1'b0;
assign data_path_reset[15] = 1'b0;
assign data_path_reset[16] = 1'b0;
assign data_path_reset[17] = 1'b0;
assign data_path_reset[18] = 1'b0;
assign data_path_reset[19] = 1'b0;
assign data_path_reset[20] = 1'b0;
assign data_path_reset[21] = 1'b0;
assign data_path_reset[22] = 1'b0;
assign data_path_reset[23] = 1'b0;
assign data_path_reset[24] = 1'b0;
assign data_path_reset[25] = 1'b0;
assign data_path_reset[26] = 1'b0;
assign data_path_reset[27] = 1'b0;
assign data_path_reset[28] = 1'b0;
assign data_path_reset[29] = 1'b0;
assign data_path_reset[30] = 1'b0;
assign data_path_reset[31] = 1'b0;

assign tx_pktctl[0] = tx_tsfr_en_n;
assign tx_pktctl[1] = 1'b0;
assign tx_pktctl[2] = 1'b0;
assign tx_pktctl[3] = 1'b0;
assign tx_pktctl[4] = 1'b0;
assign tx_pktctl[5] = 1'b0;
assign tx_pktctl[6] = 1'b0;
assign tx_pktctl[7] = 1'b0;
assign tx_pktctl[8] = 1'b0;
assign tx_pktctl[9] = 1'b0;
assign tx_pktctl[10] = 1'b0;
assign tx_pktctl[11] = 1'b0;
assign tx_pktctl[12] = 1'b0;
assign tx_pktctl[13] = 1'b0;
assign tx_pktctl[14] = 1'b0;
assign tx_pktctl[15] = 1'b0;
assign tx_pktctl[16] = 1'b0;
assign tx_pktctl[17] = 1'b0;
assign tx_pktctl[18] = 1'b0;
assign tx_pktctl[19] = 1'b0;
assign tx_pktctl[20] = 1'b0;
assign tx_pktctl[21] = 1'b0;
assign tx_pktctl[22] = 1'b0;
assign tx_pktctl[23] = 1'b0;
assign tx_pktctl[24] = 1'b0;
assign tx_pktctl[25] = 1'b0;
assign tx_pktctl[26] = 1'b0;
assign tx_pktctl[27] = 1'b0;
assign tx_pktctl[28] = 1'b0;
assign tx_pktctl[29] = 1'b0;
assign tx_pktctl[30] = 1'b0;
assign tx_pktctl[31] = 1'b0;

assign tx_pktsts[0] = tx_datafrm_tsfr_en_sts;
assign tx_pktsts[1] = 1'b0;
assign tx_pktsts[2] = 1'b0;
assign tx_pktsts[3] = 1'b0;
assign tx_pktsts[4] = 1'b0;
assign tx_pktsts[5] = 1'b0;
assign tx_pktsts[6] = 1'b0;
assign tx_pktsts[7] = 1'b0;
assign tx_pktsts[8] = tx_busy;
assign tx_pktsts[9] = 1'b0;
assign tx_pktsts[10] = 1'b0;
assign tx_pktsts[11] = 1'b0;
assign tx_pktsts[12] = tx_rst_sts;
assign tx_pktsts[13] = 1'b0;
assign tx_pktsts[14] = 1'b0;
assign tx_pktsts[15] = 1'b0;
assign tx_pktsts[16] = 1'b0;
assign tx_pktsts[17] = 1'b0;
assign tx_pktsts[18] = 1'b0;
assign tx_pktsts[19] = 1'b0;
assign tx_pktsts[20] = 1'b0;
assign tx_pktsts[21] = 1'b0;
assign tx_pktsts[22] = 1'b0;
assign tx_pktsts[23] = 1'b0;
assign tx_pktsts[24] = 1'b0;
assign tx_pktsts[25] = 1'b0;
assign tx_pktsts[26] = 1'b0;
assign tx_pktsts[27] = 1'b0;
assign tx_pktsts[28] = 1'b0;
assign tx_pktsts[29] = 1'b0;
assign tx_pktsts[30] = 1'b0;
assign tx_pktsts[31] = 1'b0;

assign tx_padctl[0] = tx_pad_insrt_en;
assign tx_padctl[1] = 1'b0;
assign tx_padctl[2] = 1'b0;
assign tx_padctl[3] = 1'b0;
assign tx_padctl[4] = 1'b0;
assign tx_padctl[5] = 1'b0;
assign tx_padctl[6] = 1'b0;
assign tx_padctl[7] = 1'b0;
assign tx_padctl[8] = 1'b0;
assign tx_padctl[9] = 1'b0;
assign tx_padctl[10] = 1'b0;
assign tx_padctl[11] = 1'b0;
assign tx_padctl[12] = 1'b0;
assign tx_padctl[13] = 1'b0;
assign tx_padctl[14] = 1'b0;
assign tx_padctl[15] = 1'b0;
assign tx_padctl[16] = 1'b0;
assign tx_padctl[17] = 1'b0;
assign tx_padctl[18] = 1'b0;
assign tx_padctl[19] = 1'b0;
assign tx_padctl[20] = 1'b0;
assign tx_padctl[21] = 1'b0;
assign tx_padctl[22] = 1'b0;
assign tx_padctl[23] = 1'b0;
assign tx_padctl[24] = 1'b0;
assign tx_padctl[25] = 1'b0;
assign tx_padctl[26] = 1'b0;
assign tx_padctl[27] = 1'b0;
assign tx_padctl[28] = 1'b0;
assign tx_padctl[29] = 1'b0;
assign tx_padctl[30] = 1'b0;
assign tx_padctl[31] = 1'b0;

assign tx_crcctl[0] = tx_crcctl_reserved;
assign tx_crcctl[1] = tx_crc_insrt_en;
assign tx_crcctl[2] = 1'b0;
assign tx_crcctl[3] = 1'b0;
assign tx_crcctl[4] = 1'b0;
assign tx_crcctl[5] = 1'b0;
assign tx_crcctl[6] = 1'b0;
assign tx_crcctl[7] = 1'b0;
assign tx_crcctl[8] = 1'b0;
assign tx_crcctl[9] = 1'b0;
assign tx_crcctl[10] = 1'b0;
assign tx_crcctl[11] = 1'b0;
assign tx_crcctl[12] = 1'b0;
assign tx_crcctl[13] = 1'b0;
assign tx_crcctl[14] = 1'b0;
assign tx_crcctl[15] = 1'b0;
assign tx_crcctl[16] = 1'b0;
assign tx_crcctl[17] = 1'b0;
assign tx_crcctl[18] = 1'b0;
assign tx_crcctl[19] = 1'b0;
assign tx_crcctl[20] = 1'b0;
assign tx_crcctl[21] = 1'b0;
assign tx_crcctl[22] = 1'b0;
assign tx_crcctl[23] = 1'b0;
assign tx_crcctl[24] = 1'b0;
assign tx_crcctl[25] = 1'b0;
assign tx_crcctl[26] = 1'b0;
assign tx_crcctl[27] = 1'b0;
assign tx_crcctl[28] = 1'b0;
assign tx_crcctl[29] = 1'b0;
assign tx_crcctl[30] = 1'b0;
assign tx_crcctl[31] = 1'b0;

assign tx_preambctl[0] = tx_preamb_passthru_en;
assign tx_preambctl[1] = 1'b0;
assign tx_preambctl[2] = 1'b0;
assign tx_preambctl[3] = 1'b0;
assign tx_preambctl[4] = 1'b0;
assign tx_preambctl[5] = 1'b0;
assign tx_preambctl[6] = 1'b0;
assign tx_preambctl[7] = 1'b0;
assign tx_preambctl[8] = 1'b0;
assign tx_preambctl[9] = 1'b0;
assign tx_preambctl[10] = 1'b0;
assign tx_preambctl[11] = 1'b0;
assign tx_preambctl[12] = 1'b0;
assign tx_preambctl[13] = 1'b0;
assign tx_preambctl[14] = 1'b0;
assign tx_preambctl[15] = 1'b0;
assign tx_preambctl[16] = 1'b0;
assign tx_preambctl[17] = 1'b0;
assign tx_preambctl[18] = 1'b0;
assign tx_preambctl[19] = 1'b0;
assign tx_preambctl[20] = 1'b0;
assign tx_preambctl[21] = 1'b0;
assign tx_preambctl[22] = 1'b0;
assign tx_preambctl[23] = 1'b0;
assign tx_preambctl[24] = 1'b0;
assign tx_preambctl[25] = 1'b0;
assign tx_preambctl[26] = 1'b0;
assign tx_preambctl[27] = 1'b0;
assign tx_preambctl[28] = 1'b0;
assign tx_preambctl[29] = 1'b0;
assign tx_preambctl[30] = 1'b0;
assign tx_preambctl[31] = 1'b0;

assign tx_sa_override[0] = tx_sa_override_en;
assign tx_sa_override[1] = 1'b0;
assign tx_sa_override[2] = 1'b0;
assign tx_sa_override[3] = 1'b0;
assign tx_sa_override[4] = 1'b0;
assign tx_sa_override[5] = 1'b0;
assign tx_sa_override[6] = 1'b0;
assign tx_sa_override[7] = 1'b0;
assign tx_sa_override[8] = 1'b0;
assign tx_sa_override[9] = 1'b0;
assign tx_sa_override[10] = 1'b0;
assign tx_sa_override[11] = 1'b0;
assign tx_sa_override[12] = 1'b0;
assign tx_sa_override[13] = 1'b0;
assign tx_sa_override[14] = 1'b0;
assign tx_sa_override[15] = 1'b0;
assign tx_sa_override[16] = 1'b0;
assign tx_sa_override[17] = 1'b0;
assign tx_sa_override[18] = 1'b0;
assign tx_sa_override[19] = 1'b0;
assign tx_sa_override[20] = 1'b0;
assign tx_sa_override[21] = 1'b0;
assign tx_sa_override[22] = 1'b0;
assign tx_sa_override[23] = 1'b0;
assign tx_sa_override[24] = 1'b0;
assign tx_sa_override[25] = 1'b0;
assign tx_sa_override[26] = 1'b0;
assign tx_sa_override[27] = 1'b0;
assign tx_sa_override[28] = 1'b0;
assign tx_sa_override[29] = 1'b0;
assign tx_sa_override[30] = 1'b0;
assign tx_sa_override[31] = 1'b0;

assign tx_frmctl[0] = tx_max_datafrmlen[0];
assign tx_frmctl[1] = tx_max_datafrmlen[1];
assign tx_frmctl[2] = tx_max_datafrmlen[2];
assign tx_frmctl[3] = tx_max_datafrmlen[3];
assign tx_frmctl[4] = tx_max_datafrmlen[4];
assign tx_frmctl[5] = tx_max_datafrmlen[5];
assign tx_frmctl[6] = tx_max_datafrmlen[6];
assign tx_frmctl[7] = tx_max_datafrmlen[7];
assign tx_frmctl[8] = tx_max_datafrmlen[8];
assign tx_frmctl[9] = tx_max_datafrmlen[9];
assign tx_frmctl[10] = tx_max_datafrmlen[10];
assign tx_frmctl[11] = tx_max_datafrmlen[11];
assign tx_frmctl[12] = tx_max_datafrmlen[12];
assign tx_frmctl[13] = tx_max_datafrmlen[13];
assign tx_frmctl[14] = tx_max_datafrmlen[14];
assign tx_frmctl[15] = tx_max_datafrmlen[15];
assign tx_frmctl[16] = 1'b0;
assign tx_frmctl[17] = 1'b0;
assign tx_frmctl[18] = 1'b0;
assign tx_frmctl[19] = 1'b0;
assign tx_frmctl[20] = 1'b0;
assign tx_frmctl[21] = 1'b0;
assign tx_frmctl[22] = 1'b0;
assign tx_frmctl[23] = 1'b0;
assign tx_frmctl[24] = 1'b0;
assign tx_frmctl[25] = 1'b0;
assign tx_frmctl[26] = 1'b0;
assign tx_frmctl[27] = 1'b0;
assign tx_frmctl[28] = 1'b0;
assign tx_frmctl[29] = 1'b0;
assign tx_frmctl[30] = 1'b0;
assign tx_frmctl[31] = 1'b0;

assign txvlandetection_dis[0] = txvlandet_dis;
assign txvlandetection_dis[1] = 1'b0;
assign txvlandetection_dis[2] = 1'b0;
assign txvlandetection_dis[3] = 1'b0;
assign txvlandetection_dis[4] = 1'b0;
assign txvlandetection_dis[5] = 1'b0;
assign txvlandetection_dis[6] = 1'b0;
assign txvlandetection_dis[7] = 1'b0;
assign txvlandetection_dis[8] = 1'b0;
assign txvlandetection_dis[9] = 1'b0;
assign txvlandetection_dis[10] = 1'b0;
assign txvlandetection_dis[11] = 1'b0;
assign txvlandetection_dis[12] = 1'b0;
assign txvlandetection_dis[13] = 1'b0;
assign txvlandetection_dis[14] = 1'b0;
assign txvlandetection_dis[15] = 1'b0;
assign txvlandetection_dis[16] = 1'b0;
assign txvlandetection_dis[17] = 1'b0;
assign txvlandetection_dis[18] = 1'b0;
assign txvlandetection_dis[19] = 1'b0;
assign txvlandetection_dis[20] = 1'b0;
assign txvlandetection_dis[21] = 1'b0;
assign txvlandetection_dis[22] = 1'b0;
assign txvlandetection_dis[23] = 1'b0;
assign txvlandetection_dis[24] = 1'b0;
assign txvlandetection_dis[25] = 1'b0;
assign txvlandetection_dis[26] = 1'b0;
assign txvlandetection_dis[27] = 1'b0;
assign txvlandetection_dis[28] = 1'b0;
assign txvlandetection_dis[29] = 1'b0;
assign txvlandetection_dis[30] = 1'b0;
assign txvlandetection_dis[31] = 1'b0;

assign tx_pipg_10g[0] = tx_pipg10g_dic[0];
assign tx_pipg_10g[1] = tx_pipg10g_dic[1];
assign tx_pipg_10g[2] = tx_pipg10g_dic[2];
assign tx_pipg_10g[3] = tx_pipg10g_dic[3];
assign tx_pipg_10g[4] = tx_pipg10g_dic[4];
assign tx_pipg_10g[5] = tx_pipg10g_dic[5];
assign tx_pipg_10g[6] = tx_pipg10g_dic[6];
assign tx_pipg_10g[7] = tx_pipg10g_dic[7];
assign tx_pipg_10g[8] = 1'b0;
assign tx_pipg_10g[9] = 1'b0;
assign tx_pipg_10g[10] = 1'b0;
assign tx_pipg_10g[11] = 1'b0;
assign tx_pipg_10g[12] = 1'b0;
assign tx_pipg_10g[13] = 1'b0;
assign tx_pipg_10g[14] = 1'b0;
assign tx_pipg_10g[15] = 1'b0;
assign tx_pipg_10g[16] = 1'b0;
assign tx_pipg_10g[17] = 1'b0;
assign tx_pipg_10g[18] = 1'b0;
assign tx_pipg_10g[19] = 1'b0;
assign tx_pipg_10g[20] = 1'b0;
assign tx_pipg_10g[21] = 1'b0;
assign tx_pipg_10g[22] = 1'b0;
assign tx_pipg_10g[23] = 1'b0;
assign tx_pipg_10g[24] = 1'b0;
assign tx_pipg_10g[25] = 1'b0;
assign tx_pipg_10g[26] = 1'b0;
assign tx_pipg_10g[27] = 1'b0;
assign tx_pipg_10g[28] = 1'b0;
assign tx_pipg_10g[29] = 1'b0;
assign tx_pipg_10g[30] = 1'b0;
assign tx_pipg_10g[31] = 1'b0;

assign tx_pipg_1g[0] = tx_pipg1g_fixed[0];
assign tx_pipg_1g[1] = tx_pipg1g_fixed[1];
assign tx_pipg_1g[2] = tx_pipg1g_fixed[2];
assign tx_pipg_1g[3] = tx_pipg1g_fixed[3];
assign tx_pipg_1g[4] = tx_pipg1g_fixed[4];
assign tx_pipg_1g[5] = tx_pipg1g_fixed[5];
assign tx_pipg_1g[6] = tx_pipg1g_fixed[6];
assign tx_pipg_1g[7] = tx_pipg1g_fixed[7];
assign tx_pipg_1g[8] = 1'b0;
assign tx_pipg_1g[9] = 1'b0;
assign tx_pipg_1g[10] = 1'b0;
assign tx_pipg_1g[11] = 1'b0;
assign tx_pipg_1g[12] = 1'b0;
assign tx_pipg_1g[13] = 1'b0;
assign tx_pipg_1g[14] = 1'b0;
assign tx_pipg_1g[15] = 1'b0;
assign tx_pipg_1g[16] = 1'b0;
assign tx_pipg_1g[17] = 1'b0;
assign tx_pipg_1g[18] = 1'b0;
assign tx_pipg_1g[19] = 1'b0;
assign tx_pipg_1g[20] = 1'b0;
assign tx_pipg_1g[21] = 1'b0;
assign tx_pipg_1g[22] = 1'b0;
assign tx_pipg_1g[23] = 1'b0;
assign tx_pipg_1g[24] = 1'b0;
assign tx_pipg_1g[25] = 1'b0;
assign tx_pipg_1g[26] = 1'b0;
assign tx_pipg_1g[27] = 1'b0;
assign tx_pipg_1g[28] = 1'b0;
assign tx_pipg_1g[29] = 1'b0;
assign tx_pipg_1g[30] = 1'b0;
assign tx_pipg_1g[31] = 1'b0;

assign tx_udf_stat_0[0] = tx_udf_errcnt_bit31to0[0];
assign tx_udf_stat_0[1] = tx_udf_errcnt_bit31to0[1];
assign tx_udf_stat_0[2] = tx_udf_errcnt_bit31to0[2];
assign tx_udf_stat_0[3] = tx_udf_errcnt_bit31to0[3];
assign tx_udf_stat_0[4] = tx_udf_errcnt_bit31to0[4];
assign tx_udf_stat_0[5] = tx_udf_errcnt_bit31to0[5];
assign tx_udf_stat_0[6] = tx_udf_errcnt_bit31to0[6];
assign tx_udf_stat_0[7] = tx_udf_errcnt_bit31to0[7];
assign tx_udf_stat_0[8] = tx_udf_errcnt_bit31to0[8];
assign tx_udf_stat_0[9] = tx_udf_errcnt_bit31to0[9];
assign tx_udf_stat_0[10] = tx_udf_errcnt_bit31to0[10];
assign tx_udf_stat_0[11] = tx_udf_errcnt_bit31to0[11];
assign tx_udf_stat_0[12] = tx_udf_errcnt_bit31to0[12];
assign tx_udf_stat_0[13] = tx_udf_errcnt_bit31to0[13];
assign tx_udf_stat_0[14] = tx_udf_errcnt_bit31to0[14];
assign tx_udf_stat_0[15] = tx_udf_errcnt_bit31to0[15];
assign tx_udf_stat_0[16] = tx_udf_errcnt_bit31to0[16];
assign tx_udf_stat_0[17] = tx_udf_errcnt_bit31to0[17];
assign tx_udf_stat_0[18] = tx_udf_errcnt_bit31to0[18];
assign tx_udf_stat_0[19] = tx_udf_errcnt_bit31to0[19];
assign tx_udf_stat_0[20] = tx_udf_errcnt_bit31to0[20];
assign tx_udf_stat_0[21] = tx_udf_errcnt_bit31to0[21];
assign tx_udf_stat_0[22] = tx_udf_errcnt_bit31to0[22];
assign tx_udf_stat_0[23] = tx_udf_errcnt_bit31to0[23];
assign tx_udf_stat_0[24] = tx_udf_errcnt_bit31to0[24];
assign tx_udf_stat_0[25] = tx_udf_errcnt_bit31to0[25];
assign tx_udf_stat_0[26] = tx_udf_errcnt_bit31to0[26];
assign tx_udf_stat_0[27] = tx_udf_errcnt_bit31to0[27];
assign tx_udf_stat_0[28] = tx_udf_errcnt_bit31to0[28];
assign tx_udf_stat_0[29] = tx_udf_errcnt_bit31to0[29];
assign tx_udf_stat_0[30] = tx_udf_errcnt_bit31to0[30];
assign tx_udf_stat_0[31] = tx_udf_errcnt_bit31to0[31];

assign tx_udf_stat_1[0] = tx_udf_errcnt_bit35to32[0];
assign tx_udf_stat_1[1] = tx_udf_errcnt_bit35to32[1];
assign tx_udf_stat_1[2] = tx_udf_errcnt_bit35to32[2];
assign tx_udf_stat_1[3] = tx_udf_errcnt_bit35to32[3];
assign tx_udf_stat_1[4] = 1'b0;
assign tx_udf_stat_1[5] = 1'b0;
assign tx_udf_stat_1[6] = 1'b0;
assign tx_udf_stat_1[7] = 1'b0;
assign tx_udf_stat_1[8] = 1'b0;
assign tx_udf_stat_1[9] = 1'b0;
assign tx_udf_stat_1[10] = 1'b0;
assign tx_udf_stat_1[11] = 1'b0;
assign tx_udf_stat_1[12] = 1'b0;
assign tx_udf_stat_1[13] = 1'b0;
assign tx_udf_stat_1[14] = 1'b0;
assign tx_udf_stat_1[15] = 1'b0;
assign tx_udf_stat_1[16] = 1'b0;
assign tx_udf_stat_1[17] = 1'b0;
assign tx_udf_stat_1[18] = 1'b0;
assign tx_udf_stat_1[19] = 1'b0;
assign tx_udf_stat_1[20] = 1'b0;
assign tx_udf_stat_1[21] = 1'b0;
assign tx_udf_stat_1[22] = 1'b0;
assign tx_udf_stat_1[23] = 1'b0;
assign tx_udf_stat_1[24] = 1'b0;
assign tx_udf_stat_1[25] = 1'b0;
assign tx_udf_stat_1[26] = 1'b0;
assign tx_udf_stat_1[27] = 1'b0;
assign tx_udf_stat_1[28] = 1'b0;
assign tx_udf_stat_1[29] = 1'b0;
assign tx_udf_stat_1[30] = 1'b0;
assign tx_udf_stat_1[31] = 1'b0;

assign tx_pausectl[0] = tx_pausefrm_xonxoff[0];
assign tx_pausectl[1] = tx_pausefrm_xonxoff[1];
assign tx_pausectl[2] = 1'b0;
assign tx_pausectl[3] = 1'b0;
assign tx_pausectl[4] = 1'b0;
assign tx_pausectl[5] = 1'b0;
assign tx_pausectl[6] = 1'b0;
assign tx_pausectl[7] = 1'b0;
assign tx_pausectl[8] = 1'b0;
assign tx_pausectl[9] = 1'b0;
assign tx_pausectl[10] = 1'b0;
assign tx_pausectl[11] = 1'b0;
assign tx_pausectl[12] = 1'b0;
assign tx_pausectl[13] = 1'b0;
assign tx_pausectl[14] = 1'b0;
assign tx_pausectl[15] = 1'b0;
assign tx_pausectl[16] = 1'b0;
assign tx_pausectl[17] = 1'b0;
assign tx_pausectl[18] = 1'b0;
assign tx_pausectl[19] = 1'b0;
assign tx_pausectl[20] = 1'b0;
assign tx_pausectl[21] = 1'b0;
assign tx_pausectl[22] = 1'b0;
assign tx_pausectl[23] = 1'b0;
assign tx_pausectl[24] = 1'b0;
assign tx_pausectl[25] = 1'b0;
assign tx_pausectl[26] = 1'b0;
assign tx_pausectl[27] = 1'b0;
assign tx_pausectl[28] = 1'b0;
assign tx_pausectl[29] = 1'b0;
assign tx_pausectl[30] = 1'b0;
assign tx_pausectl[31] = 1'b0;

assign tx_pausefrm_pq[0] = tx_pausefrm_pqt[0];
assign tx_pausefrm_pq[1] = tx_pausefrm_pqt[1];
assign tx_pausefrm_pq[2] = tx_pausefrm_pqt[2];
assign tx_pausefrm_pq[3] = tx_pausefrm_pqt[3];
assign tx_pausefrm_pq[4] = tx_pausefrm_pqt[4];
assign tx_pausefrm_pq[5] = tx_pausefrm_pqt[5];
assign tx_pausefrm_pq[6] = tx_pausefrm_pqt[6];
assign tx_pausefrm_pq[7] = tx_pausefrm_pqt[7];
assign tx_pausefrm_pq[8] = tx_pausefrm_pqt[8];
assign tx_pausefrm_pq[9] = tx_pausefrm_pqt[9];
assign tx_pausefrm_pq[10] = tx_pausefrm_pqt[10];
assign tx_pausefrm_pq[11] = tx_pausefrm_pqt[11];
assign tx_pausefrm_pq[12] = tx_pausefrm_pqt[12];
assign tx_pausefrm_pq[13] = tx_pausefrm_pqt[13];
assign tx_pausefrm_pq[14] = tx_pausefrm_pqt[14];
assign tx_pausefrm_pq[15] = tx_pausefrm_pqt[15];
assign tx_pausefrm_pq[16] = 1'b0;
assign tx_pausefrm_pq[17] = 1'b0;
assign tx_pausefrm_pq[18] = 1'b0;
assign tx_pausefrm_pq[19] = 1'b0;
assign tx_pausefrm_pq[20] = 1'b0;
assign tx_pausefrm_pq[21] = 1'b0;
assign tx_pausefrm_pq[22] = 1'b0;
assign tx_pausefrm_pq[23] = 1'b0;
assign tx_pausefrm_pq[24] = 1'b0;
assign tx_pausefrm_pq[25] = 1'b0;
assign tx_pausefrm_pq[26] = 1'b0;
assign tx_pausefrm_pq[27] = 1'b0;
assign tx_pausefrm_pq[28] = 1'b0;
assign tx_pausefrm_pq[29] = 1'b0;
assign tx_pausefrm_pq[30] = 1'b0;
assign tx_pausefrm_pq[31] = 1'b0;

assign tx_pausefrm_hqt[0] = tx_pausefrm_xoff_hqt[0];
assign tx_pausefrm_hqt[1] = tx_pausefrm_xoff_hqt[1];
assign tx_pausefrm_hqt[2] = tx_pausefrm_xoff_hqt[2];
assign tx_pausefrm_hqt[3] = tx_pausefrm_xoff_hqt[3];
assign tx_pausefrm_hqt[4] = tx_pausefrm_xoff_hqt[4];
assign tx_pausefrm_hqt[5] = tx_pausefrm_xoff_hqt[5];
assign tx_pausefrm_hqt[6] = tx_pausefrm_xoff_hqt[6];
assign tx_pausefrm_hqt[7] = tx_pausefrm_xoff_hqt[7];
assign tx_pausefrm_hqt[8] = tx_pausefrm_xoff_hqt[8];
assign tx_pausefrm_hqt[9] = tx_pausefrm_xoff_hqt[9];
assign tx_pausefrm_hqt[10] = tx_pausefrm_xoff_hqt[10];
assign tx_pausefrm_hqt[11] = tx_pausefrm_xoff_hqt[11];
assign tx_pausefrm_hqt[12] = tx_pausefrm_xoff_hqt[12];
assign tx_pausefrm_hqt[13] = tx_pausefrm_xoff_hqt[13];
assign tx_pausefrm_hqt[14] = tx_pausefrm_xoff_hqt[14];
assign tx_pausefrm_hqt[15] = tx_pausefrm_xoff_hqt[15];
assign tx_pausefrm_hqt[16] = 1'b0;
assign tx_pausefrm_hqt[17] = 1'b0;
assign tx_pausefrm_hqt[18] = 1'b0;
assign tx_pausefrm_hqt[19] = 1'b0;
assign tx_pausefrm_hqt[20] = 1'b0;
assign tx_pausefrm_hqt[21] = 1'b0;
assign tx_pausefrm_hqt[22] = 1'b0;
assign tx_pausefrm_hqt[23] = 1'b0;
assign tx_pausefrm_hqt[24] = 1'b0;
assign tx_pausefrm_hqt[25] = 1'b0;
assign tx_pausefrm_hqt[26] = 1'b0;
assign tx_pausefrm_hqt[27] = 1'b0;
assign tx_pausefrm_hqt[28] = 1'b0;
assign tx_pausefrm_hqt[29] = 1'b0;
assign tx_pausefrm_hqt[30] = 1'b0;
assign tx_pausefrm_hqt[31] = 1'b0;

assign tx_pausefrm_genctl[0] = tx_pausefrm_en;
assign tx_pausefrm_genctl[1] = tx_pausefrm_policy[0];
assign tx_pausefrm_genctl[2] = tx_pausefrm_policy[1];
assign tx_pausefrm_genctl[3] = 1'b0;
assign tx_pausefrm_genctl[4] = 1'b0;
assign tx_pausefrm_genctl[5] = 1'b0;
assign tx_pausefrm_genctl[6] = 1'b0;
assign tx_pausefrm_genctl[7] = 1'b0;
assign tx_pausefrm_genctl[8] = 1'b0;
assign tx_pausefrm_genctl[9] = 1'b0;
assign tx_pausefrm_genctl[10] = 1'b0;
assign tx_pausefrm_genctl[11] = 1'b0;
assign tx_pausefrm_genctl[12] = 1'b0;
assign tx_pausefrm_genctl[13] = 1'b0;
assign tx_pausefrm_genctl[14] = 1'b0;
assign tx_pausefrm_genctl[15] = 1'b0;
assign tx_pausefrm_genctl[16] = 1'b0;
assign tx_pausefrm_genctl[17] = 1'b0;
assign tx_pausefrm_genctl[18] = 1'b0;
assign tx_pausefrm_genctl[19] = 1'b0;
assign tx_pausefrm_genctl[20] = 1'b0;
assign tx_pausefrm_genctl[21] = 1'b0;
assign tx_pausefrm_genctl[22] = 1'b0;
assign tx_pausefrm_genctl[23] = 1'b0;
assign tx_pausefrm_genctl[24] = 1'b0;
assign tx_pausefrm_genctl[25] = 1'b0;
assign tx_pausefrm_genctl[26] = 1'b0;
assign tx_pausefrm_genctl[27] = 1'b0;
assign tx_pausefrm_genctl[28] = 1'b0;
assign tx_pausefrm_genctl[29] = 1'b0;
assign tx_pausefrm_genctl[30] = 1'b0;
assign tx_pausefrm_genctl[31] = 1'b0;

assign tx_pfcfrm_en[0] = tx_pfcfrm_en0;
assign tx_pfcfrm_en[1] = tx_pfcfrm_en1;
assign tx_pfcfrm_en[2] = tx_pfcfrm_en2;
assign tx_pfcfrm_en[3] = tx_pfcfrm_en3;
assign tx_pfcfrm_en[4] = tx_pfcfrm_en4;
assign tx_pfcfrm_en[5] = tx_pfcfrm_en5;
assign tx_pfcfrm_en[6] = tx_pfcfrm_en6;
assign tx_pfcfrm_en[7] = tx_pfcfrm_en7;
assign tx_pfcfrm_en[8] = 1'b0;
assign tx_pfcfrm_en[9] = 1'b0;
assign tx_pfcfrm_en[10] = 1'b0;
assign tx_pfcfrm_en[11] = 1'b0;
assign tx_pfcfrm_en[12] = 1'b0;
assign tx_pfcfrm_en[13] = 1'b0;
assign tx_pfcfrm_en[14] = 1'b0;
assign tx_pfcfrm_en[15] = 1'b0;
assign tx_pfcfrm_en[16] = 1'b0;
assign tx_pfcfrm_en[17] = 1'b0;
assign tx_pfcfrm_en[18] = 1'b0;
assign tx_pfcfrm_en[19] = 1'b0;
assign tx_pfcfrm_en[20] = 1'b0;
assign tx_pfcfrm_en[21] = 1'b0;
assign tx_pfcfrm_en[22] = 1'b0;
assign tx_pfcfrm_en[23] = 1'b0;
assign tx_pfcfrm_en[24] = 1'b0;
assign tx_pfcfrm_en[25] = 1'b0;
assign tx_pfcfrm_en[26] = 1'b0;
assign tx_pfcfrm_en[27] = 1'b0;
assign tx_pfcfrm_en[28] = 1'b0;
assign tx_pfcfrm_en[29] = 1'b0;
assign tx_pfcfrm_en[30] = 1'b0;
assign tx_pfcfrm_en[31] = 1'b0;

assign tx_pfcfrm_pq0[0] = tx_pfcfrm_pqt0[0];
assign tx_pfcfrm_pq0[1] = tx_pfcfrm_pqt0[1];
assign tx_pfcfrm_pq0[2] = tx_pfcfrm_pqt0[2];
assign tx_pfcfrm_pq0[3] = tx_pfcfrm_pqt0[3];
assign tx_pfcfrm_pq0[4] = tx_pfcfrm_pqt0[4];
assign tx_pfcfrm_pq0[5] = tx_pfcfrm_pqt0[5];
assign tx_pfcfrm_pq0[6] = tx_pfcfrm_pqt0[6];
assign tx_pfcfrm_pq0[7] = tx_pfcfrm_pqt0[7];
assign tx_pfcfrm_pq0[8] = tx_pfcfrm_pqt0[8];
assign tx_pfcfrm_pq0[9] = tx_pfcfrm_pqt0[9];
assign tx_pfcfrm_pq0[10] = tx_pfcfrm_pqt0[10];
assign tx_pfcfrm_pq0[11] = tx_pfcfrm_pqt0[11];
assign tx_pfcfrm_pq0[12] = tx_pfcfrm_pqt0[12];
assign tx_pfcfrm_pq0[13] = tx_pfcfrm_pqt0[13];
assign tx_pfcfrm_pq0[14] = tx_pfcfrm_pqt0[14];
assign tx_pfcfrm_pq0[15] = tx_pfcfrm_pqt0[15];
assign tx_pfcfrm_pq0[16] = 1'b0;
assign tx_pfcfrm_pq0[17] = 1'b0;
assign tx_pfcfrm_pq0[18] = 1'b0;
assign tx_pfcfrm_pq0[19] = 1'b0;
assign tx_pfcfrm_pq0[20] = 1'b0;
assign tx_pfcfrm_pq0[21] = 1'b0;
assign tx_pfcfrm_pq0[22] = 1'b0;
assign tx_pfcfrm_pq0[23] = 1'b0;
assign tx_pfcfrm_pq0[24] = 1'b0;
assign tx_pfcfrm_pq0[25] = 1'b0;
assign tx_pfcfrm_pq0[26] = 1'b0;
assign tx_pfcfrm_pq0[27] = 1'b0;
assign tx_pfcfrm_pq0[28] = 1'b0;
assign tx_pfcfrm_pq0[29] = 1'b0;
assign tx_pfcfrm_pq0[30] = 1'b0;
assign tx_pfcfrm_pq0[31] = 1'b0;

assign tx_pfcfrm_pq1[0] = tx_pfcfrm_pqt1[0];
assign tx_pfcfrm_pq1[1] = tx_pfcfrm_pqt1[1];
assign tx_pfcfrm_pq1[2] = tx_pfcfrm_pqt1[2];
assign tx_pfcfrm_pq1[3] = tx_pfcfrm_pqt1[3];
assign tx_pfcfrm_pq1[4] = tx_pfcfrm_pqt1[4];
assign tx_pfcfrm_pq1[5] = tx_pfcfrm_pqt1[5];
assign tx_pfcfrm_pq1[6] = tx_pfcfrm_pqt1[6];
assign tx_pfcfrm_pq1[7] = tx_pfcfrm_pqt1[7];
assign tx_pfcfrm_pq1[8] = tx_pfcfrm_pqt1[8];
assign tx_pfcfrm_pq1[9] = tx_pfcfrm_pqt1[9];
assign tx_pfcfrm_pq1[10] = tx_pfcfrm_pqt1[10];
assign tx_pfcfrm_pq1[11] = tx_pfcfrm_pqt1[11];
assign tx_pfcfrm_pq1[12] = tx_pfcfrm_pqt1[12];
assign tx_pfcfrm_pq1[13] = tx_pfcfrm_pqt1[13];
assign tx_pfcfrm_pq1[14] = tx_pfcfrm_pqt1[14];
assign tx_pfcfrm_pq1[15] = tx_pfcfrm_pqt1[15];
assign tx_pfcfrm_pq1[16] = 1'b0;
assign tx_pfcfrm_pq1[17] = 1'b0;
assign tx_pfcfrm_pq1[18] = 1'b0;
assign tx_pfcfrm_pq1[19] = 1'b0;
assign tx_pfcfrm_pq1[20] = 1'b0;
assign tx_pfcfrm_pq1[21] = 1'b0;
assign tx_pfcfrm_pq1[22] = 1'b0;
assign tx_pfcfrm_pq1[23] = 1'b0;
assign tx_pfcfrm_pq1[24] = 1'b0;
assign tx_pfcfrm_pq1[25] = 1'b0;
assign tx_pfcfrm_pq1[26] = 1'b0;
assign tx_pfcfrm_pq1[27] = 1'b0;
assign tx_pfcfrm_pq1[28] = 1'b0;
assign tx_pfcfrm_pq1[29] = 1'b0;
assign tx_pfcfrm_pq1[30] = 1'b0;
assign tx_pfcfrm_pq1[31] = 1'b0;

assign tx_pfcfrm_pq2[0] = tx_pfcfrm_pqt2[0];
assign tx_pfcfrm_pq2[1] = tx_pfcfrm_pqt2[1];
assign tx_pfcfrm_pq2[2] = tx_pfcfrm_pqt2[2];
assign tx_pfcfrm_pq2[3] = tx_pfcfrm_pqt2[3];
assign tx_pfcfrm_pq2[4] = tx_pfcfrm_pqt2[4];
assign tx_pfcfrm_pq2[5] = tx_pfcfrm_pqt2[5];
assign tx_pfcfrm_pq2[6] = tx_pfcfrm_pqt2[6];
assign tx_pfcfrm_pq2[7] = tx_pfcfrm_pqt2[7];
assign tx_pfcfrm_pq2[8] = tx_pfcfrm_pqt2[8];
assign tx_pfcfrm_pq2[9] = tx_pfcfrm_pqt2[9];
assign tx_pfcfrm_pq2[10] = tx_pfcfrm_pqt2[10];
assign tx_pfcfrm_pq2[11] = tx_pfcfrm_pqt2[11];
assign tx_pfcfrm_pq2[12] = tx_pfcfrm_pqt2[12];
assign tx_pfcfrm_pq2[13] = tx_pfcfrm_pqt2[13];
assign tx_pfcfrm_pq2[14] = tx_pfcfrm_pqt2[14];
assign tx_pfcfrm_pq2[15] = tx_pfcfrm_pqt2[15];
assign tx_pfcfrm_pq2[16] = 1'b0;
assign tx_pfcfrm_pq2[17] = 1'b0;
assign tx_pfcfrm_pq2[18] = 1'b0;
assign tx_pfcfrm_pq2[19] = 1'b0;
assign tx_pfcfrm_pq2[20] = 1'b0;
assign tx_pfcfrm_pq2[21] = 1'b0;
assign tx_pfcfrm_pq2[22] = 1'b0;
assign tx_pfcfrm_pq2[23] = 1'b0;
assign tx_pfcfrm_pq2[24] = 1'b0;
assign tx_pfcfrm_pq2[25] = 1'b0;
assign tx_pfcfrm_pq2[26] = 1'b0;
assign tx_pfcfrm_pq2[27] = 1'b0;
assign tx_pfcfrm_pq2[28] = 1'b0;
assign tx_pfcfrm_pq2[29] = 1'b0;
assign tx_pfcfrm_pq2[30] = 1'b0;
assign tx_pfcfrm_pq2[31] = 1'b0;

assign tx_pfcfrm_pq3[0] = tx_pfcfrm_pqt3[0];
assign tx_pfcfrm_pq3[1] = tx_pfcfrm_pqt3[1];
assign tx_pfcfrm_pq3[2] = tx_pfcfrm_pqt3[2];
assign tx_pfcfrm_pq3[3] = tx_pfcfrm_pqt3[3];
assign tx_pfcfrm_pq3[4] = tx_pfcfrm_pqt3[4];
assign tx_pfcfrm_pq3[5] = tx_pfcfrm_pqt3[5];
assign tx_pfcfrm_pq3[6] = tx_pfcfrm_pqt3[6];
assign tx_pfcfrm_pq3[7] = tx_pfcfrm_pqt3[7];
assign tx_pfcfrm_pq3[8] = tx_pfcfrm_pqt3[8];
assign tx_pfcfrm_pq3[9] = tx_pfcfrm_pqt3[9];
assign tx_pfcfrm_pq3[10] = tx_pfcfrm_pqt3[10];
assign tx_pfcfrm_pq3[11] = tx_pfcfrm_pqt3[11];
assign tx_pfcfrm_pq3[12] = tx_pfcfrm_pqt3[12];
assign tx_pfcfrm_pq3[13] = tx_pfcfrm_pqt3[13];
assign tx_pfcfrm_pq3[14] = tx_pfcfrm_pqt3[14];
assign tx_pfcfrm_pq3[15] = tx_pfcfrm_pqt3[15];
assign tx_pfcfrm_pq3[16] = 1'b0;
assign tx_pfcfrm_pq3[17] = 1'b0;
assign tx_pfcfrm_pq3[18] = 1'b0;
assign tx_pfcfrm_pq3[19] = 1'b0;
assign tx_pfcfrm_pq3[20] = 1'b0;
assign tx_pfcfrm_pq3[21] = 1'b0;
assign tx_pfcfrm_pq3[22] = 1'b0;
assign tx_pfcfrm_pq3[23] = 1'b0;
assign tx_pfcfrm_pq3[24] = 1'b0;
assign tx_pfcfrm_pq3[25] = 1'b0;
assign tx_pfcfrm_pq3[26] = 1'b0;
assign tx_pfcfrm_pq3[27] = 1'b0;
assign tx_pfcfrm_pq3[28] = 1'b0;
assign tx_pfcfrm_pq3[29] = 1'b0;
assign tx_pfcfrm_pq3[30] = 1'b0;
assign tx_pfcfrm_pq3[31] = 1'b0;

assign tx_pfcfrm_pq4[0] = tx_pfcfrm_pqt4[0];
assign tx_pfcfrm_pq4[1] = tx_pfcfrm_pqt4[1];
assign tx_pfcfrm_pq4[2] = tx_pfcfrm_pqt4[2];
assign tx_pfcfrm_pq4[3] = tx_pfcfrm_pqt4[3];
assign tx_pfcfrm_pq4[4] = tx_pfcfrm_pqt4[4];
assign tx_pfcfrm_pq4[5] = tx_pfcfrm_pqt4[5];
assign tx_pfcfrm_pq4[6] = tx_pfcfrm_pqt4[6];
assign tx_pfcfrm_pq4[7] = tx_pfcfrm_pqt4[7];
assign tx_pfcfrm_pq4[8] = tx_pfcfrm_pqt4[8];
assign tx_pfcfrm_pq4[9] = tx_pfcfrm_pqt4[9];
assign tx_pfcfrm_pq4[10] = tx_pfcfrm_pqt4[10];
assign tx_pfcfrm_pq4[11] = tx_pfcfrm_pqt4[11];
assign tx_pfcfrm_pq4[12] = tx_pfcfrm_pqt4[12];
assign tx_pfcfrm_pq4[13] = tx_pfcfrm_pqt4[13];
assign tx_pfcfrm_pq4[14] = tx_pfcfrm_pqt4[14];
assign tx_pfcfrm_pq4[15] = tx_pfcfrm_pqt4[15];
assign tx_pfcfrm_pq4[16] = 1'b0;
assign tx_pfcfrm_pq4[17] = 1'b0;
assign tx_pfcfrm_pq4[18] = 1'b0;
assign tx_pfcfrm_pq4[19] = 1'b0;
assign tx_pfcfrm_pq4[20] = 1'b0;
assign tx_pfcfrm_pq4[21] = 1'b0;
assign tx_pfcfrm_pq4[22] = 1'b0;
assign tx_pfcfrm_pq4[23] = 1'b0;
assign tx_pfcfrm_pq4[24] = 1'b0;
assign tx_pfcfrm_pq4[25] = 1'b0;
assign tx_pfcfrm_pq4[26] = 1'b0;
assign tx_pfcfrm_pq4[27] = 1'b0;
assign tx_pfcfrm_pq4[28] = 1'b0;
assign tx_pfcfrm_pq4[29] = 1'b0;
assign tx_pfcfrm_pq4[30] = 1'b0;
assign tx_pfcfrm_pq4[31] = 1'b0;

assign tx_pfcfrm_pq5[0] = tx_pfcfrm_pqt5[0];
assign tx_pfcfrm_pq5[1] = tx_pfcfrm_pqt5[1];
assign tx_pfcfrm_pq5[2] = tx_pfcfrm_pqt5[2];
assign tx_pfcfrm_pq5[3] = tx_pfcfrm_pqt5[3];
assign tx_pfcfrm_pq5[4] = tx_pfcfrm_pqt5[4];
assign tx_pfcfrm_pq5[5] = tx_pfcfrm_pqt5[5];
assign tx_pfcfrm_pq5[6] = tx_pfcfrm_pqt5[6];
assign tx_pfcfrm_pq5[7] = tx_pfcfrm_pqt5[7];
assign tx_pfcfrm_pq5[8] = tx_pfcfrm_pqt5[8];
assign tx_pfcfrm_pq5[9] = tx_pfcfrm_pqt5[9];
assign tx_pfcfrm_pq5[10] = tx_pfcfrm_pqt5[10];
assign tx_pfcfrm_pq5[11] = tx_pfcfrm_pqt5[11];
assign tx_pfcfrm_pq5[12] = tx_pfcfrm_pqt5[12];
assign tx_pfcfrm_pq5[13] = tx_pfcfrm_pqt5[13];
assign tx_pfcfrm_pq5[14] = tx_pfcfrm_pqt5[14];
assign tx_pfcfrm_pq5[15] = tx_pfcfrm_pqt5[15];
assign tx_pfcfrm_pq5[16] = 1'b0;
assign tx_pfcfrm_pq5[17] = 1'b0;
assign tx_pfcfrm_pq5[18] = 1'b0;
assign tx_pfcfrm_pq5[19] = 1'b0;
assign tx_pfcfrm_pq5[20] = 1'b0;
assign tx_pfcfrm_pq5[21] = 1'b0;
assign tx_pfcfrm_pq5[22] = 1'b0;
assign tx_pfcfrm_pq5[23] = 1'b0;
assign tx_pfcfrm_pq5[24] = 1'b0;
assign tx_pfcfrm_pq5[25] = 1'b0;
assign tx_pfcfrm_pq5[26] = 1'b0;
assign tx_pfcfrm_pq5[27] = 1'b0;
assign tx_pfcfrm_pq5[28] = 1'b0;
assign tx_pfcfrm_pq5[29] = 1'b0;
assign tx_pfcfrm_pq5[30] = 1'b0;
assign tx_pfcfrm_pq5[31] = 1'b0;

assign tx_pfcfrm_pq6[0] = tx_pfcfrm_pqt6[0];
assign tx_pfcfrm_pq6[1] = tx_pfcfrm_pqt6[1];
assign tx_pfcfrm_pq6[2] = tx_pfcfrm_pqt6[2];
assign tx_pfcfrm_pq6[3] = tx_pfcfrm_pqt6[3];
assign tx_pfcfrm_pq6[4] = tx_pfcfrm_pqt6[4];
assign tx_pfcfrm_pq6[5] = tx_pfcfrm_pqt6[5];
assign tx_pfcfrm_pq6[6] = tx_pfcfrm_pqt6[6];
assign tx_pfcfrm_pq6[7] = tx_pfcfrm_pqt6[7];
assign tx_pfcfrm_pq6[8] = tx_pfcfrm_pqt6[8];
assign tx_pfcfrm_pq6[9] = tx_pfcfrm_pqt6[9];
assign tx_pfcfrm_pq6[10] = tx_pfcfrm_pqt6[10];
assign tx_pfcfrm_pq6[11] = tx_pfcfrm_pqt6[11];
assign tx_pfcfrm_pq6[12] = tx_pfcfrm_pqt6[12];
assign tx_pfcfrm_pq6[13] = tx_pfcfrm_pqt6[13];
assign tx_pfcfrm_pq6[14] = tx_pfcfrm_pqt6[14];
assign tx_pfcfrm_pq6[15] = tx_pfcfrm_pqt6[15];
assign tx_pfcfrm_pq6[16] = 1'b0;
assign tx_pfcfrm_pq6[17] = 1'b0;
assign tx_pfcfrm_pq6[18] = 1'b0;
assign tx_pfcfrm_pq6[19] = 1'b0;
assign tx_pfcfrm_pq6[20] = 1'b0;
assign tx_pfcfrm_pq6[21] = 1'b0;
assign tx_pfcfrm_pq6[22] = 1'b0;
assign tx_pfcfrm_pq6[23] = 1'b0;
assign tx_pfcfrm_pq6[24] = 1'b0;
assign tx_pfcfrm_pq6[25] = 1'b0;
assign tx_pfcfrm_pq6[26] = 1'b0;
assign tx_pfcfrm_pq6[27] = 1'b0;
assign tx_pfcfrm_pq6[28] = 1'b0;
assign tx_pfcfrm_pq6[29] = 1'b0;
assign tx_pfcfrm_pq6[30] = 1'b0;
assign tx_pfcfrm_pq6[31] = 1'b0;

assign tx_pfcfrm_pq7[0] = tx_pfcfrm_pqt7[0];
assign tx_pfcfrm_pq7[1] = tx_pfcfrm_pqt7[1];
assign tx_pfcfrm_pq7[2] = tx_pfcfrm_pqt7[2];
assign tx_pfcfrm_pq7[3] = tx_pfcfrm_pqt7[3];
assign tx_pfcfrm_pq7[4] = tx_pfcfrm_pqt7[4];
assign tx_pfcfrm_pq7[5] = tx_pfcfrm_pqt7[5];
assign tx_pfcfrm_pq7[6] = tx_pfcfrm_pqt7[6];
assign tx_pfcfrm_pq7[7] = tx_pfcfrm_pqt7[7];
assign tx_pfcfrm_pq7[8] = tx_pfcfrm_pqt7[8];
assign tx_pfcfrm_pq7[9] = tx_pfcfrm_pqt7[9];
assign tx_pfcfrm_pq7[10] = tx_pfcfrm_pqt7[10];
assign tx_pfcfrm_pq7[11] = tx_pfcfrm_pqt7[11];
assign tx_pfcfrm_pq7[12] = tx_pfcfrm_pqt7[12];
assign tx_pfcfrm_pq7[13] = tx_pfcfrm_pqt7[13];
assign tx_pfcfrm_pq7[14] = tx_pfcfrm_pqt7[14];
assign tx_pfcfrm_pq7[15] = tx_pfcfrm_pqt7[15];
assign tx_pfcfrm_pq7[16] = 1'b0;
assign tx_pfcfrm_pq7[17] = 1'b0;
assign tx_pfcfrm_pq7[18] = 1'b0;
assign tx_pfcfrm_pq7[19] = 1'b0;
assign tx_pfcfrm_pq7[20] = 1'b0;
assign tx_pfcfrm_pq7[21] = 1'b0;
assign tx_pfcfrm_pq7[22] = 1'b0;
assign tx_pfcfrm_pq7[23] = 1'b0;
assign tx_pfcfrm_pq7[24] = 1'b0;
assign tx_pfcfrm_pq7[25] = 1'b0;
assign tx_pfcfrm_pq7[26] = 1'b0;
assign tx_pfcfrm_pq7[27] = 1'b0;
assign tx_pfcfrm_pq7[28] = 1'b0;
assign tx_pfcfrm_pq7[29] = 1'b0;
assign tx_pfcfrm_pq7[30] = 1'b0;
assign tx_pfcfrm_pq7[31] = 1'b0;

assign tx_pfcfrm_hq0[0] = tx_xoff_hqt0[0];
assign tx_pfcfrm_hq0[1] = tx_xoff_hqt0[1];
assign tx_pfcfrm_hq0[2] = tx_xoff_hqt0[2];
assign tx_pfcfrm_hq0[3] = tx_xoff_hqt0[3];
assign tx_pfcfrm_hq0[4] = tx_xoff_hqt0[4];
assign tx_pfcfrm_hq0[5] = tx_xoff_hqt0[5];
assign tx_pfcfrm_hq0[6] = tx_xoff_hqt0[6];
assign tx_pfcfrm_hq0[7] = tx_xoff_hqt0[7];
assign tx_pfcfrm_hq0[8] = tx_xoff_hqt0[8];
assign tx_pfcfrm_hq0[9] = tx_xoff_hqt0[9];
assign tx_pfcfrm_hq0[10] = tx_xoff_hqt0[10];
assign tx_pfcfrm_hq0[11] = tx_xoff_hqt0[11];
assign tx_pfcfrm_hq0[12] = tx_xoff_hqt0[12];
assign tx_pfcfrm_hq0[13] = tx_xoff_hqt0[13];
assign tx_pfcfrm_hq0[14] = tx_xoff_hqt0[14];
assign tx_pfcfrm_hq0[15] = tx_xoff_hqt0[15];
assign tx_pfcfrm_hq0[16] = 1'b0;
assign tx_pfcfrm_hq0[17] = 1'b0;
assign tx_pfcfrm_hq0[18] = 1'b0;
assign tx_pfcfrm_hq0[19] = 1'b0;
assign tx_pfcfrm_hq0[20] = 1'b0;
assign tx_pfcfrm_hq0[21] = 1'b0;
assign tx_pfcfrm_hq0[22] = 1'b0;
assign tx_pfcfrm_hq0[23] = 1'b0;
assign tx_pfcfrm_hq0[24] = 1'b0;
assign tx_pfcfrm_hq0[25] = 1'b0;
assign tx_pfcfrm_hq0[26] = 1'b0;
assign tx_pfcfrm_hq0[27] = 1'b0;
assign tx_pfcfrm_hq0[28] = 1'b0;
assign tx_pfcfrm_hq0[29] = 1'b0;
assign tx_pfcfrm_hq0[30] = 1'b0;
assign tx_pfcfrm_hq0[31] = 1'b0;

assign tx_pfcfrm_hq1[0] = tx_xoff_hqt1[0];
assign tx_pfcfrm_hq1[1] = tx_xoff_hqt1[1];
assign tx_pfcfrm_hq1[2] = tx_xoff_hqt1[2];
assign tx_pfcfrm_hq1[3] = tx_xoff_hqt1[3];
assign tx_pfcfrm_hq1[4] = tx_xoff_hqt1[4];
assign tx_pfcfrm_hq1[5] = tx_xoff_hqt1[5];
assign tx_pfcfrm_hq1[6] = tx_xoff_hqt1[6];
assign tx_pfcfrm_hq1[7] = tx_xoff_hqt1[7];
assign tx_pfcfrm_hq1[8] = tx_xoff_hqt1[8];
assign tx_pfcfrm_hq1[9] = tx_xoff_hqt1[9];
assign tx_pfcfrm_hq1[10] = tx_xoff_hqt1[10];
assign tx_pfcfrm_hq1[11] = tx_xoff_hqt1[11];
assign tx_pfcfrm_hq1[12] = tx_xoff_hqt1[12];
assign tx_pfcfrm_hq1[13] = tx_xoff_hqt1[13];
assign tx_pfcfrm_hq1[14] = tx_xoff_hqt1[14];
assign tx_pfcfrm_hq1[15] = tx_xoff_hqt1[15];
assign tx_pfcfrm_hq1[16] = 1'b0;
assign tx_pfcfrm_hq1[17] = 1'b0;
assign tx_pfcfrm_hq1[18] = 1'b0;
assign tx_pfcfrm_hq1[19] = 1'b0;
assign tx_pfcfrm_hq1[20] = 1'b0;
assign tx_pfcfrm_hq1[21] = 1'b0;
assign tx_pfcfrm_hq1[22] = 1'b0;
assign tx_pfcfrm_hq1[23] = 1'b0;
assign tx_pfcfrm_hq1[24] = 1'b0;
assign tx_pfcfrm_hq1[25] = 1'b0;
assign tx_pfcfrm_hq1[26] = 1'b0;
assign tx_pfcfrm_hq1[27] = 1'b0;
assign tx_pfcfrm_hq1[28] = 1'b0;
assign tx_pfcfrm_hq1[29] = 1'b0;
assign tx_pfcfrm_hq1[30] = 1'b0;
assign tx_pfcfrm_hq1[31] = 1'b0;

assign tx_pfcfrm_hq2[0] = tx_xoff_hqt2[0];
assign tx_pfcfrm_hq2[1] = tx_xoff_hqt2[1];
assign tx_pfcfrm_hq2[2] = tx_xoff_hqt2[2];
assign tx_pfcfrm_hq2[3] = tx_xoff_hqt2[3];
assign tx_pfcfrm_hq2[4] = tx_xoff_hqt2[4];
assign tx_pfcfrm_hq2[5] = tx_xoff_hqt2[5];
assign tx_pfcfrm_hq2[6] = tx_xoff_hqt2[6];
assign tx_pfcfrm_hq2[7] = tx_xoff_hqt2[7];
assign tx_pfcfrm_hq2[8] = tx_xoff_hqt2[8];
assign tx_pfcfrm_hq2[9] = tx_xoff_hqt2[9];
assign tx_pfcfrm_hq2[10] = tx_xoff_hqt2[10];
assign tx_pfcfrm_hq2[11] = tx_xoff_hqt2[11];
assign tx_pfcfrm_hq2[12] = tx_xoff_hqt2[12];
assign tx_pfcfrm_hq2[13] = tx_xoff_hqt2[13];
assign tx_pfcfrm_hq2[14] = tx_xoff_hqt2[14];
assign tx_pfcfrm_hq2[15] = tx_xoff_hqt2[15];
assign tx_pfcfrm_hq2[16] = 1'b0;
assign tx_pfcfrm_hq2[17] = 1'b0;
assign tx_pfcfrm_hq2[18] = 1'b0;
assign tx_pfcfrm_hq2[19] = 1'b0;
assign tx_pfcfrm_hq2[20] = 1'b0;
assign tx_pfcfrm_hq2[21] = 1'b0;
assign tx_pfcfrm_hq2[22] = 1'b0;
assign tx_pfcfrm_hq2[23] = 1'b0;
assign tx_pfcfrm_hq2[24] = 1'b0;
assign tx_pfcfrm_hq2[25] = 1'b0;
assign tx_pfcfrm_hq2[26] = 1'b0;
assign tx_pfcfrm_hq2[27] = 1'b0;
assign tx_pfcfrm_hq2[28] = 1'b0;
assign tx_pfcfrm_hq2[29] = 1'b0;
assign tx_pfcfrm_hq2[30] = 1'b0;
assign tx_pfcfrm_hq2[31] = 1'b0;

assign tx_pfcfrm_hq3[0] = tx_xoff_hqt3[0];
assign tx_pfcfrm_hq3[1] = tx_xoff_hqt3[1];
assign tx_pfcfrm_hq3[2] = tx_xoff_hqt3[2];
assign tx_pfcfrm_hq3[3] = tx_xoff_hqt3[3];
assign tx_pfcfrm_hq3[4] = tx_xoff_hqt3[4];
assign tx_pfcfrm_hq3[5] = tx_xoff_hqt3[5];
assign tx_pfcfrm_hq3[6] = tx_xoff_hqt3[6];
assign tx_pfcfrm_hq3[7] = tx_xoff_hqt3[7];
assign tx_pfcfrm_hq3[8] = tx_xoff_hqt3[8];
assign tx_pfcfrm_hq3[9] = tx_xoff_hqt3[9];
assign tx_pfcfrm_hq3[10] = tx_xoff_hqt3[10];
assign tx_pfcfrm_hq3[11] = tx_xoff_hqt3[11];
assign tx_pfcfrm_hq3[12] = tx_xoff_hqt3[12];
assign tx_pfcfrm_hq3[13] = tx_xoff_hqt3[13];
assign tx_pfcfrm_hq3[14] = tx_xoff_hqt3[14];
assign tx_pfcfrm_hq3[15] = tx_xoff_hqt3[15];
assign tx_pfcfrm_hq3[16] = 1'b0;
assign tx_pfcfrm_hq3[17] = 1'b0;
assign tx_pfcfrm_hq3[18] = 1'b0;
assign tx_pfcfrm_hq3[19] = 1'b0;
assign tx_pfcfrm_hq3[20] = 1'b0;
assign tx_pfcfrm_hq3[21] = 1'b0;
assign tx_pfcfrm_hq3[22] = 1'b0;
assign tx_pfcfrm_hq3[23] = 1'b0;
assign tx_pfcfrm_hq3[24] = 1'b0;
assign tx_pfcfrm_hq3[25] = 1'b0;
assign tx_pfcfrm_hq3[26] = 1'b0;
assign tx_pfcfrm_hq3[27] = 1'b0;
assign tx_pfcfrm_hq3[28] = 1'b0;
assign tx_pfcfrm_hq3[29] = 1'b0;
assign tx_pfcfrm_hq3[30] = 1'b0;
assign tx_pfcfrm_hq3[31] = 1'b0;

assign tx_pfcfrm_hq4[0] = tx_xoff_hqt4[0];
assign tx_pfcfrm_hq4[1] = tx_xoff_hqt4[1];
assign tx_pfcfrm_hq4[2] = tx_xoff_hqt4[2];
assign tx_pfcfrm_hq4[3] = tx_xoff_hqt4[3];
assign tx_pfcfrm_hq4[4] = tx_xoff_hqt4[4];
assign tx_pfcfrm_hq4[5] = tx_xoff_hqt4[5];
assign tx_pfcfrm_hq4[6] = tx_xoff_hqt4[6];
assign tx_pfcfrm_hq4[7] = tx_xoff_hqt4[7];
assign tx_pfcfrm_hq4[8] = tx_xoff_hqt4[8];
assign tx_pfcfrm_hq4[9] = tx_xoff_hqt4[9];
assign tx_pfcfrm_hq4[10] = tx_xoff_hqt4[10];
assign tx_pfcfrm_hq4[11] = tx_xoff_hqt4[11];
assign tx_pfcfrm_hq4[12] = tx_xoff_hqt4[12];
assign tx_pfcfrm_hq4[13] = tx_xoff_hqt4[13];
assign tx_pfcfrm_hq4[14] = tx_xoff_hqt4[14];
assign tx_pfcfrm_hq4[15] = tx_xoff_hqt4[15];
assign tx_pfcfrm_hq4[16] = 1'b0;
assign tx_pfcfrm_hq4[17] = 1'b0;
assign tx_pfcfrm_hq4[18] = 1'b0;
assign tx_pfcfrm_hq4[19] = 1'b0;
assign tx_pfcfrm_hq4[20] = 1'b0;
assign tx_pfcfrm_hq4[21] = 1'b0;
assign tx_pfcfrm_hq4[22] = 1'b0;
assign tx_pfcfrm_hq4[23] = 1'b0;
assign tx_pfcfrm_hq4[24] = 1'b0;
assign tx_pfcfrm_hq4[25] = 1'b0;
assign tx_pfcfrm_hq4[26] = 1'b0;
assign tx_pfcfrm_hq4[27] = 1'b0;
assign tx_pfcfrm_hq4[28] = 1'b0;
assign tx_pfcfrm_hq4[29] = 1'b0;
assign tx_pfcfrm_hq4[30] = 1'b0;
assign tx_pfcfrm_hq4[31] = 1'b0;

assign tx_pfcfrm_hq5[0] = tx_xoff_hqt5[0];
assign tx_pfcfrm_hq5[1] = tx_xoff_hqt5[1];
assign tx_pfcfrm_hq5[2] = tx_xoff_hqt5[2];
assign tx_pfcfrm_hq5[3] = tx_xoff_hqt5[3];
assign tx_pfcfrm_hq5[4] = tx_xoff_hqt5[4];
assign tx_pfcfrm_hq5[5] = tx_xoff_hqt5[5];
assign tx_pfcfrm_hq5[6] = tx_xoff_hqt5[6];
assign tx_pfcfrm_hq5[7] = tx_xoff_hqt5[7];
assign tx_pfcfrm_hq5[8] = tx_xoff_hqt5[8];
assign tx_pfcfrm_hq5[9] = tx_xoff_hqt5[9];
assign tx_pfcfrm_hq5[10] = tx_xoff_hqt5[10];
assign tx_pfcfrm_hq5[11] = tx_xoff_hqt5[11];
assign tx_pfcfrm_hq5[12] = tx_xoff_hqt5[12];
assign tx_pfcfrm_hq5[13] = tx_xoff_hqt5[13];
assign tx_pfcfrm_hq5[14] = tx_xoff_hqt5[14];
assign tx_pfcfrm_hq5[15] = tx_xoff_hqt5[15];
assign tx_pfcfrm_hq5[16] = 1'b0;
assign tx_pfcfrm_hq5[17] = 1'b0;
assign tx_pfcfrm_hq5[18] = 1'b0;
assign tx_pfcfrm_hq5[19] = 1'b0;
assign tx_pfcfrm_hq5[20] = 1'b0;
assign tx_pfcfrm_hq5[21] = 1'b0;
assign tx_pfcfrm_hq5[22] = 1'b0;
assign tx_pfcfrm_hq5[23] = 1'b0;
assign tx_pfcfrm_hq5[24] = 1'b0;
assign tx_pfcfrm_hq5[25] = 1'b0;
assign tx_pfcfrm_hq5[26] = 1'b0;
assign tx_pfcfrm_hq5[27] = 1'b0;
assign tx_pfcfrm_hq5[28] = 1'b0;
assign tx_pfcfrm_hq5[29] = 1'b0;
assign tx_pfcfrm_hq5[30] = 1'b0;
assign tx_pfcfrm_hq5[31] = 1'b0;

assign tx_pfcfrm_hq6[0] = tx_xoff_hqt6[0];
assign tx_pfcfrm_hq6[1] = tx_xoff_hqt6[1];
assign tx_pfcfrm_hq6[2] = tx_xoff_hqt6[2];
assign tx_pfcfrm_hq6[3] = tx_xoff_hqt6[3];
assign tx_pfcfrm_hq6[4] = tx_xoff_hqt6[4];
assign tx_pfcfrm_hq6[5] = tx_xoff_hqt6[5];
assign tx_pfcfrm_hq6[6] = tx_xoff_hqt6[6];
assign tx_pfcfrm_hq6[7] = tx_xoff_hqt6[7];
assign tx_pfcfrm_hq6[8] = tx_xoff_hqt6[8];
assign tx_pfcfrm_hq6[9] = tx_xoff_hqt6[9];
assign tx_pfcfrm_hq6[10] = tx_xoff_hqt6[10];
assign tx_pfcfrm_hq6[11] = tx_xoff_hqt6[11];
assign tx_pfcfrm_hq6[12] = tx_xoff_hqt6[12];
assign tx_pfcfrm_hq6[13] = tx_xoff_hqt6[13];
assign tx_pfcfrm_hq6[14] = tx_xoff_hqt6[14];
assign tx_pfcfrm_hq6[15] = tx_xoff_hqt6[15];
assign tx_pfcfrm_hq6[16] = 1'b0;
assign tx_pfcfrm_hq6[17] = 1'b0;
assign tx_pfcfrm_hq6[18] = 1'b0;
assign tx_pfcfrm_hq6[19] = 1'b0;
assign tx_pfcfrm_hq6[20] = 1'b0;
assign tx_pfcfrm_hq6[21] = 1'b0;
assign tx_pfcfrm_hq6[22] = 1'b0;
assign tx_pfcfrm_hq6[23] = 1'b0;
assign tx_pfcfrm_hq6[24] = 1'b0;
assign tx_pfcfrm_hq6[25] = 1'b0;
assign tx_pfcfrm_hq6[26] = 1'b0;
assign tx_pfcfrm_hq6[27] = 1'b0;
assign tx_pfcfrm_hq6[28] = 1'b0;
assign tx_pfcfrm_hq6[29] = 1'b0;
assign tx_pfcfrm_hq6[30] = 1'b0;
assign tx_pfcfrm_hq6[31] = 1'b0;

assign tx_pfcfrm_hq7[0] = tx_xoff_hqt7[0];
assign tx_pfcfrm_hq7[1] = tx_xoff_hqt7[1];
assign tx_pfcfrm_hq7[2] = tx_xoff_hqt7[2];
assign tx_pfcfrm_hq7[3] = tx_xoff_hqt7[3];
assign tx_pfcfrm_hq7[4] = tx_xoff_hqt7[4];
assign tx_pfcfrm_hq7[5] = tx_xoff_hqt7[5];
assign tx_pfcfrm_hq7[6] = tx_xoff_hqt7[6];
assign tx_pfcfrm_hq7[7] = tx_xoff_hqt7[7];
assign tx_pfcfrm_hq7[8] = tx_xoff_hqt7[8];
assign tx_pfcfrm_hq7[9] = tx_xoff_hqt7[9];
assign tx_pfcfrm_hq7[10] = tx_xoff_hqt7[10];
assign tx_pfcfrm_hq7[11] = tx_xoff_hqt7[11];
assign tx_pfcfrm_hq7[12] = tx_xoff_hqt7[12];
assign tx_pfcfrm_hq7[13] = tx_xoff_hqt7[13];
assign tx_pfcfrm_hq7[14] = tx_xoff_hqt7[14];
assign tx_pfcfrm_hq7[15] = tx_xoff_hqt7[15];
assign tx_pfcfrm_hq7[16] = 1'b0;
assign tx_pfcfrm_hq7[17] = 1'b0;
assign tx_pfcfrm_hq7[18] = 1'b0;
assign tx_pfcfrm_hq7[19] = 1'b0;
assign tx_pfcfrm_hq7[20] = 1'b0;
assign tx_pfcfrm_hq7[21] = 1'b0;
assign tx_pfcfrm_hq7[22] = 1'b0;
assign tx_pfcfrm_hq7[23] = 1'b0;
assign tx_pfcfrm_hq7[24] = 1'b0;
assign tx_pfcfrm_hq7[25] = 1'b0;
assign tx_pfcfrm_hq7[26] = 1'b0;
assign tx_pfcfrm_hq7[27] = 1'b0;
assign tx_pfcfrm_hq7[28] = 1'b0;
assign tx_pfcfrm_hq7[29] = 1'b0;
assign tx_pfcfrm_hq7[30] = 1'b0;
assign tx_pfcfrm_hq7[31] = 1'b0;

assign tx_unidirectional_feature[0] = tx_unidirectional_en;
assign tx_unidirectional_feature[1] = tx_unidirectional_remote_fault_dis;
assign tx_unidirectional_feature[2] = tx_unidirectional_force_remote_fault;
assign tx_unidirectional_feature[3] = 1'b0;
assign tx_unidirectional_feature[4] = 1'b0;
assign tx_unidirectional_feature[5] = 1'b0;
assign tx_unidirectional_feature[6] = 1'b0;
assign tx_unidirectional_feature[7] = 1'b0;
assign tx_unidirectional_feature[8] = 1'b0;
assign tx_unidirectional_feature[9] = 1'b0;
assign tx_unidirectional_feature[10] = 1'b0;
assign tx_unidirectional_feature[11] = 1'b0;
assign tx_unidirectional_feature[12] = 1'b0;
assign tx_unidirectional_feature[13] = 1'b0;
assign tx_unidirectional_feature[14] = 1'b0;
assign tx_unidirectional_feature[15] = 1'b0;
assign tx_unidirectional_feature[16] = 1'b0;
assign tx_unidirectional_feature[17] = 1'b0;
assign tx_unidirectional_feature[18] = 1'b0;
assign tx_unidirectional_feature[19] = 1'b0;
assign tx_unidirectional_feature[20] = 1'b0;
assign tx_unidirectional_feature[21] = 1'b0;
assign tx_unidirectional_feature[22] = 1'b0;
assign tx_unidirectional_feature[23] = 1'b0;
assign tx_unidirectional_feature[24] = 1'b0;
assign tx_unidirectional_feature[25] = 1'b0;
assign tx_unidirectional_feature[26] = 1'b0;
assign tx_unidirectional_feature[27] = 1'b0;
assign tx_unidirectional_feature[28] = 1'b0;
assign tx_unidirectional_feature[29] = 1'b0;
assign tx_unidirectional_feature[30] = 1'b0;
assign tx_unidirectional_feature[31] = 1'b0;

assign rx_pktctl[0] = rx_tsfr_en_n;
assign rx_pktctl[1] = 1'b0;
assign rx_pktctl[2] = 1'b0;
assign rx_pktctl[3] = 1'b0;
assign rx_pktctl[4] = 1'b0;
assign rx_pktctl[5] = 1'b0;
assign rx_pktctl[6] = 1'b0;
assign rx_pktctl[7] = 1'b0;
assign rx_pktctl[8] = 1'b0;
assign rx_pktctl[9] = 1'b0;
assign rx_pktctl[10] = 1'b0;
assign rx_pktctl[11] = 1'b0;
assign rx_pktctl[12] = 1'b0;
assign rx_pktctl[13] = 1'b0;
assign rx_pktctl[14] = 1'b0;
assign rx_pktctl[15] = 1'b0;
assign rx_pktctl[16] = 1'b0;
assign rx_pktctl[17] = 1'b0;
assign rx_pktctl[18] = 1'b0;
assign rx_pktctl[19] = 1'b0;
assign rx_pktctl[20] = 1'b0;
assign rx_pktctl[21] = 1'b0;
assign rx_pktctl[22] = 1'b0;
assign rx_pktctl[23] = 1'b0;
assign rx_pktctl[24] = 1'b0;
assign rx_pktctl[25] = 1'b0;
assign rx_pktctl[26] = 1'b0;
assign rx_pktctl[27] = 1'b0;
assign rx_pktctl[28] = 1'b0;
assign rx_pktctl[29] = 1'b0;
assign rx_pktctl[30] = 1'b0;
assign rx_pktctl[31] = 1'b0;

assign rx_pktsts[0] = rx_tsfr_sts;
assign rx_pktsts[1] = 1'b0;
assign rx_pktsts[2] = 1'b0;
assign rx_pktsts[3] = 1'b0;
assign rx_pktsts[4] = 1'b0;
assign rx_pktsts[5] = 1'b0;
assign rx_pktsts[6] = 1'b0;
assign rx_pktsts[7] = 1'b0;
assign rx_pktsts[8] = rx_busy;
assign rx_pktsts[9] = 1'b0;
assign rx_pktsts[10] = 1'b0;
assign rx_pktsts[11] = 1'b0;
assign rx_pktsts[12] = rx_rst_sts;
assign rx_pktsts[13] = 1'b0;
assign rx_pktsts[14] = 1'b0;
assign rx_pktsts[15] = 1'b0;
assign rx_pktsts[16] = 1'b0;
assign rx_pktsts[17] = 1'b0;
assign rx_pktsts[18] = 1'b0;
assign rx_pktsts[19] = 1'b0;
assign rx_pktsts[20] = 1'b0;
assign rx_pktsts[21] = 1'b0;
assign rx_pktsts[22] = 1'b0;
assign rx_pktsts[23] = 1'b0;
assign rx_pktsts[24] = 1'b0;
assign rx_pktsts[25] = 1'b0;
assign rx_pktsts[26] = 1'b0;
assign rx_pktsts[27] = 1'b0;
assign rx_pktsts[28] = 1'b0;
assign rx_pktsts[29] = 1'b0;
assign rx_pktsts[30] = 1'b0;
assign rx_pktsts[31] = 1'b0;

assign rx_crcpad_ctl[0] = rx_crcpad_rem[0];
assign rx_crcpad_ctl[1] = rx_crcpad_rem[1];
assign rx_crcpad_ctl[2] = 1'b0;
assign rx_crcpad_ctl[3] = 1'b0;
assign rx_crcpad_ctl[4] = 1'b0;
assign rx_crcpad_ctl[5] = 1'b0;
assign rx_crcpad_ctl[6] = 1'b0;
assign rx_crcpad_ctl[7] = 1'b0;
assign rx_crcpad_ctl[8] = 1'b0;
assign rx_crcpad_ctl[9] = 1'b0;
assign rx_crcpad_ctl[10] = 1'b0;
assign rx_crcpad_ctl[11] = 1'b0;
assign rx_crcpad_ctl[12] = 1'b0;
assign rx_crcpad_ctl[13] = 1'b0;
assign rx_crcpad_ctl[14] = 1'b0;
assign rx_crcpad_ctl[15] = 1'b0;
assign rx_crcpad_ctl[16] = 1'b0;
assign rx_crcpad_ctl[17] = 1'b0;
assign rx_crcpad_ctl[18] = 1'b0;
assign rx_crcpad_ctl[19] = 1'b0;
assign rx_crcpad_ctl[20] = 1'b0;
assign rx_crcpad_ctl[21] = 1'b0;
assign rx_crcpad_ctl[22] = 1'b0;
assign rx_crcpad_ctl[23] = 1'b0;
assign rx_crcpad_ctl[24] = 1'b0;
assign rx_crcpad_ctl[25] = 1'b0;
assign rx_crcpad_ctl[26] = 1'b0;
assign rx_crcpad_ctl[27] = 1'b0;
assign rx_crcpad_ctl[28] = 1'b0;
assign rx_crcpad_ctl[29] = 1'b0;
assign rx_crcpad_ctl[30] = 1'b0;
assign rx_crcpad_ctl[31] = 1'b0;

assign rx_crc_ctl[0] = rx_crc_reserved;
assign rx_crc_ctl[1] = rx_crc_chk;
assign rx_crc_ctl[2] = 1'b0;
assign rx_crc_ctl[3] = 1'b0;
assign rx_crc_ctl[4] = 1'b0;
assign rx_crc_ctl[5] = 1'b0;
assign rx_crc_ctl[6] = 1'b0;
assign rx_crc_ctl[7] = 1'b0;
assign rx_crc_ctl[8] = 1'b0;
assign rx_crc_ctl[9] = 1'b0;
assign rx_crc_ctl[10] = 1'b0;
assign rx_crc_ctl[11] = 1'b0;
assign rx_crc_ctl[12] = 1'b0;
assign rx_crc_ctl[13] = 1'b0;
assign rx_crc_ctl[14] = 1'b0;
assign rx_crc_ctl[15] = 1'b0;
assign rx_crc_ctl[16] = 1'b0;
assign rx_crc_ctl[17] = 1'b0;
assign rx_crc_ctl[18] = 1'b0;
assign rx_crc_ctl[19] = 1'b0;
assign rx_crc_ctl[20] = 1'b0;
assign rx_crc_ctl[21] = 1'b0;
assign rx_crc_ctl[22] = 1'b0;
assign rx_crc_ctl[23] = 1'b0;
assign rx_crc_ctl[24] = 1'b0;
assign rx_crc_ctl[25] = 1'b0;
assign rx_crc_ctl[26] = 1'b0;
assign rx_crc_ctl[27] = 1'b0;
assign rx_crc_ctl[28] = 1'b0;
assign rx_crc_ctl[29] = 1'b0;
assign rx_crc_ctl[30] = 1'b0;
assign rx_crc_ctl[31] = 1'b0;

assign rx_preamb_fwd_ctl[0] = rx_preambctl_fwd;
assign rx_preamb_fwd_ctl[1] = 1'b0;
assign rx_preamb_fwd_ctl[2] = 1'b0;
assign rx_preamb_fwd_ctl[3] = 1'b0;
assign rx_preamb_fwd_ctl[4] = 1'b0;
assign rx_preamb_fwd_ctl[5] = 1'b0;
assign rx_preamb_fwd_ctl[6] = 1'b0;
assign rx_preamb_fwd_ctl[7] = 1'b0;
assign rx_preamb_fwd_ctl[8] = 1'b0;
assign rx_preamb_fwd_ctl[9] = 1'b0;
assign rx_preamb_fwd_ctl[10] = 1'b0;
assign rx_preamb_fwd_ctl[11] = 1'b0;
assign rx_preamb_fwd_ctl[12] = 1'b0;
assign rx_preamb_fwd_ctl[13] = 1'b0;
assign rx_preamb_fwd_ctl[14] = 1'b0;
assign rx_preamb_fwd_ctl[15] = 1'b0;
assign rx_preamb_fwd_ctl[16] = 1'b0;
assign rx_preamb_fwd_ctl[17] = 1'b0;
assign rx_preamb_fwd_ctl[18] = 1'b0;
assign rx_preamb_fwd_ctl[19] = 1'b0;
assign rx_preamb_fwd_ctl[20] = 1'b0;
assign rx_preamb_fwd_ctl[21] = 1'b0;
assign rx_preamb_fwd_ctl[22] = 1'b0;
assign rx_preamb_fwd_ctl[23] = 1'b0;
assign rx_preamb_fwd_ctl[24] = 1'b0;
assign rx_preamb_fwd_ctl[25] = 1'b0;
assign rx_preamb_fwd_ctl[26] = 1'b0;
assign rx_preamb_fwd_ctl[27] = 1'b0;
assign rx_preamb_fwd_ctl[28] = 1'b0;
assign rx_preamb_fwd_ctl[29] = 1'b0;
assign rx_preamb_fwd_ctl[30] = 1'b0;
assign rx_preamb_fwd_ctl[31] = 1'b0;

assign rx_preamb_pt[0] = rx_preamb_passthru_en;
assign rx_preamb_pt[1] = 1'b0;
assign rx_preamb_pt[2] = 1'b0;
assign rx_preamb_pt[3] = 1'b0;
assign rx_preamb_pt[4] = 1'b0;
assign rx_preamb_pt[5] = 1'b0;
assign rx_preamb_pt[6] = 1'b0;
assign rx_preamb_pt[7] = 1'b0;
assign rx_preamb_pt[8] = 1'b0;
assign rx_preamb_pt[9] = 1'b0;
assign rx_preamb_pt[10] = 1'b0;
assign rx_preamb_pt[11] = 1'b0;
assign rx_preamb_pt[12] = 1'b0;
assign rx_preamb_pt[13] = 1'b0;
assign rx_preamb_pt[14] = 1'b0;
assign rx_preamb_pt[15] = 1'b0;
assign rx_preamb_pt[16] = 1'b0;
assign rx_preamb_pt[17] = 1'b0;
assign rx_preamb_pt[18] = 1'b0;
assign rx_preamb_pt[19] = 1'b0;
assign rx_preamb_pt[20] = 1'b0;
assign rx_preamb_pt[21] = 1'b0;
assign rx_preamb_pt[22] = 1'b0;
assign rx_preamb_pt[23] = 1'b0;
assign rx_preamb_pt[24] = 1'b0;
assign rx_preamb_pt[25] = 1'b0;
assign rx_preamb_pt[26] = 1'b0;
assign rx_preamb_pt[27] = 1'b0;
assign rx_preamb_pt[28] = 1'b0;
assign rx_preamb_pt[29] = 1'b0;
assign rx_preamb_pt[30] = 1'b0;
assign rx_preamb_pt[31] = 1'b0;

assign rx_frm_ctl[0] = rx_allucast_en;
assign rx_frm_ctl[1] = rx_allmcast_en;
assign rx_frm_ctl[2] = 1'b0;
assign rx_frm_ctl[3] = rx_fwd_ctlfrm;
assign rx_frm_ctl[4] = rx_fwd_pausefrm;
assign rx_frm_ctl[5] = rx_ignore_pausefrm;
assign rx_frm_ctl[6] = 1'b0;
assign rx_frm_ctl[7] = 1'b0;
assign rx_frm_ctl[8] = 1'b0;
assign rx_frm_ctl[9] = 1'b0;
assign rx_frm_ctl[10] = 1'b0;
assign rx_frm_ctl[11] = 1'b0;
assign rx_frm_ctl[12] = 1'b0;
assign rx_frm_ctl[13] = 1'b0;
assign rx_frm_ctl[14] = 1'b0;
assign rx_frm_ctl[15] = 1'b0;
assign rx_frm_ctl[16] = rx_suppaddr_en0;
assign rx_frm_ctl[17] = rx_suppaddr_en1;
assign rx_frm_ctl[18] = rx_suppaddr_en2;
assign rx_frm_ctl[19] = rx_suppaddr_en3;
assign rx_frm_ctl[20] = 1'b0;
assign rx_frm_ctl[21] = 1'b0;
assign rx_frm_ctl[22] = 1'b0;
assign rx_frm_ctl[23] = 1'b0;
assign rx_frm_ctl[24] = 1'b0;
assign rx_frm_ctl[25] = 1'b0;
assign rx_frm_ctl[26] = 1'b0;
assign rx_frm_ctl[27] = 1'b0;
assign rx_frm_ctl[28] = 1'b0;
assign rx_frm_ctl[29] = 1'b0;
assign rx_frm_ctl[30] = 1'b0;
assign rx_frm_ctl[31] = 1'b0;

assign rx_frm_ctl_maxlen[0] = rx_max_datafrmlen[0];
assign rx_frm_ctl_maxlen[1] = rx_max_datafrmlen[1];
assign rx_frm_ctl_maxlen[2] = rx_max_datafrmlen[2];
assign rx_frm_ctl_maxlen[3] = rx_max_datafrmlen[3];
assign rx_frm_ctl_maxlen[4] = rx_max_datafrmlen[4];
assign rx_frm_ctl_maxlen[5] = rx_max_datafrmlen[5];
assign rx_frm_ctl_maxlen[6] = rx_max_datafrmlen[6];
assign rx_frm_ctl_maxlen[7] = rx_max_datafrmlen[7];
assign rx_frm_ctl_maxlen[8] = rx_max_datafrmlen[8];
assign rx_frm_ctl_maxlen[9] = rx_max_datafrmlen[9];
assign rx_frm_ctl_maxlen[10] = rx_max_datafrmlen[10];
assign rx_frm_ctl_maxlen[11] = rx_max_datafrmlen[11];
assign rx_frm_ctl_maxlen[12] = rx_max_datafrmlen[12];
assign rx_frm_ctl_maxlen[13] = rx_max_datafrmlen[13];
assign rx_frm_ctl_maxlen[14] = rx_max_datafrmlen[14];
assign rx_frm_ctl_maxlen[15] = rx_max_datafrmlen[15];
assign rx_frm_ctl_maxlen[16] = 1'b0;
assign rx_frm_ctl_maxlen[17] = 1'b0;
assign rx_frm_ctl_maxlen[18] = 1'b0;
assign rx_frm_ctl_maxlen[19] = 1'b0;
assign rx_frm_ctl_maxlen[20] = 1'b0;
assign rx_frm_ctl_maxlen[21] = 1'b0;
assign rx_frm_ctl_maxlen[22] = 1'b0;
assign rx_frm_ctl_maxlen[23] = 1'b0;
assign rx_frm_ctl_maxlen[24] = 1'b0;
assign rx_frm_ctl_maxlen[25] = 1'b0;
assign rx_frm_ctl_maxlen[26] = 1'b0;
assign rx_frm_ctl_maxlen[27] = 1'b0;
assign rx_frm_ctl_maxlen[28] = 1'b0;
assign rx_frm_ctl_maxlen[29] = 1'b0;
assign rx_frm_ctl_maxlen[30] = 1'b0;
assign rx_frm_ctl_maxlen[31] = 1'b0;

assign rxvlandetection_dis[0] = rxvlandet_dis;
assign rxvlandetection_dis[1] = 1'b0;
assign rxvlandetection_dis[2] = 1'b0;
assign rxvlandetection_dis[3] = 1'b0;
assign rxvlandetection_dis[4] = 1'b0;
assign rxvlandetection_dis[5] = 1'b0;
assign rxvlandetection_dis[6] = 1'b0;
assign rxvlandetection_dis[7] = 1'b0;
assign rxvlandetection_dis[8] = 1'b0;
assign rxvlandetection_dis[9] = 1'b0;
assign rxvlandetection_dis[10] = 1'b0;
assign rxvlandetection_dis[11] = 1'b0;
assign rxvlandetection_dis[12] = 1'b0;
assign rxvlandetection_dis[13] = 1'b0;
assign rxvlandetection_dis[14] = 1'b0;
assign rxvlandetection_dis[15] = 1'b0;
assign rxvlandetection_dis[16] = 1'b0;
assign rxvlandetection_dis[17] = 1'b0;
assign rxvlandetection_dis[18] = 1'b0;
assign rxvlandetection_dis[19] = 1'b0;
assign rxvlandetection_dis[20] = 1'b0;
assign rxvlandetection_dis[21] = 1'b0;
assign rxvlandetection_dis[22] = 1'b0;
assign rxvlandetection_dis[23] = 1'b0;
assign rxvlandetection_dis[24] = 1'b0;
assign rxvlandetection_dis[25] = 1'b0;
assign rxvlandetection_dis[26] = 1'b0;
assign rxvlandetection_dis[27] = 1'b0;
assign rxvlandetection_dis[28] = 1'b0;
assign rxvlandetection_dis[29] = 1'b0;
assign rxvlandetection_dis[30] = 1'b0;
assign rxvlandetection_dis[31] = 1'b0;

assign rx_supp_macaddr_lower_0[0] = rx_supp_macaddr_bit31to0_0[0];
assign rx_supp_macaddr_lower_0[1] = rx_supp_macaddr_bit31to0_0[1];
assign rx_supp_macaddr_lower_0[2] = rx_supp_macaddr_bit31to0_0[2];
assign rx_supp_macaddr_lower_0[3] = rx_supp_macaddr_bit31to0_0[3];
assign rx_supp_macaddr_lower_0[4] = rx_supp_macaddr_bit31to0_0[4];
assign rx_supp_macaddr_lower_0[5] = rx_supp_macaddr_bit31to0_0[5];
assign rx_supp_macaddr_lower_0[6] = rx_supp_macaddr_bit31to0_0[6];
assign rx_supp_macaddr_lower_0[7] = rx_supp_macaddr_bit31to0_0[7];
assign rx_supp_macaddr_lower_0[8] = rx_supp_macaddr_bit31to0_0[8];
assign rx_supp_macaddr_lower_0[9] = rx_supp_macaddr_bit31to0_0[9];
assign rx_supp_macaddr_lower_0[10] = rx_supp_macaddr_bit31to0_0[10];
assign rx_supp_macaddr_lower_0[11] = rx_supp_macaddr_bit31to0_0[11];
assign rx_supp_macaddr_lower_0[12] = rx_supp_macaddr_bit31to0_0[12];
assign rx_supp_macaddr_lower_0[13] = rx_supp_macaddr_bit31to0_0[13];
assign rx_supp_macaddr_lower_0[14] = rx_supp_macaddr_bit31to0_0[14];
assign rx_supp_macaddr_lower_0[15] = rx_supp_macaddr_bit31to0_0[15];
assign rx_supp_macaddr_lower_0[16] = rx_supp_macaddr_bit31to0_0[16];
assign rx_supp_macaddr_lower_0[17] = rx_supp_macaddr_bit31to0_0[17];
assign rx_supp_macaddr_lower_0[18] = rx_supp_macaddr_bit31to0_0[18];
assign rx_supp_macaddr_lower_0[19] = rx_supp_macaddr_bit31to0_0[19];
assign rx_supp_macaddr_lower_0[20] = rx_supp_macaddr_bit31to0_0[20];
assign rx_supp_macaddr_lower_0[21] = rx_supp_macaddr_bit31to0_0[21];
assign rx_supp_macaddr_lower_0[22] = rx_supp_macaddr_bit31to0_0[22];
assign rx_supp_macaddr_lower_0[23] = rx_supp_macaddr_bit31to0_0[23];
assign rx_supp_macaddr_lower_0[24] = rx_supp_macaddr_bit31to0_0[24];
assign rx_supp_macaddr_lower_0[25] = rx_supp_macaddr_bit31to0_0[25];
assign rx_supp_macaddr_lower_0[26] = rx_supp_macaddr_bit31to0_0[26];
assign rx_supp_macaddr_lower_0[27] = rx_supp_macaddr_bit31to0_0[27];
assign rx_supp_macaddr_lower_0[28] = rx_supp_macaddr_bit31to0_0[28];
assign rx_supp_macaddr_lower_0[29] = rx_supp_macaddr_bit31to0_0[29];
assign rx_supp_macaddr_lower_0[30] = rx_supp_macaddr_bit31to0_0[30];
assign rx_supp_macaddr_lower_0[31] = rx_supp_macaddr_bit31to0_0[31];

assign rx_supp_macaddr_upper_0[0] = rx_supp_macaddr_bit47to32_0[0];
assign rx_supp_macaddr_upper_0[1] = rx_supp_macaddr_bit47to32_0[1];
assign rx_supp_macaddr_upper_0[2] = rx_supp_macaddr_bit47to32_0[2];
assign rx_supp_macaddr_upper_0[3] = rx_supp_macaddr_bit47to32_0[3];
assign rx_supp_macaddr_upper_0[4] = rx_supp_macaddr_bit47to32_0[4];
assign rx_supp_macaddr_upper_0[5] = rx_supp_macaddr_bit47to32_0[5];
assign rx_supp_macaddr_upper_0[6] = rx_supp_macaddr_bit47to32_0[6];
assign rx_supp_macaddr_upper_0[7] = rx_supp_macaddr_bit47to32_0[7];
assign rx_supp_macaddr_upper_0[8] = rx_supp_macaddr_bit47to32_0[8];
assign rx_supp_macaddr_upper_0[9] = rx_supp_macaddr_bit47to32_0[9];
assign rx_supp_macaddr_upper_0[10] = rx_supp_macaddr_bit47to32_0[10];
assign rx_supp_macaddr_upper_0[11] = rx_supp_macaddr_bit47to32_0[11];
assign rx_supp_macaddr_upper_0[12] = rx_supp_macaddr_bit47to32_0[12];
assign rx_supp_macaddr_upper_0[13] = rx_supp_macaddr_bit47to32_0[13];
assign rx_supp_macaddr_upper_0[14] = rx_supp_macaddr_bit47to32_0[14];
assign rx_supp_macaddr_upper_0[15] = rx_supp_macaddr_bit47to32_0[15];
assign rx_supp_macaddr_upper_0[16] = 1'b0;
assign rx_supp_macaddr_upper_0[17] = 1'b0;
assign rx_supp_macaddr_upper_0[18] = 1'b0;
assign rx_supp_macaddr_upper_0[19] = 1'b0;
assign rx_supp_macaddr_upper_0[20] = 1'b0;
assign rx_supp_macaddr_upper_0[21] = 1'b0;
assign rx_supp_macaddr_upper_0[22] = 1'b0;
assign rx_supp_macaddr_upper_0[23] = 1'b0;
assign rx_supp_macaddr_upper_0[24] = 1'b0;
assign rx_supp_macaddr_upper_0[25] = 1'b0;
assign rx_supp_macaddr_upper_0[26] = 1'b0;
assign rx_supp_macaddr_upper_0[27] = 1'b0;
assign rx_supp_macaddr_upper_0[28] = 1'b0;
assign rx_supp_macaddr_upper_0[29] = 1'b0;
assign rx_supp_macaddr_upper_0[30] = 1'b0;
assign rx_supp_macaddr_upper_0[31] = 1'b0;

assign rx_supp_macaddr_lower_1[0] = rx_supp_macaddr_bit31to0_1[0];
assign rx_supp_macaddr_lower_1[1] = rx_supp_macaddr_bit31to0_1[1];
assign rx_supp_macaddr_lower_1[2] = rx_supp_macaddr_bit31to0_1[2];
assign rx_supp_macaddr_lower_1[3] = rx_supp_macaddr_bit31to0_1[3];
assign rx_supp_macaddr_lower_1[4] = rx_supp_macaddr_bit31to0_1[4];
assign rx_supp_macaddr_lower_1[5] = rx_supp_macaddr_bit31to0_1[5];
assign rx_supp_macaddr_lower_1[6] = rx_supp_macaddr_bit31to0_1[6];
assign rx_supp_macaddr_lower_1[7] = rx_supp_macaddr_bit31to0_1[7];
assign rx_supp_macaddr_lower_1[8] = rx_supp_macaddr_bit31to0_1[8];
assign rx_supp_macaddr_lower_1[9] = rx_supp_macaddr_bit31to0_1[9];
assign rx_supp_macaddr_lower_1[10] = rx_supp_macaddr_bit31to0_1[10];
assign rx_supp_macaddr_lower_1[11] = rx_supp_macaddr_bit31to0_1[11];
assign rx_supp_macaddr_lower_1[12] = rx_supp_macaddr_bit31to0_1[12];
assign rx_supp_macaddr_lower_1[13] = rx_supp_macaddr_bit31to0_1[13];
assign rx_supp_macaddr_lower_1[14] = rx_supp_macaddr_bit31to0_1[14];
assign rx_supp_macaddr_lower_1[15] = rx_supp_macaddr_bit31to0_1[15];
assign rx_supp_macaddr_lower_1[16] = rx_supp_macaddr_bit31to0_1[16];
assign rx_supp_macaddr_lower_1[17] = rx_supp_macaddr_bit31to0_1[17];
assign rx_supp_macaddr_lower_1[18] = rx_supp_macaddr_bit31to0_1[18];
assign rx_supp_macaddr_lower_1[19] = rx_supp_macaddr_bit31to0_1[19];
assign rx_supp_macaddr_lower_1[20] = rx_supp_macaddr_bit31to0_1[20];
assign rx_supp_macaddr_lower_1[21] = rx_supp_macaddr_bit31to0_1[21];
assign rx_supp_macaddr_lower_1[22] = rx_supp_macaddr_bit31to0_1[22];
assign rx_supp_macaddr_lower_1[23] = rx_supp_macaddr_bit31to0_1[23];
assign rx_supp_macaddr_lower_1[24] = rx_supp_macaddr_bit31to0_1[24];
assign rx_supp_macaddr_lower_1[25] = rx_supp_macaddr_bit31to0_1[25];
assign rx_supp_macaddr_lower_1[26] = rx_supp_macaddr_bit31to0_1[26];
assign rx_supp_macaddr_lower_1[27] = rx_supp_macaddr_bit31to0_1[27];
assign rx_supp_macaddr_lower_1[28] = rx_supp_macaddr_bit31to0_1[28];
assign rx_supp_macaddr_lower_1[29] = rx_supp_macaddr_bit31to0_1[29];
assign rx_supp_macaddr_lower_1[30] = rx_supp_macaddr_bit31to0_1[30];
assign rx_supp_macaddr_lower_1[31] = rx_supp_macaddr_bit31to0_1[31];

assign rx_supp_macaddr_upper_1[0] = rx_supp_macaddr_bit47to32_1[0];
assign rx_supp_macaddr_upper_1[1] = rx_supp_macaddr_bit47to32_1[1];
assign rx_supp_macaddr_upper_1[2] = rx_supp_macaddr_bit47to32_1[2];
assign rx_supp_macaddr_upper_1[3] = rx_supp_macaddr_bit47to32_1[3];
assign rx_supp_macaddr_upper_1[4] = rx_supp_macaddr_bit47to32_1[4];
assign rx_supp_macaddr_upper_1[5] = rx_supp_macaddr_bit47to32_1[5];
assign rx_supp_macaddr_upper_1[6] = rx_supp_macaddr_bit47to32_1[6];
assign rx_supp_macaddr_upper_1[7] = rx_supp_macaddr_bit47to32_1[7];
assign rx_supp_macaddr_upper_1[8] = rx_supp_macaddr_bit47to32_1[8];
assign rx_supp_macaddr_upper_1[9] = rx_supp_macaddr_bit47to32_1[9];
assign rx_supp_macaddr_upper_1[10] = rx_supp_macaddr_bit47to32_1[10];
assign rx_supp_macaddr_upper_1[11] = rx_supp_macaddr_bit47to32_1[11];
assign rx_supp_macaddr_upper_1[12] = rx_supp_macaddr_bit47to32_1[12];
assign rx_supp_macaddr_upper_1[13] = rx_supp_macaddr_bit47to32_1[13];
assign rx_supp_macaddr_upper_1[14] = rx_supp_macaddr_bit47to32_1[14];
assign rx_supp_macaddr_upper_1[15] = rx_supp_macaddr_bit47to32_1[15];
assign rx_supp_macaddr_upper_1[16] = 1'b0;
assign rx_supp_macaddr_upper_1[17] = 1'b0;
assign rx_supp_macaddr_upper_1[18] = 1'b0;
assign rx_supp_macaddr_upper_1[19] = 1'b0;
assign rx_supp_macaddr_upper_1[20] = 1'b0;
assign rx_supp_macaddr_upper_1[21] = 1'b0;
assign rx_supp_macaddr_upper_1[22] = 1'b0;
assign rx_supp_macaddr_upper_1[23] = 1'b0;
assign rx_supp_macaddr_upper_1[24] = 1'b0;
assign rx_supp_macaddr_upper_1[25] = 1'b0;
assign rx_supp_macaddr_upper_1[26] = 1'b0;
assign rx_supp_macaddr_upper_1[27] = 1'b0;
assign rx_supp_macaddr_upper_1[28] = 1'b0;
assign rx_supp_macaddr_upper_1[29] = 1'b0;
assign rx_supp_macaddr_upper_1[30] = 1'b0;
assign rx_supp_macaddr_upper_1[31] = 1'b0;

assign rx_supp_macaddr_lower_2[0] = rx_supp_macaddr_bit31to0_2[0];
assign rx_supp_macaddr_lower_2[1] = rx_supp_macaddr_bit31to0_2[1];
assign rx_supp_macaddr_lower_2[2] = rx_supp_macaddr_bit31to0_2[2];
assign rx_supp_macaddr_lower_2[3] = rx_supp_macaddr_bit31to0_2[3];
assign rx_supp_macaddr_lower_2[4] = rx_supp_macaddr_bit31to0_2[4];
assign rx_supp_macaddr_lower_2[5] = rx_supp_macaddr_bit31to0_2[5];
assign rx_supp_macaddr_lower_2[6] = rx_supp_macaddr_bit31to0_2[6];
assign rx_supp_macaddr_lower_2[7] = rx_supp_macaddr_bit31to0_2[7];
assign rx_supp_macaddr_lower_2[8] = rx_supp_macaddr_bit31to0_2[8];
assign rx_supp_macaddr_lower_2[9] = rx_supp_macaddr_bit31to0_2[9];
assign rx_supp_macaddr_lower_2[10] = rx_supp_macaddr_bit31to0_2[10];
assign rx_supp_macaddr_lower_2[11] = rx_supp_macaddr_bit31to0_2[11];
assign rx_supp_macaddr_lower_2[12] = rx_supp_macaddr_bit31to0_2[12];
assign rx_supp_macaddr_lower_2[13] = rx_supp_macaddr_bit31to0_2[13];
assign rx_supp_macaddr_lower_2[14] = rx_supp_macaddr_bit31to0_2[14];
assign rx_supp_macaddr_lower_2[15] = rx_supp_macaddr_bit31to0_2[15];
assign rx_supp_macaddr_lower_2[16] = rx_supp_macaddr_bit31to0_2[16];
assign rx_supp_macaddr_lower_2[17] = rx_supp_macaddr_bit31to0_2[17];
assign rx_supp_macaddr_lower_2[18] = rx_supp_macaddr_bit31to0_2[18];
assign rx_supp_macaddr_lower_2[19] = rx_supp_macaddr_bit31to0_2[19];
assign rx_supp_macaddr_lower_2[20] = rx_supp_macaddr_bit31to0_2[20];
assign rx_supp_macaddr_lower_2[21] = rx_supp_macaddr_bit31to0_2[21];
assign rx_supp_macaddr_lower_2[22] = rx_supp_macaddr_bit31to0_2[22];
assign rx_supp_macaddr_lower_2[23] = rx_supp_macaddr_bit31to0_2[23];
assign rx_supp_macaddr_lower_2[24] = rx_supp_macaddr_bit31to0_2[24];
assign rx_supp_macaddr_lower_2[25] = rx_supp_macaddr_bit31to0_2[25];
assign rx_supp_macaddr_lower_2[26] = rx_supp_macaddr_bit31to0_2[26];
assign rx_supp_macaddr_lower_2[27] = rx_supp_macaddr_bit31to0_2[27];
assign rx_supp_macaddr_lower_2[28] = rx_supp_macaddr_bit31to0_2[28];
assign rx_supp_macaddr_lower_2[29] = rx_supp_macaddr_bit31to0_2[29];
assign rx_supp_macaddr_lower_2[30] = rx_supp_macaddr_bit31to0_2[30];
assign rx_supp_macaddr_lower_2[31] = rx_supp_macaddr_bit31to0_2[31];

assign rx_supp_macaddr_upper_2[0] = rx_supp_macaddr_bit47to32_2[0];
assign rx_supp_macaddr_upper_2[1] = rx_supp_macaddr_bit47to32_2[1];
assign rx_supp_macaddr_upper_2[2] = rx_supp_macaddr_bit47to32_2[2];
assign rx_supp_macaddr_upper_2[3] = rx_supp_macaddr_bit47to32_2[3];
assign rx_supp_macaddr_upper_2[4] = rx_supp_macaddr_bit47to32_2[4];
assign rx_supp_macaddr_upper_2[5] = rx_supp_macaddr_bit47to32_2[5];
assign rx_supp_macaddr_upper_2[6] = rx_supp_macaddr_bit47to32_2[6];
assign rx_supp_macaddr_upper_2[7] = rx_supp_macaddr_bit47to32_2[7];
assign rx_supp_macaddr_upper_2[8] = rx_supp_macaddr_bit47to32_2[8];
assign rx_supp_macaddr_upper_2[9] = rx_supp_macaddr_bit47to32_2[9];
assign rx_supp_macaddr_upper_2[10] = rx_supp_macaddr_bit47to32_2[10];
assign rx_supp_macaddr_upper_2[11] = rx_supp_macaddr_bit47to32_2[11];
assign rx_supp_macaddr_upper_2[12] = rx_supp_macaddr_bit47to32_2[12];
assign rx_supp_macaddr_upper_2[13] = rx_supp_macaddr_bit47to32_2[13];
assign rx_supp_macaddr_upper_2[14] = rx_supp_macaddr_bit47to32_2[14];
assign rx_supp_macaddr_upper_2[15] = rx_supp_macaddr_bit47to32_2[15];
assign rx_supp_macaddr_upper_2[16] = 1'b0;
assign rx_supp_macaddr_upper_2[17] = 1'b0;
assign rx_supp_macaddr_upper_2[18] = 1'b0;
assign rx_supp_macaddr_upper_2[19] = 1'b0;
assign rx_supp_macaddr_upper_2[20] = 1'b0;
assign rx_supp_macaddr_upper_2[21] = 1'b0;
assign rx_supp_macaddr_upper_2[22] = 1'b0;
assign rx_supp_macaddr_upper_2[23] = 1'b0;
assign rx_supp_macaddr_upper_2[24] = 1'b0;
assign rx_supp_macaddr_upper_2[25] = 1'b0;
assign rx_supp_macaddr_upper_2[26] = 1'b0;
assign rx_supp_macaddr_upper_2[27] = 1'b0;
assign rx_supp_macaddr_upper_2[28] = 1'b0;
assign rx_supp_macaddr_upper_2[29] = 1'b0;
assign rx_supp_macaddr_upper_2[30] = 1'b0;
assign rx_supp_macaddr_upper_2[31] = 1'b0;

assign rx_supp_macaddr_lower_3[0] = rx_supp_macaddr_bit31to0_3[0];
assign rx_supp_macaddr_lower_3[1] = rx_supp_macaddr_bit31to0_3[1];
assign rx_supp_macaddr_lower_3[2] = rx_supp_macaddr_bit31to0_3[2];
assign rx_supp_macaddr_lower_3[3] = rx_supp_macaddr_bit31to0_3[3];
assign rx_supp_macaddr_lower_3[4] = rx_supp_macaddr_bit31to0_3[4];
assign rx_supp_macaddr_lower_3[5] = rx_supp_macaddr_bit31to0_3[5];
assign rx_supp_macaddr_lower_3[6] = rx_supp_macaddr_bit31to0_3[6];
assign rx_supp_macaddr_lower_3[7] = rx_supp_macaddr_bit31to0_3[7];
assign rx_supp_macaddr_lower_3[8] = rx_supp_macaddr_bit31to0_3[8];
assign rx_supp_macaddr_lower_3[9] = rx_supp_macaddr_bit31to0_3[9];
assign rx_supp_macaddr_lower_3[10] = rx_supp_macaddr_bit31to0_3[10];
assign rx_supp_macaddr_lower_3[11] = rx_supp_macaddr_bit31to0_3[11];
assign rx_supp_macaddr_lower_3[12] = rx_supp_macaddr_bit31to0_3[12];
assign rx_supp_macaddr_lower_3[13] = rx_supp_macaddr_bit31to0_3[13];
assign rx_supp_macaddr_lower_3[14] = rx_supp_macaddr_bit31to0_3[14];
assign rx_supp_macaddr_lower_3[15] = rx_supp_macaddr_bit31to0_3[15];
assign rx_supp_macaddr_lower_3[16] = rx_supp_macaddr_bit31to0_3[16];
assign rx_supp_macaddr_lower_3[17] = rx_supp_macaddr_bit31to0_3[17];
assign rx_supp_macaddr_lower_3[18] = rx_supp_macaddr_bit31to0_3[18];
assign rx_supp_macaddr_lower_3[19] = rx_supp_macaddr_bit31to0_3[19];
assign rx_supp_macaddr_lower_3[20] = rx_supp_macaddr_bit31to0_3[20];
assign rx_supp_macaddr_lower_3[21] = rx_supp_macaddr_bit31to0_3[21];
assign rx_supp_macaddr_lower_3[22] = rx_supp_macaddr_bit31to0_3[22];
assign rx_supp_macaddr_lower_3[23] = rx_supp_macaddr_bit31to0_3[23];
assign rx_supp_macaddr_lower_3[24] = rx_supp_macaddr_bit31to0_3[24];
assign rx_supp_macaddr_lower_3[25] = rx_supp_macaddr_bit31to0_3[25];
assign rx_supp_macaddr_lower_3[26] = rx_supp_macaddr_bit31to0_3[26];
assign rx_supp_macaddr_lower_3[27] = rx_supp_macaddr_bit31to0_3[27];
assign rx_supp_macaddr_lower_3[28] = rx_supp_macaddr_bit31to0_3[28];
assign rx_supp_macaddr_lower_3[29] = rx_supp_macaddr_bit31to0_3[29];
assign rx_supp_macaddr_lower_3[30] = rx_supp_macaddr_bit31to0_3[30];
assign rx_supp_macaddr_lower_3[31] = rx_supp_macaddr_bit31to0_3[31];

assign rx_supp_macaddr_upper_3[0] = rx_supp_macaddr_bit47to32_3[0];
assign rx_supp_macaddr_upper_3[1] = rx_supp_macaddr_bit47to32_3[1];
assign rx_supp_macaddr_upper_3[2] = rx_supp_macaddr_bit47to32_3[2];
assign rx_supp_macaddr_upper_3[3] = rx_supp_macaddr_bit47to32_3[3];
assign rx_supp_macaddr_upper_3[4] = rx_supp_macaddr_bit47to32_3[4];
assign rx_supp_macaddr_upper_3[5] = rx_supp_macaddr_bit47to32_3[5];
assign rx_supp_macaddr_upper_3[6] = rx_supp_macaddr_bit47to32_3[6];
assign rx_supp_macaddr_upper_3[7] = rx_supp_macaddr_bit47to32_3[7];
assign rx_supp_macaddr_upper_3[8] = rx_supp_macaddr_bit47to32_3[8];
assign rx_supp_macaddr_upper_3[9] = rx_supp_macaddr_bit47to32_3[9];
assign rx_supp_macaddr_upper_3[10] = rx_supp_macaddr_bit47to32_3[10];
assign rx_supp_macaddr_upper_3[11] = rx_supp_macaddr_bit47to32_3[11];
assign rx_supp_macaddr_upper_3[12] = rx_supp_macaddr_bit47to32_3[12];
assign rx_supp_macaddr_upper_3[13] = rx_supp_macaddr_bit47to32_3[13];
assign rx_supp_macaddr_upper_3[14] = rx_supp_macaddr_bit47to32_3[14];
assign rx_supp_macaddr_upper_3[15] = rx_supp_macaddr_bit47to32_3[15];
assign rx_supp_macaddr_upper_3[16] = 1'b0;
assign rx_supp_macaddr_upper_3[17] = 1'b0;
assign rx_supp_macaddr_upper_3[18] = 1'b0;
assign rx_supp_macaddr_upper_3[19] = 1'b0;
assign rx_supp_macaddr_upper_3[20] = 1'b0;
assign rx_supp_macaddr_upper_3[21] = 1'b0;
assign rx_supp_macaddr_upper_3[22] = 1'b0;
assign rx_supp_macaddr_upper_3[23] = 1'b0;
assign rx_supp_macaddr_upper_3[24] = 1'b0;
assign rx_supp_macaddr_upper_3[25] = 1'b0;
assign rx_supp_macaddr_upper_3[26] = 1'b0;
assign rx_supp_macaddr_upper_3[27] = 1'b0;
assign rx_supp_macaddr_upper_3[28] = 1'b0;
assign rx_supp_macaddr_upper_3[29] = 1'b0;
assign rx_supp_macaddr_upper_3[30] = 1'b0;
assign rx_supp_macaddr_upper_3[31] = 1'b0;

assign rx_pfc_ctl[0] = rx_pfc_ignore_pausefrm_0;
assign rx_pfc_ctl[1] = rx_pfc_ignore_pausefrm_1;
assign rx_pfc_ctl[2] = rx_pfc_ignore_pausefrm_2;
assign rx_pfc_ctl[3] = rx_pfc_ignore_pausefrm_3;
assign rx_pfc_ctl[4] = rx_pfc_ignore_pausefrm_4;
assign rx_pfc_ctl[5] = rx_pfc_ignore_pausefrm_5;
assign rx_pfc_ctl[6] = rx_pfc_ignore_pausefrm_6;
assign rx_pfc_ctl[7] = rx_pfc_ignore_pausefrm_7;
assign rx_pfc_ctl[8] = 1'b0;
assign rx_pfc_ctl[9] = 1'b0;
assign rx_pfc_ctl[10] = 1'b0;
assign rx_pfc_ctl[11] = 1'b0;
assign rx_pfc_ctl[12] = 1'b0;
assign rx_pfc_ctl[13] = 1'b0;
assign rx_pfc_ctl[14] = 1'b0;
assign rx_pfc_ctl[15] = 1'b0;
assign rx_pfc_ctl[16] = rx_pfc_fwd;
assign rx_pfc_ctl[17] = 1'b0;
assign rx_pfc_ctl[18] = 1'b0;
assign rx_pfc_ctl[19] = 1'b0;
assign rx_pfc_ctl[20] = 1'b0;
assign rx_pfc_ctl[21] = 1'b0;
assign rx_pfc_ctl[22] = 1'b0;
assign rx_pfc_ctl[23] = 1'b0;
assign rx_pfc_ctl[24] = 1'b0;
assign rx_pfc_ctl[25] = 1'b0;
assign rx_pfc_ctl[26] = 1'b0;
assign rx_pfc_ctl[27] = 1'b0;
assign rx_pfc_ctl[28] = 1'b0;
assign rx_pfc_ctl[29] = 1'b0;
assign rx_pfc_ctl[30] = 1'b0;
assign rx_pfc_ctl[31] = 1'b0;

assign rx_pkt_ovrflw_errcnt_lower[0] = rx_pkt_ovrflw_errcnt_bit31to0[0];
assign rx_pkt_ovrflw_errcnt_lower[1] = rx_pkt_ovrflw_errcnt_bit31to0[1];
assign rx_pkt_ovrflw_errcnt_lower[2] = rx_pkt_ovrflw_errcnt_bit31to0[2];
assign rx_pkt_ovrflw_errcnt_lower[3] = rx_pkt_ovrflw_errcnt_bit31to0[3];
assign rx_pkt_ovrflw_errcnt_lower[4] = rx_pkt_ovrflw_errcnt_bit31to0[4];
assign rx_pkt_ovrflw_errcnt_lower[5] = rx_pkt_ovrflw_errcnt_bit31to0[5];
assign rx_pkt_ovrflw_errcnt_lower[6] = rx_pkt_ovrflw_errcnt_bit31to0[6];
assign rx_pkt_ovrflw_errcnt_lower[7] = rx_pkt_ovrflw_errcnt_bit31to0[7];
assign rx_pkt_ovrflw_errcnt_lower[8] = rx_pkt_ovrflw_errcnt_bit31to0[8];
assign rx_pkt_ovrflw_errcnt_lower[9] = rx_pkt_ovrflw_errcnt_bit31to0[9];
assign rx_pkt_ovrflw_errcnt_lower[10] = rx_pkt_ovrflw_errcnt_bit31to0[10];
assign rx_pkt_ovrflw_errcnt_lower[11] = rx_pkt_ovrflw_errcnt_bit31to0[11];
assign rx_pkt_ovrflw_errcnt_lower[12] = rx_pkt_ovrflw_errcnt_bit31to0[12];
assign rx_pkt_ovrflw_errcnt_lower[13] = rx_pkt_ovrflw_errcnt_bit31to0[13];
assign rx_pkt_ovrflw_errcnt_lower[14] = rx_pkt_ovrflw_errcnt_bit31to0[14];
assign rx_pkt_ovrflw_errcnt_lower[15] = rx_pkt_ovrflw_errcnt_bit31to0[15];
assign rx_pkt_ovrflw_errcnt_lower[16] = rx_pkt_ovrflw_errcnt_bit31to0[16];
assign rx_pkt_ovrflw_errcnt_lower[17] = rx_pkt_ovrflw_errcnt_bit31to0[17];
assign rx_pkt_ovrflw_errcnt_lower[18] = rx_pkt_ovrflw_errcnt_bit31to0[18];
assign rx_pkt_ovrflw_errcnt_lower[19] = rx_pkt_ovrflw_errcnt_bit31to0[19];
assign rx_pkt_ovrflw_errcnt_lower[20] = rx_pkt_ovrflw_errcnt_bit31to0[20];
assign rx_pkt_ovrflw_errcnt_lower[21] = rx_pkt_ovrflw_errcnt_bit31to0[21];
assign rx_pkt_ovrflw_errcnt_lower[22] = rx_pkt_ovrflw_errcnt_bit31to0[22];
assign rx_pkt_ovrflw_errcnt_lower[23] = rx_pkt_ovrflw_errcnt_bit31to0[23];
assign rx_pkt_ovrflw_errcnt_lower[24] = rx_pkt_ovrflw_errcnt_bit31to0[24];
assign rx_pkt_ovrflw_errcnt_lower[25] = rx_pkt_ovrflw_errcnt_bit31to0[25];
assign rx_pkt_ovrflw_errcnt_lower[26] = rx_pkt_ovrflw_errcnt_bit31to0[26];
assign rx_pkt_ovrflw_errcnt_lower[27] = rx_pkt_ovrflw_errcnt_bit31to0[27];
assign rx_pkt_ovrflw_errcnt_lower[28] = rx_pkt_ovrflw_errcnt_bit31to0[28];
assign rx_pkt_ovrflw_errcnt_lower[29] = rx_pkt_ovrflw_errcnt_bit31to0[29];
assign rx_pkt_ovrflw_errcnt_lower[30] = rx_pkt_ovrflw_errcnt_bit31to0[30];
assign rx_pkt_ovrflw_errcnt_lower[31] = rx_pkt_ovrflw_errcnt_bit31to0[31];

assign rx_pkt_ovrflw_errcnt_upper[0] = rx_pkt_ovrflw_errcnt_bit35to32[0];
assign rx_pkt_ovrflw_errcnt_upper[1] = rx_pkt_ovrflw_errcnt_bit35to32[1];
assign rx_pkt_ovrflw_errcnt_upper[2] = rx_pkt_ovrflw_errcnt_bit35to32[2];
assign rx_pkt_ovrflw_errcnt_upper[3] = rx_pkt_ovrflw_errcnt_bit35to32[3];
assign rx_pkt_ovrflw_errcnt_upper[4] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[5] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[6] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[7] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[8] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[9] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[10] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[11] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[12] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[13] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[14] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[15] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[16] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[17] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[18] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[19] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[20] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[21] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[22] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[23] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[24] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[25] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[26] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[27] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[28] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[29] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[30] = 1'b0;
assign rx_pkt_ovrflw_errcnt_upper[31] = 1'b0;

assign rx_pkt_ovrflw_etherstatsdropevents_lower[0] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[0];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[1] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[1];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[2] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[2];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[3] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[3];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[4] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[4];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[5] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[5];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[6] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[6];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[7] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[7];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[8] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[8];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[9] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[9];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[10] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[10];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[11] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[11];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[12] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[12];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[13] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[13];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[14] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[14];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[15] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[15];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[16] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[16];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[17] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[17];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[18] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[18];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[19] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[19];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[20] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[20];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[21] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[21];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[22] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[22];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[23] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[23];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[24] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[24];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[25] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[25];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[26] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[26];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[27] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[27];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[28] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[28];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[29] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[29];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[30] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[30];
assign rx_pkt_ovrflw_etherstatsdropevents_lower[31] = rx_pkt_ovrflw_etherstatsdropevents_bit31to0[31];

assign rx_pkt_ovrflw_etherstatsdropevents_upper[0] = rx_pkt_ovrflw_etherstatsdropevents_bit35to32[0];
assign rx_pkt_ovrflw_etherstatsdropevents_upper[1] = rx_pkt_ovrflw_etherstatsdropevents_bit35to32[1];
assign rx_pkt_ovrflw_etherstatsdropevents_upper[2] = rx_pkt_ovrflw_etherstatsdropevents_bit35to32[2];
assign rx_pkt_ovrflw_etherstatsdropevents_upper[3] = rx_pkt_ovrflw_etherstatsdropevents_bit35to32[3];
assign rx_pkt_ovrflw_etherstatsdropevents_upper[4] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[5] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[6] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[7] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[8] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[9] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[10] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[11] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[12] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[13] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[14] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[15] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[16] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[17] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[18] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[19] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[20] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[21] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[22] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[23] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[24] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[25] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[26] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[27] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[28] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[29] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[30] = 1'b0;
assign rx_pkt_ovrflw_etherstatsdropevents_upper[31] = 1'b0;

assign tx_period10g[0] = tx_period_10g[0];
assign tx_period10g[1] = tx_period_10g[1];
assign tx_period10g[2] = tx_period_10g[2];
assign tx_period10g[3] = tx_period_10g[3];
assign tx_period10g[4] = tx_period_10g[4];
assign tx_period10g[5] = tx_period_10g[5];
assign tx_period10g[6] = tx_period_10g[6];
assign tx_period10g[7] = tx_period_10g[7];
assign tx_period10g[8] = tx_period_10g[8];
assign tx_period10g[9] = tx_period_10g[9];
assign tx_period10g[10] = tx_period_10g[10];
assign tx_period10g[11] = tx_period_10g[11];
assign tx_period10g[12] = tx_period_10g[12];
assign tx_period10g[13] = tx_period_10g[13];
assign tx_period10g[14] = tx_period_10g[14];
assign tx_period10g[15] = tx_period_10g[15];
assign tx_period10g[16] = tx_period_10g[16];
assign tx_period10g[17] = tx_period_10g[17];
assign tx_period10g[18] = tx_period_10g[18];
assign tx_period10g[19] = tx_period_10g[19];
assign tx_period10g[20] = 1'b0;
assign tx_period10g[21] = 1'b0;
assign tx_period10g[22] = 1'b0;
assign tx_period10g[23] = 1'b0;
assign tx_period10g[24] = 1'b0;
assign tx_period10g[25] = 1'b0;
assign tx_period10g[26] = 1'b0;
assign tx_period10g[27] = 1'b0;
assign tx_period10g[28] = 1'b0;
assign tx_period10g[29] = 1'b0;
assign tx_period10g[30] = 1'b0;
assign tx_period10g[31] = 1'b0;

assign tx_adjns_10g[0] = tx_adj_fracns_10g[0];
assign tx_adjns_10g[1] = tx_adj_fracns_10g[1];
assign tx_adjns_10g[2] = tx_adj_fracns_10g[2];
assign tx_adjns_10g[3] = tx_adj_fracns_10g[3];
assign tx_adjns_10g[4] = tx_adj_fracns_10g[4];
assign tx_adjns_10g[5] = tx_adj_fracns_10g[5];
assign tx_adjns_10g[6] = tx_adj_fracns_10g[6];
assign tx_adjns_10g[7] = tx_adj_fracns_10g[7];
assign tx_adjns_10g[8] = tx_adj_fracns_10g[8];
assign tx_adjns_10g[9] = tx_adj_fracns_10g[9];
assign tx_adjns_10g[10] = tx_adj_fracns_10g[10];
assign tx_adjns_10g[11] = tx_adj_fracns_10g[11];
assign tx_adjns_10g[12] = tx_adj_fracns_10g[12];
assign tx_adjns_10g[13] = tx_adj_fracns_10g[13];
assign tx_adjns_10g[14] = tx_adj_fracns_10g[14];
assign tx_adjns_10g[15] = tx_adj_fracns_10g[15];
assign tx_adjns_10g[16] = 1'b0;
assign tx_adjns_10g[17] = 1'b0;
assign tx_adjns_10g[18] = 1'b0;
assign tx_adjns_10g[19] = 1'b0;
assign tx_adjns_10g[20] = 1'b0;
assign tx_adjns_10g[21] = 1'b0;
assign tx_adjns_10g[22] = 1'b0;
assign tx_adjns_10g[23] = 1'b0;
assign tx_adjns_10g[24] = 1'b0;
assign tx_adjns_10g[25] = 1'b0;
assign tx_adjns_10g[26] = 1'b0;
assign tx_adjns_10g[27] = 1'b0;
assign tx_adjns_10g[28] = 1'b0;
assign tx_adjns_10g[29] = 1'b0;
assign tx_adjns_10g[30] = 1'b0;
assign tx_adjns_10g[31] = 1'b0;

assign tx_adjfracns_10g[0] = tx_adj_ns_10g[0];
assign tx_adjfracns_10g[1] = tx_adj_ns_10g[1];
assign tx_adjfracns_10g[2] = tx_adj_ns_10g[2];
assign tx_adjfracns_10g[3] = tx_adj_ns_10g[3];
assign tx_adjfracns_10g[4] = tx_adj_ns_10g[4];
assign tx_adjfracns_10g[5] = tx_adj_ns_10g[5];
assign tx_adjfracns_10g[6] = tx_adj_ns_10g[6];
assign tx_adjfracns_10g[7] = tx_adj_ns_10g[7];
assign tx_adjfracns_10g[8] = tx_adj_ns_10g[8];
assign tx_adjfracns_10g[9] = tx_adj_ns_10g[9];
assign tx_adjfracns_10g[10] = tx_adj_ns_10g[10];
assign tx_adjfracns_10g[11] = tx_adj_ns_10g[11];
assign tx_adjfracns_10g[12] = tx_adj_ns_10g[12];
assign tx_adjfracns_10g[13] = tx_adj_ns_10g[13];
assign tx_adjfracns_10g[14] = tx_adj_ns_10g[14];
assign tx_adjfracns_10g[15] = tx_adj_ns_10g[15];
assign tx_adjfracns_10g[16] = 1'b0;
assign tx_adjfracns_10g[17] = 1'b0;
assign tx_adjfracns_10g[18] = 1'b0;
assign tx_adjfracns_10g[19] = 1'b0;
assign tx_adjfracns_10g[20] = 1'b0;
assign tx_adjfracns_10g[21] = 1'b0;
assign tx_adjfracns_10g[22] = 1'b0;
assign tx_adjfracns_10g[23] = 1'b0;
assign tx_adjfracns_10g[24] = 1'b0;
assign tx_adjfracns_10g[25] = 1'b0;
assign tx_adjfracns_10g[26] = 1'b0;
assign tx_adjfracns_10g[27] = 1'b0;
assign tx_adjfracns_10g[28] = 1'b0;
assign tx_adjfracns_10g[29] = 1'b0;
assign tx_adjfracns_10g[30] = 1'b0;
assign tx_adjfracns_10g[31] = 1'b0;

assign tx_period1g[0] = tx_period_1g[0];
assign tx_period1g[1] = tx_period_1g[1];
assign tx_period1g[2] = tx_period_1g[2];
assign tx_period1g[3] = tx_period_1g[3];
assign tx_period1g[4] = tx_period_1g[4];
assign tx_period1g[5] = tx_period_1g[5];
assign tx_period1g[6] = tx_period_1g[6];
assign tx_period1g[7] = tx_period_1g[7];
assign tx_period1g[8] = tx_period_1g[8];
assign tx_period1g[9] = tx_period_1g[9];
assign tx_period1g[10] = tx_period_1g[10];
assign tx_period1g[11] = tx_period_1g[11];
assign tx_period1g[12] = tx_period_1g[12];
assign tx_period1g[13] = tx_period_1g[13];
assign tx_period1g[14] = tx_period_1g[14];
assign tx_period1g[15] = tx_period_1g[15];
assign tx_period1g[16] = tx_period_1g[16];
assign tx_period1g[17] = tx_period_1g[17];
assign tx_period1g[18] = tx_period_1g[18];
assign tx_period1g[19] = tx_period_1g[19];
assign tx_period1g[20] = 1'b0;
assign tx_period1g[21] = 1'b0;
assign tx_period1g[22] = 1'b0;
assign tx_period1g[23] = 1'b0;
assign tx_period1g[24] = 1'b0;
assign tx_period1g[25] = 1'b0;
assign tx_period1g[26] = 1'b0;
assign tx_period1g[27] = 1'b0;
assign tx_period1g[28] = 1'b0;
assign tx_period1g[29] = 1'b0;
assign tx_period1g[30] = 1'b0;
assign tx_period1g[31] = 1'b0;

assign tx_adjns_1g[0] = tx_adj_fracns_1g[0];
assign tx_adjns_1g[1] = tx_adj_fracns_1g[1];
assign tx_adjns_1g[2] = tx_adj_fracns_1g[2];
assign tx_adjns_1g[3] = tx_adj_fracns_1g[3];
assign tx_adjns_1g[4] = tx_adj_fracns_1g[4];
assign tx_adjns_1g[5] = tx_adj_fracns_1g[5];
assign tx_adjns_1g[6] = tx_adj_fracns_1g[6];
assign tx_adjns_1g[7] = tx_adj_fracns_1g[7];
assign tx_adjns_1g[8] = tx_adj_fracns_1g[8];
assign tx_adjns_1g[9] = tx_adj_fracns_1g[9];
assign tx_adjns_1g[10] = tx_adj_fracns_1g[10];
assign tx_adjns_1g[11] = tx_adj_fracns_1g[11];
assign tx_adjns_1g[12] = tx_adj_fracns_1g[12];
assign tx_adjns_1g[13] = tx_adj_fracns_1g[13];
assign tx_adjns_1g[14] = tx_adj_fracns_1g[14];
assign tx_adjns_1g[15] = tx_adj_fracns_1g[15];
assign tx_adjns_1g[16] = 1'b0;
assign tx_adjns_1g[17] = 1'b0;
assign tx_adjns_1g[18] = 1'b0;
assign tx_adjns_1g[19] = 1'b0;
assign tx_adjns_1g[20] = 1'b0;
assign tx_adjns_1g[21] = 1'b0;
assign tx_adjns_1g[22] = 1'b0;
assign tx_adjns_1g[23] = 1'b0;
assign tx_adjns_1g[24] = 1'b0;
assign tx_adjns_1g[25] = 1'b0;
assign tx_adjns_1g[26] = 1'b0;
assign tx_adjns_1g[27] = 1'b0;
assign tx_adjns_1g[28] = 1'b0;
assign tx_adjns_1g[29] = 1'b0;
assign tx_adjns_1g[30] = 1'b0;
assign tx_adjns_1g[31] = 1'b0;

assign tx_adjfracns_1g[0] = tx_adj_ns_1g[0];
assign tx_adjfracns_1g[1] = tx_adj_ns_1g[1];
assign tx_adjfracns_1g[2] = tx_adj_ns_1g[2];
assign tx_adjfracns_1g[3] = tx_adj_ns_1g[3];
assign tx_adjfracns_1g[4] = tx_adj_ns_1g[4];
assign tx_adjfracns_1g[5] = tx_adj_ns_1g[5];
assign tx_adjfracns_1g[6] = tx_adj_ns_1g[6];
assign tx_adjfracns_1g[7] = tx_adj_ns_1g[7];
assign tx_adjfracns_1g[8] = tx_adj_ns_1g[8];
assign tx_adjfracns_1g[9] = tx_adj_ns_1g[9];
assign tx_adjfracns_1g[10] = tx_adj_ns_1g[10];
assign tx_adjfracns_1g[11] = tx_adj_ns_1g[11];
assign tx_adjfracns_1g[12] = tx_adj_ns_1g[12];
assign tx_adjfracns_1g[13] = tx_adj_ns_1g[13];
assign tx_adjfracns_1g[14] = tx_adj_ns_1g[14];
assign tx_adjfracns_1g[15] = tx_adj_ns_1g[15];
assign tx_adjfracns_1g[16] = 1'b0;
assign tx_adjfracns_1g[17] = 1'b0;
assign tx_adjfracns_1g[18] = 1'b0;
assign tx_adjfracns_1g[19] = 1'b0;
assign tx_adjfracns_1g[20] = 1'b0;
assign tx_adjfracns_1g[21] = 1'b0;
assign tx_adjfracns_1g[22] = 1'b0;
assign tx_adjfracns_1g[23] = 1'b0;
assign tx_adjfracns_1g[24] = 1'b0;
assign tx_adjfracns_1g[25] = 1'b0;
assign tx_adjfracns_1g[26] = 1'b0;
assign tx_adjfracns_1g[27] = 1'b0;
assign tx_adjfracns_1g[28] = 1'b0;
assign tx_adjfracns_1g[29] = 1'b0;
assign tx_adjfracns_1g[30] = 1'b0;
assign tx_adjfracns_1g[31] = 1'b0;

assign tx_asymm[0] = tx_asymmetry[0];
assign tx_asymm[1] = tx_asymmetry[1];
assign tx_asymm[2] = tx_asymmetry[2];
assign tx_asymm[3] = tx_asymmetry[3];
assign tx_asymm[4] = tx_asymmetry[4];
assign tx_asymm[5] = tx_asymmetry[5];
assign tx_asymm[6] = tx_asymmetry[6];
assign tx_asymm[7] = tx_asymmetry[7];
assign tx_asymm[8] = tx_asymmetry[8];
assign tx_asymm[9] = tx_asymmetry[9];
assign tx_asymm[10] = tx_asymmetry[10];
assign tx_asymm[11] = tx_asymmetry[11];
assign tx_asymm[12] = tx_asymmetry[12];
assign tx_asymm[13] = tx_asymmetry[13];
assign tx_asymm[14] = tx_asymmetry[14];
assign tx_asymm[15] = tx_asymmetry[15];
assign tx_asymm[16] = tx_asymmetry[16];
assign tx_asymm[17] = tx_asymmetry[17];
assign tx_asymm[18] = tx_asymmetry[18];
assign tx_asymm[19] = 1'b0;
assign tx_asymm[20] = 1'b0;
assign tx_asymm[21] = 1'b0;
assign tx_asymm[22] = 1'b0;
assign tx_asymm[23] = 1'b0;
assign tx_asymm[24] = 1'b0;
assign tx_asymm[25] = 1'b0;
assign tx_asymm[26] = 1'b0;
assign tx_asymm[27] = 1'b0;
assign tx_asymm[28] = 1'b0;
assign tx_asymm[29] = 1'b0;
assign tx_asymm[30] = 1'b0;
assign tx_asymm[31] = 1'b0;

assign tx_p2p_dir[0] = tx_p2p_dir_egress;
assign tx_p2p_dir[1] = 1'b0;
assign tx_p2p_dir[2] = 1'b0;
assign tx_p2p_dir[3] = 1'b0;
assign tx_p2p_dir[4] = 1'b0;
assign tx_p2p_dir[5] = 1'b0;
assign tx_p2p_dir[6] = 1'b0;
assign tx_p2p_dir[7] = 1'b0;
assign tx_p2p_dir[8] = 1'b0;
assign tx_p2p_dir[9] = 1'b0;
assign tx_p2p_dir[10] = 1'b0;
assign tx_p2p_dir[11] = 1'b0;
assign tx_p2p_dir[12] = 1'b0;
assign tx_p2p_dir[13] = 1'b0;
assign tx_p2p_dir[14] = 1'b0;
assign tx_p2p_dir[15] = 1'b0;
assign tx_p2p_dir[16] = 1'b0;
assign tx_p2p_dir[17] = 1'b0;
assign tx_p2p_dir[18] = 1'b0;
assign tx_p2p_dir[19] = 1'b0;
assign tx_p2p_dir[20] = 1'b0;
assign tx_p2p_dir[21] = 1'b0;
assign tx_p2p_dir[22] = 1'b0;
assign tx_p2p_dir[23] = 1'b0;
assign tx_p2p_dir[24] = 1'b0;
assign tx_p2p_dir[25] = 1'b0;
assign tx_p2p_dir[26] = 1'b0;
assign tx_p2p_dir[27] = 1'b0;
assign tx_p2p_dir[28] = 1'b0;
assign tx_p2p_dir[29] = 1'b0;
assign tx_p2p_dir[30] = 1'b0;
assign tx_p2p_dir[31] = 1'b0;

assign cf_error[0] = cf_overflow_ingress;
assign cf_error[1] = 1'b0;
assign cf_error[2] = 1'b0;
assign cf_error[3] = 1'b0;
assign cf_error[4] = 1'b0;
assign cf_error[5] = 1'b0;
assign cf_error[6] = 1'b0;
assign cf_error[7] = 1'b0;
assign cf_error[8] = 1'b0;
assign cf_error[9] = 1'b0;
assign cf_error[10] = 1'b0;
assign cf_error[11] = 1'b0;
assign cf_error[12] = 1'b0;
assign cf_error[13] = 1'b0;
assign cf_error[14] = 1'b0;
assign cf_error[15] = 1'b0;
assign cf_error[16] = cf_overflow_egress;
assign cf_error[17] = cf_rt_gt_eq_4s;
assign cf_error[18] = cf_rt_neg;
assign cf_error[19] = 1'b0;
assign cf_error[20] = 1'b0;
assign cf_error[21] = 1'b0;
assign cf_error[22] = 1'b0;
assign cf_error[23] = 1'b0;
assign cf_error[24] = 1'b0;
assign cf_error[25] = 1'b0;
assign cf_error[26] = 1'b0;
assign cf_error[27] = 1'b0;
assign cf_error[28] = 1'b0;
assign cf_error[29] = 1'b0;
assign cf_error[30] = 1'b0;
assign cf_error[31] = 1'b0;

assign rx_period10g[0] = rx_period_10g[0];
assign rx_period10g[1] = rx_period_10g[1];
assign rx_period10g[2] = rx_period_10g[2];
assign rx_period10g[3] = rx_period_10g[3];
assign rx_period10g[4] = rx_period_10g[4];
assign rx_period10g[5] = rx_period_10g[5];
assign rx_period10g[6] = rx_period_10g[6];
assign rx_period10g[7] = rx_period_10g[7];
assign rx_period10g[8] = rx_period_10g[8];
assign rx_period10g[9] = rx_period_10g[9];
assign rx_period10g[10] = rx_period_10g[10];
assign rx_period10g[11] = rx_period_10g[11];
assign rx_period10g[12] = rx_period_10g[12];
assign rx_period10g[13] = rx_period_10g[13];
assign rx_period10g[14] = rx_period_10g[14];
assign rx_period10g[15] = rx_period_10g[15];
assign rx_period10g[16] = rx_period_10g[16];
assign rx_period10g[17] = rx_period_10g[17];
assign rx_period10g[18] = rx_period_10g[18];
assign rx_period10g[19] = rx_period_10g[19];
assign rx_period10g[20] = 1'b0;
assign rx_period10g[21] = 1'b0;
assign rx_period10g[22] = 1'b0;
assign rx_period10g[23] = 1'b0;
assign rx_period10g[24] = 1'b0;
assign rx_period10g[25] = 1'b0;
assign rx_period10g[26] = 1'b0;
assign rx_period10g[27] = 1'b0;
assign rx_period10g[28] = 1'b0;
assign rx_period10g[29] = 1'b0;
assign rx_period10g[30] = 1'b0;
assign rx_period10g[31] = 1'b0;

assign rx_adjns_10g[0] = rx_adj_fracns_10g[0];
assign rx_adjns_10g[1] = rx_adj_fracns_10g[1];
assign rx_adjns_10g[2] = rx_adj_fracns_10g[2];
assign rx_adjns_10g[3] = rx_adj_fracns_10g[3];
assign rx_adjns_10g[4] = rx_adj_fracns_10g[4];
assign rx_adjns_10g[5] = rx_adj_fracns_10g[5];
assign rx_adjns_10g[6] = rx_adj_fracns_10g[6];
assign rx_adjns_10g[7] = rx_adj_fracns_10g[7];
assign rx_adjns_10g[8] = rx_adj_fracns_10g[8];
assign rx_adjns_10g[9] = rx_adj_fracns_10g[9];
assign rx_adjns_10g[10] = rx_adj_fracns_10g[10];
assign rx_adjns_10g[11] = rx_adj_fracns_10g[11];
assign rx_adjns_10g[12] = rx_adj_fracns_10g[12];
assign rx_adjns_10g[13] = rx_adj_fracns_10g[13];
assign rx_adjns_10g[14] = rx_adj_fracns_10g[14];
assign rx_adjns_10g[15] = rx_adj_fracns_10g[15];
assign rx_adjns_10g[16] = 1'b0;
assign rx_adjns_10g[17] = 1'b0;
assign rx_adjns_10g[18] = 1'b0;
assign rx_adjns_10g[19] = 1'b0;
assign rx_adjns_10g[20] = 1'b0;
assign rx_adjns_10g[21] = 1'b0;
assign rx_adjns_10g[22] = 1'b0;
assign rx_adjns_10g[23] = 1'b0;
assign rx_adjns_10g[24] = 1'b0;
assign rx_adjns_10g[25] = 1'b0;
assign rx_adjns_10g[26] = 1'b0;
assign rx_adjns_10g[27] = 1'b0;
assign rx_adjns_10g[28] = 1'b0;
assign rx_adjns_10g[29] = 1'b0;
assign rx_adjns_10g[30] = 1'b0;
assign rx_adjns_10g[31] = 1'b0;

assign rx_adjfracns_10g[0] = rx_adj_ns_10g[0];
assign rx_adjfracns_10g[1] = rx_adj_ns_10g[1];
assign rx_adjfracns_10g[2] = rx_adj_ns_10g[2];
assign rx_adjfracns_10g[3] = rx_adj_ns_10g[3];
assign rx_adjfracns_10g[4] = rx_adj_ns_10g[4];
assign rx_adjfracns_10g[5] = rx_adj_ns_10g[5];
assign rx_adjfracns_10g[6] = rx_adj_ns_10g[6];
assign rx_adjfracns_10g[7] = rx_adj_ns_10g[7];
assign rx_adjfracns_10g[8] = rx_adj_ns_10g[8];
assign rx_adjfracns_10g[9] = rx_adj_ns_10g[9];
assign rx_adjfracns_10g[10] = rx_adj_ns_10g[10];
assign rx_adjfracns_10g[11] = rx_adj_ns_10g[11];
assign rx_adjfracns_10g[12] = rx_adj_ns_10g[12];
assign rx_adjfracns_10g[13] = rx_adj_ns_10g[13];
assign rx_adjfracns_10g[14] = rx_adj_ns_10g[14];
assign rx_adjfracns_10g[15] = rx_adj_ns_10g[15];
assign rx_adjfracns_10g[16] = 1'b0;
assign rx_adjfracns_10g[17] = 1'b0;
assign rx_adjfracns_10g[18] = 1'b0;
assign rx_adjfracns_10g[19] = 1'b0;
assign rx_adjfracns_10g[20] = 1'b0;
assign rx_adjfracns_10g[21] = 1'b0;
assign rx_adjfracns_10g[22] = 1'b0;
assign rx_adjfracns_10g[23] = 1'b0;
assign rx_adjfracns_10g[24] = 1'b0;
assign rx_adjfracns_10g[25] = 1'b0;
assign rx_adjfracns_10g[26] = 1'b0;
assign rx_adjfracns_10g[27] = 1'b0;
assign rx_adjfracns_10g[28] = 1'b0;
assign rx_adjfracns_10g[29] = 1'b0;
assign rx_adjfracns_10g[30] = 1'b0;
assign rx_adjfracns_10g[31] = 1'b0;

assign rx_period1g[0] = rx_period_1g[0];
assign rx_period1g[1] = rx_period_1g[1];
assign rx_period1g[2] = rx_period_1g[2];
assign rx_period1g[3] = rx_period_1g[3];
assign rx_period1g[4] = rx_period_1g[4];
assign rx_period1g[5] = rx_period_1g[5];
assign rx_period1g[6] = rx_period_1g[6];
assign rx_period1g[7] = rx_period_1g[7];
assign rx_period1g[8] = rx_period_1g[8];
assign rx_period1g[9] = rx_period_1g[9];
assign rx_period1g[10] = rx_period_1g[10];
assign rx_period1g[11] = rx_period_1g[11];
assign rx_period1g[12] = rx_period_1g[12];
assign rx_period1g[13] = rx_period_1g[13];
assign rx_period1g[14] = rx_period_1g[14];
assign rx_period1g[15] = rx_period_1g[15];
assign rx_period1g[16] = rx_period_1g[16];
assign rx_period1g[17] = rx_period_1g[17];
assign rx_period1g[18] = rx_period_1g[18];
assign rx_period1g[19] = rx_period_1g[19];
assign rx_period1g[20] = 1'b0;
assign rx_period1g[21] = 1'b0;
assign rx_period1g[22] = 1'b0;
assign rx_period1g[23] = 1'b0;
assign rx_period1g[24] = 1'b0;
assign rx_period1g[25] = 1'b0;
assign rx_period1g[26] = 1'b0;
assign rx_period1g[27] = 1'b0;
assign rx_period1g[28] = 1'b0;
assign rx_period1g[29] = 1'b0;
assign rx_period1g[30] = 1'b0;
assign rx_period1g[31] = 1'b0;

assign rx_adjns_1g[0] = rx_adj_fracns_1g[0];
assign rx_adjns_1g[1] = rx_adj_fracns_1g[1];
assign rx_adjns_1g[2] = rx_adj_fracns_1g[2];
assign rx_adjns_1g[3] = rx_adj_fracns_1g[3];
assign rx_adjns_1g[4] = rx_adj_fracns_1g[4];
assign rx_adjns_1g[5] = rx_adj_fracns_1g[5];
assign rx_adjns_1g[6] = rx_adj_fracns_1g[6];
assign rx_adjns_1g[7] = rx_adj_fracns_1g[7];
assign rx_adjns_1g[8] = rx_adj_fracns_1g[8];
assign rx_adjns_1g[9] = rx_adj_fracns_1g[9];
assign rx_adjns_1g[10] = rx_adj_fracns_1g[10];
assign rx_adjns_1g[11] = rx_adj_fracns_1g[11];
assign rx_adjns_1g[12] = rx_adj_fracns_1g[12];
assign rx_adjns_1g[13] = rx_adj_fracns_1g[13];
assign rx_adjns_1g[14] = rx_adj_fracns_1g[14];
assign rx_adjns_1g[15] = rx_adj_fracns_1g[15];
assign rx_adjns_1g[16] = 1'b0;
assign rx_adjns_1g[17] = 1'b0;
assign rx_adjns_1g[18] = 1'b0;
assign rx_adjns_1g[19] = 1'b0;
assign rx_adjns_1g[20] = 1'b0;
assign rx_adjns_1g[21] = 1'b0;
assign rx_adjns_1g[22] = 1'b0;
assign rx_adjns_1g[23] = 1'b0;
assign rx_adjns_1g[24] = 1'b0;
assign rx_adjns_1g[25] = 1'b0;
assign rx_adjns_1g[26] = 1'b0;
assign rx_adjns_1g[27] = 1'b0;
assign rx_adjns_1g[28] = 1'b0;
assign rx_adjns_1g[29] = 1'b0;
assign rx_adjns_1g[30] = 1'b0;
assign rx_adjns_1g[31] = 1'b0;

assign rx_adjfracns_1g[0] = rx_adj_ns_1g[0];
assign rx_adjfracns_1g[1] = rx_adj_ns_1g[1];
assign rx_adjfracns_1g[2] = rx_adj_ns_1g[2];
assign rx_adjfracns_1g[3] = rx_adj_ns_1g[3];
assign rx_adjfracns_1g[4] = rx_adj_ns_1g[4];
assign rx_adjfracns_1g[5] = rx_adj_ns_1g[5];
assign rx_adjfracns_1g[6] = rx_adj_ns_1g[6];
assign rx_adjfracns_1g[7] = rx_adj_ns_1g[7];
assign rx_adjfracns_1g[8] = rx_adj_ns_1g[8];
assign rx_adjfracns_1g[9] = rx_adj_ns_1g[9];
assign rx_adjfracns_1g[10] = rx_adj_ns_1g[10];
assign rx_adjfracns_1g[11] = rx_adj_ns_1g[11];
assign rx_adjfracns_1g[12] = rx_adj_ns_1g[12];
assign rx_adjfracns_1g[13] = rx_adj_ns_1g[13];
assign rx_adjfracns_1g[14] = rx_adj_ns_1g[14];
assign rx_adjfracns_1g[15] = rx_adj_ns_1g[15];
assign rx_adjfracns_1g[16] = 1'b0;
assign rx_adjfracns_1g[17] = 1'b0;
assign rx_adjfracns_1g[18] = 1'b0;
assign rx_adjfracns_1g[19] = 1'b0;
assign rx_adjfracns_1g[20] = 1'b0;
assign rx_adjfracns_1g[21] = 1'b0;
assign rx_adjfracns_1g[22] = 1'b0;
assign rx_adjfracns_1g[23] = 1'b0;
assign rx_adjfracns_1g[24] = 1'b0;
assign rx_adjfracns_1g[25] = 1'b0;
assign rx_adjfracns_1g[26] = 1'b0;
assign rx_adjfracns_1g[27] = 1'b0;
assign rx_adjfracns_1g[28] = 1'b0;
assign rx_adjfracns_1g[29] = 1'b0;
assign rx_adjfracns_1g[30] = 1'b0;
assign rx_adjfracns_1g[31] = 1'b0;

assign rx_p2p_vd_ns[0] = rx_p2p_val_ns[0];
assign rx_p2p_vd_ns[1] = rx_p2p_val_ns[1];
assign rx_p2p_vd_ns[2] = rx_p2p_val_ns[2];
assign rx_p2p_vd_ns[3] = rx_p2p_val_ns[3];
assign rx_p2p_vd_ns[4] = rx_p2p_val_ns[4];
assign rx_p2p_vd_ns[5] = rx_p2p_val_ns[5];
assign rx_p2p_vd_ns[6] = rx_p2p_val_ns[6];
assign rx_p2p_vd_ns[7] = rx_p2p_val_ns[7];
assign rx_p2p_vd_ns[8] = rx_p2p_val_ns[8];
assign rx_p2p_vd_ns[9] = rx_p2p_val_ns[9];
assign rx_p2p_vd_ns[10] = rx_p2p_val_ns[10];
assign rx_p2p_vd_ns[11] = rx_p2p_val_ns[11];
assign rx_p2p_vd_ns[12] = rx_p2p_val_ns[12];
assign rx_p2p_vd_ns[13] = rx_p2p_val_ns[13];
assign rx_p2p_vd_ns[14] = rx_p2p_val_ns[14];
assign rx_p2p_vd_ns[15] = rx_p2p_val_ns[15];
assign rx_p2p_vd_ns[16] = rx_p2p_val_ns[16];
assign rx_p2p_vd_ns[17] = rx_p2p_val_ns[17];
assign rx_p2p_vd_ns[18] = rx_p2p_val_ns[18];
assign rx_p2p_vd_ns[19] = rx_p2p_val_ns[19];
assign rx_p2p_vd_ns[20] = rx_p2p_val_ns[20];
assign rx_p2p_vd_ns[21] = rx_p2p_val_ns[21];
assign rx_p2p_vd_ns[22] = rx_p2p_val_ns[22];
assign rx_p2p_vd_ns[23] = rx_p2p_val_ns[23];
assign rx_p2p_vd_ns[24] = rx_p2p_val_ns[24];
assign rx_p2p_vd_ns[25] = rx_p2p_val_ns[25];
assign rx_p2p_vd_ns[26] = rx_p2p_val_ns[26];
assign rx_p2p_vd_ns[27] = rx_p2p_val_ns[27];
assign rx_p2p_vd_ns[28] = rx_p2p_val_ns[28];
assign rx_p2p_vd_ns[29] = rx_p2p_val_ns[29];
assign rx_p2p_vd_ns[30] = rx_p2p_val_valid;
assign rx_p2p_vd_ns[31] = 1'b0;

assign rx_p2p_fns[0] = rx_p2p_val_fns[0];
assign rx_p2p_fns[1] = rx_p2p_val_fns[1];
assign rx_p2p_fns[2] = rx_p2p_val_fns[2];
assign rx_p2p_fns[3] = rx_p2p_val_fns[3];
assign rx_p2p_fns[4] = rx_p2p_val_fns[4];
assign rx_p2p_fns[5] = rx_p2p_val_fns[5];
assign rx_p2p_fns[6] = rx_p2p_val_fns[6];
assign rx_p2p_fns[7] = rx_p2p_val_fns[7];
assign rx_p2p_fns[8] = rx_p2p_val_fns[8];
assign rx_p2p_fns[9] = rx_p2p_val_fns[9];
assign rx_p2p_fns[10] = rx_p2p_val_fns[10];
assign rx_p2p_fns[11] = rx_p2p_val_fns[11];
assign rx_p2p_fns[12] = rx_p2p_val_fns[12];
assign rx_p2p_fns[13] = rx_p2p_val_fns[13];
assign rx_p2p_fns[14] = rx_p2p_val_fns[14];
assign rx_p2p_fns[15] = rx_p2p_val_fns[15];
assign rx_p2p_fns[16] = 1'b0;
assign rx_p2p_fns[17] = 1'b0;
assign rx_p2p_fns[18] = 1'b0;
assign rx_p2p_fns[19] = 1'b0;
assign rx_p2p_fns[20] = 1'b0;
assign rx_p2p_fns[21] = 1'b0;
assign rx_p2p_fns[22] = 1'b0;
assign rx_p2p_fns[23] = 1'b0;
assign rx_p2p_fns[24] = 1'b0;
assign rx_p2p_fns[25] = 1'b0;
assign rx_p2p_fns[26] = 1'b0;
assign rx_p2p_fns[27] = 1'b0;
assign rx_p2p_fns[28] = 1'b0;
assign rx_p2p_fns[29] = 1'b0;
assign rx_p2p_fns[30] = 1'b0;
assign rx_p2p_fns[31] = 1'b0;

assign ecc_status[0] = ecc_corrected_err;
assign ecc_status[1] = ecc_fatal_err;
assign ecc_status[2] = 1'b0;
assign ecc_status[3] = 1'b0;
assign ecc_status[4] = 1'b0;
assign ecc_status[5] = 1'b0;
assign ecc_status[6] = 1'b0;
assign ecc_status[7] = 1'b0;
assign ecc_status[8] = 1'b0;
assign ecc_status[9] = 1'b0;
assign ecc_status[10] = 1'b0;
assign ecc_status[11] = 1'b0;
assign ecc_status[12] = 1'b0;
assign ecc_status[13] = 1'b0;
assign ecc_status[14] = 1'b0;
assign ecc_status[15] = 1'b0;
assign ecc_status[16] = 1'b0;
assign ecc_status[17] = 1'b0;
assign ecc_status[18] = 1'b0;
assign ecc_status[19] = 1'b0;
assign ecc_status[20] = 1'b0;
assign ecc_status[21] = 1'b0;
assign ecc_status[22] = 1'b0;
assign ecc_status[23] = 1'b0;
assign ecc_status[24] = 1'b0;
assign ecc_status[25] = 1'b0;
assign ecc_status[26] = 1'b0;
assign ecc_status[27] = 1'b0;
assign ecc_status[28] = 1'b0;
assign ecc_status[29] = 1'b0;
assign ecc_status[30] = 1'b0;
assign ecc_status[31] = 1'b0;

assign ecc_status_ena[0] = ecc_corrected_err_ena;
assign ecc_status_ena[1] = ecc_fatal_err_ena;
assign ecc_status_ena[2] = 1'b0;
assign ecc_status_ena[3] = 1'b0;
assign ecc_status_ena[4] = 1'b0;
assign ecc_status_ena[5] = 1'b0;
assign ecc_status_ena[6] = 1'b0;
assign ecc_status_ena[7] = 1'b0;
assign ecc_status_ena[8] = 1'b0;
assign ecc_status_ena[9] = 1'b0;
assign ecc_status_ena[10] = 1'b0;
assign ecc_status_ena[11] = 1'b0;
assign ecc_status_ena[12] = 1'b0;
assign ecc_status_ena[13] = 1'b0;
assign ecc_status_ena[14] = 1'b0;
assign ecc_status_ena[15] = 1'b0;
assign ecc_status_ena[16] = 1'b0;
assign ecc_status_ena[17] = 1'b0;
assign ecc_status_ena[18] = 1'b0;
assign ecc_status_ena[19] = 1'b0;
assign ecc_status_ena[20] = 1'b0;
assign ecc_status_ena[21] = 1'b0;
assign ecc_status_ena[22] = 1'b0;
assign ecc_status_ena[23] = 1'b0;
assign ecc_status_ena[24] = 1'b0;
assign ecc_status_ena[25] = 1'b0;
assign ecc_status_ena[26] = 1'b0;
assign ecc_status_ena[27] = 1'b0;
assign ecc_status_ena[28] = 1'b0;
assign ecc_status_ena[29] = 1'b0;
assign ecc_status_ena[30] = 1'b0;
assign ecc_status_ena[31] = 1'b0;

assign test_mode[0] = tx_adptdcff_rdwtrmrk_dis;
assign test_mode[1] = tx_adptdcff_rdwtrmrk[0];
assign test_mode[2] = tx_adptdcff_rdwtrmrk[1];
assign test_mode[3] = tx_adptdcff_rdwtrmrk[2];
assign test_mode[4] = 1'b0;
assign test_mode[5] = 1'b0;
assign test_mode[6] = 1'b0;
assign test_mode[7] = 1'b0;
assign test_mode[8] = 1'b0;
assign test_mode[9] = 1'b0;
assign test_mode[10] = 1'b0;
assign test_mode[11] = 1'b0;
assign test_mode[12] = 1'b0;
assign test_mode[13] = 1'b0;
assign test_mode[14] = 1'b0;
assign test_mode[15] = 1'b0;
assign test_mode[16] = 1'b0;
assign test_mode[17] = tx_adptdcff_vldpkt_minwt[0];
assign test_mode[18] = tx_adptdcff_vldpkt_minwt[1];
assign test_mode[19] = tx_adptdcff_vldpkt_minwt[2];
assign test_mode[20] = 1'b0;
assign test_mode[21] = 1'b0;
assign test_mode[22] = 1'b0;
assign test_mode[23] = 1'b0;
assign test_mode[24] = 1'b0;
assign test_mode[25] = 1'b0;
assign test_mode[26] = 1'b0;
assign test_mode[27] = 1'b0;
assign test_mode[28] = 1'b0;
assign test_mode[29] = 1'b0;
assign test_mode[30] = 1'b0;
assign test_mode[31] = 1'b0;

generate if (SYNC_RESET_N == 1) begin
always @(posedge csr_clk ) begin
    if(!csr_clk_rst_n) begin
        avs_readdata <= 32'h0000_0000;
    end
    else begin
        if(avs_read) begin
            case (avs_address)
                10'h000 : avs_readdata <= rev_id;
                10'h002 : avs_readdata <= capability;
                10'h010 : avs_readdata <= pri_macaddr_lower;
                10'h011 : avs_readdata <= pri_macaddr_1_upper;
                10'h01E : avs_readdata <= mac_common_status;
                10'h01F : avs_readdata <= data_path_reset;
                10'h020 : avs_readdata <= tx_pktctl;
                10'h022 : avs_readdata <= tx_pktsts;
                10'h024 : avs_readdata <= tx_padctl;
                10'h026 : avs_readdata <= tx_crcctl;
                10'h028 : avs_readdata <= tx_preambctl;
                10'h02A : avs_readdata <= tx_sa_override;
                10'h02C : avs_readdata <= tx_frmctl;
                10'h02D : avs_readdata <= txvlandetection_dis;
                10'h02E : avs_readdata <= tx_pipg_10g;
                10'h02F : avs_readdata <= tx_pipg_1g;
                10'h03E : avs_readdata <= tx_udf_stat_0;
                10'h03F : avs_readdata <= tx_udf_stat_1;
                10'h040 : avs_readdata <= tx_pausectl;
                10'h042 : avs_readdata <= tx_pausefrm_pq;
                10'h043 : avs_readdata <= tx_pausefrm_hqt;
                10'h044 : avs_readdata <= tx_pausefrm_genctl;
                10'h046 : avs_readdata <= tx_pfcfrm_en;
                10'h048 : avs_readdata <= tx_pfcfrm_pq0;
                10'h049 : avs_readdata <= tx_pfcfrm_pq1;
                10'h04A : avs_readdata <= tx_pfcfrm_pq2;
                10'h04B : avs_readdata <= tx_pfcfrm_pq3;
                10'h04C : avs_readdata <= tx_pfcfrm_pq4;
                10'h04D : avs_readdata <= tx_pfcfrm_pq5;
                10'h04E : avs_readdata <= tx_pfcfrm_pq6;
                10'h04F : avs_readdata <= tx_pfcfrm_pq7;
                10'h058 : avs_readdata <= tx_pfcfrm_hq0;
                10'h059 : avs_readdata <= tx_pfcfrm_hq1;
                10'h05A : avs_readdata <= tx_pfcfrm_hq2;
                10'h05B : avs_readdata <= tx_pfcfrm_hq3;
                10'h05C : avs_readdata <= tx_pfcfrm_hq4;
                10'h05D : avs_readdata <= tx_pfcfrm_hq5;
                10'h05E : avs_readdata <= tx_pfcfrm_hq6;
                10'h05F : avs_readdata <= tx_pfcfrm_hq7;
                10'h070 : avs_readdata <= tx_unidirectional_feature;
                10'h0A0 : avs_readdata <= rx_pktctl;
                10'h0A2 : avs_readdata <= rx_pktsts;
                10'h0A4 : avs_readdata <= rx_crcpad_ctl;
                10'h0A6 : avs_readdata <= rx_crc_ctl;
                10'h0A8 : avs_readdata <= rx_preamb_fwd_ctl;
                10'h0AA : avs_readdata <= rx_preamb_pt;
                10'h0AC : avs_readdata <= rx_frm_ctl;
                10'h0AE : avs_readdata <= rx_frm_ctl_maxlen;
                10'h0AF : avs_readdata <= rxvlandetection_dis;
                10'h0B0 : avs_readdata <= rx_supp_macaddr_lower_0;
                10'h0B1 : avs_readdata <= rx_supp_macaddr_upper_0;
                10'h0B2 : avs_readdata <= rx_supp_macaddr_lower_1;
                10'h0B3 : avs_readdata <= rx_supp_macaddr_upper_1;
                10'h0B4 : avs_readdata <= rx_supp_macaddr_lower_2;
                10'h0B5 : avs_readdata <= rx_supp_macaddr_upper_2;
                10'h0B6 : avs_readdata <= rx_supp_macaddr_lower_3;
                10'h0B7 : avs_readdata <= rx_supp_macaddr_upper_3;
                10'h0C0 : avs_readdata <= rx_pfc_ctl;
                10'h0FC : avs_readdata <= rx_pkt_ovrflw_errcnt_lower;
                10'h0FD : avs_readdata <= rx_pkt_ovrflw_errcnt_upper;
                10'h0FE : avs_readdata <= rx_pkt_ovrflw_etherstatsdropevents_lower;
                10'h0FF : avs_readdata <= rx_pkt_ovrflw_etherstatsdropevents_upper;
                10'h100 : avs_readdata <= tx_period10g;
                10'h102 : avs_readdata <= tx_adjns_10g;
                10'h104 : avs_readdata <= tx_adjfracns_10g;
                10'h108 : avs_readdata <= tx_period1g;
                10'h10A : avs_readdata <= tx_adjns_1g;
                10'h10C : avs_readdata <= tx_adjfracns_1g;
                10'h110 : avs_readdata <= tx_asymm;
                10'h112 : avs_readdata <= tx_p2p_dir;
                10'h114 : avs_readdata <= cf_error;
                10'h120 : avs_readdata <= rx_period10g;
                10'h122 : avs_readdata <= rx_adjns_10g;
                10'h124 : avs_readdata <= rx_adjfracns_10g;
                10'h128 : avs_readdata <= rx_period1g;
                10'h12A : avs_readdata <= rx_adjns_1g;
                10'h12C : avs_readdata <= rx_adjfracns_1g;
                10'h12E : avs_readdata <= rx_p2p_vd_ns;
                10'h130 : avs_readdata <= rx_p2p_fns;
                10'h240 : avs_readdata <= ecc_status;
                10'h241 : avs_readdata <= ecc_status_ena;
                10'h3F0 : avs_readdata <= test_mode;
                default : avs_readdata <= 32'h0000_0000;
            endcase
        end
        else begin
            avs_readdata <= avs_readdata;
        end
    end
end
end else begin
always @(posedge csr_clk or negedge csr_clk_rst_n) begin
    if(!csr_clk_rst_n) begin
        avs_readdata <= 32'h0000_0000;
    end
    else begin
        if(avs_read) begin
            case (avs_address)
                10'h000 : avs_readdata <= rev_id;
                10'h002 : avs_readdata <= capability;
                10'h010 : avs_readdata <= pri_macaddr_lower;
                10'h011 : avs_readdata <= pri_macaddr_1_upper;
                10'h01E : avs_readdata <= mac_common_status;
                10'h01F : avs_readdata <= data_path_reset;
                10'h020 : avs_readdata <= tx_pktctl;
                10'h022 : avs_readdata <= tx_pktsts;
                10'h024 : avs_readdata <= tx_padctl;
                10'h026 : avs_readdata <= tx_crcctl;
                10'h028 : avs_readdata <= tx_preambctl;
                10'h02A : avs_readdata <= tx_sa_override;
                10'h02C : avs_readdata <= tx_frmctl;
                10'h02D : avs_readdata <= txvlandetection_dis;
                10'h02E : avs_readdata <= tx_pipg_10g;
                10'h02F : avs_readdata <= tx_pipg_1g;
                10'h03E : avs_readdata <= tx_udf_stat_0;
                10'h03F : avs_readdata <= tx_udf_stat_1;
                10'h040 : avs_readdata <= tx_pausectl;
                10'h042 : avs_readdata <= tx_pausefrm_pq;
                10'h043 : avs_readdata <= tx_pausefrm_hqt;
                10'h044 : avs_readdata <= tx_pausefrm_genctl;
                10'h046 : avs_readdata <= tx_pfcfrm_en;
                10'h048 : avs_readdata <= tx_pfcfrm_pq0;
                10'h049 : avs_readdata <= tx_pfcfrm_pq1;
                10'h04A : avs_readdata <= tx_pfcfrm_pq2;
                10'h04B : avs_readdata <= tx_pfcfrm_pq3;
                10'h04C : avs_readdata <= tx_pfcfrm_pq4;
                10'h04D : avs_readdata <= tx_pfcfrm_pq5;
                10'h04E : avs_readdata <= tx_pfcfrm_pq6;
                10'h04F : avs_readdata <= tx_pfcfrm_pq7;
                10'h058 : avs_readdata <= tx_pfcfrm_hq0;
                10'h059 : avs_readdata <= tx_pfcfrm_hq1;
                10'h05A : avs_readdata <= tx_pfcfrm_hq2;
                10'h05B : avs_readdata <= tx_pfcfrm_hq3;
                10'h05C : avs_readdata <= tx_pfcfrm_hq4;
                10'h05D : avs_readdata <= tx_pfcfrm_hq5;
                10'h05E : avs_readdata <= tx_pfcfrm_hq6;
                10'h05F : avs_readdata <= tx_pfcfrm_hq7;
                10'h070 : avs_readdata <= tx_unidirectional_feature;
                10'h0A0 : avs_readdata <= rx_pktctl;
                10'h0A2 : avs_readdata <= rx_pktsts;
                10'h0A4 : avs_readdata <= rx_crcpad_ctl;
                10'h0A6 : avs_readdata <= rx_crc_ctl;
                10'h0A8 : avs_readdata <= rx_preamb_fwd_ctl;
                10'h0AA : avs_readdata <= rx_preamb_pt;
                10'h0AC : avs_readdata <= rx_frm_ctl;
                10'h0AE : avs_readdata <= rx_frm_ctl_maxlen;
                10'h0AF : avs_readdata <= rxvlandetection_dis;
                10'h0B0 : avs_readdata <= rx_supp_macaddr_lower_0;
                10'h0B1 : avs_readdata <= rx_supp_macaddr_upper_0;
                10'h0B2 : avs_readdata <= rx_supp_macaddr_lower_1;
                10'h0B3 : avs_readdata <= rx_supp_macaddr_upper_1;
                10'h0B4 : avs_readdata <= rx_supp_macaddr_lower_2;
                10'h0B5 : avs_readdata <= rx_supp_macaddr_upper_2;
                10'h0B6 : avs_readdata <= rx_supp_macaddr_lower_3;
                10'h0B7 : avs_readdata <= rx_supp_macaddr_upper_3;
                10'h0C0 : avs_readdata <= rx_pfc_ctl;
                10'h0FC : avs_readdata <= rx_pkt_ovrflw_errcnt_lower;
                10'h0FD : avs_readdata <= rx_pkt_ovrflw_errcnt_upper;
                10'h0FE : avs_readdata <= rx_pkt_ovrflw_etherstatsdropevents_lower;
                10'h0FF : avs_readdata <= rx_pkt_ovrflw_etherstatsdropevents_upper;
                10'h100 : avs_readdata <= tx_period10g;
                10'h102 : avs_readdata <= tx_adjns_10g;
                10'h104 : avs_readdata <= tx_adjfracns_10g;
                10'h108 : avs_readdata <= tx_period1g;
                10'h10A : avs_readdata <= tx_adjns_1g;
                10'h10C : avs_readdata <= tx_adjfracns_1g;
                10'h110 : avs_readdata <= tx_asymm;
                10'h112 : avs_readdata <= tx_p2p_dir;
                10'h114 : avs_readdata <= cf_error;
                10'h120 : avs_readdata <= rx_period10g;
                10'h122 : avs_readdata <= rx_adjns_10g;
                10'h124 : avs_readdata <= rx_adjfracns_10g;
                10'h128 : avs_readdata <= rx_period1g;
                10'h12A : avs_readdata <= rx_adjns_1g;
                10'h12C : avs_readdata <= rx_adjfracns_1g;
                10'h12E : avs_readdata <= rx_p2p_vd_ns;
                10'h130 : avs_readdata <= rx_p2p_fns;
                10'h240 : avs_readdata <= ecc_status;
                10'h241 : avs_readdata <= ecc_status_ena;
                10'h3F0 : avs_readdata <= test_mode;
                default : avs_readdata <= 32'h0000_0000;
            endcase
        end
        else begin
            avs_readdata <= avs_readdata;
        end
    end
end
end 
endgenerate

endmodule

