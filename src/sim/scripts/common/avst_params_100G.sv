parameter USE_PACKET_100G  = 1;
parameter USE_CHANNEL_100G = 0;
parameter USE_ERROR_100G   = 1;
parameter USE_READY_100G   = 1;
parameter USE_VALID_100G   = 1;
parameter USE_EMPTY_100G   = 1;
parameter  ST_SYMBOL_W_100G   =          8;
parameter  ST_NUMSYMBOLS_100G =          64;
parameter  ST_ERROR_W_100G    =           6;
parameter  ST_EMPTY_W_100G    =           6;
parameter  ST_BEATSPERCYCLE_100G =1 ;                                                  
parameter  ST_CHANNEL_W_100G =0;
parameter  ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_100G=1;
parameter  ST_MAX_CHANNELS_100G=1;                                                  
parameter  ST_MAX_PACKET_SIZE_100G =1000;                                                  
`ifdef RDY_LAT
parameter  ST_READY_LATENCY_100G=`RDY_LAT;                                               
`else
parameter  ST_READY_LATENCY_100G=0;                                               
`endif

`define ALTUVM_AVALON_ST_INF_TB_PARAM_INST_100G \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_100G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_100G), \
   .ST_ERROR_W                               (ST_ERROR_W_100G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_100G), \
   .USE_CHANNEL                              (USE_CHANNEL_100G), \
   .USE_EMPTY                                (USE_EMPTY_100G), \
   .USE_ERROR                                (USE_ERROR_100G), \
   .USE_PACKET                               (USE_PACKET_100G), \
   .USE_READY                                (USE_READY_100G), \
   .USE_VALID                                (USE_VALID_100G)

`define ALTUVM_AVALON_ST_RTB_TB_PARAM_INST_100G \
   .ST_BEATSPERCYCLE                         (ST_BEATSPERCYCLE_100G), \
   .ST_CHANNEL_W                             (ST_CHANNEL_W_100G), \
   .ST_EMPTY_W                               (ST_EMPTY_W_100G), \
   .ST_ERROR_W                               (ST_ERROR_W_100G), \
   .ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS       (ST_FIRST_SYMBOL_IN_HIGH_ORDER_BITS_100G), \
   .ST_MAX_CHANNELS                          (ST_MAX_CHANNELS_100G), \
   .ST_MAX_PACKET_SIZE                       (ST_MAX_PACKET_SIZE_100G), \
   .ST_NUMSYMBOLS                            (ST_NUMSYMBOLS_100G), \
   .ST_READY_LATENCY                         (ST_READY_LATENCY_100G), \
   .USE_CHANNEL                              (USE_CHANNEL_100G), \
   .USE_EMPTY                                (USE_EMPTY_100G), \
   .USE_ERROR                                (USE_ERROR_100G), \
   .USE_PACKET                               (USE_PACKET_100G), \
   .USE_READY                                (USE_READY_100G), \
   .USE_VALID                                (USE_VALID_100G)
