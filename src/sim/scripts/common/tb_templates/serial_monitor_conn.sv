`ifdef ENABLE_ETH_VIP
         bit spm_clk_gate = 1;
         logic [15:0] tx_serial_spm_ip0 = 0; 
         logic [15:0] rx_serial_spm_ip0 = 0; 
         logic [7:0] tx_10b_clk_ip0 = 0;
         logic [7:0] tx_16b_clk_ip0 = 0;
         logic [7:0] tx_25x4_clk_ip0 = 0;
         logic [7:0] rx_10b_clk_ip0 = 0;
         logic [7:0] rx_16b_clk_ip0 = 0;
         logic [7:0] rx_25x4_clk_ip0 = 0;
         logic tx_dl_bit;
         string str_ch,enc_str;
         bit pam4_nrz;

         //For PAM4, 1 clock will clock 2 phy data lanes.
         //Example:
         //phy_clk0 control lane0+lane1
         //phy_clk1 control lane2+lane3
         //phy_clk2 control lane4+lane5
         //nrz=['10G_1','25G_1','40G_4','50G_2','100G_4','200G_8','400G_16']
         //For NRZ, 1 clock will clock 1 phy data lanes
         initial begin
            #1fs; //to get the correct value after time 0
            
            str_ch.itoa(spy_if_ip0.ch_num);
            enc_str = {spy_if_ip0.speed.name,"_",str_ch};
            pam4_nrz =  isPAM4(enc_str);      
            
            if (spy_if_ip0.speed==_10G) begin
                  assign tx_serial_spm_ip0 = {15'h0, svt_ethernet_drv_0.Bfm.deserializer_16bit.pll_data_lane0[0]};
                  assign rx_serial_spm_ip0 = eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_16bit_tx.pll_data_lane0[0];
                  assign tx_10b_clk_ip0 = 'h0;
                  assign tx_16b_clk_ip0 = {7'h0, (svt_ethernet_drv_0.Bfm.deserializer_16bit.pll_clk_lane0 & spm_clk_gate)};
                  assign tx_25x4_clk_ip0 = 'h0;
                  assign rx_10b_clk_ip0 = 'h0;
                  assign rx_16b_clk_ip0 = eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_16bit_tx.pll_clk_lane0;
                  assign rx_25x4_clk_ip0 = 'h0;
            end
            else if (spy_if_ip0.speed==_25G) begin
                  assign tx_serial_spm_ip0 = {15'h0, svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane0[0]};
                  assign rx_serial_spm_ip0 = eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane0[0];
                  assign tx_10b_clk_ip0 = 'h0;
                  assign tx_16b_clk_ip0 = 'h0;
                  assign tx_25x4_clk_ip0 = {7'h0, (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate)};
                  assign rx_10b_clk_ip0 = 'h0;
                  assign rx_16b_clk_ip0 = 'h0;
                  assign rx_25x4_clk_ip0 = (eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane0 & spm_clk_gate);
            end
            else if (spy_if_ip0.speed==_50G) begin
                  assign tx_serial_spm_ip0 = pam4_nrz? eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane0[1:0] : {eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane1[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane0[0]};
                  assign rx_serial_spm_ip0 = pam4_nrz? eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane0[1:0] : {eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane1[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane0[0]};
                  assign tx_10b_clk_ip0 = 'h0;
                  assign tx_16b_clk_ip0 = 'h0;
                  assign tx_25x4_clk_ip0 = pam4_nrz?(svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate):{(svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane1 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate)};
                  assign rx_10b_clk_ip0 = 'h0;
                  assign rx_16b_clk_ip0 = 'h0;
                  assign rx_25x4_clk_ip0 = pam4_nrz?(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane0 & spm_clk_gate): {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane1 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane0 & spm_clk_gate)};
            end
            else if (spy_if_ip0.speed==_100G) begin
                  //assign tx_serial_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2) ? ({eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane2[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane0[1:0]}) : eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane0[1:0]): {svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane3[0], svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane2[0], svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane1[0], svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane0[0]};
                  assign tx_serial_spm_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2) ? ({eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane2[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane0[1:0]}) : eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane0[1:0]): ((spy_if_ip0.fec_type == RSFECKP || spy_if_ip0.fec_type == RSFECKR) ? ({eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane3[0], eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane2[0], eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane1[0], eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_data_lane0[0]}) : {svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane3[0], svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane2[0], svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane1[0], svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_data_lane0[0]});
                  //assign rx_serial_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2) ? ({eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane2[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane0[1:0]}) : eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane0[1:0]): {eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane3[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane2[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane1[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane0[0]};
                  assign rx_serial_spm_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2) ? ({eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane2[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane0[1:0]}) : eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane0[1:0]): ((spy_if_ip0.fec_type == RSFECKP || spy_if_ip0.fec_type == RSFECKR) ? ({eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane3[0], eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane2[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane1[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_data_lane0[0]}) : {eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane3[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane2[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane1[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_data_lane0[0]});
                  assign tx_10b_clk_ip0 = 'h0;
                  assign tx_16b_clk_ip0 = 'h0;
                  //assign tx_25x4_clk_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2)? {(svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate)}: (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate)) : {4'h0, (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane3 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane2 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane1 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate)};
                  assign tx_25x4_clk_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2)? {(svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_clk_lane0 & spm_clk_gate)}: (svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane0 & spm_clk_gate)) : ((spy_if_ip0.fec_type == RSFECKP || spy_if_ip0.fec_type == RSFECKR) ? {(svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_clk_lane3 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_clk_lane1 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_kr4.pll_clk_lane0 & spm_clk_gate)} : {4'h0, (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane3 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane2 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane1 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_25x4.pll_clk_lane0 & spm_clk_gate)});
                  assign rx_10b_clk_ip0 = 'h0;
                  assign rx_16b_clk_ip0 = 'h0;
                  //assign rx_25x4_clk_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2)? {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane2 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane0 & spm_clk_gate)}: {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane0 & spm_clk_gate)}) : {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane3 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane2 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane1 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane0 & spm_clk_gate)};
                  assign rx_25x4_clk_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==2)? {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane2 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane0 & spm_clk_gate)}: {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane0 & spm_clk_gate)}) : ((spy_if_ip0.fec_type == RSFECKP || spy_if_ip0.fec_type == RSFECKR) ? {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane3 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane2 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane1 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_kr4_tx.pll_clk_lane0 & spm_clk_gate)}: {(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane3 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane2 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane1 & spm_clk_gate),(eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_25x4_tx.pll_clk_lane0 & spm_clk_gate)});
            end
            else if (spy_if_ip0.speed==_200G) begin
                  assign tx_serial_spm_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==4) ? ({eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane6[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane4[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane2[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane0[1:0]}):{eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane2[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane0[1:0]}) 
                  : {eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane7[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane6[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane5[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane4[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane3[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane2[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane1[0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane0[0]};
                  assign rx_serial_spm_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==4)? ({eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane6[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane4[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane2[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane0[1:0]}): {eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane2[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane0[1:0]})
                  : {eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane7[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane6[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane5[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane4[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane3[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane2[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane1[0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane0[0]};
                  assign tx_10b_clk_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==4)? {(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane0 & spm_clk_gate)} : {(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane2 & spm_clk_gate), (svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane0 & spm_clk_gate)})
                  : {(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane7 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane5 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane3 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane1 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane0 & spm_clk_gate)};
                  assign tx_16b_clk_ip0 = 'h0;
                  assign tx_25x4_clk_ip0 = 'h0;
                  assign rx_10b_clk_ip0 = pam4_nrz? ((spy_if_ip0.ch_num ==4)? {(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane0 & spm_clk_gate)}:{(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane0 & spm_clk_gate)})
                  : {(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane7 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane5 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane3 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane1 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane0 & spm_clk_gate)};
                  assign rx_16b_clk_ip0 = 'h0;
                  assign rx_25x4_clk_ip0 = 'h0;
            end
            else if (spy_if_ip0.speed==_400G) begin //only has pam4
                  assign tx_serial_spm_ip0 = (spy_if_ip0.ch_num == 8) ? {eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane14[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane12[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane10[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane8[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane6[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane4[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane2[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane0[1:0]}
                  :{eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane6[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane4[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane2[1:0],eth_env_top.svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_data_lane0[1:0]};
                  assign rx_serial_spm_ip0 = (spy_if_ip0.ch_num == 8) ? {eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane14[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane12[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane10[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane8[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane6[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane4[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane2[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane0[1:0]}
                  :{eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane6[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane4[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane2[1:0],eth_env_top.svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_data_lane0[1:0]};
                  assign tx_10b_clk_ip0 = (spy_if_ip0.ch_num == 8) ? {(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane14 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane12 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane10 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane8 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane0 & spm_clk_gate)}
                  :{(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_drv_0.Bfm.deserializer_10bit.pll_clk_lane0 & spm_clk_gate)};
                  assign tx_16b_clk_ip0 = 'h0;
                  assign tx_25x4_clk_ip0 = 'h0;
                  assign rx_10b_clk_ip0 = (spy_if_ip0.ch_num == 8) ? {(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane14 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane12 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane10 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane8 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane0 & spm_clk_gate)}
                  :{(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane6 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane4 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane2 & spm_clk_gate),(svt_ethernet_mon_chk_0.Chk.deserializer_10bit_tx.pll_clk_lane0 & spm_clk_gate)};
                  assign rx_16b_clk_ip0 = 'h0;
                  assign rx_25x4_clk_ip0 = 'h0;
            end
   
            if (spy_if_ip0.trans_type == 1)
                  assign tx_dl_bit = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_barak_quad.i_gdr_ie400g_barak_ds_3__brk_pcs2srds_tx_dl_bit;
            else if (spy_if_ip0.trans_type == 0)
                  assign tx_dl_bit = `QUARTUS_TOP_LEVEL_ENTITY_INSTANCE_PATH.z1577a.z1577a_inst.u_ux_quad_3.i_gdr_ie400g_ux_ds_3__ux_tx_dl_bit;
         end

         serial_monitor ptp_serial_monitor_ip0(
            .snps_tx_10b_clk(tx_10b_clk_ip0),
            .snps_tx_16b_clk(tx_16b_clk_ip0),
            .snps_tx_25x4_clk(tx_25x4_clk_ip0),
            .snps_tx_kr4_clk('h0),
            .snps_rx_cdr_10b_clk(rx_10b_clk_ip0),
            .snps_rx_cdr_16b_clk(rx_16b_clk_ip0),
            .snps_rx_cdr_25x4_clk(rx_25x4_clk_ip0),
            .snps_rx_cdr_kr4_clk('h0),
            .snps_clk_10b_flopped((spy_if_ip0.speed == _200G || spy_if_ip0.speed == _400G) ? 'h1 : 'h0),
            .snps_clk_16b_flopped(spy_if_ip0.speed == _10G ? 'h1 : 'h0),
            .snps_clk_25x4_flopped((spy_if_ip0.speed == _25G || spy_if_ip0.speed == _50G || spy_if_ip0.speed == _100G) ? 'h1 : 'h0),
            .snps_clk_kr4_flopped('h0),
            .vip_ready_for_core(~svt_ethernet_txrx_if[0].reset),
            .vip_ready_for_lane(~svt_ethernet_txrx_if[0].reset),
            .phy_tx_p(tx_serial_spm_ip0),
            .phy_rx_p(rx_serial_spm_ip0),
            .core_serial_log_ev('h0),
            .tx_dl_bit(tx_dl_bit),
            .reset(spm_clk_gate)
          );
          
`endif
