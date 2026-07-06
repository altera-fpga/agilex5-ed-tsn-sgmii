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


//////////////////////////////////////////////////////////////////////////////
// 
// Module: 
// 
// Description: 
//
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps


module alt_em10g32_sc_fifo #(
    parameter FFDEPTH       = 8, // must be power of 2
    parameter FULLWTRMRK    = 4, // less than FFDEPTH
    parameter DATAWIDTH     = 32,
    parameter USE_FILL_LEVEL = 1,
    parameter USE_CHK_LEVEL  = 0,
    parameter SYNC_RESET_N = 1
) (
    input wire clk,
    input wire rst_n,

    input wire ff_syncrst,

    input wire ff_wr,
    input wire [DATAWIDTH-1:0] ff_wrdata,     
    input wire ff_rd,      
    output reg [DATAWIDTH-1:0] ff_rddata,  
    
    output wire ff_empty,   
    output wire ff_full,

    output wire ff_overflow,
    output wire ff_underflow
);

    // Internal parameters
    localparam ADDRWIDTH = log2ceil(FFDEPTH);

    localparam EMP      = 2'b01;
    localparam NOTEMP   = 2'b10;

    localparam FULL     = 2'b01;
    localparam NOTFULL  = 2'b10;

    // Internal wires and registers
    genvar i;
    reg [DATAWIDTH-1:0] mem [(FFDEPTH-1):0];
    wire [DATAWIDTH-1:0] ff_rrdata_preflop;
    reg [ADDRWIDTH-1:0] ff_wrptr;
    reg [ADDRWIDTH-1:0] ff_rdptr;
    reg [ADDRWIDTH-1:0] ff_datacnt;

    reg [1:0] emp_ps;
    reg [1:0] emp_ns;
    reg [1:0] full_ps;
    reg [1:0] full_ns;

    wire [ADDRWIDTH-1:0] ff_next_wrptr;
    wire [ADDRWIDTH-1:0] ff_next_rdptr;

    // --------------------------------------------------
    // Write to FIFO
    // --------------------------------------------------
    generate
    for (i=0; i<FFDEPTH; i=i+1) begin : registers
	if (SYNC_RESET_N == 1) begin
          always @(posedge clk) begin
              if (!rst_n) begin
                  mem[i] <= {DATAWIDTH{1'b0}};
              end 
              else begin
                  if (ff_wr && (ff_wrptr==i)) begin
                      mem[i] <= ff_wrdata;
                  end
              end
          end
        end else begin
	  always @(posedge clk or negedge rst_n) begin
              if (!rst_n) begin
                  mem[i] <= {DATAWIDTH{1'b0}};
              end 
              else begin
                  if (ff_wr && (ff_wrptr==i)) begin
                      mem[i] <= ff_wrdata;
                  end
              end
          end
        end
    end
    endgenerate

    // --------------------------------------------------
    // Read from FIFO
    // --------------------------------------------------
    // Readdata is showahead
    assign ff_rrdata_preflop = mem[ff_rdptr];

    // Output is registered
    generate if (SYNC_RESET_N == 1) begin
      always @(posedge clk) begin
          if (!rst_n) begin
              ff_rddata <= {DATAWIDTH{1'b0}};
          end
          else begin
              if (ff_rd) begin
                  ff_rddata <= ff_rrdata_preflop;
              end
          end
      end
      end else begin
      always @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
              ff_rddata <= {DATAWIDTH{1'b0}};
          end
          else begin
              if (ff_rd) begin
                  ff_rddata <= ff_rrdata_preflop;
              end
          end
      end
    end
    endgenerate

    // --------------------------------------------------
    // Read pointer
    // Circular FIFO
    // --------------------------------------------------
    generate if (SYNC_RESET_N == 1) begin
      always @(posedge clk) begin
          if (!rst_n) begin
              ff_rdptr <= {ADDRWIDTH{1'b0}};
          end
          else begin
              if (ff_syncrst) begin
                  ff_rdptr <= 3'b0;
              end
              else if (ff_rd) begin
                  ff_rdptr <= ff_rdptr + 1'b1;
              end
          end
      end
      end else begin
      always @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
              ff_rdptr <= {ADDRWIDTH{1'b0}};
          end
          else begin
              if (ff_syncrst) begin
                  ff_rdptr <= 3'b0;
              end
              else if (ff_rd) begin
                  ff_rdptr <= ff_rdptr + 1'b1;
              end
          end
      end
    end
    endgenerate
    // --------------------------------------------------
    // Write pointer
    // Circular FIFO
    // --------------------------------------------------
    generate if (SYNC_RESET_N == 1) begin
      always @(posedge clk) begin
          if (!rst_n) begin
              ff_wrptr <= {ADDRWIDTH{1'b0}};
          end
          else begin
              if (ff_syncrst) begin
                  ff_wrptr <= 3'b0;
              end
              else if (ff_wr) begin
                  ff_wrptr <= ff_wrptr + 1'b1;
              end
          end
      end

      // --------------------------------------------------
      // Data count
      // --------------------------------------------------
      always @(posedge clk) begin
          if (!rst_n) begin
              ff_datacnt <= {ADDRWIDTH{1'b0}};
          end
          else begin
              if (ff_syncrst) begin
                  ff_datacnt <= 3'b0;
              end
              else begin
                  case ({ff_wr, ff_rd})
                      2'b10: ff_datacnt <= ff_datacnt + 1'b1;
                      2'b01: ff_datacnt <= ff_datacnt - 1'b1;
                      default: ff_datacnt <= ff_datacnt;
                  endcase
              end
          end
      end
      end else begin
       always @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
              ff_wrptr <= {ADDRWIDTH{1'b0}};
          end
          else begin
              if (ff_syncrst) begin
                  ff_wrptr <= 3'b0;
              end
              else if (ff_wr) begin
                  ff_wrptr <= ff_wrptr + 1'b1;
              end
          end
      end

      // --------------------------------------------------
      // Data count
      // --------------------------------------------------
      always @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
              ff_datacnt <= {ADDRWIDTH{1'b0}};
          end
          else begin
              if (ff_syncrst) begin
                  ff_datacnt <= 3'b0;
              end
              else begin
                  case ({ff_wr, ff_rd})
                      2'b10: ff_datacnt <= ff_datacnt + 1'b1;
                      2'b01: ff_datacnt <= ff_datacnt - 1'b1;
                      default: ff_datacnt <= ff_datacnt;
                  endcase
              end
          end
      end
    end 
    endgenerate

    // --------------------------------------------------
    // Empty pointer
    // Registered output
    // --------------------------------------------------
    generate
    if (USE_FILL_LEVEL) begin : fill_level
      if (SYNC_RESET_N == 1) begin
      always @(posedge clk) begin
          if (!rst_n) begin
              emp_ps <= EMP;
          end
          else begin 
              emp_ps <= emp_ns;
          end
      end
      end else begin
      always @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
              emp_ps <= EMP;
          end
          else begin 
              emp_ps <= emp_ns;
          end
      end
    end

    always @(*) begin
        emp_ns = emp_ps;

        case (emp_ps)
        EMP: if (!ff_syncrst & ff_wr) begin
                emp_ns = NOTEMP;
             end
        NOTEMP: if (ff_syncrst || (!ff_wr && ff_rd && (ff_datacnt == 4'h1))) begin
                    emp_ns = EMP;
                end
        default: emp_ns = EMP;
        endcase
    end

    assign ff_empty = (emp_ps == EMP); 

    // --------------------------------------------------
    // Full pointer
    // Registered output
    // --------------------------------------------------
    if (SYNC_RESET_N == 1) begin
      always @(posedge clk) begin
          if (!rst_n) begin
              full_ps <= NOTFULL;
          end
          else begin 
              full_ps <= full_ns;
          end
      end
      end else begin
      always @(posedge clk or negedge rst_n) begin
          if (!rst_n) begin
              full_ps <= NOTFULL;
          end
          else begin 
              full_ps <= full_ns;
          end
      end
    end

    always @(*) begin
        full_ns = full_ps;

        case (full_ps)
        NOTFULL: if (!ff_syncrst && ff_wr && !ff_rd && (ff_datacnt == (FULLWTRMRK-1))) begin
                full_ns = FULL;
             end
        FULL: if (ff_syncrst || (!ff_wr && ff_rd && (ff_datacnt == (FULLWTRMRK)))) begin
                    full_ns = NOTFULL;
                end
        default: full_ns = NOTFULL;
        endcase
    end

    assign ff_full = (full_ps == FULL); 

    end
    else begin
        assign ff_full = 1'b0;
        assign ff_empty = 1'b0;
    end
    endgenerate


    // --------------------------------------------------
    // Check for underflow/overflow condition
    // --------------------------------------------------
    generate 
    if (USE_CHK_LEVEL) begin :  check_level 
        assign ff_next_rdptr = ff_rdptr + 1'b1;
        assign ff_next_wrptr = ff_wrptr + 1'b1;
        assign ff_underflow = ff_rd & (ff_next_rdptr == ff_wrptr);
        assign ff_overflow = ff_wr & (ff_next_wrptr == ff_rdptr);
    end
    else begin
        assign ff_underflow = 0;
        assign ff_overflow = 0;
    end
    endgenerate

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

    //	synopsys translate_off
    reg[79:0] EMP_FSM;
    always@(*) begin
	    case(emp_ps)
	    EMP: EMP_FSM = "EMP";
	    NOTEMP: EMP_FSM = "NOTEMP";
	    endcase
    end
    reg[79:0] FULL_FSM;
    always@(*) begin
	    case(emp_ps)
	    FULL: FULL_FSM = "FULL";
	    NOTFULL: FULL_FSM = "NOTFULL";
	    endcase
    end
    //	synopsys translate_on

endmodule
