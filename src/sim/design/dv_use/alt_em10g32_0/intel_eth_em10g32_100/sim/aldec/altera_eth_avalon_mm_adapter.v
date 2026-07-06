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


module altera_eth_avalon_mm_adapter
  (
    // Avalon Slave Interface
    input sl_clock,
    input sl_reset,    
    output [31:0] sl_csr_readdata_o,
    input [12:0]   sl_csr_address_i,
    input         sl_csr_read_i,
    input         sl_csr_write_i,
    input [31:0]  sl_csr_writedata_i,
    output        sl_csr_waitrequest_o,
   // Avalon Master Interface
    output ms_clock,
    output ms_reset,    
    input [31:0]  ms_csr_readdata_i,
    output [9:0] ms_csr_address_o,
    output        ms_csr_read_o,
    output        ms_csr_write_o,
    output [31:0] ms_csr_writedata_o,
    input         ms_csr_waitrequest_i
   ) ;

   // Have an internal address bus with full byte address so it is pretty
   reg [9:0]     new_byte_address ;
   
   // Many signals just piped through
   assign sl_csr_readdata_o = ms_csr_readdata_i ;
   assign sl_csr_waitrequest_o = ms_csr_waitrequest_i ;
   assign ms_csr_read_o = sl_csr_read_i ;
   assign ms_csr_write_o = sl_csr_write_i;
   assign ms_csr_writedata_o = sl_csr_writedata_i ;
   assign ms_clock = sl_clock ;
   assign ms_reset = sl_reset ;
   assign ms_csr_address_o = new_byte_address;   


   // Now map the addresses as desired
   always @ *
     begin
        casez (sl_csr_address_i[12:0])
         //TX CSR
          13'h1201:
            new_byte_address = 10'h010;
          13'h1202:
            new_byte_address = 10'h011;
          13'h1000:
            new_byte_address = 10'h020;
          13'h1001:
            new_byte_address = 10'h022;   
          13'h1040:
            new_byte_address = 10'h024; 
          13'h1080:
            new_byte_address = 10'h026;
          13'h1100:
            new_byte_address = 10'h028; 
          13'h1200:
            new_byte_address = 10'h02A;
          13'h1801:
            new_byte_address = 10'h02C;
          13'h1830:
            new_byte_address = 10'h02D;             
          13'h10C0:
            new_byte_address = 10'h03E;
          13'h10C1:
            new_byte_address = 10'h03F; 
          13'h1140:
            new_byte_address = 10'h040;  
          13'h1141:
            new_byte_address = 10'h042;
          13'h1142:
            new_byte_address = 10'h044;
          13'h11A0:
            new_byte_address = 10'h046; 
          13'h1180:
            new_byte_address = 10'h048;
          13'h1181:
            new_byte_address = 10'h049;
          13'h1182:
            new_byte_address = 10'h04A;
          13'h1183:
            new_byte_address = 10'h04B;
          13'h1184:
            new_byte_address = 10'h04C; 
          13'h1185:
            new_byte_address = 10'h04D;
          13'h1186:
            new_byte_address = 10'h04E; 
          13'h1187:
            new_byte_address = 10'h04F; 
          13'h1190:
            new_byte_address = 10'h058; 
          13'h1191:
            new_byte_address = 10'h059; 
          13'h1192:
            new_byte_address = 10'h05A;
          13'h1193:
            new_byte_address = 10'h05B; 
          13'h1194:
            new_byte_address = 10'h05C;
          13'h1195:
            new_byte_address = 10'h05D; 
          13'h1196:
            new_byte_address = 10'h05E;
          13'h1197:
            new_byte_address = 10'h05F;  
		  13'h1120:
			new_byte_address = 10'h070; 	

         // RX CSR
          13'h0000:
            new_byte_address = 10'h0A0;
          13'h0001:
            new_byte_address = 10'h0A2; 
          13'h0040:
            new_byte_address = 10'h0A4;   
          13'h0080:
            new_byte_address = 10'h0A6; 
          13'h0100:
            new_byte_address = 10'h0A8; 
          13'h0140:
            new_byte_address = 10'h0AA; 
          13'h0800:
            new_byte_address = 10'h0AC; 
          13'h0801:
            new_byte_address = 10'h0AE;
          13'h0830:
            new_byte_address = 10'h0AF;  
          13'h0802:
            new_byte_address = 10'h010;  //map to TX primary address 
          13'h0803:
            new_byte_address = 10'h011;  //map to TX primary address 
          13'h0804:
            new_byte_address = 10'h0B0;  
          13'h0805:
            new_byte_address = 10'h0B1;  
          13'h0806:
            new_byte_address = 10'h0B2;   
          13'h0807:
            new_byte_address = 10'h0B3; 
          13'h0808:
            new_byte_address = 10'h0B4; 
          13'h0809:
            new_byte_address = 10'h0B5;  
          13'h080A:
            new_byte_address = 10'h0B6; 
          13'h080B:
            new_byte_address = 10'h0B7;   
          13'h0818:
            new_byte_address = 10'h0C0; 
          13'h00C0:
            new_byte_address = 10'h0FC;
          13'h00C1:
            new_byte_address = 10'h0FD; 
          13'h00C2:
            new_byte_address = 10'h0FE; 
          13'h00C3:
            new_byte_address = 10'h0FF; 
          
          //New csr register in 32b MAC          
          13'h0819:
            new_byte_address = 10'h000;
          13'h081B:
            new_byte_address = 10'h002;   
          13'h081D:
            new_byte_address = 10'h043;    
          13'h081E:
            new_byte_address = 10'h02E;     
          13'h081F:
            new_byte_address = 10'h02F;
          13'h0820:
            new_byte_address = 10'h240; 
          13'h0821:
            new_byte_address = 10'h241;
          13'h08FE:
            new_byte_address = 10'h01E;  
          13'h08FF:
            new_byte_address = 10'h01F;               

         //TX Timestamp
          13'h1110:
            new_byte_address = 10'h100;  
          13'h1112:
            new_byte_address = 10'h102;
          13'h1113:
            new_byte_address = 10'h104; 
          13'h1118:
            new_byte_address = 10'h108; 
          13'h111A:
            new_byte_address = 10'h10A;
          13'h111B:
            new_byte_address = 10'h10C;
         // TX Asymmetry
          13'h111C:
            new_byte_address = 10'h110;
         // TX P2P
          13'h111D:
            new_byte_address = 10'h112;
         // TX CF Error Status
          13'h111E:
            new_byte_address = 10'h114;
         //RX Timestamp
          13'h0110:
            new_byte_address = 10'h120; 
          13'h0112:
            new_byte_address = 10'h122;
          13'h0113:
            new_byte_address = 10'h124; 
          13'h0118:
            new_byte_address = 10'h128; 
          13'h011A:
            new_byte_address = 10'h12A;
          13'h011B:
            new_byte_address = 10'h12C;
          //RX P2P
          13'h011C:
            new_byte_address = 10'h12E;
          13'h011D:
            new_byte_address = 10'h130;
          //Test Mode
          13'h1FF0:
            new_byte_address = 10'h3F0;

          //TX Statistic
          13'b1_1100_????_????:  //13'h1CXX
            new_byte_address = 10'h140+sl_csr_address_i[7:0];    

          //RX Statistic
          13'b0_1100_????_????:  //13'h0C??:
            new_byte_address = 10'h1C0+sl_csr_address_i[7:0];             
          default:
            begin
            // Shouldn't get here!
            new_byte_address = 10'h3FF;
            end
        endcase // case (sl_csr_address_i[8:6])
     end 
     
endmodule
   
          
   
