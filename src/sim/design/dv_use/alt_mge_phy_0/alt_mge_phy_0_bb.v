module alt_mge_phy_0 (
		input  wire        csr_clk,                 //                csr_clk.clk
		input  wire        gmii8b_tx_clkin,         //        gmii8b_tx_clkin.clk
		output wire        tx_clkout,               //              tx_clkout.clk
		output wire        rx_clkout,               //              rx_clkout.clk
		input  wire        gmii8b_tx_rst_n,         //        gmii8b_tx_rst_n.gmii8b_tx_rst_n
		input  wire        gmii8b_rx_rst_n,         //        gmii8b_rx_rst_n.gmii8b_rx_rst_n
		output wire        gmii8b_rx_clkout,        //       gmii8b_rx_clkout.clk
		output wire        gmii8b_tx_clkout,        //       gmii8b_tx_clkout.clk
		input  wire        reset,                   //                  reset.reset
		input  wire        rx_digitalreset,         //        rx_digitalreset.rx_digitalreset
		input  wire        tx_digitalreset,         //        tx_digitalreset.tx_digitalreset
		output wire [15:0] csr_readdata,            //          avalon_mm_csr.readdata
		input  wire [15:0] csr_writedata,           //                       .writedata
		input  wire [4:0]  csr_address,             //                       .address
		output wire        csr_waitrequest,         //                       .waitrequest
		input  wire        csr_read,                //                       .read
		input  wire        csr_write,               //                       .write
		input  wire        gmii8b_mac_txen,         //        gmii8b_mac_txen.export
		input  wire [7:0]  gmii8b_mac_tx_d,         //        gmii8b_mac_tx_d.export
		input  wire        gmii8b_mac_txer,         //        gmii8b_mac_txer.export
		output wire        gmii8b_mac_rxdv,         //        gmii8b_mac_rxdv.export
		output wire [7:0]  gmii8b_mac_rxd,          //         gmii8b_mac_rxd.export
		output wire        gmii8b_mac_rxer,         //        gmii8b_mac_rxer.export
		input  wire [1:0]  gmii8b_mac_speed,        //       gmii8b_mac_speed.export
		output wire        led_link,                //               led_link.export
		output wire        led_char_err,            //           led_char_err.export
		output wire        led_disp_err,            //           led_disp_err.export
		output wire        led_an,                  //                 led_an.export
		output wire [2:0]  operating_speed,         //        operating_speed.export
		output wire        mrphy_pll_lock,          //         mrphy_pll_lock.pll_locked_stable
		input  wire        i_src_ch_pause_request,  // i_src_ch_pause_request.o_src_ch_pause_request
		output wire        o_src_ch_pause_grant,    //   o_src_ch_pause_grant.i_src_ch_pause_grant
		input  wire        i_rst_n,                 //                i_rst_n.i_rst_n
		output wire        o_rst_ack_n,             //            o_rst_ack_n.o_rst_ack_n
		input  wire        i_tx_rst_n,              //             i_tx_rst_n.i_tx_rst_n
		input  wire        i_rx_rst_n,              //             i_rx_rst_n.i_rx_rst_n
		output wire        o_tx_rst_ack_n,          //         o_tx_rst_ack_n.o_tx_rst_ack_n
		output wire        o_rx_rst_ack_n,          //         o_rx_rst_ack_n.o_rx_rst_ack_n
		input  wire        rx_cdr_refclk_p,         //        rx_cdr_refclk_p.clk
		output wire        tx_ready,                //               tx_ready.tx_ready
		output wire        rx_ready,                //               rx_ready.rx_ready
		output wire        rx_pma_clkout,           //          rx_pma_clkout.clk
		input  wire [1:0]  xcvr_mode,               //              xcvr_mode.export
		input  wire [0:0]  tx_pll_refclk_p,         //        tx_pll_refclk_p.clk,                   The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire [0:0]  i_pma_cu_clk,            //           i_pma_cu_clk.clk,                   The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire [0:0]  i_system_pll_clk,        //       i_system_pll_clk.clk,                   The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire [0:0]  i_system_pll_lock,       //      i_system_pll_lock.system_pll_lock,       The connection made from "Reference and SystemPLL Clocks IP" to this pin will guide Quartus on properly setting clock network.
		input  wire [0:0]  i_src_rs_grant,          //         i_src_rs_grant.src_rs_grant,          Grant Signal
		output wire [0:0]  o_src_rs_req,            //           o_src_rs_req.src_rs_req,            Request Signal
		output wire [0:0]  tx_serial_data,          //         tx_serial_data.o_tx_serial_data,      TX serial data port.
		output wire [0:0]  tx_serial_data_n,        //       tx_serial_data_n.o_tx_serial_data_n,    Differential pair for TX serial data port. Historically was hidden; however now used in pam4 signal simulation model, hence needs to be connected by user.
		input  wire [0:0]  rx_serial_data,          //         rx_serial_data.i_rx_serial_data,      RX serial data port.
		input  wire [0:0]  rx_serial_data_n,        //       rx_serial_data_n.i_rx_serial_data_n,    Differential pair for RX serial data port. Historically was hidden; however now used in pam4 signal simulation model, hence needs to be connected by user.
		output wire [0:0]  rx_is_lockedtodata,      //     rx_is_lockedtodata.o_rx_is_lockedtodata,  RX CDR data lock status signal. 1`b0: CDR is not locked to data. 1`b1: CDR is locked to data.
		input  wire [0:0]  reconfig_clk,            //           reconfig_clk.clk,                   Reconfiguration interface clock.
		input  wire [0:0]  reconfig_reset,          //         reconfig_reset.reset,                 Reconfiguration reset.
		input  wire [0:0]  reconfig_write,          //               reconfig.write,                 Reconfiguration write.
		input  wire [0:0]  reconfig_read,           //                       .read,                  Reconfiguration read.
		input  wire [17:0] reconfig_address,        //                       .address,               Reconfiguration word address.
		input  wire [3:0]  reconfig_be,             //                       .byteenable,            Reconfiguration byte enable. If byteenable[3:0] is 4`b1111, 32-bit Dword Access is assumed; otherwise byte access will be used.
		input  wire [31:0] reconfig_writedata,      //                       .writedata,             Reconfiguration write data.
		output wire [31:0] reconfig_readdata,       //                       .readdata,              Reconfiguration read data.
		output wire [0:0]  reconfig_waitrequest,    //                       .waitrequest,           Reconfiguration wait request.
		output wire [0:0]  reconfig_readdata_valid  //                       .readdatavalid,         Reconfiguration read data valid. Optional port, available if the port is enabled in parameter editor.
	);
endmodule

