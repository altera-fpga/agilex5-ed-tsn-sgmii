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


// --------------------------------------------------------------------------------
//| Avalon Streaming Data Format Adapter
// --------------------------------------------------------------------------------

`timescale 1ns / 100ps
module sideband_adapter_tx # ( 
      parameter TSTAMP_FP_WIDTH = 4
) ( 
      // Interface: clk
      clk,
      // Interface: reset
      reset_n,

      // 1588 signals
      out_tx_egress_timestamp_96b_data,
      out_tx_egress_timestamp_96b_valid,
      out_tx_egress_timestamp_96b_fingerprint,
      out_tx_egress_timestamp_64b_data,
      out_tx_egress_timestamp_64b_valid,
      out_tx_egress_timestamp_64b_fingerprint,

      in_tx_egress_timestamp_96b_data,
      in_tx_egress_timestamp_96b_valid,
      in_tx_egress_timestamp_96b_fingerprint,
      in_tx_egress_timestamp_64b_data,
      in_tx_egress_timestamp_64b_valid,
      in_tx_egress_timestamp_64b_fingerprint,

      //TX Status Signals
      out_avalon_st_txstatus_valid,
      out_avalon_st_txstatus_data,
      out_avalon_st_txstatus_error,
      
      in_avalon_st_txstatus_valid,
      in_avalon_st_txstatus_data,
      in_avalon_st_txstatus_error,      

      in_avalon_st_tx_pfc_data,       
      out_avalon_st_tx_pfc_status_valid,
      out_avalon_st_tx_pfc_status,

      out_avalon_st_tx_pfc_data,       
      in_avalon_st_tx_pfc_status_valid,
      in_avalon_st_tx_pfc_status,

	  //TX Pause Data
      in_avalon_st_tx_pause_data,
	  out_avalon_st_tx_pause_data,

      // Pause Quanta (For TX only variant)
      in_avalon_st_tx_pause_length_valid,
      in_avalon_st_tx_pause_length_data,
      
      out_avalon_st_tx_pause_length_valid,
      out_avalon_st_tx_pause_length_data
);

    // Interface: clk
    input              clk;
    // Interface: reset
    input              reset_n;

    // 1588 signals
    output  reg [95:0]                 out_tx_egress_timestamp_96b_data /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg                        out_tx_egress_timestamp_96b_valid /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg [TSTAMP_FP_WIDTH-1:0]  out_tx_egress_timestamp_96b_fingerprint /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg [63:0]                 out_tx_egress_timestamp_64b_data /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg                        out_tx_egress_timestamp_64b_valid /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg [TSTAMP_FP_WIDTH-1:0]  out_tx_egress_timestamp_64b_fingerprint /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;

    input       [95:0]                 in_tx_egress_timestamp_96b_data;
    input                              in_tx_egress_timestamp_96b_valid;
    input       [TSTAMP_FP_WIDTH-1:0]  in_tx_egress_timestamp_96b_fingerprint;
    input       [63:0]                 in_tx_egress_timestamp_64b_data;
    input                              in_tx_egress_timestamp_64b_valid;
    input       [TSTAMP_FP_WIDTH-1:0]  in_tx_egress_timestamp_64b_fingerprint;

    //TX Status Signals
    output  reg                        out_avalon_st_txstatus_valid /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg [39:0]                 out_avalon_st_txstatus_data /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output  reg [6:0]                  out_avalon_st_txstatus_error /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;

    input                              in_avalon_st_txstatus_valid;
    input       [39:0]                 in_avalon_st_txstatus_data;
    input       [6:0]                  in_avalon_st_txstatus_error;

    input       [15:0]                 in_avalon_st_tx_pfc_data;
    output reg                         out_avalon_st_tx_pfc_status_valid /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output reg  [15:0]                 out_avalon_st_tx_pfc_status /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;

    output      [15:0]                 out_avalon_st_tx_pfc_data;
    input                              in_avalon_st_tx_pfc_status_valid;
    input       [15:0]                 in_avalon_st_tx_pfc_status;

    //TX Pause Data
    input 	[1:0]					 in_avalon_st_tx_pause_data;
    output	[1:0]					 out_avalon_st_tx_pause_data;

    // Pause Quanta (For TX only variant)
    input  wire                        in_avalon_st_tx_pause_length_valid;
    input  wire [15:0]                 in_avalon_st_tx_pause_length_data;

    output  reg                        out_avalon_st_tx_pause_length_valid;
    output  reg [15:0]                 out_avalon_st_tx_pause_length_data;


   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------
   reg                         hold_1588_data;
   reg                         hold_txstatus_data;
   reg                         hold_txpfc_data;
   
   assign out_avalon_st_tx_pfc_data = in_avalon_st_tx_pfc_data;
   assign out_avalon_st_tx_pause_data = in_avalon_st_tx_pause_data;
  
    
   //retain 1588 output signals to client for 2 cycles
   always @(posedge clk) begin
      if (!reset_n) begin 
         hold_1588_data <= 1'b0;
      end else begin
         hold_1588_data <= in_tx_egress_timestamp_96b_valid | in_tx_egress_timestamp_64b_valid;
      end
   end      
   
   always @(posedge clk) begin
      if (!reset_n) begin   
         out_tx_egress_timestamp_96b_data        <= 96'b0;
         out_tx_egress_timestamp_96b_valid       <= 1'b0;
         out_tx_egress_timestamp_96b_fingerprint <= {TSTAMP_FP_WIDTH{1'b0}};
         out_tx_egress_timestamp_64b_data        <= 64'b0;
         out_tx_egress_timestamp_64b_valid       <= 1'b0;
         out_tx_egress_timestamp_64b_fingerprint <= {TSTAMP_FP_WIDTH{1'b0}};
      end else begin
         if (hold_1588_data) begin
            out_tx_egress_timestamp_96b_data        <= out_tx_egress_timestamp_96b_data;
            out_tx_egress_timestamp_96b_valid       <= out_tx_egress_timestamp_96b_valid;
            out_tx_egress_timestamp_96b_fingerprint <= out_tx_egress_timestamp_96b_fingerprint;
            out_tx_egress_timestamp_64b_data        <= out_tx_egress_timestamp_64b_data;
            out_tx_egress_timestamp_64b_valid       <= out_tx_egress_timestamp_64b_valid;
            out_tx_egress_timestamp_64b_fingerprint <= out_tx_egress_timestamp_64b_fingerprint;         
         end else begin
            out_tx_egress_timestamp_96b_data        <= in_tx_egress_timestamp_96b_data;
            out_tx_egress_timestamp_96b_valid       <= in_tx_egress_timestamp_96b_valid;
            out_tx_egress_timestamp_96b_fingerprint <= in_tx_egress_timestamp_96b_fingerprint;
            out_tx_egress_timestamp_64b_data        <= in_tx_egress_timestamp_64b_data;
            out_tx_egress_timestamp_64b_valid       <= in_tx_egress_timestamp_64b_valid;
            out_tx_egress_timestamp_64b_fingerprint <= in_tx_egress_timestamp_64b_fingerprint;          
         end      
      end
   end
   
   //retain TX Status output signals to client for 2 cycles
   always @(posedge clk) begin
      if (!reset_n) begin 
         hold_txstatus_data <= 1'b0;
      end else begin
         hold_txstatus_data <= in_avalon_st_txstatus_valid;
      end
   end      
   
   always @(posedge clk) begin
      if (!reset_n) begin   
         out_avalon_st_txstatus_valid <= 1'b0;
         out_avalon_st_txstatus_data  <= 40'b0;
         out_avalon_st_txstatus_error <= 7'b0;
      end else begin
         if (hold_txstatus_data) begin
            out_avalon_st_txstatus_valid <= out_avalon_st_txstatus_valid;
            out_avalon_st_txstatus_data  <= out_avalon_st_txstatus_data;
            out_avalon_st_txstatus_error <= out_avalon_st_txstatus_error;        
         end else begin
            out_avalon_st_txstatus_valid <= in_avalon_st_txstatus_valid;
            out_avalon_st_txstatus_data  <= in_avalon_st_txstatus_data;
            out_avalon_st_txstatus_error <= in_avalon_st_txstatus_error;         
         end      
      end
   end

   //retain TX PFC Status output signals to client for 2 cycles
   always @(posedge clk) begin
      if (!reset_n) begin 
         hold_txpfc_data <= 1'b0;
      end else begin
         hold_txpfc_data <= in_avalon_st_tx_pfc_status_valid;
      end
   end      
   
   always @(posedge clk) begin
      if (!reset_n) begin   
         out_avalon_st_tx_pfc_status_valid <= 1'b0;
         out_avalon_st_tx_pfc_status  <= 16'b0;
      end else begin
         if (hold_txpfc_data) begin
            out_avalon_st_tx_pfc_status_valid <= out_avalon_st_tx_pfc_status_valid;
            out_avalon_st_tx_pfc_status  <= out_avalon_st_tx_pfc_status;
         end else begin
            out_avalon_st_tx_pfc_status_valid <= in_avalon_st_tx_pfc_status_valid;
            out_avalon_st_tx_pfc_status  <= in_avalon_st_tx_pfc_status;
         end      
      end
   end
   
   
   always @(posedge clk) begin
      if (!reset_n) begin   
         out_avalon_st_tx_pause_length_data        <= 16'b0;
         out_avalon_st_tx_pause_length_valid       <= 1'b0;
      end else begin
         if (out_avalon_st_tx_pause_length_valid) begin
            out_avalon_st_tx_pause_length_valid       <= 1'b0;
         end else begin
            out_avalon_st_tx_pause_length_valid       <= in_avalon_st_tx_pause_length_valid;
         end 
         out_avalon_st_tx_pause_length_data        <= in_avalon_st_tx_pause_length_data;         
      end
   end   
endmodule

