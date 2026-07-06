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


typedef enum {_400G,_200G,_100G,_50G,_40G,_25G,_10G} speed_e;
typedef struct packed {
   logic [23:0]     am                             ;// sw(read-write) hw(read-only)
}   t_ehip_csr_am_encoding_0;

typedef struct packed {
   logic [23:0]     am                             ;// sw(read-write) hw(read-only)
}   t_ehip_csr_am_encoding_1;

typedef struct packed {
   logic [23:0]     am                             ;// sw(read-write) hw(read-only)
}   t_ehip_csr_am_encoding_2;

typedef struct packed {
   logic [23:0]     am                             ;// sw(read-write) hw(read-only)
}   t_ehip_csr_am_encoding_3;

typedef struct packed {
   logic [19:0]     inj_err                        ;// sw(read-write) hw(read-only)
}   t_ehip_csr_err_inj;

typedef struct packed {
   logic            use_enc                        ;// sw(read-write) hw(read-only)
   logic            use_scr                        ;// sw(read-write) hw(read-only)
   logic            select_tx_am                   ;// sw(read-write) hw(read-only)
   logic            use_striper                    ;// sw(read-write) hw(read-only)
   logic            use_am_insert                  ;// sw(read-write) hw(read-only)
   logic            use_dsc                        ;// sw(read-write) hw(read-only)
   logic            select_rx_am                   ;// sw(read-write) hw(read-only)
   logic            use_aligner                    ;// sw(read-write) hw(read-only)
   logic            use_rx_50g                     ;// sw(read-write) hw(read-only)
   logic            rx_test_pattern_mode           ;// sw(read-write) hw(read-only)
}   t_ehip_csr_phy_ehip_pcs_modes;

typedef struct packed {
	t_ehip_csr_am_encoding_0                                   am_encoding_0;
	t_ehip_csr_am_encoding_1                                   am_encoding_1;
	t_ehip_csr_am_encoding_2                                   am_encoding_2;
	t_ehip_csr_am_encoding_3                                   am_encoding_3;
	t_ehip_csr_err_inj                                               err_inj;
	t_ehip_csr_phy_ehip_pcs_modes                         phy_ehip_pcs_modes;
} t_ehip_tx_pcs_cfg      ;

// `line 6123 "work/quartus/devices/nadder/shared_data/factory/hssi/device/cr2ev0/collect_sim_models/verilog.f" 0
// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_ehip_pipeline.sv $
// $Revision: #16 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/ehip_pipeline.sv
// Date: Fri Mar 17 14:27:26 2017
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//Description
//  EHIP pipeline is a generic pipeline module. It has parameters for WIDTH
//  and LATENCY. Setting latency to 0 makes it act as a wire
//
//
//-----------------------------------------------------------------------------
//Module Declaration


// `line 19 "/nfs/sc/disks/swuser_work_sujoymit/data/sion/rsync/rels/Crete/z1501a/REL5.0--CR2ErevA0P1--KIT__18ww021aaa/c2_ehip_top/rtl/ehip_core/c2_ehip_pipeline.sv" 0
module new_cr2ev0_c2_ehip_pipeline
//import cr2ev0_c2_ehip_package::*;
#(
    parameter   WIDTH   =   1,
    parameter   LATENCY =   1
)
(
    input   logic               i_clk,
    input   logic               i_rst_n,
    input   logic               i_en,
    input   logic   [WIDTH-1:0] i_din,
    output  logic   [WIDTH-1:0] o_dout
);

//-----------------------------------------------------------------------------
//Declarations

    logic   [(LATENCY+1)*WIDTH-1:0] pipeline;

//-----------------------------------------------------------------------------
//Main Body of Code

    //The lower WIDTH bits of the pipeline are the input bits
    assign  pipeline[0+:WIDTH]  =   i_din;


    //If latency is greater than 0, we create a series of LATENCY register
    //words, each WIDTH bits wide. Data moves through this pipeline one step
    //per clock cycle when enable is high
    generate
    if(LATENCY>0)begin:generate_pipeline

        always @(posedge i_clk or negedge i_rst_n)
        if(!i_rst_n)    pipeline[WIDTH+:(LATENCY*WIDTH)]    <=  '0;
        else            pipeline[WIDTH+:(LATENCY*WIDTH)]    <=  i_en?   pipeline[0+:(LATENCY*WIDTH)]:
                                                                        pipeline[WIDTH+:(LATENCY*WIDTH)];
    end:generate_pipeline
    endgenerate

    //The output is the last stage of the pipeline
    assign  o_dout  =   pipeline[LATENCY*WIDTH+:WIDTH];

endmodule



// `line 6146 "work/quartus/devices/nadder/shared_data/factory/hssi/device/cr2ev0/collect_sim_models/verilog.f" 0
// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_ehip_bubble_pipe.sv $
// $Revision: #16 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/ehip_bubble_pipe.sv
// Date: Fri Mar 17 14:27:27 2017
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//Description:
//  This module converts data valid signals that travel with data to an enable
//  signal that can be used to freeze a processing module while incoming data
//  is not to be processed, and an output valid signal that is timed so that
//  it is low for invalid data coming out of the module.
//
//-----------------------------------------------------------------------------
//Module Declaration

// `line 19 "/nfs/sc/disks/swuser_work_sujoymit/data/sion/rsync/rels/Crete/z1501a/REL5.0--CR2ErevA0P1--KIT__18ww021aaa/c2_ehip_top/rtl/ehip_core/c2_ehip_bubble_pipe.sv" 0
module new_cr2ev0_c2_ehip_bubble_pipe
//import cr2ev0_c2_ehip_package::*;
#(
    parameter   LATENCY =   1   //Set to match datapath latency
)
(
    input   logic               i_clk,
    input   logic               i_rst_n,
    input   logic               i_valid,
    output  logic               o_en,
    output  logic               o_valid
);

//-----------------------------------------------------------------------------
//Declarations

    logic           valid;
    logic           pipe_init_values_cleared;

//-----------------------------------------------------------------------------
//Module Declarations

    //Drive enable with the data valid signal
    assign  o_en    =   i_valid;


    //Register the data valid signal to generate enable. Valid is deasserted
    //one cycle after enable goes low, so that the frozen data in the datapath
    //is not read twice into the following stage
    new_cr2ev0_c2_ehip_pipeline #(
        .LATENCY        (LATENCY>0?1:0  ),
        .WIDTH          (1              )
    )
    valid_reg (
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        .i_en           (1'b1           ),
        .i_din          (i_valid        ),
        .o_dout         (valid          )
    );

    //When the datapath has a pipeline, the pipeline needs time to clear
    //before the first set of valid data is available.
    //pipe_init_values_cleared qualifies the valid signal to account for
    //initial pipeline contents
    new_cr2ev0_c2_ehip_pipeline #(
        .LATENCY        (LATENCY                    ),
        .WIDTH          (1                          )
    )
    suppress_initial_pipe_output (
        .i_clk          (i_clk                      ),
        .i_rst_n        (i_rst_n                    ),
        .i_en           (i_valid                    ),
        .i_din          (1'b1                       ),
        .o_dout         (pipe_init_values_cleared   )
    );

    //The output valid signal is asserted when valid is high and the initial
    //contents of the pipelines have cleared
    assign  o_valid =   valid && pipe_init_values_cleared;



endmodule

// `line 6194 "work/quartus/devices/nadder/shared_data/factory/hssi/device/cr2ev0/collect_sim_models/verilog.f" 0
// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_ehip_bip_xor_5way.sv $
// $Revision: #16 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/ehip_bip_xor_5way.sv
// Date: Fri Mar 17 14:27:28 2017
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Copyright ?? 2015 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//Description:
//  This is the 8-bit BIP generation circuit. It calculates BIP for 5 separate
//  virtual lanes. It takes time multiplexed data for 5 lanes as its input,
//  and calculates an independent BIP over all the blocks for each lane,
//  restarting the calculation when i_restart is high
//
//-----------------------------------------------------------------------------


// `line 28 "/nfs/sc/disks/swuser_work_sujoymit/data/sion/rsync/rels/Crete/z1501a/REL5.0--CR2ErevA0P1--KIT__18ww021aaa/c2_ehip_top/rtl/ehip_core/c2_ehip_bip_xor_5way.sv" 0
module new_cr2ev0_c2_ehip_bip_xor_5way
//import cr2ev0_c2_ehip_package::*;
#(
    parameter   USE_PIPE    =   0
)
(
    input   logic           i_clk,
    input   logic           i_rst_n,
    input   logic           i_en,
    input   logic           i_restart,
    input   logic   [2:0]   i_vl_cnt,
    input   logic   [65:0]  i_din,//[TODO] need to change width to max requirement
    output  logic   [7:0]   o_dout
);

//-----------------------------------------------------------------------------
//Declarations

    localparam          BIP_W   =   8;  //Width of the BIP

    logic   [7:0]       bip_xor;
    logic   [65:0]      d;//[TODO] need to change width to max
    logic   [7:0]       prev_vl [4:0];
    logic   [7:0]       bip;
    logic   [4:0]       en_vl;

    genvar              vl;


//-----------------------------------------------------------------------------
//Main Body of Code

    //Use a shorter name for the data input to simplify the xor equations
    assign  d   =   i_din;//[TODO] need to select the part based on speed

    //XOR function to generate BIP based on Table 82-4 //[TODO] check bip insertions for speeds otherthan 100G
    assign bip_xor[0] = d[2]^d[10]^d[18]^d[26]^d[34]^d[42]^d[50]^d[58];
    assign bip_xor[1] = d[3]^d[11]^d[19]^d[27]^d[35]^d[43]^d[51]^d[59];
    assign bip_xor[2] = d[4]^d[12]^d[20]^d[28]^d[36]^d[44]^d[52]^d[60];
    assign bip_xor[3] = d[0]^d[5]^d[13]^d[21]^d[29]^d[37]^d[45]^d[53]^d[61];
    assign bip_xor[4] = d[1]^d[6]^d[14]^d[22]^d[30]^d[38]^d[46]^d[54]^d[62];
    assign bip_xor[5] = d[7]^d[15]^d[23]^d[31]^d[39]^d[47]^d[55]^d[63];
    assign bip_xor[6] = d[8]^d[16]^d[24]^d[32]^d[40]^d[48]^d[56]^d[64];
    assign bip_xor[7] = d[9]^d[17]^d[25]^d[33]^d[41]^d[49]^d[57]^d[65];


    //Calculate bip for the current virtual lane by adding the bip for the
    //current block to the accumulated bip for the lane. Reset the bip to 8 if
    //restart is high, indicating the start of a new AM period
    assign  bip =   i_restart?  8'h08:
                                (prev_vl[i_vl_cnt]^bip_xor);


    //Accumulate the bip for each virtual lane independently
    generate
    for(vl=0;vl<5;vl=vl+1) begin:generate_vl_registers

        //Only write to a given bip accumulator when the vl is active
        assign  en_vl[vl]   =   i_en && (i_vl_cnt == vl);

        new_cr2ev0_c2_ehip_pipeline #(
            .WIDTH      (BIP_W              ),
            .LATENCY    (1                  )
        )
        prev_register (
            .i_clk      (i_clk              ),
            .i_rst_n    (i_rst_n            ),
            .i_en       (en_vl[vl]          ),
            .i_din      (bip                ),
            .o_dout     (prev_vl[vl]        )
        );

    end:generate_vl_registers
    endgenerate

    //Optionally pipeline the output
    new_cr2ev0_c2_ehip_pipeline #(
        .WIDTH          (BIP_W              ),
        .LATENCY        (USE_PIPE           )
    )
    pipe1 (
        .i_clk          (i_clk              ),
        .i_rst_n        (i_rst_n            ),
        .i_en           (i_en               ),
        .i_din          (prev_vl[i_vl_cnt]  ),
        .o_dout         (o_dout             )
    );

endmodule

// `line 6195 "work/quartus/devices/nadder/shared_data/factory/hssi/device/cr2ev0/collect_sim_models/verilog.f" 0
// $File: //depot/icm/proj/t20socand/icmrel/c2_ehip_top/rtl/c2_ehip_top/ehip_core/c2_ehip_tx_tagger_5way.sv $
// $Revision: #16 $
// $Date: 2017/03/18 $
// $Author: icmAdmin $
//-------------------------------------------------------------------------------
// Cloned by //depot/ipd_tools/bin/clone#5
// Source file: /ice_ip/dsg3/crete/aweng/cr2e/clone/ehip/c3_ehip_rtl/ehip_tx_tagger_5way.sv
// Date: Fri Mar 17 14:27:28 2017
//-------------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Copyright ?? 2015 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//Description:
//    (ORIGINAL) The 5 way tagger adds 100G Ethernet Alignment markers to a
//  stream of 5 virtual lanes sharing a single physical word in the 100G PCS
//  datapath. The block calculates BIP independently for each virtual lane,
//  starting at the AM for that lane and ending on the block before the next AM,
//  then inserts the BIP along with the AM. The time when AMs are inserted is
//  determined by i_am_insert, which must be held high for 5 valid cycles when
//  it is asserted.
//    (JUL 11, 2016) Updated the module to also work for the 40G AM insertion
//  scheme. By and large this means that the module handles 1 virtual lane
//  (instead of 5) and uses different encoding for the AMs. The am_insert
//  signal should only be held high for 1 clock cycle.
//-----------------------------------------------------------------------------


// `line 34 "/nfs/sc/disks/swuser_work_sujoymit/data/sion/rsync/rels/Crete/z1501a/REL5.0--CR2ErevA0P1--KIT__18ww021aaa/c2_ehip_top/rtl/ehip_core/c2_ehip_tx_tagger_5way.sv" 0
module new_cr2ev0_c2_ehip_tx_tagger_5way
//import cr2ev0_c2_ehip_package::*,cr2ev0_c2_ehip_cfgcsr_package::*;
#(
	parameter   VLANE_SET           =   1   // 0..3
)
(
    input   logic                    i_clk,
    input   logic                    i_rst_n,
    input   logic                    i_cfg_half_width,
    input   logic                    i_cfg_skip_tags,
    input   logic  [19:0]            i_cfg_err_inj,
    input   logic                    i_mode_100g, 
    input   logic                    i_valid,
    input   logic  [1055:0]          i_din,
    input   logic                    i_am_insert, 
    input   logic  [3:0]	     i_vlane_set,
    input   string  		     i_speed,
    output  logic  [15:0]            o_dout_am,
    output  logic                    o_dout_vld,
    output  logic  [1055:0]          o_dout
);


//-----------------------------------------------------------------------------
//Declarations

    localparam      TAGGER_LATENCY  =   2;

    //Alignment Marker contents
    // this is cut and paste from the spec table (82-2), lanes 0..19
    //  for obvious compatability
    localparam [64*20-1:0] marker_table_100g_raw = {
        8'hc1,8'h68,8'h21,8'h00,8'h3e,8'h97,8'hde,8'h00,    // lane  0
        8'h9d,8'h71,8'h8e,8'h00,8'h62,8'h8e,8'h71,8'h00,    // lane  1
        8'h59,8'h4b,8'he8,8'h00,8'ha6,8'hb4,8'h17,8'h00,    // lane  2
        8'h4d,8'h95,8'h7b,8'h00,8'hb2,8'h6a,8'h84,8'h00,    // lane  3
        8'hf5,8'h07,8'h09,8'h00,8'h0a,8'hf8,8'hf6,8'h00,    // lane  4
        8'hdd,8'h14,8'hc2,8'h00,8'h22,8'heb,8'h3d,8'h00,    // lane  5
        8'h9a,8'h4a,8'h26,8'h00,8'h65,8'hb5,8'hd9,8'h00,    // lane  6
        8'h7b,8'h45,8'h66,8'h00,8'h84,8'hba,8'h99,8'h00,    // lane  7
        8'ha0,8'h24,8'h76,8'h00,8'h5f,8'hdb,8'h89,8'h00,    // lane  8
        8'h68,8'hc9,8'hfb,8'h00,8'h97,8'h36,8'h04,8'h00,    // lane  9
        8'hfd,8'h6c,8'h99,8'h00,8'h02,8'h93,8'h66,8'h00,    // lane 10
        8'hb9,8'h91,8'h55,8'h00,8'h46,8'h6e,8'haa,8'h00,    // lane 11
        8'h5c,8'hb9,8'hb2,8'h00,8'ha3,8'h46,8'h4d,8'h00,    // lane 12
        8'h1a,8'hf8,8'hbd,8'h00,8'he5,8'h07,8'h42,8'h00,    // lane 13
        8'h83,8'hc7,8'hca,8'h00,8'h7c,8'h38,8'h35,8'h00,    // lane 14
        8'h35,8'h36,8'hcd,8'h00,8'hca,8'hc9,8'h32,8'h00,    // lane 15
        8'hc4,8'h31,8'h4c,8'h00,8'h3b,8'hce,8'hb3,8'h00,    // lane 16
        8'had,8'hd6,8'hb7,8'h00,8'h52,8'h29,8'h48,8'h00,    // lane 17
        8'h5f,8'h66,8'h2a,8'h00,8'ha0,8'h99,8'hd5,8'h00,    // lane 18
        8'hc0,8'hf0,8'he5,8'h00,8'h3f,8'h0f,8'h1a,8'h00     // lane 19
    };

    localparam [64*20-1:0] marker_table_100g_raw_mod = {
        4'hc,4'b000x,8'h68,8'h21,8'h00,8'h3e,8'h97,8'hde,8'h00,    // lane  0
        4'h9,4'b11x1,8'h71,8'h8e,8'h00,8'h62,8'h8e,8'h71,8'h00,    // lane  1
        4'h5,4'b1x01,8'h4b,8'he8,8'h00,8'ha6,8'hb4,8'h17,8'h00,    // lane  2
        4'h4,4'bx101,8'h95,8'h7b,8'h00,8'hb2,8'h6a,8'h84,8'h00,    // lane  3
        4'hf,4'b010x,8'h07,8'h09,8'h00,8'h0a,8'hf8,8'hf6,8'h00,    // lane  4
        8'hdd,8'h14,8'hc2,8'h00,8'h22,8'heb,8'h3d,8'h00,    // lane  5
        8'h9a,8'h4a,8'h26,8'h00,8'h65,8'hb5,8'hd9,8'h00,    // lane  6
        8'h7b,8'h45,8'h66,8'h00,8'h84,8'hba,8'h99,8'h00,    // lane  7
        8'ha0,8'h24,8'h76,8'h00,8'h5f,8'hdb,8'h89,8'h00,    // lane  8
        8'h68,8'hc9,8'hfb,8'h00,8'h97,8'h36,8'h04,8'h00,    // lane  9
        8'hfd,8'h6c,8'h99,8'h00,8'h02,8'h93,8'h66,8'h00,    // lane 10
        8'hb9,8'h91,8'h55,8'h00,8'h46,8'h6e,8'haa,8'h00,    // lane 11
        8'h5c,8'hb9,8'hb2,8'h00,8'ha3,8'h46,8'h4d,8'h00,    // lane 12
        8'h1a,8'hf8,8'hbd,8'h00,8'he5,8'h07,8'h42,8'h00,    // lane 13
        8'h83,8'hc7,8'hca,8'h00,8'h7c,8'h38,8'h35,8'h00,    // lane 14
        8'h35,8'h36,8'hcd,8'h00,8'hca,8'hc9,8'h32,8'h00,    // lane 15
        8'hc4,8'h31,8'h4c,8'h00,8'h3b,8'hce,8'hb3,8'h00,    // lane 16
        8'had,8'hd6,8'hb7,8'h00,8'h52,8'h29,8'h48,8'h00,    // lane 17
        8'h5f,8'h66,8'h2a,8'h00,8'ha0,8'h99,8'hd5,8'h00,    // lane 18
        8'hc0,8'hf0,8'he5,8'h00,8'h3f,8'h0f,8'h1a,8'h00     // lane 19
    };

    logic                   enable;
    logic   [1055:0]        din_r;
    logic   [15:0]          am_insert_r;
    logic   [4:0]           cntr;
    logic   [127:0]         bip;
    logic   [64*20-1:0]     marker_table;
    logic   [120*8-1:0]     marker_table_200g;
    logic   [120*16-1:0]    marker_table_400g;
    logic   [120*16-1:0]    marker_table_200g_400g;
    logic   [64*20-1:0]     marker_table_100g;
    logic   [64*4-1:0]      marker_table_50g;
    logic   [64*4-1:0]      marker_table_40g;
    logic   [64*1-1:0]      marker_table_25g;
    logic   [1055:0]        vlane_tag_full; 
    logic   [1055:0]        vlane_tag_half;  
    logic   [1055:0]        vlane_tag_const;
    logic   [1055:0]        vlane_tag;       
    logic   [1055:0]        dout;                        
    logic   [64*4-1:0]     marker_table_40g_raw;
    logic   [64*4-1:0]     marker_table_50g_raw;
    logic   [3:0][23:0]     am40;
    logic                   cntr_max;
    logic   [4:0]           err_inj;
    logic   [4:0]           cfg_err_inj;
    logic   [4:0]           cfg_err_inj_r;
    logic   [4:0]           do_err_inj;
    logic   [1055:0]        dout_err_inj;
    logic   [15:0]          o_dout_am_100g;
    logic   [15:0]          o_dout_am_200g_400g;
    logic   [1055:0]        o_dout_100g;
    logic   [1055:0]        o_dout_200g_400g;


    genvar i;

//-----------------------------------------------------------------------------
// Main Body of Code

    //Alignment Marker contents
    // this is cut and paste from the spec table (82-3), lanes 0..3
    //  for obvious compatability (the 64 bit AM vectors go
    //  in at the top of the 20 x 64 bit vector to be compatibele
    //  with the 100g table above... lane #4 to #19 do not exist
    //  for a 40g PCS and thus are specified to match 100G to help
    //  minimize the gate count)
   assign o_dout_am = (i_speed == "_200G" || i_speed == "_400G") ? o_dout_am_200g_400g : o_dout_am_100g;
   assign o_dout    = (i_speed == "_200G" || i_speed == "_400G") ? o_dout_200g_400g : o_dout_100g;

//{muralasx} [marker table for 40G]
    assign marker_table_40g_raw = {
        8'h90,8'h76,8'h47,8'h00,8'h6f,8'h89,8'hb8,8'h00,    // lane  0
        8'hf0,8'hc4,8'he6,8'h00,8'h0f,8'h3b,8'h19,8'h00,    // lane  1
        8'hc5,8'h65,8'h9b,8'h00,8'h3a,8'h9a,8'h64,8'h00,    // lane  2
        8'ha2,8'h79,8'h3d,8'h00,8'h5d,8'h86,8'hc2,8'h00    // lane  3
    };
    assign marker_table_50g_raw = {
        8'h90,8'h76,8'h47,8'h00,8'h6f,8'h89,8'hb8,8'h00,    // lane  0
        8'hf0,8'hc4,8'he6,8'h00,8'h0f,8'h3b,8'h19,8'h00,    // lane  1
        8'hc5,8'h65,8'h9b,8'h00,8'h3a,8'h9a,8'h64,8'h00,    // lane  2
        8'ha2,8'h79,8'h3d,8'h00,8'h5d,8'h86,8'hc2,8'h00};    // lane  3
    localparam [64*20-1:0] marker_table_25g_raw =0;
    localparam [120*8-1:0] marker_table_200g_raw ={
	    8'h9A,8'h4A,8'h26,8'h05,8'h65,8'hB5,8'hD9,8'hD6,8'hB3,8'hC0,8'h8C,8'h29,8'h4C,8'h3F,8'h73,  
            8'h9A,8'h4A,8'h26,8'h04,8'h65,8'hB5,8'hD9,8'h67,8'h5A,8'hDE,8'h7E,8'h98,8'hA5,8'h21,8'h81,
            8'h9A,8'h4A,8'h26,8'h46,8'h65,8'hB5,8'hD9,8'hFE,8'h3E,8'hF3,8'h56,8'h01,8'hC1,8'h0C,8'hA9,
            8'h9A,8'h4A,8'h26,8'h5A,8'h65,8'hB5,8'hD9,8'h84,8'h86,8'h80,8'hD0,8'h7B,8'h79,8'h7F,8'h2F,
            8'h9A,8'h4A,8'h26,8'hE1,8'h65,8'hB5,8'hD9,8'h19,8'h2A,8'h51,8'hF2,8'hE6,8'hD5,8'hAE,8'h0D,
            8'h9A,8'h4A,8'h26,8'hF2,8'h65,8'hB5,8'hD9,8'h4E,8'h12,8'h4F,8'hD1,8'hB1,8'hED,8'hB0,8'h2E,
            8'h9A,8'h4A,8'h26,8'h3D,8'h65,8'hB5,8'hD9,8'hEE,8'h42,8'h9C,8'hA1,8'h11,8'hBD,8'h63,8'h5E,
            8'h9A,8'h4A,8'h26,8'h22,8'h65,8'hB5,8'hD9,8'h32,8'hD6,8'h76,8'h5B,8'hCD,8'h29,8'h89,8'hA4};
    localparam [120*16-1:0] marker_table_400g_raw ={
            8'h9A,8'h4A,8'h26,8'hB6,8'h65,8'hB5,8'hD9,8'hD9,8'h01,8'h71,8'hF3,8'h26,8'hFE,8'h8E,8'h0C, 
            8'h9A,8'h4A,8'h26,8'h04,8'h65,8'hB5,8'hD9,8'h67,8'h5A,8'hDE,8'h7E,8'h98,8'hA5,8'h21,8'h81,
            8'h9A,8'h4A,8'h26,8'h46,8'h65,8'hB5,8'hD9,8'hFE,8'h3E,8'hF3,8'h56,8'h01,8'hC1,8'h0C,8'hA9,
            8'h9A,8'h4A,8'h26,8'h5A,8'h65,8'hB5,8'hD9,8'h84,8'h86,8'h80,8'hD0,8'h7B,8'h79,8'h7F,8'h2F,
            8'h9A,8'h4A,8'h26,8'hE1,8'h65,8'hB5,8'hD9,8'h19,8'h2A,8'h51,8'hF2,8'hE6,8'hD5,8'hAE,8'h0D,
            8'h9A,8'h4A,8'h26,8'hF2,8'h65,8'hB5,8'hD9,8'h4E,8'h12,8'h4F,8'hD1,8'hB1,8'hED,8'hB0,8'h2E,
            8'h9A,8'h4A,8'h26,8'h3D,8'h65,8'hB5,8'hD9,8'hEE,8'h42,8'h9C,8'hA1,8'h11,8'hBD,8'h63,8'h5E,
            8'h9A,8'h4A,8'h26,8'h22,8'h65,8'hB5,8'hD9,8'h32,8'hD6,8'h76,8'h5B,8'hCD,8'h29,8'h89,8'hA4,
            8'h9A,8'h4A,8'h26,8'h60,8'h65,8'hB5,8'hD9,8'h9F,8'hE1,8'h73,8'h75,8'h60,8'h1E,8'h8C,8'h8A,
            8'h9A,8'h4A,8'h26,8'h6B,8'h65,8'hB5,8'hD9,8'hA2,8'h71,8'hC4,8'h3C,8'h5D,8'h8E,8'h3B,8'hC3,
            8'h9A,8'h4A,8'h26,8'hFA,8'h65,8'hB5,8'hD9,8'h04,8'h95,8'hEB,8'hD8,8'hFB,8'h6A,8'h14,8'h27,
            8'h9A,8'h4A,8'h26,8'h6C,8'h65,8'hB5,8'hD9,8'h71,8'h22,8'h66,8'h38,8'h8E,8'hDD,8'h99,8'hC7,
            8'h9A,8'h4A,8'h26,8'h18,8'h65,8'hB5,8'hD9,8'h5B,8'hA2,8'hF6,8'h95,8'hA4,8'h5D,8'h09,8'h6A,
            8'h9A,8'h4A,8'h26,8'h14,8'h65,8'hB5,8'hD9,8'hCC,8'h31,8'h97,8'hC3,8'h33,8'hCE,8'h68,8'h3C,
            8'h9A,8'h4A,8'h26,8'hD0,8'h65,8'hB5,8'hD9,8'hB1,8'hCA,8'hFB,8'hA6,8'h4E,8'h35,8'h04,8'h59,
            8'h9A,8'h4A,8'h26,8'hB4,8'h65,8'hB5,8'hD9,8'h56,8'hA6,8'hBA,8'h79,8'hA9,8'h59,8'h45,8'h86};
    //Use a bubble pipe to covert the input valid signal to an enable, and to
    //produce an output valid signal
    new_cr2ev0_c2_ehip_bubble_pipe #(
        .LATENCY        (TAGGER_LATENCY     )
    )
    bubble_pipe (
        .i_clk          (i_clk              ),
        .i_rst_n        (i_rst_n            ),
        .i_valid        (i_valid            ),
        .o_en           (enable             ),
        .o_valid        (o_dout_vld         )
    );



    //Latch error injection requests until a block arrives when they can be
    //processed
    generate
    for(i=0;i<5;i++)begin:g_err_inj

        //Assign error injection requests to the appropriate vlane. In half
        //width mode, there are 2 sets of vlanes, in full width mode there are
        //4
        assign  cfg_err_inj[i] =   i_cfg_half_width?    i_cfg_err_inj[i*2+i_vlane_set]:
                                                        i_cfg_err_inj[i*4+i_vlane_set];

        //Register the error inject signal to look for a rising edge
        always_ff @(posedge i_clk or negedge i_rst_n)
        if(!i_rst_n)    cfg_err_inj_r[i]    <=  1'b0;
        else            cfg_err_inj_r[i]    <=  cfg_err_inj[i];

        //Trigger error injection on rising edge
        assign  do_err_inj[i]   =   cfg_err_inj[i] & !cfg_err_inj_r[i];

        //Set err inj high for a given vlane set when the corresponding
        //cfg_err_inj signal is high
        always_ff @(posedge i_clk or negedge i_rst_n)
        if(!i_rst_n)    err_inj[i]  <=  1'b0;
        else            err_inj[i]  <=  do_err_inj[i]?  1'b1:
                                        !enable?        err_inj[i]:
                                        (cntr == i)?    1'b0:
                                                        err_inj[i];


    end:g_err_inj
    endgenerate






    //Pipeline the input data and am_insert signal so that they line up with
    //the alignment marker's output using the BIP
    generate
    for(genvar k=0;k<16;k++) begin
    new_cr2ev0_c2_ehip_pipeline #(
        .WIDTH      (66+1  ),
        .LATENCY    (1                                  )
    )
    input_register (
        .i_clk      (i_clk                              ),
        .i_rst_n    (i_rst_n                            ),
        .i_en       (enable                             ),
        .i_din      ({i_din[(66*(k+1))-1 : 66*k],i_am_insert}     ),
        .o_dout     ({din_r[(66*(k+1))-1 : 66*k],am_insert_r[k]}  )
    );
    end
    endgenerate


    //=========================================================================
    //Generate BIP values based on data between alignment markers

    //Calculate the bip.
    generate 
    for(genvar b=0;b<4;b++)
    new_cr2ev0_c2_ehip_bip_xor_5way #(    //[TODO] for 200G & 400G
        .USE_PIPE   (1'b0               )
    )
    u_bx (
        .i_clk      (i_clk              ),
        .i_rst_n    (i_rst_n            ),
        .i_en       (enable             ),
        .i_vl_cnt   (cntr               ),
        .i_restart  (am_insert_r[b]     ),
        .i_din      (din_r[66*(b+1)-1 :b*66]),
        .o_dout     (bip[8*(b+1)-1 : b*8]   )
    );
    endgenerate


    //=========================================================================
    //Generate Alignment Markers

    //The bytes in the raw marker table are from the published IEEE spec,
    //where they are published in the opposite bit and byte order from what is
    //required on the line. Here we change the order of the bits and bytes to
    //match how the AMs need to be transmitted
      generate 
          for (i=0; i<8*20; i=i+1) begin 
            assign marker_table_100g[(8*20-i)*8-1-:8] = marker_table_100g_raw[(i*8)+7:i*8];
	   end 
	  endgenerate	  
      generate
           for(i=0; i <8*4; i= i+1) begin
             assign marker_table_50g[(8*4-i)*8-1-:8] =  marker_table_50g_raw[(i*8)+7:i*8];   
	     end
      endgenerate	   
        generate
           for (i=0; i<8*4; i=i+1) begin
              assign marker_table_40g[(8*4-i)*8-1-:8] = marker_table_40g_raw[(i*8)+7:i*8] ; 
	      end
        endgenerate	   
        generate
            for (i=0; i<8*1; i=i+1) begin
              assign marker_table_25g[(8*1-i)*8-1-:8] = marker_table_25g_raw[(i*8)+7:i*8] ; 
	      end
        endgenerate

    generate 
      for(genvar l=0;l<8*15;l++)begin:reorder_am_table_200g
          assign marker_table_200g[(15*8-l)*8-1 -: 8] = marker_table_200g_raw[(l*8)+7 : l*8];
      end
    endgenerate
    generate 
      for(genvar k=0;k<15*16;k++)begin:reorder_am_table_400g
          assign marker_table_400g[(15*16-k)*8-1 -: 8] = marker_table_400g_raw[(k*8)+7 : k*8];
      end
    endgenerate

   assign marker_table = (i_speed == "_100G")? marker_table_100g:
                         (i_speed == "_50G")? marker_table_50g:
                         (i_speed == "_40G")? marker_table_40g:
			                     marker_table_25g;

   assign marker_table_200g_400g = (i_speed == "_200G") ? marker_table_200g:
                                   (i_speed == "_400G") ? marker_table_400g:
                                                    marker_table;

    //Use a counter to send out 5 consecutive sets of alignment markers. To
    //ensure that the first alignment markers that go out are 0 to 3, the
    //counter is set to its first position on the rising edge of i_am_insert

    //We set the terminal value of the mode based on whether we are processing
    //100G, 50G, or 40G data. In 100G mode, we use 4 lanes over 5 cycles; in
    //50G mode we use 2 lanes over 2 cycles, and in 40G mode, we use 4 lanes
    //over 1 cycle.
    //{muralasx} updating cntr_max for all speeds
    assign  cntr_max        =   (cntr == 5'd0  && i_speed == "_25G") || 
                                (cntr == 5'd2  &&  (i_speed == "_50G" || i_speed == "_40G" )) || //for 50G
                                (cntr == 5'd4  &&  i_speed == "_100G");                    // || //for 100G
                                //(cntr == 5'd8  &&  i_speed == "_200G")                     || //for 200G[TODO] FIXME 
                                //(cntr == 5'd16 &&  i_speed == "_400G")                     || //for 400G[TODO] FIXME
                                //(cntr == 5'd1  && i_speed != "_100G"  && i_cfg_half_width)||
                                //(cntr == 5'd0  && i_speed != "_100G"  && !i_cfg_half_width);

    always_ff @(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n)    cntr    <=  5'b0;
    else            cntr    <=  !enable?                            cntr:
                                (i_am_insert && !am_insert_r[0])?      5'b0:
                                cntr_max?                           5'b0:
                                                                    (cntr + 1'b1);

    //Register early_counter for 1 cycle so that it's aligned to am_insert_r


    //Select the alignment marker content based on counter and which set of
    //vlanes is assigned to this segment of the datapath, and turn the
    //64b of am content into a 66b control block
//
//{muralasx} assign marker table data based on speed to vlane_tag_full [TODO]
    generate
    for(genvar l=0;l<4;l++)begin
    assign  vlane_tag_full[66*(l+1)-1 : 66*l]  =   (cntr==5'd0)?   {marker_table[64*(l+0)+:64],2'b01}:
                                                    (cntr==5'd1)?   {marker_table[64*(l+4)+:64],2'b01}:
                                                    (cntr==5'd2)?   {marker_table[64*(l+8)+:64],2'b01}:
                                                    (cntr==5'd3)?   {marker_table[64*(l+12)+:64],2'b01}:
                                                    /* 3'd4*/       {marker_table[64*(l+16)+:64],2'b01};


    assign  vlane_tag_half[66*(l+1)-1 : 66*l]  =   (cntr==5'd0)?   {marker_table[64*(l+0)+:64],2'b01}:
                                                   (cntr==5'd1)?   {marker_table[64*(l+2)+:64],2'b01}:
                                                   (cntr==5'd2)?   {marker_table[64*(l+4)+:64],2'b01}:
                                                   (cntr==5'd3)?   {marker_table[64*(l+6)+:64],2'b01}:
                                                   /* 3'd4*/       {marker_table[64*(l+8)+:64],2'b01};

    assign  vlane_tag_const[66*(l+1)-1 : 66*l] =   i_cfg_half_width?   vlane_tag_half[66*(l+1)-1 :66*l]: vlane_tag_full[66*(l+1)-1 : 66*l];

    //Insert the bit interleaved parity (bip) into the appropriate positions
    //of the alignment maker
    assign vlane_tag[66*(l+1)-1 : 66*l] = vlane_tag_const[66*(l+1)-1 :66*l] | {~bip[8*(l+1)-1 : 8*l],24'b0,bip[8*(l+1)-1 : 8*l],24'b0,2'b0};

    assign  dout[66*(l+1)-1 : 66*l]    =   (am_insert_r[l] && !i_cfg_skip_tags)? vlane_tag[66*(l+1)-1 :66*l]: din_r[66*(l+1)-1 : 66*l];
    assign  dout_err_inj[66*(l+1)-1 : 66*l]    =   ((cntr==3'd0) &&  err_inj[0])?  (dout[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd1) &&  err_inj[1])?  (dout[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd2) &&  err_inj[2])?  (dout[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd3) &&  err_inj[3])?  (dout[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd4) &&  err_inj[4])?  (dout[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                                                   dout[66*(l+1)-1 : 66*l];
    new_cr2ev0_c2_ehip_pipeline #(
        //.WIDTH      ($bits(o_dout) + 1          ),
        //.LATENCY    (1                          )
        .WIDTH      (66 + 1          ),
        .LATENCY    (1                          )
    )
    output_register (
        .i_clk      (i_clk                      ),
        .i_rst_n    (i_rst_n                    ),
        .i_en       (enable                     ),
        .i_din      ({dout_err_inj[66*(l+1)-1 :66*l],am_insert_r[l]} ),
        .o_dout     ({o_dout_100g[66*(l+1)-1 : 66*l],o_dout_am_100g[l]}         )
    );
    end
    endgenerate
 
//--------------------------ports for 200g & 400g---------------------------
    logic   [1055:0]        vlane_tag_full_200g_400g; 
    logic   [1055:0]        vlane_tag_half_200g_400g;  
    logic   [1055:0]        vlane_tag_const_200g_400g;
    logic   [1055:0]        vlane_tag_200g_400g;       
    logic   [1055:0]        dout_200g_400g;       
    logic   [1055:0]        dout_err_inj_200g_400g;       

//--------------------------ports for 200g & 400g [end] --------------------------

    //=========================================================================
    //Pipeline output

    //When AM insert is high, select the vlane output. Otherwise, select the
    //scrambled encoded data.

    //When err_inj is high for a given counter value, corrupt the
    //corresponding block

    //Pipeline the data and the am_insert signal to go with it
   

    generate
    for(genvar l=0;l<16;l++)begin
    assign  vlane_tag_full_200g_400g[66*(l+1)-1 : 66*l]  =   (cntr==5'd0)?  {marker_table_200g_400g[64*(l+0)+:64],2'b01}:
                                                             (cntr==5'd1)?  {marker_table_200g_400g[64*(l+4)+:64],2'b01}:
                                                             (cntr==5'd2)?  {marker_table_200g_400g[64*(l+8)+:64],2'b01}:
                                                             (cntr==5'd3)?  {marker_table_200g_400g[64*(l+12)+:64],2'b01}:
                                                                            {marker_table_200g_400g[64*(l+16)+:64],2'b01};


    assign  vlane_tag_half_200g_400g[66*(l+1)-1 : 66*l]  =   (cntr==5'd0)?   {marker_table_200g_400g[64*(l+0)+:64],2'b01}:
                                                             (cntr==5'd1)?   {marker_table_200g_400g[64*(l+2)+:64],2'b01}:
                                                             (cntr==5'd2)?   {marker_table_200g_400g[64*(l+4)+:64],2'b01}:
                                                             (cntr==5'd3)?   {marker_table_200g_400g[64*(l+6)+:64],2'b01}:
                                                             /* 3'd4*/       {marker_table_200g_400g[64*(l+8)+:64],2'b01};


    assign  vlane_tag_const_200g_400g[66*(l+1)-1 : 66*l] =   i_cfg_half_width?   vlane_tag_half_200g_400g[66*(l+1)-1 :66*l]: vlane_tag_full_200g_400g[66*(l+1)-1 : 66*l];

    ////Insert the bit interleaved parity (bip) into the appropriate positions
    ////of the alignment maker
    assign vlane_tag_200g_400g[66*(l+1)-1 : 66*l] = vlane_tag_const_200g_400g[66*(l+1)-1 :66*l] | {~bip[8*(l+1)-1 : 8*l],24'b0,bip[8*(l+1)-1 : 8*l],24'b0,2'b0};

    assign  dout_200g_400g[66*(l+1)-1 : 66*l]    =   (am_insert_r[l] && !i_cfg_skip_tags)? vlane_tag_200g_400g[66*(l+1)-1 :66*l]: din_r[66*(l+1)-1 : 66*l];
    assign  dout_err_inj_200g_400g[66*(l+1)-1 : 66*l]    =   ((cntr==3'd0) &&  err_inj[0])?  (dout_200g_400g[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd1) &&  err_inj[1])?  (dout_200g_400g[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd2) &&  err_inj[2])?  (dout_200g_400g[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd3) &&  err_inj[3])?  (dout_200g_400g[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                   ((cntr==3'd4) &&  err_inj[4])?  (dout_200g_400g[66*(l+1)-1 : 66*l] ^ 66'd4):
                                                                                   dout_200g_400g[66*(l+1)-1 : 66*l];
    new_cr2ev0_c2_ehip_pipeline #(
        //.WIDTH      ($bits(o_dout) + 1          ),
        //.LATENCY    (1                          )
        .WIDTH      (66 + 1          ),
        .LATENCY    (1                          )
    )
    output_register_200g_400g (
        .i_clk      (i_clk                      ),
        .i_rst_n    (i_rst_n                    ),
        .i_en       (enable                     ),
        .i_din      ({dout_err_inj_200g_400g[66*(l+1)-1 :66*l],am_insert_r[l]} ),
        .o_dout     ({o_dout_200g_400g[66*(l+1)-1 : 66*l],o_dout_am_200g_400g[l]}         )
       // .o_dout     ({reg_out,reg_am}         )
    );
    end
    endgenerate
endmodule










