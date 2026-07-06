`timescale 1ps/1fs

`define ETH_FEC_SCRAMBLER_2112 2112'hFDFA_A880_AA85_4AAF_D7FF_DAD5_5A08_00B4_FFE0_2AAA_8755_7DD5_57B0_0057_D555_8FFF_5DFF_FE4A_AAAA_AA82_2AAF_D7FF_5055_4A80_02A5_FF80_AAA2_B554_FFD5_7FD0_0757_55D5_1FE5_57FD_7F2A_DAA2_A201_AB1F_FFD5_5752_2A80_82AF_E500_282A_A525_FF5D_FFE1_B555_7FD5_7885_577D_FFB0_4AA8_2800_DA7F_F75D_54E1_AAAA_AAA8_8200_282A_AFAF_FFD5_7FF0_A555_FF55_4AB5_557F_FFD0_2AA8_A800_4AFF_FD55_5580_AAA2_AAAB_0000_002A_A8AF_FFD5_FFFA_B555_7D55_5AD5_55F7_FFE1_AAAA_8000_2DFF_FDD5_551A_AAA8_2AAA_7000_08AA_AB1F_FFFF_FFFD_D555_7D55_5055_557F_FFF0_AAAA_0000_1FFF_FFD5_557A_AAA8_AAAA_E000_02AA_AA7F_FFF7_FFFE_5555_5555_5755_557F_FFFA_AAAA_8000_0FFF_FF55_554A_AAAA_AAAA_8000_02AA_AAFF_FFFF_FFFF

module serial_monitor(
  input logic [7:0] snps_tx_10b_clk, //should be 16bits, each clock bit clock each lane data
  input logic [7:0] snps_tx_16b_clk, //should be 16bits, each clock bit clock each lane data
  input logic [7:0] snps_tx_25x4_clk,//should be 16bits, each clock bit clock each lane data
  input logic [7:0] snps_tx_kr4_clk, //should be 16bits, each clock bit clock each lane data

  input logic [7:0] snps_rx_cdr_10b_clk,
  input logic [7:0] snps_rx_cdr_16b_clk,
  input logic [7:0] snps_rx_cdr_25x4_clk,
  input logic [7:0] snps_rx_cdr_kr4_clk,
  
  input logic       snps_clk_10b_flopped,
  input logic       snps_clk_16b_flopped,
  input logic       snps_clk_25x4_flopped,
  input logic       snps_clk_kr4_flopped,

  input logic       vip_ready_for_core,
  input logic [5:0] vip_ready_for_lane,

  input logic [15:0] phy_tx_p,
  input logic [15:0] phy_rx_p,

  input bit	    tx_dl_bit,
  input logic       reset,
  input logic       core_serial_log_ev
  );

  //---------------------------------------------------------------------------
  // Import and include common packages and files
  //---------------------------------------------------------------------------
  //   `EHIP_COMMON_PACKAGE_INCLUDES
  //   import ehip_env_pkg::*;

  //Serial Line Logger File pointers.
  integer fp_rx_ch0;
  integer fp_rx_ch1;
  integer fp_rx_ch2;
  integer fp_rx_ch3;
  integer fp_tx_ch0;
  integer fp_tx_ch1;
  integer fp_tx_ch2;
  integer fp_tx_ch3;

  integer fp_trans_rx_ch0;
  integer fp_trans_rx_ch1;
  integer fp_trans_rx_ch2;
  integer fp_trans_rx_ch3;
  integer fp_trans_tx_ch0;
  integer fp_trans_tx_ch1;
  integer fp_trans_tx_ch2;
  integer fp_trans_tx_ch3;

  integer core_fp_tx[20];
  integer core_fp_rx[20];

  integer core_fp_trans_tx[20];
  integer core_fp_trans_rx[20];

  bit [2719:0] core_fec_phy_word_tx[][$];
  bit [2719:0] core_fec_phy_word_rx[][$];

  int n_symbols;
  int generator_polynomial[];
  int polynomial = 1033;
  int k_symbols = 514;
  bit[9:0] rsfec_codeword[560];
  int check_symbols; 

  int open_cnt = 0; // to indicate the the file already open  
  //debug
  bit [7:0][19:0][2719:0] tx_phy_word, rx_phy_word; //phy_num, vl_num
  bit [1:0][3:0][63:0] tx_decodeData,rx_decodeData;
  initial begin
      $vcdplusmemon(tx_phy_word);
      $vcdplusmemon(rx_phy_word);
      $vcdplusmemon(tx_decodeData);
      $vcdplusmemon(rx_decodeData);      
  end

  //------------------------------------------------------------------------------
  // Initial Block for timeformat.
  //------------------------------------------------------------------------------
  initial 
  begin
    #1fs; //workaround for printing timescale correctly. Override the ctf_hssi timeformat
    $timeformat(-9, 3, " ns", 15);
  end

  //------------------------------------------------------------------------------
  // Initial Block for Serial Line monitors.
  // All the Full duplex monitors are in ehip_rtb and Loopback monitors in cr3top_tb.
  //
  // Appropriate monitors are called based on runtime arguments.
  //------------------------------------------------------------------------------
  initial
  begin

    if($test$plusargs("MAC_NO_FEC")) begin
      for(int a = 0; a < 1; a++)
      begin  
      	@(posedge tx_dl_bit);
	$display("TX_DL_BIT :at time %t seen no.=%d  TX_DL_BIT = %d",$time,a,tx_dl_bit);
      end
    end

    //enable spm operations
    if($test$plusargs("SPM_ENABLE"))
    begin
         forever
         begin
            open_cnt++;
            fork
            begin
              `uvm_info("DEBUG:initial block", "Entered ...",UVM_LOW)
          
              //Initialize Variables for KR/KP/LL FEC if applicable
              if($test$plusargs("ETH_KR_FEC"))
              begin
              `uvm_info("DEBUG:ETH_KR_FEC block", "Entered ...",UVM_LOW)
          
                k_symbols = 514;
                n_symbols = 528;
                generator_polynomial = new[14]('{904,6,701,32,656,925,900,614,391,592,265,945,290,432});
              end
              else if($test$plusargs("ETH_KP_FEC"))
              begin
                k_symbols = 514;
                n_symbols = 544; 
                generator_polynomial = new[30]('{575,552,187,230,552,1,108,565,282,249,593,132,94,720,495,385,942,503,883,361,788,610,193,392,127,185,158,128,834,523});
              end
              else if($test$plusargs("ETH_LL_FEC"))
              begin
                n_symbols = 272;
                k_symbols = 258;
                generator_polynomial = new[14]('{904,6,701,32,656,925,900,614,391,592,265,945,290,432});
              end
          
              check_symbols = n_symbols - k_symbols;
          
              // Check for CORE monitors args
              // For Core there will be total 40 logs, 20-TX 20-RX, one for each virual lane.
              if($test$plusargs("core_serial_log"))
              begin
                // DA_TO:
                if($test$plusargs("core_fec_mode"))
                begin
    	          //look for 2nd async_pulse, then call tasks
        	  for(int b = 1; b < 4; b++)
          	  begin
	             @(posedge tx_dl_bit);
        	     $display("TX_DL_BIT: at time %t seen no. =%d TX_DL_BIT = %d",$time,b,tx_dl_bit);
          	  end
          
                  fork
                    //Core FEC RX
                    core_fec_serial_mon(.tx1_rx0(0));
          
                    //Core FEC TX
                    core_fec_serial_mon(.tx1_rx0(1));
                  join
                end
                else // NO FEC
                begin 
                  //For Core intial all 8 file pointer(4TX-4RX)
                  if($test$plusargs("ETH_50G"))
                  begin
                    for (int i = 0; i < 4; i++)
                    begin
                      if(open_cnt == 1)begin
                        core_fp_tx[i] =  $fopen($sformatf("ptp_serial_monitor.tx_channel%0d.out",i), "w");
                        core_fp_rx[i] =  $fopen($sformatf("ptp_serial_monitor.rx_channel%0d.out",i), "w");
                      end
                    end //for (int i = 0; i < 4; i++)
                  end //if($test$plusargs("ETH_50G"))
                  else
                  begin
                    for (int i = 0; i < 20; i++)
                    begin
                      if(open_cnt == 1)begin
                  core_fp_tx[i] =  $fopen($sformatf("ptp_serial_monitor.tx_channel%0d.out",i), "w");
                  core_fp_rx[i] =  $fopen($sformatf("ptp_serial_monitor.rx_channel%0d.out",i), "w");
                      end
                    end //for (int i = 0; i < 20; i++)
                  end // else
                  if(open_cnt == 1)begin
                    // Pointers of Phy-lanes used only for Non-FEC  
                    fp_tx_ch0 = $fopen($sformatf("%m.phy_tx_channel0.out"), "w");
                    fp_tx_ch1 = $fopen($sformatf("%m.phy_tx_channel1.out"), "w");
                    fp_tx_ch2 = $fopen($sformatf("%m.phy_tx_channel2.out"), "w");
                    fp_tx_ch3 = $fopen($sformatf("%m.phy_tx_channel3.out"), "w");
                    fp_rx_ch0 = $fopen($sformatf("%m.phy_rx_channel0.out"), "w");
                    fp_rx_ch1 = $fopen($sformatf("%m.phy_rx_channel1.out"), "w");
                    fp_rx_ch2 = $fopen($sformatf("%m.phy_rx_channel2.out"), "w");
                    fp_rx_ch3 = $fopen($sformatf("%m.phy_rx_channel3.out"), "w");
                  end
                  if($test$plusargs("ETH_50G"))
                  begin
                    fork
                      //Core No-FEC RX
                      core_serial_mon_50G(.tx1_rx0(0)); //RX done
                      //Core No-FEC TX
                      core_serial_mon_50G(.tx1_rx0(1));
                    join
                  end // if($test$plusargs("ETH_50G"))
                  else
                  begin
                    fork
                      //Core No-FEC RX
                      core_serial_mon(.tx1_rx0(0));
                      //Core No-FEC TX
                      core_serial_mon(.tx1_rx0(1));
                    join
                  end 
                end // core no fec
              end // if($test$plusargs("core_serial_log"))
              // ELANE Monitors
              else if($test$plusargs("elane_fec_mode"))
              begin
                // Individual monitor for each Elane and in each direction
                // look for 2nd async_pulse, then call tasks
                //for(int a = 1; a < 4; a++)
                //begin  
                //	@(posedge tx_dl_bit);
          	//        $display("TX_DL_BIT :at time %t seen no.=%d  TX_DL_BIT = %d",$time,a,tx_dl_bit);
                //end
          
                fork
                  //ELANE FEC RX
                  fec_serial_am_log(.tx1_rx0(0), .ch_num(0));
                  fec_serial_am_log(.tx1_rx0(0), .ch_num(1));
                  fec_serial_am_log(.tx1_rx0(0), .ch_num(2));
                  fec_serial_am_log(.tx1_rx0(0), .ch_num(3));
                  fec_decoder_serial_log(.tx1_rx0(0), .ch_num(0));
                  fec_decoder_serial_log(.tx1_rx0(0), .ch_num(1));
                  fec_decoder_serial_log(.tx1_rx0(0), .ch_num(2));
                  fec_decoder_serial_log(.tx1_rx0(0), .ch_num(3));
                  //ELANE FEC TX
                  fec_serial_am_log(.tx1_rx0(1), .ch_num(0));
                  fec_serial_am_log(.tx1_rx0(1), .ch_num(1));
                  fec_serial_am_log(.tx1_rx0(1), .ch_num(2));
                  fec_serial_am_log(.tx1_rx0(1), .ch_num(3));
                  fec_decoder_serial_log(.tx1_rx0(1), .ch_num(0));
                  fec_decoder_serial_log(.tx1_rx0(1), .ch_num(1));
                  fec_decoder_serial_log(.tx1_rx0(1), .ch_num(2));
                  fec_decoder_serial_log(.tx1_rx0(1), .ch_num(3));
                join
              end // else if($test$plusargs("elane_fec_mode"))
              else if($test$plusargs("elane_firefec_mode"))
              begin
                // Individual monitor for each Elane and in each direction
                fork
                  //RX
                  firefec_serial_log(.tx1_rx0(0), .ch_num(0));
                  firefec_serial_log(.tx1_rx0(0), .ch_num(1));
                  firefec_serial_log(.tx1_rx0(0), .ch_num(2));
                  firefec_serial_log(.tx1_rx0(0), .ch_num(3));
          
                  //TX
                  firefec_serial_log(.tx1_rx0(1), .ch_num(0));
                  firefec_serial_log(.tx1_rx0(1), .ch_num(1));
                  firefec_serial_log(.tx1_rx0(1), .ch_num(2));
                  firefec_serial_log(.tx1_rx0(1), .ch_num(3));
                join
              end // else if($test$plusargs("elane_firefec_mode"))
              else // ELANE No-FEC for 25G, 10G@10LR and 10G@25LR
              begin
                fork
                  //RX
                  serial_line_log(.tx1_rx0(0), .ch_num(0));
                  serial_line_log(.tx1_rx0(0), .ch_num(1));
                  serial_line_log(.tx1_rx0(0), .ch_num(2));
                  serial_line_log(.tx1_rx0(0), .ch_num(3));
          
                  //TX
                  serial_line_log(.tx1_rx0(1), .ch_num(0));
                  serial_line_log(.tx1_rx0(1), .ch_num(1));
                  serial_line_log(.tx1_rx0(1), .ch_num(2));
                  serial_line_log(.tx1_rx0(1), .ch_num(3));
                join
              end // else ELANE No-FEC
            end
            begin
               //reset
               @(negedge reset);
               `uvm_info("Initial block",$sformatf("Reset entered"), UVM_LOW)
               
               //init_mon();
               //`uvm_info("Initial block",$sformatf("Initialised monitor"), UVM_LOW)
            
            end
            join_any
            disable fork;         
         end //end - forever  
    end //spm_enable
  end // initial 

//------------------------------------------------------------------------------
// Task: serial_line_log
// ELANE NOFEC Serial Monitor for 25G@25LR and 10G
// 
//
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - ch_num   : Elane Channel number.
//------------------------------------------------------------------------------
  task automatic serial_line_log(bit tx1_rx0, bit [1:0] ch_num);

    bit [6:0] cnt;
    bit [65:0] word_66b;
    bit [65:0] word_66b_1;
    bit [65:0] word_66b_2;
    time t;
    string stng;

      // Wait for VIP reset to deassert.
      wait(vip_ready_for_lane[ch_num] === 1'b1);
       
      // Open file pointer and Wait for posedge on serial line.
      // In NOFEC mode this posedge will be Bit 0 of Control SH.
      // 
      // In TX direction due to XCVRIF Gearbox reset on first AM the monitor will no longer be
      // Aligned to SHs, but the post-process script finds the SH.
      //
      // In RX direction the monitors remain aligned to SH during whole simulation.
      if (tx1_rx0)
      begin
        if(open_cnt == 1)begin 
          case(ch_num)
            0: fp_tx_ch0 = $fopen($sformatf("%m.tx_channel0.out"), "w");
            1: fp_tx_ch1 = $fopen($sformatf("%m.tx_channel1.out"), "w");
            2: fp_tx_ch2 = $fopen($sformatf("%m.tx_channel2.out"), "w");
            3: fp_tx_ch3 = $fopen($sformatf("%m.tx_channel3.out"), "w");
          endcase
        end
        wait(phy_tx_p[ch_num] === 1'b1);
      end
      else
      begin
        if(open_cnt == 1)begin
          case(ch_num)
            0: fp_rx_ch0 = $fopen($sformatf("%m.rx_channel0.out"), "w");
            1: fp_rx_ch1 = $fopen($sformatf("%m.rx_channel1.out"), "w");
            2: fp_rx_ch2 = $fopen($sformatf("%m.rx_channel2.out"), "w");
            3: fp_rx_ch3 = $fopen($sformatf("%m.rx_channel3.out"), "w");
          endcase
        end	
        wait(phy_rx_p[ch_num] === 1'b1);
	
      end

      // In CR3TOP SS, the Serdes Model injects jitter so we use VIP CDR for serial line clk.
      // At EHIP IP level CDR is not needed, so appropriate clocks are used for sampling.
      //
      // We are sampling at negedge on serial as VIP drives at posedge.
      forever
      begin
        //sample data on negedge
        get_serial_clock(.tx1_rx0(tx1_rx0),
                         .clk_10b(snps_clk_10b_flopped), 
                         .clk_16b(snps_clk_16b_flopped), 
                         .clk_25X4(snps_clk_25x4_flopped), 
                         .clk_kr4(snps_clk_kr4_flopped), 
                         .lane_num(ch_num));

        // Sample and collect 66bit PCS word at a time.
        // Post processing script will find SOP based on SH transitions
        word_66b[cnt] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];

        // Check if 66 bit has been sample.
        // If 66bit, send data to file and reset counter.
        // Else increment counter. If counter is bit 0 of 66bit, sample time stamp.
        if (cnt == 65)
        begin
          stng = $sformatf("\n%t | 66'h%17h | 64'h%16h | 2'b%2b",t, word_66b, word_66b[65:2], word_66b[1:0]);
          case(ch_num)
            0:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch0,"%s",stng);
              else
                $fwrite(fp_rx_ch0,"%s",stng);
            end
            1:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch1,"%s",stng);
              else
                $fwrite(fp_rx_ch1,"%s",stng);
            end
            2:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch2,"%s",stng);
              else
                $fwrite(fp_rx_ch2,"%s",stng);
            end
            3:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch3,"%s",stng);
              else
                $fwrite(fp_rx_ch3,"%s",stng);
            end
          endcase
          cnt = 0;
        end
        else
        begin
          if (cnt == 0) t = $time;
          cnt++;
        end
      end
  endtask : serial_line_log

//------------------------------------------------------------------------------
// Task: fec_serial_am_log
// ELANE FEC Serial AM Monitor. It prints only AM timestamps seen at serial line.
// This monitor has been depricated by fec_decoder_serial_log.
//
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - ch_num   : Elane Channel number.
//------------------------------------------------------------------------------
  task automatic fec_serial_am_log(bit tx1_rx0, bit [1:0] ch_num);

    bit  [127:0] cnt;
    bit  [127:0] word_128b;
    time t_stamp[$:127];
    string stng;

      // Initialize Timestamp Queue. We collect timestamp for each bit we sample.
      repeat(128) t_stamp.push_back(0);

      // Wait for VIP reset to deassert.
      wait(vip_ready_for_lane[ch_num] === 1'b1);

      //Open file pointer and Wait for posedge on serial line.
      if (tx1_rx0)
      begin
        if(open_cnt == 1)begin
          case(ch_num)
            0: fp_tx_ch0 = $fopen($sformatf("%m.tx_channel0.out"), "w");
            1: fp_tx_ch1 = $fopen($sformatf("%m.tx_channel1.out"), "w");
            2: fp_tx_ch2 = $fopen($sformatf("%m.tx_channel2.out"), "w");
            3: fp_tx_ch3 = $fopen($sformatf("%m.tx_channel3.out"), "w");
          endcase
        end
        wait(phy_tx_p[ch_num] === 1'b1);
      end
      else
      begin
        if(open_cnt == 1)begin
          case(ch_num)
            0: fp_rx_ch0 = $fopen($sformatf("%m.rx_channel0.out"), "w");
            1: fp_rx_ch1 = $fopen($sformatf("%m.rx_channel1.out"), "w");
            2: fp_rx_ch2 = $fopen($sformatf("%m.rx_channel2.out"), "w");
            3: fp_rx_ch3 = $fopen($sformatf("%m.rx_channel3.out"), "w");
          endcase
        end
        wait(phy_rx_p[ch_num] === 1'b1);
      end

      // In this monitor we dont check for AM distance or invalid AMs.
      // We simply shift data register pop a timestamp from queue, sample bit and put it in register and
      // push timestamp in queue.
      //
      // We check for AM pattern at every clock. Using AM distance will be more efficient but this is much simple.
      // Also on TX side, the AM dist between AM0 and AM1 is always shorter than the expected AM_DIST. From AM1 
      // The RSFEC core send out AMs at correct distance.
      //
      // In CR3TOP SS, the Serdes Model injects jitter so we use VIP CDR for serial line clk.
      // At EHIP IP level CDR is not needed, so appropriate clocks are used for sampling.
      //
      // We are sampling at negedge on serial as VIP drives at posedge.

      forever
      begin
        //sample data on negedge
        get_serial_clock(.tx1_rx0(tx1_rx0),
                         .clk_10b(snps_clk_10b_flopped), 
                         .clk_16b(snps_clk_16b_flopped), 
                         .clk_25X4(snps_clk_25x4_flopped), 
                         .clk_kr4(snps_clk_kr4_flopped), 
                         .lane_num(ch_num));

        // Shift data register and pop timestamp from queue to make space for sampled bit.
        word_128b = word_128b >> 1;
        t_stamp.pop_front();

        word_128b[127] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];
        t_stamp.push_back($time);

        //Check for AM pattern excluding BIPs. and if mathced print timestamp to appropirate file.
	if ({word_128b[119:96], word_128b[87:64],word_128b[55:32], word_128b[23:0]} == {24'h193B0F, 24'hE6C4F0, 24'hDE973E, 24'h2168C1})
        begin
          stng = $sformatf("\nAM_DETECT # %0d | %t",cnt, t_stamp[0]);
          case(ch_num)
            0:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch0,"%s",stng);
              else
                $fwrite(fp_rx_ch0,"%s",stng);
            end
            1:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch1,"%s",stng);
              else
                $fwrite(fp_rx_ch1,"%s",stng);
            end
            2:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch2,"%s",stng);
              else
                $fwrite(fp_rx_ch2,"%s",stng);
            end
            3:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch3,"%s",stng);
              else
                $fwrite(fp_rx_ch3,"%s",stng);
            end
          endcase
          cnt++;
        end
      end
  endtask : fec_serial_am_log

//------------------------------------------------------------------------------
// Task: fec_decoder_serial_log
// ELANE FEC Serial Monitor with FEC decoder support. 
// This monitor finds RSFEC-CW boundary based on AMs, collects RSFEC 5280bit CW,
// Transdecode CW to form 80-66bit PCS scrambled words.
// based on the timestamp of bit 0 of CW it predicts the timestamp of each PCS word 
// as if RSFEC transcodeing never happened.
// 
// Timestamps are assigned as:
// Say Bit 0 of RSFEC CW appeared on serial line at time 'x'
// So time of PCS_WORD_0 will be x, PCS_WORD_1 will be x+66UI, 
// PCS_WORD_2 will be x+2*66UI
//
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - ch_num   : Elane Channel number.
//------------------------------------------------------------------------------
  task automatic fec_decoder_serial_log(bit tx1_rx0, bit [1:0] ch_num);

    bit  [12:0] cnt;
    bit  [5439:0] word_5280b;
    bit  [256:0] word_257b;
    realtime t_stamp;
    realtime t_ui;
    string stng;
    bit locked;
    bit am_found;
    bit [65:0] m_prev_rx_coded_3;
    bit [65:0] rx_coded[4];
    int word_size;

    // Initialize Timestamp and UI.
    t_stamp = 0;
    //t_ui = 0.038788ns;
    t_ui = 0.0387878787878788ns;

    $display("TX_DL_BIT :at time %t seen fec_decoder_serial task called",$time);

    //if ($test$plusargs("ETH_LL_FEC"))//rkporwa
    if ($test$plusargs("ETH_KP_FEC"))//rkporwa
      word_size = 5440; 
    else
      word_size = 5280;

    // Wait for VIP reset to deassert.
    wait(vip_ready_for_lane[ch_num] === 1'b1);

    //Open file pointer and Wait for posedge on serial line.
    if (tx1_rx0)
    begin
      if(open_cnt == 1)begin
        case(ch_num)
          0: fp_trans_tx_ch0 = $fopen($sformatf("%m.tx_decoded_channel0.out"), "w");
          1: fp_trans_tx_ch1 = $fopen($sformatf("%m.tx_decoded_channel1.out"), "w");
          2: fp_trans_tx_ch2 = $fopen($sformatf("%m.tx_decoded_channel2.out"), "w");
          3: fp_trans_tx_ch3 = $fopen($sformatf("%m.tx_decoded_channel3.out"), "w");
        endcase
      end
      wait(phy_tx_p[ch_num] === 1'b1);
    end
    else
    begin
      if(open_cnt == 1)begin
        case(ch_num)
          0: fp_trans_rx_ch0 = $fopen($sformatf("%m.rx_decoded_channel0.out"), "w");
          1: fp_trans_rx_ch1 = $fopen($sformatf("%m.rx_decoded_channel1.out"), "w");
          2: fp_trans_rx_ch2 = $fopen($sformatf("%m.rx_decoded_channel2.out"), "w");
          3: fp_trans_rx_ch3 = $fopen($sformatf("%m.rx_decoded_channel3.out"), "w");
        endcase
      end
      wait(phy_rx_p[ch_num] === 1'b1);
    end

    // In CR3TOP SS, the Serdes Model injects jitter so we use VIP CDR for serial line clk.
    // At EHIP IP level CDR is not needed, so appropriate clocks are used for sampling.
    //
    // We are sampling at negedge on serial as VIP drives at posedge.
    forever
    begin
      //sample data on negedge
      get_serial_clock(.tx1_rx0(tx1_rx0),
                       .clk_10b(snps_clk_10b_flopped), 
                       .clk_16b(snps_clk_16b_flopped), 
                       .clk_25X4(snps_clk_25x4_flopped), 
                       .clk_kr4(snps_clk_kr4_flopped), 
                       .lane_num(ch_num));

      // While AM lock is not done: We keep sampling bit and timestamp at every clock by shifting data in register and keep checking it 
      // againt AM pattern. 
      //
      // Once AM lock is done we collect 5280 bits i.e. RSFEC CW at a time and log timestamp of bit 0 of CW.
      // We dont keep track of AM distance and simply check for AM pattern before de-transcoding RSFEC word.
      //
      // Though we are not checking RSFEC parity but it can be done using the check_rsfec_parity which is being used for 100G FEC cases.
      if (!am_found)
      begin
        word_5280b = word_5280b >> 1;
        word_5280b[word_size - 1] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];
         if ({word_5280b[119:96], word_5280b[87:64],word_5280b[55:32], word_5280b[23:0]} == {24'h193B0F, 24'hE6C4F0, 24'hDE973E, 24'h2168C1})
         begin
           am_found = 1;
           cnt = 0;
         end
      end
      else
      begin
        word_5280b[cnt] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];
        if (cnt == 0) t_stamp = $realtime;
        cnt ++; 
      end

      // If cnt reached 5280 i.e. RSFEC CW is collected, de-transcode it to form PCS words.
      // The cnt will reach 5280 olny if AM lock is done else it remains 0.
      if (cnt == word_size)
      begin
        // As RSFEC trancoding is 257->264 we process 257 bits at a time. 257*20=5140 rest 140 bits are parity
        // Which are not needed.
        //
        // We check 257 bits for AM pattern, if found we simply print AMs without calling transdecoder else transdecoder is called
        // to form PCS CWs. Also time stamp is assigned to each 66bit word
        //
        // DBG logs are for debugging only post-process script ignores them
        for (int i = 0; i < 20; i++)
        begin
          word_257b = word_5280b[257*i +: 257];
          if ({word_257b[119:96], word_257b[87:64],word_257b[55:32], word_257b[23:0]} == {24'h193B0F, 24'hE6C4F0, 24'hDE973E, 24'h2168C1})
          begin
            stng = $sformatf("\nDBG_AM  | %t | 257'h%64h                  ",      (t_stamp + i*264*t_ui + 66*0*t_ui), word_257b);
            stng = $sformatf("%s\nALIGN | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*0*t_ui), {word_257b[63:0],2'b01}, word_257b[63:0], 2'b01);
            stng = $sformatf("%s\nALIGN | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*1*t_ui), {word_257b[127:64],2'b01},  word_257b[127:64], 2'b01);
            stng = $sformatf("%s\nALIGN | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*2*t_ui), {word_257b[191:128],2'b01}, word_257b[191:128], 2'b01);
            stng = $sformatf("%s\nALIGN | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*3*t_ui), {word_257b[255:192],2'b01}, word_257b[255:192], 2'b01);
          end
          else
          begin
            rsfec_transdecoder(.rsfec_cw(word_257b), .m_prev_rx_coded_3(m_prev_rx_coded_3), .rx_coded(rx_coded));
            stng = $sformatf("\nDBG_WORD| %t | 257'h%64h                  ",      (t_stamp + i*264*t_ui + 66*0*t_ui), word_257b);
            stng = $sformatf("%s\n      | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*0*t_ui), rx_coded[0], rx_coded[0][65:2], rx_coded[0][1:0]);
            stng = $sformatf("%s\n      | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*1*t_ui), rx_coded[1], rx_coded[1][65:2], rx_coded[1][1:0]);
            stng = $sformatf("%s\n      | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*2*t_ui), rx_coded[2], rx_coded[2][65:2], rx_coded[2][1:0]);
            stng = $sformatf("%s\n      | %t | 66'h%17h | 64'h%16h | 2'b%2b",stng, (t_stamp + i*264*t_ui + 66*3*t_ui), rx_coded[3], rx_coded[3][65:2], rx_coded[3][1:0]);
          end

          case(ch_num)
            0:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_trans_tx_ch0,"%s",stng);
              else
                $fwrite(fp_trans_rx_ch0,"%s",stng);
            end
            1:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_trans_tx_ch1,"%s",stng);
              else
                $fwrite(fp_trans_rx_ch1,"%s",stng);
            end
            2:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_trans_tx_ch2,"%s",stng);
              else
                $fwrite(fp_trans_rx_ch2,"%s",stng);
            end
            3:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_trans_tx_ch3,"%s",stng);
              else
                $fwrite(fp_trans_rx_ch3,"%s",stng);
            end
          endcase
        end
        cnt = 0;
      end
    end
  endtask : fec_decoder_serial_log

//------------------------------------------------------------------------------
// Task: core_serial_mon_50G
//------------------------------------------------------------------------------
  task automatic core_serial_mon_50G(bit tx1_rx0);

   `uvm_info("DEBUG_NO_FEC: inside core_serial_mon_50G task", "Entered ...",UVM_LOW)

 $display ("at time =%t DEBUG_NO_FEC:inside core_serial_mon_50G task",$time);
    fork
      core_serial_am_log_50G(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(0));
      core_serial_am_log_50G(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(1));
      core_serial_am_log_50G(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(0));
      core_serial_am_log_50G(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(1));
    join
  endtask : core_serial_mon_50G

//------------------------------------------------------------------------------
// Task: core_serial_am_log_50G
// Core NOFEC Serial Monitor. One instance for each Virtual lane. 
//
// Process : 
// 1 : Find Word lock based on SH interleave pattern  4'b00_11.
// 2 : Once Wordlock done find AM lock to determine Virual lane number
// 3 : Once AM lock done collect 132 bits at a time also log timestamp of first 2 bits of
//     132b word. Deinterleave and print PCS word along with time in appropriate file
// 
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - phy_num   : Core phy lane number.
// - v_lane : virtual lane number on phy
//------------------------------------------------------------------------------
  task automatic core_serial_am_log_50G(bit tx1_rx0, bit [1:0] phy_num, bit [1:0] v_lane);

    bit [8:0] cnt;
    bit [8:0] cnt1;
    bit [131:0] word_131b;
    bit [131:0] word_66b_1;
    bit [131:0] word_66b_2;
    bit word_align_found;
    bit [4:0] reordered_lane_num;
    bit [65:0] inrlvd_words[2];
    bit [65:0] inrlvd_words_1[2];
    bit curr_am;
    bit am_lock;
    bit word_lock;
    time t_stamp[2];
    string stng;

    //Initialize timestamp else it prints wrong format for first log
    for (int i = 0; i < 2; i++) t_stamp[i] = 0;

    //Start processing only when VIP is out of reset
    wait(vip_ready_for_core === 1'b1);

    //As Tag bits reset gearbox and data will be corrupted on TX
    //wait for event from testcase which will be triggered post data is stable after first tag
    `ifdef CR3TOP
      wait(core_serial_log_ev === 1'b1);
    `endif

    //Initially lines will be z followed by 0 for long time
    //Ignore this period.
    if (tx1_rx0)
    begin
      wait(phy_tx_p[phy_num] === 1'b1);
    end
    else
    begin
      wait(phy_rx_p[phy_num] === 1'b1);
    end

    //For every serial clock process data
    forever
    begin
      //sample data on negedge
       get_serial_clock(.tx1_rx0(tx1_rx0),
                         .clk_10b(snps_clk_10b_flopped), 
                         .clk_16b(snps_clk_16b_flopped), 
                         .clk_25X4(snps_clk_25x4_flopped), 
                         .clk_kr4(snps_clk_kr4_flopped), 
                         .lane_num(phy_num));

      // Sample the serial line.
      // STEP 1 : WORD ALIGN
      // First wait for word lock. This will be 2-1s followed by 2-0s. at bit [3:0] of 132 collected word.
      // Collect 132 bits and check if word align holds true. If yes word_lock done else it is a false align.
      // REDO above step
      // STEP 2:
      //   Keep collecting 132 bit words till am_lock not done
      // STEP 3:
      //   If am_lock is true collect timestamp of first 2 bits of 132 bit word for accurate time
      //

      if (!word_lock)
      begin
        if (word_align_found  == 0)
        begin
          word_131b = word_131b >> 1;
          word_131b[131] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];

          if (word_131b[3:0] == 4'b00_11) 
	      begin
	      word_align_found = 1;
	       if(tx1_rx0 == 1) 
		begin
       	        `uvm_info("check word_align_found 50G",$sformatf("word_align_found=%0d",word_align_found ),UVM_LOW)
                end
	      end
	end  //Word_allign =1
        else
        begin
          cnt ++;
          word_131b = word_131b >> 1;
          word_131b[131] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];

          if (cnt == 132)
          begin
            cnt = 0;
            if (word_131b[1:0] == 2'b11) 
		begin 
		word_lock = 1;
	        end
            else  word_align_found = 0;
          end
        end
      end
    else if (!am_lock)
      begin
        cnt ++;
        if (cnt == 132) cnt = 0;
        word_131b = word_131b >> 1;
        word_131b[131] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];
      	end
      else
      begin
        cnt ++;
        if (cnt inside {[1:2]}) t_stamp[cnt -1] = $time;
        else if (cnt == 132) cnt = 0;
        word_131b = word_131b >> 1;
        word_131b[131] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];
      end

      // If word lock is found and 132 bit word is collected
      // Deinterleave the 2 66bit words
      // Check if the word is AM and find VL number

	if(tx1_rx0 == 1) begin 
      if (word_lock == 1)
      begin
           for (int j = 0; j < 66; j++)
            begin
          	for (int i = 0; i < 2; i++)
             begin
            	inrlvd_words[i][j] = word_131b[j*2+i];
             end
           end

	if(tx1_rx0 == 1) 
	begin
       	`uvm_info("check word_131b 50G",$sformatf("word_131b=%0h",word_131b ), UVM_LOW)
	 end
        check_am_marker(.word_66b(inrlvd_words[v_lane]),.tx(tx1_rx0),.is_am(curr_am),.v_lane(reordered_lane_num));

      if (curr_am)
        begin
	if(tx1_rx0 == 1) 
	begin
	  am_lock = 1;
	  cnt = 0;
       	 `uvm_info("check am_lock 50G",$sformatf("am_lock=%0d,vlane=%d,cnt=%d",am_lock,reordered_lane_num,cnt),UVM_LOW)
        end
        end
      end
      end

	if(tx1_rx0 == 0) begin 
      if (word_lock == 1 && cnt == 0)
      begin
           for (int j = 0; j < 66; j++)
            begin
          	for (int i = 0; i < 2; i++)
             begin
            	inrlvd_words[i][j] = word_131b[j*2+i];
             end
           end
        check_am_marker(.word_66b(inrlvd_words[v_lane]),.tx(tx1_rx0),.is_am(curr_am),.v_lane(reordered_lane_num));
      if (curr_am)
        begin
	  am_lock = 1;
        end
      end
      end

     // IF AM is locked and 132 bit collected print to file
     if (am_lock && cnt == 0)
     begin
        for (int j = 0; j < 66; j++)
        begin
          for (int i = 0; i < 2; i++)
          begin
            inrlvd_words[i][j] = word_131b[j*2+i];
          end
        end

        // This is option for debugging purpose
        if (curr_am)
          stng = $sformatf("\nALIGN | %t | 132'h%132h | 66'h%66h | 66'h%66h",t_stamp[0], word_131b, inrlvd_words[1], inrlvd_words[0]);
        else
          stng = $sformatf("\n      | %t | 132'h%132h | 66'h%66h | 66'h%66h",t_stamp[0], word_131b, inrlvd_words[1], inrlvd_words[0]);

        // This is option for debugging purpose
        if (v_lane == 0)
        begin
          case(phy_num)
            0:
            begin
              if (tx1_rx0 == 1 )
                $fwrite(fp_tx_ch0,"%s",stng);
              else
                $fwrite(fp_rx_ch0,"%s",stng);
            end
            1:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch1,"%s",stng);
              else
                $fwrite(fp_rx_ch1,"%s",stng);
            end
            endcase
        end

        if (curr_am)
        begin
          stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",t_stamp[v_lane], inrlvd_words[v_lane], inrlvd_words[v_lane][65:2],inrlvd_words[v_lane][1:0]);
        end
        else
        begin
          stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",t_stamp[v_lane], inrlvd_words[v_lane], inrlvd_words[v_lane][65:2],inrlvd_words[v_lane][1:0]);
        end

       if (tx1_rx0 == 1 )
         $fwrite(core_fp_tx[reordered_lane_num],"%s",stng);
       else
         $fwrite(core_fp_rx[reordered_lane_num],"%s",stng);

      end
    end
  endtask : core_serial_am_log_50G

//------------------------------------------------------------------------------
// Task: core_serial_mon
//------------------------------------------------------------------------------
  task automatic core_serial_mon(bit tx1_rx0);

   `uvm_info("DEBUG_NO_FEC: inside core_serial_mon task", "Entered ...",UVM_LOW)

 $display ("at time =%t DEBUG_NO_FEC:inside core_serial_mon task",$time);
 
    fork
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(0));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(1));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(2));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(3));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .v_lane(4));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(0));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(1));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(2));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(3));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .v_lane(4));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .v_lane(0));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .v_lane(1));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .v_lane(2));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .v_lane(3));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .v_lane(4));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .v_lane(0));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .v_lane(1));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .v_lane(2));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .v_lane(3));
      core_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .v_lane(4));
    join
  endtask : core_serial_mon

//------------------------------------------------------------------------------
// Task: core_serial_am_log
// Core NOFEC Serial Monitor. One instance for each Virtual lane. 
//
// Process : 
// 1 : Find Word lock based on SH interleave pattern  10'b00000_11111.
// 2 : Once Wordlock done find AM lock to determine Virual lane number
// 3 : Once AM lock done collect 330 bits at a time also log timestamp of first 5 bits of
//     330b word. Deinterleave and print PCS word along with time in appropriate file
// 
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - phy_num   : Core phy lane number.
// - v_lane : virtual lane number on phy
//------------------------------------------------------------------------------
  task automatic core_serial_am_log(bit tx1_rx0, bit [1:0] phy_num, bit [4:0] v_lane);

    bit [8:0] cnt;
    bit [329:0] word_329b;
    bit word_align_found;
    bit [4:0] reordered_lane_num;
    bit [65:0] inrlvd_words[5];
    bit curr_am;
    bit am_lock;
    bit word_lock;
    time t_stamp[5];
    string stng;

    //Initialize timestamp else it prints wrong format for first log
    for (int i = 0; i < 5; i++) t_stamp[i] = 0;

    //Start processing only when VIP is out of reset
    wait(vip_ready_for_core === 1'b1);

    //As Tag bits reset gearbox and data will be corrupted on TX
    //wait for event from testcase which will be triggered post data is stable after first tag
    `ifdef CR3TOP
      wait(core_serial_log_ev === 1'b1);
    `endif

    //Initially lines will be z followed by 0 for long time
    //Ignore this period.
    if (tx1_rx0)
    begin
      wait(phy_tx_p[phy_num] === 1'b1);
    end
    else
    begin
  
      wait(phy_rx_p[phy_num] === 1'b1);
    end

    //For every serial clock process data
    forever
    begin
      //sample data on negedge
       get_serial_clock(.tx1_rx0(tx1_rx0),
                         .clk_10b(snps_clk_10b_flopped), 
                         .clk_16b(snps_clk_16b_flopped), 
                         .clk_25X4(snps_clk_25x4_flopped), 
                         .clk_kr4(snps_clk_kr4_flopped), 
                         .lane_num(phy_num));

      //Sample the serial line.
      // STEP 1 : WORD ALIGN
      //   First wait for word lock. This will be 5-1s followed by 5-0s. at bit [9:0] of 330 collected word.
      //   Collect 330 bits and check if word align holds true. If yes word_lock done else it is a false align. REDO above step
      // STEP 2:
      //   Keep collecting 330 bit words till am_lock not done
      // STEP 3:
      //   If am_lock is true collect timestamp of first 5 bits of 330 bit word for accurate time
      //

      if (!word_lock)
      begin
        if (word_align_found  == 0)
        begin
          word_329b = word_329b >> 1;
          word_329b[329] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];

          if (word_329b[9:0] == 10'b00000_11111) 
	      begin
	      word_align_found = 1;
       	      `uvm_info("check word_align_found",$sformatf("word_align_found=%0d",word_align_found ), UVM_LOW)
              end
	end
        else
        begin
          cnt ++;
          word_329b = word_329b >> 1;
          word_329b[329] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];

          if (cnt == 330)
          begin
            cnt = 0;
            //if (word_329b[9:0] == 10'b00000_11111) 
            if (word_329b[4:0] == 5'b1_1111) 
		begin 
		word_lock = 1;
       		`uvm_info("check Word_lock",$sformatf("Word_lock=%0d",word_lock ), UVM_LOW)
	    end
            else  word_align_found = 0;
          end
        end
      end
    else if (!am_lock)
      begin
        cnt ++;
        if (cnt == 330) cnt = 0;
        word_329b = word_329b >> 1;
        word_329b[329] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];
      end
      else
      begin
        cnt ++;
        if (cnt inside {[1:5]}) t_stamp[cnt -1] = $time;
        else if (cnt == 330) cnt = 0;
        word_329b = word_329b >> 1;
        word_329b[329] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];
      end

      // If word lock is found and 330 bit word is collected
      // Deinterleave the 5 66bit words
      // Check if the word is AM and find VL number
      if (word_lock == 1 && cnt == 0)
      begin
        for (int j = 0; j < 66; j++)
        begin
          for (int i = 0; i < 5; i++)
          begin
            inrlvd_words[i][j] = word_329b[j*5+i];
          end
        end

        check_am_marker(.word_66b(inrlvd_words[v_lane]),.tx(tx1_rx0),.is_am(curr_am),.v_lane(reordered_lane_num));

      if (curr_am)
        begin
          am_lock = 1;
       	  `uvm_info("check am_lock",$sformatf("am_lock=%0d",am_lock ), UVM_LOW)
        end
      end

     // IF AM is locked and 330 bit collected print to file
     if (am_lock && cnt == 0)
     begin
        for (int j = 0; j < 66; j++)
        begin
          for (int i = 0; i < 5; i++)
          begin
            inrlvd_words[i][j] = word_329b[j*5+i];
          end
        end

        // This is option for debugging purpose
        if (curr_am)
          stng = $sformatf("\nALIGN | %t | 330'h%330h | 66'h%66h | 66'h%66h | 66'h%66h | 66'h%66h | 66'h%66h",t_stamp[0], word_329b, inrlvd_words[4], inrlvd_words[3], inrlvd_words[2], inrlvd_words[1], inrlvd_words[0]);
        else
          stng = $sformatf("\n      | %t | 330'h%330h | 66'h%66h | 66'h%66h | 66'h%66h | 66'h%66h | 66'h%66h",t_stamp[0], word_329b, inrlvd_words[4], inrlvd_words[3], inrlvd_words[2], inrlvd_words[1], inrlvd_words[0]);

        // This is option for debugging purpose
        if (v_lane == 0)
        begin
          case(phy_num)
            0:
            begin
              if (tx1_rx0 == 1 )
                $fwrite(fp_tx_ch0,"%s",stng);
              else
                $fwrite(fp_rx_ch0,"%s",stng);
            end
            1:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch1,"%s",stng);
              else
                $fwrite(fp_rx_ch1,"%s",stng);
            end
            2:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch2,"%s",stng);
              else
                $fwrite(fp_rx_ch2,"%s",stng);
            end
            3:
            begin
              if (tx1_rx0 == 1)
                $fwrite(fp_tx_ch3,"%s",stng);
              else
                $fwrite(fp_rx_ch3,"%s",stng);
            end
          endcase
        end

        if (curr_am)
        begin
          //stng = $sformatf("\nALIGN | %t | 330'h%330h | 66'h%66h ",t_stamp[v_lane], word_329b, inrlvd_words[v_lane]);
          stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",t_stamp[v_lane], inrlvd_words[v_lane], inrlvd_words[v_lane][65:2], inrlvd_words[v_lane][1:0]);
        end
        else
        begin
          //stng = $sformatf("\n      | %t | 330'h%330h | 66'h%66h ",t_stamp[v_lane], word_329b, inrlvd_words[v_lane]);
          stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",t_stamp[v_lane], inrlvd_words[v_lane], inrlvd_words[v_lane][65:2], inrlvd_words[v_lane][1:0]);
        end

       if (tx1_rx0 == 1 )
         $fwrite(core_fp_tx[reordered_lane_num],"%s",stng);
       else
         $fwrite(core_fp_rx[reordered_lane_num],"%s",stng);

      end
    end
  endtask : core_serial_am_log

//------------------------------------------------------------------------------
// Task: core_fec_serial_mon
// Core FEC Serial Monitor. Supports AM reorder, deSkew and RSFEC transdecoding. 
//
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
//------------------------------------------------------------------------------
  task automatic core_fec_serial_mon(bit tx1_rx0);

    bit [5439:0] fec_word;
    bit [5439:0] fec_word_b;
    bit [10279:0] tx_scrambled_am;
    bit [5279:0] rev_transcoded_word_5280b;
    bit [65:0] rev_transcoded_pcs_word_66b[];
    bit [256:0] word_257b;
    bit [65:0] m_prev_rx_coded_3;
    bit [65:0] rx_coded[4];
    bit [319:0] am_payloads[4];
    bit [1284:0] word_1285b;
    bit [63:0] rx_am_data;
    string stng;
    int cnt;
    int m;
    int num_vl;
    int num_phy; //also represent num of serial clocks
    int ui_multiplier = 1;
    realtime cw_t_stamp[][$];
    bit first_cw_skipped = 0;

    bit[57:0] m_rx_descrambler_reg = '1;

    bit is_am; 
    realtime t_ui;

    // Initialize variables
    if ($test$plusargs("ETH_400G"))
    begin
      num_vl = 16;
      num_phy = 16;
	$display ("DEBUG_SPM:at time =%t NUM_VL=%d NUM_PHY=%d",$time,num_vl,num_phy);
    end
    else if ($test$plusargs("ETH_200G"))
    begin
      num_vl = 8;
      num_phy = 8;
	$display ("DEBUG_200G_SPM:at time =%t NUM_VL=%d NUM_PHY=%d",$time,num_vl,num_phy);
    end
    else if ($test$plusargs("ETH_50G"))
    begin
       num_vl = 4;
       num_phy = 2;
	$display ("DEBUG_50G_SPM:at time =%t NUM_VL=%d NUM_PHY=%d",$time,num_vl,num_phy);
    end
    else
    begin
      num_vl = 20;
      num_phy = 4;
      $display ("DEBUG_100G_SPM:at time =%t NUM_VL=%d NUM_PHY=%d",$time,num_vl,num_phy);
    end

    if(tx1_rx0) 
    begin
      core_fec_phy_word_tx = new[num_phy];
      if(open_cnt == 1)begin
        //for (int i = 0; i < num_vl; i++) core_fp_trans_tx[i] =  $fopen($sformatf("%m.tx_channel%0d.out",i), "w");
        for (int i = 0; i < num_vl; i++) core_fp_trans_tx[i] =  $fopen($sformatf("%m.core_fec_serial_mon.tx_channel%0d.out",i), "w");
      end
    end
    else
    begin
      core_fec_phy_word_rx = new[num_phy];
      if(open_cnt == 1)begin
        //for (int i = 0; i < num_vl; i++) core_fp_trans_rx[i] =  $fopen($sformatf("%m.rx_channel%0d.out",i), "w");
        for (int i = 0; i < num_vl; i++) core_fp_trans_rx[i] =  $fopen($sformatf("%m.core_fec_serial_mon.rx_channel%0d.out",i), "w");
      end
    end
    cw_t_stamp = new[num_phy];

   //Call Serial line monitor for each phy lane.
   // The monitors looks for AM lock and then collects fec_cw_size/4 bits at an time and push into queue based on phy-lane number
   // As first data pushed is AM, it also acts as deskewer.
   if ($test$plusargs("ETH_400G"))
   begin
      if ($test$plusargs("PHY8X2"))
      begin
         ui_multiplier = 2;
         //t_ui = 0.018824ns;//0.0188235294117
         t_ui = 0.009411764705ns;
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(4), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(4), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(5), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(5), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(6), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(6), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(7), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(7), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
         join_none
      end
      else if ($test$plusargs("PHY4X4"))
      begin
         ui_multiplier = 4;
         //t_ui = 0.009412ns;//0.0188235294117
         t_ui = 0.004705882352ns;
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(2), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(3), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(2), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(3), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(2), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(3), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(2), .intl_vls(2), .cw_t_stamp(cw_t_stamp));
//            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(3), .intl_vls(2), .cw_t_stamp(cw_t_stamp));

         join_none
      end
      else
      begin
        `uvm_fatal("ehip_ptp_serial_line_monitor",$sformatf("Invalid Mode selected. Check runtime arguments passed.")) 
      end
   end
   else if ($test$plusargs("ETH_200G"))
   begin
      if ($test$plusargs("PHY4X2"))
      begin
        
         ui_multiplier = 2;
         //t_ui = $test$plusargs("PAM4_MODE") ? 0.018824ns : 0.037648ns;//0.0185294117647059
         //t_ui = $test$plusargs("PAM4_MODE") ? 0.018824ns : 0.0094117647058ns;//pam4 need to chck
         t_ui = $test$plusargs("PAM4_MODE") ? 0.0094117647058ns : 0.018824ns;//pam4 need to chck
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
         join_none
      end
      else if ($test$plusargs("PHY2X4"))
      begin
         //ui_multiplier = 4;
//        t_ui = 0.004705882352ns;//pam4 need to chck
         ui_multiplier = 2;
         t_ui = $test$plusargs("PAM4_MODE") ? 0.0094117647058ns : 0.018824ns;//pam4 need to chck
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));       
         join_none
      end
      else
      begin
         ui_multiplier = 1;
         t_ui = 0.018823529ns;//25.6/1360
         //t_ui = 0.038787878ns;
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(4), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(5), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(6), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(7), .cw_t_stamp(cw_t_stamp));
         join_none
      end
   end
   else if ($test$plusargs("ETH_50G"))
   begin
      if($test$plusargs("PHY1X4"))
      begin
         t_ui = 0.0376470588235ns;  //t_ui = 0.018823529ns;
         ui_multiplier = 1;
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
         join_none
      end
      else
      begin	  
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
         join_none
         if ($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
            t_ui = 0.0376470588235ns;
         else
            t_ui = 0.038787878ns;
      end	    
   end
   else
   begin //100G
      if ($test$plusargs("PHY2X10"))
      begin
         if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))
         begin
            t_ui = 0.0376470588235ns; // 330UI=12.8, DUT running at 100Gx2 - UI = 0.0188235, SPM cannot support PAM4 running at 100Gx4 - UI = 0.0376470588235
            ui_multiplier = 1;
         end
         else begin
            //t_ui = 0.0376470588235ns;
            t_ui = 0.038787878ns;
            ui_multiplier = 1;
         end
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(0), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .vl_num(1), .intl_vls(1), .cw_t_stamp(cw_t_stamp));
         join_none
      end //if ($test$plusargs("PHY2X10"))
      else if($test$plusargs("PHY1X20"))
      begin

         if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))
         begin   
            t_ui = 0.0376470588235ns;
            //t_ui = 0.018824ns; // 330UI=12.8
            ui_multiplier = 1;
         end
         else begin
            t_ui = 0.03878787878ns; // 330UI=12.8
            ui_multiplier = 1;
         end //if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))   
         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(0), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(0));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .vl_num(1), .intl_vls(2), .cw_t_stamp(cw_t_stamp), .even_odd_clk(1));     
         join_none         
         
      end //if($test$plusargs("PHY1X20"))
      else 
      begin
         if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))
         begin
            t_ui = 0.0376470588235ns;
            //t_ui = 0.018824ns; // 330UI=12.8
            ui_multiplier = 1;
         end
         else begin
            t_ui = 0.03878787878ns; // 330UI=12.8
            ui_multiplier = 1;
         end //if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))

         fork
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(0), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(1), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(2), .cw_t_stamp(cw_t_stamp));
            core_fec_serial_am_log(.tx1_rx0(tx1_rx0), .phy_num(3), .cw_t_stamp(cw_t_stamp));
         join_none
      end //else begin
   end //100G

  // Keep checking if data is present in all queues of phylane.
    forever
    begin
      fork 
        begin : isolating_thread
          for(int index = 0; index < num_phy; index++)
          begin : for_loop
            fork
              automatic int idx=index;
              begin
                if (tx1_rx0) wait (core_fec_phy_word_tx[idx].size >= 1);
                else wait (core_fec_phy_word_rx[idx].size >= 1);
              end
            join_none;
          end : for_loop
        wait fork;
        end : isolating_thread
      join

      is_am = 0;
      fec_word = '0;
      fec_word_b = '0;
      rev_transcoded_pcs_word_66b.delete();
      rev_transcoded_word_5280b = '0;

      // Form RSFEC CW from data from phy-streams
      // Also Check parity of RSFEC CW.
      // We are doing this to ensure reordering, deskew and symbol distribution worked properly.
      // It was coded while debugging monitor bring up and is not necessary now.
      if ($test$plusargs("ETH_400G") || $test$plusargs("ETH_200G"))
      begin
        rev_transcoded_pcs_word_66b = new[k_symbols*10*4*2/257];//160

        for (int sym = 0; sym < ((n_symbols*2)/num_phy); sym++)//136
        begin
          for (int phy = 0; phy < num_phy; phy++)
          begin
            if (sym %2 == 0)
            begin
              if (phy%2 == 0)
              begin
                fec_word[(sym*num_phy*10/2 + (phy/2)*10) +: 10] = (tx1_rx0) ? (core_fec_phy_word_tx[phy][0][sym*10 +: 10]) : (core_fec_phy_word_rx[phy][0][sym*10 +: 10]); 
              end
              else
              begin
                fec_word_b[(sym*num_phy*10/2 + (phy/2)*10) +: 10] = (tx1_rx0) ? (core_fec_phy_word_tx[phy][0][sym*10 +: 10]) : (core_fec_phy_word_rx[phy][0][sym*10 +: 10]); 
              end
            end
            else
            begin
              if (phy%2 == 0)
              begin
                fec_word_b[(sym*num_phy*10/2 + (phy/2)*10) +: 10] = (tx1_rx0) ? (core_fec_phy_word_tx[phy][0][sym*10 +: 10]) : (core_fec_phy_word_rx[phy][0][sym*10 +: 10]); 
              end
              else
              begin
                fec_word[(sym*num_phy*10/2 + (phy/2)*10) +: 10] = (tx1_rx0) ? (core_fec_phy_word_tx[phy][0][sym*10 +: 10]) : (core_fec_phy_word_rx[phy][0][sym*10 +: 10]); 
              end
            end
          end // for (int phy = 0; phy < 16; phy++)
        end // for (int sym = 0; sym < (68); sym++)
       
        //Check Parity
        check_rsfec_parity(fec_word, tx1_rx0);
        check_rsfec_parity(fec_word_b, tx1_rx0);
      end // if ($test$plusargs("ETH_400G"))
      else 
      begin
        for (int sym = 0; sym < (n_symbols/num_phy); sym++)
        begin
          for (int phy = 0; phy < num_phy; phy++)
          begin
            fec_word[(num_phy*10*sym + 10*phy) +: 10] = (tx1_rx0) ? (core_fec_phy_word_tx[phy][0][sym*10 +: 10]) : (core_fec_phy_word_rx[phy][0][sym*10 +: 10]);
          end
        end

        //Check Parity
        //rk check_rsfec_parity(fec_word, tx1_rx0);
      end

      if ($test$plusargs("ETH_400G") || $test$plusargs("ETH_200G"))
      begin
        rev_transcoded_pcs_word_66b = new[k_symbols*10*4*2/257];//160

        for (int i = 0; i < k_symbols; i++)//514
        begin
          tx_scrambled_am[(20*i)+:10] =  fec_word[i*10 +: 10];
          tx_scrambled_am[(20*i + 10)+:10] = fec_word_b[i*10 +: 10];
        end

        if (tx_scrambled_am[79:0] == 80'ha6a9aa6a9aa6a9aa6a9a)
        begin

          is_am = 1;
          rev_transcoded_pcs_word_66b[0]  = {64'h00_D9_B5_65_00_26_4A_9A,2'b01}; 
          rev_transcoded_pcs_word_66b[1]  = {64'h01_D9_B5_65_01_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[2]  = {64'h02_D9_B5_65_02_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[3]  = {64'h03_D9_B5_65_03_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[4]  = {64'h04_D9_B5_65_04_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[5]  = {64'h05_D9_B5_65_05_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[6]  = {64'h06_D9_B5_65_06_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[7]  = {64'h07_D9_B5_65_07_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[8]  = {64'h08_D9_B5_65_08_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[9]  = {64'h09_D9_B5_65_09_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[10] = {64'h0A_D9_B5_65_0A_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[11] = {64'h0B_D9_B5_65_0B_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[12] = {64'h0C_D9_B5_65_0C_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[13] = {64'h0D_D9_B5_65_0D_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[14] = {64'h0E_D9_B5_65_0E_26_4A_9A,2'b01};
          rev_transcoded_pcs_word_66b[15] = {64'h0F_D9_B5_65_0F_26_4A_9A,2'b01};
          if ($test$plusargs("ETH_400G"))
          begin
            rev_transcoded_pcs_word_66b[16] = {64'h10_D9_B5_65_10_26_4A_9A,2'b01}; 
            rev_transcoded_pcs_word_66b[17] = {64'h11_D9_B5_65_11_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[18] = {64'h12_D9_B5_65_12_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[19] = {64'h13_D9_B5_65_13_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[20] = {64'h14_D9_B5_65_14_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[21] = {64'h15_D9_B5_65_15_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[22] = {64'h16_D9_B5_65_16_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[23] = {64'h17_D9_B5_65_17_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[24] = {64'h18_D9_B5_65_18_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[25] = {64'h19_D9_B5_65_19_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[26] = {64'h1A_D9_B5_65_1A_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[27] = {64'h1B_D9_B5_65_1B_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[28] = {64'h1C_D9_B5_65_1C_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[29] = {64'h1D_D9_B5_65_1D_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[30] = {64'h1E_D9_B5_65_1E_26_4A_9A,2'b01};
            rev_transcoded_pcs_word_66b[31] = {64'h1F_D9_B5_65_1F_26_4A_9A,2'b01};
          end
          
          for (int i = num_phy/2; i < k_symbols*10*2/257; i++)//4,40
          begin
            word_257b = pcs_descrambler(tx_scrambled_am[257*i +: 257], m_rx_descrambler_reg);
            rsfec_transdecoder(word_257b, m_prev_rx_coded_3, rx_coded);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[0]);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[1]);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[2]);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[3]);
            
            for (int j = 0; j < 4; j ++)
            begin
              if(first_cw_skipped == 0)  rx_coded[j][1:0] = 2'b01; //As the descrambler needs 58 bits to sync the first CW is corrunpted and is interpreted as SOP 
              rev_transcoded_pcs_word_66b[i*4 + j] =  rx_coded[j];
              if(first_cw_skipped == 0 && j == 3) first_cw_skipped = 1;
            end
          end
        end
        else
        begin

          is_am = 0;

          for (int i = 0; i < k_symbols*10*2/257; i++)//0,40
          begin
            word_257b = pcs_descrambler(tx_scrambled_am[257*i +: 257], m_rx_descrambler_reg);
            rsfec_transdecoder(word_257b, m_prev_rx_coded_3, rx_coded);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[0]);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[1]);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[2]);
//            if(tx1_rx0)$display("DA_DBG_MON_1 |       | %h | encoded_data=%h", word_257b, rx_coded[3]);
            for (int j = 0; j < 4; j ++)//4
            begin
              rev_transcoded_pcs_word_66b[i*4 + j] =  rx_coded[j];
            end
          end 
        end
      end
      else if ($test$plusargs("ETH_50G"))
      begin
        if ($test$plusargs("ETH_KR_FEC") || $test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
        begin
          rev_transcoded_pcs_word_66b = new[k_symbols*10*4/257];

          //Process 257bit at a time as AM size is 264 ~= 257b Transcoded word
          // 257*20=5140 message part only
          for (int i = 0; i < (k_symbols*10/257); i++)
          begin

            //Check for AMs
            //rk: if (i == 0 && fec_word[47:0] == 48'hd4775dda4290)
            if (i == 0 && fec_word[43:0] == 44'h4775dda4290)
            begin
              is_am = 1;
              rev_transcoded_pcs_word_66b[4*i + 0] = {64'hFF_B8_89_6F_00_47_76_90,2'b01};
              rev_transcoded_pcs_word_66b[4*i + 1] = {64'hFF_19_3B_0F_00_E6_C4_F0,2'b01};
              rev_transcoded_pcs_word_66b[4*i + 2] = {64'hFF_64_9A_3A_00_9B_65_C5,2'b01};
              rev_transcoded_pcs_word_66b[4*i + 3] = {64'hFF_C2_86_5D_00_3D_79_A2,2'b01};
            end
            else
            begin
              rsfec_transdecoder(fec_word[(i * 257) +: 257], m_prev_rx_coded_3, rx_coded);

              for (int loop = 0; loop < 4; loop++)
              begin
                rev_transcoded_pcs_word_66b[i*4 + loop] = rx_coded[loop];
              end
            end
          end // for (int i = 0; i < 20; i++)
        end // else if ($test$plusargs("ETH_50G_KRFEC"))
        else
        begin
          rev_transcoded_pcs_word_66b = new[4];
          for (int i = 0; i < num_phy; i++)
          begin
            rev_transcoded_pcs_word_66b[i] = (tx1_rx0) ? (core_fec_phy_word_tx[i][0]) : (core_fec_phy_word_rx[i][0]);
          end
        end
      end
      else
      begin
        rev_transcoded_pcs_word_66b = new[k_symbols*10*4/257];

        // Process 1285 bits at a time
        for (int i = 0; i < (k_symbols*10/1285); i++)
        begin
          word_1285b = fec_word[(i*1285) +: 1285];

          //Check for AMs
          // 80'h1685a1685a304c1304c1 is derived by taking 10 bits of AM from each lane.
          if (word_1285b[79:0] == 80'h1685a1685a304c1304c1)
          begin

            is_am = 1;
            for (int k=0; k<4; k++)
            begin
              for (int l=0; l<32; l++)
              begin
                m = k + 4*l;
                am_payloads[k][10*l +: 10] = word_1285b[10*m +: 10];
              end
            end

            for (int x=0; x<5; x++)
            begin
              for (int y=0; y<4; y++)
              begin
                rx_am_data = am_payloads[y][64*x +: 64];
                rx_coded[y] = {rx_am_data, 2'b01};

                // AM 0, 1, 2 and 3
                if (x == 0)
                begin
                  case(y) 
                    1 : 
                    begin
                      rx_coded[y][25:2]  = 24'h8E719D;
                      rx_coded[y][57:34] = 24'h718E62;
                    end
                    2 :
                    begin
                      rx_coded[y][25:2]  = 24'hE84B59;
                      rx_coded[y][57:34] = 24'h17B4A6;
                    end
                    3 :
                    begin
                      rx_coded[y][25:2]  = 24'h7B954D;
                      rx_coded[y][57:34] = 24'h846AB2;
                    end
                  endcase
                end
                // AM 16, 17, 18 and 19
                if (x == 4)
                begin
                  case(y) 
                    1 :
                    begin
                      rx_coded[y][25:2]  = 24'hB7D6AD;
                      rx_coded[y][57:34] = 24'h482952;
                    end
                    2 :
                    begin
                      rx_coded[y][25:2]  = 24'h2A665F;
                      rx_coded[y][57:34] = 24'hD599A0;
                    end
                    3 :
                    begin
                      rx_coded[y][25:2]  = 24'hE5F0C0;
                      rx_coded[y][57:34] = 24'h1A0F3F;
                    end
                  endcase
                end
              end //for (int y=0; y<4; y++)
              
              for (int loop = 0; loop < 4; loop++)
              begin
                rev_transcoded_pcs_word_66b[i*20 + x*4 + loop] = rx_coded[loop];
              end

            end //for (int x=0; x<5; x++)
          end //if (word_1285b[23:0] == 24'h2168C1 && word_1285b[55:32]== 24'hDE973E)
          else
          begin
            for (int x = 0; x < 5; x++)
            begin
              rsfec_transdecoder(word_1285b[(x * 257) +: 257], m_prev_rx_coded_3, rx_coded);

              for (int loop = 0; loop < 4; loop++)
              begin
                rev_transcoded_pcs_word_66b[i*20 + x*4 + loop] = rx_coded[loop];
              end
            
            end //for (int x = 0; x < 5; x++)
          end //end ... if (word_1285b[23:0] == 24'h2168C1 && word_1285b[55:32]== 24'hDE973E)
        end //for (int i = 0; i < 4; i++)
      end

      // Write Words and Time to Individual VL files
      for (int pcs_word = 0; pcs_word < rev_transcoded_pcs_word_66b.size(); pcs_word ++)
      begin
        if ($test$plusargs("ETH_400G") || $test$plusargs("ETH_200G"))
        begin
          if (is_am && pcs_word < 2*num_vl) 
            begin
              //stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % num_vl][0] + t_ui*66*ui_multiplier*(pcs_word / num_vl)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
              stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % num_vl][0] + t_ui*136*ui_multiplier*(pcs_word / num_vl)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
            else
            begin
              //stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % num_vl][0] + t_ui*66*ui_multiplier*(pcs_word / num_vl)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
              stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % num_vl][0] + t_ui*136*ui_multiplier*(pcs_word / num_vl)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
        end
        else if ($test$plusargs("ETH_50G"))
        begin
          if ($test$plusargs("ETH_KR_FEC"))
          begin
            if (rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_47_76_90 ||
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_E6_C4_F0 ||
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_9B_65_C5 || 
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_3D_79_A2)
            begin
              if (pcs_word inside {0,1})
                stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0]), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
              else
                stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0] + t_ui*66*(pcs_word/2)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
            else
            begin
              if (pcs_word inside {0,1})
                stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0]), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
              else
                stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0] + t_ui*66*(pcs_word/2)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
          end
	  else if ($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
	  begin
            if (rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_47_76_90 ||
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_E6_C4_F0 ||
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_9B_65_C5 || 
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_3D_79_A2)
            begin
              if (pcs_word inside {0,1})
                stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0]), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
              else
                stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0] + t_ui*68*(pcs_word/2)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
            else
            begin
              if (pcs_word inside {0,1})
                stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0]), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
              else
                stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % 2][0] + t_ui*68*(pcs_word/2)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
          end
          else
          begin
            if (rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_47_76_90 ||
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_E6_C4_F0 ||
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_9B_65_C5 || 
                rev_transcoded_pcs_word_66b[pcs_word][25:2] == 24'h_3D_79_A2)
            begin
              stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % num_vl][0] + t_ui*68*ui_multiplier*(pcs_word / num_vl)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
            else
            begin
              stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word % num_vl][0] + t_ui*68*ui_multiplier*(pcs_word / num_vl)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
          end
        end
        else 
        begin
          //This assigns timestamps as :
          // 1) As if iterveaving happended at ehip. (This is what PTP logic assumes)
          // 2) PCS words without interleaving
          if($test$plusargs("en_fec_core_interl_ts"))
          begin
            if (is_am && pcs_word < num_vl) 
            begin
              stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word%4][0] + t_ui*(330*(pcs_word/20) + (pcs_word%20)/4)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
            else
            begin
              stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word%4][0] + t_ui*(330*(pcs_word/20) + (pcs_word%20)/4)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
          end
          else
          begin
            if (is_am && pcs_word < num_vl) 
            begin
	    if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))
	    stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word%4][0] + t_ui*68*(pcs_word/4)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
	    else
	    stng = $sformatf("\nALIGN | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word%4][0] + t_ui*66*(pcs_word/4)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
            else
            begin
	    if($test$plusargs("ETH_KP_FEC")||$test$plusargs("ETH_LL_FEC"))
	    stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word%4][0] + t_ui*68*(pcs_word/4)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
	    else
	    stng = $sformatf("\n      | %t | 66'h%16h | 64'h%16h | 2'b%2b",(cw_t_stamp[pcs_word%4][0] + t_ui*66*(pcs_word/4)), rev_transcoded_pcs_word_66b[pcs_word], rev_transcoded_pcs_word_66b[pcs_word][65:2], rev_transcoded_pcs_word_66b[pcs_word][1:0]);
            end
          end
        end

	if($test$plusargs("ETH_50G"))
	begin
	    if (tx1_rx0 == 1 )
		$fwrite(core_fp_trans_tx[pcs_word%4],"%s",stng);
	    else
		$fwrite(core_fp_trans_rx[pcs_word%4],"%s",stng);
	end
        else if($test$plusargs("ETH_200G"))
	begin
	    if (tx1_rx0 == 1 )
		$fwrite(core_fp_trans_tx[pcs_word%8],"%s",stng);
	    else
		$fwrite(core_fp_trans_rx[pcs_word%8],"%s",stng);
	end
        else if($test$plusargs("ETH_400G"))
	begin
	    if (tx1_rx0 == 1 )
		$fwrite(core_fp_trans_tx[pcs_word%16],"%s",stng);
	    else
		$fwrite(core_fp_trans_rx[pcs_word%16],"%s",stng);
	end
	else
	begin
	    if (tx1_rx0 == 1 )
		$fwrite(core_fp_trans_tx[pcs_word%20],"%s",stng);
	    else
		$fwrite(core_fp_trans_rx[pcs_word%20],"%s",stng);
	end
	end
      //Pop Data from Queues
      for (int phy = 0; phy < num_phy; phy++)
      begin
         if(tx1_rx0)begin
          core_fec_phy_word_tx[phy].pop_front();
         end else 
         begin
          core_fec_phy_word_rx[phy].pop_front();
         end
          cw_t_stamp[phy].pop_front();
        end
      
    end
  endtask : core_fec_serial_mon

//------------------------------------------------------------------------------
// Task: core_fec_serial_am_log
// Core FEC Serial Monitor for serial line logging and AM align. 
// Once AM aligned it collects 132b words and pushes into  core_fec_phy_word_tx and  core_fec_phy_word_rx queue
//
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - phy_num  : Phy lane number 
// - vl_num   : virtual lane
// - intl_vls : number of interleaved VLs per Phy
// - even_odd_clk : 1 = use even clock, 0 use odd clock. Only applicable when intl_vls > 1
//------------------------------------------------------------------------------
  task automatic core_fec_serial_am_log(bit tx1_rx0, bit [2:0] phy_num, bit [1:0] vl_num = 0, bit [2:0] intl_vls = 1, ref realtime cw_t_stamp[][$], input bit even_odd_clk = 0);

    // KR4FEC    : 5280/4    = 1320 
    // KP4FEC    : 5440/4    = 1360 
    // 400G      : 5440*2/16 = 680 
    // 200G      : 5440*2/8  = 1360 
    // 50G_NOFEC : PCS_CW    = 66 
    // 50G_KR    : 5280/2    = 2640 
    // 50G_KP    : 5440/2    = 2720
    bit [2719:0] phy_word;
    bit [3:0] reordered_phy_num;
    bit curr_am;
    bit am_locked;
    time am_t_stamp;
    string stng;
    int cnt;
    int bit_cnt;
    realtime t_stamp[$:2719];
    bit found_once;
    int phy_word_size;

    if ($test$plusargs("ETH_400G"))
    begin
      phy_word_size = 680;
    end
    else if ($test$plusargs("ETH_200G"))
    begin
      phy_word_size = 1360;
    end
    else if ($test$plusargs("ETH_50G"))
    begin
      if ($test$plusargs("ETH_KR_FEC"))
      begin
        phy_word_size = 2640;
      end
      else if ($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
      begin
        phy_word_size = 2720;
      end
      else
      begin
        phy_word_size = 66;
      end
    end
    else if ($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
    begin
      phy_word_size = 1360;
    end
    else
    begin
      phy_word_size = 1320;
    end

    if(tx1_rx0) 
    begin
      if ($test$plusargs("ETH_50G")) begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 4; i++) core_fp_tx[i] =  $fopen($sformatf("core_fec_serial_am_log.tx_channel%0d.out",i), "w");
        end
      end
      else if ($test$plusargs("ETH_200G")) begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 8; i++) core_fp_tx[i] =  $fopen($sformatf("%m.core_fec_serial_am_log.tx_channel%0d.out",i), "w");
        end
      end
      else if ($test$plusargs("ETH_400G")) begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 16; i++) core_fp_tx[i] =  $fopen($sformatf("core_fec_serial_am_log.tx_channel%0d.out",i), "w");
        end
      end
      else begin 
        if(open_cnt == 1)begin
          for (int i = 0; i < 20; i++) core_fp_tx[i] =  $fopen($sformatf("core_fec_serial_am_log.tx_channel%0d.out",i), "w");
        end
      end
    end //if(tx1_rx0)
    else
    begin
      if ($test$plusargs("ETH_50G")) begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 4; i++) core_fp_rx[i] =  $fopen($sformatf("core_fec_serial_am_log.rx_channel%0d.out",i), "w");
        end
      end
      else if ($test$plusargs("ETH_200G")) begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 8; i++) core_fp_rx[i] =  $fopen($sformatf("%m.core_fec_serial_am_log.rx_channel%0d.out",i), "w");
        end
      end
      else if ($test$plusargs("ETH_400G")) begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 16; i++) core_fp_rx[i] =  $fopen($sformatf("core_fec_serial_am_log.rx_channel%0d.out",i), "w");
        end
      end
      else begin
        if(open_cnt == 1)begin
          for (int i = 0; i < 20; i++) core_fp_rx[i] =  $fopen($sformatf("core_fec_serial_am_log.rx_channel%0d.out",i), "w");
        end
      end
    end

    // FOR LL_FEC Word size is half
    if ($test$plusargs("ETH_LL_FEC"))
    begin
      phy_word_size = phy_word_size/2;
    end

    //Initialize timestamp else it prints wrong format for first log
    // Also as we pop-push queue it will underflow
    repeat(phy_word_size) t_stamp.push_back(0);

    //Start processing only when VIP is out of reset
    wait(vip_ready_for_core === 1'b1);

    //In SSDV env as Tag bits reset XCVR gearbox and data will be corrupted on TX,
    //wait for event from testcase which will be triggered post data is stable after first tag
    `ifdef CR3TOP
      wait(core_serial_log_ev === 1'b1);
    `endif

    // Wait for flopped signal to start clock sampling from VIP.
    fork
      wait(snps_clk_10b_flopped  == 1);
      wait(snps_clk_16b_flopped  == 1);
      wait(snps_clk_25x4_flopped == 1);
      wait(snps_clk_kr4_flopped  == 1);
    join_any

    //Wait for number of clocks to offset sampling for each interleaved/Muxed Lane
    //Only applicable when intl_vls>1
    //repeat(vl_num)
    repeat(even_odd_clk+1) //at least 1 clock to sync
    begin
      get_serial_clock(.tx1_rx0(tx1_rx0),
                       .clk_10b(snps_clk_10b_flopped),
                       .clk_16b(snps_clk_16b_flopped),
                       .clk_25X4(snps_clk_25x4_flopped),
                       .clk_kr4(snps_clk_kr4_flopped),
                       .lane_num(phy_num));
    end

    // For every serial clock process data
    // And update the word_320 and also the timestamp. We keep 320 bits of data and 320 corresponding timestamps.
    // On each cycle check for AM. We can implement count based AM checking but this is much simpler.
    // As This is FEC all Phys AM will have same pattern of AM 0 at start and AM16 at end with differntiating AMs in center.
    forever
    begin
      //sample data on negedge
      repeat(intl_vls)
      begin
        get_serial_clock(.tx1_rx0(tx1_rx0),
                         .clk_10b(snps_clk_10b_flopped),
                         .clk_16b(snps_clk_16b_flopped),
                         .clk_25X4(snps_clk_25x4_flopped),
                         .clk_kr4(snps_clk_kr4_flopped),
			 .lane_num(phy_num));
      end

      if($test$plusargs("PAM4_MODE"))
      begin

        phy_word = phy_word >> 1;
        t_stamp.pop_front();
        //debug
        if(tx1_rx0)begin
            tx_phy_word[phy_num][vl_num] = tx_phy_word[phy_num][vl_num] >> 1;
        end else begin
            rx_phy_word[phy_num][vl_num] = rx_phy_word[phy_num][vl_num] >> 1;
        end
        
        // FOR DUT
        // SO_T is lane_0 data while SO_C is ~(lane_0 ^ lane_1)
        //
        // For VIP 
        // tx_lane[0] is (lane_0 ^ lane_1) while tx_lane[1] is lane_1
        //
        // Here as per connections from SSTB, phy_tx_p[1] is SO_T 
        //if (phy_num%2 == 0)
        if (vl_num%2 == 0)
        begin
            //When gray coding enabled
            //phy=0, vl =0 : phy_tx_p[0] ^ phy_tx_p[1]
            //phy=1, vl =0 : phy_tx_p[2] ^ phy_tx_p[3]
            //phy=2, vl =0 : phy_tx_p[4] ^ phy_tx_p[5]
            //phy=3, vl =0 : phy_tx_p[6] ^ phy_tx_p[7]
            //phy=4, vl =0 : phy_tx_p[8] ^ phy_tx_p[9]
            //phy=5, vl =0 : phy_tx_p[10] ^ phy_tx_p[11]
            //phy=6, vl =0 : phy_tx_p[12] ^ phy_tx_p[13]
            //phy=7, vl =0 : phy_tx_p[14] ^ phy_tx_p[15]
            //else just take the value as is:
            //phy=0, vl =0 : phy_tx_p[0]
            //phy=1, vl =0 : phy_tx_p[2]
            //phy=2, vl =0 : phy_tx_p[4]
            //phy=3, vl =0 : phy_tx_p[6]
            //phy=4, vl =0 : phy_tx_p[8]
            //phy=5, vl =0 : phy_tx_p[10]
            //phy=6, vl =0 : phy_tx_p[12]
            //phy=7, vl =0 : phy_tx_p[14]            
            
            //phy_word[phy_word_size -1] = tx1_rx0 ? (phy_tx_p[phy_num*2]) : (phy_rx_p[phy_num*2]);
            phy_word[phy_word_size -1] = tx1_rx0 ? (phy_tx_p[phy_num*2] ^ phy_tx_p[phy_num*2+1]) : (phy_rx_p[phy_num*2] ^ phy_rx_p[phy_num*2+1]);

        end
        else
        begin
            //When gray coding enabled
            //phy=0, vl =1 : phy_tx_p[1]
            //phy=1, vl =1 : phy_tx_p[3]
            //phy=2, vl =1 : phy_tx_p[5]
            //phy=3, vl =1 : phy_tx_p[7]
            //phy=4, vl =1 : phy_tx_p[9]
            //phy=5, vl =1 : phy_tx_p[11]
            //phy=6, vl =1 : phy_tx_p[13]
            //phy=7, vl =1 : phy_tx_p[15]
            //else just take the value as is 
            phy_word[phy_word_size -1] = tx1_rx0 ? phy_tx_p[phy_num*2+1] : phy_rx_p[phy_num*2+1];
        end
        
         //debug
         if(tx1_rx0)begin
            tx_phy_word[phy_num][vl_num][phy_word_size -1] = phy_word[phy_word_size -1];
         end else begin
            rx_phy_word[phy_num][vl_num][phy_word_size -1] = phy_word[phy_word_size -1];
         end          
            
         if(tx1_rx0)begin
            //  $display("DEBUG_PHY_TX_WORD :PAM4 at phy_num = %d at time %t phy_word value is %0h",phy_num, $time,phy_word);
         end
         else begin
            //  $display("DEBUG_PHY_RX_WORD :PAM4 at phy_num = %d  at time %t phy_word value is %0h",phy_num,$time,phy_word);
         end

        t_stamp.push_back($time);
      end
      //NRZ
      else
      begin
        phy_word = phy_word >> 1;
        t_stamp.pop_front();
        phy_word[phy_word_size -1] =  tx1_rx0 ? phy_tx_p[phy_num] : phy_rx_p[phy_num];
        t_stamp.push_back($time);
      end

      bit_cnt++;
      if(bit_cnt == phy_word_size || !am_locked) bit_cnt = 0;

      if (bit_cnt == 0)
      begin
        
        check_core_fec_am_marker(phy_word, phy_num, curr_am, reordered_phy_num);

        // For AMs print to respective file.
        if (curr_am)
        begin

          if (found_once > 0) 
          begin
            am_locked = 1; 
               `uvm_info("core_fec_serial_am_log",$sformatf("am_locked = 1, phy_num=%0d, vl_num=%0d, reordered_phy_num=%0d",phy_num,vl_num,reordered_phy_num), UVM_LOW)
          end
          else
          begin
            found_once ++;
          end

	  if($test$plusargs("ETH_50G"))
	  begin 
	    for (int i = 0; i < 2; i++)//vlane=4
	    begin
		am_t_stamp = t_stamp[64*i];

		stng = $sformatf("\nAM_DETECT # %0d | %t",cnt, am_t_stamp);
                  if (tx1_rx0 ==1 ) begin
                     `uvm_info("core_fec_serial_am_log",$sformatf("writting to tx am log am_locked = 1, phy_num=%0d, vl_num=%0d, reordered_phy_num=%0d",phy_num,vl_num,reordered_phy_num), UVM_LOW)
		    $fwrite(core_fp_tx[reordered_phy_num + 2*i],"%s",stng);//0+0=0,0+2=2,1+0=1,1+2=3
                  end
                  else begin
                     `uvm_info("core_fec_serial_am_log",$sformatf("writting to rx am log am_locked = 1, phy_num=%0d, vl_num=%0d, reordered_phy_num=%0d",phy_num,vl_num,reordered_phy_num), UVM_LOW)
		    $fwrite(core_fp_rx[reordered_phy_num + 2*i],"%s",stng);
                  end
	    end
	  end //ETH_50G
	  else if($test$plusargs("ETH_200G"))
	  begin
	      //for (int i = 0; i < 8; i++)//vlane=8
	      //begin
		  //am_t_stamp = t_stamp[64*i];
		  am_t_stamp = t_stamp[0];
		  stng = $sformatf("\nAM_DETECT # %0d | %t",cnt, am_t_stamp);
		  if (tx1_rx0 == 1)
		    $fwrite(core_fp_tx[reordered_phy_num ],"%s",stng);//0,1,2,3,4,5,6,7
		  else
		    $fwrite(core_fp_rx[reordered_phy_num ],"%s",stng);
	      //end
	  end //ETH_200G    
	  else if($test$plusargs("ETH_400G"))
	  begin
	      //for (int i = 0; i < 16; i++)//vlane=16
	      //begin
		  //am_t_stamp = t_stamp[64*i];
		  am_t_stamp = t_stamp[0];
		  stng = $sformatf("\nAM_DETECT # %0d | %t",cnt, am_t_stamp);
		  if (tx1_rx0 == 1)
		    $fwrite(core_fp_tx[reordered_phy_num ],"%s",stng);//0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
		  else
		    $fwrite(core_fp_rx[reordered_phy_num ],"%s",stng);
	      //end
	  end //ETH_400G    
	  else
	  begin
	    for (int i = 0; i < 5; i++)//vlane=20
	    begin
		am_t_stamp = t_stamp[64*i];
		stng = $sformatf("\nAM_DETECT # %0d | %t",cnt, am_t_stamp);
		if (tx1_rx0 == 1 )
		    $fwrite(core_fp_tx[reordered_phy_num + 4*i],"%s",stng);
		else
		    $fwrite(core_fp_rx[reordered_phy_num + 4*i],"%s",stng);
	    end
	  end
          cnt++;
        end//if(curr_am)

        //DA_TODO:
        if (am_locked)
        begin
          cw_t_stamp[reordered_phy_num].push_back(t_stamp[0]);
          if (tx1_rx0)
          begin
            core_fec_phy_word_tx[reordered_phy_num].push_back(phy_word);
          end
          else
          begin
            core_fec_phy_word_rx[reordered_phy_num].push_back(phy_word);
          end
        end

      end //if (bit_cnt == 0)
    end
  endtask : core_fec_serial_am_log

//------------------------------------------------------------------------------
// Task: check_core_fec_am_marker
// Check if current 1320/1360b is 100G FEC AM 
//
// Parameter(s):
// - phy_word : word collected by core_fec_serial_am_log
// - phy_num  : Phy lane number 
// - curr_am  : returns 1 is current word is AM
// - reordered_phy_num : returns reordered phy number.
//------------------------------------------------------------------------------
function automatic check_core_fec_am_marker(bit [2719:0] phy_word, bit [2:0] phy_num, ref bit curr_am, ref bit [3:0] reordered_phy_num);
   if ($test$plusargs("ETH_400G"))
   begin
      curr_am = 1;
      case(phy_word[119:0])
        120'h0C_8E_FE_26_F3_71_01_D9_D9_B5_65_B6_26_4A_9A : reordered_phy_num = 0; 
        120'h81_21_A5_98_7E_DE_5A_67_D9_B5_65_04_26_4A_9A : reordered_phy_num = 1;
        120'hA9_0C_C1_01_56_F3_3E_FE_D9_B5_65_46_26_4A_9A : reordered_phy_num = 2;
        120'h2F_7F_79_7B_D0_80_86_84_D9_B5_65_5A_26_4A_9A : reordered_phy_num = 3;
        120'h0D_AE_D5_E6_F2_51_2A_19_D9_B5_65_E1_26_4A_9A : reordered_phy_num = 4;
        120'h2E_B0_ED_B1_D1_4F_12_4E_D9_B5_65_F2_26_4A_9A : reordered_phy_num = 5;
        120'h5E_63_BD_11_A1_9C_42_EE_D9_B5_65_3D_26_4A_9A : reordered_phy_num = 6;
        120'hA4_89_29_CD_5B_76_D6_32_D9_B5_65_22_26_4A_9A : reordered_phy_num = 7;
        120'h8A_8C_1E_60_75_73_E1_9F_D9_B5_65_60_26_4A_9A : reordered_phy_num = 8;
        120'hC3_3B_8E_5D_3C_C4_71_A2_D9_B5_65_6B_26_4A_9A : reordered_phy_num = 9;
        120'h27_14_6A_FB_D8_EB_95_04_D9_B5_65_FA_26_4A_9A : reordered_phy_num = 10;
        120'hC7_99_DD_8E_38_66_22_71_D9_B5_65_6C_26_4A_9A : reordered_phy_num = 11;
        120'h6A_09_5D_A4_95_F6_A2_5B_D9_B5_65_18_26_4A_9A : reordered_phy_num = 12;
        120'h3C_68_CE_33_C3_97_31_CC_D9_B5_65_14_26_4A_9A : reordered_phy_num = 13;
        120'h59_04_35_4E_A6_FB_CA_B1_D9_B5_65_D0_26_4A_9A : reordered_phy_num = 14;
        120'h86_45_59_A9_79_BA_A6_56_D9_B5_65_B4_26_4A_9A : reordered_phy_num = 15;
        default : curr_am = 0;
      endcase
   end // if ($test$plusargs("ETH_400G"))
   else if ($test$plusargs("ETH_200G"))
   begin
      curr_am = 1;
      case(phy_word[119:0])
        120'h73_3F_4C_29_8C_C0_B3_D6_D9_B5_65_05_26_4A_9A : reordered_phy_num = 0;
        120'h81_21_A5_98_7E_DE_5A_67_D9_B5_65_04_26_4A_9A : reordered_phy_num = 1;
        120'hA9_0C_C1_01_56_F3_3E_FE_D9_B5_65_46_26_4A_9A : reordered_phy_num = 2;
        120'h2F_7F_79_7B_D0_80_86_84_D9_B5_65_5A_26_4A_9A : reordered_phy_num = 3;
        120'h0D_AE_D5_E6_F2_51_2A_19_D9_B5_65_E1_26_4A_9A : reordered_phy_num = 4;
        120'h2E_B0_ED_B1_D1_4F_12_4E_D9_B5_65_F2_26_4A_9A : reordered_phy_num = 5;
        120'h5E_63_BD_11_A1_9C_42_EE_D9_B5_65_3D_26_4A_9A : reordered_phy_num = 6;
        120'hA4_89_29_CD_5B_76_D6_32_D9_B5_65_22_26_4A_9A : reordered_phy_num = 7;
        default : curr_am = 0;
      endcase
   end // else if ($test$plusargs("ETH_200G"))
   else if ($test$plusargs("ETH_50G"))
   begin
      if ($test$plusargs("ETH_KR_FEC") || $test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
      begin
         if ({phy_word[55:32],   phy_word[23:0]}  == 48'hB8896F_477690 && //VL 0
               {phy_word[119:96],  phy_word[87:64]} == 48'h649A3A_9B65C5)
         begin
            curr_am = 1;
            reordered_phy_num = 0;
         end
         else if ({phy_word[55:32],   phy_word[23:0]}  == 48'hB8896F_477690 && //VL 1
                  {phy_word[119:96],  phy_word[87:64]} == 48'hC2865D_3D79A2)
         begin
            curr_am = 1;
            reordered_phy_num = 1;
         end
         else
         begin
            curr_am = 0;
         end
      end // else if ($test$plusargs("ETH_KR_FEC") || $test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))
      else
      begin
         curr_am = 1;
         case(phy_word[25:2])
            24'h_47_76_90 : reordered_phy_num = 0;
            24'h_E6_C4_F0 : reordered_phy_num = 1;
            24'h_9B_65_C5 : reordered_phy_num = 2;
            24'h_3D_79_A2 : reordered_phy_num = 3;
            default : curr_am = 0;
         endcase
      end 
   end
   else
   begin
      // match for AM pattern. If match, set curr_am and reordered lane number accordingly.
      if ({phy_word[55:32],   phy_word[23:0]}    == 48'hDE973E_2168C1 && //VL 0
          {phy_word[119:96],  phy_word[87:64]}   == 48'hF6F80A_0907F5 && //VL 4
          {phy_word[183:160], phy_word[151:128]} == 48'h89DB5F_7624A0 && //VL 8
          {phy_word[247:224], phy_word[215:192]} == 48'h4D46A3_B2B95C)   //VL 12
      begin
         if(( ($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC"))&& ({phy_word[311:288], phy_word[279:256]} == 48'h482952_B7D6AD))  ||
            ({phy_word[311:288], phy_word[279:256]} == 48'hB3CE3B_4C31C4))   //VL 16
         begin
            curr_am = 1;
            reordered_phy_num = 0;
         end
      end
      else if ({phy_word[55:32],   phy_word[23:0]}    == 48'hDE973E_2168C1 && //VL 1
               {phy_word[119:96],  phy_word[87:64]}   == 48'h3DEB22_C214DD && //VL 5
               {phy_word[183:160], phy_word[151:128]} == 48'h043697_FBC968 && //VL 9
               {phy_word[247:224], phy_word[215:192]} == 48'h4207E5_BDF81A)   //VL 13
      begin
         if((($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC")) && ({phy_word[311:288], phy_word[279:256]} == 48'h482952_B7D6AD))  ||
            ({phy_word[311:288], phy_word[279:256]} == 48'hB3CE3B_4C31C4))   //VL 16
         begin
            curr_am = 1;
            reordered_phy_num = 1;
         end
      end
      else if ({phy_word[55:32],   phy_word[23:0]}    == 48'hDE973E_2168C1 && //VL 2
               {phy_word[119:96],  phy_word[87:64]}   == 48'hD9B565_264A9A && //VL 6
               {phy_word[183:160], phy_word[151:128]} == 48'h669302_996CFD && //VL 10
               {phy_word[247:224], phy_word[215:192]} == 48'h35387C_CAC783)   //VL 14
      begin
         if((($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC")) && ({phy_word[311:288], phy_word[279:256]} == 48'hD599A0_2A665F))  ||
            ({phy_word[311:288], phy_word[279:256]} == 48'hB3CE3B_4C31C4))   //VL 16
         begin
            curr_am = 1;
            reordered_phy_num = 2;
         end
      end
      else if ({phy_word[55:32],   phy_word[23:0]}    == 48'hDE973E_2168C1 && //VL 3
               {phy_word[119:96],  phy_word[87:64]}   == 48'h99BA84_66457B && //VL 7
               {phy_word[183:160], phy_word[151:128]} == 48'hAA6E46_5591B9 && //VL 11
               {phy_word[247:224], phy_word[215:192]} == 48'h32C9CA_CD3635)   //VL 15
      begin
         if((($test$plusargs("ETH_KP_FEC") || $test$plusargs("ETH_LL_FEC")) && ({phy_word[311:288], phy_word[279:256]} == 48'h1A0F3F_E5F0C0))  ||
            ({phy_word[311:288], phy_word[279:256]} == 48'hB3CE3B_4C31C4))   //VL 16
         begin
            curr_am = 1;
            reordered_phy_num = 3;
         end
      end
      else
      begin
         curr_am = 0;
      end
   end
endfunction : check_core_fec_am_marker

//------------------------------------------------------------------------------
// Task: check_am_marker
// Check if current 66b is 100G NOFEC AM 
//
// Parameter(s):
// - word_66b : 66b word collected by core_serial_am_log
// - is_am  : returns 1 is current word is AM
// - v_lane : returns reordered virtual lane number.
//------------------------------------------------------------------------------
  function automatic check_am_marker(bit [65:0] word_66b, ref bit tx, ref bit is_am, ref bit[4:0] v_lane);

    //Assume the word is AM, In default case update to 0 if not.
    is_am  = 1;

   if ($test$plusargs("ETH_50G"))
    begin 
	if(tx == 1) begin
    	`uvm_info("check AM Values",$sformatf("AM values=%h",word_66b ), UVM_LOW)
    	`uvm_info("check AM Values",$sformatf("AM values=%h",word_66b[57:34] ), UVM_LOW)
    	`uvm_info("check AM Values",$sformatf("AM values=%h",word_66b[25:2] ), UVM_LOW)
	end
    		case({word_66b[57:34], word_66b[25:2]})
      		{48'hB8896F_477690} : v_lane = 0;
      		{48'h193B0F_E6C4F0} : v_lane = 1;
      		{48'h649A3A_9b65C5} : v_lane = 2;
      		{48'hC2865D_3D79A2} : v_lane = 3;
      		default : is_am = 0;
    		endcase
   end	   //ETH_50G
   else    //ETH_50G
    begin
    case({word_66b[57:34], word_66b[25:2]})
      {48'hDE973E_2168C1} : v_lane = 0;
      {48'h718E62_8E719D} : v_lane = 1;
      {48'h17B4A6_E84B59} : v_lane = 2;
      {48'h846AB2_7B954D} : v_lane = 3;
      {48'hF6F80A_0907F5} : v_lane = 4;
      {48'h3DEB22_C214DD} : v_lane = 5;
      {48'hD9B565_264A9A} : v_lane = 6;
      {48'h99BA84_66457B} : v_lane = 7;
      {48'h89DB5F_7624A0} : v_lane = 8;
      {48'h043697_FBC968} : v_lane = 9;
      {48'h669302_996CFD} : v_lane = 10;
      {48'hAA6E46_5591B9} : v_lane = 11;
      {48'h4D46A3_B2B95C} : v_lane = 12;
      {48'h4207E5_BDF81A} : v_lane = 13;
      {48'h35387C_CAC783} : v_lane = 14;
      {48'h32C9CA_CD3635} : v_lane = 15;
      {48'hB3CE3B_4C31C4} : v_lane = 16;
      {48'h482952_B7D6AD} : v_lane = 17;
      {48'hD599A0_2A665F} : v_lane = 18;
      {48'h1A0F3F_E5F0C0} : v_lane = 19;
      default : is_am = 0;
    endcase
   end

  endfunction : check_am_marker


//------------------------------------------------------------------------------
// Task: rsfec_transdecoder
// RSFEC 257b->264b transdecoder based on CL91 sec 91.5.3.5 steps 
//
// Parameter(s):
// - rsfec_cw : 257b Transcoded word 
// - m_prev_rx_coded_3  :  transdecoded PCS words 3.
// - rx_coded : 4 66bits transdecoded PCS words.
//------------------------------------------------------------------------------
  function automatic void rsfec_transdecoder(bit [256:0] rsfec_cw, ref bit [65:0] m_prev_rx_coded_3, ref bit [65:0] rx_coded[4]);

    int c;
    bit [256:0] rx_scrambled;
    bit [256:0] rx_xcoded;
    bit [255:0] rx_payloads;
    bit [3:0] f_c;
    bit [3:0] g;
    bit [3:0] h;
    bit [3:0] s_c;
    int m;
    rx_scrambled = rsfec_cw;

    if ($test$plusargs("ETH_400G") || $test$plusargs("ETH_200G"))
    begin
      rx_xcoded = rsfec_cw;
    end
    else
    begin
      rx_scrambled = rsfec_cw;

      //Form rx_xcoded
      rx_xcoded[4:0] = rx_scrambled[4:0] ^ rx_scrambled[12:8];
      rx_xcoded[256:5] = rx_scrambled[256:5];
    end

    //If rx_xcoded<0> is 1, ...
    if (rx_xcoded[0] == 1)
    begin
      for (int j = 0; j < 4;j++)
      begin
        rx_coded[j][65:2] = rx_xcoded[(64*j + 1) +: 64]; //Eqv to  rx_coded[j][65:2] = rx_xcoded[(64*j+64):(64*j+1)]
        rx_coded[j][1:0] = 2'b10;
      end
    end //if (rx_xcoded[0] == 1)

    //If rx_xcoded<0> and rx_xcoded<j+1>=0 for j=0 to 3 ...
    else if (rx_xcoded[0] == 0 && (rx_xcoded[4:1] != 4'b1111))
    begin
      if ($test$plusargs("ETH_400G") || $test$plusargs("ETH_200G"))
      begin
         //Step A1
        casex(rx_xcoded[4:1])
          4'b???0 : c = 0;
          4'b??01 : c = 1;
          4'b?011 : c = 2;
          4'b0111 : c = 3;
        endcase 
        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | c=%d", c);

        //Step B1
        for (int k=0; k <= 64*c+3; k++)
        begin
          rx_payloads[k] = rx_xcoded[5+k];
        end

        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_payloads=%d", rx_payloads);

        g = rx_payloads[(64*c) +: 4];

        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | g=%d", g);

        case(g)
          4'hE : h = 4'h1;
          4'h8 : h = 4'h7;
          4'hB : h = 4'h4;
          4'h7 : h = 4'h8;
          4'h9 : h = 4'h9;
          4'hA : h = 4'hA;
          4'h4 : h = 4'hB;
          4'hC : h = 4'hC;
          4'h2 : h = 4'hD;
          4'h1 : h = 4'hE;
          4'hF : h = 4'hF;
          default : h = 4'h0;
        endcase

        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | h=%d", h);
        
        rx_payloads[(64*c+4) +: 4] = h;
        
        for (int k=64*c+8 ; k<256; k++)
        begin
          rx_payloads[k] = rx_xcoded[k+1];
        end

        //Step C1
        for (int j=0; j<4; j++)
        begin
          rx_coded[j][65:2] = rx_payloads[64*j +: 64];
        end
        
        //Step D1-E1
        for (int j=0; j<4; j++)
        begin
          if (rx_xcoded[j+1] == 0)
          begin
            rx_coded[j][1:0] = 2'b01;
          end
          else
          begin
            rx_coded[j][1:0] = 2'b10;
          end
        end

        //Step F1
        if(h == 0)
        begin
          rx_coded[c][1] = 1'b1;
        end
        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_coded[0]=%h", rx_coded[0]);
        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_coded[1]=%h", rx_coded[1]);
        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_coded[2]=%h", rx_coded[2]);
        if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_coded[3]=%h", rx_coded[3]);
      end
      else
      begin
        //Step A
        casex(rx_xcoded[4:1])
          4'b???0 : c = 0;
          4'b??01 : c = 1;
          4'b?011 : c = 2;
          4'b0111 : c = 3;
        endcase

        //Step B
        for (int k=0; k<=64*c+3; k++)
        begin
          rx_payloads[k] = rx_xcoded[5+k];
        end

        rx_payloads[(64*c+4) +: 4] = 4'b0000;

        for (int k=64*c+8 ; k<256; k++)
        begin
          rx_payloads[k] = rx_xcoded[k+1];
        end

        //Step C
        for (int j=0; j<4; j++)
        begin
          rx_coded[j][65:2] = rx_payloads[64*j +: 64];
        end

        //Step D
        f_c = rx_coded[c][5:2];

        //Step E
        if (c == 0)
        begin
          for (int k = 0; k<4; k++)
          begin
            g[k] = f_c[k] ^ m_prev_rx_coded_3[k+8] ^ m_prev_rx_coded_3[k+27];
          end
        end
        else
        begin
          for (int k = 0; k<4; k++)
          begin
            g[k] = f_c[k] ^ rx_coded[c-1][k+8] ^ rx_coded[c-1][k+27];
          end
        end

        //Step F
        case(g)
          4'hE : h = 4'h1;
          4'h8 : h = 4'h7;
          4'hB : h = 4'h4;
          4'h7 : h = 4'h8;
          4'h9 : h = 4'h9;
          4'hA : h = 4'hA;
          4'h4 : h = 4'hB;
          4'hC : h = 4'hC;
          4'h2 : h = 4'hD;
          4'h1 : h = 4'hE;
          4'hF : h = 4'hF;
          default :
          begin
            if($test$plusargs("elane_fec_mode"))
            begin
              case(g)
                4'h3 : h = 4'h3;
                4'hD : h = 4'h2;
                4'h6 : h = 4'h6;
                4'h5 : h = 4'h5;
                default : h = 4'h0;
              endcase
            end
            else
            begin
              h = 4'h0;
            end
          end
        endcase

        //Step G and H
        for (int j=0; j<4; j++)
        begin
          if (rx_xcoded[j+1] == 0)
          begin
            rx_coded[j][1:0] = 2'b01;
          end
          else
          begin
            rx_coded[j][1:0] = 2'b10;
          end
        end

        //Step I
        if (h == 0)
        begin
          rx_coded[c][1] = 1;
        end
      end
    end //else if (rx_xcoded[0] == 0 && (rx_xcoded[4:1] ^ 4'b1111 != 4'b1111))

    // If rx_xcoded<0> is 0 and all rx_xcoded<j+1>=1 for j=0 to 3.
    else if (rx_xcoded[0] == 0 && (rx_xcoded[4:1] == 4'b1111))
    begin
      //Step A
      c = 0;
      h = 0;

      //Step B
      for (int k=0; k< 64*c+3; k++)
      begin
        rx_payloads[k] = rx_xcoded[5+k];
      end

      rx_payloads[(64*c+4) +: 4] = 4'b0000;

      for (int k=64*c+8 ; k<264; k++)
      begin
        rx_payloads[k] = rx_xcoded[k+1];
      end

      //Step C
      for (int j=0; j<4; j++)
      begin
        rx_coded[j][65:2] = rx_payloads[64*j +: 64];
      end

      //Step D
      rx_coded[0][1:0] = 2'b00;
      rx_coded[2][1:0] = 2'b00;

      //Step E
      rx_coded[1][1:0] = 2'b11;
      rx_coded[3][1:0] = 2'b11;
    end //else if (rx_xcoded[0] == 0 && (rx_xcoded[4:1] ^ 4'b1111 == 4'b0000))

    if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_coded[3]=%h", rx_coded[3]);

    if (!($test$plusargs("ETH_400G") || $test$plusargs("ETH_200G")))
    begin
      // If rx_coded[0] is 0,  scramble ...
      if (rx_xcoded[0] == 0)
      begin
        if (c == 0)
        begin
          for (int k=0; k<4; k++)
          begin
            s_c[k] = h[k] ^ m_prev_rx_coded_3[k+12] ^ m_prev_rx_coded_3[k+31];
          end
        end
        else
        begin
          for (int k=0; k<4; k++)
          begin
            s_c[k] = h[k] ^ rx_coded[c-1][k+12] ^ rx_coded[c-1][k+31];
          end
        end
        rx_coded[c][9:6] = s_c[3:0];
      end //if (rx_xcoded[0] == 0)
    end

    m_prev_rx_coded_3 = rx_coded[3];
    if(rx_xcoded == 257'h000000000ca563e8c8706e6c6a68666462605e5c5a58565452504e4c4a484644e) $display("DA_DBG_XCODE | rx_coded[3]=%h", rx_coded[3]);

  endfunction : rsfec_transdecoder


//------------------------------------------------------------------------------
// Task: rs_multiply
// RSFEC Parity calculator supporting function. Based on Cl91 appendix 
//------------------------------------------------------------------------------
  function automatic int rs_multiply(int aa, int bb);
    int expand = 0;

    for (int k = 0; k < 10; k++)
    begin
      if (bb & (1 << k))
        expand = expand ^ (aa << k);
    end

    for (int k = 0; k < 9; k++)
    begin
      if ((expand >> (18-k)) & 1)
        expand = expand ^ (polynomial << (8-k));
    end

    rs_multiply = expand;

  endfunction : rs_multiply

//------------------------------------------------------------------------------
// Task: rs_encode
// RSFEC Parity calculator function. Based on Cl91 appendix 
//------------------------------------------------------------------------------
  function automatic void rs_encode();
    int multiplier;
    int generator_vector[30];
    int encoder_divide[30];

    for (int k = 0; k < check_symbols; k++)
      encoder_divide[k] = 0;

    for (int k = 0; k < k_symbols; k++)
    begin
      multiplier = rsfec_codeword[k] ^ encoder_divide[0];

      for (int j = 0; j < check_symbols; j++)
        generator_vector[j] = rs_multiply(multiplier, generator_polynomial[j]);

      for (int j = 0; j < check_symbols - 1; j++)
        encoder_divide[j] = generator_vector[j] ^ encoder_divide[j+1];

      encoder_divide[check_symbols - 1] = generator_vector[check_symbols - 1];

      for (int j = 0; j < check_symbols; j++)
        rsfec_codeword[j + k_symbols] = encoder_divide[j];
    end

  endfunction : rs_encode

//------------------------------------------------------------------------------
// Task: check_rsfec_parity
// RSFEC Parity calculator function. Based on Cl91 appendix 
//------------------------------------------------------------------------------
  function automatic check_rsfec_parity(bit [5439:0] inp_rsfec_word, bit tx1_rx0);

    bit [299:0] calculated_parity;
    bit [299:0] recieved_parity;

    if ($test$plusargs("ETH_LL_FEC"))
    begin
      recieved_parity = inp_rsfec_word[2719:2580];
    end
    else
    begin
      recieved_parity = inp_rsfec_word[5439:5140];
    end

    for (int i = 0; i < k_symbols; i++)
    begin
      rsfec_codeword[i] =  inp_rsfec_word[i*10 +: 10];
    end

    rs_encode();

    ///Get calculated parity from rsfec_codeword
    for (int i = 0; i < check_symbols; i++)
    begin
      for(int k = 0; k < 10; k++)
      begin
         calculated_parity[i*10 + k] = rsfec_codeword[k_symbols + i][k];
      end
    end

    if (recieved_parity != calculated_parity)
    begin
      `uvm_warning("check_rsfec_parity",$sformatf("TX1_RX0=%0d | RSFEC calculated parity doesn't matches with recieved parity. Received=%h | Calculated=%h",tx1_rx0, inp_rsfec_word[5439:5139], calculated_parity))
    end
    else
    begin
//       `uvm_info("check_rsfec_parity",$sformatf("TX1_RX0=%0d | RSFEC calculated parity matches with recieved parity. Calculated=%h",tx1_rx0, calculated_parity), UVM_LOW)
    end

  endfunction : check_rsfec_parity

//------------------------------------------------------------------------------
// Task: pcs_descrambler
// PCS Descrambler 
//------------------------------------------------------------------------------
  function bit [256:0] pcs_descrambler(bit[256:0] tx_scrambled_257b, ref bit[57:0] m_rx_descrambler_reg);
    bit scr_bit;
    bit[57:0] m_rx_descrambler_reg_local;
    m_rx_descrambler_reg_local = m_rx_descrambler_reg;
    for (int i=0; i <257; i++)
    begin
      scr_bit = tx_scrambled_257b[i];
      tx_scrambled_257b[i] = tx_scrambled_257b[i] ^ m_rx_descrambler_reg_local[38] ^ m_rx_descrambler_reg_local[57];
      m_rx_descrambler_reg_local[57:0] = {m_rx_descrambler_reg_local[56:0],  scr_bit};
    end
    m_rx_descrambler_reg = m_rx_descrambler_reg_local;
    pcs_descrambler = tx_scrambled_257b;
  endfunction

//------------------------------------------------------------------------------
// Task: get_serial_clock
//------------------------------------------------------------------------------
  task automatic get_serial_clock(bit tx1_rx0, bit clk_10b, bit clk_16b, bit clk_25X4, bit clk_kr4, bit [2:0] lane_num = 0);
    if(clk_10b)
    begin
      if (tx1_rx0) @(negedge snps_tx_10b_clk[lane_num]);
      else         @(negedge snps_rx_cdr_10b_clk[lane_num]);
    end
    else if (clk_16b)
    begin
      if (tx1_rx0) @(negedge snps_tx_16b_clk[lane_num]);
      else         @(negedge snps_rx_cdr_16b_clk[lane_num]);
    end
    else if (clk_25X4)
    begin
      if (tx1_rx0) @(negedge snps_tx_25x4_clk[lane_num]);
      else         @(negedge snps_rx_cdr_25x4_clk[lane_num]);
    end
    else if (clk_kr4)
    begin
      if (tx1_rx0) @(negedge snps_tx_kr4_clk[lane_num]);
      else         @(negedge snps_rx_cdr_kr4_clk[lane_num]);
    end
  endtask

//------------------------------------------------------------------------------
// Task: firefec_serial_log
//
// Parameter(s):
// - tx1_rx0  : Direction for monitor Tx=1 Rx=0 
// - ch_num   : Elane Channel number.
//------------------------------------------------------------------------------
  task automatic firefec_serial_log(bit tx1_rx0, bit [1:0] ch_num);
    
    bit [11:0] cnt;
    bit [2111:0] word_2112b;
    bit [65:0] word_66b;
    bit parity_match; 
    bit cw_lock; 
    realtime t_stamp;
    realtime t_ui;
    string stng;

    //Initialize timestamp else it prints wrong format for first log
    t_stamp = 0;
    t_ui = 0.038788ns;

    // Wait for VIP reset to deassert.
    wait(vip_ready_for_lane[ch_num] === 1'b1);

    // Open file pointer and Wait for posedge on serial line.
    if (tx1_rx0)
    begin
      if(open_cnt == 1)begin
        case(ch_num)
          0: fp_tx_ch0 = $fopen($sformatf("%m.tx_channel0.out"), "w");
          1: fp_tx_ch1 = $fopen($sformatf("%m.tx_channel1.out"), "w");
          2: fp_tx_ch2 = $fopen($sformatf("%m.tx_channel2.out"), "w");
          3: fp_tx_ch3 = $fopen($sformatf("%m.tx_channel3.out"), "w");
        endcase
      end
      wait(phy_tx_p[ch_num] === 1'b1);
    end
    else
    begin
      if(open_cnt == 1)begin
        case(ch_num)
          0: fp_rx_ch0 = $fopen($sformatf("%m.rx_channel0.out"), "w");
          1: fp_rx_ch1 = $fopen($sformatf("%m.rx_channel1.out"), "w");
          2: fp_rx_ch2 = $fopen($sformatf("%m.rx_channel2.out"), "w");
          3: fp_rx_ch3 = $fopen($sformatf("%m.rx_channel3.out"), "w");
        endcase
      end
      wait(phy_rx_p[ch_num] === 1'b1);
    end
      // In CR3TOP SS, the Serdes Model injects jitter so we use VIP CDR for serial line clk.
      // At EHIP IP level CDR is not needed, so appropriate clocks are used for sampling.
      //
      // We are sampling at negedge on serial as VIP drives at posedge.
      forever
      begin
        //sample data on negedge
        get_serial_clock(.tx1_rx0(tx1_rx0),
                         .clk_10b(snps_clk_10b_flopped), 
                         .clk_16b(snps_clk_16b_flopped), 
                         .clk_25X4(snps_clk_25x4_flopped), 
                         .clk_kr4(snps_clk_kr4_flopped),
                         .lane_num(ch_num));

        if (!cw_lock)
        begin
          if (parity_match  == 0)
          begin
            word_2112b = word_2112b >> 1;
            word_2112b[2111] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];
            if (firefec_decode_2112b(word_2112b) == 1) 
            begin
              parity_match = 1;
            end
          end
          else
          begin
            if (cnt == 0) t_stamp = $realtime;
            cnt ++;
            word_2112b = word_2112b >> 1;
            word_2112b[2111] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];

            if (cnt == 2112)
            begin
              cnt = 0;
              if (firefec_decode_2112b(word_2112b) == 1) 
              begin
                cw_lock = 1;
              end
              else
              begin
                parity_match = 0;
              end
            end
          end
        end
        else
        begin
          word_2112b[cnt] =  tx1_rx0 ? phy_tx_p[ch_num] : phy_rx_p[ch_num];
          cnt ++;
          if (cnt == 0) t_stamp = $realtime;
          else if (cnt == 2112)
          begin
            cnt = 0;
          end
        end

        if (cnt == 0 && cw_lock == 1)
        begin

     
          if (firefec_decode_2112b(word_2112b) == 0) 
          begin
            `uvm_warning("firefec_serial_log",$sformatf("TX1_RX0=%0d | Lane=%0d | FIREFEC parity mismatch post cw_lock.",tx1_rx0, ch_num))
          end   

          word_2112b ^= `ETH_FEC_SCRAMBLER_2112;

          for (int i = 0; i < 32; i++)
          begin
            word_66b[65:1] = word_2112b[65*i +: 65];
            word_66b[1] =  word_66b[1] ^ word_66b[10];
            word_66b[0] = ~ word_66b[1];

            stng = $sformatf("\n%t | 66'h%66h | 64'h%64h | 2'b%2b",(t_stamp + 66*i*t_ui), word_66b, word_66b[65:2], word_66b[1:0]);
            case(ch_num)
              0:
              begin
                if (tx1_rx0 == 1)
                  $fwrite(fp_tx_ch0,"%s",stng);
                else
                  $fwrite(fp_rx_ch0,"%s",stng);
              end
              1:
              begin
                if (tx1_rx0 == 1)
                  $fwrite(fp_tx_ch1,"%s",stng);
                else
                  $fwrite(fp_rx_ch1,"%s",stng);
              end
              2:
              begin
                if (tx1_rx0 == 1)
                  $fwrite(fp_tx_ch2,"%s",stng);
                else
                  $fwrite(fp_rx_ch2,"%s",stng);
              end
              3:
              begin
                if (tx1_rx0 == 1)
                  $fwrite(fp_tx_ch3,"%s",stng);
                else
                  $fwrite(fp_rx_ch3,"%s",stng);
              end
            endcase
          end
        end
      end //forever

  endtask : firefec_serial_log
//------------------------------------------------------------------------------
// Task: firefec_decode_2112b
// FIREFEC(2112,2080) decoder
//------------------------------------------------------------------------------
  function automatic bit firefec_decode_2112b(bit [2111:0] data);
    
    bit [31:0] m_fec_parity = 0;

    data ^= `ETH_FEC_SCRAMBLER_2112;

    for (int i = 0; i < 32; i++)
    begin
      firefec_calc_parity(data[65*i +: 65], m_fec_parity);
    end

    firefec_decode_2112b = (m_fec_parity == data[2111:2080]) ? 1 : 0;

  endfunction : firefec_decode_2112b


//------------------------------------------------------------------------------
// Task: firefec_calc_parity
// FIREFEC(2112,2080) parity calculator
//------------------------------------------------------------------------------
  function automatic firefec_calc_parity(bit [64:0] d, ref  bit [31:0] m_fec_parity);
    bit [31:0] p;
   
    p = m_fec_parity;
   
    m_fec_parity[0] = d[10]^d[13]^d[14]^d[15]^d[17]^d[18]^d[1]^d[20]^d[21]^d[22]^
                      d[23]^d[26]^d[29]^d[32]^d[33]^d[34]^d[35]^d[36]^d[38]^d[3]^
                      d[43]^d[44]^d[47]^d[54]^d[56]^d[5]^d[7]^d[8]^p[10]^p[13]^
                      p[14]^p[15]^p[17]^p[18]^p[1]^p[20]^p[21]^p[22]^p[23]^p[26]^
                      p[29]^p[3]^p[5]^p[7]^p[8];
    m_fec_parity[1] = d[11]^d[14]^d[15]^d[16]^d[18]^d[19]^d[21]^d[22]^d[23]^
                      d[24]^d[27]^d[2]^d[30]^d[33]^d[34]^d[35]^d[36]^d[37]^d[39]^
                      d[44]^d[45]^d[48]^d[4]^d[55]^d[57]^d[6]^d[8]^d[9]^p[11]^
                      p[14]^p[15]^p[16]^p[18]^p[19]^p[21]^p[22]^p[23]^p[24]^
                      p[27]^p[2]^p[30]^p[4]^p[6]^p[8]^p[9];
    m_fec_parity[2] = d[0]^d[10]^d[12]^d[15]^d[16]^d[17]^d[19]^d[20]^d[22]^d[23]^
                      d[24]^d[25]^d[28]^d[31]^d[34]^d[35]^d[36]^d[37]^d[38]^d[3]^
                      d[40]^d[45]^d[46]^d[49]^d[56]^d[58]^d[5]^d[7]^d[9]^p[0]^
                      p[10]^p[12]^p[15]^p[16]^p[17]^p[19]^p[20]^p[22]^p[23]^
                      p[24]^p[25]^p[28]^p[31]^p[3]^p[5]^p[7]^p[9];
    m_fec_parity[3] = d[0]^d[10]^d[11]^d[13]^d[16]^d[17]^d[18]^d[1]^d[20]^d[21]^
                      d[23]^d[24]^d[25]^d[26]^d[29]^d[32]^d[35]^d[36]^d[37]^
                      d[38]^d[39]^d[41]^d[46]^d[47]^d[4]^d[50]^d[57]^d[59]^d[6]^
                      d[8]^p[0]^p[10]^p[11]^p[13]^p[16]^p[17]^p[18]^p[1]^p[20]^
                      p[21]^p[23]^p[24]^p[25]^p[26]^p[29]^p[4]^p[6]^p[8];
    m_fec_parity[4] = d[11]^d[12]^d[14]^d[17]^d[18]^d[19]^d[1]^d[21]^d[22]^d[24]^
                      d[25]^d[26]^d[27]^d[2]^d[30]^d[33]^d[36]^d[37]^d[38]^d[39]^
                      d[40]^d[42]^d[47]^d[48]^d[51]^d[58]^d[5]^d[60]^d[7]^d[9]^
                      p[11]^p[12]^p[14]^p[17]^p[18]^p[19]^p[1]^p[21]^p[22]^p[24]^
                      p[25]^p[26]^p[27]^p[2]^p[30]^p[5]^p[7]^p[9];
    m_fec_parity[5] = d[10]^d[12]^d[13]^d[15]^d[18]^d[19]^d[20]^d[22]^d[23]^
                      d[25]^d[26]^d[27]^d[28]^d[2]^d[31]^d[34]^d[37]^d[38]^d[39]^
                      d[3]^d[40]^d[41]^d[43]^d[48]^d[49]^d[52]^d[59]^d[61]^d[6]^
                      d[8]^p[10]^p[12]^p[13]^p[15]^p[18]^p[19]^p[20]^p[22]^p[23]^
                      p[25]^p[26]^p[27]^p[28]^p[2]^p[31]^p[3]^p[6]^p[8];
    m_fec_parity[6] = d[11]^d[13]^d[14]^d[16]^d[19]^d[20]^d[21]^d[23]^d[24]^
                      d[26]^d[27]^d[28]^d[29]^d[32]^d[35]^d[38]^d[39]^d[3]^d[40]^
                      d[41]^d[42]^d[44]^d[49]^d[4]^d[50]^d[53]^d[60]^d[62]^d[7]^
                      d[9]^p[11]^p[13]^p[14]^p[16]^p[19]^p[20]^p[21]^p[23]^p[24]^
                      p[26]^p[27]^p[28]^p[29]^p[3]^p[4]^p[7]^p[9];
    m_fec_parity[7] = d[10]^d[12]^d[14]^d[15]^d[17]^d[20]^d[21]^d[22]^d[24]^
                      d[25]^d[27]^d[28]^d[29]^d[30]^d[33]^d[36]^d[39]^d[40]^
                      d[41]^d[42]^d[43]^d[45]^d[4]^d[50]^d[51]^d[54]^d[5]^d[61]^
                      d[63]^d[8]^p[10]^p[12]^p[14]^p[15]^p[17]^p[20]^p[21]^p[22]^
                      p[24]^p[25]^p[27]^p[28]^p[29]^p[30]^p[4]^p[5]^p[8];
    m_fec_parity[8] = d[11]^d[13]^d[15]^d[16]^d[18]^d[21]^d[22]^d[23]^d[25]^
                      d[26]^d[28]^d[29]^d[30]^d[31]^d[34]^d[37]^d[40]^d[41]^
                      d[42]^d[43]^d[44]^d[46]^d[51]^d[52]^d[55]^d[5]^d[62]^d[64]^
                      d[6]^d[9]^p[11]^p[13]^p[15]^p[16]^p[18]^p[21]^p[22]^p[23]^
                      p[25]^p[26]^p[28]^p[29]^p[30]^p[31]^p[5]^p[6]^p[9];
    m_fec_parity[9] = d[12]^d[13]^d[15]^d[16]^d[18]^d[19]^d[1]^d[20]^d[21]^d[24]^
                      d[27]^d[30]^d[31]^d[33]^d[34]^d[36]^d[3]^d[41]^d[42]^d[45]^
                      d[52]^d[53]^d[54]^d[5]^d[63]^d[6]^d[8]^p[12]^p[13]^p[15]^
                      p[16]^p[18]^p[19]^p[1]^p[20]^p[21]^p[24]^p[27]^p[30]^p[31]^
                      p[3]^p[5]^p[6]^p[8];
    m_fec_parity[10] = d[0]^d[13]^d[14]^d[16]^d[17]^d[19]^d[20]^d[21]^d[22]^
                       d[25]^d[28]^d[2]^d[31]^d[32]^d[34]^d[35]^d[37]^d[42]^
                       d[43]^d[46]^d[4]^d[53]^d[54]^d[55]^d[64]^d[6]^d[7]^d[9]^
                       p[0]^p[13]^p[14]^p[16]^p[17]^p[19]^p[20]^p[21]^p[22]^p[25]^
                       p[28]^p[2]^p[31]^p[4]^p[6]^p[7]^p[9];
    m_fec_parity[11] = d[13]^d[34]^d[55]^p[13];
    m_fec_parity[12] = d[14]^d[35]^d[56]^p[14];
    m_fec_parity[13] = d[15]^d[36]^d[57]^p[15];
    m_fec_parity[14] = d[16]^d[37]^d[58]^p[16];
    m_fec_parity[15] = d[17]^d[38]^d[59]^p[17];
    m_fec_parity[16] = d[18]^d[39]^d[60]^p[18];
    m_fec_parity[17] = d[19]^d[40]^d[61]^p[19];
    m_fec_parity[18] = d[20]^d[41]^d[62]^p[20];
    m_fec_parity[19] = d[0]^d[21]^d[42]^d[63]^p[0]^p[21];
    m_fec_parity[20] = d[1]^d[22]^d[43]^d[64]^p[1]^p[22];
    m_fec_parity[21] = d[10]^d[13]^d[14]^d[15]^d[17]^d[18]^d[1]^d[20]^d[21]^
                       d[22]^d[26]^d[29]^d[2]^d[32]^d[33]^d[34]^d[35]^d[36]^
                       d[38]^d[3]^d[43]^d[47]^d[54]^d[56]^d[5]^d[7]^d[8]^p[10]^
                       p[13]^p[14]^p[15]^p[17]^p[18]^p[1]^p[20]^p[21]^p[22]^
                       p[26]^p[29]^p[2]^p[3]^p[5]^p[7]^p[8];
    m_fec_parity[22] = d[11]^d[14]^d[15]^d[16]^d[18]^d[19]^d[21]^d[22]^d[23]^
                       d[27]^d[2]^d[30]^d[33]^d[34]^d[35]^d[36]^d[37]^d[39]^d[3]^
                       d[44]^d[48]^d[4]^d[55]^d[57]^d[6]^d[8]^d[9]^p[11]^p[14]^
                       p[15]^p[16]^p[18]^p[19]^p[21]^p[22]^p[23]^p[27]^p[2]^
                       p[30]^p[3]^p[4]^p[6]^p[8]^p[9];
    m_fec_parity[23] = d[0]^d[10]^d[12]^d[15]^d[16]^d[17]^d[19]^d[20]^d[22]^
                       d[23]^d[24]^d[28]^d[31]^d[34]^d[35]^d[36]^d[37]^d[38]^
                       d[3]^d[40]^d[45]^d[49]^d[4]^d[56]^d[58]^d[5]^d[7]^d[9]^
                       p[0]^p[10]^p[12]^p[15]^p[16]^p[17]^p[19]^p[20]^p[22]^
                       p[23]^p[24]^p[28]^p[31]^p[3]^p[4]^p[5]^p[7]^p[9];
    m_fec_parity[24] = d[0]^d[10]^d[11]^d[13]^d[16]^d[17]^d[18]^d[1]^d[20]^
                       d[21]^d[23]^d[24]^d[25]^d[29]^d[32]^d[35]^d[36]^d[37]^
                       d[38]^d[39]^d[41]^d[46]^d[4]^d[50]^d[57]^d[59]^d[5]^d[6]^
                       d[8]^p[0]^p[10]^p[11]^p[13]^p[16]^p[17]^p[18]^p[1]^p[20]^
                       p[21]^p[23]^p[24]^p[25]^p[29]^p[4]^p[5]^p[6]^p[8];
    m_fec_parity[25] = d[11]^d[12]^d[14]^d[17]^d[18]^d[19]^d[1]^d[21]^d[22]^
                       d[24]^d[25]^d[26]^d[2]^d[30]^d[33]^d[36]^d[37]^d[38]^
                       d[39]^d[40]^d[42]^d[47]^d[51]^d[58]^d[5]^d[60]^d[6]^d[7]^
                       d[9]^p[11]^p[12]^p[14]^p[17]^p[18]^p[19]^p[1]^p[21]^p[22]^
                       p[24]^p[25]^p[26]^p[2]^p[30]^p[5]^p[6]^p[7]^p[9];
    m_fec_parity[26] = d[10]^d[12]^d[13]^d[15]^d[18]^d[19]^d[20]^d[22]^d[23]^
                       d[25]^d[26]^d[27]^d[2]^d[31]^d[34]^d[37]^d[38]^d[39]^d[3]^
                       d[40]^d[41]^d[43]^d[48]^d[52]^d[59]^d[61]^d[6]^d[7]^d[8]^
                       p[10]^p[12]^p[13]^p[15]^p[18]^p[19]^p[20]^p[22]^p[23]^
                       p[25]^p[26]^p[27]^p[2]^p[31]^p[3]^p[6]^p[7]^p[8];
    m_fec_parity[27] = d[11]^d[13]^d[14]^d[16]^d[19]^d[20]^d[21]^d[23]^d[24]^
                       d[26]^d[27]^d[28]^d[32]^d[35]^d[38]^d[39]^d[3]^d[40]^
                       d[41]^d[42]^d[44]^d[49]^d[4]^d[53]^d[60]^d[62]^d[7]^d[8]^
                       d[9]^p[11]^p[13]^p[14]^p[16]^p[19]^p[20]^p[21]^p[23]^
                       p[24]^p[26]^p[27]^p[28]^p[3]^p[4]^p[7]^p[8]^p[9];
    m_fec_parity[28] = d[10]^d[12]^d[14]^d[15]^d[17]^d[20]^d[21]^d[22]^d[24]^
                       d[25]^d[27]^d[28]^d[29]^d[33]^d[36]^d[39]^d[40]^d[41]^
                       d[42]^d[43]^d[45]^d[4]^d[50]^d[54]^d[5]^d[61]^d[63]^d[8]^
                       d[9]^p[10]^p[12]^p[14]^p[15]^p[17]^p[20]^p[21]^p[22]^p[24]^
                       p[25]^p[27]^p[28]^p[29]^p[4]^p[5]^p[8]^p[9];
    m_fec_parity[29] = d[10]^d[11]^d[13]^d[15]^d[16]^d[18]^d[21]^d[22]^d[23]^
                       d[25]^d[26]^d[28]^d[29]^d[30]^d[34]^d[37]^d[40]^d[41]^
                       d[42]^d[43]^d[44]^d[46]^d[51]^d[55]^d[5]^d[62]^d[64]^d[6]^
                       d[9]^p[10]^p[11]^p[13]^p[15]^p[16]^p[18]^p[21]^p[22]^
                       p[23]^p[25]^p[26]^p[28]^p[29]^p[30]^p[5]^p[6]^p[9];
    m_fec_parity[30] = d[11]^d[12]^d[13]^d[15]^d[16]^d[18]^d[19]^d[1]^d[20]^
                       d[21]^d[24]^d[27]^d[30]^d[31]^d[32]^d[33]^d[34]^d[36]^
                       d[3]^d[41]^d[42]^d[45]^d[52]^d[54]^d[5]^d[63]^d[6]^d[8]^
                       p[11]^p[12]^p[13]^p[15]^p[16]^p[18]^p[19]^p[1]^p[20]^
                       p[21]^p[24]^p[27]^p[30]^p[31]^p[3]^p[5]^p[6]^p[8];
    m_fec_parity[31] = d[0]^d[12]^d[13]^d[14]^d[16]^d[17]^d[19]^d[20]^d[21]^
                       d[22]^d[25]^d[28]^d[2]^d[31]^d[32]^d[33]^d[34]^d[35]^
                       d[37]^d[42]^d[43]^d[46]^d[4]^d[53]^d[55]^d[64]^d[6]^d[7]^
                       d[9]^p[0]^p[12]^p[13]^p[14]^p[16]^p[17]^p[19]^p[20]^p[21]^
                       p[22]^p[25]^p[28]^p[2]^p[31]^p[4]^p[6]^p[7]^p[9];
  endfunction : firefec_calc_parity


endmodule : serial_monitor

