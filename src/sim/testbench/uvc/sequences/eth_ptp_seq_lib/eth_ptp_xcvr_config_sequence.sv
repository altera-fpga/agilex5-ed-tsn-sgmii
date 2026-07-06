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


`define STRINGIFY(x) `"x`"
class eth_ptp_xcvr_config_sequence extends eth_base_sequence;
  `uvm_object_utils(eth_ptp_xcvr_config_sequence)

  // Firmware
  // Common TX & RX
  localparam  PL = 8;
  localparam  VL = 16;
  logic [27:0] ui = 32'h4D19EC;
  rand logic [16-1:0][30:0] i_rx_xcvr_if_pulse_adj; //have 16 AIB_LANES MAX case
  rand int  i_rx_pl_fl_map;
  int inst;
  int node;
  int lane_num;
 function new(string name = "eth_ptp_xcvr_config_sequence");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 task body();

   `uvm_info("body", "started eth_ptp_xcvr_config_sequence ...", UVM_NONE)

   inst = p_sequencer.env.inst_num;
   if ((p_sequencer.env.dyn_rcfg_obj_inst.speed == _25G) || (p_sequencer.env.dyn_rcfg_obj_inst.speed == _10G)) begin
      node = (inst == 0) ? 15:
                 (inst == 1) ? 16:
                 (inst == 2) ? 17:
                 (inst == 3) ? 18:
                 (inst == 4) ? 19:
                 (inst == 5) ? 20:
                 (inst == 6) ? 21:
                 (inst == 7) ? 22:
                 (inst == 8) ? 23:
                 (inst == 9) ? 24:
                 (inst == 10) ? 25:
                 (inst == 11) ? 26:
                 (inst == 12) ? 27:
                 (inst == 13) ? 28:
                 (inst == 14) ? 29: 30;
   end

   if (p_sequencer.env.dyn_rcfg_obj_inst.trans_type == 0) begin
	ux_xcvr_programming();
   end
   else begin
       //if (p_sequencer.env.dyn_rcfg_obj_inst.trans_type == 1) begin
       bk_xcvr_programming();
   end

 endtask : body

 //Task for register programing to UX XCVR
 task ux_xcvr_programming();
   uvm_status_e  status0, status1, status2, status3, status4, status5, status6, status7;
   bit[31:0] read_data0, read_data1, read_data2, read_data3, read_data4, read_data5, read_data6, read_data7; 
   bit[31:0] write_data0, write_data1, write_data2, write_data3, write_data4, write_data5, write_data6, write_data7;

  //This is original from FW.
  // Step 2c
  // Write the pulse adjustments into IP

  // for (pl = 0; pl < PL; pl++) begin
  //     csr_write (Hard FGT XCVR, reg_ux_q_dl_ctrl_a_l<pl>.cfg_rx_lat_bit_for_async[17:0], i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*pl]);
  // end
  `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Start the XCVR UX Register programing"),UVM_MEDIUM)
  
  //quad3 == xcvr_reg_model_0,xcvr_reg_model_4
  //quad2 == xcvr_reg_model_1,xcvr_reg_model_5
  //quad1 == xcvr_reg_model_2,xcvr_reg_model_6
  //quad0 == xcvr_reg_model_3,xcvr_reg_model_7
  fork 
  begin
		if($test$plusargs("ETH17A_21"))begin
		
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Programming ETH17A_21 UX registers"),UVM_MEDIUM)
			p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status0, read_data0);
			do begin
				p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]); 
				#100ns;
				end
			while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("ux_q_dl_ctrl_a_l1 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)
			p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
		
		end else if ($test$plusargs("ETH17A_20"))begin
		
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Programming ETH17A_20 UX registers"),UVM_MEDIUM)
			p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status0, read_data0);
			do begin
				p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]); 
				#100ns;
				end
			while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("ux_q_dl_ctrl_a_l0 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)
			p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());		
		end else if (p_sequencer.env.dyn_rcfg_obj_inst.speed==_25G && p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {1}) begin //25G single and multi instance
	                lane_num = 3 - (inst % 4);
                        `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("lane_num = %d, inst_num = %d, node = %0d", lane_num, inst, node), UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Programming normal UX registers"),UVM_MEDIUM)
                        if (node == 15) begin
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l3 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get());
                        end

                        else if (node == 16) begin
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l2 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l2 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get());
                        end
                        else if (node == 17) begin
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l1 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
                        end
                        else if (node == 18) begin
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l0 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());
                        end
                        else if (node == 19) begin
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l3 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.write(status0, p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get());
                        end
                        else if (node == 20) begin
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l2 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l2 is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.write(status0, p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get());
                        end
                        else if (node == 21) begin
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l1 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status0, p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
                        end
                        else if (node == 22) begin
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l0 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status0, p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());
                        end
                        else if (node == 23) begin
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l3 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.write(status0, p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get());
                        end

                        else if (node == 24) begin
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l2 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l2 is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.write(status0, p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get());
                        end
                        else if (node == 25) begin
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l1 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status0, p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
                        end
                        else if (node == 26) begin
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l0 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status0, p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());
                        end
                        else if (node == 27) begin
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l3 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.write(status0, p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get());
                        end

                        else if (node == 28) begin
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l2 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l2 is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.write(status0, p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get());
                        end
                        else if (node == 29) begin
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l1 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status0, p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
                        end
                        else if (node == 30) begin
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status0, read_data0);
                           do begin
                                   p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                   #100ns;
                                   end
                           while (p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l0 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                           `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)
                           p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status0, p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());
                        end

                end else begin //for other speeds other than 25G

                        `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Programming normal UX registers"),UVM_MEDIUM)
                        p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.read(status0, read_data0);
                        do begin
                                p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                                #100ns;
                                end
                        while (p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
                        `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l3 read data0 is 'h%h, write data0 is 'h%h", read_data0, write_data0),UVM_MEDIUM)
                        `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
                        `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG0: ux_q_dl_ctrl_a_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get()),UVM_MEDIUM)
                        p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get());
		end
 end

   begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {2, 4, 8}) begin
         p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.read(status1, read_data1);
         do begin
            p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*1][17:0]); 
            #100ns;
         end
         while (p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*1][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l2 read data1 is 'h%h, write data1 is 'h%h", read_data1, write_data1),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG1: ux_q_dl_ctrl_a_l2 is 'h%h", p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get()),UVM_MEDIUM)           
         p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.write(status1, p_sequencer.env.xcvr_reg_model_1.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get());
      end
  end

   begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {4, 8}) begin
         p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status2, read_data2);
         do begin
            p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*2][17:0]); 
            #100ns;
         end
         while (p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*2][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l1 read data2 is 'h%h, write data2 is 'h%h", read_data2, write_data2),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG2: ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)           
         p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status2, p_sequencer.env.xcvr_reg_model_2.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
      end
  end

   begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {4, 8}) begin
         p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status3, read_data3);
         do begin
            p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*3][17:0]); 
            #100ns;
         end
         while (p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*3][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l0 read data3 is 'h%h, write data3 is 'h%h", read_data3, write_data3),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG3: ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)              
         p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status3, p_sequencer.env.xcvr_reg_model_3.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());
      end
   end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.read(status4, read_data4);
         do begin
            p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*4][17:0]); 
            #100ns;
            end
         while (p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*4][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG4: ux_q_dl_ctrl_a_l3 read data4 is 'h%h, write data0 is 'h%h", read_data4, write_data4),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG4: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG4: ux_q_dl_ctrl_a_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get()),UVM_MEDIUM)       
         p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.write(status4, p_sequencer.env.xcvr_reg_model_4.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l3.get());
      end
  end

   begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.read(status5, read_data5);
         do begin
            p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*5][17:0]); 
            #100ns;
         end
         while (p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*5][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG5: ux_q_dl_ctrl_a_l2 read data4 is 'h%h, write data5 is 'h%h", read_data5, write_data5),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG5: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG5: ux_q_dl_ctrl_a_l2 is 'h%h", p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get()),UVM_MEDIUM)            
         p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.write(status5, p_sequencer.env.xcvr_reg_model_5.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l2.get());
      end
   end

   begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.read(status6, read_data6);
         do begin
            p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*6][17:0]); 
            #100ns;
         end
         while (p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*6][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG6: ux_q_dl_ctrl_a_l1 read data6 is 'h%h, write data6 is 'h%h", read_data6, write_data6),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG6: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG6: ux_q_dl_ctrl_a_l1 is 'h%h", p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get()),UVM_MEDIUM)            
         p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.write(status6, p_sequencer.env.xcvr_reg_model_6.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l1.get());
      end
   end

   begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.read(status7, read_data7);
         do begin
            p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*7][17:0]); 
            #100ns;
         end
         while (p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*7][17:0]);
  			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG7: ux_q_dl_ctrl_a_l0 read data7 is 'h%h, write data7 is 'h%h", read_data7, write_data7),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG7: cfg_sel_rxbit_adder 'h%h, cfg_rx_lat_bit_for_async is 'h%h", p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_sel_rxbit_adder.get(), p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.cfg_rx_lat_bit_for_async.get()),UVM_MEDIUM)
			`uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("REG7: ux_q_dl_ctrl_a_l0 is 'h%h", p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get()),UVM_MEDIUM)            
         p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.write(status7, p_sequencer.env.xcvr_reg_model_7.u_gdr_ux_quad_urm.ux_q_dl_ctrl_a_l0.get());
      end
   end
  join
  `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Complete the XCVR UX Register programing"),UVM_MEDIUM)

 endtask : ux_xcvr_programming

 //Task for register programing to UX XCVR
 task bk_xcvr_programming();
   uvm_status_e  status0, status1, status2, status3, status4, status5, status6, status7;
   bit[31:0] read_data0, read_data1, read_data2, read_data3, read_data4, read_data5, read_data6, read_data7; 
   bit[31:0] write_data0, write_data1, write_data2, write_data3, write_data4, write_data5, write_data6, write_data7;
	string tile_path;

  //This is original from FW.
  // Step 2c
  // Write the pulse adjustments into IP

  // for (pl = 0; pl < PL; pl++) begin
  //     csr_write (Hard FGT XCVR, reg_ux_q_dl_ctrl_a_l<pl>.cfg_rx_lat_bit_for_async[17:0], i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*pl]);
  // end
  `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Start the XCVR Barak Register programing"),UVM_MEDIUM)
  
  tile_path = `STRINGIFY(`FTILE_TOP_PATH);
  
  fork 
  begin
      //uvm_hdl_force({tile_path,".z1577a.z1577a_inst.u_barak_quad.u_gdr_barak_quad_rxtx_dp.GEN_PERLANE_CODE[3].u_rxtx_detlat.i_csr_rx_lat_bit_for_async[17:0]"}, i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
      
      p_sequencer.env.xcvr_reg_model_0.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.read(status0, read_data0);
      do begin
         p_sequencer.env.xcvr_reg_model_0.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.cfg_rx_lat_bit_for_async_lane3.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]); 
         #100ns;
      end
      while(p_sequencer.env.xcvr_reg_model_0.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.cfg_rx_lat_bit_for_async_lane3.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]);
      `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("barak_rxdl_async_l3 read data0 is 'h%h", read_data0),UVM_MEDIUM)
      `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0] is 'h%h", i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*0][17:0]),UVM_MEDIUM)
      `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Get barak_rxdl_async_l3 is 'h%h", p_sequencer.env.xcvr_reg_model_0.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.get()),UVM_MEDIUM)
      p_sequencer.env.xcvr_reg_model_0.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.write(status0, p_sequencer.env.xcvr_reg_model_0.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.get());
      
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {2, 4, 8}) begin
      //uvm_hdl_force({tile_path,".z1577a.z1577a_inst.u_barak_quad.u_gdr_barak_quad_rxtx_dp.GEN_PERLANE_CODE[2].u_rxtx_detlat.i_csr_rx_lat_bit_for_async[17:0]"}, i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*1][17:0]);
         p_sequencer.env.xcvr_reg_model_1.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.read(status1, read_data1);      
         do begin
            p_sequencer.env.xcvr_reg_model_1.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.cfg_rx_lat_bit_for_async_lane2.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*1][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_1.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.cfg_rx_lat_bit_for_async_lane2.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*1][17:0]);
         p_sequencer.env.xcvr_reg_model_1.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.write(status1, p_sequencer.env.xcvr_reg_model_1.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.get());
	  
      end
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {4, 8}) begin
         p_sequencer.env.xcvr_reg_model_2.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.read(status2, read_data2);
         do begin
            p_sequencer.env.xcvr_reg_model_2.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.cfg_rx_lat_bit_for_async_lane1.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*2][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_2.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.cfg_rx_lat_bit_for_async_lane1.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*2][17:0]); 
         p_sequencer.env.xcvr_reg_model_2.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.write(status2, p_sequencer.env.xcvr_reg_model_2.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.get());
      end
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num inside {4, 8}) begin
         p_sequencer.env.xcvr_reg_model_3.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.read(status3, read_data3);
         do begin         
            p_sequencer.env.xcvr_reg_model_3.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.cfg_rx_lat_bit_for_async_lane0.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*3][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_3.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.cfg_rx_lat_bit_for_async_lane0.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*3][17:0]);
         p_sequencer.env.xcvr_reg_model_3.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.write(status3, p_sequencer.env.xcvr_reg_model_3.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.get());
      end
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_4.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.read(status4, read_data4);
         do begin
            p_sequencer.env.xcvr_reg_model_4.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.cfg_rx_lat_bit_for_async_lane3.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*4][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_4.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.cfg_rx_lat_bit_for_async_lane3.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*4][17:0]);
         p_sequencer.env.xcvr_reg_model_4.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.write(status4, p_sequencer.env.xcvr_reg_model_4.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l3.get());
      end
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_5.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.read(status5, read_data5);
         do begin
            p_sequencer.env.xcvr_reg_model_5.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.cfg_rx_lat_bit_for_async_lane2.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*5][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_5.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.cfg_rx_lat_bit_for_async_lane2.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*5][17:0]);
         p_sequencer.env.xcvr_reg_model_5.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.write(status5, p_sequencer.env.xcvr_reg_model_5.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l2.get());
      end
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_6.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.read(status6, read_data6);
         do begin
            p_sequencer.env.xcvr_reg_model_6.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.cfg_rx_lat_bit_for_async_lane1.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*6][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_6.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.cfg_rx_lat_bit_for_async_lane1.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*6][17:0]);
         p_sequencer.env.xcvr_reg_model_6.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.write(status6, p_sequencer.env.xcvr_reg_model_6.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l1.get());
      end
  end

  begin
      if (p_sequencer.env.dyn_rcfg_obj_inst.ch_num == 8) begin
         p_sequencer.env.xcvr_reg_model_7.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.read(status7, read_data7);
         do begin
            p_sequencer.env.xcvr_reg_model_7.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.cfg_rx_lat_bit_for_async_lane0.set(i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*7][17:0]); 
            #100ns;
         end
         while(p_sequencer.env.xcvr_reg_model_7.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.cfg_rx_lat_bit_for_async_lane0.get() != i_rx_xcvr_if_pulse_adj[i_rx_pl_fl_map*7][17:0]);
         p_sequencer.env.xcvr_reg_model_7.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.write(status7, p_sequencer.env.xcvr_reg_model_7.u_gdr_barak_quad_urm.u_gdr_barak_quad_cfg_ctrl.u_gdr_barak_quad_avmm_cfgcsr.barak_rxdl_async_l0.get());
      end
  end
  join
  `uvm_info("eth_ptp_xcvr_config_sequence", $sformatf("Complete the XCVR Barak Register programing"),UVM_MEDIUM)

 endtask : bk_xcvr_programming
endclass : eth_ptp_xcvr_config_sequence
