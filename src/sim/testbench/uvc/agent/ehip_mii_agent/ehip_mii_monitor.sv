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
// (C) 2011-2014 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
// $File: //depot/avatar/crete3/ehip/uvc/agent/ehip_client_tx/src/uvc/ehip_mii_monitor.svh $
// $Revision: #4 $
// $Date: 2017/06/12 $
// $Author: reranki $
// Created by: utbgen.pl by Hoong Han Leong
//==============================================================================

`ifndef __EHIP_MII_MONITOR_SVH__
`define __EHIP_MII_MONITOR_SVH__

typedef class eth_packet;
//------------------------------------------------------------------------------
// Class: ehip_mii_monitor
//
//------------------------------------------------------------------------------
class ehip_mii_monitor extends uvm_monitor;

   //---------------------------------------------------------------------------
   // Class Variables
   //---------------------------------------------------------------------------
   virtual ehip_mii_tx_if   uif;
   virtual spy_interface    spy_if;
   dyn_rcfg          m_config;
   // Analysis ports
   uvm_analysis_port #(eth_packet) m_ap;
   int my_sop;
   int frame_no,my_frame_no;
   bit dis_check_bn_frames;
   bit ready_to_send=0;
   bit [3:0] prev_in_frame;
   bit found_sop;
   int found_sop_pos=99;
   bit sop_cycle[16];
   int speed_var;
   bit flag=0;
   bit found_eop;
   int found_eop_pos=99;
   bit found_eop_latch;
   bit check_mii_lane_data_eop_latch;
   int frm_count = 0;
   bit[7:0] packed_bytes[$];
   bit[7:0] packed_bytes_final[$];
   bit[7:0] packed_bytes_to_send[$];
   int packed_bytes_size;
   eth_packet transmitted_frame;
   eth_packet transmitted_frame2;
   bit[63:0] local_data[16];
   bit[63:0] local_data_latch[16];
   bit[63:0] local_data0, local_data1, local_data2, local_data3;
   bit[63:0] local_data0_latch, local_data1_latch, local_data2_latch, local_data3_latch; // previous cycle data is latched for validating start of frame on current cycle
   bit[63:0] local_data0_latchx2; // Only applicable for 10/25g. Latching previous to previous cycle data for validating start of frame on current cycle.
   bit[63:0] local_ctl[16];
   bit[63:0] local_ctl_latch[16];
   bit[7:0] local_ctl0, local_ctl1, local_ctl2, local_ctl3;
   bit[7:0] local_ctl0_latch, local_ctl1_latch, local_ctl2_latch, local_ctl3_latch; // previous cycle control correspond to latched-data
   bit[7:0] local_ctl0_latchx2;  // Only applicable for 10/25g. Latching previous to previous cycle control correspond to latched-data
   bit local_vld, local_am_insert;
   bit local_vld_latch, local_am_insert_latch;
   bit local_vld_latchx2, local_am_insert_latchx2;  // Only applicable for 10/25g. Latching valid data based on am_insert & valid
   bit found_fe = 1'b0;
   bit found_invalid_ctrl = 1'b0;
   bit found_idle = 1'b0;
   bit copy_buf_seen_extra_short_frame_tx_mon = 1'b0;
   bit[7:0] packed_bytes_to_send_q[$][$];
   eth_packet transmitted_frame_q[$];
   eth_packet get_tran_frame;
   bit ctl_data_before_start = 1'b0;
   bit found_sop_latch;
   bit load_0_1_2_3;
   bit load_1_2_3;
   bit load_2_3;
   bit load_3;
   bit frame_start_ =1'b0;
   int num_sig_os=0;
   bit found_first_sop_seg0;
   bit found_first_sop_seg1;
   bit found_first_sop_seg2;
   bit found_first_sop_seg3;
   bit found_sop_seg0;
   bit found_sop_seg1;
   bit found_sop_seg2;
   bit found_sop_seg3;
   bit sip_limit = 0;
   //---------------------------------------------------------------------------
   // Register class with factory
   //---------------------------------------------------------------------------
   `uvm_component_utils_begin(ehip_mii_monitor)
	`uvm_field_object(m_config,     UVM_PRINT)
   `uvm_component_utils_end
   
   //---------------------------------------------------------------------------
   // Constructor: new
   //---------------------------------------------------------------------------
   function new(string name, uvm_component parent);
     super.new(name, parent);
     found_first_sop_seg0 = 0;
     found_first_sop_seg1 = 0;
     found_first_sop_seg2 = 0;
     found_first_sop_seg3 = 0;
     found_sop_seg0 = 0;
     found_sop_seg1 = 0;
     found_sop_seg2 = 0;
     found_sop_seg3 = 0;      
   endfunction : new

   //---------------------------------------------------------------------------
   // Function: build_phase
   //---------------------------------------------------------------------------
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     m_ap = new("m_ap", this);
     if(get_name() == "mii_tx_mon") begin
       if(!uvm_config_db#(virtual ehip_mii_tx_if)::get(this, "", "mii_tx_if", uif)) begin
         `uvm_fatal("ehip_mii_mon","Virtul interface not configured!");
       end      
     end
     else begin
       if(!uvm_config_db#(virtual ehip_mii_tx_if)::get(this, "", "mii_rx_if", uif)) begin
         `uvm_fatal("ehip_mii_mon","Virtul interface not configured!");
       end      
     end
       if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_if_mii", spy_if)) begin
         `uvm_fatal("ehip_mii_mon","Virtul interface not configured!");
       end      
     if(!uvm_config_db#(dyn_rcfg)::get(this, "", "dyn_rcfg_obj_inst", m_config))begin
      `uvm_error("ehip_mii_tx_mon","config object is not found"); 
     end

   endfunction : build_phase

   //---------------------------------------------------------------------------
   // Task: run_phase
   //---------------------------------------------------------------------------
   task run_phase(uvm_phase phase);
    fork
      update_dyn_objects();
      collect_tran();
      monitor_dut();
    join
   endtask : run_phase
   task update_dyn_objects();
       forever begin
           @(uif.clk);
           speed_var=(m_config.speed==_10G)?1:
                     (m_config.speed==_25G)?1:
                     (m_config.speed==_40G)?2:
                     (m_config.speed==_50G)?2:
                     (m_config.speed==_100G)?4:
                     (m_config.speed==_200G)?8:16;
           `uvm_info(get_name(),$sformatf("value of speed_var %0d",speed_var),UVM_DEBUG)
       end
   endtask
   //---------------------------------------------------------------------------
   // Task: collect_tran
   //---------------------------------------------------------------------------
   task collect_tran();
      // Local transaction to capture the variables
      eth_packet   m_tran, t;
      eth_packet   m_tran_q [$];
      int m_tran_q_size;

      forever 
        begin : b_FOREVER_COLLECT_TRAN
           get_tran(m_tran_q);
           m_tran_q_size = m_tran_q.size(); 
           `uvm_info(get_name(), $sformatf("Got xactions m_tran_q_size :%d",m_tran_q_size), UVM_DEBUG)
           for(int i=0;i<m_tran_q_size; i++) begin 
             m_tran = eth_packet::type_id::create("m_tran");
             m_tran = m_tran_q.pop_front(); 
             $cast(t, m_tran.clone());
             write_to_analysis_port(t);
             `uvm_info(get_name(), $sformatf("Collected transaction ->\n%0s", m_tran.sprint()), UVM_MEDIUM)
            end
        end : b_FOREVER_COLLECT_TRAN

   endtask : collect_tran

   //---------------------------------------------------------------------------
   // task: get_tran
   //---------------------------------------------------------------------------
   task get_tran(output eth_packet _tran_q[$]);
     `uvm_info(get_name(), $sformatf("get_tran -> Started"), UVM_DEBUG)

     while(ready_to_send !== 1) begin
       @(uif.mon_cb);
     end

     `uvm_info(get_name(), $sformatf("get_tran -> Got frame, ready to send"), UVM_DEBUG)

     //Multiple frames possible in a single cycle, copying over all frames
     _tran_q = transmitted_frame_q;

     `uvm_info(get_name(),$sformatf("_tran_q.size:%d, transmitted_frame_q.size() :%d", _tran_q.size(),transmitted_frame_q.size()), UVM_DEBUG)
     `uvm_info(get_name(), $sformatf("get_tran -> Ended"), UVM_DEBUG)
     transmitted_frame_q.delete();
     ready_to_send = 0;
   endtask : get_tran

   //---------------------------------------------------------------------------
   // Function: write_to_analysis_port
   //---------------------------------------------------------------------------
   function void write_to_analysis_port(eth_packet t);
      m_ap.write(t);
   endfunction : write_to_analysis_port
  
   //---------------------------------------------------------------------------
   // task: check_for_more_sops
   //---------------------------------------------------------------------------
   task check_for_more_sops(bit[3:0] current_eop);
     `uvm_info(get_name(),$sformatf("inside check_for_more_sops %0d",current_eop),UVM_DEBUG)
     if(current_eop == speed_var) begin
	     found_eop=0;
     end
     else begin
      //chethan  if((find_fb(local_data[speed_var-current_eop][63:56],local_ctl[speed_var-current_eop][7]))) begin
      //chethan     found_sop = 1'b1;
      //chethan     found_sop_pos = current_eop-1;
      //chethan     sop_cycle[found_sop_pos] = 1'b1;
      //chethan     if(found_sop == 1) begin
      //chethan       find_eop(found_sop_pos); 
      //chethan       if(found_eop == 1) begin
      //chethan         `uvm_info(get_name(), $sformatf("current_eop position: segment 3 Found next EOP for sop@segment 2, setting trigger"), UVM_DEBUG)
      //chethan         found_eop = 0;
      //chethan         found_eop_pos = 99;

      //chethan       end
      //chethan     end
      //chethan  end
       for(int i=current_eop;i<speed_var;i++) begin
         if(found_sop == 0) begin
          if(find_fb(local_data[i][63:56],local_ctl[i][7])) begin
               found_sop = 1'b1;
               found_sop_pos = i;
               sop_cycle[found_sop_pos] = 1'b1;
            if(found_sop == 1) begin
              find_eop(found_sop_pos); 
              if(found_eop == 1) begin
                `uvm_info(get_name(), $sformatf("current_eop position: segment 3 Found next EOP for sop@segment 1, setting trigger"), UVM_DEBUG)
                found_eop = 0;
                found_eop_pos = 99;
              end
            end
         end
       end
       end
     end
   endtask :check_for_more_sops

   //---------------------------------------------------------------------------
   // task : check_for_more_sops_50gx2
   //---------------------------------------------------------------------------
   task check_for_more_sops_50gx2(bit[3:0] current_eop);
     case(current_eop)
     4'd3: begin //eop in segment 3, look for next sop in same cycle
       if((find_fb(local_data1[63:56],local_ctl1[7]))) begin
          found_sop = 1'b1;
          found_sop_pos = 0;
          //sop_cycle_0 = 1'b1;//notused[muralasx]
       end
       if(found_sop == 1) begin
         find_eop(found_sop_pos); //find eop with sop starting at segment 2
         if(found_eop == 1) begin
           `uvm_info(get_name(),$sformatf("check_for_more_sops_50gx2: current_eop position: segment 3 Found next EOP for sop@segment 2, setting trigger"), UVM_DEBUG)
           found_eop = 0;
           found_eop_pos = 99;
         end
       end
     end
     4'd2: begin //sop in segment 0, do nothing
		found_eop = 0;
     end
     endcase
   endtask :check_for_more_sops_50gx2
   //---------------------------------------------------------------------------
   // function: find_fb
   //---------------------------------------------------------------------------
   function bit find_fb(bit[7:0] data_byte, bit control_bit);
     `uvm_info(get_name(),$sformatf("inside find_fb data_byte %0h control_bit %0h",data_byte,control_bit),UVM_DEBUG)
	   if(data_byte == 8'hfb && control_bit == 1) begin
      my_sop++;
		  return 1;
	   end
	   else begin
		  return 0;
	   end
   endfunction : find_fb

   //---------------------------------------------------------------------------
   // function: find_fd_or_fb
   //---------------------------------------------------------------------------
   function bit[7:0] find_fd_or_fb(bit[63:0] data_byte, bit[7:0] control_bit);
     `uvm_info(get_name(),$sformatf("inside find_fd_or_fb data_byte %0h control_bit %0h",data_byte,control_bit),UVM_DEBUG)

     //sanity logic for fd and idle
     if      (data_byte[63:56] == 8'hfd && control_bit[7] == 1) return 8'b1000_0000;

     else if (data_byte[55:48] == 8'hfd && control_bit[6] == 1) return 8'b0100_0000;
     //else if (data_byte[55:48] == 8'h07 && control_bit[6] == 1) return 8'b0100_0000;

     else if (data_byte[47:40] == 8'hfd && control_bit[5] == 1) return 8'b0010_0000;
     //else if (data_byte[47:40] == 8'h07 && control_bit[5] == 1) return 8'b0010_0000;

     else if (data_byte[39:32] == 8'hfd && control_bit[4] == 1) return 8'b0001_0000;
     //else if (data_byte[39:32] == 8'h07 && control_bit[4] == 1) return 8'b0001_0000;

     else if (data_byte[31:24] == 8'hfd && control_bit[3] == 1) return 8'b0000_1000;
     //else if (data_byte[31:24] == 8'h07 && control_bit[3] == 1) return 8'b0000_1000;

     else if (data_byte[23:16] == 8'hfd && control_bit[2] == 1) return 8'b0000_0100;
     //else if (data_byte[23:16] == 8'h07 && control_bit[2] == 1) return 8'b0000_0100;

     else if (data_byte[15:8] == 8'hfd && control_bit[1] == 1) return 8'b0000_0010;
     //else if (data_byte[15:8] == 8'h07 && control_bit[1] == 1) return 8'b0000_0010;

     else if (data_byte[7:0] == 8'hfd && control_bit[0] == 1) return 8'b0000_0001;
     //else if (data_byte[7:0] == 8'h07 && control_bit[0] == 1) return 8'b0000_0001;

          //sanity logic for fd and idle
   /*  if      (data_byte[63:56] == 8'hfb && control_bit[7] == 1) return 8'b0000_0001;

     else if (data_byte[55:48] == 8'hfb && control_bit[6] == 1) return 8'b0000_0010;
     //else if (data_byte[55:48] == 8'h07 && control_bit[6] == 1) return 8'b0100_0000;

     else if (data_byte[47:40] == 8'hfb && control_bit[5] == 1) return 8'b0000_0100;
     //else if (data_byte[47:40] == 8'h07 && control_bit[5] == 1) return 8'b0010_0000;

     else if (data_byte[39:32] == 8'hfb && control_bit[4] == 1) return 8'b0000_1000;
     //else if (data_byte[39:32] == 8'h07 && control_bit[4] == 1) return 8'b0001_0000;

     else if (data_byte[31:24] == 8'hfb && control_bit[3] == 1) return 8'b0001_0000;
     //else if (data_byte[31:24] == 8'h07 && control_bit[3] == 1) return 8'b0000_1000;

     else if (data_byte[23:16] == 8'hfb && control_bit[2] == 1) return 8'b0010_0000;
     //else if (data_byte[23:16] == 8'h07 && control_bit[2] == 1) return 8'b0000_0100;

     else if (data_byte[15:8] == 8'hfb && control_bit[1] == 1) return 8'b0100_0000;
     //else if (data_byte[15:8] == 8'h07 && control_bit[1] == 1) return 8'b0000_0010;

     else if (data_byte[7:0] == 8'hfb && control_bit[0] == 1) return 8'b1000_0000;
     //else if (data_byte[7:0] == 8'h07 && control_bit[0] == 1) return 8'b0000_0001;
     */
     
     else begin
       return 0;
     end
   endfunction : find_fd_or_fb
   
   
   function bit[7:0] find_fb_25G(bit[63:0] data_byte, bit[7:0] control_bit);
     `uvm_info(get_name(),$sformatf("inside find_fb_25g data_byte %0h control_bit %0h",data_byte,control_bit),UVM_DEBUG)
   if      (data_byte[63:56] == 8'hfb && control_bit[7] == 1) return 8'b0000_0001;

     else if (data_byte[55:48] == 8'hfb && control_bit[6] == 1) return 8'b0000_0010;
     //else if (data_byte[55:48] == 8'h07 && control_bit[6] == 1) return 8'b0100_0000;

     else if (data_byte[47:40] == 8'hfb && control_bit[5] == 1) return 8'b0000_0100;
     //else if (data_byte[47:40] == 8'h07 && control_bit[5] == 1) return 8'b0010_0000;

     else if (data_byte[39:32] == 8'hfb && control_bit[4] == 1) return 8'b0000_1000;
     //else if (data_byte[39:32] == 8'h07 && control_bit[4] == 1) return 8'b0001_0000;

     else if (data_byte[31:24] == 8'hfb && control_bit[3] == 1) return 8'b0001_0000;
     //else if (data_byte[31:24] == 8'h07 && control_bit[3] == 1) return 8'b0000_1000;

     else if (data_byte[23:16] == 8'hfb && control_bit[2] == 1) return 8'b0010_0000;
     //else if (data_byte[23:16] == 8'h07 && control_bit[2] == 1) return 8'b0000_0100;

     else if (data_byte[15:8] == 8'hfb && control_bit[1] == 1) return 8'b0100_0000;
     //else if (data_byte[15:8] == 8'h07 && control_bit[1] == 1) return 8'b0000_0010;

     else if (data_byte[7:0] == 8'hfb && control_bit[0] == 1) return 8'b1000_0000;
     //else if (data_byte[7:0] == 8'h07 && control_bit[0] == 1) return 8'b0000_0001;
     
     
     else begin
       return 0;
     end
   endfunction
   //---------------------------------------------------------------------------
   // Task: monitor_dut
   // Monitor DUT interface activity and extract out useful information.
   //---------------------------------------------------------------------------
   task automatic monitor_dut();

    forever 
    begin : _FOREVER_MONITOR_DUT

    if(get_name()== "mii_rx_mon") begin
       
      if((uif.mon_cb.rx_blk_lock !== 1)  || (((m_config.speed!=_10G)&&(m_config.speed!=_25G))&&uif.mon_cb.rx_am_lock !== 1) )begin
	while((uif.mon_cb.rx_blk_lock !== 1) || (((m_config.speed!=_10G)&&(m_config.speed!=_25G))&&uif.mon_cb.rx_am_lock !== 1))begin
	  @(uif.mon_cb);
        end
	flush_rx_mon();
        `uvm_info(get_name(),$sformatf("got DUT lock"),UVM_DEBUG)
      end 
      @(uif.mon_cb);
    end 

    reverse_bytes();

    if(get_name()== "mii_tx_mon") begin
      @(uif.mon_cb);
    end  

    if((local_vld == 1) && (local_am_insert== 0))begin
       `uvm_info(get_name(), $sformatf("DBG_1 : found_sop = %0d, found_sop_pos =%0d",found_sop, found_sop_pos),UVM_NONE);

       for(int i=0;i<speed_var;i++) begin
         if((find_fb(local_data[i][63:56],local_ctl[i][7])) && (found_sop == 0)) begin //prev sop flags still active
           found_sop = 1'b1;
           found_sop_pos = i;//speed_var-i-1;
	   sop_cycle[found_sop_pos]=1'b1;
           `uvm_info(get_name(), $sformatf(" 0 found_sop = %0d  found_sop_pos :%d", found_sop, found_sop_pos), UVM_DEBUG)
         end
       end
       if( ( (find_fb(local_data[0][63:56],local_ctl[0][7])) || (find_fb(local_data[0][55:48],local_ctl[0][6])) || 
	   (find_fb(local_data[0][47:40],local_ctl[0][5])) || (find_fb(local_data[0][39:32],local_ctl[0][4])) || 
	   (find_fb(local_data[0][31:24],local_ctl[0][3])) || (find_fb(local_data[0][23:16],local_ctl[0][2])) ||
	   (find_fb(local_data[0][15:8],local_ctl[0][1]))  || (find_fb(local_data[0][7:0],local_ctl[0][0]))) &&  (found_sop == 0)) begin //prev sop flags still active
          
	   found_sop = 1'b1;
	   found_sop_pos = 0;
        end
       `uvm_info(get_name(), $sformatf("DBG_2 : found_sop = %0d, found_sop_pos =%0d",found_sop, found_sop_pos),UVM_NONE);
       if(found_sop == 1) begin

         find_eop(found_sop_pos); //find eop associated with sop starting at sop_pos

         //if eop found:
         //1.trigger sending packet to get_tran
         //2.check if more sops are present on same cycle. if so look for their eops to collect packet data
         //3.advance clk
         if(found_eop == 1) begin
           check_for_more_sops(found_eop_pos);
           found_eop = 0;
           found_eop_pos = 99;
         end
       end   //found_sop == 1 
     end //din_tx_vld

     end : _FOREVER_MONITOR_DUT
   endtask : monitor_dut

   //---------------------------------------------------------------------------
   // task: reverse_bytes
   //---------------------------------------------------------------------------
   task reverse_bytes();
     if(get_name() == "mii_tx_mon") begin
       local_vld <= uif.mon_cb.vld;
       local_am_insert <= uif.mon_cb.am_insert; 
     end
     else begin // mii_rx_mon
       local_vld <= (uif.mon_cb.vld & !((m_config.speed!=_10G && m_config.speed!=_25G)&uif.mon_cb.am) );
       local_am_insert <= uif.mon_cb.am;  // make this zero for rx monitor because this is related to tx_mon
     end  
     //chethan for(int i=0;i<speed_var;i++) begin
     //chethan   local_data[i] <= {uif.mon_cb.data[speed_var-i-1][7:0],  uif.mon_cb.data[speed_var-i-1][15:8], 
     //chethan                     uif.mon_cb.data[speed_var-i-1][23:16],uif.mon_cb.data[speed_var-i-1][31:24],
     //chethan                     uif.mon_cb.data[speed_var-i-1][39:32],uif.mon_cb.data[speed_var-i-1][47:40],
     //chethan                     uif.mon_cb.data[speed_var-i-1][55:48],uif.mon_cb.data[speed_var-i-1][63:56]};
     //chethan   local_ctl[i]  <= {uif.mon_cb.ctl[speed_var-i-1][0],uif.mon_cb.ctl[speed_var-i-1][1],
     //chethaN                     uif.mon_cb.ctl[speed_var-i-1][2],uif.mon_cb.ctl[speed_var-i-1][3],
     //chethan                     uif.mon_cb.ctl[speed_var-i-1][4],uif.mon_cb.ctl[speed_var-i-1][5],
     //chethan                     uif.mon_cb.ctl[speed_var-i-1][6],uif.mon_cb.ctl[speed_var-i-1][7]};
     //chethan  `uvm_info(get_name(), $sformatf("RX local data[%0d] - %0h local ctl[%0d] - %0h",i,local_data[i],i,local_ctl[i]),UVM_DEBUG)
     for(int i=0;i<speed_var;i++) begin
       local_data[i] <= {uif.mon_cb.data[i][7:0],  uif.mon_cb.data[i][15:8], 
                         uif.mon_cb.data[i][23:16],uif.mon_cb.data[i][31:24],
                         uif.mon_cb.data[i][39:32],uif.mon_cb.data[i][47:40],
                         uif.mon_cb.data[i][55:48],uif.mon_cb.data[i][63:56]};
       local_ctl[i]  <= {uif.mon_cb.ctl[i][0],uif.mon_cb.ctl[i][1],
                         uif.mon_cb.ctl[i][2],uif.mon_cb.ctl[i][3],
                         uif.mon_cb.ctl[i][4],uif.mon_cb.ctl[i][5],
                         uif.mon_cb.ctl[i][6],uif.mon_cb.ctl[i][7]};
      `uvm_info(get_name(), $sformatf("RX local data[%0d] - %0h local ctl[%0d] - %0h",i,local_data[i],i,local_ctl[i]),UVM_DEBUG)
               
     end

   endtask : reverse_bytes

   //---------------------------------------------------------------------------
   // Task: find_eop
   //---------------------------------------------------------------------------
//   task find_eop(bit[3:0] sop);
//    int index;
//    `uvm_info(get_name(),$sformatf("inside find_eop step1"),UVM_DEBUG)
//    `uvm_info(get_name(),$sformatf("inside find_eop packed_bytes %0d",packed_bytes.size()),UVM_DEBUG)
//       if(sop_cycle[sop] ==1 && sop!= (speed_var-1)) begin
//    `uvm_info(get_name(),$sformatf("inside find_eop step2"),UVM_DEBUG)
//	       for(int i=0;i<sop+1;i++) begin
//		       index=speed_var-sop-1+i;
//                 if(find_fd_or_fb(local_data[index],local_ctl[index]) != 8'b0 && flag==0) begin
//		      for(int l=0;l<index-1;l++) load_complete_word(local_data[speed_var-sop+l]);
//                      load_partial_word(local_data[index],find_fd_or_fb(local_data[index],local_ctl[index]));
//                      found_eop = 1;
//                      found_eop_pos = sop-i;
//		      flag=1;
//		 end
//	       end
//	       if(!flag)begin
//		 for(int i=0;i<sop+1;i++) begin
//		    load_complete_word(local_data[speed_var-sop-1+i]);
//		 end
//                 found_eop = 0;
//                 found_eop_pos = 99;
//	       end
//            sop_cycle[sop] = 0;
//	    flag=0;
//       end
//    else begin
//    `uvm_info(get_name(),$sformatf("inside find_eop step3"),UVM_DEBUG)
//       for(int i=0;i<speed_var;i++) begin
//          if(find_fd_or_fb(local_data[i],local_ctl[i]) != 8'b0 && flag==0) begin
//            for(int j=0;j<i;j++) load_complete_word(local_data[j]);
//            load_partial_word(local_data[i],find_fd_or_fb(local_data[i],local_ctl[i]));
//            found_eop = 1;
//            found_eop_pos = speed_var-i-1;
//	    flag=1;
//	    if(i==(speed_var-1))begin//version2.0
//	      found_sop = 1'b0;
//	      found_eop_latch=1;
//	      load_0_1_2_3 =1;
//              found_eop = 1'b0; //version3.0
//	    end
//          end
//       end
//       if(!flag)begin
//    `uvm_info(get_name(),$sformatf("inside find_eop step4"),UVM_DEBUG)
//	  for(int i=0;i<speed_var;i++) load_complete_word(local_data[i]);
//	  if((speed_var-1)==sop)begin//version2.0
//    `uvm_info(get_name(),$sformatf("inside find_eop step5"),UVM_DEBUG)
//          end
//	  else begin
//	  found_eop=0;
//	  found_eop_pos=99;
//    `uvm_info(get_name(),$sformatf("inside find_eop step6"),UVM_DEBUG)
//	  end
//       end
//       flag=0;
//    end
//    
//
//   endtask :find_eop

   //---------------------------------------------------------------------------
   // Task: find_eop
   //---------------------------------------------------------------------------
    task find_eop(bit[3:0] sop);

         `uvm_info(get_name(),$sformatf("inside find_eop "),UVM_DEBUG)
        if(speed_var == 1) begin
	        if(find_fb_25G(local_data[0],local_ctl[0]) != 8'b0) begin
	            load_partial_word_25G(local_data[0],find_fb_25G(local_data[0],local_ctl[0]));
	        end
	        else begin
                if(find_fd_or_fb(local_data[0],local_ctl[0]) != 8'b0) begin
                    load_partial_word(local_data[0],find_fd_or_fb(local_data[0],local_ctl[0]));
                    found_eop = 1;
                    found_eop_pos = 3;
                end
                else begin
                    load_complete_word(local_data[0]);
                    found_eop = 0;
                    found_eop_pos = 99;
                end
            end
        end
        else begin
                 `uvm_info(get_name(),$sformatf("inside find_eop step1"),UVM_DEBUG)
                 if(sop_cycle[sop] == 1) begin
                    `uvm_info(get_name(),$sformatf("inside find_eop step2"),UVM_DEBUG)
                       for(int j=sop;j<speed_var;j++) begin //for_1
                          if((find_fd_or_fb(local_data[j],local_ctl[j]) != 8'b0) ) begin
                             load_partial_word(local_data[j],find_fd_or_fb(local_data[j],local_ctl[j]));
                             found_eop = 1;
                             found_eop_pos = j;
                             flag = 1; 
                             break;
                            end
                          else
                           if(flag ==0)
                             begin
                              load_complete_word(local_data[j]);
                             `uvm_info(get_name(),$sformatf(" inside find_eop step2 local_data = %h j=%d",local_data[j],j),UVM_DEBUG)
                              found_eop = 0;
                              found_eop_pos = 99;
                            end
                        end //for_1
                    sop_cycle[sop] = 0;
                   flag = 0;
                  end //if-end
               else begin
                 for(int j=0;j<speed_var;j++) begin //for_2
                   //chethan if(find_fd_or_fb(local_data[j],local_ctl[j]) != 8'b0) begin
                   if((find_fd_or_fb(local_data[j],local_ctl[j]) != 8'b0)) begin
                    load_partial_word(local_data[j],find_fd_or_fb(local_data[j],local_ctl[j]));
                    found_eop = 1;
                    found_eop_pos = j;
                    `uvm_info(get_name(),$sformatf(" inside find_eop step3a local_data = %h  found_eop_pos=%d",local_data[j],j),UVM_LOW)
                    flag = 1; 
                    break;
                   end
                   else 
                    if(flag ==0)
                    begin
                      load_complete_word(local_data[j]);
                      `uvm_info(get_name(),$sformatf(" inside find_eop step3 local_data = %h j=%d",local_data[j],j),UVM_DEBUG)
                      found_eop = 0;
                      found_eop_pos = 99;
                   end
                  end //for_2  
              end // else_end
          flag = 0; 
       end
   endtask :find_eop

   //---------------------------------------------------------------------------
   // Task: load_partial_word
   //---------------------------------------------------------------------------
   task load_partial_word(bit[63:0] word, bit[7:0] control_bits);

    `uvm_info(get_name(),$sformatf("inside load_partial_word word %0h control_bits %0h",word,control_bits),UVM_DEBUG)
     case(control_bits)
       8'b0000_0001: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
          packed_bytes.push_back(word[15:8]);
       end
       8'b0000_0010: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
       end
       8'b0000_0100: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
       end
       8'b0000_1000: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);

       end
       8'b0001_0000: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);

       end
       8'b0010_0000: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);

       end
       8'b0100_0000: begin
          packed_bytes.push_back(word[63:56]);
       end
       8'b1000_0000: begin
         //Load nothing, FD at beginning of word
       end

     endcase

     copy_buffer();
     found_sop_latch = found_sop;
     found_sop = 0;
     frame_start_ = 1'b0;
     construct_frame();

   endtask : load_partial_word

 task load_partial_word_25G(bit[63:0] word, bit[7:0] control_bits);
    `uvm_info(get_name(),$sformatf("inside load_partial_word_25g word %0h control_bits %0h",word,control_bits),UVM_DEBUG)
      case(control_bits)
       8'b0000_0001: begin
          packed_bytes.push_back(word[63:56]);
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
          packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);
       end
       8'b0000_0010: begin
          packed_bytes.push_back(word[55:48]);
          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
	  packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);
       end
       8'b0000_0100: begin

          packed_bytes.push_back(word[47:40]);
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
          packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);
       end
       8'b0000_1000: begin
     
          packed_bytes.push_back(word[39:32]);
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
          packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);

       end
       8'b0001_0000: begin
 
          packed_bytes.push_back(word[31:24]);
          packed_bytes.push_back(word[23:16]);
          packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);

       end
       8'b0010_0000: begin

          packed_bytes.push_back(word[23:16]);
          packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);

       end
       8'b0100_0000: begin

          packed_bytes.push_back(word[15:8]);
	  packed_bytes.push_back(word[7:0]);
       end
       8'b1000_0000: begin

	  packed_bytes.push_back(word[7:0]);
       end

     endcase
  endtask
   //---------------------------------------------------------------------------
   // Task: load_complete_word
   //---------------------------------------------------------------------------
   task load_complete_word(bit[63:0] word);
   `uvm_info(get_name(),$sformatf("load_complete_word %0h",word),UVM_LOW)
     packed_bytes.push_back(word[63:56]);
     packed_bytes.push_back(word[55:48]);
     packed_bytes.push_back(word[47:40]);
     packed_bytes.push_back(word[39:32]);
     packed_bytes.push_back(word[31:24]);
     packed_bytes.push_back(word[23:16]);
     packed_bytes.push_back(word[15:8]);
     packed_bytes.push_back(word[7:0]);
   endtask : load_complete_word

   //---------------------------------------------------------------------------
   // Task: copy_buffer
   //---------------------------------------------------------------------------
   task copy_buffer();
   `uvm_info(get_name(),$sformatf("copy_buffer"),UVM_DEBUG)
   `uvm_info(get_name(),$sformatf("packed_bytes size %0d",packed_bytes.size()),UVM_DEBUG)
    packed_bytes_size=packed_bytes.size();
     for(int i = 0; i < packed_bytes_size; i++) begin
       packed_bytes_to_send.push_back(packed_bytes.pop_front());
     end
   `uvm_info(get_name(),$sformatf("packed_bytes size %0d packed_bytes_to_send %0d",packed_bytes.size(),packed_bytes_to_send.size()),UVM_DEBUG)
     packed_bytes_to_send_q.push_back(packed_bytes_to_send);
     packed_bytes_to_send.delete();
     packed_bytes_size=0;
   endtask : copy_buffer

   //---------------------------------------------------------------------------
   // Task: construct_frame
   //---------------------------------------------------------------------------
   task construct_frame();

     transmitted_frame = eth_packet::type_id::create("transmitted_frame");

     packed_bytes_final = packed_bytes_to_send_q.pop_front();
     transmitted_frame.packed_bytes        = new[packed_bytes_final.size()];
     `uvm_info(get_name(),$sformatf("inside construct_frame packed_bytes_final %0h",packed_bytes_final.size()),UVM_LOW)
     foreach(transmitted_frame.packed_bytes[i]) begin
       transmitted_frame.packed_bytes[i]  = packed_bytes_final.pop_front();
     end

     transmitted_frame.extra_short_frame = 0;
     //Exception - To avoid run time error (Error-[DT-NV] Negative value), if DUT incorrectly decodes start character and end character when we insert skew
     if(transmitted_frame.packed_bytes.size() <= 25) 
       transmitted_frame.unpack_bytes_extra_short_frame(1,1);
     else if (sip_limit == 1) begin //HSD:16013867273
       `uvm_info("ehip_mii_rx_monitor","sip_limit is set 1",UVM_MEDIUM);	     
       transmitted_frame.unpack_bytes(1'b1,1'b1,"vip_tx_mac_rx",1'b1);
     end  
     else
       transmitted_frame.unpack_bytes(/*m_config.enable_rx_crc_passthrough*/1'b1,/*m_config.preamble_passthrough*/1'b1);
     //transmitted_frame.fcs={<<byte{transmitted_frame.fcs}};

     `uvm_info(get_name(),$sformatf("inside construct_frame packed bytes in transmitted %0h",transmitted_frame.packed_bytes.size()),UVM_DEBUG)

     transmitted_frame_q.push_back(transmitted_frame);
     frm_count++;
     `uvm_info(get_name(), $sformatf("construct_frame transmitted_frame_q.size() :%d", transmitted_frame_q.size()), UVM_DEBUG)

     ready_to_send = 1;
     frame_no++;

   endtask : construct_frame

   function bit check_for_local_fault();
    //-------------------------------------------------------
    bit control;
    for(int i=0;i<speed_var;i++)begin
        if((uif.mon_cb.data[speed_var-i-1] == 64'h100_009C) && (uif.mon_cb.ctl[speed_var-i-1]))
            control++;
    end
    if(control==speed_var) begin
      `uvm_info("ehip_mii_rx_monitor_bfm", $sformatf("check_for_local_fault, pass"), UVM_MEDIUM)
        return(1);
    end
    else begin
      `uvm_info("ehip_mii_rx_monitor_bfm", $sformatf("check_for_local_fault, fail"), UVM_MEDIUM)
        return(0);
    end
         control=0;
    //-------------------------------------------------------
   endfunction: check_for_local_fault

   //---------------------------------------------------------------------------
   //Flush monitor state when required (during mid sim reset, other cases like
   //lock is loss 
   //---------------------------------------------------------------------------
    task flush_rx_mon();
      found_sop = 0;
      prev_in_frame = 0;
      found_eop = 0;
      found_first_sop_seg0 = 0;
      found_first_sop_seg1 = 0;
      found_first_sop_seg2 = 0;
      found_first_sop_seg3 = 0;
      found_sop_seg0 = 0;
      found_sop_seg1 = 0;
      found_sop_seg2 = 0;
      found_sop_seg3 = 0;
      packed_bytes.delete();
      packed_bytes_to_send.delete();
      packed_bytes_final.delete();
      packed_bytes_to_send_q.delete();
      `uvm_info("ehip_mii_rx_monitor_bfm", $sformatf("flushed monitor found_sop :%d", found_sop), UVM_DEBUG)
    endtask :flush_rx_mon

endclass : ehip_mii_monitor
                
`endif//__EHIP_MII_MONITOR_SVH__
