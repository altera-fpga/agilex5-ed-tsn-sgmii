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


// $Id: #1 $
// $Revision: #1 $
// $Date: 2009/04/27 $
// $Author: smlam $
//-----------------------------------------------------------------------------
// =head1 NAME
// Packet Back Pressure Controller module 
//-----------------------------------------------------------------------------
// =head1 COPYRIGHT
// Copyright (c) 2008 Altera Corporation. All Rights Reserved.
// The information contained in this file is the property of Altera
// Corporation. Except as specifically authorized in writing by Altera 
// Corporation, the holder of this file shall keep all information 
// contained herein confidential and shall protect same in whole or in part 
// from disclosure and dissemination to all third parties. Use of this 
// program confirms your agreement with the terms of this license.
//-----------------------------------------------------------------------------
// =head1 DESCRIPTION
// The packet backpressure controller is responsible to back pressure in-coming packets on the Avalon-ST Sink Data interface.
// The core will backpressure when the csr is set or when a valid pause beats is received from the Av-ST pause interface.
// 
//-----------------------------------------------------------------------------
`timescale 1ns / 1ns
module alt_em10g32_rx_pkt_backpressure_control (

 			//Common clock and Reset
                        clk,
                        reset_n /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=\"R102\"" */, 
                        csr_reset_n,
						
			//CSR Interface
                        csr_write,
                        csr_read,
                        csr_address,
                        csr_writedata,
                        csr_readdata,
						
			//Av-ST Data Sink
                        data_sink_sop,
			data_sink_eop,
			data_sink_valid,
			data_sink_ready,
			data_sink_data,
			data_sink_empty,
			data_sink_error,
 
 			//Av-ST Data Source
                        data_src_sop,
			data_src_eop,
			data_src_valid,
			data_src_ready,
			data_src_data,
			data_src_empty,
			data_src_error,
						
			//Av-st Pause Duration
                        pausebeats_sink_valid,
			pausebeats_sink_data
                   
	);

// =head1 GLOBAL PARAMETERS
   
   // =head2 Avalon Streaming
   parameter BITSPERSYMBOL                   = 8;  // Streaming Data symbol width in bits
   parameter SYMBOLSPERBEAT                  = 8;  // Streaming Number of symbols per word
   parameter ERROR_WIDTH                     = 1;  // Streaming port error width
   
   // =head2 Others
   parameter USE_READY                       = 1;  // Option to use the ready signal
   parameter SYNC_RESET_N                    = 1; 
   // =cut

   
   // =head1 LOCAL PARAMETERS
   
   // =head2 Avalon Streaming
   localparam EMPTY_WIDTH                    = log2ceil(SYMBOLSPERBEAT); 
   localparam DATA_WIDTH                     = BITSPERSYMBOL * SYMBOLSPERBEAT;

   // =head2 Avalon Master
   localparam CSR_DATAPATH_WIDTH 	     = 32;
   localparam CSR_ADDRESS_WIDTH              = 1;
   
   // =head2 Avalon Streaming for Pause Interface
   localparam PAUSEBEATS_WIDTH               = 32;
   
   // =head2 Timer
   localparam TIMER_WIDTH = PAUSEBEATS_WIDTH;

   
   // =head2 Clock Interface
   input                                                 clk;
   input                                                 reset_n;	  
   input                                                 csr_reset_n;
   
   // =head2 Avalon MM Slave CSR Interface
   input                                                 csr_write;
   input                                                 csr_read;
   input       [(CSR_ADDRESS_WIDTH)-1:0]                 csr_address;
   (* altera_attribute = "-name MESSAGE_DISABLE 15610" *) input       [(CSR_DATAPATH_WIDTH)-1:0]	csr_writedata;
   (* altera_attribute = "-name MESSAGE_DISABLE 13410" *) output      [(CSR_DATAPATH_WIDTH)-1:0]	csr_readdata;
 
   // =head2 Avalon ST DataIn (Sink) Interface
   input                                                 data_sink_sop;
   input                                                 data_sink_eop;
   input                                                 data_sink_valid;
   output                                                data_sink_ready;
   input       [(DATA_WIDTH)-1:0]                        data_sink_data;
   input       [(EMPTY_WIDTH)-1:0]                       data_sink_empty;
   input       [(ERROR_WIDTH)-1:0]                       data_sink_error;

   // =head2 Avalon ST DataOut (Source) Interface
   output                                                data_src_sop;
   output                                                data_src_eop;
   output                                                data_src_valid;
   input                                                 data_src_ready;
   output      [(DATA_WIDTH)-1:0]                        data_src_data;
   output      [(EMPTY_WIDTH)-1:0]                       data_src_empty;
   output      [(ERROR_WIDTH)-1:0]                       data_src_error;  
   
   // =head2 Avalon ST Pause Quanta from MAC RX (Sink) Interface
   input                                           	 pausebeats_sink_valid;
   input       [(PAUSEBEATS_WIDTH)-1:0]                  pausebeats_sink_data;
   
 
 // ----------------------------------------------------------------------------
 // Local registers and wire declarations
 // ----------------------------------------------------------------------------
	
	// Timer block
	// reg[(TIMER_WIDTH)-1:0] timer;
	reg[15:0] timer_msb;
	reg[15:0] timer_lsb;
    wire  [15:0]   timer_lsb_mod;
	reg timer_not_zero;
	reg timer_enable;

	// Avalon-MM CSR 	
	reg controlreg;	// register map for controlreg wire: stop_x_reg
	reg statusreg;

	// Packet
	reg packet_frame;
	wire pause;
	reg intermediate_ready;

	// Wires
	wire internal_src_ready_in;
	wire internal_src_ready_out;
	wire internal_src_valid;
	wire internal_sink_ready;

	// Output registers 
 	reg [(CSR_DATAPATH_WIDTH)-1:0]  csr_readdata; 

	
// ###########################################################################################
// ---------------------------------------------------------------------------
// CSR Interface and Register Space
// ---------------------------------------------------------------------------
// ###########################################################################################
    
// ---------------------------------------------------------------------------
// Control register and status register
// This block handles the write transaction from the Avalon-MM CSR interface.
// - The control register can be written and read. The status register is read-only.
// - Status register indicates the state of the core (backpressure or not backpressure).
// ---------------------------------------------------------------------------
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin
	    if (!csr_reset_n) begin
		    controlreg <= 1'b0;
		    statusreg <= 1'b0;
	    end
	    else begin
		if (csr_write == 1'b1 && csr_address == 1'b0) begin
			controlreg <= csr_writedata[0]; 
		end
		
		statusreg <= ~(internal_src_ready_in & intermediate_ready);
	     end
    end
  end else begin
    always @(posedge clk or negedge csr_reset_n) begin
	    if (!csr_reset_n) begin
		    controlreg <= 1'b0;
		    statusreg <= 1'b0;
	    end
	    else begin
		if (csr_write == 1'b1 && csr_address == 1'b0) begin
			controlreg <= csr_writedata[0]; 
		end
		
		statusreg <= ~(internal_src_ready_in & intermediate_ready);
	     end
    end
  end
  endgenerate

// ---------------------------------------------------------------------------
// Register space read back logic
// This block handles the read transaction from the Avalon-MM CSR interface
// ---------------------------------------------------------------------------
  generate if (SYNC_RESET_N == 1) begin
    always @(posedge clk) begin 
	if (!csr_reset_n) begin
		csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};   
	end
	else begin
		if ((csr_read == 1'b1) && (csr_address == 1'b0)) begin
				csr_readdata[0] <= controlreg; 
		end
		else if ((csr_read == 1'b1) && (csr_address == 1'b1)) begin
				csr_readdata[0] <= statusreg; 
		end
		else begin
			csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}}; 
		end			
	     end
    end	
  end else begin
    always @(posedge clk or negedge csr_reset_n) begin 
	if (!csr_reset_n) begin
		csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}};   
	end
	else begin
		if ((csr_read == 1'b1) && (csr_address == 1'b0)) begin
				csr_readdata[0] <= controlreg; 
		end
		else if ((csr_read == 1'b1) && (csr_address == 1'b1)) begin
				csr_readdata[0] <= statusreg; 
		end
		else begin
			csr_readdata <= {CSR_DATAPATH_WIDTH{1'b0}}; 
		end			
	     end
    end	
  end
  endgenerate

// ###########################################################################################
// ---------------------------------------------------------------------------
// Pause Timer 
// The timer would only be loaded when the pausebeats is valid. It will only decrements until zero.
// ---------------------------------------------------------------------------
// ###########################################################################################

    reg [2:0]state;
    reg [2:0]next_state;
    
    localparam IDLE = 3'b000;
    localparam LOAD = 3'b001;
    localparam LSBD = 3'b010;
    localparam MSBD = 3'b011;
    localparam PEND = 3'b100;
    
    
    // SYNC_RESET FLOPS
    always @ (posedge clk)
        begin
        if(!reset_n)
            begin
            state <= IDLE;
            end
        else
            begin
            state <= next_state;
            end
        end
        
    always @ (*)
        begin
        case(state)
        IDLE    :   if(pausebeats_sink_valid)  
                        begin
                        next_state = LOAD;
                        end
                    else
                        begin
                        next_state = IDLE;
                        end
        LOAD    :   next_state =  PEND;
        PEND    :   if(pausebeats_sink_valid)
                        begin
                        next_state =  LOAD;
                        end
                    else if(timer_enable == 1'b0)
                        begin
                        next_state =  PEND;
                        end    
                    else 
                        begin
                        next_state =  LSBD;
                        end
        LSBD    :   if(pausebeats_sink_valid)
                        begin
                        next_state = LOAD;
                        end
                    else if(timer_lsb > 1)
                        begin
                        next_state = LSBD;
                        end
                    else if(timer_msb == 0)
                        begin
                        next_state = IDLE;
                        end    
                    else
                        begin
                        next_state = MSBD;
                        end
        MSBD    :   if(pausebeats_sink_valid)
                        begin
                        next_state = LOAD;
                        end
                    else if(timer_msb !=0)
                        begin
                        next_state = LSBD;
                        end
                    else
                        begin
                        next_state = IDLE;
                        end
        default:    next_state = IDLE;                
        endcase
        end
        
    // SYNC_RESET FLOPS
    always @ (posedge clk)        
        begin
        case(state)
        IDLE:   begin
                timer_lsb <= 16'b0;
                timer_msb <= 16'b0;
                end
        LOAD:   begin
                timer_lsb <= pausebeats_sink_data[15:0];
                timer_msb <= pausebeats_sink_data[31:16];
                end
        PEND:   begin
                timer_lsb <= timer_lsb;
                timer_msb <= timer_msb;
                end
        LSBD:   begin
                timer_lsb <= timer_lsb -1'b1;
                timer_msb <= timer_msb;
                end
        MSBD:   begin
                timer_lsb <= 16'hFFFF;
                timer_msb <= timer_msb -1'b1;
                end
        endcase        
        end    
    // SYNC_RESET FLOPS
    /* always @(posedge clk) begin
        if (!reset_n) begin
            // timer <= {TIMER_WIDTH{1'b0}};
            timer_msb <= 16'b0;
            timer_lsb <= 16'b0;
            timer_not_zero <= 1'b0;
        end
        else begin
            if (pausebeats_sink_valid) begin
                // timer <= pausebeats_sink_data;
                timer_msb <= pausebeats_sink_data[31:16];
                timer_lsb <= pausebeats_sink_data[15:0];
                timer_not_zero <= (pausebeats_sink_data > 0);
            end
            else begin
                if ((timer_not_zero) && (timer_enable)) begin
                    // timer <= timer - 1'b1;
                    timer_lsb <= timer_lsb - 1'b1;
                    if(timer_lsb == 0) begin
                    timer_msb <= timer_msb - 1'b1;
                    end                    
                end
                
                timer_not_zero <= (|timer_lsb) || (|timer_msb);
            end
        end
    end */


// ###########################################################################################
// ---------------------------------------------------------------------------
// Timer Enable 
// This block controls the start and stop of the timer.
// - It disable the timer when it is zero
// - It enable the timer only if there core is not transmitting a packet 
// ---------------------------------------------------------------------------
// ###########################################################################################
    // SYNC_RESET FLOPS
    always @(posedge clk) begin
     	if(!reset_n) begin
		timer_enable <=1'b0;
     	end
     	else begin

		if (timer_msb==0 && timer_lsb==0) begin
			timer_enable<=1'b0;
		end
		else begin
			if (!(packet_frame | (data_sink_sop & internal_sink_ready & data_sink_valid & !data_sink_eop))) begin
				timer_enable<=1'b1;
			end
		end
    	end
    end


// ###########################################################################################
// ---------------------------------------------------------------------------
// Pause
// This logic indicates pause due to the timer and the control register
// ---------------------------------------------------------------------------
// ###########################################################################################
    // Minus 1 due to packet backpressure control module always introduce additional clock cycle of pause
    //assign pause = (((|timer_lsb) || (|timer_msb) == 1'b0) && (controlreg==1'b0)) ? 1'b0:1'b1;
    assign timer_lsb_mod = (state == LSBD || state == MSBD) ? timer_lsb: 16'b0;
    assign pause = ((( (|timer_lsb_mod) || (|timer_msb)) == 1'b0) && (controlreg==1'b0)) ? 1'b0:1'b1;
    // assign pause = ((|(timer[TIMER_WIDTH-1:1]) == 1'b0) && (controlreg==1'b0)) ? 1'b0:1'b1;


// ###########################################################################################
// ---------------------------------------------------------------------------
// Intermediate ready
// This block is the decision-maker for backpressure depending on pause, packet_frame, start of packet,
// and end of packet
// ---------------------------------------------------------------------------
// ###########################################################################################
   // SYNC_RESET FLOPS
    always @ (posedge clk) begin
  	if (!reset_n) begin
        packet_frame <= 1'b0;
	 	intermediate_ready<=1'b1;
  	end 
  	else begin
		if(!packet_frame) begin
			if (data_sink_sop & data_sink_valid & internal_sink_ready & !data_sink_eop) begin

			end
			else begin
				if (pause) begin
					intermediate_ready<=1'b0;
				end
				else begin
					intermediate_ready<=1'b1;
				end
			end
		end 
   	end
    end




// ###########################################################################################
// ---------------------------------------------------------------------------
// Output 
// Internal sink ready and internal source ready is tied to 1 when USE_READY is configured to '0'
// ---------------------------------------------------------------------------
// ###########################################################################################
   assign internal_sink_ready = USE_READY? internal_src_ready_in & intermediate_ready : 1'b1; 
   assign internal_src_valid = data_sink_valid & intermediate_ready; 
   assign internal_src_ready_out = USE_READY? data_src_ready : 1'b1;  
   assign data_sink_ready = internal_sink_ready;

// ---------------------------------------------------------------------------
// Avalon-ST source interface
// ---------------------------------------------------------------------------

   assign data_src_valid = internal_src_valid;
   assign internal_src_ready_in = internal_src_ready_out;
   assign data_src_data  = data_sink_data;
   assign data_src_sop   = data_sink_sop;
   assign data_src_eop   = data_sink_eop;
   assign data_src_empty = data_sink_empty;
   assign data_src_error = data_sink_error;
		

// --------------------------------------------------
// Calculates the log2ceil of the input value
// --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1; 
            end
        end
    endfunction

endmodule

