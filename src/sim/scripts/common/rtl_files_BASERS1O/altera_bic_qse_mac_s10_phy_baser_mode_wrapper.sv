`timescale 1 ps / 1 ps


module altera_bic_qse_mac_s10_phy_baser_mode_wrapper (
  
  // clock and reset
  input  wire         csr_clk,
  input  wire         csr_rst_n,
  input wire          clk_312_5,
  input wire          clk_156_25,
  input  wire         tx_rst_n,
  input  wire         rx_rst_n,
  
  input wire          ref_clk_clk,
  
  // csr interface
  input  wire         csr_read,
  input  wire         csr_write,
  input  wire [31:0]  csr_writedata,
  output wire [31:0]  csr_readdata,
  input  wire [15:0]  csr_address,
  output wire         csr_waitrequest,
  
  //avlon_st tx interface
  input  wire         avalon_st_tx_startofpacket,
  input  wire         avalon_st_tx_endofpacket,
  input  wire         avalon_st_tx_valid,
  input  wire [31:0]  avalon_st_tx_data,
  input  wire  [1:0]  avalon_st_tx_empty,
  input  wire         avalon_st_tx_error,
  output wire         avalon_st_tx_ready,
  
  // avalon_st rx interface
  output wire         avalon_st_rx_startofpacket,
  output wire         avalon_st_rx_endofpacket,
  output wire         avalon_st_rx_valid,
  output wire [31:0]  avalon_st_rx_data,
  output wire  [1:0]  avalon_st_rx_empty,
  input  wire         avalon_st_rx_ready,
  output wire  [5:0]  avalon_st_rx_error,
    
  // additional st interface
  input  wire  [1:0]  avalon_st_pause_data,
  output wire         avalon_st_txstatus_valid,
  output wire [39:0]  avalon_st_txstatus_data, 
  output wire  [6:0]  avalon_st_txstatus_error,
  
  output wire         avalon_st_rxstatus_valid,                                  
  output wire  [6:0]  avalon_st_rxstatus_error,                                  
  output wire [39:0]  avalon_st_rxstatus_data,
  
  output wire  [1:0]  link_fault_status_xgmii_rx_data,
  
  // reset controller
  output wire         tx_ready_export,
  output wire         rx_ready_export,
  
  output wire         tx_serial_data,
  input wire          rx_serial_data

);


wire [7:0]    xgmii_tx_control;
wire [63:0]   xgmii_tx_data;
wire [71:0]   xgmii_tx;

wire [7:0]    xgmii_rx_control;
wire [63:0]   xgmii_rx_data;
wire [71:0]   xgmii_rx;


wire          mac_csr_read;
wire          mac_csr_write;
wire  [31:0]  mac_csr_readdata;
wire  [31:0]  mac_csr_writedata;
wire          mac_csr_waitrequest;
wire  [13:0]  mac_csr_address;

wire          phy_csr_read;
wire          phy_csr_write;
wire  [31:0]  phy_csr_readdata;
wire  [31:0]  phy_csr_writedata;
wire          phy_csr_waitrequest;
wire  [9:0]   phy_csr_address;

//reset controller
wire          tx_analogreset;
wire          tx_digitalreset;  
wire          rx_analogreset;
wire          rx_digitalreset;  
wire          rx_is_lockedtodata; 
wire          fpll_locked;  
wire          atx_pll_locked; 
wire          tx_cal_busy;
wire          rx_cal_busy;

wire          tx_serial_clk;
wire          tx_clkout;
wire          rx_clkout;
wire          tx_reset_n;
wire          tx_reset;
wire          rx_reset_n;
wire          rx_reset;

assign tx_reset_n = ~tx_reset;
assign rx_reset_n = ~rx_reset;

wire [71:0] xgmii_sdr_rx_avst;
wire [71:0] xgmii_sdr_tx_avst;

altera_eth_10g_mac mac_inst (

    .csr_read                           (mac_csr_read),                   
    .csr_write                          (mac_csr_write),                  
    .csr_writedata                      (mac_csr_writedata),              
    .csr_readdata                       (mac_csr_readdata),               
    .csr_waitrequest                    (mac_csr_waitrequest),            
    .csr_address                        (mac_csr_address),                
    .csr_clk                            (csr_clk),                        
    .csr_rst_n                          (csr_rst_n),                      
    .tx_rst_n                           (tx_reset_n),                     
    .rx_rst_n                           (rx_reset_n),                     
    .avalon_st_tx_startofpacket         (avalon_st_tx_startofpacket),     
    .avalon_st_tx_endofpacket           (avalon_st_tx_endofpacket),       
    .avalon_st_tx_valid                 (avalon_st_tx_valid),             
    .avalon_st_tx_data                  (avalon_st_tx_data),              
    .avalon_st_tx_empty                 (avalon_st_tx_empty),             
    .avalon_st_tx_error                 (avalon_st_tx_error),             
    .avalon_st_tx_ready                 (avalon_st_tx_ready),             
    .avalon_st_pause_data               (avalon_st_pause_data),           
    .avalon_st_txstatus_valid           (avalon_st_txstatus_valid),       
    .avalon_st_txstatus_data            (avalon_st_txstatus_data),        
    .avalon_st_txstatus_error           (avalon_st_txstatus_error),       
    .link_fault_status_xgmii_rx_data    (link_fault_status_xgmii_rx_data),
    .avalon_st_rx_data                  (avalon_st_rx_data),              
    .avalon_st_rx_startofpacket         (avalon_st_rx_startofpacket),     
    .avalon_st_rx_valid                 (avalon_st_rx_valid),             
    .avalon_st_rx_empty                 (avalon_st_rx_empty),             
    .avalon_st_rx_error                 (avalon_st_rx_error),             
    .avalon_st_rx_ready                 (avalon_st_rx_ready),             
    .avalon_st_rx_endofpacket           (avalon_st_rx_endofpacket),       
    .avalon_st_rxstatus_valid           (avalon_st_rxstatus_valid),       
    .avalon_st_rxstatus_data            (avalon_st_rxstatus_data),        
    .avalon_st_rxstatus_error           (avalon_st_rxstatus_error),       
    .rx_156_25_clk                      (clk_156_25),                     
    .rx_312_5_clk                       (clk_312_5),                      
    .tx_156_25_clk                      (clk_156_25),                     
    .tx_312_5_clk                       (clk_312_5),                      
    .xgmii_rx                           (xgmii_rx),                       
    .xgmii_tx                           (xgmii_tx)                        
);


altera_eth_10gbaser_phy baser_inst (

    .tx_analogreset             (tx_analogreset),         
    .tx_digitalreset          (tx_digitalreset),        
    .rx_analogreset           (rx_analogreset),         
    .rx_digitalreset          (rx_digitalreset),        
    .tx_cal_busy              (tx_cal_busy),            
    .rx_cal_busy              (rx_cal_busy),            
    .tx_serial_clk0           (tx_serial_clk),         
    .rx_cdr_refclk0           (ref_clk_clk),         
    .tx_serial_data           (tx_serial_data),         
    .rx_serial_data           (rx_serial_data),         
    .rx_is_lockedtoref        (),      
    .rx_is_lockedtodata       (rx_is_lockedtodata),     
    .tx_coreclkin             (clk_156_25),           
    .rx_coreclkin             (clk_156_25),           
    .tx_clkout                (),              
    .rx_clkout                (),              
    .tx_parallel_data         (xgmii_tx_data),       
    .rx_parallel_data         (xgmii_rx_data),       
    .tx_control               (xgmii_tx_control),             
    .tx_err_ins               (1'b0),             
    .unused_tx_parallel_data  (64'b0),
    .rx_control               (xgmii_rx_control),             
    .unused_rx_parallel_data  (),
    .rx_enh_highber           (),         
    .rx_enh_blk_lock          (),        
    .rx_analogreset_stat      (rx_analogreset_stat),
    .rx_digitalreset_stat     (rx_digitalreset_stat),
    .tx_analogreset_stat      (tx_analogreset_stat),
    .tx_digitalreset_stat     (tx_digitalreset_stat),
    .reconfig_clk             (csr_clk),           
    .reconfig_reset           (~csr_rst_n),         
    .reconfig_write           (phy_csr_write),         
    .reconfig_read            (phy_csr_read),          
    .reconfig_address         (phy_csr_address),       
    .reconfig_writedata       (phy_csr_writedata),     
    .reconfig_readdata        (phy_csr_readdata),      
    .reconfig_waitrequest     (phy_csr_waitrequest)    

);


address_decode address_decoder_inst (

    .clk_csr_clk                                                  (csr_clk),                                                
    .csr_reset_n                                                  (csr_rst_n),                                                
    .merlin_master_translator_0_avalon_anti_master_0_address      (csr_address),    
    .merlin_master_translator_0_avalon_anti_master_0_waitrequest  (csr_waitrequest),
    .merlin_master_translator_0_avalon_anti_master_0_read         (csr_read),       
    .merlin_master_translator_0_avalon_anti_master_0_readdata     (csr_readdata),   
    .merlin_master_translator_0_avalon_anti_master_0_write        (csr_write),      
    .merlin_master_translator_0_avalon_anti_master_0_writedata    (csr_writedata),  
    .mac_avalon_anti_slave_0_address                              (mac_csr_address),                            
    .mac_avalon_anti_slave_0_write                                (mac_csr_write),                              
    .mac_avalon_anti_slave_0_read                                 (mac_csr_read),                               
    .mac_avalon_anti_slave_0_readdata                             (mac_csr_readdata),                           
    .mac_avalon_anti_slave_0_writedata                            (mac_csr_writedata),                          
    .mac_avalon_anti_slave_0_waitrequest                          (mac_csr_waitrequest),                        
    .phy_avalon_anti_slave_0_address                              (phy_csr_address),                            
    .phy_avalon_anti_slave_0_write                                (phy_csr_write),                              
    .phy_avalon_anti_slave_0_read                                 (phy_csr_read),                               
    .phy_avalon_anti_slave_0_readdata                             (phy_csr_readdata),                           
    .phy_avalon_anti_slave_0_writedata                            (phy_csr_writedata),                          
    .phy_avalon_anti_slave_0_waitrequest                          (phy_csr_waitrequest)

);


reset_control reset_controller_inst(

    .clock              (csr_clk),              
    .reset              (~csr_rst_n),              
    .tx_analogreset     (tx_analogreset),     
    .tx_digitalreset    (tx_digitalreset),    
    .tx_ready           (tx_ready_export),           
    .pll_locked         (atx_pll_locked),         
    .pll_select         (1'b0),         
    .tx_cal_busy        (tx_cal_busy),        
    .rx_analogreset     (rx_analogreset),     
    .rx_digitalreset    (rx_digitalreset),    
    .rx_analogreset_stat  (rx_analogreset_stat),
    .rx_digitalreset_stat (rx_digitalreset_stat),
    .tx_analogreset_stat  (tx_analogreset_stat),
    .tx_digitalreset_stat (tx_digitalreset_stat),
    .rx_ready           (rx_ready_export),           
    .rx_is_lockedtodata (rx_is_lockedtodata), 
    .rx_cal_busy        (rx_cal_busy)        

);

altera_xcvr_atx_pll_ip atx_pll_inst(

    .pll_refclk0    (ref_clk_clk),
    .tx_serial_clk  (tx_serial_clk),
    .pll_locked     (atx_pll_locked)

    );


    // Clock and reset
alt_em10g32_reset_synchronizer #(
        .DEPTH      (2),
        .ASYNC_RESET(1)
    ) tx_rst_sync (
        .clk        (clk_312_5),
        .reset_in   (~tx_rst_n),
        .reset_out  (tx_reset)
    );

    // Clock and reset
alt_em10g32_reset_synchronizer #(
        .DEPTH      (2),
        .ASYNC_RESET(1)
    ) rx_rst_sync (
        .clk        (clk_312_5),
        .reset_in   (~rx_rst_n),
        .reset_out  (rx_reset)
    );  

assign {
xgmii_sdr_rx_avst[71],
xgmii_sdr_rx_avst[62],
xgmii_sdr_rx_avst[53],
xgmii_sdr_rx_avst[44],
xgmii_sdr_rx_avst[35],
xgmii_sdr_rx_avst[26],
xgmii_sdr_rx_avst[17],
xgmii_sdr_rx_avst[8]
} = xgmii_rx_control;

assign {
xgmii_sdr_rx_avst[70:63],
xgmii_sdr_rx_avst[61:54],
xgmii_sdr_rx_avst[52:45],
xgmii_sdr_rx_avst[43:36],
xgmii_sdr_rx_avst[34:27],
xgmii_sdr_rx_avst[25:18],
xgmii_sdr_rx_avst[16:9],
xgmii_sdr_rx_avst[7:0]
} = xgmii_rx_data;


assign {
xgmii_sdr_tx_avst[71],
xgmii_sdr_tx_avst[62],
xgmii_sdr_tx_avst[53],
xgmii_sdr_tx_avst[44],
xgmii_sdr_tx_avst[35],
xgmii_sdr_tx_avst[26],
xgmii_sdr_tx_avst[17],
xgmii_sdr_tx_avst[8]
} = xgmii_tx_control;

assign {
xgmii_sdr_tx_avst[70:63],
xgmii_sdr_tx_avst[61:54],
xgmii_sdr_tx_avst[52:45],
xgmii_sdr_tx_avst[43:36],
xgmii_sdr_tx_avst[34:27],
xgmii_sdr_tx_avst[25:18],
xgmii_sdr_tx_avst[16:9],
xgmii_sdr_tx_avst[7:0]
} = xgmii_tx_data;

assign xgmii_tx_data = {
   xgmii_tx[70:63],
   xgmii_tx[61:54],
   xgmii_tx[52:45],
   xgmii_tx[43:36],
   xgmii_tx[34:27],
   xgmii_tx[25:18],
   xgmii_tx[16:9],
   xgmii_tx[7:0]
};

assign xgmii_tx_control = {
   xgmii_tx[71],
   xgmii_tx[62],
   xgmii_tx[53],
   xgmii_tx[44],
   xgmii_tx[35],
   xgmii_tx[26],
   xgmii_tx[17],
   xgmii_tx[8]
};

assign xgmii_rx = {
   xgmii_rx_control[7], xgmii_rx_data[63:56],
   xgmii_rx_control[6], xgmii_rx_data[55:48],
   xgmii_rx_control[5], xgmii_rx_data[47:40],
   xgmii_rx_control[4], xgmii_rx_data[39:32],
   xgmii_rx_control[3], xgmii_rx_data[31:24],
   xgmii_rx_control[2], xgmii_rx_data[23:16],
   xgmii_rx_control[1], xgmii_rx_data[15:8],
   xgmii_rx_control[0], xgmii_rx_data[7:0]};
  
endmodule 
