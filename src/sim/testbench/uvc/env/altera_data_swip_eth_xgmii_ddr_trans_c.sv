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


`ifndef ALTERA_DATA_SWIP_ETH_XGMII_DDR_TRANS_C__SV
`define ALTERA_DATA_SWIP_ETH_XGMII_DDR_TRANS_C__SV

parameter XGMII_DDR_SYMBOLSPERBEAT = 4;

class altera_data_swip_eth_xgmii_ddr_trans_c ;

    
    bit [XGMII_DDR_SYMBOLSPERBEAT - 1:0] ctrl;
    bit [7:0] data[XGMII_DDR_SYMBOLSPERBEAT];
    
    
    function new();
      //  super.new(this.log);    
    endfunction
    
    
   
    virtual function string psdisplay(string prefix = "");
        int unsigned i;
        
        psdisplay = {
            $psprintf("", prefix),
            "altera_data_swip_eth_xgmii_ddr_trans_c"
        };
        
        psdisplay = {
            psdisplay,
            "\n    ctrl = "
        };
        
        for(i = 0; i < XGMII_DDR_SYMBOLSPERBEAT; i++) begin
            psdisplay = {
                psdisplay,
                $psprintf(" %x ", ctrl[i])
            };
        end
        
        psdisplay = {
            psdisplay,
            "\n    data = "
        };
        
        for(i = 0; i < XGMII_DDR_SYMBOLSPERBEAT; i++) begin
            psdisplay = {
                psdisplay,
                $psprintf("%2x ", data[i])
            };
        end
        
    endfunction


    
endclass


`endif
