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



   /** PHY Interface  Clocks */
  //`ifdef EHIP_PCS_ONLY
//genvar i;
generate
for (i = 0; i < NUM_PHY; i++) begin
  `ifdef OTN_MODE
      assign uif_pcs66[i].reference_clk         = reference_clk;
      assign uif_pcs66[i].xgmii_tx_clk          = xgmii66_clk[i];
      //assign uif_pcs66[0].xgmii_rx_clk          = !xgmii66_clk && xgmii66_rx_valid;// BFM workaround - gate the RX clock with data-valid since BFM has no 'valid' input
      assign uif_pcs66[i].xgmii_rx_clk          = !xgmii66_clk[i];
      assign uif_pcs66[i].xsbi_tx_clk           = xsbi66_clk[i];
      assign uif_pcs66[i].xsbi_rx_clk           = xsbi66_clk[i];
      assign uif_pcs66[i].serial_tx_baser_clk   = serial_baser_clk[i];
      assign uif_pcs66[i].serial_rx_baser_clk   = serial_baser_clk[i]; 
  `elsif FLEXE_MODE
      assign uif_pcs66[i].reference_clk         = reference_clk;
      assign uif_pcs66[i].xgmii_tx_clk          = xgmii66_clk[i];
      //assign uif_pcs66[0].xgmii_rx_clk          = !xgmii66_clk && xgmii66_rx_valid;// BFM workaround - gate the RX clock with data-valid since BFM has no 'valid' input
      assign uif_pcs66[i].xgmii_rx_clk          = !xgmii66_clk[i];
      assign uif_pcs66[i].xsbi_tx_clk           = xsbi66_clk[i];
      assign uif_pcs66[i].xsbi_rx_clk           = xsbi66_clk[i];
      assign uif_pcs66[i].serial_tx_baser_clk   = serial_baser_clk[i];
      assign uif_pcs66[i].serial_rx_baser_clk   = serial_baser_clk[i]; 
  `endif
end
endgenerate
