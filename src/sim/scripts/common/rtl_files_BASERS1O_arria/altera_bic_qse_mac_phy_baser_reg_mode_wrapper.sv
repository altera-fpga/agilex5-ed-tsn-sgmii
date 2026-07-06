`timescale 1 ps / 1 ps


module altera_bic_qse_mac_phy_baser_reg_mode_wrapper (
  
  // clock and reset
  input  wire         csr_clk,
  input  wire         csr_rst_n,
  output wire         tx_xcvr_clk,
  input  wire         tx_rst_n,
  output wire         rx_xcvr_clk,
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
wire          xgmii_tx_valid;

wire [7:0]    xgmii_rx_control;
wire [63:0]   xgmii_rx_data;
wire          xgmii_rx_valid;


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
wire          pll_powerdown;
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

low_latency_mac mac_inst (

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
    .rx_xcvr_clk                        (rx_xcvr_clk),                    
    .tx_xcvr_clk                        (tx_xcvr_clk),                    
    .xgmii_tx_valid                     (xgmii_tx_valid),                 
    .xgmii_rx_valid                     (xgmii_rx_valid),                 
    .xgmii_tx_data                      (xgmii_tx_data),                  
    .xgmii_tx_control                   (xgmii_tx_control),               
    .xgmii_rx_data                      (xgmii_rx_data),                  
    .xgmii_rx_control                   (xgmii_rx_control)                
  

);

low_latency_baser baser_inst (

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
    .tx_coreclkin             (tx_xcvr_clk),           
    .rx_coreclkin             (rx_xcvr_clk),           
    .tx_clkout                (tx_xcvr_clk),              
    .rx_clkout                (rx_xcvr_clk),              
    .tx_parallel_data         (xgmii_tx_data),       
    .rx_parallel_data         (xgmii_rx_data),       
    .tx_control               (xgmii_tx_control),             
    .tx_err_ins               (1'b0),             
    .unused_tx_parallel_data  (64'b0),
    .unused_tx_control        (8'b0),      
    .rx_control               (xgmii_rx_control),             
    .unused_rx_parallel_data  (),
    .unused_rx_control        (),      
    .tx_enh_data_valid        (xgmii_tx_valid),      
    .rx_enh_data_valid        (xgmii_rx_valid),      
    .rx_enh_highber           (),         
    .rx_enh_blk_lock          (),        
    .reconfig_clk             (csr_clk),           
    .reconfig_reset           (~csr_rst_n),         
    .reconfig_write           (phy_csr_write),         
    .reconfig_read            (phy_csr_read),          
    .reconfig_address         (phy_csr_address),       
    .reconfig_writedata       (phy_csr_writedata),     
    .reconfig_readdata        (phy_csr_readdata),      
    .reconfig_waitrequest       (phy_csr_waitrequest)    

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
    .pll_powerdown      (pll_powerdown),      
    .tx_analogreset     (tx_analogreset),     
    .tx_digitalreset    (tx_digitalreset),    
    .tx_ready           (tx_ready_export),           
    .pll_locked         (atx_pll_locked),         
    .pll_select         (1'b0),         
    .tx_cal_busy        (tx_cal_busy),        
    .rx_analogreset     (rx_analogreset),     
    .rx_digitalreset    (rx_digitalreset),    
    .rx_ready           (rx_ready_export),           
    .rx_is_lockedtodata (rx_is_lockedtodata), 
    .rx_cal_busy        (rx_cal_busy)        

);

altera_xcvr_atx_pll_ip atx_pll_inst(
    .pll_powerdown  (pll_powerdown),
    .pll_refclk0    (ref_clk_clk),
    .tx_serial_clk  (tx_serial_clk),
    .pll_locked     (atx_pll_locked)
);

altera_fpll_ip fpll_inst(
    .pll_refclk0      (ref_clk_clk),      //   pll_refclk0.clk
    .pll_powerdown    (pll_powerdown),    // pll_powerdown.pll_powerdown
    .pll_locked       (fpll_locked),      //    pll_locked.pll_locked
    .outclk0          (xgmii_rx_clk_clk), //       outclk0.outclk0
    .outclk1          (clk_312_5),        //       outclk1.outclk1
    .pll_cal_busy     ()                  //  pll_cal_busy.pll_cal_busy
);

    // Clock and reset
alt_em10g32_reset_synchronizer #(
        .DEPTH      (2),
        .ASYNC_RESET(1)
    ) tx_rst_sync (
        .clk        (tx_xcvr_clk),
        .reset_in   (~tx_rst_n),
        .reset_out  (tx_reset)
    );

    // Clock and reset
alt_em10g32_reset_synchronizer #(
        .DEPTH      (2),
        .ASYNC_RESET(1)
    ) rx_rst_sync (
        .clk        (rx_xcvr_clk),
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

  
endmodule 
