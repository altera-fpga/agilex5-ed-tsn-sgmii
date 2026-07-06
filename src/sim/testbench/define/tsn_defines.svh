// Below are needed for AXI ST interface
//`define SVT_AXI_MAX_TID_WIDTH   9
//`define SVT_AXI_MAX_TDATA_WIDTH 64
`define SVT_AXI_TKEEP_WIDTH     `SVT_AXI_MAX_TDATA_WIDTH/8
//`define SVT_AXI_MAX_TUSER_WIDTH 40

`define MULTICAST_ADDRESS 48'h457dc138c6fa
`define MAX_BUS_WIDTH 4096
`define MAX_TUSER_BUS_WIDTH 512
`define MAX_PPMETADATA_WIDTH 1024
`define MAX_USERMETADATA_WIDTH 1024

`define TSN_TOP top_tb.dut


`define altuvm_define(DEF) DEF

`define stringify(x) `"x`"

`define def_param(PARAM, VAL, TYPE=string, CONV=`stringify)\
  `ifdef PARAM\
    `altuvm_define(parameter TYPE PARAM = CONV(`PARAM);)\
  `else\
    `altuvm_define(parameter TYPE PARAM = CONV(VAL);)\
  `endif

`define def_str_param(PARAM, VAL)\
  `def_param(PARAM, VAL)

`define def_int_param(PARAM, VAL, TYPE=int)\
  `def_param(PARAM, VAL, TYPE, TYPE')

//***********************************************************

`define TSN_TOP top_tb.dut
`define MRPHY(ID) `TSN_TOP.soc_inst.subsys_tsn.intel_mge_phy_``ID``

`define MRPHY_INST(ID) `TSN_TOP.soc_inst.subsys_tsn.intel_mge_phy_``ID``.intel_mge_phy_``ID``

//************************************************************

`define set_rtb_config_pre(TYPE, INS_NAME=m_rtb_config)\
   /* Function that will create the singleton class and pass the handle of it */\
   /* Configuration class's handle */\
      ``TYPE`` ``INS_NAME``;\
   function ``TYPE`` get_rtb_config();\
      /* Build a configuration object that describes this instance of the */\
      /* BFM.  Add this to the resource database for retreval by the UVM */\
      /* agent and also pass it to the BFM interface for use by the driver */\
      /* and monitor BFM code. */\
      if (``INS_NAME`` == null)\
      begin\
         ``INS_NAME`` = ``TYPE``::type_id::create(`"INS_NAME`");\
      end

// Change this compile time. Take 1 instance if not provided
`ifndef MAX_AXI_PORT
  `define MAX_AXI_PORT 9
`endif
