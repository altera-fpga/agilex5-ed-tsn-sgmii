// Below are needed for AXI ST interface
`define SVT_AXI_MAX_TID_WIDTH   9
`define SVT_AXI_MAX_TDATA_WIDTH 64
`define SVT_AXI_TKEEP_WIDTH     `SVT_AXI_MAX_TDATA_WIDTH/8
`define SVT_AXI_MAX_TUSER_WIDTH 40

// Change this compile time. Take 1 instance if not provided
`ifndef MAX_AXI_PORT
  `define MAX_AXI_PORT 1
`endif
