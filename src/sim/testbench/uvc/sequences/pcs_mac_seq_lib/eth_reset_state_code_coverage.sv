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


class eth_reset_state_code_coverage extends eth_base_sequence;
   // Reset sequence state machine
   // State machine parameters
   //`ifdef CRETE3  //dsamantx:FIX_ME for GDR
   localparam  SAMPLE_RESET     = 5'd0;
   localparam  RESET_EHIP_RX    = 5'd1;
   localparam  RESET_EHIP_TX       = 5'd2;   
   localparam  RESET_EHIP  = 5'd3;
   localparam  RESET_RSFEC_RX    = 5'd4;
   localparam  RESET_RSFEC_TX       = 5'd5;   
   localparam  RESET_RSFEC  = 5'd6;   
   localparam  RESET_EHIP_PLD_READY = 5'd7;   
   localparam  ASSERT_EHIP_PLD_READY = 5'd8;
   localparam  DEASSERT_EHIP  = 5'd9;
   localparam  WAIT_FOR_EHIP_READY = 5'd10;   
   localparam  DEASSERT_EHIP_TX  = 5'd11;
   localparam  DEASSERT_EHIP_RX  = 5'd12;
   localparam  DEASSERT_RSFEC  = 5'd13; 
   localparam  DEASSERT_RSFEC_TX  = 5'd14;
   localparam  DEASSERT_RSFEC_RX  = 5'd15;  
   localparam  DONE_REQ  = 5'd16;   
   localparam  RESUME_RESET = 5'd17;
   localparam  WAIT_FOR_RXPFA_0 = 5'd18;   
   localparam SIGNAL_NOT_OK= 5'd19;
   localparam SIGNAL_OK= 5'd20;    
   // `else
   //localparam  SAMPLE_RESET     = 4'd0;
   //localparam  RESET_EHIP_RX    = 4'd1;
   //localparam  RESET_EHIP_TX       = 4'd2;   
   //localparam  RESET_EHIP  = 4'd3;
   //localparam  RESET_EHIP_PLD_READY = 4'd4;   
   //localparam  ASSERT_EHIP_PLD_READY = 4'd5;
   //localparam  DEASSERT_EHIP  = 4'd6;
   //localparam  WAIT_FOR_EHIP_READY = 4'd7;   
   //localparam  DEASSERT_EHIP_TX  = 4'd8;
   //localparam  DEASSERT_EHIP_RX  = 4'd9;
   //localparam  DONE_REQ  = 4'd10;   
   //localparam  RESUME_RESET           = 4'd11;
   //localparam  WAIT_FOR_RXPFA_0 = 4'd12;
   //`endif

  `uvm_object_utils(eth_reset_state_code_coverage)

  function new(string name = "eth_reset_state_code_coverage");
    super.new(name);
	`ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 task coverage_scenario(bit [4:0] state,bit [4:0] deassert_state);
   fork
    begin
     if(state==RESET_EHIP) begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply EHIP reset", UVM_NONE)
       p_sequencer.env.apply_reset("hard",0,0,1,11);
       //`ifdef CRETE3
       //Wait for RESUME_RESET state to come after DEASSERT_EHIP_RX 
       //to make sure reset sequence completes before applying second reset (FB 553344)
       wait(p_sequencer.env.spy_if.ehip_reset_state==DEASSERT_EHIP_RX); //DEASSERT_EHIP_RX 
       wait(p_sequencer.env.spy_if.ehip_reset_state==RESUME_RESET);  // RESUME_RESET
       p_sequencer.env.apply_reset("hard",0,0,1,11);
       //`endif
     end
     if(state==RESET_EHIP_RX) begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply hard rx reset", UVM_NONE)
       p_sequencer.env.apply_reset("hard",0,1,0,$urandom_range(10,20));
     end
     if(state==RESET_EHIP_TX) begin
       `uvm_info("apply_tx_rx_hard_soft_rst", " Apply hard tx reset", UVM_NONE)
       p_sequencer.env.apply_reset("hard",1,0,0,$urandom_range(10,20));
     end
    end
    begin
      wait(p_sequencer.env.spy_if.ehip_reset_state==state); 

      //Pull reset_ack “0” When => ehip_reset_out_reg ==1 , ehip_reset_ack_in !=1
      if(state==RESET_EHIP) wait(p_sequencer.env.spy_if.ehip_reset==1'b1 && p_sequencer.env.spy_if.ehip_reset_ack==1'b0);

      //Pull reset_ack “0” When => ehip_rx_reset_out_reg ==1 , ehip_rx_reset_ack_in !=1
      if(state==RESET_EHIP_RX) wait(p_sequencer.env.spy_if.ehip_reset_rx==1'b1 && p_sequencer.env.spy_if.ehip_reset_ack_rx==1'b0);

      //Pull reset_ack “0” When => ehip_tx_reset_out_reg ==1 , ehip_tx_reset_ack_in !=1
      if(state==RESET_EHIP_TX) wait(p_sequencer.env.spy_if.ehip_reset_tx==1'b1 && p_sequencer.env.spy_if.ehip_reset_ack_tx==1'b0);

      `uvm_info("eth_reset_state_code_coverage", "EHIP reset. Forcing reset_ack to 0\n",UVM_LOW)
      `ifndef CRETE3
       uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
       `else
       `ifdef FALCON_MESA
         uvm_hdl_force("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_fm_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
        `else
        uvm_hdl_force("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
         `endif //FALCON_MESA
       `endif

      wait(p_sequencer.env.spy_if.ehip_reset_state==RESUME_RESET); // RESUME_RESET state

      `uvm_info("eth_reset_state_code_coverage", "EHIP reset. Releasing reset_ack\n",UVM_LOW)
      `ifndef CRETE3
      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.ehip_rst_seqinst.reset_ack");
      `else
       `ifdef FALCON_MESA
      uvm_hdl_release("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_fm_reset_controller_inst.ehip_rst_seqinst.reset_ack");
        `else
      uvm_hdl_release("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_reset_controller_inst.ehip_rst_seqinst.reset_ack");
        `endif //FALCON_MESA
       `endif
    end
    begin
      wait(p_sequencer.env.spy_if.ehip_reset_state==deassert_state); 

      //Pull reset_ack “0” When => ehip_reset_out_reg ==0 , ehip_reset_ack_in !=0 - 4
      if(state==RESET_EHIP) wait(p_sequencer.env.spy_if.ehip_reset==1'b0 && p_sequencer.env.spy_if.ehip_reset_ack==1'b1);

      //Pull reset_ack “0” When => ehip_rx_reset_out_reg ==0 , ehip_rx_reset_ack_in !=0 - 5
      if(state==RESET_EHIP_RX) wait(p_sequencer.env.spy_if.ehip_reset_rx==1'b0 && p_sequencer.env.spy_if.ehip_reset_ack_rx==1'b1);

      //Pull reset_ack “0” When => ehip_tx_reset_out_reg ==0 , ehip_tx_reset_ack_in !=0
      if(state==RESET_EHIP_TX) wait(p_sequencer.env.spy_if.ehip_reset_tx==1'b0 && p_sequencer.env.spy_if.ehip_reset_ack_tx==1'b1);

      `uvm_info("eth_reset_state_code_coverage", "Forcing reset_ack to 0\n",UVM_LOW)
      `ifndef CRETE3
      uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
      `else
       `ifdef FALCON_MESA
       uvm_hdl_force("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_fm_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
       `else
      uvm_hdl_force("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
	`endif //FALCON_MESA
      `endif

      wait(p_sequencer.env.spy_if.ehip_reset_state==RESUME_RESET); // RESUME_RESET state

      `uvm_info("eth_reset_state_code_coverage", "Releasing reset_ack\n",UVM_LOW)
      `ifndef CRETE3
      uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.ehip_rst_seqinst.reset_ack");
      `else
       `ifdef FALCON_MESA
       uvm_hdl_release("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_fm_reset_controller_inst.ehip_rst_seqinst.reset_ack");
       `else 
      uvm_hdl_release("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_reset_controller_inst.ehip_rst_seqinst.reset_ack");
        `endif //FALCON_MESA
       `endif

      if(state==RESET_EHIP) begin //if EHIP_RESET
        wait(p_sequencer.env.spy_if.ehip_reset_state==DEASSERT_EHIP_TX); //DEASSERT_EHIP_TX 
        wait(p_sequencer.env.spy_if.ehip_reset_state==WAIT_FOR_EHIP_READY); //WAIT_FOR_EHIP_READY 

        //Pull reset_ack “0” When => ehip_ready!=1 and 4&5 is acieve
        if(p_sequencer.env.master_agent.mast_agt_if.ehip_ready==0) begin
          `uvm_info("eth_reset_state_code_coverage", "Forcing reset_ack to 0\n",UVM_LOW)
          `ifndef CRETE3
          uvm_hdl_force("eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
          `else
          `ifdef FALCON_MESA
           uvm_hdl_force("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_fm_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
	   `else
          uvm_hdl_force("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_reset_controller_inst.ehip_rst_seqinst.reset_ack",1'b0);
	   `endif //FALCON_MESA
          `endif

          wait(p_sequencer.env.spy_if.ehip_reset_state==RESUME_RESET); // RESUME_RESET state

          `uvm_info("eth_reset_state_code_coverage", "Releasing reset_ack\n",UVM_LOW)
          `ifndef CRETE3
          uvm_hdl_release("eth_env_top.dut.top.alt_ehipc2_reset_controller_inst.ehip_rst_seqinst.reset_ack");
          `else
          `ifdef FALCON_MESA
           uvm_hdl_release("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_fm_reset_controller_inst.ehip_rst_seqinst.reset_ack");
           `else
          uvm_hdl_release("eth_env_top.dut.top.RST_CTRL_100G.alt_ehipc3_reset_controller_inst.ehip_rst_seqinst.reset_ack");
           `endif //FALCON_MESA
          `endif
        end

      end
    end
    join

    //p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    if(state==RESET_EHIP)    p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
    if(state==RESET_EHIP_RX) p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(1),.ip_sync(0));
    if(state==RESET_EHIP_TX) p_sequencer.env.wait_for_linkup(.tx_sync(1),.rx_sync(0),.ip_sync(0));
    send_frames();
    #2us;

 endtask

  virtual task body();
    `uvm_info("eth_reset_state_code_coverage", "running  eth_reset_state_code_coverage sequence\n",UVM_LOW)

    coverage_scenario(RESET_EHIP,DEASSERT_EHIP);
    coverage_scenario(RESET_EHIP_RX,DEASSERT_EHIP_RX);
    coverage_scenario(RESET_EHIP_TX,DEASSERT_EHIP_TX);

  endtask

  task send_frames();
   `ifdef ENABLE_ETH_VIP
      fork
        send_eth_frame(DATA_FRAME,ETH_VIP_AVL_RX,10);  
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
      join
   `else
        send_eth_frame(DATA_FRAME,AVL_TX_ETH_VIP,10);  
   `endif
  endtask

endclass
