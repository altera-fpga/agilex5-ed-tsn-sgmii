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


`ifndef ALTERA_COVERAGE_SWIP_ETH_XGMII_DDR_C__SV
`define ALTERA_COVERAGE_SWIP_ETH_XGMII_DDR_C__SV
 `define XGMII_DDR_SYMBOLSPERBEAT 4
class altera_coverage_swip_eth_xgmii_ddr_c extends uvm_component ;
    `uvm_component_utils(altera_coverage_swip_eth_xgmii_ddr_c)
    // coverage instance properties
    string inst_name ;
    string TEST_NAME = "UNDEFINED_TEST";
    string DUT_NAME = "eth_env_top";
    
   parameter ETH_SYMBOL_SFD                = 8'hD5;
   parameter ETH_SYMBOL_ERROR              = 8'hFE;
   parameter ETH_SYMBOL_START              = 8'hFB;
   parameter ETH_SYMBOL_PREAMBLE           = 8'h55;
   parameter ETH_SYMBOL_IDLE               = 8'h07;
   parameter ETH_SYMBOL_EFD                = 8'hFD;
   parameter ETH_SYMBOL_SEQUENCE           = 8'h9C;   
  
    // transaction properties
    bit [XGMII_DDR_SYMBOLSPERBEAT - 1:0] ctrl;
    bit [7:0] data[XGMII_DDR_SYMBOLSPERBEAT];
    
    bit [XGMII_DDR_SYMBOLSPERBEAT - 1:0] ctrl_prev;
    bit [7:0] data_prev[XGMII_DDR_SYMBOLSPERBEAT];
    virtual spy_interface spy_if;
 
    // extracted properties
    int start_align_lane = -1;
    int preamble_num = -1;
    int sfd_align_lane = -1;
    int terminate_align_lane = -1;
    int tx_rx; // 1 for TX, 0 for RX   
    bit frame_in_progress = 0;
    bit header_in_progress = 0;
    
    // UNH 46.2.5
    bit full_idle_before_start = 0;
    bit local_fault_before_start = 0;
    bit remote_fault_before_start = 0;
    bit reserved_sequence_before_start = 0;
    bit terminate_before_start = 0;
    bit start_before_start = 0;
    bit error_before_start = 0;
    bit data_codegroup_before_start = 0;
    
    // UNH 46.2.6 A
    bit idle_replace_terminate = 0;
    bit sequence_replace_terminate = 0;
    bit start_replace_terminate = 0;
        
    // UNH 46.2.6 B
    bit start_after_terminate = 0;
    bit data_codegroup_after_terminate = 0;
    bit error_after_terminate = 0;
    bit terminate_after_terminate = 0;
    
    // UNH 46.2.7
    int error_replace_preamble = -1;
    bit error_replace_sfd = 0;
    bit error_replace_data = 0;
    bit error_replace_terminate = 0;
    
    // UNH 46.3
    int local_fault_count = 0;
    int local_fault_count_prev = 0;
    int remote_fault_count = 0;
    int remote_fault_count_prev = 0;
    int reserved_sequence_count = 0;
    int reserved_sequence_count_prev = 0;
    int idle_column_count = 0;
    int reserved_sequence_idle_column_count = 0;
    int idle_column_count_prev = 0;
    int reserved_sequence_idle_column_count_prev = 0;
    
    // UNH 46.3.3
    int lf_3__rf_n__lf_1__count = 0;
    bit lf_3__rf_n__lf_1__valid = 0;
    
    int rf_3__lf_n__rf_1__count = 0;
    bit rf_3__lf_n__rf_1__valid = 0;
    
    int lf_3__rsvf_n__lf_1__count = 0;
    bit lf_3__rsvf_n__lf_1__valid = 0;
    
    int rf_3__rsvf_n__rf_1__count = 0;
    bit rf_3__rsvf_n__rf_1__valid = 0;
    
    int lf_1__rf_1__4_times_count = 0;
    int rf_1__lf_1__3_times_count = 0;
    
    int lf_1__rsvf_1__4_times_count = 0;
    int rsvf_1__lf_1__3_times_count = 0;
    
    int rf_1__rsvf_1__4_times_count = 0;
    int rsvf_1__rf_1__3_times_count = 0;
    
    // UNH 46.3.4
    int local_fault_count_no_clear = 0;
    int local_fault_count_no_clear_prev = 0;
    int remote_fault_count_no_clear = 0;
    int remote_fault_count_no_clear_prev = 0;
    int clear_counter = 0;
    
    // coverage
    covergroup cg_xgmii_ddr;
        option.name = $psprintf("%s__%s", DUT_NAME, inst_name);
        
        option.per_instance = 1;
        
        /////////////////////////////////////////////////////////////////
        // Start
        /////////////////////////////////////////////////////////////////
        start_align_lane_const_preamble_cp: coverpoint start_align_lane iff((terminate_align_lane >= 0) && (preamble_num == 6)) {
            bins lane[] = {[0:3]};
        }
        
        start_align_lane_const_sfd_lane_cp: coverpoint start_align_lane iff((terminate_align_lane >= 0) && (sfd_align_lane == 3)) {
            bins lane[] = {[0:3]};
        }
        
        /////////////////////////////////////////////////////////////////
        // Preamble
        /////////////////////////////////////////////////////////////////
        preamble_length_cp: coverpoint preamble_num iff(terminate_align_lane >= 0) {
            bins length[15] = {[0:14]};
        }
        
        /////////////////////////////////////////////////////////////////
        // Terminate
        /////////////////////////////////////////////////////////////////
        terminate_align_lane_cp: coverpoint terminate_align_lane {
            bins lane[] = {[0:3]};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.2.5
        /////////////////////////////////////////////////////////////////
        full_idle_before_start_cp: coverpoint full_idle_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        local_fault_before_start_cp: coverpoint local_fault_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        remote_fault_before_start_cp: coverpoint remote_fault_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        reserved_sequence_before_start_cp: coverpoint reserved_sequence_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        terminate_before_start_cp: coverpoint terminate_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        start_before_start_cp: coverpoint start_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        error_before_start_cp: coverpoint error_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        data_codegroup_before_start_cp: coverpoint data_codegroup_before_start iff(terminate_align_lane >= 0) {
            bins covered = {1};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.2.6 A
        /////////////////////////////////////////////////////////////////
        idle_replace_terminate_cp: coverpoint idle_replace_terminate iff(idle_replace_terminate) {
            bins covered = {1};
        }
        
        sequence_replace_terminate_cp: coverpoint sequence_replace_terminate iff(sequence_replace_terminate) {
            bins covered = {1};
        }
        
        start_replace_terminate_cp: coverpoint start_replace_terminate iff(start_replace_terminate) {
            bins covered = {1};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.2.6 B
        /////////////////////////////////////////////////////////////////
        start_after_terminate_cp: coverpoint start_after_terminate iff(start_after_terminate) {
            bins covered = {1};
        }
        
        data_codegroup_after_terminate_cp: coverpoint data_codegroup_after_terminate iff(data_codegroup_after_terminate) {
            bins covered = {1};
        }
        
        error_after_terminate_cp: coverpoint error_after_terminate iff(error_after_terminate) {
            bins covered = {1};
        }
        
        terminate_after_terminate_cp: coverpoint terminate_after_terminate iff(terminate_after_terminate) {
            bins covered = {1};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.2.7
        /////////////////////////////////////////////////////////////////
        error_replace_preamble_cp: coverpoint error_replace_preamble iff(error_replace_preamble >= 0) {
            bins preamble_location[6] = {[0:5]};
        }
        
        error_replace_sfd_cp: coverpoint error_replace_sfd iff(error_replace_sfd) {
            bins covered = {1};
        }
        
        error_replace_terminate_cp: coverpoint error_replace_terminate iff(error_replace_terminate) {
            bins covered = {1};
        }
        
        error_replace_data_cp: coverpoint error_replace_data iff(error_replace_data) {
            bins covered = {1};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.3.1
        /////////////////////////////////////////////////////////////////
        continuous_local_fault_cp: coverpoint local_fault_count {
            bins covered = {4};
        }
        
        continuous_remote_fault_cp: coverpoint remote_fault_count {
            bins covered = {4};
        }
        
        continuous_reserved_sequence_cp: coverpoint reserved_sequence_count {
            bins covered = {4};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.3.2
        /////////////////////////////////////////////////////////////////
        continuous_local_fault_count_cp: coverpoint local_fault_count iff((idle_column_count == 127)) {
            bins count[4] = {[1:4]};
        }
        
        continuous_remote_fault_count_cp: coverpoint remote_fault_count iff((idle_column_count == 127)) {
            bins count[4] = {[1:4]};
        }
        
        continuous_reserved_sequence_count_cp: coverpoint reserved_sequence_count iff((reserved_sequence_idle_column_count == 127)) {
            bins count[4] = {[1:4]};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.3.3
        /////////////////////////////////////////////////////////////////
        lf_3__rf_n__lf_1__count_cp: coverpoint lf_3__rf_n__lf_1__count iff((lf_3__rf_n__lf_1__valid)) {
            bins count[4] = {[1:4]};
        }
        
        rf_3__lf_n__rf_1__count_cp: coverpoint rf_3__lf_n__rf_1__count iff((rf_3__lf_n__rf_1__valid)) {
            bins count[4] = {[1:4]};
        }
        
        lf_3__rsvf_n__lf_1__count_cp: coverpoint lf_3__rsvf_n__lf_1__count iff((lf_3__rsvf_n__lf_1__valid)) {
            bins count[4] = {[1:4]};
        }
        
        rf_3__rsvf_n__rf_1__count_cp: coverpoint rf_3__rsvf_n__rf_1__count iff((rf_3__rsvf_n__rf_1__valid)) {
            bins count[4] = {[1:4]};
        }
        
        lf_1__rf_1__4_times_count_cp: coverpoint lf_1__rf_1__4_times_count iff((rf_1__lf_1__3_times_count) == 3) {
            bins count = {4};
        }
        
        lf_1__rsvf_1__4_times_count_cp: coverpoint lf_1__rsvf_1__4_times_count iff((rsvf_1__lf_1__3_times_count) == 3) {
            bins count = {4};
        }
        
        rf_1__rsvf_1__4_times_count_cp: coverpoint rf_1__rsvf_1__4_times_count iff((rsvf_1__rf_1__3_times_count) == 3) {
            bins count = {4};
        }
        
        /////////////////////////////////////////////////////////////////
        // UNH 46.3.4
        /////////////////////////////////////////////////////////////////
        no_init_fault_local_fault_column_separate_count_cp: coverpoint idle_column_count_prev iff((local_fault_count_no_clear == local_fault_count_no_clear_prev + 1) && (local_fault_count_no_clear == 4)) {
            bins idle_column_count_lt_128 = {[1:127]};
            bins idle_column_count_eq_128 = {128};
            bins idle_column_count_gt_128 = {[129:$]};
        }
        
        no_init_fault_remote_fault_column_separate_count_cp: coverpoint idle_column_count_prev iff((remote_fault_count_no_clear == remote_fault_count_no_clear_prev + 1) && (remote_fault_count_no_clear == 4)) {
            bins idle_column_count_lt_128 = {[1:127]};
            bins idle_column_count_eq_128 = {128};
            bins idle_column_count_gt_128 = {[129:$]};
        }
        
        init_local_fault_local_fault_column_separate_count_cp: coverpoint idle_column_count_prev iff((local_fault_count_no_clear == local_fault_count_no_clear_prev + 1) && (local_fault_count_no_clear == 6)) {
            bins idle_column_count_lt_128 = {[1:127]};
            bins idle_column_count_eq_128 = {128};
            bins idle_column_count_gt_128 = {[129:$]};
        }
        
        init_remote_fault_remote_fault_column_separate_count_cp: coverpoint idle_column_count_prev iff((remote_fault_count_no_clear == remote_fault_count_no_clear_prev + 1) && (remote_fault_count_no_clear == 6)) {
            bins idle_column_count_lt_128 = {[1:127]};
            bins idle_column_count_eq_128 = {128};
            bins idle_column_count_gt_128 = {[129:$]};
        }
        
    endgroup
    
    
    
    
    
    // functions
    function new(string name, uvm_component parent);
        super.new(name, parent);
        inst_name = name;

        // Update from command line if being passed down
        $value$plusargs("TEST_NAME=%s", TEST_NAME);
        $value$plusargs("DUT_NAME=%s", DUT_NAME);
       // ----------------------------------------------------------------------//
       //  We are commenting below DDR covergroup                                // 
       //  cg_xgmii_ddr is for PCS signal coverage, DM is always with MAC+PCS   //
       //  Hence we are not covering below covergroup                          //
       //----------------------------------------------------------------------//       
         //cg_xgmii_ddr = new();

         if(!uvm_config_db#(virtual spy_interface)::get(this, "", "spy_interface", spy_if)) begin
                    `uvm_fatal("spy_interface", "failed to get spy_interface intf");
                end
        
    endfunction

    task run_phase(uvm_phase phase);
     begin
       fork
      begin
       if(tx_rx == 1) begin
       forever begin
       @(spy_if.xgmii_tx_valid,spy_if.xgmii_tx_data,spy_if.xgmii_tx_control);
       sample_cover_groups(spy_if.xgmii_tx_valid,spy_if.xgmii_tx_data,spy_if.xgmii_tx_control);
       end
       end
     end
     begin
       if(tx_rx == 0) begin
       forever begin
        @(spy_if.xgmii_rx_valid,spy_if.xgmii_rx_data,spy_if.xgmii_rx_control);
       sample_cover_groups(spy_if.xgmii_rx_valid,spy_if.xgmii_rx_data,spy_if.xgmii_rx_control);
        end
       end
     end
     


       join_none
     end
    endtask: run_phase
 
    
    virtual function void sample_cover_groups(bit valid,bit[32:0] data_1,bit[3:0] control);
        
        // obtain signal data from the input transaction
        this.ctrl = control;
        this.data[0] = data_1[7:0];
        this.data[1] = data_1[15:8];
        this.data[2] = data_1[23:16];
        this.data[3] = data_1[31:24];
        
        // reset the properties at next clock cycle
        if(frame_in_progress == 0) begin
            start_align_lane = -1;
            sfd_align_lane = -1;
            terminate_align_lane = -1;
            header_in_progress = 0;
            preamble_num = -1;
        end
        
        for(int i = 0; i < XGMII_DDR_SYMBOLSPERBEAT; i++) begin
            // start_align_lane        
            if((ctrl[i] == 1'b1) && (data[i] == ETH_SYMBOL_START)) begin
                start_align_lane = i;
                frame_in_progress = 1;
                header_in_progress = 1;
                preamble_num = 0;
                continue;
            end
            
            // sfd_align_lane
            if((ctrl[i] == 1'b0) && (data[i] == ETH_SYMBOL_SFD)) begin
                if(frame_in_progress && header_in_progress) begin
                    sfd_align_lane = i;
                    header_in_progress = 0;
                    break;
                end
            end
            
            // increment preamble when no START or SFD detected for frame header processing
            if(header_in_progress && (start_align_lane >= 0) && (sfd_align_lane < 0)) begin
                
                // UNH 46.2.7 - /E/ after /S/, before SFD
                if((ctrl[i] == 1'b1) && (data[i] == ETH_SYMBOL_ERROR)) begin
                    error_replace_preamble = preamble_num;
                end
                
                preamble_num += 1;
            end
        end
        
        // terminate_align_lane
        terminate_align_lane = -1;
        for(int i = 0; i < XGMII_DDR_SYMBOLSPERBEAT; i++) begin
            if((ctrl[i] == 1'b1) && (data[i] == ETH_SYMBOL_EFD)) begin
                terminate_align_lane = i;
                frame_in_progress = 0;
                break;
            end
        end
        
        // UNH 46.2.5
        if(
            ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_START)) &&
            ((ctrl[1] == 1'b0) && (data[1] == ETH_SYMBOL_PREAMBLE)) &&
            ((ctrl[2] == 1'b0) && (data[2] == ETH_SYMBOL_PREAMBLE)) &&
            ((ctrl[3] == 1'b0) && (data[3] == ETH_SYMBOL_PREAMBLE))
            ) begin
            
            full_idle_before_start = 0;
            local_fault_before_start = 0;
            remote_fault_before_start = 0;
            reserved_sequence_before_start = 0;
            terminate_before_start = 0;
            start_before_start = 0;
            error_before_start = 0;
            data_codegroup_before_start = 0;
            
            // A full column of Idle
            if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_IDLE)) &&
                ((ctrl_prev[1] == 1'b1) && (data_prev[1] == ETH_SYMBOL_IDLE)) &&
                ((ctrl_prev[2] == 1'b1) && (data_prev[2] == ETH_SYMBOL_IDLE)) &&
                ((ctrl_prev[3] == 1'b1) && (data_prev[3] == ETH_SYMBOL_IDLE))
            ) begin
                full_idle_before_start = 1;
            end
            
            // A sequence ordered set corresponding to Local Fault
            else if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_SEQUENCE)) &&
                ((ctrl_prev[1] == 1'b0) && (data_prev[1] == 8'h00)) &&
                ((ctrl_prev[2] == 1'b0) && (data_prev[2] == 8'h00)) &&
                ((ctrl_prev[3] == 1'b0) && (data_prev[3] == 8'h01))
            ) begin
                local_fault_before_start = 1;
            end
            
            // A sequence ordered set corresponding to Remote Fault
            else if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_SEQUENCE)) &&
                ((ctrl_prev[1] == 1'b0) && (data_prev[1] == 8'h00)) &&
                ((ctrl_prev[2] == 1'b0) && (data_prev[2] == 8'h00)) &&
                ((ctrl_prev[3] == 1'b0) && (data_prev[3] == 8'h02))
            ) begin
                remote_fault_before_start = 1;
            end
            
            // A sequence ordered set corresponding to reserved value
            else if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_SEQUENCE)) &&
                ((ctrl_prev[1] == 1'b0) && (data_prev[1] == 8'h00)) &&
                ((ctrl_prev[2] == 1'b0) && (data_prev[2] == 8'h00)) &&
                ((ctrl_prev[3] == 1'b0) && ((data_prev[3] != 8'h01) && (data_prev[3] != 8'h02)))
            ) begin
                reserved_sequence_before_start = 1;
            end
            
            // A column containing a Terminate control character
            else if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_EFD)) ||
                ((ctrl_prev[1] == 1'b1) && (data_prev[1] == ETH_SYMBOL_EFD)) ||
                ((ctrl_prev[2] == 1'b1) && (data_prev[2] == ETH_SYMBOL_EFD)) ||
                ((ctrl_prev[3] == 1'b1) && (data_prev[3] == ETH_SYMBOL_EFD))
            ) begin
                terminate_before_start = 1;
            end
            
            // A column containing a Start control character
            else if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_START)) &&
                ((ctrl_prev[1] == 1'b0) && (data_prev[1] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl_prev[2] == 1'b0) && (data_prev[2] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl_prev[3] == 1'b0) && (data_prev[3] == ETH_SYMBOL_PREAMBLE))
            ) begin
                start_before_start = 1;
            end
            
            // A column containing an Error control character
            else if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[1] == 1'b1) && (data_prev[1] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[2] == 1'b1) && (data_prev[2] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[3] == 1'b1) && (data_prev[3] == ETH_SYMBOL_ERROR))
            ) begin
                error_before_start = 1;
            end
            
            // A column containing Data code groups
            else if(
                (ctrl_prev[0] == 1'b0) &&
                (ctrl_prev[1] == 1'b0) &&
                (ctrl_prev[2] == 1'b0) &&
                (ctrl_prev[3] == 1'b0)
            ) begin
                data_codegroup_before_start = 1;
            end
        end
        
        // UNH 46.2.6 A
        if((frame_in_progress) && (!header_in_progress) && (terminate_align_lane < 0)) begin
            idle_replace_terminate = 0;
            sequence_replace_terminate = 0;
            
            for(int i = 0; i < XGMII_DDR_SYMBOLSPERBEAT; i++) begin
                if(ctrl[i] == 1'b1) begin
                    if(data[i] == ETH_SYMBOL_SEQUENCE) begin
                        sequence_replace_terminate = 1;
                        frame_in_progress = 0;
                    end
                    
                    else if(data[i] == ETH_SYMBOL_IDLE) begin
                        idle_replace_terminate = 1;
                        frame_in_progress = 0;
                    end
                end
            end
        end
        
        // Do not check for header_in_progress as it is set to 1 by code before if() block above
        if((frame_in_progress) && (terminate_align_lane < 0)) begin
            start_replace_terminate = 0;
            
            for(int i = 0; i < XGMII_DDR_SYMBOLSPERBEAT; i++) begin
                if(ctrl[i] == 1'b1) begin
                    if(data[i] == ETH_SYMBOL_START) begin
                        
                        // Lane 0 to Lane 2, check for idle character after Start (originally idle after terminate)
                        if((i < 3) && (ctrl[i + 1] == 1'b1) && (data[i + 1] == ETH_SYMBOL_IDLE)) begin
                            start_replace_terminate = 1;
                            frame_in_progress = 0;
                        end
                        
                        // Lane 3, check for data character before Start (originally before terminate)
                        if((i == 3) && (ctrl[i - 1] == 1'b0)) begin
                            start_replace_terminate = 1;
                            frame_in_progress = 0;
                        end
                    end
                end
            end
        end
        
        // UNH 46.2.6 B
        if(
            ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_EFD)) ||
            ((ctrl_prev[1] == 1'b1) && (data_prev[1] == ETH_SYMBOL_EFD)) ||
            ((ctrl_prev[2] == 1'b1) && (data_prev[2] == ETH_SYMBOL_EFD)) ||
            ((ctrl_prev[3] == 1'b1) && (data_prev[3] == ETH_SYMBOL_EFD))
        ) begin
            
            // Replace with /S/D/D/D/
            if(
                ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_START)) &&
                ((ctrl[1] == 1'b0) && (data[1] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl[2] == 1'b0) && (data[2] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl[3] == 1'b0) && (data[3] == ETH_SYMBOL_PREAMBLE))
            ) begin
                start_after_terminate = 1;
            end
            
            // Replace with /D/D/D/D/
            if(
                (ctrl[0] == 1'b0) &&
                (ctrl[1] == 1'b0) &&
                (ctrl[2] == 1'b0) &&
                (ctrl[3] == 1'b0)
            ) begin
                data_codegroup_after_terminate = 1;
            end
            
            // Replace with /E/E/E/E/
            if(
                ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_ERROR)) &&
                ((ctrl[1] == 1'b1) && (data[1] == ETH_SYMBOL_ERROR)) &&
                ((ctrl[2] == 1'b1) && (data[2] == ETH_SYMBOL_ERROR)) &&
                ((ctrl[3] == 1'b1) && (data[3] == ETH_SYMBOL_ERROR))
            ) begin
                error_after_terminate = 1;
            end
            
            // Replace with /T/I/I/I/
            if(
                ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_EFD)) &&
                ((ctrl[1] == 1'b1) && (data[1] == ETH_SYMBOL_IDLE)) &&
                ((ctrl[2] == 1'b1) && (data[2] == ETH_SYMBOL_IDLE)) &&
                ((ctrl[3] == 1'b1) && (data[3] == ETH_SYMBOL_IDLE))
            ) begin
                terminate_after_terminate = 1;
            end
        end
        
        // UNH 46.2.7
        if((frame_in_progress)) begin
            error_replace_sfd = 0;
            error_replace_terminate = 0;
            error_replace_data = 0;
            
            // /E/ replacing SFD
            if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_START)) &&
                ((ctrl_prev[1] == 1'b0) && (data_prev[1] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl_prev[2] == 1'b0) && (data_prev[2] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl_prev[3] == 1'b0) && (data_prev[3] == ETH_SYMBOL_PREAMBLE))
                &&
                ((ctrl[0] == 1'b0) && (data[0] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl[1] == 1'b0) && (data[1] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl[2] == 1'b0) && (data[2] == ETH_SYMBOL_PREAMBLE)) &&
                ((ctrl[3] == 1'b0) && (data[3] == ETH_SYMBOL_SFD))
            ) begin
                error_replace_sfd = 1;
            end
            
            // /E/ replacing /T/
            if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[1] == 1'b1) && (data_prev[1] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[2] == 1'b1) && (data_prev[2] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[3] == 1'b1) && (data_prev[3] == ETH_SYMBOL_ERROR))
                &&
                ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_IDLE)) &&
                ((ctrl[1] == 1'b1) && (data[1] == ETH_SYMBOL_IDLE)) &&
                ((ctrl[2] == 1'b1) && (data[2] == ETH_SYMBOL_IDLE)) &&
                ((ctrl[3] == 1'b1) && (data[3] == ETH_SYMBOL_IDLE))
            ) begin
                error_replace_terminate = 1;
            end
            
            // /E/ after SFD, replacing one octet of an otherwise valid frame
            if(
                ((ctrl_prev[0] == 1'b1) && (data_prev[0] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[1] == 1'b1) && (data_prev[1] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[2] == 1'b1) && (data_prev[2] == ETH_SYMBOL_ERROR)) ||
                ((ctrl_prev[3] == 1'b1) && (data_prev[3] == ETH_SYMBOL_ERROR))
                &&
                !(
                    ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_IDLE)) &&
                    ((ctrl[1] == 1'b1) && (data[1] == ETH_SYMBOL_IDLE)) &&
                    ((ctrl[2] == 1'b1) && (data[2] == ETH_SYMBOL_IDLE)) &&
                    ((ctrl[3] == 1'b1) && (data[3] == ETH_SYMBOL_IDLE))
                )
            ) begin
                error_replace_data = 1;
            end
            
        end
        
        // UNH 46.3
        if(
            ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_SEQUENCE)) &&
            ((ctrl[1] == 1'b0) && (data[1] == 8'h00)) &&
            ((ctrl[2] == 1'b0) && (data[2] == 8'h00)) &&
            ((ctrl[3] == 1'b0) && (data[3] == 8'h01))
        ) begin
            if(remote_fault_count > 0) begin
                remote_fault_count_prev = remote_fault_count;
            end
            
            local_fault_count++;
            remote_fault_count = 0;
            reserved_sequence_count = 0;
            idle_column_count = 0;
            
            local_fault_count_no_clear++;
            
            reserved_sequence_count_prev = reserved_sequence_count;
        end
        
        else if(
            ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_SEQUENCE)) &&
            ((ctrl[1] == 1'b0) && (data[1] == 8'h00)) &&
            ((ctrl[2] == 1'b0) && (data[2] == 8'h00)) &&
            ((ctrl[3] == 1'b0) && (data[3] == 8'h02))
        ) begin
            if(local_fault_count > 0) begin
                local_fault_count_prev = local_fault_count;
            end
            
            remote_fault_count++;
            local_fault_count = 0;
            reserved_sequence_count = 0;
            idle_column_count = 0;
            
            remote_fault_count_no_clear++;
            
            reserved_sequence_count_prev = reserved_sequence_count;
        end
        
        else if(
            ((ctrl[0] == 1'b1) && (data[0] == ETH_SYMBOL_SEQUENCE)) &&
            ((ctrl[1] == 1'b0) && (data[1] == 8'h00)) &&
            ((ctrl[2] == 1'b0) && (data[2] == 8'h00)) &&
            ((ctrl[3] == 1'b0) && ((data[3] != 8'h01) && (data[3] != 8'h02)))
        ) begin
            reserved_sequence_count++;
            reserved_sequence_idle_column_count = 0;
            idle_column_count++;
            
            local_fault_count_prev = local_fault_count;
            remote_fault_count_prev = remote_fault_count;
        end
        
        else begin
            idle_column_count++;
            reserved_sequence_idle_column_count++;
        end
        
        if(idle_column_count >= 128) begin
            local_fault_count = 0;
            local_fault_count_prev = 0;
            remote_fault_count = 0;
            remote_fault_count_prev = 0;
        end
        
        if(reserved_sequence_idle_column_count >= 128) begin
            reserved_sequence_count = 0;
        end
        
        // Prevent overflow of int data type
        if(idle_column_count >= 65535) begin
            idle_column_count = 65535;
        end
        
        if(reserved_sequence_idle_column_count >= 65535) begin
            reserved_sequence_idle_column_count = 65535;
        end
        
        // UNH 46.3.3
        if((local_fault_count_prev == 3) && (remote_fault_count > 0)) begin
            lf_3__rf_n__lf_1__count = remote_fault_count;
        end
        if((lf_3__rf_n__lf_1__count > 0) && (remote_fault_count_prev > 0)) begin
            lf_3__rf_n__lf_1__valid = 1;
        end
        
        if((remote_fault_count_prev == 3) && (local_fault_count > 0)) begin
            rf_3__lf_n__rf_1__count = local_fault_count;
        end
        if((rf_3__lf_n__rf_1__count > 0) && (local_fault_count_prev > 0)) begin
            rf_3__lf_n__rf_1__valid = 1;
        end
        
        if((local_fault_count_prev == 3) && (reserved_sequence_count > 0)) begin
            lf_3__rsvf_n__lf_1__count = reserved_sequence_count;
        end
        if((local_fault_count_prev == 3) && (local_fault_count == 4)) begin
            lf_3__rsvf_n__lf_1__valid = 1;
        end
        
        if((remote_fault_count_prev == 3) && (reserved_sequence_count > 0)) begin
            rf_3__rsvf_n__rf_1__count = reserved_sequence_count;
        end
        if((remote_fault_count_prev == 3) && (remote_fault_count == 4)) begin
            rf_3__rsvf_n__rf_1__valid = 1;
        end
        
        if((local_fault_count_prev == 1) && (remote_fault_count == 1)) begin
            lf_1__rf_1__4_times_count++;
        end
        if((remote_fault_count_prev == 1) && (local_fault_count == 1)) begin
            rf_1__lf_1__3_times_count++;
        end
        if((local_fault_count > 1) || (remote_fault_count > 1) || (idle_column_count >= 128)) begin
            lf_1__rf_1__4_times_count = 0;
            rf_1__lf_1__3_times_count = 0;
        end
        
        if((local_fault_count == local_fault_count_prev) && (reserved_sequence_count == reserved_sequence_count_prev + 1)) begin
            lf_1__rsvf_1__4_times_count++;
        end
        if((local_fault_count == local_fault_count_prev + 1) && (reserved_sequence_count == reserved_sequence_count_prev)) begin
            rsvf_1__lf_1__3_times_count++;
        end
        if((idle_column_count >= 128)) begin
            lf_1__rsvf_1__4_times_count = 0;
            rsvf_1__lf_1__3_times_count = 0;
        end
        
        if((remote_fault_count == remote_fault_count_prev) && (reserved_sequence_count == reserved_sequence_count_prev + 1)) begin
            rf_1__rsvf_1__4_times_count++;
        end
        if((remote_fault_count == remote_fault_count_prev + 1) && (reserved_sequence_count == reserved_sequence_count_prev)) begin
            rsvf_1__rf_1__3_times_count++;
        end
        if((idle_column_count >= 128)) begin
            rf_1__rsvf_1__4_times_count = 0;
            rsvf_1__rf_1__3_times_count = 0;
        end
        
        // Sample
       // this.cg_xgmii_ddr.sample();
        
        // UNH 46.3.4
        if(clear_counter < 8) begin
            if((local_fault_count_no_clear == local_fault_count_no_clear_prev + 1) && (local_fault_count_no_clear == 4)) begin
                local_fault_count_no_clear = 0;
                local_fault_count_no_clear_prev = 0;
                clear_counter++;
            end
            
            if((remote_fault_count_no_clear == remote_fault_count_no_clear_prev + 1) && (remote_fault_count_no_clear == 4)) begin
                remote_fault_count_no_clear = 0;
                remote_fault_count_no_clear_prev = 0;
                clear_counter++;
            end
        end
        if(clear_counter >= 8) begin
            if((local_fault_count_no_clear == local_fault_count_no_clear_prev + 1) && (local_fault_count_no_clear == 6)) begin
                local_fault_count_no_clear = 0;
                local_fault_count_no_clear_prev = 0;
                clear_counter++;
            end
            
            if((remote_fault_count_no_clear == remote_fault_count_no_clear_prev + 1) && (remote_fault_count_no_clear == 6)) begin
                remote_fault_count_no_clear = 0;
                remote_fault_count_no_clear_prev = 0;
                clear_counter++;
            end
        end
        
        // store previous transaction
        ctrl_prev = ctrl;
        data_prev = data;
        
        idle_column_count_prev = idle_column_count;
        reserved_sequence_idle_column_count_prev = reserved_sequence_idle_column_count;
        
        local_fault_count_no_clear_prev = local_fault_count_no_clear;
        remote_fault_count_no_clear_prev = remote_fault_count_no_clear;
        
        // UNH 46.3.3
        if(lf_3__rf_n__lf_1__valid) begin
            lf_3__rf_n__lf_1__valid = 0;
        end
        
        if(rf_3__lf_n__rf_1__valid) begin
            rf_3__lf_n__rf_1__valid = 0;
        end
        
        if(lf_3__rsvf_n__lf_1__valid) begin
            lf_3__rsvf_n__lf_1__valid = 0;
        end
        
        if(rf_3__rsvf_n__rf_1__valid) begin
            rf_3__rsvf_n__rf_1__valid = 0;
        end
        
    endfunction
    
endclass

`endif
