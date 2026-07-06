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


// (C) 2001-2020 Intel Corporation. All rights reserved.
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


// Copied from:
// depot/avatar/gdr/e4hip/uvc/common/e4hip_cmn_ptp_defines.svh
// TODO: Check whether exact design names can be exposed to USER.
typedef struct packed {
                  bit [2:0]  spare;
                  bit [2:0]  gb_state;
                  bit [1:0]  ba_phase;
                  bit [4:0]  ba_pos;
                  bit [13:0] am_count; //15bit?, should be 14 bit
                  bit [4:0]  local_vl;
                  bit [4:0]  remote_vl;
                  bit [1:0]  local_pl; //3 bit?, should be 2 bit
                  bit [2:0]  blk_align_ocp;
                  bit [2:0]  ptp_am_det_ocp;
                  bit [2:0]  ptp_gb110_ocp;
                  bit [1:0]  ptp_gb3366_ocp;
                  bit [6:0]  ptp_al_pos_50_ocp;                  
} read_vl_data_s;

// Copied from:
// ehip_cfgcsr_package.sv (ICM)
typedef struct packed {
   logic [6:0]     ptp_al_pos_50g                    ;// sw(read-only) hw(write-only)
   logic [4:0]     local_vl                          ;
   logic [1:0]     local_pl                          ;
   logic [4:0]     vlane_num                         ;
   logic [1:0]     ptp_gb33to66_occupancy            ;
   logic [2:0]     ptp_gb110_occupancy               ;
   logic [2:0]     ptp_am_detect_occupancy           ;
   logic [2:0]     ptp_blk_align_occupancy           ;   
   logic           spare                             ; 
}  t_ehip_csr_ptp_vl_data_hi;

typedef struct packed {
   logic [4:0]     local_vl                        ;
   logic [13:0]    ptp_am_count                    ;
   logic [4:0]     ptp_al_pos			   ;// sw(read-only) hw(write-only)
   logic [1:0]     ptp_al_blk_phase		   ;
   logic [2:0]     ptp_gbstate			   ;
   logic [2:0]     spare                           ;
}  t_ehip_csr_ptp_vl_data_lo;

t_ehip_csr_ptp_vl_data_hi [19:0] rx_pcs_vl_data_hi;
t_ehip_csr_ptp_vl_data_lo [19:0] rx_pcs_vl_data_lo;

logic [19:0][31:0]  rx_non_fec_vl_offset;
logic [19:0][1:0]   rx_non_fec_vl_local_pl;
logic [19:0][4:0]   rx_non_fec_vl_remote_pl;

      function is50G();
         is50G = (p_sequencer.env.dyn_rcfg_obj_inst.speed == _50G) ? 1 : 0;
      endfunction

      function is100G();
         is100G = (p_sequencer.env.dyn_rcfg_obj_inst.speed == _100G) ? 1 : 0;
      endfunction

// Copied from:
// //depot/avatar/gdr/e4hip/uvc/agent/ptp_rx_vl_data/src/bfm/ptp_rx_vl_data_monitor_bfm.sv

      function calculate_vl_offset(read_vl_data_s vl_data);
         int final_offset;
         //bit all_vl_collected;         
         
         //1. Calculate the vl_offset
         if(is50G())begin
            final_offset = get_gb3366_occupancy_bits(vl_data.ptp_gb3366_ocp) + get_gb66110_occupancy_bits(vl_data.ptp_gb110_ocp) + (get_blk_align_occupancy_bits(vl_data.blk_align_ocp, vl_data.ptp_al_pos_50_ocp) * 2) + 
                           (get_am_detect_occupancy_bits(vl_data.ptp_am_det_ocp) * 2) + ({vl_data.spare[1:0],vl_data.am_count} * 2 * 66);
         end else if (is100G())begin
            final_offset = get_gb3366_occupancy_bits(vl_data.ptp_gb3366_ocp) + get_gb66110_occupancy_bits(vl_data.ptp_gb110_ocp,vl_data.gb_state) + (get_blk_align_occupancy_bits(vl_data.blk_align_ocp, {2'b0,vl_data.ba_pos}) * 5) + 
                           (get_am_detect_occupancy_bits(vl_data.ptp_am_det_ocp) * 5) + ({vl_data.spare[1:0],vl_data.am_count} * 5 * 66)/* - vl_data.local_vl*/;
         end         
         //`uvm_info(m_config.m_msg_id, $sformatf("Before shifting vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         
         ////2. shift for remote_vl == 3 by 330(50G)
         //if(is50G()/* && vl_data.remote_vl == 3*/)begin
         //   //final_offset = final_offset - 330;
         //   ////`uvm_info(m_config.m_msg_id, $sformatf("After Shifting vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         //   if(final_offset < 2560*66)begin
         //      final_offset = 2560*66 - final_offset;               
         //      //`uvm_info(m_config.m_msg_id, $sformatf("final_offset smaller. After Shifting vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         //   end else begin
         //      final_offset = 2560*66*2 - final_offset;
         //      //`uvm_info(m_config.m_msg_id, $sformatf("final_offset bigger. After Shifting vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         //   end            
         //end
         if(is50G())begin
            if (vl_data.local_vl == 0 || vl_data.local_vl == 2)begin
               //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: After final_offset adjustment for local_vl[%0d]: %0h",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
         
            if (vl_data.local_vl == 1 || vl_data.local_vl == 3)begin
               final_offset = final_offset - 1;
               //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: After final_offset adjustment for local_vl[%0d]: %0h",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
            
            //Check if it is bigger than 2560*66
            //if(final_offset > (( `altuvm_test_parg("NON_FAST_SIM", "NON_FAST_SIM test"))?(2560*66*16):2560*66))begin
            //   final_offset = final_offset - (( `altuvm_test_parg("NON_FAST_SIM", "NON_FAST_SIM test"))?(2560*66*16):2560*66) /*(2560*66)*/;
            //   if( `altuvm_test_parg("NON_FAST_SIM", "NON_FAST_SIM test") ) begin
            //      //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: final_offset is bigger than 2560*66. Subtract 2560*66*16 from final_offset for local_vl[%0d]: %0h",vl_data.local_vl, final_offset), UVM_MEDIUM)
            //   end else begin
            //      //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: final_offset is bigger than 2560*66. Subtract 2560*66 from final_offset for local_vl[%0d]: %0h",vl_data.local_vl, final_offset), UVM_MEDIUM)
            //   end
            //end
            
         end else if (is100G())begin
            if (vl_data.local_vl == 0 || vl_data.local_vl == 5 || vl_data.local_vl == 10 || vl_data.local_vl == 15)begin
               //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: After final_offset adjustment for local_vl[%0d]: %0h -- 0",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
            if (vl_data.local_vl == 1 || vl_data.local_vl == 6 || vl_data.local_vl == 11 || vl_data.local_vl == 16)begin
               final_offset = final_offset - 1;
               //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: After final_offset adjustment for local_vl[%0d]: %0h -- 1",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
            if (vl_data.local_vl == 2 || vl_data.local_vl == 7 || vl_data.local_vl == 12 || vl_data.local_vl == 17)begin
               final_offset = final_offset - 2;
               //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: After final_offset adjustment for local_vl[%0d]: %0h -- 2",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
            if (vl_data.local_vl == 3 || vl_data.local_vl == 8 || vl_data.local_vl == 13 || vl_data.local_vl == 18)begin
               final_offset = final_offset - 3;
               //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: After final_offset adjustment for local_vl[%0d]: %0h -- 3",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
            if (vl_data.local_vl == 4 || vl_data.local_vl == 9 || vl_data.local_vl == 14 || vl_data.local_vl == 19)begin
               final_offset = final_offset - 4;
               //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: After final_offset adjustment for local_vl[%0d]: %0h -- 4",vl_data.local_vl, final_offset), UVM_MEDIUM)
            end
            
            //Check if it is bigger than 2560*66
            if(final_offset > 2560*66)begin
               final_offset = final_offset - 2560*66;
               //if( `altuvm_test_parg("NON_FAST_SIM", "NON_FAST_SIM test") ) begin
               //   //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: final_offset is bigger than 2560*66*32. Subtract 2560*66 from final_offset for local_vl[%0d]: %0h",vl_data.local_vl, final_offset), UVM_MEDIUM)
               //end else begin
               //   //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: final_offset is bigger than 2560*66. Subtract 2560*66 from final_offset for local_vl[%0d]: %0h",vl_data.local_vl, final_offset), UVM_MEDIUM)
               //end
            end            
            
         end
         
         //if(is100G() && (vl_data.remote_vl == 18 || vl_data.remote_vl == 19))begin
         //   final_offset = final_offset - 330;
         //   //`uvm_info(m_config.m_msg_id, $sformatf("After Shifting vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         //end
         
         ////3a. Apply UI to convert to NS_FNS
         ////`uvm_info(m_config.m_msg_id, $sformatf("Getting UI from m_config node %0d: %0h",node,m_config.rx_ptp_ui), UVM_MEDIUM)
         //final_offset = final_offset * m_config.rx_ptp_ui;
         ////`uvm_info(m_config.m_msg_id, $sformatf("After applying UI vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         
         ////3b. Getting only 16 bit of the FNS part         
         //final_offset >>= 12;
         ////`uvm_info(m_config.m_msg_id, $sformatf("After shifting 12 bits of the UI vl_offset for remote_vl: %0d: %0h",vl_data.remote_vl,final_offset), UVM_MEDIUM)
         //
         ////3c. Adding tx vloffset
         //final_offset += m_config.vl_offset[vl_data.remote_vl];         
         ////`uvm_info(m_config.m_msg_id, $sformatf("tx vl_offset[%0d]: %0h: After adding tx vloffset: %0h",vl_data.remote_vl, m_config.vl_offset[vl_data.remote_vl],final_offset), UVM_MEDIUM)

         //4. Generating array based on the collected VL information
         //vl_offset_collected[vl_data.local_vl] = 1;
         rx_non_fec_vl_offset[vl_data.local_vl]     = final_offset;
         rx_non_fec_vl_local_pl[vl_data.local_vl]   = vl_data.local_pl;
         rx_non_fec_vl_remote_pl[vl_data.local_vl]  = vl_data.remote_vl;

         // Checking if all the VL offset data are being captured or not
         // Based on speed:
         // 50G   : 4 VL
         // 100G  : 20 VL
         
         //if(is50G()) begin
         //   all_vl_collected = &vl_offset_collected[3:0];
         //end else if (is100G())begin
         //   all_vl_collected = &vl_offset_collected[19:0];
         //end         
         //
         //if(all_vl_collected == 1) begin
         //   event_pool= new();
         //   event_pool = event_pool.get_global_pool();
         //   // Taking an event from the event pool
         //   vl_load_event = event_pool.get($sformatf("vl_load_event_%0d",node));
         //   // Creating an object to pass the virtual lane offset information to another agent/component
         //   vl_info_cfg = vl_offset_info_config::type_id::create("vl_info_cfg");
         //   
         //   // Assign the *re-mapped* VL offset array.
         //   vl_info_cfg.vl_offset_load_arr = vl_offset_load_arr; 
         //   
         //   vl_info_cfg.print();
         //
         //   // Triggering the event and passing the VL information along with it
         //   vl_load_event.trigger(vl_info_cfg);
         //   
         //   //`uvm_info(m_config.m_msg_id, $sformatf("Triggering vl_load_event_%0d",node), UVM_MEDIUM)            
         //
         //   //`uvm_info(m_config.m_msg_id,
         //      $sformatf("SSDV_PTP_INFO:All of 20 VLs have been read and offset data is generated"), UVM_LOW)
         //
         //   vl_offset_collected  = 'h0;
         //   all_vl_collected     = 0;
         //
         //end
               
      
      endfunction: calculate_vl_offset

      function int get_gb66110_occupancy_bits(input bit[2:0] _occ = 3'b0, input bit[2:0] _gbs = 3'b0);
         if(is50G())begin
         
            case(_occ[2:1])
               2'b00:begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: GB 66110 Occupancy return is 0 PL bits"), UVM_MEDIUM)
                  return 0;
               end
               2'b01:begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: GB 66110 Occupancy return is 132 PL bits"), UVM_MEDIUM)
                  return 132;
               end
               2'b10:begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: GB 66110 Occupancy return is 66 PL bits"), UVM_MEDIUM)
                  return 66;
               end
               2'b11:begin
                  ////`uvm_info(m_config.m_msg_id, $sformatf("[50G]: GB 66110 Occupancy return is 0 PL bits"), UVM_MEDIUM)
                  //`uvm_error(m_config.m_msg_id, $sformatf("[50G]: Illegal case for GB 66110 Occupancy"))                  
               end
               default: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[50G]: GB 66110 Occupancy return is 0 PL bits (default)"), UVM_MEDIUM)
                  return 0;
               end            
            endcase
         
         end else if (is100G())begin
            case(_gbs)
               3'b000:begin
                  if(_occ[2] == 1)begin
                     //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 110 PL bits"), UVM_MEDIUM)
                     return (110);
                  end else begin
                     //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 0 PL bits"), UVM_MEDIUM)
                     return 0;                  
                  end
               end
               3'b001:begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 66 PL bits"), UVM_MEDIUM)
                  return (66);
               end            
               3'b010:begin
                  if(_occ[2] == 1)begin
                     //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 132 PL bits"), UVM_MEDIUM)
                     return (22+110);               
                  end else begin
                     //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 22 PL bits"), UVM_MEDIUM)
                     return (22);
                  end
               end
               3'b011:begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 88 PL bits"), UVM_MEDIUM)
                  return (88);
               end
               3'b100:begin
                  if(_occ[2] == 1)begin
                     //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 154 PL bits"), UVM_MEDIUM)
                     return (44+110);               
                  end else begin
                     //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 44 PL bits"), UVM_MEDIUM)
                     return (44);
                  end
               end             
               default: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 0 PL bits"), UVM_MEDIUM)
                  return 0;
               end         
            endcase
         end         
         
         //else if (is100G())begin
         //   case(_gbs)
         //      3'b000:begin
         //         if(_occ[2] == 1)begin
         //            //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 176 PL bits"), UVM_MEDIUM)
         //            return (66+110);               
         //         end else begin
         //            //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 66 PL bits"), UVM_MEDIUM)
         //            return 66;
         //         end
         //      end
         //      3'b001:begin
         //         //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 132 PL bits"), UVM_MEDIUM)
         //         return (66+66);
         //      end            
         //      3'b010:begin
         //         if(_occ[2] == 1)begin
         //            //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 198 PL bits"), UVM_MEDIUM)
         //            return (66+22+110);               
         //         end else begin
         //            //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 88 PL bits"), UVM_MEDIUM)
         //            return (66+22);
         //         end
         //      end
         //      3'b011:begin
         //         //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 154 PL bits"), UVM_MEDIUM)
         //         return (66+88);
         //      end
         //      3'b100:begin
         //         if(_occ[2] == 1)begin
         //            //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 220 PL bits"), UVM_MEDIUM)
         //            return (66+44+110);               
         //         end else begin
         //            //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 110 PL bits"), UVM_MEDIUM)
         //            return (66+44);
         //         end
         //      end             
         //      default: begin
         //         //`uvm_info(m_config.m_msg_id, $sformatf("[100G]: GB 66110 Occupancy return is 0 PL bits"), UVM_MEDIUM)
         //         return 0;
         //      end         
         //   endcase
         //end
      endfunction: get_gb66110_occupancy_bits

      function int get_gb3366_occupancy_bits(input bit[1:0] _occ);
         case(_occ)
            2'b00: begin
               //`uvm_info(m_config.m_msg_id, $sformatf("GB Occupancy 3366 return is 0 PL bits"), UVM_MEDIUM)
               return 0;
            end
            2'b01: begin
               //`uvm_info(m_config.m_msg_id, $sformatf("GB Occupancy 3366 return is 0 PL bits"), UVM_MEDIUM)
               return 0; 
            end
            2'b10: begin
               //`uvm_info(m_config.m_msg_id, $sformatf("GB Occupancy 3366 return is 33 PL bits"), UVM_MEDIUM)
               return 33;
            end
            2'b11: begin
               //`uvm_info(m_config.m_msg_id, $sformatf("GB Occupancy 3366 return is 33 PL bits"), UVM_MEDIUM)
               return 33;
            end 
            default: begin
               //`uvm_info(m_config.m_msg_id, $sformatf("GB Occupancy 3366 return is 0 PL bits"), UVM_MEDIUM)
               return 0;
            end
         endcase
      endfunction: get_gb3366_occupancy_bits
      
      function int get_blk_align_occupancy_bits(input bit[2:0] _occ, bit[6:0] _al_pos);
         if(is50G())begin
         
            case(_occ[1:0])
               2'b00: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 65 - al_pos = %0d VL bits", (65 - _al_pos)), UVM_MEDIUM)
                  return (65 - _al_pos);
               end
               2'b01: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 66 + (65 - al_pos) = %0d VL bits", (66 + (65 - _al_pos))), UVM_MEDIUM)
                  return (66 + (65 - _al_pos)); 
               end
               2'b10: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 66 + (65 - al_pos) = %0d VL bits", (66 + (65 - _al_pos))), UVM_MEDIUM)
                  return (66 + (65 - _al_pos));
               end
               2'b11: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 66 + (65 - al_pos) + 66 = %0d VL bits", (66 + (65 - _al_pos) + 66)), UVM_MEDIUM)
                  return (66 + (65 - _al_pos) + 66);
               end 
               default: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 0 VL bits"), UVM_MEDIUM)
                  return 0;
               end
            endcase
            
         end else if(is100G())begin
            case(_occ[1:0])
               2'b00: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 21 - al_pos = %0d VL bits", (21 - _al_pos)), UVM_MEDIUM)
                  return (21 - _al_pos);
               end
               2'b01: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 22 + (21 - al_pos) = %0d VL bits", (22 + (21 - _al_pos))), UVM_MEDIUM)
                  return (22 + (21 - _al_pos)); 
               end
               2'b10: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 22 + (21 - al_pos) = %0d VL bits", (22 + (21 - _al_pos))), UVM_MEDIUM)
                  return (22 + (21 - _al_pos));
               end
               2'b11: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 22 + (21 - al_pos) + 22 = %0d VL bits", (22 + (21 - _al_pos) + 22)), UVM_MEDIUM)
                  return (22 + (21 - _al_pos) + 22);
               end 
               default: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Block align occupancy return is 0 VL bits"), UVM_MEDIUM)
                  return 0;
               end
            endcase         
         end
      endfunction: get_blk_align_occupancy_bits

      function int get_am_detect_occupancy_bits (input bit[2:0] _occ);
         if(is50G())begin
            case(_occ[0])
               1'b0: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 0 VL bits"), UVM_MEDIUM)
                  return 0;
               end
               1'b1: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 66 VL bits"), UVM_MEDIUM)
                  return 66; 
               end
               default: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 0 VL bits"), UVM_MEDIUM)
                  return 0;
               end
            endcase
         end else if(is100G())begin
            case(_occ)
               3'b000: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 44 VL bits"), UVM_MEDIUM)
                  return 44;
               end
               3'b001: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 66 VL bits"), UVM_MEDIUM)
                  return 66; 
               end
               3'b010: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 22 VL bits"), UVM_MEDIUM)
                  return 22; 
               end
               3'b011: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 44 VL bits"), UVM_MEDIUM)
                  return 44;
               end
               3'b100: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 0 VL bits"), UVM_MEDIUM)
                  return 0;
               end
               3'b101: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 22 VL bits"), UVM_MEDIUM)
                  return 22;
               end                
               default: begin
                  //`uvm_info(m_config.m_msg_id, $sformatf("Am detect occupancy return is 0 VL bits"), UVM_MEDIUM)
                  return 0;
               end
            endcase         
         end
      endfunction: get_am_detect_occupancy_bits


      // Calculating VL offset based on the sampled Virtual Lane data
      //
      //       The soft logic can be moved to dedicated component just like ptp_checker.   
      function int unsigned get_proc_offset(read_vl_data_s vl_data);
      
         case (vl_data.local_vl)
            0,5,10,15: begin
            case(vl_data.ba_phase)
               2: begin
                  case(vl_data.ba_pos)
                     21,20,19,18,17: get_proc_offset = 5;
                     3,2,1,0: get_proc_offset = 7;
                     default: begin
                        if ((vl_data.ba_pos >= 4) && (vl_data.ba_pos <= 16)) begin
                           get_proc_offset = 6;
                        end
                        else begin
                           get_proc_offset = 0; // not tabled for this ba_pos value
                        end
                     end
                  endcase
               end
               1: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 12)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 13) && (vl_data.ba_pos <= 21)) begin
                        get_proc_offset = 5;
                     end
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               0: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 7)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 8) && (vl_data.ba_pos <= 20)) begin
                        get_proc_offset = 5;
                     end
                     else if (vl_data.ba_pos == 21) get_proc_offset = 4;
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               default: get_proc_offset = 0; // not tabled for this ba_phase value
            endcase
            end
            1,6,11,16: begin
            case(vl_data.ba_phase)
               2: begin
                  case(vl_data.ba_pos)
                     21,20,19,18,17: get_proc_offset = 5;
                     3,2,1,0: get_proc_offset = 7;
                     default: begin
                        if ((vl_data.ba_pos >= 4) && (vl_data.ba_pos <= 16)) begin
                           get_proc_offset = 6;
                        end
                        else begin
                           get_proc_offset = 0; // not tabled for this ba_pos value
                        end
                     end
                  endcase
               end
               1: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 11)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 12) && (vl_data.ba_pos <= 21)) begin
                        get_proc_offset = 5;
                     end
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               0: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 7)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 8) && (vl_data.ba_pos <= 20)) begin
                        get_proc_offset = 5;
                     end
                     else if (vl_data.ba_pos == 21) get_proc_offset = 4;
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               default: get_proc_offset = 0; // not tabled for this ba_phase value
            endcase
            end
            2,7,12,17: begin
            case(vl_data.ba_phase)
               2: begin
                  case(vl_data.ba_pos)
                     21,20,19,18,17: get_proc_offset = 5;
                     2,1,0: get_proc_offset = 7;
                     default: begin
                        if ((vl_data.ba_pos >= 3) && (vl_data.ba_pos <= 16)) begin
                           get_proc_offset = 6;
                        end
                        else begin
                           get_proc_offset = 0; // not tabled for this ba_pos value
                        end
                     end
                  endcase
               end
               1: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 11)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 12) && (vl_data.ba_pos <= 21)) begin
                        get_proc_offset = 5;
                     end
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               0: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 7)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 8) && (vl_data.ba_pos <= 20)) begin
                        get_proc_offset = 5;
                     end
                     else if (vl_data.ba_pos == 21) get_proc_offset = 4;
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               default: get_proc_offset = 0; // not tabled for this ba_phase value
            endcase
            end
            3,8,13,18: begin
            case(vl_data.ba_phase)
               2: begin
                  case(vl_data.ba_pos)
                     21,20,19,18,17,16: get_proc_offset = 5;
                     2,1,0: get_proc_offset = 7;
                     default: begin
                        if ((vl_data.ba_pos >= 3) && (vl_data.ba_pos <= 15)) begin
                           get_proc_offset = 6;
                        end
                        else begin
                           get_proc_offset = 0; // not tabled for this ba_pos value
                        end
                     end
                  endcase
               end
               1: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 11)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 12) && (vl_data.ba_pos <= 21)) begin
                        get_proc_offset = 5;
                     end
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               0: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 7)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 8) && (vl_data.ba_pos <= 20)) begin
                        get_proc_offset = 5;
                     end
                     else if (vl_data.ba_pos == 21) get_proc_offset = 4;
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               default: get_proc_offset = 0; // not tabled for this ba_phase value
            endcase
            end
            4,9,14,19: begin
            case(vl_data.ba_phase)
               2: begin
                  case(vl_data.ba_pos)
                     21,20,19,18,17,16: get_proc_offset = 5;
                     2,1,0: get_proc_offset = 7;
                     default: begin
                        if ((vl_data.ba_pos >= 3) && (vl_data.ba_pos <= 15)) begin
                           get_proc_offset = 6;
                        end
                        else begin
                           get_proc_offset = 0; // not tabled for this ba_pos value
                        end
                     end
                  endcase
               end
               1: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 11)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 12) && (vl_data.ba_pos <= 21)) begin
                        get_proc_offset = 5;
                     end
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               0: begin
                     if ((vl_data.ba_pos >= 0) && (vl_data.ba_pos <= 6)) begin
                        get_proc_offset = 6;
                     end
                     else if ((vl_data.ba_pos >= 7) && (vl_data.ba_pos <= 20)) begin
                        get_proc_offset = 5;
                     end
                     else if (vl_data.ba_pos == 21) get_proc_offset = 4;
                     else begin
                        get_proc_offset = 0; // not tabled for this ba_pos value
                     end
               end
               default: get_proc_offset = 0; // not tabled for this ba_phase value
            endcase
            end
            default: get_proc_offset = 0; // not tabled for this ba_phase value 
         endcase
      
         //`uvm_info(m_config.m_msg_id,
            //$sformatf("proc_offset = %0d, vl_data = %p", get_proc_offset, vl_data), UVM_MEDIUM)
      
         return get_proc_offset;
      
      endfunction: get_proc_offset
      
         // Capturing the data and storing it into VL struct
   
   function generate_vl_data(/*bit [83:0] rx_ts*/ t_ehip_csr_ptp_vl_data_hi pcs_reg_hi, t_ehip_csr_ptp_vl_data_lo pcs_reg_lo);
   
      read_vl_data_s vl_offset_s; // VL offset struct to collect info
   
      vl_offset_s.spare    = pcs_reg_lo.spare;    //spare bit used for upper bits am_count
      vl_offset_s.gb_state = pcs_reg_lo.ptp_gbstate;      // GB state
      vl_offset_s.ba_phase = pcs_reg_lo.ptp_al_blk_phase;      // BA phase
      vl_offset_s.ba_pos   = pcs_reg_lo.ptp_al_pos;      // BA position
      vl_offset_s.am_count = pcs_reg_lo.ptp_am_count;    // AM count
      vl_offset_s.local_vl = pcs_reg_lo.local_vl;    // Local VL number
      vl_offset_s.remote_vl= pcs_reg_hi.vlane_num;      // Remote VL number
      vl_offset_s.local_pl = pcs_reg_hi.local_pl;      // Local PL number      
      vl_offset_s.blk_align_ocp     = pcs_reg_hi.ptp_blk_align_occupancy;    // Blk align occupancy  : GDR NEW
      vl_offset_s.ptp_am_det_ocp    = pcs_reg_hi.ptp_am_detect_occupancy;    // PTP am det occupancy : GDR NEW
      vl_offset_s.ptp_gb110_ocp     = pcs_reg_hi.ptp_gb110_occupancy;    // PTP gb110 occupancy  : GDR NEW
      vl_offset_s.ptp_gb3366_ocp    = pcs_reg_hi.ptp_gb33to66_occupancy;    // PTP gb3366 occupancy : GDR NEW
      vl_offset_s.ptp_al_pos_50_ocp = pcs_reg_hi.ptp_al_pos_50g;    // PTP al_pos 50g occupancy : GDR NEW
      
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, GB_STATE           = %0d",pcs_reg_lo[28:24],pcs_reg_lo[2:0]),    UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, BA_PHASE           = %0d",pcs_reg_lo[28:24],pcs_reg_lo[4:3]),    UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, BA_POS             = %0d",pcs_reg_lo[28:24],pcs_reg_lo[9:5]),    UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, AM_COUNT           = %0d",pcs_reg_lo[28:24],{pcs_reg_lo[30:29],pcs_reg_lo[23:10]}),  UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, REMOTE_VL          = %0d",pcs_reg_lo[28:24],pcs_reg_hi[4:0]),    UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, LOCAL_PL           = %0d",pcs_reg_lo[28:24],pcs_reg_hi[6:5]),    UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, BLK_ALGN_OCP       = %0d",pcs_reg_lo[28:24],pcs_reg_hi[15:13]),  UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, PTP_AM_DET_OCP     = %0d",pcs_reg_lo[28:24],pcs_reg_hi[18:16]),  UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, PTP_GB110_OCP      = %0d",pcs_reg_lo[28:24],pcs_reg_hi[21:19]),  UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, PTP_GB3366_OCP     = %0d",pcs_reg_lo[28:24],pcs_reg_hi[23:22]),  UVM_MEDIUM)
      //`uvm_info(m_config.m_msg_id, $sformatf("Local VL no = %0d, PTP_AL_POS_50_OCP  = %0d",pcs_reg_lo[28:24],pcs_reg_hi[30:24]),  UVM_MEDIUM)
                                                                                                  
      // Caluclation of VL offset based on the collected timestamp
      // calculate_vl_offset_old(vl_offset_s); // old method, delete later...

         //calculate_vl_offset_new(vl_offset_s);
         calculate_vl_offset(vl_offset_s);
   endfunction
