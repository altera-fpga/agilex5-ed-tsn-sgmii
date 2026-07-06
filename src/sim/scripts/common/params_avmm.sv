parameter AV_ADDRESS_W 				= 14; 
parameter AV_BURSTCOUNT_W			= 1; 
parameter AV_BURST_BNDR_ONLY			= 0;
parameter AV_BURST_LINEWRAP			= 0;
parameter AV_CONSTANT_BURST_BEHAVIOR  		= 1;     
parameter AV_FIX_READ_LATENCY       	        = 0;     
parameter AV_MAX_CONTINUOUS_READ      		= 5;     
parameter AV_MAX_CONTINUOUS_READDATAVALID	= 5;  
parameter AV_MAX_CONTINUOUS_WAITREQUEST 	= 5;   
parameter AV_MAX_CONTINUOUS_WRITE 	   	= 5;      
parameter AV_MAX_PENDING_READS  	        = 0;       
parameter AV_MAX_PENDING_WRITES     		= 0;       
parameter AV_MAX_READ_LATENCY       		= 100;       
parameter AV_MAX_WAITREQUESTED_READ 		= 100;       
parameter AV_MAX_WAITREQUESTED_WRITE		= 100;       
parameter AV_NUMSYMBOLS            		= 4;        
parameter AV_READRESPONSE_W       		= 8;         
parameter AV_READ_TIMEOUT         		= 100;         
parameter AV_READ_WAIT_TIME       		= 0;         
parameter AV_REGISTERINCOMINGSIGNALS 		= 0;      
parameter AV_SYMBOL_W             		= 8;         
parameter AV_WAITREQUEST_TIMEOUT 		= 1024;          
parameter AV_WRITERESPONSE_W     		= 8;          
parameter AV_WRITE_TIMEOUT       		= 100;          
parameter AV_WRITE_WAIT_TIME     		= 0;         
`ifdef G100
parameter MASTER_ADDRESS_TYPE    		= 23460611426831443;
`elsif G10_25
parameter MASTER_ADDRESS_TYPE    		= 23460611;
`endif
parameter REGISTER_WAITREQUEST   		= 0;          
`ifdef G100
parameter SLAVE_ADDRESS_TYPE     		= 374992946259;          
`elsif G10_25
parameter SLAVE_ADDRESS_TYPE     		= 3749929;
`endif
`ifdef FAST_CLK
  `ifdef PTP_EN
    parameter CLOCK_PERIOD = 10000;
  `else
    `ifdef ETH_BASERS10
      parameter CLOCK_PERIOD = 6400;
    `elsif ETH_BASERS10_ARRIA
      parameter CLOCK_PERIOD = 6400;
    `elsif ETH_NF_10G
       parameter CLOCK_PERIOD = 6400;
     `elsif ETH_NF_1G
      parameter CLOCK_PERIOD = 6400;
     `elsif ETH_SM_MGBASET
      parameter CLOCK_PERIOD = 10000;
     `else
      parameter CLOCK_PERIOD = 8000;
    `endif
  `endif
`else
    parameter CLOCK_PERIOD = 10000;
`endif
parameter STORE_COMMAND         		= 0;           
parameter STORE_RESPONSE        		= 0;           
parameter USE_ADDRESS          			= 1;            
parameter USE_ARBITERLOCK       		= 0;           
parameter USE_BEGIN_BURST_TRANSFER 		= 0;        
parameter USE_BEGIN_TRANSFER    		= 0;           
parameter USE_BURSTCOUNT       			= 0;            
parameter USE_BYTE_ENABLE     			= 1;             //changed my mehul
parameter USE_CLKEN          			= 0;             
parameter USE_DEBUGACCESS     			= 0;             
parameter USE_LOCK           			= 0;              
parameter USE_READ           			= 1;              
parameter USE_READRESPONSE   			= 0;              
parameter USE_READ_DATA      			= 1;              
parameter USE_READ_DATA_VALID 			= 1;             
parameter USE_TRANSACTIONID   			= 0;             
parameter USE_WAIT_REQUEST   			= 1;             
parameter USE_WRITE           			= 1;             
parameter USE_WRITERESPONSE   			= 0;             
parameter USE_WRITE_DATA     			= 1;             

// Define macro :
// This define macro overrides the Avalon MM rtb and interface parameters
// Note : AV_SYMBOL_W and AV_NUMSYMBOLS need to confirm with UVC Owner.
`define AVMM_CFG_SHARED_INF_INST \
   .AV_ADDRESS_W              (18),\
   .AV_SYMBOL_W               (8),\
   .AV_NUMSYMBOLS             (4),\
   .USE_READ                  (1),\
   .USE_WRITE                 (1),\
   .USE_ADDRESS               (1),\
   .USE_BYTE_ENABLE           (1),\
   .USE_BURSTCOUNT            (0),\
   .USE_READ_DATA             (1),\
   .USE_READ_DATA_VALID       (0),\
   .USE_WRITE_DATA            (1),\
   .USE_BEGIN_TRANSFER        (0),\
   .USE_BEGIN_BURST_TRANSFER  (0),\
   .USE_WAIT_REQUEST          (1),\
   .USE_ARBITERLOCK           (0),\
   .USE_LOCK                  (0),\
   .USE_DEBUGACCESS           (0),\
   .USE_TRANSACTIONID         (0),\
   .USE_WRITERESPONSE         (0),\
   .USE_READRESPONSE          (0),\
   .USE_CLKEN                 (0)


   // Define macro :
// This define macro overrides the Avalon MM rtb and interface parameters
// Note : AV_SYMBOL_W and AV_NUMSYMBOLS need to confirm with UVC Owner.
`define AVMM_RSFEC_CFG_SHARED_INF_INST \
   .AV_ADDRESS_W              (18),\
   .AV_SYMBOL_W               (8),\
   .AV_NUMSYMBOLS             (4),\
   .USE_READ                  (1),\
   .USE_WRITE                 (1),\
   .USE_ADDRESS               (1),\
   .USE_BYTE_ENABLE           (1),\
   .USE_BURSTCOUNT            (0),\
   .USE_READ_DATA             (1),\
   .USE_READ_DATA_VALID       (0),\
   .USE_WRITE_DATA            (1),\
   .USE_BEGIN_TRANSFER        (0),\
   .USE_BEGIN_BURST_TRANSFER  (0),\
   .USE_WAIT_REQUEST          (1),\
   .USE_ARBITERLOCK           (0),\
   .USE_LOCK                  (0),\
   .USE_DEBUGACCESS           (0),\
   .USE_TRANSACTIONID         (0),\
   .USE_WRITERESPONSE         (0),\
   .USE_READRESPONSE          (0),\
   .USE_CLKEN                 (0)


   // Define macro :
// This define macro overrides the Avalon MM rtb and interface parameters
// Note : AV_SYMBOL_W and AV_NUMSYMBOLS need to confirm with UVC Owner.
`define AVMM_XCVR_CFG_SHARED_INF_INST \
   .AV_ADDRESS_W              (20),\
   .AV_SYMBOL_W               (8),\
   .AV_NUMSYMBOLS             (4),\
   .USE_READ                  (1),\
   .USE_WRITE                 (1),\
   .USE_ADDRESS               (1),\
   .USE_BYTE_ENABLE           (1),\
   .USE_BURSTCOUNT            (0),\
   .USE_READ_DATA             (1),\
   .USE_READ_DATA_VALID       (0),\
   .USE_WRITE_DATA            (1),\
   .USE_BEGIN_TRANSFER        (0),\
   .USE_BEGIN_BURST_TRANSFER  (0),\
   .USE_WAIT_REQUEST          (1),\
   .USE_ARBITERLOCK           (0),\
   .USE_LOCK                  (0),\
   .USE_DEBUGACCESS           (0),\
   .USE_TRANSACTIONID         (0),\
   .USE_WRITERESPONSE         (0),\
   .USE_READRESPONSE          (0),\
   .USE_CLKEN                 (0)


// Define macro : USE_READ_DATA_VALID = 1
// This define macro overrides the Avalon MM rtb and interface parameters
// Note : AV_SYMBOL_W and AV_NUMSYMBOLS need to confirm with UVC Owner.
`define AVMM_XCVR_CFG_SHARED_INF_INST1 \
   .AV_ADDRESS_W              (20),\
   .AV_SYMBOL_W               (8),\
   .AV_NUMSYMBOLS             (4),\
   .USE_READ                  (1),\
   .USE_WRITE                 (1),\
   .USE_ADDRESS               (1),\
   .USE_BYTE_ENABLE           (1),\
   .USE_BURSTCOUNT            (0),\
   .USE_READ_DATA             (1),\
   .USE_READ_DATA_VALID       (0),\
   .USE_WRITE_DATA            (1),\
   .USE_BEGIN_TRANSFER        (0),\
   .USE_BEGIN_BURST_TRANSFER  (0),\
   .USE_WAIT_REQUEST          (1),\
   .USE_ARBITERLOCK           (0),\
   .USE_LOCK                  (0),\
   .USE_DEBUGACCESS           (0),\
   .USE_TRANSACTIONID         (0),\
   .USE_WRITERESPONSE         (0),\
   .USE_READRESPONSE          (0),\
   .USE_CLKEN                 (0)
