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


//==============================================================================
//  (C) 2014 Altera Corporation. All rights reserved.
//
//  Your use of Altera Corporation's design tools, logic functions and other
//  software and tools, and its AMPP partner logic functions, and any output
//  files from any of the foregoing (including device programming or simulation
//  files), and any associated documentation or information are expressly
//  subject to the terms and conditions of the Altera Program License
//  Subscription Agreement, Altera MegaCore Function License Agreement, or
//  other applicable license agreement, including, without limitation, that
//  your use is for the sole purpose of programming logic devices manufactured
//  by Altera and sold by Altera or its authorized distributors.  Please refer
//  to the applicable agreement for further details.
//------------------------------------------------------------------------------
//  $Id: $
//  $Change: $
//  $Author: pjoshi  $
//  $DateTime:  $
//==============================================================================
//------------------------------------------------------------------------------
//  File:  eth_avst_rx_pkt_adapter.svh
//------------------------------------------------------------------------------
`ifndef __ETH_AVST_RX_PKT_ADAPTER__
`define __ETH_AVST_RX_PKT_ADAPTER__
//`include "registers.vh"
//`include "registers_urm.svh"

`uvm_analysis_imp_decl(_reset_port_tr)
`uvm_analysis_imp_decl(_avmm_bus_tr)
//------------------------------------------------------------------------------
// Class:  eth_avst_rx_pkt_adapter
// This class gets the transcation from AVST RX monitor and unpacks that
// packet and then passes that to scoreboard
//------------------------------------------------------------------------------
class eth_avst_rx_pkt_adapter extends uvm_subscriber # (avst_req_base);

    /*Sideband if pointer*/
    typedef virtual eth_sideband_interface v_if;
    v_if rx_adp_if;
    
    typedef virtual eth_fc_interface v_fc_if;
    v_fc_if fc_if;

    //Port: rx_mac_to_scb_ap
    //This port sends the item recived from the RX AVST monitor to scoreboard
    uvm_analysis_port#(eth_packet) rx_mac_to_scb_ap;

    //Port: frm_rx_avst_mon
    //This port receives item recived from the RX AVST monitor
    uvm_analysis_imp #(avst_req_base,eth_avst_rx_pkt_adapter) frm_rx_avst_mon;

    //Object: trans
    //Ethernet packet class.   
    eth_packet trans;

    // Variable- transaction_id
    //
    // Specifies the transcation_id of received packet
    int transaction_id;

    // last received ptp value
    bit [95:0]          last_ptp_its = 0;
    bit [47:0]          diff_its = 0; // Assuming difference will not be in seconds

    /*mac and mac control fields*/
    bit                 pause;
    bit[7:0]            q_id;
    uvm_reg_data_t      read_data;
    bit [31:0]          rxmac_ctrl;

    //Object: reg_model
    //This is register model handle
    registers_urm       reg_model;
    uvm_reg 	        regs;
    dyn_rcfg            dyn_rcfg_obj_inst;

    /*Current object's parent env name*/
    string env_name;

    /*File pointers for packet level debug*/
    string  file_avst_pkt = "avst_rx_pkt_adapter_avst_pkt.log";
    integer avst_rx_pkt_adapter_avst_pkt_id; // = $fopen(file_avst_pkt,"a");
    string  file_eth_pkt = "avst_rx_pkt_adapter_eth_pkt.log";
    integer avst_rx_pkt_adapter_eth_pkt_id;// = $fopen(file_eth_pkt,"a");
    
   `uvm_component_utils(eth_avst_rx_pkt_adapter)

    //Function: new
    //This is class constructor and used to create port instances
     function new(string        name   = "eth_avst_rx_pkt_adapter",uvm_component parent = null );
      super.new(name, parent);
      rx_mac_to_scb_ap = new("rx_mac_to_scb_ap", this);
      frm_rx_avst_mon = new("frm_rx_avst_mon", this);
      fc_rx=new;
    endfunction : new

    //------------------------------------------------------------------------------
    //  Function:  build_phase
    //
    //  Acquire the configutation object and RAL model handle from the environment and use it to
    //  configure the rx adapter.
    //
    //  Parameters:
    //
    //  phase - Current UVM phase.
    //
    //  Return:
    //
    //  None
    //------------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(registers_urm)::get(this, "", "reg_model", reg_model);
        if (reg_model == null)  `uvm_fatal("NO_CONN", "failed to get reg model in rx packet adapter");   
        uvm_config_db#(v_if)::get(this, "", "mst_if", rx_adp_if);
        if (rx_adp_if == null)  `uvm_fatal("NO_CONN", "failed to get config db in rx packet adapter");
        uvm_config_db#(v_fc_if)::get(this, "", "mst_if", fc_if);
        if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", dyn_rcfg_obj_inst)) begin 
           `uvm_fatal("dyn_rcfg", "failed to get dyn_rcfg_obj_inst object from test");
        end
        if(!uvm_config_db#(string)::get(this,"","env_name", env_name)) begin
            `uvm_fatal("env_name_rxpkt_adpter", "failed to get env_name");
        end        
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);           
        
        avst_rx_pkt_adapter_avst_pkt_id = $fopen({env_name,"_",file_avst_pkt},"a");
        avst_rx_pkt_adapter_eth_pkt_id  = $fopen({env_name,"_",file_eth_pkt},"a");
    
    endfunction:connect_phase

    //------------------------------------------------------------------------------
    //  function:  write
    //
    //  This write function gets invoke whenever the RX-MAC AVST monitor gets some transcation 
    //  and broadcasts that transcation on its anaysis port then below write function of this subscriber gets active.
    //  This function converts the packet compliant to eth_packet and write to its analysis port
    //  rx_mac_to_scb_ap for scoreboarding
    //------------------------------------------------------------------------------
    function void write(avst_req_base t);
      int max_extra_short_frame_size;
      bit [31:0] rx_preamble_pass;
      // process only correct packets 
      if(t.protocol_error_eop == 1'b0) begin

        transaction_id = transaction_id + 1;
        t.transaction_id = transaction_id; 
       `uvm_info(get_name(), $sformatf("Packet %0d received at RX MAC monitor...\n %s",transaction_id,t.convert2string()), UVM_DEBUG)
//  	$fwrite(avst_rx_pkt_adapter_avst_pkt_id,"Transaction no:%0d\n %s \n",t.transaction_id,t.convert2string());
        trans = eth_packet::type_id::create("trans");
        trans.packed_bytes=new[t.data_symbols.size](t.data_symbols);
	    //DM_TODO: Remove regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
	    regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_custom_preamble_forward_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
	    rx_preamble_pass = regs.get();
      
        // [TO DO]  virtual function unpack_bytes(bit rx_crc_passthrough_enabled, bit rx_preamble_passthrough_enabled);
        // Argumnets to unpack function should come from params/config object
        //DM_TODO: remove regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
        regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(rx_padcrc_control_OFFSET_REG,dyn_rcfg_obj_inst.speed), 1 );
        `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
        read_data = regs.get_mirrored_value();
        read_data[0] = ~read_data[0];
        `uvm_info(get_full_name(), $sformatf("CRC pass through RCVD at RX MAC = %0b,Preamble_passthrough %b",regs.get_mirrored_value(),rx_preamble_pass[0]), UVM_NONE)

        //DM_TODO: remove regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,dyn_rcfg_obj_inst.speed));
        //DM_TODO: remove rxmac_ctrl = regs.get();
        rxmac_ctrl[8] = read_data[1];
        `uvm_info(get_full_name(), $sformatf("rxmac_ctrl[8]= %0h",rxmac_ctrl[8]), UVM_NONE)
        //`ifdef G50
        if ((dyn_rcfg_obj_inst.speed==_50G || dyn_rcfg_obj_inst.speed==_40G) && dyn_rcfg_obj_inst.mode==PCSMAC) begin
          if(rx_preamble_pass[0] == 1 && read_data[0] == 1)      max_extra_short_frame_size = 17;
          else if(rx_preamble_pass[0] == 1 && read_data[0] == 0) max_extra_short_frame_size = 13;
          else if(rx_preamble_pass[0] == 0 && read_data[0] == 0) max_extra_short_frame_size = 13;
          else                                                   max_extra_short_frame_size = 17;

          //invoke unpack functions based on size
          if(trans.packed_bytes.size() <= max_extra_short_frame_size) trans.unpack_bytes_extra_short_frame(read_data[0],0);
          else  trans.unpack_bytes((read_data[0] && !rxmac_ctrl[8]),0);
      
          if(rx_preamble_pass[0]) trans.preamble=rx_adp_if.l2_rx_preamble;
         end //50G
         else  begin
       // `else 
          if(rx_preamble_pass[0] == 1 && read_data[0] == 1)      max_extra_short_frame_size = 25;
          else if(rx_preamble_pass[0] == 1 && read_data[0] == 0) max_extra_short_frame_size = 21;
          else if(rx_preamble_pass[0] == 0 && read_data[0] == 0) max_extra_short_frame_size = 13;
          else                                                   max_extra_short_frame_size = 17;

          if(read_data[0] == 0) begin
		    max_extra_short_frame_size = 13;
          end else begin
		    max_extra_short_frame_size = 17;
          end

          //invoke unpack functions based on size
          if(trans.packed_bytes.size() <= max_extra_short_frame_size) trans.unpack_bytes_extra_short_frame(read_data[0],rx_preamble_pass[0]);
          else  trans.unpack_bytes((read_data[0] && !rxmac_ctrl[8]),0);
        //`endif
        end

        // Logic to capture the l8_rx_error. This is valid with EOP so taking the last entry of the errror array.
        foreach (t.error[i])                   
        trans.rx_error = t.error[i];

        `uvm_info(get_full_name(), $sformatf("l8_rx_error RCVD at RX MAC = %0b",trans.rx_error), UVM_MEDIUM)
        if(trans.frame_type==ETH_SFC_FRAME || trans.frame_type==ETH_PFC_FRAME) begin
          if(trans.frame_type==ETH_SFC_FRAME) pause=0;
          else pause=1;
          if(pause==1) q_id=trans.payload[3];
          
	  ->fc_if.event_new_fc_triggered;
          fc_rx.sample;
        end
        trans.transaction_id = transaction_id;
       `uvm_info(get_name(), $sformatf("Packet %0d send to scoreboard from RX MAC (avalon st) ",transaction_id), UVM_MEDIUM)
       `uvm_info(get_name(), $psprintf("Packet %0d send to scoreboard from RX MAC (avalon st) \n ",transaction_id,trans.print()), UVM_DEBUG)
//  	$fwrite(avst_rx_pkt_adapter_eth_pkt_id,"Transaction no:%0d\n %s \n",trans.transaction_id,trans.print_transaction());
        //`ifdef ENABLE_ETH_VIP
        //    trans.fcs = 32'b0; // VIP enable mode needs to have fcs as 0. Alex
        //`endif
        rx_mac_to_scb_ap.write(trans);
      end
      else begin
        `uvm_info(get_name(), "Error packet received (packet wihtout eop) ...", UVM_NONE)
      end

   endfunction: write

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      fork
      join
   endtask: run_phase

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $fclose(avst_rx_pkt_adapter_eth_pkt_id);
    $fclose(avst_rx_pkt_adapter_avst_pkt_id);
   endfunction:report_phase

  covergroup fc_rx;
      PAUSE_PFC : coverpoint pause;
      ACTIVE_Q:   coverpoint q_id{
               bins NUM_Q={1,2,4,8,16,32,64,128};
                }
      cross PAUSE_PFC,ACTIVE_Q{
        ignore_bins PFC_Q_HIT=binsof(PAUSE_PFC) intersect {0} && binsof(ACTIVE_Q); 
       }
    endgroup 
endclass : eth_avst_rx_pkt_adapter

`endif  // _ETH_AVST_RX_PKT_ADAPTER__

