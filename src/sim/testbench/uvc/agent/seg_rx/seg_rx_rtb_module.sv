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


module seg_rx_rtb_module (client_rx_if uif_rx); 
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import eth_env_pkg::*;
   import vector_uvc_pkg::*;

   class monitor_concrete extends seg_rx_monitor_abstract;
   	eth_packet m_tran,m_tran_clone;
    vector_uvc_packet m_vec_tran,m_vec_tran_clone;
   	uvm_reg 	regs;
    uvm_reg_data_t read_data;
   	extern task collect_tran();
   	extern function int get_num_words();
   extern function bit[39:0] get_vec_data(int in_status); 
   extern function bit[6:0] get_vec_error(bit[1:0] in_error,int eop_pos); 
   endclass 
   	 //
   // Task: collect_tran
   //
   // Task to call the BFM's get_*tran task and write the collected
   // transaction into the analysis port.
   //
   task monitor_concrete::collect_tran();
   	int repeat_num,j,size,eop_pos,sop_pos,num_word;
   	bit [31:0] rx_preamble_pass;
        int max_extra_short_frame_size;

   	m_tran = eth_packet::type_id::create("m_tran");
   	m_vec_tran = vector_uvc_packet::type_id::create("m_vec_tran");

      num_word=get_num_words();
      forever 
      begin 
         while(uif_rx.mon_cb.found_sop!==1)
            @(uif_rx.mon_cb);
         
         //sop_pos= uif_rx.found_sop_pos.pop_front();
         //debug
         if(uif_rx.found_sop_pos.size()>0) begin
            sop_pos= uif_rx.found_sop_pos.pop_front();
            `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor found_sop_pos: %0d",sop_pos), UVM_LOW);
            
            foreach(uif_rx.mon_cb.in_frame[i])begin
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor inframe[%0d]: %0d -- 0",i,uif_rx.mon_cb.in_frame[i]), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor sop[%0d]: %0d , sop_pos: %0d -- 0",i,uif_rx.sop[i],sop_pos), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor eop[%0d]: %0d , eop_pos: %0d -- 0",i,uif_rx.eop[i],eop_pos), UVM_HIGH);
            end         
         end      
      
      
         size = num_word - sop_pos;
         m_tran.seg_packed_bytes=new[size]; 
         foreach(m_tran.seg_packed_bytes[i])
            m_tran.seg_packed_bytes[i]= uif_rx.mon_cb.data[sop_pos+i];
         $display("monitor_concrete:%t seg seg_packed_bytes is %p",$time,m_tran.seg_packed_bytes);
         if(uif_rx.found_eop_pos.size()>0) begin
            eop_pos=uif_rx.found_eop_pos.pop_front();
            `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor found_eop_pos: %0d",eop_pos), UVM_LOW);
         end   
         
         if(uif_rx.mon_cb.found_eop==1 && (eop_pos > sop_pos))//sop & eop on the same cycle //make sure its not eop after sop situation 
         begin
         
            //DEBUG
            `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor in_frame_prev: %0d -- 1",uif_rx.mon_cb.in_frame_prev), UVM_LOW);
            foreach(uif_rx.mon_cb.in_frame[i])begin
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor inframe[%0d]: %0d -- 1",i,uif_rx.mon_cb.in_frame[i]), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor sop[%0d]: %0d , sop_pos: %0d -- 1",i,uif_rx.sop[i],sop_pos), UVM_HIGH);
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor eop[%0d]: %0d , eop_pos: %0d -- 1",i,uif_rx.eop[i],eop_pos), UVM_HIGH);
            end      
               
            m_tran.seg_packed_bytes=new[(eop_pos-sop_pos)+1](m_tran.seg_packed_bytes);
            m_tran.empty_bytes=uif_rx.mon_cb.eop_empty[eop_pos];
            m_vec_tran.status_data=get_vec_data(uif_rx.mon_cb.rx_status[eop_pos]);
            m_vec_tran.status_error=get_vec_error(uif_rx.mon_cb.rx_error[eop_pos],eop_pos);
            m_tran.rx_mac_error=get_vec_error(uif_rx.mon_cb.rx_error[eop_pos],eop_pos);
            `uvm_info(get_full_name(), $sformatf("rx_mac_error before FCS update is %d",m_tran.rx_mac_error), UVM_HIGH)
            `uvm_info(get_full_name(), $sformatf("vector status_error before FCS update is %d",m_vec_tran.status_error), UVM_HIGH)
            `uvm_info(get_full_name(), $sformatf("fcs_error value is %d for eop_pos value %d",uif_rx.mon_cb.fcs_error[eop_pos],eop_pos), UVM_HIGH)
            m_tran.rx_mac_error[1]=(uif_rx.mon_cb.fcs_error[eop_pos]);
            m_vec_tran.status_error[1]=(uif_rx.mon_cb.fcs_error[eop_pos]);
            `uvm_info(get_full_name(), $sformatf("rx_mac_error after FCS update is %d",m_tran.rx_mac_error), UVM_HIGH)
            `uvm_info(get_full_name(), $sformatf("vector status_error after FCS update is %d",m_vec_tran.status_error), UVM_HIGH)
            $display("monitor_concrete:%t seg seg_packed_bytes is %p",$time,m_tran.seg_packed_bytes);
            // get the pp & skip crc values from respective registers
            //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
            //DM_TODO: rx_preamble_pass = regs.get();
            //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,m_config.speed), 1 );
            //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
            //DM_TODO: read_data = regs.get_mirrored_value();
            `uvm_info(get_full_name(), $sformatf("CRC pass through RCVD at RX MAC = %0b,Preamble_passthrough %b",regs.get_mirrored_value(),rx_preamble_pass[0]), UVM_NONE)
             `uvm_info(get_full_name(),$sformatf("size of packet is %d",(m_tran.seg_packed_bytes.size()*8)),UVM_NONE)
            if (rx_preamble_pass[0] ==1 && read_data[0]==1)      max_extra_short_frame_size = 32; 
            else if (rx_preamble_pass[0] ==1 && read_data[0]==0) max_extra_short_frame_size = 24; 
            else if (rx_preamble_pass[0] ==0 && read_data[0]==0) max_extra_short_frame_size = 16; 
            else                                                 max_extra_short_frame_size = 24;

            if((m_tran.seg_packed_bytes.size()*8) <= max_extra_short_frame_size) m_tran.seg_unpack_bytes_extra_short_frame(read_data[0],rx_preamble_pass[0]);
              else  m_tran.seg_unpack_bytes(read_data[0],rx_preamble_pass[0]);

            m_tran.transaction_id++; //starting the transaction id from 0
            m_vec_tran.transaction_id++;
            $cast(m_tran_clone,m_tran.clone());
            mmbox.put(m_tran_clone);
            $cast(m_vec_tran_clone,m_vec_tran.clone());
            mmbox_vec.put(m_vec_tran_clone);
            
            ->spy_if.RX_SEG_PKT_RECEIVED;
            
            if(uif_rx.found_sop_pos.size()==0) // no more packets on the same cycle 
            @(uif_rx.mon_cb);		
         
         end
         else
         begin 
            while(uif_rx.mon_cb.found_eop==0 ||(uif_rx.mon_cb.found_eop==1 && (eop_pos < sop_pos))) begin // continue if eop pos <sop pos ie sop after eop
               @(uif_rx.mon_cb);
               while(!uif_rx.mon_cb.vld)begin
                  @uif_rx.mon_cb;
               end 
               if(uif_rx.mon_cb.found_eop==1) begin 
                  eop_pos=uif_rx.found_eop_pos.pop_front();
                  m_tran.empty_bytes=uif_rx.mon_cb.eop_empty[eop_pos];
                  m_vec_tran.status_data=get_vec_data(uif_rx.mon_cb.rx_status[eop_pos]);
                  m_vec_tran.status_error=get_vec_error(uif_rx.mon_cb.rx_error[eop_pos],eop_pos);
                  m_tran.rx_mac_error=get_vec_error(uif_rx.mon_cb.rx_error[eop_pos],eop_pos);
                  `uvm_info(get_full_name(), $sformatf("rx_mac_error before FCS update is %d",m_tran.rx_mac_error), UVM_HIGH)
                  `uvm_info(get_full_name(), $sformatf("fcs_error value is %d for eop_pos value %d",uif_rx.mon_cb.fcs_error[eop_pos],eop_pos), UVM_HIGH)
                  `uvm_info(get_full_name(), $sformatf("vector status_error before FCS update is %d",m_vec_tran.status_error), UVM_HIGH)
                  m_tran.rx_mac_error[1]=(uif_rx.mon_cb.fcs_error[eop_pos]);
                  m_vec_tran.status_error[1]=(uif_rx.mon_cb.fcs_error[eop_pos]);
                  `uvm_info(get_full_name(), $sformatf("rx_mac_error after FCS update is %d",m_tran.rx_mac_error), UVM_HIGH)
                  `uvm_info(get_full_name(), $sformatf("vector status_error after FCS update is %d",m_vec_tran.status_error), UVM_HIGH)
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor uif_rx.mon_cb.eop_empty[%0d]: %0h -- 2",eop_pos,uif_rx.mon_cb.eop_empty[eop_pos]), UVM_LOW);
                  repeat_num=eop_pos+1;
               end
               else
                  repeat_num=num_word;
      
            repeat(repeat_num)
            begin 	
               m_tran.seg_packed_bytes=new[m_tran.seg_packed_bytes.size()+1](m_tran.seg_packed_bytes); 
               m_tran.seg_packed_bytes[m_tran.seg_packed_bytes.size()-1]= uif_rx.mon_cb.data[j] ;
               j++; 
            end
            j=0;
            if(uif_rx.mon_cb.found_eop==1) 
               begin 
               
                  //DEBUG
                  `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor in_frame_prev: %0d -- 2",uif_rx.mon_cb.in_frame_prev), UVM_LOW);
                  foreach(uif_rx.in_frame[i])begin
                        `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor inframe[%0d]: %0d -- 2",i,uif_rx.mon_cb.in_frame[i]), UVM_HIGH);
                        `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor sop[%0d]: %0d , sop_pos: %0d -- 2",i,uif_rx.sop[i],sop_pos), UVM_HIGH);
                        `uvm_info(get_type_name(),$sformatf("inside seg_rx monitor eop[%0d]: %0d , eop_pos: %0d -- 2",i,uif_rx.eop[i],eop_pos), UVM_HIGH);              
                  end               
               
                  $display("monitor_concrete:%t seg seg_packed_bytes is %p -- 3",$time,m_tran.seg_packed_bytes);
                  // get the pp & skip crc values from respective registers
                  //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_rxmac_ehip_cfg_OFFSET_REG,m_config.speed), 1 );
                  //DM_TODO: rx_preamble_pass = regs.get();
                  //DM_TODO: regs = reg_model.default_map.get_reg_by_offset(`GET_REG_ADDR(mac_cfg_mac_crc_config_OFFSET_REG,m_config.speed), 1 );
                  //DM_TODO: `uvm_info(get_full_name(), $sformatf("regs = %0p",regs), UVM_DEBUG)
                  //DM_TODO: read_data = regs.get_mirrored_value();
                  `uvm_info(get_full_name(), $sformatf("CRC pass through RCVD at RX MAC = %0b,Preamble_passthrough %b",regs.get_mirrored_value(),rx_preamble_pass[0]), UVM_NONE)
             `uvm_info(get_full_name(),$sformatf("size of packet is %d",(m_tran.seg_packed_bytes.size()*8)),UVM_NONE)
            if (rx_preamble_pass[0] ==1 && read_data[0]==1)      max_extra_short_frame_size = 32; 
            else if (rx_preamble_pass[0] ==1 && read_data[0]==0) max_extra_short_frame_size = 24; 
            else if (rx_preamble_pass[0] ==0 && read_data[0]==0) max_extra_short_frame_size = 16; 
            else                                                 max_extra_short_frame_size = 24;
              
             if((m_tran.seg_packed_bytes.size()*8) <= max_extra_short_frame_size) m_tran.seg_unpack_bytes_extra_short_frame(read_data[0],rx_preamble_pass[0]);
                 else  m_tran.seg_unpack_bytes(read_data[0],rx_preamble_pass[0]);
                  m_tran.transaction_id++; //starting the transaction id from 0
                  m_vec_tran.transaction_id++;
                  $cast(m_tran_clone,m_tran.clone());
            	  mmbox.put(m_tran_clone);
                  $cast(m_vec_tran_clone,m_vec_tran.clone());
            	  mmbox_vec.put(m_vec_tran_clone);
                 
                 ->spy_if.RX_SEG_PKT_RECEIVED;
                 
                  break; // breaking out of while loop when eop is asserted; this makes sure that pkt doesnt get collected in sop after eop on same cycle scenerio
               end
            end 
         end
      end
 		
   endtask: collect_tran 

   function int monitor_concrete::get_num_words(); 
   	case(m_config.speed) 
   		_400G: return(16); 
   		_200G: return(8); 
   		_100G: return(4); 
   		_50G,_40G : return(2); 
   		_25G,_10G : return(1); 
   	endcase 
   	endfunction
   function bit[39:0] monitor_concrete::get_vec_data(int in_status);
	case(in_status) 
   		5: return 1 << 33;  // VLAN/SVLAN (33-1)
   		4: return 1 << 35;  // PFC/SFC
   		7: return 1 << 34;  // Control
   		6: return 1 << 38;  // Illegal LT
   		1: return 1 << 39;  // Eth but non FC
   		2: return 1 << 37;  // bcast/mcast
//   		3: return 1 << ;  // ptp
//              0: return 1 << ;  // valid_length/data frame
   	endcase 

   endfunction
   
   function bit[6:0] monitor_concrete::get_vec_error(bit[1:0] in_error,int eop_pos);
	case(in_error)
	  2'd1: return 1;                                     //2'd1:MALFORMED PACKET
	  2'd2: return 'b1 << 2;                             //2'd2:UNDERSIZE OR OVERSIZE
	  2'd3: return 1 << 4;                                //2'd3:LENGTH ERROR
	  2'd0: return uif_rx.mon_cb.fcs_error[eop_pos] << 1; //2'd0:FCS ERROR   <Based on error decoding of MACSEG>
   	endcase 

   endfunction
monitor_concrete conc_obj_monitor;
 initial begin 
   	conc_obj_monitor = new();
   	uvm_config_db #(seg_rx_monitor_abstract)::set(null,$sformatf("%m"),"CONCRETE_MONITOR",conc_obj_monitor); 
   end 
endmodule 
