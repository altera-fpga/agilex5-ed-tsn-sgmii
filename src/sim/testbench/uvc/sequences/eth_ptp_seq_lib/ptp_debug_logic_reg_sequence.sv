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


class ptp_debug_logic_reg_sequence extends eth_ptp_base_sequence;
	int i;
	int rtl_node;

  `uvm_object_utils(ptp_debug_logic_reg_sequence)
  function new(string name = "ptp_debug_logic_reg_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
   super.body();
   `uvm_info("eth_seq_lib", "running ptp_debug_logic_reg_sequence\n",UVM_LOW)
 		
	   if((p_sequencer.env.spy_if.speed == _25G) || (p_sequencer.env.spy_if.speed == _10G)) begin
			 i=0;
			 //rtl_node = 15;
         //TODO: for different non default node 
         rtl_node = (($test$plusargs("ETH17A_21"))?17:(($test$plusargs("ETH17A_20"))?18:15));        
		 end
		 if(p_sequencer.env.spy_if.speed == _50G) begin
			 i=1;
			 rtl_node = 7;
		 end
		 if(p_sequencer.env.spy_if.speed == _100G) begin
			 i=3;
			 rtl_node = 3;
		 end
		 if(p_sequencer.env.spy_if.speed == _200G) begin
			 i=7;
			 rtl_node = 1;
		 end
		 if(p_sequencer.env.spy_if.speed == _400G) begin
			 i=7;
			 rtl_node = 0;
		 end  
       
       `uvm_info(get_full_name(),$sformatf("rtl_node is %0d", rtl_node), UVM_MEDIUM)
  	 
		 tx_tam_dbg_register_check(); 	 
		 tx_tam_adj_dbg_register_check(); 	 
		 rx_tam_dbg_register_check(); 	 
		 rx_tam_adj_dbg_register_check();  

    repeat(3) begin
      send_ptp_frame(INS_2STEP,DATA_FRAME,1);  
   #2000ns  ;    //to complete frame transacation
		
	  vl_ss_register_check();
		tssnap_register_check (); 

    end
   
  endtask

 task tx_tam_dbg_register_check();

  bit [15:0] addr1,addr2,addr3,adr_in1,adr_in2,adr_in3;
	uvm_reg_data_t read_data_0,read_data_1,read_data_2; 

        `uvm_info(get_full_name(), $sformatf("RTL wait_load = 96'h%0h",p_sequencer.env.spy_if.tx_o_load_data_valid[rtl_node]),UVM_LOW) 

       addr1 = `GET_REG_ADDR(mac_stats_tx_ptp_tam_lo_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;
       addr2 = `GET_REG_ADDR(mac_stats_tx_ptp_tam_med_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;
       addr3 = `GET_REG_ADDR(mac_stats_tx_ptp_tam_hi_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;

       
 		 for(int j=0;j<=i;j++)   begin
 			 
			 wait(p_sequencer.env.spy_if.tx_o_load_data_valid[rtl_node][0])

       adr_in1 = addr1 +(j*16);
       adr_in2 = addr2 +(j*16);
       adr_in3 = addr3 +(j*16);
				 p_sequencer.env.reg_read(adr_in1,read_data_0,1);
				 p_sequencer.env.reg_read(adr_in2,read_data_1,1);
				 p_sequencer.env.reg_read(adr_in3,read_data_2,1);
				
				if (p_sequencer.env.spy_if.tx_o_tam_dbg[rtl_node][j][95:0] == {read_data_2,read_data_1,read_data_0})
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue TX TAM READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.tx_o_tam_dbg[rtl_node][j][95:0],read_data_0,read_data_1,read_data_2),UVM_LOW)
					else      begin
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue TX TAM READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.tx_o_tam_dbg[rtl_node][j][95:0],read_data_0,read_data_1,read_data_2))
				end
			end  

		endtask  

 task rx_tam_dbg_register_check();

  bit [15:0] addr1,addr2,addr3,adr_in1,adr_in2,adr_in3;
	uvm_reg_data_t read_data_0,read_data_1,read_data_2; 

        `uvm_info(get_full_name(), $sformatf("RTL wait_load = 96'h%0h",p_sequencer.env.spy_if.rx_o_load_data_valid[rtl_node]),UVM_LOW) 

       addr1 = `GET_REG_ADDR(mac_stats_rx_ptp_tam_lo_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;
       addr2 = `GET_REG_ADDR(mac_stats_rx_ptp_tam_med_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;
       addr3 = `GET_REG_ADDR(mac_stats_rx_ptp_tam_hi_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;

       
 		 for(int j=0;j<=i;j++)   begin
    		
			 wait(p_sequencer.env.spy_if.rx_o_load_data_valid[rtl_node][0])

       adr_in1 = addr1 +(j*16);
       adr_in2 = addr2 +(j*16);
       adr_in3 = addr3 +(j*16);
				 p_sequencer.env.reg_read(adr_in1,read_data_0,1);
				 p_sequencer.env.reg_read(adr_in2,read_data_1,1);
				 p_sequencer.env.reg_read(adr_in3,read_data_2,1);
				
				if (p_sequencer.env.spy_if.rx_o_tam_dbg[rtl_node][j][95:0] == {read_data_2,read_data_1,read_data_0})
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue RX TAM READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.rx_o_tam_dbg[rtl_node][j][95:0],read_data_0,read_data_1,read_data_2),UVM_LOW)
					else      begin
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue RX TAM READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.rx_o_tam_dbg[rtl_node][j][95:0],read_data_0,read_data_1,read_data_2))
				end
			end  

		endtask 

 task rx_tam_adj_dbg_register_check();

  bit [15:0] addr1,adr_in1;
	uvm_reg_data_t read_data_0; 

       addr1 = `GET_REG_ADDR(mac_stats_rx_ptp_tam_adj_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;

       
 		 for(int j=0;j<=i;j++)   begin

       adr_in1 = addr1 +(j*16);
				 p_sequencer.env.reg_read(adr_in1,read_data_0,1);
				
				if (p_sequencer.env.spy_if.rx_o_tam_adj_dbg[rtl_node][j][31:0] == read_data_0)
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue RX TAM ADJ READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.rx_o_tam_adj_dbg[rtl_node][j][31:0],read_data_0),UVM_LOW)
					else      begin
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue RX TAM ADJ READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.rx_o_tam_adj_dbg[rtl_node][j][31:0],read_data_0))
				end
			end  

		endtask 


 task tx_tam_adj_dbg_register_check();

  bit [15:0] addr1,adr_in1;
	uvm_reg_data_t read_data_0,read_data_1,read_data_2; 

       addr1 = `GET_REG_ADDR(mac_stats_tx_ptp_tam_adj_pl_0_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed) ;

       
 		 for(int j=0;j<=i;j++)   begin

       adr_in1 = addr1 +(j*16);
				 p_sequencer.env.reg_read(adr_in1,read_data_0,1);
				
				if (p_sequencer.env.spy_if.tx_o_tam_adj_dbg[rtl_node][j][31:0] == read_data_0)
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue TX TAM ADJ READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.tx_o_tam_adj_dbg[rtl_node][j][31:0],read_data_0),UVM_LOW)
					else      begin
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register valuue TX TAM ADJ READ ADJ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.tx_o_tam_adj_dbg[rtl_node][j][31:0],read_data_0))
				end
			end  
endtask
             


 task tssnap_register_check();
	uvm_reg_data_t read_data_0,read_data_1,read_data_2; 

				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_tx_ts_ss_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_0,1);
				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_tx_ts_ss_mid_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_1,1);
				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_tx_ts_ss_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_2,1);
				
				if (p_sequencer.env.spy_if.tx_o_ts_ss[rtl_node][95:0] == {read_data_2,read_data_1,read_data_0})
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register value TX TS SNAP READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.tx_o_ts_ss[rtl_node][95:0],read_data_0,read_data_1,read_data_2),UVM_LOW)
					else 
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register value TX TS SNAP READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.tx_o_ts_ss[rtl_node][95:0],read_data_0,read_data_1,read_data_2))
       
				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_rx_ts_ss_lo_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_0,1);
				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_rx_ts_ss_mid_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_1,1);
				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_rx_ts_ss_hi_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_2,1);
				
				if (p_sequencer.env.spy_if.rx_o_ts_ss[rtl_node][95:0] == {read_data_2,read_data_1,read_data_0})
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register value  RX TS SNAP READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.rx_o_ts_ss[rtl_node][95:0],read_data_0,read_data_1,read_data_2),UVM_LOW)
					else  
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register value RX TS SNAP READ VALUE = 96'h%0h, read_data_0=%h,read_data_1=%h,read_data_2=%h",p_sequencer.env.spy_if.rx_o_ts_ss[rtl_node][95:0],read_data_0,read_data_1,read_data_2))
			
   endtask



	task vl_ss_register_check();
	uvm_reg_data_t read_data_0; 

				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_tx_vl_ss_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_0,1);
				
				if (p_sequencer.env.spy_if.tx_o_vl_ss[rtl_node][4:0] == read_data_0)
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register value TX_VL_SS READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.tx_o_ts_ss[rtl_node][4:0],read_data_0),UVM_LOW)
					else 
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register value TX TS SNAP READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.tx_o_ts_ss[rtl_node][4:0],read_data_0))
			  
       
				 p_sequencer.env.reg_read(`GET_REG_ADDR(mac_stats_rx_vl_ss_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data_0,1);
				if (p_sequencer.env.spy_if.rx_o_vl_ss[rtl_node][4:0] == read_data_0)
            `uvm_info(get_full_name(), $sformatf("MATCH RTL WB signal and register value  RX_VL_SS READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.rx_o_vl_ss[rtl_node][4:0],read_data_0),UVM_LOW)
					else  
            `uvm_error(get_full_name(), $sformatf("MATCH RTL WB signal and register value RX_VL_SS SNAP READ VALUE = 96'h%0h, read_data_0=%h",p_sequencer.env.spy_if.rx_o_vl_ss[rtl_node][95:0],read_data_0))
			 
   endtask 
endclass : ptp_debug_logic_reg_sequence      
