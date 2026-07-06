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


class ptp_cf_ts_ingress_coverage_sequence extends eth_ptp_base_sequence;
//  sequence_0 tx_seq;
  int i;
  int sel;
  bit [47:0] tod_val;
  bit [47:0] ing_val;
//  ethernet_random_sequence eth_seq;
  `uvm_object_utils(ptp_cf_ts_ingress_coverage_sequence)
  function new(string name = "ptp_cf_ts_ingress_coverage_sequence");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif

// tx_seq=new("tx_seq");  
 endfunction:new

  virtual task body();
	std::randomize(sel) with {sel inside {1,2,3,4};};
	$display("[INGRESS INFO] Sel = %0d", sel);
	if (sel == 1) begin 
	  tod_val = 'd17592186044418;
	end else if (sel == 2) begin
	  tod_val = 'd87960930222082;
	end else if (sel == 3) begin 
	  tod_val = 'd158329674399746;
	end else begin 
	  tod_val = 'd228698418577410;
	end
	
	$display("[INGRESS INFO] TOD selected value is %0d", tod_val);
	ing_val = tod_val - 2;
	$display("[INGRESS INFO] ING selected value is %0d", ing_val);
  	p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.tod_seconds_part.rand_mode(0); 
	p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.tod_seconds_part= tod_val;
	p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.ing_seconds_part.rand_mode(0);
	p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.ing_seconds_part= ing_val;

    super.body();
    //write_ptp_reg;
    `uvm_info("eth_seq_lib", "running ptp cf_ts_ingress sequence\n",UVM_LOW)


   
   fork
   begin

	 repeat (5) begin 
		$display("[INGRESS INFO] Now is packet number %0d", i);
		$display("[INGRESS INFO] TOD sec rand is %0d", p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.tod_seconds_part.rand_mode);
		$display("[INGRESS INFO] second TOD is %0d", p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.tod_seconds_part);
		$display("[INGRESS INFO] ING sec rand is %0d", p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.ing_seconds_part.rand_mode);
		$display("[INGRESS INFO] second ing is %0d", p_sequencer.env.m_ptp_tx_agent.m_ptp_tod_drv.m_ptp_config.ing_seconds_part);
        send_ptp_frame(INS_CF,DATA_FRAME,1);  
	  end
   end
   begin
     `ifdef ENABLE_ETH_VIP
      send_eth_frame(RANDOM_FRAME,ETH_VIP_AVL_RX,10);  
     `endif
   end
   join   


  endtask
endclass
