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


class eth_stat_64B_MAXB_cnt_sequence extends eth_stat_base_sequence;
  `uvm_object_utils(eth_stat_64B_MAXB_cnt_sequence)

  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
 endfunction:new

  virtual task body();
    int rx_rpt_cnt=0;
    int tx_rpt_cnt=0;
    int rx_frame_size=0;
    int tx_frame_size=0;
    `uvm_info("body", "started eth_stat_64B_MAXB_cnt_sequence ...", UVM_NONE)
    super.body();

    //Ignore expected VIP errors
    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_non_control_frame_reception_in_pause_state.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_invalid_control_frame_destination_address.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_ipv4_invalid_header_checksum.set_default_fail_effect(svt_err_check_stats::IGNORE);//when regular frame is generated with 'h800 payload size.'h800 is IPV4 type frame
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_length_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_length_type_not_supported.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif

    //3. Send one frame from each category stats counters start boundary  (i.e.. 63,64,65,128,256,,512,1024,1519 bytes) byte size. 
    //4. Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3.
    `uvm_info("eth_stat_64B_MAXB_cnt_sequence", "3. Send one frame from each category stats counters start boundary  (i.e.. 63,64,65,128,256,,512,1024,1519 bytes) byte size. 4. Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3", UVM_NONE)
    send_fix_size_frame(UNDERSIZE_FRAME,1,63);
    #700ns; //572434250 FIXME Shabbir: wait till tx/rx frame is decoded by MAC and stat is updated
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,64);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,65);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,128);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,256);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,512);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,1024);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,1519);
    #700ns;
    read_and_compare_frame_size_reg();

    //5. Send one frame from each category stats counters end boundary  (i.e.. 63,64,127,255,,511,1023,1518 and MAXB bytes) byte size. 
    //6.  Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 5.
    `uvm_info("eth_stat_64B_MAXB_cnt_sequence", "5. Send one frame from each category stats counters end boundary  (i.e.. 63,64,127,255,,511,1023,1518 and MAXB bytes) byte size. 6. Read  64B,65to127B,128to255B,256to511B,512o1023B, 1024to1518B,1519toMAXB register after each frame send in step 3", UVM_NONE)
    send_fix_size_frame(UNDERSIZE_FRAME,1,63);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,64);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,127);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,255);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,511);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,1023);
    #700ns;
    read_and_compare_frame_size_reg();
    send_fix_size_frame(RANDOM_FRAME,1,1518);
    #700ns;
    read_and_compare_frame_size_reg();
    fork
    begin//begin1
      `uvm_info("eth_stat_64B_MAXB_cnt_sequence", $psprintf("RX Frame : RANDOM_FRAME with frame_size=%0d ",rx_max_frame_size), UVM_NONE)
      send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(rx_max_frame_size),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
    end//begin1
    begin//begin2
      `uvm_info("eth_stat_64B_MAXB_cnt_sequence", $psprintf("TX Frame : RANDOM_FRAME with frame_size=%0d ",tx_max_frame_size), UVM_NONE)
      send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(tx_max_frame_size),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
    end//begin2
    join
    #700ns;
    read_and_compare_frame_size_reg();

    //7. Send some frames from each category stats counters  byte size boundary , have a frame size random between start and end boundary.
    //8. Read  64B,65to127B, 128to255B,256to511B, 512o1023B,1024to1518B,1519toMAXB register.
    `uvm_info("eth_stat_64B_MAXB_cnt_sequence", "7. Send some frames from each category stats counters  byte size boundary , have a frame size random between start and end boundary. 8. Read  64B,65to127B, 128to255B,256to511B, 512o1023B,1024to1518B,1519toMAXB register.", UVM_NONE)
    fork
      send_fix_size_frame(UNDERSIZE_FRAME,num_of_frames/20,63);
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
      send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,64);
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
      send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(65,127));
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
      send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(128,255));
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
      send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(256,511));
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
      send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(512,1023));
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
      send_fix_size_frame(RANDOM_FRAME,num_of_frames/20,$urandom_range(1024,1518));
      send_random_frames(num_of_frames/20);
    join
    #700ns;
    read_and_compare_frame_size_reg();
    fork
    begin//begin1
      rx_rpt_cnt=num_of_frames/20;
      repeat (rx_rpt_cnt) begin
        rx_frame_size=$urandom_range(1519,rx_max_frame_size);
        `uvm_info("eth_stat_64B_MAXB_cnt_sequence", $psprintf("RX Frame : RANDOM_FRAME with frame_size=%0d ",rx_frame_size), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(rx_frame_size),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
      end
    end//begin1
    begin//begin2
      tx_rpt_cnt=num_of_frames/20;
      repeat (tx_rpt_cnt) begin
        tx_frame_size=$urandom_range(1519,tx_max_frame_size);
        `uvm_info("eth_stat_64B_MAXB_cnt_sequence", $psprintf("TX Frame : RANDOM_FRAME with frame_size=%0d ",tx_frame_size), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(RANDOM_FRAME),.frame_size(tx_frame_size),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
      end
    end//begin2
    begin
      send_random_frames(num_of_frames/20);
    end
    join
    #700ns;
    read_and_compare_frame_size_reg();

    //FIXME Shabbir: force doesn't work now
    //9. Send random frames such that read value of  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  counter status register rollover from 32 bit value to 33 bit value 
    //10.  read  64B, 5to127B, 128to255B, 256to511B, 512o1023B, 1024to1518B,1519toMAXB  register after each frame.
    //11. Send random frames such that read value of  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB  counter status register reaches to maximum value  
    //12.Read  64B,65to127B,128to255B,256to511B,512o1023B,1024to1518B,1519toMAXB counter register
    //13. Send random frames after  64B, 65to127B, 128to255B, 256to511B, 512o1023B,1024to1518B,1519toMAXB  counter reaches to maximum value.
    //14. Read  64B,65to127B,128to255B, 256to511B, 512o1023B, 1024to1518B,1519toMAXB counter register to make sure counter does not rollover.
    //15. Read all stats counter registers
    //
    //PS : 
    //1 ) Before step 9/11, test may force the counter value near to max value or expected value to avoid large frame transfer.
    //2) include normal, undersize ,oversize and control frames with and without FCS error in step 7 and 9

    `uvm_info("body", "ended eth_stat_64B_MAXB_cnt_sequence ...", UVM_NONE)
  endtask

  task send_fix_size_frame(frame_type f_type = DATA_FRAME,int no_of_frames=1, int frame_size=64);
    repeat (no_of_frames) begin
      fork
      begin//begin1
        `uvm_info("send_fix_size_frame", $psprintf("RX Frame : %0s with frame_size=%0d ",f_type.name(),frame_size), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(f_type),.frame_size(frame_size),.no_of_frame(1),.path(ETH_VIP_AVL_RX));
      end//begin1
      begin//begin2
        `uvm_info("send_fix_size_frame", $psprintf("TX Frame : %0s with frame_size=%0d ",f_type.name(),frame_size), UVM_NONE)
        send_eth_frame_with_fix_size(.eth_frame(f_type),.frame_size(frame_size),.no_of_frame(1),.path(AVL_TX_ETH_VIP));
      end//begin2
      join
    end//repeat (no_of_frames) begin
  endtask: send_fix_size_frame

endclass:eth_stat_64B_MAXB_cnt_sequence
