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


class mac_control_cov extends eth_base_sequence;

  `uvm_object_utils(mac_control_cov)
  bit [47:0] src_address;
  uvm_reg_data_t read_data;
  function new(string name = "seq_0");
    super.new(name);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif
   //muralasx: Newly added 
   if (!($value$plusargs("num_of_frames=%d",num_of_frames))) begin
         num_of_frames=500;
   end    
   `uvm_info(get_name(),$sformatf("no of eth_frames set to := %0d-frames",num_of_frames),UVM_NONE)
  endfunction:new

  virtual task body();
    `uvm_info("eth_seq_lib", "running mac_control_cov \n",UVM_LOW)

    if(p_sequencer.env.dyn_rcfg_obj_inst.ll_speed == _10M)begin
       fork
         send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,2);  
         send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,2);  
       join
       p_sequencer.env.wait_client_rx_frames_done(.exp_num(2),.timeout_time(1ms));
       p_sequencer.env.wait_tx_frames_received(.exp_num(2),.timeout_time(1ms));    
    end else begin
        //muralasx: Added below logic to insert unique unicast source address when the parameter sa =1
        src_address = $random();
        src_address[40]=0;
        $display("Source address %0h",src_address);
        p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrl_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[31:0]);
        p_sequencer.env.reg_write((`GET_REG_ADDR(mac_cfg_txmac_saddrh_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed)),src_address[47:32]);

        p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
        //-----------------------------------
        // Added by atiwari2, for cov
        read_data[7]=1;//
        read_data[10]=1;//
        read_data[8]=1;//
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_rxmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);

        p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
        read_data[3]=1;
        read_data[5]=1;
        read_data[7]=1;
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
        `ifdef ENABLE_ETH_VIP
          fork
            send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,num_of_frames);  
            send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
            
          join_any
        `else
          send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,num_of_frames);  
        `endif
        #100ns;
        p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
        read_data[2]=1;  //disable_txmac
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
        $display("ABT Enabled Disable TXMAC %0h",read_data[2]);
        fork
            #200ns;
            begin
                repeat(200-20) begin // suppose to see ready 0 for 200ns but checking for less time
                    #1ns;
                    if ( p_sequencer.env.sideband_if.tx_ready == 1) 
                        `uvm_error("ETH Trans", $sformatf("TXMAC not paused properly"));
                end
            end
        join_any  
        p_sequencer.env.reg_read(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data,1);
        read_data[2]=0;  //disable_txmac
        p_sequencer.env.reg_write(`GET_REG_ADDR(mac_cfg_txmac_control_OFFSET_REG,p_sequencer.env.dyn_rcfg_obj_inst.speed),read_data);
        $display("ABT Disabled Disable TXMAC %0h",read_data[2]);
    end

  endtask
endclass

