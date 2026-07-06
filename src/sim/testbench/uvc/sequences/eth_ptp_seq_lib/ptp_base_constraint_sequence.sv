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


class ptp_base_constraint_sequence extends eth_packet;
 
  int sequence_length;
  bit ptp_asym_en;
  bit ptp_p2p_en;
  int num_words_local;
  rand bit [63:0] ingress_cf;
dyn_rcfg dyn_rcfg_obj_inst; 
  
`uvm_object_utils_begin(ptp_base_constraint_sequence)
  `uvm_field_int(ingress_cf,UVM_ALL_ON)
`uvm_object_utils_end

  function new(string name = "ptp_base_constraint_sequence");
    super.new(name);
   `ifdef UVM_POST_VERSION_1_1
       set_automatic_phase_objection(1);
    `endif
  endfunction:new


   constraint ingress_cf_c {
      ingress_cf dist {
        0 := 10, // zero
        'h10000 := 10,
        'h8000_0000_0000_0001 :=10,
        [1:'h7FFF_FFFF_FFFF_FFFD] :/ 10,
        'h8000_0000_0000_0000   := 50, // most negative number, if substrate will undeflow
        'h7FFF_FFFF_FFFF_FFFE := 50, // most positive number, if add will overflow
        'h7FFF_FFFF_FFFF_FFFF := 40  // original CF = 7FFF_FFFF_FFFF_FFFF (Error), do nothing
      };
   }

  

  //Method : post_randomize
//This method does post_randomization
function void post_randomize();

    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_start::is_ptp_seq=%0b, operation=%s", is_ptp_seq, m_ptp_op.name()), UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_start::ptp_ff_offsets_rand_en=%0b, ptp_ff_even_offsets=%0b, ptp_ff_odd_offsets=%0b", 
                                      ptp_ff_offsets_rand_en, ptp_ff_even_offsets, ptp_ff_odd_offsets), UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_start::i_ptp_tx_fp=%0d, payload_size=%0d, ts_offset=%0d, cf_offset=%0d, cs_offset=%0d, ingress_ts=%0h",
                                      i_ptp_tx_fp, payload.size(), ptp_offset, cf_offset, cs_offset, ingress_ts), UVM_LOW)

  //  Added by atiwari2, stopping the overriding of incremental generated
  //  data incase payload_type is assigned, else random payload
  if (payload_typ==INCR) begin
    foreach(payload[i])
      payload[i] = i;
  end
  else begin
      foreach(payload[i])
      payload[i] = $urandom();
  end


    if(frame_type == ETH_SFC_FRAME) begin
      foreach(payload[i])
        payload[4+i] = 0;

        {payload[0],payload[1]} = 'h00001;
        {payload[2],payload[3]} = sfc_pause_quanta;
    end
    else if (frame_type == ETH_PFC_FRAME) begin
      foreach(payload[i])
        payload[20+i] = 0;

        {payload[0],payload[1]} = 'h0101;
        payload[2] = pfc_class_en_vect[0];
        payload[3] = pfc_class_en_vect[1];
        payload[4] =  pfc_pause_quanta[0][15:8];
        payload[5] =  pfc_pause_quanta[0][7:0];
        payload[6] =  pfc_pause_quanta[1][15:8];
        payload[7] =  pfc_pause_quanta[1][7:0];
        payload[8] =  pfc_pause_quanta[2][15:8];
        payload[9] =  pfc_pause_quanta[2][7:0];
        payload[10] = pfc_pause_quanta[3][15:8];
        payload[11] = pfc_pause_quanta[3][7:0];
        payload[12] = pfc_pause_quanta[4][15:8];
        payload[13] = pfc_pause_quanta[4][7:0];
        payload[14] = pfc_pause_quanta[5][15:8];
        payload[15] = pfc_pause_quanta[5][7:0];
        payload[16] = pfc_pause_quanta[6][15:8];
        payload[17] = pfc_pause_quanta[6][7:0];
        payload[18] = pfc_pause_quanta[7][15:8];
        payload[19] = pfc_pause_quanta[7][7:0];
    end

  /*  if (payload_typ == PTP_DEBUG) begin
      // For PTP debug, keep incremental and fixed payload across packets.
      fixed_payload = ++seq_id;
         if (is_ptp_seq ==1) begin
            foreach(payload[i]) payload[i] = fixed_payload;
            i_ptp_tx_fp = seq_id % 'd255; // fp is a 8-bit bus.
            `uvm_info(get_full_name(), $sformatf("is_ptp_seq::is_ptp_seq=%0d, payload_typ=%s, seq_id=%0d, fixed_payload=%0d",
               is_ptp_seq, frame_type.name(), seq_id, fixed_payload), UVM_NONE)
         end */
   
	
    

    if (is_ptp_seq == 0) begin // NON PTP packet
          m_ptp_op = INS_NOOP;
          i_ptp_tx_fp=0;
          ingress_ts=0;
          ptp_offset=0;
          cf_offset=0;
          cs_offset=0;
    end else begin
          if(m_ptp_op == INS_2STEP) begin
               ingress_ts=0;
               ptp_offset=0;
               cf_offset=0;
               cs_offset=0;
          end
    end

    if (frame_payload_type == UNDERSIZE) begin
      if (is_ptp_seq == 0) begin // NON PTP packet
          m_ptp_op = INS_NOOP;
          i_ptp_tx_fp=0;
          ingress_ts=0;
          ptp_offset=0;
          cf_offset=0;
          cs_offset=0;
      end
		end

    if(((m_ptp_op == INS_V1) || (m_ptp_op == INS_V1_W_UDP_CS_0) || (m_ptp_op == INS_V1_W_EB) || (m_ptp_op == INS_V1_W_ASYM_LAT)    || 
                                                              (m_ptp_op == INS_V1_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op == INS_V1_W_ASYM_LAT_EB) ||
        (m_ptp_op == INS_V2) || (m_ptp_op == INS_V2_W_UDP_CS_0) || (m_ptp_op == INS_V2_W_EB) || (m_ptp_op == INS_V2_W_ASYM_LAT)    || 
                                                              (m_ptp_op == INS_V2_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op == INS_V2_W_ASYM_LAT_EB) ||
        (m_ptp_op == INS_P2P) || (m_ptp_op == INS_P2P_W_UDP_CS_0) || (m_ptp_op == INS_P2P_W_EB) || (m_ptp_op == INS_P2P_W_ASYM_LAT) ||
                                                             (m_ptp_op == INS_P2P_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op == INS_P2P_W_ASYM_LAT_EB) ||
        (m_ptp_op ==INS_ASYM_LAT) || (m_ptp_op ==INS_ASYM_LAT_EB) || (m_ptp_op ==INS_ASYM_LAT_CS_0) ||
        (m_ptp_op == INS_CF) || (m_ptp_op == INS_CF_W_UDP_CS_0) || (m_ptp_op == INS_CF_W_EB) || (m_ptp_op == INS_CF_W_ASYM_LAT)    ||
                                                              (m_ptp_op == INS_CF_W_ASYM_LAT_UDP_CS_0) || (m_ptp_op == INS_CF_W_ASYM_LAT_EB)) && (is_ptp_seq == 1)) begin

         byte offset_pos = 'd14; //6+6+2

			   //This will be indicator for which cycle to set the offset
			   //The driver will have to take care of the preamble passthrough setting when counting
			   //up to this word
         if (!ptp_ff_offsets_rand_en) begin
			              if((ptp_offset > payload.size() -12)||
                       (cf_offset > payload.size() -8)||
                       (cs_offset > payload.size() -2)) begin
                            randcase
                                   50: begin
			   	                                ptp_offset = payload.size()-12;
                                          cf_offset  = ptp_offset-8;
			                                    cs_offset  = ptp_offset+10;
                                   end
                                   50: begin
			   	                                cf_offset  = payload.size()-10;
                                          ptp_offset = cf_offset-10;
			                                    cs_offset  = cf_offset+8;
                                   end
                            endcase
			              end

         end //ptp_ff_offset


                          // Randomize ori CF field
            if(ptp_asym_en || ptp_p2p_en) begin
                for (int i=0; i<8; i++)begin
                   payload[(cf_offset + (7-i)) - offset_pos - preamble_offset] = ingress_cf[i*8+:8];
                end
                original_cf_bytes = {payload[(cf_offset)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+1)-(offset_pos) - preamble_offset],
						                       payload[(cf_offset+2)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+3)-(offset_pos) - preamble_offset],
						                       payload[(cf_offset+4)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+5)-(offset_pos) - preamble_offset],
						                       payload[(cf_offset+6)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+7)-(offset_pos) - preamble_offset]};
                
                $display("\n\n\n\n\norignal_byte=%h...........INGRESS_CF=%h\n\n\n\n",original_cf_bytes,ingress_cf); 

            end
            `uvm_info(get_type_name(), $sformatf("Randomized CF field : %0h", this.ingress_cf), UVM_MEDIUM)


			   ptp_offset_word_counter = (ptp_offset/8)+1;
			   cf_offset_word_counter  = (cf_offset/8)+1;
			   cs_offset_word_counter  = (cs_offset/8)+1;

         if (frame_type == ETH_VLAN_FRAME) offset_pos = 'd18;
         if (frame_type == ETH_STACKED_VLAN_FRAME) offset_pos = 'd22;

			   original_bytes = {payload[(ptp_offset)-(offset_pos) - preamble_offset],
                                payload[(ptp_offset+1)-(offset_pos) - preamble_offset],
					                      payload[(ptp_offset+2)-(offset_pos) - preamble_offset],
                                payload[(ptp_offset+3)-(offset_pos) - preamble_offset],
					                      payload[(ptp_offset+4)-(offset_pos) - preamble_offset],
                                payload[(ptp_offset+5)-(offset_pos) - preamble_offset],
					                      payload[(ptp_offset+6)-(offset_pos) - preamble_offset],
                                payload[(ptp_offset+7)-(offset_pos) - preamble_offset],
					                      payload[(ptp_offset+8)-(offset_pos) - preamble_offset],
                                payload[(ptp_offset+9)-(offset_pos) - preamble_offset]};

			   original_cf_bytes = {payload[(cf_offset)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+1)-(offset_pos) - preamble_offset],
						                       payload[(cf_offset+2)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+3)-(offset_pos) - preamble_offset],
						                       payload[(cf_offset+4)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+5)-(offset_pos) - preamble_offset],
						                       payload[(cf_offset+6)-(offset_pos) - preamble_offset],
                                   payload[(cf_offset+7)-(offset_pos) - preamble_offset]};

			   original_cs_bytes = {payload[(cs_offset)-(offset_pos) - preamble_offset],
                                   payload[(cs_offset+1)-(offset_pos) - preamble_offset]};

         `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_end::ts_wc=%0d, cf_wc=%0d, cs_wc=%0d",
                                               ptp_offset_word_counter, cf_offset_word_counter, cs_offset_word_counter), UVM_LOW)

		end

    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_end::is_ptp_seq=%0b, operation=%s", is_ptp_seq, m_ptp_op.name()), UVM_LOW)
    `uvm_info(get_full_name(), $sformatf("ptp_post_randomize_end::i_ptp_tx_fp=%0d, payload_size=%0d, ts_offset=%0d, cf_offset=%0d, cs_offset=%0d, ingress_ts=%0h",
                                      i_ptp_tx_fp, payload.size(), ptp_offset, cf_offset, cs_offset, ingress_ts), UVM_LOW)

    calc_crc32();

endfunction : post_randomize


endclass : ptp_base_constraint_sequence
