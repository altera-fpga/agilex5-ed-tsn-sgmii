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


//-------------------------------------------------------------------
// Description : Address offset of components & each registers of the components
//-------------------------------------------------------------------

// allows the file to be included multiple time without causing multiple-definition errors
`ifndef ALTERA_BIC_QSE_REGISTER_MAP_PARAMS__SV
`define ALTERA_BIC_QSE_REGISTER_MAP_PARAMS__SV


// **********************************//
// CSR Addresses without CSR Adapter //
// **********************************//

//`ifdef REG_MAP_WO_ADAPTER 

// ******************************************************************************************
// Address Offset of Components
// ******************************************************************************************
    parameter CSR_ADDR_WIDTH                            = 32;
    
    //`ifdef CSR_ADDRESS_MODE_DWORD
        parameter CSR_BYTE_WORD_ADDRESS_MODE            = 4;
        parameter CSR_REG_OFFSET                        = 1;
    //`else
      //  parameter CSR_BYTE_WORD_ADDRESS_MODE            = 1;
       // parameter CSR_REG_OFFSET                        = CSR_ADDR_WIDTH / 8;
   // `endif
       
    // ------------------------------------------------------------------------------------------
    // MAC (32 bit)
    // ------------------------------------------------------------------------------------------
    `ifdef ETH_MGE_MAC_PHY_DE
		parameter ETH_MAC_ADDR                              = 32'h10000/4; 
    `elsif ETH_MGBASET_MAC_PHY_DE
		parameter ETH_MAC_ADDR                              = 32'h10000/4; 
    `elsif ETH_MGBASET_MAC_S10_PHY_MODE_DE
		parameter ETH_MAC_ADDR                              = 32'h10000/4; 
    `elsif ETH_NBASET_MAC_PHY_DE
		parameter ETH_MAC_ADDR                              = 32'h28000/4; 
    `else
		parameter ETH_MAC_ADDR                              = 32'h0000; 
    `endif
    
    parameter ETH_MAC_TX_ADDR                           = ETH_MAC_ADDR + 32'h0020;
    parameter ETH_MAC_RX_ADDR                           = ETH_MAC_ADDR + 32'h00A0;

    
    parameter TX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR      = (ETH_MAC_TX_ADDR + 32'h0000); //TX Packet Control (TX_PKTCTL)
    parameter TX_ETH_PAD_INSERTER_ADDR                  = (ETH_MAC_TX_ADDR + 32'h0004); //TX Pad Control (TX_PADCTL)
    parameter TX_ETH_CRC_INSERTER_ADDR                  = (ETH_MAC_TX_ADDR + 32'h0006);
    parameter TX_ETH_PREAMBLE_CONTROL_ADDR              = (ETH_MAC_TX_ADDR + 32'h0008);
    parameter TX_ETH_ADDRESS_INSERTER_ADDR              = (ETH_MAC_TX_ADDR + 32'h000A); //TX Source Address Overide
    parameter TX_ETH_FRAME_CTRL_ADDR                    = (ETH_MAC_TX_ADDR + 32'h000C);
    parameter TX_ETH_FRAME_DECODER_ADDR                 = (ETH_MAC_TX_ADDR + 32'h000C); //same as tx frame control?
    parameter TX_ETH_PKT_UNDERFLOW_CONTROL_ADDR         = (ETH_MAC_TX_ADDR + 32'h001E);
    parameter TX_ETH_PAUSE_CTRL_GEN_ADDR                = (ETH_MAC_TX_ADDR + 32'h0020);
    parameter TX_ETH_PFC_GEN_ADDR                       = (ETH_MAC_TX_ADDR + 32'h0026);
    parameter TX_ETH_STATISTICS_COLLECTOR_ADDR          = (ETH_MAC_TX_ADDR + 32'h0120);
    parameter TX_ETH_TIME_STAMP_ADDR                    = (ETH_MAC_TX_ADDR + 32'h00E0);
    
    parameter RX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR      = (ETH_MAC_RX_ADDR + 32'h0000); //RX Transfer Enable 
    parameter RX_ETH_CRC_PAD_REMOVAL_ADDR               = (ETH_MAC_RX_ADDR + 32'h0004);
    parameter RX_ETH_CRC_CHECKER_ADDR                   = (ETH_MAC_RX_ADDR + 32'h0006);
    parameter RX_ETH_PREAMBLE_CONTROL_ADDR              = (ETH_MAC_RX_ADDR + 32'h0008);
    parameter RX_ETH_FRAME_DECODER_ADDR                 = (ETH_MAC_RX_ADDR + 32'h000C); //RX Frame Control
    parameter RX_ETH_PFC_CTRL_ADDR                      = (ETH_MAC_RX_ADDR + 32'h0020); //0x00C0
    parameter RX_ETH_PKT_OVERFLOW_CONTROL_ADDR          = (ETH_MAC_RX_ADDR + 32'h005C); //0x00FC  
    parameter RX_ETH_STATISTICS_COLLECTOR_ADDR          = (ETH_MAC_RX_ADDR + 32'h0120);
    parameter RX_ETH_TIME_STAMP_ADDR                    = (ETH_MAC_RX_ADDR + 32'h0080);

    // New CSR in 32b MAC
    parameter MAC_REVISION_ADDR                         = ETH_MAC_ADDR + 13'h0000;
    parameter MAC_CAPABILITY_ADDR                       = ETH_MAC_ADDR + 13'h0002;
    parameter TX_ETH_PAUSE_HOLDOFF_QUANTA_ADDR          = ETH_MAC_ADDR + 13'h0043;
    parameter TX_ETH_PIPG_10G_ADDR                      = ETH_MAC_ADDR + 13'h002E;
    parameter TX_ETH_PIPG_1G_ADDR                       = ETH_MAC_ADDR + 13'h002F;
    parameter ECC_STATUS_ADDR                           = ETH_MAC_ADDR + 13'h0240;
    parameter ECC_STATUS_ENABLE_ADDR                    = ETH_MAC_ADDR + 13'h0241;
    parameter MAC_COMMON_STATUS                         = ETH_MAC_ADDR + 13'h001E;
    parameter TXRX_SOFTWARE_RESET_ADDR	                = ETH_MAC_ADDR + 13'h001F;
    // Unidirectional Ethernet
    parameter TX_ETH_UNIDIECTIONAL_ADDR                = (ETH_MAC_TX_ADDR + 32'h0050);
    parameter TX_ETH_UNIDIECTIONAL_ENA                 = TX_ETH_UNIDIECTIONAL_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_UNIDIECTIONAL_RMTSTS_EN           = TX_ETH_UNIDIECTIONAL_ADDR + CSR_REG_OFFSET * 1;
    parameter TX_ETH_UNIDIECTIONAL_RMTFLT_EN           = TX_ETH_UNIDIECTIONAL_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_UNIDIECTIONAL_ENA_OFFSET          = 0;
    parameter TX_ETH_UNIDIECTIONAL_RMTSTS_EN_OFFSET    = 1;  
    parameter TX_ETH_UNIDIECTIONAL_RMTFLT_EN_OFFSET    = 2;
    
    // ------------------------------------------------------------------------------------------
    // XAUI PCS
    // ------------------------------------------------------------------------------------------
    parameter ETH_PCS_XAUI_ADDR                         = 32'h40000 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter ETH_PCS_XAUI_PMA_CONTROLLER_ADDR          = ETH_PCS_XAUI_ADDR + 32'h80;
    parameter ETH_PCS_XAUI_POWERDOWN_ADDR               = ETH_PCS_XAUI_PMA_CONTROLLER_ADDR + CSR_REG_OFFSET * 1;
    parameter ETH_PCS_XAUI_GXB_POWERDOWN_OFFSET         = 1;
    
    parameter ETH_PCS_XAUI_CSR_ADDR                     = ETH_PCS_XAUI_ADDR + 32'h200;
    parameter ETH_PCS_XAUI_SIMULATION_FLAG_ADDR         = ETH_PCS_XAUI_CSR_ADDR + 32'h28;
    
    
    
    
    
    // ------------------------------------------------------------------------------------------
    // RX FIFO
    // ------------------------------------------------------------------------------------------
    parameter RX_FIFO_ADDR                              = 32'h10400 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_FIFO_ALMOST_FULL_THRESHOLD_ADDR        = RX_FIFO_ADDR + CSR_REG_OFFSET * 2;
    parameter RX_FIFO_ALMOST_EMPTY_THRESHOLD_ADDR       = RX_FIFO_ADDR + CSR_REG_OFFSET * 3;
    parameter RX_FIFO_CUT_THROUGH_THRESHOLD_ADDR        = RX_FIFO_ADDR + CSR_REG_OFFSET * 4;
    parameter RX_FIFO_DROP_ON_ERROR_ADDR                = RX_FIFO_ADDR + CSR_REG_OFFSET * 5;
    
    // ------------------------------------------------------------------------------------------
    // TX FIFO
    // ------------------------------------------------------------------------------------------
    parameter TX_FIFO_ADDR                              = 32'h10600 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_FIFO_ALMOST_FULL_THRESHOLD_ADDR        = TX_FIFO_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_FIFO_ALMOST_EMPTY_THRESHOLD_ADDR       = TX_FIFO_ADDR + CSR_REG_OFFSET * 3;
    parameter TX_FIFO_CUT_THROUGH_THRESHOLD_ADDR        = TX_FIFO_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_FIFO_DROP_ON_ERROR_ADDR                = TX_FIFO_ADDR + CSR_REG_OFFSET * 5;
    
    
    
    
    
    // ------------------------------------------------------------------------------------------
    // Loopback
    // ------------------------------------------------------------------------------------------
    parameter LOOPBACK_COMPOSED_ADDR                    = 32'h10200 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter LINE_LOOPBACK_ADDR                        = (LOOPBACK_COMPOSED_ADDR + 32'h000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter LOCAL_LOOPBACK_ADDR                       = (LOOPBACK_COMPOSED_ADDR + 32'h008) / CSR_BYTE_WORD_ADDRESS_MODE;
    
    
// ******************************************************************************************
// Registers Offset of Components
// ******************************************************************************************

    // ------------------------------------------------------------------------------------------
    // RX Packet Backpressure Control (RX Transfer Enable)
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_PKT_BACKPRESSURE_CONTROL_CONTROL_ADDR      = RX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    parameter RX_ETH_PKT_BACKPRESSURE_CONTROL_STATUS_ADDR       = RX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 2;
    
    // ------------------------------------------------------------------------------------------
    // RX CRC Checker
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_CRC_CHECKER_CONTROL_ADDR                   = RX_ETH_CRC_CHECKER_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // RX CRC/Pad Removal
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_CRC_PAD_REMOVAL_CONTROL_ADDR               = RX_ETH_CRC_PAD_REMOVAL_ADDR + CSR_REG_OFFSET * 0;

    // ------------------------------------------------------------------------------------------
    // RX Preamble Control
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_PREAMBLE_CONTROL_CTRL_ADDR                 = RX_ETH_PREAMBLE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    parameter RX_ETH_PREAMBLE_CONTROL_PASSTHRU_EN_ADDR          = RX_ETH_PREAMBLE_CONTROL_ADDR + CSR_REG_OFFSET * 2;
    
    // ------------------------------------------------------------------------------------------
    // RX Frame Decoder
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_FRAME_DECODER_CONTROL_ADDR                 = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 0;
    parameter RX_ETH_FRAME_DECODER_MAX_FRAME_LENGTH_ADDR        = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 2;
    //parameter RX_ETH_FRAME_DECODER_UCAST_MAC_ADD_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 2; //not in BIC (maintain so that not need to modify framework)
    //parameter RX_ETH_FRAME_DECODER_UCAST_MAC_ADD_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 3; //not in BIC (maintain so that not need to modify framework)
    parameter RX_ETH_FRAME_DECODER_UCAST_MAC_ADD_0_ADDR         = ETH_MAC_ADDR + 32'h0010;
    parameter RX_ETH_FRAME_DECODER_UCAST_MAC_ADD_1_ADDR         = ETH_MAC_ADDR + 32'h0011;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 4; //0x00B0
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 5;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 6;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 7;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 8;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 9;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 10;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 11;
    parameter RX_ETH_FRAME_DECODER_PFC_CONTROL_ADDR             = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 20; //0x00C0
    
    // ------------------------------------------------------------------------------------------
    // RX PFC Control
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_PFC_CTRL_EN_ADDR = RX_ETH_PFC_CTRL_ADDR + CSR_REG_OFFSET * 0;
	
    // ------------------------------------------------------------------------------------------
    // RX Packet Overflow Control
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_PKT_OVERFLOW_CONTROL_TRUNCATE_COUNTER_ADDR = RX_ETH_PKT_OVERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 0; //map to RX Packet Overflow Error Count[31:0]
    parameter RX_ETH_PKT_OVERFLOW_CONTROL_DROP_COUNTER_ADDR     = RX_ETH_PKT_OVERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 2; //map to RX Packet Overflow Drop Count[31:0]
	
    // parameter RX_ETH_PKT_OVERFLOW_CONTROL_ERROR_COUNTER_ADDR        = RX_ETH_PKT_OVERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    // parameter RX_ETH_PKT_OVERFLOW_CONTROL_ERROR_COUNTER_UPPER_ADDR  = RX_ETH_PKT_OVERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 1;
    
    // ------------------------------------------------------------------------------------------
    // RX Statistics Collector
    // ------------------------------------------------------------------------------------------
    parameter RX_ETH_STATISTICS_COLLECTOR_CLR_ADDR                              = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 0;
    parameter RX_ETH_STATISTICS_COLLECTOR_framesOK_ADDR                         = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 2;
    parameter RX_ETH_STATISTICS_COLLECTOR_framesErr_ADDR                        = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 4;
    parameter RX_ETH_STATISTICS_COLLECTOR_framesCRCErr_ADDR                     = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 6;
    parameter RX_ETH_STATISTICS_COLLECTOR_octetsOK_ADDR                         = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 8;
    parameter RX_ETH_STATISTICS_COLLECTOR_pauseMACCtrlFrames_ADDR               = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 10;
    parameter RX_ETH_STATISTICS_COLLECTOR_ifErrors_ADDR                         = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 12;
    parameter RX_ETH_STATISTICS_COLLECTOR_unicastFramesOK_ADDR                  = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 14;
    parameter RX_ETH_STATISTICS_COLLECTOR_unicastFramesErr_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 16;
    parameter RX_ETH_STATISTICS_COLLECTOR_multicastFramesOK_ADDR                = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 18;
    parameter RX_ETH_STATISTICS_COLLECTOR_multicastFramesErr_ADDR               = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 20;
    parameter RX_ETH_STATISTICS_COLLECTOR_broadcastFramesOK_ADDR                = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 22;
    parameter RX_ETH_STATISTICS_COLLECTOR_broadcastFramesErr_ADDR               = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 24;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsOctets_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 26;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts_ADDR                   = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 28;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsUndersizePkts_ADDR          = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 30;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsOversizePkts_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 32;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts64Octets_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 34;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts65to127Octets_ADDR      = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 36;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts128to255Octets_ADDR     = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 38;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts256to511Octets_ADDR     = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 40;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts512to1023Octets_ADDR    = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 42;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1024to1518Octets_ADDR   = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 44;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1519toXOctets_ADDR      = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 46;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsFragments_ADDR              = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 48;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsJabbers_ADDR                = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 50;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsCRCErr_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 52;
    parameter RX_ETH_STATISTICS_COLLECTOR_unicastMACCtrlFrames_ADDR             = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 54;
    parameter RX_ETH_STATISTICS_COLLECTOR_multicastMACCtrlFrames_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 56;
    parameter RX_ETH_STATISTICS_COLLECTOR_broadcastMACCtrlFrames_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 58;
    parameter RX_ETH_STATISTICS_COLLECTOR_pfcMACCtrlFrames_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 60;
      
    // ------------------------------------------------------------------------------------------
    // TX Packet Backpressure Control (TX Packet Control)
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_PKT_BACKPRESSURE_CONTROL_CONTROL_ADDR      = TX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_PKT_BACKPRESSURE_CONTROL_STATUS_ADDR       = TX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 2;   //TX Transfer Status
    
    // ------------------------------------------------------------------------------------------
    // TX CRC Inserter
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_CRC_INSERTER_CONTROL_ADDR                  = TX_ETH_CRC_INSERTER_ADDR + CSR_REG_OFFSET * 0;

    // ------------------------------------------------------------------------------------------
    // TX Preamble Control
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_PREAMBLE_CONTROL_PASSTHRU_EN_ADDR          = TX_ETH_PREAMBLE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // TX FRAME Control
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_FRAME_CTRL_MAX_DATAFRMLEN_ADDR             = TX_ETH_FRAME_CTRL_ADDR + CSR_REG_OFFSET * 0;

    // ------------------------------------------------------------------------------------------
    // TX Pad Inserter
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_PAD_INSERTER_CONTROL_ADDR                  = TX_ETH_PAD_INSERTER_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // TX Pause Frame Control
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_PAUSE_CTRL_GEN_ADDR_CONTROL_ADDR           = TX_ETH_PAUSE_CTRL_GEN_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_PAUSE_CTRL_GEN_ADDR_PAUSE_QUANTA_ADDR      = TX_ETH_PAUSE_CTRL_GEN_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_PAUSE_CTRL_GEN_PAUSE_GEN_ENA_ADDR          = TX_ETH_PAUSE_CTRL_GEN_ADDR + CSR_REG_OFFSET * 4;
    
    // ------------------------------------------------------------------------------------------
    // TX Address Inserter (TX Source Address Overide)
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_ADDRESS_INSERTER_CONTROL_ADDR              = TX_ETH_ADDRESS_INSERTER_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_ADDRESS_INSERTER_UCAST_MAC_ADD_0_ADDR      = ETH_MAC_ADDR + 32'h0010 + CSR_REG_OFFSET * 0;
    parameter TX_ETH_ADDRESS_INSERTER_UCAST_MAC_ADD_1_ADDR      = ETH_MAC_ADDR + 32'h0010 + CSR_REG_OFFSET * 1;
    
    // ------------------------------------------------------------------------------------------
    // TX Frame Decoder
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_FRAME_DECODER_MAX_FRAME_LENGTH_ADDR        = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 0; //same as TX_ETH_FRAME_CTRL_MAX_DATAFRMLEN_ADDR
	
	parameter TX_ETH_FRAME_DECODER_CONTROL_ADDR                 = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 0;
    // parameter TX_ETH_FRAME_DECODER_MAX_FRAME_LENGTH_ADDR        = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 1;
    // parameter TX_ETH_FRAME_DECODER_UCAST_MAC_ADD_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 2;
    // parameter TX_ETH_FRAME_DECODER_UCAST_MAC_ADD_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 3;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 4;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 5;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 6;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 7;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 8;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 9;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 10;
    // parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 11;
    // parameter TX_ETH_FRAME_DECODER_PFC_CONTROL_ADDR             = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 24;
    
    // ------------------------------------------------------------------------------------------
    // TX Packet Underflow Control
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_PKT_UNDERFLOW_CONTROL_COUNTER_ADDR         = TX_ETH_PKT_UNDERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 0;
	parameter TX_ETH_PKT_UNDERFLOW_CONTROL_COUNTER_UPPER_ADDR   = TX_ETH_PKT_UNDERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 1; //TX Underflow Error
    
    // ------------------------------------------------------------------------------------------
    // TX PFC Generator
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_PFC_GEN_PRIORITY_ENA_ADDR                  = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 0; //PFC Frame Enable
	parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_0_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_1_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 3;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_2_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_3_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 5;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_4_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 6;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_5_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 7;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_6_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 8;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_7_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 9;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_0_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 18;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_1_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 19;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_2_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 20;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_3_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 21;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_4_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 22;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_5_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 23;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_6_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 24;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_7_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 25;
        
    // ------------------------------------------------------------------------------------------
    // TX Statistics Collector
    // ------------------------------------------------------------------------------------------
    parameter TX_ETH_STATISTICS_COLLECTOR_CLR_ADDR                              = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_STATISTICS_COLLECTOR_framesOK_ADDR                         = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_STATISTICS_COLLECTOR_framesErr_ADDR                        = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_ETH_STATISTICS_COLLECTOR_framesCRCErr_ADDR                     = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 6;
    parameter TX_ETH_STATISTICS_COLLECTOR_octetsOK_ADDR                         = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 8;
    parameter TX_ETH_STATISTICS_COLLECTOR_pauseMACCtrlFrames_ADDR               = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 10;
    parameter TX_ETH_STATISTICS_COLLECTOR_ifErrors_ADDR                         = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 12;
    parameter TX_ETH_STATISTICS_COLLECTOR_unicastFramesOK_ADDR                  = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 14;
    parameter TX_ETH_STATISTICS_COLLECTOR_unicastFramesErr_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 16;
    parameter TX_ETH_STATISTICS_COLLECTOR_multicastFramesOK_ADDR                = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 18;
    parameter TX_ETH_STATISTICS_COLLECTOR_multicastFramesErr_ADDR               = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 20;
    parameter TX_ETH_STATISTICS_COLLECTOR_broadcastFramesOK_ADDR                = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 22;
    parameter TX_ETH_STATISTICS_COLLECTOR_broadcastFramesErr_ADDR               = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 24;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsOctets_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 26;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts_ADDR                   = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 28;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsUndersizePkts_ADDR          = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 30;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsOversizePkts_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 32;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts64Octets_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 34;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts65to127Octets_ADDR      = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 36;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts128to255Octets_ADDR     = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 38;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts256to511Octets_ADDR     = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 40;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts512to1023Octets_ADDR    = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 42;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1024to1518Octets_ADDR   = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 44;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1519toXOctets_ADDR      = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 46;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsFragments_ADDR              = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 48;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsJabbers_ADDR                = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 50;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsCRCErr_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 52;
    parameter TX_ETH_STATISTICS_COLLECTOR_unicastMACCtrlFrames_ADDR             = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 54;
    parameter TX_ETH_STATISTICS_COLLECTOR_multicastMACCtrlFrames_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 56;
    parameter TX_ETH_STATISTICS_COLLECTOR_broadcastMACCtrlFrames_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 58;
    parameter TX_ETH_STATISTICS_COLLECTOR_pfcMACCtrlFrames_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 60;
    
    
    
    
    
// ******************************************************************************************
// Register Offset of Components
// ******************************************************************************************    
    
    // ------------------------------------------------------------------------------------------
    // Packet Backpressure Control
    // ------------------------------------------------------------------------------------------
    parameter ETH_PKT_BACKPRESSURE_CONTROL_CONTROL_STOP_X_OFFSET        = 0;
    parameter ETH_PKT_BACKPRESSURE_CONTROL_STATUS_STATUS_OFFSET         = 0;
    
    // ------------------------------------------------------------------------------------------
    // CRC
    // ------------------------------------------------------------------------------------------
    parameter ETH_CRC_CONTROL_MODE_OFFSET                               = 0;
    parameter ETH_CRC_CONTROL_ENABLE_OFFSET                             = 1;
    
    // ------------------------------------------------------------------------------------------
    // Pad Inserter
    // ------------------------------------------------------------------------------------------
    parameter ETH_PAD_INSERTER_PAD_INS_OFFSET                           = 0;
	
	// ------------------------------------------------------------------------------------------
    // Preamble
    // ------------------------------------------------------------------------------------------
    parameter ETH_PREAMBLE_CONTROL_OFFSET                           = 0;
	
	// ------------------------------------------------------------------------------------------
    // Pause Frame Control
    // ------------------------------------------------------------------------------------------
    parameter ETH_PAUSE_CTRL_GEN_ADDR_CONTROL_XON_OFFSET               = 0;
    parameter ETH_PAUSE_CTRL_GEN_ADDR_CONTROL_XOFF_OFFSET              = 1;
    
    parameter ETH_PAUSE_CTRL_GEN_PAUSE_GEN_ENA_OFFSET                  = 0;
    
    // ------------------------------------------------------------------------------------------
    // PFC Generator
    // ------------------------------------------------------------------------------------------
    parameter ETH_PFC_GEN_PRIORITY_ENA_0_OFFSET                        = 0;
    parameter ETH_PFC_GEN_PRIORITY_ENA_1_OFFSET                        = 1;
    parameter ETH_PFC_GEN_PRIORITY_ENA_2_OFFSET                        = 2;
    parameter ETH_PFC_GEN_PRIORITY_ENA_3_OFFSET                        = 3;
    parameter ETH_PFC_GEN_PRIORITY_ENA_4_OFFSET                        = 4;
    parameter ETH_PFC_GEN_PRIORITY_ENA_5_OFFSET                        = 5;
    parameter ETH_PFC_GEN_PRIORITY_ENA_6_OFFSET                        = 6;
    parameter ETH_PFC_GEN_PRIORITY_ENA_7_OFFSET                        = 7;
	
	// ------------------------------------------------------------------------------------------
    // Address Inserter
    // ------------------------------------------------------------------------------------------
    parameter ETH_ADDRESS_INSERTER_CONTROL_INSERT_OFFSET                = 0;
	
	// ------------------------------------------------------------------------------------------
    // Frame Decoder
    // ------------------------------------------------------------------------------------------
    parameter ETH_FRAME_DECODER_CONTROL_ALL_UCAST_OFFSET                = 0;
    parameter ETH_FRAME_DECODER_CONTROL_ALL_MCAST_OFFSET                = 1;
      parameter ETH_FRAME_DECODER_CONTROL_DROP_BCAST_OFFSET               = 2; //not in BIC(maintain as not need to modify framework)
    parameter ETH_FRAME_DECODER_CONTROL_FORWARD_CONTROL_OFFSET          = 3;
    parameter ETH_FRAME_DECODER_CONTROL_FORWARD_PAUSE_OFFSET            = 4;
    parameter ETH_FRAME_DECODER_CONTROL_IGNORE_PAUSE_OFFSET             = 5;
    parameter ETH_FRAME_DECODER_CONTROL_NO_LEN_CHECK_OFFSET             = 6;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_0_OFFSET               = 16;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_1_OFFSET               = 17;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_2_OFFSET               = 18;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_3_OFFSET               = 19;
    
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_0_OFFSET       = 0;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_1_OFFSET       = 1;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_2_OFFSET       = 2;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_3_OFFSET       = 3;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_4_OFFSET       = 4;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_5_OFFSET       = 5;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_6_OFFSET       = 6;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_7_OFFSET       = 7;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_FORWARD_PFC_OFFSET          = 16;
    
    // ------------------------------------------------------------------------------------------
    // CRC/Pad Removal
    // ------------------------------------------------------------------------------------------
    parameter ETH_CRC_PAD_REMOVAL_CONTROL_REMOVE_CRC_ONLY_OFFSET        = 0;
    parameter ETH_CRC_PAD_REMOVAL_CONTROL_REMOVE_PAD_CRC_OFFSET         = 1;

    // ------------------------------------------------------------------------------------------
    // KR GIGE PCS 
    // ------------------------------------------------------------------------------------------
    // Additional address decoding to shift the KR address 
    
    parameter KR_GIGE_PCS_ADDR                              = 32'h8000_0000 / CSR_BYTE_WORD_ADDRESS_MODE; //Appears as 32'h1000_0000 for WORD addressing.
        
    parameter KR_GIGE_PCS_CONTROL_ADDR                      = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h90;
    parameter KR_GIGE_PCS_STATUS_ADDR                       = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h91;
    parameter KR_GIGE_PCS_PHY_INDENTIFIER_HI_ADDR           = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h92;
    parameter KR_GIGE_PCS_PHY_INDENTIFIER_LO_ADDR           = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h93;
    parameter KR_GIGE_PCS_DEV_ABILITY_ADDR                  = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h94;
    parameter KR_GIGE_PCS_PARTNER_ABILITY_ADDR              = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h95;
    parameter KR_GIGE_PCS_AN_EXPANSION_ADDR                 = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h96;
        
    parameter KR_GIGE_PCS_EXT_SCRATCH_ADDR                  = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA0;
    parameter KR_GIGE_PCS_EXT_REV_ADDR                      = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA1;
    parameter KR_GIGE_PCS_EXT_LINK_TIMER_LO_ADDR            = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA2;
    parameter KR_GIGE_PCS_EXT_LINK_TIMER_HI_ADDR            = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA3;
    
    parameter KR_GIGE_PCS_IF_MODE_ADDR                      = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA4;
    
    // KR GIGE PCS within Design Example
    parameter PHY_MGMT_ADDR                                 = 32'h8_0000 / CSR_BYTE_WORD_ADDRESS_MODE; // This is for Design Example, ideally the KR_GIGE_PCS_ADDR need to change so that both this share the same address.
    parameter PHY_MGMT_KR_GIGE_PCS_CONTROL_ADDR                      = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h90;
    parameter PHY_MGMT_KR_GIGE_PCS_STATUS_ADDR                       = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h91;
    parameter PHY_MGMT_KR_GIGE_PCS_PHY_INDENTIFIER_HI_ADDR           = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h92;
    parameter PHY_MGMT_KR_GIGE_PCS_PHY_INDENTIFIER_LO_ADDR           = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h93;
    parameter PHY_MGMT_KR_GIGE_PCS_DEV_ABILITY_ADDR                  = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h94;
    parameter PHY_MGMT_KR_GIGE_PCS_PARTNER_ABILITY_ADDR              = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h95;
    parameter PHY_MGMT_KR_GIGE_PCS_AN_EXPANSION_ADDR                 = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h96;
        
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_SCRATCH_ADDR                  = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA0;
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_REV_ADDR                      = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA1;
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_LINK_TIMER_LO_ADDR            = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA2;
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_LINK_TIMER_HI_ADDR            = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA3;
    
    parameter PHY_MGMT_KR_GIGE_PCS_IF_MODE_ADDR                      = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA4;
    
    //Too bad, due to support 1G/10G PHY, access to the TSE PCS is needed even this is 10G test
    // ------------------------------------------------------------------------------------------
    // PCS Control
    // ------------------------------------------------------------------------------------------
    parameter TSE_PCS_CONTROL_SPEED_SELECTION_LSB_OFFSET                    = 13;
    parameter TSE_PCS_CONTROL_SPEED_SELECTION_MSB_OFFSET                    = 6;
    parameter TSE_PCS_CONTROL_COLLISION_TEST_OFFSET                         = 7;
    parameter TSE_PCS_CONTROL_DUPLEX_MODE_OFFSET                            = 8;
    parameter TSE_PCS_CONTROL_RESTART_AUTO_NEGOTIATION_OFFSET               = 9;
    parameter TSE_PCS_CONTROL_ISOLATE_OFFSET                                = 10;
    parameter TSE_PCS_CONTROL_POWERDOWN_OFFSET                              = 11;
    parameter TSE_PCS_CONTROL_AUTO_NEGOTIATION_ENABLE_OFFSET                = 12;
    parameter TSE_PCS_CONTROL_LOOPBACK_OFFSET                               = 14;
    parameter TSE_PCS_CONTROL_RESET_OFFSET                                  = 15;
    
    // ------------------------------------------------------------------------------------------
    // PCS if_mode
    // ------------------------------------------------------------------------------------------
    parameter TSE_PCS_IF_MODE_SGMII_ENA_OFFSET                              = 0;
    parameter TSE_PCS_IF_MODE_USE_SGMII_AN_OFFSET                           = 1;
    parameter TSE_PCS_IF_MODE_SGMII_SPEED_OFFSET                            = 2;
    parameter TSE_PCS_IF_MODE_SGMII_DUPLEX_OFFSET                           = 4;
    parameter TSE_PCS_IF_MODE_SGMII_PHY_MODE_OFFSET                           = 5;
    
    // ------------------------------------------------------------------------------------------
    // PCS Status Register
    // ------------------------------------------------------------------------------------------
    parameter TSE_PCS_STATUS_EXTENDED_CAPABILITIES_OFFSET                  = 0;
    parameter TSE_PCS_STATUS_JABBER_DETECT_OFFSET                          = 1;
    parameter TSE_PCS_STATUS_LINK_STATUS_OFFSET                            = 2;
    parameter TSE_PCS_STATUS_AUTO_NEGOTIATION_ABILITY_OFFSET               = 3;
    parameter TSE_PCS_STATUS_REMOTE_FAULT_OFFSET                           = 4;
    parameter TSE_PCS_STATUS_AUTO_NEGOTIATION_COMPLETE_OFFSET              = 5;
    parameter TSE_PCS_STATUS_MF_PREAMBLE_SUPPRESSION_OFFSET                = 6;
    parameter TSE_PCS_STATUS_UNIDIRECTIONAL_ABILITY_OFFSET                 = 7;
    parameter TSE_PCS_STATUS_EXTENDED_STATUS_OFFSET                        = 8;

    // ------------------------------------------------------------------------------------------
    // PCS Dev_Ability and Partner_Ability Register Bits in 1000BASE-X
    // ------------------------------------------------------------------------------------------
    parameter TSE_PCS_DEV_ABILITY_FD_OFFSET                        = 5;
    parameter TSE_PCS_DEV_ABILITY_HD_OFFSET                        = 6;
    parameter TSE_PCS_DEV_ABILITY_PS1_OFFSET                       = 7;
    parameter TSE_PCS_DEV_ABILITY_PS2_OFFSET                       = 8;
    parameter TSE_PCS_DEV_ABILITY_RF1_OFFSET                       = 12;
    parameter TSE_PCS_DEV_ABILITY_RF2_OFFSET                       = 13;
    parameter TSE_PCS_DEV_ABILITY_ACK_OFFSET                       = 14;
    parameter TSE_PCS_DEV_ABILITY_NP_OFFSET                        = 15;
    
    // ------------------------------------------------------------------------------------------
    // PCS  Partner_Ability Register Bits in SGMII
    // ------------------------------------------------------------------------------------------
    parameter TSE_PCS_PARTNER_ABILITY_COPPER_SPEED_OFFSET          = 10;
    parameter TSE_PCS_PARTNER_ABILITY_COPPER_DUPLEX_STATUS_OFFSET  = 12;
    parameter TSE_PCS_PARTNER_ABILITY_ACK_OFFSET                   = 14;
    parameter TSE_PCS_PARTNER_ABILITY_COPPER_LINK_STATUS_OFFSET    = 15;
    
    // ------------------------------------------------------------------------------------------
    // PCS  An_Expansion Register
    // ------------------------------------------------------------------------------------------
    parameter TSE_PCS_AN_ENPANSION_LINK_PARTNER_AUTO_NEGOTATION_ABLE_OFFSET     = 0;
    parameter TSE_PCS_AN_ENPANSION_PAGE_RECEIVE_OFFSET             		= 1;
    parameter TSE_PCS_AN_NEXT_PAGE_ABLE_OFFSET                     		= 2;

    // ------------------------------------------------------------------------------------------
    // Configure Reconfiguration Module for 1G/10G Design Example
    // ------------------------------------------------------------------------------------------
    parameter CONFIGURE_RECONFIG_ADDR                              = 32'h10800 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter CONFIGURE_RECONFIG_1G_10GBAR_ADDR                    = CONFIGURE_RECONFIG_ADDR + CSR_REG_OFFSET * 32'h1;

    // ------------------------------------------------------------------------------------------
    // Reconfig Block for MGE
    // ------------------------------------------------------------------------------------------
    parameter RCFG_LOGICAL_CHANNEL_NUM_ADDR                     = 32'h0;
    parameter RCFG_CONTROL_ADDR                                 = 32'h1;
    parameter RCFG_STATUS_ADDR                                  = 32'h2;    

    // ******************************************************************************************
    // Registers Address of MGE PHY Block
    // ******************************************************************************************
    parameter PHY_IF_MODE_ADDR                     = 32'h14;
    parameter PHY_CONTROL_ADDR                     = 32'h00;
    parameter PHY_DEV_ABILITY_ADDR                 = 32'h04;
    parameter PHY_PARTNER_ABILITY_ADDR             = 32'h05;
    parameter PHY_LINK_TIMER_L_ADDR                = 32'h12;
    parameter PHY_LINK_TIMER_H_ADDR                = 32'h13;
    
    // ------------------------------------------------------------------------------------------
    // Soft PCS for MGE
    // ------------------------------------------------------------------------------------------
    parameter MGE_GIGE_PCS_ADDR                              = 32'h0001_8000 / CSR_BYTE_WORD_ADDRESS_MODE;
    
    parameter MGE_GIGE_PCS_CONTROL_ADDR                      = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h00;
    parameter MGE_GIGE_PCS_STATUS_ADDR                       = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h01;
    parameter MGE_GIGE_PCS_PHY_INDENTIFIER_HI_ADDR           = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h02;
    parameter MGE_GIGE_PCS_PHY_INDENTIFIER_LO_ADDR           = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h03;
    parameter MGE_GIGE_PCS_DEV_ABILITY_ADDR                  = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h04;
    parameter MGE_GIGE_PCS_PARTNER_ABILITY_ADDR              = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h05;
    parameter MGE_GIGE_PCS_AN_EXPANSION_ADDR                 = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h06;
    
    parameter MGE_GIGE_PCS_EXT_SCRATCH_ADDR                  = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h10;
    parameter MGE_GIGE_PCS_EXT_REV_ADDR                      = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h11;
    parameter MGE_GIGE_PCS_EXT_LINK_TIMER_LO_ADDR            = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h12;
    parameter MGE_GIGE_PCS_EXT_LINK_TIMER_HI_ADDR            = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h13;
    
    parameter MGE_GIGE_PCS_IF_MODE_ADDR                      = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h14;
    
    // Direct Mapping /wo addr adapt
    parameter TX_ETH_FRAME_DECODER_VLANDET_DIS_ADDR = 10'h02D;
    parameter RX_ETH_FRAME_DECODER_VLANDET_DIS_ADDR = 10'h0AF;

    // ------------------------------------------------------------------------------------------
    // Register Address of NBASET PHY - Word Addressing
    // ------------------------------------------------------------------------------------------
    parameter NBASET_PHY_ADDR                                   = 32'h24000/4;
    parameter NBASET_USXGMII_CONTROL_ADDR                       = NBASET_PHY_ADDR + 32'h400;
    parameter NBASET_USXGMII_STATUS_ADDR                        = NBASET_PHY_ADDR + 32'h401;
    parameter NBASET_USXGMII_DEV_ABILITY_ADDR                   = NBASET_PHY_ADDR + 32'h404;
    parameter NBASET_USXGMII_PARTNER_ABILITY_ADDR               = NBASET_PHY_ADDR + 32'h405;
    parameter NBASET_USXGMII_AN_LINK_TIMER_ADDR                 = NBASET_PHY_ADDR + 32'h412;
    parameter NBASET_USXGMII_EXT_CONTROL_ADDR                   = NBASET_PHY_ADDR + 32'h415;
    parameter NBASET_USXGMII_PHY_SERIAL_LPBK_ADDR               = NBASET_PHY_ADDR + 32'h461;
    
	//Register added for eADIC UXSGMII PCS
	parameter NBASET_USXGMII_AN_RESP_MODE                       = NBASET_PHY_ADDR + 32'h403;
	
    // ------------------------------------------------------------------------------------------
    // NBASET PCS Control Register
    // ------------------------------------------------------------------------------------------
    parameter USXGMII_CONTROL_USXGMII_ENA_OFFSET                = 0;
    parameter USXGMII_CONTROL_USXGMII_AN_ENA_OFFSET             = 1;
    parameter USXGMII_CONTROL_SPEED0_OFFSET                     = 2;
    parameter USXGMII_CONTROL_SPEED1_OFFSET                     = 3;
    parameter USXGMII_CONTROL_SPEED2_OFFSET                     = 4;
    parameter USXGMII_CONTROL_RESTART_AUTO_NEGOTIATION_OFFSET   = 9;
    
    // ------------------------------------------------------------------------------------------
    // NBASET PCS Status Register
    // ------------------------------------------------------------------------------------------
    parameter USXGMII_STATUS_LINK_STATUS_OFFSET                 = 2;
    parameter USXGMII_AUTO_NEGOTIATION_COMPLETE_OFFSET          = 5;
    
    // ------------------------------------------------------------------------------------------
    // NBASET PCS Device Ability Register
    // ------------------------------------------------------------------------------------------
    parameter USXGMII_DEV_ABILITY_EEE_CLOCK_STOP_OFFSET         = 7;
    parameter USXGMII_DEV_ABILITY_EEE_CAPABILITY_OFFSET         = 8;
    parameter USXGMII_DEV_ABILITY_SPEED0_OFFSET                 = 9;
    parameter USXGMII_DEV_ABILITY_SPEED1_OFFSET                 = 10;
    parameter USXGMII_DEV_ABILITY_SPEED2_OFFSET                 = 11;
    parameter USXGMII_DEV_ABILITY_DUPLEX_OFFSET                 = 12;
    parameter USXGMII_DEV_ABILITY_ACK_OFFSET                    = 14;

    // ------------------------------------------------------------------------------------------
    // NBASET PCS Partner Ability Register
    // ------------------------------------------------------------------------------------------
    parameter USXGMII_PARTNER_ABILITY_EEE_CLOCK_STOP_OFFSET     = 7;
    parameter USXGMII_PARTNER_ABILITY_EEE_CAPABILITY_OFFSET     = 8;
    parameter USXGMII_PARTNER_ABILITY_SPEED0_OFFSET             = 9;
    parameter USXGMII_PARTNER_ABILITY_SPEED1_OFFSET             = 10;
    parameter USXGMII_PARTNER_ABILITY_SPEED2_OFFSET             = 11;
    parameter USXGMII_PARTNER_ABILITY_DUPLEX_OFFSET             = 12;
    parameter USXGMII_PARTNER_ABILITY_ACK_OFFSET                = 14;
    parameter USXGMII_PARTNER_ABILITY_LINK_OFFSET               = 15;

    // ------------------------------------------------------------------------------------------
    // NBASET PCS Link Timer Register
    // ------------------------------------------------------------------------------------------
    parameter USXGMII_AN_LINK_TIMER_LSB_OFFSET                  = 14;
    parameter USXGMII_AN_LINK_TIMER_MSB_OFFSET                  = 19;

    // ------------------------------------------------------------------------------------------
    // NBASET PCS Extended Control Register
    // ------------------------------------------------------------------------------------------
    parameter USXGMII_EXT_CONTROL_UMII_FAULT_OFFSET             = 0;
    
	parameter PCS_CONTROL_ADDR                              = 12'h400;

//`else


// *******************************//
// CSR Addresses with CSR Adapter //
// *******************************//


// ******************************************************************************************
// Address Offset of Components
// ******************************************************************************************
  //  parameter CSR_ADDR_WIDTH                            = 32;
    
    //`ifdef CSR_ADDRESS_MODE_DWORD
      //  parameter CSR_BYTE_WORD_ADDRESS_MODE            = 4;
        //parameter CSR_REG_OFFSET                        = 1;
   // `else
     //   parameter CSR_BYTE_WORD_ADDRESS_MODE            = 1;
       // parameter CSR_REG_OFFSET                        = CSR_ADDR_WIDTH / 8;
   // `endif
    
    
    
    
    
    // ------------------------------------------------------------------------------------------
    // MAC
    // ------------------------------------------------------------------------------------------
   /* parameter ETH_MAC_ADDR                              = 32'h000 / CSR_BYTE_WORD_ADDRESS_MODE;
    
    `ifdef ETH_10G_MAC_SEPARATED_TX_RX
        parameter ETH_MAC_RX_ADDR                       = ETH_MAC_ADDR + 32'h00000;
        parameter ETH_MAC_TX_ADDR                       = ETH_MAC_ADDR + 32'h14000;
    `else
        parameter ETH_MAC_RX_ADDR                       = ETH_MAC_ADDR + 32'h0000;
        parameter ETH_MAC_TX_ADDR                       = ETH_MAC_ADDR + 32'h4000;
    `endif
    
    parameter RX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR      = (ETH_MAC_RX_ADDR + 32'h000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_ETH_CRC_PAD_REMOVAL_ADDR               = (ETH_MAC_RX_ADDR + 32'h100) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_ETH_CRC_CHECKER_ADDR                   = (ETH_MAC_RX_ADDR + 32'h200) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_ETH_FRAME_DECODER_ADDR                 = (ETH_MAC_RX_ADDR + 32'h2000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_ETH_PKT_OVERFLOW_CONTROL_ADDR          = (ETH_MAC_RX_ADDR + 32'h300) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_ETH_PREAMBLE_CONTROL_ADDR              = (ETH_MAC_RX_ADDR + 32'h400) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_ETH_PFC_CTRL_ADDR                      = (ETH_MAC_RX_ADDR + 32'h2060)/ CSR_BYTE_WORD_ADDRESS_MODE;
    
    parameter TX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR      = (ETH_MAC_TX_ADDR + 32'h000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_PAD_INSERTER_ADDR                  = (ETH_MAC_TX_ADDR + 32'h100) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_CRC_INSERTER_ADDR                  = (ETH_MAC_TX_ADDR + 32'h200) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_PREAMBLE_CONTROL_ADDR              = (ETH_MAC_TX_ADDR + 32'h400) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_PAUSE_CTRL_GEN_ADDR                = (ETH_MAC_TX_ADDR + 32'h500) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_ADDRESS_INSERTER_ADDR              = (ETH_MAC_TX_ADDR + 32'h800) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_FRAME_DECODER_ADDR                 = (ETH_MAC_TX_ADDR + 32'h2000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_PKT_UNDERFLOW_CONTROL_ADDR         = (ETH_MAC_TX_ADDR + 32'h300) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_PFC_GEN_ADDR                       = (ETH_MAC_TX_ADDR + 32'h600) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_FRAME_CTRL_ADDR                    = (ETH_MAC_TX_ADDR + 32'h2004) / CSR_BYTE_WORD_ADDRESS_MODE;
    
    parameter RX_ETH_STATISTICS_COLLECTOR_ADDR          = (ETH_MAC_RX_ADDR + 32'h3000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_ETH_STATISTICS_COLLECTOR_ADDR          = (ETH_MAC_TX_ADDR + 32'h3000) / CSR_BYTE_WORD_ADDRESS_MODE;*/

    // New CSR in 32b MAC (sync with CSR adapter mapping)
   /* parameter MAC_REVISION_ADDR                = 13'h0819;
    parameter MAC_CAPABILITY_ADDR              = 13'h081B;
    parameter TX_ETH_PAUSE_HOLDOFF_QUANTA_ADDR = 13'h081D;
    parameter TX_ETH_PIPG_10G_ADDR             = 13'h081E;
    parameter TX_ETH_PIPG_1G_ADDR              = 13'h081F;
    parameter ECC_STATUS_ADDR                  = 13'h0820;
    parameter ECC_STATUS_ENABLE_ADDR           = 13'h0821;
	parameter MAC_COMMON_STATUS		           = 13'h08FE;
	parameter TXRX_SOFTWARE_RESET_ADDR		   = 13'h08FF;
	parameter TX_ETH_FRAME_DECODER_VLANDET_DIS_ADDR = 10'h02d;
	parameter RX_ETH_FRAME_DECODER_VLANDET_DIS_ADDR = 13'h0830;*/

    // Unidirectional Ethernet
   /* parameter TX_ETH_UNIDIECTIONAL_ADDR                 = (ETH_MAC_TX_ADDR + 32'h480) / CSR_BYTE_WORD_ADDRESS_MODE;*/

    // ------------------------------------------------------------------------------------------
    // RX PFC Control
    // ------------------------------------------------------------------------------------------
   //parameter RX_ETH_PFC_CTRL_EN_ADDR                   = RX_ETH_PFC_CTRL_ADDR + CSR_REG_OFFSET * 0;

    // ------------------------------------------------------------------------------------------
    // XAUI PCS
    // ------------------------------------------------------------------------------------------
    /*parameter ETH_PCS_XAUI_ADDR                         = 32'h40000 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter ETH_PCS_XAUI_PMA_CONTROLLER_ADDR          = ETH_PCS_XAUI_ADDR + 32'h80;
    parameter ETH_PCS_XAUI_POWERDOWN_ADDR               = ETH_PCS_XAUI_PMA_CONTROLLER_ADDR + CSR_REG_OFFSET * 1;
    parameter ETH_PCS_XAUI_GXB_POWERDOWN_OFFSET         = 1;
    
    parameter ETH_PCS_XAUI_CSR_ADDR                     = ETH_PCS_XAUI_ADDR + 32'h200;
    parameter ETH_PCS_XAUI_SIMULATION_FLAG_ADDR         = ETH_PCS_XAUI_CSR_ADDR + 32'h28;*/
    
    
    
    
    
    // ------------------------------------------------------------------------------------------
    // RX FIFO
    // ------------------------------------------------------------------------------------------
  /*  parameter RX_FIFO_ADDR                              = 32'h10400 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter RX_FIFO_ALMOST_FULL_THRESHOLD_ADDR        = RX_FIFO_ADDR + CSR_REG_OFFSET * 2;
    parameter RX_FIFO_ALMOST_EMPTY_THRESHOLD_ADDR       = RX_FIFO_ADDR + CSR_REG_OFFSET * 3;
    parameter RX_FIFO_CUT_THROUGH_THRESHOLD_ADDR        = RX_FIFO_ADDR + CSR_REG_OFFSET * 4;
    parameter RX_FIFO_DROP_ON_ERROR_ADDR                = RX_FIFO_ADDR + CSR_REG_OFFSET * 5;*/
    
    // ------------------------------------------------------------------------------------------
    // TX FIFO
    // ------------------------------------------------------------------------------------------
   /* parameter TX_FIFO_ADDR                              = 32'h10600 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter TX_FIFO_ALMOST_FULL_THRESHOLD_ADDR        = TX_FIFO_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_FIFO_ALMOST_EMPTY_THRESHOLD_ADDR       = TX_FIFO_ADDR + CSR_REG_OFFSET * 3;
    parameter TX_FIFO_CUT_THROUGH_THRESHOLD_ADDR        = TX_FIFO_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_FIFO_DROP_ON_ERROR_ADDR                = TX_FIFO_ADDR + CSR_REG_OFFSET * 5;*/
    
    
    
    
    
    // ------------------------------------------------------------------------------------------
    // Loopback
    // ------------------------------------------------------------------------------------------
   /* parameter LOOPBACK_COMPOSED_ADDR                    = 32'h10200 / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter LINE_LOOPBACK_ADDR                        = (LOOPBACK_COMPOSED_ADDR + 32'h000) / CSR_BYTE_WORD_ADDRESS_MODE;
    parameter LOCAL_LOOPBACK_ADDR                       = (LOOPBACK_COMPOSED_ADDR + 32'h008) / CSR_BYTE_WORD_ADDRESS_MODE;*/
    
    
    
    
    
// ******************************************************************************************
// Registers Offset of Components
// ******************************************************************************************

    // ------------------------------------------------------------------------------------------
    // RX Packet Backpressure Control
    // ------------------------------------------------------------------------------------------
   // parameter RX_ETH_PKT_BACKPRESSURE_CONTROL_CONTROL_ADDR      = RX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
   // parameter RX_ETH_PKT_BACKPRESSURE_CONTROL_STATUS_ADDR       = RX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 1;
    
    // ------------------------------------------------------------------------------------------
    // RX CRC Checker
    // ------------------------------------------------------------------------------------------
    //parameter RX_ETH_CRC_CHECKER_CONTROL_ADDR                   = RX_ETH_CRC_CHECKER_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // RX CRC/Pad Removal
    // ------------------------------------------------------------------------------------------
    //parameter RX_ETH_CRC_PAD_REMOVAL_CONTROL_ADDR               = RX_ETH_CRC_PAD_REMOVAL_ADDR + CSR_REG_OFFSET * 0;

    // ------------------------------------------------------------------------------------------
    // RX Preamble Control
    // ------------------------------------------------------------------------------------------
   // parameter RX_ETH_PREAMBLE_CONTROL_CTRL_ADDR                 = RX_ETH_PREAMBLE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
   // parameter RX_ETH_PREAMBLE_CONTROL_PASSTHRU_EN_ADDR          = RX_ETH_PREAMBLE_CONTROL_ADDR + CSR_REG_OFFSET * 64;

    // ------------------------------------------------------------------------------------------
    // RX Frame Decoder
    // ------------------------------------------------------------------------------------------
   /* parameter RX_ETH_FRAME_DECODER_CONTROL_ADDR                 = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 0;
    parameter RX_ETH_FRAME_DECODER_MAX_FRAME_LENGTH_ADDR        = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 1;
    parameter RX_ETH_FRAME_DECODER_UCAST_MAC_ADD_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 2;
    parameter RX_ETH_FRAME_DECODER_UCAST_MAC_ADD_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 3;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 4;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 5;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 6;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 7;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 8;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 9;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_0_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 10;
    parameter RX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_1_ADDR         = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 11;
    parameter RX_ETH_FRAME_DECODER_PFC_CONTROL_ADDR             = RX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 24;*/
    
    // ------------------------------------------------------------------------------------------
    // RX Packet Overflow Control
    // ------------------------------------------------------------------------------------------
   // parameter RX_ETH_PKT_OVERFLOW_CONTROL_TRUNCATE_COUNTER_ADDR = RX_ETH_PKT_OVERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    //parameter RX_ETH_PKT_OVERFLOW_CONTROL_DROP_COUNTER_ADDR     = RX_ETH_PKT_OVERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 2;
    
    // ------------------------------------------------------------------------------------------
    // RX Statistics Collector
    // ------------------------------------------------------------------------------------------
   /* parameter RX_ETH_STATISTICS_COLLECTOR_CLR_ADDR                              = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 0;
    parameter RX_ETH_STATISTICS_COLLECTOR_framesOK_ADDR                         = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 2;
    parameter RX_ETH_STATISTICS_COLLECTOR_framesErr_ADDR                        = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 4;
    parameter RX_ETH_STATISTICS_COLLECTOR_framesCRCErr_ADDR                     = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 6;
    parameter RX_ETH_STATISTICS_COLLECTOR_octetsOK_ADDR                         = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 8;
    parameter RX_ETH_STATISTICS_COLLECTOR_pauseMACCtrlFrames_ADDR               = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 10;
    parameter RX_ETH_STATISTICS_COLLECTOR_ifErrors_ADDR                         = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 12;
    parameter RX_ETH_STATISTICS_COLLECTOR_unicastFramesOK_ADDR                  = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 14;
    parameter RX_ETH_STATISTICS_COLLECTOR_unicastFramesErr_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 16;
    parameter RX_ETH_STATISTICS_COLLECTOR_multicastFramesOK_ADDR                = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 18;
    parameter RX_ETH_STATISTICS_COLLECTOR_multicastFramesErr_ADDR               = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 20;
    parameter RX_ETH_STATISTICS_COLLECTOR_broadcastFramesOK_ADDR                = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 22;
    parameter RX_ETH_STATISTICS_COLLECTOR_broadcastFramesErr_ADDR               = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 24;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsOctets_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 26;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts_ADDR                   = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 28;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsUndersizePkts_ADDR          = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 30;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsOversizePkts_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 32;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts64Octets_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 34;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts65to127Octets_ADDR      = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 36;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts128to255Octets_ADDR     = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 38;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts256to511Octets_ADDR     = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 40;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts512to1023Octets_ADDR    = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 42;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1024to1518Octets_ADDR   = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 44;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1519toXOctets_ADDR      = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 46;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsFragments_ADDR              = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 48;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsJabbers_ADDR                = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 50;
    parameter RX_ETH_STATISTICS_COLLECTOR_etherStatsCRCErr_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 52;
    parameter RX_ETH_STATISTICS_COLLECTOR_unicastMACCtrlFrames_ADDR             = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 54;
    parameter RX_ETH_STATISTICS_COLLECTOR_multicastMACCtrlFrames_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 56;
    parameter RX_ETH_STATISTICS_COLLECTOR_broadcastMACCtrlFrames_ADDR           = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 58;
    parameter RX_ETH_STATISTICS_COLLECTOR_pfcMACCtrlFrames_ADDR                 = RX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 60;*/
    
    
    
    
    
    // ------------------------------------------------------------------------------------------
    // TX Packet Backpressure Control
    // ------------------------------------------------------------------------------------------
    //parameter TX_ETH_PKT_BACKPRESSURE_CONTROL_CONTROL_ADDR      = TX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
  //  parameter TX_ETH_PKT_BACKPRESSURE_CONTROL_STATUS_ADDR       = TX_ETH_PKT_BACKPRESSURE_CONTROL_ADDR + CSR_REG_OFFSET * 1;
    
    // ------------------------------------------------------------------------------------------
    // TX CRC Inserter
    // ------------------------------------------------------------------------------------------
    //parameter TX_ETH_CRC_INSERTER_CONTROL_ADDR                  = TX_ETH_CRC_INSERTER_ADDR + CSR_REG_OFFSET * 0;

    // ------------------------------------------------------------------------------------------
    // TX Preamble Control
    // ------------------------------------------------------------------------------------------
    //parameter TX_ETH_PREAMBLE_CONTROL_PASSTHRU_EN_ADDR          = TX_ETH_PREAMBLE_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // TX FRAME Control
    // ------------------------------------------------------------------------------------------
   // parameter TX_ETH_FRAME_CTRL_MAX_DATAFRMLEN_ADDR             = TX_ETH_FRAME_CTRL_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // TX Pad Inserter
    // ------------------------------------------------------------------------------------------
    //parameter TX_ETH_PAD_INSERTER_CONTROL_ADDR                  = TX_ETH_PAD_INSERTER_ADDR + CSR_REG_OFFSET * 0;
    
    // ------------------------------------------------------------------------------------------
    // TX Pause Frame Control
    // ------------------------------------------------------------------------------------------
    //parameter TX_ETH_PAUSE_CTRL_GEN_ADDR_CONTROL_ADDR           = TX_ETH_PAUSE_CTRL_GEN_ADDR + CSR_REG_OFFSET * 0;
   // parameter TX_ETH_PAUSE_CTRL_GEN_ADDR_PAUSE_QUANTA_ADDR      = TX_ETH_PAUSE_CTRL_GEN_ADDR + CSR_REG_OFFSET * 1;
    //parameter TX_ETH_PAUSE_CTRL_GEN_PAUSE_GEN_ENA_ADDR          = TX_ETH_PAUSE_CTRL_GEN_ADDR + CSR_REG_OFFSET * 2;
    
    // ------------------------------------------------------------------------------------------
    // TX Address Inserter
    // ------------------------------------------------------------------------------------------
   // parameter TX_ETH_ADDRESS_INSERTER_CONTROL_ADDR              = TX_ETH_ADDRESS_INSERTER_ADDR + CSR_REG_OFFSET * 0;
    //parameter TX_ETH_ADDRESS_INSERTER_UCAST_MAC_ADD_0_ADDR      = TX_ETH_ADDRESS_INSERTER_ADDR + CSR_REG_OFFSET * 1;
    //parameter TX_ETH_ADDRESS_INSERTER_UCAST_MAC_ADD_1_ADDR      = TX_ETH_ADDRESS_INSERTER_ADDR + CSR_REG_OFFSET * 2;
    
    // ------------------------------------------------------------------------------------------
    // TX Frame Decoder
    // ------------------------------------------------------------------------------------------
  /*  parameter TX_ETH_FRAME_DECODER_CONTROL_ADDR                 = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_FRAME_DECODER_MAX_FRAME_LENGTH_ADDR        = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 1;
    parameter TX_ETH_FRAME_DECODER_UCAST_MAC_ADD_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_FRAME_DECODER_UCAST_MAC_ADD_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 3;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD0_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 5;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 6;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD1_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 7;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 8;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD2_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 9;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_0_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 10;
    parameter TX_ETH_FRAME_DECODER_SUPP_MAC_ADD3_1_ADDR         = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 11;
    parameter TX_ETH_FRAME_DECODER_PFC_CONTROL_ADDR             = TX_ETH_FRAME_DECODER_ADDR + CSR_REG_OFFSET * 24;*/
    
    // ------------------------------------------------------------------------------------------
    // TX Packet Underflow Control
    // ------------------------------------------------------------------------------------------
    //parameter TX_ETH_PKT_UNDERFLOW_CONTROL_COUNTER_ADDR         = TX_ETH_PKT_UNDERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 0;
    //parameter TX_ETH_PKT_UNDERFLOW_CONTROL_COUNTER_UPPER_ADDR   = TX_ETH_PKT_UNDERFLOW_CONTROL_ADDR + CSR_REG_OFFSET * 1; //TX Underflow Error
	    
    // ------------------------------------------------------------------------------------------
    // TX PFC Generator
    // ------------------------------------------------------------------------------------------
   /* parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_0_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_1_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 1;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_2_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_3_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 3;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_4_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_5_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 5;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_6_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 6;
    parameter TX_ETH_PFC_GEN_PAUSE_QUANTA_7_ADDR                = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 7;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_0_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 16;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_1_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 17;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_2_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 18;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_3_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 19;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_4_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 20;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_5_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 21;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_6_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 22;
    parameter TX_ETH_PFC_GEN_HOLDOFF_QUANTA_7_ADDR              = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 23;
    parameter TX_ETH_PFC_GEN_PRIORITY_ENA_ADDR                  = TX_ETH_PFC_GEN_ADDR + CSR_REG_OFFSET * 32;*/
    
    // ------------------------------------------------------------------------------------------
    // TX Statistics Collector
    // ------------------------------------------------------------------------------------------
   /* parameter TX_ETH_STATISTICS_COLLECTOR_CLR_ADDR                              = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 0;
    parameter TX_ETH_STATISTICS_COLLECTOR_framesOK_ADDR                         = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 2;
    parameter TX_ETH_STATISTICS_COLLECTOR_framesErr_ADDR                        = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 4;
    parameter TX_ETH_STATISTICS_COLLECTOR_framesCRCErr_ADDR                     = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 6;
    parameter TX_ETH_STATISTICS_COLLECTOR_octetsOK_ADDR                         = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 8;
    parameter TX_ETH_STATISTICS_COLLECTOR_pauseMACCtrlFrames_ADDR               = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 10;
    parameter TX_ETH_STATISTICS_COLLECTOR_ifErrors_ADDR                         = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 12;
    parameter TX_ETH_STATISTICS_COLLECTOR_unicastFramesOK_ADDR                  = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 14;
    parameter TX_ETH_STATISTICS_COLLECTOR_unicastFramesErr_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 16;
    parameter TX_ETH_STATISTICS_COLLECTOR_multicastFramesOK_ADDR                = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 18;
    parameter TX_ETH_STATISTICS_COLLECTOR_multicastFramesErr_ADDR               = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 20;
    parameter TX_ETH_STATISTICS_COLLECTOR_broadcastFramesOK_ADDR                = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 22;
    parameter TX_ETH_STATISTICS_COLLECTOR_broadcastFramesErr_ADDR               = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 24;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsOctets_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 26;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts_ADDR                   = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 28;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsUndersizePkts_ADDR          = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 30;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsOversizePkts_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 32;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts64Octets_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 34;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts65to127Octets_ADDR      = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 36;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts128to255Octets_ADDR     = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 38;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts256to511Octets_ADDR     = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 40;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts512to1023Octets_ADDR    = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 42;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1024to1518Octets_ADDR   = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 44;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsPkts1519toXOctets_ADDR      = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 46;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsFragments_ADDR              = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 48;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsJabbers_ADDR                = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 50;
    parameter TX_ETH_STATISTICS_COLLECTOR_etherStatsCRCErr_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 52;
    parameter TX_ETH_STATISTICS_COLLECTOR_unicastMACCtrlFrames_ADDR             = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 54;
    parameter TX_ETH_STATISTICS_COLLECTOR_multicastMACCtrlFrames_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 56;
    parameter TX_ETH_STATISTICS_COLLECTOR_broadcastMACCtrlFrames_ADDR           = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 58;
    parameter TX_ETH_STATISTICS_COLLECTOR_pfcMACCtrlFrames_ADDR                 = TX_ETH_STATISTICS_COLLECTOR_ADDR + CSR_REG_OFFSET * 60;*/
    
    // Unidirectional Ethernet
   // parameter TX_ETH_UNIDIECTIONAL_ENA                 = TX_ETH_UNIDIECTIONAL_ADDR + CSR_REG_OFFSET * 0;
  //  parameter TX_ETH_UNIDIECTIONAL_RMTSTS_EN           = TX_ETH_UNIDIECTIONAL_ADDR + CSR_REG_OFFSET * 1;
   // parameter TX_ETH_UNIDIECTIONAL_RMTFLT_EN           = TX_ETH_UNIDIECTIONAL_ADDR + CSR_REG_OFFSET * 2;
    
    //parameter TX_ETH_UNIDIECTIONAL_ENA_OFFSET                 = 0;
   // parameter TX_ETH_UNIDIECTIONAL_RMTSTS_EN_OFFSET           = 1;  
   // parameter TX_ETH_UNIDIECTIONAL_RMTFLT_EN_OFFSET           = 2;  
    
// ******************************************************************************************
// Register Offset of Components
// ******************************************************************************************    

    // ------------------------------------------------------------------------------------------
    // Preamble Control
    // ------------------------------------------------------------------------------------------    
   // parameter ETH_PREAMBLE_CONTROL_OFFSET                               = 0;
    
    // ------------------------------------------------------------------------------------------
    // Packet Backpressure Control
    // ------------------------------------------------------------------------------------------
   // parameter ETH_PKT_BACKPRESSURE_CONTROL_CONTROL_STOP_X_OFFSET        = 0;
    //parameter ETH_PKT_BACKPRESSURE_CONTROL_STATUS_STATUS_OFFSET         = 0;
    
    // ------------------------------------------------------------------------------------------
    // CRC
    // ------------------------------------------------------------------------------------------
   // parameter ETH_CRC_CONTROL_MODE_OFFSET                               = 0;
   // parameter ETH_CRC_CONTROL_ENABLE_OFFSET                             = 1;
    
    // ------------------------------------------------------------------------------------------
    // Pad Inserter
    // ------------------------------------------------------------------------------------------
   // parameter ETH_PAD_INSERTER_PAD_INS_OFFSET                           = 0;
	
	// ------------------------------------------------------------------------------------------
    // Pause Frame Control
    // ------------------------------------------------------------------------------------------
   // parameter ETH_PAUSE_CTRL_GEN_ADDR_CONTROL_XON_OFFSET           	    = 0;
   // parameter ETH_PAUSE_CTRL_GEN_ADDR_CONTROL_XOFF_OFFSET      	        = 1;
    
    //parameter ETH_PAUSE_CTRL_GEN_PAUSE_GEN_ENA_OFFSET                   = 0;
    
    // ------------------------------------------------------------------------------------------
    // PFC Generator
    // ------------------------------------------------------------------------------------------
   /* parameter ETH_PFC_GEN_PRIORITY_ENA_0_OFFSET           	            = 0;
    parameter ETH_PFC_GEN_PRIORITY_ENA_1_OFFSET      	                = 1;
    parameter ETH_PFC_GEN_PRIORITY_ENA_2_OFFSET      	                = 2;
    parameter ETH_PFC_GEN_PRIORITY_ENA_3_OFFSET      	                = 3;
    parameter ETH_PFC_GEN_PRIORITY_ENA_4_OFFSET      	                = 4;
    parameter ETH_PFC_GEN_PRIORITY_ENA_5_OFFSET      	                = 5;
    parameter ETH_PFC_GEN_PRIORITY_ENA_6_OFFSET      	                = 6;
    parameter ETH_PFC_GEN_PRIORITY_ENA_7_OFFSET      	                = 7;*/
	
	// ------------------------------------------------------------------------------------------
    // Address Inserter
    // ------------------------------------------------------------------------------------------
    //parameter ETH_ADDRESS_INSERTER_CONTROL_INSERT_OFFSET                = 0;
	
	// ------------------------------------------------------------------------------------------
    // Frame Decoder
    // ------------------------------------------------------------------------------------------
    /*parameter ETH_FRAME_DECODER_CONTROL_ALL_UCAST_OFFSET                = 0;
    parameter ETH_FRAME_DECODER_CONTROL_ALL_MCAST_OFFSET                = 1;
    parameter ETH_FRAME_DECODER_CONTROL_DROP_BCAST_OFFSET               = 2;
    parameter ETH_FRAME_DECODER_CONTROL_FORWARD_CONTROL_OFFSET          = 3;
    parameter ETH_FRAME_DECODER_CONTROL_FORWARD_PAUSE_OFFSET            = 4;
    parameter ETH_FRAME_DECODER_CONTROL_IGNORE_PAUSE_OFFSET             = 5;
    parameter ETH_FRAME_DECODER_CONTROL_NO_LEN_CHECK_OFFSET             = 6;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_0_OFFSET               = 16;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_1_OFFSET               = 17;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_2_OFFSET               = 18;
    parameter ETH_FRAME_DECODER_CONTROL_ENA_SUPP_3_OFFSET               = 19;
    
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_0_OFFSET       = 0;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_1_OFFSET       = 1;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_2_OFFSET       = 2;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_3_OFFSET       = 3;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_4_OFFSET       = 4;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_5_OFFSET       = 5;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_6_OFFSET       = 6;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_IGNORE_PAUSE_7_OFFSET       = 7;
    parameter ETH_FRAME_DECODER_PFC_CONTROL_FORWARD_PFC_OFFSET          = 16;*/
    
    // ------------------------------------------------------------------------------------------
    // CRC/Pad Removal
    // ------------------------------------------------------------------------------------------
   // parameter ETH_CRC_PAD_REMOVAL_CONTROL_REMOVE_CRC_ONLY_OFFSET        = 0;
   // parameter ETH_CRC_PAD_REMOVAL_CONTROL_REMOVE_PAD_CRC_OFFSET         = 1;

    // ------------------------------------------------------------------------------------------
    // KR GIGE PCS 
    // ------------------------------------------------------------------------------------------
    // Additional address decoding to shift the KR address 
    
   /* parameter KR_GIGE_PCS_ADDR                              = 32'h8000_0000 / CSR_BYTE_WORD_ADDRESS_MODE; //Appears as 32'h1000_0000 for WORD addressing.
        
    parameter KR_GIGE_PCS_CONTROL_ADDR                      = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h90;
    parameter KR_GIGE_PCS_STATUS_ADDR                       = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h91;
    parameter KR_GIGE_PCS_PHY_INDENTIFIER_HI_ADDR           = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h92;
    parameter KR_GIGE_PCS_PHY_INDENTIFIER_LO_ADDR           = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h93;
    parameter KR_GIGE_PCS_DEV_ABILITY_ADDR                  = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h94;
    parameter KR_GIGE_PCS_PARTNER_ABILITY_ADDR              = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h95;
    parameter KR_GIGE_PCS_AN_EXPANSION_ADDR                 = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h96;
        
    parameter KR_GIGE_PCS_EXT_SCRATCH_ADDR                  = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA0;
    parameter KR_GIGE_PCS_EXT_REV_ADDR                      = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA1;
    parameter KR_GIGE_PCS_EXT_LINK_TIMER_LO_ADDR            = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA2;
    parameter KR_GIGE_PCS_EXT_LINK_TIMER_HI_ADDR            = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA3;
    
    parameter KR_GIGE_PCS_IF_MODE_ADDR                      = KR_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'hA4;*/
    
    // KR GIGE PCS within Design Example
  //  parameter PHY_MGMT_ADDR                                 = 32'h8_0000 / CSR_BYTE_WORD_ADDRESS_MODE; // This is for Design Example, ideally the KR_GIGE_PCS_ADDR need to change so that both this share the same address.
  /*  parameter PHY_MGMT_KR_GIGE_PCS_CONTROL_ADDR                      = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h90;
    parameter PHY_MGMT_KR_GIGE_PCS_STATUS_ADDR                       = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h91;
    parameter PHY_MGMT_KR_GIGE_PCS_PHY_INDENTIFIER_HI_ADDR           = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h92;
    parameter PHY_MGMT_KR_GIGE_PCS_PHY_INDENTIFIER_LO_ADDR           = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h93;
    parameter PHY_MGMT_KR_GIGE_PCS_DEV_ABILITY_ADDR                  = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h94;
    parameter PHY_MGMT_KR_GIGE_PCS_PARTNER_ABILITY_ADDR              = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h95;
    parameter PHY_MGMT_KR_GIGE_PCS_AN_EXPANSION_ADDR                 = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'h96;
        
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_SCRATCH_ADDR                  = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA0;
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_REV_ADDR                      = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA1;
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_LINK_TIMER_LO_ADDR            = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA2;
    parameter PHY_MGMT_KR_GIGE_PCS_EXT_LINK_TIMER_HI_ADDR            = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA3;
    
    parameter PHY_MGMT_KR_GIGE_PCS_IF_MODE_ADDR                      = PHY_MGMT_ADDR + CSR_REG_OFFSET * 32'hA4;*/
    
    //Too bad, due to support 1G/10G PHY, access to the TSE PCS is needed even this is 10G test
    // ------------------------------------------------------------------------------------------
    // PCS Control
    // ------------------------------------------------------------------------------------------
   /* parameter TSE_PCS_CONTROL_SPEED_SELECTION_LSB_OFFSET                    = 13;
    parameter TSE_PCS_CONTROL_SPEED_SELECTION_MSB_OFFSET                    = 6;
    parameter TSE_PCS_CONTROL_COLLISION_TEST_OFFSET                         = 7;
    parameter TSE_PCS_CONTROL_DUPLEX_MODE_OFFSET                            = 8;
    parameter TSE_PCS_CONTROL_RESTART_AUTO_NEGOTIATION_OFFSET               = 9;
    parameter TSE_PCS_CONTROL_ISOLATE_OFFSET                                = 10;
    parameter TSE_PCS_CONTROL_POWERDOWN_OFFSET                              = 11;
    parameter TSE_PCS_CONTROL_AUTO_NEGOTIATION_ENABLE_OFFSET                = 12;
    parameter TSE_PCS_CONTROL_LOOPBACK_OFFSET                               = 14;
    parameter TSE_PCS_CONTROL_RESET_OFFSET                                  = 15;*/
    
    // ------------------------------------------------------------------------------------------
    // PCS if_mode
    // ------------------------------------------------------------------------------------------
  /*  parameter TSE_PCS_IF_MODE_SGMII_ENA_OFFSET                              = 0;
    parameter TSE_PCS_IF_MODE_USE_SGMII_AN_OFFSET                           = 1;
    parameter TSE_PCS_IF_MODE_SGMII_SPEED_OFFSET                            = 2;
    parameter TSE_PCS_IF_MODE_SGMII_DUPLEX_OFFSET                           = 4;
    parameter TSE_PCS_IF_MODE_SGMII_PHY_MODE_OFFSET                           = 5;*/
    
    // ------------------------------------------------------------------------------------------
    // PCS Status Register
    // ------------------------------------------------------------------------------------------
   /* parameter TSE_PCS_STATUS_EXTENDED_CAPABILITIES_OFFSET                  = 0;
    parameter TSE_PCS_STATUS_JABBER_DETECT_OFFSET                          = 1;
    parameter TSE_PCS_STATUS_LINK_STATUS_OFFSET                            = 2;
    parameter TSE_PCS_STATUS_AUTO_NEGOTIATION_ABILITY_OFFSET               = 3;
    parameter TSE_PCS_STATUS_REMOTE_FAULT_OFFSET                           = 4;
    parameter TSE_PCS_STATUS_AUTO_NEGOTIATION_COMPLETE_OFFSET              = 5;
    parameter TSE_PCS_STATUS_MF_PREAMBLE_SUPPRESSION_OFFSET                = 6;
    parameter TSE_PCS_STATUS_UNIDIRECTIONAL_ABILITY_OFFSET                 = 7;
    parameter TSE_PCS_STATUS_EXTENDED_STATUS_OFFSET                        = 8;*/

    // ------------------------------------------------------------------------------------------
    // PCS Dev_Ability and Partner_Ability Register Bits in 1000BASE-X
    // ------------------------------------------------------------------------------------------
    /*parameter TSE_PCS_DEV_ABILITY_FD_OFFSET                        = 5;
    parameter TSE_PCS_DEV_ABILITY_HD_OFFSET                        = 6;
    parameter TSE_PCS_DEV_ABILITY_PS1_OFFSET                       = 7;
    parameter TSE_PCS_DEV_ABILITY_PS2_OFFSET                       = 8;
    parameter TSE_PCS_DEV_ABILITY_RF1_OFFSET                       = 12;
    parameter TSE_PCS_DEV_ABILITY_RF2_OFFSET                       = 13;
    parameter TSE_PCS_DEV_ABILITY_ACK_OFFSET                       = 14;
    parameter TSE_PCS_DEV_ABILITY_NP_OFFSET                        = 15;*/
    
    // ------------------------------------------------------------------------------------------
    // PCS  Partner_Ability Register Bits in SGMII
    // ------------------------------------------------------------------------------------------
 //   parameter TSE_PCS_PARTNER_ABILITY_COPPER_SPEED_OFFSET          = 10;
   // parameter TSE_PCS_PARTNER_ABILITY_COPPER_DUPLEX_STATUS_OFFSET  = 12;
   // parameter TSE_PCS_PARTNER_ABILITY_ACK_OFFSET                   = 14;
   // parameter TSE_PCS_PARTNER_ABILITY_COPPER_LINK_STATUS_OFFSET    = 15;
    
    // ------------------------------------------------------------------------------------------
    // PCS  An_Expansion Register
    // ------------------------------------------------------------------------------------------
   /* parameter TSE_PCS_AN_ENPANSION_LINK_PARTNER_AUTO_NEGOTATION_ABLE_OFFSET     = 0;
    parameter TSE_PCS_AN_ENPANSION_PAGE_RECEIVE_OFFSET             		= 1;
    parameter TSE_PCS_AN_NEXT_PAGE_ABLE_OFFSET                     		= 2;*/
    
    // ------------------------------------------------------------------------------------------
    // Configure Reconfiguration Module for 1G/10G Design Example
    // ------------------------------------------------------------------------------------------
   // parameter CONFIGURE_RECONFIG_ADDR                              = 32'h10800 / CSR_BYTE_WORD_ADDRESS_MODE;
   // parameter CONFIGURE_RECONFIG_1G_10GBAR_ADDR                    = CONFIGURE_RECONFIG_ADDR + CSR_REG_OFFSET * 32'h1;

    // ------------------------------------------------------------------------------------------
    // Reconfig Block for MGE
    // ------------------------------------------------------------------------------------------
    /*parameter RCFG_LOGICAL_CHANNEL_NUM_ADDR                     = 32'h0;
    parameter RCFG_CONTROL_ADDR                                 = 32'h1;
    parameter RCFG_STATUS_ADDR                                  = 32'h2;*/
    
    // ------------------------------------------------------------------------------------------
    // Soft PCS for MGE
    // ------------------------------------------------------------------------------------------
   /* parameter MGE_GIGE_PCS_ADDR                              = 32'h0001_8000 / CSR_BYTE_WORD_ADDRESS_MODE;
    
    parameter MGE_GIGE_PCS_CONTROL_ADDR                      = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h00;
    parameter MGE_GIGE_PCS_STATUS_ADDR                       = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h01;
    parameter MGE_GIGE_PCS_PHY_INDENTIFIER_HI_ADDR           = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h02;
    parameter MGE_GIGE_PCS_PHY_INDENTIFIER_LO_ADDR           = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h03;
    parameter MGE_GIGE_PCS_DEV_ABILITY_ADDR                  = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h04;
    parameter MGE_GIGE_PCS_PARTNER_ABILITY_ADDR              = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h05;
    parameter MGE_GIGE_PCS_AN_EXPANSION_ADDR                 = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h06;
    
    parameter MGE_GIGE_PCS_EXT_SCRATCH_ADDR                  = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h00;
    parameter MGE_GIGE_PCS_EXT_REV_ADDR                      = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h01;
    parameter MGE_GIGE_PCS_EXT_LINK_TIMER_LO_ADDR            = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h02;
    parameter MGE_GIGE_PCS_EXT_LINK_TIMER_HI_ADDR            = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h03;
    
    parameter MGE_GIGE_PCS_IF_MODE_ADDR                      = MGE_GIGE_PCS_ADDR + CSR_REG_OFFSET * 32'h04;*/
    
//`endif //ETH_MGE_MAC
`endif
