	component alt_mge_phy_0 is
		port (
			csr_clk                 : in  std_logic                     := 'X';             -- clk
			gmii8b_tx_clkin         : in  std_logic                     := 'X';             -- clk
			tx_clkout               : out std_logic;                                        -- clk
			rx_clkout               : out std_logic;                                        -- clk
			gmii8b_tx_rst_n         : in  std_logic                     := 'X';             -- gmii8b_tx_rst_n
			gmii8b_rx_rst_n         : in  std_logic                     := 'X';             -- gmii8b_rx_rst_n
			gmii8b_rx_clkout        : out std_logic;                                        -- clk
			gmii8b_tx_clkout        : out std_logic;                                        -- clk
			reset                   : in  std_logic                     := 'X';             -- reset
			rx_digitalreset         : in  std_logic                     := 'X';             -- rx_digitalreset
			tx_digitalreset         : in  std_logic                     := 'X';             -- tx_digitalreset
			csr_readdata            : out std_logic_vector(15 downto 0);                    -- readdata
			csr_writedata           : in  std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			csr_address             : in  std_logic_vector(4 downto 0)  := (others => 'X'); -- address
			csr_waitrequest         : out std_logic;                                        -- waitrequest
			csr_read                : in  std_logic                     := 'X';             -- read
			csr_write               : in  std_logic                     := 'X';             -- write
			gmii8b_mac_txen         : in  std_logic                     := 'X';             -- export
			gmii8b_mac_tx_d         : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			gmii8b_mac_txer         : in  std_logic                     := 'X';             -- export
			gmii8b_mac_rxdv         : out std_logic;                                        -- export
			gmii8b_mac_rxd          : out std_logic_vector(7 downto 0);                     -- export
			gmii8b_mac_rxer         : out std_logic;                                        -- export
			gmii8b_mac_speed        : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			led_link                : out std_logic;                                        -- export
			led_char_err            : out std_logic;                                        -- export
			led_disp_err            : out std_logic;                                        -- export
			led_an                  : out std_logic;                                        -- export
			operating_speed         : out std_logic_vector(2 downto 0);                     -- export
			mrphy_pll_lock          : out std_logic;                                        -- pll_locked_stable
			i_src_ch_pause_request  : in  std_logic                     := 'X';             -- o_src_ch_pause_request
			o_src_ch_pause_grant    : out std_logic;                                        -- i_src_ch_pause_grant
			i_rst_n                 : in  std_logic                     := 'X';             -- i_rst_n
			o_rst_ack_n             : out std_logic;                                        -- o_rst_ack_n
			i_tx_rst_n              : in  std_logic                     := 'X';             -- i_tx_rst_n
			i_rx_rst_n              : in  std_logic                     := 'X';             -- i_rx_rst_n
			o_tx_rst_ack_n          : out std_logic;                                        -- o_tx_rst_ack_n
			o_rx_rst_ack_n          : out std_logic;                                        -- o_rx_rst_ack_n
			rx_cdr_refclk_p         : in  std_logic                     := 'X';             -- clk
			tx_ready                : out std_logic;                                        -- tx_ready
			rx_ready                : out std_logic;                                        -- rx_ready
			rx_pma_clkout           : out std_logic;                                        -- clk
			xcvr_mode               : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			tx_pll_refclk_p         : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			i_pma_cu_clk            : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			i_system_pll_clk        : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			i_system_pll_lock       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- system_pll_lock
			i_src_rs_grant          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- src_rs_grant
			o_src_rs_req            : out std_logic_vector(0 downto 0);                     -- src_rs_req
			tx_serial_data          : out std_logic_vector(0 downto 0);                     -- o_tx_serial_data
			tx_serial_data_n        : out std_logic_vector(0 downto 0);                     -- o_tx_serial_data_n
			rx_serial_data          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- i_rx_serial_data
			rx_serial_data_n        : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- i_rx_serial_data_n
			rx_is_lockedtodata      : out std_logic_vector(0 downto 0);                     -- o_rx_is_lockedtodata
			reconfig_clk            : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			reconfig_reset          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- reset
			reconfig_write          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- write
			reconfig_read           : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- read
			reconfig_address        : in  std_logic_vector(17 downto 0) := (others => 'X'); -- address
			reconfig_be             : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			reconfig_writedata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			reconfig_readdata       : out std_logic_vector(31 downto 0);                    -- readdata
			reconfig_waitrequest    : out std_logic_vector(0 downto 0);                     -- waitrequest
			reconfig_readdata_valid : out std_logic_vector(0 downto 0)                      -- readdatavalid
		);
	end component alt_mge_phy_0;

	u0 : component alt_mge_phy_0
		port map (
			csr_clk                 => CONNECTED_TO_csr_clk,                 --                csr_clk.clk
			gmii8b_tx_clkin         => CONNECTED_TO_gmii8b_tx_clkin,         --        gmii8b_tx_clkin.clk
			tx_clkout               => CONNECTED_TO_tx_clkout,               --              tx_clkout.clk
			rx_clkout               => CONNECTED_TO_rx_clkout,               --              rx_clkout.clk
			gmii8b_tx_rst_n         => CONNECTED_TO_gmii8b_tx_rst_n,         --        gmii8b_tx_rst_n.gmii8b_tx_rst_n
			gmii8b_rx_rst_n         => CONNECTED_TO_gmii8b_rx_rst_n,         --        gmii8b_rx_rst_n.gmii8b_rx_rst_n
			gmii8b_rx_clkout        => CONNECTED_TO_gmii8b_rx_clkout,        --       gmii8b_rx_clkout.clk
			gmii8b_tx_clkout        => CONNECTED_TO_gmii8b_tx_clkout,        --       gmii8b_tx_clkout.clk
			reset                   => CONNECTED_TO_reset,                   --                  reset.reset
			rx_digitalreset         => CONNECTED_TO_rx_digitalreset,         --        rx_digitalreset.rx_digitalreset
			tx_digitalreset         => CONNECTED_TO_tx_digitalreset,         --        tx_digitalreset.tx_digitalreset
			csr_readdata            => CONNECTED_TO_csr_readdata,            --          avalon_mm_csr.readdata
			csr_writedata           => CONNECTED_TO_csr_writedata,           --                       .writedata
			csr_address             => CONNECTED_TO_csr_address,             --                       .address
			csr_waitrequest         => CONNECTED_TO_csr_waitrequest,         --                       .waitrequest
			csr_read                => CONNECTED_TO_csr_read,                --                       .read
			csr_write               => CONNECTED_TO_csr_write,               --                       .write
			gmii8b_mac_txen         => CONNECTED_TO_gmii8b_mac_txen,         --        gmii8b_mac_txen.export
			gmii8b_mac_tx_d         => CONNECTED_TO_gmii8b_mac_tx_d,         --        gmii8b_mac_tx_d.export
			gmii8b_mac_txer         => CONNECTED_TO_gmii8b_mac_txer,         --        gmii8b_mac_txer.export
			gmii8b_mac_rxdv         => CONNECTED_TO_gmii8b_mac_rxdv,         --        gmii8b_mac_rxdv.export
			gmii8b_mac_rxd          => CONNECTED_TO_gmii8b_mac_rxd,          --         gmii8b_mac_rxd.export
			gmii8b_mac_rxer         => CONNECTED_TO_gmii8b_mac_rxer,         --        gmii8b_mac_rxer.export
			gmii8b_mac_speed        => CONNECTED_TO_gmii8b_mac_speed,        --       gmii8b_mac_speed.export
			led_link                => CONNECTED_TO_led_link,                --               led_link.export
			led_char_err            => CONNECTED_TO_led_char_err,            --           led_char_err.export
			led_disp_err            => CONNECTED_TO_led_disp_err,            --           led_disp_err.export
			led_an                  => CONNECTED_TO_led_an,                  --                 led_an.export
			operating_speed         => CONNECTED_TO_operating_speed,         --        operating_speed.export
			mrphy_pll_lock          => CONNECTED_TO_mrphy_pll_lock,          --         mrphy_pll_lock.pll_locked_stable
			i_src_ch_pause_request  => CONNECTED_TO_i_src_ch_pause_request,  -- i_src_ch_pause_request.o_src_ch_pause_request
			o_src_ch_pause_grant    => CONNECTED_TO_o_src_ch_pause_grant,    --   o_src_ch_pause_grant.i_src_ch_pause_grant
			i_rst_n                 => CONNECTED_TO_i_rst_n,                 --                i_rst_n.i_rst_n
			o_rst_ack_n             => CONNECTED_TO_o_rst_ack_n,             --            o_rst_ack_n.o_rst_ack_n
			i_tx_rst_n              => CONNECTED_TO_i_tx_rst_n,              --             i_tx_rst_n.i_tx_rst_n
			i_rx_rst_n              => CONNECTED_TO_i_rx_rst_n,              --             i_rx_rst_n.i_rx_rst_n
			o_tx_rst_ack_n          => CONNECTED_TO_o_tx_rst_ack_n,          --         o_tx_rst_ack_n.o_tx_rst_ack_n
			o_rx_rst_ack_n          => CONNECTED_TO_o_rx_rst_ack_n,          --         o_rx_rst_ack_n.o_rx_rst_ack_n
			rx_cdr_refclk_p         => CONNECTED_TO_rx_cdr_refclk_p,         --        rx_cdr_refclk_p.clk
			tx_ready                => CONNECTED_TO_tx_ready,                --               tx_ready.tx_ready
			rx_ready                => CONNECTED_TO_rx_ready,                --               rx_ready.rx_ready
			rx_pma_clkout           => CONNECTED_TO_rx_pma_clkout,           --          rx_pma_clkout.clk
			xcvr_mode               => CONNECTED_TO_xcvr_mode,               --              xcvr_mode.export
			tx_pll_refclk_p         => CONNECTED_TO_tx_pll_refclk_p,         --        tx_pll_refclk_p.clk
			i_pma_cu_clk            => CONNECTED_TO_i_pma_cu_clk,            --           i_pma_cu_clk.clk
			i_system_pll_clk        => CONNECTED_TO_i_system_pll_clk,        --       i_system_pll_clk.clk
			i_system_pll_lock       => CONNECTED_TO_i_system_pll_lock,       --      i_system_pll_lock.system_pll_lock
			i_src_rs_grant          => CONNECTED_TO_i_src_rs_grant,          --         i_src_rs_grant.src_rs_grant
			o_src_rs_req            => CONNECTED_TO_o_src_rs_req,            --           o_src_rs_req.src_rs_req
			tx_serial_data          => CONNECTED_TO_tx_serial_data,          --         tx_serial_data.o_tx_serial_data
			tx_serial_data_n        => CONNECTED_TO_tx_serial_data_n,        --       tx_serial_data_n.o_tx_serial_data_n
			rx_serial_data          => CONNECTED_TO_rx_serial_data,          --         rx_serial_data.i_rx_serial_data
			rx_serial_data_n        => CONNECTED_TO_rx_serial_data_n,        --       rx_serial_data_n.i_rx_serial_data_n
			rx_is_lockedtodata      => CONNECTED_TO_rx_is_lockedtodata,      --     rx_is_lockedtodata.o_rx_is_lockedtodata
			reconfig_clk            => CONNECTED_TO_reconfig_clk,            --           reconfig_clk.clk
			reconfig_reset          => CONNECTED_TO_reconfig_reset,          --         reconfig_reset.reset
			reconfig_write          => CONNECTED_TO_reconfig_write,          --               reconfig.write
			reconfig_read           => CONNECTED_TO_reconfig_read,           --                       .read
			reconfig_address        => CONNECTED_TO_reconfig_address,        --                       .address
			reconfig_be             => CONNECTED_TO_reconfig_be,             --                       .byteenable
			reconfig_writedata      => CONNECTED_TO_reconfig_writedata,      --                       .writedata
			reconfig_readdata       => CONNECTED_TO_reconfig_readdata,       --                       .readdata
			reconfig_waitrequest    => CONNECTED_TO_reconfig_waitrequest,    --                       .waitrequest
			reconfig_readdata_valid => CONNECTED_TO_reconfig_readdata_valid  --                       .readdatavalid
		);

