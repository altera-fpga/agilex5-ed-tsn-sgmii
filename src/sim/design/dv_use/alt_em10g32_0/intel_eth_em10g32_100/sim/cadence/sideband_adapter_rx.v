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
module sideband_adapter_rx ( 
      // Interface: clk
      clk,
      // Interface: reset
      reset_n,

      //RX PFC Status Signals
      in_avalon_st_rx_pfc_pause_data,
      in_avalon_st_rx_pfc_status_valid,
      in_avalon_st_rx_pfc_status_data,      
      
      out_avalon_st_rx_pfc_pause_data,
      out_avalon_st_rx_pfc_status_valid,
      out_avalon_st_rx_pfc_status_data,
      
      // Pause Quanta (For RX only variant)
      in_avalon_st_rx_pause_length_valid,
      in_avalon_st_rx_pause_length_data,  
      
      out_avalon_st_rx_pause_length_valid,
      out_avalon_st_rx_pause_length_data

);
    
    // Interface: clk
    input              clk;
    // Interface: reset
    input              reset_n;

    //RX PFC Status Signals
    input      [7:0]                   in_avalon_st_rx_pfc_pause_data;
    input                              in_avalon_st_rx_pfc_status_valid;
    input      [15:0]                  in_avalon_st_rx_pfc_status_data;     

    output     [7:0]                   out_avalon_st_rx_pfc_pause_data;
    output reg                         out_avalon_st_rx_pfc_status_valid /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output reg [15:0]                  out_avalon_st_rx_pfc_status_data /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;

    // Pause Quanta (For RX only variant)
    input wire                        in_avalon_st_rx_pause_length_valid;
    input wire [15:0]                 in_avalon_st_rx_pause_length_data; 

    output reg                        out_avalon_st_rx_pause_length_valid /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;
    output reg [15:0]                 out_avalon_st_rx_pause_length_data /* synthesis altera_attribute="suppress_da_rule_internal=D101" */;




   // ---------------------------------------------------------------------
   //| Signal Declarations
   // ---------------------------------------------------------------------
   reg                              hold_rxpfcstatus;
   reg                              hold_rxpfclength;
   

   //RX PFC signals
   assign out_avalon_st_rx_pfc_pause_data = in_avalon_st_rx_pfc_pause_data;
   
 
   //retain RX PFC Status output signals to client for 2 cycles
   always @(posedge clk) begin
      if (!reset_n) begin 
         hold_rxpfcstatus <= 1'b0;
      end else begin
         hold_rxpfcstatus <= in_avalon_st_rx_pfc_status_valid;
      end
   end      
   
   always @(posedge clk) begin
      if (!reset_n) begin   
         out_avalon_st_rx_pfc_status_valid <= 1'b0;
         out_avalon_st_rx_pfc_status_data  <= 16'b0;
      end else begin
         if (hold_rxpfcstatus) begin
            out_avalon_st_rx_pfc_status_valid <= out_avalon_st_rx_pfc_status_valid;
            out_avalon_st_rx_pfc_status_data  <= out_avalon_st_rx_pfc_status_data;
         end else begin
            out_avalon_st_rx_pfc_status_valid <= in_avalon_st_rx_pfc_status_valid;
            out_avalon_st_rx_pfc_status_data  <= in_avalon_st_rx_pfc_status_data;
         end      
      end
   end    

   //retain RX PFC Lenght output signals to client for 2 cycles
   always @(posedge clk) begin
      if (!reset_n) begin 
         hold_rxpfclength <= 1'b0;
      end else begin
         hold_rxpfclength <= in_avalon_st_rx_pause_length_valid;
      end
   end      
   
   always @(posedge clk) begin
      if (!reset_n) begin   
         out_avalon_st_rx_pause_length_valid <= 1'b0;
         out_avalon_st_rx_pause_length_data  <= 16'b0;
      end else begin
         if (hold_rxpfclength) begin
            out_avalon_st_rx_pause_length_valid <= out_avalon_st_rx_pause_length_valid;
            out_avalon_st_rx_pause_length_data  <= out_avalon_st_rx_pause_length_data;
         end else begin
            out_avalon_st_rx_pause_length_valid <= in_avalon_st_rx_pfc_status_valid;
            out_avalon_st_rx_pause_length_data  <= in_avalon_st_rx_pause_length_data;
         end      
      end
   end     
   
   
endmodule

