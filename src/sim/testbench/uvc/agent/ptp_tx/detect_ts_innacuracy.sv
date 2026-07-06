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


/*
This module was implemented by Gustavo Rodriguez for FB case 481465. The purpose of this module is to detect when packets starting in oen of the 4 affected virtual lane slots of each alignment marker cycle, and indicates that the packet should be either dropped, or have an additional -330 UI subtracted from the timestamp. For more details see section 5.3.5.2 in the FS.
*/
module detect_ts_innacuracy (
  input logic   [3:0]   i_rx_am,
  input logic           i_rx_sop,
  input logic           i_rx_valid,
  input logic           i_rx_clk,
  input logic           i_rx_rst_n,
  output logic          o_correct_this_ts,
  output logic [15:0]   o_pkt_count
);

  logic         [3:0]   vl_position;
  logic                 am_detect_r;
  logic                 am_detect_rise;
  logic         [3:0]   count='d0;
  logic         [15:0]  pkt_count;



  //Set the vl_position based on the configuration of the RX MAC. If remove
  //pads or enforce max frame size is on, VL_POSITION is 4, otherwise it is
  //3, due to the latency added by the pad stripper
  /* assign  vl_position =  i_cfg.rxmac_control.remove_rx_pad   ?   4'd4:
                            i_cfg.rxmac_control.enforce_max_rx  ?   4'd4: 4'd3;*/
  //can not find control signal for now 
  //TODO add control signal in.
  assign  vl_position =   4'd4; 
 
  //Sample o_rx_am using the clock to find a 0->1 transition. Do not use
  //data valid for this sample
  always_ff @(posedge i_rx_clk or negedge i_rx_rst_n)
  if(~i_rx_rst_n)    am_detect_r <=  1'b0;
  else            am_detect_r <=  i_rx_am[0];
 
 
  assign  am_detect_rise  =   i_rx_am[0]          //am high
                              && !am_detect_r     //..was low
                              && (count == '1);   //..and was waiting for am
 
 
  //Count valid cycles to find the first cycle of data after the AMs
  always_ff @(posedge i_rx_clk or negedge i_rx_rst_n)
  if(~i_rx_rst_n) count  <=  '1;
  else         count  <=  am_detect_rise ?    '0:         //Reset
                          !i_rx_valid ?       count:      //Freeze
                          (count == '1)  ?    count:      //Saturate
                                              (count+1);  //Increment

  always_ff @(posedge i_rx_clk or negedge i_rx_rst_n) begin
     if(~i_rx_rst_n) begin
        pkt_count  <=  16'h0;
     end else if(i_rx_sop && i_rx_valid) begin
        pkt_count <= pkt_count + 1;
     end
  end

  //If sof occurs on a cycle where correct_this_ts is high,
  //either subt ract 330 UI from the timestamp (about 12.8ns) or drop the
  //packet
  assign  o_correct_this_ts  =   (count == vl_position) && (i_rx_sop & i_rx_valid);
  assign  o_pkt_count = pkt_count;

endmodule
