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


// $File: //acds/main/ip/sopc/components/altera_avalon_dc_fifo/altera_dcfifo_synchronizer_bundle.v $
// $Revision: #4 $
// $Date: 2012/01/18 $
// $Author: pscheidt $
//-------------------------------------------------------------------------------

`timescale 1 ns / 1 ns
module alt_em10g32_dcfifo_synchronizer_bundle(
				     clk,
				     reset_n,
				     din,
				     dout
				     );
   parameter WIDTH = 1;
   parameter DEPTH = 3;   
   
   input clk;
   input reset_n;
   input [WIDTH-1:0] din;
   output [WIDTH-1:0] dout;
   
   genvar i;
   
   generate
      for (i=0; i<WIDTH; i=i+1)
	begin : sync
	   alt_em10g32_std_synchronizer #(.depth(DEPTH))
                                   u (
				      .clk(clk), 
				      .reset_n(reset_n), 
				      .din(din[i]), 
				      .dout(dout[i])
				      );
	end
   endgenerate
   
endmodule 

`ifdef QUESTA_INTEL_OEM
`pragma questa_oem_00 "yhUI+8vmytpRCBqF0zmkIP8y6qygH02Swfh+aJUObfvQHqSV2BpkM/910eRPFcaH8oW/VO3xE9UAkyT4Fr47iBQkJWUd456qsT8KoU+OUZPFU8f6/4IqZP95cwXDNcYajlJ7RU1ht4eGrG5zQZXsr/QRVNRf3qBwG/bz9jte5RJtKVWlbXQc/0oaiVeqv7hXwTxBmSxbw7jN/YTRBsD30BybgGmI064OT1XOSE/OaLbEBhygfIInFlgFf8++SevPgmDAM8tPlOOhf3EujFi76dOk2wcoeBLMQxGLolmMurys3KsyoCePMP7xRSEj2OtpKERkeHYshqZg4fYySmyKaFmGZdXPGOo52csafscLnVZY5z9vVlSybf0AFDXoRpD6l/DIxU89sp2xiXoAayxv8NrqoX5Nh2OGP/+hlXz6FIGn7JenVQfEOjLhdfS/EcmQsdRTjlwGhx13c81nQcvdqdhlZAeujaVoAf4afB6i3pOSlLeJWRiod/h0ZXhEWlzbi4Ma712WWOmm+2M0Wdf71NIVHaHA/kDQSaRKF6niCdJBrfFbZv4ngMF9lekhuKvLe7rXVvgZfiDsuim1LTLkHg+1N9zcI0ZtPiwxOrEBnsXQSiJzJ5YeleZoTTPIzYslboJr9CcK/f/rpGzrqiqKNwVv12/yDT+3lpC93kAvVoSAlukNnMiAtOEsjPMf8dRBPMJQugTa8kfvypFD8zTCX+npQFTeHn1xjwDeFNvGrFns5aHk2190YKj9wMAMqGRcqP/INPEI3QUDuXLFk9zjUxWnzVa9qjvKRxI4DsPYkqrHl5s/fnyekDY37ZB7mG+s78ENG9qi2S8uMR3EKyJY+ysT+e9EJ1bPucc/uHEhBaN6enD9We9k4c0IBH0w5dR8hjwVrJSopFGeXW3w1+XEDX+d1F3s/lypDOMoWVxDwiL4J0up5fnzAOlra+7Hxpy79dlVFnwtX8sePxuezIrrp79XgmzMOcINRF+M7DdVhCPSCuvU2VRtWLLfoWwqHLoa"
`endif