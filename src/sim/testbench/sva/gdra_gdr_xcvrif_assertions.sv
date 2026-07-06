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


module gdra_gdr_xcvrif_assertions #(parameter SIZE=16) ();
  genvar i;
  generate
    for(i=0; i<SIZE; i=i+1) begin : gen_asrt
      gdra_gdr_xcvrif_sva gdra_gdr_xcvrif_sva_i(
	  .tx_wr_clk   (`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.gdr_e400g_xcvrif.XCVRIF_CHNL[i].genblk1.xcvrif_chnl.chnl_tx.tx_fifo.wr_clk),
	  .tx_rd_clk   (`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.gdr_e400g_xcvrif.XCVRIF_CHNL[i].genblk1.xcvrif_chnl.chnl_tx.tx_fifo.rd_clk),
	  .tx_wr_en    (`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.gdr_e400g_xcvrif.XCVRIF_CHNL[i].genblk1.xcvrif_chnl.chnl_tx.tx_fifo.u_tx_async_fifo.wr_en),
	  .tx_rd_en    (`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.gdr_e400g_xcvrif.XCVRIF_CHNL[i].genblk1.xcvrif_chnl.chnl_tx.tx_fifo.u_tx_async_fifo.rd_en),
	  .tx_wr_full  (`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.gdr_e400g_xcvrif.XCVRIF_CHNL[i].genblk1.xcvrif_chnl.chnl_tx.tx_fifo.u_tx_async_fifo.wr_full),
	  .tx_rd_empty (`QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_e400g_top.u_e400g_lphy.gdr_e400g_xcvrif.XCVRIF_CHNL[i].genblk1.xcvrif_chnl.chnl_tx.tx_fifo.u_tx_async_fifo.rd_empty)
      );
    end
  endgenerate
endmodule
