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


//------------------------------------------------------------------------------------------
// The test intenstion was to create a underflow, when the valid signal is de-asserted
// in between of data transmission, as the valid goes low the MAC should not read data 
// from the FIFOs above it ports causing intrupsion in the data rate, and the status
// register checking the underflowrflow shouldld get asserted. But as per designer there
// a adaptor layer between which ignores the valid and accepts complete data, which will
// prevent the underflow senario to occure. Currently this info should be specificly 
// mentioned in the user guide.  
//------------------------------------------------------------------------------------------

class ptp_frames_underflow_sequence extends eth_ptp_base_sequence;
  `uvm_object_utils(ptp_frames_underflow_sequence)
   ptp_base_size_sequence eth_seq;
  eth_ptp_config_sequence eth_ptp_config_seq;
 eth_transaction_frame_type f_type;
int size;
int mix_rule;
bit [31:0] rd_data;
int delay;

  function new(string name = "ptp_frame_sizes_sequence");
    super.new(name);
	  `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
 endfunction:new

 virtual task body();
  int i;

  `uvm_do(eth_ptp_config_seq)
   p_sequencer.env.wait_for_linkup(.tx_sync(0),.rx_sync(0),.ip_sync(1));
   $display("rx pcs ready received"); 

    `uvm_info("eth_ptp_base_sequence", "Waiting for TX PTP Ready\n",UVM_LOW)
    wait (p_sequencer.env.spy_if.o_tx_ptp_ready === 1'b1);
    `uvm_info("eth_ptp_base_sequence", "TX PTP ready\n",UVM_LOW)

    `uvm_info("ptp_frames_underflow_sequence", "Waiting for RX PTP Ready\n",UVM_LOW)
    wait (p_sequencer.env.spy_if.o_rx_ptp_ready === 1'b1);
    `uvm_info("ptp_frames_underflow_sequence", "RX PTP ready\n",UVM_LOW)
      

for( i=0; i <=1; ++i);
begin		  
  if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
    //Actual PTP traffic after PTP ready
    `uvm_create_on(eth_seq, p_sequencer.tx_seqr);
  end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
    //Actual PTP traffic after PTP ready
    `uvm_create_on(eth_seq, p_sequencer.v_m_sqr);
  end  

 std::randomize(f_type) with {f_type inside {ETH_DATA_FRAME};};
 std::randomize(mix_rule) with {mix_rule ==3 ;}; //1 is all v1 frames, 3 without v1 is 2
 delay = $urandom_range(0,3);
 $display("\n\n\n\n\n*****DELAY=%d***Loop=%d***\n\n\n\n\n",delay,i);
     

     eth_seq.fb609905_rule = mix_rule;
     eth_seq.pl_size = $urandom_range(64,400);
     eth_seq.fr_type = f_type;
     eth_seq.ptp = 1;;
     eth_seq.sequence_length = 10;
    if(i == 0) p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 1;
    else  p_sequencer.env.sb_mac_tx_vip_rx.scb_dis = 0;

     eth_seq.num_words_local = (p_sequencer.env.spy_if.speed == _10G) ? 1: //[TODO] Need to update with actual values
                        (p_sequencer.env.spy_if.speed == _25G) ? 1:
                        (p_sequencer.env.spy_if.speed == _40G) ? 2:
                        (p_sequencer.env.spy_if.speed == _50G) ? 2:
                        (p_sequencer.env.spy_if.speed == _100G)? 4:
                        (p_sequencer.env.spy_if.speed == _200G)? 8:16;
   if(i == 0)
   begin
      fork
       begin
        if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
           eth_seq.start(p_sequencer.tx_seqr);
        end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
           eth_seq.start(p_sequencer.v_m_sqr);
        end 
       end
       begin
        #(delay*1us);
        wait(p_sequencer.env.spy_if.avst_tx_sop == 1'b1);
        #30ns;
         uvm_hdl_force("eth_env_top.tx_valid_ip0", 0);
         #1us;
         uvm_hdl_release("eth_env_top.tx_valid_ip0");
         wait(p_sequencer.env.spy_if.avst_tx_eop == 1'b1);
       end
      join
  
      #100us; 
   end
   else 
   begin
     if (p_sequencer.env.dyn_rcfg_obj_inst.mode == PCSMAC) begin 
         eth_seq.start(p_sequencer.tx_seqr);
      end else if(p_sequencer.env.dyn_rcfg_obj_inst.mode ==MACSEG) begin 
         eth_seq.start(p_sequencer.v_m_sqr);
      end 
   end
end
 
endtask
endclass : ptp_frames_underflow_sequence
