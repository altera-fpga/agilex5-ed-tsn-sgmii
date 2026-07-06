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


`timescale 1 ps / 1 ps
module alt_em10g32_stat_mem (

        //Common clock and Reset
        clk,
        csr_reset_n,
        
        //CSR Interface
        csr_read,
        csr_address,
        csr_readdata,
        csr_write,
        csr_writedata,
        
        //Av-ST Data Sink
        stat_sink_valid,
        stat_sink_data,
        stat_sink_error,
        
        // ECC Status
        mem_stat_update_ecc_err_corrected,
        mem_stat_update_ecc_err_fatal,
        mem_stat_csr_ecc_err_corrected,
        mem_stat_csr_ecc_err_fatal,
        
        // Parameters
        enable_pfc
    );
    
    // Global parameters
    parameter DEVICE_FAMILY                 = "Stratix V";
    parameter ENABLE_MEM_ECC                = 0;
    parameter SYNC_RESET_N                  = 1;
    
    // =head1 LOCAL PARAMETERS
 
    // =head2 Avalon Streaming
    localparam STATUS_WIDTH                 = 40;   // Streaming Number of symbols per word
    localparam ERROR_WIDTH                  = 7;

    // =head2 Avalon MM
    localparam CSR_DATAPATH_WIDTH           = 32;
    localparam CSR_ADDRESS_WIDTH            = 6;    // 64 addresses
   
    // =head2 Others (size of statistic registers)
    localparam OCTET_REG_WIDTH              = 64;
    localparam REG_WIDTH                    = 36;
    
    // Explicit Memory Blocks
    localparam USE_MEMORY_BLOCKS            = 1;
   
    // =head2 Clock Interface
    input                                                 clk;
    input                                                 csr_reset_n;
   
    // =head2 Avalon MM Slave CSR Interface
    input                                                 csr_read;
    input                                                 csr_write;
    input       [(CSR_ADDRESS_WIDTH)-1:0]                 csr_address;
    output      [(CSR_DATAPATH_WIDTH)-1:0]	csr_readdata;
    input       [(CSR_DATAPATH_WIDTH)-1:0]	csr_writedata;
    
    
    // =head2 Avalon ST DataIn (Sink) Interface
    input                                                 stat_sink_valid;
    input       [(STATUS_WIDTH)-1:0]                      stat_sink_data;
    input       [(ERROR_WIDTH)-1:0]                       stat_sink_error;
    
    // ECC Status
    output  reg                                           mem_stat_update_ecc_err_corrected;
    output  reg                                           mem_stat_update_ecc_err_fatal;
    output  reg                                           mem_stat_csr_ecc_err_corrected;
    output  reg                                           mem_stat_csr_ecc_err_fatal;
    
    // Parameters
    input                                                 enable_pfc;

   
    // For debugging purpose: to change reset value for statistic registers to other value than 0    
    localparam REG_RESET_VALUE = {REG_WIDTH{1'b0}};
    localparam OCTET_REG_RESET_VALUE = {OCTET_REG_WIDTH{1'b0}}; 

    
    // ----------------------------------------------------------------------------
    // Local registers and wire declarations
    // ----------------------------------------------------------------------------
	
    // Statistics Registers (wraparound counters)	        
    reg [(REG_WIDTH-1):0]   etherStatsPkts;   
    reg [15:0]              etherStatsPkts_lsb;   
    reg                     etherStatsPkts_carry;   
    reg [(REG_WIDTH-1):0]   ifErrors;    
    reg [15:0]              ifErrors_lsb;    
    reg                     ifErrors_lsb_carry;    

    
    
    reg [(OCTET_REG_WIDTH-1):0] octetsOK;
    reg [27:0]                  octetsOK_lsb;
    reg                         octetsOK_lsb_carry;
    reg [(OCTET_REG_WIDTH-1):0] etherStatsOctets;
    reg [27:0]                  etherStatsOctets_lsb;
    reg                         etherStatsOctets_lsb_carry;

    // Soft reset
    reg sw_reset;

    // Shadow register
    reg [31:0] msb_reg;

    // Wires
    wire crc_error_w;
    wire error;
    wire valid;
    reg  err_reg;
    reg  valid_reg;
    reg  [7:0]                  reg_stat_data;
    reg  [(ERROR_WIDTH)-1:0]    reg_stat_err;
    reg  [1:0]                  undersizeframe_cnt;

    // Avalon-ST data sink
    wire [15:0] payload_length;
    wire [15:0] pkt_length;
    wire svlan_pkt;
    wire vlan_pkt;
    wire control_frame;
    wire pause_pkt;
    wire pfc_pkt;
    wire broadcast_pkt;
    wire multicast_pkt;
    wire unicast_pkt;

    wire phy_err;
    wire crc_err;
    wire user_err;
    wire underflow_err;
    wire undersize_frame_err;
    wire oversize_frame_err;
    wire payload_length_err; 
    wire initial_undersize_frame_err;
    wire initial_oversize_frame_err;
    reg  [2:0] tmp_cnt;
    reg  [2:0] tmp_cnt_p1;
    wire [2:0] tmp_cnt_w;

    // Output registers 
    reg [(CSR_DATAPATH_WIDTH)-1:0]  csr_readdata;


    
    // Intrnal Registers
    reg [(CSR_ADDRESS_WIDTH)-1:0]   csr_address_reg;
    reg                             csr_read_reg;


    // Internal Wires
    reg [(REG_WIDTH)-1:0]           host_data;
    wire [(REG_WIDTH)-1:0]          host_data_w;
    
    
    // TYPE stm_type:
    localparam STM_TYPE_IDLE         = 2'h 0;
    localparam STM_TYPE_INC_CNT      = 2'h 1;
    localparam STM_TYPE_RST_CNT      = 2'h 2;
    localparam STM_TYPE_RST_DONE     = 2'h 3;
    
    reg     [1:0] nextstate; 
    reg     [1:0] state; 

    reg     [2:0] reg_cnt; 
    reg     [4:0] rst_cnt;
    reg     [4:0] cnt_rdaddr;
    reg     [4:0] cnt_waddr;
    reg     [4:0] cnt_waddr_p1;
    reg     [4:0] cnt_waddr_p2;
    reg     cnt_inc;
    //reg     cnt_inc_reg;
    reg     cnt_wren;
	reg		cnt_wren_reg;
	reg		cnt_wren_reg_p1;
	reg		cnt_wren_reg_p2;
    
    reg     sw_reset_done_reg;   
    
    reg     [(REG_WIDTH)-1:0] cnt_out;
    wire    [(REG_WIDTH)-1:0] stat_cnt;
    reg     [(REG_WIDTH)-1:0] stat_cnt_p1;
    
    reg     [4:0] cnt_rdaddr_wire;
    reg     [(REG_WIDTH)-1:0] cnt_out_reg;
    wire    [(REG_WIDTH)-1:0] cnt_out_w;
    
    wire    [1:0] mem_stat_update_eccstatus;
    wire    [1:0] mem_stat_csr_eccstatus;

    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Av-ST data sink interface mapping
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            reg_stat_data <= {8{1'b0}};
            reg_stat_err <= {ERROR_WIDTH{1'b0}};
        end else begin
            if (stat_sink_valid) begin
                reg_stat_data <= (enable_pfc) ? stat_sink_data[39:32] : {1'b0,stat_sink_data[38:32]};
                reg_stat_err <= stat_sink_error;
            end
        end
    end
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            reg_stat_data <= {8{1'b0}};
            reg_stat_err <= {ERROR_WIDTH{1'b0}};
        end else begin
            if (stat_sink_valid) begin
                reg_stat_data <= (enable_pfc) ? stat_sink_data[39:32] : {1'b0,stat_sink_data[38:32]};
                reg_stat_err <= stat_sink_error;
            end
        end
    end
    end
    endgenerate

    assign payload_length = stat_sink_data[15:0];
    assign pkt_length = stat_sink_data[31:16];
    
    // assign svlan_pkt = reg_stat_data[0];
    // assign vlan_pkt = reg_stat_data[1];
    assign control_frame = reg_stat_data[2];
    assign pause_pkt = reg_stat_data[3];
    assign pfc_pkt = reg_stat_data[7];
    assign broadcast_pkt = reg_stat_data[4];
    assign multicast_pkt = reg_stat_data[5];
    assign unicast_pkt = reg_stat_data[6];

    assign initial_undersize_frame_err = stat_sink_error[0];
    assign initial_oversize_frame_err = stat_sink_error[1];
    
    assign undersize_frame_err = reg_stat_err[0];
    assign oversize_frame_err = reg_stat_err[1];
    // assign payload_length_err = reg_stat_err[2];
    assign crc_error_w = stat_sink_error[3];
    assign crc_err = reg_stat_err[3];
    // assign underflow_err = reg_stat_err[4];
    // assign user_err = reg_stat_err[5];
    // assign phy_err = reg_stat_err[6];

    // It takes 8 clock cycles to update all statistics counters and a minimum of 2 clock cycles update a single group of registers
    // => at least 4 undersizeframe could be received in 8 clock cycles.
    // => undersizeframe_cnt is a 2 bits register and is only expected to hold up to value of 3. The fourth undersizeframe is counted by cnt_inc_reg 
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            undersizeframe_cnt <= 2'b0;
        end 
        else begin
            if ((state !=  STM_TYPE_IDLE) && stat_sink_error[0] && stat_sink_valid) begin
                undersizeframe_cnt <= undersizeframe_cnt + 1'b1;
            end
            else begin
                if (cnt_waddr_p1 == 5'h0F) begin
                    undersizeframe_cnt <= 2'b0;
                end
            end
        end
    end
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            undersizeframe_cnt <= 2'b0;
        end 
        else begin
            if ((state !=  STM_TYPE_IDLE) && stat_sink_error[0] && stat_sink_valid) begin
                undersizeframe_cnt <= undersizeframe_cnt + 1'b1;
            end
            else begin
                if (cnt_waddr_p1 == 5'h0F) begin
                    undersizeframe_cnt <= 2'b0;
                end
            end
        end
    end
    end
    endgenerate

    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Error detector
    // ---------------------------------------------------------------------------
    // ##########################################################################################
    assign error = |stat_sink_error;
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            err_reg <= {1'b0};
        end else begin
            if (stat_sink_valid) begin
                err_reg <= error;
            end
        end
    end    
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            err_reg <= {1'b0};
        end else begin
            if (stat_sink_valid) begin
                err_reg <= error;
            end
        end
    end 
    end
    endgenerate

    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Valid packet detector
    // ---------------------------------------------------------------------------
    // ##########################################################################################
    assign valid = (enable_pfc) ? |stat_sink_data[39:34] : |stat_sink_data[38:34]; 
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            valid_reg <= {1'b0};
        end else begin
            if (stat_sink_valid) begin
                valid_reg <= valid;
            end
        end
    end   
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            valid_reg <= {1'b0};
        end else begin
            if (stat_sink_valid) begin
                valid_reg <= valid;
            end
        end
    end 
    end
    endgenerate

    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Packet Length detector
    // ---------------------------------------------------------------------------
    // ##########################################################################################
    reg     [2:0]  length_enc;
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            length_enc <= {3{1'b0}};
        end else begin
            if (stat_sink_valid) begin
                if (pkt_length < 64)
                    length_enc <= 3'h0;
                else if (pkt_length == 64)
                    length_enc <= 3'h1;
                else if (pkt_length > 64 & pkt_length < 128 )
                    length_enc <= 3'h2;
                else if (pkt_length > 127 & pkt_length < 256 )
                    length_enc <= 3'h3;
                else if (pkt_length > 255 & pkt_length < 512 )
                    length_enc <= 3'h4;
                else if (pkt_length > 511 & pkt_length < 1024 )
                    length_enc <= 3'h5;
                else if (pkt_length > 1023 & pkt_length < 1519 )
                    length_enc <= 3'h6;
                else
                    length_enc <= 3'h7;
            end
        end
    end     
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            length_enc <= {3{1'b0}};
        end else begin
            if (stat_sink_valid) begin
                if (pkt_length < 64)
                    length_enc <= 3'h0;
                else if (pkt_length == 64)
                    length_enc <= 3'h1;
                else if (pkt_length > 64 & pkt_length < 128 )
                    length_enc <= 3'h2;
                else if (pkt_length > 127 & pkt_length < 256 )
                    length_enc <= 3'h3;
                else if (pkt_length > 255 & pkt_length < 512 )
                    length_enc <= 3'h4;
                else if (pkt_length > 511 & pkt_length < 1024 )
                    length_enc <= 3'h5;
                else if (pkt_length > 1023 & pkt_length < 1519 )
                    length_enc <= 3'h6;
                else
                    length_enc <= 3'h7;
            end
        end
    end 
    end
    endgenerate
    
    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // CSR Interface and Register Space
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Control register and status register
    // This block handles the write transaction from the Avalon-MM csr interface.
    // Setting '1' to sw_reset (soft reset) will reset all statistic registers.
    // Soft reset will be self-cleared.
    // ---------------------------------------------------------------------------
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            sw_reset <= 1'b1; 
        end
        else begin
            if (csr_write == 1'b1 && csr_address == 1'b0) begin
                sw_reset <= sw_reset ? 1'b1 : csr_writedata[0];
            end else if (nextstate == STM_TYPE_RST_DONE) begin
                sw_reset <= 1'b0;
            end
        end
    end 
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            sw_reset <= 1'b1; 
        end
        else begin
            if (csr_write == 1'b1 && csr_address == 1'b0) begin
                sw_reset <= sw_reset ? 1'b1 : csr_writedata[0];
            end else if (nextstate == STM_TYPE_RST_DONE) begin
                sw_reset <= 1'b0;
            end
        end
    end 
    end
    endgenerate   

    // ---------------------------------------------------------------------------
    // Control register and status register
    // This block handles the read transaction from the Avalon-MM csr interface. 
    // A read transaction to address '0' will read the value of soft reset
    // Address '1' is reserved
    // A read transaction to a statistic register will clear the particular register
    // - A read transaction to a valid even address (other than 0) will read from the 32 lower-bits of the associated register. 
    //   The higher-bits of the register will be written to the shadow register.
    //   The shadow register will always be overwritten by the next read transaction to any valid even address. 
    // - A read transaction to a valid odd address will read from the shadow register.
    // ---------------------------------------------------------------------------
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (!csr_reset_n) begin
            csr_read_reg <= 1'b0;
            csr_address_reg <= {CSR_ADDRESS_WIDTH{1'b0}};
        end else begin
            csr_read_reg <= csr_read;
            csr_address_reg <= csr_address;
        end
    end


    always @(posedge clk) begin
        if (!csr_reset_n) begin
            csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
            msb_reg <= 32'b0;
		end else begin
            if (csr_read_reg == 1'b1) begin
                if (csr_address_reg[0] == 1'b0) begin
                    case (csr_address_reg[(CSR_ADDRESS_WIDTH-1):1])
                        5'h0: begin
                                csr_readdata <= {{31{1'b0}}, sw_reset};
                                msb_reg <= {32{1'b0}};
                              end

                        5'h04: begin
                                csr_readdata <= octetsOK[31:0];
                                msb_reg <= octetsOK[63:32];
                              end

                        5'h06: begin
                                csr_readdata <= ifErrors[31:0];
                                msb_reg <= {28'b0, ifErrors[35:32]};
                              end

                        5'h0D: begin
                                csr_readdata <= etherStatsOctets[31:0];
                                msb_reg <= etherStatsOctets[63:32];
                               end

                        5'h0E: begin
                                csr_readdata <= etherStatsPkts[31:0];
                                msb_reg <= {28'b0,etherStatsPkts[35:32]};
                               end

                        default: begin 
                                    csr_readdata <= host_data[31:0];
                                    msb_reg <= {28'b0,host_data[35:32]};
                                end
                    endcase                  
                end else begin
                    csr_readdata <= msb_reg;
                end
            end else begin
                csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
            end
        end	     
    end
    end else begin
    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            csr_read_reg <= 1'b0;
            csr_address_reg <= {CSR_ADDRESS_WIDTH{1'b0}};
        end else begin
            csr_read_reg <= csr_read;
            csr_address_reg <= csr_address;
        end
    end


    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
            msb_reg <= 32'b0;
		end else begin
            if (csr_read_reg == 1'b1) begin
                if (csr_address_reg[0] == 1'b0) begin
                    case (csr_address_reg[(CSR_ADDRESS_WIDTH-1):1])
                        5'h0: begin
                                csr_readdata <= {{31{1'b0}}, sw_reset};
                                msb_reg <= {32{1'b0}};
                              end

                        5'h04: begin
                                csr_readdata <= octetsOK[31:0];
                                msb_reg <= octetsOK[63:32];
                              end

                        5'h06: begin
                                csr_readdata <= ifErrors[31:0];
                                msb_reg <= {28'b0, ifErrors[35:32]};
                              end

                        5'h0D: begin
                                csr_readdata <= etherStatsOctets[31:0];
                                msb_reg <= etherStatsOctets[63:32];
                               end

                        5'h0E: begin
                                csr_readdata <= etherStatsPkts[31:0];
                                msb_reg <= {28'b0,etherStatsPkts[35:32]};
                               end

                        default: begin 
                                    csr_readdata <= host_data[31:0];
                                    msb_reg <= {28'b0,host_data[35:32]};
                                end
                    endcase                  
                end else begin
                    csr_readdata <= msb_reg;
                end
            end else begin
                csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};
            end
        end	     
    end
    end
    endgenerate
    
    
    //  Statistic Array Control
    //  -----------------------
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
        if (csr_reset_n == 1'b 0)
            begin
            state <= STM_TYPE_IDLE;    
            end
        else
            begin
            state <= nextstate;   
            end
    end
    end else begin
    always @(negedge csr_reset_n or posedge clk) begin
        if (csr_reset_n == 1'b 0)
            begin
            state <= STM_TYPE_IDLE;    
            end
        else
            begin
            state <= nextstate;   
            end
    end
    end
    endgenerate

    
    always @(state or stat_sink_valid or reg_cnt or sw_reset or sw_reset_done_reg) begin
        case (state)   
            STM_TYPE_IDLE: begin
                if (sw_reset == 1'b 1)
                    begin
                    nextstate = STM_TYPE_RST_CNT;  
                    end
                else if (stat_sink_valid == 1'b 1 )
                    begin
                    nextstate = STM_TYPE_INC_CNT;   
                    end
                else
                    begin
                    nextstate = STM_TYPE_IDLE; 
                    end
                end
                
            STM_TYPE_INC_CNT: begin
                if (reg_cnt == 3'd 7)
                    begin
                    nextstate = STM_TYPE_IDLE; 
                    end
                else
                    begin
                    nextstate = STM_TYPE_INC_CNT;  
                    end
            end

            STM_TYPE_RST_CNT: begin
                if (sw_reset_done_reg == 1'b1)
                    begin
                    nextstate = STM_TYPE_RST_DONE; 
                    end
                else
                    begin
                    nextstate = STM_TYPE_RST_CNT;  
                    end
            end
                
            STM_TYPE_RST_DONE: begin
                if (sw_reset == 1'b 0)
                    begin
                    nextstate = STM_TYPE_IDLE; 
                    end
                else
                    begin
                    nextstate = STM_TYPE_RST_DONE; 
                    end
            end
            
            default: begin
                nextstate = STM_TYPE_IDLE; 
            end    
        endcase      
    end    
    
    
    //  Read Counter
    //  -------------
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            reg_cnt <= 3'd 0; 
            end
        else
            begin
            if (nextstate == STM_TYPE_IDLE)
                begin
                reg_cnt <= 3'd 0;  
                end
            else if (nextstate == STM_TYPE_INC_CNT)
                begin
                    if ((state == STM_TYPE_IDLE) && (initial_undersize_frame_err)) begin
                        reg_cnt <= 3'd 7; 
                    end
                    else begin
                        reg_cnt <= reg_cnt + 3'd 1; 
                    end              
                end
            end
        end
    end else begin
    always @(negedge csr_reset_n or posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            reg_cnt <= 3'd 0; 
            end
        else
            begin
            if (nextstate == STM_TYPE_IDLE)
                begin
                reg_cnt <= 3'd 0;  
                end
            else if (nextstate == STM_TYPE_INC_CNT)
                begin
                    if ((state == STM_TYPE_IDLE) && (initial_undersize_frame_err)) begin
                        reg_cnt <= 3'd 7; 
                    end
                    else begin
                        reg_cnt <= reg_cnt + 3'd 1; 
                    end              
                end
            end
        end
    end
    endgenerate   


    //  Reset Counter
    //  --------------
    generate if (SYNC_RESET_N == 1) begin
    always @( posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            rst_cnt <= {5{1'b0}}; 
            end
        else
            begin
            if (state == STM_TYPE_RST_CNT)
                begin
                rst_cnt <= rst_cnt + 5'd 1;    
                end
            else if (state == STM_TYPE_IDLE )
                begin
                rst_cnt <= 5'd 0;  
                end
            end
        end      



    always @(posedge clk) begin
        if (!csr_reset_n) begin
            sw_reset_done_reg <= 1'b0;
        end else begin
            if (rst_cnt == 5'd 30) begin
                sw_reset_done_reg <= 1'b1;
            end else begin
                sw_reset_done_reg <= 1'b0;
            end
        end
    end
    end else begin
    always @(negedge csr_reset_n or posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            rst_cnt <= {5{1'b0}}; 
            end
        else
            begin
            if (state == STM_TYPE_RST_CNT)
                begin
                rst_cnt <= rst_cnt + 5'd 1;    
                end
            else if (state == STM_TYPE_IDLE )
                begin
                rst_cnt <= 5'd 0;  
                end
            end
        end      



    always @(posedge clk or negedge csr_reset_n) begin
        if (!csr_reset_n) begin
            sw_reset_done_reg <= 1'b0;
        end else begin
            if (rst_cnt == 5'd 30) begin
                sw_reset_done_reg <= 1'b1;
            end else begin
                sw_reset_done_reg <= 1'b0;
            end
        end
    end
    end
    endgenerate
        
    //  Counter Read
    //  ------------
    always @(*)
        begin

            case (reg_cnt)
                               
                3'd 1:
                // framesCRCErr
                begin
                cnt_rdaddr_wire = 5'h 03; 
                end
                
                3'd 2:
                begin
                if(pfc_pkt)
                    begin
                    //pfcMACCtrlFrames
                    cnt_rdaddr_wire = 5'h 1E;
                    end
                else
                    begin
                    //pauseMACCtrlFrames
                    cnt_rdaddr_wire = 5'h 05;
                    end
                end

                3'd 3:
                begin
                case(length_enc)
                3'h 1:cnt_rdaddr_wire = 5'h 11;
                3'h 2:cnt_rdaddr_wire = 5'h 12;
                3'h 3:cnt_rdaddr_wire = 5'h 13; 
                3'h 4:cnt_rdaddr_wire = 5'h 14; 
                3'h 5:cnt_rdaddr_wire = 5'h 15; 
                3'h 6:cnt_rdaddr_wire = 5'h 16; 
                3'h 7:cnt_rdaddr_wire = 5'h 17; 
                default: cnt_rdaddr_wire = 5'h 00;                    
                endcase
                end                    
                
                3'd 4:
                begin
                case({unicast_pkt,multicast_pkt,broadcast_pkt})
                // unicastMACCtrlFrames
                3'b100:cnt_rdaddr_wire = 5'h 1B;
                // multicastMACCtrlFrames
                3'b010:cnt_rdaddr_wire = 5'h 1C;
                // broadcastMACCtrlFrames
                3'b001:cnt_rdaddr_wire = 5'h 1D;
                default:cnt_rdaddr_wire = 5'h 00;
                endcase
                end
                
                3'd 5:
                begin
                // framesOK
                if (!err_reg)
                    begin
                    cnt_rdaddr_wire = 5'h 01;  
                    end
                // framesErr
                else
                    begin
                    cnt_rdaddr_wire = 5'h 02;  
                    end
                end                    
                
                3'd 6:
                begin
                case({err_reg,unicast_pkt,multicast_pkt,broadcast_pkt})
                4'b0100:cnt_rdaddr_wire = 5'h 07; 
                4'b1100:cnt_rdaddr_wire = 5'h 08;
                4'b0010:cnt_rdaddr_wire = 5'h 09;
                4'b1010:cnt_rdaddr_wire = 5'h 0A;
                4'b0001:cnt_rdaddr_wire = 5'h 0B;
                4'b1001:cnt_rdaddr_wire = 5'h 0C;
                default:cnt_rdaddr_wire = 5'h 00;
                endcase                        
                end

                3'd 0:
                begin
                 // etherStatsUnderSizedPkts
                if (initial_undersize_frame_err)
                    begin
                    cnt_rdaddr_wire = 5'h 0F;  
                    end
                // etherStatsOverSizedPkts
                else if (initial_oversize_frame_err)
                    begin
                    cnt_rdaddr_wire = 5'h 10;  
                    end
                else
                    begin
                    cnt_rdaddr_wire = 5'h 00;  //  default to last address  
                    end
                end
                
                3'd 7:
                begin
                // etherStatsFragments
                if (undersize_frame_err)
                    begin
                    cnt_rdaddr_wire = 5'h 18; 
                    end
                // etherStatsJabbers
                else if (oversize_frame_err)
                    begin
                    cnt_rdaddr_wire = 5'h 19;  
                    end
                // etherStatsCRCErrors
                else
                    begin
                    cnt_rdaddr_wire = 5'h 1A; 
                    end
                end
                
                default:
                begin
                cnt_rdaddr_wire = 5'h 00; 
                end
                
            endcase

        end        

    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            cnt_rdaddr <= {5{1'b 0}};
            end
        else
            begin
            cnt_rdaddr <= cnt_rdaddr_wire;
            end
        end
    end else begin
    always @(negedge csr_reset_n or posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            cnt_rdaddr <= {5{1'b 0}};
            end
        else
            begin
            cnt_rdaddr <= cnt_rdaddr_wire;
            end
        end
    end
    endgenerate    
        
    //  Counter Increments
    //  ------------------
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            cnt_inc <= 1'b 0; 
            end
        else
            begin

                case (reg_cnt)
                                   
                    3'd 1:
                    // framesCRCErr
                    begin                    
                    cnt_inc <= ((!oversize_frame_err  & !undersize_frame_err) & (valid_reg & crc_err)); 
                    end
                    
                    3'd 2:
                    begin
                    if(pfc_pkt)
                        begin
                        //pfcMACCtrlFrames
                        cnt_inc <= (pfc_pkt & !err_reg);
                        end
                    else
                        begin
                        //pauseMACCtrlFrames
                        cnt_inc <= (pause_pkt & !err_reg);
                        end
                    end

                    3'd 3:
                    begin
                    if (length_enc != 3'h 0)
                        begin
                        cnt_inc <= 1'b1;  
                        end
                    else
                        begin
                        cnt_inc <= 1'b0; 
                        end
                    end                    
                    
                    3'd 4:
                    begin
                    cnt_inc <= (control_frame & !err_reg);
                    end
                    
                    3'd 5:
                    begin
                    cnt_inc <= valid_reg;  
                    end                    
                    
                    3'd 6:
                    begin
                    cnt_inc <= (!control_frame);  
                    end

                    3'd 0:
                    begin
                    cnt_inc <= (stat_sink_valid & !crc_error_w);
                    end
                    
                    3'd 7:
                    begin
                    cnt_inc <= crc_err; 
                    end
                    
                    default:
                    begin
                    cnt_inc <= 1'b0; 
                    end
                    
                endcase

            end
        end
    end else begin
    always @(negedge csr_reset_n or posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            cnt_inc <= 1'b 0; 
            end
        else
            begin

                case (reg_cnt)
                                   
                    3'd 1:
                    // framesCRCErr
                    begin                    
                    cnt_inc <= ((!oversize_frame_err  & !undersize_frame_err) & (valid_reg & crc_err)); 
                    end
                    
                    3'd 2:
                    begin
                    if(pfc_pkt)
                        begin
                        //pfcMACCtrlFrames
                        cnt_inc <= (pfc_pkt & !err_reg);
                        end
                    else
                        begin
                        //pauseMACCtrlFrames
                        cnt_inc <= (pause_pkt & !err_reg);
                        end
                    end

                    3'd 3:
                    begin
                    if (length_enc != 3'h 0)
                        begin
                        cnt_inc <= 1'b1;  
                        end
                    else
                        begin
                        cnt_inc <= 1'b0; 
                        end
                    end                    
                    
                    3'd 4:
                    begin
                    cnt_inc <= (control_frame & !err_reg);
                    end
                    
                    3'd 5:
                    begin
                    cnt_inc <= valid_reg;  
                    end                    
                    
                    3'd 6:
                    begin
                    cnt_inc <= (!control_frame);  
                    end

                    3'd 0:
                    begin
                    cnt_inc <= (stat_sink_valid & !crc_error_w);
                    end
                    
                    3'd 7:
                    begin
                    cnt_inc <= crc_err; 
                    end
                    
                    default:
                    begin
                    cnt_inc <= 1'b0; 
                    end
                    
                endcase

            end
        end
      end
      endgenerate      
        
      generate if (SYNC_RESET_N == 1) begin
	always @( posedge clk) begin
		if (csr_reset_n == 1'b 0) begin
			cnt_wren <= 1'b 0;
		end else begin
			if (state == STM_TYPE_IDLE && nextstate == STM_TYPE_IDLE) begin
				cnt_wren <= 1'b 0;
            end else if (state == STM_TYPE_RST_DONE || nextstate == STM_TYPE_RST_DONE) begin
                cnt_wren <= 1'b 0;
			end else begin
				cnt_wren <= 1'b 1;
			end
		end
	end

	
    always @(posedge clk) begin 
        if (csr_reset_n == 1'b 0) begin
            cnt_waddr <= {5{1'b 0}};  
            cnt_waddr_p1 <= {5{1'b0}};
            cnt_waddr_p2 <= {5{1'b0}};
            cnt_wren_reg <= 1'b 0;  
            cnt_wren_reg_p1 <= 1'b 0;
            cnt_wren_reg_p2 <= 1'b 0;
            //cnt_inc_reg <= 1'b 0;  
        end else begin            

			cnt_wren_reg <= cnt_wren;          
			cnt_wren_reg_p1 <= cnt_wren_reg;
			cnt_wren_reg_p2 <= cnt_wren_reg_p1;
            cnt_waddr_p1 <= cnt_waddr;
            cnt_waddr_p2 <= cnt_waddr_p1;

            if (state == STM_TYPE_RST_CNT || state == STM_TYPE_RST_DONE) begin
                cnt_waddr <= rst_cnt;
				//cnt_inc_reg <= 1'b 0;
            end else begin
                cnt_waddr <= cnt_rdaddr; 
                //cnt_inc_reg <= cnt_inc;				
            end

        end
    end
    end else begin
    always @(negedge csr_reset_n or posedge clk) begin
		if (csr_reset_n == 1'b 0) begin
			cnt_wren <= 1'b 0;
		end else begin
			if (state == STM_TYPE_IDLE && nextstate == STM_TYPE_IDLE) begin
				cnt_wren <= 1'b 0;
            end else if (state == STM_TYPE_RST_DONE || nextstate == STM_TYPE_RST_DONE) begin
                cnt_wren <= 1'b 0;
			end else begin
				cnt_wren <= 1'b 1;
			end
		end
	end

	
    always @(negedge csr_reset_n or posedge clk) begin 
        if (csr_reset_n == 1'b 0) begin
            cnt_waddr <= {5{1'b 0}};  
            cnt_waddr_p1 <= {5{1'b0}};
            cnt_waddr_p2 <= {5{1'b0}};
            cnt_wren_reg <= 1'b 0;  
            cnt_wren_reg_p1 <= 1'b 0;
            cnt_wren_reg_p2 <= 1'b 0;
            //cnt_inc_reg <= 1'b 0;  
        end else begin            

			cnt_wren_reg <= cnt_wren;          
			cnt_wren_reg_p1 <= cnt_wren_reg;
			cnt_wren_reg_p2 <= cnt_wren_reg_p1;
            cnt_waddr_p1 <= cnt_waddr;
            cnt_waddr_p2 <= cnt_waddr_p1;

            if (state == STM_TYPE_RST_CNT || state == STM_TYPE_RST_DONE) begin
                cnt_waddr <= rst_cnt;
				//cnt_inc_reg <= 1'b 0;
            end else begin
                cnt_waddr <= cnt_rdaddr; 
                //cnt_inc_reg <= cnt_inc;				
            end

        end
    end
    end
    endgenerate
  
    generate if (SYNC_RESET_N == 1) begin
    always @( posedge clk) 
        begin 
        if (csr_reset_n == 1'b 0) 
            begin
            tmp_cnt <= 3'b0;
            tmp_cnt_p1 <= 3'b0;
            end
        else
            begin
            if(state == STM_TYPE_RST_CNT || state == STM_TYPE_RST_DONE)
                begin
                tmp_cnt <=3'b0;
                end
            else
                begin
                if(cnt_rdaddr == 5'h0F)
                    begin
                    tmp_cnt <= cnt_inc + undersizeframe_cnt;
                    end
                else
                    begin
                    tmp_cnt <= cnt_inc;
                    end
                end    
            
            tmp_cnt_p1 <= tmp_cnt;
            
            end
        end    
    end else begin 
    always @(negedge csr_reset_n or posedge clk) 
        begin 
        if (csr_reset_n == 1'b 0) 
            begin
            tmp_cnt <= 3'b0;
            tmp_cnt_p1 <= 3'b0;
            end
        else
            begin
            if(state == STM_TYPE_RST_CNT || state == STM_TYPE_RST_DONE)
                begin
                tmp_cnt <=3'b0;
                end
            else
                begin
                if(cnt_rdaddr == 5'h0F)
                    begin
                    tmp_cnt <= cnt_inc + undersizeframe_cnt;
                    end
                else
                    begin
                    tmp_cnt <= cnt_inc;
                    end
                end    
            
            tmp_cnt_p1 <= tmp_cnt;
            
            end
        end  
    end 
    endgenerate    

    assign tmp_cnt_w = (USE_MEMORY_BLOCKS == 0) ? tmp_cnt :
                       (ENABLE_MEM_ECC == 0)    ? tmp_cnt :
                                                  tmp_cnt_p1;
    
    assign stat_cnt = (state != STM_TYPE_RST_CNT)? (cnt_out + tmp_cnt_w) : REG_RESET_VALUE[(REG_WIDTH)-1:0];
    
    generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            stat_cnt_p1 <= {36{1'b 0}};
            end
        else
            begin
            stat_cnt_p1 <= stat_cnt;
            end
        end
    end else begin
    always @(negedge csr_reset_n or posedge clk)
        begin
        if (csr_reset_n == 1'b 0)
            begin
            stat_cnt_p1 <= {36{1'b 0}};
            end
        else
            begin
            stat_cnt_p1 <= stat_cnt;
            end
        end
    end
    endgenerate
    
    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // MEMORY
    // - Memory blocks to store the statistics
    // ---------------------------------------------------------------------------
    // ###########################################################################################    
    
    reg     [(REG_WIDTH-1):0]       mem1 [31:0];
    reg     [(REG_WIDTH-1):0]       mem2 [31:0];
    
    wire    [(REG_WIDTH-1):0]       mem_wrdata;
    wire                            mem_wren;
    wire    [4:0]                   mem_wraddress;
    
    assign mem_wrdata    = (USE_MEMORY_BLOCKS == 0) ? stat_cnt_p1 :
                           (ENABLE_MEM_ECC == 0)    ? stat_cnt_p1 :
                                                      stat_cnt_p1;
    assign mem_wren      = (USE_MEMORY_BLOCKS == 0) ? cnt_wren_reg_p1 :
                           (ENABLE_MEM_ECC == 0)    ? cnt_wren_reg_p1 :
                                                      cnt_wren_reg_p2;
    assign mem_wraddress = (USE_MEMORY_BLOCKS == 0) ? cnt_waddr_p1 :
                           (ENABLE_MEM_ECC == 0)    ? cnt_waddr_p1 :
                                                      cnt_waddr_p2;
    
    generate if(USE_MEMORY_BLOCKS == 0) begin
        if (SYNC_RESET_N == 1) begin
	always @(posedge clk)
            begin
            if (csr_reset_n == 1'b 0)
                begin
                cnt_out <= {36{1'b 0}};
                end
            else
                begin
                cnt_out <= cnt_out_reg;
                end
            end
        end else begin
	always @(negedge csr_reset_n or posedge clk)
            begin
            if (csr_reset_n == 1'b 0)
                begin
                cnt_out <= {36{1'b 0}};
                end
            else
                begin
                cnt_out <= cnt_out_reg;
                end
            end
        end
        // Memory that is used for internal read
        always @ (posedge clk) begin
            if (mem_wren)
                mem1[mem_wraddress] <= mem_wrdata;
            cnt_out_reg <= mem1[cnt_rdaddr_wire];
        end
        
        // Memory that is used for CSR read
        always @ (posedge clk) begin
            if (mem_wren)
                mem2[mem_wraddress] <= mem_wrdata;
            host_data <= mem2[csr_address[5:1]];
        end
        
    end
    else begin
        
        // Memory that is used for internal read
        alt_em10g32_altsyncram_bundle #(
            .DEVICE_FAMILY              (DEVICE_FAMILY),
            .WIDTH                      (36),
            .DEPTH                      (32),
            .ENABLE_MEM_ECC             (ENABLE_MEM_ECC),
            .ENABLE_ECC_PIPELINE_STAGE  (ENABLE_MEM_ECC),
            .REGISTERED_OUTPUT          (1)
        ) mem_count (
            .data       (mem_wrdata),
            .rd_aclr    (~csr_reset_n),
            .rdaddress  (cnt_rdaddr_wire),
            .rdclock    (clk),
            .rden       (1'b1),
            .wraddress  (mem_wraddress),
            .wrclock    (clk),
            .wren       (mem_wren),
            .eccstatus  (mem_stat_update_eccstatus),
            .q          (cnt_out_w)
        );
        
        // Memory that is used for CSR read
        alt_em10g32_altsyncram_bundle #(
            .DEVICE_FAMILY              (DEVICE_FAMILY),
            .WIDTH                      (36),
            .DEPTH                      (32),
            .ENABLE_MEM_ECC             (ENABLE_MEM_ECC),
            .ENABLE_ECC_PIPELINE_STAGE  (ENABLE_MEM_ECC),
            .REGISTERED_OUTPUT          (1)
        ) mem_csr (
            .data       (mem_wrdata),
            .rd_aclr    (~csr_reset_n),
            .rdaddress  (csr_address[5:1]),
            .rdclock    (clk),
            .rden       (1'b1),
            .wraddress  (mem_wraddress),
            .wrclock    (clk),
            .wren       (mem_wren),
            .eccstatus  (mem_stat_csr_eccstatus),
            .q          (host_data_w)
        );
        
        always @(*) begin
            cnt_out = cnt_out_w;
            host_data = host_data_w;
        end
        
    end
    endgenerate
    
    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Increment ifErrors
    // - The total number of packets that contain error and invalid packets.(error and invalid packets)
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    reg control_ifErrors;
    
    always @ (posedge clk) begin
        if (sw_reset) begin
            control_ifErrors <= 1'b0;
        end
        else begin
            control_ifErrors <= stat_sink_valid & (error | !valid);
        end
    end
    
    always @(posedge clk) begin
        
            if (sw_reset) begin
                ifErrors <= REG_RESET_VALUE[(REG_WIDTH)-1:0];
                ifErrors_lsb <= 16'b0;
                ifErrors_lsb_carry <= 1'b0;
            end
            else begin
                if (control_ifErrors)  begin
                    // ifErrors <= ifErrors + 1'b1;
                    {ifErrors_lsb_carry,ifErrors_lsb} <= ifErrors_lsb + 1'b1;
                end
                else begin
                    // ifErrors <= ifErrors;
                    ifErrors_lsb_carry <= 1'b0;
                    ifErrors_lsb <= ifErrors_lsb;
                end
                ifErrors[15:0] <= ifErrors_lsb;
                ifErrors [35:16] <= ifErrors [35:16] + ifErrors_lsb_carry;
            end
        
		 end 


    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Increment etherStatsPkts
    // - The total number of packets received. (good, error and invalid packets)
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    reg stat_sink_valid_pipe1;
    
    always @(posedge clk ) begin
        if (sw_reset) begin
            stat_sink_valid_pipe1 <= 1'b0;
        end
        else begin
            stat_sink_valid_pipe1 <= stat_sink_valid;
        end
    end
    
    
    always @(posedge clk ) begin
       
            if (sw_reset) begin
                etherStatsPkts <= REG_RESET_VALUE[(REG_WIDTH)-1:0];
                etherStatsPkts_lsb <= 16'b0;
                etherStatsPkts_carry <= 1'b0;
            end
            else begin
                    if (stat_sink_valid_pipe1)  begin
                        // etherStatsPkts <= etherStatsPkts + 1'b1;
                        {etherStatsPkts_carry,etherStatsPkts_lsb} <= etherStatsPkts_lsb + 1'b1;
                    end
                    else begin
                        // etherStatsPkts <= etherStatsPkts;
                        etherStatsPkts_lsb <= etherStatsPkts_lsb;
                        etherStatsPkts_carry <= 1'b0;
                    end
                    etherStatsPkts[15:0] <=  etherStatsPkts_lsb;
                    etherStatsPkts[35:16] <= etherStatsPkts[35:16] + etherStatsPkts_carry;
            end
        
    end


    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Increment octetsOK
    // - A count of data and padding octets in frames that are successfully transmitted/receive. (good frames only including control frames)
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    reg control_octetsOK;
    reg [15:0]payload_length_pipe1;
    
    
    always @(posedge clk ) begin
        if (sw_reset) begin
            control_octetsOK <= 1'b0;
        end
        else begin
            control_octetsOK <= stat_sink_valid & !error & valid;
        end
        
        payload_length_pipe1 <= payload_length;
    end
    
    always @(posedge clk ) begin
       
            if (sw_reset) begin
                octetsOK <= OCTET_REG_RESET_VALUE;
                octetsOK_lsb <= OCTET_REG_RESET_VALUE[27:0];
                octetsOK_lsb_carry <= 1'b0;
            end
            else begin
                if (control_octetsOK) begin
                    {octetsOK_lsb_carry, octetsOK_lsb} <= octetsOK_lsb + payload_length_pipe1;
                end
                else begin
                    octetsOK_lsb <= octetsOK_lsb;
                    octetsOK_lsb_carry <= 1'b0;
                end
                
                octetsOK[27:0] <= octetsOK_lsb;
                octetsOK[63:28] <= octetsOK[63:28] + octetsOK_lsb_carry;
            end
        
    end


    // ###########################################################################################
    // ---------------------------------------------------------------------------
    // Increment etherStatsOctets
    // - The total number of octets of data received on the network (good, error and invalid packets excluding framing bits but including FCS octets)
    // ---------------------------------------------------------------------------
    // ###########################################################################################
    reg [15:0]pkt_length_pipe1;
    
    always @(posedge clk ) begin
        
        pkt_length_pipe1 <= pkt_length;
        
    end
    
    always @(posedge clk ) begin
        
            if (sw_reset) begin
                etherStatsOctets <= OCTET_REG_RESET_VALUE;
                etherStatsOctets_lsb <= OCTET_REG_RESET_VALUE[27:0];
                etherStatsOctets_lsb_carry <= 1'b0;
            end
            else begin
                if(stat_sink_valid_pipe1) begin
                    {etherStatsOctets_lsb_carry, etherStatsOctets_lsb} <= etherStatsOctets_lsb + pkt_length_pipe1;
                end
                else begin
                    etherStatsOctets_lsb <= etherStatsOctets_lsb;
                    etherStatsOctets_lsb_carry <= 1'b0;
                end
                
                etherStatsOctets[27:0] <= etherStatsOctets_lsb;
                etherStatsOctets[63:28] <= etherStatsOctets[63:28] + etherStatsOctets_lsb_carry;
            end
        
    end
    
    //  ------------
    //  ECC Status
    //  ------------
    always @ (posedge clk) begin
        mem_stat_update_ecc_err_corrected <= mem_stat_update_eccstatus[1] & ~mem_stat_update_eccstatus[0];
        mem_stat_update_ecc_err_fatal <= mem_stat_update_eccstatus[1] & mem_stat_update_eccstatus[0];
        mem_stat_csr_ecc_err_corrected <= mem_stat_csr_eccstatus[1] & ~mem_stat_csr_eccstatus[0];
        mem_stat_csr_ecc_err_fatal <= mem_stat_csr_eccstatus[1] & mem_stat_csr_eccstatus[0];
    end

    
    // assign mem_stat_update_ecc_err_corrected = mem_stat_update_eccstatus[1] & ~mem_stat_update_eccstatus[0];
    // assign mem_stat_update_ecc_err_fatal = mem_stat_update_eccstatus[1] & mem_stat_update_eccstatus[0];
    // assign mem_stat_csr_ecc_err_corrected = mem_stat_csr_eccstatus[1] & ~mem_stat_csr_eccstatus[0];
    // assign mem_stat_csr_ecc_err_fatal = mem_stat_csr_eccstatus[1] & mem_stat_csr_eccstatus[0];
    
endmodule

