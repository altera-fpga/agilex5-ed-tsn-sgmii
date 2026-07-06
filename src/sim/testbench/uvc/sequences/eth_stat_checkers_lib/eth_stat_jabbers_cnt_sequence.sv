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


class eth_stat_jabbers_cnt_sequence extends eth_stat_base_sequence;
  
   int frame_size_rx,frame_size_tx;
   int frame_num_rx,frame_num_tx;
   int itr_cnt;

  `uvm_object_utils(eth_stat_jabbers_cnt_sequence)

  function new(string name = "eth_stat_jabbers_cnt_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
    set_automatic_phase_objection(1);
    `endif
  endfunction:new

  virtual task body();
    `uvm_info("eth_stat_jabbers_cnt_sequence", "Executing eth_stat_jabbers_cnt_sequence ...", UVM_NONE)
    super.body();

    `uvm_info("eth_stat_jabbers_cnt_sequence", "1. Apply csr reset is done in base test reset phase", UVM_NONE)

    `ifdef ENABLE_ETH_VIP
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_fcs_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_frame_too_long_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_tx.svt_err_mac_invalid_length_type_field.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_frame_too_short_error.set_default_fail_effect(svt_err_check_stats::IGNORE);
    p_sequencer.env.`M_SNPS_ETH_PCS66_AGENT.monitor.err_check_rx.svt_err_mac_small_frame_padded_upto_min_frame_length.set_default_fail_effect(svt_err_check_stats::IGNORE);
    `endif


    //2. Read JABBER register and configure MAX PAYLOAD SIZE register with random value.
    read_registers();
    itr_cnt =(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) ? 2:50;

    repeat(5) begin

      if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M})begin
        std::randomize(rx_max_frame_size) with {rx_max_frame_size dist {'d64 := 1 };}; //TO reduce simulation time
        std::randomize(tx_max_frame_size) with {tx_max_frame_size dist {'d64 := 1 };}; //To reduce simulation time
      end else begin
        std::randomize(tx_max_frame_size) with {tx_max_frame_size dist {'d64 := 1, 'd16384 := 1, 'd9600 := 1, ['d65:'d16383] := 2}; };
        std::randomize(rx_max_frame_size) with {rx_max_frame_size dist {'d64 := 1, 'd16364 := 1, 'd9600 := 1, ['d65:'d16383] := 2}; };
      end
      p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_rx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),rx_max_frame_size);
            p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_max_tx_size_config_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),tx_max_frame_size);
      `uvm_info("eth_stat_jabbers_cnt_sequence", $psprintf("2. Read JABBER register and configure MAX FRAME SIZE register with random value = %0d",rx_max_frame_size), UVM_NONE)

      `uvm_info("eth_stat_jabbers_cnt_sequence", "3. Send 25 random frames with below_oversize/oversize/jabber frames", UVM_NONE)
      repeat(itr_cnt) begin
        fork
        begin
          frame_size_rx = $urandom_range(rx_max_frame_size-10,rx_max_frame_size+10);
          randcase
          1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,ETH_VIP_AVL_RX,frame_size_rx);
          1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_rx,1,ETH_VIP_AVL_RX);
          endcase
          frame_num_rx++;
          `uvm_info("eth_stat_jabbers_cnt_sequence", $sformatf("RX frame_num=%0d, frame_size=%0d", frame_num_rx,frame_size_rx), UVM_LOW)
        end
        begin
          frame_size_tx = $urandom_range(tx_max_frame_size-10,tx_max_frame_size+10);
          randcase
          1:send_eth_frame_with_fcs_error(1,RANDOM_FRAME,AVL_TX_ETH_VIP,frame_size_tx);
          1:send_eth_frame_with_fix_size(RANDOM_FRAME,frame_size_tx,1,AVL_TX_ETH_VIP);
          endcase
          frame_num_tx++;
          `uvm_info("eth_stat_jabbers_cnt_sequence", $sformatf("TX frame_num=%0d, frame_size=%0d", frame_num_tx,frame_size_tx), UVM_LOW)
        end
        join
		#25us; //wait for all transactions to be completed
        //Read JABBERS registers
        // Disabling intermediate reads
	    //if((frame_num_tx%5) == 0) read_registers();
      end
    end

	p_sequencer.env.wait_tx_frames_received(.exp_num(frame_num_tx),.timeout_time(1ms));
    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed inside {_100M,_10M}) begin
	   #250us;
	end
    //4 Read all stats counter registers 
    read_and_compare_stats();

  endtask

  task read_registers();
    #2000ns;
    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_rx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
//    p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_cntr_tx_jabbers_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
  endtask

endclass : eth_stat_jabbers_cnt_sequence
