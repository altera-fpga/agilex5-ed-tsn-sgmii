
// CRU parameters
`define TSN_CRU_PARAM_INST \
   .CLK_IN_NUM                               (CLK_IN_NUM), \
   .CLK_OUT_NUM                              (CLK_OUT_NUM), \
   .RST_IN_NUM                               (RST_IN_NUM), \
   .RST_OUT_NUM                              (RST_OUT_NUM)

// BNIC RTB Parameters
`define TSN_RTB_PARAM_ANSI \
   parameter                 CLK_IN_NUM                               = tsn_pkg::DEFAULT_CLK_IN_NUM, \
   parameter                 CLK_OUT_NUM                              = tsn_pkg::DEFAULT_CLK_OUT_NUM, \
   parameter string          DEVICE_FAMILY                            = tsn_pkg::DEFAULT_DEVICE_FAMILY, \
   parameter                 RST_IN_NUM                               = tsn_pkg::DEFAULT_RST_IN_NUM, \
   parameter                 RST_OUT_NUM                              = tsn_pkg::DEFAULT_RST_OUT_NUM


`define TSN_RTB_PARAM_SETCFG \
   m_rtb_config.CLK_IN_NUM                               = CLK_IN_NUM; \
   m_rtb_config.CLK_OUT_NUM                              = CLK_OUT_NUM; \
   m_rtb_config.DEVICE_FAMILY                            = DEVICE_FAMILY; \
   m_rtb_config.RST_IN_NUM                               = RST_IN_NUM; \
   m_rtb_config.RST_OUT_NUM                              = RST_OUT_NUM;


`define TSN_RTB_PARAM_INST \
   .CLK_IN_NUM                               (CLK_IN_NUM), \
   .CLK_OUT_NUM                              (CLK_OUT_NUM), \
   .DEVICE_FAMILY                            (DEVICE_FAMILY), \
   .RST_IN_NUM                               (RST_IN_NUM), \
   .RST_OUT_NUM                              (RST_OUT_NUM)

`define TSN_RTB_PARAM_BODY \
   parameter                 CLK_IN_NUM                               = tsn_pkg::DEFAULT_CLK_IN_NUM; \
   parameter                 CLK_OUT_NUM                              = tsn_pkg::DEFAULT_CLK_OUT_NUM; \
   parameter string          DEVICE_FAMILY                            = tsn_pkg::DEFAULT_DEVICE_FAMILY; \
   parameter                 RST_IN_NUM                               = tsn_pkg::DEFAULT_RST_IN_NUM; \
   parameter                 RST_OUT_NUM                              = tsn_pkg::DEFAULT_RST_OUT_NUM;

`define TSN_RTB_PARAM_DEFCFG \
   int             CLK_IN_NUM                               = tsn_pkg::DEFAULT_CLK_IN_NUM; \
   int             CLK_OUT_NUM                              = tsn_pkg::DEFAULT_CLK_OUT_NUM; \
   string          DEVICE_FAMILY                            = tsn_pkg::DEFAULT_DEVICE_FAMILY; \
   int             RST_IN_NUM                               = tsn_pkg::DEFAULT_RST_IN_NUM; \
   int             RST_OUT_NUM                              = tsn_pkg::DEFAULT_RST_OUT_NUM;

`define HPS_RTB_PARAM_DEFCFG \
   int             CLK_IN_NUM                               = tsn_pkg::DEFAULT_CLK_IN_NUM; \
   int             CLK_OUT_NUM                              = tsn_pkg::DEFAULT_CLK_OUT_NUM; \
   string          DEVICE_FAMILY                            = tsn_pkg::DEFAULT_DEVICE_FAMILY; \
   int             RST_IN_NUM                               = tsn_pkg::DEFAULT_RST_IN_NUM; \
   int             RST_OUT_NUM                              = tsn_pkg::DEFAULT_RST_OUT_NUM;

`define TSN_RTB_PARAM_DEFUVM \
   `uvm_field_int(          CLK_IN_NUM,                              UVM_PRINT) \
   `uvm_field_int(          CLK_OUT_NUM,                             UVM_PRINT) \
   `uvm_field_string(       DEVICE_FAMILY,                           UVM_PRINT) \
   `uvm_field_int(          RST_IN_NUM,                              UVM_PRINT) \
   `uvm_field_int(          RST_OUT_NUM,                             UVM_PRINT)


`define HPS_RTB_PARAM_DEFUVM \
   `uvm_field_int(          CLK_IN_NUM,                              UVM_PRINT) \
   `uvm_field_int(          CLK_OUT_NUM,                             UVM_PRINT) \
   `uvm_field_string(       DEVICE_FAMILY,                           UVM_PRINT) \
   `uvm_field_int(          RST_IN_NUM,                              UVM_PRINT) \
   `uvm_field_int(          RST_OUT_NUM,                             UVM_PRINT)

   
`define TSN_RTB_PARAM_PRINT

`define NUM_INST 1

`define NUM_OF_PORTS 8

`define INST_0
`define NUM_LANES_IP0 1
`define NUM_LANES_IP0_1
`define PTP_NUM_WORDS_IP 1

`define MAC_MODE

`define CLK_FREQ(F) ((1000000)/(2*(F/1000.0)))

