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


//=======================================================================
//
//  COPYRIGHT (C) 2012-2017 SYNOPSYS INC.
//  This software and the associated documentation are confidential and
//  proprietary to Synopsys, Inc. Your use or disclosure of this software
//  is subject to the terms and conditions of a written license agreement
//  between you, or your company, and Synopsys, Inc. In the event of
//  publications, the following notice is applicable:
//
//  ALL RIGHTS RESERVED
//
//  The entire notice above must be reproduced on all authorized copies.
//
//-----------------------------------------------------------------------
`ifdef ENABLE_ETH_VIP
`ifndef GUARD_ETHERNET_MAC_RS_FEC_ERR_ENCODER_CALLBACKS_SV 
 `define GUARD_ETHERNET_MAC_RS_FEC_ERR_ENCODER_CALLBACKS_SV 

/** 
 * Abstract: 
 * This class ethernet_mac_rs_fec_err_encoder_callbacks is derived from Ethernet Txrx 
 * callback class. This class is instantiated in class ethernet_env 
 * and is registered with the Ethernet MAC VIP class object. 
 *
 * This callback class inserts RS FEC encoder error 
 * In order to view the various members of transaction class ,set UVM_VERBOSITY TO UVM_HIGH  
 */

 class ethernet_mac_rs_fec_err_encoder_callbacks extends svt_ethernet_txrx_callback;

   bit [9:0] local_rs_fec_corrupt_encoder_160bits_error[16] = {10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0};
   bit local_160bits_error_pos[33]; 
   int approx_160b_count=0;
   bit error_injection_enable=0;
   event group_error_injection;
   bit enable_all_am_corruption = 0;
   int no_of_symbol_corrpt_cnt;
   int local_enc_blk_cnt=0;
   bit first_frame = 0;
   int num_cws_corrupted=0;

   /* Constructor method for the callback class */ 
   function new(string name = "ethernet_mac_rs_fec_err_encoder_callbacks"); 
     super.new();
     `uvm_info(get_name(), $sformatf("inside ethernet_mac_rs_fec_err_encoder_callbacks class "), UVM_NONE);
   endfunction  
 
   virtual task svt_ethernet_txrx_400g_pcs_rs_fec_encoded_start(svt_ethernet_txrx driver,ref svt_ethernet_400g_pcs_rs_fec_encoder_transaction xact);

     svt_ethernet_400g_pcs_rs_fec_encoder_transaction_exception exception ;
     svt_ethernet_400g_pcs_rs_fec_encoder_transaction_exception_list exception_list ;

     local_enc_blk_cnt = local_enc_blk_cnt + 1; 
     `uvm_info(get_name(), $sformatf("400G and 200G callback task related count local_enc_blk_cnt = %d", local_enc_blk_cnt), UVM_HIGH);

     if(error_injection_enable == 1'b1) begin
        `uvm_info(get_name(), $sformatf("MS_DBG: Inside RSFEC correction\n"),UVM_NONE);     
        exception = new("exception");
        exception_list = new("exception_list",exception);
        /** Insertion of Inverted RS Symbols*/
        exception.error_kind = svt_ethernet_400g_pcs_rs_fec_encoder_transaction_exception::PCS_RS_FEC_INVERT_SYMBOL;

        /** Randomizing the Number of errors inserted in RS FEC Encoder 0 and 1 between 1- 15 */
        //exception.number_of_symbols_corruption0 = $urandom_range(1,20);
        //exception.number_of_symbols_corruption1 = $urandom_range(1,20);
        exception.number_of_symbols_corruption0 = no_of_symbol_corrpt_cnt;
        exception.number_of_symbols_corruption1 = no_of_symbol_corrpt_cnt;

        `uvm_info("svt_ethernet_txrx_400g_pcs_rs_fec_encoded_start", $sformatf("Number of Corrupted RS Symbols for RS FEC Encoder 0 = %0d.",exception.number_of_symbols_corruption0), UVM_LOW);
        `uvm_info("svt_ethernet_txrx_400g_pcs_rs_fec_encoded_start", $sformatf("Number of Corrupted RS Symbols for RS FEC Encoder 1 = %0d.",exception.number_of_symbols_corruption1), UVM_LOW);
         
        /** Corrupting random RS FEC Symbols in each of RS FEC Encoder */
         exception.error_positions_encoder1 = new[exception.number_of_symbols_corruption1];
         exception.error_positions_encoder0 = new[exception.number_of_symbols_corruption0];

        /** Insertion of Corrupted RS FEC Symbols at random locations in RS FEC Encoder0 */
        foreach(exception.error_positions_encoder0[i])
           //exception.error_positions_encoder0[i]= $urandom_range(0,543);
           exception.error_positions_encoder0[i]= local_rs_fec_corrupt_encoder_160bits_error[i];

        /** Insertion of Corrupted RS FEC Symbols at random locations in RS FEC Encoder1 */
        foreach(exception.error_positions_encoder1[i])
           //exception.error_positions_encoder1[i]= $urandom_range(0,543);
           exception.error_positions_encoder1[i]= local_rs_fec_corrupt_encoder_160bits_error[i];

        exception_list.add_exception(exception);

        /** Write the handle of the exception list on the trans class handle */
        xact.exception_list = exception_list;
        xact.print();
           
         num_cws_corrupted = num_cws_corrupted + 1;
         `uvm_info("svt_ethernet_txrx_400g_pcs_rs_fec_encoded_start", $sformatf(" Number of CWs corrupted = %0d", num_cws_corrupted ),UVM_LOW);   
     end
     //To avoid corrupting RSFEC Align Markers
     if(local_enc_blk_cnt == 'd33 && first_frame == 1'b0) begin
      ->group_error_injection;
      `uvm_info("svt_ethernet_txrx_400g_pcs_rs_fec_encoded_start", $sformatf("local_enc_blk_cnt =%0d ",local_enc_blk_cnt), UVM_NONE);
      local_enc_blk_cnt = 'h0;
      first_frame = 1'b1;
    end else begin
      ->group_error_injection;
    end
endtask


  virtual task svt_ethernet_txrx_xxvsbi_lsbi_rs_fec_encoded_start(svt_ethernet_txrx driver,ref svt_ethernet_xxvsbi_lsbi_rs_fec_encoder_transaction xact);

    static integer encoder_index = 0;

    svt_ethernet_xxvsbi_lsbi_rs_fec_encoder_transaction_exception exception ;
    svt_ethernet_xxvsbi_lsbi_rs_fec_encoder_transaction_exception_list exception_list;

    approx_160b_count = approx_160b_count + 1;
    `uvm_info(get_name(), $sformatf("25G callback task related count approx_160b_count = %d", approx_160b_count), UVM_HIGH);

     if(error_injection_enable == 1'b1) begin
        exception = new("exception");
        exception_list = new("exception_list",exception);
        /** Configuring the error kind to invert the RS Symbols */
        exception.error_kind = svt_ethernet_xxvsbi_lsbi_rs_fec_encoder_transaction_exception::XXVSBI_LSBI_RS_FEC_INVERT_SYMBOL;

        //exception.number_of_symbols_corruption = $urandom_range(0,10);
        exception.number_of_symbols_corruption = no_of_symbol_corrpt_cnt ;
        exception.error_positions = new[exception.number_of_symbols_corruption];
        /** Insertion of Corrupted RS Symbols at random locations */
        foreach(exception.error_positions[i])
	      //exception.error_positions[i]= $urandom_range(0,527);
	       exception.error_positions[i]=  local_rs_fec_corrupt_encoder_160bits_error[i];

        exception_list.add_exception(exception);
        /** Write the handle of the exception list on the trans class handle */
        xact.exception_list = exception_list;
        xact.print();
        num_cws_corrupted = num_cws_corrupted + 1;
        `uvm_info("svt_ethernet_txrx_rs_fec_encoder_start", $sformatf(" Number of CWs corrupted = %0d", num_cws_corrupted ),UVM_LOW);   

     end
   
     if(approx_160b_count == 'd33 && first_frame == 0) begin
      ->group_error_injection;
      `uvm_info("svt_ethernet_txrx_xxvsbi_lsbi_rx_fec_encoded_start", $sformatf("approx_160b_count =%0d ",approx_160b_count), UVM_DEBUG);
      approx_160b_count = 'h0;
      first_frame = 1;
    end else begin
      ->group_error_injection;
    end
  endtask

   /** Callback task for  RS encoder */
   virtual task svt_ethernet_txrx_rs_fec_encoder_start(svt_ethernet_txrx driver,svt_ethernet_rs_fec_encoder_transaction xact);
    
    svt_ethernet_rs_fec_encoder_transaction_exception_list cust_exception_list;
    svt_ethernet_rs_fec_encoder_transaction_exception     exception;      
  
    approx_160b_count = approx_160b_count + 1;

   if(error_injection_enable == 1'b1  && local_160bits_error_pos[approx_160b_count - 1] == 1'b1 )
   begin

      /** Create the exception class */
      exception = new("cust_exception");

      /** Create the exception list */
      cust_exception_list = new("cust_exception_list",exception);

       exception.error_kind = svt_ethernet_rs_fec_encoder_transaction_exception::RS_FEC_CORRUPT_ENCODER_160BITS;
       
       foreach(exception.rs_fec_corrupt_encoder_160bits_error[i]) begin
       exception.rs_fec_corrupt_encoder_160bits_error[i] = local_rs_fec_corrupt_encoder_160bits_error[i];
       `uvm_info(get_name(), $sformatf("exception.rs_fec_corrupt_encoder_160bits_error[%0d] = %x.", i,exception.rs_fec_corrupt_encoder_160bits_error[i]), UVM_NONE);
       `uvm_info(get_name(), $sformatf("local_rs_fec_corrupt_encoder_160bits_error[%0d] = %x.", i,local_rs_fec_corrupt_encoder_160bits_error[i]), UVM_NONE);
       end

       cust_exception_list.add_exception(exception);
       //end
       `uvm_info("svt_ethernet_txrx_rs_fec_encoder_start", $sformatf("RS_FEC_160B_ENCODER_BLOCK =  %d.", xact.rs_fec_160b_encoder_block), UVM_NONE);
       
       /** Write the handle of the exception list on the trans class handle */
       xact.exception_list = cust_exception_list;
    
       /** For more detailed information use the xact.print () */
       
       xact.print();
       num_cws_corrupted = num_cws_corrupted + 1;
       `uvm_info("svt_ethernet_txrx_rs_fec_encoder_start", $sformatf(" Number of CWs corrupted = %0d", num_cws_corrupted ),UVM_LOW);   
    end
    
    
    if(approx_160b_count == 'd33)
    begin
      ->group_error_injection;
    `uvm_info("svt_ethernet_txrx_rs_fec_encoder_start", $sformatf("approx_160b_count =%0d ",approx_160b_count), UVM_DEBUG);
     approx_160b_count = 'h0;
    end
   endtask : svt_ethernet_txrx_rs_fec_encoder_start



  /** Callback task for align marker */
  virtual task svt_ethernet_txrx_rs_fec_align_marker_start(svt_ethernet_txrx driver,svt_ethernet_rs_fec_align_marker_transaction xact);
     static integer index1=0;
      svt_ethernet_rs_fec_align_marker_transaction_exception_list cust_exception_list;
       svt_ethernet_rs_fec_align_marker_transaction_exception exception;
 
    if(enable_all_am_corruption == 1'b1) 
    begin

     `uvm_info("svt_ethernet_txrx_rs_fec_align_marker_start", $sformatf("RS_FEC_AM_257B_TRANSCODE_BLOCK =  %h.", xact.rs_fec_am_257b_transcode_block), UVM_NONE);
       /** Create the exception class */
      exception = new("cust_exception");

  //    /** Create the exception list */
      cust_exception_list = new("cust_exception_list",exception);

       exception.error_kind = svt_ethernet_rs_fec_align_marker_transaction_exception::RS_FEC_CORRUPT_PCS_AM;
       
       exception.rs_fec_corrupt_pcs_am_location_error = {1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1};

       exception.rs_fec_corrupt_pcs_am_error[0] =  48'hde_97_3e_21_60_00;
       exception.rs_fec_corrupt_pcs_am_error[1] =  48'hde_97_3e_00_08_C1;
       exception.rs_fec_corrupt_pcs_am_error[2] =  48'hde_90_00_21_68_C1;
       exception.rs_fec_corrupt_pcs_am_error[3] =  48'h00_07_3e_21_68_C1;
       exception.rs_fec_corrupt_pcs_am_error[4] =  48'hf6_f8_0A_09_00_00;
       exception.rs_fec_corrupt_pcs_am_error[5] =  48'h3D_EB_22_00_04_dd;
       exception.rs_fec_corrupt_pcs_am_error[6] =  48'hD9_b0_00_26_4A_9A;
       exception.rs_fec_corrupt_pcs_am_error[7] =  48'h00_0A_84_66_45_7B;
       exception.rs_fec_corrupt_pcs_am_error[8] =  48'h00_0B_5F_76_24_A0;
       exception.rs_fec_corrupt_pcs_am_error[9] =  48'h04_30_00_FB_C9_68;
       exception.rs_fec_corrupt_pcs_am_error[10] =  48'h66_93_02_00_0C_FD;
       exception.rs_fec_corrupt_pcs_am_error[11] =  48'hAA_6E_46_55_90_00;
       exception.rs_fec_corrupt_pcs_am_error[12] =  48'h4D_46_A3_B2_B0_00;
       exception.rs_fec_corrupt_pcs_am_error[13] =  48'h42_07_E5_00_08_1A;
       exception.rs_fec_corrupt_pcs_am_error[14] =  48'h35_30_00_CA_C7_83;
       exception.rs_fec_corrupt_pcs_am_error[15] =  48'h00_09_CA_CD_36_35;
       exception.rs_fec_corrupt_pcs_am_error[16] =  48'hB3_CE_3B_4C_30_00;
       exception.rs_fec_corrupt_pcs_am_error[17] =  48'hB3_CE_3B_00_01_C4;
       exception.rs_fec_corrupt_pcs_am_error[18] =  48'hB3_C0_00_4C_31_C4;
       exception.rs_fec_corrupt_pcs_am_error[19] =  48'h00_0E_3B_4C_31_C4;

       cust_exception_list.add_exception(exception);
       
       /** Write the handle of the exception list on the trans class handle */
       xact.exception_list = cust_exception_list;

     index1++;
   //  xact.print();
     `uvm_info("svt_ethernet_txrx_rs_fec_align_marker_start", $sformatf("ALIGN_MARKER_TRANSACTION INDEX1 =  %d.", index1), UVM_HIGH);
    end
   endtask : svt_ethernet_txrx_rs_fec_align_marker_start


endclass : ethernet_mac_rs_fec_err_encoder_callbacks 

`endif //GUARD_ETHERNET_MAC_RS_FEC_ERR_ENCODER_CALLBACKS_SV 
`endif //`ifdef ENABLE_ETH_VIP 
