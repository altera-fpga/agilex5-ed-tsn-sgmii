
   spy_interface #(.IP("ip0")) spy_if_ip0(); 
   
   bit 				    soft_reset_ip0 = 0;
   bit[31:0] REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;
   
   assign REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0 = ((avmm_if_mac_ip0.address[17:2] == `mac_reset_control_OFFSET_REG) && (avmm_if_mac_ip0.write == 1'b1)) ? avmm_if_mac_ip0.writedata : REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0;

   assign spy_if_ip0.eio_soft_rst =  0;//REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
   assign spy_if_ip0.tx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[0];
   assign spy_if_ip0.rx_soft_rst  =  REGISTERS_eth_reset_OFFSET_REG_WRITE_DATA_IP0[8];
   assign spy_if_ip0.o_rx_hi_ber = rx_hi_ber_ip0;
   assign spy_if_ip0.rx_am_lock = rx_am_lock_ip0;
   assign spy_if_ip0.rx_block_lock = rx_pcs_ready_ip0;
   assign spy_if_ip0.rx_pcs_ready = rx_pcs_ready_ip0;
   //assign spy_if_ip0.ehip_ready = ehip_ready_ip0; // RAMI-FIX port not available in GDR
   assign spy_if_ip0.soft_reset = soft_reset_ip0;
   assign spy_if_ip0.o_tx_ready = tx_ready_ip0;
   //GDR_RX/TX_MAC connections
   assign spy_if_ip0.rf_status		= remote_fault_status_ip0;
   assign spy_if_ip0.sig_avalon_st_txstatus_valid  = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_txstatus_valid;
   assign spy_if_ip0.sig_avalon_st_txstatus_error  = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_txstatus_error;
   assign spy_if_ip0.sig_avalon_st_txstatus_data   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_txstatus_data;
   assign spy_if_ip0.sig_avalon_st_tx_error        = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_tx_error;
   assign spy_if_ip0.sig_avalon_st_tx_valid        = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_tx_valid;
   assign spy_if_ip0.sig_avalon_st_tx_endofpacket  = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_tx_endofpacket;
   assign spy_if_ip0.sig_avalon_st_rx_error         = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rx_error;
   assign spy_if_ip0.sig_avalon_st_rxstatus_valid   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rxstatus_valid;
   assign spy_if_ip0.sig_avalon_st_rxstatus_error   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rxstatus_error;
   assign spy_if_ip0.sig_avalon_st_rx_valid         = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rx_valid;
   assign spy_if_ip0.sig_avalon_st_rx_endofpacket   = eth_env_top.dut.U_DUT.mac.alt_em10g32_0.avalon_st_rx_endofpacket;
   assign spy_if_ip0.clk                  = clk_ref_ip0;
   assign spy_if_ip0.avst_tx_eop		       = tx_avst_if_ip0.endofpacket;			  	
   assign spy_if_ip0.avst_tx_sop					 = tx_avst_if_ip0.startofpacket;
   
   initial begin
     `ifdef COV
       uvm_config_db #(v_if2)::set(null,"*","spy_interface",spy_if_ip0);
     `else
       uvm_config_db #(v_if2)::set(null,"*env_ip0","spy_interface",spy_if_ip0);
     `endif
       uvm_config_db#(string)::set(uvm_root::get(),"*env_ip0*","dut_name","*dut_10g_ip0");  
   end

