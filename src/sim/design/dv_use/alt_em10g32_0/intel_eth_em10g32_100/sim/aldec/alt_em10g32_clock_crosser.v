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


`timescale 1ns / 1ns
module alt_em10g32_clock_crosser(
                                 in_clk,
                                 in_reset_n,
                                 in_ready,
                                 in_valid,
                                 in_data,
                                 out_clk,
                                 out_reset_n,
                                 out_ready,
                                 out_valid,
                                 out_data
                                );

  parameter  SYMBOLS_PER_BEAT    = 1;
  parameter  BITS_PER_SYMBOL     = 8;
  parameter  FORWARD_SYNC_DEPTH  = 3;
  parameter  BACKWARD_SYNC_DEPTH = 3;
  parameter  USE_OUTPUT_PIPELINE = 1;
  parameter  ASYNC_RST = 0;
  
  localparam DATA_WIDTH = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
  localparam FORWARD_SYNC_DEPTH_INT = FORWARD_SYNC_DEPTH - 1;
  localparam BACKWARD_SYNC_DEPTH_INT = BACKWARD_SYNC_DEPTH - 1;

  input                   in_clk;
  input                   in_reset_n;
  output                  in_ready;
  input                   in_valid;
  input  [DATA_WIDTH-1:0] in_data;

  input                   out_clk;
  input                   out_reset_n;
  input                   out_ready;
  output                  out_valid;
  output [DATA_WIDTH-1:0] out_data;

  // Data is guaranteed valid by control signal clock crossing.  Cut data
  // buffer false path.
  (* altera_attribute = {"-name SUPPRESS_DA_RULE_INTERNAL \"D101,D102,D103\"" } *) reg [DATA_WIDTH-1:0] in_data_buffer;
  (* altera_attribute = {"-name SYNCHRONIZER_IDENTIFICATION OFF"} *)               reg [DATA_WIDTH-1:0] out_data_buffer;

  reg                     in_data_toggle;
  wire                    out_data_toggle;
  reg                     out_data_toggle_flopped;

  wire                    take_in_data;
  wire                    out_data_taken;

  wire                    out_valid_internal;
  wire                    out_ready_internal;
  
  // Asserted during reset, to ensure that in_ready is 0 during reset
  reg                     in_under_reset;
  reg                     in_ready;
  
  // Clock cross synchronization, use sync reset to avoid metastable issue at the output, thus not using altera_std_synchronizer

  wire                    in_data_toggle_returned_sync_wire;
  
  wire                      out_data_toggle_sync_wire;
  reg                       out_data_toggle_sync_reg2;
  
  wire                      wire_in_data_toggle;
  assign wire_in_data_toggle =  take_in_data ? ~in_data_toggle : in_data_toggle;                

  
  assign take_in_data = in_valid & in_ready;
  assign out_valid_internal = out_data_toggle ^ out_data_toggle_flopped;
  assign out_data_taken = out_ready_internal & out_valid_internal;

  generate if (ASYNC_RST == 1) begin
      always @(posedge in_clk or negedge in_reset_n) begin
        if (!in_reset_n) 
            begin
            in_ready <= 1'b0;
            end 
        else 
            begin
            in_ready <= ~(in_data_toggle_returned_sync_wire ^ wire_in_data_toggle);
            end //in_reset_n
      end //in_clk always block
      
      always @(posedge in_clk or negedge in_reset_n) begin
        if (!in_reset_n) begin
            in_data_toggle <= 1'b0;
        end else begin
          if (take_in_data) begin
            in_data_toggle <= ~in_data_toggle;
          end
        end //in_reset_n
      end //in_clk always block 
  end else begin
      always @(posedge in_clk) begin
        if (!in_reset_n) 
            begin
            in_ready <= 1'b0;
            end 
        else 
            begin
            in_ready <= ~(in_data_toggle_returned_sync_wire ^ wire_in_data_toggle);
            end //in_reset_n
      end //in_clk always block
      
      always @(posedge in_clk) begin
        if (!in_reset_n) begin
            in_data_toggle <= 1'b0;
        end else begin
          if (take_in_data) begin
            in_data_toggle <= ~in_data_toggle;
          end
        end //in_reset_n
      end //in_clk always block
      
  end
  endgenerate
  
  
  // in_data_buffer and out_data_buffer should use different always block without reset.
  always @(posedge in_clk) 
      begin
      if (take_in_data) 
          begin
          in_data_buffer <= in_data;    
          end
      end
      
  always @(posedge out_clk) 
      begin
      out_data_buffer <= in_data_buffer;
      end    

  generate if (ASYNC_RST == 1) begin
      always @(posedge out_clk or negedge out_reset_n) begin
        if (!out_reset_n) begin
          out_data_toggle_flopped <= 1'b0;
        end else begin
          if (out_data_taken) begin
            out_data_toggle_flopped <= out_data_toggle;
          end
        end //end if
      end //out_clk always block
      
      always @(posedge out_clk or negedge out_reset_n) begin
        if(!out_reset_n) begin
          out_data_toggle_sync_reg2 <= 1'b0;
        end else begin
          out_data_toggle_sync_reg2 <= out_data_toggle_sync_wire;
        end
      end //out_clk always block 
  end else begin
      always @(posedge out_clk) begin
        if (!out_reset_n) begin
          out_data_toggle_flopped <= 1'b0;
        end else begin
          if (out_data_taken) begin
            out_data_toggle_flopped <= out_data_toggle;
          end
        end //end if
      end //out_clk always block
      
      always @(posedge out_clk) begin
        if(!out_reset_n) begin
          out_data_toggle_sync_reg2 <= 1'b0;
        end else begin
          out_data_toggle_sync_reg2 <= out_data_toggle_sync_wire;
        end
      end //out_clk always block
      
  end
  endgenerate
  
  assign out_data_toggle = out_data_toggle_sync_reg2;
  altera_std_synchronizer_nocut #(
         .depth(FORWARD_SYNC_DEPTH_INT)
      ) synchronizer_nocut_forward_sync (
      .clk       (out_clk), 
      .reset_n   (1'b1), 
      .din       (in_data_toggle), 
      .dout      (out_data_toggle_sync_wire)
      );
  

    altera_std_synchronizer_nocut #(
         .depth(BACKWARD_SYNC_DEPTH_INT)
      ) synchronizer_nocut_backward_sync (
      .clk       (in_clk), 
      .reset_n   (1'b1), 
      .din       (out_data_toggle_flopped), 
      .dout      (in_data_toggle_returned_sync_wire)
      );
        
  generate if (USE_OUTPUT_PIPELINE == 1) begin

      alt_em10g32_pipeline_base 
      #(
         .BITS_PER_SYMBOL(BITS_PER_SYMBOL),
         .SYMBOLS_PER_BEAT(SYMBOLS_PER_BEAT)
      ) output_stage (
         .clk(out_clk),
         .reset_n(out_reset_n),
         .in_ready(out_ready_internal),
         .in_valid(out_valid_internal),
         .in_data(out_data_buffer),
         .out_ready(out_ready),
         .out_valid(out_valid),
         .out_data(out_data)
      );

  end else begin

      assign out_valid = out_valid_internal;
      assign out_ready_internal = out_ready;
      assign out_data = out_data_buffer;

  end

  endgenerate

endmodule
