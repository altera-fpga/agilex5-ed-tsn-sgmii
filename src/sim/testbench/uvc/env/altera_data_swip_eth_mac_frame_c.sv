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


`ifndef ALTERA_DATA_SWIP_ETH_MAC_FRAME_C__SV
`define ALTERA_DATA_SWIP_ETH_MAC_FRAME_C__SV

class altera_data_swip_eth_mac_frame_c ;
    
    
    // frame data
    rand logic [7:0] frame_data[];
    
    // frame properties
    rand bit [31:0] frame_length = 64;
    rand bit [31:0] payload_length = 46;
    
    rand enum int unsigned {DATA_FRAME, TYPE_FRAME, CONTROL_FRAME} frame_type = DATA_FRAME;
    rand enum int unsigned {PAUSE_CONTROL, PFC_CONTROL, MISC_CONTROL} control_type = MISC_CONTROL;
    
    rand enum int unsigned {UNICAST, MULTICAST, BROADCAST, UNICAST_INVALID, MULTICAST_PAUSE} da_type = UNICAST;
    rand enum int unsigned {UCAST_ADDR, SUPP_ADDR_0, SUPP_ADDR_1, SUPP_ADDR_2, SUPP_ADDR_3} da_ucast_type = UCAST_ADDR; // mainly used for coverage only
    
    rand enum int unsigned {UNTAGGED = 0, VLAN = 1, SVLAN = 2} tag_type = UNTAGGED;
    
    typedef enum int unsigned {
        NO_ERROR                = 0,
        ERROR_CRC               = 1 << 0,
        ERROR_UNDERSIZED        = 1 << 1,
        ERROR_OVERSIZED         = 1 << 2,
        ERROR_PAYLOAD_LENGTH    = 1 << 3
    } ERROR_E;
    
    rand int unsigned error_type = 0;
    
    rand int unsigned ipg = 12;
    
    int inc_data_mode = 0;
    
    parameter ETH_SYMBOL_SFD                = 8'hD5;
    parameter ETH_MAC_BROADCAST_ADDRESS     = 48'hFF_FF_FF_FF_FF_FF;
    parameter ETH_MAC_PAUSE_MCAST_ADDRESS   = 48'h01_80_C2_00_00_01;
   parameter ETH_MAC_RX_UCAST_ADDRESS       = 48'h00_00_22_33_44_55; 
   parameter ETH_MAC_RX_UCAST_ADDR          = 48'h00_00_22_33_44_55; 
   parameter ETH_MAC_RX_SUPP_ADDR_0             = 48'h22_33_44_55_66_77;
    parameter ETH_MAC_RX_SUPP_ADDR_1        = 48'h44_55_66_77_88_99; 
    parameter ETH_MAC_RX_SUPP_ADDR_2        = 48'h66_77_88_99_aa_bb;
    parameter ETH_MAC_RX_SUPP_ADDR_3        = 48'h88_99_aa_bb_cc_dd;
    parameter ETH_MAC_RX_SUPP_ENA_2         = 1;
    parameter ETH_MAC_RX_SUPP_ENA_0         = 1;
    parameter ETH_MAC_RX_SUPP_ENA_1         = 1;
    parameter ETH_MAC_RX_SUPP_ENA_3         = 1; 
    parameter ETH_SYMBOL_EFD                = 8'hFD;

    
    // frame content
    rand bit [7:0] da[6];
    rand bit [7:0] sa[6];
    bit [7:0] vlan_tag_data[2] = '{{8'h81}, {8'h00}};
    rand bit [7:0] vlan_info[2];
    bit [7:0] stacked_vlan_tag_data[2] = '{{8'h81}, {8'h00}};
    rand bit [7:0] stacked_vlan_info[2];
    bit [15:0] cntrl_field = {16'h8808};
    bit [7:0] pause_opcode[2] = '{{8'h00}, {8'h01}};
    bit [7:0] pfc_opcode[2] = '{{8'h01}, {8'h01}};
    rand bit [15:0] pause_quanta = {16'h0010};
    rand bit [15:0] pfc_priority_ena = {16'h0000};
    rand bit [15:0] pfc_pause_quanta[8] = '{{16'h0010}, {16'h0011}, {16'h0012}, {16'h0013}, {16'h0014}, {16'h0015}, {16'h0016}, {16'h0017}};
    rand bit [15:0] length_type;
    rand bit [7:0] eth_payload[];
    bit [7:0] crc[4];
    
    rand bit [7:0] client_defined_preamble[8] = '{{8'h00}, {8'h11}, {8'h22}, {8'h33}, {8'h44}, {8'h55}, {8'h66}, {ETH_SYMBOL_SFD}};; // Preamble
    rand bit [7:0] client_defined_preamble_with_tx_insert_address[6]; //for preamble + SA insert
    
    
    // Properties of content
    bit insert_pad = 0;
    bit insert_crc = 0;
    bit insert_client_defined_preamble = 0;
    bit post_insert_client_defined_preamble = 0;
    bit insert_client_defined_preamble_plus_insert_address = 0;
    
    
    
    
    // DUT configuration
    bit en_all_ucast = 0;
    `ifdef TSE_MAC_RX_EN_ALL_MCAST
        bit en_all_mcast = TSE_MAC_RX_EN_ALL_MCAST;
    `else
        bit en_all_mcast = 1;
    `endif
    bit crc_check = 1;
    bit no_len_check = 0;
    int unsigned max_frame_len = 1518;
    
    
    
    
    
    // Constraints
    constraint properties {
        
        frame_type inside {DATA_FRAME, TYPE_FRAME, CONTROL_FRAME};
        control_type inside {PAUSE_CONTROL, PFC_CONTROL, MISC_CONTROL};
        da_type inside {UNICAST, MULTICAST, BROADCAST, UNICAST_INVALID, MULTICAST_PAUSE};
        error_type inside {NO_ERROR, ERROR_CRC, ERROR_UNDERSIZED, ERROR_OVERSIZED, ERROR_PAYLOAD_LENGTH};
        
        if(frame_type == DATA_FRAME) {
            control_type == MISC_CONTROL;
        }
        
        if(frame_type == CONTROL_FRAME) {
            tag_type == UNTAGGED;
            frame_length == 64;
            payload_length >= 20;
            payload_length <= 46;
        }
        
        tag_type inside {UNTAGGED, VLAN, SVLAN};
        
        frame_length dist {[(18 + tag_type * 4):65543]:/1};
        
        if(frame_length == 64) {
            payload_length inside {[0:46 - tag_type * 4]};
            frame_data.size == 64;
        }
        else {
            payload_length == frame_length - tag_type * 4 - 18;
            
            frame_data.size == frame_length;
        }
        
        ipg inside {[0:5000]};
        
    }
    
    constraint content {
        
        if(da_type == BROADCAST) {
            da[0] == ETH_MAC_BROADCAST_ADDRESS[47:40];
            da[1] == ETH_MAC_BROADCAST_ADDRESS[39:32];
            da[2] == ETH_MAC_BROADCAST_ADDRESS[31:24];
            da[3] == ETH_MAC_BROADCAST_ADDRESS[23:16];
            da[4] == ETH_MAC_BROADCAST_ADDRESS[15:8];
            da[5] == ETH_MAC_BROADCAST_ADDRESS[7:0];
        }
        else if(da_type == MULTICAST_PAUSE) {
            {da[0], da[1], da[2], da[3], da[4], da[5]} == ETH_MAC_PAUSE_MCAST_ADDRESS;
        }
        else if(da_type == MULTICAST) {
            da[0][0] == 1'b1;
            {da[0], da[1], da[2], da[3], da[4], da[5]} != ETH_MAC_BROADCAST_ADDRESS;
            
            {da[0], da[1], da[2], da[3], da[4], da[5]} != ETH_MAC_PAUSE_MCAST_ADDRESS;
        }
        else {
            da[0][0] == 1'b0;
        }
        
        if(frame_type == CONTROL_FRAME) {
            length_type == cntrl_field;
            
            if(control_type == PAUSE_CONTROL) {
                {eth_payload[0], eth_payload[1]} == {pause_opcode[0], pause_opcode[1]};
                {eth_payload[2], eth_payload[3]} == pause_quanta;
            }
            else if(control_type == PFC_CONTROL) {
                {eth_payload[0], eth_payload[1]} == {pfc_opcode[0], pfc_opcode[1]};
                {eth_payload[2], eth_payload[3]} == {pfc_priority_ena[15:8], pfc_priority_ena[7:0]};
                {eth_payload[4], eth_payload[5]} == pfc_pause_quanta[0];
                {eth_payload[6], eth_payload[7]} == pfc_pause_quanta[1];
                {eth_payload[8], eth_payload[9]} == pfc_pause_quanta[2];
                {eth_payload[10], eth_payload[11]} == pfc_pause_quanta[3];
                {eth_payload[12], eth_payload[13]} == pfc_pause_quanta[4];
                {eth_payload[14], eth_payload[15]} == pfc_pause_quanta[5];
                {eth_payload[16], eth_payload[17]} == pfc_pause_quanta[6];
                {eth_payload[18], eth_payload[19]} == pfc_pause_quanta[7];
            }
            else {
                {eth_payload[0], eth_payload[1]} != {pause_opcode[0], pause_opcode[1]};
                {eth_payload[0], eth_payload[1]} != {pfc_opcode[0], pfc_opcode[1]};
            }
        }
        else if(frame_type == TYPE_FRAME) {
            `ifdef DEBUG_TYPE_FRAME //TODO: Clean up this TAG (temporary debug for FB:170023)
                length_type >= 16'hFFF0;
            `else
                length_type >= 16'h0600;
            `endif

            length_type <= 16'hFFFF;
            length_type != 16'h8100; // != VLAN frame
            length_type != 16'h8808; // != Control frame
        }
        else {
            // Constraint only if there is no payload length error
            if(!(error_type & ERROR_PAYLOAD_LENGTH)) {
                length_type == payload_length;
            }
            else {
                length_type > payload_length + 4;//+4 CRC bytes FB:437860 MAC remove CRC bytes incorrectly
                length_type < 1536;
            }
        }
        
        if(payload_length > 46 - tag_type * 4) {
            eth_payload.size == payload_length;
        }
        else {
            eth_payload.size == 46 - tag_type * 4;
        }
    }
    
    
    
    
    
    // vmm_data functions
    function new();
       // super.new(this.log);    
    endfunction
    
    function void post_randomize();
        create_content();
    endfunction
    
    static bit [31:0] crc_table[256] =
    '{
        32'h00000000, 32'h77073096, 32'hEE0E612C, 32'h990951BA,
        32'h076DC419, 32'h706AF48F, 32'hE963A535, 32'h9E6495A3,
        32'h0EDB8832, 32'h79DCB8A4, 32'hE0D5E91E, 32'h97D2D988,
        32'h09B64C2B, 32'h7EB17CBD, 32'hE7B82D07, 32'h90BF1D91,
        32'h1DB71064, 32'h6AB020F2, 32'hF3B97148, 32'h84BE41DE,
        32'h1ADAD47D, 32'h6DDDE4EB, 32'hF4D4B551, 32'h83D385C7,
        32'h136C9856, 32'h646BA8C0, 32'hFD62F97A, 32'h8A65C9EC,
        32'h14015C4F, 32'h63066CD9, 32'hFA0F3D63, 32'h8D080DF5,
        32'h3B6E20C8, 32'h4C69105E, 32'hD56041E4, 32'hA2677172,
        32'h3C03E4D1, 32'h4B04D447, 32'hD20D85FD, 32'hA50AB56B,
        32'h35B5A8FA, 32'h42B2986C, 32'hDBBBC9D6, 32'hACBCF940,
        32'h32D86CE3, 32'h45DF5C75, 32'hDCD60DCF, 32'hABD13D59,
        32'h26D930AC, 32'h51DE003A, 32'hC8D75180, 32'hBFD06116,
        32'h21B4F4B5, 32'h56B3C423, 32'hCFBA9599, 32'hB8BDA50F,
        32'h2802B89E, 32'h5F058808, 32'hC60CD9B2, 32'hB10BE924,
        32'h2F6F7C87, 32'h58684C11, 32'hC1611DAB, 32'hB6662D3D,
        32'h76DC4190, 32'h01DB7106, 32'h98D220BC, 32'hEFD5102A,
        32'h71B18589, 32'h06B6B51F, 32'h9FBFE4A5, 32'hE8B8D433,
        32'h7807C9A2, 32'h0F00F934, 32'h9609A88E, 32'hE10E9818,
        32'h7F6A0DBB, 32'h086D3D2D, 32'h91646C97, 32'hE6635C01,
        32'h6B6B51F4, 32'h1C6C6162, 32'h856530D8, 32'hF262004E,
        32'h6C0695ED, 32'h1B01A57B, 32'h8208F4C1, 32'hF50FC457,
        32'h65B0D9C6, 32'h12B7E950, 32'h8BBEB8EA, 32'hFCB9887C,
        32'h62DD1DDF, 32'h15DA2D49, 32'h8CD37CF3, 32'hFBD44C65,
        32'h4DB26158, 32'h3AB551CE, 32'hA3BC0074, 32'hD4BB30E2,
        32'h4ADFA541, 32'h3DD895D7, 32'hA4D1C46D, 32'hD3D6F4FB,
        32'h4369E96A, 32'h346ED9FC, 32'hAD678846, 32'hDA60B8D0,
        32'h44042D73, 32'h33031DE5, 32'hAA0A4C5F, 32'hDD0D7CC9,
        32'h5005713C, 32'h270241AA, 32'hBE0B1010, 32'hC90C2086,
        32'h5768B525, 32'h206F85B3, 32'hB966D409, 32'hCE61E49F,
        32'h5EDEF90E, 32'h29D9C998, 32'hB0D09822, 32'hC7D7A8B4,
        32'h59B33D17, 32'h2EB40D81, 32'hB7BD5C3B, 32'hC0BA6CAD,
        32'hEDB88320, 32'h9ABFB3B6, 32'h03B6E20C, 32'h74B1D29A,
        32'hEAD54739, 32'h9DD277AF, 32'h04DB2615, 32'h73DC1683,
        32'hE3630B12, 32'h94643B84, 32'h0D6D6A3E, 32'h7A6A5AA8,
        32'hE40ECF0B, 32'h9309FF9D, 32'h0A00AE27, 32'h7D079EB1,
        32'hF00F9344, 32'h8708A3D2, 32'h1E01F268, 32'h6906C2FE,
        32'hF762575D, 32'h806567CB, 32'h196C3671, 32'h6E6B06E7,
        32'hFED41B76, 32'h89D32BE0, 32'h10DA7A5A, 32'h67DD4ACC,
        32'hF9B9DF6F, 32'h8EBEEFF9, 32'h17B7BE43, 32'h60B08ED5,
        32'hD6D6A3E8, 32'hA1D1937E, 32'h38D8C2C4, 32'h4FDFF252,
        32'hD1BB67F1, 32'hA6BC5767, 32'h3FB506DD, 32'h48B2364B,
        32'hD80D2BDA, 32'hAF0A1B4C, 32'h36034AF6, 32'h41047A60,
        32'hDF60EFC3, 32'hA867DF55, 32'h316E8EEF, 32'h4669BE79,
        32'hCB61B38C, 32'hBC66831A, 32'h256FD2A0, 32'h5268E236,
        32'hCC0C7795, 32'hBB0B4703, 32'h220216B9, 32'h5505262F,
        32'hC5BA3BBE, 32'hB2BD0B28, 32'h2BB45A92, 32'h5CB36A04,
        32'hC2D7FFA7, 32'hB5D0CF31, 32'h2CD99E8B, 32'h5BDEAE1D,
        32'h9B64C2B0, 32'hEC63F226, 32'h756AA39C, 32'h026D930A,
        32'h9C0906A9, 32'hEB0E363F, 32'h72076785, 32'h05005713,
        32'h95BF4A82, 32'hE2B87A14, 32'h7BB12BAE, 32'h0CB61B38,
        32'h92D28E9B, 32'hE5D5BE0D, 32'h7CDCEFB7, 32'h0BDBDF21,
        32'h86D3D2D4, 32'hF1D4E242, 32'h68DDB3F8, 32'h1FDA836E,
        32'h81BE16CD, 32'hF6B9265B, 32'h6FB077E1, 32'h18B74777,
        32'h88085AE6, 32'hFF0F6A70, 32'h66063BCA, 32'h11010B5C,
        32'h8F659EFF, 32'hF862AE69, 32'h616BFFD3, 32'h166CCF45,
        32'hA00AE278, 32'hD70DD2EE, 32'h4E048354, 32'h3903B3C2,
        32'hA7672661, 32'hD06016F7, 32'h4969474D, 32'h3E6E77DB,
        32'hAED16A4A, 32'hD9D65ADC, 32'h40DF0B66, 32'h37D83BF0,
        32'hA9BCAE53, 32'hDEBB9EC5, 32'h47B2CF7F, 32'h30B5FFE9,
        32'hBDBDF21C, 32'hCABAC28A, 32'h53B39330, 32'h24B4A3A6,
        32'hBAD03605, 32'hCDD70693, 32'h54DE5729, 32'h23D967BF,
        32'hB3667A2E, 32'hC4614AB8, 32'h5D681B02, 32'h2A6F2B94,
        32'hB40BBE37, 32'hC30C8EA1, 32'h5A05DF1B, 32'h2D02EF8D
    };
    
    virtual function void calculate_crc(ref bit [7:0] crc[4]);
        int unsigned i;
        
        bit [31:0] crc_int;
        
        // init CRC register with all one
        crc_int = 32'hffffffff;
        
        for(i = 0; i < frame_data.size() - 4; i++ ) begin
            crc_int = crc_table[(crc_int & 8'hff) ^ frame_data[i]] ^ ((crc_int >> 8) & 32'h00ffffff);
        end
        
        crc_int = ~crc_int;
        
        crc[0] = crc_int[7:0];
        crc[1] = crc_int[15:8];
        crc[2] = crc_int[23:16];
        crc[3] = crc_int[31:24];
    endfunction
    
    virtual function void update_properties();
        // offset variables
        int unsigned da_offset;
        int unsigned sa_offset;
        int unsigned vlan_offset;
        int unsigned stacked_vlan_offset;
        int unsigned length_type_offset;
        int unsigned payload_offset;
        int unsigned crc_offset;
        
        // intermediate variables
        int unsigned oversize_threshold;
        bit [7:0] crc[4];
        
        // variables that store global parameters
        // to avoid following error when use only partial of global parameters
        // eg: ETH_MAC_RX_UCAST_ADDR[7:0]
        /*
            Error-[NYI-NS] Not Yet Implemented
            Feature is not yet supported: partselects of $root parameters
        */
        bit [47:0] eth_mac_ucast_address = ETH_MAC_RX_UCAST_ADDR;
        bit [47:0] eth_mac_supp_address_0 = ETH_MAC_RX_SUPP_ADDR_0;
        bit [47:0] eth_mac_supp_address_1 = ETH_MAC_RX_SUPP_ADDR_1;
        bit [47:0] eth_mac_supp_address_2 = ETH_MAC_RX_SUPP_ADDR_2;
        bit [47:0] eth_mac_supp_address_3 = ETH_MAC_RX_SUPP_ADDR_3;
        
        bit [47:0] eth_mac_pause_mcast_address = ETH_MAC_PAUSE_MCAST_ADDRESS;

        // Do not check for fragmented frame, or else the simulation will hang
        if(frame_data.size() < 18) begin
            error_type = ERROR_UNDERSIZED;
            frame_length = frame_data.size();
            crc_offset = frame_length - 4;
            
            if(crc_check) begin
                calculate_crc(crc);
                if(
                    (frame_data[crc_offset + 0] != crc[0]) ||
                    (frame_data[crc_offset + 1] != crc[1]) ||
                    (frame_data[crc_offset + 2] != crc[2]) ||
                    (frame_data[crc_offset + 3] != crc[3])
                ) begin
                    error_type = error_type | ERROR_CRC;
                end
            end
            
            return;
        end
        
        // frame length
        frame_length = frame_data.size();
        
        da_offset = 0;
        sa_offset = da_offset + 6;
        vlan_offset = sa_offset + 6;
        stacked_vlan_offset = vlan_offset + 4;
        
        // vlan tagged frame
        if(
            (frame_data[vlan_offset] == 8'h81) &&
            (frame_data[vlan_offset + 1] == 8'h00) &&
            (frame_data[stacked_vlan_offset] == 8'h81) &&
            (frame_data[stacked_vlan_offset + 1] == 8'h00)
        ) begin
            `ifdef ETH_MAC_RX_VLANDET_DIS
                tag_type = UNTAGGED;
            `elsif ETH_MAC_TX_VLANDET_DIS
                tag_type = UNTAGGED;
            `else
                tag_type = SVLAN;
            `endif
        end
        else if(
            (frame_data[vlan_offset] == 8'h81) &&
            (frame_data[vlan_offset + 1] == 8'h00)
        ) begin
            `ifdef ETH_MAC_RX_VLANDET_DIS
                tag_type = UNTAGGED;
            `elsif ETH_MAC_TX_VLANDET_DIS
                tag_type = UNTAGGED;
            `else
                tag_type = VLAN;
            `endif
        end
        else begin
            tag_type = UNTAGGED;
        end
        
        // offset calculation
        length_type_offset = vlan_offset + tag_type * 4;
        payload_offset = length_type_offset + 2;
        crc_offset = frame_length - 4;
        
        // unicast, multicast, broadcast, or valid_frame frame
        // check for unicast address
        if(
            (frame_data[da_offset + 0] == eth_mac_ucast_address[47:40]) &&
            (frame_data[da_offset + 1] == eth_mac_ucast_address[39:32]) &&
            (frame_data[da_offset + 2] == eth_mac_ucast_address[31:24]) &&
            (frame_data[da_offset + 3] == eth_mac_ucast_address[23:16]) &&
            (frame_data[da_offset + 4] == eth_mac_ucast_address[15:8]) &&
            (frame_data[da_offset + 5] == eth_mac_ucast_address[7:0])
        ) begin
            da_type = UNICAST;
            da_ucast_type = UCAST_ADDR;
        end
        
        // check for supplementary address 0
        else if(
            (frame_data[da_offset + 0] == eth_mac_supp_address_0[47:40]) &&
            (frame_data[da_offset + 1] == eth_mac_supp_address_0[39:32]) &&
            (frame_data[da_offset + 2] == eth_mac_supp_address_0[31:24]) &&
            (frame_data[da_offset + 3] == eth_mac_supp_address_0[23:16]) &&
            (frame_data[da_offset + 4] == eth_mac_supp_address_0[15:8]) &&
            (frame_data[da_offset + 5] == eth_mac_supp_address_0[7:0])
        ) begin
            if(ETH_MAC_RX_SUPP_ENA_0) begin
                da_type = UNICAST;
            end
            else begin
                da_type = UNICAST_INVALID;
            end
            da_ucast_type = SUPP_ADDR_0;
        end
        
        // check for supplementary address 1
        else if(
            (frame_data[da_offset + 0] == eth_mac_supp_address_1[47:40]) &&
            (frame_data[da_offset + 1] == eth_mac_supp_address_1[39:32]) &&
            (frame_data[da_offset + 2] == eth_mac_supp_address_1[31:24]) &&
            (frame_data[da_offset + 3] == eth_mac_supp_address_1[23:16]) &&
            (frame_data[da_offset + 4] == eth_mac_supp_address_1[15:8]) &&
            (frame_data[da_offset + 5] == eth_mac_supp_address_1[7:0])
        ) begin
            if(ETH_MAC_RX_SUPP_ENA_1) begin
                da_type = UNICAST;
            end
            else begin
                da_type = UNICAST_INVALID;
            end
            da_ucast_type = SUPP_ADDR_1;
        end
        
        // check for supplementary address 2
        else if(
            (frame_data[da_offset + 0] == eth_mac_supp_address_2[47:40]) &&
            (frame_data[da_offset + 1] == eth_mac_supp_address_2[39:32]) &&
            (frame_data[da_offset + 2] == eth_mac_supp_address_2[31:24]) &&
            (frame_data[da_offset + 3] == eth_mac_supp_address_2[23:16]) &&
            (frame_data[da_offset + 4] == eth_mac_supp_address_2[15:8]) &&
            (frame_data[da_offset + 5] == eth_mac_supp_address_2[7:0])
        ) begin
            if(ETH_MAC_RX_SUPP_ENA_2) begin
                da_type = UNICAST;
            end
            else begin
                da_type = UNICAST_INVALID;
            end
            da_ucast_type = SUPP_ADDR_2;
        end
        
        // check for supplementary address 3
        else if(
            (frame_data[da_offset + 0] == eth_mac_supp_address_3[47:40]) &&
            (frame_data[da_offset + 1] == eth_mac_supp_address_3[39:32]) &&
            (frame_data[da_offset + 2] == eth_mac_supp_address_3[31:24]) &&
            (frame_data[da_offset + 3] == eth_mac_supp_address_3[23:16]) &&
            (frame_data[da_offset + 4] == eth_mac_supp_address_3[15:8]) &&
            (frame_data[da_offset + 5] == eth_mac_supp_address_3[7:0])
        ) begin
            if(ETH_MAC_RX_SUPP_ENA_3) begin
                da_type = UNICAST;
            end
            else begin
                da_type = UNICAST_INVALID;
            end
            da_ucast_type = SUPP_ADDR_3;
        end
        
        // check for broadcast address
        else if(
            (frame_data[da_offset + 0] == 8'hFF) &&
            (frame_data[da_offset + 1] == 8'hFF) &&
            (frame_data[da_offset + 2] == 8'hFF) &&
            (frame_data[da_offset + 3] == 8'hFF) &&
            (frame_data[da_offset + 4] == 8'hFF) &&
            (frame_data[da_offset + 5] == 8'hFF)
        ) begin
            da_type = BROADCAST;
        end
        
        // check for pause frame global multicast address
        else if(
            (frame_data[da_offset + 0] == eth_mac_pause_mcast_address[47:40]) &&
            (frame_data[da_offset + 1] == eth_mac_pause_mcast_address[39:32]) &&
            (frame_data[da_offset + 2] == eth_mac_pause_mcast_address[31:24]) &&
            (frame_data[da_offset + 3] == eth_mac_pause_mcast_address[23:16]) &&
            (frame_data[da_offset + 4] == eth_mac_pause_mcast_address[15:8]) &&
            (frame_data[da_offset + 5] == eth_mac_pause_mcast_address[7:0])
        ) begin
            da_type = MULTICAST_PAUSE;
        end
        
        // check for multicast address
        else if(frame_data[da_offset + 0][0] == 1'b1) begin
            da_type = MULTICAST;
        end
        
        // invalid frame
        else begin
            if(en_all_ucast) begin
                da_type = UNICAST;
            end
            else begin
                da_type = UNICAST_INVALID;
            end
        end
        
        // payload length
        length_type = frame_data[length_type_offset + 0] * 256 + frame_data[length_type_offset + 1];
        payload_length = frame_length - 18 - tag_type * 4;
        
        pfc_priority_ena[15:0] = 16'h0;
        pfc_pause_quanta[0] = 16'h0;
        pfc_pause_quanta[1] = 16'h0;
        pfc_pause_quanta[2] = 16'h0;
        pfc_pause_quanta[3] = 16'h0;
        pfc_pause_quanta[4] = 16'h0;
        pfc_pause_quanta[5] = 16'h0;
        pfc_pause_quanta[6] = 16'h0;
        pfc_pause_quanta[7] = 16'h0;
        
        // control frame
        if (
            (frame_data[length_type_offset + 0] == 8'h88) &&
            (frame_data[length_type_offset + 1] == 8'h08)
        )begin
            frame_type = CONTROL_FRAME;
            
            if(
                (frame_data[length_type_offset + 2] == 8'h00) &&
                (frame_data[length_type_offset + 3] == 8'h01)
            ) begin
                control_type = PAUSE_CONTROL;
                
                if((da_type == MULTICAST_PAUSE) || (da_type == UNICAST)) begin
                    pause_quanta[0] = {frame_data[payload_offset + 0], frame_data[payload_offset + 1]};
                end
            end
            else if(
                (frame_data[length_type_offset + 2] == 8'h01) &&
                (frame_data[length_type_offset + 3] == 8'h01)
            ) begin
                control_type = PFC_CONTROL;
                
                if(da_type == MULTICAST_PAUSE) begin
                    pfc_priority_ena[15:0] = {frame_data[payload_offset + 2], frame_data[payload_offset + 3]};
                    pfc_pause_quanta[0] = {frame_data[payload_offset + 4], frame_data[payload_offset + 5]};
                    pfc_pause_quanta[1] = {frame_data[payload_offset + 6], frame_data[payload_offset + 7]};
                    pfc_pause_quanta[2] = {frame_data[payload_offset + 8], frame_data[payload_offset + 9]};
                    pfc_pause_quanta[3] = {frame_data[payload_offset + 10], frame_data[payload_offset + 11]};
                    pfc_pause_quanta[4] = {frame_data[payload_offset + 12], frame_data[payload_offset + 13]};
                    pfc_pause_quanta[5] = {frame_data[payload_offset + 14], frame_data[payload_offset + 15]};
                    pfc_pause_quanta[6] = {frame_data[payload_offset + 16], frame_data[payload_offset + 17]};
                    pfc_pause_quanta[7] = {frame_data[payload_offset + 18], frame_data[payload_offset + 19]};
                end
            end
            else begin
                control_type = MISC_CONTROL;
            end
        end
        else if(
            {frame_data[length_type_offset + 0], frame_data[length_type_offset + 1]} >= 16'h0600
            ) begin
            frame_type = TYPE_FRAME;
        end
        else begin
            frame_type = DATA_FRAME;
        end
        
        if(!en_all_mcast) begin
            // Data Frame
            if((frame_type == DATA_FRAME) && ((da_type == MULTICAST) || (da_type == MULTICAST_PAUSE))) begin
                da_type = UNICAST_INVALID;
            end
            
            if((frame_type == TYPE_FRAME) && ((da_type == MULTICAST) || (da_type == MULTICAST_PAUSE))) begin
                da_type = UNICAST_INVALID;
            end
            
            // Control Frame
            if((frame_type == CONTROL_FRAME) && (control_type != PAUSE_CONTROL)) begin
                if((da_type == MULTICAST) || (da_type == MULTICAST_PAUSE)) begin
                    da_type = UNICAST_INVALID;
                end
            end
            
            // Pause Frame
            if((frame_type == CONTROL_FRAME) && (control_type == PAUSE_CONTROL)) begin
                if((da_type == MULTICAST)) begin
                    da_type = UNICAST_INVALID;
                end
            end
            
            // PFC Frame
            if((frame_type == CONTROL_FRAME) && (control_type == PFC_CONTROL)) begin
                if((da_type == MULTICAST)) begin
                    da_type = UNICAST_INVALID;
                end
            end
        end
               
        // Reset error
        error_type = NO_ERROR;
        
        // error_crc
        if(crc_check) begin
            calculate_crc(crc);
            if(
                (frame_data[crc_offset + 0] != crc[0]) ||
                (frame_data[crc_offset + 1] != crc[1]) ||
                (frame_data[crc_offset + 2] != crc[2]) ||
                (frame_data[crc_offset + 3] != crc[3])
            ) begin
                error_type = error_type | ERROR_CRC;
            end
        end
        
        // error_oversized frame
        oversize_threshold = max_frame_len + tag_type * 4;
        if(frame_length > oversize_threshold) begin
            error_type = error_type | ERROR_OVERSIZED;
        end
        
        // error_undersized frame
        if(frame_length < 64) begin
            error_type = error_type | ERROR_UNDERSIZED;
        end
        
        // error_payload_length
        if(no_len_check) begin
        end
        else begin
            if(frame_type == CONTROL_FRAME) begin
            end
            else if(frame_type == TYPE_FRAME) begin
            end
            else if(payload_length <= 46 - tag_type * 4) begin
                if(payload_length < length_type) begin
                    error_type = error_type | ERROR_PAYLOAD_LENGTH;
                end
            end
            else if(payload_length != length_type) begin
                error_type = error_type | ERROR_PAYLOAD_LENGTH;
            end
            else begin
            end
        end
        
    endfunction
    
    function void update_content();
        
        int unsigned i;
        int unsigned client_defined_preamble_offset;
        int unsigned da_offset;
        int unsigned sa_offset;
        int unsigned vlan_tag_offset;
        int unsigned stacked_vlan_tag_offset;
        int unsigned length_type_offset;
        int unsigned eth_payload_offset;
        int unsigned crc_offset;

        // Get offset of the Ethernet data field
        da_offset = 0;
        sa_offset = da_offset + 6;
        vlan_tag_offset = sa_offset + 6;
        stacked_vlan_tag_offset = vlan_tag_offset + 4;
        
        length_type_offset = sa_offset + tag_type * 4 + 6;
        
        eth_payload_offset = length_type_offset + 2;
        
        for(i = 0; i < 6; i++) begin
            da[i] = frame_data[da_offset + i];
        end
        
        for(i = 0; i < 6; i++) begin
            sa[i] = frame_data[sa_offset + i];
        end
        
        if(tag_type > 0) begin
            for(i = 0; i < 2; i++) begin
                vlan_tag_data[i] = frame_data[vlan_tag_offset + i];
            end
            for(i = 0; i < 2; i++) begin
                vlan_info[i] = frame_data[vlan_tag_offset + 2 + i];
            end
        end
        
        if(tag_type > 1) begin
            for(i = 0; i < 2; i++) begin
                stacked_vlan_tag_data[i] = frame_data[stacked_vlan_tag_offset + i];
            end
            for(i = 0; i < 2; i++) begin
                stacked_vlan_info[i] = frame_data[stacked_vlan_tag_offset + 2 + i];
            end
        end
        
        length_type[15:8] = frame_data[length_type_offset + 0];
        length_type[7:0] = frame_data[length_type_offset + 1];
        
                
                `ifdef TSE_MAC_TX_OMIT_CRC
                // If OMIT CRC, during Create_Content it should generate and append CRC for the target mac_frame
                // The frame should comprise of DA+SA+TYPE+PAYLOAD+CRC
                    payload_length = frame_data.size() - eth_payload_offset -4;
                `else 
                    `ifdef TSE_PCS_PMA_LVDS_STANDALONE
                        //If PCS+PMA variaant, it receive packet from RX and Loopback through TX. 
                        //The original frame itself already has CRC appended
                        payload_length = frame_data.size() - eth_payload_offset -4;    
                    `else
                    // Original mac_frame should not have appended CRC,  
                    // The frame should comprise of DA+SA+TYPE+PAYLOAD
                        payload_length = frame_data.size() - eth_payload_offset;
                    `endif
                `endif
                
        eth_payload = new[payload_length];
        for(i = 0; i < payload_length; i++) begin
            eth_payload[i] = frame_data[eth_payload_offset + i];
        end

    endfunction
    
    function void create_content();

        int unsigned i;
        int unsigned client_defined_preamble_offset;
        int unsigned da_offset;
        int unsigned sa_offset;
        int unsigned vlan_tag_offset;
        int unsigned stacked_vlan_tag_offset;
        int unsigned length_type_offset;
        int unsigned eth_payload_offset;
        int unsigned crc_offset;
        int unsigned accu;
        
        // Get offset of the Ethernet data field
        client_defined_preamble_offset = 0;
        if(insert_client_defined_preamble == 1) begin
            da_offset = 8; // +8 byte
        end
        else begin
            da_offset = 0; // without preamble
        end
        
        if (post_insert_client_defined_preamble == 1) begin
            da_offset = -8; // -8 byte
        end

        sa_offset = da_offset + 6;
        vlan_tag_offset = sa_offset + 6;
        stacked_vlan_tag_offset = vlan_tag_offset + 4;
        
        length_type_offset = sa_offset + tag_type * 4 + 6;
        
        eth_payload_offset = length_type_offset + 2;
        crc_offset = eth_payload_offset + payload_length;

        
        // Reallocated data
        if(frame_length < 64) begin
            frame_data = new[64];
        end
        else begin
            frame_data = new[frame_length];
        end
 
        if(insert_client_defined_preamble == 1) begin
            for(i = 0; i < 7; i++) begin
                frame_data[client_defined_preamble_offset + i] = client_defined_preamble[i];
            end
            frame_data[client_defined_preamble_offset + 7] = ETH_SYMBOL_SFD; //Insert SFD by user when enable Preamble
        end
				
        // Update payload data
        for(i = 0; i < 6; i++) begin
            frame_data[da_offset + i] = da[i];
        end
        
        for(i = 0; i < 6; i++) begin
            frame_data[sa_offset + i] = sa[i];
        end

        if(tag_type > 0) begin
            for(i = 0; i < 2; i++) begin
                frame_data[vlan_tag_offset + i] = vlan_tag_data[i];
            end
            for(i = 0; i < 2; i++) begin
                frame_data[vlan_tag_offset + 2 + i] = vlan_info[i];
            end
        end
        
        if(tag_type > 1) begin
            for(i = 0; i < 2; i++) begin
                frame_data[stacked_vlan_tag_offset + i] = stacked_vlan_tag_data[i];
            end
            for(i = 0; i < 2; i++) begin
                frame_data[stacked_vlan_tag_offset + 2 + i] = stacked_vlan_info[i];
            end
        end    
        
        frame_data[length_type_offset + 0] = length_type[15:8];
        frame_data[length_type_offset + 1] = length_type[7:0];    
        
		accu = 0;
        for(i = 0; i < eth_payload.size(); i++) begin
			
            `ifdef ETH_MAC_AVALON_ST_LOOPBACK_TEST
                frame_data[eth_payload_offset + i] = eth_payload[i];
            `else
                // Fill Data with incremental order if this mode is turned-on
                // Allow only to use Incremental order when not in AVST loopback mode.
                if(inc_data_mode && da_type!=MULTICAST_PAUSE) begin
                    frame_data[eth_payload_offset + i] = accu++; 
                end
                else begin
                    frame_data[eth_payload_offset + i] = eth_payload[i];
                end
            `endif
        end
        
        if(insert_pad == 0) begin
            crc_offset = 14 + tag_type * 4 + payload_length;
        end
        else begin
            if(crc_offset < 60) begin
                for(i = crc_offset; i < 60; i++) begin
                    frame_data[i] = 8'h00;
                end
                crc_offset = 60;
            end
        end

        //Updating TX SA insert when Preamble passthrough enable (hckhor)
        if (insert_client_defined_preamble_plus_insert_address == 1) begin
            for(i = 0; i < 6; i++) begin
                frame_data[sa_offset + i + 8] = client_defined_preamble_with_tx_insert_address[i];
            end
        end

        frame_data = new[crc_offset + 4](frame_data);
        calculate_crc(crc);
        for(i = 0; i < 4; i++) begin
            if(error_type & altera_data_swip_eth_mac_frame_c::ERROR_CRC) begin
                crc[i] = ~crc[i];
            end
            frame_data[crc_offset + i] = crc[i];
        end
        `ifdef TSE_MAC_TX_OMIT_CRC
            //In TSE_MAC_TX_OMIT_CRC test, the TX-AVST generator will insert CRC to the packet. 
            //During score board altera_sb_swip_tse_tx_c update content, insert_crc=0 mode is selected. 
            //Do not remove 4 byte from frame-data in this case.
        `else
            `ifdef TSE_PCS_PMA_LVDS_STANDALONE
                //In PCS+PMA test, the data loopback already has CRC appended.
            `else
                if(insert_crc == 0) begin
                    if (post_insert_client_defined_preamble == 1 && insert_pad == 0) begin
                        frame_data = new[frame_data.size() - 12](frame_data); // - 12 (extra 8) when pad disable
                    end else begin
                        frame_data = new[frame_data.size() - 4](frame_data);
                    end
                end else begin
                    if (post_insert_client_defined_preamble == 1 && insert_pad == 0) begin
                        // TODO: Calculate CRC - CRC disappear at last 4 bytes?
                        frame_data = new[frame_data.size() - 8](frame_data); 
                    end
                end
            `endif
        `endif
    endfunction

endclass


`endif
