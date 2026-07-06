// ############################################################################################
// intel_start_of_header
//
// INTEL CONFIDENTIAL
// Copyright 2018 Intel Corporation
//
// The source code contained or described herein and all documents related
// to the source code ("Material") are owned by Intel Corporation or
// its suppliers or licensors. Title to the Material remains with Intel
// Corporation or its suppliers and licensors. The Material contains trade
// secrets and proprietary and confidential information of Intel or its
// suppliers and licensors. The Material is protected by worldwide copyright
// and trade secret laws and treaty provisions. No part of the Material
// may be used, copied, reproduced, modified, published, uploaded, posted,
// transmitted, distributed, or disclosed in any way without Intel's prior
// express written permission.
//
// No license under any patent, copyright, trade secret or other intellectual
// property right is granted to or conferred upon you by disclosure or
// delivery of the Materials, either expressly, by implication, inducement,
// estoppel or otherwise. Any license under such intellectual property
// rights must be express and approved by Intel in writing.
//
// intel_end_of_header
// ############################################################################################
//--------------------------------------------------------------------------------------------
// Description: ipbb_asyn_to_syn_rst
// 
// Converts asynchronous reset to synchronous reset.
//
//--------------------------------------------------------------------------------------------

module ipbb_asyn_to_syn_rst
    (input  var clk
     ,input var logic asyn_rst

     ,output var logic syn_rst

     );


    logic asyn_rst_c1, asyn_rst_c2;
    
    always @(posedge clk or posedge asyn_rst) begin
	if (asyn_rst) begin
	    asyn_rst_c1 <= 'd1;
	    asyn_rst_c2 <= 'd1;
	    syn_rst     <= 'd1;
	end // if (asyn_rst)
	else begin
	    asyn_rst_c1 <= 'd0;
	
	    asyn_rst_c2 <= asyn_rst_c1;
	
	    syn_rst <= asyn_rst_c2;
	end	
    end

endmodule




	
