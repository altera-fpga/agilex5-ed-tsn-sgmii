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


`ifdef ENABLE_ETH_VIP

`ifndef GUARD_ETHERNET_MAC_SB_CALLBACKS_SV 
 `define GUARD_ETHERNET_MAC_SB_CALLBACKS_SV 

/** 
 * Abstract: 
 * This class ethernet_mac_sb_callbacks is derived from Ethernet Txrx 
 * callback class. This class is instantiated in class ethernet_env 
 * and is registered with the Ethernet MAC VIP class object. 
 * 
 */

 class ethernet_mac_sb_callbacks extends svt_ethernet_txrx_callback;
 
  svt_ethernet_link_transaction link_trans;
  bit enable_lt_seed_err;
  bit enable_lt_status_reg_err;
  bit enable_fcs_err;              //workaround to inject error
  bit enable_length_err;           //workaround to inject error
  bit enable_malformed_err;        //workaround to inject error
  bit enable_sfd_preamble_err;     //workaround to inject error
  bit enable_error_inside_err;     //workaround to inject error
  bit [10:0] local_init_seed;
  bit [9:0] lane_select;
  bit [2:0] polynomical_lane_id;
  bit [15:0] local_status_reg;
  bit [7:0]  bad_sfd;              //workaround to inject error
  bit [55:0] bad_preamble;         //workaround to inject error
  bit eth_malf_decoder_seq_lib;     //workaround to inject error

   /* Constructor method for the callback class */ 
   function new(string name = "ethernet_mac_sb_callbacks"); 
     super.new();
     this.link_trans = new();
   endfunction  
 
  /** Link Transaction callback task */
  virtual task svt_ethernet_txrx_link_transaction(svt_ethernet_txrx driver,ref svt_ethernet_link_transaction xact);

  //link_trans.an73_technology_ability_field = 'h1ff;// AN73_TECHNOLOGY_ABILITY_FIELD_100G_BASE_CR4;
  //link_trans.an73_link_fail_inhibit_timer = 4000000;
  //`ifndef CRETE3
  //  link_trans.an73_break_link_timer = 10000;
  //`endif
     xact =this.link_trans;
  /** This link_trans will get assigned with a user defined link transaction in the testcase file 
   * when non-default values are desired */

//     `uvm_info("svt_ethernet_txrx_link_transaction", $sformatf("MAC_CL37_LINK_XACTION"), UVM_LOW);
//     xact.print();
 endtask


 /** Frame Transaction callback task */
   virtual task svt_ethernet_txrx_post_get ( svt_ethernet_txrx    driver,
 					     svt_ethernet_transaction   xact);
     static integer index=0;
    
    svt_ethernet_transaction_exception_list cust_exception_list;
    svt_ethernet_transaction_exception exception;
 //   `uvm_info(get_name(), $sformatf("enable_lt_seed_err            :%0d ",enable_lt_seed_err), UVM_NONE);
 //   `uvm_info(get_name(), $sformatf("enable_lt_status_reg_err            :%0d ",enable_lt_status_reg_err), UVM_NONE);
   
    if(enable_lt_seed_err == 1'b1 || enable_lt_status_reg_err == 1'b1) 
    begin
        `uvm_info(get_name(), $sformatf("enable_lt_seed_err: %0d, enable_lt_status_reg_err: %0d",enable_lt_seed_err,enable_lt_status_reg_err), UVM_NONE);
    
        if(enable_lt_seed_err == 1'b1)
        begin
     //     `uvm_info(get_name(), $sformatf("lane_select                   :%0d ",lane_select), UVM_LOW);
    //      `uvm_info(get_name(), $sformatf("local_init_seed               :%0d ",local_init_seed), UVM_LOW);

          /** Create the exception class */
          exception = new("cust_exception");
          /** Create the exception list */
          cust_exception_list = new("cust_exception_list",exception);
  
          exception.error_kind = svt_ethernet_transaction_exception::AUTOADAPTATION_ERROR_KIND;
          exception.autoadaptation_error_kind= svt_ethernet_transaction_exception:: AUTOADAPTATION_CORRUPT_CL93_PRBS_FRAME_SEED;
          exception.autoadaptation_corrupt_cl93_prbs_frame_seed_error = local_init_seed;
          exception.exception_lane_number = lane_select;

          cust_exception_list.add_exception(exception);
          
          /** Write the handle of the exception list on the trans class handle */
          xact.exception_list = cust_exception_list;
        end

        if(enable_lt_status_reg_err == 1'b1) 
        begin
     //     `uvm_info(get_name(), $sformatf("lane_select                   :%0d ",lane_select), UVM_LOW);
    //      `uvm_info(get_name(), $sformatf("local_status_reg            :%0d ",local_status_reg), UVM_LOW);

          /** Create the exception class */
          exception = new("cust_exception");
          /** Create the exception list */
          cust_exception_list = new("cust_exception_list",exception);
  
          exception.error_kind = svt_ethernet_transaction_exception::AUTOADAPTATION_ERROR_KIND;
          exception.autoadaptation_error_kind= svt_ethernet_transaction_exception:: AUTOADAPTATION_CORRUPT_REPLACE_STATUS_REG;
      //    `uvm_info(get_name(), $sformatf("autoadaptation_corrupt_replace_status_reg_error                   :%0h ",exception.autoadaptation_corrupt_replace_status_reg_error), UVM_LOW);
          exception.autoadaptation_corrupt_replace_status_reg_error = local_status_reg;
    //      `uvm_info(get_name(), $sformatf("autoadaptation_corrupt_replace_status_reg_error                   :%0h ",exception.autoadaptation_corrupt_replace_status_reg_error), UVM_LOW);
          exception.exception_lane_number = lane_select;

          cust_exception_list.add_exception(exception);
          
          /** Write the handle of the exception list on the trans class handle */
          xact.exception_list = cust_exception_list;
          
       //   xact.print();

        end
   end

   
   else if(enable_fcs_err == 1)begin
               `uvm_info(get_name(), $sformatf("Inside enable_fcs_err"), UVM_NONE);
          
               index++;
               /** Create the exception class */
               exception = new("cust_exception");
               
               /** Create the exception list */
               cust_exception_list = new("cust_exception_list",exception);
               
               /** Assign the type of error to be inserted in exception class */
               exception.error_kind = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
               exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INCORRECT_FCS;
               exception.frame_incorrect_fcs_error = 32'h77778888;
               cust_exception_list.add_exception(exception);
               
               /** Write the handle of the exception list on the trans class handle */
               xact.exception_list = cust_exception_list;
               `uvm_info("svt_ethernet_txrx_post_get", $sformatf("ERROR_FRAME INDEX =  %d.", index), UVM_LOW);
               xact.print();
   end 
   
 // length error sent using "length_type == byte_count+range" , no need to workaround
 /*  else if(enable_length_err == 1)begin
               `uvm_info(get_name(), $sformatf("Inside enable_length_err"), UVM_NONE);

               index++;
               * Create the exception class /
               exception = new("cust_exception");

               * Create the exception list /
               cust_exception_list = new("cust_exception_list",exception);
			   
			   * Assign the type of error to be inserted in exception class /
               exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
               exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_LENGTH_TYPE_FIELD_CORRECT_FCS;
	           
               cust_exception_list.add_exception(exception);			   
	
               * Write the handle of the exception list on the trans class handle /
               xact.exception_list = cust_exception_list;
               `uvm_info("svt_ethernet_txrx_post_get", $sformatf("ERROR_FRAME INDEX =  %d.", index), UVM_LOW);
               xact.print();               
			   
   end */

   else if(enable_sfd_preamble_err == 1)begin
               `uvm_info(get_name(), $sformatf("Inside enable_sfd_preamble_err"), UVM_NONE);

               index++;
               /** Create the exception class */
               exception = new("cust_exception");

               /** Create the exception list */
               cust_exception_list = new("cust_exception_list",exception);
			   
			   /** Assign the type of error to be inserted in exception class */
                exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
                exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_SEND_INVALID_PREAMBLE_BITS;
                exception.frame_send_invalid_preamble_bits_error = bad_preamble;
                cust_exception_list.add_exception(exception);

	            exception.error_kind       = svt_ethernet_transaction_exception::FRAME_ERROR_KIND;
                exception.frame_error_kind = svt_ethernet_transaction_exception::FRAME_INVALID_SFD;
                exception.frame_invalid_sfd_error = bad_sfd;
                cust_exception_list.add_exception(exception);

               /** Write the handle of the exception list on the trans class handle */
               xact.exception_list = cust_exception_list;
               `uvm_info("svt_ethernet_txrx_post_get", $sformatf("ERROR_FRAME INDEX =  %d.", index), UVM_LOW);
               xact.print();               	   
   end
   
   else if(enable_malformed_err == 1)begin
 //              `uvm_info(get_name(), $sformatf("Inside enable_malformed_err"), UVM_NONE);

 //              index++;
 //              /** Create the exception class */
 //              exception = new("cust_exception");

 //              /** Create the exception list */
 //              cust_exception_list = new("cust_exception_list",exception);

 //              /** Assign the type of error to be inserted in exception class */
 //              exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
 //              exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_REPLACE_TERMINATE_CONTROL_CHAR;    
 //              exception.xgmii_replace_terminate_control_char_error = 9'h1_df;
 //              cust_exception_list.add_exception(exception);

 //              /** Write the handle of the exception list on the trans class handle */
 //              xact.exception_list = cust_exception_list;
 //              `uvm_info("svt_ethernet_txrx_post_get", $sformatf("ERROR_FRAME INDEX =  %d.", index), UVM_LOW);
 //              xact.print();               
   end

   else if(enable_error_inside_err == 1)begin
               `uvm_info(get_name(), $sformatf("Inside enable_error_inside_err"), UVM_NONE);

               index++;
               /** Create the exception class */
               exception = new("cust_exception");

               /** Create the exception list */
               cust_exception_list = new("cust_exception_list",exception);
			   
			   /** Assign the type of error to be inserted in exception class */
                exception.error_kind       = svt_ethernet_transaction_exception::CGMII_100G_ERROR_KIND;
                exception.xgmii_error_kind = svt_ethernet_transaction_exception::XGMII_INSERT_8BYTES_INBETWEEN_FRAME;
                exception.xgmii_insert_8bytes_inbetween_frame_error = 72'hfffefefefefefefefe;
                cust_exception_list.add_exception(exception);
				
               /** Write the handle of the exception list on the trans class handle */
               xact.exception_list = cust_exception_list;
               `uvm_info("svt_ethernet_txrx_post_get", $sformatf("ERROR_FRAME INDEX =  %d.", index), UVM_LOW);
               xact.print();               	   
   end
   
   else if(eth_malf_decoder_seq_lib == 1) begin
     //For sequences defined in eth_malf_decoder_seq_lib, exceptions are added from sequences so no need to add it here
   end
   else begin
     `uvm_info(get_name(), $sformatf(" xact.exception_list = null :%0d ",enable_lt_status_reg_err), UVM_NONE);
     /** Programming the Outgoing transaction exception to null */
     xact.exception_list = null ;
   end
   endtask : svt_ethernet_txrx_post_get
 
 endclass : ethernet_mac_sb_callbacks 


`endif //GUARD_ETHERNET_MAC_SB_CALLBACKS_SV 
`endif // ENABLE_ETH_VIP
 



