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

`ifndef GUARD_ETHERNET_MAC_USR_CONFIG_66B_SCRAMBLED_BLACK_CALLBACKS_SV 
 `define GUARD_ETHERNET_MAC_USR_CONFIG_66B_SCRAMBLED_BLACK_CALLBACKS_SV 

/** 
 * Abstract: 
 * This class ethernet_mac_sb_callbacks is derived from Ethernet Txrx 
 * callback class. This class is instantiated in class ethernet_env 
 * and is registered with the Ethernet MAC VIP class object. 
 * 
 */

class ethernet_usr_config_66b_scrambled_block_callbacks extends svt_ethernet_pcs_force_encoded_data_callback;

  int number;
  function new(string name = "cust_svt_ethernet_pcs_force_scrambled_data_callback");
    super.new(name);
    number = 0;
  endfunction

  virtual function void  svt_ethernet_sample_pcs_66b_unscrambled_data(svt_ethernet_pcs_force_encoded_data driver,reg[65:0] encoded_data,input int lane_number, input reg flag_lock);
  if(encoded_data[63:0]=='h9C0000100_00000000)
   $display("unscramble data :%h",encoded_data);
  endfunction

  virtual function void svt_ethernet_drive_pcs_66b_scrambled_data(svt_ethernet_pcs_force_encoded_data driver, ref reg[65:0] scrambled_data,input int lane_number);
//   $display("scramble data :%h",scrambled_data);
  endfunction
endclass 

`ifdef ETH_MULTI_PORT
class ethernet_usr_inject_callback extends svt_ethernet_multi_port_txrx_callback;

  bit enable_injection = 0 ;
  int err_inj_cnt = 0;
  bit [1:0] sync_hdr_type = 2'b11;
  function new(string name = "ethernet_usr_inject_callback"); 
     super.new();
   endfunction

  virtual function void svt_ethernet_txrx_usxgmii_drive_pcs_66b_encoded_data(svt_ethernet_multi_port_usxgmii_pcs_force_encoded_data driver, ref reg[65:0] encoded_data, input int lane_number);
    `uvm_info("inside callback",$sformatf("enable_injection : %0d and err_inj_cnt: %0d",enable_injection,err_inj_cnt),UVM_HIGH);
      
       if (enable_injection == 1 ) begin
         `uvm_info("inside callback","enable_injection is 1",UVM_HIGH);
         encoded_data[1:0] = sync_hdr_type;
	 err_inj_cnt = err_inj_cnt + 1 ;
         `uvm_info("inside callback",$sformatf("encoded_data: %0h",encoded_data),UVM_HIGH);
         `uvm_info("inside callback",$sformatf("err_inj_cnt: %0d",err_inj_cnt),UVM_HIGH);
       end 
  endfunction
endclass
`endif

class ethernet_mac_baser_66b_err_inject_callback extends svt_ethernet_txrx_callback;
 
  bit enable_injection = 0 ;
  int err_inj_cnt = 0;
  bit [1:0] sync_hdr_type = 2'b11;
   /* Constructor method for the callback class */ 
   function new(string name = "ethernet_mac_baser_66b_err_inject_callback"); 
     super.new();
   endfunction  
   
    
   virtual task svt_ethernet_txrx_baser_66b_encoded_scrambled_data_start ( svt_ethernet_txrx  driver, svt_ethernet_baser_66b_transaction   xact);

    svt_ethernet_baser_66b_transaction_exception_list cust_exception_list;
    svt_ethernet_baser_66b_transaction_exception      exception;
    static integer index=0;
      
       if (enable_injection == 1 ) begin
    
       /** Create the exception class */
       exception = new("cust_exception");

       /** Create the exception list */
       cust_exception_list = new("cust_exception_list",exception);

       /** Assign the type of error to be inserted in exception class */
       index++;
       /** Use packet index to control turning on and off of the error injection */
       //SNPS if (xact.packet_id == 328 ) begin
       exception.error_kind = svt_ethernet_baser_66b_transaction_exception::BASER_66B_INSERT_SYNC_HEADER;
       exception.baser_66b_insert_sync_header_error = sync_hdr_type;
       exception.exception_lane_number = 'hFFF;
       cust_exception_list.add_exception(exception);
       err_inj_cnt = err_inj_cnt + 1 ;
       /** Write the handle of the exception list on the trans class handle */
        xact.exception_list = cust_exception_list;
       `uvm_info("svt_ethernet_txrx_baser_66b_start", $sformatf("ERROR_FRAME INDEX =  %d user_index=%d ", xact.packet_id, index), UVM_LOW);
       xact.print();
        end 
   endtask : svt_ethernet_txrx_baser_66b_encoded_scrambled_data_start
 
 endclass : ethernet_mac_baser_66b_err_inject_callback 


 class ethernet_mac_basex_err_inject_callback extends svt_ethernet_txrx_callback;
 
  bit enable_injection = 0 ;
  int err_inj_cnt = 0;
  int i=0;
   /* Constructor method for the callback class */ 
   function new(string name = "ethernet_mac_basex_err_inject_callback"); 
     super.new();
   endfunction  
    
   virtual task svt_ethernet_txrx_basex_start ( svt_ethernet_txrx  driver, svt_ethernet_basex_transaction  xact);
    svt_ethernet_basex_transaction_exception_list cust_exception_list;
    svt_ethernet_basex_transaction_exception     exception;
    static integer index=0;
       if (enable_injection == 1 ) begin
       /** Create the exception class */
       exception = new("cust_exception");
       /** Create the exception list */
       cust_exception_list = new("cust_exception_list",exception);
       /** Assign the type of error to be inserted in exception class */
       if (xact.basex_codegroup[0] == 10'h245 || xact.basex_codegroup[0] == 10'h2b5 || xact.basex_codegroup[0] == 10'h1b5 || xact.basex_codegroup[0] == 10'h305 || xact.basex_codegroup[0] == 10'hcd || xact.basex_codegroup[0] == 10'hfa)
	   begin
	   /** Use packet index to control turning on and off of the error injection */
       exception.error_kind = svt_ethernet_basex_transaction_exception:: BASEX_1G_ERROR_KIND;
	   exception.basex_1g_error_kind = svt_ethernet_basex_transaction_exception:: BASEX_1G_ERR_INSERT_CHAR;
	   `uvm_info("svt_ethernet_txrx_basex_start", $sformatf("xact.basex_codegroup[0] is %h",xact.basex_codegroup[0]), UVM_MEDIUM);
	    for(i=0;i<4;i++)begin
        exception.basex_1g_err_insert_char_error[i] = ~(xact.basex_codegroup[i]);
	    `uvm_info("after svt_ethernet_txrx_basex_start", $sformatf("basex_1g_err_insert_char_error[%d] is  %h and xact.basex_codegroup[%d] is %h",i,exception.basex_1g_err_insert_char_error[i],i		,xact.basex_codegroup[i]), UVM_MEDIUM);
	    end
	   `uvm_info("svt_ethernet_txrx_basex_start", $sformatf("xact.basex_codegroup[0] is %h",xact.basex_codegroup[0]), UVM_MEDIUM);
	   end
       cust_exception_list.add_exception(exception);
	   err_inj_cnt = err_inj_cnt + 1 ;
       /** Write the handle of the exception list on the trans class handle */
        xact.exception_list = cust_exception_list;
       `uvm_info("svt_ethernet_txrx_basex_start", $sformatf("ERROR_FRAME INDEX =  %d user_index=%d ", xact.packet_id, index), UVM_LOW);
       xact.print();
        end 
   endtask : svt_ethernet_txrx_basex_start
 
 endclass : ethernet_mac_basex_err_inject_callback


 class ethernet_xxvsbi_lsbi_bip_corruption_callback extends svt_ethernet_txrx_callback;
    
   `uvm_object_utils(ethernet_xxvsbi_lsbi_bip_corruption_callback)
 
   bit enable_injection = 0 ;
   int err_inj_cnt = 0; 
 
   function new(string name = "ethernet_xxvsbi_lsbi_bip_corruption_callback");
     super.new(name);
   endfunction
 
   virtual task svt_ethernet_txrx_xxvsbi_lsbi_align_marker_start(svt_ethernet_txrx driver,ref svt_ethernet_xxvsbi_lsbi_align_marker_transaction xact);

     svt_ethernet_xxvsbi_lsbi_align_marker_transaction_exception exception;

     svt_ethernet_xxvsbi_lsbi_align_marker_transaction_exception_list exception_list;
 
     if (enable_injection == 1 ) begin   
       exception = new("exception");     
       exception_list = new ("exception_list", exception);   

       /** Configuring the Error kind to Align Marker Nibble Corruption */       
       exception.error_kind = svt_ethernet_xxvsbi_lsbi_align_marker_transaction_exception::XXVSBI_LSBI_CORRUPT_NIBBLE;       
        
       /** Configuring xxvsbi_lsbi_corrupt_am_location_error[0] as 1 indicates that nibbles will be corrupted for Lane 0 */
       exception.xxvsbi_lsbi_corrupt_am_location_error = {1'b1, 1'b1, 1'b1,1'b1};

       /** Configuring  xxvsbi_lsbi_corrupt_nibble_error[0] as 7 [16'b0000_0000_0000_0111] indicates that Nibbles 0/1/2  {Total of 3 nibbles } in the Align Marker Character for Lane 0 will be corrupted  */      
       /** Corrupting Nibbles 0/1/2 for AM's of all Lanes AM0/1/2/3 */      
       exception.xxvsbi_lsbi_corrupt_nibble_error =  {16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,16'b1100_0000_1100_0000};     //BIP Nibbles corruption 

       /** Write the handle of the exception list on the trans class handle */
       exception_list.add_exception(exception);      
       xact.exception_list = exception_list;     

       err_inj_cnt = err_inj_cnt + 1 ;
       `uvm_info("ethernet_xxvsbi_lsbi_bip_corruption_callback", $sformatf("Inserting AM error %d ", xact.packet_id), UVM_MEDIUM);
       xact.print(); 
     end
   endtask 
    
 endclass
 
 class ethernet_rs_fec_bip_corruption_callbacks extends svt_ethernet_txrx_callback;
   
   `uvm_object_utils(ethernet_rs_fec_bip_corruption_callbacks)
 
   bit enable_injection = 0 ;
   int err_inj_cnt = 0; 
    
   /* Constructor method for the callback class */    
   function new(string name = "ethernet_rs_fec_bip_corruption_callbacks");      
     super.new();   
   endfunction   
  
   /** Callback task for  RS align marker */  
   virtual task svt_ethernet_txrx_rs_fec_align_marker_start(svt_ethernet_txrx driver,svt_ethernet_rs_fec_align_marker_transaction xact);   

     svt_ethernet_rs_fec_align_marker_transaction_exception_list exception_list;  

     svt_ethernet_rs_fec_align_marker_transaction_exception      exception;       

     if (enable_injection == 1 ) begin   
       /** Create the exception class */    
       exception = new("exception"); 
       /** Create the exception list */ 
       exception_list = new("exception_list",exception);   

       exception.error_kind = svt_ethernet_rs_fec_align_marker_transaction_exception::RS_FEC_CORRUPT_AM;

       //Specifies rows/FEC Lane  which needs to be corrupted    
       exception.rs_fec_corrupt_am_location_error = { 1'b1 , 1'b1 , 1'b1 , 1'b1 };

       //Specifies rows/FEC Lane which needs to be corrupted
       exception.rs_fec_corrupt_am_error =64'd11_00_00_00_11_00_00_00;// Invalid AM value

       /** Write the handle of the exception list on the trans class handle */  
       exception_list.add_exception(exception);   
       xact.exception_list = exception_list;

       err_inj_cnt = err_inj_cnt + 1 ;
       `uvm_info("ethernet_rs_fec_bip_corruption_callbacks", $sformatf("Inserting AM error in RSFEC %d ", xact.packet_id), UVM_MEDIUM);
       xact.print();    
     end
   endtask : svt_ethernet_txrx_rs_fec_align_marker_start
 endclass :  ethernet_rs_fec_bip_corruption_callbacks
 
 class ethernet_400g_bip_corruption_callback extends svt_ethernet_txrx_callback;
    
   `uvm_object_utils(ethernet_400g_bip_corruption_callback)
 
   bit enable_injection = 0 ;
   int err_inj_cnt = 0; 
 
   function new(string name = "ethernet_400g_bip_corruption_callback");
     super.new(name);
   endfunction
 
   virtual task svt_ethernet_txrx_400g_pcs_align_marker_start(svt_ethernet_txrx driver,ref svt_ethernet_400g_pcs_align_marker_transaction xact);   
 
     svt_ethernet_400g_pcs_align_marker_transaction_exception_list exception_list;
     svt_ethernet_400g_pcs_align_marker_transaction_exception exception;
     
     if (enable_injection == 1 ) begin   
       exception = new("exception");     
       exception_list = new ("exception_list", exception);
   
       /** Configuring the Error kind to Align Marker Nibble Corruption */ 
       exception.error_kind = svt_ethernet_400g_pcs_align_marker_transaction_exception::PCS_CORRUPT_NIBBLE;
       exception.pcs_corrupt_am_lane = {1'b1 , 1'b1 , 1'b1 , 1'b1 , 
                                        1'b1 , 1'b1 , 1'b1 , 1'b1 , 
                                        1'b1 , 1'b1 , 1'b1 , 1'b1 , 
                                        1'b1 , 1'b1 , 1'b1 , 1'b1 };

       exception.pcs_corrupt_nibble_error = {16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000,
                                             16'b1100_0000_1100_0000,16'b1100_0000_1100_0000};

       exception_list.add_exception(exception);      /** Write the handle of the exception list on the trans class handle */
       xact.exception_list = exception_list;     

       err_inj_cnt = err_inj_cnt + 1 ;
       `uvm_info("ethernet_400g_bip_corruption_callback", $sformatf("Inserting AM error %d ", err_inj_cnt), UVM_MEDIUM);
       xact.print(); 
     end
 
   endtask : svt_ethernet_txrx_400g_pcs_align_marker_start
 endclass :ethernet_400g_bip_corruption_callback 

class ethernet_txrx_bip_corruption_callback extends svt_ethernet_txrx_callback;
    
   `uvm_object_utils(ethernet_txrx_bip_corruption_callback)
 
   bit enable_injection = 0 ;
   int err_inj_cnt = 0; 
 
   function new(string name = "ethernet_txrx_bip_corruption_callback");
     super.new(name);
   endfunction
 
   virtual task svt_ethernet_txrx_align_marker_start( svt_ethernet_txrx driver, svt_ethernet_align_marker_transaction xact) ;
 
     svt_ethernet_align_marker_transaction_exception_list exception_list;
     svt_ethernet_align_marker_transaction_exception exception;
     
     if (enable_injection == 1 ) begin   
       exception = new("exception");     
       exception_list = new ("exception_list", exception);
   
       /** Configuring the Error kind to Align Marker Nibble Corruption */ 
       exception.error_kind = svt_ethernet_align_marker_transaction_exception::ALIGN_MARKER_CORRUPT_BIP;
       //exception.align_marker_corrupt_bip_error = $random;
       exception.align_marker_corrupt_bip_error = 8'hA5;
       exception.exception_lane_number = 'hF_FFFF;

       exception_list.add_exception(exception);      /** Write the handle of the exception list on the trans class handle */
       xact.exception_list = exception_list;     

       err_inj_cnt = err_inj_cnt + 1 ;
       `uvm_info("ethernet_txrx_bip_corruption_callback", $sformatf("Inserting AM error %d ", xact.packet_id), UVM_MEDIUM);
       xact.print(); 
     end
 
   endtask : svt_ethernet_txrx_align_marker_start
 endclass :ethernet_txrx_bip_corruption_callback

 class ethernet_user_inject_callbacks extends svt_ethernet_txrx_callback;
 
  bit enable_injection = 0 ;
  int err_inj_cnt = 0;
  bit [4:0] sync_hdr_type = 5'b01111;
   /* Constructor method for the callback class */ 
   function new(string name = "ethernet_user_inject_callbacks"); 
     super.new();
   endfunction  
   
      
   virtual task svt_ethernet_txrx_ck_100g_1lane_transcode_start (svt_ethernet_txrx driver , ref svt_ethernet_ck_100g_1lane_transcode_transaction xact);

    svt_ethernet_ck_100g_1lane_transcode_transaction_exception_list  cust_exception_list;
    svt_ethernet_ck_100g_1lane_transcode_transaction_exception      exception;
    static integer index=0;
      
       if (enable_injection == 1 ) begin
    
       /** Create the exception class */
       exception = new("cust_exception");

       /** Create the exception list */
       cust_exception_list = new("cust_exception_list",exception);

       /** Assign the type of error to be inserted in exception class */
       index++;
       /** Use packet index to control turning on and off of the error injection */
       //SNPS if (xact.packet_id == 328 ) begin
       exception.error_kind = svt_ethernet_ck_100g_1lane_transcode_transaction_exception::CK_100G_1LANE_5BIT_IN_TRANSCODE_CORRUPT;
       exception.ck_100g_1lane_5bit_in_transcode_error = sync_hdr_type;
       cust_exception_list.add_exception(exception);
       err_inj_cnt = err_inj_cnt + 1 ;
       /** Write the handle of the exception list on the trans class handle */
        xact.exception_list = cust_exception_list;
       `uvm_info("svt_ethernet_txrx_ck_100g_1lane_transcode_start", $sformatf("ERROR_FRAME INDEX =  %d user_index=%d ", xact.packet_id, index), UVM_LOW);
       xact.print();
        end 
   endtask : svt_ethernet_txrx_ck_100g_1lane_transcode_start
 
 endclass : ethernet_user_inject_callbacks

`endif //GUARD_ETHERNET_MAC_USR_CONFIG_66B_SCRAMBLED_BLACK_CALLBACKS_SV 
`endif // ENABLE_ETH_VIP 
